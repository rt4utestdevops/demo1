package t4u.statements;

public class HistoryAnalysisStatements {
	
	public static final String GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPE= "select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = (select DistanceUnitId from Vehicle_Category_Master where Category_name = ("
																				+ "select VehicleType from tblVehicleMaster where System_id=? and VehicleNo=?))";
	
//	public static final String GET_ALL_VEHICLE_FOR_LTSP = "select a.REGISTRATION_NO,isNull(b.VEHICLE_ID,'') as VEHICLE_ID from dbo.gpsdata_history_latest a "+
//															" inner join dbo.Live_Vision_Support b on a.REGISTRATION_NO=b.REGISTRATION_NO "+												
//															" where a.System_id=? order by a.REGISTRATION_NO";
	public static final String GET_ALL_VEHICLE_FOR_LTSP= " select a.REGISTRATION_NO,isNull(b.VEHICLE_ID,'') as VEHICLE_ID from dbo.gpsdata_history_latest a "+
	" inner join dbo.Live_Vision_Support b on a.REGISTRATION_NO=b.REGISTRATION_NO 	"+										
	" inner join AMS.dbo.Vehicle_User b2 on a.REGISTRATION_NO = b2.Registration_no and a.System_id = b2.System_id "+
	" inner join tblVehicleMaster c2 on b2.Registration_no=c2.VehicleNo and b2.System_id=c2.System_id "+
	" where a.System_id=? and b2.User_id = ? "+
	" order by a.REGISTRATION_NO ";
	
	public static final String GET_ALL_VEHICLE_FOR_CLIENT_WITH_ACTIVE = "select  VehicleNo as REGISTRATION_NO,isNull(VehicleAlias,'') as VEHICLE_ID from tblVehicleMaster a "+
																		" inner join Vehicle_User b on a.VehicleNo=b.Registration_no and a.System_id=b.System_id "+
																		" inner join AMS.dbo.VEHICLE_CLIENT c on b.Registration_no=c.REGISTRATION_NUMBER "+
																		" where b.User_id=? and c.SYSTEM_ID=? and c.CLIENT_ID=? ";
	
	public static final String GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPES = "select isnull(a.VehicleAlias,'') as VehicleAlias,isnull(c.UnitName,'kms') as UnitName,isnull(c.ConversionFactor,1.0) as ConversionFactor from tblVehicleMaster a "+
																				  " left outer join  Vehicle_Category_Master b on b.Category_name = a.VehicleType "+
																				  " left outer join tblDistanceUnitMaster c on c.UnitId = b.DistanceUnitId "+
																				  " where a.System_id=? and a.VehicleNo=? ";
	public static final String GET_VEHICLE_STATUS = "select IGNITION,SPEED,isNull(SPEED_LIMIT,0) as SPEED_LIMIT from dbo.gpsdata_history_latest where REGISTRATION_NO=?";
	
	public static final String GET_START_END_DATE = "select IGNITION,SPEED,GMT from dbo.HISTORY_DATA where REGISTRATION_NO=? and GMT between dateadd(mi,-30,getutcdate()) and getutcdate() order by GMT desc";
    
	public static final String GET_LIVE_LOCATION = "select isNull(LOCATION,'') as LOCATION from dbo.gpsdata_history_latest where REGISTRATION_NO=? and System_id=? ";

	public static final String GET_LIVE_LOCATION_FOR_IMPRECISE_LOCATION = "select isNull(IM_LOCATION,'') as LOCATION from dbo.gpsdata_history_latest where REGISTRATION_NO=? and System_id=? ";

}
