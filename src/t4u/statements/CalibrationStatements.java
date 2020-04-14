package t4u.statements;

public class CalibrationStatements {

	public static final String GET_CALIBRATION_DETAILS = "select SLNO, isnull(a.VehicleNo,'') as VehicleNo,isnull(a.VoltageWhenTankIsEmpty,0) as VoltageWhenTankIsEmpty,"
			+ "isnull(a.VoltageWhenTankIsFull,0) as VoltageWhenTankIsFull,isnull(a.FuelWhenTankIsEmpty,0) as FuelWhenTankIsEmpty,"
			+ "isnull(a.FuelWhenTankIsFull,0) as FuelWhenTankIsFull,isnull(a.ApproxMileageMin,0) as ApproxMileageMin,"
			+ "isnull(a.ApproxMileageMax,0) as ApproxMileageMax,dateadd(mi,?,a.CALIBRATION_DATE) as CALIBRATION_DATE,"
			+ "a.CALIBRATED_BY as CALIBRATED_BY,a.CUSTOMER_NAME as CUSTOMER_NAME,"
			+ "a.REMARKS as REMARKS,dateadd(mi,?,Fuel_LastExeDateTime) as Fuel_LastExeDateTime,"
			+ "Speed,isnull(a.DELTADISTANCE,0) as DELTA_DISTANCE, IGNITION from FUEL_FORMULA_VALUE a left outer join dbo.RefuelCalculator b on a.VehicleNo=b.REGISTRATION_NO "
			+ "where a.SystemId=? and a.ClientId=?";

	public static final String INSERT_CALIBRATION_DETAILS = " insert into FUEL_FORMULA_VALUE (VehicleNo,FuelWhenTankIsEmpty,VoltageWhenTankIsEmpty,FuelWhenTankIsFull,VoltageWhenTankIsFull,"
			+ " ApproxMileageMin, ApproxMileageMax, SystemId, ClientId, M_CODE , C_CODE,Last_Execution_DateTime, "
			+ "CALIBRATION_DATE,CALIBRATED_BY,CUSTOMER_NAME,REMARKS,CREATED_BY,FUEL_CONSTANT_FACTOR,Speed,DELTADISTANCE,IGNITION) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

	public static final String UPDATE_CALIBRATION_DETAILS = " update FUEL_FORMULA_VALUE set FuelWhenTankIsEmpty=?,VoltageWhenTankIsEmpty=?,FuelWhenTankIsFull=?, VoltageWhenTankIsFull=?, "
			+ " ApproxMileageMin=?, ApproxMileageMax=?, "
			+ " Last_Execution_DateTime=?,CALIBRATION_DATE=?,CALIBRATED_BY=?,CUSTOMER_NAME=?,REMARKS=?,Modified_DateTime=getdate(), M_CODE=? , C_CODE=? ,Speed=? ,DELTADISTANCE=?,IGNITION=? "
			+ " where ClientId=? and SystemId=? and VehicleNo=? and SLNO=? ";
	
	public static final String GET_VEHICLE_NOT_IN_REFUEL = "select REGISTRATION_NUMBER from VEHICLE_CLIENT vc, Vehicle_User vu ,tblVehicleMaster vm "
			+ "where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and "
			+ "vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no and vc.SYSTEM_ID=vm.System_id and vm.VehicleNo=vc.REGISTRATION_NUMBER "
			+ "and REGISTRATION_NUMBER not in (select VehicleNo from dbo.FUEL_FORMULA_VALUE ) order by REGISTRATION_NUMBER";

	public static final String GET_MONITORING_VEHICLE_DETAILS = "select isnull(s.System_Name,'') as LTSP,isnull(c.NAME,'') as CUSTOMER_NAME,isnull(f.VehicleNo,'')as ASSET_NO,dateadd(mi,330,f.CALIBRATION_DATE) as CALIBRATION_DATE, "
			+ "SUM(CASE WHEN MESSAGE='Invalid Voltage' and GMT between dateadd(dd,-7,getutcdate()) and getutcdate() THEN 1 ELSE 0 END)as VOLTAGE , "
			+ "SUM(CASE WHEN MESSAGE='Spurious Refuel Detected' and GMT between dateadd(dd,-7,getutcdate()) and getutcdate() THEN 1 ELSE 0 END)as SPURIOUS_REFUEL, "
			+ "SUM(CASE WHEN MESSAGE='Refuel Detected' and GMT between dateadd(dd,-7,getutcdate()) and getutcdate() THEN 1 ELSE 0 END)as REFUEL_DETECTED, "
			+ "SUM(CASE WHEN MESSAGE='Unexpected Fuel Variation Detected' and GMT between dateadd(dd,-7,getutcdate()) and getutcdate() THEN 1 ELSE 0 END)as UNEXPECTED_FUEL_VARIATION "
			+ "from dbo.FUEL_FORMULA_VALUE f "
			+ "left outer join dbo.System_Master s on s.System_id=f.SystemId "
			+ "left outer join ADMINISTRATOR.dbo.CUSTOMER_MASTER c on c.CUSTOMER_ID=f.ClientId and c.SYSTEM_ID=f.SystemId "
			+ "left outer join ALERT.dbo.FUEL_INFO fi on  f.VehicleNo collate database_default=fi.REGISTRATION_NO "
			+ "and fi.SYSTEM_ID=f.SystemId "
			+ "group by s.System_Name,c.NAME,f.VehicleNo,f.CALIBRATION_DATE order by s.System_Name,c.NAME,f.VehicleNo";

	public static final String GET_VEHICLE_NUMBER = "select distinct VehicleNo from dbo.FUEL_FORMULA_VALUE where ClientId=? and SystemId=? order by VehicleNo";
	
	public static String GET_FUEL_FORMULA_MULTI_VALUE = "select ID, VOLTAGE, FUEL from dbo.FUEL_FORMULA_MULTI_VALUE where ASSET_NUMBER = ? order by VOLTAGE";

	public static final String GET_REFUEL_DETAILS = "select a.ID,dateadd(mi, ?, a.REFUEL_DATE) as REFUEL_DATE ,isnull(a.REFUEL,0) as REFUEL,"
			+ " isnull(a.SOURCE,0) as SOURCE,isnull(a.REMARKS,0) as REMARKS,"
			+ " isnull(b.Firstname,'') as ENTERED_BY,isnull(a.ENTERED_DATE,0) as ENTERED_DATE,"
			+ " isnull(a.VERIFIED_REMARKS,'') as VERIFIED_REMARKS,isnull(c.Firstname,'') as VERIFIED_BY, isnull(a.APPROVE_ENTERED_BY, '') as APPROVE_ENTERED_BY, isnull(a.APPROVED_REMARKS, '') as APPROVED_REMARKS, isnull(d.Firstname,'') as APPROVED_BY, isnull(a.APPROVED_DATE, '') as APPROVED_DATE, isNull(e.REFUEL_COUNTER,0) as REFUEL_COUNTER"
			+ " from dbo.FDAS_CALIBRATION_DETAILS a left outer join Users b on a.ENTERED_BY = b.User_id and a.SYSTEM_ID = b.System_id"
			+ " left outer join Users c on a.VERIFIED_BY = c.User_id and a.SYSTEM_ID = c.System_id "
			+ " left outer join Users d on a.APPROVED_BY = d.User_id and a.SYSTEM_ID = d.System_id " 
			+ " left outer join dbo.FUEL_FORMULA_VALUE e on a.ASSET_NUMBER = e.VehicleNo and a.SYSTEM_ID = e.SystemId and a.CUSTOMER_ID = e.ClientId"
			+ " where a.SYSTEM_ID=? and a.ASSET_NUMBER=? and a.CUSTOMER_ID = ?";

	public static final String INSERT_REFUEL_DETAILS = " insert into FDAS_CALIBRATION_DETAILS (ASSET_NUMBER,REFUEL_DATE,REFUEL,SOURCE,REMARKS,SYSTEM_ID,CUSTOMER_ID,ENTERED_BY,ENTERED_DATE) values (?,dateadd(mi,-?,?),?,?,?,?,?,?,getUTCDate())";

	public static final String UPDATE_REFUEL_DETAILS = "update FDAS_CALIBRATION_DETAILS set REFUEL_DATE=?,REFUEL=?,SOURCE=?,REMARKS=?,ENTERED_BY = ?,ENTERED_DATE = getUTCDate() where ASSET_NUMBER=? and SYSTEM_ID = ? and CUSTOMER_ID = ? and ID = ?";

	public static final String UPDATE_APPROVE_DETAILS = "update FDAS_CALIBRATION_DETAILS set APPROVED_BY = ?,APPROVED_REMARKS = ?,APPROVE_ENTERED_BY = ?,APPROVED_DATE = getUTCDate() where SYSTEM_ID= ? and CUSTOMER_ID = ? and ASSET_NUMBER= ?";

	public static final String UPDATE_VERIFY_DETAILS = "update FDAS_CALIBRATION_DETAILS set VERIFIED_BY = ?, VERIFIED_REMARKS=? where SYSTEM_ID= ? and CUSTOMER_ID = ? and ASSET_NUMBER= ? and ID = ?";

	public static final String APPROVED_STATUS = "select isnull(APPROVED_BY,-1) as APPROVE_STATUS from dbo.FDAS_CALIBRATION_DETAILS where ASSET_NUMBER=? and SYSTEM_ID= ? and CUSTOMER_ID = ?";

	public static final String UPDATE_RFUEL_COUNT_INCREMENT = "update dbo.FUEL_FORMULA_VALUE set REFUEL_COUNTER = isNull(REFUEL_COUNTER,0) + 1 where VehicleNo = ? and SystemId = ? and ClientId = ?";

	public static final String UPDATE_RFUEL_COUNT_INCREMENT_TO_ZERO = "update dbo.FUEL_FORMULA_VALUE set REFUEL_COUNTER = 0 where VehicleNo = ? and SystemId = ? and ClientId = ?";

	public static final String INSERT_HISTORY_DATA ="insert into dbo.FDAS_APPROVE_HISTORY (ASSET_NUMBER,APPROVED_BY,APPROVED_REMARKS,APPROVE_ENTERED_BY,APPROVED_DATE,SYSTEM_ID,CUSTOMER_ID) select ASSET_NUMBER,APPROVED_BY,APPROVED_REMARKS,APPROVE_ENTERED_BY,APPROVED_DATE,SYSTEM_ID,CUSTOMER_ID from dbo.FDAS_CALIBRATION_DETAILS where ASSET_NUMBER=? and SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String GET_UNIT_TYPE_CODE = "select isNull(Unit_Type_Code, '') as Unit_Type_Code from dbo.Vehicle_association where Registration_no = ? and System_id=? ";

	public static final String INSERT_FUEL_MULTI_VALUE_CALIBRATION_DETAILS = "insert into dbo.FUEL_FORMULA_MULTI_VALUE(ASSET_NUMBER, VOLTAGE, FUEL, M_CODE, C_CODE) values (?, ?, ?, ?, ?)";

	public static final String MOVE_FUEL_MULTI_VALUE_CALIBRATION_DETAILS_TO_HISTORY= "insert into dbo.FUEL_FORMULA_MULTI_VALUE_HISTORY(ID, ASSET_NUMBER, VOLTAGE, FUEL, M_CODE, C_CODE) select ID, ASSET_NUMBER, VOLTAGE, FUEL, M_CODE, C_CODE from dbo.FUEL_FORMULA_MULTI_VALUE where ASSET_NUMBER = ?";

	public static final String DELETE_FUEL_MULTI_VALUE_CALIBRATION_DETAILS = "delete from dbo.FUEL_FORMULA_MULTI_VALUE where ASSET_NUMBER = ?";

}
