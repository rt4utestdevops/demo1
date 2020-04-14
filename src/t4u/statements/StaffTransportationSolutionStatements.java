package t4u.statements;

public class StaffTransportationSolutionStatements {

	public static final String  CHECK_SHIFT_ALREADY_EXIST=" select SHIFT_NAME from AMS.dbo.SHIFT_MASTER where SHIFT_NAME=? AND SYSTEM_ID = ? AND CUSTOMER_ID = ? AND BRANCH_ID=? ";

	public static final String INSERT_SHIFT ="insert into AMS.dbo.SHIFT_MASTER (SHIFT_NAME,START_TIME,END_TIME,STATUS,SYSTEM_ID,CUSTOMER_ID,INSERTED_DATETIME,INSERTED_BY,BRANCH_ID) VALUES(?,?,?,?,?,?,GETUTCDATE(),?,?)";

	public static final String  CHECK_SHIFT_ALREADY_EXIST_FOR_MODIFY=" select SHIFT_NAME from AMS.dbo.SHIFT_MASTER where SHIFT_NAME=? AND SYSTEM_ID = ? AND CUSTOMER_ID = ?  and SHIFT_ID != ? ";

	public static final String UPDATE_SHIFT = "update AMS.dbo.SHIFT_MASTER set SHIFT_NAME=?,START_TIME=?,END_TIME=?,STATUS=? ,UPDATED_DATETIME = GETUTCDATE(),UPDATED_BY = ?,BRANCH_ID=? "
		+ " where SYSTEM_ID=? and CUSTOMER_ID=? and SHIFT_ID=? ";
	
	public static final String GET_SHIFT_DETAILS = " select SHIFT_ID,SHIFT_NAME,START_TIME,END_TIME,STATUS,isnull(B.BranchName,'') as BRANCH,isnull(S.BRANCH_ID,'') as BRANCH_ID "
		+ "from AMS.dbo.SHIFT_MASTER S LEFT OUTER JOIN Maple.dbo.tblBranchMaster B ON  S.BRANCH_ID=B.BranchId where SYSTEM_ID=? and CUSTOMER_ID=? ORDER BY BRANCH_ID";
	
	public static final String  DELETE_SHIFT = " delete from  AMS.dbo.SHIFT_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and SHIFT_ID = ? ";
	
	public static final String GET_ALL_VEHICLES =  " select b.REGISTRATION_NUMBER as VEHICLE_NO from AMS.dbo.tblVehicleMaster a "+
	                                               " inner join AMS.dbo.VEHICLE_CLIENT b on a.VehicleNo = b.REGISTRATION_NUMBER and a.System_id = b.SYSTEM_ID "+
	                                               " where a.System_id = ? and a.VehicleStatus = 'Active' and b.CLIENT_ID = ? ";
	
	public static final String GET_VEHICLES = " select b.REGISTRATION_NUMBER as VEHICLE_NO from AMS.dbo.tblVehicleMaster a "+
												    " inner join AMS.dbo.VEHICLE_CLIENT b on a.VehicleNo = b.REGISTRATION_NUMBER and a.System_id = b.SYSTEM_ID "+
												    " where a.System_id = ? and a.VehicleStatus = 'Active' and b.CLIENT_ID = ? and b.GROUP_ID= ? ";
													
	public static final String GET_ALL_SHIFTS = " select SHIFT_ID,SHIFT_NAME,START_TIME,END_TIME from AMS.dbo.SHIFT_MASTER where SYSTEM_ID = ? AND CUSTOMER_ID = ?  ";
	
	public static final String CHECK_VEHICLE_ALREADY_EXIST = " Select VEHICLE_NUMBER FROM AMS.dbo.SHIFT_VEHICLE_ASSOCIATION where VEHICLE_NUMBER = ? and SYSTEM_ID = ? and CUSTOMER_ID = ? and SHIFT_ID = ? ";
	
	public static final String INSERT_ASSOCIATION = " INSERT INTO AMS.dbo.SHIFT_VEHICLE_ASSOCIATION (VEHICLE_NUMBER,SHIFT_ID,STATUS,INSERTED_BY,INSERTED_DATETIME,SYSTEM_ID,CUSTOMER_ID,BRANCH_ID,GROUP_ID,GROUP_NAME )values(?,?,?,?,getUtcdate(),?,?,?,?,?) ";
	
	public static final String MODIFY_ASSOCIATION = " update AMS.dbo.SHIFT_VEHICLE_ASSOCIATION set VEHICLE_NUMBER = ? ,SHIFT_ID = ? ,STATUS = ? , UPDATED_BY = ? , UPDATED_DATETIME = getutcdate() where SYSTEM_ID = ? and CUSTOMER_ID = ? and ASSC_ID = ? ";
	
	public static final String GET_ASSOCIATIONT_DETAILS = " select a.SHIFT_ID,a.ASSC_ID,a.VEHICLE_NUMBER,b.SHIFT_NAME,b.START_TIME,b.END_TIME,a.STATUS,ISNULL(GROUP_NAME,'') AS GROUP_NAME,isnull(B.BranchName,'') as BRANCH,isnull(a.BRANCH_ID,'') as BRANCH_ID "+
		                                                  " from AMS.dbo.SHIFT_VEHICLE_ASSOCIATION a inner join AMS.dbo.SHIFT_MASTER b "+
		                                                  " on a.SHIFT_ID = b.SHIFT_ID LEFT OUTER JOIN Maple.dbo.tblBranchMaster B ON  a.BRANCH_ID=B.BranchId"+
		                                                  " where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? ";
	

	public static final String  DELETE_ASSOCIATION = " delete from  AMS.dbo.SHIFT_VEHICLE_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? and ASSC_ID = ? ";
	
	public static final String  GET_BRANCH_NAME="select BranchId,BranchName from Maple.dbo.tblBranchMaster where SystemId=? AND ClientId=? order by BranchName";

	public static final String GET_ALL_SHIFTS_BRANCH = " select distinct  a.SHIFT_ID,a.SHIFT_NAME,a.START_TIME,a.END_TIME from AMS.dbo.SHIFT_MASTER a inner join AMS.dbo.SHIFT_VEHICLE_ASSOCIATION b on a.SHIFT_ID = b.SHIFT_ID where a.SYSTEM_ID = ? AND a.CUSTOMER_ID = ? and b.GROUP_ID = ? ";
   
	public static final String GET_VEHICLE_NOS = " select c.Odometer as ODOMETER,isnull(c.VehicleAlias,'') as VEHICLE_ID ,a.VEHICLE_NUMBER,a.GROUP_NAME,b.SHIFT_NAME,b.START_TIME,b.END_TIME "+
                                                 " from AMS.dbo.SHIFT_VEHICLE_ASSOCIATION a inner join AMS.dbo.SHIFT_MASTER b "+
                                                 " on a.SHIFT_ID = b.SHIFT_ID "+
                                                 " inner join AMS.dbo.tblVehicleMaster (NOLOCK) c on c.VehicleNo=a.VEHICLE_NUMBER "+
                                                 " where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and a.GROUP_ID = ? and a.SHIFT_ID = ?  ";

	public static final String GET_SHIFT_DETAILS2 =  " select SHIFT_NAME,START_TIME,END_TIME from AMS.dbo.SHIFT_MASTER where SYSTEM_ID = ? AND CUSTOMER_ID = ? and SHIFT_ID =?  ";
	
	public static final String  GET_SHIFT_BASED_ON_BRANCH=" SELECT SHIFT_ID,SHIFT_NAME,START_TIME,END_TIME FROM AMS.dbo.SHIFT_MASTER WHERE  SYSTEM_ID=? AND CUSTOMER_ID=? AND BRANCH_ID=? ";
	
	
	public static final String  GET_VEHICLE_AND_GROUP=" select b.REGISTRATION_NUMBER  as VEHICLE_NO,ISNULL(b.GROUP_ID,'') AS GROUP_ID ,ISNULL(c.GROUP_NAME,'' ) as GROUP_NAME from AMS.dbo.tblVehicleMaster a "+
												" inner join AMS.dbo.VEHICLE_CLIENT b on a.VehicleNo = b.REGISTRATION_NUMBER and a.System_id = b.SYSTEM_ID "+
												" left outer join  ADMINISTRATOR.dbo.ASSET_GROUP c on  b.GROUP_ID=c.GROUP_ID "+
												" where  a.VehicleStatus = 'Active' and a.System_id = ? and b.CLIENT_ID = ? ";
	
	public static final String  GET_SHIFT_DETAIS_FOR_VALIDATION=" SELECT SHIFT_ID,SHIFT_NAME,START_TIME,END_TIME FROM dbo.SHIFT_MASTER WHERE  SYSTEM_ID=? AND CUSTOMER_ID=? AND BRANCH_ID=? ORDER BY SHIFT_ID ASC";
	
	public static final String  CHECK_IS_ASSOCIATED_WITH_OTHER_BRANCH=" SELECT VEHICLE_NUMBER FROM AMS.dbo.SHIFT_VEHICLE_ASSOCIATION WHERE VEHICLE_NUMBER=? AND SYSTEM_ID=? AND CUSTOMER_ID=? AND BRANCH_ID!=?  ";

	public static final String GET_VEHICLE_GROUP_FROM_SHIFT_MASTER = " SELECT DISTINCT GROUP_ID,GROUP_NAME  FROM  AMS.dbo.SHIFT_VEHICLE_ASSOCIATION  where SYSTEM_ID = ? and  CUSTOMER_ID = ? ";

	public static final String  SELECT_SHIFT_TIMINGS = " select START_TIME,END_TIME from  AMS.dbo.SHIFT_MASTER where SHIFT_ID = ? ";

	public static final String SELECT_ALL_SHIFT_TIMINGS =  " select top 1 START_TIME,END_TIME from AMS.dbo.SHIFT_MASTER a "+
                                                           " inner join  AMS.dbo.SHIFT_VEHICLE_ASSOCIATION b on a.SHIFT_ID = b.SHIFT_ID "+
		                                                   " where  a.SYSTEM_ID = ? and  a.CUSTOMER_ID = ? and b.GROUP_ID = ? order by a.START_TIME desc ";
	public static final String SELECT_ALL_SHIFT_TIMINGS1 =  " select top 1 START_TIME,END_TIME from AMS.dbo.SHIFT_MASTER a "+
    " inner join  AMS.dbo.SHIFT_VEHICLE_ASSOCIATION b on a.SHIFT_ID = b.SHIFT_ID "+
    " where  a.SYSTEM_ID = ? and  a.CUSTOMER_ID = ? and b.GROUP_ID = ? order by a.START_TIME asc ";
	
	public static final String GET_VEHICLE_NOS2 = " select c.Odometer as ODOMETER,isnull(c.VehicleAlias,'') as VEHICLE_ID ,a.VEHICLE_NUMBER,a.GROUP_NAME,b.SHIFT_NAME,b.START_TIME,b.END_TIME "+
    " from AMS.dbo.SHIFT_VEHICLE_ASSOCIATION a inner join AMS.dbo.SHIFT_MASTER b "+
    " on a.SHIFT_ID = b.SHIFT_ID "+
    " inner join AMS.dbo.tblVehicleMaster (NOLOCK) c on c.VehicleNo=a.VEHICLE_NUMBER "+
    " where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and a.GROUP_ID = ?  ";
	
	public static final String GET_VEHICLES_BASED_ON_GROUP = "select REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT WHERE SYSTEM_ID=? and CLIENT_ID=? and GROUP_ID=?";

	public static final String GET_HARSH_ACC_BRK_COUNT = "select count(*) as AlertCount,REGISTRATION_NO,c.AlertId " +
			"from ALERT.dbo.HARSH_ALERT_DATA a " +
			"left outer join AMS.dbo.Alert_Master_Details c on a.SYSTEM_ID=c.SystemId and a.TYPE_OF_ALERT=c.AlertId " +
			"where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.GMT between ? and ? and AlertId in (58,105) and REGISTRATION_NO in " +
			"(" +
			"	select REGISTRATION_NUMBER collate database_default from VEHICLE_CLIENT vc, Vehicle_User vu " +
			"	left outer join tblVehicleMaster vm on vm.VehicleNo=vu.Registration_no  " +
			"	where vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no and " +
			"	vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? and GROUP_ID=? " +
			") group by REGISTRATION_NO,c.AlertId " +
			"union " +
			"select count(*) as AlertCount,REGISTRATION_NO,d.AlertId " +
			"from ALERT.dbo.HARSH_ALERT_DATA_HISTORY b " +
			"left outer join AMS.dbo.Alert_Master_Details d on b.SYSTEM_ID=d.SystemId and b.TYPE_OF_ALERT=d.AlertId " +
			"where b.SYSTEM_ID=? and b.CUSTOMER_ID=? and b.GMT between ? and ? and AlertId in (58,105) and REGISTRATION_NO in " +
			"(" +
			"	select REGISTRATION_NUMBER collate database_default from VEHICLE_CLIENT vc, Vehicle_User vu " +
			"	left outer join tblVehicleMaster vm on vm.VehicleNo=vu.Registration_no  " +
			"	where vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no and " +
			"	vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? and GROUP_ID=? " +
			")group by REGISTRATION_NO,d.AlertId order by REGISTRATION_NO,AlertId"; 
	
	public static final String GET_STAFF_ACTIVITY_REPORT = "select vs.RegistrationNo,sum(vs.NoOfIdle) as NoOfIdle,sum(vs.IdleDurationHrs*60*60*1000) as IdleDurationMilliSec," +
			"sum(vs.NoOfOverSpeed) as NoOfOverSpeed,max(vs.MaxSpeed) as MaxSpeed,sum(vs.TravelTimeHrs*60*60*1000) as TravelTimeMilliSec," +
			"sum(vs.TotalDistanceTravelled) as TotalDistanceTravelled ,max(glh.GPS_DATETIME) as LastCommTime,max(v.Odometer) as Odometer," +
			"max(isnull(v.OverSpeedLimit,0)) as StandardSpeed,sum(isnull(vs.SBViolationCount,0)) as SBViolationCount " +
			"from VehicleSummaryData vs " +
			"inner join tblVehicleMaster v on vs.RegistrationNo=v.VehicleNo " +
			"inner join AMS.dbo.gpsdata_history_latest glh on glh.REGISTRATION_NO=v.VehicleNo and glh.System_id=v.System_id " +
			"where vs.DateGMT >= ? and vs.DateGMT < ? and  vs.RegistrationNo in " +
			"( " +
			"	select REGISTRATION_NUMBER from VEHICLE_CLIENT vc, Vehicle_User vu " +
			"	left outer join tblVehicleMaster vm on vm.VehicleNo=vu.Registration_no  " +
			"	where vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no and " +
			"	vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? and GROUP_ID=? " +
			") group by vs.RegistrationNo order by vs.RegistrationNo desc";
	
	
	public static final String GET_DAYS_USED = "select count(*) as DaysUsed,RegistrationNo from VehicleSummaryData " +
			"where DateGMT >= ? and DateGMT < ? and  TotalDistanceTravelled>1 and RegistrationNo in " +
			"( " +
			"	select REGISTRATION_NUMBER from VEHICLE_CLIENT vc, Vehicle_User vu " +
			"	left outer join tblVehicleMaster vm on vm.VehicleNo=vu.Registration_no  " +
			"	where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=?  and GROUP_ID=? " +
			"	and vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no " +
			")	group by RegistrationNo order by RegistrationNo  desc";
					
	public static final String GET_VEHICLE_DETAILS_FROM_SHEDULAR = " select isnull(sum(isnull(TRIP_COUNT,0)),0) as noOfTrip,isnull(sum(isnull(TOTAL_KMS,0)),0) as totalKms,isnull(sum(isnull(TOTAL_DURATION,0)),0) as duration,isnull(max(LAST_GPS_TIME),'') as lastKnownTime, "+
			"isnull(sum(isnull(TRIP_DURATION,0)),0) as Trip_Duration, isnull(max(isnull(MAX_SPEED,0)),0) as Max_Speed, isnull(sum(isnull(SPEED_LIMIT,0)),0) as Speed_Limit, isnull(sum(isnull(OS_COUNT,0)),0) as OS_COUNT, isnull(sum(isnull(HA_COUNT,0)),0) as HA_COUNT, isnull(sum(isnull(HB_COUNT,0)),0) as HB_COUNT, "+  
			"isnull(sum(isnull(IDLE_COUNT,0)),0) as IDLE_COUNT, isnull(sum(isnull(SB_ALERT_COUNT,0)),0) as SB_ALERT_COUNT, isnull(sum(isnull(IDLE_DURATION,0)),0) as IDLE_DURATION "+
			"from AMS.dbo.SHIFTWISE_TRIP_SUMMARY (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and VEHICLE_NUMBER= ? and  SHIFT_START_TIME = ?  and  SHIFT_END_TIME = ?  and SHIFT_ID = ? ";
			
	public static final String GET_VEHICLE_DETAILS_FROM_SHEDULAR2 =  " select isnull(sum(isnull(TRIP_COUNT,0)),0) as noOfTrip,isnull(sum(isnull(TOTAL_KMS,0)),0) as totalKms,isnull(sum(isnull(TOTAL_DURATION,0)),0) as duration,isnull(max(LAST_GPS_TIME),'') as lastKnownTime, " +
			"isnull(sum(isnull(TRIP_DURATION,0)),0) as Trip_Duration, isnull(max(isnull(MAX_SPEED,0)),0) as Max_Speed, isnull(sum(isnull(SPEED_LIMIT,0)),0) as Speed_Limit, isnull(sum(isnull(OS_COUNT,0)),0) as OS_COUNT, isnull(sum(isnull(HA_COUNT,0)),0) as HA_COUNT, isnull(sum(isnull(HB_COUNT,0)),0) as HB_COUNT, "+  
			"isnull(sum(isnull(IDLE_COUNT,0)),0) as IDLE_COUNT, isnull(sum(isnull(SB_ALERT_COUNT,0)),0) as SB_ALERT_COUNT, isnull(sum(isnull(IDLE_DURATION,0)),0) as IDLE_DURATION "+
	        "from AMS.dbo.SHIFTWISE_TRIP_SUMMARY (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and VEHICLE_NUMBER= ? and  SHIFT_END_TIME between ? and ? ";
	
	public static final String GET_SPEEDING_DETAILS = "select isnull(rh.LOCATION,'') as ROUTE,pod.VEHICLE_NUMBER,isnull(dateadd(mi,?,pod.GMT),'') as Date, isnull(pod.LOCATION,'') as LOCATION,isnull(max(pod.SPEED),0) as MAX_SPEED, isnull(pod.SPEED_LIMIT,0) as SPEED_LIMIT, " +
			"isnull(pod.PATH_OS_DURATION,0) as PATH_OS_DURATION,isnull(dm.Fullname,'') as DRIVER_NAME from AMS.dbo.PATH_OS_DETAILS pod " +
			"left outer join AMS.dbo.Driver_Master dm on dm.System_id=pod.SYSTEM_ID and dm.Client_id=pod.CUSTOMER_ID " +
			"left outer join AMS.dbo.Driver_Vehicle dv on dv.SYSTEM_ID=pod.SYSTEM_ID and dv.DRIVER_ID=pod.DRIVER_ID "+
			" inner join AMS.dbo.VEHICLE_CLIENT b on pod.VEHICLE_NUMBER = b.REGISTRATION_NUMBER and pod.SYSTEM_ID = b.SYSTEM_ID " +
			" left outer join AMS.dbo.ROUTE_HUB rh on rh.ROUTE_HUB_ID=pod.ROUTE_HUB_ID " +
			"where pod.SYSTEM_ID=? and pod.CUSTOMER_ID=? and pod.GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) && " +
			"group by pod.SPEED,pod.GMT,pod.LOCATION,pod.SPEED_LIMIT,pod.PATH_OS_DURATION,dm.Fullname,pod.VEHICLE_NUMBER,rh.LOCATION order by pod.VEHICLE_NUMBER desc ";

	public static final String GET_SHIFTWISE_VEHICLE_DETAILS = " select convert(varchar(10),dateadd(mi,180,START_TIME),120) as START_DATE,convert(varchar(10),dateadd(mi,180,END_TIME),120) as END_DATE, " +
            " substring(CONVERT(VARCHAR, dateadd(mi,180,START_TIME), 114),1,5) as START_TIME,substring(CONVERT(VARCHAR, dateadd(mi,180,END_TIME), 114),1,5) as END_TIME,VEHICLE_NUMBER,isnull(TOTAL_KMS,0) as TOTAL_KM,TOTAL_DURATION as DURATION,dateadd(mi,180,START_TIME) as START_DATETIME,dateadd(mi,180,END_TIME) as END_DATETIME  from AMS.dbo.SHIFTWISE_TRIP_DETAILS where VEHICLE_NUMBER=? and CUSTOMER_ID=? " +
            " ## and BRANCH_ID=?  and START_TIME between dateadd(mi,-180,?) and dateadd(mi,-180,?) " ;
}

