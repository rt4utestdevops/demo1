package t4u.statements;

public class TripStatements {
	
	public static final String GET_MAX_ROUTE_ID="select max(RouteID) from Route_Master";
	
    public static final String SAVE_ROUTE_ID = "insert into Route_Master(RouteID,RouteName,System_id,ClientId,UpdationTime) values(?,?,?,?,getutcdate())";
    
    public static final String SAVE_ROUTE_PICK_UP_POINT = "insert into Route_PickupPoint(RouteId,PickupPointId,SequenceId,Distance) values (?,?,?,?)";
    
    public static final String SAVE_ROUTE_DETAIL = "insert into Route_Detail(Route_id,Route_Segment,Route_sequence,Latitude,Longitude) values(?,?,?,?,?)";
	
    public static final String GET_ROUTE_NAMES="select RouteID,RouteName from Route_Master where ClientId=? and System_id=?";
    
    public static final String GET_ROUTE_DETAILS="select Route_Segment,Route_sequence,Latitude,Longitude from Route_Detail a "+
    											 "inner join Route_Master b on a.Route_id=b.RouteID "+
    											 "inner join dbo.Route_PickupPoint c on a.Route_id=c.RouteId and a.Route_Segment=c.PickupPointId "+
    											 "where b.RouteID=? and  b.ClientId=? and b.System_id=? order by Route_Segment,Route_sequence asc";
    
    public static final String DELETE_ROUTE_PICKUP="delete from Route_PickupPoint where RouteId=?";
    
    public static final String DELETE_ROUTE_DETAILS="delete from Route_Detail where Route_id=?";
    
    public static final String DELETE_ROUTE_MASTER="delete from dbo.Route_Master where RouteID=? and ClientId=? and System_id=?";
    
    public static final String GET_MAX_SEGMENT_ID="select max(Route_Segment) from Route_Detail";
    
    public static final String GET_CLIENTS="select CustomerId,CustomerName from dbo.tblCustomerMaster where System_id=?";
    
    public static final String GET_CLIENT="select CustomerId,CustomerName from dbo.tblCustomerMaster where System_id=? and CustomerId=?";
    
    public static final String GET_HUBS="select HUBID,NAME from LOCATION_ZONE_A a where SYSTEMID=? and CLIENTID=?";
    
    public static final String CHECK_DUPLICATE="select * from TRIP_LOCATION_SYNC where SYSTEM_ID=? and CUSTOMER_ID=? and CUSTOMER_LOCATION_NAME=?";
    
    public static final String INSERT_TRIP="INSERT into dbo.TRIP_LOCATION_SYNC(CUSTOMER_LOCATION_NAME,HUB_ID,CUSTOMER_ID,SYSTEM_ID,CREATED_BY,CREATED_TIME)values(?,?,?,?,?,GetUtcDate())";
    
    public static final String UPDATE_TRIP="UPDATE dbo.TRIP_LOCATION_SYNC SET  HUB_ID = ? where SYSTEM_ID = ? and CUSTOMER_ID=? and CUSTOMER_LOCATION_NAME=?";
    
    public static final String GET_CUST_ROUTE_DETAILS="select a.CUSTOMER_LOCATION_NAME,b.NAME as HubName,c.Firstname as CREATED_BY,dateadd(mi,?,a.CREATED_TIME) as CREATED_TIME from TRIP_LOCATION_SYNC a " 
					+ " inner join LOCATION_ZONE_A b on b.SYSTEMID=a.SYSTEM_ID and b.CLIENTID=a.CUSTOMER_ID and b.HUBID = a.HUB_ID "+
					" inner join Users c on c.System_id=a.SYSTEM_ID and a.CREATED_BY=c.User_id "+
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? order by a.CUSTOMER_LOCATION_NAME ";
    
   /* public static final String GET_CUSTOMER_ROUTE = " Select a.RouteName as RouteName,a.RouteID as RouteID from Route_Master a, "+
	   "ClientRouteAssociation b  where a.System_id=? and a.RouteID=b.RouteId and b.ClientId=? order by a.RouteID ";*/
    
    public static final String GET_CUSTOMER_ROUTE = " Select isnull(RouteName,'') as RouteName,RouteID as RouteID from AMS.dbo.Route_Master "
                                                  + " where System_id=? and ClientId=? order by RouteID ";

    
    public static final String GET_GROUP_NAME = " select a.GROUP_ID,a.GROUP_NAME from ADMINISTRATOR.dbo.ASSET_GROUP a "	+ 
    										    " inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on b.SYSTEM_ID=a.SYSTEM_ID and b.GROUP_ID=a.GROUP_ID " + 
    										    " where a.SYSTEM_ID=?  and a.CUSTOMER_ID=? and b.USER_ID=? ";
    
    public static final String GET_VEHICLE_ACCORDING_TO_GROUP_NAME = " Select a.REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT a "+
    																 " inner join AMS.dbo.Vehicle_User b on  b.Registration_no=a.REGISTRATION_NUMBER and a.SYSTEM_ID=b.System_id "+
    																 " where a.SYSTEM_ID=? and a.CLIENT_ID=? and GROUP_ID=? and b.User_id=? and REGISTRATION_NUMBER not in "+
    																 " (select REGISTRATION_NO from VEHICLE_ROUTE_ASSOCIATION where ROUTE_ID=?) ";
 
    public static final String GET_ROUTE_VEHICLE_ASSOCIATION_REPORT = " select b.RouteID as ROUTE_ID,isnull(b.RouteName,'') as ROUTE_NAME,a.REGISTRATION_NO as REGISTRATION_NO,f.GROUP_ID as GROUP_ID,f.GROUP_NAME as GROUP_NAME, "+
    																  " isnull(c.Login_name,'') as CREATED_BY,isnull(a.CREATED_TIME,'') as CREATED_TIME,isnull(d.Login_name,'') as UPDATED_BY,isnull(a.UpdationTime,'') as UPDATED_TIME  "+
    																  " from AMS.dbo.VEHICLE_ROUTE_ASSOCIATION a "+
    																  " left outer join AMS.dbo.Route_Master b on a.ROUTE_ID=b.RouteID "+
    																  " left outer join AMS.dbo.Users c on c.User_id= a.CREATED_BY and c.System_id=? "+
    																  " left outer join AMS.dbo.Users d on  d.User_id = a.UPDATED_BY and d.System_id=? "+
    																  " left outer join AMS.dbo.VEHICLE_CLIENT e on a.REGISTRATION_NO=e.REGISTRATION_NUMBER "+
    																  " inner join AMS.dbo.Vehicle_User g on a.REGISTRATION_NO=g.Registration_no and g.System_id =? and g.User_id=? "+
    																  " left outer join ADMINISTRATOR.dbo.ASSET_GROUP f on f.GROUP_ID = e.GROUP_ID and f.SYSTEM_ID=e.SYSTEM_ID and f.CUSTOMER_ID=e.CLIENT_ID "+
    																  " where f.SYSTEM_ID=? and f.CUSTOMER_ID=? ";
    																  
    public static final String INSERT_ROUTE_VEHICLE_ASSOCIATION = " insert into AMS.dbo.VEHICLE_ROUTE_ASSOCIATION(REGISTRATION_NO,ROUTE_ID,CREATED_BY,CREATED_TIME) values(?,?,?,getDate())";
    
    public static final String DELETE_ROUTE_VEHICLE_ASSOCIATION = " delete from AMS.dbo.VEHICLE_ROUTE_ASSOCIATION where REGISTRATION_NO = ? and ROUTE_ID = ? ";
    
    public static final String CHECK_EXISTING_ROUTE_VEHICLE_ASSOCIATION = " Select count(*) as Count from AMS.dbo.VEHICLE_ROUTE_ASSOCIATION where REGISTRATION_NO = ? and ROUTE_ID = ? ";
    
    public static final String UPDATE_ROUTE_VEHICLE_ASSOCIATION = " Update AMS.dbo.VEHICLE_ROUTE_ASSOCIATION set REGISTRATION_NO = ?,UPDATED_BY = ?,UpdationTime = getDate() where ROUTE_ID =? and REGISTRATION_NO = ?";
   
    public static final String DELETE_ROUTES_ASSOCIATED_VEHICLES = " delete from AMS.dbo.VEHICLE_ROUTE_ASSOCIATION where ROUTE_ID = ? ";
    
    public static final String CHECK_ROUTES_ASSOCIATED_VEHICLE = " select * from VEHICLE_ROUTE_ASSOCIATION where ROUTE_ID=?  "; 
  
}
