package t4u.statements;

/**
 * 
 * This class is used to write common sql statements
 *
 */
public class CommonStatements {

	/**
	 * To fetch customer id and name from dbo.CUSTOMER_MASTER table
	 */
	public static final String GET_CUSTOMER="select CUSTOMER_ID,NAME,STATUS,ACTIVATION_STATUS from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and STATUS='Active' and ACTIVATION_STATUS='Complete' order by NAME asc";
	/**
	 * To fetch taluk names from dbo.Temporary_Permit_Master table
	 */
	public static final String GET_TALUKNAMES="select distinct isnull(Taluk,'')as NAME from dbo.Temporary_Permit_Master where System_Id=? and Client_Id=?";

	public static final String GET_MDPLIMIT="select isnull(value2,'0')as MDPLIMIT from AMS.dbo.General_Settings where System_Id=? and Client_Id=? and value=?";

	/**
	 * To fetch customer id and name from dbo.CUSTOMER_MASTER table for logged in Customer whose Activation_Status is Incomplete
	 */
	public static final String GET_CUSTOMER_FOR_LOGGED_IN_CUST="select CUSTOMER_ID,NAME,STATUS,ACTIVATION_STATUS from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active' and ACTIVATION_STATUS='Complete' order by NAME asc";

    public static final String GET_ALL_CUSTOMER="select CUSTOMER_ID,NAME,STATUS,ACTIVATION_STATUS from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and STATUS='Active' order by NAME asc";
	
	/**
	 * To fetch All customer id and name from dbo.CUSTOMER_MASTER table for logged in Customer
	 */
	public static final String GET_ALL_CUSTOMER_FOR_LOGGED_IN_CUST="select CUSTOMER_ID,NAME,STATUS,ACTIVATION_STATUS from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active' order by NAME asc ";
	
	/**
	 * To Fetch language specific word from dbo.LANG_LOCALIZATION
	 */
	public static final String GET_LANGUAGE_VARIABLES="select LABEL_ID,LANG_ARABIC,LANG_ENGLISH from dbo.LANG_LOCALIZATION ";
	
	/**
	 * To fetch menus from Menu_Structure table based on feature clicked
	 */
	public static final String GET_MENU_STRUTURE_FOR_FEATURE="select a.REPORT_NAME as PARENT_REPORT_NAME,a.JSP_NAME as PARENT_JSP_NAME, "+
						" isnull(b.ID,0) as CHILD_ID,isnull(b.REPORT_NAME,'') as CHILD_REPORT_NAME,isnull(b.JSP_NAME,'') as CHILD_JSP_NAME,isnull(b.IS_SUB_PARENT,'') as IS_CHILD_PARENT "+
						" from ADMINISTRATOR.dbo.MENU_STRUCTURE a "+
						" left outer join ADMINISTRATOR.dbo.MENU_STRUCTURE b on b.PARENT_ID=a.ID "+
						" where a.PARENT_ID=0 and (a.FEATURE_ID=0 or a.FEATURE_ID=?) ";	
	
	/**
	 * To fetch features from Features tables 
	 */
	public static final String GET_FEATURE_LIST="select FEATURE_NAME,ID,TYPE,RATE_TAG," +
			"(select convert(varchar(max),(select (select SUB_FEATURE_NAME from dbo.SUB_FEATURES "+
			" where dbo.SUB_FEATURES.SUB_FEATURE_ID=main.SUB_FEATURE_ID) as u,(select MENU_NAME as li from dbo.MENU_MASTER a "+ 
			" where a.FEATURE_ID=main.FEATURE_ID and isnull(a.SUB_FEATURE_ID,0)=main.SUB_FEATURE_ID "+
			" for xml path(''),type) from (select distinct FEATURE_ID,isnull(SUB_FEATURE_ID,0) as SUB_FEATURE_ID from dbo.MENU_MASTER where dbo.MENU_MASTER.FEATURE_ID=a.ID) main "+
			" FOR XML PATH ('')))) as MENUSTR "+
			" from dbo.FEATURES a where a.ID in "+
			" (select distinct(FEATURE_ID) from dbo.MENU_MASTER a "+
			" inner join AMS.dbo.menu_item_master b on a.MENU_NAME=b.menu_item_name collate database_default "+
			" where b.system_id=?) "+
			" order by ORDER_OF_TYPE asc ";
	
	/**
	 * To fetch features selected by Customer in Cust_feature ass table 
	 */
	public static final String GET_FEATURE_LIST_FOR_CUSTOMER="select FEATURE_LIST from dbo.CUSTOMER_FEATURE_ASSOC where CUSTOMER_ID=?";
	
	/**
	 * To fetch features from Features tables for group to select
	 */
	public static final String GET_FEATURE_LIST_FOR_GROUP="select FEATURE_NAME,ID,TYPE,RATE_TAG, " +
			"(select convert(varchar(max),(select (select SUB_FEATURE_NAME from dbo.SUB_FEATURES "+
			" where dbo.SUB_FEATURES.SUB_FEATURE_ID=main.SUB_FEATURE_ID) as u,(select MENU_NAME as li from dbo.MENU_MASTER a "+ 
			" where a.FEATURE_ID=main.FEATURE_ID and isnull(a.SUB_FEATURE_ID,0)=main.SUB_FEATURE_ID "+
			" for xml path(''),type) from (select distinct FEATURE_ID,isnull(SUB_FEATURE_ID,0) as SUB_FEATURE_ID from dbo.MENU_MASTER where dbo.MENU_MASTER.FEATURE_ID=a.ID) main "+
			" FOR XML PATH ('')))) as MENUSTR "+
			" from dbo.FEATURES a where ID in (#) order by ORDER_OF_TYPE asc ";
	
	public static final String GET_CLIENT_NAME = "select NAME from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String GET_GROUP_NAME_FOR_CLIENT = "select GROUP_ID,GROUP_NAME from VEHICLE_GROUP where CLIENT_ID=? and SYSTEM_ID=? order by GROUP_NAME";

	public static final String GET_REGISTRATION_NO = "select REGISTRATION_NUMBER,GROUP_ID from dbo.VEHICLE_CLIENT where CLIENT_ID=? and SYSTEM_ID=?";

	public static final String GET_REGISTRATION_NO_BASED_ON_USER = "select REGISTRATION_NUMBER from VEHICLE_CLIENT vc, Vehicle_User vu where vc.CLIENT_ID=? "
			+ " and vc.SYSTEM_ID=? and vu.User_id=? and vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no order by REGISTRATION_NUMBER";

	public static final String GET_REGISTRATION_NO_BASED_ON_USER_FOR_MARINE = "select vc.REGISTRATION_NUMBER,VehicleType from VEHICLE_CLIENT vc "+
																			"inner join tblVehicleMaster vm on vm.VehicleNo=vc.REGISTRATION_NUMBER "+
																			"inner join AMS.dbo.Vehicle_User vu on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no "+
																			"where vc.CLIENT_ID=? "+
																			"and vc.SYSTEM_ID=? and vu.User_id=?  and UPPER(VehicleType)  like '%BARGE%' "+
																			"order by vc.REGISTRATION_NUMBER";

	
	public static final String GET_DRIVER_NAME = "select Driver_id,Fullname as DriverName from Driver_Master where System_id = ? and Client_id = ? and Fullname is not null and Fullname<>''";
	
	public static final String GET_LIVE_DATA=" select REGISTRATION_NO,UNIT_NO,LONGITUDE,LATITUDE,SPEED,GPS_DATETIME,ODOMETER,IGNITION," +
	" LOCATION,System_id,GMT,FUEL_LEVEL_PERCENTAGE,CLIENTID,OFFSET,DRIVER_NAME,CATEGORY,DURATION,DELTADISTANCE,ANALOG_INPUT_2," +
	"isnull(IO3,0) as IO3,isnull(IO4,0) as IO4,isnull(IO5,0) as IO5,isnull(IO6,0) as IO6,isnull(DRIVER_ASSOC_ID,0) as DRIVER_ASSOC_ID from dbo.gpsdata_history_latest where REGISTRATION_NO=? ";
	
	public static final String GET_ALL_GROUP="select GROUP_ID,GROUP_NAME,ACTIVATION_STATUS from dbo.ASSET_GROUP where CUSTOMER_ID=? and SYSTEM_ID=? order by GROUP_NAME asc";
	
	public static final String GET_GROUP="select GROUP_ID,GROUP_NAME,ACTIVATION_STATUS from dbo.ASSET_GROUP where CUSTOMER_ID=? and SYSTEM_ID=? and ACTIVATION_STATUS='Complete' order by GROUP_NAME asc";

	public static final String GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPE = "select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = (select DistanceUnitId from Vehicle_Category_Master where Category_name = ("
		+ "select VehicleType from tblVehicleMaster where System_id=? and VehicleNo=?))";
	
	public static final String GET_BATTERY_VOLTAGE = "select isnull(gps.MAIN_BATTERY_VOLTAGE,0) as MAIN_BATTERY_VOLTAGE, tbVM.BatteryVoltage FROM gpsdata_history_latest gps INNER JOIN tblVehicleMaster tbVM ON gps.REGISTRATION_NO=tbVM.VehicleNo where gps.System_id=? and gps.CLIENTID=? and LOCATION != 'No GPS Device Connected' and tbVM.BatteryVoltage is not null;";
	
	public static final String GET_SYSTEM_HEALTH_DETAILS = "select isnull(gps.REGISTRATION_NO,0) as ASSET_NO,isnull(gps.LOCATION,0) as LOCATION,isnull(gps.MAIN_BATTERY_VOLTAGE,0) as MAIN_BATTERY_VOLTAGE,isnull(gps.GPS_DATETIME,'')as ALERT_DATE,isnull(tbVM.BatteryVoltage,'') as BATTERY_VOLTAGE" +
			",isnull(p.ModelName,'') as ASSET_MODEL,isnull(gps.CATEGORY,'') as CATEGORY,gps.CATEGORY+'@'+cast(gps.DURATION as varchar) as StopIdle " +
			" FROM gpsdata_history_latest gps INNER JOIN tblVehicleMaster tbVM ON gps.REGISTRATION_NO=tbVM.VehicleNo  " +
			" left outer join FMS.dbo.Vehicle_Model p on gps.CLIENTID=p.ClientId and tbVM.System_id=p.SystemId and p.ModelTypeId=tbVM.Model where gps.System_id=? and gps.CLIENTID=? and LOCATION != 'No GPS Device Connected' and tbVM.BatteryVoltage is not null";
	
	
	/**
	 * To fetch Service Type  from dbo.WEBSERVICE_DATA_TRACK table
	 */
	public static final String GET_SERVICE_TYPE="select ID,DATA from dbo.CARGO_LOOKUP_DETAILS where SYSTEM_ID=? and TYPE='SERVICE TYPE'";
	
	/**
	 * To fetch Service Type for logged in Customer  from dbo.WEBSERVICE_DATA_TRACK table
	 */
	public static final String GET_SERVICE_TYPE_FOR_LOGGED_IN_CUST="select DATA from dbo.CARGO_LOOKUP_DETAILS where SYSTEM_ID=? and  TYPE=? ";
	
	public static final String GET_CURRENCY="select isnull(CURRENCY_SYMBOL , '') as CURRENCY_SYMBOL from ADMINISTRATOR.dbo.COUNTRY_DETAILS ,AMS.dbo.System_Master  where CountryCode= COUNTRY_CODE and System_id=? ";
	
	public static final String GET_LOC_LAT_LONG="SELECT TOP 1 LONGITUDE,LATITUDE,LOCATION,GPS_DATETIME FROM dbo.gpsdata_history_latest WHERE REGISTRATION_NO=? and LOCATION <>'No GPS Device Connected' ";
	
	public static final String GET_STATE_LIST_FROM_ADMINSTRATOR="select isnull(STATE_CODE,'') as StateID,isnull(STATE_NAME,'') as StateName from ADMINISTRATOR.dbo.STATE_DETAILS where COUNTRY_CODE=? order by StateName ";
	
	public static final String GET_USER_AUTHORITY="select isnull(USERAUTHORITY,'User') as USERAUTHORITY from ADMINISTRATOR.dbo.USERS where  SYSTEM_ID=? and USER_ID=?";
	
	public static final String GET_VEHICLE_LIST_FOR_LTSP="select a.REGISTRATION_NO from gpsdata_history_latest a "
														+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
														+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
														+ "where a.CLIENTID = ? and a.System_id = ? and b.User_id=?";
	
	public static final String GET_VEHICLE_LIST_FOR_CUSTOMER="select a.REGISTRATION_NO  from gpsdata_history_latest a "
															+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
															+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
															+ "where a.CLIENTID = ? and a.System_id = ? and b.User_id=?";

	public static final String GET_VEHICLE_DETAILS= " select a.REGISTRATION_NO,a.GPS_DATETIME,a.LOCATION,isnull (a.DRIVER_NAME, '')as DRIVER_NAME ,isnull(a.DRIVER_MOBILE,'') as DRIVER_MOBILE,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull(str(c.LoadingCapacity,7,2),'NA')as Loading_Capacity "+
													" from dbo.gpsdata_history_latest a  "+
													" inner join dbo.Live_Vision_Support b on b.REGISTRATION_NO=a.REGISTRATION_NO "+
													" inner join dbo.tblVehicleMaster c on c.VehicleNo=a.REGISTRATION_NO "+
													" where a.System_id=? and CLIENTID=? and a.REGISTRATION_NO=?";
	
	public static final String GET_LIVEVISION_DETAILS = " select isnull(REGISTRATION_NO,'')as REGISTRATION_NO ,isnull(UNIT_NO,'')as UNIT_NO,isnull(LONGITUDE,'')as LONGITUDE,isnull(LATITUDE,'')as LATITUDE, " +
												        " isnull(SPEED,0)as SPEED,isnull(GPS_DATETIME,'')as GPS_DATETIME,isnull(IGNITION,'')as IGNITION,isnull(LOCATION,'')as LOCATION ,isnull(CATEGORY,'')as CATEGORY " +
												        " from AMS.dbo.gpsdata_history_latest where REGISTRATION_NO=? " ;
	
	public static final String GET_COUNTRY_LIST = "select COUNTRY_CODE,COUNTRY_NAME from dbo.COUNTRY_DETAILS";
	
	public static final String GET_COUNTRY_NAME_BASED_ON_ID = "select COUNTRY_NAME from dbo.COUNTRY_DETAILS where COUNTRY_CODE=? ";
	
    public static final String GET_USERS="select SYSTEM_ID,CUSTOMER_ID from ADMINISTRATOR.dbo.Users where USER_NAME=? and PASSWORD=? ";
	
	public static final String GET_VEHICLE="select * from AMS.dbo.VEHICLE_CLIENT where SYSTEM_ID=? and REGISTRATION_NUMBER in (#) ";
	
 	public static final String GET_HUB_ID=" select ag.GROUP_NAME as HubName,b.GROUP_ID as HUBID,b.USER_ID,ag.CUSTOMER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b "
		+ " inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.GROUP_ID=b.GROUP_ID and ag.SYSTEM_ID=b.SYSTEM_ID "
		+ " where b.SYSTEM_ID=? and b.USER_ID=? ";
 	
 	public static final String GET_ZONE_CATEGORY_TYPE = "select Zone,CategoryTypeForBill from System_Master where System_id=?";

 	
 	public static final String GET_LAT_LONGS =  " select isnull(g.LOCATION,'') as LOCATION,isnull(g.LATITUDE,0) as VEHICLE_LATITUDE,isnull(g.LONGITUDE,0) as VEHICLE_LONGITUDE, " +
											 	" isnull(NAME,'') as HUB_NAME,isnull(lz.LONGITUDE,0) as HUB_LONGITUDE,isnull(lz.LATITUDE,0) as HUB_LATITUDE,RADIUS " +
											 	" from AMS.dbo.VEHICLE_CLIENT lvs " +
											 	" inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.SYSTEM_ID=lvs.SYSTEM_ID and ag.CUSTOMER_ID=lvs.CLIENT_ID and ag.GROUP_ID=lvs.GROUP_ID " +
											 	" inner join AMS.dbo.LOCATION_ZONE_A lz on lz.SYSTEMID=ag.SYSTEM_ID and lz.HUBID=ag.HUB_ID " +
											 	" left outer  join AMS.dbo.gpsdata_history_latest g on lvs.REGISTRATION_NUMBER=g.REGISTRATION_NO " +
											 	" where lvs.SYSTEM_ID=? and lvs.CLIENT_ID=? and lvs.REGISTRATION_NUMBER=? " ;

 	public static final String GET_LTSPS ="select System_Name,System_id,Category from AMS.dbo.System_Master order by System_Name";

	public static final String GET_CLIENT_NAMES_TWHADR  = "select CUSTOMER_ID as CustomerId,NAME as CustomerName from ADMINISTRATOR.dbo.CUSTOMER_MASTER where SYSTEM_ID=? and ACTIVATION_STATUS='Complete' ";

	public static final String GET_GROUP_NAME_FOR_CLIENT_TWHADR = "select a.GROUP_ID, a.GROUP_NAME from ADMINISTRATOR.dbo.ASSET_GROUP a inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on b.SYSTEM_ID=a.SYSTEM_ID " +
	" and a.GROUP_ID=b.GROUP_ID where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and b.USER_ID=?";
	
	public static final String TRIPWISE_HUB_ARRIVAL_DEPARTURE_DETAILS = 
	" select ghl.ODOMETER,vm.Odometer as ODOMETER_TVM,CONVERT(VARCHAR(10),dateadd(mi,?,ACTUAL_ARRIVAL),111) as KEY_DATE,hr.REGISTRATION_NO as[REGISTRATION NO],isnull(vm.VehicleAlias,'') as VehicleId,isnull(vm.VehicleType,'') as Vehicle_Type,hr.LOCATION,dateadd(mi,?,ACTUAL_ARRIVAL) "+
	" as [ACTUAL ARRIVAL],ACTUAL_ARRIVAL as ARRIVALGMT,ARRIVAL_TEMPERATURE as ARRIVAL_TEMPERATURE,dateadd(mi,?,ACTUAL_DEPARTURE) as [ACTUAL DEPARTURE],DEPARTURE_TEMPERATURE as DEPARTURE_TEMPERATURE,DATEDIFF(mi,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE) "+
	" as [DURATION], case when ACTUAL_DEPARTURE is null then  DATEDIFF(mi,ACTUAL_ARRIVAL,getUTCdate()) else 0 end as [DETENTION],isNull(dm.Fullname,'') as DRIVER, "+
	" isnull(stdtime.scht,'NA') as [STANDARD],isnull(stdtime.diffhh,'NA') [DEVIATION],hr.STANDARD_DURATION as [STANDARD_DURATION],isnull(vm.OwnerName,'')as OwnerName,isnull(vn.ModelName,'NA') as MODEL_NAME , lb.NAME as HUB_NAME "+
	" from HUB_REPORT hr (nolock) "+
	" outer apply dbo.GetStandardandDeviationTime(HUB_ID,CONVERT(numeric,SUBSTRING(CONVERT(VARCHAR(8),dateadd(mi,?,ACTUAL_ARRIVAL),108),1,2)),CONVERT(numeric,SUBSTRING(CONVERT(VARCHAR(8),dateadd(mi,?,ACTUAL_ARRIVAL),108),4,2))) stdtime "+
	" left outer join dbo.tblVehicleMaster vm on hr.REGISTRATION_NO=vm.VehicleNo "+
	" left outer join dbo.gpsdata_history_latest ghl on hr.REGISTRATION_NO = ghl.REGISTRATION_NO and hr.SYSTEM_ID = ghl.System_id "+
	" left outer join dbo.Driver_Master dm on dm.Driver_id=hr.DRIVER_ID and dm.System_id=hr.SYSTEM_ID "+
	" left outer join dbo.VEHICLE_CLIENT vc on vc.SYSTEM_ID=hr.SYSTEM_ID  and vm.VehicleNo=vc.REGISTRATION_NUMBER  "+
	" left outer join FMS.dbo.Vehicle_Model vn on vn.SystemId=hr.SYSTEM_ID and vn.ClientId=vc.CLIENT_ID and vn.ModelTypeId=vm.Model "+
	" inner join AMS.dbo.LOCATION_ZONE_# lb on lb.SYSTEMID = hr.SYSTEM_ID and lb.HUBID = hr.HUB_ID "+
	" where (ACTUAL_ARRIVAL between ? and ? ) and hr.REGISTRATION_NO in (?)and hr.SYSTEM_ID=? "+
	" group by ghl.ODOMETER,vm.Odometer,vn.ModelName,hr.REGISTRATION_NO,hr.LOCATION,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,ARRIVAL_TEMPERATURE,DEPARTURE_TEMPERATURE,stdtime.scht,stdtime.diffhh,hr.STANDARD_DURATION,vm.OwnerName,vm.VehicleType,vm.VehicleAlias,dm.Fullname,lb.NAME "+
	" union "+
	" select ghl.ODOMETER, vm.Odometer as ODOMETER_TVM,CONVERT(VARCHAR(10),dateadd(mi,?,ACTUAL_ARRIVAL),111) as KEY_DATE , hrh.REGISTRATION_NO as[REGISTRATION NO],isnull(vm.VehicleAlias,'') as VehicleId,isnull(vm.VehicleType,'') as Vehicle_Type,hrh.LOCATION,dateadd(mi,?,ACTUAL_ARRIVAL) "+
	" as [ACTUAL ARRIVAL],ACTUAL_ARRIVAL as ARRIVALGMT,ARRIVAL_TEMPERATURE as ARRIVAL_TEMPERATURE,dateadd(mi,?,ACTUAL_DEPARTURE) as [ACTUAL DEPARTURE],DEPARTURE_TEMPERATURE as DEPARTURE_TEMPERATURE,DATEDIFF(mi,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE)"+
	" as [DURATION], case when ACTUAL_DEPARTURE is null then  DATEDIFF(mi,ACTUAL_ARRIVAL,getUTCdate()) else 0 end as [DETENTION],isNull(dm.Fullname,'') as DRIVER, "+
	" isnull(stdtime.scht,'NA') as [STANDARD],isnull(stdtime.diffhh,'NA') [DEVIATION],hrh.STANDARD_DURATION as [STANDARD_DURATION],isnull(vm.OwnerName,'')as OwnerName,isnull(vn.ModelName,'NA') as MODEL_NAME , lb.NAME as HUB_NAME "+
	" from HUB_REPORT_HISTORY hrh (nolock) "+
	" outer apply dbo.GetStandardandDeviationTime(HUB_ID,CONVERT(numeric,SUBSTRING(CONVERT(VARCHAR(8),dateadd(mi,?,ACTUAL_ARRIVAL),108),1,2)),CONVERT(numeric,SUBSTRING(CONVERT(VARCHAR(8),dateadd(mi,?,ACTUAL_ARRIVAL),108),4,2))) stdtime "+
	" left outer join dbo.tblVehicleMaster vm on hrh.REGISTRATION_NO=vm.VehicleNo "+
	" left outer join dbo.gpsdata_history_latest ghl on hrh.REGISTRATION_NO = ghl.REGISTRATION_NO and hrh.SYSTEM_ID = ghl.System_id "+
	" left outer join dbo.Driver_Master dm on dm.Driver_id=hrh.DRIVER_ID and dm.System_id=hrh.SYSTEM_ID "+
	" left outer join dbo.VEHICLE_CLIENT vc on vc.SYSTEM_ID=hrh.SYSTEM_ID  and vm.VehicleNo=vc.REGISTRATION_NUMBER  "+
	" left outer join FMS.dbo.Vehicle_Model vn on vn.SystemId=hrh.SYSTEM_ID and vn.ClientId=vc.CLIENT_ID and vn.ModelTypeId=vm.Model "+
	" inner join AMS.dbo.LOCATION_ZONE_# lb on lb.SYSTEMID = hrh.SYSTEM_ID and lb.HUBID = hrh.HUB_ID "+
	" where (ACTUAL_ARRIVAL between ? and ? )and hrh.REGISTRATION_NO in (?)and hrh.SYSTEM_ID=? "+
	" group by ghl.ODOMETER,vm.Odometer,vn.ModelName,hrh.REGISTRATION_NO,hrh.LOCATION,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE,ARRIVAL_TEMPERATURE,DEPARTURE_TEMPERATURE,stdtime.scht,stdtime.diffhh,hrh.STANDARD_DURATION,vm.OwnerName,vm.VehicleType,vm.VehicleAlias,dm.Fullname,lb.NAME "+
	" order by [REGISTRATION NO],[ACTUAL ARRIVAL] asc ";
	
	public static final String CHECK_SYSTEM_MASTER_FOR_PRECISE_SETTING = " select isnull(Imprecise_Location_Setting,0) as Location_Setting from  AMS.dbo.System_Master where System_id = ? ";
	
	public static final String CHECK_USERS_FOR_PRECISE_SETTING = " select isnull(Imprecise_Location_Setting,0) as Location_Setting from AMS.dbo.Users where System_id = ? and  User_id = ?  ";
	
	public static final String GET_COORDINATES_BASED_ON_SYSTEM_ID = "select isnull(Latitude,0) as Latitude,isnull(Longitude,0) as Longitude from AMS.dbo.System_Master where System_id =? ";
	
	public static final String GET_USER_ASSOCIATED_CUSTOMER = "select isnull(q1.NAME,'') as CUSTOMER_NAME, isnull(q1.CUSTOMER_ID,0) as CUSTOMER_ID  from dbo.TRIP_CUSTOMER_DETAILS as q1 inner join dbo.USER_TRIP_CUST_ASSOC as q2 on q2.TRIP_CUSTOMER_ID = q1.ID where q2.USER_ID = ? and q2.SYSTEM_ID =?";

	public static final String CHECK_VEHICLE_STATUS = "select Vehicle_id from AMS.dbo.Vehicle_Status where Vehicle_id=?";

	public static final String MOVE_TO_HISTORY = "insert into AMS.dbo.Vehicle_Status_History (Status_id,Vehicle_id,Date_Time,Trip_id,Hub_id,HubName)" +
	" select Status_id,Vehicle_id,Date_Time,Trip_id,Hub_id,HubName from AMS.dbo.Vehicle_Status where Vehicle_id=?";

	public static final String UPDATE_VEHICLE_STATUS = "update AMS.dbo.Vehicle_Status set Status_id=?,Date_Time=getutcdate(),Trip_id=? where Vehicle_id=?";

	public static final String INSERT_INTO_VEHICLE_STATUS = "insert into AMS.dbo.Vehicle_Status (Status_id,Vehicle_id,Date_Time,Trip_id) values (?,?,getutcdate(),?)";
	
	public static final String GET_DOOR_SENSOR_ACTIVITY_REPORT = " select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,IO_VALUE,IO_ID,IO_CATEGORY from  AMS.dbo.RS232_LIVE " +
	" where REGISTRATION_NO=?  " +
	" and GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) "+
	" union all "+
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,IO_VALUE,IO_ID,IO_CATEGORY from  AMS.dbo.RS232_HISTORY " +
	" where REGISTRATION_NO=?  " +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?)   order by GMT ";
	
	public static final String GET_USER_ASSOCIATED_CUSTOMER_ID = "select isnull(q1.NAME,'') as CUSTOMER_NAME, isnull(q1.ID,'') as ID  from dbo.TRIP_CUSTOMER_DETAILS as q1 inner join dbo.USER_TRIP_CUST_ASSOC as q2 on q2.TRIP_CUSTOMER_ID = q1.ID where q2.USER_ID = ? and q2.SYSTEM_ID =?";
	
	public static final String GET_LIST_VIEW_COLUMN_SETTING = "select ID,COLUMN_NAME,VISIBILITY from LIST_VIEW_COLUMN_SETTING where SYSTEM_ID=? and CUSTOMER_ID=? and USER_ID=? and PAGE_NAME=?";
	
	public static final String GET_COLUMN_SETTING = "select ID,COLUMN_NAME,VISIBILITY,TRIPCUSTOMER_ID from LIST_VIEW_COLUMN_SETTING where SYSTEM_ID=? and CUSTOMER_ID=? and TRIPCUSTOMER_ID in (#) and USER_ID=? and PAGE_NAME=? order by DISPLAY_ORDER asc";

	public static final String UPDATE_LIST_VIEW_COLUMN_SETTING = "update LIST_VIEW_COLUMN_SETTING set VISIBILITY=? where ID=? and SYSTEM_ID=? and CUSTOMER_ID=? and USER_ID=?";
	
	public static final String DELETE_COLUMN_SETTING = "delete LIST_VIEW_COLUMN_SETTING where ID=? and SYSTEM_ID=? and CUSTOMER_ID=? and USER_ID=? and PAGE_NAME=?";


	public static final String UPDATE_COLUMN_SETTING = "update LIST_VIEW_COLUMN_SETTING set VISIBILITY=? where ID=? and SYSTEM_ID=? and TRIPCUSTOMER_ID=? and USER_ID=? and PAGE_NAME=? and CUSTOMER_ID=?";

	public static final String INSERT_LIST_VIEW_COLUMN_SETTING = "INSERT INTO LIST_VIEW_COLUMN_SETTING (PAGE_NAME,COLUMN_NAME,VISIBILITY,SYSTEM_ID,TRIPCUSTOMER_ID,USER_ID,DISPLAY_ORDER,CUSTOMER_ID)  " +
																  " VALUES(?,?,?,?,?,?,?,?)";
	
	public static final String GET_CUSTOMER_MASTER_DETAILS_BY_CUSTOMER_ID = "SELECT ISNULL(ROLE_BASED_MENU,'NO') as ROLE_BASED_MENU FROM ADMINISTRATOR.dbo.CUSTOMER_MASTER WHERE CUSTOMER_ID = ?";
	
	public static final String GET_SYSTEM_MASTER_DETAILS_BY_SYSTEM_ID = "SELECT ISNULL(ROLE_BASED_MENU,'NO') as ROLE_BASED_MENU FROM AMS.dbo.System_Master WHERE System_id = ?";
		
	public static final String GET_ROLE_ID_DETAILS_BY_USER_ID = "SELECT  isnull(ROLE_ID,0) as ROLE_ID FROM ADMINISTRATOR.dbo.USERS WHERE SYSTEM_ID=? and USER_ID = ?";

	public static final String GET_TRIP_CUSTOMER_DETAILS_BY_ID = " SELECT * FROM TRIP_CUSTOMER_DETAILS WHERE ID = ? ";
	
	public static final String GET_CITY_NAMES = " select CITY_NAME,LATITUDE,LONGITUDE,isnull(CITY_TYPE,'') as CITY_TYPE,ICON_NAME,ICON_LINK,UTC_TIME,VISIBILITY,TEMPERATURE,DESCRIPTION,SEVERE_WEATHER_DESCRIPTION " +
			" from CITY_DETAILS ";
	
	public static final String GET_ACTIVE_USERS = " select count(*) as count, 'web' as type from Login_History where logout_time is null and login_time >  CONVERT(date, getutcdate() + ' 00:00:00') and system_id= ? " +
	" union all " +
	" select count(distinct USER_ID) as count, 'mobile' as type from EMVISION_LOGIN_HISTORY where SYSTEM_ID=? and LOGOUT_TIME is null and LOGIN_TIME > '2020-02-01' " ;
	
	public static final String GET_STOCKYARDS = "SELECT Port_No,Port_Name,Port_Village,Port_Taluk,Port_Survey_Number,System_Id,Client_Id,UniqueId,isnull(ASSESSED_QUANTITY,0) as ASSESSED_QUANTITY " +
	" ,l.LATITUDE,l.LONGITUDE  FROM Sand_Port_Details s " +
	"inner join AMS.dbo.LOCATION_ZONE_A l on l.HUBID=s.Port_Hub and l.SYSTEMID=s.System_Id and s.Client_Id=l.CLIENTID WHERE System_Id=? and Client_Id=? " +
	"order by Port_Name";
	
	public static final String GET_LIVEVISION_SETTINGS = " SELECT * from AMS.dbo.LIVEVISION_SETTINGS where SYSTEM_ID=? ";
	
	public static final String GET_API_DETAILS = "SELECT * FROM API_CONFIGURATION_DETAILS where API_TYPE=?";
}
