package t4u.admin;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.AdminStatements;

public class UnitDetailsExcelImport {
	
		static JSONArray globalJsonArray = new JSONArray();
		static Map<String,List<UnitDetailsData>>  dataMap = new HashMap<String, List<UnitDetailsData>>();
		private File inFile;
		private String fileExtension;
		private int userId;
		private int systemId;
		private int clientId;
		private int offset;
		
		private String unitNumber;
		private String manufacturer;
		private String unitType;
		private String unitReferenceId;
		private String status;
		private String remarks;
	
		private int rowNo;
		String message = "";
		String format = "";
		
		public UnitDetailsExcelImport(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension){
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
		
	public String importExcelData(){	
		String importMessage = "";
		List<UnitDetailsData> list = new ArrayList();	
		
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
								for (int c = 0; c < 4; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){ 
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												unitNumber = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												unitNumber = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										}else {
											unitNumber = "";
										}
										break;
									case 1:
										if (cell != null){ 
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												manufacturer = cell.getStringCellValue();
											else  if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												manufacturer = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											manufacturer = "";
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												unitType = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												unitType = cell.getStringCellValue();
											}
											else{												
												format = "Invalid";
											}
										} else {
											unitType = "";
										}
										break;
									case 3:
										if (cell != null){ 
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												unitReferenceId = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												unitReferenceId = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											unitReferenceId = "";
										}
										if(unitNumber!="" || manufacturer!="" || unitType!="" || unitReferenceId!="")
											  list.add(new UnitDetailsData(unitNumber,manufacturer,unitType,unitReferenceId,"",""));
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
								for (int c = 0; c < 4; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){ 
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
												unitNumber = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												unitNumber = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											unitNumber = "";
										}
										break;
									case 1:
										if (cell != null){ 
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												manufacturer = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												manufacturer = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											manufacturer = "";
										}
										break;
									case 2:
										if (cell != null) {
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
											   unitType = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												  unitType = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											unitType = "";
										}
										break;
									case 3:
										if (cell != null){ 
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
												unitReferenceId = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												unitReferenceId = cell.getStringCellValue();
											}
											else{	
												format = "Invalid";
											}
										} else {
											unitReferenceId = "";
										}
										if(unitNumber!="" || manufacturer!="" || unitType!="" || unitReferenceId!="")
											 list.add(new UnitDetailsData(unitNumber,manufacturer,unitType,unitReferenceId,"",""));
										break;
									}	
								}							
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				dataMap = getValidUnitDetails(list,systemId,userId);
				globalJsonArray  = null;
				if(!dataMap.isEmpty())
				globalJsonArray = getImportExcelUnitDetails(clientId, systemId,dataMap.get("All"));
				if(globalJsonArray != null && globalJsonArray.length() > 0){
					importMessage = "Success";
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return importMessage;
		}

		
	public Map<String,List<UnitDetailsData>> getValidUnitDetails(List<UnitDetailsData> list,int systemId,int userId) {
			Connection con = null;
			PreparedStatement pstmt = null;
			PreparedStatement pstmt1 = null;
			PreparedStatement pstmt2 = null;
			ResultSet rs = null;
			ResultSet rs1 = null;
			ResultSet rs2 = null;
			Map<String, List<UnitDetailsData>> dataMap = new HashMap<String, List<UnitDetailsData>>();
			List<UnitDetailsData> validlist = new ArrayList();
			List<UnitDetailsData> validSavelist = new ArrayList();
			String unitstatus = "";
			int manufacturercode=0;
			boolean validUnitType = false;
			String unitType = "";
			try {
				con = DBConnection.getConnectionToDB("AMS");
				if(list.size()!=0 && !format.equalsIgnoreCase("Invalid")){
				for (UnitDetailsData unitDetails : list) {
					if(unitDetails.unitNumber==""){
						unitDetails.remarks = " Invalid Unit Number .";
					}else{
					pstmt = con.prepareStatement(AdminStatements.SELECT_UNIT_NUMBER_VALIDATE);
					pstmt.setString(1,unitDetails.unitNumber.toUpperCase());
					rs = pstmt.executeQuery();
					if (rs.next()){
						unitDetails.remarks = " Unit Number already exist";
					}else{
						pstmt1 = con.prepareStatement(AdminStatements.SELECT_MANUFACTURE_CODE);
						rs1 = pstmt1.executeQuery();
						while(rs1.next()){
							if(unitDetails.manufacturer.equalsIgnoreCase(rs1.getString("MANUFACTURE_NAME"))){
								manufacturercode = Integer.parseInt(rs1.getString("MANUFACTURE_ID"));
							}
						}	
						if(manufacturercode==0){
							unitDetails.remarks = " Invalid Manufacturer";
						}else{
							pstmt2 = con.prepareStatement(AdminStatements.SELECT_UNIT_TYPE_CODE_FROM_MANUFACTURE);
							pstmt2.setInt(1, manufacturercode);
							rs2 = pstmt2.executeQuery();
							while(rs2.next()){
								if(unitDetails.unitType.equals(rs2.getString("UNIT_NAME"))){
									validUnitType = true;
									unitType = rs2.getString("UNIT_TYPE_CODE");
								}
							}
							if(!validUnitType){
								unitDetails.remarks = " Invalid Unit Type";
							}
						}
					}
				  }
					if(!(unitDetails.remarks.contains("already") || unitDetails.remarks.contains("Invalid"))){
						if(validlist.size()!=0){
							for (UnitDetailsData ud : validlist) {
								if(ud.unitNumber.equalsIgnoreCase(unitDetails.unitNumber)){
								    unitstatus = "Invalid";
								    unitDetails.remarks = " Unit Number is Duplicate";
								}
							}
						}
						if(!unitDetails.remarks.contains("Duplicate")){
						validSavelist.add(new UnitDetailsData(unitDetails.unitNumber,manufacturercode+"",unitType,unitDetails.unitReferenceId,"",""));
						dataMap.put("Valid",validSavelist);
						unitstatus = "Valid";
						}
					}
					if(unitstatus == ""){
						unitstatus = "Invalid";
					}
					validlist.add(new UnitDetailsData(unitDetails.unitNumber,unitDetails.manufacturer,unitDetails.unitType,unitDetails.unitReferenceId,unitstatus,unitDetails.remarks));
					dataMap.put("All",validlist);
					  validUnitType = false;
					  manufacturercode = 0;
					  unitType = "";
					  unitstatus = "";
					  unitDetails.remarks ="";
			  }
		    }
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
				DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
				DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
			}
			return dataMap;
		}
		 
		public JSONArray getImportExcelUnitDetails(int clientId, int systemId, List<UnitDetailsData> list) {

			JSONArray unitDetaisJsonArray = null;
			JSONObject unitDetailsJsonObject = null;
			int count = 0;		
			try {
				unitDetaisJsonArray = new JSONArray();
				unitDetailsJsonObject = new JSONObject();		
							
				for (UnitDetailsData unitDetails : list) {
					count++;
					unitDetailsJsonObject = new JSONObject();

					unitDetailsJsonObject.put("importslnoIndex", count);
					unitDetailsJsonObject.put("importunitnoindex", unitDetails.unitNumber);
					unitDetailsJsonObject.put("importmanufacturerindex", unitDetails.manufacturer);
					unitDetailsJsonObject.put("importunittypeindex", unitDetails.unitType);
					unitDetailsJsonObject.put("importunitreferenceidindex", unitDetails.unitReferenceId);
					unitDetailsJsonObject.put("importstatusindex", unitDetails.status);
					unitDetailsJsonObject.put("importremarksindex", unitDetails.remarks);
					unitDetaisJsonArray.put(unitDetailsJsonObject);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} 
			return unitDetaisJsonArray;
		}
}
