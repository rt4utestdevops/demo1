package t4u.statements;

public class CashVanManagementStatements {
	/**
	 * getting total alert record from CASH_VAN_DASHBOARD_SETTING table 
	 */
	
	public static final String GET_ALERT="select ALERT_ID,ALERT_NAME_LABEL_ID from dbo.CASH_VAN_DASHBOARD_SETTING where SYSTEM_ID=? order by ORDER_OF_ALERT";
	/**
	 * getting count of different alert from Alert table;
	 */
	public static final String GET_CVS_DASHBOARD_SETTING="select ALERT_ID,ALERT_NAME_LABEL_ID from dbo.CASH_VAN_DASHBOARD_SETTING " +
			"where ALERT_NAME_LABEL_ID in('VEHICLE_ON_OFF_ROAD','STATUTORY-BARCHART','VEHICLELIVESTATUS-PIECHART','PREVENTIVEMAINTAINACE-PIECHART','COMMISSIONED/DECOMMISIONED-PIECHART','REFUEL_LITERS','TOTAL_ASSET','COMMUNICATING','NONCOMMUNICATING','NO_GPS') " +
			"and SYSTEM_ID=? order by ORDER_OF_ALERT";
	
	public static final String GET_ALERT_COUNT="select count(a.REGISTRATION_NO) as COUNT " +
	 "from dbo.Alert a inner join VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID   "+
	 "left outer join tblVehicleMaster vm on b.REGISTRATION_NUMBER = vm.VehicleNo   "+
	 "where a.TYPE_OF_ALERT=? and GMT>dateadd(mi,-?,getutcdate()) and a.CLIENTID=?  and b.SYSTEM_ID=? and  a.ISREDALERT<>'Y'";
	
	public static final String GET_DETENTION_ALERT_COUNT="select count(a.REGISTRATION_NO) as COUNT " +
	 "from dbo.Alert a inner join VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID   "+
	 "left outer join tblVehicleMaster vm on b.REGISTRATION_NUMBER = vm.VehicleNo   "+
	 "where a.TYPE_OF_ALERT=?  and a.CLIENTID=?  and b.SYSTEM_ID=? and  a.ISREDALERT<>'Y' and GMT>dateadd(hh,-48,getutcdate()) ";
	/**
	 * getting count of different alert from Exception_Analysis_Alerts table;
	 */
	public static final String GET_PREVENTIVE_ALERT_COUNT="select Count(*) as COUNT from [AMS].[dbo].[Exception_Analysis_Alerts] where [System_Id]=? and Checked='N' and Client_Id=? " ;
	
	/**
	 * getting count of Statutory  table;
	 
	public static final String GET_STATUTORY_ALERT_COUNT="select SUM(R.INSURANCE_DOE)AS INSURANCE_DOE,SUM(INSURANCE_EXP)AS INSURANCE_EXP, "+  
	 "SUM(R.GOODS_TOKEN_TAX_DOE)AS GOODS_TOKEN_TAX_DOE,SUM(R.GOODS_TOKEN_TAX_EXP)AS GOODS_TOKEN_TAX_EXP,   "+
	 "SUM(R.FCI_DOE)AS FCI_DOE,SUM(R.FCI_EXP)AS FCI_EXP,   "+
	 "SUM(R.EMISSION_DOE)AS EMISSION_DOE,SUM(R.EMISSION_EXP)AS EMISSION_EXP,  "+ 
	 "SUM(R.PERMIT_DOE)AS PERMIT_DOE,SUM(R.PERMIT_EXP)AS PERMIT_EXP,   "+
	 "SUM(R.REGISTRATION_DOE)AS REGISTRATION_DOE,SUM(R.REGISTRATION_EXP)AS REGISTRATION_EXP, "+
	 "SUM(R.DRIVER_LICENSE_DOE)AS DRIVER_LICENSE_DOE,SUM(R.DRIVER_LICENSE_EXP)AS DRIVER_LICENSE_EXP from "+
	 "(select SUM(CASE WHEN AlertId=10 THEN 1 ELSE 0 END)AS INSURANCE_DOE,SUM(CASE WHEN AlertId=32 THEN 1 ELSE 0 END)AS INSURANCE_EXP,  "+ 
	 "SUM(CASE WHEN AlertId=11 THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_DOE,SUM(CASE WHEN AlertId=33 THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_EXP,   "+
	 "SUM(CASE WHEN AlertId=12 THEN 1 ELSE 0 END)AS FCI_DOE,SUM(CASE WHEN AlertId=34 THEN 1 ELSE 0 END)AS FCI_EXP,   "+
	 "SUM(CASE WHEN AlertId=13 THEN 1 ELSE 0 END)AS EMISSION_DOE,SUM(CASE WHEN AlertId=35 THEN 1 ELSE 0 END)AS EMISSION_EXP,   "+
	 "SUM(CASE WHEN AlertId=15 THEN 1 ELSE 0 END)AS PERMIT_DOE,SUM(CASE WHEN AlertId=36 THEN 1 ELSE 0 END)AS PERMIT_EXP, "+ 
	 "SUM(CASE WHEN AlertId=130 THEN 1 ELSE 0 END)AS REGISTRATION_DOE,SUM(CASE WHEN AlertId=131 THEN 1 ELSE 0 END)AS REGISTRATION_EXP, "+
	 "SUM(CASE WHEN AlertId=66 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_DOE,SUM(CASE WHEN AlertId=67 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_EXP   "+ 
	 "from dbo.StatutoryAlert where UpdatedDate> dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  ClientId=? and SystemId=? "+
		"union all "+
		"select SUM(CASE WHEN AlertId=10 THEN 1 ELSE 0 END)AS INSURANCE_DOE,SUM(CASE WHEN AlertId=32 THEN 1 ELSE 0 END)AS INSURANCE_EXP,   "+
	 "SUM(CASE WHEN AlertId=11 THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_DOE,SUM(CASE WHEN AlertId=33 THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_EXP,  "+ 
	 "SUM(CASE WHEN AlertId=12 THEN 1 ELSE 0 END)AS FCI_DOE,SUM(CASE WHEN AlertId=34 THEN 1 ELSE 0 END)AS FCI_EXP,   "+
	 "SUM(CASE WHEN AlertId=13 THEN 1 ELSE 0 END)AS EMISSION_DOE,SUM(CASE WHEN AlertId=35 THEN 1 ELSE 0 END)AS EMISSION_EXP,  "+ 
	 "SUM(CASE WHEN AlertId=15 THEN 1 ELSE 0 END)AS PERMIT_DOE,SUM(CASE WHEN AlertId=36 THEN 1 ELSE 0 END)AS PERMIT_EXP, "+ 
	 "SUM(CASE WHEN AlertId=130 THEN 1 ELSE 0 END)AS REGISTRATION_DOE,SUM(CASE WHEN AlertId=131 THEN 1 ELSE 0 END)AS REGISTRATION_EXP,   "+
	 "SUM(CASE WHEN AlertId=66 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_DOE,SUM(CASE WHEN AlertId=67 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_EXP   "+ 
	 "from dbo.StatutoryAlertHistory where UpdatedDate> dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  ClientId=? and SystemId=?) R";
	
	*/
	public static final String GET_STATUTORY_ALERT_COUNT = "select SUM(CASE WHEN AlertId=10 THEN 1 ELSE 0 END)AS INSURANCE_DOE,SUM(CASE WHEN AlertId=32 THEN 1 ELSE 0 END)AS INSURANCE_EXP,  "+ 
															 "SUM(CASE WHEN (AlertId=11 or AlertId=127) THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_DOE,SUM(CASE WHEN (AlertId=33 or AlertId=128) THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_EXP,   "+
															 "SUM(CASE WHEN AlertId=12 THEN 1 ELSE 0 END)AS FCI_DOE,SUM(CASE WHEN AlertId=34 THEN 1 ELSE 0 END)AS FCI_EXP,   "+
															 "SUM(CASE WHEN AlertId=13 THEN 1 ELSE 0 END)AS EMISSION_DOE,SUM(CASE WHEN AlertId=35 THEN 1 ELSE 0 END)AS EMISSION_EXP,   "+
															 "SUM(CASE WHEN AlertId=15 THEN 1 ELSE 0 END)AS PERMIT_DOE,SUM(CASE WHEN AlertId=36 THEN 1 ELSE 0 END)AS PERMIT_EXP, "+ 
															 "SUM(CASE WHEN AlertId=130 THEN 1 ELSE 0 END)AS REGISTRATION_DOE,SUM(CASE WHEN AlertId=131 THEN 1 ELSE 0 END)AS REGISTRATION_EXP, "+
															 "SUM(CASE WHEN AlertId=66 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_DOE,SUM(CASE WHEN AlertId=67 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_EXP   "+ 
															 "from dbo.StatutoryAlert where UpdatedDate> dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  ClientId=? and SystemId=? ";
	
	public static final String GET_STATUTORY_ALERT_COUNT_NEW = "select SUM(CASE WHEN AlertId=10 THEN 1 ELSE 0 END)AS INSURANCE_DOE,SUM(CASE WHEN AlertId=32 THEN 1 ELSE 0 END)AS INSURANCE_EXP,  "+ 
	 "SUM(CASE WHEN (AlertId=11 or AlertId=127) THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_DOE,SUM(CASE WHEN (AlertId=33 or AlertId=128) THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_EXP,   "+
	 "SUM(CASE WHEN AlertId=12 THEN 1 ELSE 0 END)AS FCI_DOE,SUM(CASE WHEN AlertId=34 THEN 1 ELSE 0 END)AS FCI_EXP,   "+
	 "SUM(CASE WHEN AlertId=13 THEN 1 ELSE 0 END)AS EMISSION_DOE,SUM(CASE WHEN AlertId=35 THEN 1 ELSE 0 END)AS EMISSION_EXP,   "+
	 "SUM(CASE WHEN AlertId=15 THEN 1 ELSE 0 END)AS PERMIT_DOE,SUM(CASE WHEN AlertId=36 THEN 1 ELSE 0 END)AS PERMIT_EXP, "+ 
	 "SUM(CASE WHEN AlertId=130 THEN 1 ELSE 0 END)AS REGISTRATION_DOE,SUM(CASE WHEN AlertId=131 THEN 1 ELSE 0 END)AS REGISTRATION_EXP, "+
	 "SUM(CASE WHEN AlertId=66 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_DOE,SUM(CASE WHEN AlertId=67 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_EXP   "+ 
	 "from  ( "+
" select * from dbo.StatutoryAlert where UpdatedDate> dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  ClientId=? and SystemId=? "+
" and AlertId  in (66,67) "+
" union all "+
" select * from dbo.StatutoryAlert where UpdatedDate> dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  ClientId=? and SystemId=? "+ 
" and AlertId not in (66,67) and VehicleNo in ( select Registration_no from  AMS.dbo.Vehicle_User  where System_id = ? and User_id = ? ) "+
" ) s ";
	
	/***
	 * getting fuel Count from FMS.dbo.MileagueMaster for last 24 hours
	 */
	
	public static final String GET_VEHICLE_ON_OFF_TRIP="Select(select count(*) as [IN] from FMS.dbo.JobCard_In_Mstr a "+
													   "inner join dbo.Vehicle_User b on b.Registration_no collate database_default =a.RegistrationNo and b.System_id=a.SystemId "+
													   "where b.User_id =? and a.JobCardStatus='Open' and a.SystemId=? and a.ClientId=?) as intcount, "+
													   "(select count(*) from FMS.dbo.JobCard_Ext_Mstr c "+
													   "inner join dbo.Vehicle_User d on d.Registration_no collate database_default =c.RegistrationNo and d.System_id=c.SystemId "+
													   "where d.User_id =? and c.JobCardStatus='Open' and c.SystemId=? and c.ClientId=?) as extcount, "+
													   "(select count(*)from AMS.dbo.gpsdata_history_latest e "+
													   "inner join AMS.dbo.Vehicle_User f on f.Registration_no collate database_default =e.REGISTRATION_NO and f.System_id=e.System_id  "+
													   "and f.User_id =? and e.System_id=? and e.CLIENTID=?)as totalcount, "+
													   " (select count(*) from AMS.dbo.TRIP_PLANNER t "+			 
													   " inner join AMS.dbo.Vehicle_User v on t.SYSTEM_ID=v.System_id  and t.ASSET_NUMBER=v.Registration_no "+  
													   " where t.STATUS='Open' and v.User_id=? and t.SYSTEM_ID=? and t.CUSTOMER_ID=?) as ontripcount "; 
	
	public static final String GET_FUEL_COUNT = "select sum(Disel) as Litres from FMS.dbo.MileagueMaster where DateTime>dateadd(mi,-?,getutcdate()) and ClientId=? and SystemId=?";
	
	public static final String GET_REFUEL_COUNT = "select sum(Disel) as Litres from FMS.dbo.MileagueMaster where DateTime>=dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))  and ClientId=? and SystemId=?";
	
	public static final String GET_TOTAL_ASSET_COUNT_FOR_LTSP = "select count(*) as TOTAL_ASSETS_COUNT from gpsdata_history_latest a "
								+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
								+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
								+ "where a.CLIENTID = ? and a.System_id = ? and b.User_id=?";
	
	public static final String GET_TOTAL_ASSET_COUNT_FOR_CLIENT = "select count(*) as TOTAL_ASSETS_COUNT  from gpsdata_history_latest a "
								+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
								+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
								+ "where a.CLIENTID = ? and a.System_id = ? and b.User_id=?";
	
	public static final String GET_NON_COMMUNICATING_FOR_LTSP="select count(*) as NON_COMMUNICATING from dbo.gpsdata_history_latest a " +
							"inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	
							+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
							+"where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= ? and b.User_id=?";

	public static final String GET_NON_COMMUNICATING_FOR_CLIENT="select count(*) as NON_COMMUNICATING from dbo.gpsdata_history_latest a " +
								"inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	
								+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id  and Status='Active' "
								+"where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= ? and b.User_id=?";
	
	
	public static final String GET_NOGPS_VEHICLES_FOR_LTSP="select count(*) as NOGPS from dbo.gpsdata_history_latest a " +
								" inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	
								+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "+
								"where a.CLIENTID=? and a.System_id=? and a.LOCATION ='No GPS Device Connected' and b.User_id=?";
	
	public static final String GET_NOGPS_VEHICLES_FOR_CLIENT="select count(*) as NOGPS from dbo.gpsdata_history_latest a " +
								" inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 
								+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id  and Status='Active' "+
								"where a.CLIENTID=? and a.System_id=? and a.LOCATION ='No GPS Device Connected' and b.User_id=?";

	public static final String GET_COMMISIONED_VEHICLE="select count(RegistrationNo) as COMMISIONED from dbo.VehicleRegistration a " +
													" inner join dbo.VEHICLE_CLIENT vc on a.SystemId=vc.SYSTEM_ID and vc.REGISTRATION_NUMBER=a.RegistrationNo "+
                                                    " where RegistrationDateTime > dateadd(year, -1, getdate()) and SystemId=? and vc.CLIENT_ID=?";

	public static final String GET_DECOMMISIONED_VEHICLE="select count(ASSET_NUMBER) as DECOMMISIONED from ADMINISTRATOR.dbo.ASSET_REGISTRATION_HISTORY "+
														" where CANCELLATION_TIME > dateadd(year, -1, getdate()) and SYSTEM_ID=? and CUSTOMER_ID=?";


	public static final String PREVENTIVE_DUE_FOR_EXPIRY="select count(*) as PREVENTIVE_DUR_FOR_EXPIRED from dbo.Exception_Analysis_Alerts where System_Id=? and Checked='N' and Client_Id=? and  upper(Description) like upper('%preventive due for expiry%') and  GMT  between  dateadd(mi,-1440,getutcdate()) and  getutcdate()";

	public static final String PREVENTIVE_DUE_FOR_EXPIRY_FROM_PREVENTIVE_EVENTS = "select count(ASSET_NUMBER) as PREVENTIVE_DUR_FOR_EXPIRED  from FMS.dbo.PREVENTIVE_EVENTS a "+
                               "inner join AMS.dbo.Vehicle_User c on c.Registration_no=a.ASSET_NUMBER collate database_default and c.System_id=a.SYSTEM_ID "+ 
                               "where System_Id=? and CUSTOMER_ID =?  AND ALERT_TYPE = 2 and c.User_id=? ";
	
	public static final String PREVENTIVE_EXPIRED="select count(*) as PREVENTIVE_EXPIRED from dbo.Exception_Analysis_Alerts where System_Id=? and Checked='N' and Client_Id=? and  upper(Description) like upper('%preventive expired%') and  GMT   between  dateadd(mi,-1440,getutcdate()) and  getutcdate()";

	//public static final String PREVENTIVE_EXPIRED_FROM_PREVENTIVE_EVENTS = "select (select count(ASSET_NUMBER) from FMS.dbo.PREVENTIVE_EVENTS a inner join AMS.dbo.Vehicle_User c on c.Registration_no=a.ASSET_NUMBER collate database_default and c.System_id=a.SYSTEM_ID  where System_Id=? and CUSTOMER_ID =? AND ALERT_TYPE = 1 and c.User_id=?  ) - (select count(ASSET_NUMBER)  from FMS.dbo.PREVENTIVE_EVENTS a inner join AMS.dbo.Vehicle_User c on c.Registration_no=a.ASSET_NUMBER collate database_default and c.System_id=a.SYSTEM_ID  where System_Id=? and  datediff(dd,getDate(),POSTPONE_DATE)>= 0   and CUSTOMER_ID = ?  AND ALERT_TYPE = 1 and c.User_id=? ) PREVENTIVE_EXPIRED";
	
	
	public static final String PREVENTIVE_EXPIRED_FROM_PREVENTIVE_EVENTS = " select (select count(ASSET_NUMBER) from FMS.dbo.PREVENTIVE_EVENTS a inner join AMS.dbo.Vehicle_User c on "
		+ " c.Registration_no=a.ASSET_NUMBER collate database_default and c.System_id=a.SYSTEM_ID  where System_Id=? and "
		+ " CUSTOMER_ID =? AND ALERT_TYPE = 1 and c.User_id=? and EVENT_DATE between (select convert(varchar(10),DATEADD (DAY,-90,convert(varchar(10), getdate(), 120)),120)) "
		+ " and (select convert(varchar(10), getdate(), 120))) "
		+ " - (select count(ASSET_NUMBER) from FMS.dbo.PREVENTIVE_EVENTS a inner join AMS.dbo.Vehicle_User c on c.Registration_no=a.ASSET_NUMBER " 
		+ " collate database_default and c.System_id=a.SYSTEM_ID  where System_Id=? and datediff(dd,getDate(),POSTPONE_DATE)>= 0 "   
		+ " and CUSTOMER_ID = ? AND ALERT_TYPE = 1 and c.User_id=? and EVENT_DATE between (select convert(varchar(10),DATEADD (DAY,-90,convert(varchar(10), getdate(), 120)),120)) "
		+ " and (select convert(varchar(10), getdate(), 120))) "
		+ " PREVENTIVE_EXPIRED ";
	
	public static final String GET_VEHICLE_LIVE_STATUS_FOR_LTSP="select SUM(CASE when (a.CATEGORY='stoppage') THEN 1 ELSE 0 END) as STOPPED_COUNT,SUM(CASE when a.CATEGORY='idle' THEN 1 ELSE 0 END) as IDLE,SUM(CASE when a.CATEGORY='running' THEN 1 ELSE 0 END) as RUNNING from dbo.gpsdata_history_latest a with (NOLOCK) " +
	                           " inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " +
	                           "inner  join  tblVehicleMaster c on b.System_id=c.System_id and c.VehicleNo=b.Registration_no "+
			                   "where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and  DATEDIFF(hh,a.GMT,getutcdate()) < 6 and b.User_id=? ";
	
	public static final String GET_VEHICLE_LIVE_STATUS_FOR_CLIENT="select SUM(CASE when (a.CATEGORY='stoppage') THEN 1 ELSE 0 END) as STOPPED_COUNT,SUM(CASE when a.CATEGORY='idle' THEN 1 ELSE 0 END) as IDLE,SUM(CASE when a.CATEGORY='running' THEN 1 ELSE 0 END) as RUNNING from dbo.gpsdata_history_latest a with (NOLOCK) " +
							    " inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " +
							    "inner  join  tblVehicleMaster c on b.System_id=c.System_id and c.VehicleNo=b.Registration_no and c.Status='Active' "+
							    "where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and  DATEDIFF(hh,a.GMT,getutcdate()) < 6 and b.User_id=? ";
	
	public static final String GET_ALERT_DETAILS="select a.SLNO as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,dateadd(mi,?,a.GMT) as [ALERT_DATE],a.LOCATION,a.STOP_HOURS as [STOPPAGE TIME],ISNULL(a.TRIP_NAME,'') as [TRIP NAME], "+
												 "isnull(a.MONITOR_STATUS,'') as REMARKS,a.LONGITUDE as LONGITUDE,a.LATITUDE as LATITUDE,a.ACTION_TAKEN as [ACTION TAKEN],a.UPDATED_BY as [USER NAME],a.SPEED as OVERSPEED,a.TYPE_OF_ALERT,'Alert' as Type,'' as [ALERT NAME],'' as SPEED,  "+ 
												 "isNull(a.OVERDUE_AMT,0) as [DRIVER NAME],'' as OVERSPEEDLIMIT,'' as [IDLE TIME],'' as STATUS,'' as ACCELERATION,'' as DEACCELERATION,'' as [DISTANCE DEVIATED],'' as [DETENTION TIME],'' as DELAY,'' as [Generator Status],'' as [Total Run Hrs],'' as [DUE DATE],c.GROUP_NAME as GROUP_NAME,vm.VehicleAlias as [VEHICLE ID]  "+ 
												 "from dbo.Alert a inner join VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID   "+
												 "left outer join tblVehicleMaster vm on b.REGISTRATION_NUMBER = vm.VehicleNo   "+
												 "where a.TYPE_OF_ALERT=? and GMT>dateadd(mi,-?,getutcdate()) and a.CLIENTID=?  and b.SYSTEM_ID=? and  a.ISREDALERT<>'Y'";
	
	public static final String GET_DETENTION_ALERT_DETAILS="select a.SLNO as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,dateadd(mi,?,a.GMT) as [ALERT_DATE],a.LOCATION,a.STOP_HOURS as [STOPPAGE TIME],ISNULL(a.TRIP_NAME,'') as [TRIP NAME], "+
	 "isnull(a.MONITOR_STATUS,'') as REMARKS,a.LONGITUDE as LONGITUDE,a.LATITUDE as LATITUDE,a.ACTION_TAKEN as [ACTION TAKEN],a.UPDATED_BY as [USER NAME],a.SPEED as OVERSPEED,a.TYPE_OF_ALERT,'Alert' as Type,'' as [ALERT NAME],'' as SPEED,  "+ 
	 "isNull(a.OVERDUE_AMT,0) as [DRIVER NAME],'' as OVERSPEEDLIMIT,'' as [IDLE TIME],'' as STATUS,'' as ACCELERATION,'' as DEACCELERATION,'' as [DISTANCE DEVIATED],'' as [DETENTION TIME],'' as DELAY,'' as [Generator Status],'' as [Total Run Hrs],'' as [DUE DATE],c.GROUP_NAME as GROUP_NAME,vm.VehicleAlias as [VEHICLE ID]  "+ 
	 "from dbo.Alert a inner join VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID   "+
	 "left outer join tblVehicleMaster vm on b.REGISTRATION_NUMBER = vm.VehicleNo   "+
	 "where a.TYPE_OF_ALERT=?  and a.CLIENTID=?  and b.SYSTEM_ID=? and  a.ISREDALERT<>'Y' and GMT>dateadd(hh,-48,getutcdate())";
	
	
	public static final String GET_PARKING_ALERT_DETAILS="select a.SLNO as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,dateadd(mi,?,a.GMT) as [ALERT_DATE],a.LOCATION,a.STOP_HOURS as [STOPPAGE TIME],ISNULL(a.TRIP_NAME,'') as [TRIP NAME], "+
	 "isnull(a.MONITOR_STATUS,'') as REMARKS,a.LONGITUDE as LONGITUDE,a.LATITUDE as LATITUDE,a.ACTION_TAKEN as [ACTION TAKEN],a.UPDATED_BY as [USER NAME],a.SPEED as OVERSPEED,a.TYPE_OF_ALERT,'Alert' as Type,'' as [ALERT NAME],'' as SPEED,  "+ 
	 "isNull(a.OVERDUE_AMT,0) as [DRIVER NAME],'' as OVERSPEEDLIMIT,'' as [IDLE TIME],'' as STATUS,'' as ACCELERATION,'' as DEACCELERATION,'' as [DISTANCE DEVIATED],'' as [DETENTION TIME],'' as DELAY,'' as [Generator Status],'' as [Total Run Hrs],'' as [DUE DATE],c.GROUP_NAME as GROUP_NAME,vm.VehicleAlias as [VEHICLE ID]  "+ 
	 "from dbo.Alert a inner join VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID   "+
	 "left outer join tblVehicleMaster vm on b.REGISTRATION_NUMBER = vm.VehicleNo   "+
	 "where a.TYPE_OF_ALERT=? and GMT>dateadd(mi,-?,getutcdate()) and a.CLIENTID=?  and b.SYSTEM_ID=? and  a.ISREDALERT<>'Y'";

	public static final String SAVE_ALERT_REMARK="update dbo.Alert set MONITOR_STATUS=? where convert(varchar,GMT,20) = ? and REGISTRATION_NO=? and TYPE_OF_ALERT=? and CLIENTID=? and SYSTEM_ID=?";
	
	public static final String SAVE_STATUTORY_REMARKS="update dbo.StatutoryAlert set MONITOR_STATUS=? where Slno=?  and ClientId=? and SystemId=?";
	
	public static final String SAVE_OVERSPEED_REMARKS="update ALERT.dbo.OVER_SPEED_DATA set REMARK=? where ID=? and REGISTRATION_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String SAVE_PREVENTIVE_REMARKS="update dbo.Exception_Analysis_Alerts set Remarks=? where Exception_Id=? and Registration_No=? and Client_Id=? and System_Id=?";
	
	public static final String GET_OVER_SPEED_ALERT="select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,a.GPS_DATETIME,dateadd(mi,?,a.GMT) as [ALERT_DATE],a.LOCATION,a.SPEED as SPEED,'' as [TRIP NAME], " +
													"isNull(a.DRIVER_ID,0) as [DRIVER NAME],isnull(a.REMARK,'') as REMARKS,a.LONGITUDE as LONGITUDE,a.LATITUDE as LATITUDE,'' as [ACTION TAKEN],a.UPDATED_BY as [USER NAME],a.SPEED as OVERSPEED,2 as TYPE_OF_ALERT,'Alert' as Type,'' as [STOPPAGE TIME],'' as [ALERT NAME], " + 
													"'' as [IDLE TIME],'' as STATUS,'' as ACCELERATION,'' as DEACCELERATION,'' as [DISTANCE DEVIATED],'' as [DETENTION TIME],'' as DELAY,'' as [Generator Status],'' as [Total Run Hrs],'' as [DUE DATE],  " +
													"case when ((vm.OverSpeedLimitforGR is null) or (vm.OverSpeedLimit is not null and vm.OverSpeedLimit<vm.OverSpeedLimitforGR)) then isnull(vm.OverSpeedLimit,0) else isnull(vm.OverSpeedLimitforGR,0) end as OVERSPEEDLIMIT,c.GROUP_NAME as GROUP_NAME,vm.VehicleAlias as [VEHICLE ID]  " +
													"from ALERT.dbo.OVER_SPEED_DATA a inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default " +
													"left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID  " +
													"left outer join tblVehicleMaster vm on  a.REGISTRATION_NO = vm.VehicleNo collate database_default " +
													"where GMT>dateadd(mi,-?,getutcdate()) and a.CUSTOMER_ID=?  and b.SYSTEM_ID=? ";
	
	public static final String GET_DISTRESS_ALERT="select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,a.GPS_DATETIME,dateadd(mi,?,a.GMT) as [ALERT_DATE],a.LOCATION,a.SPEED as SPEED,isnull(a.REMARK,'') as REMARKS,isNull(a.DRIVER_ID,0) as [DRIVER NAME],a.SPEED as OVERSPEED," +
													"a.TYPE_OF_ALERT as TYPE_OF_ALERT,c.GROUP_NAME as GROUP_NAME,vm.VehicleAlias as [VEHICLE ID]  from ALERT.dbo.PANIC_DATA a " +
													"inner join VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO collate database_default " +
													"left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID " +
													"left outer join tblVehicleMaster vm on b.REGISTRATION_NUMBER = vm.VehicleNo collate database_default " +
													"where a.TYPE_OF_ALERT=?  and a.CUSTOMER_ID=?  and b.SYSTEM_ID=? and a.GMT>dateadd(hh,-48,getutcdate()) ";
	
	/*public static final String GET_STATUTORY_ALERT_DETAILS="Select Slno as SLNO,a.VehicleNo as REGISTRATION_NO ,v2.GROUP_NAME as GROUP_NAME,a.AlertId as TYPE_OF_ALERT,a.AlertStartDate ,a.UpdatedDate,dateadd(mi,?,a.DueDate) as ALERT_DATE,a.ClientId,a.SystemId,isNull(a.DriverId ,'0') as [DRIVER NAME],a.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION from dbo.StatutoryAlert a WITH(NOLOCK) "+       
														   "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo left "+         
														   "outer join dbo.VEHICLE_GROUP v2 on v1.GROUP_ID= v2.GROUP_ID  "+        
														   "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId "+  
														   "inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on  a.ClientId= ag.CUSTOMER_ID and a.SystemId=ag.SYSTEM_ID and v2.GROUP_NAME collate database_default=ag.GROUP_NAME "+  
														   "where a.ClientId=? and a.SystemId=? and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and a.AlertId=?   and  "+   
														   "ag.STATE =(select STATE_CODE from ADMINISTRATOR.dbo.STATE_DETAILS where STATE_NAME=?) "+  
														   "union all   "+      
														   "Select Slno as SLNO,d.VehicleNo as REGISTRATION_NO ,v2.GROUP_NAME as GROUP_NAME,d.AlertId TYPE_OF_ALERT,d.AlertStartDate ,d.DueDate,dateadd(mi,?,d.UpdatedDate) as ALERT_DATE,d.ClientId,d.SystemId,isNull(d.DriverId ,'0') as [DRIVER NAME],d.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION from dbo.StatutoryAlertHistory d WITH(NOLOCK) "+         
														   "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=d.VehicleNo " +
														   "left outer join dbo.VEHICLE_GROUP v2 on v1.GROUP_ID= v2.GROUP_ID  "+        
														   "join dbo.Alert_Master_Details b WITH(NOLOCK) on d.AlertId=b.AlertId and  d.SystemId=b.SystemId  "+  
														   "inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on  d.ClientId= ag.CUSTOMER_ID and d.SystemId=ag.SYSTEM_ID and v2.GROUP_NAME collate database_default=ag.GROUP_NAME "+  
														   "where d.ClientId=? and  d.SystemId=?  and d.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and d.AlertId=? and ag.STATE =(select STATE_CODE from ADMINISTRATOR.dbo.STATE_DETAILS where STATE_NAME=?) order by ALERT_DATE desc ";
	*/
	
	public static final String GET_STATUTORY_ALERT_DETAILS="Select Slno as SLNO,a.VehicleNo as REGISTRATION_NO ,v2.GROUP_NAME as GROUP_NAME,a.AlertId as TYPE_OF_ALERT,a.AlertStartDate ,a.UpdatedDate,dateadd(mi,?,a.DueDate) as ALERT_DATE,a.ClientId,a.SystemId,isNull(a.DriverId ,'0') as [DRIVER NAME],a.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION from dbo.StatutoryAlert a WITH(NOLOCK) "+       
														   "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo left "+         
														   "outer join dbo.VEHICLE_GROUP v2 on v1.GROUP_ID= v2.GROUP_ID  "+        
														   "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId "+  
														   "inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on  a.ClientId= ag.CUSTOMER_ID and a.SystemId=ag.SYSTEM_ID and v2.GROUP_NAME collate database_default=ag.GROUP_NAME "+  
														   "where a.ClientId=? and a.SystemId=? and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and a.AlertId=?   and  "+   
														   "ag.STATE =(select STATE_CODE from ADMINISTRATOR.dbo.STATE_DETAILS where STATE_NAME=?) ";
	  
	public static final String GET_STATUTORY_ALERT_DETAILS_NEW="Select Slno as SLNO,a.VehicleNo as REGISTRATION_NO ,v2.GROUP_NAME as GROUP_NAME,a.AlertId as TYPE_OF_ALERT,a.AlertStartDate ,a.UpdatedDate,dateadd(mi,?,a.DueDate) as ALERT_DATE,a.ClientId,a.SystemId,isNull(a.DriverId ,'0') as [DRIVER NAME],a.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION from dbo.StatutoryAlert a WITH(NOLOCK) "+       
	   "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo left "+         
	   "outer join dbo.VEHICLE_GROUP v2 on v1.GROUP_ID= v2.GROUP_ID  "+        
	   "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId "+  
	   "inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on  a.ClientId= ag.CUSTOMER_ID and a.SystemId=ag.SYSTEM_ID and v2.GROUP_NAME collate database_default=ag.GROUP_NAME "+  
	   "where a.ClientId=? and a.SystemId=? and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and a.AlertId=?   and  "+   
	   "ag.STATE =(select STATE_CODE from ADMINISTRATOR.dbo.STATE_DETAILS where STATE_NAME=?)" +
	   " and VehicleNo in ( select Registration_no from  AMS.dbo.Vehicle_User  where System_id = ? and User_id = ? ) ";
	
	public static final String PREVENTIVE_DETAILS="select Exception_Id as SLNO,Registration_No as REGISTRATION_NO,dateadd(mi,?,GMT) as ALERT_DATE,Location as LOCATION,isnull(Remarks,'') as REMARKS,isnull(Driver_Name,0) as[DRIVER NAME],''as SPEED,'' as TYPE_OF_ALERT,'' as GROUP_NAME  from dbo.Exception_Analysis_Alerts where System_Id=? and Checked='N' and Client_Id=? and   GMT   between  dateadd(mi,-?,getutcdate()) and  getutcdate() and  (upper(Description) like upper('%preventive expired%') or  upper(Description) like upper('%preventive due for expiry%'))";
	
	public static final String GET_STOPPAGE_ALERT_DETAILS="select SLNO,REGISTRATION_NO,v2.GROUP_NAME as GROUP_NAME,LOCATION,(cast(STOP_HOURS as numeric(18,2))*60)as SPEED,dateadd(mi,?,GMT) as ALERT_DATE,MONITOR_STATUS,TYPE_OF_ALERT,LONGITUDE,LATITUDE,isnull(a.MONITOR_STATUS,'') as REMARKS,isNull(OVERDUE_AMT ,'0') as [DRIVER NAME] " +  
														  "from Alert a WITH(NOLOCK) " +  
														  "inner join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.REGISTRATION_NO left   " + 
														  "outer join dbo.VEHICLE_GROUP v2 on v1.GROUP_ID= v2.GROUP_ID where  " +  
														  "a.TYPE_OF_ALERT=? and a.ISREDALERT<>'Y' and a.GMT>dateadd(mi,-?,getutcdate()) and a.CLIENTID=? and a.SYSTEM_ID=?";
	
	public static final String GET_STOPPAGE_ALERT_DETAILS_COUNT="select count(*) as COUNT from Alert a WITH(NOLOCK) " +  
																"inner join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.REGISTRATION_NO left   " + 
																"outer join dbo.VEHICLE_GROUP v2 on v1.GROUP_ID= v2.GROUP_ID where  " +  
																"a.TYPE_OF_ALERT=? and a.ISREDALERT<>'Y' and a.GMT>dateadd(mi,-?,getutcdate()) and a.CLIENTID=? and a.SYSTEM_ID=?";
	
	public static final String GET_IDLE_ALERT_DETAILS="select SLNO,REGISTRATION_NO,v2.GROUP_NAME as GROUP_NAME,LOCATION,(cast(STOP_HOURS as numeric(18,2))*60)as SPEED,dateadd(mi,?,GMT) as ALERT_DATE,MONITOR_STATUS,TYPE_OF_ALERT,LONGITUDE,LATITUDE,isnull(a.MONITOR_STATUS,'') as REMARKS,isNull(OVERDUE_AMT ,'0') as [DRIVER NAME] " +  
													  "from Alert a WITH(NOLOCK) " +  
													  "inner join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.REGISTRATION_NO left   " + 
													  "outer join dbo.VEHICLE_GROUP v2 on v1.GROUP_ID= v2.GROUP_ID where  " +  
													  "a.TYPE_OF_ALERT=? and a.ISREDALERT<>'Y' and a.GMT>dateadd(mi,-?,getutcdate()) and a.CLIENTID=? and a.SYSTEM_ID=?  and  cast(STOP_HOURS as numeric(18,2))> 0.166 ";
	
	public static final String GET_IDLE_ALERT_DETAILS_COUNT="select count(*) as COUNT from Alert a WITH(NOLOCK) " +  
															"inner join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.REGISTRATION_NO left   " + 
															"outer join dbo.VEHICLE_GROUP v2 on v1.GROUP_ID= v2.GROUP_ID where  " +  
															"a.TYPE_OF_ALERT=? and a.ISREDALERT<>'Y' and a.GMT>dateadd(mi,-?,getutcdate()) and a.CLIENTID=? and a.SYSTEM_ID=?  and  cast(STOP_HOURS as numeric(18,2))> 0.166 ";
	
	
	/*public static final String GET_STATUTORY_STATEWISE_COUNT="select R.STATE_NAME,SUM(R.STATUTORY_COUNT) as STATUTORY_COUNT  from( select isnull(s.STATE_NAME,'Other') as STATE_NAME,COUNT(*) AS STATUTORY_COUNT from dbo.StatutoryAlert a WITH(NOLOCK) " +         
															 "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo " + 
															 "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a1 on v1.GROUP_ID= a1.GROUP_ID  " + 
															 "left outer join ADMINISTRATOR.dbo.STATE_DETAILS s on a1.STATE=s.STATE_CODE  " +     
															 "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId where a.AlertId=? and a.ClientId=?  and a.SystemId=?  and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))   group by s.STATE_NAME  " +  
															 "union all  " +      
															 "select isnull(s.STATE_NAME,'Other') as STATE_NAME,COUNT(*) AS STATUTORY_COUNT from dbo.StatutoryAlertHistory d WITH(NOLOCK)   " +     
															 "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=d.VehicleNo " + 
															 "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a2 on v1.GROUP_ID= a2.GROUP_ID " + 
															 "left outer join ADMINISTRATOR.dbo.STATE_DETAILS s on a2.STATE=s.STATE_CODE " + 
															 "join dbo.Alert_Master_Details b WITH(NOLOCK) on d.AlertId=b.AlertId and  d.SystemId=b.SystemId where  d.AlertId=? and d.ClientId=?   and d.SystemId=? " +  
															 "and d.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))  group by s.STATE_NAME) R group by R.STATE_NAME ";
	*/
	public static final String GET_STATUTORY_STATEWISE_COUNT = "select isnull(s.STATE_NAME,'Other') as STATE_NAME,COUNT(*) AS STATUTORY_COUNT from dbo.StatutoryAlert a WITH(NOLOCK) " +         
																 "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo " + 
																 "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a1 on v1.GROUP_ID= a1.GROUP_ID  " + 
																 "left outer join ADMINISTRATOR.dbo.STATE_DETAILS s on a1.STATE=s.STATE_CODE  " +     
																 "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId where a.AlertId=? and a.ClientId=?  and a.SystemId=?  and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))   group by s.STATE_NAME  ";
	
	public static final String GET_STATUTORY_STATEWISE_COUNT_NEW = "select isnull(s.STATE_NAME,'Other') as STATE_NAME,COUNT(*) AS STATUTORY_COUNT from dbo.StatutoryAlert a WITH(NOLOCK) " +         
	 "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo " + 
	 "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a1 on v1.GROUP_ID= a1.GROUP_ID  " + 
	 "left outer join ADMINISTRATOR.dbo.STATE_DETAILS s on a1.STATE=s.STATE_CODE  " +     
	 "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId where a.AlertId =? and a.ClientId=?  and a.SystemId=?  and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))  and VehicleNo in ( select Registration_no from  AMS.dbo.Vehicle_User  where System_id = ? and User_id = ? )   group by s.STATE_NAME  ";
	
	/*public static final String GET_STATUTORRY_STATEWISE_DETAILS_OTHERS="select Slno as SLNO,a.VehicleNo as REGISTRATION_NO ,a1.GROUP_NAME as GROUP_NAME,a.AlertId as TYPE_OF_ALERT,a.AlertStartDate ,a.UpdatedDate,dateadd(mi,?,a.DueDate) as ALERT_DATE,a.ClientId,a.SystemId,isNull(a.DriverId ,'0') as [DRIVER NAME],a.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION from dbo.StatutoryAlert a WITH(NOLOCK)  "+           
																	   "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo "+     
																	   "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a1 on v1.GROUP_ID= a1.GROUP_ID   "+    
																	   "left outer join ADMINISTRATOR.dbo.STATE_DETAILS s on a1.STATE=s.STATE_CODE  "+         
																	   "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId where  a.ClientId=?  and a.SystemId=?  and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))  and a.AlertId=? and s.STATE_NAME is null "+ 															  
																	   "union all  "+          
																	   "select  Slno as SLNO,d.VehicleNo as REGISTRATION_NO ,a2.GROUP_NAME as GROUP_NAME,d.AlertId as TYPE_OF_ALERT,d.AlertStartDate ,d.UpdatedDate,dateadd(mi,?,d.DueDate) as ALERT_DATE,d.ClientId,d.SystemId,isNull(d.DriverId ,'0') as [DRIVER NAME],d.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION  from dbo.StatutoryAlertHistory d WITH(NOLOCK) "+           
																	   "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=d.VehicleNo  "+    
																	   "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a2 on v1.GROUP_ID= a2.GROUP_ID    "+  
																	   "left outer join ADMINISTRATOR.dbo.STATE_DETAILS s on a2.STATE=s.STATE_CODE   "+   
																	   "join dbo.Alert_Master_Details b WITH(NOLOCK) on d.AlertId=b.AlertId and  d.SystemId=b.SystemId where   d.ClientId=?   and d.SystemId=?  and d.UpdatedDate >  dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and d.AlertId=? and s.STATE_NAME is null ";
	*/
	public static final String GET_STATUTORRY_STATEWISE_DETAILS_OTHERS = "select Slno as SLNO,a.VehicleNo as REGISTRATION_NO ,a1.GROUP_NAME as GROUP_NAME,a.AlertId as TYPE_OF_ALERT,a.AlertStartDate ,a.UpdatedDate,dateadd(mi,?,a.DueDate) as ALERT_DATE,a.ClientId,a.SystemId,isNull(a.DriverId ,'0') as [DRIVER NAME],a.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION from dbo.StatutoryAlert a WITH(NOLOCK)  "+           
																		   "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo "+     
																		   "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a1 on v1.GROUP_ID= a1.GROUP_ID   "+    
																		   "left outer join ADMINISTRATOR.dbo.STATE_DETAILS s on a1.STATE=s.STATE_CODE  "+         
																		   "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId where  a.ClientId=?  and a.SystemId=?  and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))  and a.AlertId=? and s.STATE_NAME is null ";
	
	public static final String GET_STATUTORRY_STATEWISE_DETAILS_OTHERS_NEW = "select Slno as SLNO,a.VehicleNo as REGISTRATION_NO ,a1.GROUP_NAME as GROUP_NAME,a.AlertId as TYPE_OF_ALERT,a.AlertStartDate ,a.UpdatedDate,dateadd(mi,?,a.DueDate) as ALERT_DATE,a.ClientId,a.SystemId,isNull(a.DriverId ,'0') as [DRIVER NAME],a.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION from dbo.StatutoryAlert a WITH(NOLOCK)  "+           
	   "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo "+     
	   "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a1 on v1.GROUP_ID= a1.GROUP_ID   "+    
	   "left outer join ADMINISTRATOR.dbo.STATE_DETAILS s on a1.STATE=s.STATE_CODE  "+         
	   "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId where  a.ClientId=?  and a.SystemId=?  and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))  and a.AlertId=? and s.STATE_NAME is null" +
	   " and VehicleNo in ( select Registration_no from  AMS.dbo.Vehicle_User  where System_id = ? and User_id = ? ) ";
	
	public static final String GET_REGION="select distinct (isnull(REGION,'')) as RegionName from AMS.dbo.CVS_BUSINESS_DETAILS  where SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String GET_LOCATION="select distinct (isnull(LOCATION,'')) as LocationName from AMS.dbo.CVS_BUSINESS_DETAILS  where SYSTEM_ID=? and CUSTOMER_ID=? and REGION=?";

	public static final String GET_HUB="select distinct (isnull(HUB_LOCATION,'')) as HubName from AMS.dbo.CVS_BUSINESS_DETAILS  where SYSTEM_ID=? and CUSTOMER_ID=? and REGION=? and LOCATION=?";
	
	public static final String GET_ROUTE="select distinct (isnull(b.ROUTE_NAME,'')) as RouteName , (isnull(b.ID,0)) as RouteId from AMS.dbo.CVS_BUSINESS_DETAILS a "
		+ "inner join AMS.dbo.CVS_ROUTE_DETAILS b on b.SYSTEM_ID=a.SYSTEM_ID and b.CUSTOMER_ID=a.CUSTOMER_ID and a.ROUTE_ID=b.ID "
		+ " where a.STATUS='Active' and a.SYSTEM_ID=? and b.CUSTOMER_ID=? ";
				
    //public static final String GET_ATMS="select distinct (isnull(BANK,'')) as AtmName,isnull(BUSINESS_ID,'') as AtmId,(isnull(BUSINESS_TYPE,'')) as Customer from AMS.dbo.CVS_BUSINESS_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_NAME=? ";
	public static final String GET_ATMS = " select c.ID,a.CUSTOMER_TYPE as TripType,c.BUSINESS_ID as BusinessId ,b.CustomerName as Customer,d.CustomerName  as onAccOf "+
                                          " from AMS.dbo.CASH_DESPENSE_DETAILS a inner join LMS.dbo.Customer_Information b  on a.CVS_CUSTOMER_ID = b.CustomerId " +
                                          " inner join AMS.dbo.CVS_BUSINESS_DETAILS c on  a.BUSINESS_ID = c.ID  "+
                                          " left outer join LMS.dbo.Customer_Information d  on a.ON_ACC_OF = d.CustomerId "+
                                          " where a.SYSTEM_ID =? and a.CUSTOMER_ID =? and a.TRIP_SHEET_NO = ? ";
    
	public static final String GET_VEHICLE_NOS=" select REGISTRATION_NUMBER as VehicleNo from AMS.dbo.tblVehicleMaster tb "+
		" inner join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id " +
		" inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id " +
		" where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and " +
		" REGISTRATION_NUMBER collate database_default not in " +
		" (select ASSET_NUMBER from AMS.dbo.TRIP_PLANNER where SYSTEM_ID=? and CUSTOMER_ID=? and " +
		" ( getdate() between CONVERT(varchar(10),dateadd(mi,?,CREATED_DATE),120) and CONVERT(varchar(10),dateadd(mi,?,TRIP_CLOSED_DATETIME),120) or STATUS in ('Open' , 'On Trip' , 'Armory Closed')))" +
		" order by REGISTRATION_NUMBER ";

    public static final String GET_CUSTODIAN_NAME_FROM_BUSINESS_DETAILS="select distinct isnull(EMP_NAME,'') as CustodianName from AMS.dbo.CVS_BUSINESS_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_NAME=?";
    
    public static final String GET_CUSTODIAN_NAME = " select distinct (isnull(Fullname,'')+' '+isnull(LastName,'')) as Fullname,Driver_id ,PREFERED_COMPANY as preferedCompany " +
    		" from AMS.dbo.Driver_Master " +
    		" where EmploymentType=? and Client_id=? and System_id=? and Race<>'Inactive' and Driver_id not in " +
    		" (select CUSTODIAN_NAME1 from AMS.dbo.TRIP_PLANNER where SYSTEM_ID=? and CUSTOMER_ID=? and" +
    		" ( getdate() between CONVERT(varchar(10),dateadd(mi,?,CREATED_DATE),120) and CONVERT(varchar(10),dateadd(mi,?,TRIP_CLOSED_DATETIME),120) or STATUS in ('Open' , 'On Trip' , 'Armory Closed')))" +
    		" and Driver_id not in " +
    		" (select CUSTODIAN_NAME2 from AMS.dbo.TRIP_PLANNER where SYSTEM_ID=? and CUSTOMER_ID=? and " +
    		" ( getdate() between CONVERT(varchar(10),dateadd(mi,?,CREATED_DATE),120) and CONVERT(varchar(10),dateadd(mi,?,TRIP_CLOSED_DATETIME),120) or STATUS in ('Open' , 'On Trip' , 'Armory Closed')))";

    public static final String GET_DRIVER_NAMES1="Select (isnull(a.Fullname,'')) as DriverName,Driver_id as DriverId from AMS.dbo.Driver_Master a "+
										  "where Client_id=? and System_id=? and Employment_Type='1' and Race<>'Inactive' ";
    
    public static final String GET_DRIVER_NAMES="Select (isnull(Fullname,'')+' '+isnull(LastName,'')) as DriverName,Driver_id as DriverId " +
    		" from AMS.dbo.Driver_Master  " +
    		" where Client_id=? and System_id=? and EmploymentType=? and  Race<>'Inactive' and Driver_id not in " +
    		" (select DRIVER_ID from AMS.dbo.TRIP_PLANNER where SYSTEM_ID=? and CUSTOMER_ID=? and " +
    		" ( getdate() between CONVERT(varchar(10),dateadd(mi,?,CREATED_DATE),120) and CONVERT(varchar(10),dateadd(mi,?,TRIP_CLOSED_DATETIME),120) or STATUS in ('Open' , 'On Trip' , 'Armory Closed'))) ";

    
    public static final String GET_GUNMAN1="Select (isnull(a.Fullname,'')) as Fullname,Driver_id as GunmanId from AMS.dbo.Driver_Master a "+
    										"where Client_id=? and System_id=? and Employment_Type='2'";
    
    public static final String GET_GUNMAN="Select distinct (isnull(Fullname,'')+' '+isnull(LastName,'')) as Fullname,Driver_id as GunmanId " +
    		" from AMS.dbo.Driver_Master  " +
    		" where EmploymentType=? and Client_id=? and System_id=? and Race<>'Inactive' and Driver_id not in " +
    		" (select GUNMAN1 from AMS.dbo.TRIP_PLANNER where SYSTEM_ID=? and CUSTOMER_ID=? and" +
    		" ( getdate() between CONVERT(varchar(10),dateadd(mi,?,CREATED_DATE),120) and CONVERT(varchar(10),dateadd(mi,?,TRIP_CLOSED_DATETIME),120) or STATUS in ('Open' , 'On Trip' , 'Armory Closed')))" +
    		" and Driver_id not in " +
    		" (select GUNMAN2 from AMS.dbo.TRIP_PLANNER where SYSTEM_ID=? and CUSTOMER_ID=? and " +
    		" ( getdate() between CONVERT(varchar(10),dateadd(mi,?,CREATED_DATE),120) and CONVERT(varchar(10),dateadd(mi,?,TRIP_CLOSED_DATETIME),120) or STATUS in ('Open' , 'On Trip' , 'Armory Closed')))";
    
    public static final String SELECT_MAX_TRIP_ID="select MAX(TRIP_ID) from AMS.dbo.TRIP_PLANNER where SYSTEM_ID=? and CUSTOMER_ID=?";
    
    public static final String INSERT_TRIPPLANNER_INFORMATION="INSERT INTO AMS.dbo.TRIP_PLANNER (REGION,LOCATION,HUB,ROUTE_NAME,ASSET_NUMBER,"
    															+ "DRIVER_ID,GUNMAN1,GUNMAN2,CREATED_BY,CREATED_DATE,TRIP_ID,SYSTEM_ID,CUSTOMER_ID,STATUS,CUSTODIAN_NAME1,CUSTODIAN_NAME2,OPENING_ODOMETER,a.TRIP_START_DATETIME,TRIP_SHEET_NO,ROUTE_ID)"
    															+ "VALUES(?,?,?,?,?,?,?,?,?,getUtcDate(),?,?,?,'Open',?,?,?,dateadd(mi,-?,?),?,?)";
    
    public static final String GET_TRIPPLAN_REPORT=" SELECT a.TRIP_SHEET_NO,isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as Location,isnull(a.HUB,'') as Hub,isnull(a.ROUTE_NAME,'') as RouteName,a.ROUTE_ID,isnull(a.STATUS,'') as Status, "
    	+ " dateadd(mi,?,a.CREATED_DATE) as StartDate,dateadd(mi,?,a.TRIP_CLOSED_DATETIME) as ClosedDate, "
    	+ " isnull(a.CUSTODIAN_NAME1,'') as CustodianName1,(isnull(g.Fullname,'')+' '+isnull(g.LastName,'')) as CustodianName2,isnull(dateadd(mi,?,a.TRIP_START_DATETIME),'') as TripCreationDate,isnull(a.OPENING_ODOMETER,0) as OpeningOdometer,isnull(a.CLOSING_ODOMETER,0) as ClosingOdometer, " 
    	+ " isnull(a.ASSET_NUMBER,'') as VehicleNo,(isnull(d.Fullname,'')+' '+isnull(d.LastName,'')) as DriverName, "
    	+ " (isnull(e.Fullname,'')+' '+isnull(e.LastName,'')) as Gunman1,(isnull(f.Fullname,'')+' '+isnull(f.LastName,'')) as Gunman2,a.UNIQUE_ID as UniqueId, "
    	+ " (isnull(b.NAME,'')+'-'+isnull(CAST(a.TRIP_ID as varchar(15)),'')) as TripNo FROM AMS.dbo.TRIP_PLANNER a "
    	+ " inner join AMS.dbo.Driver_Master d on d.Driver_id=a.DRIVER_ID and d.System_id=a.SYSTEM_ID and d.Client_id=a.CUSTOMER_ID and d.EmploymentType=1 "
    	+ " left outer join AMS.dbo.Driver_Master e on e.Driver_id=a.GUNMAN1 and e.System_id=a.SYSTEM_ID and e.Client_id=a.CUSTOMER_ID and e.EmploymentType=2 "
    	+ " left outer join AMS.dbo.Driver_Master f on f.Driver_id=a.GUNMAN2 and f.System_id=a.SYSTEM_ID and f.Client_id=a.CUSTOMER_ID and f.EmploymentType=2 " 
    	+ " left outer join AMS.dbo.Driver_Master g on g.Driver_id=a.CUSTODIAN_NAME2 and g.System_id=a.SYSTEM_ID and g.Client_id=a.CUSTOMER_ID and g.EmploymentType=8  "
    	+ " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID "
    	+ " where a.SYSTEM_ID = ? and a.CUSTOMER_ID= ? and a.STATUS<>'Closed' order by a.STATUS desc , a.TRIP_START_DATETIME desc";


    public static final String MODIFY_TRIPPLANNER_INFORMATION="UPDATE AMS.dbo.TRIP_PLANNER SET REGION = ?,LOCATION = ?,HUB = ?,ROUTE_NAME = ?,CUSTODIAN_NAME1 =?,ASSET_NUMBER = ?,"+
    														 "DRIVER_NAME = ?,GUNMAN1 = ?,GUNMAN2 = ?,UPDATED_BY = ?,UPDATED_DATE = getutcdate(),TRIP_ID = ?,SYSTEM_ID = ?,CUSTOMER_ID =? "+
    														 "WHERE SYSTEM_ID = ? and CUSTOMER_ID = ? and UNIQUE_ID=?";
    
    public static final String INSERT_TRIP_HUB_PLANNER="INSERT INTO AMS.dbo.TRIP_TRANSIT_POINTS(TRIP_ID,ATM,SYSTEM_ID,CUSTOMER_ID,CVS_CUSTOMER_NAME,ON_ACCOUNT) VALUES (?,?,?,?,?,?)";
    
    public static final String GET_TRIP_HUB_PLANNER="select ATM as Atm from AMS.dbo.TRIP_TRANSIT_POINTS where TRIP_ID=? and SYSTEM_ID = ? and CUSTOMER_ID = ?";
    
    public static final String CHECK_ATM_PRESENT="select * from AMS.dbo.TRIP_TRANSIT_POINTS where ATM in (#) and CUSTOMER_ID=? and SYSTEM_ID=? and TRIP_ID=? ";

    public static final String MODIFY_TRIP_PLANNER_INFORMATION=" update AMS.dbo.TRIP_PLANNER set ROUTE_NAME=?,UPDATED_BY = ?,UPDATED_DATE = getutcdate() where CUSTOMER_ID=? and SYSTEM_ID=? and TRIP_ID=? and UNIQUE_ID=? ";

    public static final String DELETE_FROM_TRIP_PLANNER_HUB="delete * from AMS.dbo.TRIP_PLANNER where CUSTOMER_ID=? and SYSTEM_ID=? and TRIP_ID=?";
    
    public static final String GET_BANK="select BANK as AtmName from AMS.dbo.CVS_BUSINESS_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?  and BUSINESS_ID=?";

    public static final String INSERT_ALL_TRIP_ID_TO_PLANNER_HUB=" insert into AMS.dbo.TRIP_TRANSIT_POINTS (TRIP_ID,ATM,CUSTOMER_ID,SYSTEM_ID,CVS_CUSTOMER_NAME,ON_ACCOUNT) values(?,?,?,?,?,?) ";
    
    public static final String CHECK_PRESENT_OR_NOT=" select ATM from AMS.dbo.TRIP_TRANSIT_POINTS where ATM=? and TRIP_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? ";

    public static final String UPDATE_TRIP_CLOSED_IN_TRIP_PLANNER=" update AMS.dbo.TRIP_PLANNER set TRIP_CLOSED_HUB=?,TRIP_CLOSED_DATETIME=dateadd(mi,-?,?),CLOSED_BY=?,ACTUAL_TRIP_CLOSED_DATE_TIME=getutcdate(),STATUS='Closed' ,CLOSING_ODOMETER=?,DISTANCE_TRAVELLED=? "
    	                     + " where TRIP_ID=? and SYSTEM_ID=? and CUSTOMER_ID=? ";
    
    public static final String SELECT_ATMS=" select * from AMS.dbo.TRIP_TRANSIT_POINTS where TRIP_ID=? and SYSTEM_ID = ? and CUSTOMER_ID = ? ";
    
    public static final String DELETE_EXISTING_TRIP_ID_FROM_PLANNER="delete from AMS.dbo.TRIP_TRANSIT_POINTS where TRIP_ID=? and ATM=? and SYSTEM_ID=? and CUSTOMER_ID=?";

 /**********************************************************DASHBOARD***************************************************************************************************************************/
    
    public static final String GET_CMS_GRID_DETAILS=" select a.TRIP_SHEET_NO as TripId,isnull(a.ASSET_NUMBER,'') as assetNumber, " 
		+ " isnull(a.HUB,'') as hub,isnull(a.ROUTE_NAME,'') as routeName,isnull(a.LOCATION,'') as location, "
		+ " isnull(count(c.BUSINESS_ID),'') as pointsToVisit,dateadd(mi,?,a.CREATED_DATE) as StartDateTime,(isnull(e.Fullname,'')+' '+isnull(e.LastName,'')) as gunman1, "
		+ " (isnull(f.Fullname,'')+' '+isnull(f.LastName,'')) as Gunman2,(isnull(g.Fullname,'')+' '+isnull(g.LastName,'')) as custodianName1,(isnull(h.Fullname,'')+' '+isnull(h.LastName,'')) as custodianName2,(isnull(d.Fullname,'')+' '+isnull(d.LastName,'')) "
		+ " as driverName from AMS.dbo.TRIP_PLANNER  a "
		+ " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID "
		+ " inner join AMS.dbo.CASH_DESPENSE_DETAILS c on a.TRIP_SHEET_NO=c.TRIP_SHEET_NO and a.SYSTEM_ID=c.SYSTEM_ID and a.CUSTOMER_ID=c.CUSTOMER_ID " 
		+ " left outer join AMS.dbo.Driver_Master d on d.Driver_id=a.DRIVER_ID and d.System_id=a.SYSTEM_ID and d.Client_id=a.CUSTOMER_ID and d.EmploymentType=1 "
		+ " left outer join AMS.dbo.Driver_Master e on e.Driver_id=a.GUNMAN1 and e.System_id=a.SYSTEM_ID and e.Client_id=a.CUSTOMER_ID and e.EmploymentType=2 "
		+ " left outer join AMS.dbo.Driver_Master f on f.Driver_id=a.GUNMAN2 and f.System_id=a.SYSTEM_ID and f.Client_id=a.CUSTOMER_ID and f.EmploymentType=2 "
		+ " left outer join AMS.dbo.Driver_Master g on g.Driver_id=a.CUSTODIAN_NAME1 and g.System_id=a.SYSTEM_ID and g.Client_id=a.CUSTOMER_ID and g.EmploymentType=8"
		+ " left outer join AMS.dbo.Driver_Master h on h.Driver_id=a.CUSTODIAN_NAME2 and h.System_id=a.SYSTEM_ID and h.Client_id=a.CUSTOMER_ID and h.EmploymentType=8"
		+ " inner join ams.dbo.CVS_BUSINESS_DETAILS bd on c.BUSINESS_ID =bd.ID "
		+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS in ('Open','On Trip') group by b.NAME,a.TRIP_SHEET_NO,a.ASSET_NUMBER,a.HUB,a.ROUTE_NAME, "
		+ " a.CREATED_DATE,d.Fullname,d.LastName,e.Fullname,e.LastName,f.Fullname,f.LastName,a.LOCATION,a.DRIVER_ID,g.Fullname,g.LastName,h.Fullname,h.LastName order by a.CREATED_DATE";
	
	public static final String GET_LATLONG_FOR_CMS_DASHBOARD=" select isnull(REGISTRATION_NO,'') as registrationNumber,isnull(LONGITUDE,0) as longitude, "
		+ " isnull(LATITUDE,0) as lattitude,isnull(SPEED,'') as speed,isnull(LOCATION,'') as location,isnull(GPS_DATETIME,'') as dateTime,isnull(CATEGORY,'') as category from "  
		+ " AMS.dbo.gpsdata_history_latest "
		+ " where  REGISTRATION_NO=? and System_id=? and CLIENTID=? ";
	
	
//	public static final String GET_ATM_FROM_TRIP_HUB_PLANNER_FOR_VISITED="select ATM from AMS.dbo.TRIP_TRANSIT_POINTS where TRIP_ID= ? and SYSTEM_ID=? and CUSTOMER_ID=? and ATM_ARRIVAL_DATETIME is not null and  ATM_DEPARTURE_DATETIME is not null ";
	public static final String GET_ATM_FROM_TRIP_HUB_PLANNER_FOR_VISITED="select distinct(b.BUSINESS_ID) as ATM from AMS.dbo.CVS_BUSINESS_DETAILS b join AMS.dbo.CASH_DESPENSE_DETAILS cdd on b.ID= cdd.BUSINESS_ID where cdd.TRIP_SHEET_NO= ? and cdd.SYSTEM_ID=? and cdd.CUSTOMER_ID=? and cdd.TRIP_STATUS='COMPLETED'  and b.SYSTEM_ID=cdd.SYSTEM_ID and b.CUSTOMER_ID=cdd.CUSTOMER_ID ";

	
	public static final String GET_LATLONG_FOR_CMS_TRIP_POINTS_FROM_CVS_TRIP_DETAILS=" select isnull(LONGITUDE,'') as longitude,isnull(LATITUDE,'') as lattitude,isnull(ADDRESS,'') as hubLocation  from AMS.dbo.CVS_BUSINESS_DETAILS where BUSINESS_ID=? ";
	
	//public static final String GET_ATM_FROM_TRIP_HUB_PLANNER_FOR_PENDING="select ATM from AMS.dbo.TRIP_TRANSIT_POINTS where TRIP_ID= ? and SYSTEM_ID=? and CUSTOMER_ID=? and (ATM_ARRIVAL_DATETIME is null or  ATM_DEPARTURE_DATETIME is null) ";
	public static final String GET_ATM_FROM_TRIP_HUB_PLANNER_FOR_PENDING="select distinct(b.BUSINESS_ID) as ATM from AMS.dbo.CVS_BUSINESS_DETAILS b join AMS.dbo.CASH_DESPENSE_DETAILS cdd on b.ID= cdd.BUSINESS_ID where cdd.TRIP_SHEET_NO= ? and cdd.SYSTEM_ID=? and cdd.CUSTOMER_ID=? and cdd.TRIP_STATUS='CREATED'  and b.SYSTEM_ID=cdd.SYSTEM_ID and b.CUSTOMER_ID=cdd.CUSTOMER_ID ";
	
	public static final String INSERT_ROUTE ="insert into AMS.dbo.CVS_ROUTE_DETAILS(ROUTE_ID,ROUTE_TYPE,ROUTE_NAME,STATUS,SYSTEM_ID,CUSTOMER_ID) VALUES(?,?,?,?,?,?)";
	
	public static final String GET_ROUTE_DETAILS ="select ID as id, isnull(ROUTE_ID,'')as routeId, isnull(ROUTE_TYPE,'')as routeType,isnull(ROUTE_NAME,'')as routeName,isnull(STATUS,'Active')as status "
												+ "from AMS.dbo.CVS_ROUTE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? ";
	public static final String UPDATE_ROUTE = "update AMS.dbo.CVS_ROUTE_DETAILS set ROUTE_ID=?,ROUTE_TYPE=?,ROUTE_NAME=?,STATUS=?"
											+ " where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";
	
	public static final String  CHECK_ROUTE_ALREADY_EXIST=" select ROUTE_ID from AMS.dbo.CVS_ROUTE_DETAILS where ROUTE_ID=? AND SYSTEM_ID=? AND CUSTOMER_ID=?";
	public static final String  CHECK_ROUTENAME_IF_ALREADY_EXIST="select ROUTE_NAME from AMS.dbo.CVS_ROUTE_DETAILS where ROUTE_NAME=?  AND SYSTEM_ID=? AND CUSTOMER_ID=?";
	
	public static final String  CHECK_ROUTE_ALREADY_EXIST_FOR_MODIFY=" select ROUTE_ID from AMS.dbo.CVS_ROUTE_DETAILS where ROUTE_ID=? and ID!=? ";

	public static final String  CHECK_ROUTENAME_IF_ALREADY_EXIST_FOR_MODIFY ="select ROUTE_NAME from AMS.dbo.CVS_ROUTE_DETAILS where ROUTE_NAME=?  AND ID !=?";

	public static final String GET_VEHICLE_OFF_ROAD_DETAILS="select RegistrationNo,JobCardType,dateadd(mi,?,a.JobCardDate) as JobCardDate from FMS.dbo.JobCard_In_Mstr a "+
															"inner join dbo.Vehicle_User b on b.Registration_no collate database_default =a.RegistrationNo and b.System_id=a.SystemId "+
															"where b.User_id =? and a.JobCardStatus='Open' and a.SystemId=? and a.ClientId=? "+
															"union all "+
															"select RegistrationNo,JobCardType,dateadd(mi,?,c.JobCardDate) as JobCardDate  from FMS.dbo.JobCard_Ext_Mstr c "+
															"inner join dbo.Vehicle_User d on d.Registration_no collate database_default =c.RegistrationNo and d.System_id=c.SystemId "+
															"where d.User_id =? and c.JobCardStatus='Open' and c.SystemId=? and c.ClientId=? order by JobCardDate asc";

	public static final String GET_TRIP_SUMMARY_REPORT = " select (isnull(b.NAME,'')+'-'+isnull(CAST(a.TRIP_ID as varchar(15)),'')) as TripNo,isnull(a.ASSET_NUMBER,'') as VehicleNo," +
			                                             " isnull(a.REGION,'') as Region,isnull(a.LOCATION,'') as Location,isnull(a.HUB,'') as Hub,isnull(a.ROUTE_NAME,'')as RouteName, " +
														 " (isnull(h.Fullname,'')+' '+isnull(h.LastName,'')) as CustodianName1,(isnull(g.Fullname,'')+' '+isnull(g.LastName,'')) as CustodianName2, " +
														 " (isnull(e.Fullname,'')+' '+isnull(e.LastName,'')) as Gunman1,(isnull(f.Fullname,'')+' '+isnull(f.LastName,'')) as Gunman2, " + 
														 " (isnull(d.Fullname,'')+' '+isnull(d.LastName,'')) as DriverName, " +
														 " isnull(dateadd(mi,?,a.TRIP_CLOSED_DATETIME),'') as CloseDateTime,isnull(dateadd(mi,?,a.TRIP_START_DATETIME),'') as StartDateTime, " +
														 " isnull(datediff(mi,dateadd(mi,?,a.TRIP_START_DATETIME),dateadd(mi,?,a.TRIP_CLOSED_DATETIME)),'') as TotalTripMins, " +
														 " isnull(a.OPENING_ODOMETER,0) as OpeningOdometer,isnull(a.CLOSING_ODOMETER,0) as ClosingOdometer,isnull(a.DISTANCE_TRAVELLED,0) as TotalKms, " +
														 " (select count(isnull(TRIP_SHEET_NO,0)) from AMS.dbo.CASH_DESPENSE_DETAILS where TRIP_SHEET_NO = a.TRIP_SHEET_NO AND SYSTEM_ID=a.SYSTEM_ID and CUSTOMER_ID=a.CUSTOMER_ID) as NO_OF_POINTS_VISITED " +
														 " from AMS.dbo.TRIP_PLANNER a " +
														 " inner join AMS.dbo.Driver_Master d on d.Driver_id=a.DRIVER_ID and d.System_id=a.SYSTEM_ID and d.Client_id=a.CUSTOMER_ID and d.EmploymentType=1 " +
														 " left outer join AMS.dbo.Driver_Master e on e.Driver_id=a.GUNMAN1 and e.System_id=a.SYSTEM_ID and e.Client_id=a.CUSTOMER_ID and e.EmploymentType=2 " +
														 " left outer join AMS.dbo.Driver_Master f on f.Driver_id=a.GUNMAN2 and f.System_id=a.SYSTEM_ID and f.Client_id=a.CUSTOMER_ID and f.EmploymentType=2 " +
														 " inner join AMS.dbo.Driver_Master h on h.Driver_id=a.CUSTODIAN_NAME1 and h.System_id=a.SYSTEM_ID and h.Client_id=a.CUSTOMER_ID and h.EmploymentType=8 " + 
														 " left outer join AMS.dbo.Driver_Master g on g.Driver_id=a.CUSTODIAN_NAME2 and g.System_id=a.SYSTEM_ID and g.Client_id=a.CUSTOMER_ID and g.EmploymentType=8 " + 
														 " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
														 " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='Closed' and a.TRIP_CLOSED_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) " ;
	
	public static final String GET_TRIP_NOS =   " select (isnull(b.NAME,'')+'-'+isnull(CAST(a.TRIP_ID as varchar(15)),'')) as TripNo from AMS.dbo.TRIP_PLANNER a " +
												" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
												" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='Closed' and a.TRIP_CLOSED_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";
	
	public static final String GET_TRIP_DETAILS_REPORT = "select isnull(bd.BUSINESS_ID,'') as Business_Id,isnull(ttp.CUSTOMER_TYPE,'') as Business_Type,isnull(bd.BANK,'') as Bank, "  +  
	"(isnull(b.NAME,'')+'-'+isnull(CAST(tp.TRIP_ID as varchar(15)),'')) as TripNo,isnull(tp.ASSET_NUMBER,'') as VehicleNo, " +  
	"isnull(dateadd(mi,?,tp.TRIP_CLOSED_DATETIME),'') as CloseDateTime,isnull(dateadd(mi,?,tp.TRIP_START_DATETIME),'') as StartDateTime, " +
	"ttp.TOTAL_AMOUNT, isnull(ci.CustomerName,'') as On_Acc_Of,isnull(dateadd(mi,?,ttp.JOB_COMPLETION_DATE),'') as JobCompletionDate,isnull(ttp.LOCATION,'') as Location " +
	"from AMS.dbo.CASH_DESPENSE_DETAILS ttp  " +
	"left join AMS.dbo.CVS_BUSINESS_DETAILS bd on ttp.BUSINESS_ID=bd.ID and ttp.SYSTEM_ID=bd.SYSTEM_ID and ttp.CUSTOMER_ID=bd.CUSTOMER_ID  " + 
	"left outer join AMS.dbo.TRIP_PLANNER tp on ttp.TRIP_SHEET_NO=tp.TRIP_SHEET_NO and ttp.SYSTEM_ID=tp.SYSTEM_ID and ttp.CUSTOMER_ID=tp.CUSTOMER_ID " + 
	"inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on tp.CUSTOMER_ID=b.CUSTOMER_ID and tp.SYSTEM_ID=b.SYSTEM_ID  "+
	"left outer join LMS.dbo.Customer_Information ci on ttp.SYSTEM_ID = ci.SystemId and ttp.CUSTOMER_ID = ci.ClientId and ttp.ON_ACC_OF = ci.CustomerId " + 
	"where ttp.SYSTEM_ID=? and ttp.CUSTOMER_ID=? and tp.TRIP_ID=? " +
	"order by ttp.INSERTED_DATE desc " ;
	
	public static final String GET_ARRIVAL_AND_DEPARTURE_DATETIME = " select * from AMS.dbo.TRIP_TRANSIT_POINTS where SYSTEM_ID=? and TRIP_ID=? and CUSTOMER_ID=? and ATM_ARRIVAL_DATETIME is not null and ATM_DEPARTURE_DATETIME is not null " +
			                                                        " order by ATM_ARRIVAL_DATETIME " ;
	
	public static final String GET_POOR_SATELLITE_COUNT_FOR_LTSP="select count(1) as SATELLITE_COUNT from dbo.gpsdata_history_latest a  "+
																 "inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id "+
																 "inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id  "+
																 "where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected'  "+
																 "and DATEDIFF(hh,a.INVALID_UPDATETIME,getutcdate()) <6 and  b.User_id=? and a.VALID='N' and a.INVALID_UPDATETIME is not null  ";
	
	public static final String GET_POOR_SATELLITE_COUNT_FOR_CLIENT="select count(1) as SATELLITE_COUNT from dbo.gpsdata_history_latest a  "+
	 															   "inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id "+
	 															   "inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active'" +
	 															   "where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected'  "+
	 															   "and DATEDIFF(hh,a.INVALID_UPDATETIME,getutcdate()) <6 and  b.User_id=? and a.VALID='N' and a.INVALID_UPDATETIME is not null  ";
	
    public static final String GET_ROUTE_NAMES="select RouteID,RouteName from Route_Master where ClientId=? and System_id=? and STATUS='Active' ";
    
    public static final String GET_GROUP_NAME_FOR_CLIENT = "select a.GROUP_ID, a.GROUP_NAME from ADMINISTRATOR.dbo.ASSET_GROUP a inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on b.SYSTEM_ID=a.SYSTEM_ID " +
	" and a.GROUP_ID=b.GROUP_ID where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and b.USER_ID=? and a.GROUP_ID not in (select GROUP_ID from AMS.dbo.ROUTE_ASSET_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=?)";
    
    public static final String GET_VEHICLE_FOR_CLIENT_WITHOUT_GROUP_ID="select REGISTRATION_NUMBER,GROUP_NAME,vg.GROUP_ID from VEHICLE_CLIENT vc   " +
    		" inner join Vehicle_User vu on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no   " +
    		" inner join  ADMINISTRATOR.dbo.ASSET_GROUP vg on vc.GROUP_ID=vg.GROUP_ID    " +
    		" where vc.CLIENT_ID=?  and vc.SYSTEM_ID=? and vu.User_id=? and vc.REGISTRATION_NUMBER not in(select ASSET_NO from AMS.dbo.ROUTE_ASSET_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? and ASSIGNED_TO='Vehicle' and STATUS='Active' ) " +
    		" and vg.GROUP_ID not in(select GROUP_ID from AMS.dbo.ROUTE_ASSET_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? and ASSIGNED_TO='Group' and STATUS='Active' )";
    
    
    public static final String CREATE_TRIP_DETAILS="Insert into AMS.dbo.ROUTE_ASSET_ASSOCIATION(ROUTE_ID,RETURN_ROUTE_ID,ASSIGNED_TO, GROUP_ID,ASSET_NO,ASSOCIATED_ID,GUEST_ALERT,GUEST_EMAIL_ID,GUEST_MOBILE_NO,STATUS,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,TRIP_TYPE,DAYS,AUTO_CANCEL_DAYS,ASSOCIATED_ALERTS,SUPERVISOR_EMAIL_ID,SUPERVISOR_MOBILE_NO) values(?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,?,?,?,?,?)";
    
    public static final String GET_TRIP_DETAILS="select a.ID,isnull(b.RouteName,'')as RouteName,  " +
    		" isnull(e.RouteName,'')as RETURN_ROUTE_NAME,  " +
    		" isnull(a.ASSIGNED_TO,'')as ASSIGN_TO,isnull(c.GROUP_NAME,'')as GROUP_NAME,a.ASSET_NO,   " +
    		" isnull(a.GUEST_ALERT,'')as GUEST_ALERT,isnull(a.GUEST_EMAIL_ID,'')as EMAIL_ID,isnull(a.SUPERVISOR_EMAIL_ID,'')as SUPERVISOR_EMAIL_ID,isnull(a.SUPERVISOR_MOBILE_NO,'')as SUPERVISOR_MOBILE_NO,  " +
    		" isnull(a.GUEST_MOBILE_NO,'')as MOBILE_NUM,(d.FIRST_NAME+' '+d. LAST_NAME)as INSERTED_BY ,dateadd(mi,330,a.INSERTED_DATETIME) as INSERTED_DATETIME,isnull(a.ASSOCIATED_ID,0) as UNIQUE_ID,a.STATUS,a.GROUP_ID, " +
    		" a.TRIP_TYPE, isnull(a.DAYS,0)as DAYS,isnull(a.AUTO_CANCEL_DAYS,0)as AUTO_CANCEL_DAYS from AMS.dbo.ROUTE_ASSET_ASSOCIATION a  " +
    		" left outer join AMS.dbo.Route_Master b on b.System_id=a.SYSTEM_ID and b.ClientId=a.CUSTOMER_ID and b.RouteID=a.ROUTE_ID " +
    		" left outer join AMS.dbo.Route_Master e on e.System_id=a.SYSTEM_ID and e.ClientId=a.CUSTOMER_ID and e.RouteID=a.RETURN_ROUTE_ID" +
    		" left outer  join ADMINISTRATOR.dbo.ASSET_GROUP c on c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID and c.GROUP_ID=a.GROUP_ID  " +
    		" inner join ADMINISTRATOR.dbo.USERS d on d.USER_ID=a.INSERTED_BY and d.SYSTEM_ID=a.SYSTEM_ID  " +
    		" where a.SYSTEM_ID=? and a.CUSTOMER_ID=?" +
    		" and a.INSERTED_DATETIME between dateadd(mi,0,?) and dateadd(mi,0,?) order by a.INSERTED_DATETIME desc ";
    
    public static final String GET_UNIQUE_ID="select top 1 ASSOCIATED_ID as UNIQUE_ID from AMS.dbo.ROUTE_ASSET_ASSOCIATION order by ASSOCIATED_ID desc";
    
    public static final String MODIFY_TRIP_DETAILS="update AMS.dbo.ROUTE_ASSET_ASSOCIATION set GUEST_ALERT=?,GUEST_EMAIL_ID=?,GUEST_MOBILE_NO=?,UPDATED_BY=?,UPDATED_DATETIME=getutcdate(),STATUS=?,SUPERVISOR_EMAIL_ID=?,SUPERVISOR_MOBILE_NO=? where ASSOCIATED_ID=? ";
    
    public static final String UPDATE_REMARK_FOR_TRIP_CLOASE="update AMS.dbo.ROUTE_ASSET_ASSOCIATION set REMARK=?,STATUS='CLOSED' where ASSOCIATED_ID=? and CUSTOMER_ID=? and SYSTEM_ID=?";
    
    public static final String UPDATE_TRIP_SOLUTION=" update AMS.dbo.TRIP_SOLUTION set STATUS='CANCELED' where STATUS='OPEN' and ASSOCIATION_ID in (select ID from AMS.dbo.ROUTE_ASSET_ASSOCIATION  where ASSOCIATED_ID=? and SYSTEM_ID=? and CUSTOMER_ID=? ) and SYSTEM_ID=? and CUSTOMER_ID=? ";
    
    public static final String GET_VEHICLES_FOR_MODIFY="select ASSOCIATED_ID,ASSET_NO from AMS.dbo.ROUTE_ASSET_ASSOCIATION where ASSOCIATED_ID=? and CUSTOMER_ID=? and SYSTEM_ID=?";
    
    public static final String GET_GROUP_FOR_MODIFY="select ASSOCIATED_ID,b.GROUP_NAME from AMS.dbo.ROUTE_ASSET_ASSOCIATION a " +
    		" inner join ADMINISTRATOR.dbo.ASSET_GROUP b on a.GROUP_ID=b.GROUP_ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID where a.ASSOCIATED_ID=? and a.CUSTOMER_ID=? and a.SYSTEM_ID=?";
    
	
	public static final String GET_MAX_ROUTE_ID= " select max(RouteID) from AMS.dbo.Route_Master";

	public static final String SAVE_ROUTE_ID = " insert into AMS.dbo.Route_Master(RouteID,RouteName,System_id,ClientId,UpdationTime,RouteDescription,RouteDistance,EXPECTED_DISTANCE,ACTUAL_DURATION,EXPECTED_DURATION,STATUS,RADIUS) values(?,?,?,?,getutcdate(),?,?,?,?,?,?,?) ";

	public static final String GET_MAX_SEGMENT_ID=" select max(Route_Segment) from AMS.dbo.Route_Detail ";
	
	public static final String GET_ALERTS_FOR_CLIENT = " select AlertId,AlertName from dbo.Alert_Master_Details where SystemId=? and AlertId in (1,5,134,135,136,138) order by AlertId ";
	
	 public static final String GET_ALERTS_FOR_MODIFY = " select ASSOCIATED_ID,ASSOCIATED_ALERTS from AMS.dbo.ROUTE_ASSET_ASSOCIATION a " +
                                                    " where a.ASSOCIATED_ID=? and a.CUSTOMER_ID=? and a.SYSTEM_ID=? " ;

	public static final String SAVE_ROUTE_PICK_UP_POINT = " insert into AMS.dbo.Route_PickupPoint(RouteId,PickupPointId,SequenceId,Distance) values (?,?,?,?) ";

	public static final String SAVE_ROUTE_DETAIL = " insert into AMS.dbo.Route_Detail(Route_id,Route_Segment,Route_sequence,Latitude,Longitude,TYPE,HUB_ID) values(?,?,?,?,?,?,?) ";
	
	public static final String GET_SOURCE_DESTINATION = " select HUBID,NAME,LATITUDE,LONGITUDE,RADIUS from AMS.dbo.LOCATION_ZONE where CLIENTID=? and SYSTEMID=? and OPERATION_ID!=2 and RADIUS>0 ";
	
	public static final String GET_ROUTE_DETAILS_FOR_GRID=   " select isnull(lz.RADIUS,0) as SOURCE_RADIUS,isnull(dlz.RADIUS,0) as DESTINATION_RADIUS,RouteID,isnull(r.RADIUS,0) as ROUTE_RADIUS,isnull(RouteName,'') as ROUTE_NAME,isnull(RouteDistance,0) as ACTUAL_DISTANCE,isnull(EXPECTED_DISTANCE,0) as EXPECTED_DISTANCE,  " +
															 " isnull(ACTUAL_DURATION,0) as ACTUAL_DURATION,isnull(EXPECTED_DURATION,0) as EXPECTED_DURATION,isnull(STATUS,'') as STATUS,  " +
															 " sourcehub,destinationhub,isnull(lz.NAME,'') as SOURCE_NAME,isnull(dlz.NAME,'') AS DESTINATION_NAME,isnull(tlz1.NAME,'') as " +
															 " TRIGGER_POINT_1,isnull(tlz2.NAME,'') AS TRIGGER_POINT_2,isnull(RouteDescription,'') as ROUTE_DESCRIPTION, " +
															 " r.ClientId,r.System_id  " +
															 " from (  " +
															 " select rm.RADIUS,RouteDescription,RouteID,RouteName,RouteDistance,EXPECTED_DISTANCE,ACTUAL_DURATION,EXPECTED_DURATION,STATUS,  " +
															 " (select HUB_ID from AMS.dbo.Route_Detail (NOLOCK)  where Route_id=rm.RouteID  and TYPE='SOURCE') as sourcehub,  " +
															 " (select HUB_ID from AMS.dbo.Route_Detail (NOLOCK)  where Route_id=rm.RouteID  and TYPE='DESTINATION')  as destinationhub, " +
															 " (select HUB_ID from AMS.dbo.Route_Detail (NOLOCK)  where Route_id=rm.RouteID  and TYPE='TRIGGER POINT 1') as trigger1hub,  " +
															 " (select HUB_ID from AMS.dbo.Route_Detail (NOLOCK)  where Route_id=rm.RouteID  and TYPE='TRIGGER POINT 2')  as trigger2hub, " + 
															 " rm.ClientId,rm.System_id   " +
															 " from AMS.dbo.Route_Master rm where rm.ClientId=? and rm.System_id=? and rm.RADIUS is not null) r  " +
															 " left outer join AMS.dbo.LOCATION_ZONE  (NOLOCK) lz on lz.SYSTEMID=r.System_id  and lz.CLIENTID=r.ClientId and r.sourcehub=lz.HUBID  " +
															 " left outer join AMS.dbo.LOCATION_ZONE  (NOLOCK)  dlz on dlz.SYSTEMID=r.System_id  and dlz.CLIENTID=r.ClientId and r.destinationhub=dlz.HUBID " +  
															 " left outer join AMS.dbo.LOCATION_ZONE  (NOLOCK) tlz1 on tlz1.SYSTEMID=r.System_id  and tlz1.CLIENTID=r.ClientId and r.trigger1hub=tlz1.HUBID  " +
															 " left outer join AMS.dbo.LOCATION_ZONE  (NOLOCK) tlz2 on tlz2.SYSTEMID=r.System_id  and tlz2.CLIENTID=r.ClientId and r.trigger2hub=tlz2.HUBID " ;
	
	public static final String GET_LAT_LNGS =     " select TYPE,Route_Segment,Route_sequence,Latitude,Longitude from Route_Detail a " +
												  " inner join Route_Master b on a.Route_id=b.RouteID " +
												  " inner join dbo.Route_PickupPoint c on a.Route_id=c.RouteId and a.Route_Segment=c.PickupPointId " +
												  " where b.RouteID=? and  b.ClientId=? and b.System_id=? and Route_sequence!=0 order by Route_Segment,Route_sequence asc ";
	
	public static final String UPDATE_ROUTE_IN_ROUTE_MASTER= " update AMS.dbo.Route_Master set STATUS='Inactive' where RouteID=? ";
	
	public static final String GET_TRIGGER_POINT_LATLONGS = " select lz.RADIUS,Route_sequence,Latitude,Longitude from AMS.dbo.Route_Detail a " +
															" inner join AMS.dbo.Route_Master b on a.Route_id=b.RouteID " +
															" left outer join AMS.dbo.LOCATION_ZONE lz on a.HUB_ID=lz.HUBID and b.System_id=lz.SYSTEMID and b.ClientId=lz.CLIENTID " +
															" where b.RouteID=? and b.ClientId=? and b.System_id=? and Route_sequence=0 and a.TYPE in ('TRIGGER POINT 1','TRIGGER POINT 2') order by Route_sequence asc ";

	public static final String GET_TRIP_SUMMARY =  " select (TRIP_ID+'-'+CAST(CUSTOMER_TRIP_ID as varchar(5))) as TripId,TRIP_ID as TripName,isnull(b.TRIP_TYPE,'') as Assignement, "+
												   " RETURN_ROUTE_ID,a.ASSET_NUMBER as VehicalNo,isnull(gps.DRIVER_NAME,'') as DriverName,dateadd(mi,?,a.START_TIME) as StartDateTime,a.START_LOCATION, "+
												   " isnull(dateadd(mi,?,a.END_TIME),'') as EndDateTime,isnull(a.END_LOCATION,'') as END_LOCATION,a.STATUS as TripStatus,isnull(datediff(mi,a.START_TIME,END_TIME),0) as TotalTimeToCompleteTripMins "+
												   " ,isnull(DISTANCE,0) as TotaldistanceTravelled,isnull(RUNNING_TIME,0) as DrivingTime,isnull(TOP_SPEED,0) as TopSpeed,VehicleType "+ 
												   " from AMS.dbo.TRIP_SOLUTION a "+
												   " left outer join AMS.dbo.ROUTE_ASSET_ASSOCIATION b on a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID and b.ID=a.ASSOCIATION_ID "+ 
												   " inner join AMS.dbo.gpsdata_history_latest gps on gps.System_id=a.SYSTEM_ID and gps.CLIENTID=a.CUSTOMER_ID and gps.REGISTRATION_NO=a.ASSET_NUMBER "+
												   " inner join AMS.dbo.tblVehicleMaster vm on vm.System_id=a.SYSTEM_ID and vm.VehicleNo=a.ASSET_NUMBER " +
												   " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.START_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";
	
	public static final String GET_HALT_LATLONGS =   " select lz.RADIUS,Route_sequence,Latitude,Longitude from AMS.dbo.Route_Detail a  " +
													 " inner join AMS.dbo.Route_Master b on a.Route_id=b.RouteID " + 
													 " left outer join AMS.dbo.LOCATION_ZONE lz on a.HUB_ID=lz.HUBID   " +
													 " where b.RouteID=? and b.ClientId=? and b.System_id=? and Route_sequence=0 and a.TYPE not in ('TRIGGER POINT 1','TRIGGER POINT 2')  " +

													 " order by Route_sequence asc  ";
	
	/***********************************************QUOTATION FOR CERTISE***********************************************************/
	public static String GET_lOCATION="select * from dbo.STATE_DETAILS where Country_code=?";

	
	public static final String GET_CUSTOMER_DETAILS = " select CustomerId,CustomerName,CustomerType,State,Address,ContactPerson,PhoneNo,Mobile,EmailId,STATUS,CreatedBy, dateadd(mi,?,InsertedDate) as InsertedDate ,isnull(UpdatedBy,'') as UpdatedBy ,dateadd(mi,?,UpdatedDateTime) as UpdatedDateTime,PhoneNo2,Mobile2,ContactPerson2 "+
                                                      " from LMS.dbo.Customer_Information where ClientId = ? and SystemId = ?  ";
	
	public static final String CHECK_CUSTOMER_ALREADY_EXIST = " select CustomerName from LMS.dbo.Customer_Information  where CustomerName = ? and  ClientId = ? and SystemId = ?  ";
	
	public static final String ADD_NEW_CUSTOMER = " insert into LMS.dbo.Customer_Information ( CustomerName,CustomerType,State,Address,ContactPerson,PhoneNo,Mobile,EmailId,CreatedBy,InsertedDate,SystemId,ClientId,STATUS,PhoneNo2,Mobile2,ContactPerson2 ) values(?,?,?,?,?,?,?,?,?,getUtcdate(),?,?,?,?,?,?) ";
	
	public static final String UPDATE_CUSTOMER = " update LMS.dbo.Customer_Information  set CustomerType = ?,State =? ,Address = ?,ContactPerson = ? ,PhoneNo = ? ,Mobile = ? ,EmailId = ? ,UpdatedBy = ? ,STATUS = ?,UpdatedDateTime = getUtcdate() ,PhoneNo2=?,Mobile2=?,ContactPerson2=? "+
                                                 " where CustomerName = ? and  ClientId = ? and SystemId = ?   ";
	
	public static final String GET_CUSTOMER_BY_LOCATION="SELECT  CustomerId, CustomerName FROM LMS.dbo.Customer_Information where State=? and ClientId=? and SystemId=?";
	
	public static final String SAVE_QUOTE="INSERT INTO [AMS].[dbo].[QUOTATION_MASTER]([QUOTATION_NO],[VALID_FROM],[VALID_TO],[LOCATION],[QUOTE_FOR],[CUSTOMER_NAME],[TARIFF_TYPE],[TARIFF_AMOUNT],[UPLOADED_FILE_PATH],[APPROVED_OR_REJECTED_BY],[QUOTATION_STATUS],[INSERTED_BY],[INSERTED_DATETIME],[SYSTEM_ID],[CUSTOMER_ID],[REVISION_COUNT],[QUOTATION_CUST_ID]) VALUES(?,?,?,?,?,?,?,?,?,'',?,?,getUTCDate(),?,?,0,?)";
	
	public static String GET_QUOTES= "SELECT * FROM AMS.dbo.QUOTATION_MASTER where CUSTOMER_ID = ? AND SYSTEM_ID = ? ";

	
	public static String GET_REVISION_QUOTES= " select QUOTATION_ID, QUOTATION_NO, VALID_FROM, VALID_TO, LOCATION, QUOTE_FOR, CUSTOMER_NAME, TARIFF_TYPE, TARIFF_AMOUNT, UPLOADED_FILE_PATH, QUOTATION_STATUS, STATUS_TYPE, APPROVED_OR_REJECTED_BY, INSERTED_BY, INSERTED_DATETIME, UPDATED_BY, UPDATED_DATETIME, SYSTEM_ID, CUSTOMER_ID, REVISION_COUNT, REASON "+
	                                          " from AMS.dbo.QUOTATION_MASTER where CUSTOMER_ID = ? AND SYSTEM_ID = ? and  QUOTATION_ID = ? "+

	                                          " union all "+

	                                          " select QUOTATION_ID, QUOTATION_NO, VALID_FROM, VALID_TO, LOCATION, QUOTE_FOR, CUSTOMER_NAME, TARIFF_TYPE, TARIFF_AMOUNT, UPLOADED_FILE_PATH, QUOTATION_STATUS, STATUS_TYPE, APPROVED_OR_REJECTED_BY, INSERTED_BY, INSERTED_DATETIME, UPDATED_BY, UPDATED_DATETIME, SYSTEM_ID, CUSTOMER_ID, REVISION_COUNT,REASON "+
	                                          " from AMS.dbo.QUOTATION_MASTER_HISTORY where CUSTOMER_ID = ? AND SYSTEM_ID = ? and  QUOTATION_ID = ? "+

	                                          " order by UPDATED_DATETIME desc ";

	
	public static final String GET_QUOTATION_MASTER_HISTORY_DETAILS = " select  QUOTATION_ID, QUOTATION_NO, CONVERT(VARCHAR(24),VALID_FROM,105) as VALID_FROM, CONVERT(VARCHAR(24),VALID_TO,105) VALID_TO, LOCATION, QUOTE_FOR, CUSTOMER_NAME, TARIFF_TYPE, TARIFF_AMOUNT , QUOTATION_STATUS,STATUS_TYPE,REVISION_COUNT,REASON "+
                                                                      " from AMS.dbo.QUOTATION_MASTER_HISTORY "+
                                                                      " where SYSTEM_ID = ?  and  CUSTOMER_ID = ?  and QUOTATION_STATUS <> 'NEW' ";
	
	public static final String UPDATE_QUOTATION = "UPDATE [AMS].[dbo].[QUOTATION_MASTER]  SET [VALID_FROM] = ?,[VALID_TO] = ?,[LOCATION] = ?,[QUOTE_FOR] = ?,[CUSTOMER_NAME] = ?,[TARIFF_TYPE] = ?,[TARIFF_AMOUNT] = ?,[UPDATED_BY] = ?,[UPDATED_DATETIME] = getUTCDate(),[REVISION_COUNT] = ?,QUOTATION_CUST_ID = ? WHERE QUOTATION_ID = ? ";


	public static final String CHECK_QUOTATION_STATUS = " Select * from [AMS].[dbo].[QUOTATION_MASTER] where  SYSTEM_ID = ?  and  CUSTOMER_ID = ? and  QUOTATION_ID = ? and  QUOTATION_STATUS = 'NEW' ";
	
	public static final String  UPDATE_QUOTATION_STATUS  = " update AMS.dbo.QUOTATION_MASTER set QUOTATION_STATUS = ? , STATUS_TYPE = ? ,APPROVED_OR_REJECTED_BY = ?  , REASON=? where SYSTEM_ID = ?  and  CUSTOMER_ID = ? and  QUOTATION_ID = ? ";

    public static final String INSERTINTO_QUOTATION_HISTORY = " insert into AMS.dbo.QUOTATION_MASTER_HISTORY ( QUOTATION_ID, QUOTATION_NO, VALID_FROM, VALID_TO, LOCATION, QUOTE_FOR, CUSTOMER_NAME, TARIFF_TYPE, TARIFF_AMOUNT, UPLOADED_FILE_PATH, QUOTATION_STATUS, STATUS_TYPE, APPROVED_OR_REJECTED_BY, INSERTED_BY, INSERTED_DATETIME, UPDATED_BY, UPDATED_DATETIME, SYSTEM_ID, CUSTOMER_ID,HISTORY_INSERTED_TIME,HISTORY_INSERTED_BY,REVISION_COUNT,REASON)"+
                                                              " (select QUOTATION_ID, QUOTATION_NO, VALID_FROM, VALID_TO, LOCATION, QUOTE_FOR, CUSTOMER_NAME, TARIFF_TYPE, TARIFF_AMOUNT, UPLOADED_FILE_PATH, QUOTATION_STATUS, STATUS_TYPE, APPROVED_OR_REJECTED_BY, INSERTED_BY, INSERTED_DATETIME, UPDATED_BY, UPDATED_DATETIME, SYSTEM_ID, CUSTOMER_ID,getutcdate(),APPROVED_OR_REJECTED_BY,REVISION_COUNT,REASON from AMS.dbo.QUOTATION_MASTER where  SYSTEM_ID = ?  and  CUSTOMER_ID = ? and  QUOTATION_ID = ? )";


   public static final String DELETE_QUOTATION_FROM_MASTER = " delete from AMS.dbo.QUOTATION_MASTER where  SYSTEM_ID = ?  and  CUSTOMER_ID = ? and  QUOTATION_ID = ?  ";

   public static final String UPDATE_FILE_PATH = " update AMS.dbo.QUOTATION_MASTER set  UPLOADED_FILE_PATH = ? where  SYSTEM_ID = ?  and  CUSTOMER_ID = ? and  QUOTATION_ID = ?   ";
  
   
   public static final String GET_FILE_PSTH = " select UPLOADED_FILE_PATH from AMS.dbo.QUOTATION_MASTER where  SYSTEM_ID = ?  and  CUSTOMER_ID = ? and  QUOTATION_ID = ?   ";
   
   public static final String GET_FILE_PSTH_HISTORY = " select UPLOADED_FILE_PATH from AMS.dbo.QUOTATION_MASTER_HISTORY where  SYSTEM_ID = ?  and  CUSTOMER_ID = ? and  QUOTATION_ID = ?   ";
   
   public static final String GET_CUSTOMER_NAME_FROM_LTSP = " select NAME from ADMINISTRATOR.dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID = ? and STATUS='Active' and ACTIVATION_STATUS='Complete' order by NAME asc ";

   public static final String INSERT_QUOTATION_REVISION_HISTORY = " insert into AMS.dbo.QUOTATION_MASTER_HISTORY ( QUOTATION_ID, QUOTATION_NO, VALID_FROM, VALID_TO, LOCATION, QUOTE_FOR, CUSTOMER_NAME, TARIFF_TYPE, TARIFF_AMOUNT, UPLOADED_FILE_PATH, QUOTATION_STATUS, STATUS_TYPE, APPROVED_OR_REJECTED_BY, INSERTED_BY, INSERTED_DATETIME, UPDATED_BY, UPDATED_DATETIME, SYSTEM_ID, CUSTOMER_ID,REVISION_COUNT,HISTORY_INSERTED_TIME) " +
                                                                  " (select QUOTATION_ID, QUOTATION_NO, VALID_FROM, VALID_TO, LOCATION, QUOTE_FOR, CUSTOMER_NAME, TARIFF_TYPE, TARIFF_AMOUNT, UPLOADED_FILE_PATH, QUOTATION_STATUS, STATUS_TYPE, APPROVED_OR_REJECTED_BY, INSERTED_BY, INSERTED_DATETIME, UPDATED_BY, UPDATED_DATETIME, SYSTEM_ID, CUSTOMER_ID,REVISION_COUNT,getutcdate() from AMS.dbo.QUOTATION_MASTER where QUOTATION_ID = ? ) " ;

   public static final String GET_REVISION_COUNT = " SELECT REVISION_COUNT FROM AMS.dbo.QUOTATION_MASTER where QUOTATION_ID = ? ";
   
   public static final String GET_CVS_CUSTOMER= " select CustomerName from LMS.dbo.Customer_Information where ClientId = ? and SystemId = ?  ";

   public static final String INSET_STATIONARY_DETAILS  = " insert into AMS.dbo.STATIONARY_INVENTORY (ITEM_ID,ITEM_NAME,INITIAL_QUANTITY,REMAINING_QTY,INWARD_DATE,ACTUAL_INWARD_DATE,INWARD_BY,VENDOR_NAME,BRANCH_ID,SYSTEM_ID,CUSTOMER_ID,REMARKS) values (?,?,?,?,?,getUtcDate(),?,?,?,?,?,?) ";

   public static final String GET_STATIONARY_DETAILS =  " select a.VENDOR_NAME,a.ITEM_ID,a.ITEM_NAME,a.INITIAL_QUANTITY,a.REMAINING_QTY,a.INWARD_DATE,a.ACTUAL_INWARD_DATE,a.REMARKS, "+
                                                        " b.Login_name as INWARD_BY from AMS.dbo.STATIONARY_INVENTORY a "+
                                                        " inner join AMS.dbo.Users b on a.INWARD_BY  = b.User_id and a.SYSTEM_ID = b.System_id "+
                                                        " where a.SYSTEM_ID = ?  and  a.CUSTOMER_ID = ?  and a.BRANCH_ID = ?  and  a.INWARD_DATE = ? ";
   
   public static final String GET_STATIONARY_SUMMARY =  " select a.VENDOR_NAME,a.ITEM_ID,sum(a.INITIAL_QUANTITY) as INITIAL_QUANTITY, max(a.REMAINING_QTY) as REMAINING_QTY "+
                                                        " from AMS.dbo.STATIONARY_INVENTORY a "+
                                                        " inner join AMS.dbo.Users b on a.INWARD_BY  = b.User_id and a.SYSTEM_ID = b.System_id "+
                                                        " where a.SYSTEM_ID = ?  and  a.CUSTOMER_ID = ?  and a.BRANCH_ID = ?  "+
                                                        " group by a.ITEM_ID,a.VENDOR_NAME ";
   
   public static final String GET_ALL_REMANING_QTY  = "  select ITEM_ID,max(REMAINING_QTY) as REMAING_QTY from  AMS.dbo.STATIONARY_INVENTORY group by ITEM_ID ";
   
	public static String GET_ARMORY_ITEMS= "SELECT Id,ITEM_NAME FROM AMS.dbo.ARMORY_ITEM WHERE SYSTEM_ID=? and CLIENTID=? and ASSET_TYPE = ? ";
	
	public static final String SAVE_ISSUANCE = "INSERT INTO AMS.dbo.CVM_STATIONARY_ISSUANCE(STATIONARY_ID,QUANTITY,ISSUE_BRANCH,DATE,DEPT,TO_BRANCH,ISSUED_BY,SYSTEMID,CUSTOMER_ID,CREATED_DATE) VALUES (?,?,?,?,?,?,?,?,?,getutcdate()) ";
	public static final String GET_ISSUANCE = "SELECT si.QUANTITY,si.DEPT,ai.ITEM_NAME,si.DATE,(select BranchName FROM Maple.dbo.tblBranchMaster where BranchId=si.ISSUE_BRANCH) as  branch ," +
			"(select BranchName FROM Maple.dbo.tblBranchMaster where BranchId=si.TO_BRANCH) as issuedTo from AMS.dbo.CVM_STATIONARY_ISSUANCE si " +
			"inner join AMS.dbo.ARMORY_ITEM ai on si.STATIONARY_ID = ai.Id inner join Maple.dbo.tblBranchMaster b on si.ISSUE_BRANCH=b.BranchId " +
			"WHERE si.ISSUE_BRANCH=? and si.ISSUED_BY=? AND si.DATE >= ? and si.DATE <= ?";
	public static final String UPDATE_REMAINING_QUANT = "UPDATE STATIONARY_INVENTORY SET REMAINING_QTY=? WHERE ID=?";
	
	public static String GET_BRANCHES="SELECT BranchId,BranchName FROM Maple.dbo.tblBranchMaster WHERE  SystemId=? and ClientId=? ";
	public static String AVALIBILITY_COUNT="SELECT TOP 1 REMAINING_QTY AS count,ID from AMS.dbo.STATIONARY_INVENTORY where ITEM_ID=? AND BRANCH_ID=? and SYSTEM_ID=? AND CUSTOMER_ID= ?  ORDER BY ID DESC";
	public static String GET_SATTIONARY_ITEMS="SELECT Id,ITEM_NAME FROM ARMORY_ITEM WHERE ASSET_TYPE='Stationary' AND SYSTEM_ID=? and CLIENTID=? ";
	 public static final String GET_CVS_CUSTOMER_FOR_VAULT= " select CustomerName,CustomerId from LMS.dbo.Customer_Information where ClientId = ? and SystemId = ?  ";
   
	 
	 public static final String ISERT_CASH_INWARD_DETAILS = " insert into AMS.dbo.CASH_INWARD_DETAILS ( INWARD_MODE, INWARD_DATE, CVS_CUST_ID, SEAL_NO, TOTAL_AMOUNT, CASH_TYPE, CUSTOMER_ID, SYSTEM_ID, ACTUAL_INWARDED_DATETIME, INWARD_BY,SEALBAG_STATUS) values (?,getDate(),?,?,?,?,?,?,getUtcDate(),?,'Inward') ";
     
	 public static final String ISERT_CASH_INWARD_DETAILS_UPDATED = " insert into AMS.dbo.CASH_INWARD_DETAILS ( INWARD_MODE, INWARD_DATE, CVS_CUST_ID, CASH_SEAL_NO, TOTAL_AMOUNT, CASH_TYPE, CUSTOMER_ID, SYSTEM_ID, ACTUAL_INWARDED_DATETIME, INWARD_BY,SEALBAG_STATUS) values (?,getDate(),?,?,?,?,?,?,getUtcDate(),?,'Inward') ";
	 
	 public static final String INSERT_DENOMINATION_DETAILS = " insert into AMS.dbo.DENOMINATION_DETAILS  ( INWARD_ID, DENOM_1,DENOM_2,DENOM_5,DENOM_10,DENOM_20,DENOM_50,DENOM_100, DENOM_500, DENOM_1000, DENOM_2000,DENOM_5000,CASH_CONDITION ) values (?,?,?,?,?,?,?,?,?,?,?,?,?)  ";

	 public static final String GET_DENOMINATION_DETAILS = "select * from AMS.dbo.DENOMINATION_DETAILS where INWARD_ID = ? ";

	 public static final String UPDATE_CASH_INWARD_DETAILS = "   update AMS.dbo.CASH_INWARD_DETAILS  set  INWARD_MODE = ? , INWARD_DATE = ? , CVS_CUST_ID = ? , SEAL_NO = ? , TOTAL_AMOUNT = ?, CASH_TYPE = ? , CUSTOMER_ID = ? , SYSTEM_ID = ?, UPDATED_TIME = getUtcDate() ,  UPDATED_BY  = ? where INWARD_ID = ?";
	 
	 public static final String UPDATE_DENOMINATION_DETAILS = " update   AMS.dbo.DENOMINATION_DETAILS  set DENOM_1 = ? ,DENOM_2 = ? ,DENOM_5 =? ,DENOM_10 =?,DENOM_20 =?,DENOM_50 =?,DENOM_100 = ?,DENOM_500 = ?,DENOM_1000 =? ,DENOM_2000 = ? ,DENOM_5000 = ? where CASH_CONDITION = ? and INWARD_ID = ? ";


	 public static final String GET_VAULT_INVENTORY_FOR_CASH_TYPE = 
	 		 " select s.CVS_CUSTOMER_ID,s.CustomerName,(sum(s.DENOM_5000)*5000)+(sum(s.DENOM_2000)*2000)+(sum(s.DENOM_1000*1000))+(sum(s.DENOM_500*500))+(sum(s.DENOM_100*100))+(sum(s.DENOM_50)*50)+(sum(s.DENOM_50*50))+(sum(s.DENOM_20*20))+(SUM(s.DENOM_10*10))+(sum(s.DENOM_5*5))+(sum(s.DENOM_2*2))+sum(s.DENOM_1*1)  as TOTAL_AMOUNT "+
	 		 " ,sum(s.AVAILABLE_BALANCE)  as AVAILABLE_BALANCE "+
	 		 " from( "+
	 		 "  select 0 as AVAILABLE_BALANCE, CVS_CUST_ID as CVS_CUSTOMER_ID,c.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500, "+
	 		 "  isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10, "+
	 		 "  isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1,b.CASH_CONDITION "+
	 		 "   from AMS.dbo.CASH_INWARD_DETAILS a  inner join AMS.dbo.DENOMINATION_DETAILS b on a.INWARD_ID =b.INWARD_ID "+
	 		 "   inner join LMS.dbo.Customer_Information c on a.CVS_CUST_ID =c.CustomerId "+
	 		 "   where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and b.CASH_CONDITION <> 'GOOD' "+
	 		 "   group by CASH_CONDITION ,CVS_CUST_ID,c.CustomerName "+
	 		 "   union all"+
	 		 "   select  (sum(a.DENOM_5000)*5000)+(sum(a.DENOM_2000)*2000)+(sum(a.DENOM_1000*1000))+(sum(a.DENOM_500*500))+(sum(a.DENOM_100*100))+(sum(a.DENOM_50)*50)+(sum(a.DENOM_50*50))+(sum(a.DENOM_20*20))+(SUM(a.DENOM_10*10))+(sum(a.DENOM_5*5))+(sum(a.DENOM_2*2))+sum(a.DENOM_1*1) as AVAILABLE_BALANCE,CVS_CUSTOMER_ID as CVS_CUSTOMER_ID,b.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500, "+
	 		 "   isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10, "+
	 		 "  isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1 , 'GOOD' as CASH_CONDITION "+
	 		 "   from AMS.dbo.VAULT_TRANSIT_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUSTOMER_ID =b.CustomerId "+
	 		 "   where SYSTEM_ID = ? and CUSTOMER_ID = ? "+
	 		 "   group by b.CustomerName,CVS_CUSTOMER_ID "+
	 		 "   union all"+
	 		 "  select  (sum(a.DENOM_5000)*5000)+(sum(a.DENOM_2000)*2000)+(sum(a.DENOM_1000*1000))+(sum(a.DENOM_500*500))+(sum(a.DENOM_100*100))+(sum(a.DENOM_50)*50)+(sum(a.DENOM_50*50))+(sum(a.DENOM_20*20))+(SUM(a.DENOM_10*10))+(sum(a.DENOM_5*5))+(sum(a.DENOM_2*2))+sum(a.DENOM_1*1) as AVAILABLE_BALANCE,(case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end) as CVS_CUSTOMER_ID,b.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500, "+
	 		 "  isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10, "+
	 		 "  isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1, 'GOOD' as CASH_CONDITION "+
	 		 "  from AMS.dbo.CASH_DESPENSE_DETAILS a inner join LMS.dbo.Customer_Information b on (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end) =b.CustomerId "+
	 		 "  where SYSTEM_ID = ? and CUSTOMER_ID = ? and TRIP_STATUS = 'PENDING' "+
	 		 "   group by b.CustomerName,(case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end)  "+ 
	 		 " ) s "+
	 		 "  group by s.CustomerName,s.CVS_CUSTOMER_ID ";
	 		 
	 		 
	 		 
	 public static final String GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE = " select 0 as AVAILABLE_BALANCE,s.CVS_CUST_ID,s.CustomerName,sum(s.TOTAL_AMOUNT) as TOTAL_AMOUNT,s.CASH_TYPE from "+
	 	 " ( select a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT , CASH_TYPE from   AMS.dbo.CASH_INWARD_DETAILS a " +
	 	 " inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'SEALED BAG' and a.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? "+
	 	 " group by b.CustomerName,CASH_TYPE,CVS_CUST_ID "+
	 	 " UNION all"+
	 	 " select a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT , CASH_TYPE "+
	 	 " from   AMS.dbo.CASH_INWARD_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId "+
	 	 " where CASH_TYPE = 'SEALED BAG' and UPPER(a.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ? "+
	 	 " and a.SEAL_NO IN ( # ) "+
	 	 " group by b.CustomerName,CASH_TYPE,CVS_CUST_ID "+
	 	 " ) s group by s.CustomerName,s.CASH_TYPE,s.CVS_CUST_ID ";

	 public static final String GET_DENOMINATION_DETAILS_SUMMARY = "  select sum(s.DENOM_5000) as DENOM_5000, sum(s.DENOM_2000) as DENOM_2000, sum(s.DENOM_1000) as DENOM_1000 , sum(s.DENOM_500) as DENOM_500, "+
                                                                   "  sum(s.DENOM_100) as DENOM_100, sum(s.DENOM_50) as DENOM_50, sum(s.DENOM_20) as DENOM_20 , sum(s.DENOM_10) as DENOM_10,"+
                                                                   "  sum(s.DENOM_5) as DENOM_5,sum(s.DENOM_2) as DENOM_2, sum(s.DENOM_1) as DENOM_1,s.CASH_CONDITION from "+
                                                                   "  (select isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,"+
                                                                   "  isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,"+
                                                                   "  isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1,b.CASH_CONDITION "+
                                                                   "  from AMS.dbo.CASH_INWARD_DETAILS a  inner join AMS.dbo.DENOMINATION_DETAILS b "+
                                                                   "  on a.INWARD_ID =b.INWARD_ID "+
                                                                   "  where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and a.CVS_CUST_ID =? and b.CASH_CONDITION <> 'GOOD' "+
                                                                   "  group by CASH_CONDITION "+
                                                                   "  union all"+
                                                                   "  select isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500, "+
                                                                   "  isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10, "+
                                                                   "  isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1 , 'GOOD' as CASH_CONDITION "+
                                                                   "  from AMS.dbo.VAULT_TRANSIT_DETAILS "+
                                                                   "  where SYSTEM_ID = ? and CUSTOMER_ID = ? and CVS_CUSTOMER_ID = ? "+
                                                                   "  union all"+
                                                                   "  select isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500, "+
                                                                   " isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10, "+
                                                                   " isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1, 'GOOD' as CASH_CONDITION "+
                                                                   " from AMS.dbo.CASH_DESPENSE_DETAILS "+
                                                                   " where SYSTEM_ID = ? and CUSTOMER_ID = ? and (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end)=? and TRIP_STATUS = 'PENDING') s "+
                                                                   " group by s.CASH_CONDITION ";

	 public static final String CHECK_CVS_CUSTOMER = "select isnull(DENOM_5000,0) as DENOM_5000  , isnull(DENOM_2000,0) as DENOM_2000, isnull(DENOM_1000,0) as DENOM_1000, isnull(DENOM_500,0) as DENOM_500, "+
     " isnull( DENOM_100,0) as DENOM_100, isnull(DENOM_50,0) as DENOM_50,isnull(DENOM_20,0) as DENOM_20 , isnull( DENOM_10,0) as DENOM_10 , "+
     " isnull(DENOM_5,0) as DENOM_5 , isnull(DENOM_2,0) as DENOM_2 , isnull( DENOM_1,0) as DENOM_1 from AMS.dbo.VAULT_TRANSIT_DETAILS where CVS_CUSTOMER_ID = ? and SYSTEM_ID = ? and CUSTOMER_ID = ? ";

	 
	 public static final String UPDATE_INWARD_DENOMINATIONS = " update AMS.dbo.VAULT_TRANSIT_DETAILS set DENOM_1=?,DENOM_2=?,DENOM_5=?,DENOM_10=?,DENOM_20=?,DENOM_50=?,DENOM_100=?,DENOM_500=?,DENOM_1000=?,DENOM_2000=?, DENOM_5000=?,UPDATED_BY=?,UPDATED_DATE=getUtcdate() where   SYSTEM_ID =? and CUSTOMER_ID =? and CVS_CUSTOMER_ID =?  ";

	 public static final String INSERT_INWARD_DENOMINATIONS = " insert into dbo.VAULT_TRANSIT_DETAILS ( DENOM_1,DENOM_2,DENOM_5,DENOM_10,DENOM_20,DENOM_50,DENOM_100,DENOM_500,DENOM_1000,DENOM_2000, DENOM_5000,INSERTED_BY,SYSTEM_ID,CUSTOMER_ID,CVS_CUSTOMER_ID,INSERTED_DATE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getUtcdate()) ";

	 public static final String CHECK_FOR_UPDATED_VALUES = " select isnull(DENOM_5000,0) as DENOM_5000  , isnull(DENOM_2000,0) as DENOM_2000, isnull(DENOM_1000,0) as DENOM_1000, isnull(DENOM_500,0) as DENOM_500, "+
     " isnull( DENOM_100,0) as DENOM_100, isnull(DENOM_50,0) as DENOM_50,isnull(DENOM_20,0) as DENOM_20 , isnull( DENOM_10,0) as DENOM_10 , "+
     " isnull(DENOM_5,0) as DENOM_5 , isnull(DENOM_2,0) as DENOM_2 , isnull( DENOM_1,0) as DENOM_1 from  AMS.dbo.DENOMINATION_DETAILS where INWARD_ID =? and CASH_CONDITION = ?  ";

	 public static final String INSERT_DENOMINATION_DETAILS2 = " insert into  AMS.dbo.DENOMINATION_DETAILS  (DENOM_1,DENOM_2,DENOM_5,DENOM_10,DENOM_20,DENOM_50,DENOM_100,DENOM_500,DENOM_1000,DENOM_2000,DENOM_5000,CASH_CONDITION,INWARD_ID) values (?,?,?,?,?,?,?,?,?,?,?,?,?) ";

	 public static final String GET_TRIP_SHEET_NO = " SELECT distinct TRIP_SHEET_NO as TripSheetNo from AMS.dbo.CASH_DESPENSE_DETAILS where SYSTEM_ID = ? AND CUSTOMER_ID = ? AND ROUTE_ID = ? AND DATE = ?  and TRIP_STATUS = 'PENDING'";

	 public static final String UPDATE_CASH_DESPENSE_DETAILS = " update  AMS.dbo.CASH_DESPENSE_DETAILS set TRIP_STATUS= 'CREATED'  where  TRIP_SHEET_NO = ?  and SYSTEM_ID = ? and CUSTOMER_ID = ? ";

	 public static final String GET_SUMMARY_FOR_CASH_DISPENSE = 
		 " select  a.CUSTOMER_TYPE,a.TRIP_SHEET_NO, CONVERT(VARCHAR(10),a.DATE,110) as DATE,c.ROUTE_NAME, a.TOTAL_AMOUNT,isnull(a.DELIVERY_CUSTOMER_ID,0) as  DeliveryCustomerId "+
		 " from AMS.dbo.CASH_DESPENSE_DETAILS a "+
		 " inner join LMS.dbo.Customer_Information b on a.CVS_CUSTOMER_ID = b.CustomerId "+
		 " inner join AMS.dbo.CVS_ROUTE_DETAILS c on a.ROUTE_ID  = c.ID "+
		 " where a.SYSTEM_ID =? AND a.CUSTOMER_ID = ? and TRIP_STATUS = 'PENDING'  "+
		 " ORDER BY a.TRIP_SHEET_NO";

	 
	 public static final String GET_SUMMARY_FOR_ENROUTE_CASH_DISPENSE = " select  ca.Fullname as CUSTODIAN_1 , cb.Fullname as CUSTODIAN_2,e.Fullname as DRIVER_NAME ,ASSET_NUMBER,d.TRIP_ID,d.STATUS as TRIP_STATUS,a.TRIP_SHEET_NO,CONVERT(VARCHAR(10),a.DATE,110) as DATE,c.ROUTE_NAME"+
" from AMS.dbo.CASH_DESPENSE_DETAILS a"+
" inner join AMS.dbo.CVS_ROUTE_DETAILS c on a.ROUTE_ID  = c.ID and c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID"+
" inner join AMS.dbo.TRIP_PLANNER d on a.TRIP_SHEET_NO = d.TRIP_SHEET_NO and d.SYSTEM_ID=a.SYSTEM_ID and d.CUSTOMER_ID=a.CUSTOMER_ID"+
" inner join AMS.dbo.Driver_Master e on d.DRIVER_ID = e.Driver_id and e.System_id=d.SYSTEM_ID and e.Client_id=d.CUSTOMER_ID"+
" left outer join  AMS.dbo.Driver_Master ca on d.CUSTODIAN_NAME1 = ca.Driver_id and ca.System_id=d.SYSTEM_ID and ca.Client_id=d.CUSTOMER_ID"+
" left outer join  AMS.dbo.Driver_Master cb on d.CUSTODIAN_NAME2 = cb.Driver_id and cb.System_id=d.SYSTEM_ID and cb.Client_id=d.CUSTOMER_ID"+
" where a.SYSTEM_ID = ? AND a.CUSTOMER_ID = ? and  a.TRIP_SHEET_NO in ( select TRIP_SHEET_NO FROM AMS.dbo.CASH_DESPENSE_DETAILS where RECONCILE_STATUS = 'PENDING' and SYSTEM_ID = ? AND CUSTOMER_ID = ? ) order by a.TRIP_SHEET_NO";
	 
	 public static final String UPDATE_CASH_DESPENSE_DETAILS_FOR_CLOSE_TRIPS = " update  AMS.dbo.CASH_DESPENSE_DETAILS set TRIP_STATUS= 'CLOSED'  where TRIP_SHEET_NO = ?  and SYSTEM_ID = ? and CUSTOMER_ID = ? ";

		
	public static final String GET_ACTIVE_ROUTES = "select isnull(ID,0) as id,isnull(ROUTE_NAME,'') as routeName from AMS.dbo.CVS_ROUTE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS=?";
	
	public static final String GET_CASH_DEPSENSE_DETAILS_ON_MODIFY = "select isnull(ID,0) as businessId,isnull(bd.BUSINESS_TYPE,'') as custType,isnull(bd.BANK,'') as custName,isnull(bd.CVS_CUSTOMER_ID,'') as customerId,"+
	" isnull(bd.BUSINESS_ID,0) as atmId,isnull(cd.ON_ACC_OF,0) as onAccOf,isnull(cd.SEALED_OR_CASH,'') as sealedOrCash,isnull(bd.HUB_LOCATION,'') as location,isnull(cd.SEAL_NO,'') as sealNo,isnull(DENOM_5000,0) as denom5000,"+
	" isnull(DENOM_2000,0) as denom2000,isnull(DENOM_1000,0) as denom1000,isnull(DENOM_500,0) as denom500,isnull(DENOM_100,'') as denom100,isnull(DENOM_50,'') as denom50,isnull(DENOM_20,'') as denom20,isnull(DENOM_10,'') as denom10,"+
	" isnull(DENOM_5,'') as denom5,isnull(DENOM_2,'') as denom2,isnull(DENOM_1,'') as denom1,isnull(DENOM_050,'') as denom050,isnull(DENOM_025,'') as denom025,isnull(DENOM_010,'') as denom010,isnull(DENOM_005,'') as denom005,isnull(DENOM_002,'') as denom002,isnull(DENOM_001,'') as denom001,isnull(CHECK_NO,'') as checkNo,isnull(JEWELLERY_REF,'') as jewelleryNo,isnull(FOREX_REF,'') as foreignNo,isnull(TOTAL_AMOUNT,0) as totalAmount,"+
	" isnull(TOTAL_SEAL_AMOUNT,0) as totalSealAmnt,isnull(TOTAL_CASH_AMOUNT,0) as totalCashAmnt,isnull(TOTAL_CHECK_AMOUNT,0) as totalCheckAmnt,isnull(JEWELLERY_TOTAL_AMOUNT,0) as totalJewelleryAmnt,isnull(POREX_TOTAL_AMOUNT,0) as totalForXAmnt,"+
	" isnull(cd.DELIVERY_CUSTOMER_ID,0) as  DeliveryCustomerName,isnull(cd.DELIVERY_BUSINESS_ID,0) as DeliveryLocationName from AMS.dbo.CVS_BUSINESS_DETAILS bd"+
	" left outer join AMS.dbo.CASH_DESPENSE_DETAILS cd on bd.SYSTEM_ID=cd.SYSTEM_ID and bd.CUSTOMER_ID=cd.CUSTOMER_ID and bd.ID=cd.BUSINESS_ID"+
	" where bd.SYSTEM_ID=? and bd.CUSTOMER_ID=? and bd.ROUTE_ID=? and DATE=? and TRIP_SHEET_NO=?"+
	" union "+
	" select isnull(ID,0) as businessId,isnull(bd.BUSINESS_TYPE,'') as custType,isnull(bd.BANK,'') as custName,isnull(bd.CVS_CUSTOMER_ID,'') as customerId,isnull(bd.BUSINESS_ID,'') as atmId,0 as onAccOf,'' as sealedOrCash,'' as location, "+
	" '' as sealNo,0 as denom5000,0 as denom2000,0 as denom1000,0 as denom500,0 as denom100,0 as denom50,0 as denom20,0 as denom10,0 as denom5,0 as denom2,0 as denom1,0 as denom050,0 as denom025,0 as denom010,0 as denom005,0 as denom002,0 as denom001,'' as checkNo,'' as jewelleryNo,'' as foreignNo,0 as totalAmount, "+
	" 0 as totalSealAmnt,0 as totalCashAmnt,0 as totalCheckAmnt,0 as totalJewelleryAmnt, 0 as totalForXAmnt,'' as  DeliveryCustomerName,'' as DeliveryLocationName "+ 
	" from AMS.dbo.CVS_BUSINESS_DETAILS bd"+
	" where bd.SYSTEM_ID=? and bd.CUSTOMER_ID=? and bd.ROUTE_ID=? and bd. ID not in ( select isnull(ID,0) as businessId from AMS.dbo.CVS_BUSINESS_DETAILS bd  "+
	" left outer join AMS.dbo.CASH_DESPENSE_DETAILS cd on bd.SYSTEM_ID=cd.SYSTEM_ID and bd.CUSTOMER_ID=cd.CUSTOMER_ID and bd.ID=cd.BUSINESS_ID"+
	" where bd.SYSTEM_ID=? and bd.CUSTOMER_ID=? and bd.ROUTE_ID=? and DATE=? and TRIP_SHEET_NO=?);";
	
	public static final String INSERT_CASH_DISPENSE = "insert into AMS.dbo.CASH_DESPENSE_DETAILS(SYSTEM_ID,CUSTOMER_ID,BUSINESS_ID,TRIP_SHEET_NO,CUSTOMER_TYPE,CVS_CUSTOMER_ID,DATE,ROUTE_ID,ON_ACC_OF,SEALED_OR_CASH,SEAL_NO,CHECK_NO,JEWELLERY_REF,FOREX_REF,DENOM_5000,DENOM_2000,DENOM_1000,DENOM_500,DENOM_100,DENOM_50,DENOM_20,DENOM_10,DENOM_5,DENOM_2,DENOM_1," +
	" TOTAL_SEAL_AMOUNT,TOTAL_CASH_AMOUNT,TOTAL_CHECK_AMOUNT,JEWELLERY_TOTAL_AMOUNT,POREX_TOTAL_AMOUNT,TOTAL_AMOUNT,TRIP_STATUS,RECONCILE_STATUS,INSERTED_BY,INSERTED_DATE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate())";
	
	public static final String INSERT_CASH_DISPENSE1 = "insert into AMS.dbo.CASH_DESPENSE_DETAILS(SYSTEM_ID,CUSTOMER_ID,BUSINESS_ID,TRIP_SHEET_NO,CUSTOMER_TYPE,CVS_CUSTOMER_ID,DATE,ROUTE_ID,ON_ACC_OF,SEALED_OR_CASH,SEAL_NO,CHECK_NO,JEWELLERY_REF,FOREX_REF,DENOM_5000,DENOM_2000,DENOM_1000,DENOM_500,DENOM_100,DENOM_50,DENOM_20,DENOM_10,DENOM_5,DENOM_2,DENOM_1,DENOM_050,DENOM_025,DENOM_010,DENOM_005,DENOM_002,DENOM_001," +
	" TOTAL_SEAL_AMOUNT,TOTAL_CASH_AMOUNT,TOTAL_CHECK_AMOUNT,JEWELLERY_TOTAL_AMOUNT,POREX_TOTAL_AMOUNT,TOTAL_AMOUNT,TRIP_STATUS,RECONCILE_STATUS,DELIVERY_CUSTOMER_ID,DELIVERY_BUSINESS_ID,INSERTED_BY,INSERTED_DATE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate())";
	
	//****************t4u506 begin ****************************************//
	public static final String INSERT_CASH_DISPENSE2 = "insert into AMS.dbo.CASH_DESPENSE_DETAILS(SYSTEM_ID,CUSTOMER_ID,BUSINESS_ID,TRIP_SHEET_NO,CUSTOMER_TYPE,CVS_CUSTOMER_ID,DATE,ROUTE_ID,ON_ACC_OF,SEALED_OR_CASH,SEAL_NO,CHECK_NO,JEWELLERY_REF,FOREX_REF,DENOM_5000,DENOM_2000,DENOM_1000,DENOM_500,DENOM_100,DENOM_50,DENOM_20,DENOM_10,DENOM_5,DENOM_2,DENOM_1," +
	" TOTAL_SEAL_AMOUNT,TOTAL_CASH_AMOUNT,TOTAL_CHECK_AMOUNT,JEWELLERY_TOTAL_AMOUNT,POREX_TOTAL_AMOUNT,TOTAL_AMOUNT,TRIP_STATUS,RECONCILE_STATUS,INSERTED_BY,INSERTED_DATE,DELIVERY_BUSINESS_ID,DELIVERY_CUSTOMER_ID) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,?)";
	//****************t4u506 begin ****************************************//
	
	public static final String GET_CURRENT_VAULT_RECORD = "select isnull(CVS_CUSTOMER_ID,0) as cvsCustId,isnull(DENOM_5000,0) as denom5000,isnull(DENOM_2000,0) as denom2000,isnull(DENOM_1000,0) as denom1000,isnull(DENOM_500,0) as denom500,isnull(DENOM_100,0) as denom100,isnull(DENOM_50,0) as denom50," +
	" isnull(DENOM_20,0) as denom20,isnull(DENOM_10,0) as denom10,isnull(DENOM_5,0) as denom5,isnull(DENOM_2,0) as denom2,isnull(DENOM_1,0) as denom1,isnull(DENOM_050,0) as denom050,isnull(DENOM_025,0) as denom025,isnull(DENOM_010,0) as denom010,isnull(DENOM_005,0) as denom005,isnull(DENOM_002,0) as denom002,isnull(DENOM_001,0) as denom001 from AMS.dbo.VAULT_TRANSIT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and CVS_CUSTOMER_ID in ( # )";
	
	public static final String UPDATE_VAULT_TRANSIT_ON_DISPENSE = "update AMS.dbo.VAULT_TRANSIT_DETAILS set DENOM_5000=isnull(DENOM_5000,0)-?,DENOM_2000=isnull(DENOM_2000,0)-?,DENOM_1000=isnull(DENOM_1000,0)-?,DENOM_500=isnull(DENOM_500,0)-?," +
	" DENOM_100=isnull(DENOM_100,0)-?,DENOM_50=isnull(DENOM_50,0)-?,DENOM_20=isnull(DENOM_20,0)-?,DENOM_10=isnull(DENOM_10,0)-?,DENOM_5=isnull(DENOM_5,0)-?,DENOM_2=isnull(DENOM_2,0)-?,DENOM_1=isnull(DENOM_1,0)-?,DENOM_050=isnull(DENOM_050,0)-?,DENOM_025=isnull(DENOM_025,0)-?,DENOM_010=isnull(DENOM_010,0)-?,DENOM_005=isnull(DENOM_005,0)-?,DENOM_002=isnull(DENOM_002,0)-?,DENOM_001=isnull(DENOM_001,0)-? where SYSTEM_ID=? and CUSTOMER_ID=? and CVS_CUSTOMER_ID=?";
	
	public static final String GET_CASH_DEPSENSE_DETAILS_ON_CREATE = "select isnull(ID,0) as businessId,isnull(BUSINESS_TYPE,'') as custType,isnull(BANK,'') as custName,isnull(CVS_CUSTOMER_ID,0) as customerId,isnull(BUSINESS_ID,'') as atmId,isnull(HUB_LOCATION,'') as location"+
	" from AMS.dbo.CVS_BUSINESS_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=? ";
	
	public static final String GET_SEAL_NO_FOR_MODIFY = "select isnull(SEAL_NO,'') as sealNo from AMS.dbo.CASH_INWARD_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and CVS_CUST_ID=?" +
	" and CASH_TYPE=? and ((SEALBAG_STATUS = 'Inward') or ( SEALBAG_STATUS = 'DISPENSED' and TRIP_SHEET_NO is null) or (SEALBAG_STATUS = 'Inward' and TRIP_SHEET_NO is not null ))";
	
	public static final String GET_TOTAL_AMOUNT = "select sum(TOTAL_AMOUNT) as totalAmount from AMS.dbo.CASH_INWARD_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and CVS_CUST_ID=? and SEAL_NO in ( # )";
	
	public static final String UPDATE_SEALBAG_STATUS_IN_VAULT_INWARD = "update AMS.dbo.CASH_INWARD_DETAILS set SEALBAG_STATUS=? where SYSTEM_ID=? and CUSTOMER_ID=? and CVS_CUST_ID=? and SEAL_NO in ( # ) and CASH_TYPE=?";
	
	public static final String UPDATE_CASH_DISPENSE = "update AMS.dbo.CASH_DESPENSE_DETAILS set ON_ACC_OF=?,SEALED_OR_CASH=?,DENOM_5000=?,DENOM_2000=?,DENOM_1000=?,DENOM_500=?,DENOM_100=?,DENOM_50=?,DENOM_20=?,DENOM_10=?,DENOM_5=?,DENOM_2=?,DENOM_1=?,TOTAL_AMOUNT=?," +
	" UPDATED_BY=?,UPDATED_DATE=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and BUSINESS_ID=? and TRIP_SHEET_NO=?";
	
	public static final String INSERT_INTO_TEMPORARY_DISPENSE = "insert into AMS.dbo.CASH_DEISPENSE_TEMPORARY (SYSTEM_ID,CUSTOMER_ID,CVS_CUST_ID,BUSINESS_ID,DENOM_5000,DENOM_2000,DENOM_1000,DENOM_500,DENOM_100,DENOM_50," +
	" DENOM_20,DENOM_10,DENOM_5,DENOM_2,DENOM_1,DENOM_050,DENOM_025,DENOM_010,DENOM_005,DENOM_002,DENOM_001) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public static final String GET_TEMPORARY_DISPENSE_RECORD = " select isnull(CVS_CUST_ID,0) as cvsCustId,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 ," +
	" isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,"+
	" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1,isnull(sum(isnull(DENOM_050,0)),0) as DENOM_050,isnull(sum(isnull(DENOM_025,0)),0) as DENOM_025,isnull(sum(isnull(DENOM_010,0)),0) as DENOM_010,isnull(sum(isnull(DENOM_005,0)),0) as DENOM_005,isnull(sum(isnull(DENOM_002,0)),0) as DENOM_002,isnull(sum(isnull(DENOM_001,0)),0) as DENOM_001"+
	" from AMS.dbo.CASH_DEISPENSE_TEMPORARY where SYSTEM_ID = ? and CUSTOMER_ID = ? group by CVS_CUST_ID";
	
	public static final String DELETE_TEMPORARY_DISPENSE_DATA = "delete from AMS.dbo.CASH_DEISPENSE_TEMPORARY where SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String GET_CURRENT_VAULT_RECORD_PLUS_DISPENSE_DETAILS = " select s.CVS_CUSTOMER_ID,sum(s.DENOM_5000) as denom5000, sum(s.DENOM_2000) as denom2000, sum(s.DENOM_1000) as denom1000 , sum(s.DENOM_500) as denom500,"+
	" sum(s.DENOM_100) as denom100, sum(s.DENOM_50) as denom50, sum(s.DENOM_20) as denom20 , sum(s.DENOM_10) as denom10,"+
	" sum(s.DENOM_5) as denom5,sum(s.DENOM_2) as denom2, sum(s.DENOM_1) as denom1,sum(s.DENOM_050) as denom050,sum(s.DENOM_025) as denom025,sum(s.DENOM_010) as denom010,sum(s.DENOM_005) as denom005,sum(s.DENOM_002) as denom002,sum(s.DENOM_001) as denom001 from"+
	" ("+
	" select (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end) as CVS_CUSTOMER_ID,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,"+
	" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,"+
	" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1,isnull(sum(isnull(DENOM_050,0)),0) as DENOM_050,isnull(sum(isnull(DENOM_025,0)),0) as DENOM_025,isnull(sum(isnull(DENOM_010,0)),0) as DENOM_010,isnull(sum(isnull(DENOM_005,0)),0) as DENOM_005,isnull(sum(isnull(DENOM_002,0)),0) as DENOM_002,isnull(sum(isnull(DENOM_001,0)),0) as DENOM_001 "+
	" from AMS.dbo.CASH_DESPENSE_DETAILS a   where a.BUSINESS_ID in(select BUSINESS_ID from AMS.dbo.CASH_DEISPENSE_TEMPORARY where SYSTEM_ID=? and CUSTOMER_ID=?) and a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and TRIP_STATUS in ('PENDING') group by (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end)"+
	" union all"+
	" select CVS_CUSTOMER_ID,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,"+
	" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,"+
	" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1,isnull(sum(isnull(DENOM_050,0)),0) as DENOM_050,isnull(sum(isnull(DENOM_025,0)),0) as DENOM_025,isnull(sum(isnull(DENOM_010,0)),0) as DENOM_010,isnull(sum(isnull(DENOM_005,0)),0) as DENOM_005,isnull(sum(isnull(DENOM_002,0)),0) as DENOM_002,isnull(sum(isnull(DENOM_001,0)),0) as DENOM_001"+
	" from AMS.dbo.VAULT_TRANSIT_DETAILS a  where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and CVS_CUSTOMER_ID in ( # )group by CVS_CUSTOMER_ID"+
	" ) s group by s.CVS_CUSTOMER_ID";
	
	public static final String GET_CURRENT_VAULT_RECORD_PLUS_DISPENSE_DETAILS_ATM = " select sum(s.DENOM_5000) as denom5000, sum(s.DENOM_2000) as denom2000, sum(s.DENOM_1000) as denom1000 , sum(s.DENOM_500) as denom500,"+
	" sum(s.DENOM_100) as denom100, sum(s.DENOM_50) as denom50, sum(s.DENOM_20) as denom20 , sum(s.DENOM_10) as denom10,"+
	" sum(s.DENOM_5) as denom5,sum(s.DENOM_2) as denom2, sum(s.DENOM_1) as denom1 from"+
	" ("+
	" select isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,"+
	" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,"+
	" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1"+
	" from AMS.dbo.CASH_DESPENSE_DETAILS a   where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? # and TRIP_STATUS in ('PENDING')"+
	" union all"+
	" select isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,"+
	" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,"+
	" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1"+
	" from AMS.dbo.VAULT_TRANSIT_DETAILS a  where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and CVS_CUSTOMER_ID = ?"+
	" ) s ";
	public static final String GET_ROUTE_DATE_DETAILS = "select isnull(cd.ROUTE_ID,0) as routeId,isnull(cd.DATE,'') as date,isnull(rm.ROUTE_NAME,'') as routeName from AMS.dbo.CASH_DESPENSE_DETAILS cd" +
	" left outer join AMS.dbo.CVS_ROUTE_DETAILS rm on rm.SYSTEM_ID=cd.SYSTEM_ID and rm.CUSTOMER_ID=cd.CUSTOMER_ID and rm.ID=cd.ROUTE_ID" +
	" where cd.SYSTEM_ID=? and cd.CUSTOMER_ID=? and cd.TRIP_SHEET_NO=?";

public static final String GET_ROUTE_DATE_DETAILS2 =  " select isnull(cd.ROUTE_ID,0) as routeId,isnull(cd.DATE,'') as date,isnull(rm.ROUTE_NAME,'') as routeName, tp.TRIP_ID as TripNo "+
	 " from AMS.dbo.CASH_DESPENSE_DETAILS cd "+
	 " inner join AMS.dbo.CVS_ROUTE_DETAILS rm on rm.SYSTEM_ID=cd.SYSTEM_ID and rm.CUSTOMER_ID=cd.CUSTOMER_ID and rm.ID=cd.ROUTE_ID "+
	 " inner join AMS.dbo.TRIP_PLANNER tp on cd.TRIP_SHEET_NO = tp.TRIP_SHEET_NO and tp.SYSTEM_ID=cd.SYSTEM_ID and tp.CUSTOMER_ID=cd.CUSTOMER_ID"+
	 " where cd.SYSTEM_ID=? and cd.CUSTOMER_ID=? and cd.TRIP_SHEET_NO=? ";
 


public static final String GET_CASH_DEPSENSE_DETAILS_FOR_RECONCILATION = "select isnull(cd.RECONCILE_STATUS,'') as RECONCILE_STATUS,isnull(cd.TR_NUMBER,'') as TR_NUMBER, isnull(cd.UNIQUE_ID,0) as Id,isnull(bd.BUSINESS_TYPE,'') as custType,isnull(bd.BANK,'') as custName,isnull(bd.CVS_CUSTOMER_ID,0) as customerId,isnull(bd.BUSINESS_ID,'') as atmId,isnull(b.CustomerName,'') as DeliveryCustomer," +
" isnull(cd.ON_ACC_OF,0) as onAccOf,isnull(cd.SEALED_OR_CASH,'') as sealedOrCash,isnull(bd.HUB_LOCATION,'') as location,isnull(cd.SEAL_NO,0) as sealNo,isnull(DENOM_5000,0) as denom5000,isnull(DENOM_2000,0) as denom2000,isnull(DENOM_1000,0) as denom1000,isnull(DENOM_500,0) as denom500,isnull(DENOM_100,'') as denom100," +
" isnull(DENOM_50,'') as denom50,isnull(DENOM_20,'') as denom20,isnull(DENOM_10,'') as denom10,isnull(DENOM_5,'') as denom5,isnull(DENOM_2,'') as denom2,isnull(DENOM_1,'') as denom1,isnull(DENOM_050,'') as denom050,isnull(DENOM_025,'') as denom025,isnull(DENOM_010,'') as denom010,isnull(DENOM_005,'') as denom005,isnull(DENOM_002,'') as denom002,isnull(DENOM_001,'') as denom001,isnull(TOTAL_AMOUNT,0) as totalAmount, isnull(cd.CHECK_NO,'') as CHECK_NO, isnull(cd.FOREX_REF,'') AS FOREX_REF, isnull(cd.JEWELLERY_REF,'') as JEWELLERY_REF,isnull(cd.SHORT_EXCESS_STATUS,'') as shortExcessStatus ,cd.TRIP_STATUS as CompleteStatus "+
" from AMS.dbo.CVS_BUSINESS_DETAILS bd"+
" left outer join AMS.dbo.CASH_DESPENSE_DETAILS cd on bd.SYSTEM_ID=cd.SYSTEM_ID and bd.CUSTOMER_ID=cd.CUSTOMER_ID and bd.ID=cd.BUSINESS_ID"+
" left outer join LMS.dbo.Customer_Information b on cd.DELIVERY_CUSTOMER_ID = b.CustomerId "+
" where bd.SYSTEM_ID=? and bd.CUSTOMER_ID=? and bd.ROUTE_ID=? and DATE=? and TRIP_SHEET_NO=?";

public static final String GET_RECONCILATION_DETAILS= 
	" select a.ROUTE_ID,a.CVS_CUSTOMER_ID,c.CustomerName as CUSTOMER_NAME,isnull(a.ON_ACC_OF,0) as ON_ACC_OF ,a.SEAL_NO,isnull(CASH_SEAL_NO,'') as CASH_SEAL_NO,isnull(a.TOTAL_AMOUNT,0) as TOTAL_AMOUNT ,a.DATE,a.CUSTOMER_TYPE,b.BUSINESS_ID,d.TRIP_ID,a.SEALED_OR_CASH,isnull(a.BUSINESS_ID,'') as businessId, isnull(a.CHECK_NO,'') as CHECK_NO, isnull(a.FOREX_REF,'') AS FOREX_REF, isnull(a.JEWELLERY_REF,'') as JEWELLERY_REF  "+
	" from AMS.dbo.CASH_DESPENSE_DETAILS a "+
	" inner join AMS.dbo.CVS_BUSINESS_DETAILS b on a.BUSINESS_ID = b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID"+
	" inner join LMS.dbo.Customer_Information c on a.CVS_CUSTOMER_ID = c.CustomerId and a.SYSTEM_ID=c.SystemId and a.CUSTOMER_ID=c.ClientId"+
	" inner join AMS.dbo.TRIP_PLANNER d on a.TRIP_SHEET_NO = d.TRIP_SHEET_NO and a.SYSTEM_ID=d.SYSTEM_ID and a.CUSTOMER_ID=d.CUSTOMER_ID"+
	" where a.SYSTEM_ID = ? AND a.CUSTOMER_ID =? AND a.TRIP_SHEET_NO = ? AND a.UNIQUE_ID = ? ";

public static final String ISERT_CASH_INWARD_DETAILS_FOR_RECONCILATION = " insert into AMS.dbo.CASH_INWARD_DETAILS ( INWARD_MODE, INWARD_DATE, CVS_CUST_ID, SEAL_NO, TOTAL_AMOUNT, CASH_TYPE, CUSTOMER_ID, SYSTEM_ID, ACTUAL_INWARDED_DATETIME, INWARD_BY,SEALBAG_STATUS,TRIP_SHEET_NO,RECONCILED_DATE,DESPENSE_ID,CASH_SEAL_NO) values (?,getdate(),?,?,?,?,?,?,getUtcDate(),?,'Inward',?,?,?,?) ";

public static final String UPDATE_CASH_INWARD_DETAILS_FOR_RECONCILATION = " update AMS.dbo.CASH_INWARD_DETAILS set INWARD_MODE = ?, SEALBAG_STATUS = 'Inward',TRIP_SHEET_NO = ? ,RECONCILED_DATE = ? ,DESPENSE_ID = ? where CVS_CUST_ID = ? AND UPPER(SEAL_NO) = ? AND  SYSTEM_ID = ? AND CUSTOMER_ID = ?  ";

public static final String UPDATE_DESPENSE = " update AMS.dbo.CASH_DESPENSE_DETAILS set RECONCILE_STATUS = 'RECONCILED',CLOSED_STATUS='PENDING' WHERE TRIP_SHEET_NO = ? AND UNIQUE_ID = ? ";

public static final String GET_CUSTOMER_NAMES = "select isnull(CustomerName,'') as customerName from LMS.dbo.Customer_Information where SystemId=? and ClientId=? and CustomerId in(#)";

public static final String UPDATE_VAULT_TRANSIT_ON_MODIFY_DISPENSE = "update AMS.dbo.VAULT_TRANSIT_DETAILS set DENOM_5000=?,DENOM_2000=?,DENOM_1000=?,DENOM_500=?," +
" DENOM_100=?,DENOM_50=?,DENOM_20=?,DENOM_10=?,DENOM_5=?,DENOM_2=?,DENOM_1=? where SYSTEM_ID=? and CUSTOMER_ID=? and CVS_CUSTOMER_ID=?";

public static final String GET_RUNNING_TRIP_SHEET_NO = "select isNull(INVOICE_NO,0) as tripSheetNo from LMS.dbo.Latest_Running_GR_No where ClientId=? and SystemId=? and TripType=?";

public static final String IS_PRESENT_INVOICE_NO = "select * from LMS.dbo.Latest_Running_GR_No where ClientId=? and SystemId=? and TripType=?";

public static final String UPDATE_INVOICE_NO = "update LMS.dbo.Latest_Running_GR_No set INVOICE_NO=? where ClientId=? and SystemId=? and TripType=?";

public static final String INSERT_INVOICE_NO = "insert into LMS.dbo.Latest_Running_GR_No (INVOICE_NO,ClientId,SystemId,TripType) values (?,?,?,?)";

public static final String GET_MODIFY_INWARD_DETAILS = 
" select a.CVS_CUST_ID,b.CustomerName as CUSTOMER_NAME,a.INWARD_DATE,INWARD_MODE,isnull(SEAL_NO,'') as SEAL_NO, isnull(CASH_SEAL_NO,'') as CASH_SEAL_NO ,a.TOTAL_AMOUNT,CASH_TYPE "+
" from AMS.dbo.CASH_INWARD_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID = b.CustomerId "+
" where a.SYSTEM_ID = ? AND a.CUSTOMER_ID = ? AND a.INWARD_ID = ?";

public static final String GET_BUSINESS_ID = "select isnull(BUSINESS_ID,0) as businessId,isnull(CVS_CUSTOMER_ID,0) as cvsCustId from  AMS.dbo.CASH_DESPENSE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_SHEET_NO=?";

public static final String CHECK_FOR_DISPENSE_EXISTENCE = "select isnull(BUSINESS_ID,0) from AMS.dbo.CASH_DESPENSE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and BUSINESS_ID=? and TRIP_SHEET_NO=?";

public static final String GET_UNCHECKED_RECORD_DETAILS = "select isnull(BUSINESS_ID,0) as businessId,isnull(CUSTOMER_TYPE,'') as customerType,isnull(SEALED_OR_CASH,'') as sealedOrCash,isnull(CVS_CUSTOMER_ID,0) as custId,isnull(ON_ACC_OF,0) as onAccOf," +
" isnull(SEAL_NO,'') as sealNo,isnull(DENOM_5000,0) as denom5000,isnull(DENOM_2000,0) as denom2000,isnull(DENOM_1000,0) as denom1000,isnull(DENOM_500,0) as denom500,isnull(DENOM_100,'') as denom100,isnull(DENOM_50,'') as denom50,isnull(DENOM_20,'') as denom20," +
" isnull(DENOM_10,'') as denom10,isnull(DENOM_5,'') as denom5,isnull(DENOM_2,'') as denom2,isnull(DENOM_1,'') as denom1"+
" from AMS.dbo.CASH_DESPENSE_DETAILS"+ 
" where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_SHEET_NO=? and BUSINESS_ID not in (select BUSINESS_ID from AMS.dbo.CASH_DEISPENSE_TEMPORARY where SYSTEM_ID=? and CUSTOMER_ID=?)";

public static final String DELETE_FROM_CASH_DISPENSE = "delete from AMS.dbo.CASH_DESPENSE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_SHEET_NO=? and BUSINESS_ID=?";

public static final String UPDATE_VAULT_TRANSIT_BEFORE_CLEARING_DISPENSE = "update AMS.dbo.VAULT_TRANSIT_DETAILS set DENOM_5000=isnull(DENOM_5000,0)+?,DENOM_2000=isnull(DENOM_2000,0)+?,DENOM_1000=isnull(DENOM_1000,0)+?,DENOM_500=isnull(DENOM_500,0)+?,DENOM_100=isnull(DENOM_100,0)+?," +
" DENOM_50=isnull(DENOM_50,0)+?,DENOM_20=isnull(DENOM_20,0)+?,DENOM_10=isnull(DENOM_10,0)+?,DENOM_5=isnull(DENOM_5,0)+?,DENOM_2=isnull(DENOM_2,0)+?,DENOM_1=isnull(DENOM_1,0)+?,DENOM_050=isnull(DENOM_050,0)+?,DENOM_025=isnull(DENOM_025,0)+?,DENOM_010=isnull(DENOM_010,0)+?,DENOM_005=isnull(DENOM_005,0)+?,DENOM_002=isnull(DENOM_002,0)+?,DENOM_001=isnull(DENOM_001,0)+? where SYSTEM_ID=? and CUSTOMER_ID=? and CVS_CUSTOMER_ID=?";

public static final String GET_CVS_CUS_TWISE_DISPENSE_RECORD = "select (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end) as CVS_CUSTOMER_ID,isnull(sum(isnull(DENOM_5000,0)),0) as denom5000," +
" isnull(sum(isnull(DENOM_2000,0)),0) as denom2000, isnull(sum(isnull(DENOM_1000,0)),0) as denom1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as denom500,isnull(sum(isnull(DENOM_100,0)),0) as denom100,isnull(sum(isnull(DENOM_50,0)),0) as denom50," +
" isnull(sum(isnull(DENOM_20,0)),0) as denom20 , isnull(sum(isnull(DENOM_10,0) ),0) as denom10,isnull(sum(isnull(DENOM_5,0)),0) as denom5,isnull( sum(isnull(DENOM_2,0)),0) as denom2, isnull(sum(isnull(DENOM_1,0)),0) as denom1"+
" isnull(sum(isnull(DENOM_050,0)),0) as denom050 , isnull(sum(isnull(DENOM_025,0) ),0) as denom025,isnull(sum(isnull(DENOM_010,0)),0) as denom010,isnull( sum(isnull(DENOM_005,0)),0) as denom005, isnull(sum(isnull(DENOM_002,0)),0) as denom002,isnull(sum(isnull(DENOM_001,0)),0) as denom001"+
" from AMS.dbo.CASH_DESPENSE_DETAILS  where SYSTEM_ID =? and CUSTOMER_ID =? and # group by (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end)";

public static final String DELETE_EXISTING_DISPENSE_RECORD = "delete from AMS.dbo.CASH_DESPENSE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and #";

public static final String GET_SEAL_NO_FROM_DISPENSE = "select isnull(SEAL_NO,'') as sealNo,isnull(ON_ACC_OF,0) as custId from CASH_DESPENSE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and # and SEALED_OR_CASH like ?";

public static final String GET_SEAL_NO_AMOUNT = " SELECT TOTAL_AMOUNT from AMS.dbo.CASH_INWARD_DETAILS where CVS_CUST_ID = ? AND UPPER(SEAL_NO) = ? AND  SYSTEM_ID = ? AND CUSTOMER_ID = ? and CASH_TYPE = 'SEALED BAG' ";

public static final String GET_SEAL_NO_AMOUNT2 = " SELECT TOTAL_AMOUNT from AMS.dbo.CASH_INWARD_DETAILS where UPPER(SEAL_NO) = ? AND  SYSTEM_ID = ? AND CUSTOMER_ID = ? and CASH_TYPE = 'SEALED BAG' ";


public static final String GET_ASSET_DETAILS = " select b.ITEM_NAME as ASSET_ITEM,a.ASSET_NO,a.QR_CODE FROM AMS.dbo.ARMORY_INVENTORY a inner join AMS.dbo.ARMORY_ITEM b on a.ASSET_ITEM = b.Id where a.SYSTEM_ID = ? AND a.CLIENT_ID =? AND a.ASSET_NO IN ( # ) ";

public static final String GET_DISPENSE_HISTORY = "select  ca.Fullname as CUSTODIAN_1 , cb.Fullname as CUSTODIAN_2,e.Fullname as DRIVER_NAME ,ASSET_NUMBER,d.TRIP_ID,d.STATUS as TRIP_STATUS,a.TRIP_SHEET_NO,CONVERT(VARCHAR(10),a.DATE,110) as DATE,c.ROUTE_NAME"+
" from AMS.dbo.CASH_DESPENSE_DETAILS a"+
" inner join AMS.dbo.CVS_ROUTE_DETAILS c on a.ROUTE_ID  = c.ID and c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID"+
" inner join AMS.dbo.TRIP_PLANNER d on a.TRIP_SHEET_NO = d.TRIP_SHEET_NO and d.SYSTEM_ID=a.SYSTEM_ID and d.CUSTOMER_ID=a.CUSTOMER_ID"+
" inner join AMS.dbo.Driver_Master e on d.DRIVER_ID = e.Driver_id and e.System_id=d.SYSTEM_ID and e.Client_id=d.CUSTOMER_ID"+
" left outer join  AMS.dbo.Driver_Master ca on d.CUSTODIAN_NAME1 = ca.Driver_id and ca.System_id=d.SYSTEM_ID and ca.Client_id=d.CUSTOMER_ID"+
" left outer join  AMS.dbo.Driver_Master cb on d.CUSTODIAN_NAME2 = cb.Driver_id and cb.System_id=d.SYSTEM_ID and cb.Client_id=d.CUSTOMER_ID"+
" where a.SYSTEM_ID = ? AND a.CUSTOMER_ID = ? and d.STATUS = 'Closed' and  a.DATE between ? and ? and " +
" a.TRIP_SHEET_NO NOT  in ( select TRIP_SHEET_NO FROM AMS.dbo.CASH_DESPENSE_DETAILS where RECONCILE_STATUS = 'PENDING' and SYSTEM_ID = ? AND CUSTOMER_ID = ? ) order by a.TRIP_SHEET_NO" ;

public static final String GET_VAULT_DETAILS = "Select isnull(ci.CustomerName,'') as ONACCOF,isnull(dateadd(mi,?,a.INSERTED_DATE),'') as INSERTED_DATE,(isnull(cm.NAME,'')+'-'+isnull(CAST(b.TRIP_ID as varchar(15)),'')) as TripNo,"+ 
" a.CUSTOMER_TYPE,c.BUSINESS_ID,CONVERT (VARCHAR(50), TOTAL_CASH_AMOUNT,128)+' Dr' as TOTAL_AMOUNT,'CASH' as INWARD_MODE, isnull(a.TOTAL_CASH_AMOUNT,0) as CASH_DISPENSE,"+
" 0 as CASH_INWARD, 0 as SEALED_BAG_DISPENSE, 0 as SEALED_BAG_INWARD,0 as CHEQUE_INWARD,0 as CHEQUE_DISPENSE,0 as JEWELLERY_INWARD,0 as JEWELLERY_DISPENSE,0 as FOREX_INWARD,0 as FOREX_DISPENSE"+ 
" from  AMS.dbo.CASH_DESPENSE_DETAILS a "+
" inner join AMS.dbo.TRIP_PLANNER b on a.TRIP_SHEET_NO = b.TRIP_SHEET_NO and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CUSTOMER_ID"+ 
" inner join AMS.dbo.CVS_BUSINESS_DETAILS c on a.BUSINESS_ID = c.ID "+
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=a.SYSTEM_ID and ci.ClientId=a.CUSTOMER_ID and ci.CustomerId=a.ON_ACC_OF"+ 
" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on a.CUSTOMER_ID=cm.CUSTOMER_ID and a.SYSTEM_ID=cm.SYSTEM_ID"+  
" where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? # and a.INSERTED_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and ( a.SEALED_OR_CASH like '%CASH%' or a.SEALED_OR_CASH = '' or a.SEALED_OR_CASH like '%Cash%') and a.CUSTOMER_TYPE not in( 'Cash pickup' , 'ATM Deposit')"+ 
" union all "+
" Select isnull(ci.CustomerName,'') as ONACCOF ,isnull(dateadd(mi,?,a.INSERTED_DATE),'') as INSERTED_DATE,(isnull(cm.NAME,'')+'-'+isnull(CAST(b.TRIP_ID as varchar(15)),'')) as TripNo,a.CUSTOMER_TYPE,c.BUSINESS_ID,"+ 
" ('SB-'+CONVERT (VARCHAR(50), TOTAL_SEAL_AMOUNT,128)+' Dr') as TOTAL_AMOUNT,'SEALED BAG' as INWARD_MODE, 0 as CASH_DISPENSE,0 as CASH_INWARD, isnull(a.TOTAL_SEAL_AMOUNT,0) as SEALED_BAG_DISPENSE, 0 as SEALED_BAG_INWARD,"+ 
" 0 as CHEQUE_INWARD,0 as CHEQUE_DISPENSE,0 as JEWELLERY_INWARD,0 as JEWELLERY_DISPENSE,0 as FOREX_INWARD,0 as FOREX_DISPENSE"+ 
" from  AMS.dbo.CASH_DESPENSE_DETAILS a"+ 
" inner join AMS.dbo.TRIP_PLANNER b on a.TRIP_SHEET_NO = b.TRIP_SHEET_NO and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CUSTOMER_ID"+ 
" inner join AMS.dbo.CVS_BUSINESS_DETAILS c on a.BUSINESS_ID = c.ID"+ 
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=a.SYSTEM_ID and ci.ClientId=a.CUSTOMER_ID and ci.CustomerId=a.ON_ACC_OF"+ 
" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on a.CUSTOMER_ID=cm.CUSTOMER_ID and a.SYSTEM_ID=cm.SYSTEM_ID "+ 
" where  a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? # and a.INSERTED_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and ( a.SEALED_OR_CASH like '%SEALED BAG%' or a.SEALED_OR_CASH like '%Sealed Bag%' ) and a.CUSTOMER_TYPE not in( 'Cash pickup' , 'ATM Deposit')"+ 
" union all"+ 
" Select isnull(ci.CustomerName,'') as ONACCOF ,isnull(dateadd(mi,?,a.INSERTED_DATE),'') as INSERTED_DATE,(isnull(cm.NAME,'')+'-'+isnull(CAST(b.TRIP_ID as varchar(15)),'')) as TripNo,a.CUSTOMER_TYPE,c.BUSINESS_ID,"+ 
" ('CQ-'+CONVERT (VARCHAR(50), TOTAL_CHECK_AMOUNT,128)+' Dr') as TOTAL_AMOUNT,'CHEQUE' as INWARD_MODE, 0 as CASH_DISPENSE,0 as CASH_INWARD, 0 as SEALED_BAG_DISPENSE, 0 as SEALED_BAG_INWARD"+
" ,0 as CHEQUE_INWARD,isnull(TOTAL_CHECK_AMOUNT,0) as CHEQUE_DISPENSE,0 as JEWELLERY_INWARD,0 as JEWELLERY_DISPENSE,0 as FOREX_INWARD,0 as FOREX_DISPENSE"+ 
" from  AMS.dbo.CASH_DESPENSE_DETAILS a"+ 
" inner join AMS.dbo.TRIP_PLANNER b on a.TRIP_SHEET_NO = b.TRIP_SHEET_NO and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CUSTOMER_ID"+ 
" inner join AMS.dbo.CVS_BUSINESS_DETAILS c on a.BUSINESS_ID = c.ID"+ 
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=a.SYSTEM_ID and ci.ClientId=a.CUSTOMER_ID and ci.CustomerId=a.ON_ACC_OF"+ 
" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on a.CUSTOMER_ID=cm.CUSTOMER_ID and a.SYSTEM_ID=cm.SYSTEM_ID"+  
" where  a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? # and a.INSERTED_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and ( a.SEALED_OR_CASH like '%CHEQUE%' or a.SEALED_OR_CASH like '%Cheque%' ) and a.CUSTOMER_TYPE not in( 'Cash pickup' , 'ATM Deposit')"+
" union all"+ 
" Select isnull(ci.CustomerName,'') as ONACCOF ,isnull(dateadd(mi,?,a.INSERTED_DATE),'') as INSERTED_DATE,(isnull(cm.NAME,'')+'-'+isnull(CAST(b.TRIP_ID as varchar(15)),'')) as TripNo,a.CUSTOMER_TYPE,c.BUSINESS_ID,"+ 
" ('JW-'+CONVERT (VARCHAR(50), JEWELLERY_TOTAL_AMOUNT,128)+' Dr') as TOTAL_AMOUNT,'JEWELLERY' as INWARD_MODE, 0 as CASH_DISPENSE,0 as CASH_INWARD, 0 as SEALED_BAG_DISPENSE, 0 as SEALED_BAG_INWARD"+ 
" ,0 as CHEQUE_INWARD,0 as CHEQUE_DISPENSE,0 as JEWELLERY_INWARD,isnull(JEWELLERY_TOTAL_AMOUNT,0) as JEWELLERY_DISPENSE,0 as FOREX_INWARD,0 as FOREX_DISPENSE "+
" from  AMS.dbo.CASH_DESPENSE_DETAILS a"+ 
" inner join AMS.dbo.TRIP_PLANNER b on a.TRIP_SHEET_NO = b.TRIP_SHEET_NO and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CUSTOMER_ID"+ 
" inner join AMS.dbo.CVS_BUSINESS_DETAILS c on a.BUSINESS_ID = c.ID "+
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=a.SYSTEM_ID and ci.ClientId=a.CUSTOMER_ID and ci.CustomerId=a.ON_ACC_OF "+
" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on a.CUSTOMER_ID=cm.CUSTOMER_ID and a.SYSTEM_ID=cm.SYSTEM_ID"+  
" where  a.SYSTEM_ID = ? and a.CUSTOMER_ID = ?  # and a.INSERTED_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and ( a.SEALED_OR_CASH like '%JEWELLERY%' or a.SEALED_OR_CASH like '%Jewellery%' ) and a.CUSTOMER_TYPE not in( 'Cash pickup' , 'ATM Deposit')"+
" union all"+ 
" Select isnull(ci.CustomerName,'') as ONACCOF ,isnull(dateadd(mi,?,a.INSERTED_DATE),'') as INSERTED_DATE,(isnull(cm.NAME,'')+'-'+isnull(CAST(b.TRIP_ID as varchar(15)),'')) as TripNo,a.CUSTOMER_TYPE,c.BUSINESS_ID,"+ 
" ('FX-'+CONVERT (VARCHAR(50), POREX_TOTAL_AMOUNT,128)+' Dr') as TOTAL_AMOUNT,'FOREIGN CURRENCY' as INWARD_MODE, 0 as CASH_DISPENSE,0 as CASH_INWARD, 0 as SEALED_BAG_DISPENSE, 0 as SEALED_BAG_INWARD"+ 
" ,0 as CHEQUE_INWARD,0 as CHEQUE_DISPENSE,0 as JEWELLERY_INWARD,0 as JEWELLERY_DISPENSE,0 as FOREX_INWARD,isnull(POREX_TOTAL_AMOUNT,0) as FOREX_DISPENSE"+ 
" from  AMS.dbo.CASH_DESPENSE_DETAILS a"+ 
" inner join AMS.dbo.TRIP_PLANNER b on a.TRIP_SHEET_NO = b.TRIP_SHEET_NO and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CUSTOMER_ID "+
" inner join AMS.dbo.CVS_BUSINESS_DETAILS c on a.BUSINESS_ID = c.ID"+ 
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=a.SYSTEM_ID and ci.ClientId=a.CUSTOMER_ID and ci.CustomerId=a.ON_ACC_OF"+ 
" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on a.CUSTOMER_ID=cm.CUSTOMER_ID and a.SYSTEM_ID=cm.SYSTEM_ID"+  
" where  a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? # and a.INSERTED_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and ( a.SEALED_OR_CASH like '%FOREIGN CURRENCY%' or a.SEALED_OR_CASH like '%Foreign Currency%' ) and a.CUSTOMER_TYPE not in( 'Cash pickup' , 'ATM Deposit')"+  
" union all"+ 
" Select isnull(ci.CustomerName,'') as ONACCOF ,d.INWARD_DATE as INSERTED_DATE,(isnull(cm.NAME,'')+'-'+isnull(CAST(b.TRIP_ID as varchar(15)),'')) as TripNo,a.CUSTOMER_TYPE,c.BUSINESS_ID,"+ 
" CONVERT (VARCHAR(50), d.TOTAL_AMOUNT,128)+' Cr' as TOTAL_AMOUNT,d.INWARD_MODE ,0 as CASH_DISPENSE,d.TOTAL_AMOUNT as CASH_INWARD, 0 as SEALED_BAG_DISPENSE, 0 as SEALED_BAG_INWARD"+
" ,0 as CHEQUE_INWARD,0 as CHEQUE_DISPENSE,0 as JEWELLERY_INWARD,0 as JEWELLERY_DISPENSE,0 as FOREX_INWARD,0 as FOREX_DISPENSE"+ 
" from  AMS.dbo.CASH_DESPENSE_DETAILS a"+ 
" inner join AMS.dbo.TRIP_PLANNER b on a.TRIP_SHEET_NO = b.TRIP_SHEET_NO and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CUSTOMER_ID"+ 
" inner join AMS.dbo.CVS_BUSINESS_DETAILS c on a.BUSINESS_ID = c.ID "+
" inner join AMS.dbo.CASH_INWARD_DETAILS d on a.UNIQUE_ID = d.DESPENSE_ID "+
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=a.SYSTEM_ID and ci.ClientId=a.CUSTOMER_ID and ci.CustomerId=a.ON_ACC_OF"+ 
" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on a.CUSTOMER_ID=cm.CUSTOMER_ID and a.SYSTEM_ID=cm.SYSTEM_ID"+  
" where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? # and d.INWARD_DATE between ? and ? and d.CASH_TYPE = 'CASH'"+ 
" union all"+ 
" Select isnull(ci.CustomerName,'') as ONACCOF ,d.INWARD_DATE as INSERTED_DATE,(isnull(cm.NAME,'')+'-'+isnull(CAST(b.TRIP_ID as varchar(15)),'')) as TripNo,a.CUSTOMER_TYPE,c.BUSINESS_ID,"+ 
" 'SB-'+CONVERT (VARCHAR(50), d.TOTAL_AMOUNT,128)+' Cr' as TOTAL_AMOUNT,d.INWARD_MODE ,0 as CASH_DISPENSE,0 as CASH_INWARD, 0 as SEALED_BAG_DISPENSE, d.TOTAL_AMOUNT as SEALED_BAG_INWARD"+ 
" ,0 as CHEQUE_INWARD,0 as CHEQUE_DISPENSE,0 as JEWELLERY_INWARD,0 as JEWELLERY_DISPENSE,0 as FOREX_INWARD,0 as FOREX_DISPENSE"+ 
" from  AMS.dbo.CASH_DESPENSE_DETAILS a "+
" inner join AMS.dbo.TRIP_PLANNER b on a.TRIP_SHEET_NO = b.TRIP_SHEET_NO and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CUSTOMER_ID "+
" inner join AMS.dbo.CVS_BUSINESS_DETAILS c on a.BUSINESS_ID = c.ID "+
" inner join AMS.dbo.CASH_INWARD_DETAILS d on a.UNIQUE_ID = d.DESPENSE_ID"+ 
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=a.SYSTEM_ID and ci.ClientId=a.CUSTOMER_ID and ci.CustomerId=a.ON_ACC_OF"+ 
" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on a.CUSTOMER_ID=cm.CUSTOMER_ID and a.SYSTEM_ID=cm.SYSTEM_ID"+  
" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? # and d.INWARD_DATE between ? and ? and d.CASH_TYPE='SEALED BAG'"+  
" union all"+
" Select isnull(ci.CustomerName,'') as ONACCOF ,d.INWARD_DATE as INSERTED_DATE,(isnull(cm.NAME,'')+'-'+isnull(CAST(b.TRIP_ID as varchar(15)),'')) as TripNo,a.CUSTOMER_TYPE,c.BUSINESS_ID,"+ 
" 'CQ-'+CONVERT (VARCHAR(50), d.TOTAL_AMOUNT,128)+' Cr' as TOTAL_AMOUNT,d.INWARD_MODE ,0 as CASH_DISPENSE,0 as CASH_INWARD, 0 as SEALED_BAG_DISPENSE, d.TOTAL_AMOUNT as SEALED_BAG_INWARD"+ 
" ,0 as CHEQUE_INWARD,0 as CHEQUE_DISPENSE,0 as JEWELLERY_INWARD,0 as JEWELLERY_DISPENSE,0 as FOREX_INWARD,0 as FOREX_DISPENSE"+ 
" from  AMS.dbo.CASH_DESPENSE_DETAILS a"+ 
" inner join AMS.dbo.TRIP_PLANNER b on a.TRIP_SHEET_NO = b.TRIP_SHEET_NO and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CUSTOMER_ID"+ 
" inner join AMS.dbo.CVS_BUSINESS_DETAILS c on a.BUSINESS_ID = c.ID"+ 
" inner join AMS.dbo.CASH_INWARD_DETAILS d on a.UNIQUE_ID = d.DESPENSE_ID "+
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=a.SYSTEM_ID and ci.ClientId=a.CUSTOMER_ID and ci.CustomerId=a.ON_ACC_OF"+ 
" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on a.CUSTOMER_ID=cm.CUSTOMER_ID and a.SYSTEM_ID=cm.SYSTEM_ID"+  
" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? # and d.INWARD_DATE between ? and ? and d.CASH_TYPE='CHEQUE'"+
" union all"+
" Select isnull(ci.CustomerName,'') as ONACCOF ,d.INWARD_DATE as INSERTED_DATE,(isnull(cm.NAME,'')+'-'+isnull(CAST(b.TRIP_ID as varchar(15)),'')) as TripNo,a.CUSTOMER_TYPE,c.BUSINESS_ID,"+ 
" 'JW-'+CONVERT (VARCHAR(50), d.TOTAL_AMOUNT,128)+' Cr' as TOTAL_AMOUNT,d.INWARD_MODE ,0 as CASH_DISPENSE,0 as CASH_INWARD, 0 as SEALED_BAG_DISPENSE,0 as SEALED_BAG_INWARD"+ 
" ,0 as CHEQUE_INWARD,0 as CHEQUE_DISPENSE,isnull(d.TOTAL_AMOUNT,0) as JEWELLERY_INWARD,0 as JEWELLERY_DISPENSE,0 as FOREX_INWARD,0 as FOREX_DISPENSE"+ 
" from  AMS.dbo.CASH_DESPENSE_DETAILS a "+
" inner join AMS.dbo.TRIP_PLANNER b on a.TRIP_SHEET_NO = b.TRIP_SHEET_NO and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CUSTOMER_ID"+ 
" inner join AMS.dbo.CVS_BUSINESS_DETAILS c on a.BUSINESS_ID = c.ID"+ 
" inner join AMS.dbo.CASH_INWARD_DETAILS d on a.UNIQUE_ID = d.DESPENSE_ID"+ 
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=a.SYSTEM_ID and ci.ClientId=a.CUSTOMER_ID and ci.CustomerId=a.ON_ACC_OF"+ 
" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on a.CUSTOMER_ID=cm.CUSTOMER_ID and a.SYSTEM_ID=cm.SYSTEM_ID"+  
" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? # and d.INWARD_DATE between ? and ? and d.CASH_TYPE='JEWELLERY'"+    
" union all"+
" Select isnull(ci.CustomerName,'') as ONACCOF ,d.INWARD_DATE as INSERTED_DATE,(isnull(cm.NAME,'')+'-'+isnull(CAST(b.TRIP_ID as varchar(15)),'')) as TripNo,a.CUSTOMER_TYPE,c.BUSINESS_ID,"+ 
" 'FX-'+CONVERT (VARCHAR(50), d.TOTAL_AMOUNT,128)+' Cr' as TOTAL_AMOUNT,d.INWARD_MODE ,0 as CASH_DISPENSE,0 as CASH_INWARD, 0 as SEALED_BAG_DISPENSE,0 as SEALED_BAG_INWARD"+ 
" ,0 as CHEQUE_INWARD,0 as CHEQUE_DISPENSE,0 as JEWELLERY_INWARD,0 as JEWELLERY_DISPENSE,isnull(d.TOTAL_AMOUNT,0) as FOREX_INWARD,0 as FOREX_DISPENSE"+ 
" from  AMS.dbo.CASH_DESPENSE_DETAILS a"+ 
" inner join AMS.dbo.TRIP_PLANNER b on a.TRIP_SHEET_NO = b.TRIP_SHEET_NO and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CUSTOMER_ID"+ 
" inner join AMS.dbo.CVS_BUSINESS_DETAILS c on a.BUSINESS_ID = c.ID"+ 
" inner join AMS.dbo.CASH_INWARD_DETAILS d on a.UNIQUE_ID = d.DESPENSE_ID "+
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=a.SYSTEM_ID and ci.ClientId=a.CUSTOMER_ID and ci.CustomerId=a.ON_ACC_OF"+ 
" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on a.CUSTOMER_ID=cm.CUSTOMER_ID and a.SYSTEM_ID=cm.SYSTEM_ID "+ 
" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? # and d.INWARD_DATE between ? and ? and d.CASH_TYPE='FOREIGN CURRENCY'"+ 
" order by INSERTED_DATE";

public static final String GET_SEAL_NO_FOR_CREATE = "select isnull(SEAL_NO,'') as sealNo  from AMS.dbo.CASH_INWARD_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and SEALBAG_STATUS='Inward' and CVS_CUST_ID=? and CASH_TYPE=?";

public static final String GET_CURRENT_INVENTORY = " select sum(ou.CASH_TOTAL_AMOUNT) as LEDGER_AMOUNT ,sum( ou.AVAILABLE_BALANCE) as AVAILABLE_BALANCE, sum( ou.SEALED_BAG_TOTAL_AMOUNT) as SEALED_BAG_AMOUNT ,sum(ou.JEW_TOTAL_AMOUNT) as JEW_TOTAL_AMOUNT ,sum(ou.CHECK_TOTAL_AMOUNT) as CHECK_TOTAL_AMOUNT, sum(ou.FOREX_TOTAL_AMOUNT) as FOREX_TOTAL_AMOUNT "+       
" from (  select o.CVS_CUSTOMER_ID,o.CustomerName,sum(o.CASH_TOTAL_AMOUNT) as CASH_TOTAL_AMOUNT ,sum( o.AVAILABLE_BALANCE) as AVAILABLE_BALANCE, sum( o.SEALED_BAG_TOTAL_AMOUNT) as SEALED_BAG_TOTAL_AMOUNT ,sum(o.JEW_TOTAL_AMOUNT) as JEW_TOTAL_AMOUNT ,sum(o.CHECK_TOTAL_AMOUNT) as CHECK_TOTAL_AMOUNT, sum(o.FOREX_TOTAL_AMOUNT) as FOREX_TOTAL_AMOUNT "+
" from ( "+
" select s.CVS_CUSTOMER_ID,s.CustomerName,(sum(s.DENOM_5000)*5000)+(sum(s.DENOM_2000)*2000)+(sum(s.DENOM_1000*1000))+(sum(s.DENOM_500*500))+(sum(s.DENOM_100*100))+(sum(s.DENOM_50)*50)+(sum(s.DENOM_50*50))+(sum(s.DENOM_20*20))+(SUM(s.DENOM_10*10))+(sum(s.DENOM_5*5))+(sum(s.DENOM_2*2))+sum(s.DENOM_1*1)  as CASH_TOTAL_AMOUNT  "+
" ,sum(s.AVAILABLE_BALANCE)  as AVAILABLE_BALANCE ,0 as SEALED_BAG_TOTAL_AMOUNT , 0 as JEW_TOTAL_AMOUNT ,0 as CHECK_TOTAL_AMOUNT,0 as FOREX_TOTAL_AMOUNT "+
" from(  "+
" select 0 as AVAILABLE_BALANCE, CVS_CUST_ID as CVS_CUSTOMER_ID,c.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,  "+
" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,  "+
" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1,b.CASH_CONDITION  "+
" from AMS.dbo.CASH_INWARD_DETAILS a inner join AMS.dbo.DENOMINATION_DETAILS b on a.INWARD_ID =b.INWARD_ID "+
" inner join LMS.dbo.Customer_Information c on a.CVS_CUST_ID =c.CustomerId  "+
" where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and CVS_CUST_ID=? and b.CASH_CONDITION <> 'GOOD'"+
" group by CASH_CONDITION ,CVS_CUST_ID,c.CustomerName  "+
" union all "+
" select  (sum(a.DENOM_5000)*5000)+(sum(a.DENOM_2000)*2000)+(sum(a.DENOM_1000*1000))+(sum(a.DENOM_500*500))+(sum(a.DENOM_100*100))+(sum(a.DENOM_50)*50)+(sum(a.DENOM_50*50))+(sum(a.DENOM_20*20))+(SUM(a.DENOM_10*10))+(sum(a.DENOM_5*5))+(sum(a.DENOM_2*2))+sum(a.DENOM_1*1) as AVAILABLE_BALANCE,CVS_CUSTOMER_ID as CVS_CUSTOMER_ID,b.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,  "+
" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,  "+
" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1 , 'GOOD' as CASH_CONDITION  "+
" from AMS.dbo.VAULT_TRANSIT_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUSTOMER_ID =b.CustomerId  "+
" where SYSTEM_ID = ? and CUSTOMER_ID = ? and CVS_CUSTOMER_ID=? "+
" group by b.CustomerName,CVS_CUSTOMER_ID "+
" union all "+
" select  (sum(a.DENOM_5000)*5000)+(sum(a.DENOM_2000)*2000)+(sum(a.DENOM_1000*1000))+(sum(a.DENOM_500*500))+(sum(a.DENOM_100*100))+(sum(a.DENOM_50)*50)+(sum(a.DENOM_50*50))+(sum(a.DENOM_20*20))+(SUM(a.DENOM_10*10))+(sum(a.DENOM_5*5))+(sum(a.DENOM_2*2))+sum(a.DENOM_1*1) as AVAILABLE_BALANCE,(case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end) as CVS_CUSTOMER_ID,b.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500, "+ 
" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,  "+
" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1, 'GOOD' as CASH_CONDITION  "+
" from AMS.dbo.CASH_DESPENSE_DETAILS a inner join LMS.dbo.Customer_Information b on (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end) =b.CustomerId  "+
" where SYSTEM_ID = ? and CUSTOMER_ID = ? and (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end)=? and TRIP_STATUS = 'PENDING'  "+
" group by b.CustomerName,(case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end)   "+ 
" ) s  "+
" group by s.CustomerName,s.CVS_CUSTOMER_ID  "+
" union all "+
" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,sum(s.TOTAL_AMOUNT) as SEALED_BAG_TOTAL_AMOUNT,0 as JEW_TOTAL_AMOUNT ,0 as CHECK_TOTAL_AMOUNT, 0 as FOREX_TOTAL_AMOUNT from  "+
" ( select a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS a   "+
" inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'SEALED BAG' and a.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? and CVS_CUST_ID=? "+
" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
" UNION all "+
" select a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
" from   AMS.dbo.CASH_INWARD_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId  "+
" where CASH_TYPE = 'SEALED BAG' and UPPER(a.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ? and CVS_CUST_ID=? "+
" and a.SEAL_NO IN ( # )  "+
" group by b.CustomerName,CVS_CUST_ID  "+
" ) s group by s.CustomerName,s.CVS_CUST_ID  "+
" union all "+
" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,0 as SEALED_BAG_TOTAL_AMOUNT,sum(s.TOTAL_AMOUNT) as JEW_TOTAL_AMOUNT, 0 as CHECK_TOTAL_AMOUNT , 0 as FOREX_TOTAL_AMOUNT from  "+
" ( select j.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS j   "+
" inner join LMS.dbo.Customer_Information b on j.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'JEWELLERY' and j.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? and CVS_CUST_ID=? "+
" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
" UNION all "+
" select j.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
" from   AMS.dbo.CASH_INWARD_DETAILS j inner join LMS.dbo.Customer_Information b on j.CVS_CUST_ID =b.CustomerId  "+
" where CASH_TYPE = 'JEWELLERY' and UPPER(j.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ? and CVS_CUST_ID=? "+
" and j.SEAL_NO IN ( # )  "+
" group by b.CustomerName,CVS_CUST_ID  "+
" ) s group by s.CustomerName,s.CVS_CUST_ID  "+
" union all "+
" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,0 as SEALED_BAG_TOTAL_AMOUNT,0 as JEW_TOTAL_AMOUNT,sum(s.TOTAL_AMOUNT) as CHECK_TOTAL_AMOUNT,0 as FOREX_TOTAL_AMOUNT from  "+
" ( select ch.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS ch   "+
" inner join LMS.dbo.Customer_Information b on ch.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'CHEQUE' and ch.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? and CVS_CUST_ID=? "+
" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
" UNION all "+
" select ch.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
" from   AMS.dbo.CASH_INWARD_DETAILS ch inner join LMS.dbo.Customer_Information b on ch.CVS_CUST_ID =b.CustomerId  "+
" where CASH_TYPE = 'CHEQUE' and UPPER(ch.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ? and CVS_CUST_ID=? "+
" and ch.SEAL_NO IN ( # )  "+
" group by b.CustomerName,CVS_CUST_ID  "+
" ) s group by s.CustomerName,s.CVS_CUST_ID  "+
" union all "+
" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,0 as SEALED_BAG_TOTAL_AMOUNT,0 as JEW_TOTAL_AMOUNT,0 as CHECK_TOTAL_AMOUNT , sum(s.TOTAL_AMOUNT) as FOREX_TOTAL_AMOUNT from  "+
" ( select fx.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS fx   "+
" inner join LMS.dbo.Customer_Information b on fx.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'FOREIGN CURRENCY' and fx.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? and CVS_CUST_ID=? "+
" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
" UNION all "+
" select fx.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
" from   AMS.dbo.CASH_INWARD_DETAILS fx inner join LMS.dbo.Customer_Information b on fx.CVS_CUST_ID =b.CustomerId  "+
" where CASH_TYPE = 'FOREIGN CURRENCY' and UPPER(fx.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ? and CVS_CUST_ID = ? "+
" and fx.SEAL_NO IN ( # )  "+
" group by b.CustomerName,CVS_CUST_ID  "+
" ) s group by s.CustomerName,s.CVS_CUST_ID "+
" ) o  "+
" group by o.CustomerName,o.CVS_CUSTOMER_ID "+
" ) ou  ";

public static final String GET_SEAL_BAG_LIST = " select s.SEAL_NO,sum(s.TOTAL_AMOUNT) as TOTAL_AMOUNT,s.remarks from "+
    " ( select a.SEAL_NO,a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT , CASH_TYPE,isnull(a.SEAL_REMARKS,'') as remarks from   AMS.dbo.CASH_INWARD_DETAILS a  "+
    " inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId where CASH_TYPE = ? and a.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? "+
	" group by b.CustomerName,CASH_TYPE,a.SEAL_REMARKS,CVS_CUST_ID,a.SEAL_NO "+
	" UNION all "+
	" select a.SEAL_NO,a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT , CASH_TYPE,'' as remarks "+
	" from   AMS.dbo.CASH_INWARD_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId "+
	" where CASH_TYPE = ? and UPPER(a.SEALBAG_STATUS)= 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ? "+
	" and a.SEAL_NO IN ( # ) "+
	" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID,a.SEAL_NO "+
	"  ) s where CVS_CUST_ID = ? group by s.CustomerName,s.remarks,s.CASH_TYPE,s.CVS_CUST_ID,s.SEAL_NO ";

public static final String GET_PREV_DENOMINATION_DETAILS_FOR_ATM_REP = "select isnull(cd.DATE,'') as date,isnull(tp.TRIP_ID,'') as tripId,isnull(DENOM_5000,0) as denom5000,isnull(DENOM_2000,0) as denom2000,isnull(DENOM_1000,0) as denom1000,isnull(DENOM_500,0) as denom500,isnull(DENOM_100,0) as denom100"+ 
" from CASH_DESPENSE_DETAILS cd"+
" left outer join CVS_BUSINESS_DETAILS cbd on cbd.SYSTEM_ID=cd.SYSTEM_ID and cbd.CUSTOMER_ID=cd.CUSTOMER_ID and cbd.ID=cd.BUSINESS_ID"+
" left outer join TRIP_PLANNER tp on tp.SYSTEM_ID=cd.SYSTEM_ID and tp.CUSTOMER_ID=cd.CUSTOMER_ID and tp.TRIP_SHEET_NO=cd.TRIP_SHEET_NO"+
" where cd.SYSTEM_ID=? and cd.CUSTOMER_ID=? and cd.CUSTOMER_TYPE='ATM Replenishment' and cbd.BUSINESS_ID=? and cd.UNIQUE_ID =(select top 1 UNIQUE_ID from CASH_DESPENSE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID < ?" +
" and CUSTOMER_TYPE='ATM Replenishment' and BUSINESS_ID=? order by UNIQUE_ID desc)order by INSERTED_DATE desc";

public static final String GET_FRESH_DENOMINATION_DETAILS_FOR_ATM_REP = "select isnull(DENOM_5000,0) as denom5000,isnull(DENOM_2000,0) as denom2000,isnull(DENOM_1000,0) as denom1000,isnull(DENOM_500,0) as denom500,isnull(DENOM_100,0) as denom100"+
" from CASH_DESPENSE_DETAILS cd where cd.SYSTEM_ID=? and cd.CUSTOMER_ID=? and cd.CUSTOMER_TYPE='ATM Replenishment' and cd.UNIQUE_ID =?";

public static final String CLOSE_THE_TRIP = "update TRIP_PLANNER set STATUS='Closed',CLOSED_BY=?,ACTUAL_TRIP_CLOSED_DATE_TIME = getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_SHEET_NO=?";

public static final String GET_SEAL_BAG_LIST_FOR_RECONCILATION = " select SEAL_NO,TOTAL_AMOUNT,CUSTOMER_TYPE,ON_ACC_OF from AMS.dbo.CASH_DESPENSE_DETAILS where SYSTEM_ID = ? and CUSTOMER_ID = ? and CVS_CUSTOMER_ID = ?  and UNIQUE_ID = ? ";

public static final String GET_JEWELLERY_LIST_FOR_RECONCILATION = " select isnull(JEWELLERY_REF,'')  as SEAL_NO,isnull(JEWELLERY_TOTAL_AMOUNT,0) as TOTAL_AMOUNT,CUSTOMER_TYPE,ON_ACC_OF from AMS.dbo.CASH_DESPENSE_DETAILS where SYSTEM_ID = ? and CUSTOMER_ID = ? and CVS_CUSTOMER_ID = ?  and UNIQUE_ID = ? ";

public static final String GET_JEWELLERY_AMOUNT = " SELECT TOTAL_AMOUNT from AMS.dbo.CASH_INWARD_DETAILS where CVS_CUST_ID = ? AND UPPER(SEAL_NO) = ? AND  SYSTEM_ID = ? AND CUSTOMER_ID = ? and CASH_TYPE = 'JEWELLERY' ";

public static final String GET_CHECK_LIST_FOR_RECONCILATION = " select isnull(CHECK_NO,'')  as SEAL_NO,isnull(TOTAL_CHECK_AMOUNT,0) as TOTAL_AMOUNT,CUSTOMER_TYPE,ON_ACC_OF from AMS.dbo.CASH_DESPENSE_DETAILS where SYSTEM_ID = ? and CUSTOMER_ID = ? and CVS_CUSTOMER_ID = ?  and UNIQUE_ID = ? ";

public static final String GET_CHECK_AMOUNT = " SELECT TOTAL_AMOUNT from AMS.dbo.CASH_INWARD_DETAILS where CVS_CUST_ID = ? AND UPPER(SEAL_NO) = ? AND  SYSTEM_ID = ? AND CUSTOMER_ID = ? and CASH_TYPE = 'CHEQUE' ";

public static final String GET_FOREX_LIST_FOR_RECONCILATION = " select isnull(FOREX_REF,'')  as SEAL_NO,isnull(POREX_TOTAL_AMOUNT,0) as TOTAL_AMOUNT,CUSTOMER_TYPE,ON_ACC_OF from AMS.dbo.CASH_DESPENSE_DETAILS where SYSTEM_ID = ? and CUSTOMER_ID = ? and CVS_CUSTOMER_ID = ?  and UNIQUE_ID = ? ";

public static final String GET_FOREX_AMOUNT = " SELECT TOTAL_AMOUNT,isnull(CURRENCY_CODE,'') as CURRENCY_CODE from AMS.dbo.CASH_INWARD_DETAILS where CVS_CUST_ID = ? AND UPPER(SEAL_NO) = ? AND  SYSTEM_ID = ? AND CUSTOMER_ID = ? and CASH_TYPE = 'FOREIGN CURRENCY' ";

public static final String GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY = " SELECT SEAL_NO FROM AMS.dbo.CASH_DESPENSE_DETAILS where TRIP_STATUS = 'PENDING' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? ";

public static final String GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY2 = " SELECT SEAL_NO FROM AMS.dbo.CASH_DESPENSE_DETAILS where TRIP_STATUS = 'PENDING' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? and (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end)=? ";

public static final String GET_SUSPENSE_REPORT_DETAILS = "select isnull(cd.UNIQUE_ID,'') as uniqueId,isnull(ci.CustomerName,'') as customerName,(isnull(cm.NAME,'')+'-'+isnull(CAST(tp.TRIP_ID as varchar(15)),'')) as tripNo,isnull(rd.ROUTE_NAME,'') as routeName," +
" isnull(dateadd(mi,?,cd.INSERTED_DATE),'') as date,isnull(bd.BUSINESS_ID,'') as businessId,isnull(cd.CVS_CUSTOMER_ID,'') as cvsCustId,isnull(SUM(sus.SHORT),0) as short,isnull(SUM(sus.EXCESS),0) as excess,isnull(cd.TRIP_SHEET_NO,'') as tripSheetNo,isnull(cd.CLOSED_STATUS,'PENDING') as status,isnull(cd.CUSTOMER_TYPE,'') as businessType" +
" from CASH_DESPENSE_DETAILS cd" +
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=cd.SYSTEM_ID and ci.ClientId=cd.CUSTOMER_ID and ci.CustomerId=cd.CVS_CUSTOMER_ID" +
" left outer join CVS_BUSINESS_DETAILS bd on bd.SYSTEM_ID=cd.SYSTEM_ID and bd.CUSTOMER_ID=cd.CUSTOMER_ID and bd.ID=cd.BUSINESS_ID" +
" left outer join CVS_ROUTE_DETAILS rd on rd.SYSTEM_ID=cd.SYSTEM_ID and rd.CUSTOMER_ID=cd.CUSTOMER_ID and rd.ID=cd.ROUTE_ID" +
" left outer join SUSPENSE_ACCOUNT_DETAILS sus on sus.SYSTEM_ID=cd.SYSTEM_ID and sus.CUSTOMER_ID=cd.CUSTOMER_ID and sus.UID_DISP=cd.UNIQUE_ID" +
" left outer join ADMINISTRATOR.dbo.CUSTOMER_MASTER cm on cm.SYSTEM_ID=cd.SYSTEM_ID and cm.CUSTOMER_ID=cd.CUSTOMER_ID"+
" left outer join TRIP_PLANNER tp on tp.SYSTEM_ID=cd.SYSTEM_ID and tp.CUSTOMER_ID=cd.CUSTOMER_ID and tp.TRIP_SHEET_NO=cd.TRIP_SHEET_NO" +
" where cd.SYSTEM_ID=? and cd.CUSTOMER_ID=? and cd.INSERTED_DATE between dateadd(mi,-?,?) and  dateadd(mi,-?,?) and cd.CLOSED_STATUS in ( # ) and cd.CUSTOMER_TYPE in ('ATM Replenishment','ATM Deposit')" +
" group by ci.CustomerName,rd.ROUTE_NAME,cd.INSERTED_DATE,bd.BUSINESS_ID,cd.UNIQUE_ID,cd.CVS_CUSTOMER_ID,cm.NAME,tp.TRIP_ID,cd.TRIP_SHEET_NO,cd.CLOSED_STATUS,cd.CUSTOMER_TYPE ";

public static final String GET_SUSPENSE_REPRINT_CUSTOMER_DETAILS = "select isnull(ci.CustomerName,'') as customerName,isnull(cd.TRIP_SHEET_NO,'') as tripSheetNo," +
" isnull(cd.DATE,'') as date,isnull(bd.BUSINESS_ID,'') as businessId,isnull(cd.BUSINESS_ID,0) as atmId,isnull(tp.TRIP_ID,0) as tripId,isnull(cd.CUSTOMER_TYPE,'') as businessType" +
" from CASH_DESPENSE_DETAILS cd" +
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=cd.SYSTEM_ID and ci.ClientId=cd.CUSTOMER_ID and ci.CustomerId=cd.CVS_CUSTOMER_ID" +
" left outer join CVS_BUSINESS_DETAILS bd on bd.SYSTEM_ID=cd.SYSTEM_ID and bd.CUSTOMER_ID=cd.CUSTOMER_ID and bd.ID=cd.BUSINESS_ID" +
" left outer join TRIP_PLANNER tp on cd.SYSTEM_ID=tp.SYSTEM_ID and cd.CUSTOMER_ID=tp.CUSTOMER_ID and cd.TRIP_SHEET_NO=tp.TRIP_SHEET_NO" +
" where cd.SYSTEM_ID=? and cd.CUSTOMER_ID=? and cd.UNIQUE_ID=? ";

public static final String GET_SUSPENSE_DENOMINATION_DETAILS ="select isnull(UNIQUE_ID,0) as UID,isnull(DENOMINATION,0) as denomination,isnull(GERNAL,0) as gernal,isnull(PHYSICAL_GOOD,0) as physicalGood,isnull(PHYSICAL_BAD,0) as physicalBad," +
" isnull(REJECTED_GOOD,0) as rejectedGood,isnull(REJECTED_BAD,0) as rejectedBad,isnull(SHORT,0) as short,isnull(EXCESS,0) as excess,isnull(WRITE_OFF,0) as writeoff,isnull(CLOSED,0) as closed" +
" from SUSPENSE_ACCOUNT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and UID_DISP=? ";

public static final String INSERT_SUSPENSE_DETAILS = "insert into SUSPENSE_ACCOUNT_DETAILS (SYSTEM_ID,CUSTOMER_ID,UID_DISP,DENOMINATION,GERNAL,PHYSICAL_GOOD,PHYSICAL_BAD," +
" REJECTED_GOOD,REJECTED_BAD,SHORT,EXCESS,INSERTED_DATE) values (?,?,?,?,?,?,?,?,?,?,?,getutcdate())";

public static final String GET_VAULT_INVENTORY_NEW = 
	    " select o.CVS_CUSTOMER_ID,o.CustomerName,sum(o.CASH_TOTAL_AMOUNT) as CASH_TOTAL_AMOUNT ,sum( o.AVAILABLE_BALANCE) as AVAILABLE_BALANCE, sum( o.SEALED_BAG_TOTAL_AMOUNT) as SEALED_BAG_TOTAL_AMOUNT ,sum(o.JEW_TOTAL_AMOUNT) as JEW_TOTAL_AMOUNT ,sum(o.CHECK_TOTAL_AMOUNT) as CHECK_TOTAL_AMOUNT, sum(o.FOREX_TOTAL_AMOUNT) as FOREX_TOTAL_AMOUNT "+
	    " from( "+
        " select s.CVS_CUSTOMER_ID,s.CustomerName,(sum(s.DENOM_5000)*5000)+(sum(s.DENOM_2000)*2000)+(sum(s.DENOM_1000*1000))+(sum(s.DENOM_500*500))+(sum(s.DENOM_100*100))+(sum(s.DENOM_50)*50)+(sum(s.DENOM_50*50))+(sum(s.DENOM_20*20))+(SUM(s.DENOM_10*10))+(sum(s.DENOM_5*5))+(sum(s.DENOM_2*2))+sum(s.DENOM_1*1)  as CASH_TOTAL_AMOUNT  "+
		" ,sum(s.AVAILABLE_BALANCE)  as AVAILABLE_BALANCE ,0 as SEALED_BAG_TOTAL_AMOUNT , 0 as JEW_TOTAL_AMOUNT ,0 as CHECK_TOTAL_AMOUNT,0 as FOREX_TOTAL_AMOUNT "+
		" from(  "+
		" select 0 as AVAILABLE_BALANCE, CVS_CUST_ID as CVS_CUSTOMER_ID,c.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,  "+
		" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,  "+
		" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1,b.CASH_CONDITION  "+
		" from AMS.dbo.CASH_INWARD_DETAILS a  inner join AMS.dbo.DENOMINATION_DETAILS b on a.INWARD_ID =b.INWARD_ID  "+
		" inner join LMS.dbo.Customer_Information c on a.CVS_CUST_ID =c.CustomerId  "+
		" where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and b.CASH_CONDITION <> 'GOOD'  "+
		" group by CASH_CONDITION ,CVS_CUST_ID,c.CustomerName  "+
		" union all "+
		" select  (sum(a.DENOM_5000)*5000)+(sum(a.DENOM_2000)*2000)+(sum(a.DENOM_1000*1000))+(sum(a.DENOM_500*500))+(sum(a.DENOM_100*100))+(sum(a.DENOM_50)*50)+(sum(a.DENOM_50*50))+(sum(a.DENOM_20*20))+(SUM(a.DENOM_10*10))+(sum(a.DENOM_5*5))+(sum(a.DENOM_2*2))+sum(a.DENOM_1*1) as AVAILABLE_BALANCE,CVS_CUSTOMER_ID as CVS_CUSTOMER_ID,b.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,  "+
		" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,  "+
		" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1 , 'GOOD' as CASH_CONDITION  "+
		" from AMS.dbo.VAULT_TRANSIT_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUSTOMER_ID =b.CustomerId  "+
		" where SYSTEM_ID = ? and CUSTOMER_ID = ?  "+
		" group by b.CustomerName,CVS_CUSTOMER_ID  "+
		" union all "+
		" select  (sum(a.DENOM_5000)*5000)+(sum(a.DENOM_2000)*2000)+(sum(a.DENOM_1000*1000))+(sum(a.DENOM_500*500))+(sum(a.DENOM_100*100))+(sum(a.DENOM_50)*50)+(sum(a.DENOM_50*50))+(sum(a.DENOM_20*20))+(SUM(a.DENOM_10*10))+(sum(a.DENOM_5*5))+(sum(a.DENOM_2*2))+sum(a.DENOM_1*1) as AVAILABLE_BALANCE,(case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end) as CVS_CUSTOMER_ID,b.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500, "+ 
		" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,  "+
		" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1, 'GOOD' as CASH_CONDITION  "+
		" from AMS.dbo.CASH_DESPENSE_DETAILS a inner join LMS.dbo.Customer_Information b on (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end) =b.CustomerId  "+
		" where SYSTEM_ID = ? and CUSTOMER_ID = ? and TRIP_STATUS = 'PENDING'  "+
		" group by b.CustomerName,(case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end)   "+ 
		" ) s  "+
		" group by s.CustomerName,s.CVS_CUSTOMER_ID  "+
		" union all "+
		" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,sum(s.TOTAL_AMOUNT) as SEALED_BAG_TOTAL_AMOUNT,0 as JEW_TOTAL_AMOUNT ,0 as CHECK_TOTAL_AMOUNT, 0 as FOREX_TOTAL_AMOUNT from  "+
		" ( select a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS a   "+
		" inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'SEALED BAG' and a.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
		" UNION all "+
		" select a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
		" from   AMS.dbo.CASH_INWARD_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId  "+
		" where CASH_TYPE = 'SEALED BAG' and UPPER(a.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" and a.SEAL_NO IN ( # )  "+
		" group by b.CustomerName,CVS_CUST_ID  "+
		" ) s group by s.CustomerName,s.CVS_CUST_ID  "+
		" union all "+
		" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,0 as SEALED_BAG_TOTAL_AMOUNT,sum(s.TOTAL_AMOUNT) as JEW_TOTAL_AMOUNT, 0 as CHECK_TOTAL_AMOUNT , 0 as FOREX_TOTAL_AMOUNT from  "+
		" ( select j.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS j   "+
		" inner join LMS.dbo.Customer_Information b on j.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'JEWELLERY' and j.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
		" UNION all "+
		" select j.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
		" from   AMS.dbo.CASH_INWARD_DETAILS j inner join LMS.dbo.Customer_Information b on j.CVS_CUST_ID =b.CustomerId  "+
		" where CASH_TYPE = 'JEWELLERY' and UPPER(j.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" and j.SEAL_NO IN ( # )  "+
		" group by b.CustomerName,CVS_CUST_ID  "+
		" ) s group by s.CustomerName,s.CVS_CUST_ID  "+
		" union all "+
		" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,0 as SEALED_BAG_TOTAL_AMOUNT,0 as JEW_TOTAL_AMOUNT,sum(s.TOTAL_AMOUNT) as CHECK_TOTAL_AMOUNT,0 as FOREX_TOTAL_AMOUNT from  "+
		" ( select ch.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS ch   "+
		" inner join LMS.dbo.Customer_Information b on ch.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'CHEQUE' and ch.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
		" UNION all "+
		" select ch.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
		" from   AMS.dbo.CASH_INWARD_DETAILS ch inner join LMS.dbo.Customer_Information b on ch.CVS_CUST_ID =b.CustomerId  "+
		" where CASH_TYPE = 'CHEQUE' and UPPER(ch.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" and ch.SEAL_NO IN ( # )  "+
		" group by b.CustomerName,CVS_CUST_ID  "+
		" ) s group by s.CustomerName,s.CVS_CUST_ID  "+
		" union all "+
		" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,0 as SEALED_BAG_TOTAL_AMOUNT,0 as JEW_TOTAL_AMOUNT,0 as CHECK_TOTAL_AMOUNT , sum(s.TOTAL_AMOUNT) as FOREX_TOTAL_AMOUNT from  "+
		" ( select fx.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS fx   "+
		" inner join LMS.dbo.Customer_Information b on fx.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'FOREIGN CURRENCY' and fx.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
		" UNION all "+
		" select fx.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
		" from   AMS.dbo.CASH_INWARD_DETAILS fx inner join LMS.dbo.Customer_Information b on fx.CVS_CUST_ID =b.CustomerId  "+
		" where CASH_TYPE = 'FOREIGN CURRENCY' and UPPER(fx.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" and fx.SEAL_NO IN ( # )  "+
		" group by b.CustomerName,CVS_CUST_ID  "+
		" ) s group by s.CustomerName,s.CVS_CUST_ID "+
		" ) o  "+
		" group by o.CustomerName,o.CVS_CUSTOMER_ID ";


public static final String GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERYY2 = " SELECT isnull(CHECK_NO,'') AS SEAL_NO FROM AMS.dbo.CASH_DESPENSE_DETAILS where TRIP_STATUS = 'PENDING' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? ";

public static final String GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY3 = " SELECT isnull(FOREX_REF,'') AS SEAL_NO FROM AMS.dbo.CASH_DESPENSE_DETAILS where TRIP_STATUS = 'PENDING' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? ";

public static final String GET_VAULT_INVENTORY_FOR_SEALED_BAG_TYPE_INNER_QUERY4 = " SELECT isnull(JEWELLERY_REF,'') AS SEAL_NO FROM AMS.dbo.CASH_DESPENSE_DETAILS where TRIP_STATUS = 'PENDING' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? ";

public static final String UPDATE_SUSPENSE_DETAILS = "update SUSPENSE_ACCOUNT_DETAILS set WRITE_OFF=?,CLOSED=? where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=?";

public static final String UPDATE_DISPENSE_RECORD_AFTER_SUSPENSE = "update AMS.dbo.CASH_DESPENSE_DETAILS set CLOSED_STATUS=?,CLOSED_REMARKS=?,CLOSED_BY=?,CHECK_NO=?,CLOSED_TIME=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=?";

public static final String GET_SEAL_BAG_LIST_AND_CURRENCY_CODE = 
    " select s.SEAL_NO,sum(s.TOTAL_AMOUNT) as TOTAL_AMOUNT , s.CURRENCY_CODE from "+
    " ( select a.SEAL_NO,a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT , CASH_TYPE,isnull(a.CURRENCY_CODE,'') as CURRENCY_CODE from   AMS.dbo.CASH_INWARD_DETAILS a  "+
    " inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId where CASH_TYPE = ? and a.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? "+
	" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID,a.SEAL_NO,a.CURRENCY_CODE "+
	" UNION all "+
	" select a.SEAL_NO,a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT , CASH_TYPE ,isnull(a.CURRENCY_CODE,'') as CURRENCY_CODE "+
	" from   AMS.dbo.CASH_INWARD_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId "+
	" where CASH_TYPE = ? and UPPER(a.SEALBAG_STATUS)= 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ? "+
	" and a.SEAL_NO IN ( # ) "+
	" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID,a.SEAL_NO,a.CURRENCY_CODE "+
	"  ) s where CVS_CUST_ID = ? group by s.CustomerName,s.CASH_TYPE,s.CVS_CUST_ID,s.SEAL_NO,s.CURRENCY_CODE ";



public static final String GET_VAULT_INVENTORY_SUMMARY_NEW =  
	  " select sum(ou.CASH_TOTAL_AMOUNT) as LEDGER_AMOUNT ,sum( ou.AVAILABLE_BALANCE) as AVAILABLE_BALANCE, sum( ou.SEALED_BAG_TOTAL_AMOUNT) as SEALED_BAG_AMOUNT ,sum(ou.JEW_TOTAL_AMOUNT) as JEW_TOTAL_AMOUNT ,sum(ou.CHECK_TOTAL_AMOUNT) as CHECK_TOTAL_AMOUNT, sum(ou.FOREX_TOTAL_AMOUNT) as FOREX_TOTAL_AMOUNT "+       
      " from (  select o.CVS_CUSTOMER_ID,o.CustomerName,sum(o.CASH_TOTAL_AMOUNT) as CASH_TOTAL_AMOUNT ,sum( o.AVAILABLE_BALANCE) as AVAILABLE_BALANCE, sum( o.SEALED_BAG_TOTAL_AMOUNT) as SEALED_BAG_TOTAL_AMOUNT ,sum(o.JEW_TOTAL_AMOUNT) as JEW_TOTAL_AMOUNT ,sum(o.CHECK_TOTAL_AMOUNT) as CHECK_TOTAL_AMOUNT, sum(o.FOREX_TOTAL_AMOUNT) as FOREX_TOTAL_AMOUNT "+
	    " from ( "+
      " select s.CVS_CUSTOMER_ID,s.CustomerName,(sum(s.DENOM_5000)*5000)+(sum(s.DENOM_2000)*2000)+(sum(s.DENOM_1000*1000))+(sum(s.DENOM_500*500))+(sum(s.DENOM_100*100))+(sum(s.DENOM_50)*50)+(sum(s.DENOM_50*50))+(sum(s.DENOM_20*20))+(SUM(s.DENOM_10*10))+(sum(s.DENOM_5*5))+(sum(s.DENOM_2*2))+sum(s.DENOM_1*1)  as CASH_TOTAL_AMOUNT  "+
		" ,sum(s.AVAILABLE_BALANCE)  as AVAILABLE_BALANCE ,0 as SEALED_BAG_TOTAL_AMOUNT , 0 as JEW_TOTAL_AMOUNT ,0 as CHECK_TOTAL_AMOUNT,0 as FOREX_TOTAL_AMOUNT "+
		" from(  "+
		" select 0 as AVAILABLE_BALANCE, CVS_CUST_ID as CVS_CUSTOMER_ID,c.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,  "+
		" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,  "+
		" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1,b.CASH_CONDITION  "+
		" from AMS.dbo.CASH_INWARD_DETAILS a  inner join AMS.dbo.DENOMINATION_DETAILS b on a.INWARD_ID =b.INWARD_ID  "+
		" inner join LMS.dbo.Customer_Information c on a.CVS_CUST_ID =c.CustomerId  "+
		" where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and b.CASH_CONDITION <> 'GOOD'  "+
		" group by CASH_CONDITION ,CVS_CUST_ID,c.CustomerName  "+
		" union all "+
		" select  (sum(a.DENOM_5000)*5000)+(sum(a.DENOM_2000)*2000)+(sum(a.DENOM_1000*1000))+(sum(a.DENOM_500*500))+(sum(a.DENOM_100*100))+(sum(a.DENOM_50)*50)+(sum(a.DENOM_50*50))+(sum(a.DENOM_20*20))+(SUM(a.DENOM_10*10))+(sum(a.DENOM_5*5))+(sum(a.DENOM_2*2))+sum(a.DENOM_1*1) as AVAILABLE_BALANCE,CVS_CUSTOMER_ID as CVS_CUSTOMER_ID,b.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500,  "+
		" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,  "+
		" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1 , 'GOOD' as CASH_CONDITION  "+
		" from AMS.dbo.VAULT_TRANSIT_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUSTOMER_ID =b.CustomerId  "+
		" where SYSTEM_ID = ? and CUSTOMER_ID = ?  "+
		" group by b.CustomerName,CVS_CUSTOMER_ID  "+
		" union all "+
		" select  (sum(a.DENOM_5000)*5000)+(sum(a.DENOM_2000)*2000)+(sum(a.DENOM_1000*1000))+(sum(a.DENOM_500*500))+(sum(a.DENOM_100*100))+(sum(a.DENOM_50)*50)+(sum(a.DENOM_50*50))+(sum(a.DENOM_20*20))+(SUM(a.DENOM_10*10))+(sum(a.DENOM_5*5))+(sum(a.DENOM_2*2))+sum(a.DENOM_1*1) as AVAILABLE_BALANCE,(case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end) as CVS_CUSTOMER_ID,b.CustomerName,isnull(sum(isnull(DENOM_5000,0)),0) as DENOM_5000, isnull(sum(isnull(DENOM_2000,0)),0) as DENOM_2000, isnull(sum(isnull(DENOM_1000,0)),0) as DENOM_1000 , isnull(sum(isnull(DENOM_500,0) ) ,0)as DENOM_500, "+ 
		" isnull(sum(isnull(DENOM_100,0)),0) as DENOM_100, isnull(sum(isnull(DENOM_50,0)),0) as DENOM_50, isnull(sum(isnull(DENOM_20,0)),0) as DENOM_20 , isnull(sum(isnull(DENOM_10,0) ),0) as DENOM_10,  "+
		" isnull(sum(isnull(DENOM_5,0)),0) as DENOM_5,isnull( sum(isnull(DENOM_2,0)),0) as DENOM_2, isnull(sum(isnull(DENOM_1,0)),0) as DENOM_1, 'GOOD' as CASH_CONDITION  "+
		" from AMS.dbo.CASH_DESPENSE_DETAILS a inner join LMS.dbo.Customer_Information b on (case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end) =b.CustomerId  "+
		" where SYSTEM_ID = ? and CUSTOMER_ID = ? and TRIP_STATUS = 'PENDING'  "+
		" group by b.CustomerName,(case when CUSTOMER_TYPE = 'Cash Delivery' then ON_ACC_OF else CVS_CUSTOMER_ID end)   "+ 
		" ) s  "+
		" group by s.CustomerName,s.CVS_CUSTOMER_ID  "+
		" union all "+
		" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,sum(s.TOTAL_AMOUNT) as SEALED_BAG_TOTAL_AMOUNT,0 as JEW_TOTAL_AMOUNT ,0 as CHECK_TOTAL_AMOUNT, 0 as FOREX_TOTAL_AMOUNT from  "+
		" ( select a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS a   "+
		" inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'SEALED BAG' and a.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
		" UNION all "+
		" select a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
		" from   AMS.dbo.CASH_INWARD_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId  "+
		" where CASH_TYPE = 'SEALED BAG' and UPPER(a.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" and a.SEAL_NO IN ( # )  "+
		" group by b.CustomerName,CVS_CUST_ID  "+
		" ) s group by s.CustomerName,s.CVS_CUST_ID  "+
		" union all "+
		" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,0 as SEALED_BAG_TOTAL_AMOUNT,sum(s.TOTAL_AMOUNT) as JEW_TOTAL_AMOUNT, 0 as CHECK_TOTAL_AMOUNT , 0 as FOREX_TOTAL_AMOUNT from  "+
		" ( select j.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS j   "+
		" inner join LMS.dbo.Customer_Information b on j.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'JEWELLERY' and j.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
		" UNION all "+
		" select j.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
		" from   AMS.dbo.CASH_INWARD_DETAILS j inner join LMS.dbo.Customer_Information b on j.CVS_CUST_ID =b.CustomerId  "+
		" where CASH_TYPE = 'JEWELLERY' and UPPER(j.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" and j.SEAL_NO IN ( # )  "+
		" group by b.CustomerName,CVS_CUST_ID  "+
		" ) s group by s.CustomerName,s.CVS_CUST_ID  "+
		" union all "+
		" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,0 as SEALED_BAG_TOTAL_AMOUNT,0 as JEW_TOTAL_AMOUNT,sum(s.TOTAL_AMOUNT) as CHECK_TOTAL_AMOUNT,0 as FOREX_TOTAL_AMOUNT from  "+
		" ( select ch.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS ch   "+
		" inner join LMS.dbo.Customer_Information b on ch.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'CHEQUE' and ch.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
		" UNION all "+
		" select ch.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
		" from   AMS.dbo.CASH_INWARD_DETAILS ch inner join LMS.dbo.Customer_Information b on ch.CVS_CUST_ID =b.CustomerId  "+
		" where CASH_TYPE = 'CHEQUE' and UPPER(ch.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" and ch.SEAL_NO IN ( # )  "+
		" group by b.CustomerName,CVS_CUST_ID  "+
		" ) s group by s.CustomerName,s.CVS_CUST_ID  "+
		" union all "+
		" select s.CVS_CUST_ID,s.CustomerName,0 as CASH_TOTAL_AMOUNT,0 as AVAILABLE_BALANCE,0 as SEALED_BAG_TOTAL_AMOUNT,0 as JEW_TOTAL_AMOUNT,0 as CHECK_TOTAL_AMOUNT , sum(s.TOTAL_AMOUNT) as FOREX_TOTAL_AMOUNT from  "+
		" ( select fx.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  from   AMS.dbo.CASH_INWARD_DETAILS fx   "+
		" inner join LMS.dbo.Customer_Information b on fx.CVS_CUST_ID =b.CustomerId where CASH_TYPE = 'FOREIGN CURRENCY' and fx.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID  "+
		" UNION all "+
		" select fx.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT  "+
		" from   AMS.dbo.CASH_INWARD_DETAILS fx inner join LMS.dbo.Customer_Information b on fx.CVS_CUST_ID =b.CustomerId  "+
		" where CASH_TYPE = 'FOREIGN CURRENCY' and UPPER(fx.SEALBAG_STATUS) = 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+
		" and fx.SEAL_NO IN ( # )  "+
		" group by b.CustomerName,CVS_CUST_ID  "+
		" ) s group by s.CustomerName,s.CVS_CUST_ID "+
		" ) o  "+
		" group by o.CustomerName,o.CVS_CUSTOMER_ID "+
      " ) ou  ";
public static final String GET_FOREX_WITH_CODE =  " select s.SEAL_NO,sum(s.TOTAL_AMOUNT) as TOTAL_AMOUNT , s.CURRENCY_CODE from "+
" ( select a.SEAL_NO,a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT , CASH_TYPE,isnull(a.CURRENCY_CODE,'') as CURRENCY_CODE from   AMS.dbo.CASH_INWARD_DETAILS a  "+
" inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId where CASH_TYPE = ? and a.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? "+
" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID,a.SEAL_NO,a.CURRENCY_CODE "+
" UNION all "+
" select a.SEAL_NO,a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT , CASH_TYPE ,isnull(a.CURRENCY_CODE,'') as CURRENCY_CODE "+
" from   AMS.dbo.CASH_INWARD_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId "+
" where CASH_TYPE = ? and UPPER(a.SEALBAG_STATUS)= 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ? "+
" and a.SEAL_NO IN ( # ) "+
" group by b.CustomerName,CASH_TYPE,CVS_CUST_ID,a.SEAL_NO,a.CURRENCY_CODE "+
"  ) s group by s.CustomerName,s.CASH_TYPE,s.CVS_CUST_ID,s.SEAL_NO,s.CURRENCY_CODE ";

public static final String GET_FOREX_WITH_CODE_ORDER_BY_CVSCUSTOMER =  " ( select a.SEAL_NO,a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT , CASH_TYPE,isnull(a.CURRENCY_CODE,'') as CURRENCY_CODE from   AMS.dbo.CASH_INWARD_DETAILS a  "+  
		          " inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId where CASH_TYPE = ? and a.SEALBAG_STATUS= 'Inward' and SYSTEM_ID = ? AND CUSTOMER_ID  = ? "+  
				  " group by b.CustomerName,CASH_TYPE,CVS_CUST_ID,a.SEAL_NO,a.CURRENCY_CODE   "+ 
				  " UNION all "+  
				  " select a.SEAL_NO,a.CVS_CUST_ID,b.CustomerName , sum(TOTAL_AMOUNT) as TOTAL_AMOUNT , CASH_TYPE ,isnull(a.CURRENCY_CODE,'') as CURRENCY_CODE "+   
				  " from   AMS.dbo.CASH_INWARD_DETAILS a inner join LMS.dbo.Customer_Information b on a.CVS_CUST_ID =b.CustomerId   "+ 
				  " where CASH_TYPE = ? and UPPER(a.SEALBAG_STATUS)= 'DISPENSED'  and SYSTEM_ID = ? AND CUSTOMER_ID  = ?  "+  
				  " and a.SEAL_NO IN ( # )   "+ 
				  " group by b.CustomerName,CASH_TYPE,CVS_CUST_ID,a.SEAL_NO,a.CURRENCY_CODE   "+ 
				  " ) "+ 
				  " order by CVS_CUST_ID asc ";

public static final String GET_CVS_SEAL_NO_FOR_VAULT = " select SEAL_NO,TOTAL_AMOUNT  from AMS.dbo.CASH_INWARD_DETAILS where CASH_TYPE = 'SEALED BAG' and SYSTEM_ID = ? AND CUSTOMER_ID =? and CVS_CUST_ID = ? and SEALBAG_STATUS= 'Inward'  ";

public static final String UPDATE_SEAL_BAG_STATUS = " update AMS.dbo.CASH_INWARD_DETAILS set SEALBAG_STATUS = 'Moved' where CASH_TYPE = 'SEALED BAG' and SYSTEM_ID = ? AND CUSTOMER_ID =? and SEAL_NO = ?  and SEALBAG_STATUS= 'Inward'  ";

public static final String GET_SUSPENSE_DETAIL_FOR_PARTICULAR_DISPENSE = "select isnull(DENOMINATION,0) as denomination,isnull(WRITE_OFF,0) as writeOff from SUSPENSE_ACCOUNT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and UID_DISP=?";

public static final String UPDATE_DISPENSE_RECORD_AFTER_SETTLEMENT = "update AMS.dbo.CASH_DESPENSE_DETAILS set CLOSED_STATUS=? where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=?";

public static final String GET_NON_ASSOCIATED_BUSINESS_ID = "select isnull(ID,0) as Id,isnull(bd.BUSINESS_ID,'') as businessId,isnull(bd.BUSINESS_TYPE,'') as businessType,isnull(bd.HUB_LOCATION,'') as location,isnull(ci.CustomerName,'') as customerName,isnull(bd.CVS_CUSTOMER_ID,0) as customerId"+ 
" from CVS_BUSINESS_DETAILS bd"+ 
" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=bd.SYSTEM_ID and ci.ClientId=bd.CUSTOMER_ID and ci.CustomerId=bd.CVS_CUSTOMER_ID"+
" where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=? and ID not in(select BUSINESS_ID from CASH_DESPENSE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_SHEET_NO=?)";
public static final String INSERT_JOURNAL_DATA = "insert into AMS.dbo.SUSPENSE_ACCOUNT_DETAILS (SYSTEM_ID,CUSTOMER_ID,UID_DISP,DENOMINATION,GERNAL,INSERTED_DATE) values(?,?,?,?,?,getutcdate())";


public static final String GET_USER_AUTHORITY_DETAILS = " select distinct isnull(a.User_id,0) as UserId,a.Firstname+ ' ' +a.Lastname as UserName,isnull(e.DATA,'No') as LEDGER_ENTRY_AUTHORITY, " +
	 "isnull(f.DATA,'No') as CASH_VIEW_AUTHORITY,isnull(g.DATA,'No') as RECONCILE_AUTHORITY,isnull(h.DATA,'No') as WRITE_OFF_AUTHORITY,isnull(i.DATA,'No') as RECONCILE_HEAD_AUTHORITY,(c.Firstname+ ' ' +c.Lastname) as CreatedBy, dateadd(mi,?,isnull(b.CREATED_DATE,'')) as CreatedDate, " + 
	 "(d.Firstname+ ' ' +d.Lastname) as UpdatedBy,dateadd(mi,?,isnull(b.UPDATED_DATE,'')) as UpdatedDate from AMS.dbo.Users a " +  
	 "left outer join LMS.dbo.USER_AUTHORITY b on  b.USER_ID=a.User_id and b.SYSTEM_ID=a.System_id  " + 
	 "left outer join AMS.dbo.Users c on c.User_id=b.CREATED_BY and c.System_id=b.SYSTEM_ID " + 
	 "left outer join AMS.dbo.Users d on d.User_id=b.UPDATED_BY and d.System_id=b.SYSTEM_ID " + 
	 "left outer join LMS.dbo.CCM_LOOKUP e on e.ID=b.INVOICE_CANCEL_AUTHORITY and e.TYPE=? and  e.System_id=b.SYSTEM_ID " + 
	 "left outer join LMS.dbo.CCM_LOOKUP f on f.ID=b.BOOKING_EDIT_AUTHORITY and f.TYPE=? and  f.System_id=b.SYSTEM_ID " + 
	 "left outer join LMS.dbo.CCM_LOOKUP g on g.ID=b.BILLING_AUTHORITY and g.TYPE=? and g.SYSTEM_ID=b.SYSTEM_ID " + 
	 "left outer join LMS.dbo.CCM_LOOKUP h on h.ID=b.REVENUE_AUTHORITY and h.TYPE=? and h.SYSTEM_ID=b.SYSTEM_ID " +
	 "left outer join LMS.dbo.CCM_LOOKUP i on i.ID=b.BOOKING_CANCELLATION_AUTHORITY and i.TYPE=? and i.SYSTEM_ID=b.SYSTEM_ID " +
	 "where a.System_id=? and a.Client_id=? ";


public static final String GET_USER_DATA_DETAILS ="select DATA,ID from LMS.dbo.CCM_LOOKUP WHERE SYSTEM_ID=? AND TYPE='User_Authority'";

public static final String USER_DATA_ALREADY_EXIST= "select isnull(USER_ID,'') as USER_ID from LMS.dbo.USER_AUTHORITY where SYSTEM_ID=? and CUSTOMER_ID=? and USER_ID=?";

public static final String INSERT_NEW_USER_DETAILS= "insert into LMS.dbo.USER_AUTHORITY(INVOICE_CANCEL_AUTHORITY,BOOKING_EDIT_AUTHORITY,BILLING_AUTHORITY,REVENUE_AUTHORITY,BOOKING_CANCELLATION_AUTHORITY,USER_ID,CREATED_BY,CREATED_DATE,SYSTEM_ID,CUSTOMER_ID) VALUES(?,?,?,?,?,?,?,getUtcDate(),?,?)";

public static final String MODIFY_USER_AUTHORITY_DETAILS="update LMS.dbo.USER_AUTHORITY set INVOICE_CANCEL_AUTHORITY =? , BOOKING_EDIT_AUTHORITY=? , BILLING_AUTHORITY=? , REVENUE_AUTHORITY=?, BOOKING_CANCELLATION_AUTHORITY=? , UPDATED_BY=?, UPDATED_DATE=getUtcDate() where SYSTEM_ID = ? AND CUSTOMER_ID =? AND USER_ID =? ";

public static final String UPDATE_SHORT_EXCESS_STATUS = "update AMS.dbo.CASH_DESPENSE_DETAILS set SHORT_EXCESS_STATUS=? where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=?";

public static final String UPDATE_PHYSICAL_CASH_DETAILS = "update AMS.dbo.SUSPENSE_ACCOUNT_DETAILS set PHYSICAL_GOOD=?,PHYSICAL_BAD=?,REJECTED_GOOD=?,REJECTED_BAD=?,INSERTED_DATE=getutcdate()" +
		" where SYSTEM_ID=? and CUSTOMER_ID=? and UID_DISP=? and DENOMINATION=?";

public static final String GET_SUSPENSE_RECORD_DETAILS = "select isnull(DENOMINATION,0) as denomination,isnull(GERNAL,0) as journal,isnull(PHYSICAL_GOOD,0) as physicalGood,isnull(PHYSICAL_BAD,0) as physicalBad,isnull(REJECTED_GOOD,0) as rejectedGood," +
		" isnull(REJECTED_BAD,0) as rejectedBad from AMS.dbo.SUSPENSE_ACCOUNT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and UID_DISP=?";

public static final String UPDATE_SUSPENSE_DETAILS_AFTER_RECONCILATION = "update AMS.dbo.SUSPENSE_ACCOUNT_DETAILS set SHORT=?,EXCESS=?,GERNAL=?,PHYSICAL_GOOD=?,PHYSICAL_BAD=?,REJECTED_GOOD=?,REJECTED_BAD=? where SYSTEM_ID=? and CUSTOMER_ID=? and UID_DISP=? and DENOMINATION=?";

public static final String GET_USER_AUTHORITY = "select isNull(PROFIT_LOSS_AUTHORITY,0) as PROFIT_LOSS_AUTHORITY,isNull(BOOKING_CANCELLATION_AUTHORITY,0) as BOOKING_CANCELLATION_AUTHORITY,isNull(REVENUE_AUTHORITY,0) as REVENUE_AUTHORITY,isnull(INVOICE_CANCEL_AUTHORITY,0) as INVOICE_CANCEL_AUTHORITY," +
		" isnull(BOOKING_EDIT_AUTHORITY,0) as BOOKING_EDIT_AUTHORITY,isnull(BILLING_AUTHORITY,0) as BILLING_AUTHORITY  from LMS.dbo.USER_AUTHORITY where SYSTEM_ID=? and CUSTOMER_ID=? and USER_ID=? ";

public static final String SAVE_NTC_ROUTE_DETAILS = "INSERT INTO NTC_ROUTE_MASTER (ROUTE_NAME,START_LOCATION,END_LOCATION,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME) VALUES " +
		" (?,?,?,?,?,?,getdate())";

public static final String SAVE_ROUTE_DETAILS = "INSERT INTO NTC_ROUTE_DETAILS (ROUTE_ID,SEQUENCE,LATITUDE,LONGITUDE) VALUES " +
		" (?,?,?,?)";
public static final String GET_ROUTE_NAME = "select * from AMS.dbo.Route_Master where System_id=?  order by RouteID desc";

public static final String GET_ROUTE_LATLNG = "select * from AMS.dbo.Route_Detail where Route_id=? and Route_sequence!=0 and TYPE!='DESTINATION' AND TYPE!='CHECK POINT' ORDER BY Route_sequence ";

public static final String SAVE_INFO_DETAILS = " insert into ROUTE_CHECKPOINT_DETAILS (ROUTE_ID,NAME,REMARKS,ALERT_TYPE,ALERT_RADIUS,RADIUS,LATITUDE,LONGITUDE) " + 
		" values(?,?,?,?,?,?,?,?)";

public static final String GET_MARKER_LATLNG = " select * from ROUTE_CHECKPOINT_DETAILS where ROUTE_ID=? ";

public static final String GET_VEHICLE_COUNT_IN_HUB = "select count(*) as vehCount from gpsdata_history_latest gps"+
" inner join Vehicle_User vu on vu.System_id=gps.System_id and vu.Registration_no=gps.REGISTRATION_NO and vu.User_id=?"+
" where gps.System_id=? and gps.CLIENTID=? and (lower(gps.LOCATION) like 'inside%') and gps.HUB_ID=?"+
" union all"+
" select count(*) vehCount from gpsdata_history_latest gps"+
" inner join Vehicle_User vu on vu.System_id=gps.System_id and vu.Registration_no=gps.REGISTRATION_NO and vu.User_id=?"+
" where gps.System_id=? and gps.CLIENTID=? and (lower(gps.LOCATION) like 'inside%') and gps.HUB_ID not in (?)";

public static final String GET_ATM_REPLENISHMENT_DETAILS = " select isnull(b.BUSINESS_ID,'') as BUSINESS_ID,isnull(a.DATE,'') as AtmRepDate,isnull(tp.ASSET_NUMBER,'') as VehicleNo," +
		" (isnull(d.Fullname,'')+' '+isnull(d.LastName,'')) as DriverName,(isnull(c1.Fullname,'')+' '+isnull(c1.LastName,'')) as CustodianName1," +
		" (isnull(c2.Fullname,'')+' '+isnull(c2.LastName,'')) as CustodianName2,(isnull(e.NAME,'')+'-'+isnull(CAST(tp.TRIP_ID as varchar(15)),'')) as TripNo," +
		" isnull(b.BANK,'') as BusinessName,isnull(b.HUB_LOCATION,'') as Location,isnull(a.TOTAL_CASH_AMOUNT,0) as TOTAL_CASH_AMOUNT " +
		" from AMS.dbo.CASH_DESPENSE_DETAILS a" +
		" left outer join AMS.dbo.CVS_BUSINESS_DETAILS b on a.BUSINESS_ID =b.ID  and a.CUSTOMER_ID=b.CUSTOMER_ID " +
		" left outer join AMS.dbo.TRIP_PLANNER tp on a.TRIP_SHEET_NO = tp.TRIP_SHEET_NO  and a.CUSTOMER_ID=tp.CUSTOMER_ID " +
		" left outer join AMS.dbo.Driver_Master c1 on c1.Driver_id = tp.CUSTODIAN_NAME1 and c1.Client_id=tp.CUSTOMER_ID and c1.EmploymentType=8" +
		" left outer join AMS.dbo.Driver_Master c2 on c2.Driver_id = tp.CUSTODIAN_NAME2  and c2.Client_id=tp.CUSTOMER_ID and c2.EmploymentType=8" +
		" left outer join AMS.dbo.Driver_Master d on d.Driver_id = tp.DRIVER_ID and d.Client_id=tp.CUSTOMER_ID and d.EmploymentType=1" +
		" left outer join ADMINISTRATOR.dbo.CUSTOMER_MASTER e on tp.CUSTOMER_ID=e.CUSTOMER_ID " +
		" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and INSERTED_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?)" +
		" and tp.STATUS = 'Closed' and a.CUSTOMER_TYPE='ATM Replenishment' # " +
		" order by INSERTED_DATE desc";

public static final String GET_TRIP_OPERATION_DETAILS = " select (isnull(b.NAME,'')+'-'+isnull(CAST(a.TRIP_ID as varchar(15)),'')) as TripNo,isnull(a.ROUTE_NAME,'') as RouteName," +
		" isnull(a.ASSET_NUMBER,'') as ASSET_NUMBER,(isnull(d.Fullname,'')+' '+isnull(d.LastName,'')) as DriverName,(isnull(g1.Fullname,'')+' '+isnull(g1.LastName,'')) as GunMan1, " +
		" (isnull(g2.Fullname,'')+' '+isnull(g2.LastName,'')) as GunMan2,isnull(dateadd(mi,?,a.TRIP_START_DATETIME),'') as TripStartDate," +
		" isnull(dateadd(mi,?,a.TRIP_CLOSED_DATETIME),'') as TripClosedDate,(isnull(c1.Fullname,'')+' '+isnull(c1.LastName,'')) as CustodianName1," +
		" isnull(a.OPENING_ODOMETER,0) as OpeningOdometer,isnull(a.CLOSING_ODOMETER,0) as CLOSING_ODOMETER,isnull((isnull(a.CLOSING_ODOMETER,0)-isnull(a.OPENING_ODOMETER,0)),0) as DistanceTravelled" +
		" from AMS.dbo.TRIP_PLANNER a" +
		" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
		" left outer join AMS.dbo.Driver_Master d on d.Driver_id=a.DRIVER_ID and d.Client_id=a.CUSTOMER_ID and d.EmploymentType=1" +
		" left outer join AMS.dbo.Driver_Master g1 on g1.Driver_id=a.GUNMAN1 and g1.Client_id=a.CUSTOMER_ID and g1.EmploymentType=2 " +
		" left outer join AMS.dbo.Driver_Master g2 on g2.Driver_id=a.GUNMAN2 and g2.Client_id=a.CUSTOMER_ID and g2.EmploymentType=2" +
		" left outer join AMS.dbo.Driver_Master c1 on c1.Driver_id = a.CUSTODIAN_NAME1 and c1.Client_id=a.CUSTOMER_ID and c1.EmploymentType=8" +
		" where a.SYSTEM_ID = ? and a.CUSTOMER_ID=? and a.TRIP_CLOSED_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)" +
		" and a.STATUS = 'Closed' # order by TRIP_CLOSED_DATETIME desc ";

public static final String GET_QUOTATION_DETAILS = "select isnull(QUOTATION_NO,'') as QUOTATION_NO,isnull(VALID_FROM,'') as VALID_FROM,isnull(VALID_TO,'') as VALID_TO," +
		" isnull(LOCATION,'') as LOCATION,isnull(QUOTE_FOR,'') as QUOTE_FOR,isnull(CUSTOMER_NAME,'') as CUSTOMER_NAME," +
		" isnull(TARIFF_TYPE,'') as TARIFF_TYPE,isnull(TARIFF_AMOUNT,0) as TARIFF_AMOUNT,isnull(QUOTATION_STATUS,'') as QUOTATION_STATUS," +
		" isnull((b.Firstname+ ' ' +b.Lastname),'') as APPROVED_OR_REJECTED_BY,isnull(REASON,'') as REASON" +
		" from dbo.QUOTATION_MASTER a" +
		" left outer join AMS.dbo.Users b on b.User_id=a.APPROVED_OR_REJECTED_BY and b.System_id=a.SYSTEM_ID" +
		" where SYSTEM_ID =? and CUSTOMER_ID =? and INSERTED_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)" +
		"  # order by INSERTED_DATETIME desc ";

public static final String GET_ARMORY_OPERATION_DETAILS = " select isnull(dateadd(mi,330,b.CREATED_DATE),'') as CreatedDate,isnull(b.ASSET_NUMBER,'') as VehicleNo," +
		" (isnull(d.Fullname,'')+' '+isnull(d.LastName,'')) as DriverName, " +
		" (isnull(c1.Fullname,'')+' '+isnull(c1.LastName,'')) as CustodianName1," +
		" (isnull(c.NAME,'')+'-'+isnull(CAST(a.TRIP_NO as varchar(15)),'')) as TripId,isnull(b.ROUTE_NAME,'') as RouteName," +
		" isnull(a.ASSET_NO,'') as AssetNo " +
		" from  dbo.ON_TRIP_ARMORY a" +
		" inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER c on a.CLIENT_ID=c.CUSTOMER_ID and a.SYSTEM_ID=c.SYSTEM_ID " +
		" left outer join AMS.dbo.TRIP_PLANNER b on a.TRIP_NO = b.TRIP_ID and a.CLIENT_ID = b.CUSTOMER_ID" +
		" left outer join AMS.dbo.Driver_Master d on d.Driver_id=b.DRIVER_ID and d.Client_id=b.CUSTOMER_ID and d.EmploymentType=1" +
		" left outer join AMS.dbo.Driver_Master c1 on c1.Driver_id = b.CUSTODIAN_NAME1 and c1.Client_id=b.CUSTOMER_ID and c1.EmploymentType=8" +
		" where a.SYSTEM_ID=? and CLIENT_ID=? and CREATED_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) # order by CREATED_DATE desc ";

public static final String GET_CREW_DETAILS = " select Driver_id as Id, (isnull(Fullname,'')+' '+isnull(LastName,'')) as CrewName,EmploymentType = (case EmploymentType when 1 then 'Driver' when 2 then 'Gun Man' when 8 then 'Custodian' else 'Other' end)" +
		" from AMS.dbo.Driver_Master where  System_id=? and Client_id=? and EmploymentType in (1,8,2)";

public static final String GET_VEHICLE_DETAILS = " select REGISTRATION_NUMBER as VehicleNo from AMS.dbo.tblVehicleMaster tb " +
		" inner join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id " +
		" inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id " +
		" where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? ";

public static final String GET_BUSINESS_DETAILS = " select ID,BUSINESS_ID from AMS.dbo.CVS_BUSINESS_DETAILS where  SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String GET_TRIP_NO_DETAILS = " select a.TRIP_ID,(isnull(b.NAME,'')+'-'+isnull(CAST(a.TRIP_ID as varchar(15)),'')) as TripNo " +
		" from AMS.dbo.TRIP_PLANNER a inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID " +
		" where a.SYSTEM_ID = ? and a.CUSTOMER_ID=? and a.STATUS = 'Closed' ";

public static final String GET_QUOTATION_NO_DETAILS = " select QUOTATION_ID,QUOTATION_NO FROM AMS.dbo.QUOTATION_MASTER where SYSTEM_ID =?  and CUSTOMER_ID =? order by INSERTED_DATETIME desc ";

//************************************* t4u506 **********************************************************//

public static final String getCustomerNames = " select CustomerName,CustomerId from LMS.dbo.Customer_Information where SystemId = ?  and  ClientId = ?  ";

public static final String getDeliveryLocation = " select ID,(BUSINESS_ID+'('+HUB_LOCATION+')') as Business from CVS_BUSINESS_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and CVS_CUSTOMER_ID=?";

public static final String GET_VEHICLE_WISE_DETAILS = " select  isnull(tp.ASSET_NUMBER,'') as AssetNumber ,isnull(b.BUSINESS_ID,'') as  BussinessId,	" +
	 " isnull(BUSINESS_TYPE,'') as BusinessType,isnull(a.TR_NUMBER,'') as trNumber,isnull(BANK,'') as BankName,isnull(b.ADDRESS,'') as Address,isnull(b.LOCATION,'') as LOCATION,isnull(b.HUB_LOCATION,'') as Hub ," +
	 " isnull(CREATED_DATE,'') as CreatedDate,isnull(c.CustomerName,'') as delivaryCustomerName " +
	 " from AMS.dbo.CASH_DESPENSE_DETAILS a "+
	 " left outer join AMS.dbo.CVS_BUSINESS_DETAILS b on a.BUSINESS_ID =b.ID  and a.CUSTOMER_ID=b.CUSTOMER_ID "+
	 " left outer join AMS.dbo.TRIP_PLANNER tp on a.TRIP_SHEET_NO = tp.TRIP_SHEET_NO  and a.CUSTOMER_ID=tp.CUSTOMER_ID "+ 
	 " left outer join ADMINISTRATOR.dbo.CUSTOMER_MASTER e on tp.CUSTOMER_ID=e.CUSTOMER_ID "+
	 " left outer join LMS.dbo.Customer_Information c on a.DELIVERY_CUSTOMER_ID =c.CustomerId "+
	 " where a.SYSTEM_ID=? and b.CUSTOMER_ID=? and tp.CREATED_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) # order by tp.CREATED_DATE desc ";

//************************************* t4u506 **********************************************************//

}