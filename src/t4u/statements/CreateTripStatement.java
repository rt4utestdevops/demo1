package t4u.statements;

public class CreateTripStatement {
	
	 public static final String GET_CUSTOMER_NAMES=" select distinct ID,isnull(NAME,'') as NAME from dbo.TRIP_CUSTOMER_DETAILS tc " +
	 		" inner join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_CUSTOMER_ID=tc.ID " +
	 		" where  tc.CUSTOMER_ID=? and tc.SYSTEM_ID=? and tc.STATUS='Active'";
	 
	 public static final String GET_CUSTOMER_NAMESCE="select distinct isnull(tc.ID,'') as ID,isnull(tc.NAME,'') as NAME from dbo.TRIP_CUSTOMER_DETAILS tc inner join TRACK_TRIP_DETAILS td on  td.TRIP_CUSTOMER_ID=tc.ID where  tc.CUSTOMER_ID=? and tc.SYSTEM_ID=? and tc.STATUS='Active' order by NAME ";

	 public static final String GET_CUSTOMER_TYPE = "select isnull(TYPE,'')as TYPE from AMS.dbo.CUSTOMER_TYPE where CUSTOMER_ID=? and SYSTEM_ID=? order by ID";
	 
	 public static final String GET_ROUTE_NAMES="select isnull(a.ID,0) as routeId,isnull(a.ROUTE_NAME,'') as routeName,count(b.ID) as legCount from TRIP_ROUTE_MASTER a"+
	 " left outer join TRIP_ROUTE_DETAILS b on b.ROUTE_ID=a.ID"+
	 " where a.SYSTEM_ID=? and a.TRIP_CUST_ID=? and a.CUSTOMER_ID=? and a.STATUS='Active' group by a.ID,a.ROUTE_NAME";
	
	 public static final String GET_VEHICLE_FOR_CLIENT="select  distinct isnull(vc.REGISTRATION_NUMBER,'') as REGISTRATION_NUMBER ,tb.VehicleType as VehicleType,isnull(vm.ModelName,'NA') as Model from VEHICLE_CLIENT vc " +
	 		" inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER=vu.Registration_no and  vc.SYSTEM_ID=vu.System_id " +
	 		" inner join  AMS.dbo.tblVehicleMaster tb  on vc.REGISTRATION_NUMBER=tb.VehicleNo " +
	 		" left outer join FMS.dbo.Vehicle_Model vm on tb.Model = vm.ModelTypeId and vm.SystemId=vc.SYSTEM_ID and vm.ClientId=vc.CLIENT_ID "+
	 	//	" left outer join dbo.TRACK_TRIP_DETAILS td on vc.SYSTEM_ID=td.SYSTEM_ID and vc.REGISTRATION_NUMBER=td.ASSET_NUMBER and td.STATUS <>'OPEN'" +
	 		" where vc.SYSTEM_ID = ? and vc.CLIENT_ID=? and vu.User_id=? and REGISTRATION_NUMBER not in (select Vehicle_id from Vehicle_Status where Status_id=4)" +
	 		" order by REGISTRATION_NUMBER";

	 public static final String GET_TRIP_DETAILS="select isnull(CUSTOMER_REF_ID,'') as CUSTOMER_REF_ID,a.TRIP_ID as ID,isnull(a.SHIPMENT_ID,'') as SHIPMENT_ID," +
	 " isnull(a.ROUTE_NAME,'') as RouteName,isnull(a.ASSET_NUMBER,'') as ASSET_NO,isnull(u.Firstname +' '+ u.Lastname ,'') as INSERTED_BY,dateadd(mi,?,a.INSERTED_TIME) as INSERTED_TIME," +
	 " dateadd(mi,?,a.TRIP_START_TIME) as TRIP_START_TIME,isnull(a.STATUS,'') as STATUS,isnull(a.ORDER_ID,'') as ORDER_ID,isnull(a.CUSTOMER_NAME,'') as CUSTOMER_NAME," +
	 " isnull(NEGATIVE_MAX_TEMPERATURE,999) as NEGATIVE_MAX_TEMPERATURE,isnull(POSITIVE_MAX_TEMPERATURE,999) as POSITIVE_MAX_TEMPERATURE, " +
	 " isnull(NEGATIVE_MIN_TEMPERATURE,999) as NEGATIVE_MIN_TEMPERATURE, isnull(POSITIVE_MIN_TEMPERATURE,999) as POSITIVE_MIN_TEMPERATURE, " +	 
	 " dateadd(mi,?,a.ACTUAL_TRIP_START_TIME) as ACTUAL_TRIP_START_TIME,isnull(a.ETA_AVG_SPEED,0) as avgSpeed,isnull(a.PRE_LOADING_TEMP,'') as preLoadTemp,isnull(a.ROUTE_ID,0) as routeId,isnull(a.PRODUCT_LINE,'') as productLine, " +
	 " isnull(a.SEAL_NO,'') as SEAL_NO,isnull(a.NO_OF_BAGS,'0') as NO_OF_BAGS, isnull(a.TRIP_TYPE,'') as TRIP_TYPE, isnull(a.NO_OF_FLUID_BAGS,'0') as NO_OF_FLUID_BAGS,isnull(a.OPENING_KMS,'0') as OPENING_KMS, " +
	 " isnull(a.TRIP_REMARKS,'') as TRIP_REMARKS,isnull(a.TRIP_CUSTOMER_ID,0) as tripCustId,isnull(dateadd(mi,?,ds.PLANNED_ARR_DATETIME),'') as STA," +
	 " dateadd(mi,?,ds.ACT_ARR_DATETIME) as ATA,dateadd(mi,?,ds0.PLANNED_ARR_DATETIME) as STP,dateadd(mi,?,a.ACT_SRC_ARR_DATETIME) as ATP,"+
	 " isnull(u1.Firstname +' '+ u1.Lastname ,'') as OVERRIDDEN_BY,a.OVERRIDDEN_DATETIME, isnull(a.OVERRIDDEN_REMARKS,'') as OVERRIDDEN_REMARKS,isnull(a.REMARKS,'') as CANCELLED_REMARKS,isnull(a.TRIP_CATEGORY,'')as CATEGORY,dateadd(mi,?,a.ACTUAL_TRIP_END_TIME) as ACTUAL_TRIP_END_TIME, " +
	 " isnull(u2.Firstname +' '+ u2.Lastname ,'') as CANCELLED_BY,dateadd(mi,?,a.CANCELLED_DATE) as CANCELLED_DATE" +
	 " from dbo.TRACK_TRIP_DETAILS (nolock) a" +
	 " left outer join AMS.dbo.DES_TRIP_DETAILS (nolock) ds0 on ds0.TRIP_ID=a.TRIP_ID and ds0.SEQUENCE=0"+
	 " left outer join AMS.dbo.DES_TRIP_DETAILS (nolock) ds on ds.TRIP_ID=a.TRIP_ID and ds.SEQUENCE=100"+
	 " left outer join AMS.dbo.Users u on u.System_id=a.SYSTEM_ID and u.User_id=a.INSERTED_BY "+
	 " left outer join AMS.dbo.Users u1 on u1.System_id=a.SYSTEM_ID and u1.User_id=a.OVERRIDDEN_BY "+
	 " left outer join AMS.dbo.Users u2 on u2.System_id=a.SYSTEM_ID and u2.User_id=a.CANCELLED_BY "+
	 " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? # and a.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by a.INSERTED_TIME desc ";
	
	 
	 public static final String GET_TRIP_DETAILS_MATERIAL_CLIENT="select isnull(CUSTOMER_REF_ID,'') as CUSTOMER_REF_ID,a.TRIP_ID as ID,isnull(a.SHIPMENT_ID,'') as SHIPMENT_ID," +
	 " isnull(a.ROUTE_NAME,'') as RouteName,isnull(a.ASSET_NUMBER,'') as ASSET_NO,isnull(u.Firstname +' '+ u.Lastname ,'') as INSERTED_BY,dateadd(mi,?,a.INSERTED_TIME) as INSERTED_TIME," +
	 " dateadd(mi,?,a.TRIP_START_TIME) as TRIP_START_TIME,isnull(a.STATUS,'') as STATUS,isnull(a.ORDER_ID,'') as ORDER_ID,isnull(a.CUSTOMER_NAME,'') as CUSTOMER_NAME," +
	 " isnull(NEGATIVE_MAX_TEMPERATURE,999) as NEGATIVE_MAX_TEMPERATURE,isnull(POSITIVE_MAX_TEMPERATURE,999) as POSITIVE_MAX_TEMPERATURE, " +
	 " isnull(NEGATIVE_MIN_TEMPERATURE,999) as NEGATIVE_MIN_TEMPERATURE, isnull(POSITIVE_MIN_TEMPERATURE,999) as POSITIVE_MIN_TEMPERATURE, " +	 
	 " dateadd(mi,?,a.ACTUAL_TRIP_START_TIME) as ACTUAL_TRIP_START_TIME,isnull(a.ETA_AVG_SPEED,0) as avgSpeed,isnull(a.PRE_LOADING_TEMP,'') as preLoadTemp,isnull(a.ROUTE_ID,0) as routeId,isnull(a.PRODUCT_LINE,'') as productLine, " +
	 " isnull(a.SEAL_NO,'') as SEAL_NO,isnull(a.NO_OF_BAGS,'0') as NO_OF_BAGS, isnull(a.TRIP_TYPE,'') as TRIP_TYPE, isnull(a.NO_OF_FLUID_BAGS,'0') as NO_OF_FLUID_BAGS,isnull(a.OPENING_KMS,'0') as OPENING_KMS, " +
	 " isnull(a.TRIP_REMARKS,'') as TRIP_REMARKS,isnull(a.TRIP_CUSTOMER_ID,0) as tripCustId,isnull(dateadd(mi,?,ds.PLANNED_ARR_DATETIME),'') as STA," +
	 " dateadd(mi,?,ds.ACT_ARR_DATETIME) as ATA,dateadd(mi,?,ds0.PLANNED_ARR_DATETIME) as STP,dateadd(mi,?,a.ACT_SRC_ARR_DATETIME) as ATP," +
	 " isnull(u1.Firstname +' '+ u1.Lastname ,'') as OVERRIDDEN_BY,a.OVERRIDDEN_DATETIME, isnull(a.OVERRIDDEN_REMARKS,'') as OVERRIDDEN_REMARKS," +
	 " rt.NAME as TEMPLATE_NAME,mm.MATERIAL_NAME, "+
	 " (select sum(TAT) from ROUTE_LEG_MATERIAL_ASSOC rlma where rlma.TEMPLATE_ID=rt.ID and rlma.MATERIAL_ID=a.MATERIAL_ID group by rlma.MATERIAL_ID) as TotalTAT,"+
	 " (select  sum(RUN_TIME) from ROUTE_LEG_MATERIAL_ASSOC rlma where rlma.TEMPLATE_ID=rt.ID and rlma.MATERIAL_ID=a.MATERIAL_ID group by rlma.MATERIAL_ID) as TotalRunTime,isnull(a.REMARKS,'') as CANCELLED_REMARKS,isnull(a.TRIP_CATEGORY,'')as CATEGORY ," +
	 " dateadd(mi,?,a.ACTUAL_TRIP_END_TIME) as ACTUAL_TRIP_END_TIME ,isnull(u2.Firstname +' '+ u2.Lastname ,'') as CANCELLED_BY,dateadd(mi,?,a.CANCELLED_DATE) as CANCELLED_DATE" +
	 " from dbo.TRACK_TRIP_DETAILS (nolock) a" +
	 " left outer join AMS.dbo.DES_TRIP_DETAILS (nolock) ds0 on ds0.TRIP_ID=a.TRIP_ID and ds0.SEQUENCE=0"+
	 " left outer join AMS.dbo.DES_TRIP_DETAILS (nolock) ds on ds.TRIP_ID=a.TRIP_ID and ds.SEQUENCE=100"+
	 " left outer join AMS.dbo.Users u on u.System_id=a.SYSTEM_ID and u.User_id=a.INSERTED_BY "+
	 " left outer join AMS.dbo.Users u1 on u1.System_id=a.SYSTEM_ID and u1.User_id=a.OVERRIDDEN_BY "+
	 " left outer join AMS.dbo.Users u2 on u2.System_id=a.SYSTEM_ID and u2.User_id=a.CANCELLED_BY "+
	 " inner join ROUTE_TEMPLATE rt on rt.ID=a.ROUTE_TEMPLATE_ID"+
	 " left outer join MATERIAL_MASTER mm on mm.ID=a.MATERIAL_ID"+
	 " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? # and a.INSERTED_TIME between dateadd(mi,?,?) and dateadd(mi,?,?) order by a.INSERTED_TIME desc ";
	
	 public static final String UPDATE_TO_CLOSE_TRIP="update AMS.dbo.TRACK_TRIP_DETAILS set STATUS='CANCEL',ACTUAL_TRIP_END_TIME=getutcdate()," +
	 " CANCELLED_BY=?,CANCELLED_DATE=getutcdate(),REMARKS=?,END_LOCATION=?,AUTO_CLOSE='N' where TRIP_ID=?";

	 public static final String CHECK_TRIP_DETAILS = " select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS (nolock) where ASSET_NUMBER=? and CUSTOMER_ID=? and SYSTEM_ID=? and STATUS='OPEN' ";
	 
	 public static final String INSERT_TRIP_DETAILS = " insert into AMS.dbo.TRACK_TRIP_DETAILS (ASSET_NUMBER,SHIPMENT_ID,TRIP_START_TIME,INSERTED_TIME,SYSTEM_ID," +
	 " CUSTOMER_ID,ROUTE_ID,TRIP_STATUS,STATUS,INSERTED_BY,ALERT_ID,ROUTE_NAME,CUSTOMER_NAME,ORDER_ID,CUSTOMER_REF_ID,ETA_AVG_SPEED, NEGATIVE_MIN_TEMPERATURE," +
	 " NEGATIVE_MAX_TEMPERATURE, POSITIVE_MIN_TEMPERATURE, POSITIVE_MAX_TEMPERATURE, MIN_HUMIDITY, MAX_HUMIDITY,PRE_LOADING_TEMP,PRODUCT_LINE,TRIP_CUSTOMER_ID," +
	 " SEAL_NO, NO_OF_BAGS, TRIP_TYPE, NO_OF_FLUID_BAGS, OPENING_KMS, TRIP_REMARKS,ROUTE_TEMPLATE_ID,MATERIAL_ID,TRIP_CATEGORY)" +
	 " values (?,?,dateadd(mi,-?,?),getutcdate(),?,?,?,'NEW','OPEN',?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

	 public static final String GET_TRIP_SUMMARY = " select TRIP_ID,isnull(a.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(a.SHIPMENT_ID,'') as SHIPMENT_ID,isnull(a.ROUTE_NAME,'') as ROUTE_NAME," +
	 		" isnull(dateadd(mi,?,a.TRIP_START_TIME),'') as TRIP_START_TIME,isnull(dateadd(mi,?,a.ACTUAL_TRIP_START_TIME),'') as ACTUAL_TRIP_START_TIME," +
	 		" isnull(a.START_LOCATION,'') as START_LOCATION,isnull(a.START_ODOMETER,0.0) as START_ODOMETER,isnull(dateadd(mi,?,a.TRIP_END_TIME),'') as TRIP_END_TIME," +
	 		" isnull(dateadd(mi,?,a.ACTUAL_TRIP_END_TIME),'') as ACTUAL_TRIP_END_TIME,isnull(a.END_ODOMETER,0.0) as END_ODOMETER,(isnull(a.STATUS,'')+' - '+isnull(a.TRIP_STATUS,'')) as TRIP_STATUS," +
	 		" isnull(a.PLANNED_DISTANCE,0) as PLANNED_DISTANCE,isnull(a.ACTUAL_DISTANCE,0) as ACTUAL_DISTANCE,isnull(vm.VehicleType,'') as VehicleType " +
	 		" from dbo.TRACK_TRIP_DETAILS (nolock) a " +
	 		" inner join AMS.dbo.tblVehicleMaster vm on vm.System_id=a.SYSTEM_ID and vm.VehicleNo=a.ASSET_NUMBER " +
	 		"where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TRIP_START_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";
	 
	 public static final String MODIFY_TRIP_DETAILS_ON_DATE_CHANGE = " update AMS.dbo.TRACK_TRIP_DETAILS set TRIP_START_TIME=dateadd(mi,-?,?),TRIP_STATUS='NEW',UPDATED_BY=?," +
	 		" UPDATED_DATETIME=getutcdate(),PRE_LOADING_TEMP=?,LAST_EXEC_DATE=null,LAST_EXEC_TIME_ATP=null,ACTUAL_TRIP_START_TIME=null,ETA_AVG_SPEED = ?,CUSTOMER_REF_ID =?,TRIP_CATEGORY = ?,PRODUCT_LINE = ?," +
	 		" ACT_SRC_ARR_DATETIME=null where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_ID=? ";
	 
	 public static final String MODIFY_TRIP_DETAILS = " update AMS.dbo.TRACK_TRIP_DETAILS set TRIP_START_TIME=dateadd(mi,-?,?),UPDATED_BY=?,UPDATED_DATETIME=getutcdate()," +
	 " PRE_LOADING_TEMP=?,ETA_AVG_SPEED = ?,CUSTOMER_REF_ID =?,TRIP_CATEGORY = ?,PRODUCT_LINE = ? where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_ID=? ";

	 public static final String DELETE_DES_TRIP_DETAILS = " delete from AMS.dbo.DES_TRIP_DETAILS where TRIP_ID=? ";
	 
	 public static final String GET_ROUTE_DETAILS = "select RouteID,isnull(rm.RADIUS,0) as ROUTE_RADIUS,isnull(RouteName,'') as ROUTE_NAME, "
			+" isnull(RouteDistance,0) as ACTUAL_DISTANCE,isnull(EXPECTED_DISTANCE,0) as EXPECTED_DISTANCE, "
			+" isnull(ACTUAL_DURATION,0) as ACTUAL_DURATION,isnull(EXPECTED_DURATION,0) as EXPECTED_DURATION,isnull(STATUS,'') as STATUS, "  
			+" isnull(RouteDescription,'') as ROUTE_DESCRIPTION,isnull(rd.SHORT_NAME,'') as SOURCE_NAME, isnull(rd1.SHORT_NAME,'') as DESTINATION_NAME "  
			+" from AMS.dbo.Route_Master rm "
			+" left outer join AMS.dbo.Route_Detail rd on rd.Route_id=rm.RouteID and rd.TYPE='SOURCE' "
			+" left outer join AMS.dbo.Route_Detail rd1 on rd1.Route_id=rm.RouteID and rd1.TYPE='DESTINATION' "
			+"where rm.System_id=? and rm.RouteID = ? ";//rm.ClientId=? and 
	 
	 public static final String GET_TRIP_SHEET_SETTING_DETAILS="select isnull(AVERAGE_SPEED,0) as AVERAGE_SPEED,isnull(ALL_EVENTS,'N')as ALL_EVENTS,isnull(EXTRA_DATA_FIELDS,'N')as EXTRA_DATA_FIELDS,isnull(VEHICLE_REPORTING,'N')as VEHICLE_REPORTING," +
	 		"isnull(HUB_ASSOCIATED_ROUTES,'N')as HUB_ASSOCIATED_ROUTES,isnull(VEHICLE_SWAP,'N')as VEHICLE_SWAP,MATERIAL_CLIENT,isnull(CATEGORY,'N') as CATEGORY,isnull(HUMIDITY,'N') as HUMIDITY,isnull(TEMPERATURE,'N') as TEMPERATURE,isnull(EVENTS,'N') as EVENTS," +
	 		" isnull(OVERRIDE_ACTUAL_TIME_USERS,'') as OVERRIDE_ACTUAL_TIME_USERS from AMS.dbo.TRIP_SHEET_SETTING where CUSTOMER_ID=? and SYSTEM_ID=? ";

	public static final String GET_DRIVER_DETAILS = "select Driver_id as driverId,Fullname+'_'+EmployeeID as driverName from Driver_Master where System_id=? and Client_id=? " ;//+
/*	" and Driver_id not in (select distinct DRIVER_1 from TRIP_LEG_DETAILS where TRIP_ID in (select TRIP_ID from TRACK_TRIP_DETAILS " +
	" where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='OPEN' and TRIP_ID != ?)"+
	" union all "+
	" select distinct DRIVER_2 from TRIP_LEG_DETAILS where TRIP_ID in (select TRIP_ID from TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='OPEN' and TRIP_ID != ?))";
*/
	public static final String GET_ROUTE_LEG_DETAILS = "select LEG_ID as legId,isnull(a.TAT,0) as tat,isnull(a.DETENTION_TIME,0) as detTime,isnull(b.LEG_NAME,'') as legName," +
	" isnull(z1.NAME,'') as src,isnull(z2.NAME,'') as dest from TRIP_ROUTE_DETAILS a"+
	" left outer join LEG_MASTER b on b.ID=a.LEG_ID"+
	" left outer join LOCATION_ZONE_A z1 on z1.HUBID=a.SOURCE_HUB"+
	" left outer join LOCATION_ZONE_A z2 on z2.HUBID=a.DESTINATION_HUB"+
	" where a.ROUTE_ID=? order by a.LEG_SEQUENCE";

	public static final String INSERT_TRIP_LEG_DETAILS = "insert into AMS.dbo.TRIP_LEG_DETAILS (TRIP_ID,LEG_ID,STD,STA,DRIVER_1,DRIVER_2,INSERTED_DATE," +
	" INSERTED_BY) values (?,?,dateadd(mi,-?,?),dateadd(mi,-?,?),?,?,getutcdate(),?)";

	public static final String GET_TRIP_LEG_DETAILS = "select LEG_ID as legId,isnull(b.LEG_NAME,'') as legName,isnull(z1.NAME,'') as src," +
	" isnull(z2.NAME,'') as dest,isnull(dateadd(mi,?,STD),'') as std,isnull(dateadd(mi,?,STA),'') as sta,isnull(a.DRIVER_1,'0') as driver1," +
	" isnull(a.DRIVER_2,'0') as driver2,isnull(ACTUAL_ARRIVAL,'') as ata " +
	" from TRIP_LEG_DETAILS a"+
	" left outer join LEG_MASTER b on b.ID=a.LEG_ID"+
	" left outer join LOCATION_ZONE_A z1 on z1.HUBID=b.SOURCE"+
	" left outer join LOCATION_ZONE_A z2 on z2.HUBID=b.DESTINATION"+
	" where a.TRIP_ID=? order by a.ID";

	public static final String UPDTAE_TRIP_LEG_DETAILS = "update TRIP_LEG_DETAILS set STD=dateadd(mi,-?,?),STA=dateadd(mi,-?,?),DRIVER_1=?,DRIVER_2=?" +
	" where TRIP_ID=? and LEG_ID=?";

	public static final String CHECK_DATE = "select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS (nolock) where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_START_TIME=dateadd(mi,-?,?) and STATUS='OPEN'";

	public static final String GET_PRODUCT_LINE = "select VALUE from LOOKUP_DETAILS where VERTICAL='Product_Line' order by ORDER_OF_DISPLAY";
	
	public static final String GET_TRIP_CATEGORY = "select VALUE from AMS.dbo.LOOKUP_DETAILS where VERTICAL='CATEGORY' order by TYPE";
	 
	public static final String GET_ROUTE_NAMES_MLL = "select RouteID as routeId,RouteName as routeName, 0 as legCount from  Route_Master a inner join "+
													 "Route_Detail b on a.RouteID=b.Route_id where a.System_id=? and a.ClientId=? and a.STATUS='Active' and Route_Segment=1"+
													 "and TYPE='SOURCE' and HUB_ID  in (SELECT HubId FROM UserHubAssociation where SystemId=? and UserId=?)";

	 public static final String GET_VEHICLE_FOR_CLIENT_PRODUCT_LINE=" select  distinct isnull(vc.REGISTRATION_NUMBER,'') as REGISTRATION_NUMBER ,isnull(tb.VehicleType,'NA') as VehicleType,isnull(vm.ModelName,'NA') as Model from VEHICLE_CLIENT vc " +
		" inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER=vu.Registration_no and  vc.SYSTEM_ID=vu.System_id " +
 		" inner join  AMS.dbo.tblVehicleMaster tb  on vc.REGISTRATION_NUMBER=tb.VehicleNo " + 
 		" left outer join FMS.dbo.Vehicle_Model vm on tb.Model = vm.ModelTypeId and vm.SystemId=vc.SYSTEM_ID and vm.ClientId=vc.CLIENT_ID "+
 		" inner join AMS.dbo.RS232_ASSOCIATION ra on ra.REGISTRATION_NO =vc.REGISTRATION_NUMBER and ra.CLIENT_ID=vc.CLIENT_ID and ra.IO_CATEGORY in ('TEMPERATURE1','TEMPERATURE2','TEMPERATURE3') " +	 		
 		" where vc.SYSTEM_ID = ? and vc.CLIENT_ID=? and vu.User_id=? and REGISTRATION_NUMBER not in (select Vehicle_id from Vehicle_Status where Status_id=4)" +
 		" order by REGISTRATION_NUMBER ";	
	 
	 
	 public static final String GET_VEHICLE_NO_AND_ACT_ARR_DATETIME_FOR_TRIP_CREATION_VALIDATION = "select top 1 td.ASSET_NUMBER," +
	 	" dateadd(mi,?,ds.ACT_ARR_DATETIME) as ACT_ARR_DATETIME,ORDER_ID,isnull(l.NAME,'') as NAME" +
		" from AMS.dbo.TRACK_TRIP_DETAILS (nolock) td " +
		" left outer join AMS.dbo.DES_TRIP_DETAILS (nolock) ds on ds.TRIP_ID = td.TRIP_ID and ds.SEQUENCE = '100' " +
		" left outer join LOCATION_ZONE_A l on l.HUBID=ds.HUB_ID"+
		" where td. ASSET_NUMBER = ? and td.SYSTEM_ID = ? and td.CUSTOMER_ID = ? and td.STATUS in ('OPEN','UPCOMING') # order by  td.TRIP_ID desc";
	 
	 public static final String GET_ALL_ROUTE_NAMES = "select RouteID as routeId,RouteName as routeName, 0 as legCount from  Route_Master a " +
		 		" inner join Route_Detail b on a.RouteID=b.Route_id where a.System_id=? and a.ClientId=? and a.STATUS='Active' " +
		 		" and Route_Segment=1	and TYPE='SOURCE' order by RouteID";
	 
	 public static final String GET_VEHICLES_FROM_VEHICLE_REPORTING=" select distinct ASSET_NO as REGISTRATION_NUMBER ,tvm.VehicleType as VehicleType,isnull(vm.ModelName,'NA') as Model from AMS.dbo.ASSET_REPORTING_DETAILS ard " +
	 		" left outer join AMS.dbo.tblVehicleMaster  tvm on tvm.VehicleNo = ard.ASSET_NO "+
	 		" left outer join FMS.dbo.Vehicle_Model vm on tvm.Model = vm.ModelTypeId and vm.SystemId=ard.SYSTEM_ID and vm.ClientId=ard.CUSTOMER_ID "+
	 		" where DATE =? and SYSTEM_ID = ? and CUSTOMER_ID=? and ASSET_NO !='' ";
	 
		public static final String CHECK_LEG__COMPLETED = "select ID from DES_TRIP_DETAILS where TRIP_ID=? and TYPE='LEG' and SEQUENCE != 0 and ACT_ARR_DATETIME is not null " +
		" and ACT_DEP_DATETIME is null order by SEQUENCE";

		public static final String GET_COMPLETED_LEGS = "select LEG_ID from DES_TRIP_DETAILS where TRIP_ID=? and TYPE='LEG' and ACT_ARR_DATETIME is not null and SEQUENCE != 0 order by SEQUENCE";

		public static final String GET_AVAILABLE_ROUTES = "select ROUTE_ID,LEG_ID from TRIP_ROUTE_DETAILS  a"+
		" left outer join TRIP_ROUTE_MASTER b on a.ROUTE_ID=b.ID"+
		" where b.SYSTEM_ID=? and b.CUSTOMER_ID=? and b.TRIP_CUST_ID=? and ROUTE_ID != ? and b.STATUS='Active' order by ROUTE_ID";

		public static final String GET_CHANGEOVER_ROUTE = "select isnull(a.ID,0) as routeId,isnull(a.ROUTE_NAME,'') as routeName,count(b.ID) as legCount" +
		" from TRIP_ROUTE_MASTER a"+
		" left outer join TRIP_ROUTE_DETAILS b on b.ROUTE_ID=a.ID"+
		" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TRIP_CUST_ID=? and a.STATUS='Active' # group by a.ID,a.ROUTE_NAME";

		public static final String GET_COMPLETED_LEG = "select a.ID as uniqueId,a.LEG_ID,b.ID,a.ACTUAL_ARRIVAL,a.ACTUAL_DEPARTURE,isnull(c.TAT,0) as dur,isnull(c.DISTANCE,0) as distance" +
		" from TRIP_LEG_DETAILS a " +
		" left outer join TRIP_ROUTE_DETAILS b on b.LEG_ID=a.LEG_ID and b.ROUTE_ID=?"+
		" left outer join TRIP_ROUTE_MASTER c on c.ID=b.ROUTE_ID"+
		" where a.TRIP_ID=? and a.ACTUAL_ARRIVAL is not null and a.ACTUAL_DEPARTURE is not null order by a.ID desc";

		public static final String GET_REMAINING_LEG_DETAILS = "select LEG_ID as legId,isnull(a.TAT,0) as tat,isnull(a.DETENTION_TIME,0) as detTime,isnull(b.LEG_NAME,'') as legName,"+
		" isnull(z1.NAME,'') as src,isnull(z2.NAME,'') as dest from TRIP_ROUTE_DETAILS a"+
		" left outer join LEG_MASTER b on b.ID=a.LEG_ID"+
		" left outer join LOCATION_ZONE_A z1 on z1.HUBID=a.SOURCE_HUB"+
		" left outer join LOCATION_ZONE_A z2 on z2.HUBID=a.DESTINATION_HUB"+
		" where a.ROUTE_ID=? and a.ID > ? order by a.LEG_SEQUENCE";

		public static final String INSERT_TRIP_LEG_FOR_NEW_ROUTE = "insert into AMS.dbo.TRIP_LEG_DETAILS (TRIP_ID,LEG_ID,STD,STA,DRIVER_1,DRIVER_2,INSERTED_DATE," +
		" INSERTED_BY) values (?,?,?,?,?,?,getutcdate(),?)";

		public static final String DELETE_OLD_LEGS = "delete from AMS.dbo.TRIP_LEG_DETAILS where TRIP_ID=? and ID > ?";

		public static final String UPDATE_ROUTE_IN_TRIP = "update TRACK_TRIP_DETAILS set ROUTE_ID=?,ROUTE_NAME=?,TRIP_END_TIME=?,PLANNED_DISTANCE=?,PLANNED_DURATION=? where TRIP_ID=?";

		public static final String GET_RUNNING_SEQUENCE = "select top 1 SEQUENCE,PLANNED_DEP_DATETIME from DES_TRIP_DETAILS where TRIP_ID=? and LEG_ID=? order by SEQUENCE desc";

		public static final String DELETE_OLD_POINTS = "delete from DES_TRIP_DETAILS where TRIP_ID = ? and SEQUENCE > ?";

		public static final String GET_NOT_COMPLETED_LEGS = "select LEG_ID from TRIP_LEG_DETAILS where TRIP_ID=? and ACTUAL_ARRIVAL is null and ACTUAL_DEPARTURE is null order by ID";
		
		public static final String GET_ROUTE_TRASIT_POINTS = "select a.TYPE,a.LEG_ID,a.LATITUDE,a.LONGITUDE,isnull(a.HUB_ID,'0') as hubId," +
		" isnull(SUBSTRING(l.NAME,1,CHARINDEX(',',l.NAME)),'') as name,isnull(a.DURATION,0) as DURATION,isnull(DETENTION,0) as detention," +
		" isnull(a.RADIUS,0) as RADIUS,isnull(a.SEQUENCE_DISTANCE,0) as SEQUENCE_DISTANCE,isnull(b.AVG_SPEED,0) as AVG_SPEED " +
		" from LEG_DETAILS a"+ 
		" left outer join LEG_MASTER b on b.ID=a.LEG_ID"+ 
		" left outer join LOCATION_ZONE_A l on l.HUBID=a.HUB_ID" +
		" where a.LEG_ID=? and b.STATUS='Active' and a.TYPE in ('DESTINATION','CHECKPOINT') order by a.ROUTE_SEQUENCE,a.ROUTE_SEGMENT";
		
		public static final String INSERT_TRIP_POINTS_CHECK_POINTS = " insert into AMS.dbo.DES_TRIP_DETAILS (TRIP_ID,HUB_ID,STD_TIME,SEQUENCE,STATUS,PLANNED_ARR_DATETIME," +
		" PLANNED_DEP_DATETIME,LATITUDE,LONGITUDE,RADIUS,ROUTE_ID,NAME,DETENTION_TIME,LEG_ID,TYPE) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		public static final String GET_SOURCE_DESTINATION_LEG = "select LEG_ID from TRIP_LEG_DETAILS where TRIP_ID=?";
		
		public static final String GET_SOURCE_DESTINATION_POINT = "select a.LATITUDE,a.LONGITUDE,isnull(a.HUB_ID,'0') as hubId," +
		" isnull(SUBSTRING(l.NAME,1,CHARINDEX(',',l.NAME)),'') as name,isnull(a.RADIUS,0) as RADIUS,isnull(DETENTION,0) as detention," +
		" isnull(a.DURATION,0) as DURATION,isnull(a.SEQUENCE_DISTANCE,0) as SEQUENCE_DISTANCE,isnull(b.AVG_SPEED,0) as AVG_SPEED " +
		" from LEG_DETAILS a " +
		" left outer join LEG_MASTER b on b.ID=a.LEG_ID " +
		" left outer join LOCATION_ZONE_A l on l.HUBID=a.HUB_ID" +
		" where LEG_ID=? and a.TYPE=? and b.STATUS='Active'";
		
		public static final String INSERT_TRIP_POINTS_DESTINATION = "insert into AMS.dbo.DES_TRIP_DETAILS (TRIP_ID,HUB_ID,STD_TIME,SEQUENCE,STATUS,PLANNED_ARR_DATETIME," +
		" PLANNED_DEP_DATETIME,LATITUDE,LONGITUDE,RADIUS,ROUTE_ID,NAME,DETENTION_TIME,LEG_ID,TYPE) values (?,?,?,?,?,?,dateadd(mi,?,?),?,?,?,?,?,?,?,?)";
		
		public static final String GET_TRIP_SHEET_DATA_FIELDS_SETTING_DETAILS = " select isnull(DATA_FIELD_NAME,'')as FIELD_NAME,isnull(DATA_FIELD_VALUE,'')as FIELD_VALUE from AMS.dbo.TRIP_SHEET_DATA_FIELD_SETTING where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Y' order by SEQUENCE_ID";
		
		public static final String UPDATED_SWAPPED_VEHICLE_NUMBER_FOR_TRIP = " update AMS.dbo.TRACK_TRIP_DETAILS set ASSET_NUMBER = ?, SWAPPED_VEHICLE = ?, SWAP_REMARKS = ?, SWAPPED_DATETIME = getUTCdate(), SWAPPED_BY = ? where TRIP_ID = ? ";
		
		public static final String VALIDATE_DRIVER_FOR_TRIP_MODIFY = "select STD,STA from TRIP_LEG_DETAILS where DRIVER_# = ? $";
		
		public static final String GET_DRIVER_NAME = "select Fullname  as DRIVER_NAME,Mobile from Driver_Master where Driver_id = ? AND System_id = ?";
		
		public static final String GET_TRIP_DRIVER_DETAILS = "select ID from TRIP_DRIVER_DETAILS where TRIP_ID = ? and LEG_ID = ? ";
		
		public static final String UPDTAE_TRIP_DRIVER_DETAILS = "update TRIP_DRIVER_DETAILS set DRIVER_ID=? where ID = ? and  TRIP_ID=? and LEG_ID=?";
		
		public static final String GET_TRIP_SCHEDULE_ACTUAL_TIME_DETAILS = "select td.TRIP_ID as ID,isnull(td.ORDER_ID,'') as ORDER_ID," +
		 " td.ASSET_NUMBER,dateadd(mi,?,ds1.PLANNED_ARR_DATETIME) as STP,dateadd(mi,?,ds1.ACT_ARR_DATETIME) as ATP,dateadd(mi,?,td.TRIP_START_TIME) as STD," +
		 " dateadd(mi,?,td.ACTUAL_TRIP_START_TIME) as ATD,dateadd(mi,?,ds.PLANNED_ARR_DATETIME) as STA,dateadd(mi,?,ds.ACT_ARR_DATETIME) as ATA,td.TRIP_REMARKS "+
		 " from dbo.TRACK_TRIP_DETAILS (nolock) td" +
		 " left outer join AMS.dbo.DES_TRIP_DETAILS (nolock) ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100"+
		 " left outer join AMS.dbo.DES_TRIP_DETAILS (nolock) ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0"+
		 " left outer join AMS.dbo.Users u on u.System_id=td.SYSTEM_ID and u.User_id=td.INSERTED_BY "+
		 " where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS = 'OPEN' and td.TRIP_STATUS <> 'NEW' " +
		 " and (td.ACTUAL_TRIP_START_TIME IS NULL or ds.ACT_ARR_DATETIME is null) order by td.INSERTED_TIME desc ";
		
		public static final String UPDATE_MAIN_ATP_ATD = "UPDATE dbo.TRACK_TRIP_DETAILS SET OVERRIDDEN_REMARKS=?,ACTUAL_DURATION=datediff(minute, dateadd(mi,-?,?), dateadd(mi,-?,?)) # WHERE TRIP_ID=?";
		
		public static final String UPDATE_DES_ATP = "UPDATE dbo.DES_TRIP_DETAILS SET ACT_ARR_DATETIME=dateadd(mi,-?,?) WHERE TRIP_ID=? AND SEQUENCE=?";
		
		public static final String UPDATE_DES_ATD = "UPDATE dbo.DES_TRIP_DETAILS SET ACT_DEP_DATETIME=dateadd(mi,-?,?),DISTANCE_FLAG='Y' WHERE TRIP_ID=? AND SEQUENCE=0";
		
		public static final String UPDATE_LEG_ATD = "UPDATE dbo.TRIP_LEG_DETAILS SET ACTUAL_DEPARTURE=dateadd(mi,-?,?) WHERE TRIP_ID=? AND" +
		" ID=(SELECT TOP(1) ID FROM TRIP_LEG_DETAILS WHERE TRIP_ID=? ORDER BY ID)";
		
		public static final String CHECK_IS_VALID_ATA ="select case when (MAX(ACT_DEP_DATETIME) > dateadd(mi,-?,?)) then 'false' else 'true' end as IS_VALID," +
		" dateadd(mi,?,MAX(ACT_DEP_DATETIME)) as maxDate FROM DES_TRIP_DETAILS WHERE TRIP_ID=?";
		
		public static final String VALIDATE_TRIP_LR_NO = "SELECT COUNT(ORDER_ID) AS LR_NO_COUNT FROM TRACK_TRIP_DETAILS WHERE SYSTEM_ID = ? AND CUSTOMER_ID = ? AND UPPER(ORDER_ID) = UPPER(?) ";
		
		public static final String INSERT_TRIP_VEHICLE_TEMPERATURE_DETAILS = "insert into AMS.dbo.TRIP_VEHICLE_TEMPERATURE_DETAILS (TRIP_ID,VEHICLE_NUMBER,DISPLAY_NAME,SENSOR_NAME,MIN_NEGATIVE_TEMP,MIN_POSITIVE_TEMP,MAX_NEGATIVE_TEMP,MAX_POSITIVE_TEMP,INSERTED_DATE,TRIGGER_ALERT)" +
		" values (?,?,?,?,?,?,?,?,getutcdate(),?)";
		
		public static final String GET_TRIP_VEHICLE_TEMPERATURE_DETAILS = "SELECT * FROM AMS.dbo.TRIP_VEHICLE_TEMPERATURE_DETAILS WHERE TRIP_ID = ? AND VEHICLE_NUMBER = ?";
		
		public static final String GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID = "SELECT td.ROUTE_ID,ASSET_NUMBER,ORDER_ID,ROUTE_NAME,ACTUAL_TRIP_END_TIME," +
		" isnull(de.NAME,'') as DEST_NAME,isnull(de0.NAME,'') as SOURCE_NAME,tds.TRIP_STATUS,isnull(td.TRIP_CUSTOMER_TYPE,'') as tripCustType," +
		" isnull(de0.SUCCESSOR_ID,0) as srcSuccessor,isnull(de.SUCCESSOR_ID,0) as destSuccessor " +
		" FROM dbo.TRACK_TRIP_DETAILS (nolock) td"+
		" left outer join DES_TRIP_DETAILS (nolock) de on de.TRIP_ID=td.TRIP_ID and de.SEQUENCE=100"+
		" left outer join DES_TRIP_DETAILS (nolock) de0 on de0.TRIP_ID=td.TRIP_ID and de0.SEQUENCE=0"+
		" left outer join dbo.TRACK_TRIP_DETAILS_SUB (nolock) tds on tds.TRIP_ID=td.TRIP_ID"+
		" WHERE td.TRIP_ID = ? AND SYSTEM_ID = ? AND CUSTOMER_ID = ?";
		
		public static final String MODIFY_TRIP_DETAILS_ON_ROUTE_OR_VEHICLE_NUMBER_CHANGE = " update AMS.dbo.TRACK_TRIP_DETAILS set TRIP_START_TIME=dateadd(mi,-?,?),TRIP_STATUS='NEW',UPDATED_BY=?," +
 		" UPDATED_DATETIME=getutcdate(),PRE_LOADING_TEMP=?,LAST_EXEC_DATE=null,LAST_EXEC_TIME_ATP=null,ACTUAL_TRIP_START_TIME=null,ETA_AVG_SPEED = ?,ROUTE_ID=?,ASSET_NUMBER= ?,PRODUCT_LINE =?,CUSTOMER_REF_ID =?,TRIP_CATEGORY = ?,ROUTE_NAME = ?,SHIPMENT_ID = ?,ACT_SRC_ARR_DATETIME=null where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_ID=? ";
		
		 public static final String DELETE_TRIP_LEG_DETAILS = " delete from AMS.dbo.TRIP_LEG_DETAILS where TRIP_ID=? ";
		 
		 public static final String GET_COUNT_FOR_LR_NO_FROM_LOOK_UP_TABLE= "SELECT TRIP_COUNT FROM AMS.dbo.TRIP_SHEET_SETTING WHERE SYSTEM_ID = ? AND CUSTOMER_ID = ?";
		 
		 public static final String UPDATE_LR_COUNT_FOR_LOOK_UP_TABLE= "UPDATE AMS.dbo.TRIP_SHEET_SETTING SET TRIP_COUNT = ? WHERE SYSTEM_ID = ? AND CUSTOMER_ID = ?";
		 
		 public static final String INSERT_NEW_RECORD_FOR_TRIP_LOOKUP_DETAILS = "INSERT INTO [dbo].[TRIP_LOOKUP_DETAILS] (TRIP_COUNT,DISTANCE_FLAG,HISTORY_DATA_COUNT,TRIP_TRIGGER_TIME_MIN,SYSTEM_ID,CUSTOMER_ID) values (?,null,null,null,?,?)";
		 
		 public static final String GET_TRIP_CANCELLATION_REMARKS = "select VALUE from AMS.dbo.LOOKUP_DETAILS where VERTICAL='TRIP_CANCELLATION_REMARKS' order by TYPE";
		 
		 public static final String GET_CURRENT_LOCATION = "SELECT isnull(gps.LOCATION,'') AS  END_LOCATION FROM  dbo.gpsdata_history_latest gps WHERE  gps.REGISTRATION_NO= ? AND gps.System_id=? AND gps.CLIENTID = ?";
		 
		 public static final String GET_RUNNING_LEG = "SELECT LEG_ID FROM TRIP_LEG_DETAILS WHERE ACTUAL_DEPARTURE IS NOT NULL AND ACTUAL_ARRIVAL IS NULL AND TRIP_ID  = ?";
		 
		 public static final String UPDTAE_DRIVERS_TO_LIVE_VISION = "UPDATE dbo.gpsdata_history_latest set DRIVER_NAME = ?, DRIVER_MOBILE=? where REGISTRATION_NO = ? and  System_id=? and CLIENTID=?";
		 
		 public static final String GET_TEMPERATURE_CONFIGURATIONS  = "SELECT * FROM AMS.dbo.TRIP_VEHICLE_TEMPERATURE_DETAILS WHERE TRIP_ID = ? AND VEHICLE_NUMBER = ?";
		 
		 public static final String UPDATE_TRIP_VEHICLE_TEMPERATURE_DETAILS = "UPDATE AMS.dbo.TRIP_VEHICLE_TEMPERATURE_DETAILS SET MIN_NEGATIVE_TEMP = ? , MIN_POSITIVE_TEMP = ?, MAX_NEGATIVE_TEMP = ? , MAX_POSITIVE_TEMP = ?, INSERTED_DATE = getutcdate() WHERE TRIP_ID = ? AND VEHICLE_NUMBER = ? AND DISPLAY_NAME = ?";
		 
		 public static final String DELETE_TRIP_VEHICLE_TEMPERATURE_DETAILS = "DELETE FROM AMS.dbo.TRIP_VEHICLE_TEMPERATURE_DETAILS WHERE TRIP_ID = ?";
 
		 public static final String UPDATE_MAIN_TRIP_FOR_MLL = "update TRACK_TRIP_DETAILS set STATUS=?,ACTUAL_TRIP_END_TIME=getutcdate(),AUTO_CLOSE=?," +
		 " CANCELLED_BY=?,REMARKS=?,CANCELLED_DATE=getutcdate(),ACTUAL_DISTANCE=PLANNED_DISTANCE,ACTUAL_DURATION=PLANNED_DURATION,TRIP_STATUS = 'FORCEFULLY' where TRIP_ID=?";
		 
		 public static final String CLOSE_SEMI_AUTOMATED_TRIP = "update TRACK_TRIP_DETAILS set STATUS=?,ACTUAL_TRIP_END_TIME=dateadd(mi,-?,?),AUTO_CLOSE=?," +
		 " CANCELLED_BY=?,REMARKS=?,CANCELLED_DATE=getutcdate(),END_LOCATION=?, TRIP_STATUS = 'FORCEFULLY' where TRIP_ID=?";
		 
		 public static final String UPDATE_MAIN_TRIP = "update TRACK_TRIP_DETAILS set STATUS=?,AUTO_CLOSE=?,CANCELLED_BY=?,REMARKS=?,CANCELLED_DATE=getutcdate()," +
		 " TRIP_STATUS='FORCEFULLY',END_LOCATION=?,ACTUAL_TRIP_END_TIME=getutcdate(),ACTUAL_DURATION=datediff(minute, dateadd(mi,-?,?), dateadd(mi,-?,?)) # where TRIP_ID=?";

		 public static final String UPDATE_DES_ATA = "UPDATE dbo.DES_TRIP_DETAILS SET ACT_ARR_DATETIME=dateadd(mi,-?,?) WHERE TRIP_ID=? AND SEQUENCE=100";

		 public static final String UPDATE_TRIP_LEG_DETAILS_WHILE_CLOSING = "update AMS.dbo.TRIP_LEG_DETAILS set ACTUAL_ARRIVAL=dateadd(mi,-?,?) where TRIP_ID=? and ID = " +
		"(select top 1 ID from AMS.dbo.TRIP_LEG_DETAILS where TRIP_ID=? order by ID desc)";
		 
		public static final String GET_AUTO_CLOSED_TRIPS = " SELECT TD.TRIP_ID,TD.SHIPMENT_ID,ISNULL(DES.PLANNED_ARR_DATETIME,'') PLANNED_ARR_DATETIME ," +
		" ISNULL(DES.ACT_ARR_DATETIME,'') ACT_ARR_DATETIME ,ISNULL(ACT_DEP_DATETIME,'') ACT_DEP_DATETIME, ISNULL(PLANNED_DEP_DATETIME,'') PLANNED_DEP_DATETIME " +
		" FROM TRACK_TRIP_DETAILS (nolock) TD " +
 		" LEFT OUTER JOIN DES_TRIP_DETAILS (nolock) DES ON DES.TRIP_ID = TD.TRIP_ID AND DES.SEQUENCE = 100 " +
 		" WHERE TD.SYSTEM_ID = ? AND TD.CUSTOMER_ID = ? AND TD.STATUS = 'CLOSED' AND AUTO_CLOSE IS NULL ORDER BY TD.TRIP_ID DESC ";
		 
		 
		 public static final String INSERT_TRACK_TRIP_DETAILS_SUB = "INSERT INTO TRACK_TRIP_DETAILS_SUB (TRIP_ID,REOPEN_DATE,REOPEN_BY,REOPEN_REASON,TRIP_STATUS) VALUES (?,getutcdate(),?,?,?)";
		 
		 public static final String UPDATE_TRACK_TRIP_DETAILS_ON_REOPEN = "UPDATE TRACK_TRIP_DETAILS SET CANCELLED_DATE = getutcdate(),CANCELLED_BY = ? ,REMARKS = ?,STATUS = ?," +
		 		" ACTUAL_TRIP_END_TIME=null,AUTO_CLOSE=null WHERE TRIP_ID = ?";

		 public static final String UPDATE_TRACK_TRIP_DETAILS = "UPDATE TRACK_TRIP_DETAILS SET CANCELLED_DATE = getutcdate(),CANCELLED_BY = ? ,REMARKS = ?,STATUS = ?," +
	 		" ACTUAL_TRIP_END_TIME=getutcdate(),AUTO_CLOSE='N',ACTUAL_DURATION=datediff(minute, dateadd(mi,-?,?),dateadd(mi,-?,?)) # WHERE TRIP_ID = ?";
		 
		public static final String GET_API_DETAILS = "select URL,AUTH from API_CONFIGURATION_DETAILS where API_TYPE=?";
		 
		public static final String GET_AVAILABLE_VEHICLES=" select  distinct isnull(vc.REGISTRATION_NUMBER,'') as REGISTRATION_NUMBER ,isnull(tb.VehicleType,'NA') as VehicleType,isnull(vm.ModelName,'NA') as Model from VEHICLE_CLIENT vc " +
		" inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER=vu.Registration_no and  vc.SYSTEM_ID=vu.System_id " +
 		" inner join  AMS.dbo.tblVehicleMaster tb  on vc.REGISTRATION_NUMBER=tb.VehicleNo " + 
 		" left outer join FMS.dbo.Vehicle_Model vm on tb.Model = vm.ModelTypeId and vm.SystemId=vc.SYSTEM_ID and vm.ClientId=vc.CLIENT_ID "+
 		" inner join AMS.dbo.RS232_ASSOCIATION ra on ra.REGISTRATION_NO =vc.REGISTRATION_NUMBER and ra.CLIENT_ID=vc.CLIENT_ID and ra.IO_CATEGORY in ('TEMPERATURE1','TEMPERATURE2','TEMPERATURE3') " +	 		
 		" where vc.SYSTEM_ID = ? and vc.CLIENT_ID=? and vu.User_id=? and REGISTRATION_NUMBER not in (select Vehicle_id from Vehicle_Status where Status_id=4)" +
 		" and REGISTRATION_NUMBER not in( select ASSET_NUMBER FROM TRACK_TRIP_DETAILS (nolock) WHERE STATUS='OPEN')" +
 		" order by REGISTRATION_NUMBER ";

		public static final String UPDATE_DES_TRIP_DETAILS_ON_REOPEN = "update DES_TRIP_DETAILS set ACT_DEP_DATETIME=null,PRO_DEPARTURE=null,PRO_ARRIVAL=null" +
		" where TRIP_ID=? and SEQUENCE=100";	
	 
		public static final String CHECK_TRIP_STATUS = "select top 1 STATUS from AMS.dbo.TRACK_TRIP_DETAILS (nolock) where ASSET_NUMBER=? and STATUS='OPEN' order by TRIP_ID desc ";

		public static final String UPDATE_SUB_TRIP_DETAILS = "update AMS.dbo.TRACK_TRIP_DETAILS_SUB set TRIP_STATUS=?,CALCULATE_SLAREPORT=?,CALCULATE_TRIPAPI=? where TRIP_ID=?";

		public static final String UPDATE_DES_ATP_AND_ATD = "update DES_TRIP_DETAILS set ACT_ARR_DATETIME=dateadd(mi,-?,?),ACT_DEP_DATETIME=dateadd(mi,-?,?),DISTANCE_FLAG='Y' where TRIP_ID=? and SEQUENCE=0";

		public static final String UPDATE_ATD_TO_TRIP_LEG_DETAILS = "update TRIP_LEG_DETAILS set ACTUAL_DEPARTURE=dateadd(mi,-?,?) where TRIP_ID=?" +
		" and ID = (select top 1 ID from TRIP_LEG_DETAILS where TRIP_ID=? order by ID)";

		public static final String GET_TRIPS_WITHOUT_ACTUALS = "select td.SHIPMENT_ID,ISNULL(td.ORDER_ID,'') AS ORDER_ID,isnull(DATEADD(MI,?,td.ACT_SRC_ARR_DATETIME),'') AS ATP," +
		" isnull(DATEADD(MI,?,td.ACTUAL_TRIP_START_TIME),'') AS ATD,isnull(DATEADD(MI,?,de100.ACT_ARR_DATETIME),'') AS ATA," +
		" isnull(DATEADD(MI,?,td.ACTUAL_TRIP_END_TIME),'') AS TripEndTime,td.ASSET_NUMBER,td.TRIP_ID,isnull(OVERRIDDEN_BY,'') as atpAtdOverridden,isnull(ATA_OVERIDDEN_BY,'') ataOverridden " +
		" from TRACK_TRIP_DETAILS td"+
		" inner join DES_TRIP_DETAILS de100 on de100.TRIP_ID=td.TRIP_ID and de100.SEQUENCE=100"+
		" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS in ('CLOSED') and INSERTED_TIME > '2019-05-31 18:30:00' # order by td.TRIP_ID desc";

		public static final String UPDATE_TRACK_TRIP_DETAILS_ON_UPDATE_ACTUALS = "UPDATE TRACK_TRIP_DETAILS SET ACTUAL_DURATION=datediff(minute, dateadd(mi,-?,?), dateadd(mi,-?,?)) # WHERE TRIP_ID = ?";

		public static final String GET_VEHICLE_TYPE = "SELECT VehicleType FROM tblVehicleMaster t INNER JOIN VEHICLE_CLIENT vc ON vc.REGISTRATION_NUMBER=t.VehicleNo WHERE vc.CLIENT_ID = ? group by VehicleType";
		
		public static final String GET_DC_VEHICLE_TYPE = "select VehicleType from tblVehicleMaster t inner join VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=t.VehicleNo where  VehicleType like '%DC%' or VehicleType like '%dc%'" +
               " and vc.CLIENT_ID=? group by VehicleType";
		
		public static final String GET_TCL_VEHICLE_TYPE = "select VehicleType from tblVehicleMaster t inner join VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=t.VehicleNo where  VehicleType like '%TCL%' or VehicleType like '%tcl%'" +
        " and vc.CLIENT_ID=? group by VehicleType";
		
		
		}

