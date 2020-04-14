package t4u.cashvanmanagement;

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
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
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

import t4u.common.DBConnection;
import t4u.statements.FuelMileageStatements;

public class FuelMileageExcelImport {
	
	FuelMileageStatements fuelMileageStatements = new FuelMileageStatements();
	
	static JSONArray globalJsonArray = new JSONArray();
	
	DecimalFormat dformat = new DecimalFormat("0.##");
	private File inFile;
	private String fileExtension;
	private int userId;
	private int systemId;
	private int clientId;
	private int offset;
	
	private String vehicleNumber;
	private String dateTime;
	private String odometer;
	private String fuel;
	private String amount;
	private String slipNumber;
	private String fuelCompanyName;
	private String petroCardNumber;
	
	private int rowNo;
	String message = "";
	
	public FuelMileageExcelImport(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension){
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
	List<FuelMileageData> list = new ArrayList<FuelMileageData>();	
	HashMap<String, ArrayList<String>> OdometerValue = new  HashMap<String, ArrayList<String>>();
	OdometerValue = getAllItemodometerValues(systemId,clientId);
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
					for (int r = 1; r < nRows; r++) {
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
									if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
										vehicleNumber = cell.getStringCellValue();
									} else if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										vehicleNumber = cell.getStringCellValue();
									} else {
										vehicleNumber = "";
									}
									break;
								case 1:
									if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING){
										SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
										dateTime = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
									} else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
										if (HSSFDateUtil.isCellDateFormatted(row.getCell(1))) {
									        Date customDate = row.getCell(1).getDateCellValue();	
									        DateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
									        dateTime = ddmmyyyy.format(customDate);
									    }
									}else {
										dateTime = "";
									}
									break;
								case 2:
									
									if(systemId == 266 && clientId ==4802){
										odometer = getodometer(systemId,clientId,vehicleNumber,OdometerValue,dateTime);
									}else{
										if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
											odometer = cell.getStringCellValue();
										} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
											odometer = String.valueOf((int)cell.getNumericCellValue());
										} else {
											odometer = "";
										}
									}
									break;
								case 3:
									if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
										slipNumber = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										slipNumber = cell.getStringCellValue();
									} else {
										slipNumber = "";
									}
									break;
								case 4:
									if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
										fuelCompanyName = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										fuelCompanyName = cell.getStringCellValue();
									} else {
										fuelCompanyName = "";
									}
									break;
								case 5:
									if (cell != null&& cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
										petroCardNumber = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
										cell.setCellType(HSSFCell.CELL_TYPE_STRING);
										petroCardNumber = cell.getStringCellValue();
									} else {
										petroCardNumber = "";
									}
									break;
								case 6:
									if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
										fuel = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
										fuel = String.valueOf(cell.getNumericCellValue());
									} else {
										fuel = "";
									}
									break;
								case 7:
									if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
										amount = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
										amount = String.valueOf(cell.getNumericCellValue());
									} else {
										amount = "";
									}
									if(validVehicleNumber() && validFuelDate() && validOdometer() && validFuel() && validAmount()){	
										if(slipNumber == null || slipNumber.equalsIgnoreCase(null)){
											slipNumber = "";
										}
										if(fuelCompanyName == null || fuelCompanyName.equalsIgnoreCase(null)){
											fuelCompanyName = "";
										}
										if(petroCardNumber == null || petroCardNumber.equalsIgnoreCase(null) || petroCardNumber.equalsIgnoreCase("")){
											petroCardNumber = getPetroCardNumber().toUpperCase();
										}
										list.add(new FuelMileageData(vehicleNumber, dateTime, Integer.parseInt(odometer), Double.parseDouble(fuel), Double.parseDouble(amount), slipNumber, fuelCompanyName, petroCardNumber));							
									}
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
					for (int r = 1; r < nRows; r++) {
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
									if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
										vehicleNumber = cell.getStringCellValue();
									} else if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
										cell.setCellType(XSSFCell.CELL_TYPE_STRING);
										vehicleNumber = cell.getStringCellValue();
									} else {
										vehicleNumber = "";
									}
									break;
								case 1:
									if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING){
											SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
											dateTime = dateFormat.format(dateFormat.parse(cell.getStringCellValue()));
									} else if(cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC){
										if (HSSFDateUtil.isCellDateFormatted(row.getCell(1))) {
									        Date customDate = row.getCell(1).getDateCellValue();	
									        DateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
									        dateTime = ddmmyyyy.format(customDate);
									    }
									} else {
										dateTime = "";
									}
									break;
								case 2:						
									if(systemId == 266 && clientId ==4802){
										odometer = getodometer(systemId,clientId,vehicleNumber, OdometerValue,dateTime);
									}else{
										if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
										odometer = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
										odometer = String.valueOf((int)cell.getNumericCellValue());
									} else {
										odometer = "";
									}
								}
									break;
								case 3:
									if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
										slipNumber = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
										cell.setCellType(XSSFCell.CELL_TYPE_STRING);
										slipNumber = cell.getStringCellValue();
									} else {
										slipNumber = "";
									}
									break;
								case 4:
									if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
										fuelCompanyName = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
										cell.setCellType(XSSFCell.CELL_TYPE_STRING);
										fuelCompanyName = cell.getStringCellValue();
									} else {
										fuelCompanyName = "";
									}
									break;
								case 5:
									if (cell != null&& cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
										petroCardNumber = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
										cell.setCellType(XSSFCell.CELL_TYPE_STRING);
										petroCardNumber = cell.getStringCellValue();
									} else {
										petroCardNumber = "";
									}
									break;
								case 6:
									if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
										fuel = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
										fuel = String.valueOf(cell.getNumericCellValue());
									} else {
										fuel = "";
									}
									break;
								case 7:
									if (cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_STRING) {
										amount = cell.getStringCellValue();
									} else if(cell != null && cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
										amount = String.valueOf(cell.getNumericCellValue());
									} else {
										amount = "";
									}
									
									if(validVehicleNumber() && validFuelDate() && validOdometer() && validFuel() && validAmount()){	
										if(slipNumber == null || slipNumber.equalsIgnoreCase(null)){
											slipNumber = "";
										}
										if(fuelCompanyName == null || fuelCompanyName.equalsIgnoreCase(null)){
											fuelCompanyName = "";
										}
										if(petroCardNumber == null || petroCardNumber.equalsIgnoreCase(null) || petroCardNumber.equalsIgnoreCase("")){
											petroCardNumber = getPetroCardNumber().toUpperCase();
										}
										list.add(new FuelMileageData(vehicleNumber, dateTime, Integer.parseInt(odometer), Double.parseDouble(fuel), Double.parseDouble(amount), slipNumber, fuelCompanyName, petroCardNumber));							
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
			globalJsonArray = getImportExcelFuelMileageDetails(clientId, systemId, list);
			if(globalJsonArray != null && globalJsonArray.length() > 0){
				importMessage = "Success";
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return importMessage;
	}

	private HashMap<String,ArrayList<String>> getAllItemodometerValues(int systemId,int clientId) {
		HashMap<String, ArrayList<String>> newmap = new HashMap<String, ArrayList<String>>();
		
		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		 try{
		 conAms = DBConnection.getConnectionToDB("AMS");
		 pstmt = conAms.prepareStatement("select VehicleNo,max(DateTime) as DateTime,max(Odometer) as Odometer from FMS.dbo.MileagueMaster where SystemId = ? and ClientId = ? group by VehicleNo");
		 pstmt.setInt(1,systemId);
		 pstmt.setInt(2,clientId);			
			rs = pstmt.executeQuery();
			while(rs.next()){
			ArrayList<String> list = new ArrayList<String>();
			list.add(rs.getString("DateTime"));
			list.add(rs.getString("Odometer"));
			newmap.put(rs.getString("VehicleNo"), list);
			}
		 }catch(Exception e){
			 e.printStackTrace();
		 }finally{
			 DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		 }
		 return newmap;
}
	
	private String getodometer(int systemId, int clientId, String vehicleNumber, HashMap<String, ArrayList<String>> odometerValue, String Date2) {
		Connection conAms = null;
		PreparedStatement pstmt = null;
		String Date1 =null;
		String prevodometer = "0.0";
		ResultSet rs = null;
		int odometer1 =0,Prevodo = 0;
		SimpleDateFormat sdf2 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		ArrayList<String> arra1 = odometerValue.get(vehicleNumber);
		if(arra1!=null && !arra1.isEmpty()){
			Date1 = arra1.get(0);			
			prevodometer = arra1.get(1);
		}
		try {
			
			conAms = DBConnection.getConnectionToDB("AMS");
			if(!prevodometer.equalsIgnoreCase("0.0")){
				java.util.Date d=sdf.parse(Date1);
				Date1=sdf.format(d);			
				Date2=sdf.format(sdf2.parse(Date2));			
				pstmt = conAms.prepareStatement("select sum(TotalDistanceTravelled) as Distance from AMS.dbo.VehicleSummaryData where RegistrationNo = ? and SystemId = ? and ClientId = ? and  DateGMT between ? and ? ");
				pstmt.setString(1, vehicleNumber);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				pstmt.setString(4, Date1);
				pstmt.setString(5, Date2);
				rs = pstmt.executeQuery();		
			}else{	
				pstmt = conAms.prepareStatement("select sum(TotalDistanceTravelled) as Distance from AMS.dbo.VehicleSummaryData where RegistrationNo = ? and SystemId = ? and ClientId = ? ");
				pstmt.setString(1, vehicleNumber);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				rs = pstmt.executeQuery();	
			}
			if(rs.next()){
				 Prevodo = (int) Double.parseDouble(prevodometer);
				odometer1 =rs.getInt("Distance")+Prevodo;
			}

		} catch (Exception e) {			
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		odometer =Integer.toString(odometer1);
		return odometer;
}
	public String getPetroCardNumber() {

		Connection conAms = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			conAms = DBConnection.getConnectionToDB("AMS");
			pstmt = conAms.prepareStatement(fuelMileageStatements.GET_PETRO_CARD_NUMBER);
			pstmt.setString(1, vehicleNumber);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				petroCardNumber = rs.getString("PetrolCardNumber");
			}
		} catch (Exception e) {			
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(conAms, pstmt, rs);
		}
		return petroCardNumber;
		
	}
	
	public boolean validVehicleNumber() {
		if (vehicleNumber != null && !vehicleNumber.trim().equals("")) {			
			boolean vehicleExitsOrNot = checkVehicleNo(systemId, clientId, vehicleNumber);
			if(vehicleExitsOrNot){
				return true;
			} else {
				message = message + "\n" + "Line No : " + rowNo + "Failure..!! Vehicle Number Not Belongs to this client..!! ";
				return false;
			}			
		} else {
			message = message + "\n" + "Line No : " + rowNo + "Failure..!! Blank Vehicle Number ..!! ";
			return false;
		}
	}
	
	public boolean validFuelDate() {
		boolean isCorrect = false;
		SimpleDateFormat ddMMYYYY = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

		try {
			if (dateTime != null && !dateTime.equals("")) {
				Date dateTime1 = ddMMYYYY.parse(dateTime);
				dateTime = ddMMYYYY.format(dateTime1);
				isCorrect = true;
			} else {
				message = message + "\n" + "Line No : " + rowNo + "Failure..!! Blank Refuel Date Time ..!! ";
				return false;
			}
		} catch (Exception e) {
			e.printStackTrace();
			message = message + "\n" + "Line No : " + rowNo+ " Vehicle Number : "+ vehicleNumber + " Failure !! Date format of Refuel Date Time must be like dd-MM-yyyy HH:mm:ss.";
			isCorrect = false;
		}

		return isCorrect;
	}
	
	public boolean validOdometer(){
		if(odometer != null && !odometer.trim().equals("")){
			int odometerInt = (int)Double.parseDouble(odometer);
			odometer = String.valueOf(odometerInt);
			return true;
		}else{
			message = message + "\n" + "Line No : "+rowNo + "Failure..!! Blank Odometer ..!! ";
			return false;
		}
	}
	
	public boolean validFuel(){
		if(fuel != null && !fuel.trim().equals("")){			
			fuel = dformat.format(Double.parseDouble(fuel));
			return true;
		}else{
			message = message + "\n" + "Line No : "+rowNo + "Failure..!! Blank Refuel ..!! ";
			return false;
		}
	}
	
	public boolean validAmount(){
		if(amount != null && !amount.trim().equals("")){
			amount = dformat.format(Double.parseDouble(amount));
			return true;
		}else{
			message = message + "\n" + "Line No : "+rowNo + "Failure..!! Blank Amount ..!! ";
			return false;
		}
	}
	
	public boolean checkVehicleNo(int systemId,int clientId, String vehicleNo) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		boolean vehicleExits = false;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select REGISTRATION_NUMBER from dbo.VEHICLE_CLIENT where REGISTRATION_NUMBER = ? and CLIENT_ID = ? and SYSTEM_ID = ?");
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				vehicleExits = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return vehicleExits;
	}
	
	public JSONArray getImportExcelFuelMileageDetails(int clientId, int systemId, List<FuelMileageData> list) {

		JSONArray fuelMileageJsonArray = null;
		JSONObject fuelMileageJsonObject = null;
		int count = 0;		
		try {
			fuelMileageJsonArray = new JSONArray();
			fuelMileageJsonObject = new JSONObject();		
			
			Collections.sort(list, new FuelMileageData());
						
			for (FuelMileageData fuelDetails : list) {
				count++;
				fuelMileageJsonObject = new JSONObject();

				fuelMileageJsonObject.put("slnoIndex", count);
				fuelMileageJsonObject.put("registrationNo", fuelDetails.vehicle);
				fuelMileageJsonObject.put("date", fuelDetails.date);
				fuelMileageJsonObject.put("odometer", fuelDetails.odometer);
				fuelMileageJsonObject.put("fuel", fuelDetails.fuel);
				fuelMileageJsonObject.put("amount", fuelDetails.amount);
				fuelMileageJsonObject.put("slipNo", fuelDetails.slipNo);
				fuelMileageJsonObject.put("fuelStationName",fuelDetails.fuelStationName);
				fuelMileageJsonObject.put("petroCardNumber",fuelDetails.petroCardNumber);
				fuelMileageJsonObject.put("validOrInvalid", "YetToValidate");// Valid
				fuelMileageJsonArray.put(fuelMileageJsonObject);

			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return fuelMileageJsonArray;
	}

}
