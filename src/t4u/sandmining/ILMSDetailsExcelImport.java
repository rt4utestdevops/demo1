package t4u.sandmining;

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
import org.apache.poi.ss.format.CellDateFormatter;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.admin.SimDetailsData;
import t4u.common.DBConnection;
import t4u.statements.AdminStatements;
import t4u.statements.SandMiningStatements;

public class ILMSDetailsExcelImport {
	
	static JSONArray globalJsonArray = new JSONArray();
	static ArrayList<ILMSDetails> allILMSImporteddetails = new ArrayList<ILMSDetails>();
	
	
	private File inFile;
	private String fileExtension;
	private int userId;
	private int systemId;
	private int clientId;
	private int offset;
	
	private String MMPS_Tripsheet_Id;
	private String MMPS_TripsheetCode;
	private String PermitNo;
	private String LeaseCode;
	private String Leasee_Name;
	private String mineral;
	private String grade;
	private String miningPlace_E;
	private String TotalQuantity;
	private String issueStatus;
	private String journyStartDate;
	private String journyEndDate;
	private String buyer;
	private String destination;
	private String hologramCode;
	private String vehicleNo;
	private String passIssueDate;
	private String actualWeight;
	private String transporterName;
	private String distance;
	private String TSrNo;
	private String villageName;
	private String routeDescription;
	private String pwdFees;
	private String weighWeight;
	private String appType;
	private String tripSheetType;
	private String unit;
	private String cancelReason;
	private String printReason;
	private String transferReason;
	private String certNo;
	
	private String status;
	private String remarks;
	private int rowNo;
	String message = "";
	String format = "";
	String fromDate="";
	String toDate="";
	int dateFormate=1;
	Date compdateFrom,compdateTo;
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	public ILMSDetailsExcelImport(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension,String fromDate,String toDate,int dateFormate){
		this.inFile = inFile;
		this.userId =  userId;
		this.systemId = systemId;
		this.clientId = clientId;
		this.offset=offset;
		this.fileExtension = fileExtension;
		this.fromDate=fromDate;
		this.toDate=toDate;
		this.dateFormate=dateFormate;
		try {
			this.compdateFrom=ddmmyyyy.parse(fromDate);
			this.compdateTo=ddmmyyyy.parse(toDate);
		} catch (ParseException e) {			
			e.printStackTrace();
		}
	}
	
	/** return message */
	public String getMessage(){
		return message;
	}
	
	@SuppressWarnings("deprecation")
	public String importExcelData(){	
		String importMessage = "";
		List<ILMSDetails> list = new ArrayList();	
		
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
						
						Date dateFrom=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").parse(fromDate);
						Date dateTo=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").parse(toDate);
						DataFormatter onlyForDate= new DataFormatter();
						boolean isValid=false;
						// Loop for traversing each row in the spreadsheet
						for (int r = 0; r < nRows; r++) {
							rowNo = r;
							rowNo++;
							row = sheet.getRow(rowNo);
							if (row != null) {
								// Column count in the current row
								cols = sheet.getRow(r).getLastCellNum();
								// Loop for traversing each column in each row in the spreadsheet
								isValid=isValid(dateFrom,dateTo,onlyForDate.formatCellValue(row.getCell(16)));
								for (int c = 0; c < 32; c++) {
									cell = row.getCell(c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												MMPS_Tripsheet_Id = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												MMPS_Tripsheet_Id = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										}else {
											MMPS_Tripsheet_Id = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												MMPS_TripsheetCode = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												MMPS_TripsheetCode = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											MMPS_TripsheetCode = "";
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												PermitNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												PermitNo = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											PermitNo = "";
										}
										break;
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												LeaseCode = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												LeaseCode = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												LeaseCode = "";
											}else{
												format = "Invalid";
											}
										} else {
											LeaseCode = "";
										}
										break;
									case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												Leasee_Name = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												Leasee_Name = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												Leasee_Name = "";
											}else{
												format = "Invalid";
											}
										} else {
											Leasee_Name = "";
										}
										break;
									case 5:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												mineral = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												mineral = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												mineral = "";
											}else{
												format = "Invalid";
											}
										} else {
											mineral = "";
										}
										break;
									case 6:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												grade = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												grade = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												grade = "";
											}else{
												format = "Invalid";
											}
										} else {
											grade = "";
										}
										break;
									case 7:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												miningPlace_E = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												miningPlace_E = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												miningPlace_E = "";
											}else{
												format = "Invalid";
											}
										} else {
											miningPlace_E = "";
										}
										break;
									case 8:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												TotalQuantity = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												TotalQuantity = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												TotalQuantity = "";
											}else{
												format = "Invalid";
											}
										} else {
											TotalQuantity = "";
										}
										break;
									case 9:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												issueStatus = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												issueStatus = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												issueStatus = "";
											}else{
												format = "Invalid";
											}
										} else {
											issueStatus = "";
										}
										break;
									case 10:
										if (cell != null){
											Date str=null;
											String str1=null;
											if(dateFormate == 1){
											if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
                                            	DataFormatter dataFormatter= new DataFormatter(); 
                                            	String dateformatstring = "dd/MM/yyyy HH:mm";
                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yy HH:mm");
                                            	str1 = dataFormatter.formatCellValue(cell);
                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(str1);
                                            }
                                            else{
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(cell.getStringCellValue());
                                                // str=cell.getDateCellValue();
                                            }
										}
											else if(dateFormate == 2){
												if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
	                                            	DataFormatter dataFormatter= new DataFormatter(); 
	                                            	String dateformatstring = "MM/dd/yyyy HH:mm";
	                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yy HH:mm");
	                                            	str1 = dataFormatter.formatCellValue(cell);
	                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
	                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(str1);
	                                            }
	                                            else{
	                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(cell.getStringCellValue());
	                                                // str=cell.getDateCellValue();
	                                            }
											}
												try{
													SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
													SimpleDateFormat dateFormatddmmyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
													journyStartDate = dateFormatddmmyy.format(str);
												}catch (Exception e) {
													journyStartDate=cell.getStringCellValue() + "Invalid";
												}
										} else {
											journyStartDate = "";
										}
										break;
									case 11:
										if (cell != null){
											Date str=null;
											String str1=null;
											if(dateFormate == 1){
											if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
                                            	DataFormatter dataFormatter= new DataFormatter(); 
                                            	String dateformatstring = "dd/MM/yyyy HH:mm";
                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yy HH:mm");
                                            	str1 = dataFormatter.formatCellValue(cell);
                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(str1);
                                            }
                                            else{
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(cell.getStringCellValue());
                                                // str=cell.getDateCellValue();
                                            }
										}
											else if(dateFormate == 2){
												if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
	                                            	DataFormatter dataFormatter= new DataFormatter(); 
	                                            	String dateformatstring = "MM/dd/yyyy HH:mm";
	                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yy HH:mm");
	                                            	str1 = dataFormatter.formatCellValue(cell);
	                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
	                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(str1);
	                                            }
	                                            else{
	                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(cell.getStringCellValue());
	                                                // str=cell.getDateCellValue();
	                                            }
											}
												try{
													SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
													SimpleDateFormat dateFormatddmmyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
													journyEndDate = dateFormatddmmyy.format(str);
												}catch (Exception e) {
													journyEndDate=cell.getStringCellValue() + "Invalid";
												}
										} else {
											journyEndDate = "";
										}
										break;
									case 12:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												buyer = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												buyer = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												buyer = "";
											}else{
												format = "Invalid";
											}
										} else {
											buyer = "";
										}
										break;
									case 13:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												destination = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												destination = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												destination = "";
											}else{
												format = "Invalid";
											}
										} else {
											destination = "";
										}
										break;
									case 14:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												hologramCode = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												hologramCode = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												hologramCode = "";
											}else{
												format = "Invalid";
											}
										} else {
											hologramCode = "";
										}
										break;
									case 15:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												vehicleNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												vehicleNo = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											vehicleNo = "";
										}
										break;
									case 16:
										if (cell != null){
											Date str=null;
											String str1=null;
											if(dateFormate == 1){
											if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
                                            	DataFormatter dataFormatter= new DataFormatter(); 
                                            	String dateformatstring = "dd/MM/yyyy HH:mm:ss";
                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
                                            	str1 = dataFormatter.formatCellValue(cell);
                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").parse(str1);
                                            }
                                            else{
                                            	str=new SimpleDateFormat("dd/MM/yyyy hh:mm:ss a").parse(cell.getStringCellValue());
                                                // str=cell.getDateCellValue();
                                            }
										}
											else if(dateFormate == 2){
												if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
	                                            	DataFormatter dataFormatter= new DataFormatter(); 
	                                            	String dateformatstring = "MM/dd/yyyy HH:mm:ss";
	                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yy HH:mm:ss");
	                                            	str1 = dataFormatter.formatCellValue(cell);
	                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
	                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm:ss").parse(str1);
	                                            }
	                                            else{
	                                            	str=new SimpleDateFormat("MM/dd/yyyy hh:mm:ss a").parse(cell.getStringCellValue());
	                                                // str=cell.getDateCellValue();
	                                            }
											}
												try{
													SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
													SimpleDateFormat dateFormatddmmyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
													passIssueDate = dateFormatddmmyy.format(str);
												}catch (Exception e) {
													passIssueDate=cell.getStringCellValue() + "Invalid";
												}
										} else {
											passIssueDate = "";
										}
										break;
									case 17:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												actualWeight = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												actualWeight = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												actualWeight = "";
											}else{
												format = "Invalid";
											}
										} else {
											actualWeight = "";
										}
										break;
									case 18:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												transporterName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												transporterName = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												transporterName = "";
											}else{
												format = "Invalid";
											}
										} else {
											transporterName = "";
										}
										break;
									case 19:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												distance = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												distance = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												distance = "";
											}else{
												format = "Invalid";
											}
										} else {
											distance = "";
										}
										break;
									case 20:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												TSrNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												TSrNo = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												TSrNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											TSrNo = "";
										}
										break;
									case 21:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												villageName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												villageName = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												villageName = "";
											}else{
												format = "Invalid";
											}
										} else {
											villageName = "";
										}
										break;
									case 22:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												routeDescription = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												routeDescription = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												routeDescription = "";
											}else{
												format = "Invalid";
											}
										} else {
											routeDescription = "";
										}
										break;
									case 23:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												pwdFees = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												pwdFees = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												pwdFees = "";
											}else{
												format = "Invalid";
											}
										} else {
											pwdFees = "";
										}
										break;
									case 24:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												weighWeight = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												weighWeight = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												weighWeight = "";
											}else{
												format = "Invalid";
											}
										} else {
											weighWeight = "";
										}
										break;
									case 25:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												appType = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												appType = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												appType = "";
											}else{
												format = "Invalid";
											}
										} else {
											appType = "";
										}
										break;
									case 26:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												tripSheetType = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												tripSheetType = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												tripSheetType = "";
											}else{
												format = "Invalid";
											}
										} else {
											tripSheetType = "";
										}
										break;
									case 27:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												unit = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												unit = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												unit = "";
											}else{
												format = "Invalid";
											}
										} else {
											unit = "";
										}
										break;
									case 28:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												cancelReason = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												cancelReason = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												cancelReason = "";
											}else{
												format = "Invalid";
											}
										} else {
											cancelReason = "";
										}
										break;
									case 29:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												printReason = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												printReason = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												printReason = "";
											}else{
												format = "Invalid";
											}
										} else {
											printReason = "";
										}
										break;
									case 30:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												transferReason = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												transferReason = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												transferReason = "";
											}else{
												format = "Invalid";
											}
										} else {
											transferReason = "";
										}
										break;
									case 31:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												certNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												certNo = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												certNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											certNo = "";
										}
										if(isValid)
										if(MMPS_Tripsheet_Id!="" || MMPS_TripsheetCode!="" || PermitNo!="" || journyStartDate!="" || journyEndDate!="" || vehicleNo!="" || passIssueDate!="" || status!="")
										  list.add(new ILMSDetails(MMPS_Tripsheet_Id,MMPS_TripsheetCode,PermitNo,LeaseCode,Leasee_Name,mineral,grade,miningPlace_E,TotalQuantity,issueStatus,journyStartDate,journyEndDate,buyer,destination,hologramCode,vehicleNo,passIssueDate,actualWeight,transporterName,distance,TSrNo,villageName,routeDescription,pwdFees,weighWeight,appType,tripSheetType,unit,cancelReason,printReason,transferReason,certNo,status," "));
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
						
						Date dateFrom=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").parse(fromDate);
						Date dateTo=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss").parse(toDate);
						DataFormatter onlyForDate= new DataFormatter();
						boolean isValid=false;
						// Loop for traversing each row in the spreadsheet
						for (int r = 0; r < nRows; r++) {
							rowNo = r;
							rowNo++;
							row = sheet.getRow(rowNo);
							
							if (row != null) {
								// Column count in the current row
								cols = sheet.getRow(r).getLastCellNum();
								
								isValid=isValid(dateFrom,dateTo,onlyForDate.formatCellValue(row.getCell(16)));
								// Loop for traversing each column in each row in the spreadsheet
								for (int c = 0; c < 32; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
												MMPS_Tripsheet_Id = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												MMPS_Tripsheet_Id = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										}else {
											MMPS_Tripsheet_Id = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												MMPS_TripsheetCode = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												MMPS_TripsheetCode = cell.getStringCellValue();
											}
											else{
												format = "Invalid";
											}
										} else {
											MMPS_TripsheetCode = "";
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												PermitNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												PermitNo = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											PermitNo = "";
										}
										break;
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												LeaseCode = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												LeaseCode = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												LeaseCode = "";
											}else{
												format = "Invalid";
											}
										} else {
											LeaseCode = "";
										}
										break;
									case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												Leasee_Name = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												Leasee_Name = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												Leasee_Name = "";
											}else{
												format = "Invalid";
											}
										} else {
											Leasee_Name = "";
										}
										break;
									case 5:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												mineral = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												mineral = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												mineral = "";
											}else{
												format = "Invalid";
											}
										} else {
											mineral = "";
										}
										break;
									case 6:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												grade = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												grade = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												grade = "";
											}else{
												format = "Invalid";
											}
										} else {
											grade = "";
										}
										break;
									case 7:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												miningPlace_E = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												miningPlace_E = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												miningPlace_E = "";
											}else{
												format = "Invalid";
											}
										} else {
											miningPlace_E = "";
										}
										break;
									case 8:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												TotalQuantity = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												TotalQuantity = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												TotalQuantity = "";
											}else{
												format = "Invalid";
											}
										} else {
											TotalQuantity = "";
										}
										break;
									case 9:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												issueStatus = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												issueStatus = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												issueStatus = "";
											}else{
												format = "Invalid";
											}
										} else {
											issueStatus = "";
										}
										break;
									case 10:
										if (cell != null){
											Date str=null;
											String str1=null;
											if(dateFormate == 1){
                                            if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
                                            	DataFormatter dataFormatter= new DataFormatter(); 
                                            	String dateformatstring = "dd/MM/yyyy HH:mm";
                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yy HH:mm");
                                            	str1 = dataFormatter.formatCellValue(cell);
                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(str1);
                                            }
                                            else{
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(cell.getStringCellValue());
                                                // str=cell.getDateCellValue();
                                            }
										}
										else if(dateFormate == 2){
											if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
                                            	DataFormatter dataFormatter= new DataFormatter(); 
                                            	String dateformatstring = "MM/dd/yyyy HH:mm";
                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yy HH:mm");
                                            	str1 = dataFormatter.formatCellValue(cell);
                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(str1);
                                            }
                                            else{
                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(cell.getStringCellValue());
                                                // str=cell.getDateCellValue();
                                            }
										}
												try{
													SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
													SimpleDateFormat dateFormatddmmyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
													journyStartDate = dateFormatddmmyy.format(str);
												}catch (Exception e) {
													journyStartDate=cell.getStringCellValue() + "Invalid";
												}
										} else {
											journyStartDate = "";
										}
										break;
									case 11:
										if (cell != null){
											Date str=null;
											String str1=null;
											if(dateFormate == 1){
											if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
												DataFormatter dataFormatter= new DataFormatter(); 
                                            	String dateformatstring = "dd/MM/yyyy HH:mm";
                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yy HH:mm");
                                            	str1 = dataFormatter.formatCellValue(cell);
                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(str1);
                                            }
                                            else{
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(cell.getStringCellValue());
                                                // str=cell.getDateCellValue();
                                            }
										}
											else if(dateFormate == 2){
												if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
	                                            	DataFormatter dataFormatter= new DataFormatter(); 
	                                            	String dateformatstring = "MM/dd/yyyy HH:mm";
	                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yy HH:mm");
	                                            	str1 = dataFormatter.formatCellValue(cell);
	                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
	                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(str1);
	                                            }
	                                            else{
	                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(cell.getStringCellValue());
	                                                // str=cell.getDateCellValue();
	                                            }
											}
												try{
													SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
													SimpleDateFormat dateFormatddmmyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
													journyEndDate = dateFormatddmmyy.format(str);
												}catch (Exception e) {
													journyEndDate=cell.getStringCellValue() + "Invalid";
												}
										} else {
											journyEndDate = "";
										}
										break;
									case 12:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												buyer = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												buyer = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												buyer = "";
											}else{
												format = "Invalid";
											}
										} else {
											buyer = "";
										}
										break;
									case 13:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												destination = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												destination = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												destination = "";
											}else{
												format = "Invalid";
											}
										} else {
											destination = "";
										}
										break;
									case 14:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												hologramCode = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												hologramCode = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												hologramCode = "";
											}else{
												format = "Invalid";
											}
										} else {
											hologramCode = "";
										}
										break;
									case 15:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												vehicleNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												vehicleNo = cell.getStringCellValue();
											}else{
												format = "Invalid";
											}
										} else {
											vehicleNo = "";
										}
										break;
									case 16:
										if (cell != null){
											Date str=null;
											String str1=null;
											if(dateFormate == 1){
											if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
                                            	DataFormatter dataFormatter= new DataFormatter(); 
                                            	String dateformatstring = "dd/MM/yyyy HH:mm";
                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yy HH:mm");
                                            	str1 = dataFormatter.formatCellValue(cell);
                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(str1);
                                            }
                                            else{
                                            	str=new SimpleDateFormat("dd/MM/yyyy HH:mm").parse(cell.getStringCellValue());
                                                // str=cell.getDateCellValue();
                                            	}
											}
											else if(dateFormate == 2){
												if(cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
	                                            	DataFormatter dataFormatter= new DataFormatter(); 
	                                            	String dateformatstring = "MM/dd/yyyy HH:mm";
	                                            	SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yy HH:mm");
	                                            	str1 = dataFormatter.formatCellValue(cell);
	                                            	str1=new CellDateFormatter(dateformatstring).format(dateFormat.parse(str1));
	                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(str1);
	                                            }
	                                            else{
	                                            	str=new SimpleDateFormat("MM/dd/yyyy HH:mm").parse(cell.getStringCellValue());
	                                                // str=cell.getDateCellValue();
	                                            }
											}
												try{
													SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm");
													SimpleDateFormat dateFormatddmmyy = new SimpleDateFormat("dd-MM-yyyy HH:mm");
													passIssueDate = dateFormatddmmyy.format(str);
												}catch (Exception e) {
													passIssueDate=cell.getStringCellValue() + "Invalid";
												}
										} else {
											passIssueDate = "";
										}
										break;
									case 17:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												actualWeight = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												actualWeight = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												actualWeight = "";
											}else{
												format = "Invalid";
											}
										} else {
											actualWeight = "";
										}
										break;
									case 18:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												transporterName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												transporterName = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												transporterName = "";
											}else{
												format = "Invalid";
											}
										} else {
											transporterName = "";
										}
										break;
									case 19:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												distance = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												distance = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												distance = "";
											}else{
												format = "Invalid";
											}
										} else {
											distance = "";
										}
										break;
									case 20:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												TSrNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												TSrNo = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												TSrNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											TSrNo = "";
										}
										break;
									case 21:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												villageName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												villageName = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												villageName = "";
											}else{
												format = "Invalid";
											}
										} else {
											villageName = "";
										}
										break;
									case 22:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												routeDescription = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												routeDescription = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												routeDescription = "";
											}else{
												format = "Invalid";
											}
										} else {
											routeDescription = "";
										}
										break;
									case 23:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												pwdFees = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												pwdFees = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												pwdFees = "";
											}else{
												format = "Invalid";
											}
										} else {
											pwdFees = "";
										}
										break;
									case 24:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												weighWeight = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												weighWeight = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												weighWeight = "";
											}else{
												format = "Invalid";
											}
										} else {
											weighWeight = "";
										}
										break;
									case 25:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												appType = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												appType = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												appType = "";
											}else{
												format = "Invalid";
											}
										} else {
											appType = "";
										}
										break;
									case 26:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												tripSheetType = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												tripSheetType = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												tripSheetType = "";
											}else{
												format = "Invalid";
											}
										} else {
											tripSheetType = "";
										}
										break;
									case 27:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												unit = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												unit = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												unit = "";
											}else{
												format = "Invalid";
											}
										} else {
											unit = "";
										}
										break;
									case 28:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												cancelReason = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												cancelReason = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												cancelReason = "";
											}else{
												format = "Invalid";
											}
										} else {
											cancelReason = "";
										}
										break;
									case 29:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												printReason = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												printReason = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												printReason = "";
											}else{
												format = "Invalid";
											}
										} else {
											printReason = "";
										}
										break;
									case 30:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												transferReason = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												transferReason = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												transferReason = "";
											}else{
												format = "Invalid";
											}
										} else {
											transferReason = "";
										}
										break;
									case 31:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												certNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												certNo = cell.getStringCellValue();
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_BLANK){
												certNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											certNo = "";
										}
										if(isValid)
										if(MMPS_Tripsheet_Id!="" || MMPS_TripsheetCode!="" || PermitNo!="" || journyStartDate!="" || journyEndDate!="" || vehicleNo!="" || passIssueDate!="" || status!="")
										  list.add(new ILMSDetails(MMPS_Tripsheet_Id,MMPS_TripsheetCode,PermitNo,LeaseCode,Leasee_Name,mineral,grade,miningPlace_E,TotalQuantity,issueStatus,journyStartDate,journyEndDate,buyer,destination,hologramCode,vehicleNo,passIssueDate,actualWeight,transporterName,distance,TSrNo,villageName,routeDescription,pwdFees,weighWeight,appType,tripSheetType,unit,cancelReason,printReason,transferReason,certNo,status," "));
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
				allILMSImporteddetails=getValidILMSDetails(list,systemId,userId);
				globalJsonArray = getImportExcelUnitDetails(clientId, systemId,allILMSImporteddetails);
				if(globalJsonArray != null && globalJsonArray.length() > 0){
					importMessage = "Success";
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return importMessage;
		}
	private JSONArray getImportExcelUnitDetails(int clientId2, int systemId2,
			List<ILMSDetails> validSimDetails) throws JSONException {
		JSONArray ar=new JSONArray();
		for (ILMSDetails il : validSimDetails) {
		JSONObject obj=new JSONObject();
		obj.put("importMMPSIdindex", il.MMPS_Tripsheet_Id);	
		obj.put("importMMPSCodeindex", il.MMPS_TripsheetCode);	
		obj.put("importPermitNoindex", il.PermitNo);	
		obj.put("importVehicleNoindex", il.vehicleNo);	
		obj.put("importPassIssueDateindex", il.passIssueDate);	
		obj.put("importJourneyStartDateindex", il.journyStartDate);	
		obj.put("importJourneyEndDateindex", il.journyEndDate);	
		obj.put("importstatusindex", il.status);	
		obj.put("importremarksindex", il.remarks);	
		
		ar.put(obj);
		}
		return ar;
	}

	public ArrayList<ILMSDetails> getValidILMSDetails(List<ILMSDetails> list,int systemId,int userId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ilmsstatus = "";
		ArrayList<ILMSDetails> validlist = new ArrayList();
		SimpleDateFormat ddmmyyyyHHMMSS = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		
	//	date = ddmmyyyy.format(ddmmyyyyHHMMSS.parse(date));
		try {
			if(list.size()!=0 && !format.equalsIgnoreCase("Invalid")){
			for (ILMSDetails ilmsDetails : list) {
				if(ilmsDetails.MMPS_TripsheetCode==""){
					ilmsDetails.remarks = " Invalid MMPS Trip sheet code.";
				}else{
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(SandMiningStatements.SELECT_ILMS_DETAILS_VALIDATE);
				pstmt.setString(1,ilmsDetails.MMPS_TripsheetCode);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
				if (rs.next()){
					ilmsDetails.remarks = " Trip Sheet Code already exist";
				}
			    if(ilmsDetails.journyStartDate.contains("Invalid") && ilmsDetails.journyStartDate.length()>6){
			    	ilmsDetails.remarks = "Invalid Start Date";
			    	ilmsDetails.journyStartDate=ilmsDetails.journyStartDate.replace("Invalid", "").trim();
				}
			    if(ilmsDetails.journyEndDate.contains("Invalid") && ilmsDetails.journyEndDate.length()>6){
			    	ilmsDetails.remarks = "Invalid End Date";
			    	ilmsDetails.journyEndDate=ilmsDetails.journyEndDate.replace("Invalid", "").trim();
				}
			    if(ilmsDetails.passIssueDate.contains("Invalid") && ilmsDetails.passIssueDate.length()>6){
			    	ilmsDetails.remarks = "Invalid pass issue Date";
			    	ilmsDetails.passIssueDate=ilmsDetails.passIssueDate.replace("Invalid", "").trim();
				}
				if(ilmsDetails.passIssueDate==""){
					ilmsDetails.remarks = " Invalid Pass Issue Date.";
				}else{
					Date dateFromExcel=ddmmyyyy.parse(ilmsDetails.passIssueDate);
					//System.out.println("Excel date "+dateFromExcel);
					if(!(dateFromExcel.compareTo(compdateFrom) >= 0) && !(dateFromExcel.compareTo(compdateTo)<=0)){
						ilmsDetails.remarks = " Invalid, Pass Issue Date not matched with selected date";
					}
				}
				if(ilmsDetails.MMPS_Tripsheet_Id==""){
					ilmsDetails.remarks = " Invalid MMPS Trip sheet Id.";
				}
				if(ilmsDetails.PermitNo==""){
					ilmsDetails.remarks = " Invalid Permit No.";
				}
				if(ilmsDetails.vehicleNo==""){
					ilmsDetails.remarks = " Invalid Vehicle No.";
				}
				if(!(ilmsDetails.remarks.contains("already") || ilmsDetails.remarks.contains("Invalid"))){
					if(validlist.size()!=0){
						for (ILMSDetails sd : validlist) {
							if(sd.MMPS_TripsheetCode.equalsIgnoreCase(ilmsDetails.MMPS_TripsheetCode)){
								ilmsstatus = "Invalid";
								ilmsDetails.remarks = "MMPS Trip Sheet Code is Duplicate";
							}
						}
					}
					if(!ilmsDetails.remarks.contains("Duplicate")){
						ilmsstatus = "Valid";
					}
				}
				
				if(ilmsstatus == ""){
					ilmsstatus = "Invalid";
				}
				validlist.add(new ILMSDetails(ilmsDetails.MMPS_Tripsheet_Id,ilmsDetails.MMPS_TripsheetCode,ilmsDetails.PermitNo,ilmsDetails.LeaseCode,ilmsDetails.Leasee_Name,ilmsDetails.mineral,ilmsDetails.grade,ilmsDetails.miningPlace_E,ilmsDetails.TotalQuantity,ilmsDetails.issueStatus,ilmsDetails.journyStartDate,ilmsDetails.journyEndDate,ilmsDetails.buyer,ilmsDetails.destination,ilmsDetails.hologramCode,ilmsDetails.vehicleNo,ilmsDetails.passIssueDate,ilmsDetails.actualWeight,ilmsDetails.transporterName,ilmsDetails.distance,ilmsDetails.TSrNo,ilmsDetails.villageName,ilmsDetails.routeDescription,ilmsDetails.pwdFees,ilmsDetails.weighWeight,ilmsDetails.appType,ilmsDetails.tripSheetType,ilmsDetails.unit,ilmsDetails.cancelReason,ilmsDetails.printReason,ilmsDetails.transferReason,ilmsDetails.certNo,ilmsstatus,ilmsDetails.remarks));
				ilmsDetails.remarks = "";
				ilmsstatus = "";
		  }
		}
	    }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return validlist;
	}

	private static boolean isValid(Date d1, Date d2,String dateFromExcel) {
		String s = "dd/MM/yyyy";
		SimpleDateFormat ss = new SimpleDateFormat(s);
		//for (String str : inputDateArry) {
			try {
				if (ss.parse(dateFromExcel).compareTo(d1) >= 0 && ss.parse(dateFromExcel).compareTo(d2) <= 0) {
					return true;
				}
			} catch (ParseException e) {
				e.printStackTrace();
			}
		//}
			return false;
	}


}
