package t4u.statements;

public class SandMiningStatements {

	/**
	 * To fetch List of Non Communicating Vehicles
	 */

	public static final String GET_NON_COMM_PERCENTAGE = "select COUNT(g.REGISTRATION_NO) as REGISTRATION_NO,isnull((select NON_COMMUNICATING_ALERT from ADMINISTRATOR.dbo.CUSTOMER_MASTER where CUSTOMER_ID=? and SYSTEM_ID=?),0) as NON_COMM_HOURS   from dbo.gpsdata_history_latest g "
		+ "inner join dbo.Vehicle_User vu on vu.Registration_no=g.REGISTRATION_NO "
		+ "inner join dbo.tblVehicleMaster v on v.VehicleNo=g.REGISTRATION_NO "
		+ "where   vu.User_id=? and g.CLIENTID=? and g.System_id=? and g.LOCATION !='No GPS Device Connected'";

	public static final String GET_REGISTRATION_NO_BASED_ON_USER = "select t.VehicleNo as REGISTRATION_NUMBER from tblVehicleMaster t "
		+ "inner join dbo.Vehicle_User vu on vu.Registration_no=t.VehicleNo "
		+ "where vu.User_id=? and t.System_id=? order by VehicleNo";

	public static final String GET_TOTAL_NON_COMM_VEHICLES = "select g.REGISTRATION_NO,g.LOCATION,dateadd(mi,?,g.GMT)as GMT,isnull(t.OwnerName,'') as OwnerName,"
		+ "isnull(t.OwnerContactNo,'')as OwnerContactNo from dbo.gpsdata_history_latest g "
		+ "inner join dbo.Vehicle_User vu on vu.Registration_no=g.REGISTRATION_NO "
		+ "inner join dbo.tblVehicleMaster t on t.VehicleNo=g.REGISTRATION_NO "
		+ "where vu.User_id=? and g.CLIENTID=? and g.System_id=? and g.LOCATION !='No GPS Device Connected' and DATEDIFF(mi,g.GMT,getutcdate()) >? order by g.GMT desc";

	public static final String GET_UNAUTHORIZED_PORT_ENTRY_REPORT_DAVANGERE = "select ASSET_NUMBER,isnull(u.REMARKS,'') as REMARKS,u.HUB_ID,s.Port_Name as SAND_BLOCK,dateadd(mi,?,ARRIVAL_TIME) as ARRIVAL_TIME,isnull(DETENTION,0) as DETENTION from dbo.UNAUTHORIZED_PORT_ENTRY u "
		+ "left outer join dbo.Sand_Port_Details s on s.UniqueId=u.PORT_NO "
		+ "where u.CUSTOMER_ID=? and u.SYSTEM_ID=? and  ARRIVAL_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by ARRIVAL_TIME desc ";

	public static final String GET_UNAUTHORIZED_PORT_ENTRY_REPORT = "select ASSET_NUMBER,isnull(u.REMARKS,'') as REMARKS,s.Port_Name as SAND_BLOCK,l.NAME,dateadd(mi,?,ARRIVAL_TIME) as ARRIVAL_TIME,isnull(DETENTION,0) as DETENTION from dbo.UNAUTHORIZED_PORT_ENTRY u "
		+ "inner join dbo.Vehicle_User vu on vu.Registration_no=u.ASSET_NUMBER "
		+ "left outer join dbo.LOCATION_ZONE l on l.HUBID=u.HUB_ID "
		+ "left outer join dbo.Sand_Port_Details s on s.UniqueId=u.PORT_NO "
		+ "left outer join dbo.VEHICLE_CLIENT b on b.REGISTRATION_NUMBER=u.ASSET_NUMBER and b.CLIENT_ID=u.CUSTOMER_ID and b.SYSTEM_ID=u.SYSTEM_ID "
		+ "where vu.User_id=? and u.CUSTOMER_ID=? and u.SYSTEM_ID=? and b.GROUP_ID=? and ARRIVAL_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by ARRIVAL_TIME desc";

	public static final String GET_PORT_WISE_COUNT_BTW_DATES = "select UPPER(s.Port_Name)+isnull('('+UPPER(v.GROUP_NAME)+')','') as Port_Name,sum(t.TRIPSHEET_COUNT) as TRIPSHEET_COUNT,isnull(v.GROUP_NAME,'NA')as GROUP_NAME from dbo.SAND_TRIP_SHEET_COUNT t "
		+ "left outer join  dbo.Sand_Port_Details s on s.UniqueId=t.PORT_NO "
		+ "left outer join  dbo.Sand_Mining_Default_Setting sd on sd.Port_Name=s.Port_Name and sd.System_Id=t.SYSTEM_ID "
		+ "left outer join  dbo.VEHICLE_GROUP v on v.GROUP_ID=sd.Group_Name and v.SYSTEM_ID=t.SYSTEM_ID "
		+ "where t.DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and t.CUSTOMER_ID=? and t.SYSTEM_ID=?  group by t.PORT_NO,s.Port_Name,v.GROUP_NAME order by Port_Name";

	public static final String INSERT_VEHICLE_DETAILS = "insert into dbo.ASSET_ENLISTING(APPLICATION_NO,DATE,ASSET_NUMBER,INSURANACE_NO,INSURANACE_EXP_DATE,FITNESS_EXP_DATE,POLLUTION_EXP_DATE,OWNER_NAME,PERMANENT_ADD,TEMP_ADD,MOBILE_NO,GROSS_WEIGHT,UNLADEN_WEIGHT,RTO,PERMIT_NO,PERMIT_EXP_DATE,LOADING_CAPACITY,YEAR_OF_MANF,SYSTEM_ID,UID,STATUS,INSERTED_DATETIME,ENLISTING_UID)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'Active',getUTCDate(),?)";

	public static final String GET_VEHICAL_ENLISTING_DETAILS = "select a.UID as UNIQUE_ID,a.APPLICATION_NO,a.DATE,a.ASSET_NUMBER,a.INSURANACE_NO,a.INSURANACE_EXP_DATE,a.FITNESS_EXP_DATE,a.POLLUTION_EXP_DATE,a.FIVE_YEAR_PERMIT_NO,a.FIVE_YEAR_PERMIT_EXP_DATE,a.OWNER_NAME,a.PERMANENT_ADD,a.TEMP_ADD,a.MOBILE_NO,a.GROSS_WEIGHT,a.UNLADEN_WEIGHT,a.RTO,a.PERMIT_NO,a.PERMIT_EXP_DATE,a.LOADING_CAPACITY,a.YEAR_OF_MANF,isnull(b.Firstname+''+b.Lastname,'') as ENLISTING_UID from dbo.ASSET_ENLISTING a left outer join Users b on a.ENLISTING_UID = b.User_id and a.SYSTEM_ID = b.System_id where a.SYSTEM_ID=? and a.STATUS='Active' order by a.INSERTED_DATETIME";

	public static final String UPDATE_VEHICAL_ENLISTING_DETAILS = "update dbo.ASSET_ENLISTING set APPLICATION_NO=?,DATE=?,INSURANACE_NO=?,INSURANACE_EXP_DATE=?,FITNESS_EXP_DATE=?,POLLUTION_EXP_DATE=?,OWNER_NAME=?,PERMANENT_ADD=?,TEMP_ADD=?,MOBILE_NO=?,GROSS_WEIGHT=?,UNLADEN_WEIGHT=?,RTO=?,PERMIT_NO=?,PERMIT_EXP_DATE=?,LOADING_CAPACITY=?,YEAR_OF_MANF=? where  SYSTEM_ID=? and ASSET_NUMBER=? and UID=?";

	public static final String UPDATE_VEHICAL_DELISTING_DETAILS = "update dbo.ASSET_ENLISTING set STATUS='Inactive',DELISTING_DATETIME=getUTCDate(),DELISTING_UID=? where ASSET_NUMBER=? and SYSTEM_ID=? and UID=? and MOBILE_NO=? and OWNER_NAME=?";

	public static final String SELECT_MAXUID = "select MAX(UID) as MAXUID from dbo.ASSET_ENLISTING where SYSTEM_ID=?";

	public static final String FETCH_CLIENTID_FOR_SENDING_SMS = "select Client_Id from dbo.General_Settings where name='SMS' and System_Id=?";

	public static final String FETCH_VALUE_FOR_SENDING_SMS = "select value from dbo.General_Settings where System_Id=? and name='ENLIST_CODE'";

	public static final String INSERT_SMS = "insert into SEND_SMS(PhoneNo,Message,Status,ClientId,SystemId,InsertedTime,VehicleNo,SchoolId,AlertTypeForSchool) values (?,?,?,?,?,getUTCDate(),?,?,?)";

	public static final String GET_DELISTING_DETAILS = "select a.APPLICATION_NO,a.ASSET_NUMBER,a.OWNER_NAME,a.PERMANENT_ADD,a.TEMP_ADD,a.MOBILE_NO,a.RTO,isnull(dateadd(mi,?,a.DELISTING_DATETIME),'') as DELISTING_DATETIME,isnull(b.Firstname+''+b.Lastname,'') as DELISTING_UID from dbo.ASSET_ENLISTING a left outer join Users b on a.DELISTING_UID = b.User_id and a.SYSTEM_ID = b.System_id where a.SYSTEM_ID=? and a.STATUS='Inactive'";

	public static final String GET_REVENUE_AND_PERMITS_PER_SANDBLOCK_ALL_GROUP = "select  UPPER(s.Port_Name) as Port_Name,isnull(UPPER(v.GROUP_NAME),'OTHER') as GROUP_NAME,SUM(a.TRIPSHEET_COUNT) as TRIPSHEET_COUNT,SUM(a.AMOUNT) as AMOUNT from dbo.SAND_TRIP_SHEET_COUNT a "
		+ "left outer join  dbo.Sand_Port_Details s on s.UniqueId=a.PORT_NO "
		+ "left outer join  dbo.VEHICLE_GROUP v on v.GROUP_ID=a.SUB_DIVISION and v.SYSTEM_ID=a.SYSTEM_ID "
		+ "where a.DATETIME between DATEADD(mi,-?,?) and DATEADD(mi,-?,?) and CUSTOMER_ID=? "
		+ "and a.SYSTEM_ID=? group by a.PORT_NO,a.SUB_DIVISION,s.Port_Name,v.GROUP_NAME ORDER BY v.GROUP_NAME desc ";

	public static final String GET_REVENUE_AND_PERMITS_PER_SANDBLOCK = "select  UPPER(s.Port_Name) as Port_Name,isnull(UPPER(v.GROUP_NAME),'OTHER') as GROUP_NAME,SUM(a.TRIPSHEET_COUNT) as TRIPSHEET_COUNT,SUM(a.AMOUNT) as AMOUNT from dbo.SAND_TRIP_SHEET_COUNT a "
		+ "left outer join  dbo.Sand_Port_Details s on s.UniqueId=a.PORT_NO "
		+ "left outer join  dbo.VEHICLE_GROUP v on v.GROUP_ID=a.SUB_DIVISION and v.SYSTEM_ID=a.SYSTEM_ID "
		+ "where a.DATETIME between DATEADD(mi,-?,?) and DATEADD(mi,-?,?) and SUB_DIVISION=? and CUSTOMER_ID=? "
		+ "and a.SYSTEM_ID=? group by a.PORT_NO,a.SUB_DIVISION,s.Port_Name,v.GROUP_NAME ORDER BY v.GROUP_NAME desc ";

	public static final String GET_YEARLY_REVENUE_AND_PERMITS_PER_SANDBLOCK_ALL_GROUP = "select PORT_NO,DATEPART(mm,DATEADD(mi,330,a.DATETIME)) AS Month,UPPER(s.Port_Name) as Port_Name,isnull(UPPER(v.GROUP_NAME),'OTHER') as GROUP_NAME,SUM(a.TRIPSHEET_COUNT) as TRIPSHEET_COUNT,SUM(a.AMOUNT) as AMOUNT "
		+ " from dbo.SAND_TRIP_SHEET_COUNT a "
		+ " left outer join  dbo.Sand_Port_Details s on s.UniqueId=a.PORT_NO "
		+ " left outer join  dbo.VEHICLE_GROUP v on v.GROUP_ID=a.SUB_DIVISION and v.SYSTEM_ID=a.SYSTEM_ID "
		+ " where a.DATETIME between DATEADD(mi,-?,?) and DATEADD(mi,-?,?) and CUSTOMER_ID=? "
		+ " and a.SYSTEM_ID=? group by PORT_NO,DATEPART(mm,DATEADD(mi,330,a.DATETIME)),a.SUB_DIVISION,s.Port_Name,v.GROUP_NAME "
		+ " ORDER BY v.GROUP_NAME desc";

	public static final String GET_YEARLY_REVENUE_AND_PERMITS_PER_SANDBLOCK = "select PORT_NO,DATEPART(mm,DATEADD(mi,330,a.DATETIME)) AS Month,UPPER(s.Port_Name) as Port_Name,isnull(UPPER(v.GROUP_NAME),'OTHER') as GROUP_NAME,SUM(a.TRIPSHEET_COUNT) as TRIPSHEET_COUNT,SUM(a.AMOUNT) as AMOUNT "
		+ " from dbo.SAND_TRIP_SHEET_COUNT a "
		+ " left outer join  dbo.Sand_Port_Details s on s.UniqueId=a.PORT_NO "
		+ " left outer join  dbo.VEHICLE_GROUP v on v.GROUP_ID=a.SUB_DIVISION and v.SYSTEM_ID=a.SYSTEM_ID "
		+ " where a.DATETIME between DATEADD(mi,-?,?) and DATEADD(mi,-?,?) and a.SUB_DIVISION=? and CUSTOMER_ID=? "
		+ " and a.SYSTEM_ID=? group by PORT_NO,DATEPART(mm,DATEADD(mi,330,a.DATETIME)),a.SUB_DIVISION,s.Port_Name,v.GROUP_NAME "
		+ " ORDER BY v.GROUP_NAME desc";

	public static final String GET_TOTAL_ASSET_COUNT_FOR_LTSP = "select count(*) as COUNT from gpsdata_history_latest a "
		+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
		+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
		+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=?";

	public static final String GET_TOTAL_ASSET_COUNT_FOR_CLIENT = "select count(*) as COUNT from gpsdata_history_latest a "
		+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
		+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
		+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=?";

	public static final String GET_COMMUNICATION_COUNT_FOR_LTSP = "select count(*) as COUNT from gpsdata_history_latest a "
		+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
		+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
		+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) < 6 ";

	public static final String GET_COMMUNICATION_COUNT_FOR_CLIENT = "select count(*) as COUNT from gpsdata_history_latest a "
		+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
		+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
		+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) < 6 ";

	public static final String GET_NON_COM_LESS_THAN_24HRS_COUNT_FOR_LTSP = "select count(*) as COUNT from gpsdata_history_latest a "
		+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
		+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
		+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=? and a.GMT > dateadd(hh,-24,getUTCDate()) "
		+ "and a.GMT < dateadd(hh,-6,getUTCDate()) and a.LOCATION <> 'No GPS Device Connected'";

	public static final String GET_NON_COM_LESS_THAN_24HRS_COUNT_FOR_CLIENT = "select count(*) as COUNT from gpsdata_history_latest a "
		+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
		+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
		+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=? and a.GMT > dateadd(hh,-24,getUTCDate()) "
		+ "and a.GMT < dateadd(hh,-6,getUTCDate()) and a.LOCATION <> 'No GPS Device Connected'";

	public static final String GET_NON_COM_GREATER_THAN_24HRS_COUNT_FOR_LTSP = "select count(*) as COUNT from gpsdata_history_latest a "
		+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
		+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
		+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=? and a.GMT < dateadd(hh,-24,getUTCDate()) and a.LOCATION <> 'No GPS Device Connected'";

	public static final String GET_NON_COM_GREATER_THAN_24HRS_COUNT_FOR_CLIENT = "select count(*) as COUNT from gpsdata_history_latest a "
		+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
		+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
		+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=? and a.GMT < dateadd(hh,-24,getUTCDate()) and a.LOCATION <> 'No GPS Device Connected'";

	public static final String GET_NO_GPS_COUNT_FOR_LTSP = "select count(*) as COUNT from gpsdata_history_latest a "
		+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
		+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
		+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=? and a.LOCATION = 'No GPS Device Connected'";

	public static final String GET_NO_GPS_COUNT_FOR_CLIENT = "select count(*) as COUNT from gpsdata_history_latest a "
		+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
		+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
		+ "where a.System_id = ? and a.CLIENTID = ? and b.User_id=? and a.LOCATION = 'No GPS Device Connected'";

	public static final String GET_ALERT_COUNT = "select count(*) as COUNT from Alert a "
		+ "left outer join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no "
		+ "where a.SYSTEM_ID = ? and a.CLIENTID = ? and b.User_id=? and between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate()";

	public static final String GET_SAND_PERMITS_COUNT = "select count(*) as COUNT from dbo.Sand_Mining_Trip_Sheet where System_Id = ? and Client_Id = ? and  Printed='Y' "
		+ "and Printed_Date between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate()";

	public static final String GET_ASSET_ARRIVAL_SAND_PORT_COUNT = "select count(*) as COUNT from dbo.HUB_REPORT where HUB_ID in (select Port_Hub from dbo.Sand_Port_Details where System_Id = ? and Client_Id = ?) and ACTUAL_ARRIVAL between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and SYSTEM_ID = ?";

	public static final String GET_MIN_PERMIT_DIVISION = "select top 1 Group_Id,Group_Name,count(*) as COUNT from dbo.Sand_Mining_Trip_Sheet where System_Id = ? and Client_Id = ? and Printed_Date between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() group by Group_Id,Group_Name order by COUNT";

	public static final String GET_MAX_PERMIT_DIVISION = "select top 1 Group_Id,Group_Name,count(*) as COUNT from dbo.Sand_Mining_Trip_Sheet where System_Id = ? and Client_Id = ? and Printed_Date between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() group by Group_Id,Group_Name order by COUNT desc";

	public static final String GET_REVENUE_FOR_DASHBOARD_CHART = "select DATEPART(dd,a.DATETIME) AS Day,SUM(a.AMOUNT) as AMOUNT from dbo.SAND_TRIP_SHEET_COUNT a "
		+ "left outer join  dbo.Sand_Port_Details s on s.UniqueId=a.PORT_NO "
		+ "left outer join  dbo.VEHICLE_GROUP v on v.GROUP_ID=a.SUB_DIVISION and v.SYSTEM_ID=a.SYSTEM_ID "
		+ "where a.DATETIME between dateadd(dd,datediff(dd,8,GETDATE()),0) and dateadd(dd,datediff(dd,1,GETDATE()),0) and CUSTOMER_ID=? "
		+ "and a.SYSTEM_ID=? group by DATEPART(dd,a.DATETIME) order by Day";

	public static final String GET_PERMIT_FOR_DASHBOARD_CHART = "select DATEPART(dd,dateadd(mi,330,a.DATETIME)) AS Day,SUM(a.TRIPSHEET_COUNT) as TRIPSHEET_COUNT from dbo.SAND_TRIP_SHEET_COUNT a "
		+ "left outer join  dbo.Sand_Port_Details s on s.UniqueId=a.PORT_NO "
		+ "left outer join  dbo.VEHICLE_GROUP v on v.GROUP_ID=a.SUB_DIVISION and v.SYSTEM_ID=a.SYSTEM_ID "
		+ "where a.DATETIME between dateadd(dd,datediff(dd,8,GETDATE()),0) and dateadd(dd,datediff(dd,1,GETDATE()),0) and CUSTOMER_ID=? "
		+ "and a.SYSTEM_ID=? group by DATEPART(dd,a.DATETIME),a.DATETIME order by Day";

	public static final String GET_DAILY_MONITORING_DETAILS = " select  ASSET_NUMBER," +
	" LIVE_STATUS = (case LIVE_STATUS when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end), " +
	" OVERSPEED_STATUS = (case OVERSPEED_STATUS when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end)," +
	" PARMIT_STATUS = (case PARMIT_STATUS when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end)," +
	" PORT_ENTRY_STATUS = (case PORT_ENTRY_STATUS when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end)," +
	" MULTIPLE_MDP = (case MULTIPLE_MDP when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end)," +
	" NEAR_TO_BORDER = (case NEAR_TO_BORDER when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end)," +
	" CROSS_BORDER = (case CROSS_BORDER when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end)," +
	" RESTRICTIVE_PORT_ENTRY = (case RESTRICTIVE_PORT_ENTRY when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end)," +
	" INSURENCE_STATUS = (case INSURENCE_STATUS when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end)," +
	" ASSET_FITNESS_STATUS = (case ASSET_FITNESS_STATUS when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end)," +
	" EMISSION_STATUS = (case EMISSION_STATUS when 1 then 'Red' when 2 then 'Green' when 3 then 'Yellow' else 'Green' end)" +
	" FROM OPERATIONAL_EXCEPTIONS WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND DATE = dateadd(mi,?,?) ";


	public static final String GET_STATE_LIST=" select isnull(StateID,'') as StateID,isnull(StateName,'') as StateName from Maple.dbo.tblState where CountryID=1 order by StateName";


	public static final String GET_DISTRICT_LIST="select isnull(DISTRICT_ID,'') as DISTRICT_ID,isnull(DISTRICT_NAME,'') as DISTRICT_NAME from AMS.dbo.DISTRICT_MASTER where STATE_ID=?;";


	public static final String GET_TALUKA_LIST="select isnull(TALUK_ID,'') as TALUK_ID,isnull(TALUK_NAME,'') as TALUK_NAME from AMS.dbo.TALUK_MASTER where DISTRICT_ID=? ";

	public static final String GET_GEO_FENCE_LIST1=" select isnull(HUBID,'') as HUBID,isnull(NAME,'') as NAME from AMS.dbo.LOCATION_ZONE_A a where CLIENTID=? and SYSTEMID=?"
		+ " and HUBID>0 and RADIUS<>0 and OPERATION_ID in (1,7) and HUBID "
		+ " not in(select ASSOCIATED_GEOFENCE from AMS.dbo.SAND_STOCKYARD_MASTER_TABLE where SYSTEM_ID=? and CUSTOMER_ID=?) ";
	public static final String GET_GEO_FENCE_LIST=" select isnull(HUBID,'') as HUBID,isnull(NAME,'') as NAME from AMS.dbo.LOCATION_ZONE_A a where CLIENTID=? and SYSTEMID=?"
		+ " and HUBID>0 and RADIUS<>0 and OPERATION_ID in (1,7) and HUBID "
		+ " not in(select isnull (Port_Hub,0) as Port_Hub from AMS.dbo.Sand_Port_Details where System_Id=? and Client_Id=?) ";

	public static final String INSERT_SAND_BLOCK_INFORMATION=" insert into AMS.dbo.Sand_Port_Details(Port_State,Port_District,SUB_DIVISION_ID,Port_Taluk,GRAM_PANCHAYAT,Port_Village, "
		+ " Port_Name,Port_No,Port_Survey_Number,SAND_BLOCK_ADDRESS,RIVER_NAME,ENVIRONMENTAL_CLEARANCE,SAND_BLOCK_TYPE,SAND_BLOCK_STATUS, "
		+ " ASSESSED_QUANTITY_METRIC,ASSESSED_QUANTITY,DIRECT_LOADING,Port_Hub,System_Id,Client_Id,CreatedBy,CreatedDate) "
		+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getUtcDate()) ";

	public static final String UPDATE_SAND_BLOCK_INFORMATION=" update AMS.dbo.Sand_Port_Details set Port_State=?,Port_District=?,SUB_DIVISION_ID=?,Port_Taluk=?,GRAM_PANCHAYAT=?,Port_Village=?, "
		+ " Port_Name=?,Port_No=?,Port_Survey_Number=?,SAND_BLOCK_ADDRESS=?,RIVER_NAME=?,ENVIRONMENTAL_CLEARANCE=?,SAND_BLOCK_TYPE=?,SAND_BLOCK_STATUS=?, " 
		+ " ASSESSED_QUANTITY_METRIC=?,ASSESSED_QUANTITY=?,DIRECT_LOADING=?,Port_Hub=?,UpdatedBy=?,UpdatedDate=getUtcdate() "
		+ " where System_Id=? and Client_Id=? and UniqueId=? ";

	public static final String GET_SAND_BLOCK_MANAGEMENT_DETAILS=" select isnull(a.Client_Id,'') as ClientId,isnull(b.STATE_NAME,'') as PortState,isnull(c.DISTRICT_NAME,'') as PortDistrict, "
		+ " isnull(e.GROUP_NAME,'') as SubDivision,isnull(a.Port_Taluk,'') as Taluka,isnull(a.GRAM_PANCHAYAT,'') as GramPanchayat, "
		+ " isnull(a.Port_Village,'') as Village,isnull(a.Port_Name,'') as SandBlockName,isnull(a.Port_No,'') as SandBlockNumber, "
		+ " isnull(a.Port_Survey_Number,'') as SurveyNo,isnull(a.SAND_BLOCK_ADDRESS,'') as SandBlockAddress,isnull(a.RIVER_NAME,'') as RiverName, "
		+ " isnull(a.ENVIRONMENTAL_CLEARANCE,'') as EnvironmentalClearence,isnull(a.SAND_BLOCK_TYPE,'') as SandBlockType, "
		+ " isnull(a.SAND_BLOCK_STATUS,'') as SandBlockStatus,isnull(a.ASSESSED_QUANTITY_METRIC,'') as AssessedQuantityMetrix, "
		+ " isnull(a.ASSESSED_QUANTITY,'') as AssessedQuantity,isnull(a.DIRECT_LOADING,'') as DirectLoading, "
		+ " isnull(d.NAME,'') as AssociatedGeoFence,isnull(a.UniqueId,'') as UniqueId,isnull(a.Port_State,'') as PortId,isnull(a.Port_District,'') as PortDistrictID, "
		+ " isnull(a.SUB_DIVISION_ID,'') as SubDivisionId,isnull(a.Port_Hub,'') as geoFenceId,temp.Total "
		+ " from AMS.dbo.Sand_Port_Details a "
		+ " left outer join ADMINISTRATOR.dbo.STATE_DETAILS b on a.Port_State=b.STATE_CODE "
		+ " left outer join AMS.dbo.DISTRICT_MASTER c on a.Port_District=c.DISTRICT_ID "
		+ " left outer join AMS.dbo.LOCATION_ZONE_A d on a.Port_Hub=d.HUBID "
		+ " left outer join ADMINISTRATOR.dbo.ASSET_GROUP e on a.SUB_DIVISION_ID=e.GROUP_ID and a.Client_Id=e.CUSTOMER_ID and a.System_Id=e.SYSTEM_ID "
		+ " left outer join (select From_Place,isnull(sum(TotalQuantity),0 ) as Total from "
        + " (select From_Place,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000)  + 'X')-1) AS decimal (18,2))) as TotalQuantity "
        + " from AMS.dbo.Sand_Mining_Trip_Sheet_History "
        + " where System_Id=? and Client_Id=? and Printed='Y'  group by From_Place "
        + " union all "
        + " select From_Place,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000)  + 'X')-1) AS decimal (18,2))) as TotalQuantity "
        + " from AMS.dbo.Sand_Mining_Trip_Sheet "
        + " where System_Id=? and Client_Id=? and Printed='Y' group by From_Place  ) sm group by From_Place) temp on temp.From_Place=a.Port_Name "
        + " where a.System_Id=? and a.Client_Id=? ";

	public static final String INSERT_CONTRACTOR_INFORMATION= "insert into AMS.dbo.SAND_CONTRACTOR_MASTER(STATE_ID,DISTRICT_ID,SUB_DIVISION,TALUKA,VILLAGE,GRAM_PANCHAYAT,CONTRACTOR_NAME,CONTRACT_NO,CONTRACT_START_DATE,CONTRACT_END_DATE,CONTRACTOR_STATUS,CONTRACT_ADDRESS,SAND_BLOCK,SAND_EXCAVATION_LIMIT,SYSTEM_ID,CUSTOMER_ID,CREATED_BY,CREATED_DATE)"
		+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getUtcDate())";

	public static final String UPDATE_CONTRACTOR_INFORMATION=  "update AMS.dbo.SAND_CONTRACTOR_MASTER set STATE_ID=?,DISTRICT_ID=?,SUB_DIVISION=?,TALUKA=?,VILLAGE=?, "
		+  "GRAM_PANCHAYAT=?,CONTRACTOR_NAME=?,CONTRACT_NO=?,CONTRACT_START_DATE=?,CONTRACT_END_DATE=?,CONTRACTOR_STATUS=?,CONTRACT_ADDRESS=?,SAND_BLOCK=?,SAND_EXCAVATION_LIMIT=?,UPDATED_BY=?,UPDATED_DATE=getUtcDate() where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=?";

	public static final String GET_CONTRACTOR_REPORT=	"select isnull(a.STATE_ID,'') as StateID1,isnull(a.DISTRICT_ID,'') as DistrictId1,isnull(a.UNIQUE_ID,'') as UNIQUEID, isnull(b.STATE_NAME,'') as STATEID ,isnull(c.DISTRICT_NAME,'') as DISTRICTID,isnull(e.GROUP_NAME,'') as SUBDIVISION,isnull(a.SUB_DIVISION,'') as SUBDIVISIONID,isnull(a.TALUKA,'') as TALUKA,isnull(a.VILLAGE,'') AS VILLAGE, " +
	"isnull(a.GRAM_PANCHAYAT,'') AS GRAMPANCHAYAT,isnull(a.CONTRACTOR_NAME,'') as CONTRACTORNAME,isnull(a.CONTRACT_NO,'') AS CONTRACTNO, " +
	"isnull(a.CONTRACT_START_DATE,'') AS CONTRACTSTARTDATE,isnull(a.CONTRACT_END_DATE,'') AS CONTRACTENDDATE,isnull(a.CONTRACTOR_STATUS,'') AS CONTRACTORSTATUS,isnull(a.CONTRACT_ADDRESS,'') AS CONTRACTADDRESS,isnull(a.SAND_BLOCK,'') as SANDBLOCKID,isnull(Port_Name,'') as SANDBLOCKNAME, isnull(a.SAND_EXCAVATION_LIMIT,0) as SANDEXCAVATIONLIMIT "+
	"from AMS.dbo.SAND_CONTRACTOR_MASTER a inner join ADMINISTRATOR.dbo.STATE_DETAILS b on a.STATE_ID=b.STATE_CODE "+
	"inner join AMS.dbo.DISTRICT_MASTER c on a.DISTRICT_ID=c.DISTRICT_ID and a.STATE_ID=c.STATE_ID " +
	"left outer join AMS.dbo.Sand_Port_Details d on a.SAND_BLOCK=d.UniqueId and a.SYSTEM_ID=d.System_Id and a.CUSTOMER_ID=d.Client_Id " +
	"left outer join ADMINISTRATOR.dbo.ASSET_GROUP e on a.SUB_DIVISION=e.GROUP_ID and a.CUSTOMER_ID=e.CUSTOMER_ID and a.SYSTEM_ID=e.SYSTEM_ID "+
	"where a.SYSTEM_ID=? and a.CUSTOMER_ID=? ";


	public static final String GET_SAND_BLOCKS=" select isnull(Port_Name,'') as associatedSandBlocks,isnull(Port_No,'') as portNumber from AMS.dbo.Sand_Port_Details where System_Id=?" 
		+ " and Client_Id=? and ENVIRONMENTAL_CLEARANCE=? and SAND_BLOCK_STATUS=? and DIRECT_LOADING=? ";

	public static final String GET_ASSGN_CONTRACTOR="select isnull(CONTRACTOR_NAME,'') as assignedContractor  from AMS.dbo.SAND_CONTRACTOR_MASTER"
		+ " where SYSTEM_ID=? and CUSTOMER_ID=? and CONTRACTOR_STATUS='Active'";

	public static final String INSERT_DIVISION_INFORMATION="insert into AMS.dbo.SAND_STOCKYARD_MASTER_TABLE(STATE_ID,DISTRICT_ID,SUB_DIVISION_ID,TALUKA,GRAM_PANCHAYAT,VILLAGE,"+
	"SAND_STOCKYARD_NAME,SAND_STOCKYARD_ADDRESS,RIVER_NAME,CAPACITY_OF_STOCKYARD,CAPACITY_METRIC,ASSOCIATED_GEOFENCE,"+
	"ASSOCIATED_SAND_BLOCKS,ESTIMATED_SAND_QUANTITY_AVAILABLE,RATE_METRIC,RATE,ASSIGNED_CONTRACTOR,SYSTEM_ID,CUSTOMER_ID,"+
	"CREATED_BY,CREATED_DATE) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate())";

	public static final String UPDATE_DIVISION_INFORMATION="update AMS.dbo.SAND_STOCKYARD_MASTER_TABLE set STATE_ID = ?,DISTRICT_ID = ?,SUB_DIVISION_ID = ?,TALUKA = ?,"+
	"GRAM_PANCHAYAT = ?,VILLAGE = ?,SAND_STOCKYARD_NAME = ?,SAND_STOCKYARD_ADDRESS = ?,RIVER_NAME = ?,"+
	"CAPACITY_OF_STOCKYARD = ?,CAPACITY_METRIC = ?,ASSOCIATED_GEOFENCE = ?,ASSOCIATED_SAND_BLOCKS = ?,"+
	"ESTIMATED_SAND_QUANTITY_AVAILABLE = ?,RATE_METRIC = ?,RATE = ?,ASSIGNED_CONTRACTOR = ?,UPDATED_BY = ?,UPDATED_DATE = getutcdate() "+
	"where SYSTEM_ID = ? and CUSTOMER_ID = ? and UNIQUE_ID=?";

	public static final String GET_DIVISION_MASTER_REPORT="select isnull(f.REMARKS,'') AS REMARKS,a.UNIQUE_ID as uniqueId,isnull(b.STATE_NAME,'') as StateName,isnull(c.DISTRICT_NAME,'') as DistrictName,isnull(d.GROUP_NAME,'') as GroupName,"+
	"isnull(a.TALUKA,'') as Taluka,isnull(a.STATE_ID,'') as StateId,isnull(a.DISTRICT_ID,'') as DistrictId,isnull(a.SUB_DIVISION_ID,'') as groupId,isnull(a.ASSOCIATED_GEOFENCE,'') as geofenceId,isnull(a.GRAM_PANCHAYAT,'') as GramPanchayat,isnull(a.VILLAGE,'') as Village,"+
	"isnull(a.SAND_STOCKYARD_NAME,'') as SandStockYardName,isnull(a.SAND_STOCKYARD_ADDRESS,'') as SandStockYardAddress,"+
	"isnull(a.RIVER_NAME,'') as RiverName,a.CAPACITY_OF_STOCKYARD as capacityOfStockyard,"+
	"isnull(a.CAPACITY_METRIC,'') as capacityMetric,isnull(e.NAME,'') as associatedGeofence,"+
	"isnull(a.ASSOCIATED_SAND_BLOCKS,'') as associatedSandBlocks,isnull(a.ESTIMATED_SAND_QUANTITY_AVAILABLE,'') as estimatedSandQuantity,"+
	"isnull(a.RATE_METRIC,'') as rateMetric,isnull(a.RATE,'') as rate,isnull(a.ASSIGNED_CONTRACTOR,'') as assignedContractor,isnull(f.QUANTITY,0) as SeizedQuantity "+
	"from AMS.dbo.SAND_STOCKYARD_MASTER_TABLE a "+
	"inner join ADMINISTRATOR.dbo.STATE_DETAILS b on a.STATE_ID=b.STATE_CODE "+ 
	"inner join AMS.dbo.DISTRICT_MASTER c on a.DISTRICT_ID=c.DISTRICT_ID "+
	"inner join ADMINISTRATOR.dbo.ASSET_GROUP d on a.SUB_DIVISION_ID=d.GROUP_ID and a.SYSTEM_ID= d.SYSTEM_ID and a.CUSTOMER_ID=d.CUSTOMER_ID "+
	"inner join AMS.dbo.LOCATION_ZONE_A e on a.ASSOCIATED_GEOFENCE=e.HUBID and a.SYSTEM_ID= e.SYSTEMID and  a.CUSTOMER_ID=e.CLIENTID "+
	"left outer join AMS.dbo.SEIZED_SAND_DETAILS f on a.UNIQUE_ID=f.STOCKYARD_ID AND a.SYSTEM_ID= f.SYSTEM_ID and  a.CUSTOMER_ID=f.CUSTOMER_ID  "+
	"where a.SYSTEM_ID=? and a.CUSTOMER_ID=?";

	public static final String GET_ASSOCIATED_HUBS_NEW = "select NAME,HUBID from LOCATION where HUBID in (select HubId from UserHubAssociation where UserId = ? and SystemId = ? and ClientId=?)";
	
	public static final String SELECT_REGISTRATION_NO_FROM_USER_VEHICLE = "select distinct Registration_no from Vehicle_User a inner join dbo.VEHICLE_CLIENT b on a.Registration_no=b.REGISTRATION_NUMBER where b.CLIENT_ID=? and b.SYSTEM_ID=?";
	
	public static final String GET_HUB_NAMES_FOR_CLIENT = "select HUBID,NAME from LOCATION where SYSTEMID=? and CLIENTID=? and RADIUS<>0 order by NAME";
	
	public static final String GET_CONTRACTORS="select UNIQUE_ID,CONTRACTOR_NAME from AMS.dbo.SAND_CONTRACTOR_MASTER where SYSTEM_ID=? AND CUSTOMER_ID=? and CONTRACTOR_STATUS='Active'";
	
	public static final String GET_NON_ASSOCIATION_DATA= " select VehicleNo from AMS.dbo.tblVehicleMaster a left outer join AMS.dbo.VEHICLE_CLIENT b on VehicleNo=REGISTRATION_NUMBER left outer join AMS.dbo.Vehicle_User c on VehicleNo=Registration_no "+
    "where a.System_id=? and b.CLIENT_ID=? and User_id=? and Status='Active' and a.LoadingCapacity <> 0 and NULLIF(a.OwnerName, '') IS NOT NULL and a.VehicleNo not in (select REGISTRATION_NO from AMS.dbo.CONTRACTOR_VEHICLE_ASSOCIATION where CUSTOMER_ID=? and SYSTEM_ID=? and CONTRACTOR_ID=?)";
	
	public static final String GET_ASSOCIATION_DATA= "select REGISTRATION_NO from  AMS.dbo.CONTRACTOR_VEHICLE_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? and CONTRACTOR_ID=? ";
	
	public static final String INSERT_INTO_CONTRACTOR_VEHICLE_ASSOCIATION= "insert into AMS.dbo.CONTRACTOR_VEHICLE_ASSOCIATION(SYSTEM_ID,CUSTOMER_ID,CONTRACTOR_ID,REGISTRATION_NO,ASSOCIATED_TIME,ASSOCIATED_BY) "+
    "values (?,?,?,?,getutcdate(),?)";
	
	public static final String SELECT_DATA_FROM_CONTRACTOR_VEHICLE_ASSOCIATION= "select * from dbo.CONTRACTOR_VEHICLE_ASSOCIATION where CONTRACTOR_ID=? and REGISTRATION_NO=? ";
	
	public static final String MOVE_DATA_TO_CONTRACTOR_VEHICLE_ASSOCIATION_HISTORY= "insert into AMS.dbo.CONTRACTOR_VEHICLE_ASSOCIATION_HISTORY(SYSTEM_ID,CUSTOMER_ID,CONTRACTOR_ID,REGISTRATION_NO,ASSOCIATED_TIME,ASSOCIATED_BY,DISASSOCIATED_BY,DISASSOCIATED_TIME) "+
	"values(?,?,?,?,?,?,?,getutcdate())";
	
	public static final String DELETE_FROM_CONTRACTOR_VEHICLE_ASSOCIATION= "delete from AMS.dbo.CONTRACTOR_VEHICLE_ASSOCIATION where CONTRACTOR_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? and  REGISTRATION_NO=? ";
	
	public static final String GET_SAND_BLOCKS_FOR_CONTRACTOR=" select isnull(Port_Name,'') as associatedSandBlocks,UniqueId as portNumber from AMS.dbo.Sand_Port_Details where System_Id=?" 
		+ " and Client_Id=? and ENVIRONMENTAL_CLEARANCE=? and SAND_BLOCK_STATUS=? and DIRECT_LOADING=? ";
	
   
	public static final String GET_CONTRACTOR_NO="select CONTRACT_NO from dbo.SAND_CONTRACTOR_MASTER where SYSTEM_ID=? and  CUSTOMER_ID=?  and UNIQUE_ID=?";
	
	public static final String GET_SANDBLOCKS_FROM="select  Port_Name,UniqueId from Sand_Port_Details a "+
"inner join dbo.SAND_CONTRACTOR_MASTER b on b.SYSTEM_ID=a.System_Id and b.CUSTOMER_ID=a.Client_Id and b.SAND_BLOCK=a.UniqueId "+
"where System_Id=? and Client_Id=?  and b.UNIQUE_ID=? ";

	public static final String GET_STOCKYARDS_TO="select UNIQUE_ID,SAND_STOCKYARD_NAME,isnull(ESTIMATED_SAND_QUANTITY_AVAILABLE,0) as ESTIMATED_SAND_QUANTITY_AVAILABLE,isnull(RATE,0) as RATE, isnull(VILLAGE,'') as VILLAGE ,isnull(TALUKA,'') as TALUKA,l.LATITUDE,l.LONGITUDE  "+ 
												"from dbo.SAND_STOCKYARD_MASTER_TABLE s inner join AMS.dbo.LOCATION_ZONE_A l on l.HUBID=s.ASSOCIATED_GEOFENCE and l.SYSTEMID=s.SYSTEM_ID and s.CUSTOMER_ID=l.CLIENTID WHERE SYSTEM_ID=? AND CUSTOMER_ID=?";

	public static final String GET_VEHICLE_NOS="select REGISTRATION_NO from  dbo.CONTRACTOR_VEHICLE_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? and CONTRACTOR_ID=? " ;

	public static final String CHECK_ASSESSED_QUANTITY="select isnull(ASSESSED_QUANTITY,0) as ASSESSED_QUANTITY from Sand_Port_Details WHERE  System_Id=? and Client_Id=? and UniqueId=?";

	public static final String UPDATE_ASSESSED_QUANTITY="UPDATE Sand_Port_Details SET ASSESSED_QUANTITY=ASSESSED_QUANTITY-? WHERE System_Id=? and Client_Id=? and UniqueId=? ";
	
	public static final String CHECK_CAPACITY_STOCKYARD="select isnull(ESTIMATED_SAND_QUANTITY_AVAILABLE,0) as ESTIMATED_SAND_QUANTITY_AVAILABLE ,isnull (CAPACITY_OF_STOCKYARD,0) as CAPACITY_OF_STOCKYARD   FROM dbo.SAND_STOCKYARD_MASTER_TABLE wHERE UNIQUE_ID=? AND SYSTEM_ID=? AND CUSTOMER_ID=?";
	
	public static final String UPDATE_AVAILABLE_QUANTITY_STOCKYARD="UPDATE dbo.SAND_STOCKYARD_MASTER_TABLE SET ESTIMATED_SAND_QUANTITY_AVAILABLE=ESTIMATED_SAND_QUANTITY_AVAILABLE+? wHERE UNIQUE_ID=? AND SYSTEM_ID=? AND CUSTOMER_ID=?";
	
	public static final String GET_VEHICLE_CAPACITY="select isnull (LoadingCapacity,0) as LoadingCapacity from tblVehicleMaster where System_id=? and VehicleNo=? ";
	
	public static final String INSERT_SAND_PERMIT_DETAILS="insert into SAND_INWARD_TRIP_SHEET ( PERMIT_NO,PERMIT_DATE, CONTRACTOR_ID,CONTRACT_NO,VEHICLE_NO,QUANTITY,SAND_BLOCK_ID,STOCKYARD_ID, "+
	"VALID_FROM,VALID_TO,PROCESSING_FEES,SYSTEM_ID,CUSTOMER_ID,PRINTED,CREATED_BY) "+ 
	"VALUES (?,getDate(),?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	
	public static final String CHECK_EXCAVATION_LIMIT="select  isnull (SAND_EXCAVATION_LIMIT,0) as SAND_EXCAVATION_LIMIT from dbo.SAND_CONTRACTOR_MASTER where UNIQUE_ID=? AND SYSTEM_ID=? AND CUSTOMER_ID=? AND SAND_BLOCK=? ";
	
	public static final String UPDATE_EXCAVATION_LIMIT = "UPDATE dbo.SAND_CONTRACTOR_MASTER SET SAND_EXCAVATION_LIMIT=SAND_EXCAVATION_LIMIT-? WHERE UNIQUE_ID=? AND SYSTEM_ID=? AND CUSTOMER_ID=? AND SAND_BLOCK=? ";
	
	public static final String UPDATE_PERMIT_DETAILS="";
	
	public static final String GET_PERMIT_DETAILS="SELECT a.PERMIT_ID,isnull(d.CONTRACTOR_NAME,'') as CONTRACTOR_ID, isnull (c.SAND_STOCKYARD_NAME,'') as STOCKYARD_ID, "+ 
"isnull (b.Port_Name,'') as SAND_BLOCK_ID,a.PERMIT_NO,a.CONTRACT_NO,a.VEHICLE_NO,a.QUANTITY, "+
"isnull (a.VALID_FROM,'') as VALID_FROM ,isnull (a.VALID_TO,'') as VALID_TO,ISNULL(PROCESSING_FEES,0) AS PROCESSING_FEES FROM AMS.dbo.SAND_INWARD_TRIP_SHEET a  "+
"left outer join AMS.dbo.Sand_Port_Details b on b.UniqueId=a.SAND_BLOCK_ID "+
"left outer join AMS.dbo.SAND_STOCKYARD_MASTER_TABLE c on c.UNIQUE_ID=a.STOCKYARD_ID "+
"left outer join AMS.dbo.SAND_CONTRACTOR_MASTER d on d.UNIQUE_ID=a.CONTRACTOR_ID "+
"where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? AND a.PRINTED='N' ORDER BY a.PERMIT_DATE desc  ";
	
	public static final String GET_PERMIT_NO="SELECT TOP 1 PERMIT_NO FROM AMS.dbo.SAND_INWARD_TRIP_SHEET WHERE SYSTEM_ID=? AND CUSTOMER_ID=? ORDER BY PERMIT_DATE DESC ";
	
	public static final String GET_DISTRICT_LIST_FOR_CONSUMERS ="select isnull(DISTRICT_ID,'') as DISTRICT_ID,isnull(DISTRICT_NAME,'') as DISTRICT_NAME from AMS.dbo.DISTRICT_MASTER where STATE_ID=75";

	public static final String INSERT_CONSUMER_INFORMATION = "insert into dbo.SAND_CONSUMER_ENROLMENT (CUSTOMER_ID, CONSUMER_TYPE,DISTRICT_ID,TALUKA_ID,VILLAGE,ADDRESS,MOBILE_NUMBER,EMAIL_ID,IDENTITY_PROOF_TYPE,IDENTITY_PROOF_NO, " +
    "SAND_CONSUMER_NAME,CONTRACTOR_NAME,PROJECT_NAME,PROJECT_START_DATE,PROJECT_END_DATE,GOVERNMENT_DEPT_NAME,DEPT_CONTACT_NAME,WORK_DISTRICT_ID,WORK_TALUKA_ID,WORK_VILLAGE,WORK_ADDRESS,WORK_LOCATION,HOUSING_APPROVAL_AUTHORITY, " +
    "HOUSING_APPROVAL_PLAN_NUMBER,PROJECT_APPROVAL_AUTHORITY,PROJECT_APPROVAL_PLAN_NUMBER,TOTAL_BUILTUP_AREA,NO_OF_BUILDINGS,ESTIMATED_SAND_REQUIREMENT,APPROVED_SAND_QUNATITY,SYSTEM_ID,CREATED_BY,CONSUMER_APPLICATION_NO,LATITUDE,LONGITUDE,BALANCE_SAND_QUANTITY,FROM_DISTRICT,FROM_TALUKA,TP_NO,CONSUMER_STATUS,ACTION_TAKEN_BY,ACTION_TAKEN_DATETIME,TP_ID,CHECK_POST,ADHAR_NO,PAN,CON_STATUS,OTP) "+
    "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,?,?,?,'Active',?)";

	public static final String SELECT_MAX_ID = "select ISNULL (MAX(UNIQUE_ID),0) as MAXUID from dbo.SAND_CONSUMER_ENROLMENT where SYSTEM_ID=?";
    
	public static final String GET_CONSUMER_REPORT = "select CONSUMER_TYPE,CONSUMER_APPLICATION_NO,isnull(b.DISTRICT_NAME,'') as DISTRICTID,isnull(c.TALUK_NAME,'')as TALUKID,isnull(VILLAGE,'') as VILLAGE,MOBILE_NUMBER,isnull(EMAIL_ID,'') as EMAIL_ID,isnull(ADDRESS,'') as ADDRESS, " +
    "isnull(SAND_CONSUMER_NAME,'') as SAND_CONSUMER_NAME,isnull (CONTRACTOR_NAME,'') as CONTRACTOR_NAME,isnull (PROJECT_NAME,'') as PROJECT_NAME,isnull (PROJECT_START_DATE,'') as PROJECT_START_DATE,isnull (PROJECT_END_DATE,'') as PROJECT_END_DATE,isnull (GOVERNMENT_DEPT_NAME,'') as GOVERNMENT_DEPT_NAME,isnull (DEPT_CONTACT_NAME,'') as DEPT_CONTACT_NAME, " +
    "WORK_LOCATION,isnull(HOUSING_APPROVAL_AUTHORITY,'') as HOUSING_APPROVAL_AUTHORITY,isnull(HOUSING_APPROVAL_PLAN_NUMBER,'') as HOUSING_APPROVAL_PLAN_NUMBER,isnull(PROJECT_APPROVAL_AUTHORITY,'') as PROJECT_APPROVAL_AUTHORITY,isnull(PROJECT_APPROVAL_PLAN_NUMBER,'') as PROJECT_APPROVAL_PLAN_NUMBER, " +
    "isnull(TOTAL_BUILTUP_AREA,0) as TOTAL_BUILTUP_AREA,NO_OF_BUILDINGS,ESTIMATED_SAND_REQUIREMENT,APPROVED_SAND_QUNATITY, isnull (BALANCE_SAND_QUANTITY,0) as BALANCE_SAND_QUANTITY,  isnull(dateadd(hh,5.5,CREATED_DATE),'') as CREATED_DATE,ADHAR_NO , isnull(CON_STATUS,'') as STATUS,isnull(CONSUMER_STATUS,'') as CONSUMER_STATUS, " +
    "isnull(IDENTITY_PROOF_TYPE,'') as IDENTITY_PROOF_TYPE,isnull(IDENTITY_PROOF_NO,'') as IDENTITY_PROOF_NO  from dbo.SAND_CONSUMER_ENROLMENT a left outer join  AMS.dbo.DISTRICT_MASTER b on a.DISTRICT_ID=b.DISTRICT_ID "+
    "left outer join AMS.dbo.TALUK_MASTER c on a.TALUKA_ID=c.TALUK_ID where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? and CREATED_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) order by CREATED_DATE" ;

	public static final String UPDATE_SMS ="INSERT INTO dbo.SEND_SMS(PhoneNo,Message,Status,ClientId,SystemId,InsertedTime) values (?,?,?,?,?,getUTCDate())";
	
   public static final String GET_BANK_NAMES="select ID,BANK_NAME,BANK_CODE  from AMS.dbo.SAND_BANK_MASTER";
	
	public static final String GET_BANK_CODE=" select  BANK_CODE  from AMS.dbo.SAND_BANK_MASTER where ID=? ";
	
	public static final String INSERT_CREDIT_DETAILS="INSERT INTO AMS.dbo.SAND_CONSUMER_CREDIT_MASTER "+
	"(CONSUMER_APPLICATION_NO,CONSUMER_NAME,APPROVED_SAND_QUANTITY,DD_NO,DD_AMOUNT,DD_DATE,BANK_ID,BRANCH_NAME,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,BALANCE_AMOUNT,CREATED_DATE,TP_ID,TP_NO) "+
	"values (?,?,?,?,?,?,?,?,?,?,?,?,getdate(),?,?) ";
	
	public static final String GET_APPLICATION_NOS="SELECT CONSUMER_APPLICATION_NO,APPROVED_SAND_QUNATITY,ISNULL (SAND_CONSUMER_NAME,'') AS SAND_CONSUMER_NAME , isnull (CONTRACTOR_NAME,'') as CONTRACTOR_NAME, isnull (GOVERNMENT_DEPT_NAME,'') as GOVERNMENT_DEPT_NAME,isnull(MOBILE_NUMBER,'') as MOBILE_NUMBER FROM AMS.dbo.SAND_CONSUMER_ENROLMENT where SYSTEM_ID=? AND CUSTOMER_ID= ?  and CON_STATUS='Active' and CONSUMER_STATUS='approved'  ";
	
	public static final String GET_CREDIT_DETAILS="SELECT  a.CONSUMER_APPLICATION_NO,a.CONSUMER_NAME,a.APPROVED_SAND_QUANTITY,a.DD_NO,a.DD_AMOUNT,a.DD_DATE,b.BANK_NAME,a.BALANCE_AMOUNT, "+
   "isnull (a.BRANCH_NAME,'') as BRANCH_NAME,CREATED_DATE FROM AMS.dbo.SAND_CONSUMER_CREDIT_MASTER a "+ 
    "left outer join AMS.dbo.SAND_BANK_MASTER b on b.ID=a.BANK_ID where a.CUSTOMER_ID=? AND a.SYSTEM_ID=? and a.CREATED_DATE between ? and ? order by CREATED_DATE desc"; 
	
	public static final String CHECK_DUPLICATE_DD_NO ="select * from AMS.dbo.SAND_CONSUMER_CREDIT_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and DD_NO=? ";
	
	public static final String CHECK_APPLICATION_NO="SELECT CONSUMER_APPLICATION_NO,isnull (BALANCE_AMOUNT,0) as BALANCE_AMOUNT FROM AMS.dbo.SAND_CONSUMER_CREDIT_MASTER WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND CONSUMER_APPLICATION_NO=? and INSERTED_BY=?  order by CREATED_DATE desc ";

	public static final String GET_VEHICLE_NO_SYS_LEASE_OWNER_FOR_MDP_GENERATOR=" select a.VehicleNo,isNull(a.Model,'') as Model,isNull(a.OwnerName,'') as OwnerName,isNull(a.OwnerAddress,'') as OwnerAddress from dbo.tblVehicleMaster a "
		//+ " inner join dbo.ASSET_ENLISTING c on c.ASSET_NUMBER=a.VehicleNo  and c.SYSTEM_ID=? "
		+ " left outer join dbo.gpsdata_history_latest g on g.REGISTRATION_NO=a.VehicleNo where a.Status='Active' and VehicleNo in (select REGISTRATION_NUMBER as VehicleNo "
		+ " from VEHICLE_CLIENT vc, Vehicle_User vu where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and  "
		+ " vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no ) order by VehicleNo ";
	
	public static final String GET_VEHICLE_NO_LEASE_OWNER_FOR_MDP_GENERATOR=" select a.VehicleNo,isNull(a.Model,'') as Model,isNull(a.OwnerName,'') as OwnerName,isNull(a.OwnerAddress,'') as OwnerAddress from dbo.tblVehicleMaster a "
		//+ " inner join dbo.ASSET_ENLISTING c on c.ASSET_NUMBER=a.VehicleNo  and c.SYSTEM_ID=? "
		+ " left outer join dbo.gpsdata_history_latest g on g.REGISTRATION_NO=a.VehicleNo where a.Status='Active'and g.LOCATION !='No GPS Device Connected'  and VehicleNo in (select REGISTRATION_NUMBER as VehicleNo "
		+ " from VEHICLE_CLIENT vc, Vehicle_User vu where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and  "
		+ " vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no ) order by VehicleNo ";
	
	public static final String GET_VEHICLE_NO_FOR_MDP_GENERATOR=" select a.VehicleNo,isNull(a.Model,'') as Model,isNull(a.OwnerName,'') as OwnerName,isNull(a.OwnerAddress,'') as OwnerAddress "
		+ " from dbo.tblVehicleMaster a " 
		//+ " inner join dbo.ASSET_ENLISTING c on c.ASSET_NUMBER=a.VehicleNo  and c.SYSTEM_ID=? "
		+ " left outer join dbo.gpsdata_history_latest g on g.REGISTRATION_NO=a.VehicleNo  "
		+ " where a.System_id=? and a.OwnerName=? and  a.Status='Active' and g.LOCATION !='No GPS Device Connected' ";
	
	public static final String GET_FROM_SAND_PORT="SELECT Port_No,Port_Name,Port_Village,Port_Taluk,Port_Survey_Number,System_Id,Client_Id,UniqueId,isnull(ASSESSED_QUANTITY,0) as ASSESSED_QUANTITY " +
		" ,l.LATITUDE,l.LONGITUDE  FROM Sand_Port_Details s " +
		"inner join AMS.dbo.LOCATION_ZONE_A l on l.HUBID=s.Port_Hub and l.SYSTEMID=s.System_Id and s.Client_Id=l.CLIENTID WHERE System_Id=? and Client_Id=? and ENVIRONMENTAL_CLEARANCE='Cleared' and SAND_BLOCK_STATUS='Active' and DIRECT_LOADING='Yes' " +
		" and Port_Name COLLATE DATABASE_DEFAULT in (select Port_Name from Sand_Mining_Default_Setting where System_Id=?)" +
		"order by Port_Name";
	
	public static final String GET_DISTINCT_TO_PLACE="select distinct Replace(upper(To_Palce),' ','') as To_Palce  from dbo.Sand_Mining_Trip_Sheet where System_Id=? and Client_Id=? order by To_Palce ";
	
	public static final String GET_MDP_GENERATOR_DETAILS="SELECT TS_ID, isnull(Trip_Sheet_No,'') as Trip_Sheet_No, dateadd(mi,?,isnull(Date_TS,'')) as Date_TS, isnull(Permit_No,'') as Permit_No, isnull(Lessee_Name,'') "
		+ "as Lessee_Name,isnull(CUSTOMER_NAME,'') as Customer_Name,isnull(Lessee_Type,'') as Lessee_Type, isnull(Mineral_Type,'') as Mineral_Type, isnull(Survey_No,'') as Survey_No, "
		+ " isnull(Village,'') as Village, isnull(Taluk,'') as Taluk, isnull(Quantity,'') as Quantity, isnull(Royalty,0) as Royalty, isnull(Vehicle_No,'') as Vehicle_No, isnull(Total_Fee,0) as Total_Fee,isnull(Printed,'') as Printed, "
		+ "isnull(From_Place,'') as From_Place,isnull(Via_Route,'') as Via_Route,isnull(To_Palce,'') as To_Palce, dateadd(mi,?,isNull(From_Date,'')) as From_Date, dateadd(mi,?,isnull(To_Date,'')) as To_Date, isnull(MiNo,'') as MiNo, isnull(Processing_Fee,0) as Processing_Fee, isnull(District,'')"
		+ " as District,isnull(Vehicle_Addr,'') as Vehicle_Addr,isNull(Validity_Period,'') as Validity_Period, isNULL(Port_No,'') as Port_No,isNULL(Loading_Type,'') as Loading_Type,isNULL(DD_No,'') as DD_No,isNULL(Bank_Name,'')"
		+ " as Bank_Name,dateadd(mi,?,isNULL(DD_Date,'')) as  DD_Date,isNULL(Group_Id,'') as  Group_Id,isNULL(Group_Name,'') as  Group_Name,isNULL(Index_No,'') as  Index_No,isNULL(Driver_Name,'') as  Driver_Name,isnull(PORT_ID,'') as PORT_ID ,isnull(Sand_Loading_From_Time,'')as Sand_Loading_From_Time,isnull(Sand_Loading_To_Time,'')as Sand_Loading_To_Time,isNull(CONSUMER_APPLICATION_NO,'') as CONSUMER_APPLICATION_NO,"
		+ " isnull(SAND_EXTRACTION_FROM,'') as SAND_EXTRACTION_FROM , isnull(DISTANCE,'0') as DISTANCE FROM Sand_Mining_Trip_Sheet WHERE (System_Id = ?) and Client_Id=? and Printed='N' and User_Id=? and isnull(CROSS_PLATFORM,'N')<>'Y' "
		+ " union "
		+ " SELECT TS_ID, isnull(Trip_Sheet_No,'') as Trip_Sheet_No, dateadd(mi,?,isnull(Date_TS,'')) as Date_TS, isnull(Permit_No,'') as Permit_No, isnull(Lessee_Name,'') "
		+ " as Lessee_Name,isnull(CUSTOMER_NAME,'') as Customer_Name,isnull(Lessee_Type,'') as Lessee_Type, isnull(Mineral_Type,'') as Mineral_Type, isnull(Survey_No,'') as Survey_No, "
		+ " isnull(Village,'') as Village, isnull(Taluk,'') as Taluk, isnull(Quantity,'') as Quantity, isnull(Royalty,0) as Royalty, isnull(Vehicle_No,'') as Vehicle_No, isnull(Total_Fee,0) as Total_Fee,isnull(Printed,'') as Printed, "
		+ " isnull(From_Place,'') as From_Place,isnull(Via_Route,'') as Via_Route,isnull(To_Palce,'') as To_Palce, dateadd(mi,?,isNull(From_Date,'')) as From_Date, dateadd(mi,?,isnull(To_Date,'')) as To_Date, isnull(MiNo,'') as MiNo, isnull(Processing_Fee,0) as Processing_Fee, isnull(District,'')"
		+ " as District,isnull(Vehicle_Addr,'') as Vehicle_Addr,isNull(Validity_Period,'') as Validity_Period, isNULL(Port_No,'') as Port_No,isNULL(Loading_Type,'') as Loading_Type,isNULL(DD_No,'') as DD_No,isNULL(Bank_Name,'')"
		+ " as Bank_Name,dateadd(mi,?,isNULL(DD_Date,'')) as  DD_Date,isNULL(Group_Id,'') as  Group_Id,isNULL(Group_Name,'') as  Group_Name,isNULL(Index_No,'') as  Index_No,isNULL(Driver_Name,'') as  Driver_Name,isnull(PORT_ID,'') as PORT_ID ,isnull(Sand_Loading_From_Time,'')as Sand_Loading_From_Time,isnull(Sand_Loading_To_Time,'')as Sand_Loading_To_Time,isNull(CONSUMER_APPLICATION_NO,'') as CONSUMER_APPLICATION_NO,"
		+ " isnull(SAND_EXTRACTION_FROM,'') as SAND_EXTRACTION_FROM , isnull(DISTANCE,'0') as DISTANCE FROM Sand_Mining_Trip_Sheet_History WHERE (System_Id = ?) and Client_Id=? and Printed='N' and User_Id=? and isnull(CROSS_PLATFORM,'N')<>'Y'";
	
	
	public static final String GET_ROYALTY = "select * from dbo.Sand_Mining_Default_Setting where System_Id=? and Port_Name=? ";
	
	public static final String GET_TRIP_SHEET_NO = "SELECT * FROM Sand_Mining_Trip_Sheet WHERE System_Id=? and Client_Id=? and TS_ID = (select max(TS_ID) from Sand_Mining_Trip_Sheet where System_Id=? and Client_Id=? )";
	
	public static final String GET_COUNT_TRIP_SHEET_NO = "select Count(*) as count from Sand_Mining_Trip_Sheet where System_Id=? and Client_Id=? "
		+ "and From_Place=?  and Printed<>'DEL' and Date_TS between dateadd(mi,-?,?) and dateadd(mi,-?,?)";
	
	public static final String INSERT_MDP_DETAILS = "INSERT INTO [AMS].[dbo].[Sand_Mining_Trip_Sheet](Trip_Sheet_No,Date_TS,Permit_No,Lessee_Name "
		+ ",Lessee_Type,Mineral_Type,Survey_No,Village,Taluk,Quantity,Royalty,Vehicle_No "
		+ " ,From_Place,To_Palce,From_Date,To_Date,System_Id,Client_Id,Processing_Fee,Total_Fee,Printed,User_Id,"
		+ "Vehicle_Addr,Port_No,Loading_Type,DD_No,Bank_Name,DD_Date,Group_Id,Group_Name,Index_No,Driver_Name,Via_Route,PORT_ID,CROSS_PLATFORM,Sand_Loading_From_Time,Sand_Loading_To_Time,CUSTOMER_NAME,ASSET_DISTRICT,Validity_Period,CONSUMER_APPLICATION_NO,SAND_EXTRACTION_FROM,DISTANCE,LATITUDE,LONGITUDE) "
		+ " VALUES(?,getutcdate(),?,?,?,?,?,?,?,?,?,?,?,?,dateadd(mi,-?,?),dateadd(mi,-?,?),?,?,?,?,?,?,?,?,?,?,?,dateadd(mi,-?,?),?,?,?,?,?,?,'N',?,?,?,'Local',?,?,?,?,?,?)";
	
	public static final String UPDATE_GENERAL_SETTINGS = "UPDATE [AMS].[dbo].[General_Settings]   SET [value] = ? WHERE [System_Id]=? and [Client_Id]=? and name='TS_No'";
	
	public static final String UPDATE_CREDIT_AGAINST_TEMP_PERMIT = "update AMS.dbo.SAND_CONSUMER_CREDIT_MASTER set BALANCE_AMOUNT=BALANCE_AMOUNT-?,TAKEN_TRIPS=TAKEN_TRIPS+1 "+
	"where CONSUMER_APPLICATION_NO=?  and SYSTEM_ID=?  and CUSTOMER_ID=?  and  ? between 0 and  BALANCE_AMOUNT "; 
	
	public static final String GET_TOTAL_FEE ="select Total_Fee from Sand_Mining_Trip_Sheet where TS_ID=? ";
	
	public static final String UPDATE_MDP_DETAILS ="update Sand_Mining_Trip_Sheet  set  Permit_No=?, Lessee_Name=?, Lessee_Type=?, "
		+ "	 Mineral_Type=?, Survey_No=?, Village=?, Taluk=?, Quantity=?, Royalty=?, Vehicle_No=?, "
		+ "	 From_Place=?,To_Palce=?, From_Date=dateadd(mi,-?,?), To_Date=dateadd(mi,-?,?), Processing_Fee=?, Total_Fee=?,Printed=?,"
		+ "  Date_TS=dateadd(mi,-?,?),District=?,Vehicle_Addr=?,Port_No=?,Validity_Period=?,Loading_Type=?,DD_No=?,Bank_Name=?,"
		+ "  DD_Date=dateadd(mi,-?,?),Group_Id=?,Group_Name=?,Driver_Name=?,Via_Route=?,PORT_ID=?,Sand_Loading_From_Time=?,Sand_Loading_To_Time=?,CUSTOMER_NAME=?,CONSUMER_APPLICATION_NO=?,DISTANCE=? "
		+ "	 where System_Id=? and Client_Id=? and TS_ID=? and User_Id=?";
	
	public static final String UPDATE_CREDIT_AGAINST_TEMP_PERMIT1 = "update AMS.dbo.SAND_CONSUMER_CREDIT_MASTER set BALANCE_AMOUNT=BALANCE_AMOUNT+?-? "+
	"where CONSUMER_APPLICATION_NO=?  and SYSTEM_ID=?  and CUSTOMER_ID=?  and   BALANCE_AMOUNT > 0 ";
	
	public static final String GET_MAX_NO = "select value from dbo.General_Settings where name='TS_No' and System_Id=? and Client_Id=?";
	
	public static final String GET_AMOUNT_MDP_GENERATOR = "select * from AMS.dbo.SAND_CONSUMER_CREDIT_MASTER where  SYSTEM_ID=? and CUSTOMER_ID=?  and CONSUMER_APPLICATION_NO=? and BALANCE_AMOUNT > 0 ";

	
	public static final String GET_VEHICLE_NO_COUNT ="select count(*) as count from dbo.Sand_Mining_Trip_Sheet where System_Id=? and Client_Id=? and  Date_TS between dateadd(mi,-?,?) and dateadd(mi,-?,?) and Permit_No=? and Printed<>'DEL'";
	
	public static final String GET_TS_COUNT_FOR_PORT1 = "select value from dbo.General_Settings where System_Id=? and name='Default_Count_Setting'";
	
	public static final String GET_TS_COUNT_FOR_PORT2 = "select * from dbo.Sand_Mining_TripSheet_Count_Setting where System_Id=? and Client_Id=? and Port_Name=? and Taluka_Name=? and datediff(day,Date,getutcdate())=0 order by Date desc ";
	
		
    public static final String GET_TS_COUNT_FOR_PORT3 = "select Count(*) as count from Sand_Mining_Trip_Sheet where System_Id=? and Client_Id=? and Loading_Type=? and From_Place=?  and Printed<>'DEL' and Date_TS between dateadd(mi,-?,?) and dateadd(mi,-?,?) and Group_Name=?";
    
    public static final String CHECK_BALANCE = "select * from AMS.dbo.SAND_CONSUMER_CREDIT_MASTER where CONSUMER_APPLICATION_NO=?  and SYSTEM_ID=?  and CUSTOMER_ID=?  and  ? between 0 and  BALANCE_AMOUNT ";

    
    public static final String GET_PDF_FILE_TYPE = "SELECT name, value, System_Id, Client_Id, value2 FROM General_Settings WHERE(name LIKE 'PDF_FILE') and System_Id=?";
    
    public static final String GET_PERMIT_NO_FOR_MDP_GENERATOR = "select isNull(VehicleNo,'') as VehicleNo,isNull(OwnerName,'') as OwnerName,isNull(v2.GROUP_ID,'') as GROUP_ID,isNull(v2.GROUP_NAME,'') as GROUP_NAME, "+
	"isNull(a.LoadingCapacity,0) as LoadingCapacity,isnull((LoadingCapacity-UnLadenWeight)/1000,0) as LoadingCapacityTons,isNull(OwnerAddress,'') as OwnerAddress, isnull(VehicleType,'') as VehicleType from dbo.tblVehicleMaster a "+
	"left outer join VEHICLE_CLIENT b on VehicleNo=REGISTRATION_NUMBER "+
	"left outer join dbo.Vehicle_User c on VehicleNo=Registration_no "+
	"left outer join dbo.gpsdata_history_latest g on g.REGISTRATION_NO=a.VehicleNo "+
	"inner join dbo.VEHICLE_GROUP v2 on b.GROUP_ID= v2.GROUP_ID "+
	"where a.System_id=? and b.CLIENT_ID=? and Status='Active'and User_id=? and g.LOCATION !='No GPS Device Connected' "+
	"and a.LoadingCapacity <> 0 and NULLIF(a.OwnerName, '') IS NOT NULL and DATEDIFF(hh,g.GMT,getutcdate())<6  ";
    
    public static final String GET_PERMIT_NO_FOR_MDP_GENERATOR_NO_GPS = "select isNull(VehicleNo,'') as VehicleNo,isNull(OwnerName,'') as OwnerName,isNull(v2.GROUP_ID,'') as GROUP_ID,isNull(v2.GROUP_NAME,'') as GROUP_NAME, "+
	"isNull(a.LoadingCapacity,0) as LoadingCapacity,isNull(OwnerAddress,'') as OwnerAddress, isnull(VehicleType,'') as VehicleType from dbo.tblVehicleMaster a "+
	"left outer join VEHICLE_CLIENT b on VehicleNo=REGISTRATION_NUMBER "+
	"left outer join dbo.Vehicle_User c on VehicleNo=Registration_no "+
	"inner join dbo.VEHICLE_GROUP v2 on b.GROUP_ID= v2.GROUP_ID "+
	"where a.System_id=? and b.CLIENT_ID=? and Status='Active'and User_id=? "+
	"and a.LoadingCapacity <> 0 and NULLIF(a.OwnerName, '') IS NOT NULL ";
    
    public static final String GET_APPLICATION_NO = "select distinct isNull(a.CONSUMER_APPLICATION_NO,'') as  CONSUMER_APPLICATION_NO,a.CREATED_DATE,isnull(a.CONSUMER_NAME,'') as CONSUMER_NAME,isnull(b.WORK_ADDRESS,'')as WORK_ADDRESS,isnull(b.LATITUDE,0) as LATITUDE,isnull(b.LONGITUDE,0) as LONGITUDE,isnull(b.MOBILE_NUMBER,'') as MOBILE_NUMBER from dbo.SAND_CONSUMER_CREDIT_MASTER a inner join AMS.dbo.SAND_CONSUMER_ENROLMENT b on a.CONSUMER_APPLICATION_NO=b.CONSUMER_APPLICATION_NO and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID where  a.SYSTEM_ID=? and a.CUSTOMER_ID=? and INSERTED_BY=? and a.BALANCE_AMOUNT>0 and b.CON_STATUS='Active'";
	
    public static final String GET_CURRENCY_FOR_MDP = "select ISNULL(CURRENCY_SYMBOL , '') as CURRENCY_SYMBOL  from ADMINISTRATOR.dbo.COUNTRY_DETAILS ,System_Master  where CountryCode=COUNTRY_CODE and System_id=?";
    
    public static final String GET_VEHICLE_NO_FOR_MDP = "select VehicleNo,isnull(VehicleAlias,'') VehicleAlias from dbo.tblVehicleMaster where System_id=? and VehicleNo=?";
    	
    public static final String GET_COUNT_TRIP_FOR_MDP = "Select count(*)+1 as count from dbo.Sand_Mining_Trip_Sheet where System_Id=? and Permit_No=? and TS_ID<?";
    		
    public static final String GET_VALUE_FROM_GENERAL_SETTING_FOR_MDP = "select isNull(value,'') as value from dbo.General_Settings where name='City' and System_Id=? and Client_Id=?";
    			
    public static final String GET_VALUE_FROM_GENERAL_SETTING1_FOR_MDP = "select isNull(value,'') as value from dbo.General_Settings where name='City' and System_Id=? and Client_Id is null";
    				
    public static final String GET_DETAILS_FROM_GENERAL_SETTING_FOR_MDP ="select * from dbo.General_Settings where name='Challan_SID' and value='Y' and System_Id=?";
    					
    public static final String GET_DETAILS_FROM_GENERAL_SETTING1_FOR_MDP = "select * from dbo.General_Settings where (name='PDF_BANK' or name='PDF_TREASURY_CODE') and System_Id=?";
    
    public static final String GET_CONSUMER_TYPE_FOR_MDP = "select sce.CONSUMER_TYPE,count(smts.CONSUMER_APPLICATION_NO) as countTrip,smts.CONSUMER_APPLICATION_NO from dbo.SAND_CONSUMER_ENROLMENT  sce "+
    "left outer join dbo.Sand_Mining_Trip_Sheet smts on smts.System_Id=sce.SYSTEM_ID and smts.Client_Id=sce.CUSTOMER_ID and smts.CONSUMER_APPLICATION_NO=sce.CONSUMER_APPLICATION_NO "+
    "where  sce.CONSUMER_APPLICATION_NO=? and sce.SYSTEM_ID=? and sce.CUSTOMER_ID=? and  Date_TS between dateadd(mi,-?,?) and dateadd(mi,-?,?) "+
    "group by smts.CONSUMER_APPLICATION_NO,sce.CONSUMER_TYPE";
    
    public static final String UPDATE_QUANTITY_FOR_MDP = "update dbo.SAND_CONSUMER_ENROLMENT set BALANCE_SAND_QUANTITY=BALANCE_SAND_QUANTITY-? where CONSUMER_APPLICATION_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? ";
    
    public static final String UPDATE_QUANTITY_FOR_MDP_MODIFY = "update dbo.SAND_CONSUMER_ENROLMENT set BALANCE_SAND_QUANTITY=BALANCE_SAND_QUANTITY+?-? where CONSUMER_APPLICATION_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

    public static final String CHECK_QUANTITY_FOR_MDP = "select isNull(BALANCE_SAND_QUANTITY,0) as BALANCE_SAND_QUANTITY from dbo.SAND_CONSUMER_ENROLMENT where CONSUMER_APPLICATION_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? ";
    
    public static final String GET_DEFAULT_SETTINGS_FOR_MDP = "select isNull(d.Valid_From,'') as Valid_From,d.Daily_Offset_1,isNull(d.Valid_To,'') as Valid_To,d.Daily_Offset_2,d.Trip_Sheet_Format, "+
    "d.Self_Amount,d.Machine_Amount,d.Default_Load_Type,dateadd(dd,Daily_Offset_1,getDate()) as d1,dateadd(dd,Daily_Offset_2,getDate()) as d2 "+
    "from dbo.Sand_Mining_Default_Setting d where d.System_Id=? and d.Client_Id=? and Port_Name=? ";
    
    public static final String GET_DD_NO_DATE_FOR_MDP = "SELECT TOP 1 UNIQUE_ID,CONSUMER_APPLICATION_NO,DD_DATE,DD_NO,CREATED_DATE,(B.BANK_NAME+'('+B.BANK_CODE+')') AS BANK_NAME FROM SAND_CONSUMER_CREDIT_MASTER A "+
    "LEFT OUTER JOIN SAND_BANK_MASTER B ON A.BANK_ID=B.ID  "+
    "WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND BALANCE_AMOUNT>0 and CONSUMER_APPLICATION_NO=? "+
    "ORDER BY CREATED_DATE DESC ";
    
    public static final String UPDATE_BALANCE_AMOUNT="update AMS.dbo.SAND_CONSUMER_CREDIT_MASTER set BALANCE_AMOUNT=? where CONSUMER_APPLICATION_NO=?  and SYSTEM_ID=?  and CUSTOMER_ID=? ";

    public static final String UPDATE_AVAILABLE_QUANTITY="UPDATE dbo.SAND_STOCKYARD_MASTER_TABLE SET ESTIMATED_SAND_QUANTITY_AVAILABLE=ESTIMATED_SAND_QUANTITY_AVAILABLE-? WHERE UNIQUE_ID=? AND SYSTEM_ID=? AND CUSTOMER_ID=?";
    
    public static final String UPDATE_ASSESSED_QUANTITY1="UPDATE Sand_Port_Details SET ASSESSED_QUANTITY=ASSESSED_QUANTITY+? WHERE System_Id=? and Client_Id=? and UniqueId=? ";
    
    public static final String UPDATE_AVAILABLE_QUANTITY1="UPDATE dbo.SAND_STOCKYARD_MASTER_TABLE SET ESTIMATED_SAND_QUANTITY_AVAILABLE=ESTIMATED_SAND_QUANTITY_AVAILABLE+? WHERE UNIQUE_ID=? AND SYSTEM_ID=? AND CUSTOMER_ID=?";
    
    public static final String GET_MAX_TRIP_SHEET_NO="select top 1 Trip_Sheet_No from AMS.dbo.Sand_Mining_Trip_Sheet where System_Id=? and Client_Id=? order by Date_TS desc";

    public static final String GET_REVENUE_FOR_DASHBOARD_CHART1 = "select sum(r.AMOUNT) as AMOUNT,r.Day from (select DATEPART(dd,dateadd(mi,330,Date_TS)) AS Day,SUM(a.Royalty) as AMOUNT from dbo.Sand_Mining_Trip_Sheet a "
    + "where a.Date_TS between dateadd(mi,-330,dateadd(dd,datediff(dd,7,getdate()),0)) and dateadd(mi,-330,dateadd(dd,datediff(dd,0,getdate()),0)) and Client_Id=? "
    + "and a.System_Id=? group by DATEPART(dd,dateadd(mi,330,Date_TS)) "
    + "union "
    + "select DATEPART(dd,dateadd(mi,330,Date_TS)) AS Day,SUM(a.Royalty) as AMOUNT from dbo.Sand_Mining_Trip_Sheet_History a "
    + "where a.Date_TS between dateadd(mi,-330,dateadd(dd,datediff(dd,7,getdate()),0)) and dateadd(mi,-330,dateadd(dd,datediff(dd,0,getdate()),0)) and Client_Id=? "
    + "and a.System_Id=? group by DATEPART(dd,dateadd(mi,330,Date_TS)) ) r group by r.Day ";
    
    public static final String GET_PERMIT_FOR_DASHBOARD_CHART1 = "select sum(r.TRIPSHEET_COUNT) as TRIPSHEET_COUNT,r.Day from ( select DATEPART(dd,dateadd(mi,330,Date_TS)) AS Day,count(a.Trip_Sheet_No) as TRIPSHEET_COUNT from dbo.Sand_Mining_Trip_Sheet a " 
    + "where a.Date_TS between dateadd(mi,-330,dateadd(dd,datediff(dd,7,getdate()),0)) and dateadd(mi,-330,dateadd(dd,datediff(dd,0,getutcdate()),0))  and Printed='Y' and isnull(a.CROSS_PLATFORM,'N')<>'Y' and Client_Id=? "
    + "and a.System_Id=? group by DATEPART(dd,dateadd(mi,330,Date_TS)) "
    + "union "
    + "select DATEPART(dd,dateadd(mi,330,Date_TS)) AS Day,count(a.Trip_Sheet_No) as TRIPSHEET_COUNT from dbo.Sand_Mining_Trip_Sheet_History a "
    + "where a.Date_TS between dateadd(mi,-330,dateadd(dd,datediff(dd,7,getdate()),0))  and dateadd(mi,-330,dateadd(dd,datediff(dd,0,getutcdate()),0)) and Printed='Y' and isnull(a.CROSS_PLATFORM,'N')<>'Y' and Client_Id=? "
    + "and a.System_Id=? group by DATEPART(dd,dateadd(mi,330,Date_TS)) ) r group by r.Day";
    
	public static final String GET_SAND_PERMITS_COUNT1 = "select count(*) as COUNT from dbo.Sand_Mining_Trip_Sheet where System_Id = ? and Client_Id = ? "
		+ "and Date_TS between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate()";
	
	public static final String GET_TOTAL_QUANTITY="select isnull(Quantity , 0.0) as Quantity  from dbo.Sand_Mining_Trip_Sheet where System_Id = ? and Client_Id = ? and Printed='Y' "+
	"and Date_TS between dateadd(mi,-?,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate() ";
	
	public static final String GET_TOTAL_EWAYBILLS_NOGPS="select COUNT(*) as COUNT from dbo.Sand_Mining_Trip_Sheet where Remarks='NOT AVAILABLE' "
		+ "and Date_TS between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getDate()  and System_Id= ? and UPPER(District) = ? ";

	public static final String GET_LATEST_MDP_DETAILS="SELECT top 1 Vehicle_No, dateadd(mi,330,From_Date) as From_Date, dateadd (mi,330,To_Date) as To_Date FROM Sand_Mining_Trip_Sheet WHERE Vehicle_No=? and System_Id=? and Client_Id=? and Printed!='DEL' order by TS_ID desc";
 
	public static final String GET_LATEST_MDP_MODIFY="SELECT top 1 Vehicle_No, dateadd(mi,330,From_Date) as From_Date, dateadd (mi,330,To_Date) as To_Date FROM Sand_Mining_Trip_Sheet WHERE Vehicle_No=? and System_Id=? and Client_Id=? and Printed!='DEL' and Trip_Sheet_No=? order by TS_ID desc";

	public static final String GET_SANDMINING_SUMMARY_REPORT=" select count(*) as COUNT, flag=1 from gpsdata_history_latest a with(NOLOCK) inner join tblVehicleMaster c on a.REGISTRATION_NO=c.VehicleNo and a.System_id=c.System_id where a.System_id =? union "
		
		+ "select count(*) as COUNT, flag=2 from gpsdata_history_latest a with(NOLOCK) inner join tblVehicleMaster c on a.REGISTRATION_NO=c.VehicleNo and a.System_id=c.System_id where a.System_id =? and a.LOCATION ='No GPS Device Connected' union " 

		+ "select count(*) as COUNT, flag=3 from gpsdata_history_latest a with(NOLOCK) inner join tblVehicleMaster c on a.REGISTRATION_NO=c.VehicleNo and a.System_id=c.System_id where a.System_id =? and a.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,a.GMT,getutcdate()) < 6 union "

		+ "select count(*) as COUNT, flag=4 from gpsdata_history_latest a with(NOLOCK) inner join tblVehicleMaster c on a.REGISTRATION_NO=c.VehicleNo and a.System_id=c.System_id where a.System_id =? and DATEDIFF(hh,a.GMT,getutcdate()) >= 6 and a.LOCATION !='No GPS Device Connected' order by flag ";

	
	public static final String GET_TOTAL_MDP_ISSUED_REPORT="With temp (S)as( select count(Trip_Sheet_No) as S from Sand_Mining_Trip_Sheet with(NOLOCK) where Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(mi,-330,?) and System_Id=? union "
		+ "select count(*) as S  from Sand_Mining_Trip_Sheet_History with(NOLOCK)  where Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(mi,-330,?) and System_Id=?) " 
		+ "select isnull(sum(S),0) as COUNT from temp";
	
	public static final String GET_TOTAL_QUANTITY_REPORT="With temp (S)as( Select sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as S  from Sand_Mining_Trip_Sheet with(NOLOCK) where System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(mi,-330,?) union "
		+ "Select sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1)AS decimal (18,2))) as S from Sand_Mining_Trip_Sheet_History with(NOLOCK) where System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(mi,-330,?)) "
		+ "select isnull(sum(S),0) as COUNT from temp";
	
	public static final String GET_TOTAL_FEES_REPORT="With temp (S)as(select isnull (sum(Total_Fee),0)as S from AMS.dbo.Sand_Mining_Trip_Sheet with(NOLOCK) where System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(mi,-330,?) union "
		+ "select isnull (sum(Total_Fee),0) as S from AMS.dbo.Sand_Mining_Trip_Sheet_History with(NOLOCK) where System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(mi,-330,?)) "
		+ "select isnull(sum(S),0) as COUNT from temp";
	
	public static final String GET_LTSP_DISTRICT="select top 1 Port_District,isnull(d.DISTRICT_NAME,'') as DISTRICT_NAME  from Sand_Port_Details a with(NOLOCK) inner join DISTRICT_MASTER d on d.DISTRICT_ID=a.Port_District where System_Id=? and Port_District is not null";
	
	public static final String GET_MDP_CHECKING_REPORT="select smt.Trip_Sheet_No,smt.Vehicle_No as Vehicle_No,(DATEADD(mi,330,smt.Printed_Date)) as Printed_Date,isnull(smt.Group_Name,'')as Group_Name,isnull(smt.CUSTOMER_NAME,'')as CUSTOMER_NAME,ghl.LOCATION as LOCATION , ghl.GPS_DATETIME as GPS_DATETIME from Sand_Mining_Trip_Sheet smt with(NOLOCK), gpsdata_history_latest ghl with(NOLOCK), Vehicle_User vh with(NOLOCK)  " 
		+ "where ghl.REGISTRATION_NO=smt.Vehicle_No and  vh.Registration_no=smt.Vehicle_No and System_Id =? and Client_Id=? and Vehicle_No not in (select distinct Permit_No from( select distinct Permit_No from Sand_Mining_Trip_Sheet_History with(NOLOCK) where System_Id=? and Client_Id=? and Printed_Date between dateadd(mm,-1,getutcdate()) and getutcdate() union select distinct Permit_No from Sand_Mining_Trip_Sheet with(NOLOCK) where System_Id=? and Client_Id=? and Printed_Date between dateadd(mm,-1,getutcdate()) and getutcdate() ) s ) "
		+ "and smt.Printed_Date between dateadd(mm,-6,getutcdate()) and dateadd(mm,-1,getutcdate()) and smt.Printed='Y' and vh.User_id=? "
		+ " union "
		+ "SELECT smt.Trip_Sheet_No,smt.Vehicle_No as Vehicle_No,(DATEADD(mi,330,smt.Printed_Date)) as Printed_Date,isnull(smt.Group_Name,'')as Group_Name,isnull(smt.CUSTOMER_NAME,'')as CUSTOMER_NAME,ghl.LOCATION as LOCATION , ghl.GPS_DATETIME as GPS_DATETIME from Sand_Mining_Trip_Sheet_History smt with(NOLOCK), gpsdata_history_latest ghl with(NOLOCK), Vehicle_User vh with(NOLOCK)  " 
		+ "where ghl.REGISTRATION_NO=smt.Vehicle_No and  vh.Registration_no=smt.Vehicle_No and System_Id =? and Client_Id=? and Vehicle_No not in (select distinct Permit_No from( select distinct Permit_No from Sand_Mining_Trip_Sheet_History with(NOLOCK) where System_Id=? and Client_Id=? and Printed_Date between dateadd(mm,-1,getutcdate()) and getutcdate() union select distinct Permit_No from Sand_Mining_Trip_Sheet with(NOLOCK) where System_Id=? and Client_Id=? and Printed_Date between dateadd(mm,-1,getutcdate()) and getutcdate() ) s  ) "
		+ "and smt.Printed_Date between  dateadd(mm,-6,getutcdate()) and  dateadd(mm,-1,getutcdate()) and smt.Printed='Y' and vh.User_id=? "
		+ "order by smt.Vehicle_No ";

	public static final String DISTINCT_VEH_NO="select distinct smt.Vehicle_No from Sand_Mining_Trip_Sheet smt with(NOLOCK), gpsdata_history_latest ghl with(NOLOCK), Vehicle_User vh with(NOLOCK)  " 
		+ "where ghl.REGISTRATION_NO=smt.Vehicle_No and  vh.Registration_no=smt.Vehicle_No and System_Id =? and Client_Id=? and Vehicle_No not in (select distinct Permit_No from( select distinct Permit_No from Sand_Mining_Trip_Sheet_History with(NOLOCK) where System_Id=? and Client_Id=? and Printed_Date between dateadd(mm,-1,getutcdate()) and getutcdate() union select distinct Permit_No from Sand_Mining_Trip_Sheet with(NOLOCK) where System_Id=? and Client_Id=? and Printed_Date between dateadd(mm,-1,getutcdate()) and getutcdate() ) s ) "
		+ "and smt.Printed_Date between dateadd(mm,-6,getutcdate()) and  dateadd(mm,-1,getutcdate()) and smt.Printed='Y' and vh.User_id=? "
		+ " union "
		+ "SELECT distinct smt.Vehicle_No from Sand_Mining_Trip_Sheet_History smt with(NOLOCK), gpsdata_history_latest ghl with(NOLOCK),  Vehicle_User vh with(NOLOCK) " 
		+ "where ghl.REGISTRATION_NO=smt.Vehicle_No and  vh.Registration_no=smt.Vehicle_No and System_Id =? and Client_Id=? and Vehicle_No not in (select distinct Permit_No from( select distinct Permit_No from Sand_Mining_Trip_Sheet_History with(NOLOCK) where System_Id=? and Client_Id=? and Printed_Date between dateadd(mm,-1,getutcdate()) and getutcdate() union select distinct Permit_No from Sand_Mining_Trip_Sheet with(NOLOCK) where System_Id=? and Client_Id=? and Printed_Date between dateadd(mm,-1,getutcdate()) and getutcdate() ) s ) "
		+ "and smt.Printed_Date between  dateadd(mm,-6,getutcdate()) and  dateadd(mm,-1,getutcdate()) and smt.Printed='Y' and vh.User_id=? "
		+ "order by smt.Vehicle_No ";
	
	public static final String GET_SAND_INWARD_REPORT = "SELECT a.PERMIT_ID,isnull(d.CONTRACTOR_NAME,'') as CONTRACTOR_ID, isnull (c.SAND_STOCKYARD_NAME,'') as STOCKYARD_ID, isnull (b.Port_Name,'') as SAND_BLOCK_ID,a.PERMIT_NO,a.CONTRACT_NO,PERMIT_DATE,a.VEHICLE_NO,a.QUANTITY, isnull (a.VALID_FROM,'') as VALID_FROM ,isnull (a.VALID_TO,'') as VALID_TO,ISNULL(PROCESSING_FEES,0) AS PROCESSING_FEES,DATEADD(mi,330,PRINTED_DATE) as PRINTED_DATE FROM AMS.dbo.SAND_INWARD_TRIP_SHEET a "  
	+ "left outer join AMS.dbo.Sand_Port_Details b on b.UniqueId=a.SAND_BLOCK_ID "
	+ "left outer join AMS.dbo.SAND_STOCKYARD_MASTER_TABLE c on c.UNIQUE_ID=a.STOCKYARD_ID "
	+ "left outer join AMS.dbo.SAND_CONTRACTOR_MASTER d on d.UNIQUE_ID=a.CONTRACTOR_ID "
	+ "where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? and PERMIT_DATE between ? and ? AND a.PRINTED='Y' ORDER BY a.PERMIT_DATE desc ";
	
	public static final String GET_SAND_BOAT_REPORT ="SELECT isnull(s.REGISTRATION_NO,'')as BOAT_NO,s.ID as ID,isnull(s.STOPPAGE_START_TIME,'')as STOPPAGE_ALERT_TIME, " +
	" isnull(tp.Permit_NoNEW,'')as TP_OWNER," +
	" isnull(a.NAME,'') as PARKING_HUB,isnull(b.NAME,'') as LOADING_HUB, " +
	" isnull(s.PARKING_HUB_DISTANCE,'')as PARKING_HUB_DISTANCE,isnull(s.LOADING_HUB_DISTANCE,'')as LOADING_HUB_DISTANCE,STOPPAGE_DURATION "
	+"FROM AMS.dbo.Temporary_Permit_Master tp "
	+"inner join AMS.dbo.SAND_BOAT_STOPPAGE_ALERT s on tp.TP_ID=s.TP_OWNER_ID inner join LOCATION_ZONE_A a on a.HUBID=s.PARKING_HUB inner join LOCATION_ZONE_A b on b.HUBID=s.LOADING_HUB "
	+"where SYSTEM_ID=? AND CUSTOMER_ID=? and INSERTED_DATETIME between ? and ? ";
	
	public static final String GET_SAND_BOAT_MAP = "SELECT  isnull(s.REGISTRATION_NO,'')as BOAT_NO,s.ID as ID,s.LATITUDE as LATITUDE,s.LONGITUDE as LONGITUDE,s.LOCATION as LOCATION, "
		+"isnull(a.NAME,'') as PARKING_HUB,isnull(a.LATITUDE,0) as parkinglat,isnull(a.LONGITUDE,0)as parkinglong,isnull(b.NAME,'') as LOADING_HUB,isnull(b.LATITUDE,0) as loadinglat,isnull(b.LONGITUDE,0)as loadinglong,"
		+"isnull(s.PARKING_HUB_DISTANCE,'')as PARKING_HUB_DISTANCE,isnull(s.LOADING_HUB_DISTANCE,'')as LOADING_HUB_DISTANCE,STOPPAGE_DURATION,s.GPS_DATETIME as GPS_DATETIME,"
		+"s.SYSTEM_ID as SYSTEM_ID,s.PARKING_HUB as PARKING_HUBID,s.LOADING_HUB as LOADING_HUBID FROM AMS.dbo.Temporary_Permit_Master tp "
		+"inner join AMS.dbo.SAND_BOAT_STOPPAGE_ALERT s on tp.TP_ID=s.TP_OWNER_ID inner join LOCATION_ZONE_A a on a.HUBID=s.PARKING_HUB inner join LOCATION_ZONE_A b on b.HUBID=s.LOADING_HUB "
		+"where s.REGISTRATION_NO=? AND s.ID=?";
	
	public static final String GET_VEHICLES_WITHOUT_GPS_REPORT = "select Vehicle_No,Trip_Sheet_No,dateadd(mi,330,Date_TS) as Date_TS,From_Place,To_Palce,Driver_Name,CUSTOMER_NAME,Quantity,isnull(dateadd(mi,330,From_Date),'') as From_Date,isnull(dateadd(mi,330,To_Date),'') as To_Date,isnull(Royalty,0) as Royalty from dbo.Sand_Mining_Trip_Sheet where Remarks='NOT AVAILABLE' "
		+ "and Date_TS between ? and ? and System_Id= ? and UPPER(District) = ? "
		+ "union "
		+ "select Vehicle_No,Trip_Sheet_No,dateadd(mi,330,Date_TS) as Date_TS,From_Place,To_Palce,Driver_Name,CUSTOMER_NAME,Quantity,isnull(dateadd(mi,330,From_Date),'') as From_Date,isnull(dateadd(mi,330,To_Date),'') as To_Date,isnull(Royalty,0) as Royalty from dbo.Sand_Mining_Trip_Sheet_History where Remarks='NOT AVAILABLE' "
		+ "and Date_TS between ? and ? and System_Id= ? and UPPER(District) = ? ";

	public static final String UNAUTHORIZED_HUB_COUNT = "select count(ASSET_NUMBER) as COUNT,ASSET_NUMBER,isnull(lvs.GROUP_NAME,'') as ASSET_GROUP from dbo.UNAUTHORIZED_PORT_ENTRY u "
		   +"left outer join dbo.LOCATION_ZONE_A l on l.HUBID=u.HUB_ID left outer join dbo.Sand_Port_Details s on s.UniqueId=u.PORT_NO "
		   +"left outer join AMS.dbo.Live_Vision_Support lvs on lvs.REGISTRATION_NO=u.ASSET_NUMBER "
		   +"where u.SYSTEM_ID=? and u.CUSTOMER_ID=? and ARRIVAL_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) group by ASSET_NUMBER,lvs.GROUP_NAME order by ASSET_NUMBER";
	
	public static final String GET_TOTAL_MDP_ISSUED_REPORT_SMS="With temp (S)as( select count(Trip_Sheet_No) as S from Sand_Mining_Trip_Sheet with(NOLOCK) where Printed='Y' and Printed_Date between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and System_Id=? union "
		+ "select count(*) as S  from Sand_Mining_Trip_Sheet_History with(NOLOCK)  where Printed='Y' and Printed_Date between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() and System_Id=?) " 
		+ "select isnull(sum(S),0) as COUNT from temp";
	
	public static final String GET_TOTAL_QUANTITY_REPORT_SMS="With temp (S)as( Select sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as S  from Sand_Mining_Trip_Sheet with(NOLOCK) where System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() union "
		+ "Select sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1)AS decimal (18,2))) as S from Sand_Mining_Trip_Sheet_History with(NOLOCK) where System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate()) "
		+ "select isnull(sum(S),0) as COUNT from temp";
	
	public static final String GET_TOTAL_FEES_REPORT_SMS="With temp (S)as(select isnull (sum(Total_Fee),0)as S from AMS.dbo.Sand_Mining_Trip_Sheet with(NOLOCK) where System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate() union "
		+ "select isnull (sum(Total_Fee),0) as S from AMS.dbo.Sand_Mining_Trip_Sheet_History with(NOLOCK) where System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)) and getutcdate()) "
		+ "select isnull(sum(S),0) as COUNT from temp";
	
	public static final String GET_SIP_HEADER = "select value from General_Settings where name='SIP_Header' and System_Id=?";
	
	public static final String CHECK_RECORD_EXISTS ="select REGISTRATION_NO from AMS.dbo.SAND_BLOCKED_VEHICLE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?  and REGISTRATION_NO=?";
	
	public static final String INSERT_INTO_SAND_BLOCKED_VEHICLE_DETAILS = "insert into AMS.dbo.SAND_BLOCKED_VEHICLE_DETAILS (REGISTRATION_NO,REASON,REMARKS,INSERTED_DATETIME,BLOCKED_BY,SYSTEM_ID,CUSTOMER_ID) values (?,?,?,getutcdate(),?,?,?) ";
	
	public static final String GET_SAND_BLOCKED_VEHICLE_DETAILS =" select ID,isnull(u.REGISTRATION_NO,'') as VehicleNo,isnull(BLOCKED_BY,'') as BLOCKED_BY,isnull(u.REASON,'') as BLOCKED_REASON,isnull(u.REMARKS,'') as BLOCKED_REMARKS,isnull(dateadd(mi,?,u.INSERTED_DATETIME),'') as BLOKED_DATETIME,isnull(lvs.GROUP_NAME,'') as ASSET_GROUP " +
																"from AMS.dbo.SAND_BLOCKED_VEHICLE_DETAILS u left outer join AMS.dbo.Live_Vision_Support lvs on lvs.REGISTRATION_NO=u.REGISTRATION_NO where u.SYSTEM_ID=? and u.CUSTOMER_ID=?  and u.INSERTED_DATETIME between ? and ? ";
	
	public static final String INSERT_INTO_SAND_BLOCKED_VEHICLE_DETAILS_HISTORY = "insert into AMS.dbo.SAND_BLOCKED_VEHICLE_DETAILS_HISTORY (ID,REGISTRATION_NO,REASON,REMARKS,BLOCKED_DATETIME,BLOCKED_BY,SYSTEM_ID,CUSTOMER_ID,UNBLOCK_REASON,UNBLOCK_REMARKS,UNBLOCK_DATETIME,UNBLOCKED_BY,PENALTY,PENALTY_AMOUNT) values (?,?,?,?,?,?,?,?,?,?,getutcdate(),?,?,?) "; 
	
	public static final String DELETE_UNBLOCKED_VEHICLE = "Delete from AMS.dbo.SAND_BLOCKED_VEHICLE_DETAILS where CUSTOMER_ID=? and SYSTEM_ID=? and REGISTRATION_NO=? ";
	
	public static final String Check_Vehicle_Blocked="select * from dbo.SAND_BLOCKED_VEHICLE_DETAILS where REGISTRATION_NO=?";
	
	public static final String GET_BLOCKED_VEHICLES_REPORT = "select isnull(u.REGISTRATION_NO,'') as VehicleNo,isnull(b.Firstname,'') as BLOCKED_BY,isnull(u.REASON,'') as BLOCKED_REASON,isnull(u.REMARKS,'') as BLOCKED_REMARKS,isnull(dateadd(mi,?,u.INSERTED_DATETIME),'') as BLOCKED_DATETIME,'' as UNBLOCK_REASON,'' as UNBLOCK_REMARKS,'' as UNBLOCK_DATETIME,'' as UNBLOCKED_BY,'' as PENALTY,'' as PENALTY_AMOUNT " +
															" from AMS.dbo.SAND_BLOCKED_VEHICLE_DETAILS u left outer join Users b on u.BLOCKED_BY = b.User_id and u.SYSTEM_ID = b.System_id where u.SYSTEM_ID=? and u.CUSTOMER_ID=? and INSERTED_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";
	
	public static final String GET_UNBLOCKED_VEHICLES_REPORT = "select isnull(v.REGISTRATION_NO,'') as VehicleNo,isnull(v.UNBLOCK_REASON,'') as UNBLOCK_REASON,isnull(v.UNBLOCK_REMARKS,'') as UNBLOCK_REMARKS,isnull(dateadd(mi,?,v.UNBLOCK_DATETIME),'') as UNBLOCK_DATETIME,isnull(b.Firstname,'') as UNBLOCKED_BY,isnull(v.PENALTY,'') as PENALTY,isnull(v.PENALTY_AMOUNT,'') as PENALTY_AMOUNT,'' as BLOCKED_BY,'' as BLOCKED_REASON,'' as BLOCKED_REMARKS,'' as BLOCKED_DATETIME "+ 
	 														" from AMS.dbo.SAND_BLOCKED_VEHICLE_DETAILS_HISTORY v left outer join Users b on v.BLOCKED_BY = b.User_id and v.SYSTEM_ID = b.System_id where v.SYSTEM_ID=? and v.CUSTOMER_ID=? and v.UNBLOCK_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";
	
	public static final String GET_BLOCKED_UNBLOCKED_VEHICLES_REPORT=" select isnull(u.REGISTRATION_NO,'') as VehicleNo,isnull(b.Firstname,'') as BLOCKED_BY,isnull(u.REASON,'') as BLOCKED_REASON,isnull(u.REMARKS,'') as BLOCKED_REMARKS,isnull(dateadd(mi,?,u.INSERTED_DATETIME),'') as BLOCKED_DATETIME,'' as UNBLOCK_REASON,'' as UNBLOCK_REMARKS,'' as UNBLOCK_DATETIME,'' as UNBLOCKED_BY,'' as PENALTY,'' as PENALTY_AMOUNT " + 
																	" from AMS.dbo.SAND_BLOCKED_VEHICLE_DETAILS u left outer join Users b on u.BLOCKED_BY = b.User_id and u.SYSTEM_ID = b.System_id where u.SYSTEM_ID=? and u.CUSTOMER_ID=? and u.INSERTED_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)"+ 
																	" union All"+
																	" select isnull(v.REGISTRATION_NO,'') as VehicleNo,isnull(b.Firstname,'') as BLOCKED_BY,isnull(v.REASON,'') as BLOCKED_REASON,isnull(v.REMARKS,'') as BLOCKED_REMARKS,isnull(dateadd(mi,?,v.BLOCKED_DATETIME),'') as BLOCKED_DATETIME,isnull(v.UNBLOCK_REASON,'') as UNBLOCK_REASON,isnull(v.UNBLOCK_REMARKS,'') as UNBLOCK_REMARKS,isnull(dateadd(mi,330,v.UNBLOCK_DATETIME),'') as UNBLOCK_DATETIME,isnull(b.Firstname,'') as UNBLOCKED_BY,isnull(v.PENALTY,'') as PENALTY,isnull(v.PENALTY_AMOUNT,'') as PENALTY_AMOUNT "+
																	" from AMS.dbo.SAND_BLOCKED_VEHICLE_DETAILS_HISTORY v left outer join Users b on v.BLOCKED_BY = b.User_id and v.SYSTEM_ID = b.System_id"+
																	" where v.SYSTEM_ID=? and v.CUSTOMER_ID=? and UNBLOCK_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)";
	
	public static final String CONSUMER_ENROLEMENT_FOR_APPROVAL=" SELECT isnull(B.Balance_Amount,0) as balance,UNIQUE_ID,CONSUMER_APPLICATION_NO,SAND_CONSUMER_NAME,MOBILE_NUMBER,CONSUMER_TYPE, "+
	" ESTIMATED_SAND_REQUIREMENT,WORK_LOCATION,ISNULL(APPROVED_SAND_QUNATITY,0) AS APPROVED_SAND_QUNATITY, "+ 
	" isnull(TP_NO,'') TP_NO,ISNULL(TP_ID,'') AS TP_ID,isnull(CHECK_POST,'') as CHECK_POST,isnull(REJECTED_REMARKS,'') REJECT_REMARKS,isnull(ADHAR_NO,'') as ADHAR_NO,isnull(PAN,'') as PROPERTY_ASSESSMENT_NO "+ 
	" FROM dbo.SAND_CONSUMER_ENROLMENT A LEFT OUTER JOIN dbo.Credit_Against_Temp_Permit B ON A.TP_ID=B.Unique_Id " +
	" WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND CONSUMER_STATUS=? ORDER BY ACTION_TAKEN_DATETIME ";

	public static final String CONSUMER_ENROLEMENT_DETAILS=" SELECT  UNIQUE_ID,CONSUMER_APPLICATION_NO,SAND_CONSUMER_NAME,MOBILE_NUMBER,CONSUMER_TYPE, " +
			" ESTIMATED_SAND_REQUIREMENT,WORK_LOCATION,ISNULL(APPROVED_SAND_QUNATITY,0) AS APPROVED_SAND_QUNATITY,isnull(BALANCE_SAND_QUANTITY,0) as BALANCE_SAND_QUANTITY,   " +
			" isnull(TP_NO,'') TP_NO,ISNULL(TP_ID,'') AS TP_ID,isnull(CHECK_POST,'') as CHECK_POST,isnull(REJECTED_REMARKS,'') REJECT_REMARKS,isnull(ADHAR_NO,'') as ADHAR_NO,isnull(PAN,'') as PROPERTY_ASSESSMENT_NO ," +
			" isnull((select isnull(sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000)  + 'X')-1) AS decimal (18,2))),0) as Total" +
			" from Sand_Mining_Trip_Sheet a where a.CONSUMER_APPLICATION_NO=b.CONSUMER_APPLICATION_NO" +
			" and System_Id =SYSTEM_ID and Client_Id=CUSTOMER_ID and Printed!='Del'  " +
			" group by CONSUMER_APPLICATION_NO),0) as TotalDispatchQty" +
			" FROM dbo.SAND_CONSUMER_ENROLMENT b WHERE SYSTEM_ID=? AND CUSTOMER_ID=? " +
			" and b.CONSUMER_APPLICATION_NO is not null AND CONSUMER_STATUS=? ORDER BY ACTION_TAKEN_DATETIME ";

	
	public static final String MANAGE_CONSUMER_ENROLEMENT_FOR_APPROVAL="UPDATE dbo.SAND_CONSUMER_ENROLMENT SET CONSUMER_STATUS= ?, ACTION_TAKEN_BY=? ,APPROVED_SAND_QUNATITY= ?,BALANCE_SAND_QUANTITY= ?,REJECTED_REMARKS=?,TIN=?,ACTION_TAKEN_DATETIME= getutcdate(),ADDITIONAL_APP_QTY=?,APPROVED_BY=?,APPROVED_DATETIME=getutcdate() WHERE UNIQUE_ID = ? AND SYSTEM_ID = ? AND CUSTOMER_ID = ? ";

	public static final String UPDATE_CREDIT= "update Credit_Against_Temp_Permit set Balance_Amount = Balance_Amount - ?  where Unique_Id = ?";
	
	public static final String GET_APPLICATION_DETAILS = "select distinct isNull(CONSUMER_APPLICATION_NO,'') as  CONSUMER_APPLICATION_NO,isnull(SAND_CONSUMER_NAME,'') as CONSUMER_NAME,isnull(WORK_LOCATION,'') as WORK_LOCATION, " +
														"isnull(LATITUDE,0) as LATITUDE,isnull(LONGITUDE,0) as LONGITUDE,isnull(CHECK_POST,'') as CHECKPOST,isnull(APPROVED_SAND_QUNATITY,0) as APPROVED_SAND_QUNATITY,isnull(BALANCE_SAND_QUANTITY,0) as BALANCE_SAND_QUANTITY,isnull(MOBILE_NUMBER,'') as PHONE " +
														"FROM AMS.dbo.SAND_CONSUMER_ENROLMENT where  SYSTEM_ID=? and CUSTOMER_ID=?  and TP_NO=? and CONSUMER_STATUS='approved' ";
	
public static final String GET_TPNO = "select top 1 isnull(c.Unique_Id,'') as TP_ID,isnull(c.Permit_No,'') as TP_NO,isnull(c.Challan_No,'') as DD_NO ,isnull(c.Date_Of_Entry,'') as DD_Date,isnull(c.Bank_Name,'') as Bank_Name, " +
									"isnull(t.Village,'') as Village,isnull(t.Taluk,'') as Taluk,isNull(c.TRIP_START_APP_NO, 0) as TripStartCode, " +
									"isNull(c.TRIP_END_APP_NO, 0) as TripEndCode,isNull(c.BARCODE_START_NO,0) as BarStartCode,isNull(c.BARCODE_END_NO,0) as BarEndCode from dbo.Credit_Against_Temp_Permit c  " +
									"left outer join dbo.SAND_TP_USER_ASSOC s on c.Client_Id=s.CUSTOMER_ID and c.System_Id=s.SYSTEM_ID and s.TP_NUMBER=c.Permit_No " +
									"left outer join dbo.Temporary_Permit_Master t on t.Permit_NoNEW=c.Permit_No and t.System_Id=c.System_Id and t.Client_Id=c.Client_Id "+
									"where c.System_Id=? and c.Client_Id=? and s.USER_ID=? and c.Permit_No<>'' and c.Permit_No is not null and getUTCdate() between t.Date_of_Issue and t.Date_of_Expiry and (t.Status ='Active' or t.Status is null) order by Entry_Date desc ";
									
public static final String GET_MDP_GENERATOR_NEW_DETAILS="SELECT TS_ID,isnull(b.TP_NO,'') as TP_NO, isnull(Trip_Sheet_No,'') as Trip_Sheet_No, isnull(Vehicle_No,'') as Vehicle_No, isnull(Lessee_Name,'') as Transporter_Name, " + 
													" isnull(CUSTOMER_NAME,'') as Consumer_Name, isnull(Quantity,'') as Quantity,isNULL(Driver_Name,'') as  Driver_Name, "+
													" isnull(Via_Route,'') as Via_Route,isnull(To_Palce,'') as To_Palce, dateadd(mi,?,isNull(From_Date,'')) as From_Date, dateadd(mi,?,isnull(To_Date,'')) as To_Date,isNULL(Loading_Type,'') as Loading_Type,isNull(a.CONSUMER_APPLICATION_NO,'') as CONSUMER_APPLICATION_NO," +
													" isnull(DISTANCE,'0') as DISTANCE,isnull(b.APPROVED_SAND_QUNATITY,0) as APPROVED_SAND_QUNATITY,isnull(b.BALANCE_SAND_QUANTITY,0) as BALANCE_SAND_QUANTITY,isnull(b.MOBILE_NUMBER,'') as PHONE "+
													" FROM Sand_Mining_Trip_Sheet a inner join AMS.dbo.SAND_CONSUMER_ENROLMENT b on a.CONSUMER_APPLICATION_NO=b.CONSUMER_APPLICATION_NO and b.SYSTEM_ID=a.System_Id and b.CUSTOMER_ID=a.Client_Id" +
													" WHERE System_Id =? and Client_Id=? and Printed='N' and User_Id=? and isnull(CROSS_PLATFORM,'N')<>'Y' " +
													" union "+
													" SELECT TS_ID,isnull(b.TP_NO,'') as TP_NO, isnull(Trip_Sheet_No,'') as Trip_Sheet_No, isnull(Vehicle_No,'') as Vehicle_No, isnull(Lessee_Name,'') " +
													" as Transporter_Name,isnull(CUSTOMER_NAME,'') as Consumer_Name, isnull(Quantity,'') as Quantity, isNULL(Driver_Name,'') as  Driver_Name," +
													" isnull(Via_Route,'') as Via_Route,isnull(To_Palce,'') as To_Palce, dateadd(mi,?,isNull(From_Date,'')) as From_Date, dateadd(mi,?,isnull(To_Date,'')) as To_Date,isNULL(Loading_Type,'') as Loading_Type,isNull(a.CONSUMER_APPLICATION_NO,'') as CONSUMER_APPLICATION_NO, " +
													" isnull(DISTANCE,'0') as DISTANCE,isnull(b.APPROVED_SAND_QUNATITY,0) as APPROVED_SAND_QUNATITY,isnull(b.BALANCE_SAND_QUANTITY,0) as BALANCE_SAND_QUANTITY,isnull(b.MOBILE_NUMBER,'') as PHONE " +
													" FROM Sand_Mining_Trip_Sheet_History a inner join AMS.dbo.SAND_CONSUMER_ENROLMENT b on a.CONSUMER_APPLICATION_NO=b.CONSUMER_APPLICATION_NO and b.SYSTEM_ID=a.System_Id and b.CUSTOMER_ID=a.Client_Id" +
													" WHERE System_Id =? and Client_Id=? and Printed='N' and User_Id=? and isnull(CROSS_PLATFORM,'N')<>'Y' ";


public static final String INSERT_MDP_NEW_DETAILS =" INSERT INTO [AMS].[dbo].[Sand_Mining_Trip_Sheet](Trip_Sheet_No,Date_TS,Permit_No,Lessee_Name, " +
											" Quantity,Vehicle_No ,From_Place,To_Palce,From_Date,To_Date,System_Id,Client_Id,Printed,User_Id," +
											" Loading_Type,Driver_Name,Via_Route,CUSTOMER_NAME,CONSUMER_APPLICATION_NO,DISTANCE,LATITUDE,LONGITUDE,Lessee_Type,Taluk,Survey_No,Village,Mineral_Type,Royalty,TRIP_CODE,BAR_CODE,Vehicle_Addr,Port_No,DD_No,Bank_Name,DD_Date,Sand_Loading_From_Time,Sand_Loading_To_Time,Total_Fee) " + 
											" VALUES(?,getutcdate(),?,?,?,?,?,?,dateadd(mi,-?,?),dateadd(mi,-?,?),?,?,'N',?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

public static final String GET_FROM_LOC_LATLONG = " select isnull(l.LATITUDE,'') as LATITUDE,isnull(l.LONGITUDE,'') as LONGITUDE,isnull(sm.Trip_Sheet_Format,'') as Trip_Sheet_Format,isnull(s.Port_Name,'') as Port_Name,isnull(s.RIVER_NAME,'') as RIVER_NAME,isnull(s.Port_No,'') as Port_No from Sand_Port_Details s " +
											    " inner join dbo.Temporary_Permit_Master tp on tp.PORT_ID=s.UniqueId " +
											    " inner join AMS.dbo.LOCATION_ZONE_A l on l.HUBID=s.Port_Hub and l.SYSTEMID=s.System_Id and s.Client_Id=l.CLIENTID " + 
											    " inner join dbo.Sand_Mining_Default_Setting sm on sm.Port_Name=s.Port_Name and sm.System_Id=s.System_Id and sm.Client_Id=s.Client_Id" +
											    " WHERE s.System_Id=? and s.Client_Id=? and ENVIRONMENTAL_CLEARANCE='Cleared' and SAND_BLOCK_STATUS='Active' and DIRECT_LOADING='Yes' and  tp.Permit_NoNEW=? "+
											    " and s.Port_Name COLLATE DATABASE_DEFAULT in (select Port_Name from Sand_Mining_Default_Setting where System_Id=?) order by s.Port_Name ";
	
public static final String GET_SAND_PORT = "select Port_Name, UniqueId FROM Sand_Port_Details where System_Id=? and Client_Id=? and SAND_BLOCK_STATUS=?";

public static final String INSERT_INTO_SANDPORT_QUANTITY_DETAILS = "insert into dbo.SAND_PORT_EXCAVATION_DETAILS (EXCAVATION_DATE, SAND_PORT_NAME, SAND_PORT_ID, SAND_QUANTITY, QUANTITY_MEASURE, SYSTEM_ID, CUSTOMER_ID,INSERTED_BY)" +
		" values (?, ?, ?, ?, ?, ?, ?, ? ) ";

public static final String CHECK_SANDPORT_QUANTITY_DETAILS = "select SAND_PORT_NAME from SAND_PORT_EXCAVATION_DETAILS" +
		" where SAND_PORT_NAME =?" +
		" and EXCAVATION_DATE between dateadd(mi,0,DATEADD(day, DATEDIFF(day, 0, ? ), 0)) and dateadd(ms,-3,DATEADD(day, DATEDIFF(day, 0, ? ), 1))" +
		" and SYSTEM_ID=? and CUSTOMER_ID=?";

public static final String GET_SANDPORT_QUANTITY_DETAILS = "select isnull(a.EXCAVATION_DATE,'') as EXCAVATION_DATE, isnull(a.SAND_PORT_NAME,'') as SAND_PORT_NAME, isnull(a.SAND_QUANTITY,'0') as SAND_QUANTITY, isnull(a.QUANTITY_MEASURE,'') as QUANTITY_MEASURE," +
		" isnull(b.Firstname +' '+ b.Lastname,'') as INSERTED_BY, isnull(a.INSERTED_DATETIME,'') as INSERTED_DATETIME" +
		" from dbo.SAND_PORT_EXCAVATION_DETAILS a " +
		" left outer join dbo.Users b on a.INSERTED_BY = b.User_id and a.SYSTEM_ID = b.System_id " +
		" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and EXCAVATION_DATE between ? and ?";

public static final String GET_TOTAL_DISPATCHED_DETAILS = "With temp (S)as( Select sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as S  from Sand_Mining_Trip_Sheet with(NOLOCK) where System_Id=? and Client_Id=? and Printed=? and Date_TS between ? and ? union" +
		" Select sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1)AS decimal (18,2))) as S from Sand_Mining_Trip_Sheet_History with(NOLOCK) where System_Id=? and Client_Id=? and Printed=? and Date_TS between ? and ?)" +
		" select isnull(sum(S),0) as Quantity from temp";

public static final String GET_STOCKYARD_LOCATION = "select isnull(SAND_STOCKYARD_NAME,'') as SAND_STOCKYARD_NAME ,isnull(UNIQUE_ID,'') as UNIQUE_ID from dbo.SAND_STOCKYARD_MASTER_TABLE where SYSTEM_ID=? AND CUSTOMER_ID=?" ;

public static final String GET_DETAILED_DETAILS = "select  isnull(sa.DATE,'') as DATE, isnull(sa.ASSET_NUMBER,'') as ASSET_NUMBER , isnull(sa.IMAGE_PATH,'') as IMAGE_PATH ,isnull(sa.GPS_FITTED,'') as GPS_FITTED from SAND_STOCKYARD_ASSET_ENTRY_DETAILS sa " +
                                                  " inner join dbo.SAND_STOCKYARD_MASTER_TABLE ss on ss.UNIQUE_ID= sa.STOCKYARD_ID  WHERE ss.SAND_STOCKYARD_NAME=? and  DATE between ? and ? order by sa.DATE DESC " ;

public static final String GET_ABSTACT_DETAILS = "select isnull(DATE,'') as DATE ,count(IMAGE_PATH) as IMAGE_PATH ,  " +
                                                 " (SELECT COUNT(ASSET_NUMBER) FROM SAND_STOCKYARD_ASSET_ENTRY_DETAILS WHERE ASSET_NUMBER <> 'NA' and STOCKYARD_ID=?) as ASSET_NUMBER , " +
												 " ( SELECT COUNT(GPS_FITTED) FROM SAND_STOCKYARD_ASSET_ENTRY_DETAILS WHERE GPS_FITTED <> 'N' and STOCKYARD_ID=? ) as GPS_FITTED,  " +
												 " ( SELECT COUNT(GPS_FITTED) FROM SAND_STOCKYARD_ASSET_ENTRY_DETAILS WHERE GPS_FITTED <> 'Y' and STOCKYARD_ID=? ) as GPS_NOT_FITTED  " +
												 " FROM SAND_STOCKYARD_ASSET_ENTRY_DETAILS sa inner join dbo.SAND_STOCKYARD_MASTER_TABLE ss on ss.UNIQUE_ID= sa.STOCKYARD_ID  WHERE DATE between ? and ? and ss.SAND_STOCKYARD_NAME=?  GROUP BY  DATE  " ;

public static final String CHECK_FOR_ADHAR_NUM = "select CONSUMER_APPLICATION_NO,IDENTITY_PROOF_TYPE,IDENTITY_PROOF_NO from dbo.SAND_CONSUMER_ENROLMENT where IDENTITY_PROOF_TYPE='ADHAAR' and CONSUMER_STATUS!='rejected' and IDENTITY_PROOF_NO=? and BALANCE_SAND_QUANTITY!=0";

public static final String GET_ASSESSED_QUANTITY = "select ASSESSED_QUANTITY from Sand_Port_Details where System_Id=? and Client_Id=? and UniqueId=? and ASSESSED_QUANTITY >= ? ";

public static final String GET_STOCKYARD_QUANTITY = "select SAND_STOCKYARD_NAME,isnull(ESTIMATED_SAND_QUANTITY_AVAILABLE,0) as ESTIMATED_SAND_QUANTITY_AVAILABLE " +
		" from dbo.SAND_STOCKYARD_MASTER_TABLE  WHERE SYSTEM_ID=? AND CUSTOMER_ID=? and UNIQUE_ID=? and ESTIMATED_SAND_QUANTITY_AVAILABLE >=? ";

public static final String DISPATCHED_QUANTITY ="select SUM(CAST(Quantity as int)) as qty from Sand_Mining_Trip_Sheet where CONSUMER_APPLICATION_NO='APPNO-5928'" +
" and System_Id =153 and Client_Id=2168 and Printed!='Del' group by CONSUMER_APPLICATION_NO ";

public static final String INSERT_CONSUMER_ADDITIONAL_QTY_DATA =" insert into CONSUMER_ADDITIONAL_QTY_DETAILS (CONSUMER_ID,CONSUMER_APPLICATION_NO,ESTIMATED_SAND_REQUIREMENT,PREVIOUS_APPROVED_SAND_QUANTITY,APPROVED_BY,APPROVED_DATE_TIME,SYSTEM_ID,CUSTOMER_ID,DISPATCHED_QUANTITY)" +
		" select UNIQUE_ID,CONSUMER_APPLICATION_NO,ESTIMATED_SAND_REQUIREMENT,ISNULL(ADDITIONAL_APP_QTY,0) AS ADDITIONAL_APP_QTY,APPROVED_BY,APPROVED_DATETIME,SYSTEM_ID,CUSTOMER_ID," +
		" isnull((select isnull(sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000)  + 'X')-1) AS decimal (18,2))),0) as Total " +
		" from Sand_Mining_Trip_Sheet a where a.CONSUMER_APPLICATION_NO=b.CONSUMER_APPLICATION_NO" +
		" and System_Id =SYSTEM_ID and Client_Id=CUSTOMER_ID and Printed!='DEL'  " +
		" group by CONSUMER_APPLICATION_NO),0) as TotalDispatchQty" +
		" FROM dbo.SAND_CONSUMER_ENROLMENT b WHERE SYSTEM_ID=? AND CUSTOMER_ID=? and UNIQUE_ID=? ";

public static final String UPDATE_CONSUMER_ENROLMENT =" update SAND_CONSUMER_ENROLMENT set APPROVED_SAND_QUNATITY=?,BALANCE_SAND_QUANTITY=?,ADDITIONAL_APP_QTY=?,APPROVED_BY=?,APPROVED_DATETIME=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=? ";

public static final String INSERT_ILMS_DETAILS = "insert into dbo.ILMS_DATA (MMPS_TRIPSHEET_ID,MMPS_TRIPSHEET_CODE,PERMIT_NO,LEASE_CODE,LEASEE_NAME,MINERAL,GRADE,MINING_PLACE_E,TOTAL_QUANTITY,ISSUE_STATUS,JOURNEY_START_DATE,JOURNEY_END_DATE,BUYER,DESTINATION,HOLOGRAM_CODE,VEHICLE_NO,PASS_ISSUE_DATE,ACTUAL_WEIGHT,TRANSPORTER_NAME,DISTANCE,TSR_NO,VILLAGE_NAME,ROUTE_DESCRIPTION,PWD_FEES,WEIGH_WEIGHT,APP_TYPE,TRIP_SHEET_TYPE,UNIT,CANCEL_REASON,PRINT_REASON,TRANSFER_REASON,CERT_NO,SYSTEM_ID,CUSTOMER_ID,USER_ID,INSERTED_DATE,VEHICLE_STATUS) VALUES " +
" (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?) ";

public static final String SELECT_ILMS_DETAILS_VALIDATE = "select MMPS_TRIPSHEET_CODE from dbo.ILMS_DATA where MMPS_TRIPSHEET_CODE=? and SYSTEM_ID=? ";

public static final String CHECK_VEHICLE_COMMUNICATION = "select REGISTRATION_NO from AMS.dbo.HISTORY_DATA_# where REGISTRATION_NO=? and GPS_DATETIME between dateadd(hh,-6,?) and ? and System_id=? and CLIENTID=? " +
		" union " +
		" select REGISTRATION_NO from AMS_Archieve.dbo.GE_DATA_# where REGISTRATION_NO=? and GPS_DATETIME between dateadd(hh,-6,?) and ? and System_id=? and CLIENTID=? ";

public static final String CHECK_VEHICLE_NON_COMMUNICATION = " select REGISTRATION_NO,SYSTEM_ID,CLIENT_ID from AMS.dbo.Live_Vision_Support where REGISTRATION_NO=? "; //and SYSTEM_ID=? and CLIENT_ID=? 

public static final String GET_ILMS_VEHICLE_DETAILS_COUNT = "select  convert(varchar(10), PASS_ISSUE_DATE, 120) as PDATE, "+
				"sum(case when VEHICLE_STATUS like 'Communicating%' then 1 else 0 end) as Communicating, "+
				"sum(case when VEHICLE_STATUS like 'Non Communicating%' then 1 else 0 end) as 'NonCommunicating', "+
				"sum(case when VEHICLE_STATUS='Not Registered' then 1 else 0 end) as 'NotRegistered'   "+
				"FROM dbo.ILMS_DATA where PASS_ISSUE_DATE between ? and ? and  SYSTEM_ID=? and CUSTOMER_ID=? "+
				"group by convert(varchar(10), PASS_ISSUE_DATE, 120)";

public static final String GET_ILMS_VEHICLE_DETAILS = " select convert(varchar(10), PASS_ISSUE_DATE, 120) as upload_date,isnull(VEHICLE_NO,' ') as vehicle_no,isnull(MMPS_TRIPSHEET_ID,'0') as tripsheet_id,isnull(MMPS_TRIPSHEET_CODE,' ') as tripsheet_code,isnull(PERMIT_NO,' ') as permit_no,isnull(LEASE_CODE,' ') as lease_code,isnull(MINING_PLACE_E,' ') as mining_place," +
		" isnull(PASS_ISSUE_DATE,' ') as pass_issue_date,isnull(JOURNEY_START_DATE,' ') as journey_start_date,isnull(JOURNEY_END_DATE,' ') as journey_end_date, isnull(VEHICLE_STATUS,' ') as vehicleStatus" +
		" from dbo.ILMS_DATA where PASS_ISSUE_DATE between ? and ? and SYSTEM_ID=? and CUSTOMER_ID=? order by PASS_ISSUE_DATE ";

public static final String GET_ILMS_SAND_PORT=" SELECT Port_No,Port_Name,Port_Village,Port_Taluk,Port_Survey_Number,System_Id,Client_Id,UniqueId,isnull(ASSESSED_QUANTITY,0) as ASSESSED_QUANTITY " +
	" ,l.LATITUDE,l.LONGITUDE  FROM Sand_Port_Details s " +
	"inner join AMS.dbo.LOCATION_ZONE_A l on l.HUBID=s.Port_Hub and l.SYSTEMID=s.System_Id and s.Client_Id=l.CLIENTID WHERE System_Id=? and Client_Id=? " +
	"order by Port_Name";

public static final String CHECK_DUPLICATE_PERMIT_NO = "select Permit_No from Sand_Mining_Trip_Sheet where System_Id=? and Client_Id=? and User_Id=? and Permit_No=? order by TS_ID";

public static final String INSERT_ILMS_MDP_DETAILS="INSERT INTO [AMS].[dbo].[Sand_Mining_Trip_Sheet] (Trip_Sheet_No,Date_TS,Permit_No,Vehicle_No,From_Place,To_Palce,From_Date,To_Date,System_Id,Client_Id,Processing_Fee,Printed, "+
	" User_Id,Group_Id,Group_Name,Index_No,PORT_ID,CROSS_PLATFORM,DISTANCE,Lessee_Name,Lessee_Type,Mineral_Type,Survey_No,Village,Taluk,Quantity,Royalty,CUSTOMER_NAME,MOBILE_NO,UNLOADING_WEIGHT,LOADING_WEIGHT,LATITUDE,LONGITUDE,NET_WEIGHT) VALUES (?,getutcdate(),?,?,?,?,dateadd(mi,-?,?),dateadd(mi,-?,?),?,?,?,?,?,?,?,?,?,'N',?,'NA','NA','NA','NA','NA','NA','0',0,?,?,?,?,?,?,?) ";

public static final String CHECK_DUPLICATE_DATE ="select * from AMS.dbo.SAND_CONSUMER_MDP_LIMIT where SYSTEM_ID=? and CUSTOMER_ID=? and DATE between ? and ? ";

public static final String INSERT_MDP_GENERATION_LIMIT_DETAILS = "INSERT INTO [AMS].[dbo].[SAND_CONSUMER_MDP_LIMIT] (DATE,GOVERNMENT_LIMIT,PUBLIC_LIMIT,CONTRACTOR_LIMIT,ASHRAYA_LIMIT,INSERTED_BY,UPDATED_BY,UPDATED_DATE,SYSTEM_ID,CUSTOMER_ID) " +
		" VALUES(dateadd(dd,?,?),?,?,?,?,?,?,getutcdate(),?,?) "; 

public static final String UPDATE_MDP_GENERATION_LIMIT_DETAILS = "update [AMS].[dbo].[SAND_CONSUMER_MDP_LIMIT] set GOVERNMENT_LIMIT=?,PUBLIC_LIMIT=?,CONTRACTOR_LIMIT=?,ASHRAYA_LIMIT=?,UPDATED_BY=?,UPDATED_DATE=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

public static final String GET_MDP_GENERATOR_LIMIT_DETAILS = "select ID,isnull(a.DATE,'') as fromDate, isnull(a.GOVERNMENT_LIMIT,0) as governmentLimit, isnull(a.PUBLIC_LIMIT,0) as publicLimit, " +
" isnull(a.CONTRACTOR_LIMIT,0) as contractorLimit, isnull(a.ASHRAYA_LIMIT,0) as ashrayaLimit, isnull(b.Firstname,'') as updatedBy, dateadd(mi,?,a.UPDATED_DATE) as updatedDate from dbo.SAND_CONSUMER_MDP_LIMIT a " +
" left outer join Users b on a.UPDATED_BY = b.User_id and a.SYSTEM_ID = b.System_id " +
" where SYSTEM_ID=? and CUSTOMER_ID=? and DATE between ? and ? ";

public static final String GET_APPLICTION_TYPE = "select CONSUMER_TYPE from [AMS].[dbo].SAND_CONSUMER_ENROLMENT where SYSTEM_ID=? and CUSTOMER_ID=? and CONSUMER_APPLICATION_NO=? ";

public static final String GET_MDP_GENERATOR_LIMIT_COUNT_DETAILS = "select b.CONSUMER_TYPE, count(a.CONSUMER_APPLICATION_NO) as CNT from Sand_Mining_Trip_Sheet a left join  SAND_CONSUMER_ENROLMENT b " +
		" on a.CONSUMER_APPLICATION_NO=b.CONSUMER_APPLICATION_NO where System_Id =? and Client_Id = ? and b.CONSUMER_TYPE=? and Printed <> 'DEL' and Date_TS between ? and ?" +
		" group by  b.CONSUMER_TYPE ";
public static final String GET_PERMIT_NO_FOR_ILMS_MDP_GENERATOR =" select isNull(VehicleNo,'') as VehicleNo,isNull(OwnerName,'') as OwnerName,isNull(v2.GROUP_ID,'') as GROUP_ID,isNull(v2.GROUP_NAME,'') as GROUP_NAME, " +
		" isNull(a.LoadingCapacity,0) as LoadingCapacity,isNull(OwnerAddress,'') as OwnerAddress, isnull(VehicleType,'') as VehicleType,isnull(a.UnLadenWeight,0) as UnLadenWeight," +
		" isnull(h.REGISTRATION_NO,'UNBLOCKED') as BLOCKED_VEHICLE_NO,isnull(g.LATITUDE,0) as LATITUDE,isnull(g.LONGITUDE,0) as LONGITUDE from dbo.tblVehicleMaster a " +
		" left outer join VEHICLE_CLIENT b on VehicleNo=REGISTRATION_NUMBER " +
		" left outer join dbo.Vehicle_User c on VehicleNo=Registration_no " +
		" left outer join dbo.gpsdata_history_latest g on g.REGISTRATION_NO=a.VehicleNo " +
		" left outer join dbo.SAND_BLOCKED_VEHICLE_DETAILS h on a.VehicleNo=h.REGISTRATION_NO " +
		" inner join dbo.VEHICLE_GROUP v2 on b.GROUP_ID= v2.GROUP_ID " +
		" where a.System_id=? and b.CLIENT_ID=? and Status='Active'and User_id=? and g.LOCATION !='No GPS Device Connected' " +
		" and g.GMT > dateadd(hh,-?,getutcdate()) ";

public static final String UPDATE_CONSUMER_ENROL_STATUS = "UPDATE AMS.dbo.SAND_CONSUMER_ENROLMENT set CON_STATUS=?, INACTIVE_REMARKS=? where SYSTEM_ID=? and CUSTOMER_ID=? and CONSUMER_APPLICATION_NO=?";

public static final String GET_TEMPROVERY_PERMIT_NO = "select Permit_NoNEW,LO_Name,Owner_Type from dbo.Temporary_Permit_Master " +
		" where System_Id=? and Client_Id=?";

public static final String GET_TP_YEARLY_APPROVED_AMOUNT = " select sum(Credit_Amount) as total_amount,DATEPART(mm,InsertedDtae) AS Month" +
		" from dbo.Credit_Against_Temp_Permit where System_Id=? and Client_Id=? and Permit_No =? and InsertedDtae between ? and ? " +
		" group by DATEPART(mm,InsertedDtae) ";

public static final String GET_TP_PREV_YEARLY_APPROVED_AMOUNT = " select sum(Credit_Amount) as total_amount,DATEPART(mm,InsertedDtae) AS Month" +
		" from dbo.Credit_Against_Temp_Permit where System_Id=? and Client_Id=? and Permit_No =? and " +
		" InsertedDtae between DATEADD(year,DATEDIFF(year,0,?)-2,0) and DATEADD(day,DATEDIFF(day,0,?),0) " +
		" group by DATEPART(mm,InsertedDtae) ";

public static final String GET_TP_YEARLY_DISPATCHED_QTY= " select sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000)  + 'X')-1) AS decimal (18,2))) as TotalQuantity ,DATEPART(mm,Printed_Date) AS Month" +
		" from Sand_Mining_Trip_Sheet with(NOLOCK)" +
		" where System_Id=? and Client_Id=? and Permit_No =? and Printed_Date between ? and ? " +
		" group by DATEPART(mm,Printed_Date)  "; 

public static final String GET_TP_PREV_YEARLY_DISPATCHED_QTY= " select sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000)  + 'X')-1) AS decimal (18,2))) as TotalQuantity ,DATEPART(mm,Printed_Date) AS Month" +
		" from Sand_Mining_Trip_Sheet with(NOLOCK)" +
		" where System_Id=? and Client_Id=? and Permit_No =? and Printed_Date between DATEADD(year,DATEDIFF(year,0,?)-2,0) and DATEADD(day,DATEDIFF(day,0,?),0) " +
		" group by DATEPART(mm,Printed_Date)  "; 

public static final String INSERT_INTO_SAND_BOAT_ASSOCIATION = " INSERT INTO AMS.dbo.SAND_BOAT_HUB_ASSOCIATION (REGISTRATION_NO,SAND_BLOCK_ID,DETENTION_TIME,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME) values " +
" (?,?,?,?,?,?,getdate()) ";

public static final String UPDATE_SAND_BOAT_DETAILS = " update AMS.dbo.SAND_BOAT_HUB_ASSOCIATION set SAND_BLOCK_ID=?,DETENTION_TIME=?,UPDATED_BY=?,UPDATED_DATETIME=getdate() where ID=? ";

public static final String GET_SAND_BLOCKS1 = " select NAME,HUBID from AMS.dbo.LOCATION_ZONE_A WHERE  SYSTEMID=? and CLIENTID=? ";

public static final String GET_REGISTRATION_NO = " select a.VehicleNo as REGISTRATION_NO, case when a.VehicleNo=b.REGISTRATION_NO then 'TRUE' else 'FALSE' end as REG_STATUS  " +
        " from AMS.dbo.tblVehicleMaster  a  " +
 		" left outer join AMS.dbo.SAND_BOAT_HUB_ASSOCIATION b on a.VehicleNo=b.REGISTRATION_NO   " +
        " where a.System_id=? " ;

public static final String GET_SAND_BOAT_DETAILS = " select a.ID,REGISTRATION_NO,lz.NAME as SAND_BLOCK,DETENTION_TIME,HUBID as HUB_ID from AMS.dbo.SAND_BOAT_HUB_ASSOCIATION a " +
		" left outer join AMS.dbo.LOCATION_ZONE_A lz on SAND_BLOCK_ID=HUBID and SYSTEMID=SYSTEM_ID " +
		" where SYSTEM_ID=? AND CUSTOMER_ID=? ";

public static final String GET_UNAUTH_ENTRY_OR_RED_ZONE_ENTRY="select REGISTRATION_NO,isnull(lz.NAME,'') as AUTH_SANDPORT,isnull(lz1.NAME,'') as UNAUTH_SANDPORT,isnull(lz1.NAME,'') as REDZONE_ENTRY,ACTUAL_ARRIVAL,ACTUAL_DEPARTURE, " +
		" datediff(mi, ACTUAL_ARRIVAL, ACTUAL_DEPARTURE) as DIFF_IN_MINS " +
		" from dbo.UNAUTHORIZED_SANDPORT_ENTRY_DETAILS a " +
		" left outer join LOCATION_ZONE_A lz on AUTH_SANPORT_ID=lz.HUBID and lz.SYSTEMID=a.SYSTEM_ID " +
		" left outer join LOCATION_ZONE_A lz1 on UNAUTH_SANPORT_ID=lz1.HUBID and lz1.SYSTEMID=a.SYSTEM_ID " +
		" where SYSTEM_ID=? and CUSTOMER_ID=? and ACTUAL_ARRIVAL between dateadd(mi,330,?) and dateadd(mi,330,?)";

public static final String GET_VEHICLE_NO = " select isnull(REGISTRATION_NO,'') as REGISTRATION_NO from  dbo.Live_Vision_Support where SYSTEM_ID=? and CLIENT_ID=? ";

public static final String GET_LTSP_SUBSCRIPTION_DETAILS = " select CUSTOMER_ID,isnull(SUBSCRIPTION_DURATION,0) as SUBSCRIPTION_DURATION,isnull(AMOUNT_PER_MONTH,0) as AMOUNT_PER_MONTH,isnull(TOTAL_AMOUNT,0) as TOTAL_AMOUNT,isnull(SUBSCRIPTION_STATUS,'Register') as SUBSCRIPTION_STATUS" +
		" from Billing.dbo.LTSP_SUBSCRIPTION_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?";

public static final String CHECK_DUPLICATE_VEHICLE_NO = " select isnull(VEHICLE_NO,'') as VEHICLE_NO,START_DATE,END_DATE,REMAINDER_DATE from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS " +
		" where SYSTEM_ID=? and CUSTOMER_ID=?" +
		" and ADMINISTRATOR.dbo.REMOVE_SPECIAL_CHARACTERS(VEHICLE_NO,'^a-zA-Z0-9s') = ADMINISTRATOR.dbo.REMOVE_SPECIAL_CHARACTERS(?,'^a-zA-Z0-9s') and ? < REMAINDER_DATE order by END_DATE desc ";

public static final String CHECK_DUPLICATE_SUBSCRIPTION_DD_NO = " select DD_NO from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and DD_NO=? and MODE_OF_PAYMENT='DD/Recipt' and DD_NO!='' ";

public static final String INSERT_VEHICLE_SUBSCRIPTION_DETAILS = " insert into AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS (SYSTEM_ID,CUSTOMER_ID,USER_ID,VEHICLE_NO,START_DATE,END_DATE,MODE_OF_PAYMENT,DD_NO," +
		" DD_DATE,BANK_NAME,TOTAL_AMOUNT,REMAINDER_DATE,SUBSCRIPTION_DURATION,VEHICLE_STATUS,INSERTED_BY,INSERTED_DATETIME) values (?,?,?,?,?,?,?,?,?,?,?,?,?,'Active',?,getdate())";

public static final String UPDATE_VEHICLE_SUBSCRIPTION_DETAILS = " update AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS set MODE_OF_PAYMENT=?,DD_NO=?, " +
		" DD_DATE=?,BANK_NAME=?,TOTAL_AMOUNT=?,SUBSCRIPTION_DURATION=?,UPDATED_BY=?,VEHICLE_STATUS='Active',UPDATED_DATETIME= getutcdate(),BILLING_STATUS=? , END_DATE=?" +
		" where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? " ;
		
public static final String GET_VEHICLE_SUBSCRIPTION_DETAILS = "SELECT ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,START_DATE,END_DATE,isnull(MODE_OF_PAYMENT,'') as MODE_OF_PAYMENT,isnull(DD_NO,'') as DD_NO,isnull(DD_DATE,'') as DD_DATE,isnull(BANK_NAME,'') as BANK_NAME,isnull(TOTAL_AMOUNT,0) as TOTAL_AMOUNT,REMAINDER_DATE,isnull(SUBSCRIPTION_DURATION,0) as SUBSCRIPTION_DURATION,isnull(VEHICLE_STATUS,'') as VEHICLE_STATUS,INSERTED_DATETIME, " +
" isnull(INSERTED_BY,0) as INSERTED_BY, isnull(UPDATED_BY,0) as UPDATED_BY,isnull(UPDATED_DATETIME,'') as UPDATED_DATETIME, "+
" isnull(SUBSCRIPTION_STATUS,'') as SUBSCRIPTION_STATUS,isnull(BILLING_STATUS,'') as BILLING_STATUS, isnull(USER_ID,0) as USER_ID "+
" from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String GET_TP_OWNER_DETAILS = " select TP_ID,isnull(Permit_NoNEW,'') as permitNoNew  from dbo.Temporary_Permit_Master where System_Id=? and Status='Active' ";

public static final String GET_TP_NON_ASSOCIATION_DATA = " select REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) " +
		" left outer join AMS.dbo.tblVehicleMaster vm on vm.VehicleNo=vc.REGISTRATION_NUMBER and vm.System_id=vc.SYSTEM_ID" +
		" left outer join AMS.dbo.Vehicle_User vu on vu.Registration_no=vc.REGISTRATION_NUMBER and vu.System_id=vc.SYSTEM_ID" +
		" where  vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vm.Status='Active' and vu.User_id=?" +
		" and vc.REGISTRATION_NUMBER not in (select  REGISTRATION_NO from AMS.dbo.TP_OWNER_ASSET_ASSOCIATION (NOLOCK) " +
		" where SYSTEM_ID=? and CUSTOMER_ID=? )" +
		" order by vc.REGISTRATION_NUMBER ";

public static final String GET_TP_ASSOCIATION_DATA =" select REGISTRATION_NO from  AMS.dbo.TP_OWNER_ASSET_ASSOCIATION " +
		" where SYSTEM_ID=? and CUSTOMER_ID=? and TP_ID=? ";

public static final String CHECK_ASSET_NO_PRESENT= "select a.REGISTRATION_NO,b.Permit_NoNEW from AMS.dbo.TP_OWNER_ASSET_ASSOCIATION a" +
		" inner join dbo.Temporary_Permit_Master b on a.TP_ID=b.TP_ID and a.SYSTEM_ID=b.System_Id" +
		" where a.REGISTRATION_NO=? and a.SYSTEM_ID=? and a.CUSTOMER_ID=? ";


public static final String INSERT_INTO_TP_OWNER_ASSET_ASSOCIATION= "insert into AMS.dbo.TP_OWNER_ASSET_ASSOCIATION(SYSTEM_ID,CUSTOMER_ID,TP_ID,REGISTRATION_NO,INSERTED_BY,PLANT_HUB_ID,LOADING_HUB_ID) values (?,?,?,?,?,?,?) ";
		
public static final String SELECT_DATA_FROM_TP_OWNER_ASSET_ASSOCIATION= "select * from AMS.dbo.TP_OWNER_ASSET_ASSOCIATION where TP_ID=? and REGISTRATION_NO=? ";

public static final String MOVE_DATA_TO_TP_OWNER_ASSET_DISASSOCIATION= "insert into AMS.dbo.TP_OWNER_ASSET_DISASSOCIATION(SYSTEM_ID,CUSTOMER_ID,TP_ID,REGISTRATION_NO,ASSOCIATED_BY,ASSOCIATED_DATETIME,DISASSOCIATED_BY,PLANT_HUB_ID,LOADING_HUB_ID) "+
 " values(?,?,?,?,?,?,?,?,?)";

public static final String DELETE_FROM_TP_OWNER_ASSET_ASSOCIATION= "delete from AMS.dbo.TP_OWNER_ASSET_ASSOCIATION where TP_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? and  REGISTRATION_NO=? ";

public static final String GET_TP_OWNER_ASSET_DETAILS= " select a.TP_ID,a.REGISTRATION_NO,b.Permit_NoNEW,g.LOCATION,datediff(hh,g.GMT,getutcdate()) as hours,g.GMT,b.MDP_ISSUING_STATUS from dbo.TP_OWNER_ASSET_ASSOCIATION a" +
		" left outer join dbo.Temporary_Permit_Master b on a.TP_ID=b.TP_ID and a.SYSTEM_ID=b.System_Id" +
		" left outer join dbo.gpsdata_history_latest g on g.REGISTRATION_NO=a.REGISTRATION_NO " +
		" where SYSTEM_ID=? and CUSTOMER_ID=? order by TP_ID ";

public static final String UPDATE_TP_MASTER_STATUS= " update dbo.Temporary_Permit_Master set MDP_ISSUING_STATUS=? where TP_ID=? and System_Id=? ";

public static final String GET_MDP_TIMENGS = " select isnull(ID,0) as ID,isnull(START_TIME,'00:00') as START_TIME ,isnull(END_TIME,'00:00') as END_TIME,isnull(VALID_TIME ,'00:00') as VALID_TIME,isnull(BLOCKED_VEHICLE,'') as BLOCKED_VEHICLE," +
		" isnull(NON_COMMUNICATING_CHECK,'') as NON_COMMUNICATING_CHECK,isnull(NON_COMMUNICATING_HOURS,'00:00') as NON_COMMUNICATING_HOURS,isnull(INSIDE_HUB,'') as INSIDE_HUB," +
		" isnull(QUANTITY_MEASURE,'') as QUANTITY_MEASURE, isnull(BUFFER_DISTANCE,0) as BUFFER_DISTANCE,isnull(GROUP_NAME,'') as GROUP_NAME,isnull(MDP_BUFFER_DISTANCE,0) as MDP_BUFFER_DISTANCE,ISNULL(PAYMENT_DURATION,0) AS PAYMENT_DURATION  " +
		" from dbo.SAND_MDP_TIME_SETTING a left outer join dbo.VEHICLE_GROUP b on b.GROUP_ID=a.VEHICLE_GROUP_ID and a.SYSTEM_ID=b.SYSTEM_ID where a.SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String IF_MDP_LIMIT_EXISTS = " select isnull(value2,0) as MDPLIMIT from AMS.dbo.General_Settings where System_Id=? and Client_Id=? and value=? and name='TpMDPLimit' ";

public static final String UPDATE_MDP_USERSETTINGS = " update AMS.dbo.General_Settings set value2=? where System_Id=? and Client_Id=? and value=?";

public static final String UPDATE_MDP_TIMENGS = " update dbo.SAND_MDP_TIME_SETTING set START_TIME=?,END_TIME=?,VALID_TIME=?,BLOCKED_VEHICLE=?,NON_COMMUNICATING_CHECK=?,NON_COMMUNICATING_HOURS=?,INSIDE_HUB=?,QUANTITY_MEASURE=?,BUFFER_DISTANCE=?,VEHICLE_GROUP_ID=?,MDP_BUFFER_DISTANCE=?,PAYMENT_DURATION = ? where SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String INSERT_MDP_TIMES =  " insert into dbo.SAND_MDP_TIME_SETTING (START_TIME,END_TIME,VALID_TIME,BLOCKED_VEHICLE,NON_COMMUNICATING_CHECK,NON_COMMUNICATING_HOURS,INSIDE_HUB,QUANTITY_MEASURE,BUFFER_DISTANCE,VEHICLE_GROUP_ID,MDP_BUFFER_DISTANCE,SYSTEM_ID,CUSTOMER_ID,PAYMENT_DURATION)" +
		"  values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

public static final String INSERT_MDP_SETTINGS =  " insert into dbo.General_Settings (name,value,System_Id,Client_Id,value2) values ('TpMDPLimit',?,?,?,?)";

public static final String GET_HUB_DETAILS = " SELECT a.NAME as HUB_NAME,a.HUBID from AMS.dbo.LOCATION_ZONE_A a " +
" INNER JOIN AMS.dbo.GeoFenceOperationMaster gf ON gf.OperationId=a.OPERATION_ID " +
" WHERE a.SYSTEMID=? AND a.CLIENTID=?  " +
" ORDER BY a.NAME  ";

public static final String GET_TP_OWNER_NAME = "select TP_ID,Permit_NoNEW from AMS.dbo.Temporary_Permit_Master where System_Id=? order by Permit_NoNEW ";

public static final String GET_SAND_EXCAVATION_REPORT = "select count(*)  as tripCount,sum(isnull(QTY,0)) as QTY,ASSET_NUMBER,STATUS,Permit_NoNEW "
	+ " FROM dbo.SAND_EXCAVATION_DETAILS as q1 left join dbo.Temporary_Permit_Master as q2 on q1.TP = q2.TP_ID "
	+ " WHERE SYSTEM_ID=? and CUSTOMER_ID=?"
	+ " and TP=? and INSERTED_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and STATUS != 'OPEN'"
	+ " group by ASSET_NUMBER,STATUS,Permit_NoNEW";

public static final String SAND_BOAT_RECONSILATION_REPORT = "select * from (select count(*)  as activityCount,"
	+ " sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000)  + 'X')-1) AS decimal (18,2))) as totalQuantity"
	+ " FROM dbo.Sand_Mining_Trip_Sheet WHERE System_Id=? and Permit_No=? and Printed='Y' and Printed_Date between dateadd(mi,-?,?) and dateadd(mi,-?,?)) as t1,"
	+ " (select count(*)  as tripCount,sum(isnull(QTY,0)) as QTY FROM dbo.SAND_EXCAVATION_DETAILS WHERE SYSTEM_ID=?  and TP=? and STATUS = 'AUTHORISED' and INSERTED_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)) as t2";

public static final String GET_ISSUE_NO_FOR_MDP_REPRINT = "select isNull(TP_ID,'') as TpID,isNull(Permit_NoNEW,'') as PermitNoNew from dbo.Temporary_Permit_Master "
	+ "where System_Id=? and Client_Id=? and Status='Active'";

public static final String GET_REPRINT_DATA ="select a.TS_ID as ID,isNull(a.Trip_Sheet_No,'NA') as PERMIT_NO,a.PERMIT_ID as PERMIT_ID,isNull(a.Permit_No,'')as TP_NUMBER,a.BAR_CODE,a.TRIP_CODE, " +
"isNull(a.[Type],'')as TYPE_OF_LAND,isNull(dateadd(mi,?,a.From_Date),'') as VALID_FROM,isNull(dateadd(mi,?,a.To_Date),'') as VALID_TO, " +
"isNull(a.Lessee_Type, '') as BUYER, isNull(a.Quantity,0) as QUANTITY,isNull(a.Royalty,0) as ROYALTY,isNull(a.Processing_Fee,0) as PROCESSING_FEE, " +
"isNull(a.Port_No,'') as SAND_PORT,a.Vehicle_No as ASSET_NO,isNull(a.To_Palce,'NA') as DESTINATION,isNull(b.LO_Name,'NA') as LeaseName,isNull(b.Lease,'NA') as LeaseNumber,isNull(b.Taluk, '') as Taluk,isnull(a.PORT_ID,'') as PORT_ID, isnull(a.DISTANCE,0.0) as DISTANCE, isnull (a.DISTRICT_IN_OUT,'') as DISTRICT_IN_OUT,isnull(a.Via_Route,'')as Via_Route from dbo.Sand_Mining_Trip_Sheet a " +
"left outer join AMS.dbo.Temporary_Permit_Master b on a.Permit_No=b.Permit_NoNEW and a.System_Id = b.System_Id and a.Client_Id=b.Client_Id " +
"left outer join dbo.SAND_TP_USER_ASSOC s on a.Client_Id=s.CUSTOMER_ID and a.System_Id=s.SYSTEM_ID and s.TP_NUMBER=a.Permit_No and a.User_Id =s.USER_ID " +
"where a.System_Id=? and a.Client_Id=?  and a.User_Id = ? and s.USER_ID=? and a.Permit_No=? and isnull(CROSS_PLATFORM,'N') <> 'Y' and a.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) union all "+
"select a.TS_ID as ID,isNull(a.Trip_Sheet_No,'NA') as PERMIT_NO,a.PERMIT_ID as PERMIT_ID,isNull(a.Permit_No,'')as TP_NUMBER,a.BAR_CODE,a.TRIP_CODE, " +
"isNull(a.[Type],'')as TYPE_OF_LAND,isNull(dateadd(mi,?,a.From_Date),'') as VALID_FROM,isNull(dateadd(mi,?,a.To_Date),'') as VALID_TO, " +
"isNull(a.Lessee_Type, '') as BUYER, isNull(a.Quantity,0) as QUANTITY,isNull(a.Royalty,0) as ROYALTY,isNull(a.Processing_Fee,0) as PROCESSING_FEE, " +
"isNull(a.Port_No,'') as SAND_PORT,a.Vehicle_No as ASSET_NO,isNull(a.To_Palce,'NA') as DESTINATION,isNull(b.LO_Name,'NA') as LeaseName,isNull(b.Lease,'NA') as LeaseNumber,isNull(b.Taluk, '') as Taluk,isnull(a.PORT_ID,'') as PORT_ID, isnull(a.DISTANCE,0.0) as DISTANCE, isnull (a.DISTRICT_IN_OUT,'') as DISTRICT_IN_OUT,isnull(a.Via_Route,'')as Via_Route from dbo.Sand_Mining_Trip_Sheet_History a " +
"left outer join AMS.dbo.Temporary_Permit_Master b on a.Permit_No=b.Permit_NoNEW and a.System_Id = b.System_Id and a.Client_Id=b.Client_Id " +
"left outer join dbo.SAND_TP_USER_ASSOC s on a.Client_Id=s.CUSTOMER_ID and a.System_Id=s.SYSTEM_ID and s.TP_NUMBER=a.Permit_No and a.User_Id =s.USER_ID " +
"where a.System_Id=? and a.Client_Id=?  and a.User_Id = ? and s.USER_ID=? and a.Permit_No=? and isnull(CROSS_PLATFORM,'N') <> 'Y' and a.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) ";

public static final String REGENERATE_OTP ="UPDATE AMS.dbo.SAND_CONSUMER_ENROLMENT set OTP=? where CONSUMER_APPLICATION_NO=? and SYSTEM_ID=? and CUSTOMER_ID=?";

public static final String VERIFY_OTP =" select OTP,CONSUMER_APPLICATION_NO,isnull(SAND_CONSUMER_NAME,'') as SAND_CONSUMER_NAME,isnull(ESTIMATED_SAND_REQUIREMENT,0.0) as ESTIMATED_SAND_REQUIREMENT,isnull(APPROVED_SAND_QUNATITY,0.0) as APPROVED_SAND_QUNATITY,isnull(TP_NO,'') as TP_NO,isnull(ADHAR_NO,'') as STOCKYARD,isnull(CONSUMER_TYPE,'') as  CONSUMER_TYPE from AMS.dbo.SAND_CONSUMER_ENROLMENT " +
 " where CONSUMER_APPLICATION_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? and OTP=? ";

public static final String UPDATE_CONSUMER_ENROLMENT_STATUS =" update AMS.dbo.SAND_CONSUMER_ENROLMENT set CONSUMER_STATUS='approved',APPROVED_BY=?,APPROVED_DATETIME=getutcdate() where CONSUMER_APPLICATION_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String GET_TP_NO_FOR_CREDIT =" select distinct isnull(a.TP_NO,'') as TP_NO,isnull(a.TP_ID,0) as TP_ID,isnull(b.LO_Phone,'') as TP_PHONE " +
		" from AMS.dbo.SAND_CONSUMER_ENROLMENT a" +
		" inner join dbo.Temporary_Permit_Master b on a.TP_NO=b.Permit_NoNEW" +
		" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.TP_NO<>'' and a.TP_NO is not null";

public static final String CONSUMER_MODULE_SMS =" select value from General_Settings where name='CONSUMER_MODULE_SMS' and System_Id=? ";

public static final String CONSUMER_CREDIT_SMS =" select value from General_Settings where name='CONSUMER_CREDIT_SMS' and System_Id=? ";

public static final String UPDATE_PREVIOUS_BALANCE_AMOUNT="update AMS.dbo.SAND_CONSUMER_CREDIT_MASTER set BALANCE_AMOUNT=? where CONSUMER_APPLICATION_NO=?  and SYSTEM_ID=?  and CUSTOMER_ID=? and INSERTED_BY=? ";

public static final String GET_QUANTITY_MEASURE=" select value from General_Settings where name='QUANTITY_MEASURE' and System_Id=? ";

public static final String GET_CONSUMER_SAND_PORT=" SELECT Port_No,Port_Name,Port_Village,Port_Taluk,Port_Survey_Number,System_Id,Client_Id,UniqueId,isnull(ASSESSED_QUANTITY,0) as ASSESSED_QUANTITY ," +
		" l.LATITUDE,l.LONGITUDE  FROM Sand_Port_Details s " +
		" inner join AMS.dbo.LOCATION_ZONE_A l on l.HUBID=s.Port_Hub and l.SYSTEMID=s.System_Id and s.Client_Id=l.CLIENTID " +
		" inner join AMS.dbo.SAND_CONSUMER_ENROLMENT c on s.Port_Name=c.ADHAR_NO" +
		" WHERE System_Id=? and Client_Id=? and ENVIRONMENTAL_CLEARANCE='Cleared' and SAND_BLOCK_STATUS='Active' and DIRECT_LOADING='Yes' " +
		" and Port_Name COLLATE DATABASE_DEFAULT in (select Port_Name from Sand_Mining_Default_Setting where System_Id=?)" +
		" and c.CONSUMER_APPLICATION_NO=? order by Port_Name";

public static final String GET_CONSUMER_STOCK_YARD=" select s.UNIQUE_ID,s.SAND_STOCKYARD_NAME,isnull(s.ESTIMATED_SAND_QUANTITY_AVAILABLE,0) as ESTIMATED_SAND_QUANTITY_AVAILABLE," +
		" isnull(s.RATE,0) as RATE, isnull(s.VILLAGE,'') as VILLAGE ,isnull(s.TALUKA,'') as TALUKA,l.LATITUDE,l.LONGITUDE " +
		" from dbo.SAND_STOCKYARD_MASTER_TABLE s " +
		" inner join AMS.dbo.LOCATION_ZONE_A l on l.HUBID=s.ASSOCIATED_GEOFENCE and l.SYSTEMID=s.SYSTEM_ID and s.CUSTOMER_ID=l.CLIENTID " +
		" inner join AMS.dbo.SAND_CONSUMER_ENROLMENT c on c.ADHAR_NO=s.SAND_STOCKYARD_NAME" +
		" WHERE s.SYSTEM_ID=? AND s.CUSTOMER_ID=? and c.CONSUMER_APPLICATION_NO=?";

public static final String GET_GROUP_ID="  select isnull(GROUP_ID,0) as GROUP_ID,isnull(GROUP_NAME,'') as GROUP_NAME FROM ADMINISTRATOR.dbo.ASSET_GROUP where SYSTEM_ID=? and CUSTOMER_ID=? "; 


public static final String CHECK_DUPLICATE_VEHICLE_PAUSE_TIME=" select * from dbo.VEHICLE_PAUSE_TIME_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and VEHICLE_NO=? and " +
		" convert(varchar(10), PAUSE_START_DATE, 105) <= CONVERT(varchar(10), CAST(? as datetime), 105) " +
		" and convert(varchar(10), PAUSE_END_DATE, 105) >= CONVERT(varchar(10), CAST(? as datetime), 105) ";


public static final String INSERT_VEHICLE_PAUSE_TIME_DETAILS=" insert into dbo.VEHICLE_PAUSE_TIME_DETAILS (VEHICLE_NO,PAUSE_START_DATE,PAUSE_END_DATE,REASON,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATE,REMARKS) " +
		" values (?,?,?,?,?,?,?,getdate(),?) ";

public static final String UPDATE_VEHICLE_PAUSE_TIME_DETAILS=" update dbo.VEHICLE_PAUSE_TIME_DETAILS set PAUSE_START_DATE=?,PAUSE_END_DATE=?,UPDATED_BY=?,UPDATED_DATE=getdate() where VEHICLE_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

public static final String GET_VEHICLE_PAUSE_TIME_DETAILS=" select ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,isnull(PAUSE_START_DATE,'') as PAUSE_START_DATE,isnull(PAUSE_END_DATE,'') as PAUSE_END_DATE,isnull(REASON,'') as REASON," +
		" isnull(b.Firstname+' '+b.Lastname,'') as INSERTED_BY,isnull(INSERTED_DATE,'') as INSERTED_DATE,isnull(REMARKS,'') as REMARKS from dbo.VEHICLE_PAUSE_TIME_DETAILS a" +
		" left outer join AMS.dbo.Users b on a.INSERTED_BY=b.User_id and a.SYSTEM_ID = b.System_id" +
		" where SYSTEM_ID=? and CUSTOMER_ID=? and INSERTED_DATE between ? and ? order by INSERTED_DATE desc";

public static final String GET_GROUP_DETAILS = " select  GROUP_ID,isnull(GROUP_NAME,'') as GROUP_NAME from ADMINISTRATOR.dbo.ASSET_GROUP where SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String GET_NON_ASSOCIATED_HUB_DETAILS = " select isnull(HUBID,0) as HUBID,isnull(NAME,'') as HUB_NAME from dbo.LOCATION_ZONE_A " +
		" where SYSTEMID=? and CLIENTID=? and HUBID not in (select HUB_ID from dbo.SAND_HUB_GROUP_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=?) " +
		" order by HUBID desc ";

public static final String GET_ASSOCIATED_HUB_DETAILS = " select HUB_ID,NAME from  dbo.SAND_HUB_GROUP_ASSOCIATION a " +
		" inner join dbo.LOCATION_ZONE_A l on a.HUB_ID = l.HUBID where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.GROUP_ID=? ";

public static final String CHECK_HUB_NAME_PRESENT = " select a.HUB_ID,isnull(l.NAME,'') as HUB_NAME,isnull(b.GROUP_NAME,'') as GROUP_NAME from dbo.SAND_HUB_GROUP_ASSOCIATION a" +
 		" inner join dbo.LOCATION_ZONE_A l on a.HUB_ID = l.HUBID and a.SYSTEM_ID = l.SYSTEMID " +		
 		" inner join ADMINISTRATOR.dbo.ASSET_GROUP b on a.GROUP_ID = b.GROUP_ID and a.SYSTEM_ID=b.SYSTEM_ID" +
		" where  a.HUB_ID=? and a.SYSTEM_ID=? and a.CUSTOMER_ID=? ";

public static final String INSERRT_HUB_GROUP_ASSOCIATION = " insert into dbo.SAND_HUB_GROUP_ASSOCIATION (GROUP_ID,HUB_ID,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME) values (?,?,?,?,?,getdate()) ";

public static final String SELECT_DATA_FROM_HUB_GROUP_ASSOCIATION = " select * from dbo.SAND_HUB_GROUP_ASSOCIATION where GROUP_ID=? and HUB_ID=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String DELETE_FROM_HUB_GROUP_ASSOCIATION= " delete from dbo.SAND_HUB_GROUP_ASSOCIATION where GROUP_ID=? and HUB_ID=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String GET_MDP_RESTRICTION_TIMENGS = " select getdate() as CUR_TIME,START_TIME,END_TIME,VALID_TIME from dbo.SAND_MDP_TIME_SETTING where SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String GET_DEFAULT_MDP_TIMENGS = " select getdate() as CUR_TIME,START_TIME,END_TIME,VALID_TIME from dbo.SAND_MDP_TIME_SETTING where SYSTEM_ID=0 and CUSTOMER_ID=0 ";

public static final String CHECK_IF_LTSP_SUBSCRIPTION_DETAILS_FOR_SUBSCRIPTION_VALIDATION = "Select INSERTED_DATETIME,SUBSCRIPTION_DURATION,AMOUNT_PER_MONTH from Billing.dbo.LTSP_SUBSCRIPTION_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String GET_CUSTOMER="select CUSTOMER_ID,NAME,STATUS,ACTIVATION_STATUS from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and STATUS='Active' and ACTIVATION_STATUS='Complete' order by NAME asc";
	
	/**
	 * To fetch customer id and name from dbo.CUSTOMER_MASTER table for logged in Customer whose Activation_Status is Incomplete
	 */
public static final String GET_CUSTOMER_FOR_LOGGED_IN_CUST="select CUSTOMER_ID,NAME,STATUS,ACTIVATION_STATUS from dbo.CUSTOMER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active' and ACTIVATION_STATUS='Complete' order by NAME asc";

public static final String GET_VEHICLE_SUBSCRIPTION_DETAILS_REPORT = "SELECT ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,START_DATE,END_DATE,MODE_OF_PAYMENT,TOTAL_AMOUNT,isnull(REMAINDER_DATE,'') as REMAINDER_DATE,isnull(INSERTED_DATETIME,'') as INSERTED_DATETIME from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and  INSERTED_DATETIME between ? and dateadd(day,1,?) ";

//public static final String GET_RECONCILIATION_REPORT = "SELECT ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,START_DATE,END_DATE,NO_OF_DAYS,AMOUNT_PER_DAY,(NO_OF_DAYS*AMOUNT_PER_DAY) as TOTAL_PRICE,INSERTED_DATE from Billing.dbo.VehicleWiseMonthlyBillDetails where SYSTEM_ID=? and CLIENT_ID=? and START_DATE>=? and  END_DATE<=?";
//public static final String GET_RECONCILIATION_REPORT = "select ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,START_DATE,END_DATE,TOTAL_AMOUNT from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS where SYSTEM_ID = ? and CUSTOMER_ID = ? and START_DATE between ? and ? ";

public static final String GET_RECONCILIATION_REPORT = "select ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,START_DATE,END_DATE,TOTAL_AMOUNT from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS where SYSTEM_ID = ? and CUSTOMER_ID = ? and START_DATE between ? and ? UNION select ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,START_DATE,END_DATE,isnull(TOTAL_AMOUNT,0) as TOTAL_AMOUNT from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS_REPORT where SYSTEM_ID = ? and CUSTOMER_ID = ? and END_DATE between ? and ? ";

public static final String CHECK_USER_IN_VEHICLE_USER = "select User_id from AMS.dbo.Vehicle_User where System_id=? and Registration_no=? and User_id=?";

public static final String INSERT_VEHICLE_USER = "insert into AMS.dbo.Vehicle_User values(?,?,?,getdate())";

public static final String CHECK_RECORD_IN_INACTIVEVEHICLEUSERASSOCIATION_HIST = " select User_id from InactiveVehicleUserAssociation_Hist where System_id=? and Registration_no=? ";

public static final String GET_USER_FOR_INACTIVE_VEHICLE = "select User_id from AMS.dbo.Users where Client_id>0 and User_id in( select USER_ID from ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION where GROUP_ID in ("
	+"select GROUP_ID from AMS.dbo.VEHICLE_CLIENT where SYSTEM_ID=? and REGISTRATION_NUMBER=?) and SYSTEM_ID=?) and System_id=? # ";

public static final String DELETE_RECORD_IN_INACTIVEVEHICLEUSERASSOCIATION_HIST  = "delete  from AMS.dbo.InactiveVehicleUserAssociation_Hist where System_id =? and Registration_no = ?" ;

public static final String GET_BOAT_HUB_BUFFER_DISTANCE_DATA  = " select isnull(BUFFER_DISTANCE,0) as BUFFER_DISTANCE,isnull(DETENTION_TIME,'') as DETENTION_TIME from dbo.SAND_BOAT_HUB_BUFFER_SETTING where SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String UPDATE_BOAT_HUB_BUFFER_DISTANCE_DATA  = " update dbo.SAND_BOAT_HUB_BUFFER_SETTING set BUFFER_DISTANCE=?,DETENTION_TIME=?  where SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String INSERT_BOAT_HUB_BUFFER_DISTANCE_DATA  = " insert into dbo.SAND_BOAT_HUB_BUFFER_SETTING (SYSTEM_ID,CUSTOMER_ID,BUFFER_DISTANCE,DETENTION_TIME) values (?,?,?,?) ";

public static final String READ_UNLADEN_WEIGHT_FROM_APPLICATION  = " select value from dbo.General_Settings where name='READ_UNLADEN_WEIGHT_FROM_APPLICATION' and System_Id=? ";

public static final String GET_SAND_MINING_GENERAL_SETTING_DETAILS  = " select isnull(s.System_Name,'') as SystemName,isnull(c.NAME,'') as CustomerName,isnull(g.name,'') as name,isnull(g.value,'') as value" +
		" from dbo.General_Settings g" +
		" inner join dbo.System_Master s on s.System_id=g.System_Id" +
		" left outer join ADMINISTRATOR.dbo.CUSTOMER_MASTER c on c.CUSTOMER_ID=g.Client_Id  where g.System_Id=? order by g.name "; 

public static final String CHECK_NAME_EXIST_IN_GENERAL_SETTING_DETAILS  = " select name from dbo.General_Settings where System_Id=? and name=? ";
		
public static final String INSERT_SAND_MINING_GENERAL_SETTING_DETAILS  = " insert into dbo.General_Settings (System_Id,name,value) values (?,?,?) ";

public static final String MODIFY_SAND_MINING_GENERAL_SETTING_DETAILS  = " update dbo.General_Settings set name=?,value=? where  System_Id=? and name=? and value=? ";

public static final String DELETE_SAND_MINING_GENERAL_SETTING_DETAILS  = " delete from dbo.General_Settings where System_Id=? and name=? and value=? ";

public static final String GET_UNRECORDED_WEIGH_BRIDGE_REPORT  = " SELECT isnull(Vehicle_No,'') as vehicleNo,isnull(Trip_Sheet_No,'') as mdpNo,isnull(Permit_No,'') as IlmsTripSheetNo,isnull(From_Place,'') as From_Place,isnull(To_Palce,'') as To_Palce, " +
		" dateadd(mi,?,isNull(From_Date,'')) as From_Date, dateadd(mi,?,isnull(To_Date,'')) as To_Date, isnull(LOADING_WEIGHT,0) as LOADING_WEIGHT,isnull(UNLOADING_WEIGHT,0) as UNLOADING_WEIGHT" +
		" FROM Sand_Mining_Trip_Sheet WHERE System_Id = ? and Client_Id=? and Printed ='Y' and Printed_Date between ? and ?" +
		" and (LOADING_WEIGHT = 0 or LOADING_WEIGHT is null) and CONSUMER_APPLICATION_NO is  NULL  and Quantity='0' order by Date_TS ";

public static final String GET_DISTRICT="SELECT * FROM DISTRICT_MASTER";

public static final String GET_STOCKYARD_BY_DISTRICT="SELECT * FROM stockyard_details WHERE DistrictId=? and GeoFenceId=23";

public static final String GET_ALL_STOCKYARD="SELECT * FROM stockyard_details WHERE GeoFenceId=23";

public static final String GET_ALL_STOCKYARD_DISTRICT="SELECT Id,HubName,Latitude,Longitude,DistrictName,AvailableSandQuantity,ReservedSandQuantity FROM sand_consumer_model.stockyard_details s inner join sand_consumer_model.district_master d on s.DistrictId=d.DistrictId and s.GeoFenceId=23";

//public static final String GET_STOCKYARD_INFO_BY_ID="SELECT * FROM stockyard_details WHERE Id=?";

//public static final String GET_STOCKYARD_INFO_BY_ID="SELECT sum(b.TotalAmount)as totalAmmount, sum(b.DispatchedSandQuantity) as totalDispatchedSandQuantity,sum(b.Royalty)as royalty,"+
//" sum(b.GSTFee)as gstFee,s.Id,s.StockyardName,s.CapacityOfStockyard,s.AvailableSandQuantity,s.ReservedSandQuantity,s.DispatchedSandQuantity,s.tripCount "+  
//"FROM sand_consumer_model.booking_master b inner join sand_consumer_model.stockyard_details s on s.Id=b.StockyardId and s.Id=?";

public static final String GET_STOCKYARD_INFO_BY_ID="SELECT sum(b.TotalAmount)as totalAmmount, sum(b.DispatchedSandQuantity) as totalDispatchedSandQuantity,sum(b.Royalty)as royalty,"+
" sum(b.GSTFee)as gstFee,s.CapacityOfStockyard,s.AvailableSandQuantity,s.ReservedSandQuantity,s.DispatchedSandQuantity "+  
"FROM sand_consumer_model.booking_master b inner join sand_consumer_model.stockyard_details s on s.Id=b.StockyardId and s.Id=? and b.BookingStatus='success' and b.PaymentStatus='success'";

public static final String GET_ALL_STOCKYARD_INFO="SELECT sum(b.TotalAmount)as totalAmmount, sum(b.DispatchedSandQuantity) as totalDispatchedSandQuantity,sum(b.Royalty)as royalty,"+
" sum(b.GSTFee)as gstFee,sum(s.CapacityOfStockyard),sum(s.AvailableSandQuantity),sum(s.ReservedSandQuantity),sum(s.DispatchedSandQuantity) "+  
"FROM sand_consumer_model.booking_master b inner join sand_consumer_model.stockyard_details s on s.Id=b.StockyardId and b.BookingStatus='success' and b.PaymentStatus='success'";

public static final String GET_TOKENS_COUNT_AND_OTHERS_INFO_FOR_STOCKYARD="select count((t.tokenNumber)) as token,sum(CASE WHEN t.TokenStatus = 'Active' THEN 1 ELSE 0 END) as activeStatus,"+
" sum(CASE WHEN t.TokenStatus = 'Expired' THEN 1 ELSE 0 END) as expired"+  
" from sand_consumer_model.token_master t inner join sand_consumer_model.booking_master b"+
" on b.BookingId=t.BookingId and t.StockyardId=? and b.StockyardId=?";

public static final String GET_ALL_TOKENS_COUNT_AND_OTHERS_INFO_FOR_STOCKYARD="select count((t.tokenNumber)) as token,sum(CASE WHEN t.TokenStatus = 'Active' THEN 1 ELSE 0 END) as activeStatus,"+
" sum(CASE WHEN t.TokenStatus = 'Expired' THEN 1 ELSE 0 END) as expired"+  
" from sand_consumer_model.token_master t inner join sand_consumer_model.booking_master b"+
" on b.BookingId=t.BookingId";

public static final String GET_REPRINT_TOKEN_HISTORY_COUNT="select count(TokenNumber) as totalReprint from sand_consumer_model.reprint_history where"+
 " TokenNumber in(select TokenNumber from sand_consumer_model.token_master where StockyardId=?)";

public static final String GET_ALL_REPRINT_TOKEN_HISTORY_COUNT="select count(TokenNumber) as totalReprint from sand_consumer_model.reprint_history where"+
" TokenNumber in(select TokenNumber from sand_consumer_model.token_master)";

public static final String GET_STOCKYARDS_HUBID="select HubId from sand_consumer_model.stockyard_details where Id=?";

public static final String GET_ALL_STOCKYARDS_HUBID="select HubId from sand_consumer_model.stockyard_details where GeoFenceId=23";

public static final String GET_DISTINCT_VEHICLE_ON_HUBID="select Distinct(REGISTRATION_NO) FROM [AMS].[dbo].[SAND_AUTOMATED_TRIP] WHERE HUB_ID=?";

public static final String GET_TRIP_COUNT_OF_VEHICLE="  SELECT MAX(COUNT) FROM [AMS].[dbo].[SAND_AUTOMATED_TRIP] WHERE REGISTRATION_NO=?";

public static final String GET_SOLD_DISPATCHED_REPORT1 = "select BookingId, ConsumerMobileNo,FromPlace,ToPlace,BookedSandQuantity,DispatchedSandQuantity "+
	" from sand_consumer_model.booking_master where StockyardId = ?";

public static final String GET_SOLD_DISPATCHED_DETAILS ="SELECT IFNULL(bm.TotalAmount,0) as totalAmount, IFNULL(BookingId, 0) AS BookingId,IFNULL(ConsumerMobileNo, 0) AS ConsumerMobileNo,IFNULL(FromPlace, '') AS FromPlace, "+ 
" IFNULL(ToPlace, '') AS ToPlace,IFNULL(BookedSandQuantity, 0) AS BookedSandQuantity,IFNULL(bm.DispatchedSandQuantity, 0) AS DispatchedSandQuantity, "+ 
" IFNULL(Royalty,0) as Royalty,IFNULL(GSTFee,0) as GSTFee,IFNULL(RemainingSandQuantity,0) as RemainingSandQuantity "+
" FROM sand_consumer_model.booking_master bm inner join sand_consumer_model.stockyard_details s on s.Id=bm.StockyardId and bm.BookingStatus='success' and bm.PaymentStatus='success' "+ 
" where StockyardId = ? ";//and bm.InsertedDateTime between ? and ? ";

public static final String GET_ALL_SOLD_DISPATCHED_DETAILS ="SELECT IFNULL(bm.TotalAmount,0) as totalAmount,IFNULL(BookingId, 0) AS BookingId,IFNULL(ConsumerMobileNo, 0) AS ConsumerMobileNo,IFNULL(FromPlace, '') AS FromPlace, "+ 
" IFNULL(ToPlace, '') AS ToPlace,IFNULL(BookedSandQuantity, 0) AS BookedSandQuantity,IFNULL(bm.DispatchedSandQuantity, 0) AS DispatchedSandQuantity, "+
" IFNULL(Royalty,0) as Royalty,IFNULL(GSTFee,0) as GSTFee,IFNULL(RemainingSandQuantity,0) as RemainingSandQuantity "+
" FROM sand_consumer_model.booking_master bm  "+
" inner join sand_consumer_model.stockyard_details s on s.Id=bm.StockyardId and bm.BookingStatus='success' and bm.PaymentStatus='success' ";  // where InsertedDateTime between ? and ?

public static final String GET_SAND_STOCK_DETAILS ="select  IFNULL(AvailableSandQuantity, 0) AS AvailableSandQty, IFNULL(sd.DispatchedSandQuantity,0) as DispatchedSandQty, "+
" IFNULL(ReservedSandQuantity, 0) as ReservedSandQty,IFNULL(HubName,'NA') as HubName from sand_consumer_model.stockyard_details sd"+
" inner join sand_consumer_model.booking_master bm on bm.StockyardId = sd.Id "+
" where sd.Id = ?  and bm.BookingStatus='success' and bm.PaymentStatus='success' ";

public static final String GET_ALL_SAND_STOCK_DETAILS ="select  IFNULL(AvailableSandQuantity, 0) AS AvailableSandQty, IFNULL(sd.DispatchedSandQuantity,0) as DispatchedSandQty, "+
" IFNULL(ReservedSandQuantity, 0) as ReservedSandQty,IFNULL(HubName,'NA') as HubName from sand_consumer_model.stockyard_details sd"+
" inner join sand_consumer_model.booking_master bm on bm.StockyardId = sd.Id "+
" where bm.BookingStatus='success' and bm.PaymentStatus='success' ";

public static final String GET_VEHICLE_DETAILS ="select DISTINCT(isnull(REGISTRATION_NO,'')) as REGISTRATION_NO, isnull(GPS_DATETIME,'') as GPS_DATETIME,isnull(GMT,'') as GMT, "+ //distinct 
" isnull(IGNITION,'') as IGNITION,isnull(LOCATION,'') as LOCATION "+
" from  AMS.dbo.gpsdata_history_latest ghl "+
" inner join AMS.dbo.Vehicle_association va on va.System_id = ghl.System_id and va.Client_id = ghl.CLIENTID "+
" inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.SYSTEM_ID = va.System_id and ag.CUSTOMER_ID = va.Client_id "+
" where ghl.System_id = ? and ghl.CLIENTID IN(#) ";

public static final String GET_TRIP_DETAILS ="select HUB_ID,s.REGISTRATION_NO,CASE WHEN upper(s.LOCATION) like '%BOREWELL%' or upper(s.LOCATION) like '%BORE WELL%' or upper(s.LOCATION) like '%BORWELL%' or upper(s.LOCATION) like '%SAND GHAT%' THEN "+ 
" 'SOURCE' ELSE 'DESTINATION' END as TYPE,s.LOCATION as NAME, s.LATITUDE as LATITUDE,s.LONGITUDE as LONGITUDE, "+
" dateadd(mi,330,s.ACTUAL_ARRIVAL) as DATETIME,s.DISTANCE as DISTANCE,s.INSERTED_DATETIME as INSERTED_DATETIME,s.STATUS as STATUS, "+
" s.COUNT as COUNT,isnull(tvm.OwnerName, '') as OWNER_NAME, isnull(vg.GROUP_NAME, '') as GROUP_NAME from AMS.dbo.SAND_AUTOMATED_TRIP s  "+ 
" left outer join tblVehicleMaster tvm on tvm.VehicleNo = s.REGISTRATION_NO and tvm.System_id = s.SYSTEM_ID "+
" inner join VEHICLE_CLIENT v on v.SYSTEM_ID=s.SYSTEM_ID and v.REGISTRATION_NUMBER=s.REGISTRATION_NO and CLIENT_ID= ? "+
" inner join VEHICLE_GROUP vg on vg.GROUP_ID=v.GROUP_ID "+
" where s.SYSTEM_ID=? order by s.ACTUAL_ARRIVAL,s.INSERTED_DATETIME asc ";

public static final String GET_STOCKYARD_DETAILS =  " select IFNULL(TokenNumber,'') as TokenNumber,IFNULL(VehicleNumber,'') as VehicleNumber, "+ 
" IFNULL(QuantityTaken,0) as QuantityTaken,IFNULL(VehicleType,'') as VehicleType, IFNULL(TokenStatus,'') as Status "+
" from sand_consumer_model.token_master t inner join sand_consumer_model.booking_master b on b.BookingId=t.BookingId  "+
"  where t.StockyardId = ? order by Status" ; 
	
public static final String GET_ALL_STOCKYARD_DETAILS = " select IFNULL(TokenNumber,'') as TokenNumber,IFNULL(VehicleNumber,'') as VehicleNumber, "+ 
" IFNULL(QuantityTaken,0) as QuantityTaken,IFNULL(VehicleType,'') as VehicleType, IFNULL(TokenStatus,'') as Status "+
" from sand_consumer_model.token_master t inner join sand_consumer_model.booking_master b "+
" on b.BookingId=t.BookingId order by Status" ;

public static final String GET_ACTIVE_SAND_DETAILS ="select IFNULL(HubName,'') as HubName,IFNULL(Address,'') as Address,IFNULL(AvailableSandQuantity,0) as AvailableSandQuantity, "+ 
" IFNULL(ReservedSandQuantity,0) as ReservedSandQuantity,IFNULL(DispatchedSandQuantity,0) as DispatchedSandQuantity "+ 
" from sand_consumer_model.stockyard_details where Id = ? and SystemId = ? and IsActive=true ";

public static final String GET_ALL_ACTIVE_SAND_DETAILS = "select IFNULL(HubName,'') as HubName,IFNULL(Address,'') as Address,IFNULL(AvailableSandQuantity,0) as AvailableSandQuantity, "+ 
" IFNULL(ReservedSandQuantity,0) as ReservedSandQuantity,IFNULL(DispatchedSandQuantity,0) as DispatchedSandQuantity "+ 
" from sand_consumer_model.stockyard_details where SystemId = ? and IsActive=true ";

public static final String GET_ALL_JSMDC_USERS="SELECT Id,UserName,FullName,TypeOfBuyer,MobileNo,Address,City,Pincode,Email,typeOfDocument,ProofOfIdentity,IsActive FROM users";

public static final String GET_ALL_JSMDC_STOCKYARD_DISTRICT_ID="SELECT Id,HubName,Address,IsActive FROM stockyard_details where DistrictId=?";

public static final String GET_ALL_JSMDC_STOCKYARD="SELECT Id,HubName,Address,IsActive FROM stockyard_details";

public static final String ACTIVE_INACTIVE_JSMDC_STOCKYAD="update stockyard_details set IsActive=? where Id=?";

public static final String ACTIVE_INACTIVE_JSMDC_USER="update users set IsActive=? where Id=?";

public static final String CONFIGURE_STOCKYARD="update stockyard_details set CapacityOfStockyard=?,AvailableSandQuantity=?,AssociatedGeofence=? where id=?";

//public static final String UPDATE_STOCKYARD_BOOKING_LIMIT="update stockyard_details set AvailableSandQuantity=? where id=?";

//public static final String UPDATE_STOCKYARD_NO_OF_TRIPS="update stockyard_details set AssociatedGeofence=? where id=?";

public static final String GET_STOCKYARD_INFO_FOR_CONFIGURATION="SELECT Id,HubName,Address,IsActive,CapacityOfStockyard,AvailableSandQuantity,AssociatedGeofence,ReservedSandQuantity,DispatchedSandQuantity,GeoFenceId,HubId FROM stockyard_details where Id=?";

public static final String GET_All_ACTIVE_AND_INACTIVE_HUBS="select sum(case when IsActive=true then 1 else 0 end)as activeHubs,sum(case when IsActive=false then 1 else 0 end)as inActiveHubs from stockyard_details";

public static final String UPDATE_IND_USER_TYPE_PER_DAY ="update sand_consumer_model.t4u_resource_properties set KeyValue = ? where Id = 21 and AccessFlag = 'Y' and EndDate is null";

public static final String UPDATE_IND_USER_TYPE_PER_WEEK ="update sand_consumer_model.t4u_resource_properties set KeyValue = ? where Id = 22 and AccessFlag = 'Y' and EndDate is null";

public static final String UPDATE_IND_USER_TYPE_PER_MONTH ="update sand_consumer_model.t4u_resource_properties set KeyValue = ? where Id = 23 and AccessFlag = 'Y' and EndDate is null";

public static final String GET_IND_INFO_PER_DAY_FOR_CONFIGURATION="select KeyValue from sand_consumer_model.t4u_resource_properties where Id = 21 and AccessFlag = 'Y' and EndDate is null";

public static final String GET_IND_INFO_PER_WEEK_FOR_CONFIGURATION="select KeyValue from sand_consumer_model.t4u_resource_properties where Id = 22 and AccessFlag = 'Y' and EndDate is null";

public static final String GET_IND_INFO_PER_MONTH_FOR_CONFIGURATION="select KeyValue from sand_consumer_model.t4u_resource_properties where Id = 23 and AccessFlag = 'Y' and EndDate is null";

public static final String UPDATE_GOVT_USER_TYPE_PER_DAY ="update sand_consumer_model.t4u_resource_properties set KeyValue = ? where Id = 24 and AccessFlag = 'Y' and EndDate is null";

public static final String UPDATE_GOVT_USER_TYPE_PER_WEEK ="update sand_consumer_model.t4u_resource_properties set KeyValue = ? where Id = 25 and AccessFlag = 'Y' and EndDate is null";

public static final String UPDATE_GOVT_USER_TYPE_PER_MONTH ="update sand_consumer_model.t4u_resource_properties set KeyValue = ? where Id = 26 and AccessFlag = 'Y' and EndDate is null";

public static final String GET_GOVT_INFO_PER_DAY_FOR_CONFIGURATION="select KeyValue from sand_consumer_model.t4u_resource_properties where Id = 24 and AccessFlag = 'Y' and EndDate is null";

public static final String GET_GOVT_INFO_PER_WEEK_FOR_CONFIGURATION="select KeyValue from sand_consumer_model.t4u_resource_properties where Id = 25 and AccessFlag = 'Y' and EndDate is null";

public static final String GET_GOVT_INFO_PER_MONTH_FOR_CONFIGURATION="select KeyValue from sand_consumer_model.t4u_resource_properties where Id = 26 and AccessFlag = 'Y' and EndDate is null";

public static final String GET_ACTIVE_SAND_COUNTS = "select count(IsActive) as count from sand_consumer_model.stockyard_details where IsActive=true ";

public static final String GET_TOTAL_ASSET_COUNT_FOR_LTSP_NEW = " select count(*) as COUNT from  AMS.dbo.gpsdata_history_latest ghl"+
" inner join AMS.dbo.Vehicle_association va on va.System_id = ghl.System_id and va.Client_id = ghl.CLIENTID "+
" inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.SYSTEM_ID = va.System_id and ag.CUSTOMER_ID = va.Client_id "+ 
" where ghl.System_id = ? and ghl.CLIENTID = ? "; 

public static final String GET_NON_COM_GREATER_THAN_24HRS_COUNT_FOR_LTSP_NEW = " select count(*) as COUNT from  AMS.dbo.gpsdata_history_latest ghl"+
" inner join AMS.dbo.Vehicle_association va on va.System_id = ghl.System_id and va.Client_id = ghl.CLIENTID "+
" inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.SYSTEM_ID = va.System_id and ag.CUSTOMER_ID = va.Client_id "+ 
" where ghl.System_id = ? and ghl.CLIENTID = ?  and ghl.GMT < dateadd(hh,-24,getUTCDate()) and ghl.LOCATION <> 'No GPS Device Connected'";

public static final String GET_COMMUNICATION_COUNT_FOR_LTSP_NEW = " select count(*) as COUNT from  AMS.dbo.gpsdata_history_latest ghl"+
" inner join AMS.dbo.Vehicle_association va on va.System_id = ghl.System_id and va.Client_id = ghl.CLIENTID "+
" inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.SYSTEM_ID = va.System_id and ag.CUSTOMER_ID = va.Client_id "+ 
" where ghl.System_id = ? and ghl.CLIENTID = ?  and ghl.GMT > dateadd(hh,-24,getUTCDate()) and ghl.LOCATION <> 'No GPS Device Connected'";

public static final String GET_TP_WISE_BOAT_ASSOCIATION_REPORT =" select a.ID,isnull(a.REGISTRATION_NO,'') as RegistrationNumber,isnull(b.Permit_NoNEW,'') as PermitNumber , "+
" isnull(c.NAME,'') as ParkingHub from dbo.TP_OWNER_ASSET_ASSOCIATION a "+
" left outer join dbo.Temporary_Permit_Master b on a.TP_ID=b.TP_ID "+
" left outer join dbo.LOCATION_ZONE_A c on c.HUBID=a.LOADING_HUB_ID "+
" where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ?  order by a.ID ";

public static final String GET_REGISTERED_VEHICLES ="select a.REGISTRATION_NO as ASSET_NUMBER "+
" from AMS.dbo.gpsdata_history_latest a "+
" inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id = b.System_id "+ 
" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "+ 
" where a.System_id=? and b.User_id = ? ";

public static final String GET_ZERO_VALUE_COORDINATES = "select isnull(REGISTRATION_NO,'') as REGISTRATION_NO, isnull(UNIT_NO,'') as UNIT_NO,isnull(LONGITUDE,'') as LONGITUDE, isnull(LATITUDE,'') as LATITUDE," +
" isnull(ALTITUDE,'') as ALTITUDE, isnull(SPEED,'') as SPEED, " +
" isnull(SATELLITE,'') as SATELLITE, isnull(GPS_DATETIME,'') as GPS_DATETIME from ZeroValueCoordinates where System_id=? and CLIENTID=? ";

public static final String GET_MDP_COUNT_TAKEN = "select count(DATEADD(dd, 0, DATEDIFF(dd, 0, INSERTED_TIME))) as Unladencount from Sand_Mining_Trip_Sheet where System_Id = ? and Vehicle_No = ? "+ 
" and DATEADD(dd, 0, DATEDIFF(dd, 0, INSERTED_TIME))=DATEADD(dd, 0, DATEDIFF(dd, 0, getutcdate())) ";

public static final String GET_MDP_LOCATION_COUNT_TAKEN_4 = "select count(DATEADD(dd, 0, DATEDIFF(dd, 0, INSERTED_TIME))) as LocationCount " +
"from Sand_Mining_Trip_Sheet where System_Id = ? and Vehicle_No = ? and From_Place = 'BALKUR BLOCK NO 4 STOCKYARD NO 4' "+ 
" and DATEADD(dd, 0, DATEDIFF(dd, 0, INSERTED_TIME))=DATEADD(dd, 0, DATEDIFF(dd, 0, getutcdate())) ";

public static final String GET_MDP_LOCATION_COUNT_TAKEN_6 = "select count(DATEADD(dd, 0, DATEDIFF(dd, 0, INSERTED_TIME))) as LocationCount " +
"from Sand_Mining_Trip_Sheet where System_Id = ? and Vehicle_No = ? and From_Place = 'HALNAD BLOCK NO 6 STOCKYARD NO 6' "+ 
" and DATEADD(dd, 0, DATEDIFF(dd, 0, INSERTED_TIME))=DATEADD(dd, 0, DATEDIFF(dd, 0, getutcdate())) ";


public static final String GET_INACTIVE_VEHICLE_SUBSCRIPTION_DETAILS_REPORT = "SELECT ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,START_DATE,END_DATE,isnull(MODE_OF_PAYMENT,'') as MODE_OF_PAYMENT,isnull(DD_NO,'') as DD_NO, " +
" isnull(DD_DATE,'') as DD_DATE,isnull(BANK_NAME,'') as BANK_NAME,isnull(TOTAL_AMOUNT,0) as TOTAL_AMOUNT,isnull(REMAINDER_DATE,'') as REMAINDER_DATE,isnull(SUBSCRIPTION_DURATION,'') as SUBSCRIPTION_DURATION, " +
" isnull(VEHICLE_STATUS,'') as VEHICLE_STATUS,isnull(INSERTED_BY,'') as INSERTED_BY,isnull(INSERTED_DATETIME,'') as INSERTED_DATETIME,isnull(UPDATED_BY,'') as UPDATED_BY,isnull(UPDATED_DATETIME,'') as UPDATED_DATETIME, " +
" isnull(SUBSCRIPTION_STATUS,'') as SUBSCRIPTION_STATUS,isnull(BILLING_STATUS,'') as BILLING_STATUS from AMS.dbo.VEHICLE_SUBSCRIPTION_DETAILS_REPORT " + 
" where SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String GET_CUSTOMER_ID_BY_HUBID="SELECT DISTINCT(CLIENTID) FROM AMS.dbo.LOCATION_ZONE_A WHERE HUBID IN(#)";

public static final String GET_CUSTOMER_BASED_ON_ID = "select count(REGISTRATION_NO) as TOTAL_VEHICLES, "+
"isnull(SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) < ? and c.LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END),0)AS COMM,"+ 
"isnull(SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >=? THEN 1 ELSE 0 END),0)AS NONCOMM "+  
"from ADMINISTRATOR.dbo.PRODUCT_PROCESS d "+ 
"inner join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC a on  a.PROCESS_ID=d.PROCESS_ID "+ 
"inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID "+
"left outer join AMS.dbo.gpsdata_history_latest c on c.CLIENTID=b.CUSTOMER_ID and c.System_id=b.SYSTEM_ID "+  
"where b.CUSTOMER_ID IN(#) and b.SYSTEM_ID=? and b.STATUS='Active' and b.ACTIVATION_STATUS='Complete' and d.PROCESS_TYPE_LABEL_ID='Vertical_Sol'";

public static final String GET_TOTAL_MDP_AND_LOADCAPACITY = "select isnull(LOADING_CAPACITY_TYPE1,0) as LOADING_CAPACITY_TYPE1,isnull(LOADING_CAPACITY_TYPE2,0) as LOADING_CAPACITY_TYPE2,isnull(LOADING_CAPACITY_TYPE3,0) as LOADING_CAPACITY_TYPE3,isnull(MDP_ALLOWED_TYPE1,0) as MDP_ALLOWED_TYPE1,isnull(MDP_ALLOWED_TYPE2,0) as MDP_ALLOWED_TYPE2,isnull(MDP_ALLOWED_TYPE3,0) as MDP_ALLOWED_TYPE3 from dbo.ADMIN_STOCKYARD_MDP_CHECK where SYSTEM_ID=? and CUSTOMER_ID=? and STOCKYARD_ID=?";

public static final String GET_STOCKYARD_DETAILS_CHECK = "select isnull(STOCKYARD_ID,0) as STOCKYARD_ID, "+
"isnull(LOADING_CAPACITY_TYPE1,'') as LOADING_CAPACITY_TYPE1, "+
"isnull(MDP_ALLOWED_TYPE1,'') as MDP_ALLOWED_TYPE1, "+
"isnull(LOADING_CAPACITY_TYPE2,'') as LOADING_CAPACITY_TYPE2, "+
"isnull(MDP_ALLOWED_TYPE2,'') as MDP_ALLOWED_TYPE2, "+
"isnull(LOADING_CAPACITY_TYPE3,'') as LOADING_CAPACITY_TYPE3, "+
"isnull(MDP_ALLOWED_TYPE3,'') as MDP_ALLOWED_TYPE3 "+
"from dbo.ADMIN_STOCKYARD_MDP_CHECK where SYSTEM_ID=? and CUSTOMER_ID=? and STOCKYARD_ID=?;";

public static final String UPDATE_MDP_STOCKYARD_DETAILS = "update dbo.ADMIN_STOCKYARD_MDP_CHECK set LOADING_CAPACITY_TYPE1=?,MDP_ALLOWED_TYPE1=?,LOADING_CAPACITY_TYPE2=?,MDP_ALLOWED_TYPE2=?,LOADING_CAPACITY_TYPE3=?,MDP_ALLOWED_TYPE3=? where STOCKYARD_ID=? and SYSTEM_ID=? AND CUSTOMER_ID=?";

public static final String INSERT_MDP_STOCKYARD_DETAILS = "INSERT INTO dbo.ADMIN_STOCKYARD_MDP_CHECK (STOCKYARD_ID,LOADING_CAPACITY_TYPE1,MDP_ALLOWED_TYPE1,LOADING_CAPACITY_TYPE2,MDP_ALLOWED_TYPE2,LOADING_CAPACITY_TYPE3,MDP_ALLOWED_TYPE3,SYSTEM_ID,CUSTOMER_ID) VALUES (?,?,?,?,?,?,?,?,?);";

public static final String GET_ANALYTICAL_WEIGH_BRIDGE_DEFERENCE = "SELECT ISNULL(ID,0)AS ID,ISNULL(MMPS_TRIPSHEET_CODE,'')AS MMPS_TRIPSHEET_CODE,ISNULL(LEASE_CODE,'')AS LEASE_CODE,ISNULL(LEASE_NAME,'')AS LEASE_NAME,ISNULL(BUYER,'')AS BUYER, "+
											"ISNULL(SOURCE,0.0)AS SOURCE,ISNULL(DESTINATION,'')AS DESTINATION,ISNULL(VEHICLE_NO,'')AS VEHICLE_NO,ISNULL(PASS_ISSUE_DATE,'')AS PASS_ISSUE_DATE, "+
											"ISNULL(ACTUAL_WEIGHT,0.0)AS ACTUAL_WEIGHT,ISNULL(NET_WEIGHT,0.0)AS NET_WEIGHT,ISNULL(DIFFERENCE_WEIGHT,0.0)AS DIFFERENCE_WEIGHT, "+
											"ISNULL(INSERTED_DATE,'')AS INSERTED_DATE FROM AMS.dbo.ILMS_DIFFERENCE_WEIGHT WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND INSERTED_DATE BETWEEN ? AND DATEADD(DAY,1,?)";

}