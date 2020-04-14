package t4u.distributionlogistics;

import java.io.BufferedOutputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.mongodb.util.Hash;

import t4u.common.ApplicationListener;
import t4u.functions.DistributionLogisticsFunctions;
import t4u.functions.IronMiningFunction;

public class IndentMasterExcelImport {
	
	DistributionLogisticsFunctions logisticsFunction = new DistributionLogisticsFunctions();
	
	List<String> nodeNamesExcel = new ArrayList<String>();
	
	List<String> regionList = Arrays.asList((new String[]{"North","South","East","West"}));
	
	List<String> indenIdListFromDB = new ArrayList<String>();
	
	List<IndentMasterData> validIndentList = new ArrayList<IndentMasterData>();
	
	public static final Integer EXCEL_UPLOAD_LIMIT = 100;
	
	Map<String, Integer>  hubsMap = new HashMap<String, Integer>();
	
	public List<IndentMasterData> getValidIndentList() {
		return validIndentList;
	}

	public void setValidIndentList(List<IndentMasterData> validIndentList) {
		this.validIndentList = validIndentList;
	}

	public JSONObject importExcelData(String inFile, int userId, int systemId,int clientId,int customerId,String zone) throws JSONException {
		String fileExtension = inFile.substring(inFile.lastIndexOf("."), inFile.length());
		List<IndentMasterData> indentDataList = new ArrayList<IndentMasterData>();
		hubsMap = getHubsMap(clientId,systemId,zone,userId);
		try {
			if (fileExtension.equals(".xls")) {
				InputStream excelFileToRead = new FileInputStream(inFile);
				HSSFWorkbook wb = new HSSFWorkbook(excelFileToRead);
				HSSFSheet sheet = wb.getSheetAt(0);
				if(sheet.getPhysicalNumberOfRows() > EXCEL_UPLOAD_LIMIT){
					JSONObject resultObj = new JSONObject();
					resultObj.append("error", "Number of rows exceeds the supported upload limit "+EXCEL_UPLOAD_LIMIT);
					return resultObj;
				}
				indentDataList = readDataFromXls(sheet);
			} else if (fileExtension.equals(".xlsx")) {
				InputStream excelFileToRead = new FileInputStream(inFile);
				XSSFWorkbook wb = new XSSFWorkbook(excelFileToRead);
				XSSFSheet sheet = wb.getSheetAt(0);
				if(sheet.getPhysicalNumberOfRows() > EXCEL_UPLOAD_LIMIT){
					JSONObject resultObj = new JSONObject();
					resultObj.append("error", "Number of rows exceeds the supported upload limit "+EXCEL_UPLOAD_LIMIT);
					return resultObj;
				}
				indentDataList = readDataFromXlsx(sheet);
			}
			
			validateRecord(indentDataList,userId, systemId,clientId,customerId,hubsMap);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return convertIndentListToJsonArray(indentDataList);
	}
	
	
	public List<String> validateBeforeSave(List<IndentMasterData> allData,int clientId, int systemId, int customerId){
		List<String> errors= new ArrayList<String>();
		List<String> nodeNames = new ArrayList<String>();
		for(IndentMasterData data : allData){
			nodeNames.add(data.getNode());
		}
		Map<String,Integer> mapHubToIndentId = logisticsFunction.getIndentListByHubNames(nodeNames, systemId, clientId, Integer.valueOf(customerId).toString());
		for(IndentMasterData indentData : allData){
			if(mapHubToIndentId.get(indentData.getNode()) != null){
				indentData.getErrors().add("Indent already exists for the node");
				indentData.setValid(false);
				errors.add("Indent alredy exists for the node "+indentData.getNode());
			}
		}
		return errors;
	}
	
	public Map<String, Integer> getHubsMap(int clientId, int systemId, String zone, int userId) throws JSONException{
		Map<String, Integer> hubMap = new HashMap<String,Integer>();
		JSONArray hubArray = logisticsFunction.getAllHubs(clientId, systemId, zone, userId);
		JSONObject obj;
		for(int i=0; i <hubArray.length();i++){
			obj = (JSONObject)hubArray.get(i);
			if(obj.get("hubId") != null && obj.get("hubName") != null)
				hubMap.put((String) obj.get("hubName"),Integer.parseInt((String)obj.get("hubId"))); 
		}
		return hubMap;
	}

	public JSONObject convertIndentListToJsonArray(List<IndentMasterData> indentList) throws JSONException {
		
		JSONObject resultObj = new JSONObject();
		JSONArray indentJsonArray = null;
		JSONObject indentDataJsonObject = null;
		int count = 0;
		try {
			indentJsonArray = new JSONArray();
			indentDataJsonObject = new JSONObject();

			for (IndentMasterData indentData : indentList) {
				count++;
				indentDataJsonObject = new JSONObject();
				indentDataJsonObject.put("slNo", count);
				indentDataJsonObject.put("node", indentData.getNode());
				indentDataJsonObject.put("region", indentData.getRegion());
				indentDataJsonObject.put("dedicated",indentData.getDedicated());
				indentDataJsonObject.put("adhoc", indentData.getAdhoc());
				indentDataJsonObject.put("supervisorName",indentData.getSupervisorName());
				indentDataJsonObject.put("supervisorContact",indentData.getSupervisorContact());
				indentDataJsonObject.put("recordStatus",(indentData.isValid()? "Valid" : "Invalid"));
				indentDataJsonObject.put("errors", formatError(indentData.getErrors()));

				indentDataJsonObject.put("valid", indentData.isValid());
				indentJsonArray.put(indentDataJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		resultObj.put("importIndentMasterRoot", indentJsonArray);
		resultObj.put("TotalRecords", indentList.size());
		resultObj.put("ValidRecord", validIndentList.size());
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
				cellValue = "";
			}
		} else {
			cellValue = "";
		}
		return cellValue;
	}

	private List<IndentMasterData> readDataFromXls(HSSFSheet sheet) {
		List<IndentMasterData> allRecords = new ArrayList<IndentMasterData>();
		IndentMasterData indentData = null;
		try {
			HSSFRow row;
			HSSFCell cell;
			int nRows = sheet.getPhysicalNumberOfRows();
			// Loop for traversing each row in the spreadsheet
			for (int rowNo = 1; rowNo <= nRows; rowNo++) {
				row = sheet.getRow(rowNo);
				//If first cloumn is empty , then igonre the row
				if(row == null){
					continue;
				}
				HSSFCell firstcell =  row.getCell((short) 0);
				if(firstcell == null){
					continue;
				}
				String firstCellValue = getHSSCellValue(firstcell);
				if(firstCellValue ==null || firstCellValue.isEmpty())
				{
					continue;
				}
				if (row != null) {
					indentData = new IndentMasterData();
					for (int c = 0; c < 6; c++) {
						cell = row.getCell((short) c);
						// If cell contains String value
						switch (c) {
						case 0:
							indentData.setNode(getHSSCellValue(cell));
							if(hubsMap.get(indentData.getNode()) != null){
								nodeNamesExcel.add(indentData.getNode());
							}
							break;
						case 1:
							indentData.setRegion(getHSSCellValue(cell));
							break;
						case 2:
							indentData.setDedicated(getHSSCellValue(cell));
							break;
						case 3:
							indentData.setAdhoc(getHSSCellValue(cell));
						case 4:
							indentData.setSupervisorName(getHSSCellValue(cell));
						case 5:
							indentData
									.setSupervisorContact(getHSSCellValue(cell));
							break;
						}
					}
					allRecords.add(indentData);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return allRecords;
	}

	private void validateRecord(List<IndentMasterData> indentDataList, int userId, int systemId,int clientId,int customerId,Map<String, Integer>  hubsMap) {
		Map<String,Integer> mapHubToIndentId = new HashMap<String, Integer>();
		if(!nodeNamesExcel.isEmpty()){
			mapHubToIndentId = logisticsFunction.getIndentListByHubNames(nodeNamesExcel, systemId, clientId, Integer.valueOf(customerId).toString());
		}
		List<String> nodeNames =  new ArrayList<String>();
		for(IndentMasterData indentData : indentDataList){
				if (indentData.getNode() == "") {
					indentData.getErrors().add("Node name is Mandatory");
				}
				// check if node is valid
				if(hubsMap.get(indentData.getNode()) == null){
					indentData.getErrors().add("Invaild Node name");
				}else if(nodeNames.contains(indentData.getNode())){//Check for duplicate nodes in excel sheet
					indentData.getErrors().add("Duplicate Node");
				}else{
					nodeNames.add(indentData.getNode());
					indentData.setNodeId(hubsMap.get(indentData.getNode()));//Fill Indent data with Node Id
				}
				
				//Duplicate indent validation
				if(mapHubToIndentId.get(indentData.getNode()) != null){
					indentData.getErrors().add("Indent already exists for the node");
				}
				
				if (indentData.getRegion() == "") {
					indentData.getErrors().add("Region is Mandatory");
				}
				else if(!regionList.contains(indentData.getRegion())){
					indentData.getErrors().add("Invalid Region");
				}
				if (indentData.getDedicated() == "") {
					indentData.getErrors().add(
							"Dedicated Number of Vehicles is Mandatory");
				}else if(!isInteger(indentData.getDedicated())){
					indentData.getErrors().add("Invalid Datatype - Dedicated Number of Vehicles");
				}
				if (indentData.getAdhoc() == "") {
					indentData.getErrors().add("Adhoc Number of Vehicles is Mandatory");
				}else if(!isInteger(indentData.getAdhoc())){
					indentData.getErrors().add("Invalid Datatype - Adhoc Number of Vehicles");
				}
				if (indentData.getSupervisorName() == "") {
					indentData.getErrors().add("Supervisor name is Mandatory");
				}
				if (indentData.getSupervisorContact() == "") {
					indentData.getErrors().add("Supervisor contact is Mandatory");
				}
				 
				if(indentData.getErrors().isEmpty()){
					indentData.setValid(true);
					validIndentList.add(indentData);
					
				}else{
					indentData.setValid(false);
				}
		}

	}
	
	private List<IndentMasterData> readDataFromXlsx(XSSFSheet sheet) {
		List<IndentMasterData> list = new ArrayList<IndentMasterData>();
		IndentMasterData indentData = null;
		try {
			int nRows = sheet.getPhysicalNumberOfRows();
			XSSFRow row;
			XSSFCell cell;
			// Loop for traversing each row in the spreadsheet
			for (int rowNo = 1; rowNo <= nRows; rowNo++) {
				row = sheet.getRow(rowNo);
				if (row != null) {
					//If first cloumn is empty , then igonre the row
					XSSFCell firstcell =  row.getCell((short) 0);
					String firstCellValue = getXSSCellValue(firstcell);
					if(firstCellValue ==null || firstCellValue.isEmpty())
					{
						continue;
					}
					indentData = new IndentMasterData();
					for (int c = 0; c < 6; c++) {
						
						cell = row.getCell((short) c);
						// If cell contains String value
						switch (c) {
						case 0:
							indentData.setNode(getXSSCellValue(cell));
							if(hubsMap.get(indentData.getNode()) != null){
								nodeNamesExcel.add(indentData.getNode());
							}
							break;
						case 1:
							indentData.setRegion(getXSSCellValue(cell));
							break;
						case 2:
							indentData.setDedicated(getXSSCellValue(cell));
							break;
						case 3:
							indentData.setAdhoc(getXSSCellValue(cell));
							break;
						case 4:
							indentData.setSupervisorName(getXSSCellValue(cell));
							break;
						case 5:
							indentData
									.setSupervisorContact(getXSSCellValue(cell));
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

	public static void downloadStandardFormt(String filePath, String fileName,HttpServletRequest req,  HttpServletResponse response) throws IOException{
		try{
			File stdFile;
			stdFile = new File(filePath);
			response.setContentType("application/octet-stream");
			response.setHeader("Content-disposition","attachment;filename="+fileName+".xlsx");
			FileInputStream fis = new FileInputStream(stdFile);
			ServletOutputStream servletOutputStream = response.getOutputStream();
			DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);
			byte [] buffer = new byte [1024];
			int len = 0;
			while ( (len = fis.read(buffer)) >= 0 ) 
			{
				outputStream.write(buffer, 0, len);
			}
			outputStream.flush();
			outputStream.close();
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}
	
}
