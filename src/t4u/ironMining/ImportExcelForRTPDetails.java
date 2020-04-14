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
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.functions.IronMiningFunction;
import t4u.statements.IronMiningStatement;

public class ImportExcelForRTPDetails {

	static JSONArray globalJsonArray = new JSONArray();
	private File inFile;
	private String fileExtension;
	private int userId;
	private int systemId;
	private int clientId;
	private int offset;
	
	private String tcNo;
	private String orgName;
	private String permitNo;
	private String vehicleNo;
	private String quantity;
	private String status;
	
	private int rowNo;
	String message = "";
	String format = "";
	
	public ImportExcelForRTPDetails(File inFile,int userId, int systemId,int clientId,int offset, String fileExtension){
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
	
	public String ImportRTPTripDetails(){
		
		String importMessage = "";
		List<RTPTripDetailsData> list = new ArrayList();	
		
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
								for (int c = 0; c < 5; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												orgName = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												orgName = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												orgName = "";
											}
											else{
												format = "Invalid";
											}
										} else {
											orgName = "";
										}
										break;
									case 1:
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
										
									case 2:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												vehicleNo = cell.getStringCellValue().toUpperCase();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												vehicleNo = cell.getStringCellValue().toUpperCase();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												vehicleNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											vehicleNo = "";
										}
										break;
										
									case 3:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												quantity = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												quantity = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												quantity = "";
											}else{
												format = "Invalid";
											}
										} else {
											quantity = "";
										}
										break;
									}															
								}
								if(orgName!="" || permitNo!="" || vehicleNo!="" || quantity!="")
									  list.add(new RTPTripDetailsData(status,"",orgName,permitNo,quantity,vehicleNo,0,0,0,"",0));
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
								for (int c = 0; c < 5; c++) {
									cell = row.getCell((short) c);
									// If cell contains String value
									switch (c) {
									case 0:
										if (cell != null){ 
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												tcNo = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												tcNo = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												tcNo = "";
											}else{
												format = "Invalid";
											}
										} else {
											tcNo = "";
										}
										break;
									case 1:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING) 
												orgName = cell.getStringCellValue();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												orgName = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												orgName = "";
											}
											else{
												format = "Invalid";
											}
										} else {
											orgName = "";
										}
										break;
									case 2:
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
							
									case 3:
										if (cell != null){
											if(cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
												vehicleNo = cell.getStringCellValue().toUpperCase();
											else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
												cell.setCellType(XSSFCell.CELL_TYPE_STRING);
												vehicleNo = cell.getStringCellValue().toUpperCase();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												vehicleNo = "";
											}
											else{	
												format = "Invalid";
												}
										} else {
											vehicleNo = "";
										}
										break;
										
									case 4:
										if (cell != null){
											if(cell.getCellType() == HSSFCell.CELL_TYPE_STRING) 
												quantity = cell.getStringCellValue();
											else if(cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC){
												cell.setCellType(HSSFCell.CELL_TYPE_STRING);
												quantity = cell.getStringCellValue();
											}else if(cell.getCellType()==Cell.CELL_TYPE_BLANK){
												quantity = "";
											}else{
												format = "Invalid";
											}
										} else {
											quantity = "";
										}
										break;
									}															
								}
								if(tcNo!="" || orgName!="" || permitNo!="" || vehicleNo!="" || quantity!="")
									list.add(new RTPTripDetailsData(status,"",orgName,permitNo,quantity,vehicleNo,0,0,0,"",0));
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				globalJsonArray  = null;
				globalJsonArray = getImportDetailsForRTPTrip(clientId, systemId,getValidTripDetailsForRTP(list,systemId,userId,clientId));
				if(globalJsonArray != null && globalJsonArray.length() > 0){
					importMessage = "Success";
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return importMessage;
	}
	
	public synchronized List<RTPTripDetailsData> getValidTripDetailsForRTP(List<RTPTripDetailsData> list,int systemId,int userId,int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String validstatus = "";
		Set<String> vehicleSet=new HashSet<String>();
		String walletLinked="";
		List<RTPTripDetailsData> validlist = new ArrayList();
		SimpleDateFormat ddMMyyyy = new SimpleDateFormat("yyyy-MM-dd");
		IronMiningFunction ironf=new IronMiningFunction();
		int tcId=0;
		int orgId=0;
		float permitQty=0;
		float usedQty=0;
		String permitStatus="";
		String permitType = "";
		int permitTcId = 0; 
		int permitorgId = 0;
		int permitId=0;
		int destHubId=0;
		int plantId=0;
		String plantName="";
		Date validDateTime;
		Date dateobj = new Date();
	    validDateTime=(Date) ironf.convertStringToDate1(ddMMyyyy.format(dateobj));
		Date startDate = null;
		Date endDate=null;
		String permitIds="";
		String permitId1[];
		String mineral="";
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(list.size()!=0 && !format.equalsIgnoreCase("Invalid")){
				int k=0;
				pstmt = con.prepareStatement(IronMiningStatement.GET_VEHILCE_NO_FOR_TRIP_SHEET_GEN_TRUCK);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,clientId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4,clientId);
				rs = pstmt.executeQuery();
				while(rs.next())
				{
					 vehicleSet.add(rs.getString("VNAME"));
				}
//				pstmt = con.prepareStatement(IronMiningStatement.GET_TC_DETAILS.replace("&", " and TC_NO=?"));
//				pstmt.setInt(1, systemId);
//				pstmt.setInt(2,clientId);
//				pstmt.setInt(3, userId);
//				pstmt.setInt(4,systemId);
//				pstmt.setString(5,list.get(0).tcNo);
//				rs = pstmt.executeQuery();
//				if(rs.next())
//				{
//					walletLinked=rs.getString("WALLET_LINK");
//					tcId=rs.getInt("ID");
//					TCorgId=rs.getInt("ORG_ID");
//				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_ORGANIZATION);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,clientId);
				pstmt.setString(3,list.get(0).orgName);
				rs = pstmt.executeQuery();
				if(rs.next())
				{
					orgId=rs.getInt("ID");
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_RTP_DETAILS);
				pstmt.setString(1,list.get(0).permitNo);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3,clientId);
				rs = pstmt.executeQuery();
				if(rs.next())
				{
					permitId=rs.getInt("ID");
					permitTcId=rs.getInt("TC_ID");
					permitQty=rs.getFloat("PERMIT_QUANTITY");
					usedQty=rs.getFloat("USED_QTY");
					permitStatus=rs.getString("STATUS");
					permitType=rs.getString("PERMIT_TYPE");
					destHubId=rs.getInt("DESTINATION");
					permitorgId=rs.getInt("ORG_ID");
					startDate=(Date) ironf.convertStringToDate1(rs.getString("START_DATE"));
					endDate=(Date) ironf.convertStringToDate1(rs.getString("END_DATE"));
					mineral=rs.getString("MINERAL");
				}
				pstmt = con.prepareStatement(IronMiningStatement.CHECK_PERMIT_NO);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,clientId);
				pstmt.setInt(3,userId);
				rs = pstmt.executeQuery();
				if (rs.next()){
					permitIds=rs.getString("PERMIT_IDS");
					if(permitIds!=""){
					permitId1=permitIds.split(",");
					for(int i=0;i<permitId1.length;i++){
						permitNo=permitNo+"'"+permitId1[i]+"',";
					}
					}
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_PLANT_NAMES_FOR_EXCEL);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2,clientId);
				pstmt.setInt(3,orgId);
				pstmt.setInt(4,destHubId);
				pstmt.setString(5,mineral);
				rs = pstmt.executeQuery();
				if(rs.next())
				{
					plantId=rs.getInt("ID");
					plantName=rs.getString("PLANT_NAME");
				}
				float permitBalance=permitQty-usedQty;
			
				for (RTPTripDetailsData RTPTripDetails : list) {
					
					if(RTPTripDetails.permitNo==null ||RTPTripDetails.permitNo==""){
						RTPTripDetails.remarks = "Invalid Permit No";
						validstatus="Invalid";
					}else if(RTPTripDetails.permitNo.contains("RTP")){
						if(RTPTripDetails.orgName==null || RTPTripDetails.orgName==""){
							RTPTripDetails.remarks = "Invalid Organization";
							validstatus="Invalid";
						}else if(list.get(0).orgName!=RTPTripDetails.orgName){
							RTPTripDetails.remarks = " Please use single Organization. ";
							validstatus="Invalid";
						}else if(permitorgId!=orgId){
							RTPTripDetails.remarks = "Invalid Organization permit ";
							validstatus="Invalid";
						}else if(!permitType.equalsIgnoreCase("Rom Transit")){
							RTPTripDetails.remarks = "Invalid Permit ";
							validstatus="Invalid";
						}
					}else{
						tcId=0;
						RTPTripDetails.tcNo="";
						if(!permitType.equalsIgnoreCase("Purchased Rom Sale Transit Permit")){
							RTPTripDetails.remarks = "Invalid Permit ";
							validstatus="Invalid";
						}else if(permitorgId!=orgId){
							RTPTripDetails.remarks = "Invalid Organization permit ";
							validstatus="Invalid";
						}
					}
					
					if(list.get(0).permitNo!=RTPTripDetails.permitNo){
						RTPTripDetails.remarks = " Please use single permit ";
						validstatus="Invalid";
					}
					if(list.get(0).orgName!=RTPTripDetails.orgName){
						RTPTripDetails.remarks = " Please use single Organization ";
						validstatus="Invalid";
					}
					if(Float.parseFloat(list.get(k).quantity) <= 0){
						RTPTripDetails.remarks = "Enter valid Quantity ";
						validstatus="Invalid";
					}
					else if(Float.parseFloat(list.get(k).quantity) > permitBalance){
						RTPTripDetails.remarks = "Permit Balance is over ";
						validstatus="Invalid";
					}
					if(!(permitStatus.equalsIgnoreCase("APPROVED") || permitStatus.equalsIgnoreCase("ACKNOWLEDGED"))){
						RTPTripDetails.remarks = "Invalid Permit ";
						validstatus="Invalid";
					}
					
			/*		if(RTPTripDetails.vehicleNo!=null && !RTPTripDetails.vehicleNo.equals("")){
						if((!vehicleSet.contains(RTPTripDetails.vehicleNo))&& validstatus!="Invalid"){
							RTPTripDetails.remarks = "Invalid Vehicle Number";
							validstatus="Invalid";
						}
					}
			*/		
					if(plantName.equals("")){
						RTPTripDetails.remarks = "Associate Permit destination to Plant";
						validstatus="Invalid";
					}
					if((RTPTripDetails.permitNo=="" || startDate==null || endDate==null)){
						RTPTripDetails.remarks = "Invalid Permit Number";
						validstatus="Invalid";
					}
					if(startDate!=null && endDate!=null){
						if((!((validDateTime.after(startDate) || validDateTime.equals(startDate)) && (validDateTime.before(endDate) || validDateTime.equals(endDate))))){
							RTPTripDetails.remarks = " Permit Validity Expired ";
							validstatus="Invalid";
						}
					}
					
					if(permitNo.contains("'"+permitId+"'")==false && validstatus!="Invalid"){
						RTPTripDetails.remarks = " Permit is not associated to user ";
						validstatus="Invalid";
					}
					if(validstatus != "Invalid" || validstatus==""){
						validstatus = "Valid";
						RTPTripDetails.remarks= "Valid";
					}
					validlist.add(new RTPTripDetailsData(validstatus,RTPTripDetails.remarks,RTPTripDetails.orgName,RTPTripDetails.permitNo,
							RTPTripDetails.quantity,RTPTripDetails.vehicleNo,tcId,orgId,permitId,plantName,plantId));
					  RTPTripDetails.remarks = "";
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

	public JSONArray getImportDetailsForRTPTrip(int clientId, int systemId, List<RTPTripDetailsData> list) {

		JSONArray RTPTripDetaisJsonArray = null;
		JSONObject RTPTripDetaisJsonObject = null;
		int count = 0;		
		try {
			RTPTripDetaisJsonArray = new JSONArray();
			RTPTripDetaisJsonObject = new JSONObject();		
						
			for (RTPTripDetailsData Details : list) {
				count++;
				RTPTripDetaisJsonObject = new JSONObject();
			
				RTPTripDetaisJsonObject.put("importslnoIndex", count);
				RTPTripDetaisJsonObject.put("importTcNoIndex", Details.tcNo);
				RTPTripDetaisJsonObject.put("importorgNameIndex", Details.orgName);
				RTPTripDetaisJsonObject.put("importPermitNoIndex", Details.permitNo);
				RTPTripDetaisJsonObject.put("importQuantityIndex", Details.quantity);
				RTPTripDetaisJsonObject.put("importVehicleNoIndex", Details.vehicleNo);
				RTPTripDetaisJsonObject.put("importplantNameIndex", Details.plantName);
				RTPTripDetaisJsonObject.put("importplantIdIndex", Details.plantId);
				RTPTripDetaisJsonObject.put("importOrgIdIndex", Details.orgId);
				RTPTripDetaisJsonObject.put("importpermitIdIndex", Details.permitId);
				RTPTripDetaisJsonObject.put("importValidStatusIndex", Details.validstatus);
				RTPTripDetaisJsonObject.put("importRemarksIndex", Details.remarks);
				RTPTripDetaisJsonArray.put(RTPTripDetaisJsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return RTPTripDetaisJsonArray;
	}

}
