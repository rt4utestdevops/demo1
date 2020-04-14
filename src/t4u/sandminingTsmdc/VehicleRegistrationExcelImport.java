package t4u.sandminingTsmdc;

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

public class VehicleRegistrationExcelImport {
	
		static JSONArray globalJsonArray = new JSONArray();
		static Map<String,List<VehicleRegistrationDetailsData>>  dataMap = new HashMap<String, List<VehicleRegistrationDetailsData>>();
		private File inFile;
		private String fileExtension;
		private int userId;
		private int systemId;
		private int clientId;
		private int offset;
		
		private String vehicleNumber;
		private String chassisNumber;
		private String ownerName;
		private String vehicleCapacity;
		private String status;
		private String remarks;
	
		private int rowNo;
		String message = "";
		String format = "";
		
		public VehicleRegistrationExcelImport(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension){
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
		List<VehicleRegistrationDetailsData> list = new ArrayList();	
		
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
												vehicleNumber = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												vehicleNumber = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										}else {
											vehicleNumber = "";
										}
										break;
									case 1:
										if (cell != null){ 
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												chassisNumber = cell.getStringCellValue();
											else  if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												chassisNumber = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											chassisNumber = "";
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												ownerName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												ownerName = cell.getStringCellValue();
											}
											else{												
												format = "Invalid";
											}
										} else {
											ownerName = "";
										}
										break;
									case 3:
										if (cell != null){ 
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												vehicleCapacity = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												vehicleCapacity = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											vehicleCapacity = "";
										}
									//	if(vehicleNumber!="" || chassisNumber!="" || ownerName!="" || vehicleCapacity!="")
										if(vehicleNumber!="")
											  list.add(new VehicleRegistrationDetailsData(vehicleNumber,chassisNumber,ownerName,vehicleCapacity,"",""));
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
												vehicleNumber = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												vehicleNumber = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											vehicleNumber = "";
										}
										break;
									case 1:
										if (cell != null){ 
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												chassisNumber = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												chassisNumber = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											chassisNumber = "";
										}
										break;
									case 2:
										if (cell != null) {
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
												ownerName = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												ownerName = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											ownerName = "";
										}
										break;
									case 3:
										if (cell != null){ 
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
												vehicleCapacity = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												vehicleCapacity = cell.getStringCellValue();
											}
											else{	
												format = "Invalid";
											}
										} else {
											vehicleCapacity = "";
										}
									//	if(vehicleNumber!="" || chassisNumber!="" || ownerName!="" || vehicleCapacity!="")
										if(vehicleNumber!="")
											 list.add(new VehicleRegistrationDetailsData(vehicleNumber,chassisNumber,ownerName,vehicleCapacity,"",""));
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

		
	public Map<String,List<VehicleRegistrationDetailsData>> getValidUnitDetails(List<VehicleRegistrationDetailsData> list,int systemId,int userId) {
			Connection con = null;
			PreparedStatement pstmt = null;
			PreparedStatement pstmt1 = null;
			PreparedStatement pstmt2 = null;
			ResultSet rs = null;
			ResultSet rs1 = null;
			ResultSet rs2 = null;
			Map<String, List<VehicleRegistrationDetailsData>> dataMap = new HashMap<String, List<VehicleRegistrationDetailsData>>();
			List<VehicleRegistrationDetailsData> validlist = new ArrayList();
			List<VehicleRegistrationDetailsData> validSavelist = new ArrayList();
			String vehiclestatus = "";
			
			try {
				con = DBConnection.getConnectionToDB("AMS");
				if(list.size()!=0 && !format.equalsIgnoreCase("Invalid")){
				for (VehicleRegistrationDetailsData VehicleDetails : list) {
					if(VehicleDetails.vehicleNumber==""){
						VehicleDetails.remarks = " Invalid Vehicle Number .";
					}else{
					pstmt = con.prepareStatement(SandTSMDCStatement.SELECT_VEHICLE_NO_VALIDITY);
					pstmt.setString(1,VehicleDetails.vehicleNumber);
					rs = pstmt.executeQuery();
					if (rs.next()){
						VehicleDetails.remarks = " Vehicle Number already exist";
					}
				  }
			/*		if(VehicleDetails.chassisNumber==""){
						VehicleDetails.remarks = " Invalid Chassis Number";
					}
					if(VehicleDetails.ownerName==""){
						VehicleDetails.remarks = " Invalid owner name";
					}
					if(VehicleDetails.vehicleCapacity==""){
						VehicleDetails.remarks = " Invalid vehicle cpacity";
					} */
					if(!(VehicleDetails.remarks.contains("already") || VehicleDetails.remarks.contains("Invalid"))){
						if(validlist.size()!=0){
							for (VehicleRegistrationDetailsData ud : validlist) {
								if(ud.vehicleNumber.equalsIgnoreCase(VehicleDetails.vehicleNumber)){
								    vehiclestatus = "Invalid";
								    VehicleDetails.remarks = " Vehicle Number is Duplicate";
								}
							}
						}
						if(!VehicleDetails.remarks.contains("Duplicate")){
						validSavelist.add(new VehicleRegistrationDetailsData(VehicleDetails.vehicleNumber,VehicleDetails.chassisNumber+"",VehicleDetails.ownerName,VehicleDetails.vehicleCapacity,"",""));
						dataMap.put("Valid",validSavelist);
						vehiclestatus = "Valid";
						}
					}
					if(vehiclestatus == ""){
						vehiclestatus = "Invalid";
					}
					validlist.add(new VehicleRegistrationDetailsData(VehicleDetails.vehicleNumber,VehicleDetails.chassisNumber,VehicleDetails.ownerName,VehicleDetails.vehicleCapacity,vehiclestatus,VehicleDetails.remarks));
					dataMap.put("All",validlist);
					  vehiclestatus = "";
					  VehicleDetails.remarks ="";
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
		 
		public JSONArray getImportExcelUnitDetails(int clientId, int systemId, List<VehicleRegistrationDetailsData> list) {

			JSONArray unitDetaisJsonArray = null;
			JSONObject unitDetailsJsonObject = null;
			int count = 0;		
			try {
				unitDetaisJsonArray = new JSONArray();
				unitDetailsJsonObject = new JSONObject();		
							
				for (VehicleRegistrationDetailsData VehicleDetails : list) {
					count++;
					unitDetailsJsonObject = new JSONObject();

					unitDetailsJsonObject.put("importslnoIndex", count);
					unitDetailsJsonObject.put("importVehicleNoindex", VehicleDetails.vehicleNumber);
					unitDetailsJsonObject.put("importChassisNoindex", VehicleDetails.chassisNumber);
					unitDetailsJsonObject.put("importOwnerNameindex", VehicleDetails.ownerName);
					unitDetailsJsonObject.put("importVehicleCapacityindex", VehicleDetails.vehicleCapacity);
					unitDetailsJsonObject.put("importstatusindex", VehicleDetails.status);
					unitDetailsJsonObject.put("importremarksindex", VehicleDetails.remarks);
					unitDetaisJsonArray.put(unitDetailsJsonObject);
				}
			} catch (Exception e) {
				e.printStackTrace();
			} 
			return unitDetaisJsonArray;
		}
}
