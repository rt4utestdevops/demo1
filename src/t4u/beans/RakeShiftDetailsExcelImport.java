package t4u.beans;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

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

import t4u.common.DBConnection;
import t4u.sandmining.ILMSDetails;
import t4u.statements.RakeShiftingStatements;


public class RakeShiftDetailsExcelImport {

	
	public static JSONArray globalJsonArray = new JSONArray();
	public static ArrayList<RakeShiftDetails> rake_shiftImportedDetails = new ArrayList<RakeShiftDetails>();
	
	private File inFile;
	private String fileExtension;
	private int userId;
	private int systemId;
	private int clientId;
	//private int offset;
	
	private String containerNo;
	private String ContainerSize;
	private String loadType;
	private String location;
	private String shipperName;
	private String billingCustomer;
	private String weight;
	private String sb_blNo;
	private String status;
	private String remarks;
	
	private String status1;
	private String remarks1;
	private int rowNo;
	String message = "";
	String format = "";
	
	public RakeShiftDetailsExcelImport(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension){
		this.inFile = inFile;
		this.userId =  userId;
		this.systemId = systemId;
		this.clientId = clientId;
		//this.offset=offset;
		this.fileExtension = fileExtension;
	}
	
	@SuppressWarnings("deprecation")
	public String importExcelData(String bookingType){	
		String importMessage = "";
		List<RakeShiftDetails> list = new ArrayList();	
		
			try
			{
				if(bookingType.equals("1"))
				{
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
								for (int c = 0; c < 10; c++) {
									cell = row.getCell(c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												containerNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												containerNo = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										}else {
											containerNo = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												ContainerSize = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												ContainerSize = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											ContainerSize = "";
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												loadType = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												loadType = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											loadType = "";
										}
										break;
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												location = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												location = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												location = "";
											}else{
												format = "Invalid";
											}
										} else {
											location = "";
										}
										break;
									case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												shipperName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												shipperName = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												shipperName = "";
											}else{
												format = "Invalid";
											}
										} else {
											shipperName = "";
										}
										break;
									case 5:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												billingCustomer = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												billingCustomer = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												billingCustomer = "";
											}else{
												format = "Invalid";
											}
										} else {
											billingCustomer = "";
										}
										break;
									case 6:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												weight = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												weight = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												weight = "";
											}else{
												format = "Invalid";
											}
										} else {
											weight = "";
										}
										break;
									case 7:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												sb_blNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												sb_blNo = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												sb_blNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											sb_blNo = "";
										}
										break;	
									case 8:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												remarks = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												remarks = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												remarks = "";
											}else{
												format = "Invalid";
											}
										} else {
											remarks = "";
										}
										
										  list.add(new RakeShiftDetails(containerNo,ContainerSize,loadType,location,shipperName,billingCustomer,weight,sb_blNo,remarks,status1,""));
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
								for (int c = 0; c < 10; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												containerNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												containerNo = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										}else {
											containerNo = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												ContainerSize = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												ContainerSize = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											ContainerSize = "";
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												loadType = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												loadType = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											loadType = "";
										}
										break;
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												location = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												location = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												location = "";
											}else{
												format = "Invalid";
											}
										} else {
											location = "";
										}
										break;
									case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												shipperName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												shipperName = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												shipperName = "";
											}else{
												format = "Invalid";
											}
										} else {
											shipperName = "";
										}
										break;
									case 5:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												billingCustomer = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												billingCustomer = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												billingCustomer = "";
											}else{
												format = "Invalid";
											}
										} else {
											billingCustomer = "";
										}
										break;
									case 6:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												weight = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												weight = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												weight = "";
											}else{
												format = "Invalid";
											}
										} else {
											weight = "";
										}
										break;
									case 7:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												sb_blNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												sb_blNo = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												sb_blNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											sb_blNo = "";
										}
										break;
									case 8:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												remarks = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												remarks = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												remarks = "";
											}else{
												format = "Invalid";
											}
										} else {
											remarks = "";
										}
											  list.add(new RakeShiftDetails(containerNo,ContainerSize,loadType,location,shipperName,billingCustomer,weight,sb_blNo,remarks,status1,""));
											break;
									}															
								}							
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
			}
			else if(bookingType.equals("2"))
			{
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
								for (int c = 0; c < 10; c++) {
									cell = row.getCell(c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												containerNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												containerNo = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										}else {
											containerNo = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												ContainerSize = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												ContainerSize = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											ContainerSize = "";
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												loadType = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												loadType = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											loadType = "";
										}
										break;
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												location = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												location = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												location = "";
											}else{
												format = "Invalid";
											}
										} else {
											location = "";
										}
										break;
									case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												remarks = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												remarks = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												remarks = "";
											}else{
												remarks = "Invalid";
											}
										} else {
											remarks = "";
										}
										
										  list.add(new RakeShiftDetails(containerNo,ContainerSize,loadType,location,shipperName,billingCustomer,weight,sb_blNo,remarks,status1,""));
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
								for (int c = 0; c < 10; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												containerNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												containerNo = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										}else {
											containerNo = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												ContainerSize = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												ContainerSize = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											ContainerSize = "";
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												loadType = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												loadType = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											loadType = "";
										}
										break;
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												location = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												location = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												location = "";
											}else{
												format = "Invalid";
											}
										} else {
											location = "";
										}
										break;
									case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												remarks = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												remarks = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												remarks = "";
											}else{
												format = "Invalid";
											}
										} else {
											remarks = "";
										}
										
											list.add(new RakeShiftDetails(containerNo,ContainerSize,loadType,location,shipperName,billingCustomer,weight,sb_blNo,remarks,status1,""));
											break;
									}															
								}							
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
					}
				}
				globalJsonArray  = null;
				rake_shiftImportedDetails=getValidILMSDetails(list,systemId,userId,bookingType);
				globalJsonArray = getImportExcelUnitDetails(clientId, systemId,rake_shiftImportedDetails);
				if(globalJsonArray != null && globalJsonArray.length() > 0){
					importMessage = "Success";
				}
			}
			catch(Exception e){
				e.printStackTrace();
			}
			return importMessage;
		}
	
	/** return message */
	public String getMessage(){
		return message;
	}
	
	public ArrayList<RakeShiftDetails> getValidILMSDetails(List<RakeShiftDetails> list,int systemId,int userId, String bookingType) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String rakeShiftStatus = "";
		ArrayList<RakeShiftDetails> validlist = new ArrayList();
		SimpleDateFormat ddmmyyyyHHMMSS = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		String regex = "^[A-Za-z]{4}[0-9]{6}[0-9]{1}$";
		String regaxWeight = "^[0-9]\\d{0,9}(\\.\\d{1,2})?%?$";
		//   ([0-9]+([.][0-9]*)?|[.][0-9]+)";
		//	date = ddmmyyyy.format(ddmmyyyyHHMMSS.parse(date));
		try {
			if(list.size()!=0 && !format.equalsIgnoreCase("Invalid")){
			for (RakeShiftDetails rakeShiftDetails : list) {
			    if(!rakeShiftDetails.containerNo.matches(regex)){
			    	rakeShiftDetails.remarks1 = "Invalid Container Number";
				}
			    if(!(rakeShiftDetails.ContainerSize.equalsIgnoreCase("20ft") || rakeShiftDetails.ContainerSize.equalsIgnoreCase("40ft"))){
			    	rakeShiftDetails.remarks1 = "Invalid Container Size";
				}
			    if( !(rakeShiftDetails.loadType.equalsIgnoreCase("Loaded") || rakeShiftDetails.loadType.equalsIgnoreCase("Empty"))){
			    	rakeShiftDetails.remarks1 = "Invalid Load Type";
				}
				if(rakeShiftDetails.location==""){
					rakeShiftDetails.remarks1 = "Invalid Location.";
				}
				else
				{
					con = DBConnection.getConnectionToDB("AMS");
					pstmt = con.prepareStatement(RakeShiftingStatements.SELECT_RAKE_LOCATION_VALIDATE);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setString(3,rakeShiftDetails.location);
					rs = pstmt.executeQuery();
					if (!rs.next()){
						rakeShiftDetails.remarks1 = "Invalid Location.";
					}
				}
				if(!bookingType.equals("2")){
					if(rakeShiftDetails.shipperName==""){
						rakeShiftDetails.remarks1 = " Invalid Shipper Name.";
					}
					if(rakeShiftDetails.billingCustomer==""){
						rakeShiftDetails.remarks1 = " Invalid Billing Customer.";
					}
					else
					{
						con = DBConnection.getConnectionToDB("AMS");
						pstmt = con.prepareStatement(RakeShiftingStatements.SELECT_RAKE_BILLING_VALIDATE);
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, clientId);
						pstmt.setString(3,rakeShiftDetails.billingCustomer);
						rs = pstmt.executeQuery();
						if (!rs.next()){
							rakeShiftDetails.remarks1 = "Invalid Billing Customer";
						}
					}
					if(!rakeShiftDetails.weight.matches(regaxWeight))
					{
						rakeShiftDetails.remarks1="Invalid Weight";
					}
					if(rakeShiftDetails.weight.charAt(0)=='0')
					{
						rakeShiftDetails.remarks1="Invalid Weight";
					}
				}
				if(!(rakeShiftDetails.remarks1.contains("Invalid"))){
					if(!rakeShiftDetails.remarks1.contains("Duplicate")){
						rakeShiftStatus = "Valid";
					}
				}
				if(rakeShiftStatus == ""){
					rakeShiftStatus = "Invalid";
				}
				
				validlist.add(new RakeShiftDetails(rakeShiftDetails.containerNo,rakeShiftDetails.ContainerSize,rakeShiftDetails.loadType,rakeShiftDetails.location,rakeShiftDetails.shipperName,rakeShiftDetails.billingCustomer,rakeShiftDetails.weight,rakeShiftDetails.sb_blNo,rakeShiftDetails.remarks,rakeShiftStatus,rakeShiftDetails.remarks1));
				rakeShiftDetails.remarks1 = "";
				rakeShiftStatus = "";
		  //}
		}
	    }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return validlist;
	}
	
	private JSONArray getImportExcelUnitDetails(int clientId2, int systemId2,List<RakeShiftDetails> validSimDetails) throws JSONException {
		JSONArray ar=new JSONArray();
		for (RakeShiftDetails il : validSimDetails) {
		JSONObject obj=new JSONObject();
		obj.put("importContainerNoIndex", il.containerNo);	
		obj.put("importContainerSizeIndex", il.ContainerSize);	
		obj.put("importLoadTypeIndex", il.loadType);	
		obj.put("importLocationIndex", il.location);	
		obj.put("importShipperNameIndex", il.shipperName);	
		obj.put("importBillingCustomerIndex", il.billingCustomer);	
		obj.put("importWeightIndex", il.weight);	
		obj.put("importSBBLNoIndex", il.sb_blNo);
		obj.put("importstatusindex", "Pending");	
		obj.put("importremarksindex", il.remarks);
		obj.put("importValidstatusIndex", il.status1);
		obj.put("importValidremarksIndex", il.remarks1);
		ar.put(obj);
		}
		return ar;
	}
	
}
