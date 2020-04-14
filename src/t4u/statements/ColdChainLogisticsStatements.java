package t4u.statements;

public class ColdChainLogisticsStatements {

	public static final String GET_RETAILER_MASTER_DETAILS="select RETAILER_ID,isnull(a.RETAILER_NAME,'') as RETAILER_NAME ,isnull(a.ADDRESS ,'') as ADDRESS, "+
				"isnull(b.GROUP_NAME,'') as ZONE ,isnull(c.STATE_NAME,0) as STATE,isnull(a.CITY,'') as CITY ,isnull(a.MOBILE_NO,'')as CONTACTNUMBER,isnull(LATITUDE,0) as LATITUDE, isnull(LONGITUDE,0) as LONGITUDE  ,"+
				"isnull(b.GROUP_ID,'') as ZONE_ID ,isnull(c.STATE_CODE,0) as STATE_ID "+
				"from  AMS.dbo.RETAILER_MASTER a " +
				"inner join ADMINISTRATOR.dbo.ASSET_GROUP b on a.GROUP_ID=b.GROUP_ID and b.SYSTEM_ID=a.SYSTEM_ID and b.CUSTOMER_ID=a.CUSTOMER_ID  " +
				"inner join ADMINISTRATOR.dbo.STATE_DETAILS c on a.STATE_ID=c.STATE_CODE "+
				"where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? AND a.STATUS='Active' " ;

	public static final String INSERT_INTO_RETAILER_MASTER="insert into AMS.dbo.RETAILER_MASTER (RETAILER_NAME,ADDRESS,GROUP_ID,STATE_ID,CITY,LATITUDE,LONGITUDE,RADIUS,STATUS,INSERTED_BY,SYSTEM_ID,CUSTOMER_ID,MOBILE_NO) "+
				"values(?,?,?,?,?,?,?,30,'Active',?,?,?,?) ";

	public static final String UPDATE_RETAILER_MASTER_INFORMATION= "update AMS.dbo.RETAILER_MASTER set RETAILER_NAME=?,ADDRESS=?,GROUP_ID=?,STATE_ID=?, "
				+" CITY=?,LATITUDE=?,LONGITUDE=?,UPDATED_BY=?,UPDATED_TIME=getUtcDate(),MOBILE_NO=? WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND RETAILER_ID=?";

	public static final String GET_ZONE_DETAILES="select  GROUP_ID as Zone_ID ,isnull(GROUP_NAME ,'') as Zone_Name from  ADMINISTRATOR.dbo.ASSET_GROUP  where SYSTEM_ID=? AND CUSTOMER_ID=? ";
	
	public static final String DELETE_CUSTOMER_DETAILES="update AMS.dbo.RETAILER_MASTER set STATUS='Inactive' where SYSTEM_ID=? AND CUSTOMER_ID=? AND RETAILER_ID=? ";
	
	    //********* Asset Association statements *******************//
	
	public static final String GET_ACTIVE_RETAILER_DETAILS= " select RETAILER_ID,RETAILER_NAME,GROUP_ID,STATUS from dbo.RETAILER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active' ";
	
	public static final String GET_NON_ASSOCIATED_ASSET_DETAILS= " select  isNull(VehicleNo,'') as Asset,isNull(VehicleType,'') as AssetType from AMS.dbo.tblVehicleMaster tvm "
	+ " inner join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER = tvm.VehicleNo and vc.SYSTEM_ID = tvm.System_id"
	+ " inner join AMS.dbo.Vehicle_User vu on vu.Registration_no = tvm.VehicleNo and vu.System_id = tvm.System_id" 
	+ " where tvm.System_id = ? " +
		" and vc.CLIENT_ID=? and User_id=? and vc.GROUP_ID=? and tvm.VehicleNo not in" 
	+"(select ASSET_NO from AMS.dbo.RETAILER_ASSET_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=?)";
	
	public static final String GET_ASSOCIATED_ASSET_DETAILS= " select isNull(VehicleNo,'') as Asset,isNull(VehicleType,'') as AssetType from AMS.dbo.tblVehicleMaster tvm " +
	" where tvm.System_id=? and tvm.VehicleNo in (select ASSET_NO from AMS.dbo.RETAILER_ASSET_ASSOCIATION " +
		"	where RETAILER_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?) ";

	public static final String INSERT_INTO_RETAILER_ASSET_ASSOCIATION=" insert into  AMS.dbo.RETAILER_ASSET_ASSOCIATION(SYSTEM_ID,CUSTOMER_ID,RETAILER_ID,ASSET_NO,ASSOCIATED_TIME,ASSOCIATED_BY) values (?,?,?,?,getutcdate(),?) ";

	public static final String INSERT_INTO_RETAILER_ASSET_ASSOCIATION_HISTORY=" insert into AMS.dbo.RETAILER_ASSET_ASSOC_HISTORY(ID,SYSTEM_ID,CUSTOMER_ID,RETAILER_ID,ASSET_NO,ASSOCIATED_TIME,ASSOCIATED_BY) " +
							 " select ID,SYSTEM_ID,CUSTOMER_ID,RETAILER_ID,ASSET_NO,ASSOCIATED_TIME,ASSOCIATED_BY from AMS.dbo.RETAILER_ASSET_ASSOCIATION " +
							 " where ASSET_NO=? and RETAILER_ID=? and SYSTEM_ID=? ";
	
	public static final String UPDATE_RETAILER_ASSET_ASSOC_HISTORY=" update AMS.dbo.RETAILER_ASSET_ASSOC_HISTORY set DISASSOCIATED_TIME=getutcdate(), DISASSOCIATED_BY=? " +
	" where ASSET_NO=? and RETAILER_ID=? and SYSTEM_ID=? ";
	
	public static final String DELETE_FROM_RETAILER_ASSET_ASSOCIATION=" delete from AMS.dbo.RETAILER_ASSET_ASSOCIATION where ASSET_NO=? and RETAILER_ID=? and SYSTEM_ID=?";
	
//***********************************************************Dashboard Count*************************************************************//
	
	public static final String getDashboardCounts="select ag.GROUP_ID,ag.GROUP_NAME, "+
												" (select count(*) from AMS.dbo.gpsdata_history_latest a "+ 
												" inner join AMS.dbo.Vehicle_User vu on a.REGISTRATION_NO=vu.Registration_no "+ 
												" inner join AMS.dbo.VEHICLE_CLIENT vc on vc.SYSTEM_ID=a.System_id and vc.CLIENT_ID=a.CLIENTID and vc.REGISTRATION_NUMBER=vu.Registration_no "+
												" where a.System_id=ag.SYSTEM_ID and a.CLIENTID=ag.CUSTOMER_ID and vu.User_id=? and "+
												" vc.GROUP_ID=ag.GROUP_ID and datediff(mi,a.GMT,getUTCdate()) <30 and a.LOCATION<>'No GPS Device Connected') as COMMUNICATING, "+
												" (select count(*) from AMS.dbo.gpsdata_history_latest a "+ 
												" inner join AMS.dbo.Vehicle_User vu on a.REGISTRATION_NO=vu.Registration_no "+ 
												" inner join AMS.dbo.VEHICLE_CLIENT vc on vc.SYSTEM_ID=a.System_id and vc.CLIENT_ID=a.CLIENTID and vc.REGISTRATION_NUMBER=vu.Registration_no "+
												" where a.System_id=ag.SYSTEM_ID and a.CLIENTID=ag.CUSTOMER_ID and vu.User_id=? and "+
												" vc.GROUP_ID=ag.GROUP_ID and datediff(mi,a.GMT,getUTCdate()) >30 and a.LOCATION<>'No GPS Device Connected') as NON_COMMUNICATING, "+
												" (select count(*) from AMS.dbo.Alert a "+
												" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and a.REGISTRATION_NO=vu.Registration_no "+
												" inner join AMS.dbo.VEHICLE_CLIENT vc on vc.SYSTEM_ID=a.SYSTEM_ID and vc.CLIENT_ID=a.CLIENTID and vc.REGISTRATION_NUMBER=vu.Registration_no "+
												" where a.TYPE_OF_ALERT=132 and a.SYSTEM_ID=ag.SYSTEM_ID and a.CLIENTID=ag.CUSTOMER_ID and vu.User_id=? "+
												" and vc.GROUP_ID=ag.GROUP_ID and a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  (MONITOR_STATUS is null or MONITOR_STATUS='N')) as MOVING_ASSET, "+
												" (select count(*) from AMS.dbo.Alert a "+
												" inner join AMS.dbo.Vehicle_User vu on vu.System_id=a.SYSTEM_ID and a.REGISTRATION_NO=vu.Registration_no "+
												" inner join AMS.dbo.VEHICLE_CLIENT vc on vc.SYSTEM_ID=a.SYSTEM_ID and vc.CLIENT_ID=a.CLIENTID and vc.REGISTRATION_NUMBER=vu.Registration_no "+ 
												" where a.TYPE_OF_ALERT in (7,38,104) and a.SYSTEM_ID=ag.SYSTEM_ID and a.CLIENTID=ag.CUSTOMER_ID "+
												" and vu.User_id=? and vc.GROUP_ID=ag.GROUP_ID and a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  (MONITOR_STATUS is null or MONITOR_STATUS='N')) as ALERT "+
												" from ADMINISTRATOR.dbo.ASSET_GROUP ag  where SYSTEM_ID=? and CUSTOMER_ID=? "+
												" and GROUP_ID in (select GROUP_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION where SYSTEM_ID=? and USER_ID=?) "+
												" order by ag.GROUP_NAME ";
	
	public static final String getAllVehiclesBasedOnGroupId = "select a.REGISTRATION_NO,a.LONGITUDE,a.LATITUDE,a.LOCATION,a.GPS_DATETIME,'Communicating' As STATUS from AMS.dbo.gpsdata_history_latest a "+  
																" inner join AMS.dbo.Vehicle_User vu on a.REGISTRATION_NO=vu.Registration_no "+
																" inner join AMS.dbo.VEHICLE_CLIENT vc on vc.SYSTEM_ID=a.System_id and vc.CLIENT_ID=a.CLIENTID and vc.REGISTRATION_NUMBER=vu.Registration_no "+
																" inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.SYSTEM_ID=a.System_id and ag.CUSTOMER_ID=a.CLIENTID and vc.GROUP_ID=ag.GROUP_ID "+
																" where datediff(mi,a.GMT,getUTCdate()) <30 and a.LOCATION !='No GPS Device Connected' "+ 
																" and ag.GROUP_ID=? and vu.User_id=? and a.CLIENTID=? and a.System_id=? "+
																" union "+
																"select a.REGISTRATION_NO,a.LONGITUDE,a.LATITUDE,a.LOCATION,a.GPS_DATETIME,'NonCommunicating' As STATUS from AMS.dbo.gpsdata_history_latest a "+ 
																" inner join AMS.dbo.Vehicle_User vu on a.REGISTRATION_NO=vu.Registration_no "+
																" inner join AMS.dbo.VEHICLE_CLIENT vc on vc.SYSTEM_ID=a.System_id and vc.CLIENT_ID=a.CLIENTID and vc.REGISTRATION_NUMBER=vu.Registration_no "+
																" inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.SYSTEM_ID=a.System_id and ag.CUSTOMER_ID=a.CLIENTID and vc.GROUP_ID=ag.GROUP_ID "+
																" where datediff(mi,a.GMT,getUTCdate()) >30 and a.LOCATION !='No GPS Device Connected' "+
																" and ag.GROUP_ID=? and vu.User_id=? and a.CLIENTID=? and a.System_id=?"; 

	public static final String getCommVehiclesCount = "select count(*) as COUNTS from AMS.dbo.gpsdata_history_latest a  "+
													" inner join AMS.dbo.Vehicle_User vu on a.REGISTRATION_NO=vu.Registration_no  "+
													" left outer join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=vu.Registration_no "+
													" inner join AMS.dbo.VEHICLE_GROUP vg on vg.GROUP_ID=vc.GROUP_ID "+
													" where datediff(mi,a.GMT,getUTCdate()) <=30 and vu.User_id=? and a.CLIENTID=? and vu.System_id=? and a.LOCATION<>'No GPS Device Connected' "; 
	
	public static final String getNonCommVehiclesCount = "select count(*) as COUNTS from dbo.gpsdata_history_latest a "+ 
														"inner join Vehicle_User vu on a.REGISTRATION_NO=vu.Registration_no "+ 
														"left outer join dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=vu.Registration_no "+
														"inner join dbo.VEHICLE_GROUP vg on vg.GROUP_ID=vc.GROUP_ID "+
														"where datediff(mi,a.GMT,getUTCdate()) >30 and vu.User_id=? and a.CLIENTID=? and vu.System_id=? and a.LOCATION<>'No GPS Device Connected' ";
																
	public static final String getMovingVehiclesCount = "select count(*) as COUNTS from AMS.dbo.Alert a "+
														" inner join Vehicle_User vu on a.REGISTRATION_NO=vu.Registration_no "+
														" left outer join dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=vu.Registration_no "+
														" inner join dbo.VEHICLE_GROUP vg on vg.GROUP_ID=vc.GROUP_ID "+
														" where a.TYPE_OF_ALERT=132 and a.SYSTEM_ID=? and a.CLIENTID=? and vu.User_id=? and vu.System_id=? " +
														" and a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') "; 
	
	public static final String getAlertVehiclesCount = "select count(a.TYPE_OF_ALERT) as COUNTS from AMS.dbo.Alert a "+
														" inner join Vehicle_User vu on a.REGISTRATION_NO=vu.Registration_no "+
														" left outer join dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=vu.Registration_no "+
														" inner join dbo.VEHICLE_GROUP vg on vg.GROUP_ID=vc.GROUP_ID "+
														" where a.TYPE_OF_ALERT in (7,38,104) and a.SYSTEM_ID=? and vu.User_id=? and a.CLIENTID=? and vu.System_id=? " +
														" and a.GMT >= dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) and  (MONITOR_STATUS is null or MONITOR_STATUS='N') ";
																															
	public static final String GET_PEAK_OR_NON_PEAK_REPORT_SUMMARY ="select convert(varchar(20),DATEADD(dd, 0, DATEDIFF(dd, 0, isnull(dateadd(mi,offset,dsr.START_GMT),''))),105) as Date,isNull(tm.START_TIME,'') as START_TIME,isNull(tm.END_TIME,'') as END_TIME,count(tm.TIME_ZONE) as CountPOrNP " +
														" from ALERT.dbo.DOOR_SENSOR_REPORT dsr " +
														" inner join AMS.dbo.Vehicle_User vu on vu.System_id=dsr.SYSTEM_ID and dsr.REGISTRATION_NO=vu.Registration_no COLLATE DATABASE_DEFAULT " +
														" left outer join AMS.dbo.TIME_MASTER tm on tm.SYSTEM_ID=dsr.SYSTEM_ID and tm.CUSTOMER_ID=dsr.CUSTOMER_ID and CONVERT(VARCHAR(5),isnull(dateadd(mi,offset,dsr.START_GMT),''),108) >=tm.START_TIME and CONVERT(VARCHAR(5),isnull(dateadd(mi,offset,dsr.START_GMT),''),108)<tm.END_TIME " +
														" inner join AMS.dbo.RETAILER_ASSET_ASSOCIATION raa on dsr.REGISTRATION_NO=raa.ASSET_NO COLLATE DATABASE_DEFAULT and dsr.SYSTEM_ID=raa.SYSTEM_ID and dsr.CUSTOMER_ID=raa.CUSTOMER_ID " +
														" inner join AMS.dbo.RETAILER_MASTER rm on rm.RETAILER_ID=raa.RETAILER_ID and rm.SYSTEM_ID=raa.SYSTEM_ID and rm.CUSTOMER_ID=raa.CUSTOMER_ID " +
														" where dsr.SYSTEM_ID=? and dsr.CUSTOMER_ID=? and dsr.START_GMT between dateadd(mi,-offset,?) and dateadd(mi,-offset,?) and ALERT_STATUS='CLOSE' and vu.User_id=? " +
														" group by convert(varchar(20),DATEADD(dd, 0, DATEDIFF(dd, 0, isnull(dateadd(mi,offset,dsr.START_GMT),''))),105), tm.START_TIME,tm.END_TIME order by Date";
	
	public static final String GET_PEAK_OR_NON_PEAK_REPORT_DETAILS = "select isnull(dsr.REGISTRATION_NO,'') as AssetNo,isnull(tvm.VehicleType,'') as AssetType,dateadd(mi,?,isnull(dsr.START_GMT,'')) as StartTime, dateadd(mi,?,isnull(dsr.END_GMT,'')) as EndTime,(isnull(tm.START_TIME,'')+' - '+isnull(tm.END_TIME,'')) as TimeZone,isnull(rm.RETAILER_NAME,'') as RetailerName,isnull(rm.ADDRESS,'') as Address " + 
														" from ALERT.dbo.DOOR_SENSOR_REPORT dsr " + 
														" inner join AMS.dbo.tblVehicleMaster tvm  on  tvm.VehicleNo=dsr.REGISTRATION_NO COLLATE DATABASE_DEFAULT and tvm.System_id=dsr.SYSTEM_ID " + 
														" inner join AMS.dbo.Vehicle_User vu on vu.System_id=dsr.SYSTEM_ID and dsr.REGISTRATION_NO=vu.Registration_no COLLATE DATABASE_DEFAULT " +
														" inner join AMS.dbo.TIME_MASTER tm on tm.SYSTEM_ID=dsr.SYSTEM_ID and tm.CUSTOMER_ID=dsr.CUSTOMER_ID and CONVERT(VARCHAR(5),isnull(dateadd(mi,?,dsr.START_GMT),''),108) >=tm.START_TIME and CONVERT(VARCHAR(5),isnull(dateadd(mi,?,dsr.START_GMT),''),108)<tm.END_TIME " + 
														" inner join AMS.dbo.RETAILER_ASSET_ASSOCIATION raa on dsr.REGISTRATION_NO=raa.ASSET_NO COLLATE DATABASE_DEFAULT and dsr.SYSTEM_ID=raa.SYSTEM_ID and dsr.CUSTOMER_ID=raa.CUSTOMER_ID " +
														" inner join AMS.dbo.RETAILER_MASTER rm on rm.RETAILER_ID=raa.RETAILER_ID and rm.SYSTEM_ID=raa.SYSTEM_ID and rm.CUSTOMER_ID=raa.CUSTOMER_ID " +
														" where dsr.SYSTEM_ID=? and dsr.CUSTOMER_ID=? and dsr.ALERT_STATUS='CLOSE' and vu.User_id=? and dsr.START_GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by START_GMT";
	
}
