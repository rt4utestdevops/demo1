package t4u.statements;

public class DemoCarStatements 
{

	public static final String GET_ASSOCIATED_HUBS = "select a.HUB_ID,b.NAME from dbo.ASSET_GROUP_HUB_ASSOCIATION a "+
					"left outer join LOCATION_ZONE b on b.HUBID=a.HUB_ID "+
					"where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.GROUP_ID=?";
	
	public static final String GET_NON_ASSOCIATED_HUBS = "select HUBID,NAME from LOCATION_ZONE where SYSTEMID=? and CLIENTID=? and HUBID>0 and RADIUS<>0 and OPERATION_ID in (1) and HUBID not in (select HUB_ID from dbo.ASSET_GROUP_HUB_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? and GROUP_ID=?) ";

	public static final String GET_GROUP_NAME_FOR_CLIENT = "select GROUP_ID,GROUP_NAME from VEHICLE_GROUP where CLIENT_ID=? and SYSTEM_ID=? order by GROUP_NAME";

	public static final String INSERT_INTO_ASSET_GROUP_HUB_ASSOCIATION = "insert into dbo.ASSET_GROUP_HUB_ASSOCIATION(SYSTEM_ID,CUSTOMER_ID,GROUP_ID,HUB_ID,CREATED_BY,CREATED_TIME) values(?,?,?,?,?,getUTCDate()) ";

	public static final String DELETE_FROM_ASSET_GROUP_HUB_ASSOCIATION = "delete from dbo.ASSET_GROUP_HUB_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? and GROUP_ID=? and HUB_ID=?";
	
	public static final String GET_DAILY_ASSET_UTILIZATION_DATA = "select b.GROUP_NAME,a.REGISTRATION_NUMBER,convert(decimal(18,2), a.TRAVEL_TIME) as TRAVEL_TIME,convert(decimal(18,2), a.DISTANCE_TRAVELLED) as DISTANCE_TRAVELLED,convert(decimal(18,2), a.OUTSIDE_HUB) as OUTSIDE_HUB,convert(decimal(18,2), a.INSIDE_HUB) as INSIDE_HUB,convert(decimal(18,2), a.PERCENTAGE) as PERCENTAGE from dbo.DAILY_ASSET_UTILIZATION a "+
	"inner join dbo.Vehicle_User vu on vu.Registration_no=a.REGISTRATION_NUMBER " +
	"left outer join dbo.VEHICLE_GROUP b on b.GROUP_ID=a.GROUP_ID "+
	"where a.DATE_GMT=dateadd(mi,-?,?) and a.SYSTEM_ID=? and a.CUSTOMER_ID=? and vu.User_id=? ";
	
	public static final String GET_HOLIDAY = "select count(*) as HOLIDAY,REGISTRATION_NUMBER from dbo.DAILY_ASSET_UTILIZATION a "
	+ " inner join AMS.dbo.Vehicle_User b (NOLOCK) on b.Registration_no=a.REGISTRATION_NUMBER and b.System_id=a.SYSTEM_ID "
    + " where DATE_GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and HOLIDAY='Yes' and a.SYSTEM_ID=? and a.CUSTOMER_ID=? and b.User_id=? ";

	public static final String GET_ASSET_UTILIZED_ON_WORKING_DAYS = "select count(*) as vehicleUtilizedInWorkingDays,REGISTRATION_NUMBER from dbo.DAILY_ASSET_UTILIZATION a "
		+ " inner join AMS.dbo.Vehicle_User b (NOLOCK) on b.Registration_no=a.REGISTRATION_NUMBER and b.System_id=a.SYSTEM_ID "
        + " where DATE_GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and HOLIDAY='No' and UTILIZED='Yes' and a.SYSTEM_ID=? and a.CUSTOMER_ID=? and b.User_id=? ";

	public static final String GET_ASSET_UTILIZED_ON_HOLIDAYS = "select count(*) as vehicleUtilizedInHolidays,REGISTRATION_NUMBER from dbo.DAILY_ASSET_UTILIZATION a  "
		+ "inner join AMS.dbo.Vehicle_User b (NOLOCK) on b.Registration_no=a.REGISTRATION_NUMBER and b.System_id=a.SYSTEM_ID "
        + " where DATE_GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and HOLIDAY='Yes' and UTILIZED='Yes' and a.SYSTEM_ID=? and a.CUSTOMER_ID=? and b.User_id=?  ";
	
	public static final String GET_MONTHLY_ASSET_UTILIZATION = "select count(a.REGISTRATION_NUMBER) as SELECTEDDAYS,a.REGISTRATION_NUMBER,b.GROUP_NAME,convert(decimal(18,2),sum(a.DISTANCE_TRAVELLED)) as DISTANCETRAVELLED from dbo.DAILY_ASSET_UTILIZATION a "+
	"inner join dbo.Vehicle_User vu on vu.Registration_no=a.REGISTRATION_NUMBER left outer join dbo.VEHICLE_GROUP b on b.GROUP_ID=a.GROUP_ID "+
	"where a.DATE_GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and a.SYSTEM_ID=? and a.CUSTOMER_ID=? and vu.User_id=? ";
	
	public static final String GET_TOP10_DAILY_ASSET_UTILIZATION = "select top 10 a.REGISTRATION_NUMBER+'('+b.GROUP_NAME+')' as RegistrationNo,convert(decimal(18,2), a.PERCENTAGE) as Percentage from dbo.DAILY_ASSET_UTILIZATION a "+
	"left outer join dbo.VEHICLE_GROUP b on b.GROUP_ID=a.GROUP_ID "+
	"where a.DATE_GMT=dateadd(mi,-?,?) and a.SYSTEM_ID=? and a.CUSTOMER_ID=? ";
	
	public static final String Get_ASSET_NUMBER_LIST="select gps.REGISTRATION_NO as ASSET_NUMBER from gpsdata_history_latest gps "+
	"left outer join Vehicle_association va on gps.REGISTRATION_NO = va.Registration_no "+
	"inner join dbo.Vehicle_User vu on vu.Registration_no=gps.REGISTRATION_NO  "+
	"inner join dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=gps.REGISTRATION_NO "+
	"inner join dbo.VEHICLE_GROUP vg on vg.GROUP_ID = vc.GROUP_ID "+
	"and gps.System_id = va.System_id "+
	"and gps.CLIENTID=va.Client_id where va.System_id = ? and va.Client_id=?  and vu.User_id=?  and GMT >= dateadd(dd, -5, GetUTCDate()) and GMT < dateadd(mi,5,GetUTCDate()) order by gps.REGISTRATION_NO ";
		
	public static final String GET_KLE_REQUEST_REPORT = " select REGISTRATION_NO,UNIT_NUMBER,REQUEST_TYPE,isnull(GPS_DATETIME,'') as GPS_DATETIME ,isnull (LOCATION,'') as LOCATION,dateadd(mi,?,INSERTED_TIME) as INSERTED_TIME,STATUS,isnull(REQUESTID,'') as REQUEST_ID,isnull(dateadd(mi,?,RESPONSE_SENT_TIME),getdate()) as RESPONSE_SENT_TIME from KLE_DATA_REQUEST "+ 
														" where SYSTEM_ID=? and CUSTOMER_ID=? and INSERTED_TIME BETWEEN dateadd(mi,-?,?) and dateadd(mi,-?,?) # "+
														" union all "+
														" select REGISTRATION_NO,UNIT_NUMBER,REQUEST_TYPE,isnull(GPS_DATETIME,'') as GPS_DATETIME ,isnull (LOCATION,'') as LOCATION,dateadd(mi,?,INSERTED_TIME) as INSERTED_TIME,STATUS,isnull(REQUESTID,'') as REQUEST_ID,isnull(dateadd(mi,?,RESPONSE_SENT_TIME),getdate()) as RESPONSE_SENT_TIME from KLE_DATA_REQUEST_HISTORY "+ 
														" where SYSTEM_ID=? and CUSTOMER_ID=? and INSERTED_TIME BETWEEN dateadd(mi,-?,?) and dateadd(mi,-?,?) $ order by INSERTED_TIME desc ";

	public static final String GET_VEHICLE_DETAILS= "select a.UNIT_NO,a.GMT,isnull(a.IO3,0)as IO3,isnull(a.IO4,0)as IO4,isnull(a.IO5,0)as IO5,isnull(a.IO6,0)as IO6,isnull(a.IO7,0) as IO7,getUtcDate() as TodayDate,a.System_id,a.CLIENTID,a.GPS_DATETIME,a.LOCATION,isnull(b.MOBILE_NUMBER,'')as MOBILE_NUMBER,a.SPEED  from dbo.gpsdata_history_latest a left join ADMINISTRATOR.dbo.UNIT_MASTER b on a.UNIT_NO=b.UNIT_NUMBER COLLATE DATABASE_DEFAULT and a.System_id=b.SYSTEM_ID where REGISTRATION_NO = ?";

	public static String INSERT_INTO_KLE_REVA="insert into AMS.dbo.KLE_DATA_REQUEST (REGISTRATION_NO,UNIT_NUMBER,REQUEST_TYPE,STATUS,RESPONSE_STATUS,SYSTEM_ID,CUSTOMER_ID)"
		+ "values (?,?,?,?,?,?,?)";

	public static String CHECK_VEHICLE_MODEL="select Model from tblVehicleMaster where VehicleNo = ?";
	
	public static String GET_IO_ASSOCIATED_WITH_VEHICLE="select IONO from dbo.VEHICLEIOASSOCIATION where VEHICLEID = ? and ALERTID= ? ";
	
	public static String CHECK_DOOR_STATUS_EVENT = "select top 1 EVENT_NUMBER from dbo.IO_DATA where REGISTRATION_NO = ? and EVENT_NUMBER in ('30','40') order by GMT desc";
	
	public static String GET_UNIT_NO="select Unit_Number,Unit_Type_Code from Vehicle_association where Registration_no=?";
	
	public static String GET_MAX_PACKET_NO="select CASE when MAX(PACKET_NO)=0 then 1 else MAX(PACKET_NO)+1 end as PACKET_NO from Data_Out";
	
	public static String MOVE_TO_OTA_HISTORY="insert into Data_Out_History select * from Data_Out where DEVICE_ID=? and PACKET_TYPE=? and UNIT_TYPE= ? ";
	
	public static String DELETE_OTA_DETAILS="delete from Data_Out where DEVICE_ID=? and PACKET_TYPE=? and UNIT_TYPE= ?";
	
	public static String INSERT_OTA_DETAILS="insert into Data_Out(PACKET_NO,DEVICE_ID,PACKET_TYPE,PACKET_MODE,PACKET_PARAMS,INSERTED_DATETIME,STATUS,UNIT_TYPE,IP_ADDRESS,MOBILE_NUMBER) values (?,?,?,?,?,getUTCDATE(),?,?,?,?)";
	
	
	public static String GET_STATUS="select STATUS from AMS.dbo.KLE_DATA_REQUEST where UNIT_NUMBER =? and REQUEST_TYPE = ? and RESPONSE_STATUS='N'and COMMAND_MODE=? and STATUS = 5";
	
	
	public static String INSERT_INTO_KLE="insert into AMS.dbo.KLE_DATA_REQUEST (REGISTRATION_NO,UNIT_NUMBER,REQUEST_TYPE,STATUS,RESPONSE_STATUS,SYSTEM_ID,CUSTOMER_ID,LOCATION,GPS_DATETIME,COMMAND_MODE)"
		+ "values (?,?,?,?,?,?,?,?,?,?)";
	
	public static String INSERT_INTO_KLE_DATA="insert into AMS.dbo.KLE_DATA_REQUEST (REGISTRATION_NO,UNIT_NUMBER,REQUEST_TYPE,STATUS,RESPONSE_STATUS,SYSTEM_ID,CUSTOMER_ID,LOCATION,GPS_DATETIME,COMMAND_MODE)"
		+ "values (?,?,?,?,?,?,?,?,?,?)";
	
	 public static final String GET_DRIVER_TRIP_DETAILS= " SELECT a.UNIQUE_ID,isnull(a.REGISTRATION_NO,'') as REGISTRATION_NO,isnull(a.TRIP_ID,'') as TRIP_ID,isnull(a.DRIVER_ID,'') as DRIVER_ID,isnull(c.NAME,'') as " +
	      " HUB_ID,isnull(u1.Firstname, '') as CREATED_BY,isnull(u2.Firstname, '') as CLOSED_BY, "+
	  " isnull(START_DATE,'') as START_DATE,isnull(END_DATE,'') as END_DATE,isnull(a.STATUS,'') as STATUS,isnull(ag.GROUP_NAME,'') as GROUP_NAME  FROM dbo.DRIVING_PERFORMANCE_DETAILS a "+
	  " LEFT OUTER JOIN dbo.LOCATION c on c.HUBID=a.HUB_ID and c.SYSTEMID=a.SYSTEM_ID and c.CLIENTID=a.CLIENT_ID "+
	  " LEFT OUTER JOIN Users u1 on a.CREATED_BY=u1.User_id and a.SYSTEM_ID=u1.System_id "+
	  " LEFT OUTER JOIN Users u2 on a.CLOSED_BY=u2.User_id and a.SYSTEM_ID=u2.System_id "+
	  " LEFT OUTER JOIN dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=a.REGISTRATION_NO AND  vc.SYSTEM_ID=a.SYSTEM_ID and vc.CLIENT_ID=a.CLIENT_ID "+
	  " LEFT OUTER JOIN ADMINISTRATOR.dbo.ASSET_GROUP ag on vc.GROUP_ID=ag.GROUP_ID "+
	  " WHERE a.CLIENT_ID=? AND a.SYSTEM_ID=? order by a.UNIQUE_ID desc ";

	public static final String GET_VEHICLE_NO_FOR_DRIVER_TRIP_DETAILS="select REGISTRATION_NUMBER from VEHICLE_CLIENT vc  "+
		"inner join Vehicle_User vu on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no  "+
		"inner join tblVehicleMaster vm on vm.System_id=vu.System_id and vm.VehicleNo= vu.Registration_no  "+
		"where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and vm.Status='Active'  "+
		"and vc.REGISTRATION_NUMBER not in (select REGISTRATION_NO from dbo.DRIVING_PERFORMANCE_DETAILS where SYSTEM_ID=? and CLIENT_ID=? and STATUS='Open')"+
		"order by REGISTRATION_NUMBER";
	
	public static final String INSERT_DRIVER_TRIP_DETAILS=" insert into dbo.DRIVING_PERFORMANCE_DETAILS(REGISTRATION_NO,DRIVER_ID,HUB_ID,START_DATE,TRIP_ID,CLIENT_ID,SYSTEM_ID,CREATED_BY,STATUS,ACTUAL_START_DATE) "+
													" values(?,?,?,?,?,?,?,?,?,getutcdate())";
	
	public static final String UPDATE_DRIVER_TRIP_DETAILS="UPDATE dbo.DRIVING_PERFORMANCE_DETAILS SET STATUS=?,CLOSED_BY=?,END_DATE=?,DISTANCE_DRIVEN=?,DISTANCE_DRIVEN_SCORE=?, "+
	"OVER_SPEED_COUNT=?,OVER_SPEED_COUNT_SCORE=?,HARSH_ACC_COUNT=?,HARSH_ACC_SCORE=?,HARSH_BRK_COUNT=?,HARSH_BRK_SCORE=?," +
	"HARSH_CURVE_COUNT=?,HARSH_CURVE_SCORE=?," +
	"TOTAL_SCORE=?,ACTUAL_END_DATE=getutcdate(),SETTING_ID=? "+
	"where UNIQUE_ID=? and CLIENT_ID=? and SYSTEM_ID=?";
	
	public static final String CHECK_DUPLICATE_TRIP_ID=" select TRIP_ID from AMS.dbo.DRIVING_PERFORMANCE_DETAILS where SYSTEM_ID=? and CLIENT_ID=? and TRIP_ID=? ";
	
	public static final String GET_ALERT_DATA_FOR_DRIVER =  "select TYPE_OF_ALERT, "+
	" 'alert' as RECORDSOURCE,isnull(REMARKS,'Black Top') as REMARKS from Alert"+
	" where REGISTRATION_NO=? and TYPE_OF_ALERT in (37) and GMT between ? and ?"+
	" union"+
	" select TYPE_OF_ALERT,"+
	" 'alerthistory' as RECORDSOURCE,isnull(REMARKS,'Black Top') as REMARKS from Alert_History"+
	" where REGISTRATION_NO=? and TYPE_OF_ALERT in (37) and GMT between ? and ?"+
	" order by GMT";
	
	public static final String GET_OVERSPEED_DATA="select sum(overSpeedCount) as overSpeedCount from ( "+
	"select count(REGISTRATION_NO) as overSpeedCount from ALERT.dbo.OVER_SPEED_DATA "+
	"where REGISTRATION_NO=? and GMT between ? and ? and SYSTEM_ID=? "+
	"union "+
	"select count(REGISTRATION_NO) as overSpeedCount from ALERT.dbo.OVER_SPEED_DATA_HISTORY "+
	"where REGISTRATION_NO=? and GMT between ? and ? and SYSTEM_ID=? ) r";
	
	public static final String GET_HARSH_ACC_BRK_DETAILS = " select c.AlertName,count(c.AlertName) as harshCount from ALERT.dbo.HARSH_ALERT_DATA a "+
	" left outer join AMS.dbo.Alert_Master_Details c on a.SYSTEM_ID=c.SystemId and a.TYPE_OF_ALERT=c.AlertId "+  
	" where a.REGISTRATION_NO=? and a.GMT between ? and ? and a.SYSTEM_ID=? group by c.AlertName "+
	" UNION ALL "+
	" select d.AlertName,count(d.AlertName) as harshCount from ALERT.dbo.HARSH_ALERT_DATA_HISTORY b "+
	" left outer join AMS.dbo.Alert_Master_Details d on b.SYSTEM_ID=d.SystemId and b.TYPE_OF_ALERT=d.AlertId "+  
	" where b.REGISTRATION_NO=? and b.GMT between ? and ? and b.SYSTEM_ID=? group by d.AlertName "; 
	
	public static final String  SELECT_LTSP_DRIVER_SETTINGS_DETAILS="select setting_param_id,score_range,score from score_setting_association "+
	"where system_id=? and setting_id=?";
	
	public static final String GET_WEIGHT_PARAREMTERS = "select setting_param_id,weight from score_setting_weight where system_id=? and setting_id=? order by setting_param_id";
	
	public static final String GET_HUB_NAMES_FOR_TRIP_DETAIL=" select HUBID,NAME from AMS.dbo.LOCATION where CLIENTID=? and SYSTEMID=? and OPERATION_ID=1 and RADIUS<>0 ";
	
	public static final String GET_SETTING_ID_FOR_TRIP_DETAIL = "select top 1 isNull(score_setting_id,0) as score_setting_id from dbo.score_setting_master where system_id=? and client_id=? order by score_setting_id desc";

	  public static final String GET_TRIP_DETAILS_REPORT = " select isnull(dtd.REGISTRATION_NO,'') as RegistrationNo,isnull(dtd.DRIVER_ID,0) as DriverId,isnull(loc.NAME,'') as HubId, " +
	  	" isnull(dtd.START_DATE,'') as StartDate,isnull(dtd.END_DATE,'') as EndDate,isnull(dtd.TRIP_ID,'') as TripId, " +
	  	" isnull(u1.FIRST_NAME,'') as CreatedBy,isnull(u2.FIRST_NAME,'') as ClosedBy,isnull(dtd.DISTANCE_DRIVEN,0) as DistanceDriven, " +
	  	" isnull(dtd.DISTANCE_DRIVEN_SCORE,0) as DistanceDrivenScore,isnull(dtd.DRIVING_HOURS,0) as DrivingHrs,isnull(dtd.DRIVING_HOURS_SCORE,0) as DrivingHrsScore, " +
	  	" isnull(dtd.OVER_SPEED_COUNT,0) as OverSpeedCount,isnull(dtd.OVER_SPEED_COUNT_SCORE,0) as OverSpeedCountScore,isnull(dtd.OVER_SPEED_GRADED_COUNT,0) as OverSpeedGradedCount, " +
	  	" isnull(dtd.OVER_SPEED_GRADED_COUNT_SCORE,0) as OverSpeedGradedCountScore,isnull(dtd.IDLE_TIME,0) as IdleTime,isnull(dtd.IDLE_TIME_SCORE,0) as IdleTimeScore, " +
	  	" isnull(dtd.HARSH_ACC_COUNT,0) as HarshAccCount,isnull(dtd.HARSH_ACC_SCORE,0) as HarshAccScore,isnull(dtd.HARSH_BRK_COUNT,0) as HarshBrkCount,isnull(dtd.HARSH_BRK_SCORE,0) as HarshBrkScore,isnull(dtd.SEAT_BELT_COUNT,0) seatBeltCount,isnull(dtd.SEAT_BELT_SCORE,0) as SeatBeltScore, " +
	  	" isnull(dtd.SEAT_BELT_DIST_COUNT,0) SeatBeltDistanceCount,isnull(dtd.SEAT_BELT_DIST_SCORE,0) as SeatBeltDistanceScore,isnull(dtd.TOTAL_SCORE,0) as TotalScore,isnull(ag.GROUP_NAME,'') as GroupName,isnull(dtd.STATUS,'') as Status,isnull(HARSH_CURVE_COUNT,0) as HarshCurveCount,isnull(HARSH_CURVE_SCORE,0) as HarshCurveScore " +
	  	" from AMS.dbo.DRIVING_PERFORMANCE_DETAILS dtd " +
	  	" left outer join ADMINISTRATOR.dbo.USERS u1 on u1.USER_ID=dtd.CREATED_BY and u1.SYSTEM_ID=dtd.SYSTEM_ID " +
	  	" left outer join ADMINISTRATOR.dbo.USERS u2 on u2.USER_ID=dtd.CLOSED_BY and u2.SYSTEM_ID=dtd.SYSTEM_ID " +
	  	" left outer join AMS.dbo.LOCATION loc on loc.HUBID=dtd.HUB_ID and loc.SYSTEMID=dtd.SYSTEM_ID and loc.CLIENTID=dtd.CLIENT_ID " +
	  	" left outer join dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=dtd.REGISTRATION_NO AND  vc.SYSTEM_ID=dtd.SYSTEM_ID and vc.CLIENT_ID=dtd.CLIENT_ID " +
	  	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on vc.GROUP_ID=ag.GROUP_ID " +
	  	" where dtd.SYSTEM_ID=? and dtd.CLIENT_ID=? and dtd.START_DATE between ? and ? ";

	  public static final String GET_SPEED = "select SPEED,GPS_DATETIME from AMS.dbo.gpsdata_history_latest where CLIENTID=? and System_id=? and REGISTRATION_NO=? ";
}
