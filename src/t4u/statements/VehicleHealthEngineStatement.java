package t4u.statements;

public class VehicleHealthEngineStatement {

	public static final String GET_OBD_VEHICLE_LIST=" select a.REGISTRATION_NO from AMS.dbo.GPSDATA_LIVE_CANIQ a    " +
			" where a.System_id=?  and CLIENTID=?  order by a.REGISTRATION_NO DESC ";
	
	public static final String GET_ACCIDENT_VEHICLE_LIST=" select distinct REGISTRATION_NO from dbo.Alert where SYSTEM_ID=? and CLIENTID=? and TYPE_OF_ALERT=184" +
			" union all " +
			" select distinct REGISTRATION_NO from dbo.Alert_History where SYSTEM_ID=? and CLIENTID=? and TYPE_OF_ALERT=184";
	
	public static final String GET_ACCIDENT_VEHICLE_DETAILS=" select REGISTRATION_NO,isnull(LOCATION,'') as LOCATION,isnull(REMARKS,'') as REMARKS,dateadd(mi,?,GMT) as GMT from dbo.Alert  " +
			" where SYSTEM_ID=? and CLIENTID=? and TYPE_OF_ALERT=184 and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and REGISTRATION_NO=?" +
			" union all " +
			" select REGISTRATION_NO,isnull(LOCATION,'') as LOCATION,isnull(REMARKS,'') as REMARKS,dateadd(mi,?,GMT) as GMT from dbo.Alert_History" +
			" where SYSTEM_ID=? and CLIENTID=? and TYPE_OF_ALERT=184 and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) and REGISTRATION_NO=?";
	
	public static final String GET_COOLENT_TEMP_DETAILS=" select REGISTRATION_NO,MAX_COOLANT,isnull(dateadd(mi,?,START_GMT),'') as START_GMT,isnull(dateadd(mi,?,END_GMT),'') as END_GMT,isnull(DATEDIFF(mi,START_GMT,END_GMT),'') as DURTION, cast( (END_ODOMETER-START_ODOMETER)  as numeric(32,2) )  'DISTANCE' from dbo.OBD_COOLANT_ANALYSIS " +
			" where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO=? " +
			" and START_GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";

	public static final String GET_ENGINE_ERROR_CODE_DETAILS=" select isnull(REGISTRATION_NO,'') as REGISTRATION_NO,isnull(ERROR_CODE,'') as ERROR_CODE,isnull(ERROR_DESC,'') as ERROR_DESC,isnull(dateadd(mi,?,START_GMT),'') as START_GMT,isnull(dateadd(mi,?,END_GMT),dateadd(mi,?,START_GMT)) as END_GMT,isnull(IMPACT,'') as IMPACT" +
			" from dbo.OBD_ERROR_ANALYSIS where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO=? and START_GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";

	public static final String GET_MILEAGE_DETAILS="select cast( sum(DISTANCE_TRAVELLED)/sum(FUEL_CONSUMED)  as numeric(32,2) )  'MILEAGE' ,REGISTRATION_NO," +
			" CONVERT(CHAR(4), START_GMT, 100) + CONVERT(CHAR(4), START_GMT, 120) as Month ," +
			" cast( sum(DISTANCE_TRAVELLED)  as numeric(32,2) )  'DISTANCE_TRAVELLED' ," +
			" cast( sum(FUEL_CONSUMED)  as numeric(32,2) )  'FUEL_CONSUMED' , Year(START_GMT) as yyyy , month(START_GMT)  as mm " +
			" from AMS.dbo.OBD_MILEAGE_ANALYSIS where SYSTEM_ID=? and CUSTOMER_ID=? and  REGISTRATION_NO=?" +
			" and  FUEL_CONSUMED<>0 and MILEAGE>2" +
			" group by  REGISTRATION_NO ,(CONVERT(CHAR(4), START_GMT, 100) + CONVERT(CHAR(4), START_GMT, 120) ) , Year(START_GMT)  , month(START_GMT)  " +
			" having cast( sum(DISTANCE_TRAVELLED)/sum(FUEL_CONSUMED)  as numeric(32,2) ) between 12 and 19" +
			" order by Year(START_GMT)  , month(START_GMT)  ";

	public static final String GET_BATTERY_DETAILS=" select REGISTRATION_NO,isnull(dateadd(mi,?,GMT),'') as GMT,cast( AVG_VALUE  as numeric(32,2) )  'AVG_VALUE' ,DISTANCE from dbo.OBD_BATTERY_ANALYSIS where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) # ";
	
}
