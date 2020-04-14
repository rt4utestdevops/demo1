package t4u.statements;

public class OilAndGasStatements {

	public static final String GET_VEHICLE_WHICH_HAS_ALERT_TYPE="select distinct ASSET_NUMBER from AMS.dbo.IO_DATA_SUMMARY (NOLOCK) where  SYSTEM_ID=? and CUSTOMER_ID=? and ALERT_TYPE=?";
	
	public static final String GET_ALL_VEHICLE="select distinct ASSET_NUMBER from AMS.dbo.IO_DATA_SUMMARY (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String GET_OIL_AND_GAS_REPORT_FOR_BOTH="select ASSET_NUMBER,ALERT_TYPE as TYPE,dateadd(mi,?,START_TIME) as TIME_OF_OPENING,dateadd(mi,?,END_TIME) as TIME_OF_CLOSING,isnull(START_LOCATION,'') as LOCATION,isnull(DURATION,'') as DURATION,isnull(DISTANCE_TRAVELLED,'') as DISTANCE_TRAVELLED from AMS.dbo.IO_DATA_SUMMARY (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and START_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and ASSET_NUMBER=? order by ALERT_TYPE,START_TIME ";

	public static final String GET_OIL_AND_GAS_REPORT="select ASSET_NUMBER,ALERT_TYPE as TYPE,dateadd(mi,?,START_TIME) as TIME_OF_OPENING,dateadd(mi,?,END_TIME) as TIME_OF_CLOSING,isnull(START_LOCATION,'') as LOCATION,isnull(DURATION,'') as DURATION,isnull(DISTANCE_TRAVELLED,'') as DISTANCE_TRAVELLED from AMS.dbo.IO_DATA_SUMMARY (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and START_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and ASSET_NUMBER=? and ALERT_TYPE=? order by ALERT_TYPE,START_TIME ";

	
	
}
