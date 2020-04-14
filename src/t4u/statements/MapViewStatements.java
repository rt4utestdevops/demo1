package t4u.statements;

public class MapViewStatements {

	public static final String GET_MAP_VIEW_DETAILS = "select isnull(td.ORDER_ID,'NA') as LR_NO,isnull(td.SHIPMENT_ID,'NA') as TRIP_NO,isnull(td.ROUTE_NAME,'NA') as ROUTE_NAME,isnull(td.CUSTOMER_NAME,'NA') as CUSTOMER_NAME," +
														" isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,"+	
														" isnull(td.DELAY,0) as DELAY,case when a.CATEGORY='stoppage' then DURATION else 0 end as STOPPAGE_TIME,case when a.CATEGORY='idle' then DURATION else 0 end as IDLE_TIME,"+
														" a.REGISTRATION_NO,isnull(b.VEHICLE_ID,'') as VEHICLE_ID,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isNull(a.CATEGORY,'') as CATEGORY,a.PREV_LAT,a.PREV_LONG,isnull(b.GROUP_NAME,'') as  GROUP_NAME,ag.GROUP_ID,b.IMAGE_NAME,isnull(c.Manufacturer,'') as Vehicle_Make,a.IGNITION,a.SPEED,ISNULL(a.SPEED_LIMIT,0) AS SPEED_LIMIT,isnull(a.DRIVER_NAME,'NA') as DRIVER_NAME "+
														"from dbo.gpsdata_history_latest (NOLOCK) a "+
														"inner join dbo.Live_Vision_Support (NOLOCK) b on a.REGISTRATION_NO=b.REGISTRATION_NO "+
														"left outer join AMS.dbo.VEHICLE_CLIENT vc on a.REGISTRATION_NO=vc.REGISTRATION_NUMBER "+
														"left outer join AMS.dbo.TRACK_TRIP_DETAILS td on a.REGISTRATION_NO=td.ASSET_NUMBER and td.STATUS = 'OPEN' "+
														"inner join AMS.dbo.tblVehicleMaster c on c.VehicleNo = a.REGISTRATION_NO "+
														"inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.GROUP_ID = vc.GROUP_ID and ag.CUSTOMER_ID=a.CLIENTID";
	public static final String GET_MAP_VIEW_DETAILS_FOR_IMPRECISE_LOCATION = "select isnull(td.ORDER_ID,'NA') as LR_NO,isnull(td.SHIPMENT_ID,'NA') as TRIP_NO,isnull(td.ROUTE_NAME,'NA') as ROUTE_NAME,isnull(td.CUSTOMER_NAME,'NA') as CUSTOMER_NAME," +
																			 " isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,"+	
																			 " isnull(td.DELAY,0) as DELAY,case when a.CATEGORY='stoppage' then DURATION else 0 end as STOPPAGE_TIME,case when a.CATEGORY='idle' then DURATION else 0 end as IDLE_TIME,"+
																			 " a.REGISTRATION_NO,isnull(b.VEHICLE_ID,'') as VEHICLE_ID,a.IM_LATITUDE as LATITUDE,a.IM_LONGITUDE as LONGITUDE ,a.IM_LOCATION as LOCATION ,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isNull(a.CATEGORY,'') as CATEGORY,a.PREV_LAT,a.PREV_LONG,isnull(b.GROUP_NAME,'') as  GROUP_NAME,ag.GROUP_ID,b.IMAGE_NAME,isnull(c.Manufacturer,'') as Vehicle_Make,a.IGNITION,a.SPEED,ISNULL(a.SPEED_LIMIT,0) AS SPEED_LIMIT ,isnull(a.DRIVER_NAME,'NA') as DRIVER_NAME  "+
																			 "from dbo.gpsdata_history_latest (NOLOCK) a "+
																			 "inner join dbo.Live_Vision_Support (NOLOCK) b on a.REGISTRATION_NO=b.REGISTRATION_NO "+
																			 "left outer join AMS.dbo.VEHICLE_CLIENT vc on a.REGISTRATION_NO=vc.REGISTRATION_NUMBER "+
																			 "left outer join AMS.dbo.TRACK_TRIP_DETAILS td on a.REGISTRATION_NO=td.ASSET_NUMBER and td.STATUS = 'OPEN' "+
																			 "inner join AMS.dbo.tblVehicleMaster c on c.VehicleNo = a.REGISTRATION_NO "+
																			 "inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.GROUP_ID = vc.GROUP_ID and ag.CUSTOMER_ID=a.CLIENTID";
														
	public static final String GET_MAP_VIEW_DETAILS_DMG = "select a.REGISTRATION_NO,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,e.Status"
		+ " from dbo.gpsdata_history_latest a "
		+" left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER "
		+ " left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
		+ " inner join  dbo.tblVehicleMaster e on e.VehicleNo=a.REGISTRATION_NO  "
		 +" where a.CLIENTID=? and a.System_id=? and a.LOCATION <>'No GPS Device Connected' order by a.REGISTRATION_NO";
	

	public static final String GET_MAP_VIEW_ASSET_DETAILS="select TOP 1  isnull(c.NAME,'') as NAME,isnull(dateadd(mi,?,a.ACTUAL_ARRIVAL),'') as ACTUAL_ARRIVAL,isnull(d.OwnerName,'') as OwnerName,isnull(d.OwnerContactNo,'') as OwnerContactNo,f.value+CAST(isnull(e.UID,'0') as varchar(5))as UniqueSandId " + 
														" from tblVehicleMaster d " + 
														" left outer join dbo.HUB_REPORT  a  on  a.REGISTRATION_NO=d.VehicleNo " +
														" left outer join LOCATION_ZONE_A c on  a.HUB_ID=c.HUBID and a.SYSTEM_ID=c.SYSTEMID " + 
														" left outer join ASSET_ENLISTING e on d.VehicleNo=e.ASSET_NUMBER and d.System_id=e.SYSTEM_ID " +
														" left outer join dbo.General_Settings f on f.name='ENLIST_CODE' and d.System_id=f.System_Id " + 
														" where  d.VehicleNo=? and d.System_id=? order by ACTUAL_ARRIVAL desc ";
																
	public static final String GET_CUSTOMER_LANDMARKS_NAMES="select NAME from AMS.dbo.LOCATION where CLIENTID= ? and SYSTEMID=? and RADIUS=0";
	public static final String GET_CUSTOMER_LANDMARKS_LAT_LONG="select NAME,LATITUDE,LONGITUDE,IMAGE from AMS.dbo.LOCATION where NAME=? and CLIENTID=? and SYSTEMID=? and RADIUS=0";
	
	
	public static final String GET_BUFFERS_FOR_MAP_VIEW = "select NAME,LONGITUDE,LATITUDE,RADIUS,IMAGE,isNull(HUBID,0) as HUBID from LOCATION where  RADIUS<> -1 and CLIENTID=? and SYSTEMID=? and OPERATION_ID<>2 ";

	public static final String GET_POLYGONS_FOR_MAP = "select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE from dbo.POLYGON_LOCATION_DETAILS a left outer join LOCATION_ZONE b on a.HUBID=b.HUBID where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and b.OPERATION_ID<>2 order by a.HUBID,a.SEQUENCE_ID";
	
	public static final String GET_SERVICE_STATION_FOR_MAP = "select isnull(a.NAME,'') as NAME,a.HUBID,isnull(b.SEQUENCE_ID,0) as SEQUENCE_ID ,isnull(b.LATITUDE,0) as LATITUDE ,isnull(b.LONGITUDE,0) as LONGITUDE, "+
															"isnull(a.LATITUDE,0) as LAT,isnull(a.LONGITUDE,0) as LONG,a.RADIUS from LOCATION_ZONE  a  "+
															"left outer join dbo.POLYGON_LOCATION_DETAILS b on a.HUBID=b.HUBID and a.SYSTEMID=b.SYSTEM_ID and a.CLIENTID=b.CUSTOMER_ID "+ 
															"where a.CLIENTID=? and a.SYSTEMID=? and a.OPERATION_ID=18 and " +
															"a.HUBID in (select HUB_ID from AMS.dbo.SERVICE_STATION_MAKE_ASSOC where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_MAKE=? and GROUP_ID=?) order by a.HUBID,b.SEQUENCE_ID ";
	
	public static final String GET_BORDERS_FOR_MAP = "select isnull(a.NAME,'') as NAME,a.HUBID,isnull(b.SEQUENCE_ID,0) as SEQUENCE_ID ,isnull(b.LATITUDE,0) as LATITUDE ,isnull(b.LONGITUDE,0) as LONGITUDE ,isnull(a.LATITUDE,0) as LAT,isnull(a.LONGITUDE,0) as LONG,a.RADIUS from LOCATION_ZONE  a "+
													 "left outer join dbo.POLYGON_LOCATION_DETAILS b on a.HUBID=b.HUBID  and a.SYSTEMID=b.SYSTEM_ID and a.CLIENTID=b.CUSTOMER_ID where a.CLIENTID=? and a.SYSTEMID=? and a.OPERATION_ID=2 order by a.HUBID,b.SEQUENCE_ID";

	public static final String GET_LIVE_VISION_VIEW_ASSET_DETAILS = "select isnull(ttd.TRIP_NO,'') as TRIP_NO,isnull(ttd.VALIDITY_DATE,'') as VALIDITY_DATE,g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
	"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME , "+
	"g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
	"isnull (b.CLIENT_NAME,'') as CLIENTNAME, "+
	"isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
	"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
	"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
	"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName, "+
	"isnull (sm.Status_desc,'') as STATUS, "+
	"isnull(vs.HubName,'') as HUBNAME,dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE,isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time "+
	" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
	" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
	" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
	" from dbo.gpsdata_history_latest g (nolock) "+
	" left outer join  dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO  "+
	" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO  "+
	" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
	" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
	" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
	" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id " +
	" left outer join AMS.dbo.MINING_ASSET_ENROLLMENT mae on mae.SYSTEM_ID=g.System_id and g.REGISTRATION_NO=mae.ASSET_NUMBER " +
	" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
	" left outer join MINING.dbo.TRUCK_TRIP_DETAILS (nolock) ttd on ttd.ASSET_NUMBER=g.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ttd.STATUS='OPEN' " ;
	
	public static final String GET_LIVE_VISION_VIEW_ASSET_DETAILS_FOR_IMPRECISE_LOCATION = "select isnull(ttd.TRIP_NO,'') as TRIP_NO,isnull(ttd.VALIDITY_DATE,'') as VALIDITY_DATE,g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.IM_LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
	"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME , "+
	"g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
	"isnull (b.CLIENT_NAME,'') as CLIENTNAME, "+
	"isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
	"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
	"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
	"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName, "+
	"isnull (sm.Status_desc,'') as STATUS, "+
	"isnull(vs.HubName,'') as HUBNAME,dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE,isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time  "+
	" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
	" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
	" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
	" from dbo.gpsdata_history_latest g (nolock) "+
	" left outer join  dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO  "+
	" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO  "+
	" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
	" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
	" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
	" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id " +
	" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
	" left outer join MINING.dbo.TRUCK_TRIP_DETAILS (nolock) ttd on ttd.ASSET_NUMBER=g.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ttd.STATUS='OPEN' " ;
	
	public static final String GET_CASH_VAN_MAP_VIEW_ASSET_DETAILS = "select isnull(td.ORDER_ID,'') as LR_NO,isnull(td.SHIPMENT_ID,'') as TRIP_NO,isnull(td.ROUTE_NAME,'') as ROUTE_NAME,isnull(td.CUSTOMER_NAME,'') as CUSTOMER_NAME," +
																	 " isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as ATD,"+
																	 " isnull(td.DELAY,0) as DELAY,case when g.CATEGORY='stoppage' then DURATION else 0 end as STOPPAGE_TIME,case when g.CATEGORY='idle' then DURATION else 0 end as IDLE_TIME,"+
																	 " g.REGISTRATION_NO as VehicleNo,isnull (g.LOCATION,'') as LOCATION,g.SPEED_LIMIT,g.GPS_DATETIME AS DATETIME,isnull (g.DRIVER_NAME, '')as DRIVER_NAME, "+
																	 "isnull ( b.GROUP_NAME,'') as GROUP_NAME,isnull (g.LOCATION,'') as LOCATION,g.IGNITION,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE,g.SPEED,isnull(g.ANALOG_INPUT_2,'10000') as Temperature, "+
																	 "isnull(a.VehicleType,'')as VEHICLE_TYPE,isnull(c.ModelName,'') as MODEL, "+
																	 "isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull(d.CASH_IN,'') as CASH_IN,isnull(d.CASH_OUT,'') as CASH_OUT,isnull(d.CASH_BALANCE,'') as CASH_BALANCE,  "+
																	 "isnull (sm.Status_desc,'') as STATUS, isnull(g.EASTWEST,'') as DIRECTION  "+
																	 "from  dbo.gpsdata_history_latest g  "+
																	 "inner join dbo.Live_Vision_Support b on g.REGISTRATION_NO=b.REGISTRATION_NO "+
																	 "inner join dbo.tblVehicleMaster a  on a.VehicleNo=g.REGISTRATION_NO "+
																	 "left outer join FMS.dbo.Vehicle_Model c on c.ModelTypeId=a.Model and c.SystemId=a.System_id "+
																	 "left outer join dbo.VEHICLE_CASH_INFO d on a.VehicleNo=d.REGISTRATION_NO and a.System_id=d.SYSTEM_ID "+
																	 "left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id "+
																	 "left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id "+
																	 "left outer join AMS.dbo.TRACK_TRIP_DETAILS td on g.REGISTRATION_NO=td.ASSET_NUMBER and td.STATUS = 'OPEN' "+ 
																	 "where a.VehicleNo=? and a.System_id=? order by g.GPS_DATETIME desc";
	
	
	public static final String GET_DMG_MAP_VIEW_ASSET_DETAILS = " select g.REGISTRATION_NO,b.VEHICLE_ID, g.SPEED_LIMIT,g.IGNITION,isnull (g.DRIVER_NAME, '')as DRIVER_NAME ,isnull (g.LOCATION,'') as LOCATION,g.GPS_DATETIME AS DATETIME, "+
	" g.SPEED,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (a.Status,'') as Status,isnull(a.VehicleType,'') as VehicleType,isnull(a.SUBSCRIPTION_VALIDITY,'') as SUBSCRIPTION_VALIDITY, isnull(a.REMINDER_DATE,'') as REMINDER_DATE" +
	" from dbo.tblVehicleMaster a " +
	" inner join dbo.Live_Vision_Support b on a.VehicleNo=b.REGISTRATION_NO " +
	" inner join dbo.gpsdata_history_latest g on a.VehicleNo=g.REGISTRATION_NO  " +
    " where g.REGISTRATION_NO=? and g.System_id=? and g.CLIENTID=? order by g.GPS_DATETIME desc";
	
	
	/*public static final String GET_DMG_TRIP_DETAILS="select  a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(a.START_TIME as varchar(20)), '') as START_TIME from dbo.TRIP_DETAILS a with (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=?" +
			" union all" +
			" select  a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(a.START_TIME as varchar(20)), '') as START_TIME from dbo.TRIP_DETAILS_HISTORY a with (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=?  order by a.INSERTED_TIME desc ";
	*/
	
	public static final String GET_DMG_TRIP_DETAILS=" select top 1 * from ( " +
			" select  a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(a.START_TIME as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS from dbo.TRIP_DETAILS a with (NOLOCK) " + 
			" where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? and TYPE is null " +
			" union all " +
			" select  a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(a.START_TIME as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS  " +
			" from dbo.TRIP_DETAILS_HISTORY a with (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? and TYPE is null) r " +
			" order by r.INSERTED_TIME desc  " ;

	public static final String GET_DMG_TRIP_DETAILS_FRESH	=" select top 1 * from (select  a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE,ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS from MINING.dbo.TRUCK_TRIP_DETAILS a with (NOLOCK) " + 
			" where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? and TYPE is not null " +
			" union all " +
			" select  a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE,ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS  " +
			" from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY a with (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? and TYPE is not null " +
			" union all " +
			" select  a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE,ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS " +
			" from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS a with (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? and TYPE is not null " +
			" union all " +
			" select  a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE,ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS " +
			" from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS_HISTORY a with (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? and TYPE is not null" +
			" union all " +
			" select  a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE,ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS " +
			" from MINING.dbo.BARGE_TRIP_DETAILS a with (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? and TYPE is not null " +
			" )r " +
			" order by r.INSERTED_TIME desc " ;

	public static final String GET_DMG_TRIP_DETAILS_FRESH1 = " select top 1 * from (  " +
			" select mpd.MINERAL,(QUANTITY-QUANTITY1)/1000 as NET_QTY,a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE,  " +
			" ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS from  MINING.dbo.TRUCK_TRIP_DETAILS  a  " +
			" left outer join MINING_PERMIT_DETAILS mpd on mpd.ID= a.PERMIT_ID  " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ASSET_NUMBER=?  " +
			//" and mpd.MINERAL='Iron Ore(E-Auction)'  " +
			" union all " +
			" select mpd.MINERAL,(QUANTITY-QUANTITY1)/1000 as NET_QTY,a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE,  " +
			" ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS from  MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY  a  " +
			" left outer join MINING_PERMIT_DETAILS mpd on mpd.ID= a.PERMIT_ID  " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ASSET_NUMBER=?  " +
			//" and mpd.MINERAL='Iron Ore(E-Auction)'  " +
			" union all  " +
			" select mpd.MINERAL,(QUANTITY-QUANTITY1)/1000 as NET_QTY,a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE,  " +
			" ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS from  MINING.dbo.BARGE_TRUCK_TRIP_DETAILS  a  " +
			" left outer join MINING_PERMIT_DETAILS mpd on mpd.ID= a.PERMIT_ID  " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ASSET_NUMBER=?  " +
			//" and mpd.MINERAL='Iron Ore(E-Auction)'  " +
			" union all  " +
			" select mpd.MINERAL,(QUANTITY-QUANTITY1)/1000 as NET_QTY,a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE,  " +
			" ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS from  MINING.dbo.BARGE_TRUCK_TRIP_DETAILS_HISTORY  a  " +
			" left outer join MINING_PERMIT_DETAILS mpd on mpd.ID= a.PERMIT_ID  " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ASSET_NUMBER=?  " +
			//" and mpd.MINERAL='Iron Ore(E-Auction)'  " +
			" union all " +
			" select 'Iron Ore' as MINERAL,(QUANTITY1)/1000 as NET_QTY,a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE, " +
			" ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS from  MINING.dbo.BARGE_TRIP_DETAILS  a " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ASSET_NUMBER=? " +
			" )r   " +
			" order by r.INSERTED_TIME desc  " ;
	
	public static final String GET_IRON_MINING_MAP_VIEW_DETAILS = "select a.REGISTRATION_NO,datediff(mi,getutcdate(),a.GMT) as COMM_STATUS,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION "
		+ " from dbo.gpsdata_history_latest a "
		+ " left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
		+ " left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
		+ " inner join  dbo.Vehicle_User d on a.REGISTRATION_NO=d.Registration_no and a.System_id=d.System_id "
		+ " inner join tblVehicleMaster e on  e.VehicleNo=a.REGISTRATION_NO  "
		+ " where d.User_id=? and a.CLIENTID=? and a.System_id=? and e.VehicleType=? and a.LOCATION <> 'No GPS Device Connected' order by a.REGISTRATION_NO";

public static final String GET_IRON_MINING_MAP_VIEW_COMM_DETAILS = "select a.REGISTRATION_NO,datediff(mi,getutcdate(),a.GMT) as COMM_STATUS,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION "
		+ " from dbo.gpsdata_history_latest a "
		+ " left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
		+ " left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
		+ " inner join  dbo.Vehicle_User d on a.REGISTRATION_NO=d.Registration_no and a.System_id=d.System_id "
		+ " inner join tblVehicleMaster e on  e.VehicleNo=a.REGISTRATION_NO  "
		+ " where a.GMT > dateadd(mi,-15,getUTCDate()) and LOCATION !='No GPS Device Connected' and d.User_id=? and a.CLIENTID=? and a.System_id=? and e.VehicleType=? order by a.REGISTRATION_NO";

public static final String GET_IRON_MINING_MAP_VIEW_NON_COMM_DETAILS = "select a.REGISTRATION_NO,datediff(mi,getutcdate(),a.GMT) as COMM_STATUS,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION "
		+ " from dbo.gpsdata_history_latest a "
		+ " left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
		+ " left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
		+ " inner join  dbo.Vehicle_User d on a.REGISTRATION_NO=d.Registration_no and a.System_id=d.System_id "
		+ " inner join tblVehicleMaster e on  e.VehicleNo=a.REGISTRATION_NO  "
		+ " where  a.GMT <= dateadd(mi,-15,getUTCDate()) and LOCATION !='No GPS Device Connected' and d.User_id=? and a.CLIENTID=? and a.System_id=? and e.VehicleType=? order by a.REGISTRATION_NO";

public static final String GET_IRON_MINING_MAP_VIEW_NO_GPS_DETAILS = "select a.REGISTRATION_NO,datediff(mi,getutcdate(),a.GMT) as COMM_STATUS,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION "
		+ " from dbo.gpsdata_history_latest a "
		+ " left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
		+ " left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
		+ " inner join  dbo.Vehicle_User d on a.REGISTRATION_NO=d.Registration_no and a.System_id=d.System_id "
		+ " inner join tblVehicleMaster e on  e.VehicleNo=a.REGISTRATION_NO  "
		+ " where  LOCATION ='No GPS Device Connected' and d.User_id=? and a.CLIENTID=? and a.System_id=? and e.VehicleType=? order by a.REGISTRATION_NO";

public static final String GET_IRON_MINING_ASSET_DETAILS="select isnull(c.STATUS,'') as TRIP_STATUS,isnull(a.VehicleAlias,'') as VEHICLE_ID,isnull(a.OwnerName,'') as OWNER_NAME,isnull(b.STATUS,'') as STATUS,isnull(c.TRIP_NO,'') as TRIP_NO,ISNULL(cast(START_TIME as varchar(20)), '') as START_TIME from dbo.tblVehicleMaster a "+
														 "inner join dbo.Live_Vision_Support b on a.VehicleNo=b.REGISTRATION_NO  "+
														 "left outer join dbo.TRIP_DETAILS c on c.ASSET_NUMBER=a.VehicleNo and a.System_id=c.SYSTEM_ID  and c.STATUS in ('In Transit','In Transit-Time Extension') "+
														 "where a.VehicleNo=? and a.System_id=?  order by c.START_TIME desc";


public static final String GET_MAIN_POWER_ON_OFF="select top 1 isnull(HUB_ID,0) as HUB_ID,LOCATION,GMT,dateadd(mi,?,GMT) as LOCALTIME from dbo.Alert where REGISTRATION_NO=? and TYPE_OF_ALERT=7 and CLIENTID=? and SYSTEM_ID=? and GMT>dateadd(hh,-48,getutcdate())  order by  GMT desc";

public static final String GET_VOLTAGE_DETAILS="select isnull(a.MAIN_BATTERY_VOLTAGE,0)as MAIN_BATTERY_VOLTAGE,a.LOCATION,a.VALID,a.INVALID_UPDATETIME,isnull(tbVM.BatteryVoltage,'') as BATTERY_VOLTAGE,dateadd(mi,?,GMT) as LOCALTIME,GMT,datediff(mi,GMT,getutcdate()) as NONCOMM_HOURS,isnull(cast (SATELLITE as varchar(10)),'NA') as SATELLITE from gpsdata_history_latest a "+
											   "INNER JOIN tblVehicleMaster tbVM ON a.REGISTRATION_NO=tbVM.VehicleNo "+
											   "where a.REGISTRATION_NO=? and a.System_id=? and a.CLIENTID=?";

public static final String GET_HISTORY_DATA="  select LOCATION,GMT,dateadd(mi,?,GMT) as LOCALTIME,SPEED,PACKET_TYPE,COMMAND_ID,SATELLITE from dbo.HISTORY_DATA where REGISTRATION_NO=? and GMT between  dateadd(hh,-6,?)  and ?" +
											 " union "+ 
											 " select LOCATION,GMT,dateadd(mi,?,GMT) as LOCALTIME,SPEED,PACKET_TYPE,COMMAND_ID,SATELLITE from AMS_Archieve.dbo.GE_DATA where REGISTRATION_NO=? and GMT between  dateadd(hh,-6,?)  and ? order by GMT desc";

//public static final String GET_GE_DATA_FROM_MYSQL = "select LOCATION,GMT,date_add(GMT,interval ? minute) as LOCAL_TIME,SPEED,PACKET_TYPE,COMMAND_ID,"+
//													" SATELLITE from ams_archieve.ge_data where REGISTRATION_NO=? " +
//													" and GMT between  date_add(?,interval -6 hour)   " +
//													" and ? order by GMT desc ";

public static final String GET_VEHICLE_FOR_MLL_ECOMMERCE = "select a.REGISTRATION_NO,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED "+
												"from dbo.gpsdata_history_latest a "+
												"left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "+
												"left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.System_id=c.SYSTEM_ID "+
												"where a.REGISTRATION_NO in (vehicleNo) order by a.REGISTRATION_NO ";


public static final String GET_TAXI_MAP_VIEW_DETAILS ="select a.REGISTRATION_NO,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED,isnull(e.IONO,'NA') as [IO],isnull(a.IO3,0) as IO3,isnull(a.IO4,0) as IO4,isnull(a.IO5,0) as IO5,isnull(a.IO6,0) as IO6,isnull(a.IO7,0) as IO7,e.ALERTID ,CASE WHEN DATEDIFF(mi,GMT,getutcdate()) >= 15 and LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END as FLAG,e.ALERTID"+
	" from dbo.gpsdata_history_latest a "+
	"inner join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "+
	"inner join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "+
//	"inner join  dbo.Vehicle_User d on a.REGISTRATION_NO=d.Registration_no and a.System_id=d.System_id "+
	"left outer join dbo.VEHICLEIOASSOCIATION e on a.REGISTRATION_NO=e.VEHICLEID and a.System_id=e.SYSTEMID and e.ALERTID!=128 "+
	"where a.CLIENTID=? and a.System_id=?  ";

public static final String GET_ALL_TAXI_MAP_VIEW_DETAILS = "select a.REGISTRATION_NO,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED,isnull(e.IONO,'NA') as [IO],isnull(a.IO3,0) as IO3,isnull(a.IO4,0) as IO4,isnull(a.IO5,0) as IO5,isnull(a.IO6,0) as IO6,isnull(a.IO7,0) as IO7,e.ALERTID ,CASE WHEN DATEDIFF(mi,GMT,getutcdate()) >= 15 and LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END as FLAG"+
" from dbo.gpsdata_history_latest a "+
"left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "+
"left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "+
"left outer join dbo.VEHICLEIOASSOCIATION e on a.REGISTRATION_NO=e.VEHICLEID and a.System_id=e.SYSTEMID  and e.ALERTID!=128  "+
"where  a.CLIENTID=? and a.System_id=?";

public static final String GET_TAXI_MAP_VIEW_COMM_DETAILS ="select FLAG=0,a.REGISTRATION_NO,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED,isnull(e.IONO,'NA') as [IO],isnull(a.IO3,0) as IO3,isnull(a.IO4,0) as IO4,isnull(a.IO5,0) as IO5,isnull(a.IO6,0) as IO6,isnull(a.IO7,0) as IO7 ,e.ALERTID"
	+ " from dbo.gpsdata_history_latest a "
	+ " inner join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
	+ " inner join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
//	+ " inner join  dbo.Vehicle_User d on a.REGISTRATION_NO=d.Registration_no and a.System_id=d.System_id "
	+ " left outer join dbo.VEHICLEIOASSOCIATION e on a.REGISTRATION_NO=e.VEHICLEID and a.System_id=e.SYSTEMID and e.ALERTID!=128 "
	+ " where  DATEDIFF(mi,GMT,getutcdate()) < 15 and LOCATION !='No GPS Device Connected' and a.CLIENTID=? and a.System_id=? ";

public static final String GET_ALL_TAXI_MAP_VIEW_COMM_DETAILS ="select a.REGISTRATION_NO,FLAG=0,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED,isnull(e.IONO,'NA') as [IO],isnull(a.IO3,0) as IO3,isnull(a.IO4,0) as IO4,isnull(a.IO5,0) as IO5,isnull(a.IO6,0) as IO6,isnull(a.IO7,0) as IO7,e.ALERTID "
	+ " from dbo.gpsdata_history_latest a "
	+ " left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
	+ " left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
	+ " left outer join dbo.VEHICLEIOASSOCIATION e on a.REGISTRATION_NO=e.VEHICLEID and a.System_id=e.SYSTEMID and e.ALERTID!=128 "
	+ " where  DATEDIFF(mi,GMT,getutcdate()) < 15 and LOCATION !='No GPS Device Connected'  and a.CLIENTID=? and a.System_id=?  ";

public static final String GET_ALL_TAXI_MAP_VIEW_DRIVER_LOG_VEHICLES ="select a.REGISTRATION_NO,FLAG=0,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED,isnull(e.IONO,'NA') as [IO],isnull(a.IO3,0) as IO3,isnull(a.IO4,0) as IO4,isnull(a.IO5,0) as IO5,isnull(a.IO6,0) as IO6,isnull(a.IO7,0) as IO7,e.ALERTID "
	+ " from dbo.gpsdata_history_latest a "
	+ " left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
	+ " left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
	+ " left outer join dbo.VEHICLEIOASSOCIATION e on a.REGISTRATION_NO=e.VEHICLEID and a.System_id=e.SYSTEMID  "
	+ " where  DATEDIFF(mi,GMT,getutcdate()) < 15 and LOCATION !='No GPS Device Connected'  and a.CLIENTID=? and a.System_id=? and ALERTID=128";


public static final String GET_TAXI_MAP_VIEW_DRIVER_LOG_VEHICLES ="select a.REGISTRATION_NO,FLAG=0,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED,isnull(e.IONO,'NA') as [IO],isnull(a.IO3,0) as IO3,isnull(a.IO4,0) as IO4,isnull(a.IO5,0) as IO5,isnull(a.IO6,0) as IO6,isnull(a.IO7,0) as IO7,e.ALERTID "
	+ " from dbo.gpsdata_history_latest a "
	+ " left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
	+ " left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
	+ " inner join  dbo.Vehicle_User d on a.REGISTRATION_NO=d.Registration_no and a.System_id=d.System_id "
	+ " left outer join dbo.VEHICLEIOASSOCIATION e on a.REGISTRATION_NO=e.VEHICLEID and a.System_id=e.SYSTEMID  "
	+ " where  DATEDIFF(mi,GMT,getutcdate()) < 15 and LOCATION !='No GPS Device Connected' and d.User_id=?  and a.CLIENTID=? and a.System_id=? and ALERTID=128";

public static final String GET_TAXI_MAP_VIEW_NON_COMM_DETAILS = "select FLAG=1,a.REGISTRATION_NO,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED,isnull(a.IO3,0) as IO3,isnull(a.IO4,0) as IO4,isnull(a.IO5,0) as IO5,isnull(a.IO6,0) as IO6,isnull(a.IO7,0) as IO7"
	+ " from dbo.gpsdata_history_latest a "
	+ " inner join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
	+ " inner join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
//	+ " inner join  dbo.Vehicle_User d on a.REGISTRATION_NO=d.Registration_no and a.System_id=d.System_id "
	//+ " left outer join dbo.VEHICLEIOASSOCIATION e on a.REGISTRATION_NO=e.VEHICLEID and a.System_id=e.SYSTEMID  "
	+ " where  DATEDIFF(mi,GMT,getutcdate()) >= 15 and LOCATION !='No GPS Device Connected' and a.CLIENTID=? and a.System_id=?";

public static final String GET_ALL_TAXI_MAP_VIEW_NON_COMM_DETAILS = "select a.REGISTRATION_NO,FLAG=1,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED,isnull(a.IO3,0) as IO3,isnull(a.IO4,0) as IO4,isnull(a.IO5,0) as IO5,isnull(a.IO6,0) as IO6,isnull(a.IO7,0) as IO7 "
	+ " from dbo.gpsdata_history_latest a "
	+ " left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
	+ " left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
//	+ " left outer join dbo.VEHICLEIOASSOCIATION e on a.REGISTRATION_NO=e.VEHICLEID and a.System_id=e.SYSTEMID  "
	+ " where  DATEDIFF(mi,GMT,getutcdate()) >= 15 and LOCATION !='No GPS Device Connected'  and a.CLIENTID=? and a.System_id=?";

public static final String GET_TAXI_MAP_VIEW_NO_GPS_DETAILS = "select FLAG=0,a.REGISTRATION_NO,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED,isnull(a.IO3,0) as IO3,isnull(a.IO4,0) as IO4,isnull(a.IO5,0) as IO5,isnull(a.IO6,0) as IO6,isnull(a.IO7,0) as IO7 "
	+ " from dbo.gpsdata_history_latest a "
	+ " inner join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
	+ " inner join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
//	+ " inner join  dbo.Vehicle_User d on a.REGISTRATION_NO=d.Registration_no and a.System_id=d.System_id "
	//+ " left outer join dbo.VEHICLEIOASSOCIATION e on a.REGISTRATION_NO=e.VEHICLEID and a.System_id=e.SYSTEMID  "
	+ " where  LOCATION ='No GPS Device Connected' and a.CLIENTID=? and a.System_id=?";

public static final String GET_ALL_TAXI_MAP_VIEW_NO_GPS_DETAILS = "select a.REGISTRATION_NO,FLAG=0,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.DRIVER_NAME,c.GROUP_NAME,a.CATEGORY,a.IGNITION,a.SPEED,isnull(a.IO3,0) as IO3,isnull(a.IO4,0) as IO4,isnull(a.IO5,0) as IO5,isnull(a.IO6,0) as IO6,isnull(a.IO7,0) as IO7 "
	+ " from dbo.gpsdata_history_latest a "
	+ " left outer join dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO=b.REGISTRATION_NUMBER  "
	+ " left outer join dbo.VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID and a.CLIENTID=c.CLIENT_ID and a.System_id=c.SYSTEM_ID "
	//+ " left outer join dbo.VEHICLEIOASSOCIATION e on a.REGISTRATION_NO=e.VEHICLEID and a.System_id=e.SYSTEMID  "
	+ " where  LOCATION ='No GPS Device Connected'  and a.CLIENTID=? and a.System_id=?";

public static final String UPDATE_REMARKS="update dbo.Live_Vision_Support set NOTES=? where REGISTRATION_NO=? AND SYSTEM_ID=? ";


public static final String GET_CONSIGNMENT_DETAILS=" select cd.VehicleNumber as VehicleNo,cd.System_Id as System_Id,cd.Client_Id as Client_Id, "+
												   " cd.ConsignmentNumber as ConsignmentNo,isnull(cd.ConsignmentStatus,'') as Status, "+
												   " isnull(cd.ScheduledShippingDate,'') as Scheduled_Shipping_Date,isnull(cd.ScheduledDelivery,'') as Scheduled_Delivery_Date,isnull(cdd.REVISED_DELIVERY_DATE,'') as Revised_Delivery_Date, "+
												   " isnull(cdd.TOATL_DISTANCE,0) as Total_Distance, isnull(cdd.TRAVELLED_DISTANCE,0) as Travelled_Distance from AMS.dbo.Consignment_Booking_Details cd "+ 
												   " left outer join AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS cdd on cdd.SYSTEM_ID=cd.System_Id and cdd.CUSTOMER_ID=cd.Client_Id and cdd.CONSIGNMENT_NO=cd.ConsignmentNumber "+
												   " where upper(cd.ConsignmentNumber)=? and cd.Status='Processing' and cd.Deleted='N' and cd.System_Id=? and cd.ConsignmentStatus!='Empty' ";

public static final String GET_OTHER_DETAILS_FROM_gpsdata_history_latest=" select isnull(LOCATION,'') as LOCATION,isnull(LATITUDE,0) as LATITUDE,isnull(LONGITUDE,0) as LONGITUDE, "
								+ " isnull(CATEGORY,'') as CATEGORY,GPS_DATETIME,isnull(IGNITION,'') as IGNITION,isnull(SPEED,'') as SPEED "
								+ " from AMS.dbo.gpsdata_history_latest where System_id=? and CLIENTID=? and REGISTRATION_NO=? ";

/************************************************CONSIGNMENT DASHBOARD*********************************************************************************************************************************/



public static final String GET_DETAILS_FROM_CONSIGNMENT_DASHBOARD_DEATILS_For_CheckBox=" select isnull(a.ASSET_NO,'') as VehicleNo,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as LOCATION,isnull(a.SPEED,0) as SPEED,isnull(a.LATITUDE,0) as LATITUDE,isnull(a.LONGITUDE,0) as LONGITUDE, "
	+ " isnull(a.DATETIME,'') as DateTime,isnull(a.CONSIGNMENT_STATUS,'') as ConsignmentStatus  from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
	+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
	+ " where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Processing' and REGION=? and CONSIGNMENT_STATUS=? and vu.User_id=? ";

public static final String GET_DETAILS_FROM_CONSIGNMENT_DASHBOARD_DEATILS_For_View=" select isnull(a.ASSET_NO,'') as VehicleNo,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as LOCATION,isnull(a.SPEED,0) as SPEED,isnull(a.LATITUDE,0) as LATITUDE,isnull(a.LONGITUDE,0) as LONGITUDE , "
	+ " isnull(a.DATETIME,'') as DateTime,isnull(a.CONSIGNMENT_STATUS,'') as ConsignmentStatus from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
	+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id " 
	+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='Processing' and REGION=? and vu.User_id=? ";

public static final String GET_CONSIGNMENT_SUMMARY_DETAILS=" select isnull(a.ASSET_NO,'') as VehicleNo,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as CurrentLocation,isnull(a.DATETIME,'') as dateTime, "
	+ " isnull(a.CONSIGNMENT_NO,'') as ConsignmentNumber,isnull(a.CONSIGNMENT_STATUS,'') as Status,isnull(a.SPEED,0) as Speed, "
	+ " isnull(a.REVISED_DELIVERY_DATE,'') as revisedDeliveryDate ,isnull(a.SCHEDULED_DELIVERY,'') as scheduledDeliverydate,isnull(TOATL_DISTANCE,0) as totalDistance,isnull(TRAVELLED_DISTANCE,0) as distancetravelled,isnull(bc.BOOKING_CUSTOMER_NAME,'') as BookingName "
	+ " from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
	+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
	+ " inner join AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER bc on bc.ID=a.BOOKING_CUSTOMER_ID and bc.SYSTEM_ID=a.SYSTEM_ID and bc.CUSTOMER_ID=a.CUSTOMER_ID "
	+ " where a.SYSTEM_ID=? and a.CONSIGNMENT_STATUS=? and a.STATUS = 'Processing' and a.CONSIGNMENT_NO!='' and vu.User_id=? and a.REGION !='' ";

public static final String GET_DETAILS_FROM_CONSIGNMENT_DASHBOARD_DEATILS_For_View_FOR_ALL=" select isnull(a.ASSET_NO,'') as VehicleNo,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as LOCATION,isnull(a.SPEED,0) as SPEED,isnull(a.LATITUDE,0) as LATITUDE,isnull(a.LONGITUDE,0) as LONGITUDE, "
	+ " isnull(a.DATETIME,'') as DateTime,isnull(a.CONSIGNMENT_STATUS,'') as ConsignmentStatus from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
	+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
	//+ " inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION ua on a.SYSTEM_ID=ua.SYSTEM_ID and vu.User_id=ua.USER_ID "
	+ " where a.SYSTEM_ID=? and a.STATUS='Processing' and vu.User_id=? ";


public static final String GET_DETAILS_FOR_REGION_ALL_AND_FOR_CHECKBOX=" select isnull(a.ASSET_NO,'') as VehicleNo,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as LOCATION,isnull(a.SPEED,0) as SPEED,isnull(a.LATITUDE,0) as LATITUDE,isnull(a.LONGITUDE,0) as LONGITUDE, "
	+ " isnull(a.DATETIME,'') as DateTime,isnull(a.CONSIGNMENT_STATUS,'') as ConsignmentStatus from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
	+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
	//+ " inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION ua on a.SYSTEM_ID=ua.SYSTEM_ID and vu.User_id=ua.USER_ID"
	+ " where a.SYSTEM_ID=? and a.STATUS='Processing' and CONSIGNMENT_STATUS=? and vu.User_id=? ";

public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE=" select isnull(ASSET_COUNT,0) as vehicles,isnull(ON_TIME_COUNT,0) as onTime,isnull(DELAY_COUNT,0) as delay, "
	+ " isnull(ALERTS_COUNT,0) as alerts,isnull(CONSIGNMENT_STATUS,'') as consignmentStatus,isnull(REGION,'') as region "
	+ " from AMS.dbo.CONSIGNMENT_DASHBOARD_SUMMARY where SYSTEM_ID=? and REGION=? and REGION!='' and CONSIGNMENT_STATUS!='Waiting For Load'";

public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE_FOR_ALL=" select isnull(ASSET_COUNT,0) as vehicles,isnull(ON_TIME_COUNT,0) as onTime,isnull(DELAY_COUNT,0) as delay, "
	+ " isnull(ALERTS_COUNT,0) as alerts,isnull(CONSIGNMENT_STATUS,'') as consignmentStatus,isnull(REGION,'') as region "
	+ " from AMS.dbo.CONSIGNMENT_DASHBOARD_SUMMARY where SYSTEM_ID=? and REGION!='' ";

public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_COUNT=" select sum(VehiclesCount) as TotalVehiclesCount,sum(OnTimeCount) as TotalOnTime,sum(DelayCount) as TotalDelay,sum(AlertsCount) as TotalAlerts,isnull(Region,'') as region,isnull(ConsignmentStatus,'') as consignmentStatus "
	+ " from AMS.dbo.CONSIGNMENT_DASHBOARD_SUMMARY where SYSTEM_ID=? "
	+ " and CUSTOMER_ID=? ";

public static final String GET_FINAL_TOTAL_FOR_ALL=" select sum(VehiclesCount) as vehicles,sum(OnTimeCount) as onTime, "
	+ " sum(DelayCount) as delay,sum(AlertsCount) as alerts "
	+ " from AMS.dbo.CONSIGNMENT_DASHBOARD_SUMMARY where SYSTEM_ID=? "
	+ " and CUSTOMER_ID=? and consignmentStatus !='Waiting For Load' ";

public static final String GET_REGION_TOTAL=" select sum(VehiclesCount) as vehicles,sum(OnTimeCount) as onTime, "
	+ " sum(DelayCount) as delay,sum(AlertsCount) as alerts "
	+ " from AMS.dbo.CONSIGNMENT_DASHBOARD_SUMMARY where SYSTEM_ID=? "
	+ " and CUSTOMER_ID=? and Region=? and  consignmentStatus !='Waiting For Load' ";

public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ONTIME=" select isnull(a.ASSET_NO,'') as VehicleNo,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as CurrentLocation,isnull(a.DATETIME,'') as dateTime, "
	+ " isnull(a.CONSIGNMENT_NO,'') as ConsignmentNumber,isnull(a.CONSIGNMENT_STATUS,'') as Status,isnull(a.SPEED,0) as Speed, "
	+ " isnull(a.REVISED_DELIVERY_DATE,'') as revisedDeliveryDate ,isnull(a.SCHEDULED_DELIVERY,'') as scheduledDeliverydate,isnull(TOATL_DISTANCE,0) as totalDistance,isnull(TRAVELLED_DISTANCE,0) as distancetravelled,isnull(bc.BOOKING_CUSTOMER_NAME,'') as BookingName "
	+ " from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
	+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
	+ " inner join AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER bc on bc.ID=a.BOOKING_CUSTOMER_ID and bc.SYSTEM_ID=a.SYSTEM_ID and bc.CUSTOMER_ID=a.CUSTOMER_ID "
	+ " where a.SYSTEM_ID=? and a.CONSIGNMENT_STATUS=? and a.STATUS = 'Processing' and a.CONSIGNMENT_NO!='' and a.REGION !='' and a.REGION is not null and a.REVISED_DELIVERY_DATE <= a.SCHEDULED_DELIVERY and vu.User_id=?";


public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DELAY=" select isnull(a.ASSET_NO,'') as VehicleNo,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as CurrentLocation,isnull(a.DATETIME,'') as dateTime, "
	+ " isnull(a.CONSIGNMENT_NO,'') as ConsignmentNumber,isnull(a.CONSIGNMENT_STATUS,'') as Status,isnull(a.SPEED,0) as Speed, "
	+ " isnull(a.REVISED_DELIVERY_DATE,'') as revisedDeliveryDate ,isnull(a.SCHEDULED_DELIVERY,'') as scheduledDeliverydate,isnull(TOATL_DISTANCE,0) as totalDistance,isnull(TRAVELLED_DISTANCE,0) as distancetravelled,isnull(bc.BOOKING_CUSTOMER_NAME,'') as BookingName "
	+ " from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
	+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
	+ " inner join AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER bc on bc.ID=a.BOOKING_CUSTOMER_ID and bc.SYSTEM_ID=a.SYSTEM_ID and bc.CUSTOMER_ID=a.CUSTOMER_ID "
	+ " where a.SYSTEM_ID=? and a.CONSIGNMENT_STATUS=? and a.STATUS = 'Processing' and a.CONSIGNMENT_NO!='' and a.REGION !='' and a.REGION is not null and a.REVISED_DELIVERY_DATE > a.SCHEDULED_DELIVERY and vu.User_id=?";

public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ALERTS=" select isnull(a.ASSET_NO,'') as VehicleNo,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as CurrentLocation,isnull(a.DATETIME,'') as dateTime," 
	+ " isnull(a.CONSIGNMENT_NO,'') as ConsignmentNumber,isnull(a.CONSIGNMENT_STATUS,'') as Status,isnull(a.SPEED,0) as Speed, "
	+ " isnull(a.REVISED_DELIVERY_DATE,'') as revisedDeliveryDate ,isnull(a.SCHEDULED_DELIVERY,'') as scheduledDeliverydate,isnull(TOATL_DISTANCE,0) as totalDistance,isnull(TRAVELLED_DISTANCE,0) as distancetravelled,isnull(bc.BOOKING_CUSTOMER_NAME,'') as BookingName "
	+ " from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
	+ " inner join AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER bc on bc.ID=a.BOOKING_CUSTOMER_ID and bc.SYSTEM_ID=a.SYSTEM_ID and bc.CUSTOMER_ID=a.CUSTOMER_ID "
	+ " where a.SYSTEM_ID=? and a.CONSIGNMENT_STATUS=? and a.STATUS ='Processing' and a.CONSIGNMENT_NO!='' and a.REGION !='' and a.REGION is not null and vu.User_id=? and a.ALERT_COUNT !=0 and a.ALERT_COUNT is not null";

public static final String GET_COUNT_OF_VEHICLES=
	" select isnull(c.Region,'') as Region,isnull(count(c.DealerName),0) as VehiclesCount from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
	+ " inner join AMS.dbo.Consignment_Details b on b.System_Id=a.SYSTEM_ID and b.Client_Id=a.CUSTOMER_ID and b.VehicleNo COLLATE DATABASE_DEFAULT=a.ASSET_NO and b.ConsignmentNo COLLATE DATABASE_DEFAULT=a.CONSIGNMENT_NO and b.ConsignmentStatus=a.CONSIGNMENT_STATUS "
	+ " inner join AMS.dbo.Consignment_Dealer_Master c on b.System_Id=c.SystemId and b.Client_Id=c.ClientId and b.DealerId=c.Slno "
	+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
	//+ " inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION ua on a.SYSTEM_ID=ua.SYSTEM_ID and vu.User_id=ua.USER_ID "
	+ " where a.SYSTEM_ID=? and a.STATUS = 'Processing' and vu.User_id=? and c.Region is not null and c.Region=? ";

public static final String GET_COUNT_OF_VEHICLES_FOR_REGION_ALL=
" select isnull(c.Region,'') as Region,isnull(count(c.DealerName),0) as VehiclesCount from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
+ " inner join AMS.dbo.Consignment_Details b on b.System_Id=a.SYSTEM_ID and b.Client_Id=a.CUSTOMER_ID and b.VehicleNo COLLATE DATABASE_DEFAULT=a.ASSET_NO and b.ConsignmentNo COLLATE DATABASE_DEFAULT=a.CONSIGNMENT_NO and b.ConsignmentStatus=a.CONSIGNMENT_STATUS "
+ " inner join AMS.dbo.Consignment_Dealer_Master c on b.System_Id=c.SystemId and b.Client_Id=c.ClientId and b.DealerId=c.Slno "
+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
//+ " inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION ua on a.SYSTEM_ID=ua.SYSTEM_ID and  vu.User_id=ua.USER_ID "
+ " where a.SYSTEM_ID=? and a.STATUS = 'Processing' and vu.User_id=? and c.Region is not null and c.Region=?";


public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_DELAY2=" select isnull(b.DealerName,'') as DealerName,isnull(cm.NAME,'') as CustomerName, " 
	+ " isnull(bb.Address,'') as Address,isnull(bb.City,'') as City,isnull(bb.State,'') as State "
	+ " from AMS.dbo.Consignment_Details c "
	+ " inner join AMS.dbo.Consignment_Dealer_Master b on b.SystemId=c.System_Id and b.ClientId=c.Client_Id and c.DealerId=b.Slno "  
	+ " inner join AMS.dbo.Consignment_Booking_Details bd on bd.System_Id=c.System_Id and bd.Client_Id=c.Client_Id and c.ConsignmentNo=bd.ConsignmentNumber and c.ConsignmentStatus=bd.ConsignmentStatus "
	+ " left outer join AMS.dbo.Consignment_Dealer_Master bb on bb.SystemId=bd.System_Id and bb.ClientId=bd.Client_Id and bd.To_DealerId=bb.Slno " 
	+ " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on cm.CUSTOMER_ID=bb.ClientId and cm.SYSTEM_ID=bb.SystemId "
	+ " where c.System_Id=? and c.ConsignmentNo=? and c.ConsignmentStatus=? ";

public static final String GET_VEHICLE_TYPE_DIST_FACTOR_MAP = "select a.Category_name as VehicleTypeName, b.ConversionFactor as ConversionFactor from Vehicle_Category_Master a inner join "
	+ "tblDistanceUnitMaster b on  a.DistanceUnitId = b.UnitId and b.ConversionFactor!=1 ";

public static final String GET_REGISTERED_VEHICLE_LIST_TYPE = "select VehicleNo,VehicleType,ModelName,isnull(Odometer ,0) as Odometer from tblVehicleMaster left outer join FMS.dbo.Vehicle_Model on  ModelTypeId=Model where VehicleNo in("
	+ "select Registration_no from Vehicle_User where User_id=? and System_id=?)";


public static final String GET_REGISTERED_VEHICLE_LIST_TYPE_FOR_CLIENT = "select VehicleNo,VehicleType,ModelName,isnull(Odometer ,0) as Odometer,isnull(Status_id,'') as Status_id from tblVehicleMaster left outer join  Vehicle_Status on VehicleNo=Vehicle_id left outer join FMS.dbo.Vehicle_Model on  ModelTypeId=Model where VehicleNo in("
	+ "select Registration_no from Vehicle_User inner join AMS.dbo.VEHICLE_CLIENT on Registration_no=REGISTRATION_NUMBER  where User_id=? and System_id=? and SYSTEM_ID=? and CLIENT_ID=?)";

public static final String SELECT_REGISTRATION_NO_FROM_USER_VEHICLE_TYPE = "select VehicleNo,VehicleType,ModelName, isnull(Odometer ,0) as Odometer from tblVehicleMaster left outer join FMS.dbo.Vehicle_Model on  ModelTypeId=Model where VehicleNo in("
	+ "select Registration_no from Vehicle_User where User_id=? and System_id=?) and Status='Active'";

public static final String SELECT_REGISTRATION_NO_FROM_USER_VEHICLE_TYPE_WITH_ACTIVE = "select VehicleNo,VehicleType,ModelName, isnull(Odometer ,0) as Odometer,isnull(Status_id,'') as Status_id from tblVehicleMaster left outer join  Vehicle_Status on VehicleNo=Vehicle_id left outer join FMS.dbo.Vehicle_Model on  ModelTypeId=Model where VehicleNo in("
	+ " select Registration_no from Vehicle_User inner join AMS.dbo.VEHICLE_CLIENT on Registration_no=REGISTRATION_NUMBER where User_id=? and System_id=? and SYSTEM_ID=? and CLIENT_ID=?) and Status='Active' and VehicleNo not in ( select  REGISTRATION_NO from dbo.SAND_BLOCKED_VEHICLE_DETAILS ) ";


public static final String SELECT_REGISTRATION_NO_FROM_VEHICLE_TYPE = "select VehicleNo,VehicleType,ModelName from tblVehicleMaster left outer join "
	+" FMS.dbo.Vehicle_Model on ModelTypeId=Model where VehicleNo in(select REGISTRATION_NUMBER from VEHICLE_CLIENT where SYSTEM_ID=? and CLIENT_ID=?)";


public static final String GET_PROCESS_ID = "select a.PROCESS_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC a with (NOLOCK)"+
" left outer join ADMINISTRATOR.dbo.PRODUCT_PROCESS b on b.PROCESS_ID=a.PROCESS_ID"+
" where SYSTEM_ID = ?  and CUSTOMER_ID = ? and b.PROCESS_TYPE_LABEL_ID = 'Vertical_Sol'";

public static final String LIVE_VISION_HEADERS= "select b.LANG_ENGLISH,b.LANG_ARABIC,a.DATA_FIELD_LABEL_ID,a.COLOUMN_DATA_TYPE from ADMINISTRATOR.dbo.PROCESS_FIELD_SETTING a with (NOLOCK) "+
"inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b with (NOLOCK) on a.DATA_FIELD_LABEL_ID=b.LABEL_ID "+
"where a.PROCESS_ID=? and a.TYPE in (-1,1) order by a.ORDER_OF_DISPLAY ";

public static final String LIVE_VISION_HEADERS_BY_LABEL= "select a.DATA_FIELD_LABEL_ID from ADMINISTRATOR.dbo.PROCESS_FIELD_SETTING a with (NOLOCK) "+
"where a.PROCESS_ID=? and a.TYPE in (-1,1)  and DATA_FIELD_LABEL_ID=? ";

public static final String MAP_VIEW_HEADERS= "select b.LANG_ENGLISH,b.LANG_ARABIC,a.DATA_FIELD_LABEL_ID,a.PROCESS_ID from ADMINISTRATOR.dbo.PROCESS_FIELD_SETTING a with (NOLOCK) "+
"inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b with (NOLOCK) on a.DATA_FIELD_LABEL_ID=b.LABEL_ID "+
"where a.PROCESS_ID=? and a.TYPE in (-1,2) order by a.ORDER_OF_DISPLAY ";

public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_REGION_BOXES=" select distinct isnull(a.ASSET_NO,'') as VehicleNo,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as CurrentLocation,isnull(a.DATETIME,'') as dateTime, " 
		+ " isnull(a.CONSIGNMENT_NO,'') as ConsignmentNumber,isnull(a.CONSIGNMENT_STATUS,'') as Status,isnull(a.SPEED,0) as Speed, "
		+ " isnull(a.REVISED_DELIVERY_DATE,'') as revisedDeliveryDate ,isnull(a.SCHEDULED_DELIVERY,'') as scheduledDeliverydate,isnull(a.TOATL_DISTANCE,0) as totalDistance, "
		+ " isnull(a.TRAVELLED_DISTANCE,0) as distancetravelled,isnull(bc.BOOKING_CUSTOMER_NAME,'') as BookingName from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
		+ " inner join AMS.dbo.Consignment_Details b on b.System_Id=a.SYSTEM_ID and b.Client_Id=a.CUSTOMER_ID and b.VehicleNo COLLATE DATABASE_DEFAULT=a.ASSET_NO and b.ConsignmentNo COLLATE DATABASE_DEFAULT=a.CONSIGNMENT_NO and b.ConsignmentStatus=a.CONSIGNMENT_STATUS " 
		+ " inner join AMS.dbo.Consignment_Dealer_Master c on b.System_Id=c.SystemId and b.Client_Id=c.ClientId and b.DealerId=c.Slno "
		+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
		+ " inner join AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER bc on bc.ID=a.BOOKING_CUSTOMER_ID and bc.SYSTEM_ID=a.SYSTEM_ID and bc.CUSTOMER_ID=a.CUSTOMER_ID "
		+ " where a.SYSTEM_ID=? and a.STATUS = 'Processing' and c.Region is not null  " 
		+ " and c.Region=? and vu.User_id=?";

public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_DELAY2_FOR_BOXES=" select isnull(b.DealerName,'') as DealerName,isnull(cm.NAME,'') as CustomerName, " 
		+ " isnull(bb.Address,'') as Address,isnull(bb.City,'') as City,isnull(bb.State,'') as State  "
		+ " from AMS.dbo.Consignment_Details c "
		+ " inner join AMS.dbo.Consignment_Dealer_Master b on b.SystemId=c.System_Id and b.ClientId=c.Client_Id and c.DealerId=b.Slno "  
		+ " inner join AMS.dbo.Consignment_Booking_Details bd on bd.System_Id=c.System_Id and bd.Client_Id=c.Client_Id and c.ConsignmentNo=bd.ConsignmentNumber and c.ConsignmentStatus=bd.ConsignmentStatus "
		+ " left outer join AMS.dbo.Consignment_Dealer_Master bb on bb.SystemId=bd.System_Id and bb.ClientId=bd.Client_Id and bd.To_DealerId=bb.Slno "  
		+ " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on cm.CUSTOMER_ID=bb.ClientId and cm.SYSTEM_ID=bb.SystemId "
		+ " where c.System_Id=? and c.ConsignmentNo=?";

public static final String GET_TOTAL_DATA_FOR_TABLE=" select isnull(a.ASSET_NO,'') as VehicleNo,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as CurrentLocation,isnull(a.DATETIME,'') as dateTime, "
		+ " isnull(a.CONSIGNMENT_NO,'') as ConsignmentNumber,isnull(a.CONSIGNMENT_STATUS,'') as Status,isnull(a.SPEED,0) as Speed, "
		+ " isnull(a.REVISED_DELIVERY_DATE,'') as revisedDeliveryDate ,isnull(a.SCHEDULED_DELIVERY,'') as scheduledDeliverydate,isnull(TOATL_DISTANCE,0) as totalDistance,isnull(TRAVELLED_DISTANCE,0) as distancetravelled "
		+ " from AMS.dbo.CONSIGNMENT_DASHBOARD_DEATILS a "
		+ " inner join AMS.dbo.Vehicle_User vu on a.ASSET_NO=vu.Registration_no and a.SYSTEM_ID=vu.System_id "
		+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.CONSIGNMENT_STATUS=? and a.STATUS = 'Processing' and a.CONSIGNMENT_NO!='' and vu.User_id=?";

public static final String GET_ACIO_COLUMN_NAME = " select VEHICLEID as REGISTRATION_NO ,IONO,ALERTID  from VEHICLEIOASSOCIATION where SYSTEMID=?";

public static final String GET_TRIP_DETAILS = "select a.TripId,a.ChartId,a.ClientId,b.RouteName,a.StartTime,a.RouteNameStr from dbo.Vehicle_Trip a "
+ "left outer join dbo.RouteMaster_UniqueId b on a.ClientId=b.ClientId and "
+ "a.SystemId=b.SystemId and a.RouteId=b.RouteId where a.VehicleNo=? and a.Status='open' and a.ClientId=? and a.SystemId=?";

public static final String GET_BOOKING_CUSTOMER= "select Customer,isNull(ContainerNo,'') as ContainerNo from dbo.Trip_Chart_Booking where TripId=? and ChartId=? and ClientId=? and DELETED = 0";

public static final String SAVE_CONSIGNMENT_DETAILS_IN_LOGIN_HISTORY=" insert into AMS.dbo.DEALER_TRACKING_HISTORY(CONSIGNMENT_NO,CONSIGNMENT_EXISTS,SYSTEM_ID,CUSTOMER_ID,IP_ADDRESS,HOST_ADDRESS,SEARCH_DATETIME) values(?,?,?,?,?,?,getUTCDate())";

public static final String GET_STOPPAGE_VEHICLE_DETAILS= "select isnull(ttd.TRIP_NO,'') as TRIP_NO,isnull(ttd.VALIDITY_DATE,'') as VALIDITY_DATE,g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME , "+
"g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
"isnull (b.CLIENT_NAME,'') as CLIENTNAME, "+
"isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName, "+
"isnull (sm.Status_desc,'') as STATUS, "+
"isnull(vs.HubName,'') as HUBNAME,dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE, isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time "+
" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
" from dbo.gpsdata_history_latest g (nolock) "+
" left outer join  dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO  "+	
" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO  "+
" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id " +
" left outer join AMS.dbo.MINING_ASSET_ENROLLMENT mae on mae.SYSTEM_ID=g.System_id and g.REGISTRATION_NO=mae.ASSET_NUMBER " +
" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
" left outer join MINING.dbo.TRUCK_TRIP_DETAILS (nolock) ttd on ttd.ASSET_NUMBER=g.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ttd.STATUS='OPEN' " ;

public static final String GET_STOPPAGE_VEHICLE_DETAILS_FOR_IMPRECISE_LOCATION= "select isnull(ttd.TRIP_NO,'') as TRIP_NO,isnull(ttd.VALIDITY_DATE,'') as VALIDITY_DATE,g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.IM_LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME , "+
"g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
"isnull (b.CLIENT_NAME,'') as CLIENTNAME, "+
"isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName, "+
"isnull (sm.Status_desc,'') as STATUS, "+
"isnull(vs.HubName,'') as HUBNAME,dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE,isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time "+
" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
" from dbo.gpsdata_history_latest g (nolock) "+
" left outer join  dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO  "+	
" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO  "+
" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id " +
" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
" left outer join MINING.dbo.TRUCK_TRIP_DETAILS (nolock) ttd on ttd.ASSET_NUMBER=g.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ttd.STATUS='OPEN' " ;

public static final String GET_IDLE_VEHICLE_DETAILS=  "select isnull(ttd.TRIP_NO,'') as TRIP_NO,isnull(ttd.VALIDITY_DATE,'') as VALIDITY_DATE,g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME , "+
"g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
"isnull (b.CLIENT_NAME,'') as CLIENTNAME, "+
"isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName, "+
"isnull (sm.Status_desc,'') as STATUS, "+
"isnull(vs.HubName,'') as HUBNAME,dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE, isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time "+
" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
" from dbo.gpsdata_history_latest g (nolock) "+
" left outer join dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO  "+
" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO  "+
" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id " +
" left outer join AMS.dbo.MINING_ASSET_ENROLLMENT mae on mae.SYSTEM_ID=g.System_id and g.REGISTRATION_NO=mae.ASSET_NUMBER " +
" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
" left outer join MINING.dbo.TRUCK_TRIP_DETAILS (nolock) ttd on ttd.ASSET_NUMBER=g.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ttd.STATUS='OPEN' " ;

public static final String GET_IDLE_VEHICLE_DETAILS_FOR_IMPRECISE_LOCATION=  "select isnull(ttd.TRIP_NO,'') as TRIP_NO,isnull(ttd.VALIDITY_DATE,'') as VALIDITY_DATE,g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.IM_LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME , "+
"g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
"isnull (b.CLIENT_NAME,'') as CLIENTNAME, "+
"isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName, "+
"isnull (sm.Status_desc,'') as STATUS, "+
"isnull(vs.HubName,'') as HUBNAME,dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE,isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time  "+
" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
" from dbo.gpsdata_history_latest g (nolock) "+
" left outer join dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO  "+
" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO  "+
" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id " +
" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
" left outer join MINING.dbo.TRUCK_TRIP_DETAILS (nolock) ttd on ttd.ASSET_NUMBER=g.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ttd.STATUS='OPEN' " ;

public static final String GET_RUNNING_VEHICLE_DETAILS= "select isnull(ttd.TRIP_NO,'') as TRIP_NO,isnull(ttd.VALIDITY_DATE,'') as VALIDITY_DATE,g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME , "+
"g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
"isnull (b.CLIENT_NAME,'') as CLIENTNAME, "+
"isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName, "+
"isnull (sm.Status_desc,'') as STATUS, "+
"isnull(vs.HubName,'') as HUBNAME,dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE, isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time "+
" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
" from dbo.gpsdata_history_latest g (nolock) "+
" left outer join dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO  "+
" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO  "+
" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id " +
" left outer join AMS.dbo.MINING_ASSET_ENROLLMENT mae on mae.SYSTEM_ID=g.System_id and g.REGISTRATION_NO=mae.ASSET_NUMBER" +
" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
" left outer join MINING.dbo.TRUCK_TRIP_DETAILS (nolock) ttd on ttd.ASSET_NUMBER=g.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ttd.STATUS='OPEN' " ;

public static final String GET_RUNNING_VEHICLE_DETAILS_FOR_IMPRECISE_LOCATION= "select isnull(ttd.TRIP_NO,'') as TRIP_NO,isnull(ttd.VALIDITY_DATE,'') as VALIDITY_DATE,g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.IM_LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME , "+
"g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
"isnull (b.CLIENT_NAME,'') as CLIENTNAME, "+
"isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName, "+
"isnull (sm.Status_desc,'') as STATUS, "+
"isnull(vs.HubName,'') as HUBNAME,dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE,isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time  "+
" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
" from dbo.gpsdata_history_latest g (nolock) "+
" left outer join dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO  "+
" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO  "+
" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id " +
" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
" left outer join MINING.dbo.TRUCK_TRIP_DETAILS (nolock) ttd on ttd.ASSET_NUMBER=g.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ttd.STATUS='OPEN' " ;

public static final String GET_POOR_SAT_VISIBILITY= "select isnull(ttd.TRIP_NO,'') as TRIP_NO,isnull(ttd.VALIDITY_DATE,'') as VALIDITY_DATE,g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME , "+
"g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
"isnull (b.CLIENT_NAME,'') as CLIENTNAME, "+
"isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName, "+
"isnull (sm.Status_desc,'') as STATUS, "+
"isnull(vs.HubName,'') as HUBNAME,dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE, isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time "+
" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
" from dbo.gpsdata_history_latest g (nolock) "+
" left outer join dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO  "+
" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO  "+
" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id " +
" left outer join AMS.dbo.MINING_ASSET_ENROLLMENT mae on mae.SYSTEM_ID=g.System_id and g.REGISTRATION_NO=mae.ASSET_NUMBER" +
" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
" left outer join MINING.dbo.TRUCK_TRIP_DETAILS (nolock) ttd on ttd.ASSET_NUMBER=g.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ttd.STATUS='OPEN' " ;

public static final String GET_POOR_SAT_VISIBILITY_FOR_IMPRECISE_LOCATION= "select isnull(ttd.TRIP_NO,'') as TRIP_NO,isnull(ttd.VALIDITY_DATE,'') as VALIDITY_DATE,g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.IM_LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME , "+
"g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
"isnull (b.CLIENT_NAME,'') as CLIENTNAME, "+
"isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName, "+
"isnull (sm.Status_desc,'') as STATUS, "+
"isnull(vs.HubName,'') as HUBNAME,dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE,isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time "+
" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
" from dbo.gpsdata_history_latest g (nolock) "+
" left outer join dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO  "+
" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO  "+
" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id " +
" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
" left outer join MINING.dbo.TRUCK_TRIP_DETAILS (nolock) ttd on ttd.ASSET_NUMBER=g.REGISTRATION_NO COLLATE DATABASE_DEFAULT and ttd.STATUS='OPEN' " ;

public static final String CHECK_FDAS_EXISTS_FOR_CUSTOMER="select * from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC with (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and PROCESS_ID=36";

public static final String INSERT_CUSTOMER_INFORMATION= "insert into AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER" +
		"(BOOKING_CUSTOMER_ID,BOOKING_CUSTOMER_NAME,EMAIL_ID,PHONE_NO,MOBILE_NO,FAX,TIN,ADDRESS,CITY,USER_ID,PASSWORD,STATE,REGION,STATUS,CUSTOMER_ID,SYSTEM_ID,CREATED_TIME,CREATED_BY)"
	+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getUtcDate(),?)";

public static final String UPDATE_CUSTOMER_INFORMATION=  "update AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER set BOOKING_CUSTOMER_ID=?,BOOKING_CUSTOMER_NAME=?,EMAIL_ID=?,PHONE_NO=?,MOBILE_NO=?, "
	+  "FAX=?,TIN=?,ADDRESS=?,CITY=?,USER_ID=?,PASSWORD=?,STATE=?,REGION=?,STATUS=?,UPDATED_BY=?,UPDATED_TIME=getUtcDate() where SYSTEM_ID=? and CUSTOMER_ID=?  and ID=?";


public static final String CHECK_IF_USER_ID_ALREADY_EXISTS = "select USER_ID from AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER where USER_ID=?";


public static final String GET_BOOKING_CUSTOMER_DETAILS="select ID, isnull(BOOKING_CUSTOMER_ID,'')as BOOKING_CUSTOMER_ID ,BOOKING_CUSTOMER_NAME,EMAIL_ID," +
		" PHONE_NO, isnull(MOBILE_NO,'') as MOBILE_NO,isnull(FAX,'') as FAX, isnull(TIN,'') as TIN," +
		" ADDRESS,isnull(CITY,'') as CITY,isnull(b.STATE_NAME,'') as STATE_NAME,a.STATE,REGION,STATUS,isnull(a.USER_ID,'')as USER_ID,isnull(a.PASSWORD,'')as PASSWORD from AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER a" +
		" left outer join ADMINISTRATOR.dbo.STATE_DETAILS b on a.STATE=b.STATE_CODE  where SYSTEM_ID=? and CUSTOMER_ID=?";

public static final String GET_CUSTOMER=" select a.CUSTOMER_ID,a.NAME,a.STATUS,a.ACTIVATION_STATUS from ADMINISTRATOR.dbo.CUSTOMER_MASTER a "
	+ " inner join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC b on b.CUSTOMER_ID=a.CUSTOMER_ID and b.SYSTEM_ID=a.SYSTEM_ID "
	+ " where a.SYSTEM_ID=? "
	+ " and a.STATUS='Active' and a.ACTIVATION_STATUS='Complete' and PROCESS_ID=34 order by NAME asc ";

public static final String GET_CUSTOMER_FOR_LOGGED_CUST=" select a.CUSTOMER_ID,a.NAME,a.STATUS,a.ACTIVATION_STATUS from ADMINISTRATOR.dbo.CUSTOMER_MASTER a "
+ " inner join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC b on b.CUSTOMER_ID=a.CUSTOMER_ID and b.SYSTEM_ID=a.SYSTEM_ID "
+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? "
+ " and a.STATUS='Active' and a.ACTIVATION_STATUS='Complete' and PROCESS_ID=34 order by NAME asc ";

public static final String SELECT_GROUP_LIST="select a.GROUP_ID,a.GROUP_NAME from ADMINISTRATOR.dbo.ASSET_GROUP a "
	+ " inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on b.SYSTEM_ID=a.SYSTEM_ID and b.GROUP_ID=a.GROUP_ID " 
	+ " where a.SYSTEM_ID=?  and a.CUSTOMER_ID=? and b.USER_ID=? ";

public static final String SELECT_BOOKING_CUSTOMER_LIST=" select ID,BOOKING_CUSTOMER_NAME from AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER where CUSTOMER_ID=? and SYSTEM_ID=? and STATUS='Active'" ;

public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE_FOR_ALL1=" select sum(ASSET_COUNT) as vehicles,sum(ON_TIME_COUNT) as onTime,sum(DELAY_COUNT) as delay, "
+ " sum(ALERTS_COUNT) as alerts,CONSIGNMENT_STATUS as consignmentStatus,REGION as region from AMS.dbo.CONSIGNMENT_DASHBOARD_SUMMARY where "
+ " SYSTEM_ID=? and BOOKING_CUSTOMER_ID!=0 and REGION !='' ";


public static final String GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE_FOR_ALL_FOR_REGION=" select sum(ASSET_COUNT) as vehicles,sum(ON_TIME_COUNT) as onTime,sum(DELAY_COUNT) as delay, "
	+ " sum(ALERTS_COUNT) as alerts,CONSIGNMENT_STATUS as consignmentStatus,REGION as region from AMS.dbo.CONSIGNMENT_DASHBOARD_SUMMARY where "
	+ " SYSTEM_ID=? and REGION=? and BOOKING_CUSTOMER_ID!=0 and REGION !=''";


public static final String SELECT_BOOKING_CUSTOMER_LIST_FOR_ALL=" select ID,BOOKING_CUSTOMER_NAME from AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER where SYSTEM_ID=? and STATUS='Active'" ;

public static final String GET_CONTAINER_DETAILS = "select tcb.SystemId, tcb.ClientId, tcb.ContainerNo, tcb.BookingId, vt.VehicleNo " +
		"from LMS.dbo.Trip_Chart_Booking tcb " +
		"inner join LMS.dbo.Vehicle_Trip vt on vt.TripId=tcb.TripId and vt.SystemId=tcb.SystemId and vt.ClientId=tcb.ClientId " +
		"where upper(tcb.ContainerNo)=? and tcb.BookingId=? and tcb.Status='open' and tcb.DELETED=0 and tcb.SystemId=? and tcb.ClientId=?";

public static final String GET_LTSP_MAP_VIEW_DETAILS = "select a.REGISTRATION_NO,isnull(b.VEHICLE_ID,'') as VEHICLE_ID,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isNull(a.CATEGORY,'') as CATEGORY,a.PREV_LAT,a.PREV_LONG,isnull(b.GROUP_NAME,'') as  GROUP_NAME,ag.GROUP_ID,b.IMAGE_NAME,isnull(c.Manufacturer,'') as Vehicle_Make,a.IGNITION,a.SPEED "+
														"from dbo.gpsdata_history_latest (NOLOCK) a "+
														"inner join dbo.Live_Vision_Support (NOLOCK) b on a.REGISTRATION_NO=b.REGISTRATION_NO "+	
														"left outer join AMS.dbo.VEHICLE_CLIENT vc on a.REGISTRATION_NO=vc.REGISTRATION_NUMBER "+
														"inner join AMS.dbo.tblVehicleMaster c on c.VehicleNo = a.REGISTRATION_NO "+
														"inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.GROUP_ID = vc.GROUP_ID and ag.SYSTEM_ID=a.System_id and ag.CUSTOMER_ID=a.CLIENTID "+
														"where a.System_id=? ";
	
public static final String GET_LTSP_MAP_VIEW_DETAILS_NEW ="select isnull(td.ORDER_ID,'NA') as LR_NO,isnull(td.SHIPMENT_ID,'NA') as TRIP_NO,isnull(td.ROUTE_NAME,'NA') as ROUTE_NAME,isnull(td.CUSTOMER_NAME,'NA') as CUSTOMER_NAME," +
														  " isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,"+
														  " isnull(td.DELAY,0) as DELAY,case when a.CATEGORY='stoppage' then DURATION else 0 end as STOPPAGE_TIME,case when a.CATEGORY='idle' then DURATION else 0 end as IDLE_TIME,"+
														  " a.REGISTRATION_NO,isnull(b.VEHICLE_ID,'') as VEHICLE_ID,a.LATITUDE,a.LONGITUDE,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isNull(a.CATEGORY,'') as CATEGORY,a.PREV_LAT,a.PREV_LONG,isnull(b.GROUP_NAME,'') as  GROUP_NAME,ag.GROUP_ID,b.IMAGE_NAME,isnull(c.Manufacturer,'') as Vehicle_Make,a.IGNITION,a.SPEED,ISNULL(a.SPEED_LIMIT,0) AS SPEED_LIMIT,isnull(a.DRIVER_NAME,'NA') as DRIVER_NAME "+
														  "from dbo.gpsdata_history_latest (NOLOCK) a "+
														  "inner join dbo.Live_Vision_Support (NOLOCK) b on a.REGISTRATION_NO=b.REGISTRATION_NO "+	
														  "left outer join AMS.dbo.VEHICLE_CLIENT vc on a.REGISTRATION_NO=vc.REGISTRATION_NUMBER "+
														  "left outer join AMS.dbo.TRACK_TRIP_DETAILS td on a.REGISTRATION_NO=td.ASSET_NUMBER and td.STATUS = 'OPEN' "+ 
														  "inner join AMS.dbo.tblVehicleMaster c on c.VehicleNo = a.REGISTRATION_NO "+
														  "inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.GROUP_ID = vc.GROUP_ID and ag.SYSTEM_ID=a.System_id and ag.CUSTOMER_ID=a.CLIENTID "+
														  "inner join AMS.dbo.Vehicle_User b2 on a.REGISTRATION_NO = b2.Registration_no and a.System_id = b2.System_id "+
														  "inner join tblVehicleMaster c2 on b2.Registration_no=c2.VehicleNo and b2.System_id=c2.System_id "+
														  "where a.System_id=? and b2.User_id = ? ";

public static final String GET_LTSP_MAP_VIEW_DETAILS_NEW_FOR_IMPRECISE_LOCATION ="select isnull(td.ORDER_ID,'NA') as LR_NO,isnull(td.SHIPMENT_ID,'NA') as TRIP_NO,isnull(td.ROUTE_NAME,'NA') as ROUTE_NAME,isnull(td.CUSTOMER_NAME,'NA') as CUSTOMER_NAME," +
																				 " isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,"+
																				 " isnull(td.DELAY,0) as DELAY,case when a.CATEGORY='stoppage' then DURATION else 0 end as STOPPAGE_TIME,case when a.CATEGORY='idle' then DURATION else 0 end as IDLE_TIME,"+
																				 " a.REGISTRATION_NO,isnull(b.VEHICLE_ID,'') as VEHICLE_ID,a.IM_LATITUDE as LATITUDE,a.IM_LONGITUDE as LONGITUDE,a.IM_LOCATION as LOCATION ,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isNull(a.CATEGORY,'') as CATEGORY,a.PREV_LAT,a.PREV_LONG,isnull(b.GROUP_NAME,'') as  GROUP_NAME,ag.GROUP_ID,b.IMAGE_NAME,isnull(c.Manufacturer,'') as Vehicle_Make,a.IGNITION,a.SPEED,ISNULL(a.SPEED_LIMIT,0) AS SPEED_LIMIT,isnull(a.DRIVER_NAME,'NA') as DRIVER_NAME  "+
																				 "from dbo.gpsdata_history_latest (NOLOCK) a "+
																				 "inner join dbo.Live_Vision_Support (NOLOCK) b on a.REGISTRATION_NO=b.REGISTRATION_NO "+	
																				 "left outer join AMS.dbo.VEHICLE_CLIENT vc on a.REGISTRATION_NO=vc.REGISTRATION_NUMBER "+
																				 "left outer join AMS.dbo.TRACK_TRIP_DETAILS td on a.REGISTRATION_NO=td.ASSET_NUMBER and td.STATUS = 'OPEN' "+
																				 "inner join AMS.dbo.tblVehicleMaster c on c.VehicleNo = a.REGISTRATION_NO "+
																				 "inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.GROUP_ID = vc.GROUP_ID and ag.SYSTEM_ID=a.System_id and ag.CUSTOMER_ID=a.CLIENTID "+
																				 "inner join AMS.dbo.Vehicle_User b2 on a.REGISTRATION_NO = b2.Registration_no and a.System_id = b2.System_id "+
																				 "inner join tblVehicleMaster c2 on b2.Registration_no=c2.VehicleNo and b2.System_id=c2.System_id "+
																				 "where a.System_id=? and b2.User_id = ? ";

public static final String GET_BUFFERS_FOR_LTSP_MAP_VIEW = "select  NAME,LONGITUDE,LATITUDE,RADIUS,IMAGE,isNull(HUBID,0) as HUBID from LOCATION where  RADIUS<> -1 and SYSTEMID=? and OPERATION_ID<>2 ";

public static final String GET_BUFFERS_FOR_USER_MAP_VIEW = "select NAME,LONGITUDE,LATITUDE,RADIUS,IMAGE,isNull(HUBID,0) as HUBID from LOCATION "+
			"where SYSTEMID = ? and OPERATION_ID<>2 and  ((RADIUS=0 and CLIENTID = ? and SYSTEMID = ?) or (RADIUS>0 and HUBID in (select HubId from UserHubAssociation where UserId = ? and ClientId = ? and SystemId = ?)))";

public static final String GET_POLYGONS_FOR_LTSP_MAP = "select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE from dbo.POLYGON_LOCATION_DETAILS a left outer join LOCATION_ZONE b on a.HUBID=b.HUBID where a.SYSTEM_ID=? and b.OPERATION_ID<>2 order by a.HUBID,a.SEQUENCE_ID";

public static final String GET_POLYGONS_FOR_USER_MAP = "select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE from dbo.POLYGON_LOCATION_DETAILS a  "+
														"left outer join LOCATION_ZONE b on a.HUBID = b.HUBID   "+
														"where a.SYSTEM_ID = ? and b.OPERATION_ID<>2 and b.HUBID in (select HubId from UserHubAssociation where UserId = ? and ClientId = ? and SystemId = ?)  "+
														"order by a.HUBID,a.SEQUENCE_ID"; 

public static final String GET_SERVICE_STATION_FOR_LTSP_MAP = "select isnull(a.NAME,'') as NAME,a.HUBID,isnull(b.SEQUENCE_ID,0) as SEQUENCE_ID ,isnull(b.LATITUDE,0) as LATITUDE ,isnull(b.LONGITUDE,0) as LONGITUDE, "+
																"isnull(a.LATITUDE,0) as LAT,isnull(a.LONGITUDE,0) as LONG,a.RADIUS from LOCATION_ZONE  a  "+
																"left outer join dbo.POLYGON_LOCATION_DETAILS b on a.HUBID=b.HUBID and a.SYSTEMID=b.SYSTEM_ID "+  
																"where a.SYSTEMID=? and a.OPERATION_ID=18 and a.HUBID in (select HUB_ID from AMS.dbo.SERVICE_STATION_MAKE_ASSOC where SYSTEM_ID=? and ASSET_MAKE=? and GROUP_ID=?) "+
																"order by a.HUBID,b.SEQUENCE_ID ";


public static final String GET_REGISTERED_VEHICLE_LIST_TYPE_FOR_LTSP_DASHBOARD = "select VehicleNo,VehicleType,ModelName,isnull(Odometer ,0) as Odometer from tblVehicleMaster left outer join FMS.dbo.Vehicle_Model on  ModelTypeId=Model where System_id=?";

//public static final String GET_LIVE_VISION_VIEW_LTSP_DASHBOARD ="select g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
//"g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME ,g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
//"isnull (b.CLIENT_NAME,'') as CLIENTNAME,isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
//"b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
//"isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
//"isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(vm.ModelName,'') as ModelName,isnull (sm.Status_desc,'') as STATUS,isnull(vs.HubName,'') as HUBNAME," +
//"dateadd(mi,?,vs.Date_Time) as HUBDATETIME,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd "+
//"from dbo.gpsdata_history_latest g (nolock) "+
//"left outer join dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO "+																
//"left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO "+
//"left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
//"left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
//"left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id "+
//"left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
//"where g.System_id=? ";

public static final String GET_LIVE_VISION_VIEW_LTSP_DASHBOARD = 
	" select g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
	" g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME ,g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
	" isnull (b.CLIENT_NAME,'') as CLIENTNAME,isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
	" b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
	" isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
	" isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName,isnull (sm.Status_desc,'') as STATUS,isnull(vs.HubName,'') as HUBNAME, "+
	" dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE, isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time "+
	" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
	" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
	" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
	" from dbo.gpsdata_history_latest g (nolock) "+
	" left outer join dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO 	"+															
	" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO "+
	" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
	" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
	" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id "+
	" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
	" left outer join AMS.dbo.MINING_ASSET_ENROLLMENT mae on mae.SYSTEM_ID=g.System_id and g.REGISTRATION_NO=mae.ASSET_NUMBER " +
	" inner join AMS.dbo.Vehicle_User b2 on g.REGISTRATION_NO = b2.Registration_no and g.System_id = b2.System_id "+
	" inner join tblVehicleMaster c on b2.Registration_no=c.VehicleNo and b2.System_id=c.System_id "+
	" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
	" where g.System_id=? and b2.User_id = ? ";

public static final String GET_LIVE_VISION_VIEW_LTSP_DASHBOARD_FOR_IMPRECISE_LOCATION = " select g.REGISTRATION_NO  as VehicleNo,g.GPS_DATETIME AS DATETIME,g.GMT,isnull (g.IM_LOCATION,'') as LOCATION,g.IGNITION,g.SPEED,g.IO3, g.IO4, g.IO5, "+
" g.IO6, g.IO7,g.System_id,g.CLIENTID,g.ANALOG_INPUT_2 as Temperature,isnull (g.DRIVER_NAME, '')as DRIVER_NAME ,g.SPEED_LIMIT,g.CATEGORY+'@'+cast(g.DURATION as varchar) as StopIdle,isnull(g.DRIVER_MOBILE,'') as DRIVER_MOBILE, "+
" isnull (b.CLIENT_NAME,'') as CLIENTNAME,isnull (b.ENGINE_HOUR1,0.0) AS ENGINEHOURS1, isnull (b.ENGINE_HOUR2,0.0) as ENGINEHOURS2,isnull(b.AC_HOURS,0) as ACHOURS,isnull ( b.GROUP_NAME,'') as GROUP_NAME, "+
" b.IMAGE_NAME as ImageName,isnull(g.FUEL_LEVEL_PERCENTAGE,0) as FUEL_LEVEL_PERCENTAGE,isnull (b.NOTES,'') as REMARKS,isnull(b.OWNER_NAME,'') as OWNER_NAME,isnull (b.VEHICLE_ID,'') as VEHICLE_ID, "+
" isnull(b.STATUS,'Active') as VEH_STATUS,isnull (b.IB_VOLTAGE_PERCENTAGE,'0') as IB_VOLTAGE,isnull (g.MAIN_BATTERY_VOLTAGE,'0') as Battery_Voltage,isnull (dateadd(mi,?,b.BEACON_ON_OFF_TIME),'') as BEACON_ON_OFF_TIME, "+
" isnull (b.PERSON_STATUS,'') as PERSON_STATUS,isnull(tvm.VehicleType,'') as VehicleType,isnull(tvm.Odometer ,0) as Odometer,isnull(obd.ODOMETER ,'') as OBDOdometer,isnull(vm.ModelName,'') as ModelName,isnull (sm.Status_desc,'') as STATUS,isnull(vs.HubName,'') as HUBNAME, "+
" dateadd(mi,?,vs.Date_Time) as HUBDATETIME,dateadd(mi,?,obd.GMT) as OBDDateTime,isnull(g.EASTWEST,'') as DIRECTION, isnull (g.IB_VOLTAGE,'0') as Internal_Battery_Voltage,isnull(obd.REGISTRATION_NO,'') as obd,isnull(mae.OPERATING_ON_MINE,'') as OPERATING_ON_MINE, isNull(b.FUEL_LTR,'-1') as FUEL_LTR,dateadd(mi,?,FUEL_GMT) as Last_Fuel_Time "+
" ,g.LATITUDE,g.LONGITUDE,g.LOCATION "+
" ,isnull(lvc.TRIP_CUSTOMER,'') AS Trip_Customer,isnull(lvc.TEMP_INFO_FOR_TCL,'') AS Temp_info_for_TCL,isnull(lvc.SET_TEMP_LIMITS_FOR_ON_TRIP,'') AS Set_Temp_limits_for_on_trip ,isnull(lvc.ETP,'') AS ETP,isnull(lvc.ATP,'') AS ATP ," +
" isnull(lvc.ETA,'') AS ETA ,isnull(lvc.ATA,'') AS ATA,isnull(lvc.AGING,'') AS Ageing,isnull(lvc.CITY,'') AS City,isnull(obd.OBD_CONNECTION_STATUS,'') as OBDConnectionStatus "+ //
" from dbo.gpsdata_history_latest g (nolock) "+
" left outer join dbo.Live_Vision_Support  b (nolock) on g.REGISTRATION_NO=b.REGISTRATION_NO 	"+															
" left outer join  tblVehicleMaster tvm (nolock) on tvm.VehicleNo=g.REGISTRATION_NO "+
" left outer join FMS.dbo.Vehicle_Model vm (nolock) on tvm.Model=vm.ModelTypeId "+
" left outer join Vehicle_Status (nolock) vs on g.REGISTRATION_NO=vs.Vehicle_id  "+
" left outer join Status_Master (nolock) sm on vs.Status_id=sm.Status_id "+
" left outer join dbo.GPSDATA_LIVE_CANIQ (nolock) obd on obd.System_id=g.System_id and obd.REGISTRATION_NO=g.REGISTRATION_NO "+
" inner join AMS.dbo.Vehicle_User b2 on g.REGISTRATION_NO = b2.Registration_no and g.System_id = b2.System_id "+
" inner join tblVehicleMaster c on b2.Registration_no=c.VehicleNo and b2.System_id=c.System_id "+
" left outer join LIVE_VISION_COLUMNS (nolock) lvc on lvc.VEHICLE_NO=g.REGISTRATION_NO "+ //
" where g.System_id=? and b2.User_id = ? ";



public static final String GET_MAIN_POWER_ON_OFF_FOR_LTSP="select top 1 isnull(HUB_ID,0) as HUB_ID,LOCATION,GMT,dateadd(mi,?,GMT) as LOCALTIME from dbo.Alert where REGISTRATION_NO=? and TYPE_OF_ALERT=7  and SYSTEM_ID=? and GMT>dateadd(hh,-48,getutcdate())  order by  GMT desc";

public static final String GET_VOLTAGE_DETAILS_FOR_LTSP="select isnull(a.MAIN_BATTERY_VOLTAGE,0)as MAIN_BATTERY_VOLTAGE,a.LOCATION,a.VALID,a.INVALID_UPDATETIME,isnull(tbVM.BatteryVoltage,'') as BATTERY_VOLTAGE,dateadd(mi,?,GMT) as LOCALTIME,GMT,datediff(mi,GMT,getutcdate()) as NONCOMM_HOURS,isnull(cast (SATELLITE as varchar(10)),'NA') as SATELLITE from gpsdata_history_latest a "+
"INNER JOIN tblVehicleMaster tbVM ON a.REGISTRATION_NO=tbVM.VehicleNo "+
"where a.REGISTRATION_NO=? and a.System_id=?";

public static final String GET_BORDERS_FOR_LTSP_MAP = "select isnull(a.NAME,'') as NAME,a.HUBID,isnull(b.SEQUENCE_ID,0) as SEQUENCE_ID ,isnull(b.LATITUDE,0) as LATITUDE ,isnull(b.LONGITUDE,0) as LONGITUDE ,isnull(a.LATITUDE,0) as LAT,isnull(a.LONGITUDE,0) as LONG,a.RADIUS from LOCATION_ZONE  a "+
"left outer join dbo.POLYGON_LOCATION_DETAILS b on a.HUBID=b.HUBID  and a.SYSTEMID=b.SYSTEM_ID  where  a.SYSTEMID=? and a.OPERATION_ID=2 order by a.HUBID,b.SEQUENCE_ID";

public static final String GET_ALL_CLIENT_VEHICLE = "select REGISTRATION_NUMBER as VehicleNo from AMS.dbo.VEHICLE_CLIENT where SYSTEM_ID=? and CLIENT_ID=?";

public static final String GET_LAT_LONG_FOR_MAP_CENTER = "select isNull(Latitude,0) as Latitude,isNull(Longitude,0) as Longitude from dbo.System_Master where System_id=?";

public static final String GET_OBD_VEHICLES = "select isnull(REGISTRATION_NO,'') as vehicleNo  from dbo.GPSDATA_LIVE_CANIQ can"+
	" inner join Vehicle_User vu on vu.System_id=can.System_id  and can.REGISTRATION_NO=vu.Registration_no and vu.User_id=?"+
	" and vu.System_id=? # and LATITUDE is not null and LONGITUDE is not null";


public static final String LIVE_VISION_HEADERS_FOR_FILTER= "select b.LANG_ENGLISH,b.LANG_ARABIC,a.DATA_FIELD_LABEL_ID,a.COLOUMN_DATA_TYPE,'true' as Visibility" +
" from ADMINISTRATOR.dbo.PROCESS_FIELD_SETTING a with (NOLOCK) "+
"inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b with (NOLOCK) on a.DATA_FIELD_LABEL_ID=b.LABEL_ID "+
"where a.PROCESS_ID=? and a.TYPE in (-1,1) order by a.ORDER_OF_DISPLAY ";

public static final String LIVE_VISION_FILTER_DATA="INSERT INTO AMS.dbo.OnlineDataWindowUserDisplay (SystemId,ColumnName,ColumnOrder,Visibility,ClientId,UserId) values(?,?,?,?,?,?)";

public static final String LIVE_VISION_FILTER_DATA_DELETION="DELETE FROM AMS.dbo.OnlineDataWindowUserDisplay where SystemId=? and ClientId=? and UserId=?";

public static final String LIVE_VISION_FILTER_DATA_CHECK_BEFORE_DELETION="SELECT ColumnName FROM AMS.dbo.OnlineDataWindowUserDisplay where SystemId=? and ClientId=? and UserId=?";


public static final String GET_HEADERS_FROM_USER_SETTING = "select b.LANG_ENGLISH,b.LANG_ARABIC,a.ColumnName as DATA_FIELD_LABEL_ID from AMS.dbo.OnlineDataWindowUserDisplay a with (NOLOCK)"+
" inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b with (NOLOCK) on a.ColumnName=b.LABEL_ID COLLATE DATABASE_DEFAULT"+
" where a.SystemId=? and a.ClientId=? and UserId=? and Visibility='true' order by a.ColumnOrder";

public static final String GET_HEADERS_FROM_USER_SETTING1="select b.LANG_ENGLISH,b.LANG_ARABIC,a.ColumnName as DATA_FIELD_LABEL_ID,Visibility" +
" from AMS.dbo.OnlineDataWindowUserDisplay a with (NOLOCK)"+
" inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b with (NOLOCK) on a.ColumnName=b.LABEL_ID COLLATE DATABASE_DEFAULT"+
" where a.SystemId=? and a.ClientId=? and UserId=? order by a.ColumnOrder";

public static final String GET_HEADERS_FROM_USER_SETTING_FOR_MAPVIEW = "select b.LANG_ENGLISH,b.LANG_ARABIC,a.ColumnName as DATA_FIELD_LABEL_ID from AMS.dbo.OnlineDataWindowUserDisplay a with (NOLOCK)"+
" inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION b with (NOLOCK) on a.ColumnName=b.LABEL_ID COLLATE DATABASE_DEFAULT"+
" where a.SystemId=? and a.ClientId=? and UserId=? and Visibility='true' order by a.ColumnOrder";

public static final String GET_DMG_BARGE_TRIP_DETAILS = " select top 1 * from ( " +
" select  a.TRIP_NO,a.INSERTED_TIME,ISNULL(cast(dateadd(mi,330,a.INSERTED_TIME) as varchar(20)), '') as ISSUED_DATE,ISNULL(cast(a.VALIDITY_DATE as varchar(20)), '') as START_TIME,ISNULL(a.STATUS,'') AS STATUS " +
" from MINING.dbo.BARGE_TRIP_DETAILS a with (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? and TYPE is not null " +
" )r "+
" order by r.INSERTED_TIME desc  ";

public static final String GET_TRIP_INFO = "select top 1 CUSTOMER_NAME from TRACK_TRIP_DETAILS where ASSET_NUMBER = ? and STATUS = 'OPEN'";

public static final String GET_TRIP_DETAILS_FOR_LIVE_VISION =" SELECT td.ASSET_NUMBER,td.TRIP_ID,isnull(CUSTOMER_NAME, 'NA') as CUSTOMER_NAME,isnull(PRODUCT_LINE,'Dry') as PRODUCT_LINE, " +
 " dateadd(mi,$,ds0.ETA_ARR_DATETIME) as ETP,dateadd(mi,$,ds0.ACT_ARR_DATETIME) as ATP,dateadd(mi,$,ds100.ETA_ARR_DATETIME) as ETA," +
 " dateadd(mi,$,ds100.ACT_ARR_DATETIME) as ATA, MIN_NEGATIVE_TEMP as negativeMin, MAX_NEGATIVE_TEMP as negativeMax," +
 " MIN_POSITIVE_TEMP as positiveMin,MAX_POSITIVE_TEMP as positiveMax,TEMPERATURE_DATA=STUFF((SELECT ',' + CAST(tvt.DISPLAY_NAME as varchar)" +
 " +CAST('=' AS VARCHAR)+CAST((SELECT IO_VALUE FROM AMS.dbo.RS232_LIVE (nolock) WHERE REGISTRATION_NO=td.ASSET_NUMBER AND IO_ID=tvt.SENSOR_NAME) AS VARCHAR) " +
 " FROM AMS.dbo.TRIP_VEHICLE_TEMPERATURE_DETAILS (nolock) tvt WHERE TRIP_ID=td.TRIP_ID FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') " +
 " FROM TRACK_TRIP_DETAILS (nolock) td  "+
 " LEFT OUTER JOIN DES_TRIP_DETAILS (nolock) ds0 on ds0.SEQUENCE=0 AND ds0.TRIP_ID=td.TRIP_ID "+
 " LEFT OUTER JOIN DES_TRIP_DETAILS (nolock) ds100 on ds100.SEQUENCE=100 AND ds100.TRIP_ID=td.TRIP_ID  "+
 " LEFT OUTER JOIN TRIP_VEHICLE_TEMPERATURE_DETAILS (nolock) tvt ON tvt.TRIP_ID=td.TRIP_ID  "+
 " WHERE td.TRIP_ID=(SELECT TOP 1 TRIP_ID from TRACK_TRIP_DETAILS (nolock) where ASSET_NUMBER = ? and STATUS = 'OPEN') ";

	public static final String GET_AGEING = "select top 1 DATEDIFF(mi,isnull(ds100.ACT_ARR_DATETIME,td.ACTUAL_TRIP_END_TIME),getutcdate()) as AGING "+
	" from TRACK_TRIP_DETAILS (nolock) td  "+
	" LEFT OUTER JOIN DES_TRIP_DETAILS (nolock) ds100 on ds100.SEQUENCE=100 AND ds100.TRIP_ID=td.TRIP_ID" +
	" WHERE ASSET_NUMBER = ? order by td.TRIP_ID desc";
	
	public static final String GET_POLYGONS_FOR_MAP_TRIP = "select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE from dbo.POLYGON_LOCATION_DETAILS a left outer join LOCATION_ZONE b on a.HUBID=b.HUBID where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and b.OPERATION_ID<>2 ## order by a.HUBID,a.SEQUENCE_ID";

	public static final String GET_POLYGONS_FOR_USER_MAP_TRIP = "select isnull(b.NAME,'') as NAME,a.HUBID,a.SEQUENCE_ID,a.LATITUDE,a.LONGITUDE from dbo.POLYGON_LOCATION_DETAILS a  "+
	"left outer join LOCATION_ZONE b on a.HUBID = b.HUBID   "+
	"where a.SYSTEM_ID = ? and b.OPERATION_ID<>2 and b.HUBID in (select HubId from UserHubAssociation where UserId = ? and ClientId = ? and SystemId = ?) ## "+
	"order by a.HUBID,a.SEQUENCE_ID"; 
	
	public static final String GET_LIVE_VISION_COLUMN_DATA = "SELECT COUNT(*) as DATA_COUNT FROM LIVE_VISION_COLUMNS WHERE VEHICLE_NO = ?";
	
	public static final String INSERT_LIVE_VISION_COLUMNS = "INSERT LIVE_VISION_COLUMNS (VEHICLE_NO,SYSTEM_ID,CLIENT_ID,TRIP_CUSTOMER,TEMP_INFO_FOR_TCL,SET_TEMP_LIMITS_FOR_ON_TRIP,ETP,ATP,ETA,ATA,AGING,INSERTED_DATETIME,CITY) VALUES (?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?)";
	
	public static final String UPDATE_LIVE_VISION_COLUMNS = "UPDATE LIVE_VISION_COLUMNS SET TRIP_CUSTOMER = ? , TEMP_INFO_FOR_TCL = ?,SET_TEMP_LIMITS_FOR_ON_TRIP = ? ,ETP = ?,ATP = ?,ETA = ?,ATA = ?,AGING =? ,CITY =? , UPDATED_DATETIME = getutcdate() WHERE VEHICLE_NO = ?";
}