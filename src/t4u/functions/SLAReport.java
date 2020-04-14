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
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.Map.Entry;

import org.apache.poi.hssf.usermodel.HSSFCellStyle;
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
import t4u.statements.CreateTripStatement;

public class SLAReport {

	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat mmddyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	DecimalFormat df1 = new DecimalFormat("00");
	DecimalFormat df2 = new DecimalFormat("00.00");
	CommonFunctions cf = new CommonFunctions();
	long actualTAT = 0;
	public static final String[] formatter = { "int", "datetime", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "datetime", "datetime", "default", "default", "default", "default",
			"datetime", "datetime", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "datetime", "datetime", "datetime", "default",
			"Number", "datetime", "default", "default", "default", "datetime", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "Number", "Number", "Number", "Number", "Number", "Number", "Number", "Number",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "datetime", "datetime", "datetime" };

	public static final String[] array = { "Sl. No.", "Trip Creation Time", "Trip Creation Month", "Trip ID",
			"Trip No.", "Trip Type", "Trip Category", "Route ID", "Make of Vehicle", "Type of Vehicle",
			"Vehicle Number", "Customer Type", "Customer Name", "Customer Reference ID", "Driver 1 Name",
			"Driver 1 Contact", "Driver 2 Name", "Driver 2 Contact", "Driver 3 Name", "Driver 3 Contact",
			"Driver 4 Name", "Driver 4 Contact", "Driver 5 Name", "Driver 5 Contact", "Driver 6 Name",
			"Driver 6 Contact", "Location", "Route Key", "Origin Hub", "Destination Hub", "Origin City",
			"Source Pincode", "Origin State", "Destination City", "Destination Pincode", "Destination State", "STP",
			"ATP", "Placement Delay (HH:mm:ss)", "Origin Hub Stoppage Allowed (HH:mm:ss)",
			"Origin Hub Stoppage Actual Duration (HH:mm:ss)", "Origin Hub (Loading) Detention (HH:mm:ss)", "STD",
			"ATD", "Departure Delay wrt STD (HH:mm:ss)", "Planned Transit Time (incl. planned stoppages) (HH:mm:ss)",
			"Touching Point 1", "Touching Point 1 Stoppage Allowed (HH:mm:ss)",
			"Touching Point 1 Stoppage Actual Duration (HH:mm:ss)", "Touching Point 1 Detention (HH:mm:ss)",
			"Touching Point 2", "Touching Point 2 Stoppage Allowed (HH:mm:ss)",
			"Touching Point 2 Stoppage Actual Duration (HH:mm:ss)", "Touching Point 2 Detention (HH:mm:ss)",
			"Touching Point 3", "Touching Point 3 Stoppage Allowed (HH:mm:ss)",
			"Touching Point 3 Stoppage Actual Duration (HH:mm:ss)", "Touching Point 3 Detention (HH:mm:ss)",
			"Touching Point 4", "Touching Point 4 Stoppage Allowed (HH:mm:ss)",
			"Touching Point 4 Stoppage Actual Duration (HH:mm:ss)", "Touching Point 4 Detention (HH:mm:ss)",
			"Touching Point 5", "Touching Point 5 Stoppage Allowed (HH:mm:ss)",
			"Touching Point 5 Stoppage Actual Duration (HH:mm:ss)", "Touching Point 5 Detention (HH:mm:ss)",
			"Touching Point 6", "Touching Point 6 Stoppage Allowed (HH:mm:ss)",
			"Touching Point 6 Stoppage Actual Duration (HH:mm:ss)", "Touching Point 6 Detention (HH:mm:ss)",
			"Touching Point 7", "Touching Point 7 Stoppage Allowed (HH:mm:ss)",
			"Touching Point 7 Stoppage Actual Duration (HH:mm:ss)", "Touching Point 7 Detention (HH:mm:ss)",
			"STA wrt STD", "STA wrt ATD", "ETA", "Next touching point", "Distance to next touching point",
			"ETA to next touching point", "ATA",
			"Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)", "Transit Delay (HH:mm:ss)",
			"Trip Close/Canceled Time", "Trip Status", "Reason for Delay", "Reason for Cancellation",
			"Destination Hub Stoppage Allowed (HH:mm:ss)", "Destination Hub Stoppage Actual Duration (HH:mm:ss)",
			"Destination Hub (Unloading) Detention (HH:mm:ss)",
			"Total In-transit Planned Customer Hub Stoppage Allowed (HH:mm:ss)",
			"Total In-transit Planned Customer Hub Stoppage Actual Duration (HH:mm:ss)",
			"Total In-transit Planned Customer Hub Stoppage Detention (HH:mm:ss)",
			"Total In-transit Planned SmartHub Stoppage Allowed (HH:mm:ss)",
			"Total In-transit Planned SmartHub Stoppage Actual Duration (HH:mm:ss)",
			"Total In-transit Planned SmartHub Stoppage Detention (HH:mm:ss)", "Unplanned Stoppage (HH:mm:ss)",
			"Total Truck Running Time (HH:mm:ss)", "Ops Dry Run (kms)", "Customer Dry Run (kms)",
			"Trip Distance (kms)", "Total Distance (kms)", "Average Speed (kms/h)", "Fuel Consumed(L)",
			"LLS Mileage (kms/L)", "OBD Mileage (kms/L)", "Temperature required",
			"Temp @ Reefer(Actual Temperature at ATA (°C))", "Temp @ Middle(Actual Temperature at ATA (°C))",
			"Temp @ Door(Actual Temperature at ATA (°C))",
			"Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)",
			"Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)",
			"Door(GREEN-BAND) - Temp Duration % (% of actual transit time)",
			"Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)",
			"Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)",
			"Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)",
			"Reefer(RED-BAND) - Temp Duration % (% of actual transit time)",
			"Middle(RED-BAND) - Temp Duration % (% of actual transit time)",
			"Door(RED-BAND) - Temp Duration % (% of actual transit time)", "Precooling  Setup Time",
			"Precooling Achieved Time", "Time to Achieve Precooling (HH:mm:ss)", };

	public static final String[] CEarray = { "Sl. No.", "Indent Number", "Placement Date", "Trip Number",
			"Customer Ref. No.", "Placement Type", "Client Name", "Status", "Origin", "Touch Point 1", "Touch Point 2",
			"Touch Point 3", "Touch Point 4", "Destination", "Route", "Vehicle Size", "Vehicle Type", "Vehicle ID",
			"Scheduled Report Date/Time", "Actual Report Date/Time", "Placement deviation", "Placement Status",
			"Scheduled Dep Date/Time", "Actual Dep Date/Time", "Dispatch Variation", "Dispatch Status",
			"Loading Detention", "Touchpoint 1 Arrival", "Touchpoint 1 Departure", "Touch point1 Detention",
			"Touchpoint 2 Arrival", "Touchpoint 2 Departure", "Touch point2 Detention", "Touchpoint 3 Arrival",
			"Touchpoint 3 Departure", "Touch point3 Detention", "Estimated Arrival", "Actual Arrival", "Trip Closure",
			"Unloading Detention", "AgreedTAT -incl.SH Stoppages", "OverallTAT -incl.SH Stoppages",
			"Uncontrollable TAT", "Actual TAT", "Delay", "Delay Bucket", "Delay Sub Bucket", "Delay Remarks",
			"Actual CHDetention", "Planned CHDetention", "Transit Performance", "Avg Speed" };

	public static final String[] CEformatter = { "int", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default", "default", "default", "default", "default", "default", "default", "default", "default",
			"default" };

	public static final String getTripInformationOld = " select * from SLA_REPORT  where  TRIP_ID IN (SELECT TRIP_ID FROM AMS.dbo.TRACK_TRIP_DETAILS WHERE SYSTEM_ID= ?  and  CUSTOMER_ID= ? "
			+ " and TRIP_START_TIME between dateadd(mi,-?,?) and  dateadd(mi,-?,?)) ";

	public static final String getTripInformation = "select ISNULL(TRIP_ID,'') AS TRIP_ID, ISNULL(TRIP_CREATE_TIME,'') AS TRIP_CREATE_TIME , ISNULL(TRIP_CREATION_MONTH,'') AS TRIP_CREATION_MONTH , ISNULL(SHIPMENT_ID,'') AS SHIPMENT_ID,ISNULL(ORDER_ID,'') AS ORDER_ID,ISNULL(PRODUCT_LINE,'') AS PRODUCT_LINE ,"
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
			+ " ISNULL(TOUCHPOINT_7_STOPPAGE_ALLOWED,'') AS TOUCHPOINT_7_STOPPAGE_ALLOWED,ISNULL(STD,'') AS STD, ISNULL(LEG_DISTANCE,0) AS LEG_DISTANCE,ISNULL(LEG_NAME,'') AS LEG_NAME, ISNULL(LEG_ID,0) AS LEG_ID FROM AMS.dbo.SLA_REPORT  WHERE  TRIP_ID IN (SELECT TRIP_ID FROM AMS.dbo.TRACK_TRIP_DETAILS WHERE SYSTEM_ID= ?  and  CUSTOMER_ID= ? "
			+ " and TRIP_START_TIME between dateadd(mi,-?,?) and  dateadd(mi,-?,?)) AND RECORD_TYPE = 'TRIP' ORDER BY TRIP_ID DESC";

	public static final String GET_DRIVER_DETAILS = "select DRIVER_X from  AMS.dbo.TRIP_LEG_DETAILS  WHERE TRIP_ID=? AND DRIVER_X !=0  ORDER BY ID";

	public static final String GET_DES_HUB_DETAILS = " select isnull(lz0.PINCODE, '') as srcPincode,isnull(lz100.PINCODE, '') as desPincode, b.OPERATION_ID,isnull(a.NAME,'') as touchPointName,a.SEQUENCE as SEQUENCE,isnull(b.NAME,'') as NAME,isnull(b.HUB_CITY,'') as HUB_CITY,isnull(b.HUB_STATE,'') as HUB_STATE , "
			+ " dateadd(mi,330,PLANNED_ARR_DATETIME) as PLANNED_ARR_DATETIME,dateadd(mi,330,isnull(ACT_ARR_DATETIME,'')) as ACT_ARR_DATETIME,dateadd(mi,330,isnull(ACT_DEP_DATETIME,isnull(ACTUAL_TRIP_END_TIME,''))) as ACT_DEP_DATETIME, "
			+ " isnull(DETENTION_TIME,'') as DETENTION_TIME ,LEG_ID , isnull(datediff(mi,PLANNED_ARR_DATETIME,ACT_ARR_DATETIME),0)  as PLACEMENTDELAY, "
			+ " isnull(datediff(mi,ACT_ARR_DATETIME,ACT_DEP_DATETIME),0)  as DEPARTUREDELAY, "
			+ " dateadd(mi,330,isnull(a.ACT_ARR_DATETIME,'')) as TOUCHPOINT_ARRIVAL,dateadd(mi,330,isnull(a.ACT_DEP_DATETIME,'')) as TOUCHPOINT_DEPARTURE,"
			+ " case when a.ACT_ARR_DATETIME is not null and a.ACT_DEP_DATETIME IS not null then isnull(datediff(mi,a.ACT_ARR_DATETIME,a.ACT_DEP_DATETIME),0)-(isnull(datediff(mi,a.PLANNED_ARR_DATETIME,a.PLANNED_DEP_DATETIME),0)) else 0 end  AS TOUCHPOINT_DETENTION "
			+ " from AMS.dbo.DES_TRIP_DETAILS a "
			+ " LEFT OUTER join AMS.dbo.LOCATION b on a.HUB_ID=b.HUBID "
			+ " left outer join AMS.dbo.LOCATION lz0 ON lz0.HUBID=a.HUB_ID "
			+ " left outer join AMS.dbo.LOCATION lz100 ON lz100.HUBID=a.HUB_ID "
			+ " left outer join TRACK_TRIP_DETAILS td on td.TRIP_ID= a.TRIP_ID "
			+ " WHERE a.TRIP_ID=? "
			+ " order by SEQUENCE ";

	public static final String GET_DES_HUB_DETAILS_CEREPORT = " select isnull(lz0.PINCODE, '') as srcPincode,isnull(lz100.PINCODE, '') as desPincode, b.OPERATION_ID,isnull(b.NAME,'') as touchPointName,a.SEQUENCE as SEQUENCE,isnull(b.NAME,'') as NAME,isnull(b.HUB_CITY,'') as HUB_CITY,isnull(b.HUB_STATE,'') as HUB_STATE , "
			+ " dateadd(mi,330,PLANNED_ARR_DATETIME) as PLANNED_ARR_DATETIME,dateadd(mi,330,isnull(ACT_ARR_DATETIME,'')) as ACT_ARR_DATETIME,dateadd(mi,330,isnull(ACT_DEP_DATETIME,isnull(ACTUAL_TRIP_END_TIME,''))) as ACT_DEP_DATETIME, "
			+ " isnull(DETENTION_TIME,'') as DETENTION_TIME ,LEG_ID , isnull(datediff(mi,PLANNED_ARR_DATETIME,ACT_ARR_DATETIME),0)  as PLACEMENTDELAY, "
			+ " isnull(datediff(mi,ACT_ARR_DATETIME,ACT_DEP_DATETIME),0)  as DEPARTUREDELAY, "
			+ " dateadd(mi,330,isnull(a.ACT_ARR_DATETIME,'')) as TOUCHPOINT_ARRIVAL,dateadd(mi,330,isnull(a.ACT_DEP_DATETIME,'')) as TOUCHPOINT_DEPARTURE,"
			+ " case when a.ACT_ARR_DATETIME is not null and a.ACT_DEP_DATETIME IS not null then isnull(datediff(mi,a.ACT_ARR_DATETIME,a.ACT_DEP_DATETIME),0) else 0 end  AS TOUCHPOINT_DETENTION "
			+ " from AMS.dbo.DES_TRIP_DETAILS a "
			+ " LEFT OUTER join AMS.dbo.LOCATION b on a.HUB_ID=b.HUBID "
			+ " left outer join AMS.dbo.LOCATION lz0 ON lz0.HUBID=a.HUB_ID "
			+ " left outer join AMS.dbo.LOCATION lz100 ON lz100.HUBID=a.HUB_ID "
			+ " left outer join TRACK_TRIP_DETAILS td on td.TRIP_ID= a.TRIP_ID "
			+ " WHERE a.TRIP_ID=? "
			+ " order by SEQUENCE ";

	public static final String GET_DRIVER_NAME = "select isnull(Fullname,'') as DRIVER_NAME,Mobile from Driver_Master where Driver_id=?  AND System_id = ?";

	public static final String getTripCreationInfo = " select (select isnull(SUM(DELAY),0)  from TRAFFIC_DETAILS WHERE TRIP_ID=td.TRIP_ID) as traffic_delay," +
	" td.STATUS as TRIPSTATUS,case when td.ACTUAL_TRIP_START_TIME is null then 0 else DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,isnull(des1.ACT_ARR_DATETIME," +
	" isnull(td.DESTINATION_ETA,td.ACTUAL_TRIP_END_TIME))) end - isnull(ACT_CH_DETENTION,0) as actualTransitTime,isnull(datediff(mi,des1.ACT_DEP_DATETIME," +
	" des1.ACT_ARR_DATETIME),0) AS OVERALL_TAT,ISNULL(td.TRIP_STATUS,'') AS TRIP_STATUS,isnull(td.PLANNED_DURATION,0) as PLANNED_DURATION,"
	+ "dateadd(mi,330,td.INSERTED_TIME) as TRIP_CREATION_TIME,td.TRIP_CUSTOMER_TYPE as PLACEMENT_TYPE,isnull(td.TRQ_ID,'NA') as INDENT_NUMBER,td.TRIP_ID as TRIP_ID," +
	" isnull(des1.ACT_ARR_DATETIME,'') as ATA,isnull(des1.ACT_DEP_DATETIME,'') as departureDatetime,dateadd(mi,330,isnull(td.ACT_SRC_ARR_DATETIME,'')) as PLACEMENT_DATETIME," +
	" isnull(td.ORDER_ID,'')as TRIPNUMBER,ISNULL(td.CUSTOMER_REF_ID,'NA') as CUSTOMER_REFERENCE_ID,isnull(left(rm.ROUTE_KEY,case WHEN CHARINDEX('_', rm.ROUTE_KEY)>0 THEN CHARINDEX('_', rm.ROUTE_KEY)-1 ELSE 0 END),'NA') as ORIGIN," +
	" isnull(right(rm.ROUTE_KEY,(len(rm.ROUTE_KEY)-CHARINDEX('_', rm.ROUTE_KEY))),'NA') as DESTINATION,td.CUSTOMER_NAME as CLIENT_NAME," +
	" case when td.STATUS='OPEN' then 'In-transit' when td.STATUS='CLOSED' then 'Completed' when td.STATUS='CANCEL' then 'Cancelled' when td.STATUS='UPCOMING' then '' else td.STATUS end as STATUS,"
	+ " case when td.ACT_SRC_ARR_DATETIME is null then '' when isnull(datediff(mi,des0.PLANNED_ARR_DATETIME,td.ACT_SRC_ARR_DATETIME),0)>0 then 'Delayed' else 'Ontime' end AS PLACEMENT_STATUS," +
	" case when td.ACTUAL_TRIP_START_TIME is null then '' when isnull(datediff(mi,td.ACTUAL_TRIP_START_TIME,td.TRIP_START_TIME),0)>0 then 'Delayed' else 'Ontime' end AS DISPATCH_STATUS,"
	+ "isnull(dateadd(mi,330,td.DESTINATION_ETA),'')as ESTIMATED_ARRIVAL,isnull(rm.ROUTE_KEY,' _ ') as ROUTE,ISNULL(tbl.VehicleType,'NA')as VEHICLE_SIZE,ISNULL(fms.ModelName,'NA')as VEHICLE_TYPE,"
	+ "case when td.ACT_SRC_ARR_DATETIME is null then 0 else (isnull((DATEDIFF(mi,td.ACT_SRC_ARR_DATETIME,td.ACTUAL_TRIP_START_TIME)-des0.DETENTION_TIME),0)) end AS LOADING_DETENTION_OLD,"
	+ " (CASE WHEN ACT_SRC_ARR_DATETIME > des0.PLANNED_ARR_DATETIME THEN convert(varchar,(DATEDIFF(mi,ACT_SRC_ARR_DATETIME,isnull(ACTUAL_TRIP_START_TIME,getutcdate()))-des0.DETENTION_TIME) ) ELSE convert(varchar,(DATEDIFF(mi,des0.PLANNED_ARR_DATETIME, isnull(ACTUAL_TRIP_START_TIME,getutcdate()))-des0.DETENTION_TIME) ) END) AS LOADING_DETENTION,"
	+ "case when des1.ACT_ARR_DATETIME is null then 0 else (isnull((DATEDIFF(mi,des1.ACT_ARR_DATETIME,des1.ACT_DEP_DATETIME)-des1.DETENTION_TIME),0))end AS UNLOADING_DETENTION_OLD, "
	+ " (CASE when des1.ACT_ARR_DATETIME is null then 0 else(CASE WHEN des1.ACT_ARR_DATETIME > des1.PLANNED_ARR_DATETIME THEN convert(varchar,(DATEDIFF(mi,des1.ACT_ARR_DATETIME,isnull(ACTUAL_TRIP_END_TIME,getutcdate()))-des1.DETENTION_TIME) )  ELSE convert(varchar,(DATEDIFF(mi,des1.PLANNED_ARR_DATETIME,isnull(ACTUAL_TRIP_END_TIME,getutcdate()))-des1.DETENTION_TIME) ) END)END) as UNLOADING_DETENTION,"
	+ "ISNULL(td.ASSET_NUMBER,'') as VEHICLEID,dateadd(mi,330,isnull(des0.PLANNED_ARR_DATETIME,'')) as SCHEDULEDREPORT_DATETIME,dateadd(mi,330,isnull(des0.ACT_ARR_DATETIME,'')) as ACTUALREPORT_DATETIME,case when td.ACT_SRC_ARR_DATETIME is null then '' else (isnull(datediff(mi,td.ACT_SRC_ARR_DATETIME,des0.PLANNED_ARR_DATETIME),0)) end AS PLACEMENT_DEVIATION,"
	+ "dateadd(mi,330,td.TRIP_START_TIME) as SCHEDULEDDEP_DATETIME,isnull(dateadd(mi,330,td.ACTUAL_TRIP_START_TIME),'') as ACTUALDEP_DATETIME,isnull(datediff(mi,td.ACTUAL_TRIP_START_TIME,td.TRIP_START_TIME),0) AS DISPATCH_VARIATION,isnull(dateadd(mi,330,des1.ACT_ARR_DATETIME),'') as ACTUAL_ARRIVAL,isnull(dateadd(mi,330,td.ACTUAL_TRIP_END_TIME),'') as ACTUAL_TRIP_END_TIME,"
	+ "ISNULL((td.PLANNED_DURATION-td.PLANNED_CH_DETENTION),0)as AGREED_TAT,isnull((select top 1 SUBISSUE_TYPE from TRIP_REMARKS_DETAILS where TRIP_ID=td.TRIP_ID order by INSERTED_DATETIME desc),'') as DELAY_SUB_BUCKET,"
	+ "isnull((select top 1 'Impacted Hours: '+dhl.DELAYTIME+', Due to :'+dhl.REASON  from AMS.dbo.TRIP_REMARKS_DETAILS dhl where dhl.TRIP_ID=td.TRIP_ID order by INSERTED_DATETIME desc ),'') as DELAY_REMARKS,"
	+ "isnull(ACT_CH_DETENTION,0) as ACT_CHDetention,isnull(PLANNED_CH_DETENTION,0) as PLANNED_CHDetention, isnull(ACTUAL_DISTANCE,0) as ACTUAL_DISTANCE," +
	" case when (td.ACTUAL_TRIP_START_TIME is not null and td.ACTUAL_DISTANCE > 0 and (datediff(mi,ACTUAL_TRIP_START_TIME,isnull(des1.ACT_ARR_DATETIME,td.ACTUAL_TRIP_END_TIME)) - td.ACT_CH_DETENTION) > 0)" +
	" then (td.ACTUAL_DISTANCE / (datediff(mi,ACTUAL_TRIP_START_TIME,isnull(des1.ACT_ARR_DATETIME,td.ACTUAL_TRIP_END_TIME)) - td.ACT_CH_DETENTION) * 60) else " +
	" (case when (PLANNED_DURATION - PLANNED_CH_DETENTION) > 0 then td.PLANNED_DISTANCE / (PLANNED_DURATION - PLANNED_CH_DETENTION) * 60 else 0 end) end as avgSpeed " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" left outer join AMS.dbo.tblVehicleMaster tbl on tbl.VehicleNo=td.ASSET_NUMBER" +
	" left outer join FMS.dbo.Vehicle_Model  fms on tbl.Model=fms.ModelTypeId" +
	" left outer join AMS.dbo.DES_TRIP_DETAILS des0 on td.TRIP_ID= des0.TRIP_ID AND des0.SEQUENCE=0" +
	" left outer join AMS.dbo.DES_TRIP_DETAILS des1 on td.TRIP_ID= des1.TRIP_ID AND des1.SEQUENCE=100"
	+ " left outer join AMS.dbo.TRIP_ROUTE_MASTER rm ON rm.ID=td.ROUTE_ID "
	+ " where td.SYSTEM_ID=? and td.TRIP_CUSTOMER_ID=? and td.STATUS='CLOSED' and td.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ORDER BY td.TRIP_ID DESC;";

	public Map<ArrayList<Integer>, ArrayList<String>> getList(Connection con, int systemId, int customerId, int userId,
			String pageName) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Integer> arrayList = null;
		ArrayList<String> colList = null;
		Map<ArrayList<Integer>, ArrayList<String>> hiddenMapping = null;
		boolean isUserSet = false;
		try {
			arrayList = new ArrayList<Integer>();
			colList = new ArrayList<String>();
			pstmt = con
					.prepareStatement(" select COLUMN_NAME,VISIBILITY from LIST_VIEW_COLUMN_SETTING  WHERE PAGE_NAME=? and SYSTEM_ID=? and CUSTOMER_ID=?  and USER_ID=? ORDER BY DISPLAY_ORDER ");
			pstmt.setString(1, pageName);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				isUserSet = true;
				int visiblity = rs.getInt("VISIBILITY");
				arrayList.add(visiblity);
				if (visiblity == 1) {
					colList.add(rs.getString("COLUMN_NAME"));
				}
			}
			if (isUserSet) {
				hiddenMapping = new HashMap<ArrayList<Integer>, ArrayList<String>>();
				hiddenMapping.put(arrayList, colList);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return hiddenMapping;
	}

	public String getCETripDetails(String startTime, String endTime, int systemId, int customerId, int offset,
			int userId) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject json = null;
		int count = 0;
		String completePath = null;
		ArrayList<String> arrayList = null;
		ArrayList<String> formatList = null;
		ArrayList<String> userColumnList = null;
		ArrayList<Integer> userVisibiltyList = null;
		Date d1 = new Date();
		String placementDeviation = "00:00";
		String dispatchDeviation = "00:00:00";
		String agreedTAT = "00:00:00";
		String loadingDetention = "00:00:00";
		String unloadingDetention = "00:00:00";
		String status = "";

		try {
			con = DBConnection.getConnectionToDB("AMS");
			arrayList = new ArrayList<String>(Arrays.asList(CEarray));
			formatList = new ArrayList<String>(Arrays.asList(CEformatter));
			String customername = "DHL";
			Properties properties = ApplicationListener.prop;
			String rootPath = properties.getProperty("CEDashBoardExcelExport");
			completePath = rootPath + "//" + customername + "_TRIP_PERFORMANCE_REPORT_"
					+ Calendar.getInstance().getTimeInMillis() + ".xlsx";

			File f = new File(rootPath);
			if (!f.exists()) {
				f.mkdir();
			}

			Workbook workbook = new XSSFWorkbook();// new HSSFWorkbook(); // for
			CreationHelper createHelper = workbook.getCreationHelper();
			CellStyle my_style = workbook.createCellStyle();
			my_style.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			my_style.setFillForegroundColor(IndexedColors.LIGHT_ORANGE.getIndex());
			my_style.setFillPattern(CellStyle.SOLID_FOREGROUND);

			// Create a Font for styling header cells
			Font headerFont = workbook.createFont();
			headerFont.setFontHeightInPoints((short) 14);
			headerFont.setColor(IndexedColors.BLACK.getIndex());
			my_style.setFont(headerFont);

			Sheet sheet = workbook.createSheet("Trip Level");
			sheet.createFreezePane(0, 6);

			CellStyle headingStyle = workbook.createCellStyle();
			Font headingFont = workbook.createFont();
			headingFont.setFontHeightInPoints((short) 16);
			headingFont.setColor(IndexedColors.DARK_BLUE.getIndex());
			headingStyle.setFont(headingFont);

			Row row1 = sheet.createRow(1);
			Cell cellA = row1.createCell(0);
			cellA.setCellValue("Trip Performance Report");
			cellA.setCellStyle(headingStyle);

			Row row2 = sheet.createRow(3);
			Cell cell0 = row2.createCell(0);
			cell0.setCellValue("TripStart Date: ");
			cell0.setCellStyle(headingStyle);
			Cell cellB = row2.createCell(1);
			cellB.setCellValue(mmddyyy.format(sdfDB.parse(startTime)));
			cellB.setCellStyle(headingStyle);
			Cell cell2 = row2.createCell(2);
			cell2.setCellValue("TripEnd Date: ");
			cell2.setCellStyle(headingStyle);
			Cell cell3 = row2.createCell(3);
			cell3.setCellValue(mmddyyy.format(sdfDB.parse(endTime)));
			cell3.setCellStyle(headingStyle);

			Row headerRow = sheet.createRow(5);
			Map<ArrayList<Integer>, ArrayList<String>> userList = getList(con, systemId, customerId, userId, "CEREPORT");
			if (userList != null) {
				Set<Entry<ArrayList<Integer>, ArrayList<String>>> set = userList.entrySet();
				Iterator<Entry<ArrayList<Integer>, ArrayList<String>>> itr = set.iterator();
				if (itr.hasNext()) {
					Entry<ArrayList<Integer>, ArrayList<String>> entry = itr.next();
					userVisibiltyList = entry.getKey();
					userColumnList = entry.getValue();

					for (int i = 0; i < userColumnList.size(); i++) {
						Cell cell = headerRow.createCell(i);
						cell.setCellValue(userColumnList.get(i));
						cell.setCellStyle(my_style);
					}
				}
			} else {
				arrayList = new ArrayList<String>(Arrays.asList(CEarray));
				formatList = new ArrayList<String>(Arrays.asList(CEformatter));
				for (int i = 0; i < arrayList.size(); i++) {
					Cell cell = headerRow.createCell(i);
					cell.setCellValue(arrayList.get(i));
					cell.setCellStyle(my_style);
				}
			}

			// Create Cell Style for formatting Date
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
			//blankOrNAStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

			Font font = null;
			font = workbook.createFont();
			font.setBoldweight(Font.BOLDWEIGHT_BOLD);

			CellStyle summaryStyle = workbook.createCellStyle();
			summaryStyle.setFont(font);
			summaryStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			summaryStyle.setBorderTop((short) 1); // single line border
			summaryStyle.setBorderBottom((short) 1); // single line border

			int rowNum = 6;
			pstmt = con.prepareStatement(getTripCreationInfo);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startTime);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endTime);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				Row row = sheet.createRow(rowNum++);
				json = new JSONObject();
				json.put("Sl. No.", ++count);
				json.put("Indent Number", rs.getString("INDENT_NUMBER"));
				json.put("Placement Date", rs.getString("PLACEMENT_DATETIME").contains("1900") ? "" : mmddyyy
						.format(sdfDB.parse(rs.getString("PLACEMENT_DATETIME"))));
				json.put("Trip Number", rs.getString("TRIPNUMBER"));
				json.put("Customer Ref. No.", rs.getString("CUSTOMER_REFERENCE_ID"));
				json.put("Placement Type", rs.getString("PLACEMENT_TYPE"));
				json.put("Client Name", rs.getString("CLIENT_NAME"));
				status = rs.getString("STATUS");
				if (rs.getString("PLACEMENT_DATETIME").contains("1900")) {
					if (status.equals("In-transit")) {
						status = "Enroute Placement";
					}
				}
				json.put("Status", status);
				json.put("Origin", rs.getString("ORIGIN"));
				//////

				getTouchPointDetails(con, rs, rs.getInt("TRIP_ID"), json, rs.getString("departureDatetime"), rs
						.getString("ATA"), rs.getLong("actualTransitTime"));
				json.put("Destination", rs.getString("DESTINATION"));
				//json.put("Route", rs.getString("ROUTE")); 
				json.put("Vehicle Size", rs.getString("VEHICLE_SIZE"));
				json.put("Vehicle Type", rs.getString("VEHICLE_TYPE"));
				json.put("Vehicle ID", rs.getString("VEHICLEID"));
				json.put("Scheduled Report Date/Time", rs.getString("SCHEDULEDREPORT_DATETIME").contains("1900") ? ""
						: mmddyyy.format(sdfDB.parse(rs.getString("SCHEDULEDREPORT_DATETIME"))));
				json.put("Actual Report Date/Time", rs.getString("ACTUALREPORT_DATETIME").contains("1900") ? ""
						: mmddyyy.format(sdfDB.parse(rs.getString("ACTUALREPORT_DATETIME"))));
				if (rs.getInt("PLACEMENT_DEVIATION") < 0) {
					placementDeviation = cf.convertMinutesToHHMMFormatNegative(rs.getInt("PLACEMENT_DEVIATION"));
				} else if (rs.getInt("PLACEMENT_DEVIATION") > 0) {
					placementDeviation = cf.convertMinutesToHHMMFormat(rs.getInt("PLACEMENT_DEVIATION"));
				}
				json.put("Placement deviation", placementDeviation);
				placementDeviation = "00:00";
				json.put("Placement Status", rs.getString("PLACEMENT_STATUS"));
				json.put("Scheduled Dep Date/Time", rs.getString("SCHEDULEDDEP_DATETIME").contains("1900") ? ""
						: mmddyyy.format(sdfDB.parse(rs.getString("SCHEDULEDDEP_DATETIME"))));
				json.put("Actual Dep Date/Time", rs.getString("ACTUALDEP_DATETIME").contains("1900") ? "" : mmddyyy
						.format(sdfDB.parse(rs.getString("ACTUALDEP_DATETIME"))));
				if (rs.getLong("DISPATCH_VARIATION") != 0) {
					dispatchDeviation = formattedHoursMinutesSeconds(rs.getLong("DISPATCH_VARIATION"));
				}
				json.put("Dispatch Variation", dispatchDeviation);
				dispatchDeviation = "00:00:00";
				json.put("Dispatch Status", rs.getString("DISPATCH_STATUS"));
				//if(rs.getLong("LOADING_DETENTION")!=0)
				if (rs.getLong("LOADING_DETENTION") > 0) {
					loadingDetention = formattedHoursMinutesSeconds(rs.getLong("LOADING_DETENTION"));
				}
				json.put("Loading Detention", loadingDetention);
				loadingDetention = "00:00:00";
				//if(rs.getLong("UNLOADING_DETENTION")!=0)
				if (rs.getLong("UNLOADING_DETENTION") > 0) {
					unloadingDetention = formattedHoursMinutesSeconds(rs.getLong("UNLOADING_DETENTION"));
				}
				json.put("Unloading Detention", unloadingDetention);
				unloadingDetention = "00:00:00";
				json.put("Estimated Arrival", rs.getString("ESTIMATED_ARRIVAL").contains("1900") ? "" : mmddyyy
						.format(sdfDB.parse(rs.getString("ESTIMATED_ARRIVAL"))));
				json.put("Actual Arrival", rs.getString("ACTUAL_ARRIVAL").contains("1900") ? "" : mmddyyy.format(sdfDB
						.parse(rs.getString("ACTUAL_ARRIVAL"))));
				json.put("Trip Closure", rs.getString("ACTUAL_TRIP_END_TIME").contains("1900") ? "" : mmddyyy
						.format(sdfDB.parse(rs.getString("ACTUAL_TRIP_END_TIME"))));
				if (rs.getLong("AGREED_TAT") != 0) {
					agreedTAT = formattedHoursMinutesSeconds(rs.getLong("AGREED_TAT"));
				}
				json.put("AgreedTAT -incl.SH Stoppages", agreedTAT);
				agreedTAT = "00:00:00";
				json.put("Delay Sub Bucket", rs.getString("DELAY_SUB_BUCKET"));
				json.put("ATP", rs.getString("ACTUALREPORT_DATETIME").contains("1900") ? "" : mmddyyy.format(sdfDB
						.parse(rs.getString("ACTUALREPORT_DATETIME"))));
				json.put("Delay Remarks", rs.getString("DELAY_REMARKS"));
				json.put("Actual CHDetention", formattedHoursMinutesSeconds(rs.getLong("ACT_CHDetention")));

				if (status.equalsIgnoreCase("Completed")) {

					json.put("Avg Speed", df2.format(rs.getDouble("avgSpeed")));
				} else {
					json.put("Avg Speed", "");
				}

				json.put("Planned CHDetention", formattedHoursMinutesSeconds(rs.getLong("PLANNED_CHDetention")));
				int colno = 0;
				if (userList != null) {
					for (int i = 0; i < arrayList.size(); i++) {
						try {
							int visbilble = userVisibiltyList.get(i);
							if (visbilble == 0) {
								continue;
							} else {
								Cell cell = row.createCell(colno++);
								String format = formatList.get(i);
								String val = json.getString(arrayList.get(i)).trim();

								val = (val == null) ? "" : val;
								if (val.equalsIgnoreCase("") || val.equalsIgnoreCase("NA")) {
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

									} else if (format.equalsIgnoreCase("int")) {
										cell.setCellValue(Integer.valueOf(val));
										cell.setCellStyle(integerStyle);
									} else if (format.equalsIgnoreCase("timeformat")) {
										cell.setCellValue(val);
										cell.setCellStyle(timecellStyle);
									} else if (format.equalsIgnoreCase("default")) {
										cell.setCellValue(val);
										cell.setCellStyle(timeCellStyle);
									} else {
										boolean numeric = true;
										try {
											@SuppressWarnings("unused")
											Double num = Double.parseDouble(val);
										} catch (NumberFormatException e) {
											numeric = false;
										}
										double nval = (numeric) ? Double.valueOf(val) : 0;
										cell.setCellValue(nval);
										cell.setCellStyle(decimalStyle);

									}
								}
							}
						} catch (JSONException e) {
						} catch (Exception e) {
						}
					}
				} else {

					for (int i = 0; i < arrayList.size(); i++) {
						try {
							Cell cell = row.createCell(i);
							cell.setCellStyle(blankOrNAStyle);
							String format = formatList.get(i);
							String val = json.getString(arrayList.get(i)).trim();
							val = (val == null) ? "" : val;

							if (val.equalsIgnoreCase("") || val.equalsIgnoreCase("NA")) {
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

								} else if (format.equalsIgnoreCase("int")) {
									cell.setCellValue(Integer.valueOf(val));
									cell.setCellStyle(integerStyle);
								} else if (format.equalsIgnoreCase("timeformat")) {
									cell.setCellValue(val);
									cell.setCellStyle(timecellStyle);
								} else if (format.equalsIgnoreCase("default")) {
									cell.setCellValue(val);
									cell.setCellStyle(timeCellStyle);
								} else {
									boolean numeric = true;
									try {
										@SuppressWarnings("unused")
										Double num = Double.parseDouble(val);
									} catch (NumberFormatException e) {
										numeric = false;
									}
									double nval = (numeric) ? Double.valueOf(val) : 0;
									cell.setCellValue(nval);
									cell.setCellStyle(decimalStyle);

								}
							}
						} catch (JSONException e) {
						} catch (Exception e) {
						}
					}
				}

				jsonArray.put(json);
			}

			FileOutputStream fileOut = new FileOutputStream(completePath);
			workbook.write(fileOut);
			fileOut.flush();
			fileOut.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Date d2 = new Date();
			long diff = d2.getTime() - d1.getTime();
			//System.out.println("time taken to complete the cycle :::" + diff + "\t" + formattedHoursMinutesSeconds((diff / 1000) / 60));
			DBConnection.releaseConnectionToDB(con, pstmt, rs);

		}
		return completePath;

	}

	private void getTouchPointDetails(Connection con, ResultSet rs1, int tripId, JSONObject json,
			String departureDatetime, String ATA, Long overallTAT) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = con.prepareStatement(GET_DES_HUB_DETAILS_CEREPORT.replaceAll("AMS.dbo.LOCATION",
					"AMS.dbo.LOCATION_ZONE_A"));
			pstmt.setInt(1, tripId);
			rs = pstmt.executeQuery();
			int touchpointCount = 0;
			long actualPlanedn = 0;
			long detention = 0;
			long detention1 = 0;
			long detention2 = 0;
			long detention3 = 0;
			String touchPoint1Detention = "00:00:00";
			String touchPoint2Detention = "00:00:00";
			String touchPoint3Detention = "00:00:00";
			String delayFormat = "00.00";
			String routeKey = "";
			long custdetention1 = 0;
			long custdetention2 = 0;
			long custdetention3 = 0;
			long custdetention = 0;
			long dhldetention1 = 0;
			long dhldetention2 = 0;
			long dhldetention3 = 0;
			long dhldetention = 0;
			//long actualTAT =0;
			//long actualTATForAvgSpeed=0;
			String overallTT = "00:00:00";
			String actualTT = "00:00:00";
			ATA = rs1.getString("ATA");
			while (rs.next()) {
				int seqNo = rs.getInt("SEQUENCE");
				if (seqNo != 0 && seqNo != 100) {
					touchpointCount++;
					long departuredelay = rs.getLong("DEPARTUREDELAY");
					actualPlanedn += departuredelay; // total planned stoppage
					switch (touchpointCount) {
					case 1:
						json.put("Touch Point 1", rs.getString("touchPointName"));
						json.put("Touchpoint 1 Arrival", rs.getString("TOUCHPOINT_ARRIVAL").contains("1900") ? ""
								: mmddyyy.format(sdfDB.parse(rs.getString("TOUCHPOINT_ARRIVAL"))));
						json.put("Touchpoint 1 Departure", rs.getString("TOUCHPOINT_DEPARTURE").contains("1900") ? ""
								: mmddyyy.format(sdfDB.parse(rs.getString("TOUCHPOINT_DEPARTURE"))));
						detention1 = rs.getLong("TOUCHPOINT_DETENTION");
						if (rs.getLong("TOUCHPOINT_DETENTION") != 0) {
							touchPoint1Detention = formattedHoursMinutesSeconds(rs.getLong("TOUCHPOINT_DETENTION"));
						}
						json.put("Touch point1 Detention", touchPoint1Detention);
						if (!rs.getString("NAME").startsWith("SH")) {
							custdetention1 = rs.getLong("TOUCHPOINT_DETENTION");
						} else {
							dhldetention1 = rs.getLong("TOUCHPOINT_DETENTION");
						}
						break;
					case 2:
						json.put("Touch Point 2", rs.getString("touchPointName"));
						json.put("Touchpoint 2 Arrival", rs.getString("TOUCHPOINT_ARRIVAL").contains("1900") ? ""
								: mmddyyy.format(sdfDB.parse(rs.getString("TOUCHPOINT_ARRIVAL"))));
						json.put("Touchpoint 2 Departure", rs.getString("TOUCHPOINT_DEPARTURE").contains("1900") ? ""
								: mmddyyy.format(sdfDB.parse(rs.getString("TOUCHPOINT_DEPARTURE"))));
						detention2 = rs.getLong("TOUCHPOINT_DETENTION");
						if (rs.getLong("TOUCHPOINT_DETENTION") != 0) {
							touchPoint2Detention = formattedHoursMinutesSeconds(rs.getLong("TOUCHPOINT_DETENTION"));
						}
						json.put("Touch point2 Detention", touchPoint2Detention);
						if (!rs.getString("NAME").startsWith("SH")) {
							custdetention2 = rs.getLong("TOUCHPOINT_DETENTION");
						} else {
							dhldetention2 = rs.getLong("TOUCHPOINT_DETENTION");
						}
						break;
					case 3:
						json.put("Touch Point 3", rs.getString("touchPointName"));
						json.put("Touchpoint 3 Arrival", rs.getString("TOUCHPOINT_ARRIVAL").contains("1900") ? ""
								: mmddyyy.format(sdfDB.parse(rs.getString("TOUCHPOINT_ARRIVAL"))));
						json.put("Touchpoint 3 Departure", rs.getString("TOUCHPOINT_DEPARTURE").contains("1900") ? ""
								: mmddyyy.format(sdfDB.parse(rs.getString("TOUCHPOINT_DEPARTURE"))));
						detention3 = rs.getLong("TOUCHPOINT_DETENTION");
						if (rs.getLong("TOUCHPOINT_DETENTION") != 0) {
							touchPoint3Detention = formattedHoursMinutesSeconds(rs.getLong("TOUCHPOINT_DETENTION"));
						}
						json.put("Touch point3 Detention", touchPoint3Detention);
						if (!rs.getString("NAME").startsWith("SH")) {
							custdetention3 = rs.getLong("TOUCHPOINT_DETENTION");
						} else {
							dhldetention3 = rs.getLong("TOUCHPOINT_DETENTION");
						}
						break;
					case 4:
						json.put("Touch Point 4", rs.getString("touchPointName"));
						break;
					default:
						break;
					}
				}
				routeKey = routeKey + "_" + rs.getString("HUB_CITY");
			}

			if (routeKey.length() > 1) {
				routeKey = routeKey.substring(1);
			}
			json.put("Route", routeKey);
			custdetention = custdetention1 + custdetention2 + custdetention3;
			dhldetention = dhldetention1 + dhldetention2 + dhldetention3;
			if (rs1.getString("TRIPSTATUS").equals("CLOSED")) {
				custdetention = custdetention + rs1.getLong("traffic_delay");
			}
			if (custdetention > 0) {
				json.put("Uncontrollable TAT", formattedHoursMinutesSeconds(custdetention));
			} else {
				json.put("Uncontrollable TAT", "00:00:00");
			}
			if (overallTAT != 0) {
				overallTT = formattedHoursMinutesSeconds(overallTAT);
				if (custdetention > 0) {
					actualTAT = overallTAT - custdetention;
				} else {
					actualTAT = overallTAT;
				}
				actualTT = formattedHoursMinutesSeconds(actualTAT);
			}
			json.put("OverallTAT -incl.SH Stoppages", overallTT);
			json.put("Actual TAT", actualTT);
			long delay = rs1.getLong("AGREED_TAT") - actualTAT;

			//System.out.println("Second occurance "+actualTATForAvgSpeed);

			if (rs1.getString("TRIPSTATUS").equals("CANCEL")) {
				delayFormat = "00.00";
				json.put("Transit Performance", "");
				json.put("Delay Bucket", "");
			} else {
				if (delay < 0) {
					delayFormat = cf.convertMinutesToHHMMFormatNegative(Integer.parseInt(String.valueOf(delay)));
					json.put("Transit Performance", "Delayed");
					if (rs1.getLong("traffic_delay") > 0) {
						json.put("Delay Bucket", "Force Majeure");
					} else if (custdetention > 0) {
						json.put("Delay Bucket", "Customer Controllable");
					} else if (rs1.getLong("traffic_delay") > 0 && custdetention > 0) {
						json.put("Delay Bucket", "Force Majeure" + "," + "Customer Controllable");
					} else {
						json.put("Delay Bucket", "DHL Controllable");
					}
				} else {
					delayFormat = cf.convertMinutesToHHMMFormat(Integer.parseInt(String.valueOf(delay)));
					json.put("Transit Performance", "OnTime");
					json.put("Delay Bucket", "OnTime");
				}
			}

			json.put("Delay", delayFormat);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String getTripDetails(String startTime, String endTime, int systemId, int customerId, int offset, int userId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		JSONObject json = null;
		int count = 0;
		String completePath = null;
		ArrayList<String> arrayList = null;
		ArrayList<String> formatList = null;
		ArrayList<String> userarrayList = null;
		ArrayList<Integer> userformatList = null;
		Date d1 = new Date();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			arrayList = new ArrayList<String>(Arrays.asList(array));
			formatList = new ArrayList<String>(Arrays.asList(formatter));
			String customername = "DHL";
			Properties properties = ApplicationListener.prop;
			String rootPath = properties.getProperty("slaDashBoardExcelExport");
			completePath = rootPath + "//" + customername + "_SLA_REPORT_" + Calendar.getInstance().getTimeInMillis()
					+ ".xlsx";

			File f = new File(rootPath);
			if (!f.exists()) {
				f.mkdir();
			}

			// Create a Workbook
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

			// Create a Sheet
			Sheet sheet = workbook.createSheet("Trip Level");
			sheet.createFreezePane(0, 6);

			/*
			 * 
			 * main heading
			 */

			CellStyle headingStyle = workbook.createCellStyle();
			// Create a Font for styling header cells
			Font headingFont = workbook.createFont();
			// headerFont.setBoldweight(); //.setBoldweight(true);
			headingFont.setFontHeightInPoints((short) 16);
			headingFont.setColor(IndexedColors.DARK_BLUE.getIndex());
			headingStyle.setFont(headingFont);

			// Create a Row
			Row row1 = sheet.createRow(1);
			Cell cellA = row1.createCell(0);
			cellA.setCellValue("SLA Report");
			cellA.setCellStyle(headingStyle);

			// Create a Row
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

			// Create a Row
			Row headerRow = sheet.createRow(5);
			// Create cells
			Map<ArrayList<Integer>, ArrayList<String>> userList = getList(con, systemId, customerId, userId,
					"SLA_REPORT");
			if (userList != null) {
				Set<Entry<ArrayList<Integer>, ArrayList<String>>> set = userList.entrySet();
				Iterator<Entry<ArrayList<Integer>, ArrayList<String>>> itr = set.iterator();
				if (itr.hasNext()) {
					Entry<ArrayList<Integer>, ArrayList<String>> entry = itr.next();
					userformatList = entry.getKey();
					userarrayList = entry.getValue();

					for (int i = 0; i < userarrayList.size(); i++) {
						Cell cell = headerRow.createCell(i);
						cell.setCellValue(userarrayList.get(i));
						if (userarrayList.get(i).contains("GREEN")) {
							cell.setCellStyle(greenCell);
						} else if (userarrayList.get(i).contains("YELLOW")) {
							cell.setCellStyle(yellowCell);
						} else if (userarrayList.get(i).contains("RED")) {
							cell.setCellStyle(redCell);
						} else {
							cell.setCellStyle(my_style);
						}

					}

				}
			} else {
				arrayList = new ArrayList<String>(Arrays.asList(array));
				formatList = new ArrayList<String>(Arrays.asList(formatter));
				for (int i = 0; i < arrayList.size(); i++) {
					Cell cell = headerRow.createCell(i);
					cell.setCellValue(arrayList.get(i));
					if (arrayList.get(i).contains("GREEN")) {
						cell.setCellStyle(greenCell);
					} else if (arrayList.get(i).contains("YELLOW")) {
						cell.setCellStyle(yellowCell);
					} else if (arrayList.get(i).contains("RED")) {
						cell.setCellStyle(redCell);
					} else {
						cell.setCellStyle(my_style);
					}

				}
			}

			// Create Cell Style for formatting Date
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

			int rowNum = 6;
			pstmt = con.prepareStatement(getTripInformation);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startTime);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endTime);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				Row row = sheet.createRow(rowNum++);
				json = new JSONObject();
				int tripId = rs.getInt("TRIP_ID");
				String tripStatus = rs.getString("TRIP_STATUS");
				String tripCreateTime = rs.getString("TRIP_CREATE_TIME");
				String ATD = rs.getString("ATD");
				String routeKey = rs.getString("ROUTE_KEY");
				json.put("tripId", tripId);
				json.put("Sl. No.", ++count);
				json.put("Trip Creation Time", mmddyyy.format(sdfDB.parse(tripCreateTime)));
				json.put("Trip Creation Month", rs.getString("TRIP_CREATION_MONTH"));
				json.put("Trip ID", rs.getString("SHIPMENT_ID"));
				json.put("Trip No.", rs.getString("ORDER_ID"));
				json.put("Trip Type", rs.getString("PRODUCT_LINE"));
				json.put("Trip Category", rs.getString("TRIP_CATEGORY"));
				json.put("Route ID", rs.getString("ROUTE_NAME"));
				json.put("Make of Vehicle", rs.getString("MODEL_NAME"));
				json.put("Type of Vehicle", rs.getString("VEHICLE_TYPE"));
				json.put("Vehicle Number", rs.getString("ASSET_NUMBER"));
				json.put("Customer Type", rs.getString("CUSTOMER_TYPE"));
				json.put("Customer Name", rs.getString("CUSTOMER_NAME"));
				json.put("Customer Reference ID", rs.getString("CUSTOMER_REFERENCE_ID"));
				json.put("Driver " + 1 + " Name", rs.getString("DRIVER_1_NAME"));
				json.put("Driver " + 1 + " Contact", rs.getString("DRIVER_1_CONTACT"));
				json.put("Driver " + 2 + " Name", rs.getString("DRIVER_2_NAME"));
				json.put("Driver " + 2 + " Contact", rs.getString("DRIVER_2_CONTACT"));
				json.put("Driver " + 3 + " Name", rs.getString("DRIVER_3_NAME"));
				json.put("Driver " + 3 + " Contact", rs.getString("DRIVER_3_CONTACT"));
				json.put("Driver " + 4 + " Name", rs.getString("DRIVER_4_NAME"));
				json.put("Driver " + 4 + " Contact", rs.getString("DRIVER_4_CONTACT"));
				json.put("Driver " + 5 + " Name", rs.getString("DRIVER_5_NAME"));
				json.put("Driver " + 5 + " Contact", rs.getString("DRIVER_5_CONTACT"));
				json.put("Driver " + 6 + " Name", rs.getString("DRIVER_6_NAME"));
				json.put("Driver " + 6 + " Contact", rs.getString("DRIVER_6_CONTACT"));
				json.put("Driver " + 7 + " Name", rs.getString("DRIVER_7_NAME"));
				json.put("Driver " + 7 + " Contact", rs.getString("DRIVER_7_CONTACT"));

				if (tripStatus.contains("OPEN")) {
					json.put("Location", rs.getString("CURRENT_LOCATION"));
					String eta = rs.getString("DESTINATION_ETA");
					json.put("ETA", eta.contains("1900") ? "" : mmddyyy.format(sdfDB.parse(eta)));
					json.put("Next touching point", rs.getString("NEXT_POINT"));
					json.put("Distance to next touching point", rs.getString("NEXT_POINT_DISTANCE"));
					json.put("ETA to next touching point", rs.getString("NEXT_POINT_ETA").contains("1900") ? ""
							: mmddyyy.format(sdfDB.parse(rs.getString("NEXT_POINT_ETA"))));
					json.put("Total Truck Running Time (HH:mm:ss)", rs.getString("RUNNING_TIME"));
					json.put("Transit Delay (HH:mm:ss)", rs.getString("TRANSIT_DELAY"));
					json.put("Temp @ Reefer(Actual Temperature at ATA (°C))",
							rs.getString("REEFER_TEMP").equals("0") ? "" : rs.getString("REEFER_TEMP"));
					json.put("Temp @ Middle(Actual Temperature at ATA (°C))",
							rs.getString("MIDDLE_TEMP").equals("0") ? "" : rs.getString("MIDDLE_TEMP"));
					json.put("Temp @ Door(Actual Temperature at ATA (°C))", rs.getString("DOOR_TEMP").equals("0") ? ""
							: rs.getString("DOOR_TEMP"));
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
					json.put("Location", rs.getString("END_LOCATION"));

					json.put("ETA", "");
					json.put("Next touching point", "");
					json.put("Distance to next touching point", "");
					json.put("ETA to next touching point", "");
					json.put("Temp @ Reefer(Actual Temperature at ATA (°C))", rs.getString("REEFER_TEMP"));
					json.put("Temp @ Middle(Actual Temperature at ATA (°C))", rs.getString("MIDDLE_TEMP"));
					json.put("Temp @ Door(Actual Temperature at ATA (°C))", rs.getString("DOOR_TEMP"));
				}

				json.put("Route Key", routeKey);

				// ------------------------------------------------ SEQUENCE
				// DETAILS --------------------------------------

				// ------------------------------------------------ SEQUENCE
				// DETAILS SOURCE HUB STARTS
				// --------------------------------------
				json.put("Origin Hub", rs.getString("ORIGIN_HUB"));
				json.put("Origin City", rs.getString("ORIGIN_CITY"));// orginCity.equalsIgnoreCase("")
				json.put("Source Pincode", rs.getString("SOURCE_PINCODE"));
				json.put("Origin State", rs.getString("ORIGIN_STATE"));

				json.put("STP", rs.getString("STP").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs
						.getString("STP"))));
				json.put("ATP", rs.getString("ATP").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs
						.getString("ATP"))));
				json.put("Placement Delay (HH:mm:ss)", rs.getString("PLACEMENT_DELAY"));
				json.put("Origin Hub Stoppage Allowed (HH:mm:ss)", rs.getString("ORIGIN_STOPPAGE_ALLOWED"));

				json.put("Origin Hub Stoppage Actual Duration (HH:mm:ss)", rs.getString("ORIGIN_STOPPAGE_DURATION"));
				json.put("Origin Hub (Loading) Detention (HH:mm:ss)", rs.getString("ORIGIN_LOADING_DETENTION"));

				// ------------------------------------------------ SEQUENCE
				// DETAILS SOURCE HUB ENDS
				// --------------------------------------

				// ------------------------------------------------ SEQUENCE
				// DETAILS DESTINATION HUB STARTS
				// --------------------------------------

				json.put("Destination Hub", rs.getString("DESTINATION_HUB"));

				json.put("Destination City", rs.getString("DESTINATION_CITY"));
				json.put("Destination Pincode", rs.getString("DESTINATION_PINCODE"));
				json.put("Destination State", rs.getString("DESTINATION_STATE"));
				json.put("Destination Hub Stoppage Allowed (HH:mm:ss)", rs.getString("DESTINATION_STOPPAGE_ALLOWED"));

				json.put("Destination Hub Stoppage Actual Duration (HH:mm:ss)", rs
						.getString("DESTINATION_STOPPAGE_DURATION"));
				json.put("Destination Hub (Unloading) Detention (HH:mm:ss)", rs
						.getString("DESTINATION_LOADING_DETENTION"));

				json.put("ATA", rs.getString("ATA").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs
						.getString("ATA"))));
				json.put("Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)", rs
						.getString("ACTUAL_TRANSIT_TIME"));

				if (!tripStatus.contains("OPEN")) {
					json.put("Transit Delay (HH:mm:ss)", rs.getString("TRANSIT_DELAY"));
				}
				// ------------------------------------------------ SEQUENCE
				// DETAILS DESTINATION HUB ENDS
				// --------------------------------------

				// ------------------------------------------------ SEQUENCE
				// DETAILS TOUCH POINTS STARTS
				// --------------------------------------

				json.put("Touching Point " + 1 + "", rs.getString("TOUCHPOINT_1"));
				json.put("Touching Point " + 1 + " Stoppage Allowed (HH:mm:ss)", rs
						.getString("TOUCHPOINT_1_STOPPAGE_ALLOWED"));
				json.put("Touching Point " + 1 + " Stoppage Actual Duration (HH:mm:ss)", rs
						.getString("TOUCHPOINT_1_DURATION"));
				json.put("Touching Point " + 1 + " Detention (HH:mm:ss)", rs.getString("TOUCHPOINT_1_DETENTION"));

				json.put("Touching Point " + 2 + "", rs.getString("TOUCHPOINT_2"));
				json.put("Touching Point " + 2 + " Stoppage Allowed (HH:mm:ss)", rs
						.getString("TOUCHPOINT_2_STOPPAGE_ALLOWED"));
				json.put("Touching Point " + 2 + " Stoppage Actual Duration (HH:mm:ss)", rs
						.getString("TOUCHPOINT_2_DURATION"));
				json.put("Touching Point " + 2 + " Detention (HH:mm:ss)", rs.getString("TOUCHPOINT_2_DETENTION"));

				json.put("Touching Point " + 3 + "", rs.getString("TOUCHPOINT_3"));
				json.put("Touching Point " + 3 + " Stoppage Allowed (HH:mm:ss)", rs
						.getString("TOUCHPOINT_3_STOPPAGE_ALLOWED"));
				json.put("Touching Point " + 3 + " Stoppage Actual Duration (HH:mm:ss)", rs
						.getString("TOUCHPOINT_3_DURATION"));
				json.put("Touching Point " + 3 + " Detention (HH:mm:ss)", rs.getString("TOUCHPOINT_3_DETENTION"));

				json.put("Touching Point " + 4 + "", rs.getString("TOUCHPOINT_4"));
				json.put("Touching Point " + 4 + " Stoppage Allowed (HH:mm:ss)", rs
						.getString("TOUCHPOINT_4_STOPPAGE_ALLOWED"));
				json.put("Touching Point " + 4 + " Stoppage Actual Duration (HH:mm:ss)", rs
						.getString("TOUCHPOINT_4_DURATION"));
				json.put("Touching Point " + 4 + " Detention (HH:mm:ss)", rs.getString("TOUCHPOINT_4_DETENTION"));

				json.put("Touching Point " + 5 + "", rs.getString("TOUCHPOINT_5"));
				json.put("Touching Point " + 5 + " Stoppage Allowed (HH:mm:ss)", rs
						.getString("TOUCHPOINT_5_STOPPAGE_ALLOWED"));
				json.put("Touching Point " + 5 + " Stoppage Actual Duration (HH:mm:ss)", rs
						.getString("TOUCHPOINT_5_DURATION"));
				json.put("Touching Point " + 5 + " Detention (HH:mm:ss)", rs.getString("TOUCHPOINT_5_DETENTION"));

				json.put("Touching Point " + 6 + "", rs.getString("TOUCHPOINT_6"));
				json.put("Touching Point " + 6 + " Stoppage Allowed (HH:mm:ss)", rs
						.getString("TOUCHPOINT_6_STOPPAGE_ALLOWED"));
				json.put("Touching Point " + 6 + " Stoppage Actual Duration (HH:mm:ss)", rs
						.getString("TOUCHPOINT_6_DURATION"));
				json.put("Touching Point " + 6 + " Detention (HH:mm:ss)", rs.getString("TOUCHPOINT_6_DETENTION"));

				json.put("Touching Point " + 7 + "", rs.getString("TOUCHPOINT_7"));
				json.put("Touching Point " + 7 + " Stoppage Allowed (HH:mm:ss)", rs
						.getString("TOUCHPOINT_7_STOPPAGE_ALLOWED"));
				json.put("Touching Point " + 7 + " Stoppage Actual Duration (HH:mm:ss)", rs
						.getString("TOUCHPOINT_7_DURATION"));
				json.put("Touching Point " + 7 + " Detention (HH:mm:ss)", rs.getString("TOUCHPOINT_7_DETENTION"));

				json.put("Total In-transit Planned Customer Hub Stoppage Allowed (HH:mm:ss)", rs
						.getString("CH_STOPPAGE_ALLOWED"));
				json.put("Total In-transit Planned Customer Hub Stoppage Actual Duration (HH:mm:ss)", rs
						.getString("CH_STOPPAGE_DURATION"));

				json.put("Total In-transit Planned Customer Hub Stoppage Detention (HH:mm:ss)", rs
						.getString("CH_STOPPAGE_DETENTION"));
				json.put("Total In-transit Planned SmartHub Stoppage Allowed (HH:mm:ss)", rs
						.getString("SH_STOPPAGE_ALLOWED"));
				json.put("Total In-transit Planned SmartHub Stoppage Actual Duration (HH:mm:ss)", rs
						.getString("SH_STOPPAGE_DURATION"));

				json.put("Total In-transit Planned SmartHub Stoppage Detention (HH:mm:ss)", rs
						.getString("SH_STOPPAGE_DETENTION"));

				json.put("Unplanned Stoppage (HH:mm:ss)", rs.getString("UNPLANNED_STOPPAGE"));

				json.put("Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)", rs
						.getString("REEFER_GREEN"));
				json.put("Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)", rs
						.getString("MIDDLE_GREEN"));
				json.put("Door(GREEN-BAND) - Temp Duration % (% of actual transit time)", rs.getString("DOOR_GREEN"));
				json.put("Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)", rs
						.getString("REEFER_YELLOW"));
				json.put("Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)", rs
						.getString("MIDDLE_YELLOW"));
				json.put("Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)", rs.getString("DOOR_YELLOW"));
				json.put("Reefer(RED-BAND) - Temp Duration % (% of actual transit time)", rs.getString("REFFER_RED"));
				json.put("Middle(RED-BAND) - Temp Duration % (% of actual transit time)", rs.getString("MIDDLE_RED"));
				json.put("Door(RED-BAND) - Temp Duration % (% of actual transit time)", rs.getString("DOOR_RED"));

				json.put("Total Truck Running Time (HH:mm:ss)", rs.getString("RUNNING_TIME"));

				json.put("STD", rs.getString("STD").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(rs
						.getString("STD"))));

				json.put("STA wrt STD", rs.getString("STA_WRT_STD").contains("1900") ? "" : mmddyyy.format(sdfDB
						.parse(rs.getString("STA_WRT_STD"))));

				json.put("ATD", rs.getString("ATD").contains("1900") ? "" : mmddyyy.format(sdfDB.parse(ATD)));
				json.put("Departure Delay wrt STD (HH:mm:ss)", rs.getString("DEP_DELAY_WRT_ATD"));

				json.put("STA wrt ATD", rs.getString("STA_WRT_ATD").contains("1900") ? "" : mmddyyy.format(sdfDB
						.parse(rs.getString("STA_WRT_ATD"))));
				json.put("Planned Transit Time (incl. planned stoppages) (HH:mm:ss)", rs
						.getString("PLANNED_TRANSIT_TIME"));
				json.put("Trip Close/Canceled Time", (rs.getString("CANCELLED_DATE").equals("") || (rs
						.getString("CANCELLED_DATE").contains("1900"))) ? "" : mmddyyy.format((rs
						.getTimestamp("CANCELLED_DATE"))));
				json.put("Trip Status", rs.getString("TRIP_STATUS"));
				json.put("Reason for Delay", rs.getString("REASON_FOR_DELAY"));
				json.put("Reason for Cancellation", rs.getString("REASON_FOR_CANCELLATION"));

				json.put("Ops Dry Run (kms)", rs.getDouble("OPS_DRYRUN_KMS"));
				json.put("Customer Dry Run (kms)", rs.getDouble("CUSTOMER_DRYRUN"));

				json.put("Trip Distance (kms)", rs.getDouble("ACTUAL_DISTANCE"));
				json.put("Total Distance (kms)", rs.getString("TOTAL_DISTANCE"));
				json.put("Average Speed (kms/h)", rs.getDouble("AVG_SPEED"));
				json.put("Fuel Consumed(L)", rs.getDouble("FUEL_CONSUMED"));
				json.put("LLS Mileage (kms/L)", rs.getDouble("LLS_MILEAGE"));
				json.put("OBD Mileage (kms/L)", rs.getDouble("OBD_MILEAGE"));

				json.put("Temperature required", rs.getString("REQ_TEMPERATURE"));
				json.put("Precooling  Setup Time", (rs.getString("PRECOOLING_SETUP_TIME").equals("") || rs.getString(
						"PRECOOLING_SETUP_TIME").contains("1900")) ? "" : mmddyyy.format(sdfDB.parse(rs
						.getString("PRECOOLING_SETUP_TIME"))));
				json.put("Precooling Achieved Time", (rs.getString("PRECOOLING_ACHIEVED_TIME").equals("") || rs
						.getString("PRECOOLING_ACHIEVED_TIME").contains("1900")) ? "" : mmddyyy.format(sdfDB.parse(rs
						.getString("PRECOOLING_ACHIEVED_TIME"))));
				json.put("Time to Achieve Precooling (HH:mm:ss)", rs.getString("TIME_TAKEN_TO_PRECOOL"));
				int colno = 0;
				if (userList != null) {
					for (int i = 0; i < arrayList.size(); i++) {
						try {
							int visbilble = userformatList.get(i);
							if (visbilble == 0) {
								continue;
							} else {
								Cell cell = row.createCell(colno++);
								String format = formatList.get(i);
								String val = json.getString(arrayList.get(i)).trim();
								val = (val == null) ? "" : val;
								if (val.equalsIgnoreCase("") || val.equalsIgnoreCase("NA")) {
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

									} else if (format.equalsIgnoreCase("int")) {
										cell.setCellValue(Integer.valueOf(val));
										cell.setCellStyle(integerStyle);
									} else if (format.equalsIgnoreCase("timeformat")) {
										cell.setCellValue(val);
										cell.setCellStyle(timecellStyle);
									} else if (format.equalsIgnoreCase("default")) {
										cell.setCellValue(val);
										cell.setCellStyle(timeCellStyle);
									} else {
										boolean numeric = true;
										try {
											@SuppressWarnings("unused")
											Double num = Double.parseDouble(val);
										} catch (NumberFormatException e) {
											numeric = false;
										}
										double nval = (numeric) ? Double.valueOf(val) : 0;
										cell.setCellValue(nval);
										cell.setCellStyle(decimalStyle);

									}
								}
							}
						} catch (JSONException e) {
						} catch (Exception e) {
						}
					}
				} else {
					for (int i = 0; i < arrayList.size(); i++) {
						try {

							Cell cell = row.createCell(i);
							String format = formatList.get(i);
							String val = json.getString(arrayList.get(i)).trim();
							val = (val == null) ? "" : val;
							if (val.equalsIgnoreCase("") || val.equalsIgnoreCase("NA")) {
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

								} else if (format.equalsIgnoreCase("int")) {
									cell.setCellValue(Integer.valueOf(val));
									cell.setCellStyle(integerStyle);
								} else if (format.equalsIgnoreCase("timeformat")) {
									cell.setCellValue(val);
									cell.setCellStyle(timecellStyle);
								} else if (format.equalsIgnoreCase("default")) {
									cell.setCellValue(val);
									cell.setCellStyle(timeCellStyle);
								} else {
									boolean numeric = true;
									try {
										@SuppressWarnings("unused")
										Double num = Double.parseDouble(val);
									} catch (NumberFormatException e) {
										numeric = false;
									}
									double nval = (numeric) ? Double.valueOf(val) : 0;
									cell.setCellValue(nval);
									cell.setCellStyle(decimalStyle);

								}
							}
						} catch (JSONException e) {
						} catch (Exception e) {
						}
					}
				}

				jsonArray.put(json);
			}

			FileOutputStream fileOut = new FileOutputStream(completePath);
			workbook.write(fileOut);
			fileOut.flush();
			fileOut.close();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			Date d2 = new Date();
			long diff = d2.getTime() - d1.getTime();
			//System.out.println("time taken to complete the cycle :::" + diff + "\t" + formattedHoursMinutesSeconds((diff / 1000) / 60));
			DBConnection.releaseConnectionToDB(con, pstmt, rs);

		}
		return completePath;
	}

	public JSONObject getDriverName(Connection con, int systemId, int customerId, int tripId, JSONObject json) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int evenCounter = 0;
		int oddCounter = 0;
		ArrayList<String> list = new ArrayList<String>();
		JSONArray driver1 = new JSONArray();
		JSONArray driver2 = new JSONArray();
		JSONObject obj = null;
		try {
			for (int j = 1; j <= 2; j++) {

				pstmt = con.prepareStatement(GET_DRIVER_DETAILS.replace("X", String.valueOf(j)));
				pstmt.setInt(1, tripId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					if (j == 1) {
						obj = new JSONObject();
						list = getDriverDetails(con, rs.getInt("DRIVER_1"), String.valueOf(systemId));
						obj.put("name", list.get(0));
						obj.put("mobile", list.get(1));
						driver1.put(obj);
					} else {
						obj = new JSONObject();
						list = getDriverDetails(con, rs.getInt("DRIVER_2"), String.valueOf(systemId));
						obj.put("name", list.get(0));
						obj.put("mobile", list.get(1));
						driver2.put(obj);
					}
				}
			}
			for (int s = 1; s < 7; s++) {
				if (s % 2 == 0) {
					JSONObject object = null;
					try {
						object = driver2.getJSONObject(evenCounter);
					} catch (Exception e) {
					}
					json.put("Driver " + s + " Name", object != null ? object.getString("name") : "");
					json.put("Driver " + s + " Contact", object != null ? object.getString("mobile") : "");
					evenCounter++;
				} else {
					JSONObject object = null;
					try {
						object = driver1.getJSONObject(oddCounter);
					} catch (Exception e) {
					}
					json.put("Driver " + s + " Name", object != null ? object.getString("name") : "");
					json.put("Driver " + s + " Contact", object != null ? object.getString("mobile") : "");
					oddCounter++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return json;
	}

	public JSONObject getSeqDetails(Connection con, int tripId, JSONObject json, String ATD, long plannedDuration,
			long totalStoppage, String tripStatus, String orginCity, String destCity, long GR, long GM, long GD,
			long YR, long YM, long YD, long RR, long RM, long RD, double travelTime, int offset, String zone) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int customerDetentionsInMs = 0;
		int dhlDetentionsInMs = 0;
		int customerActualStoppageInMs = 0;
		int dhlActualStoppageInMs = 0;
		try {
			pstmt = con.prepareStatement(GET_DES_HUB_DETAILS.replaceAll("330", "" + offset).replaceAll(
					"AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_" + zone)

			);
			pstmt.setInt(1, tripId);
			rs = pstmt.executeQuery();
			String STP = null;
			String ATP = null;
			int touchpointCount = 0;
			String ATA = "1900";
			long actualPlanedn = 0;
			while (rs.next()) {
				int seqNo = rs.getInt("SEQUENCE");
				json.put(rs.getString("NAME"), rs.getLong("DEPARTUREDELAY"));
				if (seqNo == 0) {
					long originDetn = rs.getLong("DETENTION_TIME");
					json.put("Origin Hub", rs.getString("touchPointName"));
					json.put("Origin City", orginCity.equalsIgnoreCase("") ? rs.getString("HUB_CITY") : orginCity);
					json.put("Source Pincode", rs.getString("srcPincode"));
					json.put("Origin State", rs.getString("HUB_STATE"));

					STP = rs.getString("PLANNED_ARR_DATETIME");
					if (STP.contains("1900")) {
						json.put("STP", "");
					} else {
						json.put("STP", mmddyyy.format(sdfDB.parse(STP)));
					}

					ATP = rs.getString("ACT_ARR_DATETIME");
					if (ATP.contains("1900")) {
						json.put("ATP", "");
					} else {
						json.put("ATP", mmddyyy.format(sdfDB.parse(ATP)));
					}

					if (ATP != null && ATP != null) {
						long placementDelay = rs.getLong("PLACEMENTDELAY");
						if (placementDelay != 0) {
							json.put("Placement Delay (HH:mm:ss)", formattedHoursMinutesSeconds(placementDelay));
						} else {
							json.put("Placement Delay (HH:mm:ss)", "");
						}

					} else {
						json.put("Placement Delay (HH:mm:ss)", "");
					}

					json.put("Origin Hub Stoppage Allowed (HH:mm:ss)",
							(originDetn > 0) ? formattedHoursMinutesSeconds(originDetn) : "");
					if (ATD.contains("1900") && ATP != null) {
						json.put("Origin Hub Stoppage Actual Duration (HH:mm:ss)", "");
						json.put("Origin Hub (Loading) Detention (HH:mm:ss)", "");
					} else {
						json.put("Origin Hub Stoppage Actual Duration (HH:mm:ss)", getFormattedHoursMinutes(ATD, ATP));
						long diff1 = getDiffinMS(ATD, ATP);
						long diff2 = originDetn * 60 * 1000;
						long difference = diff1 - diff2;
						long diffSeconds = difference / 1000 % 60;
						long diffMinutes = difference / (60 * 1000) % 60;
						long diffHours = difference / (60 * 60 * 1000);
						String hhmmssformat = df1.format(diffHours) + ":" + df1.format(diffMinutes) + ":"
								+ df1.format(diffSeconds);
						boolean negative = hhmmssformat.contains("-") ? true : false;
						String Timeformat = negative ? "-" + hhmmssformat.replaceAll("-", "") : hhmmssformat;

						json.put("Origin Hub (Loading) Detention (HH:mm:ss)", Timeformat);
					}

				}
				if (seqNo == 100) {
					ATA = rs.getString("ACT_ARR_DATETIME");
					long DesignDetn = rs.getLong("DETENTION_TIME");
					String departureDatetime = rs.getString("ACT_DEP_DATETIME");
					json.put("Destination Hub", (rs.getString("touchPointName") != null) ? rs
							.getString("touchPointName") : "");
					json.put("Destination City", destCity.equalsIgnoreCase("") ? rs.getString("HUB_CITY") : destCity);
					json.put("Destination Pincode", rs.getString("desPincode"));
					json.put("Destination State", (rs.getString("HUB_STATE") != null) ? rs.getString("HUB_STATE") : "");

					json.put("Destination Hub Stoppage Allowed (HH:mm:ss)",
							(DesignDetn > 0) ? formattedHoursMinutesSeconds(DesignDetn) : "");
					if (departureDatetime.contains("1900") || ATA.contains("1900")) {
						json.put("Destination Hub Stoppage Actual Duration (HH:mm:ss)", "");
						json.put("Destination Hub (Unloading) Detention (HH:mm:ss)", "");
					} else {

						String actualDuration = getFormattedHoursMinutes(departureDatetime, ATA);
						long difference = getDiffinMS(departureDatetime, ATA) - (DesignDetn * 60 * 1000);
						long diffSeconds = difference / 1000 % 60;
						long diffMinutes = difference / (60 * 1000) % 60;
						long diffHours = difference / (60 * 60 * 1000);
						String hhmmssformat = df1.format(diffHours) + ":" + df1.format(diffMinutes) + ":"
								+ df1.format(diffSeconds);
						boolean negative = hhmmssformat.contains("-") ? true : false;
						String Timeformat = negative ? "-" + hhmmssformat.replaceAll("-", "") : hhmmssformat;

						json.put("Destination Hub Stoppage Actual Duration (HH:mm:ss)", actualDuration);
						json.put("Destination Hub (Unloading) Detention (HH:mm:ss)", Timeformat);
					}

					if (ATA.contains("1900") || ATD.contains("1900")) {
						json.put("ATA", "");
						json.put("Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)", "");
						if (!tripStatus.equalsIgnoreCase("OPEN")) {
							json.put("Transit Delay (HH:mm:ss)", "");
						}
					} else {
						String actualTransit = getFormattedHoursMinutes(ATA, ATD);
						json.put("ATA", mmddyyy.format(sdfDB.parse(ATA)));
						json.put("Actual Transit Time incl. planned and unplanned stoppages (HH:mm:ss)", actualTransit);

						long diff2 = (plannedDuration * 60 * 1000);
						long diff1 = getDiffinMS(ATA, ATD);
						long difference = diff1 - diff2;
						long diffSeconds = difference / 1000 % 60;
						long diffMinutes = difference / (60 * 1000) % 60;
						long diffHours = difference / (60 * 60 * 1000);
						String hhmmssformat = df1.format(diffHours) + ":" + df1.format(diffMinutes) + ":"
								+ df1.format(diffSeconds);
						boolean negative = hhmmssformat.contains("-") ? true : false;
						String Timeformat = negative ? "-" + hhmmssformat.replaceAll("-", "") : hhmmssformat;

						if (!tripStatus.equalsIgnoreCase("OPEN")) {
							json.put("Transit Delay (HH:mm:ss)", (plannedDuration > 0) ? Timeformat : "");
						}

					}

				}

				if (seqNo != 0 && seqNo != 100) {
					++touchpointCount;
					long detention = rs.getLong("DETENTION_TIME");
					long departuredelay = rs.getLong("DEPARTUREDELAY");
					actualPlanedn += departuredelay;
					if (rs.getInt("OPERATION_ID") == 32) {
						customerDetentionsInMs += rs.getInt("DETENTION_TIME");
						customerActualStoppageInMs += rs.getInt("DEPARTUREDELAY");

					} else if (rs.getInt("OPERATION_ID") == 33) {
						dhlDetentionsInMs += rs.getInt("DETENTION_TIME");
						dhlActualStoppageInMs += rs.getInt("DEPARTUREDELAY");

					}

					json.put("Touching Point " + touchpointCount + "", rs.getString("touchPointName"));
					json.put("Touching Point " + touchpointCount + " Stoppage Allowed (HH:mm:ss)",
							formattedHoursMinutesSeconds(detention));
					if (departuredelay > 0) {

						json.put("Touching Point " + touchpointCount + " Stoppage Actual Duration (HH:mm:ss)",
								formattedHoursMinutesSeconds(departuredelay));
						long difference = (departuredelay * 60 * 1000) - (detention * 60 * 1000);
						long diffSeconds = difference / 1000 % 60;
						long diffMinutes = difference / (60 * 1000) % 60;
						long diffHours = difference / (60 * 60 * 1000);
						String hhmmssformat = df1.format(diffHours) + ":" + df1.format(diffMinutes) + ":"
								+ df1.format(diffSeconds);
						boolean negative = hhmmssformat.contains("-") ? true : false;
						String Timeformat = negative ? "-" + hhmmssformat.replaceAll("-", "") : hhmmssformat;

						json.put("Touching Point " + touchpointCount + " Detention (HH:mm:ss)", Timeformat);

					} else {
						json.put("Touching Point " + touchpointCount + " Stoppage Actual Duration (HH:mm:ss)", "");
						json.put("Touching Point " + touchpointCount + " Detention (HH:mm:ss)", "");

					}

				}

			}
			touchpointCount++;
			for (int i = touchpointCount; i < 8; i++) {
				json.put("Touching Point " + i + "", "");
				json.put("Touching Point " + i + " Stoppage Allowed (HH:mm:ss)", "");
				json.put("Touching Point " + i + " Stoppage Actual Duration (HH:mm:ss)", "");
				json.put("Touching Point " + i + " Detention (HH:mm:ss)", "");
			}

			json.put("Total In-transit Planned Customer Hub Stoppage Allowed (HH:mm:ss)",
					formattedHoursMinutesSeconds(customerDetentionsInMs));
			json.put("Total In-transit Planned Customer Hub Stoppage Actual Duration (HH:mm:ss)",
					formattedHoursMinutesSeconds(customerActualStoppageInMs));
			long difference = (customerActualStoppageInMs * 60 * 1000) - (customerDetentionsInMs * 60 * 1000);
			long diffSeconds = difference / 1000 % 60;
			long diffMinutes = difference / (60 * 1000) % 60;
			long diffHours = difference / (60 * 60 * 1000);
			String hhmmssformat = df1.format(diffHours) + ":" + df1.format(diffMinutes) + ":" + df1.format(diffSeconds);
			boolean negative = hhmmssformat.contains("-") ? true : false;
			String Timeformat = negative ? "-" + hhmmssformat.replaceAll("-", "") : hhmmssformat;

			json.put("Total In-transit Planned Customer Hub Stoppage Detention (HH:mm:ss)", Timeformat);
			json.put("Total In-transit Planned SmartHub Stoppage Allowed (HH:mm:ss)",
					formattedHoursMinutesSeconds(dhlDetentionsInMs));
			json.put("Total In-transit Planned SmartHub Stoppage Actual Duration (HH:mm:ss)",
					formattedHoursMinutesSeconds(dhlActualStoppageInMs));
			long difference1 = (dhlActualStoppageInMs * 60 * 1000) - (dhlDetentionsInMs * 60 * 1000);
			long diffSeconds1 = difference1 / 1000 % 60;
			long diffMinutes1 = difference1 / (60 * 1000) % 60;
			long diffHours1 = difference1 / (60 * 60 * 1000);
			String hhmmssformat1 = df1.format(diffHours1) + ":" + df1.format(diffMinutes1) + ":"
					+ df1.format(diffSeconds1);
			boolean negative1 = hhmmssformat1.contains("-") ? true : false;
			String Timeformat1 = negative1 ? "-" + hhmmssformat1.replaceAll("-", "") : hhmmssformat1;
			json.put("Total In-transit Planned SmartHub Stoppage Detention (HH:mm:ss)", Timeformat1);

			if ((totalStoppage - actualPlanedn) > 0) {
				json.put("Unplanned Stoppage (HH:mm:ss)", formattedHoursMinutesSeconds(totalStoppage - actualPlanedn));
			} else {
				json.put("Unplanned Stoppage (HH:mm:ss)", "00:00:00");
			}

			if (!tripStatus.equalsIgnoreCase("OPEN")) {
				if (travelTime > 0) {
					double gRefer = GR != 0 ? (GR * 100 / travelTime) : 0;
					double gMiddle = GM != 0 ? ((GM * 100) / travelTime) : 0;
					double gDoor = GD != 0 ? ((GD * 100) / travelTime) : 0;
					double yRefer = YR != 0 ? ((YR * 100) / travelTime) : 0;
					double yMiddle = YM != 0 ? ((YM * 100) / travelTime) : 0;
					double yDoor = YD != 0 ? ((YD * 100) / travelTime) : 0;
					double rRefer = RR != 0 ? ((RR * 100) / travelTime) : 0;
					double rMiddle = RM != 0 ? ((RM * 100) / travelTime) : 0;
					double rDoor = RD != 0 ? ((RD * 100) / travelTime) : 0;

					json.put("Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)", GM != 0 ? df2
							.format(gRefer)
							+ "%" : "");
					json.put("Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)", GD != 0 ? df2
							.format(gMiddle)
							+ "%" : "");
					json.put("Door(GREEN-BAND) - Temp Duration % (% of actual transit time)", GR != 0 ? df2
							.format(gDoor)
							+ "%" : "");
					json.put("Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)", YR != 0 ? df2
							.format(yRefer)
							+ "%" : "");
					json.put("Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)", YM != 0 ? df2
							.format(yMiddle)
							+ "%" : "");
					json.put("Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)", YD != 0 ? df2
							.format(yDoor)
							+ "%" : "");
					json.put("Reefer(RED-BAND) - Temp Duration % (% of actual transit time)", RR != 0 ? df2
							.format(rRefer)
							+ "%" : "");
					json.put("Middle(RED-BAND) - Temp Duration % (% of actual transit time)", RM != 0 ? df2
							.format(rMiddle)
							+ "%" : "");
					json.put("Door(RED-BAND) - Temp Duration % (% of actual transit time)", RD != 0 ? df2.format(rDoor)
							+ "%" : "");
				} else {
					json.put("Reefer(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");
					json.put("Middle(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");
					json.put("Door(GREEN-BAND) - Temp Duration % (% of actual transit time)", "");
					json.put("Reefer(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");
					json.put("Middle(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");
					json.put("Door(YELLOW-BAND) - Temp Duration % (% of actual transit time)", "");
					json.put("Reefer(RED-BAND) - Temp Duration % (% of actual transit time)", "");
					json.put("Middle(RED-BAND) - Temp Duration % (% of actual transit time)", "");
					json.put("Door(RED-BAND) - Temp Duration % (% of actual transit time)", "");

				}

				if (ATA.contains("1900") || ATD.contains("1900") || (ATD == null)) {
					json.put("Total Truck Running Time (HH:mm:ss)", "");

				} else {
					long ATAATD = getDiffinMS(ATA, ATD);
					long difference2 = ATAATD - ((totalStoppage * 60 * 1000));
					long diffSeconds2 = difference2 / 1000 % 60;
					long diffMinutes2 = difference2 / (60 * 1000) % 60;
					long diffHours2 = difference2 / (60 * 60 * 1000);
					String hhmmssformat2 = df1.format(diffHours2) + ":" + df1.format(diffMinutes2) + ":"
							+ df1.format(diffSeconds2);
					boolean negative2 = hhmmssformat2.contains("-") ? true : false;
					if (negative2) {
						json.put("Total Truck Running Time (HH:mm:ss)", "");
					} else {
						String Timeformat2 = negative2 ? "-" + hhmmssformat2.replaceAll("-", "") : hhmmssformat2;
						json.put("Total Truck Running Time (HH:mm:ss)", Timeformat2);
					}
				}

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return json;
	}

	public String getTemperaturerequired(Connection con, int tripId, String vehicleNo) {
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String tblData = "";
		try {
			pstmt1 = con.prepareStatement(CreateTripStatement.GET_TRIP_VEHICLE_TEMPERATURE_DETAILS);
			pstmt1.setInt(1, tripId);
			pstmt1.setString(2, vehicleNo);
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				double negativeMaxTemp = rs1.getDouble("MAX_NEGATIVE_TEMP");
				double negativeMinTemp = rs1.getDouble("MIN_NEGATIVE_TEMP");
				double positiveMaxTemp = rs1.getDouble("MAX_POSITIVE_TEMP");
				double positiveMinTemp = rs1.getDouble("MIN_POSITIVE_TEMP");
				double positiveMaxTemp2 = positiveMaxTemp;// +1;
				double negativeMinTemp2 = negativeMinTemp;// -1;
				tblData = "GREEN :" + negativeMaxTemp + " to " + positiveMinTemp + " YELLOW band:" + negativeMinTemp
						+ " to " + negativeMaxTemp + "; " + positiveMinTemp + " to " + positiveMaxTemp
						+ " RED band : -70 to " + negativeMinTemp2 + "; " + positiveMaxTemp2 + " to 70";
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return tblData;
	}

	public String getFormattedHoursMinutes(String date1, String date2) {
		String hhmmssformat = "";
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date d1 = null;
		Date d2 = null;
		String Timeformat = "";
		boolean negative = false;
		try {
			d1 = format.parse(date1);
			d2 = format.parse(date2);

			// in milliseconds
			long diff = d1.getTime() - d2.getTime();

			long diffSeconds = diff / 1000 % 60;
			long diffMinutes = diff / (60 * 1000) % 60;
			long diffHours = diff / (60 * 60 * 1000);
			hhmmssformat = df1.format(diffHours) + ":" + df1.format(diffMinutes) + ":" + df1.format(diffSeconds);
			negative = hhmmssformat.contains("-") ? true : false;
			Timeformat = negative ? "-" + hhmmssformat.replaceAll("-", "") : hhmmssformat;
		} catch (Exception e) {
			e.printStackTrace();

		}
		return Timeformat;

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
			hhmmssformat = df1.format(diffHours) + ":" + df1.format(diffMinutes) + ":" + df1.format(diffSeconds);
			negative = hhmmssformat.contains("-") ? true : false;
			format = negative ? "-" + hhmmssformat.replaceAll("-", "") : hhmmssformat;
		} catch (Exception e) {
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
			diff = d1.getTime() - d2.getTime();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return diff;

	}

	private ArrayList<String> getDriverDetails(Connection con, int driverId, String systemId) throws SQLException {
		ArrayList<String> driverDetails = new ArrayList<String>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		pstmt = con.prepareStatement(GET_DRIVER_NAME);
		pstmt.setInt(1, driverId);
		pstmt.setString(2, systemId);
		rs = pstmt.executeQuery();
		if (rs.next()) {
			driverDetails.add(rs.getString("DRIVER_NAME"));
			driverDetails.add(rs.getString("Mobile"));
		}
		return driverDetails;
	}

}
