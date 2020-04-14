package t4u.ironMining;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.swing.text.DefaultEditorKit.PasteAction;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.WorkbookFactory;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.jfree.chart.urls.CustomCategoryURLGenerator;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.functions.IronMiningFunction;
import t4u.statements.IronMiningStatement;

public class ImpportModifyExcelForAssertEnroll {

	static JSONArray globalJsonArray = new JSONArray();
	private File inFile;
	private String fileExtension;
	private int userId;
	private int systemId;
	private int clientId;
	private int offset;
	
	private String assetNo;
	private String engineNo;
	private String insuranseNo;
	private Date insuranseExpDate;
	private String pucNo;
	private Date pucExpDate;
	private Date roadTaxValididtyDate;
	private Date permitValididtyDate;
	private String challanNo;
	private Date challanDate;
	private String bankTransactionNo;
	private Double amountPaid;
	private Date validityDate;
	
	private String operatingOnMine;
	private String location;
	private String miningLeaseNo;
	private String chassisNo;
	private String constituency;
	private String houseNo;
	private String locality;
	private String city;
	private String taluka;
	
	private String epicNo;
	private String panNo;
	private String mobileNo;
	private String phoneNo;
	private String aadharNo;
	private String bank;
	private String branch;
	private Double principalBalance;
	private Double principalOverDue;
	private Double interestBalance;
	private String accountNo;
	
	private SimpleDateFormat ddMMyyyy = new SimpleDateFormat("dd/MM/yyyy");
	private SimpleDateFormat MMddyyyy = new SimpleDateFormat("MM/dd/yyyy");
	private int rowNo;
	String message = "";
	
	public ImpportModifyExcelForAssertEnroll(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension){
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
	
	public String getModifiedImportExcellDetails(){
		
		String importMessage = "";
		List<ModifiedAssetEnrollmentImportBean> list = new ArrayList<ModifiedAssetEnrollmentImportBean>();
		int columnCount=33;
		
			try{
				if(fileExtension.equals(".xls")){
					
					try {
						InputStream excelFileToRead = new FileInputStream(inFile);
						HSSFWorkbook wb = new HSSFWorkbook(excelFileToRead);

						HSSFSheet sheet = wb.getSheetAt(0);
						HSSFRow row;
						HSSFCell cell;
						int nRows = sheet.getPhysicalNumberOfRows();

						// Loop for traversing each row in the spreadsheet
						for (int r = 0; r < nRows; r++) {
							rowNo = r;
							rowNo++;
							row = sheet.getRow(rowNo);
							if (row != null) {
								// Column count in the current row
								// Loop for traversing each column in each row in the spreadsheet
								for (int c = 0; c < columnCount; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												assetNo = validateData(cell.getStringCellValue().toUpperCase().trim());
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												assetNo = validateData(cell.getStringCellValue().toUpperCase().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												assetNo = null;
											}
											else{
												assetNo = null;
											}
										} else {
											assetNo = null;
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												engineNo = validateData(cell.getStringCellValue().toUpperCase().trim());
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												engineNo = validateData(cell.getStringCellValue().toUpperCase().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												engineNo = null;
											}
											else{
												engineNo = null;
											}
										} else {
											engineNo = null;
										}
										break;	
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												insuranseNo = validateData(cell.getStringCellValue().trim());
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												insuranseNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												insuranseNo = null;
											}else{
												insuranseNo = null;
											}
										} else {
											insuranseNo = null;
										}
										break;
										
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												insuranseExpDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												insuranseExpDate = null;
											}else{
												insuranseExpDate = null;
											}
										} else {
											insuranseExpDate = null;
										}
										break;
										
									case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												pucNo = validateData(cell.getStringCellValue().trim());
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												pucNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												pucNo = null;
											}else{
												pucNo = null;
											}
										} else {
											pucNo = null;
										}
										break;
										
									case 5:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												pucExpDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												pucExpDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												pucExpDate = null;
											}else{
												pucExpDate = null;
											}
										} else {
											pucExpDate = null;
										}
										break;
										
									case 6:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												roadTaxValididtyDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												roadTaxValididtyDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												roadTaxValididtyDate = null;
											}else{
												roadTaxValididtyDate = null;
											}
										} else {
											roadTaxValididtyDate = null;
										}
										break;
									case 7:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												permitValididtyDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												permitValididtyDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												permitValididtyDate = null;
											}else{
												permitValididtyDate = null;
											}
										} else {
											permitValididtyDate = null;
										}
										break;
									case 8:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												challanNo = validateData(cell.getStringCellValue().trim());
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												challanNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												challanNo = null;
											}else{
												challanNo = null;
											}
										} else {
											challanNo = null;
										}
										break;	
									case 9:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												challanDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												challanDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												challanDate = null;
											}else{
												challanDate = null;
											}
										} else {
											challanDate = null;
										}
										break;	
									case 10:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												bankTransactionNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												bankTransactionNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												bankTransactionNo = null;
											}else{
												bankTransactionNo = null;
											}
										} else {
											bankTransactionNo = null;
										}
										break;	
									case 11:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												String amtPaid=cell.getStringCellValue().trim();
												amountPaid = amtPaid.matches("\\d+(\\.\\d+)?")?Double.parseDouble(amtPaid):null;
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												String amtPaid=cell.getStringCellValue().trim();
												amountPaid = amtPaid.matches("\\d+(\\.\\d+)?")?Double.parseDouble(amtPaid):null;
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												amountPaid = null;
											}else{
												amountPaid = null;
											}
										} else {
											amountPaid = null;
										}
										break;	
									case 12:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												validityDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												validityDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												validityDate = null;
											}else{
												validityDate = null;
											}
										} else {
											validityDate = null;
										}
										break;
									case 13:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												operatingOnMine = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												operatingOnMine = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												operatingOnMine = null;
											}else{
												operatingOnMine = null;
											}
										} else {
											operatingOnMine = null;
										}
										break;
									case 14:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												location = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												location = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												location = null;
											}else{
												location = null;
											}
										} else {
											location = null;
										}
										break;
									case 15:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												miningLeaseNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												miningLeaseNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												miningLeaseNo = null;
											}else{
												miningLeaseNo = null;
											}
										} else {
											miningLeaseNo = null;
										}
										break;
									case 16:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												chassisNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												chassisNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												chassisNo = null;
											}else{
												chassisNo = null;
											}
										} else {
											chassisNo = null;
										}
										break;
									case 17:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												constituency = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												constituency = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												constituency = null;
											}else{
												constituency = null;
											}
										} else {
											constituency = null;
										}
										break;
									case 18:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												houseNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												houseNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												houseNo = null;
											}else{
												houseNo = null;
											}
										} else {
											houseNo = null;
										}
										break;
									case 19:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												locality = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												locality = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												locality = null;
											}else{
												locality = null;
											}
										} else {
											locality = null;
										}
										break;
									case 20:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												city = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												city = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												city = null;
											}else{
												city = null;
											}
										} else {
											city = null;
										}
										break;
									case 21:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												taluka = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												taluka = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												taluka = null;
											}else{
												taluka = null;
											}
										} else {
											taluka = null;
										}
										break;
									case 22:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												epicNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												epicNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												epicNo = null;
											}else{
												epicNo = null;
											}
										} else {
											epicNo = null;
										}
										break;
									case 23:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												panNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												panNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												panNo = null;
											}else{
												panNo = null;
											}
										} else {
											panNo = null;
										}
										break;
									case 24:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												mobileNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												mobileNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												mobileNo = null;
											}else{
												mobileNo = null;
											}
										} else {
											mobileNo = null;
										}
										break;
									case 25:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												phoneNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												phoneNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												phoneNo = null;
											}else{
												phoneNo = null;
											}
										} else {
											phoneNo = null;
										}
										break;
									case 26:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												aadharNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												aadharNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												aadharNo = null;
											}else{
												aadharNo = null;
											}
										} else {
											aadharNo = null;
										}
										break;
									case 27:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												bank = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												bank = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												bank = null;
											}else{
												bank = null;
											}
										} else {
											bank = null;
										}
										break;
									case 28:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												branch = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												branch = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												branch = null;
											}else{
												branch = null;
											}
										} else {
											branch = null;
										}
										break;
									case 29:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
												String pBal=cell.getStringCellValue().trim();
												principalBalance = pBal.matches("\\d+(\\.\\d+)?")?Double.parseDouble(pBal):null;
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												String pBal=cell.getStringCellValue().trim();
												principalBalance = pBal.matches("\\d+(\\.\\d+)?")?Double.parseDouble(pBal):null;
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												principalBalance = null;
											}else{
												principalBalance = null;
											}
										} else {
											principalBalance = null;
										}
										break;
									case 30:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
												String pOverDue=cell.getStringCellValue().trim();
												principalOverDue = pOverDue.matches("\\d+(\\.\\d+)?")?Double.parseDouble(pOverDue):null;
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												String pOverDue=cell.getStringCellValue().trim();
												principalOverDue = pOverDue.matches("\\d+(\\.\\d+)?")?Double.parseDouble(pOverDue):null;
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												principalOverDue = null;
											}else{
												principalOverDue = null;
											}
										} else {
											principalOverDue = null;
										}
										break;
									case 31:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
												String iBal=cell.getStringCellValue().trim();
												interestBalance = iBal.matches("\\d+(\\.\\d+)?")?Double.parseDouble(iBal):null;
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												String iBal=cell.getStringCellValue().trim();
												interestBalance = iBal.matches("\\d+(\\.\\d+)?")?Double.parseDouble(iBal):null;
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												interestBalance = null;
											}else{
												interestBalance = null;
											}
										} else {
											interestBalance = null;
										}
										break;
									case 32:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){ 
												accountNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												accountNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												accountNo = null;
											}else{
												accountNo = null;
											}
										} else {
											accountNo = null;
										}
										break;	
									}															
								}
								if(assetNo!=null ||engineNo!=null ||insuranseNo!=null ||insuranseExpDate!=null ||pucNo!=null ||pucExpDate!=null ||challanNo!=null ||challanDate!=null ||bankTransactionNo!=null ||amountPaid!=null ||validityDate!=null ||operatingOnMine!=null ||location!=null ||miningLeaseNo!=null ||chassisNo!=null ||constituency!=null ||houseNo!=null ||locality!=null ||city!=null ||taluka!=null ||epicNo!=null ||panNo!=null ||mobileNo!=null ||phoneNo!=null ||aadharNo!=null ||bank!=null ||branch!=null ||principalBalance!=null ||principalOverDue!=null ||interestBalance!=null ||accountNo!=null
										||roadTaxValididtyDate!=null||permitValididtyDate!=null)
									  list.add(new ModifiedAssetEnrollmentImportBean(assetNo,engineNo,insuranseNo,insuranseExpDate,pucNo,pucExpDate,roadTaxValididtyDate,permitValididtyDate,challanNo,challanDate,bankTransactionNo,amountPaid,validityDate,operatingOnMine,location,miningLeaseNo,chassisNo,constituency,houseNo,locality,city,taluka,epicNo,panNo,mobileNo,phoneNo,aadharNo,bank,branch,principalBalance,principalOverDue,interestBalance,accountNo));
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
						int nRows = sheet.getPhysicalNumberOfRows();

						// Loop for traversing each row in the spreadsheet
						for (int r = 0; r < nRows; r++) {
							rowNo = r;
							rowNo++;
							row = sheet.getRow(rowNo);
							if (row != null) {
								// Column count in the current row
								// Loop for traversing each column in each row in the spreadsheet
								for (int c = 0; c < columnCount; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												assetNo = validateData(cell.getStringCellValue().toUpperCase().trim());
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												assetNo = validateData(cell.getStringCellValue().toUpperCase().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												assetNo = null;
											}
											else{
												assetNo = null;
											}
										} else {
											assetNo = null;
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												engineNo = validateData(cell.getStringCellValue().toUpperCase().trim());
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												engineNo = validateData(cell.getStringCellValue().toUpperCase().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												engineNo = null;
											}
											else{
												engineNo = null;
											}
										} else {
											engineNo = null;
										}
										break;
									case 2:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
											insuranseNo = validateData(cell.getStringCellValue().trim());
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												insuranseNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												insuranseNo = null;
											}
											else{	
												insuranseNo = null;
												}
										} else {
											insuranseNo = null;
										}
										break;
							
									case 3:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
												insuranseExpDate=validateDateFormate(cell.getStringCellValue());
											}else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												insuranseExpDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												insuranseExpDate = null;
											}
											else{	
												insuranseExpDate = null;
												}
										} else {
											insuranseExpDate = null;
										}
										break;
										
									case 4:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												pucNo = validateData(cell.getStringCellValue().trim());
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												pucNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												pucNo = null;
											}else{
												pucNo = null;
											}
										} else {
											pucNo = null;
										}
										break;	
									case 5:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												pucExpDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												pucExpDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												pucExpDate = null;
											}else{
												pucExpDate = null;
											}
										} else {
											pucExpDate = null;
										}
										break;	
									case 6:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												roadTaxValididtyDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												roadTaxValididtyDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												roadTaxValididtyDate = null;
											}else{
												roadTaxValididtyDate = null;
											}
										} else {
											roadTaxValididtyDate = null;
										}
										break;	
									case 7:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												permitValididtyDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												permitValididtyDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												permitValididtyDate = null;
											}else{
												permitValididtyDate = null;
											}
										} else {
											permitValididtyDate = null;
										}
										break;	
									case 8:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												challanNo = validateData(cell.getStringCellValue().trim());
											else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												challanNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												challanNo = "";
											}else{
												challanNo = "";
											}
										} else {
											challanNo = "";
										}
										break;	
									case 9:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												challanDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												challanDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												challanDate = null;
											}else{
												challanDate = null;
											}
										} else {
											challanDate = null;
										}
										break;	
									case 10:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												bankTransactionNo = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												bankTransactionNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												bankTransactionNo = null;
											}else{
												bankTransactionNo = null;
											}
										} else {
											bankTransactionNo = null;
										}
										break;	
									case 11:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												String amtPaid=cell.getStringCellValue().trim();
												amountPaid = amtPaid.matches("\\d+(\\.\\d+)?")?Double.parseDouble(amtPaid):null;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												String amtPaid=cell.getStringCellValue().trim();
												amountPaid = amtPaid.matches("\\d+(\\.\\d+)?")?Double.parseDouble(amtPaid):null;
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												amountPaid = null;
											}else{
												amountPaid = null;
											}
										} else {
											amountPaid = null;
										}
										break;	
									case 12:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												validityDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												validityDate=validateDateFormate(cell.getStringCellValue());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												validityDate = null;
											}else{
												validityDate = null;
											}
										} else {
											validityDate = null;
										}
										break;
									case 13:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												operatingOnMine = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												operatingOnMine = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												operatingOnMine = null;
											}else{
												operatingOnMine = null;
											}
										} else {
											operatingOnMine = null;
										}
										break;
									case 14:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												location = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												location = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												location = null;
											}else{
												location = null;
											}
										} else {
											location = null;
										}
										break;
									case 15:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												miningLeaseNo = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												miningLeaseNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												miningLeaseNo = null;
											}else{
												miningLeaseNo = null;
											}
										} else {
											miningLeaseNo = null;
										}
										break;
									case 16:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												chassisNo = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												chassisNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												chassisNo = null;
											}else{
												chassisNo = null;
											}
										} else {
											chassisNo = null;
										}
										break;
									case 17:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												constituency = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												constituency = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												constituency = null;
											}else{
												constituency = null;
											}
										} else {
											constituency = null;
										}
										break;
									case 18:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												houseNo = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												houseNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												houseNo = null;
											}else{
												houseNo = null;
											}
										} else {
											houseNo = null;
										}
										break;
									case 19:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												locality = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												locality = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												locality = null;
											}else{
												locality = null;
											}
										} else {
											locality = null;
										}
										break;
									case 20:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												city = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												city = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												city = null;
											}else{
												city = null;
											}
										} else {
											city = null;
										}
										break;
									case 21:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												taluka = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												taluka = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												taluka = null;
											}else{
												taluka = null;
											}
										} else {
											taluka = null;
										}
										break;
									case 22:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												epicNo = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												epicNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												epicNo = null;
											}else{
												epicNo = null;
											}
										} else {
											epicNo = null;
										}
										break;
									case 23:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												panNo = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												panNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												panNo = null;
											}else{
												panNo = null;
											}
										} else {
											panNo = null;
										}
										break;
									case 24:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												mobileNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												mobileNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												mobileNo = null;
											}else{
												mobileNo = null;
											}
										} else {
											mobileNo = null;
										}
										break;
									case 25:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												phoneNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												phoneNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												phoneNo = null;
											}else{
												phoneNo = null;
											}
										} else {
											phoneNo = null;
										}
										break;
									case 26:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												aadharNo = validateData(cell.getStringCellValue().trim());;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												aadharNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												aadharNo = null;
											}else{
												aadharNo = null;
											}
										} else {
											aadharNo = null;
										}
										break;
									case 27:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												bank = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												bank = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												bank = null;
											}else{
												bank = null;
											}
										} else {
											bank = null;
										}
										break;
									case 28:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												branch = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												branch = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												branch = null;
											}else{
												branch = null;
											}
										} else {
											branch = null;
										}
										break;
									case 29:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												String pBal=cell.getStringCellValue().trim();
												principalBalance = pBal.matches("\\d+(\\.\\d+)?")?Double.parseDouble(pBal):null;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												String pBal=cell.getStringCellValue().trim();
												principalBalance = pBal.matches("\\d+(\\.\\d+)?")?Double.parseDouble(pBal):null;
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												principalBalance = null;
											}else{
												principalBalance = null;
											}
										} else {
											principalBalance = null;
										}
										break;
									case 30:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
												String pOverDue=cell.getStringCellValue().trim();
												principalOverDue = pOverDue.matches("\\d+(\\.\\d+)?")?Double.parseDouble(pOverDue):null;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												String pOverDue=cell.getStringCellValue().trim();
												principalOverDue = pOverDue.matches("\\d+(\\.\\d+)?")?Double.parseDouble(pOverDue):null;
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												principalOverDue = null;
											}else{
												principalOverDue = null;
											}
										} else {
											principalOverDue = null;
										}
										break;
									case 31:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												String iBal=cell.getStringCellValue().trim();
												interestBalance = iBal.matches("\\d+(\\.\\d+)?")?Double.parseDouble(iBal):null;
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												String iBal=cell.getStringCellValue().trim();
												interestBalance = iBal.matches("\\d+(\\.\\d+)?")?Double.parseDouble(iBal):null;
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												interestBalance = null;
											}else{
												interestBalance = null;
											}
										} else {
											interestBalance = null;
										}
										break;
									case 32:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){ 
												accountNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												accountNo = validateData(cell.getStringCellValue().trim());
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												accountNo = null;
											}else{
												accountNo = null;
											}
										} else {
											accountNo = null;
										}
										break;	
									}															
								}
								if(assetNo!=null ||engineNo!=null ||insuranseNo!=null ||insuranseExpDate!=null ||pucNo!=null ||pucExpDate!=null ||challanNo!=null ||challanDate!=null ||bankTransactionNo!=null ||amountPaid!=null ||validityDate!=null ||operatingOnMine!=null ||location!=null ||miningLeaseNo!=null ||chassisNo!=null ||constituency!=null ||houseNo!=null ||locality!=null ||city!=null ||taluka!=null ||epicNo!=null ||panNo!=null ||mobileNo!=null ||phoneNo!=null ||aadharNo!=null ||bank!=null ||branch!=null ||principalBalance!=null ||principalOverDue!=null ||interestBalance!=null ||accountNo!=null
										||roadTaxValididtyDate!=null||permitValididtyDate!=null)
								   list.add(new ModifiedAssetEnrollmentImportBean(assetNo,engineNo,insuranseNo,insuranseExpDate,pucNo,pucExpDate,roadTaxValididtyDate,permitValididtyDate,challanNo,challanDate,bankTransactionNo,amountPaid,validityDate,operatingOnMine,location,miningLeaseNo,chassisNo,constituency,houseNo,locality,city,taluka,epicNo,panNo,mobileNo,phoneNo,aadharNo,bank,branch,principalBalance,principalOverDue,interestBalance,accountNo));
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				globalJsonArray  = null;
				globalJsonArray = getImportDetailsForAsserEnrollment(clientId, systemId,getValidAsserEnrollmentDetails(list,systemId,userId,clientId,getVehicleDBMap(systemId,clientId)));
				if(globalJsonArray != null && globalJsonArray.length() > 0){
					importMessage = "Success";
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return importMessage;
	}
	
	public synchronized List<ModifiedAssetEnrollmentImportBean> getValidAsserEnrollmentDetails(List<ModifiedAssetEnrollmentImportBean> list,int systemId,int userId,int clientId,Map getVehicleDBMap) {
		List<ModifiedAssetEnrollmentImportBean> validlist = new ArrayList<ModifiedAssetEnrollmentImportBean>();
		ModifiedAssetEnrollmentImportBean validBean = null;
		ModifiedAssetEnrollmentImportBean dbBean = null;
		Date currDate = new Date();
		String operatingOnMineText="Operating On Mine";
		String locationText="Location";
		String minigLeaseNoText="Mining Lease No"; 
		String chassisNoText="Chassis No";
		String constituencyText="Assembly Constituency";
		String houseNoText="House No";
		String localityText="Locality";
		String cityText="City/Village";
		String talukaText="Taluka";
		String epicNoText="EPIC No";
		String panNoText="PAN No";
		String mobileNoText="Mobile No"; 
		String phoneNoText="Phone No";
		String aadharNoText="Aadhar No";
		String bankText="Bank";
		String branchText="Branch"; 
		String accountNoText="Account No";
		
			if(list.size()!=0){
			
				for (ModifiedAssetEnrollmentImportBean modAssetBean : list) {
					validBean= new ModifiedAssetEnrollmentImportBean();
					dbBean= null;
					if(modAssetBean.assetNo!=null){
						if(getVehicleDBMap.containsKey(modAssetBean.assetNo)){
						dbBean = (ModifiedAssetEnrollmentImportBean) getVehicleDBMap.get(modAssetBean.assetNo);
						validBean.assetNo=modAssetBean.assetNo;
						validBean.UID=dbBean.UID;
						
						if(modAssetBean.engineNo==null){
							validBean.engineNo=dbBean.engineNo;
						}else{
							if(modAssetBean.engineNo.length()>50){
								validBean.remarks = "Engine Number Exceeded it's Maximum length. Please make it simple.";
							}
							validBean.engineNo=modAssetBean.engineNo;
						}
						
						if(modAssetBean.insuranseNo==null&&modAssetBean.insuranseExpDate==null){
							validBean.insuranseNo=dbBean.insuranseNo;
							validBean.insuranseExpDate=dbBean.insuranseExpDate;
						}else if(modAssetBean.insuranseNo!=null&&modAssetBean.insuranseExpDate!=null){
							validBean.insuranseNo=modAssetBean.insuranseNo;
							if(currDate.compareTo(modAssetBean.insuranseExpDate)>0){
								validBean.remarks="Insurance Expiry Date should not be less than current Date";
								validBean.insuranseExpDate=modAssetBean.insuranseExpDate;
								validBean.insuranseNo=modAssetBean.insuranseNo;
							}else{
								validBean.insuranseExpDate=modAssetBean.insuranseExpDate;
							}
						}else if(modAssetBean.insuranseNo!=null||modAssetBean.insuranseExpDate!=null){
							if(modAssetBean.insuranseNo==null){
								validBean.remarks="Insurance Number should not be empty.";
								validBean.insuranseExpDate=modAssetBean.insuranseExpDate;
							}else if(modAssetBean.insuranseExpDate==null){
								validBean.remarks="Insurance Expiry Date should not be empty. It should be in Standard format.";
								validBean.insuranseNo=modAssetBean.insuranseNo;
							}
						}
						
						if(modAssetBean.pucNo==null&&modAssetBean.pucExpDate==null){
							validBean.pucNo=dbBean.pucNo;
							validBean.pucExpDate=dbBean.pucExpDate;
						}else if(modAssetBean.pucNo!=null&&modAssetBean.pucExpDate!=null){
							validBean.pucNo=modAssetBean.pucNo;
							if(currDate.compareTo(modAssetBean.pucExpDate)>0){
								validBean.remarks="Puc Expiry Date should not be less than current Date";
								validBean.pucExpDate=modAssetBean.pucExpDate;
								validBean.pucNo=modAssetBean.pucNo;
							}else{
								validBean.pucExpDate=modAssetBean.pucExpDate;
							}
						}else if(modAssetBean.pucNo!=null||modAssetBean.pucExpDate!=null){
							if(modAssetBean.pucNo==null){
								validBean.remarks="Puc Number should not be empty.";
								validBean.pucExpDate=modAssetBean.pucExpDate;
							}else if(modAssetBean.pucExpDate==null){
								validBean.remarks="Puc Expiry Date should not be empty. It should be in Standard format.";
								validBean.pucNo=modAssetBean.pucNo;
							}
						}
						
						if(modAssetBean.roadTaxValididtyDate==null){
							validBean.roadTaxValididtyDate=dbBean.roadTaxValididtyDate;
						}else if(modAssetBean.roadTaxValididtyDate!=null){
							if(currDate.compareTo(modAssetBean.roadTaxValididtyDate)>0){
								validBean.remarks="RoadTax Validation Date should not be less than current Date";
								validBean.roadTaxValididtyDate=modAssetBean.roadTaxValididtyDate;
							}else{
								validBean.roadTaxValididtyDate=modAssetBean.roadTaxValididtyDate;
							}
						}else if(modAssetBean.roadTaxValididtyDate!=null){
							if(modAssetBean.roadTaxValididtyDate==null){
								validBean.remarks="RoadTax Validation Date should not be empty. It should be in Standard format.";
							}
						}
						
						if(modAssetBean.permitValididtyDate==null){
							validBean.permitValididtyDate=dbBean.permitValididtyDate;
						}else if(modAssetBean.permitValididtyDate!=null){
							if(currDate.compareTo(modAssetBean.permitValididtyDate)>0){
								validBean.remarks="permit Validation Date should not be less than current Date";
								validBean.permitValididtyDate=modAssetBean.permitValididtyDate;
							}else{
								validBean.permitValididtyDate=modAssetBean.permitValididtyDate;
							}
						}else if(modAssetBean.permitValididtyDate!=null){
							if(modAssetBean.permitValididtyDate==null){
								validBean.remarks="permit Validation Date should not be empty. It should be in Standard format.";
							}
						}
						
					if(modAssetBean.challanNo==null&&modAssetBean.challanDate==null&&modAssetBean.bankTransactionNo==null&&modAssetBean.amountPaid==null&&modAssetBean.validityDate==null){
						validBean.challanNo=dbBean.challanNo;
						validBean.challanDate=dbBean.challanDate;
						validBean.bankTransactionNo=dbBean.bankTransactionNo;
						validBean.amountPaid=dbBean.amountPaid;
						validBean.validityDate=dbBean.validityDate;
						validBean.assetStatus=dbBean.assetStatus;
					}else if(modAssetBean.challanNo==null&&modAssetBean.challanDate==null){
						validBean.remarks="Challan Details should not be empty.";
						validBean.bankTransactionNo=modAssetBean.bankTransactionNo;
						validBean.amountPaid=modAssetBean.amountPaid;
						validBean.validityDate=modAssetBean.validityDate;
					}else if(modAssetBean.bankTransactionNo==null&&modAssetBean.amountPaid==null){
						validBean.remarks="Payment Details should not be empty.";
						validBean.challanNo=modAssetBean.challanNo;
						validBean.challanDate=modAssetBean.challanDate;
						validBean.validityDate=modAssetBean.validityDate;
					}else if(modAssetBean.validityDate==null){
						validBean.remarks="Validity Expiry Date should not be empty.";
						validBean.challanNo=modAssetBean.challanNo;
						validBean.challanDate=modAssetBean.challanDate;
						validBean.bankTransactionNo=dbBean.bankTransactionNo;
						validBean.amountPaid=dbBean.amountPaid;
						validBean.validityDate=modAssetBean.validityDate;
					}else{
					
						if(modAssetBean.challanNo==null&&modAssetBean.challanDate==null){
							validBean.challanNo=dbBean.challanNo;
							validBean.challanDate=dbBean.challanDate;
						}else if(modAssetBean.challanNo!=null&&modAssetBean.challanDate!=null){
							validBean.challanNo=modAssetBean.challanNo;
							validBean.challanDate=modAssetBean.challanDate;
						}else if(modAssetBean.challanNo!=null||modAssetBean.challanDate!=null){
							if(modAssetBean.challanNo==null){
								validBean.remarks="Challan Number should not be empty.";
								validBean.challanDate=modAssetBean.challanDate;
							}else if(modAssetBean.challanDate==null){
								validBean.remarks="Challan Date should not be empty. It should be in Standard format.";
								validBean.challanNo=modAssetBean.challanNo;
							}
						}

						if(modAssetBean.bankTransactionNo==null&&modAssetBean.amountPaid==null){
							validBean.bankTransactionNo=dbBean.bankTransactionNo;
							validBean.amountPaid=dbBean.amountPaid;
						}else if(modAssetBean.bankTransactionNo!=null&&modAssetBean.amountPaid!=null){
							validBean.bankTransactionNo=modAssetBean.bankTransactionNo;
							if(modAssetBean.amountPaid<0){
								validBean.remarks="Amount paid should be greter than zero.";
								validBean.bankTransactionNo=modAssetBean.bankTransactionNo;
							}else{
								validBean.amountPaid=modAssetBean.amountPaid;
							}
						}else if(modAssetBean.bankTransactionNo!=null||modAssetBean.amountPaid!=null){
							if(modAssetBean.bankTransactionNo==null){
								validBean.remarks="Bank Transaction Number should not be empty.";
								validBean.amountPaid=modAssetBean.amountPaid;
							}else if(modAssetBean.amountPaid==null){
								validBean.remarks="Amount paid should not be empty.";
								validBean.bankTransactionNo=modAssetBean.bankTransactionNo;
							}
						}
						
						if(modAssetBean.validityDate==null){
							validBean.validityDate=dbBean.validityDate;
							validBean.assetStatus=dbBean.assetStatus;
						}else{
							if(currDate.compareTo(modAssetBean.validityDate)>=0){
								validBean.remarks="Validity Date should be future Date";
								validBean.validityDate=dbBean.validityDate;
								validBean.assetStatus=dbBean.assetStatus;
							}else{
								validBean.validityDate=modAssetBean.validityDate;
								validBean.assetStatus="Active";
							}
						}
					}
					validBean.operatingOnMine=validateSize(validBean,operatingOnMineText,modAssetBean.operatingOnMine,50);
					validBean.location=validateSize(validBean,locationText,modAssetBean.location,500);
					validBean.miningLeaseNo=validateSize(validBean,minigLeaseNoText,modAssetBean.miningLeaseNo,50);
					validBean.chassisNo=validateSize(validBean,chassisNoText,modAssetBean.chassisNo,25);
					validBean.constituency=validateSize(validBean,constituencyText,modAssetBean.constituency,50);
					validBean.houseNo=validateSize(validBean,houseNoText,modAssetBean.houseNo,50);
					validBean.locality=validateSize(validBean,localityText,modAssetBean.locality,50);
					validBean.city=validateSize(validBean,cityText,modAssetBean.city,50);
					validBean.taluka=validateSize(validBean,talukaText,modAssetBean.taluka,50);
					validBean.epicNo=validateSize(validBean,epicNoText,modAssetBean.epicNo,50);
					validBean.panNo=validateSize(validBean,panNoText,modAssetBean.panNo,50);
					validBean.mobileNo=isNumeric(validBean,mobileNoText,modAssetBean.mobileNo)==true?validateSize(validBean,mobileNoText,modAssetBean.mobileNo,10):null;
					validBean.phoneNo=isNumeric(validBean,phoneNoText,modAssetBean.phoneNo)==true?validateSize(validBean,phoneNoText,modAssetBean.phoneNo,15):null;
					validBean.aadharNo=validateSize(validBean,aadharNoText,modAssetBean.aadharNo,16);
					validBean.bank=validateSize(validBean,bankText,modAssetBean.bank,50);
					validBean.branch=validateSize(validBean,branchText,modAssetBean.branch,50);
					validBean.principalBalance=modAssetBean.principalBalance;
					validBean.principalOverDue=modAssetBean.principalOverDue;
					validBean.interestBalance=modAssetBean.interestBalance;
					validBean.accountNo=validateSize(validBean,accountNoText,modAssetBean.accountNo,50);
						
						}else{validBean.remarks="Asset Number should not be New one.";}
					}else{
						validBean.remarks="Asset Number should not be empty.";
					}
					validlist.add(validBean);
				}
			}
		return validlist;
	}

	public JSONArray getImportDetailsForAsserEnrollment(int clientId, int systemId, List<ModifiedAssetEnrollmentImportBean> list) {

		JSONArray jsonArray = null;
		JSONObject jsonObj = null;
		int count = 0;		
		try {
			jsonArray = new JSONArray();
			jsonObj = new JSONObject();		
						
			for (ModifiedAssetEnrollmentImportBean bean : list) {
				count++;
				jsonObj = new JSONObject();
			
				jsonObj.put("impSlnoIdx", count);
				jsonObj.put("impAssetNoIdx", bean.assetNo);
				jsonObj.put("impEngineNoIdx", bean.engineNo);
				jsonObj.put("UIDIdx", bean.UID);
				jsonObj.put("impInsuranseNoIdx", bean.insuranseNo);
				jsonObj.put("impInsuranseExpDateIdx", bean.insuranseExpDate!=null?MMddyyyy.format(bean.insuranseExpDate):null);
				jsonObj.put("impPucNoIdx", bean.pucNo);
				jsonObj.put("impPucExpDate", bean.pucExpDate!=null?MMddyyyy.format(bean.pucExpDate):null);
				jsonObj.put("impRoadTaxValDate", bean.roadTaxValididtyDate!=null?MMddyyyy.format(bean.roadTaxValididtyDate):null);
				jsonObj.put("imppermitValDate", bean.permitValididtyDate!=null?MMddyyyy.format(bean.permitValididtyDate):null);
				jsonObj.put("impChallanNoIdx", bean.challanNo);
				jsonObj.put("impChallanDateIdx", bean.challanDate!=null?MMddyyyy.format(bean.challanDate):null);
				jsonObj.put("impBankTransactionNoIdx", bean.bankTransactionNo);
				jsonObj.put("impAmountPaidIdx", bean.amountPaid);
				jsonObj.put("impValidityDateIdx", bean.validityDate!=null?MMddyyyy.format(bean.validityDate):null);
				jsonObj.put("impOperatingOnMineIdx", bean.operatingOnMine);
				jsonObj.put("impLocationIdx", bean.location);
				jsonObj.put("impMiningLeaseNoIdx", bean.miningLeaseNo);
				jsonObj.put("impChassisNoIdx", bean.chassisNo);
				jsonObj.put("impConstituencyIdx", bean.constituency);
				jsonObj.put("impHouseNoIdx", bean.houseNo);
				jsonObj.put("impLocalityIdx", bean.locality);
				jsonObj.put("impCityIdx", bean.city);
				jsonObj.put("impTalukaIdx", bean.taluka);
				jsonObj.put("impEpicNoIdx", bean.epicNo);
				jsonObj.put("impPanNoIdx", bean.panNo);
				jsonObj.put("impMobileNoIdx", bean.mobileNo);
				jsonObj.put("impPhoneNoIdx", bean.phoneNo);
				jsonObj.put("impAadharNoIdx", bean.aadharNo);
				jsonObj.put("impBankIdx", bean.bank);
				jsonObj.put("impBranchIdx", bean.branch);
				jsonObj.put("impPrincipalBalanceIdx", bean.principalBalance);
				jsonObj.put("impPrincipalOverDueIdx", bean.principalOverDue);
				jsonObj.put("impInterestBalanceIdx", bean.interestBalance);
				jsonObj.put("impAccountNoIdx", bean.accountNo);
				jsonObj.put("impAssetStatusIdx", bean.assetStatus);
				jsonObj.put("impValidStatusIdx", bean.remarks!=null?"Invalid":"Valid");
				jsonObj.put("importRemarksIndex", bean.remarks!=null?bean.remarks:"");
				
				jsonArray.put(jsonObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return jsonArray;
	}
	
	private Map<String, ModifiedAssetEnrollmentImportBean> getVehicleDBMap(int systemId, int customerId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ModifiedAssetEnrollmentImportBean assetDBBean;
		Map<String, ModifiedAssetEnrollmentImportBean> assetDBMap = new HashMap<String, ModifiedAssetEnrollmentImportBean>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select ID,ASSET_NUMBER,INSURANCE_POLICY_NO,INSURANCE_EXPIRY_DATE,PUC_NUMBER,PUC_EXPIRY_DATE,CHALLAN_NO,CHALLAN_DATE,BANK_TRANSACTION_NUMBER,AMOUNT_PAID,VALIDITY_DATE,STATUS " +
										 "from AMS.dbo.MINING_ASSET_ENROLLMENT where SYSTEM_ID=? and CUSTOMER_ID=?");
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				assetDBBean=new ModifiedAssetEnrollmentImportBean();
				assetDBBean.setAssetNo(rs.getString("ASSET_NUMBER").toUpperCase());
				assetDBBean.setInsuranseNo(rs.getString("INSURANCE_POLICY_NO"));
				assetDBBean.setInsuranseExpDate(rs.getDate("INSURANCE_EXPIRY_DATE"));
				assetDBBean.setPucNo(rs.getString("PUC_NUMBER"));
				assetDBBean.setPucExpDate(rs.getDate("PUC_EXPIRY_DATE"));
				assetDBBean.setChallanNo(rs.getString("CHALLAN_NO"));
				assetDBBean.setChallanDate(rs.getDate("CHALLAN_DATE"));
				assetDBBean.setBankTransactionNo(rs.getString("BANK_TRANSACTION_NUMBER"));
				assetDBBean.setAmountPaid(rs.getDouble("AMOUNT_PAID"));
				assetDBBean.setValidityDate(rs.getDate("VALIDITY_DATE"));
				assetDBBean.setAssetStatus(rs.getString("STATUS"));
				assetDBBean.setUID(rs.getInt("ID"));
				assetDBMap.put(rs.getString("ASSET_NUMBER").toUpperCase(), assetDBBean);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return assetDBMap;
		
	}
	private Date validateDateFormate(String date){
		Date date_=null;
		if(date!=null&&date!=""){
			try {
				date_=ddMMyyyy.format(ddMMyyyy.parse(date)).equals(date)?ddMMyyyy.parse(date):null;
			} catch (Exception e) { date_=null; }
		}
		return date_;
	}
	private String validateData(String data){		
		return data.trim().equals("")?null:data;
	}
	private String validateSize(ModifiedAssetEnrollmentImportBean validBean, String text, String data, int size){
		if(data==null) return null;
		if(data.length()>size){
			validBean.remarks=text+" field exccede it's Maximum length "+size;
		}
		return data;
	}
	private boolean isNumeric(ModifiedAssetEnrollmentImportBean validBean, String text, String data){		
		if(data==null)return false;
		try{
			Double.parseDouble(data);
		}catch (Exception e) {
			validBean.remarks=text+" field should have Numbers only!";
			return false;
		}return true;
	}
}
