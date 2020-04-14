package t4u.statements;

public class PreventiveMaintenanceStatements {  

	public static final String GET_TASK_NAME_LIST = "select MaintenanceId as TaskId,Maintenance as TaskName,DEFAULT_DISTANCE,DEFAULT_DAYS,THRESHOLD_DISTANCE,THRESHOLD_DAYS from FMS.dbo.Maintenance_Mstr where SystemId=? and CUSTOMER_ID=? and TYPE='Periodic'and (STATUS='Active' or STATUS is null) and MaintenanceId NOT IN (SELECT TASK_ID FROM FMS.dbo.PREVENTIVE_TASK_ASSOCIATION  where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=?)";

	public static final String INSERT_TASK_MASTER_DETAILS = "insert into FMS.dbo.Maintenance_Mstr(MaintenanceId,Maintenance,TYPE,DEFAULT_DAYS,DEFAULT_DISTANCE,STATUS,THRESHOLD_DAYS,THRESHOLD_DISTANCE,AUTO_UPDATE,DETENTION_TIME,CUSTOMER_ID,SystemId)values(?,?,?,?,?,?,?,?,?,?,?,?)";

	public static final String UPDATE_TASK_MASTER_DETAILS = "update FMS.dbo.Maintenance_Mstr set Maintenance=?,TYPE=?,DEFAULT_DAYS=?,DEFAULT_DISTANCE=?,STATUS=?,THRESHOLD_DAYS=?,THRESHOLD_DISTANCE=?,AUTO_UPDATE=?,DETENTION_TIME=? where SystemId=? and CUSTOMER_ID=? and MaintenanceId=?";

	public static final String CHECK_FOR_EXISTING_TASK = "select Maintenance from FMS.dbo.Maintenance_Mstr where Maintenance = ? and SystemId= ? and CUSTOMER_ID=? ";

	public static final String GET_MAX_TASKS = "select MAX(MaintenanceId) from FMS.dbo.Maintenance_Mstr where SystemId=? and CUSTOMER_ID=?";

	public static final String GET_TASK_MASTER_DETAILS = "select MaintenanceId,isnull(Maintenance,'')as Maintenance,isnull(TYPE,'')as TYPE, isnull(DEFAULT_DAYS,0) as DEFAULT_DAYS,isnull(DEFAULT_DISTANCE,0) as DEFAULT_DISTANCE,isnull(STATUS,'')as STATUS,isnull(AUTO_UPDATE,'') as AUTO_UPDATE,isnull(DETENTION_TIME,0) as DETENTION_TIME from FMS.dbo.Maintenance_Mstr where SystemId=? and CUSTOMER_ID=?";

	public static final String GET_ASSET_NUMBER_FOR_ALL = "select REGISTRATION_NUMBER,vm.ModelName from tblVehicleMaster tb left outer join VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id left outer join Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id left outer join FMS.dbo.Vehicle_Model vm on ModelTypeId=tb.Model and vu.System_id=vm.SystemId where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? order by REGISTRATION_NUMBER";
	
	public static final String GET_ASSET_NUMBER_FOR_ALERTTYPE = "select distinct REGISTRATION_NUMBER,vm.ModelName from tblVehicleMaster tb left outer join VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id left outer join Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id left outer join FMS.dbo.Vehicle_Model vm on ModelTypeId=tb.Model and vu.System_id=vm.SystemId inner join FMS.dbo.PREVENTIVE_EVENTS pe on vc.REGISTRATION_NUMBER=pe.ASSET_NUMBER collate database_default and vc.SYSTEM_ID=pe.SYSTEM_ID where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and pe.ALERT_TYPE=? order by REGISTRATION_NUMBER";
	
	public static final String INSERT_MANAGE_TASK_DETAILS ="insert into FMS.dbo.PREVENTIVE_TASK_ASSOCIATION (TASK_ID,DISTANCE,DAYS,THRESHOULD_DISTANCE,THRESHOULD_DAYS,LAST_SERVICE_DATE,CREATED_BY,SYSTEM_ID,CUSTOMER_ID,ASSET_NUMBER)values(?,?,?,?,?,?,?,?,?,?)";
	
	public static final String MODIFY_MANAGE_TASK_DETAILS ="update FMS.dbo.PREVENTIVE_TASK_ASSOCIATION set DISTANCE=?,DAYS=?,THRESHOULD_DISTANCE=?,THRESHOULD_DAYS=?,LAST_SERVICE_DATE=?,MODIFIED_DATE=getDate(),MODIFIED_BY=? where SYSTEM_ID=? and ASSET_NUMBER=? and CUSTOMER_ID=? and TASK_ID=?";
	
	public static final String MODIFY_MANAGE_TASK_DETAILS_NEW ="update FMS.dbo.PREVENTIVE_TASK_ASSOCIATION set DISTANCE=?,DAYS=?,THRESHOULD_DISTANCE=?,THRESHOULD_DAYS=?,MODIFIED_DATE=getDate(),MODIFIED_BY=? where SYSTEM_ID=? and ASSET_NUMBER=? and CUSTOMER_ID=? and TASK_ID=?";
	
	public static final String GET_MANAGE_TASK_DETAILS ="select a.TASK_ID,a.ASSET_NUMBER,isnull(b.Maintenance,'') as TASK_NAME,a.DISTANCE,a.DAYS,a.THRESHOULD_DISTANCE,a.THRESHOULD_DAYS,dateadd(mi,?,a.LAST_SERVICE_DATE) as LAST_SERVICE_DATE from FMS.dbo.PREVENTIVE_TASK_ASSOCIATION a left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID = b.MaintenanceId and a.SYSTEM_ID=b.SystemId and a.CUSTOMER_ID=b.CUSTOMER_ID where a.SYSTEM_ID=? and a.CUSTOMER_ID = ? and a.ASSET_NUMBER=?";
	
	public static final String GET_ASSET_NUMBER_AND_MODEL_TO_COPY_DETAILS ="select REGISTRATION_NUMBER,vm.ModelName from tblVehicleMaster tb left outer join VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id left outer join Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id left outer join FMS.dbo.Vehicle_Model vm on ModelTypeId=tb.Model and vu.System_id=vm.SystemId where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and REGISTRATION_NUMBER !=? order by REGISTRATION_NUMBER";
	
	public static final String CHECK_EXISTING_TASK_FOR_MANAGE_DETAILS ="select TASK_ID from FMS.dbo.PREVENTIVE_TASK_ASSOCIATION where TASK_ID =? and SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=?";
	
	public static final String GET_MAX_TASKS1 ="select MAX(ID) from FMS.dbo.PREVENTIVE_TASK_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=?";

	public static final String INSERT_MANAGE_COPY_DETAILS="insert into FMS.dbo.PREVENTIVE_TASK_ASSOCIATION (TASK_ID,DISTANCE,DAYS,THRESHOULD_DISTANCE,THRESHOULD_DAYS,LAST_SERVICE_DATE,CREATED_BY,SYSTEM_ID,CUSTOMER_ID,ASSET_NUMBER)values(?,?,?,?,?,?,?,?,?,?)";
	
	public static final String MODIFY_EXPIRING_SOON_DETAILS="update FMS.dbo.PREVENTIVE_TASK_ASSOCIATION set LAST_SERVICE_DATE=?,MODIFIED_DATE=getDate(),MODIFIED_BY=? where SYSTEM_ID=? and ASSET_NUMBER=? and CUSTOMER_ID=? and TASK_ID=?";

	public static final String GET_TASK_NAME_LIST_FOR_EXPIRING_SOON= "select a.TASK_ID ,b.Maintenance,a.LAST_SERVICE_DATE FROM FMS.dbo.PREVENTIVE_TASK_ASSOCIATION a left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID=b.MaintenanceId where a.SYSTEM_ID = b.SystemId and a.CUSTOMER_ID=b.CUSTOMER_ID and a.ASSET_NUMBER=?";
	
	public static final String GET_EXPIRING_SOON_DETAILS="select a.ASSET_NUMBER,b.Maintenance as TASK_NAME,a.LAST_SERVICE_DATE,a.EVENT_PARAM,a.TASK_ID,a.EVENT_DATE,a.DUE_DAYS,a.DUE_MILEAGE from FMS.dbo.PREVENTIVE_EVENTS a left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID = b.MaintenanceId and a.SYSTEM_ID = b.SystemId and a.CUSTOMER_ID=b.CUSTOMER_ID where a.SYSTEM_ID =? and a.CUSTOMER_ID=? and a.ALERT_TYPE ='2' and a.ASSET_NUMBER = ?";

	public static final String GET_EXPIRING_SOON_DETAILS_NEW=" select a.ASSET_NUMBER,b.Maintenance as TASK_NAME,dateadd( mi,?,a.LAST_SERVICE_DATE) as LAST_SERVICE_DATE ,dateadd( mi,?,a.SERVICE_DATE)  as SERVICE_DATE ,a.EVENT_PARAM,a.TASK_ID,a.EVENT_DATE,a.DUE_DAYS,a.DUE_MILEAGE from FMS.dbo.PREVENTIVE_EVENTS a left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID = b.MaintenanceId and a.SYSTEM_ID = b.SystemId and a.CUSTOMER_ID=b.CUSTOMER_ID where a.SYSTEM_ID =? and a.CUSTOMER_ID=? and a.ALERT_TYPE ='2' and a.ASSET_NUMBER = ?";

	
	
	
	
	
	
	
	
	
	public static final String INSERT_INTO_HISTORY="insert into FMS.dbo.PREVENTIVE_EVENTS_HISTORY (ID,ASSET_NUMBER,TASK_ID,ALERT_TYPE,EVENT_DATE,EVENT_PARAM,LAST_SERVICE_DATE,SYSTEM_ID,CUSTOMER_ID,CREATED_TIME,DUE_DAYS,DUE_MILEAGE,REMARKS,UPDATED_TIME,UPDATED_BY)  select ID,ASSET_NUMBER,TASK_ID,ALERT_TYPE,EVENT_DATE,EVENT_PARAM,LAST_SERVICE_DATE,SYSTEM_ID,CUSTOMER_ID,CREATED_TIME,DUE_DAYS,DUE_MILEAGE,?,getDate(),? from FMS.dbo.PREVENTIVE_EVENTS where ASSET_NUMBER =? and TASK_ID = ? and ALERT_TYPE = ? and SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String MODIFY_ALREADY_EXPIRED_SOON_DETAILS="update FMS.dbo.PREVENTIVE_TASK_ASSOCIATION set LAST_SERVICE_DATE=?,MODIFIED_DATE=getDate(),MODIFIED_BY=? where SYSTEM_ID=? and ASSET_NUMBER=? and CUSTOMER_ID=? and TASK_ID=?";

	public static final String INSERT_INTO_HISTORY_FOR_ALREADY_EXPIRED="insert into FMS.dbo.PREVENTIVE_EVENTS_HISTORY (ID,ASSET_NUMBER,TASK_ID,ALERT_TYPE,EVENT_DATE,EVENT_PARAM,LAST_SERVICE_DATE,SYSTEM_ID,CUSTOMER_ID,CREATED_TIME,REMARKS) select * from FMS.dbo.PREVENTIVE_EVENTS where ASSET_NUMBER =? and TASK_ID = ? and ALERT_TYPE = ? and SYSTEM_ID=? and CUSTOMER_ID=?" ;
	
	
	
	
	
	public static final String GET_ALREADY_EXPIRED_DETAILS="select a.ASSET_NUMBER,a.LAST_SERVICE_DATE,a.EVENT_PARAM,a.EVENT_DATE,a.TASK_ID,a.POSTPONE_DATE,a.POSTPONE_REMARKS,b.Maintenance as TASK_NAME,a.DUE_DAYS,a.DUE_MILEAGE from FMS.dbo.PREVENTIVE_EVENTS a left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID = b.MaintenanceId and a.SYSTEM_ID = b.SystemId and a.CUSTOMER_ID=b.CUSTOMER_ID where a.SYSTEM_ID =? and a.CUSTOMER_ID=? and a.ALERT_TYPE ='1' and a.ASSET_NUMBER = ?";

	public static final String GET_ALREADY_EXPIRED_DETAILS_NEW= " select a.ASSET_NUMBER,dateadd( mi,?,a.LAST_SERVICE_DATE) as LAST_SERVICE_DATE ,dateadd( mi,?,a.SERVICE_DATE)  as SERVICE_DATE, a.EVENT_PARAM,a.EVENT_DATE,a.TASK_ID,a.POSTPONE_DATE,a.POSTPONE_REMARKS,b.Maintenance as TASK_NAME,a.DUE_DAYS,a.DUE_MILEAGE from FMS.dbo.PREVENTIVE_EVENTS a left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID = b.MaintenanceId and a.SYSTEM_ID = b.SystemId and a.CUSTOMER_ID=b.CUSTOMER_ID where a.SYSTEM_ID =? and a.CUSTOMER_ID=? and a.ALERT_TYPE ='1' and a.ASSET_NUMBER = ?";

	
	public static final String GET_TASKS_HISTORY_DETAILS="select a.ASSET_NUMBER,b.Maintenance as TASK_NAME,a.LAST_SERVICE_DATE,a.EVENT_PARAM,a.REMARKS,isNull(a.ALERT_TYPE, 0) as ALERT_TYPE from FMS.dbo.PREVENTIVE_EVENTS_HISTORY a left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID = b.MaintenanceId and a.SYSTEM_ID = b.SystemId and a.CUSTOMER_ID=b.CUSTOMER_ID where a.SYSTEM_ID =? and a.CUSTOMER_ID=? and a.ASSET_NUMBER = ?";
	
	public static final String GET_TASKS_HISTORY_DETAILS_NEW="select a.ASSET_NUMBER,b.Maintenance as TASK_NAME,  dateadd( mi,?,a.LAST_SERVICE_DATE) as LAST_SERVICE_DATE , dateadd( mi,?,a.SERVICE_DATE)  as SERVICE_DATE ,a.EVENT_PARAM,a.REMARKS,isNull(a.ALERT_TYPE, 0) as ALERT_TYPE from FMS.dbo.PREVENTIVE_EVENTS_HISTORY a left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID = b.MaintenanceId and a.SYSTEM_ID = b.SystemId and a.CUSTOMER_ID=b.CUSTOMER_ID where a.SYSTEM_ID =? and a.CUSTOMER_ID=? and a.ASSET_NUMBER = ?";

	
	public static final String UPDATE_REMARKS="update FMS.dbo.PREVENTIVE_EVENTS set REMARKS=? where ASSET_NUMBER=? and TASK_ID=? and ALERT_TYPE=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	 
	
	
	public static final String  GET_AND_EXPIRING_SOON_DETAILS_REPORT=" select isnull(a.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(lvs.VEHICLE_ID,'') as VEHICLE_ID,isnull(lvs.GROUP_NAME,'') as VEHICLE_GROUP,isnull(b.Maintenance,'') as TASK_NAME, " 
								+ " isnull(a.LAST_SERVICE_DATE,'')as LAST_SERVICE_DATE ,isnull(a.EVENT_PARAM,'') as RENEWAL_BY,isnull(tvm.Odometer,'') as ODOMETER, isnull(a.SERVICE_DATE,'') as SERVICE_DATE ," 
								+ " isnull(a.DUE_DAYS,'') as DUE_DAYS,isnull(a.DUE_MILEAGE,'') as DUE_MILEAGE, isnull(a.EVENT_DATE,'') as EXPIRY_DATE,isnull(a.ALERT_TYPE,'') as ALERT_TYPE,isnull(REMARKS,'') as REMARKS "
								+ " from FMS.dbo.PREVENTIVE_EVENTS a " 
								+ " inner join AMS.dbo.Vehicle_User c on c.Registration_no=a.ASSET_NUMBER collate database_default " 
								+ " and c.System_id=a.SYSTEM_ID "
								+ " left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID = b.MaintenanceId and a.SYSTEM_ID = b.SystemId and a.CUSTOMER_ID=b.CUSTOMER_ID "
								+ " left outer join AMS.dbo.Live_Vision_Support  lvs (nolock) on  a.SYSTEM_ID = lvs.SYSTEM_ID and a.ASSET_NUMBER = lvs.REGISTRATION_NO collate database_default "
								+ " left outer join AMS.dbo.tblVehicleMaster  tvm (nolock) on  a.SYSTEM_ID = tvm.System_id and a.ASSET_NUMBER = tvm.VehicleNo collate database_default "
								+ " where a.SYSTEM_ID =? and a.CUSTOMER_ID=? and a.ALERT_TYPE =? " 
								+ " and (a.POSTPONE_DATE < dateadd(dd,-1,getDate()) or a.POSTPONE_DATE is null) "
								+ " and EVENT_DATE between ? and ? and c.User_id=? order by a.ASSET_NUMBER ";
	
	
	public static final String GET_HISTORY_DETAILS=" select isnull(a.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(lvs.VEHICLE_ID,'') as VEHICLE_ID,isnull(lvs.GROUP_NAME,'') as VEHICLE_GROUP,isnull(b.Maintenance,'') as TASK_NAME, "
											+ " isnull(a.LAST_SERVICE_DATE,'')as LAST_SERVICE_DATE ,isnull(a.EVENT_PARAM,'') as RENEWAL_BY,isnull(tvm.Odometer,'') as ODOMETER, isnull(a.SERVICE_DATE,'') as SERVICE_DATE, "
											+ " isnull(a.DUE_DAYS,'') as DUE_DAYS,isnull(a.DUE_MILEAGE,'') as DUE_MILEAGE, isnull(a.EVENT_DATE,'') as EXPIRY_DATE,isnull(a.ALERT_TYPE,'') as ALERT_TYPE,isnull(REMARKS,'') as REMARKS"
											+ " from FMS.dbo.PREVENTIVE_EVENTS_HISTORY a "
											+ " inner join AMS.dbo.Vehicle_User c on c.Registration_no=a.ASSET_NUMBER collate database_default and c.System_id=a.SYSTEM_ID"
											+ " left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID = b.MaintenanceId and a.SYSTEM_ID = b.SystemId "
											+ " left outer join AMS.dbo.Live_Vision_Support  lvs (nolock) on  a.SYSTEM_ID = lvs.SYSTEM_ID and a.ASSET_NUMBER = lvs.REGISTRATION_NO collate database_default "
											+ " left outer join AMS.dbo.tblVehicleMaster  tvm (nolock) on  a.SYSTEM_ID = tvm.System_id and a.ASSET_NUMBER = tvm.VehicleNo collate database_default "
											+ " and a.CUSTOMER_ID=b.CUSTOMER_ID where a.SYSTEM_ID =? and a.CUSTOMER_ID=? and a.SERVICE_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and c.User_id=? order by a.ASSET_NUMBER ";
	
	
	public static final String  GET_ALREADY_EXPIRED_DETAILS_REPORT=" select isnull(a.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(lvs.VEHICLE_ID,'') as VEHICLE_ID,isnull(lvs.GROUP_NAME,'') as VEHICLE_GROUP,isnull(b.Maintenance,'') as TASK_NAME, "
		+ " isnull(a.LAST_SERVICE_DATE,'')as LAST_SERVICE_DATE ,isnull(a.EVENT_PARAM,'') as RENEWAL_BY,isnull(tvm.Odometer,'') as ODOMETER, isnull(a.SERVICE_DATE,'') as SERVICE_DATE, "
		+ " isnull(a.DUE_DAYS,'') as DUE_DAYS,isnull(a.DUE_MILEAGE,'') as DUE_MILEAGE, isnull(a.EVENT_DATE,'') as EXPIRY_DATE,isnull(a.ALERT_TYPE,'') as ALERT_TYPE,isnull(REMARKS,'') as REMARKS"
		+ " from FMS.dbo.PREVENTIVE_EVENTS a "
		+ " inner join AMS.dbo.Vehicle_User c on c.Registration_no=a.ASSET_NUMBER collate database_default and c.System_id=a.SYSTEM_ID"
		+ " left outer join FMS.dbo.Maintenance_Mstr b on a.TASK_ID = b.MaintenanceId and a.SYSTEM_ID = b.SystemId "
		+ " left outer join AMS.dbo.Live_Vision_Support  lvs (nolock) on  a.SYSTEM_ID = lvs.SYSTEM_ID and a.ASSET_NUMBER = lvs.REGISTRATION_NO collate database_default "
		+ " left outer join AMS.dbo.tblVehicleMaster  tvm (nolock) on  a.SYSTEM_ID = tvm.System_id and a.ASSET_NUMBER = tvm.VehicleNo collate database_default "
		+ " and a.CUSTOMER_ID=b.CUSTOMER_ID where a.SYSTEM_ID =? and a.CUSTOMER_ID=? and a.ALERT_TYPE =? and c.User_id=? order by a.ASSET_NUMBER ";

	public static final String UPDATE_POSTPONE_DETAILS=" update FMS.dbo.PREVENTIVE_EVENTS set POSTPONE_BY=?,POSTPONE_DATE=?,POSTPONE_REMARKS=? where ASSET_NUMBER=? and TASK_ID=? and ALERT_TYPE=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_UTC_FOR_LAST_SERVICE_DATE="Select dateadd(mi,-?,?) as UTCDATETIME ";
	
}
