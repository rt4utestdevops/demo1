package t4u.statements;

public class MarineVesselStatements {
	

	public final String GET_MARINE_VESSEL = "select REGISTRATION_NUMBER,VEHICLE_ID from VEHICLE_CLIENT vc, Vehicle_User vu,dbo.Live_Vision_Support vi where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no and vc.REGISTRATION_NUMBER = vi.REGISTRATION_NO order by REGISTRATION_NUMBER";
	
	public final String GET_MARINE_LIVE_INFORMATION = "select isNull(b.GROUP_NAME,'N/A') as GROUP_NAME,isNull(a.GPS_DATETIME,'') as GPS_DATETIME,isNull(a.LATITUDE,0) as LATITUDE,isNull(a.LONGITUDE,0) as LONGITUDE, " +
			"isNull(d.Fullname,'N/A') as DRIVER_NAME,isNull(d.Mobile,'N/A') as DRIVER_NUMBER,isNull(c.OwnerName,'N/A') as OWNER_NAME,isNull(c.OwnerContactNo,'') as OWNER_NUMBER from dbo.gpsdata_history_latest a " +
			"left outer join dbo.Live_Vision_Support b on a.REGISTRATION_NO = b.REGISTRATION_NO " +
			"left outer join tblVehicleMaster c on a.REGISTRATION_NO = c.VehicleNo and a.System_id = c.System_id " +
			"left outer join dbo.Driver_Master d on a.DRIVER_ASSOC_ID = d.Driver_id and a.System_id = d.System_id " +
			"where a.REGISTRATION_NO = ? and a.System_id = ? and a.CLIENTID = ?";
	
	public final String GET_LIVE_VEHICLE_DATA = "select LATITUDE,LONGITUDE from AMS.dbo.gpsdata_history_latest where REGISTRATION_NO = ? and System_id = ? and CLIENTID = ? and LATITUDE is not null and LATITUDE<>'' and LONGITUDE is not null and LONGITUDE<>'' and GMT between dateadd(hh,-6, getUTCDate()) and getUTCDate()";
	
	public final String GET_OTHER_ASSET_LIVE_DATA = "select isNull(b.VEHICLE_ID,'') as VEHICLE_ID,a.REGISTRATION_NO,a.SPEED,a.LATITUDE,a.LONGITUDE,isNull(b.GROUP_NAME,'') as GROUP_NAME,isNull(a.DRIVER_NAME,'') as DRIVER_NAME,isNull(b.OWNER_NAME,'') as OWNER_NAME from AMS.dbo.gpsdata_history_latest a " +
			"inner join AMS.dbo.Live_Vision_Support b on a.REGISTRATION_NO = b.REGISTRATION_NO " +
			"inner join AMS.dbo.Vehicle_User c on a.REGISTRATION_NO = c.Registration_no and a.System_id = c.System_id " +
			"where a.REGISTRATION_NO<>? and a.System_id = ? and a.CLIENTID = ? and c.User_id = ? and LATITUDE is not null and LATITUDE<>'' and LONGITUDE is not null and LONGITUDE<>'' and a.GMT between dateadd(hh,-6, getUTCDate()) and getUTCDate() order by a.REGISTRATION_NO";

	public final String GET_HISTORY_VEHICLE_DATA = "select GMT,GPS_DATETIME,SPEED,isNull(LATITUDE,0) as LATITUDE,isNull(LONGITUDE,0) as LONGITUDE from HISTORY_DATA " +
			"where REGISTRATION_NO = ? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and System_id = ? and CLIENTID = ? " +
			"union all " +
			"select GMT,GPS_DATETIME,SPEED,isNull(LATITUDE,0) as LATITUDE,isNull(LONGITUDE,0) as LONGITUDE from AMS_Archieve.dbo.GE_DATA " +
			"where REGISTRATION_NO = ? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and System_id = ? and CLIENTID = ? " +
			"union all " +
			"select GMT,GPS_DATETIME,SPEED,isNull(LATITUDE,0) as LATITUDE,isNull(LONGITUDE,0) as LONGITUDE from REPROCESS_TABLE " +
			"where REGISTRATION_NO = ? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and System_id = ? and CLIENTID = ? " +
			"order by GMT";

// comented for migration
//	public final String GET_GE_VEHICLE_DATA = " select GMT,GPS_DATETIME,SPEED,ifNull(LATITUDE,0) as LATITUDE,ifNull(LONGITUDE,0) as LONGITUDE from ams_archieve.ge_data "+ 
//	                                          " where REGISTRATION_NO = ?  and GMT between DATE_SUB(?,INTERVAL ? MINUTE) and DATE_SUB(?,INTERVAL ? MINUTE) "+
//	                                          " and System_id = ? and CLIENTID = ? order by GMT desc ";
	
	public final String GET_LOCATION_VEHICLE_DATA = "select a.GMT,b.VEHICLE_ID,a.REGISTRATION_NO,b.GROUP_NAME,a.LATITUDE,a.LONGITUDE,a.SPEED,isNull(c.Fullname,'') as DRIVER_NAME,isNull(c.Mobile,'') as DRIVER_NUMBER,isNull(b.OWNER_NAME,'') as OWNER_NAME from HISTORY_DATA a " +
			"left outer join dbo.Live_Vision_Support b on a.REGISTRATION_NO = b.REGISTRATION_NO " +
			"left outer join  dbo.Driver_Master c on a.MESSAGE_NUMBER = c.Driver_id and a.System_id = c.System_id " +
			"where a.System_id = ? and a.CLIENTID = ? and a.REGISTRATION_NO = ? and a.GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) " +
			"union " +
			"select a.GMT,b.VEHICLE_ID,a.REGISTRATION_NO,b.GROUP_NAME,a.LATITUDE,a.LONGITUDE,a.SPEED,isNull(c.Fullname,'') as DRIVER_NAME,isNull(c.Mobile,'') as DRIVER_NUMBER,isNull(b.OWNER_NAME,'') as OWNER_NAME from AMS_Archieve.dbo.GE_DATA a " +
			"left outer join dbo.Live_Vision_Support b on a.REGISTRATION_NO = b.REGISTRATION_NO " +
			"left outer join  dbo.Driver_Master c on a.MESSAGE_NUMBER = c.Driver_id and a.System_id = c.System_id " +
			"where a.System_id = ? and a.CLIENTID = ? and a.REGISTRATION_NO = ? and a.GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) " +
			"union " +
			"select a.GMT,b.VEHICLE_ID,a.REGISTRATION_NO,b.GROUP_NAME,a.LATITUDE,a.LONGITUDE,a.SPEED,isNull(c.Fullname,'') as DRIVER_NAME,isNull(c.Mobile,'') as DRIVER_NUMBER,isNull(b.OWNER_NAME,'') as OWNER_NAME from REPROCESS_TABLE a " +
			"left outer join dbo.Live_Vision_Support b on a.REGISTRATION_NO = b.REGISTRATION_NO " +
			"left outer join  dbo.Driver_Master c on a.MESSAGE_NUMBER = c.Driver_id and a.System_id = c.System_id " +
			"where a.System_id = ? and a.CLIENTID = ? and a.REGISTRATION_NO = ? and a.GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by a.GMT";	
//commented for migration
//	public final String GET_GE_LOCATION_VEHICLE_DATA = " select a.MESSAGE_NUMBER,a.GMT,a.REGISTRATION_NO,a.LATITUDE,a.LONGITUDE,a.SPEED from AMS_Archieve.ge_data_15 a " +
//			                                           " where a.System_id = ? and a.CLIENTID = ? and a.REGISTRATION_NO = ? and a.GMT between DATE_SUB(?,INTERVAL ? MINUTE) and DATE_SUB(?,INTERVAL ? MINUTE) ";

}
