package t4u.statements;

public class UtilizationReportsStatements {
	
 public static final String GET_GROUP_NAME_FOR_CLIENT=" select a.GROUP_ID,b.GROUP_NAME from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION a " 
													+ " inner join  ADMINISTRATOR.dbo.ASSET_GROUP b on a.GROUP_ID=b.GROUP_ID and a.SYSTEM_ID=b.SYSTEM_ID " 
													+ " where b.CUSTOMER_ID=? and a.USER_ID=? and a.SYSTEM_ID=?";
 
 public static final String GET_UTILIZATION_WORKING_HOLIDAYS_AND_WEEKENDS_REPORT="select ASSET_NUMBER as ASSET_NUMBER,isnull(b.GROUP_NAME,'') as GROUP_NAME,isnull(c.VehicleType,'') as ASSET_TYPE,(DATEDIFF(day,dateadd(mi,-?,?),dateadd(mi,-?,?))+1) as SELECTED_DAYS," +
 		"count(HOLIDAY) as NON_WORKING_DAYS,sum(TOATL_ENGINE_HRS) as HRS_OF_IGNITION_ON,sum(TOTAL_RUNNING_TIME) as TRAVEL_TIME,sum(TOTAL_DISTANCE_TRAVELLED) as DISTANCE_TRAVELLED,isnull(d.ModelName,'') as ASSET_MODEL from AMS.dbo.DAILY_UTILIZATION a (NOLOCK) "
        + "inner join AMS.dbo.Vehicle_User v (NOLOCK) on v.Registration_no=a.ASSET_NUMBER and v.System_id=a.SYSTEM_ID "
 		+ "inner join AMS.dbo.tblVehicleMaster c (NOLOCK) on a.ASSET_NUMBER=c.VehicleNo and a.SYSTEM_ID=c.System_id "
 		+ "inner join dbo.VEHICLE_CLIENT vc (NOLOCK) on vc.CLIENT_ID=a.CUSTOMER_ID and vc.SYSTEM_ID=a.SYSTEM_ID and vc.REGISTRATION_NUMBER=a.ASSET_NUMBER "
 		+ "left outer join FMS.dbo.Vehicle_Model d (NOLOCK) on c.Model=ModelTypeId and a.SYSTEM_ID=d.SystemId "
 		+ "left outer join ADMINISTRATOR.dbo.ASSET_GROUP b on vc.GROUP_ID=b.GROUP_ID and  vc.SYSTEM_ID=b.SYSTEM_ID  and vc.CLIENT_ID=b.CUSTOMER_ID  " 
 		+ "where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and v.User_id=? # and HOLIDAY='Y' and a.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) group by a.ASSET_NUMBER,b.GROUP_NAME,c.VehicleType,d.ModelName order by a.ASSET_NUMBER "; 	
 
 public static final String GET_UTILIZATION_DURING_WORKING_DAYS="select count(UTILIZED) as UTILIZATION_DURING_WORKING_DAYS from AMS.dbo.DAILY_UTILIZATION xx (NOLOCK) where HOLIDAY='N' and DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and UTILIZED='Y' and xx.ASSET_NUMBER=? group by xx.ASSET_NUMBER ";
 
 public static final String GET_Utilized_On_Holidays="select count(UTILIZED) as Utilized_On_Holidays from AMS.dbo.DAILY_UTILIZATION xy (NOLOCK) where HOLIDAY='Y' and DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and UTILIZED='Y' and xy.ASSET_NUMBER=? group by xy.ASSET_NUMBER ";
 
 public static final String GET_DATA_FOR_WORKINGDAYS_WORKINGHRS_REPORT="select a.ASSET_NUMBER,isnull(c.VehicleType,'') as ASSET_TYPE,isnull(b.GROUP_NAME,'') as GROUP_NAME,(DATEDIFF(day,dateadd(mi,-?,?),dateadd(mi,-?,?))+ 1) as SELECTED_DAYS, "
	 + "count(a.HOLIDAY) as WORKING_DAYS,isnull((select count(UTILIZED) from AMS.dbo.DAILY_UTILIZATION (NOLOCK) xx where xx.HOLIDAY='N' and xx.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) "
	 + "and xx.ASSET_NUMBER=a.ASSET_NUMBER and xx.UTILIZED='Y' "
	 + "group by xx.ASSET_NUMBER),0) as UTILIZATION,isnull(d.ModelName,'') as ASSET_MODEL "
	 + "from AMS.dbo.DAILY_UTILIZATION (NOLOCK) a "
	 + "inner join AMS.dbo.Vehicle_User v (NOLOCK) on v.Registration_no=a.ASSET_NUMBER and v.System_id=a.SYSTEM_ID "
	 + "inner join AMS.dbo.tblVehicleMaster c (NOLOCK) on a.ASSET_NUMBER=c.VehicleNo and a.SYSTEM_ID=c.System_id "
	 + "inner join dbo.VEHICLE_CLIENT vc (NOLOCK) on vc.CLIENT_ID=a.CUSTOMER_ID and vc.SYSTEM_ID=a.SYSTEM_ID and vc.REGISTRATION_NUMBER=a.ASSET_NUMBER "
	 + "left outer join FMS.dbo.Vehicle_Model d (NOLOCK) on c.Model=ModelTypeId and a.SYSTEM_ID=d.SystemId "
	 + "left outer join ADMINISTRATOR.dbo.ASSET_GROUP b on vc.GROUP_ID=b.GROUP_ID and  vc.SYSTEM_ID=b.SYSTEM_ID  and vc.CLIENT_ID=b.CUSTOMER_ID "
	 + "where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and v.User_id=? # and a.HOLIDAY='N' and a.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) "
	 + "group by a.ASSET_NUMBER,b.GROUP_NAME,c.VehicleType,d.ModelName ";
 
 public static final String GET_REPORT_FOR_WORKINGDAYS_AFTER_WORKINGHRS="select a.ASSET_NUMBER,isnull(c.VehicleType,'') as ASSET_TYPE ,isnull(b.GROUP_NAME,'') as GROUP_NAME,(DATEDIFF(day,dateadd(mi,-?,?),dateadd(mi,-?,?))+ 1) as SELECTED_DAYS, "
	 + "count(a.HOLIDAY) as WORKING_DAYS,isnull((select count(UTILIZED) from AMS.dbo.DAILY_UTILIZATION (NOLOCK) xx where xx.HOLIDAY='N' and xx.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) "
	 + "and xx.ASSET_NUMBER=a.ASSET_NUMBER and xx.UTILIZED='Y' "
	 + "group by xx.ASSET_NUMBER),0) as UTILIZATION,isnull(d.ModelName,'') as ASSET_MODEL "
	 + "from AMS.dbo.DAILY_UTILIZATION (NOLOCK) a "
	 + "inner join AMS.dbo.Vehicle_User v (NOLOCK) on v.Registration_no=a.ASSET_NUMBER and v.System_id=a.SYSTEM_ID "
	 + "inner join AMS.dbo.tblVehicleMaster c (NOLOCK) on a.ASSET_NUMBER=c.VehicleNo and a.SYSTEM_ID=c.System_id "
	 + "inner join dbo.VEHICLE_CLIENT vc (NOLOCK) on vc.CLIENT_ID=a.CUSTOMER_ID and vc.SYSTEM_ID=a.SYSTEM_ID and vc.REGISTRATION_NUMBER=a.ASSET_NUMBER "
 	 + "left outer join FMS.dbo.Vehicle_Model d (NOLOCK) on c.Model=ModelTypeId and a.SYSTEM_ID=d.SystemId "
	 + "left outer join ADMINISTRATOR.dbo.ASSET_GROUP b on vc.GROUP_ID=b.GROUP_ID  and  vc.SYSTEM_ID=b.SYSTEM_ID  and vc.CLIENT_ID=b.CUSTOMER_ID "
	 + "where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and v.User_id=? # and a.HOLIDAY='N' and a.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) "
	 + "group by a.ASSET_NUMBER,b.GROUP_NAME,c.VehicleType,d.ModelName ";
 
 public static final String GET_UTILIZATION_SUMMARY_REPORT="select a.ASSET_NUMBER as ASSET_NUMBER,isnull(c.VehicleType,'') as ASSET_TYPE,isnull(b.GROUP_NAME,'') as GROUP_NAME,(DATEDIFF(day,dateadd(mi,-?,?),dateadd(mi,-?,?))+ 1) as SELECTED_DAYS,count(a.HOLIDAY) as WORKING_DAYS,isnull(d.ModelName,'') as ASSET_MODEL from AMS.dbo.DAILY_UTILIZATION (NOLOCK) a inner join AMS.dbo.Vehicle_User v (NOLOCK) on v.Registration_no=a.ASSET_NUMBER and v.System_id=a.SYSTEM_ID " 
 		+ "inner join AMS.dbo.tblVehicleMaster c (NOLOCK) on a.ASSET_NUMBER=c.VehicleNo and a.SYSTEM_ID=c.System_id inner join dbo.VEHICLE_CLIENT vc (NOLOCK) on vc.CLIENT_ID=a.CUSTOMER_ID and vc.SYSTEM_ID=a.SYSTEM_ID and vc.REGISTRATION_NUMBER=a.ASSET_NUMBER left outer join FMS.dbo.Vehicle_Model d (NOLOCK) on c.Model=ModelTypeId and a.SYSTEM_ID=d.SystemId left outer join ADMINISTRATOR.dbo.ASSET_GROUP b on vc.GROUP_ID=b.GROUP_ID and  vc.SYSTEM_ID=b.SYSTEM_ID  and vc.CLIENT_ID=b.CUSTOMER_ID  where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and v.User_id=? # and a.HOLIDAY='N' and a.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) group by a.ASSET_NUMBER,b.GROUP_NAME,c.VehicleType,d.ModelName ";
 
 public static final String GET_SUMMARY_UTILIZATION_DURING_WORKING_DAYS="select count(UTILIZED) as UTILIZATION_DURING_WORKING_DAYS from AMS.dbo.DAILY_UTILIZATION (NOLOCK) xx where xx.HOLIDAY='N' and xx.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and xx.ASSET_NUMBER=? and xx.UTILIZED='Y' group by xx.ASSET_NUMBER";
 
 public static final String GET_UTILIZATION_DURING_WORKING_HRS="select count(UTILIZED_WORKING_HRS) as UTILIZATION_DURING_WORKING_HRS from AMS.dbo.DAILY_UTILIZATION (NOLOCK) xx where xx.HOLIDAY='N' and xx.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and xx.ASSET_NUMBER=? and xx.UTILIZED_WORKING_HRS='Y' group by xx.ASSET_NUMBER ";
 
 public static final String GET_UTILIZATION_AFTER_WORKING_HRS="select count(UTILIZED_NON_WORKING_HRS) as UTILIZATION_AFTER_WORKING_HRS from AMS.dbo.DAILY_UTILIZATION (NOLOCK) xx where xx.HOLIDAY='N' and xx.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and xx.ASSET_NUMBER=? and xx.UTILIZED_NON_WORKING_HRS='Y' group by xx.ASSET_NUMBER";
 
 public static final String GET_UTILIZATION_DURING_WORKING_HOLIDAYS_AND_WEEKEDS="select count(UTILIZED) as UTILIZATION_DURING_WORKING_HOLIDAYS_AND_WEEKEDS from AMS.dbo.DAILY_UTILIZATION (NOLOCK) xx where xx.HOLIDAY='Y' and xx.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?)and xx.ASSET_NUMBER=? and xx.UTILIZED='Y' group by xx.ASSET_NUMBER";
 
 public static final String GET_DATA_FOR_WORKINGDAYS_AND_WORKING_HOURS="select count(UTILIZED_WORKING_HRS) as UTILIZED_HOURS, "
	 + "sum(RUNNING_TIME_WORKING_HRS) as TRAVELLED_TIME,sum(DISTANCE_TRAVELLED_WORKING_HRS) as DISTANCE_TRAVELLED from AMS.dbo.DAILY_UTILIZATION (NOLOCK) xx where xx.HOLIDAY='N' and xx.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) "
	 + "and xx.ASSET_NUMBER=? and xx.UTILIZED_WORKING_HRS='Y' "
	 + "group by xx.ASSET_NUMBER ";
 
 public static final String GET_DATA_FOR_TRAVEL_TIME_AND_DISTANCE ="select count(UTILIZED_NON_WORKING_HRS) as UTILIZED_HRS, "
	 + "(sum(TOTAL_RUNNING_TIME)-sum(RUNNING_TIME_WORKING_HRS)) as TRAVEL_TIME, "
	 + "(sum(TOTAL_DISTANCE_TRAVELLED)-sum(DISTANCE_TRAVELLED_WORKING_HRS)) as DISTANCE_TRAVELLED "
	 + "from AMS.dbo.DAILY_UTILIZATION (NOLOCK) xx where xx.HOLIDAY='N' and xx.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) "
	 + "and xx.ASSET_NUMBER=? and xx.UTILIZED_NON_WORKING_HRS='Y' "
	 + "group by xx.ASSET_NUMBER ";
  
 public static final String GET_UTILIZATION_WORKING_REPORT="select  a.ASSET_NUMBER,isnull(c.VehicleType,'') as ASSET_TYPE ,isnull(b.GROUP_NAME,'') as GROUP_NAME,(DATEDIFF(day,dateadd(mi,-?,?),dateadd(mi,-?,?))+ 1) as SELECTED_DAYS, "  
	 + "count(HOLIDAY) as WORKING_DAYS,sum(TOTAL_RUNNING_TIME) as TRAVEL_TIME,sum(TOTAL_DISTANCE_TRAVELLED) as DISTANCE_TRAVELLED, " 
	 + "isnull((select count(UTILIZED) from dbo.DAILY_UTILIZATION where HOLIDAY='N' and DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) "  
	 + "and ASSET_NUMBER=a.ASSET_NUMBER and UTILIZED='Y' "  
	 + "group by ASSET_NUMBER),0) as UTILIZATION, isnull(d.ModelName,'') as ASSET_MODEL from dbo.DAILY_UTILIZATION a "
	 + "inner join AMS.dbo.Vehicle_User v on v.Registration_no=a.ASSET_NUMBER and v.System_id=a.SYSTEM_ID "
	 + "inner join AMS.dbo.tblVehicleMaster c (NOLOCK) on a.ASSET_NUMBER=c.VehicleNo and a.SYSTEM_ID=c.System_id "
	 + "inner join dbo.VEHICLE_CLIENT vc (NOLOCK) on vc.CLIENT_ID=a.CUSTOMER_ID and vc.SYSTEM_ID=a.SYSTEM_ID and vc.REGISTRATION_NUMBER=a.ASSET_NUMBER "
	 + "left outer join FMS.dbo.Vehicle_Model d (NOLOCK) on c.Model=ModelTypeId and a.SYSTEM_ID=d.SystemId "
	 + "left outer join ADMINISTRATOR.dbo.ASSET_GROUP b on vc.GROUP_ID=b.GROUP_ID  and vc.SYSTEM_ID=b.SYSTEM_ID  and vc.CLIENT_ID=b.CUSTOMER_ID " 
	 + "where HOLIDAY='N' and a.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) "  
	 + "and a.SYSTEM_ID=? and a.CUSTOMER_ID=? and v.User_id=? # group by ASSET_NUMBER,b.GROUP_NAME,c.VehicleType,d.ModelName "
	 + "order by a.ASSET_NUMBER desc ";

}
