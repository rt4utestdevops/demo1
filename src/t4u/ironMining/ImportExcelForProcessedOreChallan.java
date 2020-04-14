package t4u.ironMining;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.functions.CommonFunctions;
import t4u.statements.IronMiningStatement;

public class ImportExcelForProcessedOreChallan {

	static JSONArray globalJsonArray = new JSONArray();
	private File inFile;
	private String fileExtension;
	private int userId;
	private int systemId;
	private int clientId;
	private int offset;
	
	private String orgName;
	private String challanNo;
	private String vehicleNo;
	private String quantity;
	private String status;
	private String plantName;
	
	private int rowNo;
	String message = "";
	String format = "";
	
	public ImportExcelForProcessedOreChallan(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension){
		this.inFile = inFile;
		this.userId =  userId;
		this.systemId = systemId;
		this.clientId = clientId;
		this.offset=offset;
		this.fileExtension = fileExtension;
	}
	public String getMessage(){
		return message;
	}
	
	public String ImportProcessedChallanDetails(){
		
		String importMessage = "";
		List<ProcessedOreChallanDetails> list = new ArrayList();	
		
			try{
				if(fileExtension.equals(".xls")){
					
					try {
						InputStream excelFileToRead = new FileInputStream(inFile);
						HSSFWorkbook wb = new HSSFWorkbook(excelFileToRead);

						HSSFSheet sheet = wb.getSheetAt(0);
						HSSFRow row;
						HSSFCell cell;
						int cols = 0;
						int nRows = sheet.getPhysicalNumberOfRows();

						// Loop for traversing each row in the spreadsheet
						for (int r = 0; r < nRows; r++) {
							rowNo = r;
							rowNo++;
							row = sheet.getRow(rowNo);
							if (row != null) {
								// Column count in the current row
								//cols = sheet.getRow(r).getLastCellNum();
								// Loop for traversing each column in each row in the spreadsheet
								for (int c = 0; c < 6; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												orgName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												orgName = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												orgName = "";
											}
											else{
												format = "Invalid";
											}
										} else {
											orgName = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												challanNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												challanNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												challanNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											challanNo = "";
										}
										break;
										
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												vehicleNo = cell.getStringCellValue().toUpperCase();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												vehicleNo = cell.getStringCellValue().toUpperCase();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												vehicleNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											vehicleNo = "";
										}
										break;
										
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												quantity = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												quantity = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												quantity = "";
											}else{
												format = "Invalid";
											}
										} else {
											quantity = "";
										}
										break;
										
									case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												plantName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												plantName = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												plantName = "";
											}else{
												format = "Invalid";
											}
										} else {
											plantName = "";
										}
										break;
									}															
								}
								if(orgName!="" || challanNo!="" || vehicleNo!="" || quantity!="")
									list.add(new ProcessedOreChallanDetails(status,"",orgName,challanNo,quantity,vehicleNo,0,0,plantName,0));
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else if (fileExtension.equals(".xlsx")) {
					
					try {
						InputStream excelFileToRead = new FileInputStream(inFile);
						//XSSFWorkbook wb = new XSSFWorkbook(excelFileToRead);
						org.apache.poi.ss.usermodel.Workbook workbook = WorkbookFactory.create(excelFileToRead);
						org.apache.poi.ss.usermodel.Sheet sheet = workbook.getSheetAt(0);

						//XSSFSheet sheet = wb.getSheetAt(0);
						Row row;
						Cell cell;
						int cols = 0;
						int nRows = sheet.getPhysicalNumberOfRows();

						// Loop for traversing each row in the spreadsheet
						for (int r = 0; r < nRows; r++) {
							rowNo = r;
							rowNo++;
							row = sheet.getRow(rowNo);
							if (row != null) {
								// Column count in the current row
								//cols = sheet.getRow(r).getLastCellNum();
								// Loop for traversing each column in each row in the spreadsheet
								for (int c = 0; c < 4; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												orgName = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												orgName = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												orgName = "";
											}
											else{
												format = "Invalid";
											}
										} else {
											orgName = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
												challanNo = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												challanNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												challanNo = "";
											}
											else{	
												format = "Invalid";
												}
										} else {
											challanNo = "";
										}
										break;
							
									case 2:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
												vehicleNo = cell.getStringCellValue().toUpperCase();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												vehicleNo = cell.getStringCellValue().toUpperCase();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												vehicleNo = "";
											}
											else{	
												format = "Invalid";
												}
										} else {
											vehicleNo = "";
										}
										break;
										
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												quantity = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												quantity = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												quantity = "";
											}else{
												format = "Invalid";
											}
										} else {
											quantity = "";
										}
										break;
									}															
								}
								if(orgName!="" || challanNo!="" || vehicleNo!="" || quantity!="")
									list.add(new ProcessedOreChallanDetails(status,"",orgName,challanNo,quantity,vehicleNo,0,0,plantName,0));
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				globalJsonArray  = null;
				globalJsonArray = getImportDetailsForPOChallan(clientId, systemId,getValidTripDetailsForPOChallan(list,systemId,userId,clientId));
				if(globalJsonArray != null && globalJsonArray.length() > 0){
					importMessage = "Success";
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return importMessage;
	}
	
	public synchronized List<ProcessedOreChallanDetails> getValidTripDetailsForPOChallan(List<ProcessedOreChallanDetails> list,int systemId,int userId,int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String validstatus = "";
		Set<String> vehicleSet=new HashSet<String>();
		List<ProcessedOreChallanDetails> validlist = new ArrayList();
		CommonFunctions cf=new CommonFunctions();
		String walletLinked="";
		Date ctoDate=null;
		int tcId=0;
		int orgId=0;
		int TCorgId=0;
		float challanQty=0;
		float usedQty=0;
		String challanStatus="";
		String challanType = "";
		int challanTcId = 0; 
		int challanId=0;
		int plantId=0;
		int plantOrgId=0;
		String processingPlant="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(list.size()!=0 && !format.equalsIgnoreCase("Invalid")){
				int k=0;
				pstmt = con.prepareStatement(IronMiningStatement.GET_VEHILCE_NO_FOR_TRIP_SHEET_GEN_TRUCK);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,clientId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4,clientId);
				rs = pstmt.executeQuery();
				while(rs.next())
				{
					 vehicleSet.add(rs.getString("VNAME"));
				}
				
				pstmt = con.prepareStatement(IronMiningStatement.GET_CHALLAN_NUMBER_FOR_TRIP.replace("#", " and CHALLAN_NO=? ")); 
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,clientId);
				pstmt.setString(3,list.get(0).challanNo);
				rs = pstmt.executeQuery();
				
				if(rs.next())
				{
					challanId=rs.getInt("ID");
					challanTcId=rs.getInt("TC_NO");
					challanQty=rs.getFloat("QUANTITY");
					usedQty=rs.getFloat("USED_QTY");
					challanStatus=rs.getString("STATUS");
					challanType=rs.getString("CHALLAN_TYPE");
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_TC_DETAILS.replace("&", " and a.ID=? "));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,clientId);
				pstmt.setInt(3, userId);
				pstmt.setInt(4,systemId);
				pstmt.setInt(5,challanTcId);
				rs = pstmt.executeQuery();
				if(rs.next())
				{
					walletLinked=rs.getString("WALLET_LINK");
					tcId=rs.getInt("ID");
					TCorgId=rs.getInt("ORG_ID");
					processingPlant=rs.getString("PROCESSING_PLANT");
					ctoDate=rs.getTimestamp("CTO_DATE");
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_ORGANIZATION);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,clientId);
				pstmt.setString(3,list.get(0).orgName);
				rs = pstmt.executeQuery();
				if(rs.next())
				{
					orgId=rs.getInt("ID");
				}
				float challanBal=challanQty-usedQty;
				for (ProcessedOreChallanDetails POChallanDetails : list) {
					
					pstmt = con.prepareStatement(IronMiningStatement.CHECK_PLANT_NAME);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2,clientId);
					pstmt.setString(3,list.get(k).plantName);
					rs = pstmt.executeQuery();
					if(rs.next())
					{
						plantId=rs.getInt("ID");
						plantOrgId=rs.getInt("ORGANIZATION_ID");
					}
					if(cf.isDateAfterDate(new Date(),ctoDate)==false){
						POChallanDetails.remarks = "CTO date Expired ";
						validstatus="Invalid";
					}
//					if(!walletLinked.equalsIgnoreCase("PROCESSED ORE")){
//						POChallanDetails.remarks = "Invalid wallet TC ";
//						validstatus="Invalid";
//					}
//					if(!processingPlant.equalsIgnoreCase("yes")){
//						POChallanDetails.remarks = " Invalid processing plant ";
//						validstatus="Invalid";
//					}
					if(orgId!=TCorgId){
						POChallanDetails.remarks = " Invalid Organization TC ";
						validstatus="Invalid";
					}
					if(orgId!=plantOrgId){
						POChallanDetails.remarks = " Invalid Organization Plant ";
						validstatus="Invalid";
					}
					if(challanTcId!=tcId){
						POChallanDetails.remarks = " Invalid TC permit ";
						validstatus="Invalid";
					}
					if(list.get(0).challanNo!=POChallanDetails.challanNo){
						POChallanDetails.remarks = " Please use single Challan ";
						validstatus="Invalid";
					}
					if(list.get(0).orgName!=POChallanDetails.orgName){
						POChallanDetails.remarks = " Please use single Organization ";
						validstatus="Invalid";
					}
					if(Float.parseFloat(list.get(k).quantity) <=0 ){
						POChallanDetails.remarks = "Enter Valid Quantity ";
						validstatus="Invalid";
					}
					else if(Float.parseFloat(list.get(k).quantity) > challanBal){
						POChallanDetails.remarks = "challan qty is over ";
						validstatus="Invalid";
					}
					if(!(challanStatus.equalsIgnoreCase("APPROVED") || challanStatus.equalsIgnoreCase("ACKNOWLEDGED"))){
						POChallanDetails.remarks = "Invalid Challan ";
						validstatus="Invalid";
					}
					if(!challanType.equalsIgnoreCase("Processed Ore")){
						POChallanDetails.remarks = "Invalid Challan ";
						validstatus="Invalid";
					}
			/*		if(POChallanDetails.vehicleNo!=null && !POChallanDetails.vehicleNo.equals("")){
						if((POChallanDetails.vehicleNo==null || !vehicleSet.contains(POChallanDetails.vehicleNo))){
							POChallanDetails.remarks = "Invalid Vehicle No";
							validstatus="Invalid";
						}
					}
			*/		
					if(validstatus != "Invalid" || validstatus==""){
						validstatus = "Valid";
						POChallanDetails.remarks= "Valid";
					}
					validlist.add(new ProcessedOreChallanDetails(validstatus,POChallanDetails.remarks,POChallanDetails.orgName,POChallanDetails.challanNo,
							POChallanDetails.quantity,POChallanDetails.vehicleNo,orgId,challanId,POChallanDetails.plantName,plantId));
					POChallanDetails.remarks = "";
					validstatus = "";
					k++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return validlist;
	}

	public JSONArray getImportDetailsForPOChallan(int clientId, int systemId, List<ProcessedOreChallanDetails> list) {

		JSONArray POChallanDetaisJsonArray = null;
		JSONObject POChallanDetaisJsonObject = null;
		int count = 0;		
		try {
			POChallanDetaisJsonArray = new JSONArray();
			POChallanDetaisJsonObject = new JSONObject();		
						
			for (ProcessedOreChallanDetails Details : list) {
				count++;
				POChallanDetaisJsonObject = new JSONObject();
			
				POChallanDetaisJsonObject.put("importslnoIndex1", count);
				POChallanDetaisJsonObject.put("importorgNameIndex1", Details.orgName);
				POChallanDetaisJsonObject.put("importChallanNoIndex1", Details.challanNo);
				POChallanDetaisJsonObject.put("importQuantityIndex1", Details.quantity);
				POChallanDetaisJsonObject.put("importVehicleNoIndex1", Details.vehicleNo);
				POChallanDetaisJsonObject.put("importplantNameIndex1", Details.plantName);
				POChallanDetaisJsonObject.put("importplantIdIndex1", Details.plantId);
				POChallanDetaisJsonObject.put("importOrgIdIndex1", Details.orgId);
				POChallanDetaisJsonObject.put("importChallanIdIndex1", Details.challanId);
				POChallanDetaisJsonObject.put("importValidStatusIndex1", Details.validstatus);
				POChallanDetaisJsonObject.put("importRemarksIndex1", Details.remarks);
				POChallanDetaisJsonArray.put(POChallanDetaisJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return POChallanDetaisJsonArray;
	}


}
