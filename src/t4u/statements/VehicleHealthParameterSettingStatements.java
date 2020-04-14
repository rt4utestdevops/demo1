package t4u.statements;

public class VehicleHealthParameterSettingStatements {

	public static final String GET_VEHICLE_MODEL_DETAILS = " SELECT  distinct isNull(ModelName,'') as ModelName, isNull(ModelTypeId,0) as ModelTypeId from AMS.dbo.VHE_PARAMETER_MASTER vpm "
			+ " inner join FMS.dbo.Vehicle_Model vm on vpm.VEHICLE_MODEL  = vm.ModelTypeId and vpm.SYSTEM_ID = vm.SystemId "
			+ " where vpm.SYSTEM_ID = ? and vpm.CLIENT_ID = ? ";

	public static final String GET_VEHICLE_PARAMETERS_DETAILS = " select isNull(vpm.PARAM_NAME,'') as PARAM_NAME, isNull(MIN_VALUE_RED,'0') as MIN_VALUE_RED, "
			+ " isNull(MIN_VALUE_YELLOW,'0') as MIN_VALUE_YELLOW ,isNull(MIN_VALUE_GREEN,'0') as MIN_VALUE_GREEN , isNull(MAX_VALUE_RED,'0') as MAX_VALUE_RED, "
			+ " isNull(MAX_VALUE_YELLOW,'0') as MAX_VALUE_YELLOW, isNull(MAX_VALUE_GREEN,'0') as MAX_VALUE_GREEN, isNull(PARAM_ID,'0') as PARAM_ID "
			+ " from AMS.dbo.VHE_PARAMETERS vp "
			+ " inner join AMS.dbo.VHE_PARAMETER_MASTER vpm on vpm.VEHICLE_MODEL = vp.MODEL and vp.PARAM_ID = vpm.ID "
			+ " where vp.MODEL = ? and vp.SYSTEM_ID = ? and vp.CLIENT_ID = ? ";

	public static final String GET_VEHICLE_PARAMETERS_NAMES = "select distinct isNull(PARAM_NAME,'') as PARAM_NAME, isNull(ID,'0') as PARAM_ID from AMS.dbo.VHE_PARAMETER_MASTER where ID not in "
			+ " (select PARAM_ID from AMS.dbo.VHE_PARAMETERS where MODEL= ?  and SYSTEM_ID = ? and CLIENT_ID = ? ) ";

	public static final String SAVE_VEHICLE_PARAMETERS = "INSERT into AMS.dbo.VHE_PARAMETERS (MODEL, PARAM_ID, MIN_VALUE_RED, MAX_VALUE_RED, MIN_VALUE_YELLOW, MAX_VALUE_YELLOW, MIN_VALUE_GREEN, MAX_VALUE_GREEN, SYSTEM_ID, CLIENT_ID, UPDATED_BY ) "
			+ " values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) ";

	public static final String GET_ALL_VEHICLE_PARAMETERS_NAMES = " select isNull(PARAM_NAME,'') as PARAM_NAME, isNull(ID,'0') as PARAM_ID"
			+ " from AMS.dbo.VHE_PARAMETER_MASTER  where SYSTEM_ID = ? and CLIENT_ID = ? ";

	public static final String INSERT_INTO_VEHICLE_PARAMETERS_HISTORY = "INSERT into AMS.dbo.VHE_PARAMETERS_HISTORY (MODEL, PARAM_ID, MIN_VALUE_RED, MIN_VALUE_YELLOW, MIN_VALUE_GREEN,MAX_VALUE_RED, MAX_VALUE_YELLOW, MAX_VALUE_GREEN,SYSTEM_ID, CLIENT_ID, UPDATED_BY ) "
			+ " values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ) ";

	public static final String UPDATE_MODIFIED_DATA_IN_VEHICLE_PARAMETERS = "Update AMS.dbo.VHE_PARAMETERS "
			+ " SET MIN_VALUE_RED = ?, MAX_VALUE_RED = ?,MIN_VALUE_YELLOW = ?, MAX_VALUE_YELLOW = ?,MIN_VALUE_GREEN = ?, MAX_VALUE_GREEN = ?, UPDATED_BY = ?, UPDATED_GMT = getUTCdate() "
			+ " WHERE MODEL = ? AND PARAM_ID = ? AND SYSTEM_ID = ? AND CLIENT_ID = ? ";
}
