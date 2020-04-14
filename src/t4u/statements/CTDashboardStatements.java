package t4u.statements;

public class CTDashboardStatements {
	public static final String GET_CT_DASHBOARD_COUNTS = " select COUNT(*) as COUNT,'INTRANSIT' as TYPE  "
			+ " from AMS.dbo.TRACK_TRIP_DETAILS "
			+ " where STATUS = 'OPEN' and ACTUAL_TRIP_START_TIME is not null and SYSTEM_ID = ? and CUSTOMER_ID = ? "
			+ " union "
			+ " select COUNT(*) as COUNT,'PLANNED' as TYPE  "
			+ " from AMS.dbo.TRACK_TRIP_DETAILS  "
			+ " where STATUS = 'OPEN' and ACTUAL_TRIP_START_TIME is null and SYSTEM_ID = ? and CUSTOMER_ID = ? "
			+ " union "
			+ " select COUNT(*) as COUNT ,'AVAILABLE' as TYPE  "
			+ " from AMS.dbo.gpsdata_history_latest a  "
			+ " where a.System_id=? and a.CLIENTID=? "
			+ " and a.REGISTRATION_NO not in( "
			+ " select distinct ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID =? and STATUS ='OPEN') "
			+ " union "
			+ " select SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >=## THEN 1 ELSE 0 END) AS COUNT ,'NON_COMM' as TYPE"
			+ " from AMS.dbo.gpsdata_history_latest where System_id=? and CLIENTID = ?"
			+ " union "
			+ " select COUNT(*) as COUNT,'INTRANSIT_TCL' as TYPE  "
			+ " from AMS.dbo.TRACK_TRIP_DETAILS  "
			+ " where STATUS = 'OPEN' and ACTUAL_TRIP_START_TIME is not null and SYSTEM_ID = ? and CUSTOMER_ID = ? and PRODUCT_LINE = 'TCL' "
			+ " union "
			+ " select COUNT(*) as COUNT,'PLANNED_TCL' as TYPE  "
			+ " from AMS.dbo.TRACK_TRIP_DETAILS  "
			+ " where STATUS = 'OPEN' and ACTUAL_TRIP_START_TIME is null and SYSTEM_ID = ? and CUSTOMER_ID = ? and PRODUCT_LINE = 'TCL' "
			+ " union "
			+ " select COUNT(*) as COUNT ,'AVAILABLE_TCL' as TYPE  "
			+ " from AMS.dbo.gpsdata_history_latest a "
			+ " inner join Live_Vision_Support lvs on lvs.REGISTRATION_NO=a.REGISTRATION_NO and lvs.GROUP_NAME='TCL'"
			+ " where a.System_id=? and a.CLIENTID=?  "
			+ " and a.REGISTRATION_NO not in(   "
			+ " select distinct ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID =? and STATUS ='OPEN') "
			+ " union "
			+ " select SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >=## THEN 1 ELSE 0 END) AS COUNT ,'NON_COMM_TCL' as TYPE"
			+ " from AMS.dbo.gpsdata_history_latest a "
			+ " inner join Live_Vision_Support lvs on lvs.REGISTRATION_NO=a.REGISTRATION_NO and lvs.GROUP_NAME='TCL'"
			+ " where System_id=? and CLIENTID = ? "
			+ " union "
			+ "select COUNT(*) as COUNT,'UNLOADING' as TYPE "
			+ "from AMS.dbo.TRACK_TRIP_DETAILS td "
			+ "left outer join DES_TRIP_DETAILS d on d.TRIP_ID=td.TRIP_ID and SEQUENCE=100 "
			+ "where td.STATUS = 'OPEN' and ACTUAL_TRIP_START_TIME is not null and d.ACT_ARR_DATETIME is not null and SYSTEM_ID = ? and CUSTOMER_ID = ? "
			+ " union "
			+ "select COUNT(*) as COUNT,'UNLOADING_TCL' as TYPE "
			+ "from AMS.dbo.TRACK_TRIP_DETAILS td "
			+ "left outer join DES_TRIP_DETAILS d on d.TRIP_ID=td.TRIP_ID and SEQUENCE=100 "
			+ "where td.STATUS = 'OPEN' and ACTUAL_TRIP_START_TIME is not null and d.ACT_ARR_DATETIME is not null and SYSTEM_ID = ? and CUSTOMER_ID = ? and PRODUCT_LINE = 'TCL' ";

	public static final String GET_REGISTRATION_NO = " select REGISTRATION_NO as VehicleNo,TRIP_ID from AMS.dbo.gpsdata_history_latest gps  "
			+ " inner join  AMS.dbo.tblVehicleMaster tb on gps.REGISTRATION_NO=tb.VehicleNo and tb.Status='Active' ## "
			+ " where gps.System_id=? and gps.CLIENTID=? and td.STATUS='OPEN' " ;
					//"and gps.REGISTRATION_NO not in "
			//+ "(select ASSET_NUMBER from USER_VEHICLE_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)  ";

	public static final String GET_VEHICLE_TYPE = " select distinct VehicleType as Category_name,VehicleType as Category_code from tblVehicleMaster where System_id=? order by  VehicleType ";

	//public static final String GET_CUSTOMERS = "select distinct ID as TRIP_CUSTOMER_ID, isnull(NAME,'') as NAME from AMS.dbo.TRIP_CUSTOMER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active'";
	public static final String GET_CUSTOMERS = "select distinct isnull(ID,'') as TRIP_CUSTOMER_ID,isnull(NAME,'') as NAME from TRIP_CUSTOMER_DETAILS tc inner join TRACK_TRIP_DETAILS td on td.TRIP_CUSTOMER_ID=tc.ID where tc.SYSTEM_ID=? and tc.CUSTOMER_ID=? and tc.STATUS='Active' order by NAME";

	public static final String GET_USERS = " select u.USER_ID, isnull(FIRST_NAME,'')+' '+isnull(LAST_NAME,'') as User_Name , " +
	" isnull((select distinct CRITERIA_ID from AMS.dbo.USER_VEHICLE_ASSOCIATION where USER_ID=u.USER_ID),'') as CRITERIA_ID " +
	" from ADMINISTRATOR.dbo.USERS (NOLOCK) u " +
	" where u.SYSTEM_ID=? and USERAUTHORITY='CT Executive' and u.STATUS='Active' order by User_Name  " ;

	public static final String GET_DASHBOARD_STAGE = "select System_Name,System_id from System_Master ";

	public static final String SAVE_USER_VEHICLE_ASSOCIATION = " insert into AMS.dbo.USER_VEHICLE_ASSOCIATION (USER_ID,ASSET_NUMBER,SYSTEM_ID,CUSTOMER_ID,CRITERIA_ID,TRIP_ID_ASSC) values (?,?,?,?,?,?) ";

	public static final String GET_HUB_DETAILS = " select HUBID,NAME from AMS.dbo.LOCATION_ZONE_A where SYSTEMID=? and CLIENTID=? order by HUBID desc";

	public static final String SAVE_SUPERVISOR_HUB_DETAILS = " insert into AMS.dbo.HUB_SUPERVISOR_DETAILS (HUB_ID,HUB_NAME,SUPERVISOR_NAME,HUB_CODE,SHIFT_START_TIME,SHIFT_END_TIME,CONTACT_NUMBER,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY) values (?,?,?,?,?,?,?,?,?,?) ";

	public static final String UPDATE_TAT_FOR_ROUTES = " update AMS.dbo.TRIP_ROUTE_MASTER set AGGRESSIVE_TAT = ? where ID in (select ID from (select rds.SOURCE_HUB,rdd.DESTINATION_HUB,rm.ROUTE_NAME,rm.ID from AMS.dbo.TRIP_ROUTE_MASTER rm "
			+ " left outer join TRIP_ROUTE_DETAILS rds on rds.ROUTE_ID = rm.ID and rds.LEG_SEQUENCE=1 "
			+ " left outer join TRIP_ROUTE_DETAILS rdd on rdd.ROUTE_ID = rm.ID and rdd.LEG_SEQUENCE=(select max(rd.LEG_SEQUENCE) from TRIP_ROUTE_DETAILS rd "
			+ " where rd.ROUTE_ID = rm.ID) "
			+ " where rm.SYSTEM_ID=? and rm.CUSTOMER_ID=?) r "
			+ " where r.SOURCE_HUB in (select HUBID from AMS.dbo.LOCATION_ZONE_A where LTRIM(RTRIM(upper(HUB_CITY)))=?) "
			+ " and r.DESTINATION_HUB in (select HUBID from AMS.dbo.LOCATION_ZONE_A where LTRIM(RTRIM(upper(HUB_CITY)))=?)) ";

	public static final String SAVE_AGGRESSIVE_TAT_DETAILS = " insert into AGGRESSIVE_TAT_DETAILS (SOURCE,DESTINATION,TAT) values (?,?,?) ";

	public static final String SAVE_DELAY_DATA = " insert into DELAY_REASON_DETAILS (DELAY_CATEGORY,DELAY_CODE,DELAY_TYPE,SYSTEM_ID,CUSTOMER_ID) values (?,?,?,?,?)";

	public static final String GET_ASSOCIATION_DATA = "select distinct vh.ASSET_NUMBER,isnull(TAT,0) as TAT,isnull(rd.AGGRESSIVE_TAT,0) as AGGRESSIVE_TAT," 
			+ " isnull(tb.VehicleType,'') as VEHICLE_TYPE,isnull(td.CUSTOMER_NAME,'') as CUSTOMER_NAME,isnull(td.PRODUCT_LINE,'') as VEHICLE_CATEGORY, isnull(cd.NAME,'') as CRITERIA_NAME "
			+ " from AMS.dbo.USER_VEHICLE_ASSOCIATION vh "
			+ " inner join  AMS.dbo.tblVehicleMaster tb on vh.ASSET_NUMBER=tb.VehicleNo and tb.Status='Active'  "
			+ " left outer join AMS.dbo.TRACK_TRIP_DETAILS td on td.ASSET_NUMBER=vh.ASSET_NUMBER and td.STATUS='OPEN' "
			+ " left outer join AMS.dbo.TRIP_ROUTE_MASTER rd on rd.ID=td.ROUTE_ID "
			+ " left outer join AMS.dbo.CRITERIA_DETAILS cd on vh.CRITERIA_ID=cd.ID "
			+ " where vh.SYSTEM_ID=? and vh.CUSTOMER_ID=? and vh.CRITERIA_ID=? ";

	public static final String DISASSOCIATE_VEHICLE_DATA = "delete from AMS.dbo.USER_VEHICLE_ASSOCIATION where TRIP_ID_ASSC=? AND SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_UNASSIGNED_VEHICLES = " select ASSET_NUMBER,ORDER_ID,isnull(tb.VehicleType,'') as VEHICLE_TYPE,isnull(td.CUSTOMER_NAME,'') as CUSTOMER_NAME,isnull(td.PRODUCT_LINE,'') as VEHICLE_CATEGORY from AMS.dbo.TRACK_TRIP_DETAILS(nolock) td "
			+ " inner join  AMS.dbo.tblVehicleMaster tb on td.ASSET_NUMBER=tb.VehicleNo and tb.Status='Active'  "
			+ " where STATUS='OPEN' and ASSET_NUMBER not in "
			+ " (select ASSET_NUMBER from AMS.dbo.USER_VEHICLE_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=?) "
			+ " and SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_AVAILABLE_VEHICLES = "select a.REGISTRATION_NO,a.LOCATION,dateadd(mi,?,a.GMT) as LAST_COMM "
			+ " from AMS.dbo.gpsdata_history_latest a  ##"
			+ " where a.System_id=? and a.CLIENTID=?  "
			+ " and a.REGISTRATION_NO not in(  "
			+ " select distinct ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID =? and STATUS ='OPEN') ";

	public static final String GET_UNLOADING_VEHICLES = " select gps.REGISTRATION_NO,gps.LOCATION,dateadd(mi,?,gps.GMT) as LAST_COMM,dateadd(mi,?,d.ACT_ARR_DATETIME) as ETA,d.DETENTION_TIME as DETENTION_TIME, "
			+ " isnull(gps.DRIVER_NAME,'') as DRIVER_NAME,isnull(gps.DRIVER_MOBILE,'') as DRIVER_NUMBER "
			+ " from AMS.dbo.TRACK_TRIP_DETAILS td "
			+ " left outer join DES_TRIP_DETAILS d on d.TRIP_ID=td.TRIP_ID and SEQUENCE=100"
			+ " left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER "
			+ " where td.STATUS = 'OPEN' and ACTUAL_TRIP_START_TIME is not null and d.ACT_ARR_DATETIME is not null and SYSTEM_ID = ? and CUSTOMER_ID = ? ## ";

	public static final String GET_NON_COMM_VEHICLES = " select case when ACTUAL_TRIP_START_TIME is null and td.STATUS='OPEN' then 'Planned' "
			+ " when ACTUAL_TRIP_START_TIME is not null and td.STATUS='OPEN' then 'On Trip' else 'Available' end as STATUS,a.REGISTRATION_NO,a.LOCATION,dateadd(mi,?,a.GMT) as LAST_COMM "
			+ " from AMS.dbo.gpsdata_history_latest a ## "
			+ " left outer join AMS.dbo.TRACK_TRIP_DETAILS td on td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ " where System_id=? and CLIENTID = ? and DATEDIFF(hh,GMT,getutcdate()) >= 6 ";

	public static final String GET_SOURCE_AND_DESTINATION = "select NAME from REGION_MASTER";

	public static final String GET_DELAY_DATA = " select * from DELAY_REASON_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_TAT_DETAILS = " select * from AGGRESSIVE_TAT_DETAILS ";

	public static final String UPDATE_AGGRESSIVE_TAT_DETAILS = " update AGGRESSIVE_TAT_DETAILS set TAT=? where SOURCE=? AND DESTINATION=? ";

	public static final String GET_CT_USER_VEHICLE_COUNTS = "select COUNT(distinct uva.ASSET_NUMBER) as COUNT ,'TOTAL_VEHICLES' as TYPE "
			+ " from USER_VEHICLE_ASSOCIATION uva"
			+ " inner join AMS.dbo.TRACK_TRIP_DETAILS (nolock) td on uva.ASSET_NUMBER=td.ASSET_NUMBER"
			+ " where uva.SYSTEM_ID=? and uva.CUSTOMER_ID =? and td.STATUS='OPEN' #"
			+ " union"
			+ " select COUNT(distinct uva.ASSET_NUMBER) as COUNT,'PLANNED' as TYPE"
			+ " from USER_VEHICLE_ASSOCIATION uva"
			+ " inner join AMS.dbo.TRACK_TRIP_DETAILS (nolock) td on uva.ASSET_NUMBER=td.ASSET_NUMBER"
			+ " where STATUS = 'OPEN' and td.ACT_SRC_ARR_DATETIME is null and td.SYSTEM_ID = ? and td.CUSTOMER_ID = ? #"
			+ " union"
			+ " select COUNT(distinct uva.ASSET_NUMBER) as COUNT,'INTRANSIT' as TYPE"
			+ " from USER_VEHICLE_ASSOCIATION uva"
			+ " inner join AMS.dbo.TRACK_TRIP_DETAILS (nolock) td on uva.ASSET_NUMBER=td.ASSET_NUMBER"
			+ " inner join DES_TRIP_DETAILS (nolock) de on de.TRIP_ID=td.TRIP_ID and de.SEQUENCE=100"
			+ " where td.STATUS = 'OPEN' and ACTUAL_TRIP_START_TIME is not null and de.ACT_ARR_DATETIME is null and td.SYSTEM_ID = ? and td.CUSTOMER_ID = ? #"
			+ " union"
			+ " select SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >= ? THEN 1 ELSE 0 END) AS COUNT ,'NON_COMM' as TYPE "
			+ " from AMS.dbo.gpsdata_history_latest (nolock) where REGISTRATION_NO in "
			+ "(select distinct(uva.ASSET_NUMBER) from USER_VEHICLE_ASSOCIATION uva inner join TRACK_TRIP_DETAILS td on td.ASSET_NUMBER=uva.ASSET_NUMBER and td.STATUS='OPEN'"
			+ " where uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? # ) and DATEDIFF(hh,GMT,getutcdate()) >= ?";

	public static final String GET_CT_USER_TRIP_COUNTS = "select COUNT(distinct uva.ASSET_NUMBER) as COUNT,'ONTIME' as TYPE"
			+ " from USER_VEHICLE_ASSOCIATION uva"
			+ " inner join AMS.dbo.TRACK_TRIP_DETAILS (nolock) td on uva.ASSET_NUMBER=td.ASSET_NUMBER"
			+ " inner join AMS.dbo.DES_TRIP_DETAILS (nolock) ds100 on ds100.TRIP_ID=td.TRIP_ID and ds100.SEQUENCE=100 "
			+ " where td.STATUS = 'OPEN' and td.SYSTEM_ID = ? and td.CUSTOMER_ID = ? and td.TRIP_STATUS='ON TIME' "
			+ " and td.ACTUAL_TRIP_START_TIME is not null and ds100.ACT_ARR_DATETIME is null # "
			+ " union"
			+ " select COUNT(distinct uva.ASSET_NUMBER) as COUNT,'DELAYEDLESS' as TYPE"
			+ " from USER_VEHICLE_ASSOCIATION uva"
			+ " inner join AMS.dbo.TRACK_TRIP_DETAILS (nolock) td on uva.ASSET_NUMBER=td.ASSET_NUMBER"
			+ " inner join AMS.dbo.DES_TRIP_DETAILS (nolock) ds100 on ds100.TRIP_ID=td.TRIP_ID and ds100.SEQUENCE=100 "
			+ " where td.STATUS = 'OPEN' and td.SYSTEM_ID = ? and td.CUSTOMER_ID = ? # and td.TRIP_STATUS='DELAYED' and isnull(td.DELAY,0) <= 60"
			+ " and td.ACTUAL_TRIP_START_TIME is not null and ds100.ACT_ARR_DATETIME is null"
			+ " union"
			+ " select COUNT(distinct uva.ASSET_NUMBER) as COUNT,'DELAYEDGREATER' as TYPE"
			+ " from USER_VEHICLE_ASSOCIATION uva"
			+ " inner join AMS.dbo.TRACK_TRIP_DETAILS (nolock) td on uva.ASSET_NUMBER=td.ASSET_NUMBER"
			+ " inner join AMS.dbo.DES_TRIP_DETAILS (nolock) ds100 on ds100.TRIP_ID=td.TRIP_ID and ds100.SEQUENCE=100 "
			+ " where td.STATUS = 'OPEN' and td.SYSTEM_ID = ? and td.CUSTOMER_ID = ? # and td.TRIP_STATUS='DELAYED' and isnull(td.DELAY,0) > 60"
			+ " and td.ACTUAL_TRIP_START_TIME is not null and ds100.ACT_ARR_DATETIME is null "
			+ " union"
			+ " select count(ASSET_NUMBER) as COUNT,'UNLOADINGLESS' as TYPE from (select distinct (td.ASSET_NUMBER) from USER_VEHICLE_ASSOCIATION uva"
			+ " inner join TRACK_TRIP_DETAILS td on td.ASSET_NUMBER=uva.ASSET_NUMBER and td.STATUS='OPEN'"
			+ " inner join DES_TRIP_DETAILS de on de.TRIP_ID=td.TRIP_ID and de.SEQUENCE=100"
			+ " where uva.SYSTEM_ID=? and uva.CUSTOMER_ID=? and de.ACT_ARR_DATETIME is not null and datediff(HOUR,de.ACT_ARR_DATETIME,GETUTCDATE()) <= 24 # ) t"
			+ " union" 
			+ " select count(ASSET_NUMBER) as COUNT,'UNLOADINGGREATER' as TYPE from (select distinct (td.ASSET_NUMBER) from USER_VEHICLE_ASSOCIATION uva"
			+ " inner join TRACK_TRIP_DETAILS td on td.ASSET_NUMBER=uva.ASSET_NUMBER and td.STATUS='OPEN'"
			+ " inner join DES_TRIP_DETAILS de on de.TRIP_ID=td.TRIP_ID and de.SEQUENCE=100"
			+ " where uva.SYSTEM_ID=? and uva.CUSTOMER_ID=? and de.ACT_ARR_DATETIME is not null and datediff(HOUR,de.ACT_ARR_DATETIME,GETUTCDATE()) > 24 # ) t"
			+ " union"
			+ " select count(ASSET_NUMBER) as COUNT,'LOADINGLESS' as TYPE from "
			+ " (select distinct (td.ASSET_NUMBER) from USER_VEHICLE_ASSOCIATION uva"
			+ " inner join TRACK_TRIP_DETAILS td on td.ASSET_NUMBER=uva.ASSET_NUMBER and td.STATUS='OPEN'"
			+ " where uva.SYSTEM_ID=? and uva.CUSTOMER_ID=? and td.ACT_SRC_ARR_DATETIME is not null and td.ACTUAL_TRIP_START_TIME is null"
			+ " and datediff(HOUR,td.ACT_SRC_ARR_DATETIME,GETUTCDATE()) <= 24 # ) t"
			+ " union"
			+ " select count(ASSET_NUMBER) as COUNT,'LOADINGGREATER' as TYPE from "
			+ " (select distinct (td.ASSET_NUMBER) from USER_VEHICLE_ASSOCIATION uva"
			+ " inner join TRACK_TRIP_DETAILS td on td.ASSET_NUMBER=uva.ASSET_NUMBER and td.STATUS='OPEN'"
			+ " where uva.SYSTEM_ID=? and uva.CUSTOMER_ID=? and td.ACT_SRC_ARR_DATETIME is not null and td.ACTUAL_TRIP_START_TIME is null"
			+ " and datediff(HOUR,td.ACT_SRC_ARR_DATETIME,GETUTCDATE()) > 24 # ) t"
			+ " union "
			+ " select count(distinct td.TRIP_ID) as COUNT,'BREAKDOWN' as TYPE "
			+ " from TRACK_TRIP_DETAILS (nolock) td "
			+ " inner join TRIP_REMARKS_DETAILS (nolock) de on de.TRIP_ID=td.TRIP_ID and SUBISSUE_TYPE IN ('VEHICLE BREAKDOWN') "
			+ " where ASSET_NUMBER in  "
			+ " (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva "
			+ " inner join AMS.dbo.TRACK_TRIP_DETAILS (nolock) td on uva.ASSET_NUMBER=td.ASSET_NUMBER  "
			+ " where uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? # ) and td.STATUS='OPEN'  "
			+ " union "
			+ " select count(distinct td.TRIP_ID) as COUNT,'ACCIDENT' as TYPE "
			+ " from TRACK_TRIP_DETAILS (nolock) td "
			+ " inner join TRIP_REMARKS_DETAILS (nolock) de on de.TRIP_ID=td.TRIP_ID and SUBISSUE_TYPE IN ('VEHICLE ACCIDENT') "
			+ " where ASSET_NUMBER in  "
			+ " (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva "
			+ " inner join AMS.dbo.TRACK_TRIP_DETAILS (nolock) td on uva.ASSET_NUMBER=td.ASSET_NUMBER  "
			+ " where uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? # ) and td.STATUS='OPEN' ";

	public static final String GET_TRIP_ALERT_COUNTS = " select COUNT(distinct REGISTRATION_NO) as COUNT, 'STOPPAGESH' as TYPE from Alert a "
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ " where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT=204 and a.REMARKS is null and a.TEMP_REMARKS is null"
			+ " and td.ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #) "
			+ " union "
			+ " select COUNT(distinct REGISTRATION_NO) as COUNT, 'ROUTEDEVIATE' as TYPE from Alert a"
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ " where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT in (5) and (a.REMARKS is null or a.REMARKS = td.SHIPMENT_ID) and a.TEMP_REMARKS is null "
			+ " and td.ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #) "
			+ " union "
			+ " select COUNT(distinct REGISTRATION_NO) as COUNT, 'SHMISSED' as TYPE from Alert a"
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ " where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT in (205) and a.REMARKS is null and a.TEMP_REMARKS is null"
			+ " and td.ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #) "
			+ " union "
			+ " select COUNT(distinct REGISTRATION_NO) as COUNT, 'CHMISSED' as TYPE from Alert a"
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ " where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT in (206) and a.REMARKS is null and a.TEMP_REMARKS is null"
			+ " and td.ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #) "
			+ " union "
			+ " select COUNT(distinct a.REGISTRATION_NO) as COUNT, 'STOPPAGE' as TYPE from Alert a"
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ " left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER "
			+ " where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT in (202) and a.REMARKS is null and a.TEMP_REMARKS is null and gps.CATEGORY='stoppage'"
			+ " and td.ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #) "
			+ " union "
			+ " select COUNT(distinct a.REGISTRATION_NO) as COUNT, 'NONCOMM' as TYPE from Alert a "
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN' "
			+ " left outer join gpsdata_history_latest(nolock) gps on gps.REGISTRATION_NO=a.REGISTRATION_NO"
			+ " where a.SYSTEM_ID=? and (a.CUSTOMER_ID=? or isnull(a.CUSTOMER_ID,0)=0) and a.TYPE_OF_ALERT in (85)  and a.REMARKS is null and a.TEMP_REMARKS is null "
			+ " and a.REMARKS is null and datediff(mi,gps.GPS_DATETIME,getdate()) > 5 "  
			+ " and td.ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #) "
			+ " union "
			+ " select COUNT(distinct REGISTRATION_NO) as COUNT, 'TEMPERATUREDEVIATION' as TYPE from Alert a"
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ " where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT in (216) and a.REMARKS is null and a.TEMP_REMARKS is null"
			+ " and td.ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #) "
			+ " union"
			+ " select COUNT(distinct a.REGISTRATION_NO) as COUNT, 'IDLEALERT' as TYPE from Alert a"
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ " left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER "
			+ " where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT in (39) and a.REMARKS is null  and a.TEMP_REMARKS is null and gps.CATEGORY='idle' "
			+ " and td.ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #) ";
			
	
	public static final String GET_SNOOZE_ALERT_COUNTS = " select COUNT(distinct REGISTRATION_NO) as COUNT, 'SNOOZE' as TYPE from Alert a"
		+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
		+ " where a.SYSTEM_ID=? and a.CLIENTID=? and a.SNOOZE_DATETIME is not null and a.TEMP_REMARKS is not null and a.REMARKS is null  "
		+ " and td.ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
		+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #)" 
		+ " union"
		+ " select count(*) as COUNT,'SNOOZE_TIME' as TYPE from (select (CASE WHEN a.SNOOZE_DATETIME > getutcdate()THEN (datediff(mi,getutcdate(),a.SNOOZE_DATETIME))ELSE 0 END ) as COUNT from Alert a"
		+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
		+ " where a.SYSTEM_ID=? and a.CLIENTID=? and a.SNOOZE_DATETIME is not null and a.TEMP_REMARKS is not null and a.REMARKS is null  "
		+ " and td.ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
		+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #) )r where r.COUNT = 0 ";

	public static final String GET_CT_USER_DASHBOARD_LIST_DETAILS = "select distinct ISNULL(td.ASSET_NUMBER,'') as vehicleNo,td.TRIP_ID,isnull(td.CUSTOMER_NAME,'') as customerName,"
			+ " ISNULL(td.ORDER_ID,'') as tripNo,ISNULL(DATEDIFF(hour,gps.GMT,GETUTCDATE()),'0') as lastCommunication,"
			+ " ISNULL(rm.ROUTE_KEY,'') as routeKey,isnull(AVG_SPEED,0) as speed,td.INSERTED_TIME," //ISNULL(td.NEXT_POINT,'') as nexttouchPoint
			+ " ISNULL(td.STATUS,'') as status,isnull(td.TRIP_STATUS,'') as tripStatus," //ISNULL(DATEADD(mi,?,td.NEXT_POINT_ETA),'') as nextTouchPointETA,"
			+ " isnull(DATEADD(mi,?,td.DESTINATION_ETA),'') as destinationETA,isnull(tcd.CUSTOMER_REFERENCE_ID,'') as TRIP_CUSTOMER_REF_ID,"
			+ " ISNULL(gps.DRIVER_NAME,'') as driverName,ISNULL(gps.DRIVER_MOBILE,'') as driverMobile,isnull(td.ROUTE_ID,0) as routeId,"
			+ " (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as endDate, "
			+ " isnull((select top 1 dateadd(mi,?,INSERTED_DATETIME) from TRIP_REMARKS_DETAILS where TRIP_ID=td.TRIP_ID order by INSERTED_DATETIME desc),'') as DELAY_TIME,PRODUCT_LINE, "
			+ " isnull((select top 1 SUBISSUE_TYPE from TRIP_REMARKS_DETAILS where TRIP_ID=td.TRIP_ID order by INSERTED_DATETIME desc),'') as DELAY_TYPE, "
			+ " isnull(DATEADD(mi,?,td.ACTUAL_TRIP_START_TIME),'') as ATD,(DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,de.ACT_ARR_DATETIME) - td.PLANNED_DURATION) as TRANSIT_DELAY, "
			+ " isnull(dateadd(mi,?,de.PLANNED_ARR_DATETIME),'') as STA,isnull(dateadd(mi,?,isnull(td.DEST_ARR_TIME_ON_ATD,de.PLANNED_ARR_DATETIME)),'') as STA_ON_ATD "
			+ " from USER_VEHICLE_ASSOCIATION (nolock) uva"
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.ASSET_NUMBER=uva.ASSET_NUMBER and td.STATUS='OPEN'"
			+ " inner join AMS.dbo.gpsdata_history_latest (nolock) gps on gps.REGISTRATION_NO=td.ASSET_NUMBER"
			+ " left outer join TRIP_ROUTE_MASTER rm on rm.ID=td.ROUTE_ID"
			+ " left outer join TRIP_CUSTOMER_DETAILS tcd on tcd.ID=td.TRIP_CUSTOMER_ID"
			+ " left outer join DES_TRIP_DETAILS (nolock) de on de.TRIP_ID=td.TRIP_ID and de.SEQUENCE=100"
			+ " left outer join DES_TRIP_DETAILS (nolock) de0 on de0.TRIP_ID=td.TRIP_ID and de0.SEQUENCE=0"
			+ " where uva.SYSTEM_ID=? and uva.CUSTOMER_ID=? and td.STATUS='OPEN' # condition order by td.TRIP_ID desc";

	public static final String GET_TRIP_TOUCHPOINT_DETAILS = "select NAME,isnull(DETENTION_TIME,0) as detentionTime from DES_TRIP_DETAILS"
			+ " where TRIP_ID=? and SEQUENCE not in (0,100) order by ID";

	public static final String GET_USER_WISE_VEHICLE_COUNT = " select count(ASSET_NUMBER) as COUNT,a.USER_ID,isnull(FIRST_NAME,'')+' '+isnull(LAST_NAME,'') as User_Name from AMS.dbo.USER_VEHICLE_ASSOCIATION a "
			+ " left outer join ADMINISTRATOR.dbo.USERS ui on ui.USER_ID = a.USER_ID and ui.SYSTEM_ID=a.SYSTEM_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? " + " group by a.USER_ID,FIRST_NAME,LAST_NAME ";

	public static final String GET_ALL_ASSOCIATED_VEHICLES = " select distinct a.ASSET_NUMBER as VEHICLE_NO,a.USER_ID,isnull(FIRST_NAME,'')+' '+isnull(LAST_NAME,'') as User_Name , "
			+ " isnull(tb.VehicleType,'') as VEHICLE_TYPE,isnull(td.CUSTOMER_NAME,'') as CUSTOMER_NAME,isnull(td.PRODUCT_LINE,'') as VEHICLE_CATEGORY "
			+ " from AMS.dbo.USER_VEHICLE_ASSOCIATION a "
			+ " left outer join ADMINISTRATOR.dbo.USERS ui on ui.USER_ID = a.USER_ID and ui.SYSTEM_ID=a.SYSTEM_ID "
			+ " inner join  AMS.dbo.tblVehicleMaster tb on a.ASSET_NUMBER=tb.VehicleNo and tb.Status='Active' "
			+ " left outer join AMS.dbo.TRACK_TRIP_DETAILS td on td.ASSET_NUMBER=a.ASSET_NUMBER and td.STATUS='OPEN' "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? ";

	public static final String MOVE_VEHICLE_ASSOCIATION_DATA = "insert into USER_VEHICLE_ASSOCIATION_HISTORY(USER_ID,ASSET_NUMBER,SYSTEM_ID," +
			"CUSTOMER_ID,TRIP_ID,CRITERIA_ID) select USER_ID,ASSET_NUMBER,SYSTEM_ID,CUSTOMER_ID,TRIP_ID_ASSC,CRITERIA_ID from USER_VEHICLE_ASSOCIATION where TRIP_ID_ASSC=?";

	public static final String GET_TRIP_ID = " select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS(nolock) where ASSET_NUMBER=? and STATUS='OPEN' ";

	public static final String GET_ISSUE_TYPE_FROM_CT_ADMIN = "select distinct DELAY_CATEGORY from DELAY_REASON_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and DELAY_CATEGORY != '' "
			+ " order by DELAY_CATEGORY";

	public static final String GET_SUB_ISSUE_TYPE_FROM_CT_ADMIN = "select DELAY_TYPE from DELAY_REASON_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?"
			+ " and DELAY_TYPE != '' order by DELAY_TYPE";

	public static final String INSERT_REMARK_DETAILS = "insert into AMS.dbo.TRIP_REMARKS_DETAILS (REMARKS,LOCATION_OF_DELAY,STARTDATE,ENDDATE,"
			+ " DELAYTIME,SUBISSUE_TYPE,SYSTEM_ID,CUSTOMER_ID,USER_ID,TRIP_ID,INSERTED_DATETIME,REASON) values (?,?,?,?,?,?,?,?,?,?,getutcdate(),'')";

	public static final String GET_DELAY_REASONS = "select td.CUSTOMER_NAME,td.ORDER_ID,td.ASSET_NUMBER,ISNULL(SUBISSUE_TYPE,'') as delayType,"
			+ " drd.DELAY_CATEGORY,ISNULL(DATEADD(mi,?,STARTDATE),'') as delayStart,ISNULL(DATEADD(mi,?,ENDDATE),'') as delayEnd,DELAYTIME,"
			+ " u.Firstname+' '+u.Lastname as addedBy,DATEADD(MI,?,tr.INSERTED_DATETIME) as addedDate,tr.LOCATION_OF_DELAY,isnull(tr.REMARKS,'') as remarks"
			+ " from TRIP_REMARKS_DETAILS tr"
			+ " left outer join TRACK_TRIP_DETAILS td on td.TRIP_ID=tr.TRIP_ID"
			+ " left outer join DELAY_REASON_DETAILS drd on drd.DELAY_TYPE=SUBISSUE_TYPE"
			+ " left outer join Users u on u.User_id=tr.USER_ID and u.System_id=tr.SYSTEM_ID" + " where tr.TRIP_ID=?";

	public static final String GET_LOCATION_FROM_GPS_DATA = "select top 1 t.LOCATION from "
			+ "(select LONGITUDE,LATITUDE,GMT,LOCATION,GPS_DATETIME,DATETIME,ODOMETER from AMS.dbo.HISTORY_DATA_#"
			+ " where CLIENTID=? and REGISTRATION_NO=? and GMT between ? and ?"
			+ " union all"
			+ " select LONGITUDE,LATITUDE,GMT,LOCATION,GPS_DATETIME,DATETIME,ODOMETER from AMS_Archieve.dbo.GE_DATA_# where CLIENTID=? and"
			+ " REGISTRATION_NO=? and GMT between ? and ?) t order by t.GMT ";

	public static final String GET_SUPERVISOR_SCHEDULE = "select id,	SUPERVISOR_NAME,	HUB_NAME,	HUB_CODE,	SHIFT_START_TIMING,	SHIFT_END_TIME,	CONTACT_NUMBER,	EXCEL_UPLOAD_TIME from SUPERVISOR_SCHEDULE WHERE SYSTEM_ID =? AND CUSTOMER_ID = ?;  ";

	public static final String INSERT_SUPERVISOR_SCHEDULE = " insert into AMS.dbo.SUPERVISOR_SCHEDULE (SUPERVISOR_NAME,HUB_NAME,HUB_CODE,SHIFT_START_TIMING,SHIFT_END_TIME,CONTACT_NUMBER,EXCEL_UPLOAD_TIME,SYSTEM_ID,CUSTOMER_ID)"
			+ "values (?,?,?,?,?,?,getdate(),?,?)";
	public static final String DELETE_SUPERVISOR_SCHEDULE = "DELETE from SUPERVISOR_SCHEDULE;  ";

	public static final String GET_PLANNED_TEMP = " select top 1 MIN_POSITIVE_TEMP as MIN_POSITIVE_TEMP,MAX_NEGATIVE_TEMP as MAX_NEGATIVE_TEMP "
			+ " from AMS.[dbo].[TRIP_VEHICLE_TEMPERATURE_DETAILS] where TRIP_ID=? ";

	public static final String GET_LIVE_TEMPERATURE = "select top 3 IO_VALUE from RS232_LIVE where REGISTRATION_NO=? and IO_CATEGORY LIKE '%TEMP%' order by GMT desc ";

	public static final String GET_ALERT_DETAILS_FOR_ROUTE_DEVIATION = " select * from (select ROW_NUMBER() OVER (PARTITION BY a.REGISTRATION_NO ORDER BY a.GPS_DATETIME DESC) AS RowNum, "
			+ " a.SLNO as slNo,td.ORDER_ID as 'Trip No',upper(rm.ROUTE_KEY) as 'Route Key',td.CUSTOMER_NAME as 'Customer Name',"
			+ " td.ASSET_NUMBER as 'Vehicle No', convert(varchar, a.GPS_DATETIME, 105)	+ ' '+ convert(varchar, a.GPS_DATETIME, 8) as 'Alert Timestamp',gps.LOCATION as 'Current Location',"
			+ " gps.DRIVER_NAME as 'Drivers',gps.DRIVER_MOBILE as 'Driver Contacts',a.SNOOZE_DATETIME as Snooze,a.REMARKS as 'Remarks<sup style=color:red;>*</sup>' "
			+ " from Alert(nolock) a "
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on a.TRIP_ID=td.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN' "
			+ " left outer join gpsdata_history_latest(nolock) gps on gps.REGISTRATION_NO=a.REGISTRATION_NO "
			+ " left outer join TRIP_ROUTE_MASTER rm on rm.ID=td.ROUTE_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT = ? and (a.REMARKS is null or a.REMARKS=td.SHIPMENT_ID) and a.TEMP_REMARKS is null "
			+ " and ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where "
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #)) r where r.RowNum = 1 ";

	public static final String GET_ALERT_DETAILS_FOR_STOPPAGE = "select * from (select ROW_NUMBER() OVER (PARTITION BY a.REGISTRATION_NO ORDER BY a.GPS_DATETIME DESC) AS RowNum, "
			+ " a.SLNO as slNo,td.ORDER_ID as 'Trip No',upper(rm.ROUTE_KEY) as 'Route Key',td.CUSTOMER_NAME as 'Customer Name',"
			+ " td.ASSET_NUMBER as 'Vehicle No', convert(varchar, a.GPS_DATETIME, 105)	+ ' '+ convert(varchar, a.GPS_DATETIME, 8) as 'Alert Timestamp'," 
			+ " CONVERT(TIME(0), DATEADD(MINUTE, 60*gps.DURATION, 0)) as 'Stoppage Duration(hh:mm:ss)',a.LOCATION as 'Alert Location', "
			+ " gps.LOCATION as 'Current Location', " 
			+ " gps.DRIVER_NAME as 'Drivers',gps.DRIVER_MOBILE as 'Driver Contacts',a.SNOOZE_DATETIME as Snooze,a.REMARKS as 'Remarks<sup style=color:red;>*</sup>' "
			+ " from Alert(nolock) a "
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN' "
			+ " inner join gpsdata_history_latest(nolock) gps on gps.REGISTRATION_NO=a.REGISTRATION_NO "
			+ " left outer join TRIP_ROUTE_MASTER rm on rm.ID=td.ROUTE_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT = ? and a.REMARKS is null and a.TEMP_REMARKS is null  and gps.CATEGORY='stoppage' "
			+ " and ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where "
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #)) r where r.RowNum = 1  ";

	public static final String GET_ALERT_DETAILS_FOR_NONCOMM = " select * from " +
			" (select ROW_NUMBER() OVER (PARTITION BY a.REGISTRATION_NO ORDER BY a.GPS_DATETIME DESC) AS RowNum, "
			+ " a.SLNO as slNo,td.ORDER_ID as 'Trip No',td.CUSTOMER_NAME as 'Customer Name',"
			+ " td.ASSET_NUMBER as 'Vehicle No', gps.GPS_DATETIME as 'Last Communication Timestamp',"
			+ " gps.LOCATION as 'Last Known Location',a.SNOOZE_DATETIME as Snooze,a.REMARKS as 'Remarks<sup style=color:red;>*</sup>' "
			+ " from Alert(nolock) a"
			+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ " left outer join gpsdata_history_latest(nolock) gps on gps.REGISTRATION_NO=a.REGISTRATION_NO"
			+ " where a.SYSTEM_ID=? and (a.CUSTOMER_ID=? or isnull(a.CUSTOMER_ID,0)=0) and a.TYPE_OF_ALERT =? and a.REMARKS is null and a.TEMP_REMARKS is null "
			+ " and datediff(mi,gps.GPS_DATETIME,getdate()) > 5 "
			+ " and ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where "
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #)) r where r.RowNum = 1 ";

	public static final String GET_ALERT_DETAILS_FOR_CH_SH_MISSED = " select * from (select ROW_NUMBER() OVER (PARTITION BY a.REGISTRATION_NO ORDER BY a.GPS_DATETIME DESC) AS RowNum, "
			+ "	a.SLNO as slNo,td.ORDER_ID as 'Trip No',upper(rm.ROUTE_KEY) as 'Route Key',gps.LOCATION as 'Current Location',td.CUSTOMER_NAME as 'Customer Name',"
			+ "	td.ASSET_NUMBER as 'Vehicle No', convert(varchar, a.GPS_DATETIME, 105)	+ ' '+ convert(varchar, a.GPS_DATETIME, 8) as 'Alert Timestamp', lz.NAME as 'Touch Point Missed',"
			+ "	gps.DRIVER_NAME as 'Drivers',gps.DRIVER_MOBILE as 'Driver Contacts',a.SNOOZE_DATETIME as Snooze,a.REMARKS as 'Remarks<sup style=color:red;>*</sup>'"
			+ "	from Alert(nolock) a"
			+ "	inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ "	inner join gpsdata_history_latest(nolock) gps on gps.REGISTRATION_NO=a.REGISTRATION_NO"
			+ "	left outer join LOCATION_ZONE_A (nolock) lz on a.HUB_ID=lz.HUBID "
			+ "	left outer join TRIP_ROUTE_MASTER rm on rm.ID=td.ROUTE_ID "
			+ "	where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT = ? and a.REMARKS is null  and a.TEMP_REMARKS is null "
			+ "	and ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where "
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #)) r where r.RowNum = 1 ";

	public static final String GET_ALERT_DETAILS_FOR_TEMP_DEVIATION = " select * from (select ROW_NUMBER() OVER (PARTITION BY a.REGISTRATION_NO ORDER BY a.GPS_DATETIME DESC) AS RowNum, " 
		+ " a.SLNO as slNo ,td.ORDER_ID as 'Trip No',upper(rm.ROUTE_KEY) as 'Route Key',gps.LOCATION as 'Current Location' ,td.CUSTOMER_NAME as 'Customer Name', " 
		+ " td.ASSET_NUMBER as 'Vehicle No', gps.DRIVER_NAME as 'Drivers',gps.DRIVER_MOBILE as 'Driver Contacts'," 
		+ " CONCAT(isnull(tvtd.MIN_POSITIVE_TEMP,'NA'),' to ',isnull(tvtd.MAX_NEGATIVE_TEMP,'NA')) as 'Planned Temperature(°C)','' as 'Actual Temperature(°C)', convert(varchar, a.GPS_DATETIME, 105) + ' '+ convert(varchar, a.GPS_DATETIME, 8) as 'Alert Timestamp',a.SNOOZE_DATETIME as Snooze,isnull(a.REMARKS,'') as 'Remarks<sup style=color:red;>*</sup>' " 
		+ " from Alert(nolock) a " 
		+ " inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN' " 
		+ " left outer join gpsdata_history_latest(nolock) gps on gps.REGISTRATION_NO=a.REGISTRATION_NO " 
		+ " left outer join TRIP_ROUTE_MASTER rm on rm.ID=td.ROUTE_ID "
		+ " left outer join AMS.[dbo].[TRIP_VEHICLE_TEMPERATURE_DETAILS] tvtd on tvtd.TRIP_ID = a.TRIP_ID "
		+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT = ? and a.REMARKS is null and a.TEMP_REMARKS is null  " 
		+ " and ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where  " 
		+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #)) r where r.RowNum = 1 ";

	public static String GET_TRIP_DETAILS = "select ORDER_ID as TRIP_NO,ASSET_NUMBER,gps.LOCATION,rm.ROUTE_KEY,gps.LATITUDE,gps.LONGITUDE, "
			+ " gps.DRIVER_NAME as DRIVERS,gps.DRIVER_MOBILE as DRIVER_CONTACTS "
			+ " from AMS.dbo.TRACK_TRIP_DETAILS td "
			+ " inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER "
			+ " left outer join TRIP_ROUTE_MASTER rm on rm.ID=td.ROUTE_ID " + " where TRIP_ID=?";

	public static final String GET_ROLES = " select * from ADMINISTRATOR.dbo.ROLE where SYSTEM_ID=? and CUSTOMER_ID = ? and STATUS='Active' ";

	public static final String GET_ALL_SMART_HUB_DETAILS = " select * from LOCATION_ZONE_A where SYSTEMID=? AND CLIENTID=? AND OPERATION_ID=33 and NAME like '%SH_%' ";
	
	public static final String UPDATE_REMARKS_ALERT = " update AMS.dbo.Alert set REMARKS=?,ACTION_TAKEN = 'Y',UPDATED_BY=? where SLNO = ? " ;
	public static final String UPDATE_TEMPORARY_REMARKS_ALERT = " update AMS.dbo.Alert set TEMP_REMARKS=?,SNOOZE_DATETIME = dateadd(mi,?,getutcdate()),SNOOZE_COUNT=? where SLNO = ? " ;
	
	public static final String GET_SNOOZE_COUNT_FROM_ALERT = "select SNOOZE_COUNT,REGISTRATION_NO from AMS.dbo.Alert where SLNO= ?";

	public static final String GET_ALERT_DETAILS_FOR_SH_DETENTION = " select * from (select ROW_NUMBER() OVER (PARTITION BY a.REGISTRATION_NO ORDER BY a.GPS_DATETIME DESC) AS RowNum, " +
	" a.SLNO as slNo,td.ORDER_ID as 'Trip No',upper(rm.ROUTE_KEY) as 'Route Key',td.CUSTOMER_NAME as 'Customer Name',"+
	" td.ASSET_NUMBER as 'Vehicle No',gps.LOCATION as 'Current Location', convert(varchar, a.GPS_DATETIME, 105)	+ ' '+ convert(varchar, a.GPS_DATETIME, 8) as 'Alert Timestamp',isnull(lz.NAME,'') as 'Smart Hub',"+
	" CONVERT(varchar, CAST(STOP_HOURS * 60 AS int) / 3600)  + RIGHT(CONVERT(varchar, DATEADD(s, a.STOP_HOURS * 60, 0), 108), 6) as 'SH Detention(hh:mm:ss)',"+
	" isnull(hr.USER_NAME,'') as 'Level1 User Name',isnull(hr.PHONE_NUMBERS,'') as 'Level1 User Contact',a.SNOOZE_DATETIME as Snooze, a.REMARKS as 'Remarks<sup style=color:red;>*</sup>'"+
	" from Alert(nolock) a "+
	" inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN' "+
	" inner join gpsdata_history_latest(nolock) gps on gps.REGISTRATION_NO=a.REGISTRATION_NO "+
	" left outer join LOCATION_ZONE_A (nolock) lz on a.HUB_ID=lz.HUBID "+
	" left outer join TRIP_ROUTE_MASTER rm on rm.ID=td.ROUTE_ID "+
	" left outer join HUB_ROLE_USER_ASSOCIATE hr on hr.HUB_ID = a.HUB_ID and LEVEL_NO=1"+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT = ? and a.REMARKS is null and a.TEMP_REMARKS is null"+
	" and ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where "+
	" uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #) ) r where r.RowNum = 1 ";

	public static final String GET_CRITERIA_DETAILS = " SELECT cd.ID,isnull(cd.NAME,'') as NAME,isnull(cd.CUSTOMER_TYPE,'') as CUSTOMER_TYPE," +
	" isnull(cd.VEHICLE_TYPE,'') as VEHICLE_TYPE,isnull(cd.VEHICLE_CATEGORY,'') as VEHICLE_CATEGORY, " +
	" isnull((STUFF((SELECT CAST(', ' + tcd.NAME AS VARCHAR(MAX))  " +
	" FROM TRIP_CUSTOMER_DETAILS tcd " +
	" WHERE (',' + cd.TRIP_CUSTOMER_ID + ',' like '%,' + cast(tcd.ID as nvarchar(20)) + ',%')  " +
	" FOR XML PATH ('')), 1, 2, '')),'') AS CUSTOMER_NAME " +
	" FROM  AMS.dbo.CRITERIA_DETAILS cd " +
	" where SYSTEM_ID=? and CUSTOMER_ID=? " +
	" GROUP BY cd.NAME,cd.TRIP_CUSTOMER_ID,cd.CUSTOMER_TYPE,cd.VEHICLE_TYPE,cd.VEHICLE_CATEGORY,cd.ID ";
	public static final String GET_ALERT_DETAILS_FOR_SNOOZE = "select * from (select ROW_NUMBER() OVER (PARTITION BY a.REGISTRATION_NO ORDER BY a.GPS_DATETIME DESC) AS RowNum, " 
			+ "	a.SLNO as slNo,am.AlertName as 'Alert Type', td.TRIP_ID as 'Trip Id',upper(rm.ROUTE_KEY) as 'Route Key',td.CUSTOMER_NAME as 'Customer Name',"
			+ "	td.ASSET_NUMBER as 'Vehicle No', convert(varchar, a.GPS_DATETIME, 105)	+ ' '+ convert(varchar, a.GPS_DATETIME, 8) as 'Alert Timestamp',"
			+ "	gps.DRIVER_NAME as 'Drivers',gps.DRIVER_MOBILE as 'Driver Contacts', (CASE WHEN a.SNOOZE_DATETIME > getutcdate()THEN (datediff(mi,getutcdate(),a.SNOOZE_DATETIME))ELSE 0 END ) as 'Snoozed Till',"
			+ "	a.SNOOZE_DATETIME as Snooze,a.TEMP_REMARKS as 'Remarks<sup style=color:red;>*</sup>' from Alert(nolock) a"
			+ "	inner join TRACK_TRIP_DETAILS (nolock) td on td.TRIP_ID=a.TRIP_ID and td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN'"
			+ "	inner join gpsdata_history_latest(nolock) gps on gps.REGISTRATION_NO=a.REGISTRATION_NO"
			+ " inner join dbo.Alert_Master_Details(nolock) am on am.AlertId = a.TYPE_OF_ALERT"
			+ "	left outer join TRIP_ROUTE_MASTER rm on rm.ID=td.ROUTE_ID "
			+ "	where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.SNOOZE_DATETIME is not Null and a.TEMP_REMARKS is not null and a.REMARKS is null  "
			+ "	and ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where "
			+ " uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #)) r where r.RowNum = 1 ORDER BY 'Snoozed Till' asc";

	public static final String SAVE_CRITERIA = " insert into CRITERIA_DETAILS (NAME,TRIP_CUSTOMER_ID,CUSTOMER_TYPE,VEHICLE_TYPE,VEHICLE_CATEGORY,SYSTEM_ID,CUSTOMER_ID) values (?,?,?,?,?,?,?) ";

	public static final String GET_CRITERIA_DETAILS_TO_ASSOCIATE = " select * from CRITERIA_DETAILS where ID=? ";

	public static final String GET_CRITERIA = " select * from CRITERIA_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String CHECK_RECORD_EXISTS = " select * from USER_VEHICLE_ASSOCIATION where USER_ID=? and ASSET_NUMBER=? ";

	public static final String MODIFY_CRITERIA = " update CRITERIA_DETAILS set TRIP_CUSTOMER_ID=?, CUSTOMER_TYPE=?, VEHICLE_TYPE=?, VEHICLE_CATEGORY=? where ID=? ";

	public static final String DELETE_ASSOCIATION_FOR_CRITERIA = " delete from USER_VEHICLE_ASSOCIATION where CRITERIA_ID=? ";

	public static final String GET_USERS_FOR_A_CRITERIA = " select distinct USER_ID from USER_VEHICLE_ASSOCIATION where CRITERIA_ID=? ";

	public static final String DISASSOCIATE_CRITERIA = " delete from USER_VEHICLE_ASSOCIATION where USER_ID=?";

	public static final String GET_ALERT_DETAILS_FOR_IDLE = " select * from (select ROW_NUMBER() OVER (PARTITION BY a.REGISTRATION_NO ORDER BY a.GPS_DATETIME DESC) AS RowNum, " +
	" a.SLNO as slNo,td.ORDER_ID as 'Trip No',upper(rm.ROUTE_KEY) as 'Route Key',td.CUSTOMER_NAME as 'Customer Name', " +
	" td.ASSET_NUMBER as 'Vehicle No', convert(varchar, a.GPS_DATETIME, 105) +' ' +convert(varchar, a.GPS_DATETIME, 8) as 'Alert Timestamp',a.LOCATION as 'Alert Location', " +
	" CONVERT(TIME(0), DATEADD(MINUTE, 60*gps.DURATION, 0)) as 'Idle Duration(hh:mm:ss)',gps.DRIVER_NAME as 'Drivers',gps.DRIVER_MOBILE as 'Driver Contacts',a.SNOOZE_DATETIME as Snooze,a.REMARKS as 'Remarks<sup style=color:red;>*</sup>' " +
	" from Alert(nolock) a " +
	" inner join TRACK_TRIP_DETAILS (nolock) td on td.ASSET_NUMBER=a.REGISTRATION_NO and td.STATUS='OPEN' " +
	" left outer join gpsdata_history_latest(nolock) gps on gps.REGISTRATION_NO=a.REGISTRATION_NO " +
	" left outer join TRIP_ROUTE_MASTER rm on rm.ID=td.ROUTE_ID " +
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT = ? and a.REMARKS is null and a.TEMP_REMARKS is null and gps.CATEGORY='idle' " +
	" and ASSET_NUMBER in (select distinct uva.ASSET_NUMBER from USER_VEHICLE_ASSOCIATION uva where " +
	" uva.SYSTEM_ID=? and uva.CUSTOMER_ID = ? #)) r where r.RowNum = 1  ";

	public static final String SAVE_USER_CRITERIA_DETAILS = " insert into USER_CRITERIA_ASSOCIATION (USER_ID,CRITERIA_ID,SYSTEM_ID,CUSTOMER_ID) values (?,?,?,?) ";

	public static final String DELETE_USER_CRITERIA_DETAILS = " delete from USER_CRITERIA_ASSOCIATION where USER_ID=? ";

	public static final String INSERT_PINCODE_REGION_DETAILS = "insert into [ams].[dbo].[PIN_CODE_REGIONS](PIN_CODE,ORIGIN_DESTINATION_ID,NAME) values(?,?,?)";

	public static final String INSERT_REGION_DETAILS = "insert into [ams].[dbo].[REGION_MASTER](NAME) values(?)";

	public static final String CHECK_DUPLICATE_EXISTS = "select PIN_CODE FROM PIN_CODE_REGIONS";

	public static final String GET_REGION_DETAILS = " select ID from REGION_MASTER where NAME =? ";
	
	public static final String GET_REMARKS_FROM_ALERT ="select TEMP_REMARKS FROM Alert where SLNO = ?";
	
}
