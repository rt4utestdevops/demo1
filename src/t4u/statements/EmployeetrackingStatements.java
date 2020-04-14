package t4u.statements;

public class EmployeetrackingStatements {

	/**
	 * To fetch LTSP id and name from System_MASTER table
	 */
	public static final String 
	GET_LTSP ="select System_id,System_Name from System_Master order by System_Name asc";
	/**
	 * To fetch User id and name from CRC.dbo.USERS table
	 */
	public static final String GET_USER = "select USER_ID,USER_NAME from CRC.dbo.USERS where USER_TYPE_ID in (1,2,3)";
	/**
	 * To fetch Vehicle Registration, Unit No and Unit type from dbo.Vehicle_association and dbo.Unit_Type_Master table
	 */
	public static final String GET_VEHICLES = "select a.Registration_no,a.Unit_Number,b.UNIT_NAME as Unit_type_desc,c.VehicleAlias from dbo.Vehicle_association a inner join ADMINISTRATOR.dbo.UNIT_TYPE b on a.Unit_Type_Code=b.UNIT_TYPE_CODE "+
										" left outer join tblVehicleMaster c on a.Registration_no=c.VehicleNo where a.System_id=? and a.Client_id=?";
	
	/**
	 * To fetch Vehicle Last Packet Date Time and Location from dbo.gpsdata_history_latest table depending on Registration No and System Id
	 */
	public static final String GET_GPS_DATETIME_LOCATION = "select GPS_DATETIME,LOCATION from dbo.gpsdata_history_latest where REGISTRATION_NO=? and System_id=? and CLIENTID=?";
	
	
	/**
	 * To fetch hid  from ALERT.dbo.SWIPE_DATA table depending on Registration No and System Id and customerId
	 */
	public static final String GET_HID = "select top 1 LOCAL_TIME from ALERT.dbo.SWIPE_DATA where REGISTRATION_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? order by GMT desc";
	/**
	 * To fetch panic data from dbo.Alert table depending on Registration No and System Id
	 */
	public static final String GET_PANIC = "select top 1 GPS_DATETIME from dbo.Alert where REGISTRATION_NO=? and TYPE_OF_ALERT=3 and SYSTEM_ID=? order by GMT desc";
	
	/**
	 * To fetch overspeed from dbo.Alert and table depending on Registration No and System Id
	 */
	public static final String GET_OVERSPEED = "select top 1 GPS_DATETIME from dbo.Alert where REGISTRATION_NO=? and TYPE_OF_ALERT=2 and SYSTEM_ID=? order by GMT desc";
	/**
	 * To fetch tripsheet from System_Master table depending on Registration No and System Id and clientId
	 */
	public static final String GET_TRIPSHEET = "select top 1 dateadd(mi,OffsetMin,InsertedDateTime) as Date from dbo.BPO_Trip_Details inner join System_Master on System_id=SystemId where VehicleNo=? and SystemId=? and ClientId=? order by InsertedDateTime desc";
	/**
	 * To fetch overspeed email from dbo.Alert table depending on Registration No and System Id
	 */
	public static final String GET_OVERSPEED_EMAIL = "select top 1 GPS_DATETIME from dbo.Alert where REGISTRATION_NO=? and TYPE_OF_ALERT=2 and EMAIL_STATUS='Y' and SYSTEM_ID=? order by GMT desc";
	/**
	 * To fetch overspeed SMS from dbo.Alert table depending on Registration No and System Id
	 */
	public static final String GET_OVERSPEED_SMS = "select top 1 GPS_DATETIME from dbo.Alert where REGISTRATION_NO=? and TYPE_OF_ALERT=2 and SMS_STATUS='Y' and SYSTEM_ID=? order by GMT desc";
	/**
	 * To fetch distress email from dbo.Alert table depending on Registration No and System Id
	 */
	public static final String GET_DISTRESS_EMAIL = "select top 1 GPS_DATETIME from dbo.Alert where REGISTRATION_NO=? and TYPE_OF_ALERT=3 and EMAIL_STATUS='Y' and SYSTEM_ID=? order by GMT desc";
	/**
	 * To fetch  distress alert from dbo.Alert table depending on Registration No and System Id
	 */
	public static final String GET_DISTRESS_SMS = "select top 1 GPS_DATETIME from dbo.Alert where REGISTRATION_NO=? and TYPE_OF_ALERT=3 and SMS_STATUS='Y' and SYSTEM_ID=? order by GMT desc";
	/**
	 * Saving the value of EmployeeTrackingDetails into the table dbo.DAILY_TASK_TRACKER
	 */
	public static final String SAVE_EMPLOYEETRACKING_DETAILS = "insert into dbo.DAILY_TASK_TRACKER(SYSTEM_ID,CUSTOMER_ID,USER_ID,REGISTRATION_NO,REPORTING_TIME,EXIT_TIME,NEW_INSTALL,UN_INSTALL,UP_KEEP,SOFTWARE,IMEI_NO,DEVICE_ID,GPS_TIME_REMARKS,LOCATION_REMARKS,LAST_SWIPE_REMARKS,LAST_PANIC_REMARKS,LAST_OS_REMARKS,LAST_TRIP_SHEET_REMARKS,LAST_OS_EMAIL_REMARKS,LAST_OS_SMS_REMARKS,LAST_PANIC_EMAIL_REMARKS,LAST_PANIC_SMS_REMARKS) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	/**
	 * Checking the tracking record already exist or not  
	 */
	public static final String CHECK_EMP_TRACKING_EXISTS = "select REGISTRATION_NO from dbo.DAILY_TASK_TRACKER where SYSTEM_ID=? and CUSTOMER_ID=? and USER_ID=? and  REGISTRATION_NO=? and convert(varchar(10),REPORTING_TIME,120)=convert(varchar(10),?,120)";
	/**
	 * To fetch  reporting and exit time from dbo.DAILY_TASK_TRACKER table depending on  System Id and user Id
	 */
	public static final String GET_REPORTEXITTIME = "select top 1 USER_ID, REPORTING_TIME, EXIT_TIME from dbo.DAILY_TASK_TRACKER where SYSTEM_ID=? and USER_ID=? order by REPORTING_TIME desc";
	
	public static final String Save_EmployeeTracking_Details = null;
	public static final String GET_DISTINCT_DATE = "select distinct dateadd(mi,sm.OffsetMin,VDS.DATE) as DATE from dbo.VEHICLE_DAILY_STATUS VDS left outer join dbo.System_Master sm on sm.System_id=VDS.SYSTEM_ID where VDS.DATE between dateadd(mi,-sm.OffsetMin,?) and dateadd(mi,-sm.OffsetMin,?) and SYSTEM_ID=? and CUSTOMER_ID=? and DATE is not null order by DATE asc";
	
	public static final StringBuilder GET_STATUS_REPORT = new StringBuilder("select dateadd(mi,sm.OffsetMin,VDS.DATE) as DATE, isnull(VDS.REGISTRATION_NO,'') as REGISTRATION_NO, isnull(VDS.VEHICLE_ID,'') as VEHICLE_ID, isnull(VDS.LOCATION,'') as LOCATION, isnull(VDS.GPS_TIME,'') as GPS_TIME, dateadd(mi,sm.OffsetMin,VDS.GMT) as GMT, dateadd(mi,sm.OffsetMin,VDS.LAST_OS) as LAST_OS, dateadd(mi,sm.OffsetMin,VDS.LAST_PANIC) as LAST_PANIC, dateadd(mi,sm.OffsetMin,VDS.LAST_SWIPE) as LAST_SWIPE, dateadd(mi,sm.OffsetMin,VDS.LAST_TRIP_SHEET) as LAST_TRIP_SHEET, dateadd(mi,sm.OffsetMin,VDS.LAST_OS_EMAIL) as LAST_OS_EMAIL, dateadd(mi,sm.OffsetMin,VDS.LAST_OS_SMS) as LAST_OS_SMS, dateadd(mi,sm.OffsetMin,VDS.LAST_PANIC_EMAIL) as LAST_PANIC_EMAIL, dateadd(mi,sm.OffsetMin,VDS.LAST_PANIC_SMS) as LAST_PANIC_SMS,isnull(VA.Unit_Number,'') as Unit_Number, isnull(UTM.UNIT_NAME,'') as Unit_Type,isnull(VM.OwnerName,'') as OwnerName from dbo.VEHICLE_DAILY_STATUS VDS left outer join dbo.Vehicle_association VA on VA.Client_id=VDS.CUSTOMER_ID and VA.System_id=VDS.SYSTEM_ID and VA.Registration_no=VDS.REGISTRATION_NO left outer join ADMINISTRATOR.dbo.UNIT_TYPE UTM on UTM.UNIT_TYPE_CODE=VA.Unit_Type_Code left outer join dbo.tblVehicleMaster VM on VM.VehicleNo=VDS.REGISTRATION_NO and VM.System_id=VDS.SYSTEM_ID left outer join dbo.System_Master sm on sm.System_id=VDS.SYSTEM_ID where DATE between dateadd(mi,-sm.OffsetMin,?) and dateadd(mi,-sm.OffsetMin,?) and SYSTEM_ID=? and CUSTOMER_ID=? order by VDS.REGISTRATION_NO,VDS.DATE asc");
	public static final String GET_TRACKER_REPORT = "select distinct cast((convert(varchar(10),dateadd(mi,sm.OffsetMin,DTT.REPORTING_TIME),120)+' 00:00:00.000') as datetime) as DATE,DTT.REGISTRATION_NO,DTT.LAST_OS_REMARKS,DTT.LAST_PANIC_REMARKS,DTT.LAST_SWIPE_REMARKS,DTT.LAST_TRIP_SHEET_REMARKS,DTT.LAST_OS_EMAIL_REMARKS,DTT.LAST_OS_SMS_REMARKS,DTT.LAST_PANIC_EMAIL_REMARKS,DTT.LAST_PANIC_SMS_REMARKS from dbo.DAILY_TASK_TRACKER DTT left outer join dbo.System_Master sm on sm.System_id=DTT.SYSTEM_ID where DTT.REPORTING_TIME between dateadd(mi,-sm.OffsetMin,?) and dateadd(mi,-sm.OffsetMin,?) and SYSTEM_ID=? and CUSTOMER_ID=? order by DTT.REGISTRATION_NO,DATE asc";
	public static final String GET_TRACKER_DATE = "select distinct DD as DATE from (select cast((convert(varchar(10),REPORTING_TIME,120)+' 00:00:00.000') as datetime) as DD from DAILY_TASK_TRACKER) R order by DATE";
	
	public static final String GET_MANAGE_ROUTE_DETAILS = " select erm.ROUTE_ID,isnull(CUSTOMER_ROUTE_ID,'') as CUSTOMER_ROUTE_ID,isnull(START_TIME,0) as START_TIME,isnull(END_TIME,0) as END_TIME,isnull(DISTANCE,0) as DISTANCE,isnull(DURATION,0) as DURATION,isnull(earm.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(erm.TYPE,'') as TYPE,isnull (dateadd(mi,?,erm.UPDATED_DATETIME),'') as UPDATED_DATETIME from AMS.dbo.ETMS_ROUTE_MASTER erm "+
	                                                      " left outer join AMS.dbo.ETMS_ASSET_ROUTE_MAPPING earm on earm.ROUTE_ID = erm.ROUTE_ID "+
	                                                      " where erm.SYSTEM_ID=? and erm.CUSTOMER_ID=? ";
	
	public static final String GET_VEHICLE_USING_CLIENTID_FOR_MANAGE_ROUTE = "select REGISTRATION_NUMBER from VEHICLE_CLIENT vc, Vehicle_User vu where vc.CLIENT_ID=? "
		+ " and vc.SYSTEM_ID=? and vu.User_id=? and vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no order by REGISTRATION_NUMBER";
	
	public static final String CHECK_ROUTE_INFORMATION = "select CUSTOMER_ROUTE_ID from AMS.dbo.ETMS_ROUTE_MASTER where CUSTOMER_ROUTE_ID=? and TYPE=? ";
	
	public static final String INSERT_ROUTE_INFORMATION = "insert into AMS.dbo.ETMS_ROUTE_MASTER(CUSTOMER_ROUTE_ID,ROUTE_NAME,START_TIME,END_TIME,DURATION,DISTANCE,SYSTEM_ID,CUSTOMER_ID,CREATED_TIME,CREATED_BY,TYPE) values (?,?,?,?,?,?,?,?,getutcdate(),?,?)";
	
	public static final String INSERT_ASSET_INFORMATION = "insert into AMS.dbo.ETMS_ASSET_ROUTE_MAPPING (ROUTE_ID,ASSET_NUMBER) values (?,?)";
	
    public static final String UPDATE_ROUTE_INFORMATION = "update AMS.dbo.ETMS_ROUTE_MASTER set START_TIME=?,END_TIME=?,DISTANCE=?,DURATION=?,CUSTOMER_ROUTE_ID=?,TYPE=?,ROUTE_NAME=?,UPDATED_BY=?,UPDATED_DATETIME=getutcdate() where  ROUTE_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String UPDATE_ASSET_INFORMATION = "update AMS.dbo.ETMS_ASSET_ROUTE_MAPPING set ASSET_NUMBER=? where ROUTE_ID=?  ";
	
    public static final String DELETE_ROUTE_INFORMATION = "delete from AMS.dbo.ETMS_ROUTE_MASTER where  ROUTE_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String DELETE_ASSET_INFORMATION = "delete from AMS.dbo.ETMS_ASSET_ROUTE_MAPPING where ROUTE_ID=?";
	
	public static final String CHECK_ROUTE_CODE_INFORMATION = "select CUSTOMER_ROUTE_ID from AMS.dbo.ETMS_ROUTE_MASTER where CUSTOMER_ROUTE_ID=? and TYPE=? and ROUTE_ID !=? ";
	
    public static final String CHECK_EMPLOYEE_INFORMATION = "select * from AMS.dbo.ETMS_EMPLOYEE_MASTER where EMPLOYEE_ID=? ";
	
	public static final String INSERT_EMPLOYEE_INFORMATION = "insert into AMS.dbo.ETMS_EMPLOYEE_MASTER (EMPLOYEE_NAME,EMPLOYEE_ID,MOBILE_NO,RFID_KEY,LATITUDE,LONGITUDE,EMAIL,GENDER,SYSTEM_ID,CUSTOMER_ID)values(?,?,?,?,?,?,?,?,?,?)";
	
	public static final String INSERT_EMPLOYEE_ID_INFORMATION = "insert into AMS.dbo.ETMS_EMPLOYEE_ROUTE_MAPPING (EMPLOYEE_ID,ROUTE_ID,TYPE)values(?,?,?)";
	
    public static final String UPDATE_EMPLOYEE_INFORMATION = "update AMS.dbo.ETMS_EMPLOYEE_MASTER set EMPLOYEE_NAME=?,EMPLOYEE_ID=?,MOBILE_NO=?,RFID_KEY=?,LATITUDE=?,LONGITUDE=?,EMAIL=?,GENDER=? where ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";
    
    public static final String UPDATE_EMPLOYEE_ID_INFORMATION = "update AMS.dbo.ETMS_EMPLOYEE_ROUTE_MAPPING set ROUTE_ID=? where EMPLOYEE_ID=? and TYPE=? ";
    
    public static final String DELETE_EMPLOYEE_INFORMATION = "delete from AMS.dbo.ETMS_EMPLOYEE_MASTER  where ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
    public static final String DELETE_EMPLOYEE_ID_INFORMATION = "delete from AMS.dbo.ETMS_EMPLOYEE_ROUTE_MAPPING  where EMPLOYEE_ID=? ";
    
	public static final String CHECK_EMPLOYEE_ID_INFORMATION = "select * from AMS.dbo.ETMS_EMPLOYEE_MASTER where EMPLOYEE_ID=? and ID!=? ";
	
	public static final String GET_EMPLOYEE_ROUTE_DETAILS = " select eem.ID,isnull(eem.EMPLOYEE_NAME,'') as EMPLOYEE_NAME,isnull(eem.EMPLOYEE_ID,'') as EMPLOYEE_ID, "
														+ " isnull(eem.MOBILE_NO,'') as MOBILE_NO,isnull(eem.RFID_KEY,'') as RFID_KEY,isnull(eem.LATITUDE,0.0) as LATITUDE, " 
														+ " isnull(eem.LONGITUDE,0.0) as LONGITUDE,isnull(eem.EMAIL,'') as EMAIL,isnull(eem.GENDER,'') as GENDER, "
														+ " isnull(erm.ROUTE_NAME,'') as ROUTE_NAME,isnull(c.ROUTE_NAME,'') as ROUTE_NAME_FOR_DROP, "
														+ " isnull(erm.ROUTE_ID,0) as ROUTE_ID,isnull(c.ROUTE_ID,0) as ROUTE_ID_FOR_DROP from AMS.dbo.ETMS_EMPLOYEE_MASTER eem " 
														+ " left outer join AMS.dbo.ETMS_EMPLOYEE_ROUTE_MAPPING eerm on eerm.EMPLOYEE_ID=eem.ID and eerm.TYPE='PickUp' "
														+ " left outer join AMS.dbo.ETMS_EMPLOYEE_ROUTE_MAPPING b on b.EMPLOYEE_ID=eem.ID and b.TYPE='Drop' "
														+ " left outer join AMS.dbo.ETMS_ROUTE_MASTER erm on cast(erm.ROUTE_ID as varchar(20))=eerm.ROUTE_ID "
														+ " left outer join AMS.dbo.ETMS_ROUTE_MASTER c on cast(c.ROUTE_ID as varchar(20))=b.ROUTE_ID "
														+ " where eem.SYSTEM_ID=? and eem.CUSTOMER_ID=? ";
	
	public static final String GET_ROUTE_NAME = "select ROUTE_ID,ROUTE_NAME from AMS.dbo.ETMS_ROUTE_MASTER where CUSTOMER_ID=? and SYSTEM_ID=? and TYPE like ? ";

	public static final String DELETE_ETMS_EMPLOYEE_ROUTE_MAPPING=" delete from AMS.dbo.ETMS_EMPLOYEE_ROUTE_MAPPING where ROUTE_ID=?";
	
	public static final String CHECK_IF_PRESENT=" select * from AMS.dbo.ETMS_EMPLOYEE_ROUTE_MAPPING where EMPLOYEE_ID=? and TYPE=? ";
	
	public static final String  INSERT_EMPLOYEE_ID_INFORMATION_FOR_PICKUP=" insert into AMS.dbo.ETMS_EMPLOYEE_ROUTE_MAPPING(ROUTE_ID,EMPLOYEE_ID,TYPE) values (?,?,?) ";
}
