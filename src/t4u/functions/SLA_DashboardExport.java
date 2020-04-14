package t4u.functions;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.*;
import org.json.JSONArray;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.GeneralVerticalStatements;


public class SLA_DashboardExport {
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat sdfDBMMDD = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat timef = new SimpleDateFormat("HH:mm");
	DecimalFormat df = new DecimalFormat("0.00");
	DecimalFormat df1=new DecimalFormat("#.##");
	DecimalFormat df3=new DecimalFormat("00");
	CommonFunctions cf = new CommonFunctions();
	
	SimpleDateFormat mmddyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	
//	private static String[] columns = {"S.No", "Trip Creation Time","Trip Creation Month","Trip ID", "Trip No.", "Trip Type","Trip Category", "Route ID", "Make of Vehicle","Type of Vehicle",
//		"Vehicle Number" ,"Customer Name", 
//		"Driver 1 Name", "Driver 1 Contact","Driver 2 Name", "Driver 2 Contact",
//		"Location","Route Key", "Origin City","Destination City","STP","ATP","Placement Delay",
//		"Origin Hub (Loading) Detention (HH:mm:ss)","STD","ATD","Departure Delay wrt STD","STA wrt ATD",
//		"ETA	","ATA"," Transit Delay (HH:mm:ss)","Trip Status","Reason for Delay",
//		"Reason for Cancellation","Destination Hub (Unloading) Detention (HH:mm:ss)","Unplanned Stoppage Time (HH:mm:ss)","Total Truck Running Time(HH:mm:ss)",
//		"Trip Distance (kms)","Average Speed (kms/h)","Panic Alert","Door Alert","Non-Communicating Alert","Red Band Temp @ Reefer(%)","Red Band Temp @ Middle(%)","Red Band Temp @ Door(%)" };
	
	private static String[] columns = { "S. No.",
		"Trip creation time",
		"Trip ID",
		"Trip No.",
		"Trip Type",
		"Trip Category",
		"Vehicle Number",
		"Customer Reference ID",
		"Route Key",
		"Route ID",
		"Customer Name",
		"Customer Type",
		"Make of Vehicle",
		"Type of Vehicle",
		"Driver 1 Name",
		"Driver 1 Contact",
		"Driver 2 Name",
		"Driver 2 Contact",
		"Location",
		"Origin City",
		"Destination City",
		"STP",
		"ATP",
		"Placement Delay",
		"Origin Hub (Loading) Detention ",
		"STD",
		"ATD",
		"Departure Delay wrt STD",
		"Next touching point",
		"Distance to next touching point",
		"ETA to next touching point",
		"STA wrt STD",
		"STA wrt ATD",
		"ETA",
		"ATA",
		"Planned Transit Time (incl. planned stoppages)",
		"Actual Transit Time incl. planned and unplanned stoppages",
		"Transit Delay",
		"Trip Status",
		"Reason for delay",
		"Trip Distance (kms)",
		"Average Speed (kms/h)",
		"Trip Closure/Cancellation date Time",
		"Reason for cancellation/closure",
		"Destination Hub (Unloading) Detention ",
		"Last Communication Stamp" };

	private static String[] custColumns={"S.No","Trip ID","Trip No.","Trip Type","Vehicle Number","Customer Name","Customer Reference ID","Location",
		"Route Key","Origin City","Destination City","STP","ATP","Placement Delay(HH:mm)","STD","ATD","Departure Delay wrt STD","STA(WRT ATD)","ETA","ATA","Actual Transit Time","Transit Delay","Trip Status","Reason for Delay","Reason for Cancellation","Last Communication Stamp"};
	
	public String dashExportData(int systemId, int clientId, int offset, String groupId, String unit,int userId,
			String custId,String routeId,String tripStatus, String startDateRange, String endDateRange,
			String custType,String tripType,String countfromjsp,String zone) throws IOException, InvalidFormatException, ParseException {
       String message="";
		Connection con = null;
		PreparedStatement pstmt = null,pstmt1 = null;
		ResultSet rs = null,rs1 = null;
		int count = 0;
		int rowCount = 0;
		String condition = "";
		double distance = 0;
		double distanceNext = 0;
		String endDate = "";
		String tripStr="",tripStrs="";
		String Delay="";
		Properties prop = ApplicationListener.prop;
		int allowedDetention = Integer.parseInt(prop.getProperty("AllowedDetention"));
		String loadingD="";
		String unloadingD="";
		String custD="";
		String completePath=null;
		try {
			String customername="DHL";
			Properties properties = ApplicationListener.prop;
			String rootPath =  properties.getProperty("slaDashBoardExcelExport");
			//String rootPath ="C:\\LegDetailsExcel";
			System.out.println("rootPath is ::::"+rootPath);
			completePath = rootPath + "//" +customername+"_"+ Calendar.getInstance().getTimeInMillis()+ ".xls";
			File f = new File(rootPath);
			if (!f.exists()) {
				f.mkdir();
			}

			// Create a Workbook
	        Workbook workbook = new HSSFWorkbook(); //new XSSFWorkbook() for generating `.xls` file

	        /* CreationHelper helps us create instances of various things like DataFormat, 
	           Hyperlink, RichTextString etc, in a format (HSSF, XSSF) independent way */
	        CreationHelper createHelper = workbook.getCreationHelper();

	        // Create a Sheet
	        Sheet sheet = workbook.createSheet("SLA Dashboard");

	        // Create a Font for styling header cells
	        Font headerFont = workbook.createFont();
	       // headerFont.setBoldweight(); //.setBoldweight(true);
	        headerFont.setFontHeightInPoints((short) 12);
	        headerFont.setColor(IndexedColors.BLUE.getIndex());

	        // Create a CellStyle with the font
	        CellStyle headerCellStyle = workbook.createCellStyle();
	        headerCellStyle.setFont(headerFont);

	        // Create a Row
	        Row headerRow = sheet.createRow(0);

	        // Create cells
	        for(int i = 0; i < columns.length; i++) {
	            Cell cell = headerRow.createCell(i);
	            cell.setCellValue(columns[i]);
	            cell.setCellStyle(headerCellStyle);
	        }

	        // Create Cell Style for formatting Date
	        CellStyle dateCellStyle = workbook.createCellStyle();
	        dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy HH:mm:ss"));

	        CellStyle timeCellStyle = workbook.createCellStyle();
	        DataFormat fmt = workbook.createDataFormat();
	        timeCellStyle.setDataFormat( fmt.getFormat("@"));
	        
	        Font redFont = workbook.createFont();
	        redFont.setColor(IndexedColors.RED.getIndex());
	        CellStyle redFontStyle = workbook.createCellStyle();
	        redFontStyle.setFont(redFont);
	        
	        Font greenFont = workbook.createFont();
	        greenFont.setColor(IndexedColors.GREEN.getIndex());
	        CellStyle greenFontStyle = workbook.createCellStyle();
	        greenFontStyle.setFont(greenFont);
	        
	        CellStyle decimalStyle = workbook.createCellStyle();
	        decimalStyle.setAlignment(CellStyle.ALIGN_RIGHT);
	        decimalStyle.setDataFormat(fmt.getFormat("0.00"));
	       
	        /*
	         * Cell style when cell contains "" or NA value
	         * Author: Narendra
	         * Date: 04/08/2018
	         * 
	         */
	        CellStyle blankOrNAStyle = workbook.createCellStyle();
			blankOrNAStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
			blankOrNAStyle.setFillPattern(CellStyle.SOLID_FOREGROUND); 
	        
	        int rowNum = 1;
	        
			con = DBConnection.getConnectionToDB("AMS");
			String groupBy = " group by CUSTOMER_REF_ID,NEXT_POINT_DISTANCE,AVG_SPEED,STOPPAGE_DURATION,td.ROUTE_ID,td.TRIP_ID,td.SHIPMENT_ID,td.ASSET_NUMBER,td.CUSTOMER_NAME,td.DEST_ARR_TIME_ON_ATD,"
				+ "	 td.DRIVER_NAME,td.DRIVER_NUMBER,gps.LOCATION,NEXT_POINT,td.TRIP_START_TIME,td.ACTUAL_TRIP_START_TIME,td.NEXT_POINT_ETA,td.DESTINATION_ETA,ds.PLANNED_ARR_DATETIME,"
				+ "	 td.ACTUAL_DISTANCE,ds1.NAME,ds.NAME,td.STATUS,td.TRIP_STATUS,td.DELAY,ACTUAL_TRIP_END_TIME,ds.PLANNED_ARR_DATETIME,DESTINATION_ETA,ACTUAL_TRIP_START_TIME,ACT_SRC_ARR_DATETIME,"
				+ "	 ORDER_ID,vm.ModelName,td.ROUTE_NAME,ds1.PLANNED_ARR_DATETIME,ds1.ACT_ARR_DATETIME,ds.ACT_ARR_DATETIME,td.ACTUAL_DISTANCE,ds.ACT_DEP_DATETIME,"
				+ "	 td.FUEL_CONSUMED,td.MILEAGE,td.OBD_MILEAGE,td.NEXT_LEG,td.NEXT_LEG_ETA,ll0.HUB_CITY, ll1.HUB_CITY, ll0.HUB_STATE, ll1.HUB_STATE,u.Firstname,u.Lastname,vm.VehType,REMARKS," +
						" td.PRODUCT_LINE,td.TRIP_CATEGORY,trd.ROUTE_KEY,UNSCHEDULED_STOP_DUR,PLANNED_DURATION,ds1.DISTANCE_FLAG,ds1.DETENTION_TIME,ds.DETENTION_TIME,td.END_LOCATION,RED_DUR_T1,RED_DUR_T2,RED_DUR_T3,DISTANCE_TRAVELLED " +
						" ,td.INSERTED_TIME,c.VehicleType,ACTUAL_DURATION,trd.TAT, rd.TRAVEL_TIME, td.TRIP_CUSTOMER_TYPE,gps.DRIVER_NAME,gps.DRIVER_MOBILE,custd.CUSTOMER_REFERENCE_ID, gps.GMT" ;
			
			String eventStrHubDetention=" and td.TRIP_ID in (select distinct TRIP_ID from DES_TRIP_DETAILS where  ACT_ARR_DATETIME is not null and SEQUENCE not in (0,100) and ACT_DEP_DATETIME is null "+  
			" and datediff(mi,ACT_ARR_DATETIME,isnull(ACT_DEP_DATETIME,getutcdate()))>isnull(DETENTION_TIME,0))";
			String eventQueryStoppage=" and td.TRIP_ID in (select distinct TRIP_ID from TRIP_EVENT_DETAILS where ALERT_TYPE=1) and gps.CATEGORY='stoppage' ";
			String eventQueryroutedEviation="and td.TRIP_ID in (select distinct TRIP_ID from TRIP_EVENT_DETAILS a where ALERT_TYPE=5 and TRIP_ID not in (select TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=td.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT))";
			String eventQuerydelayedLateDeparture=" and td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and ds.SEQUENCE=100 and (ACTUAL_TRIP_START_TIME>td.TRIP_START_TIME and (DATEDIFF(mi,isnull(td.DEST_ARR_TIME_ON_ATD,ds.PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,td.TRIP_START_TIME,ACTUAL_TRIP_START_TIME)))";
			String additionalconditionfordelay=" and td.TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+ 
				" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+  
				" and (ACTUAL_TRIP_START_TIME>td.TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,td.TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) ";

			if(groupId.equals("0")){
				condition = "and td.STATUS='OPEN'";
			}else if(groupId.equals("1")){
				condition = "and td.TRIP_START_TIME between dateadd(dd,-2,getutcdate()) and getutcdate()";
			}else if(groupId.equals("2")){
				condition = "and td.TRIP_START_TIME between dateadd(dd,-7,getutcdate()) and getutcdate()";
			}else if(groupId.equals("3")){
				condition = "and td.TRIP_START_TIME between dateadd(dd,-15,getutcdate()) and getutcdate()";
			}else if(groupId.equals("4")){
				condition = "and td.TRIP_START_TIME between dateadd(dd,-30,getutcdate()) and getutcdate()";
			}else if(groupId.equals("5")){
				condition = "and td.TRIP_START_TIME between dateadd(mi,-330,'"+startDateRange+" 00:00:00') and dateadd(mi,-330,'"+endDateRange+" 23:59:59')";
			}
			
			//Dhl BlueDart start table
			 if (tripStatus.equalsIgnoreCase("delayedonetotwohour")) {
					Delay = "True";
					tripStatus = "DELAYED";
					tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'"
							+ " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120 "
							+ additionalconditionfordelay;
				} else  if (tripStatus.equalsIgnoreCase("delayedtwotothreehour")) {
					Delay = "True";
					tripStatus = "DELAYED";
					tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'"
							+ " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 "
							+ additionalconditionfordelay;
				} else  if (tripStatus.equalsIgnoreCase("delayedthreetofivehour")) {
					Delay = "True";
					tripStatus = "DELAYED";
					tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'"
							+ " and isnull(DELAY,0)>180 and isnull(DELAY,0)<300 "
							+ additionalconditionfordelay;
				} else   if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour")) {
					Delay = "True";
					tripStatus = "DELAYED";
					tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'"
							+ " and isnull(DELAY,0)>300 "
							+ additionalconditionfordelay;
				} else ////////////
					 if (tripStatus.equalsIgnoreCase("delayedonetotwohour-deviation")) {
							Delay = "";
							tripStatus = "DELAYED";
							tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
									+ " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120 "
									+ additionalconditionfordelay + eventQueryroutedEviation;
						} else if (tripStatus.equalsIgnoreCase("delayedonetotwohour-stoppage")) {
							Delay = "";
							tripStatus = "DELAYED";
							tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
									+ " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120"
									+ additionalconditionfordelay + eventQueryStoppage;
						} else  if (tripStatus.equalsIgnoreCase("delayedtwotothreehour-deviation")) {
							Delay = "";
							tripStatus = "DELAYED";
							tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
									+ " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 "
									+ additionalconditionfordelay + eventQueryroutedEviation;
						} else if (tripStatus.equalsIgnoreCase("delayedtwotothreehour-stoppage")) {
							Delay = "";
							tripStatus = "DELAYED";
							tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
									+ " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 "
									+ additionalconditionfordelay + eventQueryStoppage;
						} else if(tripStatus.equalsIgnoreCase("delayedthreetofivehour-deviation")) {
							Delay = "";
							tripStatus = "DELAYED";
							tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
									+ " and isnull(DELAY,0)>180  and isnull(DELAY,0)<300"
									+ additionalconditionfordelay
									+ eventQueryroutedEviation;
						}else if (tripStatus.equalsIgnoreCase("delayedthreetofivehour-stoppage")) {
							Delay = "";
							tripStatus = "DELAYED";
							tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
									+ " and isnull(DELAY,0)>180 and isnull(DELAY,0)<300"
									+ additionalconditionfordelay + eventQueryStoppage;
						} else  if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour-deviation")) {
							Delay = "";
							tripStatus = "DELAYED";
							tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
									+ " and isnull(DELAY,0)>300 "
									+ additionalconditionfordelay + eventQueryroutedEviation;
						} else if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour-stoppage")) {
							Delay = "";
							tripStatus = "DELAYED";
							tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
									+ " and isnull(DELAY,0)>300"
									+ additionalconditionfordelay + eventQueryStoppage;
						} else 
				
			//Dhl bluedart end table
			
			if(tripStatus.equalsIgnoreCase("enrouteId")){
				Delay ="";
				tripStatus="ENROUTE PLACEMENT%";
				tripStr="and TRIP_STATUS like '"+ tripStatus+"'";
			}
			else if (tripStatus.equalsIgnoreCase("onTimeId")){
				Delay ="";
				tripStatus="ON TIME";
				tripStr="and TRIP_STATUS = '"+ tripStatus+"'";
			}
			else if (tripStatus.equalsIgnoreCase("delayedless1")){
				Delay="True";
				tripStatus="DELAYED";
				tripStr="and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)<60 "+additionalconditionfordelay ;
			}
			else if (tripStatus.equalsIgnoreCase("delayedgreater1")){
				Delay="True";
				tripStatus="DELAYED";
				tripStr="and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)>60 "+additionalconditionfordelay ;
			}
			else if (tripStatus.equalsIgnoreCase("enrouteId-Ontime")){
				Delay ="";
				tripStatus="ENROUTE PLACEMENT ON TIME";
				tripStr="and TRIP_STATUS = '"+ tripStatus+"'";
			}
			else if (tripStatus.equalsIgnoreCase("enrouteId-delay")){
				Delay ="";
				tripStatus="ENROUTE PLACEMENT DELAYED";
				tripStr="and TRIP_STATUS = '"+ tripStatus+"'";
			}
			else if (tripStatus.equalsIgnoreCase("loading-detention")){
				Delay ="";
				tripStatus="LOADING DETENTION";
				tripStr="and TRIP_STATUS = '"+ tripStatus+"'";
			}
			else if (tripStatus.equalsIgnoreCase("unloading-detention")){
				Delay ="";
				tripStatus="UNLOADING DETENTION";
				tripStr="and TRIP_STATUS = '"+ tripStatus+"'";
			}	
			else if (tripStatus.equalsIgnoreCase("delay-late-departure")){
				Delay ="True";
				tripStatus="DELAYED LATE DEPARTURE";
				tripStrs=" "+eventQuerydelayedLateDeparture;
			}	//EVENT QUERIES
			//ONTIME
			else if (tripStatus.equalsIgnoreCase("onTimeId-hubhetention")){
				Delay ="";
				tripStatus="ON TIME";
				tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+eventStrHubDetention;
			}
			else if (tripStatus.equalsIgnoreCase("onTimeId-stoppage")){
				Delay ="";
				tripStatus="ON TIME";
				tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+eventQueryStoppage;  
			}
			else if (tripStatus.equalsIgnoreCase("onTimeId-deviation")){
				Delay ="";
				tripStatus="ON TIME";
				tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+eventQueryroutedEviation;  
			}
			//DELAYED<1HR
			else if (tripStatus.equalsIgnoreCase("delayedless1-detention")){
				Delay ="";
				tripStatus="DELAYED";
				tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)<60"+additionalconditionfordelay + eventStrHubDetention;
			}
			else if (tripStatus.equalsIgnoreCase("delayedless1-stoppage")){
				Delay ="";
				tripStatus="DELAYED";
				tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)<60"+additionalconditionfordelay + eventQueryStoppage; 
			}
			else if (tripStatus.equalsIgnoreCase("delayedless1-deviation")){
				Delay ="";
				tripStatus="DELAYED";
				tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)<60"+additionalconditionfordelay + eventQueryroutedEviation;
			}
			//DELAYED>1HR
			else if (tripStatus.equalsIgnoreCase("delayedgreater1-detention")){
				Delay ="";
				tripStatus="DELAYED";
				tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)>60"+additionalconditionfordelay + eventStrHubDetention;
			}
			else if (tripStatus.equalsIgnoreCase("delayedgreater1-stoppage")){
				Delay ="";
				tripStatus="DELAYED";
				tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)>60"+additionalconditionfordelay + eventQueryStoppage;
			}
			else if (tripStatus.equalsIgnoreCase("delayedgreater1-deviation")){
				Delay ="";
				tripStatus="DELAYED";
				tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)>60"+additionalconditionfordelay + eventQueryroutedEviation;
			}
			else{
				Delay ="";
				//tripStr="and td.TRIP_STATUS <> 'NEW'";
				tripStr="";
			}
			String stmt="";
			
			if(tripStatus.equalsIgnoreCase("DELAYED") && Delay.equalsIgnoreCase("True")){
				//System.out.println("i am in 1 ");
				stmt=GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL_DELAY.replace("&", condition).concat(tripStr).replaceAll("330",""+offset).replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone);
				}else if (tripStatus.equalsIgnoreCase("DELAYED LATE DEPARTURE")){
				//	System.out.println("i am in 2");
					stmt=GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL.replace("&", condition).concat(tripStr).concat(tripStrs).replaceAll("330",""+offset).replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone);
				//	stmt=stmt.replace("td.TRIP_STATUS,", "'DELAYED LATE DEPARTURE' as TRIP_STATUS,");
				}else {
					//System.out.println("i am in 3");
					stmt=GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL.replace("&", condition).concat(tripStr).replaceAll("330",""+offset).replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone);
				}
				
				
				
			if(routeId.equals("ALL")){
				stmt = stmt.replace("#", "");
			}else{
				routeId = routeId.substring(0, routeId.length()-1);
				stmt=stmt.replace("#", "and td.ROUTE_ID in ("+routeId+")");
			}
//			if(custName.equals("ALL")){
//				stmt = stmt.replace("$", "");
//			}else{
//				stmt=stmt.replace("$","and CUSTOMER_NAME='"+custName+"'");
//			}
			if(custId.equals("ALL")){
				stmt = stmt.replace("$", "");
			}else{
				custId = custId.substring(0, custId.length()-1);
				stmt=stmt.replace("$","and td.TRIP_CUSTOMER_ID in ("+custId+")");
			}
			if(custType.equals("ALL")){
				stmt = stmt.replace("custTypeCondition", "");
			}else{
				custType=custType.substring(0, custType.length()-1);
				stmt=stmt.replace("custTypeCondition","and TRIP_CUSTOMER_TYPE in ("+custType+")");
			}
			if(tripType.equals("ALL")){
				stmt = stmt.replace("tripTypeCondition", "");
			}else{
				tripType=tripType.substring(0, tripType.length()-1);
				stmt=stmt.replace("tripTypeCondition","and PRODUCT_LINE in ("+tripType+")");
			}
			if (countfromjsp != null && Integer.parseInt(countfromjsp) > 0) {
			pstmt=con.prepareStatement(stmt+ " "+groupBy+" order by td.TRIP_ID desc");
			//System.out.println("getTripSummaryDetailsDHL :"+stmt+ " "+groupBy+" order by td.TRIP_ID desc" );
			pstmt.setInt(1,offset);
			pstmt.setInt(2,offset);
			pstmt.setInt(3,offset);
			pstmt.setInt(4,offset);
			pstmt.setInt(5,offset);
			pstmt.setInt(6,offset);
			pstmt.setInt(7,offset);
			pstmt.setInt(8, allowedDetention);
			pstmt.setInt(9,offset);
			pstmt.setInt(10,offset);
			pstmt.setInt(11,offset);
			//pstmt.setInt(12, allowedDetention);
			pstmt.setInt(12, offset);
			pstmt.setInt(13,offset);
			pstmt.setInt(14,offset);
			pstmt.setInt(15,offset);
			pstmt.setInt(16, systemId);
			pstmt.setInt(17,clientId);
			}
			else {
			pstmt = con.prepareStatement(GeneralVerticalStatements.GET_LISTVIEW_TRIP_DETAILS);
			}
			rs = pstmt.executeQuery();
			while (rs.next()) {
				
				
				String driver1 = "";
				String driver1Contact = "";
				String driver2 = "";
				String driver2Contact = "";
				
				endDate = "";
				count++;
				String STD="";
				if(!rs.getString("STD").contains("1900")){
					STD = mmddyyy.format(sdfDB.parse(rs.getString("STD")));
				}
				String ATD="";
				if(!rs.getString("ATD").contains("1900")){
					ATD = mmddyyy.format(sdfDB.parse(rs.getString("ATD")));
				}
				String ETHA="";
				if(!rs.getString("ETHA").contains("1900")){
					ETHA = mmddyyy.format(sdfDB.parse(rs.getString("ETHA")));
				}
				String ETA="";
				if(!rs.getString("ETA").contains("1900")){
					ETA = mmddyyy.format(sdfDB.parse(rs.getString("ETA")));
				}
				String STA="";
				if(!rs.getString("STA").contains("1900")){
					STA = mmddyyy.format(sdfDB.parse(rs.getString("STA")));
				}
				
				String STA_ON_STD="";
				if(!rs.getString("STA").contains("1900")){
					STA_ON_STD = mmddyyy.format(sdfDB.parse(rs.getString("STA")));
				}
				
				
				String STA_ON_ATD="";
				if(!rs.getString("STA_ON_ATD").contains("1900")){
					STA_ON_ATD = mmddyyy.format(sdfDB.parse(rs.getString("STA_ON_ATD")));
				}
				
				String ATP="";
				if(!rs.getString("ATP").contains("1900")){
					ATP = mmddyyy.format(sdfDB.parse(rs.getString("ATP")));
				}
				
				String STP="";
				if(!rs.getString("STP").contains("1900")){
					STP = mmddyyy.format(sdfDB.parse(rs.getString("STP")));
				}
				
				String ATA="";
				if(!rs.getString("ATA").contains("1900")){
					ATA = mmddyyy.format(sdfDB.parse(rs.getString("ATA")));
				}
				int tripNO=Integer.parseInt(rs.getString("TRIP_NO"));
				
				//jsonobject = new JSONObject();
				 Row row = sheet.createRow(rowNum++);
				 rowCount =0;
				row.createCell(rowCount).setCellValue(count);
				
				String tripCreationTime="";
				if(!rs.getString("INSERTED_TIME").contains("1900")){
					tripCreationTime = mmddyyy.format(sdfDB.parse(rs.getString("INSERTED_TIME")));
				}
				Cell dateCell1Cr = row.createCell(++rowCount);//1
				if(tripCreationTime.equalsIgnoreCase("")||tripCreationTime.equalsIgnoreCase("NA")){
					dateCell1Cr.setCellValue(tripCreationTime);
					dateCell1Cr.setCellStyle(blankOrNAStyle);
				}else{
					dateCell1Cr.setCellValue(tripCreationTime);
					dateCell1Cr.setCellStyle(timeCellStyle);
				}
				//row.createCell(++rowCount).setCellValue(new SimpleDateFormat("MMMM").format(sdfDB.parse(rs.getString("INSERTED_TIME"))));
				
				Cell cell=row.createCell(++rowCount);
				if(rs.getString("TRIP_ID").equalsIgnoreCase("")||rs.getString("TRIP_ID").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("TRIP_ID"));
					cell.setCellStyle(blankOrNAStyle);
				}
				else
				{
					cell.setCellValue(rs.getString("TRIP_ID"));
					
				}
				cell=row.createCell(++rowCount);
				
				if(rs.getString("LR_NO").equalsIgnoreCase("")||rs.getString("LR_NO").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("LR_NO"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("LR_NO"));
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("PRODUCT_LINE").equalsIgnoreCase("")||rs.getString("PRODUCT_LINE").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("PRODUCT_LINE"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("PRODUCT_LINE"));
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("TRIP_CATEGORY").equalsIgnoreCase("")||rs.getString("TRIP_CATEGORY").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("TRIP_CATEGORY"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("TRIP_CATEGORY"));
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("VEHICLE_NO").equalsIgnoreCase("")||rs.getString("VEHICLE_NO").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("VEHICLE_NO"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("VEHICLE_NO"));
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("CUSTOMER_REF_ID").equalsIgnoreCase("")||rs.getString("CUSTOMER_REF_ID").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("CUSTOMER_REF_ID"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("CUSTOMER_REF_ID"));
				}
			
				cell=row.createCell(++rowCount);
				if(rs.getString("RouteKey").equalsIgnoreCase("")||rs.getString("RouteKey").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("RouteKey"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("RouteKey"));
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("ROUTE_NAME").equalsIgnoreCase("")||rs.getString("ROUTE_NAME").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("ROUTE_NAME"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("ROUTE_NAME"));
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("CUSTOMER_NAME").equalsIgnoreCase("")||rs.getString("CUSTOMER_NAME").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("CUSTOMER_NAME"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("CUSTOMER_NAME"));
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("TRIP_CUSTOMER_TYPE").equalsIgnoreCase("")||rs.getString("TRIP_CUSTOMER_TYPE").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("TRIP_CUSTOMER_TYPE"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("TRIP_CUSTOMER_TYPE"));
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("MAKE").equalsIgnoreCase("")||rs.getString("MAKE").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("MAKE"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("MAKE"));
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("VehicleType").equalsIgnoreCase("")||rs.getString("VehicleType").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("VehicleType"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("VehicleType"));
				}	
				
				
				/*cell=row.createCell(++rowCount); // 26
					if(rs.getString("LAST_COMMUNICATION_STAMP").equalsIgnoreCase("")||rs.getString("LAST_COMMUNICATION_STAMP").contains("1900"))
					{
						cell.setCellValue(rs.getString("LAST_COMMUNICATION_STAMP"));
						cell.setCellStyle(blankOrNAStyle);
					}else
					{
						cell.setCellValue(rs.getString("LAST_COMMUNICATION_STAMP"));
					}*/
				
				
				//String legGroupBy = "group by LEG_NAME, lz.NAME,lz1.NAME ,STD ,STA ,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,tl.TOTAL_DISTANCE ,tl.AVG_SPEED,tl.FUEL_CONSUMED,tl.MILEAGE," +
				//" tl.OBD_MILEAGE,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,d.Fullname,d1.Fullname,ETA,tdd.GREEN_BAND_SPEED_PERC,tdd.GREEN_RPM_PERC,d.Mobile,d1.Mobile,tl.ID,lm.TAT";
				String legGroupBy = " group by tl.LEG_ID , LEG_NAME, lz.NAME,lz1.NAME ,STD ,STA ,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,tl.TOTAL_DISTANCE ,tl.AVG_SPEED,tl.FUEL_CONSUMED,tl.MILEAGE, "+
				" tl.OBD_MILEAGE,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,d.Fullname,d1.Fullname,ETA,tdd.GREEN_BAND_SPEED_PERC,tdd.GREEN_RPM_PERC,d.Mobile,d1.Mobile,tl.ID,lm.TAT "+
				" ,lm.DISTANCE,lz.Standard_Duration,lz1.Standard_Duration ";
		
				
				try
				{
				pstmt1=con.prepareStatement(GeneralVerticalStatements.GET_TRIP_SUMMARY_REPORT_LEG_DETAILS.replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone)+ legGroupBy + " order by tl.LEG_ID ");
				pstmt1.setInt(1,offset);
				pstmt1.setInt(2,offset);
				pstmt1.setInt(3,offset);
				pstmt1.setInt(4,offset);
				pstmt1.setInt(5,offset);
				pstmt1.setInt(6,tripNO);
				rs1=pstmt1.executeQuery();
				int legsequence = 0;
				while(rs1.next())
				{
					legsequence++;
					String LEGATD="";
					if(!rs1.getString("ATD").contains("1900")){
						LEGATD = mmddyyy.format(sdfDB.parse(rs1.getString("ATD")));
					}
					String LEGATA="";
					if(!rs1.getString("ATA").contains("1900")){
						LEGATA = mmddyyy.format(sdfDB.parse(rs1.getString("ATA")));
					}
					if (legsequence==1) {
						driver1 = rs1.getString("DRIVER1");
						driver1Contact = rs1.getString("DRIVER1_CONTACT");
						driver2 = rs1.getString("DRIVER2");
						driver2Contact = rs1.getString("DRIVER2_CONTACT");
					}else			
					if ((LEGATA.equalsIgnoreCase("")) && (!LEGATD.equalsIgnoreCase(""))){
						driver1 = rs1.getString("DRIVER1");
						driver1Contact = rs1.getString("DRIVER1_CONTACT");
						driver2 = rs1.getString("DRIVER2");
						driver2Contact = rs1.getString("DRIVER2_CONTACT");
						
					}
					
				}
				}catch(Exception e)
				{
					e.printStackTrace();
				}
				
				cell=row.createCell(++rowCount);
				if(driver1.equalsIgnoreCase("")||driver1.equalsIgnoreCase("NA")){
					cell.setCellValue(driver1);
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(driver1);
				}
				
				cell=row.createCell(++rowCount);
				if(driver1Contact.equalsIgnoreCase("")||driver1Contact.equalsIgnoreCase("NA")){
					cell.setCellValue(driver1Contact);
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(driver1Contact);
				}
				cell=row.createCell(++rowCount);
				if(driver2.equalsIgnoreCase("")||driver2.equalsIgnoreCase("NA")){
					cell.setCellValue(driver2);
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(driver2);
				}
				
				cell=row.createCell(++rowCount);
				if(driver2Contact.equalsIgnoreCase("")||driver2Contact.equalsIgnoreCase("NA")){
					cell.setCellValue(driver2Contact);
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(driver2Contact);
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("LOCATION").equalsIgnoreCase("")||rs.getString("LOCATION").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("LOCATION"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("LOCATION"));
				}
				
				
				
				cell=row.createCell(++rowCount);
				if(rs.getString("OriginCity").equalsIgnoreCase("")||rs.getString("OriginCity").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("OriginCity"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("OriginCity"));
				}
				
				cell=row.createCell(++rowCount);
				if(rs.getString("DestinationCity").equalsIgnoreCase("")||rs.getString("DestinationCity").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("DestinationCity"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("DestinationCity"));
				}
				
				Cell dateCell17 = row.createCell(++rowCount);
				if(STP.equalsIgnoreCase("")||STP.equalsIgnoreCase("NA")){
					dateCell17.setCellValue(STP);
					dateCell17.setCellStyle(blankOrNAStyle);
				}else{
					dateCell17.setCellValue(STP);
					dateCell17.setCellStyle(timeCellStyle);
				}
				
				Cell dateCell18 = row.createCell(++rowCount);
				if(ATP.equalsIgnoreCase("")||ATP.equalsIgnoreCase("NA")){
					dateCell18.setCellValue(ATP);
					dateCell18.setCellStyle(blankOrNAStyle);
				}else{
					dateCell18.setCellValue(ATP);
					dateCell18.setCellStyle(timeCellStyle);
				}
					
				//row.createCell(19).setCellValue(ATP);
				
				//String PlacedelayS=cf.convertMinutesToHHMMFormat(rs.getInt("PLACEMENT_DELAY"));
				Cell dateCell32 = row.createCell(++rowCount);
				if(rs.getInt("PLACEMENT_DELAY")<0){
					dateCell32.setCellValue("-"+cf.convertMinutesToHHMMSSFormat(-(rs.getInt("PLACEMENT_DELAY"))));
					dateCell32.setCellStyle(timeCellStyle);
					//row.createCell(33).setCellValue("00.00");
				}else{
					dateCell32.setCellValue(cf.convertMinutesToHHMMSSFormat(rs.getInt("PLACEMENT_DELAY")));
					dateCell32.setCellStyle(timeCellStyle);
					//row.createCell(33).setCellValue(PlacedelayS);
				}
				if(rs.getInt("LOADING_DETENTION")<0){
					loadingD="-"+cf.convertMinutesToHHMMSSFormat(-rs.getInt("LOADING_DETENTION"));
				}else{
					loadingD=cf.convertMinutesToHHMMSSFormat(rs.getInt("LOADING_DETENTION"));
				}
				
				Cell dateCell34 = row.createCell(++rowCount);
				if(loadingD.equalsIgnoreCase("")||loadingD.equalsIgnoreCase("NA")){
					dateCell34.setCellValue(loadingD);
					dateCell34.setCellStyle(blankOrNAStyle);
				}else{
					dateCell34.setCellValue(loadingD);
					dateCell34.setCellStyle(timeCellStyle);
				}
				
				Cell dateCell19 = row.createCell(++rowCount);
				if(STD.equalsIgnoreCase("")||STD.equalsIgnoreCase("NA")){
					dateCell19.setCellValue(STD);
					dateCell19.setCellStyle(blankOrNAStyle);
				}
				else
				{
					dateCell19.setCellValue(STD);
					dateCell19.setCellStyle(timeCellStyle);
				}
								
				Cell dateCell20 = row.createCell(++rowCount);
				if(ATD.equalsIgnoreCase("")||ATD.equalsIgnoreCase("NA")){
					dateCell20.setCellValue(ATD);
					dateCell20.setCellStyle(blankOrNAStyle);
				}else{
					dateCell20.setCellValue(ATD);
					dateCell20.setCellStyle(timeCellStyle);
				}
				
				String delayDepS=cf.convertMinutesToHHMMSSFormat(rs.getInt("delayedDepartureATD_STD"));
				String delayDepE="-"+cf.convertMinutesToHHMMSSFormat(-rs.getInt("delayedDepartureATD_STD"));
				Cell dateCell28 = row.createCell(++rowCount);
				if(rs.getInt("delayedDepartureATD_STD")<0){
					dateCell28.setCellValue(delayDepE);
					dateCell28.setCellStyle(timeCellStyle);
				}else{
					dateCell28.setCellValue(delayDepS);
					dateCell28.setCellStyle(timeCellStyle);
				}
								
				/*
				 * add touch point details 
				 * 
				 */
				
				Cell dateCelltp1 = row.createCell(++rowCount);
				if(rs.getString("NEAREST_HUB").equalsIgnoreCase("")||rs.getString("NEAREST_HUB").equalsIgnoreCase("NA")){
					dateCelltp1.setCellValue(rs.getString("NEAREST_HUB"));
					dateCelltp1.setCellStyle(blankOrNAStyle);
				}else{
					dateCelltp1.setCellValue(rs.getString("NEAREST_HUB"));
					dateCelltp1.setCellStyle(timeCellStyle);
				}
				
				distanceNext= rs.getDouble("DISTANCE_TO_NEXTHUB");
				if(unit.equals("Miles")){
					distanceNext = rs.getDouble("DISTANCE_TO_NEXTHUB") * 0.621371; 
				}
				
				Cell dateCelltp2 = row.createCell(++rowCount);
				if(distanceNext<0){
					dateCelltp2.setCellValue(distanceNext);
					dateCelltp2.setCellStyle(blankOrNAStyle);
				}else{
					dateCelltp2.setCellValue(distanceNext);
					dateCelltp2.setCellStyle(timeCellStyle);
				}
				
				String nextLegETA="";
				if(!rs.getString("ETHA").contains("1900")){
					nextLegETA = sdf.format(sdfDB.parse(rs.getString("ETHA")));
				}

				Cell dateCelltp3 = row.createCell(++rowCount);
				if(nextLegETA.equalsIgnoreCase("")||nextLegETA.equalsIgnoreCase("NA")){
					dateCelltp3.setCellValue(nextLegETA);
					dateCelltp3.setCellStyle(blankOrNAStyle);
				}else{
					dateCelltp3.setCellValue(nextLegETA);
					dateCelltp3.setCellStyle(timeCellStyle);
				}
			
				
				Cell dateCellsws = row.createCell(++rowCount);
				if(STA_ON_STD.equalsIgnoreCase("")||STA_ON_STD.equalsIgnoreCase("NA")){
					dateCellsws.setCellValue(STA_ON_STD);
					dateCellsws.setCellStyle(blankOrNAStyle);
				}else{
					dateCellsws.setCellValue(STA_ON_STD);
					dateCellsws.setCellStyle(timeCellStyle);
				}
				
				Cell dateCell26 = row.createCell(++rowCount);
				if(STA_ON_ATD.equalsIgnoreCase("")||STA_ON_ATD.equalsIgnoreCase("NA")){
					dateCell26.setCellValue(STA_ON_ATD);
					dateCell26.setCellStyle(blankOrNAStyle);
				}else{
					dateCell26.setCellValue(STA_ON_ATD);
					dateCell26.setCellStyle(timeCellStyle);
				}
				
				Cell dateCell24 = row.createCell(++rowCount);
				if(ETA.equals("")||ETA.equalsIgnoreCase("NA")){
					dateCell24.setCellValue(ETA);
					dateCell24.setCellStyle(blankOrNAStyle);
				}else{
					dateCell24.setCellValue(ETA);
					dateCell24.setCellStyle(timeCellStyle);
				}
			
				 dateCell24 = row.createCell(++rowCount);
				if(ATA.equals("")||ATA.equalsIgnoreCase("NA")){
					dateCell24.setCellValue(ATA);
					dateCell24.setCellStyle(blankOrNAStyle);
				}else{
					dateCell24.setCellValue(ATA);
					dateCell24.setCellStyle(timeCellStyle);
				}
				
				String ptS=cf.convertMinutesToHHMMSSFormat(rs.getInt("PLANNED_TRANSIT_TIME"));
				//String ptE=cf.convertMinutesToHHMMFormatNegative(rs.getInt("PLANNED_TRANSIT_TIME"));
				String ptE="-"+cf.convertMinutesToHHMMSSFormat(-rs.getInt("PLANNED_TRANSIT_TIME"));
				Cell dateCellDelay2 = row.createCell(++rowCount);
				if(rs.getInt("PLANNED_TRANSIT_TIME")<0){
					//jsonobject.put("plannedTT", ptE);
					dateCellDelay2.setCellValue(ptE);
					dateCellDelay2.setCellStyle(timeCellStyle);
				}else{
					//jsonobject.put("plannedTT", ptS);
					dateCellDelay2.setCellValue(ptS);
					dateCellDelay2.setCellStyle(timeCellStyle);
				}


				String atS=cf.convertMinutesToHHMMSSFormat(rs.getInt("ACTUAL_TRANSIT_TIME"));
			//	String atE=cf.convertMinutesToHHMMFormatNegative(rs.getInt("ACTUAL_TRANSIT_TIME"));
				 String atE="-"+cf.convertMinutesToHHMMSSFormat(-rs.getInt("ACTUAL_TRANSIT_TIME"));
				Cell dateCellDelay1 = row.createCell(++rowCount);
				if(rs.getInt("ACTUAL_TRANSIT_TIME")<0){
					//jsonobject.put("actualTT", atE);
					dateCellDelay1.setCellValue(atE);
					dateCellDelay1.setCellStyle(timeCellStyle);
				}else{
					//jsonobject.put("actualTT", atS);
					dateCellDelay1.setCellValue(atS);
					dateCellDelay1.setCellStyle(timeCellStyle);
				}
					
				String delayS=cf.convertMinutesToHHMMSSFormat(rs.getInt("transitDelay"));
				String delayE="-"+cf.convertMinutesToHHMMSSFormat(-rs.getInt("transitDelay"));
				
				cell=row.createCell(++rowCount); // 22 TRANSIT DELAY
				if(rs.getString("STATUS").contains("OPEN")){
					String td=getTransitDealy(tripStatus, ETA, STA_ON_ATD);	
					cell.setCellValue(td);
				}else{
					if(rs.getInt("transitDelay")<0){					
						cell.setCellValue(delayE);
						
					}else{
						cell.setCellValue(delayS);
					}
				}
					

//				String delayS=cf.convertMinutesToHHMMSSFormat(rs.getInt("transitDelay"));
//				String delayE="-"+cf.convertMinutesToHHMMSSFormat(-rs.getInt("transitDelay"));
//				Cell dateCellDelay = row.createCell(++rowCount);
//				if(rs.getInt("transitDelay")<0){
//					dateCellDelay.setCellValue(delayE);
//					dateCellDelay.setCellStyle(timeCellStyle);
//				}else{
//					dateCellDelay.setCellValue(delayS);
//					dateCellDelay.setCellStyle(timeCellStyle);
//				}
				//trip status
				cell=row.createCell(++rowCount);
				if(rs.getString("STATUS").equalsIgnoreCase("")||rs.getString("STATUS").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("STATUS"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("STATUS"));
				}
				
				//reason for delay
				cell=row.createCell(++rowCount);
					if(rs.getString("REASON").equalsIgnoreCase("")||rs.getString("REASON").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("REASON"));
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("REASON"));
					}	
				//Trip Distance (<%=unit%>)
				distance = rs.getDouble("TOTAL_DISTANCE");
				if(unit.equals("Miles")){
					distance = rs.getDouble("TOTAL_DISTANCE") * 0.621371; 
				}
				Cell dateCell31 = row.createCell(++rowCount);
				dateCell31.setCellValue(Double.valueOf(df.format(distance)));
				dateCell31.setCellStyle(decimalStyle);
				
				double avgSpped=rs.getDouble("AVG_SPEED");
				if(unit.equals("Miles")){
					avgSpped = rs.getDouble("AVG_SPEED") * 0.621371; 
				}
				
				Cell dateCell29 = row.createCell(++rowCount);
				dateCell29.setCellValue(Double.valueOf(df.format(avgSpped)));
				dateCell29.setCellStyle(decimalStyle);
				//row.createCell(34).setCellValue(custD);
				
				
				//jsonobject.put("weather", "");
				if(!rs.getString("endDate1").contains("1900")){
					endDate = mmddyyy.format(sdfDB.parse(rs.getString("endDate1")));
				}
				//	String RouteId=rs.getString("ROUTE_ID");
				
				if(endDate.equals("") || endDate.equalsIgnoreCase("NA")){
					Cell dateCell36 = row.createCell(++rowCount);
					dateCell36.setCellValue(endDate);
					dateCell36.setCellStyle(blankOrNAStyle);
				}else{
					Cell dateCell36 = row.createCell(++rowCount);
					dateCell36.setCellValue(endDate);
					dateCell36.setCellStyle(timeCellStyle);
				}
				
				
	              //remakrs
				cell=row.createCell(++rowCount);
				if(rs.getString("CANCELLED_REMARKS").equalsIgnoreCase("")||rs.getString("CANCELLED_REMARKS").equalsIgnoreCase("NA")){
					cell.setCellValue(rs.getString("CANCELLED_REMARKS"));
					cell.setCellStyle(blankOrNAStyle);
				}else{
					cell.setCellValue(rs.getString("CANCELLED_REMARKS"));
				}
				
				
				
				//destination hub(Unloading) Detention(HH:mm)
				if(rs.getInt("UNLOADING_DETENTION")<0){
					unloadingD="-"+cf.convertMinutesToHHMMSSFormat(-rs.getInt("UNLOADING_DETENTION"));
				}else{
					unloadingD=cf.convertMinutesToHHMMSSFormat(rs.getInt("UNLOADING_DETENTION"));
				}
				Cell dateCell35 = row.createCell(++rowCount);
				if(unloadingD.equalsIgnoreCase("")||unloadingD.equalsIgnoreCase("NA")){
					dateCell35.setCellValue(unloadingD);
					dateCell35.setCellStyle(blankOrNAStyle);
				}else{
					dateCell35.setCellValue(unloadingD);
					dateCell35.setCellStyle(timeCellStyle);
				}
				
				
				
				
				
				
				
			/*
				//Unplanned Stoppage Time(HH:mm)
				Cell unplannedStoppage = row.createCell(++rowCount);
				if(rs.getString("UNSCHEDULED_STOP_DUR")== null || rs.getString("UNSCHEDULED_STOP_DUR").equals("") 
						|| rs.getInt("UNSCHEDULED_STOP_DUR") <0){
					unplannedStoppage.setCellValue("00:00:00");
					//unplannedStoppage.setCellStyle(blankOrNAStyle);
				}else{
					unplannedStoppage.setCellValue(cf.convertMinutesToHHMMSSFormat(rs.getInt("UNSCHEDULED_STOP_DUR")));//new field
				}
				//Total Truck Running Time(HH:mm)
				Cell totalTruckRunningTime = row.createCell(++rowCount);
				if(rs.getString("totalTruckRunningTime")== null || rs.getString("totalTruckRunningTime").equals("")){
					totalTruckRunningTime.setCellValue("");
					totalTruckRunningTime.setCellStyle(blankOrNAStyle);
				}else{
					totalTruckRunningTime.setCellValue(cf.convertMinutesToHHMMSSFormat(rs.getInt("totalTruckRunningTime")));//New field
				}
				
				
				
				
				
				//row.createCell(37).setCellValue(mmddyyy.parse(endDate));
				
				row.createCell(++rowCount).setCellValue(rs.getInt("PANIC_COUNT"));
				row.createCell(++rowCount).setCellValue(rs.getInt("DOOR_COUNT"));
				row.createCell(++rowCount).setCellValue(rs.getInt("NON_REPORTING_COUNT"));
				
				
				if(rs.getString("TEMP_REEFER_PERCENT") != null && !rs.getString("TEMP_REEFER_PERCENT").equals("0.00")){
					row.createCell(++rowCount).setCellValue(rs.getString("TEMP_REEFER_PERCENT"));
				}else{
					row.createCell(++rowCount).setCellValue("");
				}
				if(rs.getString("TEMP_MIDDLE_PERCENT") != null && !rs.getString("TEMP_MIDDLE_PERCENT").equals("0.00")){
					row.createCell(++rowCount).setCellValue(rs.getString("TEMP_MIDDLE_PERCENT"));
				}else{
					row.createCell(++rowCount).setCellValue("");
				}
				if(rs.getString("TEMP_DOOR_PERCENT") != null && !rs.getString("TEMP_DOOR_PERCENT").equals("0.00")){
					row.createCell(++rowCount).setCellValue(rs.getString("TEMP_DOOR_PERCENT"));
				}else{
					row.createCell(++rowCount).setCellValue("");
				}*/
				
				String LAST_COMMUNICATION_STAMP="";
				if(!rs.getString("LAST_COMMUNICATION_STAMP").contains("1900")){					
					LAST_COMMUNICATION_STAMP = mmddyyy.format(sdfDB.parse(rs.getString("LAST_COMMUNICATION_STAMP")));
				}
				
				Cell dateCell21 = row.createCell(++rowCount);
				if(LAST_COMMUNICATION_STAMP.equalsIgnoreCase("")||LAST_COMMUNICATION_STAMP.equalsIgnoreCase("NA")){
					dateCell21.setCellValue(LAST_COMMUNICATION_STAMP);
					dateCell21.setCellStyle(blankOrNAStyle);
				}else{
					dateCell21.setCellValue(LAST_COMMUNICATION_STAMP);
					dateCell21.setCellStyle(timeCellStyle);
				}
			}
			FileOutputStream fileOut = new FileOutputStream(completePath);
	        workbook.write(fileOut);
	        fileOut.flush();
	        fileOut.close();
	       // ((FileOutputStream) workbook).close();
	        
	      /*  File tmpDir = new File("c://logs/SlaDashBoard"+userId+".xls");
	        boolean exists = tmpDir.exists();
	        if(exists){
	        	message="SlaDashBoard"+userId+".xls";
	        }*/
	        
		} catch (Exception e) {
			e.printStackTrace();
			message="Failed to Download Report";
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}
		return completePath;
	}
	public String dashCustExportData(int systemId, int clientId, int offset, String groupId, String unit,int userId,
			String custId,String routeId,String tripStatus, String startDateRange, String endDateRange,String zone){
		
		 String message="";
			Connection con = null;
			PreparedStatement pstmt = null,pstmt1 = null;
			ResultSet rs = null,rs1 = null;
			int count = 0;
			int rowCount = 0;
			String condition = "";
			double distance = 0;
			double distanceNext = 0;
			String endDate = "";
			String tripStr="",tripStrs="";
			String Delay="";
			Properties prop = ApplicationListener.prop;
			int allowedDetention = Integer.parseInt(prop.getProperty("AllowedDetention"));
			String loadingD="";
			String unloadingD="";
			String custD="";
			String completePath=null;
			String custType=null;
			String tripType=null;
			
			try {
				
				String customername="DHL";
				Properties properties = ApplicationListener.prop;
				String rootPath =  properties.getProperty("slaDashBoardExcelExport");
				System.out.println(" Root Path :: "+rootPath);
				//String rootPath ="C:\\LegDetailsExcel";
				completePath = rootPath + "//" +customername+"_"+ Calendar.getInstance().getTimeInMillis()+ ".xls";
				
				File f = new File(rootPath);
				if (!f.exists()) {
					f.mkdir();
				}

				// Create a Workbook
		        Workbook workbook = new HSSFWorkbook(); //new XSSFWorkbook() for generating `.xls` file

		        /* CreationHelper helps us create instances of various things like DataFormat, 
		           Hyperlink, RichTextString etc, in a format (HSSF, XSSF) independent way */
		        CreationHelper createHelper = workbook.getCreationHelper();

		        // Create a Sheet
		        Sheet sheet = workbook.createSheet("SLA Dashboard");

		        // Create a Font for styling header cells
		        Font headerFont = workbook.createFont();
		       // headerFont.setBoldweight(); //.setBoldweight(true);
		        headerFont.setFontHeightInPoints((short) 12);
		        headerFont.setColor(IndexedColors.BLUE.getIndex());

		        // Create a CellStyle with the font
		        CellStyle headerCellStyle = workbook.createCellStyle();
		        headerCellStyle.setFont(headerFont);

		        // Create a Row
		        Row headerRow = sheet.createRow(0);

		        // Create cells
		        for(int i = 0; i < custColumns.length; i++) {
		            Cell cell = headerRow.createCell(i);
		            cell.setCellValue(custColumns[i]);
		            cell.setCellStyle(headerCellStyle);
		        }

		        // Create Cell Style for formatting Date
		        CellStyle dateCellStyle = workbook.createCellStyle();
		        dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy HH:mm:ss"));

		        CellStyle timeCellStyle = workbook.createCellStyle();
		        DataFormat fmt = workbook.createDataFormat();
		        timeCellStyle.setDataFormat( fmt.getFormat("@"));
		        
		        Font redFont = workbook.createFont();
		        redFont.setColor(IndexedColors.RED.getIndex());
		        CellStyle redFontStyle = workbook.createCellStyle();
		        redFontStyle.setFont(redFont);
		        
		        Font greenFont = workbook.createFont();
		        greenFont.setColor(IndexedColors.GREEN.getIndex());
		        CellStyle greenFontStyle = workbook.createCellStyle();
		        greenFontStyle.setFont(greenFont);
		        
		        CellStyle decimalStyle = workbook.createCellStyle();
		        decimalStyle.setAlignment(CellStyle.ALIGN_RIGHT);
		        decimalStyle.setDataFormat(fmt.getFormat("0.00"));
		       
		        CellStyle blankOrNAStyle = workbook.createCellStyle();
				blankOrNAStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
				blankOrNAStyle.setFillPattern(CellStyle.SOLID_FOREGROUND); 
		        
		        int rowNum = 1;
		        
		        con = DBConnection.getConnectionToDB("AMS");
				String groupBy = " group by CUSTOMER_REF_ID,NEXT_POINT_DISTANCE,AVG_SPEED,STOPPAGE_DURATION,td.ROUTE_ID,td.TRIP_ID,td.SHIPMENT_ID,td.ASSET_NUMBER,td.CUSTOMER_NAME,td.DEST_ARR_TIME_ON_ATD,"
					+ "	 gps.DRIVER_NAME,gps.DRIVER_MOBILE,gps.LOCATION,NEXT_POINT,td.TRIP_START_TIME,td.ACTUAL_TRIP_START_TIME,td.NEXT_POINT_ETA,td.DESTINATION_ETA,ds.PLANNED_ARR_DATETIME,"
					+ "	 td.ACTUAL_DISTANCE,ds1.NAME,ds.NAME,td.STATUS,td.TRIP_STATUS,td.DELAY,ACTUAL_TRIP_END_TIME,ds.PLANNED_ARR_DATETIME,DESTINATION_ETA,ACTUAL_TRIP_START_TIME,ACT_SRC_ARR_DATETIME,"
					+ "	 ORDER_ID,vm.ModelName,td.ROUTE_NAME,ds1.PLANNED_ARR_DATETIME,ds1.ACT_ARR_DATETIME,ds.ACT_ARR_DATETIME,td.ACTUAL_DISTANCE,ds.ACT_DEP_DATETIME,"
					+ "	 td.FUEL_CONSUMED,td.MILEAGE,td.OBD_MILEAGE,td.NEXT_LEG,td.NEXT_LEG_ETA,ll0.HUB_CITY, ll1.HUB_CITY, ll0.HUB_STATE, ll1.HUB_STATE, u.Firstname,u.Lastname,vm.VehType,td.REMARKS," +
							"td.PRODUCT_LINE,td.TRIP_CATEGORY,trd.ROUTE_KEY,UNSCHEDULED_STOP_DUR,PLANNED_DURATION,ds1.DISTANCE_FLAG,ds1.DETENTION_TIME,ds.DETENTION_TIME,td.END_LOCATION,RED_DUR_T1,RED_DUR_T2,RED_DUR_T3,DISTANCE_TRAVELLED " +
							" ,td.INSERTED_TIME,c.VehicleType,ACTUAL_DURATION,trd.TAT, rd.TRAVEL_TIME,custd.CUSTOMER_REFERENCE_ID, gps.GMT,td.TRIP_CUSTOMER_TYPE";
				
				String eventStrHubDetention=" and td.TRIP_ID in (select distinct TRIP_ID from DES_TRIP_DETAILS where  ACT_ARR_DATETIME is not null and SEQUENCE not in (0,100) and ACT_DEP_DATETIME is null "+  
				" and datediff(mi,ACT_ARR_DATETIME,isnull(ACT_DEP_DATETIME,getutcdate()))>isnull(DETENTION_TIME,0))";
				String eventQueryStoppage=" and td.TRIP_ID in (select distinct TRIP_ID from TRIP_EVENT_DETAILS where ALERT_TYPE=1) and gps.CATEGORY='stoppage' ";
				String eventQueryroutedEviation="and td.TRIP_ID in (select distinct TRIP_ID from TRIP_EVENT_DETAILS a where ALERT_TYPE=5 and TRIP_ID not in (select TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=td.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT))";
				String eventQuerydelayedLateDeparture=" and td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and ds.SEQUENCE=100 and (ACTUAL_TRIP_START_TIME>td.TRIP_START_TIME and (DATEDIFF(mi,isnull(td.DEST_ARR_TIME_ON_ATD,ds.PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,td.TRIP_START_TIME,ACTUAL_TRIP_START_TIME)))";
				String additionalconditionfordelay=" and td.TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+ 
					" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+  
					" and (ACTUAL_TRIP_START_TIME>td.TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,td.TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) ";

				if(groupId.equals("0")){
					condition = "and td.STATUS='OPEN'";
				}else if(groupId.equals("1")){
					condition = "and td.TRIP_START_TIME between dateadd(dd,-2,getutcdate()) and getutcdate()";
				}else if(groupId.equals("2")){
					condition = "and td.TRIP_START_TIME between dateadd(dd,-7,getutcdate()) and getutcdate()";
				}else if(groupId.equals("3")){
					condition = "and td.TRIP_START_TIME between dateadd(dd,-15,getutcdate()) and getutcdate()";
				}else if(groupId.equals("4")){
					condition = "and td.TRIP_START_TIME between dateadd(dd,-30,getutcdate()) and getutcdate()";
				}else if(groupId.equals("5")){
					condition = "and td.TRIP_START_TIME between dateadd(mi,-330,'"+startDateRange+" 00:00:00') and dateadd(mi,-330,'"+endDateRange+" 23:59:59')";
				}
				
				
				//Dhl BlueDart start table
				 if (tripStatus.equalsIgnoreCase("delayedonetotwohour")) {
						Delay = "True";
						tripStatus = "DELAYED";
						tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'"
								+ " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120 "
								+ additionalconditionfordelay;
					} else  if (tripStatus.equalsIgnoreCase("delayedtwotothreehour")) {
						Delay = "True";
						tripStatus = "DELAYED";
						tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'"
								+ " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 "
								+ additionalconditionfordelay;
					} else  if (tripStatus.equalsIgnoreCase("delayedthreetofivehour")) {
						Delay = "True";
						tripStatus = "DELAYED";
						tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'"
								+ " and isnull(DELAY,0)>180 and isnull(DELAY,0)<300 "
								+ additionalconditionfordelay;
					} else   if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour")) {
						Delay = "True";
						tripStatus = "DELAYED";
						tripStr = "and td.TRIP_STATUS = '" + tripStatus + "'"
								+ " and isnull(DELAY,0)>300 "
								+ additionalconditionfordelay;
					} else ////////////
						 if (tripStatus.equalsIgnoreCase("delayedonetotwohour-deviation")) {
								Delay = "";
								tripStatus = "DELAYED";
								tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
										+ " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120 "
										+ additionalconditionfordelay + eventQueryroutedEviation;
							} else if (tripStatus.equalsIgnoreCase("delayedonetotwohour-stoppage")) {
								Delay = "";
								tripStatus = "DELAYED";
								tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
										+ " and isnull(DELAY,0)>60 and isnull(DELAY,0)<120"
										+ additionalconditionfordelay + eventQueryStoppage;
							} else  if (tripStatus.equalsIgnoreCase("delayedtwotothreehour-deviation")) {
								Delay = "";
								tripStatus = "DELAYED";
								tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
										+ " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 "
										+ additionalconditionfordelay + eventQueryroutedEviation;
							} else if (tripStatus.equalsIgnoreCase("delayedtwotothreehour-stoppage")) {
								Delay = "";
								tripStatus = "DELAYED";
								tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
										+ " and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 "
										+ additionalconditionfordelay + eventQueryStoppage;
							} else if(tripStatus.equalsIgnoreCase("delayedthreetofivehour-deviation")) {
								Delay = "";
								tripStatus = "DELAYED";
								tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
										+ " and isnull(DELAY,0)>180  and isnull(DELAY,0)<300"
										+ additionalconditionfordelay
										+ eventQueryroutedEviation;
							}	else if (tripStatus.equalsIgnoreCase("delayedthreetofivehour-stoppage")) {
								Delay = "";
								tripStatus = "DELAYED";
								tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
										+ " and isnull(DELAY,0)>180 and isnull(DELAY,0)<300"
										+ additionalconditionfordelay + eventQueryStoppage;
							} else  if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour-deviation")) {
								Delay = "";
								tripStatus = "DELAYED";
								tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
										+ " and isnull(DELAY,0)>300 "
										+ additionalconditionfordelay + eventQueryroutedEviation;
							} else if (tripStatus.equalsIgnoreCase("delayedmorethanfivehour-stoppage")) {
								Delay = "";
								tripStatus = "DELAYED";
								tripStr = " and td.TRIP_STATUS = '" + tripStatus + "'"
										+ " and isnull(DELAY,0)>300"
										+ additionalconditionfordelay + eventQueryStoppage;
							} else 
					
				//Dhl bluedart end table
				if(tripStatus.equalsIgnoreCase("enrouteId")){
					Delay ="";
					tripStatus="ENROUTE PLACEMENT%";
					tripStr="and TRIP_STATUS like '"+ tripStatus+"'";
				}
				else if (tripStatus.equalsIgnoreCase("onTimeId")){
					Delay ="";
					tripStatus="ON TIME";
					tripStr="and TRIP_STATUS = '"+ tripStatus+"'";
				}
				else if (tripStatus.equalsIgnoreCase("delayedless1")){
					Delay="True";
					tripStatus="DELAYED";
					tripStr="and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)<60 "+additionalconditionfordelay ;
				}
				else if (tripStatus.equalsIgnoreCase("delayedgreater1")){
					Delay="True";
					tripStatus="DELAYED";
					tripStr="and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)>60 "+additionalconditionfordelay ;
				}
				else if (tripStatus.equalsIgnoreCase("enrouteId-Ontime")){
					Delay ="";
					tripStatus="ENROUTE PLACEMENT ON TIME";
					tripStr="and TRIP_STATUS = '"+ tripStatus+"'";
				}
				else if (tripStatus.equalsIgnoreCase("enrouteId-delay")){
					Delay ="";
					tripStatus="ENROUTE PLACEMENT DELAYED";
					tripStr="and TRIP_STATUS = '"+ tripStatus+"'";
				}
				else if (tripStatus.equalsIgnoreCase("loading-detention")){
					Delay ="";
					tripStatus="LOADING DETENTION";
					tripStr="and TRIP_STATUS = '"+ tripStatus+"'";
				}
				else if (tripStatus.equalsIgnoreCase("unloading-detention")){
					Delay ="";
					tripStatus="UNLOADING DETENTION";
					tripStr="and TRIP_STATUS = '"+ tripStatus+"'";
				}	
				else if (tripStatus.equalsIgnoreCase("delay-late-departure")){
					Delay ="True";
					tripStatus="DELAYED LATE DEPARTURE";
					tripStrs=" "+eventQuerydelayedLateDeparture;
				}	//EVENT QUERIES
				//ONTIME
				else if (tripStatus.equalsIgnoreCase("onTimeId-hubhetention")){
					Delay ="";
					tripStatus="ON TIME";
					tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+eventStrHubDetention;
				}
				else if (tripStatus.equalsIgnoreCase("onTimeId-stoppage")){
					Delay ="";
					tripStatus="ON TIME";
					tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+eventQueryStoppage;  
				}
				else if (tripStatus.equalsIgnoreCase("onTimeId-deviation")){
					Delay ="";
					tripStatus="ON TIME";
					tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+eventQueryroutedEviation;  
				}
				//DELAYED<1HR
				else if (tripStatus.equalsIgnoreCase("delayedless1-detention")){
					Delay ="";
					tripStatus="DELAYED";
					tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)<60"+additionalconditionfordelay + eventStrHubDetention;
				}
				else if (tripStatus.equalsIgnoreCase("delayedless1-stoppage")){
					Delay ="";
					tripStatus="DELAYED";
					tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)<60"+additionalconditionfordelay + eventQueryStoppage; 
				}
				else if (tripStatus.equalsIgnoreCase("delayedless1-deviation")){
					Delay ="";
					tripStatus="DELAYED";
					tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)<60"+additionalconditionfordelay + eventQueryroutedEviation;
				}
				//DELAYED>1HR
				else if (tripStatus.equalsIgnoreCase("delayedgreater1-detention")){
					Delay ="";
					tripStatus="DELAYED";
					tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)>60"+additionalconditionfordelay + eventStrHubDetention;
				}
				else if (tripStatus.equalsIgnoreCase("delayedgreater1-stoppage")){
					Delay ="";
					tripStatus="DELAYED";
					tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)>60"+additionalconditionfordelay + eventQueryStoppage;
				}
				else if (tripStatus.equalsIgnoreCase("delayedgreater1-deviation")){
					Delay ="";
					tripStatus="DELAYED";
					tripStr=" and TRIP_STATUS = '"+ tripStatus+"'"+"and isnull(DELAY,0)>60"+additionalconditionfordelay + eventQueryroutedEviation;
				}
				else{
					Delay ="";
					tripStr="and td.TRIP_STATUS <> 'NEW'";
				}
				String stmt="";
				
				if(tripStatus.equalsIgnoreCase("DELAYED") && Delay.equalsIgnoreCase("True")){
					//System.out.println("i am in 1 ");
					stmt=GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL_DELAY.replace("&", condition).concat(tripStr).replaceAll("330",""+offset).replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone);
					}else if (tripStatus.equalsIgnoreCase("DELAYED LATE DEPARTURE")){
					//	System.out.println("i am in 2");
						stmt=GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL.replace("&", condition).concat(tripStr).concat(tripStrs).replaceAll("330",""+offset).replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone);
					//	stmt=stmt.replace("td.TRIP_STATUS,", "'DELAYED LATE DEPARTURE' as TRIP_STATUS,");
					}else {
						//System.out.println("i am in 3");
						stmt=GeneralVerticalStatements.GET_TRIP_SUMMARY_DETAILS_DHL.replace("&", condition).concat(tripStr).replaceAll("330",""+offset).replaceAll("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+zone);
					}
					
					
					
				if(routeId.equals("ALL")){
					stmt = stmt.replace("#", "");
				}else{
					stmt=stmt.replace("#", "and td.ROUTE_ID="+routeId);
				}
				
				
				//dhl bluedart req
				if(custType == null){
					stmt = stmt.replace("custTypeCondition", "");
				}
				if(tripType == null){
					stmt = stmt.replace("tripTypeCondition", "");
				}
//				if(custName.equals("ALL")){
//					stmt = stmt.replace("$", "");
//				}else{
//					stmt=stmt.replace("$","and CUSTOMER_NAME='"+custName+"'");
//				}
				if(custId.equals("ALL")){
					stmt = stmt.replace("$", "");
				}else{
					stmt=stmt.replace("$","and td.TRIP_CUSTOMER_ID='"+custId+"'");
				}
				pstmt=con.prepareStatement(stmt+ " "+groupBy+" order by td.TRIP_ID desc");
				//System.out.println("getTripSummaryDetailsDHL :"+stmt+ " "+groupBy+" order by td.TRIP_ID desc" );
				pstmt.setInt(1,offset);
				pstmt.setInt(2,offset);
				pstmt.setInt(3,offset);
				pstmt.setInt(4,offset);
				pstmt.setInt(5,offset);
				pstmt.setInt(6,offset);
				pstmt.setInt(7,offset);
				pstmt.setInt(8, allowedDetention);
				pstmt.setInt(9,offset);
				pstmt.setInt(10,offset);
				pstmt.setInt(11,offset);
				//pstmt.setInt(12, allowedDetention);
				pstmt.setInt(12, offset);
				pstmt.setInt(13,offset);
				pstmt.setInt(14,offset);
				pstmt.setInt(15,offset);
				pstmt.setInt(16, systemId);
				pstmt.setInt(17, clientId);
				rs = pstmt.executeQuery();
				
				while(rs.next())
				{
					endDate = "";
					count++;
					String STD="";
					if(!rs.getString("STD").contains("1900")){
					//	STD = sdf.format(sdfDB.parse(rs.getString("STD")));
						STD = mmddyyy.format(sdfDB.parse(rs.getString("STD")));					
					}
					String ATD="";
					if(!rs.getString("ATD").contains("1900")){					
						ATD = mmddyyy.format(sdfDB.parse(rs.getString("ATD")));
					}
					String ETHA="";
					if(!rs.getString("ETHA").contains("1900")){
						ETHA = mmddyyy.format(sdfDB.parse(rs.getString("ETHA")));
					}
					String ETA="";
					if(!rs.getString("ETA").contains("1900")){
						ETA = mmddyyy.format(sdfDB.parse(rs.getString("ETA")));
					}
					String STA="";
					if(!rs.getString("STA").contains("1900")){
						STA = mmddyyy.format(sdfDB.parse(rs.getString("STA")));
					}
					String STA_ON_ATD=STA;
					if(!rs.getString("STA_ON_ATD").contains("1900")){
						STA_ON_ATD = mmddyyy.format(sdfDB.parse(rs.getString("STA_ON_ATD")));
					}
					
					String ATP="";
					if(!rs.getString("ATP").contains("1900")){
						ATP = mmddyyy.format(sdfDB.parse(rs.getString("ATP")));
					}
					
					String STP="";
					if(!rs.getString("STP").contains("1900")){
						STP = mmddyyy.format(sdfDB.parse(rs.getString("STP")));
					}
					
					String ATA="";
					if(!rs.getString("ATA").contains("1900")){
						ATA = mmddyyy.format(sdfDB.parse(rs.getString("ATA")));
					}
					int tripNO=Integer.parseInt(rs.getString("TRIP_NO"));
					
					Row row = sheet.createRow(rowNum++);  //1 sLNO
					rowCount =0;
					row.createCell(rowCount).setCellValue(count);  
					
					Cell cell=row.createCell(++rowCount);  // 2 TRIP ID
					if(rs.getString("TRIP_ID").equalsIgnoreCase("")||rs.getString("TRIP_ID").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("TRIP_ID"));
						cell.setCellStyle(blankOrNAStyle);
					}
					else
					{
						cell.setCellValue(rs.getString("TRIP_ID")); 
					}
			
					cell=row.createCell(++rowCount);  // 3 TRIP NO
					
					if(rs.getString("LR_NO").equalsIgnoreCase("")||rs.getString("LR_NO").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("LR_NO"));
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("LR_NO"));  
					}
					
					cell=row.createCell(++rowCount);  // 4 TRIP NO
					
					if(rs.getString("PRODUCT_LINE").equalsIgnoreCase("")||rs.getString("PRODUCT_LINE").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("PRODUCT_LINE"));
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("PRODUCT_LINE"));  
					}
			
					cell=row.createCell(++rowCount); // 5 GAADI NUMBER
					if(rs.getString("VEHICLE_NO").equalsIgnoreCase("")||rs.getString("VEHICLE_NO").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("VEHICLE_NO"));
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("VEHICLE_NO"));
					}
					cell=row.createCell(++rowCount); // 6 CUSTOMER
					if(rs.getString("CUSTOMER_NAME").equalsIgnoreCase("")||rs.getString("CUSTOMER_NAME").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("CUSTOMER_NAME"));
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("CUSTOMER_NAME"));
					}	
					
					cell=row.createCell(++rowCount); // 7 CUST REF
					if(rs.getString("CUSTOMER_REF_ID").equalsIgnoreCase("")||rs.getString("CUSTOMER_REF_ID").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("CUSTOMER_REF_ID"));
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("CUSTOMER_REF_ID"));
					}
					
					cell=row.createCell(++rowCount); //8 LOC
					if(rs.getString("LOCATION").equalsIgnoreCase("")||rs.getString("LOCATION").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("LOCATION"));
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("LOCATION"));
					}
					
					cell=row.createCell(++rowCount); //9 ROUTE KEY 
					if(rs.getString("RouteKey").equalsIgnoreCase("")||rs.getString("RouteKey").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("RouteKey"));
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("RouteKey"));
					}
					
					cell=row.createCell(++rowCount); // 10 ORIGIN CITY
					if(rs.getString("OriginCity").equalsIgnoreCase("")||rs.getString("OriginCity").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("OriginCity"));
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("OriginCity"));
					}
					
					cell=row.createCell(++rowCount); //11 DESTINATION CITY
					if(rs.getString("DestinationCity").equalsIgnoreCase("")||rs.getString("DestinationCity").equalsIgnoreCase("NA")){
						cell.setCellValue(rs.getString("DestinationCity"));
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("DestinationCity"));
					}
					
					cell=row.createCell(++rowCount); // 12 STP
					if(STP.equalsIgnoreCase("")||STP.equalsIgnoreCase("NA")){
						cell.setCellValue(STP);
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(STP);
					}
					
					cell=row.createCell(++rowCount); //13 ATP
					if(ATP.equalsIgnoreCase("")||ATP.equalsIgnoreCase("NA")){
						cell.setCellValue(ATP);
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(ATP);
					}
					
					cell=row.createCell(++rowCount); // 14 PACEMENT DELAY
					if(rs.getInt("PLACEMENT_DELAY")<0){
						cell.setCellValue("-"+cf.convertMinutesToHHMMSSFormat(-rs.getInt("PLACEMENT_DELAY")));
					}else{
						cell.setCellValue(cf.convertMinutesToHHMMSSFormat(rs.getInt("PLACEMENT_DELAY")));
					}
					
					cell=row.createCell(++rowCount); // 15 STD
					if(STD.equalsIgnoreCase("")||STD.equalsIgnoreCase("NA")){
						cell.setCellValue(STD);
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(STD);
					}
					
					cell=row.createCell(++rowCount); // 16 ATD
					if(ATD.equalsIgnoreCase("")||ATD.equalsIgnoreCase("NA")){
						cell.setCellValue(ATD);
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(ATD);
					}
					
					cell=row.createCell(++rowCount); //17 DELAY DEP
					if(rs.getString("delayedDepartureATD_STD") !=	 null && !rs.getString("delayedDepartureATD_STD").equals("")){
						if(rs.getInt("delayedDepartureATD_STD") < 0){
							cell.setCellValue("-"+cf.convertMinutesToHHMMSSFormat(-Integer.parseInt(rs.getString("delayedDepartureATD_STD"))));
						}
						else{	
							cell.setCellValue(cf.convertMinutesToHHMMSSFormat(Integer.parseInt(rs.getString("delayedDepartureATD_STD"))));
						}
					}else{
						cell.setCellValue("");
						cell.setCellStyle(blankOrNAStyle);
					}
					
					cell=row.createCell(++rowCount); //18 STA_ON_ATD
					if(STA_ON_ATD.equalsIgnoreCase("")||STA_ON_ATD.equalsIgnoreCase("NA")){
						cell.setCellValue(STA_ON_ATD);
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(STA_ON_ATD);
					}

					cell=row.createCell(++rowCount); //19 ETA
					if(ETA.equalsIgnoreCase("")||ETA.equalsIgnoreCase("NA")){
						cell.setCellValue(ETA);
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(ETA);
					}
					
					cell=row.createCell(++rowCount); //20 ATA
					if(ATA.equalsIgnoreCase("")||ATA.equalsIgnoreCase("NA")){
						cell.setCellValue(ATA);
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(ATA);
					}
					
					cell=row.createCell(++rowCount);  // 21 STOP DUR
					/*if(rs.getString("UNSCHEDULED_STOP_DUR")== null || rs.getString("UNSCHEDULED_STOP_DUR").equals("")){
						cell.setCellValue("NA");
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(cf.convertMinutesToHHMMSSFormat(rs.getInt("UNSCHEDULED_STOP_DUR")));
					}*/
					Integer totalTripTimeATAATD = 0;
					if((!ATA.equals("")) &&( !ATD.equals(""))){
						 totalTripTimeATAATD = rs.getInt("TOTAL_TRIP_TIME_ATA_ATD");
						 totalTripTimeATAATD  = totalTripTimeATAATD < 0 ? 0: totalTripTimeATAATD;
					}	
					cell.setCellValue(cf.convertMinutesToHHMMSSFormat(totalTripTimeATAATD));
					
					String delayS=cf.convertMinutesToHHMMSSFormat(rs.getInt("transitDelay"));
					String delayE="-"+cf.convertMinutesToHHMMSSFormat(-rs.getInt("transitDelay"));
					
					cell=row.createCell(++rowCount); // 22 TRANSIT DELAY
					if(rs.getString("STATUS").contains("OPEN")){
						String td=getTransitDealy(tripStatus, ETA, STA_ON_ATD);	
						cell.setCellValue(td);
					}else{
						if(rs.getInt("transitDelay")<0){					
							cell.setCellValue(delayE);
							
						}else{
							cell.setCellValue(delayS);
						}
					}
				
					
					
					
					cell=row.createCell(++rowCount); // 23 STATUS
					if(rs.getString("STATUS")== null || rs.getString("STATUS").equals("")){
						cell.setCellValue("NA");
						cell.setCellStyle(blankOrNAStyle);
					}else{
						cell.setCellValue(rs.getString("STATUS"));
					}
					
					cell=row.createCell(++rowCount); // 24 
					if(rs.getString("CUSTOMER_REASON").equalsIgnoreCase("")||rs.getString("CUSTOMER_REASON").equalsIgnoreCase("NA"))
					{
						cell.setCellValue(rs.getString("CUSTOMER_REASON"));
						cell.setCellStyle(blankOrNAStyle);
					}
					else
					{
						cell.setCellValue(rs.getString("CUSTOMER_REASON"));
					}
					
					cell=row.createCell(++rowCount); // 25
					if(rs.getString("CANCELLED_REMARKS").equalsIgnoreCase("")||rs.getString("CANCELLED_REMARKS").equalsIgnoreCase("NA"))
					{
						cell.setCellValue(rs.getString("CANCELLED_REMARKS"));
						cell.setCellStyle(blankOrNAStyle);
					}else
					{
						cell.setCellValue(rs.getString("CANCELLED_REMARKS"));
					}
					
					String LAST_COMMUNICATION_STAMP="";
					if(!rs.getString("LAST_COMMUNICATION_STAMP").contains("1900")){					
						LAST_COMMUNICATION_STAMP = mmddyyy.format(sdfDB.parse(rs.getString("LAST_COMMUNICATION_STAMP")));
					}
					
					Cell dateCell21 = row.createCell(++rowCount);
					if(LAST_COMMUNICATION_STAMP.equalsIgnoreCase("")||LAST_COMMUNICATION_STAMP.equalsIgnoreCase("NA")){
						dateCell21.setCellValue(LAST_COMMUNICATION_STAMP);
						dateCell21.setCellStyle(blankOrNAStyle);
					}else{
						dateCell21.setCellValue(LAST_COMMUNICATION_STAMP);
						dateCell21.setCellStyle(timeCellStyle);
					}
					
					
						if(rs.getString("LAST_COMMUNICATION_STAMP").equalsIgnoreCase("")||rs.getString("LAST_COMMUNICATION_STAMP").contains("1900"))
						{
							cell.setCellValue(rs.getString("LAST_COMMUNICATION_STAMP"));
							cell.setCellStyle(blankOrNAStyle);
						}else
						{
							cell.setCellValue(rs.getString("LAST_COMMUNICATION_STAMP"));
						}
					//}
				}
				FileOutputStream fileOut = new FileOutputStream(completePath);
		        workbook.write(fileOut);
		        fileOut.flush();
		        fileOut.close();
			}
			catch(Exception e){
				e.printStackTrace();
				message="Failed to Download Report";
			}
			finally{
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
				DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
			}
			return completePath;
	}
	
	public String getTransitDealy(String tripStatus,String eta,String staonata){
		try {
			
			if(eta.equals("") || staonata.equals("")){
				return "";
			}else{
				return getFormattedHoursMinutes(eta,staonata);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
		
		
	}
	
	public  String getFormattedHoursMinutes(String date1,String date2) {
		String hhmmssformat="";
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		Date d1 = null;
		Date d2 = null;
		String Timeformat="";
		boolean negative=false;
		try {
			d1 = format.parse(date1);
			d2 = format.parse(date2);

			//in milliseconds
			long diff = d1.getTime() - d2.getTime();


			long diffSeconds = diff / 1000 % 60;
			long diffMinutes = diff / (60 * 1000) % 60;
			long diffHours = diff / (60 * 60 * 1000);
			hhmmssformat=df3.format(diffHours)+":"+df3.format(diffMinutes)+":"+df3.format(diffSeconds);
			negative = hhmmssformat.contains("-")?true:false;
			Timeformat=negative?"-"+hhmmssformat.replaceAll("-", ""):hhmmssformat;
		} catch (Exception e) {
			System.out.println("hh:mm:ss exception :::::   "+e.getLocalizedMessage());
			e.printStackTrace();

		}
		return Timeformat;

	}
}
