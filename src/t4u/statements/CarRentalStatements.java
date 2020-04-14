package t4u.statements;

/**
 * @author amith.n
 * 
 */
public class CarRentalStatements {

	
	public final static String GET_ALERT_NAMES= " select AlertId, AlertName from Alert_Master_Details where SystemId=? "+
													 " and AlertId in (2,39,84,3,145,85)  " +
													 "order by CASE AlertName "+
													 "WHEN 'OverSpeed' THEN '1' "+
													 "WHEN 'Continues Running' THEN '2' "+
													 "WHEN 'Idle' THEN '3' "+
													 "WHEN 'Parking Alert' THEN '4' "+
													 "WHEN 'Vault Alert' THEN '5' "+
													 "WHEN 'Detention Alert' THEN '6' "+
													 "ELSE AlertName END ASC";

	public static final String GET_ALERT_COUNT =" select r.TYPE_OF_ALERT,sum(r.ALERT_COUNT) as  ALERT_COUNT from " +
												" (select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as ALERT_COUNT from AMS.dbo.Alert a (nolock) " +
												" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? " + 
												" where a.SYSTEM_ID=?  and a.CLIENTID=? "  + 
												" and a.TYPE_OF_ALERT in (145,39,84,85,139) "  +
												" and a.GMT >= dateadd(hh,-48,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') "  +
												" group by a.TYPE_OF_ALERT "  +
												" union all " +
												" select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as ALERT_COUNT from AMS.dbo.Alert_History a (nolock) "  +
												" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? " + 
												" where a.SYSTEM_ID=?  and a.CLIENTID=? " + 
												" and a.TYPE_OF_ALERT in (145,39,84,85,139) "  +
												" and a.GMT >= dateadd(hh,-48,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') "  +
												" group by a.TYPE_OF_ALERT ) r group by r.TYPE_OF_ALERT order by r.TYPE_OF_ALERT desc " ;
	
	public static final String GET_ALERT_COUNT_NON_COMMUNICATING =" select r.TYPE_OF_ALERT,sum(r.ALERT_COUNT) as  ALERT_COUNT from " +
	" (select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as ALERT_COUNT from AMS.dbo.Alert a (nolock) " +
	" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? " + 
	" where a.SYSTEM_ID=?  and a.CLIENTID=? "  + 
	" and a.TYPE_OF_ALERT in (145,85,148) "  +
	" and a.GMT >= dateadd(hh,-48,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') "  +
	" group by a.TYPE_OF_ALERT "  +
	" union all " +
	" select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as ALERT_COUNT from AMS.dbo.Alert_History a (nolock) "  +
	" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? " + 
	" where a.SYSTEM_ID=?  and a.CLIENTID=? " + 
	" and a.TYPE_OF_ALERT in (145,85,148) "  +
	" and a.GMT >= dateadd(hh,-48,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') "  +
	" group by a.TYPE_OF_ALERT ) r group by r.TYPE_OF_ALERT order by r.TYPE_OF_ALERT desc " ;

    public static final String GET_OVER_SPEED_ALERT_COUNT = " select sum(r.ALERT_COUNT) as ALERT_COUNT from (select count(a.REGISTRATION_NO) as ALERT_COUNT from ALERT.dbo.OVER_SPEED_DATA a   " +
												    		" inner join AMS.dbo.Vehicle_User v on a.SYSTEM_ID=v.System_id and a.REGISTRATION_NO = v.Registration_no collate database_default " +
												    		" where GMT >= dateadd(hh,-48,getutcdate()) and a.CUSTOMER_ID=?  and a.SYSTEM_ID=? and v.User_id=? " +
												    		" and REMARK is  null  " +
												    		" union all   " +
												    		" select count(a.REGISTRATION_NO) as ALERT_COUNT from ALERT.dbo.OVER_SPEED_DATA_HISTORY a  " +
												    		" inner join AMS.dbo.Vehicle_User v on a.SYSTEM_ID=v.System_id and a.REGISTRATION_NO = v.Registration_no collate database_default " +
												    		" where GMT >= dateadd(hh,-48,getutcdate()) and a.CUSTOMER_ID=?  and a.SYSTEM_ID=? and v.User_id=? " +
												    		" and REMARK is  null)r " ;


	public static final String GET_DISTRESS_COUNT =     " select sum(r.ALERT_COUNT) as ALERT_COUNT from " +
												        " (select count(a.REGISTRATION_NO) as ALERT_COUNT from ALERT.dbo.PANIC_DATA a "  +
														" inner join AMS.dbo.Vehicle_User v on a.SYSTEM_ID=v.System_id and a.REGISTRATION_NO = v.Registration_no collate database_default " +
														" where GMT >= dateadd(hh,-48,getutcdate()) and a.CUSTOMER_ID=?  and a.SYSTEM_ID=? and v.User_id=? " +
														" and REMARK is null " +
														" union all  " +
														" select count(a.REGISTRATION_NO) as ALERT_COUNT from ALERT.dbo.PANIC_DATA_HISTORY a " +
														" inner join AMS.dbo.Vehicle_User v on a.SYSTEM_ID=v.System_id and a.REGISTRATION_NO = v.Registration_no collate database_default  " +
														" where GMT >= dateadd(hh,-48,getutcdate()) and a.CUSTOMER_ID=?  and a.SYSTEM_ID=? and v.User_id=? " +
														" and REMARK is null)r " ;

	
	public static final String GET_TOTAL_ASSET_COUNT =  " select count(*) as COUNT from AMS.dbo.gpsdata_history_latest a " +
																 " inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id " +
																 " where a.System_id = ? and a.CLIENTID = ? and b.User_id=?";

	public static final String GET_NON_COMMUNICATING=  " select count(*) as NON_COMMUNICATING from AMS.dbo.gpsdata_history_latest a " +
																" inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " +
																" where a.CLIENTID=? and  a.System_id=? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= ? and b.User_id=?";
	
	
	public static final String GET_NOGPS_VEHICLES= " select count(*) as NOGPS from AMS.dbo.gpsdata_history_latest a " +
															" inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	+
															" where a.CLIENTID=? and a.System_id=? and a.LOCATION ='No GPS Device Connected' and b.User_id=?";

    

   public static final String GET_CVS_DASHBOARD_SETTING="select ALERT_ID,ALERT_NAME_LABEL_ID from AMS.dbo.CASH_VAN_DASHBOARD_SETTING " +
														"where ALERT_NAME_LABEL_ID in('VEHICLE_ON_OFF_ROAD','STATUTORY-BARCHART','PREVENTIVEMAINTAINACE-PIECHART','TOTAL_ASSET','COMMUNICATING','NONCOMMUNICATING','NO_GPS') " +
														"and SYSTEM_ID=? order by ORDER_OF_ALERT";
   
	public static final String PREVENTIVE_EXPIRED_FROM_PREVENTIVE_EVENTS = " select (select count(ASSET_NUMBER) from FMS.dbo.PREVENTIVE_EVENTS a inner join AMS.dbo.Vehicle_User c on "
		+ " c.Registration_no=a.ASSET_NUMBER collate database_default and c.System_id=a.SYSTEM_ID  where System_Id=? and "
		+ " CUSTOMER_ID =? AND ALERT_TYPE = 1 and c.User_id=? and EVENT_DATE between (select convert(varchar(10),DATEADD (DAY,-90,convert(varchar(10), getdate(), 120)),120)) "
		+ " and (select convert(varchar(10), getdate(), 120))) "
		+ " - (select count(ASSET_NUMBER) from FMS.dbo.PREVENTIVE_EVENTS a inner join AMS.dbo.Vehicle_User c on c.Registration_no=a.ASSET_NUMBER " 
		+ " collate database_default and c.System_id=a.SYSTEM_ID  where System_Id=? and datediff(dd,getDate(),POSTPONE_DATE)>= 0 "   
		+ " and CUSTOMER_ID = ? AND ALERT_TYPE = 1 and c.User_id=? and EVENT_DATE between (select convert(varchar(10),DATEADD (DAY,-90,convert(varchar(10), getdate(), 120)),120)) "
		+ " and (select convert(varchar(10), getdate(), 120))) "
		+ " PREVENTIVE_EXPIRED ";

	public static final String PREVENTIVE_DUE_FOR_EXPIRY_FROM_PREVENTIVE_EVENTS = "select count(ASSET_NUMBER) as PREVENTIVE_DUR_FOR_EXPIRED  from FMS.dbo.PREVENTIVE_EVENTS a "+
    "inner join AMS.dbo.Vehicle_User c on c.Registration_no=a.ASSET_NUMBER collate database_default and c.System_id=a.SYSTEM_ID "+ 
    "where System_Id=? and CUSTOMER_ID =?  AND ALERT_TYPE = 2 and c.User_id=? ";


	public static final String GET_STATUTORY_ALERT_COUNT="select SUM(R.INSURANCE_DOE)AS INSURANCE_DOE,SUM(INSURANCE_EXP)AS INSURANCE_EXP, "+  
	 "SUM(R.GOODS_TOKEN_TAX_DOE)AS GOODS_TOKEN_TAX_DOE,SUM(R.GOODS_TOKEN_TAX_EXP)AS GOODS_TOKEN_TAX_EXP,   "+
	 "SUM(R.FCI_DOE)AS FCI_DOE,SUM(R.FCI_EXP)AS FCI_EXP,   "+
	 "SUM(R.EMISSION_DOE)AS EMISSION_DOE,SUM(R.EMISSION_EXP)AS EMISSION_EXP,  "+ 
	 "SUM(R.PERMIT_DOE)AS PERMIT_DOE,SUM(R.PERMIT_EXP)AS PERMIT_EXP,   "+
	 "SUM(R.REGISTRATION_DOE)AS REGISTRATION_DOE,SUM(R.REGISTRATION_EXP)AS REGISTRATION_EXP, "+
	 "SUM(R.ROAD_TAX_DOE)AS ROAD_TAX_DOE,SUM(R.ROAD_TAX_EXP)AS ROAD_TAX_EXP, " +
	 "SUM(R.STATE_TAX_DOE)AS STATE_TAX_DOE,SUM(R.STATE_TAX_EXP)AS STATE_TAX_EXP, " +
	 "SUM(R.DRIVER_LICENSE_DOE)AS DRIVER_LICENSE_DOE,SUM(R.DRIVER_LICENSE_EXP)AS DRIVER_LICENSE_EXP from "+
	 "(select SUM(CASE WHEN AlertId=10 THEN 1 ELSE 0 END)AS INSURANCE_DOE,SUM(CASE WHEN AlertId=32 THEN 1 ELSE 0 END)AS INSURANCE_EXP,  "+ 
	 "SUM(CASE WHEN AlertId=11 THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_DOE,SUM(CASE WHEN AlertId=33 THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_EXP,   "+
	 "SUM(CASE WHEN AlertId=12 THEN 1 ELSE 0 END)AS FCI_DOE,SUM(CASE WHEN AlertId=34 THEN 1 ELSE 0 END)AS FCI_EXP,   "+
	 "SUM(CASE WHEN AlertId=13 THEN 1 ELSE 0 END)AS EMISSION_DOE,SUM(CASE WHEN AlertId=35 THEN 1 ELSE 0 END)AS EMISSION_EXP,   "+
	 "SUM(CASE WHEN AlertId=15 THEN 1 ELSE 0 END)AS PERMIT_DOE,SUM(CASE WHEN AlertId=36 THEN 1 ELSE 0 END)AS PERMIT_EXP, "+ 
	 "SUM(CASE WHEN AlertId=130 THEN 1 ELSE 0 END)AS REGISTRATION_DOE,SUM(CASE WHEN AlertId=131 THEN 1 ELSE 0 END)AS REGISTRATION_EXP, "+
	 "SUM(CASE WHEN AlertId=140 THEN 1 ELSE 0 END)AS ROAD_TAX_DOE,SUM(CASE WHEN AlertId=141 THEN 1 ELSE 0 END)AS ROAD_TAX_EXP, " +
	 "SUM(CASE WHEN AlertId=142 THEN 1 ELSE 0 END)AS STATE_TAX_DOE,SUM(CASE WHEN AlertId=143 THEN 1 ELSE 0 END)AS STATE_TAX_EXP, " +
	 "SUM(CASE WHEN AlertId=66 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_DOE,SUM(CASE WHEN AlertId=67 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_EXP   "+ 
	 "from dbo.StatutoryAlert where UpdatedDate> dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  ClientId=? and SystemId=? "+
	 "union all "+
	 "select SUM(CASE WHEN AlertId=10 THEN 1 ELSE 0 END)AS INSURANCE_DOE,SUM(CASE WHEN AlertId=32 THEN 1 ELSE 0 END)AS INSURANCE_EXP,   "+
	 "SUM(CASE WHEN AlertId=11 THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_DOE,SUM(CASE WHEN AlertId=33 THEN 1 ELSE 0 END)AS GOODS_TOKEN_TAX_EXP,  "+ 
	 "SUM(CASE WHEN AlertId=12 THEN 1 ELSE 0 END)AS FCI_DOE,SUM(CASE WHEN AlertId=34 THEN 1 ELSE 0 END)AS FCI_EXP,   "+
	 "SUM(CASE WHEN AlertId=13 THEN 1 ELSE 0 END)AS EMISSION_DOE,SUM(CASE WHEN AlertId=35 THEN 1 ELSE 0 END)AS EMISSION_EXP,  "+ 
	 "SUM(CASE WHEN AlertId=15 THEN 1 ELSE 0 END)AS PERMIT_DOE,SUM(CASE WHEN AlertId=36 THEN 1 ELSE 0 END)AS PERMIT_EXP, "+ 
	 "SUM(CASE WHEN AlertId=130 THEN 1 ELSE 0 END)AS REGISTRATION_DOE,SUM(CASE WHEN AlertId=131 THEN 1 ELSE 0 END)AS REGISTRATION_EXP,   "+
	 "SUM(CASE WHEN AlertId=140 THEN 1 ELSE 0 END)AS ROAD_TAX_DOE,SUM(CASE WHEN AlertId=141 THEN 1 ELSE 0 END)AS ROAD_TAX_EXP, " +
	 "SUM(CASE WHEN AlertId=142 THEN 1 ELSE 0 END)AS STATE_TAX_DOE,SUM(CASE WHEN AlertId=143 THEN 1 ELSE 0 END)AS STATE_TAX_EXP, " +
	 "SUM(CASE WHEN AlertId=66 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_DOE,SUM(CASE WHEN AlertId=67 THEN 1 ELSE 0 END)AS DRIVER_LICENSE_EXP   "+ 
	 "from dbo.StatutoryAlertHistory where UpdatedDate> dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  ClientId=? and SystemId=?) R";
	
	public static final String SAVE_ALERT_REMARK=" update dbo.Alert set MONITOR_STATUS=?,ACTION_TAKEN=?,UPDATED_BY=? where SLNO = ? and REGISTRATION_NO=? and TYPE_OF_ALERT=? and CLIENTID=? and SYSTEM_ID=?";

	public static final String SAVE_ALERT_HISTORY_REMARK=" update AMS.dbo.Alert_History set MONITOR_STATUS=?,ACTION_TAKEN=?,UPDATED_BY=? where SLNO = ? and REGISTRATION_NO=? and TYPE_OF_ALERT=? and CLIENTID=? and SYSTEM_ID=?";

	public static final String SAVE_OVERSPEED_REMARKS="update ALERT.dbo.OVER_SPEED_DATA set REMARK=? where ID=? and REGISTRATION_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String SAVE_OVERSPEED_HISTORY_REMARKS="update ALERT.dbo.OVER_SPEED_DATA_HISTORY set REMARK=? where ID=? and REGISTRATION_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String SAVE_DISTRESS_REMARKS="update ALERT.dbo.PANIC_DATA set REMARK=? where ID=? and REGISTRATION_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String SAVE_HUB_ALERT_REMARKS="update ALERT.dbo.HUB_ALERTS set REMARK=? where ID=? and REGISTRATION_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
public static final String SAVE_HUB_ALERT_HISTORY_REMARKS="update ALERT.dbo.HUB_ALERTS_HISTORY set REMARK=? where ID=? and REGISTRATION_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String SAVE_DISTRESS_HISTORY_REMARKS="update ALERT.dbo.PANIC_DATA_HISTORY set REMARK=? where ID=? and REGISTRATION_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String UPDATE_HUB_ALERT="update ALERT.dbo.HUB_ALERTS set REMARK=? where ID=? and SYSTEM_ID=? and CUSTOMER_ID=? and TYPE_OF_ALERT=?";
	
	public static final String GET_ALERT_DETAILS =      " select a.SLNO,MONITOR_STATUS,a.REGISTRATION_NO,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isnull(dateadd(mi,?,a.GMT),'') as GMT, " +
														" a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID,'Alert' as ALERT_TYPE from AMS.dbo.Alert a " +
														" inner join Vehicle_User b on a.SYSTEM_ID=b.System_id and a.REGISTRATION_NO = b.Registration_no " +
														" where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT= ? and 	 " +										
														" a.GMT >= dateadd(hh,-48,getutcdate()) " +
														" and b.User_id=? and  (MONITOR_STATUS is null or MONITOR_STATUS='N') " +
														" union all " +
														" select a.SLNO,MONITOR_STATUS,a.REGISTRATION_NO,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isnull(dateadd(mi,?,a.GMT),'') as GMT, " +
														" a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID,'History' as ALERT_TYPE from AMS.dbo.Alert_History a " +
														" inner join Vehicle_User b on a.SYSTEM_ID=b.System_id and a.REGISTRATION_NO = b.Registration_no " +
														" where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT= ? and " +										
														" a.GMT >= dateadd(hh,-48,getutcdate()) " +
														" and b.User_id=? and  (MONITOR_STATUS is null or MONITOR_STATUS='N') " +
														" order by GPS_DATETIME desc " ;

	public static final String GET_NON_COMMUNICATING_ALERT_DETAILS =      " select a.SLNO,MONITOR_STATUS,a.REGISTRATION_NO,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isnull(dateadd(mi,?,a.GMT),'') as GMT, " +
	" a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID,'Alert' as ALERT_TYPE from AMS.dbo.Alert a " +
	" inner join Vehicle_User b on a.SYSTEM_ID=b.System_id and a.REGISTRATION_NO = b.Registration_no " +
	" where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT= ? and 	 " +										
	" a.GMT >= dateadd(hh,-48,getutcdate()) " +
	" and b.User_id=? and (MONITOR_STATUS is null or MONITOR_STATUS='N')" +
	" union all " +
	" select a.SLNO,MONITOR_STATUS,a.REGISTRATION_NO,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isnull(dateadd(mi,?,a.GMT),'') as GMT, " +
	" a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID,'History' as ALERT_TYPE from AMS.dbo.Alert_History a " +
	" inner join Vehicle_User b on a.SYSTEM_ID=b.System_id and a.REGISTRATION_NO = b.Registration_no " +
	" where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT= ? and " +										
	" a.GMT >= dateadd(hh,-48,getutcdate()) " +
	" and b.User_id=?  and (MONITOR_STATUS is null or MONITOR_STATUS='N')" +
	" order by GPS_DATETIME desc " ;
	
	public static final String GET_OVER_SPEED_ALERT =   " select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,a.GMT as [GMT], " +
														" GPS_DATETIME,a.LOCATION,isnull(a.SPEED, 0) as SPEED,isnull(a.REMARK,'') as REMARKS,a.SPEED as OVERSPEED, " +
														" 2 as TYPE_OF_ALERT,'Alert' as ALERT_TYPE from ALERT.dbo.OVER_SPEED_DATA a inner join AMS.dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default   " +
														" inner join AMS.dbo.Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no " +
														" where GMT >= dateadd(hh,-48,getutcdate()) and a.CUSTOMER_ID=?  and b.SYSTEM_ID=? and v.User_id=? " +
														" and REMARK is null " +
														" union all " +
														" select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,a.GMT as [GMT], " +
														" GPS_DATETIME,a.LOCATION,isnull(a.SPEED, 0) as SPEED,isnull(a.REMARK,'') as REMARKS,a.SPEED as OVERSPEED, " +
														" 2 as TYPE_OF_ALERT,'History' as ALERT_TYPE from ALERT.dbo.OVER_SPEED_DATA_HISTORY a inner join AMS.dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default  " +
														" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no " +
														" where GMT >= dateadd(hh,-48,getutcdate()) and a.CUSTOMER_ID=?  and b.SYSTEM_ID=? and v.User_id=? " +
														" and REMARK is null order by GPS_DATETIME desc ";

	public static final String GET_DISTRESS_ALERT_DETAILS =  " select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,a.GMT as [GMT],a.LOCATION,a.TYPE_OF_ALERT " +
															 " as TYPE_OF_ALERT,'Alert' as ALERT_TYPE ,REMARK as REMARKS from ALERT.dbo.PANIC_DATA a " +
															 " inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no collate database_default " +
															 " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT=? and a.GMT >= dateadd(hh,-48,getutcdate()) " +
															 " and b.User_id=? and REMARK is null " +
															 " union all " +
															 " select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,a.GMT as [GMT],a.LOCATION,a.TYPE_OF_ALERT as TYPE_OF_ALERT," +
															 " 'History' as ALERT_TYPE,REMARK as REMARKS from ALERT.dbo.PANIC_DATA_HISTORY a " +
															 " inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no collate database_default " +
															 " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT=? and a.GMT >= dateadd(hh,-48,getutcdate()) " +
															 " and  b.User_id=? and REMARK is null order by GMT desc " ;

	
		
   public static final String GET_IMMOBILIZED_DATA =    " select count(DEVICE_ID) as COUNT from AMS.dbo.Data_Out a" +
														" inner join AMS.dbo.gpsdata_history_latest c on c.UNIT_NO=a.DEVICE_ID collate database_default  " +
													    " inner join AMS.dbo.Vehicle_User d on d.Registration_no=c.REGISTRATION_NO  " +
														" where a.PACKET_TYPE='IO3' and a.PACKET_MODE='SET' and a.PACKET_PARAMS='success' and a.IP_ADDRESS='1' " +
														" and DEVICE_ID collate database_default in (select Unit_Number " +
														" from AMS.dbo.Vehicle_association where System_id=? and Client_id=?) " +
														" and INSERTED_DATETIME>=dateadd(hh,-48,getutcdate()) and d.User_id=?";

	public static final String GET_HIGH_USAGE_DATA = " select count(*) as COUNT from AMS.dbo.VehicleSummaryData a " +
													 " inner join AMS.dbo.Vehicle_User b on b.System_id=a.SystemId and b.Registration_no=a.RegistrationNo " +
													 " where SystemId=? and ClientId=? and b.User_id=? " +
													 " and DateGMT= dateadd(mi,-?,dateadd(dd,-1,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0))) " +
													 " and TotalDistanceTravelled>300 ";
	
	public static final String GET_VOLTAGE_DRAIN = " Select count(*) as COUNT from AMS.dbo.gpsdata_history_latest a "+
													 " inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "+
													 " where a.System_id = ? and a.CLIENTID = ? and b.User_id=? AND MAIN_BATTERY_VOLTAGE BETWEEN 2 AND 7 ";
														
	public static final String GET_VOLTAGE_DRAIN_DETAILS =	" Select REGISTRATION_NO,isnull(LOCATION,'') as LOCATION,isnull(DRIVER_NAME,'') as DRIVER_NAME,isnull(DRIVER_MOBILE,'') as DRIVER_MOBILE , MAIN_BATTERY_VOLTAGE as VOLTAGE from gpsdata_history_latest a "+
													" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "+
													" where a.System_id = ? and a.CLIENTID = ? and b.User_id=? AND MAIN_BATTERY_VOLTAGE BETWEEN 2 AND 7 ";
	
	public static final String GET_HIGH_USAGE_DETAILS=  " select c.REGISTRATION_NO,ISNULL(a.TotalDistanceTravelled,0)AS TotalDistanceTravelled,ISNULL(c.DRIVER_NAME,'')AS DRIVER_NAME, ISNULL(e.GROUP_NAME,'') AS GROUP_NAME from AMS.dbo.VehicleSummaryData a "+
														" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SystemId and b.Registration_no=a.RegistrationNo  "+
														" inner join AMS.dbo.gpsdata_history_latest c on c.REGISTRATION_NO=b.Registration_no  "+
														" inner join AMS.dbo.Live_Vision_Support e on e.REGISTRATION_NO=c.REGISTRATION_NO "+
														" where SystemId=? and ClientId=? and b.User_id=?  "+
														" and DateGMT = dateadd(mi,-?,dateadd(dd,-1,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0))) "+
														" and TotalDistanceTravelled > 300 ";

	public static final String GET_IMMOBILIZED_DETAILS= " select DEVICE_ID,c.REGISTRATION_NO,isnull(c.DRIVER_NAME,'') as DRIVER_NAME ,isnull(c.LOCATION,'') as LOCATION,isnull(c.DRIVER_NAME,'') as DRIVER_NAME,c.GPS_DATETIME,isnull(e.GROUP_NAME,'') as GROUP_NAME from AMS.dbo.Data_Out a "+
														" inner join AMS.dbo.gpsdata_history_latest c on c.UNIT_NO=a.DEVICE_ID collate database_default "+
														" inner join AMS.dbo.Vehicle_User d on d.Registration_no=c.REGISTRATION_NO  "+
														" left outer join AMS.dbo.Live_Vision_Support e on e.REGISTRATION_NO=c.REGISTRATION_NO "+
														" where a.PACKET_TYPE='IO3' and PACKET_MODE='SET' and PACKET_PARAMS='success' and a.IP_ADDRESS='1'  "+
														" and DEVICE_ID collate database_default in (select Unit_Number from dbo.Vehicle_association where System_id=? and Client_id=?) "+ 
														" and INSERTED_DATETIME>=dateadd(hh,-48,getutcdate()) and d.User_id=?";
	
	public static final String GET_UNDER_MAINTANCE_COUNT =  " select HUBID from AMS.dbo.LOCATION_ZONE where SYSTEMID=?  and CLIENTID=? and OPERATION_ID=18 " ;
	
	public static final String GET_STATUTORY_STATEWISE_COUNT_FOR_STATE_TAX =  " select isnull(a.DriverName,'Other') as STATE_NAME,COUNT(*) AS STATUTORY_COUNT " +
																" from AMS.dbo.StatutoryAlert a WITH(NOLOCK)   " +      
																" join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and " +
																" a.SystemId=b.SystemId where a.AlertId=? and a.ClientId=?  and a.SystemId=? " +
																" and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) group by a.DriverName " ;

	public static final String GET_STATUTORY_STATEWISE_COUNT =   " select isnull(s.STATE_NAME,'Other') as STATE_NAME,COUNT(*) AS STATUTORY_COUNT from dbo.StatutoryAlert a WITH(NOLOCK) " +         
																 " left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo " + 
																 " left outer join ADMINISTRATOR.dbo.ASSET_GROUP a1 on v1.GROUP_ID= a1.GROUP_ID  " + 
																 " left outer join ADMINISTRATOR.dbo.STATE_DETAILS s on a1.STATE=s.STATE_CODE  " +     
																 " join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId where a.AlertId=? and a.ClientId=?  and a.SystemId=?  and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))   group by s.STATE_NAME  ";

	public static final String GET_STATUTORY_ALERT_DETAILS="Select Slno as SLNO,a.VehicleNo as REGISTRATION_NO ,v2.GROUP_NAME as GROUP_NAME,a.AlertId as TYPE_OF_ALERT,a.AlertStartDate ,a.UpdatedDate,dateadd(mi,?,a.DueDate) as ALERT_DATE,a.ClientId,a.SystemId,isNull(a.DriverId ,'0') as [DRIVER NAME],a.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION from dbo.StatutoryAlert a WITH(NOLOCK) "+       
														   "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo left "+         
														   "outer join dbo.VEHICLE_GROUP v2 on v1.GROUP_ID= v2.GROUP_ID  "+        
														   "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId "+  
														   "inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on  a.ClientId= ag.CUSTOMER_ID and a.SystemId=ag.SYSTEM_ID and v2.GROUP_NAME collate database_default=ag.GROUP_NAME "+  
														   "where a.ClientId=? and a.SystemId=? and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and a.AlertId=?   and  "+   
														   "ag.STATE =(select STATE_CODE from ADMINISTRATOR.dbo.STATE_DETAILS where STATE_NAME=?) ";

	public static final String GET_STATUTORRY_STATEWISE_DETAILS_OTHERS =   "select Slno as SLNO,a.VehicleNo as REGISTRATION_NO ,a1.GROUP_NAME as GROUP_NAME,a.AlertId as TYPE_OF_ALERT,a.AlertStartDate ,a.UpdatedDate,dateadd(mi,?,a.DueDate) as ALERT_DATE,a.ClientId,a.SystemId,isNull(a.DriverId ,'0') as [DRIVER NAME],a.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION from dbo.StatutoryAlert a WITH(NOLOCK)  "+           
																		   "left outer join dbo.VEHICLE_CLIENT v1 on REGISTRATION_NUMBER=a.VehicleNo "+     
																		   "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a1 on v1.GROUP_ID= a1.GROUP_ID   "+    
																		   "left outer join ADMINISTRATOR.dbo.STATE_DETAILS s on a1.STATE=s.STATE_CODE  "+         
																		   "join dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId where  a.ClientId=?  and a.SystemId=?  and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))  and a.AlertId=? and s.STATE_NAME is null ";

	public static final String GET_STATUTORRY_STATEWISE_DETAILS_STATETAX =  " select Slno as SLNO,a.VehicleNo as REGISTRATION_NO ,a.AlertId as TYPE_OF_ALERT,v2.GROUP_NAME as GROUP_NAME,  " +
																			" a.AlertStartDate ,a.UpdatedDate,dateadd(mi,?,a.DueDate) as ALERT_DATE,a.ClientId,a.SystemId,  " +
																			" isNull(a.DriverId ,'0') as [DRIVER NAME],a.MONITOR_STATUS as REMARKS,b.AlertName,'' as SPEED,'' as LOCATION  " +
																			" from AMS.dbo.StatutoryAlert a WITH(NOLOCK)  " +
																			" inner join AMS.dbo.VEHICLE_CLIENT v1 on v1.SYSTEM_ID=a.SystemId and v1.CLIENT_ID=a.ClientId and v1.REGISTRATION_NUMBER=a.VehicleNo " +
																			" inner join ADMINISTRATOR.dbo.ASSET_GROUP v2 on v2.SYSTEM_ID=v1.SYSTEM_ID and v2.CUSTOMER_ID=v1.CLIENT_ID and v2.GROUP_ID=v1.GROUP_ID " +
																			" join AMS.dbo.Alert_Master_Details b WITH(NOLOCK)  on a.AlertId=b.AlertId and a.SystemId=b.SystemId    " +
																			" where a.ClientId=? and a.SystemId=? and a.UpdatedDate > dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) " +
																			" and a.AlertId=? and a.DriverName=? " ;
	public static final String GET_TRIP_EXCEPTION_REPORT = " select isnull(RA_ID,0) as Raid,isnull(BOOKING_ID,0) as BookingNo,isnull(DUTY_TYPE,'') as DutyType,isnull(REGISTRATION_NO,'') as RegistrationNo, " +
			" isnull(USER_NAME,'') as DriverName,isnull(USER_MOBILE,'') as MobileNo,isnull(dateadd(mi,?,SCHD_PICK_UP_DATE_TIME),'') as scheduledPickUpTime,isnull(STATUS,'') as Status, " +
			" (isnull(GI_GPS_DISTANCE,0) - isnull(GS_GPS_DISTANCE,0)) as g2gGPSKms,(isnull(GARAGE_IN_ODOMETER,0) - isnull(GARAGE_OUT_ODOMETER,0)) as g2godoKms, " +
			" (isnull(TE_GPS_DISTANCE,0) - isnull(TS_GPS_DISTANCE,0)) as p2pGPSKms,(isnull(DROP_UP_ODOMETER,0) - isnull(PICK_UP_ODOMETER,0)) as p2pOdoKms, " +
			" convert(varchar(30), (datediff(mi, isnull(ACTUAL_GARAGE_OUT_DATE_TIME,''), isnull(GARAGE_IN_DATE_TIME,'')) / 60)) + ' : ' + convert(varchar(30), (datediff(mi, isnull(ACTUAL_GARAGE_OUT_DATE_TIME,''), isnull(GARAGE_IN_DATE_TIME,'')) % 60)) as g2gTime, " +
			" convert(varchar(30), (datediff(mi, isnull(ACTUAL_PICK_UP_DATE_TIME,''), isnull(DROP_UP_DATE_TIME,'')) / 60)) + ' : ' + convert(varchar(30), (datediff(mi,isnull(ACTUAL_PICK_UP_DATE_TIME,''), isnull(DROP_UP_DATE_TIME,'')) % 60)) as p2pTime," +
			" isnull(VEHICLE_STATUS,'') as vehicleStatus,isNull(GOOGLE_JSON,'') as GoogleJson " +
			" from dbo.CAR_RENTAL_TRIP_DETAILS " +
			" where SYSTEM_ID=? and CUSTOMER_ID=? and SCHD_PICK_UP_DATE_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and STATUS = 'IN' order by SCHD_PICK_UP_DATE_TIME ";

	public static final String GET_JETFLEET_TRIP_REPORT_DETAILS ="select isnull(RA_ID,0) as RA_ID,isnull(BOOKING_ID,0) as BOOKING_ID,isnull(DUTY_TYPE,'') as DUTY_TYPE,isnull(REGISTRATION_NO,'') as REGISTRATION_NO, "+
			 "isnull(USER_NAME,'') as USER_NAME ,isnull(USER_MOBILE,'') as USER_MOBILE,isnull(dateadd(mi,?,SCHD_PICK_UP_DATE_TIME),'') as SCHD_PICK_UP_DATE_TIME,isnull(STATUS,'') as STATUS, "+
			 "isnull(GARAGE_IN_ODOMETER-GARAGE_OUT_ODOMETER,0) as G2G_ODO_KMS,isnull(GI_GPS_DISTANCE-GS_GPS_DISTANCE,0) as G2G_GPS_KMS,DATEDIFF(mi,isnull(ACTUAL_GARAGE_OUT_DATE_TIME,''),isnull(GARAGE_IN_DATE_TIME,'')) as G2G_GPS_TIME, "+
			 "isnull(TE_GPS_DISTANCE-TS_GPS_DISTANCE,0) as P2P_GPS_KMS,isnull(DROP_UP_ODOMETER-PICK_UP_ODOMETER,0) as P2P_ODO_KMS,DATEDIFF(mi,isnull(ACTUAL_PICK_UP_DATE_TIME,''),isnull(DROP_UP_DATE_TIME,'')) as P2P_GPS_TIME, "+
			 "isnull(dateadd(mi,?,ACTUAL_GARAGE_OUT_DATE_TIME),'') as ACTUAL_GARAGE_OUT_DATE_TIME,isnull(GARAGE_OUT_ODOMETER,0) as GARAGE_OUT_ODOMETER,isnull(dateadd(mi,?,ACTUAL_PICK_UP_DATE_TIME),'') as ACTUAL_PICK_UP_DATE_TIME, "+
			 "isnull(PICK_UP_ODOMETER,0) as PICK_UP_ODOMETER,isnull(dateadd(mi,?,DROP_UP_DATE_TIME),'') as DROP_UP_DATE_TIME,isnull(DROP_UP_ODOMETER,0) as DROP_UP_ODOMETER,isnull(dateadd(mi,?,GARAGE_IN_DATE_TIME),'') as GARAGE_IN_DATE_TIME, "+
			 "isnull(GARAGE_IN_ODOMETER,0) as GARAGE_IN_ODOMETER, "+
			 "GS_LATITUDE,GS_LONGITUDE,GS_GPS_DISTANCE, "+
			 "TS_LATITUDE,TS_LONGITUDE,TS_GPS_DISTANCE, "+
			 "TE_LATITUDE,TE_LONGITUDE,TE_GPS_DISTANCE, "+
			 "GI_LATITUDE,GI_LONGITUDE,GI_GPS_DISTANCE, "+
			 "isnull(FEEDBACK,'') as FEEDBACK,isnull(REMARK,'') as REMARK,isnull(COMMENTS,'') as COMMENTS "+ 
			 "from AMS.dbo.CAR_RENTAL_TRIP_DETAILS "+
			 "where SYSTEM_ID=? and CUSTOMER_ID=? and SCHD_PICK_UP_DATE_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by SCHD_PICK_UP_DATE_TIME ";
	
	public static final String GET_JETFLEET_EXCEPTION = "select isNull(DIST_EXCEPTION,'') as DistExcep from AMS.dbo.CAR_RENTAL_EXCEPTION " +
			"where SYSTEM_ID=? and CUSTOMER_ID=? and RA_ID=? and BILLING_TYPE=? ";
	
	public static final String GET_HUB_ARRIVAL_COUNT="select count(a.REGISTRATION_NO) as COUNT,a.TYPE_OF_ALERT as TYPE_OF_ALERT from ALERT.dbo.HUB_ALERTS a " +
	" inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default  and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CLIENT_ID  " +
	" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no AND a.System_id = b.SYSTEM_ID" +
    " inner join  dbo.LOCATION_ZONE_A c on c.HUBID=a.HUB_ID and c.SYSTEMID=a.SYSTEM_ID AND c.CLIENTID=a.CUSTOMER_ID " +
	" where a.SYSTEM_ID= ? and a.CUSTOMER_ID= ? and a.GMT >=dateadd(hh,-48,getutcdate()) and REMARK IS NULL " +
	" and v.User_id= ? and c.OPERATION_ID=18 " +
    " group by a.TYPE_OF_ALERT " +
    " union " +
    " select count(a.REGISTRATION_NO) as COUNT,a.TYPE_OF_ALERT as TYPE_OF_ALERT from ALERT.dbo.HUB_ALERTS_HISTORY a " +
	" inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default  and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CLIENT_ID  " +
	" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no AND a.System_id = b.SYSTEM_ID" +
    " inner join  dbo.LOCATION_ZONE_A c on c.HUBID=a.HUB_ID and c.SYSTEMID=a.SYSTEM_ID AND c.CLIENTID=a.CUSTOMER_ID " +
	" where a.SYSTEM_ID= ? and a.CUSTOMER_ID= ? and a.GMT >=dateadd(hh,-48,getutcdate()) and REMARK IS NULL " +
	" and v.User_id= ? and c.OPERATION_ID=18 " +
	" group by a.TYPE_OF_ALERT " ;
	
	public static final String GET_OFF_ROAD_COUNT =" select count(a.REGISTRATION_NO) as COUNT,a.TYPE_OF_ALERT as TYPE_OF_ALERT from ALERT.dbo.HUB_ALERTS a " +
	" inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default  and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CLIENT_ID  " +
	" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no AND a.System_id = b.SYSTEM_ID" +
    " inner join  dbo.LOCATION_ZONE_A c on c.HUBID=a.HUB_ID and c.SYSTEMID=a.SYSTEM_ID AND c.CLIENTID=a.CUSTOMER_ID " +
	" where a.SYSTEM_ID= ? and a.CUSTOMER_ID= ? and  a.GMT >=dateadd(hh,-48,getutcdate())  " +
	" and v.User_id= ? and c.OPERATION_ID = 23 " +
    " group by a.TYPE_OF_ALERT " +
    " union " +
    " select count(a.REGISTRATION_NO) as COUNT,a.TYPE_OF_ALERT as TYPE_OF_ALERT from ALERT.dbo.HUB_ALERTS_HISTORY a " +
	" inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default  and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CLIENT_ID  " +
	" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no AND a.System_id = b.SYSTEM_ID" +
    " inner join  dbo.LOCATION_ZONE_A c on c.HUBID=a.HUB_ID and c.SYSTEMID=a.SYSTEM_ID AND c.CLIENTID=a.CUSTOMER_ID " +
	" where a.SYSTEM_ID= ? and a.CUSTOMER_ID= ? and  a.GMT >=dateadd(hh,-48,getutcdate())  " +
	" and v.User_id= ? and c.OPERATION_ID = 23 " +
	" group by a.TYPE_OF_ALERT " ;
	
	public static final String GET_HUB_ARRIVAL_DETAIL=
		" select a.GMT,a.LOCATION,a.ID as SLNO  , a.REGISTRATION_NO, a.GPS_DATETIME,a.TYPE_OF_ALERT as TYPE_OF_ALERT ,a.REMARK as REMARKS ,'Alert' as ALERT_TYPE from ALERT.dbo.HUB_ALERTS a " +
		" inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CLIENT_ID " +
		" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no AND a.System_id = b.SYSTEM_ID " +
	    " inner join  dbo.LOCATION_ZONE_A c on c.HUBID=a.HUB_ID and c.SYSTEMID=a.SYSTEM_ID AND c.CLIENTID=a.CUSTOMER_ID " +
		" where a.SYSTEM_ID= ? and a.CUSTOMER_ID= ? and a.GMT >=dateadd(hh,-48,getutcdate()) " +
		" and v.User_id= ? and c.OPERATION_ID= 18 and a.TYPE_OF_ALERT=? and REMARK is null " +
	    " union all "+
	    " select a.GMT,a.LOCATION,a.ID as SLNO  , a.REGISTRATION_NO, a.GPS_DATETIME,a.TYPE_OF_ALERT as TYPE_OF_ALERT ,a.REMARK as REMARKS ,'History' as ALERT_TYPE from ALERT.dbo.HUB_ALERTS_HISTORY a " +
		" inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CLIENT_ID " +
		" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no AND a.System_id = b.SYSTEM_ID " +
	    " inner join  dbo.LOCATION_ZONE_A c on c.HUBID=a.HUB_ID and c.SYSTEMID=a.SYSTEM_ID AND c.CLIENTID=a.CUSTOMER_ID " +
		" where a.SYSTEM_ID= ? and a.CUSTOMER_ID= ? and a.GMT >=dateadd(hh,-48,getutcdate()) " +
		" and v.User_id= ? and c.OPERATION_ID= 18 and a.TYPE_OF_ALERT=? and REMARK is null order by GMT ";
	
	public static final String GET_OFFROAD_DETAIL=
		" select a.GMT,a.LOCATION,a.ID as SLNO, a.REGISTRATION_NO, a.GPS_DATETIME from ALERT.dbo.HUB_ALERTS a " +
		" inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CLIENT_ID " +
		" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no AND a.System_id = b.SYSTEM_ID " +
	    " inner join  dbo.LOCATION_ZONE_A c on c.HUBID=a.HUB_ID and c.SYSTEMID=a.SYSTEM_ID AND c.CLIENTID=a.CUSTOMER_ID " +
		" where a.SYSTEM_ID= ? and a.CUSTOMER_ID= ? and a.GMT >=dateadd(hh,-48,getutcdate()) " +
		" and v.User_id= ? and c.OPERATION_ID= 23 and a.TYPE_OF_ALERT=? " +
	    " union all "+
	    " select a.GMT,a.LOCATION,a.ID as SLNO, a.REGISTRATION_NO, a.GPS_DATETIME from ALERT.dbo.HUB_ALERTS_HISTORY a " +
		" inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default and a.SYSTEM_ID = b.SYSTEM_ID and a.CUSTOMER_ID = b.CLIENT_ID " +
		" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no AND a.System_id = b.SYSTEM_ID " +
	    " inner join  dbo.LOCATION_ZONE_A c on c.HUBID=a.HUB_ID and c.SYSTEMID=a.SYSTEM_ID AND c.CLIENTID=a.CUSTOMER_ID " +
		" where a.SYSTEM_ID= ? and a.CUSTOMER_ID= ? and a.GMT >=dateadd(hh,-48,getutcdate()) " +
		" and v.User_id= ? and c.OPERATION_ID= 23 and a.TYPE_OF_ALERT=? order by GMT ";
	
	
	public static final String GET_NONASSOCIATED_STATIONS="select  NAME,HUBID from dbo.LOCATION_ZONE_# where OPERATION_ID =18 and SYSTEMID=? AND CLIENTID=? and HUBID not in (SELECT HUB_ID FROM  dbo.SERVICE_STATION_MAKE_ASSOC where SYSTEM_ID=? and CUSTOMER_ID=? AND GROUP_ID=?)";
	
	public static final String GET_ASSOCIATED_STATIONS=" SELECT A.HUB_ID,C.NAME FROM  dbo.SERVICE_STATION_MAKE_ASSOC A "+						
											" left outer join dbo.LOCATION_ZONE_# C ON A.HUB_ID=C.HUBID and A.SYSTEM_ID=C.SYSTEMID "+
											" WHERE A.GROUP_ID=? AND A.ASSET_MAKE= ? AND A.SYSTEM_ID=? and A.CUSTOMER_ID=? ";
	
	public static final String CHECK_FOR_EXISTENCE="SELECT HUB_ID FROM  dbo.SERVICE_STATION_MAKE_ASSOC where HUB_ID =? and GROUP_ID=? AND ASSET_MAKE= ? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String INSERT_INTO_STATION_ASSOC="insert into SERVICE_STATION_MAKE_ASSOC(GROUP_ID,ASSET_MAKE,HUB_ID,SYSTEM_ID,CUSTOMER_ID,ASSOCIATED_BY) values(?,?,?,?,?,?)";
	
	public static final String INSERT_INTO_STATION_DISASSOC=" INSERT INTO SERVICE_STATION_MAKE_DISASSOC (ID,GROUP_ID,ASSET_MAKE,HUB_ID,ASSOCIATED_DATE,ASSOCIATED_BY,SYSTEM_ID,CUSTOMER_ID,DISASSOCIATED_BY) "+ 
													    " (SELECT ID,GROUP_ID,ASSET_MAKE,HUB_ID,ASSOCIATED_DATE,ASSOCIATED_BY,SYSTEM_ID,CUSTOMER_ID,? AS DISASSOCIATED_BY FROM dbo.SERVICE_STATION_MAKE_ASSOC "+ 
													    " WHERE GROUP_ID=? AND ASSET_MAKE=? AND HUB_ID=? AND SYSTEM_ID=? AND CUSTOMER_ID =?) ";
	
	public static final String DELETE_FROM_ASSOC="DELETE FROM  dbo.SERVICE_STATION_MAKE_ASSOC where HUB_ID =? and GROUP_ID=? AND ASSET_MAKE= ? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
    public static final String GET_VEHICLE_DOCUMENT_TYPE_LIST="SELECT DISTINCT isnull(a.Manufacturer,'') as Name  from dbo.tblVehicleMaster a "+ 
								" INNER JOIN  dbo.VEHICLE_CLIENT b on a.VehicleNo=b.REGISTRATION_NUMBER"+
								" where  b.SYSTEM_ID=? and b.CLIENT_ID=? AND b.GROUP_ID=? and a.Manufacturer in(select Name from VehicleDocumentType where TypeId=3 and SystemId=?) ";
	
	public static final String GET_ASSET_GROUP= "SELECT  GROUP_ID,GROUP_NAME  FROM dbo.ASSET_GROUP  WHERE ACTIVATION_STATUS ='Complete' AND CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String GET_ALERT_COUNT_DEVICE_BATERY_CONNECTION= "select count(*) as AlertCount from ALERT.dbo.BATTERY_CONNECTION_ALERT_DATA where SYSTEM_ID=? AND CUSTOMER_ID=? and DATEDIFF(hh,GMT,getutcdate())<48 and REMARKS is null ";
	
	public static final String GET_ALERT_DETAILS_DEVICE_BATERY_CONNECTION= "select ID,REGISTRATION_NO,LOCATION,GMT,GPS_DATETIME,REMARKS from ALERT.dbo.BATTERY_CONNECTION_ALERT_DATA where SYSTEM_ID=? AND CUSTOMER_ID=? and DATEDIFF(hh,GMT,getutcdate())<48 and REMARKS is null";
	
	public static final String SAVE_DEVICE_BATERY_REMARKS="update ALERT.dbo.BATTERY_CONNECTION_ALERT_DATA  set REMARKS=? ,UPDATED_BY=?,UPDATED_DATETIME=getutcdate() where ID=? and REGISTRATION_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String GET_VEHICLE_WISE_DETAILS="select REGISTRATION_NO,LOCATION,GPS_DATETIME,isnull(REMARKS,'') as REMARKS,isnull(VOLTAGE,0) VOLTAGE,GROUP_NAME,Model,ModelName, "
		  +"(isnull(FIRST_NAME,'')+' '+isnull(LAST_NAME,'')) as UPDATED_BY,isnull(dateadd(mi,?,UPDATED_DATETIME),'') as UPDATED_DATETIME from ALERT.dbo.BATTERY_CONNECTION_ALERT_DATA a "
		  +"inner join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=a.REGISTRATION_NO collate database_default "
		  +"inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=vc.CLIENT_ID and ag.GROUP_ID=vc.GROUP_ID "
		  +"inner join AMS.dbo.tblVehicleMaster vm on vm.VehicleNo=a.REGISTRATION_NO collate database_default "
		  +"left outer join FMS.dbo.Vehicle_Model m on m.ModelTypeId=vm.Model "
		  +"left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=UPDATED_BY "
		  +"where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and GPS_DATETIME between ? and ?";
	
	public static final String GET_POWER_CONNECTION_REPORT_DETAILS = "select a.REGISTRATION_NO as REG_NO,isnull(ag.GROUP_NAME,'') as GROUP_NAME,Model,ModelName as MODEL_NAME, "+
																	"isnull(dateadd(mi,0,a.START_GPS_DATETIME),'')as DIS_CON_TIME,isnull(a.START_VOLTAGE,0)as DIS_CON_VOLTAGE,isnull(a.START_LOCATION,'')as DIS_CON_LOCATION, "+
																	"isnull(dateadd(mi,0,a.END_GPS_DATETIME),'')as RE_CON_TIME,isnull(a.END_VOLTAGE,0)as RE_CON_VOLTAGE,isnull(a.END_LOCATION,'')as RE_CON_LOCATION "+
																	"from ALERT.dbo.POWER_CONNECTION_ALERT_DATA a "+
																	"inner join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=a.REGISTRATION_NO collate database_default "+ 
																	"inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=vc.CLIENT_ID and ag.GROUP_ID=vc.GROUP_ID "+
																	"inner join AMS.dbo.tblVehicleMaster vm on vm.VehicleNo=a.REGISTRATION_NO collate database_default "+ 
																	"left outer join FMS.dbo.Vehicle_Model m on m.ModelTypeId=vm.Model "+
																	"where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and (a.START_GPS_DATETIME  between ? and ? or a.END_GPS_DATETIME  between ? and ?)";
	
	public static final String GET_TAMPERED_CROSS_BORDER_REPORT = " select REGISTRATION_NO,isnull(vg.GROUP_NAME,'') as GROUP_NAME, isnull(vn.ModelName,'') as MODEL_NAME,isnull(TOGGLE_TIME,'') as GPS_TAMPERED_DATETIME,isnull(REMARKS,'') as TAMPERED_LOCATION, " +
		" isnull(a.GMT,'') as CROSS_BORDER_DATE,LOCATION as CROSS_BORDER_LOACTION,ISNULL(a.ACTION_TAKEN,'') as ACTION_TAKEN,isnull(UPDATED_DATETIME,'') as UPDATED_DATETIME,isnull(us.USER_NAME,'') as UPDATED_BY" +
		" from AMS.dbo.Alert a " +
		" inner join AMS.dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER " +
		" left outer join AMS.dbo.VEHICLE_GROUP vg on b.GROUP_ID=vg.GROUP_ID " +
		" left outer join AMS.dbo.tblVehicleMaster vm on  a.REGISTRATION_NO = vm.VehicleNo " +
		" left outer join FMS.dbo.Vehicle_Model vn on vm.System_id=a.SYSTEM_ID and vn.ClientId=a.CLIENTID and vn.ModelTypeId=vm.Model " +
		" left outer join ADMINISTRATOR.dbo.USERS us on  us.USER_ID=a.UPDATED_BY and a.SYSTEM_ID=us.SYSTEM_ID " +
		" where TYPE_OF_ALERT=148 and a.SYSTEM_ID=? and a.CLIENTID=? and a.GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) " ;

	public static final String GET_GROUP_NAME_FOR_CLIENT = " select a.GROUP_ID, a.GROUP_NAME from ADMINISTRATOR.dbo.ASSET_GROUP a inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on b.SYSTEM_ID=a.SYSTEM_ID " +
	   " and a.GROUP_ID=b.GROUP_ID where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and b.USER_ID=? and a.GROUP_ID not in (select GROUP_ID from AMS.dbo.ROUTE_ASSET_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=?)";
	
	public static final String GET_CITY_NAMES= " select distinct c.CityId,c.CityName from ADMINISTRATOR.dbo.ASSET_GROUP a " +
	" inner JOIN ADMINISTRATOR.dbo.CUSTOMER_MASTER m on a.CUSTOMER_ID=m.CUSTOMER_ID and a.SYSTEM_ID=m.SYSTEM_ID " +
	" inner JOIN Maple.dbo.tblCity c on a.CITY = CityID and a.STATE = stateID " +
	" where m.CUSTOMER_ID=? and  m.SYSTEM_ID=? order by c.CityName ASC ";
	
	public static final String GET_CITY_WISE_DATA= "select d.CityName,c.CITY,REGISTRATION_NO,GPS_DATETIME,LOCATION,b.GROUP_ID,GROUP_NAME,CITY, " +
				" (select min(GPS_DATETIME) from Alert where SYSTEM_ID=? and TYPE_OF_ALERT=83 and HUB_ID=a.HUB_ID " +
				" and REGISTRATION_NO=a.REGISTRATION_NO and GPS_DATETIME > a.GPS_DATETIME ) as ReturnStatus" +
				" FROM AMS.dbo.Alert (NOLOCK) a " +
				" inner join AMS.dbo.VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO " +
				" inner join ADMINISTRATOR.dbo.ASSET_GROUP c on c.GROUP_ID=b.GROUP_ID AND b.CLIENT_ID = c.CUSTOMER_ID " +
				" inner join MAPLE.dbo.tblCity d on d.CityID=c.CITY " +
				" where a.SYSTEM_ID=? and TYPE_OF_ALERT=84 and CITY in (#) and c.CUSTOMER_ID =? and  " +
				" GPS_DATETIME between ? and  ? " +
				" union all " +
				" select d.CityName,c.CITY,REGISTRATION_NO,GPS_DATETIME,LOCATION,b.GROUP_ID,GROUP_NAME,CITY, " +
				" (select min(GPS_DATETIME) from (select GPS_DATETIME from Alert where SYSTEM_ID=? and  " +
				" TYPE_OF_ALERT=83 and HUB_ID=a.HUB_ID and REGISTRATION_NO=a.REGISTRATION_NO " +
				" and GPS_DATETIME > a.GPS_DATETIME " +
				" union all " +
				" select GPS_DATETIME from Alert_History where SYSTEM_ID=? and TYPE_OF_ALERT=83 and HUB_ID=a.HUB_ID  " +
				" and REGISTRATION_NO=a.REGISTRATION_NO and GPS_DATETIME > a.GPS_DATETIME ) r)  as ReturnStatus" +
				" FROM AMS.dbo.Alert_History (NOLOCK) a " +
				" inner join AMS.dbo.VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO " +
				" inner join ADMINISTRATOR.dbo.ASSET_GROUP c on c.GROUP_ID=b.GROUP_ID AND b.CLIENT_ID = c.CUSTOMER_ID " +
				" inner join MAPLE.dbo.tblCity d on d.CityID=c.CITY " +
				" where a.SYSTEM_ID=? and TYPE_OF_ALERT=84 and  CITY in (#) and c.CUSTOMER_ID =? and " +
				" GPS_DATETIME between ? and ? order by GPS_DATETIME";
						
	public static final String GET_CITY_Name = "select distinct c.CityId,c.CityName from ADMINISTRATOR.dbo.ASSET_GROUP a " +
			" inner JOIN ADMINISTRATOR.dbo.CUSTOMER_MASTER m on a.CUSTOMER_ID=m.CUSTOMER_ID and a.SYSTEM_ID=m.SYSTEM_ID " +
			" inner JOIN Maple.dbo.tblCity c on a.CITY = CityID and a.STATE = stateID " +
			" where m.CUSTOMER_ID=? and  m.SYSTEM_ID=? and c.CityId in (#	) ";

	public static final String GET_BORDERCROSS_DATA = "select count(*) as 'BorderCrossedandNotreturnedbyMidnight' from (select REGISTRATION_NO,GPS_DATETIME,LOCATION,b.GROUP_ID,GROUP_NAME," +
			" (select count(*) from (select distinct REGISTRATION_NO from Alert where SYSTEM_ID=? and TYPE_OF_ALERT=83 and HUB_ID=a.HUB_ID and REGISTRATION_NO=a.REGISTRATION_NO" +
			" and GPS_DATETIME between ? and ? union all" +
			" select distinct REGISTRATION_NO from Alert_History where SYSTEM_ID=? and TYPE_OF_ALERT=83 and HUB_ID=a.HUB_ID and REGISTRATION_NO=a.REGISTRATION_NO and" +
			" GPS_DATETIME between ? and ?)r) as statussssss FROM AMS.dbo.Alert (NOLOCK) a" +
			" inner join AMS.dbo.VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO" +
			" inner join ADMINISTRATOR.dbo.ASSET_GROUP c on c.GROUP_ID=b.GROUP_ID" +
			" where a.SYSTEM_ID=? and TYPE_OF_ALERT=84 and GPS_DATETIME between ? and ? and CITY=? " +
			" union all" +
			" select REGISTRATION_NO,GPS_DATETIME,LOCATION,b.GROUP_ID,GROUP_NAME," +
			" (select count(*) from (select distinct REGISTRATION_NO from Alert where SYSTEM_ID=? and TYPE_OF_ALERT=83 and HUB_ID=a.HUB_ID and REGISTRATION_NO=a.REGISTRATION_NO and" +
			" GPS_DATETIME between ? and ?" +
			" union all" +
			" select distinct REGISTRATION_NO from Alert_History where SYSTEM_ID=? and TYPE_OF_ALERT=83 and HUB_ID=a.HUB_ID and REGISTRATION_NO=a.REGISTRATION_NO and" +
			" GPS_DATETIME between ? and ?)r) as statussssss FROM AMS.dbo.Alert_History (NOLOCK) a " +
			" inner join AMS.dbo.VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO" +
			" inner join ADMINISTRATOR.dbo.ASSET_GROUP c on c.GROUP_ID=b.GROUP_ID" +
			" where a.SYSTEM_ID=? and TYPE_OF_ALERT=84 and GPS_DATETIME between ? and ? and CITY=? ) u " +
			" where u.statussssss=0  " ;
			
			
	public static final String GET_GPSWIRING_DATA = "  select count(*) as GPSWiringTampered from (select REGISTRATION_NO from Alert a " +
			" inner join AMS.dbo.VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO " +
			" inner join ADMINISTRATOR.dbo.ASSET_GROUP c on c.GROUP_ID=b.GROUP_ID " +
			" where a.SYSTEM_ID=? and a.TYPE_OF_ALERT=145 and GPS_DATETIME between  ?  and  ? and CLIENT_ID=?  and c.CITY=? " +
			" union all " +
			" select REGISTRATION_NO from Alert_History a  " +
			" inner join AMS.dbo.VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO " +
			" inner join ADMINISTRATOR.dbo.ASSET_GROUP c on c.GROUP_ID=b.GROUP_ID " +
			" where a.SYSTEM_ID=? and a.TYPE_OF_ALERT=145 and GPS_DATETIME between  ?  and ? and CLIENT_ID=?  and c.CITY=? ) r" ;
	
	
	public static final String GET_GPSTAMPER_DATA = " select count(*) as 'GpsTamperingCrossBorderAlert' from (select REGISTRATION_NO from Alert a" +
			" inner join AMS.dbo.VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO" +
			" inner join ADMINISTRATOR.dbo.ASSET_GROUP c on c.GROUP_ID=b.GROUP_ID" +
			" where a.SYSTEM_ID=? and a.TYPE_OF_ALERT=148 and GPS_DATETIME between ? and ? and CLIENT_ID=?  and c.CITY=?" +
			" union all" +
			" select REGISTRATION_NO from Alert_History a" +
			" inner join AMS.dbo.VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=a.REGISTRATION_NO" +
			" inner join ADMINISTRATOR.dbo.ASSET_GROUP c on c.GROUP_ID=b.GROUP_ID" +
			" where a.SYSTEM_ID=? and a.TYPE_OF_ALERT=148 and GPS_DATETIME between ? and ? and CLIENT_ID=?  and c.CITY=?) r" ;
	
	public static final String GET_VEHICLES_DATA = " select count(*) as 'VehiclesNotcommunicatingforwholeday' from dbo.VehicleSummaryData a" +
			" inner join ADMINISTRATOR.dbo.ASSET_GROUP c on c.GROUP_ID=a.GroupId" +
			" where SystemId=? and DateGMT=dateadd(mi,-330,?) and (StopDurationHrs + IdleDurationHrs + TravelTimeHrs)=0 and Clientd=?  and c.CITY=?";

	public static final String SAVE_FIELD_TAMPERING_DETAILS = "insert into GPS_TAMPERING_DETAILS (CITY_ID,REGISTRATION_NO,NC_REASON,ACTION_TAKEN,ATTENDED_DATE,IMAGE_PATH,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME) VALUES (?,?,?,?,?,?,?,?,?,GETUTCDATE())" ;

	public static final String GET_CITY_DETAILS = " select CityID as CITY_ID,CityName as CITY_NAME from Maple.dbo.tblCity order by CityName "; 
	
	public static final String GET_VEHICLE_DETAILS= " select REGISTRATION_NO,dateadd(mi,330,GMT) as LAT_COMM_TIME from AMS.dbo.gpsdata_history_latest g " +
		" left outer join AMS.dbo.VEHICLE_CLIENT vc on g.REGISTRATION_NO=vc.REGISTRATION_NUMBER " +
		" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=vc.CLIENT_ID and ag.GROUP_ID=vc.GROUP_ID " +
		" left outer join Maple.dbo.tblCity tc on tc.CityID=ag.CITY " +
		" where g.System_id=? and g.CLIENTID=? and isnull(tc.CityID,0)=? " ;

	public static final String GET_DRIVER_ID = "select * from AMS.dbo.LOOKUP_DETAILS where VERTICAL='CAR_RENTAL' ";

	public static final String GET_CITYWISE_COUNT = "select CityID,CityName,count(REGISTRATION_NO)  as COUNT from AMS.dbo.GPS_TAMPERING_DETAILS gd " +
	" left outer join Maple.dbo.tblCity tc on tc.CityID=gd.CITY_ID " +
	" where SYSTEM_ID=? and CUSTOMER_ID=? " +
	" group by tc.CityID,CityName ";
	
	public static final String GET_GPS_TAMPERING_DETAILS = " select isnull(v.ModelName,'') as VEHICLE_MODEL,CityName,REGISTRATION_NO,NC_REASON,ACTION_TAKEN,ATTENDED_DATE from AMS.dbo.GPS_TAMPERING_DETAILS gd " +
	" left outer join AMS.dbo.tblVehicleMaster vm on vm.VehicleNo=gd.REGISTRATION_NO " +
	" left outer join FMS.dbo.Vehicle_Model v on vm.Model=v.ModelTypeId " +
	" left outer join Maple.dbo.tblCity tc on tc.CityID=gd.CITY_ID " +
	" where SYSTEM_ID=? and CUSTOMER_ID=?  " ;

	public static final String GET_NON_COMMUNICATING_COUNT = " select count(*) as NON_COMMUNICATING from AMS.dbo.gpsdata_history_latest a" +
	" inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id" +                                       
	" where a.System_id=? and a.CLIENTID=? and a.LOCATION !='No GPS Device Connected' " +
	" and DATEDIFF(hh,a.GMT,getutcdate()) >= 24 and b.User_id=? ";

	public static final String GET_PROACTIVE_MAINTENANCE_COUNT =" select count(distinct r.REGISTRATION_NO) as PROACTIVE_COUNT from (select REGISTRATION_NO from AMS.dbo.Alert (NOLOCK) a where a.TYPE_OF_ALERT=7 and SYSTEM_ID=? AND CUSTOMER_ID=? "+
	" and (DATEDIFF(hh,a.GMT,getutcdate()) <=24) group by REGISTRATION_NO having count(REGISTRATION_NO) >20 "+
	" union all "+
	" select distinct REGISTRATION_NO from HISTORY_DATA_# (NOLOCK) where CLIENTID=? and COMMAND_ID<6 "+
	" and DATEDIFF(hh,GMT,getutcdate()) <=24)r "+
	" inner join AMS.dbo.Vehicle_User b on r.REGISTRATION_NO=b.Registration_no "+ 
	" where User_id=? ";

	public static final String GET_SIM_RELATED_ISSUE_COUNT = " select distinct REGISTRATION_NO as SPEED_COUNT from AMS.dbo.gpsdata_history_latest g "+
	 " inner join  AMS.dbo.Vehicle_User b on g.REGISTRATION_NO=b.Registration_no and g.System_id=b.System_id "+
	 " where g.System_id=? and g.CLIENTID=? and g.LOCATION !='No GPS Device Connected' "+ 
	 " and SPEED>5 and GMT between dateadd(mi,-120,getutcdate()) and dateadd(mi,-30,getutcdate()) "+
	 " and b.User_id=? ";

	public static final String GET_NC_MORE_THAN_48_HRS_COUNT = " select count(REGISTRATION_NO) as NON_COMMUNICATING from AMS.dbo.gpsdata_history_latest a" +
	" inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id" +
	" where a.System_id=? and a.CLIENTID=? and a.LOCATION !='No GPS Device Connected' " +
	" and DATEDIFF(hh,a.GMT,getutcdate()) >= 24 and b.User_id=? ";

	public static final String GET_INSIDE_YARD_COUNT = " select distinct(REGISTRATION_NO) as YARD_VEHICLES from AMS.dbo.gpsdata_history_latest g (nolock)" +
	" inner join  AMS.dbo.Vehicle_User b on g.REGISTRATION_NO=b.Registration_no and g.System_id=b.System_id" +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz on g.CLIENTID=lz.CLIENTID and g.System_id=lz.SYSTEMID and lz.HUBID=g.HUB_ID " +
	" where g.System_id=? and g.CLIENTID=? and (lz.OPERATION_ID in (23,18) and g.LOCATION like 'Inside%') " +
	" and (DATEDIFF(hh,g.GMT,getutcdate()) >= 24) and b.User_id=? ";

	public static final String GET_ON_ROAD_VEHICLE_COUNT = " select distinct(g.REGISTRATION_NO) as ON_ROAD_COUNT,g.LOCATION,OPERATION_ID from AMS.dbo.gpsdata_history_latest g (nolock) "+
   " inner join  AMS.dbo.Vehicle_User b on g.REGISTRATION_NO=b.Registration_no and g.System_id=b.System_id "+
   " left outer join AMS.dbo.LOCATION_ZONE_A lz on g.CLIENTID=lz.CLIENTID and g.System_id=lz.SYSTEMID and lz.HUBID=g.HUB_ID "+	
   " where g.System_id=? and g.CLIENTID=? and g.LOCATION !='No GPS Device Connected' and "+
   " DATEDIFF(hh,g.GMT,getutcdate()) >= 24 and b.User_id=? "+ 
   " and ((isnull(lz.OPERATION_ID,0) not in (23,18)) or (lz.OPERATION_ID in (23,18) and g.LOCATION not like 'Inside%')) ";

	public static final String GET_SUSPECTED_TAMPERING_COUNT = "select distinct(g.REGISTRATION_NO) as ALERT_COUNT from AMS.dbo.gpsdata_history_latest g (nolock)" +
	" inner join AMS.dbo.Alert a on a.REGISTRATION_NO=g.REGISTRATION_NO" +
	" inner join  AMS.dbo.Vehicle_User b on g.REGISTRATION_NO=b.Registration_no and g.System_id=b.System_id" +
	" where g.System_id=? and g.CLIENTID=? and g.LOCATION !='No GPS Device Connected' and" +
	" (DATEDIFF(hh,g.GMT,getutcdate()) >= 24) and a.TYPE_OF_ALERT in (145) and (MONITOR_STATUS is null or MONITOR_STATUS='N') and" +
	" (DATEDIFF(hh,a.GMT,getutcdate()) >= 24) and b.User_id=? ";

	public static final String GET_NON_COMMUNICATING_DETAILS = "select isnull(a.REGISTRATION_NO,'') as REGISTRATION_NO,dateadd(mi,330,a.GMT) as GMT,isnull(a.LOCATION,'') as LOCATION,a.SPEED as SPEED,a.IGNITION as IGNITION,isnull(ag.GROUP_NAME,'') as GROUP_NAME,isnull(tc.CityName,'') as CityName from AMS.dbo.gpsdata_history_latest a" +
	" inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id" +
	" left outer join AMS.dbo.VEHICLE_CLIENT vc on a.REGISTRATION_NO=vc.REGISTRATION_NUMBER " +
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=vc.CLIENT_ID and ag.GROUP_ID=vc.GROUP_ID " +
	" left outer join Maple.dbo.tblCity tc on tc.CityID=ag.CITY " +
	" where a.System_id=? and a.CLIENTID=? and a.LOCATION !='No GPS Device Connected' " +
	" and DATEDIFF(hh,a.GMT,getutcdate()) >= 24 and b.User_id=? ";

	public static final String GET_SIM_RELATED_ISSUE_DETAILS = " select isnull(g.REGISTRATION_NO,'') as REGISTRATION_NO,dateadd(mi,330,g.GMT) as GMT,isnull(g.LOCATION,'') as LOCATION,g.SPEED as SPEED,g.IGNITION as IGNITION,isnull(ag.GROUP_NAME,'') as GROUP_NAME,isnull(tc.CityName,'') as CityName from AMS.dbo.gpsdata_history_latest g" +
	" inner join  AMS.dbo.Vehicle_User b on g.REGISTRATION_NO=b.Registration_no and g.System_id=b.System_id" +
	" left outer join AMS.dbo.VEHICLE_CLIENT vc on g.REGISTRATION_NO=vc.REGISTRATION_NUMBER " +
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=vc.CLIENT_ID and ag.GROUP_ID=vc.GROUP_ID " +
	" left outer join Maple.dbo.tblCity tc on tc.CityID=ag.CITY" +
	" where g.System_id=? and g.CLIENTID=? and g.LOCATION !='No GPS Device Connected' " +
	" and SPEED>5 and GMT between dateadd(mi,-120,getutcdate()) and dateadd(mi,-30,getutcdate()) and b.User_id=? ";

	public static final String GET_INSIDE_YARD_VEHICLE_DETAILS = " select isnull(g.REGISTRATION_NO,'') as REGISTRATION_NO,dateadd(mi,330,g.GMT) as GMT,isnull(g.LOCATION,'') as LOCATION,g.SPEED as SPEED,g.IGNITION as IGNITION,isnull(ag.GROUP_NAME,'') as GROUP_NAME,isnull(tc.CityName,'') as CityName from AMS.dbo.gpsdata_history_latest g (nolock)" +
	" inner join  AMS.dbo.Vehicle_User b on g.REGISTRATION_NO=b.Registration_no and g.System_id=b.System_id" +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz on g.CLIENTID=lz.CLIENTID and g.System_id=lz.SYSTEMID and lz.HUBID=g.HUB_ID " +
	" left outer join AMS.dbo.VEHICLE_CLIENT vc on g.REGISTRATION_NO=vc.REGISTRATION_NUMBER " +
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=vc.CLIENT_ID and ag.GROUP_ID=vc.GROUP_ID " +
	" left outer join Maple.dbo.tblCity tc on tc.CityID=ag.CITY " +
	" where g.System_id=? and g.CLIENTID=? and (lz.OPERATION_ID in (23,18) and g.LOCATION like 'Inside%') " +
	" and (DATEDIFF(hh,g.GMT,getutcdate()) >= 24) and b.User_id=? ";
    
	public static final String GET_ON_ROAD_VEHICLE_DETAILS = "select isnull(g.REGISTRATION_NO,'') as REGISTRATION_NO,dateadd(mi,330,g.GMT) as GMT,isnull(g.LOCATION,'') as LOCATION,g.SPEED as SPEED,g.IGNITION as IGNITION,isnull(ag.GROUP_NAME,'') as GROUP_NAME,isnull(tc.CityName,'') as CityName from AMS.dbo.gpsdata_history_latest g (nolock)" +
	" inner join  AMS.dbo.Vehicle_User b on g.REGISTRATION_NO=b.Registration_no and g.System_id=b.System_id" +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz on g.CLIENTID=lz.CLIENTID and g.System_id=lz.SYSTEMID and lz.HUBID=g.HUB_ID" +
	" left outer join AMS.dbo.VEHICLE_CLIENT vc on g.REGISTRATION_NO=vc.REGISTRATION_NUMBER " +
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=vc.CLIENT_ID and ag.GROUP_ID=vc.GROUP_ID " +
	" left outer join Maple.dbo.tblCity tc on tc.CityID=ag.CITY" +
	" where g.System_id=? and g.CLIENTID=? and g.LOCATION !='No GPS Device Connected' and" +
	" (DATEDIFF(hh,g.GMT,getutcdate()) >= 24) and b.User_id=? " +
	" and ((isnull(lz.OPERATION_ID,0) not in (23,18)) or (lz.OPERATION_ID in (23,18) and g.LOCATION not like 'Inside%')) " ;
	
	public static final String GET_SUSPECTED_TAMPERING_DETAILS = "select isnull(g.REGISTRATION_NO,'') as REGISTRATION_NO,dateadd(mi,330,g.GMT) as GMT,isnull(g.LOCATION,'') as LOCATION,g.SPEED as SPEED,g.IGNITION as IGNITION,isnull(ag.GROUP_NAME,'') as GROUP_NAME,isnull(tc.CityName,'') as CityName,a.GPS_DATETIME as GPS_TAMPERED_DATE,a.LOCATION AS GPS_TAMPERED_LOC from AMS.dbo.gpsdata_history_latest g (nolock)" +
	" inner join AMS.dbo.Alert a on a.REGISTRATION_NO=g.REGISTRATION_NO" +
	" inner join  AMS.dbo.Vehicle_User b on g.REGISTRATION_NO=b.Registration_no and g.System_id=b.System_id" +
	" left outer join AMS.dbo.VEHICLE_CLIENT vc on g.REGISTRATION_NO=vc.REGISTRATION_NUMBER " +
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=vc.CLIENT_ID and ag.GROUP_ID=vc.GROUP_ID " +
	" left outer join Maple.dbo.tblCity tc on tc.CityID=ag.CITY" +
	" where g.System_id=? and g.CLIENTID=? and g.LOCATION !='No GPS Device Connected' and" +
	" (DATEDIFF(hh,g.GMT,getutcdate()) >= 24) and a.TYPE_OF_ALERT in (145) and (MONITOR_STATUS is null or MONITOR_STATUS='N') and" +
	" (DATEDIFF(hh,a.GMT,getutcdate()) >= 24) and b.User_id=? ";
	
	public static final String GET_PROACTIVE_DETAILS =  " select isnull(g.REGISTRATION_NO,'') as REGISTRATION_NO,dateadd(mi,330,g.GMT) as GMT,isnull(g.LOCATION,'') as LOCATION,g.SPEED as SPEED, " +
	" g.IGNITION as IGNITION,isnull(ag.GROUP_NAME,'') as GROUP_NAME,isnull(tc.CityName,'') as CityName " +
	" from (select REGISTRATION_NO from AMS.dbo.Alert a (NOLOCK)  " +
	" where a.TYPE_OF_ALERT=7 and SYSTEM_ID=? AND CUSTOMER_ID=?  " +
	" and (DATEDIFF(hh,a.GMT,getutcdate()) <=24) group by REGISTRATION_NO having count(REGISTRATION_NO) >20  " +
	" union all  " +
	" select distinct REGISTRATION_NO from HISTORY_DATA_261 a (NOLOCK)  " +
	" where CLIENTID=? and COMMAND_ID<6 and DATEDIFF(hh,GMT,getutcdate()) <=24)r  " +
	" inner join AMS.dbo.gpsdata_history_latest g on r.REGISTRATION_NO=g.REGISTRATION_NO " +
	" inner join AMS.dbo.Vehicle_User b on r.REGISTRATION_NO=b.Registration_no  " +
	" left outer join AMS.dbo.VEHICLE_CLIENT vc on r.REGISTRATION_NO=vc.REGISTRATION_NUMBER  " +
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=vc.CLIENT_ID and ag.GROUP_ID=vc.GROUP_ID " +
	" left outer join Maple.dbo.tblCity tc on tc.CityID=ag.CITY " +
	" where User_id=?  " ;

	}

