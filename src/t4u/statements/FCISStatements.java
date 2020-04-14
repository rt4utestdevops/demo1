package t4u.statements;
/**
 * This is a DB querystring class for FCIS Modules containing all query string together at one place for FCIS Module
 * @author ashutoshk
 *
 */
public class FCISStatements {
	//query string for fuel consolidated report for a client and their one of associated group for particular date range
	public final static  String GET_FUEL_CONSOLIDATED_REPORT_DATA="select ri.REGISTRATION_NO, ri.REFUEL_IN_LIT, ri.GMT, ri.LOCATION, " +
			"(select max(FUEL) from AMS.dbo.FUEL_FORMULA_MULTI_VALUE where ri.REGISTRATION_NO=ASSET_NUMBER) FuelWhenTankIsFull,vm.ModelName, isnull(ri.REFUEL,0) as FuelConsumed, " +
			"isnull(ODOMETER,0) as Distance, isnull(MILEAGE,0) as Mileage,fi.MESSAGE from dbo.REFUEL_INFO ri " +
			"inner join dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER = ri.REGISTRATION_NO and vc.SYSTEM_ID = ri.SYSTEM_ID " +
			"inner join dbo.Vehicle_User vu on vu.Registration_no=ri.REGISTRATION_NO " +
			"left outer join dbo.FUEL_FORMULA_VALUE ffv on ffv.VehicleNo = ri.REGISTRATION_NO and ffv.SystemId = ri.SYSTEM_ID " +
			"left outer join dbo.tblVehicleMaster tvm on tvm.VehicleNo = ri.REGISTRATION_NO and tvm.System_id = ri.SYSTEM_ID " +
			"left outer join FMS.dbo.Vehicle_Model vm on tvm.Model = vm.ModelTypeId and tvm.System_id = vm.SystemId " +
			"left outer join ALERT.dbo.FUEL_INFO fi on fi.REGISTRATION_NO = ri.REGISTRATION_NO collate database_default and " +
			"fi.SYSTEM_ID = ri.SYSTEM_ID and fi.GMT = ri.GMT " +
			"where ri.GMT between ? and ? and ri.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? and fi.MESSAGE='Refuel Detected'";// and vc.GROUP_ID=?

public static final String QUERY1 = "select startDateInGMT,endDateInGMT,FirstFuel,LastFuel from dbo.VehicleSummaryData  where DateGMT between ? and ? " +
		"and SystemId=? and ClientId=? and RegistrationNo=? ";

}
