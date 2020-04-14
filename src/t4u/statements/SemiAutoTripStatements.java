package t4u.statements;

public class SemiAutoTripStatements {

	 public static final String INSERT_TRIP_DETAILS_MUSCAT = " insert into AMS.dbo.TRACK_TRIP_DETAILS (ASSET_NUMBER,PRODUCT_LINE,INSERTED_TIME," +
	 		" TRIP_START_TIME,CUSTOMER_REF_ID, CUSTOMER_NAME,ORDER_ID, SHIPMENT_ID, ROUTE_NAME," +
	 " SYSTEM_ID,CUSTOMER_ID,INSERTED_BY )" +
	 " values (?,?,getutcdate(),dateadd(mi,-?,?),?,?,?,?,?,?,?,?) ";
	 
	public static final String INSERT_TRACK_TRIP_DETAILS_SUB_MUSCAT = "INSERT INTO TRACK_TRIP_DETAILS_SUB (TRIP_ID,LOAD_START_TIME,LOAD_END_TIME) " +
	" VALUES (?,dateadd(mi,-?,?),dateadd(mi,-?,?))";
	 
	public static final String INSERT_TRIP_POINTS_CHECK_POINTS = " insert into AMS.dbo.DES_TRIP_DETAILS (TRIP_ID,HUB_ID,NAME,LATITUDE,LONGITUDE,RADIUS,DETENTION_TIME,SEQUENCE) " +
			"														values (?,?,?,?,?,?,?,?)";
	
	public static final String INSERT_INTO_TRIP_ORDER_DETAILS = "INSERT INTO AMS.dbo.TRIP_ORDER_DETAILS(DES_TRIP_ID,TRIP_ID,SCAN_ID,ORDER_NO,DELIVERY_TICKET_NO,DELIVERY_NOTE_NO "
			+ ", TRIP_CUSTOMER_ID, DELIVERY_STATUS ,TRIP_CUSTOMER_NAME ,AUTO_CLOSED,SYSTEM_ID,CUSTOMER_ID) "
		+" VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public static final String INSERT_INTO_MAP_VIEW_SETTINGS = "INSERT INTO MAP_VIEW_SETTINGS (ALERT_TYPE, DURATION ,ICON_COLOUR ,BLINK ,REGION ,BLINK_DURATION ,SYSTEM_ID,CUSTOMER_ID) VALUES (?,?,?,?,?,?,?,?)";
	
	public static final String DELETE_FROM_MAP_VIEW_SETTINGS = "DELETE FROM MAP_VIEW_SETTINGS WHERE SYSTEM_ID=? AND CUSTOMER_ID=?";
	
	public static final String SELECT_FROM_MAP_VIEW_SETTINGS = "SELECT ALERT_TYPE,DURATION,ICON_COLOUR,BLINK,mv.REGION,NAME,ISNULL(BLINK_DURATION,0) AS BLINK_DURATION  FROM MAP_VIEW_SETTINGS mv LEFT OUTER JOIN LOCATION_ZONE_# lz" +
															   " on lz.HUBID=mv.REGION WHERE SYSTEM_ID=? AND CUSTOMER_ID=?  order by mv.ID desc";

	public static final String GET_SEMI_AUTO_TRIP_DETAILS="select isnull(CUSTOMER_REF_ID,'') as CUSTOMER_REF_ID,a.TRIP_ID as ID,isnull(a.SHIPMENT_ID,'') as SHIPMENT_ID," +
	 " isnull(a.ROUTE_NAME,'') as RouteName,isnull(a.ASSET_NUMBER,'') as ASSET_NO,isnull(u.Firstname +' '+ u.Lastname ,'') as INSERTED_BY,dateadd(mi,?,a.INSERTED_TIME) as INSERTED_TIME," +
	 " dateadd(mi,?,a.TRIP_START_TIME) as TRIP_START_TIME,isnull(a.STATUS,'') as STATUS,isnull(a.ORDER_ID,'') as ORDER_ID,isnull(a.CUSTOMER_NAME,'') as CUSTOMER_NAME," +
	 " isnull(NEGATIVE_MAX_TEMPERATURE,999) as NEGATIVE_MAX_TEMPERATURE,isnull(POSITIVE_MAX_TEMPERATURE,999) as POSITIVE_MAX_TEMPERATURE, " +
	 " isnull(NEGATIVE_MIN_TEMPERATURE,999) as NEGATIVE_MIN_TEMPERATURE, isnull(POSITIVE_MIN_TEMPERATURE,999) as POSITIVE_MIN_TEMPERATURE, " +	 
	 " a.ACTUAL_TRIP_START_TIME,isnull(a.ETA_AVG_SPEED,0) as avgSpeed,isnull(a.PRE_LOADING_TEMP,'') as preLoadTemp,isnull(a.ROUTE_ID,0) as routeId,isnull(a.PRODUCT_LINE,'') as productLine, " +
	 " isnull(a.SEAL_NO,'') as SEAL_NO,isnull(a.NO_OF_BAGS,'0') as NO_OF_BAGS, isnull(a.TRIP_TYPE,'') as TRIP_TYPE, isnull(a.NO_OF_FLUID_BAGS,'0') as NO_OF_FLUID_BAGS,isnull(a.OPENING_KMS,'0') as OPENING_KMS, " +
	 " isnull(a.TRIP_REMARKS,'') as TRIP_REMARKS,isnull(a.TRIP_CUSTOMER_ID,0) as tripCustId, " +
	 " isnull(dateadd(mi,?,ds.PLANNED_ARR_DATETIME),'') as STA, "+
	 " dateadd(mi,?,ds.ACT_ARR_DATETIME) as ATA, " +
	 " isnull(u1.Firstname +' '+ u1.Lastname ,'') as OVERRIDDEN_BY,a.OVERRIDDEN_DATETIME, isnull(a.OVERRIDDEN_REMARKS,'') as OVERRIDDEN_REMARKS,isnull(a.REMARKS,'') as CANCELLED_REMARKS,isnull(a.TRIP_CATEGORY,'')as CATEGORY,dateadd(mi,?,a.ACTUAL_TRIP_END_TIME) as ACTUAL_TRIP_END_TIME, " +
	 " isnull(u2.Firstname +' '+ u2.Lastname ,'') as CANCELLED_BY,dateadd(mi,?,a.CANCELLED_DATE) as CANCELLED_DATE," +
	 " (SELECT NAME FROM LOCATION_ZONE WHERE HUBID = ds0.HUB_ID) as sourceHubName, "+
	 " tc.TRIP_REPOEN_OPTION ,dateadd(mi,?,tds.LOAD_START_TIME) as LOAD_START_TIME, dateadd(mi,?,tds.LOAD_END_TIME) as LOAD_END_TIME, "+
	 " dateadd(mi,?,ACTUAL_TRIP_END_TIME) as tripEndTime "+
	 " from dbo.TRACK_TRIP_DETAILS a" +
	 " left outer join AMS.dbo.DES_TRIP_DETAILS ds0 on ds0.TRIP_ID=a.TRIP_ID and ds0.SEQUENCE=0"+
	 " left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=a.TRIP_ID and ds.SEQUENCE=100"+
	 " left outer join AMS.dbo.Users u on u.System_id=a.SYSTEM_ID and u.User_id=a.INSERTED_BY "+
	 " left outer join AMS.dbo.Users u1 on u1.System_id=a.SYSTEM_ID and u1.User_id=a.OVERRIDDEN_BY "+
	 " left outer join AMS.dbo.Users u2 on u2.System_id=a.SYSTEM_ID and u2.User_id=a.CANCELLED_BY "+
	 " left outer join TRACK_TRIP_DETAILS_SUB tds on tds.TRIP_ID=a.TRIP_ID "+ 
	 " left outer join TRIP_CONFIGURATION tc on tc.SYSTEM_ID=a.SYSTEM_ID AND tc.CUSTOMER_ID=a.CUSTOMER_ID "+
	 " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? # and a.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by a.INSERTED_TIME desc ";
	
	
	public static final String CHECK_VEHICLE_AVALABILITY = "SELECT * FROM TRACK_TRIP_DETAILS WHERE ASSET_NUMBER=? AND STATUS='OPEN'";
	
	public static final String CHECK_R232_ASSOCIATION = "select  REGISTRATION_NO from dbo.RS232_ASSOCIATION where IO_CATEGORY LIKE '%TEMPERATURE%' and REGISTRATION_NO=? and SYSTEM_ID=? AND CLIENT_ID=?";

	public static final String GET_AVAILABLE_VEHICLES=" select  distinct isnull(vc.REGISTRATION_NUMBER,'') as REGISTRATION_NUMBER ," +
			" isnull(tb.VehicleType,'NA') as VehicleType,isnull(vm.ModelName,'NA') as Model,  NULL as MinTempLimit, NULL as MaxTempLimit, 'Y' AS IS_RS232_ASSOC "+
			" from VEHICLE_CLIENT vc " +
			" inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER=vu.Registration_no and  vc.SYSTEM_ID=vu.System_id " +
			" inner join  AMS.dbo.tblVehicleMaster tb  on vc.REGISTRATION_NUMBER=tb.VehicleNo " + 
			" left outer join FMS.dbo.Vehicle_Model vm on tb.Model = vm.ModelTypeId and vm.SystemId=vc.SYSTEM_ID and vm.ClientId=vc.CLIENT_ID "+
			" inner join AMS.dbo.RS232_ASSOCIATION ra on ra.REGISTRATION_NO =vc.REGISTRATION_NUMBER and ra.CLIENT_ID=vc.CLIENT_ID and ra.IO_CATEGORY in ('TEMPERATURE1','TEMPERATURE2','TEMPERATURE3') " +	 		
			" where vc.SYSTEM_ID = ? and vc.CLIENT_ID=? and vu.User_id=? and REGISTRATION_NUMBER not in (select Vehicle_id from Vehicle_Status where Status_id=4)" +
			" and REGISTRATION_NUMBER not in( select ASSET_NUMBER FROM TRACK_TRIP_DETAILS (nolock) WHERE STATUS='OPEN')" +
			" union all "+
			" select  distinct isnull(vc.REGISTRATION_NUMBER,'') as REGISTRATION_NUMBER ,isnull(tb.VehicleType,'NA') as VehicleType," +
			" isnull(vm.ModelName,'NA') as Model ,MinTempLimit, MaxTempLimit, 'N' AS IS_RS232_ASSOC "+
			" from VEHICLE_CLIENT vc " +
			" inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER=vu.Registration_no and  vc.SYSTEM_ID=vu.System_id " +
			" inner join  AMS.dbo.tblVehicleMaster tb  on vc.REGISTRATION_NUMBER=tb.VehicleNo " + 
			" left outer join FMS.dbo.Vehicle_Model vm on tb.Model = vm.ModelTypeId and vm.SystemId=vc.SYSTEM_ID and vm.ClientId=vc.CLIENT_ID "+
			" where vc.SYSTEM_ID = ? and vc.CLIENT_ID=? and vu.User_id=? and REGISTRATION_NUMBER not in (select Vehicle_id from Vehicle_Status where Status_id=4)" +
			" and REGISTRATION_NUMBER not in( select ASSET_NUMBER FROM TRACK_TRIP_DETAILS (nolock) WHERE STATUS='OPEN') and TMU='Y'" +
			" order by REGISTRATION_NUMBER ";
	
	public static final String GET_CUSTOMERS = "SELECT CUSTOMER_ID,NAME,SYSTEM_ID FROM ADMINISTRATOR.dbo.CUSTOMER_MASTER";
	
	
	public static final String GET_TRIP_CONFIGURATION = "SELECT SYSTEM_ID,CUSTOMER_ID,TRIP_START_CRITERIA,TRIP_END_CRITERIA,TRIP_START_CRITERIA_PARAM,TRIP_END_CRITERIA_PARAM,ROUTE_TYPE,ISNULL(SMS_URL,'') AS SMS_URL,ISNULL(SMS_USERNAME,'') AS SMS_USERNAME ,ISNULL(SMS_PASSWORD,'') AS SMS_PASSWORD FROM AMS.dbo.TRIP_CONFIGURATION";
	
	public static final String INSERT_TRIP_CONFIGURATION = "INSERT INTO TRIP_CONFIGURATION (SYSTEM_ID,CUSTOMER_ID,TRIP_START_CRITERIA,TRIP_END_CRITERIA,TRIP_START_CRITERIA_PARAM,TRIP_END_CRITERIA_PARAM,ROUTE_TYPE)" +
	" VALUES(?,?,?,?,?,?,?)";
	
	public static final String UPDATE_TRIP_CONFIGURATION = "update TRIP_CONFIGURATION set TRIP_START_CRITERIA=?,TRIP_END_CRITERIA=?,TRIP_START_CRITERIA_PARAM=?,TRIP_END_CRITERIA_PARAM=?,ROUTE_TYPE=?,SEND_SMS_ONTRIP_START=?,HEAD_QUATERS=?,SMS_URL=?,SMS_USERNAME=?,SMS_PASSWORD=?,TRIP_CREATION_TYPE=?" +
	" where SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String GET_TRIP_CONFIGURATION_BY_SYSTEM_AND_CUSTOMER_ID = "SELECT SYSTEM_ID,CUSTOMER_ID,TRIP_START_CRITERIA,TRIP_END_CRITERIA," +
			" TRIP_START_CRITERIA_PARAM,TRIP_END_CRITERIA_PARAM,ROUTE_TYPE,ISNULL(SMS_URL,'') AS SMS_URL,ISNULL(SMS_USERNAME,'') AS SMS_USERNAME ," +
			" ISNULL(SMS_PASSWORD,'') AS SMS_PASSWORD ,ISNULL(MTM_BUFFER_MINS,0)AS MTM_BUFFER_MINS,ISNULL(MTM_BUFFER_DAYS,0) AS MTM_BUFFER_DAYS, " +
			" ISNULL(MTM_SMS_BUFFER_MINS,0) AS MTM_SMS_BUFFER_MINS,ENABLE_MTM,ENABLE_COLLECTION,ENABLE_BORDER_ALERT FROM AMS.dbo.TRIP_CONFIGURATION WHERE SYSTEM_ID = ? AND CUSTOMER_ID = ? ";
	
	public static final String GET_TRIP_CUSTOMERS=" select ID,isnull(NAME,'') as NAME from dbo.TRIP_CUSTOMER_DETAILS where  CUSTOMER_ID=? and SYSTEM_ID=? and STATUS='Active'";
	 

}
