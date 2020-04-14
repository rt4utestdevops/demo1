package t4u.statements;

public class GeneralVerticalStatements {

	public static final String GET_TRIP_SUMMARY_DETAILS = "select isnull(td.TRIP_ID,0) as tripId,isnull(td.SHIPMENT_ID,'') as tripName,isnull(td.ASSET_NUMBER,'') as vehicleNo,isnull(td.ROUTE_NAME,'') as routeName," +
	" isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as plannedDate,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as actualDate,isnull(td.ACTUAL_DISTANCE,0) as actualDuration," +
	" isnull(count(ed.TRIP_ID),0) as eventsCount,isnull(td.START_LOCATION,'') as startLocation,isnull(gps.LOCATION,'') as currentLocation," +
	" (isnull(td.STATUS,'')+'-'+isnull(td.TRIP_STATUS,'')) as status,(case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as endDate,"+
	" isnull(ds1.NAME,'') as ORIGIN, isnull(ds.NAME,'') as DESTINATION,isnull(td.DELAY,'') as DELAY, " +
	" isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,isnull(NEXT_POINT,'') as NEAREST_HUB " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" left outer join AMS.dbo.TRIP_EVENT_DETAILS ed on ed.TRIP_ID=td.TRIP_ID"+ 
	" left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID"+
	" inner join AMS.dbo.Vehicle_User vu on vu.Registration_no=td.ASSET_NUMBER and vu.User_id=?"+
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100 "+
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0" + 
	" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? #"+ 
	" group by td.TRIP_ID,td.SHIPMENT_ID,td.ASSET_NUMBER,td.ROUTE_NAME,td.TRIP_START_TIME,td.ACTUAL_TRIP_START_TIME,td.ACTUAL_DISTANCE,ds1.NAME,ds.NAME,td.NEXT_POINT_ETA,td.DESTINATION_ETA, " +
	" gps.LOCATION,td.START_LOCATION,td.STATUS,td.TRIP_STATUS,td.ACTUAL_TRIP_END_TIME,NEXT_POINT,td.DELAY order by td.TRIP_ID desc ";

	
	public static final String VEHICLE_COUNT = "select count(a.ASSET_NUMBER) as vehicleCount,'On Trip' as type from AMS.dbo.TRACK_TRIP_DETAILS a"+
	" inner join AMS.dbo.Vehicle_User vu on vu.Registration_no=a.ASSET_NUMBER and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='OPEN' and a.TRIP_STATUS <> 'NEW'"+
	" union all"+ 
	" select count(ASSET_NUMBER) as vehicleCount,'Assigned' as type from AMS.dbo.TRACK_TRIP_DETAILS a"+
	" inner join AMS.dbo.Vehicle_User vu on vu.Registration_no=a.ASSET_NUMBER and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='OPEN'"+
	" union all"+
	" select count(tvm.VehicleNo) as vehicleCount,'Total' as type from AMS.dbo.tblVehicleMaster tvm"+
	" left outer join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=tvm.VehicleNo"+
	" inner join AMS.dbo.Vehicle_User vu on vu.Registration_no=tvm.VehicleNo and vu.User_id=?"+
	" where tvm.System_id=? and vc.CLIENT_ID=? ";

	//Query is hard coded for MainPower and Restrictive Hours 
	public static final String GET_MAIN_POWER_RESTRICTIVE_ALERT_COUNT = "select count(REGISTRATION_NO) as alertCount,TYPE_OF_ALERT from dbo.Alert a"+ 
	" inner join Vehicle_User vu on vu.System_id=a.SYSTEM_ID and vu.Registration_no=a.REGISTRATION_NO and vu.User_id=?"+
	" where  a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT in (7,45) and a.GMT >= dateadd(dd,-1,getutcdate()) and a.ACTION_TAKEN is null" +
	" group by TYPE_OF_ALERT order by a.TYPE_OF_ALERT";

	public static final String GET_PANIC_ALERT_COUNT = "select count(a.REGISTRATION_NO) as alertCount,a.TYPE_OF_ALERT from ALERT.dbo.PANIC_DATA a"+  
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT=3 and a.GMT >= dateadd(dd,-1,getutcdate()) and a.REMARK is null" +
	" group by TYPE_OF_ALERT order by TYPE_OF_ALERT";

	public static final String GET_HARSH_ALERT_COUNT = "select count(a.REGISTRATION_NO) as alertcount,a.TYPE_OF_ALERT from ALERT.dbo.HARSH_ALERT_DATA a"+  
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT=58 and a.GMT >= dateadd(dd,-1,getutcdate()) and a.REMARK is null group by a.TYPE_OF_ALERT order by TYPE_OF_ALERT";

	public static final String GET_TRIP_EVENT_DETAILS = "select isnull(VEHICLE_NO,'') as vehicleNo,isnull(dateadd(mi,?,GMT),'') as dateTime,isnull(LOCATION,'') as location," +
	" isnull(ALERT_NAME,'') as alertName from AMS.dbo.TRIP_EVENT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_ID=? order by GMT desc";
	
    public static final String GET_USER_ASSOCIATED_CUSTOMER = "select isnull(q1.NAME,'') as CUSTOMER_NAME, isnull(q1.ID,0) as CUSTOMER_ID  from dbo.TRIP_CUSTOMER_DETAILS as q1 inner join dbo.USER_TRIP_CUST_ASSOC as q2 on q2.TRIP_CUSTOMER_ID = q1.ID where q2.SYSTEM_ID =? # order by q1.ID ";
	
	public static final String GET_ASSOCIATED_CUSTOMER = "select isnull(q1.NAME,'') as CUSTOMER_NAME, isnull(q1.ID,0) as CUSTOMER_ID from TRIP_CUSTOMER_DETAILS q1 where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active' order by ID";

	public static final String GET_SUMMARY_DETAILS = "select  t.VEHICLE_EXIT,t.vehicleNo,t.location,t.plannedDate,t.occuredTime,t.status,t.alertName,t.lat,t.lon,t.sequence,t.typename,t.alertId,t.speed,t.stoppagetime from" +
	" (select isnull(td.ASSET_NUMBER,'') as vehicleNo,isnull(sd.NAME,'') as location,isnull(dateadd(mi,?,sd.PLANNED_DEP_DATETIME),'') as plannedDate," +
	"(case when sd.SEQUENCE=0 then isnull(dateadd(mi,?,sd.ACT_DEP_DATETIME),'') else isnull(dateadd(mi,?,sd.ACT_ARR_DATETIME),'') end ) as occuredTime,"+
	" isnull(dateadd(mi,?,sd.ACT_DEP_DATETIME),'') as VEHICLE_EXIT, " +
	" isnull(sd.STATUS,'') as status,'NA' as alertName,isnull(sd.LATITUDE,0) as lat,isnull(sd.LONGITUDE,0) as lon,isnull(sd.SEQUENCE,0) as sequence,'checkPoint' as typename,0 as alertId,0 as speed,0 as stoppagetime"+
	" from AMS.dbo.DES_TRIP_DETAILS sd"+
	" left outer join AMS.dbo.TRACK_TRIP_DETAILS td on sd.TRIP_ID=td.TRIP_ID where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.TRIP_ID=?"+
	" union all"+
	" select isnull(VEHICLE_NO,'') as vehicleNo,isnull(LOCATION,'') as location,'' as plannedDate,isnull(dateadd(mi,?,GMT),'') as occuredTime,'' as VEHICLE_EXIT,'NA' as status,"+
	" isnull(ALERT_NAME,'') as alertName,isnull(LATITUDE,0) as lat,isnull(LONGITUDE,0) as lon,'0' as sequence,'events' as typename,isnull(ALERT_TYPE,0) as alertId,isnull(SPEED,0) as speed,isnull(STOP_HOURS,0) as stoppagetime " +
	" from AMS.dbo.TRIP_EVENT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_ID=?) t # order by occuredTime desc";

	public static final String GET_ALERT_DETAILS_FOR_DASHBOARD = "select isnull(REGISTRATION_NO,'') as registrationNo,isnull(LOCATION,'') as location,dateadd(mi,?,GMT) as alretDate"+
	" from AMS.dbo.Alert a"+
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and vu.Registration_no=a.REGISTRATION_NO and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CLIENTID=? and a.ACTION_TAKEN is null # order by GMT desc";

	public static final String GET_PANIC_ALERT_DETAILS_FOR_DASHBOARD = "select isnull(REGISTRATION_NO,'') as registrationNo,isnull(LOCATION,'') as location,dateadd(mi,?,GMT) as alretDate"+
	" from ALERT.dbo.PANIC_DATA a"+
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.REMARK is null # order by a.GMT desc";

	public static final String GET_HARSH_ALERT_DETAILS_FOR_DASHBOARD = "select isnull(REGISTRATION_NO,'') as registrationNo,isnull(LOCATION,'') as location,dateadd(mi,?,GMT) as alretDate"+
	" from ALERT.dbo.HARSH_ALERT_DATA a"+
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? # and a.REMARK is null order by a.GMT desc";

	public static final String GET_OBD_ALERT_DETAILS_FOR_DASHBOARD = "select isnull(REGISTRATION_NO,'') as registrationNo,isnull(LOCATION,'') as location,dateadd(mi,?,GMT) as alretDate"+
	" from AMS.dbo.CANIQ_ERROR_CODES a"+
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CLIENT_ID=? and a.ACTION_TAKEN is null # order by a.GMT desc";

	public static final String GET_ENGINE_ERROR_CODE = "select count(REGISTRATION_NO) as alertCount from AMS.dbo.CANIQ_ERROR_CODES a"+
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CLIENT_ID=? and a.GMT >= dateadd(dd,-1,getutcdate()) and a.ACTION_TAKEN is null";

	public static final String GET_OVERSPEED_ALERT = "select count(REGISTRATION_NO) as alertCount from ALERT.dbo.OVER_SPEED_DATA a"+
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.GMT >= dateadd(dd,-1,getutcdate()) and a.REMARK is null";
	
	public static final String GET_STATE_OF_CHARGE_COUNT = "select COUNT(REGISTRATION_NO)  as COUNT, 'SOC' AS STATUS from dbo.GPSDATA_LIVE_CANIQ a "+
															" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.System_id and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT " +
															"and vu.User_id=?  where "+
														    " a.System_id=? and a.CLIENTID=? and a.STATE_OF_CHARGE<30"+
															" union all "+
															"select COUNT(REGISTRATION_NO) as COUNT, 'AC_COUNT' AS STATUS from dbo.GPSDATA_LIVE_CANIQ a "+
															" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.System_id and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT " +
															"and vu.User_id=?  where "+
														    " a.System_id=? and a.CLIENTID=? and a.AC=1"+
															" union all "+
															"select COUNT(REGISTRATION_NO) as COUNT, 'BOOST' AS STATUS  from dbo.GPSDATA_LIVE_CANIQ a "+ 
															" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.System_id and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT "+
															" and vu.User_id=?  where "+
															" a.System_id=? and a.CLIENTID=? and a.GEAR NOT IN(0,1,2)";

	
	public static final String GET_STATE_OF_CHARGE_DETAILS = " select caniq.STATE_OF_CHARGE,isnull(gps.REGISTRATION_NO,'') as registrationNo," +
															"('(SOC : '+cast(STATE_OF_CHARGE as varchar(3))+'%) ' +isnull(gps.LOCATION,'')) as location," +
															"dateadd(mi,?,caniq.GMT) as alretDate,  "+
															"CASE WHEN DATEDIFF(hh,caniq.GMT,getutcdate()) < 6 THEN 'Communicating' ELSE 'NonCommunicating' END AS COMM"+
															" from dbo.GPSDATA_LIVE_CANIQ caniq "+
															" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=caniq.REGISTRATION_NO " +
															" inner join AMS.dbo.Vehicle_User vu on vu.System_id=caniq.System_id and vu.Registration_no=caniq.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=?  "+ 
															" where caniq.System_id=? and caniq.CLIENTID=? and caniq.STATE_OF_CHARGE<30";
	
	public static final String GET_AC_ON_STATUS_DETAILS = " select caniq.AC,isnull(gps.REGISTRATION_NO,'') as registrationNo," +
	"+isnull(gps.LOCATION,'') as location," +
	"dateadd(mi,?,caniq.GMT) as alretDate  "+
	" from dbo.GPSDATA_LIVE_CANIQ caniq "+
	" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=caniq.REGISTRATION_NO " +
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=caniq.System_id and vu.Registration_no=caniq.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=?  "+ 
	" where caniq.System_id=? and caniq.CLIENTID=? and caniq.AC=1";

	public static final String GET_OVERSPEED_FOR_DASHBOARD = "select isnull(REGISTRATION_NO,'') as registrationNo,isnull(LOCATION,'') as location,dateadd(mi,?,GMT) as alretDate," +
	" isnull(SPEED,0) as speed from ALERT.dbo.OVER_SPEED_DATA a"+
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and vu.Registration_no=a.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=?"+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.REMARK is null # order by a.GMT desc";
	
	public static final String GET_TRIP_SUMMARY_DETAILS_AMAZON = "select isnull(td.TRIP_ID,0) as tripId,isnull(td.SHIPMENT_ID,'') as tripName,isnull(td.ASSET_NUMBER,'') as vehicleNo,isnull(td.ROUTE_NAME,'') as routeName," +
	" isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as plannedDate,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as actualDate,isnull(td.ACTUAL_DISTANCE,0) as actualDuration," +
	" isnull(count(ed.TRIP_ID),0) as eventsCount,isnull(td.START_LOCATION,'') as startLocation,isnull(gps.LOCATION,'') as currentLocation," +
	" (isnull(td.STATUS,'')+'-'+isnull(td.TRIP_STATUS,'')) as status,(case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as endDate," +
	" isnull(NEXT_LOCATION,'') as NEXT_LOCATION,'' as START_DATE,isnull(dateadd(mi,?,td.DRIVER_NAME),'') AS ORIGIN, " +
	" isnull((select NAME from DES_TRIP_DETAILS where TRIP_ID=td.TRIP_ID and SEQUENCE=1),'') as CHECKPOINT_1, " +
	" isnull((select NAME from DES_TRIP_DETAILS where TRIP_ID=td.TRIP_ID and SEQUENCE=2),'') as CHECKPOINT_2, " +
	" isnull((select NAME from DES_TRIP_DETAILS where TRIP_ID=td.TRIP_ID and SEQUENCE=3),'') as CHECKPOINT_3, " +
	" isnull((select NAME from DES_TRIP_DETAILS where TRIP_ID=td.TRIP_ID and SEQUENCE=4),'') as CHECKPOINT_4, " +
	" isnull((select NAME from DES_TRIP_DETAILS where TRIP_ID=td.TRIP_ID and SEQUENCE=5),'') as CHECKPOINT_5  " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" left outer join AMS.dbo.TRIP_EVENT_DETAILS ed on ed.TRIP_ID=td.TRIP_ID"+ 
	" left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID"+
	" inner join AMS.dbo.Vehicle_User vu on vu.Registration_no=td.ASSET_NUMBER and vu.User_id=?"+
	" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? #"+ 
	" group by td.TRIP_ID,td.SHIPMENT_ID,td.ASSET_NUMBER,td.ROUTE_NAME,td.TRIP_START_TIME,td.ACTUAL_TRIP_START_TIME,td.ACTUAL_DISTANCE," +
	" gps.LOCATION,td.START_LOCATION,td.STATUS,td.TRIP_STATUS,td.ACTUAL_TRIP_END_TIME,NEXT_LOCATION,td.DRIVER_NAME order by td.TRIP_ID desc";
	

	public static final String GET_LAT_LONG_DHL = "select * from Route_Detail where Route_id=? and TYPE in ('CHECK POINT','DESTINATION','SOURCE') order by Route_sequence,Route_Segment asc  ";

	public static final String GET_HISTORY_TRACK_INFO = " select r.GMT,r.LATITUDE,r.LONGITUDE,r.TYPE from " +
	 " (select GMT,LATITUDE,LONGITUDE,'' as TYPE from AMS.dbo.HISTORY_DATA where REGISTRATION_NO=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) " +
	 " union all " +
	 " select GMT,LATITUDE,LONGITUDE,'' as TYPE from AMS_Archieve.dbo.GE_DATA where REGISTRATION_NO=? and GMT between" +
	 " dateadd(mi,-?,?) and dateadd(mi,-?,?)" +
	 " union all  " +
	 " select GMT,LATITUDE,LONGITUDE,'2' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where ALERT_TYPE=2 and VEHICLE_NO=? " +
	 " and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?)) r " +
	 " order by r.GMT asc ";
	
	public static final String GET_TRIP_SUMMARY_DETAILS_DHL = " select isnull(CUSTOMER_REF_ID,'') as CUSTOMER_REF_ID,isnull (custd.CUSTOMER_REFERENCE_ID,'') as TRIP_CUSTOMER_REF_ID,isnull(NEXT_POINT_DISTANCE,0) as DISTANCE_TO_NEXTHUB," +
	" isnull(AVG_SPEED,0) as AVG_SPEED,isnull(STOPPAGE_DURATION,0) as STOPPAGE_TIME,isnull(td.ROUTE_ID,0) as ROUTE_ID,isnull(td.TRIP_ID,0) as TRIP_NO,isnull(td.SHIPMENT_ID,'') as TRIP_ID,isnull(PRODUCT_LINE,'') as PRODUCT_LINE,isnull(TRIP_CATEGORY,'') as TRIP_CATEGORY, " +
	" isnull(trd.ROUTE_KEY,'NA') as RouteKey," +
	" isnull(left(trd.ROUTE_KEY,case WHEN CHARINDEX('_', trd.ROUTE_KEY)>0 THEN CHARINDEX('_', trd.ROUTE_KEY)-1 ELSE 0 END),'NA') as OriginCity ,isnull(right(trd.ROUTE_KEY,(len(trd.ROUTE_KEY)-CHARINDEX('_', trd.ROUTE_KEY))),'NA') as DestinationCity,"+
	" isnull(td.ASSET_NUMBER,'') as VEHICLE_NO,isnull(td.CUSTOMER_NAME,'') as CUSTOMER_NAME,case when td.STATUS='OPEN' then isnull(gps.DRIVER_NAME,'') else '' end as DRIVER_NAME,"+
	" case when td.STATUS='OPEN' then isnull(gps.DRIVER_MOBILE,'') else '' end as DRIVER_NUMBER," +
	" case when td.STATUS='OPEN' THEN isnull(gps.LOCATION,'')  ELSE isnull(td.END_LOCATION,'')   END AS LOCATION , "+
	" isnull(NEXT_POINT,'') as NEAREST_HUB,isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as STD,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as ATD," +
	" isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,isnull(dateadd(mi,?,ds.PLANNED_ARR_DATETIME),'') as STA,isnull(dateadd(mi,?,isnull(td.DEST_ARR_TIME_ON_ATD,ds.PLANNED_ARR_DATETIME)),'') as STA_ON_ATD, " +
	" isnull(td.ACTUAL_DISTANCE,0) as actualDuration, isnull(ds1.NAME,'') as ORIGIN, isnull(ds.NAME,'') as DESTINATION,(isnull(td.STATUS,'')+'-'+isnull(td.TRIP_STATUS,'')) as STATUS," +
	" isnull(td.DELAY,'') as DELAY,isnull(td.TRIP_CUSTOMER_TYPE,'') as TRIP_CUSTOMER_TYPE, " +
	"(case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,330,'1900-01-01 00:00:00.000') else dateadd(mi,330,td.ACTUAL_TRIP_END_TIME) end) as endDate1, " +
	"(case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate())else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as endDate, " +
	" case when isnull((DATEDIFF(mi,ds.PLANNED_ARR_DATETIME,DESTINATION_ETA)),0) < isnull((DATEDIFF(mi,ACTUAL_TRIP_START_TIME,(dateadd(mi,?,ACT_SRC_ARR_DATETIME)))),0) then 'RED' else 'GREEN' end as FLAG, " +
	" (select count(*) from AMS.dbo.TRIP_EVENT_DETAILS where ALERT_TYPE=3 and TRIP_ID=td.TRIP_ID) as PANIC_COUNT,(select count(*) from AMS.dbo.TRIP_EVENT_DETAILS where ALERT_TYPE=38 and TRIP_ID=td.TRIP_ID ) as DOOR_COUNT, " +
	" (select count(*) from AMS.dbo.TRIP_EVENT_DETAILS where ALERT_TYPE=85 and TRIP_ID=td.TRIP_ID ) as NON_REPORTING_COUNT, " +
	//" (DATEDIFF(mi,ACT_SRC_ARR_DATETIME,ACTUAL_TRIP_START_TIME)-ds1.DETENTION_TIME) as LOADING_DETENTION, " +
	" (CASE WHEN ACT_SRC_ARR_DATETIME > ds1.PLANNED_ARR_DATETIME THEN convert(varchar,(DATEDIFF(mi,ACT_SRC_ARR_DATETIME,isnull(ACTUAL_TRIP_START_TIME,getutcdate()))-ds1.DETENTION_TIME) )    ELSE convert(varchar,(DATEDIFF(mi,ds1.PLANNED_ARR_DATETIME, isnull(ACTUAL_TRIP_START_TIME,getutcdate()))-ds1.DETENTION_TIME) ) END) AS LOADING_DETENTION , "+
	" isnull(ACT_SRC_ARR_DATETIME,'') as ACT_SRC_ARR_DATETIME,isnull(ORDER_ID,'') as LR_NO,isnull(vm.ModelName,'') as MAKE," +
	" isnull(td.ROUTE_NAME,0) as ROUTE_NAME,isnull(dateadd(mi,?,ds1.PLANNED_ARR_DATETIME),'') as STP,isnull(dateadd(mi,?,ds1.ACT_ARR_DATETIME),'') as ATP, " +
	" isnull(dateadd(mi,?,ds.ACT_ARR_DATETIME),'') as ATA,isnull(td.ACTUAL_DISTANCE,0) as TOTAL_DISTANCE,isnull(datediff(mi,ds1.PLANNED_ARR_DATETIME,ds1.ACT_ARR_DATETIME),0) as PLACEMENT_DELAY," +
	" case when  ISDATE(ds.ACT_ARR_DATETIME)=1 then datediff(mi,isnull(ds.ACT_ARR_DATETIME,0),isnull(ds.PLANNED_ARR_DATETIME,0)) else 0 end as beforeTime ," +
	//" (DATEDIFF(mi,ds.ACT_ARR_DATETIME,ds.ACT_DEP_DATETIME)-ds.DETENTION_TIME) as UNLOADING_DETENTION," +
	" (CASE when ds.ACT_ARR_DATETIME is null then 0 else(CASE WHEN ds.ACT_ARR_DATETIME > ds.PLANNED_ARR_DATETIME THEN  convert(varchar,(DATEDIFF(mi,ds.ACT_ARR_DATETIME,isnull(ACTUAL_TRIP_END_TIME,getutcdate()))-ds.DETENTION_TIME) )  ELSE convert(varchar,(DATEDIFF(mi,ds.PLANNED_ARR_DATETIME,isnull(ACTUAL_TRIP_END_TIME,getutcdate()))-ds.DETENTION_TIME) ) END)END) as UNLOADING_DETENTION, "+
	" isnull(case when td.FUEL_CONSUMED > 0 then td.FUEL_CONSUMED else 0 end,0) as fuelConsumed, "+
	" DATEDIFF(mi,ISNULL(td.TRIP_START_TIME,0),isnull(td.ACTUAL_TRIP_START_TIME,0)) as DELAYED_DEPARTURE_ATD_STD, DATEDIFF(mi,ISNULL(td.ACTUAL_TRIP_START_TIME,0)," +
	" isnull(ds.ACT_ARR_DATETIME,getutcdate())) as TOTAL_TRIP_TIME_ATA_ATD , isnull(case when (td.MILEAGE > 0 and td.MILEAGE < 10) then td.MILEAGE else 0 end,0) as MILEAGE ," +
	" isnull(case when (td.OBD_MILEAGE > 0 and td.OBD_MILEAGE < 10) then td.OBD_MILEAGE else 0 end,0) as OBD_MILEAGE ,isnull(td.NEXT_LEG,'') as NEXT_LEG,isnull(dateadd(mi,?,td.NEXT_LEG_ETA),'') as NEXT_LEG_ETA ," +
	" isnull(sum(GREEN_BAND_SPEED_DUR),0) as SUM_GBSD ,isnull(sum(GREEN_BAND_RPM_DUR),0) as SUM_GBRD,isnull(sum(FREE_WHEEL_DUR),0) as SUM_FWD,isnull(sum(TOTAL_DURATION),0) as TOTAL_DURATION," +
	" isnull(sum(TOTAL_STOP_DURATION),0)as TOTAL_STOP_DURATION,isnull(sum(tdd.LOW_RPM_DUR),0) as LOW_RPM_DUR,isnull(sum(tdd.HIGH_RPM_DUR),0) as HIGH_RPM_DUR,avg(tdd.GREEN_BAND_SPEED_PERC) as greenBandSpeedPerc," +
	" avg(tdd.GREEN_RPM_PERC) as greenRPMPerc,avg(tdd.GREEN_BAND_SPEED_PERC) as greenBandSpeedPerc,avg(tdd.GREEN_RPM_PERC) as greenRPMPerc,isnull(ll0.HUB_CITY,'') as ORG_City," +
	" isnull(ll0.HUB_STATE,'') as ORG_STATE,isnull(ll1.HUB_CITY,'') as DEST_CITY, isnull(ll1.HUB_STATE,'') as DEST_STATE,isnull(u.Firstname,'')+' '+isnull(u.Lastname,'') as INSERTED_BY," +
	" isnull((select dhl.ISSUETYPE+'-'+dhl.SUBISSUE_TYPE+'-'+dhl.REMARKS from AMS.dbo.TRIP_REMARKS_DETAILS dhl where dhl.TRIP_ID=td.TRIP_ID and INSERTED_DATETIME=(select max(INSERTED_DATETIME) from TRIP_REMARKS_DETAILS where TRIP_ID=td.TRIP_ID) ),'')as REMARKS," +
	" isnull((select 'Location Of Delay: '+dhl.LOCATION_OF_DELAY+', Delay Startime: '+convert(varchar,dhl.STARTDATE,120)+',Delay Endtime: '+convert(varchar,dhl.ENDDATE,120)+',Delay Duration: '+dhl.DELAYTIME+', Issue Type: '+dhl.ISSUETYPE+', Sub Issue Type: '+dhl.SUBISSUE_TYPE+', Remarks: '+dhl.REMARKS from AMS.dbo.TRIP_REMARKS_DETAILS dhl where dhl.TRIP_ID=td.TRIP_ID and INSERTED_DATETIME=(select max(INSERTED_DATETIME) from TRIP_REMARKS_DETAILS where TRIP_ID=td.TRIP_ID) ),'') as REASON, "+
	" isnull((select top 1 'Location Of Delay: '+dhl.LOCATION_OF_DELAY+', Delay Startime: '+convert(varchar,dhl.STARTDATE,120)+',Delay Endtime: '+convert(varchar,dhl.ENDDATE,120)+',Delay Duration: '+dhl.DELAYTIME+', Issue Type: '+dhl.ISSUETYPE+', Sub Issue Type: '+dhl.SUBISSUE_TYPE+', Remarks: '+dhl.REMARKS from AMS.dbo.TRIP_REMARKS_DETAILS dhl where dhl.TRIP_ID=td.TRIP_ID and dhl.CUSTOMER_TYPE='Yes' order by INSERTED_DATETIME desc),'') as CUSTOMER_REASON, "+
	" isnull(sum(GREEN_BAND_SPEED_DUR * TOTAL_DURATION) / sum(TOTAL_DURATION),0)  as WEIGHTED_GREEN_BAND_SPEED_DURATION, "+
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (GREEN_BAND_RPM_DUR * TOTAL_DURATION) ELSE NULL END) / "+ 
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (TOTAL_DURATION) ELSE NULL END) as numeric(18,2)) as varchar(10)),'0.0') as WEIGHTED_GREEN_BAND_RPM_DURATION,  "+
	" isnull(cast(cast(AVG(CASE WHEN (tdd.MILEAGE>0 and tdd.MILEAGE < 10) THEN tdd.MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),'0.0') as LLS_MILEAGE, "+
	" isnull(cast(cast(AVG(CASE WHEN (tdd.OBD_MILEAGE>0 and tdd.OBD_MILEAGE < 10) THEN tdd.OBD_MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),'0.0') as OBD_MILEAGE_FOR_SLA_LEG_REPORT,isnull(vm.VehType,'') as VEHICLE_LENGTH,isnull(td.REMARKS,'') as CANCELLED_REMARKS, "+
	" DATEDIFF(mi,td.TRIP_START_TIME,td.ACTUAL_TRIP_START_TIME)  as delayedDepartureATD_STD, "+
	" (DATEDIFF(mi,ACTUAL_TRIP_START_TIME,ds.ACT_ARR_DATETIME) - STOPPAGE_DURATION)  AS totalTruckRunningTime, "+
	" isnull(PLANNED_DURATION,0) as PLANNED_DURATION , isnull(ds1.DISTANCE_FLAG,'') as DISTANCE_FLAG, " +
	" cast((RED_DUR_T1 * 100) /cast (case when rd.TRAVEL_TIME=0 then null else rd.TRAVEL_TIME end as float) as decimal(18,2)) AS TEMP_REEFER_PERCENT," +
	" cast((RED_DUR_T2 * 100) /cast (case when rd.TRAVEL_TIME=0 then null else rd.TRAVEL_TIME end as float) as decimal(18,2)) AS TEMP_MIDDLE_PERCENT, "+
	" cast((RED_DUR_T3 * 100) /cast (case when rd.TRAVEL_TIME=0 then null else rd.TRAVEL_TIME end as float) as decimal(18,2)) AS TEMP_DOOR_PERCENT, "+
	" isnull(dateadd(mi,?,td.INSERTED_TIME),'') as INSERTED_TIME, isnull(c.VehicleType,'') as VehicleType ,"+
	" (STOPPAGE_DURATION - (select sum(DATEDIFF(mi,ACT_ARR_DATETIME,ACT_DEP_DATETIME))from DES_TRIP_DETAILS des "+
	" WHERE des.TRIP_ID=td.TRIP_ID AND des.SEQUENCE >0 AND des.SEQUENCE<100)) as UNSCHEDULED_STOP_DUR, "+
	" (DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,ds.ACT_ARR_DATETIME) - td.PLANNED_DURATION) AS transitDelay , "+
	" DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,ds.ACT_ARR_DATETIME) as ACTUAL_TRANSIT_TIME , "+
	" td.PLANNED_DURATION  as PLANNED_TRANSIT_TIME, "+
	" isnull(dateadd(mi,?,gps.GMT),'') as LAST_COMMUNICATION_STAMP"+
	" from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	" left outer join Users u on td.INSERTED_BY=u.User_id and td.SYSTEM_ID=u.System_id"+
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100"+
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0"+
	" left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID " +
	" left outer join tblVehicleMaster c on td.ASSET_NUMBER=c.VehicleNo "+
	" left outer join AMS.dbo.LOCATION ll0 on ll0.HUBID=ds1.HUB_ID "+
	" left outer join AMS.dbo.LOCATION ll1 on ll1.HUBID=ds.HUB_ID "+
	" left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model" +
	" left outer join TRIP_DRIVER_DETAILS tdd on td.TRIP_ID=tdd.TRIP_ID"+ 
	" left outer join AMS.dbo.TRIP_ROUTE_MASTER trd on trd.ID=td.ROUTE_ID  "+ 
	" left outer join REPORT_BUILDER_DETAILS rd on rd.TRIP_ID=td.TRIP_ID "+
	" inner join AMS.dbo.TRIP_CUSTOMER_DETAILS custd on custd.ID=td.TRIP_CUSTOMER_ID"+
	" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? & # $ custTypeCondition tripTypeCondition" ;

	public static final String GET_TRIP_SUMMARY_DETAILS_DHL_DELAY = " select isnull(CUSTOMER_REF_ID,'') as CUSTOMER_REF_ID,isnull (custd.CUSTOMER_REFERENCE_ID,'') as TRIP_CUSTOMER_REF_ID,isnull(NEXT_POINT_DISTANCE,0) as DISTANCE_TO_NEXTHUB,isnull(AVG_SPEED,0) as AVG_SPEED,isnull(STOPPAGE_DURATION,0) as STOPPAGE_TIME,isnull(td.ROUTE_ID,0) as ROUTE_ID," +
	"isnull(td.TRIP_ID,0) as TRIP_NO,isnull(td.SHIPMENT_ID,'') as TRIP_ID, isnull(PRODUCT_LINE,'') as PRODUCT_LINE,isnull(TRIP_CATEGORY,'') as TRIP_CATEGORY,isnull(trd.ROUTE_KEY,'NA') as RouteKey, " +
	" isnull(td.ASSET_NUMBER,'') as VEHICLE_NO,isnull(td.CUSTOMER_NAME,'') as CUSTOMER_NAME,case when td.STATUS='OPEN' then isnull(gps.DRIVER_NAME,'') else '' end as DRIVER_NAME,"+
	" case when td.STATUS='OPEN' then isnull(gps.DRIVER_MOBILE,'') else '' end as DRIVER_NUMBER, " +
	" isnull(left(trd.ROUTE_KEY,case WHEN CHARINDEX('_', trd.ROUTE_KEY)>0 THEN CHARINDEX('_', trd.ROUTE_KEY)-1 ELSE 0 END),'NA') as OriginCity ,isnull(right(trd.ROUTE_KEY,(len(trd.ROUTE_KEY)-CHARINDEX('_', trd.ROUTE_KEY))),'NA') as DestinationCity,"+ 
	" case when td.STATUS='OPEN' THEN isnull(gps.LOCATION,'')  ELSE isnull(td.END_LOCATION,'')   END AS LOCATION,isnull(NEXT_POINT,'') as NEAREST_HUB, " +
	" isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as STD,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as ATD, isnull(td.TRIP_CUSTOMER_TYPE,'') as TRIP_CUSTOMER_TYPE," +
	" isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,isnull(dateadd(mi,?,ds.PLANNED_ARR_DATETIME),'') as STA,isnull(dateadd(mi,?,isnull(td.DEST_ARR_TIME_ON_ATD,ds.PLANNED_ARR_DATETIME)),'') as STA_ON_ATD, " +
	" isnull(td.ACTUAL_DISTANCE,0) as actualDuration, isnull(ds1.NAME,'') as ORIGIN, isnull(ds.NAME,'') as DESTINATION, " +
	" (isnull(td.STATUS,'')+'-'+isnull(td.TRIP_STATUS,'')) as STATUS,isnull(td.DELAY,'') as DELAY,isnull(u.Firstname+' '+u.Lastname,'')as INSERTED_BY, " +
	" (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as endDate, " +
	" (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,330,'1900-01-01 00:00:00.000') else dateadd(mi,330,td.ACTUAL_TRIP_END_TIME) end) as endDate1, " +
	" case when isnull((DATEDIFF(mi,ds.PLANNED_ARR_DATETIME,DESTINATION_ETA)),0) < isnull((DATEDIFF(mi,ACTUAL_TRIP_START_TIME,(dateadd(mi,?,ACT_SRC_ARR_DATETIME)))),0) then 'RED' else 'GREEN' end as FLAG, " +
	" (select count(*) from AMS.dbo.TRIP_EVENT_DETAILS where ALERT_TYPE=3 and TRIP_ID=td.TRIP_ID) as PANIC_COUNT, " +
	" (select count(*) from AMS.dbo.TRIP_EVENT_DETAILS where ALERT_TYPE=38 and TRIP_ID=td.TRIP_ID ) as DOOR_COUNT, " +
	" (select count(*) from AMS.dbo.TRIP_EVENT_DETAILS where ALERT_TYPE=85 and TRIP_ID=td.TRIP_ID ) as NON_REPORTING_COUNT, " +
	//" (DATEDIFF(mi,ACT_SRC_ARR_DATETIME,ACTUAL_TRIP_START_TIME)-ds1.DETENTION_TIME) as LOADING_DETENTION, " +
	" (CASE WHEN ACT_SRC_ARR_DATETIME > ds1.PLANNED_ARR_DATETIME THEN convert(varchar,(DATEDIFF(mi,ACT_SRC_ARR_DATETIME,isnull(ACTUAL_TRIP_START_TIME,getutcdate()))-ds1.DETENTION_TIME) )    ELSE convert(varchar,(DATEDIFF(mi,ds1.PLANNED_ARR_DATETIME, isnull(ACTUAL_TRIP_START_TIME,getutcdate()))-ds1.DETENTION_TIME) ) END) AS LOADING_DETENTION , "+
	" isnull(ACT_SRC_ARR_DATETIME,'') as ACT_SRC_ARR_DATETIME, " +
	" isnull(ORDER_ID,'') as LR_NO,isnull(vm.ModelName,'') as MAKE,isnull(td.ROUTE_NAME,0) as ROUTE_NAME, "+
	" isnull(dateadd(mi,?,ds1.PLANNED_ARR_DATETIME),'') as STP,isnull(dateadd(mi,?,ds1.ACT_ARR_DATETIME),'') as ATP, " +
	" isnull(dateadd(mi,?,ds.ACT_ARR_DATETIME),'') as ATA,isnull(td.ACTUAL_DISTANCE,0) as TOTAL_DISTANCE,isnull(datediff(mi,ds1.PLANNED_ARR_DATETIME,ds1.ACT_ARR_DATETIME),0) as PLACEMENT_DELAY," +
	//" (DATEDIFF(mi,ds.ACT_ARR_DATETIME,ds.ACT_DEP_DATETIME)-ds.DETENTION_TIME) as UNLOADING_DETENTION, " +
	//" (CASE when ds.ACT_ARR_DATETIME is null then 0 else (CASE WHEN ACT_SRC_ARR_DATETIME > ds.PLANNED_ARR_DATETIME THEN  convert(varchar,(DATEDIFF(mi,ACT_SRC_ARR_DATETIME,isnull(ACTUAL_TRIP_END_TIME,getutcdate()))-ds.DETENTION_TIME) )  ELSE convert(varchar,(DATEDIFF(mi,DEST_ARR_TIME_ON_ATD,isnull(ACTUAL_TRIP_END_TIME,getutcdate()))-ds.DETENTION_TIME) ) END)END) as UNLOADING_DETENTION, "+
	" (CASE when ds.ACT_ARR_DATETIME is null then 0 else(CASE WHEN ds.ACT_ARR_DATETIME > ds.PLANNED_ARR_DATETIME THEN  convert(varchar,(DATEDIFF(mi,ds.ACT_ARR_DATETIME,isnull(ACTUAL_TRIP_END_TIME,getutcdate()))-ds.DETENTION_TIME) )  ELSE convert(varchar,(DATEDIFF(mi,ds.PLANNED_ARR_DATETIME,isnull(ACTUAL_TRIP_END_TIME,getutcdate()))-ds.DETENTION_TIME) ) END)END) as UNLOADING_DETENTION, "+
	" isnull(case when td.FUEL_CONSUMED > 0 then td.FUEL_CONSUMED else 0 end,0) as fuelConsumed, "+
	" DATEDIFF(mi,ISNULL(td.TRIP_START_TIME,0),isnull(td.ACTUAL_TRIP_START_TIME,0)) as DELAYED_DEPARTURE_ATD_STD, DATEDIFF(mi,ISNULL(td.ACTUAL_TRIP_START_TIME,0)," +
	" isnull(ds.ACT_ARR_DATETIME,0)) as TOTAL_TRIP_TIME_ATA_ATD , isnull(case when (td.MILEAGE > 0 and td.MILEAGE < 10) then td.MILEAGE else 0 end,0) as MILEAGE ," +
	" isnull(case when (td.OBD_MILEAGE > 0 and td.OBD_MILEAGE < 10) then td.OBD_MILEAGE else 0 end,0) as OBD_MILEAGE ,isnull(td.NEXT_LEG,'') as NEXT_LEG," +
	" isnull(dateadd(mi,?,td.NEXT_LEG_ETA),'') as NEXT_LEG_ETA ,isnull(sum(GREEN_BAND_SPEED_DUR),0) as SUM_GBSD ,isnull(sum(GREEN_BAND_RPM_DUR),0) as SUM_GBRD," +
	" isnull(sum(TOTAL_DURATION),0) as TOTAL_DURATION,isnull(sum(TOTAL_STOP_DURATION),0)as TOTAL_STOP_DURATION,isnull(sum(tdd.LOW_RPM_DUR),0) as LOW_RPM_DUR,isnull(sum(tdd.HIGH_RPM_DUR),0) as HIGH_RPM_DUR,  " +
	" isnull(ll0.HUB_CITY,'') as ORG_City,isnull(ll0.HUB_STATE,'') as ORG_STATE, "+
    " isnull(ll1.HUB_CITY,'') as DEST_CITY,isnull(ll1.HUB_STATE,'') as DEST_STATE,isnull(u.Firstname,'')+' '+isnull(u.Lastname,'') as INSERTED_BY , isnull(vm.VehType,'') as VEHICLE_LENGTH, isnull(td.REMARKS,'') as CANCELLED_REMARKS, "+
    " DATEDIFF(mi,td.TRIP_START_TIME,td.ACTUAL_TRIP_START_TIME)  as delayedDepartureATD_STD, "+
	" (DATEDIFF(mi,ACTUAL_TRIP_START_TIME,ds.ACT_ARR_DATETIME) - STOPPAGE_DURATION)  AS totalTruckRunningTime, "+
	" DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,ds.ACT_ARR_DATETIME) as ACTUAL_TRANSIT_TIME ,"+
	" isnull(PLANNED_DURATION,0) as PLANNED_DURATION , isnull(ds1.DISTANCE_FLAG,'') as DISTANCE_FLAG, " +
	" isnull((select dhl.ISSUETYPE+'-'+dhl.SUBISSUE_TYPE+'-'+dhl.REMARKS from AMS.dbo.TRIP_REMARKS_DETAILS dhl where dhl.TRIP_ID=td.TRIP_ID and INSERTED_DATETIME=(select max(INSERTED_DATETIME) from TRIP_REMARKS_DETAILS where TRIP_ID=td.TRIP_ID) ),'')as REMARKS," +
	" isnull((select 'Location Of Delay: '+dhl.LOCATION_OF_DELAY+', Delay Startime: '+convert(varchar,dhl.STARTDATE,120)+',Delay Endtime: '+convert(varchar,dhl.ENDDATE,120)+',Delay Duration: '+dhl.DELAYTIME+', Issue Type'+dhl.ISSUETYPE+', Sub Issue Type: '+dhl.SUBISSUE_TYPE+', Remarks: '+dhl.REMARKS from AMS.dbo.TRIP_REMARKS_DETAILS dhl where dhl.TRIP_ID=td.TRIP_ID and INSERTED_DATETIME=(select max(INSERTED_DATETIME) from TRIP_REMARKS_DETAILS where TRIP_ID=td.TRIP_ID) ),'') as REASON, "+
	" isnull((select top 1 'Location Of Delay: '+dhl.LOCATION_OF_DELAY+', Delay Startime: '+convert(varchar,dhl.STARTDATE,120)+',Delay Endtime: '+convert(varchar,dhl.ENDDATE,120)+',Delay Duration: '+dhl.DELAYTIME+', Issue Type: '+dhl.ISSUETYPE+', Sub Issue Type: '+dhl.SUBISSUE_TYPE+', Remarks: '+dhl.REMARKS from AMS.dbo.TRIP_REMARKS_DETAILS dhl where dhl.TRIP_ID=td.TRIP_ID and CUSTOMER_TYPE='Yes' order by INSERTED_DATETIME desc),'') as CUSTOMER_REASON, "+
	" cast((RED_DUR_T1 * 100) /cast (case when rd.TRAVEL_TIME=0 then null else rd.TRAVEL_TIME end as float) as decimal(18,2)) AS TEMP_REEFER_PERCENT," +
	" cast((RED_DUR_T2 * 100) /cast (case when rd.TRAVEL_TIME=0 then null else rd.TRAVEL_TIME end as float) as decimal(18,2)) AS TEMP_MIDDLE_PERCENT, "+
	" cast((RED_DUR_T3 * 100) /cast (case when rd.TRAVEL_TIME=0 then null else rd.TRAVEL_TIME end as float) as decimal(18,2)) AS TEMP_DOOR_PERCENT, "+
	" isnull(dateadd(mi,?,td.INSERTED_TIME),'') as INSERTED_TIME,isnull(c.VehicleType,'') as VehicleType, "+
	" (STOPPAGE_DURATION - (select sum(DATEDIFF(mi,ACT_ARR_DATETIME,ACT_DEP_DATETIME))from DES_TRIP_DETAILS des "+
	" WHERE des.TRIP_ID=td.TRIP_ID AND des.SEQUENCE >0 AND des.SEQUENCE<100)) as UNSCHEDULED_STOP_DUR, "+
	" (DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,ds.ACT_ARR_DATETIME) - td.PLANNED_DURATION) AS transitDelay , " +
	" td.PLANNED_DURATION  as PLANNED_TRANSIT_TIME, " +
	" isnull(dateadd(mi,?,gps.GMT),'') as LAST_COMMUNICATION_STAMP"+
	" from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	" left outer join Users u on td.INSERTED_BY=u.User_id and td.SYSTEM_ID=u.System_id"+
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100"+
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0"+
	" left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID " +
	" left join tblVehicleMaster c on td.ASSET_NUMBER=c.VehicleNo "+
	" left outer join AMS.dbo.LOCATION ll0 on ll0.HUBID=ds1.HUB_ID "+
    " left outer join AMS.dbo.LOCATION ll1 on ll1.HUBID=ds.HUB_ID "+
	" left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model" +
	" left outer join TRIP_DRIVER_DETAILS tdd on td.TRIP_ID=tdd.TRIP_ID"+
	" left outer join AMS.dbo.TRIP_ROUTE_MASTER trd on trd.ID=td.ROUTE_ID "+
	" left outer join REPORT_BUILDER_DETAILS rd on rd.TRIP_ID=td.TRIP_ID "+
	" inner join AMS.dbo.TRIP_CUSTOMER_DETAILS custd on custd.ID=td.TRIP_CUSTOMER_ID"+
	//" left outer join TRIP_CUSTOMER_DETAILS tc on tc.ID=td.TRIP_CUSTOMER_ID " +
	" where td.TRIP_ID not in(select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " + 
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and td.TRIP_STATUS='DELAYED' and SEQUENCE=100 " +
	" and (ACTUAL_TRIP_START_TIME>td.TRIP_START_TIME " +
	" and DATEDIFF(mi,PLANNED_ARR_DATETIME,DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) and " +
	" td.SYSTEM_ID=? and td.CUSTOMER_ID=? & # $ custTypeCondition tripTypeCondition " ;
	
	public static final String GET_VEHICLES_FOR_MAP = "select isnull(ORDER_ID,'') as LR_NO,isnull(td.SHIPMENT_ID,'') as TRIP_NO,isnull(td.ROUTE_NAME,0) as ROUTE_NAME,isnull(ANALOG_INPUT_1,'99999') as Humidity ,isnull(td.PRODUCT_LINE,0) as PRODUCT_LINE,isnull(td.ROUTE_ID,0) as ROUTE_ID,isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as STD,isnull(td.TRIP_ID,0) as TRIP_ID,isnull(td.STATUS,'') as STATUS," +
	" isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,isnull(gps.DRIVER_NAME,'') as DRIVER_NAME,isnull(gps.DRIVER_MOBILE,'') as DRIVER_MOBILE,isnull(DELAY,0) as DELAY," +
	" ISNULL(td.CUSTOMER_NAME,'') as CUSTOMER_NAME,td.SHIPMENT_ID,td.TRIP_STATUS,ASSET_NUMBER,isnull(gps.LATITUDE,0) as LATITUDE,isnull(gps.LONGITUDE,0) as LONGITUDE," +
	" isnull(gps.LOCATION,'') as LOCATION,isnull(dateadd(mi,?,gps.GMT),'') as GMT,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as ATD, " +
	" (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as endDate, " +
	" case when gps.CATEGORY='stoppage' then DURATION else 0 end as STOPPAGE_TIME,case when gps.CATEGORY='idle' then DURATION else 0 end as IDLE_TIME, " +
	" isnull(gps.SPEED,0) as SPEED,isnull(trm.ROUTE_KEY,0) as ROUTE_KEY, " +
	" TEMPERATURE_DATA=STUFF((SELECT ',' + CAST(tvt.DISPLAY_NAME as varchar)+CAST('=' AS VARCHAR)+CAST((SELECT IO_VALUE FROM AMS.dbo.RS232_LIVE WHERE "+
	" REGISTRATION_NO=td.ASSET_NUMBER AND IO_ID=tvt.SENSOR_NAME) AS VARCHAR)"+
	" FROM AMS.dbo.TRIP_VEHICLE_TEMPERATURE_DETAILS  tvt WHERE "+
	" TRIP_ID=td.TRIP_ID FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') "+
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS dt on td.TRIP_ID=dt.TRIP_ID and dt.SEQUENCE=100"+
	" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID " +
	" inner join AMS.dbo.TRIP_ROUTE_MASTER trm on trm.ID = td.ROUTE_ID " +
	" where td.STATUS=? and td.SYSTEM_ID=? and td.CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ";
	
	public static final String GET_VEHICLES_FOR_MAP_DELAY = "select isnull(ORDER_ID,'') as LR_NO,isnull(td.SHIPMENT_ID,'') as TRIP_NO,isnull(td.ROUTE_NAME,0) as ROUTE_NAME,isnull(ANALOG_INPUT_1,'99999') as Humidity ,isnull(td.PRODUCT_LINE,0) as PRODUCT_LINE,isnull(td.ROUTE_ID,0) as ROUTE_ID,isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as STD,isnull(td.TRIP_ID,0) as TRIP_ID,isnull(td.STATUS,'') as STATUS," +
	" isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,isnull(gps.DRIVER_NAME,'') as DRIVER_NAME,isnull(DELAY,0) as DELAY," +
	" ISNULL(td.CUSTOMER_NAME,'') as CUSTOMER_NAME,td.SHIPMENT_ID,td.TRIP_STATUS,ASSET_NUMBER,isnull(gps.LATITUDE,0) as LATITUDE,isnull(gps.LONGITUDE,0) as LONGITUDE," +
	" isnull(gps.LOCATION,'') as LOCATION,isnull(dateadd(mi,?,gps.GMT),'') as GMT,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as ATD, " +
	" (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as endDate, " +
	" case when gps.CATEGORY='stoppage' then DURATION else 0 end as STOPPAGE_TIME,case when gps.CATEGORY='idle' then DURATION else 0 end as IDLE_TIME, " +
	" isnull(gps.SPEED,0) as SPEED, isnull(gps.DRIVER_MOBILE,'') as DRIVER_MOBILE,isnull(trm.ROUTE_KEY,0) as ROUTE_KEY," +
	" TEMPERATURE_DATA=STUFF((SELECT ',' + (tvt.DISPLAY_NAME + '=' +(SELECT IO_VALUE FROM AMS.dbo.RS232_LIVE WHERE "+
	" REGISTRATION_NO=td.ASSET_NUMBER AND IO_ID=tvt.SENSOR_NAME))"+
	" FROM AMS.dbo.TRIP_VEHICLE_TEMPERATURE_DETAILS  tvt WHERE "+
	" TRIP_ID=td.TRIP_ID FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') "+
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID " +
	" inner join AMS.dbo.TRIP_ROUTE_MASTER trm on trm.ID = td.ROUTE_ID " +
	" where td.TRIP_ID not in(select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " + 
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 " +
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and DATEDIFF(mi,isnull(td.DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and td.STATUS=? and td.SYSTEM_ID=? and td.CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ";

	public static final String GET_ONTIME_COUNT = "select count(*) as COUNT,'ENROUTE' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS like 'ENROUTE PLACEMENT%'  " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,  'ENROUTE_ONTIME'  as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='ENROUTE PLACEMENT ON TIME' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT, 'ENROUTE_DELAYED'  as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='ENROUTE PLACEMENT DELAYED' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'ONTIME'  as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='ON TIME' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'DELAY_LESS' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where  TRIP_ID not in( " +
	" select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " +
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 " +
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and isnull(DELAY,0)<60 and STATUS='OPEN' and TRIP_STATUS='DELAYED' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'DELAY_GREATER' as STATUS  from AMS.dbo.TRACK_TRIP_DETAILS where  TRIP_ID not in( " +
	" select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " + 
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100  " +
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and isnull(DELAY,0)>60 and STATUS='OPEN' and TRIP_STATUS='DELAYED'" +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'LOADING_DETENTION' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='LOADING DETENTION' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " + 
	" union all " +
	" select count(*) as COUNT,'UNLOADING_DETENTION' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='UNLOADING DETENTION' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'DELYED_LATE_DEPARTURE' as STATUS  from AMS.dbo.TRACK_TRIP_DETAILS where TRIP_ID in (select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " + 
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and (DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?)  # $ custTypeCondition tripTypeCondition ";
	
	/*
	 * Delay Slab required for the on trip vehicles stopped at any unplanned location. Slab: 1-2 hrs, 2-3 hrs, 3-5 hrs, 5 hrs & above
	 * */
	public static final String GET_ONTIME_COUNT_BLUEDART = "select count(*) as COUNT,'ENROUTE' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS like 'ENROUTE PLACEMENT%'  " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,  'ENROUTE_ONTIME'  as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='ENROUTE PLACEMENT ON TIME' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT, 'ENROUTE_DELAYED'  as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='ENROUTE PLACEMENT DELAYED' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'ONTIME'  as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='ON TIME' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'DELAY_LESS' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where  TRIP_ID not in( " +
	" select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " +
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 " +
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and isnull(DELAY,0)<60 and STATUS='OPEN' and TRIP_STATUS='DELAYED' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'DELAY_GREATER' as STATUS  from AMS.dbo.TRACK_TRIP_DETAILS where  TRIP_ID not in( " +
	" select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " + 
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100  " +
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and isnull(DELAY,0)>60 and STATUS='OPEN' and TRIP_STATUS='DELAYED'" +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'DELAY_ONE_TO_TWO_HOUR' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where  TRIP_ID not in( " +
	" select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " +
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 " +
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and isnull(DELAY,0)>60 and isnull(DELAY,0)<120 and STATUS='OPEN' and TRIP_STATUS='DELAYED' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'DELAY_TWO_TO_THREE_HOUR' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where  TRIP_ID not in( " +
	" select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " +
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 " +
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and isnull(DELAY,0)>120 and isnull(DELAY,0)<180 and STATUS='OPEN' and TRIP_STATUS='DELAYED' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'DELAY_THREE_TO_FIVE_HOUR' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where  TRIP_ID not in( " +
	" select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " +
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 " +
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and isnull(DELAY,0)>180 and isnull(DELAY,0)<300 and STATUS='OPEN' and TRIP_STATUS='DELAYED' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'DELAY_MORE_THAN_FIVE_HOUR' as STATUS  from AMS.dbo.TRACK_TRIP_DETAILS where  TRIP_ID not in( " +
	" select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " + 
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100  " +
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and isnull(DELAY,0)>300 and STATUS='OPEN' and TRIP_STATUS='DELAYED'" +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'LOADING_DETENTION' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='LOADING DETENTION' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " + 
	" union all " +
	" select count(*) as COUNT,'UNLOADING_DETENTION' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='UNLOADING DETENTION' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?  # $ custTypeCondition tripTypeCondition " +
	" union all " +
	" select count(*) as COUNT,'DELYED_LATE_DEPARTURE' as STATUS  from AMS.dbo.TRACK_TRIP_DETAILS where TRIP_ID in (select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td inner join AMS.dbo.DES_TRIP_DETAILS dt " + 
	" on td.TRIP_ID=dt.TRIP_ID  where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME " +
	" and (DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) " +
	" and SYSTEM_ID=? and CUSTOMER_ID=?)  # $ custTypeCondition tripTypeCondition ";


	public static final String GET_ALERT_COUNTS = "select count(*) as COUNT,'ACKNOWLEDGE_DOOR' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=38 and REMARKS is null " +
	" union all " +
	" select count(*) as COUNT ,'TOTAL_DOOR' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE=38 " +
	" union all " +
	" select count(*) as COUNT,'ACKNOWLEDGE_REPORTING' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE=85 and REMARKS is null " +
	" union all " +
	" select count(*) as COUNT ,'TOTAL_REPORTING' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE=85 "+
	" union all " +
	" select count(*) as COUNT,'ACKNOWLEDGE_PANIC' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE=3 and REMARKS is null " +
	" union all " +
	" select count(*) as COUNT ,'TOTAL_PANIC' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE=3 "+
	" union all " +
	" select count(*) as COUNT,'ACKNOWLEDGE_TEMP' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE in (187,188,189) and REMARKS is null " +
	" union all " +
	" select count(*) as COUNT ,'TOTAL_TEMP' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE in (187,188,189) "+
	" union all " +
	" select count(*) as COUNT,'ACKNOWLEDGE_HUMIDITY' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE in (186) and REMARKS is null " +
	" union all " +
	" select count(*) as COUNT ,'TOTAL_HUMIDITY' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE in (186) "+
	" union all " +
    " select count(*) as COUNT,'ACKNOWLEDGE_REEFER' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
    " and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE in (190) and REMARKS is null " +
    " union all " +
    " select count(*) as COUNT ,'TOTAL_REEFER' as TYPE from AMS.dbo.TRIP_EVENT_DETAILS where TRIP_ID in (select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' " +
    " and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition) and ALERT_TYPE in (190) ";

	public static final String GET_ALERT_DETAILS = " select isnull(STOP_HOURS,'') as TEMP_VALUES,ALERT_TYPE,ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,isnull(LOCATION,'') as LOCATION,isnull(dateadd(mi,?,GMT),'') as GMT,isnull(REMARKS,'') as REMARKS " +
	" from AMS.dbo.TRIP_EVENT_DETAILS where & and ALERT_TYPE in (^^^) order by GMT DESC ";

	public static final String GET_ROUTES = "select distinct a.ROUTE_ID,isnull(b.RouteName,isnull(c.ROUTE_NAME,'')) as ROUTE_NAME,a.STATUS as STATUS from AMS.dbo.TRACK_TRIP_DETAILS a"+  
	 										" left outer join AMS.dbo.Route_Master b on RouteID=ROUTE_ID"+  
	 										" left outer join AMS.dbo.TRIP_ROUTE_MASTER c on c.ID=ROUTE_ID"+
	 										" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and  a.STATUS='OPEN' and a.ROUTE_ID is not null and a.ROUTE_ID !=0 ";

	public static final String GET_CUSTOMERS = "select distinct isnull(CUSTOMER_NAME,'') as CUSTOMER_NAME from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and SYSTEM_ID=? and CUSTOMER_ID=? ";		

	public static final String GET_ALERT_EVENT_COUNT = 
	"select count(distinct TRIP_ID) as COUNT,'STOPPAGE_DELAYED_ONE_TO_TWO_HOUR' as STATUS from TRIP_EVENT_DETAILS where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS inner join AMS.dbo.gpsdata_history_latest on REGISTRATION_NO=ASSET_NUMBER where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>60 and DELAY<120 and CATEGORY='stoppage' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=1  " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	"select count(distinct TRIP_ID) as COUNT,'STOPPAGE_DELAYED_TWO_TO_THREE_HOUR' as STATUS from TRIP_EVENT_DETAILS where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS inner join AMS.dbo.gpsdata_history_latest on REGISTRATION_NO=ASSET_NUMBER where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>120 and DELAY<180 and CATEGORY='stoppage' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=1  " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	"select count(distinct TRIP_ID) as COUNT,'STOPPAGE_DELAYED_THREE_TO_FIVE_HOUR' as STATUS from TRIP_EVENT_DETAILS where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS inner join AMS.dbo.gpsdata_history_latest on REGISTRATION_NO=ASSET_NUMBER where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>180 and DELAY<300 and CATEGORY='stoppage' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=1  " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	"select count(distinct TRIP_ID) as COUNT,'STOPPAGE_DELAYED_MORE_THAN_FIVE_HOUR' as STATUS from TRIP_EVENT_DETAILS where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS inner join AMS.dbo.gpsdata_history_latest on REGISTRATION_NO=ASSET_NUMBER where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>300 and CATEGORY='stoppage' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=1  " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	" select count(distinct TRIP_ID) as COUNT,'DEVIATION_DELAYED_ONE_TO_TWO_HOUR' as STATUS from TRIP_EVENT_DETAILS a where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>60 and DELAY<120  " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=5 and TRIP_ID not in (select  TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=a.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT) " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	" select count(distinct TRIP_ID) as COUNT,'DEVIATION_DELAYED_TWO_TO_THREE_HOUR' as STATUS from TRIP_EVENT_DETAILS a where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>120 and DELAY<180  " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=5 and TRIP_ID not in (select  TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=a.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT) " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	" select count(distinct TRIP_ID) as COUNT,'DEVIATION_DELAYED_THREE_TO_FIVE_HOUR' as STATUS from TRIP_EVENT_DETAILS a where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>180 and DELAY<300  " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=5 and TRIP_ID not in (select  TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=a.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT) " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	" select count(distinct TRIP_ID) as COUNT,'DEVIATION_DELAYED_MORE_THAN_FIVE_HOUR' as STATUS from TRIP_EVENT_DETAILS a where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>300  " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=5 and TRIP_ID not in (select  TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=a.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT) " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	"select count(distinct TRIP_ID) as COUNT,'STOPPAGE_DELAYED_LESS' as STATUS from TRIP_EVENT_DETAILS where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS inner join AMS.dbo.gpsdata_history_latest on REGISTRATION_NO=ASSET_NUMBER where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY<60 and CATEGORY='stoppage' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=1  " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	" select count(distinct TRIP_ID) as COUNT ,'DETENTION_DELAYED_LESS' as STATUS from DES_TRIP_DETAILS where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY<60  " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ACT_ARR_DATETIME is not null and SEQUENCE not in (0,100) and ACT_DEP_DATETIME is null " +
	" and datediff(mi,ACT_ARR_DATETIME,isnull(ACT_DEP_DATETIME,getutcdate()))>isnull(DETENTION_TIME,0)  " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	" select count(distinct TRIP_ID) as COUNT,'DEVIATION_DELAYED_LESS' as STATUS from TRIP_EVENT_DETAILS a where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY<60  " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=5 and TRIP_ID not in (select  TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=a.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT) " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	" select count(distinct TRIP_ID) as COUNT,'STOPPAGE_DELAYED_GREATER' as STATUS from TRIP_EVENT_DETAILS where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS inner join AMS.dbo.gpsdata_history_latest on REGISTRATION_NO=ASSET_NUMBER where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>60 and CATEGORY='stoppage'" +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $  custTypeCondition tripTypeCondition ) and ALERT_TYPE=1  " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all  " +
	" select count(distinct TRIP_ID) as COUNT,'DETENTION_DELAYED_GREATER' as STATUS from DES_TRIP_DETAILS where TRIP_ID in (  " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>60  " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ACT_ARR_DATETIME is not null and SEQUENCE not in (0,100) and ACT_DEP_DATETIME is null " +
	" and datediff(mi,ACT_ARR_DATETIME,isnull(ACT_DEP_DATETIME,getutcdate()))>isnull(DETENTION_TIME,0)  " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" union all " +
	" select count(distinct TRIP_ID) as COUNT,'DEVIATION_DELAYED_GREATER' as STATUS from TRIP_EVENT_DETAILS a where TRIP_ID in ( " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='DELAYED' and DELAY>60 " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=5 and TRIP_ID not in (select  TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=a.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT) " +
	" and TRIP_ID not in(  select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td "+
	" inner join AMS.dbo.DES_TRIP_DETAILS dt  on td.TRIP_ID=dt.TRIP_ID where td.STATUS='OPEN' and TRIP_STATUS='DELAYED' and SEQUENCE=100 "+ 
	" and (ACTUAL_TRIP_START_TIME>TRIP_START_TIME and DATEDIFF(mi,isnull(DEST_ARR_TIME_ON_ATD,PLANNED_ARR_DATETIME),DESTINATION_ETA) < DATEDIFF(mi,TRIP_START_TIME,ACTUAL_TRIP_START_TIME))) "+ 
	" UNION ALL " +
	" select count(distinct TRIP_ID) as COUNT,'ONTIME_STOPPAGE' as STATUS from TRIP_EVENT_DETAILS where TRIP_ID in ( " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS inner join AMS.dbo.gpsdata_history_latest on REGISTRATION_NO=ASSET_NUMBER where STATUS='OPEN' and TRIP_STATUS='ON TIME' and CATEGORY='stoppage'" +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=1 " +
	" union all " +
	" select count(distinct TRIP_ID) as COUNT,'ONTIME_DETENTION' as STATUS from DES_TRIP_DETAILS where TRIP_ID in ( " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='ON TIME' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ACT_ARR_DATETIME is not null and SEQUENCE not in (0,100) and ACT_DEP_DATETIME is null " +
	" and datediff(mi,ACT_ARR_DATETIME,isnull(ACT_DEP_DATETIME,getutcdate()))>isnull(DETENTION_TIME,0) " +
	" union all " +
	" select count(distinct TRIP_ID) as COUNT,'ONTIME_DEVIATION' as STATUS from TRIP_EVENT_DETAILS a where TRIP_ID in ( " +
	" select TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS='ON TIME' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? # $ custTypeCondition tripTypeCondition ) and ALERT_TYPE=5 and TRIP_ID not in (select  TRIP_ID from TRIP_EVENT_DETAILS b where b.TRIP_ID=a.TRIP_ID and ALERT_TYPE=134 and b.GMT>a.GMT) ";

	public static final String UPDATE_EVENT = " update AMS.dbo.TRIP_EVENT_DETAILS set REMARKS=?,ACKNOWLEDGE_BY=?,ACKNOWLEDGE_DATETIME=getdate() where ID=? " ;

	public static final String GET_CUSTOMER_DETAILS="select distinct CUSTOMER_NAME ,TRIP_CUSTOMER_ID as CUSTOMER_ID   from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and SYSTEM_ID=? and CUSTOMER_ID=? AND CUSTOMER_NAME IS NOT NULL ";

	public static final String GET_CUSTOMER_DETAILS1="select distinct isnull(ID,'') as TRIP_CUSTOMER_ID,isnull(NAME,'') as NAME from TRIP_CUSTOMER_DETAILS tc inner join TRACK_TRIP_DETAILS td on td.TRIP_CUSTOMER_ID=tc.ID where tc.SYSTEM_ID=? and tc.CUSTOMER_ID=? and tc.STATUS='Active' order by NAME";
	
	
	public static final String GET_ROUTE_DETAILS=" select distinct a.ROUTE_ID,a.ROUTE_NAME as RouteName from AMS.dbo.TRACK_TRIP_DETAILS a "+
	" where a.SYSTEM_ID=? # and CUSTOMER_NAME is not null ";
	
	public static  String GET_TIME_PERFORMACE =  " select " +
	  " (select count(*) from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='CLOSED'  " +
	  " and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ )  " +
	  " as TIME_TOATL_TRIP ,  " +
	  " (select count(*) from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='CLOSED' and TRIP_STATUS='ON TIME'  " +
	  " and SYSTEM_ID=? and CUSTOMER_ID=? " +
	  " and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120))  # $)  " +
	  " as TIME_ON_TRIP , " +
	  " (select count(*) from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='CLOSED'  " +
	  " and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ )  " +
	  " as R_TIME_TOATL_TRIP , 	 " +
	  " (select count(*) from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='CLOSED' and TRIP_STATUS='ON TIME' " +
	  " and SYSTEM_ID=? and CUSTOMER_ID=? " +
	  " and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120))  # $)  " +
	  " as R_TIME_ON_TRIP " ;
	
	public static String GET_DELEYED_PERCENTAGE=" select " +
	  " (select count(*) from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='CLOSED' and AUTO_CLOSE is null " +
	  " and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ )  " +
	  " as TOTAL_DELIVERY ,  " +
	  " (select count(*) from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='CLOSED' and TRIP_STATUS='DELAYED' and AUTO_CLOSE is null " +
	  " and SYSTEM_ID=? and CUSTOMER_ID=? " +
	  " and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120))  # $)  " +
	  " as DELAYED_DELIVERY , " +
	  " (select count(*) from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='CLOSED' and AUTO_CLOSE is null " +
	  " and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120))  # $)  " +
	  " as R_TOTAL_DELIVERY , 	 " +
	  " (select count(*) from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='CLOSED' and TRIP_STATUS='DELAYED' and AUTO_CLOSE is null " +
	  " and SYSTEM_ID=? and CUSTOMER_ID=? " +
	  " and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ )  " +
	  " as R_DELAYED_DELIVERY " ;
	
	public static final String GET_BACKHAUL_PERCENTAGE=" select  "+ 
	" (select sum(isnull(ACTUAL_DISTANCE,0)) as ACTUAL_DISTANCE  from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?  "+ 
	" and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120))  ) as ACTUAL_DISTANCE,  "+ 
	" (  "+ 
	" select sum(TotalDistanceTravelled) from AMS.dbo.VehicleSummaryData where SystemId=? and ClientId=?   "+ 
	" and DateGMT between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120))) as TotalDistanceTravelled,  "+ 
	" (" +
	" select sum(isnull(ACTUAL_DISTANCE,0)) as ACTUAL_DISTANCE  from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?  "+ 
	" and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) ) as R_ACTUAL_DISTANCE,  "+ 
	" (  "+ 
	" select sum(TotalDistanceTravelled) from AMS.dbo.VehicleSummaryData where SystemId=? and ClientId=?   "+ 
	" and DateGMT between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120))) as R_TotalDistanceTravelled  ";
	
	public static final String GET_SMART_TRUCK_DETAILS=" select( "+ 
	  " select count(distinct ASSET_NUMBER) from  AMS.dbo.TRACK_TRIP_DETAILS td "+
	  " where SYSTEM_ID=? and CUSTOMER_ID=? AND STATUS='CLOSED'  "+
	  " and INSERTED_TIME "+
	  " between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ ) "+  
	  " as TOTAL_TRUCK , "+
	  " ( "+
	  " select sum(ACTUAL_DISTANCE) as TotalDistanceTravelled  from AMS.dbo.TRACK_TRIP_DETAILS "+
	  " where  SYSTEM_ID=? and CUSTOMER_ID=? AND STATUS='CLOSED'  "+
	  " and INSERTED_TIME "+
	  " between  dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ ) "+ 
	  " as ON_TRIP_KM , "+
	  " ( "+
	  " select count(distinct ASSET_NUMBER) from  AMS.dbo.TRACK_TRIP_DETAILS td "+
	  " where SYSTEM_ID=? and CUSTOMER_ID=?  AND STATUS='CLOSED'  "+
	  " and INSERTED_TIME "+
	  " between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120))  # $ ) "+  
	  " as TOTAL_TRUCK_REL , "+
	  "( "+
	  " select sum(ACTUAL_DISTANCE) as TotalDistanceTravelled  from AMS.dbo.TRACK_TRIP_DETAILS "+
	  " where  SYSTEM_ID=? and CUSTOMER_ID=? AND STATUS='CLOSED'  "+
	  " and INSERTED_TIME "+
	  " between  dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ )  "+
	  " as ON_TRIP_KM_REL ";
	
	public static final String GET_MILEAGE_ON_VEH_TYPE=" select  "+
	" (select cast( sum(a.DISTANCE_TRAVELLED)/sum(a.FUEL_CONSUMED)  as numeric(32,2) )  'Mileage' "+
	" from AMS.dbo.Refuel_And_Mileage_Summary a "+
	" inner join AMS.dbo.tblVehicleMaster vm on vm.VehicleNo=a.REGISTRATION_NO "+
	" and System_id=? and  CUSTOMER_ID=? AND vm.VehicleType=? AND REFUEL_DATE_TIME BETWEEN  "+
	" convert(varchar(10),getdate()-?,120) and  convert(varchar(10),getdate()-?,120) ) as MILEAGE , "+
	" (select cast( sum(a.DISTANCE_TRAVELLED)/sum(a.FUEL_CONSUMED)  as numeric(32,2) )  'Mileage' "+
	" from AMS.dbo.Refuel_And_Mileage_Summary a "+
	" inner join AMS.dbo.tblVehicleMaster vm on vm.VehicleNo=a.REGISTRATION_NO "+
	" and System_id=? and  CUSTOMER_ID=? AND vm.VehicleType=? AND REFUEL_DATE_TIME BETWEEN  "+
	" convert(varchar(10),getdate()-?,120) and  convert(varchar(10),getdate()-?,120) ) as RMILEAGE ";
	
	public static String GET_DASHBOARD_DETAIL_COUNT=" select (select count(*) from AMS.dbo.gpsdata_history_latest where System_id=? " +
	"and CLIENTID=? and REGISTRATION_NO not in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' )) as unassignedCount, " +
	"(select count(*) from AMS.dbo.gpsdata_history_latest where System_id=? and CATEGORY='idle' " +
	"and CLIENTID=? and REGISTRATION_NO not in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' )) as idlecount," +
	"(select count(*)  from AMS.dbo.VEHICLE_MAINTENANCE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and END_DATE is null) as undermaintainancecount, " +
	"(select count(*) from AMS.dbo.TRACK_TRIP_DETAILS td where STATUS='OPEN' and TRIP_STATUS like 'ENROUTE PLACEMENT%' " +
	"and SYSTEM_ID=? and CUSTOMER_ID=? # $ ^) as enroutementcount," +
	"(select count(*) from AMS.dbo.TRACK_TRIP_DETAILS td where STATUS='OPEN' and ACT_SRC_ARR_DATETIME IS NOT NULL AND ACTUAL_TRIP_START_TIME IS NULL " +
	"and SYSTEM_ID=? and CUSTOMER_ID=? # $ ^) as assignedplacementcount, "+
	"(select count(*) as COUNT from AMS.dbo.TRACK_TRIP_DETAILS td " +
	"left outer join DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and SEQUENCE=100 " +
	"WHERE td.STATUS='OPEN' and td.TRIP_STATUS='ON TIME' and td.ACTUAL_TRIP_START_TIME is not null and ds.ACT_ARR_DATETIME is null and SYSTEM_ID=? and CUSTOMER_ID=? # $ ^) as ontimecount, "+
	"(select count(*) as COUNT from AMS.dbo.TRACK_TRIP_DETAILS td " +
	"left outer join DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and SEQUENCE=100 " +
	"WHERE td.STATUS='OPEN' and td.TRIP_STATUS='DELAYED' and td.ACTUAL_TRIP_START_TIME is not null and ds.ACT_ARR_DATETIME is null and SYSTEM_ID=? and CUSTOMER_ID=? # $ ^) as delayedcount, "+
	"(select count(*) from AMS.dbo.TRACK_TRIP_DETAILS td where STATUS='OPEN' and TRIP_STATUS like '%DETENTION%' " +
	"and SYSTEM_ID=? and CUSTOMER_ID=? # $ ^) as detentioncount ";
	
	public static  String GET_ON_TIME_PERFORMACE=  "select "+
	  "(select count(*) from AMS.dbo.TRACK_TRIP_DETAILS td "+
	  " where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS='CLOSED' and TRIP_STATUS='ON TIME'  "+
	  " and INSERTED_TIME between  convert(varchar(10),getdate()-?,120) and  convert(varchar(10),getdate()-?,120) # $ )  "+ 
	  " as TOTAL_TRIP_AT_SOURCE ,"+
	  " (select count(*) from AMS.dbo.DES_TRIP_DETAILS dt inner join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=dt.TRIP_ID "+
	  " where SEQUENCE=0 and td.STATUS='CLOSED' and TRIP_STATUS='ON TIME'  and  DATEDIFF(mi,ACT_ARR_DATETIME,PLANNED_ARR_DATETIME)>0 and  td.SYSTEM_ID=? and td.CUSTOMER_ID=?  "+  
	  " and INSERTED_TIME between dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) # $ )  "+
	  " as ON_TIME_PLACED ,  "+
	  " (select count(*) from  AMS.dbo.DES_TRIP_DETAILS dt inner join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=dt.TRIP_ID "+
	  " where SEQUENCE=0 and td.STATUS='CLOSED' and TRIP_STATUS='ON TIME'  and  DATEDIFF(mi,ACT_DEP_DATETIME,PLANNED_DEP_DATETIME)>0 and  td.SYSTEM_ID=? and td.CUSTOMER_ID=? "+   
	  " and td.INSERTED_TIME between   dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) # $ ) "+ 
	  " as ON_TIME_DEPART ,  "+
	  " (select count(*) from AMS.dbo.DES_TRIP_DETAILS dt inner join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=dt.TRIP_ID "+
	  " where SEQUENCE=0 and td.STATUS='CLOSED' and TRIP_STATUS='ON TIME'  and  DATEDIFF(mi,ACT_ARR_DATETIME,ACT_DEP_DATETIME)<DETENTION_TIME and  td.SYSTEM_ID=? and td.CUSTOMER_ID=? "+  
	  " and INSERTED_TIME between dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) # $ )  "+
	  " as ON_TIME_LOAD , "+	  
	  " (select count(*) from  AMS.dbo.DES_TRIP_DETAILS dt inner join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=dt.TRIP_ID "+
	  " where SEQUENCE=100 and td.STATUS='CLOSED' and TRIP_STATUS='ON TIME'  and  DATEDIFF(mi,ACT_ARR_DATETIME,PLANNED_ARR_DATETIME)<DETENTION_TIME and   td.SYSTEM_ID=? and td.CUSTOMER_ID=?  "+   
	  " and td.INSERTED_TIME between dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-330,convert(varchar(10),getdate()-?,120))# $ )   "+
	  " as ON_TIME_UNLOAD ";
	
	
//	public static  String GET_HOUR_DELAY_PERFORMACE= "select ( "+
//	  "select count(*) from  AMS.dbo.DES_TRIP_DETAILS dt inner join    "+
//	  "AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=dt.TRIP_ID where SEQUENCE=100 and  "+
//	  "(datediff(mi,ACTUAL_TRIP_START_TIME,dt.ACT_ARR_DATETIME)-datediff(mi,TRIP_START_TIME,PLANNED_ARR_DATETIME))<60     "+
//	  "and td.STATUS='CLOSED' and AUTO_CLOSE is null and TRIP_STATUS !='ON TIME' and  td.SYSTEM_ID=? and td.CUSTOMER_ID=? "+
//	  "and td.INSERTED_TIME between dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) # $ )     "+
//	  "as ONE_HOUR_DELAY ,  	  "+
//	  "(select count(*) from  AMS.dbo.DES_TRIP_DETAILS dt inner join     "+
//	  "AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=dt.TRIP_ID where SEQUENCE=100 and    "+
//	  "(datediff(mi,ACTUAL_TRIP_START_TIME,dt.ACT_ARR_DATETIME)-datediff(mi,TRIP_START_TIME,PLANNED_ARR_DATETIME))>=60  and   "+
//	  "(datediff(mi,ACTUAL_TRIP_START_TIME,dt.ACT_ARR_DATETIME)-datediff(mi,TRIP_START_TIME,PLANNED_ARR_DATETIME))<180    "+
//	  "and td.STATUS='CLOSED' and AUTO_CLOSE is null and TRIP_STATUS !='ON TIME' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?     "+
//	  "and td.INSERTED_TIME between dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) # $ )   "+
//	  "as THREE_HOURS_DELAY,   	 "+
//	  "( select count(*) from  AMS.dbo.DES_TRIP_DETAILS dt inner join     "+
//	  "AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=dt.TRIP_ID where SEQUENCE=100 and    "+
//	  "(datediff(mi,ACTUAL_TRIP_START_TIME,dt.ACT_ARR_DATETIME)-datediff(mi,TRIP_START_TIME,PLANNED_ARR_DATETIME))>=180 AND    "+
//	  "(datediff(mi,ACTUAL_TRIP_START_TIME,dt.ACT_ARR_DATETIME)-datediff(mi,TRIP_START_TIME,PLANNED_ARR_DATETIME))<300     "+
//	  "and td.STATUS='CLOSED' and AUTO_CLOSE is null and TRIP_STATUS !='ON TIME' and  td.SYSTEM_ID=? and td.CUSTOMER_ID=?  "+
//	  "and td.INSERTED_TIME between dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) # $ ) "+
//	  "as FIVE_HOUR_DELAY ,   "+
//	  "( select count(*) from  AMS.dbo.DES_TRIP_DETAILS dt inner join "+
//	  "AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=dt.TRIP_ID where SEQUENCE=100 and   "+
//	  "(datediff(mi,ACTUAL_TRIP_START_TIME,dt.ACT_ARR_DATETIME)-datediff(mi,TRIP_START_TIME,PLANNED_ARR_DATETIME))>=300    "+
//	  "and td.STATUS='CLOSED' and AUTO_CLOSE is null and TRIP_STATUS !='ON TIME' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?    "+
//	  "and td.INSERTED_TIME between dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) # $ )    "+
//	  "as ABOVE_FIVE_HOUR_DELAY   ";
	
	public static  String GET_HOUR_DELAY_PERFORMACE = "select abs(datediff(mi,ACTUAL_TRIP_START_TIME,dt.ACT_ARR_DATETIME)-datediff(mi,TRIP_START_TIME,PLANNED_ARR_DATETIME)) as DELAY from  AMS.dbo.DES_TRIP_DETAILS dt inner join    "
	  +"AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=dt.TRIP_ID where SEQUENCE=100 and  "
	  +"(datediff(mi,ACTUAL_TRIP_START_TIME,dt.ACT_ARR_DATETIME)-datediff(mi,TRIP_START_TIME,PLANNED_ARR_DATETIME)) is not null and td.STATUS='CLOSED'  and TRIP_STATUS !='ON TIME' and  td.SYSTEM_ID=? and td.CUSTOMER_ID=? "
	  +"and td.INSERTED_TIME between dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) # $  ";
	
	public static  String GET_HOUR_DELAY_PERFORMACE_TOTAL = "select count(*) as TOTAL_DELAY  from AMS.dbo.TRACK_TRIP_DETAILS td where STATUS='CLOSED' and TRIP_STATUS !='ON TIME' "+
	  "and td.SYSTEM_ID=? and td.CUSTOMER_ID=?   "+
	  "and INSERTED_TIME between dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-330,convert(varchar(10),getdate()-?,120)) # $   ";
	
	public static final String GET_PANEL_TABLE_DETAILS="select isnull(REGISTRATION_NO,'') as VEHICLE_NO,isnull(GPS_DATETIME,'') as GPS_DATETIME,isnull(LOCATION,'') as LOCATION " +
	"from AMS.dbo.gpsdata_history_latest where System_id=? " +
	"and CLIENTID=? and REGISTRATION_NO not in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' )";
	
	public static final String GET_PANEL_IDLE_TABLE_DETAILS="select isnull(REGISTRATION_NO,'') as VEHICLE_NO,isnull(GPS_DATETIME,'') as GPS_DATETIME,isnull(LOCATION,'') as LOCATION from AMS.dbo.gpsdata_history_latest where System_id=? and CATEGORY='idle' " +
	"and CLIENTID=? and REGISTRATION_NO not in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' )";
	
	public static final String GET_PANEL_STOPAGE_TABLE_DETAILS="select isnull(REGISTRATION_NO,'') as VEHICLE_NO,isnull(GPS_DATETIME,'') as GPS_DATETIME,isnull(LOCATION,'') as LOCATION from AMS.dbo.gpsdata_history_latest where System_id=? and CATEGORY='stoppage' " +
	"and CLIENTID=? and REGISTRATION_NO not in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' )";
	
	public static final String GET_ASSIGNED_ENROUTE_PLACED_DETAILS="select isnull(b.CUSTOMER_NAME,'') Customer_Name,isnull(c.RouteName,'') Route_Name,isnull(a.REGISTRATION_NO,'') as VEHICLE_NO,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isnull(LOCATION,'') as LOCATION " +
	"from AMS.dbo.gpsdata_history_latest a " +
	"inner join AMS.dbo.TRACK_TRIP_DETAILS b on b.ASSET_NUMBER=a.REGISTRATION_NO " +
	"left outer join AMS.dbo.Route_Master c on c.RouteID=b.ROUTE_ID " +
	"where a.System_id=? and a.CLIENTID=? and b.STATUS='OPEN' # $ ^ ";
	
	public static final String GET_SAMRT_TRUCK_ALERT_COUNT=" select  "+
	" (select count(*) from TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?   "+
	" and INSERTED_TIME>dateadd(hh,-24,getutcdate()) and TRIP_STATUS='ON TIME') as ON_TRIP ,  "+
	"  (select count(*) from TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?    "+
	" and INSERTED_TIME>dateadd(hh,-24,getutcdate()) ) as TOTAL_TRIP ,  "+
	"(select count(*) as COUNT from AMS.dbo.TRACK_TRIP_DETAILS td "+
	"left outer join DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and SEQUENCE=100 "+
	"WHERE td.STATUS='OPEN' and td.TRIP_STATUS='ON TIME' and td.ACTUAL_TRIP_START_TIME is not null and ACTUAL_TRIP_START_TIME > dateadd(hh,-1,getutcdate()) and ds.ACT_ARR_DATETIME is null)  as ON_TRIP_ALERT ,"+
	"  (select count(*) from TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?    "+
	" and INSERTED_TIME>dateadd(hh,-1,getutcdate()) ) as TOTAL_TRIP_ALERT ,  "+
	" (select count(*) from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate())   "+
	" and ALERT_TYPE=2 and SYSTEM_ID=? AND CUSTOMER_ID=? ) as OVER_SPEED ,  "+
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=105  "+
	"  and SYSTEM_ID=? AND CUSTOMER_ID=? ) as HA ,  "+
	"  (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=58  "+
	"  and SYSTEM_ID=? AND CUSTOMER_ID=?  "+
	" ) as HB ,  "+
	" (select count(*) from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=106   "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=?  "+
	" ) as HC ,  "+
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=5  "+
	"  and SYSTEM_ID=? AND CUSTOMER_ID=?  "+
	" ) as ROUTE_DEVIATION ,  "+
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=1   "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=?  "+
	" ) as STOPPAGE, " +
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=93  "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=?  "+
	" ) as FREE_WHEELING, "+
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=194  "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=?  "+
	" ) as LOW_HIGH_RPM ," +
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=195  "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=?  "+
	" ) as LOW_MILEAGE ";
	
/*	public static final String GET_SAMRT_TRUCK_DRIVER_DETAILS="SELECT isnull(a.Fullname,'') as DriverName,isnull(Mobile,'') as Contact_No ,b.REGISTRATION_NO  "+
	"FROM  AMS.dbo.Driver_Master a "+
	"inner join AMS.dbo.Driver_Vehicle b on b.SYSTEM_ID=a.System_id and b.DRIVER_ID=a.Driver_id "+
	"WHERE a.System_id=? and a.Client_id=? "; 
	*/
	/*public static final String GET_DRIVER_ALERT_COUNTS="select count(*) as Total_ALERT_COUNT,ALERT_TYPE  "+
	"from TRIP_EVENT_DETAILS "+
	"where ALERT_TYPE in (2,105,58,106,5,1) "+
	"and VEHICLE_NO='KA5300356'    "+
	"group by ALERT_TYPE ";*/
	
	public static final String GET_DRIVER_ALERT_COUNTS="select count(*) as Total_ALERT_COUNT,ALERT_TYPE " +
	"from TRIP_EVENT_DETAILS " +
	"where ALERT_TYPE in (2,105,58,106,5,1) " +
	"and VEHICLE_NO=? and GMT between ? and ? " +
	"and SYSTEM_ID=? and CUSTOMER_ID=?  "+
	"group by ALERT_TYPE ";
	
	/*public static final String GET_DRIVER_ALERT_COUNTS="select count(*) as Total_ALERT_COUNT,ALERT_TYPE  "+
	"from TRIP_EVENT_DETAILS "+
	"where ALERT_TYPE in (2,105,58,106,5,1) "+
	"and VEHICLE_NO=?  and GMT>dateadd(hh,-1,getutcdate())  "+
	" and SYSTEM_ID=? and CUSTOMER_ID=? "+
	"group by ALERT_TYPE ";*/
	
	public static  String GET_SAMRT_TRUCK_ALERT_DETAILS=" select ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,isnull(LOCATION,'') as LOCATION,isnull(dateadd(mi,?,GMT),'') as GMT, "+
	" isnull(REMARKS,'') as REMARKS  "+
	" from AMS.dbo.TRIP_EVENT_DETAILS where ALERT_TYPE=? and GMT>dateadd(hh,-1,getutcdate())  "+
	" and SYSTEM_ID=? and CUSTOMER_ID=? # ";
	
	public static  String GET_SAMRT_TRUCK_ALERT_DETAILS_FOR_TABLE=" select ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,isnull(LOCATION,'') as LOCATION,isnull(dateadd(mi,?,GMT),'') as GMT, "+
	" isnull(REMARKS,'') as REMARKS  "+
	" from AMS.dbo.TRIP_EVENT_DETAILS where ALERT_TYPE=? and GMT between ? and ?   "+
	" and SYSTEM_ID=? and CUSTOMER_ID=? and VEHICLE_NO=?  ";
	
	public static final String GET_SAMRT_TRUCK_ALERT_DETAILS_NON_REMARK=" select isnull(ASSET_NUMBER,'') as VEHICLE_NO, isnull(START_LOCATION,'') as LOCATION ,isnull(dateadd(mi,?,INSERTED_TIME),'') as GMT "+
	" from AMS.dbo.TRACK_TRIP_DETAILS "+
	" where INSERTED_TIME>dateadd(hh,-1,getutcdate()) and TRIP_STATUS='ON TIME' "+
	" and SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_OEM_MAKE_DETAILS=" select distinct Model,ModelName from AMS.dbo.tblVehicleMaster a  " +
	" inner join FMS.[dbo].[Vehicle_Model] vm on   vm.ModelTypeId=a.Model and vm.SystemId=a.System_id" +
	" inner join [dbo].[gpsdata_history_latest] b on REGISTRATION_NO=VehicleNo" +
	" where a.System_id=? and b.CLIENTID=?";

	public static final String GET_OEM_BASED_VEHICLE_DETAILs="select distinct VehicleNo from AMS.dbo.tblVehicleMaster vm" +
	" inner join AMS.dbo.gpsdata_history_latest a on vm.VehicleNo=a.REGISTRATION_NO" +
	" where a.System_id=? and a.CLIENTID=? # ";

	public static final String GET_TRUCK_TYPE_DETAILS="select distinct VehicleType,VehicleAlias from AMS.dbo.tblVehicleMaster a" +
	" inner join [dbo].[gpsdata_history_latest] on REGISTRATION_NO=VehicleNo" +
	" where a.System_id=? and CLIENTID=? #";
	
	//	public static final String GET_SAMRT_TRUCK_DRIVER_DETAILS="";
	
	public static String GET_ERROR_ALERT_DETAILS = "select " +
	" count(case when ERROR_CODE like 'P%' then 1 end)   as PowerTrain, " +
	" count(case when ERROR_CODE like 'C%' then 1 end)    as Chasis," +
	" count(case when ERROR_CODE like 'B%' then 1 end)    as Body" +
	" from  dbo.CANIQ_ERROR_CODES a" +
	" inner join AMS.dbo.tblVehicleMaster b on b.VehicleNo=a.REGISTRATION_NO" +
	" inner join FMS.dbo.Vehicle_Model vm on b.Model=vm.ModelTypeId"+
	" where SYSTEM_ID=? and CLIENT_ID=? and GMT between dateadd(dd,-7,getutcdate()) and getutcdate() # ";
	
	public static String GET_ERROR_ALERT_DETAILS_DESCRIPTION=" select isnull(a.REGISTRATION_NO,'') AS vehicleNo, isnull(a.LOCATION,'') AS LOCATION,dateadd(mi,?,a.GMT) AS Datevalue, isnull(a.ACTION_TAKEN,'') AS REMARKS, isnull(a.SLNO,'0') AS serial " +
	" from  dbo.CANIQ_ERROR_CODES a inner join AMS.dbo.tblVehicleMaster b on b.VehicleNo=a.REGISTRATION_NO " +
	" inner join FMS.dbo.Vehicle_Model vm on b.Model=vm.ModelTypeId"+
	" where SYSTEM_ID=? and CLIENT_ID=? and GMT between dateadd(dd,-7,getutcdate()) and getutcdate() ";
	
	public static final String UPDATE_ACTION_TAKEN = " update AMS.dbo.CANIQ_ERROR_CODES set ACTION_TAKEN=? where SLNO=? and SYSTEM_ID=? and CLIENT_ID=? ";

	public static final String GET_POWER_COOLANT_COUNT=" select count(*) as CoolantCount from Alert vc " +
	" inner join AMS.dbo.tblVehicleMaster b on b.VehicleNo=vc.REGISTRATION_NO " +
	" inner join FMS.dbo.Vehicle_Model vm on b.Model=vm.ModelTypeId WHERE SYSTEM_ID=? and vc.CLIENTID=? and GMT between dateadd(dd,-7,getutcdate()) and getutcdate() # ";

	public static final String GET_POWER_COOLANT_COUNT_DETAILS="select isnull(SLNO,0) as SLNO,isnull(a.REGISTRATION_NO,'') AS vehicleNo, isnull(a.LOCATION,'') AS LOCATION,dateadd(mi,?,a.GMT) AS Datevalue,isnull(a.ACTION_TAKEN,'') AS REMARKS " +
	" from  dbo.Alert a inner join AMS.dbo.tblVehicleMaster b on b.VehicleNo=a.REGISTRATION_NO " +
	" inner join FMS.dbo.Vehicle_Model vm on b.Model=vm.ModelTypeId "+
	" where SYSTEM_ID=? and a.CLIENTID=? and GMT between dateadd(dd,-7,getutcdate()) and getutcdate() ";

	public static final String UPDATE_ACTION_TAKEN_POWER="update AMS.dbo.Alert set ACTION_TAKEN=? where SLNO=? and SYSTEM_ID=? and CLIENTID=? ";
	
	public static final String GET_COUNTS_FOR_DASHBOARD = " select count(*) as COUNT,'ONTIME'  as STATUS from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" inner join AMS.dbo.Vehicle_User vu on vu.Registration_no=td.ASSET_NUMBER and vu.User_id=? " +
	" where STATUS='OPEN' and TRIP_STATUS='ON TIME' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? " +
	" union all " +
	" select count(*) as COUNT,'DELAYED' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" inner join AMS.dbo.Vehicle_User vu on vu.Registration_no=td.ASSET_NUMBER and vu.User_id=? " +
	" where STATUS='OPEN' and TRIP_STATUS='DELAYED' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? " +
	" union all " +
	" select count(*) as COUNT,'LOADING_DETENTION' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" inner join AMS.dbo.Vehicle_User vu on vu.Registration_no=td.ASSET_NUMBER and vu.User_id=? " +
	" where STATUS='OPEN' and TRIP_STATUS='LOADING DETENTION' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? " + 
	" union all " +
	" select count(*) as COUNT,'UNLOADING_DETENTION' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" inner join AMS.dbo.Vehicle_User vu on vu.Registration_no=td.ASSET_NUMBER and vu.User_id=? " +
	" where STATUS='OPEN' and TRIP_STATUS='UNLOADING DETENTION' " +
	" and SYSTEM_ID=? and CUSTOMER_ID=? " ;
	
	public static final String GET_VEHICLES = "select isnull(gps.DRIVER_NAME,'') as DRIVER_NAME,isnull(DELAY,0) as DELAY,ISNULL(td.CUSTOMER_NAME,'') as CUSTOMER_NAME,td.SHIPMENT_ID,td.TRIP_STATUS,ASSET_NUMBER,isnull(gps.LATITUDE,0) as LATITUDE,isnull(gps.LONGITUDE,0) as LONGITUDE,isnull(gps.LOCATION,'') as LOCATION," +
	" isnull(dateadd(mi,?,GMT),'') as GMT " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID " +
	" inner join AMS.dbo.Vehicle_User vu on vu.Registration_no=td.ASSET_NUMBER and vu.User_id=? " +
	" where STATUS=? and SYSTEM_ID=? and CUSTOMER_ID=? ";
	
	
	public static final String GET_VEHICLE_DETAILS = " select 'CURRENT',SYSTEM_ID,isnull(a.Fullname,'') as DRIVER_NAME, isnull(dv.REGISTRATION_NO,'') AS VEHICLE_NO,isnull(dv.DATE_TIME,'') as STARTTIME,getutcdate() as END_TIME "+
	" from Driver_Vehicle dv "+
	" inner join AMS.dbo.Driver_Master a on a.Driver_id = dv.DRIVER_ID and a.System_id=dv.SYSTEM_ID "+
	" where dv.DATE_TIME > dateadd(dd,-?,getutcdate()) "+ 
	" and dv.SYSTEM_ID=? and dv.DRIVER_ID=? "+
	" union all "+
	" select 'HISTORY',SYSTEM_ID,isnull(a.Fullname,'') as DRIVER_NAME, isnull(dv.REGISTRATION_NO,'') AS VEHICLE_NO,isnull(dv.FROM_DATE_TIME,'') as STARTTIME,TO_DATE_TIME as END_TIME "+
	" from DRIVER_VEHICLE_HISTORY dv " +
	" inner join AMS.dbo.Driver_Master a on a.Driver_id = dv.DRIVER_ID and a.System_id=dv.SYSTEM_ID "+
	" where (dv.FROM_DATE_TIME > dateadd(dd,-?,getutcdate()) or dv.TO_DATE_TIME>dateadd(dd,-?,getutcdate())) "+
	" and dv.SYSTEM_ID=? and dv.DRIVER_ID=? "+
	" order by STARTTIME asc ";
	
	public static final String GET_DRIVER_DETAILS=" select Driver_id,Fullname,Mobile as Contact_No,System_id,Client_id from AMS.dbo.Driver_Master where System_id=? and Client_id=?";

	
	public static final String GET_SAMRT_TRUCK_REMARKED_ALERT_COUNT=" select  "+
	" (select count(*) from TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?   "+
	" and INSERTED_TIME>dateadd(hh,-24,getutcdate()) and TRIP_STATUS='ON TIME') as ON_TRIP ,  "+
	"  (select count(*) from TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?    "+
	" and INSERTED_TIME>dateadd(hh,-24,getutcdate()) ) as TOTAL_TRIP ,  "+
	"(select count(*) as COUNT from AMS.dbo.TRACK_TRIP_DETAILS td "+
	"left outer join DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and SEQUENCE=100 "+
	"WHERE td.STATUS='OPEN' and td.TRIP_STATUS='ON TIME' and td.ACTUAL_TRIP_START_TIME is not null and ACTUAL_TRIP_START_TIME > dateadd(hh,-1,getutcdate()) and ds.ACT_ARR_DATETIME is null)  as ON_TRIP_ALERT ,"+
	"  (select count(*) from TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?   "+
	" and INSERTED_TIME>dateadd(hh,-1,getutcdate()) ) as TOTAL_TRIP_ALERT ,  "+
	" (select count(*) from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate())   "+
	" and ALERT_TYPE=2 and SYSTEM_ID=? AND CUSTOMER_ID=? and REMARKS is null) as OVER_SPEED ,  "+
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=105  "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=? and REMARKS is null) as HA ,  "+
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=58  "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=? and REMARKS is null "+
	" ) as HB ,  "+
	" (select count(*) from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=106   "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=? and REMARKS is null "+
	" ) as HC ,  "+
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=5  "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=? and REMARKS is null "+
	" ) as ROUTE_DEVIATION ,  "+
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=1   "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=? and REMARKS is null "+
	" ) as STOPPAGE, " +
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=93  "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=? and REMARKS is null "+
	" ) as FREE_WHEELING, "+
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=194  "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=? and REMARKS is null "+
	" ) as LOW_HIGH_RPM ," +
	" (select count(*)  from TRIP_EVENT_DETAILS where GMT>dateadd(hh,-1,getutcdate()) and ALERT_TYPE=195  "+
	" and SYSTEM_ID=? AND CUSTOMER_ID=? and REMARKS is null "+
	" ) as LOW_MILEAGE ";

	public static final String GET_ASSOCIATION_DETAILS = "select ID,IO_ID ioId,isnull(IO_CATEGORY,'NA') as category, isnull(IO_TYPE,'NA') as ioType,isnull(SENSOR_ID,'') as sensorId from RS232_ASSOCIATION" +
	" where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO=? order by ID";

	public static final String CHECK_RECORD_EXIST = "select count(ID) as counta,'digital' as type from RS232_ASSOCIATION where SYSTEM_ID=? and CLIENT_ID=?" +
	" and REGISTRATION_NO=? and IO_ID like 'INP%'"+
	" union all"+
	" select count(ID) as counta,'analog' as type from RS232_ASSOCIATION where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO=? and IO_ID like 'ANG%'"+
	" union all"+
	" select count(ID) as counta,'button' as type from RS232_ASSOCIATION where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO=? and IO_ID like 'IBUTTON%'"+
	" union all "+
	" select count(ID) as counta,'onewire' as type from RS232_ASSOCIATION where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO=? and IO_ID like 'ONEWIRE%'"+
	" union all "+
	" select count(ID) as counta,'zang' as type from RS232_ASSOCIATION where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO=? and IO_ID in (#)";
	
	public static final String GET_PORT_COUNT = "select isnull(Digital_Inputs,0) as digital,isnull(Analog_Inputs,0) as analog,isnull(Ibutton,0) as button,isnull(Onewire,0) as onewire" +
	" from Unit_Type_Master where Unit_type_code=?";

	public static final String CHECK_USER_VEHICLE = "select isnull(vc.REGISTRATION_NUMBER,'') as vehicleNo,isnull(vo.Unit_Type_Code,0) as unitType,isnull(Unit_Number,0) as unitNo" +
	" from  VEHICLE_CLIENT vc"+ 
	" inner join Vehicle_User vu on vu.Registration_no=vc.REGISTRATION_NUMBER and vu.System_id=vc.SYSTEM_ID and vu.User_id=?"+
	" inner join dbo.Vehicle_association vo on vo.Registration_no=vc.REGISTRATION_NUMBER and vo.Client_id=vc.CLIENT_ID"+
	" inner join Unit_Type_Master utm on Unit_Type_Code=Unit_type_code "+
	" where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and utm.Manufacture_code in (7,22,13,27) order by vc.REGISTRATION_NUMBER";
	
	public static final String CHECK_CATEGOTY_LIST = "select VALUE from dbo.LOOKUP_DETAILS where VERTICAL=? order by ORDER_OF_DISPLAY";


	public static final String INSERT_ASSOCIATION_DETAILS = "insert into RS232_ASSOCIATION (REGISTRATION_NO,IO_ID,IO_CATEGORY,UPDATED_GMT,SYSTEM_ID,CLIENT_ID,USER_ID,IO_TYPE,SENSOR_ID)" +
	" values (?,?,?,getutcdate(),?,?,?,?,?)";

	public static final String DELETE_OLD_RECORDS = "delete from RS232_LIVE where REGISTRATION_NO=?";

	public static final String INERT_INTO_LIVE_TABLE = "insert into RS232_LIVE (REGISTRATION_NO,UNIT_NO,GMT,GPS_DATETIME,SPEED,IO_CATEGORY,IO_VALUE,IO_ID," +
	" SYSTEM_ID,CLIENT_ID,SENSOR_ID) values (?,?,getutcdate(),getdate(),?,?,?,?,?,?,?)";

	public static final String MOVE_TO_ASSOCIATION_HISTORY = "insert into RS232_ASSOCIATION_HISTORY (REGISTRATION_NO,IO_ID,IO_CATEGORY,UPDATED_GMT,SYSTEM_ID,CLIENT_ID,USER_ID,IO_TYPE,SENSOR_ID)" +
	" select REGISTRATION_NO,IO_ID,IO_CATEGORY,UPDATED_GMT,SYSTEM_ID,CLIENT_ID,USER_ID,IO_TYPE,SENSOR_ID from RS232_ASSOCIATION where ID=?";


	public static final String UPDATE_ASSOCIATED_DATA = "update RS232_ASSOCIATION set IO_ID=?,IO_CATEGORY=?,UPDATED_GMT=getutcdate(),IO_TYPE=?,USER_ID=?,SENSOR_ID=?" +
	" where REGISTRATION_NO=? and ID=?";

	public static final String GET_TYPES = "select * from dbo.LOOKUP_DETAILS where VERTICAL='GENERAL_VERTICAL' and TYPE='TYPE'";
	
	public static final String GET_TRIP_NAME = " select isnull(SHIPMENT_ID,'') as TRIP_NAME,ASSET_NUMBER,isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as STD, " +
	" (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as END_DATE, " +
	" isnull(vm.ModelName,'') as MAKE from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	" inner join AMS.dbo.tblVehicleMaster c on td.ASSET_NUMBER=c.VehicleNo " +
	" left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model " +
	" where SYSTEM_ID=? AND CUSTOMER_ID=? " ;

	public static final String GET_TEMPERATURE_FROM_HISTORY_DATA = " select r.REGISTRATION_NO ,r.GMT,r.LOCATION,r.IO_VALUE,IO_CATEGORY from (" +
			" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,LOCATION,IO_VALUE,IO_CATEGORY from RS232_HISTORY where REGISTRATION_NO=? and IO_CATEGORY=? " +
			" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) " +
			" union all "+
			" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,LOCATION,IO_VALUE,IO_CATEGORY from AMS_Archieve.dbo.RS232_HISTORY_ARCHIEVE where REGISTRATION_NO=? and IO_CATEGORY=? " +
			" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) ) r order by GMT " ;
	
	public static final String GET_TEMPERATURE_DATA = " select distinct r.REGISTRATION_NO ,r.GMT,r.LOCATION,r.IO_VALUE,IO_CATEGORY from (" +
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,LOCATION,IO_VALUE,IO_CATEGORY " +
	" from RS232_HISTORY where REGISTRATION_NO=?  and IO_CATEGORY in ('TEMPERATURE1','TEMPERATURE2','TEMPERATURE3') " +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) " +
	" union all "+
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,LOCATION,IO_VALUE,IO_CATEGORY from AMS_Archieve.dbo.RS232_HISTORY_ARCHIEVE where REGISTRATION_NO=? and " +
	" IO_CATEGORY in ('TEMPERATURE1','TEMPERATURE2','TEMPERATURE3') " +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) ) r order by GMT " ;

	public static final String GET_ALL_TEMP_COUNT = "SELECT  tvt.DISPLAY_NAME AS SENSOR_NAME,rs.IO_VALUE AS VALUE,dateadd(mi,?,GMT) as GMT FROM AMS.dbo.TRIP_VEHICLE_TEMPERATURE_DETAILS tvt "+
													" LEFT OUTER JOIN AMS.dbo.RS232_LIVE rs ON rs.REGISTRATION_NO=tvt.VEHICLE_NUMBER AND rs.IO_ID=tvt.SENSOR_NAME WHERE tvt.TRIP_ID=? and rs.SYSTEM_ID=? AND rs.CLIENT_ID=? ";
	
	public static final String GET_TEMP_COUNT1 = " select top 1 isnull(IO_VALUE,'') as T1,isnull(dateadd(mi,?,GMT),'') as GMT from AMS.dbo.RS232_LIVE where REGISTRATION_NO=? and IO_CATEGORY in ('TEMPERATURE1') order by GMT DESC ";

	public static final String GET_TEMP_COUNT2 = " select top 1 isnull(IO_VALUE,'') as T2,isnull(dateadd(mi,?,GMT),'') as GMT from AMS.dbo.RS232_LIVE where REGISTRATION_NO=? and IO_CATEGORY in ('TEMPERATURE2') order by GMT DESC " ;
	
	public static final String GET_TEMP_COUNT3 = " select top 1 isnull(IO_VALUE,'') as T3,isnull(dateadd(mi,?,GMT),'') as GMT from AMS.dbo.RS232_LIVE where REGISTRATION_NO=? and IO_CATEGORY in ('TEMPERATURE3') order by GMT DESC " ;
	
	public static final String GET_TEMP_COUNT4 = " select top 1 isnull(IO_VALUE,'') as REEFER,isnull(dateadd(mi,?,GMT),'') as GMT from AMS.dbo.RS232_LIVE where REGISTRATION_NO=? and IO_CATEGORY in ('REEFER') order by GMT DESC " ;

	public static final String GET_TEMPERATURE_REPORT = " select r.REGISTRATION_NO ,r.GMT,r.LOCATION,r.IO_VALUE,IO_CATEGORY from (" +
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,isnull(LOCATION,'') as LOCATION,IO_VALUE,IO_CATEGORY from  RS232_HISTORY " +
	" where REGISTRATION_NO=? and IO_CATEGORY in ('TEMPERATURE1','TEMPERATURE2','TEMPERATURE3','REEFER') " +
	" and GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) "+
	" union "+
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,isnull(LOCATION,'') as LOCATION,IO_VALUE,IO_CATEGORY from  AMS_Archieve.dbo.RS232_HISTORY_ARCHIEVE " +
	" where REGISTRATION_NO=? and IO_CATEGORY in ('TEMPERATURE1','TEMPERATURE2','TEMPERATURE3','REEFER') " +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) ) r order by r.GMT ";
	
	public static final String GET_VEHICLES_FOR_TEMP_REPORT = "select DISTINCT gps.REGISTRATION_NO from AMS.dbo.gpsdata_history_latest gps " + 
	" left outer join dbo.Live_Vision_Support  b (nolock) on gps.REGISTRATION_NO=b.REGISTRATION_NO 	"+
	" where gps.System_id=? and gps.CLIENTID = ? and b.GROUP_NAME='TCL' " ;

	public static final String GET_TRIP_NAMES= " select TRIP_ID,isnull(ORDER_ID,'') as TRIP_NAME,(isnull(ORDER_ID,'')+'-('+isnull(ASSET_NUMBER,'')+')') as TRIP_NAME_1 " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" where SYSTEM_ID=? AND CUSTOMER_ID=? AND PRODUCT_LINE='TCL' ## order by TRIP_ID desc ";
	
	public static final String GET_TRIP_DATA= " select datediff(dd,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME) as days,VehicleAlias,td.TRIP_ID,isnull(SHIPMENT_ID,'') as TRIP_NAME,ASSET_NUMBER,td.STATUS," +
	"isnull(dateadd(mi,?,ACT_SRC_ARR_DATETIME),case when INSERTED_TIME>d0.PLANNED_ARR_DATETIME then dateadd(mi,?,d0.PLANNED_ARR_DATETIME) else dateadd(mi,?,INSERTED_TIME) end) as STD,  " +
	" (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as END_DATE, " +
	" isnull(vm.ModelName,'') as MAKE from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	" inner join AMS.dbo.tblVehicleMaster c on td.ASSET_NUMBER=c.VehicleNo " +
	" left outer join AMS.dbo.[DES_TRIP_DETAILS] d0 on d0.TRIP_ID= td.TRIP_ID and d0.SEQUENCE=0 " +
	" left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model " +
	" where td.TRIP_ID=? " ;
	
	public static final String GET_SOURCE_DESTINATION = " select HUBID,NAME,LATITUDE,LONGITUDE,RADIUS,Standard_Duration from AMS.dbo.LOCATION_ZONE where CLIENTID=? and SYSTEMID=? and OPERATION_ID!=2 and (RADIUS>0 or RADIUS=-1) ";

	public static final String GET_CHECK_POINT = " select HUBID,NAME,LATITUDE,LONGITUDE,RADIUS,Standard_Duration from AMS.dbo.LOCATION_ZONE where CLIENTID=? and SYSTEMID=? and OPERATION_ID in (1,26) ";

	public static final String GET_ASSOCIATION_DATA = " select count(*) as COUNT from  AMS.dbo.RS232_ASSOCIATION where IO_CATEGORY in ('TEMPERATURE1','TEMPERATURE2','TEMPERATURE3') " +
			" and REGISTRATION_NO=?" ;
	
	public static final String GET_DRIVER_SCORE_PARAMETER_SETTING_DATA = "select a.UID, isnull(b.ModelName,'') as MODEL_NAME ,isnull(a.PARAMETER,'') as PARAMETER, isnull(a.MIN,0) as MIN_VALUE,isnull(a.MAX,0) as MAX_VALUE,isnull(a.TYPE,'')as TYPE " +
			" from AMS.dbo.DRIVER_SCORE_PARAMETER_SETTING a " +
			" left outer join FMS.dbo.Vehicle_Model b on b.ModelTypeId=a.MODEL_ID and b.SystemId=a.SYSTEM_ID " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.MODEL_ID=? ";

	public static final String GET_VEHICLE_MODEL_DETAILS ="select ModelName, ModelTypeId from FMS.dbo.Vehicle_Model where SystemId=? and ClientId=?";
	
	public static final String GET_PARAMETERS_FOR_VEHICLES =" select distinct isNull(VALUE,'') as PARAM_NAME from dbo.LOOKUP_DETAILS WHERE VERTICAL='DRIVER_SCORE_PARAMETER' and VALUE not in " + 
			" (select PARAMETER from AMS.dbo.DRIVER_SCORE_PARAMETER_SETTING " +
			" where MODEL_ID= ?  and SYSTEM_ID = ? and CUSTOMER_ID = ?)";
	
	public static final String SAVE_DRIVER_SCORE_PARAMETERS ="insert into AMS.dbo.DRIVER_SCORE_PARAMETER_SETTING  (PARAMETER,MIN,MAX,MODEL_ID,TYPE,SYSTEM_ID,CUSTOMER_ID,INSERTED_DATE) " +
			" values (?,?,?,?,?,?,?,getutcdate())";
	
	public static final String MODIFY_DRIVER_SCORE_PARAMETERS =" update AMS.dbo.DRIVER_SCORE_PARAMETER_SETTING SET MIN=?, MAX=? where UID=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
	//****************************************************DRIVER PERFORMANCE **********************************************************************//
	public static final String GET_OVERALL_SCORE = " Select count(REGISTRATION_NO) AS NO_OF_DRIVERS,isnull(sum(FINAL_SCORE*CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0))/"+
	" SUM(CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0)),0) as TOTAL_SCORE,'PRESENT_MONTH' as STATUS " +
	" from AMS.dbo.TRIP_DRIVER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? # and END_DATE between DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0) and getutcdate() " +
	" union all  "+
//	" Select count(REGISTRATION_NO) AS NO_OF_DRIVERS,isnull(sum(FINAL_SCORE*CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0))/ "+
//	" SUM(CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0)),0) as TOTAL_SCORE,'LAST_MONTH' as STATUS " +
//	" from AMS.dbo.TRIP_DRIVER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? # and END_DATE between DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE())-1, 0) " +
//	" and DATEADD(MONTH, DATEDIFF(MONTH,-1,GETDATE())-1,-1) " +
//	" union all  "+
	" Select count(REGISTRATION_NO) AS NO_OF_DRIVERS,isnull(sum(FINAL_SCORE*CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0))/ "+
	" SUM(CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0)),0) as TOTAL_SCORE,'OVERALL' as STATUS " +
	" from AMS.dbo.TRIP_DRIVER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? # ";

	public static final String GET_DATA_FOR_CHART = " select count(r.COUNT) as COUNT ,'LOW' as STATUS from (Select isnull(count(DRIVER_ID),0) AS COUNT,'LOW' as STATUS , " +
	" (sum(FINAL_SCORE*CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0))/  " +
	" SUM(CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0)) ) as TOTAL_SCORE " +
	" from AMS.dbo.TRIP_DRIVER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and DRIVER_ID!= 0 " +
	" and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) # group by DRIVER_ID ) r where r.TOTAL_SCORE BETWEEN 0 AND 7 " +
	" UNION ALL " +
	" select count(r.COUNT) as COUNT ,'MEDIUM' as STATUS from (Select isnull(count(DRIVER_ID),0) AS COUNT,'MEDIUM' as STATUS , " +
	" (sum(FINAL_SCORE*CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0))/  " +
	" SUM(CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0)) ) as TOTAL_SCORE " +
	" from AMS.dbo.TRIP_DRIVER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and DRIVER_ID!= 0 " +
	" and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) # group by DRIVER_ID ) r where r.TOTAL_SCORE BETWEEN 7 AND 9 " +
	" UNION ALL " +
	" select count(r.COUNT) as COUNT ,'HIGH' as STATUS from (Select isnull(count(DRIVER_ID),0) AS COUNT,'HIGH' as STATUS , " +
	" (sum(FINAL_SCORE*CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0))/  " +
	" SUM(CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0)) ) as TOTAL_SCORE " +
	" from AMS.dbo.TRIP_DRIVER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and DRIVER_ID!= 0 " +
	" and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) # group by DRIVER_ID ) r where r.TOTAL_SCORE BETWEEN 9 AND 10 " ;

	public static final String GET_PERFORMANCE_DATA = "select isnull(sum(HB_SCORE),0) as HB_SCORE,isnull(sum(HA_SCORE),0) as HA_SCORE," +
	" isnull(sum(HC_SCORE),0) as HC_SCORE,isnull(sum(OVER_REVV_SCORE),0) as OVER_REVV_SCORE,isnull(sum(OVER_SPEED_SCORE),0) as OVER_SPEED_SCORE,"+
	" isnull(sum(IDLE_SCORE),0) as IDLE_SCORE,isnull(sum(UNSCHDL_STOPPAGE_SCORE),0) as UNSCHDL_STOPPAGE_SCORE,isnull(sum(GREEN_BAND_SPEED_SCORE),0) as GREEN_BAND_SPEED_SCORE," +
	" isnull(sum(GREEN_BAND_RPM_SCORE),0) as GREEN_BAND_RPM_SCORE,isnull(sum(LOW_RPM_SCORE),0) as LOW_RPM_SCORE,isnull(sum(HIGH_RPM_SCORE),0) as HIGH_RPM_SCORE "+
	" from AMS.dbo.TRIP_DRIVER_DETAILS where CUSTOMER_ID=? and DRIVER_ID != 0 and END_DATE between DATEADD(mi,-?,?) and DATEADD(mi,-?,?) # ";
	
	public static final String GET_TOP_DRIVERS = "Select top 5 isnull(OVERALL_SCORE,0) as OVERALL_SCORE,isnull(OVERALL_RANK,0) as OVERALL_RANK," +
	" isnull(SUM(FINAL_SCORE*CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0))/SUM(CONVERT(NUMERIC(18, 2), " +
	" TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0)),0) as PERIOD_SCORE,isnull(d.Fullname,'')+' ('+isnull(d.EmployeeID,'')+')' as NAME " +
	" from AMS.dbo.TRIP_DRIVER_DETAILS a " +
	" LEFT OUTER join Driver_Master d on d.Driver_id=a.DRIVER_ID and Client_id=CUSTOMER_ID " +
	" where SYSTEM_ID=? and CUSTOMER_ID=? and DRIVER_ID != 0 and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) #" +
	" group by DRIVER_ID,d.EmployeeID,d.Fullname,d.LastName,OVERALL_SCORE,OVERALL_RANK order by PERIOD_SCORE" ;

	public static final String GET_DRIVER_PER_DETAILS = "select DRIVER_ID,isnull(SUM(FINAL_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as TOTAL_SCORE," +
	" isnull(d.EmployeeID,'') as EMP_ID,isnull(d.Fullname,'') as NAME,isnull(SUM(HB_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as HB_SCORE," +
	" isnull(SUM(HA_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as HA_SCORE,isnull(SUM(HC_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as HC_SCORE," +
	" isnull(SUM(OVER_REVV_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as OVER_REVV_SCORE,isnull(SUM(OVER_SPEED_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as OVER_SPEED_SCORE," +
	" isnull(SUM(IDLE_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as IDLE_SCORE,isnull(SUM(UNSCHDL_STOPPAGE_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as UNSCHDL_STOPPAGE_SCORE," +
	" isnull(SUM(GREEN_BAND_SPEED_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as GREEN_BAND_SPEED_SCORE,isnull(SUM(IDLE_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as IDLE_SCORE," +
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (FREE_WHEEL_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as FREE_WHEEL_SCORE,"+
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (GREEN_BAND_RPM_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as GREEN_BAND_RPM_SCORE,"+
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (LOW_RPM_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as LOW_RPM_SCORE,"+
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (HIGH_RPM_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as HIGH_RPM_SCORE,"+
	" count(DRIVER_ID) as NO_OF_TRIPS,isnull(sum(TOTAL_DISTANCE),0) as TOTAL_DISTANCE,isnull(sum(TOTAL_DURATION),0) as TOTAL_DURATION,0 as OVERALL_PERC," +
	" isnull(avg(AVG_SPEED_EXCL_STOPPAGE),0) as AVG_SPEED,isnull(cast(cast(AVG(CASE WHEN (MILEAGE>0 and MILEAGE < 10) THEN MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as AVG_MILAGE,"+
	" isnull(cast(cast(AVG(CASE WHEN (OBD_MILEAGE>0 and OBD_MILEAGE<10) THEN OBD_MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as AVG_OBD_MILAGE,"+ 	  
	" cast((isnull(sum(case when isNull(OTP_STATUS,0)='ontime'  then 1 else 0 end),0)/cast(count(DRIVER_ID) as float))*100 as numeric(18,2)) as ON_TIME_PERFORMANCE"+ 
	" from AMS.dbo.TRIP_DRIVER_DETAILS a "+
	" LEFT OUTER join AMS.dbo.Driver_Master d on d.Driver_id=a.DRIVER_ID and Client_id=CUSTOMER_ID "+
	" where SYSTEM_ID=? and CUSTOMER_ID=? and DRIVER_ID != 0 and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) # "+
	" group by DRIVER_ID,d.EmployeeID,d.Fullname order by d.Fullname";
	
	public static final String GET_DRIVER_SUMMARY= "select DRIVER_ID,isnull(d.EmployeeID,'') as EMP_ID,isnull(d.Fullname,'')+' '+isnull(d.LastName,'') as NAME," +
	" isnull(SUM(FINAL_SCORE * TOTAL_DURATION) / SUM(TOTAL_DURATION),0) as TOTAL_SCORE,isnull(SUM(UNSCHDL_STOPPAGE_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as PERFORMANCE_SCORE,"+
	" (isnull(SUM(HB_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) + isnull(SUM(HA_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) + isnull(SUM(HC_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) + "+
	" isnull(SUM(OVER_SPEED_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0)) as SAFETY_SCORE," +
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (FREE_WHEEL_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as FREE_WHEEL_SCORE,"+ 
	" isnull(SUM(OVER_REVV_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as OVER_REVV_SCORE,isnull(SUM(IDLE_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as IDLE_SCORE,"+
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (GREEN_BAND_RPM_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as GREEN_BAND_RPM_SCORE,"+
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (LOW_RPM_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as LOW_RPM_SCORE,"+
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (HIGH_RPM_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as HIGH_RPM_SCORE,"+
	" isnull(sum(MILEAGE),0) as AVG_MILAGE,count(DRIVER_ID) as NO_OF_TRIPS,isnull(SUM(GREEN_BAND_SPEED_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as GREEN_BAND_SPEED_SCORE"+  
	 " from AMS.dbo.TRIP_DRIVER_DETAILS a  " +
	 " LEFT OUTER join AMS.dbo.Driver_Master d on d.Driver_id=a.DRIVER_ID and Client_id=CUSTOMER_ID   " +
	 " where SYSTEM_ID=? and CUSTOMER_ID=? and DRIVER_ID != 0 and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) # " +
	 " group by DRIVER_ID,d.EmployeeID,d.Fullname,d.LastName order by d.Fullname" ;
	
	public static final String GET_MAX_AVG_MIN_ALL_DRIVERS=" select  isnull(max(HB_SCORE),0) as MAX_HB_SCORE,isnull(max(HA_SCORE),0) as MAX_HA_SCORE, "+ 
	" isnull(max(HC_SCORE),0) as MAX_HC_SCORE,isnull(max(OVER_REVV_SCORE),0) as MAX_OVER_REVV_SCORE,isnull(max(OVER_SPEED_SCORE),0) as MAX_OVER_SPEED_SCORE,"+ 
	" isnull(max(IDLE_SCORE),0) as MAX_IDLE_SCORE,isnull(max(UNSCHDL_STOPPAGE_SCORE),0) as MAX_UNSCHDL_STOPPAGE_SCORE, "+ 
	" isnull(max(GREEN_BAND_SPEED_SCORE),0) as MAX_GREEN_BAND_SPEED_SCORE,isnull(max(GREEN_BAND_RPM_SCORE),0) as MAX_GREEN_BAND_RPM_SCORE,isnull(max(LOW_RPM_SCORE),0) as MAX_LOW_RPM_SCORE,"+ 
	" isnull(max(HIGH_RPM_SCORE),0) as MAX_HIGH_RPM_SCORE,isnull(max(FREE_WHEEL_SCORE),0) as MAX_FREE_WHEEL_SCORE, "+ 
	" isnull(min(HB_SCORE),0) as MIN_HB_SCORE,isnull(min(HA_SCORE),0) as MIN_HA_SCORE, "+ 
	" isnull(min(HC_SCORE),0) as MIN_HC_SCORE,isnull(min(OVER_REVV_SCORE),0) as MIN_OVER_REVV_SCORE,isnull(min(OVER_SPEED_SCORE),0) as MIN_OVER_SPEED_SCORE,"+ 
	" isnull(min(IDLE_SCORE),0) as MIN_IDLE_SCORE,isnull(min(UNSCHDL_STOPPAGE_SCORE),0) as MIN_UNSCHDL_STOPPAGE_SCORE, "+ 
	" isnull(min(GREEN_BAND_SPEED_SCORE),0) as MIN_GREEN_BAND_SPEED_SCORE,isnull(min(GREEN_BAND_RPM_SCORE),0) as MIN_GREEN_BAND_RPM_SCORE,isnull(min(LOW_RPM_SCORE),0) as MIN_LOW_RPM_SCORE, "+ 
	" isnull(min(HIGH_RPM_SCORE),0) as MIN_HIGH_RPM_SCORE,isnull(min(FREE_WHEEL_SCORE),0) as MIN_FREE_WHEEL_SCORE, "+ 
	" isnull(avg(HB_SCORE),0) as AVG_HB_SCORE,isnull(avg(HA_SCORE),0) as AVG_HA_SCORE, "+ 
	" isnull(avg(HC_SCORE),0) as AVG_HC_SCORE,isnull(avg(OVER_REVV_SCORE),0) as AVG_OVER_REVV_SCORE,isnull(avg(OVER_SPEED_SCORE),0) as AVG_OVER_SPEED_SCORE,"+ 
	" isnull(avg(IDLE_SCORE),0) as AVG_IDLE_SCORE,isnull(avg(UNSCHDL_STOPPAGE_SCORE),0) as AVG_UNSCHDL_STOPPAGE_SCORE, "+ 
	" isnull(avg(GREEN_BAND_SPEED_SCORE),0) as AVG_GREEN_BAND_SPEED_SCORE,isnull(avg(GREEN_BAND_RPM_SCORE),0) as AVG_GREEN_BAND_RPM_SCORE,isnull(avg(LOW_RPM_SCORE),0) as AVG_LOW_RPM_SCORE, "+ 
	" isnull(avg(HIGH_RPM_SCORE),0) as AVG_HIGH_RPM_SCORE,isnull(avg(FREE_WHEEL_SCORE),0) as AVG_FREE_WHEEL_SCORE "+ 
	" from ( "+ 
	" select DRIVER_ID,isnull(avg(HB_SCORE),0) as HB_SCORE,isnull(avg(HA_SCORE),0) as HA_SCORE, "+ 
	" isnull(avg(HC_SCORE),0) as HC_SCORE,isnull(avg(OVER_REVV_SCORE),0) as OVER_REVV_SCORE,isnull(avg(OVER_SPEED_SCORE),0) as OVER_SPEED_SCORE,"+ 
	" isnull(avg(IDLE_SCORE),0) as IDLE_SCORE,isnull(avg(UNSCHDL_STOPPAGE_SCORE),0) as UNSCHDL_STOPPAGE_SCORE, "+ 
	" isnull(avg(GREEN_BAND_SPEED_SCORE),0) as GREEN_BAND_SPEED_SCORE,isnull(avg(GREEN_BAND_RPM_SCORE),0) as GREEN_BAND_RPM_SCORE,isnull(avg(LOW_RPM_SCORE),0) as LOW_RPM_SCORE, "+ 
	" isnull(avg(HIGH_RPM_SCORE),0) as HIGH_RPM_SCORE,isnull(avg(FREE_WHEEL_SCORE),0) as FREE_WHEEL_SCORE  "+ 
	" from AMS.dbo.TRIP_DRIVER_DETAILS a  "+ 
	" LEFT OUTER join AMS.dbo.Driver_Master d on d.Driver_id=a.DRIVER_ID and Client_id=CUSTOMER_ID "+ 
	" where SYSTEM_ID=? and CUSTOMER_ID=?   and (START_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) or END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?)) "+ 
	" group by DRIVER_ID,d.EmployeeID,d.Fullname,d.LastName)r ";

	public static final String GET_DATA_TO_COLUMN_CHART = " select isnull(avg(HB_SCORE),0) as HB_SCORE,isnull(avg(HA_SCORE),0) as HA_SCORE,   " +
	" isnull(avg(HC_SCORE),0) as HC_SCORE,isnull(avg(OVER_REVV_SCORE),0) as OVER_REVV_SCORE,isnull(avg(OVER_SPEED_SCORE),0) as OVER_SPEED_SCORE,  " +
	" isnull(avg(IDLE_SCORE),0) as IDLE_SCORE,isnull(avg(UNSCHDL_STOPPAGE_SCORE),0) as UNSCHDL_STOPPAGE_SCORE,   " +
	" isnull(avg(GREEN_BAND_SPEED_SCORE),0) as GREEN_BAND_SPEED_SCORE,isnull(avg(GREEN_BAND_RPM_SCORE),0) as GREEN_BAND_RPM_SCORE,isnull(avg(LOW_RPM_SCORE),0) as LOW_RPM_SCORE,   " +
	" isnull(avg(HIGH_RPM_SCORE),0) as HIGH_RPM_SCORE,isnull(avg(FREE_WHEEL_SCORE),0) as FREE_WHEEL_SCORE " +
	" from AMS.dbo.TRIP_DRIVER_DETAILS a   " +
	" LEFT OUTER join AMS.dbo.Driver_Master d on d.Driver_id=a.DRIVER_ID and Client_id=CUSTOMER_ID   " +
	" where SYSTEM_ID=? and CUSTOMER_ID=? and DRIVER_ID=?  and (START_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) or END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?))" +
	" group by DRIVER_ID,d.EmployeeID,d.Fullname,d.LastName order by d.LastName desc " ;

	public static final String GET_HUMIDITY = " select isnull(dateadd(mi,?,GMT),'') as GMT,ANALOG_INPUT_1 as Humidity from gpsdata_history_latest where REGISTRATION_NO=? ";
		
	public static final String INSERT_CUSTOMER_DETAILS = " insert into AMS.dbo.TRIP_CUSTOMER_DETAILS (NAME, SYSTEM_ID, CUSTOMER_ID, INSERTED_DATETIME, CONTACT_PERSON, CONTACT_NO, CONTACT_ADDRESS, CUSTOMER_REFERENCE_ID,STATUS,TYPE,CONTACT_NO2) values "+
	" (?,?,?,getutcdate(),?,?,?,?,?,?,?) " ;	

	public static final String GET_CUSTOMER_TRIP_DETAILS= "select ID, isNull(NAME,'') as NAME, SYSTEM_ID, CUSTOMER_ID, INSERTED_DATETIME, isNull(CONTACT_PERSON,'') as CONTACT_PERSON, isNull(CONTACT_NO,'') as CONTACT_NO,isNull(CONTACT_NO2,'') as CONTACT_NO2, isNull(CONTACT_ADDRESS,'') as CONTACT_ADDRESS, isNull(CUSTOMER_REFERENCE_ID,'') as CUSTOMER_REFERENCE_ID,isNull(TYPE,'') as TYPE,isnull(STATUS,'Active')as STATUS from AMS.dbo.TRIP_CUSTOMER_DETAILS"+
														  " where SYSTEM_ID=? AND CUSTOMER_ID=?";
	   
	public static final String UPDATE_CUSTOMER_TRIP_DETAILS ="update AMS.dbo.TRIP_CUSTOMER_DETAILS set NAME=?, CONTACT_PERSON=?, CONTACT_NO=?, CONTACT_ADDRESS=?, CUSTOMER_REFERENCE_ID=?,STATUS=?,TYPE=?, INSERTED_DATETIME=getdate(),CONTACT_NO2=? where ID=?";

	public static final String GET_USERS_FOR_CUSTOMER ="select u.USER_ID from dbo.TRIP_CUSTOMER_DETAILS c left join dbo.USER_TRIP_CUST_ASSOC u on c.ID=u.TRIP_CUSTOMER_ID where c.ID=?";

	public static final String UPDATE_Users_STATUS ="update AMS.dbo.Users set Status=? where User_id=? and System_id=? and Client_id=?";
	
	public static final String UPDATE_USERS_STATUS ="update ADMINISTRATOR.dbo.USERS set STATUS=? where USER_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String CHECK_ZANG_RECORD_EXIST = "select VALUE from LOOKUP_DETAILS where VERTICAL= 'RS232_LABEL'";

	public static final String CHECK_IO_TYPE_LIST = "select VALUE from LOOKUP_DETAILS where VERTICAL= ? order by ORDER_OF_DISPLAY";
	
	public static final String GET_REMARK_ISSUES = "select VALUE from AMS.dbo.LOOKUP_DETAILS where VERTICAL='ISSUE_TYPE' order by TYPE";
	
	public static final String GET_REMARK_SUBISSUES = "SELECT A.VALUE AS ISSUE, B.VALUE AS SUBISSUE FROM LOOKUP_DETAILS A, LOOKUP_DETAILS B WHERE " +
	"A.VALUE =? AND A.TYPE=B.TYPE AND B.VERTICAL='SUB-ISSUE_TYPE' and A.VERTICAL='ISSUE_TYPE' ORDER BY A.ORDER_OF_DISPLAY";
	
	public static final String INSERT_REMARK_DETAILS = "insert into AMS.dbo.TRIP_REMARKS_DETAILS (CUSTOMER_NAME,CUSTOMER_TYPE,REMARKS,LOCATION_OF_DELAY,STARTDATE,ENDDATE,DELAYTIME,ISSUETYPE,SUBISSUE_TYPE,SYSTEM_ID,USER_ID,TRIP_ID,REASON,INSERTED_DATETIME) values "+
	" (?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate()) " ;
	
	public static final String UPDATE_REMARK_DETAILS = "update AMS.dbo.TRIP_REMARKS_DETAILS set CUSTOMER_NAME=?,CUSTOMER_TYPE=?,REMARKS=?,LOCATION_OF_DELAY=?,STARTDATE=?,ENDDATE=?,DELAYTIME=?,ISSUETYPE=?,SUBISSUE_TYPE=?,INSERTED_DATETIME=getutcdate() where TRIP_ID=? and ID=?";
	
	public static final String GET_TRIP_REMARKS_DETAILS = " select isnull(FIRST_NAME+' '+LAST_NAME,'') as USER_NAME,isnull(CUSTOMER_NAME,'') as CUSTOMER_NAME,isnull(CUSTOMER_TYPE,'') as CUSTOMER_TYPE,dateadd(mi,?,INSERTED_DATETIME) as INSERTEDDATE,isnull(REASON,'') as REASON,isnull(REMARKS,'') as REMARKS," +
	"isnull(LOCATION_OF_DELAY,'') as LOCATION_DELAY,isnull(STARTDATE,'') as STARTDATE,isnull(ENDDATE,'') as ENDDATE,isnull(DELAYTIME,'') as DELAYTIME,isnull(ISSUETYPE,'') as ISSUETYPE,isnull(SUBISSUE_TYPE,'') as SUBISSUE_TYPE,ID, TRIP_ID"+
	" from AMS.dbo.TRIP_REMARKS_DETAILS a left outer join ADMINISTRATOR.dbo.USERS u on u.USER_ID=a.USER_ID and u.SYSTEM_ID=a.SYSTEM_ID where TRIP_ID=? # order by INSERTED_DATETIME DESC" ;
	
	public static final String TRIP_ID_EXISTS = "select * from AMS.dbo.TRIP_REMARKS_DETAILS where TRIP_ID=? and SYSTEM_ID=? #" ;
	
	public static final String GET_SMART_HUB_BUFFERS = "select isnull(Standard_Duration,0) as DETENTION,NAME,LONGITUDE,LATITUDE,RADIUS,IMAGE,isNull(HUBID,0) as HUBID from LOCATION where  RADIUS>0 and CLIENTID=? and SYSTEMID=? and OPERATION_ID in (32) and TRIP_CUSTOMER_ID= ? " +
			" union all" +
			" select isnull(Standard_Duration,0) as DETENTION,NAME,LONGITUDE,LATITUDE,RADIUS,IMAGE,isNull(HUBID,0) as HUBID from LOCATION where  RADIUS>0 and CLIENTID=? and SYSTEMID=? and OPERATION_ID in (33) and TRIP_CUSTOMER_ID= 0 ";

	public static final String GET_SMART_HUB_POLYGONS = " select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE,b.LATITUDE as LAT,b.LONGITUDE as LNG from dbo.POLYGON_LOCATION_DETAILS a left outer join LOCATION_ZONE b on a.HUBID=b.HUBID where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and b.OPERATION_ID in (32) and TRIP_CUSTOMER_ID= ?"+ 
														" union all "+
														" select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE,b.LATITUDE,b.LONGITUDE from dbo.POLYGON_LOCATION_DETAILS a left outer join LOCATION_ZONE b on a.HUBID=b.HUBID where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and b.OPERATION_ID in (33) and TRIP_CUSTOMER_ID= 0" +
														" order by a.HUBID,a.SEQUENCE_ID";

	public static final String GET_SMART_HUB_BUFFERS_FOR_TRIPCUST = "select isnull(Standard_Duration,0) as DETENTION,NAME,LONGITUDE,LATITUDE,RADIUS,IMAGE,isNull(HUBID,0) as HUBID,TRIP_CUSTOMER_ID from LOCATION where  RADIUS>0 and CLIENTID=? and SYSTEMID=? and OPERATION_ID in (32) and TRIP_CUSTOMER_ID IN(#) " +
	" union all" +
	" select isnull(Standard_Duration,0) as DETENTION,NAME,LONGITUDE,LATITUDE,RADIUS,IMAGE,isNull(HUBID,0) as HUBID,TRIP_CUSTOMER_ID from LOCATION where  RADIUS>0 and CLIENTID=? and SYSTEMID=? and OPERATION_ID in (33) and TRIP_CUSTOMER_ID= 0 ";

	public static final String GET_SMART_HUB_POLYGONS_FOR_TRIPCUST = " select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE,b.LATITUDE as LAT,b.LONGITUDE as LNG,TRIP_CUSTOMER_ID from dbo.POLYGON_LOCATION_DETAILS a left outer join LOCATION_ZONE b on a.HUBID=b.HUBID where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and b.OPERATION_ID in (32) and TRIP_CUSTOMER_ID IN(#)"+ 
												" union all "+
												" select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE,b.LATITUDE,b.LONGITUDE,TRIP_CUSTOMER_ID from dbo.POLYGON_LOCATION_DETAILS a left outer join LOCATION_ZONE b on a.HUBID=b.HUBID where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and b.OPERATION_ID in (33) and TRIP_CUSTOMER_ID= 0" +
												" order by a.HUBID,a.SEQUENCE_ID";
	
	public static final String GET_CHECKPOINT_BUFFERS = "select NAME,LONGITUDE,LATITUDE,RADIUS,IMAGE,isNull(HUBID,0) as HUBID from LOCATION where CLIENTID=? and SYSTEMID=? and OPERATION_ID in (27,28,29,30,31) and RADIUS > 0 and TRIP_CUSTOMER_ID= ? ";

	public static final String GET_CHECKPOINT_POLYGONS = "select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE from dbo.POLYGON_LOCATION_DETAILS a left outer join LOCATION_ZONE b on a.HUBID=b.HUBID where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and b.OPERATION_ID in (27,28,29,30,31) and TRIP_CUSTOMER_ID= ? order by a.HUBID,a.SEQUENCE_ID";

	public static final String GET_LEG_NAMES = " select lm.DISTANCE,Standard_Duration,lm.TAT,lm.DESTINATION as HUB_ID,LEG_NAME,lm.ID from AMS.dbo.LEG_MASTER lm " +
	" inner join AMS.dbo.LEG_DETAILS ld on ld.LEG_ID = lm.ID and ld.TYPE='SOURCE' " +
	"  inner join  AMS.dbo.LOCATION lz on lz.HUBID=lm.SOURCE " +
	" where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_CUST_ID=? and lm.STATUS='Active'" ;
	
	public static final String GET_LEG_MASTER_DETAILS = " select (select count(*) from TRIP_ROUTE_DETAILS ld inner join TRIP_ROUTE_MASTER lmr on lmr.ID=ld.ROUTE_ID where STATUS='Active' and ld.LEG_ID=lm.ID) as ROUTE_COUNT,lz.NAME as SOURCE,lz1.NAME as DESTINATION,lm.ID as ID ,LEG_NAME,DISTANCE,AVG_SPEED,TAT, lm.STATUS, tcd.NAME as CUST_NAME from AMS.dbo.LEG_MASTER lm " +
	" inner join AMS.dbo.LOCATION lz on lz.HUBID=lm.SOURCE " +
    " inner join AMS.dbo.LOCATION lz1 on lz1.HUBID=lm.DESTINATION " +
    " inner join AMS.dbo.TRIP_CUSTOMER_DETAILS tcd on tcd.ID = lm.TRIP_CUST_ID " +
	" where  lm.SYSTEM_ID=? AND lm.CUSTOMER_ID=? # order by lm.TRIP_CUST_ID,lm.ID desc " ;
	
	public static final String INSERT_LEG_MASTER_DETAILS = "insert into AMS.dbo.LEG_MASTER (LEG_NAME,TRIP_CUST_ID,DISTANCE,AVG_SPEED,TAT,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,STATUS,INSERTED_DATETIME,SOURCE,DESTINATION) values "+
	" (?,?,?,?,?,?,?,?,?,getutcdate(),?,?)";

	public static final String INSERT_LEG_POINTS = " insert into AMS.dbo.LEG_DETAILS (LEG_ID,ROUTE_SEGMENT,ROUTE_SEQUENCE,LATITUDE,LONGITUDE,HUB_ID,TYPE,RADIUS,DETENTION,DURATION,CHECKPOINT_SEQUENCE,SEQUENCE_DISTANCE)" +
	" values (?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public static final String GET_LATLONGS_FOR_LEG = " select (select max(CHECKPOINT_SEQUENCE) from AMS.dbo.LEG_DETAILS where LEG_ID=? and TYPE='DRAGPOINT') as MAX_CHECK," +
	" CHECKPOINT_SEQUENCE,ROUTE_SEQUENCE,ld.LATITUDE as LATITUDE,(select max(ROUTE_SEQUENCE) from AMS.dbo.LEG_DETAILS where LEG_ID=? and TYPE='DRAGPOINT') as MAX_DRAG,"+
	" ld.LONGITUDE as LONGITUDE,ld.TYPE as TYPE,ld.HUB_ID as HUB_ID from AMS.dbo.LEG_DETAILS ld " +
	" left outer join AMS.dbo.LOCATION lz on lz.HUBID=ld.HUB_ID " +
	" where LEG_ID=? and ld.TYPE!=''" ;

	public static final String DELETE_LEG_DETAILS = " delete from AMS.dbo.LEG_DETAILS where LEG_ID=?";

	public static final String UPDATE_LEG_MASTER_DETAILS = "Update AMS.dbo.LEG_MASTER set LEG_NAME=?,DISTANCE=?,AVG_SPEED=?,TAT=?,SOURCE=?,DESTINATION=? where ID=?";
	
	public static final String GET_ROUTE_MASTER_DETAILS = " select *,tcd.NAME as CUST_NAME,isnull(RADIUS,0) as RADIUS,(select count(*) from TRACK_TRIP_DETAILS " +
	" where tm.ID=ROUTE_ID and STATUS='OPEN') as COUNT from AMS.dbo.TRIP_ROUTE_MASTER tm " +
	" inner join AMS.dbo.TRIP_CUSTOMER_DETAILS tcd on tcd.ID = tm.TRIP_CUST_ID " +
	" where tm.SYSTEM_ID=? AND tm.CUSTOMER_ID=? # order by tm.TRIP_CUST_ID,tm.ID desc "  ;

	public static final String UPDATE_ROUTE_MASTER_DETAILS = "Update AMS.dbo.TRIP_ROUTE_MASTER set ROUTE_NAME=?,DISTANCE=?,ROUTE_KEY=?,TAT=?,RADIUS=? where ID=?";

	public static final String DELETE_ROUTE_DETAILS = "  delete from AMS.dbo.TRIP_ROUTE_DETAILS where ROUTE_ID=? ";

	public static final String INSERT_ROUTE_MASTER_DETAILS = "insert into AMS.dbo.TRIP_ROUTE_MASTER (ROUTE_NAME,ROUTE_KEY,TAT,DISTANCE,STATUS,SYSTEM_ID,CUSTOMER_ID,TRIP_CUST_ID,INSERTED_BY,INSERTED_DATETIME,RADIUS)" +
	" values (?,?,?,?,?,?,?,?,?,getutcdate(),?)" ;

	public static final String INSERT_ROUTE_POINTS = " insert into AMS.dbo.TRIP_ROUTE_DETAILS (ROUTE_ID,LEG_ID,AVG_SPEED,TAT,DISTANCE,LEG_SEQUENCE,SOURCE_HUB,DESTINATION_HUB,DETENTION_TIME)" +
	" values (?,?,?,?,?,?,?,?,?)" ;
	
	public static final String GET_LEG_DETAILS = "Select Standard_Duration,* from  AMS.dbo.LEG_MASTER lm " +
	" inner join AMS.dbo.LOCATION lz on lz.HUBID=lm.SOURCE " +
	" where lm.ID=? ";

	public static final String UPDATE_STATUS = " update AMS.dbo.LEG_MASTER SET STATUS=? WHERE ID=? ";
	
	public static final String UPDATE_LEG_STATUS_OF_A_ROUTE = " update AMS.dbo.LEG_MASTER SET STATUS=? where ID in (select LEG_ID from AMS.dbo.TRIP_ROUTE_DETAILS WHERE ROUTE_ID=?) ";
	
	public static final String UPDATE_STATUS_FOR_ROUTE = " update AMS.dbo.TRIP_ROUTE_MASTER SET STATUS=? WHERE ID=? ";
	
	public static final String GET_SOURCE_DESTINATION_LEG = " select HUBID,lz.NAME,(lz.NAME+'-'+isnull(tcd.NAME,'')) as FULLHUBNAME,LATITUDE,LONGITUDE,RADIUS,isnull(Standard_Duration,0) as DETENTION,(case when datalength(lz.ADDRESS)=0 then lz.NAME else isnull(lz.NAME+' : '+lz.ADDRESS,lz.NAME) end) as HUB_ADDRESS from AMS.dbo.LOCATION_ZONE lz " +
			" left outer join dbo.TRIP_CUSTOMER_DETAILS tcd on tcd.SYSTEM_ID = lz.SYSTEMID and tcd.ID = lz.TRIP_CUSTOMER_ID " +
			" where CLIENTID=? and SYSTEMID=? and OPERATION_ID in (32) and (RADIUS >0 or RADIUS=-1) # "+ // and TRIP_CUSTOMER_ID = ? 
			" union all " +
			" select lz.HUBID,lz.NAME,lz.NAME  as FULLHUBNAME,lz.LATITUDE,lz.LONGITUDE,lz.RADIUS,isnull(lz.Standard_Duration,0) as DETENTION,(case when datalength(lz.ADDRESS)=0 then lz.NAME else isnull(lz.NAME+' : '+lz.ADDRESS,lz.NAME) end) as HUB_ADDRESS  from AMS.dbo.LOCATION_ZONE lz " +
			" where CLIENTID=? and SYSTEMID=? and OPERATION_ID in (33 $) and (RADIUS >0 or RADIUS=-1) and TRIP_CUSTOMER_ID = 0 ";

	public static final String GET_CHECKPOINT_LEG = " select HUBID,NAME,LATITUDE,LONGITUDE,RADIUS,isnull(Standard_Duration,0) as DETENTION,(case when datalength(ADDRESS)=0 then NAME else isnull(NAME+' : '+ ADDRESS ,NAME) end) as HUB_ADDRESS from AMS.dbo.LOCATION_ZONE where CLIENTID=? and SYSTEMID=? and OPERATION_ID in (27,28,29,30,31) and (RADIUS >0 or RADIUS=-1) and TRIP_CUSTOMER_ID= 0 ";
	
	public static final String GET_TRIP_NAME_FOR_OBD = " select VehicleAlias,TRIP_ID,(isnull(ORDER_ID,'')+'-('+isnull(SHIPMENT_ID,'')+')') as TRIP_NAME,ASSET_NUMBER,isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as STD, " +
	   " (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as END_DATE, " +
	   " isnull(vm.ModelName,'') as MAKE from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	   " inner join AMS.dbo.tblVehicleMaster c on td.ASSET_NUMBER=c.VehicleNo " +
	   " left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model " +
	   " where SYSTEM_ID=? AND CUSTOMER_ID=? " ;
	
	public static final String GET_LATLONGS_FOR_ROUTE = "select LEG_ID,ROUTE_SEQUENCE,ld.LATITUDE as LATITUDE,ROUTE_SEGMENT,TAT,LEG_NAME, " +
    " ld.LONGITUDE as LONGITUDE,ld.TYPE as TYPE,ld.HUB_ID as HUB_ID, CHECKPOINT_SEQUENCE, isnull(DETENTION,0) as DETENTION " +
    " ,(case when datalength(lz.ADDRESS)=0 then lz.NAME else isnull(lz.NAME+' : '+lz.ADDRESS,isnull(lz.NAME,'')) end) as HUB_ADDRESS  " +
    " from AMS.dbo.LEG_DETAILS ld   " +
    " inner join LEG_MASTER lm on lm.ID=ld.LEG_ID "+
    " left outer join LOCATION_ZONE lz on lz.HUBID=ld.HUB_ID and lm.SYSTEM_ID = lz.SYSTEMID and lm.CUSTOMER_ID = lz.CLIENTID "+
    " where ld.TYPE!='' and ld.TYPE!='DRAGPOINT' and LEG_ID = ? order by LEG_ID,ROUTE_SEQUENCE,ROUTE_SEGMENT ";
	
	public static final String GET_ROUTE_LATLONGS = "select LEG_ID,ROUTE_SEQUENCE,lz.LATITUDE as LATITUDE,ROUTE_SEGMENT, " +
    " lz.LONGITUDE as LONGITUDE,ld.TYPE as TYPE,ld.HUB_ID as HUB_ID from AMS.dbo.LEG_DETAILS ld   " +
    " left outer join AMS.dbo.LOCATION_ZONE lz on lz.HUBID=ld.HUB_ID   " +
    " where ld.TYPE!='' and ld.LEG_ID=? order by LEG_ID,ROUTE_SEQUENCE,ROUTE_SEGMENT ";

	public static final String GET_LEG_IDS = "select * from AMS.dbo.TRIP_ROUTE_DETAILS where ROUTE_ID=? ";
		
	public static final String INSERT_INTO_USER_CUSTOMER_ASSOCIATION=" insert into dbo.USER_TRIP_CUST_ASSOC(USER_ID,CUSTOMER_ID,SYSTEM_ID,INSERTED_TIME,ASSOCIATED_BY,TRIP_CUSTOMER_ID) values (?,?,?,getutcdate(),?,?) ";

	public static final String CHECK_IF_PRESENT=" select * from dbo.USER_TRIP_CUST_ASSOC where USER_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? and TRIP_CUSTOMER_ID=? ";

	public static final String GET_ASSOCIATION_DATA_FOR_USER=" select c.NAME as CUSTOMER_NAME, c.CUSTOMER_ID,c.ID from dbo.USER_TRIP_CUST_ASSOC u "+
	"  inner join dbo.TRIP_CUSTOMER_DETAILS c on c.CUSTOMER_ID = u.CUSTOMER_ID and  c.ID = u.TRIP_CUSTOMER_ID "+
	"  where u.USER_ID=? and u.SYSTEM_ID=? and c.CUSTOMER_ID=? ";

	public static final String GET_ASSOCIATION_DATA_FOR_LTSP_USERS="  select c.NAME as CUSTOMER_NAME, c.CUSTOMER_ID, c.ID as ID from dbo.USER_TRIP_CUST_ASSOC u "+
	" 	inner join dbo.TRIP_CUSTOMER_DETAILS c on c.ID = u.TRIP_CUSTOMER_ID " +
	"  where u.USER_ID=? and u.SYSTEM_ID=? ";

	public static final String GET_NON_ASSOCIATION_DATA_FOR_USER=" select c.NAME as CUSTOMER_NAME,c.CUSTOMER_ID,c.ID from dbo.TRIP_CUSTOMER_DETAILS c "+
	"	where c.CUSTOMER_ID =? and c.SYSTEM_ID=? " + 
	"	and ID not in (select TRIP_CUSTOMER_ID from dbo.USER_TRIP_CUST_ASSOC where USER_ID=? and SYSTEM_ID=?) ";

	public static final String GET_NON_ASSOCIATION_DATA_FOR_LTSP_USERS="  select c.NAME as CUSTOMER_NAME,c.CUSTOMER_ID,c.ID as ID from dbo.TRIP_CUSTOMER_DETAILS c "+
	"	where c.SYSTEM_ID=? " + 
	"	and c.ID not in (select TRIP_CUSTOMER_ID from dbo.USER_TRIP_CUST_ASSOC where USER_ID=? and SYSTEM_ID=?) ";

	public static final String MOVE_DATA_TO_USER_CUSTOMER_ASSOCIATION_HISTORY=" insert into dbo.USER_TRIP_CUST_ASSOC_HIST(ID,USER_ID,CUSTOMER_ID,SYSTEM_ID,INSERTED_TIME,DISASSOCIATED_BY,DISASSOCIATED_TIME,ASSOCIATED_BY,TRIP_CUSTOMER_ID) "+
	" select ID,USER_ID,CUSTOMER_ID,SYSTEM_ID,INSERTED_TIME,?,getutcdate(),ASSOCIATED_BY,TRIP_CUSTOMER_ID from dbo.USER_TRIP_CUST_ASSOC "+
	" where USER_ID=? and SYSTEM_ID=? and TRIP_CUSTOMER_ID=? and CUSTOMER_ID=? ";


	public static final String DELETE_FROM_USER_CUSTOMER_ASSOCIATION=" delete from dbo.USER_TRIP_CUST_ASSOC where USER_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? and TRIP_CUSTOMER_ID=? ";
	
	public static final String INSERT_VEHICLES_FOR_MAINTENANCE = "insert into VEHICLE_MAINTENANCE_DETAILS (VEHICLE_NUMBER,START_DATE,REMARKS,SYSTEM_ID,CUSTOMER_ID,CREATED_BY,CREATED_DATE)" +
	" values (?,dateadd(mi,-?,?),?,?,?,?,getutcdate())";

	public static final String GET_VEHICLES_WHICH_ARE_NOT_ON_TRIP = "select REGISTRATION_NO from dbo.gpsdata_history_latest where System_id=? and CLIENTID=? " +
	" and REGISTRATION_NO in (select Vehicle_id from dbo.Vehicle_Status where Status_id=16)";	
	
	public static final String GET_VEHICLES_MAINTENANCE_DETAILS = "select ID,VEHICLE_NUMBER,isnull(dateadd(mi,?,START_DATE),'') as START_DATE,REMARKS,isnull(dateadd(mi,?,END_DATE),'') as END_DATE from dbo.VEHICLE_MAINTENANCE_DETAILS WHERE CUSTOMER_ID = ? and SYSTEM_ID = ? ORDER BY ID DESC ";
	
	public static final String CLOSE_VEHICLE_MAINTENANCE = " update dbo.VEHICLE_MAINTENANCE_DETAILS set END_DATE=dateadd(mi,-?,?),ENDED_BY=?,ENDED_DATE=getutcdate() where ID=? and VEHICLE_NUMBER = ? and SYSTEM_ID = ? and CUSTOMER_ID = ? " ;
	
	public static final String VEHICLE_VALIDATION = "select * from dbo.TRACK_TRIP_DETAILS where ASSET_NUMBER=? and ((TRIP_START_TIME between ? and getdate()) or (ACTUAL_TRIP_END_TIME between ? and getdate()))";

	public static final String GET_LEG_SEQUENCE = " select * from AMS.dbo.LEG_DETAILS where LEG_ID=? and TYPE IN ('CHECKPOINT','DRAGPOINT') " +
    " order by LEG_ID,ROUTE_SEQUENCE,ROUTE_SEGMENT " ;
	
	public static final String GET_LEG_CONCEPT="select isnull(LEG_CONCEPT, 'N') as legConcept from dbo.TRIP_SHEET_SETTING where SYSTEM_ID=? and CUSTOMER_ID=?";
	
	/*public static final String GET_TRIP_SUMMARY_REPORT_LEG_DETAILS="select LEG_NAME,isnull(lz.NAME,'') as SOURCE,lz1.NAME as DESTIANTION,isnull(dateadd(mi,?,STD),'') as STD,isnull(dateadd(mi,?,STA),'') as STA, " +
	" isnull(dateadd(mi,?,ACTUAL_ARRIVAL),'') as ATA,isnull(dateadd(mi,?,ACTUAL_DEPARTURE),'') as ATD," +
	" isnull(TOTAL_DISTANCE,0) as TOTAL_DISTANCE, " +
	" isnull(tl.AVG_SPEED,0) as AVG_SPEED,isnull(FUEL_CONSUMED,0) as FUEL_CONSUMED,isnull(MILEAGE,0) as MILEAGE,isnull(OBD_MILEAGE,0) as OBD_MILEAGE, " +
	" case when ACTUAL_ARRIVAL is null then " +
	" isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ISNULL(ACTUAL_ARRIVAL,getutcdate())),0) else isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ACTUAL_ARRIVAL),0)  end as TRAVEL_DURATION, "+
	" isnull(d.Fullname,'') as DRIVER1,isnull(d1.Fullname,'') as DRIVER2,isnull(dateadd(mi,?,ETA),'') as ETA " +
	" from TRIP_LEG_DETAILS tl " +
	" left outer join AMS.dbo.LEG_MASTER lm on lm.ID=tl.LEG_ID " +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=lm.SOURCE " +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz1 on lz1.HUBID=lm.DESTINATION " +
	" left outer join AMS.dbo.Driver_Master d on d.Driver_id=tl.DRIVER_1 " +
	" left outer join AMS.dbo.Driver_Master d1 on d1.Driver_id=tl.DRIVER_2 " +
	" where LEG_ID in (select LEG_ID from TRIP_ROUTE_DETAILS where ROUTE_ID =?) and TRIP_ID=? ";*/
	
	/*public static final String GET_TRIP_SUMMARY_REPORT_LEG_DETAILS = "select LEG_NAME,isnull(lz.NAME,'') as SOURCE,isnull(lz1.NAME,'') as DESTIANTION,isnull(dateadd(mi,?,STD),'') as STD," +
	" isnull(dateadd(mi,?,STA),'') as STA, isnull(dateadd(mi,?,ACTUAL_ARRIVAL),'') as ATA,isnull(dateadd(mi,?,ACTUAL_DEPARTURE),'') as ATD,isnull(tl.TOTAL_DISTANCE,0) as TOTAL_DISTANCE," +
	" isnull(tl.AVG_SPEED,0) as AVG_SPEED,isnull(case when tl.FUEL_CONSUMED > 0 then tl.FUEL_CONSUMED else 0 end,0) as FUEL_CONSUMED,isnull(case when (tl.MILEAGE > 0 and tl.MILEAGE < 10) then tl.MILEAGE else 0 end,0) as MILEAGE," +
	" isnull(case when (tl.OBD_MILEAGE > 0 and tl.OBD_MILEAGE < 10) then tl.OBD_MILEAGE else 0 end,0) as OBD_MILEAGE," +
	" case when ACTUAL_ARRIVAL is null then isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ISNULL(ACTUAL_ARRIVAL,getutcdate())),0) else isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ACTUAL_ARRIVAL),0)  end as TRAVEL_DURATION," +
	" isnull(d.Fullname,'') as DRIVER1,isnull(d1.Fullname,'') as DRIVER2,isnull(dateadd(mi,?,ETA),'') as ETA,isnull(sum(GREEN_BAND_SPEED_DUR),0) as SUM_GBSD ," +
	" isnull(sum(GREEN_BAND_RPM_DUR),0) as SUM_GBRD,isnull(sum(TOTAL_DURATION),0) as TOTAL_DURATION,isnull(sum(TOTAL_STOP_DURATION),0)as TOTAL_STOP_DURATION," +
	" isnull(sum(tdd.LOW_RPM_DUR),0) as LOW_RPM_DUR,isnull(sum(tdd.HIGH_RPM_DUR),0) as HIGH_RPM_DUR , isnull(sum(FREE_WHEEL_DUR),0) as SUM_FWD," +
	" isnull(tdd.GREEN_BAND_SPEED_PERC,0) as greenBandSpeedPerc,isnull(tdd.GREEN_RPM_PERC,0) as greenRPMPerc,isnull(d.Mobile,'') as DRIVER1_CONTACT,isnull(d1.Mobile,'') as DRIVER2_CONTACT,  " +
	" DATEDIFF(mi,STD, ACTUAL_DEPARTURE) as delayedDepartureATD_STD, "+
	" isnull(lm.TAT,0) as plannedTransitTime, "+
	" DATEDIFF(mi,ACTUAL_DEPARTURE, ACTUAL_ARRIVAL) as actualTransitTime"+
	" from TRIP_LEG_DETAILS tl" +
	" left outer join AMS.dbo.LEG_MASTER lm on lm.ID=tl.LEG_ID " +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=lm.SOURCE " +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz1 on lz1.HUBID=lm.DESTINATION" +
	" left outer join AMS.dbo.Driver_Master d on d.Driver_id=tl.DRIVER_1 and d.Client_id = lm.CUSTOMER_ID" +
	" left outer join AMS.dbo.Driver_Master d1 on d1.Driver_id=tl.DRIVER_2 and d1.Client_id = lm.CUSTOMER_ID" +
	" left outer join TRIP_DRIVER_DETAILS tdd on tl.TRIP_ID=tdd.TRIP_ID and tl.LEG_ID=tdd.LEG_ID" +
	" where  tl.TRIP_ID=? ";*/
	public static final String GET_TRIP_SUMMARY_REPORT_LEG_DETAILS = "select tl.LEG_ID,isnull(LEG_NAME,'') as LEG_NAME,isnull(lz.NAME,'') as SOURCE,isnull(lz1.NAME,'') as DESTIANTION,isnull(dateadd(mi,?,STD),'') as STD," +
	" isnull(dateadd(mi,?,STA),'') as STA, isnull(dateadd(mi,?,ACTUAL_ARRIVAL),'') as ATA,isnull(dateadd(mi,?,ACTUAL_DEPARTURE),'') as ATD,isnull(tl.TOTAL_DISTANCE,0) as TOTAL_DISTANCE," +
	" isnull(tl.AVG_SPEED,0) as AVG_SPEED,isnull(case when tl.FUEL_CONSUMED > 0 then tl.FUEL_CONSUMED else 0 end,0) as FUEL_CONSUMED,isnull(case when (tl.MILEAGE > 0 and tl.MILEAGE < 10) then tl.MILEAGE else 0 end,0) as MILEAGE," +
	" isnull(case when (tl.OBD_MILEAGE > 0 and tl.OBD_MILEAGE < 10) then tl.OBD_MILEAGE else 0 end,0) as OBD_MILEAGE," +
	" case when ACTUAL_ARRIVAL is null then isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ISNULL(ACTUAL_ARRIVAL,getutcdate())),0) else isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ACTUAL_ARRIVAL),0)  end as TRAVEL_DURATION," +
	" isnull(d.Fullname,'') as DRIVER1,isnull(d1.Fullname,'') as DRIVER2,isnull(dateadd(mi,?,ETA),'') as ETA,isnull(sum(GREEN_BAND_SPEED_DUR),0) as SUM_GBSD ," +
	" isnull(sum(GREEN_BAND_RPM_DUR),0) as SUM_GBRD,isnull(sum(TOTAL_DURATION),0) as TOTAL_DURATION,isnull(sum(TOTAL_STOP_DURATION),0)as TOTAL_STOP_DURATION," +
	" isnull(sum(tdd.LOW_RPM_DUR),0) as LOW_RPM_DUR,isnull(sum(tdd.HIGH_RPM_DUR),0) as HIGH_RPM_DUR , isnull(sum(FREE_WHEEL_DUR),0) as SUM_FWD," +
	" isnull(tdd.GREEN_BAND_SPEED_PERC,0) as greenBandSpeedPerc,isnull(tdd.GREEN_RPM_PERC,0) as greenRPMPerc,isnull(d.Mobile,'') as DRIVER1_CONTACT,isnull(d1.Mobile,'') as DRIVER2_CONTACT,  " +
	" isnull(DATEDIFF(mi,STD, ACTUAL_DEPARTURE),0) as delayedDepartureATD_STD, "+
	" isnull(lm.TAT,0) as plannedTransitTime, "+
	" isnull(DATEDIFF(mi,ACTUAL_DEPARTURE, ACTUAL_ARRIVAL),0) as actualTransitTime , lm.DISTANCE , "+
	" isnull(lz.Standard_Duration,'') as Standard_DurationS,isnull(lz1.Standard_Duration,'') as Standard_DurationD , "+
	" DATEADD(mi,lm.TAT,isnull(STA,'')) as STA_wrt_STD,DATEADD(mi,lm.TAT,isnull(ACTUAL_DEPARTURE,''))  as STA_wrt_ATD "+
	" from TRIP_LEG_DETAILS tl " +
	" left outer join AMS.dbo.LEG_MASTER lm on lm.ID=tl.LEG_ID " +
	" left outer join AMS.dbo.LOCATION lz on lz.HUBID=lm.SOURCE " +
	" left outer join AMS.dbo.LOCATION lz1 on lz1.HUBID=lm.DESTINATION " +
	" left outer join AMS.dbo.Driver_Master d on d.Driver_id=tl.DRIVER_1 and d.Client_id = lm.CUSTOMER_ID " +
	" left outer join AMS.dbo.Driver_Master d1 on d1.Driver_id=tl.DRIVER_2 and d1.Client_id = lm.CUSTOMER_ID " +
	" left outer join TRIP_DRIVER_DETAILS tdd on tl.TRIP_ID=tdd.TRIP_ID and tl.LEG_ID=tdd.LEG_ID " +
	" where  tl.TRIP_ID=? ";
	
	public static final String GET_LEG_DETAILS_SLA = "select td.ORDER_ID as tripNumber,tl.TRIP_ID as Tripno,tl.LEG_ID,isnull(LEG_NAME,'') as LEG_NAME,isnull(lz.NAME,'') as SOURCE,isnull(lz1.NAME,'') as DESTIANTION,isnull(dateadd(mi,?,STD),'') as STD," +
	" isnull(dateadd(mi,?,STA),'') as STA, isnull(dateadd(mi,?,ACTUAL_ARRIVAL),'') as ATA,isnull(dateadd(mi,?,ACTUAL_DEPARTURE),'') as ATD,isnull(tl.TOTAL_DISTANCE,0) as TOTAL_DISTANCE," +
	" isnull(tl.AVG_SPEED,0) as AVG_SPEED,isnull(case when tl.FUEL_CONSUMED > 0 then tl.FUEL_CONSUMED else 0 end,0) as FUEL_CONSUMED,isnull(case when (tl.MILEAGE > 0 and tl.MILEAGE < 10) then tl.MILEAGE else 0 end,0) as MILEAGE," +
	" isnull(case when (tl.OBD_MILEAGE > 0 and tl.OBD_MILEAGE < 10) then tl.OBD_MILEAGE else 0 end,0) as OBD_MILEAGE," +
	" case when ACTUAL_ARRIVAL is null then isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ISNULL(ACTUAL_ARRIVAL,getutcdate())),0) else isnull(DATEDIFF(mi,ACTUAL_DEPARTURE,ACTUAL_ARRIVAL),0)  end as TRAVEL_DURATION," +
	" isnull(d.Fullname,'') as DRIVER1,isnull(d1.Fullname,'') as DRIVER2,isnull(dateadd(mi,?,ETA),'') as ETA,isnull(sum(GREEN_BAND_SPEED_DUR),0) as SUM_GBSD ," +
	" isnull(sum(GREEN_BAND_RPM_DUR),0) as SUM_GBRD,isnull(sum(TOTAL_DURATION),0) as TOTAL_DURATION,isnull(sum(TOTAL_STOP_DURATION),0)as TOTAL_STOP_DURATION," +
	" isnull(sum(tdd.LOW_RPM_DUR),0) as LOW_RPM_DUR,isnull(sum(tdd.HIGH_RPM_DUR),0) as HIGH_RPM_DUR , isnull(sum(FREE_WHEEL_DUR),0) as SUM_FWD," +
	" isnull(tdd.GREEN_BAND_SPEED_PERC,0) as greenBandSpeedPerc,isnull(tdd.GREEN_RPM_PERC,0) as greenRPMPerc,isnull(d.Mobile,'') as DRIVER1_CONTACT,isnull(d1.Mobile,'') as DRIVER2_CONTACT,  " +
	" isnull(DATEDIFF(mi,STD, ACTUAL_DEPARTURE),0) as delayedDepartureATD_STD, "+
	" isnull(lm.TAT,0) as plannedTransitTime, "+
	" isnull(DATEDIFF(mi,ACTUAL_DEPARTURE, ACTUAL_ARRIVAL),0) as actualTransitTime , lm.DISTANCE , "+
	" isnull(lz.Standard_Duration,'') as Standard_DurationS,isnull(lz1.Standard_Duration,'') as Standard_DurationD , "+
	" DATEADD(mi,lm.TAT,isnull(STA,'')) as STA_wrt_STD,DATEADD(mi,lm.TAT,isnull(ACTUAL_DEPARTURE,''))  as STA_wrt_ATD "+
	" from TRIP_LEG_DETAILS tl " +
	" left outer join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=tl.TRIP_ID "+
	" left outer join AMS.dbo.LEG_MASTER lm on lm.ID=tl.LEG_ID " +
	" left outer join AMS.dbo.LOCATION lz on lz.HUBID=lm.SOURCE " +
	" left outer join AMS.dbo.LOCATION lz1 on lz1.HUBID=lm.DESTINATION " +
	" left outer join AMS.dbo.Driver_Master d on d.Driver_id=tl.DRIVER_1 and d.Client_id = lm.CUSTOMER_ID " +
	" left outer join AMS.dbo.Driver_Master d1 on d1.Driver_id=tl.DRIVER_2 and d1.Client_id = lm.CUSTOMER_ID " +
	" left outer join TRIP_DRIVER_DETAILS tdd on tl.TRIP_ID=tdd.TRIP_ID and tl.LEG_ID=tdd.LEG_ID " +
	" where tl.TRIP_ID=? ";
	
	public static final String GET_TRIP_DETAILS_SLA = "select td.ORDER_ID as tripNumber,isnull(td.TRIP_ID,0) as Tripno,isnull(left(trd.ROUTE_KEY,case WHEN CHARINDEX('_', trd.ROUTE_KEY)>0 THEN CHARINDEX('_', trd.ROUTE_KEY)-1 ELSE 0 END),'NA') as SOURCE, "+
	" SUBSTRING(gps.DRIVER_NAME, 1, CASE CHARINDEX('/', gps.DRIVER_NAME)WHEN 0 THEN LEN(gps.DRIVER_NAME) ELSE CHARINDEX('/', gps.DRIVER_NAME) - 1 END) AS DriverName1,SUBSTRING(gps.DRIVER_NAME, CASE CHARINDEX('/', gps.DRIVER_NAME) "+
    " WHEN 0 THEN LEN(gps.DRIVER_NAME) + 1 ELSE CHARINDEX('/', gps.DRIVER_NAME) + 1 END, 1000) AS DriverName2 ,LEN(gps.DRIVER_MOBILE), SUBSTRING(gps.DRIVER_MOBILE, 1, CASE CHARINDEX('/', gps.DRIVER_MOBILE) WHEN 0 "+
    " THEN LEN(gps.DRIVER_MOBILE) ELSE CHARINDEX('/', gps.DRIVER_MOBILE) - 1 END) AS DriverMob1,SUBSTRING(gps.DRIVER_MOBILE, CASE CHARINDEX('/', gps.DRIVER_MOBILE) WHEN 0 THEN LEN(gps.DRIVER_MOBILE) + 1 ELSE CHARINDEX('/', gps.DRIVER_MOBILE) + 1 END, 1000) AS DriverMob2, "+
	" isnull(right(trd.ROUTE_KEY,(len(trd.ROUTE_KEY)-CHARINDEX('_', trd.ROUTE_KEY))),'NA') as DESTIANTION,isnull(dateadd(mi,330,td.TRIP_START_TIME),'') as STD, "	+
	" isnull(dateadd(mi,330,td.ACTUAL_TRIP_START_TIME),'') as ATD,case when td.ACTUAL_TRIP_START_TIME is not null then CONVERT(varchar, DATEDIFF(mi,td.TRIP_START_TIME,td.ACTUAL_TRIP_START_TIME)) else CONVERT(varchar, 0.00) end as delayedDepartureATDwrtSTD,"+
	" td.PLANNED_DURATION as plannedTransitTime,isnull(dateadd(mi,330,isnull(td.DEST_ARR_TIME_ON_ATD,ds.PLANNED_ARR_DATETIME)),'') as staOnAtd,isnull(dateadd(mi,330,td.DESTINATION_ETA),'') as eta,isnull(dateadd(mi,330,ds.ACT_ARR_DATETIME),'') as ata, "+
	" case when td.ACTUAL_TRIP_START_TIME is null then 0 else DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,isnull(ds.ACT_ARR_DATETIME,isnull(td.DESTINATION_ETA,td.ACTUAL_TRIP_END_TIME))) end - isnull(ACT_CH_DETENTION,0) as actualTransitTime,CONVERT(varchar,((DATEDIFF(mi,isnull(td.ACTUAL_TRIP_START_TIME,0),isnull(ds.ACT_ARR_DATETIME,td.DESTINATION_ETA))-ACT_CH_DETENTION) - (td.PLANNED_DURATION-td.PLANNED_CH_DETENTION))) AS transitDelay "+
	" from AMS.dbo.TRACK_TRIP_DETAILS(nolock) td left outer join AMS.dbo.DES_TRIP_DETAILS(nolock) ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100 left outer join AMS.dbo.DES_TRIP_DETAILS(nolock) ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0 "+
	" left outer join gpsdata_history_latest(nolock) gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID left outer join AMS.dbo.TRIP_ROUTE_MASTER(nolock) trd on trd.ID=td.ROUTE_ID where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS!='UPCOMING'";
	
	public static final String GET_SMART_TRUCKER_TRUCK_DETAILS = " select "+
	" (select count(*)  from AMS.dbo.Driver_Master where Race='Active'  "+
	" and System_id=? and Client_id=? ) as Driver,  "+
	" (select  count(*) from AMS.dbo.VehicleRegistration where SystemId=?  "+
	" and Status='Active') as Vehicle,  "+
	" (select count(*)  from AMS.dbo.Driver_Master where Race='Active'  "+
	" and System_id=? and Client_id=?  "+
	" and CREATED_TIME<convert(varchar(10),getdate()-?,120) ) as RelDriver,    "+
	" (select  count(*) from AMS.dbo.VehicleRegistration where SystemId=?  "+
	" and RegistrationDateTime < convert(varchar(10),getdate()-?,120)  "+
	" and Status='Active') as RelVehicle  ";
	
	public static final String GET_POINTS_FOR_ROUTE = " select ROUTE_SEQUENCE,ROUTE_SEGMENT,LATITUDE,LONGITUDE,ld.TYPE as TYPE,ld.HUB_ID, CHECKPOINT_SEQUENCE ,ld.LEG_ID from AMS.dbo.TRIP_ROUTE_DETAILS rd " +
	" inner join AMS.dbo.LEG_DETAILS ld on ld.LEG_ID=rd.LEG_ID " +
	" where ROUTE_ID=? and ld.TYPE!='' and ld.TYPE!='DRAGPOINT' order by LEG_SEQUENCE,ROUTE_SEQUENCE,ROUTE_SEGMENT " ;

	public static final String GET_DRIVER_COUNT_DETAILS = "select isnull(d.Fullname,'') as NAME,isnull(d.EmployeeID,'') as EMP_ID,count(DRIVER_ID) as NO_OF_TRIPS," +
	" DRIVER_ID,isnull(sum(HA_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HA_COUNT,isnull(sum(HB_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HB_COUNT,"+
	" isnull(sum(HC_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HC_COUNT,isnull(sum(OVERSPEED_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as OVERSPEED_COUNT,"+
	" isnull(sum(OVER_REVV_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as OVER_REVV_COUNT,isnull(sum(UNSCHLD_STOP_DUR * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as UNSCHLD_STOP_DUR,"+
	" isnull(sum(EXCESS_IDLE_DUR * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as EXCESS_IDLE_DUR,isnull(sum(GREEN_BAND_SPEED_DUR * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as GREEN_BAND_SPEED_DUR,"+
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) then (FREE_WHEEL_DUR * TOTAL_DURATION) else null end) /"+ 
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) then TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as FREE_WHEEL_DUR,"+
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (GREEN_BAND_RPM_DUR * TOTAL_DURATION) ELSE NULL END) / "+
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (TOTAL_DURATION) ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as GREEN_BAND_RPM_DUR,"+
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (LOW_RPM_DUR * TOTAL_DURATION) ELSE NULL END) /"+ 
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (TOTAL_DURATION) ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as LOW_RPM_DUR,"+
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (HIGH_RPM_DUR * TOTAL_DURATION) ELSE NULL END) /"+
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (TOTAL_DURATION) ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as HIGH_RPM_DUR,"+
	" isnull(cast(cast(AVG(CASE WHEN (MILEAGE>0 and MILEAGE < 10) THEN MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as MILEAGE,"+
	" isnull(cast(cast(AVG(CASE WHEN (OBD_MILEAGE>0 and OBD_MILEAGE < 10) THEN OBD_MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as OBD_MILEAGE"+  
	" from AMS.dbo.TRIP_DRIVER_DETAILS a "+
	" LEFT OUTER join AMS.dbo.Driver_Master d on d.Driver_id=a.DRIVER_ID and Client_id=CUSTOMER_ID "+
	" where SYSTEM_ID=? and CUSTOMER_ID=? and DRIVER_ID !=0 and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) #"+
	" group by DRIVER_ID,d.EmployeeID,d.Fullname order by d.Fullname";
	
	public static final String GET_UNDERMAINTENANCE_DETAILS_AT_CONTROL_TOWER = "select isnull(t1.REGISTRATION_NO,'') as VEHICLE_NO,isnull(t1.GPS_DATETIME,'') as GPS_DATETIME,"
		+ " isnull(t1.LOCATION,'') as LOCATION, isnull(t2.ID,'') as ID, isnull(t2.START_DATE,'') as START_DATE, isnull(t2.REMARKS,'') as REMARKS from AMS.dbo.VEHICLE_MAINTENANCE_DETAILS t2 "
		+ " left outer join AMS.dbo.gpsdata_history_latest as t1  on t1.REGISTRATION_NO = t2.VEHICLE_NUMBER and t1.System_id=t2.SYSTEM_ID and t1.CLIENTID=t2.CUSTOMER_ID "
		+ " where System_id=? and CLIENTID=? and t2.END_DATE is null";;

    public static final String GET_ASSOCIATION_DATA_FOR_PRODUCT_LINE = " select count(*) as COUNT from  AMS.dbo.RS232_ASSOCIATION where IO_CATEGORY in ('TEMPERATURE1','TEMPERATURE2','TEMPERATURE3') " +
		" and REGISTRATION_NO in( select ASSET_NUMBER from dbo.TRACK_TRIP_DETAILS where PRODUCT_LINE in('Chiller', 'Freezer','TCL') and ASSET_NUMBER=? and TRIP_ID=?)" ;
	

	public static final String GET_LOW_FUEL_ALERT_COUNT="select count(*) as LowFuelAlert from Alert a " +
	" inner join AMS.dbo.tblVehicleMaster b on b.VehicleNo=a.REGISTRATION_NO " +
	" inner join FMS.dbo.Vehicle_Model vm on b.Model=vm.ModelTypeId WHERE a.SYSTEM_ID=? and a.CLIENTID=? and GMT between dateadd(dd,-7,getutcdate()) and getutcdate() # ";

	public static final String GET_MILEAGE_ON_VEH_TYPE_NEW = " select AVG(MILEAGE) as MILEAGE from (select AVG(AVG_MILEAGE) as MILEAGE,DD from( "+ 
		" select (isnull(ENG_FUEL_ECO,0)) as AVG_MILEAGE,REGISTRATION_NO as DD "+
		" from AMS.dbo.CANIQ_HISTORY_# ch inner join   AMS.dbo.tblVehicleMaster tvm on REGISTRATION_NO=VehicleNo "+
		" inner join FMS.dbo.Vehicle_Model vm on tvm.Model=vm.ModelTypeId "+
		" where ch.CLIENTID=? and VehType=?  and ENG_FUEL_ECO<6 and GMT "+
		" between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) "+
		" union all "+
		" select (isnull(ENG_FUEL_ECO,0)) as AVG_MILEAGE,REGISTRATION_NO as DD "+
		" from [AMS_Archieve].dbo.GE_CANIQ_# ch inner join   AMS.dbo.tblVehicleMaster tvm on REGISTRATION_NO=VehicleNo "+
		" inner join FMS.dbo.Vehicle_Model vm on tvm.Model=vm.ModelTypeId "+
		" where ch.CLIENTID=? and VehType=?  and ENG_FUEL_ECO<6 and GMT "+
		" between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) "+
		" ) q "+
		" group by q.DD )r ";

	public static final String GET_MILEAGE_ON_VEH_TYPE_NEW_REL = " select AVG(MILEAGE) as RMILEAGE from (select AVG(AVG_MILEAGE) as MILEAGE,DD from( "+ 
		" select (isnull(ENG_FUEL_ECO,0)) as AVG_MILEAGE,REGISTRATION_NO as DD "+
		" from AMS.dbo.CANIQ_HISTORY_# ch inner join   AMS.dbo.tblVehicleMaster tvm on REGISTRATION_NO=VehicleNo "+
		" inner join FMS.dbo.Vehicle_Model vm on tvm.Model=vm.ModelTypeId "+
		" where ch.CLIENTID=? and VehType=?  and ENG_FUEL_ECO<6 and GMT "+
		" between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) "+
		" union all "+
		" select (isnull(ENG_FUEL_ECO,0)) as AVG_MILEAGE,REGISTRATION_NO as DD "+
		" from [AMS_Archieve].dbo.GE_CANIQ_# ch inner join   AMS.dbo.tblVehicleMaster tvm on REGISTRATION_NO=VehicleNo "+
		" inner join FMS.dbo.Vehicle_Model vm on tvm.Model=vm.ModelTypeId "+
		" where ch.CLIENTID=? and VehType=?  and ENG_FUEL_ECO<6 and GMT "+
		" between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) "+
		" ) q "+
		" group by q.DD )r ";

	public static final String GET_TOTAL_COUNT_VEHICLE ="select count(ASSET_NUMBER) as TotalVehicle FROM( "+
						" select count(distinct ASSET_NUMBER) as ASSET_NUMBER FROM AMS.dbo.TRACK_TRIP_DETAILS "+
						" where  SYSTEM_ID=? and CUSTOMER_ID=? AND STATUS='CLOSED' "+
						" and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-30,120)) and dateadd(mi,-?,convert(varchar(10),getdate(),120)) # $ "+
						" GROUP BY ASSET_NUMBER ) as ff";

	public static final String GET_TOTAL_COUNT_GREATER_RANGE =  "select count(ASSET_NUMBER) as  GreaterthanRange from (" +
				 		" SELECT count(distinct ASSET_NUMBER) as  ASSET_NUMBER " +
				 		" FROM AMS.dbo.TRACK_TRIP_DETAILS " +
				 		" where  SYSTEM_ID=? and CUSTOMER_ID=? AND STATUS='CLOSED' "+
						" and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-30,120)) and dateadd(mi,-?,convert(varchar(10),getdate(),120)) # $"+						
				 		" GROUP BY ASSET_NUMBER" +
				 		" having sum(isnull(ACTUAL_DISTANCE,0))>=15000) as ddd ";

	public static final String GET_TOTAL_COUNT_BETWEEN_RANGE = " select count(ASSET_NUMBER) as  IntheRange from ( " +
			 		" SELECT count(distinct ASSET_NUMBER) as  ASSET_NUMBER FROM AMS.dbo.TRACK_TRIP_DETAILS " +
			 		" where SYSTEM_ID=? and CUSTOMER_ID=? AND STATUS='CLOSED'  and AUTO_CLOSE is null " +
					" and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-30,120)) and dateadd(mi,-?,convert(varchar(10),getdate(),120)) # $"+	
			 		" GROUP BY ASSET_NUMBER having sum(isnull(ACTUAL_DISTANCE,0))<15000 and sum(isnull(ACTUAL_DISTANCE,0))>12000 ) " +
			 		" as ddd";

	public static final String GET_TOTAL_COUNT_BELOW_RANGE = "select count(ASSET_NUMBER) as  lessthanRange from ( " +
		 		" SELECT count(distinct ASSET_NUMBER) as  ASSET_NUMBER FROM AMS.dbo.TRACK_TRIP_DETAILS " +
		 		" where SYSTEM_ID=? and CUSTOMER_ID=? AND STATUS='CLOSED'  and AUTO_CLOSE is null " +
				" and INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-30,120)) and dateadd(mi,-?,convert(varchar(10),getdate(),120)) # $"+	
		 		" GROUP BY ASSET_NUMBER " +
		 		" having sum(isnull(ACTUAL_DISTANCE,0))<=12000 ) as ddd";

	public static final String GET_COUNT_OF_DRIVERS_PERFORMACE = "  select count(DRIVER_ID) as  TOTAL_DRIVER from  ( "+
								" select distinct DRIVER_ID from AMS.dbo.TRIP_DRIVER_DETAILS  td inner join AMS.dbo.TRACK_TRIP_DETAILS tt "+
						 		" on td.TRIP_ID = tt.TRIP_ID " +
						 		" where  td.SYSTEM_ID=? and td.CUSTOMER_ID=? "+
								" and td.INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ "+	
								" ) as ddd ";

	public static final String GET_TOP_DRIVER_PERFORMACE = "select count(TOP_PER) as  TOP_PERFORMER from ("+
							" SELECT avg(isnull(FINAL_SCORE,0)) as  TOP_PER ,DRIVER_ID "+
							" FROM AMS.dbo.TRIP_DRIVER_DETAILS  td inner join AMS.dbo.TRACK_TRIP_DETAILS tt "+
						 	" on td.TRIP_ID = tt.TRIP_ID " +
						 	" where  td.SYSTEM_ID=? and td.CUSTOMER_ID=? "+
							" and td.INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ "+	
							" GROUP BY DRIVER_ID "+
							" having avg(isnull(FINAL_SCORE,0))>=8 "+
							" ) as ddd ";

	public static final String GET_COUNT_OF_REL_DRIVERS_PERFORMACE = "  select count(DRIVER_ID) as  REL_TOTAL_DRIVER from  ( "+
							" select distinct DRIVER_ID from AMS.dbo.TRIP_DRIVER_DETAILS td inner join AMS.dbo.TRACK_TRIP_DETAILS tt "+
							" on td.TRIP_ID = tt.TRIP_ID " +
							" where  td.SYSTEM_ID=? and td.CUSTOMER_ID=? "+
							" and td.INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ "+	
							" ) as ddd ";

	public static final String GET_TOP_DRIVER_REL_PERFORMACE = "select count(TOP_PER) as  REL_TOP_PERFORMER from ("+
							" SELECT avg(isnull(FINAL_SCORE,0)) as  TOP_PER ,DRIVER_ID "+
							" FROM AMS.dbo.TRIP_DRIVER_DETAILS  td inner join AMS.dbo.TRACK_TRIP_DETAILS tt "+
							" on td.TRIP_ID = tt.TRIP_ID " +
							" where  td.SYSTEM_ID=? and td.CUSTOMER_ID=? "+
							" and td.INSERTED_TIME between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) # $ "+	
							" GROUP BY DRIVER_ID "+
							" having avg(isnull(FINAL_SCORE,0))>=8 "+
							" ) as ddd ";


	public static final String GET_VEHICLE_TYPE_MILEAGE = 
		 " select AVG(Milage) as Mileage ,MN as ModelName from (select avg(AVG_MILEAGE) as Milage ,MN  from( "+
		 " select isnull((ENG_FUEL_ECO),0) as AVG_MILEAGE ,ModelName as MN "+
		 " from AMS.dbo.CANIQ_HISTORY_# as CD inner join   AMS.dbo.tblVehicleMaster vm on REGISTRATION_NO=VehicleNo "+ 
		 " inner join FMS.dbo.Vehicle_Model on ModelTypeId=Model "+
		 " where CD.CLIENTID=?  and VehType=?  and ENG_FUEL_ECO<6 "+
		 " and GMT between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) "+     
		 " union  all "+
		 " select isnull((ENG_FUEL_ECO),0) as AVG_MILEAGE ,ModelName as MN "+
		 " from [AMS_Archieve].dbo.GE_CANIQ_# as CD inner join   AMS.dbo.tblVehicleMaster vm on REGISTRATION_NO=VehicleNo "+
		 " inner join FMS.dbo.Vehicle_Model on ModelTypeId=Model "+
		 " where CD.CLIENTID=?  and VehType=?   and ENG_FUEL_ECO<6 "+
		 " and GMT between dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) and dateadd(mi,-?,convert(varchar(10),getdate()-?,120)) "+
		 " )hh group by hh.MN "+
		 " )r  group by r.MN ";
						 
 public static final String GET_DRAGPOINTS = "select LEG_ID,ROUTE_SEQUENCE,ld.LATITUDE as LATITUDE,ROUTE_SEGMENT,CHECKPOINT_SEQUENCE," +
 		"    ld.LONGITUDE as LONGITUDE,ld.TYPE as TYPE,ld.HUB_ID as HUB_ID from AMS.dbo.LEG_DETAILS ld " +
 		"    where  ld.TYPE ='DRAGPOINT' and LEG_ID = ? and CHECKPOINT_SEQUENCE = ?" +
 		"    order by LEG_ID,ROUTE_SEQUENCE,CHECKPOINT_SEQUENCE,ROUTE_SEGMENT  ";
 
 public static final String GET_UNASSIGNED_VEHICLE_LATLNG="select isnull(REGISTRATION_NO,'') as REGISTRATION_NO,isnull(LONGITUDE,'') as LONGITUDE,isnull(LATITUDE,'') as LATITUDE from AMS.dbo.gpsdata_history_latest where System_id=? " +
 		" and CLIENTID=? and REGISTRATION_NO not in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' )";
 
 public static final String GET_ASSIGNED_ENROUTE_VEHICLE_LATLNG="select REGISTRATION_NO,LONGITUDE,LATITUDE from AMS.dbo.gpsdata_history_latest where System_id=268 and CLIENTID=5560 and REGISTRATION_NO in ( select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS like 'ENROUTE PLACEMENT%'  " +
 		" and SYSTEM_ID=? and CUSTOMER_ID=?) ";
 
 public static final String GET_ASSIGNED_PLACED_VEHICLE_LATLNG="select REGISTRATION_NO,LONGITUDE,LATITUDE from AMS.dbo.gpsdata_history_latest where System_id=268 and CLIENTID=5560 and REGISTRATION_NO in ( select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_STATUS not like 'ENROUTE PLACEMENT%' " +
 		" and SYSTEM_ID=? and CUSTOMER_ID=?) ";
 
 public static final String GET_FUTURE_AVAILABLE_TRUCKS="select gps.REGISTRATION_NO,gps.LONGITUDE,LATITUDE,dateadd(mi,?,td.DESTINATION_ETA)as ETA ,isnull(gps.LOCATION,'') as LOCATION  from AMS.dbo.gpsdata_history_latest gps "+
		 "inner join AMS.dbo.TRACK_TRIP_DETAILS td on gps.System_id=td.SYSTEM_ID and gps.CLIENTID=td.CUSTOMER_ID and gps.REGISTRATION_NO=td.ASSET_NUMBER "+
		 "where td.DESTINATION_ETA is not null and td.STATUS='OPEN'  "+
		 "and td.DESTINATION_ETA between getutcdate() and DATEADD(hour, ?, getutcdate()) "+
		 "and td.SYSTEM_ID=? and td.CUSTOMER_ID=? "+
		 "ORDER BY gps.REGISTRATION_NO ";
 
 public static final String GET_DRIVERS_FOR_UTILIZATION=" select  DISTINCT a.Driver_id as id,a.Fullname as DriverName  "+
		 " from AMS.dbo.Driver_Master a "+
		 " INNER JOIN   AMS.dbo.TRIP_LEG_DETAILS b on a.Driver_id=b.DRIVER_1 or a.Driver_id=b.DRIVER_2 "+
		 " INNER   join AMS.dbo.TRACK_TRIP_DETAILS c on b.TRIP_ID=c.TRIP_ID "+
		 " where c.SYSTEM_ID=? and c.CUSTOMER_ID=?    ";

	public static final String INSERT_ROUTE_HUB_LEG_DETENTION_DETAILS = "insert into ROUTE_HUB_DETENTION_DETAILS (ROUTE_ID,LEG_ID,HUB_ID,DETENTION)" +
	" values (?,?,?,?)" ;

	public static final String GET_ROUTE_HUB_LEG_DETENTION_DETAILS_COUNT = "select count(*) as count from ROUTE_HUB_DETENTION_DETAILS where ROUTE_ID = ? and LEG_ID = ? and HUB_ID = ?"; 

	public static final String UPDATE_ROUTE_HUB_LEG_DETENTION_DETAILS = "update ROUTE_HUB_DETENTION_DETAILS set DETENTION = ? where ROUTE_ID = ? and LEG_ID = ? and HUB_ID = ?";	
	
	public static final String GET_ROUTE_HUB_LEG_DETENTION = "select DETENTION as ROUTE_HUB_DETENTION_DETAILS_DETENTION, '' as HUB_ADDRESS from ROUTE_HUB_DETENTION_DETAILS where ROUTE_ID = ? and LEG_ID = ? and HUB_ID = ? ";
	
	public static final String GET_ROUTE_DETAILS_FOR_LIST_VIEW="select distinct a.ROUTE_ID,a.ROUTE_NAME as RouteName from AMS.dbo.TRACK_TRIP_DETAILS a where " +
																"a.SYSTEM_ID=? # and CUSTOMER_NAME is not null ";

	
	public static final String GET_ASSIGNED_ENROUTE_PLACED_DETAILS_FOR_LIST_VIEW=
		"select isnull(b.CUSTOMER_NAME,'') Customer_Name,isnull(b.ROUTE_NAME,'') Route_Name,isnull(a.REGISTRATION_NO,'') as VEHICLE_NO,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isnull(LOCATION,'') as LOCATION " +
	"from AMS.dbo.gpsdata_history_latest a " +
	"inner join AMS.dbo.TRACK_TRIP_DETAILS b on b.ASSET_NUMBER=a.REGISTRATION_NO " +
	"where a.System_id=? and a.CLIENTID=? and b.STATUS='OPEN' # $ ^ ";

	//public static final String GET_CUSTOMERS_FOR_SLA = "select distinct isnull(ID,'') as TRIP_CUSTOMER_ID, isnull(NAME,'') as NAME from AMS.dbo.TRIP_CUSTOMER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active'";
	public static final String GET_CUSTOMERS_FOR_SLA = "select distinct isnull(ID,'') as TRIP_CUSTOMER_ID,isnull(NAME,'') as NAME from TRIP_CUSTOMER_DETAILS tc inner join TRACK_TRIP_DETAILS td on td.TRIP_CUSTOMER_ID=tc.ID where tc.SYSTEM_ID=? and tc.CUSTOMER_ID=? and tc.STATUS='Active' order by NAME";
	
	
	public static final String INSERT_ROUTE_TEMPLATE = "INSERT INTO ROUTE_TEMPLATE (NAME,ROUTE_ID,SYSTEM_ID,CUSTOMER_ID,TRIP_CUST_ID,CREATED_BY,CREATED_DATE)" +
	 													" VALUES(?,?,?,?,?,?,getDate())";
	
	public static final String UPDATE_ROUTE_TEMPLATE = "UPDATE ROUTE_TEMPLATE SET UPDATED_BY=? , UPDATED_DATE=getDate() WHERE ID=?";
	
	public static final String INSERT_ROUTE_LEG_MATERIAL_ASSOC = "INSERT INTO ROUTE_LEG_MATERIAL_ASSOC (TEMPLATE_ID,MATERIAL_ID,LEG_ID,TAT,RUN_TIME,DETENTION,SYSTEM_ID,CUSTOMER_ID,TRIP_CUST_ID,IS_DELETED)" +
		 														 " VALUES(?,?,?,?,?,?,?,?,?,'N')";
	
	public static final String UPDATE_ROUTE_LEG_MATERIAL_ASSOC = "UPDATE ROUTE_LEG_MATERIAL_ASSOC SET TAT=?, RUN_TIME=?,DETENTION=?,IS_DELETED='N' WHERE TEMPLATE_ID=?  AND MATERIAL_ID=? AND LEG_ID=?";
	
	public static final String DELETE_ROUTE_LEG_MATERIAL_ASSOC = "UPDATE ROUTE_LEG_MATERIAL_ASSOC SET IS_DELETED='Y' WHERE TEMPLATE_ID=?  AND MATERIAL_ID=? AND LEG_ID=?";

	
	public static final String GET_MATERIALS_BY_TEMPLATE_ID = "SELECT MATERIAL_ID FROM ROUTE_LEG_MATERIAL_ASSOC WHERE TEMPLATE_ID=?";
	
	public static final String GET_ALL_ROUTE_TEMPLATE = "SELECT rt.ID as ID,NAME,isNull(trm.ROUTE_NAME,'') as ROUTE_NAME,ROUTE_ID, " +
														" MATERIALS=STUFF((SELECT DISTINCT ',' + mm.MATERIAL_NAME FROM ROUTE_LEG_MATERIAL_ASSOC rlm LEFT JOIN MATERIAL_MASTER mm " +
														" on rlm.MATERIAL_ID=mm.ID WHERE rlm.TEMPLATE_ID = rt.ID AND (rlm.IS_DELETED ='N' OR rlm.IS_DELETED IS NULL) FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')" +
														" FROM ROUTE_TEMPLATE rt LEFT JOIN TRIP_ROUTE_MASTER trm ON trm.ID=rt.ROUTE_ID WHERE rt.SYSTEM_ID=? AND rt.CUSTOMER_ID=? and rt.TRIP_CUST_ID=? order by rt.ID desc";
	
	public static final String GET_ROUTE_TEMPLATE_BY_ID = "SELECT rlm.MATERIAL_ID,mm.MATERIAL_NAME,rlm.LEG_ID,lm.LEG_NAME,rlm.TAT,rlm.RUN_TIME,rlm.DETENTION, " +
														  "	(select sum(TAT) from ROUTE_LEG_MATERIAL_ASSOC rlm1 where rlm1.MATERIAL_ID =rlm.MATERIAL_ID and rlm1.TEMPLATE_ID=rlm.TEMPLATE_ID AND (rlm.IS_DELETED ='N' OR rlm.IS_DELETED IS NULL) group by MATERIAL_ID) as TotalTAT,"+
														  "	(select sum(RUN_TIME) from ROUTE_LEG_MATERIAL_ASSOC rlm1 where rlm1.MATERIAL_ID =rlm.MATERIAL_ID and rlm1.TEMPLATE_ID=rlm.TEMPLATE_ID AND (rlm.IS_DELETED ='N' OR rlm.IS_DELETED IS NULL) group by MATERIAL_ID) as TotalRunTime,"+
														  "	(select sum(DETENTION) from ROUTE_LEG_MATERIAL_ASSOC rlm1 where rlm1.MATERIAL_ID =rlm.MATERIAL_ID and rlm1.TEMPLATE_ID=rlm.TEMPLATE_ID AND (rlm.IS_DELETED ='N' OR rlm.IS_DELETED IS NULL) group by MATERIAL_ID) as TotalDetention"+
														 " FROM ROUTE_LEG_MATERIAL_ASSOC rlm"+
														 " LEFT JOIN MATERIAL_MASTER mm on rlm.MATERIAL_ID=mm.ID "+
														 " LEFT JOIN LEG_MASTER lm ON lm.ID=rlm.LEG_ID"+
														 " where TEMPLATE_ID=? AND (rlm.IS_DELETED ='N' OR rlm.IS_DELETED IS NULL)";											
		
	public static final String INSERT_MATERIAL_MASTER = "insert into MATERIAL_MASTER (MATERIAL_NAME,INSERTED_DATE,CLIENT_ID,SYSTEM_ID)" +
														" values (?,getutcdate(),?,?)";
	
	public static final String GET_MATERIAL_MASTER = " select ID,MATERIAL_NAME from dbo.MATERIAL_MASTER where SYSTEM_ID = ?  and CLIENT_ID = ? ";
	
	public static final String UPDATE_MATERIAL_MASTER = " update dbo.MATERIAL_MASTER set MATERIAL_NAME = ? where ID = ?  ";
	
	public static final String DELETE_MATERIAL_MASTER = " delete from dbo.MATERIAL_MASTER where ID = ? ";
	
	public static final String GET_MATERIALS_TOTAL_TAT ="select MATERIAL_ID,mm.MATERIAL_NAME, sum(TAT) as TotalTAT, sum(RUN_TIME) TotalRunTime,sum(DETENTION) AS TotalDetention from ROUTE_LEG_MATERIAL_ASSOC rlma"+
														" inner join MATERIAL_MASTER mm on mm.ID= rlma.MATERIAL_ID WHERE rlma.SYSTEM_ID=? AND rlma.CUSTOMER_ID=? and rlma.TRIP_CUST_ID=? and rlma.TEMPLATE_ID=? " +
														" AND (rlma.IS_DELETED ='N' OR rlma.IS_DELETED IS NULL) " +
														" group by rlma.MATERIAL_ID,mm.MATERIAL_NAME";
	
	public static final String GET_ON_TRIP_VEHICLE_STOPPAGE = "SELECT td.TRIP_ID, isnull(td.SHIPMENT_ID,'') as SHIPMENT_ID,isnull(td.ASSET_NUMBER, '') as ASSET_NUMBER, "+
																" isnull(td.ROUTE_NAME,'') as ROUTE_NAME, isnull(gps.LONGITUDE,'') as LONGITUDE, isnull(gps.LATITUDE,'') as LATITUDE, isnull(LOCATION,'') as LOCATION,isnull(DURATION,0) as DURATION,isnull(tcd.ID,'') as TRIP_CUST_ID, isnull(tcd.NAME,'') as TRIP_CUST_NAME, " +
																" (CAST(getDate() as datetime) - CAST(DURATION AS datetime)) as STOPPAGE_BEGIN, isnull(ORDER_ID,'') as LR_NO"+
																" from dbo.gpsdata_history_latest gps "+
																" INNER JOIN TRACK_TRIP_DETAILS td ON td.ASSET_NUMBER=gps.REGISTRATION_NO "+
																" LEFT OUTER JOIN DES_TRIP_DETAILS des100 ON des100.SEQUENCE=100 AND td.TRIP_ID=des100.TRIP_ID "+
																" LEFT OUTER JOIN TRIP_CUSTOMER_DETAILS tcd ON tcd.ID=td.TRIP_CUSTOMER_ID "+
																" LEFT OUTER JOIN  AMS.dbo.LOCATION lz ON lz.HUBID=gps.HUB_ID "+
																" where td.STATUS='OPEN' and DURATION >=1 AND CATEGORY='stoppage' AND des100.ACT_ARR_DATETIME IS NULL " + 
																" AND CATEGORY='stoppage' AND td.SYSTEM_ID=? AND td.CUSTOMER_ID=? AND (lz.OPERATION_ID NOT IN(33) AND LOCATION NOT LIKE '%Inside%') "+ 
																" AND td.TRIP_ID NOT IN(SELECT TRIP_ID FROM ON_TRIP_VEHICLE_STOPPAGE_ACTION WHERE SYSTEM_ID=? AND" +
																" CUSTOMER_ID=? AND (STATUS='ACKNOWLEDGED' OR STATUS='CLOSED')) ORDER BY DURATION DESC ";
	
	public static final String INSERT_INTO_ON_TRIP_VEHICLE_STOPPAGE_ACTION =  "INSERT INTO ON_TRIP_VEHICLE_STOPPAGE_ACTION (TRIP_ID,STATUS,INSERTED_BY,INSERTED_DATE,SYSTEM_ID,CUSTOMER_ID,STOPPAGE_START_TIME)"+
																				" VALUES (?,?,?,getutcdate(),?,?,?)";
	
	public static final String INSERT_UPDATE_ON_TRIP_VEHICLE_STOPPAGE_ACTION =  "INSERT INTO ON_TRIP_VEHICLE_STOPPAGE_ACTION (TRIP_ID,STATUS,INSERTED_BY,INSERTED_DATE,SYSTEM_ID,CUSTOMER_ID,UPDATED_BY," +
																				" UPDATED_DATE,STOPPAGE_START_TIME,REMARKS,STOPPAGE_DURATION,LATITUDE,LONGITUDE,LOCATION)"+
																			  " VALUES (?,?,?,getutcdate(),?,?,?,getutcdate(),?,?,?,?,?,?)";
	
	public static final String GET_ONTRIP_VEHICLE_STOPPAGE_ALERT_BY_TRIPID = "SELECT ID FROM ON_TRIP_VEHICLE_STOPPAGE_ACTION WHERE TRIP_ID=? AND (STATUS='OPEN' OR STATUS='CLOSED')";
	
	public static final String UPDATE_ONTRIP_VEHICLE_STOPPAGE_AUTO_CLOSE = " UPDATE ON_TRIP_VEHICLE_STOPPAGE_ACTION SET STATUS='AUTO_CLOSED',UPDATED_DATE=getutcdate() WHERE STATUS='OPEN' AND TRIP_ID NOT IN" +
																			" (SELECT td.TRIP_ID  "+
																			" from dbo.gpsdata_history_latest gps"+ 
																			" INNER JOIN TRACK_TRIP_DETAILS td ON td.ASSET_NUMBER=gps.REGISTRATION_NO "+
																			" LEFT OUTER JOIN  AMS.dbo.LOCATION lz ON lz.HUBID=gps.HUB_ID "+
																			" where td.STATUS='OPEN' and DURATION >=1 AND CATEGORY='stoppage' AND td.TRIP_STATUS='ENROUTE PLACEMENT DELAYED' "+
																			" AND td.SYSTEM_ID=? AND td.CUSTOMER_ID=? AND (lz.OPERATION_ID NOT IN(33) AND LOCATION NOT LIKE '%Inside%')) ";
																			
																			
	public static final String GET_ONTRIP_VEHICLE_STOPPAGE_ACTION_DETAILS = " SELECT otvs.ID,td.TRIP_ID, td.SHIPMENT_ID,td.ASSET_NUMBER,td.ROUTE_NAME,LONGITUDE,LATITUDE,LOCATION,DURATION,otvs.STATUS,dateadd(mi,?,INSERTED_DATE) AS INSERTED_DATE,tcd.ID as TRIP_CUST_ID," +
																			" tcd.NAME as TRIP_CUST_NAME,isnull(ORDER_ID,'') as LR_NO FROM ON_TRIP_VEHICLE_STOPPAGE_ACTION otvs"+ 
																			" LEFT OUTER JOIN TRACK_TRIP_DETAILS td on td.TRIP_ID=otvs.TRIP_ID "+
																			" LEFT OUTER JOIN gpsdata_history_latest gps ON td.ASSET_NUMBER=gps.REGISTRATION_NO"+
																			" LEFT OUTER JOIN TRIP_CUSTOMER_DETAILS tcd ON tcd.ID=td.TRIP_CUSTOMER_ID WHERE otvs.SYSTEM_ID=? AND otvs.CUSTOMER_ID=? AND otvs.STATUS='OPEN'";

					
	public static final String UPDATE_ONTRIP_VEHICLE_STOPPAGE_ACTION = "UPDATE ON_TRIP_VEHICLE_STOPPAGE_ACTION SET STATUS='CLOSED', UPDATED_DATE=getutcdate() ,UPDATED_BY=? WHERE ID=?";
	
	
	public static final String GET_DELAYED_TRIPS_NOT_ACK = " select td.TRIP_ID,td.ORDER_ID as LR_NO,td.ASSET_NUMBER,td.ROUTE_NAME,dateadd(mi,?,des0.PLANNED_ARR_DATETIME) AS STP,gps.LOCATION," +
	" ATP_DELAY_ACKNOWLEDGE,SHIPMENT_ID,isnull(gps.LATITUDE,'') as LATITUDE,isnull(gps.LONGITUDE,'') as LONGITUDE, "+
	" gps.DURATION,tcd.NAME as TRIP_CUST_NAME,tcd.ID as TRIP_CUST_ID from TRACK_TRIP_DETAILS td "+
	" LEFT OUTER JOIN DES_TRIP_DETAILS des0 on des0.SEQUENCE=0 AND des0.TRIP_ID=td.TRIP_ID "+
	" LEFT OUTER JOIN TRIP_CUSTOMER_DETAILS tcd ON tcd.ID=td.TRIP_CUSTOMER_ID "+
	" INNER JOIN gpsdata_history_latest gps ON gps.REGISTRATION_NO=td.ASSET_NUMBER WHERE "+
	" DATEDIFF(mi,des0.PLANNED_ARR_DATETIME,LAST_EXEC_DATE) >30 and des0.ACT_ARR_DATETIME is null and ATP_DELAY_ACKNOWLEDGE IS NULL AND td.STATUS='OPEN' AND td.SYSTEM_ID=? and td.CUSTOMER_ID=? ";

public static final String GET_DELAYED_TRIPS_ALL = " select td.TRIP_ID,td.ORDER_ID as LR_NO,td.ASSET_NUMBER,td.ROUTE_NAME,dateadd(mi,?,des0.PLANNED_ARR_DATETIME) AS STP," +
	" gps.LOCATION,ATP_DELAY_ACKNOWLEDGE,SHIPMENT_ID,isnull(gps.LATITUDE,'') as LATITUDE,isnull(gps.LONGITUDE,'') as LONGITUDE, "+
	" gps.DURATION,tcd.NAME as TRIP_CUST_NAME,tcd.ID as TRIP_CUST_ID from TRACK_TRIP_DETAILS td "+
	" LEFT OUTER JOIN DES_TRIP_DETAILS des0 on des0.SEQUENCE=0 AND des0.TRIP_ID=td.TRIP_ID "+
	" LEFT OUTER JOIN TRIP_CUSTOMER_DETAILS tcd ON tcd.ID=td.TRIP_CUSTOMER_ID "+
	" INNER JOIN gpsdata_history_latest gps ON gps.REGISTRATION_NO=td.ASSET_NUMBER WHERE "+
	" DATEDIFF(mi,des0.PLANNED_ARR_DATETIME,LAST_EXEC_DATE) >30 and" +
	" (des0.ACT_ARR_DATETIME is null or (ATP_DELAY_ACKNOWLEDGE is not null AND OVERRIDDEN_REMARKS IS NOT NULL))" +
	" AND td.STATUS='OPEN' AND td.SYSTEM_ID=? and td.CUSTOMER_ID=? ORDER BY ATP_DELAY_ACKNOWLEDGE ";

	public static final String UPDATE_TRIP_ACKNOWLEDGEMENT = "UPDATE TRACK_TRIP_DETAILS SET ATP_DELAY_ACKNOWLEDGE=?,ACKNOWLEDGED_BY=?, ACKNOWLEDGED_DATE=getUTCDate() WHERE TRIP_ID=? AND SYSTEM_ID=? AND CUSTOMER_ID=? ";
	
	public static final String GET_DRIVER_SCORE_VALUE_DETAILS = "select DRIVER_ID,isnull(SUM(FINAL_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as TOTAL_SCORE, " +
	" isnull(d.EmployeeID,'') as EMP_ID,isnull(d.Fullname,'') as NAME,isnull(SUM(HB_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as HB_SCORE, " +
	" isnull(SUM(HA_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as HA_SCORE,isnull(SUM(HC_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as HC_SCORE, " +
	" isnull(SUM(OVER_REVV_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as OVER_REVV_SCORE,isnull(SUM(OVER_SPEED_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as OVER_SPEED_SCORE, " +
	" isnull(SUM(IDLE_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as IDLE_SCORE,isnull(SUM(UNSCHDL_STOPPAGE_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as UNSCHDL_STOPPAGE_SCORE, " +
	" isnull(SUM(GREEN_BAND_SPEED_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as GREEN_BAND_SPEED_SCORE,isnull(SUM(IDLE_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as IDLE_SCORE, " +
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (FREE_WHEEL_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as FREE_WHEEL_SCORE, "+
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (GREEN_BAND_RPM_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as GREEN_BAND_RPM_SCORE, "+
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (LOW_RPM_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as LOW_RPM_SCORE, "+
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (HIGH_RPM_SCORE * TOTAL_DURATION) else null end) /"+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as HIGH_RPM_SCORE, "+
	" count(DRIVER_ID) as NO_OF_TRIPS,isnull(sum(TOTAL_DISTANCE),0) as TOTAL_DISTANCE,isnull(sum(TOTAL_DURATION),0) as TOTAL_DURATION,0 as OVERALL_PERC, " +
	" isnull(avg(AVG_SPEED_EXCL_STOPPAGE),0) as AVG_SPEED,isnull(cast(cast(AVG(CASE WHEN (MILEAGE>0 and MILEAGE < 10) THEN MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as AVG_MILAGE, "+
	" isnull(cast(cast(AVG(CASE WHEN (OBD_MILEAGE>0 and OBD_MILEAGE<10) THEN OBD_MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as AVG_OBD_MILAGE, "+ 	  
	" cast((isnull(sum(case when isNull(OTP_STATUS,0)='ontime'  then 1 else 0 end),0)/cast(count(DRIVER_ID) as float))*100 as numeric(18,2)) as ON_TIME_PERFORMANCE , "+ 
	" isnull(sum(HA_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HA_COUNT,isnull(sum(HB_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HB_COUNT, "+
	" isnull(sum(HC_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HC_COUNT,isnull(sum(OVERSPEED_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as OVERSPEED_COUNT, "+
	" isnull(sum(OVER_REVV_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as OVER_REVV_COUNT,isnull(sum(UNSCHLD_STOP_DUR * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as UNSCHLD_STOP_DUR, "+
	" isnull(sum(EXCESS_IDLE_DUR * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as EXCESS_IDLE_DUR,isnull(sum(GREEN_BAND_SPEED_DUR * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as GREEN_BAND_SPEED_DUR, "+
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) then (FREE_WHEEL_DUR * TOTAL_DURATION) else null end) /"+ 
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) then TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'NA') as FREE_WHEEL_DUR, "+
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (GREEN_BAND_RPM_DUR * TOTAL_DURATION) ELSE NULL END) / "+
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (TOTAL_DURATION) ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as GREEN_BAND_RPM_DUR, "+
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (LOW_RPM_DUR * TOTAL_DURATION) ELSE NULL END) /"+ 
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (TOTAL_DURATION) ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as LOW_RPM_DUR, "+
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (HIGH_RPM_DUR * TOTAL_DURATION) ELSE NULL END) /"+
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (TOTAL_DURATION) ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as HIGH_RPM_DUR, "+
	" isnull(cast(cast(AVG(CASE WHEN (MILEAGE>0 and MILEAGE < 10) THEN MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as MILEAGE, "+
	" isnull(cast(cast(AVG(CASE WHEN (OBD_MILEAGE>0 and OBD_MILEAGE < 10) THEN OBD_MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),'NA') as OBD_MILEAGE "+  
	" from AMS.dbo.TRIP_DRIVER_DETAILS a "+
	" LEFT OUTER join AMS.dbo.Driver_Master d on d.Driver_id=a.DRIVER_ID and Client_id=CUSTOMER_ID "+
	" where SYSTEM_ID=? and CUSTOMER_ID=? and DRIVER_ID != 0 and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) #"+
	" group by DRIVER_ID,d.EmployeeID,d.Fullname order by d.Fullname";
	
	public static final String GET_CUSTOMERS_BY_TYPE = "select isNull(NAME,'') as NAME,ID from AMS.dbo.TRIP_CUSTOMER_DETAILS "+
	" where SYSTEM_ID=? AND CUSTOMER_ID=? and TYPE =? ";

	public static final String GET_CUSTOMER_TYPE = "select TYPE from AMS.dbo.CUSTOMER_TYPE where SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_IATA_CODE = " SELECT AIRPORT_CODE FROM ADMINISTRATOR.dbo.IATA_CODE_DETAILS where CITY=? ";

	public static final String GET_IRCTC_CODE = "SELECT STATION_NAME, STATION_CODE FROM ADMINISTRATOR.dbo.IRCTC_CODE_DETAILS where STATION_NAME=?";
	
	public static final String GET_CITY_COUNT_FROM_LOOKUP_DETAILS = " SELECT ROUTE_COUNT FROM AMS.dbo.ROUTE_LOOKUP_DETAILS WHERE SYSTEM_ID =? AND CUSTOMER_ID = ? AND TRIP_CUST_ID=? and CITY_CODE=?";

	public static final String UPDATE_ROUTE_COUNT_IN_LOOKUP_DETAILS = " update AMS.dbo.ROUTE_LOOKUP_DETAILS set ROUTE_COUNT=? WHERE SYSTEM_ID =? AND CUSTOMER_ID = ? AND TRIP_CUST_ID=? and CITY_CODE=? " ;

	public static final String INSERT_INTO_ROUTE_LOOKUP_DETAILS = " insert into AMS.dbo.ROUTE_LOOKUP_DETAILS(ROUTE_COUNT,SYSTEM_ID,CUSTOMER_ID,TRIP_CUST_ID,CITY_CODE) values (?,?,?,?,?) ";

	public static final String GET_CUSTOMER_NAME = " SELECT NAME,SUBSTRING(NAME,1,(CHARINDEX(' ',NAME + ' ')-1)) as CUST_NAME from AMS.dbo.TRIP_CUSTOMER_DETAILS where ID = ?";

	public static final String GET_HUB_COUNT_FROM_LOOKUP_DETAILS = " SELECT HUB_COUNT FROM AMS.dbo.ROUTE_LOOKUP_DETAILS WHERE SYSTEM_ID =? AND CUSTOMER_ID = ? AND TRIP_CUST_ID=? and CITY_CODE=? ";

	public static final String UPDATE_HUB_COUNT_IN_LOOKUP_DETAILS = " update AMS.dbo.ROUTE_LOOKUP_DETAILS set HUB_COUNT=? WHERE SYSTEM_ID =? AND CUSTOMER_ID = ? AND TRIP_CUST_ID=? and CITY_CODE=? "; 
	
	public static final String INSERT_INTO_HUB_LOOKUP_DETAILS = " insert into AMS.dbo.ROUTE_LOOKUP_DETAILS(HUB_COUNT,SYSTEM_ID,CUSTOMER_ID,TRIP_CUST_ID,CITY_CODE) values (?,?,?,?,?) ";

	public static final String GET_CITY_NAME = "select HUB_CITY from AMS.dbo.LOCATION lz where HUBID=?";

	public static final String GET_HUB_NAME = "select ISNULL(td.NAME,'') as CUST_NAME,isnull(Standard_Duration,0) as DETENTION,lz.NAME,RADIUS from AMS.dbo.LOCATION lz " +
	" left outer join AMS.dbo.TRIP_CUSTOMER_DETAILS td on td.ID=lz.TRIP_CUSTOMER_ID " +
	" where HUBID=?";
	
	public static final String GET_LEG_REPORT_FOR_DRIVER_SCORE =" select DRIVER_ID,isnull(dm.EmployeeID,'') as EMP_ID,isnull(dm.Fullname,'') as NAME," +
	" isnull(td.SHIPMENT_ID,'') as TRIP_ID,'TRIP_NAME' as TRIP_NAME,isnull(td.ROUTE_ID,'') as ROUTE_ID,isnull(td.ROUTE_NAME,'') as ROUTE_NAME," +
	" isnull(td.ORDER_ID,'') as TRIP_LR_NO,isnull(td.ASSET_NUMBER,'') as VEHICLE_NUMBER,isnull(tvm.VehicleType,'') as VEHICLE_TYPE," +
	" isnull(vm.ModelName,'') as MODEL_NAME,isnull(td.CUSTOMER_REF_ID,'') as CUSTOMER_REF_ID,isnull(td.CUSTOMER_NAME,'') as CUSTOMER_NAME, " +
	" a.LEG_ID,isnull(lm.LEG_NAME,'') as LEG_NAME,isnull(td.START_LOCATION,'') as ORIGIN,isnull(td.END_LOCATION,'') as DESTINATION," +
	" isnull(td.TRIP_START_TIME,'') as STD,isnull(td.ACTUAL_TRIP_START_TIME,'') as  ATD,isnull(td.DESTINATION_ETA,'') as ETA," +
	" isnull(td.TRIP_END_TIME,'') as STA,isnull(td.ACTUAL_TRIP_END_TIME,'') as ATA,isnull(td.DELAY,'') as DELAY,isnull(a.TOTAL_DISTANCE,0) as TOTAL_DISTANCE," +
	" isnull(a.TOTAL_DURATION,0) as TOTAL_DURATION,isnull(td.STOPPAGE_DURATION,0) as STOPPAGE_DURATION,isnull(a.GREEN_BAND_SPEED_DUR,0) as GREEN_BAND_SPEED_DUR," +
	" isnull(a.GREEN_BAND_RPM_DUR,0) as GREEN_BAND_RPM_DUR,isnull(a.FUEL_CONSUMED,0) as FUEL_CONSUMED,isnull(a.HA_COUNT,0) as HA_COUNT,isnull(a.HB_COUNT,0) as HB_COUNT," +
	" isnull(cast(cast((CASE WHEN (a.MILEAGE>0 and a.MILEAGE < 10) THEN a.MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),0) as LLS_MILEAGE, "+
	" isnull(cast(cast((CASE WHEN (a.OBD_MILEAGE>0 and a.OBD_MILEAGE < 10) THEN a.OBD_MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),0) as OBD_MILEAGE," +
	" isnull(a.HC_COUNT,0) as HC_COUNT,isnull(a.OVERSPEED_COUNT,0) as OVERSPEED_COUNT,isnull(a.FREE_WHEEL_DUR,0) as FREE_WHEEL_DUR,isnull(a.UNSCHLD_STOP_DUR,0) as UNSCHEDULED_STOP, " +
	" isnull(a.EXCESS_IDLE_DUR,0) as EXCESS_IDLE_DUR, isnull(a.LOW_RPM_DUR,0) as LOW_RPM_DUR , isnull(a.HIGH_RPM_DUR,0) as HIGH_RPM_DUR, " +
	" isnull(a.OVER_REVV_COUNT,0) as OVER_REVV_COUNT,isnull(a.FINAL_SCORE,0) as FINAL_SCORE,isnull(a.HA_SCORE,0) as HA_SCORE,isnull(a.HB_SCORE,0) as HB_SCORE," +
	" isnull(a.HC_SCORE,0) as HC_SCORE,isnull(a.OVER_SPEED_SCORE,0) as OVER_SPEED_SCORE,isnull(a.FREE_WHEEL_SCORE,0) as FREE_WHEEL_SCORE," +
	" isnull(a.UNSCHDL_STOPPAGE_SCORE,0) as UNSCHDL_STOPPAGE_SCORE,isnull(a.IDLE_SCORE,0) as IDLE_SCORE,isnull(a.GREEN_BAND_SPEED_SCORE,0) as GREEN_BAND_SPEED_SCORE," +
	" isnull(a.GREEN_BAND_RPM_SCORE,0) as GREEN_BAND_RPM_SCORE,isnull(a.LOW_RPM_SCORE,0) as LOW_RPM_SCORE,isnull(a.HIGH_RPM_SCORE,0) as HIGH_RPM_SCORE," +
	" isnull(a.OVER_REVV_SCORE,0) as OVER_REVV_SCORE,isnull(a.AVG_SPEED_EXCL_STOPPAGE,0) AVG_SPEED,0 as W_AVG_SPEED" +
	" from AMS.dbo.TRIP_DRIVER_DETAILS a " +
	" INNER join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=a.TRIP_ID " +
	" LEFT OUTER join AMS.dbo.Driver_Master dm on dm.Driver_id=a.DRIVER_ID and dm.Client_id=a.CUSTOMER_ID " +
	" LEFT OUTER join AMS.dbo.tblVehicleMaster tvm on td.ASSET_NUMBER = tvm.VehicleNo and tvm.System_id = td.SYSTEM_ID " +
	" LEFT OUTER join FMS.dbo.Vehicle_Model vm on vm.ModelTypeId = tvm.Model and tvm.System_id = vm.SystemId " +
	" LEFT OUTER join AMS.dbo.LEG_MASTER lm on a.LEG_ID = lm.ID and a.SYSTEM_ID = lm.SYSTEM_ID " +
	" where DRIVER_ID!=0 and a.SYSTEM_ID=? and a.CUSTOMER_ID=? # and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?)" +
	" union all " +
	" select  DRIVER_ID,isnull(dm.EmployeeID,'') as EMP_ID,isnull(dm.Fullname,'') as NAME,'' as TRIP_ID,'' as TRIP_NAME,'' as ROUTE_ID,'' as ROUTE_NAME, '' as TRIP_LR_NO,  " +
	" '' as VEHICLE_NUMBER,'' as VEHICLE_TYPE,'' as MODEL_NAME,'' as CUSTOMER_REF_ID,'' as CUSTOMER_NAME,count(a.LEG_ID),'' as LEG_NAME,'' as ORIGIN," +
	" '' as DESTINATION,'' as STD,'' as ATD,'' as ETA,'' as STA,'' as ATA,sum(isnull(td.DELAY,0)),sum(TOTAL_DISTANCE),sum(TOTAL_DURATION), " +
	" isnull(SUM(STOPPAGE_DURATION * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as STOPPAGE_DURATION," +
	" isnull(sum(GREEN_BAND_SPEED_DUR * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as GREEN_BAND_SPEED_DUR, " +
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (GREEN_BAND_RPM_DUR * TOTAL_DURATION) ELSE NULL END) / "+
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (TOTAL_DURATION) ELSE NULL END) as numeric(18,2)) as varchar(10)),0) as GREEN_BAND_RPM_DUR,"+
	" isnull(cast(cast(AVG(CASE WHEN (a.MILEAGE>0 and a.MILEAGE < 10) THEN a.MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),0) as LLS_MILEAGE, "+
	" isnull(cast(cast(AVG(CASE WHEN (a.OBD_MILEAGE>0 and a.OBD_MILEAGE<10) THEN a.OBD_MILEAGE ELSE NULL END) as numeric(18,2)) as varchar(10)),0) as OBD_MILAGE, " +
	" sum(a.FUEL_CONSUMED),isnull(sum(HA_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HA_COUNT,isnull(sum(HB_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HB_COUNT, " +
	" isnull(sum(HC_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HC_COUNT,isnull(sum(OVERSPEED_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as OVERSPEED_COUNT, " +
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) then (FREE_WHEEL_DUR * TOTAL_DURATION) else null end) /  " +
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) then TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'0') as FREE_WHEEL_DUR, " +
	" isnull(sum(UNSCHLD_STOP_DUR * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as UNSCHLD_STOP_DUR,isnull(sum(EXCESS_IDLE_DUR * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as EXCESS_IDLE_DUR,  " +
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (LOW_RPM_DUR * TOTAL_DURATION) ELSE NULL END) / " +
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (TOTAL_DURATION) ELSE NULL END) as numeric(18,2)) as varchar(10)),'0') as LOW_RPM_DUR, " +
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (HIGH_RPM_DUR * TOTAL_DURATION) ELSE NULL END) / " +
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (TOTAL_DURATION) ELSE NULL END) as numeric(18,2)) as varchar(10)),'0') as HIGH_RPM_DUR, " +
	" isnull(sum(OVER_REVV_COUNT * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as OVER_REVV_COUNT,isnull(SUM(FINAL_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as TOTAL_SCORE, " +
	" isnull(sum(HA_SCORE * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HA_SCORE,isnull(sum(HB_SCORE * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HB_SCORE, " +
	" isnull(sum(HC_SCORE * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as HC_SCORE,isnull(sum(OVER_SPEED_SCORE * TOTAL_DURATION) / sum(TOTAL_DURATION),0) as OVER_SPEED_SCORE, " +
	" isnull(cast(cast(sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) then (FREE_WHEEL_SCORE * TOTAL_DURATION) else null end) /  " +
	" sum(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) then TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'0') as FREE_WHEEL_SCORE, " +
	" isnull(SUM(UNSCHDL_STOPPAGE_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as UNSCHDL_STOPPAGE_SCORE,isnull(SUM(IDLE_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as IDLE_SCORE, " +
	" isnull(SUM(GREEN_BAND_SPEED_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as GREEN_BAND_SPEED_SCORE, " +
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (GREEN_BAND_RPM_SCORE * TOTAL_DURATION) else null end) / "+
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),0) as GREEN_BAND_RPM_SCORE, "+
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (LOW_RPM_SCORE * TOTAL_DURATION) else null end) / " +
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'0') as LOW_RPM_SCORE, " +
	" isnull(cast(cast(SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN (HIGH_RPM_SCORE * TOTAL_DURATION) else null end) / " +
	" SUM(CASE WHEN (LOW_RPM_DUR>0 or HIGH_RPM_DUR>0 or GREEN_BAND_RPM_DUR>0) THEN TOTAL_DURATION else null end) as numeric(18,2)) as varchar(10)),'0') as HIGH_RPM_SCORE, " +
	" isnull(SUM(OVER_REVV_SCORE * TOTAL_DURATION )/SUM(TOTAL_DURATION),0) as OVER_REVV_SCORE, " +
	" 0 as AVG_SPEED,isnull(avg(AVG_SPEED_EXCL_STOPPAGE),0) as W_AVG_SPEED " +
	" from AMS.dbo.TRIP_DRIVER_DETAILS a " +
	" INNER join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=a.TRIP_ID " +
	" LEFT OUTER join AMS.dbo.Driver_Master dm on dm.Driver_id=a.DRIVER_ID and dm.Client_id=a.CUSTOMER_ID" +
	" LEFT OUTER join AMS.dbo.tblVehicleMaster tvm on td.ASSET_NUMBER = tvm.VehicleNo and tvm.System_id = td.SYSTEM_ID" +
	" LEFT OUTER join FMS.dbo.Vehicle_Model vm on vm.ModelTypeId = tvm.Model and tvm.System_id = vm.SystemId" +
	" LEFT OUTER join AMS.dbo.LEG_MASTER lm on a.LEG_ID = lm.ID and a.SYSTEM_ID = lm.SYSTEM_ID" +
	" where DRIVER_ID!=0 and a.SYSTEM_ID=? and a.CUSTOMER_ID=? and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) # " +
	" group by DRIVER_ID ,dm.EmployeeID,dm.Fullname";

	public static final String CHECK_DUPLICATE_ROUTE = " select * from AMS.dbo.TRIP_ROUTE_MASTER where ROUTE_NAME = ? and SYSTEM_ID=? and CUSTOMER_ID= ? AND TRIP_CUST_ID = ? ";
	
	public static final String GET_SMART_HUB_BUFFERS_TRIP_DELAY = "select isnull(Standard_Duration,0) as DETENTION,NAME,LONGITUDE,LATITUDE,RADIUS,IMAGE,isNull(HUBID,0) as HUBID,OPERATION_ID from LOCATION where  RADIUS>0 and CLIENTID=? and SYSTEMID=? and OPERATION_ID in (32) and TRIP_CUSTOMER_ID= ? " +
	" union all" +
	" select isnull(Standard_Duration,0) as DETENTION,NAME,LONGITUDE,LATITUDE,RADIUS,IMAGE,isNull(HUBID,0) as HUBID,OPERATION_ID from LOCATION where  RADIUS>0 and CLIENTID=? and SYSTEMID=? and OPERATION_ID in (33) and TRIP_CUSTOMER_ID= 0 ";
	
	public static final String GET_SMART_HUB_POLYGONS_TRIP_DELAY = " select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE,b.LATITUDE as LAT,b.LONGITUDE as LNG,b.OPERATION_ID from dbo.POLYGON_LOCATION_DETAILS a left outer join LOCATION_ZONE b on a.HUBID=b.HUBID where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and b.OPERATION_ID in (32) and TRIP_CUSTOMER_ID= ?"+ 
	" union all "+
	" select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE,b.LATITUDE,b.LONGITUDE,b.OPERATION_ID from dbo.POLYGON_LOCATION_DETAILS a left outer join LOCATION_ZONE b on a.HUBID=b.HUBID where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and b.OPERATION_ID in (33) and TRIP_CUSTOMER_ID= 0" +
	" order by a.HUBID,a.SEQUENCE_ID";
	
	public static final String GET_HUB = "select top 1 substring(NAME, PatIndex('%[0-9]%', NAME), len(NAME)) as number,isnull(Standard_Duration,0) as DETENTION,NAME," +
	" RADIUS from AMS.dbo.LOCATION lz where TRIP_CUSTOMER_ID=? and (NAME like ? or NAME like ?) order by HUBID desc";


	public static final String ACKNOWLEDGE_ON_TRIP_VEH_STOPPAGE = "";
	
	public static final String GET_SOURCE_DESTINATION_HUBS = " select OPERATION_ID,HUBID,lz.NAME,(lz.NAME+'-'+isnull(tcd.NAME,'')) as FULLHUBNAME,LATITUDE,LONGITUDE,RADIUS,isnull(Standard_Duration,0) as DETENTION,(case when datalength(lz.ADDRESS)=0 then lz.NAME else isnull(lz.NAME+' : '+lz.ADDRESS,lz.NAME) end) as HUB_ADDRESS from AMS.dbo.LOCATION_ZONE lz " +
	" left outer join dbo.TRIP_CUSTOMER_DETAILS tcd on tcd.SYSTEM_ID = lz.SYSTEMID and tcd.ID = lz.TRIP_CUSTOMER_ID " +
	" where CLIENTID=? and SYSTEMID=? and OPERATION_ID in (32) and (RADIUS >0 or RADIUS=-1) # "+ // and TRIP_CUSTOMER_ID = ? 
	" union all "+
	" select OPERATION_ID,HUBID,lz.NAME,(lz.NAME+'-'+isnull(tcd.NAME,'')) as FULLHUBNAME,LATITUDE,LONGITUDE,RADIUS,isnull(Standard_Duration,0) as DETENTION,(case when datalength(lz.ADDRESS)=0 then lz.NAME else isnull(lz.NAME+' : '+lz.ADDRESS,lz.NAME) end) as HUB_ADDRESS from AMS.dbo.LOCATION_ZONE lz " +
	" left outer join dbo.TRIP_CUSTOMER_DETAILS tcd on tcd.SYSTEM_ID = lz.SYSTEMID and tcd.ID = lz.TRIP_CUSTOMER_ID " +
	" where CLIENTID=? and SYSTEMID=? and OPERATION_ID in (999) and (RADIUS >0 or RADIUS=-1) and TRIP_CUSTOMER_ID = 0 " ; 
	
	public static final String GET_TRIP =  " select * from AMS.dbo.TRACK_TRIP_DETAILS td  where TRIP_ID=? " ;
	
	public static final String GET_TYPE = "select TYPE from TRIP_CUSTOMER_DETAILS where ID=?";
	
	public static final String GET_GENERIC_HUB_NAME = "select isnull(Standard_Duration,0) as DETENTION,lz.NAME,RADIUS from AMS.dbo.LOCATION lz " +
	" where HUBID=?";

	public static final String GET_USER_AUDIT_LOG_REPORT = " select isnull(t.NAME,'') as NAME,UPDATED_DATETIME,isnull(lz.NAME,'') as HUB_NAME,PREV_LATITUDE,PREV_LONGITUDE,PRESENT_LATITUDE,PRESENT_LONGITUDE, "+
	" isnull(u.Firstname,'') as FIRSTNAME,isnull(u.Lastname,'') as LASTNAME from ADMINISTRATOR.dbo.USER_LOG_DETAILS a "+
	" left outer join AMS.dbo.LOCATION lz on lz.HUBID=a.HUB_ID "+
	" left outer join AMS.dbo.TRIP_CUSTOMER_DETAILS t on t.ID=a.TRIP_CUST_ID "+
	" left outer join AMS.dbo.Users u on a.UPDATED_BY=u.User_id and a.SYSTEM_ID=u.System_id "+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? ## "+
	" and UPDATED_DATETIME between ? and ? " ;

	public static final String GET_OUTBOUND_SH_TRIPS = " select td.TRIP_ID as ID,isnull(td.STATUS,'') as status,isnull(td.TRIP_STATUS,'') as STATUS,isnull(td.ORDER_ID,'') as TRIP_NO,isnull(td.ASSET_NUMBER,'') as VEHICLE_NO, " +
	" dateadd(mi,?,isnull(ds.ACT_ARR_DATETIME,'')) as ATA@SH,dateadd(mi,?,isnull(ds.ACT_DEP_DATETIME,'')) as ATD@SH,datediff(mi,ds.ACT_ARR_DATETIME,ds.ACT_DEP_DATETIME)-DETENTION_TIME as EXCESS_DETENTION, " +
	" td.INSERTED_TIME,ISNULL(td.STATUS,'') as status, isnull(td.ROUTE_ID,0) as routeId, "  +
    " (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,330,getutcdate())else dateadd(mi,330,td.ACTUAL_TRIP_END_TIME) end) as endDate " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID " +
	" where ds.SEQUENCE not in (0,100) and ds.ACT_ARR_DATETIME is not null and ds.ACT_DEP_DATETIME is not null " +
	" and td.SYSTEM_ID=? and CUSTOMER_ID= ? $$ ## ";

	public static final String GET_INBOUND_SH_TRIPS = " select isnull(td.STATUS,'') as status,ds.SEQUENCE as SEQUENCE,td.TRIP_ID as ID,isnull(td.TRIP_STATUS,'') as STATUS,isnull(td.ORDER_ID,'') as TRIP_NO,isnull(td.ASSET_NUMBER,'') as VEHICLE_NO, " +
	" isnull(td.SHIPMENT_ID,'') as TRIP_ID,isnull(dateadd(mi,330,ds.ETA_ARR_DATETIME),'') as ETA, " +
	" case when dsp.ACT_DEP_DATETIME is null then ds.PLANNED_ARR_DATETIME else dateadd(mi,ds.STD_TIME,dsp.ACT_DEP_DATETIME) end as STA_WRT_STD, " +
	" datediff(mi,ds.PLANNED_ARR_DATETIME,isnull(ds.ACT_ARR_DATETIME,ds.ETA_ARR_DATETIME)) as DELAY, " +
	" td.INSERTED_TIME,ISNULL(td.STATUS,'') as status, isnull(td.ROUTE_ID,0) as routeId, "  +
    " (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,330,getutcdate())else dateadd(mi,330,td.ACTUAL_TRIP_END_TIME) end) as endDate " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID AND ds.SEQUENCE not in (0,100) " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS dsp on dsp.TRIP_ID=td.TRIP_ID and dsp.SEQUENCE=ds.SEQUENCE-1 " +
	" where ds.ACT_DEP_DATETIME is null and ds.ACT_ARR_DATETIME is null " +
	" and td.SYSTEM_ID=? and CUSTOMER_ID= ? $$ ## ";

	public static final String GET_OUTBOUND_ORIGIN_TRIPS = " select td.TRIP_ID as ID,isnull(td.STATUS,'') as status,isnull(td.ASSET_NUMBER,'') as VEHICLE_NO,isnull(td.TRIP_STATUS,'') as STATUS," +
		" isnull(td.SHIPMENT_ID,'') as TRIP_ID,isnull(td.ORDER_ID,'') as TRIP_NO, " +
		" dateadd(mi,?,isnull(ds.ACT_ARR_DATETIME,'')) as ATP,isnull(datediff(mi,ds.PLANNED_ARR_DATETIME,ds.ACT_ARR_DATETIME),0)  as PLACEMENT_DELAY, " +
		" isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as ATD,isnull(NEXT_POINT,'') AS NEXT_TOUCH_POINT,isnull(dateadd(mi,?,DESTINATION_ETA),'') AS DESTINATION_ETA, " +
		" isnull(dateadd(mi,?,isnull(td.DEST_ARR_TIME_ON_ATD,ds.PLANNED_ARR_DATETIME)),'') as STA_WRT_ATD, " +
		" dateadd(mi,?,isnull(ds100.ACT_ARR_DATETIME,'')) as ATA, " +
		" td.INSERTED_TIME,ISNULL(td.STATUS,'') as status, isnull(td.ROUTE_ID,0) as routeId, "  +
	    " (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,330,getutcdate())else dateadd(mi,330,td.ACTUAL_TRIP_END_TIME) end) as endDate " +
		" from AMS.dbo.TRACK_TRIP_DETAILS td " +
		" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=0 " +	
		" left outer join AMS.dbo.DES_TRIP_DETAILS ds100 on ds100.TRIP_ID=td.TRIP_ID and ds100.SEQUENCE=100 " +
		" where ds.HUB_ID in (select HUBID from  AMS.dbo.LOCATION where PINCODE in " +
		" (select PINCODE from SMARTHUB_PINCODE_DETAILS ## )) " +
		" and td.SYSTEM_ID=? and CUSTOMER_ID= ? $$ ";

	public static final String GET_INBOUND_DESTINATION_TRIPS = " select isnull(td.STATUS,'') as status,td.TRIP_ID as ID,isnull(td.ASSET_NUMBER,'') as VEHICLE_NO,isnull(td.TRIP_STATUS,'') as STATUS," +
		" isnull(td.SHIPMENT_ID,'') as TRIP_ID,isnull(td.ORDER_ID,'') as TRIP_NO, "+
		" isnull(dateadd(mi,330,td.DESTINATION_ETA),'') AS ETA_HH_MM, "+
		" isnull(dateadd(mi,?,isnull(td.DEST_ARR_TIME_ON_ATD,'')),'') as STA_WRT_ATD, datediff(mi,DEST_ARR_TIME_ON_ATD,DESTINATION_ETA) as DELAY, "+
		" td.INSERTED_TIME,ISNULL(td.STATUS,'') as status, isnull(td.ROUTE_ID,0) as routeId, "  +
	    " (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,330,getutcdate())else dateadd(mi,330,td.ACTUAL_TRIP_END_TIME) end) as endDate " +
		" from AMS.dbo.TRACK_TRIP_DETAILS td "+
		" left outer join AMS.dbo.DES_TRIP_DETAILS ds100 on ds100.TRIP_ID=td.TRIP_ID and ds100.SEQUENCE=100 "+
		" where ds100.HUB_ID in (select HUBID from AMS.dbo.LOCATION where PINCODE in  "+
		" (select PINCODE from SMARTHUB_PINCODE_DETAILS ##)) "+
		" and td.SYSTEM_ID=? and CUSTOMER_ID= ? $$ ";

	public static final String GET_SMARTHUB_DETAILS  = " select NAME,HUBID from AMS.dbo.LOCATION where SYSTEMID=? and CLIENTID=? and OPERATION_ID=33 and NAME like 'SH_%' ";

	public static final String GET_ENROUTE_DETAILS = " select isnull(datediff(mi,ACT_ARR_DATETIME,ACT_DEP_DATETIME) - DETENTION_TIME,-9999) as DELAY from DES_TRIP_DETAILS where TRIP_ID=? and SEQUENCE not in (0,100)";

	public static final String GET_SH_ENROUTE_DETAILS = " select isnull(datediff(mi,ACT_ARR_DATETIME,ACT_DEP_DATETIME) - DETENTION_TIME,-9999) as DELAY from DES_TRIP_DETAILS where TRIP_ID=? and SEQUENCE not in (0,100) and SEQUENCE < ? and NAME not like 'SH_%' ";
	
	public static final String GET_TRIP_CUSTOMER_TYPE_FROM_LOOKUP_DETAILS = " select VALUE,LABEL from AMS.dbo.LOOKUP_DETAILS where VERTICAL = 'TRIP_CUSTOMER_TYPE' order by ORDER_OF_DISPLAY ";

	public static final String GET_TRIPS= " select TRIP_ID,isnull(ORDER_ID,'') as TRIP_NAME,(isnull(ORDER_ID,'')+'-('+isnull(SHIPMENT_ID,'')+')') as TRIP_NAME_1 " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS in ('CLOSED','CANCEL') AND PRODUCT_LINE='TCL' ## && order by TRIP_ID desc ";
	
	public static final String GET_TRIP_DETAILS = " select t.NAME,td.TRIP_ID,td.ORDER_ID as TRIP_NO,isnull(SHIPMENT_ID,'') as TRIP_NAME,ASSET_NUMBER,td.STATUS as STATUS," +
	" isnull(dateadd(mi,&&,ACT_SRC_ARR_DATETIME),case when INSERTED_TIME>d0.PLANNED_ARR_DATETIME then dateadd(mi,&&,d0.PLANNED_ARR_DATETIME) else dateadd(mi,&&,INSERTED_TIME) end) as STD,   " +
	" dateadd(mi,&&,td.ACTUAL_TRIP_END_TIME) as END_DATE " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	" left outer join AMS.dbo.[DES_TRIP_DETAILS] d0 on d0.TRIP_ID= td.TRIP_ID and d0.SEQUENCE=0 " +
	" left outer join TRIP_CUSTOMER_DETAILS t on t.ID=td.TRIP_CUSTOMER_ID " +
	" ## order by td.TRIP_ID desc " ;
	
	public static final String GET_DASHBOARD_COUNTS = " select * from TRIP_DASHBOARD_COUNTS(nolock) where SYSTEM_ID=? and CUSTOMER_ID=? " ;
	
	public static final String GET_SWIPED_DATA =
	" select DRIVER_ID,REGISTRATION_NO,DATETIME,isnull(Fullname,'NA') as Driver_name,isnull(DriverCodeFromUnit,'NA') as Driver_key  from "+
	" (select DRIVER_ID,REGISTRATION_NO,dateadd(mi,?,GMT) as DATETIME,PACKET_TYPE,CLIENTID "+
	" from # "+
	" where GMT between ? and ? and REGISTRATION_NO in (select REGISTRATION_NO from gpsdata_history_latest where CLIENTID=?) "+
	" union all "+
	" select DRIVER_ID,REGISTRATION_NO,dateadd(mi,?,GMT) as DATETIME,PACKET_TYPE,CLIENTID "+
	" from $  where  GMT between ? and ? and REGISTRATION_NO in (select REGISTRATION_NO from gpsdata_history_latest where CLIENTID=?) "+
	" ) t left outer join Driver_Master "+
	" on DriverCodeFromUnit=DRIVER_ID  where   DRIVER_ID is not null order by DATETIME ";


	public static final String GET_LISTVIEW_TRIP_DETAILS = " select isnull((select 'Location Of Delay: '+dhl.LOCATION_OF_DELAY+', Delay Startime: '+convert(varchar,dhl.STARTDATE,120)+',Delay Endtime: '+convert(varchar,dhl.ENDDATE,120)+',Delay Duration: '+dhl.DELAYTIME+', Issue Type: '+dhl.ISSUETYPE+', Sub Issue Type: '+dhl.SUBISSUE_TYPE+', Remarks: '+dhl.REMARKS from AMS.dbo.TRIP_REMARKS_DETAILS dhl where dhl.TRIP_ID=td.TRIP_ID and INSERTED_DATETIME=(select max(INSERTED_DATETIME) from TRIP_REMARKS_DETAILS where TRIP_ID=td.TRIP_ID) ),'') as REASON,* " +
			"from TRIP_DASHBOARD_DETAILS(nolock) tt left outer join TRACK_TRIP_DETAILS td on tt.TRIP_NO=td.TRIP_ID order by tt.TRIP_NO desc ";
	
	public static final String GET_GROUP_NAME = "select distinct GROUP_NAME from AMS. dbo.Live_Vision_Support where SYSTEM_ID=? and CLIENT_ID=? ";
	
	
	  public static final String GET_VEHICLE_TRIP_DETAILS = "SELECT vm.VehicleType,ASSET_NUMBER,dm.Fullname,dateadd(mi,?,ACTUAL_TRIP_START_TIME) as ACTUAL_TRIP_START_TIME," +
	  		" dateadd(mi,?,ACTUAL_TRIP_END_TIME) as ACTUAL_TRIP_END_TIME," +
	  		" START_ODOMETER,END_ODOMETER,datediff(mi,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME) as TOTAL_TRIP_MIN," +
	  		" ACTUAL_DISTANCE,SWIPE_COUNT,lvs.GROUP_NAME FROM TRACK_TRIP_DETAILS td " +
	        " INNER JOIN TRACK_TRIP_DETAILS_SUB ttds on td.TRIP_ID=ttds.TRIP_ID " +
	  		" inner join dbo.Live_Vision_Support lvs on lvs.REGISTRATION_NO=td.ASSET_NUMBER AND lvs.SYSTEM_ID=td.SYSTEM_ID and lvs.CLIENT_ID=td.CUSTOMER_ID "+
	        " LEFT OUTER JOIN Driver_Master dm on dm.Driver_id = ttds.DRIVER_ID " +
	         " left join tblVehicleMaster vm on vm.VehicleNo=td.ASSET_NUMBER " +
	       " WHERE # AND td.STATUS='CLOSED' AND ACTUAL_TRIP_END_TIME BETWEEN dateadd(mi,-?,?)" +
	       " AND  dateadd(mi,-?,?) AND td.SYSTEM_ID =? AND td.CUSTOMER_ID =? ";

	  public static final String GET_VEHICLE_TRIP_SUMMARY = "SELECT ASSET_NUMBER,"+
	       "count(td.TRIP_ID) AS TRIP_COUNT,sum(ACTUAL_DISTANCE) AS TOTAL_DISTANCE,sum(SWIPE_COUNT) AS SUM_PAS,"  +
		  " AVG(SWIPE_COUNT) AS AVG_PAS, AVG(ACTUAL_DISTANCE) AS AVG_DIS , avg(datediff(mi,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME))  AS AVG_TIME " +
	      " FROM TRACK_TRIP_DETAILS td " +
	      " INNER JOIN TRACK_TRIP_DETAILS_SUB ttds on td.TRIP_ID=ttds.TRIP_ID " +
	      " inner join dbo.Live_Vision_Support lvs on lvs.REGISTRATION_NO=td.ASSET_NUMBER AND lvs.SYSTEM_ID=td.SYSTEM_ID and lvs.CLIENT_ID=td.CUSTOMER_ID "+
	      " left join tblVehicleMaster vm on vm.VehicleNo=td.ASSET_NUMBER WHERE td.ASSET_NUMBER=? and td.STATUS='CLOSED' " +
	       " AND ACTUAL_TRIP_END_TIME BETWEEN dateadd(mi,-?,?) AND " +  
	       " dateadd(mi,-?,?) and td.SYSTEM_ID =? AND td.CUSTOMER_ID =? group by ASSET_NUMBER  ";
	  
	  public static final String GET_GROUP_TRIP_SUMMARY = "SELECT GROUP_NAME,"+
	  " count(td.TRIP_ID) AS TRIP_COUNT,sum(ACTUAL_DISTANCE) AS TOTAL_DISTANCE,sum(SWIPE_COUNT) AS SUM_PAS, " +
	  " AVG(SWIPE_COUNT) AS AVG_PAS, AVG(ACTUAL_DISTANCE) AS AVG_DIS ,avg(datediff(mi,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME))  AS AVG_TIME " +
	  " FROM TRACK_TRIP_DETAILS td " +
	  " INNER JOIN TRACK_TRIP_DETAILS_SUB ttds on td.TRIP_ID=ttds.TRIP_ID " +
	  " inner join dbo.Live_Vision_Support lvs on lvs.REGISTRATION_NO=td.ASSET_NUMBER AND lvs.SYSTEM_ID=td.SYSTEM_ID and lvs.CLIENT_ID=td.CUSTOMER_ID "+
	  " left join tblVehicleMaster vm on vm.VehicleNo=td.ASSET_NUMBER WHERE lvs.GROUP_NAME=? and td.STATUS='CLOSED' " +
	   " AND ACTUAL_TRIP_END_TIME BETWEEN dateadd(mi,-?,?) AND " +  
	   " dateadd(mi,-?,?) and td.SYSTEM_ID =? AND td.CUSTOMER_ID =? group by GROUP_NAME  ";
	  
	  public static final String GET_GEOFENCE_CORRECTION_DATA = "SELECT td.TRIP_ID, isnull(td.SHIPMENT_ID,'') as SHIPMENT_ID,isnull(td.ASSET_NUMBER, '') as ASSET_NUMBER, "+
		" isnull(td.ROUTE_NAME,'') as ROUTE_NAME,isnull(tcd.ID,'') as TRIP_CUST_ID, isnull(tcd.NAME,'') as TRIP_CUST_NAME, isnull(lza.NAME,'') hubName ," +
		" isnull(ORDER_ID,'') as LR_NO ,* "+
		" from dbo.GEOFENCE_CORRECTION_ALERT gca "+
		" INNER JOIN TRACK_TRIP_DETAILS td ON td.TRIP_ID=gca.TRIP_ID "+
		" LEFT OUTER JOIN TRIP_CUSTOMER_DETAILS tcd ON tcd.ID=td.TRIP_CUSTOMER_ID " +
		" LEFT OUTER JOIN LOCATION_ZONE lza ON gca.HUB_ID= lza.HUBID " +
		" WHERE gca.STATUS = 'Active' " ; 
	  
	  public static final String ACKNOWLEDGE_GEOFENCE_CORRECTION = "UPDATE GEOFENCE_CORRECTION_ALERT SET STATUS='Inactive',REMARKS=?,UPDATED_BY=?,UPDATED_DATETIME=GETDATE() WHERE ID=?";
	  
	  public static final String GET_TRIPS_WHOSE_ATA_IS_TO_BE_UPDATED = " SELECT ISNULL(ttd.ORDER_ID,'') AS ORDER_ID,DATEADD(MI,?,ttd.ACTUAL_TRIP_START_TIME) AS ACTUAL_TRIP_START_TIME," +
	  	" DATEADD(MI,?,ttd.ACTUAL_TRIP_END_TIME) AS ACTUAL_TRIP_END_TIME,ttd.ASSET_NUMBER,ttd.TRIP_STATUS,ttd.TRIP_ID " +
		" FROM AMS.dbo.TRACK_TRIP_DETAILS ttd INNER JOIN AMS.dbo.DES_TRIP_DETAILS des ON des.TRIP_ID = ttd.TRIP_ID AND SEQUENCE = 100 " +
		" WHERE ttd.ACTUAL_TRIP_START_TIME is not null and ttd.ACTUAL_TRIP_END_TIME IS NOT NULL AND des.ACT_ARR_DATETIME IS NULL AND " +
		" ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? and ttd.STATUS != 'CANCEL' and ttd.TRIP_CATEGORY != 'Empty Trip' and ttd.INSERTED_TIME > '2019-05-09 18:30:00'" +
		" ORDER BY TRIP_ID DESC";
	
	  public static final String UPDATE_ATA_OF_DES_TRIP_DETAILS_FOR_CLOSED_TRIP = " UPDATE AMS.dbo.DES_TRIP_DETAILS SET ACT_ARR_DATETIME = dateadd(mi,-?,?)," +
	  	"STATUS='COMPLETED' WHERE TRIP_ID = ? AND SEQUENCE = 100 ";

	  public static final String UPDATE_ATA_OF_TRIP_LEG_DETAILS_FOR_CLOSED_TRIP = "UPDATE AMS.dbo.TRIP_LEG_DETAILS SET ACTUAL_ARRIVAL = dateadd(mi,-?,?) " +
	  	"WHERE TRIP_ID = ? AND ID = (SELECT TOP 1 ID FROM AMS.dbo.TRIP_LEG_DETAILS WHERE TRIP_ID = ? ORDER BY ID desc)";
	  
	  public static final String UPDATE_TRACK_TRIP_DETAILS_ON_ATA_UPDATE_FOR_CLOSED_TRIP = "UPDATE AMS.dbo.TRACK_TRIP_DETAILS SET REPORT_BUILDER = NULL  WHERE TRIP_ID = ? ";
	 
	  public static final String DELETE_REPORT_BUILDER_DETAILS = " DELETE FROM AMS.dbo.REPORT_BUILDER_DETAILS WHERE TRIP_ID = ? ";
	  
	  public static final String GET_API_DETAILS = "select URL,AUTH from API_CONFIGURATION_DETAILS where API_TYPE=?";
	  
	 public static final String GET_ROUTE_ID_AND_VEHICLE_NUMBER_BY_TRIP_ID = "SELECT td.ROUTE_ID,ASSET_NUMBER,ORDER_ID,ROUTE_NAME,ACTUAL_TRIP_END_TIME," +
		" isnull(de.NAME,'') as NAME,tds.TRIP_STATUS,isnull(td.TRIP_CUSTOMER_TYPE,'') as tripCustType,isnull(de.SUCCESSOR_ID,'') as successorId " +
		" FROM dbo.TRACK_TRIP_DETAILS (nolock) td"+
		" left outer join DES_TRIP_DETAILS (nolock) de on de.TRIP_ID=td.TRIP_ID and de.SEQUENCE=100"+
		" left outer join dbo.TRACK_TRIP_DETAILS_SUB (nolock) tds on tds.TRIP_ID=td.TRIP_ID"+
		" WHERE td.TRIP_ID = ? AND SYSTEM_ID = ? AND CUSTOMER_ID = ?";
	
	public static final String GET_TRIP_LEG_DETAILS = "select LEG_ID, ACTUAL_ARRIVAL from TRIP_LEG_DETAILS where TRIP_ID = ? ";

	public static final String UPDATE_SLA_TRIP_WISE_ATA = "update AMS.dbo.SLA_REPORT set ATA=? where TRIP_ID=? and SEQUENCE=999 ";

	public static final String UPDATE_SLA_LEG_WISE_ATA = "update AMS.dbo.SLA_REPORT set ATA=? where ID =(select top 1 ID from SLA_REPORT where TRIP_ID = ? and RECORD_TYPE='LEG' order by ID desc)";

	public static final String GET_BOOSTER_MODE_DETAILS = " select isnull(gps.REGISTRATION_NO, '') as registrationNo, isnull(gps.LOCATION,'') as location, dateadd(mi,?,gdlc.GMT) as alretDate from  dbo.GPSDATA_LIVE_CANIQ gdlc "+
	" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=gdlc.REGISTRATION_NO "+
	" inner join AMS.dbo.Vehicle_User vu on vu.System_id=gdlc.System_id and vu.Registration_no=gdlc.REGISTRATION_NO COLLATE DATABASE_DEFAULT and vu.User_id=? "+ 
	" where gdlc.System_id = ? and gdlc.CLIENTID = ? and gdlc.GEAR not in (0,1,2)";

	public static final String GET_TRIP_LOG_dETAILS = " select td.TRIP_ID as TRIP_ID,td.ORDER_ID as TRIP_NO,PAGE_NAME,ACTION,isnull(u.Firstname,'')+' '+isnull(u.Lastname,'') as USER_NAME," +
	" dateadd(mi,?,INSERTED_DATETIME) as INSERTED_DATETIME,isnull(ald.REMARKS,'') as REMARKS " +
	" from ADMINISTRATOR.[dbo].[AUDIT_LOG_DETAILS] ald " +
	" left outer join AMS.dbo.TRACK_TRIP_DETAILS td on td.TRIP_ID=ald.TRIP_ID " +
	" left outer join AMS.dbo.Users u on u.User_id=ald.USER_ID and u.System_id=ald.SYSTEM_ID " +
	" where ald.SYSTEM_ID=? and ald.CUSTOMER_ID=? and ald.PAGE_NAME in ('Trip Solution :- Closing Trip','Trip Solution :- Update Actuals','Trip Solution :- Override Actuals')" +
	" and INSERTED_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by ID desc ";


	public static final String GET_DRIVER_DETAILS_BY_ID = "select isnull(SUBSTRING(NAME,1,CHARINDEX(',',NAME)-1),'') as NAME,l.HUBID," +
	" isnull(Fullname,'') as DriverName,isnull(EmployeeID,'') as EmployeeId,(select isnull(sum(FINAL_SCORE*CONVERT(NUMERIC(18, 2)," +
	" TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0))/ SUM(CONVERT(NUMERIC(18, 2), TOTAL_DURATION / 60 + (TOTAL_DURATION % 60) / 100.0)),0) as TOTAL_SCORE " +
	" from AMS.dbo.TRIP_DRIVER_DETAILS where CUSTOMER_ID=? and DRIVER_ID=? and END_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?)) as periodScore " +
	" from Driver_Master d"+
	" left outer join LOCATION_ZONE_A l on l.HUBID=d.RESPONSIBLE_LOCATION"+
	" where Client_id=? and Driver_id=?";


	public static final String UPDATE_DRIVER_REMARKS = "insert into DRIVER_REMARKS_DETAILS(DRIVER_ID,DRIVER_NAME,HUB_ID,HUB_NAME,REMARKS," +
			"SCORE,ADDED_DATETIME,ADDED_BY,SYSTEM_ID,CLIENT_ID) values (?,?,?,?,?,?,getutcdate(),?,?,?)";


	public static final String GET_TRAINING_REMARKS_DETAILS = "select DRIVER_NAME,HUB_NAME,REMARKS,SCORE,isnull(u.Firstname,'')+' '+isnull(u.Lastname,'') as userName"+
	" from DRIVER_REMARKS_DETAILS dr"+
	" left outer join Users u on u.User_id=dr.ADDED_BY and u.System_id=dr.SYSTEM_ID"+
	" where CLIENT_ID=? and DRIVER_ID=? order by ID";


	public static final String GET_DRIVER_PARAMETER_COUNTS = "";
}
