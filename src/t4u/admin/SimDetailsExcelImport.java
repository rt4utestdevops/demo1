package t4u.admin;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Properties;

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
import org.json.JSONObject;

import com.sun.corba.se.impl.ior.WireObjectKeyTemplate;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.AdminStatements;

public class SimDetailsExcelImport {
	
		static JSONArray globalJsonArray = new JSONArray();

		private File inFile;
		private String fileExtension;
		private int userId;
		private int systemId;
		private int clientId;
		private int offset;
		
		private String mobileNumber;
		private String serviceProvider;
		private String simNumber;
		private String validityStartDate;
		private String validityEndDate;
		private String status;
		private String remarks;
		
		private int rowNo;
		String message = "";
		String format = "";
		public SimDetailsExcelImport(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension){
			this.inFile = inFile;
			this.userId =  userId;
			this.systemId = systemId;
			this.clientId = clientId;
			this.offset=offset;
			this.fileExtension = fileExtension;
		}
		
		/** return message */
		public String getMessage(){
			return message;
		}
		
	@SuppressWarnings("deprecation")
	public String importExcelData(){	
		String importMessage = "";
		List<SimDetailsData> list = new ArrayList();	
		
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
								cols = sheet.getRow(r).getLastCellNum();
								// Loop for traversing each column in each row in the spreadsheet
								for (int c = 0; c < 5; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												mobileNumber = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												mobileNumber = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										}else {
											mobileNumber = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												serviceProvider = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												serviceProvider = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											serviceProvider = "";
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												simNumber = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												simNumber = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											simNumber = "";
										}
										break;
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
												try{
													SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
													validityStartDate = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
												}catch (Exception e) {
													validityStartDate=cell.getStringCellValue() + "Invalid";
												}
											}else
												format = "Invalid";
										} else {
											validityStartDate = "";
										}
										break;
									case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
												try{
													SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
													validityEndDate = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
												}catch (Exception e) {
													validityEndDate=cell.getStringCellValue() + "Invalid";
												}
											}else
												format = "Invalid";
										} else {
											validityEndDate = "";
										}
										if(mobileNumber!="" || serviceProvider!="" || status!="")
										  list.add(new SimDetailsData(mobileNumber,serviceProvider,simNumber,validityStartDate,validityEndDate,status,""));
										break;
									}															
								}							
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else if (fileExtension.equals(".xlsx")) {
					
					try {
						InputStream excelFileToRead = new FileInputStream(inFile);
						XSSFWorkbook wb = new XSSFWorkbook(excelFileToRead);

						XSSFSheet sheet = wb.getSheetAt(0);
						XSSFRow row;
						XSSFCell cell;
						int cols = 0;
						int nRows = sheet.getPhysicalNumberOfRows();

						// Loop for traversing each row in the spreadsheet
						for (int r = 0; r < nRows; r++) {
							rowNo = r;
							rowNo++;
							row = sheet.getRow(rowNo);
							if (row != null) {
								// Column count in the current row
								cols = sheet.getRow(r).getLastCellNum();
								// Loop for traversing each column in each row in the spreadsheet
								for (int c = 0; c < 5; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){ 
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												mobileNumber = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												mobileNumber = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											mobileNumber = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
											serviceProvider = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												serviceProvider = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											serviceProvider = "";
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
											simNumber = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												simNumber = cell.getStringCellValue();
											}
											else{	
												format = "Invalid";
												}
										} else {
											simNumber = "";
										}
										break;
									case 3:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
												try{
													SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
													validityStartDate = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
												}catch (Exception e) {
													validityStartDate=cell.getStringCellValue()+"Invalid";
												}
											}else
												format = "Invalid";
										} else {
											validityStartDate = "";
										}
										break;
									case 4:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
												try{
													SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
													validityEndDate = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
												}catch (Exception e) {
													validityEndDate=cell.getStringCellValue()+"Invalid";
												}
											}else
												format = "Invalid";
										} else {
											validityEndDate = "";
										}
										if(mobileNumber!="" || serviceProvider!="" || status!="")
										 list.add(new SimDetailsData(mobileNumber,serviceProvider,simNumber,validityStartDate,validityEndDate,status,""));
										break;
									}															
								}							
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				globalJsonArray  = null;
				globalJsonArray = getImportExcelUnitDetails(clientId, systemId,getValidSimDetails(list,systemId,userId));
				if(globalJsonArray != null && globalJsonArray.length() > 0){
					importMessage = "Success";
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return importMessage;
		}

		
		public List<SimDetailsData> getValidSimDetails(List<SimDetailsData> list,int systemId,int userId) {

			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String simstatus = "";
			List<SimDetailsData> validlist = new ArrayList();
			try {
				if(list.size()!=0 && !format.equalsIgnoreCase("Invalid")){
				for (SimDetailsData simDetails : list) {
					if(simDetails.mobileNumber==""){
						simDetails.remarks = " Invalid Mobile Number .";
					}else{
					con = DBConnection.getConnectionToDB("AMS");
					pstmt = con.prepareStatement(AdminStatements.SELECT_MOBILE_NO_VALIDATE);
					pstmt.setString(1,simDetails.mobileNumber.toUpperCase());
					rs = pstmt.executeQuery();
					if (rs.next()){
						simDetails.remarks = " Mobile Number already exist";
					}else{
						if(simDetails.serviceProvider==""){
							simDetails.remarks = " Invalid Service Provider.";
						}else if(simDetails.validityStartDate.contains("Invalid") && simDetails.validityStartDate.length()>6){
							simDetails.remarks = "Invalid Start Date";
							simDetails.validityStartDate=simDetails.validityStartDate.replace("Invalid", "").trim();
						}else  if(simDetails.validityEndDate.contains("Invalid") && simDetails.validityEndDate.length()>6){
							simDetails.remarks = "Invalid End Date";
							simDetails.validityEndDate=simDetails.validityEndDate.replace("Invalid", "").trim();
						}
					}
				  }
					
					if(!(simDetails.remarks.contains("already") || simDetails.remarks.contains("Invalid"))){
						if(validlist.size()!=0){
							for (SimDetailsData sd : validlist) {
								if(sd.mobileNumber.equalsIgnoreCase(simDetails.mobileNumber)){
									simstatus = "Invalid";
									simDetails.remarks = "Mobile Number is Duplicate";
								}
							}
						}
						if(!simDetails.remarks.contains("Duplicate")){
						simstatus = "Valid";
						}
					}
					
					if(simstatus == ""){
						simstatus = "Invalid";
					}
					validlist.add(new SimDetailsData(simDetails.mobileNumber,simDetails.serviceProvider,simDetails.simNumber,simDetails.validityStartDate,simDetails.validityEndDate,simstatus,simDetails.remarks));
					  simDetails.remarks = "";
					  simstatus = "";
			  }
		    }
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return validlist;
		}
		 
		public JSONArray getImportExcelUnitDetails(int clientId, int systemId, List<SimDetailsData> list) {

			JSONArray unitDetaisJsonArray = null;
			JSONObject unitDetailsJsonObject = null;
			int count = 0;		
			try {
				unitDetaisJsonArray = new JSONArray();
				unitDetailsJsonObject = new JSONObject();		
							
				for (SimDetailsData simDetails : list) {
					count++;
					unitDetailsJsonObject = new JSONObject();

					unitDetailsJsonObject.put("importslnoIndex", count);
					unitDetailsJsonObject.put("importmobilenumberindex", simDetails.mobileNumber);
					unitDetailsJsonObject.put("importserviceproviderindex", simDetails.serviceProvider);
					unitDetailsJsonObject.put("importsimnumberindex", simDetails.simNumber);
					unitDetailsJsonObject.put("importsimvaliditystartdateindex", simDetails.validityStartDate);
					unitDetailsJsonObject.put("importsimvalidityenddateindex", simDetails.validityEndDate);
					unitDetailsJsonObject.put("importsimstatusindex", simDetails.status);
					unitDetailsJsonObject.put("importsimremarksindex", simDetails.remarks);
					unitDetaisJsonArray.put(unitDetailsJsonObject);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} 
			return unitDetaisJsonArray;
		}
}
