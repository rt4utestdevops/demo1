package t4u.statements;

public class DistributionStatments {

	 public static final String GET_APMT_TRIP_DETAILS=" SELECT a.TRIP_ID,isnull(b.MILESTONE_NAME,'') as MILESTONE_1 ,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,b.MILESTONE_IN),''),120)  as MILESTONE_1_IN,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,b.MILESTONE_OUT),''),120)  as MILESTONE_1_OUT,isnull(b.STOP_DETENTION,'00:00') as DETENTION_1, "+
	  " isnull(c.MILESTONE_NAME,'') as MILESTONE_2 ,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,c.MILESTONE_IN),''),120)  as MILESTONE_2_IN,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,c.MILESTONE_OUT),''),120)  as MILESTONE_2_OUT,isnull(c.STOP_DETENTION,'00:00') as DETENTION_2, "+
	  " isnull(d.MILESTONE_NAME,'') as MILESTONE_3 ,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,d.MILESTONE_IN),''),120)  as MILESTONE_3_IN,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,d.MILESTONE_OUT),''),120)  as MILESTONE_3_OUT,isnull(d.STOP_DETENTION,'00:00') as DETENTION_3, "+
	  " isnull(e.MILESTONE_NAME,'') as MILESTONE_4 ,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,e.MILESTONE_IN),''),120)  as MILESTONE_4_IN,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,e.MILESTONE_OUT),''),120)  as MILESTONE_4_OUT,isnull(e.STOP_DETENTION,'00:00') as DETENTION_4, "+
	  " isnull(f.MILESTONE_NAME,'') as MILESTONE_5 ,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,f.MILESTONE_IN),''),120)  as MILESTONE_5_IN,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,f.MILESTONE_OUT),''),120)  as MILESTONE_5_OUT,isnull(f.STOP_DETENTION,'00:00') as DETENTION_5, "+
	  " isnull(g.MILESTONE_NAME,'') as MILESTONE_6 ,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,g.MILESTONE_IN),''),120)  as MILESTONE_6_IN,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,g.MILESTONE_OUT),''),120)  as MILESTONE_6_OUT,isnull(g.STOP_DETENTION,'00:00') as DETENTION_6, "+
	  " REGISTRATION_NO,SOURCE_NAME,CONVERT(VARCHAR(19),dateadd(mi,330,SOURCE_IN),120)  as SOURCE_IN ,CONVERT(VARCHAR(19),dateadd(mi,330,SOURCE_OUT),120)  as SOURCE_OUT, DATEPART(hh,dateadd(mi,330,SOURCE_OUT)) as DATEHR ,isnull(PORT_DETENTION,'00:00') as PORT_DETENTION ,isnull(DEST_NAME,'')as DEST_NAME,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,DEST_IN),''),120)  as DEST_IN,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,DEST_OUT),''),120)  as "+
	  " DEST_OUT,isnull(CFS_DETENTION,'00:00') as CFS_DETENTION,TRIP_STATUS,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,TRIP_END_TIME),''),120)  as TRIP_END_TIME , ISNULL(ENROUTE_STOPPAGE_1,'') AS ENROUTE_STOPPAGE_1 ,ISNULL(ENROUTE_STOPPAGE_2,'') AS ENROUTE_STOPPAGE_2,RETURN_PORT,STOPPAGE_COUNT,RETURN_PORT_IN , isNull(SRC_MILESTONE_STOPPAGE,'') as SRC_MILESTONE_STOPPAGE, isNull(DEST_MILESTONE_STOPPAGE,'') as DEST_MILESTONE_STOPPAGE ,"+    
     " isnull(EXPORT_DEST_NAME,'')as EXPORT_DEST_NAME,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,EXPORT_DEST_IN),''),120)  as EXPORT_DEST_IN,CONVERT(VARCHAR(19),isnull(dateadd(mi,330,EXPORT_DEST_OUT),''),120)  as "+
	  " EXPORT_DEST_OUT,isnull(EXPORT_CFS_DETENTION,'00:00') as EXPORT_CFS_DETENTION,ISNULL(ENROUTE_STOPPAGE_BTW_CFS ,'') AS STOPPAGE_BTE_CFS "+
	  " FROM  AMS.dbo.DISTRIBUTION_TRIP_DETAILS a  "+
	  " left outer join AMS.dbo.DISTRIBUTION_STOP_POINT_DETAILS b on "+ 
	  " a.TRIP_ID = b.TRIP_ID and b.SEQUENCE= 1  "+
	  " left outer join AMS.dbo.DISTRIBUTION_STOP_POINT_DETAILS c on "+
	  " a.TRIP_ID = c.TRIP_ID and c.SEQUENCE= 2 "+
	  " left outer join AMS.dbo.DISTRIBUTION_STOP_POINT_DETAILS d on "+
	  " a.TRIP_ID = d.TRIP_ID and d.SEQUENCE= 3 "+
	  " left outer join AMS.dbo.DISTRIBUTION_STOP_POINT_DETAILS e on "+
	  " a.TRIP_ID = e.TRIP_ID and e.SEQUENCE= 4 "+
	  " left outer join AMS.dbo.DISTRIBUTION_STOP_POINT_DETAILS f on "+
	  " a.TRIP_ID = f.TRIP_ID and f.SEQUENCE= 5 "+
	  " left outer join AMS.dbo.DISTRIBUTION_STOP_POINT_DETAILS g on "+
	  " a.TRIP_ID = g.TRIP_ID and g.SEQUENCE= 6 "+
	  " where DEST_IN IS NOT NULL AND SOURCE_OUT BETWEEN DATEADD(mi,210,?) AND DATEADD(mi,210,?) and SYSTEM_ID = ?  AND CUSTOMER_ID = ? AND TRIP_STATUS = 'DELIVERED' ORDER BY TRIP_ID ";  // 210 is added to show the data from 9am to next day 9am .
	
	 public static final String GET_VEHICLE_WHICH_IS_BELONG_GROUP_AND_VID = "select REGISTRATION_NUMBER from VEHICLE_CLIENT vc, Vehicle_User vu left outer join tblVehicleMaster vm on vm.VehicleNo=vu.Registration_no  where vc.CLIENT_ID=? "
			+ " and vc.SYSTEM_ID=? and vu.User_id=? and vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no and GROUP_ID=? order by REGISTRATION_NUMBER DESC";

	 public static final String CHECK_VEHICLE_ALREADY_EXIST = "select ASSET_NO from AMS.dbo.ASSET_REPORTING_DETAILS where ASSET_NO=? and GROUP_ID=? and ACTUAL_REPORT_DATETIME is NULL and SYSTEM_ID=? and CUSTOMER_ID=?";
	 
	 public static final String ADD_NEW_VEHICLE_REPORTING_DETAILS = "insert into AMS.dbo.ASSET_REPORTING_DETAILS (GROUP_ID,GROUP_NAME,ASSET_NO,DATE,REPORT_TIME,SYSTEM_ID,CUSTOMER_ID) values (?,?,?,?,?,?,?) ";

	 public static final String GET_VEHICLE_REPORTING_DETAILS = "select ar.ID,ar.ASSET_NO,ar.REPORT_TIME,isnull(dateadd(mi,?,ar.ACTUAL_REPORT_DATETIME),'') as ACTUAL_REPORT_DATETIME ,isnull(ar.UPDATED_DATETIME,'') as UPDATED_DATETIME ,isnull((u.Firstname+ ' ' +u.Lastname),'') as UPDATED_BY " +
	 		" from AMS.dbo.ASSET_REPORTING_DETAILS ar" +
	 		" left outer join AMS.dbo.Users u on u.User_id=ar.UPDATED_BY and u.System_id=ar.SYSTEM_ID" +
	 		" where ar.GROUP_ID=? and ar.SYSTEM_ID=? and ar.CUSTOMER_ID=? and ar.DATE=? ";

	 public static final String UPDATE_VEHICLE_REPORTING_DETAILS ="update AMS.dbo.ASSET_REPORTING_DETAILS set REPORT_TIME=?, UPDATED_DATETIME=getdate(),UPDATED_BY=? where GROUP_ID=? and ASSET_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";
	 
	 public static final String GET_LOCATION_ZONE = "select a.NAME,a.LONGITUDE,a.LATITUDE,a.HUBID from LOCATION_ZONE_A a" +
	 		" left outer join UserHubAssociation b on a.HUBID=b.HubId and a.SYSTEMID=b.SystemId " +
	 		" where a.SYSTEMID=? and CLIENTID=? and b.UserId=? order by NAME asc";

	 public static final String GET_VEHICLES = "select vc.REGISTRATION_NUMBER,vc.GROUP_ID,isnull(g.DRIVER_NAME,'NA')as DRIVER_NAME,isnull(g.DRIVER_MOBILE,'NA')as DRIVER_MOBILE from VEHICLE_CLIENT vc "+
	" inner join AMS.dbo.Vehicle_User b on b.System_id=vc.SYSTEM_ID and b.Registration_no=vc.REGISTRATION_NUMBER "+
	" left outer join dbo.gpsdata_history_latest g on vc.REGISTRATION_NUMBER=g.REGISTRATION_NO and vc.SYSTEM_ID=g.System_id "+
	" where SYSTEM_ID=? and CLIENT_ID=? and b.User_id= ? and g.LOCATION <> 'No GPS Device Connected' ";
	 
	 public static final String CHECK_TRIP_EXIST = " select top 1 * from CARGO_SHIPMENT_DETAILS where ((ASSET_NUMBER=? and STATUS='Open') or SHIPMENNT_ID = ?)  and SYSTEM_ID=? and CUSTOMER_ID=? "; 

	 public static final String INSERT_TRIP_GENERATION_DETAILS = "insert into CARGO_SHIPMENT_DETAILS (ASSET_NUMBER,SHIPMENNT_ID,TRIP_START_TIME,STATUS,TYPE,SYSTEM_ID,CUSTOMER_ID,DRIVER_NAME,DRIVER_NUMBER,INSERTED_BY,PLANNED_DISTANCE,PLANNED_DURATION,ROUTE_NAME,COMMUNICATION_STATUS,DOMAIN_NAME)" +
	 		" values(?,?,?,'Open',1,?,?,?,?,?,?,?,?,'COMMUNICATING','APPLICATION')";

	 public static final String INSERT_TOUCHPOINTS_DETAILS = "INSERT INTO CARGO_TRIP_DETAILS (TRIP_ID,HUB_ID,STD_TIME,PLANNED_ARR_DATETIME,EXP_ARR_DATETIME,SEQUENCE,DISTANCE,STATUS) VALUES (?,?,?,dateadd(mi,?,dateadd(mi,-330,?)),dateadd(mi,?,dateadd(mi,-330,?)),?,?,'')";

	 public static final String GET_TRIP_GENERATION_DETAILS = "select c.TRIP_ID,c.ASSET_NUMBER,c.SHIPMENNT_ID,c.TRIP_START_TIME,dateadd(mi,330,c.INSERTED_TIME) as INSERTED_TIME ,isnull(u.Firstname +' '+ u.Lastname,'') as INSERTED_BY ,isnull(c.PLANNED_DISTANCE,'0') as PLANNED_DISTANCE,isnull(c.PLANNED_DURATION,'0') as PLANNED_DURATION,isnull(ROUTE_NAME,'') as ROUTE_NAME from CARGO_SHIPMENT_DETAILS c" +
	 		" left outer join dbo.Users u on c.SYSTEM_ID = u.System_id and c.INSERTED_BY=u.User_id" +
	 		" where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Open' order by c.TRIP_ID desc ";
	 
	 public static final String GET_DASHBOARD_DETAILS =  " select b.SEQUENCE,ROUTE_NAME,isnull(SHIPMENNT_ID,'') as SHIPMENNT_ID,isnull(ASSET_NUMBER,'') as ASSET_NUMBER,  ISNULL(CATEGORY,'NA') AS CATEGORY , ISNULL(HUB_STATUS,'') AS HUB_STATUS , ISNULL(DURATION,0) AS DURATION,ISNULL(c.HUB_ID,'') AS HUB_ID,ISNULL(b.HUB_ID,'') AS STOP_HUB , "+
		 " isnull(d.NAME,'') as TOUCH_POINT,isnull(TRIP_START_TIME,'') as PLANNED_TRIP_TIME, "+
		 " isnull(DATEADD(mi,330,b.ACT_DEP_DATETIME),TRIP_START_TIME) AS ACTUAL_START_TIME, "+
		 " b.ACT_ARR_DATETIME AS TOUCH_POINT_ACT,   "+
		 " isnull(DATEADD(mi,330,b.PLANNED_ARR_DATETIME),'') as ETA_DATETIME,isnull(DATEADD(mi,330,b.EXP_ARR_DATETIME),'') as EXP_ETA_DATETIME,isnull(PLANNED_DISTANCE,0) as PLANNED_DISTANCE,  "+
		 " isnull(LOCATION,'') as LOCATION,c.LATITUDE,c.LONGITUDE , "+
		 " isnull(ACTUAL_DISTANCE,0) as ACTUAL_DISTANCE,isnull(TRIP_STATUS,'') as TRIP_STATUS,(PLANNED_DISTANCE - ACTUAL_DISTANCE) as DIST_TO_DEST ,  "+ 
		 " (SELECT TOP 1 NAME FROM CARGO_TRIP_DETAILS INNER JOIN LOCATION_ZONE_A ON HUB_ID = HUBID AND ACT_ARR_DATETIME IS NULL AND TRIP_ID = a.TRIP_ID ORDER BY SEQUENCE ) AS NEXT_POINT   "+
		 " FROM CARGO_SHIPMENT_DETAILS a   "+
		 " inner join CARGO_TRIP_DETAILS b on a.TRIP_ID=b.TRIP_ID "+
		 " inner join CARGO_TRIP_DETAILS e on a.TRIP_ID=e.TRIP_ID and e.SEQUENCE = 100 " +
		 " INNER  join LOCATION_ZONE_A d ON b.HUB_ID = d.HUBID    "+
		 " INNER JOIN gpsdata_history_latest c on ASSET_NUMBER = REGISTRATION_NO   "+
		 " where SYSTEM_ID=? and CUSTOMER_ID =? AND a.STATUS='Open' # order by a.TRIP_ID,b.SEQUENCE ";
	  
	 public static final String GET_DETAILS = " select b.SEQUENCE , ROUTE_NAME,isnull(SHIPMENNT_ID,'') as SHIPMENNT_ID,isnull(ASSET_NUMBER,'') as ASSET_NUMBER, ISNULL(CATEGORY,'NA') AS CATEGORY , ISNULL(HUB_STATUS,'') AS HUB_STATUS , ISNULL(DURATION,0) AS DURATION,ISNULL(c.HUB_ID,'') AS HUB_ID,ISNULL(b.HUB_ID,'') AS STOP_HUB , a.TRIP_ID ,isnull(d.LOCATION_ID,'') as TOUCH_POINT,isnull(TRIP_START_TIME,'') as PLANNED_TRIP_TIME, "+
		 " isnull(DATEADD(mi,330,b.ACT_DEP_DATETIME),TRIP_START_TIME) as ACTUAL_START_TIME, b.ACT_ARR_DATETIME AS TOUCH_POINT_ACT, isnull(DATEADD(mi,330,b.PLANNED_ARR_DATETIME),'') as ETA_DATETIME ,isnull(DATEADD(mi,330,b.EXP_ARR_DATETIME),'') as EXP_ETA_DATETIME "+
		 " ,isnull(PLANNED_DISTANCE,0) as PLANNED_DISTANCE,isnull(LOCATION,'') as LOCATION,c.LATITUDE,c.LONGITUDE , isnull(ACTUAL_DISTANCE,0) as ACTUAL_DISTANCE,isnull(TRIP_STATUS,'') as TRIP_STATUS, "+
		 " (PLANNED_DISTANCE - ACTUAL_DISTANCE) as DIST_TO_DEST,  "+
		 " (SELECT TOP 1 LOCATION_ID FROM CARGO_STOP_POINT_DETAILS WHERE STOP_IN_TIME IS NULL AND TRIP_ID = a.TRIP_ID ORDER BY SEQUENCE ) AS NEXT_POINT  "+
		 " FROM CARGO_SHIPMENT_DETAILS a  "+
		 " inner join CARGO_TRIP_DETAILS b on a.TRIP_ID=b.TRIP_ID "+
		 " inner join CARGO_STOP_POINT_DETAILS d ON b.TRIP_ID=d.TRIP_ID and ((b.SEQUENCE = (d.SEQUENCE-1)) or (b.SEQUENCE = 100) and d.TYPE='D ') "+
		 " INNER JOIN gpsdata_history_latest c on ASSET_NUMBER = REGISTRATION_NO  "+
		 " where SYSTEM_ID=? and CUSTOMER_ID =? AND a.STATUS = 'Open' and a.COMMUNICATION_STATUS='COMMUNICATING' # order by a.TRIP_ID ,b.SEQUENCE ";

	public static final String GET_COLUMN_HEADERS = "select TYPE as ID,VALUE as COLUMN_NAME,(case when TYPE=ISNULL(COLUMN_ID,0) then 'TRUE' else 'FALSE' end)as CHECKED_STATUS from AMS.dbo.LOOKUP_DETAILS a " +
		" left outer join AMS.dbo.CT_DASHBOARD_COLUMN_SETTING ct on ct.COLUMN_ID=a.TYPE and SYSTEM_ID=? AND CUSTOMER_ID=? and USER_ID=? " +
		" where VERTICAL='DISTRIBUTION_LOGISTICS' order by ORDER_OF_DISPLAY " ;

	public static final String CHECK_IF_PRESENT=" select * from AMS.dbo.CT_DASHBOARD_COLUMN_SETTING where COLUMN_ID=? and USER_ID=? and CUSTOMER_ID=? and SYSTEM_ID=?";

	public static final String INSERT_INTO_COLUMN_SETTINGS = " insert into AMS.dbo.CT_DASHBOARD_COLUMN_SETTING(COLUMN_ID,USER_ID,CUSTOMER_ID,SYSTEM_ID,INSERTED_BY,INSERTED_DATETIME) values (?,?,?,?,?,getutcdate()) ";

	public static final String GET_COLUMN_HEADERS_FOR_USER = "select * from AMS.dbo.CT_DASHBOARD_COLUMN_SETTING a " +
		" inner join AMS.dbo.LOOKUP_DETAILS b on a.COLUMN_ID=b.TYPE " +
		" where VERTICAL='DISTRIBUTION_LOGISTICS' and SYSTEM_ID=? AND CUSTOMER_ID=? and USER_ID=? order by ORDER_OF_DISPLAY ";

	public static final String DELETE_PREV_RECORDS = " delete from AMS.dbo.CT_DASHBOARD_COLUMN_SETTING where USER_ID=? and CUSTOMER_ID=? and SYSTEM_ID=? " ;
	
	public static final String GET_VEHICLE_ALLOCATION = "select isnull(z.NAME,'')as NAME,isnull(a.VEHICLE_TYPE,'') as VEHICLE_TYPE,isnull(a.MAKE,'') as MAKE,isnull(a.TYPE,'') as TYPE,isnull(b.ID,'') as ID," +
		" isnull(a.PLACEMENT_TIME,'') as ACTUAL_DETENTION,isnull(a.VEHICLE_NO,'') as VEHICLE_NO,isnull(a.VEHICLE_COUNT,0) as VEHICLE_COUNT,isnull(a.INDENT_ID,0) as INDENT_ID," +
		" isnull(a.ID,0) as vehicleIndentId,'' as ACTUAL_REPORT_DATETIME,DATEADD(DAY, DATEDIFF(DAY, 0,?), 0)+a.PLACEMENT_TIME as RequiredDate," +
		" dateadd(hour,1,getdate()) as currentdate " +
		"from AMS.dbo.INDENT_VEHICLE_DETAILS a "
		+ " inner join AMS.dbo.INDENT_MASTER_DETAILS b on a.INDENT_ID=b.ID" +
		 " left outer join LOCATION z on z.HUBID=b.NODE_ID " 
		+ " where # b.SYSTEM_ID=? and b.CUSTOMER_ID=? ";

	public static final String GET_VEHICLE_ALLOCATION_BASED_ON_INDENT = "select isnull(a.VEHICLE_TYPE,'') as VEHICLE_TYPE,isnull(a.MAKE,'') as MAKE,isnull(a.TYPE,'') as TYPE,isnull(b.ID,'') as ID," +
	" isnull(a.PLACEMENT_TIME,'') as ACTUAL_DETENTION,isnull(a.VEHICLE_NO,'') as VEHICLE_NO,isnull(a.VEHICLE_COUNT,0) as VEHICLE_COUNT,isnull(a.INDENT_ID,0) as INDENT_ID," +
	" isnull(a.ID,0) as vehicleIndentId,'' as ACTUAL_REPORT_DATETIME from AMS.dbo.INDENT_VEHICLE_DETAILS a "
	+ " inner join AMS.dbo.INDENT_MASTER_DETAILS b on a.INDENT_ID=b.ID"
	+ " where a.INDENT_ID=? ";
	
	public static final String INSERT_INDENT_DETAILS = "insert into AMS.dbo.INDENT_MASTER_DETAILS (NODE_ID,REGION,DEDICATED_COUNT,ADHOC_COUNT,TOTAL_COUNT,SUPERVISOR_NAME,SUPERVISOR_CONTACT,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,CUSTOMER_NAME) values "+
	" (?,?,?,?,?,?,?,?,?,?,getutcdate(),?) " ;

	public static final String UPDATE_INDENT_MASTER_DETAILS = " update INDENT_MASTER_DETAILS set REGION=?, DEDICATED_COUNT=?, ADHOC_COUNT=?,TOTAL_COUNT=?, SUPERVISOR_NAME=?, SUPERVISOR_CONTACT=? where ID=?" ;
	
	public static final String GET_INDENT_DETAILS = " select a.ID ,isnull(lz.NAME,'') as NODE,a.REGION,DEDICATED_COUNT,ADHOC_COUNT,TOTAL_COUNT,SUPERVISOR_NAME,isnull(SUPERVISOR_CONTACT,'')as SUPERVISOR_CONTACT , " +
	" isnull((select count(INDENT_ID) from AMS.dbo.INDENT_VEHICLE_DETAILS where INDENT_ID=a.ID),0) as COUNT, "+
	" isnull((select sum(VEHICLE_COUNT) from AMS.dbo.INDENT_VEHICLE_DETAILS where INDENT_ID=a.ID and TYPE='Ad-hoc' group by INDENT_ID),0) as ASSIGNED_ADHOC_COUNT," +
	" isnull((select sum(VEHICLE_COUNT) from AMS.dbo.INDENT_VEHICLE_DETAILS where INDENT_ID=a.ID and TYPE='Dedicated' group by INDENT_ID),0) as ASSIGNED_DEDICATED_COUNT" +
	" from AMS.dbo.INDENT_MASTER_DETAILS a " +
	" left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=a.NODE_ID " +
	" where SYSTEM_ID=? AND CUSTOMER_ID=? and CUSTOMER_NAME=? and a.NODE_ID in(select HubId from UserHubAssociation where UserId=? and SystemId=?) order by a.ID desc";
	
	public static final String GET_MAKES = " select Name from VehicleDocumentType where ClientId=0 and SystemId=? and TypeId=3 ";

	public static final String GET_INDENT_VEHICLE_DETAILS = " select " +
	" a.ID,isnull(lz.NAME,'') as NODE,a.INDENT_ID,a.VEHICLE_TYPE,a.MAKE,a.VEHICLE_COUNT,a.TYPE,PLACEMENT_TIME from AMS.dbo.INDENT_VEHICLE_DETAILS a " + 
	" inner join AMS.dbo.INDENT_MASTER_DETAILS b on a.INDENT_ID=b.ID " +
	" inner join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=b.NODE_ID " +
	" where INDENT_ID=? " ;
	
	public static final String INSERT_INDENT_VEHICLE_DETAILS = " insert AMS.dbo.INDENT_VEHICLE_DETAILS (INDENT_ID,VEHICLE_TYPE,MAKE,VEHICLE_COUNT,TYPE,PLACEMENT_TIME) values "+
	" (?,?,?,?,?,?) " ;

	public static final String GET_TOTAL_VEHICLE_COUNT = "select isnull((select ADHOC_COUNT from AMS.dbo.INDENT_MASTER_DETAILS where ID=b.INDENT_ID ),0) as ADHOC_COUNT, " +
    " isnull((select DEDICATED_COUNT from AMS.dbo.INDENT_MASTER_DETAILS where ID=b.INDENT_ID ),0) as DEDICATED_COUNT,isnull(sum(VEHICLE_COUNT),0) AS VEHICLE_COUNT,TYPE from AMS.dbo.INDENT_VEHICLE_DETAILS b WHERE INDENT_ID=? group by  TYPE,b.INDENT_ID ";

	public static final String GET_TOTAL_ASSIGNED_COUNT="select isnull(sum(VEHICLE_COUNT),0) AS VEHICLE_COUNT,TYPE from AMS.dbo.INDENT_VEHICLE_DETAILS b WHERE INDENT_ID=? group by  TYPE,b.INDENT_ID";
	
	public static final String UPDATE_INDENT_VEHICLE_DETAILS = "update AMS.dbo.INDENT_VEHICLE_DETAILS set VEHICLE_COUNT=?,TYPE=?,PLACEMENT_TIME=? # $ where ID=?"; 
	 
	public static final String GET_VEHICLE_BY_CUSTOMERID_SYSTEMID = "select ag.GROUP_NAME,vm.VehicleType,REGISTRATION_NUMBER from  VEHICLE_CLIENT vc " +
	 " inner join AMS.dbo.Vehicle_User vu on vu.System_id=vc.SYSTEM_ID and vu.Registration_no=vc.REGISTRATION_NUMBER " +
	 " inner join tblVehicleMaster vm on vm.VehicleNo=vu.Registration_no " + 
	 " inner join ADMINISTRATOR.dbo.ASSET_GROUP ag on vc.GROUP_ID=ag.GROUP_ID " + 
	 " where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no " +
	 " and REGISTRATION_NUMBER not in (select ttd.ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS ttd where ttd.ASSET_NUMBER is not null and ttd.STATUS='OPEN' and ttd.SYSTEM_ID=vc.SYSTEM_ID  ) " ;
	 //" and REGISTRATION_NUMBER not in (select apd.ASSET_NO from AMS.dbo.ASSET_REPORTING_DETAILS apd  where apd.DATE = ?) order by REGISTRATION_NUMBER DESC "; 

	 
	 public static final String GET_ASSET_REPORTING_BY_DATE ="select * from AMS.dbo.ASSET_REPORTING_DETAILS where DATE=? and SYSTEM_ID=? and CUSTOMER_ID=? AND INDENT_ID=?";
	
	 public static final String INSERT_INDENT_VEHICLE_DETAILS1 ="insert into AMS.dbo.ASSET_REPORTING_DETAILS(ASSET_NO,DATE,REPORT_TIME,HUB_ID,SYSTEM_ID,CUSTOMER_ID,INDENT_ID,VEHICLE_INDENT_ID) values " +
	 		"(?,?,?,?,?,?,?,?)";
	 
	public static final String GET_ASSETS_REGISTERD_TO_HUB_ID = " select distinct HUB_ID from AMS.dbo.ASSET_REPORTING_DETAILS " +
																 "where # DATE=? and SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String GET_REPORTED_VEHICLES =  " select isnull(z.NAME,'')as NAME,isnull(tbl.VehicleType,'')as VehicleType,isnull(ag.GROUP_NAME,'')as GROUP_NAME,b.ID as UNIQUE_ID,isnull(b.VEHICLE_INDENT_ID,0) AS vehicleIndentId, " +
		" isnull(b.INDENT_ID,0) AS ID,isnull(a.VEHICLE_TYPE,'') as VEHICLE_TYPE, t.STATUS as STATUS,isnull(dateadd(mi,?,b.INSERTED_DATETIME),'') as Actualvehicleallocated," +
		" isnull(a.MAKE,'')as MAKE, isnull(a.TYPE,'') as TYPE, isnull(b.ASSET_NO,'') AS VEHICLE_NO, isnull(b.REPORT_TIME,'') AS ACTUAL_DETENTION, " +
		" isnull(dateadd(mi,?,ACTUAL_REPORT_DATETIME),'') as ACTUAL_REPORT_DATETIME,DATEADD(DAY, DATEDIFF(DAY, 0,b.DATE), 0)+b.REPORT_TIME as RequiredDate,dateadd(hour,1,getdate()) as currentdate," +
		" (select count(distinct tt.TRIP_ID) as Count from TRACK_TRIP_DETAILS tt where tt.ASSET_NUMBER=ASSET_NO and tt.INSERTED_TIME>b.DATE ) as Counttt from  AMS.dbo.INDENT_VEHICLE_DETAILS a  " +
		" left outer join ASSET_REPORTING_DETAILS b on a.ID  = b.VEHICLE_INDENT_ID  " +
		" left outer join VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER= b.ASSET_NO " +
		" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.GROUP_ID=vc.GROUP_ID " +
		" left outer join  AMS.dbo.tblVehicleMaster tbl on tbl.VehicleNo=b.ASSET_NO " +
		" left outer join LOCATION z on z.HUBID=b.HUB_ID " +
		" left outer join (select STATUS,ASSET_NUMBER from  TRACK_TRIP_DETAILS where STATUS='OPEN' and SYSTEM_ID=? and CUSTOMER_ID=?) t on t.ASSET_NUMBER=b.ASSET_NO "+
		" where # b.SYSTEM_ID=? and b.CUSTOMER_ID=? and b.DATE =?  " ;

	public static final String GET_INDENT = " select isnull(count(*),0)  as IndentCount,INDENT_ID from AMS.dbo.ASSET_REPORTING_DETAILS where HUB_ID = ?  "+
	            	" group by INDENT_ID ";

	public static final String GET_HUB_DETAILS=" select distinct isnull(a.NODE_ID,'0') as HUBID,isnull(b.NAME,'')as HUBNAME from AMS.dbo.INDENT_MASTER_DETAILS a " 
		+ "left outer join AMS.dbo.LOCATION b on a.NODE_ID=b.HUBID " +
		"where SYSTEM_ID = ? and CUSTOMER_ID=? and a.NODE_ID in(select HubId from UserHubAssociation where UserId=? and SystemId=?)";
	
	public static final String GET_USER_ASSOCIATED_HUB = " select isnull(NAME,'')as HUBNAME,isnull(HUBID,'0')as HUBID from LOCATION WHERE" +
														 " OPERATION_ID!=2 and SYSTEMID=? and CLIENTID=? " +
														 " and HUBID IN(select HubId from UserHubAssociation where UserId=? and SystemId=?)";
	
	public static final String GET_ALERT_DETAILS="select count(TRIP_ID) as COUNT,'UNPLANNED_STOPPAGE' as STATUS from AMS.dbo.TRIP_EVENT_DETAILS e" +
	" where e.TRIP_ID in ( " +
	" select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td left outer join AMS.dbo.DES_TRIP_DETAILS ds" +
	" on td.TRIP_ID=ds.TRIP_ID where SEQUENCE=0 # and HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?)" +
	" and td.STATUS='OPEN' and SYSTEM_ID=? and CUSTOMER_ID=? ) and e.ALERT_TYPE=1" +
	" union all " +
	" select count(TRIP_ID) as COUNT,'ROUTE_DEVIATION' as STATUS from AMS.dbo.TRIP_EVENT_DETAILS a where TRIP_ID in ( " +
	" select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS  td left outer join AMS.dbo.DES_TRIP_DETAILS ds" +
	" on td.TRIP_ID=ds.TRIP_ID where SEQUENCE=0 # and HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?) and td.STATUS='OPEN'" +
	" and SYSTEM_ID=? and CUSTOMER_ID=? ) and ALERT_TYPE=5 " +
	" union all " +
	" select count( td.TRIP_ID) as COUNT,'COMPLETED_TRIPS' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on td.TRIP_ID=ds.TRIP_ID where SEQUENCE=0 # and HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?)" +
	" and td.STATUS='CLOSED'" +  
	" and SYSTEM_ID=? and CUSTOMER_ID=? and DATEADD(DAY, DATEDIFF(DAY, 0,td.ACTUAL_TRIP_START_TIME), 0)>= DATEADD(DAY, DATEDIFF(DAY, 0,CURRENT_TIMESTAMP), 0)" +
	" union all "+
	" select count(distinct td.TRIP_ID) as COUNT,'ENROUTE_TRIPS' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS td  " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on td.TRIP_ID=ds.TRIP_ID where SEQUENCE=0 # and HUB_ID in(select HubId from UserHubAssociation where UserId=? and SystemId=?)" +
	" and td.STATUS='OPEN' and dateadd(mi,isnull(td.PLANNED_DURATION,'0'),isnull(td.ACTUAL_TRIP_START_TIME,td.TRIP_START_TIME))>=getUTCDate() " +  
	" and SYSTEM_ID=? and CUSTOMER_ID=? "+
	" union all "+
	" select count(distinct td.TRIP_ID) as COUNT,'TAT' as STATUS from AMS.dbo.TRACK_TRIP_DETAILS td" +
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on td.TRIP_ID=ds.TRIP_ID where SEQUENCE=0 # and HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?)" +
	" and td.STATUS='OPEN' and dateadd(mi,isnull(td.PLANNED_DURATION,'0'),isnull(td.ACTUAL_TRIP_START_TIME,td.TRIP_START_TIME))<getUTCDate()"+
	" and SYSTEM_ID=? and CUSTOMER_ID=? ";
	
	public static final String GET_VEHICLE_PLACEMENT_DETAILS="select SUM(VEHICLE_COUNT) as COUNT,'TOTAL' as STATUS " +
	" from AMS.dbo.INDENT_VEHICLE_DETAILS a " +
	" left outer join AMS.dbo.INDENT_MASTER_DETAILS c on a.INDENT_ID=c.ID " +
	" where c.SYSTEM_ID=? and c.CUSTOMER_ID=? and DATEADD(DAY, DATEDIFF(DAY, 0,getdate()), 0)+PLACEMENT_TIME<=dateadd(hour,1,getdate())" +
	" and NODE_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?)# " +
	" union all " +
	" select COUNT(a.ASSET_NO)as COUNT,'PLACED' as STATUS from AMS.dbo.ASSET_REPORTING_DETAILS a " + 
	" where SYSTEM_ID=?  and CUSTOMER_ID=? and a.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?) and a.ASSET_NO !='' " +
	" and DATE= ? and DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME<=dateadd(hour,1,getdate()) $ " ;
	
	
	public static final String GET_DASHBOARD_TABLE_DATA="select isnull(td.TRIP_ID,0) as TRIP_ID,isnull(td.CUSTOMER_REF_ID,'') as VR_NO,isnull(td.ASSET_NUMBER,'') as VEHICLE_NO,isnull(td.ACTUAL_TRIP_START_TIME,'')as Start_Time, " +
	" isnull(ds1.NAME,'') as START_POINT,isnull(ds.NAME,'') as END_POINT, isnull(NEXT_POINT,'') as NEXT_TOUCH_POINT,isnull(td.SHIPMENT_ID,'') as TRIP_NO, " +
	" isnull(dateadd(mi,?,td.NEXT_POINT_ETA),'') as ETA_TO_NEXT_TOUCH_POINT,isnull(dateadd(mi,?,td.TRIP_START_TIME),'') as STD, " +
	" isnull(gps.LOCATION,'') as CURRENT_LOCATION,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as TRIP_START,  " +
	" isnull(PLANNED_DISTANCE,'0') as TOTAL_DISTANCE,isnull(ACTUAL_DISTANCE,'0') as TRAVELLED_DISTANCE, " +
	" isnull(td.ROUTE_ID,0) as ROUTE_ID,isnull(td.STATUS,'') as STATUS,  " +
	" isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA, isnull(td.TRIP_STATUS,'ONTIME') as ONTIME_DELAYED_STATUS," +
	" isnull(gps.LATITUDE,0) as LAT,isnull(gps.LONGITUDE,0) as LNG," +
	" case when isnull((DATEDIFF(mi,ds.PLANNED_ARR_DATETIME,DESTINATION_ETA)),0) > isnull((DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,(dateadd(mi,?,ACT_SRC_ARR_DATETIME)))),0) then 'RED' else 'GREEN' end as FLAG ," +
	" (case when td.ACTUAL_TRIP_END_TIME is null then dateadd(mi,?,getutcdate()) else dateadd(mi,?,td.ACTUAL_TRIP_END_TIME) end) as endDate," +
	" case when dateadd(mi,?,getdate()) > isnull(dateadd(mi,?,ds.ACT_ARR_DATETIME),'') THEN isnull(dateadd(mi,?,ds.ACT_ARR_DATETIME),'') else '' end as ACTUALARRIVALTIME_DEST," +
	" isnull((select isnull(e.GPS_DATETIME,'')as GMT from TRIP_EVENT_DETAILS e where e.TRIP_ID=td.TRIP_ID and e.ALERT_TYPE='0' and e.ALERT_NAME='Unload_Start'),'') as GPS_START,"+
	" isnull((select isnull(e.GPS_DATETIME,'')as GMT from TRIP_EVENT_DETAILS e where e.TRIP_ID=td.TRIP_ID and e.ALERT_TYPE='0' and e.ALERT_NAME='Unload_End'),'') as GPS_END " +
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100 " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0 " +
	" left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID " +
	" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS=? $ and ds1.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?)# ";
	
	
	public static final String GET_MLL_TABLE_DATA="select distinct isnull(dateadd(mi,?,td.DESTINATION_ETA),'') as ETA,isnull(dateadd(mi,?,ds.ACT_ARR_DATETIME),'') as ATA," +
	"isnull(td.ASSET_NUMBER,'') as VEHICLE_NO, isnull(ivd.VEHICLE_TYPE,'') as VehicleType,isnull(td.CUSTOMER_REF_ID,'') as VR_NO, " +
	"isnull(td.ORDER_ID,'') as ORDER_ID,isnull(gps.UNIT_NO,'') as GPSNO," +
	"isnull(td.ROUTE_NAME,'') as ROUTE_NAME,isnull(ds1.NAME,'') as OriginHubCode," +
	"isnull(b.DATE+b.REPORT_TIME,'') as ScheduledTimeOfPlacement, isnull(td.SWAPPED_VEHICLE,'') as SWAPPED_VEHICLE , " +
	"isnull(td.SEAL_NO,'') as SEAL_NO,isnull(td.NO_OF_BAGS,'') as NO_OF_BAGS,isnull(td.TRIP_TYPE,'') as TRIP_TYPE,isnull(td.NO_OF_FLUID_BAGS,'') as NO_OF_FLUID_BAGS,isnull(td.OPENING_KMS,0) as OPENING_KMS,isnull(td.TRIP_REMARKS,'') as REMARKS," +
	"isnull(dateadd(mi,?,b.INSERTED_DATETIME),'') as ActualTimeOfPlacement,isnull(dateadd(mi,?,b.ACTUAL_REPORT_DATETIME),'') as actualreporting," +
	"isnull(dateadd(mi,?,td.INSERTED_TIME),'')as TRIPDATETIME,isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as ActualTimeOfDeparture,datediff(mi,b.ACTUAL_REPORT_DATETIME,td.ACTUAL_TRIP_START_TIME)as OriginDetention," +
	"datediff(mi,ds.ACT_ARR_DATETIME,ds.ACT_DEP_DATETIME)as DestinationDetention," +	
	"isnull(ds.NAME,'') as DestinationHubCode,isnull(dateadd(mi,?,ds.ACT_ARR_DATETIME),'') as DestinationArrivalTime,isnull(dateadd(mi,?,ds.ACT_DEP_DATETIME),'') as DestinationDeptTime," +
	"isnull(td.ACTUAL_DISTANCE,0) as TOTAL_DISTANCE,isnull(td.PLANNED_DISTANCE,0) as TOTAL_EXPECTED_DISTANCE," +
	"isnull((td.STATUS + '-'+ td.TRIP_STATUS),'')as STATUS,DATEDIFF(mi,gps.GMT,getutcdate())as GPSTIME," +
	"DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,isnull(ds.ACT_ARR_DATETIME,td.ACTUAL_TRIP_END_TIME)) as TOTAL_TRIP_TIME," +
	"DATEDIFF(mi,ISNULL(td.TRIP_START_TIME,0),isnull(ds.PLANNED_ARR_DATETIME,0)) as EXPECTED_TOTAL_TRIP_TIME,isnull(dateadd(mi,?,td.ACTUAL_TRIP_END_TIME),'') as TRIP_END_TIME, " +
	"isnull(dp1.NAME,'')as DP1NAME,isnull(dateadd(mi,?,dp1.ACT_ARR_DATETIME),'')as DP1AAT,isnull(dateadd(mi,?,dp1.ACT_DEP_DATETIME),'')as DP1ADT,datediff(mi,dp1.ACT_ARR_DATETIME,dp1.ACT_DEP_DATETIME)as Dp1Detention," +
	"isnull(dp2.NAME,'')as DP2NAME,isnull(dateadd(mi,?,dp2.ACT_ARR_DATETIME),'')as DP2AAT,isnull(dateadd(mi,?,dp2.ACT_DEP_DATETIME),'')as DP2ADT,datediff(mi,dp2.ACT_ARR_DATETIME,dp2.ACT_DEP_DATETIME)as Dp2Detention," +
	"isnull(dp3.NAME,'')as DP3NAME,isnull(dateadd(mi,?,dp3.ACT_ARR_DATETIME),'')as DP3AAT,isnull(dateadd(mi,?,dp3.ACT_DEP_DATETIME),'')as DP3ADT,datediff(mi,dp3.ACT_ARR_DATETIME,dp3.ACT_DEP_DATETIME)as Dp3Detention," +
	"isnull(dp4.NAME,'')as DP4NAME,isnull(dateadd(mi,?,dp4.ACT_ARR_DATETIME),'')as DP4AAT,isnull(dateadd(mi,?,dp4.ACT_DEP_DATETIME),'')as DP4ADT,datediff(mi,dp4.ACT_ARR_DATETIME,dp4.ACT_DEP_DATETIME)as Dp4Detention, " +
	"INTRANSIT_REMARKS=STUFF((SELECT '+' + te.DESCRIPTION FROM dbo.TRIP_EVENT_DETAILS  te WHERE te.TRIP_ID = td.TRIP_ID and ALERT_TYPE=0 ORDER BY ID FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), " +
	"isnull((select isnull(e.GPS_DATETIME,'')as GMT from TRIP_EVENT_DETAILS e where e.TRIP_ID=td.TRIP_ID and e.ALERT_TYPE='0' and e.ALERT_NAME='Unload_Start'),'') as GPS_START, "+
	"isnull((select isnull(e.GPS_DATETIME,'')as GMT from TRIP_EVENT_DETAILS e where e.TRIP_ID=td.TRIP_ID and e.ALERT_TYPE='0' and e.ALERT_NAME='Unload_End'),'') as GPS_END " + 
	" from AMS.dbo.TRACK_TRIP_DETAILS td " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100 " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0 " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS dp1 on dp1.TRIP_ID=td.TRIP_ID and dp1.SEQUENCE=1 " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS dp2 on dp2.TRIP_ID=td.TRIP_ID and dp2.SEQUENCE=2 " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS dp3 on dp3.TRIP_ID=td.TRIP_ID and dp3.SEQUENCE=3 " +
	" left outer join AMS.dbo.DES_TRIP_DETAILS dp4 on dp4.TRIP_ID=td.TRIP_ID and dp4.SEQUENCE=4 " +
	" left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID " +
	" left outer join Route_Detail rd1 on rd1.Route_id=td.ROUTE_ID  "+
	" left outer join ASSET_REPORTING_DETAILS b on b.ASSET_NO=td.ASSET_NUMBER and DATEADD(DAY, DATEDIFF(DAY, 0, b.DATE), 0)=DATEADD(DAY, DATEDIFF(DAY, 0, td.INSERTED_TIME), 0) and b.HUB_ID=rd1.HUB_ID"+// and b.HUB_ID=ds1.HUB_ID"+
	" left outer join INDENT_VEHICLE_DETAILS ivd on ivd.ID=b.VEHICLE_INDENT_ID  "+
	" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and rd1.Route_Segment=1 and rd1.TYPE='SOURCE' & # $";	


//	public static final String GET_ON_TIME_PLACEMENT_DETAILS="select dateadd(mi,?,a.ACTUAL_REPORT_DATETIME) as TIME,COUNT(ASSET_NO) AS COUNT from AMS.dbo.ASSET_REPORTING_DETAILS a " + 
//		" left outer join AMS.dbo.INDENT_VEHICLE_DETAILS b on a.VEHICLE_INDENT_ID=b.ID  " +
//		" left outer join AMS.dbo.INDENT_MASTER_DETAILS c on a.INDENT_ID=c.ID "  +
//		" where a.ACTUAL_REPORT_DATETIME IS NOT NULL AND GROUP_ID IS NULL and "+
//		" a.DATE=? and " +
//		" a.SYSTEM_ID=? and a.CUSTOMER_ID=? # GROUP BY ASSET_NO,a.ACTUAL_REPORT_DATETIME ";
	
	
	
//	public static final String GET_ON_TIME_PLACEMENT_COUNTS=" select isnull(REPORT_TIME,'') as REPORT_TIME ,isnull(ACTUAL_REPORT_DATETIME,'') as ACTUAL_REPORT_DATETIME from  AMS.dbo.ASSET_REPORTING_DETAILS a " +
//	"where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?) and a.DATE=? # and ACTUAL_REPORT_DATETIME is not null and DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME<=dateadd(hour,1,getutcdate()) " ;
	
	public static final String GET_ON_TIME_PLACEMENT_COUNTS="select count(*) as count,'YET_TO_REACH' as STATUS " +
			" from  AMS.dbo.ASSET_REPORTING_DETAILS a " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and " +
			" a.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?) " +
			" and a.DATE=? and ACTUAL_REPORT_DATETIME is null and a.ASSET_NO !='' " +
			" and DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME<=dateadd(hour,1,getdate()) # " +
			" union all " +
			" select count(*) as count,'DELAYED' as STATUS " +
			" from  AMS.dbo.ASSET_REPORTING_DETAILS a " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and " +
			" a.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?) " +
			" and a.DATE=? and ACTUAL_REPORT_DATETIME is not null " +
			" and DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME<=dateadd(hour,1,getdate()) " +
			" and dateadd(mi,330,isnull(a.ACTUAL_REPORT_DATETIME,''))>DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME  # " +
			" union all " + 
			" select count(*) as count,'ONTIME' as STATUS " +
			" from  AMS.dbo.ASSET_REPORTING_DETAILS a " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and " +
			" a.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?) " +
			" and a.DATE=? and ACTUAL_REPORT_DATETIME is not null " +
			" and DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME<=dateadd(hour,1,getdate()) " +
			" and dateadd(mi,330,isnull(a.ACTUAL_REPORT_DATETIME,''))<=DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME # ";
	

	public static final String CHECK_IF_VEHICLE_PRESENT = " select * from ASSET_REPORTING_DETAILS where SYSTEM_ID=? and HUB_ID=? and ASSET_NO=? and DATE=? ";

	public static final String UPDATE_INDENT_DETAILS = "update ASSET_REPORTING_DETAILS set ASSET_NO=?,INSERTED_DATETIME=getutcdate() where ID=? and ASSET_NO!=?";
	
	public static final String GET_ALERT_TABLE_DETAILS = " select ID,isnull(VEHICLE_NO,'') as VEHICLE_NO,isnull(LOCATION,'') as LOCATION,isnull(dateadd(mi,?,GMT),'') as GMT,isnull(REMARKS,'') as REMARKS "
			+ " from AMS.dbo.TRIP_EVENT_DETAILS "
			+ " where TRIP_ID in (select td.TRIP_ID from AMS.dbo.TRACK_TRIP_DETAILS td left outer join AMS.dbo.DES_TRIP_DETAILS ds" +
			  " on td.TRIP_ID=ds.TRIP_ID where SEQUENCE=0 # and HUB_ID in(select HubId from UserHubAssociation where UserId=? and SystemId=?) " +
			  " and td.STATUS='OPEN'  and SYSTEM_ID=? and CUSTOMER_ID=? ) "
			+ " and ALERT_TYPE=? order by GMT DESC";
	
	public static final String GET_ASSET_MODEL_NAMES="select isnull(ModelName,'') as ModelName,isnull(ModelTypeId,0) as ModelTypeId from  FMS.dbo.Vehicle_Model (NOLOCK) where  SystemId=?  and ClientId=?";
	
	public static final String GET_VEHICLE_PLACEMENT_TABLE_DETAILS = " select isnull(lza.NAME,'') as NAME,isnull(a.ACTUAL_REPORT_DATETIME,'') as ACTUAL_REP_TIME, " +
			" isnull(ASSET_NO,'') as ASSET_NO,isnull(VEHICLE_TYPE,'') as VEHICLE_TYPE,isnull(MAKE,'') as VEHICLE_MAKE, " +
			" isnull(a.INSERTED_DATETIME,'') as vehicleassigned, " +
			" DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME as currentreporttime " +
			" from AMS.dbo.ASSET_REPORTING_DETAILS a " +
			" inner join AMS.dbo.LOCATION_ZONE_A lza on a.HUB_ID=lza.HUBID and lza.SYSTEMID=a.SYSTEM_ID " +
			" inner join AMS.dbo.INDENT_VEHICLE_DETAILS c on c.ID=a.VEHICLE_INDENT_ID " +
			" where SYSTEM_ID=?  and CUSTOMER_ID=? and a.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?) and a.ASSET_NO !='' " + 
			" and DATE= ? and DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME<=dateadd(hour,1,getdate())  # ";
	
	public static final String GET_VEHICLE_PLACEMENT_TABLE_DETAILS_YET_TO_PLACE ="select  isnull(lza.NAME,'') as NAME,isnull(b.ASSET_NO,'') AS ASSET_NO,"+
	" isnull(VEHICLE_TYPE,'') as VEHICLE_TYPE,isnull(MAKE,'') as VEHICLE_MAKE,DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME as currentreporttime,1 as COUNT"+
	" from  AMS.dbo.INDENT_VEHICLE_DETAILS a left outer join ASSET_REPORTING_DETAILS b on a.ID  = b.VEHICLE_INDENT_ID "+
	" inner join AMS.dbo.LOCATION_ZONE_A lza on b.HUB_ID=lza.HUBID and lza.SYSTEMID=b.SYSTEM_ID where b.ASSET_NO='' # and b.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?)"+
	" and b.SYSTEM_ID=? and b.CUSTOMER_ID=? and b.DATE =? and DATEADD(DAY, DATEDIFF(DAY, 0,b.DATE), 0)+b.REPORT_TIME<=dateadd(hour,1,getdate())"+
	" union all"+
	" select isnull(lza.NAME,'') as NAME,isnull(VEHICLE_NO,'')as ASSET_NO,isnull(VEHICLE_TYPE,'') as VEHICLE_TYPE,isnull(MAKE,'') as VEHICLE_MAKE,DATEADD(DAY, DATEDIFF(DAY, 0,?), 0)+PLACEMENT_TIME as currentreporttime,isnull(VEHICLE_COUNT,'') as COUNT from AMS.dbo.INDENT_VEHICLE_DETAILS a"+ 
	" inner join AMS.dbo.INDENT_MASTER_DETAILS b on a.INDENT_ID=b.ID inner join AMS.dbo.LOCATION_ZONE_A lza on NODE_ID=lza.HUBID and lza.SYSTEMID=?"+	 
	" where $ NODE_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?)and b.SYSTEM_ID=? and b.CUSTOMER_ID=? and DATEADD(DAY, DATEDIFF(DAY, 0,?), 0)+PLACEMENT_TIME<=dateadd(hour,1,getdate())"+ 
	" and a.ID not in (select VEHICLE_INDENT_ID from ASSET_REPORTING_DETAILS where DATE=? and DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME<=dateadd(hour,1,getdate()) )";
			

		
	public static final String GET_ONTIME_PLACEMENT_TABLE_DETAILS_NOT_REACHED="select isnull(lza.NAME,'') as NAME,isnull(a.ACTUAL_REPORT_DATETIME,'') as ACTUAL_REP_TIME, " +
		" isnull(ASSET_NO,'') as ASSET_NO,isnull(VEHICLE_TYPE,'') as VEHICLE_TYPE,isnull(MAKE,'') as VEHICLE_MAKE, " +
		" isnull(a.INSERTED_DATETIME,'') as vehicleassigned, " +
		" DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME as currentreporttime " +
		" from  AMS.dbo.ASSET_REPORTING_DETAILS a " +
		" inner join AMS.dbo.LOCATION_ZONE_A lza on a.HUB_ID=lza.HUBID and lza.SYSTEMID=a.SYSTEM_ID " +
		" inner join AMS.dbo.INDENT_VEHICLE_DETAILS c on c.ID=a.VEHICLE_INDENT_ID " + 
		" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and " +
		" a.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?) " +
		" and a.DATE=? and ACTUAL_REPORT_DATETIME is null and a.ASSET_NO !='' " +
		" and DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME<=dateadd(hour,1,getdate()) # ";
	
	public static final String GET_ONTIME_PLACEMENT_TABLE_DETAILS_DELAYED="select isnull(lza.NAME,'') as NAME,dateadd(mi,330,isnull(a.ACTUAL_REPORT_DATETIME,'')) as ACTUAL_REP_TIME, "+
		 " isnull(ASSET_NO,'') as ASSET_NO,isnull(VEHICLE_TYPE,'') as VEHICLE_TYPE,isnull(MAKE,'') as VEHICLE_MAKE,"+
		" dateadd(mi,330,isnull(a.INSERTED_DATETIME,'')) as vehicleassigned, "+
		" DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME as currentreporttime "+
		 " from  AMS.dbo.ASSET_REPORTING_DETAILS a "+
		" inner join AMS.dbo.LOCATION_ZONE_A lza on  a.HUB_ID=lza.HUBID and lza.SYSTEMID=a.SYSTEM_ID "+
		" inner join AMS.dbo.INDENT_VEHICLE_DETAILS c on c.ID=a.VEHICLE_INDENT_ID "+
		" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and "+
		" a.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?) "+
		" and a.DATE=? and ACTUAL_REPORT_DATETIME is not null and dateadd(mi,330,isnull(a.ACTUAL_REPORT_DATETIME,''))>DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME "+
		" and DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME<=dateadd(hour,1,getdate()) # ";
	
	public static final String GET_ONTIME_PLACEMENT_TABLE_DETAILS_ON_TIME=" select isnull(lza.NAME,'') as NAME,dateadd(mi,330,isnull(a.ACTUAL_REPORT_DATETIME,'')) as ACTUAL_REP_TIME, " +
		" isnull(ASSET_NO,'') as ASSET_NO,isnull(VEHICLE_TYPE,'') as VEHICLE_TYPE,isnull(MAKE,'') as VEHICLE_MAKE, " +
		" dateadd(mi,330,isnull(a.INSERTED_DATETIME,'')) as vehicleassigned, " +
		 " DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME as currentreporttime " +
		" from  AMS.dbo.ASSET_REPORTING_DETAILS a " +
		" inner join AMS.dbo.LOCATION_ZONE_A lza on a.HUB_ID=lza.HUBID and lza.SYSTEMID=a.SYSTEM_ID " +
		" inner join AMS.dbo.INDENT_VEHICLE_DETAILS c on c.ID=a.VEHICLE_INDENT_ID " +
		" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and " +
		" a.HUB_ID in (select HubId from UserHubAssociation where UserId=? and SystemId=?) " +
		" and a.DATE=? and ACTUAL_REPORT_DATETIME is not null and dateadd(mi,330,isnull(a.ACTUAL_REPORT_DATETIME,''))<=DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME " +
		" and DATEADD(DAY, DATEDIFF(DAY, 0,DATE), 0)+REPORT_TIME<=dateadd(hour,1,getdate()) # "; 
	
	
	public static final String GET_INDENT_FOR_HUB="select a.ID from AMS.dbo.INDENT_MASTER_DETAILS a left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=a.NODE_ID "+
													"where SYSTEM_ID=?  AND CUSTOMER_ID=? and CUSTOMER_NAME=? and HUBID=?";
	
	public static final String GET_INDENT_BY_ID = "select a.ID ,lz.HUBID as HUBID, isnull(lz.NAME,'') as NODE,a.REGION,DEDICATED_COUNT,ADHOC_COUNT,TOTAL_COUNT,SUPERVISOR_NAME,isnull(SUPERVISOR_CONTACT,'')as SUPERVISOR_CONTACT  " +
												  " from AMS.dbo.INDENT_MASTER_DETAILS a " +
												  " left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=a.NODE_ID where a.ID=? " ;
	
	public static final String INSERT_TRIP_REMARKS = "INSERT INTO TRIP_EVENT_DETAILS (TRIP_ID,VEHICLE_NO,ALERT_TYPE, GMT,GPS_DATETIME,LOCATION, ALERT_NAME, DESCRIPTION,HUB_ID,SYSTEM_ID,CUSTOMER_ID) VALUES (?,?,?,getutcdate(),getdate(),?,?,?,?,?,?)";
	
	public static final String INSERT_UNLOADINGSTART_DETAILS = "INSERT INTO AMS.dbo.TRIP_EVENT_DETAILS (GMT,TRIP_ID,VEHICLE_NO,ALERT_TYPE,LOCATION,ALERT_NAME,ACKNOWLEDGE_BY,ACKNOWLEDGE_DATETIME,SYSTEM_ID,CUSTOMER_ID,GPS_DATETIME) VALUES (DATEADD(mi,-?,?),?,?,?,?,?,?,getutcdate(),?,?,?)";
	public static final String INSERT_UNLOADINGEND_DETAILS = "INSERT INTO TRIP_EVENT_DETAILS (GMT,TRIP_ID,VEHICLE_NO,ALERT_TYPE,LOCATION,ALERT_NAME,ACKNOWLEDGE_BY,ACKNOWLEDGE_DATETIME,SYSTEM_ID,CUSTOMER_ID,GPS_DATETIME) VALUES (DATEADD(mi,-?,?),?,?,?,?,?,?,getutcdate(),?,?,?)";

	public static final String GET_UNLOADING_DETAILS = "SELECT isnull(dateadd(mi,?,td.UNLOADING_STARTTIME),'') as UNLOADING_STARTTIME,isnull(dateadd(mi,?,td.UNLOADING_ENDTIME),'') as UNLOADING_ENDTIME FROM AMS.dbo.TRACK_TRIP_DETAILS td WHERE td.TRIP_ID=?";

	public static final String GET_TRIP_REMARKS_BY_TRIP_ID = "SELECT isnull(DESCRIPTION,'') as DESCRIPTION FROM TRIP_EVENT_DETAILS WHERE TRIP_ID=?  AND ALERT_TYPE=0 ORDER BY ID";
	
	public static final String GET_INDENT_VEHICLE_COUNT_BY_HUBNAMES = "select a.ID as INDENT_ID,lz.NAME as NODE, isnull(DEDICATED_COUNT,0) as DEDICATED_COUNT ,isnull(ADHOC_COUNT,0) as ADHOC_COUNT,"+
	   																  "(select isnull(sum(VEHICLE_COUNT),0) from INDENT_VEHICLE_DETAILS where INDENT_ID=a.ID and TYPE='Dedicated') as ASSIGNED_DEDICATED,"+
	   																  "(select isnull(sum(VEHICLE_COUNT),0) from INDENT_VEHICLE_DETAILS where INDENT_ID=a.ID and TYPE='Ad-hoc') as ASSIGNED_ADHOC "+
	   																  " from INDENT_MASTER_DETAILS a left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=a.NODE_ID where "+
	   																  " SYSTEM_ID=? AND CLIENTID=? and CUSTOMER_NAME=? and lz.NAME IN(#)";
	
	public static final String GET_INDENTS_BY_HUBNAMES = "select a.ID as INDENT_ID, lz.NAME as NODE " +
	  													 " from AMS.dbo.INDENT_MASTER_DETAILS a left outer join AMS.dbo.LOCATION_ZONE_A lz on lz.HUBID=a.NODE_ID where " +
	  													 " SYSTEM_ID=? AND CLIENTID=? and CUSTOMER_NAME=? and lz.NAME IN(#)" ;

	public static final String VEHICLE_SUMMARY_REPORT = "select ASSET_NUMBER,isnull(ivd.VEHICLE_TYPE,'') as VehicleType," +
														" count(td.TRIP_ID) as TOTAL_NO_OF_TRIPS," +
														" sum(td.ACTUAL_DISTANCE) as TOTAL_DISTANCE_COVERED,"+ 
														" sum(rm.EXPECTED_DISTANCE) as TOTAL_DISTANACE_EXPECTED ," +
														" sum(DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,isNull(ds.ACT_ARR_DATETIME,td.ACTUAL_TRIP_END_TIME))) as TOTAL_DURATION " +
														" ,(select count(distinct DATE) from ASSET_REPORTING_DETAILS ar where ar.ASSET_NO=td.ASSET_NUMBER and DATE between" +
														" DATEADD(DAY, 0, DATEDIFF(DAY, 0, ? ))"+
														" and  DATEADD(DAY, 0, DATEDIFF(DAY, 0, ? ))) as NO_OF_ALLOCATED_DAYS"+
														" from AMS.dbo.TRACK_TRIP_DETAILS td"+  
														" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100"+  
														" left outer join AMS.dbo.DES_TRIP_DETAILS ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0"+   
														" left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID"+  
														" left outer join ASSET_REPORTING_DETAILS b on b.ASSET_NO=td.ASSET_NUMBER and "+
														" DATEADD(DAY, DATEDIFF(DAY, 0, b.DATE), 0)=DATEADD(DAY, DATEDIFF(DAY, 0, td.INSERTED_TIME), 0) "+ // and b.HUB_ID=ds1.HUB_ID"+
														" left outer join INDENT_VEHICLE_DETAILS ivd on ivd.ID=b.VEHICLE_INDENT_ID  "+
														" inner join tblVehicleMaster vm on vm.VehicleNo=td.ASSET_NUMBER "+
														" left outer join AMS.dbo.Route_Master rm on rm.RouteID=td.ROUTE_ID "+
														" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.STATUS<> 'OPEN' & group by ASSET_NUMBER,ivd.VEHICLE_TYPE "; //Check with and b.ACTUAL_REPORT_DATETIME IS NOT NULL
	
	public static final String GET_VEHICLES_FROM_VEHICLE_REPORTING_DATE_RANGE=" select distinct ASSET_NO as REGISTRATION_NUMBER from AMS.dbo.ASSET_REPORTING_DETAILS " +
																			  " where DATE between DATEADD(DAY, DATEDIFF(DAY, 0, ?), 0) and DATEADD(DAY, DATEDIFF(DAY, 0, ?), 0) and SYSTEM_ID = ? and CUSTOMER_ID=? and ASSET_NO !='' "; 

	public static final String VEHICLE_TRIP_REPORT = "select distinct CONVERT(CHAR(10), dateadd(mi,330,td.TRIP_START_TIME), 103) as DATE," +
													" isnull(dateadd(mi,?,td.ACTUAL_TRIP_START_TIME),'') as ActualTimeOfDeparture, " +
													" isnull(dateadd(mi,?,ds.ACT_ARR_DATETIME),'') as ATA,"+
													" isnull(td.ROUTE_NAME,'') as ROUTE_NAME,"+ 
													" isnull(td.ASSET_NUMBER,'') as VEHICLE_NO ,"+
													" dateadd(mi,?,b.ACTUAL_REPORT_DATETIME) as ACTUAL_REPORT_DATETIME,"+ 
													" isnull(dateadd(mi,?,ds.ACT_ARR_DATETIME),'') as DestinationArrivalTime, "+
													" isnull(dateadd(mi,?,td.ACTUAL_TRIP_END_TIME),'') as ACTUAL_TRIP_END_TIME, "+
													" isnull(td.ACTUAL_DISTANCE,0) as TOTAL_DISTANCE,"+
													" DATEDIFF(mi,gps.GMT,getutcdate())as GPSTIME, "+
													" DATEDIFF(mi,td.ACTUAL_TRIP_START_TIME,isNull(ds.ACT_ARR_DATETIME,td.ACTUAL_TRIP_END_TIME)) as TOTAL_TRIP_TIME,"+ 
													" isnull(rm.EXPECTED_DISTANCE,0) as TOTAL_EXPECTED_DISTANCE "+  
													" from AMS.dbo.TRACK_TRIP_DETAILS td"+
													" left outer join AMS.dbo.DES_TRIP_DETAILS ds on ds.TRIP_ID=td.TRIP_ID and ds.SEQUENCE=100"+  
													" left outer join AMS.dbo.DES_TRIP_DETAILS ds1 on ds1.TRIP_ID=td.TRIP_ID and ds1.SEQUENCE=0"+  
													" left outer join gpsdata_history_latest gps on gps.REGISTRATION_NO=td.ASSET_NUMBER and gps.System_id=td.SYSTEM_ID"+  
													" left outer join ASSET_REPORTING_DETAILS b on b.ASSET_NO=td.ASSET_NUMBER and DATEADD(DAY, DATEDIFF(DAY, 0, b.DATE), 0)=DATEADD(DAY, DATEDIFF(DAY, 0, td.INSERTED_TIME), 0)"+ 
													" and b.HUB_ID=ds1.HUB_ID"+
													" inner join tblVehicleMaster vm on vm.VehicleNo=td.ASSET_NUMBER"+ 
													" left outer join AMS.dbo.Route_Master rm on rm.RouteID=td.ROUTE_ID"+
													" where td.SYSTEM_ID=? and td.CUSTOMER_ID=?  and td.TRIP_START_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) & ";				
	
	
}
