package t4u.statements;

public class TripBasedReportStatements {
	public static final String GET_REPORT_DATA="select isnull(td.TRIP_ID,0) as TRIP_ID,isnull(td.ASSET_NUMBER,'') as VEHICLE_NO, " +
	 " isnull(ds1.NAME,'') as START_POINT,isnull(ds.NAME,'') as END_POINT, isnull(td.SHIPMENT_ID,'') as TRIP_NO,  " +
	 " isnull(gps.LOCATION,'') as CURRENT_LOCATION,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as TRIP_START,isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as TRIP_PLANNED_DATE , " + 
	 " isnull(dateadd(mi,?,td.ACTUAL_TRIP_END_TIME),'') as TRIP_END,   " +
	 " isnull(ACTUAL_DISTANCE,'0') as TRAVELLED_DISTANCE,  " +
	 " isnull(td.ROUTE_ID,0) as ROUTE_ID,isnull(td.STATUS,'') as STATUS, " +  
	 " isnull(gps.LATITUDE,0) as LAT,isnull(gps.LONGITUDE,0) as LNG,isnull(rm.RouteName,'') as ROUTE_NAME, " +
	 " isnull( case when ACTUAL_TRIP_END_TIME is null then datediff (mi,ACTUAL_TRIP_START_TIME,getutcdate()) else datediff (mi,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME) end , 0) as DURATION, "+
	 " dateadd(mi,?,LOAD_START_TIME) as LOAD_START_TIME, dateadd(mi,?,LOAD_END_TIME) as LOAD_END_TIME"+
	 " from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	 " inner join TRACK_TRIP_DETAILS_SUB tsb on td.TRIP_ID=tsb.TRIP_ID "+
	 " left outer join AMS.dbo.Route_Master rm on td.ROUTE_ID = rm.RouteID and td.SYSTEM_ID = rm.System_id " +
	 " left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100 " + 
	 " left outer join AMS.dbo.DES_TRIP_DETAILS ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0  " +
	 " left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID " + 
	 " where td.SYSTEM_ID=? and td.CUSTOMER_ID=? # $ " +
	 " order by td.INSERTED_TIME "; 
	
	public static final String GET_ROUTE_DETAILS=" select RouteID,RouteName from AMS.dbo.Route_Master where System_id = ? and ClientId = ? ";
	
	public static final String GET_DOOR_ALERT_REPORT_DATA = " select isnull(dsr.REGISTRATION_NO,'') as VEHICLE_NO,isnull(dateadd(mi,?,dsr.START_GMT),'') as START_GMT, " +
	" isnull(dateadd(mi,?,dsr.END_GMT),'') as END_GMT,isnull(dsr.ALERT_VALUE,'') as DOOR_NO,isnull(dsr.ALERT_TYPE,'') as ALERT_TYPE,isnull(dsr.STATUS,'') as STATUS, " + 
	" datediff(ss,dsr.START_GMT,dsr.END_GMT) as DURATION,isnull(dsr.START_LOCATION,'') as START_LOCATION,isnull(dsr.END_LOCATION,'') as END_LOCATION, " +
	" isnull(u.Firstname,'') as FIRSTNAME,isnull(u.Lastname,'') as LASTNAME,isnull(dateadd(mi,?,ted.ACKNOWLEDGE_DATETIME),'') as ACK_DATETIME " +
	" from ALERT.dbo.DOOR_SENSOR_REPORT dsr "+
	" left outer join AMS.dbo.TRIP_EVENT_DETAILS ted on ted.ALERT_TYPE = dsr.TYPE_OF_ALERT and ted.VEHICLE_NO = dsr.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ted.GMT=dsr.START_GMT " +
	" left outer join AMS.dbo.Users u on ted.ACKNOWLEDGE_BY=u.User_id and ted.SYSTEM_ID=u.System_id " +
	" where dsr.SYSTEM_ID=? and dsr.CUSTOMER_ID = ? " + 
	" and START_GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and dsr.REGISTRATION_NO = ? order by dsr.START_GMT ";
	
	public static final String GET_TEMP_ALERT_REPORT_DATA = " select ted.TRIP_ID,isnull(ted.VEHICLE_NO,'') as VEHICLE_NO,isnull(ted.ALERT_NAME,'') as ALERT_NAME,isnull(ted.LOCATION,'') as LOCATION, " +
	"isnull(dateadd(mi,?,ted.GMT),'') as DATETIME,isnull(ted.DESCRIPTION,'') as DESCRIPTION, " +
	" isnull(ted.STOP_HOURS,'') as TEMP_VALUE,isnull(ted.REMARKS,'') as REMARKS,isnull(u.Firstname,'') as FIRSTNAME,isnull(u.Lastname,'') as LASTNAME,isnull(dateadd(mi,?,ted.ACKNOWLEDGE_DATETIME),'') as ACK_DATETIME " +
	" from AMS.dbo.TRIP_EVENT_DETAILS ted " +
	" left outer join AMS.dbo.Users u on ted.ACKNOWLEDGE_BY=u.User_id and ted.SYSTEM_ID=u.System_id " +
	" where  ALERT_TYPE in (188,189) and SYSTEM_ID = ? and CUSTOMER_ID = ? "+
	" and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and VEHICLE_NO = ? order by ted.GMT";

	public static final String SELECT_VEHICLE_ADN_UNIT_LIST_AND_VID = "	select vc.REGISTRATION_NUMBER,du.UnitName,vm.VehicleAlias from tblVehicleMaster vm inner join VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=vm.VehicleNo "
			+ " inner join Vehicle_User uv on vc.REGISTRATION_NUMBER=uv.Registration_no "
			+ " inner join Vehicle_Category_Master vcm on vcm.Category_name=vm.VehicleType "
			+ " inner join tblDistanceUnitMaster du on vcm.DistanceUnitId=du.UnitId "
			+ " where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and uv.User_id=? order by REGISTRATION_NUMBER ";
	
	public static final String GET_VEHICLE_USING_CLIENTID_VEHICLE_ID = " select REGISTRATION_NUMBER,VehicleAlias from VEHICLE_CLIENT vc, Vehicle_User vu "
		+ " left outer join tblVehicleMaster vm on vm.VehicleNo=vu.Registration_no where vc.CLIENT_ID=?  "
		+ " and vc.SYSTEM_ID=? and vu.User_id=? and vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no   order by REGISTRATION_NUMBER ";
	
	public static final String GET_TRIP_NAME = " select VehicleAlias,TRIP_ID,(isnull(ORDER_ID,'')+'-('+isnull(SHIPMENT_ID,'')+')') as TRIP_NAME,ASSET_NUMBER, " +
	" (case when td.ACTUAL_TRIP_START_TIME is null then dateadd(mi, ?,td.TRIP_START_TIME) else dateadd(mi,?,td.ACTUAL_TRIP_START_TIME) end) as STD, " +
	" (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as END_DATE, " +
	" isnull(vm.ModelName,'') as MAKE from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	" inner join AMS.dbo.tblVehicleMaster c on td.ASSET_NUMBER=c.VehicleNo " +
	" left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model " +
	" where SYSTEM_ID=? AND CUSTOMER_ID=?  and INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and STATUS != 'CANCEL' " ;
	
	public static final String CHECK_SYSTEM_MASTER_FOR_PRECISE_SETTING = " select isnull(Imprecise_Location_Setting,0) as Location_Setting from  AMS.dbo.System_Master where System_id = ? ";

	public static final String CHECK_USERS_FOR_PRECISE_SETTING = " select isnull(Imprecise_Location_Setting,0) as Location_Setting from AMS.dbo.Users where System_id = ? and  User_id = ?  ";

	public static final String GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPE = "select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = (select DistanceUnitId from Vehicle_Category_Master where Category_name = ("
		+ "select VehicleType from tblVehicleMaster where System_id=? and VehicleNo=?))";
	
	public static final String SELECT_ALL_TRIP_VEHICLE = "select distinct Trip_id as Trip_Allocation_id,Trip_Name,StartDate from Trip_Allocation where Registration_no=? and System_id=?"
		+ " union"
		+ " select distinct Trip_id as Trip_Allocation_id,Trip_Name,StartDate from Trip_Allocation_Hist where Registration_no=? and System_id=?"
		+ " order by StartDate desc";
	
	public static final String GET_TRIP_START_END_DATE = "select distinct Trip_id,Trip_Name,StartDate,EndDate from Trip_Allocation where Trip_id=? and Registration_no=? and System_id=?"
		+ " union"
		+ " select distinct Trip_id,Trip_Name,StartDate,EndDate from Trip_Allocation_Hist where Trip_id=? and Registration_no=? and System_id=?";
	
	public static final String GET_HUB_VEHICLE_DETAILS = "SELECT (SELECT TOP 1 STATUS from AMS.dbo.TRACK_TRIP_DETAILS where ASSET_NUMBER = hb.REGISTRATION_NO order by TRIP_START_TIME desc) AS STATUS,(SELECT TOP 1 CUSTOMER_NAME from AMS.dbo.TRACK_TRIP_DETAILS where ASSET_NUMBER = hb.REGISTRATION_NO order by TRIP_START_TIME desc) AS 'CUSTOMER NAME',(SELECT TOP 1 ORDER_ID from AMS.dbo.TRACK_TRIP_DETAILS where ASSET_NUMBER = hb.REGISTRATION_NO order by TRIP_START_TIME desc) AS 'TRIP ID', "
			+ " hb.HUB_ID,isnull(SUBSTRING(lz.NAME,1,CHARINDEX(',',lz.NAME)-1),'') AS 'HUB NAME',hb.REGISTRATION_NO AS 'VEHICLE NO',tvm.VehicleType AS 'VEHICLE TYPE',CONCAT(ISNULL(odo.SRC_ZONE,'NA'),' - ',ISNULL(odo.DES_ZONE,'NA')) AS 'CURRENT ODO', "
			+ " dateadd(mi,?,ghl.GMT) AS 'LAST COMMUNICATION DATETIME',dateadd(mi,?,hb.ACTUAL_ARRIVAL) AS 'HUB ARRIVAL DATETIME', "
			+ " dateadd(mi,?,hb.ACTUAL_DEPARTURE) AS 'HUB DEPARTURE DATETIME',CASE WHEN hb.ACTUAL_DEPARTURE is not null THEN DATEDIFF(minute ,hb.ACTUAL_ARRIVAL,hb.ACTUAL_DEPARTURE) ELSE DATEDIFF(minute ,hb.ACTUAL_ARRIVAL,GETUTCDATE()) END AS 'STOPPAGE TIME' from AMS.dbo.HUB_REPORT hb(NOLOCK) "
			+ " LEFT OUTER JOIN AMS.dbo.LOCATION_ZONE_A lz(NOLOCK) ON lz.HUBID=hb.HUB_ID "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = hb.REGISTRATION_NO AND ghl.System_id = hb.SYSTEM_ID  AND ghl.CLIENTID=lz.CLIENTID "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ " LEFT OUTER JOIN AMS.dbo.ODO_ROUTE_DETAILS odo(NOLOCK) on odo.RES_ID = ghl.REGISTRATION_NO "
			+ " where hb.SYSTEM_ID = ? $  AND "
			+ " ((hb.ACTUAL_DEPARTURE > ? AND  hb.ACTUAL_DEPARTURE < ?) OR hb.ACTUAL_DEPARTURE is null) ";
			//+ " hb.ACTUAL_ARRIVAL < ? AND ((hb.ACTUAL_DEPARTURE > ? AND  hb.ACTUAL_DEPARTURE < ?) OR hb.ACTUAL_DEPARTURE is null)";
	
	public static final String GET_UNREGISTRED_VEHICLES = " select ASSET_NUMBER as REGISTRATION_NUMBER from ADMINISTRATOR.dbo.ASSET_REGISTRATION_HISTORY where SYSTEM_ID=? AND CUSTOMER_ID=? " +
	"  and CANCELLATION_TIME between dateadd(dd,-30,getdate()) and getdate()";
}
