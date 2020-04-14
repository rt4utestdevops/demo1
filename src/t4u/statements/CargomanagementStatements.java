package t4u.statements;

public class CargomanagementStatements {
/**
 * To fetch List of Hub Names based on Customer
 */
public static final String GET_TOTAL_HUBS="select HUBID,NAME from LOCATION_ZONE where OPERATION_ID=1 " +
										  "and CLIENTID=?";


/**
 * To fetch Trip Names based on Customer
 */
public static final String GET_CARGO_TRIP_NAMES="select TRIP_NAME from dbo.ROUTE_SKELETON where CUSTOMER_ID=? " +
										  "and SYSTEM_ID=? and TYPE='CARGO EXPRESS' ";
/**
 * To fetch Trip Details based on Trip Name
 */
public static final String GET_TRIP_DETAILS="select TRIP_CODE,ORIGIN,DESTINATION,TRANSITION_POINT,STD_TIME,DISTANCE,AVG_SPEED " +
		"from dbo.ROUTE_SKELETON where CUSTOMER_ID=? and TRIP_NAME=? and TYPE='CARGO EXPRESS' ";
/**
 * Inserts Cargo Trip 
 */
 
 public static final String INSERT_CARGO_ROUTE_SKELETON="insert into dbo.ROUTE_SKELETON(TRIP_NAME,TRIP_CODE," +
 		"ORIGIN,DESTINATION,TRANSITION_POINT,STD_TIME,DISTANCE,AVG_SPEED,CUSTOMER_ID,SYSTEM_ID,CREATED_BY,CREATED_TIME,TYPE)" +
 		"values(?,?,?,?,?,?,?,?,?,?,?,getutcdate(),'CARGO EXPRESS')";
 /**
  * Updates Cargo Trip 
  */
 public static final String UPDATE_CARGO_ROUTE_SKELETON="update dbo.ROUTE_SKELETON set TRIP_CODE=?,ORIGIN=?,DESTINATION=?,TRANSITION_POINT=?,STD_TIME=?,DISTANCE=?,AVG_SPEED=? where TRIP_NAME=? and CUSTOMER_ID=? and TYPE='CARGO EXPRESS' ";
 /**
  * Deletes Cargo Trip 
  */
 public static final String DELETE_CARGO_ROUTE_SKELETON="delete from dbo.ROUTE_SKELETON where CUSTOMER_ID=? and TRIP_NAME=? and TYPE='CARGO EXPRESS' ";
 /**
  * To Fetch Route Names
  */
 public static final String GET_TOTAL_ROUTES="select ROUTE_ID,TRIP_NAME from dbo.ROUTE_SKELETON where CUSTOMER_ID=? and SYSTEM_ID=? and TYPE='CARGO EXPRESS' ";
 /**
  * Inserts Cargo Trip Allocation
  */
 public static final String INSERT_TRIP_ALLOCATION="insert into dbo.ROUTE_ALLOCATION(REGISTRATION_NO,ROUTE_ID,CUSTOMER_ID,SYSTEM_ID,CREATED_BY,CREATED_TIME,START_TIME,STATUS) values(?,?,?,?,?,getutcdate(),getutcdate(),'Active')";
 /**
  * check cargo trip already exist
  */
 public static final String TRIP_ALREADY_EXIST="select * from dbo.ROUTE_ALLOCATION where REGISTRATION_NO=? and ROUTE_ID=? and CUSTOMER_ID=?";
 /**
  * Fetch Trip Allocation
  */
 public static final String GET_TRIP_ALLOCATION=" select ra.ID,ra.REGISTRATION_NO,rs.TRIP_NAME,ra.ROUTE_ID,ra.STATUS,rs.TRIP_CODE,dateadd(mi,?,ra.CREATED_TIME) as CREATED_TIME," +
                                                " isnull(cast(rs.ORIGIN_ARRIVAL as varchar(10)),'') as ORIGIN_ARRIVAL,isnull(cast(rs.ORIGIN_DEPARTURE as varchar(10)),'') as ORIGIN_DEPARTURE from dbo.ROUTE_ALLOCATION ra"+
 												" inner join dbo.VehicleRegistration v on ra.REGISTRATION_NO=v.RegistrationNo " +
 												" inner join dbo.Vehicle_User vu on vu.Registration_no=ra.REGISTRATION_NO " +
 												" left outer join dbo.ROUTE_SKELETON rs on ra.ROUTE_ID=rs.ROUTE_ID " +
 												" where ra.SYSTEM_ID=? and ra.CUSTOMER_ID=? and vu.User_id=? and v.Status='Active'";
 
 

 /**
  * Updates Trip Allocation
  */
 public static final String UPDATE_TRIP_ALLOCATION="update AMS.dbo.ROUTE_ALLOCATION set REGISTRATION_NO=?,ROUTE_ID=?,CREATED_TIME=getutcdate(),STATUS=? where SYSTEM_ID=? and CUSTOMER_ID=?  and ID=?";
 /**
  * Close Trip Allocation
  */
 public static final String CLOSE_TRIP_ALLOCATION="update AMS.dbo.ROUTE_ALLOCATION set END_TIME=dateadd(mi,-?,?),STATUS=? where REGISTRATION_NO=? and ROUTE_ID=?  and CUSTOMER_ID=?";
 /**
  * Fetch DashBoard Details 
  */
 public static final String GET_DASHBOARD_DETAILS="select ra.REGISTRATION_NO,ra.ROUTE_ID,ra.START_TIME,ra.PLANNED_ENDDATE,rs.TRIP_NAME,rs.ORIGIN,l.NAME as ORGIN_NAME,rs.DESTINATION," +
 		"rs.TRANSITION_POINT,rs.DISTANCE,rs.STD_TIME,l1.NAME as DESTINATION_NAME from dbo.ROUTE_ALLOCATION ra " +
 		"left outer join dbo.ROUTE_SKELETON rs on ra.ROUTE_ID=rs.ROUTE_ID " +
 		"left outer join dbo.LOCATION_ZONE l on l.HUBID=rs.ORIGIN  " +
 		"left outer join  dbo.LOCATION_ZONE l1 on l1.HUBID=rs.DESTINATION " +
 		"where STATUS='Open' and rs.SYSTEM_ID=? and rs.CUSTOMER_ID=?";
 
 /**
  * Fetch Latest HubReport
  */
 public static final String GET_TOP_HUB_REPORT="select  top 1 HUB_ID  from dbo.HUB_REPORT where REGISTRATION_NO=? and SYSTEM_ID=? order by ACTUAL_ARRIVAL";


	/**
	 * To fetch Vehicle Registration, Unit No and Unit type from dbo.Vehicle_association and dbo.Unit_Type_Master table
	 */
	public static final String GET_VEHICLES = "select a.Registration_no,a.Unit_Number,b.UNIT_NAME as Unit_type_desc,c.VehicleAlias from dbo.Vehicle_association a inner join ADMINISTRATOR.dbo.UNIT_TYPE b on a.Unit_Type_Code=b.UNIT_TYPE_CODE "+
										
	 " inner join dbo.Vehicle_User vu on vu.Registration_no=a.Registration_no left outer join tblVehicleMaster c on a.Registration_no=c.VehicleNo where a.System_id=? and a.Client_id=? and vu.User_id=? and a.Registration_no not in (select REGISTRATION_NO from dbo.ROUTE_ALLOCATION where STATUS='Open')";
	
	/**
	 * To fetch Trip Name
	 */
	public static final String GET_TRIP_NAME="select * from dbo.ROUTE_SKELETON where CUSTOMER_ID=? and SYSTEM_ID=? and TRIP_NAME=? and TYPE='CARGO EXPRESS' ";

	/**
	 * To fetch Transition Location
	 */
	public static final String GET_TRANSITION_LOCATION="select NAME from dbo.LOCATION_ZONE where HUBID=? and SYSTEMID=? and CLIENTID=?";
	
	
	
	public static final String GET_ASSET_NUMBER="select REGISTRATION_NUMBER from AMS.dbo.tblVehicleMaster tb left outer join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id left outer join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id  where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=?  order by REGISTRATION_NUMBER";
	
	
	public static final String GET_GROUP_NAME_FOR_CLIENT="select GROUP_ID,GROUP_NAME from VEHICLE_GROUP where CLIENT_ID=? and SYSTEM_ID=? order by GROUP_NAME";	
	
	
	public static final String GET_VEHICLE_WHICH_IS_BELONG_GROUP="select distinct REGISTRATION_NUMBER,GROUP_ID from AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) inner join AMS.dbo.Vehicle_User vu (NOLOCK) on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and GROUP_ID=? order by REGISTRATION_NUMBER";
	
	
	public static final String GET_VEHICLE_FOR_CLIENT="select distinct REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) inner join AMS.dbo.Vehicle_User vu (NOLOCK) on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? order by REGISTRATION_NUMBER";
	
	public static final String GET_PLANT_MOVEMENT_DETAILS="select isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER,isnull(d.TRIP_NAME,'') as TRIP_NAME ,dateadd(mi,?,a.START_TIME) as START_TIME,isnull(b.NAME,'') as STARTLOCATION,dateadd(mi,?,a.END_TIME) as END_TIME,isnull(c.NAME,'') as ENDLOCATION,isnull(a.DISTANCE,'0.0') as DISTANCE,isnull(a.RUNNING_TIME,'0.0') as RUNNING_TIME,isnull(a.TRAVEL_TIME,'0.0') as TRAVEL_TIME from AMS.dbo.ROUTE_SUMMARY a (NOLOCK) inner join AMS.dbo.ROUTE_SKELETON d (NOLOCK) on d.SYSTEM_ID=a.SYSTEM_ID and d.CUSTOMER_ID=a.CUSTOMER_ID and d.ROUTE_ID=a.ROUTE_ID inner join AMS.dbo.LOCATION_ZONE_# b (NOLOCK) on b.OPERATION_ID=1 and b.HUBID=a.START_HUB left outer join AMS.dbo.LOCATION_ZONE_# c (NOLOCK) on c.OPERATION_ID=1 and c.HUBID=a.END_HUB where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and a.ASSET_NUMBER in (@) and a.START_TIME > = dateadd(mi,-?,?) and a.START_TIME < dateadd(mi,-?,?) order by START_TIME";
	
	public static final String GET_TOTAL_ASSET_COUNT_FOR_CLIENT = "select count(*) as COUNT from gpsdata_history_latest a "
											+ "inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
											+" inner join AMS.dbo.tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
											+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=?";
	
	public static final String GET_TOTAL_ASSET_COUNT_FOR_LTSP="select count(*) as COUNT from gpsdata_history_latest a "
												+ "inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
												+" inner join AMS.dbo.tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
												+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=?";
	
	public static final String GET_NON_COMMUNICATING_FOR_CLIENT="select count(a.REGISTRATION_NO) as NON_COMMUNICATING from AMS.dbo.gpsdata_history_latest a " +
												"inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	
												+" inner join AMS.dbo.tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id  and Status='Active' "
												+"where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= 3 and b.User_id=?";
    
	
	public static final String GET_NON_COMMUNICATING_FOR_LTSP="select count(a.REGISTRATION_NO) as NON_COMMUNICATING from AMS.dbo.gpsdata_history_latest a " +
											"inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	
											+" inner join AMS.dbo.tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
											+"where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= 3 and b.User_id=?";
	
	
	public static final String GET_NO_GPS_COUNT_FOR_CLIENT =" select count(*) as COUNT from AMS.dbo.gpsdata_history_latest a " +
															" inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	+
															" inner join AMS.dbo.tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id  and Status='Active' "+
															" where a.CLIENTID=? and a.System_id=? and a.LOCATION ='No GPS Device Connected' and b.User_id=?";
	
	
	public static final String GET_NO_GPS_COUNT_FOR_LTSP=" select count(*) as COUNT from AMS.dbo.gpsdata_history_latest a " +
												         " inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	+
												         " inner join AMS.dbo.tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "+
												         " where a.CLIENTID=? and a.System_id=? and a.LOCATION ='No GPS Device Connected' and b.User_id=?";

	public static final String GET_ON_SCHEDULE_COUNT =  " select count(ASSET_NUMBER) as SCHEDULE from AMS.dbo.CARGO_TRIP_SUMMARY a " +
														" inner join AMS.dbo.ROUTE_SKELETON b on a.ROUTE_ID=b.ROUTE_ID and a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
														" inner join AMS.dbo.ROUTE_ALLOCATION c on a.ASSET_NUMBER=c.REGISTRATION_NO and a.ROUTE_ID=c.ROUTE_ID and a.CUSTOMER_ID=c.CUSTOMER_ID and a.SYSTEM_ID=c.SYSTEM_ID" +
														" inner join  AMS.dbo.Vehicle_User d on a.ASSET_NUMBER=d.Registration_no and a.SYSTEM_ID=d.System_id  " +
														" where a.STATUS='Open' and c.STATUS='Active' and a.CUSTOMER_ID=? and a.SYSTEM_ID=? and  d.User_id=? and a.AVG_SPEED>=b.AVG_SPEED ";
												
	public static final String GET_BSV_ACTION_REQUIRED_COUNT = " select count(ASSET_NUMBER) as ACTION_REQUIRED from AMS.dbo.CARGO_TRIP_SUMMARY a inner join dbo.ROUTE_SKELETON b on a.ROUTE_ID=b.ROUTE_ID and a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
															   " inner join AMS.dbo.ROUTE_ALLOCATION c on a.ASSET_NUMBER=c.REGISTRATION_NO and a.ROUTE_ID=c.ROUTE_ID and a.CUSTOMER_ID=c.CUSTOMER_ID and a.SYSTEM_ID=c.SYSTEM_ID " +
															   " inner join AMS.dbo.gpsdata_history_latest d on c.REGISTRATION_NO=d.REGISTRATION_NO and d.System_id=c.SYSTEM_ID" +
															   " inner join  AMS.dbo.Vehicle_User e on a.ASSET_NUMBER=e.Registration_no and a.SYSTEM_ID=e.System_id " +
															   " where a.STATUS='Open' and c.STATUS='Active' and a.CUSTOMER_ID=? and a.SYSTEM_ID=? and e.User_id=? and a.AVG_SPEED < b.AVG_SPEED-(b.AVG_SPEED*0.25) ";
	
	public static final String GET_BSV_UNDER_OBSERVATION_COUNT =" select count(ASSET_NUMBER) as UNDER_OBSERVATION from AMS.dbo.CARGO_TRIP_SUMMARY a " +
																" inner join AMS.dbo.ROUTE_SKELETON b on a.ROUTE_ID=b.ROUTE_ID and a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
																" inner join AMS.dbo.ROUTE_ALLOCATION c on a.ASSET_NUMBER=c.REGISTRATION_NO and a.ROUTE_ID=c.ROUTE_ID and a.CUSTOMER_ID=c.CUSTOMER_ID and a.SYSTEM_ID=c.SYSTEM_ID" +
																" inner join AMS.dbo.Vehicle_User d on a.ASSET_NUMBER = d.Registration_no and a.SYSTEM_ID=d.System_id " +
																" where a.STATUS='Open' and c.STATUS='Active' and a.CUSTOMER_ID=? and a.SYSTEM_ID=? and  d.User_id=? and a.AVG_SPEED < b.AVG_SPEED and a.AVG_SPEED >(b.AVG_SPEED -b.AVG_SPEED*0.25)";
	
	
	public static final String GET_ROUTE_SKELETON_REPORT = "select a.ROUTE_ID,isnull(a.ORIGIN,'')as ORIGIN,isnull(a.DESTINATION,'')as DESTINATION,isnull(a.TRIP_CODE,'')as ROUTE_CODE,isnull(a.TRIP_NAME,'') as ROUTE_NAME,isnull(b.NAME,'') as ROUTE_ORIGIN,isnull(c.NAME,'') as ROUTE_DESTINATION,isnull(a.STD_TIME,'') as TOTAL_TIME,isnull(a.DISTANCE,'') as APPROX_DISTANCE,isnull(a.AVG_SPEED,'') as AVERAGE_SPEED, isnull(a.ORIGIN_ARRIVAL,'') as ORIGIN_ARRIVAL,isnull(a.ORIGIN_DEPARTURE,'') as ORIGIN_DEPARTURE,isnull(a.DESTINATION_ARRIVAL,'') as DESTINATION_ARRIVAL,isnull(a.DESTINATION_DEPARTURE,'') as DESTINATION_DEPARTURE from AMS.dbo.ROUTE_SKELETON a left outer join AMS.dbo.LOCATION_ZONE_A b on b.HUBID = a.ORIGIN and a.SYSTEM_ID=b.SYSTEMID left outer join AMS.dbo.LOCATION_ZONE_A c on c.HUBID=a.DESTINATION and a.SYSTEM_ID=c.SYSTEMID where a.CUSTOMER_ID=? and a.SYSTEM_ID=? AND a.TYPE='CARGO EXPRESS' ";

	public static final String GET_ROUTE_TRANSITION_POINTS = "select isnull(TRANSITION_POINT,'')as TRANSITION_POINT,isnull(TRANSITION_POINT_ARRIVAL,'') as TRANSITION_POINT_ARRIVAL,isnull(TRANSITION_POINT_DEPARTURE,'') as TRANSITION_POINT_DEPARTURE,isnull(SEQUENCE,'') as SEQUENCE from dbo.ROUTE_TRANSITION_POINTS where ROUTE_ID = ? and CUSTOMER_ID=? and SYSTEM_ID=? ";
 
	public static final String DELETE_TRANSITION = "delete from dbo.ROUTE_TRANSITION_POINTS where ROUTE_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? ";

	public static final String INSERT_ROUTE_TRANSITION_POINTS = "insert into dbo.ROUTE_TRANSITION_POINTS(ROUTE_ID,TRANSITION_POINT,TRANSITION_POINT_ARRIVAL,TRANSITION_POINT_DEPARTURE,SEQUENCE,CUSTOMER_ID,SYSTEM_ID)" +
	 "values(?,?,?,?,?,?,?) ";
	
	public static final String UPDATE_ROUTE_SKELETON="update dbo.ROUTE_SKELETON set TRIP_CODE=?,TRIP_NAME=?,ORIGIN=?,DESTINATION=?,STD_TIME=?,DISTANCE=?,AVG_SPEED=?, ORIGIN_ARRIVAL=?, ORIGIN_DEPARTURE=?, DESTINATION_ARRIVAL=?, DESTINATION_DEPARTURE=? where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=?";
	
	public static final String INSERT_ROUTE_SKELETON="insert into dbo.ROUTE_SKELETON(TRIP_CODE,TRIP_NAME," +
	"ORIGIN,DESTINATION,STD_TIME,DISTANCE,AVG_SPEED,ORIGIN_ARRIVAL,ORIGIN_DEPARTURE,DESTINATION_ARRIVAL,DESTINATION_DEPARTURE,CUSTOMER_ID,SYSTEM_ID,CREATED_BY,CREATED_TIME,TYPE)" +
	"values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),'CARGO EXPRESS')";

	public static final String GET_ON_SCHEDULE_DETAILS = " select isnull(a.ASSET_NUMBER,'')as VEHICLE_NUMBER,isnull(b.TRIP_NAME,'')as ROUTE_NAME,isnull(b.TRIP_CODE,'')as " +
                                               			 " ROUTE_CODE,isnull(dateadd(mi,?,a.TRIP_START_TIME),'') as TRIP_START_TIME,isnull(d.LOCATION,'')as CURRENT_LOCATION," +
                                               			 " isnull(a.AVG_SPEED,'')as AVERAGE_SPEED,dateadd(mi,?,d.GMT)as LAST_COMMUNICATED,isnull(a.IDLE_TIME,0)as IDLE_TIME," +
                                               			 " isnull(a.DISTANCE,'')as DISTANCE_TRAVELLED,isnull(a.DELAY_TIME,0)as DELAY_TIME,isnull(dateadd(mi,?,SCHEDULED_TRIP_END_TIME),'')as SCHEDULED_ARRIVAL," +
                                               			 " isnull(f.NAME,'')as FROM_PLACE,isnull(g.NAME,'')as TO_DESTINATION  " +
                                               			 " from AMS.dbo.CARGO_TRIP_SUMMARY a " +
                                               			 " inner join AMS.dbo.ROUTE_SKELETON b on a.ROUTE_ID=b.ROUTE_ID and a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
                                               			 " left outer join AMS.dbo.LOCATION_ZONE_A  f on f.HUBID = b.ORIGIN and b.CUSTOMER_ID=f.CLIENTID and b.SYSTEM_ID=f.SYSTEMID" +
                                               			 " left outer join AMS.dbo.LOCATION_ZONE_A g on g.HUBID = b.DESTINATION and b.SYSTEM_ID=g.SYSTEMID and  b.CUSTOMER_ID=g.CLIENTID " +
			                                             " inner join AMS.dbo.ROUTE_ALLOCATION c on a.ASSET_NUMBER=c.REGISTRATION_NO and a.ROUTE_ID=c.ROUTE_ID and a.CUSTOMER_ID=c.CUSTOMER_ID and a.SYSTEM_ID=c.SYSTEM_ID and c.STATUS='Active'" +
			                                             " inner join AMS.dbo.gpsdata_history_latest d on a.ASSET_NUMBER=d.REGISTRATION_NO and a.CUSTOMER_ID=d.CLIENTID and a.SYSTEM_ID=d.System_id " +
			                                             " inner join AMS.dbo.Vehicle_User vu on d.REGISTRATION_NO = vu.Registration_no " +
			                                             " where a.STATUS='Open' and a.CUSTOMER_ID=? and a.SYSTEM_ID=? and vu.User_id=? and a.AVG_SPEED>=b.AVG_SPEED ";

	public static final String GET_BSV_ACTION_REQUIRED_DETAILS =" select isnull(a.ASSET_NUMBER,'')as VEHICLE_NUMBER,isnull(b.TRIP_NAME,'')as ROUTE_NAME,isnull(b.TRIP_CODE,'')as " +
																" ROUTE_CODE,isnull(dateadd(mi,?,a.TRIP_START_TIME),'') as TRIP_START_TIME,isnull(d.LOCATION,'')as CURRENT_LOCATION," +
																" isnull(a.AVG_SPEED,'')as AVERAGE_SPEED,dateadd(mi,?,d.GMT)as LAST_COMMUNICATED,isnull(a.IDLE_TIME,0)as IDLE_TIME," +
																" isnull(a.DISTANCE,'')as DISTANCE_TRAVELLED ,isnull(a.DELAY_TIME,0)as DELAY_TIME,isnull(dateadd(mi,?,SCHEDULED_TRIP_END_TIME),'')as SCHEDULED_ARRIVAL," +
																" isnull(f.NAME,'')as FROM_PLACE,isnull(g.NAME,'')as TO_DESTINATION  " +
																" from AMS.dbo.CARGO_TRIP_SUMMARY a " +
																" inner join AMS.dbo.ROUTE_SKELETON b on a.ROUTE_ID=b.ROUTE_ID and a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
																" left outer join AMS.dbo.LOCATION_ZONE_A  f on f.HUBID = b.ORIGIN and b.CUSTOMER_ID=f.CLIENTID and b.SYSTEM_ID=f.SYSTEMID " +
																" left outer join AMS.dbo.LOCATION_ZONE_A g on g.HUBID = b.DESTINATION and b.SYSTEM_ID=g.SYSTEMID and b.CUSTOMER_ID=g.CLIENTID " +
																" inner join AMS.dbo.ROUTE_ALLOCATION c on a.ASSET_NUMBER=c.REGISTRATION_NO and a.ROUTE_ID=c.ROUTE_ID and a.CUSTOMER_ID=c.CUSTOMER_ID and a.SYSTEM_ID=c.SYSTEM_ID and c.STATUS='Active'" +
																" inner join AMS.dbo.gpsdata_history_latest d on a.ASSET_NUMBER=d.REGISTRATION_NO and a.CUSTOMER_ID=d.CLIENTID and a.SYSTEM_ID=d.System_id" +
																" inner join  AMS.dbo.Vehicle_User e on a.ASSET_NUMBER=e.Registration_no " +
																" where a.STATUS='Open' and a.CUSTOMER_ID=? and a.SYSTEM_ID=? and e.User_id=? and a.AVG_SPEED < b.AVG_SPEED-(b.AVG_SPEED*0.25) ";
	
	public static final String GET_BSV_UNDER_OBSERVATION_DETAILS =  " select isnull(a.ASSET_NUMBER,'')as VEHICLE_NUMBER,isnull(b.TRIP_NAME,'')as ROUTE_NAME,isnull(b.TRIP_CODE,'')as ROUTE_CODE," +
																	" isnull(dateadd(mi,?,a.TRIP_START_TIME),'') as TRIP_START_TIME,isnull(d.LOCATION,'')as CURRENT_LOCATION," +
																	" isnull(a.AVG_SPEED,'')as AVERAGE_SPEED,dateadd(mi,?,d.GMT)as LAST_COMMUNICATED,isnull(a.IDLE_TIME,0)as IDLE_TIME," +
																	" isnull(a.DISTANCE,'')as DISTANCE_TRAVELLED,isnull(a.DELAY_TIME,0)as DELAY_TIME,isnull(dateadd(mi,?,SCHEDULED_TRIP_END_TIME),'')as SCHEDULED_ARRIVAL," +
																	" isnull(f.NAME,'')as FROM_PLACE,isnull(g.NAME,'')as TO_DESTINATION   " +
																	" from AMS.dbo.CARGO_TRIP_SUMMARY a " +
																	" inner join AMS.dbo.ROUTE_SKELETON b on a.ROUTE_ID=b.ROUTE_ID and a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
																	" left outer join AMS.dbo.LOCATION_ZONE_A  f on f.HUBID = b.ORIGIN and b.CUSTOMER_ID=f.CLIENTID and b.SYSTEM_ID=f.SYSTEMID" +
																	" left outer join AMS.dbo.LOCATION_ZONE_A g on g.HUBID = b.DESTINATION and b.SYSTEM_ID=g.SYSTEMID and b.CUSTOMER_ID=g.CLIENTID " +
																	" inner join AMS.dbo.ROUTE_ALLOCATION c on a.ASSET_NUMBER=c.REGISTRATION_NO and a.ROUTE_ID=c.ROUTE_ID and a.CUSTOMER_ID=c.CUSTOMER_ID and a.SYSTEM_ID=c.SYSTEM_ID and c.STATUS='Active'" +
																	" inner join AMS.dbo.gpsdata_history_latest d on a.ASSET_NUMBER=d.REGISTRATION_NO and a.CUSTOMER_ID=d.CLIENTID and a.SYSTEM_ID=d.System_id " +
																	" inner join AMS.dbo.Vehicle_User vu on d.REGISTRATION_NO = vu.Registration_no " +
																	" where a.STATUS='Open' and a.CUSTOMER_ID=? and a.SYSTEM_ID=? and vu.User_id =? and a.AVG_SPEED < b.AVG_SPEED and a.AVG_SPEED >(b.AVG_SPEED -b.AVG_SPEED*0.25) ";

	public static final String GET_TOTAL_ASSET_DETAILS_FOR_LTSP = " select a.UNIT_NO,isnull(a.REGISTRATION_NO,'')as VEHICLE_NUMBER,isnull(d.TRIP_NAME,'')as ROUTE_NAME," +
																" isnull(d.TRIP_CODE,'')as ROUTE_CODE,isnull(dateadd(mi,?,cts.TRIP_START_TIME) ,'') as TRIP_START_TIME,isnull(a.LOCATION,'')as CURRENT_LOCATION, " +
																" isnull(d.AVG_SPEED,'')as AVERAGE_SPEED,isnull(dateadd(mi,?,a.GMT),'') as LAST_COMMUNICATED , isnull(cts.IDLE_TIME,0)as IDLE_TIME," +
																" isnull(cts.DISTANCE,'')as DISTANCE_TRAVELLED , isnull(cts.DELAY_TIME,0)as DELAY_TIME,isnull(dateadd(mi,?,cts.SCHEDULED_TRIP_END_TIME),'')as SCHEDULED_ARRIVAL, " +
																" isnull(f.NAME,'')as FROM_PLACE,isnull(g.NAME,'')as TO_DESTINATION,(case when (a.LOCATION ='No GPS Device Connected' ) then 'NO GPS'" +
																" else(case when ( DATEDIFF(hh,a.GMT,getutcdate()) >= 3) then 'NON COMMUNICATING' else (case when (cts.TRIP_START_TIME != null) then '' " +
																" else(case when (cts.AVG_SPEED>=d.AVG_SPEED) then 'On Schedule' " +
																" else (case when (cts.AVG_SPEED < d.AVG_SPEED-(d.AVG_SPEED*0.25)) then 'Behind The Schedule Action Required' " +
																" else (case when (cts.AVG_SPEED < d.AVG_SPEED and cts.AVG_SPEED >(d.AVG_SPEED -d.AVG_SPEED*0.25)) then 'Behind The Schedule Under Observation' " +
																" else 'COMMUNICATING' end) end) end )end ) end) end) as STATUS  " +
																" from AMS.dbo.gpsdata_history_latest a " +
																" left outer join AMS.dbo.ROUTE_ALLOCATION c on c.REGISTRATION_NO=a.REGISTRATION_NO and c.SYSTEM_ID=a.System_id and c.STATUS='Active' " +
																" left outer join AMS.dbo.ROUTE_SKELETON d on c.ROUTE_ID=d.ROUTE_ID and a.CLIENTID=d.CUSTOMER_ID and a.System_id=d.SYSTEM_ID  " +
																" left outer join AMS.dbo.LOCATION_ZONE_A  f on f.HUBID = d.ORIGIN and d.CUSTOMER_ID=f.CLIENTID and d.SYSTEM_ID=f.SYSTEMID " +
																" left outer join AMS.dbo.LOCATION_ZONE_A g on g.HUBID = d.DESTINATION and d.SYSTEM_ID=g.SYSTEMID and d.CUSTOMER_ID=g.CLIENTID " +
																" left outer join AMS.dbo.CARGO_TRIP_SUMMARY cts on c.REGISTRATION_NO=cts.ASSET_NUMBER and c.CUSTOMER_ID=cts.CUSTOMER_ID and c.SYSTEM_ID=cts.SYSTEM_ID and cts.STATUS='Open'  " +
																" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no" +
																" inner join AMS.dbo.tblVehicleMaster e on b.Registration_no=e.VehicleNo and b.System_id=e.System_id  " +
																" where a.System_id = ? and a.CLIENTID = ? and b.User_id= ?";
	
	public static final String GET_TOTAL_ASSET_DETAILS_FOR_CLIENT = " select a.UNIT_NO,isnull(a.REGISTRATION_NO,'')as VEHICLE_NUMBER,isnull(d.TRIP_NAME,'')as ROUTE_NAME," +
																	" isnull(d.TRIP_CODE,'')as ROUTE_CODE,isnull(dateadd(mi,?,cts.TRIP_START_TIME) ,'') as TRIP_START_TIME,isnull(a.LOCATION,'')as CURRENT_LOCATION, " +
																	" isnull(d.AVG_SPEED,'')as AVERAGE_SPEED,isnull(dateadd(mi,?,a.GMT),'') as LAST_COMMUNICATED , isnull(cts.IDLE_TIME,0)as IDLE_TIME," +
																	" isnull(cts.DISTANCE,'')as DISTANCE_TRAVELLED , isnull(cts.DELAY_TIME,0)as DELAY_TIME,isnull(dateadd(mi,?,cts.SCHEDULED_TRIP_END_TIME),'')as SCHEDULED_ARRIVAL, " +
																	" isnull(f.NAME,'')as FROM_PLACE,isnull(g.NAME,'')as TO_DESTINATION,(case when (a.LOCATION ='No GPS Device Connected' ) then 'NO GPS'" +
																	" else(case when ( DATEDIFF(hh,a.GMT,getutcdate()) >= 3) then 'NON COMMUNICATING' else (case when (cts.TRIP_START_TIME != null) then '' " +
																	" else(case when (cts.AVG_SPEED>=d.AVG_SPEED) then 'On Schedule' " +
																	" else (case when (cts.AVG_SPEED < d.AVG_SPEED-(d.AVG_SPEED*0.25)) then 'Behind The Schedule Action Required' " +
																	" else (case when (cts.AVG_SPEED < d.AVG_SPEED and cts.AVG_SPEED >(d.AVG_SPEED -d.AVG_SPEED*0.25)) then 'Behind The Schedule Under Observation' " +
																	" else 'COMMUNICATING' end) end) end )end ) end) end) as STATUS  " +
																	" from AMS.dbo.gpsdata_history_latest a " +
																	" left outer join AMS.dbo.ROUTE_ALLOCATION c on c.REGISTRATION_NO=a.REGISTRATION_NO and c.SYSTEM_ID=a.System_id and c.STATUS='Active' " +
																	" left outer join AMS.dbo.ROUTE_SKELETON d on c.ROUTE_ID=d.ROUTE_ID and a.CLIENTID=d.CUSTOMER_ID and a.System_id=d.SYSTEM_ID  " +
																	" left outer join AMS.dbo.LOCATION_ZONE_A  f on f.HUBID = d.ORIGIN and d.CUSTOMER_ID=f.CLIENTID and d.SYSTEM_ID=f.SYSTEMID " +
																	" left outer join AMS.dbo.LOCATION_ZONE_A g on g.HUBID = d.DESTINATION and d.SYSTEM_ID=g.SYSTEMID and d.CUSTOMER_ID=g.CLIENTID " +
																	" left outer join AMS.dbo.CARGO_TRIP_SUMMARY cts on c.REGISTRATION_NO=cts.ASSET_NUMBER and c.CUSTOMER_ID=cts.CUSTOMER_ID and c.SYSTEM_ID=cts.SYSTEM_ID and cts.STATUS='Open'  " +
																	" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no" +
																	" inner join AMS.dbo.tblVehicleMaster e on b.Registration_no=e.VehicleNo and b.System_id=e.System_id  and Status='Active' " +
																	" where a.System_id = ? and a.CLIENTID = ? and b.User_id= ?";

	public static final String GET_NON_COMMUNICATING_DETAILS_FOR_LTSP =  " select isnull(a.REGISTRATION_NO,'')as VEHICLE_NUMBER,isnull(d.TRIP_NAME,'')as ROUTE_NAME,isnull(d.TRIP_CODE,'')as "+
					  													 " ROUTE_CODE,isnull(dateadd(mi,?,cts.TRIP_START_TIME) ,'') as TRIP_START_TIME,isnull(a.LOCATION,'')as CURRENT_LOCATION, "+
					  													 " isnull(d.AVG_SPEED,'')as AVERAGE_SPEED,isnull(dateadd(mi,?,a.GMT),'') as LAST_COMMUNICATED, "+
																	     " isnull(cts.IDLE_TIME,0)as IDLE_TIME,isnull(cts.DISTANCE,'')as DISTANCE_TRAVELLED ," +
																	     " isnull(cts.DELAY_TIME,0)as DELAY_TIME,isnull(dateadd(mi,?,cts.SCHEDULED_TRIP_END_TIME),'')as SCHEDULED_ARRIVAL," +
																		 " isnull(f.NAME,'')as FROM_PLACE,isnull(g.NAME,'')as TO_DESTINATION   " +
					  													 " from AMS.dbo.gpsdata_history_latest a "+
					  													 " left outer join AMS.dbo.ROUTE_ALLOCATION c on c.REGISTRATION_NO=a.REGISTRATION_NO and c.SYSTEM_ID=a.System_id and c.STATUS='Active' "+
					  													 " left outer join AMS.dbo.ROUTE_SKELETON d on c.ROUTE_ID=d.ROUTE_ID and a.CLIENTID=d.CUSTOMER_ID and a.System_id=d.SYSTEM_ID  "+
																		 " left outer join AMS.dbo.LOCATION_ZONE_A  f on f.HUBID = d.ORIGIN and d.CUSTOMER_ID=f.CLIENTID and d.SYSTEM_ID=f.SYSTEMID "+
																		 " left outer join AMS.dbo.LOCATION_ZONE_A g on g.HUBID = d.DESTINATION and d.SYSTEM_ID=g.SYSTEMID and d.CUSTOMER_ID=g.CLIENTID " +
																		 " left outer join AMS.dbo.CARGO_TRIP_SUMMARY cts on a.REGISTRATION_NO=cts.ASSET_NUMBER and a.CLIENTID=cts.CUSTOMER_ID and a.System_id=cts.SYSTEM_ID and cts.STATUS='Open' " +
					  													 " inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no "+
					  													 " inner join AMS.dbo.tblVehicleMaster e on b.Registration_no=e.VehicleNo and b.System_id=e.System_id "+
					  													 " where a.System_id = ? and a.CLIENTID = ? and b.User_id= ? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= 3 ";
	
	public static final String GET_NON_COMMUNICATING_DETAILS_FOR_CLIENT =   " select isnull(a.REGISTRATION_NO,'')as VEHICLE_NUMBER,isnull(d.TRIP_NAME,'')as ROUTE_NAME,isnull(d.TRIP_CODE,'')as "+
							 												" ROUTE_CODE,isnull(dateadd(mi,?,cts.TRIP_START_TIME) ,'') as TRIP_START_TIME,isnull(a.LOCATION,'')as CURRENT_LOCATION, "+
							 												" isnull(d.AVG_SPEED,'')as AVERAGE_SPEED,isnull(dateadd(mi,?,a.GMT),'') as LAST_COMMUNICATED , "+
																			" isnull(cts.IDLE_TIME,0)as IDLE_TIME,isnull(cts.DISTANCE,'')as DISTANCE_TRAVELLED, " +
																			" isnull(cts.DELAY_TIME,0)as DELAY_TIME,isnull(dateadd(mi,?,cts.SCHEDULED_TRIP_END_TIME),'')as SCHEDULED_ARRIVAL," +
																			" isnull(f.NAME,'')as FROM_PLACE,isnull(g.NAME,'')as TO_DESTINATION   " +
							 												" from AMS.dbo.gpsdata_history_latest a "+
							 												" left outer join AMS.dbo.ROUTE_ALLOCATION c on c.REGISTRATION_NO=a.REGISTRATION_NO and c.SYSTEM_ID=a.System_id and c.STATUS='Active' "+
							 												" left outer join AMS.dbo.ROUTE_SKELETON d on c.ROUTE_ID=d.ROUTE_ID and a.CLIENTID=d.CUSTOMER_ID and a.System_id=d.SYSTEM_ID  "+
																		    " left outer join AMS.dbo.LOCATION_ZONE_A  f on f.HUBID = d.ORIGIN and d.CUSTOMER_ID=f.CLIENTID and d.SYSTEM_ID=f.SYSTEMID "+
																			" left outer join AMS.dbo.LOCATION_ZONE_A g on g.HUBID = d.DESTINATION and d.SYSTEM_ID=g.SYSTEMID and  d.CUSTOMER_ID=g.CLIENTID " +
																			" left outer join AMS.dbo.CARGO_TRIP_SUMMARY cts on a.REGISTRATION_NO=cts.ASSET_NUMBER and a.CLIENTID=cts.CUSTOMER_ID and a.System_id=cts.SYSTEM_ID and cts.STATUS='Open' " +
					                                                        " inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no "+
							 												" inner join AMS.dbo.tblVehicleMaster e on b.Registration_no=e.VehicleNo and b.System_id=e.System_id and  Status='Active' "+
							 												" where a.System_id = ? and a.CLIENTID = ? and b.User_id= ? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= 3 ";

	public static final String GET_NO_GPS_DETAILS_FOR_LTSP = " select isnull(a.REGISTRATION_NO,'')as VEHICLE_NUMBER,isnull(d.TRIP_NAME,'')as ROUTE_NAME,isnull(d.TRIP_CODE,'')as "+
		  													 " ROUTE_CODE,isnull(dateadd(mi,?,cts.TRIP_START_TIME ),'') as TRIP_START_TIME,isnull(a.LOCATION,'')as CURRENT_LOCATION, "+
		  													 " isnull(d.AVG_SPEED,'')as AVERAGE_SPEED,isnull(dateadd(mi,?,a.GMT),'') as LAST_COMMUNICATED , "+
															 " isnull(cts.IDLE_TIME,0)as IDLE_TIME,isnull(cts.DISTANCE,'')as DISTANCE_TRAVELLED," +
															 " isnull(cts.DELAY_TIME,0)as DELAY_TIME,isnull(dateadd(mi,?,cts.SCHEDULED_TRIP_END_TIME),'')as SCHEDULED_ARRIVAL, " +
															 " isnull(f.NAME,'')as FROM_PLACE,isnull(g.NAME,'')as TO_DESTINATION   " +
		  													 " from AMS.dbo.gpsdata_history_latest a "+
		  													 " left outer join AMS.dbo.ROUTE_ALLOCATION c on c.REGISTRATION_NO=a.REGISTRATION_NO and c.SYSTEM_ID=a.System_id and c.STATUS='Active' "+
		  													 " left outer join AMS.dbo.ROUTE_SKELETON d on c.ROUTE_ID=d.ROUTE_ID and a.CLIENTID=d.CUSTOMER_ID and a.System_id=d.SYSTEM_ID  "+
															 " left outer join AMS.dbo.LOCATION_ZONE_A  f on f.HUBID = d.ORIGIN and d.CUSTOMER_ID=f.CLIENTID and d.SYSTEM_ID=f.SYSTEMID "+
															 " left outer join AMS.dbo.LOCATION_ZONE_A g on g.HUBID = d.DESTINATION and d.SYSTEM_ID=g.SYSTEMID and d.CUSTOMER_ID=g.CLIENTID " +
		  													 " left outer join AMS.dbo.CARGO_TRIP_SUMMARY cts on a.REGISTRATION_NO=cts.ASSET_NUMBER and a.CLIENTID=cts.CUSTOMER_ID and a.System_id=cts.SYSTEM_ID and cts.STATUS='Open' " +
		  													 " inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no "+
		  													 " inner join AMS.dbo.tblVehicleMaster e on b.Registration_no=e.VehicleNo and b.System_id=e.System_id "+
		  													 " where a.System_id = ? and a.CLIENTID = ? and b.User_id= ? and a.LOCATION ='No GPS Device Connected'";
	
	public static final String GET_NO_GPS_DETAILS_FOR_CLIENT =  " select isnull(a.REGISTRATION_NO,'')as VEHICLE_NUMBER,isnull(d.TRIP_NAME,'')as ROUTE_NAME,isnull(d.TRIP_CODE,'')as "+
					 											" ROUTE_CODE,isnull(dateadd(mi,?,cts.TRIP_START_TIME) ,'') as TRIP_START_TIME,isnull(a.LOCATION,'')as CURRENT_LOCATION, "+
					 											" isnull(d.AVG_SPEED,'')as AVERAGE_SPEED,isnull(dateadd(mi,?,a.GMT),'') as LAST_COMMUNICATED, "+
																" isnull(cts.IDLE_TIME,0)as IDLE_TIME,isnull(cts.DISTANCE,'')as DISTANCE_TRAVELLED ," +
																" isnull(cts.DELAY_TIME,0)as DELAY_TIME,isnull(dateadd(mi,?,cts.SCHEDULED_TRIP_END_TIME),'')as SCHEDULED_ARRIVAL, " +
															    " isnull(f.NAME,'')as FROM_PLACE,isnull(g.NAME,'')as TO_DESTINATION   " +
					 											" from AMS.dbo.gpsdata_history_latest a "+
					 											" left outer join AMS.dbo.ROUTE_ALLOCATION c on c.REGISTRATION_NO=a.REGISTRATION_NO and c.SYSTEM_ID=a.System_id and c.STATUS='Active' "+
					 											" left outer join AMS.dbo.ROUTE_SKELETON d on c.ROUTE_ID=d.ROUTE_ID and a.CLIENTID=d.CUSTOMER_ID and a.System_id=d.SYSTEM_ID  "+
															    " left outer join AMS.dbo.LOCATION_ZONE_A  f on f.HUBID = d.ORIGIN and d.CUSTOMER_ID=f.CLIENTID and d.SYSTEM_ID=f.SYSTEMID "+
																" left outer join AMS.dbo.LOCATION_ZONE_A g on g.HUBID = d.DESTINATION and d.SYSTEM_ID=g.SYSTEMID and d.CUSTOMER_ID=g.CLIENTID " +
					 											" left outer join AMS.dbo.CARGO_TRIP_SUMMARY cts on a.REGISTRATION_NO=cts.ASSET_NUMBER and a.CLIENTID=cts.CUSTOMER_ID and a.System_id=cts.SYSTEM_ID and cts.STATUS='Open' " +		 										
					 											" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no "+
					 											" inner join AMS.dbo.tblVehicleMaster e on b.Registration_no=e.VehicleNo and b.System_id=e.System_id and  Status='Active' "+
					 											" where a.System_id = ? and a.CLIENTID = ? and b.User_id= ? and a.LOCATION ='No GPS Device Connected'";
	
	public static final String GET_LAST_HUBNAME = "select top 1 isnull(LOCATION,'')as LAST_HUB_NAME from dbo.HUB_REPORT where REGISTRATION_NO=? and SYSTEM_ID=? ORDER BY ACTUAL_ARRIVAL desc ";
	
	
	public static String CHECK_TRIP_OPENED =    " select ASSET_NUMBER,getutcdate() as CUR_DATE,TRIP_START_TIME as START_TIME,CUSTOMER_TRIP_ID,ra.ROUTE_ID,STATUS ,rs.STD_TIME as STANDARD_DURATION,rs.DISTANCE as STANDARD_DISTANCE " +
												" from AMS.dbo.CARGO_TRIP_SUMMARY ra (NOLOCK) " +
												" inner join AMS.dbo.ROUTE_SKELETON rs (NOLOCK) on ra.ROUTE_ID=rs.ROUTE_ID " +
												" where ra.SYSTEM_ID = ? and ra.CUSTOMER_ID = ? and ra.ASSET_NUMBER = ? and " +
												" ra.STATUS = 'Open' and ra.ROUTE_ID = ? " +
												" and TRIP_END_TIME is NULL " ;
	
	 public static final String CLOSE_TRIP_IN_CARGO_SUMMARY= " update AMS.dbo.CARGO_TRIP_SUMMARY set TRIP_END_TIME = ?,IDLE_TIME = ?,STOPPAGE_TIME = ?,RUNNING_TIME = ?,DISTANCE = ?,STATUS = ?,AVG_SPEED=?,UPDATED_TIME=?,DELAY_TIME=? "+ 
															 " where ASSET_NUMBER = ? and TRIP_START_TIME = ? and SYSTEM_ID = ? and CUSTOMER_ID = ? and STATUS = 'Open' "+ 
															 " and ROUTE_ID = ? and CUSTOMER_TRIP_ID = ? and TRIP_END_TIME is null ";
	 
	 public static final String GET_DISTANCE_CONVERSION_FACTOR = "select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = "
			                                                   + "(select DistanceUnitId from tblVehicleMaster where System_id = ? and VehicleNo = ?)";

	 public static final String GET_PRINCIPAL_STORE_DETAILS = "select isnull(CustomerId,0) as principalId,isnull(CustomerName,'') as principalName " +
														" from LMS.dbo.Customer_Information where SystemId=? and ClientId=? and CustomerType=? and STATUS = 'Active' ";

	 public static final String GET_CONSIGNEE_STORE_DETAILS = "select isnull(CustomerId,0) as principalId,isnull(CustomerName,'') as principalName " +
														" from LMS.dbo.Customer_Information where SystemId=? and ClientId=? and CustomerType=? and STATUS = 'Active' ";
	 
	 public static final String CHECK_VEHICLE_ASSIGNED = " select UID from LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT where ASSET_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? ";
	 
	 public static final String SAVE_ASSIGN_VEHICLE_DETAILS= " insert into LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT(ASSET_NO,PRINCIPAL_ID,CONSIGNEE_ID,SYSTEM_ID,CUSTOMER_ID,CREATED_BY,CREATED_DATE) values(?,?,?,?,?,?,getUTCDate())";
		 					 
	 public static final String MODIFY_ASSIGN_VEHICLE_DETAILS=" update LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT set PRINCIPAL_ID=?,CONSIGNEE_ID=?,UPDATED_BY=?,UPDATED_DATE=getutcdate() where UID=? and SYSTEM_ID=? and CUSTOMER_ID=? ";
	 
	 public static final String GET_ASSIGNED_VEHICLE_DETAILS= " select isnull(cva.UID,0) as UID, isnull(cva.ASSET_NO,'') as VEHICLE_NO, isnull(ci1.CustomerName,'') as Principal, isnull(ci.CustomerName,'') as Consignee, "+
															" isnull(u1.Firstname,'') as createdBy,isnull(u2.Firstname,'') as updatedBy,isnull(dateadd(mi,?,cva.CREATED_DATE),'') as createdDate,isnull(dateadd(mi,?,cva.UPDATED_DATE),'') as updatedDate "+
															" from LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT cva " +
															" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=cva.SYSTEM_ID and ci.ClientId=cva.CUSTOMER_ID and ci.CustomerId=cva.CONSIGNEE_ID "+
															" left outer join LMS.dbo.Customer_Information ci1 on ci1.SystemId=cva.SYSTEM_ID and ci1.ClientId=cva.CUSTOMER_ID and ci1.CustomerId=cva.PRINCIPAL_ID "+
															" left outer join AMS.dbo.Users u1 on u1.System_id=cva.SYSTEM_ID and u1.User_id=cva.CREATED_BY "+
															" left outer join AMS.dbo.Users u2 on u2.System_id=cva.SYSTEM_ID and u2.User_id=cva.UPDATED_BY "+
															" where cva.SYSTEM_ID=? and cva.CUSTOMER_ID=? ";


	public static final String GET_EXPENSE_DETAILS = " select isnull(ae.UNIQUE_ID,0) as UID," +
													 " isnull(ae.TRIP_NO,'') as TRIP_NO, "+
													 " isnull(dateadd(mi,?,td.CREATED_TIME),'') as TripDate, "+
													 " isnull(ci1.CustomerName,'') as Principal, "+
													 " isnull(ci.CustomerName,'') as Consignee, "+
													 " isnull(ae.AMOUNT,0) as Amount, "+
													 " isnull(ae.REMARKS,'') as Description, "+
													 " isnull(ae.APPROVED_AMOUNT,0) as Approved_Amount,"+
													 " isnull(cb.DESCRIPTION,'') as Remarks, "+
													 " isnull(cc.TYPE,'') as AccHeader "+
													 " from LMS.dbo.ADDITIONAL_EXPENSES ae "+
													 " left outer join LMS.dbo.TRIP_DETAILS td on td.SYSTEM_ID=ae.SYSTEM_ID and td.CUSTOMER_ID=ae.CUSTOMER_ID and td.TRIP_NO=ae.TRIP_NO "+
													 " left outer join LMS.dbo.CASH_BOOK cb on cb.SYSTEM_ID=ae.SYSTEM_ID and cb.CUSTOMER_ID=ae.CUSTOMER_ID and cb.TRIP_NO=ae.TRIP_NO "+
													 " left outer join LMS.dbo.CCM_LOOKUP cc on cc.SYSTEM_ID=ae.SYSTEM_ID and cc.CUSTOMER_ID=ae.CUSTOMER_ID and cc.ID=cb.ACC_HEADER_ID "+
													 " left outer join LMS.dbo.Customer_Information ci on ci.SystemId=ae.SYSTEM_ID and ci.ClientId=ae.CUSTOMER_ID and ci.CustomerId=td.CONSIGNEE_ID "+
													 " left outer join LMS.dbo.Customer_Information ci1 on ci1.SystemId=ae.SYSTEM_ID and ci1.ClientId=td.CUSTOMER_ID and ci1.CustomerId=td.PRINCIPAL_ID "+ 
													 " where ae.SYSTEM_ID = ? and ae.CUSTOMER_ID = ? and ae.STATUS = ? ";


	public static final String GET_NTC_TRIP_DETAILS = " select isnull(GPS_DATETIME,'') as GPS_DATETIME,TRIPSHEET_NO,isnull(LOCATION,'') as LOCATION,TRIPSHEET_DATE,isnull(CATEGORY,'') as CATEGORY,LOCATION_FROM,LOCATION_TO,START_DATE,ROUTE_CODE,SALES_CHANNEL,STATUS,TRIP_SHEET_TYPE,REMARKS,REF_CODE_NO,COUSTOMER_NAME,MATERIAL_NAME,DIMENSIONS,TRANSIT_DAYS,CREW_CODE,CREW_ANAL_CODE,CREW_NAME,CREW_TYPE,CREW_MOBILE,CREW_DL_NO,CREW_CONSULT_NAME,VEHICLE_NO,VEHICLE_MODE,VEHICLE_MAKE,VEHICLE_MODEL,VEHICLE_INCHARGE,VEHICLE_TYPE,CO_CREW_CODE,CO_CREW_ANAL_CODE,CO_CREW_NAME,CO_CREW_TYPE,CO_CREW_MOBILE,CO_CREW_DL_NO,CO_CREW_CONSULT_NAME,TRAILER_NO,TRAILER_MODE,TRAILER_MAKE,TRAILER_MODEL,TRAILER_INCHARGE,TRAILER_TYPE,SYSTEM_ID,CUSTOMER_ID,TRIP_STATUS,SPEED, "+  
		 											  " isnull( (select top 1 endLocation from AMS.dbo.VehicleSummaryData where RegistrationNo = VEHICLE_NO and DateGMT <= DATEADD(mi,-?,CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),112))) order by  DateGMT desc),'') AS YEST_LOCATION "+
		                                              " from AMS.dbo.ASSET_TRIP_DETAILS a right outer join AMS.dbo.gpsdata_history_latest b on a.VEHICLE_NO=b.REGISTRATION_NO where TRIP_STATUS = 'OPEN' and SYSTEM_ID = ?  and CUSTOMER_ID= ? order by TRIPSHEET_DATE desc ";
		
		
		
 
}