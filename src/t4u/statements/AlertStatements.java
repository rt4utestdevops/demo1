package t4u.statements;

public class AlertStatements {
	
	//public final static String GET_ALERT_COMPONENTS = "select AlertId, AlertName from Alert_Master_Details where SystemId=? and (IsStatutory<>'Y' or IsStatutory is null) and AlertId<> 110 and AlertId<> 111  order by DisplayId";
	
	
	public final static String GET_ALERT_COMPONENTS="select AlertId, AlertName from Alert_Master_Details where SystemId=? "+
															 "and AlertId in (1,2,3,5,7,17,18,38,39,45,58,82,83,84,93,99,102,104,105,106,113,117,118,119,132,182)  "+
															 "order by CASE AlertName "+
															 "WHEN 'OverSpeed' THEN '1' "+
															 "WHEN 'Continues Running' THEN '2' "+
															 "WHEN 'Idle' THEN '3' "+
															 "WHEN 'Parking Alert' THEN '4' "+
															 "WHEN 'Vault Alert' THEN '5' "+
															 "WHEN 'Detention Alert' THEN '6' "+
															 "ELSE AlertName END ASC";
	
	public static final String GET_ALERT_COUNT="select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as COUNT from dbo.Alert a (nolock) "+
											   " inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? "+
											   " where a.SYSTEM_ID=? and a.CLIENTID=? "+
											   " and a.TYPE_OF_ALERT in (1,2,5,7,17,18,38,39,45,82,83,84,93,99,102,104,106,113,117,118,119,132) "+
											   " and a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') "+
											   " group by a.TYPE_OF_ALERT";
	
	public static final String GET_OVER_SPEED_ALERT_COUNT=" select count(a.REGISTRATION_NO) as COUNT from ALERT.dbo.OVER_SPEED_DATA a  "+
														  " inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default " +
														  " inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no"+
														  " where GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0))  and a.CUSTOMER_ID=?  and b.SYSTEM_ID=? and v.User_id=? and REMARK is  null ";
	
	public static final String GET_DETENTION_ALERT_COUNT="select count(a.REGISTRATION_NO) as COUNT from dbo.Alert a (nolock) " +
														 " inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? "+
	 													 "where a.TYPE_OF_ALERT=119  and a.CLIENTID=?  and a.SYSTEM_ID=? and  a.ISREDALERT<>'Y' and GMT>dateadd(hh,-48,getutcdate()) ";
	
	public static final String GET_HUB_ARRIVAL_COUNT="select count(a.REGISTRATION_NO) as COUNT,a.TYPE_OF_ALERT as TYPE_OF_ALERT from ALERT.dbo.HUB_ALERTS a "+
													 "inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default "+
													 "inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no "+
													 "where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day,1, GETDATE()), 0))  "+
													 "and v.User_id=? "+
													 "group by a.TYPE_OF_ALERT";
	
	public static final String GET_DISTRESS_COUNT_ALERT="select count(a.REGISTRATION_NO) as COUNT from ALERT.dbo.PANIC_DATA a " +
			                                       "inner join AMS.dbo.Vehicle_User v on a.SYSTEM_ID=v.System_id and a.REGISTRATION_NO = v.Registration_no collate database_default " +
			                                       "where GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and a.CUSTOMER_ID=?  and a.SYSTEM_ID=? and v.User_id=? and a.TYPE_OF_ALERT =? and REMARK is null";
	
	public static final String GET_DISTRESS_COUNT="select count(a.REGISTRATION_NO) as COUNT from ALERT.dbo.PANIC_DATA a " +
    "inner join AMS.dbo.Vehicle_User v on a.SYSTEM_ID=v.System_id and a.REGISTRATION_NO = v.Registration_no collate database_default " +
    "where GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and a.CUSTOMER_ID=?  and a.SYSTEM_ID=? and v.User_id=? and a.TYPE_OF_ALERT in (3,182) and REMARK is null";
	
	public static final String GET_HARSH_ACC_COUNT = "select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as COUNT from ALERT.dbo.HARSH_ALERT_DATA a (nolock)  inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no collate database_default and a.SYSTEM_ID=b.System_id  " +
			"and b.User_id=?  where a.SYSTEM_ID=? and a.CUSTOMER_ID=?  and a.TYPE_OF_ALERT in (105)  and a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))  group by a.TYPE_OF_ALERT";
	
	
	public static final String GET_HARSH_BRK_COUNT = "select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as COUNT from ALERT.dbo.HARSH_ALERT_DATA a (nolock)  inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no collate database_default and a.SYSTEM_ID=b.System_id  " +
	"and b.User_id=?  where a.SYSTEM_ID=? and a.CUSTOMER_ID=?  and a.TYPE_OF_ALERT in (58)  and a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))  group by a.TYPE_OF_ALERT";
	
	
	public static final String GET_OVER_SPEED_ALERT="select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,dateadd(mi,?,a.GMT) as [GMT],GPS_DATETIME,a.LOCATION,isnull(a.SPEED, 0) as SPEED,'' as [TRIP NAME], " +
													" isNull(a.DRIVER_ID,0) as [DRIVER NAME],isnull(a.REMARK,'') as REMARKS,a.LONGITUDE as LONGITUDE,a.LATITUDE as LATITUDE,'' as [ACTION TAKEN],a.UPDATED_BY as [USER NAME],a.SPEED as OVERSPEED,2 as TYPE_OF_ALERT,'Alert' as Type,'' as [STOPPAGE TIME],'' as [ALERT NAME], " + 
													" '' as [IDLE TIME],'' as STATUS,'' as ACCELERATION,'' as DEACCELERATION,'' as [DISTANCE DEVIATED],'' as [DETENTION TIME],'' as DELAY,'' as [Generator Status],'' as [Total Run Hrs],'' as [DUE DATE],  " +
													" case when ((vm.OverSpeedLimitforGR is null) or (vm.OverSpeedLimit is not null and vm.OverSpeedLimit<vm.OverSpeedLimitforGR)) then isnull(vm.OverSpeedLimit,0) else isnull(vm.OverSpeedLimitforGR,0) end as OVERSPEEDLIMIT,c.GROUP_NAME as GROUP_NAME,vm.VehicleAlias as [VEHICLE ID]  " +
													" from ALERT.dbo.OVER_SPEED_DATA a inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default " +
													" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no"+
													" left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID  " +
													" left outer join tblVehicleMaster vm on  a.REGISTRATION_NO = vm.VehicleNo collate database_default " +
													" where GMT between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and a.CUSTOMER_ID=?  and b.SYSTEM_ID=? and v.User_id=? and REMARK is  null order by GPS_DATETIME desc";
	
	
	public static final String GET_HUB_ARRIVAL_DETAILS="select a.ID as SLNO,a.REGISTRATION_NO,isnull(a.LOCATION,'') as  LOCATION, isnull(a.GPS_DATETIME,'') as GPS_DATETIME,a.GMT from ALERT.dbo.HUB_ALERTS a "+
														"inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default "+
														"inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no "+
														"where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day,1, GETDATE()), 0))  "+
														"and v.User_id=? and a.TYPE_OF_ALERT=?  order by GPS_DATETIME desc";
	
	public static final String GET_ALERT_DETAILS="select a.SLNO,a.REGISTRATION_NO,a.LOCATION,a.GPS_DATETIME,a.GMT,a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID from Alert a " +
													" inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no " +
													" left outer join VEHICLE_CLIENT c on a.REGISTRATION_NO = c.REGISTRATION_NUMBER " +
													" where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT= ? and " +													
													" a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) " +
													" and b.User_id=? and  (MONITOR_STATUS is null or MONITOR_STATUS='N') order by GPS_DATETIME desc";
													/*" union all " +
													" select a.SLNO,a.REGISTRATION_NO,a.LOCATION,a.GPS_DATETIME,a.GMT,a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID from Alert_History a  " +
													" inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no " +
													" left outer join VEHICLE_CLIENT c on a.REGISTRATION_NO = c.REGISTRATION_NUMBER " +
													" where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT= ? and " +
													" a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) " +
													" and b.User_id=? and  (MONITOR_STATUS is null or MONITOR_STATUS='N') ";*/
	
	
	public static final String GET_DETENTION_ALERT_DETAILS="select a.SLNO,a.REGISTRATION_NO,a.LOCATION,a.GPS_DATETIME,dateadd(mi,?,a.GMT) as GMT,a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID from Alert a " +
															" inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no " +
															" left outer join VEHICLE_CLIENT c on a.REGISTRATION_NO = c.REGISTRATION_NUMBER " +
															" where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT= ? and " +
															" a.GMT>dateadd(hh,-48,getutcdate()) " +
															" and b.User_id=? and  (MONITOR_STATUS is null or MONITOR_STATUS='N') " +
															" union all " +
															" select a.SLNO,a.REGISTRATION_NO,a.LOCATION,a.GPS_DATETIME,dateadd(mi,?,a.GMT) as GMT,a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID from Alert_History a  " +
															" inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no " +
															" left outer join VEHICLE_CLIENT c on a.REGISTRATION_NO = c.REGISTRATION_NUMBER " +
															" where a.SYSTEM_ID=? and a.CLIENTID=? and a.TYPE_OF_ALERT= ? and " +
															" a.GMT>dateadd(hh,-48,getutcdate()) " +
															" and b.User_id=? and  (MONITOR_STATUS is null or MONITOR_STATUS='N') order by GPS_DATETIME desc";
	
	
	public static final String GET_DISTRESS_ALERT_DETAILS="select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,dateadd(mi,?,a.GMT) as [GMT],a.LOCATION,a.TYPE_OF_ALERT as TYPE_OF_ALERT from ALERT.dbo.PANIC_DATA a " +
														  "inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no collate database_default " +
														  "where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT=? and a.GMT between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and b.User_id=? and REMARK is null " +
														  "union all " +
														  "select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,dateadd(mi,?,a.GMT) as [GMT],a.LOCATION,a.TYPE_OF_ALERT as TYPE_OF_ALERT from ALERT.dbo.PANIC_DATA_HISTORY a " +
														  "inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no collate database_default " +
														  "where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT=? and a.GMT between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and  b.User_id=? and REMARK is null order by GMT desc";
	
	
	public static final String GET_HA_HB_DETAILS= "select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,dateadd(mi,?,a.GMT) as [GMT],a.LOCATION,a.TYPE_OF_ALERT as TYPE_OF_ALERT from  ALERT.dbo.HARSH_ALERT_DATA a  inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO =" +
													" b.Registration_no collate database_default  where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TYPE_OF_ALERT=? and a.GMT between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and b.User_id=? and REMARK is null ";
	
	public static final String SAVE_ALERT_REMARK="update dbo.Alert set MONITOR_STATUS=? where SLNO = ? and REGISTRATION_NO=? and TYPE_OF_ALERT=? and CLIENTID=? and SYSTEM_ID=?";

	public static final String SAVE_OVERSPEED_REMARKS="update ALERT.dbo.OVER_SPEED_DATA set REMARK=? where ID=? and REGISTRATION_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";
	
	public static final String SAVE_DISTRESS_REMARKS="update ALERT.dbo.PANIC_DATA set REMARK=? where ID=? and REGISTRATION_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";
			
	public static final String UPDATE_HUB_ALERT="update ALERT.dbo.HUB_ALERTS set REMARK=? where ID=? and SYSTEM_ID=? and CUSTOMER_ID=? and TYPE_OF_ALERT=?";
	
	public static final String CHECK_VEHICLE_NO_IN_TRIP_SHEET=" SELECT * FROM AMS.dbo.Sand_Mining_Trip_Sheet where Permit_No=? and System_Id=? and Client_Id=? and Date_TS >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0))";
}
