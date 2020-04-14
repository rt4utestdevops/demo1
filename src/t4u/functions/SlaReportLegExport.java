package t4u.functions;

import java.io.File;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;

public class SlaReportLegExport {

	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat mmddyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DecimalFormat df1 = new DecimalFormat("00");
	DecimalFormat df2 = new DecimalFormat("00.00");

	CommonFunctions cf = new CommonFunctions();

	public static final String GET_TRIP_DETAILS = "SELECT td.STATUS+'-'+td.TRIP_STATUS as TRIP_STATUS,td.SHIPMENT_ID,td.ORDER_ID,td.PRODUCT_LINE,td.TRIP_CATEGORY,td.ROUTE_NAME,"
			+ " isnull(fms.ModelName,'NA') as MODEL_NAME,isnull(tbl.VehicleType,'NA') as VEHICLE_TYPE,td.ASSET_NUMBER,td.CUSTOMER_REF_ID,td.CUSTOMER_NAME,td.TRIP_ID FROM AMS.dbo.TRACK_TRIP_DETAILS td"
			+
			// " left outer join SLA_REPORT sla on td.TRIP_ID=sla.TRIP_ID " +
			" left outer join AMS.dbo.tblVehicleMaster tbl on tbl.VehicleNo=td.ASSET_NUMBER  " + " left outer join FMS.dbo.Vehicle_Model  fms on tbl.Model=fms.ModelTypeId "
			+ " WHERE td.SYSTEM_ID= ?  and  td.CUSTOMER_ID= ? and td.TRIP_START_TIME between dateadd(mi,-?,?) and " + " dateadd(mi,-?,?)";

	public static final String[] array = { "Sl. No.", "Trip Id", "Trip No.", "Trip Type", "Trip Category", "Route Id", "Vehicle Number", "Make Of Vehicle", "Type of Vehicle",
			"Customer Reference ID", "Customer Name", "Leg ID", "Driver 1 Name", "Driver 1 Contact", "Driver 2 Name", "Driver 2 Contact", "Origin", "Destination", "STD", "ATD",
			"Departure Delay wrt STD (HH:mm:ss)", "Planned Transit Time (incl. planned stoppages)(HH:mm:ss)", "STA wrt STD", "STA wrt ATD", "ETA", "ATA",
			"Actual Transit Time (incl. planned and unplanned stoppages) (HH:mm:ss)", "Transit Delay (HH:mm:ss)", "Trip Status", "Origin Point Stoppage Allowed (HH:mm:ss)",
			"Origin Point Stoppage Actual Duration (HH:mm:ss)", "Origin Point Detention (HH:mm:ss)", "Destination Point Stoppage Allowed (HH:mm:ss)",
			"Destination Point Stoppage Actual Duration (HH:mm:ss)", "Destination Point Detention (HH:mm:ss)", "Unplanned Stoppages (HH:mm:ss)",
			"Total Truck Running Time (HH:mm:ss)", "Leg Distance (Kms)", "Avg. Speed(Kmph)", "LLS Mileage (KMPL)", "OBD Mileage (KMPL)", "Fuel Consumed(L)",
			"Temperature required", "Temp @ Reefer(Actual Temperature at ATA (°C))", "Temp @ Middle(Actual Temperature at ATA (°C))",
			"Temp @ Door(Actual Temperature at ATA (°C))", "Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)",
			"Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)", "Door(GREEN-BAND) - Temp Duration % (% of actual transit time)",
			"Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)",
			"Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "Reefer(RED-BAND) - Temp Duration % (% of actual transit time)",
			"Middle(RED-BAND) - Temp Duration % (% of actual transit time)", "Door(RED-BAND) - Temp Duration % (% of actual transit time)" };
	public static final String[] formatter = { "int", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "datetime", "datetime", "default", "default", "datetime", "datetime", "datetime", "datetime",
			"default", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default", "Number", "Number", "Number", "Number",
			"Number", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default", "default"

	};

	public static final String GET_TRIP_SUMMARY_REPORT_LEG_DETAILS_OLD = "select tl.LEG_ID,LEG_NAME,isnull(lz.NAME,'') as SOURCE,lz1.NAME as DESTIANTION,isnull(dateadd(mi,?,STD),'') as STD,"
			+ " isnull(dateadd(mi,?,STA),'') as STA, isnull(dateadd(mi,?,ACTUAL_ARRIVAL),'') as ATA,isnull(dateadd(mi,?,ACTUAL_DEPARTURE),'') as ATD,isnull(tl.TOTAL_DISTANCE,0) as TOTAL_DISTANCE,"
			+ " isnull(tl.AVG_SPEED,0) as AVG_SPEED,isnull(case when tl.FUEL_CONSUMED > 0 then tl.FUEL_CONSUMED else 0 end,0) as FUEL_CONSUMED,isnull(case when (tl.MILEAGE > 0 and tl.MILEAGE < 10) then tl.MILEAGE else 0 end,0) as MILEAGE,"
			+ " isnull(case when (tl.OBD_MILEAGE > 0 and tl.OBD_MILEAGE < 10) then tl.OBD_MILEAGE else 0 end,0) as OBD_MILEAGE,"
			+ " case when ACTUAL_ARRIVAL is null then isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ISNULL(ACTUAL_ARRIVAL,getutcdate())),0) else isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ACTUAL_ARRIVAL),0)  end as TRAVEL_DURATION,"
			+ " isnull(d.Fullname,'') as DRIVER1,isnull(d1.Fullname,'') as DRIVER2,isnull(dateadd(mi,?,ETA),'') as ETA,isnull(sum(GREEN_BAND_SPEED_DUR),0) as SUM_GBSD ,"
			+ " isnull(sum(GREEN_BAND_RPM_DUR),0) as SUM_GBRD,isnull(sum(TOTAL_DURATION),0) as TOTAL_DURATION,isnull(sum(TOTAL_STOP_DURATION),0)as TOTAL_STOP_DURATION,"
			+ " isnull(sum(tdd.LOW_RPM_DUR),0) as LOW_RPM_DUR,isnull(sum(tdd.HIGH_RPM_DUR),0) as HIGH_RPM_DUR , isnull(sum(FREE_WHEEL_DUR),0) as SUM_FWD,"
			+ " isnull(tdd.GREEN_BAND_SPEED_PERC,0) as greenBandSpeedPerc,isnull(tdd.GREEN_RPM_PERC,0) as greenRPMPerc,isnull(d.Mobile,'') as DRIVER1_CONTACT,isnull(d1.Mobile,'') as DRIVER2_CONTACT,  "
			+ " isnull(DATEDIFF(mi,STD, ACTUAL_DEPARTURE),0) as delayedDepartureATD_STD, "
			+ " isnull(lm.TAT,0) as plannedTransitTime, "
			+ " isnull(DATEDIFF(mi,ACTUAL_DEPARTURE, ACTUAL_ARRIVAL),0) as actualTransitTime , lm.DISTANCE , "
			+ " isnull(lz.Standard_Duration,'') as Standard_DurationS,isnull(lz1.Standard_Duration,'') as Standard_DurationD , "
			+ " DATEADD(mi,lm.TAT,isnull(STA,'')) as STA_wrt_STD,DATEADD(mi,lm.TAT,isnull(ACTUAL_DEPARTURE,''))  as STA_wrt_ATD , "
			+ " isnull(tl.ATA_TEMP1,0) as ATA_TEMPA , isnull(tl.ATA_TEMP2,0) as ATA_TEMPB , isnull(tl.ATA_TEMP3,0) as ATA_TEMPC , "
			+ " isnull(GREEN_DUR_T1,0) as GR,isnull(GREEN_DUR_T2,0) as GM,isnull(GREEN_DUR_T3,0) as GD, "
			+ " isnull(YELLOW_DUR_T1,0) as YR,isnull(YELLOW_DUR_T2,0) as YM,isnull(YELLOW_DUR_T3,0) as YD , "
			+ " isnull(RED_DUR_T1,0) as RR,isnull(RED_DUR_T2,0) as RM,isnull(RED_DUR_T3,0) as RD , "
			+ " isnull(TOTAL_DURATION,0) as TDUR,isnull(TOTAL_STOP_DURATION,0) as TSTOPDUR "
			+ " from TRIP_LEG_DETAILS (nolock) tl "
			+ " left outer join AMS.dbo.LEG_MASTER lm on lm.ID=tl.LEG_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=lm.SOURCE "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz1 on lz1.HUBID=lm.DESTINATION "
			+ " left outer join AMS.dbo.Driver_Master d on d.Driver_id=tl.DRIVER_1 and d.Client_id = lm.CUSTOMER_ID "
			+ " left outer join AMS.dbo.Driver_Master d1 on d1.Driver_id=tl.DRIVER_2 and d1.Client_id = lm.CUSTOMER_ID "
			+ " left outer join TRIP_DRIVER_DETAILS tdd on tl.TRIP_ID=tdd.TRIP_ID and tl.LEG_ID=tdd.LEG_ID "
			+ " where  tl.TRIP_ID=? "
			+ " group by tl.LEG_ID , LEG_NAME, lz.NAME,lz1.NAME ,STD ,STA ,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,tl.TOTAL_DISTANCE ,tl.AVG_SPEED,tl.FUEL_CONSUMED,tl.MILEAGE, "
			+ " tl.OBD_MILEAGE,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,d.Fullname,d1.Fullname,ETA,tdd.GREEN_BAND_SPEED_PERC,tdd.GREEN_RPM_PERC,d.Mobile,d1.Mobile,tl.ID,lm.TAT , "
			+ " lm.DISTANCE,lz.Standard_Duration,lz1.Standard_Duration , tl.ATA_TEMP1,tl.ATA_TEMP2,tl.ATA_TEMP3,GREEN_DUR_T1,GREEN_DUR_T2,GREEN_DUR_T3, "
			+ " YELLOW_DUR_T1,YELLOW_DUR_T2,YELLOW_DUR_T3,RED_DUR_T1,RED_DUR_T2,RED_DUR_T3 , TOTAL_DURATION,TOTAL_STOP_DURATION order by tl.ID ";

	public static final String GET_TRIP_SUMMARY_REPORT_LEG_DETAILS = "select    ISNULL(TRIP_ID,'') AS TRIP_ID, ISNULL(TRIP_CREATE_TIME,'') AS TRIP_CREATE_TIME , ISNULL(TRIP_CREATION_MONTH,'') AS TRIP_CREATION_MONTH , ISNULL(SHIPMENT_ID,'') AS SHIPMENT_ID,ISNULL(ORDER_ID,'') AS ORDER_ID,ISNULL(PRODUCT_LINE,'') AS PRODUCT_LINE ,"
			+ " ISNULL(TRIP_CATEGORY,'') AS TRIP_CATEGORY,ISNULL(ROUTE_NAME,'') AS ROUTE_NAME,ISNULL(MODEL_NAME,'') AS MODEL_NAME, ISNULL(VEHICLE_TYPE,'') AS VEHICLE_TYPE,ISNULL( ASSET_NUMBER,'') AS ASSET_NUMBER, ISNULL(CUSTOMER_TYPE,'') AS CUSTOMER_TYPE,ISNULL(CUSTOMER_NAME,'') AS CUSTOMER_NAME , "
			+ " ISNULL(CUSTOMER_REFERENCE_ID,'') AS CUSTOMER_REFERENCE_ID,  ISNULL(  DRIVER_1_NAME,'') AS DRIVER_1_NAME, ISNULL(DRIVER_1_CONTACT,'') AS DRIVER_1_CONTACT,  ISNULL(DRIVER_2_NAME,'') AS DRIVER_2_NAME, ISNULL(DRIVER_2_CONTACT,'') AS DRIVER_2_CONTACT,ISNULL(DRIVER_3_NAME,'') AS DRIVER_3_NAME, ISNULL(DRIVER_3_CONTACT,'') AS DRIVER_3_CONTACT , "
			+ " ISNULL(DRIVER_4_NAME,'') AS DRIVER_4_NAME, ISNULL(DRIVER_4_CONTACT,'') AS DRIVER_4_CONTACT, ISNULL(DRIVER_5_NAME,'') AS DRIVER_5_NAME, ISNULL(DRIVER_5_CONTACT,'') AS DRIVER_5_CONTACT,  ISNULL(DRIVER_6_NAME,'') AS DRIVER_6_NAME, ISNULL(DRIVER_6_CONTACT,'') AS DRIVER_6_CONTACT,  ISNULL(DRIVER_7_NAME,'') AS DRIVER_7_NAME, "
			+ " ISNULL(DRIVER_7_CONTACT,'') AS DRIVER_7_CONTACT, ISNULL( CURRENT_LOCATION,'') AS CURRENT_LOCATION,  ISNULL(DESTINATION_ETA,'') AS DESTINATION_ETA, ISNULL(NEXT_POINT,'') AS NEXT_POINT, ISNULL(NEXT_POINT_DISTANCE,0) AS NEXT_POINT_DISTANCE,ISNULL(NEXT_POINT_ETA,'') AS NEXT_POINT_ETA,ISNULL(TRANSIT_DELAY,'') AS TRANSIT_DELAY, "
			+ " ISNULL(ROUTE_KEY,'') AS ROUTE_KEY, ISNULL(STA_WRT_STD,'') AS STA_WRT_STD,   ISNULL( ATD,'') AS ATD, ISNULL(DEP_DELAY_WRT_ATD,'') AS DEP_DELAY_WRT_ATD, ISNULL( STA_WRT_ATD,'') AS STA_WRT_ATD, ISNULL(PLANNED_TRANSIT_TIME,'') AS PLANNED_TRANSIT_TIME, ISNULL(CANCELLED_DATE,'') AS CANCELLED_DATE, "
			+ " ISNULL(TRIP_STATUS,'') AS TRIP_STATUS, ISNULL(REASON_FOR_DELAY,'') AS REASON_FOR_DELAY, ISNULL(REASON_FOR_CANCELLATION,'') AS REASON_FOR_CANCELLATION, ISNULL(OPS_DRYRUN_KMS,'') AS OPS_DRYRUN_KMS, ISNULL(CUSTOMER_DRYRUN,'') AS CUSTOMER_DRYRUN, "
			+ " ISNULL(ACTUAL_DISTANCE,0) AS ACTUAL_DISTANCE, ISNULL(TOTAL_DISTANCE,0) AS TOTAL_DISTANCE, ISNULL(AVG_SPEED,0) AS AVG_SPEED,  ISNULL(FUEL_CONSUMED,0) AS FUEL_CONSUMED, ISNULL(LLS_MILEAGE,0) AS LLS_MILEAGE,  ISNULL(OBD_MILEAGE,0) AS OBD_MILEAGE, ISNULL(REQ_TEMPERATURE,0) AS REQ_TEMPERATURE, "
			+ " ISNULL(PRECOOLING_SETUP_TIME,'') AS PRECOOLING_SETUP_TIME,ISNULL(PRECOOLING_ACHIEVED_TIME,'') AS PRECOOLING_ACHIEVED_TIME,  ISNULL(TIME_TAKEN_TO_PRECOOL,'') AS TIME_TAKEN_TO_PRECOOL, ISNULL( ORIGIN_HUB,'') AS ORIGIN_HUB, "
			+ " ISNULL(ORIGIN_CITY,'') AS ORIGIN_CITY, ISNULL(SOURCE_PINCODE,'') AS SOURCE_PINCODE, ISNULL(ORIGIN_STATE,'') AS ORIGIN_STATE,    ISNULL(STP,'') AS STP,   ISNULL( ATP,'') AS ATP,  ISNULL(PLACEMENT_DELAY,'') AS PLACEMENT_DELAY, ISNULL(ORIGIN_STOPPAGE_ALLOWED,'') AS ORIGIN_STOPPAGE_ALLOWED , "
			+ " ISNULL(ORIGIN_STOPPAGE_DURATION,'') AS ORIGIN_STOPPAGE_DURATION, ISNULL(ORIGIN_LOADING_DETENTION,'') AS ORIGIN_LOADING_DETENTION, ISNULL(DESTINATION_HUB,'') AS DESTINATION_HUB, ISNULL(DESTINATION_CITY,'') AS DESTINATION_CITY, ISNULL(DESTINATION_PINCODE,'') AS DESTINATION_PINCODE, "
			+ " ISNULL(DESTINATION_STATE,'') AS DESTINATION_STATE, ISNULL(DESTINATION_STOPPAGE_ALLOWED,'') AS DESTINATION_STOPPAGE_ALLOWED, ISNULL(DESTINATION_STOPPAGE_DURATION,'') AS DESTINATION_STOPPAGE_DURATION, ISNULL(DESTINATION_LOADING_DETENTION,'') AS DESTINATION_LOADING_DETENTION, "
			+ " ISNULL(ATA,'') AS ATA ,ISNULL(ACTUAL_TRANSIT_TIME,'') AS ACTUAL_TRANSIT_TIME, ISNULL(CH_STOPPAGE_ALLOWED,'') AS CH_STOPPAGE_ALLOWED    ,ISNULL(CH_STOPPAGE_DURATION,'') AS CH_STOPPAGE_DURATION, ISNULL(CH_STOPPAGE_DETENTION,'') AS CH_STOPPAGE_DETENTION, ISNULL(SH_STOPPAGE_ALLOWED,'') AS SH_STOPPAGE_ALLOWED, "
			+ " ISNULL(SH_STOPPAGE_DURATION,'') AS SH_STOPPAGE_DURATION, ISNULL(SH_STOPPAGE_DETENTION,'') AS SH_STOPPAGE_DETENTION, ISNULL(UNPLANNED_STOPPAGE,'') AS UNPLANNED_STOPPAGE,  ISNULL(REEFER_GREEN,'') AS REEFER_GREEN, ISNULL(MIDDLE_GREEN,'') AS MIDDLE_GREEN,  ISNULL(DOOR_GREEN,'') AS DOOR_GREEN, "
			+ " ISNULL(REEFER_YELLOW,'') AS REEFER_YELLOW,  ISNULL(MIDDLE_YELLOW,'') AS MIDDLE_YELLOW, ISNULL(DOOR_YELLOW,'') AS DOOR_YELLOW,  ISNULL( REFFER_RED,'') AS REFFER_RED,   ISNULL(MIDDLE_RED,'') AS MIDDLE_RED,  ISNULL(DOOR_RED,'') AS DOOR_RED, ISNULL(RUNNING_TIME,'') AS  RUNNING_TIME, ISNULL(REEFER_TEMP,'') AS REEFER_TEMP, ISNULL(MIDDLE_TEMP,'') AS MIDDLE_TEMP,ISNULL(DOOR_TEMP,'') AS DOOR_TEMP, ISNULL(END_LOCATION,'') AS END_LOCATION, "
			+ " ISNULL(TOUCHPOINT_1,'') AS TOUCHPOINT_1,ISNULL(TOUCHPOINT_1_DURATION,'') AS TOUCHPOINT_1_DURATION,ISNULL(TOUCHPOINT_1_DETENTION,'') AS TOUCHPOINT_1_DETENTION,"
			+ " ISNULL(TOUCHPOINT_2,'') AS TOUCHPOINT_2, ISNULL(TOUCHPOINT_2_DURATION,'') AS TOUCHPOINT_2_DURATION, ISNULL(TOUCHPOINT_2_DETENTION,'') AS TOUCHPOINT_2_DETENTION, "
			+ " ISNULL(TOUCHPOINT_3,'') AS TOUCHPOINT_3,	ISNULL(TOUCHPOINT_3_DURATION,'') AS TOUCHPOINT_3_DURATION,ISNULL(TOUCHPOINT_3_DETENTION,'') AS TOUCHPOINT_3_DETENTION,	"
			+ " ISNULL(TOUCHPOINT_4,'') AS TOUCHPOINT_4, ISNULL(TOUCHPOINT_4_DURATION,'') AS TOUCHPOINT_4_DURATION,ISNULL(TOUCHPOINT_4_DETENTION,'') AS TOUCHPOINT_4_DETENTION, ISNULL(TOUCHPOINT_5,'') AS TOUCHPOINT_5,"
			+ " ISNULL(TOUCHPOINT_5_DURATION,'') AS TOUCHPOINT_5_DURATION,ISNULL(TOUCHPOINT_5_DETENTION,'') AS TOUCHPOINT_5_DETENTION,	"
			+ " ISNULL(TOUCHPOINT_6,'') AS TOUCHPOINT_6,ISNULL(TOUCHPOINT_6_DURATION,'') AS TOUCHPOINT_6_DURATION,ISNULL(TOUCHPOINT_6_DETENTION,'') AS TOUCHPOINT_6_DETENTION,"
			+ " ISNULL(TOUCHPOINT_7,'') AS TOUCHPOINT_7,	ISNULL(TOUCHPOINT_7_DURATION,'') AS TOUCHPOINT_7_DURATION,ISNULL(TOUCHPOINT_7_DETENTION,'') AS TOUCHPOINT_7_DETENTION, "
			+ " ISNULL(	TOUCHPOINT_1_STOPPAGE_ALLOWED,'') AS TOUCHPOINT_1_STOPPAGE_ALLOWED,	ISNULL(TOUCHPOINT_2_STOPPAGE_ALLOWED,'') AS TOUCHPOINT_2_STOPPAGE_ALLOWED,"
			+ "	ISNULL(TOUCHPOINT_3_STOPPAGE_ALLOWED,'') AS TOUCHPOINT_3_STOPPAGE_ALLOWED, 	ISNULL(TOUCHPOINT_4_STOPPAGE_ALLOWED,'') AS TOUCHPOINT_4_STOPPAGE_ALLOWED,"
			+ " ISNULL(TOUCHPOINT_5_STOPPAGE_ALLOWED,'') AS TOUCHPOINT_5_STOPPAGE_ALLOWED,ISNULL(TOUCHPOINT_6_STOPPAGE_ALLOWED,'') AS TOUCHPOINT_6_STOPPAGE_ALLOWED,"
			+ " ISNULL(TOUCHPOINT_7_STOPPAGE_ALLOWED,'') AS TOUCHPOINT_7_STOPPAGE_ALLOWED,ISNULL(STD,'') AS STD, ISNULL(LEG_DISTANCE,0) AS LEG_DISTANCE,ISNULL(LEG_NAME,'') AS LEG_NAME, ISNULL(LEG_ID,0) AS LEG_ID , ISNULL(RECORD_TYPE,'') AS RECORD_TYPE FROM AMS.dbo.SLA_REPORT  WHERE  TRIP_ID IN (SELECT TRIP_ID FROM AMS.dbo.TRACK_TRIP_DETAILS WHERE SYSTEM_ID= ?  and  CUSTOMER_ID= ? "
			+ " and TRIP_START_TIME between dateadd(mi,-?,?) and  dateadd(mi,-?,?))  ORDER BY TRIP_ID,SEQUENCE ";

	/*
	 * public int legDetails(Connection con, int offset, Sheet sheet, CellStyle
	 * headingStyle, CellStyle dateCellStyle, CellStyle defaultStyle, CellStyle
	 * decimalStyle, CellStyle integerStyle, CellStyle blankOrNAStyle,CellStyle
	 * redCell,CellStyle yellowCell,CellStyle greenCell,CellStyle
	 * summaryStyle,JSONArray jsonArray) throws JSONException {
	 */
	public String legDetails(String startTime, String endTime, int systemId, int customerId, int offset, int userId) throws JSONException {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String completePath = "";
		ArrayList<String> arrayList = new ArrayList<String>(Arrays.asList(array));
		ArrayList<String> formatList = new ArrayList<String>(Arrays.asList(formatter));
		try {
			final int indexArray[] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 21, 26, 27, 35, 36, 37 };

			// final String summationArray[] = { "Sl. No.", "Trip ID",
			// "Trip No.", "Trip Type", "Trip Category", "Route ID",
			// "Vehicle Number", "Make of Vehicle", "Type of Vehicle",
			// "Customer Reference ID", "Customer Name",
			// "Planned Transit Time (incl. planned stoppages) (HH:mm:ss)", //
			// "Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)",
			// //
			// "Transit Delay (HH:mm:ss)", //
			// "Unplanned Stoppage (HH:mm:ss)", //
			// "Total Truck Running Time (HH:mm:ss)", //
			// "Leg Distance (Kms)" //
			// };

			final String summationArray[] = { "SL.NO.", "SHIPMENT_ID", "ORDER_ID", "PRODUCT_LINE", "TRIP_CATEGORY", "ROUTE_NAME", "ASSET_NUMBER", "MODEL_NAME",
					"VEHICLE_TYPE", "CUSTOMER_REFERENCE_ID", "CUSTOMER_NAME", "Planned Transit Time (incl. planned stoppages) (HH:mm:ss)", //
					"Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)", //
					"Transit Delay (HH:mm:ss)", //
					"Unplanned Stoppage (HH:mm:ss)", //
					"Total Truck Running Time (HH:mm:ss)", //
					"Leg Distance (Kms)" //
			};

			// Create a Row

			String customername = "DHL";
			Properties properties = ApplicationListener.prop;
			String rootPath = properties.getProperty("slaDashBoardExcelExport");
			// String rootPath ="C://ExcelReport";
			completePath = rootPath + "//" + customername + "_SLA_LEGWISE_REPORT_" + Calendar.getInstance().getTimeInMillis() + ".xlsx";

			File f = new File(rootPath);
			if (!f.exists()) {
				f.mkdir();
			}

			Workbook workbook = new XSSFWorkbook();// new HSSFWorkbook(); // for
			// generating `.xls` file

			/*
			 * CreationHelper helps us create instances of various things like
			 * DataFormat, Hyperlink, RichTextString etc, in a format (HSSF,
			 * XSSF) independent way
			 */
			CreationHelper createHelper = workbook.getCreationHelper();

			/*
			 * 
			 * header styling
			 */
			CellStyle my_style = workbook.createCellStyle();
			my_style.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setFillForegroundColor(IndexedColors.LIGHT_ORANGE.getIndex());
			my_style.setFillPattern(CellStyle.SOLID_FOREGROUND);

			// Create a Font for styling header cells
			Font headerFont = workbook.createFont();
			// headerFont.setBoldweight(); //.setBoldweight(true);
			headerFont.setFontHeightInPoints((short) 14);
			headerFont.setColor(IndexedColors.BLACK.getIndex());
			my_style.setFont(headerFont);

			CellStyle redCell = workbook.createCellStyle();
			redCell.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			redCell.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			redCell.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			redCell.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			redCell.setFillForegroundColor(IndexedColors.RED.getIndex());
			redCell.setFillPattern(CellStyle.SOLID_FOREGROUND);
			redCell.setFont(headerFont);

			CellStyle yellowCell = workbook.createCellStyle();
			yellowCell.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			yellowCell.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			yellowCell.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			yellowCell.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			yellowCell.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
			yellowCell.setFillPattern(CellStyle.SOLID_FOREGROUND);
			yellowCell.setFont(headerFont);

			CellStyle greenCell = workbook.createCellStyle();
			greenCell.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			greenCell.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			greenCell.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			greenCell.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			greenCell.setFillForegroundColor(IndexedColors.GREEN.getIndex());
			greenCell.setFillPattern(CellStyle.SOLID_FOREGROUND);
			greenCell.setFont(headerFont);

			CellStyle dateCellStyle = workbook.createCellStyle();
			dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy HH:mm:ss"));
			dateCellStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			dateCellStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			dateCellStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			dateCellStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			dateCellStyle.setAlignment(CellStyle.ALIGN_RIGHT);

			// Create Cell Style for formatting as Text
			CellStyle timeCellStyle = workbook.createCellStyle();
			timeCellStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			timeCellStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			timeCellStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			timeCellStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			DataFormat fmt = workbook.createDataFormat();
			timeCellStyle.setDataFormat(fmt.getFormat("@"));

			Font redFont = workbook.createFont();
			redFont.setColor(IndexedColors.RED.getIndex());
			CellStyle redFontStyle = workbook.createCellStyle();
			redFontStyle.setFont(redFont);

			Font greenFont = workbook.createFont();
			greenFont.setColor(IndexedColors.GREEN.getIndex());
			CellStyle greenFontStyle = workbook.createCellStyle();
			greenFontStyle.setFont(greenFont);

			CellStyle decimalStyle = workbook.createCellStyle();
			decimalStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			decimalStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			decimalStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			decimalStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			decimalStyle.setAlignment(CellStyle.ALIGN_RIGHT);
			decimalStyle.setDataFormat(fmt.getFormat("0.00"));

			CellStyle integerStyle = workbook.createCellStyle();
			integerStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			integerStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			integerStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			integerStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			integerStyle.setAlignment(CellStyle.ALIGN_RIGHT);
			integerStyle.setDataFormat(fmt.getFormat("0"));

			// Create Cell Style for formatting Date
			CellStyle timecellStyle = workbook.createCellStyle();
			timecellStyle.setDataFormat(createHelper.createDataFormat().getFormat("HH:mm:ss"));
			timecellStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			timecellStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			timecellStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			timecellStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			timecellStyle.setAlignment(CellStyle.ALIGN_RIGHT);

			/*
			 * Created Cell style for Blank and 'NA' Cells Author: Narendra
			 * Date: 04/08/2018
			 */

			CellStyle blankOrNAStyle = workbook.createCellStyle();
			blankOrNAStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			blankOrNAStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			blankOrNAStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			blankOrNAStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			blankOrNAStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
			blankOrNAStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

			Font font = null;
			font = workbook.createFont();
			font.setBoldweight(Font.BOLDWEIGHT_BOLD);

			CellStyle summaryStyle = workbook.createCellStyle();
			summaryStyle.setFont(font);
			summaryStyle.setFillForegroundColor(IndexedColors.GREY_40_PERCENT.index);
			summaryStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			summaryStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			summaryStyle.setBorderTop((short) 1); // single line border
			summaryStyle.setBorderBottom((short) 1); // single line border

			// Create a Sheet
			Sheet sheet = workbook.createSheet("Leg Wise");
			// Sheet sheet2 = workbook.createSheet("Leg Wise");
			sheet.createFreezePane(0, 6);
			// sheet2.createFreezePane(0, 1);
			CellStyle headingStyle = workbook.createCellStyle();
			// headingStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			// headingStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			// headingStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			// headingStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			// headingStyle.setFillBackgroundColor(IndexedColors.BROWN.getIndex());

			// Create a Font for styling header cells
			Font headingFont = workbook.createFont();
			// headerFont.setBoldweight(true);
			headingFont.setFontHeightInPoints((short) 16);
			headingFont.setColor(IndexedColors.DARK_BLUE.getIndex());
			headingStyle.setFont(headingFont);

			// Create a Row
			Row row1 = sheet.createRow(1);
			Cell cellA = row1.createCell(0);
			cellA.setCellValue("SLA LegWise Report");
			cellA.setCellStyle(headingStyle);
			//
			// // Create a Row
			Row row2 = sheet.createRow(3);
			Cell cell0 = row2.createCell(0);
			cell0.setCellValue("Start Date: ");
			cell0.setCellStyle(headingStyle);
			Cell cellB = row2.createCell(1);
			cellB.setCellValue(mmddyyy.format(sdfDB.parse(startTime)));
			cellB.setCellStyle(headingStyle);
			Cell cell2 = row2.createCell(2);
			cell2.setCellValue("End Date: ");
			cell2.setCellStyle(headingStyle);
			Cell cell3 = row2.createCell(3);
			cell3.setCellValue(mmddyyy.format(sdfDB.parse(endTime)));
			cell3.setCellStyle(headingStyle);
			// sheet.addMergedRegion(CellRangeAddress.valueOf("A3:D4"));

			// Create a Row
			Row headerRow = sheet.createRow(5);

			// Row headerRow = sheet.createRow(0);
			Row row = null;
			// Create cells
			for (int i = 0; i < array.length; i++) {
				Cell cell = headerRow.createCell(i);
				cell.setCellValue(array[i]);
				if (array[i].contains("GREEN")) {
					cell.setCellStyle(greenCell);
				} else if (array[i].contains("YELLOW")) {
					cell.setCellStyle(yellowCell);
				} else if (array[i].contains("RED")) {
					cell.setCellStyle(redCell);
				} else {
					cell.setCellStyle(my_style);
				}

				// cell.setCellStyle(headingStyle);
				// if(i%10==0){
				// System.out.println("json.put('"+array[i]+"',#)");
				// }

			}
			int rowNumber = 6;
			int slNo = 1;
			con = DBConnection.getConnectionToDB("AMS");

			// JSONArray tripDetails = getTripDetails(con, systemId, customerId,
			// startTime, endTime, offset);
			// for (int i = 0; i < tripDetails.length(); i++) {
			// JSONObject json1 = (JSONObject) tripDetails.get(i);
			JSONObject json = new JSONObject();
			int legNo = 0;
			pstmt = con.prepareStatement(GET_TRIP_SUMMARY_REPORT_LEG_DETAILS.replace("$", String.valueOf(offset)));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startTime);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endTime);
			rs = pstmt.executeQuery();

			long sumPlannedTransitTime = 0;
			long sumActualTransitTime = 0;
			long sumTransitDelay = 0;
			long sumUnplannedStoppage = 0;
			long sumTruckinngRunningTime = 0;
			double sumDistance = 0;

			while (rs.next()) {

				String record = rs.getString("RECORD_TYPE");
				if (record.equals("LEG")) {

					++legNo;
					++rowNumber;
					row = sheet.createRow(rowNumber);
					long plannedTransitTime = rs.getString("PLANNED_TRANSIT_TIME").equals("") ? 0 : (long) convertHHMMSSToMinutes(rs.getString("PLANNED_TRANSIT_TIME"));
					long actualTransitTime = rs.getString("ACTUAL_TRANSIT_TIME").equals("") ? 0 : (long) convertHHMMSSToMinutes(rs.getString("ACTUAL_TRANSIT_TIME"));// rs.getInt("ACTUAL_TRANSIT_TIME");
					long total_stop_duration = rs.getString("UNPLANNED_STOPPAGE").equals("") ? 0 : (long) convertHHMMSSToMinutes(rs.getString("UNPLANNED_STOPPAGE"));
					; // rs.getLong("UNPLANNED_STOPPAGE");
					double distance = rs.getDouble("LEG_DISTANCE");
					long orginDetn = 0;// rs.getLong("Standard_DurationS");
					long destnDetn = 0;// rs.getLong("Standard_DurationD");

					// long totalDuration =rs.getInt("RUNNING_TIME");
					long truckinngRunningTime = rs.getString("RUNNING_TIME").equals("") ? 0 : (long) convertHHMMSSToMinutes(rs.getString("RUNNING_TIME"));
					long transitDelay = (actualTransitTime != 0) ? (actualTransitTime - plannedTransitTime) : 0;
					//
					// long GR = rs.getLong("GR");
					// long GM = rs.getLong("GM");
					// long GD = rs.getLong("GD");
					//
					// long YR = rs.getLong("YR");
					// long YM = rs.getLong("YM");
					// long YD = rs.getLong("YD");
					//
					// long RR = rs.getLong("RR");
					// long RM = rs.getLong("RM");
					// long RD = rs.getLong("RD");

					json.put("Temperature required", rs.getString("REQ_TEMPERATURE"));
					json.put("Sl. No.", rowNumber);
					Cell cell1 = row.createCell(0);
					cell1.setCellValue("");
					cell1.setCellStyle(integerStyle);

					json.put("Trip Id", rs.getString("SHIPMENT_ID"));
					json.put("Trip No.", rs.getString("ORDER_ID"));
					json.put("Trip Type", rs.getString("PRODUCT_LINE"));
					json.put("Trip Category", rs.getString("TRIP_CATEGORY"));

					json.put("Route Id", rs.getString("ROUTE_NAME"));
					json.put("Vehicle Number", rs.getString("ASSET_NUMBER"));
					json.put("Make Of Vehicle", rs.getString("MODEL_NAME"));
					json.put("Type of Vehicle", rs.getString("VEHICLE_TYPE"));
					json.put("Customer Reference ID", rs.getString("CUSTOMER_REFERENCE_ID"));
					json.put("Customer Name", rs.getString("CUSTOMER_NAME"));

					// json.put("Trip Id", rs.getString("SHIPMENT_ID"));
					// json.put("Trip No.", rs.getString("ORDER_ID"));
					// json.put("Trip Type", rs.getString("PRODUCT_LINE"));
					// json.put("Trip Category", rs.getString("TRIP_CATEGORY"));
					//	
					// json.put("Route Id", rs.getString("ROUTE_NAME"));
					// json.put("Vehicle Number", rs.getString("ASSET_NUMBER"));
					// json.put("Make Of Vehicle", rs.getString("ModelName"));
					// json.put("Type of Vehicle", rs.getString("VehType"));
					// json.put("Customer Reference ID",
					// rs.getString("CUSTOMER_REFERENCE_ID"));
					// json.put("Customer Name", rs.getString("CUSTOMER_NAME"));

					json.put("Leg ID", rs.getString("LEG_NAME"));
					json.put("Driver 1 Name", rs.getString("DRIVER_1_NAME"));
					json.put("Driver 1 Contact", rs.getString("DRIVER_1_CONTACT"));
					json.put("Driver 2 Name", rs.getString("DRIVER_2_NAME"));
					json.put("Driver 2 Contact", rs.getString("DRIVER_2_CONTACT"));
					json.put("Origin", rs.getString("CURRENT_LOCATION"));
					json.put("Destination", rs.getString("END_LOCATION"));
					json.put("STD", rs.getString("STD").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("STD"))));
					json.put("ATD", rs.getString("ATD").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("ATD"))));
					json.put("Departure Delay wrt STD (HH:mm:ss)", rs.getString("DEP_DELAY_WRT_ATD").equals("00:00:00")? "" : rs.getString("DEP_DELAY_WRT_ATD"));// (rs.getInt("delayedDepartureATD_STD")
					// !=
					// 0)
					// ?
					// formattedHoursMinutesSeconds(rs.getInt("delayedDepartureATD_STD"))
					// : "");
					// sum of planned Transit time
					sumPlannedTransitTime += plannedTransitTime;
					json.put("Planned Transit Time (incl. planned stoppages)(HH:mm:ss)", rs.getString("PLANNED_TRANSIT_TIME").equals("00:00:00")? "" : rs.getString("PLANNED_TRANSIT_TIME"));// (plannedTransitTime
					// !=
					// 0)
					// ?
					// formattedHoursMinutesSeconds(plannedTransitTime)
					// :
					// "");
					// getDate(rs.getString("STD"), plannedTransitTime);
					// getDate(rs.getString("ATD"), plannedTransitTime);
					json.put("STA wrt STD", rs.getString("STA_WRT_STD").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("STA_WRT_STD"))));
					json.put("STA wrt ATD", getDate(rs.getString("ATD"), plannedTransitTime));
					json.put("ETA", rs.getString("DESTINATION_ETA").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("DESTINATION_ETA"))));
					json.put("ATA", rs.getString("ATA").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs.getString("ATA"))));
					// sum of actual transit time
					sumActualTransitTime += actualTransitTime;
					json.put("Actual Transit Time (incl. planned and unplanned stoppages) (HH:mm:ss)", (actualTransitTime != 0) ? formattedHoursMinutesSeconds(actualTransitTime)
							: "");
					// sum of Transit Delay
					sumTransitDelay += transitDelay;
					json.put("Transit Delay (HH:mm:ss)", rs.getString("TRANSIT_DELAY").equals("00:00:00") ? "" : rs.getString("TRANSIT_DELAY"));// (transitDelay
					// !=
					// 0)
					// ?
					// formattedHoursMinutesSeconds(transitDelay)
					// :
					// "");
					json.put("Trip Status", rs.getString("TRIP_STATUS"));
					if (rs.getString("ATA").contains("1900") || rs.getString("ATD").contains("1900")) {
						json.put("Origin Point Stoppage Allowed (HH:mm:ss)", " ");
						json.put("Origin Point Stoppage Actual Duration (HH:mm:ss)", " ");
						json.put("Origin Point Detention (HH:mm:ss)", " ");
						json.put("Destination Point Stoppage Allowed (HH:mm:ss)", " ");
						json.put("Destination Point Stoppage Actual Duration (HH:mm:ss)", " ");
						json.put("Destination Point Detention (HH:mm:ss)", " ");
						json.put("Temp @ Reefer(Actual Temperature at ATA (°C))", "");
						json.put("Temp @ Middle(Actual Temperature at ATA (°C))", "");
						json.put("Temp @ Door(Actual Temperature at ATA (°C))", "");
						json.put("Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");
						json.put("Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");
						json.put("Door(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");
						json.put("Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");
						json.put("Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");
						json.put("Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");
						json.put("Reefer(RED-BAND) - Temp Duration % (% of actual transit time)", "");
						json.put("Middle(RED-BAND) - Temp Duration % (% of actual transit time)", "");
						json.put("Door(RED-BAND) - Temp Duration % (% of actual transit time)", "");
					} else {
						// json.put("Temp @ Reefer(Actual Temperature at ATA) (°C)",
						// (rs.getLong("ATA_TEMPA")!=0)?formattedHoursMinutesSeconds(rs.getLong("ATA_TEMPA")):"");
						// json.put("Temp @ Middle(Actual Temperature at ATA (°C))",
						// (rs.getLong("ATA_TEMPB")!=0)?formattedHoursMinutesSeconds(rs.getLong("ATA_TEMPB")):"");
						// json.put("Temp @ Door(Actual Temperature at ATA) (°C)",
						// (rs.getLong("ATA_TEMPC")!=0)?formattedHoursMinutesSeconds(rs.getLong("ATA_TEMPC")):"");

						// json.put("Temp @ Reefer(Actual Temperature at ATA (°C))",
						// rs.getLong("ATA_TEMPA") != 0 ?
						// rs.getLong("ATA_TEMPA") : "");
						// json.put("Temp @ Middle(Actual Temperature at ATA (°C))",
						// rs.getLong("ATA_TEMPB") != 0 ?
						// rs.getLong("ATA_TEMPB") : "");
						// json.put("Temp @ Door(Actual Temperature at ATA (°C))",
						// rs.getLong("ATA_TEMPC") != 0 ?
						// rs.getLong("ATA_TEMPC") : "");

						json.put("Temp @ Reefer(Actual Temperature at ATA (°C))", rs.getString("REEFER_TEMP"));
						json.put("Temp @ Middle(Actual Temperature at ATA (°C))", rs.getString("MIDDLE_TEMP"));
						json.put("Temp @ Door(Actual Temperature at ATA (°C))", rs.getString("DOOR_TEMP"));

						long ATAATD = getDiffinMS(rs.getString("ATA"), rs.getString("ATD"));
						double travelTime = ATAATD / (1000 * 60);

						// double gRefer = GR != 0 ? (GR / travelTime) * 100 :
						// 0;
						// double gMiddle = GM != 0 ? ((GM * 100) / travelTime)
						// : 0;
						// double gDoor = GD != 0 ? ((GD * 100) / travelTime) :
						// 0;
						// double yRefer = YR != 0 ? ((YR * 100) / travelTime) :
						// 0;
						// double yMiddle = YM != 0 ? ((YM * 100) / travelTime)
						// : 0;
						// double yDoor = YD != 0 ? ((YD * 100) / travelTime) :
						// 0;
						// double rRefer = RR != 0 ? ((RR * 100) / travelTime) :
						// 0;
						// double rMiddle = RM != 0 ? ((RM * 100) / travelTime)
						// : 0;
						// double rDoor = RD != 0 ? ((RD * 100) / travelTime) :
						// 0;

						json.put("Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)", rs.getString("REEFER_GREEN"));
						json.put("Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)", rs.getString("MIDDLE_GREEN"));
						json.put("Door(GREEN-BAND) - Temp Duration % (% of actual transit time)", rs.getString("DOOR_GREEN"));
						json.put("Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)", rs.getString("REEFER_YELLOW"));
						json.put("Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)", rs.getString("MIDDLE_YELLOW"));
						json.put("Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)", rs.getString("DOOR_YELLOW"));
						json.put("Reefer(RED-BAND) - Temp Duration % (% of actual transit time)", rs.getString("REFFER_RED"));
						json.put("Middle(RED-BAND) - Temp Duration % (% of actual transit time)", rs.getString("MIDDLE_RED"));
						json.put("Door(RED-BAND) - Temp Duration % (% of actual transit time)", rs.getString("DOOR_RED"));

						long actulaDurationS = 0;
						long actulaDurationD = 0;
						/*
						 * if(json1.has(rs.getString("SOURCE"))){ String
						 * actDurS= json1.getString(rs.getString("SOURCE"));
						 * actulaDurationS=(
						 * actDurS!=null)?Integer.parseInt(actDurS):0; }
						 * if(json1.has(rs.getString("DESTIANTION"))){ String
						 * actDurD=
						 * json1.getString(rs.getString("DESTIANTION"));
						 * actulaDurationD
						 * =(actDurD!=null)?Integer.parseInt(actDurD):0; }
						 */

						json.put("Origin Point Stoppage Allowed (HH:mm:ss)", (orginDetn != 0) ? formattedHoursMinutesSeconds(orginDetn) : "");
						json.put("Origin Point Stoppage Actual Duration (HH:mm:ss)", (actulaDurationS != 0) ? formattedHoursMinutesSeconds(actulaDurationS) : "");
						json.put("Origin Point Detention (HH:mm:ss)", (orginDetn != 0 && actulaDurationS != 0) ? formattedHoursMinutesSeconds((actulaDurationS - orginDetn)) : "");

						json.put("Destination Point Stoppage Allowed (HH:mm:ss)", (destnDetn != 0) ? formattedHoursMinutesSeconds(destnDetn) : "");
						json.put("Destination Point Stoppage Actual Duration (HH:mm:ss)", (actulaDurationD != 0) ? formattedHoursMinutesSeconds(actulaDurationD) : "");
						json.put("Destination Point Detention (HH:mm:ss)", (destnDetn != 0 && actulaDurationD != 0) ? formattedHoursMinutesSeconds((actulaDurationD - destnDetn))
								: "");

					}
					// sum of Unplanned Stopage
					sumUnplannedStoppage += total_stop_duration;
					json.put("Unplanned Stoppages (HH:mm:ss)", (total_stop_duration != 0) ? formattedHoursMinutesSeconds(total_stop_duration) : "");
					// sum of Total Truck Running
					sumTruckinngRunningTime += truckinngRunningTime;
					json.put("Total Truck Running Time (HH:mm:ss)", rs.getString("RUNNING_TIME"));// (truckinngRunningTime
					// !=
					// 0)
					// ?
					// formattedHoursMinutesSeconds(truckinngRunningTime)
					// :
					// "");
					// sum of leg distance
					sumDistance += distance;
					json.put("Leg Distance (Kms)", (distance != 0) ? distance : "");
					json.put("Avg. Speed(Kmph)", rs.getDouble("AVG_SPEED"));
					json.put("LLS Mileage (KMPL)", rs.getDouble("LLS_MILEAGE"));
					json.put("OBD Mileage (KMPL)", rs.getDouble("OBD_MILEAGE"));
					json.put("Fuel Consumed(L)", rs.getDouble("FUEL_CONSUMED"));

					for (int j = 1; j < arrayList.size(); j++) {
						try {

							Cell cell = row.createCell(j);
							String format = formatList.get(j);
							String val = json.getString(arrayList.get(j));
							if (val.trim().equalsIgnoreCase("") || val.equalsIgnoreCase("NA")) {
								cell.setCellValue(val);
								cell.setCellStyle(blankOrNAStyle);
							} else {
								if (format.equalsIgnoreCase("datetime")) {
									if (val.contains("1900")) {
										cell.setCellValue(val);
										cell.setCellStyle(timeCellStyle);
									} else {
										cell.setCellValue(val);
										cell.setCellStyle(dateCellStyle);
									}

								} else if (format.equalsIgnoreCase("Number")) {
									boolean numeric = true;
									try {
										Double num = Double.parseDouble(val);
									} catch (NumberFormatException e) {
										numeric = false;
									}
									double nval = (numeric) ? Double.valueOf(val) : 0;
									cell.setCellValue(nval);
									cell.setCellStyle(decimalStyle);
								} else {
									cell.setCellValue(val);
									cell.setCellStyle(timeCellStyle);
								}
							}
						} catch (JSONException e) {
							// e.printStackTrace();
							System.out.println(e.getMessage());
						} catch (Exception e) {
							// TODO: handle exception
						}
					}
				} else {
					++rowNumber;
					row = sheet.createRow((short) rowNumber);
					Cell cell00 = row.createCell(0);
					cell00.setCellValue(slNo);
					cell00.setCellStyle(summaryStyle);
					slNo++;
					for (int jj = 1; jj < 55; jj++) {
						Cell cell = row.createCell(jj);
						cell.setCellStyle(summaryStyle);
					}
					// summationArray[0] is SL no so starting looping from index 1
					for (int j = 1; j < summationArray.length; j++) {
						try {
							Cell cell = row.createCell(indexArray[j]);

							if (summationArray[j].equals("Planned Transit Time (incl. planned stoppages) (HH:mm:ss)")) {
								cell.setCellValue(rs.getString("PLANNED_TRANSIT_TIME") != "" ? rs.getString("PLANNED_TRANSIT_TIME") : "");
								cell.setCellStyle(summaryStyle);
							} else if (summationArray[j].equals("Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)")) {
								cell.setCellValue((sumActualTransitTime) != 0 ? formattedHoursMinutesSeconds(sumActualTransitTime) : "");
								cell.setCellStyle(summaryStyle);
							} else if (summationArray[j].equals("Transit Delay (HH:mm:ss)")) {
								cell.setCellValue(sumTransitDelay != 0 ? formattedHoursMinutesSeconds(sumTransitDelay) : "");
								cell.setCellStyle(summaryStyle);
							} else if (summationArray[j].equals("Unplanned Stoppage (HH:mm:ss)")) {
								cell.setCellValue(sumUnplannedStoppage != 0 ? formattedHoursMinutesSeconds(sumUnplannedStoppage) : "");
								cell.setCellStyle(summaryStyle);
							} else if (summationArray[j].equals("Total Truck Running Time (HH:mm:ss)")) {
								cell.setCellValue(sumTruckinngRunningTime != 0 ? formattedHoursMinutesSeconds(sumTruckinngRunningTime) : "");
								cell.setCellStyle(summaryStyle);
							} else if (summationArray[j].equals("Leg Distance (Kms)")) {
								cell.setCellValue(sumDistance);
								cell.setCellStyle(summaryStyle);
							} else {
								String val = rs.getString(summationArray[j]);
								if (!val.trim().equalsIgnoreCase("") || !val.equalsIgnoreCase("NA")) {
									cell.setCellValue(val);
									cell.setCellStyle(summaryStyle);
								}
							}

						} catch (Exception e) {
							System.out.println(e.getMessage());
						}
					}
					rowNumber++;

					sumPlannedTransitTime = 0;
					sumActualTransitTime = 0;
					sumTransitDelay = 0;
					sumUnplannedStoppage = 0;
					sumTruckinngRunningTime = 0;
					sumDistance = 0;
				}
			}

			// }

			FileOutputStream fileOut = new FileOutputStream(completePath);
			workbook.write(fileOut);
			fileOut.flush();
			fileOut.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return completePath;
	}

	private JSONArray getTripDetails(Connection con, int systemId, int customerId, String startTime, String endTime, int offset) throws SQLException, JSONException {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		JSONArray jArr = new JSONArray();
		JSONObject jsonobject = null;
		pstmt = con.prepareStatement(GET_TRIP_DETAILS);
		pstmt.setInt(1, systemId);
		pstmt.setInt(2, customerId);
		pstmt.setInt(3, offset);
		pstmt.setString(4, startTime);
		pstmt.setInt(5, offset);
		pstmt.setString(6, endTime);
		rs = pstmt.executeQuery();
		while (rs.next()) {
			count++;
			jsonobject = new JSONObject();
			jsonobject.put("Sl. No.", count);
			jsonobject.put("Trip ID", rs.getString("SHIPMENT_ID"));
			jsonobject.put("Trip No.", rs.getString("ORDER_ID"));
			jsonobject.put("Trip Type", rs.getString("PRODUCT_LINE"));
			jsonobject.put("Trip Category", rs.getString("TRIP_CATEGORY"));
			jsonobject.put("Route ID", rs.getString("ROUTE_NAME"));
			jsonobject.put("Make of Vehicle", rs.getString("MODEL_NAME"));
			jsonobject.put("Type of Vehicle", rs.getString("VEHICLE_TYPE"));
			jsonobject.put("Vehicle Number", rs.getString("ASSET_NUMBER"));
			jsonobject.put("Customer Reference ID", rs.getString("CUSTOMER_REF_ID"));
			jsonobject.put("Customer Name", rs.getString("CUSTOMER_NAME"));
			jsonobject.put("tripId", rs.getInt("TRIP_ID"));
			jsonobject.put("Trip Status", rs.getString("TRIP_STATUS"));
			jArr.put(jsonobject);
		}
		return jArr;
	}

	public String formattedHoursMinutesSeconds(long diff) {
		String hhmmssformat = "";
		String format = "";
		boolean negative = false;
		try {
			diff = (diff * 60) * 1000;
			if (diff == 0) {
				return hhmmssformat = "";
			}
			long diffSeconds = diff / 1000 % 60;
			long diffMinutes = diff / (60 * 1000) % 60;
			long diffHours = diff / (60 * 60 * 1000);
			// hhmmssformat=diffHours+":"+diffMinutes+":"+diffSeconds;
			hhmmssformat = df1.format(diffHours) + ":" + df1.format(diffMinutes) + ":" + df1.format(diffSeconds);
			negative = hhmmssformat.contains("-") ? true : false;
			format = negative ? "-" + hhmmssformat.replaceAll("-", "") : hhmmssformat;
		} catch (Exception e) {
			System.out.println("hh:mm:ss exception :::::   " + e.getLocalizedMessage());
			e.printStackTrace();

		}
		return format;

	}

	public long getDiffinMS(String date1, String date2) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date d1 = null;
		Date d2 = null;
		long diff = 0;
		try {
			d1 = format.parse(date1);
			d2 = format.parse(date2);
			// diff = d2.getTime() - d1.getTime();
			diff = d1.getTime() - d2.getTime();
		} catch (Exception e) {
			System.out.println("hh:mm:ss exception :::::   " + e.getLocalizedMessage());
			e.printStackTrace();

		}
		return diff;

	}

	public String getDate(String date, long mins) {
		String newDate = "";
		try {
			if (!date.contains("1900") && mins > 0) {
				Date d = sdfDB.parse(date);
				Calendar cal = Calendar.getInstance();
				cal.setTime(d);
				cal.add(Calendar.MINUTE, (int) mins);
				newDate = sdfDB.format(cal.getTime());
				newDate = mmddyyy.format(sdfDB.parse(newDate));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return newDate;
	}

	public int convertHHMMSSToMinutes(String hourminutes) {
		int duration = 0;
		String[] split = hourminutes.split(":");
		String hours = split[0];// hourminutes.substring(0,
		// hourminutes.indexOf(":"));
		String minutes = split[1];// hourminutes.substring(hourminutes.indexOf(":")+1);
		int hoursdouble = 0;
		if (!hours.equals("")) {
			hoursdouble = Integer.parseInt(hours) * 60;
		}
		duration = hoursdouble + Integer.parseInt(minutes);
		return duration;
	}

}
