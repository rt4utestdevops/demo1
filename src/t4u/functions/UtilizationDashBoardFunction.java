package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Formatter;

import org.json.JSONArray;
import org.json.JSONObject;


import t4u.common.DBConnection;

public class UtilizationDashBoardFunction {

	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");


	public static final String  GETVEHICLESCOUNT=" select  count(REGISTRATION_NO) as REGISTRATION_NO ,isnull(Status_id,16) as Status_id,COMMUNICATION_STATUS , MOVED_STATUS from   "+
	" (select a.REGISTRATION_NO,vs.Status_id ,   "+
	" case when a.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and ( getutcdate() )     "+
	" THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS COMMUNICATION_STATUS  , "+
	" case when uv.DISTANCE>=da.ALERT_DISTANCE_KM    Then 'Moved' ELSE 'Halted'  END AS MOVED_STATUS "+
	" from dbo.gpsdata_history_latest a   "+
	" left join  AMS.dbo.Vehicle_Status vs on vs.Vehicle_id=a.REGISTRATION_NO   "+
	" INNER JOIN AMS.dbo.DISTANCE_ALERT da on a.System_id=da.SYSTEM_ID and a.CLIENTID=da.CUSTOMER_ID   "+
	" left join AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = a.REGISTRATION_NO   "+
	" left join AMS.dbo.tblVehicleMaster tvm on tvm.VehicleNo = a.REGISTRATION_NO  "+
	" where a.System_id=?  and a.CLIENTID=? and tvm.Status = 'Active' "+
	" union    "+
	" select a.REGISTRATION_NO,vs.Status_id,   "+
	" case when a.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and ( getutcdate() )     "+
	" THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS COMMUNICATION_STATUS   , "+
    " case when uv.DISTANCE>=da.ALERT_DISTANCE_KM Then 'Moved' ELSE 'Halted'  END AS MOVED_STATUS "+
	" from dbo.gpsdata_history_latest a   "+
	" left join  AMS.dbo.Vehicle_Status vs on vs.Vehicle_id=a.REGISTRATION_NO   "+
	" INNER JOIN AMS.dbo.DISTANCE_ALERT da on a.System_id=da.SYSTEM_ID and a.CLIENTID=da.CUSTOMER_ID   "+
	" left join AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = a.REGISTRATION_NO   "+
	" left join AMS.dbo.tblVehicleMaster tvm on tvm.VehicleNo = a.REGISTRATION_NO "+
	" where a.System_id=?  and a.CLIENTID=?  and vs.Status_id is null and tvm.Status = 'Active'  "+
	" ) a   "+
	" group by Status_id,COMMUNICATION_STATUS,MOVED_STATUS  "+
	" order by Status_id   ";

	public static final String GETASSIGNEDVEHICLESCOUNT = "SELECT COUNT(ASSET_NUMBER) AS COUNT, COMMUNICATION_STATUS, MOVED_STATUS FROM "
			+ " (SELECT ttd.ASSET_NUMBER,case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS COMMUNICATION_STATUS,  case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS MOVED_STATUS  "
			+ " FROM AMS.dbo.TRACK_TRIP_DETAILS ttd "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO  "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id"
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND tvm.Status = 'Active' AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Maintenance Trip' @ $ **) A GROUP BY COMMUNICATION_STATUS,MOVED_STATUS ";
		
	public static final String GETUNASSIGNEDVEHICLESCOUNT = "SELECT COUNT(REGISTRATION_NO) AS COUNT, COMMUNICATION_STATUS, MOVED_STATUS FROM "
			+ " (SELECT ghl.REGISTRATION_NO,case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS COMMUNICATION_STATUS, "
			+ "  case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS MOVED_STATUS "
			+ "  FROM AMS.dbo.gpsdata_history_latest ghl  "
			+ "  INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ "  LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ "  LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ "  LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ "  WHERE ghl.System_id = ? AND ghl.CLIENTID= ? AND tvm.Status = 'Active' $ ** AND ghl.REGISTRATION_NO NOT IN ( "
			+ "  SELECT ttd.ASSET_NUMBER "
			+ "  FROM AMS.dbo.TRACK_TRIP_DETAILS ttd "
			+ "  LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ "  INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ "  LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ "  WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? "
			+ "  UNION  "
			+ "  SELECT mv.ASSET_NUMBER FROM AMS.[dbo].[MAINTENANCE_VEHICLES] mv WHERE mv.SYSTEM_ID = ? AND mv.CLIENT_ID = ? "
			+ "  )) A GROUP BY COMMUNICATION_STATUS,MOVED_STATUS";

	public static final String GETMAINTENANCEVEHICLESCOUNT = "SELECT COUNT(ASSET_NUMBER) AS COUNT, COMMUNICATION_STATUS, MOVED_STATUS FROM "
			+ " (SELECT ttd.ASSET_NUMBER,case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS COMMUNICATION_STATUS,  case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS MOVED_STATUS  "
			+ " FROM AMS.[dbo].[MAINTENANCE_VEHICLES] ttd "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CLIENT_ID "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID  "
			+ " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO  "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " WHERE ttd.SYSTEM_ID = ? AND ttd.CLIENT_ID = ? AND tvm.Status = 'Active' @ $ ** "
			+ " AND ttd.ASSET_NUMBER not in (SELECT ASSET_NUMBER FROM AMS.dbo.TRACK_TRIP_DETAILS WHERE STATUS = 'OPEN' AND SYSTEM_ID = 268 AND CUSTOMER_ID = 5560 ) "
			+ ") A GROUP BY COMMUNICATION_STATUS,MOVED_STATUS "
			+ " UNION ALL "
			+ " SELECT COUNT(ASSET_NUMBER) AS COUNT, COMMUNICATION_STATUS, MOVED_STATUS FROM "
			+ " (SELECT ttd.ASSET_NUMBER,case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS COMMUNICATION_STATUS,  case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS MOVED_STATUS  "
			+ " FROM AMS.dbo.TRACK_TRIP_DETAILS ttd "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO  "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id"
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND tvm.Status = 'Active' @ $ ** AND ttd.TRIP_CUSTOMER_TYPE  LIKE 'Maintenance Trip' ) A GROUP BY COMMUNICATION_STATUS,MOVED_STATUS " ;
	

	public static final String GET_VEHICLE_DETAILS=" select REGISTRATION_NO,ISNULL(TRIP_ID,0) AS TRIP_ID,isnull(Status_id,16) as Status_id ,LOCATION,isnull(SHIPMENT_ID,'NA') as SHIPMENT_ID, isnull(ACTUAL_DISTANCE,0) as ACTUAL_DISTANCE,isnull(Distance,0) as Distance,COMMUNICATION_STATUS , Gps_Tampering_Alert,LR_NO,MOVED_STATUS,UNASSIGNED_AGE  from "+
	" ( "+
	" select a.REGISTRATION_NO,td .TRIP_ID,vs.Status_id , a.LOCATION as LOCATION , td.SHIPMENT_ID as SHIPMENT_ID , "+
	" isnull(td.ACTUAL_DISTANCE,0)  as ACTUAL_DISTANCE ,isnull(uv.DISTANCE,0) as Distance , "+
	" case when a.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and ( getutcdate() )   "+
	" THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS COMMUNICATION_STATUS , "+
	" ( select count(REGISTRATION_NO) as Gps_Tampering_Alert from AMS.dbo.Alert where TYPE_OF_ALERT=145 and  REGISTRATION_NO= a.REGISTRATION_NO) as 'Gps_Tampering_Alert' ,isnull(td.ORDER_ID,'') as LR_NO , "+
	" case when uv.DISTANCE>=da.ALERT_DISTANCE_KM   Then 'Moved' ELSE 'Halted'  END AS MOVED_STATUS ,"+
	" case when ACTUAL_TRIP_END_TIME is null    Then 0 ELSE  datediff(minute ,dateadd(mi,?,ACTUAL_TRIP_END_TIME),getdate())    END AS UNASSIGNED_AGE  "+
	" from dbo.gpsdata_history_latest a "+
	" left join  AMS.dbo.Vehicle_Status vs on vs.Vehicle_id=a.REGISTRATION_NO "+
	" left join AMS.dbo.TRACK_TRIP_DETAILS  td on vs.Vehicle_id=td.ASSET_NUMBER  "+
	" left join AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = a.REGISTRATION_NO "+
	" left join AMS.dbo.tblVehicleMaster tvm on tvm.VehicleNo = a.REGISTRATION_NO  "+
	" INNER JOIN AMS.dbo.DISTANCE_ALERT da on a.System_id=da.SYSTEM_ID and a.CLIENTID=da.CUSTOMER_ID "+		
	" where a.System_id=? and a.CLIENTID=? and tvm.Status = 'Active' "+
	" and td.TRIP_ID in (select  max(TRIP_ID) from AMS.dbo.TRACK_TRIP_DETAILS group by ASSET_NUMBER ) "+
	" union "+
	" select a.REGISTRATION_NO,td .TRIP_ID,vs.Status_id , a.LOCATION as LOCATION , td.SHIPMENT_ID as SHIPMENT_ID , "+
	" isnull(td.ACTUAL_DISTANCE,0)  as ACTUAL_DISTANCE ,isnull(uv.DISTANCE,0) as Distance , "+
	" case when a.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and ( getutcdate() )   "+
	" THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS COMMUNICATION_STATUS , "+
	" ( select count(REGISTRATION_NO) as Gps_Tampering_Alert from AMS.dbo.Alert where TYPE_OF_ALERT=145 and  REGISTRATION_NO= a.REGISTRATION_NO) as 'Gps_Tampering_Alert'  ,isnull(td.ORDER_ID,'') as LR_NO , "+
	" case when uv.DISTANCE>=da.ALERT_DISTANCE_KM   Then 'Moved' ELSE 'Halted'  END AS MOVED_STATUS , "+
	" case when ACTUAL_TRIP_END_TIME is null    Then 0 ELSE  datediff(minute ,dateadd(mi,?,ACTUAL_TRIP_END_TIME),getdate())    END AS UNASSIGNED_AGE "+
	" from dbo.gpsdata_history_latest a "+
	" left join  AMS.dbo.Vehicle_Status vs on vs.Vehicle_id=a.REGISTRATION_NO "+
	" left join AMS.dbo.TRACK_TRIP_DETAILS  td on vs.Vehicle_id=td.ASSET_NUMBER  "+
	" left join AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = a.REGISTRATION_NO "+
	" left join AMS.dbo.tblVehicleMaster tvm on tvm.VehicleNo = a.REGISTRATION_NO  "+
	" INNER JOIN AMS.dbo.DISTANCE_ALERT da on a.System_id=da.SYSTEM_ID and a.CLIENTID=da.CUSTOMER_ID "+
	" where a.System_id=? and a.CLIENTID=? and vs.Status_id is null and tvm.Status = 'Active' "+
	" ) a # "+
	" order by Status_id  ";

	public static final String GET_ASSIGNED_VEHICLE_DETAILS = "SELECT CASE WHEN aa > 0 THEN aa ELSE 0 END AS 'ASSIGNED AGE',TRIP_ID AS 'TRIP ID',ASSET_NUMBER AS 'VEHICLE NO.',VEHICLE_CAT,VEHICLE_TYPE,CUSTOMER_NAME,oid AS 'TRIP NO.',ad AS 'ACTUAL DISTANCE',DISTANCE,cl AS 'CURRENT LOCATION',rid AS 'ROUTE ID',gtc AS 'GPS TAMPERING COUNT', cs AS 'COMMUNICATION STATUS', ms AS 'MOVEMENT STATUS',CURRENT_ODO AS 'CURRENT ODO',model AS 'MODEL NAME', hub AS 'HUB' FROM ("
			+ " SELECT datediff(minute ,dateadd(mi,?,TRIP_START_TIME),getdate()) AS aa, ttd.TRIP_ID ,ttd.PRODUCT_LINE ,  "
			+ " ttd.ASSET_NUMBER,ISNULL(ttd.CUSTOMER_NAME,'') AS CUSTOMER_NAME, ISNULL(ttd.ORDER_ID,'') AS oid,ISNULL(ttd.ACTUAL_DISTANCE,0)  AS ad,isnull(tvm.VehicleType,'') as VEHICLE_TYPE ,(select case when (tvm.VehicleType like '%DC%') then 'Dry' else 'TCL' end )as VEHICLE_CAT,ISNULL(uv.DISTANCE,0) AS DISTANCE , "
			+ " ghl.LOCATION AS cl,ttd.SHIPMENT_ID AS rid ,isnull(vm.ModelName,'') as model,isnull(vshd.HUB_NAME,'') as hub, "
			+ " (SELECT COUNT(REGISTRATION_NO) FROM AMS.dbo.Alert WHERE TYPE_OF_ALERT=145 AND  REGISTRATION_NO= ghl.REGISTRATION_NO) AS gtc , "
			+ " CASE WHEN ghl.GMT BETWEEN DATEADD(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) AND (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS cs, "
			+ " CASE WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS ms , CONCAT(ISNULL(odo.SRC_ZONE,'NA'),' - ',ISNULL(odo.DES_ZONE,'NA')) AS CURRENT_ODO ,ds1.PLANNED_ARR_DATETIME "
			+ " FROM AMS.dbo.TRACK_TRIP_DETAILS ttd  "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID  "
			+ " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ "  LEFT OUTER JOIN FMS.[dbo].[Vehicle_Model](nolock) vm ON ghl.System_id = vm.SystemId AND ghl.CLIENTID = vm.ClientId AND vm.ModelTypeId = tvm.Model " 
			+ "  LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS(nolock) vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " LEFT OUTER JOIN AMS.dbo.ODO_ROUTE_DETAILS odo(NOLOCK) on odo.RES_ID = ghl.REGISTRATION_NO "
			+ " LEFT OUTER JOIN AMS.dbo.DES_TRIP_DETAILS(nolock) ds1 on ds1.TRIP_ID=ttd.TRIP_ID and ds1.SEQUENCE=0 "
			+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND tvm.Status = 'Active' AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Maintenance Trip' @ $ **)a # ORDER BY aa DESC";


	public static final String GET_UNASSIGNED_VEHICLE_DETAILS = "SELECT ua AS 'UNASSIGNED AGE',REGISTRATION_NO AS 'VEHICLE NO.',VEHICLE_CAT,VEHICLE_TYPE,DISTANCE,cl AS 'CURRENT LOCATION',gtc AS 'GPS TAMPERING COUNT', cs AS 'COMMUNICATION STATUS', ms AS 'MOVEMENT STATUS', CURRENT_ODO AS 'CURRENT ODO',model AS 'MODEL NAME', hub AS 'HUB'  FROM "
			+ " (SELECT ISNULL(DATEDIFF(minute ,DATEADD(mi,?,(SELECT TOP 1 ACTUAL_TRIP_END_TIME FROM AMS.dbo.TRACK_TRIP_DETAILS(NOLOCK) WHERE ASSET_NUMBER = ghl.REGISTRATION_NO  order by ACTUAL_TRIP_END_TIME desc)),getdate()),0) AS ua, "
			+ " ghl.REGISTRATION_NO,isnull(tvm.VehicleType,'') as VEHICLE_TYPE ,(select case when (tvm.VehicleType like '%DC%') then 'Dry' else 'TCL' end )as VEHICLE_CAT, isnull(uv.DISTANCE,0) as DISTANCE , "
			+ " ghl.LOCATION as cl, "
			+ " (select count(REGISTRATION_NO) from AMS.dbo.Alert(NOLOCK) where TYPE_OF_ALERT=145 and  REGISTRATION_NO= ghl.REGISTRATION_NO) as gtc , "
			+ " case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS cs,isnull(vm.ModelName,'') as model,isnull(vshd.HUB_NAME,'') as hub, "
			+ " case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS ms, CONCAT(ISNULL(odo.SRC_ZONE,'NA'),' - ',ISNULL(odo.DES_ZONE,'NA')) AS CURRENT_ODO "
			+ " FROM AMS.dbo.gpsdata_history_latest ghl(NOLOCK)  "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT(NOLOCK) da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS(NOLOCK) uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ " LEFT OUTER JOIN FMS.[dbo].[Vehicle_Model](nolock) vm ON ghl.System_id = vm.SystemId AND ghl.CLIENTID = vm.ClientId AND vm.ModelTypeId = tvm.Model"
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd(NOLOCK) on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " LEFT OUTER JOIN AMS.dbo.ODO_ROUTE_DETAILS odo(NOLOCK) on odo.RES_ID = ghl.REGISTRATION_NO "
			+ " WHERE ghl.System_id = ? AND ghl.CLIENTID= ? AND tvm.Status = 'Active' $ ** AND ghl.REGISTRATION_NO NOT IN ( "
			+ " SELECT ttd.ASSET_NUMBER "
			+ " FROM AMS.dbo.TRACK_TRIP_DETAILS(NOLOCK) ttd "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? "
			+ " UNION  "
			+ " SELECT mv.ASSET_NUMBER FROM AMS.[dbo].[MAINTENANCE_VEHICLES](NOLOCK) mv WHERE mv.SYSTEM_ID = ? AND mv.CLIENT_ID = ? )) a # ORDER BY ua DESC";

	public static final String GET_MAINTENANCE_VEHICLE_DETAILS = " SELECT * FROM ( SELECT CASE WHEN ma > 0 THEN ma ELSE 0 END AS 'MAINTENANCE AGE', ASSET_NUMBER AS 'VEHICLE NO', DISTANCE, VEHICLE_CAT, VEHICLE_TYPE, cl AS 'CURRENT LOCATION', cs AS 'COMMUNICATION STATUS', ms AS 'MOVEMENT STATUS' ,CURRENT_ODO AS 'CURRENT ODO',model AS 'MODEL NAME', hub AS 'HUB' FROM "
			+ "(SELECT mv.ASSET_NUMBER, "
			+ "ISNULL(DATEDIFF(minute ,DATEADD(mi,?,(mv.START_DATE)),getdate()),0) AS ma, "
			+ "case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS cs,isnull(vm.ModelName,'') as model,isnull(vshd.HUB_NAME,'') as hub, "
			+ "case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS ms, "
			+ "ghl.LOCATION as cl,isnull(tvm.VehicleType,'') as VEHICLE_TYPE ,(select case when (tvm.VehicleType like '%DC%') then 'Dry' else 'TCL' end )as VEHICLE_CAT, "
			+ "isnull(uv.DISTANCE,0) as DISTANCE ,CONCAT(ISNULL(odo.SRC_ZONE,'NA'),' - ',ISNULL(odo.DES_ZONE,'NA')) AS CURRENT_ODO "
			+ "FROM AMS.[dbo].[MAINTENANCE_VEHICLES] mv(NOLOCK) "
			+ "INNER JOIN AMS.dbo.gpsdata_history_latest ghl(NOLOCK) ON ghl.System_id=mv.SYSTEM_ID and ghl.CLIENTID=mv.CLIENT_ID and ghl.REGISTRATION_NO = mv.ASSET_NUMBER "
			+ "INNER JOIN AMS.dbo.DISTANCE_ALERT(NOLOCK) da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ "LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO  "
			+ "LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ " LEFT OUTER JOIN FMS.[dbo].[Vehicle_Model](nolock) vm ON ghl.System_id = vm.SystemId AND ghl.CLIENTID = vm.ClientId AND vm.ModelTypeId = tvm.Model"
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " LEFT OUTER JOIN AMS.dbo.ODO_ROUTE_DETAILS odo(NOLOCK) on odo.RES_ID = ghl.REGISTRATION_NO  "
			+ "WHERE mv.SYSTEM_ID = ? AND mv.CLIENT_ID = ? AND tvm.Status = 'Active' @ $ ** "
			+ " AND mv.ASSET_NUMBER not in (SELECT ASSET_NUMBER FROM AMS.dbo.TRACK_TRIP_DETAILS WHERE STATUS = 'OPEN' AND SYSTEM_ID = 268 AND CUSTOMER_ID = 5560 )"
			+ ") a # "
			+ " UNION ALL " 
			+ " SELECT CASE WHEN ma > 0 THEN ma ELSE 0 END AS 'MAINTENANCE AGE',ASSET_NUMBER AS 'VEHICLE NO',DISTANCE,VEHICLE_CAT,VEHICLE_TYPE,cl AS 'CURRENT LOCATION', cs AS 'COMMUNICATION STATUS', ms AS 'MOVEMENT STATUS',CURRENT_ODO AS 'CURRENT ODO',model AS 'MODEL NAME', hub AS 'HUB' FROM " 
			+ "( SELECT datediff(minute ,dateadd(mi,?,TRIP_START_TIME),getdate()) AS ma, "
            + " ttd.ASSET_NUMBER, ISNULL(uv.DISTANCE,0) AS DISTANCE , isnull(tvm.VehicleType,'') as VEHICLE_TYPE ,(select case when (tvm.VehicleType like '%DC%') then 'Dry' else 'TCL' end )as VEHICLE_CAT, "
            + " ghl.LOCATION AS cl, CASE WHEN ghl.GMT BETWEEN DATEADD(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) AND (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS cs,isnull(vm.ModelName,'') as model,isnull(vshd.HUB_NAME,'') as hub, "
            + " CASE WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS ms , CONCAT(ISNULL(odo.SRC_ZONE,'NA'),' - ',ISNULL(odo.DES_ZONE,'NA')) AS CURRENT_ODO ,ds1.PLANNED_ARR_DATETIME "
            + " FROM AMS.dbo.TRACK_TRIP_DETAILS ttd " 
            + " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
            + " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
            + " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
            + " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
            + " LEFT OUTER JOIN FMS.[dbo].[Vehicle_Model](nolock) vm ON ghl.System_id = vm.SystemId AND ghl.CLIENTID = vm.ClientId AND vm.ModelTypeId = tvm.Model"
            + " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
            + " LEFT OUTER JOIN AMS.dbo.ODO_ROUTE_DETAILS odo(NOLOCK) on odo.RES_ID = ghl.REGISTRATION_NO "
            + " LEFT OUTER JOIN AMS.dbo.DES_TRIP_DETAILS(nolock) ds1 on ds1.TRIP_ID=ttd.TRIP_ID and ds1.SEQUENCE=0 "
            + " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND tvm.Status = 'Active' @ $ ** $$ AND ttd.TRIP_CUSTOMER_TYPE LIKE 'Maintenance Trip')a # "
            + " )b  order by 'MAINTENANCE AGE' desc " ;

	public static final String GET_DRIVER_DETAILS=" select  isnull(a.Fullname,'NA') as DriverName , isnull(Mobile,0)  as Mobile   "+
	" from AMS.dbo.Driver_Master a  "+
	" INNER JOIN   AMS.dbo.TRIP_LEG_DETAILS b on a.Driver_id=b.DRIVER_1 or a.Driver_id=b.DRIVER_2  "+
	" INNER   join AMS.dbo.TRACK_TRIP_DETAILS c on b.TRIP_ID=c.TRIP_ID  "+
	" where c.SYSTEM_ID=?  and c.CUSTOMER_ID=?  and b.TRIP_ID=?   " ;


	public static final String GET_MAP_DETAILS=" select isnull(ORDER_ID,'') as LR_NO,isnull(td.SHIPMENT_ID,'') as TRIP_NO,isnull(td.ROUTE_NAME,0) as ROUTE_NAME,isnull(ANALOG_INPUT_1,'99999') as Humidity ,isnull(r.IO_VALUE,'NA') as T1,isnull(r1.IO_VALUE,'NA') as T2,isnull(r2.IO_VALUE,'NA') as T3,isnull(td.PRODUCT_LINE,0) as PRODUCT_LINE,isnull(td.ROUTE_ID,0) as ROUTE_ID,isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as STD,isnull(td.TRIP_ID,0) as TRIP_ID,isnull(td.STATUS,'') as STATUS,  "+
	"  isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,isnull(gps.DRIVER_NAME,'') as DRIVER_NAME,isnull(DELAY,0) as DELAY,  "+
	"  ISNULL(td.CUSTOMER_NAME,'') as CUSTOMER_NAME,td.SHIPMENT_ID,td.TRIP_STATUS,td.ASSET_NUMBER as ASSET_NUMBER,isnull(gps.LATITUDE,0) as LATITUDE,isnull(gps.LONGITUDE,0) as LONGITUDE,  "+
	"  isnull(gps.LOCATION,'') as LOCATION,isnull(dateadd(mi,?,gps.GMT),'') as GMT,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as ATD,   "+
	"  (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as endDate,   "+
	"  case when gps.CATEGORY='stoppage' then DURATION else 0 end as STOPPAGE_TIME,case when gps.CATEGORY='idle' then DURATION else 0 end as IDLE_TIME,   "+
	"  isnull(gps.SPEED,0) as SPEED  , "+
	"  case when gps.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and ( getutcdate() )   "+
	"  THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS COMMUNICATION_STATUS , "+
	"  case when uv.DISTANCE>=da.ALERT_DISTANCE_KM   Then 'Moved' ELSE 'Halted'  END AS MOVED_STATUS "+
	"  from AMS.dbo.TRACK_TRIP_DETAILS td   "+
	"  inner join AMS.dbo.DES_TRIP_DETAILS dt on td.TRIP_ID=dt.TRIP_ID   "+
	"  inner join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID   "+
	"  left outer join AMS.dbo.RS232_LIVE r on r.REGISTRATION_NO=td.ASSET_NUMBER and r.IO_CATEGORY in ('TEMPERATURE1')    "+
	"  left outer join AMS.dbo.RS232_LIVE r1 on r1.REGISTRATION_NO=td.ASSET_NUMBER and r1.IO_CATEGORY in ('TEMPERATURE2')   "+
	"  left outer join AMS.dbo.RS232_LIVE r2 on r2.REGISTRATION_NO=td.ASSET_NUMBER and r2.IO_CATEGORY in ('TEMPERATURE3')   "+
	"  left outer join  AMS.dbo.Vehicle_Status vs on vs.Vehicle_id=gps.REGISTRATION_NO "+
	"  INNER JOIN AMS.dbo.DISTANCE_ALERT da on gps.System_id=da.SYSTEM_ID and gps.CLIENTID=da.CUSTOMER_ID "+
	"  left join AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = gps.REGISTRATION_NO  "+
	" left join AMS.dbo.tblVehicleMaster tvm on tvm.VehicleNo = gps.REGISTRATION_NO  "+
	"  where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and SEQUENCE=100 and tvm.Status = 'Active' "+
	"  and td.TRIP_ID in (select  max(TRIP_ID) from AMS.dbo.TRACK_TRIP_DETAILS group by ASSET_NUMBER ) # ";
	
	public static final String GET_ASSIGNED_MAP_DETAILS = "SELECT trip_no AS 'TRIP NO', rName AS 'ROUTE NAME', humidity AS 'HUMIDITY', ISNULL(T1,'NA') AS T1, ISNULL(T2,'NA') AS T2, ISNULL(T3,'NA') AS T3, pLine AS 'PRODUCT LINE', rId as 'ROUTE ID',STD,tripId AS 'TRIP ID'," 
		+ "  STATUS,ETHA,ETA,dName AS 'DRIVER NAME', DELAY,custName AS 'CUSTOMER NAME', tripStatus AS 'TRIP STATUS', vehicleNo AS 'VEHICLE NO',LATITUDE, LONGITUDE, LOCATION,"  
		+ "  GMT, ATD, endDate,sTime AS 'STOPPAGE TIME', iTime AS 'IDLE TIME', SPEED, cs AS 'COMMUNICATION STATUS', ms AS 'MOVEMENT STATUS'," 
		+ "  CASE WHEN aa > 0 THEN aa ELSE 0 END AS 'ASSIGNED TIME'" 
		+ "  FROM "
		+ "  (SELECT datediff(minute ,dateadd(mi,?,TRIP_START_TIME),getdate()) AS aa,isnull(ttd.ORDER_ID,'') as trip_no,isnull(ttd.ROUTE_NAME,0) as rName,isnull(ANALOG_INPUT_1,'99999') as humidity , "
		+ "  (SELECT TOP 1 IO_VALUE FROM AMS.dbo.RS232_LIVE WHERE IO_CATEGORY = 'TEMPERATURE1' AND REGISTRATION_NO = ttd.ASSET_NUMBER ORDER BY GMT DESC) as T1, "
		+ "  (SELECT TOP 1 IO_VALUE FROM AMS.dbo.RS232_LIVE WHERE IO_CATEGORY = 'TEMPERATURE2' AND REGISTRATION_NO = ttd.ASSET_NUMBER ORDER BY GMT DESC) as T2, "
		+ "  (SELECT TOP 1 IO_VALUE FROM AMS.dbo.RS232_LIVE WHERE IO_CATEGORY = 'TEMPERATURE3' AND REGISTRATION_NO = ttd.ASSET_NUMBER ORDER BY GMT DESC) as T3, "
		+ "  isnull(ttd.PRODUCT_LINE,0) as pLine,isnull(ttd.ROUTE_ID,0) as rId,isnull(dateadd(mi,?,ttd.TRIP_START_TIME),'') as STD,isnull(ttd.TRIP_ID,0) as tripId,isnull(ttd.STATUS,'') as STATUS, " 
		+ "  isnull(dateadd(mi,?,ttd.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,ttd.DESTINATION_ETA),'') as ETA,isnull(ghl.DRIVER_NAME,'') as dName,isnull(DELAY,0) as DELAY,   "
		+ "  ISNULL(ttd.CUSTOMER_NAME,'') as custName,ttd.TRIP_STATUS AS tripStatus, ttd.ASSET_NUMBER as vehicleNo,isnull(ghl.LATITUDE,0) as LATITUDE,isnull(ghl.LONGITUDE,0) as LONGITUDE, " 
		+ "  isnull(ghl.LOCATION,'') as LOCATION,isnull(dateadd(mi,?,ghl.GMT),'') as GMT,isnull(dateadd(mi,?,ttd.ACTUAL_TRIP_START_TIME),'') as ATD,  "  
		+ "  (case when ttd.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,ttd.ACTUAL_TRIP_END_TIME) end) as endDate, "   
		+ "  case when ghl.CATEGORY='stoppage' then DURATION else 0 end as sTime,case when ghl.CATEGORY='idle' then DURATION else 0 end as iTime, "    
		+ "  isnull(ghl.SPEED,0) as SPEED  ,  "
		+ "   case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and ( getutcdate() ) " 
		+ "  THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS cs ,  "
		+ "  case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS ms ,ds1.PLANNED_ARR_DATETIME " 
		+ "  FROM AMS.dbo.TRACK_TRIP_DETAILS ttd   "
		+ "  LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID " 
		+ "  INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID   "
		+ "  LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "   
		+ "  left outer join AMS.dbo.Vehicle_Status vs on vs.Vehicle_id=ghl.REGISTRATION_NO  "
		+ "  left outer join AMS.dbo.tblVehicleMaster tvm on tvm.VehicleNo = ghl.REGISTRATION_NO    "
		+ "  LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
		+ "  LEFT OUTER JOIN AMS.dbo.DES_TRIP_DETAILS(nolock) ds1 on ds1.TRIP_ID=ttd.TRIP_ID and ds1.SEQUENCE=0 "
		+ "  WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND tvm.Status = 'Active' AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Maintenance Trip' @ $ **  ) a # ";

	public static final String GET_UNASSIGNED_MAP_DETAILS = "SELECT REGISTRATION_NO AS 'VEHICLE NO',DISTANCE,cl AS 'LOCATION',cs AS 'COMMUNICATION STATUS', ms AS 'MOVEMENT STATUS',LATITUDE,LONGITUDE, ua AS 'UNASSIGNED AGE' FROM "
			+ " (SELECT ISNULL(DATEDIFF(minute ,DATEADD(mi,?,(SELECT TOP 1 ACTUAL_TRIP_END_TIME FROM AMS.dbo.TRACK_TRIP_DETAILS(NOLOCK) WHERE ASSET_NUMBER = ghl.REGISTRATION_NO  order by ACTUAL_TRIP_END_TIME desc)),getdate()),0) AS ua, "
			+ "  ghl.REGISTRATION_NO, isnull(uv.DISTANCE,0) as DISTANCE , ghl.LOCATION as cl, "
			+ "  isnull(ghl.LATITUDE,0) as LATITUDE,isnull(ghl.LONGITUDE,0) as LONGITUDE, "
			+ "  case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS cs, "
			+ "  case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS ms "
			+ "  FROM AMS.dbo.gpsdata_history_latest ghl(NOLOCK)  "
			+ "  INNER JOIN AMS.dbo.DISTANCE_ALERT(NOLOCK) da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ "  LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS(NOLOCK) uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ "  LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ "  WHERE ghl.System_id = ? AND ghl.CLIENTID= ? AND tvm.Status = 'Active' $ ** AND ghl.REGISTRATION_NO NOT IN ( "
			+ "  SELECT ttd.ASSET_NUMBER "
			+ "  FROM AMS.dbo.TRACK_TRIP_DETAILS(NOLOCK) ttd "
			+ "  LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ "  INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ "  LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ "  WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? "
			+ "  UNION "
			+ "  SELECT mv.ASSET_NUMBER FROM AMS.[dbo].[MAINTENANCE_VEHICLES](NOLOCK) mv WHERE mv.SYSTEM_ID = ? AND mv.CLIENT_ID = ? )) a #";
	
	public static final String GET_MAINTENANCE_MAP_DETAILS = "SELECT * FROM ( SELECT CASE WHEN ma > 0 THEN ma ELSE 0 END AS 'MAINTENANCE AGE', ASSET_NUMBER AS 'VEHICLE NO', DISTANCE, cl AS 'LOCATION',cs AS 'COMMUNICATION STATUS', ms AS 'MOVEMENT STATUS',LATITUDE,LONGITUDE FROM "
			+ " (SELECT mv.ASSET_NUMBER,ISNULL(DATEDIFF(minute ,DATEADD(mi,?,(mv.START_DATE)),getdate()),0) AS ma, "
			+ " isnull(uv.DISTANCE,0) as DISTANCE , ghl.LOCATION as cl, "
			+ " isnull(ghl.LATITUDE,0) as LATITUDE,isnull(ghl.LONGITUDE,0) as LONGITUDE, "
			+ " case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS cs, "
			+ " case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS ms "
			+ " FROM AMS.dbo.MAINTENANCE_VEHICLES mv(NOLOCK) "
			+ " INNER JOIN AMS.dbo.gpsdata_history_latest ghl(NOLOCK) on ghl.System_id=mv.SYSTEM_ID and ghl.CLIENTID=mv.CLIENT_ID AND mv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT(NOLOCK) da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS(NOLOCK) uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ " left outer join AMS.dbo.tblVehicleMaster tvm on tvm.VehicleNo = ghl.REGISTRATION_NO  "
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " WHERE mv.SYSTEM_ID = ? AND mv.CLIENT_ID = ? AND tvm.Status = 'Active' @ $ ** "
			+ " AND mv.ASSET_NUMBER not in (SELECT ASSET_NUMBER FROM AMS.dbo.TRACK_TRIP_DETAILS WHERE STATUS = 'OPEN' AND SYSTEM_ID = 268 AND CUSTOMER_ID = 5560 )"
			+ ") a # "
			+ " UNION ALL " 
			+ " SELECT CASE WHEN ma > 0 THEN ma ELSE 0 END AS 'MAINTENANCE AGE' ,"
			+ " vehicleNo AS 'VEHICLE NO',DISTANCE, cl as LOCATION,  cs AS 'COMMUNICATION STATUS', ms AS 'MOVEMENT STATUS', LATITUDE, LONGITUDE FROM "
			+ " (SELECT datediff(minute ,dateadd(mi,?,TRIP_START_TIME),getdate()) AS ma, ttd.ASSET_NUMBER as vehicleNo,isnull(ghl.LATITUDE,0) as LATITUDE,isnull(ghl.LONGITUDE,0) as LONGITUDE,isnull(uv.DISTANCE,0) as DISTANCE ,"
			+ " isnull(ghl.LOCATION,'') as cl, case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and ( getutcdate() ) "
			+ " THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS cs , "  
			+ " case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS ms ,ds1.PLANNED_ARR_DATETIME "
			+ " FROM AMS.dbo.TRACK_TRIP_DETAILS ttd  "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID  "  
			+ " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ " left outer join  AMS.dbo.Vehicle_Status vs on vs.Vehicle_id=ghl.REGISTRATION_NO  " 
			+ " left outer join AMS.dbo.tblVehicleMaster tvm on tvm.VehicleNo = ghl.REGISTRATION_NO "   
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " LEFT OUTER JOIN dbo.DES_TRIP_DETAILS(nolock) ds1 on ds1.TRIP_ID=ttd.TRIP_ID and ds1.SEQUENCE=0 "
			+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND tvm.Status = 'Active' @ $ ** AND ttd.TRIP_CUSTOMER_TYPE  LIKE 'Maintenance Trip'  ) a # )b ORDER BY 'MAINTENANCE AGE' ";

	public static final String UNASSIGNED_NON_TRIP_MAP_DETAILS=" select a.REGISTRATION_NO as ASSET_NUMBER ,isnull(a.LOCATION,'') as LOCATION,isnull(dateadd(mi,?,a.GMT),'') as GMT, "+
	" isnull(a.LATITUDE,0) as LATITUDE,isnull(a.LONGITUDE,0) as LONGITUDE,   "+
	" case when a.CATEGORY='stoppage' then DURATION else 0 end as STOPPAGE_TIME,case when a.CATEGORY='idle' then DURATION else 0 end as IDLE_TIME,   "+
	" isnull(a.SPEED,0) as SPEED  , "+
	" case when a.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and ( getutcdate() )   "+
	" THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS COMMUNICATION_STATUS , "+
	" case when uv.DISTANCE>=da.ALERT_DISTANCE_KM   Then 'Moved' ELSE 'Halted'  END AS MOVED_STATUS "+
	" from dbo.gpsdata_history_latest a "+
	" left join  AMS.dbo.Vehicle_Status vs on vs.Vehicle_id=a.REGISTRATION_NO "+
	" left join AMS.dbo.TRACK_TRIP_DETAILS  td on vs.Vehicle_id=td.ASSET_NUMBER  "+
	" left join AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = a.REGISTRATION_NO "+
	" left join AMS.dbo.tblVehicleMaster tvm on tvm.VehicleNo = a.REGISTRATION_NO  "+
	" INNER JOIN AMS.dbo.DISTANCE_ALERT da on a.System_id=da.SYSTEM_ID and a.CLIENTID=da.CUSTOMER_ID "+		
	" where a.System_id=? and a.CLIENTID=?  and vs.Status_id is null  and tvm.Status = 'Active' ";

	public static final String GET_ASSIGNED_VEHICLES_DAYS_COUNT = "SELECT datediff(minute ,dateadd(mi,?,TRIP_START_TIME),getdate()) AS 'AGE',ghl.LOCATION AS 'CURRENT LOCATION', "
			+ " CASE WHEN ghl.GMT BETWEEN DATEADD(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) AND (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS 'COMMUNICATION STATUS' "
			+ " FROM AMS.dbo.TRACK_TRIP_DETAILS ttd  "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " left outer join AMS.dbo.DES_TRIP_DETAILS(nolock) ds1 on ds1.TRIP_ID=ttd.TRIP_ID and ds1.SEQUENCE=0"
			+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND tvm.Status = 'Active' AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Maintenance Trip' @ $ ** ";

	public static final String GET_UNASSIGNED_VEHICLES_DAYS_COUNT = "SELECT ISNULL(DATEDIFF(minute ,DATEADD(mi,?,(SELECT TOP 1 ACTUAL_TRIP_END_TIME FROM AMS.dbo.TRACK_TRIP_DETAILS(NOLOCK) WHERE ASSET_NUMBER = ghl.REGISTRATION_NO  order by ACTUAL_TRIP_END_TIME desc)),getdate()),0) AS 'AGE',ghl.LOCATION AS 'CURRENT LOCATION', "
			+ " case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS 'COMMUNICATION STATUS' "
			+ " FROM AMS.dbo.gpsdata_history_latest ghl(NOLOCK)  "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT(NOLOCK) da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " WHERE ghl.System_id = ? AND ghl.CLIENTID= ? AND tvm.Status = 'Active' $ ** AND ghl.REGISTRATION_NO NOT IN ( "
			+ " SELECT ttd.ASSET_NUMBER "
			+ " FROM AMS.dbo.TRACK_TRIP_DETAILS(NOLOCK) ttd "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? "
			+ " UNION  "
			+ " SELECT mv.ASSET_NUMBER FROM AMS.[dbo].[MAINTENANCE_VEHICLES](NOLOCK) mv WHERE mv.SYSTEM_ID = ? AND mv.CLIENT_ID = ?)";

	public static final String GET_MAINTENANCE_VEHICLES_DAYS_COUNT = "SELECT ISNULL(DATEDIFF(minute ,DATEADD(mi,?,(START_DATE)),getdate()),0) AS 'AGE',ghl.LOCATION AS 'CURRENT LOCATION', "
			+ " case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS 'COMMUNICATION STATUS' "
			+ " FROM AMS.[dbo].[MAINTENANCE_VEHICLES](NOLOCK) mv "
			+ " INNER JOIN AMS.dbo.gpsdata_history_latest ghl(NOLOCK)  ON ghl.System_id=mv.SYSTEM_ID and ghl.CLIENTID=mv.CLIENT_ID and ghl.REGISTRATION_NO = mv.ASSET_NUMBER "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT(NOLOCK) da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " WHERE mv.SYSTEM_ID = ? AND mv.CLIENT_ID = ? AND tvm.Status = 'Active'  $ ** "
			+ " AND mv.ASSET_NUMBER not in (SELECT ASSET_NUMBER FROM AMS.dbo.TRACK_TRIP_DETAILS WHERE STATUS = 'OPEN' AND SYSTEM_ID = 268 AND CUSTOMER_ID = 5560)"
			+ " UNION ALL "
			+ " SELECT  ISNULL(datediff(minute ,dateadd(mi,?,TRIP_START_TIME),getdate()),0) AS 'AGE',ghl.LOCATION AS 'CURRENT LOCATION', "
			+ " CASE WHEN ghl.GMT BETWEEN DATEADD(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) AND (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS 'COMMUNICATION STATUS' "
			+ " FROM AMS.dbo.TRACK_TRIP_DETAILS ttd  "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id "
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " left outer join AMS.dbo.DES_TRIP_DETAILS(nolock) ds1 on ds1.TRIP_ID=ttd.TRIP_ID and ds1.SEQUENCE=0 "
			+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND tvm.Status = 'Active' $ **  AND ttd.TRIP_CUSTOMER_TYPE  LIKE 'Maintenance Trip' ";

	public static final String GET_ASSIGNED_TRIP_TYPE_COUNT = "select COUNT(*) AS COUNT,PRODUCT_LINE AS TYPE from AMS.dbo.TRACK_TRIP_DETAILS ttd "
              + " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ttd.ASSET_NUMBER AND  ttd.SYSTEM_ID = tvm.System_id " 
              + " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ttd.ASSET_NUMBER "
              + " where STATUS = 'OPEN' AND SYSTEM_ID = ? AND CUSTOMER_ID = ? AND tvm.Status = 'Active' AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Maintenance Trip' $ ** GROUP BY PRODUCT_LINE ";
	
	public static final String GET_ASSIGNED_LOADING_COUNT = " SELECT COUNT(ttd.ASSET_NUMBER) AS 'LoadingCount' FROM AMS.dbo.TRACK_TRIP_DETAILS ttd "
            + " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ttd.ASSET_NUMBER AND  ttd.SYSTEM_ID = tvm.System_id LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ttd.ASSET_NUMBER "
            + " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Maintenance Trip' $ ** AND ttd.ACT_SRC_ARR_DATETIME IS NOT NULL AND ttd.ACTUAL_TRIP_START_TIME IS NULL ";
	
	public static final String GET_ASSIGNED_UNLOADING_COUNT = "SELECT COUNT(ttd.ASSET_NUMBER) AS 'UnloadingCount' FROM AMS.dbo.TRACK_TRIP_DETAILS ttd INNER JOIN AMS.dbo.DES_TRIP_DETAILS dt on ttd.TRIP_ID=dt.TRIP_ID AND dt.SEQUENCE = 100 LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ttd.ASSET_NUMBER AND  " 
			+ " ttd.SYSTEM_ID = tvm.System_id LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ttd.ASSET_NUMBER "
            + " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Maintenance Trip' $ ** AND dt.ACT_ARR_DATETIME IS NOT NULL AND ttd.ACTUAL_TRIP_END_TIME IS NULL ";
	
    public static final String GET_ASSIGNED_LOADING_UNLOADING_DETAILS = "SELECT CASE WHEN aa > 0 THEN aa ELSE 0 END AS 'ASSIGNED AGE',TRIP_ID AS 'TRIP ID',ASSET_NUMBER AS 'VEHICLE NO.',VEHICLE_CAT,VEHICLE_TYPE,CUSTOMER_NAME,oid AS 'TRIP NO.',ad AS 'ACTUAL DISTANCE',DISTANCE,cl AS 'CURRENT LOCATION',rid AS 'ROUTE ID',gtc AS 'GPS TAMPERING COUNT', cs AS 'COMMUNICATION STATUS', ms AS 'MOVEMENT STATUS',CURRENT_ODO AS 'CURRENT ODO',model AS 'MODEL NAME', hub AS 'HUB' FROM ( "
			+ "SELECT datediff(minute ,dateadd(mi,?,TRIP_START_TIME),getdate()) AS aa, ttd.TRIP_ID ,ttd.PRODUCT_LINE , "
			+ " ttd.ASSET_NUMBER,ISNULL(ttd.CUSTOMER_NAME,'') AS CUSTOMER_NAME, ISNULL(ttd.ORDER_ID,'') AS oid,ISNULL(ttd.ACTUAL_DISTANCE,0)  AS ad,ISNULL(uv.DISTANCE,0) AS DISTANCE , "
			+ " ghl.LOCATION AS cl,ttd.SHIPMENT_ID AS rid ,isnull(vm.ModelName,'') as model,isnull(vshd.HUB_NAME,'') as hub,isnull(tvm.VehicleType,'') as VEHICLE_TYPE ,(select case when (tvm.VehicleType like '%DC%') then 'Dry' else 'TCL' end )as VEHICLE_CAT, "
			+ " (SELECT COUNT(REGISTRATION_NO) FROM AMS.dbo.Alert WHERE TYPE_OF_ALERT=145 AND  REGISTRATION_NO= ghl.REGISTRATION_NO) AS gtc , "
			+ " CASE WHEN ghl.GMT BETWEEN DATEADD(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) AND (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS cs, "
			+ " CASE WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS ms ,CONCAT(ISNULL(odo.SRC_ZONE,'NA'),' - ',ISNULL(odo.DES_ZONE,'NA')) AS CURRENT_ODO "
			+ " FROM AMS.dbo.TRACK_TRIP_DETAILS ttd "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
			+ " INNER JOIN AMS.dbo.DES_TRIP_DETAILS dt on ttd.TRIP_ID=dt.TRIP_ID AND dt.SEQUENCE = 100 "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ttd.ASSET_NUMBER AND  ttd.SYSTEM_ID = tvm.System_id LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ttd.ASSET_NUMBER "
			+ " LEFT OUTER JOIN AMS.dbo.ODO_ROUTE_DETAILS odo(NOLOCK) on odo.RES_ID = ghl.REGISTRATION_NO  "
			+ "  LEFT OUTER JOIN FMS.[dbo].[Vehicle_Model](nolock) vm ON ghl.System_id = vm.SystemId AND ghl.CLIENTID = vm.ClientId AND vm.ModelTypeId = tvm.Model " 
			+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Maintenance Trip' $ ** # )a  ORDER BY aa DESC ";
	
	public static final String GET_ASSIGNED_LOADING_UNLOADING_MAP_DETAILS = "SELECT trip_no AS 'TRIP NO', rName AS 'ROUTE NAME', humidity AS 'HUMIDITY', T1, T2, T3, pLine AS 'PRODUCT LINE', rId as 'ROUTE ID',STD,tripId AS 'TRIP ID', "
		+ " STATUS,ETHA,ETA,dName AS 'DRIVER NAME', DELAY,custName AS 'CUSTOMER NAME', tripStatus AS 'TRIP STATUS', vehicleNo AS 'VEHICLE NO',LATITUDE, LONGITUDE, LOCATION,  "
		+ " GMT, ATD, endDate,sTime AS 'STOPPAGE TIME', iTime AS 'IDLE TIME', SPEED, cs AS 'COMMUNICATION STATUS', ms AS 'MOVEMENT STATUS', "
		+ " CASE WHEN aa > 0 THEN aa ELSE 0 END AS 'ASSIGNED TIME' "
		+ " FROM "
		+ " (SELECT datediff(minute ,dateadd(mi,?,TRIP_START_TIME),getdate()) AS aa,isnull(ttd.ORDER_ID,'') as trip_no,isnull(ttd.ROUTE_NAME,0) as rName,isnull(ANALOG_INPUT_1,'99999') as humidity ,isnull(r.IO_VALUE,'NA') as T1,isnull(r1.IO_VALUE,'NA') as T2,isnull(r2.IO_VALUE,'NA') as T3,isnull(ttd.PRODUCT_LINE,0) as pLine,isnull(ttd.ROUTE_ID,0) as rId,isnull(dateadd(mi,?,ttd.TRIP_START_TIME),'') as STD,isnull(ttd.TRIP_ID,0) as tripId,isnull(ttd.STATUS,'') as STATUS, "
		+ " isnull(dateadd(mi,?,ttd.NEXT_POINT_ETA),'') as ETHA,isnull(dateadd(mi,?,ttd.DESTINATION_ETA),'') as ETA,isnull(ghl.DRIVER_NAME,'') as dName,isnull(DELAY,0) as DELAY,   "
		+ " ISNULL(ttd.CUSTOMER_NAME,'') as custName,ttd.TRIP_STATUS AS tripStatus, ttd.ASSET_NUMBER as vehicleNo,isnull(ghl.LATITUDE,0) as LATITUDE,isnull(ghl.LONGITUDE,0) as LONGITUDE, "
		+ " isnull(ghl.LOCATION,'') as LOCATION,isnull(dateadd(mi,?,ghl.GMT),'') as GMT,isnull(dateadd(mi,?,ttd.ACTUAL_TRIP_START_TIME),'') as ATD,    "
		+ " (case when ttd.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,ttd.ACTUAL_TRIP_END_TIME) end) as endDate,    "
		+ " case when ghl.CATEGORY='stoppage' then DURATION else 0 end as sTime,case when ghl.CATEGORY='idle' then DURATION else 0 end as iTime,    "
		+ " isnull(ghl.SPEED,0) as SPEED  ,  "
		+ "  case when ghl.GMT between dateadd(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) and ( getutcdate() ) "
		+ " THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS cs ,  "
		+ " case WHEN ghl.SPEED = 0 AND ghl.IGNITION = 1 Then 'Idling' WHEN ghl.SPEED = 0 AND ghl.IGNITION = 0 THEN 'Halted' ELSE 'Moved'  END AS ms "
		+ " FROM AMS.dbo.TRACK_TRIP_DETAILS ttd   "
		+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID "
		+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID   "
		+ " LEFT OUTER JOIN AMS.dbo.UNASSIGNED_VEHICLE_TRIP_DETAILS uv on uv.ASSET_NUMBER = ghl.REGISTRATION_NO "
		+ " left outer join AMS.dbo.RS232_LIVE r on r.REGISTRATION_NO=ttd.ASSET_NUMBER and r.IO_CATEGORY in ('TEMPERATURE1') "
		+ " left outer join AMS.dbo.RS232_LIVE r1 on r1.REGISTRATION_NO=ttd.ASSET_NUMBER and r1.IO_CATEGORY in ('TEMPERATURE2') "
		+ " left outer join AMS.dbo.RS232_LIVE r2 on r2.REGISTRATION_NO=ttd.ASSET_NUMBER and r2.IO_CATEGORY in ('TEMPERATURE3')  "
		+ " left outer join  AMS.dbo.Vehicle_Status vs on vs.Vehicle_id=ghl.REGISTRATION_NO  "
		+ " left join AMS.dbo.tblVehicleMaster tvm on tvm.VehicleNo = ghl.REGISTRATION_NO    "
		+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ttd.ASSET_NUMBER "
		+ " INNER JOIN AMS.dbo.DES_TRIP_DETAILS dt on ttd.TRIP_ID=dt.TRIP_ID AND dt.SEQUENCE = 100 "
		+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Maintenance Trip' $ ** #) a ";
	
	public static final String GET_ASSIGNED_GREATER_THAN_STP = "SELECT datediff(minute ,dateadd(mi,?,ds1.PLANNED_ARR_DATETIME),getdate()) AS 'AGE',ghl.LOCATION AS 'CURRENT LOCATION',"
			+ " CASE WHEN ghl.GMT BETWEEN DATEADD(mi,-da.NON_COMM_DURATION_MINS,getUTCDate()) AND (getutcdate()) THEN 'COMMUNICATING' ELSE 'NON COMMUNICATING'  END AS 'COMMUNICATION STATUS'"
			+ " FROM AMS.dbo.TRACK_TRIP_DETAILS ttd  "
			+ " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest ghl ON ghl.REGISTRATION_NO = ttd.ASSET_NUMBER AND ghl.System_id = ttd.SYSTEM_ID  AND ghl.CLIENTID=ttd.CUSTOMER_ID"
			+ " INNER JOIN AMS.dbo.DISTANCE_ALERT da on ghl.System_id=da.SYSTEM_ID and ghl.CLIENTID=da.CUSTOMER_ID "
			+ " LEFT OUTER JOIN AMS.dbo.tblVehicleMaster tvm(NOLOCK) on tvm.VehicleNo = ghl.REGISTRATION_NO AND  ghl.System_id = tvm.System_id"
			+ " LEFT OUTER JOIN AMS.dbo.VEHICLE_SMART_HUB_DETAILS vshd on vshd.VEHICLE_NO = ghl.REGISTRATION_NO "
			+ " left outer join AMS.dbo.DES_TRIP_DETAILS(nolock) ds1 on ds1.TRIP_ID=ttd.TRIP_ID and ds1.SEQUENCE=0"
			+ " WHERE ttd.STATUS = 'OPEN' AND ttd.SYSTEM_ID = ? AND ttd.CUSTOMER_ID = ? AND tvm.Status = 'Active'"
			+ " AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Maintenance Trip' AND ds1.PLANNED_ARR_DATETIME IS NOT NULL"
			+ " AND ds1.PLANNED_ARR_DATETIME  > getutcdate()"
			+ " AND DATEDIFF(mi,GETUTCDATE(),ds1.PLANNED_ARR_DATETIME) > 2880 $ ** order by ds1.PLANNED_ARR_DATETIME desc ";

	String allTheSelectedHubs = "773368,773363,773367,773374,773364,773361,773366,773383,773380,773371,773375,773365,773369";
	
	public static final String GET_SUM_MAINTENANCE_AGE = " select SUM(DURATION_MIN) as SUM_OF_AGE from MAINTENANCE_VEHICLE_DURATION where MONTH = ? ";
	
	public JSONArray getDayDetails(int systemId, int customerId,int offset, String type,String vehicleCat,String vehicleTyp,String hubTyp) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		String query = "";

		try {
			
			JSONObject json = new JSONObject();
			con=DBConnection.getConnectionToDB("AMS");
			
			if (type.equalsIgnoreCase("AssignedVehicles")) {
				query = getAssignedQuery(GET_ASSIGNED_VEHICLES_DAYS_COUNT.replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
			} else if (type.equalsIgnoreCase("UnassignedVehicles")) {
				query = getQuery(GET_UNASSIGNED_VEHICLES_DAYS_COUNT, vehicleCat,vehicleTyp,hubTyp);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, systemId);
				pstmt.setInt(5, customerId);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, customerId);
			} else if (type.equalsIgnoreCase("MaintenanceVehicles")) {
				query = getQuery(GET_MAINTENANCE_VEHICLES_DAYS_COUNT.replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, offset);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, customerId);
			} 
			
			rs=pstmt.executeQuery();
			int comm2hr = 0;
			int nComm2hr = 0;
			int comm5hr = 0;
			int nComm5hr = 0;
			int comm7hr = 0;
			int nComm7hr = 0;
			int comm10hr = 0;
			int nComm10hr = 0;
			int ish2 = 0 ;
			int ish5 = 0 ;
			int ish7 = 0 ;
			int ish10 = 0 ;
		    int agelessthan=0;
		    int agegreathan=0;
		    
			while(rs.next()){
				int age = rs.getInt("AGE");
				String commStatus = rs.getString("COMMUNICATION STATUS");
				String cLocation = rs.getString("CURRENT LOCATION");
				
				if(age < 2881){
					if(cLocation.contains("Inside SH")){
						ish2 ++;
					}
					if(commStatus.equalsIgnoreCase("COMMUNICATING")){
						comm2hr ++;
					}else{
						nComm2hr ++;
					}
				}else if(age >= 2881 && age < 7201){
					if(cLocation.contains("Inside SH")){
						ish5 ++;
					}
					if(commStatus.equalsIgnoreCase("COMMUNICATING")){
						comm5hr ++;
					}else{
						nComm5hr ++;
					}
				}else if(age >= 7201 && age < 14401){
					if(cLocation.contains("Inside SH")){
						ish7 ++;
					}
					if(commStatus.equalsIgnoreCase("COMMUNICATING")){
						comm7hr ++;
					}else{
						nComm7hr ++;
					}
				}else if(age >= 14401){
					if(cLocation.contains("Inside SH")){
						ish10 ++;
					}
					if(commStatus.equalsIgnoreCase("COMMUNICATING")){
						comm10hr ++;
					}else{
						nComm10hr ++;
					}
				}
				if (type.equalsIgnoreCase("MaintenanceVehicles")) {
					if(age < 720){
						agelessthan++;
					}else if(age >= 720 && age < 2881){
						agegreathan++;
					}
					
				}
			}
			json.put("communicating2Hour", comm2hr);
			json.put("nonCommunicating2Hour", nComm2hr);
			json.put("communicating5Hour", comm5hr);
			json.put("nonCommunicating5Hour", nComm5hr);
			json.put("communicating7Hour", comm7hr);
			json.put("nonCommunicating7Hour", nComm7hr);
			json.put("communicating10Hour", comm10hr);
			json.put("nonCommunicating10Hour", nComm10hr);
			json.put("insideSH2Hour", ish2);
			json.put("insideSH5Hour", ish5);
			json.put("insideSH7Hour", ish7);
			json.put("insideSH10Hour", ish10);
			json.put("agelessthan", agelessthan);
			json.put("agegreathan", agegreathan);
			jsonArray.put(json);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getSTPGreathenThan2DayDetails(int systemId, int customerId, int offset, String type, String vehicleCat, String vehicleTyp, String hubTyp) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsonArray = new JSONArray();
		String query = "";

		try {

			JSONObject json = new JSONObject();
			con = DBConnection.getConnectionToDB("AMS");

			query = getAssignedQuery(GET_ASSIGNED_GREATER_THAN_STP, vehicleCat, vehicleTyp,
					hubTyp);

			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);

			rs = pstmt.executeQuery();
			int commGreathanThan2hr = 0;
			int nCommGreathanThan2hr = 0;
			int ishGreathanThan2hr = 0;

			while (rs.next()) {

				String commStatus = rs.getString("COMMUNICATION STATUS");
				String cLocation = rs.getString("CURRENT LOCATION");

				if (cLocation.contains("Inside SH")) {
					ishGreathanThan2hr++;
				}
				if (commStatus.equalsIgnoreCase("COMMUNICATING")) {
					commGreathanThan2hr++;
				} else {
					nCommGreathanThan2hr++;
				}

			}

			json.put("communicatingGrthn2Hour", commGreathanThan2hr);
			json.put("nonCommunicatingGrthn2Hour", nCommGreathanThan2hr);
			json.put("insideSHGrth2Hour", ishGreathanThan2hr);
			jsonArray.put(json);

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getTripTypeWiseCounts(int systemId,int customerId,String vehicleCat,String vehicleTyp,String hubTyp){
		
		Connection con =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		String query = "";
		
		try {
			JSONObject json = new JSONObject();
			con=DBConnection.getConnectionToDB("AMS");
			
			query = getAssignedQuery(GET_ASSIGNED_TRIP_TYPE_COUNT, vehicleCat,vehicleTyp,hubTyp);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs=pstmt.executeQuery();
			
			int dryCount = 0;
			int tclCount = 0;
			
			while (rs.next()) {
				if(rs.getString("TYPE").equalsIgnoreCase("Dry")){
					dryCount = rs.getInt("COUNT");
				}else{
					tclCount = rs.getInt("COUNT");
				}
			}
			
			json.put("dryCount", dryCount);
			json.put("tclCount", tclCount);
			jsonArray.put(json);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getCountDetails(int systemId,int customerId, String type,String vehicleCat,String vehicleTyp,String hubTyp){
		
		Connection con =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONArray jsonArray = new JSONArray();
		String query = "";
		
		try {
			
			JSONObject json = new JSONObject();
			con=DBConnection.getConnectionToDB("AMS");
			
			if (type.equalsIgnoreCase("getAssignedVehicleCountJson")) {
				query = getAssignedQuery(GETASSIGNEDVEHICLESCOUNT.replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
			} else if (type.equalsIgnoreCase("getUnAssignedVehicleCountJson")) {
				query = getQuery(GETUNASSIGNEDVEHICLESCOUNT, vehicleCat,vehicleTyp,hubTyp);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, customerId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, customerId);
			} else if (type.equalsIgnoreCase("getMaintenanceVehicleCountJson")) {
				query = getQuery(GETMAINTENANCEVEHICLESCOUNT.replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, customerId);
			}else if (type.equalsIgnoreCase("getAssignedEmptyTripVehicleCountJson")) {
				query = getAssignedQuery(GETASSIGNEDVEHICLESCOUNT.replace("@", " AND ttd.TRIP_CUSTOMER_TYPE LIKE 'Empty Trip'"), vehicleCat,vehicleTyp,hubTyp);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
			}else if (type.equalsIgnoreCase("getAssignedCustomerTripVehicleCountJson")) {
				query = getAssignedQuery(GETASSIGNEDVEHICLESCOUNT.replace("@", " AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Empty Trip'"), vehicleCat,vehicleTyp,hubTyp);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
			}else if (type.equalsIgnoreCase("getMaintenanceInsideSCCountJson")) {
				query = getQuery(GETMAINTENANCEVEHICLESCOUNT.replace("@", " AND ghl.LOCATION LIKE 'Inside SVC_STN_%'"), vehicleCat,vehicleTyp,hubTyp);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, customerId);
			}else if (type.equalsIgnoreCase("getMaintenanceEnrouteSCCountJson")) {
				query = getQuery(GETMAINTENANCEVEHICLESCOUNT.replace("@", " AND ghl.LOCATION NOT LIKE 'Inside SVC_STN_%'"), vehicleCat,vehicleTyp,hubTyp);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, customerId);
			}
			rs=pstmt.executeQuery();
			int total = 0;
			int commn = 0;
			int nonCommn = 0;
			int halted = 0;
			int haltedCommn = 0;
			int haltedNonCommn = 0;
			int moving = 0;
			int movingCommn = 0;
			int movingNonCommn = 0;
			int idling = 0;
			int idlingCommn = 0;
			int idlingNonCommn = 0;
			int totalEmptyTrip = 0;
			int totalCustomerTrip = 0;
			int insideSCcount = 0;
			int insideEnrouteCount = 0;
			int sumOfAge = 0;
			
			while (rs.next()) {
				int count = rs.getInt("COUNT");
				String commStatus=rs.getString("COMMUNICATION_STATUS");
				String movedStatus=rs.getString("MOVED_STATUS");
				total += count;
				totalEmptyTrip += count;
				totalCustomerTrip += count;
				insideSCcount += count;
				insideEnrouteCount += count;
				
				if(commStatus.equalsIgnoreCase("COMMUNICATING"))
					commn += count;
				else
					nonCommn += count;
				
				if(movedStatus.equalsIgnoreCase("Halted")){
					halted += count;
					if(commStatus.equalsIgnoreCase("COMMUNICATING"))
						haltedCommn += count;
					else
						haltedNonCommn += count;
				}else if(movedStatus.equalsIgnoreCase("Moved")){
					moving += count;
					if(commStatus.equalsIgnoreCase("COMMUNICATING"))
						movingCommn += count;
					else
						movingNonCommn += count;
				}else if(movedStatus.equalsIgnoreCase("Idling")){
					idling += count;
					if(commStatus.equalsIgnoreCase("COMMUNICATING"))
						idlingCommn += count;
					else
						idlingNonCommn += count;
				}
			}
			sumOfAge  = getMaintenanceMTDSumOfAge(con,pstmt,rs);
			json.put("totalCount", total);
			json.put("communicatingCount", commn);
			json.put("nonCommunicatingCount", nonCommn);
			json.put("haltedCount", halted);
			json.put("haltedCommunicatingCount", haltedCommn);
			json.put("haltedNonCommunicatingCount", haltedNonCommn);
			json.put("movingCount", moving);
			json.put("movingCommunicatingCount", movingCommn);
			json.put("movingNonCommunicatingCount", movingNonCommn);
			json.put("idlingCount", idling);
			json.put("idlingCommunicatingCount", idlingCommn);
			json.put("idlingNonCommunicatingCount", idlingNonCommn);
			json.put("totalEmptyTripCount", totalEmptyTrip);
			json.put("totalCustomerTripCount", totalCustomerTrip);
			json.put("insideSCCount", insideSCcount);
			json.put("insideEnrouteCount", insideEnrouteCount);
			json.put("totalMaintenanceAge", sumOfAge);
			jsonArray.put(json);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public int getMaintenanceMTDSumOfAge(Connection con, PreparedStatement pstmt, ResultSet rs) {
		int ageTotalCount = 0;
		try {
			Calendar cal = Calendar.getInstance();
			Formatter fmt = new Formatter();
			String currentMonth = fmt.format("%tB", cal).toString();
			pstmt = con.prepareStatement(GET_SUM_MAINTENANCE_AGE);
			pstmt.setString(1, currentMonth);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				ageTotalCount = rs.getInt("SUM_OF_AGE");
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return ageTotalCount;
	}

	

	public  JSONArray getAssignedListView(int systemId,int customerId,int offset,String type,String vehicleCat,String vehicleTyp,String hubTyp){
		Connection con =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONObject jsonObj= null;
		JSONArray array= null;
		String query = "";
		try {
			array= new JSONArray();
			ReportBuilderFunctions ddhhmm= new ReportBuilderFunctions();
			con=DBConnection.getConnectionToDB("AMS");
			if (type.equalsIgnoreCase("all"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", "").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("communicating"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#","WHERE cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("nonCommunicating"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#","WHERE cs = 'NON COMMUNICATING'" ).replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("haltedCommunicating"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#","WHERE cs = 'COMMUNICATING' AND ms = 'Halted'" ).replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("idlingCommunicating"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#","WHERE cs = 'COMMUNICATING' AND ms = 'Idling'" ).replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("movedCommunicating"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#","WHERE cs = 'COMMUNICATING' AND ms = 'Moved'" ).replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("haltedNonCommunicating"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#","WHERE cs = 'NON COMMUNICATING' AND ms = 'Halted'" ).replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("movedNonCommunicating"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#","WHERE cs = 'NON COMMUNICATING' AND ms = 'Moved'" ).replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("idlingNonCommunicating"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#","WHERE cs = 'NON COMMUNICATING' AND ms = 'Idling'" ).replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("lessThan2hrNonComm"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cs = 'NON COMMUNICATING' and a.PLANNED_ARR_DATETIME is not null and a.PLANNED_ARR_DATETIME > getutcdate() and datediff(dd,a.PLANNED_ARR_DATETIME,getutcdate()) > 2  ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("between2To5hrNonComm"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE aa >= 2881 AND aa < 7201 AND cs = 'NON COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("moreThan5hrNonComm"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE aa >= 7201 AND aa < 14401 AND cs = 'NON COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("moreThan10hrNonComm"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE aa >= 14401 AND cs = 'NON COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("lessThan2hrComm"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE aa < 2881 AND cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("between2To5hrComm"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE aa >= 2881 AND aa < 7201 AND cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("moreThan5hrComm"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE aa >= 7201 AND aa < 14401 AND cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("moreThan10hrComm"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE aa >= 14401 AND cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("insideSH"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("movedInsideSH"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("haltedInsideSH"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("idlingInsideSH"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("insideSH2hr"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND  a.PLANNED_ARR_DATETIME is not null and a.PLANNED_ARR_DATETIME > getutcdate() and datediff(dd,a.PLANNED_ARR_DATETIME,getutcdate()) > 2 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("insideSH5hr"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND aa >= 2881 AND aa < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("insideSH7hr"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND aa >= 7201 AND aa < 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("insideSH10hr"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND aa >= 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("Moved"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ms = 'Moved' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("Idling"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ms = 'Idling' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("Halted"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ms = 'Halted' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("2hr"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE a.PLANNED_ARR_DATETIME is not null and a.PLANNED_ARR_DATETIME > getutcdate() and datediff(mi,getutcdate(),a.PLANNED_ARR_DATETIME) > 2880 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("5hr"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE aa >= 2881 AND aa < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("7hr"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE aa >= 7201 AND aa < 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("10hr"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE aa >= 14401").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("Dry"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", "  WHERE PRODUCT_LINE = 'Dry' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("TCL"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", "  WHERE PRODUCT_LINE = 'TCL'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("empty"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", "").replace("@", " AND ttd.TRIP_CUSTOMER_TYPE LIKE 'Empty Trip'"), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("customer"))
				query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", "").replace("@", " AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Empty Trip'"), vehicleCat,vehicleTyp,hubTyp);
			
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObj= new JSONObject();
				int tripId=rs.getInt("TRIP ID");
				ArrayList<String> driverDetais = getDriverName(con, systemId, customerId, tripId);
				long assigned_age=rs.getLong("ASSIGNED AGE");
				jsonObj.put("vehicleNumber", rs.getString("VEHICLE NO."));
				jsonObj.put("currentLocation", rs.getString("CURRENT LOCATION"));
				jsonObj.put("routeId", rs.getString("ROUTE ID"));
				jsonObj.put("tripNo", rs.getString("TRIP NO."));
				jsonObj.put("tripId", rs.getString("TRIP ID"));
				jsonObj.put("distance", rs.getDouble("ACTUAL DISTANCE")!=0?rs.getDouble("ACTUAL DISTANCE"):rs.getDouble("DISTANCE"));
				jsonObj.put("driver1", driverDetais.get(0));
				jsonObj.put("driver1Contact", driverDetais.get(1));
				jsonObj.put("driver2", driverDetais.get(2));
				jsonObj.put("driver2Contact", driverDetais.get(3));
				jsonObj.put("tamperCount", rs.getInt("GPS TAMPERING COUNT"));
				jsonObj.put("commStatus", rs.getString("COMMUNICATION STATUS"));
				jsonObj.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				String assignedTime=(assigned_age==0)?"NA":ddhhmm.formattedDaysHoursMinutes(assigned_age);
				jsonObj.put("unassignedTime", assignedTime);
				jsonObj.put("vehicleCategory", rs.getString("VEHICLE_CAT"));
				jsonObj.put("vehicleType", rs.getString("VEHICLE_TYPE"));
				jsonObj.put("currentODORoute", rs.getString("CURRENT ODO"));
				jsonObj.put("customerName", rs.getString("CUSTOMER_NAME"));
				jsonObj.put("modelName", rs.getString("MODEL NAME"));
				String [] srcHubAddress = rs.getString("HUB").split(",");
				jsonObj.put("srcHub", srcHubAddress[0]);
				array.put(jsonObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return array;
	}
		
	public  JSONArray getUnassignedListView(int systemId,int customerId,int offset, String type,String vehicleCat,String vehicleTyp,String hubTyp){
		Connection con =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONObject jsonObj= null;
		JSONArray array= null;
		String query = "";
		
		try {
			array= new JSONArray();
			ReportBuilderFunctions ddhhmm= new ReportBuilderFunctions();
			con=DBConnection.getConnectionToDB("AMS");
		
			 if(type.equalsIgnoreCase("all"))
				 query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", ""), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("communicating"))
				 query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("nonCommunicating"))
				 query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("haltedCommunicating"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Halted'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("idlingCommunicating"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Idling'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("movedCommunicating"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Moved'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("haltedNonCommunicating"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Halted'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("movedNonCommunicating"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Moved'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("idlingNonCommunicating"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Idling'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("lessThan2hrComm"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE ua < 2881 AND cs = 'COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("between2To5hrComm"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE ua >= 2881 AND aa < 7201 AND cs = 'COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("moreThan5hrComm"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ua >= 7201 AND aa < 14401 AND cs = 'COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("moreThan10hrComm"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ua >= 14401 AND cs = 'COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("lessThan2hrNonComm"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ua < 2881 AND cs = 'NON COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("between2To5hrNonComm"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ua >= 2881 AND aa < 7201 AND cs = 'NON COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("moreThan5hrNonComm"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ua >= 7201 AND aa < 14401 AND cs = 'NON COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("moreThan10hrNonComm"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ua >= 14401 AND cs = 'NON COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("insideSH"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("extraKm50"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE DISTANCE > 50 AND DISTANCE < 100"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("extraKm100"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE DISTANCE >= 100 "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("extraKm200"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE DISTANCE >= 200 "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("movedInsideSH"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ms = 'Moved'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("haltedInsideSH"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ms = 'Halted'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("idlingInsideSH"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ms = 'Idling'"), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("insideSH2hr"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ua < 2881 "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("insideSH5hr"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ua >= 2881 AND ua < 7201 "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("insideSH7hr"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ua >= 7201 AND ua < 14401 "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("insideSH10hr"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ua >= 14401 "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("Moved"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ms = 'Moved' "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("Idling"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ms = 'Idling' "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("Halted"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ms = 'Halted' "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("2hr"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ua < 2881 "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("5hr"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ua >= 2881 AND ua < 7201 "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("7hr"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ua >= 7201 AND ua < 14401 "), vehicleCat,vehicleTyp,hubTyp);
			 else if(type.equalsIgnoreCase("10hr"))
				query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", " WHERE ua >= 14401 "), vehicleCat,vehicleTyp,hubTyp);
				
	        pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, customerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObj= new JSONObject();
				long unassigned_age=rs.getLong("UNASSIGNED AGE");
				jsonObj.put("vehicleNumber", rs.getString("VEHICLE NO."));
				jsonObj.put("currentLocation", rs.getString("CURRENT LOCATION"));
				jsonObj.put("distance", rs.getDouble("DISTANCE"));
				jsonObj.put("tamperCount", rs.getInt("GPS TAMPERING COUNT"));
				jsonObj.put("commStatus", rs.getString("COMMUNICATION STATUS"));
				jsonObj.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				String unassignedTime=(unassigned_age==0)?"NA":ddhhmm.formattedDaysHoursMinutes(unassigned_age);
				jsonObj.put("unassignedTime", unassignedTime);
				jsonObj.put("vehicleCategory", rs.getString("VEHICLE_CAT"));
				jsonObj.put("vehicleType", rs.getString("VEHICLE_TYPE"));
				jsonObj.put("currentODORoute", rs.getString("CURRENT ODO"));
				jsonObj.put("modelName", rs.getString("MODEL NAME"));
				//jsonObj.put("srcHub", rs.getString("HUB"));
				String [] srcHubAddress = rs.getString("HUB").split(",");
				jsonObj.put("srcHub", srcHubAddress[0]);
				array.put(jsonObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return array;
	}
	
	public String getQuery(CharSequence query, String vehicleCat,
  String vehicleTyp, String hubType) {
		String vehicleCategory = "";
		String retValue = query.toString();

		if (!vehicleCat.equals("ALL")) {
			if (vehicleCat.equals("'Dry'")) {
				vehicleCategory = "'%DC%'";
			} else {
				vehicleCategory = "'%TCL%'";
			}
		}
		if (vehicleCat.equals("ALL")) {
			if (vehicleTyp.equals("ALL")) {
				if (hubType.equals("ALL")) {
					retValue = query.toString().replace("$", "").replace("**", "AND vshd.HUB_ID in (" + allTheSelectedHubs + ") ");
				} else {
					retValue = query.toString().replace("$", "").replace("**", "AND vshd.HUB_ID in (" + hubType + ") ");
				}
			} else if (hubType.equals("ALL")) {
				retValue = query.toString().replace("$", "AND tvm.VehicleType in (" + vehicleTyp + ") ").replace("**", "AND vshd.HUB_ID in (" + allTheSelectedHubs + ") ");
			} else {
				retValue = query.toString().replace("$", "AND tvm.VehicleType in (" + vehicleTyp + ") ").replace("**", "AND vshd.HUB_ID in (" + hubType + ") ");
			}
		} else if (hubType.equals("ALL")) {
			retValue = query.toString().replace("$", "AND tvm.VehicleType like (" + vehicleCategory + ") AND tvm.VehicleType in (" + vehicleTyp + ") ").replace("**", "AND vshd.HUB_ID in (" + allTheSelectedHubs + ") ");
		} else {
			retValue = query.toString().replace("$", "AND tvm.VehicleType like (" + vehicleCategory + ") AND tvm.VehicleType in (" + vehicleTyp + ") ").replace("**",
					"AND vshd.HUB_ID in (" + hubType + ") ");
		}

		return retValue;
	}
	
	public String getAssignedQuery(CharSequence query, String vehicleCat,
			  String vehicleTyp, String hubType) {
 					String vehicleCategory = "";
					String retValue = query.toString();
					String hubNameCondition = "";
					
					hubNameCondition = " and ttd.TRIP_ID in (select TRIP_ID from AMS.dbo.DES_TRIP_DETAILS where HUB_ID in (select HUBID from AMS.dbo.LOCATION_ZONE_A where PINCODE in (select PINCODE from SMARTHUB_PINCODE_DETAILS where HUB_ID in (##))))" +
							" and ttd.TRIP_ID not in ( " +
							" select TRIP_ID from AMS.dbo.DES_TRIP_DETAILS where SEQUENCE=100 and ACT_ARR_DATETIME is not null " +
							" and HUB_ID not in (select HUBID from AMS.dbo.LOCATION_ZONE_A where PINCODE in  " +
							" (select PINCODE from SMARTHUB_PINCODE_DETAILS where HUB_ID in (##)))) ";
					
					if (!vehicleCat.equals("ALL")) {
						if (vehicleCat.equals("'Dry'")) {
							vehicleCategory = "'%DC%'";
						} else {
							vehicleCategory = "'%TCL%'";
						}
					}
					if (vehicleCat.equals("ALL")) {
						if (vehicleTyp.equals("ALL")) {
							if (hubType.equals("ALL")) {
								//all the considered HUBs are hardcoded when we encounter 'ALL' 
								retValue = query.toString().replace("$", "").replace("**", hubNameCondition.replace("##", allTheSelectedHubs) );
							} else {
								retValue = query.toString().replace("$", "").replace("**", hubNameCondition.replace("##", hubType));
							}
						} else if (hubType.equals("ALL")) {
							retValue = query.toString().replace("$", "AND tvm.VehicleType in (" + vehicleTyp + ") ").replace("**", hubNameCondition.replace("##", allTheSelectedHubs));
						} else {
							retValue = query.toString().replace("$", "AND tvm.VehicleType in (" + vehicleTyp + ") ").replace("**", hubNameCondition.replace("##", hubType));
						}
					} else if (hubType.equals("ALL")) {
						retValue = query.toString().replace("$", "AND tvm.VehicleType like (" + vehicleCategory + ") AND tvm.VehicleType in (" + vehicleTyp + ") ").replace("**", hubNameCondition.replace("##", allTheSelectedHubs));
					} else {
						retValue = query.toString().replace("$", "AND tvm.VehicleType like (" + vehicleCategory + ") AND tvm.VehicleType in (" + vehicleTyp + ") ").replace("**",
								hubNameCondition.replace("##", hubType));
					}
					return retValue;
				}

	public  JSONArray getMaintenanceListView(int systemId,int customerId,int offset, String type,String vehicleCat,String vehicleTyp,String hubTyp){
		Connection con =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONObject jsonObj= null;
		JSONArray array= null;
		String query = "";
		try {
			array= new JSONArray();
			ReportBuilderFunctions ddhhmm= new ReportBuilderFunctions();
			con=DBConnection.getConnectionToDB("AMS");
			if(type.equalsIgnoreCase("all"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("communicating"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("nonCommunicating"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("haltedCommunicating"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("idlingCommunicating"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("movedCommunicating"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("haltedNonCommunicating"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("movedNonCommunicating"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("idlingNonCommunicating"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("lessThan2hrComm"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE ma < 2881 AND cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("between2To5hrComm"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE ma >= 2881 AND ma < 7201 AND cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("moreThan5hrComm"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma >= 7201 AND ma < 14401 AND cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("moreThan10hrComm"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma >= 14401 AND cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("lessThan2hrNonComm"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma < 2881 AND cs = 'NON COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("between2To5hrNonComm"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma >= 2881 AND ma < 7201 AND cs = 'NON COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("moreThan5hrNonComm"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma >= 7201 AND ma < 14401 AND cs = 'NON COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("moreThan10hrNonComm"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma >= 14401 AND cs = 'NON COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("insideSH"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("extraKm50"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE DISTANCE > 50 AND DISTANCE < 100").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("extraKm100"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE DISTANCE >= 100 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("extraKm200"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE DISTANCE >= 200 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("movedInsideSH"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("haltedInsideSH"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("idlingInsideSH"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("insideSH2hr"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ma < 2881 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("insideSH5hr"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ma >= 2881 AND ma < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("insideSH7hr"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ma >= 7201 AND ma < 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("insideSH10hr"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE cl LIKE 'Inside SH_%' AND ma >= 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("Moved"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ms = 'Moved' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("Idling"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ms = 'Idling' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("Halted"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ms = 'Halted' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("2hr"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma < 2881 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("5hr"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma >= 2881 AND ma < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("7hr"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma >= 7201 AND ma < 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("10hr"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma >= 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("MaintenanceInsideSC"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "").replace("@", " AND ghl.LOCATION LIKE 'Inside SVC_STN_%'"), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("MaintenanceEnrouteSC"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "").replace("@", " AND ghl.LOCATION NOT LIKE 'Inside SVC_STN_%'"), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("lessThan12hr"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma < 720 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			else if(type.equalsIgnoreCase("greatherThan12hr"))
				query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", " WHERE ma > = 720 AND ma < 2881 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, customerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObj= new JSONObject();
				long maintenance_age=rs.getLong("MAINTENANCE AGE");
				jsonObj.put("vehicleNumber", rs.getString("VEHICLE NO"));
				jsonObj.put("currentLocation", rs.getString("CURRENT LOCATION"));
				jsonObj.put("distance", rs.getDouble("DISTANCE"));
				jsonObj.put("commStatus", rs.getString("COMMUNICATION STATUS"));
				jsonObj.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				String unassignedTime=(maintenance_age==0)?"NA":ddhhmm.formattedDaysHoursMinutes(maintenance_age);
				jsonObj.put("unassignedTime", unassignedTime);
				jsonObj.put("vehicleCategory", rs.getString("VEHICLE_CAT"));
				jsonObj.put("vehicleType", rs.getString("VEHICLE_TYPE"));
				jsonObj.put("currentODORoute", rs.getString("CURRENT ODO"));
				jsonObj.put("modelName", rs.getString("MODEL NAME"));
				//jsonObj.put("srcHub", rs.getString("HUB"));
				String [] srcHubAddress = rs.getString("HUB").split(",");
				jsonObj.put("srcHub", srcHubAddress[0]);
				array.put(jsonObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return array;
	}
	
	public  JSONArray getInsideSHCounts(int systemId,int customerId,int offset,String vehicleCat,String vehicleTyp,String hubTyp){
		Connection con =null;
		PreparedStatement pstmt = null, pstmt2 = null, pstmt3 = null;
		ResultSet rs = null, rs2 = null, rs3 = null;
		JSONObject jsonObj= null;
		JSONArray array= null;
		String query = "";
		
		try {
			array= new JSONArray();
			con=DBConnection.getConnectionToDB("AMS");
			int assignedInSH = 0;
			int unassignedInSH = 0;
			int maintenanceInSH = 0;
			
			int aMoved = 0;
			int aIdle = 0;
			int aHalted = 0;
			int uaMoved = 0;
			int uaIdle = 0;
			int uaHalted = 0;
			int mMoved = 0;
			int mIdle = 0;
			int mHalted = 0;
			
			query = getAssignedQuery(GET_ASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				assignedInSH ++;
				String mStatus = rs.getString("MOVEMENT STATUS");

				if(mStatus.equalsIgnoreCase("Moved")){
					aMoved ++;
				}else if(mStatus.equalsIgnoreCase("Halted")){
					aHalted ++;
				}else{
					aIdle ++;
				}
			}
			
			query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%'"), vehicleCat,vehicleTyp,hubTyp);
			pstmt2 = con.prepareStatement(query);
			pstmt2.setInt(1, offset);
			pstmt2.setInt(2, systemId);
			pstmt2.setInt(3, customerId);
			pstmt2.setInt(4, systemId);
			pstmt2.setInt(5, customerId);
			pstmt2.setInt(6, systemId);
			pstmt2.setInt(7, customerId);
			rs2=pstmt2.executeQuery();
			while(rs2.next()){
				unassignedInSH ++;
				String mStatus = rs2.getString("MOVEMENT STATUS");

				if(mStatus.equalsIgnoreCase("Moved")){
					uaMoved ++;
				}else if(mStatus.equalsIgnoreCase("Halted")){
					uaHalted ++;
				}else{
					uaIdle ++;
				}
			}
			
			query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			pstmt3 = con.prepareStatement(query);
			pstmt3.setInt(1, offset);
			pstmt3.setInt(2, systemId);
			pstmt3.setInt(3, customerId);
			pstmt3.setInt(4, offset);
			pstmt3.setInt(5, systemId);
			pstmt3.setInt(6, customerId);
			rs3=pstmt3.executeQuery();
			while(rs3.next()){
				maintenanceInSH ++;
				String mStatus = rs3.getString("MOVEMENT STATUS");

				if(mStatus.equalsIgnoreCase("Moved")){
					mMoved ++;
				}else if(mStatus.equalsIgnoreCase("Halted")){
					mHalted ++;
				}else{
					mIdle ++;
				}
			}
			
			jsonObj= new JSONObject();
			jsonObj.put("assignedISH", assignedInSH);
			jsonObj.put("unassignedISH", unassignedInSH);
			jsonObj.put("maintenanceISH", maintenanceInSH);
			jsonObj.put("aMoved", aMoved);
			jsonObj.put("aHalted", aHalted);
			jsonObj.put("aIdle", aIdle);
			jsonObj.put("uaMoved", uaMoved);
			jsonObj.put("uaHalted", uaHalted);
			jsonObj.put("uaIdle", uaIdle);
			jsonObj.put("mMoved", mMoved);
			jsonObj.put("mHalted", mHalted);
			jsonObj.put("mIdle", mIdle);
			array.put(jsonObj);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
			DBConnection.releaseConnectionToDB(con, pstmt3, rs3);
		}
		return array;
	}
	
	public  JSONArray getExtraTravelledKMSCount(int systemId,int customerId,int offset,String vehicleCat,String vehicleTyp,String hubTyp){
		Connection con =null;
		PreparedStatement pstmt = null, pstmt2 = null;
		ResultSet rs = null ,rs2 = null;
		JSONObject jsonObj= null;
		JSONArray array= null;
		String query = "";
		try {
			array= new JSONArray();
			con=DBConnection.getConnectionToDB("AMS");
			
			int unassigned50 = 0;
			int unassigned100 = 0;
			int maintenance50 = 0;
			int maintenance100 = 0;
			
			query = getQuery(GET_UNASSIGNED_VEHICLE_DETAILS.replace("#", "WHERE DISTANCE > 50"), vehicleCat,vehicleTyp,hubTyp);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, customerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				int distance = rs.getInt("DISTANCE");
				if(distance < 100){
					unassigned50 ++;
				}else if(distance >= 100){
					unassigned100 ++;
				}
			}
            
			query = getQuery(GET_MAINTENANCE_VEHICLE_DETAILS.replace("#", "WHERE DISTANCE > 50").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			pstmt2 = con.prepareStatement(query);
			pstmt2.setInt(1, offset);
			pstmt2.setInt(2, systemId);
			pstmt2.setInt(3, customerId);
			pstmt2.setInt(4, offset);
			pstmt2.setInt(5, systemId);
			pstmt2.setInt(6, customerId);
			rs2=pstmt2.executeQuery();
			while(rs2.next()){
				int distance = rs2.getInt("DISTANCE");
				if(distance < 100){
					maintenance50 ++;
				}else if(distance >= 100){
					maintenance100 ++;
				}
			}
			
			jsonObj= new JSONObject();
			jsonObj.put("unassigned50", unassigned50);
			jsonObj.put("unassigned100", unassigned100);
			jsonObj.put("maintenance50", maintenance50);
			jsonObj.put("maintenance100", maintenance100);
			array.put(jsonObj);
		
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return array;
	}
	public static ArrayList<String> getDriverName(Connection con ,int systemId,int customerId,int tripId){
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		ArrayList<String> driver = new ArrayList<String>();
		try {
			pstmt=con.prepareStatement(GET_DRIVER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, tripId);
			rs=pstmt.executeQuery();
			for(int i =0 ; i<2 ; i++){
				if(rs.next()){
					String name=rs.getString("DriverName");
					String mobile=rs.getString("Mobile");
					driver.add(name);
					driver.add(mobile);
				}else{
					driver.add("");
					driver.add("");
				}	
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return driver;
	}

	public  JSONArray getVehiclesForMap(int systemId,int clientId,int statusId,int offset) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String query="";;
			if(statusId==0){
				query=GET_MAP_DETAILS.replace("#", "");
			}else if(statusId==4){
				query=GET_MAP_DETAILS.replace("#", " and  Status_id="+statusId+" ");
			}
			else if(statusId==8){
				query=GET_MAP_DETAILS.replace("#", " and  Status_id="+statusId+" ");
			}else if(statusId==16){
				query=GET_MAP_DETAILS.replace("#", " and  Status_id="+statusId+" ");
			}
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, systemId);
			pstmt.setInt(9, clientId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNo", rs.getString("ASSET_NUMBER"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("lon", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				if(!rs.getString("GMT").contains("1900")){
					VehicleDetailsObject.put("gmt", sdf.format(sdfDB.parse(rs.getString("GMT"))));
				}else{
					VehicleDetailsObject.put("gmt", "");
				}
				VehicleDetailsObject.put("tripStatus", rs.getString("TRIP_STATUS"));
				VehicleDetailsObject.put("custName", rs.getString("CUSTOMER_NAME"));
				VehicleDetailsObject.put("shipmentId", rs.getString("SHIPMENT_ID"));
				VehicleDetailsObject.put("LRNO", rs.getString("LR_NO"));
				if(rs.getInt("DELAY")<0){
					VehicleDetailsObject.put("delay", 0);
				}else{
					VehicleDetailsObject.put("delay", rs.getString("DELAY"));
				}
				VehicleDetailsObject.put("weather", "");
				VehicleDetailsObject.put("driverName", rs.getString("DRIVER_NAME"));

				String ETHA="";
				if(!rs.getString("ETHA").contains("1900")){
					ETHA = sdf.format(sdfDB.parse(rs.getString("ETHA")));
				}
				String ETA="";
				String ATD="";
				String endDate="";
				if(!rs.getString("ETA").contains("1900")){
					ETA = sdf.format(sdfDB.parse(rs.getString("ETA")));
				}

				VehicleDetailsObject.put("etaDest", ETA);
				VehicleDetailsObject.put("etaNextPt", ETHA);
				if(!rs.getString("ATD").contains("1900")){
					ATD = sdf.format(sdfDB.parse(rs.getString("ATD")));
				}
				String RouteId = rs.getString("ROUTE_ID");
				VehicleDetailsObject.put("ATD", ATD);
				VehicleDetailsObject.put("routeIdHidden", RouteId);
				VehicleDetailsObject.put("status", rs.getString("STATUS"));

				String TripId = rs.getString("TRIP_ID");
				VehicleDetailsObject.put("tripId", TripId);

				if(!rs.getString("endDate").contains("1900")){
					endDate = sdf.format(sdfDB.parse(rs.getString("endDate")));
				}
				VehicleDetailsObject.put("endDateHidden", endDate);
				String STD=null;
				if(!rs.getString("STD").contains("1900")){
					STD = sdf.format(sdfDB.parse(rs.getString("STD")));
				}
				VehicleDetailsObject.put("STD", STD);
				VehicleDetailsObject.put("T1", rs.getString("T1"));
				VehicleDetailsObject.put("T2", rs.getString("T2"));
				VehicleDetailsObject.put("T3", rs.getString("T3"));
				VehicleDetailsObject.put("productLine", rs.getString("PRODUCT_LINE"));
				if(rs.getString("Humidity").equals("99999.0")){
					VehicleDetailsObject.put("Humidity", "NA");
				}else{
					VehicleDetailsObject.put("Humidity", rs.getString("Humidity"));
				}
				VehicleDetailsObject.put("tripNo", rs.getString("TRIP_NO"));
				VehicleDetailsObject.put("routeName", rs.getString("ROUTE_NAME"));
				VehicleDetailsObject.put("currentStoppageTime", stoppageTime(rs.getString("STOPPAGE_TIME")));
				VehicleDetailsObject.put("currentIdlingTime", stoppageTime(rs.getString("IDLE_TIME")));
				VehicleDetailsObject.put("speed", rs.getString("SPEED"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION_STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVED_STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);

			}
			
			if(statusId==0 || statusId==16){
				pstmt=con.prepareStatement(UNASSIGNED_NON_TRIP_MAP_DETAILS);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				rs=pstmt.executeQuery();
				while(rs.next()){
					VehicleDetailsObject = new JSONObject();
					VehicleDetailsObject.put("vehicleNo", rs.getString("ASSET_NUMBER"));
					VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
					VehicleDetailsObject.put("lon", rs.getString("LONGITUDE"));
					VehicleDetailsObject.put("location", rs.getString("LOCATION"));
					if(!rs.getString("GMT").contains("1900")){
						VehicleDetailsObject.put("gmt", sdf.format(sdfDB.parse(rs.getString("GMT"))));
					}else{
						VehicleDetailsObject.put("gmt", "");
					}
					VehicleDetailsObject.put("tripStatus", "NA");
					VehicleDetailsObject.put("custName", "NA");
					VehicleDetailsObject.put("shipmentId", "NA");
					VehicleDetailsObject.put("LRNO", "NA");
					VehicleDetailsObject.put("delay", 0);
					
					VehicleDetailsObject.put("weather", "NA");
					VehicleDetailsObject.put("driverName", "NA");

					VehicleDetailsObject.put("etaDest", "NA");
					VehicleDetailsObject.put("etaNextPt", "NA");
					VehicleDetailsObject.put("ATD", "NA");
					VehicleDetailsObject.put("routeIdHidden", "NA");
					VehicleDetailsObject.put("status","NA");
					VehicleDetailsObject.put("tripId", "NA");
					VehicleDetailsObject.put("endDateHidden", "NA");
					VehicleDetailsObject.put("STD", "NA");
					VehicleDetailsObject.put("T1", "NA");
					VehicleDetailsObject.put("T2", "NA");
					VehicleDetailsObject.put("T3", "NA");
					VehicleDetailsObject.put("productLine", "NA");
					VehicleDetailsObject.put("Humidity", "NA");
					VehicleDetailsObject.put("tripNo", "NA");
					VehicleDetailsObject.put("routeName", "NA");
					VehicleDetailsObject.put("currentStoppageTime", stoppageTime(rs.getString("STOPPAGE_TIME")));
					VehicleDetailsObject.put("currentIdlingTime", stoppageTime(rs.getString("IDLE_TIME")));
					VehicleDetailsObject.put("speed", rs.getString("SPEED"));
					VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION_STATUS"));
					VehicleDetailsObject.put("movingStatus", rs.getString("MOVED_STATUS"));
					VehicleDetailsArray.put(VehicleDetailsObject);

				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return VehicleDetailsArray;

	}
	
	public  JSONArray getAssignedVehiclesForMap(int systemId,int clientId,int offset, String commStatus, int days,String moveStatus,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if (commStatus.equalsIgnoreCase("ALL")) {
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(commStatus.equalsIgnoreCase("Empty")){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "").replace("@", " AND ttd.TRIP_CUSTOMER_TYPE LIKE 'Empty Trip'"), vehicleCat,vehicleTyp,hubTyp);
			}else if(commStatus.equalsIgnoreCase("Customer")){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "").replace("@", " AND ttd.TRIP_CUSTOMER_TYPE NOT LIKE 'Empty Trip'"), vehicleCat,vehicleTyp,hubTyp);
			}else if (commStatus.equalsIgnoreCase("Yes")) {
				if(moveStatus.equalsIgnoreCase("Moved")){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Halted")){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Idling")){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 2){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND a.PLANNED_ARR_DATETIME is not null and a.PLANNED_ARR_DATETIME > getutcdate() and datediff(mi,getutcdate(),a.PLANNED_ARR_DATETIME) > 2880  ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 5){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND aa >= 2881 AND aa < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 7){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND aa >= 7201 AND aa < 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 10){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND aa >= 14401").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else{
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}
			} else if (commStatus.equalsIgnoreCase("No")) {
				if(moveStatus.equalsIgnoreCase("Moved")){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Halted")){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Idling")){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 2){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND a.PLANNED_ARR_DATETIME is not null and a.PLANNED_ARR_DATETIME > getutcdate() and datediff(mi,getutcdate(),a.PLANNED_ARR_DATETIME) > 2880 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 5){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND aa >= 2881 AND aa < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 7){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND aa >= 7201 AND aa < 14401").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 10){
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND aa >= 14401").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else{
					query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}
			}
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, offset);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("tripNO", rs.getString("TRIP NO"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				if(rs.getString("HUMIDITY").equals("99999.0"))
					VehicleDetailsObject.put("humidity", "NA");
				else
					VehicleDetailsObject.put("humidity", rs.getString("HUMIDITY"));
				VehicleDetailsObject.put("tripId", rs.getString("TRIP ID"));
				VehicleDetailsObject.put("routeName", rs.getString("ROUTE NAME"));
				VehicleDetailsObject.put("currentStoppageTime", stoppageTime(rs.getString("STOPPAGE TIME")));
				VehicleDetailsObject.put("currentIdlingTime", stoppageTime(rs.getString("IDLE TIME")));
				VehicleDetailsObject.put("speed", rs.getString("SPEED"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsObject.put("status", rs.getString("STATUS"));
				VehicleDetailsObject.put("etha", rs.getString("ETHA"));
				VehicleDetailsObject.put("eta", rs.getString("ETA"));
				VehicleDetailsObject.put("driverNames", rs.getString("DRIVER NAME"));
				if (rs.getInt("DELAY") > 0)
					VehicleDetailsObject.put("delay", rs.getString("DELAY"));
				else
					VehicleDetailsObject.put("delay", "NA");
				VehicleDetailsObject.put("custName", rs.getString("CUSTOMER NAME"));
				VehicleDetailsObject.put("tripStatus", rs.getString("TRIP STATUS"));
				VehicleDetailsObject.put("t1", rs.getString("T1"));
				VehicleDetailsObject.put("t2", rs.getString("T2"));
				VehicleDetailsObject.put("t3", rs.getString("T3"));
				VehicleDetailsObject.put("productLine", rs.getString("PRODUCT LINE"));
				VehicleDetailsObject.put("routeId", rs.getString("ROUTE ID"));
				VehicleDetailsObject.put("std", rs.getString("STD"));
				VehicleDetailsObject.put("gmt", rs.getString("GMT"));
				VehicleDetailsObject.put("atd", rs.getString("ATD"));
				VehicleDetailsObject.put("endDate", rs.getString("endDate"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public  JSONArray getAssignedVehiclesForMapBasedOnTripType(int systemId,int clientId,int offset, String type,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if(type.equalsIgnoreCase("Dry")){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", " WHERE pLine = 'Dry' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else{
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", " WHERE pLine = 'TCL' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, offset);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("tripNO", rs.getString("TRIP NO"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				if(rs.getString("HUMIDITY").equals("99999.0"))
					VehicleDetailsObject.put("humidity", "NA");
				else
					VehicleDetailsObject.put("humidity", rs.getString("HUMIDITY"));
				VehicleDetailsObject.put("tripId", rs.getString("TRIP ID"));
				VehicleDetailsObject.put("routeName", rs.getString("ROUTE NAME"));
				VehicleDetailsObject.put("currentStoppageTime", stoppageTime(rs.getString("STOPPAGE TIME")));
				VehicleDetailsObject.put("currentIdlingTime", stoppageTime(rs.getString("IDLE TIME")));
				VehicleDetailsObject.put("speed", rs.getString("SPEED"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsObject.put("status", rs.getString("STATUS"));
				VehicleDetailsObject.put("etha", rs.getString("ETHA"));
				VehicleDetailsObject.put("eta", rs.getString("ETA"));
				VehicleDetailsObject.put("driverNames", rs.getString("DRIVER NAME"));
				if (rs.getInt("DELAY") > 0)
					VehicleDetailsObject.put("delay", rs.getString("DELAY"));
				else
					VehicleDetailsObject.put("delay", "NA");
				VehicleDetailsObject.put("custName", rs.getString("CUSTOMER NAME"));
				VehicleDetailsObject.put("tripStatus", rs.getString("TRIP STATUS"));
				VehicleDetailsObject.put("t1", rs.getString("T1"));
				VehicleDetailsObject.put("t2", rs.getString("T2"));
				VehicleDetailsObject.put("t3", rs.getString("T3"));
				VehicleDetailsObject.put("productLine", rs.getString("PRODUCT LINE"));
				VehicleDetailsObject.put("routeId", rs.getString("ROUTE ID"));
				VehicleDetailsObject.put("std", rs.getString("STD"));
				VehicleDetailsObject.put("gmt", rs.getString("GMT"));
				VehicleDetailsObject.put("atd", rs.getString("ATD"));
				VehicleDetailsObject.put("endDate", rs.getString("endDate"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public  JSONArray getAssignedVehiclesMapDetailsForISH(int systemId,int clientId,int offset, int days,String moveStatus,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if(moveStatus.equalsIgnoreCase("Moved")){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE LOCATION LIKE 'Inside SH_%' AND ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Idling")){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE LOCATION LIKE 'Inside SH_%' AND ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Halted")){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE LOCATION LIKE 'Inside SH_%' AND ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 2){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE LOCATION LIKE 'Inside SH_%' AND a.PLANNED_ARR_DATETIME is not null and a.PLANNED_ARR_DATETIME > getutcdate() and datediff(dd,a.PLANNED_ARR_DATETIME,getutcdate()) > 2 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 5){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE LOCATION LIKE 'Inside SH_%' AND aa >= 2881 AND aa < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 7){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE LOCATION LIKE 'Inside SH_%' AND aa >= 7201 AND aa < 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 10){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE LOCATION LIKE 'Inside SH_%' AND aa >= 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("") && days == 0){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE LOCATION LIKE 'Inside SH_%' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}	
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, offset);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("tripNO", rs.getString("TRIP NO"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				if(rs.getString("HUMIDITY").equals("99999.0"))
					VehicleDetailsObject.put("humidity", "NA");
				else
					VehicleDetailsObject.put("humidity", rs.getString("HUMIDITY"));
				VehicleDetailsObject.put("tripId", rs.getString("TRIP ID"));
				VehicleDetailsObject.put("routeName", rs.getString("ROUTE NAME"));
				VehicleDetailsObject.put("currentStoppageTime", stoppageTime(rs.getString("STOPPAGE TIME")));
				VehicleDetailsObject.put("currentIdlingTime", stoppageTime(rs.getString("IDLE TIME")));
				VehicleDetailsObject.put("speed", rs.getString("SPEED"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsObject.put("status", rs.getString("STATUS"));
				VehicleDetailsObject.put("etha", rs.getString("ETHA"));
				VehicleDetailsObject.put("eta", rs.getString("ETA"));
				VehicleDetailsObject.put("driverNames", rs.getString("DRIVER NAME"));
				if (rs.getInt("DELAY") > 0)
					VehicleDetailsObject.put("delay", rs.getString("DELAY"));
				else
					VehicleDetailsObject.put("delay", "NA");
				VehicleDetailsObject.put("custName", rs.getString("CUSTOMER NAME"));
				VehicleDetailsObject.put("tripStatus", rs.getString("TRIP STATUS"));
				VehicleDetailsObject.put("t1", rs.getString("T1"));
				VehicleDetailsObject.put("t2", rs.getString("T2"));
				VehicleDetailsObject.put("t3", rs.getString("T3"));
				VehicleDetailsObject.put("productLine", rs.getString("PRODUCT LINE"));
				VehicleDetailsObject.put("routeId", rs.getString("ROUTE ID"));
				VehicleDetailsObject.put("std", rs.getString("STD"));
				VehicleDetailsObject.put("gmt", rs.getString("GMT"));
				VehicleDetailsObject.put("atd", rs.getString("ATD"));
				VehicleDetailsObject.put("endDate", rs.getString("endDate"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public  JSONArray getAssignedVehiclesMapDetails(int systemId,int clientId,int offset, int days,String moveStatus,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if(moveStatus.equalsIgnoreCase("Moved")){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Idling")){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Halted")){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 2){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE a.PLANNED_ARR_DATETIME is not null and a.PLANNED_ARR_DATETIME > getutcdate() and datediff(mi,getutcdate(),a.PLANNED_ARR_DATETIME) > 2880  ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 5){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE aa >= 2881 AND aa < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 7){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE aa >= 7201 AND aa < 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 10){
				query = getAssignedQuery(GET_ASSIGNED_MAP_DETAILS.replace("#", "WHERE aa >= 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}	
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, offset);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("tripNO", rs.getString("TRIP NO"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				if(rs.getString("HUMIDITY").equals("99999.0"))
					VehicleDetailsObject.put("humidity", "NA");
				else
					VehicleDetailsObject.put("humidity", rs.getString("HUMIDITY"));
				VehicleDetailsObject.put("tripId", rs.getString("TRIP ID"));
				VehicleDetailsObject.put("routeName", rs.getString("ROUTE NAME"));
				VehicleDetailsObject.put("currentStoppageTime", stoppageTime(rs.getString("STOPPAGE TIME")));
				VehicleDetailsObject.put("currentIdlingTime", stoppageTime(rs.getString("IDLE TIME")));
				VehicleDetailsObject.put("speed", rs.getString("SPEED"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsObject.put("status", rs.getString("STATUS"));
				VehicleDetailsObject.put("etha", rs.getString("ETHA"));
				VehicleDetailsObject.put("eta", rs.getString("ETA"));
				VehicleDetailsObject.put("driverNames", rs.getString("DRIVER NAME"));
				if (rs.getInt("DELAY") > 0)
					VehicleDetailsObject.put("delay", rs.getString("DELAY"));
				else
					VehicleDetailsObject.put("delay", "NA");
				VehicleDetailsObject.put("custName", rs.getString("CUSTOMER NAME"));
				VehicleDetailsObject.put("tripStatus", rs.getString("TRIP STATUS"));
				VehicleDetailsObject.put("t1", rs.getString("T1"));
				VehicleDetailsObject.put("t2", rs.getString("T2"));
				VehicleDetailsObject.put("t3", rs.getString("T3"));
				VehicleDetailsObject.put("productLine", rs.getString("PRODUCT LINE"));
				VehicleDetailsObject.put("routeId", rs.getString("ROUTE ID"));
				VehicleDetailsObject.put("std", rs.getString("STD"));
				VehicleDetailsObject.put("gmt", rs.getString("GMT"));
				VehicleDetailsObject.put("atd", rs.getString("ATD"));
				VehicleDetailsObject.put("endDate", rs.getString("endDate"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	
	public  JSONArray getUnassignedVehiclesForMap(int systemId,int clientId,int offset, String commStatus, int days,String moveStatus,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if (commStatus.equalsIgnoreCase("ALL")) {
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", ""), vehicleCat,vehicleTyp,hubTyp);
			} else if (commStatus.equalsIgnoreCase("Yes")) {
				if(moveStatus.equalsIgnoreCase("Moved")){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Moved'"), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Halted")){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Halted'"), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Idling")){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Idling'"), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 2){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ua < 2881 "), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 5){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ua >= 2881 AND ua < 7201 "), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 7){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ua >= 7201 AND ua < 14401"), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 10){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ua >= 14401"), vehicleCat,vehicleTyp,hubTyp);
				}else{
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
				}
			} else if (commStatus.equalsIgnoreCase("No")) {
				if(moveStatus.equalsIgnoreCase("Moved")){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Moved'"), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Halted")){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Halted'"), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Idling")){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Idling'"), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 2){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ua < 2881 "), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 5){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ua >= 2881 AND ua < 7201 "), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 7){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ua >= 7201 AND ua < 14401 "), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 10){
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ua >= 14401"), vehicleCat,vehicleTyp,hubTyp);
				}else{
					query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING'"), vehicleCat,vehicleTyp,hubTyp);
				}
			}
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("distance", rs.getString("DISTANCE"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	
	public  JSONArray getMaintenanceVehiclesForMap(int systemId,int clientId,int offset, String commStatus, int days,String moveStatus,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if (commStatus.equalsIgnoreCase("ALL")) {
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			} else if (commStatus.equalsIgnoreCase("insideSC")) {
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "").replace("@", " AND ghl.LOCATION LIKE 'Inside SVC_STN_%'"), vehicleCat,vehicleTyp,hubTyp);
			}else if (commStatus.equalsIgnoreCase("enrouteSC")) {
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "").replace("@", " AND ghl.LOCATION NOT LIKE 'Inside SVC_STN_%'"), vehicleCat,vehicleTyp,hubTyp);
			}else if (commStatus.equalsIgnoreCase("Yes")) {
				if(moveStatus.equalsIgnoreCase("Moved")){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Halted")){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Idling")){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 2){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ma < 2881 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 5){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ma >= 2881 AND ma < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 7){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ma >= 7201 AND ma < 14401").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 10){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING' AND ma >= 14401").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else{
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}
			} else if (commStatus.equalsIgnoreCase("No")) {
				if(moveStatus.equalsIgnoreCase("Moved")){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Halted")){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(moveStatus.equalsIgnoreCase("Idling")){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 2){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ma < 2881 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 5){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ma >= 2881 AND ma < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 7){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ma >= 7201 AND ma < 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else if(days == 10){
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING' AND ma >= 14401").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}else{
					query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cs = 'NON COMMUNICATING'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
				}
			}
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("distance", rs.getString("DISTANCE"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	
	public  JSONArray getUnassignedVehiclesMapDetailsForISH(int systemId,int clientId,int offset, int days,String moveStatus,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if(moveStatus.equalsIgnoreCase("Moved")){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ms = 'Moved'"), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Idling")){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ms = 'Idling'"), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Halted")){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ms = 'Halted'"), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 2){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ua < 2881 "), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 5){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ua >= 2881 AND ua < 7201 "), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 7){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ua >= 7201 AND ua < 14401 "), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 10){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ua >= 14401"), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("") && days == 0){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' "), vehicleCat,vehicleTyp,hubTyp);
			}	
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("distance", rs.getString("DISTANCE"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	
	public  JSONArray getMaintenanceVehiclesMapDetailsForISH(int systemId,int clientId,int offset, int days,String moveStatus,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if(moveStatus.equalsIgnoreCase("Moved")){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Idling")){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Halted")){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 2){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ma < 2881 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 5){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ma >= 2881 AND ma < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 7){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ma > 7201 AND ma < 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 10){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' AND ma >= 14401").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("") && days == 0){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE cl LIKE 'Inside SH_%' ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}	
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("distance", rs.getString("DISTANCE"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public  JSONArray getUnassignedVehiclesMapDetails(int systemId,int clientId,int offset, int days,String moveStatus,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if(moveStatus.equalsIgnoreCase("Moved")){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE ms = 'Moved'"), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Idling")){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE ms = 'Idling'"), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Halted")){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE ms = 'Halted'"), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 2){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE ua < 2881 "), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 5){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE ua >= 2881 AND ua < 7201 "), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 7){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE ua >= 7201 AND ua < 14401 "), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 10){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", "WHERE ua >= 14401"), vehicleCat,vehicleTyp,hubTyp);
			}	
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("distance", rs.getString("DISTANCE"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	
	public  JSONArray getMaintenanceVehiclesMapDetails(int systemId,int clientId,int offset, int days,String moveStatus,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if(moveStatus.equalsIgnoreCase("Moved")){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE ms = 'Moved'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Idling")){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE ms = 'Idling'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(moveStatus.equalsIgnoreCase("Halted")){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE ms = 'Halted'").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 2){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE ma < 2881 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 5){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE ma >= 2881 AND ma < 7201 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 7){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE ma >= 7201 AND ma < 14401 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 10){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE ma >= 14401").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else if(days == 11){
			query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE ma < 720").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
		    }else if(days == 12){
			query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", "WHERE ma >= 720 AND ma < 2881 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
		    }	
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("distance", rs.getString("DISTANCE"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public  JSONArray getUnassignedExtraTravelledKMSDetailsMaps(int systemId,int clientId,int offset, String type,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if(type.equalsIgnoreCase("extraKm50")){
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", " WHERE DISTANCE > 50 AND DISTANCE < 100 "), vehicleCat,vehicleTyp,hubTyp);
			}else{
				query = getQuery(GET_UNASSIGNED_MAP_DETAILS.replace("#", " WHERE DISTANCE >= 100 "), vehicleCat,vehicleTyp,hubTyp);
			}
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("distance", rs.getString("DISTANCE"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	
	public  JSONArray getMaintenanceExtraTravelledKMSDetailsMaps(int systemId,int clientId,int offset, String type,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if(type.equalsIgnoreCase("extraKm50")){
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", " WHERE DISTANCE > 50 AND DISTANCE < 100 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}else{
				query = getQuery(GET_MAINTENANCE_MAP_DETAILS.replace("#", " WHERE DISTANCE >= 100 ").replace("@", ""), vehicleCat,vehicleTyp,hubTyp);
			}
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, clientId);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("distance", rs.getString("DISTANCE"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public double stoppageTime(String stop){
		double d = Double.parseDouble(stop);
		double value=0;

		int hrs = (int)d;
		int min = (int)((d - hrs) * 60);
		String idletime="0.0";
		if(min < 10){
			idletime=String.valueOf(hrs)+".0"+String.valueOf(min);
		}else{
			idletime=String.valueOf(hrs)+"."+String.valueOf(min);
		}
		if (idletime!=null) {
			value=Double.parseDouble(idletime);
		} else {
			value=0.0;
		}
		return value;
	}
	
	/*
	 * Utilization dashboard config methods
	 * 
	 */
	public  JSONArray getCustomerDetails(int systemId) {
		JSONArray array = new JSONArray();
		JSONObject json =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(" select NAME,CUSTOMER_ID from ADMINISTRATOR.dbo.CUSTOMER_MASTER where SYSTEM_ID=?  ");
			pstmt.setInt(1, systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				json = new JSONObject();
				json.put("CustName", rs.getString("NAME"));
				json.put("CustId", rs.getInt("CUSTOMER_ID"));
				array.put(json);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return array;
	}


	public  JSONArray getUtilConfig(int systemId,int clientId) {
		JSONArray array = new JSONArray();
		JSONObject json =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(" select  b.NAME,b.CUSTOMER_ID,a.* from AMS.dbo.DISTANCE_ALERT a inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.SYSTEM_ID=b.SYSTEM_ID and b.CUSTOMER_ID=a.CUSTOMER_ID ");
			rs=pstmt.executeQuery();
			int count=0;
			while(rs.next()){
				json = new JSONObject();
				json.put("slno", ++count);
				json.put("custName", rs.getString("NAME"));
				json.put("custId", rs.getInt("CUSTOMER_ID"));
				json.put("Id", rs.getInt("ID"));
				json.put("nonCommMin", rs.getInt("NON_COMM_DURATION_MINS"));
				json.put("alertDist", rs.getInt("ALERT_DISTANCE_KM"));
				json.put("mailList", rs.getString("MAIL_LIST"));
				json.put("speedLimit", rs.getInt("SPEED_LIMIT"));
				array.put(json);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return array;
	}

	public  String InsertUtilConfig(int nonCommMin,int alertDist,String mailList,int speedlimit,int systemId,int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message=null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(" insert into AMS.dbo.DISTANCE_ALERT values (?,?,?,?,?,?) ");
			pstmt.setInt(1, nonCommMin);
			pstmt.setInt(2, alertDist);
			pstmt.setString(3, mailList);
			pstmt.setInt(4, speedlimit);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId); //not login custId
			int inserted=pstmt.executeUpdate();
			if(inserted>0){
				message="Saved Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public  String UpdateUtilConfig(int id,int nonCommMin,int alertDist,String mailList) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message=null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(" update  AMS.dbo.DISTANCE_ALERT set NON_COMM_DURATION_MINS=?,ALERT_DISTANCE_KM=?,MAIL_LIST=? where ID=? ");
			pstmt.setInt(1, nonCommMin);
			pstmt.setInt(2, alertDist);
			pstmt.setString(3, mailList);
			pstmt.setInt(4, id);
			int updated=pstmt.executeUpdate();
			if(updated>0){
				message="Updated Successfully";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}

	public JSONArray getLoadingStatusCounts(int systemId, int clientId,String vehicleCat,String vehicleTyp,String hubTyp) {
		Connection con =null;
		PreparedStatement pstmt=null, pstmt2 = null;
		ResultSet rs=null, rs2 = null;
		JSONArray jsonArray = new JSONArray();
		String query = "";
		
		try {
			JSONObject json = new JSONObject();
			con=DBConnection.getConnectionToDB("AMS");
			
			int loadingCount = 0;
			int unloadingCount = 0;
			
			query = getAssignedQuery(GET_ASSIGNED_LOADING_COUNT, vehicleCat,vehicleTyp,hubTyp);
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs=pstmt.executeQuery();
			if (rs.next()) {
				loadingCount = rs.getInt("LoadingCount");
			}
			
			query = getAssignedQuery(GET_ASSIGNED_UNLOADING_COUNT, vehicleCat,vehicleTyp,hubTyp);
			pstmt2=con.prepareStatement(query);
			pstmt2.setInt(1, systemId);
			pstmt2.setInt(2, clientId);
			rs2=pstmt2.executeQuery();
			if (rs2.next()) {
				unloadingCount = rs2.getInt("UnloadingCount");
			}
			
			json.put("loadingCount", loadingCount);
			json.put("unloadingCount", unloadingCount);
			jsonArray.put(json);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
		}
		return jsonArray;
	}
	
	public  JSONArray getAssignedLoadingUnloadingDetails(int systemId,int customerId,int offset,String type,String vehicleCat,String vehicleTyp,String hubTyp){
		Connection con =null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		JSONObject jsonObj= null;
		JSONArray array= null;
		String query = "";
		try {
			array= new JSONArray();
			ReportBuilderFunctions ddhhmm= new ReportBuilderFunctions();
			con=DBConnection.getConnectionToDB("AMS");
			if (type.equalsIgnoreCase("loading"))
				query = getAssignedQuery(GET_ASSIGNED_LOADING_UNLOADING_DETAILS.replace("#", " AND ttd.ACT_SRC_ARR_DATETIME IS NOT NULL AND ttd.ACTUAL_TRIP_START_TIME IS NULL "), vehicleCat,vehicleTyp,hubTyp);
			else
				query = getAssignedQuery(GET_ASSIGNED_LOADING_UNLOADING_DETAILS.replace("#", " AND dt.ACT_ARR_DATETIME IS NOT NULL AND ttd.ACTUAL_TRIP_END_TIME IS NULL "), vehicleCat,vehicleTyp,hubTyp);
			
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, customerId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObj= new JSONObject();
				int tripId=rs.getInt("TRIP ID");
				ArrayList<String> driverDetais = getDriverName(con, systemId, customerId, tripId);
				long assigned_age=rs.getLong("ASSIGNED AGE");
				jsonObj.put("vehicleNumber", rs.getString("VEHICLE NO."));
				jsonObj.put("currentLocation", rs.getString("CURRENT LOCATION"));
				jsonObj.put("routeId", rs.getString("ROUTE ID"));
				jsonObj.put("tripNo", rs.getString("TRIP NO."));
				jsonObj.put("tripId", rs.getString("TRIP ID"));
				jsonObj.put("distance", rs.getDouble("ACTUAL DISTANCE")!=0?rs.getDouble("ACTUAL DISTANCE"):rs.getDouble("DISTANCE"));
				jsonObj.put("driver1", driverDetais.get(0));
				jsonObj.put("driver1Contact", driverDetais.get(1));
				jsonObj.put("driver2", driverDetais.get(2));
				jsonObj.put("driver2Contact", driverDetais.get(3));
				jsonObj.put("tamperCount", rs.getInt("GPS TAMPERING COUNT"));
				jsonObj.put("commStatus", rs.getString("COMMUNICATION STATUS"));
				jsonObj.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				String assignedTime=(assigned_age==0)?"NA":ddhhmm.formattedDaysHoursMinutes(assigned_age);
				jsonObj.put("unassignedTime", assignedTime);
				jsonObj.put("vehicleCategory", rs.getString("VEHICLE_CAT"));
				jsonObj.put("vehicleType", rs.getString("VEHICLE_TYPE"));
				jsonObj.put("currentODORoute", rs.getString("CURRENT ODO"));
				jsonObj.put("modelName", rs.getString("MODEL NAME"));
				jsonObj.put("customerName", rs.getString("CUSTOMER_NAME"));
				//jsonObj.put("srcHub", rs.getString("HUB"));
				String [] srcHubAddress = rs.getString("HUB").split(",");
				jsonObj.put("srcHub", srcHubAddress[0]);
				array.put(jsonObj);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return array;
	}
	
	public  JSONArray getAssignedLoadingUnloadingMapDetails(int systemId,int clientId,int offset,String type,String vehicleCat,String vehicleTyp,String hubTyp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject =null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con=DBConnection.getConnectionToDB("AMS");
			String query = "";
			
			if (type.equalsIgnoreCase("loading")) 
				query = getAssignedQuery(GET_ASSIGNED_LOADING_UNLOADING_MAP_DETAILS.replace("#", " AND ttd.ACT_SRC_ARR_DATETIME IS NOT NULL AND ttd.ACTUAL_TRIP_START_TIME IS NULL "), vehicleCat,vehicleTyp,hubTyp);
			else
				query = getAssignedQuery(GET_ASSIGNED_LOADING_UNLOADING_MAP_DETAILS.replace("#", " AND dt.ACT_ARR_DATETIME IS NOT NULL AND ttd.ACTUAL_TRIP_END_TIME IS NULL "), vehicleCat,vehicleTyp,hubTyp);
				
			pstmt=con.prepareStatement(query);
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			pstmt.setInt(3, offset);
			pstmt.setInt(4, offset);
			pstmt.setInt(5, offset);
			pstmt.setInt(6, offset);
			pstmt.setInt(7, offset);
			pstmt.setInt(8, offset);
			pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			rs=pstmt.executeQuery();
			
			while(rs.next()){
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleNO", rs.getString("VEHICLE NO"));
				VehicleDetailsObject.put("tripNO", rs.getString("TRIP NO"));
				VehicleDetailsObject.put("lat", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("long", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				if(rs.getString("HUMIDITY").equals("99999.0"))
					VehicleDetailsObject.put("humidity", "NA");
				else
					VehicleDetailsObject.put("humidity", rs.getString("HUMIDITY"));
				VehicleDetailsObject.put("tripId", rs.getString("TRIP ID"));
				VehicleDetailsObject.put("routeName", rs.getString("ROUTE NAME"));
				VehicleDetailsObject.put("currentStoppageTime", stoppageTime(rs.getString("STOPPAGE TIME")));
				VehicleDetailsObject.put("currentIdlingTime", stoppageTime(rs.getString("IDLE TIME")));
				VehicleDetailsObject.put("speed", rs.getString("SPEED"));
				VehicleDetailsObject.put("CommStatus", rs.getString("COMMUNICATION STATUS"));
				VehicleDetailsObject.put("movingStatus", rs.getString("MOVEMENT STATUS"));
				VehicleDetailsObject.put("status", rs.getString("STATUS"));
				VehicleDetailsObject.put("etha", rs.getString("ETHA"));
				VehicleDetailsObject.put("eta", rs.getString("ETA"));
				VehicleDetailsObject.put("driverNames", rs.getString("DRIVER NAME"));
				if (rs.getInt("DELAY") > 0)
					VehicleDetailsObject.put("delay", rs.getString("DELAY"));
				else
					VehicleDetailsObject.put("delay", "NA");
				VehicleDetailsObject.put("custName", rs.getString("CUSTOMER NAME"));
				VehicleDetailsObject.put("tripStatus", rs.getString("TRIP STATUS"));
				VehicleDetailsObject.put("t1", rs.getString("T1"));
				VehicleDetailsObject.put("t2", rs.getString("T2"));
				VehicleDetailsObject.put("t3", rs.getString("T3"));
				VehicleDetailsObject.put("productLine", rs.getString("PRODUCT LINE"));
				VehicleDetailsObject.put("routeId", rs.getString("ROUTE ID"));
				VehicleDetailsObject.put("std", rs.getString("STD"));
				VehicleDetailsObject.put("gmt", rs.getString("GMT"));
				VehicleDetailsObject.put("atd", rs.getString("ATD"));
				VehicleDetailsObject.put("endDate", rs.getString("endDate"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
}

