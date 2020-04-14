package t4u.statements;

public class HubReportStatements {

	public static final String GET_ALL_HUB_DATA_FOR_SUMMARY = "select isnull(VEHICLE_NUMBER,'') as VEHICLE_NUMBER,isnull(vg.GROUP_NAME, '') as GROUP_NAME, "+
							" isnull(VEHICLE_ID ,'') as VEHICLE_ID,isnull(VEHICLE_TYPE, '') as VEHICLE_TYPE, "+
							" count(isnull(ACTUAL_ARRIVAL,'')) as ACTUAL_ARRIVAL,"+
							" count(isnull(ACTUAL_DEPARTURE,'')) as ACTUAL_DEPARTURE ,"+
							" sum(isnull(OUTSIDE_DURATION,0))  as OUTSIDE_DURATION,"+
							" sum(isnull(INSIDE_DURATION,0))  as INSIDE_DURATION, "+
							" (sum(isnull(OUTSIDE_DURATION,0))/datediff(dd,dateadd(mi,-?,?), dateadd(mi,-?,?) )) as Average_detention_outside_time, "+
							" (sum(isnull(INSIDE_DURATION,0))/datediff(dd,dateadd(mi,-?,?), dateadd(mi,-?,?) )) as Average_detention_inside_time "+
							" from dbo.HUB_ARRIVAL_DEPARTURE_SUMMARY as ha join dbo.VEHICLE_GROUP as vg "+
							" on ha.GROUP_ID =vg.GROUP_ID and ha.SYSTEM_ID=vg.SYSTEM_ID and ha.CUSTOMER_ID=vg.CLIENT_ID "+
							" join dbo.Live_Vision_Support as vs on ha.VEHICLE_NUMBER= vs.REGISTRATION_NO and ha.SYSTEM_ID=vs.SYSTEM_ID "+
							" and ha.CUSTOMER_ID=vs.CLIENT_ID  where ha.SYSTEM_ID = ? and ha.CUSTOMER_ID = ? and $$ "+
							" and ACTUAL_ARRIVAL between dateadd(mi,-?,?) and dateadd(mi,-?,?) "+
							" group by VEHICLE_NUMBER,vg.GROUP_NAME,VEHICLE_TYPE,VEHICLE_ID order by VEHICLE_NUMBER ";
	
	public static final String GET_ALL_REGNO_DATA_FOR_SUMMARY = "select isnull(VEHICLE_NUMBER,'') as VEHICLE_NUMBER,isnull(vg.GROUP_NAME, '') as GROUP_NAME, "+
							" isnull(VEHICLE_ID ,'') as VEHICLE_ID,isnull(VEHICLE_TYPE, '') as VEHICLE_TYPE, "+
							" count(isnull(ACTUAL_ARRIVAL,'')) as ACTUAL_ARRIVAL,"+
							" count(isnull(ACTUAL_DEPARTURE,'')) as ACTUAL_DEPARTURE ,"+
							" sum(isnull(OUTSIDE_DURATION,0))  as OUTSIDE_DURATION,"+
							" sum(isnull(INSIDE_DURATION,0))  as INSIDE_DURATION, "+
							" (sum(isnull(OUTSIDE_DURATION,0))/datediff(dd,dateadd(mi,-?,?), dateadd(mi,-?,?) )) as Average_detention_outside_time, "+
							" (sum(isnull(INSIDE_DURATION,0))/datediff(dd,dateadd(mi,-?,?), dateadd(mi,-?,?) )) as Average_detention_inside_time "+
							" from dbo.HUB_ARRIVAL_DEPARTURE_SUMMARY as ha join dbo.VEHICLE_GROUP as vg "+
							" on ha.GROUP_ID =vg.GROUP_ID and ha.SYSTEM_ID=vg.SYSTEM_ID and ha.CUSTOMER_ID=vg.CLIENT_ID "+
							" join dbo.Live_Vision_Support as vs on ha.VEHICLE_NUMBER= vs.REGISTRATION_NO and ha.SYSTEM_ID=vs.SYSTEM_ID "+
							" and ha.CUSTOMER_ID=vs.CLIENT_ID  where ha.SYSTEM_ID = ? and ha.CUSTOMER_ID = ? and ## "+
							" and ACTUAL_ARRIVAL between dateadd(mi,-?,?) and dateadd(mi,-?,?) "+
							" group by VEHICLE_NUMBER,vg.GROUP_NAME,VEHICLE_TYPE,VEHICLE_ID order by VEHICLE_NUMBER ";

	public static final String GET_HUB_NAMES_FOR_CLIENT = "select isnull(NAME,'') as NAME ,isnull(HUBID,'') as HUBID from LOCATION where SYSTEMID=? and CLIENTID=? and RADIUS<>0 order by NAME";

	public static final String GET_ZONE = "select Zone from System_Master where System_id=?";

	public static final String GET_ALL_HUB_FOR_SUMMARY = "select isnull(NAME,'') as NAME ,isnull(HUBID,'') as HUBID from LOCATION where SYSTEMID=? and CLIENTID=? and OPERATION_ID not in (2,13) and HUBID in "+
		" (select HubId from AMS.dbo.UserHubAssociation where UserId = ? and SystemId = ?)";
	
	public static final String GET_GROUP_NAME_FOR_CLIENT = "select isnull(a.GROUP_ID,'') as GROUP_ID , isnull(a.GROUP_NAME,'') as GROUP_NAME from ADMINISTRATOR.dbo.ASSET_GROUP a inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on b.SYSTEM_ID=a.SYSTEM_ID " +
		" and a.GROUP_ID=b.GROUP_ID where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and b.USER_ID=?";
	
	
	public static final String GET_REPORT_DATA =" select * from ( "+
			" select count(HUB_ID) as MAX_SOURCE,HUB_ID,ARRIVAL,REGISTRATION_NO,LOCATION,TYPE,sum(DISTANCE) as DISTANCE_TRAVELLED,OWNER_NAME,GROUP_NAME,LATITUDE,LONGITUDE from "+ 
			" (select REGISTRATION_NO,CASE WHEN upper(LOCATION) like '%BOREWELL%' or upper(LOCATION) like '%BORE WELL%' or upper(LOCATION) like '%BORWELL' or upper(LOCATION) like '%SAND GHAT%' THEN "+ 
			" 'SOURCE' ELSE 'DESTINATION' END as TYPE,HUB_ID,LOCATION,CONVERT(VARCHAR(10), ACTUAL_ARRIVAL, 105) as ARRIVAL,DISTANCE as DISTANCE, "+
			" isnull(tvm.OwnerName, '') as OWNER_NAME,isnull(vg.GROUP_NAME,'') as GROUP_NAME, "+
			" isnull(lz.LATITUDE,'') as LATITUDE,isnull(lz.LONGITUDE,'') as LONGITUDE "+
			" from AMS.dbo.SAND_AUTOMATED_TRIP s (nolock) "+
			" inner join AMS.dbo.tblVehicleMaster tvm (nolock) on tvm.VehicleNo = s.REGISTRATION_NO and tvm.System_id = s.SYSTEM_ID "+
			" left outer join AMS.dbo.VEHICLE_CLIENT v (nolock) on v.SYSTEM_ID=s.SYSTEM_ID and v.REGISTRATION_NUMBER=s.REGISTRATION_NO and CLIENT_ID=? "+
			" left outer join AMS.dbo.VEHICLE_GROUP vg (nolock) on vg.GROUP_ID=v.GROUP_ID "+
			" inner join AMS.dbo.LOCATION_ZONE_A lz (nolock) on lz.HUBID = s.HUB_ID and lz.SYSTEMID = s.SYSTEM_ID and lz.CLIENTID = ? "+
			" WHERE ACTUAL_ARRIVAL BETWEEN ? AND ? and s.SYSTEM_ID = ?  and s.REGISTRATION_NO in ($) ) r "+
			" group by HUB_ID,r.TYPE,ARRIVAL,REGISTRATION_NO,LOCATION,r.OWNER_NAME,r.GROUP_NAME,r.LATITUDE,r.LONGITUDE having count(HUB_ID) = (select count(HUB_ID) where r.TYPE='SOURCE') "+
			" union "+
			" select count(HUB_ID) as MAX_SOURCE,HUB_ID,ARRIVAL,REGISTRATION_NO,LOCATION,TYPE,sum(DISTANCE),OWNER_NAME,GROUP_NAME,LATITUDE,LONGITUDE from "+ 
			" (select REGISTRATION_NO,CASE WHEN upper(LOCATION) like '%BOREWELL%' or upper(LOCATION) like '%BORE WELL%' or upper(LOCATION) like '%BORWELL%' or upper(LOCATION) like '%SAND GHAT%' THEN "+ 
			" 'SOURCE' ELSE 'DESTINATION' END as TYPE,HUB_ID,LOCATION,CONVERT(VARCHAR(10), ACTUAL_ARRIVAL, 105) as ARRIVAL,DISTANCE as DISTANCE, "+
			" isnull(tvm.OwnerName, '') as OWNER_NAME,isnull(vg.GROUP_NAME,'') as GROUP_NAME, "+
			" isnull(lz.LATITUDE,'') as LATITUDE,isnull(lz.LONGITUDE,'') as LONGITUDE "+
			" from AMS.dbo.SAND_AUTOMATED_TRIP s (nolock) "+
			" inner join AMS.dbo.tblVehicleMaster tvm (nolock) on tvm.VehicleNo = s.REGISTRATION_NO and tvm.System_id = s.SYSTEM_ID "+
			" left outer join AMS.dbo.VEHICLE_CLIENT v (nolock) on v.SYSTEM_ID=s.SYSTEM_ID and v.REGISTRATION_NUMBER=s.REGISTRATION_NO and CLIENT_ID=? "+
			" left outer join AMS.dbo.VEHICLE_GROUP vg (nolock) on vg.GROUP_ID=v.GROUP_ID "+
			" inner join AMS.dbo.LOCATION_ZONE_A lz (nolock) on lz.HUBID = s.HUB_ID and lz.SYSTEMID = s.SYSTEM_ID and lz.CLIENTID = ? "+
			" WHERE ACTUAL_ARRIVAL BETWEEN ? AND ? and s.SYSTEM_ID = ? and s.REGISTRATION_NO in ($) ) r "+
			" group by HUB_ID,r.TYPE,ARRIVAL,REGISTRATION_NO,LOCATION,r.OWNER_NAME,r.GROUP_NAME,r.LATITUDE,r.LONGITUDE having count(HUB_ID) = (select count(HUB_ID) where r.TYPE='DESTINATION') "+ 
			" )p "+
			" order by REGISTRATION_NO,ARRIVAL,MAX_SOURCE ";


	public static final String GET_COUNT_FROM_SAND_AUTOMATED = 
		" select max(count) as COUNT,ARRIVAL from (select max(COUNT) as count,CONVERT(VARCHAR(10), ACTUAL_ARRIVAL, 105) as ARRIVAL from AMS.dbo.SAND_AUTOMATED_TRIP where REGISTRATION_NO=? "+
		" and ACTUAL_ARRIVAL BETWEEN ? AND ? group by REGISTRATION_NO,ACTUAL_ARRIVAL) r "+
		" group by ARRIVAL ";
}
