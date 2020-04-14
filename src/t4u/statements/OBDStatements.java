package t4u.statements;

public class OBDStatements {

	public static final String GET_AGGREGRATE_ERRORCODE = "select count(*),DATEADD(day, DATEDIFF(day, 0, dateadd(mi,?,GMT)), 0) as Dates from CANIQ_ERROR_CODES where GMT>DATEADD(day, DATEDIFF(day, 5, dateadd(mi,-?,getdate())), 0) and getutcdate()"
														 +" GROUP BY DATEADD(day, DATEDIFF(day, 0, dateadd(mi,?,GMT)), 0)";
	public static final String GET_AGGREGRATE_ERRORCODE_DUMMY = "select count(GMT) as Count,DATEADD(day, DATEDIFF(day, 0, dateadd(mi,330,GMT)), 0) as Dates from HISTORY_DATA_261(nolock) where GMT between DATEADD(day, DATEDIFF(day, 5, dateadd(mi,-330,getdate())), 0) and getutcdate()"
															  + " GROUP BY DATEADD(day, DATEDIFF(day, 0, dateadd(mi,330,GMT)), 0)";
	
    public static final String GET_OVER_SPEED_ALERT_COUNT = " select sum(r.ALERT_COUNT) as ALERT_COUNT from (select count(a.REGISTRATION_NO) as ALERT_COUNT from ALERT.dbo.OVER_SPEED_DATA a   " +
    		" inner join AMS.dbo.Vehicle_User v on a.SYSTEM_ID=v.System_id and a.REGISTRATION_NO = v.Registration_no collate database_default " +
    		" inner join Vehicle_association va on a.REGISTRATION_NO = va.Registration_no collate database_default "+
    		" where GMT >= dateadd(hh,-72,getutcdate()) and a.CUSTOMER_ID=?  and a.SYSTEM_ID=? and v.User_id=? and va.Unit_Type_Code=?" +
    		" and REMARK is  null  " +
    		" union all   " +
    		" select count(a.REGISTRATION_NO) as ALERT_COUNT from ALERT.dbo.OVER_SPEED_DATA_HISTORY a  " +
    		" inner join AMS.dbo.Vehicle_User v on a.SYSTEM_ID=v.System_id and a.REGISTRATION_NO = v.Registration_no collate database_default " +
    		" inner join Vehicle_association va on a.REGISTRATION_NO = va.Registration_no collate database_default "+
    		" where GMT >= dateadd(hh,-72,getutcdate()) and a.CUSTOMER_ID=?  and a.SYSTEM_ID=? and v.User_id=? and va.Unit_Type_Code=?" +
    		" and REMARK is  null)r " ;
    
    public static final String GET_ALERT_COUNT =" select r.TYPE_OF_ALERT,sum(r.ALERT_COUNT) as  ALERT_COUNT from " +
			" (select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as ALERT_COUNT from AMS.dbo.Alert a (nolock) " +
    		" inner join Vehicle_association va on a.REGISTRATION_NO = va.Registration_no"+
			" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? " + 
			" where a.SYSTEM_ID=?  and a.CLIENTID=? and va.Unit_Type_Code=?"  + 
			" and a.TYPE_OF_ALERT in (84) "  +
			" and a.GMT >= dateadd(hh,-72,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') "  +
			" group by a.TYPE_OF_ALERT "  +
			" union all " +
			" select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as ALERT_COUNT from AMS.dbo.Alert_History a (nolock) "  +
			" inner join Vehicle_association va on a.REGISTRATION_NO = va.Registration_no"+
			" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? " + 
			" where a.SYSTEM_ID=?  and a.CLIENTID=? and va.Unit_Type_Code=?" + 
			" and a.TYPE_OF_ALERT in (84) "  +
			" and a.GMT >= dateadd(hh,-72,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') "  +
			" group by a.TYPE_OF_ALERT ) r group by r.TYPE_OF_ALERT order by r.TYPE_OF_ALERT desc " ;
    
    public static final String GET_ALERT_COUNT_NON_COMMUNICATING =" select r.TYPE_OF_ALERT,sum(r.ALERT_COUNT) as  ALERT_COUNT from " +
    		" (select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as ALERT_COUNT from AMS.dbo.Alert a (nolock) " +
    		" inner join Vehicle_association va on a.REGISTRATION_NO = va.Registration_no "+
    		" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? " + 
    		" where a.SYSTEM_ID=?  and a.CLIENTID=? and va.Unit_Type_Code=?"  + 
    		" and a.TYPE_OF_ALERT in (85,148) "  +
    		" and a.GMT >= dateadd(hh,-72,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') "  +
    		" group by a.TYPE_OF_ALERT "  +
    		" union all " +
    		" select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as ALERT_COUNT from AMS.dbo.Alert_History a (nolock) "  +
    		" inner join Vehicle_association va on a.REGISTRATION_NO = va.Registration_no "+
    		" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? " + 
    		" where a.SYSTEM_ID=?  and a.CLIENTID=? and va.Unit_Type_Code=?" + 
    		" and a.TYPE_OF_ALERT in (85,148) "  +
    		" and a.GMT >= dateadd(hh,-72,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') "  +
    		" group by a.TYPE_OF_ALERT ) r group by r.TYPE_OF_ALERT order by r.TYPE_OF_ALERT desc " ;
    
	public static final String GET_TOTAL_ASSET_COUNT =  " select count(*) as COUNT from AMS.dbo.gpsdata_history_latest a " +
			 "  inner join AMS.dbo.Vehicle_association va on a.REGISTRATION_NO=va.Registration_no"+
			 " inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id " +
			 " where a.System_id = ? and a.CLIENTID = ? and va.Unit_Type_Code=? and b.User_id=?";

	public static final String GET_NON_COMMUNICATING=  " select count(*) as NON_COMMUNICATING from AMS.dbo.gpsdata_history_latest a " +
			"  inner join AMS.dbo.Vehicle_association va on a.REGISTRATION_NO=va.Registration_no"+	
			" inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " +
			" where a.CLIENTID=? and  a.System_id=? and va.Unit_Type_Code=? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= 6 and b.User_id=?";
	
	
	public static final String GET_NON_COMMUNICATING_NEW=  "select count(*) as NON_COMMUNICATING from AMS.dbo.GPSDATA_LIVE_CANIQ a "+
	  "inner join AMS.dbo.Vehicle_association va on a.REGISTRATION_NO=va.Registration_no "+
	  "inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "+
	  "where a.System_id=? and a.CLIENTID=? and va.Unit_Type_Code=68 and b.User_id=? and # a.LOCATION <>'No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= 8 ";
	
	public static final String GET_NON_COMMUNICATING_LESS=  "select count(*) as NON_COMMUNICATING_LS from AMS.dbo.GPSDATA_LIVE_CANIQ a "+
	  "inner join AMS.dbo.Vehicle_association va on a.REGISTRATION_NO=va.Registration_no "+
	  "inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "+
	  "where a.System_id=? and a.CLIENTID=? and va.Unit_Type_Code=68 and b.User_id=? and # a.LOCATION <>'No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) <= 8 ";
	
	public static final String GET_COUNT_MAIN_BATTERY_LOW="select Count(REGISTRATION_NO) as cnt from gpsdata_history_latest a "+
	"where REGISTRATION_NO in (select REGISTRATION_NO from dbo.GPSDATA_LIVE_CANIQ  c "+
	"inner join AMS.dbo.Vehicle_User b on c.REGISTRATION_NO = b.Registration_no and c.System_id=b.System_id "+
	"where c.System_id=? and c.CLIENTID=? and  b.User_id=? ) # "+
	"AND MAIN_BATTERY_VOLTAGE BETWEEN 2 AND 7 ";
	
	public static final String GET_COUNT_OF_ALL_OBD_ASSETS ="select count(*) as ALL_ASSET from AMS.dbo.GPSDATA_LIVE_CANIQ a "+
	  "inner join AMS.dbo.Vehicle_association va on a.REGISTRATION_NO=va.Registration_no "+
	  "inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "+
	  "where a.System_id=? and a.CLIENTID=? and va.Unit_Type_Code=68 and b.User_id=? ";
	
	
	public static final String GET_NOGPS_VEHICLES= " select count(*) as NOGPS from AMS.dbo.gpsdata_history_latest a " +
			"  inner join AMS.dbo.Vehicle_association va on a.REGISTRATION_NO=va.Registration_no"+
			" inner join  AMS.dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id " 	+
			" where a.CLIENTID=? and a.System_id=? and va.Unit_Type_Code=? and a.LOCATION ='No GPS Device Connected' and b.User_id=?";

	
	public static final String GET_VOLTAGE_DRAIN = " Select count(*) as COUNT from AMS.dbo.gpsdata_history_latest a "+
													" inner join Vehicle_association va on a.REGISTRATION_NO = va.Registration_no"+
													 " inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "+
													 " where a.System_id = ? and a.CLIENTID = ? and va.Unit_Type_Code=?  and b.User_id=? AND MAIN_BATTERY_VOLTAGE BETWEEN 2 AND 7 ";
	
	public static final String GET_OVER_SPEED_ALERT =   " select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,a.GMT as [GMT], " +
			" GPS_DATETIME,a.LOCATION,isnull(a.SPEED, 0) as SPEED,isnull(a.REMARK,'') as REMARKS,a.SPEED as OVERSPEED, " +
			" 2 as TYPE_OF_ALERT,'Alert' as ALERT_TYPE from ALERT.dbo.OVER_SPEED_DATA a inner join AMS.dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default   " +
			" inner join Vehicle_association va on  a.REGISTRATION_NO=va.Registration_no collate database_default"+
			" inner join AMS.dbo.Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no " +
			" where GMT >= dateadd(hh,-72,getutcdate()) and a.CUSTOMER_ID=?  and b.SYSTEM_ID=? and va.Unit_Type_Code=? and v.User_id=? " +
			" and REMARK is null " +
			" union all " +
			" select a.ID as SLNO,a.REGISTRATION_NO as REGISTRATION_NO,a.GMT as [GMT], " +
			" GPS_DATETIME,a.LOCATION,isnull(a.SPEED, 0) as SPEED,isnull(a.REMARK,'') as REMARKS,a.SPEED as OVERSPEED, " +
			" 2 as TYPE_OF_ALERT,'History' as ALERT_TYPE from ALERT.dbo.OVER_SPEED_DATA_HISTORY a inner join AMS.dbo.VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER collate database_default  " +
			" inner join Vehicle_association va on  a.REGISTRATION_NO=va.Registration_no collate database_default"+
			" inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no " +
			" where GMT >= dateadd(hh,-72,getutcdate()) and a.CUSTOMER_ID=?  and b.SYSTEM_ID=? and va.Unit_Type_Code=? and v.User_id=? " +
			" and REMARK is null order by GPS_DATETIME desc ";
	
	public static final String GET_NON_COMMUNICATING_ALERT_DETAILS =      " select a.SLNO,MONITOR_STATUS,a.REGISTRATION_NO,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isnull(dateadd(mi,?,a.GMT),'') as GMT, " +
	" a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID,'Alert' as ALERT_TYPE from AMS.dbo.Alert a " +
	" inner join Vehicle_association va on a.REGISTRATION_NO=va.Registration_no "+
	" inner join Vehicle_User b on a.SYSTEM_ID=b.System_id and a.REGISTRATION_NO = b.Registration_no " +
	" where a.SYSTEM_ID=? and a.CLIENTID=? and va.Unit_Type_Code=? and a.TYPE_OF_ALERT= ? and 	 " +										
	" a.GMT >= dateadd(hh,-72,getutcdate()) " +
	" and b.User_id=? and (MONITOR_STATUS is null or MONITOR_STATUS='N')" +
	" union all " +
	" select a.SLNO,MONITOR_STATUS,a.REGISTRATION_NO,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isnull(dateadd(mi,?,a.GMT),'') as GMT, " +
	" a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID,'History' as ALERT_TYPE from AMS.dbo.Alert_History a " +
	" inner join Vehicle_association va on a.REGISTRATION_NO=va.Registration_no "+
	" inner join Vehicle_User b on a.SYSTEM_ID=b.System_id and a.REGISTRATION_NO = b.Registration_no " +
	" where a.SYSTEM_ID=? and a.CLIENTID=? and va.Unit_Type_Code=? and a.TYPE_OF_ALERT= ? and " +										
	" a.GMT >= dateadd(hh,-72,getutcdate()) " +
	" and b.User_id=?  and (MONITOR_STATUS is null or MONITOR_STATUS='N')" +
	" order by GPS_DATETIME desc " ;
	
	public static final String GET_ALERT_DETAILS =      " select a.SLNO,MONITOR_STATUS,a.REGISTRATION_NO,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isnull(dateadd(mi,?,a.GMT),'') as GMT, " +
			" a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID,'Alert' as ALERT_TYPE from AMS.dbo.Alert a " +
			" inner join Vehicle_association va on a.REGISTRATION_NO = va.Registration_no"+
			" inner join Vehicle_User b on a.SYSTEM_ID=b.System_id and a.REGISTRATION_NO = b.Registration_no " +
			" where a.SYSTEM_ID=? and a.CLIENTID=? and va.Unit_Type_Code=? and a.TYPE_OF_ALERT= ? and 	 " +										
			" a.GMT >= dateadd(hh,-72,getutcdate()) " +
			" and b.User_id=? and  (MONITOR_STATUS is null or MONITOR_STATUS='N') " +
			" union all " +
			" select a.SLNO,MONITOR_STATUS,a.REGISTRATION_NO,a.LOCATION,isnull(a.GPS_DATETIME,'') as GPS_DATETIME,isnull(dateadd(mi,?,a.GMT),'') as GMT, " +
			" a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID,'History' as ALERT_TYPE from AMS.dbo.Alert_History a " +
			" inner join Vehicle_association va on a.REGISTRATION_NO = va.Registration_no"+
			" inner join Vehicle_User b on a.SYSTEM_ID=b.System_id and a.REGISTRATION_NO = b.Registration_no " +
			" where a.SYSTEM_ID=? and a.CLIENTID=? and va.Unit_Type_Code=? and a.TYPE_OF_ALERT= ? and " +										
			" a.GMT >= dateadd(hh,-72,getutcdate()) " +
			" and b.User_id=? and  (MONITOR_STATUS is null or MONITOR_STATUS='N') " +
			" order by GPS_DATETIME desc " ;
	
	public static final String GET_ALERT_COUNT_DEVICE_BATERY_CONNECTION= "select count(*) as AlertCount from ALERT.dbo.BATTERY_CONNECTION_ALERT_DATA bc "+
			"inner join Vehicle_association va on bc.REGISTRATION_NO = va.Registration_no collate database_default where SYSTEM_ID=? AND CUSTOMER_ID=? and va.Unit_Type_Code=? and DATEDIFF(hh,GMT,getutcdate())<72 and REMARKS is null ";
	
//	public static final String GET_ERRORCODE_DETAILS = "select SLNO,REGISTRATION_NO,UNIT_NO,ERROR_CODE, ERROR_DESC,dateadd(mi,?,GMT) as GPS_TIME,isNull(REMARKS,'') as REMARKS,tb.VehicleType as VEHTYPE,vm.ModelName as MODEL from AMS.dbo.CANIQ_ERROR_CODES c " +
//			" inner join AMS.dbo.tblVehicleMaster tb on REGISTRATION_NO=tb.VehicleNo " +
//			" inner join FMS.dbo.Vehicle_Model vm  on tb.System_id=vm.SystemId and tb.Model=vm.ModelTypeId " +
//			" where  c.SYSTEM_ID=? and c.CLIENT_ID=? ";
	
	public static final String GET_ERRORCODE_DETAILS = "select SLNO,REGISTRATION_NO,UNIT_NO,ERROR_CODE, ERROR_DESC,dateadd(mi,?,GMT) as GPS_TIME,isNull(REMARKS,'') as REMARKS,'HYUANDAI' as VEHTYPE,'HYUNDAI XCENT' as MODEL from AMS.dbo.CANIQ_ERROR_CODES c " +
	" where  c.SYSTEM_ID=? and c.CLIENT_ID=? ";
	
	
	public static final String DEVICE_BATERY_CONNECTION_DETAIL= "select REGISTRATION_NO,LOCATION,isNull(GPS_DATETIME,'') as GPS_DATETIME,SPEED from ALERT.dbo.BATTERY_CONNECTION_ALERT_DATA bc "+
			"inner join Vehicle_association va on bc.REGISTRATION_NO = va.Registration_no collate database_default where SYSTEM_ID=? AND CUSTOMER_ID=? and va.Unit_Type_Code=? and DATEDIFF(hh,GMT,getutcdate())<72 and REMARKS is null and LOCATION is not NULL";
	
	public static final String GET_ERROR_CODES = "select isnull(ERROR_CODE,'') as codeId,isnull(ERROR_DESC,'') as codeDesc,isnull(dateadd(mi,?,GMT),'') as codeDateTime," +
	" isnull(REMARKS,'') as remarks from dbo.CANIQ_ERROR_CODES where REGISTRATION_NO=? and SYSTEM_ID=? and CLIENT_ID=? ";
	
	public static final String GET_VEHICLE_MAP_DETAILS = "select isnull(LIMIT_TYPE,0) as limitType,isnull(LIMIT_VALUE,'') as limitValue from OBD_VEHICLE_MAP_DETAILS " +
	" where SYSTEM_ID=? and CUSTOMER_ID=? and PARAMETER_ID=?";

	public static final String GET_VEHICLE_DETAILS = "select isnull(tb.Model,'') as modelId,isnull(vm.ModelName,'') as modelName,isnull(tb.VehicleType,'') as vehicleMake from AMS.dbo.tblVehicleMaster tb"+
	" inner join FMS.dbo.Vehicle_Model vm  on tb.System_id=vm.SystemId and tb.Model=vm.ModelTypeId"+
	" where System_id=? and VehicleNo=?";
	
	public static final String Get_OBD_ASSET_NUMBER_LIST="select  vc.REGISTRATION_NUMBER as ASSET_NUMBER from VEHICLE_CLIENT vc " +
	"inner join	AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER=vu.Registration_no and  vc.SYSTEM_ID=vu.System_id and vu.User_id=? " +
	"inner join  AMS.dbo.tblVehicleMaster tb  on vc.REGISTRATION_NUMBER=tb.VehicleNo " +
	"inner join Vehicle_association va on vc.REGISTRATION_NUMBER = va.Registration_no and va.Unit_Type_Code=68 " +
	"where vc.SYSTEM_ID = ? and vc.CLIENT_ID=?  and tb.Model in (select VEHICLE_MODEL from AMS.dbo.OBD_PARAMETER_LOOKUP where FIELD_LABEL='FUEL_QTY') " +
	"order by vc.REGISTRATION_NUMBER";
	
	public static final String GET_COUNT_OF_DTC_ERROR="select " +
	"count(case when ERROR_CODE like 'P%' then 1 end)	as Poweer, " +
	"count(case when ERROR_CODE like 'C%' then 1 end)	as Chasis," +
	"count(case when ERROR_CODE like 'B%' then 1 end)	as Body," +
	"count(case when ERROR_CODE like 'N%' then 1 end)	as Network from  dbo.CANIQ_ERROR_CODES where SYSTEM_ID=? ";

public static final String GET_LIST_OF_POWER_TRAIN="select REGISTRATION_NO,UNIT_NO,ERROR_DESC,GPS_DATETIME,LOCATION from  dbo.CANIQ_ERROR_CODES" +
	" where ERROR_CODE like 'P%' and  SYSTEM_ID=?";


public static final String GET_LIST_OF_POWER_TRAIN_FINAL= "select cec.REGISTRATION_NO,cec.ERROR_CODE,dateadd(mi,330,max(cec.GMT)) as GPS_DATETIME,cec.ERROR_DESC from dbo.CANIQ_ERROR_CODES cec "+
"inner join AMS.dbo.Vehicle_User b on cec.REGISTRATION_NO = b.Registration_no and cec.SYSTEM_ID=b.System_id "+
"where cec.ERROR_CODE like 'P%' and cec.SYSTEM_ID= ? and cec.CLIENT_ID=? and  b.User_id= ? # and IS_RECENT='Y' "+
"group by  cec.REGISTRATION_NO,cec.ERROR_CODE,cec.ERROR_DESC order by GPS_DATETIME desc ";


public static final String GET_LIST_OF_POWER_BODY_FINAL ="select cec.REGISTRATION_NO,cec.ERROR_CODE,dateadd(mi,330,max(cec.GMT)) as GPS_DATETIME,cec.ERROR_DESC from dbo.CANIQ_ERROR_CODES cec "+
"inner join AMS.dbo.Vehicle_User b on cec.REGISTRATION_NO = b.Registration_no and cec.SYSTEM_ID=b.System_id "+
"where cec.ERROR_CODE like 'B%' and cec.SYSTEM_ID= ? and cec.CLIENT_ID=? and  b.User_id= ? # and IS_RECENT='Y' "+
"group by  cec.REGISTRATION_NO,cec.ERROR_CODE,cec.ERROR_DESC order by GPS_DATETIME desc ";

public static final String GET_LIST_OF_POWER_CHASSIS_FINAL ="select cec.REGISTRATION_NO,cec.ERROR_CODE,dateadd(mi,330,max(cec.GMT)) as GPS_DATETIME,cec.ERROR_DESC from dbo.CANIQ_ERROR_CODES cec "+
"inner join AMS.dbo.Vehicle_User b on cec.REGISTRATION_NO = b.Registration_no and cec.SYSTEM_ID=b.System_id "+
"where cec.ERROR_CODE like 'C%' and cec.SYSTEM_ID= ? and cec.CLIENT_ID=?  and  b.User_id= ? # and IS_RECENT='Y' "+
"group by  cec.REGISTRATION_NO,cec.ERROR_CODE,cec.ERROR_DESC order by GPS_DATETIME desc ";

public static final String GET_LIST_OF_POWER_NETWORK_FINAL ="select cec.REGISTRATION_NO,cec.ERROR_CODE,dateadd(mi,330,max(cec.GMT)) as GPS_DATETIME,cec.ERROR_DESC from dbo.CANIQ_ERROR_CODES cec "+
"inner join AMS.dbo.Vehicle_User b on cec.REGISTRATION_NO = b.Registration_no and cec.SYSTEM_ID=b.System_id "+
"where cec.ERROR_CODE like 'N%' and cec.SYSTEM_ID= ? and cec.CLIENT_ID=? and  b.User_id= ? # and IS_RECENT='Y' "+
"group by  cec.REGISTRATION_NO,cec.ERROR_CODE,cec.ERROR_DESC order by GPS_DATETIME desc ";


//public static final String GET_LIST_OF_GPS_TAMPERING="select REGISTRATION_NO,GPS_DATETIME,LOCATION, 'GPS TAMPERED' as VALUE from dbo.Alert where  SYSTEM_ID=?  and TYPE_OF_ALERT=148 ";

public static final String GET_LIST_OF_NON_COMM= "select a.REGISTRATION_NO,'Non-Communicating' as VALUE,GPS_DATETIME,LOCATION,a.GMT from AMS.dbo.GPSDATA_LIVE_CANIQ a "+
"inner join AMS.dbo.Vehicle_association va on a.REGISTRATION_NO=va.Registration_no "+
"inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "+
"where a.System_id=? and a.CLIENTID=? and va.Unit_Type_Code=68 and b.User_id=? and # "+
"a.LOCATION <>'No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) >= 8 order by a.GMT DESC ";

public static final String GET_LIST_OF_NON_COMM_LS= "select a.REGISTRATION_NO,'Non-Communicating' as VALUE,GPS_DATETIME,LOCATION,a.GMT from AMS.dbo.GPSDATA_LIVE_CANIQ a "+
"inner join AMS.dbo.Vehicle_association va on a.REGISTRATION_NO=va.Registration_no "+
"inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "+
"where a.System_id=? and a.CLIENTID=? and va.Unit_Type_Code=68 and b.User_id=? and  # "+
"a.LOCATION <>'No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) <= 8 order by a.GMT DESC ";


public static final String GET_LIST_OF_FUEL_QTY= "select distinct (a.REGISTRATION_NO),oat.VALUE,a.GPS_DATETIME,isnull(a.LOCATION,'') as LOCATION,a.GMT from Alert a " +
"inner join OBD_ALERT_TRANSACTION oat on oat.REGISTRATION_NO=a.REGISTRATION_NO  and oat.TYPE_OF_ALERT=167 and oat.STATUS='Y' and oat.START_GMT=a.GMT " +
"inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and oat.SYSTEM_ID=? and oat.CLIENT_ID=? and b.User_id=? #  " +
"order by a.GMT DESC ";

public static final String GET_LIST_OF_COOL_QTY= "select distinct (a.REGISTRATION_NO),oat.VALUE,a.GPS_DATETIME,isnull(a.LOCATION,'') as LOCATION,a.GMT from Alert a " +
"inner join OBD_ALERT_TRANSACTION oat on oat.REGISTRATION_NO=a.REGISTRATION_NO  and oat.TYPE_OF_ALERT=159 and oat.STATUS='Y' and oat.START_GMT=a.GMT " +
"inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and oat.SYSTEM_ID=? and oat.CLIENT_ID=? and b.User_id=? #  " +
"order by a.GMT DESC ";

public static final String GET_LIST_OF_PARK_BRAKE= "select distinct (a.REGISTRATION_NO),oat.VALUE,a.GPS_DATETIME,isnull(a.LOCATION,'') as LOCATION,a.GMT from Alert a " +
"inner join OBD_ALERT_TRANSACTION oat on oat.REGISTRATION_NO=a.REGISTRATION_NO  and oat.TYPE_OF_ALERT=176 and oat.STATUS='Y' and oat.START_GMT=a.GMT " +
"inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and oat.SYSTEM_ID=? and oat.CLIENT_ID=? and b.User_id=? #  " +
"order by a.GMT DESC ";

public static final String GET_LIST_OF_TOWING= "select distinct (a.REGISTRATION_NO),oat.VALUE,a.GPS_DATETIME,isnull(a.LOCATION,'') as LOCATION,a.GMT from Alert a " +
"inner join OBD_ALERT_TRANSACTION oat on oat.REGISTRATION_NO=a.REGISTRATION_NO  and oat.TYPE_OF_ALERT=175 and oat.STATUS='Y' and oat.START_GMT=a.GMT " +
"inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and oat.SYSTEM_ID=? and oat.CLIENT_ID=? and b.User_id=? #  " +
"order by a.GMT DESC ";

public static final String GET_LIST_MAIN_BATTERY_LOW="select a.REGISTRATION_NO,MAIN_BATTERY_VOLTAGE as VALUE,a.GPS_DATETIME, isnull(LOCATION,'') as LOCATION from gpsdata_history_latest a " +
"where REGISTRATION_NO in (select REGISTRATION_NO from dbo.GPSDATA_LIVE_CANIQ  c " +
"inner join AMS.dbo.Vehicle_User b on c.REGISTRATION_NO = b.Registration_no and c.System_id=b.System_id " +
"where c.System_id=?  and c.CLIENTID=? and  b.User_id=? ) # " +
"AND MAIN_BATTERY_VOLTAGE BETWEEN 2 AND 7 ORDER BY a.GMT desc";

public static final String GET_LIST_OF_CROSS_BORDER="select a.REGISTRATION_NO,'Cross Bordered' as VALUE, GPS_DATETIME,a.GMT,isnull(a.LOCATION,'') as LOCATION from Alert a " +
"where REGISTRATION_NO in(select REGISTRATION_NO from dbo.GPSDATA_LIVE_CANIQ  c " +
"inner join AMS.dbo.Vehicle_User b on c.REGISTRATION_NO = b.Registration_no and c.System_id=b.System_id " +
"where c.System_id=? and c.CLIENTID = ?  and  b.User_id=? )  and a.GMT >= dateadd(hh,-48,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') and TYPE_OF_ALERT =84  # " +
"ORDER BY a.GMT desc";

public static final String GET_LIST_OF_GPS_TAMP="select a.REGISTRATION_NO,'Gps Tampering' as VALUE, GPS_DATETIME,a.GMT,isnull(a.LOCATION,'') as LOCATION from Alert a " +
"where REGISTRATION_NO in(select REGISTRATION_NO from dbo.GPSDATA_LIVE_CANIQ  c " +
"inner join AMS.dbo.Vehicle_User b on c.REGISTRATION_NO = b.Registration_no and c.System_id=b.System_id " +
"where c.System_id=? and c.CLIENTID = ?  and  b.User_id=? ) and a.GMT >= dateadd(hh,-48,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') and TYPE_OF_ALERT =145 # " +
"ORDER BY a.GMT desc";

public static final String GET_LIST_OF_GPS_TAMP_AND_CROSS_BORD="select a.REGISTRATION_NO,'Gps Tamper And Cross' as VALUE, GPS_DATETIME,a.GMT,isnull(a.LOCATION,'') as LOCATION from Alert a " +
"where REGISTRATION_NO in(select REGISTRATION_NO from dbo.GPSDATA_LIVE_CANIQ  c " +
"inner join AMS.dbo.Vehicle_User b on c.REGISTRATION_NO = b.Registration_no and c.System_id=b.System_id " +
"where c.System_id=? and c.CLIENTID = ?  and  b.User_id=? )  and a.GMT >= dateadd(hh,-48,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') and TYPE_OF_ALERT =148 " +
"ORDER BY a.GMT desc";


public static final String GET_COUNT_OF_ALERTS_MAJOR= "select " +
"count(case when TYPE_OF_ALERT =84 then 1 end)	as CrossedBorder," +
"count(case when TYPE_OF_ALERT =145 then 1 end)	as GpsTamperingAlert," +
"count(case when TYPE_OF_ALERT =148 then 1 end)	as GpsTamperingCrossBorderAlert," +
"count(case when TYPE_OF_ALERT =172 then 1 end)	as ParkBrake," +
"count(case when TYPE_OF_ALERT =168 then 1 end)	as HeadLight," +
"count(case when TYPE_OF_ALERT =165 then 1 end)	as FuelLevel," +
"count(case when TYPE_OF_ALERT =159 then 1 end)	as CoolantTemp," +
"count(case when TYPE_OF_ALERT =94 then 1 end)	as LowBatteryBackup" +
" from dbo.Alert where  SYSTEM_ID=? " ;

public static final String GET_COUNT_OF_ALERTS_MAJOR_TEMP= "select count(REGISTRATION_NO),TYPE_OF_ALERT from dbo.Alert a  "+
"inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id and b.User_id=? "+
"where  a.SYSTEM_ID=? and TYPE_OF_ALERT in (84,145,148,172,168,165,159,94) "+
"group by TYPE_OF_ALERT "; 

public static final String GET_COUNT_OF_ALERTS_MAJOR_OBD="select count(REGISTRATION_NO) as cnt ,TYPE_OF_ALERT from dbo.Alert a "+
"inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.SYSTEM_ID=b.System_id "+
"where  a.SYSTEM_ID=? and a.CLIENTID=? and b.User_id=?  and GMT between dateadd(dd,-7,getutcdate()) and getutcdate() and TYPE_OF_ALERT in (159,176,167,175) # "+
"group by TYPE_OF_ALERT ";



public static final String GET_COUNT_OF_ALERTS_CROSS_BOR_TAMP="select Count(a.REGISTRATION_NO) as cnt,a.TYPE_OF_ALERT  from Alert a "+
"where REGISTRATION_NO in(select REGISTRATION_NO from dbo.GPSDATA_LIVE_CANIQ  c "+
"inner join AMS.dbo.Vehicle_User b on c.REGISTRATION_NO = b.Registration_no and c.System_id=b.System_id "+
"where c.System_id=? and c.CLIENTID = ? and  b.User_id=? )  and a.GMT >= dateadd(hh,-48,getutcdate()) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') and TYPE_OF_ALERT in (84,148,145) # "+
"group by TYPE_OF_ALERT ";

public static final String GET_COUNT_OF_DTC_ERROR_OF_POWER = "select REGISTRATION_NO,ERROR_CODE,max(GMT) from dbo.CANIQ_ERROR_CODES cec "+
"inner join AMS.dbo.Vehicle_User b on cec.REGISTRATION_NO = b.Registration_no and cec.SYSTEM_ID=b.System_id "+
"where cec.ERROR_CODE like 'P%' and cec.SYSTEM_ID= ? and cec.CLIENT_ID=?   and  b.User_id= ? # and IS_RECENT='Y' "+
"group by  REGISTRATION_NO,ERROR_CODE ";

public static final String GET_COUNT_OF_DTC_ERROR_OF_BODY= "select REGISTRATION_NO,ERROR_CODE,max(GMT) from dbo.CANIQ_ERROR_CODES cec "+
"inner join AMS.dbo.Vehicle_User b on cec.REGISTRATION_NO = b.Registration_no and cec.SYSTEM_ID=b.System_id "+
"where cec.ERROR_CODE like 'B%' and cec.SYSTEM_ID= ? and cec.CLIENT_ID=? and  b.User_id= ? # and IS_RECENT='Y' "+
"group by  REGISTRATION_NO,ERROR_CODE ";

public static final String GET_COUNT_OF_DTC_ERROR_OF_CHASSIS="select REGISTRATION_NO,ERROR_CODE,max(GMT) from dbo.CANIQ_ERROR_CODES cec "+
"inner join AMS.dbo.Vehicle_User b on cec.REGISTRATION_NO = b.Registration_no and cec.SYSTEM_ID=b.System_id "+
"where cec.ERROR_CODE like 'C%' and cec.SYSTEM_ID= ? and cec.CLIENT_ID=?  and  b.User_id= ? # and IS_RECENT='Y'"+
"group by  REGISTRATION_NO,ERROR_CODE ";

public static final String GET_COUNT_OF_DTC_ERROR_OF_NETWORK= "select REGISTRATION_NO,ERROR_CODE,max(GMT) from dbo.CANIQ_ERROR_CODES cec "+
"inner join AMS.dbo.Vehicle_User b on cec.REGISTRATION_NO = b.Registration_no and cec.SYSTEM_ID=b.System_id "+
"where cec.ERROR_CODE like 'N%' and cec.SYSTEM_ID= ? and cec.CLIENT_ID=? and  b.User_id= ? # and IS_RECENT='Y' "+
"group by  REGISTRATION_NO,ERROR_CODE ";

public static final String GET_PARAMETER_CONFIG_DETAILS = "select isnull(pmd.ID,0) as UID,isnull(pml.ID,0) as parameterId,isnull(pml.PARAMETER_NAME,'') as parameterName," +
" isnull(pml.UNIT,'') as unit,isnull(pmd.LIMIT_VALUE,'') as limitValue,isnull(pmd.LIMIT_TYPE,'') as limitType,isnull(pmd.LIMIT_TYPE,0) as limitTypeId"+
" from dbo.OBD_PARAMETER_LOOKUP pml"+ 
" left outer join dbo.OBD_VEHICLE_MAP_DETAILS pmd on pmd.PARAMETER_ID=pml.ID and pmd.SYSTEM_ID=pml.SYSTEM_ID and pmd.CUSTOMER_ID=pml.CUSTOMER_ID"+
" where pml.SYSTEM_ID=? and pml.CUSTOMER_ID=? and pml.VEHICLE_MODEL=?";

public static final String GET_VEHICLE_MAKE = "select distinct isnull(VEHICLE_MAKE,'') as vehicleMake from dbo.Vehicle_Model where SystemId=? and ClientId=? and VEHICLE_MAKE is not null";

public static final String GET_VEHICLE_MODEL = "select isnull(ModelTypeId,0) as id,isnull(ModelName,'') as vehicleModel from dbo.Vehicle_Model where SystemId=? and ClientId=? and VEHICLE_MAKE=?";

public static final String GET_LIMT_TYPE = "select isnull(TYPE,0) as type,isnull(VALUE,'') as value from dbo.LOOKUP_DETAILS where VERTICAL=? order by TYPE";

public static final String SAVE_PARAMETER_SETTING = "insert into dbo.OBD_VEHICLE_MAP_DETAILS (SYSTEM_ID,CUSTOMER_ID,PARAMETER_ID,UNIT,LIMIT_TYPE,LIMIT_VALUE,VEHICLE_MODEL,INSERTED_BY)"+
" values(?,?,?,?,?,?,?,?)";

public static final String DELETE_PARAMETER_SETTING = "delete from dbo.OBD_VEHICLE_MAP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and VEHICLE_MODEL=?";

public static final String MOVE_TO_PARAMETER_SETTING_HISTORY = "insert into dbo.OBD_VEHICLE_MAP_DETAILS_HISTORY select * from dbo.OBD_VEHICLE_MAP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and VEHICLE_MODEL=?";

public static final String GET_ERROR_CODE_DETAILS = "select isnull(SLNO,0) as UID,isnull(REGISTRATION_NO,'') as vehicleNo,isnull(ERROR_CODE,'') as errorCode,isnull(ERROR_DESC,'') as errorDesc,isnull(dateadd(mi,?,GMT),'') as dateTime,"+
" isnull(REMARKS,'') as remarks from CANIQ_ERROR_CODES where SYSTEM_ID=? and CLIENT_ID=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and REGISTRATION_NO in (select Registration_no from Vehicle_User where System_id=? and User_id=?) " +
" Union " +
" select isnull(SLNO,0) as UID,isnull(REGISTRATION_NO,'') as vehicleNo,isnull(ERROR_CODE,'') as errorCode,isnull(ERROR_DESC,'') as errorDesc,isnull(dateadd(mi,?,GMT),'') as dateTime,"+
" isnull(REMARKS,'') as remarks from CANIQ_ERROR_CODES_HISTORY where SYSTEM_ID=? and CLIENT_ID=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and REGISTRATION_NO in (select Registration_no from Vehicle_User where System_id=? and User_id=?) ";

public static final String UPDATE_REMARKS = "update CANIQ_ERROR_CODES set REMARKS=? where SYSTEM_ID=? and CLIENT_ID=? and SLNO=?";

public static final String GET_OBD_USER_VEHICLE = "select isnull(REGISTRATION_NO,'') as vehicleNo  from dbo.GPSDATA_LIVE_CANIQ can"+
" inner join Vehicle_User vu on vu.System_id=can.System_id  and can.REGISTRATION_NO=vu.Registration_no and vu.User_id=? and vu.System_id=? and can.CLIENTID=?";

public static final String GET_ERROR_CODE_DTAILS = "select isnull(ERROR_CODE,'') as errorCode,isnull(IS_J1939,0) as IS_J1939,isnull(IS_RECENT,'') as IS_RECENT from dbo.CANIQ_ERROR_CODES where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO=?  order by GMT";

public static final String GET_VEHICLLE_LOOKUP_DETAILS = "select isnull(ID,'') as parameterId,isnull(FIELD_LABEL,'') as fieldLabel,isnull(UNIT,'') as unit,PARAMETER_NAME from dbo.OBD_PARAMETER_LOOKUP where SYSTEM_ID=? and VEHICLE_MODEL=? ORDER BY DISPLAY_ORDER ";

public static final String GET_VEHICLLE_LOOKUP_DETAILS_EXPORT = "select isnull(ID,'') as parameterId,isnull(FIELD_LABEL,'') as fieldLabel,isnull(UNIT,'') as unit,PARAMETER_NAME,ISNULL(DATE_TYPE,'') as TYPE from dbo.OBD_PARAMETER_LOOKUP where SYSTEM_ID=? and VEHICLE_MODEL=? ORDER BY DISPLAY_ORDER ";

public static final String GET_IGNITION_STATUS = "select isnull(CATEGORY,'No GPS') as ignitionStatus,isnull(GPS_DATETIME,'') as gpsDate from dbo.gpsdata_history_latest where System_id=? and CLIENTID=? and REGISTRATION_NO=?";

public static final String GET_IGNITION_STATUS1 = "select isnull(CATEGORY,'') as ignitionStatus,isnull(dateadd(mi,?,GMT),'') as gmt from AMS.dbo.GPSDATA_LIVE_CANIQ where System_id=? and CLIENTID=? and REGISTRATION_NO=?";


public static final String GET_VOLTAGE = "select isnull(MAIN_BATTERY_VOLTAGE,'0') as Battery from dbo.gpsdata_history_latest where System_id=? and CLIENTID=? and REGISTRATION_NO=?";

public static final String GET_VEHICLE_COUNT = "select count(REGISTRATION_NO) as vehicleCount from gpsdata_history_latest where System_id=?";

public static final String GET_VEHICLE_COUNT_NEW = 
	" select count(REGISTRATION_NO) as vehicleCount from gpsdata_history_latest a "+
	" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id = b.System_id "+
	" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "+
	" where a.System_id=? and  b.User_id = ? ";

public static final String SELECT_GROUP_LIST_FOR_ASSET ="select a.REGISTRATION_NO from AMS.dbo.GPSDATA_LIVE_CANIQ a "+
			" inner join AMS.dbo.Vehicle_association va on a.REGISTRATION_NO=va.Registration_no "+
			" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "+
			" where a.System_id=? and a.CLIENTID=? and va.Unit_Type_Code=68 and b.User_id=?  ";

public static final String SELECT_OBD_DETAILS ="select GPS_DATE_TIME,ABS_AMBER_WARN,ABS_SWITCH,AC,ACC_PEDAL_POS,ACC_PEDAL_SWITCH,ACT_TORQ,AIRFLOW_RATE, "+
			" ANTI_LOCK_BRAKE,ASR_SWITCH,BRAKE_PEDAL,CLUTCH,COOLANT_TEMP,DISTANCE_MIL,DISTANCE_SCC,DOOR,DOOR_LOCK,DOOR_P, "+
			" DOOR_RL,DOOR_RR,DR_DEM_TORQ,ENG_DEM_TORQ,ENG_FUEL_ECO ,ENGINE_BRAKE,ENGINE_COOLANT_PER,ENGINE_INS_FUEL_ECO, "+
			" ENG_IMF_TEMP,ENGINE_LOAD,ENGINE_SPEED,FUEL_CONSUMED,FUEL_LEVEL,FUEL_PRESSURE,FUEL_RATE,FUEL_TEMP,HEAD_LIGHT, "+
			" IMA_PRESSURE,IN_AIRTEMP,OIL_PRESSURE,ODOMETER,POWER_INPUT,PARK_BRAKE,REVERSE,SEAT_BELT,SPEED,VEHICLE_SPEED  "+
			" from (select isnull(dateadd(mi,?,GMT),' ' )as GPS_DATE_TIME,isnull(ABS_AMBER_WARN,'-999') as ABS_AMBER_WARN, isnull(ABS_SWITCH,'-999') as ABS_SWITCH, isnull(AC,'-999' ) as AC," +
			" isnull(ACC_PEDAL_POS,'-999' ) as ACC_PEDAL_POS,isnull(ACC_PEDAL_SWITCH,'-999' ) as  ACC_PEDAL_SWITCH , "+
			" isnull(ACT_TORQ,'-999' ) as  ACT_TORQ,isnull(AIRFLOW_RATE,'-999' ) as  AIRFLOW_RATE,isnull(ANTI_LOCK_BRAKE,'-999' ) as  ANTI_LOCK_BRAKE,isnull(ASR_SWITCH,'-999' ) as  ASR_SWITCH, "+
			" isnull(BRAKE_PEDAL,'-999' ) as BRAKE_PEDAL,isnull(CLUTCH,'-999' ) as CLUTCH,isnull(COOLANT_TEMP,'-999' ) as COOLANT_TEMP,isnull(DISTANCE_MIL,'-999' ) as DISTANCE_MIL,"+
			" isnull(DISTANCE_SCC ,'-999' ) as DISTANCE_SCC,isnull(DOOR ,'-999' ) as DOOR,isnull(DOOR_LOCK ,'-999' ) as DOOR_LOCK,isnull(DOOR_P ,'-999' ) as DOOR_P,isnull(DOOR_RL ,'-999' )DOOR_RL, "+
			" isnull(ENG_DEM_TORQ,'-999' ) as ENG_DEM_TORQ,isnull(ENGINE_BRAKE ,'-999' ) as ENGINE_BRAKE, isnull(ENGINE_INS_FUEL_ECO ,'-999' ) as ENGINE_INS_FUEL_ECO,"+
			" isnull(DOOR_RR,'-999' ) as DOOR_RR,isnull(DR_DEM_TORQ ,'-999' ) as DR_DEM_TORQ,isnull(ENG_FUEL_ECO ,'-999' ) as ENG_FUEL_ECO, "+
			" isnull(ENG_IMF_TEMP,'-999' ) as ENG_IMF_TEMP,isnull(ENGINE_COOLANT_PER ,'-999' ) as ENGINE_COOLANT_PER,isnull(ENGINE_LOAD ,'-999' ) as ENGINE_LOAD, "+
			" isnull(ENGINE_SPEED ,'-999' ) as ENGINE_SPEED,isnull(FUEL_CONSUMED ,'-999' ) as FUEL_CONSUMED,isnull(FUEL_LEVEL,'-999' ) as FUEL_LEVEL, "+
			" isnull(FUEL_PRESSURE ,'-999' ) as FUEL_PRESSURE,isnull(FUEL_RATE,'-999' ) as FUEL_RATE,isnull(FUEL_TEMP,'-999' ) as FUEL_TEMP, "+
			" isnull(HEAD_LIGHT ,'-999' ) as HEAD_LIGHT,isnull(IMA_PRESSURE,'-999' ) as IMA_PRESSURE, "+
			" isnull(IN_AIRTEMP,'-999' ) as IN_AIRTEMP,isnull(ODOMETER,'-999' ) as ODOMETER,isnull(OIL_PRESSURE,'-999' ) as OIL_PRESSURE,isnull(PARK_BRAKE,'-999' ) as PARK_BRAKE, "+
			" isnull(POWER_INPUT,'-999' ) as POWER_INPUT,isnull(REVERSE,'-999' ) as REVERSE,isnull(SEAT_BELT,'-999' ) as SEAT_BELT,isnull(SPEED,'-999' ) as SPEED, "+
			" isnull(VEHICLE_SPEED,'-999' ) as VEHICLE_SPEED from AMS.dbo.CANIQ_HISTORY_# where REGISTRATION_NO=?  "+
			" and GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) and CLIENTID=?   "+
			" UNION ALL "+
			" select isnull(dateadd(mi,?,GMT),' ' )as GPS_DATE_TIME,isnull(ABS_AMBER_WARN,'-999') as ABS_AMBER_WARN, isnull(ABS_SWITCH,'-999') as ABS_SWITCH, isnull(AC,'-999' ) as AC," +
			" isnull(ACC_PEDAL_POS,'-999' ) as ACC_PEDAL_POS,isnull(ACC_PEDAL_SWITCH,'-999' ) as  ACC_PEDAL_SWITCH , "+
			" isnull(ACT_TORQ,'-999' ) as  ACT_TORQ,isnull(AIRFLOW_RATE,'-999' ) as  AIRFLOW_RATE,isnull(ANTI_LOCK_BRAKE,'-999' ) as  ANTI_LOCK_BRAKE,isnull(ASR_SWITCH,'-999' ) as  ASR_SWITCH, "+
			" isnull(BRAKE_PEDAL,'-999' ) as BRAKE_PEDAL,isnull(CLUTCH,'-999' ) as CLUTCH,isnull(COOLANT_TEMP,'-999' ) as COOLANT_TEMP,  isnull(DISTANCE_MIL,'-999' ) as DISTANCE_MIL, "+
			" isnull(DISTANCE_SCC ,'-999' ) as DISTANCE_SCC,isnull(DOOR ,'-999' ) as DOOR,isnull(DOOR_LOCK ,'-999' ) as DOOR_LOCK,isnull(DOOR_P ,'-999' ) as DOOR_P,isnull(DOOR_RL ,'-999' )DOOR_RL, "+
			" isnull(ENG_DEM_TORQ,'-999' ) as ENG_DEM_TORQ,isnull(ENGINE_BRAKE ,'-999' ) as ENGINE_BRAKE, isnull(ENGINE_INS_FUEL_ECO ,'-999' ) as ENGINE_INS_FUEL_ECO,"+
			" isnull(DOOR_RR,'-999' ) as DOOR_RR,isnull(DR_DEM_TORQ ,'-999' ) as DR_DEM_TORQ,isnull(ENG_FUEL_ECO ,'-999' ) as ENG_FUEL_ECO, "+
			" isnull(ENG_IMF_TEMP,'-999' ) as ENG_IMF_TEMP,isnull(ENGINE_COOLANT_PER ,'-999' ) as ENGINE_COOLANT_PER,isnull(ENGINE_LOAD ,'-999' ) as ENGINE_LOAD, "+
			" isnull(ENGINE_SPEED ,'-999' ) as ENGINE_SPEED,isnull(FUEL_CONSUMED ,'-999' ) as FUEL_CONSUMED,isnull(FUEL_LEVEL,'-999' ) as FUEL_LEVEL, "+
			" isnull(FUEL_PRESSURE ,'-999' ) as FUEL_PRESSURE,isnull(FUEL_RATE,'-999' ) as FUEL_RATE,isnull(FUEL_TEMP,'-999' ) as FUEL_TEMP, "+
			" isnull(HEAD_LIGHT ,'-999' ) as HEAD_LIGHT,isnull(IMA_PRESSURE,'-999' ) as IMA_PRESSURE, "+
			" isnull(IN_AIRTEMP,'-999' ) as IN_AIRTEMP,isnull(ODOMETER,'-999' ) as ODOMETER,isnull(OIL_PRESSURE,'-999' ) as OIL_PRESSURE,isnull(PARK_BRAKE,'-999' ) as PARK_BRAKE, "+
			" isnull(POWER_INPUT,'-999' ) as POWER_INPUT,isnull(REVERSE,'-999' ) as REVERSE,isnull(SEAT_BELT,'-999' ) as SEAT_BELT,isnull(SPEED,'-999' ) as SPEED, "+
			" isnull(VEHICLE_SPEED,'-999' ) as VEHICLE_SPEED  from AMS_Archieve.dbo.GE_CANIQ_# where REGISTRATION_NO=?  "+
			" and GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) and CLIENTID=? )r order by GPS_DATE_TIME";

public static final String SELECT_OBD_INDEX_DETAILS ="select isnull(FIELD_LABEL,'') as fieldLabel,isnull(UNIT,'') as unit,PARAMETER_NAME from dbo.OBD_PARAMETER_LOOKUP where SYSTEM_ID=? and CUSTOMER_ID=? and VEHICLE_MODEL in (select Model from tblVehicleMaster where VehicleNo=?)";

public static final String GET_VEHICLLE_LOOKUP_DETAILS_FOR_2X2="select isnull(ID,'') as parameterId,isnull(FIELD_LABEL,'') as fieldLabel,isnull(UNIT,'') as unit,PARAMETER_NAME from dbo.OBD_PARAMETER_LOOKUP where SYSTEM_ID=? and FIELD_LABEL not in ('ENG_INST_FUEL_ECO','ENG_IMF_TEMP','WATER_FUEL_IND','ENG_HRS_OPE','FUEL_RATE','ENG_FUEL_USED','ENG_TRIP_FUEL','ACT_TORQ','DR_DEM_TORQ') and  VEHICLE_MODEL=? ORDER BY DISPLAY_ORDER ";
}
