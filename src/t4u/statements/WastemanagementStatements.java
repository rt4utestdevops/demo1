package t4u.statements;

public class WastemanagementStatements {
	/**
	 * To fetch Trader(Licence holder) id and name from Trader_Master table
	 */
	public static final String GET_TRADER="select ID,LICENCE_HOLDER_NAME from dbo.TRADER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? ";
	
	/**
	 * To fetch Trader details from Trader_Master table
	 */
	public static final String GET_TRADER_DETAILS="select LICENCE_NO, ADDRESS, TRADE, TRADE_NAME, DOOR_NO, WARD_NAME, WARD_NO, AREA, MOBILE_NO, RFID_CODE, STATUS from " +
												" dbo.TRADER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";
	
	/**
	 * Inserts a record to Trader_Master table
	 */
	public static final String SAVE_TRADER="insert into dbo.TRADER_MASTER( LICENCE_HOLDER_NAME, LICENCE_NO, ADDRESS, TRADE, TRADE_NAME, DOOR_NO, WARD_NAME, WARD_NO, AREA, MOBILE_NO, RFID_CODE, STATUS, SYSTEM_ID, CUSTOMER_ID, INSERTED_BY) "+
							" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	/**
	 * updates a record in Trader_Master table of that id
	 */
	public static final String UPDATE_TRADER="update dbo.TRADER_MASTER set LICENCE_HOLDER_NAME=?, LICENCE_NO=?, ADDRESS=?, TRADE=?, TRADE_NAME=?, DOOR_NO=?, WARD_NAME=?, WARD_NO=?, AREA=?, MOBILE_NO=?, RFID_CODE=?, STATUS=? "+
								"where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?  ";
	
	/**
	 * deletes a record in Trader_Master table of that id
	 */
	public static final String DELETE_TRADER="delete from dbo.TRADER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	/**
	 * Fetches daily attendance report data from Waste_Mgmt_Attendance table
	 */
	public static final String GET_DAILY_ATTENDANCE_REPORT_DATA="select dateadd(mi,s.OffsetMin,a.GMT) as date,a.REGISTRATION_NO,b.TRADE_NAME,b.LICENCE_HOLDER_NAME,a.LOCATION, "+
										" b.MOBILE_NO,b.WARD_NAME,b.WARD_NO,dateadd(mi,s.OffsetMin,a.GMT) as GMT "+
										" from dbo.WASTE_MGMT_ATTENDANCE a "+
										" inner join System_Master s on s.System_id=a.SYSTEM_ID "+
										" inner join dbo.Vehicle_User vu on vu.Registration_no=a.REGISTRATION_NO "+
										" inner join dbo.TRADER_MASTER b on b.ID=a.TRADER_ID and b.SYSTEM_ID=a.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "+
										" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.GMT between dateadd(mi,-s.OffsetMin,?) and dateadd(mi,-s.OffsetMin,?) and vu.User_id=? ";
	public static final String GET_ASSET_TYPE = " select distinct tb.VehicleType from AMS.dbo.tblVehicleMaster tb left outer join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id left outer join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and tb.VehicleType <> '' ";

	public static final String GET_ASSET_NUMBER = " select REGISTRATION_NUMBER from AMS.dbo.tblVehicleMaster tb left outer join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id left outer join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id  where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and tb.VehicleType = ? order by REGISTRATION_NUMBER ";
	
	public static final String GET_SWEEPING_MANAGEMENT_REPORT = " select dateadd(mi,?,DateGMT) as Date,isnull(RegistrationNo,'') as Asset_Number,isnull(EngineHrs,'') as TotalRunningTime,isnull(ENGINE2_HOURS,'') as TotalBrushTime,isnull(b.GROUP_NAME,'') as Asset_Group from AMS.dbo.VehicleSummaryData (NOLOCK) a left outer join AMS.dbo.VEHICLE_GROUP b (NOLOCK) on b.GROUP_ID=a.GroupId and b.SYSTEM_ID=a.SystemId and b.CLIENT_ID=a.ClientId where SystemId=? and ClientId=? and DateGMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and RegistrationNo in (#) order by DateGMT ";
	
	public static final String GET_WASTE_MANAGEMENT_REPORT = " select isnull(a.ASSET_NO,'') as Asset_Number,isnull(ID,'') as Id,dateadd(hh,24,dateadd(mi,?,a.DATE)) as Date,isnull(a.RUNNING_TIME,'') as TotalRunningTime,isnull(a.WEIGHT_CARRIED,'') as TotalWeightCarried,isnull(c.GROUP_NAME,'') as Asset_Group from AMS.dbo.WASTE_MANAGEMENT_SUMMARY (NOLOCK) a left outer join AMS.dbo.VEHICLE_CLIENT b (NOLOCK) on b.REGISTRATION_NUMBER=a.ASSET_NO left outer join AMS.dbo.VEHICLE_GROUP c (NOLOCK) on b.GROUP_ID=c.GROUP_ID and b.SYSTEM_ID=c.SYSTEM_ID and b.CLIENT_ID=c.CLIENT_ID where a.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and a.ASSET_NO in (#) order by a.DATE ";
	
	public static final String UPDATE_WASTE_INFORMATION_INFORMATION = " update AMS.dbo.WASTE_MANAGEMENT_SUMMARY set WEIGHT_CARRIED=? where ID=? ";
	
	public static final String INSERT_REMARKS_INTO_SUMMARY_HISTORY = " insert into AMS.dbo.WASTE_MGMT_SUMMARY_HISTORY(SUMMARY_ID, "
		+ " WEIGHT_CARRIED,REMARKS,UPDATED_BY,UPDATED_DATETIME) "
		+ " select ID,WEIGHT_CARRIED,?,?,getUtcDate() FROM AMS.dbo.WASTE_MANAGEMENT_SUMMARY "
		+ " where ID=? ";

	
}
