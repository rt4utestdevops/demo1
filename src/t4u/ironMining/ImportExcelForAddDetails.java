package t4u.ironMining;

import java.text.DateFormat;
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

public class ImportExcelForAddDetails {
	
		SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"); 
		SimpleDateFormat ddMMyyyy = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
		SimpleDateFormat ddMMyyyyHms = new SimpleDateFormat("dd/MM/yyyy");
		CommonFunctions cf=new CommonFunctions();
        SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
        SimpleDateFormat sdf1 = new SimpleDateFormat("MM-dd-yyyy");
        Date currDate = new Date();
 
	static JSONArray globalJsonArray = new JSONArray();
	private File inFile;
	private String fileExtension;
	private int userId;
	private int systemId;
	private int clientId;
	private int offset;
	private String customerName;
	private int CustomerId;
	 
	private String AssetNumber;
    private String RegistrationDate;
	private String CarriageCapacity;
	private String OperatingOnMine;
	private String Location;
	private String MiningLeaseNo ;	
	private String ChassisNo; 	
	private String InsurancePolicyNo ;	
	private String InsuranceExpiryDate; 
	private String PucNumber ;	
	private String PucExpiryDate ;
	private String roadTaxValidityDate ;
	private String permitValidityDate ;
	private String OwnerName ;
	private String AssemblyConstituency;
	private String HouseNo ;
	private String Locality ;
	private String CityVillage ;	
	private String Taluka ;	
	private String State ;
	private String District ;	
	private String EPICNo; 
	private String PANNo; 	
	private String MobileNo;	
	private String PhoneNo	;
	private String AadharNo; 
	private String EnrollmentDate;	
	private String Bank ;	
	private String Branch;
	private String PrincipalBalance ;
	private String PrincipalOverDues; 	
	private String InterestBalance ;	
	private String AccountNo ;
	private String engineNo;
	private String status;
   

	
	
	private int rowNo;
	String message = "";
	String format = "";
	
	public ImportExcelForAddDetails(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension){
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
	
	public String ImportInsuranceDetails(){
				String importMessage = "";
		List<AddInsuranceDetails> list = new ArrayList();	
		
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
								for (int c = 0; c < 34; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
												AssetNumber = cell.getStringCellValue();
												AssetNumber=AssetNumber.toUpperCase();
											}
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												AssetNumber = cell.getStringCellValue();
												AssetNumber=AssetNumber.toUpperCase();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												AssetNumber = "";
											}
											else{
												format = "Invalid";
											}
										} else {
											AssetNumber = "";
										}
										break;
									case 1:
									if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
												try{
													RegistrationDate = sdf.format(sdf.parse(cell.getStringCellValue()));
														if(!cell.getStringCellValue().equals(RegistrationDate)){
															RegistrationDate=cell.getStringCellValue()+"Invalid";
														}
													}catch (Exception e) {
														RegistrationDate=cell.getStringCellValue()+"Invalid";
													}
												}
//													else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
//														cell.setCellType(HSSFCell.CELL_TYPE_STRING);
//														RegistrationDate = cell.getStringCellValue()+"Invalid";
//													}
												else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
													RegistrationDate = "";
												}else
													format = "Invalid";
											} else {
												RegistrationDate = "";
											}
											break;
										
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												CarriageCapacity = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												CarriageCapacity = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												CarriageCapacity = "";
											}else{
												format = "Invalid";
											}
										} else {
											CarriageCapacity = "";
										}
										break;
                                   case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												OperatingOnMine = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												OperatingOnMine = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												OperatingOnMine = "";
											}else{
												format = "Invalid";
											}
										} else {
											OperatingOnMine = "";
										}
										break;
										 case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												Location = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												Location = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												Location = "";
											}else{
												format = "Invalid";
											}
										} else {
											Location = "";
										}
										break;
                                 case 5:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												MiningLeaseNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												MiningLeaseNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												MiningLeaseNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											MiningLeaseNo = "";
										}
										break;
										case 6:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												ChassisNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												ChassisNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												ChassisNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											ChassisNo = "";
										}
										break;
										case 7:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												InsurancePolicyNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												InsurancePolicyNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												InsurancePolicyNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											InsurancePolicyNo = "";
										}
										break;
										case 8:
											if (cell != null){
												if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
													try{
														InsuranceExpiryDate = sdf.format(sdf.parse(cell.getStringCellValue()));
															if(!cell.getStringCellValue().equals(InsuranceExpiryDate)){
																InsuranceExpiryDate=cell.getStringCellValue()+"Invalid";
															}
														}catch (Exception e) {
															InsuranceExpiryDate=cell.getStringCellValue()+"Invalid";
														}
													}
														else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
															cell.setCellType(HSSFCell.CELL_TYPE_STRING);
															InsuranceExpiryDate = cell.getStringCellValue()+"Invalid";
														}
													else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
														InsuranceExpiryDate = "";
													}else
														format = "Invalid";
												} else {
													InsuranceExpiryDate = "";
												}
												break;
										
										case 9:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												PucNumber = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												PucNumber = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												PucNumber = "";
											}else{
												format = "Invalid";
											}
										} else {
											PucNumber = "";
										}
										break;
										case 10:
											if (cell != null){
												if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
													try{
														PucExpiryDate = sdf.format(sdf.parse(cell.getStringCellValue()));
															if(!cell.getStringCellValue().equals(PucExpiryDate)){
																PucExpiryDate=cell.getStringCellValue()+"Invalid";
															}
														}catch (Exception e) {
															PucExpiryDate=cell.getStringCellValue()+"Invalid";
														}
													}
														else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
															cell.setCellType(HSSFCell.CELL_TYPE_STRING);
															PucExpiryDate = cell.getStringCellValue()+"Invalid";
														}
													else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
														PucExpiryDate = "";
													}else
														format = "Invalid";
												} else {
													PucExpiryDate = "";
												}
												break;
										case 11:
											if (cell != null){
												if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
													try{
														roadTaxValidityDate = sdf.format(sdf.parse(cell.getStringCellValue()));
															if(!cell.getStringCellValue().equals(roadTaxValidityDate)){
																roadTaxValidityDate=cell.getStringCellValue()+"Invalid";
															}
														}catch (Exception e) {
															roadTaxValidityDate=cell.getStringCellValue()+"Invalid";
														}
													}
														else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
															cell.setCellType(HSSFCell.CELL_TYPE_STRING);
															roadTaxValidityDate = cell.getStringCellValue()+"Invalid";
														}
													else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
														roadTaxValidityDate = "";
													}else
														format = "Invalid";
												} else {
													roadTaxValidityDate = "";
												}
												break;
										case 12:
											if (cell != null){
												if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
													try{
														permitValidityDate = sdf.format(sdf.parse(cell.getStringCellValue()));
															if(!cell.getStringCellValue().equals(permitValidityDate)){
																permitValidityDate=cell.getStringCellValue()+"Invalid";
															}
														}catch (Exception e) {
															permitValidityDate=cell.getStringCellValue()+"Invalid";
														}
													}
														else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
															cell.setCellType(HSSFCell.CELL_TYPE_STRING);
															permitValidityDate = cell.getStringCellValue()+"Invalid";
														}
													else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
														permitValidityDate = "";
													}else
														format = "Invalid";
												} else {
													permitValidityDate = "";
												}
												break;	
                                     
                                     case 13:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												OwnerName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												OwnerName = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												OwnerName = "";
											}else{
												format = "Invalid";
											}
										} else {
											OwnerName = "";
										}
										break;
										case 14:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												AssemblyConstituency= cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												AssemblyConstituency = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												AssemblyConstituency = "";
											}else{
												format = "Invalid";
											}
										} else {
											AssemblyConstituency = "";
										}
										break;
                                     case 15:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												HouseNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												HouseNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												HouseNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											HouseNo = "";
										}
										break;
										case 16:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												Locality= cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												Locality = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												Locality = "";
											}else{
												format = "Invalid";
											}
										} else {
											Locality = "";
										}
										break;
                                     case 17:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												CityVillage = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												CityVillage = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												CityVillage = "";
											}else{
												format = "Invalid";
											}
										} else {
											CityVillage = "";
										}
										break;
										 case 18:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												Taluka = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												Taluka = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												Taluka = "";
											}else{
												format = "Invalid";
											}
										} else {
											Taluka = "";
										}
										break;
										   case 19:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												State= cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												State = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												State = "";
											}else{
												format = "Invalid";
											}
										} else {
											State = "";
										}
										break;
                                     case 20:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												District = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												District = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												District = "";
											}else{
												format = "Invalid";
											}
										} else {
											District = "";
										}
										break;
										 case 21:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												EPICNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												EPICNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												EPICNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											EPICNo = "";
										}
										break;
										case 22:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												PANNo= cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												PANNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												PANNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											PANNo = "";
										}
										break;
                                     case 23:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												MobileNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												MobileNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												MobileNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											MobileNo = "";
										}
										break;
										 case 24:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												PhoneNo = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												PhoneNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												PhoneNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											PhoneNo = "";
										}
										break;
										 case 25:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												AadharNo= cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												AadharNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												AadharNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											AadharNo = "";
										}
										break;
                                     case 26:
                                    	 if (cell != null){
 											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
 												try{
 													EnrollmentDate = sdf.format(sdf.parse(cell.getStringCellValue()));
 														if(!cell.getStringCellValue().equals(EnrollmentDate)){
 															EnrollmentDate=cell.getStringCellValue()+"Invalid";
 														}
 													}catch (Exception e) {
 														EnrollmentDate=cell.getStringCellValue()+"Invalid";
 													}
 												}
 													else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
 														cell.setCellType(HSSFCell.CELL_TYPE_STRING);
 														EnrollmentDate = cell.getStringCellValue()+"Invalid";
 													}
 												else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
 													EnrollmentDate = "";
 												}else
 													format = "Invalid";
 											} else {
 												EnrollmentDate = "";
 											}
 											break;
										
									
							case 27:
								if (cell != null){
									if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
										Bank = cell.getStringCellValue();
									else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										Bank = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										Bank = "";
									}else{
										format = "Invalid";
									}
								} else {
									Bank = "";
								}
								break;
								 case 28:
								if (cell != null){
									if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
										Branch = cell.getStringCellValue();
									else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										Branch = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										Branch = "";
									}else{
										format = "Invalid";
									}
								} else {
									Branch = "";
								}
								break;
                             case 29:
								if (cell != null){
									if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
										PrincipalBalance = cell.getStringCellValue();
									else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										PrincipalBalance = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										PrincipalBalance = "";
									}else{
										format = "Invalid";
									}
								} else {
									PrincipalBalance = "";
								}
								break;
								case 30:
								if (cell != null){
									if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
										PrincipalOverDues = cell.getStringCellValue();
									else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										PrincipalOverDues = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										PrincipalOverDues = "";
									}else{
										format = "Invalid";
									}
								} else {
									PrincipalOverDues = "";
								}
								break;
                             case 31:
								if (cell != null){
									if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
										InterestBalance = cell.getStringCellValue();
									else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										InterestBalance = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										InterestBalance = "";
									}else{
										format = "Invalid";
									}
								} else {
									InterestBalance = "";
								}
								break;
							case 32:
								if (cell != null){
									if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
										AccountNo = cell.getStringCellValue();
									else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										AccountNo = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										AccountNo = "";
									}else{
										format = "Invalid";
									}
								} else {
									AccountNo = "";
								}
								break;
							case 33:
								if (cell != null){
									if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
										engineNo = cell.getStringCellValue();
									else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										engineNo = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										engineNo = "";
									}else{
										format = "Invalid";
									}
								} else {
									engineNo = "";
								}
								break;	
									}															
								}
								if(AssetNumber!="" || RegistrationDate!="" || CarriageCapacity!="" || OperatingOnMine!=""||Location!=""||MiningLeaseNo!=""||ChassisNo!=""||InsurancePolicyNo!=""||InsuranceExpiryDate!=""||PucNumber!=""||PucExpiryDate!=""||Bank!=""||OwnerName!=""||AssemblyConstituency!=""||HouseNo!=""||Locality!=""||CityVillage!=""||Taluka!=""||State!=""||District!=""||EPICNo!=""||PANNo!=""||MobileNo!=""||PhoneNo!=""||AadharNo!=""||EnrollmentDate!=""||Branch!=""||PrincipalBalance!=""||PrincipalOverDues!=""||InterestBalance!=""||AccountNo!=""||engineNo!=""
									||roadTaxValidityDate!=""||permitValidityDate!="")
									list.add(new AddInsuranceDetails(status,"",AssetNumber, RegistrationDate, CarriageCapacity, OperatingOnMine, Location, MiningLeaseNo,	 ChassisNo, InsurancePolicyNo, InsuranceExpiryDate, PucNumber, PucExpiryDate,roadTaxValidityDate,permitValidityDate, OwnerName, AssemblyConstituency, HouseNo, Locality, CityVillage, Taluka , State , District , EPICNo, PANNo, MobileNo, PhoneNo, AadharNo, EnrollmentDate, Bank, Branch, PrincipalBalance , PrincipalOverDues,  InterestBalance , AccountNo,engineNo,0,0));

									
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}    
				else if (fileExtension.equals(".xlsx")) {
					
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
								for (int c = 0; c < 34; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {   



									case 0:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
												AssetNumber = cell.getStringCellValue();
												AssetNumber=AssetNumber.toUpperCase();
											}
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												AssetNumber = cell.getStringCellValue();
												AssetNumber=AssetNumber.toUpperCase();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												AssetNumber = "";
											}
											else{
												format = "Invalid";
											}
										} else {
											AssetNumber = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
												try{
													RegistrationDate = sdf.format(sdf.parse(cell.getStringCellValue()));
													if(!cell.getStringCellValue().equals(RegistrationDate)){
														RegistrationDate=cell.getStringCellValue()+"Invalid";
													}
												}catch (Exception e) {
													RegistrationDate=cell.getStringCellValue()+"Invalid";
												}
											}
//												else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
//													cell.setCellType(XSSFCell.CELL_TYPE_STRING);
//													RegistrationDate = cell.getStringCellValue()+"Invalid";
//												}
											else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												RegistrationDate = "";
											}else
												format = "Invalid";
										} else {
											RegistrationDate = "";
										}
										break;
								  case 2:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												CarriageCapacity = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												CarriageCapacity = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												CarriageCapacity = "";
											}else{
												format = "Invalid";
											}
										} else {
											CarriageCapacity = "";
										}
										break;
                                   case 3:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												OperatingOnMine = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												OperatingOnMine = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												OperatingOnMine = "";
											}else{
												format = "Invalid";
											}
										} else {
											OperatingOnMine = "";
										}
										break;
										 case 4:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												Location = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												Location = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												Location = "";
											}else{
												format = "Invalid";
											}
										} else {
											Location = "";
										}
										break;
                                 case 5:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												MiningLeaseNo = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												MiningLeaseNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												MiningLeaseNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											MiningLeaseNo = "";
										}
										break;
										case 6:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												ChassisNo = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												ChassisNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												ChassisNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											ChassisNo = "";
										}
										break;
										case 7:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												InsurancePolicyNo = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												InsurancePolicyNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												InsurancePolicyNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											InsurancePolicyNo = "";
										}
										break;
										case 8:
								            if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
												try{
													InsuranceExpiryDate = sdf.format(sdf.parse(cell.getStringCellValue()));
														if(!cell.getStringCellValue().equals(InsuranceExpiryDate)){
															InsuranceExpiryDate=cell.getStringCellValue()+"Invalid";
														}
													}catch (Exception e) {
														InsuranceExpiryDate=cell.getStringCellValue()+"Invalid";
													}
												}
													else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
														cell.setCellType(XSSFCell.CELL_TYPE_STRING);
														InsuranceExpiryDate = cell.getStringCellValue()+"Invalid";
													}
												else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
													InsuranceExpiryDate = "";
												}else
													format = "Invalid";
											} else {
												InsuranceExpiryDate = "";
											}
											break;
										
										case 9:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												PucNumber = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												PucNumber = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												PucNumber = "";
											}else{
												format = "Invalid";
											}
										} else {
											PucNumber = "";
										}
										break;
										case 10:
											 if (cell != null){
													if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
														try
														{
															PucExpiryDate = sdf.format(sdf.parse(cell.getStringCellValue()));
															if(!cell.getStringCellValue().equals(PucExpiryDate)){
																PucExpiryDate=cell.getStringCellValue()+"Invalid";
															}
														}catch (Exception e) {
															PucExpiryDate=cell.getStringCellValue()+"Invalid";
														}
													}
														else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
															cell.setCellType(XSSFCell.CELL_TYPE_STRING);
															PucExpiryDate = cell.getStringCellValue()+"Invalid";
														}
													else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
														PucExpiryDate = "";
													}else
														format = "Invalid";
												} else {
													PucExpiryDate = "";
												}
												break;
										case 11:
											 if (cell != null){
													if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
														try
														{
															roadTaxValidityDate = sdf.format(sdf.parse(cell.getStringCellValue()));
															if(!cell.getStringCellValue().equals(roadTaxValidityDate)){
																roadTaxValidityDate=cell.getStringCellValue()+"Invalid";
															}
														}catch (Exception e) {
															roadTaxValidityDate=cell.getStringCellValue()+"Invalid";
														}
													}
														else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
															cell.setCellType(XSSFCell.CELL_TYPE_STRING);
															roadTaxValidityDate = cell.getStringCellValue()+"Invalid";
														}
													else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
														roadTaxValidityDate = "";
													}else
														format = "Invalid";
												} else {
													roadTaxValidityDate = "";
												}
												break;
										case 12:
											 if (cell != null){
													if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
														try
														{
															permitValidityDate = sdf.format(sdf.parse(cell.getStringCellValue()));
															if(!cell.getStringCellValue().equals(permitValidityDate)){
																permitValidityDate=cell.getStringCellValue()+"Invalid";
															}
														}catch (Exception e) {
															permitValidityDate=cell.getStringCellValue()+"Invalid";
														}
													}
														else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
															cell.setCellType(XSSFCell.CELL_TYPE_STRING);
															permitValidityDate = cell.getStringCellValue()+"Invalid";
														}
													else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
														permitValidityDate = "";
													}else
														format = "Invalid";
												} else {
													permitValidityDate = "";
												}
												break;
											
                                     case 13:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												OwnerName = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												OwnerName = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												OwnerName = "";
											}else{
												format = "Invalid";
											}
										} else {
											OwnerName = "";
										}
										break;
										case 14:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												AssemblyConstituency= cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												AssemblyConstituency = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												AssemblyConstituency = "";
											}else{
												format = "Invalid";
											}
										} else {
											AssemblyConstituency = "";
										}
										break;
                                     case 15:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												HouseNo = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												HouseNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												HouseNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											HouseNo = "";
										}
										break;
										case 16:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												Locality= cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												Locality = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												Locality = "";
											}else{
												format = "Invalid";
											}
										} else {
											Locality = "";
										}
										break;
                                     case 17:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												CityVillage = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												CityVillage = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												CityVillage = "";
											}else{
												format = "Invalid";
											}
										} else {
											CityVillage = "";
										}
										break;
										 case 18:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												Taluka = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												Taluka = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												Taluka = "";
											}else{
												format = "Invalid";
											}
										} else {
											Taluka = "";
										}
										break;
										   case 19:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												State= cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												State = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												State = "";
											}else{
												format = "Invalid";
											}
										} else {
											State = "";
										}
										break;
                                     case 20:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												District = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												District = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												District = "";
											}else{
												format = "Invalid";
											}
										} else {
											District = "";
										}
										break;
										 case 21:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												EPICNo = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												EPICNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												EPICNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											EPICNo = "";
										}
										break;
										case 22:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												PANNo= cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												PANNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												PANNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											PANNo = "";
										}
										break;
                                     case 23:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												MobileNo = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												MobileNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												MobileNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											MobileNo = "";
										}
										break;
										 case 24:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												PhoneNo = cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												PhoneNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												PhoneNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											PhoneNo = "";
										}
										break;
										 case 25:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												AadharNo= cell.getStringCellValue();
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												AadharNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												AadharNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											AadharNo = "";
										}
										break;
                                     case 26:
                                      	   if (cell != null){
   											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
   												try{
   													EnrollmentDate = sdf.format(sdf.parse(cell.getStringCellValue()));
   														if(!cell.getStringCellValue().equals(EnrollmentDate)){
   															EnrollmentDate=cell.getStringCellValue()+"Invalid";
   														}
   													}catch (Exception e) {
   														EnrollmentDate=cell.getStringCellValue()+"Invalid";
   													}
   												}
   													else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
   														cell.setCellType(XSSFCell.CELL_TYPE_STRING);
   														EnrollmentDate = cell.getStringCellValue()+"Invalid";
   													}
   												else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
   													EnrollmentDate = "";
   												}else
   													format = "Invalid";
   											} else {
   												EnrollmentDate = "";
   											}
   											break;										
							case 27:
								if (cell != null){
									if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
										Bank = cell.getStringCellValue();
									else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(XSSFCell.CELL_TYPE_STRING);
										Bank = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										Bank = "";
									}else{
										format = "Invalid";
									}
								} else {
									Bank = "";
								}
								break;
								 case 28:
								if (cell != null){
									if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
										Branch = cell.getStringCellValue();
									else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(XSSFCell.CELL_TYPE_STRING);
										Branch = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										Branch = "";
									}else{
										format = "Invalid";
									}
								} else {
									Branch = "";
								}
								break;
                             case 29:
								if (cell != null){
									if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
										PrincipalBalance = cell.getStringCellValue();
									else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(XSSFCell.CELL_TYPE_STRING);
										PrincipalBalance = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										PrincipalBalance = "";
									}else{
										format = "Invalid";
									}
								} else {
									PrincipalBalance = "";
								}
								break;
								case 30:
								if (cell != null){
									if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
										PrincipalOverDues = cell.getStringCellValue();
									else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(XSSFCell.CELL_TYPE_STRING);
										PrincipalOverDues = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										PrincipalOverDues = "";
									}else{
										format = "Invalid";
									}
								} else {
									PrincipalOverDues = "";
								}
								break;
                             case 31:
								if (cell != null){
									if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
										InterestBalance = cell.getStringCellValue();
									else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(XSSFCell.CELL_TYPE_STRING);
										InterestBalance = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										InterestBalance = "";
									}else{
										format = "Invalid";
									}
								} else {
									InterestBalance = "";
								}
								break;
								 case 32:
								if (cell != null){
									if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
										AccountNo = cell.getStringCellValue();
									else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
										cell.setCellType(XSSFCell.CELL_TYPE_STRING);
										AccountNo = cell.getStringCellValue();
									}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
										AccountNo = "";
									}else{
										format = "Invalid";
									}
								} else {
									AccountNo = "";
								}
								break;
							 case 33:
									if (cell != null){
										if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
											engineNo = cell.getStringCellValue();
										else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(XSSFCell.CELL_TYPE_STRING);
											engineNo = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											engineNo = "";
										}else{
											format = "Invalid";
										}
									} else {
										engineNo = "";
									}
									break;	
								}															
								}
								if(AssetNumber!="" || RegistrationDate!="" || CarriageCapacity!="" || OperatingOnMine!=""||Location!=""||MiningLeaseNo!=""||ChassisNo!=""||InsurancePolicyNo!=""||InsuranceExpiryDate!=""||PucNumber!=""||PucExpiryDate!=""||OwnerName!=""||AssemblyConstituency!=""||HouseNo!=""||Locality!=""||CityVillage!=""||Taluka!=""||State!=""||District!=""||EPICNo!=""||PANNo!=""||MobileNo!=""||PhoneNo!=""||AadharNo!=""||EnrollmentDate!=""||Bank!=""||Branch!=""||PrincipalBalance!=""||PrincipalOverDues!=""||InterestBalance!=""||AccountNo!=""||engineNo!=""
									||roadTaxValidityDate!=""||permitValidityDate!="")
									list.add(new AddInsuranceDetails(status,"",AssetNumber, RegistrationDate, CarriageCapacity, OperatingOnMine, Location, MiningLeaseNo,ChassisNo, InsurancePolicyNo, InsuranceExpiryDate, PucNumber, PucExpiryDate,roadTaxValidityDate,permitValidityDate, OwnerName, AssemblyConstituency, HouseNo, Locality, CityVillage, Taluka , State , District , EPICNo, PANNo, MobileNo, PhoneNo, AadharNo, EnrollmentDate, Bank, Branch, PrincipalBalance , PrincipalOverDues,  InterestBalance , AccountNo,engineNo,0,0));
							}
							
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				globalJsonArray  = null;
				globalJsonArray = getImportDetailsForAdd(clientId, systemId,getValidTripDetailsForAdd(list,systemId, CustomerId, userId));
				if(globalJsonArray != null && globalJsonArray.length() > 0){
					importMessage = "Success";
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return importMessage;
	}
	
	public synchronized List<AddInsuranceDetails> getValidTripDetailsForAdd(List<AddInsuranceDetails> list,int systemId, int CustomerId,int userId) {
	    List<AddInsuranceDetails> validlist = new ArrayList();
	    String validstatus = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		 int stateid = 0;
		 int districtId=0;
		 
		
	 try {
			con = DBConnection.getConnectionToDB("AMS");
		    if(list.size()!=0 && !format.equalsIgnoreCase("Invalid")){
			int k=0;
		       for (AddInsuranceDetails InsuranceDetails : list) {
				 stateid=0;
				 districtId=0;
				 
				 pstmt=con.prepareStatement(IronMiningStatement.CHECK_STATE);
				 pstmt.setString(1, list.get(k).State.toUpperCase());
				 rs=pstmt.executeQuery();
				 if(rs.next()){
					  stateid = rs.getInt("STATE_CODE");
				 } 
				 
				 pstmt=con.prepareStatement(IronMiningStatement.CHECK_DISTRICT);
				 pstmt.setInt(1, stateid);
				 pstmt.setString(2, list.get(k).District.toUpperCase());
				 rs=pstmt.executeQuery();
				 if(rs.next()){
					 districtId = rs.getInt("DISTRICT_ID");
				 }
				 
                    if(list.get(k).AssetNumber.equals("")){
						InsuranceDetails.remarks = "Please Enter the asset number";
						validstatus="Invalid";
					}
                    
                    else if(list.get(k).AssetNumber.matches(".*[^a-zA-Z0-9].*")){
						InsuranceDetails.remarks = "Please Enter the  valid asset number";
						validstatus="Invalid";
					}
                    
                   else if(list.get(k).RegistrationDate.equals("")){
						InsuranceDetails.remarks = " Enter the Registration Date";
						validstatus="Invalid";
					}
                  
                   else if(list.get(k). RegistrationDate==null ){
						InsuranceDetails.remarks = "Registration DateTime Format is not valid";
						validstatus="Invalid";
					}
                   else if( list.get(k).RegistrationDate.contains("Invalid")){
						InsuranceDetails.remarks = " Invalid  Registration DateTime Format";
						validstatus="Invalid";
					}
                    
                   else	if(Checkdate(list.get(k).RegistrationDate)){
						InsuranceDetails.remarks = "Entered RegistrationDate is not valid";
						validstatus="Invalid";
					}
                    
                    else if(list.get(k).CarriageCapacity.equals("")){
						InsuranceDetails.remarks = "Please Enter the Carriage capacity";
						validstatus="Invalid";
					}
                   else if(list.get(k).CarriageCapacity.matches(".*[^0-9].*")){
						InsuranceDetails.remarks = "Please Enter the valid Carriage capacity";
						validstatus="Invalid";
					}
					
					
                   else if(list.get(k).InsurancePolicyNo.equals("")){
						InsuranceDetails.remarks = "Please Enter the Insurance policy no";
						validstatus="Invalid";
					}
					
                   else if(list.get(k).InsurancePolicyNo.matches(".*[^a-zA-Z0-9].*")){
						InsuranceDetails.remarks = "Please Enter the valid Insurance policy no";
						validstatus="Invalid";
					}
					
                   else	if(list.get(k).InsuranceExpiryDate.equals("")){
    						InsuranceDetails.remarks = "Please Enter the Insurance Expiry Date";
    						validstatus="Invalid";
    					}
                      
                   else	if(Checkdate(list.get(k).InsuranceExpiryDate)){
						InsuranceDetails.remarks = "Entered Insurance Expiry Date is not valid";
						validstatus="Invalid";
					}
                    
                   else	if(CompareDate(list.get(k).InsuranceExpiryDate)){
						InsuranceDetails.remarks = "Entered Insurance Expiry Date is past date";
						validstatus="Invalid";
					}
                    
                  else	if(list.get(k).InsuranceExpiryDate==null ){
						InsuranceDetails.remarks = "Please Enter the Valid Insurance Expiry Date";
						validstatus="Invalid";
					}
                   else	if(InsuranceExpiryDate.contains("Invalid")){
						InsuranceDetails.remarks = "Please Enter the Valid Insurance Expiry Date";
						validstatus="Invalid";
					}
                   else if(list.get(k).PucNumber .equals("")){
						InsuranceDetails.remarks = "Please Enter the Puc Number";
						validstatus="Invalid";
					}
                   else if(list.get(k).PucNumber.matches(".*[^a-zA-Z0-9].*")){
						InsuranceDetails.remarks = "Please Enter the valid Puc Number";
						validstatus="Invalid";
					}
					
                   else if(list.get(k).PucExpiryDate.equals("")){
    						InsuranceDetails.remarks = "Please Enter the PUC Expiry Date";
    						validstatus="Invalid";
    					}
                   else if(list.get(k).PucExpiryDate==null){
						InsuranceDetails.remarks = "Please Enter the Valid  PUC Expiry Date";
						validstatus="Invalid";
					}
                    
                   else	if(Checkdate(list.get(k).PucExpiryDate)){
						InsuranceDetails.remarks = "Entered Puc Expiry Date is not valid";
						validstatus="Invalid";
					}
                   else if(CompareDate(list.get(k).PucExpiryDate)){
						InsuranceDetails.remarks = " Entered  Valid  PUC Expiry Date is past date";
						validstatus="Invalid";
					}
                   else if(list.get(k).PucExpiryDate.contains("Invalid")){
						InsuranceDetails.remarks = "Please Enter the Valid  PUC Expiry Date";
						validstatus="Invalid";
					}
                    
                   else if(list.get(k).roadTaxValidityDate.equals("")){
						InsuranceDetails.remarks = "Please Enter the RoadTax Validity Date";
						validstatus="Invalid";
					}
                   else if(list.get(k).roadTaxValidityDate==null){
						InsuranceDetails.remarks = "Please Enter the Valid RoadTax Validity Date";
						validstatus="Invalid";
					}
	               
	              else	if(Checkdate(list.get(k).roadTaxValidityDate)){
						InsuranceDetails.remarks = "Entered RoadTax Validity Date is not valid";
						validstatus="Invalid";
					}
	              else if(CompareDate(list.get(k).roadTaxValidityDate)){
						InsuranceDetails.remarks = " Entered RoadTax Validity is past date";
						validstatus="Invalid";
					}
	              else if(list.get(k).roadTaxValidityDate.contains("Invalid")){
						InsuranceDetails.remarks = "Please Enter the Valid RoadTax Validity Date";
						validstatus="Invalid";
					}
                    
	              else if(list.get(k).permitValidityDate.equals("")){
						InsuranceDetails.remarks = "Please Enter the Permit Validity Date";
						validstatus="Invalid";
					}
                 else if(list.get(k).permitValidityDate==null){
						InsuranceDetails.remarks = "Please Enter the Valid Permit Validity Date";
						validstatus="Invalid";
					}
	               
	              else	if(Checkdate(list.get(k).permitValidityDate)){
						InsuranceDetails.remarks = "Entered Permit Validity Date is not valid";
						validstatus="Invalid";
					}
	              else if(CompareDate(list.get(k).permitValidityDate)){
						InsuranceDetails.remarks = " Entered Permit Validity is past date";
						validstatus="Invalid";
					}
	              else if(list.get(k).permitValidityDate.contains("Invalid")){
						InsuranceDetails.remarks = "Please Enter the Valid Permit Validity Date";
						validstatus="Invalid";
					}
                    
    				 else if(list.get(k).OwnerName .equals("")){
						InsuranceDetails.remarks = "Please Enter the OwnerName";
						validstatus="Invalid";
					}
                   else if(list.get(k).AssemblyConstituency.equals("")){
						InsuranceDetails.remarks = "Please Enter the Assembly Constituency";
						validstatus="Invalid";
					}
					
					 else if(stateid==0){
						 InsuranceDetails.remarks = "Please Enter Valid State";
						 validstatus="Invalid";
					 }
					 else if(districtId==0){
						 InsuranceDetails.remarks = "Please Enter Valid District";
						 validstatus="Invalid";
					 }
					 else if(list.get(k).engineNo.equals("")){
						 InsuranceDetails.remarks = "Please Enter the Engine Number";
						 validstatus="Invalid";
					 }
                     else if(list.get(k).engineNo.matches(".*[^a-zA-Z0-9].*")){
						InsuranceDetails.remarks = "Please Enter the valid Engine Number";
						validstatus="Invalid";
					 }
                     else if(list.get(k).engineNo.length()>50){
                    	InsuranceDetails.remarks = "Engine Number Exceeded it's Maximum length. Please make it simple.";
 						validstatus="Invalid";
					 }
					 
					 else if(validstatus != "Invalid" || validstatus==""){
						validstatus = "Valid";
						InsuranceDetails.remarks= "Valid";
					}
					 else{
						     validstatus = "InValid";
							InsuranceDetails.remarks= "Enter all the fields";
						}
					
				  validlist.add(new AddInsuranceDetails(validstatus,InsuranceDetails.remarks,InsuranceDetails.AssetNumber,InsuranceDetails.RegistrationDate, InsuranceDetails.CarriageCapacity,InsuranceDetails.OperatingOnMine, InsuranceDetails.Location, InsuranceDetails.MiningLeaseNo,InsuranceDetails.ChassisNo,InsuranceDetails. InsurancePolicyNo, InsuranceDetails.InsuranceExpiryDate, InsuranceDetails.PucNumber, InsuranceDetails.PucExpiryDate,InsuranceDetails.roadTaxValidityDate,InsuranceDetails.permitValidityDate,InsuranceDetails. OwnerName, InsuranceDetails.AssemblyConstituency,InsuranceDetails. HouseNo,InsuranceDetails. Locality,InsuranceDetails. CityVillage,InsuranceDetails. Taluka ,InsuranceDetails. State , InsuranceDetails.District , InsuranceDetails.EPICNo,InsuranceDetails. PANNo,InsuranceDetails. MobileNo, InsuranceDetails.PhoneNo, InsuranceDetails.AadharNo,InsuranceDetails. EnrollmentDate,InsuranceDetails. Bank,InsuranceDetails. Branch, InsuranceDetails.PrincipalBalance ,InsuranceDetails. PrincipalOverDues, InsuranceDetails. InterestBalance , InsuranceDetails.AccountNo,InsuranceDetails.engineNo,stateid,districtId));
				  InsuranceDetails.remarks = "";
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
	
	public boolean CompareDate(String date1) {

        // HH converts hour in 24 hours format (0-23), day calculation
		boolean greater = false;
		Date currDate = new Date();
        SimpleDateFormat format = new SimpleDateFormat("dd-MM-yyyy");

        Date d1 = null;
        Date d2 = null;

        try {
            d1 = format.parse(date1);
            d2 = format.parse(format.format(currDate));

            // in milliseconds
            long diff = (d2.getTime() - d1.getTime());
            long diffDays = diff / (24 * 60 * 60 * 1000);

            if (diffDays > 0) {
            	greater =true;
                }

        } catch (ParseException e) {
            e.printStackTrace();
        }
        return greater;
    }
	
	public boolean Checkdate(String date) {
	
	String [] dateParts = date.split("-");
    String day = dateParts[0];
    String month = dateParts[1];
    String year = dateParts[2];
    boolean check=false;
    try {
	 if(year.length()>4){
		 check=true;
	 } 
	 else if(day.equals("00"))
	 {
		 check=true;
	 }
	 else if (month.equals("00"))
	 {
		 check=true;
		 
	 }
    }catch (Exception e) {
         e.printStackTrace();
     }
     return check;
 }
		 
	 
	public JSONArray getImportDetailsForAdd(int systemId, int CustomerId,List<AddInsuranceDetails> list) {

		JSONArray AddDetaisJsonArray = null;
		JSONObject AddDetaisJsonObject = null;
		int count = 0;
		
		try {
			AddDetaisJsonArray = new JSONArray();
			AddDetaisJsonObject = new JSONObject();		
						
			for (AddInsuranceDetails Details : list) {
				count++;
				AddDetaisJsonObject = new JSONObject();
		        AddDetaisJsonObject.put("importassetnoIndex", Details.AssetNumber);
		        
		        if(!Details.RegistrationDate.equals(""))
				{
				if(Details.RegistrationDate.equals("00-00-0000Invalid"))
				{
					AddDetaisJsonObject.put("importregistrationdateIndex","00-00-0000");
				}
				AddDetaisJsonObject.put("importregistrationdateIndex",Details.RegistrationDate);
			}  
				AddDetaisJsonObject.put("importcarriagecapacityIndex", Details.CarriageCapacity);
				AddDetaisJsonObject.put("importOperatingonmineIndex", Details.OperatingOnMine);
				AddDetaisJsonObject.put("importlocationIndex", Details.Location);
				AddDetaisJsonObject.put("importminingleasenoIndex", Details.MiningLeaseNo);
				AddDetaisJsonObject.put("importchassingnoIndex", Details.ChassisNo);
				AddDetaisJsonObject.put("importpolicynoIndex", Details.InsurancePolicyNo);
				
				 if(!Details.InsuranceExpiryDate.equals(""))
					{
					if(Details.InsuranceExpiryDate.equals("00-00-0000Invalid"))
					{
						AddDetaisJsonObject.put("importinsuranceexpirydateIndex","00-00-0000");
					}
				      else
					{
					    AddDetaisJsonObject.put("importinsuranceexpirydateIndex",Details.InsuranceExpiryDate);
				    }
					}  
				AddDetaisJsonObject.put("importpucnoIndex", Details.PucNumber);
				if(!Details.PucExpiryDate.equals(""))
				{
				if(Details.PucExpiryDate.equals("00-00-0000Invalid"))
				{
					AddDetaisJsonObject.put("importpucexpirydateIndex","00-00-0000");
				}
				else
				{
					 AddDetaisJsonObject.put("importpucexpirydateIndex",Details.PucExpiryDate);
			    }
				} 
				
				if(!Details.roadTaxValidityDate.equals(""))
				{
				if(Details.roadTaxValidityDate.equals("00-00-0000Invalid"))
				{
					AddDetaisJsonObject.put("importroadTaxValiditydateIndex","00-00-0000");
				}
				else
				{
					 AddDetaisJsonObject.put("importroadTaxValiditydateIndex",Details.roadTaxValidityDate);
			    }
				} 
				
				if(!Details.permitValidityDate.equals(""))
				{
				if(Details.permitValidityDate.equals("00-00-0000Invalid"))
				{
					AddDetaisJsonObject.put("importpermitValiditydateIndex","00-00-0000");
				}
				else
				{
					 AddDetaisJsonObject.put("importpermitValiditydateIndex",Details.permitValidityDate);
			    }
				} 
				AddDetaisJsonObject.put("importownernameIndex", Details.OwnerName);
				AddDetaisJsonObject.put("importAssemblyConstituencyIndex", Details.AssemblyConstituency);
				AddDetaisJsonObject.put("importHouseNoIndex", Details.HouseNo);
				AddDetaisJsonObject.put("importLocalityIndex", Details.Locality);
				AddDetaisJsonObject.put("importCityIndex", Details.CityVillage);
				AddDetaisJsonObject.put("importTalukaIndex", Details.Taluka);
				AddDetaisJsonObject.put("importStateIndex", Details.State);
		        AddDetaisJsonObject.put("importDistrictIndex", Details.District);
				AddDetaisJsonObject.put("importEPICNoIndex", Details.EPICNo);
				AddDetaisJsonObject.put("importPANNoIndex", Details.PANNo);
				AddDetaisJsonObject.put("importMobileNoIndex", !Details.MobileNo.equals("")?Details.MobileNo:"0");
				AddDetaisJsonObject.put("importPhoneNoIndex", !Details.PhoneNo.equals("")?Details.PhoneNo:"0");
			    AddDetaisJsonObject.put("importAadharNoIndex", Details.AadharNo);
			    if(!Details.EnrollmentDate.equals(""))
				{
					if(Details.EnrollmentDate.equals("00-00-0000Invalid"))
					{
					  AddDetaisJsonObject.put("importEnrollmentDateIndex","00-00-0000");
					}else{
					  AddDetaisJsonObject.put("importEnrollmentDateIndex",Details.EnrollmentDate);
				    }
				}else{
				   Date dateobj = new Date();
			       AddDetaisJsonObject.put("importEnrollmentDateIndex",sdf.format(dateobj));
				}
			
			    AddDetaisJsonObject.put("importBankIndex", Details.Bank);
				AddDetaisJsonObject.put("importBranchIndex", Details.Branch);
				AddDetaisJsonObject.put("importPrincipalBalanceIndex", !Details.PrincipalBalance.equals("")?Details.PrincipalBalance:"0");
                AddDetaisJsonObject.put("importPrincipalOverDuesIndex",!Details.PrincipalOverDues.equals("")?Details.PrincipalOverDues:"0");
				AddDetaisJsonObject.put("importInterestBalanceIndex", !Details.InterestBalance.equals("")?Details.InterestBalance:"0");
				AddDetaisJsonObject.put("importAccountNoIndex", Details.AccountNo); 
		        AddDetaisJsonObject.put("importValidStatusIndex", Details.validstatus);
				AddDetaisJsonObject.put("importRemarksIndex", Details.remarks); 
				AddDetaisJsonObject.put("importstateidIndex", Details.stateid);
				AddDetaisJsonObject.put("importdistrictidIndex", Details.districtId);
				AddDetaisJsonObject.put("importEngineNoIndex", Details.engineNo);
			    AddDetaisJsonArray.put(AddDetaisJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return AddDetaisJsonArray;
	}

}
	
	

										    
										
										
										
										
										
										
										
										
										
										
										
										