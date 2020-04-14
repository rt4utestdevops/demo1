package t4u.ironMining;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.List;
import java.util.Set;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.functions.IronMiningFunction;
import t4u.statements.IronMiningStatement;

public class TripDetailsExcelImport {
	static JSONArray globalJsonArray = new JSONArray();

	private File inFile;
	private String fileExtension;
	private int userId;
	private int systemId;
	private int clientId;
	private int offset;
	private String btsNo;
	private float bargeCapacity;
	private int bargeLocationId;
	private int orgIdI;
	
	
	private String type;
	private String vehicleNumber;
	private String validityDate;
	private String permitNo;
	private String grossWeight;
	private String status;
	private String remarks;
	private String transactionID;
	private String bargeID;

	private int rowNo;
	String message = "";
	String format = "";
	public TripDetailsExcelImport(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension,String btsNo,float bargebargeCapacity,int orgIdI,int bargeLocationId){
		this.inFile = inFile;
		this.userId =  userId;
		this.systemId = systemId;
		this.clientId = clientId;
		this.offset=offset;
		this.fileExtension = fileExtension;
		this.btsNo = btsNo;
		this.bargeCapacity = bargebargeCapacity;
		this.orgIdI = orgIdI;
		this.bargeLocationId = bargeLocationId;
	}
	
	/** return message */
	public String getMessage(){
		return message;
	}
	
@SuppressWarnings("deprecation")
public String importExcelData(){	
	String importMessage = "";
	List<TripDetailsData> list = new ArrayList();	
	
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
							for (int c = 0; c < 7; c++) {
								cell = row.getCell((short) c);
								// If cell contains String value
								switch (c) {
								case 0:
									if (cell != null){
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
											type = cell.getStringCellValue();
										else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											type = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											type = "";
										}else{
											format = "Invalid";
										}
									}else {
										type = "";
									}
									break;
								case 1:
									if (cell != null){
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
											vehicleNumber = cell.getStringCellValue();
										else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											vehicleNumber = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											vehicleNumber = "";
										}
										else{
											format = "Invalid";
										}
									} else {
										vehicleNumber = "";
									}
									break;
								
								case 2:
									if (cell != null){
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
											try{
												SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
												validityDate = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
												if(!cell.getStringCellValue().equals(validityDate)){
													validityDate=cell.getStringCellValue()+"Invalid";
												}
											}catch (Exception e) {
												validityDate=cell.getStringCellValue() + "Invalid";
											}
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											validityDate = "";
										}else
											format = "Invalid";
									} else {
										validityDate = "";
									}
									break;
								case 3:
									if (cell != null){
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
											permitNo = cell.getStringCellValue();
										else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											permitNo = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											permitNo = "";
										}else{
											format = "Invalid";
										}
									} else {
										permitNo = "";
									}
									break;
									
								case 4:
									if (cell != null){
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
											grossWeight = cell.getStringCellValue();
										else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											grossWeight = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											grossWeight = "";
										}else{
											format = "Invalid";
										}
									} else {
										grossWeight = "";
									}
									break;
									
								case 5:
									if (cell != null){
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
											transactionID = cell.getStringCellValue();
										else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											transactionID = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											transactionID = "";
										}else{
											format = "Invalid";
										}
									} else {
										transactionID = "";
									}
									break;
								case 6:
									if (cell != null){
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
											bargeID = cell.getStringCellValue();
										else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											bargeID = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											bargeID = "";
										}else{
											format = "Invalid";
										}
									} else {
										bargeID = "";
									}
									break;
					
								}															
							}
							if(type!="" || vehicleNumber!="" || permitNo!="" || validityDate!="" || grossWeight!="" || transactionID!="" || bargeID!="" )
								  list.add(new TripDetailsData(type,vehicleNumber,validityDate,permitNo,grossWeight,status,"",0.0f,0.0f,0.0f,"",0,0,0,0,transactionID,bargeID,""));
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
							//cols = sheet.getRow(r).getLastCellNum();
							// Loop for traversing each column in each row in the spreadsheet
							for (int c = 0; c < 7; c++) {
								cell = row.getCell((short) c);
								// If cell contains String value
								switch (c) {
								case 0:
									if (cell != null){ 
										if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
											type = cell.getStringCellValue();
										else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(XSSFCell.CELL_TYPE_STRING);
											type = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											type = "";
										}else{
											format = "Invalid";
										}
									} else {
										type = "";
									}
									break;
								case 1:
									if (cell != null){
										if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
										vehicleNumber = cell.getStringCellValue();
										else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(XSSFCell.CELL_TYPE_STRING);
											vehicleNumber = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											vehicleNumber = "";
										}
										else{
											format = "Invalid";
										}
									} else {
										vehicleNumber = "";
									}
									break;
								case 2:
									if (cell != null){
										if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
											try{
												SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
												validityDate = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
												if(!cell.getStringCellValue().equals(validityDate)){
													validityDate=cell.getStringCellValue()+"Invalid";
												}
											}catch (Exception e) {
												validityDate=cell.getStringCellValue()+"Invalid";
											}
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											validityDate = "";
										}else
											format = "Invalid";
									} else {
										validityDate = "";
									}
									break;
								case 3:
									if (cell != null){
										if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
										permitNo = cell.getStringCellValue();
										else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(XSSFCell.CELL_TYPE_STRING);
											permitNo = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											permitNo = "";
										}
										else{	
											format = "Invalid";
											}
									} else {
										permitNo = "";
									}
									break;
						
								case 4:
									if (cell != null){
										if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
										grossWeight = cell.getStringCellValue();
										else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
											cell.setCellType(XSSFCell.CELL_TYPE_STRING);
											grossWeight = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											grossWeight = "";
										}
										else{	
											format = "Invalid";
											}
									} else {
										grossWeight = "";
									}
									break;
									
								case 5:
									if (cell != null){
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
											transactionID = cell.getStringCellValue();
										else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											transactionID = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											transactionID = "";
										}else{
											format = "Invalid";
										}
									} else {
										transactionID = "";
									}
									break;
									
								case 6:
									if (cell != null){
										if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
											bargeID = cell.getStringCellValue();
										else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
											cell.setCellType(HSSFCell.CELL_TYPE_STRING);
											bargeID = cell.getStringCellValue();
										}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
											bargeID = "";
										}else{
											format = "Invalid";
										}
									} else {
										bargeID = "";
									}
									break;
								}															
							}
							if(type!="" || vehicleNumber!="" || permitNo!="" || validityDate!="" || grossWeight!="" || transactionID!="" || bargeID!="" )
								 list.add(new TripDetailsData(type,vehicleNumber,validityDate,permitNo,grossWeight,status,"",0.0f,0.0f,0.0f,"",0,0,0,0,transactionID,bargeID,""));
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			globalJsonArray  = null;
			globalJsonArray = getImportExcelUnitDetails(clientId, systemId,getValidTripDetails(list,systemId,userId,clientId,btsNo,bargeLocationId,orgIdI));
			if(globalJsonArray != null && globalJsonArray.length() > 0){
				importMessage = "Success";
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return importMessage;
	}

	
	public synchronized List<TripDetailsData> getValidTripDetails(List<TripDetailsData> list,int systemId,int userId,int clientId,String btsNo,int bargeLocationId,int orgIdI) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String tripstatus = "";
		String perNo="";
		int perId=0;
		String grade="";
		float permitQty=0;
		float balanceQty=0;
		float permitbalanceQty=0;
		int srcHubId;
		int deshubId;
		String routeName;
		int orgCode=0;
		int tcId=0;
		int routeId=0;
		float tareWeight=0;
		float actualQuantity;
		float covertTotons;
		float netWeight=0;
		float netWeightIntons = 0;
		float bargeAvailableBalance=0;
		float bargeQuantity=0;
		String permitId="0";
		String permitIds="";
		String permitId1[];
		String permitNo="";
		Set<String> transactionIds=new HashSet<String>();
		Hashtable<String,String> vehicleHTable=new Hashtable<String,String>();
		String BargeID="";
		float sumOfWeights=0;
		DecimalFormat df=new DecimalFormat("#.###");
		List<TripDetailsData> validlist = new ArrayList();
		SimpleDateFormat ddMMyyyy = new SimpleDateFormat("yyyy-MM-dd");
		IronMiningFunction ironf=new IronMiningFunction();
		Date validDateTime;
		Date startDate = null;
		Date endDate=null;
		int commHours=0;
		String commStatus="";
		int permitOrgId=0;
		int permitTcid=0;
		int bargeLoc=0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(list.size()!=0 && !format.equalsIgnoreCase("Invalid")){
			    Date dateobj = new Date();
			    validDateTime=(Date) ironf.convertStringToDate1(ddMMyyyy.format(dateobj));
				
			    if(list.get(0).permitNo!=""){
			    pstmt = con.prepareStatement(IronMiningStatement.CHECK_PERMIT_NUMBER);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,clientId);
				pstmt.setString(3,list.get(0).permitNo);
				rs = pstmt.executeQuery();
				if(rs.next()){
			    
				pstmt = con.prepareStatement(IronMiningStatement.GET_PERMIT_DETAILS_FOR_IMPORT);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,clientId);
				pstmt.setString(3,list.get(0).permitNo);
				rs = pstmt.executeQuery();
				if(rs.next()){
					permitId=rs.getString("ID");
					routeId=rs.getInt("ROUTE_ID");
					routeName = rs.getString("ROUTE_NAME");
					permitOrgId = rs.getInt("ORGANIZATION_CODE");
					permitTcid= rs.getInt("TC_ID");
					startDate=(Date) ironf.convertStringToDate1(rs.getString("START_DATE"));
					endDate=(Date) ironf.convertStringToDate1(rs.getString("END_DATE"));
					if (rs.getInt("CHALLAN_ID")>0) {
						permitQty = Float.parseFloat(df.format(rs.getFloat("QUANTITY")));
					}else{
						permitQty = Float.parseFloat(df.format(rs.getFloat("POTQUANTITY")));
					}
					actualQuantity=rs.getFloat("TRIPSHEET_QTY");
					covertTotons=actualQuantity/1000;
					
					if (rs.getInt("CHALLAN_ID")>0) {
						balanceQty=Float.parseFloat(df.format(rs.getFloat("QUANTITY")-covertTotons));
					}else{
						balanceQty=Float.parseFloat(df.format(rs.getFloat("POTQUANTITY")-covertTotons));
					}
					grade = rs.getString("GRADE")+"("+rs.getString("TYPE")+")";
					permitbalanceQty = balanceQty;
				}
				}
				}

					pstmt = con.prepareStatement(IronMiningStatement.GET_BARGE_DETAILS_FOR_IMPORT);
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,clientId);
					pstmt.setString(3,btsNo);
					rs = pstmt.executeQuery();
					if(rs.next()){
						bargeQuantity= rs.getFloat("BARGEQUANTITY");
					}
					
					pstmt = con.prepareStatement(IronMiningStatement.CHECK_PERMIT_NO);
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,clientId);
					pstmt.setInt(3,userId);
					rs1 = pstmt.executeQuery();
					if (rs1.next()){
						orgCode= rs1.getInt("ORGANISATION_CODE");
						tcId = rs1.getInt("TC_ID");
						permitIds=rs1.getString("PERMIT_IDS");
						bargeLoc= rs1.getInt("PERMIT_ID");
						if(permitIds!=""){
						permitId1=permitIds.split(",");
						for(int i=0;i<permitId1.length;i++){
							permitNo=permitNo+"'"+permitId1[i]+"',";
						}
						}
					}
					
					pstmt = con.prepareStatement(IronMiningStatement.GET_VEHILCE_NO_FOR_TRIP_SHEET_GEN_TRUCK);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2,clientId);
					pstmt.setInt(3, systemId);
					pstmt.setInt(4,clientId);
					rs = pstmt.executeQuery();
					while(rs.next())
					{
						 vehicleHTable.put(rs.getString("VNAME"), rs.getString("PUC_EXP_STATUS")+","+rs.getString("INSURANCE_EXP_STATUS"));
					}
					
					pstmt = con.prepareStatement(IronMiningStatement.CHECK_BARGE_ID);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2,clientId);
					pstmt.setString(3, btsNo);
					rs = pstmt.executeQuery();
					if(rs.next())
					{
						 BargeID=rs.getString("VEHICLE_ID");
					}
					
					int k=0;
			for (TripDetailsData tripDetails : list) {
				pstmt = con.prepareStatement(IronMiningStatement.GET_TIME_DETAILS);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,clientId);
				rs = pstmt.executeQuery();
				if(rs.next())
				{
					 commHours=rs.getInt("NON_COMM_HRS");
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_COMM_STATUS);
				pstmt.setInt(1, commHours);
				pstmt.setString(2, list.get(k).vehicleNumber);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4,clientId);
				rs = pstmt.executeQuery();
				if(rs.next())
				{
					 commStatus=rs.getString("COMM_STATUS");
				}
				if(permitOrgId!=orgIdI){
					tripDetails.remarks = "Invalid organization permit ";
					tripstatus="Invalid";
				}
				if(bargeLoc!=bargeLocationId){
					tripDetails.remarks = " Invalid barge Location ";
					tripstatus="Invalid";
				}
				if(commStatus.equalsIgnoreCase("NOT_APPLICABLE")){
					tripDetails.remarks = " Vehicle is not communicating ";
					tripstatus="Invalid";
				}
				if(tripDetails.type=="" || !tripDetails.type.equals("Application")){
					tripDetails.remarks = " Invalid Type ";
					tripstatus="Invalid";
				}
				else if(tripDetails.vehicleNumber==""){
					tripDetails.remarks= "Invalid Vehicle Number";
					tripstatus="Invalid";
				}
				else if(tripDetails.validityDate==null || tripDetails.validityDate=="" || tripDetails.validityDate.contains("Invalid")){
					tripDetails.remarks = " Invalid Validity DateTime Format";
					tripstatus="Invalid";
				}
				else if(tripDetails.transactionID==""){
					tripDetails.remarks = "Invalid Transaction ID ";
					tripstatus="Invalid";
				}else{
					pstmt = con.prepareStatement(IronMiningStatement.CHECK_TRANSACTION_ID);
					pstmt.setInt(1,systemId);
					pstmt.setInt(2,clientId);
					pstmt.setString(3,tripDetails.transactionID);
					rs1 = pstmt.executeQuery();
					if(rs1.next()){
						tripDetails.remarks = "Transaction ID already present";
						tripstatus="Invalid";
					}else{
						if(transactionIds.contains(tripDetails.transactionID)){
							tripDetails.remarks = "Transaction ID already used in this sheet";
							tripstatus="Invalid";
						}else{
							transactionIds.add(tripDetails.transactionID);
						}
					}
				}
				if(!tripDetails.bargeID.equals(BargeID) && tripstatus!="Invalid"){
					tripDetails.remarks= "Invalid Barge Id";
					tripstatus="Invalid";
				}
				else if((tripDetails.permitNo=="" || startDate==null || endDate==null) && tripstatus!="Invalid"){
					tripDetails.remarks = "Invalid Permit Number";
					tripstatus="Invalid";
				}
				//perNo=list.get(0).permitNo;
				else if(list.get(0).permitNo!=tripDetails.permitNo && tripstatus!="Invalid"){
					tripDetails.remarks = " Please use single permit ";
					tripstatus="Invalid";
				}
				else if((!(tripDetails.permitNo.startsWith("IE") || tripDetails.permitNo.startsWith("DE")))&& tripstatus!="Invalid"){
					tripDetails.remarks = " Please use Internation Export and Domestic Permit ";
					tripstatus="Invalid";
				}
				else{
					
					if(permitIds=="" && tripstatus!="Invalid"){
						tripDetails.remarks = " Please do User setting ";
						tripstatus="Invalid";
					}
					else if(permitNo.contains("'"+permitId+"'")==false && tripstatus!="Invalid"){
							tripDetails.remarks = " Permit is not associated to user ";
							tripstatus="Invalid";
						}
					
					else if(startDate==null && endDate==null && tripstatus!="Invalid" && (!((validDateTime.after(startDate) || validDateTime.equals(startDate)) && (validDateTime.before(endDate) || validDateTime.equals(endDate))))){
							tripDetails.remarks = " Permit Validity Expired ";
							tripstatus="Invalid";
						}
						
					else if((tripDetails.vehicleNumber==null || tripDetails.vehicleNumber=="" || !vehicleHTable.containsKey(tripDetails.vehicleNumber))&& tripstatus!="Invalid"){
						tripDetails.remarks = "Invalid Vehicle Number";
						tripstatus="Invalid";
					}	
					else{
					  String[] expr = vehicleHTable.get(tripDetails.vehicleNumber).split(",");
					  if(expr[0].equals("False")){
						tripDetails.remarks = "PUC Date has Expired";
						tripstatus="Invalid";
					  }else if(expr[1].equals("False")){
						tripDetails.remarks = "Insurance Date has Expired";
						tripstatus="Invalid";
					  }else{
						pstmt = con.prepareStatement(IronMiningStatement.GET_VEHICLE_TARE_WEIGHT_FOR_IMPORT);
						pstmt.setString(1,tripDetails.vehicleNumber);
						pstmt.setInt(2,systemId);
						pstmt.setString(3,tripDetails.vehicleNumber);
						pstmt.setInt(4, systemId);
						rs = pstmt.executeQuery();
						if(rs.next()){
							tareWeight = rs.getFloat("QUANTITY1");
						
						
						if((tripDetails.grossWeight==null || tripDetails.grossWeight=="")&& tripstatus!="Invalid"){
							tripDetails.remarks = " Invalid Gross Weight ";
							tripstatus="Invalid";
						}else{	
						if(tripDetails.grossWeight!=""){
						netWeight=Float.parseFloat(tripDetails.grossWeight)-tareWeight;
						netWeightIntons=netWeight/1000;
						if(!(netWeight>0) && tripstatus!="Invalid"){
							tripDetails.remarks = " Tare Weight is greater than Gross Weight ";
							tripstatus="Invalid";
						}
						}else if(tripstatus!="Invalid"){
							tripDetails.remarks = " Invalid Gross Weight ";
							tripstatus="Invalid";
						}
						if(netWeightIntons>balanceQty && tripstatus!="Invalid"){
							tripDetails.remarks = " Permit Balance is over ";
							tripstatus="Invalid";
						}
//						if(netWeightIntons>0 && netWeightIntons!=balanceQty && tripstatus!="Invalid"){
//							balanceQty=Float.valueOf(df.format(balanceQty-netWeightIntons));
//						}
						
						if(netWeightIntons>0 && tripstatus!="Invalid"){
						sumOfWeights=Float.valueOf(df.format(sumOfWeights+netWeightIntons));
						if(permitbalanceQty<sumOfWeights && tripstatus!="Invalid"){
								tripDetails.remarks = " Permit Balance is less than Net Quantity ";
								tripstatus="Invalid";
								sumOfWeights=Float.valueOf(df.format(sumOfWeights-netWeightIntons));
						}
						}
						if(tripstatus!="Invalid"){
							bargeAvailableBalance=bargeCapacity-(bargeQuantity/1000);
							if(bargeAvailableBalance< sumOfWeights && tripstatus!="Invalid"){
								tripDetails.remarks = " Barge Available balance is less than Net Quantity ";
								tripstatus="Invalid";
								bargeAvailableBalance=bargeCapacity+(bargeQuantity/1000);
								sumOfWeights=Float.valueOf(df.format(sumOfWeights-netWeightIntons));
							}
						
							if(netWeightIntons>0 && tripstatus!="Invalid" && bargeAvailableBalance!=0){
							bargeAvailableBalance=bargeAvailableBalance-netWeightIntons;
							}
						}	
					  }	
					}
				   }	
				  }		
				}	
				if(tripstatus != "Invalid" || tripstatus==""){
					tripstatus = "Valid";
					tripDetails.remarks= "Valid";
				}
				validlist.add(new TripDetailsData(tripDetails.type,tripDetails.vehicleNumber,tripDetails.validityDate,tripDetails.permitNo,tripDetails.grossWeight,tripstatus,tripDetails.remarks,permitQty,tareWeight,netWeight,grade,routeId,orgIdI,tcId,Integer.parseInt(permitId),tripDetails.transactionID,tripDetails.bargeID,commStatus));
				  tripDetails.remarks = "";
				  tripstatus = "";
				  k++;
		  }
	    }
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return validlist;
	}
	 
	public JSONArray getImportExcelUnitDetails(int clientId, int systemId, List<TripDetailsData> list) {

		JSONArray unitDetaisJsonArray = null;
		JSONObject unitDetailsJsonObject = null;
		int count = 0;		
		try {
			unitDetaisJsonArray = new JSONArray();
			unitDetailsJsonObject = new JSONObject();		
						
			for (TripDetailsData tripDetails : list) {
				count++;
				unitDetailsJsonObject = new JSONObject();

				unitDetailsJsonObject.put("importslnoIndex", count);
				unitDetailsJsonObject.put("importtypeindex", tripDetails.type);
				unitDetailsJsonObject.put("importvehicleNoindex", tripDetails.vehicleNumber);
				unitDetailsJsonObject.put("importvalidityDateindex", tripDetails.validityDate);
				unitDetailsJsonObject.put("importpermitNoindex", tripDetails.permitNo);
				unitDetailsJsonObject.put("importgrossWeightindex", tripDetails.grossWeight);
				unitDetailsJsonObject.put("importpermitQtyindex", tripDetails.permitQty);
				unitDetailsJsonObject.put("importpermitIdindex", tripDetails.permitId);
				unitDetailsJsonObject.put("importtareWeightindex", tripDetails.tareWeight);
				unitDetailsJsonObject.put("importnetWeightindex", tripDetails.netWeight);
				unitDetailsJsonObject.put("importgradeindex", tripDetails.grade);
				unitDetailsJsonObject.put("importrouteIdindex", tripDetails.routeId);
				unitDetailsJsonObject.put("importorgCodeindex", tripDetails.orgCode);
				unitDetailsJsonObject.put("importtcIdindex", tripDetails.tc_id);
				unitDetailsJsonObject.put("importtripstatusindex", tripDetails.status);
				unitDetailsJsonObject.put("importtripremarksindex", tripDetails.remarks);
				unitDetailsJsonObject.put("transactionIDindex", tripDetails.transactionID);
				unitDetailsJsonObject.put("bargeIDindex", tripDetails.bargeID);
				unitDetailsJsonObject.put("commStatusindex", tripDetails.commStatus);
				unitDetaisJsonArray.put(unitDetailsJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return unitDetaisJsonArray;
	}
}
