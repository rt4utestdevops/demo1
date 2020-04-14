package t4u.statements;

public class CreateLandmarkStatements {
	public static final String GET_GEO_FENCE_TYPES = "select OperationId,TypeOfOperation from dbo.GeoFenceOperationMaster ";
	
	public static final String GET_GMTLIST = "select isNull(COUNTRY,'') as COUNTRY,isNull(GMT,0) as GMT from COUNTRY_GMT order by COUNTRY";
	
	public static final String CHECK_NAME_EXISTS_IN_AUTHORIZED_LOCATION = "select Description from AuthorizedLocationMaster where upper(Description)=? and SystemId=?";
	
	public static final String GET_MAX_ID_AUTHORIZED_LOCATION = "select max(AuthorizedLocId) as maxid from AuthorizedLocationMaster";
	
	public static final String SAVE_AUTHORIZED_LOCATION = "insert into AuthorizedLocationMaster(AuthorizedLocId,Description,Radius,Latitude,Longitutde,OFFSET,SystemId,Standard_Duration) values(?,?,?,?,?,?,?,?)";
	
	public static final String SAVE_AUTHORIZED_LOCATION_ASSOCIATION = "insert into AuthorizedLocationAssociation(AuthorizedLocId,ClientId,SystemId) values(?,?,?)";
	
	public static final String SELECT_ZONE_FROM_SYSTEM_ID = "select Zone from System_Master where System_id=?";
	
	public static final String CHECK_NAME_EXISTS_IN_LOCATION_BUFFER = "select NAME,HUBID from LOCATION where upper(NAME)=? and CLIENTID=? and SYSTEMID=?";
	
	public static final String GET_MAX_ID_LOCATION_BUFFER = "select max(HUBID) as maxid,max(MAPID) as maxmapid from LOCATION";
	
	public static final String SAVE_LOCATION_BUFFER = "insert into LOCATION (NAME,IMAGE,RADIUS,LATITUDE,LONGITUDE,CLIENTID,SYSTEMID,MAPID,OFFSET,GRIDID,OPERATION_ID,Standard_Duration,REGION,TRIP_CUSTOMER_ID, CONTACT_PERSON,ADDRESS,DESCRIPTION,HUB_CITY,HUB_STATE,PINCODE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public static final String SAVE_POLYGON_LOCATION_DETAILS = "insert into POLYGON_LOCATION_DETAILS(HUBID,SEQUENCE_ID,LATITUDE,LONGITUDE,SYSTEM_ID,CUSTOMER_ID) values(?,?,?,?,?,?)";
	
	public static final String GET_LOCATION_NAMES = "select HUBID,NAME from LOCATION where SYSTEMID=? and CLIENTID=? order by NAME";
	
	public static final String GET_LOCATION_DETAILS = "select HUBID,NAME,RADIUS,IMAGE,LATITUDE,LONGITUDE,OFFSET,GRIDID,Standard_Duration,gfom.TypeOfOperation,REGION,AREA," +
													  " CONTACT_PERSON,ADDRESS,DESCRIPTION, TRIP_CUSTOMER_ID,HUB_CITY,HUB_STATE from LOCATION_ZONE_A lz "+
													  " LEFT OUTER JOIN GeoFenceOperationMaster gfom ON gfom.OperationId=lz.OPERATION_ID where HUBID=?";
	
	public static final String CHECK_IF_POLYGON_LOCATION = "select RADIUS from LOCATION where HUBID=?";
	
	public static final String GET_POLYGON_LOCATION_DETAILS = "select LATITUDE,LONGITUDE from POLYGON_LOCATION_DETAILS where HUBID=? order by SEQUENCE_ID";
	
	public static final String UPDATE_LOCATION_DETAILS ="update LOCATION set NAME=?,IMAGE=?,RADIUS=?,LATITUDE=?,LONGITUDE=?,OFFSET=?,GRIDID=?,Standard_Duration=?,UPDATED_DATE=GETDATE() where HUBID=?";
	
	public static final String DELETE_LOCATION_DETAILS = "delete from LOCATION where HUBID=?";
	
	public static final String SAVE_LOCATION_CLIENT_ASSOCIATION = "insert into LOCATION(MAPID,NAME,LONGITUDE,LATITUDE,TYPE,RADIUS,HUBID,CLIENTID,SYSTEMID,IMAGE,SIGNAGE,OFFSET,OPERATION_ID) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public static final String DELETE_POLYGON_LOCATION_DETAILS = "delete from POLYGON_LOCATION_DETAILS where HUBID=?";
	
	public static final String GET_COMPLETE_POLYGON_LOCATION_DETAILS = "select HUBID,SEQUENCE_ID,LATITUDE,LONGITUDE from POLYGON_LOCATION_DETAILS where HUBID=? order by SEQUENCE_ID";
	
	public static final String GET_OPERATION_ID = "select OperationId from GeoFenceOperationMaster where TypeOfOperation=?";
	
	public static final String CHECK_LAT_LONG_EXISTS_IN_LOCATION_BUFFER="select LATITUDE,LONGITUDE from LOCATION where LATITUDE=? and LONGITUDE=?";
	
	public static final String UPDATE_LOCATION_HUBID_WITH_GENERATED_KEY = "update LOCATION set HUBID=? where ID=?";
	
	public static final String CHECK_LAT_LONG_EXISTS_FOR_SYSTEM_AND_CLIENT ="select LATITUDE,LONGITUDE from LOCATION where SYSTEMID=? and CLIENTID=?";
	
	public static final String SAVE_ROUTE_HUB = "insert into AMS.dbo.ROUTE_HUB(LOCATION,RADIUS,LATITUDE,LONGITUDE,SPEED_LIMIT,CLIENT_ID,SYSTEM_ID,ROUTE_HUB_ID,SEQUENCE,STATUS)values(?,?,?,?,?,?,?,?,?,?)";
	
	public static final String GET_MAX_ROUTE_HUB_ID = "select isNull(max(ROUTE_HUB_ID),0) as ROUTE_HUB_ID  from AMS.dbo.ROUTE_HUB";
	
	public static final String GET_ALL_ROUTE_HUB_ID = " select isNull(ROUTE_HUB_ID,0) as ROUTE_HUB_ID,LATITUDE,LONGITUDE,SEQUENCE,RADIUS  from AMS.dbo.ROUTE_HUB order by RADIUS desc,ROUTE_HUB_ID asc,SEQUENCE desc ";
	
	public static final String SAVE_CHILD_ROUTE_HUB = "insert into AMS.dbo.NESTED_ROUTE_HUB (LOCATION,RADIUS,LATITUDE,LONGITUDE,SPEED_LIMIT,CLIENT_ID,SYSTEM_ID,ROUTE_HUB_ID,SEQUENCE,PARENT_HUB_ID)values(?,?,?,?,?,?,?,?,?,?) " ;
	
	public static final String GET_MAX_CHILD_ROUTE_HUB_ID = "select isNull(max(ROUTE_HUB_ID),0) as ROUTE_HUB_ID  from AMS.dbo.NESTED_ROUTE_HUB ";

	public static final CharSequence GET_EDIT_LOCATION_DETAILS_NEW = "select a.HUBID,a.NAME,a.RADIUS,a.IMAGE,a.LATITUDE,a.LONGITUDE,a.OFFSET," 
		+ " isNull(b.TypeOfOperation,'N/A') as TypeOfOperation,isNull(a.Standard_Duration,'') as Standard_Duration,a.ID, isnull(a.REGION,'') as REGION, " 
		+ " isnull(a.CONTACT_PERSON,'') as CONTACT_PERSON,isnull(a.ADDRESS,'') as ADDRESS ,isnull(c.NAME,'') as TRIP_CUSTOMER from LOCATION a "
		+ " left outer join AMS.dbo.TRIP_CUSTOMER_DETAILS c on a.TRIP_CUSTOMER_ID=c.ID and a.SYSTEMID=c.SYSTEM_ID "
		+ " left outer join GeoFenceOperationMaster b on a.OPERATION_ID=b.OperationId where a.SYSTEMID=? and a.CLIENTID=? ";
	
	public static final CharSequence GET_HUB_ID_NEW = "select HUBID from LOCATION where SYSTEMID=? and CLIENTID=? and NAME=? ";

	public static final CharSequence SELECT_LOCATION_DETAILS = "select MAPID, a.NAME, LONGITUDE, LATITUDE, RADIUS, HUBID, CLIENTID, SYSTEMID, OFFSET, a.ID, " +
			" OPERATION_ID, Standard_Duration,isNull(b.TypeOfOperation,'N/A') as TypeOfOperation,isnull(REGION,'') as REGION, isnull(c.NAME,'') as TRIP_CUSTOMER, " +
			" isnull(a.CONTACT_PERSON,'') as CONTACT_PERSON,isnull(a.ADDRESS,'') as ADDRESS, isnull(a.DESCRIPTION,'') as DESCRIPTION "+
			" from LOCATION a " +
			" left outer join AMS.dbo.TRIP_CUSTOMER_DETAILS c on a.TRIP_CUSTOMER_ID=c.ID and a.SYSTEMID=c.SYSTEM_ID "+
			" left outer join GeoFenceOperationMaster b on a.OPERATION_ID=b.OperationId  where HUBID=?";
	
	public static final String INSERT_INTO_HUB_HISTORY = "insert into dbo.HUB_HISTORY (MAPID, NAME, LONGITUDE, LATITUDE, RADIUS, HUBID, CLIENTID, " +
	"SYSTEMID, OFFSET, OPERATION_ID, ZONE, DELETED_BY) values (?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public static final String DELETE_STATUS_FROM_VEHICLE_BORDER_STATUS = "delete from Vehicle_Status_Border where Hub_id = ?";

	public static final String DELETE_STATUS_FROM_VEHICLE_STATUS = "delete from Vehicle_Status where Hub_id = ?";

	public static final String UPDATE_LOCATION_ZONE = "update LOCATION set NAME=?,RADIUS=?,LATITUDE=?,LONGITUDE=?,OFFSET=?,GRIDID=?,Standard_Duration=?,UPDATED_DATE=GETDATE(),REGION=?,CONTACT_PERSON=?,ADDRESS=?,DESCRIPTION=?,HUB_CITY=?,HUB_STATE=?,PINCODE=? where ID=? and HUBID=?";
	
	public static final String SELECT_LOCATION_ZONE_NESTED_HUB_DETAILS="select NESTED_HUB from LOCATION where ID=? and  HUBID=? ";

	public static final String GET_GEOFENCE_TYPEID = "select OperationId from dbo.GeoFenceOperationMaster where TypeOfOperation=?";
	
	public static final String GET_POLYGONS_FOR_MAP = "select isnull(LOCATION,'') as NAME,ROUTE_HUB_ID,SEQUENCE,LATITUDE,LONGITUDE from dbo.ROUTE_HUB where CLIENT_ID=? and SYSTEM_ID=? order by ROUTE_HUB_ID,SEQUENCE ";
	
	public static final String GET_BUFFERS_FOR_MAP_VIEW = "select LOCATION,LONGITUDE,LATITUDE,RADIUS,isNull(ROUTE_HUB_ID,0) as HUBID from ROUTE_HUB where  RADIUS<> -1 and CLIENT_ID=? and SYSTEM_ID=? ";

	public static final String GET_POLYGON_COORDINATES ="select a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE from dbo.POLYGON_LOCATION_DETAILS a  "+
			"where a.HUBID = ? order by a.SEQUENCE_ID"; 

	public static final String GET_ALL_ROUTE_HUB_COUNT_ID = " select count(s.ROUTE_COUNT) as routeHubCount from ( select count(ROUTE_HUB_ID) as ROUTE_COUNT from ROUTE_HUB group by ROUTE_HUB_ID ) s ";
	
	public static final String GET_ROWSIZE = " select count(*) as rowsize  from AMS.dbo.ROUTE_HUB ";
	
	public static final String GET_LOCATION = " select distinct LOCATION,ROUTE_HUB_ID,SPEED_LIMIT,STATUS,(case when RADIUS=-1 then 'Polygon' else 'Buffer' end) as LOCATION_TYPE from AMS.dbo.ROUTE_HUB where SYSTEM_ID=? and CLIENT_ID=? " ;
	
	public static final String UPDATE_ROUTE_HUB = " update AMS.dbo.ROUTE_HUB set SPEED_LIMIT= ?,STATUS=? where CLIENT_ID=? and SYSTEM_ID=? and ROUTE_HUB_ID=? ";
	 
	public static final String GET_POLYGON_DETAILS = " select a.RADIUS,a.ROUTE_HUB_ID,a.SEQUENCE,a.LATITUDE,a.LONGITUDE from AMS.dbo.ROUTE_HUB a " +
	       " where a.ROUTE_HUB_ID=? order by a.SEQUENCE " ;
	
	public static final String GET_TRIP_CUSTOMER_NAMES=" select ID,isnull(NAME,'') as NAME from dbo.TRIP_CUSTOMER_DETAILS where  CUSTOMER_ID=? and SYSTEM_ID=? and STATUS='Active'";
	
	//public static final String CHECK_HUB_IN_LEGS_DETAILS="select count(*) as COUNT from AMS.dbo.LEG_DETAILS where HUB_ID=? ";
	
	public static final String CHECK_HUB_IN_LEGS_DETAILS=" select b.STATUS,a.HUB_ID from AMS.dbo.LEG_DETAILS a " + 
	" left outer join AMS.dbo.LEG_MASTER b on b.ID=a.LEG_ID " +
	" where a.HUB_ID=? ";
	
	public static final String IS_HUB_NAME_EXIST ="select NAME from LOCATION_ZONE where SYSTEMID=? and CLIENTID=? and TRIP_CUSTOMER_ID=? "; 
	
	public static final String HUB_NAME_FROM_HUB_ID ="select NAME from LOCATION_ZONE where HUBID=?";
	
	public static final String CHECK_LEGS_AND_ROUTES_FOR_GIVEN_HUB_ID=" select count(ID) as Legcount,(select count(ID) as routecount from TRIP_ROUTE_MASTER "+ 
	 " where ID in (select distinct ROUTE_ID from TRIP_ROUTE_DETAILS where LEG_ID IN (SELECT distinct LEG_ID FROM LEG_DETAILS where HUB_ID =?)) "+
	 " and STATUS='Active') as routecount from LEG_MASTER where ID in (SELECT LEG_ID FROM LEG_DETAILS where HUB_ID =?) and STATUS='Active' ";

	public static final String CHECK_NAME_EXISTS = "select NAME,HUBID from LOCATION where upper(NAME)=? and CLIENTID=? and SYSTEMID=? and TRIP_CUSTOMER_ID=? ";

	public static final String CHECK_LAT_LONG_EXISTS="select LATITUDE,LONGITUDE from LOCATION where LATITUDE=? and LONGITUDE=? and TRIP_CUSTOMER_ID=? ";

	public static final String CHECK_IF_LATLONG_CHANGED = " select * from LOCATION where HUBID=? and (LATITUDE!=? or LONGITUDE!=?)";

	public static final String INSERT_INTO_USER_LOG_DETAILS = "insert into ADMINISTRATOR.dbo.USER_LOG_DETAILS values (?,?,?,?,?,?,getdate(),?,?,?)";
	
	public static final String INSERT_INTO_STOCKYARD_DETAILS_IN_CONSUMER_MODEL="insert into sand_consumer_model.stockyard_details (HubName,Address,SystemId,InsertedDateTime,UpdatedDateTime,Latitude,Longitude,HubId,DistrictId,GeoFenceId,StateId,IsActive,AssociatedGeofence,AssociatedSandBlockId,CapacityOfStockyard,AvailableSandQuantity,ReservedSandQuantity,DispatchedSandQuantity) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public static String GET_DISTRICT_ID="SELECT DISTRICT_ID FROM [AMS].[dbo].[DISTRICT_MASTER] WHERE UPPER(DISTRICT_NAME)=? and STATE_ID=391";
	
	public static String DEACTIVATE_STOCKYARD_IN_CONSUMER_PF="update stockyard_details set IsActive=false where HubId=?";
	
	public static String UPDATE_STOCKYARD_IN_CONSUMER_PF="UPDATE stockyard_details SET HubName=?, DistrictId=? , Address=?,Latitude=?,Longitude=?,UpdatedDateTime=? where HubId=?";
	
	public static String UPDATE_STOCKYARD_IN_CONSUMER_PF_WITHOUT_DISTRICT_ID="UPDATE stockyard_details SET HubName=? , Address=?,Latitude=?,Longitude=?,UpdatedDateTime=? where HubId=?";
	
	public static String GET_LATEST_STOCKYARD_ID="select Id from stockyard_details where HubId=?";
	
	public static String INSERT_INTO_SAND_QUALITY_MASTER="INSERT INTO sand_quality_master (StockyardId,QualityName,Rate) values(?,'Pit sand',5)";
	
}
