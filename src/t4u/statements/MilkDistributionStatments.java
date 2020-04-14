package t4u.statements;

public class MilkDistributionStatments {

	public static final String GET_DISTRIBUTION_DETAILS = "select isnull(DIST_ID,0) as UID,isnull(DIST_HUB_ID,0) as locationName,isnull(DIST_ARR_TIME,'') as distArrTime,isnull(DIST_BUFF_TIME,0) as distBufferTime,"+
	" isnull(PRIORITY,'') as priority from AMS.dbo.MD_DIST_DETAILS  where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=? order by PRIORITY";
	
	public static final String GETZONE = "select isnull(Zone,'') as Zone from AMS.dbo.System_Master where System_id=?";

	public static final String GET_LOCATION_NAMES = "select isnull(NAME,'') as name,isnull(HUBID,0) as hubId from AMS.dbo.LOCATION where SYSTEMID=? and CLIENTID=? and OPERATION_ID=?";

	public static final String INSERT_ROUTE_DETAILS = "insert into AMS.dbo.MD_ROUTE_MASTER(SYSTEM_ID,CUSTOMER_ID,ROUTE_NAME,SRC_HUB_ID,SRC_DEP_TIME,SRC_BUFF_TIME,STATUS,INSERTED_DATE,INSERTED_BY,NO_OF_DIST_PTS)" +
	" values (?,?,?,?,?,?,?,getutcdate(),?,?)";

	public static final String INSERT_DISTRIBUTION_DETAILS = "insert into AMS.dbo.MD_DIST_DETAILS (SYSTEM_ID,CUSTOMER_ID,ROUTE_ID,DIST_HUB_ID,DIST_ARR_TIME,DIST_BUFF_TIME,PRIORITY,INSERTED_BY,INSERTED_TIME) values (?,?,?,?,?,?,?,?,getutcdate())";

	public static final String GET_ACTIVE_ROUTES = "select isnull(ROUTE_ID,0) as routeId,isnull(ROUTE_NAME,'') as routeName from AMS.dbo.MD_ROUTE_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS=1";

	public static final String GET_VEHICLES = "select isnull(REGISTRATION_NUMBER,'') as assetNo from dbo.VEHICLE_CLIENT vc, dbo.Vehicle_User vu " +
	" where vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER=vu.Registration_no and vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? ";

	public static final String INSERT_TRIP_DETAILS = "insert into AMS.dbo.MD_TRIP_ASSIGNMENT (SYSTEM_ID,CUSTOMER_ID,ASSET_NO,ROUTE_ID,STATUS,INSERTED_DATE,INSERTED_BY)" +
	" values (?,?,?,?,?,getutcdate(),?)";

	public static final String GET_TRIP_DETAILS = "select isnull(UNIQUE_ID,0) as UID,isnull(tp.ASSET_NO,'') as assetNo,(case when isnull(tp.STATUS,0)=1 then 'Active' else 'Inactive' end) as status," +
	" isnull(rm.ROUTE_NAME,'') as routeName from  AMS.dbo.MD_TRIP_ASSIGNMENT tp left outer join dbo.MD_ROUTE_MASTER rm on rm.ROUTE_ID=tp.ROUTE_ID where tp.SYSTEM_ID=? and tp.CUSTOMER_ID=?";

	public static final String GET_ROUTE_MASTER_DETAILS = "select isnull(rm.ROUTE_ID,0) as UID,isnull(rm.ROUTE_NAME,'') as routeName,isnull(lz.NAME,'') as source,isnull(SRC_DEP_TIME,'') as depTime," +
	" (select count(*) from AMS.dbo.MD_DIST_DETAILS dd where dd.ROUTE_ID=rm.ROUTE_ID) as noOfPoints,(case when isnull(rm.STATUS,0)= 1 then 'Active' else 'Inactive' end) as status,isnull(rm.SRC_BUFF_TIME,0) as srcBufferTime"+
	" from dbo.MD_ROUTE_MASTER rm"+
	" left outer join AMS.dbo.LOCATION lz on lz.SYSTEMID=rm.SYSTEM_ID and lz.CLIENTID=rm.CUSTOMER_ID and lz.HUBID=rm.SRC_HUB_ID"+
	" where rm.SYSTEM_ID=? and rm.CUSTOMER_ID=? order by rm.ROUTE_ID";

	public static final String CHECK_EXISTING_ROUTE_NAME = "select isnull(ROUTE_NAME,'') as routeName from dbo.MD_ROUTE_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_NAME=?";

	public static final String GET_MILK_DISTRIBUTION_REPORT_DETAILS = "select * from " +
	" (select isnull(sd.TRIP_ID,0) as UID,isnull(sd.ASSET_NO,'') as assetNo,isnull(dateadd(mi,?,sd.START_DATE),'') as date,isnull(rm.ROUTE_NAME,'') as routeName,isnull(lz.NAME,'') as source,"+
	" isnull(CONVERT(VARCHAR(5), sd.SCHD_DEP_TIME, 108),'') as scheduledDepTime,isnull(CONVERT(VARCHAR(5), dateadd(mi,?,sd.ACTUAL_DEP_TIME), 108),'') as actualDepTime,"+
	" isnull(sd.NO_OF_DIST_PTS,0) as distributionPts,isnull(sd.TOTAL_DISTANCE_TRAVELLED,0) as distanceTravelled,isnull(sd.BUFF_TIME,0) as bufferTime,datediff(ss,dateadd(mi,-?,sd.SCHD_DEP_TIME),dist.SCHD_ARR_TIME) as tripDuration," +
	" datediff(ss,sd.ACTUAL_DEP_TIME,dist.ACTUAL_ARR_TIME) as actualDuration,ROW_NUMBER() OVER(PARTITION BY dist.TRIP_ID ORDER BY dist.UNIQUE_ID DESC) rn"+
	" from  AMS.dbo.MD_SRC_TRIP_DETAILS sd"+
	" left outer join dbo.MD_ROUTE_MASTER rm on sd.ROUTE_ID=rm.ROUTE_ID"+
	" left outer join AMS.dbo.LOCATION lz on lz.SYSTEMID=sd.SYSTEM_ID and lz.CLIENTID=sd.CUSTOMER_ID and lz.HUBID=sd.HUB_ID"+
	" left outer join AMS.dbo.MD_DIST_TRIP_DETAILS dist on dist.TRIP_ID = sd.TRIP_ID"+
	" where sd.SYSTEM_ID=? and sd.CUSTOMER_ID=? and TRIP_STATUS='CLOSE' and sd.START_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) #) t where rn = 1 order by date";

	public static final String GET_MILK_DISTRIBUTION_POINTS_DETAILS = "select isnull(lz.NAME,'') as distributionPointName,isnull(CONVERT(VARCHAR(5),dateadd(mi,?,dist.SCHD_ARR_TIME), 108),'') as scheduledArrTime," +
	" isnull(dist.BUFF_TIME,0) as buffer,isnull(CONVERT(VARCHAR(5),dateadd(mi,?,dist.ACTUAL_ARR_TIME), 108),'') as actualArrTime,isnull(CONVERT(VARCHAR(5),dateadd(mi,?,dist.ACTUAL_DEP_TIME), 108),'') as actualDepTime,isnull(dist.TEMP,0) as temprature"+
	" from AMS.dbo.MD_DIST_TRIP_DETAILS dist"+
	" left outer join AMS.dbo.LOCATION lz on lz.SYSTEMID=dist.SYSTEM_ID and lz.CLIENTID=dist.CUSTOMER_ID and lz.HUBID=dist.HUB_ID"+
	" where dist.SYSTEM_ID=? and dist.CUSTOMER_ID=? and dist.TRIP_ID=? order by dist.UNIQUE_ID";

	public static final String GET_ACTIVE_ROUTES_FOR_TRIP = "select isnull(rm.ROUTE_ID,0) as routeId,isnull(rm.ROUTE_NAME,'') as routeName from AMS.dbo.MD_ROUTE_MASTER rm"+
	" where rm.SYSTEM_ID=? and rm.CUSTOMER_ID=? and rm.STATUS=1 and rm.ROUTE_ID not in (select tp.ROUTE_ID from dbo.MD_TRIP_ASSIGNMENT tp where tp.SYSTEM_ID=? and tp.CUSTOMER_ID=? and tp.STATUS=1)";

	public static final String CHANGE_TRIP_STATUS = "update AMS.dbo.MD_TRIP_ASSIGNMENT set STATUS=? where UNIQUE_ID=?";

	public static final String CHANGE_ROUTE_STATUS = "update AMS.dbo.MD_ROUTE_MASTER set STATUS=? where ROUTE_ID=?";

	public static final String UPDATE_ROUTE_DETAILS = "update AMS.dbo.MD_ROUTE_MASTER set SRC_HUB_ID=?,SRC_DEP_TIME=?,SRC_BUFF_TIME=?,NO_OF_DIST_PTS=(select count(DIST_ID) from dbo.MD_DIST_DETAILS dd where dd.ROUTE_ID=?),UPDATED_BY=?,UPDATED_DATE=getutcdate() where ROUTE_ID=?";

	public static final String UPDATE_DISTRIBUTION_DETAILS = "update AMS.dbo.MD_DIST_DETAILS set DIST_HUB_ID=?,DIST_ARR_TIME=?,DIST_BUFF_TIME=?,PRIORITY=? where DIST_ID=?";

	public static final String UPDATE_ROUTE_DETAILS_EXCEPT_SRC_HUB = "update AMS.dbo.MD_ROUTE_MASTER set SRC_DEP_TIME=?,SRC_BUFF_TIME=?,NO_OF_DIST_PTS=(select count(DIST_ID) from dbo.MD_DIST_DETAILS dd where dd.ROUTE_ID=?),UPDATED_BY=?,UPDATED_DATE=getutcdate() where ROUTE_ID=?";

	public static final String CHECK_EXISTING_ROUTE_AND_ASSET = "select UNIQUE_ID from AMS.dbo.MD_TRIP_ASSIGNMENT where	ASSET_NO=? and ROUTE_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String CHECK_FOR_RUNNING_TRIPS = "select TRIP_ID from AMS.dbo.MD_SRC_TRIP_DETAILS where ROUTE_ID=? and TRIP_STATUS='OPEN'";

	public static final String CHECK_FOR_RUNNING_TRIPS_NEW = "select rep.TRIP_ID from dbo.MD_SRC_TRIP_DETAILS rep"+
	" left outer join dbo.MD_TRIP_ASSIGNMENT tp on tp.ROUTE_ID=rep.ROUTE_ID where tp.UNIQUE_ID=? and rep.TRIP_STATUS='OPEN'";

}
