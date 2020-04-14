package t4u.distributionlogistics;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.common.ApplicationListener;
import t4u.functions.DistributionLogisticsFunctions;
import t4u.functions.IronMiningFunction;

public class IndentDetailsExcelImport {

	Map<String, Integer> hubMap = new HashMap<String,Integer>();
	IronMiningFunction miningFunction = new IronMiningFunction();
	DistributionLogisticsFunctions logisticsFunction = new DistributionLogisticsFunctions();

	private Set<String> nodeNamesExcel = new HashSet<String>();
	private List<String> vehicleTypesFromDB = new ArrayList<String>();
	private List<String> makesFromDB = new ArrayList<String>();
	Map<String, Integer> nodeToDedicatedCountExcel = new HashMap<String, Integer>();
	Map<String, Integer> nodeToAdhocCountExcel = new HashMap<String, Integer>();
	public static final Integer EXCEL_UPLOAD_LIMIT = 100;
	SimpleDateFormat PLACEMNT_TIME_DATE_FORMAT = new SimpleDateFormat("HH:mm");
	
	String PLCEMENT_TIME_REGEX_PATTERN = "^([01]\\d|2[0-3]):?([0-5]\\d)$";
	
	List<IndentVehicleDetailsData> validIndentVehicleDetails = new ArrayList<IndentVehicleDetailsData>();
	
	public List<IndentVehicleDetailsData> getValidIndentVehicleDetails() {
		return validIndentVehicleDetails;
	}

	public void setValidIndentVehicleDetails(
			List<IndentVehicleDetailsData> validIndentVehicleDetails) {
		this.validIndentVehicleDetails = validIndentVehicleDetails;
	}

	public JSONObject importExcelData(String inFile, int userId, int systemId,int clientId,int customerId,String zone) throws JSONException {
		//Get hubs and put in map
		String fileExtension = inFile.substring(inFile.lastIndexOf("."), inFile.length());
		List<IndentVehicleDetailsData> indentDetailsListAll = new ArrayList<IndentVehicleDetailsData>();
		getHubsMap(clientId,systemId,userId,zone);
		getVehicleTypesFromDB(systemId,userId);
		getMakesFromDB(systemId, clientId);
		
		try {
			if (fileExtension.equals(".xls")) {
				InputStream excelFileToRead = new FileInputStream(inFile);
				HSSFWorkbook wb = new HSSFWorkbook(excelFileToRead);
				HSSFSheet sheet = wb.getSheetAt(0);
				if(sheet.getPhysicalNumberOfRows() > EXCEL_UPLOAD_LIMIT){
					JSONObject resultObj = new JSONObject();
					resultObj.append("error", "Number of rows exceeds the supported upload limit"+EXCEL_UPLOAD_LIMIT);
					return resultObj;
				}
				indentDetailsListAll = readDataFromXls(sheet);
			} else if (fileExtension.equals(".xlsx")) {
				InputStream excelFileToRead = new FileInputStream(inFile);
				XSSFWorkbook wb = new XSSFWorkbook(excelFileToRead);
				XSSFSheet sheet = wb.getSheetAt(0);
				if(sheet.getPhysicalNumberOfRows() > EXCEL_UPLOAD_LIMIT){
					JSONObject resultObj = new JSONObject();
					resultObj.append("error", "Number of rows exceeds the supported upload limit"+EXCEL_UPLOAD_LIMIT);
					return resultObj;
				}
				indentDetailsListAll = readDataFromXlsx(sheet);
			}
			
			Map<String, IndentVehiclesCount> nodeToVehicleCountFromDB = logisticsFunction.getIndentVehiclesCount(nodeNamesExcel, systemId, clientId, Integer.valueOf(customerId).toString());
			Map<String,List<IndentVehicleDetailsData>> nodeToIndentVehicleDetailsMap = convertListToNodeToListMap(indentDetailsListAll);
			validateRecordMap(nodeToIndentVehicleDetailsMap,nodeToVehicleCountFromDB);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return convertIndentListToJsonArray(indentDetailsListAll);
	}
	
	private void getMakesFromDB(int systemId, int clientId) throws JSONException{
		JSONArray array = logisticsFunction.getMakes(systemId, clientId);
		for(int i=0; i <array.length();i++){
			JSONObject obj = (JSONObject)array.get(i);
			if(obj.get("make") != null)
				makesFromDB.add(obj.get("make").toString());
		}
	}
	
	private void getVehicleTypesFromDB(int systemId, int userId) throws JSONException{
		JSONArray array = logisticsFunction.getAssetTypeDetails(systemId, userId);
		for(int i=0; i <array.length();i++){
			JSONObject obj = (JSONObject)array.get(i);
			if(obj.get("AssetType") != null)
				vehicleTypesFromDB.add(obj.get("AssetType").toString());
		}
	}
	
	public void getHubsMap(int clientId, int systemId,int userId,String zone) throws JSONException{
		JSONArray hubArray = logisticsFunction.getAllHubs(clientId, systemId, zone, userId);
		JSONObject obj;
		for(int i=0; i <hubArray.length();i++){
			obj = (JSONObject)hubArray.get(i);
			if(obj.get("hubId") != null && obj.get("hubName") != null)
				hubMap.put((String) obj.get("hubName"),Integer.parseInt((String)obj.get("hubId"))); 
		}
	}

	public JSONObject convertIndentListToJsonArray(List<IndentVehicleDetailsData> totalRecordsList) throws JSONException {
		
		JSONObject resultObj = new JSONObject();
		JSONArray indentJsonArray = null;
		JSONObject indentDataJsonObject = null;
		int count = 0;
		try {
			indentJsonArray = new JSONArray();
			indentDataJsonObject = new JSONObject();
			for (IndentVehicleDetailsData indentData : totalRecordsList) {
				count++;
				indentDataJsonObject = new JSONObject();
				indentDataJsonObject.put("slNo", count);
				indentDataJsonObject.put("node", indentData.getNode());
				indentDataJsonObject.put("vehicleType", indentData.getVehicleType());
				indentDataJsonObject.put("make",indentData.getMake());
				indentDataJsonObject.put("dedicatedOrAdhoc", indentData.getDedicatedOrAdhoc());
				indentDataJsonObject.put("noOfVehicles",indentData.getNoOfVehicles());
				indentDataJsonObject.put("placementTime",indentData.getPlacementTime());
				indentDataJsonObject.put("recordStatus",(indentData.isValid()? "Valid" : "Invalid"));
				indentDataJsonObject.put("errors", formatError(indentData.getErrors()));
//				if(!indentData.isValid()){
//					indentDataJsonObject.put("errorsBtn", "<button type='button' class='btn btn-info btn-sm text-center'>Show errors</button>");
//				}else{
//					indentDataJsonObject.put("errorsBtn", "<div></div>");
//				}
				indentDataJsonObject.put("valid", indentData.isValid());
				indentJsonArray.put(indentDataJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		resultObj.put("importIndentDetailsRoot", indentJsonArray);
		resultObj.put("TotalRecords", totalRecordsList.size());
		resultObj.put("ValidRecord", validIndentVehicleDetails.size());
		return resultObj;
	}
	
	private String formatError(List<String> errors){
		StringBuffer sb = new StringBuffer();
		int slNo=1;
		for(String error : errors){
			sb.append(slNo+". ");
			sb.append(error);
			sb.append("<br>");
			slNo++;
		}
		
		return sb.toString();
	}
	
	private String getHSSCellValue(HSSFCell cell) {
		String cellValue = "";
		if (cell != null) {
			if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
				cellValue = cell.getStringCellValue();
			else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
				cell.setCellType(HSSFCell.CELL_TYPE_STRING);
				cellValue = cell.getStringCellValue();
			} else {
//				format = "Invalid";
			}
		} else {
			cellValue = "";
		}
		return cellValue;
	}

	private String getXSSCellValue(XSSFCell cell) {
		String cellValue = "";
		if (cell != null) {
			
			if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
				cellValue = cell.getStringCellValue();
			else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
				cell.setCellType(XSSFCell.CELL_TYPE_STRING);
				cellValue = cell.getStringCellValue();
			} else {
//				format = "Invalid";
			}
		} else {
			cellValue = "";
		}
		return cellValue;
	}

	private List<IndentVehicleDetailsData> readDataFromXls(HSSFSheet sheet) {
		List<IndentVehicleDetailsData> list = new ArrayList<IndentVehicleDetailsData>();
		IndentVehicleDetailsData indentData = null;
		try {
			HSSFRow row;
			HSSFCell cell;
			int nRows = sheet.getPhysicalNumberOfRows();
			// Loop for traversing each row in the spreadsheet
			for (int rowNo = 1; rowNo <= nRows; rowNo++) {

				row = sheet.getRow(rowNo);
				if (row != null) {
					// Loop for traversing each column in each row in the
					// spreadsheet
					indentData = new IndentVehicleDetailsData();
					for (int c = 0; c < 6; c++) {
						cell = row.getCell((short) c);
						// If cell contains String value
						switch (c) {
						case 0:
							indentData.setNode(getHSSCellValue(cell));
							if(hubMap.get(indentData.getNode()) != null){//Only valid nodes
								nodeNamesExcel.add(indentData.getNode());
							}
							break;
						case 1:
							indentData.setVehicleType(getHSSCellValue(cell));
							break;
						case 2:
							indentData.setMake(getHSSCellValue(cell));
							break;
						case 3:
							indentData.setNoOfVehicles(getHSSCellValue(cell));
							break;
						case 4:
							indentData.setDedicatedOrAdhoc(getHSSCellValue(cell));
							break;
						case 5:
							if(cell == null || cell.getCellType() ==  HSSFCell.CELL_TYPE_BLANK){
								indentData.setPlacementTime("");
							}
							else if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
								indentData.setPlacementTime(getHSSCellValue(cell));
							}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
								if (DateUtil.isCellDateFormatted(cell)) {
						            indentData.setPlacementTime(PLACEMNT_TIME_DATE_FORMAT.format(cell.getDateCellValue()));
						        }else{
									indentData.setPlacementTime(getHSSCellValue(cell));
						        }
							}
							break;
						}
					}
					list.add(indentData);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	
	
	private Map<String,List<IndentVehicleDetailsData>> convertListToNodeToListMap(List<IndentVehicleDetailsData> indentDataList){
		Map<String,List<IndentVehicleDetailsData>> nodeToIndentVehicleDetailsMap = new HashMap<String, List<IndentVehicleDetailsData>>();
		for(IndentVehicleDetailsData indentData : indentDataList){
			
			if(nodeToIndentVehicleDetailsMap.get(indentData.getNode()) == null){
				ArrayList<IndentVehicleDetailsData> indentList = new ArrayList<IndentVehicleDetailsData>();
				indentList.add(indentData);
				nodeToIndentVehicleDetailsMap.put(indentData.getNode(),indentList);
			}else {
				nodeToIndentVehicleDetailsMap.get(indentData.getNode()).add(indentData);
			}
		}
		return nodeToIndentVehicleDetailsMap;
	}

	private void validateRecordMap(Map<String,List<IndentVehicleDetailsData>> nodeToIndendeListMap,Map<String, IndentVehiclesCount> nodeToVehicleCountFromDB) {
		for(String nodeName : nodeToIndendeListMap.keySet()){
			List<IndentVehicleDetailsData> indentDataList = nodeToIndendeListMap.get(nodeName) ;
			for(IndentVehicleDetailsData indentData : indentDataList){
				validateRecord(indentData, nodeToVehicleCountFromDB);
				if(indentData.getErrors().isEmpty()){//If record passes the basic validation, then do vehicle count validation
					validateVehiclesCount(indentData , nodeToVehicleCountFromDB);
					indentData.setIndentId(nodeToVehicleCountFromDB.get(indentData.getNode()).getIndentId());//Fill IndentID from DB
				}
				if(indentData.getErrors().isEmpty()){
					indentData.setValid(true);
					validIndentVehicleDetails.add(indentData);
				}else{
					indentData.setValid(false);
				}
				
			}
		}
	}
	
	private void validateRecord(IndentVehicleDetailsData indentData,Map<String, IndentVehiclesCount> nodeToVehicleCountFromDB){
			if (indentData.getNode() == "") {
				indentData.getErrors().add("Node name is Mandatory");
			}
			
			// check if node is valid
			if(hubMap.get(indentData.getNode()) == null){
				indentData.getErrors().add("Invaild Node name");
			}//check if Master indent exists for the node
			else if(nodeToVehicleCountFromDB.get(indentData.getNode()) == null){
				indentData.getErrors().add("Indent does not exists for this node");
			}
			
			if (indentData.getVehicleType() == "") {
				indentData.getErrors().add("Vehicle Type is Mandatory");
			}else if(!vehicleTypesFromDB.contains(indentData.getVehicleType())){ 
				indentData.getErrors().add("Invalid Vehicle Type");
			}
			
			if (indentData.getMake() == "") {
				indentData.getErrors().add("Vehicle model is Mandatory");
			}else if(!makesFromDB.contains(indentData.getMake())){ 
				indentData.getErrors().add("Invalid Vehicle Model");
			}
			
			if (indentData.getDedicatedOrAdhoc() == "") {
				indentData.getErrors().add("Dedicated /Adhoc Type is Mandatory");
			}else if(!((indentData.getDedicatedOrAdhoc().equals(DistributionLogisticsFunctions.VEHICLE_TYPE_DEDICATED))
					   ||(indentData.getDedicatedOrAdhoc().equals(DistributionLogisticsFunctions.VEHICLE_TYPE_AD_HOC)))){
				indentData.getErrors().add("Invalid type Dedicated/Ad-hoc");
			}
			if (indentData.getNoOfVehicles() == "") {
				indentData.getErrors().add("No of vehicles is Mandatory");
			}else if(!isInteger(indentData.getNoOfVehicles())){
				indentData.getErrors().add("Invalid Datatype - Number of Vehicles");
			}
			if (indentData.getPlacementTime() == "") {
				indentData.getErrors().add("Placement Time is Mandatory");
			}else 
			{
				Pattern p = Pattern.compile(PLCEMENT_TIME_REGEX_PATTERN);  
				Matcher m = p.matcher(indentData.getPlacementTime());  
				if(!m.matches()){
					indentData.getErrors().add("Invalid Placement Time format");
				}
			}

		}

	public void validateVehiclesCount(IndentVehicleDetailsData indentData , Map<String, IndentVehiclesCount> nodeToVehicleCountFromDB){
		IndentVehiclesCount vehiclesCountDB = nodeToVehicleCountFromDB.get(indentData.getNode());
		int remainingDedicatedDB = vehiclesCountDB.getTotalDedicated() - vehiclesCountDB.getTotalAssignedDedicated();
		int remainingAdhocDB = vehiclesCountDB.getTotalAdhoc() - vehiclesCountDB.getTotalAssignedAdhoc();
		if(indentData.getDedicatedOrAdhoc().equals(DistributionLogisticsFunctions.VEHICLE_TYPE_DEDICATED)){
			Integer totalDedicatedExcel = 0;
			if((nodeToDedicatedCountExcel.get(indentData.getNode()) != null)){
				totalDedicatedExcel = (nodeToDedicatedCountExcel.get(indentData.getNode()));
			}
			Integer noOfVehicles = Integer.parseInt(indentData.getNoOfVehicles());
			if((totalDedicatedExcel+noOfVehicles) > remainingDedicatedDB){
				indentData.getErrors().add("Number of vehicles exceeds total dedicated (Total dedicated: "+vehiclesCountDB.getTotalDedicated()+" Remaining: "+(remainingDedicatedDB-totalDedicatedExcel)+")");
			}else{
				if(nodeToDedicatedCountExcel.get(indentData.getNode()) == null){
					nodeToDedicatedCountExcel.put(indentData.getNode(), noOfVehicles);
				}else{
					Integer totalCount = totalDedicatedExcel + noOfVehicles;
					nodeToDedicatedCountExcel.put(indentData.getNode(),totalCount);
				}
			}
		}
		if(indentData.getDedicatedOrAdhoc().equals(DistributionLogisticsFunctions.VEHICLE_TYPE_AD_HOC)){
			Integer totalAdhocExcel = 0;
			if((nodeToAdhocCountExcel.get(indentData.getNode()) != null)){
				totalAdhocExcel = nodeToAdhocCountExcel.get(indentData.getNode());
			}
			Integer noOfVehicles = Integer.parseInt(indentData.getNoOfVehicles());
			if((totalAdhocExcel+noOfVehicles) > remainingAdhocDB){
				indentData.getErrors().add("Number of vehicles exceeds total Ad-hoc (Total Ad-hoc:"+vehiclesCountDB.getTotalAdhoc()+" Remaining: "+(remainingAdhocDB-totalAdhocExcel)+")");
			}else{
				if(nodeToAdhocCountExcel.get(indentData.getNode()) == null){
					nodeToAdhocCountExcel.put(indentData.getNode(), Integer.parseInt(indentData.getNoOfVehicles()));
				}else{
					Integer totalCount = totalAdhocExcel + noOfVehicles;
					nodeToAdhocCountExcel.put(indentData.getNode(),totalCount);
				}
			}
		}
	
	}
	
	public List<String> validateIndentDetailsBeforeSave(List<IndentVehicleDetailsData> validList, int systemId,int clientId,int customerId,int userId ){
		Set<String> nodeNames = new HashSet<String>();
		for(IndentVehicleDetailsData data : validList){
			nodeNames.add(data.getNode());
		}
		Map<String, IndentVehiclesCount> nodeToVehicleCountDB = logisticsFunction.getIndentVehiclesCount(nodeNames, systemId, clientId, Integer.valueOf(customerId).toString());
		List<String> errors = new ArrayList<String>();
		Map<String,List<IndentVehicleDetailsData>> nodeToIndentVehicleList = convertListToNodeToListMap(validList);
		for(String nodeName : nodeToIndentVehicleList.keySet()){
			List<IndentVehicleDetailsData> indentDataList = nodeToIndentVehicleList.get(nodeName) ;
			for(IndentVehicleDetailsData indentData : indentDataList){
				validateVehiclesCount(indentData , nodeToVehicleCountDB);
				if(indentData.getErrors().isEmpty()){
					indentData.setValid(true);
				}else{
					indentData.setValid(false);
					errors.add(indentData.getErrors().get(0));
				}
			}
		}
		
		return errors;
	}
	
	
	private List<IndentVehicleDetailsData> readDataFromXlsx(XSSFSheet sheet) {
		List<IndentVehicleDetailsData> list = new ArrayList<IndentVehicleDetailsData>();
		IndentVehicleDetailsData indentData = null;
		try {
			XSSFRow row;
			XSSFCell cell;
			int nRows = sheet.getPhysicalNumberOfRows();
			// Loop for traversing each row in the spreadsheet
			for (int rowNo = 1; rowNo <= nRows; rowNo++) {
				row = sheet.getRow(rowNo);
				if (row != null) {
					// Column count in the current row
					// cols = sheet.getRow(r).getLastCellNum();
					// Loop for traversing each column in each row in the
					// spreadsheet
					indentData = new IndentVehicleDetailsData();
					//If first column is empty igone that row..
					XSSFCell firstcell =  row.getCell((short) 0);
					String firstCellValue = getXSSCellValue(firstcell);
					if(firstCellValue ==null || firstCellValue.isEmpty())
					{
						continue;
					}
					for (int c = 0; c < 6; c++) {
						
						cell = row.getCell((short) c);
						// If cell contains String value
						switch (c) {
						case 0:
							indentData.setNode(getXSSCellValue(cell));
							if(hubMap.get(indentData.getNode()) != null){//Only valid nodes
								nodeNamesExcel.add(indentData.getNode());
							}
							break;
						case 1:
							indentData.setVehicleType(getXSSCellValue(cell));
							break;
						case 2:
							indentData.setMake(getXSSCellValue(cell));
							break;
						case 3:
							indentData.setNoOfVehicles(getXSSCellValue(cell));
							break;
						case 4:
							indentData.setDedicatedOrAdhoc(getXSSCellValue(cell));
							break;
						case 5:
							if(cell == null || cell.getCellType() ==  XSSFCell.CELL_TYPE_BLANK){
								indentData.setPlacementTime("");
							}
							else if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
								indentData.setPlacementTime(getXSSCellValue(cell));
							}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
								if (DateUtil.isCellDateFormatted(cell)) {
						            SimpleDateFormat dateFormat = new SimpleDateFormat("HH:mm");
						            indentData.setPlacementTime(dateFormat.format(cell.getDateCellValue()));
						        }else{
									indentData.setPlacementTime(getXSSCellValue(cell));
						        }
							}
							break;
						}
					}
					list.add(indentData);
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public static boolean isInteger(String s) {
	    try { 
	        Integer.parseInt(s); 
	    } catch(NumberFormatException e) { 
	        return false; 
	    } catch(NullPointerException e) {
	        return false;
	    }
	    return true;
	}
	
	
}
