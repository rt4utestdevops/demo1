package t4u.statements;

public class AutomotiveLogisticsStatements {

	public static final String GET_SOURCE_DESTINATION = " SELECT HUBID,NAME FROM AMS.dbo.LOCATION_ZONE WHERE OPERATION_ID not in (2,13) AND CLIENTID=? AND SYSTEMID=? ";
	
	public static final String GET_ON_TIME_VEHICLE_COUNT = "select count(*) as COUNTS  from gpsdata_history_latest a "
															+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
															+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
															+ "where a.CLIENTID = ? and a.System_id = ? and b.User_id=?";
	
	public static final String GET_DELAYED_VEHICLE_COUNT = "select count(*) as COUNTS from gpsdata_history_latest a "
															+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
															+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
															+ "where a.CLIENTID = ? and a.System_id = ? and b.User_id=?";
	
	public static final String GET_DELAYED_ADDRESS_VEHICLE_COUNT ="select count(*) as COUNTS  from gpsdata_history_latest a "
																	+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
																	+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
																	+ "where a.CLIENTID = ? and a.System_id = ? and b.User_id=?";
	
	public static final String GET_BEFORE_TIME_VEHICLE_COUNT = "select count(*) as COUNTS from gpsdata_history_latest a "
																+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "
																+" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id and Status='Active' "
																+ "where a.CLIENTID = ? and a.System_id = ? and b.User_id=?";
	
	public static final String GET_VEHICLE_DETAILS_FOR_DASHBOARD = "select TRIP_NAME,ASSET_NUMBER,SHIPMENNT_ID from dbo.CARGO_SHIPMENT_DETAILS a "+
																" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
																" inner join dbo.ROUTE_SKELETON c on c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID and c.ROUTE_ID=a.ROUTE_ID "+
																" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and COMMUNICATION_STATUS='COMMUNICATING' and a.TYPE=1 and b.User_id=? and c.TYPE='MLL SCM' "+
																" and DOMAIN_NAME!='ECOM' and TRIP_STATUS is not null and TRIP_STATUS!='NEW' and TRIP_START_TIME between ? and ? and TRIP_STATUS=? "+
																" and STATUS='Open' ";
	
	public static final String GET_VEHICLE_DETAILS_FOR_DASHBOARD_NEW = "select isNull(a.ROUTE_NAME,'') AS TRIP_NAME,ASSET_NUMBER,SHIPMENNT_ID from dbo.CARGO_SHIPMENT_DETAILS a "+
	" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and COMMUNICATION_STATUS='COMMUNICATING' and a.TYPE=1 and b.User_id=? "+
	" and DOMAIN_NAME!='ECOM' and TRIP_STATUS is not null and TRIP_STATUS!='NEW' and TRIP_START_TIME between ? and ? and TRIP_STATUS=? "+
	" and STATUS='Open' ";
	
	public static final String GET_DASHBOARD_COUNT = "select count(TRIP_STATUS) as COUNTS,a.TRIP_STATUS from dbo.CARGO_SHIPMENT_DETAILS a "+
													" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
													" where SYSTEM_ID=? and CUSTOMER_ID=? and COMMUNICATION_STATUS='COMMUNICATING' and TYPE=1 and b.User_id=? "+
													" and DOMAIN_NAME!='ECOM' and TRIP_STATUS is not null and TRIP_STATUS!='NEW' and TRIP_START_TIME between ? and ? "+
													" and STATUS='Open' group by a.TRIP_STATUS";
	
	public static final String GET_OVERSPEED_COUNT = " select count(distinct r.ASSET_NUMBER) as OVERSPEEDCOUNT from "+
		" (select distinct ASSET_NUMBER  from AMS.dbo.CARGO_SHIPMENT_DETAILS a "+
		" inner join ALERT.dbo.OVER_SPEED_DATA c on c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID and c.REGISTRATION_NO=a.ASSET_NUMBER collate database_default and c.GPS_DATETIME>a.TRIP_START_TIME "+ 
		" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
		" where a.SYSTEM_ID= ? and a.CUSTOMER_ID= ?  and a.COMMUNICATION_STATUS='COMMUNICATING' and TYPE=1 and b.User_id= ? "+
		" and a.DOMAIN_NAME!='ECOM' and a.TRIP_STATUS is not null and a.TRIP_STATUS!='NEW' and a.TRIP_START_TIME between  ? and ? "+
		" and a.STATUS='Open' and c.REMARK is null)r ";
		

	
	public static final String GET_STOPPAGE_COUNT = "select count(distinct r.ASSET_NUMBER) as Stoppagecount from "+
	" (select distinct ASSET_NUMBER from AMS.dbo.CARGO_SHIPMENT_DETAILS a "+
	" inner join AMS.dbo.Alert c on c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID and c.REGISTRATION_NO=a.ASSET_NUMBER and c.GPS_DATETIME>a.TRIP_START_TIME"+
	" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
	" where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and a.COMMUNICATION_STATUS='COMMUNICATING' and TYPE=1 and b.User_id= ? "+
	" and a.DOMAIN_NAME!='ECOM' and a.TRIP_STATUS is not null and a.TRIP_STATUS!='NEW' and a.TRIP_START_TIME between ? and ? "+
	" and a.STATUS='Open' and c.TYPE_OF_ALERT=1 and  (c.MONITOR_STATUS is null or c.MONITOR_STATUS='N'))r";

	
	public static final String GET_TRANSIT_POINT_FOR_TRIP = "select a.ID,c.NAME,a.HUB_ID,a.TRIP_ID,dateadd(mi,?,a.EXP_ARR_DATETIME) as REVISED_ETA,dateadd(mi,?,isnull(a.PLANNED_ARR_DATETIME,a.EXP_ARR_DATETIME)) as PLANNED_TIME,dateadd(mi,?,a.ACT_ARR_DATETIME) as ACTUAL_TIME,dateadd(mi,?,a.ACT_DEP_DATETIME) as ACT_DEP_DATETIME,a.SEQUENCE,isnull(datediff(mi,dateadd(mi,?,a.PLANNED_ARR_DATETIME),isnull(dateadd(mi,?,a.ACT_ARR_DATETIME),getdate())),0) as MINS_DIFF, "+
															" isnull(datediff(mi,dateadd(mi,?,a.PLANNED_ARR_DATETIME),isnull(dateadd(mi,?,a.ACT_DEP_DATETIME),getdate())),0) as MINS_DIFF1,Isnull(a.REMARKS,'') as REMARKS,Isnull(a.ACTION_STATUS, 'Active') as ACTION_STATUS,isnull(a.ISSUE,'') as ISSUE,b.STATUS as TRIP_STATUS,a.STATUS as pointstatus,b.TRIP_STATUS as SHIPMENT_STATUS,d.LATITUDE,d.LONGITUDE,d.GPS_DATETIME,d.LOCATION,d.CATEGORY,d.SPEED,e.DESTINATION_DEPARTURE as ETA ,e.TRIP_CODE as MODE,VehicleType , TRIP_START_TIME as START_TIME , isnull(TRIP_END_TIME,getdate()) as END_TIME , c.LATITUDE as HUB_LAT,c.LONGITUDE as HUB_LONG"+
															" from AMS.dbo.CARGO_TRIP_DETAILS a "+
															" inner join AMS.dbo.CARGO_SHIPMENT_DETAILS b on b.TRIP_ID=a.TRIP_ID "+
															" inner join AMS.dbo.LOCATION_ZONE_A c on c.SYSTEMID=b.SYSTEM_ID and CLIENTID=b.CUSTOMER_ID and c.HUBID=a.HUB_ID "+ 
															" inner join AMS.dbo.gpsdata_history_latest d on d.System_id=b.SYSTEM_ID and d.CLIENTID=b.CUSTOMER_ID and d.REGISTRATION_NO=b.ASSET_NUMBER "+
															" left outer join AMS.dbo.ROUTE_SKELETON e on e.SYSTEM_ID=b.SYSTEM_ID and e.ROUTE_ID=b.ROUTE_ID " +
															" inner join AMS.dbo.tblVehicleMaster tv on tv.System_id=b.SYSTEM_ID and tv.VehicleNo=b.ASSET_NUMBER " +
															" where a.STATUS not in ('ORIGIN','DESTINATION') "+
															" and a.TRIP_ID in (select top 1 TRIP_ID from dbo.CARGO_SHIPMENT_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and "+ 
															" ASSET_NUMBER=? and SHIPMENNT_ID=? order by TRIP_ID desc) "+
															" order by SEQUENCE";
	
	public static final String GET_TRANSIT_POINT_FOR_TRIP_NEW =  " select a.ID,c.LOCATION_ID AS NAME,(SELECT TOP 1 LOCATION_ID FROM AMS.dbo.CARGO_STOP_POINT_DETAILS where TRIP_ID = (SELECT TOP 1 TRIP_ID FROM CARGO_SHIPMENT_DETAILS WHERE SHIPMENNT_ID = ?) ORDER BY SEQUENCE DESC ) as NAME_1,(SELECT TOP 1 LATITUDE FROM AMS.dbo.CARGO_STOP_POINT_DETAILS where TRIP_ID = (SELECT TOP 1 TRIP_ID FROM CARGO_SHIPMENT_DETAILS WHERE SHIPMENNT_ID = ?) ORDER BY SEQUENCE DESC ) as LAST_LAT,(SELECT TOP 1 LONGITUDE FROM AMS.dbo.CARGO_STOP_POINT_DETAILS where TRIP_ID = (SELECT TOP 1 TRIP_ID FROM CARGO_SHIPMENT_DETAILS WHERE SHIPMENNT_ID = ?) ORDER BY SEQUENCE DESC ) as LAST_LONG,a.HUB_ID,a.TRIP_ID,dateadd(mi,?,a.EXP_ARR_DATETIME) as REVISED_ETA,dateadd(mi,?,isnull(a.PLANNED_ARR_DATETIME,a.EXP_ARR_DATETIME)) as PLANNED_TIME,dateadd(mi,?,a.ACT_ARR_DATETIME) as ACTUAL_TIME,dateadd(mi,?,a.ACT_DEP_DATETIME) as ACT_DEP_DATETIME,a.SEQUENCE,isnull(datediff(mi,dateadd(mi,?,a.PLANNED_ARR_DATETIME),isnull(dateadd(mi,?,a.ACT_ARR_DATETIME),getdate())),0) as MINS_DIFF, "+
  	" isnull(datediff(mi,dateadd(mi,?,a.PLANNED_ARR_DATETIME),isnull(dateadd(mi,?,a.ACT_DEP_DATETIME),getdate())),0) as MINS_DIFF1,Isnull(a.REMARKS,'') as REMARKS,Isnull(a.ACTION_STATUS, 'Active') as ACTION_STATUS,isnull(a.ISSUE,'') as ISSUE,b.STATUS as TRIP_STATUS,a.STATUS as pointstatus,b.TRIP_STATUS as SHIPMENT_STATUS,d.LATITUDE,d.LONGITUDE,d.GPS_DATETIME,d.LOCATION,d.CATEGORY,d.SPEED,'' as ETA ,'NA' as MODE,VehicleType , TRIP_START_TIME as START_TIME , isnull(TRIP_END_TIME,getdate()) as END_TIME , c.LATITUDE as HUB_LAT,c.LONGITUDE as HUB_LONG"+
	" from AMS.dbo.CARGO_TRIP_DETAILS a "+
	" inner join AMS.dbo.CARGO_SHIPMENT_DETAILS b on b.TRIP_ID=a.TRIP_ID "+
	" inner join AMS.dbo.gpsdata_history_latest d on d.System_id=b.SYSTEM_ID and d.CLIENTID=b.CUSTOMER_ID and d.REGISTRATION_NO=b.ASSET_NUMBER "+
	" inner join AMS.dbo.tblVehicleMaster tv on tv.System_id=b.SYSTEM_ID and tv.VehicleNo=b.ASSET_NUMBER  "+
    " left outer join AMS.dbo.CARGO_STOP_POINT_DETAILS c on b.TRIP_ID=c.TRIP_ID and (c.SEQUENCE= (a.SEQUENCE+1) or (a.SEQUENCE=100 and c.TYPE='D' )) "+
	" where a.STATUS not in ('ORIGIN','DESTINATION') "+
	" and a.TRIP_ID in (select top 1 TRIP_ID from dbo.CARGO_SHIPMENT_DETAILS where SYSTEM_ID= ? and CUSTOMER_ID= ? and  "+
	" ASSET_NUMBER= ? and SHIPMENNT_ID= ? order by TRIP_ID desc) "+
	" order by SEQUENCE ";
	
	public static final String UPDATE_REMARKS_AND_ACTION_STATUS="update AMS.dbo.CARGO_TRIP_DETAILS set ISSUE=?, REMARKS=?, ACTION_STATUS=? where ID=?";
	
	public static final String CHECK_ACTION_STATUS_CLOSED=" select * from AMS.dbo.CARGO_TRIP_DETAILS where TRIP_ID=? and STATUS='DELAYED' and ACTION_STATUS!='Closed'  ";
	
	public static final String UPDATE_TRIP_STATUS_AS_DELAYED_ADDRESSED=" update AMS.dbo.CARGO_SHIPMENT_DETAILS set TRIP_STATUS='DELAYED ADDRESSED' where TRIP_ID=? ";
	
	public static final String GET_ISSUES_LIST = "select VALUE from AMS.dbo.LOOKUP_DETAILS where VERTICAL='AUTOMOTIVE_LOGISTICS' and TYPE='ISSUES' ";

	public static final String GET_STOPPAGE_DETAILS = " select   ASSET_NUMBER , c.LOCATION,c.GMT, c.SLNO,c.GPS_DATETIME,c.STOP_HOURS from AMS.dbo.CARGO_SHIPMENT_DETAILS a "+
	" inner join AMS.dbo.Alert c on c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID and c.REGISTRATION_NO=a.ASSET_NUMBER and c.GPS_DATETIME>a.TRIP_START_TIME "+
	" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.COMMUNICATION_STATUS='COMMUNICATING' and TYPE=1 and b.User_id= ? "+ 
	" and a.DOMAIN_NAME!='ECOM' and a.TRIP_STATUS is not null and a.TRIP_STATUS!='NEW' and a.TRIP_START_TIME between ? and ? "+
	" and a.STATUS='Open' and c.TYPE_OF_ALERT=1 and  (c.MONITOR_STATUS is null or c.MONITOR_STATUS='N') ";
	
	
	public static final String GET_OVERSPEED_DETAILS = " select  ASSET_NUMBER , c.LOCATION,c.GMT, c.ID,c.GPS_DATETIME,c.SPEED from AMS.dbo.CARGO_SHIPMENT_DETAILS a "+
	" inner join ALERT.dbo.OVER_SPEED_DATA c on c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID and c.REGISTRATION_NO=a.ASSET_NUMBER collate database_default and c.GPS_DATETIME>a.TRIP_START_TIME "+
	" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
	" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.COMMUNICATION_STATUS='COMMUNICATING' and TYPE=1 and b.User_id=? "+
	" and a.DOMAIN_NAME!='ECOM' and a.TRIP_STATUS is not null and a.TRIP_STATUS!='NEW' and a.TRIP_START_TIME between ? and ? "+
	" and a.STATUS='Open' and c.REMARK is null ";
	
	
	
	//***********************************************Automotive Logistics Export *******************************//
	
	public static final String GET_HUB_REPORT= " select a.TRIP_STATUS,a.TRIP_ID,a.ASSET_NUMBER,a.SHIPMENNT_ID,b.TRIP_NAME,a.STATUS,VehicleType,b.ROUTE_ID,d.GROUP_ID,e.GROUP_NAME,STOPPAGE_TIME,TRIP_START_TIME "+ 
                                         " from AMS.dbo.CARGO_SHIPMENT_DETAILS a "+
                                         " inner join AMS.dbo.ROUTE_SKELETON b on b.SYSTEM_ID=a.SYSTEM_ID and b.CUSTOMER_ID=a.CUSTOMER_ID and b.ROUTE_ID = a.ROUTE_ID "+
                                         " inner join AMS.dbo.tblVehicleMaster c on c.System_id=a.SYSTEM_ID and c.VehicleNo=a.ASSET_NUMBER "+
                                         " inner join AMS.dbo.VEHICLE_CLIENT d on d.SYSTEM_ID=a.SYSTEM_ID and d.CLIENT_ID=a.CUSTOMER_ID and d.REGISTRATION_NUMBER=a.ASSET_NUMBER "+
                                         " inner join ADMINISTRATOR.dbo.ASSET_GROUP e on e.SYSTEM_ID=d.SYSTEM_ID and e.CUSTOMER_ID=d.CLIENT_ID and d.GROUP_ID=e.GROUP_ID "+
										 " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and TRIP_START_TIME between ? and ? and a.TYPE=1 and COMMUNICATION_STATUS='COMMUNICATING' and DOMAIN_NAME!='ECOM' order by TRIP_START_TIME ";
	
	public static final String GET_TRIP_DETAILS = " select (select top 1 SEQUENCE from CARGO_STOP_POINT_DETAILS WHERE TRIP_ID = a.TRIP_ID AND TYPE= 'D ' ORDER BY SEQUENCE DESC ) as MAX_TRANSIT_POINT,a.TRIP_STATUS,a.TRIP_ID,a.ASSET_NUMBER,a.SHIPMENNT_ID,isnull(ROUTE_NAME,'') AS TRIP_NAME,a.STATUS,VehicleType,isnull(MODE,'') AS ROUTE_ID,d.GROUP_ID,e.GROUP_NAME,STOPPAGE_TIME,TRIP_START_TIME "+ 
    " from AMS.dbo.CARGO_SHIPMENT_DETAILS a "+
    " inner join AMS.dbo.tblVehicleMaster c on c.System_id=a.SYSTEM_ID and c.VehicleNo=a.ASSET_NUMBER "+
    " inner join AMS.dbo.VEHICLE_CLIENT d on d.SYSTEM_ID=a.SYSTEM_ID and d.CLIENT_ID=a.CUSTOMER_ID and d.REGISTRATION_NUMBER=a.ASSET_NUMBER "+
    " inner join ADMINISTRATOR.dbo.ASSET_GROUP e on e.SYSTEM_ID=d.SYSTEM_ID and e.CUSTOMER_ID=d.CLIENT_ID and d.GROUP_ID=e.GROUP_ID "+
	 " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and TRIP_START_TIME between ? and ? and a.TYPE=1 and COMMUNICATION_STATUS='COMMUNICATING' and DOMAIN_NAME!='ECOM' order by MAX_TRANSIT_POINT desc";
	
	public static final String GET_TRIP_DETAILS_MM = " select (select top 1 SEQUENCE from CARGO_TRIP_DETAILS WHERE TRIP_ID = a.TRIP_ID AND SEQUENCE <> 100 ORDER BY SEQUENCE DESC ) as MAX_TRANSIT_POINT,a.TRIP_STATUS,a.TRIP_ID,a.ASSET_NUMBER,a.SHIPMENNT_ID,isnull(ROUTE_NAME,'') AS TRIP_NAME,a.STATUS,VehicleType,isnull(MODE,'') AS ROUTE_ID,d.GROUP_ID,e.GROUP_NAME,STOPPAGE_TIME,TRIP_START_TIME,PLANNED_DISTANCE,ISNULL(ACTUAL_DISTANCE,0) as ACT_DIST,ISNULL(a.AUTO_CLOSE,0) as AUTO_CLOSE "+ 
    " from AMS.dbo.CARGO_SHIPMENT_DETAILS a "+
    " inner join AMS.dbo.tblVehicleMaster c on c.System_id=a.SYSTEM_ID and c.VehicleNo=a.ASSET_NUMBER "+
    " inner join AMS.dbo.VEHICLE_CLIENT d on d.SYSTEM_ID=a.SYSTEM_ID and d.CLIENT_ID=a.CUSTOMER_ID and d.REGISTRATION_NUMBER=a.ASSET_NUMBER "+
    " inner join ADMINISTRATOR.dbo.ASSET_GROUP e on e.SYSTEM_ID=d.SYSTEM_ID and e.CUSTOMER_ID=d.CLIENT_ID and d.GROUP_ID=e.GROUP_ID "+
	 " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and TRIP_START_TIME between ? and ? and a.TYPE=1 and COMMUNICATION_STATUS='COMMUNICATING' and DOMAIN_NAME!='ECOM' order by MAX_TRANSIT_POINT desc";
	
	public static final String GET_CHECKPOINT_DETAILS= " select SEQUENCE,NAME,HUB_ID,isnull(dateadd(mi,?,PLANNED_ARR_DATETIME),'') as ETA,isnull(dateadd(mi,?,ACT_ARR_DATETIME),'') as actualtime,isnull(dateadd(mi,?,ACT_DEP_DATETIME),'') as actualtimedep,  '' as planneDepTime, "+
													 " isnull(datediff(mi,dateadd(mi,?,PLANNED_ARR_DATETIME),isnull(dateadd(mi,?,ACT_ARR_DATETIME),getdate())),0) as diffhh,STATUS,isnull(ISSUE,'') as issues,isnull(REMARKS,'') as remarks,isnull(ACTION_STATUS,'') as actionstatus, DISTANCE "+
													 " from dbo.CARGO_TRIP_DETAILS a inner join AMS.dbo.LOCATION_ZONE_A b on a.HUB_ID=b.HUBID "+
													 " where b.SYSTEMID=? and CLIENTID=? and TRIP_ID=? order by SEQUENCE";
	
	

	public static final String GET_CHECKPOINT_DETAILS_NEW= " select a.SEQUENCE,isnull(c.LOCATION_ID,'NA') as NAME,isnull(dateadd(mi,?,PLANNED_ARR_DATETIME),'') as ETA,isnull(dateadd(mi,?,ACT_ARR_DATETIME),'') as actualtime,isnull(dateadd(mi,?,ACT_DEP_DATETIME),'') as actualtimedep, "+
													 " isnull(datediff(mi,dateadd(mi,?,PLANNED_ARR_DATETIME),isnull(dateadd(mi,?,ACT_ARR_DATETIME),getdate())),0) as diffhh,a.STATUS,isnull(ISSUE,'') as issues,isnull(REMARKS,'') as remarks,isnull(ACTION_STATUS,'') as actionstatus "+
													 " from dbo.CARGO_TRIP_DETAILS a right outer join CARGO_SHIPMENT_DETAILS b on a.TRIP_ID=b.TRIP_ID "+
													 " left outer join AMS.dbo.CARGO_STOP_POINT_DETAILS c on b.TRIP_ID=c.TRIP_ID and (c.SEQUENCE= (a.SEQUENCE+1) or (a.SEQUENCE=100 and c.TYPE='D' )) "+
													 " where b.SYSTEM_ID=? and b.CUSTOMER_ID=? and b.TRIP_ID=? order by a.SEQUENCE";

	public static final String GET_CHECKPOINT_DETAILS_New= " select a.SEQUENCE,isnull(c.LOCATION_ID,'NA') as NAME,isnull(dateadd(mi,?,PLANNED_ARR_DATETIME),'') as ETA,isnull(dateadd(mi,?,ACT_ARR_DATETIME),'') as actualtime,isnull(c.STOP_OUT_TIME,'') as actualtimedep, isnull(a.PLANNED_DEP_DATETIME,'') as planneDepTime ,"+
	 " isnull(datediff(mi,dateadd(mi,?,PLANNED_ARR_DATETIME),isnull(dateadd(mi,?,ACT_ARR_DATETIME),getdate())),0) as diffhh,a.STATUS,isnull(ISSUE,'') as issues,isnull(REMARKS,'') as remarks,isnull(ACTION_STATUS,'') as actionstatus "+
	 " from dbo.CARGO_TRIP_DETAILS a right outer join CARGO_SHIPMENT_DETAILS b on a.TRIP_ID=b.TRIP_ID "+
	 " left outer join AMS.dbo.CARGO_STOP_POINT_DETAILS c on b.TRIP_ID=c.TRIP_ID and (c.SEQUENCE= (a.SEQUENCE+1) or (a.SEQUENCE=100 and c.TYPE='D' )) "+
	 " where b.SYSTEM_ID=? and b.CUSTOMER_ID=? and b.TRIP_ID=? order by a.SEQUENCE";
 
	
	public static final String GET_VEHICLE_AVAILABILITY_DETAILS= " select * from (select  isnull(a.ASSET_NUMBER,'') as ASSET_NUMBER ,a.TRIP_ID,c.LOCATION_ID as DESTINATION ,TRIP_END_TIME, isnull(live.LOCATION,'')as LOCATION,isnull(d.ACT_ARR_DATETIME,a.TRIP_END_TIME) as ACT_ARR_DATETIME , ROW_NUMBER() OVER(PARTITION BY a.ASSET_NUMBER ORDER BY a.TRIP_ID DESC) rn "+   
	 " from CARGO_SHIPMENT_DETAILS a "+  
	 " inner join CARGO_STOP_POINT_DETAILS c on a.TRIP_ID=c.TRIP_ID and c.TYPE='D ' "+
	 " inner join Vehicle_association vr on  vr.Registration_no = a.ASSET_NUMBER  and vr.System_id = a.SYSTEM_ID and  vr.Client_id = CUSTOMER_ID "+
	 " LEFT OUTER JOIN dbo.gpsdata_history_latest live on live.System_id = a.SYSTEM_ID and live.CLIENTID=a.CUSTOMER_ID and live.REGISTRATION_NO=a.ASSET_NUMBER "+  
	 " LEFT OUTER JOIN CARGO_TRIP_DETAILS d On a.TRIP_ID=d.TRIP_ID "+ 
	 " where SYSTEM_ID= ? and CUSTOMER_ID = ? and INSERTED_TIME < GETDATE() "+   
	 " and TRIP_END_TIME is NOT null and d.SEQUENCE=100 and ROUTE_ID <> 0 and COMMUNICATION_STATUS = 'COMMUNICATING' AND AUTO_CLOSE IS NOT NULL and CARGO_STATUS = 'CLOSED' and SHIPMENNT_ID LIKE 'SAU%' "+  
	 " AND vr.VALID = 'Y' and ASSET_NUMBER NOT IN (SELECT ASSET_NUMBER FROM CARGO_SHIPMENT_DETAILS where SYSTEM_ID = ? and CUSTOMER_ID = ? and INSERTED_TIME < GETDATE() "+   
	 " and TRIP_END_TIME is NULL and ROUTE_ID <> 0 and COMMUNICATION_STATUS = 'COMMUNICATING' AND AUTO_CLOSE IS NULL AND CARGO_STATUS = 'OPEN' ))r  where rn = 1 ";
	
public static final String GET_IN_TRANSIT_VEHICLE_DETAILS=" select isnull(a.ASSET_NUMBER,'') as ASSET_NUMBER,isnull(b.LOCATION_ID,'') as SOURCE,isnull(c.LOCATION_ID,'') as DESTINATION,c.ETA as DESTINATION_ETA ,TRIP_END_TIME, isnull(live.LOCATION,'')as LOCATION,isnull(d.EXP_ARR_DATETIME,'') as EXP_ARR_DATETIME " +
	" from CARGO_SHIPMENT_DETAILS a " +
	" inner join CARGO_STOP_POINT_DETAILS b on a.TRIP_ID=b.TRIP_ID and b.TYPE='P ' "+
	" inner join CARGO_STOP_POINT_DETAILS c on a.TRIP_ID=c.TRIP_ID and c.TYPE='D ' " +
	" LEFT OUTER JOIN dbo.gpsdata_history_latest live on live.System_id = a.SYSTEM_ID and live.CLIENTID=a.CUSTOMER_ID and live.REGISTRATION_NO=a.ASSET_NUMBER " +
	" LEFT OUTER JOIN CARGO_TRIP_DETAILS d On a.TRIP_ID=d.TRIP_ID  " +
	" where SYSTEM_ID=? and CUSTOMER_ID = ? and INSERTED_TIME between dateadd(mi,1110,dateadd(dd,-1,?)) and dateadd(mi,1110,?) and TRIP_END_TIME is null and d.SEQUENCE=100 and ROUTE_ID <> 0 and COMMUNICATION_STATUS='COMMUNICATING' AND AUTO_CLOSE IS NULL and CARGO_STATUS = 'OPEN' and SHIPMENNT_ID LIKE 'SAU%' ";

public static final String GET_SEQUENCE_DETAILS = " select TRIP_ID,HUB_ID,ACT_ARR_DATETIME,SEQUENCE,LONGITUDE,LATITUDE,DISTANCE, (select TOP 1 SEQUENCE FROM AMS.dbo.CARGO_TRIP_DETAILS WHERE ACT_ARR_DATETIME IS NOT NULL AND TRIP_ID = ? ORDER BY SEQUENCE DESC) AS CURRENT_LOC_SEQ ,"+ 
                                                  " (select TOP 1 HUB_ID FROM AMS.dbo.CARGO_TRIP_DETAILS WHERE SEQUENCE = 0 AND TRIP_ID = ? ORDER BY SEQUENCE DESC ) as SOURCE_HUB ,(select TOP 1 HUB_ID FROM AMS.dbo.CARGO_TRIP_DETAILS WHERE SEQUENCE = 100 AND TRIP_ID = ? ORDER BY SEQUENCE DESC ) as DEST_HUB  "+													
                                                  " from AMS.dbo.CARGO_TRIP_DETAILS a left outer join AMS.dbo.LOCATION_ZONE_A on HUB_ID=HUBID "+
												  " where TRIP_ID=? AND SYSTEMID= ? AND CLIENTID =? ORDER BY SEQUENCE ";

public static final String END_TRIP = "UPDATE CARGO_SHIPMENT_DETAILS SET AUTO_CLOSE = 'N', TRIP_END_TIME = getdate(), ACTUAL_DISTANCE = ? , STATUS = 'Closed', CARGO_STATUS= 'CLOSED' WHERE TRIP_ID = ? AND SHIPMENNT_ID =? AND SYSTEM_ID = ?";

public static final String GET_OVERSPEED_COUNT_FOR_NEW_DASHBOARD = " select count(distinct r.ASSET_NUMBER) as COUNT,flag=1 from "+
			" (select distinct ASSET_NUMBER  from AMS.dbo.CARGO_SHIPMENT_DETAILS a "+
			" inner join ALERT.dbo.OVER_SPEED_DATA c on c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID and c.REGISTRATION_NO=a.ASSET_NUMBER collate database_default and c.GPS_DATETIME>a.TRIP_START_TIME "+ 
			" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
			" where a.SYSTEM_ID= ? and a.CUSTOMER_ID= ?  and a.COMMUNICATION_STATUS='COMMUNICATING' and TYPE=1 and b.User_id= ? "+
			" and a.DOMAIN_NAME!='ECOM' and a.TRIP_STATUS is not null and a.TRIP_STATUS!='NEW' "+
			" and a.STATUS='Open' and c.REMARK is null)r "+
			" union all"+ 
			" select count(distinct r.ASSET_NUMBER) as COUNT,flag=2 from "+
			" (select distinct ASSET_NUMBER from AMS.dbo.CARGO_SHIPMENT_DETAILS a "+
			" inner join AMS.dbo.Alert c on c.SYSTEM_ID=a.SYSTEM_ID and c.CUSTOMER_ID=a.CUSTOMER_ID and c.REGISTRATION_NO=a.ASSET_NUMBER and c.GPS_DATETIME>a.TRIP_START_TIME"+
			" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
			" where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? and a.COMMUNICATION_STATUS='COMMUNICATING' and TYPE=1 and b.User_id= ? "+
			" and a.DOMAIN_NAME!='ECOM' and a.TRIP_STATUS is not null and a.TRIP_STATUS!='NEW' "+
			" and a.STATUS='Open' and c.TYPE_OF_ALERT=1 and  (c.MONITOR_STATUS is null or c.MONITOR_STATUS='N'))r";

public static final String GET_ALL_COUNTS_FOR_NEW_DASHBOARD = " SELECT STATUS AS TRIP_STATUS,ISNULL(COUNTS,0) AS COUNTS FROM ( "+
			" SELECT STATUS,COUNTS FROM (select 'ON TIME'  STATUS union all select 'DELAYED ADDRESSED' STATUS union all select 'DELAYED' STATUS union all select'BEFORE TIME' STATUS) C "+
			" LEFT JOIN (select count(TRIP_STATUS) as COUNTS,a.TRIP_STATUS from dbo.CARGO_SHIPMENT_DETAILS a "+
			" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
			" where SYSTEM_ID=? and CUSTOMER_ID=? and COMMUNICATION_STATUS='COMMUNICATING' and TYPE=1 "+
			" and DOMAIN_NAME!='ECOM' and TRIP_STATUS is not null and TRIP_STATUS!='NEW' and b.User_id=? "+
			" and STATUS='Open' group by a.TRIP_STATUS ) TBL ON C.STATUS=TBL.TRIP_STATUS ) E";

public static final String GET_DETAILS_FOR_NEW_DASHBOARD = "select CustomerName,TRIP_ID,ROUTE_NAME as TRIP_NAME,ASSET_NUMBER,SHIPMENNT_ID ,PLANNED_DISTANCE,TRIP_ID ,DRIVER_NUMBER, c.LOCATION,TRIP_STATUS , ISNULL(ACTUAL_DISTANCE,0) AS ACTUAL_DISTANCE from dbo.CARGO_SHIPMENT_DETAILS a "+
			" inner join AMS.dbo.Vehicle_User b on b.System_id=a.SYSTEM_ID and b.Registration_no=a.ASSET_NUMBER "+
			"  inner join AMS.dbo.gpsdata_history_latest c on c.System_id=a.SYSTEM_ID and c.REGISTRATION_NO=a.ASSET_NUMBER  "+
			" inner join AMS.dbo.tblCustomerMaster d on d.CustomerId = a.CUSTOMER_ID and d.System_id=a.SYSTEM_ID "+
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and COMMUNICATION_STATUS='COMMUNICATING' and a.TYPE=1 and b.User_id=? "+ 
			" and DOMAIN_NAME!='ECOM' and TRIP_STATUS is not null and TRIP_STATUS!='NEW' and STATUS='Open'";

public static final String GET_TOUCH_POINT_INFO = " select isnull(NAME,'') as NAME,SEQUENCE,HUB_ID,DISTANCE,STATUS,DATEADD(mi,330,EXP_ARR_DATETIME) as	EXP_ARRIVAL,datediff(mi,PLANNED_ARR_DATETIME,ISNULL(ACT_ARR_DATETIME,GETUTCDATE())) AS DELAY,ISNULL((select TOP 1 SEQUENCE from CARGO_TRIP_DETAILS where TRIP_ID=? AND ACT_ARR_DATETIME IS NOT NULL ORDER BY ACT_ARR_DATETIME DESC ),0) AS CURR_POINT from  CARGO_TRIP_DETAILS a "+
            " inner join LOCATION_ZONE_A b on a.HUB_ID = b.HUBID where TRIP_ID=? ORDER BY SEQUENCE" ;

public static final String GET_TOUCH_POINT_INFO_NON_MM = " select isnull(LOCATION_ID,'') as NAME ,a.SEQUENCE,HUB_ID,ISNULL(DISTANCE,0) AS DISTANCE ,STATUS,DATEADD(mi,330,EXP_ARR_DATETIME) as EXP_ARRIVAL,datediff(mi,PLANNED_ARR_DATETIME,ISNULL(ACT_ARR_DATETIME,GETUTCDATE())) AS DELAY,ISNULL((select TOP 1 SEQUENCE from CARGO_TRIP_DETAILS where TRIP_ID=? AND ACT_ARR_DATETIME IS NOT NULL ORDER BY SEQUENCE DESC ),0) AS CURR_POINT from  CARGO_TRIP_DETAILS a "+
	                                                " left outer join CARGO_STOP_POINT_DETAILS b ON a.TRIP_ID= b.TRIP_ID AND (b.SEQUENCE=(a.SEQUENCE+1) or (a.SEQUENCE=100 and b.TYPE='D' )) "+
	                                                " WHERE a.TRIP_ID=? ORDER BY SEQUENCE ";

public static final String INSERT_TO_EMAIL_QUEUE = "insert into AMS.dbo.EmailQueue(Subject,Body,EmailList,AlertType,SystemId,RegistrationNo) values (?,?,?,?,?,?)";

}
