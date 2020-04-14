package t4u.functions;

public class FleetMaintanceStatements {

	public static final String GET_BRANCH_NAME_USER = "select a.BranchId,a.BranchName,a.Category from Maple.dbo.tblBranchMaster a left outer join Users b " +
	                                                   "on a.BranchId=b.BranchId where b.System_id=? and b.User_id=?";

	public static final String GET_VEHICLE_TYPES = " select distinct VehicleType from AMS.dbo.tblVehicleMaster vt "+
	" inner join AMS.dbo.VEHICLE_CLIENT vc on vt.VehicleNo   = vc.REGISTRATION_NUMBER "+
	" where vt.System_id = ? and vc.CLIENT_ID = ? ";


	
	public static final String GET_PARTS_PENDING_DETAILS = " select isnull(a.RequisitionNo,'') as REQUISITION_NO,isnull(a.SpareName,'') as PART_NAME,isnull(a.SpareNumber,'') as PART_NUMBER," +
														    " isnull(a.SpareCategory,'') as PART_CATEGORY,isnull(b.ManufactureName,'') as MANUFACTURER,isnull(a.UOM,'') as UOM,isnull(c.QIH,0) as QIH," +
														    " isnull(e.BranchName,'') as BRANCH_NAME,(isnull(d.Firstname,'')+' '+isnull(d.Lastname,''))  as REQUESTED_BY,isnull(dateadd(mi,?,a.InsertedDate),'') as INSERTED_DATE,isnull(a.ItemType,'') as ITEM_TYPE," +
														    " isnull(a.RequiredQuantity,0) as REQUESTED_QUANTITY" +
															   " from FMS.dbo.RequisitionSpareDetails a " +
															   " left outer join FMS.dbo.Manufacture_Master b on b.ManufactureId = a.Manufacturer and b.SystemId = a.SystemId " +
															   " left outer join FMS.dbo.Spare_Master c on a.BranchName=c.BranchName and a.ClientId=c.ClientId and a.SystemId = c.SystemId and c.SpareName=a.SpareName " +
															   " left outer join FMS.dbo.RequisitionMaster r on a.RequisitionNo=r.RequisitionNo and a.SystemId=r.SystemId and a.ClientId=r.ClientId" +
															   " left outer join  AMS.dbo.Users d on r.UserId=d.User_id and d.System_id=? " +
															   " left outer join MAPLE.dbo.tblBranchMaster e on a.BranchName=e.BranchId and a.SystemId=e.SystemId and a.ClientId=e.ClientId " +
															   " where a.Status = 'Waiting For Approval' and a.SystemId=? and a.ClientId=? ";

	public static final String GET_IDLING_PERCENTAGE =  " select s.GROUP_NAME,s.VehicleType,sum(s.IDLE_HRS) as IDLE_HRS, sum(s.ENGINE_HRS) as ENGINE_HRS from "+
             " (select vg.GROUP_NAME as GROUP_NAME ,vt.VehicleType , isnull(IdleDurationHrs,0)  as IDLE_HRS,  isnull(EngineHrs,0)  as ENGINE_HRS from AMS.dbo.VehicleSummaryData vd "+
		     " inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.ClientId = vc.CLIENT_ID and vd.RegistrationNo = vc.REGISTRATION_NUMBER "+
		     " inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
		     " inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo = vd.RegistrationNo "+
		     " inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
		"  where vd.DateGMT between dateadd(mi,?,?) and dateadd(mi,?,?) and "+
		"  vd.SystemId =? and vd.ClientId = ?  and c.User_id = ? "+
		"  # "+
		"  union all "+
		"  select vg.GROUP_NAME as GROUP_NAME,vt.VehicleType ,isnull(IdleDurationHrs,0)  as IDLE_HRS,  isnull(EngineHrs,0)  as ENGINE_HRS from AMS_Archieve.dbo.VehicleSummaryData_History  vd "+
		"  inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.ClientId = vc.CLIENT_ID and vd.RegistrationNo = vc.REGISTRATION_NUMBER "+
		"  inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
		"  inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo = vd.RegistrationNo "+
		" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
		"  where vd.DateGMT between dateadd(mi,?,?) and dateadd(mi,?,?) and "+
		" 	 vd.SystemId =? and vd.ClientId = ?  and c.User_id = ? "+
		" 	# ) s "+
		" 	 group by  s.GROUP_NAME,s.VehicleType "+
		" 	 order by  s.GROUP_NAME ";

	
	public static final String GET_IDLING_PERCENTAGE_TREND  = " select s.GROUP_NAME,sum(s.IDLE_HRS) as IDLE_HRS1, sum(s.ENGINE_HRS) as ENGINE_HRS1 from "+
" (select vg.GROUP_NAME as GROUP_NAME , isnull(IdleDurationHrs,0)  as IDLE_HRS,  isnull(EngineHrs,0)  as ENGINE_HRS from AMS.dbo.VehicleSummaryData vd "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.ClientId = vc.CLIENT_ID and vd.RegistrationNo = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
"  inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo = vd.RegistrationNo "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
"  where vd.DateGMT between dateadd(mi,?,?) and dateadd(mi,?,?) and "+
"  vd.SystemId =? and vd.ClientId = ? and c.User_id = ? "+
"  # "+
"  union all "+
"  select vg.GROUP_NAME as GROUP_NAME ,isnull(IdleDurationHrs,0)  as IDLE_HRS,  isnull(EngineHrs,0)  as ENGINE_HRS from AMS_Archieve.dbo.VehicleSummaryData_History  vd "+
"  inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.ClientId = vc.CLIENT_ID and vd.RegistrationNo = vc.REGISTRATION_NUMBER "+
"  inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
"  inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo = vd.RegistrationNo "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
"  where vd.DateGMT between dateadd(mi,?,?) and dateadd(mi,?,?) and "+
" 	 vd.SystemId =? and vd.ClientId = ? and c.User_id = ? "+
" 	# ) s "+
" 	 group by  s.GROUP_NAME "+
" 	 order by  s.GROUP_NAME ";


 public static final String GET_VEHICLE_COUNT = " Select vg.GROUP_NAME,count(REGISTRATION_NUMBER) VEHICLE_COUNT from AMS.dbo.VEHICLE_GROUP vg "+
 " inner join AMS.dbo.VEHICLE_CLIENT vc on vc.SYSTEM_ID = vg.SYSTEM_ID and vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
 " inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vc.REGISTRATION_NUMBER "+
 " inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
 " where vc.SYSTEM_ID =? and vc.CLIENT_ID = ? and c.User_id = ? "+
 " # "+
 " group by vg.GROUP_NAME "+
 " order by vg.GROUP_NAME ";


 public static final String GET_OVERSPEED_COUNT_ORC = " select count(distinct s.OSVEHICLE_COUNT) as OSVEHICLE_COUNT ,s.GROUP_NAME,count (s.OVERSPEED_COUNT ) as OVERSPEED_COUNT from "+
 " (select  vd.REGISTRATION_NO as OSVEHICLE_COUNT,vt.VehicleType, vg.GROUP_NAME as GROUP_NAME ,REGISTRATION_NO as OVERSPEED_COUNT from AMS.dbo.Overspeed_Violation vd "+
	 "  inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.CLIENTID = vc.CLIENT_ID and vd.REGISTRATION_NO = vc.REGISTRATION_NUMBER "+
	 "  inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
	 "   inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.REGISTRATION_NO "+
	 "  inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
	 "   where vd.START_GMT > dateadd(mi,?,?) and  vd.END_GMT < dateadd(mi,?,?) and "+
	 "   vd.SYSTEM_ID = ? and vd.CLIENTID =? and c.User_id = ? "+
		 " # "+
	 " union all "+
	 "  select   vd.REGISTRATION_NO as OSVEHICLE_COUNT,vt.VehicleType, vg.GROUP_NAME as GROUP_NAME ,REGISTRATION_NO as OVERSPEED_COUNT from AMS.dbo.Overspeed_Violation_History vd "+
	 "   inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.CLIENTID = vc.CLIENT_ID and vd.REGISTRATION_NO = vc.REGISTRATION_NUMBER "+
	 "   inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
	 " 	  inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.REGISTRATION_NO "+
	 "  inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
	 " 	  where vd.START_GMT > dateadd(mi,-?,?) and  vd.END_GMT < dateadd(mi,-?,?) and "+
	 "   vd.SYSTEM_ID = ? and vd.CLIENTID =?  and c.User_id = ? "+
		" # "	+
	 " 	) s "+
	 "   group by  s.GROUP_NAME ";

 public static final String GET_OVERSPEED_COUNT_ORC_ONCLICK = 
     " select  vd.REGISTRATION_NO as REGISTRATION_NO,vt.VehicleType, vg.GROUP_NAME as GROUP_NAME ,START_GPS_DATETIME,START_LOCATION,END_GPS_DATETIME,END_LOCATION from AMS.dbo.Overspeed_Violation vd "+
	 "  inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.CLIENTID = vc.CLIENT_ID and vd.REGISTRATION_NO = vc.REGISTRATION_NUMBER "+
	 "  inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
	 "   inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.REGISTRATION_NO "+
	 "  inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
	 "   where vd.START_GMT > dateadd(mi,?,?) and  vd.END_GMT < dateadd(mi,?,?) and "+
	 "   vd.SYSTEM_ID = ? and vd.CLIENTID =? and c.User_id = ? and vg.GROUP_NAME = ? "+
		 " # "+
	 " union all "+
	 "  select vd.REGISTRATION_NO ,vt.VehicleType, vg.GROUP_NAME as GROUP_NAME ,START_GPS_DATETIME,START_LOCATION,END_GPS_DATETIME,END_LOCATION   from AMS.dbo.Overspeed_Violation_History vd "+
	 "   inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.CLIENTID = vc.CLIENT_ID and vd.REGISTRATION_NO = vc.REGISTRATION_NUMBER "+
	 "   inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
	 " 	  inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.REGISTRATION_NO "+
	 "  inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
	 " 	  where vd.START_GMT > dateadd(mi,-?,?) and  vd.END_GMT < dateadd(mi,-?,?) and "+
	 "   vd.SYSTEM_ID = ? and vd.CLIENTID =?  and c.User_id = ? and vg.GROUP_NAME = ? "+
		" # "	;
	

public static final String GET_PM_COMPLETED_PREVIOUS_DURATION = " select s.GROUP_NAME, count(s.ASSET_COUNT) as ASSET_COUNT  from "+
    " ( "+
	" select vg.GROUP_NAME, pv.ASSET_NUMBER as ASSET_COUNT, pv.SERVICE_DATE as UPDATED_TIME , pv.TASK_ID,vt.VehicleType "+
	" from FMS.dbo.PREVENTIVE_EVENTS_HISTORY pv "+
	" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
	" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
	" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
	" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
	" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
	" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ? and c.User_id = ? "+
	" and pv.SERVICE_DATE between dateadd(mi,?,? ) and dateadd(mi,?,? ) "+
	" # "+
	" group by vg.GROUP_NAME,pv.ASSET_NUMBER,pv.SERVICE_DATE, pv.TASK_ID,vt.VehicleType "+
	" )s group by  s.GROUP_NAME ";

public static final String GET_PM_SHEDULED_CURRENT_DURATION_2 = " select s.GROUP_NAME, count(s.ASSET_COUNT) as ASSET_COUNT  from "+
" ( "+
" select vg.GROUP_NAME, pv.ASSET_NUMBER as ASSET_COUNT, pv.EVENT_DATE as UPDATED_TIME "+
" from FMS.dbo.PREVENTIVE_EVENTS pv "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ? and c.User_id = ? and pv.ALERT_TYPE = 1 "+
" and pv.EVENT_DATE between dateadd(mi,?,? ) and dateadd(mi,?,? ) "+
" and (pv.POSTPONE_DATE < dateadd(dd,-1,getDate()) or pv.POSTPONE_DATE is null) "+
" # "+
" ) s group by  s.GROUP_NAME ";

public static final String GET_PM_SHEDULED_CURRENT_DURATION = " select s.GROUP_NAME, count(s.ASSET_COUNT) as ASSET_COUNT  from "+
" ( "+
" select vg.GROUP_NAME, pv.ASSET_NUMBER as ASSET_COUNT, pv.EVENT_DATE as UPDATED_TIME "+
" from FMS.dbo.PREVENTIVE_EVENTS pv "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ? and c.User_id = ? and pv.ALERT_TYPE = 1 "+
" and pv.EVENT_DATE between dateadd(mi,?,? ) and dateadd(mi,?,? ) "+
" and (pv.POSTPONE_DATE < dateadd(dd,-1,getDate()) or pv.POSTPONE_DATE is null) "+
" # "+
" union "+
" select vg.GROUP_NAME, pv.ASSET_NUMBER as ASSET_COUNT, pv.EVENT_DATE as UPDATED_TIME "+
" from FMS.dbo.PREVENTIVE_EVENTS pv "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ? and c.User_id = ?  and pv.ALERT_TYPE =2  "+
" # "+
" ) s group by  s.GROUP_NAME ";

public static final String GET_PM_SCHEDULED_ALL_VEHICLE =" select vg.GROUP_NAME as All_GROUP ,  count(vt.VehicleNo) as VEHICLE_COUNT from AMS.dbo.VEHICLE_GROUP as vg "+
			  " inner join AMS.dbo.VEHICLE_CLIENT vc on   vc.GROUP_ID= vg.GROUP_ID "+
			  " inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = vc.REGISTRATION_NUMBER "+
			  " inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
			  " where vg.SYSTEM_ID= ? and vg.CLIENT_ID= ? and c.User_id = ? "+
			  " # "+
			  " group by  vg.GROUP_NAME ";

public static final String GET_PM_SCHEDULED_ALL_VEHICLE_FOR_COMPLIANCE =" select s.GROUP_NAME, count( s.ASSET_COUNT) as VEHICLE_COUNT  from "+
" ( "+
" select distinct vg.GROUP_NAME, pv.ASSET_NUMBER as ASSET_COUNT ,pv.SERVICE_DATE,pv.TASK_ID "+
" from FMS.dbo.PREVENTIVE_EVENTS_HISTORY pv "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ?  and c.User_id = ? "+
" and pv.SERVICE_DATE between dateadd(mi,?,? ) and dateadd(mi,?,? )  "+
" # "+
" )" +
" s group by  s.GROUP_NAME ";

public static final String GET_PM_EXPIRED_COUNT = " select s.GROUP_NAME, count( s.ASSET_COUNT) as VEHICLE_COUNT  from "+
" ( "+
" select distinct vg.GROUP_NAME,pv.ASSET_NUMBER as ASSET_COUNT ,pv.SERVICE_DATE,pv.TASK_ID "+
" from FMS.dbo.PREVENTIVE_EVENTS_HISTORY pv "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ?  and c.User_id = ? "+
" and pv.SERVICE_DATE between dateadd(mi,?,? ) and dateadd(mi,?,? ) and ( DUE_DAYS = 0 or DUE_MILEAGE = 0 ) "+
" # "+

" )" +
" s group by  s.GROUP_NAME ";


public static final String GET_PM_NON_EXPIRED_COUNT = " select s.GROUP_NAME, count( s.ASSET_COUNT) as VEHICLE_COUNT  from "+
" ( "+
" select distinct vg.GROUP_NAME, pv.ASSET_NUMBER as ASSET_COUNT ,pv.SERVICE_DATE,pv.TASK_ID "+
" from FMS.dbo.PREVENTIVE_EVENTS_HISTORY pv "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
" where pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ?  and c.User_id = ? "+
" and pv.SERVICE_DATE between dateadd(mi,?,? ) and dateadd(mi,?,? ) and ( DUE_DAYS > 0 or DUE_MILEAGE > 0 ) "+
" # "+
" )" +
" s group by  s.GROUP_NAME ";

public static final String GET_STATUTORY_DUE_COUNT = " select s.GROUP_NAME, count(s.ASSET_COUNT) as ASSET_COUNT  from "+
" (select vg.GROUP_NAME,sa.VehicleNo as ASSET_COUNT,sa.VehicleNo,sa.DueDate "+
" from AMS.dbo.StatutoryAlert sa "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on sa.VehicleNo COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID  "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = sa.VehicleNo "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where sa.SystemId = ? and sa.ClientId = ? and c.User_id = ?   and sa.AlertId = ? and sa.DueDate between ? and ? "+
" # "+
" union "+
" select vg.GROUP_NAME, sa.VehicleNo as ASSET_COUNT,sa.VehicleNo,sa.DueDate "+
" from AMS.dbo.StatutoryAlertHistory sa "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on sa.VehicleNo COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+ 
" inner join AMS.dbo.VEHICLE_GROUP vg on vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = sa.VehicleNo "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where sa.SystemId = ? and sa.ClientId = ? and c.User_id = ?   and sa.AlertId = ? and sa.DueDate between ? and ? "+
" # "+
" )s group by  s.GROUP_NAME ";

public static final String GET_STATUTORY_DUE_COUNT_ONCLICK = 
" select vg.GROUP_NAME,sa.VehicleNo,vt.VehicleType,sa.VehicleNo,sa.DueDate "+
" from AMS.dbo.StatutoryAlert sa "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on sa.VehicleNo COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID  "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = sa.VehicleNo "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where sa.SystemId = ? and sa.ClientId = ? and c.User_id = ?   and sa.AlertId = ? and sa.DueDate between ? and ?  and vg.GROUP_NAME = ? "+
" # "+
" union "+
" select vg.GROUP_NAME, sa.VehicleNo,vt.VehicleType,sa.VehicleNo,sa.DueDate "+
" from AMS.dbo.StatutoryAlertHistory sa "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on sa.VehicleNo COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+ 
" inner join AMS.dbo.VEHICLE_GROUP vg on vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = sa.VehicleNo "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where sa.SystemId = ? and sa.ClientId = ? and c.User_id = ?   and sa.AlertId = ? and sa.DueDate between ? and ? and vg.GROUP_NAME = ? "+
" # ";


public static final String GET_STATUTORY_DUE_COUNT_FORECASTING = " select vg.GROUP_NAME, count(distinct vt.VehicleNo) as ASSET_COUNT "+
" from AMS.dbo.tblVehicleMaster vt "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on vt.VehicleNo COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID  "+
" where vt.System_id = ? and vg.CLIENT_ID =? and c.User_id = ?  and $  "+
" # "+
" group by  vg.GROUP_NAME ";


public static final String GET_VEHICLE_OF_EACH_GROUP = " select vg.GROUP_NAME,vc.REGISTRATION_NUMBER as ASSET_NUMBER from AMS.dbo.VEHICLE_CLIENT vc "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = vc.REGISTRATION_NUMBER "+ 
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where vc.SYSTEM_ID = ? AND vc.CLIENT_ID = ? and c.User_id = ? "+
" # "+
" order by vg.GROUP_NAME ";


public static final String GET_VEHICLE_OF_EACH_GROUP_WISE = " select vg.GROUP_NAME,vc.REGISTRATION_NUMBER as ASSET_NUMBER from AMS.dbo.VEHICLE_CLIENT vc "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = vc.REGISTRATION_NUMBER "+ 
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vt.VehicleNo collate database_default "+
" where vc.SYSTEM_ID = ? AND vc.CLIENT_ID = ?  and c.User_id = ? and vg.GROUP_NAME = ?"+
" # "+
" order by vg.GROUP_NAME ";

public static final String GET_VEHICLE_AND_VEHICLE_TYPE = " select vc.REGISTRATION_NUMBER as ASSET_NUMBER, vt.VehicleType from AMS.dbo.VEHICLE_CLIENT vc "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = vc.REGISTRATION_NUMBER "+ 
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vt.VehicleNo collate database_default "+
" where vc.SYSTEM_ID = ? AND vc.CLIENT_ID = ?  and c.User_id = ? ";



public static final String GET_VEHICLE_TOTAL_DISTANCE_NEW = 
	 " select vd.RegistrationNo as ASSET_NUMBER ,sum( isnull(TotalDistanceTravelled,0) )as TOTAL_DISTANCE from AMS.dbo.VehicleSummaryData vd "+
	 " inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.RegistrationNo = vc.REGISTRATION_NUMBER "+
	 " inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.RegistrationNo "+
	 " where  vd.SystemId =? and vd.ClientId = ? and  vd.DateGMT between dateadd(mi,?,? ) and dateadd(mi,?,? )   "+
	 " # "+
	 " group by vd.RegistrationNo ";


public static final String GET_IDLING_PERCENTAGE_ONCLICK = " select s.VEHICLE_NO,s.VehicleType,s.GROUP_NAME,sum(IDLE_HRS) as IDLE_HRS,sum(s.ENGINE_HRS) as ENGINE_HRS from "+
" ( select vd.RegistrationNo as VEHICLE_NO ,vt.VehicleType,vg.GROUP_NAME as GROUP_NAME ,isnull(IdleDurationHrs,0) as IDLE_HRS, isnull(EngineHrs,0) as ENGINE_HRS from AMS.dbo.VehicleSummaryData vd "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.ClientId = vc.CLIENT_ID and vd.RegistrationNo = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo = vd.RegistrationNo "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where vd.DateGMT between dateadd(mi,?,? ) and dateadd(mi,?,? ) and "+ 
" vd.SystemId =? and vd.ClientId = ? and c.User_id = ?  and vg.GROUP_NAME = ? "+
" # "+
" UNION ALL "+
 " select vd.RegistrationNo as VEHICLE_NO ,vt.VehicleType,vg.GROUP_NAME as GROUP_NAME ,isnull(IdleDurationHrs,0) as IDLE_HRS,  isnull(EngineHrs,0) as ENGINE_HRS from  AMS_Archieve.dbo.VehicleSummaryData_History  vd "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on  vd.ClientId = vc.CLIENT_ID and vd.RegistrationNo = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo = vd.RegistrationNo "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where vd.DateGMT between dateadd(mi,?,? ) and dateadd(mi,?,? ) and "+ 
" vd.SystemId =? and vd.ClientId = ? and c.User_id = ?  and vg.GROUP_NAME = ? "+
" # "+
" ) s "+
" group by s.VEHICLE_NO,s.GROUP_NAME,s.VehicleType"+
" order by s.VEHICLE_NO ";


public static final String GET_PM_EXPIRED_COUNT_ON_CLICK = 
" select vg.GROUP_NAME,vt.VehicleType,pv.ASSET_NUMBER,count(pv.ASSET_NUMBER) as ASSET_COUNT,dateadd(mi,?, pv.SERVICE_DATE) as LAST_SERVICE_DATE, pv.TASK_ID "+
" from FMS.dbo.PREVENTIVE_EVENTS_HISTORY pv "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
" where pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ? and c.User_id = ? "+
" and pv.SERVICE_DATE between dateadd(mi,?,? ) and dateadd(mi,?,? ) and ( DUE_DAYS = 0 or DUE_MILEAGE = 0 ) and vg.GROUP_NAME = ?  "+
" # "+
" group by  vg.GROUP_NAME,pv.ASSET_NUMBER, pv.SERVICE_DATE,pv.TASK_ID,vt.VehicleType"+
" order by  pv.ASSET_NUMBER,pv.SERVICE_DATE  ";


public static final String GET_PM_NON_EXPIRED_COUNT_ON_CLICK = 
" select vg.GROUP_NAME, pv.ASSET_NUMBER, count(pv.ASSET_NUMBER) as ASSET_COUNT,vt.VehicleType,dateadd(mi,?, pv.SERVICE_DATE) as LAST_SERVICE_DATE,pv.TASK_ID "+
" from FMS.dbo.PREVENTIVE_EVENTS_HISTORY pv "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ? and c.User_id = ? "+
" and pv.SERVICE_DATE between dateadd(mi,?,? ) and dateadd(mi,?,? )  and ( DUE_DAYS > 0 or DUE_MILEAGE > 0 ) and vg.GROUP_NAME = ? "+
" # "+
" group by  vg.GROUP_NAME,pv.ASSET_NUMBER,pv.SERVICE_DATE,pv.TASK_ID ,vt.VehicleType"+
" order by  ASSET_NUMBER,LAST_SERVICE_DATE  ";


public static final String GET_PM_COMPLETED_PREVIOUS_DURATION_ONCLICK = 
" select vg.GROUP_NAME, pv.ASSET_NUMBER ,dateadd(mi,?,pv.SERVICE_DATE) as LAST_SERVICE_DATE,vt.VehicleType, pv.TASK_ID "+
" from FMS.dbo.PREVENTIVE_EVENTS_HISTORY pv "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ?  and c.User_id = ?  and vg.GROUP_NAME = ?   "+
" and pv.SERVICE_DATE between dateadd(mi,?,?) and dateadd(mi,?,?) "+
" # "+
" group by vg.GROUP_NAME,pv.ASSET_NUMBER,pv.SERVICE_DATE,pv.TASK_ID,vt.VehicleType "+
" order by  pv.ASSET_NUMBER ,LAST_SERVICE_DATE ";

public static final String GET_PM_SCHEDULED_CURRENT_DURATION_ONCLICK = 
	" select vg.GROUP_NAME, pv.ASSET_NUMBER,vt.VehicleType ,dateadd(mi,?,pv.EVENT_DATE) as LAST_SERVICE_DATE"+
	" from FMS.dbo.PREVENTIVE_EVENTS pv "+
	" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
	" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
	" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
	" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
	" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
	" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ?  and c.User_id = ?  and vg.GROUP_NAME = ? and pv.ALERT_TYPE = 1  "+
	" and (pv.POSTPONE_DATE < dateadd(dd,-1,getDate()) or pv.POSTPONE_DATE is null) "+
	" and pv.EVENT_DATE between dateadd(mi,?,?) and dateadd(mi,?,?) "+
	" # "+
	" union"+
	" select vg.GROUP_NAME, pv.ASSET_NUMBER,vt.VehicleType ,dateadd(mi,?,pv.EVENT_DATE) as LAST_SERVICE_DATE"+
	" from FMS.dbo.PREVENTIVE_EVENTS pv "+
	" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
	" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
	" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
	" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
	" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
	" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ?  and c.User_id = ?  and vg.GROUP_NAME = ?  and pv.ALERT_TYPE = 2  "+
	" # "+	
	" order by  pv.ASSET_NUMBER ,LAST_SERVICE_DATE ";

public static final String GET_PM_SCHEDULED_CURRENT_DURATION_ONCLICK_2 = 
	" select vg.GROUP_NAME, pv.ASSET_NUMBER ,dateadd(mi,?,pv.EVENT_DATE) as LAST_SERVICE_DATE"+
	" from FMS.dbo.PREVENTIVE_EVENTS pv "+
	" inner join AMS.dbo.VEHICLE_CLIENT vc on    pv.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vc.REGISTRATION_NUMBER "+
	" inner join AMS.dbo.VEHICLE_GROUP vg on   vc.GROUP_ID= vg.GROUP_ID "+
	" inner join AMS.dbo.tblVehicleMaster vt on vt.VehicleNo COLLATE DATABASE_DEFAULT = pv.ASSET_NUMBER "+
	" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
	" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
	" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID = ?  and c.User_id = ?  and vg.GROUP_NAME = ? and pv.ALERT_TYPE = 1  "+
	" and (pv.POSTPONE_DATE < dateadd(dd,-1,getDate()) or pv.POSTPONE_DATE is null) "+
	" and pv.EVENT_DATE between dateadd(mi,?,?) and dateadd(mi,?,?) "+
	" # "+
	" order by  pv.ASSET_NUMBER ,LAST_SERVICE_DATE ";
public static final String GET_MANAGER_DETAILS="Select isnull(USER_ID,'') as ManagerId, isnull(FIRST_NAME,'')+' '+ isnull(LAST_NAME,'') as ManagerName from ADMINISTRATOR.dbo.USERS where SYSTEM_ID=? and CUSTOMER_ID=?";

public static final String GET_JOBCARD_SETTINGS_DETAILS="select jc.ID,isnull(jc.SYSTEM_ID,'') as SYSTEMID,isnull(cm.NAME,'') as CUSTOMER_NAME,isnull(EXT_JC_MAX_COST,0) as EXT_JC_MAX_COST, " + 
"isnull(EXT_JC_SUB_TASK,0) as EXT_JC_SUB_TASK,isnull(MANAGER_ID,'') as MANAGER_ID,isnull(u.FIRST_NAME,'')+' '+isnull(LAST_NAME,'') as MANAGER_NAME, " +
"isnull(u.EMAIL,'') as MANAGER_EMAIL, isnull(u.PHONE,'') as MANAGER_PHONE,isnull(u.USER_ID,0) as MANAGER_ID " +
"from FMS.dbo.JOBCARD_SETTINGS jc " +
"inner join ADMINISTRATOR.dbo.USERS u ON u.SYSTEM_ID = jc.SYSTEM_ID and u.USER_ID=jc.MANAGER_ID " +
"left outer join ADMINISTRATOR.dbo.Customer_Master cm ON cm.SYSTEM_ID = jc.SYSTEM_ID AND cm.CUSTOMER_ID= jc.CUSTOMER_ID "+
"where jc.SYSTEM_ID=? and jc.CUSTOMER_ID=?";

public static final String INSERT_FMS_JC_SETTINGS="insert into FMS.dbo.JOBCARD_SETTINGS(SYSTEM_ID,CUSTOMER_ID,EXT_JC_MAX_COST,EXT_JC_SUB_TASK,MANAGER_ID) values(?,?,?,?,?)";

public static final String UPDATE_FMS_JC_SETTINGS="update FMS.dbo.JOBCARD_SETTINGS set EXT_JC_MAX_COST=?, EXT_JC_SUB_TASK=?, MANAGER_ID=? where ID=?";

public static final String CHECK_FMS_JC_SETTINGS_AVAILABILITY="select * from FMS.dbo.JOBCARD_SETTINGS WHERE SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String GET_STATUTORY_DUE_DRIVER_LICENSE = "  select count(Driver_id) as ASSET_COUNT , vg.GROUP_NAME  from AMS.dbo.Driver_Master a "+
" inner join AMS.dbo.Driver_Vehicle  b on a.System_id = b.SYSTEM_ID and  a.Driver_id = b.DRIVER_ID "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on a.Client_id = vc.CLIENT_ID and b.REGISTRATION_NO = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = b.REGISTRATION_NO "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where a.System_id = ? and a.Client_id = ?  and c.User_id = ?  "+
" # " +
" and Lic_expiry_date between ? and ? "+
" group by vg.GROUP_NAME ";

public static final String GET_STATUTORY_DUE_DRIVER_LICENSE_ONCLICK = "  select vt.VehicleNo , vg.GROUP_NAME, Lic_expiry_date as DUE_DATE from AMS.dbo.Driver_Master a "+
" inner join AMS.dbo.Driver_Vehicle  b on a.System_id = b.SYSTEM_ID and  a.Driver_id = b.DRIVER_ID "+
" inner join AMS.dbo.VEHICLE_CLIENT vc on a.Client_id = vc.CLIENT_ID and b.REGISTRATION_NO = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID "+
" inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = b.REGISTRATION_NO "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where a.System_id = ? and a.Client_id = ?  and c.User_id = ?  "+
" # " +
" and Lic_expiry_date between ? and ? and vg.GROUP_NAME = ? ";


public static final String GET_DISTANCE_COUNT_NEW_LOGIC = " select sa.GROUP_NAME1 as GROUP_NAME, sum(sa.DISTANCE1) as DISTANCE  from( "+
" select vd.RegistrationNo,vc.GROUP_NAME  as GROUP_NAME1 ,isnull(TotalDistanceTravelled,0) as DISTANCE1 "+
" from AMS.dbo.VehicleSummaryData vd  "+
" inner join AMS.dbo.Live_Vision_Support vc on vd.ClientId = vc.CLIENT_ID and vd.RegistrationNo = vc.REGISTRATION_NO "+
" inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.RegistrationNo    "+  
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NO collate database_default "+
" where vd.DateGMT between dateadd(mi,?,?) and dateadd(mi,?,?) and vd.SystemId =? and vd.ClientId =? and c.User_id = ?  "+
" and vd.RegistrationNo in ( $ ) "+
"#"  +
	 " union all "+
" select vd.RegistrationNo,vc.GROUP_NAME  as GROUP_NAME1 ,isnull(TotalDistanceTravelled,0) as DISTANCE1 "+
" from  AMS_Archieve.dbo.VehicleSummaryData_History vd "+
" inner join AMS.dbo.Live_Vision_Support vc on vd.ClientId = vc.CLIENT_ID and vd.RegistrationNo = vc.REGISTRATION_NO "+
	 " inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.RegistrationNo   "+ 
	 " inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NO collate database_default "+
" where vd.DateGMT between dateadd(mi,?,?) and dateadd(mi,?,?) and vd.SystemId =? and vd.ClientId =? and c.User_id = ?  "+
" and vd.RegistrationNo in ( $ ) "+
"# "+ 
" ) sa "+
	 " group by  sa.GROUP_NAME1 "+
	 " order by sa.GROUP_NAME1 desc ";

public static final String get_tatal_distance_from_lastServiceDate_new = "  select vd.RegistrationNo as ASSET_NUMBER ,sum( isnull(TotalDistanceTravelled,0) )as TOTAL_DISTANCE ,isnull(LAST_SERVICE_DATE, getutcdate()) as LAST_SERVICE_DATE  "+
" from AMS.dbo.VehicleSummaryData vd "+ 
" left outer join FMS.dbo.PREVENTIVE_TASK_ASSOCIATION ta on ta.ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vd.RegistrationNo "+
" inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.RegistrationNo "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vd.RegistrationNo collate database_default "+
" where vd.DateGMT between ( select max(LAST_SERVICE_DATE) as LAST_SERVICE_DATE from FMS.dbo.PREVENTIVE_TASK_ASSOCIATION pv " +
" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
" where ASSET_NUMBER COLLATE DATABASE_DEFAULT  = vd.RegistrationNo " +
" and   pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID  = ? )" +
" and dateadd(mi,?,?)  and vd.SystemId =? and vd.ClientId = ? and c.User_id = ? "+
" # "+
" group by vd.RegistrationNo,LAST_SERVICE_DATE  ";

public static final String get_Monthly_avg_distance = " select vd.RegistrationNo as ASSET_NUMBER ,avg( isnull(TotalDistanceTravelled,0) )as TOTAL_DISTANCE "+
" from AMS.dbo.VehicleSummaryData vd "+
" inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.RegistrationNo "+
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vd.RegistrationNo collate database_default "+ 
" where vd.DateGMT between dateadd(mi,?,?) "+
" and dateadd(mi,?,?)  and vd.SystemId =? and vd.ClientId = ? and c.User_id = ? "+
" # "+		
"group by vd.RegistrationNo ";


public static final String get_th_distance_and_th_days = 
	" select ASSET_NUMBER,isnull(THRESHOULD_DISTANCE,0) as THRESHOULD_DISTANCE ,isnull(DAYS,0) as THRESHOULD_DAYS "+
	" from FMS.dbo.PREVENTIVE_TASK_ASSOCIATION pv "+
	" inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo COLLATE DATABASE_DEFAULT  = pv.ASSET_NUMBER "+
	" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vt.VehicleNo collate database_default "+
	" left outer join FMS.dbo.Maintenance_Mstr mm on pv.TASK_ID = mm.MaintenanceId and pv.SYSTEM_ID = mm.SystemId "+
	" where  pv.SYSTEM_ID = ? AND pv.CUSTOMER_ID  = ? and c.User_id = ? "+
	" # ";
public static final String GET_FUEL = "  select vg.GROUP_NAME COLLATE DATABASE_DEFAULT  as GROUP_NAME,vd.VehicleNo as ASSET_NUMBER , isnull(Disel,0) as FUEL "+
" from FMS.dbo.MileagueMaster vd "+
" left outer join AMS.dbo.VEHICLE_CLIENT vc on   vd.VehicleNo COLLATE DATABASE_DEFAULT = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID  = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID  "+
" inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo COLLATE DATABASE_DEFAULT = vd.VehicleNo "+ 
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where vd.DateTime  between dateadd(mi,?,?)  and dateadd(mi,?,?) "+
" and vd.SystemId =? and vd.ClientId =?  and c.User_id = ? "+
" # "+
" order by GROUP_NAME";


public static final String GET_FUEL_ONCLICK = "  select vg.GROUP_NAME COLLATE DATABASE_DEFAULT  as GROUP_NAME,vd.VehicleNo as ASSET_NUMBER , isnull(Disel,0) as FUEL "+
" from FMS.dbo.MileagueMaster vd "+
" left outer join AMS.dbo.VEHICLE_CLIENT vc on   vd.VehicleNo COLLATE DATABASE_DEFAULT = vc.REGISTRATION_NUMBER "+
" inner join AMS.dbo.VEHICLE_GROUP vg on  vc.CLIENT_ID  = vg.CLIENT_ID and vc.GROUP_ID= vg.GROUP_ID  "+
" inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo COLLATE DATABASE_DEFAULT = vd.VehicleNo "+ 
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NUMBER collate database_default "+
" where vd.DateTime  between dateadd(mi,?,?)  and dateadd(mi,?,?) "+
" and vd.SystemId =? and vd.ClientId =?  and c.User_id = ? and vg.GROUP_NAME = ? "+
" # " ;

public static final String GET_DISTANCE_COUNT_NEW_LOGIC_ONCLICK = 
" select vd.RegistrationNo as VehicleNo,vt.VehicleType ,sum(isnull(TotalDistanceTravelled,0)) as DISTANCE "+
" from AMS.dbo.VehicleSummaryData vd  "+
" inner join AMS.dbo.Live_Vision_Support vc on vd.ClientId = vc.CLIENT_ID and vd.RegistrationNo = vc.REGISTRATION_NO "+
" inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.RegistrationNo    "+  
" inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NO collate database_default "+
" where vd.DateGMT between dateadd(mi,?,?) and dateadd(mi,?,?) and vd.SystemId =? and vd.ClientId =? and c.User_id = ? and vc.GROUP_NAME = ? "+
" and vd.RegistrationNo in ( $ ) "+
" # "  +
" group by  vd.RegistrationNo,vt.VehicleType "+
	 " union all "+
" select vd.RegistrationNo,vt.VehicleType,sum(isnull(TotalDistanceTravelled,0)) as DISTANCE1 "+
" from  AMS_Archieve.dbo.VehicleSummaryData_History vd "+
" inner join AMS.dbo.Live_Vision_Support vc on vd.ClientId = vc.CLIENT_ID and vd.RegistrationNo = vc.REGISTRATION_NO "+
	 " inner join AMS.dbo.tblVehicleMaster vt on  vt.VehicleNo = vd.RegistrationNo   "+ 
	 " inner join AMS.dbo.Vehicle_User c on c.Registration_no=vc.REGISTRATION_NO collate database_default "+
" where vd.DateGMT between dateadd(mi,?,?) and dateadd(mi,?,?) and vd.SystemId =? and vd.ClientId =? and c.User_id = ? and vc.GROUP_NAME = ?  "+
" and vd.RegistrationNo in ( $ ) "+
" # "+ 
" group by  vd.RegistrationNo,vt.VehicleType ";
	

} 