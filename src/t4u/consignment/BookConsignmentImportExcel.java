package t4u.consignment;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;



import org.apache.poi.ss.usermodel.DateUtil;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.functions.BookingCustomerFunctions;
import t4u.statements.BookingCustomerStatements;







public class BookConsignmentImportExcel {
//FuelMileageStatements fuelMileageStatements = new FuelMileageStatements();
	
	static JSONArray globalJsonArray = new JSONArray();
	
	DecimalFormat dformat = new DecimalFormat("0.##");
	private File inFile;
	private String fileExtension;
	private int userId;
	private int systemId;
	private int clientId;
	private int offset;
	
	private String BookingDate;
	private String BookingDateInsertion;
	private String VehicleNumber;
	private String BookingCustomerName;
	private String Dealers;
	private String ConsignmentNumber;
	private String ScheduledShippingDate;
	private String ShippingDateInsertion;
	private String ScheduledDelivery;
	private String DeliveryDateInsertion;
	private String Email;
	private String Sms;
	private String TotalDistance;
	private float DistancePerDay=0;
	private String FromLocation;
	private String ToLocation;
	private String Status;
	private int BookingCustomerId;
	private String ValidDealerNames="";
	private final int startRowIdx = 1;
	private final int startColIdx = 0;

	
	private int rowNo;
	String message = "";
	 
	public BookConsignmentImportExcel(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension){
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
	
public String importData(){	
	String importMessage = "";
	List<BookConsignmentData> list = new ArrayList<BookConsignmentData>();	

	 PreparedStatement pstmt = null;
	 ResultSet rs = null;
	 Connection con = null;
	try{
		 con = DBConnection.getConnectionToDB("AMS");
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
				for (int r = 1; r <= nRows; r++) {
					rowNo = r;
					rowNo++;
					row = sheet.getRow(r);
					if (row != null) {
						// Column count in the current row
						cols = sheet.getRow(r).getLastCellNum();
						// Loop for traversing each column in each row in the spreadsheet
						for (int c = 0; c < cols; c++) {
							cell = row.getCell((short) c);
							// If cell contains String value
							switch (c) {
							case 0:
								
								if (cell != null){
									if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
								SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
								SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
								BookingDate = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
								BookingDateInsertion=dateFormat1.format(dateFormat.parse(cell.getStringCellValue()));
								} else {
								BookingDate = "";
								}
								}
								break;
								
								
								
							case 1:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									VehicleNumber = cell.getStringCellValue();
								} else if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									cell.setCellType(HSSFCell.CELL_TYPE_STRING);
									VehicleNumber = cell.getStringCellValue();
								} else {
									VehicleNumber = "";
								}
								break;
							case 2:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									BookingCustomerName = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									BookingCustomerName = String.valueOf((int)cell.getNumericCellValue());
								} else {
									BookingCustomerName = "";
								}
								break;
							case 3:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									Dealers = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									Dealers = String.valueOf((int)cell.getNumericCellValue());
								} else {
									Dealers = "";
								}
								break;
							case 4:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									ConsignmentNumber = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									cell.setCellType(HSSFCell.CELL_TYPE_STRING);
									ConsignmentNumber = cell.getStringCellValue();
								} else {
									ConsignmentNumber = "";
								}
								break;
							case 5:
								if (cell != null){
								if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
								SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
								SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
								ScheduledShippingDate = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
								ShippingDateInsertion = dateFormat1.format(dateFormat.parse(cell.getStringCellValue()));
								} else {
									ScheduledShippingDate = "";
								}
								}
								break;
								
							case 6:
								if (cell != null){
									if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
									SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
									SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
									ScheduledDelivery = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
									DeliveryDateInsertion = dateFormat1.format(dateFormat.parse(cell.getStringCellValue()));
									} else {
										ScheduledDelivery = "";
									}
									}
									break;
							case 7:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									Email = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									Email = String.valueOf(cell.getNumericCellValue());
								} else {
									Email = "";
								}
								break;
							case 8:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									Sms = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									Sms = String.valueOf(cell.getNumericCellValue());
								} else {
									Sms = "";
								}
								break;
							case 9:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									TotalDistance = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									TotalDistance = String.valueOf(cell.getNumericCellValue());
								} else {
									TotalDistance = "";
								}
								break;
							
							case 10:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									FromLocation = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									FromLocation = String.valueOf(cell.getNumericCellValue());
								} else {
									FromLocation = "";
								}
								break;
							case 11:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									ToLocation = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									ToLocation = String.valueOf(cell.getNumericCellValue());
								} else {
									ToLocation = "";
								}
								break;
							case 12:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									Status = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									Status = String.valueOf(cell.getNumericCellValue());
								} else {
									Status = "";
								}
								
								if(validBooking(VehicleNumber,systemId,clientId,Status) && validBookingDate(BookingDate) && validVehicleNo(systemId, clientId, VehicleNumber)&&validBookingCustomer()&&validDealerName(Dealers, systemId, clientId, BookingCustomerId)&&validConsignmentNumber(systemId, clientId, ConsignmentNumber)&&validFromLocation(systemId, clientId, FromLocation)&&validToLocation(systemId, clientId, Dealers, ToLocation)&&validScheduleDeliveryDate(ScheduledDelivery, ScheduledShippingDate)&&validScheduleShippingDate(ScheduledShippingDate, BookingDate) && validEmail(Email) && validSms(Sms) && validTotalDistance(Float.parseFloat(TotalDistance))){	
								message = message + "\n" + "Line No : " + rowNo + "Success..!! Imported Successfully..!! ";

								int i;
								String dealers[];
								String names="";
								ArrayList<String> dealersNameList=new ArrayList<String>(); 
								dealers=Dealers.split(",");
						 		for( i=0;i<dealers.length;i++)
						 		{
						 			names=names+"'"+dealers[i]+"',";
						 		}
						 		names=names.substring(0,names.length()-1);
								//for(int i=0;i<dealersIdList.length;i++){
								String dealersName="";
								pstmt=con.prepareStatement("select DealerName,Slno,EmailId,MobileNo from AMS.dbo.Consignment_Dealer_Master where SystemId=? and ClientId=? and DealerName in ("+names+") and (BaseLocation='N' or BaseLocation is null)");
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, clientId);
								//pstmt1.setString(3, dealersIdList[i]);
								rs=pstmt.executeQuery();
								while(rs.next())
								{
									dealersNameList.add(rs.getString("DealerName"));
									dealersName=dealersName+rs.getString("DealerName")+",";
									pstmt = con.prepareStatement(BookingCustomerStatements.INSERT_COSIGNMENT_DETAILS);
									pstmt.setString(1, ConsignmentNumber);
									pstmt.setString(2, VehicleNumber);
									pstmt.setString(3, rs.getString("DealerName"));
									pstmt.setString(4, BookingDateInsertion);
									pstmt.setInt(5,systemId);
									pstmt.setInt(6, clientId);
									pstmt.setString(7, Email);
									pstmt.setString(8, Sms);
									pstmt.setString(9, ShippingDateInsertion);
									pstmt.setString(10, DeliveryDateInsertion);
									pstmt.setInt(11,rs.getInt("Slno"));
									pstmt.setString(12, Status);
									pstmt.executeUpdate();
									pstmt.close();
								}
								int fromId=0;
								int toId=0;
								pstmt=con.prepareStatement(BookingCustomerStatements.GET_FROM_LOACTION);
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, clientId);
								pstmt.setString(3,FromLocation);
								rs=pstmt.executeQuery();
								if(rs.next())
								{
									fromId=rs.getInt("DealerId");
								}
								pstmt=con.prepareStatement(BookingCustomerStatements.GET_TO_LOCATION_ID.replace("#", names));
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, clientId);
								pstmt.setString(3,ToLocation);
								rs=pstmt.executeQuery();
								if(rs.next())
								{
									toId=rs.getInt("Slno");
								}
								int days=getDaysDiffrence(ScheduledShippingDate,ScheduledDelivery);
								float total=Float.parseFloat(TotalDistance);
								if(days!=0){
								DistancePerDay=total/days;
								}
								else{
									DistancePerDay=Float.parseFloat(TotalDistance);
								}
									pstmt=con.prepareStatement(BookingCustomerStatements.INSERT_COSIGNMENT_BOOKING_DETAILS);
									pstmt.setString(1, BookingDateInsertion);
									pstmt.setString(2, VehicleNumber);
									pstmt.setString(3, ValidDealerNames);
									pstmt.setString(4, ConsignmentNumber);
									pstmt.setString(5, ShippingDateInsertion);
									pstmt.setString(6, DeliveryDateInsertion);
									pstmt.setInt(7,systemId);
									pstmt.setInt(8, clientId);
									pstmt.setString(9, Email);
									pstmt.setString(10, Sms);
									pstmt.setString(11, TotalDistance);
									pstmt.setFloat(12, DistancePerDay);
									pstmt.setString(13, FromLocation);
									pstmt.setString(14, ToLocation);
									pstmt.setInt(15,toId);
									pstmt.setInt(16, fromId);
									pstmt.setString(17, Status);
									pstmt.setInt(18, BookingCustomerId);
									pstmt.executeUpdate();
									pstmt.close();
									list.add(new BookConsignmentData(BookingDate,VehicleNumber,BookingCustomerName,ValidDealerNames,ConsignmentNumber,ScheduledShippingDate,ScheduledDelivery,Email,Sms,TotalDistance,DistancePerDay,FromLocation,ToLocation,Status,fromId,toId));
									names="";
									ValidDealerNames="";
									break;
									
//								}
								
							}															
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
				for (int r = 1; r <= nRows; r++) {
					rowNo = r;
					rowNo++;
					row = sheet.getRow(r);
					if (row != null) {
						// Column count in the current row
						cols = sheet.getRow(r).getLastCellNum();
						// Loop for traversing each column in each row in the spreadsheet
						for (int c = 0; c < cols; c++) {
							cell = row.getCell((short) c);
							// If cell contains String value
							switch (c) {
							case 0:
								if (cell != null){
									if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
								SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
								SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
								BookingDate = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
								BookingDateInsertion=dateFormat1.format(dateFormat.parse(cell.getStringCellValue()));
								} else {
								BookingDate = "";
								}
								}
								break;
								
							case 1:
								if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
									VehicleNumber = cell.getStringCellValue();
								} else if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
									cell.setCellType(XSSFCell.CELL_TYPE_STRING);
									VehicleNumber = cell.getStringCellValue();
								} else {
									VehicleNumber = "";
								}
								break;
							case 2:
								if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
									BookingCustomerName = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
									BookingCustomerName = String.valueOf((int)cell.getNumericCellValue());
								} else {
									BookingCustomerName = "";
								}
								break;
							case 3:
								if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
									Dealers = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
									Dealers = String.valueOf((int)cell.getNumericCellValue());
								} else {
									Dealers = "";
								}
								break;
							case 4:
								if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
									ConsignmentNumber = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
									cell.setCellType(XSSFCell.CELL_TYPE_STRING);
									ConsignmentNumber = cell.getStringCellValue();
								} else {
									ConsignmentNumber = "";
								}
								break;
							case 5:
								if (cell != null){
								if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
								SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
								SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
								ScheduledShippingDate = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
								ShippingDateInsertion = dateFormat1.format(dateFormat.parse(cell.getStringCellValue()));
								} else {
									ScheduledShippingDate = "";
								}
								}
								break;
								
							case 6:
								if (cell != null){
									if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
									SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
									SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
									ScheduledDelivery = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
									DeliveryDateInsertion = dateFormat1.format(dateFormat.parse(cell.getStringCellValue()));
									} else {
										ScheduledDelivery = "";
									}
									}
									break;
								
							case 7:
								if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
									Email = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
									Email = String.valueOf(cell.getNumericCellValue());
								} else {
									Email = "";
								}
								break;
							case 8:
								if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
									Sms = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
									Sms = String.valueOf(cell.getNumericCellValue());
								} else {
									Sms = "";
								}
								break;
							case 9:
								if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
									TotalDistance = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
									TotalDistance = String.valueOf(cell.getNumericCellValue());
								} else {
									TotalDistance = "";
								}
								break;
							
							case 10:
								if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
									FromLocation = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
									FromLocation = String.valueOf(cell.getNumericCellValue());
								} else {
									FromLocation = "";
								}
								break;
							case 11:
								if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
									ToLocation = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
									ToLocation = String.valueOf(cell.getNumericCellValue());
								} else {
									ToLocation = "";
								}
								break;
							case 12:
								if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
									Status = cell.getStringCellValue();
								} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
									Status = String.valueOf(cell.getNumericCellValue());
								} else {
									Status = "";
								}
								
								
								if(validBooking(VehicleNumber,systemId,clientId,Status) && validBookingDate(BookingDate) && validVehicleNo(systemId, clientId, VehicleNumber)&&validBookingCustomer()&&validDealerName(Dealers, systemId, clientId, BookingCustomerId)&&validConsignmentNumber(systemId, clientId, ConsignmentNumber)&&validFromLocation(systemId, clientId, FromLocation)&&validToLocation(systemId, clientId, Dealers, ToLocation)&&validScheduleDeliveryDate(ScheduledDelivery, ScheduledShippingDate)&&validScheduleShippingDate(ScheduledShippingDate, BookingDate) && validEmail(Email) && validSms(Sms) && validTotalDistance(Float.parseFloat(TotalDistance))){	
								message = message + "\n" + "Line No : " + rowNo + "Success..!! Imported Successfully..!! ";

									int i;
									String[] dealers;
									String names="";
									ArrayList<String> dealersNameList=new ArrayList<String>(); 
									dealers=Dealers.split(",");
							 		for( i=0;i<dealers.length;i++)
							 		{
							 			names=names+"'"+dealers[i]+"',";
							 		}
							 		names=names.substring(0,names.length()-1);

									String dealersName="";
									pstmt=con.prepareStatement("select DealerName,Slno,EmailId,MobileNo from AMS.dbo.Consignment_Dealer_Master where SystemId=? and ClientId=? and DealerName in ("+names+") and (BaseLocation='N' or BaseLocation is null)");
									pstmt.setInt(1, systemId);
									pstmt.setInt(2, clientId);
									rs=pstmt.executeQuery();
									while(rs.next())
									{
										dealersNameList.add(rs.getString("DealerName"));
										dealersName=dealersName+rs.getString("DealerName")+",";
										pstmt = con.prepareStatement(BookingCustomerStatements.INSERT_COSIGNMENT_DETAILS);
										pstmt.setString(1, ConsignmentNumber);
										pstmt.setString(2, VehicleNumber);
										pstmt.setString(3, rs.getString("DealerName"));
										pstmt.setString(4, BookingDateInsertion);
										pstmt.setInt(5,systemId);
										pstmt.setInt(6, clientId);
										pstmt.setString(7, Email);
										pstmt.setString(8, Sms);
										pstmt.setString(9, ShippingDateInsertion);
										pstmt.setString(10, DeliveryDateInsertion);
										pstmt.setInt(11,rs.getInt("Slno"));
										pstmt.setString(12, Status);
										pstmt.executeUpdate();
										pstmt.close();
									}
								
								int fromId=0;
								int toId=0;
								pstmt=con.prepareStatement(BookingCustomerStatements.GET_FROM_LOACTION);
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, clientId);
								pstmt.setString(3,FromLocation);
								rs=pstmt.executeQuery();
								if(rs.next())
								{
									fromId=rs.getInt("DealerId");
								}
								pstmt=con.prepareStatement(BookingCustomerStatements.GET_TO_LOCATION_ID.replace("#", names));
								pstmt.setInt(1, systemId);
								pstmt.setInt(2, clientId);
								pstmt.setString(3,ToLocation);
								rs=pstmt.executeQuery();
								if(rs.next())
								{
									toId=rs.getInt("Slno");
								}
								int days=getDaysDiffrence(ScheduledShippingDate,ScheduledDelivery);
								float total=Float.parseFloat(TotalDistance);
								if(days!=0){
								DistancePerDay=total/days;}
								else
								{
									DistancePerDay=Float.parseFloat(TotalDistance);
								}
									pstmt=con.prepareStatement(BookingCustomerStatements.INSERT_COSIGNMENT_BOOKING_DETAILS);
									pstmt.setString(1, BookingDateInsertion);
									pstmt.setString(2, VehicleNumber);
									pstmt.setString(3, ValidDealerNames);
									pstmt.setString(4, ConsignmentNumber);
									pstmt.setString(5, ShippingDateInsertion);
									pstmt.setString(6, DeliveryDateInsertion);
									pstmt.setInt(7,systemId);
									pstmt.setInt(8, clientId);
									pstmt.setString(9, Email);
									pstmt.setString(10, Sms);
									pstmt.setString(11, TotalDistance);
									pstmt.setFloat(12, DistancePerDay);
									pstmt.setString(13, FromLocation);
									pstmt.setString(14, ToLocation);
									pstmt.setInt(15,toId);
									pstmt.setInt(16, fromId);
									pstmt.setString(17, Status);
									pstmt.setInt(18, BookingCustomerId);
									pstmt.executeUpdate();
									pstmt.close();
								list.add(new BookConsignmentData(BookingDate, VehicleNumber, BookingCustomerName,Dealers, ConsignmentNumber, ScheduledShippingDate, ScheduledDelivery, Email, Sms,TotalDistance,DistancePerDay,FromLocation,ToLocation,Status,fromId,toId));							
								ValidDealerNames="";
							}
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
		globalJsonArray = getImportExcelBookConsignment(clientId, systemId, list);
		if(globalJsonArray != null && globalJsonArray.length() > 0){
			importMessage = "Success";
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	finally {
		 DBConnection.releaseConnectionToDB(con, pstmt, rs);
		 }
	return importMessage;
}

public int getBookingCustomerAssociatedToDealer(int clientid,int systemid,String CustomerName) {
	 Connection con = null;
	 PreparedStatement pstmt = null;
	 ResultSet rs = null;
 	try
 	{
 		 con = DBConnection.getConnectionToDB("AMS");
         pstmt = con.prepareStatement(BookingCustomerStatements.GET_BOOKING_CUSTOMER_DETAILS1);
         pstmt.setString(1, BookingCustomerName);
         pstmt.setInt(2, clientId);
         pstmt.setInt(3,systemid);
         rs = pstmt.executeQuery();
         if(rs.next())
         {
        	 BookingCustomerId=rs.getInt("ID");
         }
 	}
catch (Exception e) {
	e.printStackTrace();
}finally {
	 DBConnection.releaseConnectionToDB(con, pstmt, rs);
	 }
return BookingCustomerId;
}



public boolean validBookingCustomer() {
	 Connection con = null;
	 PreparedStatement pstmt = null;
	 ResultSet rs = null;
	 boolean CustomereExitsOrNot=false;
	 try {
		 BookingCustomerId=getBookingCustomerAssociatedToDealer(clientId,systemId,BookingCustomerName);
	if (BookingCustomerId != 0) {	
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(BookingCustomerStatements.CHECK_CUSTOMER_ASSOCIATED_TO_DEALER);
		pstmt.setInt(1, BookingCustomerId);
		rs=pstmt.executeQuery();
		if(rs.next())
		{
			 CustomereExitsOrNot=true;
		}
		else
		{
			message = message + "\n" + "Line No : " + rowNo + "Failure..!! Customer is not associated to dealer..!! ";
			return false;
		}
	}
	else {
		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Customer name is blank ..!! ";
		CustomereExitsOrNot=false;
	}
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}finally {
		 DBConnection.releaseConnectionToDB(con, pstmt, rs);
	 }
	return CustomereExitsOrNot;
}
public boolean validVehicleNo(int systemId,int clientId, String vehicleNo) {

	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	boolean vehicleExits = false;
	try {
		if(!vehicleNo.equals("") && vehicleNo!=null)
		{
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement("select REGISTRATION_NUMBER from dbo.VEHICLE_CLIENT where REGISTRATION_NUMBER = ? and CLIENT_ID = ? and SYSTEM_ID = ?");
		pstmt.setString(1, vehicleNo);
		pstmt.setInt(2, clientId);
		pstmt.setInt(3, systemId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			vehicleExits = true;
		}
		else
		{
			message = message + "\n" + "Line No : " + rowNo + "Failure..!! Vehicle is not associated to client..!! ";
			vehicleExits=false;
			}
		}
		else
		{
			message = message + "\n" + "Line No : " + rowNo + "Failure..!! Vehicle number is blank ..!! ";
			vehicleExits=false;
		}
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
	}
	return vehicleExits;
}

public boolean validBookingDate(String bookingDate) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
 	Date PresentDate=new Date();
 	boolean validBookingDate=false;
 	Date bdate;
	//SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYY1 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd");
	
 	try
      {
 		if(bookingDate!=null && !bookingDate.equals("")){
 			
 		bdate= simpleDateFormatddMMYY1.parse(bookingDate+" 00:00:00");
 		con = DBConnection.getConnectionToDB("AMS");
 		pstmt=con.prepareStatement("select getUTCDate() as present");
 		rs=pstmt.executeQuery();
        while(rs.next())
		{
        	PresentDate=simpleDateFormatddMMYY1.parse(simpleDateFormatddMMYY1.format (simpleDateFormatddMMYYYYDB.parse(rs.getString("present"))));
        } 
        if(bdate.compareTo(PresentDate)<=0)
        {
        	validBookingDate=true;
        }
        else
        {
        	validBookingDate=false;
    		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Booking Date should be less than or equals to todays date ";
        }
 		}else{
 			validBookingDate=false;
    		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Booking date should not be empty ";
 		}
}
 	catch(Exception e)
{
	
	e.printStackTrace();
}
finally
{
	DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return validBookingDate;
}

public boolean validDealerName(String dealerName,int systemId,int clientId,int bookingCustomerId) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
 	boolean validdealer=false;
 	boolean validdealer1=false;
 	String names="";
 	String dealers[];
 	int i;
 	String result="";
	
 	try
      {
 		if(dealerName!=null && !dealerName.equals("")){
 			dealers=dealerName.split(",");
 		for( i=0;i<dealers.length;i++)
 		{
 			//System.out.println(dealers[i]);
 			names=names+"'"+dealers[i]+"',";
 		//	System.out.println(names);
 		}
 		ValidDealerNames="";
 		names=names.substring(0,names.length()-1);
 		//System.out.println(names);
 		con = DBConnection.getConnectionToDB("AMS");
 		pstmt=con.prepareStatement(BookingCustomerStatements.GET_DEALER_NAME.replace("#", names));
 		pstmt.setInt(1, systemId);
 		pstmt.setInt(2, clientId);
 		pstmt.setInt(3, bookingCustomerId);
 		rs=pstmt.executeQuery();
        while(rs.next())
		{ValidDealerNames=ValidDealerNames+rs.getString("DealerName")+",";
        	if(names.contains(rs.getString("DealerName"))){
        		validdealer=true;
        	}else{
        		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Dealer doest not belong to given customer ";
        		validdealer1=false;
        	}
        }
        if(validdealer || validdealer1)
        {
        	validdealer=true;
        }
        else
        {
        	message = message + "\n" + "Line No : " + rowNo + "Failure..!! Dealer doest not belong to given customer ";
    		validdealer=false;
        }
        ValidDealerNames=ValidDealerNames.substring(0,ValidDealerNames.length()-1);
 		}else{
    		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Dealer Name should not be empty ";
    		validdealer=false;
 		}
 		
}
 	catch(Exception e)
{
	
	e.printStackTrace();
}
finally
{
	DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return validdealer;
}

public boolean validConsignmentNumber(int systemid,int clientId,String consignmentNumber)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
 	boolean validNumber=false;
	try
    {
		if(consignmentNumber!=null && !consignmentNumber.equals("")){
		con = DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(BookingCustomerStatements.GET_CONSIGNMENT_NUMBER);
		pstmt.setInt(1, systemId);
		pstmt.setString(2, consignmentNumber);
		rs=pstmt.executeQuery();
      if(!rs.next())
		{
      		validNumber=true;
      	}else{
      		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Consignment number already exsits ";
      		validNumber=false;
      	}
      } 
		else{
  		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Consignment number should not be empty";
  		validNumber=false;
		}
}catch(Exception e){
	e.printStackTrace();
}
finally{
	DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return validNumber;
}
		
public boolean validScheduleShippingDate(String shippingDate,String bookingDate) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
 	boolean validBookingDate=false;
	SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYY1 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	Date sdate,bdate;
 	try
      {
 		if(shippingDate!=null && !shippingDate.equals("")){
 			sdate= simpleDateFormatddMMYY1.parse(shippingDate);
 			bdate= simpleDateFormatddMMYY1.parse(bookingDate+" 00:00:00");
        if(sdate.compareTo(bdate)>=0)
        {
        	validBookingDate=true;
        }else{
        	validBookingDate=false;
        	message = message + "\n" + "Line No : " + rowNo + "Failure..!! Shipping date should be greater than or equals to booking date";
        }
 		}else{
 			validBookingDate=false;
        	message = message + "\n" + "Line No : " + rowNo + "Failure..!! Shipping date should be empty";
 		}
}
 	catch(Exception e){
	e.printStackTrace();
}finally{
	DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return validBookingDate;
}
public boolean validScheduleDeliveryDate(String deliveryDate,String shippingDate) {
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
 	boolean validBookingDate=false;
 	SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYY1 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	Date sdate,ddate;
 	try
      {
 		if(shippingDate!=null && !shippingDate.equals("")){
 			sdate= simpleDateFormatddMMYY1.parse(shippingDate);
 			ddate= simpleDateFormatddMMYY1.parse(deliveryDate);
        if(ddate.compareTo(sdate)>=0)
        {
        	validBookingDate=true;
        }else{
        	validBookingDate=false;
        	message = message + "\n" + "Line No : " + rowNo + "Failure..!! Shipping date should be greater than or equals to booking date";
        }
 		}else{
 			validBookingDate=false;
        	message = message + "\n" + "Line No : " + rowNo + "Failure..!! Shipping date should be empty";
 		}
}
 	catch(Exception e){
	e.printStackTrace();
}finally{
	DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return validBookingDate;
}

public boolean validFromLocation(int systemid,int clientId,String fromLocation)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
 	boolean validLocation=false;
	try
    {
		if(fromLocation!=null && !fromLocation.equals("")){
		con = DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(BookingCustomerStatements.GET_FROM_LOACTION);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		pstmt.setString(3, fromLocation);
		rs=pstmt.executeQuery();
		if(rs.next())
		{
      		validLocation=true;
      	}else{
      		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Base Location is incorrect";
      		validLocation=false;
      	}
      } 
		else{
  		message = message + "\n" + "Line No : " + rowNo + "Failure..!! From Location should not be empty";
  		validLocation=false;
		}
}catch(Exception e){
	e.printStackTrace();
}
finally{
	DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return validLocation;
}

public boolean validToLocation(int systemid,int clientId,String dealers,String toLocation)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
 	boolean validLocation=false;
 	String dealersname[];
 	String names="";
 	String num="";
	try
    {
		dealersname=dealers.split(",");
 		for( int i=0;i<dealersname.length;i++)
 		{
 			//System.out.println(dealersname[i]);
 			names=names+"'"+dealersname[i]+"',";
 			//System.out.println(names);
 		}
 		names=names.substring(0,names.length()-1);
		if(toLocation!=null && !toLocation.equals("")){
		con = DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(BookingCustomerStatements.GET_DEALER_ID.replace("#",names));
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, clientId);
		//pstmt.setString(3, dealers);
		rs=pstmt.executeQuery();
		while(rs.next())
		{
			int dealerId;
			dealerId=rs.getInt("DealerId");
			num=num+String.valueOf(dealerId)+",";
		}
 			num=num.substring(0,num.length()-1);

			pstmt=con.prepareStatement(BookingCustomerStatements.GET_TO_LOCATIONS.replace("#", num));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, toLocation);
			rs=pstmt.executeQuery();
			while(rs.next())
			{
	      		validLocation=true;
	      	}if(!validLocation){
	      		message = message + "\n" + "Line No : " + rowNo + "Failure..!! To Location is incorrect";
	      		validLocation=false;
	      	}
		}
		else{
  		message = message + "\n" + "Line No : " + rowNo + "Failure..!! To Location should not be empty";
  		validLocation=false;
		}
}catch(Exception e){
	e.printStackTrace();
}
finally{
	DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return validLocation;
}


public boolean validStatus(String status)
{
 	boolean validStatus=false;
	try
    {
		if(status!=null && !status.equals("")){
		if(!status.equals("Empty"))
		{
			validStatus=true;
      	}else{
      		message = message + "\n" + " Line No : " + rowNo + "Failure..!! Status should be EMPTY load or reload.";
      		validStatus=false;
      	}
      } 
		else{
  		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Status  should not be empty";
  		validStatus=false;
		}
}catch(Exception e){
	e.printStackTrace();
}
return validStatus;
}

public boolean validTotalDistance(float total)
{
 	boolean validTotal=false;
	try
    {
		if(total!=0){
			validTotal=true;
      } 
		else{
  		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Total Distance  should not be empty";
  		validTotal=false;
		}
}catch(Exception e){
	e.printStackTrace();
}
return validTotal;
}

public boolean validEmail(String email)
{
 	boolean validEmail=false;
	try
    {
		if(email!=null && !email.equals("")){
			if(email.contains("Y")||email.contains("N"))
			{
				validEmail=true;
			}
			else
			{
				validEmail=false;
		  		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Email should be Y/N ";

			}
		}
		else{
  		message = message + "\n" + "Line No : " + rowNo + "Failure..!! Email should not be empty";
  		validEmail=false;
		}
}catch(Exception e){
	e.printStackTrace();
}
return validEmail;
}
public boolean validSms(String sms)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
 	boolean validSms=false;
	try
    {
		if(sms!=null && !sms.equals("")){
			if(sms.contains("Y")||sms.contains("N"))
			{
				validSms=true;
			}
			else
			{
				validSms=false;
		  		message = message + "\n" + "Line No : " + rowNo + "Failure..!! SMS should be Y/N ";

			}
		}
		else{
  		message = message + "\n" + "Line No : " + rowNo + "Failure..!! SMS should not be empty";
  		validSms=false;
		}
}catch(Exception e){
	e.printStackTrace();
}
finally{
	DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return validSms;
}

public boolean validBooking(String vehicleNumber,int systemId,int clientId,String status)
{
	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
 	boolean validConsignmet=false;
	try
    {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(" select * from AMS.dbo.Consignment_Details where VehicleNo=? and System_Id=? and Client_Id=? and Deleted!='Y' and Status='Processing' and ConsignmentStatus!=?");
		pstmt.setString(1, vehicleNumber);
		pstmt.setInt(2, systemId);
		pstmt.setInt(3, clientId);
		pstmt.setString(4, status);
		rs=pstmt.executeQuery();
		if(rs.next())
		{
			validConsignmet=false;
      		message = message + "\n" + "Line No : " + rowNo + "Failure..!! You Cannot Create Consignment For This Vehicle";

      	}else{
      		validConsignmet=true;
      	}
}catch(Exception e){
	e.printStackTrace();
}
finally{
	DBConnection.releaseConnectionToDB(con, pstmt, rs);
}
return validConsignmet;
}



public int getDaysDiffrence(String shippingDate,String deliveryDate )
{
	
	SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

	Date d1 = null;
	Date d2 = null;
	int daydiff=0;
	try {
		 long ONE_DAY = 1000 * 60 * 60 * 24;
		d1=dateFormat.parse(shippingDate);
		d2=dateFormat.parse(deliveryDate);
		long diff = d2.getTime() - d1.getTime();
		daydiff = (int) (diff / ONE_DAY);
	   

	} catch (Exception e) {
		e.printStackTrace();
		System.out.println("Error in getDaysDiffrence method " + e);
	}
	return daydiff;
}


public JSONArray getImportExcelBookConsignment(int clientId, int systemId, List<BookConsignmentData> list) {

	JSONArray bookConsignmentJsonArray = null;
	JSONObject bookConsignmentJsonObject = null;
	int count = 0;		
	try {
		bookConsignmentJsonArray = new JSONArray();
		bookConsignmentJsonObject = new JSONObject();		
		
		Collections.sort(list, new BookConsignmentData());
					
		for (BookConsignmentData consignmentDetails : list) {
			
			count++;
			bookConsignmentJsonObject = new JSONObject();
			bookConsignmentJsonObject.put("SlNoDataIndex", count);
			bookConsignmentJsonObject.put("BookingDateIndex",consignmentDetails.bookingDate);
			bookConsignmentJsonObject.put("VehicleNumberDataIndex", consignmentDetails.vehicleNumber);
			bookConsignmentJsonObject.put("BookingCustomerDataIndex", consignmentDetails.bookingCustomerName);
			bookConsignmentJsonObject.put("DealersDataIndex", consignmentDetails.dealers);
			bookConsignmentJsonObject.put("ConsignmentNumberDataIndex", consignmentDetails.consignmentNumber);
			bookConsignmentJsonObject.put("ScheduledShippingDateDataIndex", consignmentDetails.scheduledShippingDate);
			bookConsignmentJsonObject.put("ScheduledDeliveryDateIndex",consignmentDetails.scheduledDelivery);
			bookConsignmentJsonObject.put("EmailDataIndex",consignmentDetails.email);
			bookConsignmentJsonObject.put("SMSDataIndex",consignmentDetails.sms);
			bookConsignmentJsonObject.put("totalindex",consignmentDetails.totalDistance);
			bookConsignmentJsonObject.put("averageindex", consignmentDetails.distancePerDay);
			bookConsignmentJsonObject.put("fromlocationindex",consignmentDetails.fromLocation);
			bookConsignmentJsonObject.put("fromdealeridindex", consignmentDetails.fromId);
			bookConsignmentJsonObject.put("tolocationindex",consignmentDetails.toLocation);
			bookConsignmentJsonObject.put("todealeridindex",consignmentDetails.toId);
			bookConsignmentJsonObject.put("statusindex", consignmentDetails.status);
			bookConsignmentJsonObject.put("closetripdateindex", "");
			bookConsignmentJsonObject.put("consignmentstatusindex", "Processing");
			bookConsignmentJsonObject.put("actualshippeddate", "");
			//bookConsignmentJsonObject.put("validOrInvalid", "YetToValidate");// Valid
			bookConsignmentJsonArray.put(bookConsignmentJsonObject);

		}
	} catch (Exception e) {
		e.printStackTrace();
	} 
	return bookConsignmentJsonArray;
}

}
