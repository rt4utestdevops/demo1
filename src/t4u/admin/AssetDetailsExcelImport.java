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

public class AssetDetailsExcelImport {
	static JSONArray globalJsonArray = new JSONArray();
	static Map<String,List<AssetDetailsData>>  dataMap = new HashMap<String, List<AssetDetailsData>>();

	private File inFile;
	private String fileExtension;	
	private int systemId;
	private int clientId;	

	private String oldAssetNo;
	private String newAssetNo;	
	private String status;
	private String remarks;

	private int rowNo;
	String message = "";
	String format = "";

	AssetDetailsExcelImport(File inFile,int systemId,int clientId, String fileExtension){
		this.inFile = inFile;		
		this.systemId = systemId;
		this.clientId = clientId;		
		this.fileExtension = fileExtension;
	}

	public AssetDetailsExcelImport() {

	}

	public String getMessage(){
		return message;
	}

	public String importExcelData(){	
		String importMessage = "";
		List<AssetDetailsData> list = new ArrayList();	

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
							for (int c = 0; c < 2; c++) {
								cell = row.getCell((short) c);
								// If cell contains String value
								switch (c) {
								case 0:
									if (cell != null){ 
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											oldAssetNo = cell.getStringCellValue().toUpperCase();
										else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											oldAssetNo = cell.getStringCellValue().toUpperCase();
										}else{
											format = "Invalid";
										}
									}else {
										oldAssetNo = "";
									}
									break;
								case 1:
									if (cell != null){ 
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											newAssetNo = cell.getStringCellValue().toUpperCase();
										else  if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											newAssetNo = cell.getStringCellValue().toUpperCase();
										}
										else{
											format = "Invalid";
										}
									} else {
										newAssetNo = "";
									}
									if(!oldAssetNo.equals("") || !newAssetNo.equals(""))
										list.add(new AssetDetailsData(oldAssetNo.trim(),newAssetNo.trim(),"",""));
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
							for (int c = 0; c < 2; c++) {
								cell = row.getCell((short) c);
								// If cell contains String value
								switch (c) {
								case 0:
									if (cell != null){ 
										if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
											oldAssetNo = cell.getStringCellValue().toUpperCase();
										else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(XSSFCell.CELL_TYPE_STRING);
											oldAssetNo = cell.getStringCellValue().toUpperCase();
										}
										else{
											format = "Invalid";
										}
									} else {
										oldAssetNo = "";
									}
									break;
								case 1:
									if (cell != null){ 
										if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
											newAssetNo = cell.getStringCellValue().toUpperCase();
										else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(XSSFCell.CELL_TYPE_STRING);
											newAssetNo = cell.getStringCellValue().toUpperCase();
										}
										else{
											format = "Invalid";
										}
									} else {
										newAssetNo = "";
									}
									if(!oldAssetNo.equals("") || !newAssetNo.equals(""))
										list.add(new AssetDetailsData(oldAssetNo.trim(),newAssetNo.trim(),"",""));
									break;								
								}	
							}							
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			dataMap = getValidUnitDetails(list,systemId,clientId);
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


	public Map<String,List<AssetDetailsData>> getValidUnitDetails(List<AssetDetailsData> list,int systemId,int clientId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;	
		ResultSet rs = null;
		ResultSet rs1 = null;

		Map<String, List<AssetDetailsData>> dataMap = new HashMap<String, List<AssetDetailsData>>();
		List<AssetDetailsData> validlist = new ArrayList();
		List<AssetDetailsData> validSavelist = new ArrayList();
		String unitstatus = "Valid";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(list.size()!=0 && !format.equalsIgnoreCase("Invalid")){
				for (AssetDetailsData assetDetails : list) {
					if(assetDetails.oldAssetNo.equals("") || assetDetails.oldAssetNo.equals(" ") ){
						assetDetails.remarks = " Invalid Old Asset Number .";
						unitstatus = "Invalid";
					}else{
						pstmt = con.prepareStatement(AdminStatements.CHECK_IF_EXISIST_IN_VEHICLE_CLIENT);
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, clientId);
						pstmt.setString(3, assetDetails.oldAssetNo);
						rs = pstmt.executeQuery();
						if (!rs.next()){
							unitstatus = "Invalid";
							assetDetails.remarks = "Old Asset Number Not Registered With Selected Customer ";
						}else{
							if(assetDetails.newAssetNo.equals("") || assetDetails.newAssetNo.equals(" ")){
								assetDetails.remarks = " Invalid New Asset Number .";
								unitstatus = "Invalid";
							}else{
							pstmt1 = con.prepareStatement(AdminStatements.CHECK_IF_VEHICLE_REGISTERED_AND_STATUS_IS_ACTIVE);
							pstmt1.setString(1, "Active");
							pstmt1.setString(2, assetDetails.newAssetNo.replace(" ", ""));
							rs1 = pstmt1.executeQuery();
							if(rs1.next()){
								unitstatus = "Invalid";
								assetDetails.remarks = "New Asset Number already exist";	
							}else{
								unitstatus = "Valid";								
							}	
							}
						}
					}
					if(!(assetDetails.remarks.contains("already") || assetDetails.remarks.contains("Invalid") || assetDetails.remarks.contains("Not"))){

						for (AssetDetailsData ud : validlist) {
							if(ud.oldAssetNo.equalsIgnoreCase(assetDetails.oldAssetNo)){
								unitstatus = "Invalid";
								assetDetails.remarks = "Old Asset Number is Duplicate";
							}
						}
						for (AssetDetailsData ud : validlist) {
							if(ud.newAssetNo.equalsIgnoreCase(assetDetails.newAssetNo)){
								unitstatus = "Invalid";
								assetDetails.remarks = "New Asset Number is Duplicate";
							}
						}
						if(!assetDetails.remarks.contains("Duplicate")){
							validSavelist.add(new AssetDetailsData(assetDetails.oldAssetNo,assetDetails.newAssetNo,"",""));								
							unitstatus = "Valid";
						}
					}
					if(unitstatus.equals("")){
						unitstatus = "Invalid";
					}
					validlist.add(new AssetDetailsData(assetDetails.oldAssetNo,assetDetails.newAssetNo,unitstatus,assetDetails.remarks));
					dataMap.put("Valid",validSavelist);
					dataMap.put("All",validlist);					
					unitstatus = "";
					assetDetails.remarks ="";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);		
		}
		return dataMap;
	}

	public JSONArray getImportExcelUnitDetails(int clientId, int systemId, List<AssetDetailsData> list) {

		JSONArray unitDetaisJsonArray = null;
		JSONObject unitDetailsJsonObject = null;
		int count = 0;		
		try {
			unitDetaisJsonArray = new JSONArray();
			unitDetailsJsonObject = new JSONObject();		

			for (AssetDetailsData assetDetails : list) {
				count++;
				unitDetailsJsonObject = new JSONObject();
				unitDetailsJsonObject.put("importslnoIndex", count);
				unitDetailsJsonObject.put("importOldAssetNoindex", assetDetails.oldAssetNo);
				unitDetailsJsonObject.put("importnewAssetNoindex", assetDetails.newAssetNo);				
				unitDetailsJsonObject.put("importstatusindex", assetDetails.status);
				unitDetailsJsonObject.put("importremarksindex", assetDetails.remarks);
				unitDetaisJsonArray.put(unitDetailsJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return unitDetaisJsonArray;		
	}
}
