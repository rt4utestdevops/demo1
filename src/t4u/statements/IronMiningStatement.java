package t4u.statements;

public interface IronMiningStatement {

	public static final String GET_TOTAL_ASSET_COUNT = " select count(a.REGISTRATION_NO) as COUNT from dbo.gpsdata_history_latest a "
			+ "inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id "
			+ "inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
			+ "where a.System_id=? and a.CLIENTID=? and b.User_id=? and c.VehicleType=? ";

	public static final String GET_TOTAL_ASSET_COUNT_CLIENT = " select count(a.REGISTRATION_NO) as COUNT from dbo.gpsdata_history_latest a "
			+ "inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id "
			+ "inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and c.Status='Active'  "
			+ "where a.System_id=? and a.CLIENTID=? and b.User_id=? and c.VehicleType=? ";

	public static final String GET_COMMUNICATION_COUNT = " select count(a.REGISTRATION_NO) as COUNT from dbo.gpsdata_history_latest a "
			+ "inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id "
			+ "inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
			+ "where a.System_id=? and a.CLIENTID=? and b.User_id=? and c.VehicleType=? "
			+ "and a.LOCATION <> 'No GPS Device Connected' and a.GMT > dateadd(mi,-15,getUTCDate())";

	public static final String GET_COMMUNICATION_COUNT_CLIENT = " select count(a.REGISTRATION_NO) as COUNT from dbo.gpsdata_history_latest a "
			+ "inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id "
			+ "inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
			+ "where a.System_id=? and a.CLIENTID=? and b.User_id=? and c.VehicleType=? "
			+ "and a.LOCATION <> 'No GPS Device Connected' and a.GMT > dateadd(mi,-15,getUTCDate())";

	public static final String GET_NON_COMM_COUNT = "select count(a.REGISTRATION_NO) as COUNT from dbo.gpsdata_history_latest a "
			+ "inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id "
			+ "inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
			+ "where a.System_id=? and a.CLIENTID=? and b.User_id=? and c.VehicleType=? "
			+ "and a.LOCATION <> 'No GPS Device Connected' and a.GMT <= dateadd(mi,-15,getUTCDate())";

	public static final String GET_NON_COMM_COUNT_CLIENT = "select count(a.REGISTRATION_NO) as COUNT from dbo.gpsdata_history_latest a "
			+ "inner join  dbo.Vehicle_User b on a.REGISTRATION_NO=b.Registration_no and a.System_id=b.System_id "
			+ "inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "
			+ "where a.System_id=? and a.CLIENTID=? and b.User_id=? and c.VehicleType=? "
			+ "and a.LOCATION <> 'No GPS Device Connected' and a.GMT <= dateadd(mi,-15,getUTCDate())";

	public static final String GET_IRON_DASHBOARD_TRIP_SHEET_ISSUED = "select count(td.ASSET_NUMBER) as TRIP_SHEET_ISSUED,isnull(sum(td.QUANTITY/1000),0) as DISPATCHED_QUANTITY from dbo.TRIP_DETAILS td "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER  and tvm.VehicleType=? "
			+ "inner join  dbo.Vehicle_User b on b.Registration_no=td.ASSET_NUMBER and b.System_id=td.SYSTEM_ID "
			+ "where td.LINKED_TS='N' and td.ISSUE_DATE >=DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0) and td.ISSUE_DATE<DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1) "
			+ "and td.SYSTEM_ID=? and td.CUSTOMER_ID=? and  b.User_id=?";

	public static final String GET_IRON_DASHBOARD_TRIPSHEET_OPEN = "select count(td.STATUS) as TRIPSHEET_OPEN,"
			+ "isnull(sum(td.QUANTITY/1000),0) as IN_TRANSIT_QUANTITY from dbo.TRIP_DETAILS td "
			+ "inner join  dbo.Vehicle_User b on b.Registration_no=td.ASSET_NUMBER and b.System_id=td.SYSTEM_ID "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER "
			+ "and tvm.VehicleType=? where td.STATUS in ('In Transit','In Transit-Time Extension') "
			+ "and td.ISSUE_DATE >=DATEADD(day, DATEDIFF(day, 7, GETDATE()), 0) and td.ISSUE_DATE<DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1) and td.SYSTEM_ID=? and td.CUSTOMER_ID=? and b.User_id=? ";

	public static final String GET_IRON_DASHBOARD_TRIP_SHEET_CLOSED = "select count(td.STATUS)as TRIP_SHEET_CLOSED,isnull(sum(QUANTITY/1000),0)as RECIEVED_QUANTITY from dbo.TRIP_DETAILS td "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER and tvm.VehicleType=? "
			+ "inner join  dbo.Vehicle_User b on b.Registration_no=td.ASSET_NUMBER and b.System_id=td.SYSTEM_ID "
			+ "where td.STATUS  like ('%Closed%') and td.STATUS not like '%Returned Trip%' and td.STATUS not like '%Breakdown%' and td.START_TIME >=DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)"
			+ " and td.START_TIME<DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1) and td.SYSTEM_ID=? and td.CUSTOMER_ID=? and b.User_id=? ";

	public static final String GET_IRON_DASHBOARD_CLOSED_RETURN_TRIP = "select count(td.ASSET_NUMBER) as CLOSED_RETURN_TRIP from dbo.TRIP_DETAILS td "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER  and tvm.VehicleType=? "
			+ "inner join  dbo.Vehicle_User b on b.Registration_no=td.ASSET_NUMBER and b.System_id=td.SYSTEM_ID "
			+ " where td.STATUS  like ('%Returned%') and td.ISSUE_DATE >=DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0) and td.ISSUE_DATE<DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1) "
			+ "and td.SYSTEM_ID=? and td.CUSTOMER_ID=? and b.User_id=?";

	public static final String GET_IRON_DASHBOARD_VECHICLES_WITH_EXTENDED_TRIPS = "select count(td.ASSET_NUMBER) as VECHICLES_WITH_EXTENDED_TRIPS from dbo.TRIP_DETAILS td "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER and tvm.VehicleType=?  "
			+ "inner join  dbo.Vehicle_User b on b.Registration_no=td.ASSET_NUMBER and b.System_id=td.SYSTEM_ID "
			+ "where td.LINKED_TS='N' and td.STATUS like '%Extension%' and td.START_TIME >=DATEADD(day, DATEDIFF(day, 7, GETDATE()), 0) "
			+ "and td.START_TIME<DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1) and td.SYSTEM_ID=? and td.CUSTOMER_ID=? and b.User_id=?";

	public static final String GET_IRON_DASHBOARD_VECHICLES_WITH_MODIFIED_TRIPS = "select count(td.ASSET_NUMBER) as VECHICLES_WITH_MODIFIED_TRIPS from dbo.TRIP_DETAILS td "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER and tvm.VehicleType=? "
			+ "inner join  dbo.Vehicle_User b on b.Registration_no=td.ASSET_NUMBER and b.System_id=td.SYSTEM_ID "
			+ "where td.LINKED_TS='Y' and td.STATUS like '%In Transit%' and td.START_TIME >=DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0) "
			+ "and td.START_TIME<DATEADD(day, DATEDIFF(day, 0, GETDATE()), 1) "
			+ "and td.SYSTEM_ID=? and td.CUSTOMER_ID=? and b.User_id=?";

	public static final String GET_QUANTITY_FOR_DASHBOARD_CHART = "select DATEPART(dw,td.ISSUE_DATE),sum(td.QUANTITY/1000) as QUANTITY from dbo.TRIP_DETAILS td "
			+ " inner join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER and tvm.VehicleType=? "
			+ " where td.ISSUE_DATE >=  DATEADD(day, DATEDIFF(day, 0, GETDATE()),-7) and  td.ISSUE_DATE <  DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)  and td.CUSTOMER_ID=? "
			+ " and td.SYSTEM_ID=? group by DATEPART(dw,td.ISSUE_DATE),DATEADD(day, DATEDIFF(day, 0, td.ISSUE_DATE), 0) "
			+ "UNION ALL select DATEPART(dw,tdh.ISSUE_DATE),sum(tdh.QUANTITY/1000) as QUANTITY from dbo.TRIP_DETAILS_HISTORY tdh "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=tdh.SYSTEM_ID and tvm.VehicleNo=tdh.ASSET_NUMBER and tvm.VehicleType=? "
			+ "where tdh.ISSUE_DATE >=  DATEADD(day, DATEDIFF(day, 0, GETDATE()),-7) and  tdh.ISSUE_DATE <  DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0)"
			+ "and tdh.CUSTOMER_ID=? and tdh.SYSTEM_ID=? group by DATEPART(dw,tdh.ISSUE_DATE),DATEADD(day, DATEDIFF(day, 0, tdh.ISSUE_DATE), 0)";

	public static final String GET_PERMIT_FOR_DASHBOARD_CHART = "select DATEPART(dw,td.ISSUE_DATE),count(td.ASSET_NUMBER) as TRIP_SHEET_ISSUED from dbo.TRIP_DETAILS td "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER and tvm.VehicleType=?"
			+ " where td.ISSUE_DATE >=  DATEADD(day, DATEDIFF(day, 0, GETDATE()),-7) and  td.ISSUE_DATE <  DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0) "
			+ "and td.CUSTOMER_ID=? and td.SYSTEM_ID=? group by DATEPART(dw,td.ISSUE_DATE),DATEADD(day, DATEDIFF(day, 0, td.ISSUE_DATE), 0) "
			+ "union all select DATEPART(dw,tdh.ISSUE_DATE),count(tdh.ASSET_NUMBER) as TRIP_SHEET_ISSUED from dbo.TRIP_DETAILS_HISTORY tdh "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=tdh.SYSTEM_ID and tvm.VehicleNo=tdh.ASSET_NUMBER and tvm.VehicleType=?"
			+ " where tdh.ISSUE_DATE >=  DATEADD(day, DATEDIFF(day, 0, GETDATE()),-7) and  tdh.ISSUE_DATE <  DATEADD(day, DATEDIFF(day, 0, GETDATE()), 0) and tdh.CUSTOMER_ID=? "
			+ " and tdh.SYSTEM_ID=?  group by DATEPART(dw,tdh.ISSUE_DATE),DATEADD(day, DATEDIFF(day, 0, tdh.ISSUE_DATE), 0)";

	public static final String SELECT_ZONE_FROM_SYSTEM_ID = "select Zone from System_Master where System_id=?";

	public static final String GET_MINING_SETTING_TYPES = "select MT.TYPE_ID,MT.TYPE_DESCRIPTION,MT.COUNT,MT.LOCATION_ID,L.NAME,isnull(MT.PLACE_NAME,'') as PLACE_NAME from MINING_TYPE MT,LOCATION L where MT.CLIENT_ID=? and MT.SYSTEM_ID=? and MT.LOCATION_ID=L.HUBID order by MT.TYPE_ID";

	public static final String GET_MINING_SETTING_TYPES1 = "select MT.TYPE_ID,MT.TYPE_DESCRIPTION,MT.COUNT,MT.LOCATION_ID,L.NAME,isnull(MT.PLACE_NAME,'') as PLACE_NAME from MINING_TYPE MT,LOCATION L where MT.CLIENT_ID=? and MT.SYSTEM_ID=? and MT.TYPE_DESCRIPTION=? and MT.LOCATION_ID=L.HUBID order by MT.TYPE_ID";

	public static final String SAVE_MINING_TYPE = "insert into MINING_TYPE(TYPE_DESCRIPTION,LOCATION_ID,CLIENT_ID,SYSTEM_ID,PLACE_NAME) values(?,?,?,?,?)";

	public static final String UPDATE_MINING_TYPE = " update MINING_TYPE set  LOCATION_ID=? , PLACE_NAME=?  WHERE TYPE_DESCRIPTION=? and LOCATION_ID=? and CLIENT_ID=? and SYSTEM_ID=? and TYPE_ID=?";

	public static final String DELETE_MINING_TYPE = "delete from MINING_TYPE where CLIENT_ID=? and SYSTEM_ID=? and LOCATION_ID=? and TYPE_ID=?";

	public static final String GET_VEHICLE_COUNT = "select count(*) as Vehicle_Count from gpsdata_history_latest where HUB_ID=? and HUB_STATUS like 'Inside%' and System_id=? and CLIENTID=?";

	public static final String EXISTING_LOCATIONS_ID = "select LOCATION_ID from MINING_TYPE where SYSTEM_ID=? and CLIENT_ID=? ";

	public static final String HUB_NAMES = "select NAME,HUBID from dbo.LOCATION  where  SYSTEMID=? AND CLIENTID=? AND HUBID NOT IN ";

	public static final String HUB_NAMES1 = "select NAME,HUBID from dbo.LOCATION  where  SYSTEMID=? AND CLIENTID=?  ORDER BY NAME ";

	public static final String GET_VEHICLE_DETAILS = "select HUB_ID,REGISTRATION_NO,dateadd(mi,?,HUB_TIME) as HUB_TIME, GPS_DATETIME "
			+ "from gpsdata_history_latest where HUB_ID=?  and HUB_STATUS like 'Inside%' and System_id=? and CLIENTID=? "
			+ "order by HUB_ID,REGISTRATION_NO";

	public static final String GET_ASSET_NUMBER = " select REGISTRATION_NUMBER from AMS.dbo.tblVehicleMaster tb left outer join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id left outer join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id  where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and vc.GROUP_ID = ? order by REGISTRATION_NUMBER ";

	public static final String SELECT_GROUP_LIST_FOR_ASSET = "select a.GROUP_ID,a.GROUP_NAME from ADMINISTRATOR.dbo.ASSET_GROUP a "
			+ " inner join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on b.SYSTEM_ID=a.SYSTEM_ID and b.GROUP_ID=a.GROUP_ID "
			+ " where a.SYSTEM_ID=?  and a.CUSTOMER_ID=? and b.USER_ID=? order by a.GROUP_NAME";

	public static final String GET_ASSET_TYPE_ALL = "select distinct tb.VehicleType from AMS.dbo.tblVehicleMaster tb left outer join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id left outer join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and tb.VehicleType <> '' ";
	public static final String GET_ASSET_TYPE = " select distinct tb.VehicleType from AMS.dbo.tblVehicleMaster tb left outer join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tb.VehicleNo and vc.SYSTEM_ID=tb.System_id left outer join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and vc.GROUP_ID=? and tb.VehicleType <> '' ";

	public static final String GET_TRIP_SHEET_REPORT_DETAILS_FOR_ALL = "select isnull(td.TRIP_NO,'')as Trip_Sheet_No,isnull(td.ISSUE_DATE,'')as Trip_Issued_DateAndTime,isnull(td.START_TIME,'') as Trip_Closed_DateAndTime,isnull(td.STATUS,'')as Trip_Sheet_Status,isnull(td.TC_NO,'')as TC_NO,isnull(td.ASSET_NUMBER,'')as ASSET_NUMBER,isnull(tvm.VehicleType,'')as Asset_Type,isnull(a.GROUP_NAME,'')as Group_Name,isnull(td.DRIVER_NAME,'')as DRIVER_NAME,"
			+ "isnull(td.START_LOCATION,'')as START_LOCATION,td.QUANTITY as Quantity_At_Source, isnull(td.QUANTITY,'')as Quantity_At_Destination,isnull(td.ROUTE_ID,'')as ROUTE_ID,isnull(td.END_LOCATION,'')as Destination,isnull(td.MATERIAL,'')as Mining_Type,isnull(td.REMARKS,'')as REMARKS,isnull(td.COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS from dbo.TRIP_DETAILS td "
			+ "left outer join AMS.dbo.VEHICLE_CLIENT vc on td.SYSTEM_ID=vc.SYSTEM_ID and td.CUSTOMER_ID=vc.CLIENT_ID and td.ASSET_NUMBER=vc.REGISTRATION_NUMBER "
			+ "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a on vc.SYSTEM_ID=a.SYSTEM_ID and vc.CLIENT_ID=a.CUSTOMER_ID and vc.GROUP_ID=a.GROUP_ID  "
			+ "left outer join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER "
			+ "where td.ISSUE_DATE between ? and ? and td.SYSTEM_ID=? " + "UNION ALL "
			+ "select isnull(tdh.TRIP_NO,'')as Trip_Sheet_No,isnull(tdh.ISSUE_DATE,'')as Trip_Issued_DateAndTime,isnull(tdh.START_TIME,'') as Trip_Closed_DateAndTime,isnull(tdh.STATUS,'')as Trip_Sheet_Status,isnull(tdh.TC_NO,'')as TC_NO,isnull(tdh.ASSET_NUMBER,'')as ASSET_NUMBER,isnull(tvm.VehicleType,'')as Asset_Type,isnull(a.GROUP_NAME,'')as Group_Name,isnull(tdh.DRIVER_NAME,'')as DRIVER_NAME,isnull(tdh.START_LOCATION,'')as START_LOCATION,tdh.QUANTITY as Quantity_At_Source,isnull(tdh.QUANTITY,'')as Quantity_At_Destination,"
			+ "isnull(tdh.ROUTE_ID,'')as ROUTE_ID,isnull(tdh.END_LOCATION,'')as Destination,isnull(tdh.MATERIAL,'')as Mining_Type,isnull(tdh.REMARKS,'')as REMARKS,isnull(tdh.COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS  from dbo.TRIP_DETAILS_HISTORY tdh  "
			+ "left outer join AMS.dbo.VEHICLE_CLIENT vc on tdh.SYSTEM_ID=vc.SYSTEM_ID and tdh.CUSTOMER_ID=vc.CLIENT_ID and tdh.ASSET_NUMBER=vc.REGISTRATION_NUMBER "
			+ "left outer join ADMINISTRATOR.dbo.ASSET_GROUP a on vc.SYSTEM_ID=a.SYSTEM_ID and vc.CLIENT_ID=a.CUSTOMER_ID and vc.GROUP_ID=a.GROUP_ID  "
			+ "left outer join  dbo.tblVehicleMaster tvm on tvm.System_id=tdh.SYSTEM_ID and tvm.VehicleNo=tdh.ASSET_NUMBER "
			+ "where tdh.ISSUE_DATE between ? and ? and tdh.SYSTEM_ID=? order by Trip_Issued_DateAndTime desc";

	public static final String GET_TRIP_SHEET_REPORT_DETAILS_FOR_ALL_GROUPID = "select isnull(td.TRIP_NO,'')as Trip_Sheet_No,isnull(td.ISSUE_DATE,'')as Trip_Issued_DateAndTime,isnull(td.START_TIME,'') as Trip_Closed_DateAndTime,isnull(td.STATUS,'')as Trip_Sheet_Status,isnull(td.TC_NO,'')as TC_NO,isnull(td.ASSET_NUMBER,'')as ASSET_NUMBER,isnull(tvm.VehicleType,'')as Asset_Type,isnull(td.DRIVER_NAME,'')as DRIVER_NAME,"
			+ "isnull(td.START_LOCATION,'')as START_LOCATION,td.QUANTITY as Quantity_At_Source, isnull(td.QUANTITY,'')as Quantity_At_Destination,isnull(td.ROUTE_ID,'')as ROUTE_ID,isnull(td.END_LOCATION,'')as Destination,isnull(td.MATERIAL,'')as Mining_Type,isnull(td.REMARKS,'')as REMARKS,isnull(td.COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS from dbo.TRIP_DETAILS td "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER "
			+ "inner join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= td.ASSET_NUMBER and vc.SYSTEM_ID=td.SYSTEM_ID  and vc.CLIENT_ID=td.CUSTOMER_ID "
			+ "inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id "
			+ "where td.ISSUE_DATE between ? and ? and td.CUSTOMER_ID=? and td.SYSTEM_ID=? and vc.GROUP_ID=? and vu.User_id=?  "
			+ "UNION ALL "
			+ "select isnull(tdh.TRIP_NO,'')as Trip_Sheet_No,isnull(tdh.ISSUE_DATE,'')as Trip_Issued_DateAndTime,isnull(tdh.START_TIME,'') as Trip_Closed_DateAndTime,isnull(tdh.STATUS,'')as Trip_Sheet_Status,isnull(tdh.TC_NO,'')as TC_NO,isnull(tdh.ASSET_NUMBER,'')as ASSET_NUMBER,isnull(tvm.VehicleType,'')as Asset_Type,isnull(tdh.DRIVER_NAME,'')as DRIVER_NAME,isnull(tdh.START_LOCATION,'')as START_LOCATION,tdh.QUANTITY as Quantity_At_Source,isnull(tdh.QUANTITY,'')as Quantity_At_Destination,"
			+ "isnull(tdh.ROUTE_ID,'')as ROUTE_ID,isnull(tdh.END_LOCATION,'')as Destination,isnull(tdh.MATERIAL,'')as Mining_Type,isnull(tdh.REMARKS,'')as REMARKS,isnull(tdh.COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS  from dbo.TRIP_DETAILS_HISTORY tdh  "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=tdh.SYSTEM_ID and tvm.VehicleNo=tdh.ASSET_NUMBER "
			+ "inner join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= tdh.ASSET_NUMBER and vc.SYSTEM_ID=tdh.SYSTEM_ID and vc.CLIENT_ID=tdh.CUSTOMER_ID "
			+ "inner join AMS.dbo.Vehicle_User vu on vc.REGISTRATION_NUMBER = vu.Registration_no and vc.SYSTEM_ID=vu.System_id "
			+ "where tdh.ISSUE_DATE between ? and ? and tdh.CUSTOMER_ID=? and tdh.SYSTEM_ID=? and vc.GROUP_ID=? and vu.User_id=? ";

	public static final String GET_TRIP_SHEET_REPORT_DETAILS_FOR_EACH_VEHICLE = "select isnull(td.TRIP_NO,'')as Trip_Sheet_No,isnull(td.ISSUE_DATE,'')as Trip_Issued_DateAndTime,isnull(td.START_TIME,'') as Trip_Closed_DateAndTime,isnull(td.STATUS,'')as Trip_Sheet_Status,isnull(td.TC_NO,'')as TC_NO,isnull(td.ASSET_NUMBER,'')as ASSET_NUMBER,isnull(tvm.VehicleType,'')as Asset_Type,isnull(td.DRIVER_NAME,'')as DRIVER_NAME,isnull(td.START_LOCATION,'')as START_LOCATION,td.QUANTITY as Quantity_At_Source,"
			+ "isnull(td.QUANTITY,'')as Quantity_At_Destination,isnull(td.ROUTE_ID,'')as ROUTE_ID,isnull(td.END_LOCATION,'')as Destination,isnull(td.MATERIAL,'')as Mining_Type,isnull(td.REMARKS,'')as REMARKS,isnull(td.COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS from dbo.TRIP_DETAILS td "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and tvm.VehicleNo=td.ASSET_NUMBER "
			+ "where td.ASSET_NUMBER in (#) and td.ISSUE_DATE between ? and ? and td.CUSTOMER_ID=? and td.SYSTEM_ID=? "
			+ "UNION ALL "
			+ "select isnull(tdh.TRIP_NO,'')as Trip_Sheet_No,isnull(tdh.ISSUE_DATE,'')as Trip_Issued_DateAndTime,isnull(tdh.START_TIME,'') as Trip_Closed_DateAndTime,isnull(tdh.STATUS,'')as Trip_Sheet_Status,isnull(tdh.TC_NO,'')as TC_NO,isnull(tdh.ASSET_NUMBER,'')as ASSET_NUMBER,isnull(tvm.VehicleType,'')as Asset_Type,isnull(tdh.DRIVER_NAME,'')as DRIVER_NAME,isnull(tdh.START_LOCATION,'')as START_LOCATION,"
			+ "tdh.QUANTITY as Quantity_At_Source,isnull(tdh.QUANTITY,'')as Quantity_At_Destination,isnull(tdh.ROUTE_ID,'')as ROUTE_ID,isnull(tdh.END_LOCATION,'')as Destination,isnull(tdh.MATERIAL,'')as Mining_Type,isnull(tdh.REMARKS,'')as REMARKS,isnull(tdh.COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS "
			+ "from dbo.TRIP_DETAILS_HISTORY tdh "
			+ "inner join  dbo.tblVehicleMaster tvm on tvm.System_id=tdh.SYSTEM_ID and tvm.VehicleNo=tdh.ASSET_NUMBER "
			+ "where tdh.ASSET_NUMBER in (#) and tdh.ISSUE_DATE between ? and ? and tdh.CUSTOMER_ID=? and tdh.SYSTEM_ID=? ";

	//-------------------------------------------------for MINING OVER SPEED REPORT---------------------------------------//

	public static final String GET_MINING_OVERSPEED_REPORT_DETAILS_FOR_ALL = "select mod.ID as ID,isnull(mod.REGISTRATION_NO,'')as Asset_No,isnull(a.GROUP_NAME,'')as Group_Name,dateadd(mi,?,mod.DATE)as DATE,isnull(mod.GPS_DATETIME,'')as GPS_DATETIME,isnull(mod.GMT,'')as GMT,isnull(mod.LATITUDE,'')as LATITUDE,"
			+ "isnull(mod.LONGITUDE,'')as LONGITUDE,isnull(mod.LOCATION,'')as LOCATION,isnull(mod.SPEED,'')as SPEED,isnull(mod.OS_LIMIT,'')as OS_LIMIT,isnull(mod.TRIP_NO,'')as TRIP_NUMBER from ALERT.dbo.MINING_OVERSPEED_DATA mod "
			+ "inner join ADMINISTRATOR.dbo.ASSET_GROUP a on mod.SYSTEM_ID=a.SYSTEM_ID and mod.CUSTOMER_ID=a.CUSTOMER_ID and mod.GROUP_ID=a.GROUP_ID "
			+ "inner join AMS.dbo.Vehicle_User vu on mod.SYSTEM_ID=vu.System_id  and mod.REGISTRATION_NO = vu.Registration_no COLLATE DATABASE_DEFAULT "
			+ "where mod.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and mod.SYSTEM_ID=? and vu.User_id=?";

	public static final String GET_MINING_OVERSPEED_REPORT_DETAILS_FOR_ALL_GROUPID = "select mod.ID as ID,isnull(mod.REGISTRATION_NO,'')as Asset_No,isnull(a.GROUP_NAME,'')as Group_Name,dateadd(mi,?,mod.DATE)as DATE,isnull(mod.GPS_DATETIME,'')as GPS_DATETIME,isnull(mod.GMT,'')as GMT,isnull(mod.LATITUDE,'')as LATITUDE,"
			+ "isnull(mod.LONGITUDE,'')as LONGITUDE,isnull(mod.LOCATION,'')as LOCATION,isnull(mod.SPEED,'')as SPEED,isnull(mod.OS_LIMIT,'')as OS_LIMIT,isnull(mod.TRIP_NO,'')as TRIP_NUMBER from ALERT.dbo.MINING_OVERSPEED_DATA mod "
			+ "inner join ADMINISTRATOR.dbo.ASSET_GROUP a on mod.SYSTEM_ID=a.SYSTEM_ID and mod.CUSTOMER_ID=a.CUSTOMER_ID and mod.GROUP_ID=a.GROUP_ID "
			+ "inner join AMS.dbo.Vehicle_User vu on mod.SYSTEM_ID=vu.System_id  and mod.REGISTRATION_NO = vu.Registration_no COLLATE DATABASE_DEFAULT "
			+ "where mod.DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and mod.SYSTEM_ID=? and mod.CUSTOMER_ID=? and mod.GROUP_ID=? and vu.User_id=?";

	//---------------------------------------------------for MINING ASSET ENROLLMENT--------------------------------------------//	
	public static final String GET_MINING_ASSET_ENROLLMENT_DETAILS = "select isnull(ROADTAX_VALIDITY_DATE,'') as ROADTAX_VALIDITY_DATE,isnull(PERMIT_VALIDITY_DATE,'') as PERMIT_VALIDITY_DATE,a.ID,isnull(a.ENROLLMENT_NUMBER,'') as ENROLLMENT_NUMBER,a.ENROLLMENT_DATE,a.ASSET_NUMBER,a.REGISTRATION_DATE,isnull(a.ENGINE_NUMBER,'') as ENGINE_NUMBER,a.CARRIAGE_CAPACITY,isnull(a.OPERATING_ON_MINE,'')as OPERATING_ON_MINE,"
			+ "isnull(a.LOCATION,'')as LOCATION,isnull(a.MINING_LEASE_NO,'')as MINING_LEASE_NO,isnull(a.CHASSIS_NO,'')as CHASSIS_NO,isnull(a.INSURANCE_POLICY_NO ,'')as INSURANCE_POLICY_NO ,isnull(a.INSURANCE_EXPIRY_DATE  ,'')as INSURANCE_EXPIRY_DATE , isnull(a.PUC_NUMBER,'')as PUC_NUMBER, isnull(a.PUC_EXPIRY_DATE ,'')as PUC_EXPIRY_DATE ,a.OWNER_NAME,isnull(a.ASSEMBLY_CONSTITUENCY,'')as ASSEMBLY_CONSTITUENCY,isnull(a.HOUSE_NO,'')as HOUSE_NO,isnull(a.LOCALITY,'')as LOCALITY,isnull(a.CITY_OR_VILLAGE,'')as CITY_OR_VILLAGE,"
			+ "isnull(a.TALUKA,'')as TALUKA,a.DISTRICT as DISTRICT_ID,a.STATE as STATE_ID,isnull(d.DISTRICT_NAME,'') as DISTRICT,c.STATE_NAME as STATE,isnull(a.EPIC_NO,'')as EPIC_NO,isnull(a.PAN_NO,'')as PAN_NO,a.MOBILE_NO,a.PHONE_NO,isnull(a.AADHAR_NO,'')as AADHAR_NO,isnull(a.BANK,'')as BANK,isnull(a.BRANCH,'')as BRANCH,a.PRINCIPAL_BALANCE,a.PRINCIPAL_OVER_DUES,"
			+ "a.INTEREST_BALANCE,isnull(a.ACCOUNT_NO,'')as ACCOUNT_NO,a.STATUS,isnull(a.CHALLAN_NO,'')as CHALLAN_NO,isnull(a.CHALLAN_DATE,'')as CHALLAN_DATE,a.BANK_TRANSACTION_NUMBER,a.AMOUNT_PAID,isnull(a.VALIDITY_DATE,'')as VALIDITY_DATE,(CASE WHEN a.STATUS='Active' THEN isnull(b.Firstname+' '+b.Lastname,'') ELSE '' END)as ACKNOWLEDGE_NAME, isnull(a.STATUS,'') as STATUS, isnull(a.REASON,'') as REASON from AMS.dbo.MINING_ASSET_ENROLLMENT a  "
			+ "left outer join AMS.dbo.Users b on b.System_id=a.SYSTEM_ID  and b.User_id=a.ACKNOWLEDGE_BY "
			+ "left outer join ADMINISTRATOR.dbo.STATE_DETAILS c on a.STATE=c.STATE_CODE "
			+ "left outer join AMS.dbo.DISTRICT_MASTER d on a.DISTRICT=d.DISTRICT_ID "
			+ "where SYSTEM_ID=? and CUSTOMER_ID=? order by ENROLLMENT_NUMBER";

	public static final String GET_ASSET_NO_VALIDATE = "select ASSET_NUMBER from AMS.dbo.MINING_ASSET_ENROLLMENT where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=?";

	public static final String GET_ENROLLMENT_NUMBER = "select VALUE,YEAR from AMS.dbo.MINING_LOOKUP_DETAILS where TYPE=? and SYSTEM_ID=? and CUSTOMER_ID=? and YEAR=? ";

	public static final String UPDATE_ENROLLMENT_NO_TO_LOOKUP = " update AMS.dbo.MINING_LOOKUP_DETAILS set VALUE=? WHERE TYPE=? and SYSTEM_ID=? and CUSTOMER_ID=? and YEAR=? ";

	public static final String INSERT_ENROLLMENT_NUMBER_TO_LOOKUP = "INSERT INTO AMS.dbo.MINING_LOOKUP_DETAILS (TYPE,VALUE,YEAR,SYSTEM_ID,CUSTOMER_ID)values(?,?,?,?,?)";

	public static final String SAVE_MINING_ASSET_ENROLLMENT_INFORMATION = "INSERT INTO AMS.dbo.MINING_ASSET_ENROLLMENT (ENROLLMENT_NUMBER,ASSET_NUMBER,REGISTRATION_DATE,CARRIAGE_CAPACITY,OPERATING_ON_MINE,LOCATION,MINING_LEASE_NO,CHASSIS_NO,INSURANCE_POLICY_NO, "
			+ " INSURANCE_EXPIRY_DATE,PUC_NUMBER,PUC_EXPIRY_DATE,OWNER_NAME,ASSEMBLY_CONSTITUENCY,HOUSE_NO,LOCALITY,CITY_OR_VILLAGE,TALUKA,DISTRICT,STATE,EPIC_NO,PAN_NO,MOBILE_NO,"
			+ "PHONE_NO,AADHAR_NO,ENROLLMENT_DATE,BANK,BRANCH,PRINCIPAL_BALANCE,PRINCIPAL_OVER_DUES,INTEREST_BALANCE,ACCOUNT_NO,ENGINE_NUMBER,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,ROADTAX_VALIDITY_DATE,PERMIT_VALIDITY_DATE)"
			+ "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	public static final String MOVED_CHALLAN_EXPIRED_DATA_TO_HISTORY = "INSERT INTO AMS.dbo.MINING_ASSET_ENROLLMENT_HISTORY (ENROLLMENT_NUMBER,ASSET_NUMBER,REGISTRATION_DATE,CARRIAGE_CAPACITY,OPERATING_ON_MINE,LOCATION,MINING_LEASE_NO,CHASSIS_NO,OWNER_NAME,ASSEMBLY_CONSTITUENCY,HOUSE_NO,LOCALITY,CITY_OR_VILLAGE,TALUKA,"
			+ "DISTRICT,STATE,EPIC_NO,PAN_NO,MOBILE_NO,PHONE_NO,AADHAR_NO,ENROLLMENT_DATE,BANK,BRANCH,PRINCIPAL_BALANCE,PRINCIPAL_OVER_DUES,INTEREST_BALANCE,ACCOUNT_NO,CHALLAN_NO,CHALLAN_DATE,BANK_TRANSACTION_NUMBER,AMOUNT_PAID,VALIDITY_DATE,STATUS,ID,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY)"
			+ "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	public static final String MODIFY_ASSET_ENROLLMENT_NO_INFORMATION = " UPDATE AMS.dbo.MINING_ASSET_ENROLLMENT SET OPERATING_ON_MINE=?,LOCATION=?,MINING_LEASE_NO=?,CHASSIS_NO=?,INSURANCE_POLICY_NO=?,INSURANCE_EXPIRY_DATE=?,PUC_NUMBER=?,PUC_EXPIRY_DATE=?,HOUSE_NO=?,LOCALITY=?,CITY_OR_VILLAGE=?,TALUKA=?,EPIC_NO=?, "
			+ " PAN_NO=?,MOBILE_NO=?,PHONE_NO=?,AADHAR_NO=?,BANK=?,BRANCH=?,PRINCIPAL_BALANCE=?,PRINCIPAL_OVER_DUES=?,INTEREST_BALANCE=?,ACCOUNT_NO=?,UPDATED_BY=?,UPDATED_DATETIME=getutcdate(),ENGINE_NUMBER=?,ASSEMBLY_CONSTITUENCY=?,ROADTAX_VALIDITY_DATE=?, "
			+ " PERMIT_VALIDITY_DATE=? WHERE SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String GET_CHALLEN_NO_VALIDATE = "select CHALLAN_NO from AMS.dbo.MINING_ASSET_ENROLLMENT where SYSTEM_ID=? and CUSTOMER_ID=? and CHALLAN_NO=? ";

	public static final String SAVE_ACKNOWLEDGEMENT_INFORMATION = "UPDATE AMS.dbo.MINING_ASSET_ENROLLMENT SET CHALLAN_NO=?,CHALLAN_DATE=?,BANK_TRANSACTION_NUMBER=?,AMOUNT_PAID=?,VALIDITY_DATE=?,STATUS='Active',ACKNOWLEDGE_BY=?,ACKNOWLEDGE_DATETIME=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String GET_DATA_FOR_PDF = "select a.ID,a.ENROLLMENT_NUMBER as ENROLLMENT_NUMBER,a.ENROLLMENT_DATE,a.ASSET_NUMBER,a.REGISTRATION_DATE,a.CARRIAGE_CAPACITY,isnull(a.CHASSIS_NO,'')as CHASSIS_NO,isnull(a.INSURANCE_POLICY_NO ,'')as INSURANCE_POLICY_NO,isnull(a.INSURANCE_EXPIRY_DATE,'')as INSURANCE_EXPIRY_DATE,isnull(a.PUC_NUMBER,'')as PUC_NUMBER,isnull(a.PUC_EXPIRY_DATE,'')as PUC_EXPIRY_DATE, a.OWNER_NAME,isnull(a.HOUSE_NO,'')as HOUSE_NO,isnull(a.ASSEMBLY_CONSTITUENCY,'')as ASSEMBLY_CONSTITUENCY,isnull(a.LOCALITY,'')as LOCALITY,"
			+ "isnull(a.CITY_OR_VILLAGE,'')as CITY_OR_VILLAGE,isnull(a.TALUKA,'')as TALUKA,d.DISTRICT_NAME as DISTRICT,c.STATE_NAME as STATE,isnull(a.EPIC_NO,'')as EPIC_NO,isnull(a.PAN_NO,'')as PAN_NO,a.MOBILE_NO,isnull(a.AADHAR_NO,'')as AADHAR_NO, isnull(vm.VehicleType,'')as VEHICLE_TYPE from AMS.dbo.MINING_ASSET_ENROLLMENT a "
			+ "left outer join AMS.dbo.tblVehicleMaster vm on VehicleNo=a.ASSET_NUMBER and vm.System_id=a.SYSTEM_ID "
			+ "left outer join ADMINISTRATOR.dbo.STATE_DETAILS c on a.STATE=c.STATE_CODE "
			+ "left outer join AMS.dbo.DISTRICT_MASTER d on a.DISTRICT=d.DISTRICT_ID "
			+ "where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? and STATUS<>'Completed' ";

	public static final String GET_DATA_FOR_PDF_ACKNOWLEDGEMENT = "select ENROLLMENT_NUMBER,ENROLLMENT_DATE,isnull(ASSET_NUMBER,'') as ASSET_NUMBER,isnull(OWNER_NAME,'')as OWNER_NAME,isnull(ASSEMBLY_CONSTITUENCY,'')as ASSEMBLY_CONSTITUENCY,isnull(CHALLAN_NO,'') as CHALLAN_NO,"
			+ "isnull(CHALLAN_DATE,'')as CHALLAN_DATE,BANK_TRANSACTION_NUMBER,AMOUNT_PAID,isnull(VALIDITY_DATE,'')as VALIDITY_DATE from AMS.dbo.MINING_ASSET_ENROLLMENT "
			+ "where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER= ? and STATUS<>'Completed' ";
	//---------------------------------------------------Mining TRIP SHEET GENERATION---------------------------------------------------//

	public static final String GET_VEHILCE_NO_FOR_TRIP_SHEET_GEN = "select CASE when datediff(dd,PUC_EXPIRY_DATE,getdate())<=0 THEN 'True' ELSE 'False' END as PUC_EXPIRED_STATUS,CASE WHEN datediff(dd,INSURANCE_EXPIRY_DATE,getdate())<=0 THEN 'True' ELSE 'False' END as INSURANCE_EXPIRED_STATUS,a.ASSET_NUMBER as VID,a.ASSET_NUMBER as VNAME , e.TARE_WEIGHT_1 as QUANTITY1,isnull(c.LoadCapacity,0) as LOADCAPACITY "
			+ " from AMS.dbo.MINING_ASSET_ENROLLMENT a (NOLOCK) "
			+ " inner join AMS.dbo.tblVehicleMaster c (NOLOCK) on c.System_id=a.SYSTEM_ID and a.ASSET_NUMBER=c.VehicleNo and c.Status=a.STATUS   "
			+ " inner join AMS.dbo.MINING_TARE_WEIGHT_MASTER e (NOLOCK) on e.SYSTEM_ID=a.SYSTEM_ID  and e.CUSTOMER_ID=a.CUSTOMER_ID and e.ASSET_NUMBER=a.ASSET_NUMBER "
			+ " and e.WEIGHT_DATETIME=(select max(WEIGHT_DATETIME) from AMS.dbo.MINING_TARE_WEIGHT_MASTER (NOLOCK) where SYSTEM_ID=a.SYSTEM_ID and e.CUSTOMER_ID=a.CUSTOMER_ID and ASSET_NUMBER=a.ASSET_NUMBER) "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='Active' and a.VALIDITY_DATE >=Convert(varchar, GETDATE(),111) and c.VehicleType!='BARGE' "
			+ " and (a.TRIP_STATUS='CLOSE' or a.TRIP_STATUS is null) "
			+ " group by a.ASSET_NUMBER, e.TARE_WEIGHT_1,c.LoadCapacity,INSURANCE_EXPIRY_DATE,PUC_EXPIRY_DATE ";

	public static final String GET_ROUTE_NAME_FOR_TRIP_SHEET_GEN = " select rd.ID as ROUTE_ID,ROUTE_NAME as ROUTE_NAME,lz.NAME as FROM_LOCATION,lz1.NAME as TO_LOCATION, "
			+ " (case when rd.DESTINATION_HUB_ID in (select HUB_ID from MINING.dbo.PLANT_MASTER where SYSTEM_ID=? AND CUSTOMER_ID=? and ORGANIZATION_ID=?) then 'TRUE' else 'FALSE'  end) as STATUS "
			+ " from MINING.dbo.ROUTE_DETAILS rd " + " left outer join LOCATION_ZONE_A lz on rd.SOURCE_HUB_ID=lz.HUBID "
			+ " left outer join LOCATION_ZONE_A lz1 on rd.DESTINATION_HUB_ID=lz1.HUBID "
			+ " where SYSTEM_ID=? AND CUSTOMER_ID=? and ORG_ID=? and TOTAL_TRIPSHEET_COUNT > 0 ";

	public static final String GET_GRADE_FOR_TRIP_SHEET_GEN = "select ID as GRADE_ID,(isnull(GRADE,'')+'('+isnull(TYPE,'')+')') as GRADE_NAME from AMS.dbo.MINING_GRADE_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_TCNAME_FOR_TRIP_SHEET_GEN = "select ID as TC_NAME_ID,LESSE_NAME as TC_LEASE_NAME from MINING_TC_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_VEHICLE_NUMBER_BASED_ON_RFID = " select CASE when datediff(dd,PUC_EXPIRY_DATE,getdate())<=0 THEN 'True' ELSE 'False' END as PUC_EXPIRED_STATUS,CASE WHEN datediff(dd,INSURANCE_EXPIRY_DATE,getdate())<=0 THEN 'True' ELSE 'False' END as INSURANCE_EXPIRED_STATUS,a.VehicleNo,e.TARE_WEIGHT_1 as QUANTITY1,isnull(a.LoadCapacity,0) as LOADCAPACITY from AMS.dbo.tblVehicleMaster a "
			+ " inner join AMS.dbo.MINING_ASSET_ENROLLMENT c (NOLOCK) on c.SYSTEM_ID=a.System_id and c.ASSET_NUMBER=a.VehicleNo "
			+ " inner join AMS.dbo.MINING_TARE_WEIGHT_MASTER e (NOLOCK) on e.ASSET_NUMBER=a.VehicleNo and e.SYSTEM_ID=a.System_id and "
			+ " e.WEIGHT_DATETIME=(select max(WEIGHT_DATETIME) from AMS.dbo.MINING_TARE_WEIGHT_MASTER (NOLOCK) where ASSET_NUMBER=a.VehicleNo and SYSTEM_ID=a.System_id ) "
			+ " where a.System_id=? and c.CUSTOMER_ID=? and a.Status='Active' and a.Gps_unit_number=? "
			+ " and a.VehicleNo collate database_default not in (select ASSET_NUMBER from MINING.dbo.TRUCK_TRIP_DETAILS (NOLOCK) where SYSTEM_ID=? "
			+ " and CUSTOMER_ID=? and STATUS='OPEN') ";

	public static final String GET_MINING_TRIP_SHEET_GENERATION_DETAILS = " (select isnull(OPENING_LOCATION,'') as OPENING_LOCATION,isnull(CLOSING_LOCATION,'') as CLOSING_LOCATION,isnull(OPENING_DATETIME,'') as OPENING_DATETIME,isnull(CLOSING_DATETIME,'') as CLOSING_DATETIME,isnull(REASON,'') AS REASON,isnull(COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS,isnull(dateadd(mi,330,a.INSERTED_TIME),'') as ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER, "
			+ " isnull(b.LESSE_NAME,'') as LESSE_NAME,isnull(a.VALIDITY_DATE,'')as VALIDITY_DATE,isnull(a.GRADE,'')as GRADE_NAME,isnull(a.QUANTITY,'')as QUANTITY2,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME, "
			+ " a.TC_ID ,a.ROUTE_ID,isnull(a.RMK_ORDER,'') as DRIVER_NAME,a.STATUS,isnull(a.QUANTITY3,0)as QUANTITY3,isnull(a.QUANTITY4,0)as QUANTITY4,isnull(a.QUANTITY1,0)as QUANTITY1,isnull(pd.PERMIT_NO,0)as PERMIT_ID,pd.ID as PID, isnull(pd.MINERAL,'')as MINERAL_TYPE,"
			+ " isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME, "
			+ " isnull(dateadd(mi,330,a.CLOSED_DATETIME),'') as CLOSED_DATETIME,isnull(u.USER_NAME,'') as WBS,isnull(ue.USER_NAME,'') as WBD,isnull(a.DESTINATION_TYPE,'') as DESTINATION_TYPE,isnull(a.CLOSING_TYPE,'') as CLOSING_TYPE,isnull(a.DS_DESTINATION,'') as DS_DESTINATION,isnull(a.BARGE_TRANSACTION_ID,'') as TRANSACTION_ID,isnull(a.DS_SOURCE,'') as DS_SOURCE, "
			+ " isnull(a.ISSUED_BY,0)as ISSUED_BY,CASE WHEN datediff(ss,dateadd(ss,0,INSERTED_TIME),getutcdate())<=300 THEN 'T' ELSE 'F' END as CLIENT_CLOSABLE from MINING.dbo.TRUCK_TRIP_DETAILS a "
			+ " left outer join AMS.dbo.MINING_TC_MASTER b on a.TC_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=a.ORGANIZATION_ID and mm.SYSTEM_ID=a.SYSTEM_ID and mm.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS pd on pd.ID=a.PERMIT_ID and pd.SYSTEM_ID=a.SYSTEM_ID and pd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=a.ISSUED_BY "
			+ " left outer join ADMINISTRATOR.dbo.USERS ue on ue.SYSTEM_ID=a.SYSTEM_ID and ue.USER_ID=a.CLOSED_BY "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? & "
			+ " and a.INSERTED_TIME between dateadd(mi,-330,?) and dateadd(mi,-330,?) and "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union "
			+ " select isnull(OPENING_LOCATION,'') as OPENING_LOCATION,isnull(CLOSING_LOCATION,'') as CLOSING_LOCATION,isnull(OPENING_DATETIME,'') as OPENING_DATETIME,isnull(CLOSING_DATETIME,'') as CLOSING_DATETIME,isnull(REASON,'') AS REASON,isnull(COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS,isnull(dateadd(mi,330,a.INSERTED_TIME),'') as ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER, "
			+ " isnull(b.LESSE_NAME,'') as LESSE_NAME,isnull(a.VALIDITY_DATE,'')as VALIDITY_DATE,isnull(a.GRADE,'')as GRADE_NAME,isnull(a.QUANTITY,'')as QUANTITY2,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME, "
			+ " a.TC_ID ,a.ROUTE_ID,isnull(a.RMK_ORDER,'') as DRIVER_NAME,a.STATUS,isnull(a.QUANTITY3,0)as QUANTITY3,isnull(a.QUANTITY4,0)as QUANTITY4, "
			+ " isnull(a.QUANTITY1,0)as QUANTITY1,isnull(pd.PERMIT_NO,0)as PERMIT_ID,pd.ID as PID,isnull(pd.MINERAL,'')as MINERAL_TYPE,isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY, "
			+ " isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(dateadd(mi,330,a.CLOSED_DATETIME),'') as CLOSED_DATETIME,isnull(u.USER_NAME,'') as WBS,isnull(ue.USER_NAME,'') as WBD,isnull(a.DESTINATION_TYPE,'') as DESTINATION_TYPE,isnull(a.CLOSING_TYPE,'') as CLOSING_TYPE,isnull(a.DS_DESTINATION,'') as DS_DESTINATION,isnull(a.BARGE_TRANSACTION_ID,'') as TRANSACTION_ID,isnull(a.DS_SOURCE,'') as DS_SOURCE, "
			+ " isnull(a.ISSUED_BY,0)as ISSUED_BY,'F' as CLIENT_CLOSABLE from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY a "
			+ " left outer join AMS.dbo.MINING_TC_MASTER b on a.TC_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=a.ORGANIZATION_ID and mm.SYSTEM_ID=a.SYSTEM_ID and mm.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS pd on pd.ID=a.PERMIT_ID and pd.SYSTEM_ID=a.SYSTEM_ID and pd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=a.ISSUED_BY "
			+ " left outer join ADMINISTRATOR.dbo.USERS ue on ue.SYSTEM_ID=a.SYSTEM_ID and ue.USER_ID=a.CLOSED_BY "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? & and a.INSERTED_TIME between dateadd(mi,-330,?) and dateadd(mi,-330,?) "
			+ " and (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))) "
			+ " order by ID desc ";

	public static final String UPDATE_ROM_QTY_IN_MASTER = "update AMS.dbo.MINING_STOCKYARD_MASTER set ROM_QTY=isnull(ROM_QTY,0)+? where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=? and ORGANIZATION_ID=? and MINERAL_TYPE=?  ";

	public static final String SAVE_MINING_TRIP_SHEET_INFORMATION = "INSERT INTO MINING.dbo.TRUCK_TRIP_DETAILS (TRIP_NO,TYPE,ASSET_NUMBER,TC_ID,VALIDITY_DATE,GRADE,QUANTITY,ROUTE_ID,SYSTEM_ID,CUSTOMER_ID,STATUS,QUANTITY1,SOURCE_HUBID,DESTINATION_HUBID,PERMIT_ID,ISSUED_BY,USER_SETTING_ID,ORGANIZATION_ID,DS_SOURCE,DS_DESTINATION,BARGE_TRANSACTION_ID,TRIP_COUNT,COMMUNICATION_STATUS,RMK_ORDER,OPENING_LOCATION,OPENING_DATETIME)VALUES(?,?,?,?,?,?,?,?,?,?,'OPEN',?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)  ";

	public static final String MODIFY_TRIP_SHEET_NO_INFORMATION = "UPDATE MINING.dbo.TRUCK_TRIP_DETAILS SET VALIDITY_DATE=?,GRADE=?,ROUTE_ID=?,RMK_ORDER=? WHERE SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String GET_TRIP_DATA_FOR_PDF_MODIFY = "select (case when isnull(mm.GST_NO,'')='' then isnull(mm1.GST_NO,'') else isnull(mm.GST_NO,'') end) as GST_NO,isnull(rd.DISTANCE,0) as DISTANCE,wm.WEIGHBRIDGE_ID,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER,isnull(b.LESSE_NAME,'') as LESSE_NAME,isnull(mm.ORGANIZATION_NAME,'') as ORGANIZATION_NAME,"
			+ "isnull(dateadd(mi,330,a.INSERTED_TIME),'') as ISSUE_DATE,isnull(a.VALIDITY_DATE,'')as VALIDITY_DATE,isnull(a.GRADE,'')as GRADE_NAME,isnull(a.QUANTITY,'')as QUANTITY,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME,lz3.NAME as SOURCE,lz4.NAME as DESTINATION,isnull(lz1.NAME,'') as SOURCE_HUB,isnull(lz2.NAME,'') as DESTINATION_HUB,isnull(a.QUANTITY1,0)as TARE_WEIGHT,(isnull(a.QUANTITY,0)-isnull(a.QUANTITY1,0)) as TOTAL_QUANTITY,isnull(DS_SOURCE,'') as DS_SOURCE, "
			+ " isnull(DS_DESTINATION,'') as DS_DESTINATION,isnull(BARGE_TRANSACTION_ID,'') as TRANSACTION_ID from MINING.dbo.TRUCK_TRIP_DETAILS a "
			+ "left outer join AMS.dbo.MINING_TC_MASTER b on a.TC_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=b.MINE_ID and b.SYSTEM_ID=c.SYSTEM_ID and b.CUSTOMER_ID=c.CUSTOMER_ID   "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ "left outer join MINING.dbo.WEIGHBRIDGE_MASTER wm on wm.ID=a.SOURCE_HUBID and wm.SYSTEM_ID=a.SYSTEM_ID and wm.CUSTOMER_ID=a.CUSTOMER_ID "
			+ "left outer join LOCATION_ZONE lz1 on lz1.HUBID=a.SOURCE_HUBID AND lz1.CLIENTID=a.CUSTOMER_ID AND lz1.SYSTEMID=a.SYSTEM_ID "
			+ "left outer join LOCATION_ZONE lz2 on lz2.HUBID=a.DESTINATION_HUBID AND lz2.CLIENTID=a.CUSTOMER_ID AND lz2.SYSTEMID=a.SYSTEM_ID "
			+ "left outer join LOCATION_ZONE lz3 on lz3.HUBID=rd.SOURCE_HUB_ID AND lz3.CLIENTID=rd.CUSTOMER_ID AND lz3.SYSTEMID=rd.SYSTEM_ID "
			+ "left outer join LOCATION_ZONE lz4 on lz4.HUBID=rd.DESTINATION_HUB_ID AND lz4.CLIENTID=rd.CUSTOMER_ID AND lz4.SYSTEMID=rd.SYSTEM_ID "
			+ "left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on a.SYSTEM_ID=mm.SYSTEM_ID and a.CUSTOMER_ID=mm.CUSTOMER_ID and mm.ID=a.ORGANIZATION_ID "
			+ "left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm1 on c.SYSTEM_ID=mm1.SYSTEM_ID and c.CUSTOMER_ID=mm1.CUSTOMER_ID and mm1.ID=c.ORG_ID  "
			+ "WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.ASSET_NUMBER=? and a.ID=? ";
	//****************************************************Grade Master Details Statements :Start******************************************************//
	public static final String GET_GRADE_MASTER_DETAILS = "select ID, isnull(MONTH,'')as MONTH, isnull(YEAR,'')as YEAR, isnull(GRADE,'')as GRADE,isnull(RATE,0)as RATE,isnull(MINERAL_CODE,'')as MINERAL_CODE, isnull(TYPE,'')as TYPE "
			+ "from AMS.dbo.MINING_GRADE_MASTER WHERE SYSTEM_ID=? AND CUSTOMER_ID=? order by ID desc";

	public static final String CHECK_RECORD_EXISTS = " select MONTH,YEAR,GRADE,MINERAL_CODE,TYPE from AMS.dbo.MINING_GRADE_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and MONTH=? and YEAR=? and GRADE=? and MINERAL_CODE=? and TYPE=?";

	public static final String INSERT_INTO_MASTER_DETAILS = "insert into AMS.dbo.MINING_GRADE_MASTER(MONTH,YEAR,GRADE,RATE,MINERAL_CODE,TYPE,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME)values(?,?,?,?,?,?,?,?,?,getUTCDate())";

	public static final String UPDATE_GRADE_MASTER_INFORMATION = " update AMS.dbo.MINING_GRADE_MASTER set MONTH=?,YEAR=?,GRADE=?, "
			+ " RATE=?,MINERAL_CODE=? ,TYPE=? ,UPDATED_BY=?,UPDATED_DATETIME=getUTCDate()  WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND ID=? ";

	public static final String GET_MINERAL_CODE = "select isnull(MINERAL_CODE,'')as MINERAL_CODE from AMS.dbo.MINING_MINERAL_MASTER where SYSTEM_ID=? ";

	//****************************************************Grade Master Details Statements :End******************************************************//
	//****************************************************TCMater Details Statement :Start ********************************************************//
	public static final String GET_DISTRICT = " select  isnull(DISTRICT_CODE,'') as DISTRICT_CODE, isnull(DISTRICT_NAME,'')as DISTRICT_NAMES  from ADMINISTRATOR.dbo.DISTRICT_DETAILS where STATE_CODE=? ";

	public static final String GET_TALUK = "select  isnull(TALUKA_CODE,'') as TALUKA_CODE, isnull(TALUKA_NAME,'')as TALUK_NAME  from ADMINISTRATOR.dbo.TALUKA_DETAILS where DISTRICT_CODE=? ";

	public static final String GET_TC_MASTER_DETAILS = "select isnull(a.CTO_CODE,'') as CTO_CODE,isnull(a.CTO_DATE,'') as CTO_DATE,a.ID ,isnull(a.TC_NO,'') as TC_NO ,isnull(a.LESSE_NAME,'') as LESSE_NAME , "
			+ " isnull(a.ORDER_NO,'') as ORDER_NO , isnull(a.ISSUED_DATE,'') as ISSUED_DATE , "
			+ " b.DISTRICT_NAME as DISTRICT , c.TALUKA_NAME as TALUK ,isnull(a.VILLAGE,'') as VILLAGE , "
			+ " isnull(a.AREA,0) as AREA,isnull(a.STATUS,'') as STATUS  ,isnull(a.REG_IBM,'') as REG_IBM,isnull(a.MINE_CODE,'') as MINE_CODE,"
			+ " isnull(a.NAME_OF_MINERAL,'') as NAME_OF_MINERAL,isnull(a.NAME_OF_MINE,'') as NAME_OF_MINE,isnull(a.STATE,'') as STATE_ID,isnull(s.STATE_NAME,'') as STATE_NAME,isnull(a.PIN,'') as PIN, "
			+ " isnull(a.FAX_NO,'') as FAX_NO,isnull(a.PHONE_NO,'') as PHONE_NO,isnull(a.EMAIL_ID,'') as EMAIL_ID,"
			+ " b.DISTRICT_CODE as DISTRICT_CODE , c.TALUKA_CODE as TALUK_CODE,a.EC_CAPPING_LIMIT, "
			+ " isnull(PROCESSING_PLANT,'') as PROCESSING_PLANT, isnull(WALLET_LINK,'') as WALLET_LINKED, isnull(AMOUNT,0) as ROM_CHALLAN_PAID_AMOUNT, isnull(QUANTITY,0 ) as ROM_CHALLAN_PAID_QUANTITY ,"
			+ " isnull(MPL_BALANCE,0) as MPL_BALANCE, isnull(lz.NAME,'') as HUB ,isnull(lz.HUBID,0) as HUBID, isnull(mmm.ID,0) as MINE_CODE_ID,isnull(a.MINE_NAME,'') as MINE_NAME,"
			+ " isnull(a.LEASE_AREA,0) as LEASE_AREA,isnull(YEAR,'') as YEAR,isnull(ENHANCED_MPL,0) as ENHANCED_MPL ,isnull(PRODUCTION_MPL,0) as  PRODUCTION_MPL ,isnull(CARRY_FORWARDED_MPL,0) as CARRY_FORWARDED_MPL ,isnull(TRANSPORTATION_MPL,0) as TRANSPORTATION_MPL "
			+ " from AMS.dbo.MINING_TC_MASTER a "
			+ " left outer join ADMINISTRATOR.dbo.DISTRICT_DETAILS  b on a.DISTRICT = b.DISTRICT_CODE "
			+ " left outer join ADMINISTRATOR.dbo.TALUKA_DETAILS c on b.DISTRICT_CODE=c.DISTRICT_CODE and a.TALUKA=c.TALUKA_CODE "
			+ " left outer join ADMINISTRATOR.dbo.STATE_DETAILS  s on a.STATE=s.STATE_CODE   "
			+ " left outer join AMS.dbo.LOCATION_ZONE lz on lz.HUBID = a.HUB_ID "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER mmm on mmm.ID = a.MINE_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? order by a.ID desc";

	public static final String CHECK_REG_IBM_NO = " select REG_IBM from AMS.dbo.MINING_TC_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and  REG_IBM=? # ";

	public static final String CHECK_TC_NO = " select TC_NO from AMS.dbo.MINING_TC_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? AND TC_NO=? ";

	public static final String INSERT_INTO_TCMASTER_DETAILS = "insert into AMS.dbo.MINING_TC_MASTER(TC_NO,LESSE_NAME,ORDER_NO,ISSUED_DATE,DISTRICT,TALUKA,VILLAGE,AREA,STATUS,SYSTEM_ID,CUSTOMER_ID,REG_IBM,MINE_CODE,NAME_OF_MINERAL,NAME_OF_MINE,STATE,PIN,FAX_NO,PHONE_NO,EMAIL_ID,INSERTED_BY,INSERTED_DATETIME,EC_CAPPING_LIMIT,PROCESSING_PLANT, WALLET_LINK, HUB_ID, MINE_ID,MINE_NAME,LEASE_AREA,YEAR,CTO_CODE,CTO_DATE,ENHANCED_MPL,PRODUCTION_MPL,CARRY_FORWARDED_MPL,TRANSPORTATION_MPL,FINANCIAL_YEAR)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getUTCDate(),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

	public static final String UPDATE_TCMASTER_INFORMATION = "update AMS.dbo.MINING_TC_MASTER set TC_NO=?,LESSE_NAME=?,ORDER_NO=?,ISSUED_DATE=?, "
			+ " DISTRICT=?,TALUKA=?,VILLAGE=?,AREA=?,STATUS=?,REG_IBM=?,MINE_CODE=?,NAME_OF_MINERAL=?,NAME_OF_MINE=?,STATE=?,PIN=?,FAX_NO=?,PHONE_NO=?,EC_CAPPING_LIMIT=?,EMAIL_ID=?,UPDATED_BY=?,UPDATED_DATETIME=getUTCDate(), "
			+ " PROCESSING_PLANT=?,WALLET_LINK=?,HUB_ID=?,MINE_ID=?,MINE_NAME=?,LEASE_AREA=?,YEAR=?,CTO_CODE=?,CTO_DATE=?,ENHANCED_MPL=?,PRODUCTION_MPL=?,CARRY_FORWARDED_MPL=?,TRANSPORTATION_MPL=? "
			+ " WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND ID=? ";

	public static final String UPDATE_TCMASTER_INFORMATION_OWNER_MASTER = "update AMS.dbo.MINE_OWNER_MASTER set YEAR=?,LEASE_NAME=?,NAME=?,STATE=?,DISTRICT=?,TALUKA=?,POST_OFFICE=?,VILLAGE=?,PIN=?,FAX_NO=?,PHONE_NO=?,EMAIL_ID=? where SYSTEM_ID=? and CUSTOMER_ID=? and TC_NO=?";

	//****************************************************TCMater Details Statement :end ********************************************************//

	//*********************************************************Mining Mine Master Details Report statements**********************************************//
	public static final String GET_MINE_MASTER_DETAILS = "select ID,isnull(MINERAL_CODE,'')as MINERAL_CODE,isnull(MINERAL_NAME,'')as MINERAL_NAME from AMS.dbo.MINING_MINERAL_MASTER WHERE SYSTEM_ID=?";

	public static final String CHECK_CODE_ALREADY_EXIST = " select MINERAL_CODE from AMS.dbo.MINING_MINERAL_MASTER where MINERAL_CODE=? and SYSTEM_ID=? ";

	public static final String CHECK_MINERAL_NAME_ALREADY_EXIST = " select MINERAL_NAME from AMS.dbo.MINING_MINERAL_MASTER where MINERAL_NAME=? and SYSTEM_ID=? ";

	public static final String INSERT_MINERALS_INFORMATION = "insert into AMS.dbo.MINING_MINERAL_MASTER (MINERAL_CODE,MINERAL_NAME,SYSTEM_ID)VALUES(?,?,?)";

	public static final String UPDATE_NAME = "update AMS.dbo.MINING_MINERAL_MASTER set MINERAL_CODE=?,MINERAL_NAME=? "
			+ " where ID=? ";

	public static final String GET_MINE_CODE_DETAILS = "select isnull(MINE_CODE,'') as MINE_CODE,isnull(ID,0) as MINE_ID,isnull(MINING_COMPANY,'') as MINE_NAME,(isnull(CARRY_FORWARDED_EC,0)+isnull(EC_LIMIT,0)+isnull(ENHANCED_EC,0)) as TOTAL_EC ,isnull((select isnull(sum(EC_CAPPING_LIMIT),0) from AMS.dbo.MINING_TC_MASTER where MINE_ID=a.ID),0) as EC_CAPPING_LIMIT,isnull(ORGANIZATION_NAME,'') as ORGANIZATION_NAME from dbo.MINING_MINE_MASTER a where SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_ORG_CODE_DETAILS = "select ID,ORGANIZATION_CODE,ORGANIZATION_NAME from dbo.MINING_ORGANIZATION_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and TYPE='ORGANIZATION' ";

	//*********************************************************Accounts Head Master Details Report statements**********************************************//
	public static final String GET_ACCOUNTS_HEAD_MASTER_DETAILS = " select ID,isnull(PAYMENT_ACC_HEAD,'')as PAYMENT_ACCOUNTS_HEAD,isnull(DESCRIPTION,'')as DESCRIPTION from AMS.dbo.ACCOUNTS_HEAD_MASTER where SYSTEM_ID = ? and CUSTOMER_ID = ? ";

	public static final String CHECK_IF_PAYMENT_ACC_ALREADY_EXIST = " select PAYMENT_ACC_HEAD from AMS.dbo.ACCOUNTS_HEAD_MASTER where PAYMENT_ACC_HEAD=? ";

	public static final String CHECK_IF_PAYMENT_ACC_ALREADY_EXISTS = " select PAYMENT_ACC_HEAD from AMS.dbo.ACCOUNTS_HEAD_MASTER where PAYMENT_ACC_HEAD=? and ID!=? ";

	public static final String INSERT_ACCOUNT_HEAD_INFORMATION = "insert into AMS.dbo.ACCOUNTS_HEAD_MASTER (PAYMENT_ACC_HEAD,DESCRIPTION,SYSTEM_ID,CUSTOMER_ID)VALUES(?,?,?,?)";

	public static final String UPDATE_ACCOUNT_HEAD_INFORMATION = "update AMS.dbo.ACCOUNTS_HEAD_MASTER set PAYMENT_ACC_HEAD=?,DESCRIPTION=? "
			+ " where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	//***************************************************Tare WEIGHT MASTER****************************************************************//

	public static final String GET_MINING_TARE_WEIGHT_DETAILS = "select isnull(ID,'')as ID,isnull(TYPE,'')as TYPE,isnull(ASSET_NUMBER,'')as ASSET_NUMBER,isnull(TARE_WEIGHT_1,'')as TARE_WEIGHT_1,isnull(WEIGHT_DATETIME,'')as WEIGHT_DATE_AND_TIME from AMS.dbo.MINING_TARE_WEIGHT_MASTER WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND WEIGHT_DATETIME BETWEEN ? AND ?  ORDER BY WEIGHT_DATETIME DESC ";

	public static final String GET_MINING_TARE_WEIGHT_DETAILS_BASED_ON_ASSET_NUMBER = "select isnull(ID,'')as ID,isnull(TYPE,'')as TYPE,isnull(ASSET_NUMBER,'')as ASSET_NUMBER,isnull(TARE_WEIGHT_1,'')as TARE_WEIGHT_1,isnull(WEIGHT_DATETIME,'')as WEIGHT_DATE_AND_TIME from AMS.dbo.MINING_TARE_WEIGHT_MASTER WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND ASSET_NUMBER=? ORDER BY WEIGHT_DATETIME DESC ";

	public static final String SAVE_MINING_TARE_WEIGHT_INFORMATION = "INSERT INTO AMS.dbo.MINING_TARE_WEIGHT_MASTER(TYPE,ASSET_NUMBER,TARE_WEIGHT_1,WEIGHT_DATETIME,SYSTEM_ID,CUSTOMER_ID)VALUES(?,?,?,getdate(),?,?);";

	public static final String MODIFY_TARE_WEIGHT_INFORMATION = "UPDATE AMS.dbo.MINING_TARE_WEIGHT_MASTER SET WEIGHT_DATETIME=? WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND ID=?";

	//***************************************************MINE OWNER MASTER****************************************************************//

	public static final String GET_TYPE = " select isnull(VALUE,'') as TYPE from  AMS.dbo.LOOKUP_DETAILS where VERTICAL='MINING_SOLUTION' and TYPE='OWNERMASTERTYPE' ";

	public static final String GET_TC_NUMBER = " select ID as TC_ID,isnull(TC_NO,'') as TC_NUMBER,isnull(YEAR,'') as YEAR,isnull(AREA,'') as AREA,isnull(NAME_OF_MINE,'') as NAME_OF_MINE,isnull(PIN,'') as PIN,isnull(FAX_NO,'')as FAX_NO,isnull(PHONE_NO,'') as PHONE_NO,isnull(EMAIL_ID,'') as EMAIL_ID,isnull(STATE,'') as STATE,isnull(TALUKA_NAME,'') as TALUKA_NAME,isnull(DISTRICT_NAME,'') as DISTRICT_NAME,isnull(VILLAGE,'') as VILLAGE,isnull(LESSE_NAME,'') as LESSE_NAME,isnull(TALUKA,'') as TALUKA_CODE,isnull(DISTRICT,'') as DISTRICT_CODE "
			+ "from AMS.dbo.MINING_TC_MASTER mtc "
			+ "inner join ADMINISTRATOR.dbo.TALUKA_DETAILS td on td.TALUKA_CODE=mtc.TALUKA "
			+ "inner join ADMINISTRATOR.dbo.DISTRICT_DETAILS dd on dd.DISTRICT_CODE=mtc.DISTRICT "
			+ "where mtc.ID not in (select ISNULL(TC_ID,0)as TC_ID from AMS.dbo.MINE_OWNER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=?) AND "
			+ "SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String INSERT_MINE_OWNER_DETAILS = " insert into AMS.dbo.MINE_OWNER_MASTER (TC_NO,TC_ID,YEAR,NAME,CONTACT_PERSON,LEASE_NAME,STATE,DISTRICT,TALUKA,VILLAGE,POST_OFFICE,ADDRESS,PIN,PHONE_NO,PAN_NO,TAN_NO,BANKER,BRANCH,SYSTEM_ID,CUSTOMER_ID,CREATED_BY,CREATED_DATETIME,EMAIL_ID,FAX_NO) "
			+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getUTCDate(),?,?) ";

	public static final String UPDATE_MINE_OWNER_INFORMATION = " update AMS.dbo.MINE_OWNER_MASTER set TC_NO=?,TC_ID=?,YEAR=?,NAME=?,CONTACT_PERSON=?,LEASE_NAME=?,STATE=?,DISTRICT=?,TALUKA=?,VILLAGE=?,POST_OFFICE=?,ADDRESS=?,PIN=?,PHONE_NO=?,PAN_NO=?,TAN_NO=?,BANKER=?,BRANCH=?,UPDATED_BY=?,UPDATED_DATETIME=getUTCDate(),EMAIL_ID=?,FAX_NO=? "
			+ " where ID=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_OWNER_MASTER_DETAILS = " select m.ID,isnull(tc.TC_NO,'') as TC_NUMBER,isnull(m.TC_ID,'') as TC_ID,isnull(m.YEAR,'') as YEAR,isnull(m.NAME,'') as NAME,isnull(m.CONTACT_PERSON,'')as CONTACT_PERSON,isnull(m.LEASE_NAME,'') as LESSEE_NAME,isnull(m.STATE,'') as STATE_ID,"
			+ " isnull(m.DISTRICT,'') as DISTRICT_ID,isnull(m.TALUKA,'') as TALUKA_ID,"
			+ " isnull(m.VILLAGE,'') as VILLAGE,isnull(m.POST_OFFICE,'') as POST_OFFICE,isnull(m.ADDRESS,'') as ADDRESS,isnull(m.PIN,'') as PIN,isnull(m.PHONE_NO,'') as PHONE_NUMBER,isnull(m.PAN_NO,'') as PAN_NO,isnull(m.TAN_NO,'') as TAN_NO,"
			+ " isnull(m.BANKER,'') as BANKER,isnull(m.BRANCH,'') as BRANCH,isnull(m.TYPE,'') as TYPE,"
			+ " isnull(m.EMAIL_ID,'') as EMAIL_ID,isnull(m.FAX_NO,'') as FAX_NO , "
			+ " isnull(d.STATE_NAME,'') as STATE ,isnull(b.DISTRICT_NAME,'') as DISTRICT ,isnull(c.TALUKA_NAME,'') as TALUKA ,"
			+ " isnull(m.TYPE_CODE,'') as TYPE_CODE " + " from AMS.dbo.MINE_OWNER_MASTER m "
			+ " inner join AMS.dbo.MINING_TC_MASTER tc on tc.ID=m.TC_ID and tc.SYSTEM_ID=m.SYSTEM_ID and tc.CUSTOMER_ID=m.CUSTOMER_ID"
			+ " left outer join ADMINISTRATOR.dbo.DISTRICT_DETAILS  b on m.DISTRICT = b.DISTRICT_CODE "
			+ " left outer join ADMINISTRATOR.dbo.TALUKA_DETAILS c on b.DISTRICT_CODE=c.DISTRICT_CODE and m.TALUKA=c.TALUKA_CODE "
			+ " left outer join ADMINISTRATOR.dbo.STATE_DETAILS  d on m.STATE=d.STATE_CODE  "
			+ " where m.SYSTEM_ID=? and m.CUSTOMER_ID=? order by ID desc";

	/***************************************************Monthly Return****************************************************************/

	public static final String GET_MONTHLY_FORM_DETAILS = "select mfd.ID,mfd.RETURN_FORM_ID,DATENAME(month, mfd.DATE) as MONTH,mfd.REGISTRATION_NO,mfd.MINERAL_NAME,isNull(mtm.NAME_OF_MINE,'') as NAME_OF_MINE,mfd.TC_NO, "
			+ " mom.CONTACT_PERSON,isNull(mfd.DESIGNATION,'') as DESIGNATION,isNull(mfd.STATUS,'') as STATUS,isNull(mfd.REMARKS,'') as REMAKRS, "
			+ " isNull(mfd.APPROVED_REJECTED_BY,0) as APPROVED_REJECTED_BY,isNull(mfd.APPROVED_REJECTED_DATETIME,'') as APPROVED_REJECTED_DATETIME from AMS.dbo.MONTHLY_FORM_DETAILS mfd "
			+ " inner join AMS.dbo.MINING_TC_MASTER mtm on mtm.ID = mfd.MINE_CODE "
			+ " inner join AMS.dbo.MINE_OWNER_MASTER mom on mom.ID = mfd.MINE_OWNER_ID "
			+ " where mfd.SYSTEM_ID=? and mfd.CUSTOMER_ID=? and mfd.DATE between ? and ? # order by mfd.ID desc ";

	public static final String GET_LIST_OF_TC_NO = "select mtm.ID,isNull(mtm.REG_IBM,'') as REG_IBM,isNull(mtm.MINE_CODE,'') as MINE_CODE,mtm.TC_NO,isNull(MINING_COMPANY,'') as NAME_OF_MINE,mtm.VILLAGE,mtm.AREA as POST_OFFICE,td.TALUKA_NAME,dd.DISTRICT_NAME, "
			+ " sd.STATE_NAME,mtm.PIN,mtm.FAX_NO,mtm.PHONE_NO,mtm.EMAIL_ID from AMS.dbo.MINING_TC_MASTER mtm  "
			+ " inner join ADMINISTRATOR.dbo.DISTRICT_DETAILS dd on dd.DISTRICT_CODE = mtm.DISTRICT "
			+ " inner join ADMINISTRATOR.dbo.TALUKA_DETAILS td on td.TALUKA_CODE = mtm.TALUKA "
			+ " left outer join ADMINISTRATOR.dbo.STATE_DETAILS sd on sd.STATE_CODE = mtm.STATE "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=mtm.MINE_ID and e.SYSTEM_ID=mtm.SYSTEM_ID and e.CUSTOMER_ID=mtm.CUSTOMER_ID "
			+ " where NAME_OF_MINE is not null and mtm.SYSTEM_ID=? and mtm.CUSTOMER_ID=? ";

	public static final String GET_NAME_AND_ADDRESS = "select mom.ID,mom.LEASE_NAME,mom.VILLAGE,mom.POST_OFFICE,td.TALUKA_NAME,dd.DISTRICT_NAME,sd.STATE_NAME, "
			+ " mom.PIN,isNull(FAX_NO,'') as FAX_NO,mom.PHONE_NO,isNull(EMAIL_ID,'') as EMAIL_ID from AMS.dbo.MINE_OWNER_MASTER mom "
			+ " inner join ADMINISTRATOR.dbo.DISTRICT_DETAILS dd on dd.DISTRICT_CODE = mom.DISTRICT "
			+ " inner join ADMINISTRATOR.dbo.TALUKA_DETAILS td on td.TALUKA_CODE = mom.TALUKA "
			+ " inner join ADMINISTRATOR.dbo.STATE_DETAILS sd on sd.STATE_CODE = mom.STATE "
			+ " where SYSTEM_ID=? and CUSTOMER_ID=?";

	/***************************************************Monthly Deduction Claimed****************************************************************/
	public static final String GET_DEDUCTION_CLAIMED = " select isnull(tc.MINE_CODE,'') as MINE_CODE,isnull(mfd.TC_NO,'') as TC_NO,isnull(sum(dsd.UNIT_RS_PER_TONE),0) as UNIT_RS_PER_TONE "
			+ " from AMS.dbo.MONTHLY_FORM_DETAILS mfd  "
			+ " inner join AMS.dbo.MINING_TC_MASTER tc on mfd.MINE_CODE=tc.ID "
			+ " inner join AMS.dbo.DEDUCTION_SALE_DETAILS dsd on mfd.ID=dsd.MONTHLY_ID  "
			+ " where mfd.SYSTEM_ID=? AND mfd.CUSTOMER_ID=? and DATENAME(month, mfd.DATE)=? and DATENAME(year, mfd.DATE)=? and mfd.MINERAL_NAME= ? and dsd.DEDUCTION_CLAIMED = ? "
			+ " group by mfd.TC_NO,tc.MINE_CODE ";

	public static final String GET_SALES_DISPATCH_DETAILS = " select isnull(mfd.TC_NO, '') as TC_NO, isnull(tc.MINE_CODE,'') as MINE_CODE, isnull(desd.DESPATCH_NAME,'') as DESPATCH, isnull(desd.DOMESTIC_CONSIGNEE, '') as CONSIGNEE, isnull(sum(desd.DOMESTIC_QUANTITY), 0) as DOMESTIC_QUANTITY, isnull(sum(desd.DOMESTICS_SALE_VALUE), 0) as SALE_VALUE,   isnull(desd.EXPORT_COUNTRY,'') as COUNTRY, isnull(sum(desd.QUANTITY), 0) as EXPORT_QUANTITY, isnull(sum(desd.EXPORT_FOB_VALUE), 0) as FOB_VALUE "
			+ " from AMS.dbo.MONTHLY_FORM_DETAILS mfd  "
			+ " inner join AMS.dbo.MINING_TC_MASTER tc on mfd.MINE_CODE=tc.ID "
			+ " inner join AMS.dbo.DOMESTIC_EXPORT_SALES_DEATILS desd on desd.MONTHLY_ID=mfd.ID "
			+ " where mfd.SYSTEM_ID=? AND mfd.CUSTOMER_ID=? and DATENAME(month, mfd.DATE)=? and DATENAME(year, mfd.DATE)=? and MINERAL_NAME=? and desd.GRADE = ? "
			+ " group by desd.EXPORT_COUNTRY,tc.MINE_CODE,mfd.TC_NO,desd.DESPATCH_NAME,desd.DOMESTIC_CONSIGNEE ";

	public static final String INSERT_MONTHLY_FORM_DETAILS = "insert into AMS.dbo.MONTHLY_FORM_DETAILS(RETURN_FORM_ID,DATE,REGION,PIN_CODE,REGISTRATION_NO,MINE_CODE,MINERAL_NAME,TC_NO,OTHER_MINERAL_NAME,MINE_OWNER_ID,RENT_PAID,ROYALTY_PAID,DEAD_RENT_PAID,CHALLAN_DETAILS1,CHALLAN_DETAILS2,MINE_WORK_DAYS,MINE_NON_WORK_DAYS,REASON_FOR_NOT_WORK,TECHNICAL_STAFF,TOTAL_SALARIES,STATUS,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,OTHER_REASON_NOT_WORK) "
			+ " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,'OPEN',?,?,?,getutcdate(),?) ";

	public static final String INSERT_DAILY_EMPLOYMENT_DETAILS = "insert into AMS.dbo.DAILY_EMPLOYEMENT_DETAILS(MONTHLY_ID,WORK_PLACE,DIRECT_MALE,DIRECT_FEMALE,CONTRACT_MALE,CONTRACT_FEMALE,WAGES_DIRECT,WAGES_CONTRACT) values(?,?,?,?,?,?,?,?)";

	public static final String UPDATE_DAILY_EMPLOYMENT_DETAILS = "update AMS.dbo.DAILY_EMPLOYEMENT_DETAILS set WORK_PLACE=?,DIRECT_MALE=?,DIRECT_FEMALE=?,CONTRACT_MALE=?,CONTRACT_FEMALE=?,WAGES_DIRECT=?, WAGES_CONTRACT=? where ID=? ";

	public static final String INSERT_CHALLAN_DETAILS = " insert into AMS.dbo.MONTHLY_CHALLAN_DETAILS(MONTHLY_ID,CHALLAN_NO,GRADE,QUANTITY,TYPE,PROVISIONAL_ROYALITY_RATE,VALUE_PAID,CHALLAN_DATE) values(?,?,?,?,?,?,?,?)";

	public static final String UPDATE_MONTHLY_CHALLAN_DETAILS = "update AMS.dbo.MONTHLY_CHALLAN_DETAILS set CHALLAN_NO=?,GRADE=?,QUANTITY=?,TYPE=?,PROVISIONAL_ROYALITY_RATE=?,VALUE_PAID=?,CHALLAN_DATE=? where ID=? ";

	public static final String INSERT_DEDUCTION_SALES_DETAILS = "insert into AMS.dbo.DEDUCTION_SALE_DETAILS(MONTHLY_ID,DEDUCTION_CLAIMED,UNIT_RS_PER_TONE,REMARKS) values(?,?,?,?) ";

	public static final String UPDATE_DEDUCTION_SALES_DETAILS = "update AMS.dbo.DEDUCTION_SALE_DETAILS set DEDUCTION_CLAIMED=?,UNIT_RS_PER_TONE=?,REMARKS=? where ID=? ";

	public static final String INSERT_PRODUCTION_AND_STOCK_DETAILS = "insert into AMS.dbo.PRODUCTION_AND_STOCK_DETAILS(MONTHLY_ID,CATEGORY,OPENING_STOCK,PRODUCTION,CLOSING_STOCK) values(?,?,?,?,?) ";

	public static final String UPDATE_PRODUCTION_AND_STOCK_DETAILS = "update AMS.dbo.PRODUCTION_AND_STOCK_DETAILS set CATEGORY=?,OPENING_STOCK=?,PRODUCTION=?,CLOSING_STOCK=? where ID=? ";

	public static final String INSERT_DOMESTIC_EXPORT_SALES_DEATILS = "insert into AMS.dbo.DOMESTIC_EXPORT_SALES_DEATILS(MONTHLY_ID,GRADE,DESPATCH_NAME,DOMESTIC_CONSIGNEE,DOMESTIC_QUANTITY,DOMESTICS_SALE_VALUE,EXPORT_COUNTRY,QUANTITY,EXPORT_FOB_VALUE) values(?,?,?,?,?,?,?,?,?) ";

	public static final String UPDATE_DOMESTIC_EXPORT_SALES_DEATILS = "update AMS.dbo.DOMESTIC_EXPORT_SALES_DEATILS set GRADE=?,DESPATCH_NAME=?,DOMESTIC_CONSIGNEE=?,DOMESTIC_QUANTITY=?,DOMESTICS_SALE_VALUE=?,EXPORT_COUNTRY=?,QUANTITY=?,EXPORT_FOB_VALUE=? where ID=? ";

	public static final String INSERT_GRADE_WISE_MINERAL_DEATILS = "insert into AMS.dbo.GRADE_WISE_MINERAL_DEATILS(MONTHLY_ID,GRADE,OPENING_STOCK,PRODUCTION,DESPATCHES,CLOSING_STOCK,EX_MINE_PRICE) values(?,?,?,?,?,?,?) ";

	public static final String UPDATE_GRADE_WISE_MINERAL_DEATILS = "update AMS.dbo.GRADE_WISE_MINERAL_DEATILS set GRADE=?,OPENING_STOCK=?,PRODUCTION=?,DESPATCHES=?,CLOSING_STOCK=?,EX_MINE_PRICE=? where ID=? ";

	public static final String UPDATE_TYPE_OF_ORE = "update AMS.dbo.MONTHLY_FORM_DETAILS set TYPE_OF_ORE=? where ID=?";

	public static final String UPDATE_PROD_GRADE_REASON = "update AMS.dbo.MONTHLY_FORM_DETAILS set INC_DEC_PROD_REASON=?,INC_DEC_GRADE_REASON=?,OTHER_REMARKS=?,PLACE=?,ENTERED_DATE=?,ENTERED_BY=?,DESIGNATION=? where ID=?";

	public static final String GET_PAYMENT_ACC_HEAD = "select ID,PAYMENT_ACC_HEAD from AMS.dbo.ACCOUNTS_HEAD_MASTER where SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String GET_MINE_OWNER_NAME = "select ID,LEASE_NAME from AMS.dbo.MINE_OWNER_MASTER where SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String GET_MINERAL_TPYE = " select MINERAL_CODE,MINERAL_NAME from AMS.dbo.MINING_MINERAL_MASTER where SYSTEM_ID=?";

	public static final String GET_GRADE_AND_RATE = " select GRADE,RATE,TYPE from AMS.dbo.MINING_GRADE_MASTER where MINERAL_CODE=? and MONTH=DATENAME(month, ?) and YEAR=year(?) and CUSTOMER_ID=? and SYSTEM_ID=? order by TYPE ";

	public static final String SAVE_MINING_CHALLAN_DETAILS = "INSERT INTO AMS.dbo.MINING_CHALLAN_DETAILS (CHALLAN_NO,ACCOUNT_HEAD_ID,TYPE,TC_NO,MINING_LEASE,MINERAL_TYPE,ROYALITY_FOR_MONTH,CHALLAN_TYPE,FINANCIAL_YEAR,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,STATUS,PAYMENT_DESC,CHALLAN_DATETIME,CLOSED_PERMIT_ID,TOTAL,E_WALLET_USED,TOTAL_PAYABLE,E_WALLET_BALANCE,PROCESSING_FEE,ORGANIZATION_ID,PREVIOUS_CHALLAN_DATE)VALUES (?,?,?,?,?,?,?,?,?,?,?,?,'OPEN',?,?,?,?,?,?,?,?,?,?)";

	public static final String UPDATE_USED_QTY_FOR_E_WALLET = "UPDATE AMS.dbo.MINING_CHALLAN_DETAILS set USED_QTY=?,USED_AMOUNT=? where ID=?";

	public static final String UPDATE_QTY_FOR_CHALLAN = "UPDATE AMS.dbo.MINING_CHALLAN_DETAILS set QUANTITY=?,GIOPF_QTY=?,GIOPF_RATE=? where ID=?";

	public static final String GET_USED_QTY_FOR_E_WALLET = "select USED_QTY, USED_AMOUNT,isnull(QUANTITY,0) as QUANTITY from AMS.dbo.MINING_CHALLAN_DETAILS  where ID=?";

	public static final String GET_CLOSED_PERMIT_NO = "select ID,PERMIT_NO from AMS.dbo.MINING_PERMIT_DETAILS "
			+ " where TC_ID=? and SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS in ('APPROVED','ACKNOWLEDGED') and SRC_TYPE='E-Wallet' and CHALLAN_ID not in "
			+ " (select ID from MINING_CHALLAN_DETAILS cd "
			+ " where cd.SYSTEM_ID=? and CUSTOMER_ID=? and QUANTITY-isnull(USED_QTY,0)=0 )";

	public static final String GET_MINING_CHALLAN_DETAILS = " select isnull(d.CTO_DATE,'') as CTO_DATE,isnull(a.GIOPF_QTY*GIOPF_RATE,0) as GIOPF_PAYABLE,isnull(mpd.CHALLAN_ID,0) as EWC_ID,isnull(a.ORGANIZATION_ID,0) as ORGANIZATION_ID,isnull(om.ORGANIZATION_NAME,'') AS ORGANIZATION_NAME_PF,isnull(om.ORGANIZATION_CODE,'') AS ORGANIZATION_CODE,a.ID,isnull(a.CHALLAN_NO,'') as CHALLAN_NO,  "
			+ " isnull(c.PAYMENT_ACC_HEAD,'') as PAYMENT_ACC_HEAD,isnull(a.TYPE,'') as TYPE,isnull(d.TC_NO,'')as TC_NO,isnull(a.TC_NO,0) as TC_ID,isnull(a.ACCOUNT_HEAD_ID,0) as PAY_ACC,ROYALITY_FOR_MONTH as ROY_DATE,  "
			+ " isnull(d.NAME_OF_MINE,'')as MINING_LEASE, isnull(dd.DISTRICT_NAME,'NA')as DISTRICT_NAME, "
			+ " isnull(a.MINERAL_TYPE,'') as MINERAL_TYPE, isnull(f.MINERAL_CODE,'')as MINERAL_CODE,  "
			+ " DATENAME(MONTH, a.ROYALITY_FOR_MONTH)+ ''+ cast(year(a.ROYALITY_FOR_MONTH)as varchar)   "
			+ " as ROYALITY_FOR_MONTH,isnull(a.PREVIOUS_CHALLAN_DATE,'')as PREVIOUS_CHALLAN_DATE, isnull(a.CHALLAN_TYPE,'')as CHALLAN_TYPE ,isnull(a.FINANCIAL_YEAR,'')as FINANCIAL_YEAR,   "
			+ " isnull(b.LEASE_NAME,'') as LEASE_NAME, isnull(e.ORGANIZATION_NAME,'') as ORGANIZATION_NAME, isnull(a.PAYMENT_DESC,'')as PAYMENT_DESC,isnull(a.CHALLAN_DATETIME,'')as CHALLAN_DATETIME, "
			+ " isnull(a.NIC_CHALLAN_NO,'')as NIC_CHALLAN_NO ,isnull(a.NIC_CHALLAN_DATE,'')as NIC_CHALLAN_DATE,  "
			+ " isnull(a.DMF_NIC_CHALLAN_NO,'')as DMF_NIC_CHALLAN_NO ,isnull(a.DMF_NIC_CHALLAN_DATE,'')as DMF_NIC_CHALLAN_DATE, "
			+ " isnull(a.NMET_NIC_CHALLAN_NO,'')as NMET_NIC_CHALLAN_NO ,isnull(a.NMET_NIC_CHALLAN_DATE,'')as NMET_NIC_CHALLAN_DATE, "
			+ " isnull(a.PF_NIC_CHALLAN_NO,'')as PF_NIC_CHALLAN_NO ,isnull(a.PF_NIC_CHALLAN_DATE,'')as PF_NIC_CHALLAN_DATE, "
			+ " isnull(a.GIOPF_NIC_CHALLAN_NO,'')as GIOPF_NIC_CHALLAN_NO ,isnull(a.GIOPF_NIC_CHALLAN_DATE,'')as GIOPF_NIC_CHALLAN_DATE, "
			+ " isnull(a.BANK_TRANS_NO,'')as BANK_TRANS_NO,isnull(a.BANK_NAME,'')as BANK_NAME,isnull(a.BRANCH,'')as BRANCH,  "
			+ " isnull(a.AMOUNT_PAID,0)as AMOUNT_PAID,isnull(a.ACK_PAYMENT_DESC,'')as ACK_PAYMENT_DESC,  "
			+ " isnull(a.ACK_DATETIME,'')as ACK_DATETIME, isnull(d.MINE_CODE,'')as MINE_CODE,isnull(a.STATUS,'')as STATUS,isnull(CLOSED_PERMIT_ID,0) as CLOSED_PERMIT_ID, "
			+ " isnull(mpd.PERMIT_NO,'') as PERMIT_NO,isnull(TOTAL,0) AS TOTAL_PAYABLE , isnull(E_WALLET_USED,'') AS E_WALLET_USED,isnull(TOTAL_PAYABLE,0) AS TOTAL_EWALLET_PAYABLE, "
			+ " isnull(d.AMOUNT,0) AS E_WALLET_BALANCE,isnull(PROCESSING_FEE,0) as PROCESSING_FEE,isnull(dateadd(mi,?,a.INSERTED_DATETIME),'')as INSERTED_DATETIME,isnull(a.USED_QTY,0)as USED_QTY "
			+ " from AMS.dbo.MINING_CHALLAN_DETAILS a   "
			+ " left outer join AMS.dbo.MINING_TC_MASTER d on a.TC_NO=d.ID and a.SYSTEM_ID=d.SYSTEM_ID and a.CUSTOMER_ID=d.CUSTOMER_ID   "
			+ " left outer join AMS.dbo.MINE_OWNER_MASTER b on d.SYSTEM_ID=b.SYSTEM_ID and d.CUSTOMER_ID=b.CUSTOMER_ID and d.TC_NO=b.TC_NO  "
			+ " inner join AMS.dbo.ACCOUNTS_HEAD_MASTER c on a.ACCOUNT_HEAD_ID=c.ID and a.SYSTEM_ID=c.SYSTEM_ID and a.CUSTOMER_ID=c.CUSTOMER_ID  "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=d.MINE_ID and e.SYSTEM_ID=d.SYSTEM_ID and e.CUSTOMER_ID=d.CUSTOMER_ID   "
			+ " left outer join  AMS.dbo.MINING_MINERAL_MASTER f on a.MINERAL_TYPE=f.MINERAL_NAME and f.SYSTEM_ID=a.SYSTEM_ID"
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS mpd on mpd.ID=a.CLOSED_PERMIT_ID   and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER om on om.ID=a.ORGANIZATION_ID and a.CUSTOMER_ID=om.CUSTOMER_ID AND a.SYSTEM_ID=om.SYSTEM_ID "
			+ " left outer join ADMINISTRATOR.dbo.DISTRICT_DETAILS dd on dd.DISTRICT_CODE=d.DISTRICT "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS not in('INACTIVE') #conditions#  order by a.ID desc ";

	public static final String SAVE_CHALLAN_ACKNOWLEDGEMENT_INFORMATION = "UPDATE AMS.dbo.MINING_CHALLAN_DETAILS SET NIC_CHALLAN_NO=?,NIC_CHALLAN_DATE=?,BANK_TRANS_NO=?,BANK_NAME=?,BRANCH=?,ACK_PAYMENT_DESC=?,ACK_DATETIME=?,ACKNOWLEDGED_BY=?,ACTUAL_ACK_DATETIME=getutcdate(),STATUS=?,DMF_NIC_CHALLAN_NO=?,DMF_NIC_CHALLAN_DATE=?,NMET_NIC_CHALLAN_NO=?,NMET_NIC_CHALLAN_DATE=?,PF_NIC_CHALLAN_NO=?,PF_NIC_CHALLAN_DATE=?,GIOPF_NIC_CHALLAN_NO=?,GIOPF_NIC_CHALLAN_DATE=? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String GET_TC_NUMBER_CHA = "select isnull(CTO_DATE,'') as CTO_DATE,isnull(TRANSPORTATION_MPL,0) as EC_ALLOCATED,(isnull(TRANSPORTATION_MPL,0)-isnull(MPL_BALANCE,0)) as MPL_BALANCE,isnull(a.MINE_CODE,'')as MINE_CODE,a.TC_NO,isnull(a.NAME_OF_MINE,'')as NAME_OF_MINE,isnull(b.LEASE_NAME,'')as OWNER_NAME,a.ID,isnull(c.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(AMOUNT,0) as QUANTITY,isnull(b.LEASE_NAME,'')as OWNER_NAME,a.ID,isnull(c.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(AMOUNT,0) as QUANTITY from "
			+ " AMS.dbo.MINING_TC_MASTER a "
			+ " inner join AMS.dbo.MINE_OWNER_MASTER b on a.TC_NO=b.TC_NO and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID"
			+ " left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=a.MINE_ID and c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.NAME_OF_MINE is not null "
			+ " and a.ID  in(select TC_ID from MINING.dbo.USER_TC_ASSOCIATION  where USER_ID=? and  SYSTEM_ID=?) order by TC_NO desc ";

	public static final String GET_MINING_SUMMARY_DETAILS = "select d.TC_NO,a.TC_NO as Id,DATENAME(month, ROYALITY_FOR_MONTH)as month,YEAR(ROYALITY_FOR_MONTH) as year,count(NIC_CHALLAN_NO)as NO_OF_CHALLAN,SUM(AMOUNT_PAID) as AMOUNT_PAID,SUM(b.RATE) as RATE,((SUM(AMOUNT_PAID))-(SUM((a.QUANTITY*b.RATE))))as Credit from AMS.dbo.MINING_CHALLAN_DETAILS a  "
			+ " left outer join AMS.dbo.MINING_TC_MASTER d on a.TC_NO=d.ID and a.SYSTEM_ID=d.SYSTEM_ID and a.CUSTOMER_ID=d.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_GRADE_MASTER b on a.GRADE=(b.GRADE+' ('+b.TYPE+')')  and b.MONTH= DATENAME(month, ROYALITY_FOR_MONTH) and b.YEAR=YEAR(ROYALITY_FOR_MONTH)  "
			+ " where AMOUNT_PAID is not null and a.SYSTEM_ID=? and a.CUSTOMER_ID=?  GROUP BY DATENAME(month, ROYALITY_FOR_MONTH),YEAR(ROYALITY_FOR_MONTH),a.TC_NO,d.TC_NO";

	public static final String GET_TC_NUMBER_SUMMARY = "Select ID from AMS.dbo.MINING_TC_MASTER where TC_NO=? and SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String GET_SUMMARY_DETAILS = " select a.ID,a.CHALLAN_NO,c.PAYMENT_ACC_HEAD,a.TYPE,isnull(d.TC_NO,'')as TC_NO, "
			+ " isnull(a.MINING_LEASE,'')as MINING_LEASE,isnull(a.TYPE1,'') as TYPE1, "
			+ " isnull(a.PREVIOUS_CHALLAN_REF,'')as PREVIOUS_CHALLAN_REF, "
			+ " isnull(a.PREVIOUS_CHALLAN_DATE,'')as PREVIOUS_CHALLAN_DATE ,b.LEASE_NAME,a.MINERAL_TYPE,a.ROYALITY_FOR_MONTH, a.GRADE,"
			+ " isnull(a.EXACT_GRADE,'')as EXACT_GRADE, "
			+ " a.RATE,a.QUANTITY,a.TOTAL,isnull(a.PAYMENT_DESC,'')as PAYMENT_DESC, a.CHALLAN_DATETIME, "
			+ " isnull(a.NIC_CHALLAN_NO,'')as NIC_CHALLAN_NO ,isnull(a.NIC_CHALLAN_DATE,'')as NIC_CHALLAN_DATE, "
			+ " isnull(a.BANK_TRANS_NO,'')as BANK_TRANS_NO,isnull(a.BANK_NAME,'')as BANK_NAME,isnull(a.BRANCH,'')as BRANCH, "
			+ " isnull(a.AMOUNT_PAID,0)as AMOUNT_PAID,isnull(a.ACK_PAYMENT_DESC,'')as ACK_PAYMENT_DESC, "
			+ " isnull(a.ACK_DATETIME,'')as ACK_DATETIME  from AMS.dbo.MINING_CHALLAN_DETAILS a  "
			+ " inner join AMS.dbo.MINE_OWNER_MASTER b on a.MINE_OWNER_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID  "
			+ " inner join AMS.dbo.ACCOUNTS_HEAD_MASTER c on a.ACCOUNT_HEAD_ID=c.ID and a.SYSTEM_ID=c.SYSTEM_ID and a.CUSTOMER_ID=c.CUSTOMER_ID "
			+ " inner join AMS.dbo.MINING_TC_MASTER d on a.TC_NO=d.ID and a.SYSTEM_ID=d.SYSTEM_ID and a.CUSTOMER_ID=d.CUSTOMER_ID "
			+ " where  a.TC_NO=? and DATENAME(month, a.ROYALITY_FOR_MONTH)=?  "
			+ " and AMOUNT_PAID is not null and a.SYSTEM_ID=? and a.CUSTOMER_ID=? order by a.ID";

	public static final String GET_MONTHLY_RETURNS_DASHBOARD_DETAILS = " select mfd.ID,mfd.RETURN_FORM_ID,DATENAME(month, mfd.DATE) as MONTH,mfd.REGISTRATION_NO,mfd.MINERAL_NAME,isNull(mtm.NAME_OF_MINE,'') as NAME_OF_MINE,mtm.TC_NO, "
			+ " mom.CONTACT_PERSON,isNull(mfd.DESIGNATION,'') as DESIGNATION,isNull(mfd.STATUS,'') as STATUS,isNull(mfd.REMARKS,'') as REMAKRS, "
			+ " isNull(mfd.APPROVED_REJECTED_BY,0) as APPROVED_REJECTED_BY,isNull(mfd.APPROVED_REJECTED_DATETIME,'') as APPROVED_REJECTED_DATETIME from AMS.dbo.MONTHLY_FORM_DETAILS mfd "
			+ " inner join AMS.dbo.MINING_TC_MASTER mtm on mtm.ID = mfd.MINE_CODE "
			+ " inner join AMS.dbo.MINE_OWNER_MASTER mom on mom.ID = mfd.MINE_OWNER_ID "
			+ " where mfd.SYSTEM_ID=? and mfd.CUSTOMER_ID=? and mfd.DATE between dateadd(mm,-2,getdate()) and getutcdate() # order by mfd.ID desc ";

	public static final String UPDATE_REMARK = " update AMS.dbo.MONTHLY_FORM_DETAILS set STATUS=?,REMARKS=?,APPROVED_REJECTED_BY=?,APPROVED_REJECTED_DATETIME=getutcdate() where ID=? ";

	public static final String GET_MONTHLY_RETURNS_DASHBOARD_COUNT = "select STATUS,count(STATUS) as COUNT from AMS.dbo.MONTHLY_FORM_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? "
			+ " and DATE between dateadd(mm,-2,getdate()) and getutcdate() # group by STATUS ";

	public static final String UPDATE_MONTHLY_DETAILS = " update AMS.dbo.MONTHLY_FORM_DETAILS set DATE=?,REGION=?,PIN_CODE=?,REGISTRATION_NO=?,MINE_CODE=?,MINERAL_NAME=?,TC_NO=?,OTHER_MINERAL_NAME=?, "
			+ " MINE_OWNER_ID=?,RENT_PAID=?,ROYALTY_PAID=?,DEAD_RENT_PAID=?,CHALLAN_DETAILS1=?,CHALLAN_DETAILS2=?,MINE_WORK_DAYS=?,MINE_NON_WORK_DAYS=?,REASON_FOR_NOT_WORK=?, "
			+ " TECHNICAL_STAFF=?,TOTAL_SALARIES=?,STATUS='OPEN',UPDATED_BY=?,UPDATED_DATETIME=getutcdate(),OTHER_REASON_NOT_WORK=? where ID=? ";

	public static final String DELETE_DEDUCTION_SALES_DETAILS = "delete from AMS.dbo.DEDUCTION_SALE_DETAILS where MONTHLY_ID=? ";

	public static final String DELETE_PRODUCTION_AND_STOCK_DETAILS = "delete from AMS.dbo.PRODUCTION_AND_STOCK_DETAILS where MONTHLY_ID=? ";

	public static final String DELETE_DOMESTIC_EXPORT_SALES_DEATILS = "delete from AMS.dbo.DOMESTIC_EXPORT_SALES_DEATILS where MONTHLY_ID=? ";

	public static final String DELETE_GRADE_WISE_MINERAL_DEATILS = "delete from AMS.dbo.GRADE_WISE_MINERAL_DEATILS where MONTHLY_ID=? ";

	public static final String GET_OPENING_STOCK_DETAILS = " select mfd.ID,CATEGORY,isNull(CLOSING_STOCK,0) AS CLOSING_STOCK,DATENAME(month, mfd.DATE) as MONTH,mfd.MINERAL_NAME,MINE_CODE "
			+ " from AMS.dbo.MONTHLY_FORM_DETAILS mfd "
			+ " inner join AMS.dbo.PRODUCTION_AND_STOCK_DETAILS psd on psd.MONTHLY_ID = mfd.ID "
			+ " where mfd.SYSTEM_ID=? and mfd.CUSTOMER_ID=? and DATENAME(month, mfd.DATE)=? and mfd.MINERAL_NAME=? and MINE_CODE=? and DATEPART(yyyy,mfd.DATE)=? ";

	public static final String GET_DETAILS_FROM_ID = " select ID,ISNULL(MINE_CODE,'') as MINE_CODE,isnull(MINERAL_NAME,'') as MINERAL_NAME, "
			+ " DATENAME(month, DATEADD(m, -1, DATE)) as MONTH,DATEPART(yyyy, DATE) as YEAR "
			+ " from AMS.dbo.MONTHLY_FORM_DETAILS where ID not in (select MONTHLY_ID from AMS.dbo.PRODUCTION_AND_STOCK_DETAILS where MONTHLY_ID=?) "
			+ " and ID=? ";

	public static final String GET_PRODUCTION_OF_ROM_REPORT = " select isNull(sum(CLOSING_STOCK),0) AS CLOSING_STOCK,isNull(sum(OPENING_STOCK),0) AS OPENING_STOCK, "
			+ " isNull(sum(PRODUCTION),0) AS PRODUCTION,isNull(mfd.TC_NO,'') as TC_NO,isnull(tc.MINE_CODE,'') as MINE_CODE "
			+ " from AMS.dbo.MONTHLY_FORM_DETAILS mfd  "
			+ " inner join AMS.dbo.MINING_TC_MASTER tc on mfd.MINE_CODE=tc.ID "
			+ " inner join AMS.dbo.PRODUCTION_AND_STOCK_DETAILS psd on psd.MONTHLY_ID = mfd.ID "
			+ " where DATENAME(month, mfd.DATE)=? and mfd.MINERAL_NAME=? and CATEGORY=? and "
			+ " mfd.SYSTEM_ID=? and mfd.CUSTOMER_ID=? and DATEPART(yyyy,mfd.DATE)=? "
			+ " group by mfd.TC_NO,tc.MINE_CODE ";

	public static final String GET_DETAILS = " select WORK_PLACE,DIRECT_MALE,DIRECT_FEMALE, CONTRACT_MALE,CONTRACT_FEMALE,WAGES_DIRECT,WAGES_CONTRACT from DAILY_EMPLOYEMENT_DETAILS where MONTHLY_ID=35 ";

	/********************************************************Modify Monthly Returns Forms**************************************************************/

	public static final String GET_DAILY_EMPLOYMENT_DETAILS = "select ID,WORK_PLACE,DIRECT_MALE,DIRECT_FEMALE,CONTRACT_MALE,CONTRACT_FEMALE,WAGES_DIRECT,WAGES_CONTRACT "
			+ " from AMS.dbo.DAILY_EMPLOYEMENT_DETAILS where MONTHLY_ID =? and WORK_PLACE != 'Total' " + " union all "
			+ " select 0 as ID,'Total' as WORK_PLACE,isNull(sum(DIRECT_MALE),0) as DIRECT_MALE,isNull(sum(DIRECT_FEMALE),0) as DIRECT_FEMALE, isNull(sum(CONTRACT_MALE),0) as CONTRACT_MALE, "
			+ " isNull(sum(CONTRACT_FEMALE),0) as CONTRACT_FEMALE,isNull(sum(WAGES_DIRECT),0) as WAGES_DIRECT,isNull(sum(WAGES_CONTRACT),0) as WAGES_CONTRACT "
			+ " from AMS.dbo.DAILY_EMPLOYEMENT_DETAILS where MONTHLY_ID=? and WORK_PLACE!='Total' ";

	public static final String GET_GRADE_WISE_PRODUCTION_LISTS = "select ID,GRADE,OPENING_STOCK,PRODUCTION,DESPATCHES,CLOSING_STOCK,EX_MINE_PRICE from AMS.dbo.GRADE_WISE_MINERAL_DEATILS where MONTHLY_ID=? ";

	public static final String GET_ORE_PRODUCTION_LISTS = "select ID,CATEGORY,OPENING_STOCK,PRODUCTION,CLOSING_STOCK from AMS.dbo.PRODUCTION_AND_STOCK_DETAILS where MONTHLY_ID=? ";

	public static final String GET_DETAILS_OF_DEDUCTIONS_LISTS = "select ID,DEDUCTION_CLAIMED,UNIT_RS_PER_TONE,REMARKS from AMS.dbo.DEDUCTION_SALE_DETAILS where MONTHLY_ID=? "
			+ " union all "
			+ " select 0 as ID,'Total (a) to (g)' as DEDUCTION_CLAIMED,isNull(sum(UNIT_RS_PER_TONE),0) as UNIT_RS_PER_TONE,'' as REMARKS "
			+ " from AMS.dbo.DEDUCTION_SALE_DETAILS where MONTHLY_ID=? ";

	public static final String GET_DETAILS_AND_LOCATION_OF_MINE = "Select mfd.DATE,mfd.REGION,mfd.REGISTRATION_NO,mfd.MINERAL_NAME,mtm.ID as MINE_ID,isNull(mtm.MINE_CODE,'') as MINE_CODE,mfd.TC_NO, "
			+ " isNull(NAME_OF_MINE,'') as NAME_OF_MINE,mtm.VILLAGE,mtm.AREA as POST_OFFICE,td.TALUKA_NAME,dd.DISTRICT_NAME, "
			+ " sd.STATE_NAME,mtm.PIN,mtm.FAX_NO,mtm.PHONE_NO,mtm.EMAIL_ID,mfd.TC_NO,mfd.OTHER_MINERAL_NAME, "
			+ " mfd.MINE_OWNER_ID,mfd.RENT_PAID,mfd.ROYALTY_PAID,mfd.DEAD_RENT_PAID,mfd.MINE_WORK_DAYS,mfd.MINE_NON_WORK_DAYS, "
			+ " mfd.REASON_FOR_NOT_WORK,mfd.TECHNICAL_STAFF,mfd.TOTAL_SALARIES,isNull(mfd.OTHER_REASON_NOT_WORK,'') as OTHER_REASON_NOT_WORK from AMS.dbo.MONTHLY_FORM_DETAILS mfd "
			+ " inner join AMS.dbo.MINING_TC_MASTER mtm on mtm.ID = mfd.MINE_CODE "
			+ " inner join ADMINISTRATOR.dbo.DISTRICT_DETAILS dd on dd.DISTRICT_CODE = mtm.DISTRICT "
			+ " inner join ADMINISTRATOR.dbo.TALUKA_DETAILS td on td.TALUKA_CODE = mtm.TALUKA "
			+ " left outer join ADMINISTRATOR.dbo.STATE_DETAILS sd on sd.STATE_CODE = mtm.STATE " + " where mfd.ID=? ";

	public static final String GET_NAME_ADDRESS_OF_LESSEE_OWNER = "select mom.ID,mom.CONTACT_PERSON,mom.VILLAGE,mom.POST_OFFICE,td.TALUKA_NAME,dd.DISTRICT_NAME,sd.STATE_NAME,mom.PIN, "
			+ " isNull(FAX_NO,'') as FAX_NO,mom.PHONE_NO,isNull(EMAIL_ID,'') as EMAIL_ID from AMS.dbo.MINE_OWNER_MASTER mom  "
			+ " inner join AMS.dbo.MONTHLY_FORM_DETAILS mfd on mfd.MINE_OWNER_ID = mom.ID  "
			+ " inner join ADMINISTRATOR.dbo.DISTRICT_DETAILS dd on dd.DISTRICT_CODE = mom.DISTRICT  "
			+ " inner join ADMINISTRATOR.dbo.TALUKA_DETAILS td on td.TALUKA_CODE = mom.TALUKA  "
			+ " inner join ADMINISTRATOR.dbo.STATE_DETAILS sd on sd.STATE_CODE = mom.STATE  "
			+ " where mom.SYSTEM_ID=? and mom.CUSTOMER_ID=? and mfd.ID=? ";

	public static final String GET_MONTHLY_CHALLAN_DETAILS = "select ID,CHALLAN_NO,GRADE,TYPE,QUANTITY,PROVISIONAL_ROYALITY_RATE,VALUE_PAID,isNull(CHALLAN_DATE,'') as CHALLAN_DATE  from AMS.dbo.MONTHLY_CHALLAN_DETAILS where MONTHLY_ID=? ";

	public static final String GET_FORM_THREE_DETAILS = "select isNull(INC_DEC_PROD_REASON,'') as INC_DEC_PROD_REASON,isNull(INC_DEC_GRADE_REASON,'') as INC_DEC_GRADE_REASON,isNull(OTHER_REMARKS,'') as OTHER_REMARKS,isNull(PLACE,'')as PLACE,isNull(ENTERED_DATE,'') as ENTERED_DATE,isNull(ENTERED_BY,'') as ENTERED_BY,isNull(DESIGNATION,'') as DESIGNATION from AMS.dbo.MONTHLY_FORM_DETAILS where ID=? ";

	public static final String GET_SALES_DESPATCH_DETAILS = "select ID,GRADE,DESPATCH_NAME,DOMESTIC_CONSIGNEE,DOMESTIC_QUANTITY,DOMESTICS_SALE_VALUE,EXPORT_COUNTRY,QUANTITY,EXPORT_FOB_VALUE from AMS.dbo.DOMESTIC_EXPORT_SALES_DEATILS where MONTHLY_ID=? ";

	public static final String GET_TYPE_OF_ORE = "select TYPE_OF_ORE from AMS.dbo.MONTHLY_FORM_DETAILS where ID=? ";

	public static final String FINAL_SUBMISSION_OF_MFD = "update AMS.dbo.MONTHLY_FORM_DETAILS set STATUS='PENDING' where ID=? ";

	public static final String GET_ORE_PROCESSED_DETAILS = " select isnull(ID,0) as ID,isnull(GRADE,'') as GRADE,isnull(FINES,0) as FINES,isnull(LUMPS,0) as LUMPS,isnull(OVERSIZE,0) as OVERSIZE,isnull(WASTE_OR_TAILING,0) as WASTE  "
			+ " from AMS.dbo.MRF_PROCESSED_ORE_DETAILS where MONTHLY_ID=? and GRADE!='Total' " + " union all  "
			+ " select 0 as ID,'Total' as GRADE,isnull(sum(FINES),0) as FINES,isnull(sum(LUMPS),0) as LUMPS,isnull(sum(OVERSIZE),0) as OVERSIZE,isnull(sum(WASTE_OR_TAILING),0) as WASTE_OR_TAILING from AMS.dbo.MRF_PROCESSED_ORE_DETAILS   "
			+ " where MONTHLY_ID=? and GRADE!='Total' ";

	public static final String GET_OVERSIZE_PROCESSING_DETAILS = " select isnull(ID,0) as ID,isnull(GRADE,'') as GRADE,isnull(FINES,0) as OVERSIZE_FINES,isnull(LUMPS,0) as OVERSIZE_LUMPS,isnull(WASTE_OR_TAILING,0) as OVERSIZE_WASTE "
			+ " from AMS.dbo.MRF_OVERSIZE_PROCESSING_DETAILS where MONTHLY_ID=? and GRADE!='Total' " + " union all "
			+ " select 0 as ID,'Total' as GRADE,isnull(sum(FINES),0) as FINES,isnull(sum(LUMPS),0) as LUMPS,isnull(sum(WASTE_OR_TAILING),0) as WASTE_OR_TAILING from AMS.dbo.MRF_OVERSIZE_PROCESSING_DETAILS  "
			+ " where MONTHLY_ID=? and GRADE!='Total' ";

	public static final String GET_PRODUCT_AND_CLOSING_BALANCE_DETAILS = " select isnull(ID,0) as ID,isnull(GRADE,'') as GRADE,isnull(OPENING_STOCK,0) as OPENING_STOCK,isnull(PRODUCT,0) as PRODUCT,isnull(DESPATCH,0) as DESPATCH ,isnull(CLOSING_STOCK,0) as CLOSING_STOCK "
			+ " from AMS.dbo.MRF_PRODUCT_BAL_DETAILS "
			+ " where MONTHLY_ID=? and GRADE not in ('Total','Total Waste & Tailing','Total Closing Stock Of Oversize','Reconciled') "
			+ " union all "
			+ " select 0 as ID,'Total' as GRADE,isnull(sum(OPENING_STOCK),0) as OPENING_STOCK,isnull(sum(PRODUCT),0) as PRODUCT,isnull(sum(DESPATCH),0) as DESPATCH,isnull(sum(CLOSING_STOCK),0) as CLOSING_STOCK from AMS.dbo.MRF_PRODUCT_BAL_DETAILS where MONTHLY_ID=?  and GRADE not in ('Total','Total Waste & Tailing','Total Closing Stock Of Oversize','Reconciled') "
			+ " union all "
			+ " select 0 as ID,isnull(GRADE,''),isnull(OPENING_STOCK,0) as OPENING_STOCK,isnull(PRODUCT,0) as PRODUCT,isnull(DESPATCH,0) as DESPATCH,isnull(CLOSING_STOCK,0) as CLOSING_STOCK from AMS.dbo.MRF_PRODUCT_BAL_DETAILS where MONTHLY_ID=?  "
			+ " and GRADE in ('Total Waste & Tailing','Total Closing Stock Of Oversize') " + " union all  "
			+ " select 0 as ID,'Reconciled' as GRADE,isnull(sum(OPENING_STOCK),0) as OPENING_STOCK,isnull(sum(PRODUCT),0) as PRODUCT,isnull(sum(DESPATCH),0) as DESPATCH,isnull(sum(CLOSING_STOCK),0) as CLOSING_STOCK "
			+ " from AMS.dbo.MRF_PRODUCT_BAL_DETAILS where MONTHLY_ID=? and GRADE not in ('Total','Reconciled') ";

	public static final String GET_ROM_PROSESSING_DATA = " select ID,isnull(PLANT_LOCATION,'') as LOCATION_OF_PLANT,isnull(ROM_OPENING_STOCK,0) as OPENING_STOCK_OF_ROM,isnull(ROM_RECEIPT,0) as RECEIPT_OF_ROM,isnull(ROM_PROCESSED,0) as ROM_PROCESSED,isnull(ROM_CLOSING_STOCK,0) as CLOSING_STOCK_OF_ROM from AMS.dbo.MRF_ROM_PROCESS_DETAILS "
			+ " where MONTHLY_ID=? ";

	public static final String GET_OVERSIZE_DATA = " select ID,isnull(PLANT_LOCATION,'') as LOCATION_OF_PLANT,isnull(OVERSIZE_OPENING_STOCK,0) as OPENING_STOCK_OF_OVERSIZE,isnull(OVERSIZE_GENERATION,0) as GENERATION_OF_OVERSIZE,isnull(OVERSIZE_PROCESSING,0) as PROCESSING_OF_OVERSIZE,isnull(OVERSIZE_CLOSING_STOCK,0) as CLOSING_STOCK_OF_OVERSIZE from AMS.dbo.MRF_OVERSIZE_CRUSHING_DETAILS "
			+ " where MONTHLY_ID=? ";

	public static final String UPDATE_ROM_PROCESSING_DETAILS = " update  AMS.dbo.MRF_ROM_PROCESS_DETAILS set PLANT_LOCATION=?,ROM_OPENING_STOCK=?,ROM_RECEIPT=?,ROM_PROCESSED=?,ROM_CLOSING_STOCK=? "
			+ " where ID=? ";

	public static final String INSERT_ROM_PROCESSING_DETAILS = " insert into AMS.dbo.MRF_ROM_PROCESS_DETAILS(MONTHLY_ID,PLANT_LOCATION,ROM_OPENING_STOCK,ROM_RECEIPT,ROM_PROCESSED,ROM_CLOSING_STOCK) "
			+ " values(?,?,?,?,?,?) ";

	public static final String UPDATE_ORE_PROCESSING_DETAILS = " update AMS.dbo.MRF_PROCESSED_ORE_DETAILS set GRADE=?,FINES=?,LUMPS=?,OVERSIZE=?,WASTE_OR_TAILING=? where ID=? ";

	public static final String INSERT_ORE_PROCESSING_DETAILS = " insert into AMS.dbo.MRF_PROCESSED_ORE_DETAILS(MONTHLY_ID,GRADE,FINES,LUMPS,OVERSIZE,WASTE_OR_TAILING) values(?,?,?,?,?,?) ";

	public static final String UPDATE_OVERSIZE_DETAILS = " update AMS.dbo.MRF_OVERSIZE_CRUSHING_DETAILS set PLANT_LOCATION=?,OVERSIZE_OPENING_STOCK=?,OVERSIZE_GENERATION=?,OVERSIZE_PROCESSING=?,OVERSIZE_CLOSING_STOCK=?"
			+ " where ID=? ";

	public static final String INSERT_OVERSIZE_DETAILS = " insert into AMS.dbo.MRF_OVERSIZE_CRUSHING_DETAILS(MONTHLY_ID,PLANT_LOCATION,OVERSIZE_OPENING_STOCK,OVERSIZE_GENERATION,OVERSIZE_PROCESSING,OVERSIZE_CLOSING_STOCK)"
			+ " values(?,?,?,?,?,?) ";

	public static final String UPDATE_OVERSIZE_PROCESSING_DETAILS = " update AMS.dbo.MRF_OVERSIZE_PROCESSING_DETAILS set GRADE=?,FINES=?,LUMPS=?,WASTE_OR_TAILING=? where ID=? ";

	public static final String INSERT_OVERSIZE_PROCESSING_DETAILS = " insert into AMS.dbo.MRF_OVERSIZE_PROCESSING_DETAILS(MONTHLY_ID,GRADE,FINES,LUMPS,WASTE_OR_TAILING) values(?,?,?,?,?) ";

	public static final String UPDATE_PRODUCT_GENERATED_DETAILS = " update AMS.dbo.MRF_PRODUCT_BAL_DETAILS set GRADE=?,OPENING_STOCK=?,PRODUCT=?,DESPATCH=?,CLOSING_STOCK=? where ID=? ";

	public static final String INSERT_PRODUCT_GENERATED_DETAILS = " insert into AMS.dbo.MRF_PRODUCT_BAL_DETAILS(MONTHLY_ID,GRADE,OPENING_STOCK,PRODUCT,DESPATCH,CLOSING_STOCK) values(?,?,?,?,?,?) ";

	public static String GET_EMPLOYMENT_DETAILS = " select isNull(b.MINE_CODE,'') as MINE_CODE,isNull(a.TC_NO,'') as TC_NO ,isNull(sum(DIRECT_MALE),0) as DIRECT_MALE,isNull(sum(DIRECT_FEMALE),0) as DIRECT_FEMALE, "
			+ " isNull(sum(CONTRACT_MALE),0) as CONTRACT_MALE,isNull(sum(CONTRACT_FEMALE),0) as CONTRACT_FEMALE,isNull(sum(WAGES_DIRECT),0) as WAGES_DIRECT,isNull(sum(WAGES_CONTRACT),0) as WAGES_CONTRACT "
			+ " from AMS.dbo.MONTHLY_FORM_DETAILS a  " + " inner join AMS.dbo.MINING_TC_MASTER b on a.MINE_CODE=b.ID  "
			+ " inner join AMS.dbo.DAILY_EMPLOYEMENT_DETAILS c on c.MONTHLY_ID = a.ID    "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.MINERAL_NAME=? and c.WORK_PLACE=? and  DATENAME(month, a.DATE)=? and DATEPART(yyyy, a.DATE)=? "
			+ " group by b.MINE_CODE,a.TC_NO ";

	public static final String GET_MRF_GRADEWISE_DETAILS = " select isnull(tc.MINE_CODE,'') as MINE_CODE,isnull(mfd.TC_NO,'') as TC_NO,isnull(sum(gwmd.OPENING_STOCK),0) as OPENING_STOCK, "
			+ " isnull(sum(gwmd.PRODUCTION),0) as PRODUCTION,isnull(sum(gwmd.CLOSING_STOCK),0) as CLOSING_STOCK,isnull(sum(gwmd.DESPATCHES),0) as DESPATCHES,isnull(sum(gwmd.EX_MINE_PRICE),0) as EX_MINE_PRICE "
			+ " from AMS.dbo.MONTHLY_FORM_DETAILS mfd  "
			+ " inner join AMS.dbo.GRADE_WISE_MINERAL_DEATILS gwmd on gwmd.MONTHLY_ID = mfd.ID "
			+ " inner join AMS.dbo.MINING_TC_MASTER tc on mfd.MINE_CODE=tc.ID "
			+ " where mfd.SYSTEM_ID = ? and mfd.CUSTOMER_ID = ? and DATEPART(yyyy,mfd.DATE)=? and DATENAME(month, mfd.DATE)=? and mfd.MINERAL_NAME = ? and gwmd.GRADE = ? "
			+ " group by tc.MINE_CODE,mfd.TC_NO";

	public static final String GET_ASSOCIATED_HUBS_FOR_TC_MASTER = " select NAME,HUBID from LOCATION_ZONE where SYSTEMID=? and CLIENTID=? and OPERATION_ID not in (2,13)  ";

	//***************************************************MINE DETAILS*****************************************//

	public static final String GET_MINE_DETAILS = " select ID,isnull(MINE_CODE,'') as MINE_CODE,isnull(MINING_COMPANY,'') as MINING_COMPANY,isnull(IBM_NUMBER,'') as IBM_NUMBER,isnull(EC_LIMIT,0) as EC_LIMIT,isnull(ORGANIZATION_CODE,'') as ORGANIZATION_CODE,isnull(ORGANIZATION_NAME,'') as ORGANIZATION_NAME,isnull(ORG_ID,0) as ORG_ID, "
			+ " (select isnull(sum(MPL_BALANCE),0) from AMS.dbo.MINING_TC_MASTER where MINE_ID=a.ID) as QUANTITY ,(select isnull(sum(AMOUNT),0) from AMS.dbo.MINING_TC_MASTER where MINE_ID=a.ID) as AMOUNT,isnull(FINANCIAL_YEAR,'') AS FINANCIAL_YEAR, isnull(CARRY_FORWARDED_EC,0) as CARRY_FORWARDED_EC, isnull(ENHANCED_EC,0) as ENHANCED_EC, "
			+ " (isnull(CARRY_FORWARDED_EC,0)+isnull(EC_LIMIT,0)+isnull(ENHANCED_EC,0)) as TOTAL_EC, isnull(REMARK,'') as REMARKS, a.INSERTED_DATETIME as INSERTED_DATETIME, isnull((u1.Firstname+' '+u1.Lastname),'')as INSERTED_BY, a.UPDATED_DATETIME as UPDATED_DATETIME, isnull((u2.Firstname+' '+u2.Lastname),'') as UPDATED_BY from AMS.dbo.MINING_MINE_MASTER a "
			+ " left outer join AMS.dbo.Users u1 on u1.System_id=a.SYSTEM_ID and u1.User_id=a.INSERTED_BY "
			+ " left outer join AMS.dbo.Users u2 on u2.System_id=a.SYSTEM_ID and u2.User_id=a.UPDATED_BY "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? order by a.ID desc ";

	public static final String GET_MAX_CARRY_FORWARDED_EC_PER_ORG = " select sum(EC_BALANCE)as EC_BALANCE,SYSTEM_ID,ORG_ID from (select sum(EC_BALANCE)as EC_BALANCE,SYSTEM_ID,ORG_ID from(select a.SYSTEM_ID,a.ORG_ID,(isnull(a.CARRY_FORWARDED_EC,0)+isnull(a.EC_LIMIT,0)+isnull(a.ENHANCED_EC,0))-(select isnull(sum(MPL_BALANCE),0) from AMS.dbo.MINING_TC_MASTER where MINE_ID=a.ID) as EC_BALANCE "
			+ " from AMS.dbo.MINING_MINE_MASTER a where a.ORG_ID=? and a.CUSTOMER_ID=? and a.SYSTEM_ID=? and a.FINANCIAL_YEAR =?)v1 group by SYSTEM_ID,ORG_ID "
			+ " union all " + " select -sum(CARRY_FORWARDED_EC)as EC_BALANCE,SYSTEM_ID,ORG_ID "
			+ " from AMS.dbo.MINING_MINE_MASTER a where a.ORG_ID=? and a.CUSTOMER_ID=? and a.SYSTEM_ID=? and a.FINANCIAL_YEAR =? group by SYSTEM_ID,ORG_ID)r group by SYSTEM_ID,ORG_ID ";

	public static final String GET_MAX_CARRY_FORWARDED_TC_PER_ORG = " select isnull(sum(CarryForward),0) as CarryForward from (select (isnull(sum(EC_CAPPING_LIMIT),0)+isnull(sum(ENHANCED_MPL),0))+isnull(sum(CARRY_FORWARDED_MPL),0)-isnull(sum(MPL_BALANCE),0) as CarryForward "
			+ " from AMS.dbo.MINING_TC_MASTER a where MINE_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? and FINANCIAL_YEAR =? "
			+ " union all " + " select -isnull(sum(CARRY_FORWARDED_MPL),0) as CarryForward "
			+ " from AMS.dbo.MINING_TC_MASTER b where MINE_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? and FINANCIAL_YEAR =?) TC ";

	public static final String CHECK_MINE_CODE_ALREADY_EXIST = "select isnull(MINE_CODE,'') as MINE_CODE,isnull(IBM_NUMBER,'') as IBM_NUMBER from AMS.dbo.MINING_MINE_MASTER where (MINE_CODE=? or IBM_NUMBER=?) and SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String INSERT_MINERALS_DETAILS = "insert into AMS.dbo.MINING_MINE_MASTER (MINE_CODE,MINING_COMPANY,IBM_NUMBER,EC_LIMIT,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,ORGANIZATION_CODE,ORGANIZATION_NAME,ORG_ID,FINANCIAL_YEAR,CARRY_FORWARDED_EC,ENHANCED_EC,REMARK)VALUES(?,?,?,?,?,?,?,getutcdate(),?,?,?,?,?,?,?)";

	public static final String UPDATE_MINERALS_DETAILS = "update AMS.dbo.MINING_MINE_MASTER set MINE_CODE=?,MINING_COMPANY=?,IBM_NUMBER=?,EC_LIMIT=?,UPDATED_BY=?,UPDATED_DATETIME=getutcdate(),ORGANIZATION_CODE=?,ORGANIZATION_NAME=?,ORG_ID=?,CARRY_FORWARDED_EC=?,ENHANCED_EC=?,REMARK=? "
			+ " where ID=? ";

	public static final String INSERT_INTO_MINING_RATE_MASTER = "insert into AMS.dbo.CHALLAN_GRADE_DETAILS (CHALLAN_ID,GRADE,RATE,QUANTITY,PAYABLE)values(?,?,?,?,?)";

	public static final String UPDATE_STATUS_FOR_FINAL_SUBMIT = "UPDATE AMS.dbo.MINING_CHALLAN_DETAILS SET STATUS='PENDING APPROVAL' where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String UPDATE_STATUS_FOR_DELETE_RECORD = "UPDATE AMS.dbo.MINING_CHALLAN_DETAILS SET STATUS='INACTIVE', DELETED_BY=? , DELETED_DATETIME=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String GET_UNIQUE_ID_FROM_CHALLAN_DETAILS = "Select ID from AMS.dbo.MINING_CHALLAN_DETAILS where CHALLAN_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";

	public static final String UPDATE_WALLET = " update AMS.dbo.MINING_TC_MASTER set AMOUNT=AMOUNT+?,QUANTITY=QUANTITY+?,MPL_BALANCE=MPL_BALANCE+? where ID=? and WALLET_LINK='ROM' ";

	//*****************************************************User Setting*********************************************//
	public static final String GET_TC_NO_FOR_USER_SETTING = "select distinct a.TC_NO,a.ID from AMS.dbo.MINING_TC_MASTER a "
			+ " inner join AMS.dbo.MINING_PERMIT_DETAILS b on a.ID=b.TC_ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and b.STATUS in ('APPROVED','ACKNOWLEDGED') "
			+ " and a.ID  in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)";

	public static final String GET_PERMIT_NO_FOR_USER_SETTING = " select ID,PERMIT_NO from AMS.dbo.MINING_PERMIT_DETAILS "
			+ " WHERE SYSTEM_ID=? and CUSTOMER_ID=? and TC_ID=? and STATUS in ('APPROVED','ACKNOWLEDGED') and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))>=START_DATE and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))<=END_DATE";
	public static final String GET_HUB_FOR_USER_SETTING = "select NAME,HUBID from LOCATION_ZONE_A WHERE OPERATION_ID=17 and SYSTEMID=? and CLIENTID=? ";

	public static final String INSERT_USER_SETTING_DETAILS = "INSERT INTO AMS.dbo.TRIP_SHEET_USER_SETTINGS(TC_ID,PERMIT_IDS,SOURCE_HUBID,DESTINATION_HUBID,TYPE,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,USER_ID,ORGANISATION_CODE,PERMIT_ID,CLOSING_TYPE)values(?,?,?,?,?,?,?,?,getutcdate(),?,?,?,?) ";

	public static final String GET_USER_SETTING_DETAILS = "select USER_NAME,isnull(mmm.ORGANIZATION_CODE,'') as ORGANISATION_CODE,mtm.TC_NO,mpd.PERMIT_NO,isnull(lza.NAME,'') as SOURCE_NAME,isnull(lz.NAME,'') as DESTINATION_NAME,utd.TYPE,utd.INSERTED_DATETIME,isnull(utd.CLOSING_TYPE,'') as CLOSING_TYPE "
			+ " from AMS.dbo.TRIP_SHEET_USER_SETTINGS utd "
			+ " left outer join AMS.dbo.MINING_TC_MASTER mtm on utd.TC_ID=mtm.ID and utd.SYSTEM_ID=mtm.SYSTEM_ID and utd.CUSTOMER_ID=mtm.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS mpd on utd.PERMIT_ID=mpd.ID and utd.SYSTEM_ID=mpd.SYSTEM_ID and utd.CUSTOMER_ID=mpd.CUSTOMER_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lza on utd.SOURCE_HUBID=lza.HUBID and utd.SYSTEM_ID=lza.SYSTEMID and utd.CUSTOMER_ID=lza.CLIENTID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz on utd.DESTINATION_HUBID=lz.HUBID and utd.SYSTEM_ID=lza.SYSTEMID and utd.CUSTOMER_ID=lza.CLIENTID "
			+ " left outer join ADMINISTRATOR.dbo.USERS us on utd.USER_ID=us.USER_ID and utd.SYSTEM_ID=us.SYSTEM_ID  "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mmm on utd.ORGANISATION_CODE=mmm.ID "
			+ " where utd.SYSTEM_ID=? and utd.CUSTOMER_ID=? and "
			+ " (utd.TC_ID  in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) or "
			+ " utd.ORGANISATION_CODE  in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))";

	//*********************************************Permit Details Statements*****************************************//
	public static final String GET_REFERENCE_NUMBER = " select ID,CHALLAN_NO from dbo.MINING_CHALLAN_DETAILS WHERE SYSTEM_ID=? and CUSTOMER_ID=? and STATUS in ('APPROVED','ACKNOWLEDGED') and CHALLAN_NO like 'EWC%' and TC_NO=?  and "
			+ " ID not in (select CHALLAN_ID from AMS.dbo.MINING_PERMIT_DETAILS where STATUS not in('CANCEL','CANCELLED') and SYSTEM_ID=? AND CUSTOMER_ID=?)";

	public static final String GET_LEASE_AREA = "select LEASE_AREA from AMS.dbo.MINING_TC_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String GET_CHALLAN_GRADE_DEATILS = " select *,(select isnull(PROCESSING_FEE,0) from AMS.dbo.MINING_CHALLAN_DETAILS where ID=?) as PROCESSING_FEE , "
			+ " (select isnull(GIOPF_RATE,0) from AMS.dbo.MINING_CHALLAN_DETAILS where ID=?) as GIOPF_RATE , "
			+ " (select isnull(GIOPF_QTY,0) from AMS.dbo.MINING_CHALLAN_DETAILS where ID=?) as GIOPF_QTY "
			+ " from CHALLAN_GRADE_DETAILS where CHALLAN_ID=? order by ID asc ";

	public static final String INSERT_PERMIT_DETAILS = "INSERT INTO AMS.dbo.MINING_PERMIT_DETAILS (PERMIT_NO,TC_ID,DATE,MINERAL,ROUTE_ID,CHALLAN_ID,START_DATE,END_DATE,REMARKS,INSERTED_DATETIME,INSERTED_BY,SYSTEM_ID,CUSTOMER_ID,PERMIT_DATE,STATUS,PERMIT_TYPE,FINANCIAL_YEAR,PERMIT_REQUEST_TYPE,OWNER_TYPE,APPLICATION_NO,ORGANIZATION_CODE,BUYER_NAME,SHIP_NAME,STATE,COUNTRY,BUYING_ORG_ID,EXISTING_PERMIT_ID,DEST_TYPE,SRC_TYPE)values(?,?,?,?,?,?,?,?,?,getutcdate(),?,?,?,getutcdate(),'OPEN',?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	public static final String GET_PERMIT_DETAILS = " select isnull(rd.ROUTE_TYPE,'') as ROUTE_LEASE,isnull(mrm.NAME,'') as MOTHER_ROUTE,(select isnull(sum(QTY),0) from MINING.dbo.MINE_TRIP_FEED_DETAILS where PERMIT_ID=a.ID and PLANT_ID is null and isnull(STATUS,'')!='Cancelled') as SELF_CONSUMPTION_QUANTITY ,popd.PROCESSING_FEE,popd.TOTAL_PROCESSING_FEE,isnull(e.ORG_ID,0) as TC_ORG,isnull(DEST_TYPE,'') as DEST_TYPE,isnull(SRC_TYPE,'') as SRC_TYPE,isnull(lz.NAME,'')as NAME,isnull(g.ID,0) as CHALLAN_ID,isnull(a.ORGANIZATION_CODE,0) as ORGANIZATION_ID,isnull(a.ROUTE_ID,0) as ROUTE_ID,a.ID,isnull(a.PERMIT_NO,'') as PERMIT_NO,isnull(a.DATE,'') as DATE,isnull(a.PERMIT_REQUEST_TYPE,'')as PERMIT_REQUEST_TYPE ,isnull(a.OWNER_TYPE,'')as OWNER_TYPE ,isnull(a.MINERAL,'') as MINERAL,isnull(a.CLOSED_QTY,0) as CLOSED_QTY,    "
			+ " isnull(a.PERMIT_TYPE,'')as PERMIT_TYPE,isnull(a.FINANCIAL_YEAR,'')as FINANCIAL_YEAR ,isnull(a.STATUS,'') as STATUS,isnull(d.TC_NO,'') as TC_NO,isnull(b.LEASE_NAME,'') as LEASE_NAME,isnull(d.NAME_OF_MINE,'')as MINING_LEASE,    "
			+ " isnull(e.ORGANIZATION_NAME,'') as ORGANIZATION_NAME,isnull(h.ORGANIZATION_CODE,'') as ORGANIZATION_CODE,isnull(h.ORGANIZATION_NAME,'')as ORGNAME ,isnull(rd.ROUTE_NAME,'') as Trip_Name,isnull(lz1.NAME,'') as Start_Location,isnull(lz2.NAME,'') as End_Location,isnull(d.MINE_CODE,'')as MINE_CODE,isnull(g.CHALLAN_NO,'') as CHALLAN_NO,isnull(a.APPLICATION_NO,'') as APPLICATION_NO,isnull(a.REMARKS,'') as REMARKS,isnull(a.START_DATE,'') as START_DATE,isnull(a.END_DATE,'') as END_DATE ,  "
			+ " isnull(sd.STATE_NAME,'') as STATE_NAME,isnull(cd.COUNTRY_NAME,'') as COUNTRY_NAME,isnull(a.STATE,0) as STATE_CODE,isnull(a.COUNTRY,0) as COUNTRY_CODE,isnull(a.BUYER_NAME,'') as BUYER_NAME,isnull(a.SHIP_NAME,'') as SHIP_NAME,    "
			+ " isnull((select sum(QUANTITY) from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID),0) as challanqty, "
			+ " isnull((select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=a.ID),0) as permitqty,isnull(a.BUYING_ORG_ID,'') as BUYING_ORG_ID,isnull(bo.ORGANIZATION_NAME,'') as BUYING_ORGANIZAION_NAME,isnull(bo.ORGANIZATION_CODE,'') as BUYING_ORGANIZATION_CODE "
			+ " ,isnull(a.PERMIT_QTY,0) as PERMIT_QTY,isnull(a.EXISTING_PERMIT_ID,0) as EXISTING_PERMIT_ID,(select PERMIT_NO from AMS.dbo.MINING_PERMIT_DETAILS where ID=a.EXISTING_PERMIT_ID) as  EXISTING_PERMIT_NO,isnull(a.TRIPSHEET_QTY,0)/1000 as USED_QTY "
			+ " ,isnull(popd.TYPE,'') as EXACT_TYPE,isnull(popd.GRADE,'') as EXACT_GRADE,isnull(a.REFUND_TYPE,'') as REFUND_TYPE, "
			+ " isnull((select top 1 GRADE from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID and GRADE like '%(Fines)'),'') as RTP_FINES_GRADE, "
			+ " isnull((select top 1 GRADE from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID and GRADE like '%(Lumps)'),'') as RTP_LUMPS_GRADE, "
			+ " isnull((select top 1 GRADE from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID and (GRADE like '%(ROM)' or GRADE like '%(High Court)')),'') as RTP_ROM_GRADE, "
			+ " isnull(IMPORT_TYPE,'') as IMPORT_TYPE,isnull(IMPORT_PURPOSE,'') as IMPORT_PURPOSE ,isnull(EXPORT_PERMIT_NO,'') as EXPORT_PERMIT_NO,isnull(EXPORT_PERMIT_NO_DATE,'') as EXPORT_PERMIT_NO_DATE ,isnull(EXPORT_CHALLAN_NO,'') as EXPORT_CHALLAN_NO,isnull(EXPORT_CHALLAN_NO_DATE,'') as EXPORT_CHALLAN_NO_DATE, isnull(SALE_INVOICE_NO,'') as SALE_INVOICE_NO,isnull(SALE_INVOICE_NO_DATE,'') as SALE_INVOICE_NO_DATE,isnull(TRANSPORTATION_TYPE,'') as TRANSPORTATION_TYPE,isnull(VESSEL_NAME,'') as VESSEL_NAME, "
			+ " (select SRC_TYPE from AMS.dbo.MINING_PERMIT_DETAILS where ID=a.EXISTING_PERMIT_ID) as SRC_TYPE_PRSTP "
			+ " from AMS.dbo.MINING_PERMIT_DETAILS a   "
			+ " left outer join AMS.dbo.MINING_TC_MASTER d on a.TC_ID=d.ID and a.SYSTEM_ID=d.SYSTEM_ID and a.CUSTOMER_ID=d.CUSTOMER_ID     "
			+ " left outer join AMS.dbo.MINE_OWNER_MASTER b on d.SYSTEM_ID=b.SYSTEM_ID and d.CUSTOMER_ID=b.CUSTOMER_ID  and d.TC_NO=b.TC_NO   "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=d.MINE_ID and e.SYSTEM_ID=d.SYSTEM_ID and e.CUSTOMER_ID=d.CUSTOMER_ID    "
			+
			//" left outer join AMS.dbo.Trip_Master f on f.Trip_id=a.ROUTE_ID and f.System_id=a.SYSTEM_ID and f.Client_id=a.CUSTOMER_ID    " +
			" left outer join AMS.dbo.MINING_CHALLAN_DETAILS g on g.ID=a.CHALLAN_ID and g.SYSTEM_ID=a.SYSTEM_ID and g.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER h on h.ID=a.ORGANIZATION_CODE and h.SYSTEM_ID=a.SYSTEM_ID and h.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER bo on bo.ID=a.BUYING_ORG_ID and bo.SYSTEM_ID=a.SYSTEM_ID and bo.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join ADMINISTRATOR.dbo.STATE_DETAILS sd on sd.STATE_CODE=a.STATE   "
			+ " left outer join ADMINISTRATOR.dbo.COUNTRY_DETAILS cd on cd.COUNTRY_CODE=a.COUNTRY   "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd on popd.PERMIT_ID=a.ID "
			+ " left outer join MINING.dbo.IMPORT_PERMIT_DETAILS ipd on ipd.PERMIT_ID=a.ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=a.ROUTE_ID "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join MINING.dbo.MOTHER_ROUTE_MASTER mrm on mrm.ID=rd.MOTHER_ROUTE_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz1 on lz1.HUBID=rd.SOURCE_HUB_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz2 on lz2.HUBID=rd.DESTINATION_HUB_ID " +
			//" left outer join MINING.dbo.MINE_TRIP_FEED_DETAILS mtf on mtf.PERMIT_ID=a.ID and PLANT_ID is null and isnull(mtf.STATUS,'')!='Cancelled' " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=?  #conditions#  order by a.ID desc ";

	public static final String UPDATE_STATUS_FOR_ACKNOWLEDGEMENT = "UPDATE AMS.dbo.MINING_PERMIT_DETAILS SET STATUS='APPROVED' where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? and STATUS not in ('APPROVED') ";

	public static final String UPDATE_PERMIT_DETAILS = "update AMS.dbo.MINING_PERMIT_DETAILS set APPLICATION_NO=?,DATE=?,FINANCIAL_YEAR=?,OWNER_TYPE=?,ROUTE_ID=?,START_DATE=?,END_DATE=?,REMARKS=?,UPDATED_BY=?,UPDATED_DATETIME=getutcdate(),BUYER_NAME=?,SHIP_NAME=?,STATE=?,COUNTRY=?,BUYING_ORG_ID=? "
			+ " where ID=? ";

	public static final String UPDATE_STATUS_FOR_FINAL_SUBMIT_PERMIT = "UPDATE AMS.dbo.MINING_PERMIT_DETAILS SET STATUS=? where SYSTEM_ID=? and CUSTOMER_ID=? and PERMIT_NO=? ";

	public static final String GET_PERMIT_NUMBER = " select mpd.ID,mpd.PERMIT_NO "
			+ " from AMS.dbo.MINING_PERMIT_DETAILS mpd  "
			+ " WHERE mpd.SYSTEM_ID=? and mpd.CUSTOMER_ID=? and mpd.STATUS in ('APPROVED','ACKNOWLEDGED') and mpd.SHIP_NAME=? and mpd.PERMIT_NO LIKE ? # ";

	public static final String GET_PERMIT_DETAILS_FOR_CLOSURE_BY_ID = " select isnull(TOTAL_PROCESSING_FEE,0) as TOTAL_PROCESSING_FEE,((select count(ID) from MINING.dbo.TRUCK_TRIP_DETAILS where PERMIT_ID=mpd.ID and STATUS='OPEN')) as TRIP_COUNT, "
			+ " (select count(ID) from MINING.dbo.BARGE_TRIP_DETAILS where ID in "
			+ " ((select BTS_ID from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS where PERMIT_ID=mpd.ID and STATUS='CLOSE') ) and STATUS in ('Start BLO','Stop BLO')) as  BARGE_TRIP_COUNT , "
			+ " (select count(ID) from MINING_CHALLAN_DETAILS where CLOSED_PERMIT_ID=mpd.ID and STATUS in ('OPEN','PENDING APPROVAL')) as RM_COUNT,  "
			+ " isnull(mpd.MINERAL,'Iron Ore') as MINERAL_TYPE,isnull(SRC_TYPE,'') as SRC_TYPE,mpd.ID,mpd.PERMIT_NO,dateadd(mi,330,mpd.PERMIT_DATE)as PERMIT_DATE,isnull(mpd.TRIPSHEET_QTY,0) as  TRIPSHEET_QTY, "
			+ " isnull((select sum(QUANTITY) from CHALLAN_GRADE_DETAILS where CHALLAN_ID in (select ID from MINING_CHALLAN_DETAILS where ID=mpd.CHALLAN_ID )),0)as CHALLAN_QTY, "
			+ " isnull((select sum(isnull(TOTAL_PAYABLE,0)-isnull(USED_AMOUNT,0)) from MINING_CHALLAN_DETAILS where ID=mpd.CHALLAN_ID),0) as ROM_TOTAL_PAYABLE, "
			+ " isnull((select sum(isnull(TOTAL_PAYABLE,0)) from MINING_CHALLAN_DETAILS where ID=mpd.CHALLAN_ID),0) as TOTAL_PAYABLE, "
			+ " isnull((select sum(QUANTITY) from CHALLAN_GRADE_DETAILS where CHALLAN_ID in (select ID from MINING_CHALLAN_DETAILS fg where CLOSED_PERMIT_ID=mpd.ID and fg.STATUS IN ('APPROVED','ACKNOWLEDGED'))),0) as ROM_PERMITY_QTY, "
			+ " isnull((select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=mpd.ID),0) as PERMIT_QTY "
			+ " from AMS.dbo.MINING_PERMIT_DETAILS mpd  "
			+ " left outer join AMS.dbo.MINING_CHALLAN_DETAILS c on c.ID=mpd.CHALLAN_ID  "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd on popd.PERMIT_ID=mpd.ID "
			+ " WHERE mpd.ID=? ";

	public static final String GET_EWALLET_DETAILS = "select mpd.ID,mpd.PERMIT_NO, "
			+ " d.TOTAL_PAYABLE as EWALLET_AMOUNT, " + " e.QUANTITY as EWALLET_QTY "
			+ " from AMS.dbo.MINING_PERMIT_DETAILS mpd   "
			+ " left outer join AMS.dbo.MINING_CHALLAN_DETAILS d on d.ID=mpd.CHALLAN_ID "
			+ " left outer join AMS.dbo.CHALLAN_GRADE_DETAILS e on e.CHALLAN_ID= d.ID "
			+ " WHERE mpd.SYSTEM_ID=? and mpd.CUSTOMER_ID=? and mpd.ID=?";

	public static final String UPDATE_PERMIT_CLOSURE_DETAILS = " update AMS.dbo.MINING_PERMIT_DETAILS set CLOSED_QTY=?,CLOSED_BY=?,CLOSED_DATETIME=getutcdate(),UPDATED_BY=?,UPDATED_DATETIME=getutcdate(),QTY=?,STATUS=?,REFUND_TYPE=? "
			+ " where ID=? ";

	public static final String GET_TRIP_DETAILS = " select top 1 ut.ID,ut.TYPE,ut.INSERTED_DATETIME,  "
			+ " ut.SOURCE_HUBID,ut.DESTINATION_HUBID,isnull(ut.CLOSING_TYPE,'') as CLOSING_TYPE,PERMIT_ID as BARGE_LOC_ID from TRIP_SHEET_USER_SETTINGS ut  "
			+ " where ut.USER_ID=? and  ut.SYSTEM_ID=? and ut.CUSTOMER_ID=?  "
			+ " and ut.INSERTED_DATETIME=(select max(INSERTED_DATETIME) "
			+ " from TRIP_SHEET_USER_SETTINGS where USER_ID=? and  SYSTEM_ID=? and CUSTOMER_ID=?) "
			+ " order by ut.INSERTED_DATETIME desc ";

	public static final String GET_TRIP_DETAILS_FOR_TARE = "select top 1 tc.LESSE_NAME as TC_LEASE_NAME,ut.TC_ID,rd.ROUTE_NAME as ROUTE_NAME,rd.ID as ROUTE_ID,ut.INSERTED_DATETIME "
			+ " from TRIP_SHEET_USER_SETTINGS ut "
			+ " left outer join MINING_TC_MASTER tc on tc.ID=ut.TC_ID and tc.SYSTEM_ID=ut.SYSTEM_ID and tc.CUSTOMER_ID=ut.CUSTOMER_ID "
			+ " inner  join AMS.dbo.MINING_PERMIT_DETAILS pd on pd.ID=ut.PERMIT_ID and pd.SYSTEM_ID=ut.SYSTEM_ID and pd.CUSTOMER_ID=ut.CUSTOMER_ID "
			+
			//" inner  join AMS.dbo.Trip_Master tm on tm.Trip_id=pd.ROUTE_ID and tm.System_id=pd.SYSTEM_ID and tm.Client_id=pd.CUSTOMER_ID " +
			" left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=pd.ROUTE_ID and rd.SYSTEM_ID=pd.SYSTEM_ID and rd.CUSTOMER_ID=pd.CUSTOMER_ID "
			+ " where ut.USER_ID=? and ut.SYSTEM_ID=? and ut.CUSTOMER_ID=? and (ut.TYPE='Close' or ut.TYPE='Both') "
			+ " and ut.INSERTED_DATETIME>=convert(varchar(10), getdate(),120) order by ut.INSERTED_DATETIME desc";

	public static final String GET_VEHICLE_DETAILS_FOR_TARE = " select isnull(c.LoadCapacity,0) as LOADCAPACITY,td.ID,td.TRIP_NO,td.ASSET_NUMBER,td.VALIDITY_DATE,isnull(td.GRADE,'')as GRADE,isnull(tc.LESSE_NAME,'')as LESSE_NAME,rd.ROUTE_NAME as Trip_Name,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(td.QUANTITY,'')as GROSS_WEIGHT_S,isnull(td.QUANTITY1,0)as TARE_WEIGHT_S,isnull(td.QUANTITY3,'')as GROSS_WEIGHT_D,isnull(td.QUANTITY4,0)as TARE_WEIGHT_D "
			+ " from MINING.dbo.TRUCK_TRIP_DETAILS td "
			+ " left outer join AMS.dbo.tblVehicleMaster c (NOLOCK) on c.System_id=td.SYSTEM_ID and td.ASSET_NUMBER=c.VehicleNo collate database_default "
			+ " left outer join AMS.dbo.MINING_TC_MASTER tc on tc.ID=td.TC_ID and tc.CUSTOMER_ID=td.CUSTOMER_ID and tc.SYSTEM_ID=td.SYSTEM_ID  "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=td.ORGANIZATION_ID and mm.SYSTEM_ID=td.SYSTEM_ID and mm.CUSTOMER_ID=td.CUSTOMER_ID "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=td.ROUTE_ID and rd.SYSTEM_ID=td.SYSTEM_ID and rd.CUSTOMER_ID=td.CUSTOMER_ID "
			+ " where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS='OPEN' "
			+ " and (td.QUANTITY3 is null or  td.QUANTITY3=0) and td.PERMIT_ID in (#) ";

	public static final String UPDATE_MINING_STOCKYARD_MASTER = "update AMS.dbo.MINING_STOCKYARD_MASTER set FINES=isnull(FINES,0)+?,LUMPS=isnull(LUMPS,0)+?,CONCENTRATES=isnull(CONCENTRATES,0)+?,TAILINGS=isnull(TAILINGS,0)+?,TOTAL_QTY=isnull(TOTAL_QTY,0)+? where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=? and ORGANIZATION_ID=? and MINERAL_TYPE=?  ";

	public static final String UPDATE_QUANTITY_FOR_TARE = "update MINING.dbo.TRUCK_TRIP_DETAILS set QUANTITY3=? where ASSET_NUMBER=? and STATUS='OPEN'";

	public static final String GET_VEHICLE_NUMBER_BASED_ON_RFID_FOR_TARE = "select isnull(a.LoadCapacity,0) as LOADCAPACITY,td.ID,td.TRIP_NO,td.ASSET_NUMBER,isnull(tc.LESSE_NAME,'')as LESSE_NAME,rd.ROUTE_NAME as Trip_Name,isnull(td.GRADE,'') as GRADE,td.VALIDITY_DATE,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(td.QUANTITY,'')as GROSS_WEIGHT_S,isnull(td.QUANTITY1,0)as TARE_WEIGHT_S,isnull(td.QUANTITY3,'')as GROSS_WEIGHT_D,isnull(td.QUANTITY4,0)as TARE_WEIGHT_D from AMS.dbo.tblVehicleMaster a   "
			+ " inner join MINING.dbo.TRUCK_TRIP_DETAILS td on a.VehicleNo = td.ASSET_NUMBER collate database_default and a.System_id=td.SYSTEM_ID "
			+ " left outer join AMS.dbo.MINING_TC_MASTER tc on tc.ID=td.TC_ID and tc.CUSTOMER_ID=td.CUSTOMER_ID and tc.SYSTEM_ID=td.SYSTEM_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=td.ORGANIZATION_ID and mm.SYSTEM_ID=td.SYSTEM_ID and mm.CUSTOMER_ID=td.CUSTOMER_ID"
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=td.ROUTE_ID and rd.SYSTEM_ID=td.SYSTEM_ID and rd.CUSTOMER_ID=td.CUSTOMER_ID "
			+ " where a.System_id=? and td.CUSTOMER_ID=? and a.Status='Active' and a.Gps_unit_number=?  "
			+ " and td.STATUS='OPEN' and (td.QUANTITY3 is null or  td.QUANTITY3=0) and td.PERMIT_ID in (#) ";

	public static final String GET_VEHICLE_NUMBER_BASED_ON_RFID_FOR_CLOSE = "select isnull(a.LoadCapacity,0) as LOADCAPACITY,td.ID,td.TRIP_NO,td.ASSET_NUMBER,isnull(tc.LESSE_NAME,'')as LESSE_NAME ,rd.ROUTE_NAME as Trip_Name,isnull(td.GRADE,'')as GRADE,td.VALIDITY_DATE,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(td.QUANTITY,'')as GROSS_WEIGHT_S,isnull(td.QUANTITY1,0)as TARE_WEIGHT_S,isnull(td.QUANTITY3,'')as GROSS_WEIGHT_D,isnull(td.QUANTITY4,0)as TARE_WEIGHT_D from AMS.dbo.tblVehicleMaster a    "
			+ " inner join MINING.dbo.TRUCK_TRIP_DETAILS td on a.VehicleNo = td.ASSET_NUMBER collate database_default and a.System_id=td.SYSTEM_ID  "
			+ " left outer join AMS.dbo.MINING_TC_MASTER tc on tc.ID=td.TC_ID and tc.CUSTOMER_ID=td.CUSTOMER_ID and tc.SYSTEM_ID=td.SYSTEM_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=td.ORGANIZATION_ID and mm.SYSTEM_ID=td.SYSTEM_ID and mm.CUSTOMER_ID=td.CUSTOMER_ID "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=td.ROUTE_ID and rd.SYSTEM_ID=td.SYSTEM_ID and rd.CUSTOMER_ID=td.CUSTOMER_ID "
			+ " where a.System_id=? and td.CUSTOMER_ID=? and a.Gps_unit_number=?   "
			+ " and td.STATUS='OPEN' and (td.QUANTITY3 is not null or  td.QUANTITY3<>0) and td.PERMIT_ID in (#) ";

	public static final String GET_VEHICLE_DETAILS_FOR_CLOSE_TRIP = "select isnull(c.LoadCapacity,0) as LOADCAPACITY,td.ID,td.TRIP_NO,td.ASSET_NUMBER,"
			+ " td.VALIDITY_DATE,isnull(td.GRADE,'')as GRADE,isnull(tc.LESSE_NAME,'')as LESSE_NAME,rd.ROUTE_NAME as Trip_Name,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(td.QUANTITY,'')as GROSS_WEIGHT_S,isnull(td.QUANTITY1,0)as TARE_WEIGHT_S,isnull(td.QUANTITY3,'')as GROSS_WEIGHT_D,isnull(td.QUANTITY4,0)as TARE_WEIGHT_D from MINING.dbo.TRUCK_TRIP_DETAILS td "
			+ " left outer join AMS.dbo.tblVehicleMaster c (NOLOCK) on c.System_id=td.SYSTEM_ID and td.ASSET_NUMBER=c.VehicleNo collate database_default "
			+ " left outer join AMS.dbo.MINING_TC_MASTER tc on tc.ID=td.TC_ID and tc.CUSTOMER_ID=td.CUSTOMER_ID and tc.SYSTEM_ID=td.SYSTEM_ID "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=td.ROUTE_ID and rd.SYSTEM_ID=td.SYSTEM_ID and rd.CUSTOMER_ID=td.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=td.ORGANIZATION_ID and mm.SYSTEM_ID=td.SYSTEM_ID and mm.CUSTOMER_ID=td.CUSTOMER_ID"
			+
			//" left outer join AMS.dbo.MINING_GRADE_MASTER mg on mg.ID=td.GRADE_ID "+
			" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS='OPEN' and (td.QUANTITY3 is not null or  td.QUANTITY3<>0) and td.PERMIT_ID in (#)";

	public static final String UPDATE_QUANTITY_FOR_CLOSE = "update MINING.dbo.TRUCK_TRIP_DETAILS set QUANTITY4=?,STATUS='CLOSE',CLOSED_BY=?,CLOSED_DATETIME=getutcdate(),CLOSING_TYPE=?,DESTINATION_TYPE=?,REASON=?,CLOSING_LOCATION=?,CLOSING_DATETIME=? where ID=? and STATUS='OPEN' and ASSET_NUMBER=?";

	public static final String GET_VEHILCE_NO_FOR_TARE_WEIGHT = "select isnull(VehicleType,'') as TYPE,isnull(UnLadenWeight,0) as UN_LADEN_WEIGHT,a.ASSET_NUMBER as VID,a.ASSET_NUMBER as VNAME from AMS.dbo.MINING_ASSET_ENROLLMENT a "
			+ "inner join AMS.dbo.VehicleRegistration b on b.SystemId =a.SYSTEM_ID and b.RegistrationNo=a.ASSET_NUMBER "
			+ "inner join AMS.dbo.tblVehicleMaster c on c.System_id=a.SYSTEM_ID and a.ASSET_NUMBER=c.VehicleNo and c.Status=a.STATUS "
			+ "inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER d on d.SYSTEM_ID=a.SYSTEM_ID and d.CUSTOMER_ID=a.CUSTOMER_ID "
			+ "where a.SYSTEM_ID=? and d.CUSTOMER_ID=? and a.STATUS='Active' and a.VALIDITY_DATE >=Convert(varchar, GETDATE(),111)";

	public static final String GET_VEHICLE_NUMBER_BASED_ON_RFID_FOR_TARE_WEIGHT = "select a.VehicleNo from AMS.dbo.tblVehicleMaster a "
			+ "inner join AMS.dbo.VehicleRegistration b on b.SystemId =a.System_id and b.RegistrationNo=a.VehicleNo "
			+ "inner join AMS.dbo.MINING_ASSET_ENROLLMENT c on c.SYSTEM_ID=a.System_id and c.ASSET_NUMBER=a.VehicleNo "
			+ "inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER d on d.SYSTEM_ID=a.System_id "
			+ "where a.System_id=? and d.CUSTOMER_ID=? and a.Status='Active' and a.Gps_unit_number=? ";

	public static final String UPDATE_CHALLAN_DETAILS = " update MINING_CHALLAN_DETAILS set ACCOUNT_HEAD_ID=?,FINANCIAL_YEAR=?, "
			+ " PAYMENT_DESC=?,E_WALLET_USED=?,TOTAL_PAYABLE=?,E_WALLET_BALANCE=?,UPDATED_BY=?,UPDATED_DATETIME=getUTCDate(),CHALLAN_DATETIME=?,PREVIOUS_CHALLAN_DATE=? where ID=? ";

	public static final String UPDATE_CHALLAN_DETAILS_FOR_OTHERS = " update MINING_CHALLAN_DETAILS set ACCOUNT_HEAD_ID=?,FINANCIAL_YEAR=?, "
			+ " PAYMENT_DESC=?,TOTAL=?,E_WALLET_USED=?,TOTAL_PAYABLE=?,E_WALLET_BALANCE=?,CHALLAN_DATETIME=?,UPDATED_BY=?,UPDATED_DATETIME=getUTCDate(),PREVIOUS_CHALLAN_DATE=? where ID=? ";

	public static final String UPDATE_MINING_RATE_MASTER = "update dbo.CHALLAN_GRADE_DETAILS set GRADE=?,RATE=?,QUANTITY=?,PAYABLE=? where ID=?";

	public static final String INSERT_INTO_MINE_FEED_DETAILS = " insert into AMS.dbo.MINE_FEED_DETAILS(SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,DATE,TC_NO,ORGANIZATION_CODE,PERMIT_NO,ROM_QUANTITY) values(?,?,?,getUTCDate(),?,?,?,?,?) ";

	public static final String UPDATE_MINE_FEED_DETAILS = " update AMS.dbo.MINE_FEED_DETAILS set DATE=?,TC_NO=?,ORGANIZATION_CODE=?,PERMIT_NO=?,ROM_QUANTITY=?,UPDATED_BY=?,UPDATED_DATETIME=getUTCDate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String GET_MINE_FEED_DETAILS = " select mfd.ID as ID ,isnull(mfd.DATE,'')as DATE,isnull(tc.TC_NO,'')as TC_NO,isnull(mfd.ORGANIZATION_CODE,'')as ORGANIZATION_CODE,isnull(mfd.PERMIT_NO,0)as PERMIT_NO,isnull(mpd.PERMIT_NO,0)as PERMIT_NUMBER,isnull(ROM_QUANTITY,0)as ROM_QUANTITY, "
			+ " (select sum(ROM_QUANTITY) from AMS.dbo.MINE_FEED_DETAILS where ORGANIZATION_CODE=mfd.ORGANIZATION_CODE group by ORGANIZATION_CODE) as ORG_ROM_QUANTITY "
			+ " from AMS.dbo.MINE_FEED_DETAILS mfd "
			+ " left outer join AMS.dbo.MINING_TC_MASTER tc on tc.ID=mfd.TC_NO and mfd.SYSTEM_ID=tc.SYSTEM_ID and mfd.CUSTOMER_ID=tc.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS mpd on mpd.ID=mfd.PERMIT_NO and mfd.SYSTEM_ID=mpd.SYSTEM_ID and mfd.CUSTOMER_ID=mpd.CUSTOMER_ID "
			+ " where mfd.SYSTEM_ID=? and mfd.CUSTOMER_ID=? and "
			+ " mfd.TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) ";

	public static final String GET_TC_NO = " select ID as TC_ID, isnull(TC_NO,'') as TC_NUMBER, isnull(MINE_ID,'') as MINE_ID, "
			+ " isnull((select SUM(ROM) from AMS.dbo.PLANT_FEED_DETAILS where SYSTEM_ID=a.SYSTEM_ID and CUSTOMER_ID=a.CUSTOMER_ID and TC_NO=a.ID and CHALLAN_TYPE='ROM'),0) as PF_ROM_USED_QTY "
			+ "	,isnull((select SUM(ROM) from AMS.dbo.PLANT_FEED_DETAILS where SYSTEM_ID=a.SYSTEM_ID and CUSTOMER_ID=a.CUSTOMER_ID and TC_NO=a.ID and CHALLAN_TYPE='Processed Ore'),0) as PF_PROC_USED_QTY "
			+ "	,isnull((select sum(QUANTITY) from AMS.dbo.MINING_CHALLAN_DETAILS where SYSTEM_ID=a.SYSTEM_ID and CUSTOMER_ID=a.CUSTOMER_ID and TC_NO=a.ID and CHALLAN_TYPE='Processed Ore'),0) as PROCESSED_QTY "
			+ " ,isnull((select sum(QUANTITY) from AMS.dbo.MINING_CHALLAN_DETAILS where SYSTEM_ID=a.SYSTEM_ID and CUSTOMER_ID=a.CUSTOMER_ID and TC_NO=a.ID and CHALLAN_TYPE='ROM'),0) as ROM_QTY "
			+ " from AMS.dbo.MINING_TC_MASTER a where SYSTEM_ID=? and CUSTOMER_ID=? and ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) order by ID ";

	public static final String GET_OCODE = " select ID,isnull(ORGANIZATION_CODE,'') as ORGANIZATION_CODE,isnull(ORGANIZATION_NAME,'') as  ORGANIZATION_NAME from AMS.dbo.MINING_ORGANIZATION_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? "
			+ " and  ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)";

	public static final String GET_FOR_TC_OCODE = " select ORG_ID as ID,isnull(ORGANIZATION_CODE,'') as ORGANIZATION_CODE,isnull(ORGANIZATION_NAME,'') as  ORGANIZATION_NAME from AMS.dbo.MINING_MINE_MASTER "
			+ " where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? and ORG_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)";

	public static final String GET_ROM_CHALLAN = "select ID,CHALLAN_NO,isnull(QUANTITY,0) as QUANTITY,isnull(USED_QTY,0) as USED_QTY from AMS.dbo.MINING_CHALLAN_DETAILS where CHALLAN_TYPE in ('ROM','Processed Ore') and isnull(QUANTITY,0)-isnull(USED_QTY,0)>0 and TC_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_PLANT_FEED_DETAILS = "select isnull(pfd.TYPE,'') as TYPE ,pfd.ID as ID,isnull(mm.ID,0)as ORG_ID,isnull(mm.ORGANIZATION_CODE,'')as ORGANIZATION_CODE,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,pfd.PLANT_ID as PLANT_ID,isnull(pm.PLANT_NAME,'') as PLANT_NAME,isnull(pm.ROM_QTY,0) as PLANT_QTY,isnull(DATE,'')as DATE,isnull(ROM,0)as ROM, isnull(LUMPS_BELOW_55,0)as LUMP1,isnull(LUMPS_55_BELOW_58,0)as LUMP2,isnull(LUMPS_58_BELOW_60,0)as LUMP3, "
			+ " isnull(LUMPS_60_BELOW_62,0)as LUMP4,isnull(LUMPS_62_BELOW_65,0)as LUMP5,isnull(LUMPS_65_ABOVE,0)as LUMP6,isnull(FINES_BELOW_55,0)as FINES1,isnull(FINES_55_BELOW_58,0)as FINES2,isnull(FINES_58_BELOW_60,0)as FINES3,isnull(FINES_60_BELOW_62,0)as FINES4,isnull(FINES_62_BELOW_65,0)as FINES5, "
			+ " isnull(FINES_65_ABOVE,0)as FINES6,isnull(pfd.CONC_BELOW_55,0)as CONCENTRATE1,isnull(pfd.CONC_55_BELOW_58,0)as CONCENTRATE2,isnull(pfd.CONC_58_BELOW_60,0)as CONCENTRATE3,isnull(pfd.CONC_60_BELOW_62,0)as CONCENTRATE4,isnull(pfd.CONC_62_BELOW_65,0)as CONCENTRATE5, "
			+ " isnull(pfd.CONC_65_ABOVE,0)as CONCENTRATE6, "
			+ " isnull(pfd.TAILINGS,0)as TAILINGS,isnull(pfd.REJECTS,0)as REJECTS,isnull(pfd.TOTAL_UFO,0) as UFO,isnull(pfd.REMARKS,'') as REMARKS  "
			+ " from AMS.dbo.PLANT_FEED_DETAILS pfd "
			+ " left outer join AMS.dbo.MINING_CHALLAN_DETAILS mcd on mcd.ID=pfd.CHALLAN_ID and pfd.SYSTEM_ID=mcd.SYSTEM_ID and pfd.CUSTOMER_ID=mcd.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=pfd.ORGANIZATION_CODE and pfd.SYSTEM_ID=mm.SYSTEM_ID and pfd.CUSTOMER_ID=mm.CUSTOMER_ID "
			+ " left outer join MINING.dbo.PLANT_MASTER pm on pm.ID=pfd.PLANT_ID and pfd.SYSTEM_ID=pm.SYSTEM_ID and pfd.CUSTOMER_ID=pm.CUSTOMER_ID "
			+ " where pfd.SYSTEM_ID=? and pfd.CUSTOMER_ID=? and "
			+ "(pfd .TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " pfd.ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) order by pfd.ID desc";

	public static final String GET_ORGANIZATION_CODE = "select isnull(ALIAS_NAME,'')+'/'+cast(DATEPART(dd,getdate()) as varchar(10))+CONVERT(varchar(2), GETDATE(), 101)+'/'+(case when DATEPART(mm,getdate())>3 then cast(DATEPART(yyyy,getdate()) as varchar)+ '-'+substring(cast(DATEPART(yyyy,getdate())+1 as varchar),3,5) else "
			+ " cast(DATEPART(yyyy,getdate())-1 as varchar)+'-'+substring(cast(DATEPART(yyyy,getdate()) as varchar),3,5) end) as ALIAS_NAME,isnull(M_WALLET_BALANCE,0) as M_WALLET_BALANCE,a.ID,ORGANIZATION_CODE,ORGANIZATION_NAME , isnull(TYPE,'') as TYPE , "
			+ " (select isnull(sum(TOTAL_LUMPS),0) as TOTAL_LUMPS from dbo.PLANT_FEED_DETAILS where ORGANIZATION_CODE=a.ID) as TOTAL_LUMPS,  "
			+ " (select isnull(sum(TOTAL_FINES),0) as TOTAL_FINES from dbo.PLANT_FEED_DETAILS where ORGANIZATION_CODE=a.ID) as TOTAL_FINES,  "
			+ " (select isnull(sum(TAILINGS),0) as TAILINGS from dbo.PLANT_FEED_DETAILS where ORGANIZATION_CODE=a.ID) as TAILINGS,  "
			+ " (select isnull(sum(REJECTS),0) as REJECTS from dbo.PLANT_FEED_DETAILS where ORGANIZATION_CODE=a.ID) as REJECTS,   "
			+ " (select isnull(sum(LUMPS),0) as TOTAL_LUMPS from dbo.MINING_ORGANIZATION_MASTER where ID=a.ID) as USED_LUMPS,  "
			+ " (select isnull(sum(FINES),0) as TOTAL_FINES from dbo.MINING_ORGANIZATION_MASTER where ID=a.ID) as USED_FINES,  "
			+ " (select isnull(sum(TAILINGS),0) as TAILINGS from dbo.MINING_ORGANIZATION_MASTER where ID=a.ID) as USED_TAILINGS, "
			+ " (select isnull(sum(REJETCS),0) as REJECTS from dbo.MINING_ORGANIZATION_MASTER where ID=a.ID) as USED_REJECTS  "
			+ " from AMS.dbo.MINING_ORGANIZATION_MASTER a where SYSTEM_ID=? and CUSTOMER_ID=? and "
			+ " a.ID  in(select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION  where USER_ID=? and  SYSTEM_ID=?) order by ORGANIZATION_NAME asc";

	public static final String UPDATE_E_WALLET = " update AMS.dbo.MINING_TC_MASTER set AMOUNT=AMOUNT+? where ID=? ";

	public static final String UPDATE_E_WALLET_FOR_ROM = " update AMS.dbo.MINING_TC_MASTER set AMOUNT=AMOUNT-? where ID=? ";

	public static final String UPDATE_TOTAL_PAYABLE = "UPDATE AMS.dbo.MINING_CHALLAN_DETAILS SET TOTAL_PAYABLE=? where ID=? ";

	public static final String INSERT_INTO_PLANT_FEED_DETAILS = " insert into AMS.dbo.PLANT_FEED_DETAILS(SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,ORGANIZATION_CODE,DATE,ROM,LUMPS_BELOW_55,LUMPS_55_BELOW_58,LUMPS_58_BELOW_60,LUMPS_60_BELOW_62,LUMPS_62_BELOW_65,LUMPS_65_ABOVE,FINES_BELOW_55,FINES_55_BELOW_58,FINES_58_BELOW_60,FINES_60_BELOW_62,FINES_62_BELOW_65,FINES_65_ABOVE,CONC_BELOW_55,CONC_55_BELOW_58,CONC_58_BELOW_60,CONC_60_BELOW_62,CONC_62_BELOW_65,CONC_65_ABOVE,TAILINGS,REJECTS,TOTAL_LUMPS,TOTAL_FINES,TOTAL_CONCENTRATES,TOTAL_UFO,TOTAL_PROCESSED_ORE,PLANT_ID,TYPE,REMARKS)values(?,?,?,getUTCDate(),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";

	public static final String UPDATE_PLANT_FEED_DETAILS = " update AMS.dbo.PLANT_FEED_DETAILS set ROM=?,LUMPS_BELOW_55=?,LUMPS_55_BELOW_58=?,LUMPS_58_BELOW_60=?,LUMPS_60_BELOW_62=?,LUMPS_62_BELOW_65=?,LUMPS_65_ABOVE=?,FINES_BELOW_55=?,FINES_55_BELOW_58=?,FINES_58_BELOW_60=?,FINES_60_BELOW_62=?,FINES_62_BELOW_65=?,FINES_65_ABOVE=?,TAILINGS=?,REJECTS=?,TOTAL_LUMPS=?,TOTAL_FINES=?,TOTAL_UFO=?,TOTAL_PROCESSED_ORE=?, UPDATED_BY=?,PLANT_ID=?,UPDATED_DATETIME=getUTCDate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String UPDATE_PLANT_DETAILS_FOR_USEDQTY = " update AMS.dbo.MINING_CHALLAN_DETAILS set USED_QTY=? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String GET_UNIQUE_ID_FROM_PERMIT_DETAILS = "Select ID from AMS.dbo.MINING_PERMIT_DETAILS where PERMIT_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";

	public static final String INSERT_INTO_PROCESSED_ORE_PERMIT_DETAILS = "insert into AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS (PERMIT_ID,GRADE,TYPE,QUANTITY,STOCK_TYPE,SOURCE_TYPE,PROCESSING_FEE,TOTAL_PROCESSING_FEE)values(?,?,?,?,?,?,?,?)";

	public static final String UPDATE_PROCESSED_ORE_PERMIT_DETAILS = "update AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS set GRADE=?,TYPE=?,QUANTITY=?,STOCK_TYPE=? where PERMIT_ID=?";

	public static final String UPDATE_ORANG_DEATILS = " update AMS.dbo.MINING_ORGANIZATION_MASTER set FINES=isnull(FINES,0)+? ,LUMPS=isnull(LUMPS,0)+? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String GET_TRIP_SHEET_NUMBER = "select TRIPSHEET_NO from AMS.dbo.MINING_PERMIT_DETAILS where ID=? ";

	public static final String UPDATE_TRIP_SHEET_NUMBER = "update AMS.dbo.MINING_PERMIT_DETAILS set  TRIPSHEET_NO=? where ID=?";

	public static final String GET_ACTUAL_QUANTITY = "select isnull(TRIPSHEET_QTY,0)as ACTUAL_QUANTITY,PERMIT_TYPE,MINERAL from MINING_PERMIT_DETAILS where ID=?";

	public static final String GET_DESTINATION_FROM_ROUTE = " select isnull(SOURCE_HUB_ID,0) as Start_Hubid,isnull(DESTINATION_HUB_ID,0) as End_Hubid "
			+ " from MINING.dbo.ROUTE_DETAILS where SYSTEM_ID=? AND CUSTOMER_ID=? and ID=? ";

	public static final String GET_STOCK_DETAILS = " select * from AMS.dbo.MINING_STOCKYARD_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=? and ORGANIZATION_ID=? and MINERAL_TYPE=? ";

	public static final String INSERT_INTO_STOCK_DEATILS = " INSERT INTO AMS.dbo.MINING_STOCKYARD_MASTER (ROUTE_ID,ORGANIZATION_ID,LUMPS,FINES,TOTAL_QTY,SYSTEM_ID,CUSTOMER_ID,MINERAL_TYPE,CONCENTRATES,TAILINGS) VALUES (?,?,?,?,?,?,?,?,?,?) ";

	public static final String INSERT_ACTUAL_QUANTITY = "update AMS.dbo.MINING_PERMIT_DETAILS set TRIPSHEET_NO=?,TRIPSHEET_QTY=isnull(TRIPSHEET_QTY,0)+? where ID=?";

	public static final String GET_PERMIT_NO_BASED_ON_ORGCODE = " select ID,PERMIT_NO from AMS.dbo.MINING_PERMIT_DETAILS "
			+ " WHERE SYSTEM_ID=? and CUSTOMER_ID=? and STATUS in ('APPROVED','ACKNOWLEDGED') and ORGANIZATION_CODE=? and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))>=START_DATE and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))<=END_DATE";

	public static final String GET_LTSP_USERS_WITH_ORGID_FOR_USER_SETTING = "select distinct(ta.USER_ID),us.USER_NAME from MINING.dbo.USER_TC_ASSOCIATION ta "
			+ " inner join ADMINISTRATOR.dbo.USERS us on ta.USER_ID=us.USER_ID and ta.SYSTEM_ID=us.SYSTEM_ID "
			+ " where ta.ORG_ID=? and us.SYSTEM_ID=? and (us.CUSTOMER_ID=0 or (us.CUSTOMER_ID=? and us.USERAUTHORITY='User')) ";

	public static final String GET_LTSP_USERS_WITH_TCID_FOR_USER_SETTING = "select ta.USER_ID,us.USER_NAME from MINING.dbo.USER_TC_ASSOCIATION ta "
			+ "inner join ADMINISTRATOR.dbo.USERS us on ta.USER_ID=us.USER_ID and ta.SYSTEM_ID=us.SYSTEM_ID "
			+ "where ta.TC_ID=? and us.SYSTEM_ID=? and (us.CUSTOMER_ID=0 or (us.CUSTOMER_ID=? and us.USERAUTHORITY='User' )) ";

	public static final String GET_LTSP_USERS_FOR_USER_SETTING = " select USER_ID,USER_NAME from ADMINISTRATOR.dbo.USERS where SYSTEM_ID=? and CUSTOMER_ID=0"
			+ " union "
			+ " select USER_ID,USER_NAME from ADMINISTRATOR.dbo.USERS where SYSTEM_ID=? and CUSTOMER_ID=? and USERAUTHORITY='User'";

	public static final String GET_ORG_NO_BASED_ON_PERMIT_ID = " select ID,ORGANIZATION_CODE from AMS.dbo.MINING_PERMIT_DETAILS "
			+ " WHERE SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String GET_TRIP_SHEET_DETAILS_FOR_MODIFY = "select pd.ID,pd.CHALLAN_ID,(select sum(QUANTITY) from  dbo.CHALLAN_GRADE_DETAILS where "
			+ " CHALLAN_ID=pd.CHALLAN_ID) as QUANTITY,isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY ,"
			+ " (select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=pd.ID) as POTQUANTITY"
			+ " from AMS.dbo.MINING_PERMIT_DETAILS pd where pd.PERMIT_NO=? and pd.SYSTEM_ID=? and pd.CUSTOMER_ID=?";

	public static final String GET_STOCKYARD_MASTER_DETAILS = " select b.ID as ORG_ID,ROUTE_ID as HUB_ID,b.ORGANIZATION_NAME,a.ID,'STOCK/JETTY' as TYPE ,isnull(c.NAME COLLATE DATABASE_DEFAULT,'') as NAME,isnull(ORGANIZATION_ID,0) as ORGANIZATION_ID,isnull(b.ORGANIZATION_CODE,'') as ORGANIZATION_CODE,isnull(a.FINES,0)as FINES,isnull(a.LUMPS,0) as LUMPS,isnull(a.TAILINGS,0)as TAILINGS,isnull(a.REJECTS,0) as REJECTS ,isnull(a.UFO,0) as UFO,isnull(a.CONCENTRATES,0) as CONCENTRATES, "
			+ " isnull(a.MINERAL_TYPE COLLATE DATABASE_DEFAULT,'Iron Ore') as MINERAL_TYPE,(case when a.MINERAL_TYPE='Bauxite/Laterite' then isnull(a.TOTAL_QTY,0) else isnull(a.FINES,0)+isnull(a.LUMPS,0)+isnull(a.TAILINGS,0)+isnull(a.REJECTS,0)+isnull(a.UFO,0)+isnull(a.CONCENTRATES,0)  end) as TOTAL_QTY,isnull(a.ROM_QTY,0) as ROM_QTY from dbo.MINING_STOCKYARD_MASTER a "
			+ " inner join dbo.MINING_ORGANIZATION_MASTER b on b.SYSTEM_ID=a.SYSTEM_ID and a.CUSTOMER_ID=a.CUSTOMER_ID and a.ORGANIZATION_ID=b.ID "
			+ " inner join dbo.LOCATION_ZONE_A c on c.SYSTEMID=a.SYSTEM_ID and c.CLIENTID=a.CUSTOMER_ID and c.HUBID=a.ROUTE_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) "
			+ " union all "
			+ " select b.ID AS ORG_ID,'' as HUB_ID,b.ORGANIZATION_NAME,a.ID,'PLANT' as TYPE,isnull(a.PLANT_NAME COLLATE DATABASE_DEFAULT,'') as NAME,isnull(a.ORGANIZATION_ID,0) as ORGANIZATION_ID,isnull(b.ORGANIZATION_CODE,'') as ORGANIZATION_CODE,(isnull(sum(pfd.TOTAL_FINES),0)-isnull(a.FINES,0)) as FINES, "
			+ " (isnull(sum(pfd.TOTAL_LUMPS),0)-isnull(a.LUMPS,0)) as LUMPS,(isnull(sum(pfd.TAILINGS),0)-isnull(a.TAILINGS,0)) as TAILINGS,(isnull(sum(pfd.REJECTS),0)-isnull(a.REJECTS,0)) as REJECTS,(isnull(sum(pfd.TOTAL_UFO),0)-isnull(a.UFO,0)) as UFO,(isnull(sum(pfd.TOTAL_CONCENTRATES),0)-isnull(a.CONCENTRATES,0)) as CONCENTRATES,isnull(a.MINERAL_TYPE COLLATE DATABASE_DEFAULT,'Iron Ore') as MINERAL_TYPE, "
			+ " (isnull(sum(pfd.TOTAL_FINES),0)-isnull(a.FINES,0)+isnull(sum(pfd.TOTAL_LUMPS),0)-isnull(a.LUMPS,0)+isnull(sum(pfd.TAILINGS),0)-isnull(a.TAILINGS,0)+isnull(sum(pfd.REJECTS),0)-isnull(a.REJECTS,0)+isnull(sum(pfd.TOTAL_UFO),0)-isnull(a.UFO,0)+isnull(sum(pfd.TOTAL_CONCENTRATES),0)-isnull(a.CONCENTRATES,0)) as TOTAL_QTY,isnull(ROM_QTY,0) as ROM_QTY "
			+ " from MINING.dbo.PLANT_MASTER a  "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER b on b.ID=a.ORGANIZATION_ID and b.SYSTEM_ID=a.SYSTEM_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.PLANT_FEED_DETAILS pfd on pfd.PLANT_ID=a.ID and pfd.SYSTEM_ID=a.SYSTEM_ID and pfd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) "
			+ " group by a.ORGANIZATION_ID,a.PLANT_NAME,b.ORGANIZATION_CODE,a.REJECTS,a.UFO,a.LUMPS,a.FINES,a.TAILINGS,a.ID,a.ROM_QTY,a.MINERAL_TYPE,a.CONCENTRATES,b.ORGANIZATION_NAME,b.ID ";

	public static final String GET_EXPORT_DETAILS = " select 'STOCK/JETTY' as STOCK_TYPE,ROUTE_ID,c.NAME COLLATE DATABASE_DEFAULT as NAME,ORGANIZATION_ID,isnull(a.FINES,0) as TOTAL_FINES,isnull(a.LUMPS,0) as TOTAL_LUMPS,isnull(a.CONCENTRATES,0) as TOTAL_CONC,isnull(a.TAILINGS,0) as TAILINGS,isnull(a.REJECTS,0) as REJECTS,isnull(a.UFO,0) as TOTAL_UFO,isnull(ROM_QTY,0) as ROM_QTY , "
			+ " (isnull(a.FINES,0)+isnull(a.LUMPS,0)+isnull(a.CONCENTRATES,0)+isnull(a.TAILINGS,0)+isnull(a.REJECTS,0)+isnull(a.UFO,0)) as TOTAL_QUANTITY   "
			+ " from AMS.dbo.MINING_STOCKYARD_MASTER a  "
			+ " inner join AMS.dbo.LOCATION_ZONE_A c on c.SYSTEMID=a.SYSTEM_ID and c.CLIENTID=a.CUSTOMER_ID and c.HUBID=a.ROUTE_ID  "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ORGANIZATION_ID=? and (a.MINERAL_TYPE is null or a.MINERAL_TYPE=?) and a.ROUTE_ID=? "
			+ " union all  "
			+ " select 'PLANT' as STOCK_TYPE,a.PLANT_ID as ROUTE_ID,isnull(pm.PLANT_NAME COLLATE DATABASE_DEFAULT,'') as NAME,a.ORGANIZATION_CODE as ORGANIZATION_ID, "
			+ " (sum(isnull(a.TOTAL_FINES,0))-isnull(pm.FINES,0)) as TOTAL_FINES ,(sum(isnull(a.TOTAL_LUMPS,0))-isnull(pm.LUMPS,0)) as TOTAL_LUMPS,(sum(isnull(a.TOTAL_CONCENTRATES,0))-isnull(pm.CONCENTRATES,0)) as TOTAL_CONCENTRATES,(sum(isnull(a.TAILINGS,0))-isnull(pm.TAILINGS,0)) as TAILINGS,(sum(isnull(a.REJECTS,0))-isnull(pm.REJECTS,0)) as REJECTS,(sum(isnull(a.TOTAL_UFO,0))-isnull(pm.UFO,0)) as TOTAL_UFO,0 as ROM_QTY , "
			+ " sum(isnull(a.TOTAL_FINES,0)+isnull(a.TOTAL_LUMPS,0)+isnull(a.TAILINGS,0)+isnull(a.REJECTS,0)+isnull(a.TOTAL_UFO,0)) as TOTAL_QUANTITY   "
			+ " from AMS.dbo.PLANT_FEED_DETAILS a  "
			+ " inner  join MINING.dbo.PLANT_MASTER pm on a.SYSTEM_ID=pm.SYSTEM_ID and a.CUSTOMER_ID=pm.CUSTOMER_ID and a.PLANT_ID=pm.ID and a.ORGANIZATION_CODE=ORGANIZATION_ID  "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.ORGANIZATION_CODE=? and pm.HUB_ID=? and pm.MINERAL_TYPE=?"
			+ " group by a.SYSTEM_ID,a.CUSTOMER_ID,a.ORGANIZATION_CODE,PLANT_ID,pm.PLANT_NAME,pm.LUMPS,pm.FINES,pm.TAILINGS,pm.REJECTS,pm.UFO,pm.UFO,pm.CONCENTRATES ";

	public static final String GET_EXPORT_DETAILS_FOR_RTP = " select 'STOCK/JETTY' as STOCK_TYPE,ROUTE_ID,c.NAME COLLATE DATABASE_DEFAULT as NAME,ORGANIZATION_ID,isnull(a.FINES,0) as TOTAL_FINES,isnull(a.LUMPS,0) as TOTAL_LUMPS,isnull(a.CONCENTRATES,0) as TOTAL_CONC,isnull(a.TAILINGS,0) as TAILINGS,isnull(a.REJECTS,0) as REJECTS,isnull(a.UFO,0) as TOTAL_UFO,isnull(ROM_QTY,0) as ROM_QTY , "
			+ " (isnull(a.FINES,0)+isnull(a.LUMPS,0)+isnull(a.CONCENTRATES,0)+isnull(a.TAILINGS,0)+isnull(a.REJECTS,0)+isnull(a.UFO,0)) as TOTAL_QUANTITY   "
			+ " from AMS.dbo.MINING_STOCKYARD_MASTER a  "
			+ " inner join AMS.dbo.LOCATION_ZONE_A c on c.SYSTEMID=a.SYSTEM_ID and c.CLIENTID=a.CUSTOMER_ID and c.HUBID=a.ROUTE_ID  "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ORGANIZATION_ID=? and (a.MINERAL_TYPE is null or a.MINERAL_TYPE=?) and a.ROUTE_ID=? ";

	public static final String GET_PERMIT_GRID_DEATILS = " select * from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=? ";

	public static final String SAVE_MINING_TRIP_SHEET_INFORMATION_FOR_BARGE = "INSERT INTO MINING.dbo.BARGE_TRIP_DETAILS (TRIP_NO,TYPE,ASSET_NUMBER,VALIDITY_DATE,QUANTITY,SYSTEM_ID,CUSTOMER_ID,STATUS,QUANTITY1,ISSUED_BY,USER_SETTING_ID,ORGANIZATION_ID,SOURCE_HUBID)VALUES(?,?,?,?,?,?,?,'OPEN',?,?,?,?,?)  ";

	public static final String SAVE_MINING_TRIP_SHEET_INFORMATION_FOR_BARGE_DIVERTION = "INSERT INTO MINING.dbo.BARGE_TRIP_DETAILS (TYPE,ASSET_NUMBER,QUANTITY,VALIDITY_DATE,SYSTEM_ID,CUSTOMER_ID,USER_SETTING_ID,ORGANIZATION_ID,SOURCE_HUBID,ROUTE_ID,DTS_ID,TRIP_COUNT,TRIP_NO,QUANTITY1,DIVERTED_QTY,STATUS,ISSUED_BY,MOTHER_VESSEL_NAME) "
			+ "(select TYPE,ASSET_NUMBER,QUANTITY,VALIDITY_DATE,SYSTEM_ID,CUSTOMER_ID,USER_SETTING_ID,ORGANIZATION_ID,SOURCE_HUBID,ROUTE_ID,isnull(DTS_ID,ID),TRIP_COUNT=isnull(TRIP_COUNT,0)+1,?+'-'+CONVERT(varchar(10), isnull(TRIP_COUNT,0)+1),?,?,?,?,? from MINING.dbo.BARGE_TRIP_DETAILS where ID=? ) ";

	public static final String UPDATE_STATUS_FOR_CLOSE_TRIP = "update MINING.dbo.BARGE_TRIP_DETAILS set STATUS='CLOSE',CLOSED_BY=?,CLOSED_DATETIME=getutcdate() where ASSET_NUMBER=? and TRIP_NO=? and CUSTOMER_ID=? and SYSTEM_ID=?";

	public static final String GET_VEHILCE_NO_FOR_BARGE_TRIP_SHEET_GEN = " select a.ASSET_NUMBER as VID,a.ASSET_NUMBER as VNAME,isnull(c.LoadCapacity,0) as QUANTITY1 from AMS.dbo.MINING_ASSET_ENROLLMENT a (NOLOCK) "
			+ " inner join AMS.dbo.VehicleRegistration b on b.SystemId =a.SYSTEM_ID and b.RegistrationNo=a.ASSET_NUMBER   "
			+ " inner join AMS.dbo.tblVehicleMaster c on c.System_id=a.SYSTEM_ID and a.ASSET_NUMBER=c.VehicleNo and c.Status=a.STATUS "
			+ " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER d on d.SYSTEM_ID=a.SYSTEM_ID and d.CUSTOMER_ID=a.CUSTOMER_ID    "
			+ " where a.SYSTEM_ID=? and d.CUSTOMER_ID=? and a.STATUS='Active' and VehicleType='BARGE' and a.VALIDITY_DATE >=Convert(varchar, GETDATE(),111)   "
			+ " and a.ASSET_NUMBER not in (select ASSET_NUMBER collate database_default from MINING.dbo.TRUCK_TRIP_DETAILS (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='OPEN')   "
			+ " group by a.ASSET_NUMBER,c.LoadCapacity ";

	public static final String UPDATE_STOCK_DEATILS = " update AMS.dbo.MINING_STOCKYARD_MASTER set FINES=isnull(FINES,0)-? , "
			+ " LUMPS=isnull(LUMPS,0)-?,CONCENTRATES=isnull(CONCENTRATES,0)-?,TAILINGS=isnull(TAILINGS,0)-?,TOTAL_QTY=TOTAL_QTY-? where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=? and ORGANIZATION_ID=? and MINERAL_TYPE=?";

	public static final String UPDATE_STOCK_DEATILS_ROM = " update AMS.dbo.MINING_STOCKYARD_MASTER set ROM_QTY=isnull(ROM_QTY,0)-?  "
			+ " where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=? and ORGANIZATION_ID=? and MINERAL_TYPE=? ";

	public static final String GET_BARGE_NO_FOR_TRIP_SHEET_GEN = " select a.ASSET_NUMBER as VID,a.ASSET_NUMBER as VNAME,c.LoadCapacity, isnull(c.VehicleAlias,'') as VehicleAlias , "
			+ " (select sum(QUANTITY1) from MINING.dbo.BARGE_TRIP_DETAILS where ASSET_NUMBER=a.ASSET_NUMBER collate database_default "
			+ " and (STATUS<>'CLOSE' and STATUS<>'Closed-Completed-Modified Trip' and STATUS<>'Closed Diverted Trip' and STATUS<>'DIVERTED TRIP'))as BARGEQUANTITY "
			+ " from AMS.dbo.MINING_ASSET_ENROLLMENT a "
			+ " inner join AMS.dbo.tblVehicleMaster c on c.Status=a.STATUS and a.ASSET_NUMBER=c.VehicleNo collate database_default "
			+ " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER d on d.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " where a.SYSTEM_ID=? and d.CUSTOMER_ID=? and a.STATUS='Active' and a.VALIDITY_DATE >=Convert(varchar, GETDATE(),111) "
			+ " and c.VehicleType='BARGE' "
			+ " and a.ASSET_NUMBER collate database_default not in (select ASSET_NUMBER from MINING.dbo.BARGE_TRIP_DETAILS where SYSTEM_ID=a.SYSTEM_ID "
			+ " and CUSTOMER_ID=a.CUSTOMER_ID and ISSUED_BY=? and STATUS in ('OPEN','Start BLO')) "
			+ " group by a.ASSET_NUMBER,c.LoadCapacity,c.VehicleAlias ";

	public static final String GET_BARGE_TRIP_DETAILS = " select isnull(u.USER_NAME,'') as WBS,isnull(ue.USER_NAME,'') as WBD,om.ORGANIZATION_NAME as ORG_NAME,'TRIP' AS FLAG,isnull(SOURCE_HUBID,0) AS SOURCE_HUBID,"
			+ " isnull(ORGANIZATION_ID,0) as ORGANIZATION_ID,isnull(dateadd(mi,330,a.INSERTED_TIME),'') as  ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,"
			+ " isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER,isnull(b.VehicleAlias,'') as ASSET_ID, "
			+ " isnull(dateadd(mi,0,a.VALIDITY_DATE),'')as VALIDITY_DATE,isnull(a.QUANTITY,0)as QUANTITY2  ,"
			+ " a.STATUS,isnull(a.QUANTITY1,0)as QUANTITY1,isnull(dateadd(mi,330,a.CLOSED_DATETIME),'') as  CLOSED_DATETIME,"
			+ " isnull(a.MOTHER_VESSEL_NAME,'')as VESSEL_NAME,isnull(mpd.SHIP_NAME,'') as SHIP_NAME,isnull(a.DESTINATION,'')as DESTINATION,"
			+ " isnull(BOAT_NOTE,'')as BOAT_NOTE,isnull(a.REASON,'')as REASON,isnull(dateadd(mi,330,a.STOP_BLO_DATETIME),'')as STOP_BLO_DATETIME,ISSUED_BY,"
			+ " (isnull(a.QUANTITY1,0)-isnull(a.DIVERTED_QTY,0)*1000)*.001 as DIVERTED_QTY from MINING.dbo.BARGE_TRIP_DETAILS a "
			+ " left outer join AMS.dbo.tblVehicleMaster (NOLOCK) b on b.VehicleNo=a.ASSET_NUMBER collate database_default "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER (NOLOCK) om on om.ID=a.ORGANIZATION_ID "
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS mpd on mpd.ID=(select top 1 PERMIT_ID from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS WHERE BTS_ID=a.ID and STATUS='CLOSE') and mpd.SYSTEM_ID=a.SYSTEM_ID "
			+ " left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=a.ISSUED_BY  "
			+ " left outer join ADMINISTRATOR.dbo.USERS ue on ue.SYSTEM_ID=a.SYSTEM_ID and ue.USER_ID=a.CLOSED_BY "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.INSERTED_TIME between dateadd(mi,-330,?)  "
			+ " and dateadd(mi,-330,? ) and "
			+ "(a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))"
			+ " order by ID desc ";

	public static final String GET_BARGE_RFID_VEHICLE = "select a.VehicleNo,a.LoadCapacity as QUANTITY1,"
			+ "(select sum(QUANTITY1) from MINING.dbo.BARGE_TRIP_DETAILS where ASSET_NUMBER=a.VehicleNo collate database_default and (STATUS<>'CLOSE' and STATUS<>'Closed-Completed-Modified Trip' and STATUS<>'Closed Diverted Trip' and STATUS<>'DIVERTED TRIP'))as BARGEQUANTITY"
			+ " from AMS.dbo.tblVehicleMaster a "
			+ " inner join AMS.dbo.MINING_ASSET_ENROLLMENT c on c.SYSTEM_ID=a.System_id and c.ASSET_NUMBER=a.VehicleNo collate database_default "
			+ " where a.System_id=? and c.CUSTOMER_ID=? and a.Status='Active' and a.Gps_unit_number=? and a.VehicleType='BARGE' "
			+ " and c.ASSET_NUMBER not in (select ASSET_NUMBER collate database_default from MINING.dbo.BARGE_TRIP_DETAILS where SYSTEM_ID=c.SYSTEM_ID "
			+ " and CUSTOMER_ID=c.CUSTOMER_ID and ISSUED_BY=? and STATUS in ('OPEN','Start BLO')) ";

	public static final String GET_PERMIT_NO = " select top 1 OPERATION_TYPE,PERMIT_IDS,isnull(wm.LOCATION_ID,'') as SOURCE_HUBID,ts.DESTINATION_HUBID,isnull(ts.PERMIT_ID,0) as BARGE_HUBID from AMS.dbo.TRIP_SHEET_USER_SETTINGS ts "
			+ " inner join ADMINISTRATOR.dbo.USERS us on ts.SYSTEM_ID= us.SYSTEM_ID and ts.USER_ID=us.USER_ID  "
			+ " left outer join MINING.dbo.WEIGHBRIDGE_MASTER wm on wm.ID=ts.SOURCE_HUBID "
			+ " where ts.SYSTEM_ID =? and ts.CUSTOMER_ID=? and ts.USER_ID=? and us.STATUS='Active' and ts.TYPE!='Close' "
			+ " order by ts.INSERTED_DATETIME desc ";

	public static final String GET_PERMIT_NO_FOR_TRIP_GEN = " select top 1 PERMIT_IDS,isnull(wm1.LOCATION_ID,0) as SOURCE_HUBID from AMS.dbo.TRIP_SHEET_USER_SETTINGS ts "
			+ " inner join ADMINISTRATOR.dbo.USERS us on ts.SYSTEM_ID= us.SYSTEM_ID and ts.USER_ID=us.USER_ID  "
			+ " left outer join MINING.dbo.WEIGHBRIDGE_MASTER wm1 on wm1.ID=ts.SOURCE_HUBID and wm1.CUSTOMER_ID=ts.CUSTOMER_ID "
			+ " where ts.SYSTEM_ID =? and ts.CUSTOMER_ID=? and ts.USER_ID=? and us.STATUS='Active' and ts.TYPE!='Close' "
			+ " order by ts.INSERTED_DATETIME desc ";

	public static final String SAVE_MINING_TRIP_SHEET_INFORMATION_FOR_TRUCK = "INSERT INTO MINING.dbo.BARGE_TRUCK_TRIP_DETAILS (TRIP_NO,TYPE,ASSET_NUMBER,TC_ID,VALIDITY_DATE,GRADE,QUANTITY,ROUTE_ID,SYSTEM_ID,CUSTOMER_ID,STATUS,QUANTITY1,SOURCE_HUBID,DESTINATION_HUBID,PERMIT_ID,ISSUED_BY,USER_SETTING_ID,ORGANIZATION_ID,BTS_ID,BARGE_TRANSACTION_ID,DS_SOURCE,DS_DESTINATION,TRIP_COUNT,COMMUNICATION_STATUS)VALUES(?,?,?,?,?,?,?,?,?,?,'CLOSE',?,?,?,?,?,?,?,?,?,?,?,?,?)  ";

	public static final String UPDATE_BARGE_QUANTITY_TO_TRIP_DETAILS = "UPDATE MINING.dbo.BARGE_TRIP_DETAILS SET QUANTITY1=isnull(QUANTITY1,0)+? WHERE SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String GET_SUM_BARGE_QUANTITY = "select sum(QUANTITY1) as BARGE_QUANTITY from MINING.dbo.BARGE_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? and (STATUS<>'CLOSE' and STATUS<>'Closed-Completed-Modified Trip' and STATUS<>'Closed Diverted Trip' and STATUS<>'DIVERTED TRIP') ";

	public static final String GET_BARGE_QUANTITY = "select QUANTITY1,STATUS from MINING.dbo.BARGE_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String UPDATE_STATUS_FOR_STOP_BLO = "update MINING.dbo.BARGE_TRIP_DETAILS set STATUS='Stop BLO',CLOSED_BY=?,CLOSED_DATETIME=getutcdate(),STOP_BLO_BY=?,STOP_BLO_DATETIME=getutcdate(),VALIDITY_DATE=(dateadd(hh,96,VALIDITY_DATE)) where ASSET_NUMBER=? and TRIP_NO=? and STATUS='Start BLO' and CUSTOMER_ID=? and SYSTEM_ID=?";

	public static final String GET_MINING_TRIP_SHEET_GENERATION_DETAILS_FOR_TRUCK = "(select pd.PERMIT_TYPE,isnull(COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS,isnull(dateadd(mi,330,a.INSERTED_TIME),'') as  ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER, "
			+ " isnull(b.LESSE_NAME,'') as LESSE_NAME,isnull(a.VALIDITY_DATE,'')as VALIDITY_DATE,isnull(a.GRADE,'')as GRADE_NAME,isnull(a.QUANTITY,'')as QUANTITY2,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME,   "
			+ " a.TC_ID ,a.ROUTE_ID,a.STATUS,isnull(a.QUANTITY1,0)as QUANTITY1,isnull(pd.PERMIT_NO,0)as PERMIT_ID,isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(pd.SHIP_NAME,'')as SHIP_NAME from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS a   "
			+ " left outer join AMS.dbo.MINING_TC_MASTER b on a.TC_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID   "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=a.ORGANIZATION_ID and mm.SYSTEM_ID=a.SYSTEM_ID and mm.CUSTOMER_ID=a.CUSTOMER_ID"
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS pd  on pd.ID=a.PERMIT_ID and pd.SYSTEM_ID=a.SYSTEM_ID and pd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.BTS_ID=?  " + " union "
			+ " select pd.PERMIT_TYPE,isnull(COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS,isnull(dateadd(mi,330,a.INSERTED_TIME),'') as  ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER,   "
			+ " isnull(b.LESSE_NAME,'') as LESSE_NAME,isnull(a.VALIDITY_DATE,'')as VALIDITY_DATE,isnull(a.GRADE,'')as GRADE_NAME,isnull(a.QUANTITY,'')as QUANTITY2,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME,    "
			+ " a.TC_ID ,a.ROUTE_ID,a.STATUS,isnull(a.QUANTITY1,0)as QUANTITY1,isnull(pd.PERMIT_NO,0)as PERMIT_ID,isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(pd.SHIP_NAME,'')as SHIP_NAME from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS_HISTORY a    "
			+ " left outer join AMS.dbo.MINING_TC_MASTER b on a.TC_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID    "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=a.ORGANIZATION_ID and mm.SYSTEM_ID=a.SYSTEM_ID and mm.CUSTOMER_ID=a.CUSTOMER_ID"
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS pd  on pd.ID=a.PERMIT_ID and pd.SYSTEM_ID=a.SYSTEM_ID and pd.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.BTS_ID=? ) ";

	public static final String UPDATE_BARGE_STATUS_AND_ROUTE_TO_TRIP_DETAILS = "UPDATE MINING.dbo.BARGE_TRIP_DETAILS SET STATUS='Start BLO' ,ROUTE_ID=? WHERE SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String GET_BARGE_TRIP_DATA_FOR_PDF = " select isnull(dateadd(mi,330,a.STOP_BLO_DATETIME),'') as  ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,"
			+ " isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER,"
			+ " isnull(dateadd(mi,330,a.VALIDITY_DATE),'')as VALIDITY_DATE,isnull(a.QUANTITY,'')as BARGE_CAPACITY,"
			+ " a.STATUS,isnull((select sum(QUANTITY-QUANTITY1) from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS where SYSTEM_ID=a.SYSTEM_ID and BTS_ID=a.ID and STATUS='CLOSE')/1000,0)as BARGE_QUANTITY, "
			+ " isnull((select QUANTITY1 from MINING.dbo.BARGE_TRIP_DETAILS where SYSTEM_ID=a.SYSTEM_ID and ID=a.ID)/1000,0)as BARGE_QUANTITY1,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME, "
			+ " '' as LESSE_NAME,isnull(mm.ORGANIZATION_NAME,'') as ORGANIZATION_NAME,"
			+ " lz3.NAME as SOURCE,lz4.NAME as DESTINATION,isnull(tbl.VehicleAlias,'')as ASSET_ID,isnull(a.MOTHER_VESSEL_NAME,'NA')as VESSEL_NAME,isnull(a.DIVERTED_QTY,0) as DIVERTED_QTY from MINING.dbo.BARGE_TRIP_DETAILS a "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " left outer join tblVehicleMaster tbl on tbl.VehicleNo=a.ASSET_NUMBER collate database_default and tbl.System_id=a.SYSTEM_ID"
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on a.SYSTEM_ID=mm.SYSTEM_ID and "
			+ " a.CUSTOMER_ID=mm.CUSTOMER_ID and mm.ID=ORGANIZATION_ID    "
			+ " left outer join LOCATION_ZONE_A lz3 on lz3.HUBID=rd.SOURCE_HUB_ID AND lz3.CLIENTID=rd.CUSTOMER_ID AND lz3.SYSTEMID=rd.SYSTEM_ID "
			+ " left outer join LOCATION_ZONE_A lz4 on lz4.HUBID=rd.DESTINATION_HUB_ID AND lz4.CLIENTID=rd.CUSTOMER_ID AND lz4.SYSTEMID=rd.SYSTEM_ID  "
			+ " where a.ID=? ";

	public static final String GET_PERMIT_DETAILS_FOR_BARGE = "( select isnull(pd.SHIP_NAME,'') as SHIP_NAME,pd.PERMIT_NO,sum(isnull((a.QUANTITY-a.QUANTITY1)/1000,0))as PERMIT_BALANCE,a.GRADE as GRADE from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS a "
			+ " inner join AMS.dbo.MINING_PERMIT_DETAILS pd on a.PERMIT_ID=pd.ID "
			+ " where a.BTS_ID=(select CASE WHEN DTS_ID IS NULL THEN ID ELSE DTS_ID END from MINING.dbo.BARGE_TRIP_DETAILS where ID=?) and a.STATUS!='Cancelled' "
			+ " group by PERMIT_NO,a.GRADE,pd.SHIP_NAME " + " union "
			+ " select isnull(pd.SHIP_NAME,'') as SHIP_NAME,pd.PERMIT_NO,sum(isnull((a.QUANTITY-a.QUANTITY1)/1000,0))as PERMIT_BALANCE,a.GRADE as GRADE from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS_HISTORY a "
			+ " inner join AMS.dbo.MINING_PERMIT_DETAILS pd on a.PERMIT_ID=pd.ID "
			+ " where a.BTS_ID=(select CASE WHEN DTS_ID IS NULL THEN ID ELSE DTS_ID END from MINING.dbo.BARGE_TRIP_DETAILS where ID=?) and a.STATUS!='Cancelled' "
			+ " group by PERMIT_NO,a.GRADE,pd.SHIP_NAME )";

	public static final String GET_VESSEL_NAME_FOR_BARGE_PDF = "(select top 1 SHIP_NAME from MINING_PERMIT_DETAILS where ID in (select top 1 PERMIT_ID from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS where BTS_ID=? and STATUS='CLOSE' order by ID)"
			+ " union "
			+ "select top 1 SHIP_NAME from MINING_PERMIT_DETAILS where ID in (select top 1 PERMIT_ID from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS_HISTORY where BTS_ID=? and STATUS='CLOSE' order by ID))";

	public static final String GET_VEHILCE_NO_FOR_TRIP_SHEET_GEN_TRUCK = "select a.ASSET_NUMBER as VID,a.ASSET_NUMBER as VNAME , e.TARE_WEIGHT_1 as QUANTITY1,max(e.WEIGHT_DATETIME),"
			+ " CASE WHEN datediff(dd,PUC_EXPIRY_DATE,getdate())<=0 THEN 'True' ELSE 'False' END as PUC_EXP_STATUS,CASE WHEN datediff(dd,INSURANCE_EXPIRY_DATE,getdate())<=0 THEN 'True' ELSE 'False' END as INSURANCE_EXP_STATUS from AMS.dbo.MINING_ASSET_ENROLLMENT a (NOLOCK) "
			+ " inner join AMS.dbo.VehicleRegistration b on b.SystemId =a.SYSTEM_ID and b.RegistrationNo=a.ASSET_NUMBER    "
			+ " inner join AMS.dbo.tblVehicleMaster c on c.System_id=a.SYSTEM_ID and a.ASSET_NUMBER=c.VehicleNo and c.Status=a.STATUS    "
			+ " inner join AMS.dbo.MINING_TARE_WEIGHT_MASTER e (NOLOCK) on e.ASSET_NUMBER=a.ASSET_NUMBER and e.SYSTEM_ID=a.SYSTEM_ID  "
			+ " and e.WEIGHT_DATETIME=(select max(WEIGHT_DATETIME) from AMS.dbo.MINING_TARE_WEIGHT_MASTER (NOLOCK) where ASSET_NUMBER=a.ASSET_NUMBER and SYSTEM_ID=a.SYSTEM_ID )"
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='Active' and a.VALIDITY_DATE >=Convert(varchar, GETDATE(),111) and c.VehicleType!='BARGE'  "
			+ " and a.ASSET_NUMBER collate database_default not in (select ASSET_NUMBER from MINING.dbo.TRUCK_TRIP_DETAILS (NOLOCK) where SYSTEM_ID=?  "
			+ " and a.CUSTOMER_ID=? and STATUS='OPEN') group by a.ASSET_NUMBER, e.TARE_WEIGHT_1, INSURANCE_EXPIRY_DATE, PUC_EXPIRY_DATE ";

	public static final String GET_VEHILCE_NO_FOR_BARGE_TRUCK_TRIPSHEET = "select CASE WHEN datediff(dd,PUC_EXPIRY_DATE,getdate())<=0 THEN 'True' ELSE 'False' END as PUC_EXPIRED_STATUS,CASE WHEN datediff(dd,INSURANCE_EXPIRY_DATE,getdate())<=0 THEN 'True' ELSE 'False' END as INSURANCE_EXPIRED_STATUS,a.ASSET_NUMBER as VID,a.ASSET_NUMBER as VNAME , e.TARE_WEIGHT_1 as QUANTITY1 from AMS.dbo.MINING_ASSET_ENROLLMENT a (NOLOCK) "
			+ " inner join AMS.dbo.tblVehicleMaster c (NOLOCK) on c.System_id=a.SYSTEM_ID and a.ASSET_NUMBER=c.VehicleNo and c.Status=a.STATUS    "
			+ " inner join AMS.dbo.MINING_TARE_WEIGHT_MASTER e (NOLOCK) on e.SYSTEM_ID=a.SYSTEM_ID and e.CUSTOMER_ID=a.CUSTOMER_ID and e.ASSET_NUMBER=a.ASSET_NUMBER "
			+ " and e.WEIGHT_DATETIME=(select max(WEIGHT_DATETIME) from AMS.dbo.MINING_TARE_WEIGHT_MASTER (NOLOCK) where SYSTEM_ID=a.SYSTEM_ID and CUSTOMER_ID=a.CUSTOMER_ID and ASSET_NUMBER=a.ASSET_NUMBER )"
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='Active' and a.VALIDITY_DATE >=Convert(varchar, GETDATE(),111) and c.VehicleType!='BARGE'  "
			+ " and (a.TRIP_STATUS='CLOSE' or a.TRIP_STATUS is null) group by a.ASSET_NUMBER, e.TARE_WEIGHT_1,INSURANCE_EXPIRY_DATE,PUC_EXPIRY_DATE ";

	public static final String GET_GRADE_FOR_BARGE = "select top 1 GRADE as GRADE_DETAILS from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS td where  BTS_ID=? and STATUS='CLOSE' order by td.ID";

	public static final String GET_MINING_ORGANIZATION_MASTER = " select isnull(GST_NO,'') as GST_NO,isnull(ALIAS_NAME,'') as ALIAS_NAME ,isnull(M_WALLET_BALANCE,0) as M_WALLET_BALANCE,ID as UniqueID, isnull(ORGANIZATION_CODE,'') as ORGANIZATION_CODE, isnull(ORGANIZATION_NAME,'') as ORGANIZATION_NAME,isnull(IMP_FINES_QTY,0)as IMP_FINES_QTY,isnull(IMP_LUMPS_QTY,0)as IMP_LUMPS_QTY,isnull(IMP_CONCENTRATES_QTY,0) as IMP_CONCENTRATES_QTY,isnull(IMP_TAILINGS_QTY,0) as IMP_TAILINGS_QTY,isnull(PURCHASED_ROM,0) as PURCHASED_ROM "
			+ " from AMS.dbo.MINING_ORGANIZATION_MASTER mom where SYSTEM_ID=? and CUSTOMER_ID=? and TYPE='ORGANIZATION' order by mom.ID desc";

	public static final String CHECK_ORGANIZATION_CODE = "select ORGANIZATION_CODE from AMS.dbo.MINING_ORGANIZATION_MASTER mom where SYSTEM_ID=? and CUSTOMER_ID=? and mom.ORGANIZATION_CODE=? ";

	public static final String INSERT_MINING_ORGANIZATION_MASTER_INFO = "insert into AMS.dbo.MINING_ORGANIZATION_MASTER(ORGANIZATION_CODE,ORGANIZATION_NAME,SYSTEM_ID,CUSTOMER_ID,ALIAS_NAME,GST_NO) values (?,?,?,?,?,?)";

	public static final String UPDATE_MINING_ORGANIZATION_MASTER_INFO = " update AMS.dbo.MINING_ORGANIZATION_MASTER  set ORGANIZATION_CODE=? ,ORGANIZATION_NAME=?,ALIAS_NAME=?,GST_NO=? where ID=? ";

	public static final String GET_NON_ASSOCIATION_DATA = " select distinct isnull(a.TC_NO,'NA') as TC_NO,isnull(a.ID,0) as TC_ID,c.ORGANIZATION_NAME,c.ID as ORG_ID"
			+ " from AMS.dbo.MINING_ORGANIZATION_MASTER c "
			+ " inner join AMS.dbo.MINING_MINE_MASTER b on c.ID=b.ORG_ID and b.SYSTEM_ID=c.SYSTEM_ID and b.CUSTOMER_ID=c.CUSTOMER_ID "
			+ " inner join AMS.dbo.MINING_TC_MASTER a on b.ID=a.MINE_ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " where c.CUSTOMER_ID=? and c.SYSTEM_ID=? and (a.ID not in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select distinct isnull(a.TC_NO,'NA') as TC_NO,isnull(a.ID,0) as TC_ID,c.ORGANIZATION_NAME,c.ID as ORG_ID"
			+ " from AMS.dbo.MINING_ORGANIZATION_MASTER c "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER b on c.ID=b.ORG_ID and b.SYSTEM_ID=c.SYSTEM_ID and b.CUSTOMER_ID=c.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_TC_MASTER a on b.ID=a.MINE_ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID and a.ID=0 "
			+ " where c.CUSTOMER_ID=? and c.SYSTEM_ID=? and (c.ID not in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID=0)) ";

	public static final String GET_NON_ASSOCIATION_DATA_FOR_LTSP_USERS = " select distinct isnull(a.TC_NO,'NA') as TC_NO,isnull(a.ID,0) as TC_ID,c.ORGANIZATION_NAME,c.ID as ORG_ID "
			+ " from AMS.dbo.MINING_ORGANIZATION_MASTER c "
			+ " inner join AMS.dbo.MINING_MINE_MASTER b on c.ID=b.ORG_ID and b.SYSTEM_ID=c.SYSTEM_ID and b.CUSTOMER_ID=c.CUSTOMER_ID "
			+ " inner join AMS.dbo.MINING_TC_MASTER a on b.ID=a.MINE_ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " where c.SYSTEM_ID=? and (a.ID not in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) ) "
			+ " union all "
			+ " select distinct isnull(a.TC_NO,'NA') as TC_NO,isnull(a.ID,0) as TC_ID,c.ORGANIZATION_NAME,c.ID as ORG_ID "
			+ " from AMS.dbo.MINING_ORGANIZATION_MASTER c "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER b on c.ID=b.ORG_ID and b.SYSTEM_ID=c.SYSTEM_ID and b.CUSTOMER_ID=c.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_TC_MASTER a on b.ID=a.MINE_ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID and a.ID=0 "
			+ " where c.SYSTEM_ID=? and (c.ID not in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID=0)) ";

	public static final String GET_USERS = " select USER_ID, isnull(FIRST_NAME,'')+' '+isnull(LAST_NAME,'') as User_Name from ADMINISTRATOR.dbo.USERS (NOLOCK) where CUSTOMER_ID=? and SYSTEM_ID=? and STATUS='Active' ";

	public static final String GET_ASSOCIATION_DATA = "select isnull(a.TC_NO,'NA') as TC_NO,isnull(a.ID,0) as TC_ID,isnull(d.ORGANIZATION_NAME,'') as ORGANIZATION_NAME,d.ID as ORG_ID,c.TC_ID,c.ORG_ID "
			+ "from MINING.dbo.USER_TC_ASSOCIATION c "
			+ "left outer join AMS.dbo.MINING_TC_MASTER a on a.SYSTEM_ID=c.SYSTEM_ID and c.TC_ID=a.ID "
			+ "left outer join AMS.dbo.MINING_ORGANIZATION_MASTER d on d.ID=c.ORG_ID and d.SYSTEM_ID=c.SYSTEM_ID "
			+ "where c.USER_ID=? and c.SYSTEM_ID=? and d.CUSTOMER_ID=?";

	public static final String GET_ASSOCIATION_DATA_FOR_LTSP_USERS = " select isnull(a.TC_NO,'NA') as TC_NO,isnull(a.ID,0) as TC_ID,d.ORGANIZATION_NAME,d.ID as ORG_ID from MINING.dbo.USER_TC_ASSOCIATION c "
			+ " left outer join AMS.dbo.MINING_TC_MASTER a on a.SYSTEM_ID=c.SYSTEM_ID and c.TC_ID=a.ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER d on d.ID=c.ORG_ID and d.SYSTEM_ID=c.SYSTEM_ID "
			+ " where c.USER_ID=? and c.SYSTEM_ID=? ";

	public static final String GET_ASSOCIATION_DATA_FOR_LTSP_USERS_BASED_ON_LOGIN = " select isnull(a.TC_NO,'NA') as TC_NO,isnull(a.ID,0) as TC_ID,d.ORGANIZATION_NAME,d.ID as ORG_ID from MINING.dbo.USER_TC_ASSOCIATION c "
			+ " left outer join AMS.dbo.MINING_TC_MASTER a on a.SYSTEM_ID=c.SYSTEM_ID and c.TC_ID=a.ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER d on d.ID=c.ORG_ID and d.SYSTEM_ID=c.SYSTEM_ID "
			+ " where c.USER_ID=? and c.SYSTEM_ID=? "
			+ " and (c.TC_ID  in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) "
			+ " and c.ORG_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) ";

	public static final String GET_USERS_FOR_USER_SETTING = " select distinct ta.USER_ID,us.USER_NAME from MINING.dbo.USER_TC_ASSOCIATION ta "
			+ " inner join ADMINISTRATOR.dbo.USERS us on ta.USER_ID=us.USER_ID and ta.SYSTEM_ID=us.SYSTEM_ID "
			+ " where us.SYSTEM_ID=? and (us.CUSTOMER_ID=0 or (us.CUSTOMER_ID=? and us.USERAUTHORITY in ('User','Supervisor'))) "
			+ " and us.STATUS='Active' #condition#";

	public static final String CHECK_IF_PRESENT = " select * from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and TC_ID=? and ORG_ID=? and SYSTEM_ID=?";

	public static final String INSERT_INTO_USER_TC_ASSOCIATION = " insert into MINING.dbo.USER_TC_ASSOCIATION(USER_ID,TC_ID,SYSTEM_ID,INSERTED_TIME,ASSOCIATED_BY,ORG_ID) values (?,?,?,getutcdate(),?,?) ";

	public static final String MOVE_DATA_TO_USER_TC_ASSOCIATION_HISTORY = "insert into MINING.dbo.USER_TC_ASSOCIATION_HISTORY(ID,USER_ID,TC_ID,ORG_ID,SYSTEM_ID,INSERTED_TIME,DISASSOCIATED_BY,DISASSOCIATED_TIME,ASSOCIATED_BY) "
			+ " select ID,USER_ID,TC_ID,ORG_ID,SYSTEM_ID,INSERTED_TIME,?,getutcdate(),ASSOCIATED_BY from MINING.dbo.USER_TC_ASSOCIATION"
			+ " where USER_ID=? and TC_ID=? and ORG_ID=?  and SYSTEM_ID=? ";

	public static final String DELETE_FROM_USER_TC_ASSOCIATION = "delete from  MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and TC_ID=? and ORG_ID=? and SYSTEM_ID=?";

	public static final String GET_EWALLET_NO_QTY = "select top 1 (case when GIOPF_QTY>0 then 'TRUE' else 'FALSE' end) as STATUS,pd.ID,a.CHALLAN_NO,sum(b1.QUANTITY)as QUANTITY,(select isnull(round((sum(b.PAYABLE)+(30*sum(b.PAYABLE)/100)+(2*sum(b.PAYABLE)/100 )+round(sum(a.GIOPF_QTY*a.GIOPF_RATE),0)+round(0*sum(b.QUANTITY),0)),0),0) from CHALLAN_GRADE_DETAILS b where b.CHALLAN_ID=pd.CHALLAN_ID)as TOTAL_PAYABLE,isnull(a.USED_QTY,0) as USED_QTY,isnull(a.USED_AMOUNT,0) as USED_AMOUNT from AMS.dbo.MINING_PERMIT_DETAILS pd   "
			+ " inner join AMS.dbo.MINING_CHALLAN_DETAILS a on a.ID=pd.CHALLAN_ID "
			+ " inner join  AMS.dbo.CHALLAN_GRADE_DETAILS b1 on a.ID=b1.CHALLAN_ID " + " where pd.ID=? "
			+ " group by pd.ID,a.CHALLAN_NO,a.TOTAL_PAYABLE,a.USED_QTY,a.USED_AMOUNT,pd.CHALLAN_ID,GIOPF_QTY ";

	public static final String GET_EWALLET_NO_QTY_FOR_CHALLAN = "select a.ID,a.CHALLAN_NO,sum(b.QUANTITY)as QUANTITY ,a.TOTAL_PAYABLE,isnull(a.USED_QTY,0) as USED_QTY,isnull(a.USED_AMOUNT,0) as USED_AMOUNT from AMS.dbo.MINING_PERMIT_DETAILS pd   "
			+ " inner join MINING_CHALLAN_DETAILS a on a.ID=pd.CHALLAN_ID   "
			+ "  inner join  AMS.dbo.CHALLAN_GRADE_DETAILS b on a.ID=b.CHALLAN_ID  "
			+ "  where pd.CHALLAN_ID=? group by a.ID,a.CHALLAN_NO,a.TOTAL_PAYABLE,a.USED_QTY,a.USED_AMOUNT";

	public static final String GET_QTY = "select sum(isnull(QUANTITY,0)) as QUANTITY,sum(isnull(PAYABLE,0)) as PAYABLE from dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=?";

	public static final String UPDATE_E_WALLET_FOR_ROM_CLOSURE = " update AMS.dbo.MINING_TC_MASTER set AMOUNT=AMOUNT+? ,QUANTITY=QUANTITY+?,MPL_BALANCE=MPL_BALANCE-? where ID=? ";

	public static final String GET_GRADE_FOR_OTHERS = "select GRADE,TYPE from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=?";

	public static final String GET_GRADE_FOR_RTP = "select b.GRADE from dbo.MINING_PERMIT_DETAILS a "
			+ " inner join dbo.CHALLAN_GRADE_DETAILS b on b.CHALLAN_ID=a.CHALLAN_ID where a.ID=?";

	public static final String GET_TC_NUMBER_PERMIT = "select isnull(a.CTO_DATE,'') as CTO_DATE,isnull(ALIAS_NAME,'')+'/'+cast(DATEPART(dd,getdate()) as varchar(10))+CONVERT(varchar(2), GETDATE(), 101)+'/'+(case when DATEPART(mm,getdate())>3 then cast(DATEPART(yyyy,getdate()) as varchar)+ '-'+substring(cast(DATEPART(yyyy,getdate())+1 as varchar),3,5) else "
			+ " cast(DATEPART(yyyy,getdate())-1 as varchar)+'-'+substring(cast(DATEPART(yyyy,getdate()) as varchar),3,5) end) as ALIAS_NAME,isnull(g.M_WALLET_BALANCE,0) as M_WALLET_BALANCE,c.ORG_ID as ORG_ID,isnull(a.MINE_CODE,'')as MINE_CODE,"
			+ " a.TC_NO,isnull(a.NAME_OF_MINE,'')as NAME_OF_MINE,isnull(b.LEASE_NAME,'')as OWNER_NAME,a.ID, "
			+ " isnull(c.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(AMOUNT,0) as QUANTITY, "
			+ " isnull(b.LEASE_NAME,'')as OWNER_NAME,a.ID,isnull(g.ORGANIZATION_CODE,'')as ORGANIZATION_CODE, "
			+ " isnull(AMOUNT,0) as QUANTITY from   " + " AMS.dbo.MINING_TC_MASTER a   "
			+ " inner join AMS.dbo.MINE_OWNER_MASTER b on a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID and a.TC_NO=b.TC_NO "
			+ " and a.CUSTOMER_ID=b.CUSTOMER_ID  "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=a.MINE_ID and c.SYSTEM_ID=a.SYSTEM_ID  "
			+ " and c.CUSTOMER_ID=a.CUSTOMER_ID   "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER g on c.ORG_ID=g.ID and c.SYSTEM_ID=g.SYSTEM_ID  and c.CUSTOMER_ID=g.CUSTOMER_ID  "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.NAME_OF_MINE is not null "
			+ " and a.ID  in(select TC_ID from MINING.dbo.USER_TC_ASSOCIATION  where USER_ID=? and  SYSTEM_ID=?) order by TC_NO desc";

	public static final String GET_MINING_CHALLAN_GRADE_DETAILS = "select isnull(GRADE,'') as GRADE,RATE,QUANTITY,PAYABLE from CHALLAN_GRADE_DETAILS where CHALLAN_ID=?";

	public static final String CHECK_PERMIT_NO = "select top 1 PERMIT_ID,PERMIT_IDS,isnull(ORGANISATION_CODE,0) as ORGANISATION_CODE,isnull(TC_ID,0)as TC_ID from TRIP_SHEET_USER_SETTINGS  "
			+ "where SYSTEM_ID=? and CUSTOMER_ID=? and USER_ID=? and TYPE!='Close' "
			+ " order by INSERTED_DATETIME desc";

	public static final String CHECK_PERMIT_NUMBER = "select top 1 pd.PERMIT_NO from AMS.dbo.MINING_PERMIT_DETAILS pd where  pd.SYSTEM_ID=? and pd.CUSTOMER_ID = ? and  pd.PERMIT_NO=?";

	public static final String CHECK_TRANSACTION_ID = "select isnull(BARGE_TRANSACTION_ID,'') as BARGE_TRANSACTION_ID from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and BARGE_TRANSACTION_ID=?";

	public static final String CHECK_BARGE_ID = "select isnull(VEHICLE_ID,'') as VEHICLE_ID from dbo.Live_Vision_Support where SYSTEM_ID=? and CLIENT_ID=? and REGISTRATION_NO=?";

	public static final String GET_PERMIT_DETAILS_FOR_IMPORT = "select pd.SHIP_NAME,pd.TC_ID,pd.ORGANIZATION_CODE,pd.START_DATE,pd.END_DATE,pd.PERMIT_NO,pd.ID,pd.CHALLAN_ID,rd.ROUTE_NAME as ROUTE_NAME,rd.ID as ROUTE_ID,  "
			+ " (select sum(QUANTITY) from  dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=pd.CHALLAN_ID) as QUANTITY,  "
			+ " isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY,  "
			+ " (select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=pd.ID ) as POTQUANTITY    "
			+ " ,(select GRADE from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=pd.ID) as GRADE  "
			+ " ,(select TYPE from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=pd.ID) as TYPE  "
			+ " from  AMS.dbo.MINING_PERMIT_DETAILS pd    " +
			//" inner  join AMS.dbo.Trip_Master tm on tm.Trip_id=pd.ROUTE_ID and tm.System_id=pd.SYSTEM_ID   " +
			" left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=pd.ROUTE_ID and rd.SYSTEM_ID=pd.SYSTEM_ID and rd.CUSTOMER_ID=pd.CUSTOMER_ID "
			+
			//" and tm.Client_id=pd.CUSTOMER_ID     " +
			" where  pd.SYSTEM_ID=? and pd.CUSTOMER_ID = ? and  pd.PERMIT_NO=?";

	public static final String GET_VEHICLE_TARE_WEIGHT_FOR_IMPORT = "select TARE_WEIGHT_1 as QUANTITY1,max(WEIGHT_DATETIME) from MINING_TARE_WEIGHT_MASTER "
			+ " where ASSET_NUMBER=? and SYSTEM_ID=? and  "
			+ " WEIGHT_DATETIME=(select max(WEIGHT_DATETIME) from MINING_TARE_WEIGHT_MASTER where  "
			+ " ASSET_NUMBER=? and SYSTEM_ID=?)  group by TARE_WEIGHT_1";

	public static final String GET_BARGE_DETAILS_FOR_IMPORT = "select sum(QUANTITY1) as BARGEQUANTITY from MINING.dbo.BARGE_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID= ? and ASSET_NUMBER=? and (STATUS<>'CLOSE' and STATUS<>'Closed-Completed-Modified Trip' and STATUS<>'Closed Diverted Trip' and STATUS<>'DIVERTED TRIP')";

	public static final String GET_BUYING_ORG_NAME = "select ID,ORGANIZATION_NAME,ORGANIZATION_CODE from MINING_ORGANIZATION_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_STATE_LIST = "select STATE_CODE,STATE_NAME from dbo.STATE_DETAILS where COUNTRY_CODE=? order by STATE_NAME asc";

	public static final String GET_PERMIT_QTY_FOR_CANCELLATION = "select (isnull(QUANTITY,0)-isnull(QUANTITY1,0))as PERMIT_QTY,PERMIT_ID from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS where BTS_ID=? and STATUS='CLOSE' and CUSTOMER_ID=? and SYSTEM_ID=?";

	public static final String UPDATE_TRIP_SHEET_QTY_FOR_BARGE_CANCELLATION = "update AMS.dbo.MINING_PERMIT_DETAILS set TRIPSHEET_QTY=TRIPSHEET_QTY-? where ID=? and CUSTOMER_ID=? and SYSTEM_ID=?";

	public static final String UPDATE_REMARK_REASON_FOR_BARGE_CANCELLATION = "UPDATE MINING.dbo.BARGE_TRIP_DETAILS SET QUANTITY1=QUANTITY1-?,BOAT_NOTE=?,REASON=?,STATUS='Closed-Cancelled Trip' where CUSTOMER_ID=? and SYSTEM_ID=?  and ID=?";

	public static final String MODIFY_BARGE_INFORMATION = "UPDATE MINING.dbo.BARGE_TRIP_DETAILS SET VALIDITY_DATE=?,STATUS=? ,DIVERTED_QTY=isnull(DIVERTED_QTY,0)+?,BOAT_NOTE=?,REASON=?,DESTINATION=?,CLOSED_BY=?,CLOSED_DATETIME=getutcdate() WHERE CUSTOMER_ID=? and SYSTEM_ID=?  and ID=? ";

	public static final String MODIFY_BARGE_INFORMATION_HISTORY = "UPDATE MINING.dbo.BARGE_TRIP_DETAILS SET VALIDITY_DATE=?,STATUS=? ,DIVERTED_QTY=isnull(DIVERTED_QTY,0)+?,BOAT_NOTE=?,REASON=?,DESTINATION=?,CLOSED_BY=?,CLOSED_DATETIME=getutcdate() WHERE CUSTOMER_ID=? and SYSTEM_ID=?  and ID=? ";

	public static final String GET_ROM_QUANTITY = " select sum(QUANTITY) as QUANTITY from  dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=? ";

	public static final String UPDATE_QUANTITY_FOR_TARE_AND_CLOSE_TRIP = " update MINING.dbo.TRUCK_TRIP_DETAILS set QUANTITY3=?,QUANTITY4=?,STATUS='CLOSE',CLOSED_BY=?,CLOSED_DATETIME=getutcdate(),CLOSING_TYPE=?,DESTINATION_TYPE=?,REASON=?,CLOSING_LOCATION=?,CLOSING_DATETIME=? where ID=? and STATUS='OPEN' and ASSET_NUMBER=?";

	public static final String GET_PERMIT_QTY_TRIP_SHEET = "select isnull(DEST_TYPE,0) as DEST_TYPE,MINERAL,PERMIT_TYPE,TRIPSHEET_NO,isnull(TRIPSHEET_QTY,0)as ACTUAL_QUANTITY,BUYING_ORG_ID,pd.ID,pd.CHALLAN_ID,(select sum(QUANTITY) from  dbo.CHALLAN_GRADE_DETAILS where "
			+ " CHALLAN_ID=pd.CHALLAN_ID) as QUANTITY,isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY ,"
			+ " (select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=pd.ID) as POTQUANTITY, isnull((select top 1 STATUS from MINING.dbo.TRUCK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NUMBER=? order by INSERTED_TIME desc),'CLOSE') as TRIP_STATUS"
			+ " from AMS.dbo.MINING_PERMIT_DETAILS pd where pd.ID=? and pd.SYSTEM_ID=? and pd.CUSTOMER_ID=? and pd.STATUS in ('APPROVED','ACKNOWLEDGED') and ID in (#)";

	public static final String CHECK_ORG_CODE_FOR_TRADER = " select isnull(ORGANIZATION_CODE,'') as ORGANIZATION_CODE from AMS.dbo.MINING_ORGANIZATION_MASTER "
			+ " WHERE SYSTEM_ID=? and CUSTOMER_ID=? and ORGANIZATION_CODE=? ";

	public static final String GET_TRADER_MASTER_DETAILS = "select isnull(TBR_APPLICATION_NO,'') as TBR_APPLICATION_NO,isnull(GST_NO,'') as GST_NO,isnull(ALIAS_NAME,'') as ALIAS_NAME,ID,IBM_APPLICATION_NO,isnull(APPLICATION_DATE,'') as APPLICATION_DATE,IBM_TRADER_NO,ORGANIZATION_NAME,ADDRESS,PAN_NO,IEC_NUMBER,TIN_NO,ORGANIZATION_CODE,isnull(DATE_OF_ISSUE,'') as DATE_OF_ISSUE,isnull(PURCHASED_ROM,0) as PURCHASED_ROM,isnull(PURCHASED_PROCESSED_ORE,0) as PURCHASED_PROCESSED_ORE, isnull(TYPE,'') as TYPE "
			+ " from AMS.dbo.MINING_ORGANIZATION_MASTER where CUSTOMER_ID=? and SYSTEM_ID=? and TYPE in ('TRADER','RAISING CONTRACTOR') order by ID desc";

	public static final String INSERT_MINING_TRADER_MASTER_DETAILS = "insert into AMS.dbo.MINING_ORGANIZATION_MASTER(ORGANIZATION_CODE,ORGANIZATION_NAME,TYPE,IBM_APPLICATION_NO,APPLICATION_DATE,IBM_TRADER_NO,ADDRESS,PAN_NO,IEC_NUMBER,TIN_NO,DATE_OF_ISSUE,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,ALIAS_NAME,GST_NO,TBR_APPLICATION_NO) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),?,?,?)";

	public static final String UPDATE_MINING_TRADER_MASTER_DETAILS = " update AMS.dbo.MINING_ORGANIZATION_MASTER  set ORGANIZATION_CODE=? ,ORGANIZATION_NAME=?,IBM_APPLICATION_NO=?,APPLICATION_DATE=?,IBM_TRADER_NO=?,ADDRESS=?,PAN_NO=?,IEC_NUMBER=?,TIN_NO=?,DATE_OF_ISSUE=?,UPDATED_BY=?,UPDATED_DATETIME=getutcdate(),ALIAS_NAME=?,GST_NO=?,TBR_APPLICATION_NO=? where ID=? ";

	public static final String GET_TOTAL_USED_FOR_CHALLAN = " select a.ID,a.CHALLAN_NO,sum(b.QUANTITY)as TOTAL_QUANTITY ,a.TOTAL_PAYABLE AS TOTAL_AMOUNT,isnull(a.USED_QTY,0) as USED_QTY, "
			+ " isnull(a.USED_AMOUNT,0) as USED_AMOUNT from AMS.dbo.MINING_PERMIT_DETAILS pd   "
			+ " inner join MINING_CHALLAN_DETAILS a on a.ID=pd.CHALLAN_ID   "
			+ " inner join  AMS.dbo.CHALLAN_GRADE_DETAILS b on a.ID=b.CHALLAN_ID "
			+ " where a.ID=? group by a.ID,a.CHALLAN_NO,a.TOTAL_PAYABLE,a.USED_QTY,a.USED_AMOUNT ";

	public static final String GET_BAUXITE_CHALLAN = " select ID,CHALLAN_NO from dbo.MINING_CHALLAN_DETAILS WHERE SYSTEM_ID=? and CUSTOMER_ID=? and "
			+ " STATUS in ('APPROVED') and CHALLAN_NO like 'BEWC%' and TC_NO=?  and "
			+ " ID not in (select CHALLAN_ID from AMS.dbo.MINING_PERMIT_DETAILS where SYSTEM_ID=? AND CUSTOMER_ID=?) ";

	public static final String GET_EXPORT_DETAILS_FOR_BAUXITE = " select ROUTE_ID,c.NAME,ORGANIZATION_ID,'STOCK/JETTY' as STOCK_TYPE,isnull(a.FINES,0) as TOTAL_FINES,isnull(a.LUMPS,0) as TOTAL_LUMPS,isnull(a.CONCENTRATES,0) as TOTAL_CONC, "
			+ " isnull(a.TAILINGS,0) as TAILINGS,isnull(a.REJECTS,0) as REJECTS,isnull(a.UFO,0) as TOTAL_UFO,isnull(TOTAL_QTY,0) as TOTAL_QUANTITY,isnull(ROM_QTY,0) as ROM_QTY "
			+ " from AMS.dbo.MINING_STOCKYARD_MASTER a  "
			+ " inner join dbo.LOCATION_ZONE_A c on c.SYSTEMID=a.SYSTEM_ID and c.CLIENTID=a.CUSTOMER_ID and c.HUBID=a.ROUTE_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.ORGANIZATION_ID=? and a.MINERAL_TYPE ='Bauxite/Laterite' ";

	public static final String GET_ORG_NO_BASED_ON_TCNO = " select isnull(a.ID,0) as TC_ID,c.ID as ORG_ID from AMS.dbo.MINING_ORGANIZATION_MASTER c  "
			+ " inner join AMS.dbo.MINING_MINE_MASTER b on c.ID=b.ORG_ID and b.SYSTEM_ID=c.SYSTEM_ID and b.CUSTOMER_ID=c.CUSTOMER_ID  "
			+ " inner join AMS.dbo.MINING_TC_MASTER a on b.ID=a.MINE_ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID  "
			+ " where c.SYSTEM_ID=? and c.CUSTOMER_ID=? and a.ID=? ";

	public static final String GET_DETAILS_FROM_PROCESSED_ORE_PERMIT_DETAILS = " select * from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=? ";

	public static final String UPDATE_ORG_DETAILS = " update MINING.dbo.PLANT_MASTER set FINES=isnull(FINES,0)-? ,LUMPS=isnull(LUMPS,0)-?,CONCENTRATES=isnull(CONCENTRATES,0)-?,TAILINGS=isnull(TAILINGS,0)-? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?  ";

	public static final String UPDATE_STOCK_DETAILS_FOR_PERMIT_CLOSURE = " update AMS.dbo.MINING_STOCKYARD_MASTER set FINES=isnull(FINES,0)+? , "
			+ " LUMPS=isnull(LUMPS,0)+?,CONCENTRATES=isnull(CONCENTRATES,0)+?,TAILINGS=isnull(TAILINGS,0)+?,TOTAL_QTY=TOTAL_QTY+?,ROM_QTY=isnull(ROM_QTY,0)+? where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=? and ORGANIZATION_ID=? and MINERAL_TYPE=? ";

	//************************************Plant Master Details Starts******************************//

	public static final String INSERT_INTO_PLANT_MASTER = "insert into MINING.dbo.PLANT_MASTER(PLANT_NAME,HUB_ID,ORGANIZATION_ID,TC_ID,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,MINERAL_TYPE) values (?,?,?,?,?,?,?,getutcdate(),?) ";

	public static final String GET_PLANT_MASTER_DETAILS = "select a.MINERAL_TYPE,a.ID,a.ORGANIZATION_ID,a.TC_ID,isnull(a.PLANT_NAME,'') as PLANT_NAME,isnull(lza.NAME,'')as HUB_NAME,isnull(a.HUB_ID,0)as HUB_ID,isnull(b.ORGANIZATION_NAME,'') as ORGANIZATION_NAME,isnull(b.ORGANIZATION_CODE,'') as ORGANIZATION_CODE,isnull(c.TC_NO,'') as TC_NO, "
			+ " isnull(sum(pfd.REJECTS),0) as TOTAL_REJECTS,isnull(sum(pfd.TOTAL_UFO),0) as TOTAL_UFO,isnull(sum(pfd.TOTAL_LUMPS),0) as TOTAL_LUMPS,isnull(sum(pfd.TOTAL_FINES),0) as TOTAL_FINES,isnull(sum(pfd.TAILINGS),0) as TOTAL_TAILINGS,isnull(sum(pfd.TOTAL_CONCENTRATES),0) as TOTAL_CONCENTRATES, "
			+ " isnull(a.REJECTS,0) as USED_REJECTS,isnull(a.UFO,0) as USED_UFO,isnull(a.LUMPS,0) as USED_LUMPS,isnull(a.FINES,0) as USED_FINES,isnull(a.TAILINGS,0) as USED_TAILINGS,isnull(a.CONCENTRATES,0) as USED_CONCENTRATES "
			+ " from MINING.dbo.PLANT_MASTER a "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER b on b.ID=a.ORGANIZATION_ID and b.SYSTEM_ID=a.SYSTEM_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_TC_MASTER c on c.ID=a.TC_ID  and c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.PLANT_FEED_DETAILS pfd on pfd.PLANT_ID=a.ID and pfd.SYSTEM_ID=a.SYSTEM_ID and pfd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lza on lza.SYSTEMID=a.SYSTEM_ID and lza.CLIENTID=a.CUSTOMER_ID and lza.HUBID=a.HUB_ID and lza.OPERATION_ID!=2 "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.ORGANIZATION_ID  in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=?) "
			+ " group by a.ID,a.ORGANIZATION_ID,a.TC_ID,a.PLANT_NAME,b.ORGANIZATION_NAME,b.ORGANIZATION_CODE,c.TC_NO,a.REJECTS,a.UFO,a.LUMPS,a.FINES,a.TAILINGS,lza.NAME,a.HUB_ID,a.MINERAL_TYPE,a.CONCENTRATES "
			+ " order by a.ID desc ";

	public static final String UPDATE_PLANT_MASTER_DETAILS = " update MINING.dbo.PLANT_MASTER set PLANT_NAME=?,HUB_ID=? ,ORGANIZATION_ID=?,TC_ID=?,UPDATED_BY=?,UPDATED_DATETIME=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String GET_TC_FOR_PLANT_MASTER = " select isnull(a.ID,0) as TC_ID,isnull(a.TC_NO,'') as TC_NO from AMS.dbo.MINING_ORGANIZATION_MASTER c "
			+ " inner join AMS.dbo.MINING_MINE_MASTER b on c.ID=b.ORG_ID and b.SYSTEM_ID=c.SYSTEM_ID and b.CUSTOMER_ID=c.CUSTOMER_ID "
			+ " inner join AMS.dbo.MINING_TC_MASTER a on b.ID=a.MINE_ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " where c.SYSTEM_ID=? and c.CUSTOMER_ID=? and c.ID=? ";

	//************************************Plant Master Details ends******************************//

	public static final String GET_TRIP_DETAILS_FOR_CANCEL_TRIP_FOR_TRUCK = " select ID,(isnull(QUANTITY,0)-isnull(QUANTITY1,0)) as TOTAL_QTY,isnull(DESTINATION_HUBID,0) as DESTINATION,isnull(ORGANIZATION_ID,0) as ORG_ID, "
			+ " isnull(PERMIT_ID,0) as PERMIT_ID,isnull(GRADE,'') as START_LOCATION,INSERTED_TIME,CASE WHEN datediff(ss,dateadd(ss,0,INSERTED_TIME),getutcdate())<=300 THEN 'T' ELSE 'F' END as CLIENT_CLOSABLE "
			+ " from MINING.dbo.TRUCK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String GET_TRIP_DETAILS_FOR_CANCEL_TRIP = " select BTS_ID,ID,(isnull(QUANTITY,0)-isnull(QUANTITY1,0)) as TOTAL_QTY,isnull(DESTINATION_HUBID,0) as DESTINATION,isnull(ORGANIZATION_ID,0) as ORG_ID, "
			+ " isnull(PERMIT_ID,0) as PERMIT_ID,isnull(GRADE,'') as START_LOCATION,INSERTED_TIME,CASE WHEN datediff(ss,dateadd(ss,0,INSERTED_TIME),getutcdate())<=300 THEN 'T' ELSE 'F' END as CLIENT_CLOSABLE "
			+ " from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String UPDATE_STOCK_DETAILS_FOR_CANCEL_TRIP = " update AMS.dbo.MINING_STOCKYARD_MASTER set FINES=FINES-?,LUMPS=LUMPS-?,TOTAL_QTY=TOTAL_QTY-?,ROM_QTY=ROM_QTY-?,CONCENTRATES=CONCENTRATES-?,TAILINGS=TAILINGS-? where ROUTE_ID=? and ORGANIZATION_ID=? and MINERAL_TYPE=? ";

	public static final String UPDATE_CLOSE_TRIP_DETAILS = " update MINING.dbo.TRUCK_TRIP_DETAILS set STATUS= 'Cancelled',CLOSED_BY=?,CLOSED_DATETIME=GETutcDATE() where ID=? and STATUS='OPEN' and (QUANTITY3 is null or  QUANTITY3=0) and (QUANTITY4 is null or QUANTITY4=0) ";

	public static final String UPDATE_TRIPSHEET_QTY = " update AMS.dbo.MINING_PERMIT_DETAILS set TRIPSHEET_QTY=TRIPSHEET_QTY-? where ID=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_PLANT_NAME_FOR_PLANT_FEED = "select pm.ID as PLANT_ID,isnull(pm.PLANT_NAME,'')as PLANT_NAME,isnull(ROM_QTY,0) as PLANT_QTY,isnull((select sum(TOTAL_UFO) from AMS.dbo.PLANT_FEED_DETAILS where SYSTEM_ID=pm.SYSTEM_ID and CUSTOMER_ID=pm.CUSTOMER_ID and ORGANIZATION_CODE=pm.ORGANIZATION_ID and PLANT_ID=pm.ID),0) - isnull(UFO,0) as UFO_QTY, "
			+ " isnull((select sum(TOTAL_LUMPS) from AMS.dbo.PLANT_FEED_DETAILS "
			+ " where SYSTEM_ID=pm.SYSTEM_ID and CUSTOMER_ID=pm.CUSTOMER_ID and ORGANIZATION_CODE=pm.ORGANIZATION_ID and PLANT_ID=pm.ID),0) - isnull(LUMPS,0) as LUMPS_QTY "
			+ " from MINING.dbo.PLANT_MASTER pm " + " where pm.SYSTEM_ID=? and pm.CUSTOMER_ID=? and ORGANIZATION_ID=?";

	public static final String UPDATE_UFO_QTY_IN_PLANT_MASTER_FOR_PLANT_FEED = "update MINING.dbo.PLANT_MASTER set UFO=isnull(UFO,0)+? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String UPDATE_LUMPS_QTY_IN_PLANT_MASTER_FOR_PLANT_FEED = "update MINING.dbo.PLANT_MASTER set LUMPS=isnull(LUMPS,0)+? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String UPDATE_PLANT_MASTER = " update MINING.dbo.PLANT_MASTER set FINES=isnull(FINES,0)+? ,LUMPS=isnull(LUMPS,0)+?,CONCENTRATES=isnull(CONCENTRATES,0)+?,TAILINGS=isnull(TAILINGS,0)+? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String UPDATE_BUYING_ORG_QUANTITY = " update AMS.dbo.MINING_STOCKYARD_MASTER set FINES=isnull(FINES,0)+? , "
			+ " LUMPS=isnull(LUMPS,0)+? where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=? and ORGANIZATION_ID=? ";

	public static final String GET_PERMIT_QTY = " select * from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=? ";

	public static final String GET_TRIP_COUNT = " select MAX(isnull(r.TRIP_COUNT,0)) as TRIP_COUNT from (select MAX(isnull(TRIP_COUNT,0)) as TRIP_COUNT from MINING.dbo.TRUCK_TRIP_DETAILS (NOLOCK) where SYSTEM_ID=? and PERMIT_ID=? "
			+ " union all "
			+ " select MAX(isnull(TRIP_COUNT,0)) as TRIP_COUNT from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY (NOLOCK) where SYSTEM_ID=? and PERMIT_ID=? )r ";

	public static final String GET_ALL_OPEN_ASSETS = " select ASSET_NUMBER from MINING.dbo.TRUCK_TRIP_DETAILS (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=? and  STATUS='OPEN' ";

	public static final String UPDATE_PROCESSING_FEE_IN_ORG_MASTER = " update AMS.dbo.MINING_ORGANIZATION_MASTER set M_WALLET_BALANCE=isnull(M_WALLET_BALANCE,0)+? where ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String UPDATE_ORGANIZATION_DEATILS = " update AMS.dbo.MINING_ORGANIZATION_MASTER set M_WALLET_BALANCE=isnull(M_WALLET_BALANCE,0)-? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String GET_MPL_BALANCE = "select isnull(TRANSPORTATION_MPL,0) as TOTAL_EC_LIMIT,isnull(PROCESSING_PLANT,'') as PROCESSING_PLANT,isnull(WALLET_LINK,'') as WALLET_LINK,isnull(MPL_BALANCE,0) as EC_USED,* from AMS.dbo.MINING_TC_MASTER where ID=? ";

	public static final String GET_LOCATION_FOR_WEIGHBRIDGE = " select NAME,isnull(HUBID,'0')as HUBID from LOCATION_ZONE_A WHERE OPERATION_ID!=2 and SYSTEMID=? and CLIENTID=? ";

	public static final String GET_LOCATION_FOR_PERMIT = " select sm.LUMPS,sm.FINES,NAME,HUBID from LOCATION_ZONE_A lz "
			+ " left outer join AMS.dbo.MINING_STOCKYARD_MASTER sm on sm.ROUTE_ID=lz.HUBID and lz.SYSTEMID=sm.SYSTEM_ID "
			+ " WHERE OPERATION_ID!=2 and SYSTEMID=? and CLIENTID=? and (sm.FINES!=0 or sm.LUMPS!=0) and ORGANIZATION_ID=? and sm.MINERAL_TYPE=? "
			+ " union all "
			+ " select isnull(sum(pfd.TOTAL_LUMPS),0) as LUMPS,isnull(sum(pfd.TOTAL_FINES),0) as FINES, "
			+ " isnull(lza.NAME,'')as NAME,isnull(a.HUB_ID,0)as HUBID " + " from MINING.dbo.PLANT_MASTER a "
			+ " left outer join AMS.dbo.PLANT_FEED_DETAILS pfd on pfd.PLANT_ID=a.ID and pfd.SYSTEM_ID=a.SYSTEM_ID and pfd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lza on lza.SYSTEMID=a.SYSTEM_ID and lza.CLIENTID=a.CUSTOMER_ID and lza.HUBID=a.HUB_ID and lza.OPERATION_ID!=2 "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and ORGANIZATION_ID=? and a.MINERAL_TYPE=? "
			+ " group by a.ID,a.ORGANIZATION_ID,a.TC_ID,a.PLANT_NAME,a.LUMPS,a.FINES,lza.NAME,a.HUB_ID,a.MINERAL_TYPE "
			+ " having (sum(pfd.TOTAL_FINES)!=0 or sum(pfd.TOTAL_LUMPS)!=0)";

	public static final String CHECK_WEIGHBRIDGE_EXIST = " select ID from MINING.dbo.WEIGHBRIDGE_MASTER where WEIGHBRIDGE_ID=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String SAVE_WEIGHBRIDGE_MASTER_DETAILS = " insert into MINING.dbo.WEIGHBRIDGE_MASTER(ORGANIZATION_ID,LOCATION_ID,WEIGHBRIDGE_ID,COMPANY_NAME,WEIGHBRIDGE_MODEL,SUPPLIER_NAME,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY)values(?,?,?,?,?,?,?,?,?) ";

	public static final String MODIFY_WEIGHBRIDGE_MASTER_DETAILS = " update MINING.dbo.WEIGHBRIDGE_MASTER set ORGANIZATION_ID=?,LOCATION_ID=?,COMPANY_NAME=?,WEIGHBRIDGE_MODEL=?,SUPPLIER_NAME=?,SYSTEM_ID=?,CUSTOMER_ID=?,UPDATED_BY=?,UPDATED_DATETIME=getutcdate() where ID=? ";

	public static final String GET_WEIGHBRIDGE_MASTER_DETAILS = " select wm.ID as ID,isnull(mom.ORGANIZATION_NAME,'NA') as  ORGANIZATION_NAME,isnull(wm.ORGANIZATION_ID,0) as ORGANIZATION_ID,isnull(lza.NAME,'') as LOCATION,isnull(wm.LOCATION_ID,0) as LOCATION_ID,isnull(wm.WEIGHBRIDGE_ID,'') as WEIGHBRIDGE, "
			+ " isnull(wm.COMPANY_NAME,'') as COMPANY_NAME,isnull(wm.WEIGHBRIDGE_MODEL,'') as WEIGHBRIDGE_MODEL,isnull(wm.SUPPLIER_NAME,'') as SUPPLIER_NAME "
			+ "	from MINING.dbo.WEIGHBRIDGE_MASTER wm "
			+ "	left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mom on mom.ID=wm.ORGANIZATION_ID "
			+ "	inner join AMS.dbo.LOCATION_ZONE_A lza on lza.HUBID=wm.LOCATION_ID "
			+ "	where wm.SYSTEM_ID=? and wm.CUSTOMER_ID=? order by wm.ID desc";

	public static final String GET_HUB_FOR_USER_SETTING_BY_ORG = " select ID,WEIGHBRIDGE_ID from MINING.dbo.WEIGHBRIDGE_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ORGANIZATION_ID in ( # )";

	public static final String GET_BARGE_HUB_FOR_USER_SETTINGS = " select isnull(HUBID,0) as ID,isnull(NAME,'') as NAME from AMS.dbo.LOCATION_ZONE_A lza where lza.SYSTEMID=? and lza.CLIENTID=? order by lza.ID desc ";

	public static final String GET_PERMIT_NO_FOR_USER_SETTINGS = " select a.ID,PERMIT_NO, isnull((select sum(QUANTITY) from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID),0) as CHALLAN_QTY, "
			+ " isnull((select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=a.ID),0) as PERMIT_QTY,"
			+ " isnull(a.TRIPSHEET_QTY,0)/1000 as USED_QTY,isnull(mtm.TC_NO,'NA') as TC_NO,isnull(mtm.ID,0) as TC_ID,isnull(mom.ORGANIZATION_NAME,'') as ORG_NAME,isnull(mom.ID,0) as ORG_ID, "
			+ " isnull(rd.ROUTE_NAME,'') as ROUTE_NAME,isnull(lz3.NAME,'') as START_LOCATION,isnull(lz4.NAME,'') as END_LOCATION "
			+ " from AMS.dbo.MINING_PERMIT_DETAILS a "
			+ " left outer join AMS.dbo.MINING_TC_MASTER mtm on a.SYSTEM_ID=mtm.SYSTEM_ID and a.TC_ID=mtm.ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mom on mom.ID=a.ORGANIZATION_CODE and mom.SYSTEM_ID=a.SYSTEM_ID "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join LOCATION_ZONE_A lz3 on lz3.HUBID=rd.SOURCE_HUB_ID AND lz3.CLIENTID=rd.CUSTOMER_ID AND lz3.SYSTEMID=rd.SYSTEM_ID "
			+ " left outer join LOCATION_ZONE_A lz4 on lz4.HUBID=rd.DESTINATION_HUB_ID AND lz4.CLIENTID=rd.CUSTOMER_ID AND lz4.SYSTEMID=rd.SYSTEM_ID "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS in ('APPROVED','ACKNOWLEDGED') and  PERMIT_TYPE!='Import Permit' and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))>=START_DATE and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))<=END_DATE and (#) & ";

	public static final String GET_PERMIT_NO_FROM_USER_SETTING = " select top 1 PERMIT_IDS,isnull(OPERATION_TYPE,'B')as OPERATION_TYPE from dbo.TRIP_SHEET_USER_SETTINGS where SYSTEM_ID=? and USER_ID=? order by ID desc ";

	public static final String GET_WEIGHBRIDGES_ASSOCIATED_TO_USER = " select top 1 isnull(SOURCE_HUBID,0)as SOURCE_HUBID,isnull(DESTINATION_HUBID,0)as DESTINATION_HUBID,isnull(PERMIT_ID,0) as BARGE_HUBID,isnull(TYPE,'')as TYPE,isnull(CLOSING_TYPE,'')as CLOSING_TYPE,isnull(OPERATION_TYPE,'B')as OPERATION_TYPE from AMS.dbo.TRIP_SHEET_USER_SETTINGS where SYSTEM_ID=? and USER_ID=? order by ID desc ";

	public static final String DELETE_TRIP_SHEET_USER_SETTINGS_BASEDON_USER = " delete AMS.dbo.TRIP_SHEET_USER_SETTINGS where SYSTEM_ID=? and USER_ID=? ";

	public static final String INSERT_TRIP_SHEET_USER_SETTINGS_HISTORY = " insert into AMS.dbo.TRIP_SHEET_USER_SETTINGS_HISTORY select *,?,getutcdate() from AMS.dbo.TRIP_SHEET_USER_SETTINGS where SYSTEM_ID=? and USER_ID=? ";

	public static final String INSERT_TRIP_SHEET_USER_SETTINGS = "  insert into AMS.dbo.TRIP_SHEET_USER_SETTINGS(USER_ID,ORGANISATION_CODE,TC_ID,PERMIT_IDS,SOURCE_HUBID,DESTINATION_HUBID,TYPE,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,PERMIT_ID,CLOSING_TYPE,OPERATION_TYPE) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";

	public static final String UPDATE_TRIP_STATUS_IN_ASSET_ENROLMENT = " update AMS.dbo.MINING_ASSET_ENROLLMENT set TRIP_STATUS=? where ASSET_NUMBER=? and SYSTEM_ID=? AND CUSTOMER_ID=?";

	public static final String GET_PERMIT_ID = " select isnull(PERMIT_ID,0) as PERMIT_ID,isnull((QUANTITY-QUANTITY1),0)/1000 as  NET_WEIGHT  from MINING.dbo.TRUCK_TRIP_DETAILS (NOLOCK) where ID=? ";

	public static final String GET_PERMIT_DETAILS_FOR_CLOSE = "select isnull(SRC_TYPE,'') as SRC_TYPE,isnull(DEST_TYPE,'') as DEST_TYPE,isnull(ROUTE_ID,0) as ROUTE_ID,MINERAL,PERMIT_TYPE,BUYING_ORG_ID,pd.ID,pd.CHALLAN_ID,isnull(ORGANIZATION_CODE,0) as ORGANIZATION_ID,isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY ,isnull(TC_ID,0) as TC_ID, "
			+ " isnull((select TYPE from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=pd.ID),'') as TYPE  "
			+ " from AMS.dbo.MINING_PERMIT_DETAILS pd where pd.ID=? and pd.SYSTEM_ID=? and pd.CUSTOMER_ID=? ";

	//**************************************************DashBoard statements*****************************************************************//

	public static final String GET_DASHBOARD_PERMIT_COUNT = "select count(*) as COUNT,type=1 from AMS.dbo.MINING_PERMIT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS not in ('CANCEL','CANCELLED') and "
			+ " (TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select count(*) as COUNT,type=2 from AMS.dbo.MINING_PERMIT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS in ('ACKNOWLEDGED','APPROVED') and "
			+ " (TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select count(*) as COUNT,type=3 from AMS.dbo.MINING_PERMIT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS in ('PENDING APPROVAL','OPEN') and "
			+ " (TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select count(*) as COUNT,type=4 from AMS.dbo.MINING_PERMIT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS in ('CLOSE') and  "
			+ " (TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))  ";

	public static final String GET_DASHBOARD_CHALLAN_COUNT = "select count(*) as COUNT,type=1 from AMS.dbo.MINING_CHALLAN_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS not in ('INACTIVE')  and "
			+ " (TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select count(*) as COUNT,type=2 from AMS.dbo.MINING_CHALLAN_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS in ('ACKNOWLEDGED','APPROVED') and "
			+ " (TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select count(*) as COUNT,type=3 from AMS.dbo.MINING_CHALLAN_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS in ('PENDING APPROVAL','OPEN') and "
			+ " (TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) ";

	public static final String GET_PERMIT_QUANTITY = " select isnull(sum(QUANTITY),0) as QUANTITY,type=1 from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID in (select ID from AMS.dbo.MINING_PERMIT_DETAILS where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS in ('ACKNOWLEDGED','APPROVED') and PERMIT_TYPE='Processed Ore Transit' and "
			+ " (TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))) "
			+ " union all  "
			+ " select isnull(sum(QUANTITY),0) as QUANTITY,type=2 from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID in (select ID from AMS.dbo.MINING_PERMIT_DETAILS where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS in ('ACKNOWLEDGED','APPROVED') and PERMIT_TYPE='Processed Ore Sale' and  "
			+ " (TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))) "
			+ " union all "
			+ " select isnull(sum(QUANTITY),0) as QUANTITY,type=3 from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID in (select ID from AMS.dbo.MINING_PERMIT_DETAILS where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS in ('ACKNOWLEDGED','APPROVED') and PERMIT_TYPE='Domestic Export' and  "
			+ " (TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))) "
			+ " union all "
			+ " select isnull(sum(QUANTITY),0) as QUANTITY,type=4 from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID in (select ID from AMS.dbo.MINING_PERMIT_DETAILS where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS in ('ACKNOWLEDGED','APPROVED') and PERMIT_TYPE='International Export' and "
			+ " (TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))) "
			+ " union all "
			+ " select isnull(sum(QUANTITY),0) as QUANTITY,type=5 from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID in (select ID from AMS.dbo.MINING_PERMIT_DETAILS where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS in ('ACKNOWLEDGED','APPROVED') and PERMIT_TYPE='Processed Ore Sale Transit' and "
			+ " (TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))) ";

	public static final String GET_MONTHLY_RETURNS_COUNT = " select count(ID) as COUNT,type=1 from AMS.dbo.MONTHLY_FORM_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=?  "
			+ " union all "
			+ " select count(ID) as COUNT,type=2 from AMS.dbo.MONTHLY_FORM_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='APPROVED' "
			+ " union all  "
			+ " select count(ID) as COUNT,type=3 from AMS.dbo.MONTHLY_FORM_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS in ('PENDING','OPEN')  "
			+ " union all  "
			+ " select count(ID) as COUNT,type=4 from AMS.dbo.MONTHLY_FORM_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='REJECTED'";

	public static final String GET_TRUCK_TRIPSHEET_COUNT_AND_QUANTITY = "select sum(COUNT) as COUNT,sum(TOTAL_QTY) as TOTAL_QTY,'1' as type from (select COUNT(TRIP_NO) as COUNT,isnull(sum(QUANTITY-QUANTITY1),0)/1000 as TOTAL_QTY,type=1 from MINING.dbo.TRUCK_TRIP_DETAILS(NOLOCK) a "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and "
			+ " a.INSERTED_TIME between  DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select COUNT(TRIP_NO) as COUNT,isnull(sum(QUANTITY-QUANTITY1),0)/1000 as TOTAL_QTY,type=1 from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY(NOLOCK) a "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and "
			+ " a.INSERTED_TIME between DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) ) r "
			+ " union all "
			+ " select COUNT(TRIP_NO) as COUNT,isnull(sum(QUANTITY-QUANTITY1),0)/1000 as TOTAL_QTY,'2' as type from MINING.dbo.TRUCK_TRIP_DETAILS(NOLOCK) a "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? "
			+ " and a.INSERTED_TIME between DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and STATUS='OPEN' and "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select sum(COUNT) as COUNT,sum(TOTAL_QTY) as TOTAL_QTY,'3' as type from (select COUNT(TRIP_NO) as COUNT,isnull(sum(QUANTITY-QUANTITY1),0)/1000 as TOTAL_QTY,type=1 from MINING.dbo.TRUCK_TRIP_DETAILS(NOLOCK) a "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and "
			+ " a.INSERTED_TIME between DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and STATUS='CLOSE' and "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select COUNT(TRIP_NO) as COUNT,isnull(sum(QUANTITY-QUANTITY1),0)/1000 as TOTAL_QTY,type=1 from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY(NOLOCK) a "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? " + " and STATUS='CLOSE' and "
			+ " a.INSERTED_TIME between DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) ) r ";

	public static final String GET_BARGE_TRIPSHEET_COUNT_AND_QUANTITY = " select COUNT(TRIP_NO) as COUNT,isnull(sum(QUANTITY1),0)/1000 as TOTAL_BARGE_QTY,type=1 from MINING.dbo.BARGE_TRIP_DETAILS(NOLOCK) a "
			+ " where  a.SYSTEM_ID=? and a.CUSTOMER_ID=? and "
			+ " a.INSERTED_TIME between dateadd(mi,-330,DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))) and dateadd(mi,-330,DATEADD(dd, 0, DATEDIFF(dd, -1, GETDATE()))) and "
			+ " (a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select COUNT(TRIP_NO) as COUNT,isnull(sum(QUANTITY1),0)/1000 as TOTAL_BARGE_QTY,type=2 from MINING.dbo.BARGE_TRIP_DETAILS(NOLOCK) a "
			+ " where  a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS in ('Stop BLO','OPEN','Start BLO') and "
			+ " a.INSERTED_TIME between dateadd(mi,-330,DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))) and dateadd(mi,-330,DATEADD(dd, 0, DATEDIFF(dd, -1, GETDATE()))) and "
			+ " (a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union all "
			+ " select COUNT(TRIP_NO) as COUNT,isnull(sum(QUANTITY1),0)/1000 as TOTAL_BARGE_QTY,type=3 from MINING.dbo.BARGE_TRIP_DETAILS(NOLOCK) a "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS in ('Close') and "
			+ " a.INSERTED_TIME between dateadd(mi,-330,DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))) and dateadd(mi,-330,DATEADD(dd, 0, DATEDIFF(dd, -1, GETDATE()))) and "
			+ " (a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) ";

	public static final String GET_TRIPSHEET_QUANTITY_FOR_TRUCK = " select ROW_NUMBER()over (order by r.DATE desc),sum(r.COUNT) as COUNT,upper(r.DATE) as DATE,'TRUCK' as TYPE "
			+ " from (select isnull(sum(QUANTITY-QUANTITY1),0)/1000 as COUNT,DATENAME(month,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120))+' '+RIGHT('0' + CAST(DATENAME(day,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) AS varchar(2)),2) as DATE "
			+ " from MINING.dbo.TRUCK_TRIP_DETAILS(NOLOCK) a "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.INSERTED_TIME between convert(varchar(10),DATEADD(dd, -7, convert(varchar(10), getdate(),120)),120) and "
			+ " convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), getdate(),120)),120) and "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " group by convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120) "
			+ " union all "
			+ " select isnull(sum(QUANTITY-QUANTITY1),0)/1000 as COUNT,DATENAME(month,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120))+' '+RIGHT('0' + CAST(DATENAME(day,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) AS varchar(2)),2) as DATE "
			+ " from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY(NOLOCK) a " + " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? "
			+ " and a.INSERTED_TIME between "
			+ " convert(varchar(10),DATEADD(dd, -7, convert(varchar(10), getdate(),120)),120) and  "
			+ " convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), getdate(),120)),120) " + " and "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " group by convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120) )r "
			+ " group by r.DATE ";

	public static final String GET_TRIPSHEET_QUANTITY_FOR_BARGE = " select ROW_NUMBER()over (order by r.DATE desc),sum(r.COUNT) as COUNT,upper(r.DATE) as DATE,'BARGE' as TYPE "
			+ " from (select isnull(sum(QUANTITY1),0)/1000 as COUNT,DATENAME(month,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120))+' '+RIGHT('0' + CAST(DATENAME(day,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) AS varchar(2)),2) as DATE "
			+ " from MINING.dbo.BARGE_TRIP_DETAILS(NOLOCK) a " + " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=?  "
			+ " and a.INSERTED_TIME between  "
			+ " convert(varchar(10),DATEADD(dd, -7, convert(varchar(10), getdate(),120)),120) and  "
			+ " convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), getdate(),120)),120) " + " and  "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) "
			+ " group by convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) r  group by r.DATE ";

	public static final String GET_TRIPSHEET_COUNT_FOR_BARGE = " select ROW_NUMBER()over (order by r.DATE desc),sum(r.COUNT) as COUNT,upper(r.DATE) as DATE,'BARGE' as TYPE "
			+ " from (select isnull(count(ID),0) as COUNT,DATENAME(month,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120))+' '+RIGHT('0' + CAST(DATENAME(day,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) AS varchar(2)),2) as DATE "
			+ " from MINING.dbo.BARGE_TRIP_DETAILS(NOLOCK) a " + " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=?  "
			+ " and a.INSERTED_TIME between  "
			+ " convert(varchar(10),DATEADD(dd, -7, convert(varchar(10), getdate(),120)),120) and  "
			+ " convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), getdate(),120)),120) "
			+ " and a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) "
			+ " group by convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120) ) r  group by r.DATE ";

	public static final String GET_TRIPSHEET_COUNT_FOR_TRUCK = " select ROW_NUMBER()over (order by r.DATE desc),sum(r.COUNT) as COUNT,upper(r.DATE) as DATE,'TRUCK' as TYPE "
			+ " from (select isnull(count(ID),0) as COUNT,DATENAME(month,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120))+' '+RIGHT('0' + CAST(DATENAME(day,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) AS varchar(2)),2) as DATE "
			+ " from MINING.dbo.TRUCK_TRIP_DETAILS(NOLOCK) a "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.INSERTED_TIME between convert(varchar(10),DATEADD(dd, -7, convert(varchar(10), getdate(),120)),120) and "
			+ " convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), getdate(),120)),120) and "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " group by convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120) "
			+ " union all "
			+ " select isnull(count(ID),0) as COUNT,DATENAME(month,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120))+' '+RIGHT('0' + CAST(DATENAME(day,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) AS varchar(2)),2) as DATE "
			+ " from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY(NOLOCK) a " + " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? "
			+ " and a.INSERTED_TIME between "
			+ " convert(varchar(10),DATEADD(dd, -7, convert(varchar(10), getdate(),120)),120) and  "
			+ " convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), getdate(),120)),120) " + " and "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " group by convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120) )r "
			+ " group by r.DATE ";

	public static final String GET_TRIPSHEET_COUNT_FOR_TRAIN = " select ROW_NUMBER()over (order by r.DATE desc),sum(r.COUNT) as COUNT,upper(r.DATE) as DATE,'BARGE' as TYPE "
			+ " from (select isnull(count(ID),0) as COUNT,DATENAME(month,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120))+' '+RIGHT('0' + CAST(DATENAME(day,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) AS varchar(2)),2) as DATE "
			+ " from TRIP_DETAILS(NOLOCK) a " + " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=?  "
			+ " and a.INSERTED_TIME between  "
			+ " convert(varchar(10),DATEADD(dd, -7, convert(varchar(10), getdate(),120)),120) and  "
			+ " convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), getdate(),120)),120) "
			+ " and a.MATERIAL='TRAIN' and  "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " group by convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120) "
			+ " union all "
			+ " select isnull(count(ID),0) as COUNT,DATENAME(month,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120))+' '+RIGHT('0' + CAST(DATENAME(day,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) AS varchar(2)),2) as DATE "
			+ " from TRIP_DETAILS_HISTORY(NOLOCK) a " + " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=?  "
			+ " and a.INSERTED_TIME between  "
			+ " convert(varchar(10),DATEADD(dd, -7, convert(varchar(10), getdate(),120)),120) and  "
			+ " convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), getdate(),120)),120) "
			+ " and a.MATERIAL='TRAIN' and  "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " group by convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120) ) r "
			+ " group by r.DATE ";

	public static final String GET_TRIPSHEET_QUANTITY_FOR_TRAIN = " select ROW_NUMBER()over (order by r.DATE desc),sum(r.COUNT) as COUNT,upper(r.DATE) as DATE,'BARGE' as TYPE "
			+ " from (select isnull(sum(QUANTITY1),0)/1000 as COUNT,DATENAME(month,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120))+' '+RIGHT('0' + CAST(DATENAME(day,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) AS varchar(2)),2) as DATE "
			+ " from TRIP_DETAILS(NOLOCK) a " + " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=?  "
			+ " and a.INSERTED_TIME between  "
			+ " convert(varchar(10),DATEADD(dd, -7, convert(varchar(10), getdate(),120)),120) and  "
			+ " convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), getdate(),120)),120) "
			+ " and a.MATERIAL='TRAIN' and  "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " group by convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120) "
			+ " union all "
			+ " select isnull(sum(QUANTITY1),0)/1000 as COUNT,DATENAME(month,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120))+' '+RIGHT('0' + CAST(DATENAME(day,convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120)) AS varchar(2)),2) as DATE "
			+ " from TRIP_DETAILS_HISTORY(NOLOCK) a " + " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=?  "
			+ " and a.INSERTED_TIME between  "
			+ " convert(varchar(10),DATEADD(dd, -7, convert(varchar(10), getdate(),120)),120) and  "
			+ " convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), getdate(),120)),120) "
			+ " and a.MATERIAL='TRAIN' and  "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or  "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " group by convert(varchar(10),DATEADD(dd, 0, convert(varchar(10), a.INSERTED_TIME,120)),120) ) r "
			+ " group by r.DATE ";

	public static final String GET_COMM_STATUS = "select GPS_DATETIME,isnull(LOCATION,'') as LOCATION,(case when  GMT<dateadd(mi,-?,getutcdate()) then 'NOT_APPLICABLE' "
			+ " when  GMT<dateadd(hh,-6,getutcdate()) then 'NON COMMUNICATING' " + " else 'COMMUNICATING' "
			+ " end) as COMM_STATUS from AMS.dbo.gpsdata_history_latest(NOLOCK) where REGISTRATION_NO=? and System_id=? and CLIENTID=? ";

	public static final String GET_TIME_DETAILS = "select NON_COMM_HRS,START_TIME,END_TIME,BREAK_START_TIME,BREAK_END_TIME ,DATEPART(hour,GETDATE()) as HOUR,DATENAME(weekday,GETDATE()) as  DAY,DATEPART(minute,GETDATE()) as TIME,1 as ID from MINING.dbo.TRIP_SHEET_TIMINGS where SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String INSERT_TRANSFER_TRIP_DETAILS = " insert into MINING.dbo.TRUCK_TRIP_DETAILS (TRIP_NO,ASSET_NUMBER,TYPE,TC_ID,VALIDITY_DATE,GRADE,QUANTITY,ROUTE_ID,SYSTEM_ID,CUSTOMER_ID,STATUS,QUANTITY1,SOURCE_HUBID,DESTINATION_HUBID,PERMIT_ID,ISSUED_BY,USER_SETTING_ID,ORGANIZATION_ID,DS_SOURCE,DS_DESTINATION,BARGE_TRANSACTION_ID,TRIP_COUNT,COMMUNICATION_STATUS) "
			+ " (select TRIP_NO,?,TYPE,TC_ID,VALIDITY_DATE,GRADE,?,ROUTE_ID,SYSTEM_ID,CUSTOMER_ID,STATUS,?,SOURCE_HUBID,DESTINATION_HUBID,PERMIT_ID,ISSUED_BY,USER_SETTING_ID,ORGANIZATION_ID,DS_SOURCE,DS_DESTINATION,BARGE_TRANSACTION_ID,TRIP_COUNT,COMMUNICATION_STATUS from MINING.dbo.TRUCK_TRIP_DETAILS "
			+ " where ASSET_NUMBER=? and TRIP_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? and ID=?)";

	public static final String UPDATE_VEHICLE_DETAILS = " update MINING.dbo.TRUCK_TRIP_DETAILS set STATUS='Cancelled-Breakdown',REASON=?,CLOSED_BY=?,CLOSED_DATETIME=getutcdate() where ASSET_NUMBER=? and TRIP_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String GET_NET_WEIGHT = " select isnull((QUANTITY-QUANTITY1),0) as NET_WEIGHT FROM MINING.dbo.TRUCK_TRIP_DETAILS where ID=? ";

	public static final String GET_ORG_NAME_FOR_BARGE = " select distinct d.ORGANIZATION_NAME,d.ID as ORG_ID from MINING.dbo.USER_TC_ASSOCIATION c "
			+ " left outer join AMS.dbo.MINING_TC_MASTER a on a.SYSTEM_ID=c.SYSTEM_ID and c.TC_ID=a.ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER d on d.ID=c.ORG_ID and d.SYSTEM_ID=c.SYSTEM_ID "
			+ " where c.USER_ID=? and c.SYSTEM_ID=? ";

	public static final String GET_PERMIT_NO_FOR_TS = " select top 1 PERMIT_IDS,isnull(wm2.LOCATION_ID,0) as DESTINATION_HUBID from AMS.dbo.TRIP_SHEET_USER_SETTINGS ts "
			+ " left outer join MINING.dbo.WEIGHBRIDGE_MASTER wm2 on wm2.ID=ts.DESTINATION_HUBID and wm2.CUSTOMER_ID=ts.CUSTOMER_ID"
			+ " where ts.SYSTEM_ID =? and ts.CUSTOMER_ID=? and ts.USER_ID=?  order by ts.INSERTED_DATETIME desc ";

	public static final String GET_MINING_TIMES = "select ID,START_TIME,END_TIME,BREAK_START_TIME,BREAK_END_TIME,FIRST_RESTRICTIVE_START_TIME,FIRST_RESTRICTIVE_END_TIME,SECOND_RESTRICTIVE_START_TIME,SECOND_RESTRICTIVE_END_TIME,isnull(NON_COMM_HRS,0) as NON_COMM_HRS from MINING.dbo.TRIP_SHEET_TIMINGS where SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String UPDATE_MINING_TIMES = "update MINING.dbo.TRIP_SHEET_TIMINGS set START_TIME=?,END_TIME=?,BREAK_START_TIME=?,BREAK_END_TIME=?,NON_COMM_HRS=?,FIRST_RESTRICTIVE_START_TIME=?,FIRST_RESTRICTIVE_END_TIME=?,SECOND_RESTRICTIVE_START_TIME=?,SECOND_RESTRICTIVE_END_TIME=? where SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String INSERT_MINING_TIMES = "insert into MINING.dbo.TRIP_SHEET_TIMINGS(START_TIME,END_TIME,BREAK_START_TIME,BREAK_END_TIME,NON_COMM_HRS,FIRST_RESTRICTIVE_START_TIME,FIRST_RESTRICTIVE_END_TIME,SECOND_RESTRICTIVE_START_TIME,SECOND_RESTRICTIVE_END_TIME,SYSTEM_ID,CUSTOMER_ID) values(?,?,?,?,?,?,?,?,?,?,?)";

	public static final String INSERT_IMPORT_DETAILS = " insert into MINING.dbo.IMPORT_PERMIT_DETAILS(PERMIT_ID,IMPORT_TYPE,IMPORT_PURPOSE,VESSEL_NAME) values (?,?,?,?) ";

	public static final String INSERT_IMPORT_TRANSIT_DETAILS = "  insert into MINING.dbo.IMPORT_PERMIT_DETAILS(PERMIT_ID,EXPORT_PERMIT_NO,EXPORT_PERMIT_NO_DATE,EXPORT_CHALLAN_NO,EXPORT_CHALLAN_NO_DATE,SALE_INVOICE_NO,SALE_INVOICE_NO_DATE,TRANSPORTATION_TYPE,VESSEL_NAME,IMPORT_TYPE) values (?,?,?,?,?,?,?,?,?,?)  ";

	public static final String GET_IMPORTED_PERMIT_NO = " select isnull(pod.TOTAL_PROCESSING_FEE,0) as TOTAL_PROCESSING_FEE,ORGANIZATION_CODE,mpd.ID,PERMIT_NO from AMS.dbo.MINING_PERMIT_DETAILS mpd "
			+ " inner join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pod on pod.PERMIT_ID=mpd.ID "
			+ " where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS='APPROVED' and PERMIT_TYPE='Import Permit' and ORGANIZATION_CODE=? ";

	public static final String UPDATE_STATUS_FOR_IMPORT_PERMIT = " update AMS.dbo.MINING_PERMIT_DETAILS set STATUS='CLOSE' where ID=? ";

	public static final String UPDATE_IMPORT_DETAILS = " update MINING.dbo.IMPORT_PERMIT_DETAILS set EXPORT_PERMIT_NO=?,EXPORT_PERMIT_NO_DATE=?,EXPORT_CHALLAN_NO=?,EXPORT_CHALLAN_NO_DATE=?,SALE_INVOICE_NO=?,SALE_INVOICE_NO_DATE=?,TRANSPORTATION_TYPE=?,IMPORT_PURPOSE=?,VESSEL_NAME=? where PERMIT_ID=?   ";

	public static final String INSERT_INTO_PROCESSED_ORE_DETAILS_FOR_IMPORT = " insert into AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS(GRADE,PERMIT_ID,TYPE,QUANTITY,STOCK_TYPE,SOURCE_TYPE,PROCESSING_FEE,TOTAL_PROCESSING_FEE ) "
			+ " (select GRADE,?,TYPE,QUANTITY,STOCK_TYPE,SOURCE_TYPE,PROCESSING_FEE,TOTAL_PROCESSING_FEE from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=?) ";

	public static final String GET_IMPORT_TYPE = " select  IMPORT_TYPE from  MINING.dbo.IMPORT_PERMIT_DETAILS where PERMIT_ID=? ";

	public static final String GET_PROCESSING_FEE = " select * from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=? ";

	public static final String UPDATE_IMPORT_QTY_IN_ORG_MASTER = " update AMS.dbo.MINING_ORGANIZATION_MASTER set IMP_FINES_QTY=isnull(IMP_FINES_QTY,0)+?,IMP_LUMPS_QTY=isnull(IMP_LUMPS_QTY,0)+?,IMP_CONCENTRATES_QTY=isnull(IMP_CONCENTRATES_QTY,0)+?,IMP_TAILINGS_QTY=isnull(IMP_TAILINGS_QTY,0)+? where ID=? ";

	public static final String UPDATE_IMPORT_QTY_IN_ORG_MASTER_FOR_CANCEL_TRIP = " update AMS.dbo.MINING_ORGANIZATION_MASTER set IMP_FINES_QTY=IMP_FINES_QTY-?,IMP_LUMPS_QTY=IMP_LUMPS_QTY-?,IMP_CONCENTRATES_QTY=IMP_CONCENTRATES_QTY-?,IMP_TAILINGS_QTY=IMP_TAILINGS_QTY-? where ID=? ";

	public static final String GET_PERMITS_FOR_USER = " select PERMIT_NO,ID from AMS.dbo.MINING_PERMIT_DETAILS a where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS  in ('APPROVED','ACKNOWLEDGED','CLOSE') and TRIPSHEET_QTY>0 "
			+ " and (a.TC_ID in (select b.TC_ID from MINING.dbo.USER_TC_ASSOCIATION b where b.USER_ID=? and b.SYSTEM_ID=? and b.TC_ID!=0) "
			+ "  or  a.ORGANIZATION_CODE in (select c.ORG_ID from MINING.dbo.USER_TC_ASSOCIATION c where c.USER_ID=? and c.SYSTEM_ID=?)) ";

	public static final String GET_BARGE_TRIP_DETAILS_PER_PERMIT = " select 'TRIP' AS FLAG,isnull(SOURCE_HUBID,0) AS SOURCE_HUBID,isnull(ORGANIZATION_ID,0) as ORGANIZATION_ID,isnull(dateadd(mi,330,a.INSERTED_TIME),'') as  ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER,  "
			+ " isnull(dateadd(mi,330,a.VALIDITY_DATE),'')as VALIDITY_DATE,isnull(a.QUANTITY,0)as QUANTITY2  ,"
			+ " a.STATUS,isnull(a.QUANTITY1,0)as QUANTITY1,isnull(dateadd(mi,330,a.CLOSED_DATETIME),'') as  CLOSED_DATETIME,isnull(a.MOTHER_VESSEL_NAME,'')as VESSEL_NAME,isnull(a.DESTINATION,'')as DESTINATION,isnull(BOAT_NOTE,'')as BOAT_NOTE,isnull(a.REASON,'')as REASON,isnull(dateadd(mi,330,a.STOP_BLO_DATETIME),'')as STOP_BLO_DATETIME  from MINING.dbo.BARGE_TRIP_DETAILS a "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and (ID in (select distinct BTS_ID from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS_HISTORY WHERE SYSTEM_ID=? "
			+ " and CUSTOMER_ID=? and PERMIT_ID=? and STATUS='CLOSE')) or (ID in (select distinct BTS_ID from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS WHERE SYSTEM_ID=? and CUSTOMER_ID=? and PERMIT_ID=? and STATUS='CLOSE')) ";

	public static final String GET_MINING_TRIP_SHEET_GENERATION_DETAILS_PER_PERMIT = " (select isnull(REASON,'') AS REASON,isnull(COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS,isnull(dateadd(mi,330,a.INSERTED_TIME),'') as ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER, "
			+ " isnull(b.LESSE_NAME,'') as LESSE_NAME,isnull(a.VALIDITY_DATE,'')as VALIDITY_DATE,isnull(a.GRADE,'')as GRADE_NAME,isnull(a.QUANTITY,'')as QUANTITY2,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME, "
			+ " a.TC_ID ,a.ROUTE_ID,a.STATUS,isnull(a.QUANTITY3,0)as QUANTITY3,isnull(a.QUANTITY4,0)as QUANTITY4,isnull(a.QUANTITY1,0)as QUANTITY1,isnull(pd.PERMIT_NO,0)as PERMIT_ID,pd.ID as PID, "
			+ " isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME, "
			+ " isnull(dateadd(mi,330,a.CLOSED_DATETIME),'') as CLOSED_DATETIME,isnull(u.USER_NAME,'') as WBS,isnull(ue.USER_NAME,'') as WBD,isnull(a.DESTINATION_TYPE,'') as DESTINATION_TYPE,isnull(a.CLOSING_TYPE,'') as CLOSING_TYPE,isnull(a.DS_DESTINATION,'') as DS_DESTINATION,isnull(a.BARGE_TRANSACTION_ID,'') as TRANSACTION_ID,isnull(a.DS_SOURCE,'') as DS_SOURCE "
			+ " from MINING.dbo.TRUCK_TRIP_DETAILS a "
			+ " left outer join AMS.dbo.MINING_TC_MASTER b on a.TC_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=a.ORGANIZATION_ID and mm.SYSTEM_ID=a.SYSTEM_ID and mm.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS pd on pd.ID=a.PERMIT_ID and pd.SYSTEM_ID=a.SYSTEM_ID and pd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=a.ISSUED_BY "
			+ " left outer join ADMINISTRATOR.dbo.USERS ue on ue.SYSTEM_ID=a.SYSTEM_ID and ue.USER_ID=a.CLOSED_BY "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.PERMIT_ID=? " + " and "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " union "
			+ " select isnull(REASON,'') AS REASON,isnull(COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS,isnull(dateadd(mi,330,a.INSERTED_TIME),'') as ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER, "
			+ " isnull(b.LESSE_NAME,'') as LESSE_NAME,isnull(a.VALIDITY_DATE,'')as VALIDITY_DATE,isnull(a.GRADE,'')as GRADE_NAME,isnull(a.QUANTITY,'')as QUANTITY2,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME, "
			+ " a.TC_ID ,a.ROUTE_ID,a.STATUS,isnull(a.QUANTITY3,0)as QUANTITY3,isnull(a.QUANTITY4,0)as QUANTITY4, "
			+ " isnull(a.QUANTITY1,0)as QUANTITY1,isnull(pd.PERMIT_NO,0)as PERMIT_ID,pd.ID as PID,isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY, "
			+ " isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(dateadd(mi,330,a.CLOSED_DATETIME),'') as CLOSED_DATETIME,isnull(u.USER_NAME,'') as WBS,isnull(ue.USER_NAME,'') as WBD,isnull(a.DESTINATION_TYPE,'') as DESTINATION_TYPE,isnull(a.CLOSING_TYPE,'') as CLOSING_TYPE,isnull(a.DS_DESTINATION,'') as DS_DESTINATION,isnull(a.BARGE_TRANSACTION_ID,'') as TRANSACTION_ID,isnull(a.DS_SOURCE,'') as DS_SOURCE from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY a "
			+ " left outer join AMS.dbo.MINING_TC_MASTER b on a.TC_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=a.ORGANIZATION_ID and mm.SYSTEM_ID=a.SYSTEM_ID and mm.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS pd on pd.ID=a.PERMIT_ID and pd.SYSTEM_ID=a.SYSTEM_ID and pd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join ADMINISTRATOR.dbo.USERS u on u.SYSTEM_ID=a.SYSTEM_ID and u.USER_ID=a.ISSUED_BY "
			+ " left outer join ADMINISTRATOR.dbo.USERS ue on ue.SYSTEM_ID=a.SYSTEM_ID and ue.USER_ID=a.CLOSED_BY "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.PERMIT_ID=? "
			+ " and (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))) "
			+ " order by ID desc ";

	public static final String GET_TRUCK_TRIP_SHEET_DETAILS_FOR_PERMIT = "(select isnull(COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS,isnull(dateadd(mi,330,a.INSERTED_TIME),'') as  ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER, "
			+ " isnull(b.LESSE_NAME,'') as LESSE_NAME,isnull(a.VALIDITY_DATE,'')as VALIDITY_DATE,isnull(a.GRADE,'')as GRADE_NAME,isnull(a.QUANTITY,'')as QUANTITY2,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME,   "
			+ " a.TC_ID ,a.ROUTE_ID,a.STATUS,isnull(a.QUANTITY1,0)as QUANTITY1,isnull(pd.PERMIT_NO,0)as PERMIT_ID,isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(pd.SHIP_NAME,'')as SHIP_NAME from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS a   "
			+ " left outer join AMS.dbo.MINING_TC_MASTER b on a.TC_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID   "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=a.ORGANIZATION_ID and mm.SYSTEM_ID=a.SYSTEM_ID and mm.CUSTOMER_ID=a.CUSTOMER_ID"
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS pd  on pd.ID=a.PERMIT_ID and pd.SYSTEM_ID=a.SYSTEM_ID and pd.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.BTS_ID=? and a.STATUS='CLOSE' and a.PERMIT_ID=? "
			+ " union "
			+ " select isnull(COMMUNICATION_STATUS,'') as COMMUNICATION_STATUS,isnull(dateadd(mi,330,a.INSERTED_TIME),'') as  ISSUE_DATE,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(a.TYPE,'') as TYPE,isnull(a.ASSET_NUMBER,'')as ASSET_NUMBER,   "
			+ " isnull(b.LESSE_NAME,'') as LESSE_NAME,isnull(a.VALIDITY_DATE,'')as VALIDITY_DATE,isnull(a.GRADE,'')as GRADE_NAME,isnull(a.QUANTITY,'')as QUANTITY2,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME,    "
			+ "  a.TC_ID ,a.ROUTE_ID,a.STATUS,isnull(a.QUANTITY1,0)as QUANTITY1,isnull(pd.PERMIT_NO,0)as PERMIT_ID,isnull(pd.TRIPSHEET_QTY,0)as TRIPSHEET_QTY,isnull(mm.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(pd.SHIP_NAME,'')as SHIP_NAME from MINING.dbo.BARGE_TRUCK_TRIP_DETAILS_HISTORY a    "
			+ " left outer join AMS.dbo.MINING_TC_MASTER b on a.TC_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID    "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mm on mm.ID=a.ORGANIZATION_ID and mm.SYSTEM_ID=a.SYSTEM_ID and mm.CUSTOMER_ID=a.CUSTOMER_ID"
			+ "  left outer join AMS.dbo.MINING_PERMIT_DETAILS pd  on pd.ID=a.PERMIT_ID and pd.SYSTEM_ID=a.SYSTEM_ID and pd.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ "  WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.BTS_ID=? and a.STATUS='CLOSE' and a.PERMIT_ID=?)";

	public static final String GET_VEHICLE_LIST_FOR_VEHICLE_STATUS = " select isnull(se.TRIP_STATUS,'') as TRIP_STATUS,isnull(se.PUC_EXPIRY_DATE,'') as PUC_EXPIRY_DATE,isnull(se.INSURANCE_EXPIRY_DATE,'') as INSURANCE_EXPIRY_DATE,isnull(se.ROADTAX_VALIDITY_DATE,'') as ROADTAX_VALIDITY_DATE,isnull(se.PERMIT_VALIDITY_DATE,'') as PERMIT_VALIDITY_DATE, "
			+ " a.REGISTRATION_NO,isnull(UNIT_NO,'') as VTS_INSTALLED,isnull(c.Status,'') AS STATUS, "
			+ " isnull(se.STATUS,'Inactive') as ENROLLMENT_STATUS, CASE WHEN se.STATUS='Inactive' THEN ' ('+isnull(se.REASON,'')+')' ELSE '' END  as REASON,"
			+ " (select (case when a.GMT<dateadd(hh,-6,getutcdate()) then 'NON COMMUNICATING' "
			+ " else'COMMUNICATING' end)) as COMM_STATUS " + " from AMS.dbo.gpsdata_history_latest(NOLOCK) a "
			+ " inner join AMS.dbo.tblVehicleMaster c (NOLOCK) on a.REGISTRATION_NO=c.VehicleNo "
			+ " left outer join AMS.dbo.MINING_ASSET_ENROLLMENT(NOLOCK) se on se.SYSTEM_ID=a.System_id and se.CUSTOMER_ID=a.CLIENTID and a.REGISTRATION_NO=se.ASSET_NUMBER "
			+ " where a.System_id=? and a.CLIENTID=? ";

	public static final String GET_VEHICLE_INFORMATION = " select top 1 TRIP_NO,STATUS,WEIGHT_DATETIME,dateadd(mi,330,INSERTED_TIME)as INSERTED_TIME from (select top 1 TRIP_NO,STATUS,isnull(e.WEIGHT_DATETIME,'') as WEIGHT_DATETIME,INSERTED_TIME from MINING.dbo.TRUCK_TRIP_DETAILS(NOLOCK) a "
			+ " left outer join AMS.dbo.MINING_TARE_WEIGHT_MASTER e (NOLOCK) on e.SYSTEM_ID=a.SYSTEM_ID and e.CUSTOMER_ID=a.CUSTOMER_ID and e.ASSET_NUMBER=a.ASSET_NUMBER collate database_default "
			+ " and e.WEIGHT_DATETIME=(select max(WEIGHT_DATETIME) from AMS.dbo.MINING_TARE_WEIGHT_MASTER (NOLOCK) where SYSTEM_ID=a.SYSTEM_ID and e.CUSTOMER_ID=a.CUSTOMER_ID and ASSET_NUMBER=a.ASSET_NUMBER collate database_default)  "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.ASSET_NUMBER=? ORDER BY INSERTED_TIME DESC "
			+ " union all "
			+ " select top 1 TRIP_NO,STATUS,isnull(e.WEIGHT_DATETIME,'') as WEIGHT_DATETIME,INSERTED_TIME from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY(NOLOCK) a "
			+ " left outer join AMS.dbo.MINING_TARE_WEIGHT_MASTER e (NOLOCK) on e.SYSTEM_ID=a.SYSTEM_ID and e.CUSTOMER_ID=a.CUSTOMER_ID and e.ASSET_NUMBER=a.ASSET_NUMBER collate database_default "
			+ " and e.WEIGHT_DATETIME=(select max(WEIGHT_DATETIME) from AMS.dbo.MINING_TARE_WEIGHT_MASTER (NOLOCK) where SYSTEM_ID=a.SYSTEM_ID and e.CUSTOMER_ID=a.CUSTOMER_ID and ASSET_NUMBER=a.ASSET_NUMBER collate database_default)  "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.ASSET_NUMBER=? ORDER BY INSERTED_TIME DESC) r ORDER BY r.INSERTED_TIME DESC ";

	public static final String UPDATE_STATUS_FOR_PERMIT = " UPDATE AMS.dbo.MINING_PERMIT_DETAILS SET STATUS=? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String UPDATE_START_END_DATE = "update AMS.dbo.MINING_PERMIT_DETAILS set STATUS='MODIFIED',DATE=?,START_DATE=?,END_DATE=?,REMARKS=?,UPDATED_BY=?,UPDATED_DATETIME=getdate() && WHERE ID=? ";

	public static final String GET_E_WALLET_DETAILS = " select TYPE,c.ID,isnull(sum(AMOUNT),0) as EWALLET_BALANCE,isnull(M_WALLET_BALANCE,0) as M_WALLET_BALANCE,c.ORGANIZATION_CODE,c.ORGANIZATION_NAME "
			+ " from AMS.dbo.MINING_ORGANIZATION_MASTER c   "
			+ " left outer  join AMS.dbo.MINING_MINE_MASTER b on c.ID=b.ORG_ID and b.SYSTEM_ID=c.SYSTEM_ID and b.CUSTOMER_ID=c.CUSTOMER_ID  "
			+ " left outer join AMS.dbo.MINING_TC_MASTER a on b.ID=a.MINE_ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID  "
			+ " where c.SYSTEM_ID=? and c.CUSTOMER_ID=? group by c.ID,TYPE,c.ORGANIZATION_NAME,M_WALLET_BALANCE,c.ORGANIZATION_CODE "
			+ " order by TYPE asc ";

	public static final String GET_MPL_BALANCE_DETAILS = "select a.ID ,isnull(a.TC_NO,'') as TC_NO ,isnull(a.NAME_OF_MINE,'') as LESSE_NAME,isnull(ORGANIZATION_CODE,'') as ORGANIZATION_CODE,ISNULL(ORGANIZATION_NAME,'') as ORGANIZATION_NAME,isnull(TRANSPORTATION_MPL,0) as MPL_ALLOCATED,(isnull(TRANSPORTATION_MPL,0)-isnull(MPL_BALANCE,0))as MPL_BALANCE,isnull(MPL_BALANCE,0)as MPL_USED "
			+ " from AMS.dbo.MINING_TC_MASTER a "
			+ " inner join AMS.dbo.MINING_MINE_MASTER b on a.MINE_ID=b.ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? order by a.ID desc ";

	public static final String GET_IMPORTS_EXPORTS_DETAILS = "select r.TYPE,sum(r.QUANTITY) as QUANTITY,PERMIT_TYPE,r.ORG_CODE as ORG_CODE, "
			+ " r.ORGANIZATION_NAME,r.ORGANIZATION_CODE as ORGANIZATION_CODE from (select pop.TYPE,sum(pop.QUANTITY) as QUANTITY,PERMIT_TYPE, "
			+ " mpd.ORGANIZATION_CODE as ORG_CODE,mom.ORGANIZATION_NAME,mom.ORGANIZATION_CODE as ORGANIZATION_CODE "
			+ " from MINING_PERMIT_DETAILS mpd "
			+ " inner join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pop on mpd.ID=pop.PERMIT_ID "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER mom on mom.ID=mpd.ORGANIZATION_CODE "
			+ " where mpd.STATUS not in ('CLOSE','CANCEL') AND mpd.SYSTEM_ID=? AND mpd.CUSTOMER_ID=? and PERMIT_TYPE in ('International Export','Domestic Export') "
			+ " group by mpd.ORGANIZATION_CODE,pop.TYPE,PERMIT_TYPE,ORGANIZATION_NAME,mom.ORGANIZATION_CODE "
			+ " union "
			+ " select pop.TYPE,sum(mpd.TRIPSHEET_QTY)*.001 as QUANTITY,PERMIT_TYPE,mpd.ORGANIZATION_CODE as ORG_CODE,mom.ORGANIZATION_NAME,mom.ORGANIZATION_CODE as ORGANIZATION_CODE "
			+ " from MINING_PERMIT_DETAILS mpd "
			+ " inner join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pop on mpd.ID=pop.PERMIT_ID "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER mom on mom.ID=mpd.ORGANIZATION_CODE "
			+ " where mpd.STATUS in ('CLOSE','CANCEL') AND mpd.SYSTEM_ID=? AND mpd.CUSTOMER_ID=? and PERMIT_TYPE in ('International Export','Domestic Export') "
			+ " group by mpd.ORGANIZATION_CODE,pop.TYPE,PERMIT_TYPE,ORGANIZATION_NAME,mom.ORGANIZATION_CODE ) r group by  PERMIT_TYPE,r.TYPE,r.ORGANIZATION_CODE,r.ORGANIZATION_NAME,r.ORG_CODE ";

	public static final String GET_IMPORTS_EXPORTS_DETAILS1 = " select r.TYPE,sum(r.QUANTITY) as QUANTITY,PERMIT_TYPE,IMPORT_TYPE,r.ORG_CODE as ORG_CODE,r.ORGANIZATION_NAME,r.ORGANIZATION_CODE "
			+ " from (select pop.TYPE,sum(pop.QUANTITY) as QUANTITY,PERMIT_TYPE,IMPORT_TYPE,mpd.ORGANIZATION_CODE as ORG_CODE,mom.ORGANIZATION_NAME,mom.ORGANIZATION_CODE "
			+ " from MINING_PERMIT_DETAILS mpd "
			+ " inner join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pop on mpd.ID=pop.PERMIT_ID "
			+ " inner join MINING.dbo.IMPORT_PERMIT_DETAILS ipd on mpd.ID=ipd.PERMIT_ID "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER mom on mom.ID=mpd.ORGANIZATION_CODE "
			+ " where mpd.STATUS not in ('CLOSE','CANCEL') and mpd.SYSTEM_ID=? AND mpd.CUSTOMER_ID=? and IMPORT_TYPE in ('Domestic Import','International Import') and PERMIT_TYPE in ('Import Transit Permit') "
			+ " group by mpd.ORGANIZATION_CODE,pop.TYPE,PERMIT_TYPE,IMPORT_TYPE,mom.ORGANIZATION_NAME,mom.ORGANIZATION_CODE "
			+ " union "
			+ " select pop.TYPE,sum(mpd.TRIPSHEET_QTY)*.001 as QUANTITY,PERMIT_TYPE,IMPORT_TYPE,mpd.ORGANIZATION_CODE as ORG_CODE,mom.ORGANIZATION_NAME,mom.ORGANIZATION_CODE "
			+ " from MINING_PERMIT_DETAILS mpd "
			+ " inner join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pop on mpd.ID=pop.PERMIT_ID "
			+ " inner join MINING.dbo.IMPORT_PERMIT_DETAILS ipd on mpd.ID=ipd.PERMIT_ID "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER mom on mom.ID=mpd.ORGANIZATION_CODE "
			+ " where mpd.STATUS in ('CLOSE','CANCEL') and mpd.SYSTEM_ID=? AND mpd.CUSTOMER_ID=? and IMPORT_TYPE in ('Domestic Import','International Import') and PERMIT_TYPE in ('Import Transit Permit') "
			+ " group by mpd.ORGANIZATION_CODE,pop.TYPE,PERMIT_TYPE,IMPORT_TYPE,mom.ORGANIZATION_NAME,mom.ORGANIZATION_CODE ) r group by r.TYPE,r.PERMIT_TYPE,IMPORT_TYPE,r.ORGANIZATION_CODE,r.ORGANIZATION_NAME,r.ORGANIZATION_CODE,r.ORG_CODE ";

	public static final String GET_BARGE_TRIP_NO = " select a.ASSET_NUMBER,STATUS,sum(QUANTITY1) as BARGEQUANTITY,a.ID,isnull(a.TRIP_NO,'')as TRIP_NO,isnull(c.LoadCapacity,0) as LoadCapacity "
			+ " from MINING.dbo.BARGE_TRIP_DETAILS a  "
			+ " left outer join AMS.dbo.tblVehicleMaster c on c.System_id=a.SYSTEM_ID and a.ASSET_NUMBER=c.VehicleNo  collate database_default "
			+ " WHERE a.SYSTEM_ID=? and a.CUSTOMER_ID=? and STATUS in ('OPEN','Start BLO') and "
			+ " (STATUS<>'CLOSE' and STATUS<>'Closed-Completed-Modified Trip' and STATUS<>'Closed Diverted Trip' and STATUS<>'DIVERTED TRIP') and "
			+ " (a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ " group by ID,TRIP_NO,c.LoadCapacity,a.STATUS,a.ASSET_NUMBER ";

	public static final String INSERT_BARGE_TRUCK_TRIPSHEET_DETAILS = "INSERT INTO MINING.dbo.BARGE_TRUCK_TRIP_DETAILS "
			+ " (TRIP_NO,TYPE,ASSET_NUMBER,TC_ID,VALIDITY_DATE,GRADE,QUANTITY,ROUTE_ID,SYSTEM_ID,CUSTOMER_ID,  "
			+ " STATUS,QUANTITY1,SOURCE_HUBID,DESTINATION_HUBID,PERMIT_ID,ISSUED_BY,USER_SETTING_ID,ORGANIZATION_ID,BTS_ID, "
			+ " BARGE_TRANSACTION_ID,DS_SOURCE,DS_DESTINATION,TRIP_COUNT,COMMUNICATION_STATUS,REMARKS,REASON) "
			+ " (select ?,TYPE,ASSET_NUMBER,TC_ID,VALIDITY_DATE,GRADE,QUANTITY,ROUTE_ID,SYSTEM_ID,CUSTOMER_ID,'CLOSE',QUANTITY1, "
			+ " SOURCE_HUBID,DESTINATION_HUBID,PERMIT_ID,ISSUED_BY,USER_SETTING_ID,ORGANIZATION_ID,?,0,DS_SOURCE,DS_DESTINATION,TRIP_COUNT, "
			+ " COMMUNICATION_STATUS,?,? from MINING.dbo.TRUCK_TRIP_DETAILS WHERE SYSTEM_ID=? AND CUSTOMER_ID=? and ID=?) ";

	public static final String GET_PERMIT_DETAILSS = " select isnull(DEST_TYPE,0) as DEST_TYPE,MINERAL,TRIPSHEET_NO,ROUTE_ID,isnull(TC_ID,0) as TC_ID ,isnull(pd.ORGANIZATION_CODE,0) as ORG_ID,isnull(pd.BUYING_ORG_ID,0) as BUYING_ORG_ID,pd.ID, PERMIT_TYPE,"
			+ " (select GRADE from MINING.dbo.TRUCK_TRIP_DETAILS WHERE ID=?) as TYPE,(select STATUS from MINING.dbo.TRUCK_TRIP_DETAILS WHERE ID=?) as TRIP_STATUS "
			+ " from AMS.dbo.MINING_PERMIT_DETAILS pd "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pod on pd.ID =pod.PERMIT_ID "
			+ " where pd.SYSTEM_ID=? and pd.ID=? "
			+ " and pd.CUSTOMER_ID=? and pd.STATUS in ('APPROVED','ACKNOWLEDGED') ";

	public static final String UPDATE_TRIP_STATUS = "  update MINING.dbo.TRUCK_TRIP_DETAILS set STATUS='Transfer Trip' where ID=?  ";

	public static final String GET_VESSEL_DETAILS = " select isnull(a.BUYER_NAME,'') as BUYER_NAME,a.ID,isnull(a.VESSEL_NAME,'') as VESSEL_NAME,isnull(a.STATUS,'') as STATUS from MINING.dbo.VESSEL_MASTER_DETAILS a where a.SYSTEM_ID=? and a.CUSTOMER_ID=? order by ID desc";

	public static final String CHECK_VESSEL_NAME_VESSEL_MASTER = " select * from MINING.dbo.VESSEL_MASTER_DETAILS a where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.VESSEL_NAME=? ";

	public static final String INSERT_VESSEL_MASTER_DETAILS = " insert into MINING.dbo.VESSEL_MASTER_DETAILS (VESSEL_NAME,STATUS,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,BUYER_NAME) values(?,?,?,?,?,getdate(),?) ";

	public static final String UPDATE_VESSEL_MASTER_DETAILS = "update MINING.dbo.VESSEL_MASTER_DETAILS set VESSEL_NAME=?,STATUS=?,UPDATED_BY=?,UPDATED_DATETIME=getdate(),BUYER_NAME=? where ID=?";

	public static final String GET_VESSEL_NAMES = " select ID,VESSEL_NAME,isnull(BUYER_NAME,'') as BUYER_NAME from MINING.dbo.VESSEL_MASTER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active' ";

	public static final String GET_TC_NUMBER_FOR_TRIP_FEED = "select c.ORG_ID as ORG_ID,a.TC_NO,a.ID,isnull(c.ORGANIZATION_CODE,'')as ORGANIZATION_CODE,isnull(c.ORGANIZATION_NAME,'')as ORGANIZATION_NAME from AMS.dbo.MINING_TC_MASTER a "
			+ "left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=a.MINE_ID and c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ "where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and WALLET_LINK=? and a.ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) ";

	public static final String GET_RTP_PERMITS = " select * from (select mpd.MINERAL,isnull(rd.DESTINATION_HUB_ID,0) as DESTINATION,isnull(mpd.TRIPSHEET_QTY,0)/1000 as USED_QTY,mpd.PERMIT_NO,mpd.ID,"
			+ " case when (PERMIT_TYPE='Rom Transit' and SRC_TYPE='E-Wallet') then (select sum(QUANTITY) from  dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=mpd.CHALLAN_ID) else isnull(popd.QUANTITY,0) end as PERMIT_QUANTITY "
			+ " from MINING_PERMIT_DETAILS mpd " + " left outer join AMS.dbo.MINING_TC_MASTER tc on tc.ID=mpd.TC_ID "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd  on popd.PERMIT_ID=mpd.ID "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=mpd.ROUTE_ID and rd.SYSTEM_ID=mpd.SYSTEM_ID and rd.CUSTOMER_ID=mpd.CUSTOMER_ID  "
			+ " where mpd.SYSTEM_ID=? and mpd.CUSTOMER_ID=? and PERMIT_TYPE=? and mpd.STATUS in ('APPROVED','ACKNOWLEDGED') "
			+ " and mpd.ID in (#) and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))>=mpd.START_DATE and DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))<=mpd.END_DATE && ) r "
			+ " where (PERMIT_QUANTITY-USED_QTY)>0";

	public static final String GET_PLANT_NAMES = " select PLANT_NAME,ID from MINING.dbo.PLANT_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ORGANIZATION_ID=? ";

	public static final String GET_PLANT_NAMES_FOR_EXCEL = " select top 1 PLANT_NAME,ID from MINING.dbo.PLANT_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ORGANIZATION_ID=? and HUB_ID=? and MINERAL_TYPE=?";

	public static final String CHECK_PLANT_NAME = "select ORGANIZATION_ID,ID from MINING.dbo.PLANT_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and PLANT_NAME=? ";

	public static final String SAVE_TRIP_FEED_DETAILS = " insert into MINING.dbo.MINE_TRIP_FEED_DETAILS(TC_ID,ORGANIZATION_ID,PERMIT_ID,CHALLAN_ID,QTY,PLANT_ID,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,ASSET_NO) "
			+ " values(?,?,?,?,?,?,?,?,?,getdate(),?) ";

	public static final String SAVE_SELF_CONSUMPTION_DETAILS = " insert into MINING.dbo.MINE_TRIP_FEED_DETAILS(TC_ID,ORGANIZATION_ID,PERMIT_ID,QTY,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,ASSET_NO) "
			+ " values(?,?,?,?,?,?,?,getdate(),?) ";

	public static final String UPDATE_TRIPSHEET_QTY_FOR_RTP = " update AMS.dbo.MINING_PERMIT_DETAILS set TRIPSHEET_QTY=isnull(TRIPSHEET_QTY,0)+? where ID=? ";

	public static final String UPDATE_ROM_QTY_IN_PLANT_MASTER = "  update MINING.dbo.PLANT_MASTER set ROM_QTY=isnull(ROM_QTY,0)+? where ID=? and SYSTEM_ID=? and CUSTOMER_ID=? and MINERAL_TYPE=? ";

	public static final String GET_ACTUAL_PERMIT_QTY = "select MINERAL,isnull(TRIPSHEET_QTY,0)/1000 as TRIPSHEET_QTY,case when (PERMIT_TYPE='Rom Transit' and SRC_TYPE='E-Wallet') then (select sum(QUANTITY) from  dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=mpd.CHALLAN_ID) else isnull(popd.QUANTITY,0)end as PERMIT_QUANTITY "
			+ " from AMS.dbo.MINING_PERMIT_DETAILS mpd "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd  on popd.PERMIT_ID=mpd.ID "
			+ " where mpd.ID=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_TRIP_FEED_DETAILS = " select isnull(tfd.STATUS,'') as STATUS,isnull(tfd.REMARKS,'') as REMARKS,tfd.ID,mpd.ID as PERMIT_ID,pm.ID as PLANT_ID,isnull(tfd.ASSET_NO,'') as VEHICLE_NO,isnull(tfd.QTY,0) as QUANTITY,isnull(tc.TC_NO,'') as TC_NO,isnull(om.ORGANIZATION_NAME,'') as ORGANIZATION_NAME, "
			+ " isnull(pm.PLANT_NAME,'') as PLANT_NAME,isnull(mpd.PERMIT_NO,'') as PERMIT_NO,isnull(mcd.CHALLAN_NO,'') as CHALLAN_NO,isnull(tfd.INSERTED_DATETIME,'') as INSERTED_DATETIME "
			+ " from MINING.dbo.MINE_TRIP_FEED_DETAILS tfd "
			+ " left outer join AMS.dbo.MINING_TC_MASTER tc on tfd.TC_ID=tc.ID and tfd.SYSTEM_ID=tc.SYSTEM_ID "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=tc.MINE_ID and c.SYSTEM_ID=tc.SYSTEM_ID and c.CUSTOMER_ID=tc.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER om on tfd.ORGANIZATION_ID=om.ID and tfd.SYSTEM_ID=om.SYSTEM_ID and tfd.CUSTOMER_ID=om.CUSTOMER_ID "
			+ " left outer join MINING.dbo.PLANT_MASTER pm on tfd.PLANT_ID=pm.ID and tfd.SYSTEM_ID=pm.SYSTEM_ID and tfd.CUSTOMER_ID=pm.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_PERMIT_DETAILS mpd on tfd.PERMIT_ID=mpd.ID and tfd.SYSTEM_ID=mpd.SYSTEM_ID and tfd.CUSTOMER_ID=mpd.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_CHALLAN_DETAILS mcd on tfd.CHALLAN_ID=mcd.ID and tfd.SYSTEM_ID=mcd.SYSTEM_ID and tfd.CUSTOMER_ID=mcd.CUSTOMER_ID "
			+ " where tfd.SYSTEM_ID=? and tfd.CUSTOMER_ID=? "
			+ " and tfd.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) order by tfd.ID desc ";

	public static final String GET_TC_DETAILS = " select isnull(a.CTO_DATE,'') as CTO_DATE,PROCESSING_PLANT,WALLET_LINK,c.ORG_ID as ORG_ID,a.TC_NO,a.ID,isnull(c.ORGANIZATION_NAME,'')as ORGANIZATION_NAME "
			+ " from AMS.dbo.MINING_TC_MASTER a "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=a.MINE_ID and c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? "
			+ " and a.ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) & ";

	public static final String GET_ORGANIZATION = "select ID from AMS.dbo.MINING_ORGANIZATION_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ORGANIZATION_NAME=?";

	public static final String GET_RTP_DETAILS = " select MINERAL,case when (PERMIT_TYPE='Rom Transit' and SRC_TYPE='E-Wallet') then (c.ORG_ID) else mpd.ORGANIZATION_CODE end as ORG_ID,"
			+ " mpd.START_DATE,mpd.END_DATE,mpd.STATUS,mpd.TC_ID,PERMIT_TYPE,isnull(rd.DESTINATION_HUB_ID,0) as DESTINATION,isnull(mpd.TRIPSHEET_QTY,0)/1000 as USED_QTY,mpd.PERMIT_NO,mpd.ID,"
			+ " case when (PERMIT_TYPE='Rom Transit' and SRC_TYPE='E-Wallet') then (select sum(QUANTITY) from  dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=mpd.CHALLAN_ID) else isnull(popd.QUANTITY,0) end  as PERMIT_QUANTITY "
			+ " from MINING_PERMIT_DETAILS mpd " + " left outer join AMS.dbo.MINING_TC_MASTER tc on tc.ID=mpd.TC_ID "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=tc.MINE_ID and c.SYSTEM_ID=tc.SYSTEM_ID and c.CUSTOMER_ID=tc.CUSTOMER_ID  "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd  on popd.PERMIT_ID=mpd.ID " +
			//" left outer join Trip_Master tm on tm.Trip_id=mpd.ROUTE_ID and tm.System_id=mpd.SYSTEM_ID " +
			" left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=mpd.ROUTE_ID and rd.SYSTEM_ID=mpd.SYSTEM_ID and rd.CUSTOMER_ID=mpd.CUSTOMER_ID  "
			+ " where PERMIT_NO=? and mpd.SYSTEM_ID=? and mpd.CUSTOMER_ID=? ";

	public static final String UPDATE_CHALLAN_USED_QTY = " update AMS.dbo.MINING_CHALLAN_DETAILS set USED_QTY=isnull(USED_QTY,0)+? where ID=? ";

	public static final String GET_CHALLAN_NUMBER_FOR_TRIP = " select * from (select isnull(mcd.MINERAL_TYPE,'') as MINERAL_TYPE,mcd.CHALLAN_TYPE,mcd.STATUS,mcd.TC_NO,mcd.ID,CHALLAN_NO,isnull(USED_QTY,0)/1000 as USED_QTY,cgd.QUANTITY from AMS.dbo.MINING_CHALLAN_DETAILS mcd "
			+ " left outer join AMS.dbo.CHALLAN_GRADE_DETAILS  cgd on cgd.CHALLAN_ID=mcd.ID "
			+ " where mcd.SYSTEM_ID=? and mcd.CUSTOMER_ID=?  # ) r " + " where (QUANTITY-USED_QTY) > 0 ";

	public static final String GET_CHALLAN_NUMBER_FOR_P_TRIP = " select * from (select isnull(tc.CTO_DATE,'') as CTO_DATE,isnull(mcd.MINERAL_TYPE,'') as MINERAL_TYPE,mcd.CHALLAN_TYPE,mcd.STATUS,mcd.TC_NO,mcd.ID,CHALLAN_NO, "
			+ " isnull(USED_QTY,0)/1000 as USED_QTY,cgd.QUANTITY from AMS.dbo.MINING_CHALLAN_DETAILS mcd  "
			+ " left outer join AMS.dbo.CHALLAN_GRADE_DETAILS  cgd on cgd.CHALLAN_ID=mcd.ID  "
			+ " left outer join AMS.dbo.MINING_TC_MASTER  tc on tc.ID=mcd.TC_NO  "
			+ " where mcd.SYSTEM_ID=? and mcd.CUSTOMER_ID=? and mcd.CHALLAN_TYPE='Processed Ore' and mcd.STATUS in ('APPROVED','ACKNOWLEDGED') "
			+ " and mcd.TC_NO in (select a.ID from AMS.dbo.MINING_TC_MASTER a  "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=a.MINE_ID and c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " where c.ORG_ID =?) ) r  " + " where (QUANTITY-USED_QTY) > 0 ";

	public static final String GET_CHALLAN_USED_QTY = " select isnull(a.MINERAL_TYPE,'') as MINERAL_TYPE,isnull(USED_QTY,0)/1000 as USED_QTY,isnull(cgd.QUANTITY,0)as CHALLAN_QTY from AMS.dbo.MINING_CHALLAN_DETAILS a "
			+ " left outer join AMS.dbo.CHALLAN_GRADE_DETAILS cgd on cgd.CHALLAN_ID=a.ID where a.ID=? ";

	public static final String UPDATE_ROM_QTY_IN_PLANT_MASTER_FOR_PLANT_FEED = "update MINING.dbo.PLANT_MASTER set ROM_QTY=isnull(ROM_QTY,0)-? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String GET_ORG_NAME_FOR_TF = "  select distinct c.ORG_ID as ID,isnull(c.ORGANIZATION_CODE,'')as ORGANIZATION_CODE,isnull(c.ORGANIZATION_NAME,'') "
			+ " as ORGANIZATION_NAME from AMS.dbo.MINING_TC_MASTER a "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=a.MINE_ID and c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and WALLET_LINK=? and PROCESSING_PLANT='yes' "
			+ " and c.ORG_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?) ";

	public static final String GET_ORGANIZATION_NAME = " select a.ID,ORGANIZATION_NAME,ORGANIZATION_CODE from AMS.dbo.MINING_ORGANIZATION_MASTER a where SYSTEM_ID=? and CUSTOMER_ID=? and "
			+ " a.ID  in(select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION  where USER_ID=? and  SYSTEM_ID=?) ";

	public static final String GET_ROUTE_DETAILS = "select isnull(rd.ROUTE_TYPE,'') as SOURCE_TYPE,isnull(rd.ACTIVE_INACTIVE_BY,0) as ACTIVE_INACTIVE_BY,isnull(rd.ACTIVE_INACTIVE_DT,'') as ACTIVE_INACTIVE_DATETIME,isnull(rd.UPDATED_BY,0) as UPDATED_BY,isnull(rd.UPDATED_DATETIME,'') as UPDATED_DATETIME,isnull(rd.STATUS,'') as STATUS,mrm.STATUS as MOTHER_R_STATUS,mrm.ID as MID,(select count(ROUTE_ID) from AMS.dbo.MINING_PERMIT_DETAILS where rd.ID=ROUTE_ID and STATUS not in ('CANCEL')) as ROUTE_COUNT,isnull(DISTANCE,0) as DISTANCE,rd.ID,om.ORGANIZATION_NAME,rd.ORG_ID,ROUTE_NAME,lz1.NAME as SOURCE_HUBNAME,lz2.NAME as DESTINATION_HUBNAME,DESTINATION_HUB_ID,SOURCE_HUB_ID,ORG_ID,TRIP_SHEET_COUNT1,TRIP_SHEET_COUNT2,isnull(mrm.NAME,'') as MOTHER_ROUTE_NAME,TOTAL_TRIPSHEET_COUNT "
			+ "from MINING.dbo.ROUTE_DETAILS rd "
			+ "left outer join AMS.dbo.MINING_ORGANIZATION_MASTER om on rd.ORG_ID=om.ID and rd.SYSTEM_ID=om.SYSTEM_ID and rd.CUSTOMER_ID=om.CUSTOMER_ID "
			+ "left outer join AMS.dbo.LOCATION_ZONE_A lz1 on rd.SOURCE_HUB_ID=lz1.HUBID "
			+ "left outer join AMS.dbo.LOCATION_ZONE_A lz2 on rd.DESTINATION_HUB_ID=lz2.HUBID "
			+ " left outer join MINING.dbo.MOTHER_ROUTE_MASTER mrm on mrm.ID=rd.MOTHER_ROUTE_ID "
			+ "where rd.SYSTEM_ID=? and rd.CUSTOMER_ID=? and rd.ORG_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=?)  order by rd.ID desc ";

	public static final String INSERT_INTO_ROUTE_MASTER_DETAILS = "insert into MINING.dbo.ROUTE_DETAILS (ORG_ID,ROUTE_NAME,SOURCE_HUB_ID,DESTINATION_HUB_ID,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,DISTANCE,MOTHER_ROUTE_ID,STATUS,ROUTE_TYPE) values(?,?,?,?,?,?,?,getdate(),?,?,?,?)";

	public static final String CHECK_ROUTE_NAME_IN_ROUTE_MASTER = "select * from MINING.dbo.ROUTE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ORG_ID=? and ROUTE_NAME=? ";

	public static final String UPDATE_ROUTE_MASTER_DETAILS = "update MINING.dbo.ROUTE_DETAILS set UPDATED_BY=?,UPDATED_DATETIME=getdate(),DISTANCE=?,SOURCE_HUB_ID=?,DESTINATION_HUB_ID=?,ROUTE_TYPE=? where ID=?";

	public static final String GET_GRADE_DETAILS_FOR_CHALLAN = " select cd.MINERAL_TYPE,cg.ID,cg.CHALLAN_ID,cg.GRADE,cg.RATE,cg.QUANTITY,cg.PAYABLE,GIOPF_RATE,GIOPF_QTY,isnull((select isnull(PROCESSING_FEE,0) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=?),0) as PROCESSING_FEE  "
			+ " from CHALLAN_GRADE_DETAILS cg "
			+ " left outer join AMS.dbo.MINING_CHALLAN_DETAILS cd on cg.CHALLAN_ID=cd.ID "
			+ " where CHALLAN_ID=? order by cg.ID asc ";

	public static final String GET_GRADE_DETAILS_FOR_MODIFY = " select cd.*,isnull((select isnull(PROCESSING_FEE,0) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=?),0) as PROCESSING_FEE,isnull(GIOPF_QTY,0) as GIOPF_QTY, isnull(GIOPF_RATE,0) AS GIOPF_RATE,ch.MINERAL_TYPE as MINERAL_TYPE "
			+ " from CHALLAN_GRADE_DETAILS cd left outer join AMS.dbo.MINING_CHALLAN_DETAILS ch on cd.CHALLAN_ID=ch.ID "
			+ " where cd.CHALLAN_ID=(select CHALLAN_ID from MINING_PERMIT_DETAILS a where a.ID=(select EXISTING_PERMIT_ID from MINING_PERMIT_DETAILS where ID=?)) order by cd.ID asc ";

	public static final String CHECK_TRIP_SHEET_COUNT = " select (case when (getdate() between convert(varchar(10), getdate(),120)+' '+'0'+ts.BREAK_END_TIME+':00'  "
			+ " and convert(varchar(10), getdate(),120)+' '+ts.END_TIME+':00') " + " then "
			+ " (select count(*) from MINING.dbo.TRUCK_TRIP_DETAILS a where "
			+ " SYSTEM_ID=? AND CUSTOMER_ID=? and ROUTE_ID=? and a.STATUS!='Cancelled' "
			+ " and INSERTED_TIME between dateadd(mi,-330,convert(varchar(10), getdate(),120)+' '+'0'+ts.BREAK_END_TIME+':00') "
			+ " and dateadd(mi,-330,convert(varchar(10), getdate(),120)+' '+ts.END_TIME+':00')) "
			+ " when (getdate() between convert(varchar(10), getdate(),120)+' '+'0'+ts.START_TIME+':00' "
			+ " and convert(varchar(10), getdate(),120)+' '+ts.BREAK_START_TIME+':00') " + " then "
			+ " (select count(*) from MINING.dbo.TRUCK_TRIP_DETAILS a where  "
			+ " SYSTEM_ID=? AND CUSTOMER_ID=? and ROUTE_ID=? and a.STATUS!='Cancelled' "
			+ " and INSERTED_TIME between dateadd(mi,-330,convert(varchar(10), getdate(),120)+' '+'0'+ts.START_TIME+':00') and  "
			+ " dateadd(mi,-330,convert(varchar(10), getdate(),120)+' '+ts.BREAK_START_TIME+':00')) " + " else '0' "
			+ " end) as COUNT,1 as ID, "
			+ " (case when (getdate() between convert(varchar(10), getdate(),120)+' '+'0'+ts.BREAK_END_TIME+':00'  "
			+ " and convert(varchar(10), getdate(),120)+' '+ts.END_TIME+':00') then 'EVENING'  "
			+ " when (getdate() between convert(varchar(10), getdate(),120)+' '+'0'+ts.START_TIME+':00'  "
			+ " and convert(varchar(10), getdate(),120)+' '+ts.BREAK_START_TIME+':00') then 'MORNING'  "
			+ " else 'break' end) as SESSION " + " from MINING.dbo.TRIP_SHEET_TIMINGS ts "
			+ " where SYSTEM_ID=? AND CUSTOMER_ID=? ";

	public static final String GET_ROUTE_LIMIT = " select rd.ID,TRIP_SHEET_COUNT1,TRIP_SHEET_COUNT2,isnull(SOURCE_HUB_ID,0)as SOURCE_WB_ID from MINING.dbo.ROUTE_DETAILS rd  "
			+ " where rd.ID=? ";

	public static final String UPDATE_PR_QTY_IN_ORG_MASTER = " update AMS.dbo.MINING_ORGANIZATION_MASTER set PURCHASED_ROM = isnull(PURCHASED_ROM,0) +? where ID=? ";

	public static final String UPDATE_PR_FOR_ORG = " update AMS.dbo.MINING_ORGANIZATION_MASTER set PURCHASED_ROM = PURCHASED_ROM -? where ID=? ";

	public static final String GET_RS_PERMIT = " select TOTAL_PROCESSING_FEE,CHALLAN_ID,mpd.ID,PERMIT_NO,SRC_TYPE from MINING_PERMIT_DETAILS mpd "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pop on pop.PERMIT_ID=mpd.ID "
			+ " where SYSTEM_ID=? and CUSTOMER_ID=? and BUYING_ORG_ID=? and PERMIT_TYPE='Rom Sale' and STATUS in ('APPROVED','ACKNOWLEDGED') and mpd.MINERAL= ? ";
	public static final String GET_GRADE_FROM_CHALLAN = " select GRADE from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=? ";

	public static final String INSERT_INTO_STOCK_DEATILS_FOR_ROM = " INSERT INTO AMS.dbo.MINING_STOCKYARD_MASTER (ROUTE_ID,ORGANIZATION_ID,ROM_QTY,SYSTEM_ID,CUSTOMER_ID,MINERAL_TYPE) VALUES (?,?,?,?,?,?) ";

	public static final String SAVE_ADDED_INSURANCE_DETAILS = "INSERT INTO AMS.dbo.MINING_ASSET_ENROLLMENT (ASSET_NUMBER,REGISTRATION_DATE,CARRIAGE_CAPACITY,OPERATING_ON_MINE,LOCATION,MINING_LEASE_NO,CHASSIS_NO,INSURANCE_POLICY_NO, "
			+ " INSURANCE_EXPIRY_DATE,PUC_NUMBER,PUC_EXPIRY_DATE,OWNER_NAME,ASSEMBLY_CONSTITUENCY,HOUSE_NO,LOCALITY,CITY_OR_VILLAGE,TALUKA,STATE,DISTRICT,EPIC_NO,PAN_NO,MOBILE_NO,"
			+ " PHONE_NO,AADHAR_NO,ENROLLMENT_DATE,BANK,BRANCH,PRINCIPAL_BALANCE,PRINCIPAL_OVER_DUES,INTEREST_BALANCE,ACCOUNT_NO,ENGINE_NUMBER,ENROLLMENT_NUMBER,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,ROADTAX_VALIDITY_DATE,PERMIT_VALIDITY_DATE)"
			+ " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

	public static final String CHECK_STATE = "select STATE_CODE,STATE_NAME from ADMINISTRATOR.dbo.STATE_DETAILS where COUNTRY_CODE=1101 and STATE_NAME=?";

	public static final String CHECK_DISTRICT = "select DISTRICT_NAME,DISTRICT_ID from AMS.dbo.DISTRICT_MASTER where STATE_ID=? and DISTRICT_NAME=?";

	public static final String GET_LOT_NO = "select ld.TYPE,LOT_NO,ld.ID,(isnull(ld.QUANTITY,0)-isnull((select sum(QUANTITY) from MINING.dbo.LOT_ALLOCATION_DETAILS where ld.ID=LOT_ID and isnull(STATUS,'') not in ('Cancelled')),0) ) as QUANTITY, "
			+ " lz.NAME as LOT_LOCATION,lz.HUBID as HUBID from MINING.dbo.LOT_DETAILS ld "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=ld.LOT_LOCATION "
			+ " where ld.SYSTEM_ID=? and ld.CUSTOMER_ID=? and isnull(ld.STATUS,'') not in ('Cancelled') "
			+ " and (FORTY_PER_AMOUNT_PAID is not null and FORTY_PER_DATE is not null and SIXTY_PER_AMOUNT_PAID is not null and SIXTY_PER_DATE is not null) "
			+ " and (FORTY_PER_AMOUNT_PAID  <> 0 and FORTY_PER_DATE!='' and SIXTY_PER_AMOUNT_PAID<>0 and SIXTY_PER_DATE!='') ";

	public static final String SAVE_LOT_DETAILS = " insert into MINING.dbo.LOT_ALLOCATION_DETAILS(LOT_ID,ORG_ID,QUANTITY,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME) "
			+ " values(?,?,?,?,?,?,getdate())";

	public static final String GET_LOT_ALLOCATION_DETAILS = " select isnull(ld.STATUS,'') as STATUS,isnull(ld.REMARKS,'') as REMARKS,c.TYPE,c.LOT_LOCATION as LOT_LOC_ID,ld.ORG_ID,ld.ID,c.LOT_NO,om.ORGANIZATION_NAME,ld.QUANTITY,lz.NAME as LOT_LOCATION "
			+ " from MINING.dbo.LOT_ALLOCATION_DETAILS ld "
			+ " left outer join  AMS.dbo.MINING_ORGANIZATION_MASTER om on om.SYSTEM_ID=ld.SYSTEM_ID and om.CUSTOMER_ID=ld.CUSTOMER_ID and ld.ORG_ID=om.ID "
			+ " left outer join  MINING.dbo.LOT_DETAILS c on c.SYSTEM_ID=ld.SYSTEM_ID and c.CUSTOMER_ID=ld.CUSTOMER_ID and c.ID=ld.LOT_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=c.LOT_LOCATION "
			+ " where ld.SYSTEM_ID=? and ld.CUSTOMER_ID=? order  by ld.INSERTED_DATETIME desc ";

	public static final String GET_LOT_MASTER_DETAILS = " select isnull(a.STATUS,'') as STATUS,isnull(a.REMARKS,'') as REMARKS,(select count(LOT_ID) from MINING.dbo.LOT_ALLOCATION_DETAILS where LOT_ID=a.ID and isnull(STATUS,'') not in ('Cancelled')) as LOT_ALLO_COUNT,a.ID,isnull(LOT_NO,'') as LOT_NO,isnull(b.NAME,'') as LOT_LOCATION,isnull(GRADE,'')as GRADE,isnull(a.TYPE,'')as TYPE,isnull(a.QUANTITY,0)as QUANTITY, "
			+ " isnull(a.FORTY_PER_AMOUNT_PAID,0)as FORTY,isnull(a.FORTY_PER_DATE,'') as Date,isnull(a.SIXTY_PER_AMOUNT_PAID,0)as SIXTY,isnull(a.SIXTY_PER_DATE,'') as DATE1 "
			+ " from MINING.dbo.LOT_DETAILS a "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A b on a.SYSTEM_ID=a.SYSTEM_ID and CLIENTID=a.CUSTOMER_ID and  b.HUBID=a.LOT_LOCATION "
			+ " where SYSTEM_ID=? and CUSTOMER_ID=? order by INSERTED_DATETIME desc ";

	public static final String INSERT_LOT_MASTER_DETAILS = " insert into MINING.dbo.LOT_DETAILS (LOT_NO,LOT_LOCATION,GRADE,TYPE,QUANTITY,REMARKS,FORTY_PER_AMOUNT_PAID,FORTY_PER_DATE,SIXTY_PER_AMOUNT_PAID,SIXTY_PER_DATE,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME) values(?,?,?,?,?,?,?,?,?,?,?,?,?,getdate()) ";

	public static final String UPDATE_LOT_MASTER_DETAILS = " update MINING.dbo.LOT_DETAILS set FORTY_PER_AMOUNT_PAID=? ,FORTY_PER_DATE=?,SIXTY_PER_AMOUNT_PAID=?,SIXTY_PER_DATE=?,REMARKS=?,UPDATED_BY=?,UPDATED_DATETIME=getdate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String INSERT_STOCK_FOR_LOT = " INSERT INTO AMS.dbo.MINING_STOCKYARD_MASTER (ROUTE_ID,ORGANIZATION_ID,FINES,LUMPS,ROM_QTY,TAILINGS,CONCENTRATES,SYSTEM_ID,CUSTOMER_ID,MINERAL_TYPE) VALUES (?,?,?,?,?,?,?,?,?,?) ";

	public static final String GET_LOT_NO_VALIDATE = "select LOT_NO from MINING.dbo.LOT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and LOT_NO=?";

	public static final String UPDATE_GRADE = " update AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS set GRADE=? where PERMIT_ID=? ";

	public static final String GET_ORGANISATION_DETAILS_FOR_PERMIT_REPORT = " select 0 as ID,'ALL' as ORGANIZATION_NAME "
			+ " union all "
			+ " select ID,ORGANIZATION_NAME from AMS.dbo.MINING_ORGANIZATION_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? "
			+ " and ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)";

	public static final String GET_ALL_PERMIT_REPORT_DETAILS = " select isnull(b.ORGANIZATION_NAME,'') as BUYING_ORGANIZATION_NAME, "
			+ " isnull(b.ORGANIZATION_CODE,'') as BUYING_ORGANIZATION_CODE,isnull(d.TC_NO,'') as TC_NO,  "
			+ " isnull(a.TRIPSHEET_QTY,0)/1000 as TRIPSHEET_QTY,CASE WHEN isnull(h.ORGANIZATION_NAME,'') ='' THEN e.ORGANIZATION_NAME ELSE h.ORGANIZATION_NAME END as ORGANIZATION_NAME,a.INSERTED_DATETIME, "
			+ " CASE when pop.TYPE='Fines' THEN pop.QUANTITY ELSE 0 END as FINES_QUANTITY,  "
			+ " CASE when pop.TYPE='Lumps' THEN pop.QUANTITY ELSE 0 END as LUMPS_QUANTITY, "
			+ " CASE when pop.TYPE='' THEN pop.QUANTITY ELSE 0 END as ROM_QUANTITY, "
			+ " CASE when pop.TYPE='Tailings' THEN pop.QUANTITY ELSE 0 END as TAILINGS_QUANTITY, "
			+ " CASE when pop.TYPE='Rejects' THEN pop.QUANTITY ELSE 0 END as REJECTS_QUANTITY, "
			+ " CASE when pop.TYPE='Concentrates' THEN pop.QUANTITY ELSE 0 END as CONCENTRATES_QUANTITY, a.PERMIT_NO,a.PERMIT_TYPE,a.MINERAL "
			+ " from MINING_PERMIT_DETAILS a  " + " left outer join AMS.dbo.MINING_TC_MASTER d on a.TC_ID=d.ID  "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=d.MINE_ID  "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pop on pop.PERMIT_ID=a.ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER h on h.ID=a.ORGANIZATION_CODE  "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER b on b.ID=a.BUYING_ORG_ID   "
			+ " where a.MINERAL=? and a.SYSTEM_ID=? AND a.CUSTOMER_ID=?  "
			+ " and a.INSERTED_DATETIME between dateadd(mi,-330,?) and dateadd(mi,-330,?) " + " && " + " union all  "
			+ " select '' as BUYING_ORGANIZATION_NAME,'' as BUYING_ORGANIZATION_CODE, "
			+ " '' as TC_NO,sum(r.TRIPSHEET_QTY),'Z' as ORGANIZATION_NAME,'' as INSERTED_DATETIME, "
			+ " sum(r.FINES_QUANTITY)as FINES_QUANTITY,sum(r.LUMPS_QUANTITY)as LUMPS_QUANTITY,sum(r.ROM_QUANTITY)as ROM_QUANTITY,sum(r.TAILINGS_QUANTITY)as TAILINGS_QUANTITY,sum(r.REJECTS_QUANTITY)as REJECTS_QUANTITY,sum(r.CONCENTRATES_QUANTITY)as CONCENTRATES_QUANTITY, "
			+ " '' as PERMIT_NO,'' as PERMIT_TYPE,'' as MINERAL from (select "
			+ " sum(isnull(a.TRIPSHEET_QTY,0))/1000 as TRIPSHEET_QTY, "
			+ " CASE when pop.TYPE='Fines' THEN sum(pop.QUANTITY) ELSE 0 END as FINES_QUANTITY, "
			+ " CASE when pop.TYPE='Lumps' THEN sum(pop.QUANTITY) ELSE 0 END as LUMPS_QUANTITY, "
			+ " CASE when pop.TYPE='' THEN sum(pop.QUANTITY) ELSE 0 END as ROM_QUANTITY, "
			+ " CASE when pop.TYPE='Tailings' THEN sum(pop.QUANTITY) ELSE 0 END as TAILINGS_QUANTITY, "
			+ " CASE when pop.TYPE='Rejects' THEN sum(pop.QUANTITY) ELSE 0 END as REJECTS_QUANTITY, "
			+ " CASE when pop.TYPE='Concentrates' THEN sum(pop.QUANTITY) ELSE 0 END as CONCENTRATES_QUANTITY, "
			+ " a.PERMIT_NO,a.PERMIT_TYPE,a.MINERAL " + " from MINING_PERMIT_DETAILS a "
			+ " left outer join AMS.dbo.MINING_TC_MASTER d on a.TC_ID=d.ID "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=d.MINE_ID "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pop on pop.PERMIT_ID=a.ID "
			+ " where  a.MINERAL=? and a.SYSTEM_ID=? AND a.CUSTOMER_ID=?  "
			+ " and a.INSERTED_DATETIME between dateadd(mi,-330,?) and dateadd(mi,-330,?) " + " && "
			+ " group by pop.TYPE,TRIPSHEET_QTY,a.PERMIT_NO,a.PERMIT_TYPE,a.MINERAL) r "
			+ " order by ORGANIZATION_NAME,PERMIT_TYPE  ";

	public static final String GET_PERMIT_SUMMARY_REPORT_DETAILS = "select k.ORG_NAME ,k.PERMIT_TYPE,sum(k.ROM_QUANTITY)as ROM_QUANTITY,sum(k.FINES_QUANTITY)as FINES_QUANTITY,sum(k.LUMPS_QUANTITY)as LUMPS_QUANTITY,sum(k.TAILINGS_QUANTITY)as TAILINGS_QUANTITY,sum(k.REJECTS_QUANTITY)as REJECTS_QUANTITY,sum(k.CONCENTRATES_QUANTITY)as CONCENTRATES_QUANTITY, "
			+ "sum(k.ROM_TRIPSHEET_QTY)as ROM_TRIPSHEET_QTY,sum(k.FINES_TRIPSHEET_QTY)as FINES_TRIPSHEET_QTY,sum(k.LUMPS_TRIPSHEET_QTY)as LUMPS_TRIPSHEET_QTY,sum(k.TAILINGS_TRIPSHEET_QTY)as TAILINGS_TRIPSHEET_QTY,sum(k.REJECTS_TRIPSHEET_QTY)as REJECTS_TRIPSHEET_QTY,sum(k.CONCENTRATES_TRIPSHEET_QTY)as CONCENTRATES_TRIPSHEET_QTY from "
			+ "(select isnull(h.ORGANIZATION_NAME,'') as ORGANIZATION_NAME, "
			+ "isnull(e.ORGANIZATION_NAME,'') as TC_ORGANIZATION_NAME,isnull(h.ORGANIZATION_CODE,'') as ORGANIZATION_CODE, "
			+ "CASE WHEN isnull(h.ORGANIZATION_NAME,'') ='' THEN e.ORGANIZATION_NAME ELSE h.ORGANIZATION_NAME END as ORG_NAME, "
			+ "CASE WHEN (pop.TYPE='' or pop.TYPE='Rom') THEN isnull(a.TRIPSHEET_QTY,0)*0.001 ELSE 0 END as ROM_TRIPSHEET_QTY, "
			+ "CASE WHEN pop.TYPE='Fines' THEN isnull(a.TRIPSHEET_QTY,0)*0.001 ELSE 0 END as FINES_TRIPSHEET_QTY, "
			+ "CASE WHEN pop.TYPE='Lumps' THEN isnull(a.TRIPSHEET_QTY,0)*0.001 ELSE 0 END as LUMPS_TRIPSHEET_QTY, "
			+ "CASE WHEN pop.TYPE='Tailings' THEN isnull(a.TRIPSHEET_QTY,0)*0.001 ELSE 0 END as TAILINGS_TRIPSHEET_QTY, "
			+ "CASE WHEN pop.TYPE='Rejects' THEN isnull(a.TRIPSHEET_QTY,0)*0.001 ELSE 0 END as REJECTS_TRIPSHEET_QTY, "
			+ "CASE WHEN pop.TYPE='Concentrates' THEN isnull(a.TRIPSHEET_QTY,0)*0.001 ELSE 0 END as CONCENTRATES_TRIPSHEET_QTY, "
			+ "CASE when pop.TYPE='Fines' THEN sum(isnull(pop.QUANTITY,0)) ELSE 0 END as FINES_QUANTITY, "
			+ "CASE when pop.TYPE='Lumps' THEN sum(isnull(pop.QUANTITY,0)) ELSE 0 END as LUMPS_QUANTITY, "
			+ "CASE when pop.TYPE='Tailings' THEN sum(isnull(pop.QUANTITY,0)) ELSE 0 END as TAILINGS_QUANTITY, "
			+ "CASE when pop.TYPE='Rejects' THEN sum(isnull(pop.QUANTITY,0)) ELSE 0 END as REJECTS_QUANTITY, "
			+ "CASE when pop.TYPE='Concentrates' THEN sum(isnull(pop.QUANTITY,0)) ELSE 0 END as CONCENTRATES_QUANTITY, "
			+ "CASE when (pop.TYPE='' or pop.TYPE='Rom') THEN sum(isnull(pop.QUANTITY,0)) ELSE 0 END as ROM_QUANTITY, "
			+ "isnull(pop.TYPE,'ROM') as TYPE,a.PERMIT_TYPE,a.MINERAL from AMS.dbo.MINING_PERMIT_DETAILS a "
			+ "left outer join AMS.dbo.MINING_TC_MASTER d on a.TC_ID=d.ID "
			+ "left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=d.MINE_ID "
			+ "left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pop on pop.PERMIT_ID=a.ID "
			+ "left outer join AMS.dbo.MINING_ORGANIZATION_MASTER h on h.ID=a.ORGANIZATION_CODE "
			+ "where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.INSERTED_DATETIME between dateadd(mi,-330,?) and dateadd(mi,-330,?) and a.MINERAL=? "
			+ "and( a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0 )  or a.ORGANIZATION_CODE  in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) "
			+ "group by PERMIT_TYPE,a.MINERAL ,pop.TYPE,h.ORGANIZATION_NAME,h.ORGANIZATION_CODE,e.ORGANIZATION_NAME,a.TRIPSHEET_QTY) k "
			+ "group by k.PERMIT_TYPE, k.ORGANIZATION_NAME,k.ORG_NAME " + "order by k.ORG_NAME ";

	public static final String GET_PROCESSING_FEE_FROM_PF_MASTER = "select isnull(PROCESSING_FEE,0)as PROCESSING_FEE from MINING.dbo.PROCESSING_FEE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and PERMIT_TYPE=? and MINERAL_TYPE=? ";

	public static final String INSERT_PROCESSING_FEE_DETAILS = "insert into MINING.dbo.PROCESSING_FEE_DETAILS(PROCESSING_FEE,PERMIT_TYPE,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,MINERAL_TYPE) values(?,?,?,?,?,getdate(),?)";

	public static final String UPDATE_PROCESSING_FEE_DETAILS = " update MINING.dbo.PROCESSING_FEE_DETAILS set PERMIT_TYPE=?,PROCESSING_FEE=?,UPDATED_DATETIME=getdate(),UPDATED_BY=? where ID=? ";

	public static final String GET_PROCESSING_FEE_DETAILS = "select ID,isnull(MINERAL_TYPE,'') as MINERAL_TYPE,isnull(PERMIT_TYPE,'') as PERMIT_TYPE, isnull(PROCESSING_FEE,0) as PROCESSING_FEE from MINING.dbo.PROCESSING_FEE_DETAILS where SYSTEM_ID=? AND CUSTOMER_ID=?";

	public static final String GET_PERMIT_TYPE_FROM_PROCESSING_FEE_DETAILS = " select PERMIT_TYPE from  MINING.dbo.PROCESSING_FEE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and PERMIT_TYPE=? and MINERAL_TYPE=? ";

	public static final String UPDATE_ASSET_ENROLLMENT_EXCEL_DETAILS = " update AMS.dbo.MINING_ASSET_ENROLLMENT set INSURANCE_POLICY_NO=?,INSURANCE_EXPIRY_DATE=?,PUC_NUMBER=?,PUC_EXPIRY_DATE=?,CHALLAN_NO=?,CHALLAN_DATE=?,BANK_TRANSACTION_NUMBER=?,AMOUNT_PAID=?,VALIDITY_DATE=?,STATUS=?,UPDATED_BY=?,UPDATED_DATETIME=getutcdate(),ROADTAX_VALIDITY_DATE=?,PERMIT_VALIDITY_DATE=? ## where ID=? and ASSET_NUMBER=? ";

	public static final String GET_PERMIT_NUMBERS_FOR_CUSTOM_SEARCH = " select a.ID as PERMIT_ID,a.PERMIT_NO from AMS.dbo.MINING_PERMIT_DETAILS a where a.SYSTEM_ID=? and a.CUSTOMER_ID=? "
			+ " and( a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and   SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0 ) "
			+ " or a.ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=a.SYSTEM_ID))order by a.ID desc";

	public static final String GET_ORG_NAMES_FOR_CUSTOM_SEARCH = " select distinct(d.ORGANIZATION_NAME) as ORG_NAME,d.ORGANIZATION_CODE as ORG_CODE,d.ID as ORG_ID from MINING.dbo.USER_TC_ASSOCIATION c "
			+ " left outer join AMS.dbo.MINING_TC_MASTER a on a.SYSTEM_ID=c.SYSTEM_ID and c.TC_ID=a.ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER d on d.ID=c.ORG_ID and d.SYSTEM_ID=c.SYSTEM_ID "
			+ " where c.USER_ID=? and d.CUSTOMER_ID=? and c.SYSTEM_ID=? ";

	public static final String UPDATE_BARGE_QTY = " update MINING.dbo.BARGE_TRIP_DETAILS set QUANTITY1=isnull(QUANTITY1,0)-? where ID=? ";

	public static final String UPDATE_CLOSE_TRIP_DETAILS_FOR_BARGE = " update MINING.dbo.BARGE_TRUCK_TRIP_DETAILS set STATUS= 'Cancelled',CLOSED_BY=?,CLOSED_DATETIME=GETutcDATE(),REMARKS=? where ID=? and STATUS='CLOSE' ";

	public static final String GET_TRIPSHEET_SUMMARY_REPORT_DETAILS = " select k.ORG_NAME,k.PERMIT_TYPE,sum(k.ROM_TRIPSHEET_QTY)as ROM_TRIPSHEET_QTY,sum(k.FINES_TRIPSHEET_QTY)as FINES_TRIPSHEET_QTY,"
			+ " sum(k.LUMPS_TRIPSHEET_QTY)as LUMPS_TRIPSHEET_QTY from "
			+ " (select pop.PERMIT_ID,isnull(h.ORGANIZATION_NAME,'') as ORGANIZATION_NAME,"
			+ " isnull(e.ORGANIZATION_NAME,'') as TC_ORGANIZATION_NAME,isnull(h.ORGANIZATION_CODE,'') as ORGANIZATION_CODE,"
			+ " CASE WHEN isnull(h.ORGANIZATION_NAME,'') ='' THEN e.ORGANIZATION_NAME ELSE h.ORGANIZATION_NAME END as ORG_NAME, "
			+ " CASE WHEN (pop.TYPE='' or pop.TYPE='Rom') THEN (select sum(r.QUANTITY) from (select isnull(sum(QUANTITY-QUANTITY1),0)*0.001 as QUANTITY from MINING.dbo.TRUCK_TRIP_DETAILS where pop.PERMIT_ID=PERMIT_ID and INSERTED_TIME between dateadd(mi,-330,?) and dateadd(mi,-330,?) union "
			+ " select isnull(sum(QUANTITY-QUANTITY1),0)*0.001 as QUANTITY from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY where pop.PERMIT_ID=PERMIT_ID and INSERTED_TIME between dateadd(mi,-330,?) and dateadd(mi,-330,?))r) ELSE 0 END as ROM_TRIPSHEET_QTY,"
			+ " CASE WHEN pop.TYPE='Fines' THEN  (select sum(r.QUANTITY) from (select isnull(sum(QUANTITY-QUANTITY1),0)*0.001 as QUANTITY from MINING.dbo.TRUCK_TRIP_DETAILS where pop.PERMIT_ID=PERMIT_ID and INSERTED_TIME between dateadd(mi,-330,?) and dateadd(mi,-330,?) union "
			+ " select isnull(sum(QUANTITY-QUANTITY1),0)*0.001 as QUANTITY from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY where pop.PERMIT_ID=PERMIT_ID and INSERTED_TIME between dateadd(mi,-330,?) and dateadd(mi,-330,?))r) ELSE 0 END as FINES_TRIPSHEET_QTY,"
			+ " CASE WHEN pop.TYPE='Lumps' THEN (select sum(r.QUANTITY) from (select isnull(sum(QUANTITY-QUANTITY1),0)*0.001 as QUANTITY from MINING.dbo.TRUCK_TRIP_DETAILS where pop.PERMIT_ID=PERMIT_ID and INSERTED_TIME between dateadd(mi,-330,?) and dateadd(mi,-330,?) union "
			+ " select isnull(sum(QUANTITY-QUANTITY1),0)*0.001 as QUANTITY from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY where pop.PERMIT_ID=PERMIT_ID and INSERTED_TIME between dateadd(mi,-330,?) and dateadd(mi,-330,?))r)  ELSE 0 END as LUMPS_TRIPSHEET_QTY, "
			+ " isnull(pop.TYPE,'ROM') as TYPE,a.PERMIT_TYPE,a.MINERAL " + " from AMS.dbo.MINING_PERMIT_DETAILS a "
			+ " left outer join AMS.dbo.MINING_TC_MASTER d on a.TC_ID=d.ID "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=d.MINE_ID "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS pop on pop.PERMIT_ID=a.ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER h on h.ID=a.ORGANIZATION_CODE "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? " +
			//"and a.INSERTED_DATETIME between dateadd(mi,-330,?) and dateadd(mi,-330,?)" +
			" and a.MINERAL=? and( a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=? and TC_ID!=0 ) "
			+ " or a.ORGANIZATION_CODE in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?))"
			+ " group by PERMIT_TYPE,a.MINERAL ,pop.TYPE,h.ORGANIZATION_NAME,h.ORGANIZATION_CODE,e.ORGANIZATION_NAME,a.TRIPSHEET_QTY,pop.PERMIT_ID) k "
			+ " where (ROM_TRIPSHEET_QTY>0 or FINES_TRIPSHEET_QTY>0 or LUMPS_TRIPSHEET_QTY>0) "
			+ " group by k.PERMIT_TYPE, k.ORGANIZATION_NAME,k.ORG_NAME " + " order by k.ORG_NAME  ";

	public static final String GET_CHALLAN_NUMBERS_FOR_CUSTOM_SEARCH = " select a.ID as CHALLAN_ID,a.CHALLAN_NO from AMS.dbo.MINING_CHALLAN_DETAILS a where a.SYSTEM_ID=? and a.CUSTOMER_ID=? "
			+ " and( a.TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and   SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0 ) "
			+ " or a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=a.SYSTEM_ID))order by a.ID desc ";

	public static final String UPDATE_ROM_QTY_IN_PLANT_MASTER_FOR_CANCEL_PLANT_FEED = "update MINING.dbo.PLANT_MASTER set ROM_QTY=isnull(ROM_QTY,0)+? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String UPDATE_UFO_QTY_IN_PLANT_MASTER_FOR_CANCEL_PLANT_FEED = "update MINING.dbo.PLANT_MASTER set UFO=isnull(UFO,0)-? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String DELETE_PLANT_FEED_RECORD = " delete from AMS.dbo.PLANT_FEED_DETAILS where ID=? ";

	public static final String INSERT_INTO_PLANT_FEED_HISTORY = " insert into MINING.dbo.PLANT_FEED_DETAILS_HISTORY select *,?,?,GETDATE() from AMS.dbo.PLANT_FEED_DETAILS where  ID=? ";

	public static final String DELETE_TRIP_FEED_RECORD = " update MINING.dbo.MINE_TRIP_FEED_DETAILS set STATUS='Cancelled',REMARKS=?,DELETED_BY=?,DELETED_DATETIME=getdate() where ID=? ";

	public static final String DELETE_LOT_MASTER = "  update MINING.dbo.LOT_DETAILS set STATUS='Cancelled',REMARKS=?,DELETED_BY=?,DELETED_DATETIME=getdate() where ID=?  ";

	public static final String UPDATE_ROM_QTY_IN_PLANT_MASTER_FOR_CANCEL_TRIP_FEED = "update MINING.dbo.PLANT_MASTER set ROM_QTY=isnull(ROM_QTY,0)-? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String UPDATE_CHALLAN_USED_QTY_FOR_CANCEL = " update AMS.dbo.MINING_CHALLAN_DETAILS set USED_QTY=isnull(USED_QTY,0)-? where CHALLAN_NO=? ";

	public static final String CHECK_RECORDS_IN_PLANT_MASTER = " select isnull(sum(TOTAL_FINES)-(isnull(pm.FINES,0)),0) as TOTAL_FINES,isnull(sum(TOTAL_LUMPS)-(isnull(pm.LUMPS,0)),0) as TOTAL_LUMPS,isnull(sum(TOTAL_CONCENTRATES)-(isnull(pm.CONCENTRATES,0)),0) as TOTAL_CONCENTRATES,isnull(sum(pf.TAILINGS)-(isnull(pm.TAILINGS,0)),0) as TAILINGS,(isnull(sum(pf.TOTAL_UFO),0)-isnull(pm.UFO,0)) as TOTAL_UFO from AMS.dbo.PLANT_FEED_DETAILS pf  "
			+ " inner join MINING.dbo.PLANT_MASTER pm on pm.ID=pf.PLANT_ID "
			+ " where pf.SYSTEM_ID=? and pf.CUSTOMER_ID=? and PLANT_ID=? group by PLANT_ID,pm.LUMPS,pm.FINES,pm.CONCENTRATES,pm.TAILINGS,pm.UFO ";

	public static final String GET_ROM_QTY = " select isnull(ROM_QTY,0) as ROM_QTY from MINING.dbo.PLANT_MASTER where ID=? ";

	public static final String GET_STOCK_DETAILS_FOR_CANCEL = " ";

	public static final String DELETE_LOT_DETAILS = " update MINING.dbo.LOT_ALLOCATION_DETAILS set REMARKS=?,DELETED_BY=?,DELETED_DATETIME=GETDATE(),STATUS='Cancelled' where ID=? ";

	public static final String GET_OVERSPEED_DEBARRING_DETAILS = "select a.ID as ID,a.ASSET_NO,b.ID as ASSET_ENROLL_ID,a.COUNT,a.NO_OF_DAYS,a.BLOCKED_TILL_DATE,isnull(a.REMARKS,'') as REMARKS,isnull(b.STATUS,'') as STATUS,a.UPDATED_DATETIME,isnull((u.Firstname+' '+u.Lastname),'') as UPDATED_BY from MINING.dbo.OVERSPPED_DEBARRING_DETAILS a "
			+ "inner join AMS.dbo.MINING_ASSET_ENROLLMENT b on a.ASSET_NO=b.ASSET_NUMBER COLLATE DATABASE_DEFAULT and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ "left outer join AMS.dbo.Users u on u.System_id=a.SYSTEM_ID and u.User_id=a.UPDATED_BY "
			+ "where a.DATE between dateadd(mi,0,?) and dateadd(mi,0,?) and a.SYSTEM_ID=? and a.CUSTOMER_ID=? ";

	public static final String UPDATE_REMARKS_IN_OVERSPEED_DEBARRING = "update MINING.dbo.OVERSPPED_DEBARRING_DETAILS set REMARKS=?,UPDATED_BY=?,UPDATED_DATETIME=getDate() where ## CUSTOMER_ID=? and SYSTEM_ID=? ";

	public static final String UPDATE_STATUS_IN_MINING_ASSET_ENROLLMENT = "update AMS.dbo.MINING_ASSET_ENROLLMENT set STATUS='Active' where ID=? and ASSET_NUMBER=? and CUSTOMER_ID=?";

	//public static final String INSERT_MINE_MASTER_HISTORY_DETAILS="insert into MINING.dbo.MINE_MASTER_HISTORY(MINE_ID, CARRY_FORWARDED_EC, EC_LIMIT, ENHANCED_EC, REMARK, SYSTEM_ID, CUSTOMER_ID, INSERTED_BY,FINANCIAL_YEAR) values(?,?,?,?,?,?,?,?,?)";
	//--------------------------------------------Mother Route Master-----------------------------//
	public static final String CHECK_MOTHER_ROUTE_ALREADY_EXIST = "SELECT ID,STATUS from MINING.dbo.MOTHER_ROUTE_MASTER WHERE NAME=? AND CUSTOMER_ID=? AND SYSTEM_ID=?";

	public static final String INSERT_MOTHER_ROUTE_MASTER = "INSERT INTO MINING.dbo.MOTHER_ROUTE_MASTER(NAME,TRIP_SHEET_LIMIT,STATUS,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY)values(?,?,?,?,?,?)";

	public static final String UPDATE_MOTHER_ROUTE_MASTER = "UPDATE MINING.dbo.MOTHER_ROUTE_MASTER SET NAME=?,TRIP_SHEET_LIMIT=?,UPDATED_BY=?,UPDATED_DATETIME=getDate() WHERE ID=?";

	public static final String GET_MOTHER_ROUTE_MASTER = " select a.ID,isnull(a.NAME,'')as MOTHER_ROUTE_NAME, isnull(a.TRIP_SHEET_LIMIT,0)as MOTHER_ROUTE_TS_LIMIT, isnull(a.STATUS,'')as STATUS, isnull(a.INACTIVE_REASON,'')as INACTIVE_REASON, a.ACTIVE_INACTIVE_DT as ACTIVE_INACTIVE_DT, isnull((u3.Firstname+' '+u3.Lastname),'')as ACTIVE_INACTIVE_BY, "
			+ " dateadd(mi,330,a.INSERTED_DATETIME) as INSERTED_DATETIME, isnull((u1.Firstname+' '+u1.Lastname),'')as INSERTED_BY, a.UPDATED_DATETIME as UPDATED_DATETIME, isnull((u2.Firstname+' '+u2.Lastname),'') as UPDATED_BY "
			+ " from MINING.dbo.MOTHER_ROUTE_MASTER a "
			+ " inner join AMS.dbo.Users u1 on u1.System_id=a.SYSTEM_ID and u1.User_id=a.INSERTED_BY "
			+ " left outer join AMS.dbo.Users u2 on u2.System_id=a.SYSTEM_ID and u2.User_id=a.UPDATED_BY "
			+ " left outer join AMS.dbo.Users u3 on u3.System_id=a.SYSTEM_ID and u3.User_id=a.ACTIVE_INACTIVE_BY "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? order by a.ID desc ";

	public static final String GET_ROUTE_MASTER_TOTAL_COUNT_DETAILS = "select isnull(sum(TOTAL_TRIPSHEET_COUNT),0)as TOTAL_TRIPSHEET_COUNT from MINING.dbo.ROUTE_DETAILS where MOTHER_ROUTE_ID=?";

	public static final String UPDATE_STATUS_FOR_MOTHER_ROUTE = "update MINING.dbo.MOTHER_ROUTE_MASTER set STATUS=?, ACTIVE_INACTIVE_BY=?, ACTIVE_INACTIVE_DT=getdate() # where ID=?";

	public static final String UPDATE_ROUTE_MASTER_STATUS_FOR_MOTHER_ROUTE = "update MINING.dbo.ROUTE_DETAILS set STATUS=? where MOTHER_ROUTE_ID=?";

	//------------------------Production Details------------------------------------------//
	public static final String GET_PRODUCTION_MASTER_DETAILS = " select a.ID as UID,a.ORG_ID,isnull(b.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(b.ORGANIZATION_CODE,'')as ORGANIZATION_CODE,a.TC_ID,isnull(c.TC_NO,'')as TC_NO,a.DATE,isnull(a.PRODUCTION_QTY,0)as PRODUCTION_QTY ,"
			+ " CASE WHEN a.DATE=(SELECT TOP 1 DATE FROM MINING.dbo.PRODUCTION_DETAILS WHERE TC_ID=a.TC_ID and ORG_ID=a.ORG_ID and SYSTEM_ID=a.SYSTEM_ID order by DATE desc) THEN 'T' ELSE 'F' END IS_LATEST "
			+ " from MINING.dbo.PRODUCTION_DETAILS a "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER b on b.ID=a.ORG_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " inner join AMS.dbo.MINING_TC_MASTER c on  c.ID=a.TC_ID and c.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and a.DATE between dateadd(mi,0,?) and dateadd(ss,-1,?) "
			+ " and (c.ID in (SELECT TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ " c.ID in (select c1.ID from MINING.dbo.USER_TC_ASSOCIATION a1 inner join AMS.dbo.MINING_MINE_MASTER b1 on b1.ORG_ID=a1.ORG_ID and a1.SYSTEM_ID=b1.SYSTEM_ID inner join AMS.dbo.MINING_TC_MASTER c1 on b1.ID=c1.MINE_ID and b1.CUSTOMER_ID=c1.CUSTOMER_ID where a1.USER_ID=? and a1.SYSTEM_ID=a.SYSTEM_ID and a1.TC_ID=0 )) "
			+ " order by a.ID desc ";

	public static final String INSERT_PRODUCTION_MASTER = "insert into MINING.dbo.PRODUCTION_DETAILS(ORG_ID,TC_ID,PRODUCTION_QTY,DATE,INSERTED_BY,CUSTOMER_ID,SYSTEM_ID) values(?,?,?,?,?,?,?)";

	public static final String CHECK_PRODUCTION_MASTER = "select ID from MINING.dbo.PRODUCTION_DETAILS a where TC_ID=? and ORG_ID=? and DATE=? and CUSTOMER_ID=? ";

	public static final String UPDATE_PRODUCTION_MASTER = "update MINING.dbo.PRODUCTION_DETAILS set UPDATED_DATETIME=getDate(), UPDATED_BY=? ,PRODUCTION_QTY=? where ID=?";

	public static final String GET_ORG_NAMES_FOR_PRODUCTION_MASTER = " select distinct(d.ORGANIZATION_NAME) as ORG_NAME,d.ORGANIZATION_CODE as ORG_CODE,d.ID as ORG_ID from MINING.dbo.USER_TC_ASSOCIATION c "
			+ " left outer join AMS.dbo.MINING_TC_MASTER a on a.SYSTEM_ID=c.SYSTEM_ID and c.TC_ID=a.ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER d on d.ID=c.ORG_ID and d.SYSTEM_ID=c.SYSTEM_ID "
			+ " where d.TYPE='ORGANIZATION' and c.USER_ID=? and d.CUSTOMER_ID=? and c.SYSTEM_ID=? ";

	public static final String GET_TC_FOR_PRODUCTION_MASTER = " select distinct isnull(a.ID,0)as TC_ID,isnull(a.TC_NO,'')as TC_NO, (isnull(PRODUCTION_MPL,0))as EC_CAPPING_LIMIT, sum(isnull(d.PRODUCTION_QTY,0))as TOTAL_PRODUCTION_QTY from AMS.dbo.MINING_TC_MASTER a "
			+ " inner join AMS.dbo.MINING_MINE_MASTER b on b.ID=a.MINE_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER c on c.ID=b.ORG_ID and c.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join MINING.dbo.PRODUCTION_DETAILS d on  d.ORG_ID=c.ID and d.TC_ID=a.ID and d.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " where c.ID=? and a.CUSTOMER_ID=? "
			+ " and (a.ID in (SELECT TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ " a.ID in (select c1.ID from MINING.dbo.USER_TC_ASSOCIATION a1 inner join AMS.dbo.MINING_MINE_MASTER b1 on b1.ORG_ID=a1.ORG_ID and a1.SYSTEM_ID=b1.SYSTEM_ID inner join AMS.dbo.MINING_TC_MASTER c1 on b1.ID=c1.MINE_ID and b1.CUSTOMER_ID=c1.CUSTOMER_ID where a1.USER_ID=? and a1.SYSTEM_ID=a.SYSTEM_ID and a1.TC_ID=0 )) "
			+ " group by a.ID, a.TC_NO, a.EC_CAPPING_LIMIT,a.PRODUCTION_MPL ";

	public static final String GET_PRODUCTION_SUMMARY_DETAILS = " select a.ORG_ID,isnull(b.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(b.ORGANIZATION_CODE,'')as ORGANIZATION_CODE,a.TC_ID,isnull(c.TC_NO,'')as TC_NO,sum(isnull(a.PRODUCTION_QTY,0))as TOTAL_PRODUCTION_QTY "
			+ " from MINING.dbo.PRODUCTION_DETAILS a "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER b on b.ID=a.ORG_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_TC_MASTER c on  c.ID=a.TC_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " where a.CUSTOMER_ID=? and a.SYSTEM_ID=? " 
			+ " $ "
			+ " and (c.ID in (SELECT TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ " c.ID in (select c1.ID from MINING.dbo.USER_TC_ASSOCIATION a1 inner join AMS.dbo.MINING_MINE_MASTER b1 on b1.ORG_ID=a1.ORG_ID and a1.SYSTEM_ID=b1.SYSTEM_ID inner join AMS.dbo.MINING_TC_MASTER c1 on b1.ID=c1.MINE_ID and b1.CUSTOMER_ID=c1.CUSTOMER_ID where a1.USER_ID=? and a1.SYSTEM_ID=a.SYSTEM_ID and a1.TC_ID=0 )) "
			+ " group by a.ORG_ID,b.ORGANIZATION_NAME,b.ORGANIZATION_CODE,a.TC_ID,c.TC_NO ";

	//&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& **DASHBOARD QUERY** &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

	public static final String GET_CHALLAN_QUANTITY = " select sum(cgd.RATE*cgd.QUANTITY) as ROYALITY,sum(GIOPF_QTY*GIOPF_RATE) as GIOPF,sum((cgd.RATE*cgd.QUANTITY)*0.30) as DMF,  "
			+ " sum((cgd.RATE*cgd.QUANTITY)*0.02) as NMET,sum(TOTAL) as PROCESSING_FEE from AMS.dbo.MINING_CHALLAN_DETAILS a  "
			+ " left outer JOIN AMS.dbo.CHALLAN_GRADE_DETAILS cgd on a.ID=cgd.CHALLAN_ID "
			+ " where SYSTEM_ID=? AND CUSTOMER_ID=? and CHALLAN_DATETIME between  "
			+ " DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE()))  "
			+ " and STATUS='APPROVED' and(a.TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and "
			+ " SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or  "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)) ";

	public static final String GET_PERMIT_QUANTITIES = " select isnull(sum(popd.QUANTITY),0) as QTY,'Export' as TYPE from AMS.dbo.MINING_PERMIT_DETAILS a "
			+ " left outer JOIN AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd on a.ID=popd.PERMIT_ID "
			+ " where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS='APPROVED' and PERMIT_TYPE in ('International Export') and  "
			+ " INSERTED_DATETIME between DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and STATUS='APPROVED' and ( a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=?  "
			+ " and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0)  "
			+ " or a.ORGANIZATION_CODE  in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)) "
			+ " union all "
			+ " select isnull(sum(popd.QUANTITY),0) as QTY,'Transit' as TYPE from AMS.dbo.MINING_PERMIT_DETAILS a  "
			+ " left outer JOIN AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd on a.ID=popd.PERMIT_ID  "
			+ " where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS='APPROVED' and  "
			+ " INSERTED_DATETIME between DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and STATUS='APPROVED' and PERMIT_TYPE like '%Transit%' and PERMIT_TYPE NOT IN('Import Transit Permit') "
			+ " and ( a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=?  "
			+ " and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0)  "
			+ " or a.ORGANIZATION_CODE  in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID))  "
			+ " union all  "
			+ " select isnull(sum(popd.QUANTITY),0) as QTY,'Import' as TYPE from AMS.dbo.MINING_PERMIT_DETAILS a "
			+ " left outer JOIN AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd on a.ID=popd.PERMIT_ID "
			+ " where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS='APPROVED' and PERMIT_TYPE ='Import Transit Permit' and "
			+ " INSERTED_DATETIME between DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and STATUS='APPROVED'and ( a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=?  "
			+ " and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) "
			+ " or a.ORGANIZATION_CODE  in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)) "
			+ " union all  "
			+ " select sum(TOTAL_PROCESSING_FEE) as PROCESSING_FEE,'pfee' as TYPE from AMS.dbo.MINING_PERMIT_DETAILS a "
			+ " left outer JOIN AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd on a.ID=popd.PERMIT_ID "
			+ " where SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS='APPROVED' and "
			+ " INSERTED_DATETIME between DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and STATUS='APPROVED' and ( a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=?  "
			+ " and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) "
			+ " or a.ORGANIZATION_CODE  in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)) ";

	public static final String GET_PRODUCTION = " select isnull(sum(PRODUCTION_QTY),0) as PRODUCTION_QTY from MINING.dbo.PRODUCTION_DETAILS a "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER b on b.ID=a.ORG_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " inner join AMS.dbo.MINING_TC_MASTER c on  c.ID=a.TC_ID and c.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and a.DATE between DATEADD(dd, -1, DATEDIFF(dd, 0, GETDATE())) and DATEADD(mi, -1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and (c.ID in (SELECT TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ " c.ID in (select c1.ID from MINING.dbo.USER_TC_ASSOCIATION a1 inner join AMS.dbo.MINING_MINE_MASTER b1 on b1.ORG_ID=a1.ORG_ID "
			+ " and a1.SYSTEM_ID=b1.SYSTEM_ID inner join AMS.dbo.MINING_TC_MASTER c1 on b1.ID=c1.MINE_ID and b1.CUSTOMER_ID=c1.CUSTOMER_ID "
			+ " where a1.USER_ID=? and a1.SYSTEM_ID=a.SYSTEM_ID and a1.TC_ID=0 )) ";

	public static final String GET_ORG_COUNT = " select count(ID) as COUNT,'lease' as TYPE from MINING_TC_MASTER a where SYSTEM_ID=? AND CUSTOMER_ID=? and ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? "
			+ " and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) " + " union all  "
			+ " select count(ID) as COUNT,'org' as TYPE from MINING_ORGANIZATION_MASTER a where SYSTEM_ID=? AND CUSTOMER_ID=? and TYPE='ORGANIZATION' and "
			+ " ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)  "
			+ " union all  "
			+ " select count(ID) as COUNT,'trader' as TYPE from MINING_ORGANIZATION_MASTER a where SYSTEM_ID=? AND CUSTOMER_ID=? and TYPE='TRADER' and  "
			+ " ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)  ";

	public static final String GET_IBMRATE = "select MONTH,YEAR,GRADE,RATE,'IBMRATE' as RATE_TYPE from AMS.dbo.MINING_GRADE_MASTER where MINERAL_CODE='Fe' and YEAR=? and TYPE=? "
			+ " and CUSTOMER_ID=? and SYSTEM_ID=? and MONTH=? ";

	public static final String GET_ROYALTY = " select MONTH,YEAR,GRADE,RATE*0.15 as RATE,'ROYALTY' as RATE_TYPE from AMS.dbo.MINING_GRADE_MASTER where MINERAL_CODE='Fe' and YEAR=? and TYPE=? "
			+ " and CUSTOMER_ID=? and SYSTEM_ID=? and MONTH=? ";

	public static final String GET_GIOPF = " select MONTH,YEAR,GRADE,RATE*0.10 as RATE,'GIOPF' as RATE_TYPE from AMS.dbo.MINING_GRADE_MASTER where MINERAL_CODE='Fe' and YEAR=? and TYPE=?  "
			+ " and CUSTOMER_ID=? and SYSTEM_ID=? and MONTH=? ";

	public static final String GET_PRODUCTION_SUMMARY = " select isnull(PRODUCTION_MPL/1000000,0) as MPL_ALLOCATED,a.ORG_ID,isnull(b.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(b.ORGANIZATION_CODE,'')as ORGANIZATION_CODE,a.TC_ID,isnull(c.TC_NO,'')as TC_NO,sum(isnull(a.PRODUCTION_QTY/1000000,0))as TOTAL_PRODUCTION_QTY "
			+ " from MINING.dbo.PRODUCTION_DETAILS a "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER b on b.ID=a.ORG_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINING_TC_MASTER c on  c.ID=a.TC_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " where a.CUSTOMER_ID=? and a.SYSTEM_ID=?  and (c.ID in (SELECT TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ " c.ID in (select c1.ID from MINING.dbo.USER_TC_ASSOCIATION a1 inner join AMS.dbo.MINING_MINE_MASTER b1 on b1.ORG_ID=a1.ORG_ID and a1.SYSTEM_ID=b1.SYSTEM_ID inner join AMS.dbo.MINING_TC_MASTER c1 on b1.ID=c1.MINE_ID and b1.CUSTOMER_ID=c1.CUSTOMER_ID where a1.USER_ID=? and a1.SYSTEM_ID=a.SYSTEM_ID and a1.TC_ID=0 )) "
			+ " group by a.ORG_ID,b.ORGANIZATION_NAME,b.ORGANIZATION_CODE,a.TC_ID,c.TC_NO,c.EC_CAPPING_LIMIT,c.PRODUCTION_MPL ";

	public static final String GET_DAYWISE_PRODUCTION_SUMMARY = " select isnull(c.EC_CAPPING_LIMIT,0) as MPL_ALLOCATED,a.ID as UID,a.ORG_ID,isnull(b.ORGANIZATION_NAME,'')as ORGANIZATION_NAME,isnull(b.ORGANIZATION_CODE,'')as ORGANIZATION_CODE,a.TC_ID,isnull(c.TC_NO,'')as TC_NO,a.DATE,isnull(a.PRODUCTION_QTY,0)as PRODUCTION_QTY  "
			+ " from MINING.dbo.PRODUCTION_DETAILS a "
			+ " inner join AMS.dbo.MINING_ORGANIZATION_MASTER b on b.ID=a.ORG_ID and b.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " inner join AMS.dbo.MINING_TC_MASTER c on  c.ID=a.TC_ID and c.CUSTOMER_ID=a.CUSTOMER_ID "
			+ " where a.CUSTOMER_ID=? and a.SYSTEM_ID=? and a.DATE between DATEADD(dd, -1, DATEDIFF(dd, 0, GETDATE())) and DATEADD(mi, -1, DATEDIFF(dd, 0, GETDATE())) "
			+ " and (c.ID in (SELECT TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ " c.ID in (select c1.ID from MINING.dbo.USER_TC_ASSOCIATION a1 inner join AMS.dbo.MINING_MINE_MASTER b1 on b1.ORG_ID=a1.ORG_ID "
			+ " and a1.SYSTEM_ID=b1.SYSTEM_ID inner join AMS.dbo.MINING_TC_MASTER c1 on b1.ID=c1.MINE_ID and b1.CUSTOMER_ID=c1.CUSTOMER_ID where a1.USER_ID=? and a1.SYSTEM_ID=a.SYSTEM_ID and a1.TC_ID=0 )) "
			+ " order by a.ID desc ";

	public static final String GET_TRUCK_TRIP_QTY = "select isnull(sum(r.QUANTITY),0)/1000 as QUANTITY from "
			+ " (select sum(QUANTITY-QUANTITY1) as QUANTITY from MINING.dbo.TRUCK_TRIP_DETAILS(NOLOCK) a where SYSTEM_ID=? AND CUSTOMER_ID=? and INSERTED_TIME between "
			+ " DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) and STATUS not in ('Cancelled','Cancelled-Breakdown') and "
			+ " (a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or   "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID))   "
			+ " union all   "
			+ " select sum(QUANTITY-QUANTITY1) as QUANTITY from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY(NOLOCK) a where SYSTEM_ID=? AND CUSTOMER_ID=? and INSERTED_TIME between   "
			+ " DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE())) and  STATUS not in ('Cancelled','Cancelled-Breakdown') and "
			+ "(a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or   "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)) ) r ";

	public static final String GET_BARGE_TRIP_QTY = " select sum(QUANTITY1) as QUANTITY from MINING.dbo.BARGE_TRIP_DETAILS a where SYSTEM_ID=? and CUSTOMER_ID=? and INSERTED_TIME between "
			+ " dateadd(mi,-330,DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))) and dateadd(mi,-330,DATEADD(dd, 1, DATEDIFF(dd, 0, GETDATE()))) and  "
			+ " (a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=?)) ";

	public static final String GET_PRODUCTION_FOR_CHART = " select sum(isnull(r.TOTAL_PRODUCTION_QTY,0))as TOTAL_PRODUCTION_QTY,sum(isnull(r.TOTAL_ALLOCATION_QTY,0))as TOTAL_ALLOCATION_QTY from( "
			+ " select distinct tc.TC_NO,sum(isnull(a.PRODUCTION_QTY,0))as TOTAL_PRODUCTION_QTY,(isnull(PRODUCTION_MPL,0))as TOTAL_ALLOCATION_QTY "
			+ " from MINING.dbo.PRODUCTION_DETAILS a "
			+ " inner join AMS.dbo.MINING_TC_MASTER tc on  tc.ID=a.TC_ID and tc.CUSTOMER_ID=a.CUSTOMER_ID  "
			+ " where a.CUSTOMER_ID=? and a.SYSTEM_ID=?  and (tc.ID in (SELECT TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or  "
			+ " tc.ID in (select c1.ID from MINING.dbo.USER_TC_ASSOCIATION a1 inner join AMS.dbo.MINING_MINE_MASTER b1 on b1.ORG_ID=a1.ORG_ID and a1.SYSTEM_ID=b1.SYSTEM_ID  "
			+ " left outer join AMS.dbo.MINING_TC_MASTER c1 on b1.ID=c1.MINE_ID and b1.CUSTOMER_ID=c1.CUSTOMER_ID where a1.USER_ID=?  "
			+ " and a1.SYSTEM_ID=a.SYSTEM_ID and a1.TC_ID=0 ))  "
			+ " group by TC_NO,tc.EC_CAPPING_LIMIT,tc.PRODUCTION_MPL)r ";

	public static final String GET_GRADE_DATA = " select ID, isnull(MONTH,'')as MONTH, isnull(YEAR,'')as YEAR, isnull(GRADE,'')as GRADE,isnull(RATE,0)as RATE, "
			+ " isnull(MINERAL_CODE,'')as MINERAL_CODE, isnull(TYPE,'')as TYPE,RATE*0.15 as ROYALTY,RATE*0.10 as GIOPF "
			+ " from AMS.dbo.MINING_GRADE_MASTER WHERE SYSTEM_ID=? AND CUSTOMER_ID=? and MONTH=? and YEAR=? and TYPE=? "
			+ " order by ID asc ";

	public static final String GET_ROYALTY_FOR_DASHBOARD = " select sum(r.QTY_IN_TONS) as QTY_IN_TONS,sum(r.ROYALTY_COLLECTED) as ROYALTY_COLLECTED,r.CHALLAN_GRADE from (select (case when cgd.GRADE like '%Fines%' then 'Fines'  "
			+ " when cgd.GRADE like '%Lumps%' then 'Lumps' when cgd.GRADE like '%Concentrates%' then 'Concentrates'  "
			+ " when cgd.GRADE like '%ROM%' then 'ROM' end) as CHALLAN_GRADE,cgd.QUANTITY as QTY_IN_TONS,PAYABLE as ROYALTY_COLLECTED "
			+ " from AMS.dbo.MINING_CHALLAN_DETAILS a "
			+ " inner join AMS.dbo.CHALLAN_GRADE_DETAILS cgd on cgd.CHALLAN_ID=a.ID "
			+ " where SYSTEM_ID=? and CUSTOMER_ID=? and "
			+ " datename(month, CHALLAN_DATETIME) = ? and datepart(yyyy,CHALLAN_DATETIME)=? and STATUS='APPROVED' and "
			+ "(a.TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)))r group by r.CHALLAN_GRADE ";

	public static final String GET_DOMESTIC_CONSUMPTION = "select isnull(sum(QTY),0) as QUANTITY from MINING.dbo.MINE_TRIP_FEED_DETAILS a "
			+ " where SYSTEM_ID=? AND CUSTOMER_ID=? AND INSERTED_DATETIME between DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE())) and "
			+ " DATEADD(dd, 0, DATEDIFF(dd, 1, GETDATE())) and PLANT_ID is null and isnull(STATUS,'')!='Cancelled' and ORGANIZATION_ID in "
			+ " (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID) ";

	public static final String GET_VEHICLES_FOR_TRIP_TRANSFER = "select td.ID,td.TRIP_NO,td.ASSET_NUMBER from MINING.dbo.TRUCK_TRIP_DETAILS td where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS='OPEN' and (td.QUANTITY3 is null or  td.QUANTITY3=0)";

	public static final String GET_ORG_ROYALTY = "select mom.ORGANIZATION_NAME,sum(ROYALTY)as ROYALTY,sum(GIOPF)as GIOPF,sum(PROCESSING_FEE)as PROCESSING_FEE from( "
			+ "select case when a.TC_NO=0 then a.ORGANIZATION_ID else mm.ORG_ID end as ORG_ID,a.CUSTOMER_ID, "
			+ "(select sum(isnull(PAYABLE,0)) from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.ID)as ROYALTY,sum(isnull(GIOPF_QTY,0)*isnull(GIOPF_RATE,0))as GIOPF ,(select sum(isnull(QUANTITY,0)) from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.ID)*isnull(PROCESSING_FEE,0) as PROCESSING_FEE "
			+ "from AMS.dbo.MINING_CHALLAN_DETAILS a "
			+ "left outer join AMS.dbo.MINING_TC_MASTER tc on tc.ID=a.TC_NO and a.CUSTOMER_ID=tc.CUSTOMER_ID and a.SYSTEM_ID=tc.SYSTEM_ID "
			+ "left outer join AMS.dbo.MINING_MINE_MASTER mm on mm.ID=tc.MINE_ID and tc.CUSTOMER_ID=mm.CUSTOMER_ID "
			+ "where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='APPROVED' ## "
			+ "and(a.TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ "a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID))"
			+ "group by a.ID,a.TC_NO,a.ORGANIZATION_ID,mm.ORG_ID,a.CUSTOMER_ID,a.PROCESSING_FEE)r "
			+ "inner join AMS.dbo.MINING_ORGANIZATION_MASTER mom on mom.ID=r.ORG_ID and mom.CUSTOMER_ID=r.CUSTOMER_ID group by mom.ORGANIZATION_NAME order by ROYALTY desc";

	public static final String GET_ACCOUNT_DETAILS = " select sum(isnull(cgd.PAYABLE,0)) as ROYALTY,sum(GIOPF_QTY*GIOPF_RATE) as GIOPF ,sum(isnull(cgd.QUANTITY,0)*isnull(PROCESSING_FEE,0)) as PROCESSING_FEE  "
			+ "from AMS.dbo.MINING_CHALLAN_DETAILS a "
			+ "inner join  AMS.dbo.CHALLAN_GRADE_DETAILS cgd on a.ID=cgd.CHALLAN_ID "
			+ "where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? ## "
			+ "and a.STATUS='APPROVED' and(a.TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ "a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID))";

	public static final String GET_MONTHLY_ACCOUNT_DETAILS = "select datepart(year,dateadd(mi,0,a.INSERTED_DATETIME))as YEAR,datepart(month,dateadd(mi,0,a.INSERTED_DATETIME))as MONTH,sum(isnull(cgd.PAYABLE,0)) as ROYALTY,sum(GIOPF_QTY*GIOPF_RATE) as GIOPF, sum(isnull(cgd.QUANTITY,0)*isnull(PROCESSING_FEE,0)) as PROCESSING_FEE "
			+ " from AMS.dbo.MINING_CHALLAN_DETAILS a "
			+ " inner join  AMS.dbo.CHALLAN_GRADE_DETAILS cgd on a.ID=cgd.CHALLAN_ID "
			+ " where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? ## "
			+ " and a.STATUS='APPROVED' and(a.TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ " a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)) "
			+ " group by datepart(month,dateadd(mi,0,a.INSERTED_DATETIME)),datepart(year,dateadd(mi,0,a.INSERTED_DATETIME))";

	public static final String GET_LATEST_7DAYS_PRODUCTION = "select sum(isnull(a.PRODUCTION_QTY,0))as PRODUCTION_QTY,a.DATE,DATEDIFF(dd,a.DATE,'2017-05-08')as DAY from MINING.dbo.PRODUCTION_DETAILS a "
			+ " where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? and DATEADD(dd,0,a.DATE) between  DATEADD(dd, -7, ?) and DATEADD(dd, -1, ?) "
			+ " and(a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "
			+ " a.ORG_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)) group by a.DATE";

	public static final String UPDATE_STATUS_FOR_SUB_ROUTE = " update MINING.dbo.ROUTE_DETAILS set STATUS=?,REMARK=?,ACTIVE_INACTIVE_BY=?,ACTIVE_INACTIVE_DT=getdate() where ID=? ";

	public static final String MOVE_DATA_TO_HISTORY = "insert into MINING.dbo.ROUTE_TRIP_LIMIT_HISTORY (ID,ROUTE_ID,FROM_TIME,TO_TIME,TRIPSHEET_LIMIT,INSERTED_BY,INSERTED_DATETIME)(select ID,ROUTE_ID,FROM_TIME,TO_TIME,TRIPSHEET_LIMIT,?,getdate() from MINING.dbo.ROUTE_TRIP_LIMIT_DETAILS where ID=?) ";

	public static final String DELETE_TIME_DETAILS = " delete from MINING.dbo.ROUTE_TRIP_LIMIT_DETAILS where ID=? ";

	public static final String UPDATE_TOTAL_TRIP_LIMIT = " update MINING.dbo.ROUTE_DETAILS set TOTAL_TRIPSHEET_COUNT=? where ID=? ";

	public static final String INSERT_INTO_ROUTE_TRIP_LIMIT = "insert into MINING.dbo.ROUTE_TRIP_LIMIT_DETAILS (ROUTE_ID,FROM_TIME,TO_TIME,TRIPSHEET_LIMIT)values(?,?,?,?)";

	public static final String GET_UNIQUE_ID_FROM_ROUTE_DETAILS = " Select ID from MINING.dbo.ROUTE_DETAILS where ROUTE_NAME=? and CUSTOMER_ID=? and SYSTEM_ID=?";

	public static final String GET_MOTHER_ROUTE = " select mr.ID,NAME as MOTHER_ROUTE_NAME,isnull(TRIP_SHEET_LIMIT,0) as MOTHER_ROUTE_TS_LIMIT,isnull(sum(TOTAL_TRIPSHEET_COUNT),0) as TOTAL_COUNT "
			+ " from MINING.dbo.MOTHER_ROUTE_MASTER mr "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.MOTHER_ROUTE_ID=mr.ID && "
			+ " where mr.SYSTEM_ID=? and mr.CUSTOMER_ID=? and mr.STATUS='Active' "
			+ " group by mr.ID,NAME,TRIP_SHEET_LIMIT ";

	public static final String GET_ROUTE_TIME_DETAILS = " select * from MINING.dbo.ROUTE_TRIP_LIMIT_DETAILS where ROUTE_ID=? order by ID desc ";

	public static final String CHECK_ROUTE_TS_LIMIT = " select DATENAME(weekday,GETDATE()) as  DAY,*,(case when CONVERT(VARCHAR(8), getdate(), 108) between FROM_TIME and TO_TIME  "
			+ " then  (select sum(r.count) from ( "
			+ " select count(*) as count from MINING.dbo.TRUCK_TRIP_DETAILS a where  "
			+ " SYSTEM_ID=? AND CUSTOMER_ID=? and ROUTE_ID=?  " + " and a.STATUS!='Cancelled' "
			+ " and INSERTED_TIME between dateadd(mi,-330,convert(varchar(10), getdate(),120)+' '+FROM_TIME)  "
			+ " and dateadd(mi,-330,convert(varchar(10), getdate(),120)+' '+TO_TIME) " + " union all  "
			+ " select count(*) as count from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY a where  "
			+ " SYSTEM_ID=? AND CUSTOMER_ID=? and ROUTE_ID=?  " + " and a.STATUS!='Cancelled' "
			+ " and INSERTED_TIME between dateadd(mi,-330,convert(varchar(10), getdate(),120)+' '+FROM_TIME)  "
			+ " and dateadd(mi,-330,convert(varchar(10), getdate(),120)+' '+TO_TIME)) r ) " + " else '0' "
			+ " end) as TRIPSHEET_COUNT,1 as REF_ID " + " from MINING.dbo.ROUTE_TRIP_LIMIT_DETAILS rl "
			+ " inner join MINING.dbo.ROUTE_DETAILS rm on rl.ROUTE_ID=rm.ID "
			+ " where ROUTE_ID=?  and rm.STATUS='Active' "
			+ " and CONVERT(VARCHAR(8), getdate(), 108) between FROM_TIME and TO_TIME ";

	public static final String GET_ALERT_DETAILS = " select TYPE_OF_ALERT from Alert where SYSTEM_ID=? and TYPE_OF_ALERT in (154) and GMT between "
			+ " dateadd(mi,-?,getutcdate()) and getutcdate() and REGISTRATION_NO=? ";

	public static final String GET_ROUTE_DENSITY_REPORT = " select isnull(mrm.STATUS,'') as M_STATUS,isnull(rd.STATUS,'') as STATUS,isnull(mrm.NAME,'') as MOTHER_R_NAME,rd.ID,om.ORGANIZATION_NAME,rd.ROUTE_NAME, "
			+ " (select count(*) from MINING.dbo.TRUCK_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ROUTE_ID=rd.ID and STATUS='OPEN') as TRIP_COUNT "
			+ " from MINING.dbo.ROUTE_DETAILS rd "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER om on om.ID=rd.ORG_ID "
			+ " left outer join MINING.dbo.MOTHER_ROUTE_MASTER mrm on mrm.ID=rd.MOTHER_ROUTE_ID "
			+ " where rd.SYSTEM_ID=? and rd.CUSTOMER_ID=? and rd.ORG_ID in  "
			+ " (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=rd.SYSTEM_ID) ";

	public static final String GET_ROUTE_TRIP_DETAILS = " select isnull(dateadd(mi,330,a.INSERTED_TIME),'') as ISSUE_DATE,TRIP_NO,ASSET_NUMBER,(QUANTITY-QUANTITY1) as QUANTITY,rd.ROUTE_NAME from MINING.dbo.TRUCK_TRIP_DETAILS a "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.ROUTE_ID=? and a.STATUS='OPEN' "
			+ " and(a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) "
			+ " or a.ORGANIZATION_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID)) ";

	public static final String GET_WALLET_RECONCILIATION_REPORT = " select isnull(QUANTITY,0) as QUANTITY,isnull((case when TYPE='CREDIT' then AMOUNT ELSE 0 end ),0) as CREDIT_AMOUNT, "
			+ " isnull((case when TYPE='DEBIT' then AMOUNT ELSE 0 end ),0) as  "
			+ " DEBIT_AMOUNT,ORGANIZATION_NAME,INSERTED_DATETIME,r.NUMBER,isnull(RATE,0) as RATE,AMOUNT,TYPE from "
			+ " (select 0 as QUANTITY,c.ORGANIZATION_NAME,a.CHALLAN_DATETIME as INSERTED_DATETIME,CHALLAN_NO as NUMBER,0 as RATE,TOTAL as AMOUNT,'CREDIT' as TYPE "
			+ " from AMS.dbo.MINING_CHALLAN_DETAILS a "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER c on c.ID=a.ORGANIZATION_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.ORGANIZATION_ID=?  " + " union all "
			+ " select b.QUANTITY,(case when e.ORGANIZATION_NAME is null then c.ORGANIZATION_NAME else e.ORGANIZATION_NAME end ) "
			+ " as ORGANIZATION_NAME,a.INSERTED_DATETIME,PERMIT_NO as NUMBER,PROCESSING_FEE as RATE,TOTAL_PROCESSING_FEE as AMOUNT, "
			+ " 'DEBIT' as TYPE " + " from AMS.dbo.MINING_PERMIT_DETAILS a "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS b on a.ID=b.PERMIT_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER c on c.ID=a.ORGANIZATION_CODE "
			+ " left outer join AMS.dbo.MINING_TC_MASTER d on d.ID=a.TC_ID "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=d.MINE_ID "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS!='CANCEL' and a.ORGANIZATION_CODE=? or a.TC_ID in (select a1.ID from AMS.dbo.MINING_TC_MASTER a1  "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER b1 on b1.ID=a1.MINE_ID and a1.SYSTEM_ID=b1.SYSTEM_ID  "
			+ " and a1.CUSTOMER_ID=b1.CUSTOMER_ID  where b1.ORG_ID=?) " + " ) r order by r.INSERTED_DATETIME ";

	public static final String GET_DMF_FIELD_VALUES = "select * from AMS.dbo.LOOKUP_DETAILS where VERTICAL='MINING_SOLUTION' and TYPE='DMFFIELDVALUE' ";

	public static final String GET_DMF = "select isnull((select sum (DMF_SOUTH) from MINING.dbo.DMF_DETAILS where SYSTEM_ID=r.SYSTEM_ID ),0) as DMF_SOUTH, "
			+ " isnull((select sum (DMF_NORTH) from MINING.dbo.DMF_DETAILS where SYSTEM_ID=r.SYSTEM_ID ),0) as DMF_NORTH, "
			+ " isnull(sum(NORTH_ROYALTY),0) as NORTH_ROYALTY,isnull(sum(SOUTH_ROYALTY),0) as SOUTH_ROYALTY ,isnull(sum(TOTAL_ROYALTY),0) as TOTAL_ROYALTY from  "
			+ " (select a.FINANCIAL_YEAR ,tc.DISTRICT,a.SYSTEM_ID,  "
			+ " (select isnull(sum(isnull(PAYABLE,0)),0) as ROYALTY from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.ID) as TOTAL_ROYALTY, "
			+ " (select isnull(sum(isnull(PAYABLE,0)),0) as ROYALTY from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.ID and tc.DISTRICT=1) as NORTH_ROYALTY, "
			+ " (select isnull(sum(isnull(PAYABLE,0)),0) as ROYALTY from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.ID and tc.DISTRICT=2) as SOUTH_ROYALTY "
			+ " from AMS.dbo.MINING_CHALLAN_DETAILS a "
			+ " left outer join AMS.dbo.MINING_TC_MASTER tc on tc.ID=a.TC_NO and a.CUSTOMER_ID=tc.CUSTOMER_ID and a.SYSTEM_ID=tc.SYSTEM_ID  "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER mm on mm.ID=tc.MINE_ID and tc.CUSTOMER_ID=mm.CUSTOMER_ID  "
			+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=?  and CHALLAN_TYPE!='Processing Fee'  "
			+ " and (a.TC_NO in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0)))r  "
			+ " group by r.SYSTEM_ID ";

	public static final String GET_DMF_DETAILS = " select isnull(TOTAL_DMF,0) as TOTAL_DMF,TOTAL_NORTH_DMF,TOTAL_SOUTH_DMF,DATE,TYPE,DMF_SOUTH,DMF_NORTH from MINING.dbo.DMF_DETAILS a where "
			+ " SYSTEM_ID=? AND CUSTOMER_ID=? and DATE between ? and ? " + " order by DATE desc ";

	public static final String INSERT_INTO_DMF_DETAILS = " insert into MINING.dbo.DMF_DETAILS(DATE,TYPE,DMF_SOUTH,DMF_NORTH,TOTAL_NORTH_DMF,TOTAL_SOUTH_DMF,TOTAL_DMF,SYSTEM_ID,CUSTOMER_ID,INSERTED_DATETIME,INSERTED_BY) "
			+ " values(?,?,?,?,?,?,?,?,?,getdate(),?) ";

	public static final String GET_DMF_DETAILS_FOR_DASHBOARD = " select ROW_NUMBER() OVER (ORDER BY VALUE) AS F_TYPE,ld.VALUE,isnull(sum(DMF_SOUTH),0) as SOUTH_DMF,isnull(sum(DMF_NORTH),0) as NORTH_DMF,isnull(sum(DMF_NORTH+DMF_SOUTH),0) as TOTAL_DMF from AMS.dbo.LOOKUP_DETAILS ld "
			+ " left outer join MINING.dbo.DMF_DETAILS a on ld.VALUE=a.TYPE collate database_default and SYSTEM_ID=? "
			+ " where VERTICAL='MINING_SOLUTION' and ld.TYPE='DMFFIELDVALUE' "
			+ " group by ld.VALUE order by VALUE asc ";

	public static final String GET_STOCK_RECONCILIATION_REPORT = " select mpd.INSERTED_DATETIME,dateadd(mi,330,mpd.INSERTED_DATETIME) as INSERTED_DATETIME,popd.TYPE as GRADE_TYPE, "
			+ " (case when mpd.STATUS='APPROVED' then popd.QUANTITY when mpd.STATUS='CLOSE' then mpd.TRIPSHEET_QTY/1000 else 0 end) as OUTGOING_QTY,0 as INCOMING_QTY, "
			+ " isnull(d.NAME,'') as SOURCE,isnull(e.NAME,'') as DESTINATION,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME,om.ORGANIZATION_NAME,  "
			+ " isnull(om1.ORGANIZATION_NAME,'') as BUYING_ORG_NAME,PERMIT_NO,PERMIT_TYPE,mpd.STATUS, popd.QUANTITY as PERMIT_QUANTITY from  "
			+ " AMS.dbo.MINING_PERMIT_DETAILS mpd "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=mpd.ROUTE_ID "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd on popd.PERMIT_ID=mpd.ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER om on om.ID=mpd.ORGANIZATION_CODE "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER om1 on om1.ID=mpd.BUYING_ORG_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A c on c.SYSTEMID=rd.SYSTEM_ID and c.CLIENTID=rd.CUSTOMER_ID and c.HUBID=mpd.ROUTE_ID  "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A d on d.SYSTEMID=rd.SYSTEM_ID and d.CLIENTID=rd.CUSTOMER_ID and d.HUBID=rd.SOURCE_HUB_ID  "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A e on e.SYSTEMID=rd.SYSTEM_ID and e.CLIENTID=rd.CUSTOMER_ID and e.HUBID=rd.DESTINATION_HUB_ID "
			+ " where mpd.SYSTEM_ID=? and mpd.CUSTOMER_ID=? and MINERAL=? and mpd.ORGANIZATION_CODE=?  "
			+ " and (mpd.ROUTE_ID=? or rd.SOURCE_HUB_ID=?) " + " union all "
			+ " select mpd.INSERTED_DATETIME,dateadd(mi,330,mpd.INSERTED_DATETIME) as INSERTED_DATETIME,popd.TYPE as GRADE_TYPE,0 as OUTGOING_QTY,mpd.TRIPSHEET_QTY/1000 as INCOMING_QTY, "
			+ " isnull(d.NAME,'') as SOURCE,isnull(e.NAME,'') as DESTINATION,isnull(rd.ROUTE_NAME,'') as ROUTE_NAME,om.ORGANIZATION_NAME,  "
			+ " isnull(om1.ORGANIZATION_NAME,'') as BUYING_ORG_NAME,PERMIT_NO,PERMIT_TYPE,mpd.STATUS, popd.QUANTITY as PERMIT_QUANTITY from  "
			+ " AMS.dbo.MINING_PERMIT_DETAILS mpd "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=mpd.ROUTE_ID "
			+ " left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd on popd.PERMIT_ID=mpd.ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER om on om.ID=mpd.ORGANIZATION_CODE "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER om1 on om1.ID=mpd.BUYING_ORG_ID "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A c on c.SYSTEMID=rd.SYSTEM_ID and c.CLIENTID=rd.CUSTOMER_ID and c.HUBID=mpd.ROUTE_ID  "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A d on d.SYSTEMID=rd.SYSTEM_ID and d.CLIENTID=rd.CUSTOMER_ID and d.HUBID=rd.SOURCE_HUB_ID  "
			+ " left outer join AMS.dbo.LOCATION_ZONE_A e on e.SYSTEMID=rd.SYSTEM_ID and e.CLIENTID=rd.CUSTOMER_ID and e.HUBID=rd.DESTINATION_HUB_ID "
			+ " where mpd.SYSTEM_ID=? and mpd.CUSTOMER_ID=? and MINERAL=? and "
			+ " ((BUYING_ORG_ID=? and (mpd.ROUTE_ID=? or (rd.DESTINATION_HUB_ID=? and isnull(rd.DESTINATION_HUB_ID,0)!=isnull(rd.SOURCE_HUB_ID,0)))) or "
			+ " (mpd.ORGANIZATION_CODE=? and rd.DESTINATION_HUB_ID=? and isnull(rd.DESTINATION_HUB_ID,0)!=isnull(rd.SOURCE_HUB_ID,0))) "
			+

			" order by mpd.INSERTED_DATETIME ";

	public static final String GET_VEHICLE_LIST_FOR_VEHICLE_ALERT_STATUS = " select TYPE_OF_ALERT,dateadd(mi,330,GMT) as GMT from Alert a"
			+ " left outer join MINING.dbo.TRIP_SHEET_TIMINGS ts on ts.SYSTEM_ID=a.SYSTEM_ID"
			+ " where a.SYSTEM_ID=? and TYPE_OF_ALERT in (7,85,154) and GMT between"
			+ " dateadd(mi,-NON_COMM_HRS,getutcdate()) and getutcdate() and REGISTRATION_NO=?" + " union all"
			+ " select top 1 2 as TYPE_OF_ALERT,dateadd(mi,330,GMT) as GMT from ALERT.dbo.OVER_SPEED_DATA a"
			+ " left outer join MINING.dbo.TRIP_SHEET_TIMINGS ts on ts.SYSTEM_ID=a.SYSTEM_ID"
			+ " where a.SYSTEM_ID=? and GMT between"
			+ " dateadd(mi,-NON_COMM_HRS,getutcdate()) and getutcdate() and REGISTRATION_NO=? order by GMT desc ";

	public static final String GET_BARGE_STATUS = "select top 1 ASSET_NUMBER from MINING.dbo.BARGE_TRIP_DETAILS where SYSTEM_ID=? "
			+ " and CUSTOMER_ID=? and ISSUED_BY=? and STATUS in ('OPEN') order by INSERTED_TIME desc ";

	public static final String GET_BARGE_STATUS_FOR_START_BLO = "select top 1 ASSET_NUMBER from MINING.dbo.BARGE_TRIP_DETAILS where SYSTEM_ID=? "
			+ " and CUSTOMER_ID=? and STATUS in ('Start BLO') and ASSET_NUMBER=? order by INSERTED_TIME desc";

	public static final String GET_DETAILS_FROM_MINING_PERMIT_DETAILS = "select BUYING_ORG_ID,EXISTING_PERMIT_ID from AMS.dbo.MINING_PERMIT_DETAILS Where ID=? ";

	public static final String UPDATE_STATUS_FOR_PRSTP_AS_APPROVE_PERMIT = " update AMS.dbo.MINING_PERMIT_DETAILS set STATUS='APPROVED' where ID=? ";

	public static final String UPDATE_TRIPSHEET_QTY_FOR_PERMIT_CLOSURE = " update AMS.dbo.MINING_PERMIT_DETAILS set TRIPSHEET_QTY=0 where ID=? ";

	public static final String GET_RESTRICTIVE_HOURS_TRIP_DETAILS = "select isnull(a.ASSET_NUMBER,'') as VEHICLE_NO,isnull(a.TRIP_NO,'') as TRIP_NO, isnull(dateadd(mi,?,a.INSERTED_TIME),'') as INSERTED_TIME,isnull(dateadd(mi,?,a.VALIDITY_DATE),'')as VALIDITY_DATE, isnull(rd.ROUTE_NAME,'')as ROUTE_NAME, "
			+ " (CASE WHEN mom.ORGANIZATION_NAME IS  NULL THEN e.ORGANIZATION_NAME  ELSE isnull(mom.ORGANIZATION_NAME,'') END ) as ORG_NAME  "
			+ " from MINING.dbo.TRUCK_TRIP_DETAILS a  "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mom on mom.ID=a.ORGANIZATION_ID "
			+ " left outer join AMS.dbo.MINING_TC_MASTER d on a.TC_ID=d.ID and a.SYSTEM_ID=d.SYSTEM_ID and a.CUSTOMER_ID=d.CUSTOMER_ID "
			+ " left outer join AMS.dbo.MINE_OWNER_MASTER b on d.SYSTEM_ID=b.SYSTEM_ID and d.CUSTOMER_ID=b.CUSTOMER_ID  and d.TC_NO=b.TC_NO "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=d.MINE_ID and e.SYSTEM_ID=d.SYSTEM_ID and e.CUSTOMER_ID=d.CUSTOMER_ID "
			+ " left outer join MINING.dbo.TRIP_SHEET_TIMINGS tst on tst.SYSTEM_ID=? and tst.CUSTOMER_ID=? "
			+ " where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and ( a.INSERTED_TIME between (dateadd(mi,-?,?+' '+tst.FIRST_RESTRICTIVE_START_TIME+':00')) and (dateadd(mi,-?,?+' '+tst.FIRST_RESTRICTIVE_END_TIME+':00')) "
			+ " or a.INSERTED_TIME between (dateadd(mi,-?,?+' '+tst.SECOND_RESTRICTIVE_START_TIME+':00')) "
			+ " and (dateadd(mi,-?,?+' '+tst.SECOND_RESTRICTIVE_END_TIME+':00')))" + " UNION  "
			+ " select isnull(a.ASSET_NUMBER,'') as VEHICLE_NO,isnull(a.TRIP_NO,'') as TRIP_NO, isnull(dateadd(mi,?,a.INSERTED_TIME),'') as INSERTED_TIME,isnull(dateadd(mi,?,a.VALIDITY_DATE),'')as VALIDITY_DATE, isnull(rd.ROUTE_NAME,'')as ROUTE_NAME, "
			+ " (CASE WHEN mom.ORGANIZATION_NAME IS  NULL THEN e.ORGANIZATION_NAME  ELSE isnull(mom.ORGANIZATION_NAME,'') END ) as ORG_NAME "
			+ " from MINING.dbo.TRUCK_TRIP_DETAILS_HISTORY a "
			+ " left outer join MINING.dbo.ROUTE_DETAILS rd on rd.ID=a.ROUTE_ID "
			+ " left outer join AMS.dbo.MINING_ORGANIZATION_MASTER mom on mom.ID=a.ORGANIZATION_ID "
			+ " left outer join AMS.dbo.MINING_TC_MASTER d on a.TC_ID=d.ID and a.SYSTEM_ID=d.SYSTEM_ID and a.CUSTOMER_ID=d.CUSTOMER_ID  "
			+ " left outer join AMS.dbo.MINE_OWNER_MASTER b on d.SYSTEM_ID=b.SYSTEM_ID and d.CUSTOMER_ID=b.CUSTOMER_ID  and d.TC_NO=b.TC_NO  "
			+ " left outer join AMS.dbo.MINING_MINE_MASTER e on e.ID=d.MINE_ID and e.SYSTEM_ID=d.SYSTEM_ID and e.CUSTOMER_ID=d.CUSTOMER_ID  "
			+ " left outer join MINING.dbo.TRIP_SHEET_TIMINGS tst on tst.SYSTEM_ID=? and tst.CUSTOMER_ID=? "
			+ " where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and ( a.INSERTED_TIME between (dateadd(mi,-?,?+' '+tst.FIRST_RESTRICTIVE_START_TIME+':00')) and (dateadd(mi,-?,?+' '+tst.FIRST_RESTRICTIVE_END_TIME+':00')) "
			+ " or a.INSERTED_TIME between (dateadd(mi,-?,?+' '+tst.SECOND_RESTRICTIVE_START_TIME+':00')) "
			+ " and (dateadd(mi,-?,?+' '+tst.SECOND_RESTRICTIVE_END_TIME+':00'))) order by INSERTED_TIME desc ";

	public static final String GET_VALID_MONTH_FROM_DMF_DETAILS = "SELECT * FROM MINING.dbo.DMF_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and MONTH(DATE)=? and Year(DATE)=?";

	public static final String GET_PRODUCTION_BAL = "select isnull(PRODUCTION_MPL,0)-isnull(sum(PRODUCTION_QTY),0) as PRODUCTION_BAL FROM MINING.dbo.PRODUCTION_DETAILS pd "
			+ " left outer join AMS.dbo.MINING_TC_MASTER tc on tc.ID=pd.TC_ID "
			+ " WHERE pd.SYSTEM_ID=? AND pd.CUSTOMER_ID=? and  tc.ID=? " + " group by tc.ID,PRODUCTION_MPL";

	public static final String GET_CURRENT_LOC = " select  GPS_DATETIME,isnull(LOCATION,'') as LOCATION from AMS.dbo.gpsdata_history_latest(NOLOCK) where REGISTRATION_NO=? and System_id=? and CLIENTID=? ";

	public static final String UPDATE_STATUS_FOR_ENROLLMENT = " update AMS.dbo.MINING_ASSET_ENROLLMENT set TRIP_STATUS=? WHERE ASSET_NUMBER=? and SYSTEM_ID=?";

}
