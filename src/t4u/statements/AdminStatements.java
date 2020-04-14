package t4u.statements;

/**
 * 
 * This class is used to write admin module sql statements
 *
 */
public class AdminStatements {
	
	/*****Query statement for CustomerMaster page*****************/
	
	/**
	 * getting same customer name from CUSTOMER_MASTER table
	 */
	
	public static final String GET_CUST_WITH_SAME_NAME="select CUSTOMER_ID from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and upper(NAME)=? ";
	/**
	 * deleting customer for SystemId and Customer Id
	 */
	
	public static final String DELETE_CUSTOMER_STORED_PROCEDURE="{call [deleteCustomerDetails](?,?)}";
	
	public static final String CUSTOMER_MOVING_TO_HISTORY="insert into dbo.CUSTOMER_MASTER_HISTORY(CUSTOMER_ID, NAME, ADDRESS, PHONE_NO, MOBILE_NO, EMAIL, CITY, ZIP_CODE, "+ 
			" COUNTRY_CODE, STATE_CODE, WEBSITE, FAX, STATUS, ACTIVATION_STATUS, TOTAL_USERS, CREATED_BY, CREATED_TIME, OS_LIMIT_BLACKTOP, "+ 
			" OS_LIMIT_GRADED, IDLETIME_ALERT, STOPPAGE_TIME_ALERT, SYSTEM_ID, VEHICLE_IMAGE, RESTRICTIVE_MOMENT_START, "+
			" RESTRICTIVE_MOMENT_END, RESTRICTIVE_MOMENT_DISTANCE, RESTRICTIVE_NON_MOMENT_START, RESTRICTIVE_NON_MOMENT_END, "+ 
			" RESTRICTIVE_NON_MOMENT_DISTANCE, STD_DISTANCE_IDLE_STOPPAGE, STD_SPEED_IDLE_STOPPAGE, LIVE_POSITION_ALERT, AC_IDLE_TIME_ALERT, "+
			" NON_COMMUNICATING_ALERT, NEARTO_BOARDER_DISTANCE, TRIP_CHART_ID, CLIENT_EXD_LINK, CLIENT_EXD_CODE, DRIVERNONCOMPLIANCE, "+ 
			" SEAT_BELT_INTERVAL, MIN_TEMPERATURE, MAX_TEMPERATURE, LIVE_POSITION_EXEC_DATE, SEAT_BELT_DISTANCE, PAYMENT_DUE_DATE, "+ 
			" PAYMENT_NOTIFICATION_PERIOD, DELETED_BY,DOOR_ALERT_INTERVAL,DOOR_ALERT_INSIDE_HUB) "+
			" select CUSTOMER_ID, NAME, ADDRESS, PHONE_NO, MOBILE_NO, EMAIL, CITY, ZIP_CODE, COUNTRY_CODE, "+ 
			" STATE_CODE, WEBSITE, FAX, STATUS, ACTIVATION_STATUS, TOTAL_USERS, CREATED_BY, CREATED_TIME, OS_LIMIT_BLACKTOP, "+
			" OS_LIMIT_GRADED, IDLETIME_ALERT, STOPPAGE_TIME_ALERT, SYSTEM_ID, VEHICLE_IMAGE, RESTRICTIVE_MOMENT_START, "+ 
			" RESTRICTIVE_MOMENT_END, RESTRICTIVE_MOMENT_DISTANCE, RESTRICTIVE_NON_MOMENT_START, RESTRICTIVE_NON_MOMENT_END, "+
			" RESTRICTIVE_NON_MOMENT_DISTANCE, STD_DISTANCE_IDLE_STOPPAGE, STD_SPEED_IDLE_STOPPAGE, LIVE_POSITION_ALERT, "+
			" AC_IDLE_TIME_ALERT, NON_COMMUNICATING_ALERT, NEARTO_BOARDER_DISTANCE, TRIP_CHART_ID, CLIENT_EXD_LINK, CLIENT_EXD_CODE, "+ 
			" DRIVERNONCOMPLIANCE, SEAT_BELT_INTERVAL, MIN_TEMPERATURE, MAX_TEMPERATURE, LIVE_POSITION_EXEC_DATE, SEAT_BELT_DISTANCE, "+ 
			" PAYMENT_DUE_DATE, PAYMENT_NOTIFICATION_PERIOD,?,DOOR_ALERT_INTERVAL,DOOR_ALERT_INSIDE_HUB from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? ";
	/**
	 * getting customer details for LTSP
	 */
	public static final String GetCustomerDetailForLTSP="select a.CUSTOMER_ID,a.NAME,a.ADDRESS,a.COUNTRY_CODE,a.STATE_CODE,a.CITY,a.ZIP_CODE,a.PHONE_NO,a.MOBILE_NO,a.FAX,EMAIL,a.WEBSITE,a.STATUS,a.COUNTRY_CODE,a.STATE_CODE,isnull(b.COUNTRY_NAME,'') as COUNTRY_NAME,isnull(c.STATE_NAME,'') as STATE_NAME,a.ACTIVATION_STATUS,PAYMENT_DUE_DATE,PAYMENT_NOTIFICATION_PERIOD,isnull(STD_SPEED_IDLE_STOPPAGE,0) as SPEED_LIMIT,isnull(SNOOZE_TIME,'') as SNOOZE_TIME,a.PAYMENT_DUE_NOTIFICATION "+
	" from dbo.CUSTOMER_MASTER a "+
	" left outer join  dbo.COUNTRY_DETAILS b on a.COUNTRY_CODE=b.COUNTRY_CODE "+ 
	" left outer  join dbo.STATE_DETAILS c on a.STATE_CODE=c.STATE_CODE "+
	" where a.SYSTEM_ID=?";
	
	
	public static final String GetCustomerDetailForLoggedClientLTSP="select a.CUSTOMER_ID,a.NAME,a.ADDRESS,a.COUNTRY_CODE,a.STATE_CODE,a.CITY,a.ZIP_CODE,a.PHONE_NO,a.MOBILE_NO,a.FAX,EMAIL,a.WEBSITE,a.STATUS,a.COUNTRY_CODE,a.STATE_CODE,isnull(b.COUNTRY_NAME,'') as COUNTRY_NAME,isnull(c.STATE_NAME,'') as STATE_NAME,a.ACTIVATION_STATUS,PAYMENT_DUE_DATE,PAYMENT_NOTIFICATION_PERIOD,isnull(STD_SPEED_IDLE_STOPPAGE,0) as SPEED_LIMIT,isnull(SNOOZE_TIME,'') as SNOOZE_TIME,a.PAYMENT_DUE_NOTIFICATION "+
	" from dbo.CUSTOMER_MASTER a "+
	" left outer join  dbo.COUNTRY_DETAILS b on a.COUNTRY_CODE=b.COUNTRY_CODE "+ 
	" left outer  join dbo.STATE_DETAILS c on a.STATE_CODE=c.STATE_CODE "+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=?";
	/**
	 * getting country name list from country details table
	 */
	public static final String Get_COUNTRY_LIST = "select COUNTRY_CODE,COUNTRY_NAME,isNull(OFFSET,'') as OFFSET from dbo.COUNTRY_DETAILS";
	/**
	 * getting state list from state details table
	 */
	public static final String Get_STATE_LIST = "select STATE_CODE,STATE_NAME,isnull(REGION,'') as REGION from dbo.STATE_DETAILS where COUNTRY_CODE=? order by STATE_NAME asc";
	
	public static final String GET_VEHICLE_LIST=" select REGISTRATION_NUMBER from AMS.dbo.tblVehicleMaster tb left outer join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id left outer join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? order by REGISTRATION_NUMBER ";
	
	public static final String GET_VEHICLE_DETAILS = "select isnull(a.GROUP_ID,0) as GROUP_ID, isnull(b.SLNO,0) as FCIS from dbo.VEHICLE_CLIENT a "
                                                     + "left outer join dbo.FUEL_FORMULA_VALUE b on a.REGISTRATION_NUMBER=b.VehicleNo "
                                                     + "where a.REGISTRATION_NUMBER=? and a.SYSTEM_ID=? and a.CLIENT_ID=? ";
	
	public static final String GET_CUMULATIVE_DISTANCE=" select top 1 CUMULATIVE_DISTANCE from dbo.VehicleSummaryData (NOLOCK) where RegistrationNo=? and DateGMT<? and SystemId=? and ClientId=? order by DateGMT desc";
	
	public static final String GET_TANK_CAPACITY_AND_MILEAGE_WITH_LOAD="select TankCapacity,isnull(Approx_Mileage_With_Load,0) as Approx_Mileage_With_Load from dbo.tblVehicleMaster where VehicleNo=?";
	
	public static final String GET_TOTAL_REFUEL="select sum(REFUEL_PERCENT) as totalfuel, count(REFUEL_PERCENT) as RefuelCount from dbo.RefuelCalculatedData where REGISTRATION_NO=? and GMT between ? and ?";
	
	public static final String GET_IDLE_STOP_OVERSPEED_COUNT= "select isnull(a.TYPE_OF_ALERT,0) as TypeOfAlert,isnull(count(a.TYPE_OF_ALERT),0) as AlertCount from " +
	" (select TYPE_OF_ALERT from Alert where TYPE_OF_ALERT in (1,39,37) and REGISTRATION_NO=? and GMT between ? and ?) a " +
	" group by a.TYPE_OF_ALERT order by count(a.TYPE_OF_ALERT) ";
	
	public static final String INSERT_INTO_VEHICLE_SUMMARY="insert into AMS.dbo.VehicleSummaryData(DateGMT,RegistrationNo,UnitNo,SystemId,ClientId,NoOfStop," +
	"StopDurationHrs,NoOfIdle,IdleDurationHrs,NoOfOverSpeed,DistTravelledWithOverSpeed,MaxSpeed,TravelTimeHrs,EngineHrs,TotalDistanceTravelled," +
	"startLocation,endLocation,startDateInGMT,endDateInGMT,LastRecordProcessed,StartTime,EndTime,Odometer,FirstRunning,LastRunning,FirstFuel," +
	"LastFuel,Refuel,FuelConsume,Mileage,DriverName,FuelInLtr,IdleViolationCount,StoppageViolationCount,GroupId,Communicating,SBViolationCount," +
	"InsertedTime,FuelUsed,REFUEL_COUNT,CUMULATIVE_DISTANCE) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,?,?)";
	
	public static final String INSERT_INTO_REPORT_REPROCESS="insert into  dbo.REPORT_REPROCESS(REGISTRATION_NO,REPROCESSED_DATE,SYSTEM_ID,CUSTOMER_ID,INSERTED_TIME,USER_ID)values(?,?,?,?,getutcdate(),?)";
	
	public static final String UPDATE_INTO_VEHICLE_SUMMARY="update AMS.dbo.VehicleSummaryData set NoOfStop=?,"+
	"StopDurationHrs=?,NoOfIdle=?,IdleDurationHrs=?,NoOfOverSpeed=?,DistTravelledWithOverSpeed=?,MaxSpeed=?,TravelTimeHrs=?,EngineHrs=?,TotalDistanceTravelled=?,"+
	"startLocation=?,endLocation=?,LastRecordProcessed=?,StartTime=?,EndTime=?,Odometer=?,FirstRunning=?,LastRunning=?,FirstFuel=?,"+
	"LastFuel=?,Refuel=?,FuelConsume=?,Mileage=?,DriverName=?,FuelInLtr=?,IdleViolationCount=?,StoppageViolationCount=?,Communicating=?,SBViolationCount=?,"+
	"FuelUsed=?,REFUEL_COUNT=?,CUMULATIVE_DISTANCE=?,UnitNo=? where RegistrationNo=? and SystemId=? and ClientId=? and DateGMT=? ";
	
	public static final String GET_VEHICLE_SUMMARY="select RegistrationNo,DateGMT from AMS.dbo.VehicleSummaryData (NOLOCK) where SystemId=? and ClientId=? and RegistrationNo=? and DateGMT=?";
			
	public static final String SELECT_DRIVER_NAME_FOR_TAXI_METER = "SELECT b.Fullname as fullname FROM DRIVER_VEHICLE_HISTORY a "
		+ "INNER JOIN Driver_Master b ON a.DRIVER_ID=b.Driver_id and a.SYSTEM_ID=b.System_id "
		+ "WHERE ? between a.FROM_DATE_TIME and a.TO_DATE_TIME and a.SYSTEM_ID=? and a.REGISTRATION_NO=? " 
		+ "UNION SELECT b.Fullname as fullname FROM Driver_Vehicle a "
		+ "INNER JOIN Driver_Master b ON a.DRIVER_ID=b.Driver_id and a.SYSTEM_ID=b.System_id "
		+ "WHERE a.SYSTEM_ID=? and a.REGISTRATION_NO=? and a.DATE_TIME<=?";
	
	public static final String GET_OVERSPEED_COUNT= "select count(*) as AlertCount from ALERT.dbo.OVER_SPEED_DATA where REGISTRATION_NO=? and GMT between ? and ?" ;
	/**
	 * Inserts a record in dbo.CUSTOMER_MASTER table with customer details
	 */
	public static final String SaveCustomerDetails="insert into dbo.CUSTOMER_MASTER(NAME,ADDRESS,COUNTRY_CODE,STATE_CODE,CITY,ZIP_CODE,PHONE_NO,MOBILE_NO,FAX,EMAIL,WEBSITE,SYSTEM_ID,STATUS,CREATED_BY,ACTIVATION_STATUS) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,'Incomplete')";
	
	public static final String SaveCustomerDetails_With_ID="insert into dbo.CUSTOMER_MASTER(CUSTOMER_ID,NAME,ADDRESS,COUNTRY_CODE,STATE_CODE,CITY,ZIP_CODE,PHONE_NO,MOBILE_NO,FAX,EMAIL,WEBSITE,SYSTEM_ID,STATUS,CREATED_BY,ACTIVATION_STATUS,PAYMENT_DUE_DATE,PAYMENT_NOTIFICATION_PERIOD,STD_SPEED_IDLE_STOPPAGE,SNOOZE_TIME) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'Incomplete',?,?,?,?)";
	
	public static final String SaveCustomerDetails_tblCustomerMaster="insert into AMS.dbo.tblCustomerMaster(CustomerId,CustomerName,HOAddress,City,Fax,CustomerPhone,CustomerMobile,CustomerEmail,CustomerURL,System_id)values(?,?,?,?,?,?,?,?,?,?)";
	
	public static final String SaveCustomerDetails_tblCustomerMaster_Without_ID="insert into AMS.dbo.tblCustomerMaster(CustomerName,HOAddress,City,Fax,CustomerPhone,CustomerMobile,CustomerEmail,CustomerURL,System_id,Expiry_date,PaymentNotificationPeriod,StopIdleSpeed)values(?,?,?,?,?,?,?,?,?,?,?,?)";
	/**
	 * Updates the record in dbo.CUSTOMER_MASTER table with modified customer details for customerId and SystemId
	 */
	public static final String UpdateCustomerDetails= "update dbo.CUSTOMER_MASTER set NAME=?,ADDRESS=?,COUNTRY_CODE=?,STATE_CODE=?,CITY=?,ZIP_CODE=?,PHONE_NO=?,MOBILE_NO=?,FAX=?,EMAIL=?,WEBSITE=?,STATUS=?,PAYMENT_DUE_DATE=?,PAYMENT_NOTIFICATION_PERIOD=?,STD_SPEED_IDLE_STOPPAGE=?,SNOOZE_TIME=? where SYSTEM_ID=? and CUSTOMER_ID=? ";
	public static final String UpdateCustomerDetailsIntoAMSdb="update AMS.dbo.tblCustomerMaster set CustomerName=?,HOAddress=?,CustomerPhone=?,CustomerMobile=?,CustomerURL=?,CustomerEmail=?,Expiry_date=?,PaymentNotificationPeriod=?,StopIdleSpeed=? where System_id=? and CustomerId=?";
	/**
	 * Inserting into CUSTOMER PROCESS SETTING table
	 */
	public static final String INSERT_INTO_CUSTOMER_PROCESS_ASSOC="insert into dbo.CUSTOMER_PROCESS_ASSOC(CUSTOMER_ID, PROCESS_ID, SYSTEM_ID, CREATED_BY) values(?,?,?,?) ";
	/**
	 * getting processid from Product Process
	 */
	
	//public static final String GET_PROCESS_ID_FOR_ESSENTIAL_MONITORING = "select PROCESS_ID from dbo.PRODUCT_PROCESS where PROCESS_LABEL_ID="+"'"+"Ess_Montr"+"'";
	/**
	 * inserting default group for each customer as client name
	 */
	public static final String INSERT_DEFAULT_GROUP_IN_ASSETGROUP_TABLE="insert into dbo.ASSET_GROUP(GROUP_NAME,CUSTOMER_ID,SYSTEM_ID,CREATED_BY) values(?,?,?,?)";
	
	public static final String INSERT_DEFAULT_GROUP_IN_ASSETGROUP_TABLE_WITH_ID="insert into dbo.ASSET_GROUP(GROUP_ID,GROUP_NAME,CUSTOMER_ID,SYSTEM_ID,CREATED_BY) values(?,?,?,?,?)";
	
	/**
	 * updating default group name as client name 
	 */
	public static final String UPDATE_DEFAULT_GROUP_IN_ASSETGROUP_TABLE="update dbo.ASSET_GROUP set GROUP_NAME=? where CUSTOMER_ID=? and GROUP_ID=? and SYSTEM_ID=?";
	
	public static final String UPDATE_DEFAULT_GROUP_IN_VEHICLE_GROUP="update AMS.dbo.VEHICLE_GROUP set GROUP_NAME=? where CLIENT_ID=? and GROUP_ID=? and SYSTEM_ID=? ";
	
	public static final String UPDATE_LIVE_VISION_CLIENT_NAME="update AMS.dbo.Live_Vision_Support set CLIENT_NAME=? where CLIENT_ID=? and SYSTEM_ID=?";
	
	public static final String UPDATE_LIVE_VISION_GROUP_NAME="update AMS.dbo.Live_Vision_Support set GROUP_NAME=? where GROUP_NAME=? and CLIENT_ID=? and SYSTEM_ID=?";
	/**
	 * getting default group id
	 */
	public static final String GET_DEFAULT_GROUPID="select GROUP_ID from dbo.ASSET_GROUP where GROUP_NAME=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String GET_STATE_DETAILS="select STATE_CODE,STATE_NAME from dbo.STATE_DETAILS where COUNTRY_CODE=(select COUNTRY_CODE from dbo.CUSTOMER_MASTER where CUSTOMER_ID=? and SYSTEM_ID=?)";
	
	public static final String GET_CITY_DETAILS="select CityID as CITY_ID,CityName as CITY_NAME from Maple.dbo.tblCity where StateID=? order by CityName";
	/**
	 * deleting feature group association for Customer
	 */
	public static final String DELETE_FEATURE_GROUP_ASS_FOR_CUST="delete from dbo.ASSET_GROUP_PROCESS where GROUP_ID in(select GROUP_ID from ASSET_GROUP where CUSTOMER_ID=? and SYSTEM_ID=?)";
	
	/**
	 * Delete a record in dbo.ASSET_GROUP table with asset group details for customer
	 */
	public static final String DELETE_ASSET_GROUP_FOR_CUST = "delete from dbo.ASSET_GROUP where CUSTOMER_ID=? and SYSTEM_ID=?";
	
	/**
	 * delete customer feature association table record for customer
	 */
	public static final String DELETE_CUST_FEATURE_ASS="delete from dbo.CUSTOMER_PROCESS_ASSOC where SYSTEM_ID=? and CUSTOMER_ID=?";
	
	/**
	 * Deleting the record in dbo.CUSTOMER_MASTER table for customerId and SystemId
	 */
	public static final String DeleteCustomerDetails="delete from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=?";
	/***
	 * getting defaultid for new customer
	 */
	public static final String GetCreatedDefaultGroupID = "select GROUP_ID from dbo.ASSET_GROUP where GROUP_NAME=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String GetCreatedDefaultGroupID_From_VehicleGroup = "select GROUP_ID from AMS.dbo.VEHICLE_GROUP where GROUP_NAME=? and CLIENT_ID=? and SYSTEM_ID=?";

	
	/**
	 *  inserting asset group details in AMS vehicle group
	 */
	public static final String INSERT_INTO_AMS_VEHICLE_GROUP = "insert into AMS.dbo.VEHICLE_GROUP(GROUP_ID, GROUP_NAME,CLIENT_ID,SYSTEM_ID,USER_ID) values(?,?,?,?,?)";
	
	public static final String INSERT_INTO_AMS_VEHICLE_GROUP_WITHOUT_ID = "insert into AMS.dbo.VEHICLE_GROUP(GROUP_NAME,CLIENT_ID,SYSTEM_ID,USER_ID) values(?,?,?,?)";
	
	/**
	 * Inserting a record into AMS.dbo.tblCustomerMaster table with customer
	 * details
	 */
	public static final String SaveCustomerDetailsIntoAMS = "insert into AMS.dbo.tblCustomerMaster(CustomerId,CustomerName,HOAddress,CustomerPhone,CustomerMobile,City,Fax,System_id) values(?,?,?,?,?,?,?,?)";
	
	/**
	 * query to check record exists in vehicle master
	 */
	
	public static final String getVehicleDetails= "select REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT where SYSTEM_ID=? and CLIENT_ID=? ";
	
	
	
	
	/*********query statement for User Management********/
	
	
	/**
	 * Fetching the record from dbo.USERS table for CustomerId and SystemId
	 */
	public static final String getUserDetails = "select a.USER_ID,a.USER_NAME,a.PASSWORD,a.FIRST_NAME,a.MIDDLE_NAME,a.LAST_NAME,a.PHONE,a.EMAIL,a.BRANCH_ID,a.USERAUTHORITY,a.STATUS,a.MOBILE_NUMBER,a.FAX, b.BranchName,a.PROCESS_ID as EMVISION , isnull (a.Imprecise_Location_Setting, 0) as LOCATION_SETTING, isnull(ROLE_ID,0) as ROLE_ID  from dbo.USERS a left outer join Maple.dbo.tblBranchMaster b on a.BRANCH_ID=b.BranchId  where CUSTOMER_ID=? and SYSTEM_ID=?";

	
	public static final String getUserProfileDetails = "select a.USER_ID,a.USER_NAME,a.PASSWORD,a.FIRST_NAME,a.MIDDLE_NAME,a.LAST_NAME,a.PHONE,a.EMAIL,a.MOBILE_NUMBER,a.FAX,a.MAP_TYPE from dbo.USERS a  where USER_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";

	/**
	 * Inserts a record in dbo.USERS table with user details
	 */
	public static final String SaveUserDetails = "insert into dbo.USERS(CUSTOMER_ID, SYSTEM_ID, USER_NAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, PHONE, EMAIL,BRANCH_ID, USERAUTHORITY, STATUS, CREATED_BY, MOBILE_NUMBER, FAX) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	
	public static final String SaveUserDetails_WithId = "insert into dbo.USERS(USER_ID,CUSTOMER_ID, SYSTEM_ID, USER_NAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, PHONE, EMAIL,BRANCH_ID, USERAUTHORITY, STATUS, CREATED_BY, MOBILE_NUMBER, FAX,PROCESS_ID , Imprecise_Location_Setting,ROLE_ID) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	
	public static final String SELECT_MAX_USER_ID = "select max(User_id) as uid from AMS.dbo.Users where System_id=?";
	/**
	 * inserting user records in old AMS table from new admin module  
	 */
	public static final String SAVE_USER_AMS="insert into AMS.dbo.Users(User_password,Firstname,Lastname,Telephone,Emailed,Login_name,Client_id,System_id,BranchId,Status,User_id,FmsUserAuthority) values(?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public static final String SAVE_USER_AMS_NEW="insert into AMS.dbo.Users(User_password,Firstname,Lastname,Telephone,Emailed,Login_name,Client_id,System_id,BranchId,Status,User_id,FmsUserAuthority,Password_Link_SessionId,Imprecise_Location_Setting,ROLE_ID) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	/**
	 * saving into the AMS_USER_GROUP----------later it has to remove after full implementation
	 */
	public static final String SAVE_USER_GROUP_AMS="insert into AMS.dbo.User_Group(User_id,Group_id,System_id) values(?,?,?)";
	/**
	 * Fetch Vehicle Client
	 */
	public static final String SELECT_VEHICLE_CLIENT = "select REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT where CLIENT_ID=?";
	/**
	 * Associating vehicle user while creating user
	 */
	public static final String INSERT_VEHICLE_USER = "insert into AMS.dbo.Vehicle_User values(?,?,?,getdate())";
	/**
	 * GET Regno from vehicle master
	 */
	public static final String SELECT_REG_NO_LIST = "select VehicleNo as regno from AMS.dbo.tblVehicleMaster where System_id=? and VehicleStatus='Active' order by VehicleNo";

	/**
	 * Update a record in dbo.USERS table with user details
	 */
	public static final String ModifyUserDetails = "update dbo.USERS set USER_NAME=?, PASSWORD=?, FIRST_NAME=?,MIDDLE_NAME=?, LAST_NAME=?, PHONE=?, EMAIL=?,BRANCH_ID=?, USERAUTHORITY=?, STATUS=?, MOBILE_NUMBER=?,FAX=? ,PROCESS_ID=?, Imprecise_Location_Setting =?  where USER_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? ";
	/**
    * modify user details in AMS Users table from new Admin module
    */
	public static final String MODIFY_USER_IN_AMS="update AMS.dbo.Users set Login_name=?,User_password=?,Firstname=?,Lastname=?,Telephone=?,Emailed=?,BranchId=?,Status=?,FmsUserAuthority=? where User_id=? and Client_id=? and System_id=?";
	
	public static final String MODIFY_USER_IN_AMS_NEW="update AMS.dbo.Users set Login_name=?,User_password=?,Firstname=?,Lastname=?,Telephone=?,Emailed=?,BranchId=?,Status=?,FmsUserAuthority=?,Password_Link_SessionId=?,Imprecise_Location_Setting=? where User_id=? and Client_id=? and System_id=?";

	
	public static final String UpdateUserDetails = "update dbo.USERS set PASSWORD=?, FIRST_NAME=?,MIDDLE_NAME=?, LAST_NAME=?, PHONE=?, EMAIL=?, MOBILE_NUMBER=?,FAX=?,Map_Type=? where USER_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? ";
	public static final String UPDATE_USER_IN_AMS="update AMS.dbo.Users set User_password=?,Firstname=?,Lastname=?,Telephone=?,Emailed=?,PasswordModifiedTime=getutcdate() where User_id=? and Client_id=? and System_id=?";

	/**
	 * Delete a record in dbo.USERS table with user details
	 */
	public static final String DeleteUserDetails = "delete from dbo.USERS where CUSTOMER_ID=? and USER_ID=? and SYSTEM_ID=?";
  /**
   * delete users from  Users table from new Admin
   */
	public static final String DELETE_USER_FROM_AMS="delete from AMS.dbo.Users where Client_id=? and User_id=?  and System_id=?";
	
	/**
	 * deleting from AMS user group-------------this query has to remove later 
	 */
	
	public static final String Delete_Group_id_From_AMS="delete from AMS.dbo.User_Group where User_id=? and System_id=?";
	
	
	/**
	 * updating live vision support table setting client name null
	 */
	
	public static final String Live_Vision_Support_AMS = "update AMS.dbo.Live_Vision_Support set GROUP_NAME=null, CLIENT_NAME=null where CUSTOMER_ID=? and SYSTEM_ID=?";
	
	/**
	 * Deleting the record from AMS.dbo.tblCustomerMaster for customerid and
	 * systemid
	 */
	public static final String DeleteCustomerMasterDetailsFromAMSdb = "delete from AMS.dbo.tblCustomerMaster where System_id=? and CustomerId=?";
	
	
	
	
	public static final String GET_BRANCH_LIST="Select a.BranchId,a.BranchName COLLATE DATABASE_DEFAULT +' ('+isnull( b.CustomerName,'')+')' as BranchName   from Maple.dbo.tblBranchMaster a left outer join  AMS.dbo.tblCustomerMaster b on  b.CustomerId = a.ClientId and  b.System_id = a.SystemId where a.SystemId=?";
	
	public static final String GET_EM_VISION_LIST="select a.PROCESS_ID as ID ,b.LANG_ENGLISH as NAME from ADMINISTRATOR.dbo.PRODUCT_PROCESS a inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b on b.LABEL_ID=a.PROCESS_LABEL_ID where a.PROCESS_ID in (29,25,33,20)";
	
	
	//-----------------------------query related to Customer Setting details-------------------------------------------//
	public static final String GET_PRODUCT_TYPE_LABEL="select distinct PROCESS_TYPE_LABEL_ID from dbo.PRODUCT_PROCESS";
	public static final String GET_SETTING_TYPE_LABEL="select * from dbo.CUSTOMER_PROCESS_SETTING";
	/**
	 * fetching Process Label Id List for Customer process list
	 */
	public static final String Get_PROCESS_LABELID_LIST = "select distinct a.PROCESS_ID, b.PROCESS_LABEL_ID from dbo.CUSTOMER_PROCESS_ASSOC a inner join dbo.PRODUCT_PROCESS b on a.PROCESS_ID=b.PROCESS_ID  where a.CUSTOMER_ID=? order by PROCESS_ID";
	
	/**
	 * getting featurename,corrosponding component's setting name, fieldtype and label for message from dbo.FEATURES and dbo.FEATURE_CUSTOMER_SETTING
	 */

	/*public static final String GET_SETTING_NAME_AND_TYPE_AND_MESSAGE = "select b.FEATURE_NAME,a.SETTING_NAME,a.TYPE,a.LABEL_FOR_MESSAGE from dbo.FEATURE_CUSTOMER_SETTING a "+
															" inner join dbo.FEATURES b on  b.ID=a.FEATURE_ID "+
															" where FEATURE_ID in (#) "+
															" order by ORDER_OF_SETTING asc ";*/
	
	public static final String GET_SETTING_NAME_TYPE_AND_MESSAGE="select a.SETTING_LABEL_ID,a.MESSAGE_LABEL_ID,a.FIELD_TYPE,b.PROCESS_LABEL_ID from dbo.CUSTOMER_PROCESS_SETTING a inner join dbo.PRODUCT_PROCESS b on a.PROCESS_ID=b.PROCESS_ID where a.PROCESS_ID=? order by ORDER_OF_SETTING";
	
	public static final String SAVE_ESSENTIAL_MONITORING_DETAILS = "update dbo.CUSTOMER_MASTER set STOPPAGE_TIME_ALERT=?,IDLETIME_ALERT=?,NON_COMMUNICATING_ALERT=?,LIVE_POSITION_ALERT=?,IDLE_SUBSEQUENT_REMAINDER=?,IDLE_SUBSEQUENT_NOTIFICATION=?,STOPPAGE_INSIDE_HUB=? where CUSTOMER_ID=? and SYSTEM_ID=? ";

	public static final String SAVE_ESSENTIAL_tblCustomerMaster="update AMS.dbo.tblCustomerMaster set IdleTime=?,IdleTimeAlert=?,GpsAlert=?,LivePositionAlert=? where CustomerId=? and System_id=?";
	
	public static final String SAVE_ADVANCE_MONITORING_DETAILS = "update dbo.CUSTOMER_MASTER set RESTRICTIVE_MOMENT_START=?,RESTRICTIVE_MOMENT_END=?,RESTRICTIVE_NON_MOMENT_START=?,RESTRICTIVE_NON_MOMENT_END=?,AC_IDLE_TIME_ALERT=?,NEARTO_BOARDER_DISTANCE=?,SEAT_BELT_INTERVAL=?,RESTRICTIVE_MOMENT_DISTANCE=?,RESTRICTIVE_NON_MOMENT_DISTANCE=?,SEAT_BELT_DISTANCE=?,DOOR_ALERT_INTERVAL=?,DOOR_ALERT_INSIDE_HUB=? where CUSTOMER_ID=? and SYSTEM_ID=? ";
	
	public static final String SAVE_ADVANCE_MONITORING_tblCustomerMaster="update AMS.dbo.tblCustomerMaster set acIdleTimeAlert=?,NearToBorderDist=?,SeatBeltAlertIntervalCli=?,NightEyeStart=?,NightEyeEnd=?,NightEyeDistance=? where CustomerId=? and System_id=?";
	
	//public static final String GET_CUSTOMER_WORK_DETAILS="select ID,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY,START_DAY_OF_WEEK,START_TIME,END_TIME from dbo.CUSTOMER_WORK_WEEK where SYSTEM_ID=? and CUSTOMER_ID=?";
	public static final String GET_CUSTOMER_WORK_DETAILS="select ID,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY,START_DAY_OF_WEEK,START_TIME,END_TIME from dbo.CUSTOMER_WORK_WEEK where SYSTEM_ID=? and CUSTOMER_ID=? and TYPE=? ";

	
	public static final String UPDATE_CUSTOMER_WORK_DETAILS="update dbo.CUSTOMER_WORK_WEEK set MONDAY=?,TUESDAY=?,WEDNESDAY=?,THURSDAY=?,FRIDAY=?,SATURDAY=?,SUNDAY=?,START_DAY_OF_WEEK=?,START_TIME=?,END_TIME=?,UPDATED_BY=?,UPDATED_TIME=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and TYPE=? ";
	
	//public static final String INSERT_CUSTOMER_WORK_DETAILS="insert into dbo.CUSTOMER_WORK_WEEK (MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY,START_DAY_OF_WEEK,START_TIME,END_TIME,CUSTOMER_ID,SYSTEM_ID,CREATED_BY,CREATED_TIME,UPDATED_BY,UPDATED_TIME)values(?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,getutcdate())";
	public static final String INSERT_CUSTOMER_WORK_DETAILS="insert into dbo.CUSTOMER_WORK_WEEK (MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY,START_DAY_OF_WEEK,START_TIME,END_TIME,CUSTOMER_ID,SYSTEM_ID,CREATED_BY,CREATED_TIME,UPDATED_BY,UPDATED_TIME,TYPE)values(?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,getutcdate(),?)";

	
	//public static final String INSERT_CUSTOMER_WORK_DETAILS_HISTORY="insert into dbo.CUSTOMER_WORK_WEEK_HISTORY (ID,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY,START_DAY_OF_WEEK,START_TIME,END_TIME,CUSTOMER_ID,SYSTEM_ID,CREATED_BY,CREATED_TIME,UPDATED_BY,UPDATED_TIME)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,getutcdate())";
	public static final String INSERT_CUSTOMER_WORK_DETAILS_HISTORY="insert into dbo.CUSTOMER_WORK_WEEK_HISTORY (ID,MONDAY,TUESDAY,WEDNESDAY,THURSDAY,FRIDAY,SATURDAY,SUNDAY,START_DAY_OF_WEEK,START_TIME,END_TIME,CUSTOMER_ID,SYSTEM_ID,CREATED_BY,CREATED_TIME,UPDATED_BY,UPDATED_TIME,TYPE)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,getutcdate(),?)";

	
	public static final String SAVE_MILKDISTRIBUTION_LOGISTICS_DETAILS = "update dbo.CUSTOMER_MASTER set MAX_TEMPERATURE=?,MIN_TEMPERATURE=? where CUSTOMER_ID=? and SYSTEM_ID=? ";
	
	public static final String SAVE_MILKDISTRIBUTION_tblCustomerMaster="update AMS.dbo.tblCustomerMaster set MaxTempLimitCli=?,MinTempLimitCli=? where CustomerId=? and System_id=?";
	
	public static final String SAVE_HEALTHSAFETY_ASSURANCE_DETAILS = "update dbo.CUSTOMER_MASTER set OS_LIMIT_BLACKTOP=?,OS_LIMIT_GRADED=? where CUSTOMER_ID=? and SYSTEM_ID=? ";
	
	public static final String SAVE_HEALTHSAFETY_ASSURANCE_tblCustomerMaster="update AMS.dbo.tblCustomerMaster set OverSpeedLimit=?,OverSpeedLimitforGRCli=? where CustomerId=? and System_id=?";
	
	//public static final String CUSTOMER_SETTING_DETAILS = "select a.VEHICLE_IMAGE,a.STOPPAGE_TIME_ALERT,a.IDLETIME_ALERT,a.NON_COMMUNICATING_ALERT,a.LIVE_POSITION_ALERT,a.STOPPAGE_INSIDE_HUB,a.RESTRICTIVE_MOMENT_START,a.RESTRICTIVE_NON_MOMENT_START,a.RESTRICTIVE_MOMENT_END,a.RESTRICTIVE_NON_MOMENT_END,a.AC_IDLE_TIME_ALERT,a.NEARTO_BOARDER_DISTANCE,a.SEAT_BELT_INTERVAL,a.RESTRICTIVE_MOMENT_DISTANCE,a.RESTRICTIVE_NON_MOMENT_DISTANCE,a.MIN_TEMPERATURE,a.MAX_TEMPERATURE,a.OS_LIMIT_BLACKTOP,a.OS_LIMIT_GRADED,a.SEAT_BELT_DISTANCE,a.IDLE_SUBSEQUENT_REMAINDER,a.IDLE_SUBSEQUENT_NOTIFICATION,b.MONDAY,b.TUESDAY,b.WEDNESDAY,b.THURSDAY,b.FRIDAY,b.SATURDAY,b.SUNDAY,b.START_DAY_OF_WEEK,b.START_TIME,b.END_TIME from dbo.CUSTOMER_MASTER a left outer join dbo.CUSTOMER_WORK_WEEK b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID where a.CUSTOMER_ID=? and a.SYSTEM_ID=?";
	
	public static final String CUSTOMER_SETTING_DETAILS = " select a.VEHICLE_IMAGE,a.STOPPAGE_TIME_ALERT,a.IDLETIME_ALERT,a.NON_COMMUNICATING_ALERT, "
		+ " a.LIVE_POSITION_ALERT,a.STOPPAGE_INSIDE_HUB, isnull(a.RESTRICTIVE_MOMENT_START,0) as RESTRICTIVE_MOMENT_START ,isnull(a.RESTRICTIVE_NON_MOMENT_START,0) as RESTRICTIVE_NON_MOMENT_START , "
		+ " isnull(a.RESTRICTIVE_MOMENT_END,0) as RESTRICTIVE_MOMENT_END ,isnull(a.RESTRICTIVE_NON_MOMENT_END,0) as RESTRICTIVE_NON_MOMENT_END,a.AC_IDLE_TIME_ALERT,a.NEARTO_BOARDER_DISTANCE, "
		+ " isnull(a.SEAT_BELT_INTERVAL,0 ) as SEAT_BELT_INTERVAL ,isnull(a.RESTRICTIVE_MOMENT_DISTANCE,0) as RESTRICTIVE_MOMENT_DISTANCE ,isnull(a.RESTRICTIVE_NON_MOMENT_DISTANCE,0) as RESTRICTIVE_NON_MOMENT_DISTANCE ,isnull ( a.MIN_TEMPERATURE,0) as MIN_TEMPERATURE,  "
		+ " isnull(a.MAX_TEMPERATURE, 0) as MAX_TEMPERATURE ,a.OS_LIMIT_BLACKTOP,a.OS_LIMIT_GRADED,isnull(a.SEAT_BELT_DISTANCE,0) as SEAT_BELT_DISTANCE ,a.IDLE_SUBSEQUENT_REMAINDER, "
		+ " a.IDLE_SUBSEQUENT_NOTIFICATION,b.MONDAY,b.TUESDAY,b.WEDNESDAY,b.THURSDAY,b.FRIDAY,b.SATURDAY,b.SUNDAY, "
		+ " b.START_DAY_OF_WEEK,b.START_TIME,b.END_TIME, "
		+ " isnull(c.MONDAY,'') as MONDAY1,isnull(c.TUESDAY,'') as TUESDAY1 ,isnull(c.WEDNESDAY,'') as WEDNESDAY1,isnull(c.THURSDAY,'') as THURSDAY1, " 
		+ " isnull(c.FRIDAY,'') as FRIDAY1,isnull(c.SATURDAY,'') as SATURDAY1,isnull(c.SUNDAY,'') as SUNDAY1,isnull(a.DOOR_ALERT_INTERVAL,0)as DOOR_ALERT_INTERVAL,isnull(a.DOOR_ALERT_INSIDE_HUB,'Y')as DOOR_ALERT_INSIDE_HUB" 
		+ " from dbo.CUSTOMER_MASTER a "
		+ " left outer join dbo.CUSTOMER_WORK_WEEK b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID and b.TYPE=1 "
		+ " left outer join dbo.CUSTOMER_WORK_WEEK c on a.CUSTOMER_ID=c.CUSTOMER_ID and a.SYSTEM_ID=c.SYSTEM_ID and c.TYPE=2 "
		+ " where a.CUSTOMER_ID=? and a.SYSTEM_ID=? "; 

	
	public static final String SAVE_IMAGE = "update dbo.CUSTOMER_MASTER set VEHICLE_IMAGE=? where CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String SAVE_IMAGE_AMS = "update AMS.dbo.tblCustomerMaster set VehicleImageName=? where CustomerId=? and System_id=?";
	/**
	 * Inserts a record in dbo.CUSTOMER_MASTER table with customer details
	 */
	//public static final String SaveCustomerDetails="insert into dbo.CUSTOMER_MASTER(NAME,ADDRESS,COUNTRY_CODE,STATE_CODE,CITY,ZIP_CODE,PHONE_NO,MOBILE_NO,FAX,EMAIL,WEBSITE,SYSTEM_ID,STATUS,CREATED_BY) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	/**
	 * Updates the record in dbo.CUSTOMER_MASTER table with modified customer details for customerId and SystemId
	 */
	//public static final String UpdateCustomerDetails= "update dbo.CUSTOMER_MASTER set NAME=?,ADDRESS=?,COUNTRY_CODE=?,STATE_CODE=?,CITY=?,ZIP_CODE=?,PHONE_NO=?,MOBILE_NO=?,FAX=?,EMAIL=?,WEBSITE=?,STATUS=? where SYSTEM_ID=? and CUSTOMER_ID=? ";
	
	/**
	 * Inserts a record in dbo.ASSET_GROUP table with asset group details
	 */
	public static final String SaveAssetGroupDetails = "insert into dbo.ASSET_GROUP(GROUP_NAME, CUSTOMER_ID, SYSTEM_ID, SUPERVISOR_ID, CREATED_BY,ACTIVATION_STATUS) values(?,?,?,?,?,'Incomplete')";
	
	public static final String SaveAssetGroupDetails_WithID = "insert into dbo.ASSET_GROUP(GROUP_ID,GROUP_NAME, CUSTOMER_ID, SYSTEM_ID, SUPERVISOR_ID, CREATED_BY,ACTIVATION_STATUS,STATE,CITY,HUB_ID) values(?,?,?,?,?,?,'Incomplete',?,?,?)";
	
	public static final String SAVE_IN_VEHICLE_GROUP="insert into AMS.dbo.VEHICLE_GROUP(GROUP_ID,GROUP_NAME,CLIENT_ID,SYSTEM_ID,USER_ID,UPDATED_TIME,Supervisor1)values(?,?,?,?,?,getutcdate(),?)";
	
	public static final String SAVE_IN_VEHICLE_GROUP_Without_ID="insert into AMS.dbo.VEHICLE_GROUP(GROUP_NAME,CLIENT_ID,SYSTEM_ID,USER_ID,UPDATED_TIME,Supervisor1)values(?,?,?,?,getutcdate(),?)";
	/**
	 * Inserts a record in dbo.USERS table with user details
	 */
	//public static final String SaveUserDetails = "insert into dbo.USERS(CUSTOMER_ID, SYSTEM_ID, USER_NAME, PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, PHONE, EMAIL, FEATURE_GROUP_ID, BRANCH_ID, USERAUTHORITY, STATUS, CREATED_BY) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	
	/**
	 * Fetching the record from dbo.USERS table for CustomerId and SystemId
	 */
	public static final String GetSupervisorDetails = "select USER_ID, isnull(FIRST_NAME,'')+' '+isnull(LAST_NAME,'') as NAME, PHONE, EMAIL  from dbo.USERS where CUSTOMER_ID= ? and SYSTEM_ID=? and STATUS='Active'";

	/**
	 * Fetching the record from dbo.CUSTOMER_MASTER table for CustomerId and SystemId
	 */
	public static final String GET_CUSTOMER_DETAILS="select a.NAME,a.ADDRESS,a.PHONE_NO,a.MOBILE_NO,a.CITY,FAX,a.STATUS,b.FEATURE_LIST from dbo.CUSTOMER_MASTER a "+ 
												" left outer join dbo.CUSTOMER_FEATURE_ASSOC b on b.SYSTEM_ID=a.SYSTEM_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "+
												" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? ";

	/**
	 * Fetching the record from dbo.USERS table for CustomerId and SystemId
	 */
	public static final String GetUserName = "select USER_ID, USER_NAME from dbo.USERS where SYSTEM_ID=? and CUSTOMER_ID=? ";


	/**
	 * Update a record in dbo.USERS table with user details
	 */
	//public static final String ModifyUserDetails = "update dbo.USERS set USER_NAME=?, PASSWORD=?, FIRST_NAME=?,MIDDLE_NAME=?, LAST_NAME=?, PHONE=?, EMAIL=?,FEATURE_GROUP_ID=?, BRANCH_ID=?, USERAUTHORITY=?, STATUS=?  where USER_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? ";

	
	/**
	 * Fetching the record from dbo.USERS table for CustomerId and SystemId
	 */
	public static final String GetGroupName = "select GROUP_ID, GROUP_NAME, SUPERVISOR_ID from dbo.ASSET_GROUP where SYSTEM_ID=? and CUSTOMER_ID=? ";

	/**
	 * Update a record in dbo.ASSET_GROUP table with asset group details
	 */
	public static final String ModifyAssetGroupDetails = "update dbo.ASSET_GROUP set GROUP_NAME=? ,SUPERVISOR_ID=?,STATE=?,CITY=?,HUB_ID=? where CUSTOMER_ID=?  and SYSTEM_ID=? and GROUP_ID=?";
	
	public static final String ModifyVehicleGroupDetails="update AMS.dbo.VEHICLE_GROUP set GROUP_NAME=?,Supervisor1=? where CLIENT_ID=? and SYSTEM_ID=? and GROUP_ID=?";

	public static final String UPDATE_LIVE_VISION="update AMS.dbo.Live_Vision_Support set GROUP_NAME=? where  GROUP_NAME=? and CLIENT_ID=? and SYSTEM_ID=?";
	/**
	 * Delete a record in dbo.ASSET_GROUP table with asset group details
	 */
	public static final String DeleteAssetGroupDetails = "delete from dbo.ASSET_GROUP where GROUP_ID=? and CUSTOMER_ID=? and SYSTEM_ID=?";
    
	public static final String DELETE_VEHICLE_GROUP="delete from AMS.dbo.VEHICLE_GROUP where GROUP_ID=? and CLIENT_ID=? and SYSTEM_ID=?";
	/**
	 * Fetching the record from dbo.USERS table for CustomerId and SystemId
	 */
	//public static final String getUserDetails = "select PASSWORD, FIRST_NAME, MIDDLE_NAME, LAST_NAME, PHONE, EMAIL, FEATURE_GROUP_ID, BRANCH_ID, USERAUTHORITY, STATUS from  dbo.USERS where SYSTEM_ID=? and CUSTOMER_ID=? and USER_ID=? ";

	
	public static final String UPDATE_VEHICLE_CLIENT="update AMS.dbo.VEHICLE_CLIENT set GROUP_ID=(select GROUP_ID from dbo.ASSET_GROUP where GROUP_NAME=?) where GROUP_ID=? and CLIENT_ID=? and SYSTEM_ID=?";
	
	public static final String UPDATE_LIVE_VISION_DEFAULT="update AMS.dbo.Live_Vision_Support set GROUP_NAME=? where  GROUP_NAME collate database_default =(select GROUP_NAME from dbo.ASSET_GROUP where GROUP_ID=? and CLIENT_ID=? and SYSTEM_ID=?) and CLIENT_ID=? and SYSTEM_ID=?";
	
	public static final String UPDATE_DRIVERMASTER_GROUP="update AMS.dbo.Driver_Master set GroupId=null  where GroupId=? and Client_id=? and System_id=?";
	/**
	 * Fetching the record from dbo.ASSET_GROUP table for CustomerId and SystemId and group name
	 */
	public static final String CheckGroupName = "select GROUP_ID  from dbo.ASSET_GROUP where CUSTOMER_ID=? and SYSTEM_ID=? and upper(GROUP_NAME)=? ";
	
		
	/**
	 * Fetching the record from dbo.USERS table for  SystemId
	 */

	public static final String CheckUserName = "select USER_ID from dbo.USERS where USER_NAME=?";
	
	public static final String CheckUserEmail = " select * from AMS.dbo.Users where System_id = ? and Emailed = ? and User_id = ? and  User_password = ''  ";

	public static final String getUserEmail = " select Emailed,User_password from AMS.dbo.Users where System_id = ?  and User_id = ? ";

	/**
	 * Inserting into Customer Feature Association table
	 */
	public static final String INSERT_INTO_CUSTOMER_FEATURE_ASS="insert into dbo.CUSTOMER_FEATURE_ASSOC(CUSTOMER_ID, FEATURE_LIST, SYSTEM_ID, CREATED_BY) values(?,?,?,?) ";
	
	/**
	 * checking whether feature details exist for customer
	 */
	public static final String CHECK_FEATURE_DETAILS_EXIST_FOR_CUST="select CUSTOMER_ID from dbo.CUSTOMER_FEATURE_ASSOC where SYSTEM_ID=? and CUSTOMER_ID=? ";
	
	/**
	 * updating customer feature association table record for customer
	 */
	public static final String UPDATE_CUST_FEATURE_ASS="update dbo.CUSTOMER_FEATURE_ASSOC set  FEATURE_LIST=? where SYSTEM_ID=? and CUSTOMER_ID=?";
	
	
	
	/**
	 * Fetching features selected by group
	 */
	public static final String GET_FEATURES_FOR_GROUP="select FEATURE_ID from dbo.ASSET_GROUP_FEATURE where GROUP_ID=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	/**
	 * deleting feature group association
	 */
	public static final String DELETE_FEATURE_GROUP_ASS="delete from dbo.ASSET_GROUP_FEATURE where CUSTOMER_ID=? and GROUP_ID=? and SYSTEM_ID=?";
	
	/**
	 * Inserting feature group association
	 */
	public static final String INSERT_FEATURE_GROUP_ASS="insert into dbo.ASSET_GROUP_FEATURE(CUSTOMER_ID,GROUP_ID,SYSTEM_ID,FEATURE_ID,CREATED_BY) values(?,?,?,?,?) ";
	
	
	
	
	
	/**
	 * Fetching the record from dbo.CUSTOMER_FEATURE_ASSOC table for  SystemId
	 */

	public static final String GET_FEATURE_LIST = "select FEATURE_LIST from dbo.CUSTOMER_FEATURE_ASSOC where CUSTOMER_ID=?";
	

	/**
	 * Saving the record from into dbo.MOBILE_APP_DOWNLOAD table 
	 */
	public static final String SAVE_DOWNLOADER_DETAILS = "insert into dbo.MOBILE_APP_DOWNLOAD(SYSTEM_ID,CUSTOMER_ID,CUSTOMER_NAME, MOBILE_NO, EMAIL, DESIGNATION, CREATED_BY) values(?,?,?,?,?,?,?)";


	public static final String GET_FEATURE_NAME = "select FEATURE_NAME from dbo.FEATURES where ID=?";


	public static final String GET_SETTING_NAME_AND_TYPE = "select SETTING_NAME, TYPE from dbo.FEATURE_CUSTOMER_SETTING where  FEATURE_ID=?";
	
	/**
	 * Fetching Feature Group from FEATURE_GROUP table
	 */
	public static final String GET_FEATURE_GROUP="select FEATURE_GROUP_ID,FEATURE_GROUP_NAME from FEATURE_GROUP where CUSTOMER_ID=? and SYSTEM_ID=? ";
	
	/**
	 * deleting Feature Group from FEATURE_GROUP table
	 */
	public static final String DELETE_FEATURE_GROUP="delete from FEATURE_GROUP where CUSTOMER_ID=? and SYSTEM_ID=? ";
	/**
	 * getting featurename,corrosponding component's setting name, fieldtype and label for message from dbo.FEATURES and dbo.FEATURE_CUSTOMER_SETTING
	 */

	public static final String GET_SETTING_NAME_AND_TYPE_AND_MESSAGE = "select b.FEATURE_NAME,a.SETTING_NAME,a.TYPE,a.LABEL_FOR_MESSAGE from dbo.FEATURE_CUSTOMER_SETTING a "+
															" inner join dbo.FEATURES b on  b.ID=a.FEATURE_ID "+
															" where FEATURE_ID in (#) "+
															" order by ORDER_OF_SETTING asc ";
/**
 * saving customer setting details into dbo.CUSTOMER_MASTER table
 */

public static final String SAVECUSTOMERSETTINGDETAILS = "update  dbo.CUSTOMER_MASTER set VEHICLE_IMAGE=?, STOPPAGE_TIME_ALERT=?, IDLETIME_ALERT=?, NON_COMMUNICATING_ALERT=?, LIVE_POSITION_ALERT=?, RESTRICTIVE_MOMENT_START=?, RESTRICTIVE_NON_MOMENT_START=?,RESTRICTIVE_MOMENT_END=?,RESTRICTIVE_NON_MOMENT_END=?,AC_IDLE_TIME_ALERT=?,NEARTO_BOARDER_DISTANCE=?,SEAT_BELT_INTERVAL=?,OS_LIMIT_BLACKTOP=?,OS_LIMIT_GRADED=?,MIN_TEMPERATURE=?,MAX_TEMPERATURE=?, RESTRICTIVE_MOMENT_DISTANCE=?,RESTRICTIVE_NON_MOMENT_DISTANCE=? where CUSTOMER_ID=? and SYSTEM_ID=?";
/**
 * getting feature group tree for particular user
 */

/*public static final String GETFEATUREGROUPTREE ="select b.FEATURE_NAME,isnull(c.SUB_FEATURE_NAME_LABEL,'') as Sub_Feature,a.ID,a.MENU_NAME_LABEL "+ 
                                                "from dbo.MENU_MASTER a "+  
                                                 "inner join dbo.FEATURES b on b.ID=a.FEATURE_ID "+  
                                                 "left outer join dbo.SUB_FEATURES c on c.SUB_FEATURE_ID=a.SUB_FEATURE_ID "+ 
                                                 "where  b.ID in (select a.FEATURE_ID from dbo.ASSET_GROUP_FEATURE a "+
                                                 "inner join dbo.ASSET_GROUP b on a.GROUP_ID=b.GROUP_ID "+
                                                "and a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID "+
                                                 "where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and b.SUPERVISOR_ID=?) "+
                                                 "order by a.FEATURE_ID, a.ORDER_OF_TYPE asc";
*/

public static final String GETFEATUREGROUPTREE="select a.MENU_ID, b.PROCESS_LABEL_ID,isnull(c.SUB_PROCESS_LABEL_ID,'') as Sub_Feature,a.MENU_LABEL_ID "+
" from ADMINISTRATOR.dbo.MENU_MASTER a "+
" inner join ADMINISTRATOR.dbo.PRODUCT_PROCESS b on b.PROCESS_ID=a.PROCESS_ID "+ 
" left outer join ADMINISTRATOR.dbo.SUB_PROCESS c on c.SUB_PROCESS_ID=a.SUB_PROCESS_ID "+ 
" inner join ADMINISTRATOR.dbo.PRODUCT_ELEMENT d on d.ELEMENT_ID=a.ELEMENT_ID "+
" where (d.ELEMENT_NAME in ('/Jsps/Admin/AdminTab.jsp') or d.ELEMENT_NAME collate database_default in (select distinct(c.program_name) from AMS.dbo.menu_item_master c where c.system_id=?)) " +
" and b.PROCESS_ID in (select a.PROCESS_ID from ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS a "+ 
" where a.GROUP_ID in (select distinct(vc.GROUP_ID) from AMS.dbo.VEHICLE_CLIENT vc "+
" inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER=vu.Registration_no and vc.SYSTEM_ID=vu.System_id "+ 
" where vu.User_id=? and vc.CLIENT_ID=? and vu.System_id=? and vc.SYSTEM_ID=? and vc.GROUP_ID is not null) "+
" and a.SYSTEM_ID=?) "+
" order by b.ORDER_OF_DISPLAY,a.PROCESS_ID,a.SUB_PROCESS_ID,a.ORDER_OF_DISPLAY asc ";

public static final String GETFEATUREGROUPTREE_LTSP="select a.MENU_ID, b.PROCESS_LABEL_ID,isnull(c.SUB_PROCESS_LABEL_ID,'') as Sub_Feature,a.MENU_LABEL_ID "+
" from ADMINISTRATOR.dbo.MENU_MASTER a "+
" inner join ADMINISTRATOR.dbo.PRODUCT_PROCESS b on b.PROCESS_ID=a.PROCESS_ID "+ 
" left outer join ADMINISTRATOR.dbo.SUB_PROCESS c on c.SUB_PROCESS_ID=a.SUB_PROCESS_ID "+ 
" inner join ADMINISTRATOR.dbo.PRODUCT_ELEMENT d on d.ELEMENT_ID=a.ELEMENT_ID "+
" where (d.ELEMENT_NAME in ('/Jsps/Admin/AdminTab.jsp') or d.ELEMENT_NAME collate database_default in (select distinct(c.program_name) from AMS.dbo.menu_item_master c where c.system_id=?)) " +
" and b.PROCESS_ID in (select a.PROCESS_ID from ADMINISTRATOR.dbo.ASSET_GROUP_PROCESS a "+ 
" where a.GROUP_ID in (select distinct(vc.GROUP_ID) from AMS.dbo.VEHICLE_CLIENT vc "+
" inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER=vu.Registration_no and vc.SYSTEM_ID=vu.System_id "+ 
" where vu.User_id=? and vu.System_id=? and vc.SYSTEM_ID=? and vc.GROUP_ID is not null) "+
" and a.SYSTEM_ID=?) "+
" order by b.ORDER_OF_DISPLAY,a.PROCESS_ID,a.SUB_PROCESS_ID,a.ORDER_OF_DISPLAY asc ";

/**
 * saving user feature attachment in dbo.USER_FEATURE_DETACHMENT
 */

public static final String SAVE_USER_FEATURE_DETACHMENT_INFO = "insert into dbo.USER_PROCESS_DETACHMENT(SYSTEM_ID,USER_ID, MENU_ID,CREATED_BY) values(?,?,?,?)";
/**
 * checking whether user has already detached or not in user feature attachment from table dbo.USER_FEATURE_DETACHMENT
 */

public static final String CHECK_USER_FEATURE_DETACHMENT = "select * from dbo.USER_PROCESS_DETACHMENT where SYSTEM_ID=? and USER_ID=?";

/**
 * modifying user feature attachment in dbo.USER_FEATURE_DETACHMENT
 */
public static final String MODIFY_USER_FEATURE_DETACHMENT_INFO = "update dbo.USER_PROCESS_DETACHMENT set MENU_ID=? where SYSTEM_ID=? and USER_ID=? ";

public static final String DELETE_USER_FEATURE_DETACHMENT_INFO="delete from dbo.USER_PROCESS_DETACHMENT where USER_ID=? and SYSTEM_ID=? ";
/**
 * get the list of detached feature name with user
 */
public static final String GET_CHECKED_MENU = "select MENU_ID from dbo.USER_PROCESS_DETACHMENT where SYSTEM_ID=? and USER_ID=?";



/*******************************************************************************************************************************************************
*															ASSET GROUP STATEMENTS
*******************************************************************************************************************************************************/
public static final String GET_ASSET_GROUP_DETAILS="select a.GROUP_ID,a.GROUP_NAME,a.SUPERVISOR_ID,isnull(u.FIRST_NAME+' '+isnull(u.MIDDLE_NAME,'')+' '+isnull(u.LAST_NAME,''),'') as NAME,u.PHONE,u.EMAIL,a.ACTIVATION_STATUS,isnull(s.STATE_CODE,'') as STATE_CODE,isnull(s.STATE_NAME,'') as STATE_NAME,isnull(a.CITY,0) as CITY_ID,isnull(city.CityName,'') as CITY_NAME,isnull(c.HUBID,0) as HubId,isnull(c.NAME,'') as hubName from dbo.ASSET_GROUP a " +
												   "LEFT OUTER JOIN dbo.USERS u on a.SUPERVISOR_ID=u.USER_ID and a.CUSTOMER_ID=u.CUSTOMER_ID and a.SYSTEM_ID=u.SYSTEM_ID " +
												   "LEFT OUTER JOIN dbo.STATE_DETAILS s on s.STATE_CODE=a.STATE "+
												   "LEFT OUTER JOIN AMS.dbo.LOCATION c on c.HUBID=a.HUB_ID and c.SYSTEMID=a.SYSTEM_ID and c.CLIENTID=a.CUSTOMER_ID " +
												   "LEFT OUTER JOIN Maple.dbo.tblCity city on city.CityID = a.CITY " +
												   "where a.CUSTOMER_ID=? and a.SYSTEM_ID=?";

public static final String GET_PROCESS_ID_FOR_ESSENTIAL_MONITORING = "select PROCESS_ID from dbo.PRODUCT_PROCESS where PROCESS_LABEL_ID="+"'"+"Ess_Montr"+"'";


public static final String INSERT_ASSET_GROUP_PROCESS="insert dbo.ASSET_GROUP_PROCESS(GROUP_ID,SYSTEM_ID,PROCESS_ID,CREATED_TIME,CREATED_BY) values(?,?,?,getutcdate(),?)";

public static final String DELETE_ASSET_GROUP_PROCESS="delete from dbo.ASSET_GROUP_PROCESS where GROUP_ID=? and SYSTEM_ID=?";

public static final String GET_USER_GROUP_ASSOCIATION_DETAILS = " select distinct USER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION (NOLOCK) where SYSTEM_ID=? and GROUP_ID=? and "+
																" USER_ID not in (select  distinct USER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION (NOLOCK) "+
																" where SYSTEM_ID=? and GROUP_ID=(select GROUP_ID from ADMINISTRATOR.dbo.ASSET_GROUP (NOLOCK) where GROUP_NAME=? and SYSTEM_ID=? and CUSTOMER_ID=?)) ";

//public static final String MOVE_USER_GROUP_ASSOCIATION_DETAILS_TO_HISTOTRY = " insert into ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION_HISTORY select * from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION where SYSTEM_ID = ? and GROUP_ID = ? ";

public static final String MOVE_USER_GROUP_ASSOCIATION_DETAILS_TO_HISTOTRY=" insert into ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION_HISTORY(ID,USER_ID,GROUP_ID,SYSTEM_ID,INSERTED_TIME,DISASSOCIATED_BY,DISASSOCIATED_TIME,ASSOCIATED_BY) " 
																+ " select ID,USER_ID,GROUP_ID,SYSTEM_ID,INSERTED_TIME,?,getutcdate(),ASSOCIATED_BY from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION "
																+ " where SYSTEM_ID=? and GROUP_ID=? ";

public static final String DELETE_USER_GROUP_ASSOCIATION_DETAILS = " Delete from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION where SYSTEM_ID = ? and GROUP_ID = ? ";

public static final String DELETE_VEHICLE_USER_DETAILS = " Delete from AMS.dbo.Vehicle_User where System_id=? and User_id=? and Registration_no in (select REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT where SYSTEM_ID=? and CLIENT_ID=? and GROUP_ID=?) ";

/**************************************************************************************************************************************************
 * 														Product Features Statement
 **************************************************************************************************************************************************/


/**
 * get product MANDATORY process from PRODUCT_PROCESS
 */
public static final String GET_PRODUCT_MANDATORY_PROCESS="select PROCESS_ID,PROCESS_LABEL_ID from dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Mand_Package' "+
												" and PROCESS_ID in (select distinct(PROCESS_ID) from dbo.MENU_MASTER a "+
												" inner join dbo.PRODUCT_ELEMENT b on a.ELEMENT_ID=b.ELEMENT_ID "+
												" inner join AMS.dbo.menu_item_master c on c.program_name=b.ELEMENT_NAME collate database_default and system_id=?) "+
												" order by ORDER_OF_DISPLAY asc ";

/**
 * get product VERTICAL process from PRODUCT_PROCESS
 */
public static final String GET_PRODUCT_VERTICAL_PROCESS="select PROCESS_ID,PROCESS_LABEL_ID from dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Vertical_Sol' "+
												" and PROCESS_ID in (select distinct(PROCESS_ID) from dbo.MENU_MASTER a "+
												" inner join dbo.PRODUCT_ELEMENT b on a.ELEMENT_ID=b.ELEMENT_ID "+
												" inner join AMS.dbo.menu_item_master c on c.program_name=b.ELEMENT_NAME collate database_default and system_id=?) "+
												" order by ORDER_OF_DISPLAY asc ";

/**
 * get product ADD ON process from PRODUCT_PROCESS
 */
public static final String GET_PRODUCT_ADD_ON_PROCESS="select PROCESS_ID,PROCESS_LABEL_ID from dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Add_On_Pkg' "+
												" and PROCESS_ID in (select distinct(PROCESS_ID) from dbo.MENU_MASTER a "+
												" inner join dbo.PRODUCT_ELEMENT b on a.ELEMENT_ID=b.ELEMENT_ID "+
												" inner join AMS.dbo.menu_item_master c on c.program_name=b.ELEMENT_NAME collate database_default and system_id=?) "+
												" order by ORDER_OF_DISPLAY asc ";

/**
 * GET PRODUCT PROCESS DETAILS
 */
public static final String GET_PRODUCT_PROCESS_DETAILS=" select isnull(s.SUB_PROCESS_LABEL_ID,'') as SUB_PROCESS_LABEL_ID,MENU_LABEL_ID  from dbo.MENU_MASTER m "+
													" left outer join dbo.SUB_PROCESS s on s.SUB_PROCESS_ID=m.SUB_PROCESS_ID and s.PROCESS_ID=m.PROCESS_ID "+
													" where m.PROCESS_ID=? order by s.PROCESS_ID,s.SUB_PROCESS_ID,m.ORDER_OF_DISPLAY asc ";

public static final String GET_CUSTOMER_PROCESS_ASSOCIATION="select PROCESS_ID from dbo.CUSTOMER_PROCESS_ASSOC where CUSTOMER_ID=? and SYSTEM_ID=? order by PROCESS_ID asc ";

public static final String GET_GROUP_PROCESS_ASSOCIATION="select PROCESS_ID from dbo.ASSET_GROUP_PROCESS where GROUP_ID=? and SYSTEM_ID=? order by PROCESS_ID asc ";

public static final String GET_PRODUCT_MANDATORY_PROCESS_FOR_CUSTOMER="select PROCESS_ID,PROCESS_LABEL_ID from dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Mand_Package' "+
												" and PROCESS_ID in (select PROCESS_ID from dbo.CUSTOMER_PROCESS_ASSOC where CUSTOMER_ID=? and SYSTEM_ID=?) "+
												" and PROCESS_ID in (select distinct(PROCESS_ID) from dbo.MENU_MASTER a "+
												" inner join dbo.PRODUCT_ELEMENT b on a.ELEMENT_ID=b.ELEMENT_ID  "+
												" inner join AMS.dbo.menu_item_master c on c.program_name=b.ELEMENT_NAME collate database_default and system_id=?) ";				

public static final String GET_PRODUCT_VERTICAL_PROCESS_FOR_CUSTOMER="select PROCESS_ID,PROCESS_LABEL_ID from dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Vertical_Sol' "+
" and PROCESS_ID in (select PROCESS_ID from dbo.CUSTOMER_PROCESS_ASSOC where CUSTOMER_ID=? and SYSTEM_ID=?) "+				
" and PROCESS_ID in (select distinct(PROCESS_ID) from dbo.MENU_MASTER a "+
" inner join dbo.PRODUCT_ELEMENT b on a.ELEMENT_ID=b.ELEMENT_ID "+
" inner join AMS.dbo.menu_item_master c on c.program_name=b.ELEMENT_NAME collate database_default and system_id=?) ";	

public static final String GET_PRODUCT_ADDON_PROCESS_FOR_CUSTOMER="select PROCESS_ID,PROCESS_LABEL_ID from dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Add_On_Pkg' "+
" and PROCESS_ID in (select PROCESS_ID from dbo.CUSTOMER_PROCESS_ASSOC where CUSTOMER_ID=? and SYSTEM_ID=?) "+
" and PROCESS_ID in (select distinct(PROCESS_ID) from dbo.MENU_MASTER a "+
" inner join dbo.PRODUCT_ELEMENT b on a.ELEMENT_ID=b.ELEMENT_ID "+
" inner join AMS.dbo.menu_item_master c on c.program_name=b.ELEMENT_NAME collate database_default and system_id=?) ";	

public static final String GET_ESS_PROCESS_ID="select PROCESS_ID from dbo.PRODUCT_PROCESS  where PROCESS_LABEL_ID in ('Ess_Montr') ";

public static final String GET_ESS_ADV_PROCESS_ID="select PROCESS_ID from dbo.PRODUCT_PROCESS  where PROCESS_LABEL_ID in ('Ess_Montr','Adv_Montr') order by PROCESS_ID asc ";

public static final String DELETE_UNCHECKED_PROCESS_FOR_CUSTOMER="delete from dbo.CUSTOMER_PROCESS_ASSOC where PROCESS_ID=? and CUSTOMER_ID=? and SYSTEM_ID=?";

public static final String UPDATE_UNCHECKED_PROCESS_DATA_FOR_CLIENT="update CUSTOMER_MASTER set RESTRICTIVE_MOMENT_START=0,RESTRICTIVE_MOMENT_END=0,RESTRICTIVE_MOMENT_DISTANCE=0,AC_IDLE_TIME_ALERT=0,NEARTO_BOARDER_DISTANCE=0,SEAT_BELT_INTERVAL=0,PAYMENT_DUE_DATE=null,PAYMENT_NOTIFICATION_PERIOD=0 where CUSTOMER_ID=? and SYSTEM_ID=? ";
public static final String UPDATE_UNCHECKED_PROCESS_DATA_FOR_AMS_CLIENT="update AMS.dbo.tblCustomerMaster set acIdleTimeAlert=0,NearToBorderDist=0,SeatBeltAlertIntervalCli=0,PaymentNotificationPeriod=0,Expiry_date=null,NightEyeStart=0,NightEyeEnd=0,NightEyeDistance=0 where CustomerId=? and System_id=? ";
public static final String UPDATE_UNCHECKED_PROCESS_DATA_FOR_CLIENT_MILK_DIS="update CUSTOMER_MASTER set MIN_TEMPERATURE=0,MAX_TEMPERATURE=0 where CUSTOMER_ID=? and SYSTEM_ID=? ";
public static final String UPDATE_UNCHECKED_PROCESS_DATA_FOR_AMS_CLIENT_MILK="update AMS.dbo.tblCustomerMaster set MinTempLimitCli=0,MaxTempLimitCli=0 where CustomerId=? and System_id=? ";

public static final String UPDATE_UNCHECKED_PROCESS_DATA_FOR_CLIENT_HEALTH_SAFETY="update CUSTOMER_MASTER set OS_LIMIT_GRADED=0,OS_LIMIT_BLACKTOP=0 where CUSTOMER_ID=? and SYSTEM_ID=? ";
public static final String UPDATE_UNCHECKED_PROCESS_DATA_FOR_AMS_CLIENT_HEALTH_SAFETY="update AMS.dbo.tblCustomerMaster set OverSpeedLimit=0,OverSpeedLimitforGRCli=0 where CustomerId=? and System_id=? ";


public static final String DELETE_UNCHECKED_PROCESS_FOR_GROUP="delete from dbo.ASSET_GROUP_PROCESS where PROCESS_ID=? and GROUP_ID in (select GROUP_ID from dbo.ASSET_GROUP where "+ 
											" CUSTOMER_ID=? and SYSTEM_ID=?) and SYSTEM_ID=? ";			

public static final String CHECK_CUST_PROCESS_ASS_EXIST="select PROCESS_ID from dbo.CUSTOMER_PROCESS_ASSOC where PROCESS_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? ";

public static final String SAVE_CUSTOMER_PROCESS_ASSOCIATION="insert into dbo.CUSTOMER_PROCESS_ASSOC(CUSTOMER_ID,PROCESS_ID,SYSTEM_ID,CREATED_BY) values(?,?,?,?) ";

public static final String UPDATE_CUSTOMER_ACTIVATION_STATUS="update dbo.CUSTOMER_MASTER set ACTIVATION_STATUS='Complete' where CUSTOMER_ID=? and SYSTEM_ID=?";

public static final String DELETE_GROUP_PROCESS_ASS_EXIST="delete from dbo.ASSET_GROUP_PROCESS where GROUP_ID=? and SYSTEM_ID=? "+
		" and PROCESS_ID in (select PROCESS_ID from dbo.PRODUCT_PROCESS  where PROCESS_LABEL_ID<>'Ess_Montr' and PROCESS_TYPE_LABEL_ID=?)";

public static final String CHECK_GROUP_PROCESS_ASS_EXIST="select PROCESS_ID from dbo.ASSET_GROUP_PROCESS where PROCESS_ID=? and GROUP_ID=? and SYSTEM_ID=?";

public static final String SAVE_GROUP_PROCESS_ASSOCIATION="insert into dbo.ASSET_GROUP_PROCESS(GROUP_ID,SYSTEM_ID,PROCESS_ID,CREATED_BY) values(?,?,?,?)";

public static final String UPDATE_ASSET_GROUP_STATUS="update dbo.ASSET_GROUP set ACTIVATION_STATUS='Complete' where GROUP_ID=? and CUSTOMER_ID=? and SYSTEM_ID=?";


public static final String GET_DEFAULT_GROUP="select a.GROUP_ID from dbo.ASSET_GROUP a inner join dbo.CUSTOMER_MASTER c on a.GROUP_NAME=c.NAME and a.CUSTOMER_ID=c.CUSTOMER_ID and a.SYSTEM_ID=c.SYSTEM_ID where a.CUSTOMER_ID=? and a.SYSTEM_ID=?";
public static final String INSERT_DEFAULT_ASSET_PROCESS="insert into dbo.ASSET_GROUP_PROCESS(GROUP_ID,SYSTEM_ID,PROCESS_ID,CREATED_TIME,CREATED_BY)values(?,?,?,getutcdate(),?)";

public static final String INSERT_INTO_EMAIL_QUEUE="insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,SystemId) values (?,?,?,?)";

public static final String GET_PROCESS_NAME_FOR_ID="select b.LANG_ENGLISH from ADMINISTRATOR.dbo.PRODUCT_PROCESS a "+
								" inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b on a.PROCESS_LABEL_ID=b.LABEL_ID "+
								" where a.PROCESS_ID=? ";

public static final String GET_MAIL_IDS ="select EMAIL_ID from CRC.dbo.BUSINESS_GROUP_USERS where BUSINESS_GROUP_ID=?";

/**************************************************************END*************************************************************************************************************************************
	/**
	 * Delete a record in dbo.USERS table with user details
	 */
	public static final String DeleteUserDetailsAMS = "delete from dbo.USERS where CUSTOMER_ID=? and USER_ID=? and SYSTEM_ID=?";
    
	public static final String Delete_USER_PROCESS_DETACHMENT="delete from dbo.USER_PROCESS_DETACHMENT where USER_ID=? and SYSTEM_ID=?";
	
	public static final String Delete_USER_GROUP="delete from AMS.dbo.User_Group where User_id=? and System_id=?";
	
	public static final String Delete_VEHICLE_USER="delete from AMS.dbo.Vehicle_User where User_id=? and System_id=?";
	
	public static final String DELETE_USER_ASSET_GROUP_ASSOCIATION=" delete from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION where USER_ID=? and SYSTEM_ID=? ";
	
/******************************************************************END*******************************************************************************/
	
	public static final String GET_ASSET_TYPE="select Category_code,Category_name from AMS.dbo.Vehicle_Category_Master order by Category_code";
	
	
	public static final String GET_UNIT_NUMBERS="select a.Unit_number,a.Unit_imei,b.Unit_type_desc,c.Manufacture_name from Unit_Master a "
												+ " left outer join dbo.Unit_Type_Master b on a.Unit_type_code=b.Unit_type_code "
												+ " left outer join dbo.Unit_Manufacture_Master c on a.Manufacture_code=c.Manufacture_id "
												+ " where a.System_id=? ";
	
	
	public static final String SELECT_GROUP_LIST="select GROUP_ID,GROUP_NAME from AMS.dbo.VEHICLE_GROUP (NOLOCK) where SYSTEM_ID = ? and CLIENT_ID = ?";
	
	/****************************************************************************unitDetails************************************************************************/
	public static final String SELECT_MANUFACTURE_CODE ="select isnull(MANUFACTURE_ID,'')as MANUFACTURE_ID,isnull(MANUFACTURE_NAME,'')as MANUFACTURE_NAME from ADMINISTRATOR.dbo.UNIT_MANUFACTURE order by MANUFACTURE_NAME";
	
	public static final String SELECT_UNIT_TYPE_CODE_FROM_MANUFACTURE = "SELECT UNIT_TYPE_CODE,UNIT_NAME from ADMINISTRATOR.dbo.UNIT_TYPE where MANUFACTURE_ID =? order by UNIT_NAME";
	
	public static final String SELECT_UNIT_TYPE_CODE_ALL = "SELECT UNIT_TYPE_CODE,UNIT_NAME from ADMINISTRATOR.dbo.UNIT_TYPE order by UNIT_NAME";
	
	public static final String GET_ALL_UNITS_DETAILS="select isnull(a.UNIT_NUMBER,'') as 'UNIT_NO',a.MANUFACTURE_ID as manufactureId ,a.UNIT_TYPE_CODE as unitTypeid ,b.MANUFACTURE_NAME as 'Manufacturer',c.UNIT_NAME as 'Unit_Type',isnull(a.UNIT_REFERENCE_ID,'') as 'Unit_Reference_Id',dateadd(mi,?,a.CREATED_TIME) as 'last_Created_date_and_Time',a.STATUS as 'STATUS',isnull(a.MOBILE_NUMBER,'') as 'PREDEFINED_MOBILE_NO',isnull(a.TRANSPARENT_MODE,0) as TRANSPARENT_MODE, isnull(a.IMSI,'') as IMSI  from ADMINISTRATOR.dbo.UNIT_MASTER a (NOLOCK) inner join ADMINISTRATOR.dbo.UNIT_MANUFACTURE b (NOLOCK) on a.MANUFACTURE_ID=b.MANUFACTURE_ID inner join ADMINISTRATOR.dbo.UNIT_TYPE c (NOLOCK) on a.UNIT_TYPE_CODE=c.UNIT_TYPE_CODE where a.SYSTEM_ID=?";
	
	public static final String SELECT_UNIT_NUMBER_VALIDATE = "SELECT UNIT_NUMBER from ADMINISTRATOR.dbo.UNIT_MASTER where UNIT_NUMBER=?";
	
	public static final String SELECT_UNIT_REFERENCE_ID_VALIDATE = "SELECT UNIT_REFERENCE_ID from ADMINISTRATOR.dbo.UNIT_MASTER where UNIT_REFERENCE_ID=?";
	
	public static final String UNIT_REFERENCE_ID_VALIDATE_UPDATE = "SELECT UNIT_REFERENCE_ID from ADMINISTRATOR.dbo.UNIT_MASTER where UNIT_REFERENCE_ID=? and UNIT_NUMBER!=?";
	
	public static final String UNIT_INSERT="INSERT INTO AMS.dbo.Unit_Master(Unit_number,Manufacture_code,Unit_type_code,Unit_imei,Last_downloaded_date,System_id) VALUES (?,?,?,?,getutcdate(),?)";
	
	public static final String UNIT_INSERT_INTO_ADMIN_UNIT ="INSERT INTO ADMINISTRATOR.dbo.UNIT_MASTER(UNIT_NUMBER,MANUFACTURE_ID,UNIT_TYPE_CODE,UNIT_REFERENCE_ID,CREATED_TIME,CREATED_BY,STATUS,SYSTEM_ID,PREDEFINED_MOBILE_NO,TRANSPARENT_MODE) VALUES(?,?,?,?,getutcdate(),?,?,?,?,?)";
	
	public static final String UPDATE_UNIT_DETAILS_ADMINSTRATOR = "UPDATE ADMINISTRATOR.dbo.UNIT_MASTER SET MANUFACTURE_ID=?,UNIT_TYPE_CODE=?,UNIT_REFERENCE_ID=?,STATUS=?,PREDEFINED_MOBILE_NO=?,TRANSPARENT_MODE=? WHERE UNIT_NUMBER=? and SYSTEM_ID=?";
	
	public static final String UPDATE_UNIT_DETAILS_AMS="UPDATE AMS.dbo.Unit_Master SET Manufacture_code=?,Unit_type_code=?,Unit_imei=? WHERE Unit_number=? and System_id=?";
	
	public static final String SELECT_UNIT_NUMBER_IN_UNIT_MASTER="select MOBILE_NUMBER from ADMINISTRATOR.dbo.UNIT_MASTER where UNIT_NUMBER=? and SYSTEM_ID=? and MOBILE_NUMBER is not null and MOBILE_NUMBER<>'' ";

	
	public static final String GET_UNIT_TYPE_CODE = "SELECT UNIT_TYPE_CODE from ADMINISTRATOR.dbo.UNIT_MASTER where UNIT_NUMBER=? and SYSTEM_ID =?";
	
	public static final String CKECK_UNIT_VEHICLE_ASSOC = "SELECT Unit_Number from AMS.dbo.Vehicle_association where Unit_Number=? and System_id=?";
	
	public static final String DELETE_UNIT = "DELETE FROM AMS.dbo.Unit_Master where Unit_number=? ";
	
	public static final String DELETE_UNIT_FROM_ADMINSDB = "DELETE FROM ADMINISTRATOR.dbo.UNIT_MASTER where UNIT_NUMBER=? ";
	
	public static final String UPDATE_UNIT_TYPE_TO_VEHICLE_ASSOCIATION="update AMS.dbo.Vehicle_association set Unit_Type_Code=? where Unit_Number =? and System_id=?";
	
	public static final String SELECT_UNIT_NUMBER_VALIDATE_IN_UNIT="select MOBILE_NUMBER from ADMINISTRATOR.dbo.UNIT_MASTER where UNIT_NUMBER=? and SYSTEM_ID=? and MOBILE_NUMBER is not null and MOBILE_NUMBER<>'' ";
	
	public static final String IS_UNIT_REGISTERED="select Unit_Number from Vehicle_association where Unit_Number=? and System_id=?";
	
	/*******************************************************sim Details*********************************************************/
	
	public static final String GET_ALL_SIM_DETAILS = "select isnull(MOBILE_NUMBER,'') as 'mobile_no',isnull(SERVICE_PROVIDER_NAME,'') as 'service_provider',isnull(CREATED_DATE,'') AS 'created_date',isnull(SIM_NUMBER,'') as 'Sim_Number',isnull(STATUS,'') as 'STATUS',dateadd(mi,?,VALIDITY_START) as VALIDITY_START,dateadd(mi,?,VALIDITY_END) as VALIDITY_END from ADMINISTRATOR.dbo.SIM_MASTER where SYSTEM_ID=? order by 'created_date' desc";
	
	public static final String SELECT_MOBILE_NO_VALIDATE = "SELECT MOBILE_NUMBER from ADMINISTRATOR.dbo.SIM_MASTER where MOBILE_NUMBER=?"; 
	
	public static final String INSERT_SIM_ADMINSTRATOR="INSERT INTO ADMINISTRATOR.dbo.SIM_MASTER(MOBILE_NUMBER,SERVICE_PROVIDER_NAME,CREATED_BY,SYSTEM_ID,SIM_NUMBER,STATUS,VALIDITY_START,VALIDITY_END,CREATED_DATE)VALUES (?,?,?,?,?,?,dateadd(mi,-?,?),dateadd(mi,-?,?),getutcdate())";
	
	public static final String UPDATE_SIM_DETAILS_ADMINSTRATOR="UPDATE ADMINISTRATOR.dbo.SIM_MASTER SET SERVICE_PROVIDER_NAME=?,SIM_NUMBER=?,STATUS=?,VALIDITY_START=dateadd(mi,-?,?),VALIDITY_END=dateadd(mi,-?,?) WHERE MOBILE_NUMBER=? and SYSTEM_ID=?";
	
	public static final String SELECT_MOBILE_NO_VALIDATE_IN_UNIT = "SELECT UNIT_NUMBER as Unit_number from ADMINISTRATOR.dbo.UNIT_MASTER where MOBILE_NUMBER=? and SYSTEM_ID=?";
	
	public static final String DELETE_MOBILENO_IN_ADMINSTRATOR ="DELETE FROM ADMINISTRATOR.dbo.SIM_MASTER WHERE MOBILE_NUMBER=? ";
	
	
	public static final String DELETE_UPLOADED_FILE = "delete  from  dbo.DOCUMENT_STORAGE_DETAILS where VALUE=? and SYSTEM_ID=? and " +
	                                                  "CUSTOMER_ID=? and FILE_NAME=? and CATEGORY=? and ID=?";
	
	
	
	public static final String GET_ALL_VEHICLES_DETAILS =  " select VehicleNo as 'REGISTRATION_NO',Model as 'Asset_Model',VehicleType as 'Asset_Type' from AMS.dbo.tblVehicleMaster tv "+
														   " left outer join AMS.dbo.VEHICLE_CLIENT vc on tv.System_id=vc.SYSTEM_ID and tv.VehicleNo=vc.REGISTRATION_NUMBER "+  
														   " left outer join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on cm.SYSTEM_ID=vc.SYSTEM_ID and cm.CUSTOMER_ID=vc.CLIENT_ID "+
														   " left outer join FMS.dbo.Vehicle_Model p on vc.CLIENT_ID=p.ClientId and tv.System_id=p.SystemId and p.ModelTypeId=tv.Model "+ 
														   " inner join AMS.dbo.Vehicle_User vu on vu.System_id = vc.SYSTEM_ID and vu.Registration_no=vc.REGISTRATION_NUMBER "+
														   " where tv.System_id=? and cm.CUSTOMER_ID=? and vu.User_id=? ";
	
	
	//********************************************USER GROUP ASSET QUERIES****************************************************************************************************************//	
		
		public static final String GET_USERS=" select USER_ID, isnull(FIRST_NAME,'')+' '+isnull(LAST_NAME,'') as User_Name from ADMINISTRATOR.dbo.USERS (NOLOCK) where CUSTOMER_ID=? and SYSTEM_ID=? and STATUS='Active' ";

		
		public static final String GET_ASSOCIATION_DATA=" select c.GROUP_NAME,c.GROUP_ID,e.NAME as CUSTOMER_NAME,e.CUSTOMER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION a "
														+ " inner join ADMINISTRATOR.dbo.ASSET_GROUP c (NOLOCK) on c.SYSTEM_ID=a.SYSTEM_ID and a.GROUP_ID=c.GROUP_ID " 
														+ " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER e (NOLOCK) on e.CUSTOMER_ID=c.CUSTOMER_ID and e.SYSTEM_ID=a.SYSTEM_ID "  
														+ " where a.USER_ID=? and a.SYSTEM_ID=? and c.CUSTOMER_ID=? and c.ACTIVATION_STATUS='Complete' order by c.GROUP_NAME ";
		
		public static final String GET_NON_ASSOCIATION_DATA=" select f.GROUP_NAME,f.GROUP_ID,e.NAME as CUSTOMER_NAME,e.CUSTOMER_ID "   
														+ " from ADMINISTRATOR.dbo.ASSET_GROUP f (NOLOCK) "  
														+ " left outer join ADMINISTRATOR.dbo.CUSTOMER_MASTER e (NOLOCK) on e.CUSTOMER_ID=f.CUSTOMER_ID and e.SYSTEM_ID=f.SYSTEM_ID "   
														+ " where f.CUSTOMER_ID=? and f.SYSTEM_ID=? and f.ACTIVATION_STATUS='Complete' "   
														+ " and GROUP_ID not in (select GROUP_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) " 
														+ " order by f.GROUP_NAME " ;
		
		
		public static final String GET_ASSOCIATION_DATA_FOR_LTSP_USERS =" select c.GROUP_NAME,c.GROUP_ID,e.NAME as CUSTOMER_NAME,e.CUSTOMER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION a "
															+ " inner join ADMINISTRATOR.dbo.ASSET_GROUP c (NOLOCK) on c.SYSTEM_ID=a.SYSTEM_ID and a.GROUP_ID=c.GROUP_ID " 
															+ " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER e (NOLOCK) on e.CUSTOMER_ID=c.CUSTOMER_ID and e.SYSTEM_ID=a.SYSTEM_ID "  
															+ " where a.USER_ID=? and a.SYSTEM_ID=? and c.ACTIVATION_STATUS='Complete' order by e.NAME,c.GROUP_NAME " ;
		
		public static final String GET_NON_ASSOCIATION_DATA_FOR_LTSP_USERS=" select f.GROUP_NAME,f.GROUP_ID,e.NAME as CUSTOMER_NAME,e.CUSTOMER_ID "   
															+ " from ADMINISTRATOR.dbo.ASSET_GROUP f (NOLOCK) "   
															+ " left outer join ADMINISTRATOR.dbo.CUSTOMER_MASTER e (NOLOCK) on e.CUSTOMER_ID=f.CUSTOMER_ID and e.SYSTEM_ID=f.SYSTEM_ID "   
															+ " where f.SYSTEM_ID=? and f.ACTIVATION_STATUS='Complete' "   
															+ " and GROUP_ID not in (select GROUP_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) "  
															+ " order by e.NAME,f.GROUP_NAME " ; 
		
		public static final String INSERT_VEHICLES_TO_INTO_VEHICLE_USER_FOR_LTSP =" insert into AMS.dbo.Vehicle_User select REGISTRATION_NUMBER,#,getutcdate() from AMS.dbo.VEHICLE_CLIENT (NOLOCK) " 
																		+ " where SYSTEM_ID=? and CLIENT_ID=? and GROUP_ID=? " 
																		+ " and REGISTRATION_NUMBER not in (select Registration_no from AMS.dbo.Vehicle_User where User_id=? and System_id=?) "; 

		public static final String INSERT_VEHICLES_TO_INTO_VEHICLE_USER_FOR_CLIENT_USERS=" insert into AMS.dbo.Vehicle_User select REGISTRATION_NUMBER,#,getutcdate() from AMS.dbo.VEHICLE_CLIENT (NOLOCK) a "
																		+ " inner join AMS.dbo.tblVehicleMaster (NOLOCK) b on b.VehicleNo=a.REGISTRATION_NUMBER and b.System_id=a.SYSTEM_ID "
																		+ " where a.SYSTEM_ID=? and a.CLIENT_ID=? and a.GROUP_ID=? and b.Status='Active' "
																		+ " and a.REGISTRATION_NUMBER not in (select Registration_no from AMS.dbo.Vehicle_User where User_id=? and System_id=?) ";  
		
		public static final String MOVE_DATA_FROM_VEHICLE_USER_TO_VEHICLE_USER_HISTORY=" insert into AMS.dbo.Vehicle_User_Hist select * from AMS.dbo.Vehicle_User where Registration_no in (select REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT where GROUP_ID=? and CLIENT_ID=? and SYSTEM_ID=?) and User_id=? and System_id=? ";
		
		public static final String DELETE_DATA_FROM_VEHICLE_USERS=" delete from AMS.dbo.Vehicle_User where Registration_no in (select REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT where GROUP_ID=? and CLIENT_ID=? and SYSTEM_ID=?) and User_id=? and System_id=? ";

		public static final String CHECK_IF_PRESENT=" select * from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION where USER_ID=? and GROUP_ID=? and SYSTEM_ID=? ";
		
		public static final String INSERT_INTO_USER_ASSET_GROUP_ASSOCIATION=" insert into ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION(USER_ID,GROUP_ID,SYSTEM_ID,INSERTED_TIME,ASSOCIATED_BY) values (?,?,?,getutcdate(),?) ";
		
		public static final String DELETE_FROM_USER_ASSET_GROUP_ASSOCIATION="delete from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION where USER_ID=? and GROUP_ID=? and SYSTEM_ID=?";
		
		
		public static final String MOVE_DATA_TO_USER_ASSET_GROUP_ASSOCIATION_HISTORY=" insert into ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION_HISTORY(ID,USER_ID,GROUP_ID,SYSTEM_ID,INSERTED_TIME,DISASSOCIATED_BY,DISASSOCIATED_TIME,ASSOCIATED_BY) "
								+ " select ID,USER_ID,GROUP_ID,SYSTEM_ID,INSERTED_TIME,?,getutcdate(),ASSOCIATED_BY from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION "
								+ " where USER_ID=? and GROUP_ID=? and SYSTEM_ID=? ";
		
		
		public static final String DELETE_ALERT_USER_ASSOC="delete from AMS.dbo.Alert_User_Assoc where UserId=? and SystemId=?";
		
		public static final String USER_REPORT_SCHEDULAR_ASSOC="delete from AMS.dbo.UserReportSchedularAssoc where UserId=? and SystemId=? and ClientId=?";

		public static final String DELETE_CLIENT_SMS_NUMBER="delete from SMS.dbo.CLIENT_ALERT_SMS_NUMBERS where USER_ID=? and SYSTEM_ID=?";
//******************************************************OWNER MASTER STATEMANTS*****************************************************************************************************//
			
			public static final String GET_OWNER_MASTER_REPORT=" select (isnull(FIRST_NAME,'')+' '+isnull(LAST_NAME,'')) as OWNERNAME,isnull(LAST_NAME,'') as LASTNAME,isnull(FIRST_NAME,'') as FirstName,isnull(ADDRESS,'') as ADDRESS, "
																+ " isnull(EMAIL_ID,'') as EMAILID,isnull(MOBILE_NO,'') as PHONENO,isnull(LANDLINE_NO,'') as LANDLINENO, "
																+ " isnull(OWNER_ID,'') as ID from ADMINISTRATOR.dbo.OWNER_MASTER(NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? ";
			
			public static final String INSERT_OWNER_INFORMATION=" insert into ADMINISTRATOR.dbo.OWNER_MASTER(FIRST_NAME,LAST_NAME,ADDRESS,EMAIL_ID,MOBILE_NO,LANDLINE_NO,SYSTEM_ID,CUSTOMER_ID,CREATED_BY,CREATED_DATE) "
				                                                + " values(?,?,?,?,?,?,?,?,?,getutcDate()) ";
				
			public static final String UPDATE_OWNER_INFORMATION=" update ADMINISTRATOR.dbo.OWNER_MASTER set FIRST_NAME=?,LAST_NAME=?,ADDRESS=?,EMAIL_ID=?, "
                                                				+ " MOBILE_NO=?,LANDLINE_NO=? where CUSTOMER_ID=? and SYSTEM_ID=? and OWNER_ID=? ";
			
			public static final String DELETE_OWNER_INFORMATION="delete from ADMINISTRATOR.dbo.OWNER_MASTER where CUSTOMER_ID=? and SYSTEM_ID=? and OWNER_ID=? ";
			
			
			public static final String CHECK_IF_OWNER_ID_EXIST_IN_VEHICLE_MASTER=" select VehicleNo,OwnerName,OwnerAddress,OwnerContactNo,OWNER_ID from AMS.dbo.tblVehicleMaster c (NOLOCK) where System_id=? and OWNER_ID=? ";
			
			
			public static final String UPDATE_IN_VEHICLE_MASTER=" update AMS.dbo.tblVehicleMaster set OwnerName='',OwnerAddress='',OwnerContactNo='',OWNER_ID=0 where OWNER_ID=? and System_id=? ";
			
			
			public static final String UPDATE_DETAILS_IN_VEHICLE_MASTER=" update AMS.dbo.tblVehicleMaster set OwnerName=?,OwnerAddress=?,OwnerContactNo=? where OWNER_ID=? and System_id=? ";
			
			public static final String UPDATE_DETAILS_IN_LIVE_VISION= " update AMS.dbo.Live_Vision_Support set OWNER_NAME=? where SYSTEM_ID=? and " 
                                 + " REGISTRATION_NO in ( select VehicleNo from AMS.dbo.tblVehicleMaster where System_id=? and OWNER_ID=?) ";
		
//******************************************************MANAGE ASSET STATEMANTS*****************************************************************************************************//
		
			public static final String GET_ASSET_TYPE_FOR_MANAGE_ASSET="select Category_code,Category_name from AMS.dbo.Vehicle_Category_Master (NOLOCK) order by Category_code";
			
			public static final String GET_ASSET_MODEL_NAMES="select isnull(ModelName,'') as ModelName,isnull(ModelTypeId,0) as ModelTypeId from  FMS.dbo.Vehicle_Model (NOLOCK) where  SystemId=?";

			public static final String GET_UNIT_NUMBERS_FOR_MANAGE_ASSET=" select a.UNIT_NUMBER,a.UNIT_REFERENCE_ID,isnull(b.UNIT_NAME,'') as Unit_type_desc,isnull(c.MANUFACTURE_NAME,'') as Manufacture_name,a.MANUFACTURE_ID as MANUFACTURE_ID from ADMINISTRATOR.dbo.UNIT_MASTER (NOLOCK) a "
												+ " left outer join ADMINISTRATOR.dbo.UNIT_TYPE (NOLOCK) b on a.UNIT_TYPE_CODE=b.UNIT_TYPE_CODE " 
												+ " left outer join ADMINISTRATOR.dbo.UNIT_MANUFACTURE (NOLOCK) c on a.MANUFACTURE_ID=c.MANUFACTURE_ID "
												+ " where a.SYSTEM_ID=? and a.STATUS='ACTIVE' and UNIT_NUMBER collate database_default not in "
												+ " (select Unit_Number from AMS.dbo.Vehicle_association (NOLOCK) where System_id=?)";

			public static final String GET_MOBILE_NUMBERS_FOR_MANAGE_ASSET=" select isnull(MOBILE_NUMBER,'') as MOBILE_NUMBER ,isnull(SIM_NUMBER,'') as SIM_NUMBER,isnull(SERVICE_PROVIDER_NAME,'') as SERVICE_PROVIDER_NAME,CASE WHEN "
												+ " MOBILE_NUMBER in   (select PREDEFINED_MOBILE_NO from ADMINISTRATOR.dbo.UNIT_MASTER(NOLOCK) where SYSTEM_ID=? and PREDEFINED_MOBILE_NO is not null) "
												+ " THEN 'Yes' ELSE 'No'  END as IS_PREDEFINED from ADMINISTRATOR.dbo.SIM_MASTER (NOLOCK) where MOBILE_NUMBER not in "
												+ " (select MOBILE_NUMBER from ADMINISTRATOR.dbo.UNIT_MASTER(NOLOCK) where SYSTEM_ID=? and MOBILE_NUMBER is not null) "
												+ " and SYSTEM_ID=? and STATUS='ACTIVE' "; 
			
			public static final String GET_MOBILE_NUMBERS_FOR_UNIT_DETAILS=" select isnull(MOBILE_NUMBER,'') as MOBILE_NUMBER ,isnull(SIM_NUMBER,'') as SIM_NUMBER,isnull(SERVICE_PROVIDER_NAME,'') as SERVICE_PROVIDER_NAME " 
				+ " from ADMINISTRATOR.dbo.SIM_MASTER (NOLOCK) where MOBILE_NUMBER not in (select MOBILE_NUMBER from ADMINISTRATOR.dbo.UNIT_MASTER(NOLOCK) where SYSTEM_ID=? and MOBILE_NUMBER is not null) "
				+ " and MOBILE_NUMBER not in (select PREDEFINED_MOBILE_NO from ADMINISTRATOR.dbo.UNIT_MASTER(NOLOCK) where SYSTEM_ID=? and PREDEFINED_MOBILE_NO is not null and PREDEFINED_MOBILE_NO!='') "
				+ " and SYSTEM_ID=? and STATUS='ACTIVE' "; 
			
			public static final String GET_MOBILE_NUMBERS_FOR_MANAGE_ASSET_CLA=" select isnull(MOBILE_NUMBER,'') as MOBILE_NUMBER ,isnull(SIM_NUMBER,'') as SIM_NUMBER,isnull(SERVICE_PROVIDER_NAME,'') as SERVICE_PROVIDER_NAME from ADMINISTRATOR.dbo.SIM_MASTER (NOLOCK) where MOBILE_NUMBER not in "
				+ " (select MOBILE_NUMBER from ADMINISTRATOR.dbo.UNIT_MASTER(NOLOCK) where SYSTEM_ID=? and MOBILE_NUMBER is not null) "
				+ " and MOBILE_NUMBER in (select PREDEFINED_MOBILE_NO from ADMINISTRATOR.dbo.UNIT_MASTER(NOLOCK) where SYSTEM_ID=? and UNIT_NUMBER=? and PREDEFINED_MOBILE_NO is not null) and SYSTEM_ID=? and STATUS='ACTIVE'"; 
			
			public static final String SELECT_GROUP_LIST_FOR_MANAGE_ASSET ="select a.GROUP_ID,a.GROUP_NAME from ADMINISTRATOR.dbo.ASSET_GROUP a "
												+ " inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on b.SYSTEM_ID=a.SYSTEM_ID and b.GROUP_ID=a.GROUP_ID " 
												+ " where a.SYSTEM_ID=?  and a.CUSTOMER_ID=? and b.USER_ID=? ";

			public static final String GET_MANAGE_ASSET_REPORT=	" select isnull(a.RegistrationNo,'') as VehicleNo,a.RegistrationDateTime as RegistrationDateTime,(isnull(u.Firstname,'')+' '+isnull(u.Lastname,'')) as RegisteredBy, isnull(b.Unit_Number,'') as UnitNo,dateadd(mi,?,b.Date) as Date,isnull(c.VehicleType,'') as AssetType,isnull(c.OwnerName,'') as OWNER_NAME,isnull(c.OwnerAddress,'') as OWNER_ADDRESS,isnull(c.OwnerContactNo,'') as OWNER_PHONE_NO,isnull(c.VehicleAlias,'') as VehicleAlias, " 
												+ " isnull(g.ModelName,'') as Model,isnull(ModelTypeId,'') as ModelTypeId, isnull(d.MOBILE_NUMBER,'') as MobileNo,isnull(f.GROUP_NAME,'None') as GroupName,isnull(e.GROUP_ID,'') as GROUP_ID ,d.MANUFACTURE_ID as MANUFACTURE_ID "  
												+ " from AMS.dbo.VehicleRegistration (NOLOCK) a "   
												+ " left outer join AMS.dbo.Users u on a.RegisteredBy=u.User_id and a.SystemId = u.System_id "
												+ " left outer join AMS.dbo.tblVehicleMaster (NOLOCK) c on c.VehicleNo=a.RegistrationNo "   
												+ " left outer join AMS.dbo.VEHICLE_CLIENT (NOLOCK) e on e.REGISTRATION_NUMBER=a.RegistrationNo "  
												+ " left outer join AMS.dbo.Vehicle_association (NOLOCK) b on b.Registration_no=a.RegistrationNo "   
												+ " left outer join ADMINISTRATOR.dbo.UNIT_MASTER (NOLOCK) d on d.UNIT_NUMBER collate database_default=b.Unit_Number and b.System_id=d.SYSTEM_ID "
												+ " left outer join AMS.dbo.VEHICLE_GROUP f (NOLOCK) on f.GROUP_ID=e.GROUP_ID and f.SYSTEM_ID=e.SYSTEM_ID and f.CLIENT_ID=e.CLIENT_ID " 
												+ " left outer join FMS.dbo.Vehicle_Model g on g.ModeltypeId=c.Model and g.SystemId=c.System_id "
												+ " inner join AMS.dbo.Vehicle_User vu (NOLOCK) on a.RegistrationNo=vu.Registration_no and a.SystemId=vu.System_id "
												+ " where a.SystemId=? and e.CLIENT_ID=? and vu.User_id=? and a.Status='Active' and c.Status='Active' ";
					
			public static final String CHECK_IF_VEHICLE_REGISTERED_AND_STATUS_IS_ACTIVE="select isnull(RegistrationNo,'') as RegistrationNo from AMS.dbo.VehicleRegistration where Status=? and  ADMINISTRATOR.dbo.REMOVE_SPECIAL_CHARACTERS(RegistrationNo,'^a-zA-Z0-9s') = ADMINISTRATOR.dbo.REMOVE_SPECIAL_CHARACTERS(?,'^a-zA-Z0-9s') ";
			
			public static final String REGISTER_NEW_VEHICLE_IN_VEHICLE_REGISTRATION = "insert into AMS.dbo.VehicleRegistration(RegistrationNo,RegistrationDateTime,SystemId,Status,RegisteredBy) values(?,dateadd(mi,?,getUTCDate()),?,?,?)";

			public static final String CHECK_REGISTRATION_NO_IN_LIVE_SUPPORT = "select isnull(REGISTRATION_NO,'') as REGISTRATION_NO from dbo.Live_Vision_Support where REGISTRATION_NO = ? ";

			public static final String INSERT_VEHICLE_LIVE_SUPPORT = "insert into AMS.dbo.Live_Vision_Support(REGISTRATION_NO,SYSTEM_ID,GROUP_NAME,CLIENT_ID,CLIENT_NAME,OWNER_NAME,IMAGE_NAME,VEHICLE_ID,STATUS) values(?,?,?,?,?,?,?,?,'Active')";

			public static final String CHECK_IF_VEHICLE_PRESENT_IN_tblVehicleMaster = "select isnull(VehicleNo,'') as VehicleNo from AMS.dbo.tblVehicleMaster where VehicleNo=? ";

			public static final String INSERT_REGISTERED_VEHICLE_DETAILS_IN_tblVehicleMaster_IF_VEHICLE_IS_NOT_PRESENT = "insert into AMS.dbo.tblVehicleMaster(VehicleNo,VehicleType,Model,OwnerName,OwnerAddress,OwnerContactNo,VehicleAlias,System_id,UpdatedDate,OWNER_ID,NoOfContainer,Vehicle_number,OwnerEmailId) values(?,?,?,?,?,?,?,?,getUTCDate(),?,?,?,?)";

			public static final String CHECK_VEHICLE_IN_gpsdata_history_latest = "select isnull(REGISTRATION_NO,'') as REGISTRATION_NO from AMS.dbo.gpsdata_history_latest where REGISTRATION_NO=?";

			public static final String SELECT_STOP_IDLE_SPEED = "select StopIdleSpeed,CategoryTypeForBill from AMS.dbo.System_Master (NOLOCK) where System_id=?";

			public static final String INSERT_VEHICLE_IN_gpsdata_history_latest = "insert into AMS.dbo.gpsdata_history_latest(SLNO,REGISTRATION_NO,UNIT_NO,CLIENTID,GPS_DATETIME,LOCATION,System_id,GMT,OFFSET,ISLATEST,SPEED,ODOMETER,IGNITION,MESSAGE_NUMBER,Zone,SPEED_LIMIT) values(?,?,?,?,dateadd(mi,?,getUTCDate()),'No GPS Device Connected',?,getUTCDate(),?,'N','0','0','0','0',?,?)";

			public static final String INSERT_INTO_VEHICLE_ASSOCIATION = "insert into AMS.dbo.Vehicle_association(Registration_no,Date,Unit_Number,Unit_Type_Code,System_id,Client_id) values(?,getUTCdate(),?,?,?,?)";

			public static final String SELECT_CLIENT_USERS_AND_LTSPUSERS_FROM_USERS = "select User_id  from AMS.dbo.Users (NOLOCK) where System_id=? and Client_id in(?,0)";

			public static final String INSERT_INTO_VEHICLE_CLIENT = "insert into AMS.dbo.VEHICLE_CLIENT(REGISTRATION_NUMBER,CLIENT_ID,SYSTEM_ID,GROUP_ID,DATE) values(?,?,?,?,getUTCdate())";

			public static final String INSERT_INTO_VEHICLE_USER = "insert into AMS.dbo.Vehicle_User values(?,?,?,getdate())";

			public static final String SELECT_IMAGE_NAME_AND_CUST_NAME_SPEED_FROM_CUSTOMER_MASTER="select isnull(VEHICLE_IMAGE,'') as VehicleImageName,isnull(NAME,'') as CustomerName,isnull(STD_SPEED_IDLE_STOPPAGE,0) as StopIdleSpeed from ADMINISTRATOR.dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=?";
			
			public static final String SELECT_STOP_IDLE_SPEED_FROM_SYSTEM_MASTER = "select StopIdleSpeed from AMS.dbo.System_Master where System_id = ? ";
			
			public static final String UPDATE_IMAGE_NAME_IN_LIVE_VISION_SUPPORT="update AMS.dbo.Live_Vision_Support set IMAGE_NAME=? where REGISTRATION_NO=? and REGISTRATION_NO in (select isnull(VehicleNo,'') as VehicleNo from tblVehicleMaster where ImageName is null or ImageName='')";

			public static final String CHECK_VEHICLE_IS_PRESENT_IN_VEHICLE_ASSOCIATION = " select isnull(a.Unit_Number,'') as Unit_Number,isnull(a.Registration_no,'') as Registration_no,isnull(a.Date,'') as Date,isnull(a.Unit_Type_Code,0) as Unit_Type_Code,a.System_id,a.Client_id,isnull(b.MOBILE_NUMBER,'') as SIM_NUMBER " 
												+ " from AMS.dbo.Vehicle_association (NOLOCK) a "
												+ " left outer join ADMINISTRATOR.dbo.UNIT_MASTER (NOLOCK) b on a.Unit_Number=b.UNIT_NUMBER collate database_default and a.System_id=b.SYSTEM_ID "
												+ " where a.Registration_no=? "; 
					
			public static final String UPDATE_CLIENT_FROM_VEHICLE_ASSOC = " update AMS.dbo.Vehicle_association set Client_id=?,Date=getUTCdate() where Registration_no=? and System_id=? ";

			public static final String INSERT_DATA_SELECTED_FROM_VEH_ASSO_INTO_VEHICLE_ASSOCIATION_HISTORY = "insert into AMS.dbo.Vehicle_association_Hist(Registration_no,"
		                                       + "Date,Unit_Number,Unit_Type_Code,System_id,User_id,DisassociationDate,Client_id,MOBILE_NUMBER) values(?,?,?,?,?,?,getUTCDate(),?,?)";

			public static final String UPDATE_REGNO_FROM_VEHICLE_ASSOC = " update AMS.dbo.Vehicle_association set Date=getUTCdate(),Unit_Number=?,Unit_Type_Code=?,Client_id=? where Registration_no=? and System_id=? ";

			public static final String UPDATE_gpsdata_history_latest="update AMS.dbo.gpsdata_history_latest set UNIT_NO=? where  REGISTRATION_NO = ? and System_id = ?";

			public static final String CHECK_VEHICLE_IS_PRESENT_IN_VEHICLE_CLIENT=" select CLIENT_ID,isnull(GROUP_ID,0) as GROUP_ID from AMS.dbo.VEHICLE_CLIENT where REGISTRATION_NUMBER=? and SYSTEM_ID=? ";

			public static final String UPDATE_GROUP_ID_IN_VEHICLE_CLIENT=" update AMS.dbo.VEHICLE_CLIENT set GROUP_ID=? where REGISTRATION_NUMBER=? and SYSTEM_ID=? and CLIENT_ID=? ";

			public static final String UPDATE_GROUP_NAME_IN_LIVE_VISION_SUPPORT="update AMS.dbo.Live_Vision_Support set GROUP_NAME=?,OWNER_NAME=? where REGISTRATION_NO=?";

			public static final String MOVE_TO_VEHICLE_USER_HISTORY="insert into AMS.dbo.Vehicle_User_Hist select * from AMS.dbo.Vehicle_User where Registration_no=? and System_id=? ";

			public static final String DELETE_FROM_VEHICLE_USERS="delete from AMS.dbo.Vehicle_User where Registration_no=? and System_id=?";

			public static final String MOVE_RECORD_TO_VEHICLE_CLIENT_HISTORY="insert into AMS.dbo.VEHICLE_CLIENT_HISTORY(REGISTRATION_NUMBER,CLIENT_ID,SYSTEM_ID,INSERTED_DATE) Select isnull(REGISTRATION_NUMBER,'') as REGISTRATION_NUMBER,CLIENT_ID,SYSTEM_ID,isNull(DATE,'') as DATE from AMS.dbo.VEHICLE_CLIENT where REGISTRATION_NUMBER=? and CLIENT_ID=? and SYSTEM_ID=?";

			public static final String UPDATE_CLIENT_VEHICLE_ASSOCIATION=" update AMS.dbo.VEHICLE_CLIENT set CLIENT_ID=?,GROUP_ID=?,DATE=getUTCdate() where REGISTRATION_NUMBER=? and SYSTEM_ID=? ";

			public static final String UPDATE_CLIENT_ID_NAME_IN_LIVE_VISION_SUPPORT_WITHOUT_IMG="update AMS.dbo.Live_Vision_Support set CLIENT_ID=?,CLIENT_NAME=?,GROUP_NAME=?,OWNER_NAME=?,VEHICLE_ID=? where REGISTRATION_NO=?";

			public static final String UPDATE_IMG_NAME_IN_LIVE_VISION_SUPPORT=" update AMS.dbo.Live_Vision_Support set IMAGE_NAME=? where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO in (select VehicleNo from tblVehicleMaster where (ImageName is null or ImageName='') and System_id=? and VehicleNo=?) ";

			public static final String UPDATE_SPEED_IN_GPS_HISTORY_LATEST="update AMS.dbo.gpsdata_history_latest set SPEED_LIMIT=?,UNIT_NO=?,CLIENTID=? where  REGISTRATION_NO = ? and System_id = ?";

			public static final String UPDATE_REGISTER_INFORMATION_IN_tblVehicleMaster="update AMS.dbo.tblVehicleMaster set VehicleType=?,Model=?,OwnerName=?,OwnerAddress=?,OwnerContactNo=?,VehicleAlias=?,OWNER_ID=?,OwnerEmailId=? where VehicleNo=? and System_id=?";

			public static final String UPDATE_REGISTERED_VEHICLE_STATUS_TO_INACTIVE = "update AMS.dbo.VehicleRegistration set Status=?,CancellationDateTime=dateadd(mi,?,getUTCDate()),CancelledBy=?,Reason=? where RegistrationNo=? and SystemId=?";

			public static final String DELETE_VEHICLE_FROM_tblVehicleMaster = "delete from AMS.dbo.tblVehicleMaster where VehicleNo=? and System_id=?";

			public static final String INSERT_INTO_VEHICLE_CLIENT_HISTORY="insert into AMS.dbo.VEHICLE_CLIENT_HISTORY(REGISTRATION_NUMBER,CLIENT_ID,SYSTEM_ID,INSERTED_DATE,USER_NAME,USER_ID) values(?,?,?,getUTCDate(),?,?)";

			public static final String DELETE_VEHICLE_FROM_Client_Vehicle = "delete from AMS.dbo.VEHICLE_CLIENT where REGISTRATION_NUMBER=? and SYSTEM_ID=? and CLIENT_ID=?";

			public static final String DELETE_VEHICLE_FROM_gpsdata_history_latest = "delete from AMS.dbo.gpsdata_history_latest where REGISTRATION_NO = ? and System_id = ? and CLIENTID=?";

			public static final String DELETE_VEHICLE_LIVE_SUPPORT = "delete from AMS.dbo.Live_Vision_Support where REGISTRATION_NO=? and SYSTEM_ID=?";

			public static final String DELETE_VEHICLE_FROM_Driver_Vehicle = "delete from AMS.dbo.Driver_Vehicle where REGISTRATION_NO=? and SYSTEM_ID=?";

			public static final String DELETE_VEHICLE_FROM_Trip_Allocation = "delete from AMS.dbo.Trip_Allocation where Registration_no=? and System_id=?";

			public static final String DELETE_VEHICLE_FROM_Vehicle_association = "delete from AMS.dbo.Vehicle_association where Registration_no=? and System_id=?";

			public static final String DELETE_VEHICLE_FROM_VEHICLEIOASSOCIATION = "delete from AMS.dbo.VEHICLEIOASSOCIATION where VEHICLEID=? and SYSTEMID=?";

			public static final String DELETE_VEHICLE_FROM_VEHICLE_DEPT_ASSOCIATION = "delete from AMS.dbo.VEHICLE_DEPT_ASSOCIATION where REGNO=? and SYSTEMID=?";

			public static final String DELETE_VEHICLE_USER_ASSOCIATION = "delete from AMS.dbo.Vehicle_User where Registration_no=? and System_id=?";

		    public static final String DELETE_VEHICLE_SCHEDULAR_ASSOCIATION = "delete from AMS.dbo.VehicleReportSchedularAssoc where VehicleNo = ? "
						                            + "and SchedularId in (select SchedularId from AMS.dbo.ReportSchedular where SystemId = ?)";

			public static final String DELETE_HUB_ALERT_DATE_TIME = "delete from AMS.dbo.HubAlertDateTime where VehicleNo=?";

			public static final String DELETE_PREVENTIVE_SCHEDULER = "delete from AMS.dbo.VehicleSchedularAssociation where VehicleNo=?";

			public static final String DELETE_PREVENTIVE_SETTING = "delete from FMS.dbo.RegularMaintenanceSchedule where VehicleNo=?";
					
			public static final String DELETE_STATUATORY_ALERT = "delete from AMS.dbo.StatutoryAlert where VehicleNo=? and SystemId=?";

			public static final String DELETE_ROUTE_ALLOCATION="delete from AMS.dbo.RouteAllocation where Allocated=? and System_Id=? ";
					
			public static final String DELETE_MAINPOWER_ONOFF=" delete from AMS.dbo.MainPowerOnOff where RegistrationNo=? and SystemId=? ";

			public static final String DELETE_REPORT_SCHEDULAR_VEHICLE = "delete from AMS.dbo.VehicleReportSchedularAssoc where VehicleNo = ?";

			public static final String GET_ASSOCIATED_EMAILID = "select a.Emailed as EmailId from AMS.dbo.Users a  inner join AMS.dbo.Alert_User_Assoc b on a.User_id=b.UserId inner join AMS.dbo.Vehicle_User c on a.User_id=c.User_id " 
		                                       + " where a.System_id=? and b.AlertId=? and b.SystemId=? and c.Registration_no=? and b.Email=1 and a.Emailed<>'' and a.Emailed is not null";

			public static final String INSERT_INTO_EMAIL_QUEUE_VEHICLE_REG_AND_UNREG = "insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,AlertType,SystemId,RegistrationNo) values(?,?,?,?,?,?)";

			public static final String GET_UNIT_TYPE_CODE_FOR_MANAGE_ASSET = "select UNIT_TYPE_CODE from ADMINISTRATOR.dbo.UNIT_MASTER where UNIT_NUMBER = ? and SYSTEM_ID = ?";

			public static final String UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_ADMINISTRATOR = "UPDATE ADMINISTRATOR.dbo.UNIT_MASTER set MOBILE_NUMBER=? where UNIT_NUMBER=? and SYSTEM_ID=?";

			public static final String UPDATE_SIM_NUMBER_BASED_ON_UNIT_IN_AMS =" update AMS.dbo.Unit_Master set SIM_NUMBER=? where Unit_number=? and System_id=? ";
					
			public static final String GET_OWNER_NAMES =" select (isnull(FIRST_NAME,'')+' '+isnull(LAST_NAME,'')) as OWNERNAME,isnull(OWNER_ID,'') as OWNER_ID,isnull(MOBILE_NO,'') as MOBILE_NO,isnull(ADDRESS,'') as ADDRESS, ISNULL(EMAIL_ID,'') AS EMAIL_ID from ADMINISTRATOR.dbo.OWNER_MASTER(NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? ";

			public static final String UPDATE_OWNER_NAME_IN_LIVE_VISION_SUPPORT=" update AMS.dbo.Live_Vision_Support set OWNER_NAME=? where REGISTRATION_NO=? and CLIENT_ID=? and SYSTEM_ID=? ";
					
			public static final String GET_GROUP_USER_FROM_USER_ASSET_GROUP_ASSOCIATION = " select distinct USER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION (NOLOCK) where SYSTEM_ID=? and GROUP_ID=? and "+ 
											  " USER_ID not in (select distinct USER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION (NOLOCK) where SYSTEM_ID=? and GROUP_ID = ? ) ";
					
			public static final String GET_ASSOCIATED_GROUP_USER_FROM_USER_ASSET_GROUP_ASSOCIATION = " select distinct isnull(USER_ID,0) as USER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION (NOLOCK) where SYSTEM_ID=? and GROUP_ID=? ";

			public static final String ASSOCIATE_VEHICLE_FOR_GROUP = "update VEHICLE_CLIENT set GROUP_ID=? where CLIENT_ID=? and SYSTEM_ID=? and REGISTRATION_NUMBER=? ";

			public static final String INSERT_USER_IN_VEHICLEUSERS = " insert into AMS.dbo.Vehicle_User (Registration_no,User_id,System_id,Date) values (?,?,?,getutcdate()) ";

			public static final String CHECK_VEHICLE_USER_IN_VEHICLEUSERS = " select isnull(Registration_no,'') as Registration_no  from AMS.dbo.Vehicle_User where User_id=? and System_id=? and Registration_no=? ";

			public static final String GET_DEFAULT_GROUP_USER_FROM_USER_ASSET_GROUP_ASSOCIATION = " select distinct USER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION (NOLOCK) where SYSTEM_ID=? and "+
										    	   " GROUP_ID = ? and USER_ID not in (select distinct USER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION (NOLOCK) where SYSTEM_ID=? and GROUP_ID =?) ";

			public static final String DELETE_USER_IN_VEHICLEUSERS = " delete from AMS.dbo.Vehicle_User where Registration_no=? and User_id=? and System_id=? ";
					
			public static final String MOVE_DATA_FROM_VEHICLE_USERS_TO_VEHICLE_USER_HISTORY=" insert into AMS.dbo.Vehicle_User_Hist select * from AMS.dbo.Vehicle_User where Registration_no=? and User_id=? and System_id=? ";

					
			public static final String GET_ALL_DEFAULT_USERS_EXCEPT_LOGIN_USER = " select Distinct USER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION (NOLOCK) "+
												 " where SYSTEM_ID=? and GROUP_ID= ? and USER_ID!=? ";
					
			public static final String DELETE_ASSET_STORED_PROCEDURE="{call [ASSET_UNREGISTARTION](?,?,?)}";
					
			public static final String CHECK_IF_VEHICLE_REGISTERED_AND_STATUS_IS_INACTIVE="select isnull(RegistrationNo,'') as RegistrationNo from AMS.dbo.VehicleRegistration where Status=? and  ADMINISTRATOR.dbo.REMOVE_SPECIAL_CHARACTERS(RegistrationNo,'^a-zA-Z0-9s') = ADMINISTRATOR.dbo.REMOVE_SPECIAL_CHARACTERS(?,'^a-zA-Z0-9s') ";

			public static final String UPDATE_VEHICLE_STATUS_TO_ACTIVE="update AMS.dbo.VehicleRegistration  set Status=?,RegistrationDateTime=dateadd(mi,?,getUTCDate()),CancellationDateTime=?,RegisteredBy=?,Reason=?,SystemId=?,RegistrationNo=?,CancelledBy=? where RegistrationNo=? ";

			
			public static final String MOVE_DATA_FROM_VEHICLEREGISTRATION_TO_ASSET_REGISTRATION_HISTORY=" insert into ADMINISTRATOR.dbo.ASSET_REGISTRATION_HISTORY(ASSET_NUMBER,SYSTEM_ID,CUSTOMER_ID,ASSET_TYPE,RAGISTRATION_TIME, "
				+ " REGISTERED_BY,CANCELLATION_TIME,CANCELLED_BY,REASON) "
				+ " select RegistrationNo,SystemId,?,?,isnull(RegistrationDateTime,'') as RegistrationDateTime,isnull(RegisteredBy,0) as RegisteredBy,isnull(CancellationDateTime,'') as CancellationDateTime,isnull(CancelledBy,0) as CancelledBy,isnull(Reason,'') as Reason from AMS.dbo.VehicleRegistration "
				+ " where RegistrationNo=? and SystemId=? ";
			
			public static final String CHECK_IF_VEHICLE_PRESENT_IN_PREVENTIVE_EVENTS=" select isnull(ASSET_NUMBER,'') as ASSET_NUMBER from FMS.dbo.PREVENTIVE_TASK_ASSOCIATION where ASSET_NUMBER=? and SYSTEM_ID=? and CUSTOMER_ID=? ";
			
			public static final String DELETE_VEHICLE_FROM_PREVENTIVE_EVENTS=" delete from FMS.dbo.PREVENTIVE_TASK_ASSOCIATION where ASSET_NUMBER=? and SYSTEM_ID=? and CUSTOMER_ID=? ";
	
			public static final String UPDATE_LOCATION_IN_GPS_LATEST_HISTORY=" update AMS.dbo.gpsdata_history_latest set LOCATION='No GPS Device Connected', "
				+ " UNIT_NO=null,LATITUDE=null,LONGITUDE=null,PREV_LONG=null,PREV_LAT=null,ISLATEST='N', "
				+ " MESSAGE_NUMBER='0',IGNITION='0',ODOMETER='0',SPEED='0',DURATION='0',CATEGORY=null,START_TIME=null "
				+ " where  REGISTRATION_NO = ? and System_id = ? " ;
			
			public static final String SELECT_REGISTRATION_DATE=" select isnull(RegistrationDateTime,'') as  RegistrationDateTime from AMS.dbo.VehicleRegistration where RegistrationNo=? and SystemId=? ";

			public static final String SELECT_CANCELLATION_DATE=" select isnull(CancellationDateTime,'') as  CancellationDateTime from AMS.dbo.VehicleRegistration where RegistrationNo=? and SystemId=? ";
			
			public static final String UPDATE_CHECK_AND_USER_ID_IN_TBL_VEHICLE_MASTER="update AMS.dbo.tblVehicleMaster set Vehicle_number=?,NoOfContainer=?  where VehicleNo=? and System_id=?";
			
			
			public static final String GET_SERVICE_TYPE_DETAILS_FOR_TDBAC ="select a.REGISTRATION_NO,a.DATA,"+
                                                                   "RESPONSE,dateadd(mi,?,a.TRIGGERED_DATETIME) as TDBAC_PUSH_TIME,b.TRIP_END_TIME as EventTime from dbo.WEBSERVICE_DATA_TRACK a "+
                                                                   "INNER join dbo.CARGO_SHIPMENT_DETAILS b on b.ASSET_NUMBER =a.REGISTRATION_NO where "+
                                                                   "a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE= ? and b.INSERTED_TIME between dateadd(mi,1110,dateadd(dd,-1,?)) and dateadd(mi,1110,?) "+
                                                                   "and b.SHIPMENNT_ID=SUBSTRING(a.DATA,(CHARINDEX('<ShipmentRefnumValue>',a.DATA)+21),"+
                                                                   "(CHARINDEX('</ShipmentRefnumValue>',a.DATA)-CHARINDEX('<ShipmentRefnumValue>',a.DATA)-21))";
			
			public static final String GET_SHIPMENT_DETAILS ="select a.ASSET_NUMBER,a.SHIPMENNT_ID,a.TRIP_START_TIME,a.STATUS,b.LOCATION_ID as SOURCE,c.LOCATION_ID as DESTINATION ,a.SERVICE_PROVIDER,a.UNIT_NO,b.ETA as SOURCE_ETA ,c.ETA as DESTINATION_ETA,"+
                                                             "dateadd(mi,?,a.INSERTED_TIME) as TRIP_SHEET_RECIEVED_TIME,a.COMMUNICATION_STATUS as SHIPMENT_CLOSER_STATUS ,isNULL(a.RE_PUSHED,'') as RE_PUSHED," +
															 "case when a.STATUS='Closed' and a.AUTO_CLOSE='N' then 'Forcibly Closed' "+  
															 "when a.STATUS='Closed' and a.AUTO_CLOSE='Y' then 'Closed' "+ 
															 "when a.TRIP_END_TIME IS NULL AND a.STATUS='Open' then 'Open' "+ 
															 "when a.TRIP_END_TIME IS NULL AND a.STATUS='Closed' then 'Forcibly Closed' "+ 
															 "when a.TRIP_END_TIME IS not NULL AND a.STATUS='Closed' then 'Closed' "+   
															 "end as SHIPMENT_CLOSER_TYPE , "+
															 "a.TRIP_END_TIME as CLOSED_TIME "+
                                                             "from CARGO_SHIPMENT_DETAILS a "+
                                                             "inner join CARGO_STOP_POINT_DETAILS b on a.TRIP_ID=b.TRIP_ID and b.TYPE='P '"+
                                                             "inner join CARGO_STOP_POINT_DETAILS c on a.TRIP_ID=c.TRIP_ID and c.TYPE='D '"+ 
                                                             "where SYSTEM_ID=? and CUSTOMER_ID in (?,0) and INSERTED_TIME between dateadd(mi,1110,dateadd(dd,-1,?)) and dateadd(mi,1110,?) and SHIPMENNT_ID LIKE ? ";
			
			
			public static final String GET_SERVICE_TYPE_DETAILS_FOR_X7 ="select REGISTRATION_NO,DATA,RESPONSE,dateadd(mi,?,TRIGGERED_DATETIME) as EventTime from dbo.WEBSERVICE_DATA_TRACK where SYSTEM_ID=? and CUSTOMER_ID=? and TYPE=? and TRIGGERED_DATETIME between dateadd(mi,1110,dateadd(dd,-1,?)) and dateadd(mi,1110,?) ";
			
			public static final String DELETE_USER_AUTHORITY="delete from LMS.dbo.USER_AUTHORITY where USER_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";

			public static final String GET_REASONS=" select isnull(VALUE,'') as Reason from AMS.dbo.LOOKUP_DETAILS where TYPE='CANCELLATIONREASON' and VERTICAL='HORIZONTAL'";
			
			public static final String GET_SHIPMENT_X6_DETAILS=" select s.TRIP_ID,s.ASSET_NUMBER,s.SHIPMENNT_ID,p.LOCATION_ID,p.SEQUENCE,p.TYPE,p.LATITUDE,p.LONGITUDE,p.PUSH_STATUS,p.STOP_IN_TIME,p.STOP_OUT_TIME,s.TRIP_START_TIME,dateadd(mi,?,s.INSERTED_TIME) as RECEIVED_TIME,s.STATUS,s.RE_PUSHED,s.TRIP_END_TIME from CARGO_SHIPMENT_DETAILS s "+
            " inner join CARGO_STOP_POINT_DETAILS p on p.TRIP_ID=s.TRIP_ID "+
            " where s.SYSTEM_ID=? and s.CUSTOMER_ID=? and INSERTED_TIME between dateadd(mi,1110,dateadd(dd,-1,?)) and dateadd(mi,1110,?) order by s.TRIP_ID desc ";
			
			public static final String GET_MLL_TAT_REPORT_DETAILS="select a.REGISTRATION_NO,b.NAME as PARK_NAME,c.NAME as PLANT_NAME,a.PARK_IN,a.PLANT_IN,a.PLANT_OUT,a.PARK_OUT from dbo.TAT_REPORT a "
                                                                  +"left outer join dbo.LOCATION_ZONE_A b on b.HUBID=a.PARK_HUB_ID "
                                                                  +"left outer join dbo.LOCATION_ZONE_A c on c.HUBID=a.PLANT_HUB_ID "
                                                                  +"where LAST_EXECUTIONTIME between ? and ? "
                                                                  +"order by REGISTRATION_NO,LAST_EXECUTIONTIME desc";
			
/*******************************************************************************ADD NEW FEATURE QUERIES****************************************************************************************************************************/			
		
			public static final String GET_ALL_LTSP="select isnull(System_id,'') as SystemId,isnull(System_Name,'') as SystemName,ISNULL(PRE_PAYMENT_MODE,'N') AS PRE_PAYMENT_MODE from AMS.dbo.System_Master";
			
			public static final String GET_PRODUCT_TYPE=" select distinct isnull(b.LANG_ENGLISH,'') as ProcessType,isnull(b.LABEL_ID,'') as ProcessId from ADMINISTRATOR.dbo.PRODUCT_PROCESS a  " 
				                                      + " inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b on a.PROCESS_TYPE_LABEL_ID=b.LABEL_ID ";
			
			public static final String GET_PROCESS_NAME=" select isnull(a.PROCESS_ID,'') as processId,isnull(b.LANG_ENGLISH,'') as ProcessName "
														+ " from ADMINISTRATOR.dbo.PRODUCT_PROCESS a "
														+ " inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b on a.PROCESS_LABEL_ID=b.LABEL_ID "
														+ " where PROCESS_TYPE_LABEL_ID=? ";
			
			public static final String GET_SUB_PROCESS_NAME=" select isnull(SUB_PROCESS_LABEL_ID,'') as SubProcessName,isnull(SUB_PROCESS_ID,'') as SubProcessId "
				+ " from ADMINISTRATOR.dbo.SUB_PROCESS where PROCESS_ID=? ";
			
			public static final String GET_SUB_PROCESS_NAME2=" select isnull(SUB_PROCESS_LABEL_ID,'') as SubProcessName,isnull(SUB_PROCESS_ID,'') as SubProcessId "
				+ " from ADMINISTRATOR.dbo.SUB_PROCESS where PROCESS_ID=? and SUB_PROCESS_LABEL_ID in ('Vertical_Dashboard','Mapview','Alerts','Actions','Reports','Preferences','Administration') "
				+ " and SUB_PROCESS_ID !=11 ";
			
			public static final String GET_MENU_GROUP_NAME=" select isnull(b.LANG_ENGLISH,'') as MenuGroupName,isnull(a.MENU_GROUP_ID,'') as menuGroupId from ADMINISTRATOR.dbo.MENU_GROUP a "
				+ " inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b on a.MENU_GROUP_LABEL_ID=b.LABEL_ID "
				+ " where a.SUB_PROCESS_ID=? ";
			
			public static final String GET_PAGE_LINK_NAMES=" select isnull(a.ELEMENT_NAME,'') as ElementName,isnull(a.ELEMENT_ID,'') as ElementId from ADMINISTRATOR.dbo.PRODUCT_ELEMENT a "
				+ " where a.ELEMENT_ID not in(select ELEMENT_ID from ADMINISTRATOR.dbo.MENU_MASTER) ";
			
			public static final String GET_ADD_FEATURE_REPORT=" select isnull(e1.LANG_ENGLISH,'') as ProcessType,isnull(e.LANG_ENGLISH,'') as ProcessName, "
				+ " isnull(g.LANG_ENGLISH,'None') as SubProcessName,isnull(a.menu_item_name,'') as PageTitle,program_name,isnull(t.LANG_ENGLISH,'') as MenuGroupName "
				+ " ,isnull(c.PROCESS_ID,0) as ProcessId,isnull(c.SUB_PROCESS_ID,0) as SubProcessId,isnull(h.MENU_GROUP_ID,0) as MenuGroupId "
				+ " from dbo.menu_item_master a "
				+ " inner join ADMINISTRATOR.dbo.PRODUCT_ELEMENT b on a.program_name=b.ELEMENT_NAME COLLATE DATABASE_DEFAULT " 
				+ " inner join ADMINISTRATOR.dbo.MENU_MASTER c on c.ELEMENT_ID=b.ELEMENT_ID "
				+ " inner join ADMINISTRATOR.dbo.PRODUCT_PROCESS d on d.PROCESS_ID=c.PROCESS_ID "
				+ " inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION e on d.PROCESS_LABEL_ID=e.LABEL_ID "
				+ " inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION e1 on d.PROCESS_TYPE_LABEL_ID=e1.LABEL_ID " 
				+ " left outer join ADMINISTRATOR.dbo.SUB_PROCESS f on f.PROCESS_ID=c.PROCESS_ID and f.SUB_PROCESS_ID=c.SUB_PROCESS_ID  "
				+ " left outer join ADMINISTRATOR.dbo.LANG_LOCALIZATION g on f.SUB_PROCESS_LABEL_ID=g.LABEL_ID "
				+ " left outer join ADMINISTRATOR.dbo.VERTICAL_MENU_DISPLAY h on h.PROCESS_ID=c.PROCESS_ID  and c.ELEMENT_ID=h.ELEMENT_ID "
				+ " left outer join ADMINISTRATOR.dbo.MENU_GROUP r on h.PROCESS_ID=r.PROCESS_ID and h.SUB_PROCESS_ID=r.SUB_PROCESS_ID and h.MENU_GROUP_ID=r.MENU_GROUP_ID "
				+ " left outer join ADMINISTRATOR.dbo.LANG_LOCALIZATION t on r.MENU_GROUP_LABEL_ID=t.LABEL_ID "
				+ " where a.system_id=? "
				+ " order by c.PROCESS_ID,c.SUB_PROCESS_ID,menu_item_name ";
			
			public static final String GET_ADD_FEATURE_REPORT1=" select isnull(e1.LANG_ENGLISH,'') as ProcessType,isnull(e.LANG_ENGLISH,'') as ProcessName, "
				+ " isnull(g.LANG_ENGLISH,'None') as SubProcessName,isnull(a.menu_item_name,'') as PageTitle,program_name,isnull(t.LANG_ENGLISH,'') as MenuGroupName "
				+ " ,isnull(c.PROCESS_ID,0) as ProcessId,isnull(c.SUB_PROCESS_ID,0) as SubProcessId,isnull(h.MENU_GROUP_ID,0) as MenuGroupId "
				+ " from dbo.menu_item_master a "
				+ " inner join ADMINISTRATOR.dbo.PRODUCT_ELEMENT b on a.program_name=b.ELEMENT_NAME COLLATE DATABASE_DEFAULT " 
				+ " inner join ADMINISTRATOR.dbo.MENU_MASTER c on c.ELEMENT_ID=b.ELEMENT_ID "
				+ " inner join ADMINISTRATOR.dbo.PRODUCT_PROCESS d on d.PROCESS_ID=c.PROCESS_ID "
				+ " inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION e on d.PROCESS_LABEL_ID=e.LABEL_ID "
				+ " inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION e1 on d.PROCESS_TYPE_LABEL_ID=e1.LABEL_ID " 
				+ " left outer join ADMINISTRATOR.dbo.SUB_PROCESS f on f.PROCESS_ID=c.PROCESS_ID and f.SUB_PROCESS_ID=c.SUB_PROCESS_ID  "
				+ " left outer join ADMINISTRATOR.dbo.LANG_LOCALIZATION g on f.SUB_PROCESS_LABEL_ID=g.LABEL_ID "
				+ " left outer join ADMINISTRATOR.dbo.VERTICAL_MENU_DISPLAY h on h.PROCESS_ID=c.PROCESS_ID and c.ELEMENT_ID=h.ELEMENT_ID "
				+ " left outer join ADMINISTRATOR.dbo.MENU_GROUP r on h.PROCESS_ID=r.PROCESS_ID and h.SUB_PROCESS_ID=r.SUB_PROCESS_ID and h.MENU_GROUP_ID=r.MENU_GROUP_ID "
				+ " left outer join ADMINISTRATOR.dbo.LANG_LOCALIZATION t on r.MENU_GROUP_LABEL_ID=t.LABEL_ID "
				+ " where a.system_id=-1 "
				+ " order by c.PROCESS_ID,c.SUB_PROCESS_ID,menu_item_name ";

			public static final String CHECK_PAGE_TITLE_PRESENT_IN_LANG_LOCALIZATION=" select LANG_ENGLISH,LABEL_ID from ADMINISTRATOR.dbo.LANG_LOCALIZATION where upper(LANG_ENGLISH)=? ";
			
			public static final String CHECK_MENU_NAME_PRESENT_MENU_ITEM_MASTER=" select * from AMS.dbo.menu_item_master where upper(menu_item_name)=? and system_id=-1 ";

			
			public static final String SELECT_MAX_MENU_ID_AND_MAX_ORDERID_FROM_MENU_ITEM_MASTER=" select max(menu_item_id) as maxMenuId,max(OrderId) as maxOrderId  from AMS.dbo.menu_item_master where system_id=-1 ";

			
			public static final String SELECT_CSS_FROM_MENU_MASTER="select top 1 CSS from ADMINISTRATOR.dbo.MENU_MASTER where PROCESS_ID=? and (SUB_PROCESS_ID=? or SUB_PROCESS_ID is null)";
			
			public static final String SELECT_MENU_ITEM_ID_FROM_MENT_ITEM_MASTER_WHEN_SUB_ROCESS_ID_IS_NOT_NULL=" select distinct menu_item_parent_id from  AMS.dbo.menu_item_tree_structure where menu_item_id in " 
				+ " (select menu_item_id from AMS.dbo.menu_item_master where program_name COLLATE DATABASE_DEFAULT in " 
				+ " (select ELEMENT_NAME from ADMINISTRATOR.dbo.PRODUCT_ELEMENT where ELEMENT_ID in "
				+ " (select ELEMENT_ID from ADMINISTRATOR.dbo.MENU_MASTER where system_id=-1 and PROCESS_ID=? ))) ";
			
			public static final String SELECT_MENU_ITEM_ID_FROM_MENT_ITEM_MASTER=" select distinct menu_item_parent_id from  AMS.dbo.menu_item_tree_structure where menu_item_id in " 
				+ " (select menu_item_id from AMS.dbo.menu_item_master where program_name COLLATE DATABASE_DEFAULT in " 
				+ " (select ELEMENT_NAME from ADMINISTRATOR.dbo.PRODUCT_ELEMENT where ELEMENT_ID in "
				+ " (select ELEMENT_ID from ADMINISTRATOR.dbo.MENU_MASTER where system_id=-1 and PROCESS_ID=? and (SUB_PROCESS_ID=? or SUB_PROCESS_ID is null) ))) ";

			
			public static final String SELECT_MENU_ITEM_PARENT_ID_FROM_MENT_ITEM_TREE="select top 1 * from  AMS.dbo.menu_item_tree_structure where menu_item_id=?";

			public static final String SELECT_ALL_SYSTEM_ID_FROM_SYSTEM_MASTER="select isnull(System_id,'') as SystemId,isnull(System_Name,'') as SystemName from AMS.dbo.System_Master";
			
			public static final String INSERT_INTO_MENU_ITEM_MASTER="insert into AMS.dbo.menu_item_master(menu_item_id,menu_item_name,program_name,system_id,css,rightsidemenu,OrderId) values(?,?,?,?,?,?,?)";
			
			public static final String INSERT_INTO_MENU_ITEM_TREE_STRUCTURE="insert into AMS.dbo.menu_item_tree_structure values(?,?,?)";
			
			public static final String INSERT_GROUP_FEATURE_T4U="insert into AMS.dbo.Group_Feature_T4U(Group_id,Feature_id,System_id) values(?,?,?)";
			
			public static final String INSERT_INTO_MENU_MASTER="insert into ADMINISTRATOR.dbo.MENU_MASTER(PROCESS_ID,SUB_PROCESS_ID,MENU_LABEL_ID,ELEMENT_ID,ORDER_OF_DISPLAY,CSS) values(?,?,?,?,?,?)";
			
			public static final String TO_GET_ORDER_OF_DISPLAY_FROM_MENU_MASTER=" select distinct ORDER_OF_DISPLAY,(select max(ORDER_OF_DISPLAY) from ADMINISTRATOR.dbo.MENU_MASTER where PROCESS_ID=? and (SUB_PROCESS_ID=? or SUB_PROCESS_ID is null)) as OrderOfDisplay"
				+ " from ADMINISTRATOR.dbo.MENU_MASTER where PROCESS_ID=? and (SUB_PROCESS_ID=? or SUB_PROCESS_ID is null) "
				+ " order by ORDER_OF_DISPLAY ";
				
			public static final String TO_GET_ORDER_OF_DISPLAY_FROM_MENU_MASTER_WHEN_SUB_PROCESS_NULL=" select distinct ORDER_OF_DISPLAY,(select max(ORDER_OF_DISPLAY) from ADMINISTRATOR.dbo.MENU_MASTER where PROCESS_ID=?)  as OrderOfDisplay "
				+ " from ADMINISTRATOR.dbo.MENU_MASTER where PROCESS_ID=? "
				+ " order by ORDER_OF_DISPLAY ";
			
			public static final String SELECT_MENU_ID_FROM_MENU_ITEM_MASTER=" select menu_item_id from AMS.dbo.menu_item_master where program_name=? ";
			
			public static final String DELETE_FROM_MENU_ITEM_TREE_STRUCTURE=" delete from AMS.dbo.menu_item_tree_structure where menu_item_id=? ";
			
			public static final String DELETE_FROM_MENU_ITEM_MASTER=" delete from AMS.dbo.menu_item_master where program_name = ?";
			
			public static final String SELECT_ELEMENT_ID_FROM_PRODUCT_ELEMENT=" select ELEMENT_ID from ADMINISTRATOR.dbo.PRODUCT_ELEMENT where ELEMENT_NAME=? ";
			
			public static final String DELETE_FROM_USER_PROCESS_DETACHMENT=" delete from ADMINISTRATOR.dbo.USER_PROCESS_DETACHMENT where MENU_ID=? ";
			
			public static final String DELETE_FROM_VERTICLE_MENU_DISPLAY=" delete from ADMINISTRATOR.dbo.VERTICAL_MENU_DISPLAY where ELEMENT_ID=? and MENU_ID=?";
			
			public static final String DELETE_FROM_MENU_MASTER=" delete from ADMINISTRATOR.dbo.MENU_MASTER where ELEMENT_ID=? ";
			
			public static final String SELECT_MENU_ID_FROM_MENU_MASTER="select * from ADMINISTRATOR.dbo.MENU_MASTER where ELEMENT_ID=?";
			
			public static final String INSERT_INTO_MENU_HISTORY=" insert into ADMINISTRATOR.dbo.MENU_MASTER_HISTORY(MENU_ID,PROCESS_ID,SUB_PROCESS_ID,MENU_LABEL_ID,ELEMENT_ID,ORDER_OF_DISPLAY,CSS,DELETED_TIME,MENU_GROUP_ID) "
			       + " select isnull(MENU_ID,'') as MENU_ID,isnull(PROCESS_ID,'') as PROCESS_ID,isnull(SUB_PROCESS_ID,'') as SUB_PROCESS_ID,isnull(MENU_LABEL_ID,'') as MENU_LABEL_ID,isnull(ELEMENT_ID,'') as ELEMENT_ID,isnull(ORDER_OF_DISPLAY,'') as ORDER_OF_DISPLAY,isnull(CSS,'') as CSS,getDate(),isnull(MENU_GROUP_ID,'') as MENU_GROUP_ID from ADMINISTRATOR.dbo.MENU_MASTER "
			       + " where ELEMENT_ID=? ";
			
			public static final String INSERT_INTO_VERTICAL_MENU_DISPLAY=" insert into ADMINISTRATOR.dbo.VERTICAL_MENU_DISPLAY(PROCESS_ID,SUB_PROCESS_ID,MENU_GROUP_ID,MENU_ID,ELEMENT_ID,ORDER_OF_DISPLAY) "
			+ " values(?,?,?,?,?,?) ";
		
			public static final String DELETE_FROM_T4U_GROUP_FEATURES="delete from AMS.dbo.Group_Feature_T4U where Feature_id=?";
			
			public static final String SELECT_ALL_PROCESS_ID_FOR_VERTICAL_SOL_IN_PRODUCT_PROCESS= " select * from ADMINISTRATOR.dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Vertical_Sol' ";
			
			public static final String SELECT_SUB_PROCESS_ID_FROM_SUB_PROCESS_FOR_ABOVE_PROCESS_ID=" select * from ADMINISTRATOR.dbo.SUB_PROCESS where PROCESS_ID=? and SUB_PROCESS_LABEL_ID='Administration'";

			public static final String SELECT_SUB_PROCESS_ID_FROM_SUB_PROCESS_REPORTS=" select * from ADMINISTRATOR.dbo.SUB_PROCESS where PROCESS_ID=? and SUB_PROCESS_LABEL_ID=?";

			public static final String SELECT_ALL_MENU_FROM_MENU_GROUP_PROCESS_AND_SUB_PROCESS_ID=" select * from dbo.MENU_GROUP where PROCESS_ID=? and SUB_PROCESS_ID=? and MENU_GROUP_LABEL_ID=?";
			
			public static final String GET_MENU_GROUP_NAME_FOR_ADD_ON_PACKAGES="select distinct lg.LANG_ENGLISH,lg.LABEL_ID from ADMINISTRATOR.dbo.MENU_GROUP mg" +
					" inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION lg on mg.MENU_GROUP_LABEL_ID=lg.LABEL_ID " +
					" where mg.MENU_GROUP_LABEL_ID like ? ";
			
			public static final String SELECT_ALL_PROCESS_ID_FOR_ADD_ON_PACKAGE_IN_PRODUCT_PROCESS= " select * from ADMINISTRATOR.dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Add_On_Pkg' ";
			
			public static final String SELECT_SUB_PROCESS_ID_FROM_SUB_PROCESS_FOR_ADD_ON_PACKAGE=" select * from ADMINISTRATOR.dbo.SUB_PROCESS where PROCESS_ID=? and SUB_PROCESS_LABEL_ID=? ";
			
			public static final String SELECT_SUB_PROCESS_AND_MENU_ID_FROM_MENU_GROUP=" select * from ADMINISTRATOR.dbo.MENU_GROUP where PROCESS_ID=? and SUB_PROCESS_ID=? and MENU_GROUP_LABEL_ID=? ";
			
			public static final String SELECT_SUB_PROCESS_ID_FROM_SUB_PROCESS=" select * from ADMINISTRATOR.dbo.SUB_PROCESS where PROCESS_ID=? and SUB_PROCESS_LABEL_ID=? ";
			
			public static final String SELECT_MENU_GROUP_ID_FROM_MENU_GROUP=" select * from ADMINISTRATOR.dbo.MENU_GROUP where PROCESS_ID=?  and SUB_PROCESS_ID=? and "
                      + " MENU_GROUP_LABEL_ID=? ";
//**********************************************************************CREATE LTSP STATEMENTS***********************************************************************************************************************************************************//
			
			public static final String GET_SUB_CATEGORY_NAME= " select ID,BUSINESS_GROUP,CATEGORY from CRC.dbo.BUSINESS_GROUP_MASTER where CATEGORY=? ";
			
			public static final String GET_COUNTRY_LIST_FOR_CREATE_LTSP= " select COUNTRY,ZONE from AMS.dbo.COUNTRY_GMT ";
			
			public static final String SELECT_MAX_SYSTEM_ID_FROM_SYSTEM_MASTER=" select max(System_id) as SystemId from AMS.dbo.System_Master ";
			
			public static final String SELECT_OFFSET_FROM_COUNTRY_GMT=" select GMT,ZONE from AMS.dbo.COUNTRY_GMT where COUNTRY=? ";
			
			public static final String INSERT_CREATE_LTSP_INFORMATION=" insert into AMS.dbo.System_Master(System_id,System_Name,Address,COUNTRY,Latitude,Longitude,Category,CategoryTypeForBill,BBC_OIL, "
																	+ " title,Show_t4u_logo,ContactPersonForBill,Email_id,Telephone_no,Unit_of_Measure,PANNoForBill,TinNoForBill,InvoiceNoForBill, "
																	+ " Group_Wise,OverSpeedFromUnit,Offset,Zone,THREAD_NAME,OffsetMin,Service_Tax) "
																	+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'Y',?,?,?,?,?) ";
			
			public static final String INSERT_USER_DETAILS_INTO_AMS_USER_TABLE=" insert into AMS.dbo.Users(User_id,Firstname,Login_status,Login_name,User_password,Client_id,System_id,Lastname,Telephone,Emailed,User_type,Status) "
				                                                    + " values('1',?,'Y',?,?,'0',?,'Y',?,?,'1','Active') ";
			
			public static final String INSERT_USER_DETAILS_INTO_ADMINISTRATOR_USER_TABLE= " insert into ADMINISTRATOR.dbo.USERS(FIRST_NAME,USER_NAME,PASSWORD,CUSTOMER_ID,SYSTEM_ID,LAST_NAME,PHONE,EMAIL,USER_ID,USER_TYPE,STATUS) "
        	                                                        + " values(?,?,?,'0',?,'Y',?,?,'1','1','Active') ";
			
			public static final String GET_CREATE_LTSP_REPORT=" select isnull(a.System_id,'') as SystemId,isnull(a.System_Name,'') as LtspName,isnull(a.Address,'') as address, "
				+ " isnull(a.COUNTRY,'') as country,isnull(a.Latitude,'') as latitude, "
				+ " isnull(a.Longitude,'') as Longitude,isnull(a.Category,'') as Category,isnull(b.BUSINESS_GROUP,'') as CategoryType,isnull(a.BBC_OIL,'') as bbcOil, "
				+ " isnull(a.title,'') as Title,isnull(a.Show_t4u_logo,'') as logo,isnull(a.ContactPersonForBill,'') as ContactPerson,isnull(a.Email_id,'') as emailId, "
				+ " isnull(a.Telephone_no,'') as TelephoneNo,isnull(a.Unit_of_Measure,'') as UnitOfMeasure, "
				+ " isnull(a.PANNoForBill,'') as PanNo,isnull(a.TinNoForBill,'') as tinNo,isnull(a.InvoiceNoForBill,'') as InvoiceNo,isnull(a.Group_Wise,'') as GroupWiseBilling,isnull(a.CategoryTypeForBill,'') as CateId "
				+ " from AMS.dbo.System_Master a "
				+ " inner join CRC.dbo.BUSINESS_GROUP_MASTER b on a.CategoryTypeForBill=b.ID ";
			
			public static final String UPDATE_CREATE_LTSP_DETAILS=" update AMS.dbo.System_Master set System_Name=?,Address=?,COUNTRY=?,Latitude=?,Longitude=?,Category=?,CategoryTypeForBill=?, "
				+ " BBC_OIL=?,title=?,Show_t4u_logo=?,ContactPersonForBill=?,Email_id=?,Telephone_no=?,Unit_of_Measure=?,PANNoForBill=?, "
				+ " TinNoForBill=?,InvoiceNoForBill=?,Group_Wise=? where System_id=? ";
			
			
			public static final String INSERT_DETAILS_TO_TSP_MASTER=" insert into ADMINISTRATOR.dbo.TSP_MASTER(ID,NAME,ADDRESS,CITY,COUNTRY,POSTAL_CODE,LATITUDE,LONGITUDE,CATEGORY, "
							+ " SUB_CATEGORY,PLTFORM_TITLE,LOGO,ZONE,OFFSET,BBC_OIL,APPLICATION_URL,CREATED_DATE,CREATED_BY) "
							+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getUtcDate(),?) ";
			
			public static final String SELECT_APPLICATION_URL_FROM_SYSTEM_MASTER="select ApplicationServer from AMS.dbo.System_Master where System_id=?";
			
			/*public static final String GET_MLL_TAT_REPORT_DETAILS1= "select a.REGISTRATION_NO,b.NAME as PARK_NAME,c.NAME as PLANT_NAME,dateadd(mi,?,a.PARK_IN) as PARK_IN,dateadd(mi,?,a.PLANT_IN) as PLANT_IN,dateadd(mi,?,a.PLANT_OUT) as PLANT_OUT,dateadd(mi,?,a.PARK_OUT) as PARK_OUT,a.OWNER_NAME,a.TRAILER_TYPE,a.TRIP_TAT,a.PLANT_TAT,a.WAITING_IN_TAT,a.WAITING_OUT_TAT,d.OWNER_NAME as GROUP_NAME from TAT_REPORT_TEST a "				                                                   
                +"left outer join dbo.LOCATION_ZONE_A b on b.HUBID=a.PARK_HUB_ID "
                +"left outer join dbo.LOCATION_ZONE_A c on c.HUBID=a.PLANT_HUB_ID "
                +"left outer join dbo.Live_Vision_Support d on d.REGISTRATION_NO=a.REGISTRATION_NO " 
                +"where a.PARK_IN between dateadd(mi,1110,dateadd(dd,-1,?)) and dateadd(mi,1110,?) and EVENTS='1|2|3|4'"
                +"order by a.PARK_IN";*/
			
			public static final String GET_MLL_TAT_REPORT_DETAILS1 = "select a.REGISTRATION_NO,b.NAME as PARK_NAME,c.NAME as PLANT_NAME,a.PARK_IN as PARK_IN,a.PLANT_IN as PLANT_IN,a.PLANT_OUT as PLANT_OUT,e.VehicleType as TRAILER_TYPE,d.GROUP_NAME as OWNER_NAME,a.PARK_OUT as PARK_OUT,DATEDIFF(mi,a.PARK_IN,a.PARK_OUT) as TRIP_TAT,DATEDIFF(mi,a.PLANT_IN,a.PLANT_OUT) as PLANT_TAT,DATEDIFF(mi,a.PARK_IN,a.PLANT_IN)as WAITING_IN_TAT, DATEDIFF(mi,a.PLANT_OUT,a.PARK_OUT) AS WAITING_OUT_TAT,d.OWNER_NAME as GROUP_NAME from TAT_REPORT a "+				                                                   
            " left outer join dbo.LOCATION_ZONE_A b on b.HUBID=a.PARK_HUB_ID "+
            " left outer join dbo.LOCATION_ZONE_A c on c.HUBID=a.PLANT_HUB_ID "+
            " left outer join dbo.Live_Vision_Support d on d.REGISTRATION_NO=a.REGISTRATION_NO  "+
            " LEFT outer join dbo.tblVehicleMaster e on a.REGISTRATION_NO=e.VehicleNo "+
            " left outer join Vehicle_association f on a.REGISTRATION_NO=f.Registration_no "+
            " where a.PARK_IN between dateadd(mi,1110,dateadd(dd,-1,?)) and dateadd(mi,1110,?) and f.System_id = ? and f.Client_id = ? and EVENTS='1|2|3|4' and a.PLANT_OUT IS NOT null and a.PLANT_IN IS NOT null and a.PARK_OUT IS NOT null and a.PARK_IN IS NOT null"+
            " order by a.PARK_IN ";
			
			public static final String GET_ENROUTE_TAT_REPORT_DETAILS="select a.REGISTRATION_NO, a.TRIP_ID,a.OWNER_NAME, a.SHIPMENNT_ID, b.NAME as SOURCE_PLANT, DATEADD(mi,330,a.SOURCE_PLANT_OUT) as SOURCE_PLANT_OUT, c.NAME as DESTINATION_PLANT, isnull(DATEADD(mi,330,a.DESTINATION_PLANT_PARK_IN),'') as DESTINATION_PLANT_PARK_IN, isnull(DATEADD(mi,330,a.DESTINATION_PLANT_GATE_IN),'') as DESTINATION_PLANT_GATE_IN, isnull(a.ENROUTE_DISTANCE,'') as ENROUTE_DISTANCE, isnull(a.ENROUTE_TRANIT_TIME,'') as ENROUTE_TRANIT_TIME,  isnull(a.ENROUTE_STOPPAGE_TIME,'') as ENROUTE_STOPPAGE_TIME, isnull(a.DESTINATION_PLANT_OUTSIDE_WAITING_TIME,'') as DESTINATION_PLANT_OUTSIDE_WAITING_TIME, a.TRAILER_TYPE "
                                                                      +"from ENROUTE_TAT_REPORT_TEST a left outer join dbo.LOCATION_ZONE_A b on b.HUBID=a.SOURCE_PLANT "
                                                                      +"left outer join dbo.LOCATION_ZONE_A c on c.HUBID=a.DESTINATION_PLANT "
                                                                      +"left outer join Vehicle_association d on a.REGISTRATION_NO=d.Registration_no "
					                                                  +"where a.SOURCE_PLANT_OUT between ? and ? and a.SYSTEM_ID = ? and d.Client_id = ? order by a.SOURCE_PLANT_OUT";
			
			public static final String GET_ENROUTE_TAT_REPORT_DETAILS_SHIPX="select a.REGISTRATION_NO, a.TRIP_ID,a.OWNER_NAME, a.SHIPMENNT_ID, b.LOCATION_ID as SOURCE_PLANT, DATEADD(mi,330,a.SOURCE_PLANT_OUT) as SOURCE_PLANT_OUT, c.LOCATION_ID as DESTINATION_PLANT, isnull(DATEADD(mi,330,a.DESTINATION_PLANT_PARK_IN),'') as DESTINATION_PLANT_PARK_IN, isnull(DATEADD(mi,330,a.DESTINATION_PLANT_GATE_IN),'') as DESTINATION_PLANT_GATE_IN, isnull(a.ENROUTE_DISTANCE,'') as ENROUTE_DISTANCE, isnull(a.ENROUTE_TRANIT_TIME,'') as ENROUTE_TRANIT_TIME,  isnull(a.ENROUTE_STOPPAGE_TIME,'') as ENROUTE_STOPPAGE_TIME, isnull(a.DESTINATION_PLANT_OUTSIDE_WAITING_TIME,'') as DESTINATION_PLANT_OUTSIDE_WAITING_TIME, a.TRAILER_TYPE "
                +"from ENROUTE_TAT_REPORT_TEST a left outer join CARGO_STOP_POINT_DETAILS b on b.TRIP_ID=a.TRIP_ID AND b.TYPE = 'P '"
                +"left outer join CARGO_STOP_POINT_DETAILS c on c.TRIP_ID=a.TRIP_ID AND c.TYPE = 'D '"
                +"left outer join Vehicle_association d on a.REGISTRATION_NO=d.Registration_no "
                +"where a.SOURCE_PLANT_OUT between ? and ? and a.SYSTEM_ID = ? and d.Client_id = ? order by a.SOURCE_PLANT_OUT";
			
			
			
			
			//*****************************************************VERTICAL SUMMARY REPORT STATEMENTS : START ****************************************************************************//
			
			

			   public static final String GET_VERTICAL_REPORT ="select LANG_ENGLISH as VERTICAL_NAME,(select count(*) from AMS.dbo.VEHICLE_CLIENT (NOLOCK) where SYSTEM_ID!=12 and CLIENT_ID in (select CUSTOMER_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where PROCESS_ID=a.PROCESS_ID) ) as VEHICLE_COUNT "
				   +"from ADMINISTRATOR.dbo.PRODUCT_PROCESS a (NOLOCK) "
				   +"inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b (NOLOCK) on b.LABEL_ID=PROCESS_LABEL_ID "
				   +"where PROCESS_TYPE_LABEL_ID='Vertical_Sol'";


				public static final String GET_LTSP_REPORT ="select System_Name as LTSP_NAME,NAME as CUSTOMER_NAME,ll.LANG_ENGLISH as VERTICAL_NAME, "
					+"(select count(REGISTRATION_NUMBER) from AMS.dbo.VEHICLE_CLIENT where SYSTEM_ID=cm.SYSTEM_ID and CLIENT_ID=cm.CUSTOMER_ID) as VEHICLE_COUNT "
					+"from ADMINISTRATOR.dbo.CUSTOMER_MASTER cm "
					+"inner join AMS.dbo.System_Master sm on cm.SYSTEM_ID=sm.System_id "
					+"inner join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC cpa on cpa.SYSTEM_ID=cm.SYSTEM_ID and cpa.CUSTOMER_ID=cm.CUSTOMER_ID "
					+"inner join ADMINISTRATOR.dbo.PRODUCT_PROCESS pp on pp.PROCESS_ID=cpa.PROCESS_ID "
					+"inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION ll on ll.LABEL_ID=pp.PROCESS_LABEL_ID "
					+"where cm.SYSTEM_ID!=12 and pp.PROCESS_TYPE_LABEL_ID='Vertical_Sol'"
					+"and cm.CUSTOMER_ID in (select CUSTOMER_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where PROCESS_ID in (select PROCESS_ID from ADMINISTRATOR.dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Vertical_Sol')) "
					+"order by VEHICLE_COUNT desc,System_Name,NAME,cpa.PROCESS_ID,pp.PROCESS_LABEL_ID,ll.LANG_ENGLISH ";


				public static final String GET_REGION_REPORT ="select BUSINESS_GROUP as REGION_NAME,System_Name as LTSP_NAME,NAME as CUSTOMER_NAME,ll.LANG_ENGLISH as VERTICAL_NAME, "
					+"(select count(REGISTRATION_NUMBER) from AMS.dbo.VEHICLE_CLIENT where SYSTEM_ID=cm.SYSTEM_ID and CLIENT_ID=cm.CUSTOMER_ID) as VEHICLE_COUNT "
					+"from ADMINISTRATOR.dbo.CUSTOMER_MASTER cm "
					+"inner join AMS.dbo.System_Master sm on cm.SYSTEM_ID=sm.System_id "
					+"inner join CRC.dbo.BUSINESS_GROUP_MASTER bg on bg.ID=sm.CategoryTypeForBill "
					+"inner join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC cpa on cpa.SYSTEM_ID=cm.SYSTEM_ID and cpa.CUSTOMER_ID=cm.CUSTOMER_ID "
					+"inner join ADMINISTRATOR.dbo.PRODUCT_PROCESS pp on pp.PROCESS_ID=cpa.PROCESS_ID "
					+"inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION ll on ll.LABEL_ID=pp.PROCESS_LABEL_ID "
					+"where cm.SYSTEM_ID!=12 and pp.PROCESS_TYPE_LABEL_ID='Vertical_Sol' "
					+"and cm.CUSTOMER_ID in (select CUSTOMER_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where PROCESS_ID in (select PROCESS_ID from ADMINISTRATOR.dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Vertical_Sol')) "
					+"order by CATEGORY,BUSINESS_GROUP,System_Name,VEHICLE_COUNT desc,NAME,cpa.PROCESS_ID,pp.PROCESS_LABEL_ID,ll.LANG_ENGLISH ";
					

				  public static final String GET_CUSTOMER_REPORT="select 0 as ID,sm.System_id,a.CUSTOMER_ID,System_Name,COUNTRY,NAME,lan.LANG_ENGLISH as PROCESS_LABEL_ID,pp.PROCESS_ID,'' as VERTICAL_STREAM, "
				  +"(select count(REGISTRATION_NUMBER) from AMS.dbo.VEHICLE_CLIENT where SYSTEM_ID=a.SYSTEM_ID and CLIENT_ID=a.CUSTOMER_ID) as VEHICLE_COUNT, "
				  +"''as MORE_POTENTIAL,a.CREATED_TIME,'' as REASON_FOR_POTENTIAL_OPEN,'' as CRC_LAST_CALL_DATE,'' as CRC_LAST_CALL_DESC,'' as ISSUES,'' as CONTACT_PERSON,'' as CONTACT_NO "
				  +"from ADMINISTRATOR.dbo.CUSTOMER_MASTER a "
				  +"inner join AMS.dbo.System_Master sm on sm.System_id=a.SYSTEM_ID "
				  +"left outer join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC cpa on cpa.SYSTEM_ID=a.SYSTEM_ID and a.CUSTOMER_ID=cpa.CUSTOMER_ID "
				  +"left outer join ADMINISTRATOR.dbo.PRODUCT_PROCESS pp on pp.PROCESS_ID=cpa.PROCESS_ID "
				  +"inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION lan on lan.LABEL_ID=pp.PROCESS_LABEL_ID "
				  +"where CategoryTypeForBill=? and PROCESS_TYPE_LABEL_ID='Vertical_Sol' and a.CUSTOMER_ID not in (select CUSTOMER_ID from CRC.dbo.CUSTOMER_MASTER_REPORT) "
				  +"union all "
				  +"select ID,cmr.System_id,a.CUSTOMER_ID,System_Name,COUNTRY,NAME,lan.LANG_ENGLISH as PROCESS_LABEL_ID,pp.PROCESS_ID,VERTICAL_STREAM, "
				  +"(select count(REGISTRATION_NUMBER) from AMS.dbo.VEHICLE_CLIENT where SYSTEM_ID=a.SYSTEM_ID and CLIENT_ID=a.CUSTOMER_ID) as VEHICLE_COUNT, "
				  +"MORE_POTENTIAL,a.CREATED_TIME,REASON_FOR_POTENTIAL_OPEN,CRC_LAST_CALL_DATE,CRC_LAST_CALL_DESC,ISSUES,CONTACT_PERSON,CONTACT_NO "
				  +"from CRC.dbo.CUSTOMER_MASTER_REPORT cmr "
				  +"inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER a on cmr.SYSTEM_ID=a.SYSTEM_ID and cmr.CUSTOMER_ID=a.CUSTOMER_ID "
				  +"inner join AMS.dbo.System_Master sm on sm.System_id=a.SYSTEM_ID "
				  +"left outer join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC cpa on cpa.SYSTEM_ID=a.SYSTEM_ID and a.CUSTOMER_ID=cpa.CUSTOMER_ID "
				  +"left outer join ADMINISTRATOR.dbo.PRODUCT_PROCESS pp on pp.PROCESS_ID=cpa.PROCESS_ID "
				  +"inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION lan on lan.LABEL_ID=pp.PROCESS_LABEL_ID "
				  +"where CategoryTypeForBill=? and PROCESS_TYPE_LABEL_ID='Vertical_Sol' "
				  +"order by System_Name,NAME ";
											  
				  
				  public static final String GET_REGION="select distinct b.BUSINESS_GROUP as Region ,a.CategoryTypeForBill as id from AMS.dbo.System_Master a "
					  +"inner join CRC.dbo.BUSINESS_GROUP_MASTER b on b.ID=a.CategoryTypeForBill ";
				  
				  public static final String INSERT_CUSTOMER_INFORMATION=" insert into CRC.dbo.CUSTOMER_MASTER_REPORT(SYSTEM_ID,CUSTOMER_ID,VERTICAL_ID,VERTICAL_STREAM,VEHICLE_COUNT,MORE_POTENTIAL,CUSTOMER_CREATED_DATE, "
					  + " REASON_FOR_POTENTIAL_OPEN,CRC_LAST_CALL_DATE,CRC_LAST_CALL_DESC,ISSUES,CONTACT_PERSON,CONTACT_NO,UPDATED_DATETIME) "
					  + " values(?,?,?,?,?,?,?,?,?,?,?,?,?,getUtcDate()) ";
				  
				  
				  public static final String CHECK_IF_RECORD_PRESENT_IN_CUSTOMER_MASTER_REPORT_TABLE= " select VERTICAL_STREAM from CRC.dbo.CUSTOMER_MASTER_REPORT where SYSTEM_ID=? and CUSTOMER_ID=? ";
				  
				  public static final String  MOVE_RECORD_TO_CUSTOMER_MASTER_HISTORY=" insert into CRC.dbo.CUSTOMER_MASTER_REPORT_HISTORY(ID,SYSTEM_ID,CUSTOMER_ID,VERTICAL_ID,VERTICAL_STREAM, "
					  + " VEHICLE_COUNT,MORE_POTENTIAL,CUSTOMER_CREATED_DATE,REASON_FOR_POTENTIAL_OPEN,CRC_LAST_CALL_DATE,CRC_LAST_CALL_DESC,ISSUES,CONTACT_PERSON,CONTACT_NO,UPDATED_DATETIME) "
					  + " select * from CRC.dbo.CUSTOMER_MASTER_REPORT where SYSTEM_ID=? and CUSTOMER_ID=? ";
				  
				  public static final String UPDATE_CUSTOMER_MASTER_REPORT=" update CRC.dbo.CUSTOMER_MASTER_REPORT set VERTICAL_ID=?,VERTICAL_STREAM=?,VEHICLE_COUNT=?,MORE_POTENTIAL=?,CUSTOMER_CREATED_DATE=?, "
					  + " REASON_FOR_POTENTIAL_OPEN=?,CRC_LAST_CALL_DATE=?,CRC_LAST_CALL_DESC=?,ISSUES=?,CONTACT_PERSON=?,CONTACT_NO=?,UPDATED_DATETIME=getUtcDate() "
					  + " where SYSTEM_ID=? and CUSTOMER_ID=? ";
				  
				  
				  public static final String GET_DRIVERS_ASSOCIATE_TO_GROUP="select Driver_id,Fullname from Driver_Master where  System_id=? and Client_id=? and  GroupId=? and Race='Active'";
				  
				  public static final String GET_DRIVERS_FOR_CLIENT="select Driver_id,Fullname from Driver_Master where  System_id=? and Client_id=? and Race='Active'";
				  
				  public static final String GET_HUB_NAMES=" select HUBID,NAME from AMS.dbo.LOCATION where CLIENTID=? and SYSTEMID=? and OPERATION_ID=1 and RADIUS<>0 "
					  + " and HUBID not in (Select HUB_ID from ADMINISTRATOR.dbo.ASSET_GROUP where CUSTOMER_ID=? and SYSTEM_ID=? and HUB_ID is not null ) ";
				  
				  public static final String SELECT_CLIENT_LIST = "select isnull(NAME,'') as CustomerName,CUSTOMER_ID as CustomerId from ADMINISTRATOR.dbo.CUSTOMER_MASTER(NOLOCK) where SYSTEM_ID=? and ACTIVATION_STATUS='Complete' order by CustomerName";
				  
				  public static final String GET_ZONE_AND_OFFSET ="select System_id,Zone,OffsetMin from System_Master where System_id=?";
				  
				  public static final String GET_ASSET_DETAILS_FOR_REREGISTRATION="select a.RegistrationNo,isnull(c.VehicleType,'') as AssetType,ISNULL(e.GROUP_ID,'') AS GROUP_ID,  "+
				  " isnull(b.Unit_Number,'') as UnitNo,isnull(d.MOBILE_NUMBER,'') as MobileNumber, "+
				  " isnull(c.OwnerName,'') as OWNER_NAME,isnull(c.OWNER_ID,'') as OWNER_ID,isnull(c.OwnerAddress,'') as OWNER_ADDRESS,isnull(f.GROUP_NAME,'None') as GroupName, "+
				  " isnull(c.OwnerContactNo,'') as OWNER_PHONE_NO,isnull(c.VehicleAlias,'') as VehicleAlias,isnull(c.Model,'') as Model "+
				  " from AMS.dbo.VehicleRegistration (NOLOCK) a    "+
				  " left outer join AMS.dbo.tblVehicleMaster (NOLOCK) c on c.VehicleNo=a.RegistrationNo  "+
				  " left outer join AMS.dbo.VEHICLE_CLIENT (NOLOCK) e on e.REGISTRATION_NUMBER=a.RegistrationNo    " +
				  " left outer join AMS.dbo.VEHICLE_GROUP f (NOLOCK) on f.GROUP_ID=e.GROUP_ID   "+
				  " left outer join AMS.dbo.Vehicle_association (NOLOCK) b on b.Registration_no=a.RegistrationNo     "+
				  " left outer join ADMINISTRATOR.dbo.UNIT_MASTER (NOLOCK) d on d.UNIT_NUMBER collate database_default=b.Unit_Number  "+
				  " where a.RegistrationNo=? AND a.SystemId=? and e.CLIENT_ID=? ";
				  
				  public static final String UPDATE_ASSET_DETAILS_FOR_VEHICLEIOASSOCIATION="update AMS.dbo.VEHICLEIOASSOCIATION set VEHICLEID = ? where VEHICLEID = ? and SYSTEMID = ?";
				  
				  public static final String UPDATE_ASSET_DETAILS_FOR_VEHICLEOPASSOCIATION="update AMS.dbo.VEHICLEOPASSOCIATION set VEHICLEID = ? where VEHICLEID = ? and SYSTEMID = ?";
				  
				  public static final String CHECK_IF_EXISIST_IN_VEHICLE_CLIENT="SELECT UPPER(REGISTRATION_NUMBER) as REGISTRATION_NUMBER FROM AMS.dbo.VEHICLE_CLIENT WHERE SYSTEM_ID=? AND CLIENT_ID=? AND REGISTRATION_NUMBER= ? "; 
				  
				public static final String UPDATE_PAYMENT_DUE_NOTIFICATION_FOR_CUSTOMER="update ADMINISTRATOR.dbo.CUSTOMER_MASTER set PAYMENT_DUE_NOTIFICATION=? WHERE  SYSTEM_ID=? and CUSTOMER_ID=?";	
				
				 
				  public static final String UPDATE_CLIENT_GPSDATA_LIVE_CANIQ="update AMS.dbo.GPSDATA_LIVE_CANIQ set UNIT_NO=?,CLIENTID=? where  REGISTRATION_NO = ? and System_id = ?";
				 
				  public static final String UPDATE_LOCATION_GPSDATA_LIVE_CANIQ=" update AMS.dbo.GPSDATA_LIVE_CANIQ set LOCATION='No GPS Device Connected', "
						+ " UNIT_NO=null,LATITUDE=null,LONGITUDE=null,PREV_LONG=null,PREV_LAT=null,ISLATEST='N', "
						+ " ODOMETER='0',SPEED='0'"
						+ " where  REGISTRATION_NO = ? and System_id = ? " ;
				  
				  public static final String GET_VEHICLE_NUMBERS_FOR_SCC_MASTER = " Select REGISTRATION_NO as VehicleNo from AMS.dbo.gpsdata_history_latest where System_id = ? and CLIENTID = ? order by REGISTRATION_NO " ;

				  public static final String CHECK_BLOCKED_VEHICLE_DETAILS ="select REGISTRATION_NO from AMS.dbo.SAND_BLOCKED_VEHICLE_DETAILS";

	public static final String GET_LTSP_SUBSCRIPTION_DETAILS = "select isnull(System_Name,'') as LTSP_NAME,isnull(NAME,'') as CUSTOMER_NAME,isnull(DISTRICT_NAME,'') as DISTRICT_NAME," +
			" isnull(WORK_ORDER_ISSUED,'') as WORK_ORDER_ISSUED,isnull(START_DATE,'')as START_DATE,isnull(END_DATE,'') as END_DATE,SUBSCRIPTION_DURATION,AMOUNT_PER_MONTH,TOTAL_AMOUNT,INSERTED_DATETIME,isnull(SUBSCRIPTION_STATUS,'Register') as SUBSCRIPTION_STATUS,MOPER_AMOUNT " +
			" from Billing.dbo.LTSP_SUBSCRIPTION_DETAILS a" +
			" left outer join AMS.dbo.System_Master b on b.System_id=a.SYSTEM_ID" +
			" left outer join ADMINISTRATOR.dbo.CUSTOMER_MASTER c on a.CUSTOMER_ID = c.CUSTOMER_ID " +
			" order by ID desc "; 
	
	public static final String CHECK_LTSP_SUBSCRIPTION_DETAILS_EXIST = " select * from Billing.dbo.LTSP_SUBSCRIPTION_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? ";
	
	public static final String INSERT_LTSP_SUBSCRIPTION_DETAILS = " insert into Billing.dbo.LTSP_SUBSCRIPTION_DETAILS (WORK_ORDER_ISSUED,START_DATE,END_DATE,SUBSCRIPTION_DURATION,AMOUNT_PER_MONTH,TOTAL_AMOUNT,SYSTEM_ID,CUSTOMER_ID,DISTRICT_NAME,MOPER_AMOUNT,SUBSCRIPTION_STATUS)" +
			" values (?,?,?,?,?,?,?,?,?,?,?) ";

	public static final String GET_USER_SYSTEM_CUST_IDS_AND_DETAILS =" select User_id as UserId,System_id as System_Id, Client_id as Client_Id ,Firstname+' '+Lastname as Full_Name, Emailed as User_MailId,Status from AMS.dbo.Users where upper(Login_name)=? ";

	public static final String GET_NAME_AND_PASSWORD = "select isnull(User_password,'') as User_password,Firstname,Lastname,Login_name from AMS.dbo.Users where System_id=?  and User_id=?";

	public static final String GET_PASSWORD_HIST = "select Password from AMS.dbo.User_Password_History where System_Id=?  and User_Id=? order by CreatedTime desc";
	
	public static final String MOVE_PASSWORD_HIST = "insert into AMS.dbo.User_Password_History(User_Id,System_Id,Customer_Id,Password,CreatedTime,Password_Link_SessionId) select User_id,System_id,Client_id,User_password,getutcdate(),Password_Link_SessionId from AMS.dbo.Users where System_id=? and Client_id=? and User_id=? and User_password!='' and User_password is not null";

	public static final String INSERT_INTO_AUDIT_LOG_DETAILS = " insert into ADMINISTRATOR.dbo.AUDIT_LOG_DETAILS (SESSION_ID,PAGE_NAME,ACTION,SERVER,USER_ID,SYSTEM_ID,INSERTED_DATETIME,CUSTOMER_ID,REMARKS) values "+
			" (?,?,?,?,?,?,getutcdate(),?,?)" ;
	
	public static final String INSERT_INTO_AUDIT_LOG_ACTION_DETAILS = "  insert into ADMINISTRATOR.dbo.AUDIT_LOG_ACTION_DETAILS (LOG_ID,TABLE_NAME,TABLE_ACTION) values  " +
			" (?,?,?)" ;
	public static final String GET_USER_DETAILS = " select (u.FIRST_NAME+' '+u.MIDDLE_NAME+' '+u.LAST_NAME) as USER_NAME,u.PHONE,u.EMAIL,u.USERAUTHORITY,u.CREATED_TIME, " +
			" ISNULL((ui.FIRST_NAME+' '+ui.MIDDLE_NAME+' '+ui.LAST_NAME),'') AS CREATED_BY from ADMINISTRATOR.dbo.USERS u " +
			" left outer join USERS ui on ui.USER_ID=u.CREATED_BY and ui.SYSTEM_ID=u.SYSTEM_ID " +
			" where u.USER_ID=? AND u.SYSTEM_ID=? ";
	
	public static final String GET_AUDIT_LOG_REPORT_FOR_ALL = " SELECT (u.FIRST_NAME+' '+u.LAST_NAME) AS USER_NAME,isnull(PAGE_NAME,'') as PAGE_NAME," +
			" isnull(ACTION,'') as ACTION,isnull(REMARKS,'') as REMARKS,dateadd(mi,?,INSERTED_DATETIME) AS INSERTED_DATETIME ,dateadd(mi,?,REQUEST_TIME) AS REQUEST_TIME ,dateadd(mi,?,RESPONSE_TIME) AS RESPONSE_TIME " +
			" FROM ADMINISTRATOR.dbo.AUDIT_LOG_DETAILS a " + 
			" left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=a.USER_ID " + 
			" WHERE a.SYSTEM_ID=? and u.USER_ID in (SELECT USER_ID FROM ADMINISTRATOR.dbo.USERS u where SYSTEM_ID=? and CUSTOMER_ID=?)" + 
			" and SERVER=? ## order by ID desc" ;// and INSERTED_DATETIME between dateadd(dd,-1,getdate()) and getdate();]

	//t4u506 added 2 columns above n below methods
	
	public static final String GET_AUDIT_LOG_REPORT = " SELECT (u.FIRST_NAME+' '+u.LAST_NAME) AS USER_NAME,isnull(PAGE_NAME,'') as PAGE_NAME," +
			" isnull(ACTION,'') as ACTION,isnull(REMARKS,'') as REMARKS,dateadd(mi,?,INSERTED_DATETIME) AS INSERTED_DATETIME ,dateadd(mi,?,REQUEST_TIME) AS REQUEST_TIME ,dateadd(mi,?,RESPONSE_TIME) AS RESPONSE_TIME " +
			" FROM ADMINISTRATOR.dbo.AUDIT_LOG_DETAILS a " +
			" left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=a.USER_ID " +
			" WHERE a.SYSTEM_ID=? and a.USER_ID=? and SERVER=? ## order by ID desc";


	public static final String MODIFY_USER_IN_AMS_NEW_new1 = "update AMS.dbo.Users set Login_name=?,Firstname=?,Lastname=?,Telephone=?,Emailed=?,BranchId=?,Status=?,FmsUserAuthority=?,Password_Link_SessionId=?,Imprecise_Location_Setting=?,ROLE_ID=? where User_id=? and Client_id=? and System_id=?";

	public static final String ModifyUserDetailsNew1 = "update dbo.USERS set USER_NAME=?, FIRST_NAME=?,MIDDLE_NAME=?, LAST_NAME=?, PHONE=?, EMAIL=?,BRANCH_ID=?, USERAUTHORITY=?, STATUS=?, MOBILE_NUMBER=?,FAX=? ,PROCESS_ID=?, Imprecise_Location_Setting =?,ROLE_ID = ?  where USER_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? ";

	public static final String SAVE_USER_HUB_ASSOC = "insert into UserHubAssociation(UserId,HubId,ClientId,SystemId,UpdatedDateTime) values (?,?,?,?,getUtcDate())";

	public static final String SELECT_USER_LIST_FOR_CLIENT ="select USER_ID as User_id from ADMINISTRATOR.dbo.USERS where SYSTEM_ID = ? and CUSTOMER_ID = ? and STATUS='Active' ";
	
		
	public static final String CHECK_IF_LTSP_SUBSCRIPTION_DETAILS_FOR_SUBSCRIPTION_VALIDATION = "Select INSERTED_DATETIME,SUBSCRIPTION_DURATION,AMOUNT_PER_MONTH from Billing.dbo.LTSP_SUBSCRIPTION_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? ";
	
	public static final String SELECT_DETAILS_FROM_VEHICLE_SUBSCRIPTION_DETAILS = "select END_DATE,case when END_DATE>dateadd(dd,0,getdate()) then 'valid' else 'Invalid' end as validity  from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS Where VEHICLE_NO=? "+ 
								" and  SYSTEM_ID=? and CUSTOMER_ID=? "+ 
								" and END_DATE=(select MAX(END_DATE) from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS" +
								" where VEHICLE_NO=? and  SYSTEM_ID=? and CUSTOMER_ID=?)";
	
	public static final String INSERT_INTO_VEHICLE_SUBSCRIPTION_DETAILS = "Insert into AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS "
								+ "(SYSTEM_ID,CUSTOMER_ID,USER_ID,VEHICLE_NO,START_DATE,END_DATE,MODE_OF_PAYMENT,TOTAL_AMOUNT,SUBSCRIPTION_DURATION,VEHICLE_STATUS,INSERTED_BY,INSERTED_DATETIME,REMAINDER_DATE,SUBSCRIPTION_STATUS,BILLING_STATUS)"
								+ "values(?,?,?,?,convert (varchar,dateadd(mi,?,getutcdate()),120), convert (varchar,dateadd(mm, ?,dateadd(mi,?,getutcdate())),120),'DD/Recipt', ?,?,'Active',?,dateadd(mi,?,getutcdate()),  convert (varchar,dateadd(mm, ?,dateadd(mi,?,getutcdate())-10),120),'Subscription','Billable')";
	
	public static final String GET_ROUTE_DETAILS = " select * from TRIP_ROUTE_MASTER WHERE ID=? " ;
	public static final String INSERT_VEHICLE_IN_GPSDATA_LIVE_CANIQ = "insert into GPSDATA_LIVE_CANIQ(SLNO,REGISTRATION_NO,UNIT_NO,GMT,GPS_DATETIME,System_id,CLIENTID,OFFSET) values(?,?,?,getutcdate(),getdate(),?,?,?)";
	
	public static final String SELECT_REGISTRATION_NO_FROM_USER_VEHICLE = " select isnull(a.RegistrationNo,'') as VehicleNo,e.CLIENT_ID    from AMS.dbo.VehicleRegistration (NOLOCK) a" 
	+ " left outer join AMS.dbo.Users u on a.RegisteredBy=u.User_id and a.SystemId = u.System_id "
	+ " left outer join AMS.dbo.tblVehicleMaster (NOLOCK) c on c.VehicleNo=a.RegistrationNo "   
	+ " left outer join AMS.dbo.VEHICLE_CLIENT (NOLOCK) e on e.REGISTRATION_NUMBER=a.RegistrationNo "  
	+ " left outer join AMS.dbo.Vehicle_association (NOLOCK) b on b.Registration_no=a.RegistrationNo "   
	+ " left outer join ADMINISTRATOR.dbo.UNIT_MASTER (NOLOCK) d on d.UNIT_NUMBER collate database_default=b.Unit_Number and b.System_id=d.SYSTEM_ID "
	+ " left outer join AMS.dbo.VEHICLE_GROUP f (NOLOCK) on f.GROUP_ID=e.GROUP_ID and f.SYSTEM_ID=e.SYSTEM_ID and f.CLIENT_ID=e.CLIENT_ID " 
	+ " left outer join FMS.dbo.Vehicle_Model g on g.ModeltypeId=c.Model and g.SystemId=c.System_id "
	+ " inner join AMS.dbo.Vehicle_User vu (NOLOCK) on a.RegistrationNo=vu.Registration_no and a.SystemId=vu.System_id "
	+ " where vu.User_id=? and a.SystemId=? and a.Status='Active' and c.Status='Active' ";
	
	public static final String INSERT_INTO_AUDIT_LOG_DETAILS_MAPLOGS = " insert into ADMINISTRATOR.dbo.AUDIT_LOG_DETAILS (SESSION_ID,PAGE_NAME,ACTION,SERVER,USER_ID,SYSTEM_ID,INSERTED_DATETIME,CUSTOMER_ID,REMARKS,REQUEST_TIME,RESPONSE_TIME) values "+
	" (?,?,?,?,?,?,getutcdate(),?,?,?,?)" ;
	//t4u506 changed ADMINISTRATOR.dbo.AUDIT_LOG_DETAILS reqStartTime and reqEndTime

	public static final String GET_STATE_LIST = "select STATE_CODE,STATE_NAME,isnull(REGION,'') as REGION from dbo.STATE_DETAILS where COUNTRY_CODE=? and STATE_NAME=? order by STATE_NAME asc";
	
	public static final String CHECK_USER_PROCESS_PERMISSION = "select * from ADMINISTRATOR.dbo.USER_PROCESS_DETACHMENT "+
																" where USER_ID=? and SYSTEM_ID =? and MENU_ID in ( "+
																" select MENU_ID from ADMINISTRATOR.dbo.MENU_MASTER "+
																" where ELEMENT_ID in (select ELEMENT_ID from ADMINISTRATOR.dbo.PRODUCT_ELEMENT " +
																" where ELEMENT_NAME=?))";
	
	public static final String INSERT_INTO_EMAIL_QUEUE_HISTORY="insert into AMS.dbo.EmailQueueHistory(Slno,Subject,Body,EmailList,SentDate,DateTime,SystemId) values(?,?,?,?,?,getdate(),?) ";

	public static final String INSERT_INTO_EMAIL_FAILURE_HISTORY="insert into AMS.dbo.EmailFailureHistory(Slno,Subject,Body,EmailList,SentDate,DateTime,SystemId) values(?,?,?,?,?,getdate(),?) ";

	public static final String UPDATE_UNIT_NO_IN_MOBILEYE_LIVE = " update AMS.dbo.MOBILEYE_LIVE set UNIT_NO=? where REGISTRATION_NO=? and SYSTEM_ID=? ";
	
	public static final String CHECK_IF_MOB_NO_IS_ASSOCIATED_TO_UNIT_NO_IN_AMS = "select isnull(SIM_NUMBER,'') as SIM_NUMBER,*  from  AMS.dbo.Unit_Master "+ 
	 " where Unit_number = ? and System_id = ?";
	
	public static final String UPDATE_MOBILE_NUMBER_EMPTY_AMS = " update AMS.dbo.Unit_Master  set SIM_NUMBER = '' where Unit_number = ? and System_id = ? ";
	
	public static final String UPDATE_MOBILE_NUMBER_IN_AMS = "update AMS.dbo.Unit_Master set SIM_NUMBER = ? where Unit_number = ? and System_id = ?";
	
	
	public static final String CHECK_IF_MOB_NO_IS_ASSOCIATED_TO_UNIT_NO_IN_ADMIN =
		"select isnull(MOBILE_NUMBER,'') as MOB_NUMBER,*  from  ADMINISTRATOR.dbo.UNIT_MASTER um "+
		" where UNIT_NUMBER = ? and um.System_id = ?";

	public static final String UPDATE_MOBILE_NUMBER_EMPTY_ADMIN = " update ADMINISTRATOR.dbo.UNIT_MASTER  set MOBILE_NUMBER = '' where UNIT_NUMBER = ? and SYSTEM_ID = ? ";
	
	public static final String UPDATE_MOBILE_NUMBER_IN_ADMIN = "update ADMINISTRATOR.dbo.UNIT_MASTER set MOBILE_NUMBER = ? where UNIT_NUMBER = ? and SYSTEM_ID = ?";
	
	public static final String GET_UNIT_NO  = "select isnull(UNIT_NUMBER,'') as unitNumber ,* from ADMINISTRATOR.dbo.UNIT_MASTER  where MOBILE_NUMBER = ? and SYSTEM_ID = ?";
	
	public static final String INSERT_TO_VEHICLE_REGISTRATION_TRANSACTION = "INSERT INTO VEHICLE_REGISTRATION_TRANSACTION  (ASSET_TYPE,REGISTRATION_NO,GROUP_ID,UNIT_NO,MOBILE_NUMBER," +
		" SYSTEM_ID,USER_ID,OFFSET,CUSTOMER_ID,LTSP_NAME,GROUP_NAME,CUSTOMER_NAME,ASSET_MODEL,OWNER_NAME,OWNER_ADDRESS,OWNER_PHONE_NUMBER,ASSET_ID,ZONE," +
		" OWNER_ID,SELECTED_CHECK_BOX,PAGE_NAME,SESSION_ID,SERVER_NAME,FLAG,UNIQUE_PAYMENY_KEY,EMAIL_ID,PAYMENT_REQUEST_DATE,AMOUNT,INSERTED_DATE,INVOICE_ID,PAYMENT_STATUS,PAYMENT_REQUEST_STATUS_CODE,REQUEST_TYPE,RENEWAL_START,RENEWAL_END,VEHICLE_SUB_ID,REGISTRATION_STATUS) " +
		" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,GETUTCDATE(),?,GETUTCDATE(),?,?,?,?,?,?,?,'Payment Awaited')";
	
	public static final String UPDATE_TRANSACTION = " UPDATE VEHICLE_REGISTRATION_TRANSACTION SET  INVOICE_ID = ?,PAYMENT_STATUS = ?,PAYMENT_REQUEST_STATUS_CODE = ?,UPDATED_DATE = GETUTCDATE() WHERE UNIQUE_PAYMENY_KEY = ?";
	
	public static final String GET_PAYMENT_TRANSACTIONS = "SELECT ISNULL(ASSET_TYPE,'') AS ASSET_TYPE,ISNULL(REGISTRATION_NO,'') AS REGISTRATION_NO , " +
			" ISNULL(GROUP_ID,0) AS GROUP_ID ,ISNULL(UNIT_NO,'')AS UNIT_NO, ISNULL(MOBILE_NUMBER,'') AS MOBILE_NUMBER,SYSTEM_ID,USER_ID,OFFSET, " +
			" CUSTOMER_ID,ISNULL(LTSP_NAME,'') AS LTSP_NAME ,ISNULL(GROUP_NAME,'')AS GROUP_NAME,ISNULL(CUSTOMER_NAME,'')AS CUSTOMER_NAME,ISNULL(REQUEST_TYPE,'') AS REQUEST_TYPE, " +
			" ISNULL(ASSET_MODEL,'')AS ASSET_MODEL,ISNULL(OWNER_NAME,'') AS OWNER_NAME,ISNULL(OWNER_ADDRESS,'')AS OWNER_ADDRESS," +
			" ISNULL(OWNER_PHONE_NUMBER,'') AS OWNER_PHONE_NUMBER,ISNULL(ASSET_ID,'') AS ASSET_ID,ISNULL(ZONE,'') AS ZONE,ISNULL(UNIQUE_PAYMENY_KEY,'') AS UNIQUE_PAYMENY_KEY, " +
			" ISNULL(EMAIL_ID,'') AS EMAIL_ID,ID,	ISNULL(PAYMENT_STATUS,'')AS PAYMENT_STATUS,ISNULL(INVOICE_ID ,'')AS INVOICE_ID, " +
			" ISNULL(AMOUNT,'0.00') AS AMOUNT,	ISNULL(REGISTRATION_STATUS,'') AS REGISTRATION_STATUS,ISNULL(DATEADD(MI,?,INSERTED_DATE),'') AS  INSERTED_DATE , " +
			" ISNULL(DATEADD(MI,?,REGISTRATION_DATE),'') AS REGISTRATION_DATE, ISNULL(DATEADD(MI,?,PAYMENT_RESPONSE_DATE),'') AS PAYMENT_RESPONSE_DATE	 FROM VEHICLE_REGISTRATION_TRANSACTION  " +
			" WHERE SYSTEM_ID = ? AND CUSTOMER_ID = ? AND INSERTED_DATE BETWEEN DATEADD(MI,-?,?) AND DATEADD(MI,-?,?) ";
	
	public static final String GET_PAYMENT_TRANSACTION_BY_ID = "SELECT ISNULL(ASSET_TYPE,'') AS ASSET_TYPE,ISNULL(REGISTRATION_NO,'') AS REGISTRATION_NO , " +
			" ISNULL(GROUP_ID,0) AS GROUP_ID ,ISNULL(UNIT_NO,'')AS UNIT_NO, ISNULL(MOBILE_NUMBER,'') AS MOBILE_NUMBER,SYSTEM_ID,USER_ID,OFFSET, " +
			" CUSTOMER_ID,ISNULL(LTSP_NAME,'') AS LTSP_NAME ,ISNULL(GROUP_NAME,'')AS GROUP_NAME,ISNULL(CUSTOMER_NAME,'')AS CUSTOMER_NAME, " +
			" ISNULL(ASSET_MODEL,'')AS ASSET_MODEL,ISNULL(OWNER_NAME,'') AS OWNER_NAME,ISNULL(OWNER_ADDRESS,'')AS OWNER_ADDRESS," +
			" ISNULL(OWNER_PHONE_NUMBER,'') AS OWNER_PHONE_NUMBER,ISNULL(ASSET_ID,'') AS ASSET_ID,ISNULL(ZONE,'') AS ZONE,ISNULL(UNIQUE_PAYMENY_KEY,'') AS UNIQUE_PAYMENY_KEY, " +
			" ISNULL(EMAIL_ID,'') AS EMAIL_ID,ID,	ISNULL(PAYMENT_STATUS,'')AS PAYMENT_STATUS,ISNULL(INVOICE_ID ,'')AS INVOICE_ID, " +
			" ISNULL(AMOUNT,'0.00') AS AMOUNT,	ISNULL(REGISTRATION_STATUS,'') AS REGISTRATION_STATUS,ISNULL(OWNER_ID,'') AS OWNER_ID,ISNULL(SELECTED_CHECK_BOX,'') AS SELECTED_CHECK_BOX,ISNULL(PAGE_NAME,'') AS PAGE_NAME,ISNULL(SESSION_ID,'') AS SESSION_ID,  " +
			" ISNULL(SERVER_NAME,'') AS SERVER_NAME,	ISNULL(FLAG,'') AS FLAG,ISNULL(EMAIL_ID,'') AS EMAIL_ID,ISNULL(RENEWAL_START,'') AS START_DATE,ISNULL(RENEWAL_END,'') AS END_DATE,ISNULL(VEHICLE_SUB_ID,'') AS VEHICLE_SUB_ID,ISNULL(REQUEST_TYPE,'') AS REQUEST_TYPE  " +
			" FROM VEHICLE_REGISTRATION_TRANSACTION  WHERE ID = ? ";
	
	public static final String UPDATE_TRANSACTION_TABLE = "UPDATE VEHICLE_REGISTRATION_TRANSACTION SET PAYMENT_STATUS = ?  WHERE ID = ? ";
	
	public static final String GET_TBL_VEHICLE_MASTER = "SELECT ISNULL(OwnerName,'') AS OwnerName,ISNULL(OwnerAddress,'') AS OwnerAddress,ISNULL(OwnerContactNo,'')AS OwnerContactNo,OWNER_ID,ISNULL(OwnerEmailId,'') AS OwnerEmailId  FROM tblVehicleMaster WHERE VehicleNo = ? AND System_id = ?";
	
	public static final String GET_VEHICLE_SUBSCRIPTION_DETAILS_BY_SYSTEM_ID_CUSTOMER_ID = "SELECT * FROM  Billing.dbo.LTSP_SUBSCRIPTION_DETAILS a  WHERE SYSTEM_ID = ? AND CUSTOMER_ID = ?";
	
}


