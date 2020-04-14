package t4u.statements;

public class RouteCreationStatements {

	public static final String GET_MAX_ROUTE_ID = " select max(RouteID) from AMS.dbo.Route_Master";

	public static final String SAVE_ROUTE_ID = " insert into AMS.dbo.Route_Master(RouteID,RouteName,System_id,ClientId,UpdationTime,RouteDescription,RouteDistance,EXPECTED_DISTANCE,ACTUAL_DURATION,EXPECTED_DURATION,STATUS,RADIUS,CreatedBy) values(?,?,?,?,getutcdate(),?,?,?,?,?,?,?,?) ";

	public static final String SAVE_ROUTE_DETAIL = " insert into AMS.dbo.Route_Detail(Route_id,Route_Segment,Route_sequence,Latitude,Longitude,TYPE,SHORT_NAME,DURATION,RADIUS,CHECKPOINT_TYPE,DETENTION_TIME,HUB_ID) values(?,?,?,?,?,?,?,?,?,?,?,?) ";

	public static final String GET_ROUTE_DETAILS_FOR_GRID = " select distinct RouteID,isnull(rm.RADIUS,0) as ROUTE_RADIUS,isnull(RouteName,'') as ROUTE_NAME, " +
	" isnull(RouteDistance,0) as ACTUAL_DISTANCE,isnull(EXPECTED_DISTANCE,0) as EXPECTED_DISTANCE, " +
	" isnull(ACTUAL_DURATION,0) as ACTUAL_DURATION,isnull(EXPECTED_DURATION,0) as EXPECTED_DURATION,isnull(STATUS,'') as STATUS, " +
	" isnull(RouteDescription,'') as ROUTE_DESCRIPTION, rd.SHORT_NAME as SOURCE_NAME, rd1.SHORT_NAME as DESTINATION_NAME, (u.Firstname +' '+u.Lastname) as CREATED_BY" +
	" from AMS.dbo.Route_Master rm  " +
	" left outer join AMS.dbo.Route_Detail rd on rd.Route_id=rm.RouteID and rd.TYPE='SOURCE' " +
	" left outer join AMS.dbo.Route_Detail rd1 on rd1.Route_id=rm.RouteID and rd1.TYPE='DESTINATION' " +
	" left outer join AMS.dbo.Users u on u.User_id=rm.CreatedBy and u.System_id=rm.System_id"  +
	" where rm.ClientId=? and rm.System_id=? and rm.RADIUS is not null " ;
		
//		" select RouteID,isnull(r.RADIUS,0) as ROUTE_RADIUS,isnull(RouteName,'') as ROUTE_NAME,isnull(RouteDistance,0) as ACTUAL_DISTANCE,isnull(EXPECTED_DISTANCE,0) as EXPECTED_DISTANCE,  "
//			+ " isnull(ACTUAL_DURATION,0) as ACTUAL_DURATION,isnull(EXPECTED_DURATION,0) as EXPECTED_DURATION,isnull(STATUS,'') as STATUS,  "
//			+ " isnull(RouteDescription,'') as ROUTE_DESCRIPTION, SOURCE_NAME, DESTINATION_NAME,  "
//			+ " r.ClientId,r.System_id  "
//			+ " from (  "
//			+ " select rm.RADIUS,RouteDescription,RouteID,RouteName,RouteDistance,EXPECTED_DISTANCE,ACTUAL_DURATION,EXPECTED_DURATION,STATUS,  "
//			+ " (select SHORT_NAME from AMS.dbo.Route_Detail (NOLOCK)  where Route_id=rm.RouteID  and TYPE='SOURCE') as SOURCE_NAME,  "
//			+ " (select SHORT_NAME from AMS.dbo.Route_Detail (NOLOCK)  where Route_id=rm.RouteID  and TYPE='DESTINATION')  as DESTINATION_NAME, "
//			//+ " (select HUB_ID from AMS.dbo.Route_Detail (NOLOCK)  where Route_id=rm.RouteID  and TYPE='TRIGGER POINT 1') as trigger1hub,  "
//			//+ " (select HUB_ID from AMS.dbo.Route_Detail (NOLOCK)  where Route_id=rm.RouteID  and TYPE='TRIGGER POINT 2')  as trigger2hub, "
//			+ " rm.ClientId,rm.System_id   "
//			+ " from AMS.dbo.Route_Master rm where rm.ClientId=? and rm.System_id=? and rm.RADIUS is not null) r  ";
//		//	+ " left outer join AMS.dbo.LOCATION_ZONE  (NOLOCK) lz on lz.SYSTEMID=r.System_id  and lz.CLIENTID=r.ClientId and r.sourcehub=lz.HUBID  "
//		//	+ " left outer join AMS.dbo.LOCATION_ZONE  (NOLOCK)  dlz on dlz.SYSTEMID=r.System_id  and dlz.CLIENTID=r.ClientId and r.destinationhub=dlz.HUBID "
//		//	+ " left outer join AMS.dbo.LOCATION_ZONE  (NOLOCK) tlz1 on tlz1.SYSTEMID=r.System_id  and tlz1.CLIENTID=r.ClientId and r.trigger1hub=tlz1.HUBID  "
//		//	+ " left outer join AMS.dbo.LOCATION_ZONE  (NOLOCK) tlz2 on tlz2.SYSTEMID=r.System_id  and tlz2.CLIENTID=r.ClientId and r.trigger2hub=tlz2.HUBID ";

	public static final String GET_LAT_LNGS = " select SHORT_NAME,TYPE,Route_Segment,Route_sequence,Latitude,Longitude from Route_Detail a "
			+ " inner join Route_Master b on a.Route_id=b.RouteID "
			+ " where b.RouteID=? and  b.ClientId=? and b.System_id=? and Route_sequence!=0 order by Route_Segment,Route_sequence asc ";

	public static final String GET_CUSTOMER_FOR_LOGGED_IN_CUST = "select CUSTOMER_ID,NAME,STATUS,ACTIVATION_STATUS from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active' and ACTIVATION_STATUS='Complete' order by NAME asc";

	public static final String GET_CUSTOMER = "select CUSTOMER_ID,NAME,STATUS,ACTIVATION_STATUS from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and STATUS='Active' and ACTIVATION_STATUS='Complete' order by NAME asc";
		
	public static final String GET_ROUTE_NAMES = "select RouteID as ROUTE_ID , isnull(RouteName,'') as ROUTE_NAME  from " +
												  "AMS.dbo.Route_Master where ClientId=? and System_id=?";
	
	public static final String GET_ROUTE_BY_SOURCE_DEST = "SELECT Route_id as ROUTE_ID FROM Route_Detail where HUB_ID =? and TYPE='SOURCE'" +
														 " and Route_id IN (SELECT Route_id FROM Route_Detail where HUB_ID =? and TYPE='DESTINATION') and System_id=? and ClientId=? ";
	
	public static final String GET_CHECKPOINTS_BY_ROUTE_ID = "SELECT Route_id as ROUTE_ID,HUB_ID FROM Route_Detail where Route_id IN(#) and TYPE='CHECK POINT' ";

}
