package t4u.statements;

public class DashBoardStatements {
	
	public static final String LOW_FUEL_ALERT_ID = "193";
	public static final String LOW_BATTERY_ALERT_ID = "183";
	public static final String OVER_SPEED_ALERT_ID = "2";
	public static final String COOLANT_TEMP_ALERT_ID = "159";
	
public static final String GET_DISTRESS_ALERT="select count(a.REGISTRATION_NO) as COUNT from ALERT.dbo.PANIC_DATA a "+  
"inner join AMS.dbo.Vehicle_User v on a.SYSTEM_ID=v.System_id and a.REGISTRATION_NO = v.Registration_no collate database_default "+  
"where GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and a.CUSTOMER_ID=?  and a.SYSTEM_ID=? and v.User_id=? and REMARK is null ";

public static final String GET_OVERSPEED_ALERT="select count(REGISTRATION_NO) as OVERSPEED_COUNT from ALERT.dbo.OVER_SPEED_DATA (NOLOCK) where GMT between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and CUSTOMER_ID=? and SYSTEM_ID=? ";

public static final String GET_VEHICLE_IDLE="select count(REGISTRATION_NO) as VEHICLE_IDLE_COUNT from dbo.Alert (NOLOCK) where TYPE_OF_ALERT=39 and   GMT between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and CLIENTID=? and SYSTEM_ID=? ";

//public static final String GET_TOTAL_NO_VEHICLES="select count(REGISTRATION_NUMBER) as  VEHICLE_COUNT from dbo.VEHICLE_CLIENT where CLIENT_ID=? and SYSTEM_ID=?";

public static final String GET_TOTAL_NO_VEHICLES_FOR_LTSP="select count(a.REGISTRATION_NO) as VEHICLE_COUNT from dbo.gpsdata_history_latest a " +
								" inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 
								+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
								+"where a.CLIENTID=? and a.System_id=? and b.User_id=?";

public static final String GET_TOTAL_NO_VEHICLES_FOR_CLIENT="select count(a.REGISTRATION_NO) as VEHICLE_COUNT from dbo.gpsdata_history_latest a " +
								" inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 
								+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id  and Status='Active' "
								+"where a.CLIENTID=? and a.System_id=? and b.User_id=?";

//public static final String GET_NON_COMMUNICATING="select count(REGISTRATION_NO) as NON_COMMUNICATING from  gpsdata_history_latest (nolock) where CLIENTID=? and System_id=? and LOCATION !='No GPS Device Connected' and DATEDIFF(hh,GMT,getutcdate()) >= 6";

public static final String GET_NON_COMMUNICATING_FOR_LTSP="select count(a.REGISTRATION_NO) as NON_COMMUNICATING from dbo.gpsdata_history_latest a " +
								"inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	
								+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
								+"where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= 6 and b.User_id=?";

public static final String GET_NON_COMMUNICATING_FOR_CLIENT="select count(a.REGISTRATION_NO) as NON_COMMUNICATING from dbo.gpsdata_history_latest a " +
								"inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	
								+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id  and Status='Active' "
								+"where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= 6 and b.User_id=?";

public static final String FIRST_LADY_PICKUP="select count(ACCTripId) as LADY_PICKUP from dbo.BPO_Trip_Details where GenderFlag='Y'and InsertedDateTime  between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and ClientId=? and SystemId=?";

public static final String HID_NOT_SWIPED="select SUM(r.HID_COUNT) as HID_COUNTS from (select count(a.EID) as HID_COUNT from dbo.BPO_DailyDetails a where a.Radius is null and  a.SwipeTime  between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and a.SystemId=? and a.ClientId=? " +
										  "union " +
										  "select count(b.EID) as HID_COUNT from dbo.BPO_DailyDetails_History b where b.Radius is null and  b.SwipeTime  between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and b.SystemId=? and b.ClientId=?) r";

//public static final String GET_TRIP_DETAILS="select top 5 b.Shift as SHIFT_TIME,count(b.Shift) as VEHICLES_ON_TRIP,case when datediff(mi,getutcdate(),dateadd(mi,-330,convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift))))>=30 then 'Y' else 'N' end as SHIFT_STATUS, "+
//											"(select count(a.ACCTripId) as VEHICLES_ARRIVED from dbo.BPO_Trip_Details a where a.Status='Close' and  a.ClientId=? and a.SystemId=? and dateadd(mi,-330,(convert(datetime,convert(varchar(10),a.ShiftDate,120)+' '+convert(varchar(5),a.Shift))))=dateadd(mi,-330,(convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift))))) as Closed, "+
//											"( select SUM(r.EMPLOYEE_ON_TRIP) from ( select count(EID) as EMPLOYEE_ON_TRIP from dbo.BPO_DailyDetails where TripId in (select a.ACCTripId from dbo.BPO_Trip_Details a where dateadd(mi,-330,(convert(datetime,convert(varchar(10),a.ShiftDate,120)+' '+convert(varchar(5),a.Shift))))=dateadd(mi,-330,(convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift))))) and ClientId=? and SystemId=? "+
//											"union "+
//											"select count(EID) as EMPLOYEE_ON_TRIP from dbo.BPO_DailyDetails_History where TripId in (select a.ACCTripId from dbo.BPO_Trip_Details a where dateadd(mi,-330,(convert(datetime,convert(varchar(10),a.ShiftDate,120)+' '+convert(varchar(5),a.Shift))))=dateadd(mi,-330,(convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift))))) and ClientId=? and SystemId=? "+
//											") r ) as EMPLOYEE_ON_TRIP, "+
//											"( select SUM(r1.EMPLOYEE_ON_SWIPE) from (select count(EID) as EMPLOYEE_ON_SWIPE from dbo.BPO_DailyDetails where Swifed='Y' and TripId in (select a.ACCTripId from dbo.BPO_Trip_Details a where dateadd(mi,-330,(convert(datetime,convert(varchar(10),a.ShiftDate,120)+' '+convert(varchar(5),a.Shift))))=dateadd(mi,-330,(convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift))))) and ClientId=? and SystemId=? "+
//											"union "+
//											"select count(EID) as EMPLOYEE_ON_SWIPE from dbo.BPO_DailyDetails_History where Swifed='Y' and  TripId in (select a.ACCTripId from dbo.BPO_Trip_Details a where dateadd(mi,-330,(convert(datetime,convert(varchar(10),a.ShiftDate,120)+' '+convert(varchar(5),a.Shift))))=dateadd(mi,-330,(convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift))))) and ClientId=? and SystemId=? "+
//											") r1 ) as EMPLOYEE_ON_SWIPE "+
//											"from dbo.BPO_Trip_Details b where dateadd(mi,-330,(convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift)))) between dateadd(mi,-45,getutcdate()) and dateadd(mi,150,getutcdate()) and b.ClientId=? and b.SystemId=? "+
//											"group by b.Shift,b.ShiftDate order by b.Shift asc ";

public static final String GET_TRIP_DETAILS="select top 5 b.Shift as SHIFT_TIME,count(b.Shift) as VEHICLES_ON_TRIP,SUM(CASE WHEN InvalidData is NULL THEN 1 ELSE 0 END)as COMMUNICATING,SUM(CASE WHEN (InvalidData='NON COMMUNICATING' or InvalidData='NOT AVAILABLE')  THEN 1 ELSE 0 END)as NON_COMMUNICATING,convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift)) as TIMES, case when datediff(mi,getutcdate(),dateadd(mi,-330,convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift))))>=0  then 'Y' else 'N' end as SHIFT_STATUS,(select count(a.ACCTripId) as VEHICLES_ARRIVED from dbo.BPO_Trip_Details a with (nolock) " +
		"where a.Status='Open' and  a.ClientId=?  and a.SystemId=?   and a.Action1='PickUp' and dateadd(mi,-330,(convert(datetime,convert(varchar(10),a.ShiftDate,120)+' '+convert(varchar(5),a.Shift))))=dateadd(mi,-330,(convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift))))) as Closed from dbo.BPO_Trip_Details b with (nolock) where b.Action1='PickUp' and dateadd(mi,-330,(convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift)))) " +
		"between dateadd(mi,-45,getutcdate()) and dateadd(mi,150,getutcdate()) and b.Facility collate database_default=(select NAME from ADMINISTRATOR.dbo.CUSTOMER_MASTER where CUSTOMER_ID=?)   and b.SystemId=?  group by b.Shift,b.ShiftDate,b.Action1 order by b.Shift asc";

public static final String EMPLOYEES_ON_TRIP="select SUM(r.EMPLOYEE_ON_TRIP) as EMPLOYEE_ON_TRIP from ( select count(*) as EMPLOYEE_ON_TRIP from dbo.BPO_DailyDetails with (nolock) where TripId in (select ACCTripId from dbo.BPO_Trip_Details a where a.Action1='PickUp' and dateadd(mi,-330,(convert(datetime,convert(varchar(10),a.ShiftDate,120)+' '+convert(varchar(5),a.Shift))))=dateadd(mi,-330,?) and a.ClientId=? and a.SystemId=? ) union all select count(*) as EMPLOYEE_ON_TRIP from dbo.BPO_DailyDetails_History with (nolock) where TripId in (select ACCTripId from dbo.BPO_Trip_Details a where a.Action1='PickUp' and dateadd(mi,-330,(convert(datetime,convert(varchar(10),a.ShiftDate,120)+' '+convert(varchar(5),a.Shift))))=dateadd(mi,-330,?) and a.ClientId=? and a.SystemId=? )) r";

public static final String EMPLOYEES_SWIPED="select SUM(r.EMPLOYEE_ON_TRIP) as EMPLOYEES_SWIPED from ( select count(*) as EMPLOYEE_ON_TRIP from dbo.BPO_DailyDetails with (nolock) where Swifed='Y' and TripId in (select ACCTripId from dbo.BPO_Trip_Details a where a.Action1='PickUp' and dateadd(mi,-330,(convert(datetime,convert(varchar(10),a.ShiftDate,120)+' '+convert(varchar(5),a.Shift))))=dateadd(mi,-330,?) and a.ClientId=?  and a.SystemId=? ) union all select count(*) as EMPLOYEE_ON_TRIP from dbo.BPO_DailyDetails_History with (nolock) where Swifed='Y' and TripId in (select ACCTripId from dbo.BPO_Trip_Details a where a.Action1='PickUp' and dateadd(mi,-330,(convert(datetime,convert(varchar(10),a.ShiftDate,120)+' '+convert(varchar(5),a.Shift))))=dateadd(mi,-330,?) and a.ClientId=?  and a.SystemId=? )) r";

public static final String GET_NEXT_TRIP_VEHICLES="select b.VehicleNo,b.ACCTripId,b.Shift from dbo.BPO_Trip_Details b with (nolock) where dateadd(mi,-330,(convert(datetime,convert(varchar(10),b.ShiftDate,120)+' '+convert(varchar(5),b.Shift)))) between getutcdate() and dateadd(mi,100,getutcdate()) and b.Facility=? and b.SystemId=? and b.Action1='PickUp' and b.Status='Open' and b.Shift=? group by b.VehicleNo,b.Shift,b.ACCTripId";

public static final String GET_TRIP_VEHICLE_DETAILS="select g.REGISTRATION_NO,g.LONGITUDE,g.LATITUDE,g.SPEED,t.VehicleAlias from dbo.gpsdata_history_latest g left outer join dbo.tblVehicleMaster t on g.REGISTRATION_NO=t.VehicleNo and g.System_id=t.System_id where g.CLIENTID=? and  g.System_id=? and g.REGISTRATION_NO=?";

public static final String GET_CUSTOMER_LAT_LONG="select Longitude,Latitude,Facility from dbo.BPO_FacilityMaster where Facility=? and SystemId=?";

public static final String EMPLOYESS_ON_TRIP_FOR_MAP="select count(*) as EMPLOYEE_ON_TRIP from dbo.BPO_DailyDetails with (nolock) where VehicleNo=? and ShiftTime=? and ClientId=? and SystemId=?";

public static final String GET_FACILITY_SHIFT="select Shift from dbo.BPO_Trip_Details  where dateadd(mi,-330,(convert(datetime,convert(varchar(10),ShiftDate,120)+' '+convert(varchar(5),Shift)))) between getutcdate() and dateadd(mi,100,getutcdate()) and Facility=? and SystemId=? and Action1='PickUp' group by Shift order by Shift asc";

public static final String GET_LIVE_VEHICLE_DETAILS = " select top 1 REGISTRATION_NO,LONGITUDE,LATITUDE,LOCATION,SPEED,GPS_DATETIME,isnull(Longitude,0) as FacilityLong,isnull(Latitude,0) as FacilityLat,fm.Facility,Action1 as TYPE,dateadd(mi,-10,td.ActualStartDate) as TripStartDate,td.ClientId " +
		                                              " from AMS.dbo.gpsdata_history_latest g  " +
                                                      " inner join AMS.dbo.ETMS_ASSET_ROUTE_MAPPING arm on g.REGISTRATION_NO=arm.ASSET_NUMBER " +
                                                      " inner join AMS.dbo.ETMS_ROUTE_MASTER rm on  arm.ROUTE_ID=rm.ROUTE_ID " +
                                                      " left outer join AMS.dbo.BPO_FacilityMaster fm on fm.SystemId=rm.SYSTEM_ID and fm.ClientId = rm.CUSTOMER_ID" +
                                                      " inner join AMS.dbo.BPO_Trip_Details td on td.SystemId=rm.SYSTEM_ID and td.VehicleNo=arm.ASSET_NUMBER " +
                                                      " where rm.CUSTOMER_ROUTE_ID= ?  and td.Status='Open' and TYPE like Action1+'%' order by td.ActualStartDate desc " ;

public static final String GET_TRANSIT_POINTS_FOR_ROUTE_DETAILS = " select dd.Latitude,dd.Longitude,dd.EmployeeName,dateadd(mi,?,dd.ArrivalTime) as ArrivalDateTime,dd.StopNumber as EID, " +
                                                                  " isnull((select top 1 EmployeeName from AMS.dbo.BPO_DailyDetails where VehicleNo = td.VehicleNo and ArrivalTime is not null order by ArrivalTime desc),'NA') as LAST_VISITED, "+
                                                                  " (select count(isnull(ArrivalTime,0)) from AMS.dbo.BPO_DailyDetails where VehicleNo = td.VehicleNo and ArrivalTime is not null) as NO_OF_NOTNULL_VALUES " +
																  " from AMS.dbo.BPO_Trip_Details td " +
																  " inner join AMS.dbo.BPO_DailyDetails dd on td.ACCTripId=dd.TripId and td.SystemId=dd.SystemId and td.VehicleNo=dd.VehicleNo " +
																  " where td.VehicleNo=? and dd.Type= ? and td.Status=? order by dd.ArrivalTime desc " ;

public static final String GET_ROUTE_DETAILS =  " select CUSTOMER_ROUTE_ID from AMS.dbo.ETMS_ROUTE_MASTER where CUSTOMER_ROUTE_ID= ? " ;

public static final String GET_LATITUDE_AND_LONGITUDE = "select LONGITUDE ,LATITUDE " +
														 " from AMS.dbo.BPO_Trip_Details td  " +
														 " inner join HISTORY_DATA_105 hd on hd.CLIENTID=td.ClientId and hd.REGISTRATION_NO=td.VehicleNo " +
														 " where td.VehicleNo=? and td.Type= ? and td.Status=? " +
														 " and hd.GMT>? order by hd.GMT " ;

public static final String GET_DASHBOARD_STAGE = " SELECT count(*) as COUNT,  ds.STATUS_ID  as STATUS_ID " +
												"  from AMS.dbo.DASHBOARD_STAGE ds, AMS.dbo.TRACK_TRIP_DETAILS trs  " +
												"  where trs.STATUS='OPEN' 	" +
												"  and trs.TRIP_ID = ds.TRIP_ID " +
												"  and ds.SYSTEM_ID=? and ds.CUSTOMER_ID=?  " +
												"  GROUP BY ds.STATUS_ID ";

public static final String GET_UN_UTILIZED_VEHICLE =" select COUNT(*) as COUNT from dbo.gpsdata_history_latest a "+
		" where GMT between dateadd(hh,-6,getUTCDate()) and getUTCDate() and "+
		"  a.System_id=? and a.CLIENTID=? and REGISTRATION_NO" +
		" NOT IN(SELECT ASSET_NUMBER FROM TRACK_TRIP_DETAILS WHERE STATUS='OPEN' and SYSTEM_ID=? AND CUSTOMER_ID=?)";

public static final String GET_NON_REPORTING_VEHICLE =" select COUNT(*) as COUNT from dbo.gpsdata_history_latest a "+
" where GMT < dateadd(hh,-6,getUTCDate()) and "+
"  a.System_id=? and a.CLIENTID=? and LOCATION <> 'No GPS Device Connected' and REGISTRATION_NO" +
" NOT IN(SELECT ASSET_NUMBER FROM TRACK_TRIP_DETAILS WHERE STATUS='OPEN' and SYSTEM_ID=? AND CUSTOMER_ID=?)";

public static final String GET_UN_UTILIZED_VEHICLE_MAP_DATA =" select LONGITUDE,LATITUDE,REGISTRATION_NO from dbo.gpsdata_history_latest a "+
" where GMT between dateadd(hh,-6,getUTCDate()) and getUTCDate() and "+
"  a.System_id=? and a.CLIENTID=? and REGISTRATION_NO" +
" NOT IN(SELECT ASSET_NUMBER FROM TRACK_TRIP_DETAILS WHERE STATUS='OPEN' and SYSTEM_ID=? AND CUSTOMER_ID=?)";

public static final String GET_NON_REPORTING_VEHICLE_MAP_DATA =" select LONGITUDE,LATITUDE,REGISTRATION_NO from dbo.gpsdata_history_latest a "+
" where GMT < dateadd(hh,-6,getUTCDate()) and "+
"  a.System_id=? and a.CLIENTID=? and REGISTRATION_NO" +
" NOT IN(SELECT ASSET_NUMBER FROM TRACK_TRIP_DETAILS WHERE STATUS='OPEN' and SYSTEM_ID=? AND CUSTOMER_ID=?)";



	public static final String GET_ALERT_DETAILS_FOR_DASHBOARD = " select  ds.TRIP_ID ,isnull(ttd.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(ttd.SHIPMENT_ID,'')as SHIPMENT_ID, " +
	" isnull(ttd.ROUTE_NAME,'') as ROUTE_NAME, isnull(ttd.DRIVER_NAME,'') as DRIVER_NAME,isnull(ttd.DRIVER_NUMBER,'') as DRIVER_NUMBER, " +
	" isnull(gps.LATITUDE,'') as LATITUDE,isnull(gps.LONGITUDE,'') as LONGITUDE, isnull(tad.REMARKS,'') as REMARKS,isnull(dam.ALERT_DESC,'') as ALERT_DESC, " +
	" isnull(dam.ALERT_TYPE,'') as ALERT_TYPE,isnull(ds.STATUS_ID,'') as ALERT_ID,isnull(ttd.ROUTE_ID,0) as ROUTE_ID " +
	" from AMS.dbo.DASHBOARD_STAGE ds " +
	" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ds.TRIP_ID = ttd.TRIP_ID " +
	" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO =ttd.ASSET_NUMBER " +
	" left outer join AMS.dbo.TRIP_ACTION_DETAILS tad on ds.TRIP_ID = tad.TRIP_ID " +
	" left outer join AMS.dbo.DASHBOARD_ALERT_MASTER dam on dam.ALERT_ID = ds.STATUS_ID " +
	" where ds.SYSTEM_ID=? and ds.CUSTOMER_ID=? and ttd.STATUS = 'OPEN' # " ;
	
	public static final String GET_ALERT_DETAILS_INTANSIT_DELAY = " select distinct ds.TRIP_ID ,isnull(ttd.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(ttd.SHIPMENT_ID,'')as SHIPMENT_ID, " + 
	" isnull(ttd.ROUTE_NAME,'') as ROUTE_NAME, isnull(ttd.DRIVER_NAME,'') as DRIVER_NAME,isnull(ttd.DRIVER_NUMBER,'') as DRIVER_NUMBER, " +
		" isnull(gps.LATITUDE,'') as LATITUDE,isnull(gps.LONGITUDE,'') as LONGITUDE, isnull(tad.REMARKS,'') as REMARKS,isnull(dam.ALERT_DESC,'') as ALERT_DESC,  " +
		" isnull(dam.ALERT_TYPE,'') as ALERT_TYPE,isnull(ds.STATUS_ID,'') as ALERT_ID,isnull(ttd.ROUTE_ID,0) as ROUTE_ID  " +
		" from AMS.dbo.DASHBOARD_STAGE ds  " +
		" left outer join AMS.dbo.DASHBOARD_ALERT_MASTER dam on dam.ALERT_ID=ds.STATUS_ID  " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ds.TRIP_ID = ttd.TRIP_ID   " +
		" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO =ttd.ASSET_NUMBER  " +
		" left outer join AMS.dbo.TRIP_ACTION_DETAILS tad on ds.TRIP_ID = tad.TRIP_ID  " +
		" where ds.STATUS_ID in (3, 4)  and ttd.STATUS = 'OPEN' and ALERT_DESC ='' and ds.SYSTEM_ID = ? and ds.CUSTOMER_ID=? and  " +
		" ds.TRIP_ID not in (select  st.TRIP_ID from AMS.dbo.DASHBOARD_STAGE  st  " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on st.TRIP_ID = ttd.TRIP_ID  where ds.SYSTEM_ID = ? and ds.CUSTOMER_ID=? and ttd.STATUS = 'OPEN' # )" + 
		" union all  " +
		" select distinct ds.TRIP_ID ,isnull(ttd.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(ttd.SHIPMENT_ID,'')as SHIPMENT_ID,  " +
		" isnull(ttd.ROUTE_NAME,'') as ROUTE_NAME, isnull(ttd.DRIVER_NAME,'') as DRIVER_NAME,isnull(ttd.DRIVER_NUMBER,'') as DRIVER_NUMBER,  " +
		" isnull(gps.LATITUDE,'') as LATITUDE,isnull(gps.LONGITUDE,'') as LONGITUDE, isnull(tad.REMARKS,'') as REMARKS,isnull(dam.ALERT_DESC,'') as ALERT_DESC,  " +
		" isnull(dam.ALERT_TYPE,'') as ALERT_TYPE,isnull(ds.STATUS_ID,'') as ALERT_ID,isnull(ttd.ROUTE_ID,0) as ROUTE_ID   " +
		" from AMS.dbo.DASHBOARD_STAGE ds  " +
		" left outer join AMS.dbo.DASHBOARD_ALERT_MASTER dam on dam.ALERT_ID=ds.STATUS_ID  " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ds.TRIP_ID = ttd.TRIP_ID    " +
		" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO =ttd.ASSET_NUMBER  " +
		" left outer join AMS.dbo.TRIP_ACTION_DETAILS tad on ds.TRIP_ID = tad.TRIP_ID  " +
		" where ttd.STATUS = 'OPEN' and ds.SYSTEM_ID = ? and ds.CUSTOMER_ID=? and ALERT_DESC !='' #  " +
		" order by ALERT_ID,ds.TRIP_ID,ASSET_NUMBER,SHIPMENT_ID,ROUTE_NAME,DRIVER_NAME,DRIVER_NUMBER,  " +
		" LATITUDE,LONGITUDE,REMARKS,ALERT_DESC,ALERT_TYPE,ROUTE_ID ";
	
	public static final String INSERT_REMARKS_FOR_DASHBOARD = "insert into AMS.dbo.TRIP_ACTION_DETAILS (REMARKS,ALERT_TYPE,SYSTEM_ID,INSERTED_BY,INSERTED_DATETIME,TRIP_ID) values (?,?,?,?,getutcdate(),?) ";
	
	
	public static final String GET_MAP_DETAILS = " select  ds.TRIP_ID ,isnull(ttd.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(ttd.SHIPMENT_ID,'')as SHIPMENT_ID, " + 
	" isnull(ttd.ROUTE_NAME,'') as ROUTE_NAME, isnull(ttd.DRIVER_NAME,'') as DRIVER_NAME,isnull(ttd.DRIVER_NUMBER,'') as DRIVER_NUMBER, " +
	" isnull(gps.LATITUDE,'') as LATITUDE,isnull(gps.LONGITUDE,'') as LONGITUDE, isnull(tad.REMARKS,'') as REMARKS, " +
	" isnull(dam.ALERT_DESC,'') as ALERT_DESC, isnull(ds.STATUS_ID,'') as ALERT_ID, isnull(dam.ALERT_TYPE,'') as ALERT_TYPE " +
	" from AMS.dbo.DASHBOARD_STAGE ds " +
	" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ds.TRIP_ID = ttd.TRIP_ID " + 
	" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO =ttd.ASSET_NUMBER  " +
	" left outer join AMS.dbo.TRIP_ACTION_DETAILS tad on ds.TRIP_ID = tad.TRIP_ID " +
	" left outer join AMS.dbo.DASHBOARD_ALERT_MASTER dam on dam.ALERT_ID = ds.STATUS_ID " + 
	" where ds.SYSTEM_ID=? and ds.CUSTOMER_ID=? and ttd.STATUS = 'OPEN' # "; 
	
	public static final String GET_MAP_DETAILS_DELAY = " select  ds.TRIP_ID ,isnull(ttd.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(ttd.SHIPMENT_ID,'')as SHIPMENT_ID, " + 
	" isnull(ttd.ROUTE_NAME,'') as ROUTE_NAME, isnull(ttd.DRIVER_NAME,'') as DRIVER_NAME,isnull(ttd.DRIVER_NUMBER,'') as DRIVER_NUMBER, " +
	" isnull(gps.LATITUDE,'') as LATITUDE,isnull(gps.LONGITUDE,'') as LONGITUDE, isnull(tad.REMARKS,'') as REMARKS, " +
	" isnull(ds.STATUS_ID,'') as ALERT_ID, isnull(dam.ALERT_TYPE,'') as ALERT_TYPE, " +
	" ALERT_DESC=STUFF((SELECT '/' + ALERT_DESC FROM DASHBOARD_STAGE ds1 "+
	" left outer join DASHBOARD_ALERT_MASTER dam1 on dam1.ALERT_ID = ds1.STATUS_ID "+ 
	" where ds1.TRIP_ID=ds.TRIP_ID and ((STATUS_ID=? OR STATUS_ID=?) )"+
	" FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '')"+
	" from AMS.dbo.DASHBOARD_STAGE ds " +
	" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ds.TRIP_ID = ttd.TRIP_ID " + 
	" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO =ttd.ASSET_NUMBER  " +
	" left outer join AMS.dbo.TRIP_ACTION_DETAILS tad on ds.TRIP_ID = tad.TRIP_ID " +
	" left outer join AMS.dbo.DASHBOARD_ALERT_MASTER dam on dam.ALERT_ID = ds.STATUS_ID " + 
	" where ds.SYSTEM_ID=? and ds.CUSTOMER_ID=? and ttd.STATUS = 'OPEN' and ds.STATUS_ID =? "; 
	
	public static final String GET_VEHICLE_DETAILS_FOR_OPEN_TRIPS= " select TRIP_ID,isnull(ASSET_NUMBER,'') as ASSET_NUMBER,isnull(SHIPMENT_ID,'') as SHIPMENT_ID,isnull(ROUTE_ID,'') as ROUTE_ID, isnull(dateadd(mi,?,TRIP_START_TIME),'') as  TRIP_START_TIME,isnull(dateadd(mi,?,ACTUAL_TRIP_START_TIME),'') as ACTUAL_TRIP_START_TIME " +
			"from AMS.dbo.TRACK_TRIP_DETAILS where STATUS = 'OPEN' and SYSTEM_ID = ? and CUSTOMER_ID = ? ";
	
	public static final String GET_SHIPMENT_DETAILS = " select ttd.TRIP_ID,ttd.ASSET_NUMBER,isnull(tvm.VehicleType,'') as VEHICLE_TYPE," +
	" ttd.SHIPMENT_ID,isnull(ttd.ROUTE_NAME,'') as ROUTE_NAME,isnull(ttd.CUSTOMER_REF_ID,'') as CUST_REF_ID ," +
	" isnull(trm.ROUTE_KEY,'') as ROUTE_KEY,isnull(trm.DISTANCE,0) as DISTANCE, isnull(trm.TAT,0) as TAT,  " +
	" isnull(ttd.TRIP_STATUS,'') as TRIP_STATUS,isnull(vm.ModelName,'') as VEHICLE_MODEL, isnull(dateadd(mi,?,ttd.DESTINATION_ETA),'') as ETA ," +
	" (select top 1 STATUS_ID from AMS.dbo.DASHBOARD_STAGE ds where ds.TRIP_ID=? and STATUS_ID in (2,3,4,30)) as STATUS_ID " +
	" from AMS.dbo.TRACK_TRIP_DETAILS ttd " +
	" LEFT OUTER join AMS.dbo.tblVehicleMaster tvm on ttd.ASSET_NUMBER = tvm.VehicleNo and tvm.System_id = ttd.SYSTEM_ID" +
	" LEFT OUTER join AMS.dbo.TRIP_ROUTE_MASTER trm on trm.ID = ttd.ROUTE_ID " +
	" LEFT OUTER join FMS.dbo.VEHICLE_MODEL vm on vm.ModelTypeId=tvm.Model " +
	" where ttd.STATUS = 'OPEN' and ttd.SYSTEM_ID = ? and ttd.CUSTOMER_ID = ? and ttd.TRIP_ID=? ";
	
	public static final String GET_DRIVER_DETAILS = "select isnull(a.Fullname,'NA') as DriverName , isnull(Mobile,0)  as Mobile,isnull(a.EmployeeID,'') as EmployeeID " +
	" from AMS.dbo.Driver_Master a   where Driver_id IN (select DRIVER_1 from  AMS.dbo.TRIP_LEG_DETAILS  WHERE TRIP_ID=? " +
	" UNION  " +
	" select DRIVER_2 from  AMS.dbo.TRIP_LEG_DETAILS  WHERE TRIP_ID=?) " +
	" and  a.System_id=?";
	
	public static final String GET_ALERTS_ON_TRIP = "select dateadd(mi,?,GMT) AS TIME_STAMP ,ALERT_NAME,isnull(REMARKS,'') as REMARKS "+
		" from  AMS.dbo.TRIP_EVENT_DETAILS "+
		" where TRIP_ID = ?";
	
	public static final String GET_ERROR_ALERT_DETAILS_COUNT = " select count(*) as errorCodeCount" +
		" from  AMS.dbo.CANIQ_ERROR_CODES a " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd  on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID" +
		" where a.SYSTEM_ID=? and a.CLIENT_ID=? "+//and a.GMT between dateadd(mi,?,?) and getutcdate() " +
		" and ttd.TRIP_ID = ? ";
	
	public static final String GET_POWER_COOLANT_COUNT = "select count(*) as CoolantCount from AMS.dbo.Alert vc " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd  on ttd.ASSET_NUMBER=vc.REGISTRATION_NO and vc.SYSTEM_ID=ttd.SYSTEM_ID " +
		" WHERE vc.SYSTEM_ID=? and vc.CLIENTID=? and GMT between dateadd(mi,?,?) and getutcdate()  " +
		" and ttd.TRIP_ID = ? and TYPE_OF_ALERT=159 "; 

	public static final String GET_LOW_FUEL_ALERT_COUNT = " select count(*) as LowFuelAlert from AMS.dbo.Alert a " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd  on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID " +
		" WHERE a.SYSTEM_ID=? and a.CLIENTID=? " +
		" and a.GMT between dateadd(mi,-?,?) and getutcdate() and ttd.TRIP_ID = ?  and TYPE_OF_ALERT=193 ";
	
	public static final String GET_ACTUAL_VEHICLE_DATA = "select isnull(glc.FUEL_LEVEL,'') as FUEL_LEVEL,isnull(cast(glc.ENG_FUEL_ECO as decimal(18,2)),'0') as MILEAGE,isnull(glc.COOLANT_TEMP,'')  as COOLANT_TEMP, "+
														" isnull(gps.ODOMETER,'') as ODOMETER,isnull(cast(gps.MAIN_BATTERY_VOLTAGE as decimal(18,2)),'0') as BATTERY_VOLTAGE,ENGINE_SPEED  "+
														" from AMS.dbo.GPSDATA_LIVE_CANIQ glc "+
														" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO = glc.REGISTRATION_NO "+
														" where glc.REGISTRATION_NO=(SELECT ASSET_NUMBER FROM AMS.dbo.TRACK_TRIP_DETAILS WHERE TRIP_ID=? AND SYSTEM_ID=? AND CUSTOMER_ID=?)";		
	
	public static final String GET_ENGINE_RPM_GPS_TAMPER = "select count(*) as gpsTamperCount from AMS.dbo.Alert vc " +
														" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd  on ttd.ASSET_NUMBER=vc.REGISTRATION_NO and vc.SYSTEM_ID=ttd.SYSTEM_ID " +
														" WHERE vc.SYSTEM_ID=? and vc.CLIENTID=? and GMT between dateadd(mi,?,?) and getutcdate()  " +
														" and ttd.TRIP_ID = ? and TYPE_OF_ALERT=145 "+//gps tampering
														" UNION ALL"+
														"select count(*) as engineRPMCount from AMS.dbo.Alert vc " +
														" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd  on ttd.ASSET_NUMBER=vc.REGISTRATION_NO and vc.SYSTEM_ID=ttd.SYSTEM_ID " +
														" WHERE vc.SYSTEM_ID=? and vc.CLIENTID=? and GMT between dateadd(mi,?,?) and getutcdate()  " +
														" and ttd.TRIP_ID = ? and TYPE_OF_ALERT=123";//Engine RPM
	
	public static final String GET_ERROR_ALERT_DETAILS = " select ISNULL(ERROR_DESC,'') AS ERROR_DESC,  isnull(dateadd(mi,?,getutcDate()),'') as TIME_STAMP,isnull(a.REGISTRATION_NO,'') as REGISTRATION_NO "+
		" from  AMS.dbo.CANIQ_ERROR_CODES a " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd  on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
		" where a.SYSTEM_ID=? and a.CLIENT_ID=? "+// and a.GMT between dateadd(mi,-?,?) and getutcdate() " + 
		" and ttd.TRIP_ID = ?  "; //and a.ERROR_CODE like 'P%' ";
	
	public static final String GET_POWER_COOLANT_OR_BATTERY_DETAILS = " select isnull(dateadd(mi,?,vc.GPS_DATETIME),'') as TIME_STAMP,isnull(vc.REMARKS,'') as REMARKS from AMS.dbo.Alert vc " + 
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd  on ttd.ASSET_NUMBER=vc.REGISTRATION_NO and vc.SYSTEM_ID=ttd.SYSTEM_ID  " +
		" WHERE vc.SYSTEM_ID=? and vc.CLIENTID=? and GMT between dateadd(mi,-?,?) and getutcdate()   " +
		" and ttd.TRIP_ID = ? # "; // and TYPE_OF_ALERT=183 -  battery voltage count
	
	public static final String GET_LOW_FUEL_ALERT_DETAILS = " select isnull(dateadd(mi,?,a.GPS_DATETIME),'') as TIME_STAMP,isnull(a.REMARKS,'') as REMARKS from AMS.dbo.Alert a " +  
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd  on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID " + 
		" WHERE a.SYSTEM_ID=? and a.CLIENTID=? " +
		" and a.GMT between dateadd(mi,-?,?) and getutcdate() and ttd.TRIP_ID = ?  #"; //low fuel , low kmpl and ABS
	
	
	public static final String GET_VEHICLE_SAFTEY_COUNTS ="select COUNT(*) AS COUNT, 'LOW_FUEL' AS ALERT_TYPE from Alert a " +
		" inner join TRACK_TRIP_DETAILS ttd  "+
		" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
		" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=193 "+
		" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=? ) "+
		" union all "+
		" select COUNT(*) AS COUNT,'LOW_BAT' AS ALERT_TYPE from Alert a inner join TRACK_TRIP_DETAILS ttd "+ 
		" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
		" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=183 "+
		" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)"+
		" union all "+
		" select COUNT(*) AS COUNT ,'OVER_SPEED' AS ALERT_TYPE from Alert a inner join TRACK_TRIP_DETAILS ttd  "+
		" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
		" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=2 "+
		" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)"+
		" union all "+
		" select COUNT(*) AS COUNT ,'COOLANT_TEMP' AS ALERT_TYPE from Alert a inner join TRACK_TRIP_DETAILS ttd  "+
		" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID"+
		" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=159 "+
		" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)";
	
	public static final String GET_VEHICLE_SAFTEY_DETAILS ="select a.REGISTRATION_NO,a.REMARKS as VALUE, 'LOW_FUEL' AS ALERT_TYPE," +
	" 0 as NO_OF_ALERTS,0 AS MAX_VALUE from Alert a " +
	" inner join TRACK_TRIP_DETAILS ttd  "+
	" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
	" inner join GPSDATA_LIVE_CANIQ caniq on caniq.REGISTRATION_NO=a.REGISTRATION_NO "+
	" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=193 "+
	" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=? ) "+
	" union all "+
	" select a.REGISTRATION_NO,isnull(cast(a.REMARKS as decimal(18,2)),'0') as VALUE, 'LOW_BAT' AS ALERT_TYPE," +
	" 0 as NO_OF_ALERTS,0 AS MAX_VALUE from Alert a inner join TRACK_TRIP_DETAILS ttd "+ 
	" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
	" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=a.REGISTRATION_NO"+
	" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=183 "+
	" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)"+
	" union all "+
	" select a.REGISTRATION_NO,a.REMARKS AS VALUE ,'OVER_SPEED' AS ALERT_TYPE, " +
	"(select COUNT(*) from Alert_History WHERE REGISTRATION_NO=a.REGISTRATION_NO "+
	 " AND TYPE_OF_ALERT=2 and GMT > ttd.ACTUAL_TRIP_START_TIME) AS NO_OF_ALERTS, "+
	 " (select MAX(REMARKS) from Alert_History WHERE REGISTRATION_NO=a.REGISTRATION_NO "+
	 " AND TYPE_OF_ALERT=2 and GMT > ttd.ACTUAL_TRIP_START_TIME) AS MAX_VALUE"+
	" from Alert a  inner join TRACK_TRIP_DETAILS ttd  "+
	" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
	" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=2 "+
	" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)"+
	" union all "+
	" select a.REGISTRATION_NO,a.REMARKS VALUE,'COOLANT_TEMP' AS ALERT_TYPE, " +
	" 0 as NO_OF_ALERTS,0 AS MAX_VALUE from Alert a inner join TRACK_TRIP_DETAILS ttd  "+
	" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID"+
	" inner join GPSDATA_LIVE_CANIQ caniq on caniq.REGISTRATION_NO=a.REGISTRATION_NO "+
	" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=159 "+
	" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)";
	
	public static final String GET_VEHICLE_SAFTEY_ACTION_DETAILS ="select a.REGISTRATION_NO as ASSET_NUMBER,ttd.TRIP_ID, " +
	" isnull(ttd.SHIPMENT_ID,'')as SHIPMENT_ID, isnull(ttd.ROUTE_NAME,'') as ROUTE_NAME, isnull(ttd.DRIVER_NAME,'') as DRIVER_NAME," +
	" isnull(ttd.DRIVER_NUMBER,'') as DRIVER_NUMBER, isnull(gps.LATITUDE,'') as LATITUDE,isnull(gps.LONGITUDE,'') as LONGITUDE,"+
	" isnull(tad.REMARKS,'') as REMARKS ,isnull(ttd.ROUTE_ID,0) as ROUTE_ID, TYPE_OF_ALERT from Alert a " +
	" inner join TRACK_TRIP_DETAILS ttd  "+
	" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
	" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=a.REGISTRATION_NO"+
	" left outer join AMS.dbo.TRIP_ACTION_DETAILS tad on ttd.TRIP_ID = tad.TRIP_ID " +
	" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT in(193,183,2,159) "+
	" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=? ) ";
/*
	" union all "+
	" select a.REGISTRATION_NO,MAIN_BATTERY_VOLTAGE as VALUE, 'LOW_BAT' AS ALERT_TYPE from Alert a inner join TRACK_TRIP_DETAILS ttd "+ 
	" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
	" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=a.REGISTRATION_NO"+
	" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=183 "+
	" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)"+
	" union all "+
	" select a.REGISTRATION_NO,'100' AS VALUE ,'OVER_SPEED' AS ALERT_TYPE from Alert a inner join TRACK_TRIP_DETAILS ttd  "+
	" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
	" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=a.REGISTRATION_NO"+
	" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=2 "+
	" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)"+
	" union all "+
	" select a.REGISTRATION_NO,caniq.COOLANT_TEMP VALUE,'COOLANT_TEMP' AS ALERT_TYPE from Alert a inner join TRACK_TRIP_DETAILS ttd  "+
	" on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID"+
	" inner join GPSDATA_LIVE_CANIQ caniq on caniq.REGISTRATION_NO=a.REGISTRATION_NO "+
	" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=a.REGISTRATION_NO"+
	" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=159 "+
	" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)";
*/
	public static final String GET_VEHICLE_SAFTEY_ALERT_DETAIL = "select  ttd.TRIP_ID ,a.REMARKS AS VALUE, isnull(ttd.ASSET_NUMBER,'') as ASSET_NUMBER," +
			"isnull(ttd.SHIPMENT_ID,'')as SHIPMENT_ID,   "+
		" isnull(ttd.ROUTE_NAME,'') as ROUTE_NAME, isnull(ttd.DRIVER_NAME,'') as DRIVER_NAME,isnull(ttd.DRIVER_NUMBER,'') as DRIVER_NUMBER, "+ 
		" isnull(gps.LATITUDE,'') as LATITUDE,isnull(gps.LONGITUDE,'') as LONGITUDE, TYPE_OF_ALERT as ALERT_TYPE "+  
		" from Alert a inner join TRACK_TRIP_DETAILS ttd  on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
		" inner join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO =ttd.ASSET_NUMBER "+
		" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=? "+
		" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)";
	
	public static final String GET_OVER_SPEED_ALERT_DETAIL = "select  ttd.TRIP_ID ,a.REMARKS AS VALUE, isnull(ttd.ASSET_NUMBER,'') as ASSET_NUMBER," +
	" isnull(ttd.SHIPMENT_ID,'')as SHIPMENT_ID,   "+
	" isnull(ttd.ROUTE_NAME,'') as ROUTE_NAME, isnull(ttd.DRIVER_NAME,'') as DRIVER_NAME,isnull(ttd.DRIVER_NUMBER,'') as DRIVER_NUMBER, "+ 
	" isnull(gps.LATITUDE,'') as LATITUDE,isnull(gps.LONGITUDE,'') as LONGITUDE, TYPE_OF_ALERT as ALERT_TYPE, "+  
	" (select COUNT(*) from Alert_History WHERE REGISTRATION_NO=a.REGISTRATION_NO "+
	" AND TYPE_OF_ALERT=2 and GMT > ttd.ACTUAL_TRIP_START_TIME) AS NO_OF_ALERTS, "+
	" (select MAX(REMARKS) from Alert_History WHERE REGISTRATION_NO=a.REGISTRATION_NO "+
	" AND TYPE_OF_ALERT=2 and GMT > ttd.ACTUAL_TRIP_START_TIME) AS MAX_VALUE "+
	" from Alert a inner join TRACK_TRIP_DETAILS ttd  on ttd.ASSET_NUMBER=a.REGISTRATION_NO and a.SYSTEM_ID=ttd.SYSTEM_ID "+
	" inner join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO =ttd.ASSET_NUMBER "+
	" WHERE a.SYSTEM_ID=? and a.CLIENTID=? and TYPE_OF_ALERT=? "+
	" and ttd.TRIP_ID IN(select TRIP_ID from TRACK_TRIP_DETAILS td where STATUS='OPEN' and td.SYSTEM_ID=? and td.CUSTOMER_ID=?)";
	
	public static final String GET_DASHBOARD_COUNT_DETAILS = "  select   COUNT(*) as COUNT,'AVAILABLE' as COUNT_TYPE " +
		" from AMS.dbo.gpsdata_history_latest a   " +
		" where  a.CLIENTID=? and a.System_id=? and a.GMT between dateadd(hh,-6,getUTCDate()) and getUTCDate() and a.REGISTRATION_NO  " +
		" not in(  " +
		" select distinct ASSET_NUMBER   " +
		" from AMS.dbo.TRACK_TRIP_DETAILS   " +
		" where SYSTEM_ID=? and CUSTOMER_ID = ? and STATUS ='OPEN') " +
		" union " +
		" select COUNT(*) as COUNT,'ENROUTE' as COUNT_TYPE  " +
		" from AMS.dbo.TRACK_TRIP_DETAILS  " +
		" where STATUS='OPEN' and ACT_SRC_ARR_DATETIME is null and CUSTOMER_ID=? and SYSTEM_ID=? " +
		" union " +
		" select count (*) as COUNT,'ON_TRIP' as COUNT_TYPE  " +
		" from AMS.dbo.TRACK_TRIP_DETAILS  " +
		" where STATUS='OPEN' and ACTUAL_TRIP_START_TIME is not null and CUSTOMER_ID=? and SYSTEM_ID=? " +
		" union " +
		" select COUNT(*) as COUNT,'WAITING_FOR_LOAD' as COUNT_TYPE  from AMS.dbo.TRACK_TRIP_DETAILS_SUB ttds " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttds.TRIP_ID = ttd.TRIP_ID " +
		" where ttd.ACTUAL_TRIP_START_TIME is null and ttd.ACT_SRC_ARR_DATETIME is not null and ttd.STATUS='OPEN' and ttds.IS_PRECOOL_ACHIEVED = 'Y' and ttd.CUSTOMER_ID=? and ttd.SYSTEM_ID=? " +
		" union " +
		" select COUNT(*) as COUNT,'NOT_READY_FOR_LOAD' as COUNT_TYPE  from AMS.dbo.TRACK_TRIP_DETAILS_SUB ttds " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttds.TRIP_ID = ttd.TRIP_ID " +
		" where ttd.ACTUAL_TRIP_START_TIME is null and ttd.ACT_SRC_ARR_DATETIME is not null and ttd.STATUS='OPEN' and ttds.IS_PRECOOL_ACHIEVED = 'N' and ttd.CUSTOMER_ID=? and ttd.SYSTEM_ID=? " +
		" union " +
		" select SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >=? THEN 1 ELSE 0 END)AS NONCOMM ,'NON_COMM' as COUNT_TYPE" +
		" from ADMINISTRATOR.dbo.PRODUCT_PROCESS d " +
		" inner join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC a on  a.PROCESS_ID=d.PROCESS_ID " +
		" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
		" left outer join AMS.dbo.gpsdata_history_latest c on c.CLIENTID=b.CUSTOMER_ID and c.System_id=b.SYSTEM_ID   " +
		" where b.CUSTOMER_ID = ? and b.SYSTEM_ID=? and b.STATUS='Active' and b.ACTIVATION_STATUS='Complete' " +
		" and d.PROCESS_TYPE_LABEL_ID='Vertical_Sol' " +
		" union" +
		" select COUNT(*) as COUNT, 'TEMP_ALERT' as COUNT_TYPE " + 
		" from AMS.dbo.TRIP_EVENT_DETAILS ted " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ted.TRIP_ID=ttd.TRIP_ID " +
		" where ALERT_TYPE= 189 and ted.CUSTOMER_ID = ? and ted.SYSTEM_ID = ?  and ttd.STATUS = 'OPEN' ";

	
	public static final String GET_AVAILABLE_VEHICLES_MAP_DETAILS = "select isnull(a.REGISTRATION_NO,'') as REG_NO ,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(dm.Fullname,'') as DRIVER_NAME,isnull(dm.Mobile,'') as DRIVER_CONTACT,'' as TRIP_ID,ANALOG_INPUT_2,rs.IO_VALUE,isnull(rs.IO_VALUE,'N/A') as TEMP " +   
		" from AMS.dbo.gpsdata_history_latest a  " +
		" left outer join AMS.dbo.RS232_LIVE rs on rs.REGISTRATION_NO = a.REGISTRATION_NO and a.System_id=rs.SYSTEM_ID and IO_CATEGORY = 'TEMPERATURE1' " +
		" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=a.System_id and dv.REGISTRATION_NO = a.REGISTRATION_NO " +
		" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id" +
		" where a.CLIENTID=? and a.System_id=? and a.GMT between dateadd(hh,-6,getUTCDate()) and getUTCDate() and a.REGISTRATION_NO not in( " +
		" select distinct ASSET_NUMBER  " +
		" from AMS.dbo.TRACK_TRIP_DETAILS  " +
		" where SYSTEM_ID=? and CUSTOMER_ID = ? and STATUS ='OPEN')";
	
	public static final String GET_LOADING_VEHICLES_MAP_DETAILS = "select ttd.TRIP_ID,isnull(ttd.ASSET_NUMBER,'') as REG_NO,gps.LATITUDE,gps.LONGITUDE,gps.LOCATION,isnull(dm.Fullname,'') as DRIVER_NAME,isnull(dm.Mobile,'') as DRIVER_CONTACT,ANALOG_INPUT_2,rs.IO_VALUE,isnull(rs.IO_VALUE,'N/A') as TEMP " +
		" from AMS.dbo.TRACK_TRIP_DETAILS_SUB ttds " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttds.TRIP_ID = ttd.TRIP_ID " +
		" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO = ttd.ASSET_NUMBER and gps.System_id=ttd.SYSTEM_ID " +
		" left outer join AMS.dbo.RS232_LIVE rs on rs.REGISTRATION_NO = ttd.ASSET_NUMBER and ttd.SYSTEM_ID=rs.SYSTEM_ID and IO_CATEGORY = 'TEMPERATURE1' " +
		" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=gps.System_id and dv.REGISTRATION_NO = gps.REGISTRATION_NO " +
		" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id" +
		" where ttd.ACTUAL_TRIP_START_TIME is null ttd.ACT_SRC_ARR_DATETIME is not null and ttd.STATUS='OPEN' and ttd.CUSTOMER_ID=? and ttd.SYSTEM_ID=? # ";
	
	public static final String GET_VEHICLES_TRIP_MAP_DETAILS = "select TRIP_ID,isnull(ttd.ASSET_NUMBER,'') as REG_NO,gps.LATITUDE,gps.LONGITUDE,gps.LOCATION,isnull(dm.Fullname,'') as DRIVER_NAME,isnull(dm.Mobile,'') as DRIVER_CONTACT,ANALOG_INPUT_2,rs.IO_VALUE,isnull(rs.IO_VALUE,'N/A') as TEMP " +
		" from AMS.dbo.TRACK_TRIP_DETAILS ttd " +
		" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO = ttd.ASSET_NUMBER and gps.System_id=ttd.SYSTEM_ID " +
		" left outer join AMS.dbo.RS232_LIVE rs on rs.REGISTRATION_NO = ttd.ASSET_NUMBER and ttd.SYSTEM_ID=rs.SYSTEM_ID and IO_CATEGORY = 'TEMPERATURE1' " +
		" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=gps.System_id and dv.REGISTRATION_NO = gps.REGISTRATION_NO " +
		" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id" +
		" where ttd.STATUS='OPEN' and ttd.CUSTOMER_ID=? and ttd.SYSTEM_ID=? #";
	
	public static final String GET_VEHICLES_LIST = " select  distinct isnull(vc.REGISTRATION_NUMBER,'') as REGISTRATION_NUMBER ,tb.VehicleType as VehicleType,isnull(vm.ModelName,'NA') as Model " + 
		" from AMS.dbo.VEHICLE_CLIENT vc  " +
		" inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER=vu.Registration_no and  vc.SYSTEM_ID=vu.System_id  " +
		" inner join  AMS.dbo.tblVehicleMaster tb  on vc.REGISTRATION_NUMBER=tb.VehicleNo  " +
		" left outer join FMS.dbo.Vehicle_Model vm on tb.Model = vm.ModelTypeId and vm.SystemId=vc.SYSTEM_ID and vm.ClientId=vc.CLIENT_ID " + 
		" where vc.SYSTEM_ID = ? and vc.CLIENT_ID=? and vu.User_id=? ";
	
	public static final String GET_TEMP_ALERT_DATA = " select ted.TRIP_ID,VEHICLE_NO,ttd.SHIPMENT_ID,GMT,LOCATION,ID, " +
		" isnull(ted.REMARKS,'') as REMARKS,isnull(u.Login_name,'') as ACK_BY,isnull(ted.ACKNOWLEDGE_DATETIME,'') as ACK_DATE " +
		" from AMS.dbo.TRIP_EVENT_DETAILS ted " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ted.TRIP_ID=ttd.TRIP_ID " +
		" left outer join AMS.dbo.Users u on ted.ACKNOWLEDGE_BY=u.User_id and ted.SYSTEM_ID=u.System_id "+
		" where ALERT_TYPE= 189 and ted.SYSTEM_ID = ? and ted.CUSTOMER_ID = ? and ttd.STATUS = 'OPEN'  ";
	
	
	public static final String GET_AVAILABLE_DRIVERS = "select distinct isnull(a.REGISTRATION_NO,'') as REGISTRATION_NO, isnull(dm.Fullname,'') as DRIVER_NAME, "+
	   " isnull(dm.Mobile,'') as DRIVER_CONTACT,'' as TRIP_ID,dm.Driver_id as DRIVER_ID   "+
	   " from AMS.dbo.gpsdata_history_latest a  "+ 
	   " left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=a.System_id and dv.REGISTRATION_NO = a.REGISTRATION_NO  "+
	   " left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id "+
	   " where a.System_id=? and a.CLIENTID=? "+// and a.GMT between dateadd(hh,-6,getUTCDate()) and getUTCDate() " +
	   " and a.REGISTRATION_NO not in( "+
	   " select distinct ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID =? and STATUS ='OPEN') AND a.REGISTRATION_NO in( ##)";
	
	public static final String GET_ON_TRIP_DRIVERS = " select distinct td.TRIP_ID  , isnull(td.ASSET_NUMBER ,'') as REGISTRATION_NO, " +
	" isnull(dm.Fullname,'') as DRIVER_NAME,dm.Driver_id as DRIVER_ID, "+
	 " isnull(dm.Mobile,'') as DRIVER_CONTACT,'' as TRIP_ID   "+
	 " from AMS.dbo.TRACK_TRIP_DETAILS td  "+
	 " left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=td.SYSTEM_ID and dv.REGISTRATION_NO = td.ASSET_NUMBER "+
	 " left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id "+
	 " where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS='OPEN' and td.ACTUAL_TRIP_START_TIME is not null AND td.ASSET_NUMBER in( ## )";
	
	public static final String GET_TRIP_ASSIGNED_DRIVERS = " select distinct td.TRIP_ID  , isnull(td.ASSET_NUMBER ,'') as REGISTRATION_NO, " +
			" isnull(dm.Fullname,'') as DRIVER_NAME,dm.Driver_id as DRIVER_ID, "+
	 " isnull(dm.Mobile,'') as DRIVER_CONTACT,'' as TRIP_ID   "+
	 " from AMS.dbo.TRACK_TRIP_DETAILS td  "+
	 " left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=td.SYSTEM_ID and dv.REGISTRATION_NO = td.ASSET_NUMBER "+
	 " left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id "+
	 " where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS='OPEN' and td.ACTUAL_TRIP_START_TIME is null AND td.ASSET_NUMBER in( ## )";

	
	public static final String GET_LOADING_PARTNERS = "SELECT ID_column as ID,NAME FROM LOADING_PARTNER WHERE SYSTEM_ID=? AND CUSTOMER_ID=?";
	
	public static final String GET_HUBS_BY_TRIP_CUSTOMER = " select HUBID,lz.NAME," +
			" LATITUDE,LONGITUDE,RADIUS,isnull(Standard_Duration,0) as DETENTION from AMS.dbo.LOCATION_ZONE lz " +
			" left outer join dbo.TRIP_CUSTOMER_DETAILS tcd on tcd.SYSTEM_ID = lz.SYSTEMID and tcd.ID = lz.TRIP_CUSTOMER_ID " +
			" where  SYSTEMID=? and CLIENTID=?  and TRIP_CUSTOMER_ID=? ";
	
	public static final String GET_DASHBOARD_COUNT_JOTUN =" select  COUNT(*) as COUNT,'AVAILABLE_GREATER' as COUNT_TYPE from  " + 
		" AMS.dbo.TRACK_TRIP_DETAILS_SUB ttds   " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttds.TRIP_ID = ttd.TRIP_ID " +  
		" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO = ttd.ASSET_NUMBER and gps.System_id=ttd.SYSTEM_ID " +  
		" left outer join AMS.dbo.TRIP_CONFIGURATION tc on tc.SYSTEM_ID=gps.System_id and tc.CUSTOMER_ID=gps.CLIENTID    " +
		" where ttd.ASSET_NUMBER in(ADMINCVEHILCES) and ttd.ACTUAL_TRIP_END_TIME in (select max(ACTUAL_TRIP_END_TIME) from AMS.dbo.TRACK_TRIP_DETAILS td where td.TRIP_STATUS='CHECK_ETA' " + 
		" and td.CUSTOMER_ID = ? and td.SYSTEM_ID = ? and td.STATUS = 'CLOSED' " +
		" group by td.ASSET_NUMBER) and gps.LOCATION !='No GPS Device Connected'  " +
		" and gps.LOCATION != tc.HEAD_QUATERS and ETA_SOURCE_HUB >30 AND ttd.ASSET_NUMBER NOT IN(select ASSET_NUMBER from TRACK_TRIP_DETAILS WHERE CUSTOMER_ID=? AND SYSTEM_ID=? AND STATUS='OPEN')" +
		" union  " +
		" select count (*) as COUNT,'ON_TRIP' as COUNT_TYPE " +  
		" from AMS.dbo.TRACK_TRIP_DETAILS ttd  " +
		" INNER JOIN [dbo].[gpsdata_history_latest] ghl on ghl.REGISTRATION_NO=ttd.ASSET_NUMBER "+ 
		" where STATUS='OPEN' and ACTUAL_TRIP_START_TIME is not null and CUSTOMER_ID=? and SYSTEM_ID=? AND ASSET_NUMBER IN (##) " +
		" union  " +
		" select count (*) as COUNT,'TRIP_ASSIGNED' as COUNT_TYPE " +  
		" from AMS.dbo.TRACK_TRIP_DETAILS  ttd " +
		" INNER JOIN [dbo].[gpsdata_history_latest] ghl on ghl.REGISTRATION_NO=ttd.ASSET_NUMBER "+ 
		" where STATUS='OPEN' and ACTUAL_TRIP_START_TIME is null and CUSTOMER_ID=? and SYSTEM_ID=? AND ASSET_NUMBER IN (##) " +
		" union  " +
		" select   count(*) as COUNT, 'INSIDE_HQ' as COUNT_TYPE " + 
		" from AMS.dbo.gpsdata_history_latest a    " +
		" left outer join AMS.dbo.TRIP_CONFIGURATION tc on tc.SYSTEM_ID=a.System_id and tc.CUSTOMER_ID=CLIENTID " + 
		" where a.REGISTRATION_NO in(ADMINCVEHILCES) and   a.CLIENTID=? and a.System_id=?  " + 
		" and LOCATION = tc.HEAD_QUATERS AND REGISTRATION_NO NOT IN(select ASSET_NUMBER from TRACK_TRIP_DETAILS WHERE STATUS='OPEN' and CUSTOMER_ID=? AND SYSTEM_ID=? AND DATEDIFF(mi,ACTUAL_TRIP_START_TIME,getutcdate())<5)"+//pra
		" union  " +
		" select COUNT (a.REGISTRATION_NO) as COUNT, 'TOTAL' as COUNT_TYPE  " + 
		" from AMS.dbo.gpsdata_history_latest a    " + 
		" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=a.System_id and dv.REGISTRATION_NO = a.REGISTRATION_NO    " + 
		" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id  " + 
		" where   a.REGISTRATION_NO in(ADMINCVEHILCES) and a.CLIENTID=? and a.System_id=? and a.LOCATION !='No GPS Device Connected' " +
		" union  " +
		" select COUNT(*) as COUNT ,'TOTAL_AVAILABLE' as COUNT_TYPE " +
		" from AMS.dbo.gpsdata_history_latest a   " +
		" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=a.System_id and dv.REGISTRATION_NO = a.REGISTRATION_NO " +  
		" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id  " +
		" where  a.CLIENTID=? and a.System_id=?  and a.REGISTRATION_NO in(ADMINCVEHILCES)" +
		" and a.REGISTRATION_NO not in(  " +
		" select distinct ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where CUSTOMER_ID =? and SYSTEM_ID=? and STATUS ='OPEN')" +
		" union  " +
		" select COUNT(*) AS COUNT ,'AT_BORDER' AS COUNT_TYPE "+
		" from [AMS].[dbo].[LIVE_DETENTION_NEW] ld "+
		" inner join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttd.[ASSET_NUMBER] = ld.REGISTRATION_NO "+
		" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=ld.SYSTEM_ID and dv.REGISTRATION_NO = ld.REGISTRATION_NO  "+
		" collate database_default "+
		" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id  "+
		" where ld.CLIENT_ID = ? and ld.SYSTEM_ID = ? and ld.HUB_TYPE=6 and ttd.STATUS='OPEN' and ld.REGISTRATION_NO in(##) ";//Hub type 6 for Check post
	
	public static final String GET_DASHBOARD_COUNT_JOTUN_FILTER_BY_REGION =" select  COUNT(*) as COUNT,'AVAILABLE_GREATER' as COUNT_TYPE from  " + 
	" AMS.dbo.TRACK_TRIP_DETAILS_SUB ttds   " +
	" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttds.TRIP_ID = ttd.TRIP_ID " +  
	" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO = ttd.ASSET_NUMBER and gps.System_id=ttd.SYSTEM_ID " +  
	" left outer join AMS.dbo.TRIP_CONFIGURATION tc on tc.SYSTEM_ID=gps.System_id and tc.CUSTOMER_ID=gps.CLIENTID    " +
	" where ttd.ACTUAL_TRIP_END_TIME in (select max(ACTUAL_TRIP_END_TIME) from AMS.dbo.TRACK_TRIP_DETAILS td where td.TRIP_STATUS='CHECK_ETA' " + 
	" and td.CUSTOMER_ID = ? and td.SYSTEM_ID = ? and td.STATUS = 'CLOSED' " +
	" group by td.ASSET_NUMBER) and gps.LOCATION !='No GPS Device Connected'  " +
	" and gps.LOCATION != tc.HEAD_QUATERS and ETA_SOURCE_HUB >30 AND ttd.ASSET_NUMBER NOT IN(select ASSET_NUMBER from TRACK_TRIP_DETAILS WHERE CUSTOMER_ID=? AND SYSTEM_ID=? AND STATUS='OPEN')" +
//	" select COUNT(*) as COUNT,'AVAILABLE_LESS' as COUNT_TYPE  from " +   old available less Q
//	" AMS.dbo.TRACK_TRIP_DETAILS_SUB ttds " +
//	" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttds.TRIP_ID = ttd.TRIP_ID " +
//	" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO = ttd.ASSET_NUMBER and gps.System_id=ttd.SYSTEM_ID " +
//	" left outer join AMS.dbo.TRIP_CONFIGURATION tc on tc.SYSTEM_ID=gps.System_id and tc.CUSTOMER_ID=gps.CLIENTID " + 
//	" where ttd.CUSTOMER_ID = ? and ttd.SYSTEM_ID = ? and ttd.STATUS = 'CLOSED' and ttd.TRIP_STATUS = 'CHECK_ETA' " +
//	"and gps.LOCATION !='No GPS Device Connected' and gps.LOCATION != tc.HEAD_QUATERS and ETA_SOURCE_HUB <30 " + 
	" union  " +
	" select count (*) as COUNT,'ON_TRIP' as COUNT_TYPE " +  
	" from AMS.dbo.TRACK_TRIP_DETAILS ttd " +
	" where STATUS='OPEN' and ACTUAL_TRIP_START_TIME is not null and CUSTOMER_ID=? and SYSTEM_ID=? AND ASSET_NUMBER IN (##) " +
	" AND  ttd.TRIP_ID IN (select TRIP_ID from DES_TRIP_DETAILS where TRIP_DESTINATION in(REGIONSID)) "+
	" union  " +
	" select count (*) as COUNT,'TRIP_ASSIGNED' as COUNT_TYPE " +  
	" from AMS.dbo.TRACK_TRIP_DETAILS ttd  " +
	" where STATUS='OPEN' and ACTUAL_TRIP_START_TIME is null and CUSTOMER_ID=? and SYSTEM_ID=? AND ASSET_NUMBER IN (##) " +
	" AND ttd.TRIP_ID IN (select TRIP_ID from DES_TRIP_DETAILS where TRIP_DESTINATION in(REGIONSID)) "+
	" union  " +
	" select   count(*) as COUNT, 'INSIDE_HQ' as COUNT_TYPE " + 
	" from AMS.dbo.gpsdata_history_latest a    " +
	" left outer join AMS.dbo.TRIP_CONFIGURATION tc on tc.SYSTEM_ID=a.System_id and tc.CUSTOMER_ID=CLIENTID " + 
	" where  a.CLIENTID=? and a.System_id=?  " + 
	" and LOCATION = tc.HEAD_QUATERS AND REGISTRATION_NO NOT IN(select ASSET_NUMBER from TRACK_TRIP_DETAILS WHERE STATUS='OPEN' and CUSTOMER_ID=? AND SYSTEM_ID=? AND DATEDIFF(mi,ACTUAL_TRIP_START_TIME,getutcdate())<5)"+//pra
	" union  " +
	" select COUNT (a.REGISTRATION_NO) as COUNT, 'TOTAL' as COUNT_TYPE  " + 
	" from AMS.dbo.gpsdata_history_latest a    " + 
	" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=a.System_id and dv.REGISTRATION_NO = a.REGISTRATION_NO    " + 
	" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id  " + 
	" where a.CLIENTID=? and a.System_id=? and a.LOCATION !='No GPS Device Connected' " +
	" union  " +
	" select COUNT(*) as COUNT ,'TOTAL_AVAILABLE' as COUNT_TYPE " +
	" from AMS.dbo.gpsdata_history_latest a   " +
	" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=a.System_id and dv.REGISTRATION_NO = a.REGISTRATION_NO " +  
	" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id  " +
	" where a.CLIENTID=? and a.System_id=?" +
	" and a.REGISTRATION_NO not in(  " +
	" select distinct ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where CUSTOMER_ID =? and SYSTEM_ID=? and STATUS ='OPEN')" +
	" union  " +
	" select COUNT(*) AS COUNT ,'AT_BORDER' AS COUNT_TYPE from [AMS].[dbo].[gpsdata_history_latest] ghl "+
	" inner join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttd.[ASSET_NUMBER] collate SQL_Latin1_General_CP1_CI_AS=REGISTRATION_NO "+
	" collate SQL_Latin1_General_CP1_CI_AS "+
	" where ttd.TRIP_ID IN(select TRIP_ID from DES_TRIP_DETAILS where TRIP_DESTINATION in(REGIONSID)) AND REGISTRATION_NO  in( "+
	" select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS WHERE CUSTOMER_ID = ? AND SYSTEM_ID = ? AND "+
	" STATUS = 'OPEN' AND ASSET_NUMBER COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT REGISTRATION_NO FROM "+
	" [ALERT].[dbo].[HUB_ALERTS] ha WHERE TYPE_OF_ALERT = 17 AND ha.REGISTRATION_NO IN(##) AND ha.INSERTED_TIME > "+
	" ACTUAL_TRIP_START_TIME AND ha.HUB_ID  IN (SELECT HUBID FROM LOCATION_ZONE WHERE  OPERATION_ID = 2 "+
	" ))) AND "+
	" STATUS = 'OPEN' AND ASSET_NUMBER COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT REGISTRATION_NO FROM "+
	" [ALERT].[dbo].[HUB_ALERTS] ha WHERE TYPE_OF_ALERT = 17 AND ha.REGISTRATION_NO IN(##) AND ha.INSERTED_TIME > "+
	" ACTUAL_TRIP_START_TIME AND ha.HUB_ID  IN (SELECT HUBID FROM LOCATION_ZONE  WHERE  OPERATION_ID = 2 "+
	" ))";
//	" union  " +
//	" select   count(*) as COUNT, 'INSIDE_HQ_TRIP_ASSIGNED' as COUNT_TYPE " +
//	" from AMS.dbo.gpsdata_history_latest a " +     
//	" left outer join AMS.dbo.TRIP_CONFIGURATION tc on tc.SYSTEM_ID=a.System_id and tc.CUSTOMER_ID=CLIENTID " +
//	" where  a.CLIENTID=? and a.System_id=? " +
//	" and LOCATION = tc.HEAD_QUATERS and a.REGISTRATION_NO in(select ASSET_NUMBER from " + 
//	" AMS.dbo.TRACK_TRIP_DETAILS where STATUS = 'OPEN' and CUSTOMER_ID = ? and SYSTEM_ID = ? )";
	
	public static final String GET_AT_BORDER_VEHICLE_FOR_JOTUN="select  REGISTRATION_NO as REG_NO,TRIP_ID,LATITUDE,LONGITUDE,ttd.DRIVER_NAME,ttd.DRIVER_NUMBER as DRIVER_CONTACT ,LOCATION,ghl.DURATION,ghl.CATEGORY  from [AMS].[dbo].[gpsdata_history_latest] ghl "+
		" inner join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttd.[ASSET_NUMBER] collate SQL_Latin1_General_CP1_CI_AS=REGISTRATION_NO "+
		" collate SQL_Latin1_General_CP1_CI_AS "+
		" where REGISTRATION_NO  in( "+
		" select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS WHERE  CUSTOMER_ID = ? AND SYSTEM_ID = ?  AND "+
		" STATUS = 'OPEN' AND ASSET_NUMBER COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT REGISTRATION_NO FROM "+
		" [ALERT].[dbo].[HUB_ALERTS] ha WHERE TYPE_OF_ALERT = 17 AND ha.INSERTED_TIME > "+
		" ACTUAL_TRIP_START_TIME AND ha.REGISTRATION_NO IN(#) AND ha.HUB_ID  IN (SELECT HUBID FROM LOCATION_ZONE  WHERE  OPERATION_ID = 2 "+
		" ))) AND "+
		" STATUS = 'OPEN' AND ASSET_NUMBER COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT REGISTRATION_NO FROM "+
		" [ALERT].[dbo].[HUB_ALERTS] ha WHERE TYPE_OF_ALERT = 17 AND ha.INSERTED_TIME > "+
		" ACTUAL_TRIP_START_TIME AND ha.REGISTRATION_NO IN(#) AND ha.HUB_ID  IN (SELECT HUBID FROM LOCATION_ZONE  WHERE  OPERATION_ID = 2 "+
		" ))";
	
	public static final String GET_LATEST_RECORD_OF_ALL_VEHICLE_FOR_BORDER="select ld.REGISTRATION_NO,DATEDIFF(mi,ld.ARRIVAL_TIME,getutcdate()) AS DETENTION ,isnull(dm.Fullname,'') as DRIVER_NAME,LATITUDE,LONGITUDE,isnull(gps.EASTWEST,'') as DIRECTION,substring(HUB_NAME,8,10) as HUB_NAME, "+
	"  CATEGORY,DURATION, dm.Mobile as DRIVER_CONTACT from [AMS].[dbo].[LIVE_DETENTION_NEW] ld "+
	"  inner join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttd.[ASSET_NUMBER] = ld.REGISTRATION_NO "+
	" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=ld.REGISTRATION_NO "+
	" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=ld.SYSTEM_ID and dv.REGISTRATION_NO = ld.REGISTRATION_NO  "+
	" collate database_default "+
	" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id  "+
	" where ld.CLIENT_ID = ? and ld.SYSTEM_ID = ?  and ld.HUB_TYPE=6 and ttd.STATUS='OPEN' and ld.REGISTRATION_NO in(#) order by  HUB_NAME desc,DETENTION desc ";//Operation id 6 - check post
	
	public static final String GET_AT_BORDER_VEHICLE_FOR_JOTUN_FILTER_BY_REGIONS="select  REGISTRATION_NO as REG_NO,TRIP_ID,LATITUDE,LONGITUDE,ttd.DRIVER_NAME,ttd.DRIVER_NUMBER as DRIVER_CONTACT ,LOCATION,ghl.DURATION,ghl.CATEGORY  from [AMS].[dbo].[gpsdata_history_latest] ghl "+
	" inner join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttd.[ASSET_NUMBER] collate SQL_Latin1_General_CP1_CI_AS=REGISTRATION_NO "+
	" collate SQL_Latin1_General_CP1_CI_AS "+
	" where ttd.TRIP_ID IN(select TRIP_ID from DES_TRIP_DETAILS where TRIP_DESTINATION in(REGIONSID)) AND REGISTRATION_NO  in( "+
	" select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS WHERE  CUSTOMER_ID = ? AND SYSTEM_ID = ?  AND "+
	" STATUS = 'OPEN' AND ASSET_NUMBER COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT REGISTRATION_NO FROM "+
	" [ALERT].[dbo].[HUB_ALERTS] ha WHERE TYPE_OF_ALERT = 17 AND ha.INSERTED_TIME > "+
	" ACTUAL_TRIP_START_TIME AND ha.REGISTRATION_NO IN(#) AND ha.HUB_ID  IN (SELECT HUBID FROM LOCATION_ZONE  WHERE  OPERATION_ID = 2 "+
	" ))) AND "+
	" STATUS = 'OPEN' AND ASSET_NUMBER COLLATE SQL_Latin1_General_CP1_CI_AS IN (SELECT REGISTRATION_NO FROM "+
	" [ALERT].[dbo].[HUB_ALERTS] ha WHERE TYPE_OF_ALERT = 17 AND ha.INSERTED_TIME > "+
	" ACTUAL_TRIP_START_TIME AND ha.REGISTRATION_NO IN(#) AND ha.HUB_ID  IN (SELECT HUBID FROM LOCATION_ZONE WHERE  OPERATION_ID = 2 "+
	" ))";
	
	public static final String GET_STOPPED_VEHICLE_FOR_JOTUN="select REGISTRATION_NO as REG_NO,TRIP_ID,ghl.LATITUDE,ghl.LONGITUDE,ttd.DRIVER_NAME, "+
		" ttd.DRIVER_NUMBER as DRIVER_CONTACT ,LOCATION,CATEGORY,DURATION,lzb.OPERATION_ID,isnull(ghl.EASTWEST,'') as DIRECTION from [AMS].[dbo].[gpsdata_history_latest] ghl "+
		" inner join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttd.[ASSET_NUMBER] collate SQL_Latin1_General_CP1_CI_AS=REGISTRATION_NO "+
		" collate SQL_Latin1_General_CP1_CI_AS "+
		" inner join LOCATION_ZONE lzb on lzb.HUBID=ghl.HUB_ID "+
		" where CATEGORY='stoppage' AND STATUS = 'OPEN' AND DURATION >0 AND ACTUAL_TRIP_START_TIME is not null AND CUSTOMER_ID = ? AND SYSTEM_ID = ? and ghl.REGISTRATION_NO IN(#) order by DURATION DESC";
	
	public static final String GET_STOPPED_VEHICLE_FOR_JOTUN_FILTER_BY_REGIONS="select REGISTRATION_NO as REG_NO,TRIP_ID,ghl.LATITUDE,ghl.LONGITUDE,ttd.DRIVER_NAME, "+
	" ttd.DRIVER_NUMBER as DRIVER_CONTACT ,LOCATION,DURATION,lzb.OPERATION_ID from [AMS].[dbo].[gpsdata_history_latest] ghl "+
	" inner join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttd.[ASSET_NUMBER] collate SQL_Latin1_General_CP1_CI_AS=REGISTRATION_NO "+
	" collate SQL_Latin1_General_CP1_CI_AS "+
	" inner join LOCATION_ZONE lzb on lzb.HUBID=ghl.HUB_ID "+
	" where ttd.TRIP_ID IN(select TRIP_ID from DES_TRIP_DETAILS where TRIP_DESTINATION in(REGIONSID)) AND CATEGORY='stoppage' AND STATUS = 'OPEN' AND CUSTOMER_ID = ? AND SYSTEM_ID = ? and ghl.REGISTRATION_NO IN(#)";
	
	public static final String GET_AVAILABLE_VEHICLES_FOR_JOTUN = "select * from (select distinct isnull(a.REGISTRATION_NO,'') as REG_NO, isnull(dm.Fullname,'') as DRIVER_NAME, "+
	   " isnull(dm.Mobile,'') as DRIVER_CONTACT,'' as TRIP_ID,   "+
	   " isnull(LATITUDE,'') as LATITUDE ,isnull(LONGITUDE,'') as LONGITUDE ,isnull(a.EASTWEST,'') as DIRECTION,a.LOCATION,a.CATEGORY,a.DURATION,a.HUB_ID,"+
	   "(SELECT TOP 1 ETA_SOURCE_HUB FROM TRACK_TRIP_DETAILS_SUB tts "+
	   " INNER JOIN TRACK_TRIP_DETAILS ttd on ttd.TRIP_ID=tts.TRIP_ID WHERE ttd.ASSET_NUMBER=a.REGISTRATION_NO "+
	   " and ETA_SOURCE_HUB is not null ORDER BY ttd.TRIP_ID DESC)  as eta_source_hub "+
	   " from AMS.dbo.gpsdata_history_latest a  "+ 
	   " left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=a.System_id and dv.REGISTRATION_NO = a.REGISTRATION_NO  "+
	   " left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id "+
	   " where a.System_id=? and a.CLIENTID=? "+// and a.GMT between dateadd(hh,-6,getUTCDate()) and getUTCDate() " +
	   " and a.REGISTRATION_NO not in( "+
	   " select distinct ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID =? and STATUS ='OPEN' )) t WHERE REG_NO IN (ADMINCVEHILCES) order by eta_source_hub";
	
	public static final String GET_AVAILABLE_VEHICLES_FOR_JOTUN_BY_REGION_FILTER = "select * from (select distinct isnull(a.REGISTRATION_NO,'') as REG_NO, isnull(dm.Fullname,'') as DRIVER_NAME, "+
	   " isnull(dm.Mobile,'') as DRIVER_CONTACT,'' as TRIP_ID,   "+
	   " isnull(LATITUDE,'') as LATITUDE ,isnull(LONGITUDE,'') as LONGITUDE ,a.LOCATION,a.CATEGORY,a.DURATION,a.HUB_ID,"+
	   "(SELECT TOP 1 ETA_SOURCE_HUB FROM TRACK_TRIP_DETAILS_SUB tts "+
	   " INNER JOIN TRACK_TRIP_DETAILS ttd on ttd.TRIP_ID=tts.TRIP_ID WHERE ttd.ASSET_NUMBER=a.REGISTRATION_NO "+
	   " and  ttd.TRIP_ID IN (select TRIP_ID from [AMS].[dbo].[DES_TRIP_DETAILS] where TRIP_DESTINATION in(REGIONSID)) and ETA_SOURCE_HUB is not null ORDER BY ttd.TRIP_ID DESC)  as eta_source_hub "+
	   " from AMS.dbo.gpsdata_history_latest a  "+ 
	   " left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=a.System_id and dv.REGISTRATION_NO = a.REGISTRATION_NO  "+
	   " left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id "+
	   " where a.System_id=? and a.CLIENTID=? "+// and a.GMT between dateadd(hh,-6,getUTCDate()) and getUTCDate() " +
	   " and a.REGISTRATION_NO not in( "+
	   " select distinct ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID =? and STATUS ='OPEN' )) t WHERE REG_NO IN (##) order by eta_source_hub";
	
	public static final String GET_OPEN_TRIPS_VEHICLES = "select TRIP_ID,isnull(ttd.ASSET_NUMBER,'') as REG_NO,gps.LATITUDE,gps.LONGITUDE,gps.LOCATION,isnull(gps.EASTWEST,'') as DIRECTION, " +
		" isnull(dm.Fullname,'') as DRIVER_NAME,isnull(dm.Mobile,'') as DRIVER_CONTACT, ACTUAL_TRIP_START_TIME,gps.CATEGORY,gps.DURATION,gps.HUB_ID " +
		" from AMS.dbo.TRACK_TRIP_DETAILS ttd " +
		" inner join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO = ttd.ASSET_NUMBER and gps.System_id=ttd.SYSTEM_ID " + 
		" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=gps.System_id and dv.REGISTRATION_NO = gps.REGISTRATION_NO  " +
		" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id " +
		" where STATUS='OPEN' and ttd.CUSTOMER_ID=? and ttd.SYSTEM_ID=? #";
	
	
	public static final String GET_OPEN_TRIPS_VEHICLES_BY_REGION_FILTER = "select TRIP_ID,isnull(ttd.ASSET_NUMBER,'') as REG_NO,gps.LATITUDE,gps.LONGITUDE,gps.LOCATION, " +
	" isnull(dm.Fullname,'') as DRIVER_NAME,isnull(dm.Mobile,'') as DRIVER_CONTACT, ACTUAL_TRIP_START_TIME,gps.CATEGORY,gps.DURATION,gps.HUB_ID " +
	" from AMS.dbo.TRACK_TRIP_DETAILS ttd " +
	" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO = ttd.ASSET_NUMBER and gps.System_id=ttd.SYSTEM_ID " + 
	" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=gps.System_id and dv.REGISTRATION_NO = gps.REGISTRATION_NO  " +
	" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id " +
	" where STATUS='OPEN' and ttd.CUSTOMER_ID=? and ttd.TRIP_ID IN (select TRIP_ID from [AMS].[dbo].[DES_TRIP_DETAILS] where TRIP_DESTINATION in(REGIONSID)) and ttd.SYSTEM_ID=? #";
	
	public static final String GET_INSIDE_HQ_VEHICLES_FOR_JOTUN = "select isnull(a.REGISTRATION_NO,'') as REG_NO,isnull(LATITUDE,'') as LATITUDE ,isnull(LONGITUDE,'') as LONGITUDE,isnull(LOCATION,'') as LOCATION, " +
		" '' as TRIP_ID " +
		" from AMS.dbo.gpsdata_history_latest a    " +
		" left outer join AMS.dbo.TRIP_CONFIGURATION tc on tc.SYSTEM_ID=a.System_id and tc.CUSTOMER_ID=CLIENTID " + 
		" where  a.CLIENTID=? and a.System_id=? " + 
		" and LOCATION = tc.HEAD_QUATERS " +
		" AND REGISTRATION_NO NOT IN(select ASSET_NUMBER from TRACK_TRIP_DETAILS WHERE STATUS='OPEN' AND DATEDIFF(mi,ACTUAL_TRIP_START_TIME,getutcdate())<5)"+//exclude inlcude newly created trips. Location service is slow and it 
		" order by a.HUB_TIME asc ";
	
	public static final String GET_DRIVER_DETENTION ="select ld.REGISTRATION_NO,DATEDIFF(mi,ld.ARRIVAL_TIME,getutcdate()) AS DETENTION ,isnull(dm.Fullname,'') as DRIVER_NAME "+
	" from [AMS].[dbo].[LIVE_DETENTION] ld "+
	" INNER JOIN [dbo].[gpsdata_history_latest] ghl on ghl.REGISTRATION_NO=ld.REGISTRATION_NO "+ 
	" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=ld.SYSTEM_ID and dv.REGISTRATION_NO = ld.REGISTRATION_NO  "+
	" collate database_default "+
	" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id  "+
	" where ld.SYSTEM_ID = ? and ld.CLIENT_ID = ?  and ld.IS_IN_HQ=1 and ld.REGISTRATION_NO in(##)  order by ld.ARRIVAL_TIME desc ";
	
	public static final String GET_CURRENT_LOCATION = " SELECT LATITUDE,LONGITUDE,LOCATION,gps.REGISTRATION_NO,isnull(dm.Fullname,'') as DRIVER_NAME," +
													  " isnull(dm.Mobile,'') as DRIVER_CONTACT FROM dbo.gpsdata_history_latest gps "+
													  " INNER JOIN TRACK_TRIP_DETAILS td ON td.ASSET_NUMBER=gps.REGISTRATION_NO AND td.SYSTEM_ID=gps.System_id "+
													  " LEFT OUTER JOIN AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=td.SYSTEM_ID and dv.REGISTRATION_NO = td.ASSET_NUMBER "+
													  " LEFT OUTER JOIN AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id "+
													  " WHERE td.TRIP_ID=? and td.STATUS='OPEN' ";
	
	public static final String CHECK_HUB_DEPARTURE  = "SELECT ACT_DEP_DATETIME FROM DES_TRIP_DETAILS des INNER JOIN TRIP_ORDER_DETAILS " +
													  " trd ON des.TRIP_ID=trd.TRIP_ID WHERE des.TRIP_ID=? AND trd.TRIP_CUSTOMER_ID=? and SEQUENCE !=0 ";
	
	
	 public static final String INSERT_TRIP_DETAILS_JOTUN = " insert into AMS.dbo.TRACK_TRIP_DETAILS (ASSET_NUMBER,PRODUCT_LINE,INSERTED_TIME," +
	 " SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,DRIVER_NAME,DRIVER_NUMBER,DRIVER_ID )" +
	 " values (?,?,getutcdate(),?,?,?,?,?,?) ";
	 
	 public static final String INSERT_TRIP_DETAILS_CUSTOMER_COLLECTION = " insert into AMS.dbo.TRACK_TRIP_DETAILS (ASSET_NUMBER,PRODUCT_LINE,INSERTED_TIME," +
	 " SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,STATUS,AUTO_CLOSE,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME,DRIVER_NAME,DRIVER_NUMBER )" +
	 " values (?,?,getutcdate(),?,?,?,'CLOSED','N',getutcdate(),getutcdate(),'Customer Collection', 'Customer Collection') ";
	 
	 public static final String INSERT_TRIP_DETAILS_JOTUN_MISSED_TRIP = " insert into AMS.dbo.TRACK_TRIP_DETAILS (ASSET_NUMBER,PRODUCT_LINE,INSERTED_TIME," +
	 " SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,ACTUAL_TRIP_START_TIME,TRIP_TYPE,DRIVER_NAME,DRIVER_NUMBER,DRIVER_ID ) values (?,?,getutcdate(),?,?,?,DATEADD(MI,-?,?),'MISSED_TRIP',?,?,?) ";
	 
	public static final String INSERT_TRACK_TRIP_DETAILS_SUB_JOTUN = "INSERT INTO TRACK_TRIP_DETAILS_SUB (TRIP_ID,LOADING_PARTNER) VALUES (?,?)";
	
	public static final String INSERT_TRIP_POINTS_CHECK_POINTS_JOTUN = " insert into AMS.dbo.DES_TRIP_DETAILS (TRIP_ID,HUB_ID,LATITUDE,LONGITUDE,RADIUS,DETENTION_TIME,SEQUENCE,DISTANCE_FLAG,TRIP_DESTINATION) values (?,?,?,?,?,?,?,?,?)";

	public static final String INSERT_TRIP_POINTS_CUSTOMER_COLL = " insert into AMS.dbo.DES_TRIP_DETAILS (TRIP_ID,SEQUENCE) values (?,?)";

	public static final String INSERT_INTO_TRIP_ORDER_DETAILS = "INSERT INTO AMS.dbo.TRIP_ORDER_DETAILS(DES_TRIP_ID,TRIP_ID,SCAN_ID,ORDER_NO,DELIVERY_TICKET_NO,DELIVERY_NOTE_NO "
           									+ ", TRIP_CUSTOMER_ID, DELIVERY_STATUS ,TRIP_CUSTOMER_NAME ,AUTO_CLOSED,SYSTEM_ID,CUSTOMER_ID) "
											+" VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public static final String INSERT_INTO_TRIP_ORDER_COLLECTION = "INSERT INTO AMS.dbo.TRIP_ORDER_DETAILS(DES_TRIP_ID,TRIP_ID,SCAN_ID,ORDER_NO,DELIVERY_TICKET_NO,DELIVERY_NOTE_NO "
		+ ", TRIP_CUSTOMER_ID, DELIVERY_STATUS ,TRIP_CUSTOMER_NAME ,AUTO_CLOSED,SYSTEM_ID,CUSTOMER_ID,INSERTED_TIME) "
	+" VALUES (?,?,?,?,?,?,?,'Y',?,?,?,?,getutcdate())";
	
	public static final String INSERT_INTO_TRIP_ORDER_CUST_COLLECTION = "INSERT INTO AMS.dbo.TRIP_ORDER_DETAILS(DES_TRIP_ID,TRIP_ID,SCAN_ID,ORDER_NO,DELIVERY_TICKET_NO,DELIVERY_NOTE_NO "
			+ ", TRIP_CUSTOMER_ID, DELIVERY_STATUS ,TRIP_CUSTOMER_NAME ,AUTO_CLOSED,SYSTEM_ID,CUSTOMER_ID," +
					"ACKNOWLEDGE_ORDER,REMARKS, DELIVERED_TIME, ORDER_TYPE,LOADING_PARTNER,COLLECTED_BY,MOBILE_NUMBER,VEHICLE_NUMBER) "
		+" VALUES (?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,getutcdate(),?,?,?,?,?)";
	
	public static final String GET_TRACK_TRIP_BY_TRIP_ID = "SELECT ASSET_NUMBER,PRODUCT_LINE,isnull(us.Firstname,'') as INSERTED_BY,dateadd(mi,?,INSERTED_TIME) as INSERTED_TIME," +
			" dateadd(mi,?,UPDATED_DATETIME) as UPDATED_DATETIME FROM TRACK_TRIP_DETAILS ttd" +
			" left outer join AMS.dbo.Users us on us.System_id=ttd.SYSTEM_ID and us.Client_id=ttd.CUSTOMER_ID and us.User_id=ttd.INSERTED_BY"+
			" WHERE TRIP_ID=?";
	
	public static final String GET_TRACK_TRIP_SUB_BY_TRIP_ID = "SELECT LOADING_PARTNER FROM TRACK_TRIP_DETAILS_SUB WHERE TRIP_ID=? ";
	
	public static final String GET_DES_TRIP_DETAILS_BY_TRIP_ID = "SELECT des.ID,HUB_ID,des.LATITUDE,des.LONGITUDE,des.RADIUS,des.DETENTION_TIME,loc.NAME as LOCATION_NAME,ISNULL(TRIP_DESTINATION,0) AS TRIP_DESTINATION " +
			" FROM AMS.dbo.DES_TRIP_DETAILS des" +
			" Left outer join AMS.dbo.LOCATION_ZONE loc on loc.HUBID = des.HUB_ID "+
			" WHERE TRIP_ID=? order by SEQUENCE ASC";

	public static final String GET_DES_TRIP_ORDER_DETAILS = "SELECT DES_TRIP_ID,SCAN_ID,ORDER_NO,DELIVERY_TICKET_NO,DELIVERY_NOTE_NO "
           									+ ", TRIP_CUSTOMER_ID, DELIVERY_STATUS ,TRIP_CUSTOMER_NAME ,AUTO_CLOSED FROM AMS.dbo.TRIP_ORDER_DETAILS WHERE DES_TRIP_ID=?";
	
	public static final String GET_HUBS_BY_OPERATION_ID  = "  select isnull(HUBID,0) as HUB_ID,isnull(NAME,'') as NAME,isnull(LATITUDE,0) as LATITUDE,isnull(LONGITUDE,0) as LONGITUDE, " +
	" isnull(RADIUS,'') as RADIUS,isnull(ADDRESS,'') as ADDRESS, isnull(Standard_Duration,'') as STD_DUR " + 
	" from LOCATION where SYSTEMID=? and CLIENTID=? and OPERATION_ID=?";
	
	public static final String UPDATE_TRIP_ORDER_DETAIL = "UPDATE TRIP_ORDER_DETAILS SET DELIVERY_STATUS=? WHERE DES_TRIP_ID=?";
	
	public static final String UPDATE_TRIP_TRIP_DETAIL= "update AMS.dbo.TRACK_TRIP_DETAILS set TRIP_STATUS='CHECK_ETA',STATUS='CLOSED',ACTUAL_TRIP_END_TIME=getutcdate(), "
														+" REMARKS=?,ACKNOWLEDGED_BY=? ,ACKNOWLEDGED_DATE=getutcdate() where TRIP_ID = ?";
	
	public static final String DELETE_FROM_DESTRIP = "delete from DES_TRIP_DETAILS WHERE TRIP_ID=?";
	
	public static final String DELETE_FROM_TRIP_ORDER = "delete from TRIP_ORDER_DETAILS WHERE TRIP_ID=?";
	
	public static final String MODIFY_TRACK_TRIP = "update AMS.dbo.TRACK_TRIP_DETAILS set UPDATED_BY=?,UPDATED_DATETIME=getutcdate() where TRIP_ID = ?";
	
	public static final String MODIFY_TRIP_SUB = "update AMS.dbo.TRACK_TRIP_DETAILS_SUB set LOADING_PARTNER = ? where TRIP_ID = ?";

	public static final String CHECK_FOR_DUPLICATE_ORDER_NO = "SELECT * FROM TRIP_ORDER_DETAILS WHERE SCAN_ID=? and DELIVERY_STATUS ! = 'NOT_DELIVERED'";
	
	public static final String GET_ALL_DRIVERS = "select distinct isnull(a.REGISTRATION_NO,'') as REGISTRATION_NO, isnull(dm.Fullname,'') as DRIVER_NAME, "+ 
		" isnull(dm.Mobile,'') as DRIVER_CONTACT,'' as TRIP_ID,Driver_id as DRIVER_ID "+  
		" from AMS.dbo.gpsdata_history_latest a  "+
		" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=a.System_id and dv.REGISTRATION_NO = a.REGISTRATION_NO "+  
		" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id "+
		" where a.System_id=? and a.CLIENTID=?";
	
	public static final String  GET_ORDER_DETAILS_FOR_DRIVER = "select tod.SCAN_ID,tod.ORDER_NO,DELIVERY_TICKET_NO,DELIVERY_NOTE_NO "+  
		" , tod.TRIP_CUSTOMER_ID, DELIVERY_STATUS ,TRIP_CUSTOMER_NAME ,AUTO_CLOSED, isnull(us.Firstname,'') as INSERTED_BY,dateadd(mi,?,INSERTED_TIME) as INSERTED_TIME "+ 
		" from AMS.dbo.TRACK_TRIP_DETAILS ttd "+
		" left outer join AMS.dbo.TRIP_ORDER_DETAILS tod on ttd.TRIP_ID = tod.TRIP_ID "+
		" left outer join AMS.dbo.Users us on us.System_id=ttd.SYSTEM_ID and us.Client_id=ttd.CUSTOMER_ID and us.User_id=ttd.INSERTED_BY "+
		" where ttd.ASSET_NUMBER =?  and tod.SCAN_ID is not null and tod.ACKNOWLEDGE_ORDER is null and ttd.STATUS = 'CLOSED'"; 
	
	public static final String  GET_ACK_DRIV_TRIP_ORDER_DETAILS="SELECT DES_TRIP_ID,SCAN_ID,ORDER_NO,DELIVERY_TICKET_NO,DELIVERY_NOTE_NO "+ 
		" , TRIP_CUSTOMER_ID, DELIVERY_STATUS ,TRIP_CUSTOMER_NAME ,AUTO_CLOSED FROM AMS.dbo.TRIP_ORDER_DETAILS tod "+
		" left outer join AMS.dbo.Driver_Master dm on dm.System_id = tod.SYSTEM_ID and dm.Client_id = tod.CUSTOMER_ID "+
		" WHERE Driver_id=? ";
	
	//public static final String SAVE_ACK_ORDERS = "";//"update AMS.dbo.TRIP_ORDER_DETAILS set ACKNOWLEDGE_ORDER = getutcdate(), DELIVERY_STATUS = 'DELIVERED' where SCAN_ID in (#) and SYSTEM_ID = ? and CUSTOMER_ID = ? "; 

	public static final String SAVE_ACK_ORDERS = "update AMS.dbo.TRIP_ORDER_DETAILS set ACKNOWLEDGE_ORDER = getutcdate(), DELIVERY_STATUS = ?, REMARKS = ? where SCAN_ID=? and SYSTEM_ID = ? and CUSTOMER_ID = ? ";

	public static final String GET_ALL_AVAILABLE_AND_TRIP_ASSIGNED_VEHICLES="select a.REGISTRATION_NO as REGISTRATION_NO,a.LATITUDE,a.LONGITUDE " +
	" from AMS.dbo.gpsdata_history_latest a " +
	" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=a.System_id and dv.REGISTRATION_NO = a.REGISTRATION_NO " +
	" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id " +
	" where a.System_id=? and a.CLIENTID=? " +
	" and a.REGISTRATION_NO not in(   " +
	" select distinct ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID =? and STATUS ='OPEN') " +
	" union " +
	" select ttd.ASSET_NUMBER as REGISTRATION_NO,gps.LATITUDE,gps.LONGITUDE " +
	" from AMS.dbo.TRACK_TRIP_DETAILS ttd " +
	" left outer join AMS.dbo.gpsdata_history_latest gps on gps.REGISTRATION_NO=ttd.ASSET_NUMBER and gps.System_id=ttd.SYSTEM_ID " +
	" where ttd.SYSTEM_ID=? and ttd.CUSTOMER_ID =? and ttd.STATUS ='OPEN' and ttd.ACTUAL_TRIP_START_TIME is null";

	public static final String GET_HEADQUARTERS_HUBID="select HUBID from LOCATION where SYSTEMID=? and CLIENTID = ? and OPERATION_ID=34 ";
	
	public static final String GET_HEADQUARTERS_ARRIVAL_DATETIME= " select top 1 ASSET_NUMBER, DATEDIFF(mi,SRC_ARR_DATE_TIME,getutcdate()) as HQ_ARRIVAL_DATETIME ,isnull(dm.Fullname,'') as DRIVER_NAME from AMS.dbo.TRACK_TRIP_DETAILS ttd " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS_SUB ttds on ttd.TRIP_ID=ttds.TRIP_ID " +
		" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=ttd.SYSTEM_ID and dv.REGISTRATION_NO = ttd.ASSET_NUMBER  collate database_default " + 
		" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = dm.System_id  " +
		" where ttd.SYSTEM_ID=? and ttd.CUSTOMER_ID = ? and ttd.ASSET_NUMBER = ? and ttd.TRIP_STATUS = 'ARRIVED_AT_SOURCE_HUB' and ttds.SRC_ARR_DATE_TIME is not null order by ttd.TRIP_ID desc ";

	//For NTC Dashboard
	
	public static final String GET_DASHBOARD_COUNTS = "SELECT COUNT(*) AS COUNT ,'LOADED' AS STATUS" +
													" FROM ASSET_TRIP_DETAILS atd " +
													" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=atd.VEHICLE_NO AND atd.SYSTEM_ID=gps.System_id and atd.CUSTOMER_ID=gps.CLIENTID " +
													" WHERE TRIP_STATUS='OPEN' AND TRIP_SHEET_TYPE='Loaded' and STATUS IN('Fresh','Draft') AND SYSTEM_ID=? AND CUSTOMER_ID=?"+
													" union all "+
													" SELECT COUNT(*) AS COUNT ,'EMPTY' AS STATUS FROM ASSET_TRIP_DETAILS atd " +
													" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=atd.VEHICLE_NO AND atd.SYSTEM_ID=gps.System_id and atd.CUSTOMER_ID=gps.CLIENTID "+
													" WHERE TRIP_STATUS='OPEN' AND TRIP_SHEET_TYPE='Empty' and STATUS IN('Fresh','Draft') AND SYSTEM_ID=? AND CUSTOMER_ID=?";


	public static final String GET_VEHICLE_DETAILS_FOR_MAPVIEW = "SELECT LATITUDE,LONGITUDE,LOCATION,REGISTRATION_NO,STATUS,SPEED," +
					" TRIP_SHEET_TYPE,TRIPSHEET_NO,MATERIAL_NAME,COUSTOMER_NAME,CREW_NAME,CREW_MOBILE  FROM gpsdata_history_latest gps "+
					" left outer join ASSET_TRIP_DETAILS atd on atd.VEHICLE_NO=gps.REGISTRATION_NO AND STATUS='OPEN' WHERE System_id=? AND CLIENTID=? ";
	
	public static final String GET_HIGH_PRIORITY_VEHICLE_DETAILS_FOR_MAPVIEW = "SELECT LATITUDE,LONGITUDE,LOCATION,REGISTRATION_NO,STATUS,SPEED," +
	" TRIP_SHEET_TYPE,TRIPSHEET_NO,MATERIAL_NAME,COUSTOMER_NAME,CREW_NAME,CREW_MOBILE  FROM gpsdata_history_latest gps "+
	" left outer join ASSET_TRIP_DETAILS atd on atd.VEHICLE_NO=gps.REGISTRATION_NO WHERE System_id=? AND CLIENTID=? AND atd.HIGH_PRIORITY=?";
	
	public static final String GET_HIGH_PRIORITY_CHART = " SELECT top 3 count(*),COUSTOMER_NAME FROM ASSET_TRIP_DETAILS where "+
														 " TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft') AND HIGH_PRIORITY='Y' AND SYSTEM_ID=? and CUSTOMER_ID=? AND COUSTOMER_NAME <> '' group by COUSTOMER_NAME ORDER BY  COUNT(*) DESC ";
	
	public static final String GET_HIGH_PRIORITY_COUNT_CHART = " SELECT count(*) FROM ASSET_TRIP_DETAILS  atd "
								+" inner  join gpsdata_history_latest gps on atd.VEHICLE_NO=gps.REGISTRATION_NO where "
								+" TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft')AND HIGH_PRIORITY='Y'  AND SYSTEM_ID=? AND CUSTOMER_ID=? and System_id=? and CLIENTID=?";
	
	public static final String GET_CUSTOMER_COUNT_CHART = " SELECT count(*),COUSTOMER_NAME FROM ASSET_TRIP_DETAILS where "+
	 " TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft') AND SYSTEM_ID=? and CUSTOMER_ID=? AND COUSTOMER_NAME <> '' group by COUSTOMER_NAME ORDER BY  COUNT(*) DESC ";
	
	public static final String GET_ONLINE_VEHICLE_CHART = " SELECT count(COUSTOMER_NAME),COUSTOMER_NAME FROM ASSET_TRIP_DETAILS where TRIP_STATUS='OPEN' " +
	 													  " and COUSTOMER_NAME <> '' group by COUSTOMER_NAME ";
	
	 public static final String GET_COMMU_NONCOMMU_COUNT_FOR_LTSP = " select count(*) as TOTAL_VEHICLES, "+
	   " SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) < ? and LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END)AS COMM, "+
	   " SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >=?  and LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END)AS NONCOMM , "+
	   " SUM(CASE WHEN LOCATION ='No GPS Device Connected' THEN 1 ELSE 0 END)AS NOGPS "+
	   " from AMS.dbo.gpsdata_history_latest a "+
	   " where a.System_id=? and CLIENTID=? ";
	 
	 public static final String GET_All_VEHICLE_INFO_FOR_NTC = " select LATITUDE,LONGITUDE,REGISTRATION_NO,SPEED,LOCATION,DRIVER_NAME"+
	   " from AMS.dbo.gpsdata_history_latest a "+
	   " where a.System_id=? and CLIENTID=? ";
	 
	 public static final String GET_ONLINE_VEHICLE_INFO_FOR_NTC = "select LATITUDE,LONGITUDE,REGISTRATION_NO,SPEED ,LOCATION,DRIVER_NAME" 
		   +" from AMS.dbo.gpsdata_history_latest a "
		   +" where a.System_id=? and CLIENTID=? AND DATEDIFF(hh,GMT,getutcdate()) < ? and LOCATION !='No GPS Device Connected'";
		 
	public static final String GET_OFFLINE_VEHICLE_INFO_FOR_NTC = "select LATITUDE,LONGITUDE,REGISTRATION_NO,SPEED,LOCATION,DRIVER_NAME" 
		  +" from AMS.dbo.gpsdata_history_latest a " 
		  +" where a.System_id=? and CLIENTID=? AND DATEDIFF(hh,GMT,getutcdate()) >=?  and LOCATION !='No GPS Device Connected'";
	 
	public static final String GET_lOADED_VEHICLE_INFO_FOR_NTC = "SELECT LATITUDE,LONGITUDE,REGISTRATION_NO,SPEED ,CREW_NAME,LOCATION"
          +" FROM ASSET_TRIP_DETAILS atd "
          +" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=atd.VEHICLE_NO AND atd.SYSTEM_ID=gps.System_id and atd.CUSTOMER_ID=gps.CLIENTID "
          +" WHERE TRIP_STATUS='OPEN' AND TRIP_SHEET_TYPE='Loaded' and STATUS IN('Fresh','Draft') AND SYSTEM_ID=? AND CUSTOMER_ID=?";
	
	public static final String GET_EMPTY_VEHICLE_INFO_FOR_NTC = "SELECT LATITUDE,LONGITUDE,REGISTRATION_NO,SPEED ,CREW_NAME,LOCATION FROM ASSET_TRIP_DETAILS atd "
		  +" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=atd.VEHICLE_NO AND atd.SYSTEM_ID=gps.System_id and atd.CUSTOMER_ID=gps.CLIENTID "
		  +" WHERE TRIP_STATUS='OPEN' AND TRIP_SHEET_TYPE='Empty' and STATUS IN('Fresh','Draft') AND SYSTEM_ID=? AND CUSTOMER_ID=?";
	
	public static final String GET_ONLINE_CHART = "select SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) < ? and LOCATION !='No GPS Device Connected'" +
			" THEN 1 ELSE 0 END)AS COUNT,'COMM' AS TYPE "+
			" from AMS.dbo.gpsdata_history_latest a "+
			" where a.System_id=? and CLIENTID=?";
//			" UNION ALL "+
//			" select count(*) AS COUNT,'STOPPAGE' AS TYPE from AMS.dbo.gpsdata_history_latest a "+
//			" LEFT OUTER JOIN  ADMINISTRATOR.dbo.CUSTOMER_MASTER cm ON cm.SYSTEM_ID=a.System_id AND cm.CUSTOMER_ID=a.CLIENTID "+
//			" where CATEGORY='stoppage' and a.System_id=? and CLIENTID=? and DURATION >STOPPAGE_TIME_ALERT "+
//			" UNION ALL "+
//			" select count(*) AS COUNT,'IDLE' AS TYPE from AMS.dbo.gpsdata_history_latest a "+
//			" LEFT OUTER JOIN  ADMINISTRATOR.dbo.CUSTOMER_MASTER cm ON cm.SYSTEM_ID=a.System_id AND cm.CUSTOMER_ID=a.CLIENTID "+
//			" where CATEGORY='idle' and a.System_id=? and CLIENTID=? and DURATION >IDLETIME_ALERT ";
	
	public static final String GET_VEHICLE_LIVE_STATUS_FOR_LTSP="select SUM(CASE when (a.CATEGORY='stoppage') THEN 1 ELSE 0 END) as STOPPED_COUNT,SUM(CASE when a.CATEGORY='idle' THEN 1 ELSE 0 END) as IDLE,SUM(CASE when a.CATEGORY='running' THEN 1 ELSE 0 END) as RUNNING from dbo.gpsdata_history_latest a with (NOLOCK) " +
    " inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " +
    "inner  join  tblVehicleMaster c on b.System_id=c.System_id and c.VehicleNo=b.Registration_no "+
    "where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and  DATEDIFF(hh,a.GMT,getutcdate()) < ? and b.User_id=? ";

	public static final String GET_VEHICLE_LIVE_STATUS_FOR_CLIENT="select SUM(CASE when (a.CATEGORY='stoppage') THEN 1 ELSE 0 END) as STOPPED_COUNT,SUM(CASE when a.CATEGORY='idle' THEN 1 ELSE 0 END) as IDLE,SUM(CASE when a.CATEGORY='running' THEN 1 ELSE 0 END) as RUNNING from dbo.gpsdata_history_latest a with (NOLOCK) " +
	    " inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " +
	    "inner  join  tblVehicleMaster c on b.System_id=c.System_id and c.VehicleNo=b.Registration_no and c.Status='Active' "+
	    "where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and  DATEDIFF(hh,a.GMT,getutcdate()) < ? and b.User_id=? ";

	public static final String GET_OFFLINE_CHART = " select SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >= ? and LOCATION !='No GPS Device Connected' "
			+" THEN 1 ELSE 0 END)AS COUNT,'NoCOMM' AS TYPE "
			+" from AMS.dbo.gpsdata_history_latest a "
			+" where a.System_id=? and CLIENTID=? ";
	
	public static final String GET_DISCONNECTED_COUNT = "select gps.REGISTRATION_NO,( select top 1 t.HUB_ID from"
			+" (select HUB_ID,GMT from Alert (nolock) where TYPE_OF_ALERT=7 AND REGISTRATION_NO=gps.REGISTRATION_NO "
			+" union all "
			+" select HUB_ID,GMT from Alert_History (nolock) where TYPE_OF_ALERT=7 AND REGISTRATION_NO=gps.REGISTRATION_NO) t order by t.GMT DESC ) as MAIN_POWER_STATUS "
			+" from gpsdata_history_latest (nolock) gps where System_id=? and CLIENTID=? and DATEDIFF(hh,GMT,getutcdate()) >= ? and LOCATION !='No GPS Device Connected' ";
	
	public static final String GET_POOR_SATELLITE_COUNT_FOR_LTSP="select count(1) as SATELLITE_COUNT from dbo.gpsdata_history_latest a  "
			+" inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id "
			+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
			+" where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' "
			+" and DATEDIFF(hh,a.INVALID_UPDATETIME,getutcdate()) <? and  b.User_id=? and a.VALID='N' and a.INVALID_UPDATETIME is not null";
	
	public static final String GET_All_VEHICLE_COUNT_BY_LOCATION="SELECT Count(*),'Trips' as Type FROM ASSET_TRIP_DETAILS atd "
									+" inner  join gpsdata_history_latest gps on atd.VEHICLE_NO=gps.REGISTRATION_NO  WHERE "
									+" TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft')"
									+" AND SYSTEM_ID=? AND CUSTOMER_ID=? and System_id=? and CLIENTID=?"
									+" union all"
									+" SELECT Count(*),'Loading' as Type"
									+" FROM gpsdata_history_latest gps "
									+" left outer join ASSET_TRIP_DETAILS atd on atd.VEHICLE_NO=gps.REGISTRATION_NO WHERE "
									+" TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft')"
									+" AND gps.HUB_ID in(select HUBID from LOCATION_ZONE_A where OPERATION_ID=37)"
									+" AND System_id=? AND CLIENTID=? "
									+" union all "
									+" SELECT count(*),'UnLoading' as Type "
									+" FROM gpsdata_history_latest gps "
									+" left outer join ASSET_TRIP_DETAILS atd on atd.VEHICLE_NO=gps.REGISTRATION_NO WHERE "
									+" TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft') AND "
									+" gps.HUB_ID in(select HUBID from LOCATION_ZONE_A where OPERATION_ID=38)"
									+" AND System_id=? AND CLIENTID=? "
									+" union all "
									+" SELECT count(*),'ServiceCenter' as Type "
									+" FROM gpsdata_history_latest gps "
									+" left outer join ASSET_TRIP_DETAILS atd on atd.VEHICLE_NO=gps.REGISTRATION_NO WHERE "
									+" TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft') AND "
									+" gps.HUB_ID in(select HUBID from LOCATION_ZONE_A where OPERATION_ID=18)"
									+" AND System_id=? AND CLIENTID=?"; 
	
	
//	public static final String GET_TOP_TRIP_BY_MATERIAL =" SELECT top 3 count(*),MATERIAL_NAME FROM ASSET_TRIP_DETAILS where "
//									+" TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft') "
//									+" AND SYSTEM_ID=? and CUSTOMER_ID=? AND MATERIAL_NAME <> '' group by MATERIAL_NAME ORDER BY  COUNT(*) DESC ";

	public static final String GET_TOP_TRIP_BY_MATERIAL ="SELECT COUNT(*) AS TOTAL , 'BLADE' AS MATERIAL_NAME FROM ASSET_TRIP_DETAILS atd "
										+" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=atd.VEHICLE_NO AND atd.SYSTEM_ID=gps.System_id "
										+" and atd.CUSTOMER_ID=gps.CLIENTID "
										+" where TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft') "
										+" AND SYSTEM_ID=? and CUSTOMER_ID=? AND MATERIAL_NAME in ('DOUBLE BLADE' ,'BLADE 56.9M' ,'Blade','BLADE-T106','BLADE','BLADE-54M','BLADE INTERCARTING', "
										+" '64.2 Mtr Blade','BLADE-V110','BLADE 42.1M','BLADE-T2.3 116') "
										+" UNION ALL "
										+" SELECT COUNT(*) AS TOTAL , 'TOWER' AS MATERIAL_NAME FROM ASSET_TRIP_DETAILS atd "
										+" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=atd.VEHICLE_NO AND atd.SYSTEM_ID=gps.System_id and atd.CUSTOMER_ID=gps.CLIENTID "
										+" where TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft') "
										+" AND SYSTEM_ID=? and CUSTOMER_ID=? AND MATERIAL_NAME in('T1','T2','T3','T4','T5','T4 - 127','T2 - 127','Tower-1','Tower-2','TOWER-1','TOWER-2','TOWER-3', "
										+" 'Tower','T1 - T106','T2 - T106','T3 - T106','T4 - T106','TOWER-TOP','TOWER-MIDDLE','TOWER-BOTTOM','GAMESA T2','GAMESA T3','GAMESA T1','T1-T104','T2-T104','T3-T104','T4-T104', "
										+" 'Tower Middle B Section','T1 - INTERCARTING') "
										+" UNION ALL "
										+" SELECT COUNT(*) AS TOTAL , 'HUB' AS MATERIAL_NAME FROM ASSET_TRIP_DETAILS atd "
										+" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=atd.VEHICLE_NO AND atd.SYSTEM_ID=gps.System_id and atd.CUSTOMER_ID=gps.CLIENTID "
										+" where TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft') "
										+" AND SYSTEM_ID=? and CUSTOMER_ID=? AND MATERIAL_NAME in('HUB','SINGLE HUB','D HUB','DOUBLE HUB') "
										+" UNION ALL "
										+" SELECT COUNT(*) AS TOTAL,'NACELLE' AS MATERIAL_NAME FROM ASSET_TRIP_DETAILS atd "
										+" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=atd.VEHICLE_NO AND atd.SYSTEM_ID=gps.System_id and atd.CUSTOMER_ID=gps.CLIENTID "
										+" where TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft') "
										+" AND SYSTEM_ID=? and CUSTOMER_ID=? AND MATERIAL_NAME in('NACELLE','Nacelle','SINGLE NACELLE') "
										+" union all "
										+" SELECT COUNT(*) AS TOTAL,'TOTAL' AS MATERIAL_NAME  FROM ASSET_TRIP_DETAILS atd "
										+" inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=atd.VEHICLE_NO AND atd.SYSTEM_ID=gps.System_id and atd.CUSTOMER_ID=gps.CLIENTID "
										+" where TRIP_STATUS='OPEN' and STATUS IN('Fresh','Draft') "
										+" AND SYSTEM_ID=? and CUSTOMER_ID=? ";
	public static final String GET_VEHICLE_INFO_BY_SPEED="SELECT REGISTRATION_NO,CREW_NAME,SPEED, "
									+" HIGH_PRIORITY,TRIP_SHEET_TYPE,'id1' OrderKey  FROM gpsdata_history_latest gps "
									+" left outer join ASSET_TRIP_DETAILS atd on atd.VEHICLE_NO=gps.REGISTRATION_NO WHERE TRIP_SHEET_TYPE='Loaded' AND "
									+" TRIP_STATUS='OPEN' AND STATUS in ('Fresh','Draft') AND System_id=? AND CLIENTID=? AND SPEED>'40'"
									+"union all "
									+" SELECT REGISTRATION_NO,CREW_NAME,SPEED, "
									+" HIGH_PRIORITY,TRIP_SHEET_TYPE,'id2' OrderKey FROM gpsdata_history_latest gps "
									+" left outer join ASSET_TRIP_DETAILS atd on atd.VEHICLE_NO=gps.REGISTRATION_NO WHERE TRIP_SHEET_TYPE='Empty' AND "
									+" TRIP_STATUS='OPEN' AND STATUS in ('Fresh','Draft') AND System_id=? AND CLIENTID=? AND SPEED>'60' ORDER BY OrderKey DESC, SPEED DESC";
	
	public static final String GET_OPEN_TRIPS = "SELECT atd.ID,atd.VEHICLE_NO,atd.CREW_NAME,atd.HIGH_PRIORITY,atd.COUSTOMER_NAME,atd.MATERIAL_NAME " 
									+ "from ASSET_TRIP_DETAILS atd inner  join gpsdata_history_latest gps on atd.VEHICLE_NO=gps.REGISTRATION_NO "
									+" WHERE TRIP_STATUS='OPEN' AND STATUS in ('Fresh','Draft') AND SYSTEM_ID=? AND CUSTOMER_ID=? AND System_id=? AND CLIENTID=?";
	
	
	public static final String UPDATE_HIGH_PRIORITY_SETTINGS = "UPDATE ASSET_TRIP_DETAILS SET HIGH_PRIORITY='Y' WHERE ID IN(#) ";
	
	public static final String UPDATE_HIGH_PRIORITY_SETTINGS_OFF = "UPDATE ASSET_TRIP_DETAILS SET HIGH_PRIORITY='N' WHERE ID NOT IN(#)";

	public static final String REMOVE_HIGH_PRIORITY_SETTINGS = "UPDATE ASSET_TRIP_DETAILS SET HIGH_PRIORITY='N' WHERE TRIP_STATUS='OPEN' AND STATUS in ('Fresh','Draft')";

	public static final String GET_VEHICLE_LOCATION = " SELECT LATITUDE, LONGITUDE,LOCATION,SPEED, REGISTRATION_NO FROM gpsdata_history_latest where REGISTRATION_NO IN(#)";
	
	public static final String UPDATE_ACTUAL_TRIP_START_TIME= "UPDATE AMS.dbo.TRACK_TRIP_DETAILS SET ACTUAL_TRIP_START_TIME = DATEADD(MI,-?,?), UPDATED_BY=? ,UPDATED_DATETIME=GETUTCDATE() WHERE TRIP_ID = ?";
		
	public static final String UPDATE_MANUAL_TRIP_START_TO_SUB_TABLE= "UPDATE AMS.dbo.TRACK_TRIP_DETAILS_SUB SET MANUAL_TRIP_START='Y' WHERE TRIP_ID = ?";
	
	public static final String GET_HUB_DEPARTURES_FROM_HUB_REPORT = "SELECT ACTUAL_DEPARTURE,UNIT_NO,LOCATION,ACTUAL_ARRIVAL FROM (SELECT DATEADD(MI,?,ACTUAL_DEPARTURE) AS ACTUAL_DEPARTURE, " +
			" UNIT_NO,LOCATION,ACTUAL_ARRIVAL FROM AMS.dbo.HUB_REPORT WHERE SYSTEM_ID = ? AND HUB_ID = ? AND REGISTRATION_NO = ?  AND " +
			" ACTUAL_DEPARTURE BETWEEN DATEADD(day, -?, DATEADD(MI,-?,?)) AND DATEADD(MI,-?,?) UNION SELECT DATEADD(MI,?,ACTUAL_DEPARTURE) AS ACTUAL_DEPARTURE," +
			" UNIT_NO,LOCATION,ACTUAL_ARRIVAL FROM AMS.dbo.HUB_REPORT_HISTORY WHERE SYSTEM_ID = ? AND HUB_ID = ? AND REGISTRATION_NO = ?  " +
			" AND ACTUAL_DEPARTURE BETWEEN DATEADD(day, -?, DATEADD(MI,-?,?)) AND DATEADD(MI,-?,?)) A ORDER BY ACTUAL_DEPARTURE DESC ";
	
	public static final String GET_TRIPS_BETWEEN_DATES = "SELECT DATEADD(MI,?,ACTUAL_TRIP_START_TIME) AS ACTUAL_TRIP_START_TIME,TRIP_ID FROM AMS.dbo.TRACK_TRIP_DETAILS t WHERE SYSTEM_ID = ? AND CUSTOMER_ID = ? AND ASSET_NUMBER = ? AND ACTUAL_TRIP_START_TIME BETWEEN DATEADD(day, -?, DATEADD(MI,-?,?)) AND DATEADD(MI,-?,?) ORDER BY t.ACTUAL_TRIP_START_TIME DESC ";
	
	public static final String GET_DES_TRIP_ORDER_DETAILS_BY_TRIP_ID = "SELECT DES_TRIP_ID,SCAN_ID,ORDER_NO,DELIVERY_TICKET_NO,DELIVERY_NOTE_NO "
			+ ", TRIP_CUSTOMER_ID, DELIVERY_STATUS ,TRIP_CUSTOMER_NAME ,AUTO_CLOSED,TRIP_ID FROM AMS.dbo.TRIP_ORDER_DETAILS WHERE TRIP_ID=?";
	
	public static final String GET_GPS_LIVE_DATA = "SELECT ISNULL(LATITUDE,0.00) AS LATITUDE,ISNULL(LONGITUDE,0.00) AS LONGITUDE,REGISTRATION_NO AS REG_NO  FROM AMS.dbo.gpsdata_history_latest WHERE System_id = ? AND CLIENTID = ?";
	
	public static final String GET_HEAD_QUARTERS = "select * from LOCATION_ZONE z INNER JOIN TRIP_CONFIGURATION tc on z.OPERATION_ID =  tc.TRIP_START_CRITERIA_PARAM " +
												   " WHERE tc.SYSTEM_ID=?  and tc.CUSTOMER_ID=? ";
	
	public static final String UPDATE_DISTANCE_FLAG_MANUAL_TRIP_START_TO_SUB_TABLE= " UPDATE AMS.dbo.DES_TRIP_DETAILS SET DISTANCE_FLAG='Y' WHERE TRIP_ID = ? AND SEQUENCE = 0 ";

	public static final String GET_ROLE_TYPE = "SELECT ISNULL(ROLE_TYPE,0) AS ROLE_TYPE FROM ADMINISTRATOR.dbo.ROLE WHERE ROLE_ID = (SELECT ROLE_ID FROM AMS.dbo.Users WHERE User_id = ? AND System_id = ?)";
	
	public static final String GET_VEHICLES_BY_TRIP_BASED_REGION = "SELECT   ASSET_NUMBER FROM AMS.dbo.TRACK_TRIP_DETAILS ttd " +
			" INNER JOIN AMS.dbo.DES_TRIP_DETAILS des ON ttd.TRIP_ID = des.TRIP_ID AND des.SEQUENCE = 0 " +
			" WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND CUSTOMER_ID = ? AND des.TRIP_DESTINATION IN (##) ";
	
	public static final String GET_VEHICLE_FROM_ASSOCIATED_VEHICLE_GROUP = "SELECT Registration_no FROM Vehicle_User " +
			" INNER JOIN AMS.dbo.VEHICLE_CLIENT ON Registration_no=REGISTRATION_NUMBER " +
			" WHERE User_id=? AND System_id=? AND SYSTEM_ID=? AND CLIENT_ID=? ";
	
}


 