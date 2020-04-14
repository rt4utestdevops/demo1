package t4u.statements;

public class TemperatureReportStatements {

	public static final String GET_TEMPERATURE_REPORT = " select r.REGISTRATION_NO ,r.GMT,r.LOCATION,r.IO_VALUE,IO_CATEGORY,IO_ID from (" +
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,isnull(LOCATION,'') as LOCATION,IO_VALUE,IO_CATEGORY,IO_ID from  RS232_HISTORY " +
	" where REGISTRATION_NO=? and IO_ID in (#) " +
	" and GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) "+
	" union all "+
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,LOCATION,IO_VALUE,IO_CATEGORY,IO_ID from  AMS_Archieve.dbo.RS232_HISTORY_ARCHIEVE " +
	" where REGISTRATION_NO=? and IO_ID in (#) " +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) ) r order by r.GMT ";
	
	public static final String GET_ANALOG_TEMPERATURE_REPORT = 
	" select r.REGISTRATION_NO ,r.GMT,r.LOCATION,r.IO_VALUE,IO_CATEGORY,IO_ID from (" +
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,isnull(LOCATION,'') as LOCATION,ANALOG_INPUT_2 AS IO_VALUE,'T1' AS IO_CATEGORY," +
	" 'T1' AS IO_ID from  HISTORY_DATA_# " +
	" where REGISTRATION_NO=?  " +
	" and GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) "+
	" union all "+
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,isnull(LOCATION,'') as LOCATION,ANALOG_INPUT_2 AS IO_VALUE,'T1' AS IO_CATEGORY," +
	" 'T1' AS IO_ID from  AMS_Archieve.dbo.GE_DATA_# " +
	" where REGISTRATION_NO=?" +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) ) r order by r.GMT ";
	
	public static final String GET_TEMPERATURE_FROM_HISTORY_DATA = " select r.REGISTRATION_NO ,r.GMT,r.LOCATION,r.IO_VALUE,IO_CATEGORY from (" +
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,LOCATION,IO_VALUE,IO_CATEGORY,IO_ID from RS232_HISTORY where REGISTRATION_NO=? and IO_ID=? " +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) " +
	" union all "+
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,LOCATION,IO_VALUE,IO_CATEGORY,IO_ID from AMS_Archieve.dbo.RS232_HISTORY_ARCHIEVE where REGISTRATION_NO=? and IO_ID=? " +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) ) r order by GMT " ;
	
	public static final String GET_ANALOG_TEMPERATURE_FROM_HISTORY_DATA = " select r.REGISTRATION_NO ,r.GMT,r.LOCATION,r.IO_VALUE,IO_CATEGORY from (" +
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,LOCATION, ANALOG_INPUT_2 AS IO_VALUE,'T1' AS IO_CATEGORY,'T1' AS IO_ID from HISTORY_DATA_# where REGISTRATION_NO=? " +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) " +
	" union all "+
	" select REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,LOCATION, ANALOG_INPUT_2 AS IO_VALUE,'T1' AS IO_CATEGORY,'T1' AS IO_ID from AMS_Archieve.dbo.GE_DATA_# where REGISTRATION_NO=? " +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) ) r order by GMT " ;
	
	
	public static final String GET_TRIP_VEHICLE_TEMPERATURE_DETAILS = "SELECT * FROM AMS.dbo.TRIP_VEHICLE_TEMPERATURE_DETAILS WHERE TRIP_ID = ? AND VEHICLE_NUMBER = ?";

	public static final String GET_TRIP_NAMES= " select TRIP_ID,isnull(ORDER_ID,'') as TRIP_NAME,(isnull(ORDER_ID,'')+'-('+isnull(SHIPMENT_ID,'')+')') as TRIP_NAME_1 " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" where SYSTEM_ID=? AND CUSTOMER_ID=? order by TRIP_ID desc ";
	
	public static final String GET_VEHICLES_FOR_TEMP_REPORT = "select DISTINCT gps.REGISTRATION_NO from AMS.dbo.gpsdata_history_latest gps " + 
	" left outer join dbo.Live_Vision_Support  b (nolock) on gps.REGISTRATION_NO=b.REGISTRATION_NO 	"+
	" where gps.System_id=? and gps.CLIENTID = ?" ;
	
	public static final String GET_TRIP_DATA_MUSCAT= " select datediff(dd,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME) as days,VehicleAlias,td.TRIP_ID,isnull(SHIPMENT_ID,'') as TRIP_NAME,ASSET_NUMBER,CUSTOMER_REF_ID,td.STATUS,isnull(dm.Fullname,'') as DRIVER_NAME, " +
	" (case when ts.LOAD_START_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,ts.LOAD_START_TIME) end) as STD, " +
	" (case when ts.LOAD_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,ts.LOAD_END_TIME) end) as END_DATE, " +
	" isnull(vm.ModelName,'') as MAKE from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	" inner join AMS.dbo.tblVehicleMaster c on td.ASSET_NUMBER=c.VehicleNo " +
	" left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model " +
	" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=td.SYSTEM_ID and dv.REGISTRATION_NO = ASSET_NUMBER " +
	" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = td.SYSTEM_ID" +
	" left outer join AMS.dbo.TRACK_TRIP_DETAILS_SUB ts on ts.TRIP_ID=td.TRIP_ID " +
	" where td.TRIP_ID=? " ;
	
	public static final String GET_TRIP_DATA= " select datediff(dd,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME) as days,VehicleAlias,TRIP_ID,isnull(SHIPMENT_ID,'') as TRIP_NAME,ASSET_NUMBER,CUSTOMER_REF_ID,td.STATUS,isnull(dm.Fullname,'') as DRIVER_NAME, " +
	" (case when td.ACTUAL_TRIP_START_TIME is null then dateadd(mi,?,td.TRIP_START_TIME) else dateadd(mi,?,td.ACTUAL_TRIP_START_TIME) end) as STD, " +
	" (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as END_DATE, " +
	" isnull(vm.ModelName,'') as MAKE from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	" inner join AMS.dbo.tblVehicleMaster c on td.ASSET_NUMBER=c.VehicleNo " +
	" left outer join FMS.[dbo].[Vehicle_Model] vm on vm.SystemId=c.System_id and vm.ModelTypeId=c.Model " +
	" left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=td.SYSTEM_ID and dv.REGISTRATION_NO = ASSET_NUMBER " +
	" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id = dv.DRIVER_ID and dv.SYSTEM_ID = td.SYSTEM_ID" +
	" where TRIP_ID=? " ;

}
