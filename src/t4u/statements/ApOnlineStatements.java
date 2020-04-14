package t4u.statements;

public class ApOnlineStatements {

	public static final String GET_NOOF_EWAYBILLS_VS_VISITS = " SELECT ISNULL(UNIQUE_ID,'') AS UNIQUE_ID, ISNULL(VEHICLE_NO,'') AS VEHICLE_NO,isnull(REACH_NAME,'') AS REACH_NAME,DATEADD(mi,330,REACH_ENTRY_DATE) "+
															  " AS REACHENTRYDATE,DATEADD(mi,330,REACH_EXIT_DATE) AS REACHEXITDATE,ISNULL(WAY_BILL_NO,' ') AS WAY_BILL_NO,ISNULL(REMARKS1,'') AS REMARKS1,ISNULL(REMARKS2,'') AS REMARKS2  "+
															  " FROM AMS.dbo.NO_OF_EWAYBILLS_AND_VISITS WHERE REACH_ENTRY_DATE BETWEEN ? AND ? and CUSTOMER_ID =? ";
	
	public static final String GET_VEHICLE_WITH_ORDER_COMPLETION = " SELECT ISNULL(ORDER_STATUS,'') AS ORDER_STATUS,isnull(FROM_PLACE,'') AS FROM_PLACE,ISNULL(a.VEHICLE_NO,'') AS VEHICLE_NO,isnull(a.WAY_BILL_NO,'') AS WAY_BILL_NO,ISNULL(a.VALID_FROM_DATE,'') "+
																   " AS VALID_FROM_DATE,ISNULL(a.VALID_TO_DATE,'') AS VALID_TO_DATE,ISNULL(a.TO_PLACE,'') AS TO_PLACE,ISNULL(a.ETA,'') "+
																   " AS ETA,ISNULL(a.DESTINATION_REACH_TIME,'') AS DESTINATION_REACH_TIME,ISNULL(b.LOCATION,'') AS LOCATION, "+
																   " ISNULL(DESTINATION_LATITUDE,0.0) AS DESTINATION_LATITUDE, ISNULL(DESTINATION_LONGITUDE,0.0) AS DESTINATION_LONGITUDE FROM AMS.dbo.SAND_ORDER_COMPLETION a  "+
																   " LEFT OUTER JOIN AMS.dbo.gpsdata_history_latest b ON a.VEHICLE_NO=b.REGISTRATION_NO "+
																   " WHERE b.LOCATION<>'No GPS Device Connected' AND LOCATION IS NOT NULL "+
																   " AND WAY_BILL_NO<>'' AND  a.VALID_FROM_DATE BETWEEN ? AND ? and CUSTOMER_ID=? ";
	
	public static final String UPDATE_REMARKS1="update dbo.NO_OF_EWAYBILLS_AND_VISITS set REMARKS1=?, REMARKS1_UPDATED_BY=?, REMARKS1_UPDATED_ON=getutcdate() where UNIQUE_ID=? AND SYSTEM_ID=? ";
	
	public static final String UPDATE_REMARKS2="update dbo.NO_OF_EWAYBILLS_AND_VISITS set REMARKS2=?, REMARKS2_UPDATED_BY=?, REMARKS2_UPDATED_ON=getutcdate() where UNIQUE_ID=? AND SYSTEM_ID=? ";
	
	
	public static final String GET_ROUTE_DEVIATION = " SELECT b.Driver_Name,a.FROM_PLACE,a.VEHICLE_NO,a.WAY_BILL_NO,b.CUSTOMER_NAME,a.TO_PLACE,ISNULL(a.VALID_FROM_DATE,'') AS VALID_FROM_DATE,ISNULL(TO_PLACE,'') "+
													 " AS Destination,a.DESTINATION_LATITUDE,a.DESTINATION_LONGITUDE FROM AMS.dbo.SAND_ORDER_COMPLETION a "+
													 " INNER JOIN AMS.dbo.Sand_Mining_Trip_Sheet b ON b.Trip_Sheet_No=a.WAY_BILL_NO "+
													 " WHERE a.ORDER_STATUS='Not Completed' AND a.VALID_FROM_DATE BETWEEN ? AND ? and CUSTOMER_ID=? UNION" +
													 " SELECT b.Driver_Name,a.FROM_PLACE,a.VEHICLE_NO,a.WAY_BILL_NO,b.CUSTOMER_NAME,a.TO_PLACE,ISNULL(a.VALID_FROM_DATE,'') AS VALID_FROM_DATE,ISNULL(TO_PLACE,'') "+
													 " AS Destination,a.DESTINATION_LATITUDE,a.DESTINATION_LONGITUDE FROM AMS.dbo.SAND_ORDER_COMPLETION a "+
													 " INNER JOIN AMS.dbo.Sand_Mining_Trip_Sheet_History b ON b.Trip_Sheet_No=a.WAY_BILL_NO "+
													 " WHERE a.ORDER_STATUS='Not Completed' AND a.VALID_FROM_DATE BETWEEN ? AND ? and CUSTOMER_ID=? ";
	
	public static final String GET_EXCESS_HALTING = " SELECT ISNULL(VEHICLE_NO,'') AS VEHICLE_NO,ISNULL(WAY_BILL_NO,'') AS WAY_BILL_NO,ISNULL(HALT_ADDRESS_1,'') AS HALT_ADDRESS_1, "+
													" ISNULL(DURATION_1,'') AS DURATION_1,ISNULL(HALT_ADDRESS_2,'') AS HALT_ADDRESS_2,ISNULL(DURATION_2,'') AS DURATION_2, "+
													" ISNULL(HALT_ADDRESS_3,'') AS HALT_ADDRESS_3,ISNULL(DURATION_3,'') AS DURATION_3 FROM AMS.dbo.EXCESS_HALTING_VEHICLE where SYSTEM_ID=229 "+
													" AND EWAYBILL_DATE BETWEEN ? AND ? and CUSTOMER_ID=? ";
	
	public static final String GET_SAME_VEHICLE_SAME_DESTINATION = " SELECT ISNULL(Vehicle_No,'') AS Vehicle_No,ISNULL(Trip_Sheet_No,'') AS Trip_Sheet_No,ISNULL(To_Palce,'') AS To_Palce, "+
																   " ISNULL(To_Date,'') AS To_Date,ISNULL(CUSTOMER_NAME,'') AS CUSTOMER_NAME FROM AMS.dbo.Sand_Mining_Trip_Sheet "+
																   " WHERE Vehicle_No=? AND To_Palce=? AND System_Id=? AND Client_Id=? AND Date_TS BETWEEN ? AND ? AND Remarks!='NOT AVAILABLE' union "+
																   " SELECT ISNULL(Vehicle_No,'') AS Vehicle_No,ISNULL(Trip_Sheet_No,'') AS Trip_Sheet_No,ISNULL(To_Palce,'') AS To_Palce, "+
																   " ISNULL(To_Date,'') AS To_Date,ISNULL(CUSTOMER_NAME,'') AS CUSTOMER_NAME FROM AMS.dbo.Sand_Mining_Trip_Sheet_History "+
																   " WHERE Vehicle_No=? AND To_Palce=? AND System_Id=? AND Client_Id=? AND Date_TS BETWEEN ? AND ? AND Remarks!='NOT AVAILABLE' ";	                                              
	
	public static final String GET_MULTIPLE_VEHICLE_SAME_DESTINATION = " SELECT ISNULL(Vehicle_No,'') AS Vehicle_No,ISNULL(Trip_Sheet_No,'') AS Trip_Sheet_No,ISNULL(To_Palce,'') AS To_Palce, "+
																	   " ISNULL(To_Date,'') AS To_Date,ISNULL(CUSTOMER_NAME,'') AS CUSTOMER_NAME,COUNT(Vehicle_No) AS TripCount FROM AMS.dbo.Sand_Mining_Trip_Sheet "+ 
																	   " WHERE To_Palce=? AND System_Id=? AND Client_Id=? AND Remarks!='NOT AVAILABLE' AND Date_TS BETWEEN ? AND ? GROUP BY Vehicle_No,Trip_Sheet_No,To_Palce,To_Date,CUSTOMER_NAME union "+
																	   " SELECT ISNULL(Vehicle_No,'') AS Vehicle_No,ISNULL(Trip_Sheet_No,'') AS Trip_Sheet_No,ISNULL(To_Palce,'') AS To_Palce, "+
																	   " ISNULL(To_Date,'') AS To_Date,ISNULL(CUSTOMER_NAME,'') AS CUSTOMER_NAME,COUNT(Vehicle_No) AS TripCount FROM AMS.dbo.Sand_Mining_Trip_Sheet_History "+ 
																	   " WHERE To_Palce=? AND System_Id=? AND Client_Id=? AND Remarks!='NOT AVAILABLE' AND Date_TS BETWEEN ? AND ? GROUP BY Vehicle_No,Trip_Sheet_No,To_Palce,To_Date,CUSTOMER_NAME ";
	
	public static final String GET_IDLE_TIME_REPORT = " SELECT isnull(a.REACH_NAME,'') AS REACH_NAME,ISNULL(a.WAY_BILL_NO,'') AS WAY_BILL_NO,ISNULL(b.Date_TS,'') AS Date_TS,ISNULL(a.VEHICLE_NO,'') AS VEHICLE_NO, "+
													  " ISNULL(a.REACH_ENTRY_DATE,'') as REACH_ENTRY_DATE,ISNULL(a.REACH_EXIT_DATE,'') as REACH_EXIT_DATE, "+
													  " ISNULL(a.DETENTION,'') as DETENTION FROM AMS.dbo.NO_OF_EWAYBILLS_AND_VISITS a "+
													  " LEFT OUTER JOIN AMS.dbo.Sand_Mining_Trip_Sheet b ON a.WAY_BILL_NO=b.Trip_Sheet_No "+
													  " WHERE SYSTEM_ID=? and CUSTOMER_ID=? and a.DETENTION IS NOT NULL AND a.REACH_ENTRY_DATE BETWEEN ? AND ? ";
	
	public static final String GET_TAMPERING_ALERTS = " SELECT DISTINCT(REGISTRATION_NO) AS REGISTRATION_NO,a.HUB_ID,a.LOCATION FROM Alert a WHERE a.SYSTEM_ID=?  "+
													  " AND a.CLIENTID=? AND a.TYPE_OF_ALERT= 7 AND a.GMT BETWEEN DATEADD(mi,-330,?) AND DATEADD(mi,-330,?) AND a.HUB_ID=0 "+
													  " UNION ALL "+
													  " SELECT DISTINCT(REGISTRATION_NO) AS REGISTRATION_NO,a.HUB_ID,a.LOCATION FROM Alert_History a  WHERE a.SYSTEM_ID=? "+
													  " AND a.CLIENTID=? AND a.TYPE_OF_ALERT= 7  AND a.GMT BETWEEN DATEADD(mi,-330,?) AND DATEADD(mi,-330,?) AND a.HUB_ID=0 ";;
	
	public static final String GET_TAMPERING_REPORT = " SELECT ISNULL(LATITUDE,'')as LATITUDE,ISNULL(LONGITUDE,'')as LONGITUDE,ISNULL(Trip_Sheet_No,'') AS TRIP_SHEET_NO,isnull(From_Place,'') as FROM_PLACE,isnull(CUSTOMER_NAME,'') as CUSTOMER_NAME,Date_TS,To_Palce FROM AMS.dbo.Sand_Mining_Trip_Sheet WHERE Permit_No=? AND System_Id=? AND Client_Id=? " +
    												  " AND Date_TS BETWEEN DATEADD(mi,-330,?) AND DATEADD(mi,-330,?) " +
													  " UNION " +
													  " SELECT ISNULL(LATITUDE,'')as LATITUDE,ISNULL(LONGITUDE,'')as LONGITUDE,ISNULL(Trip_Sheet_No,'') AS TRIP_SHEET_NO,isnull(From_Place,'') as FROM_PLACE,isnull(CUSTOMER_NAME,'') as CUSTOMER_NAME,Date_TS,To_Palce FROM AMS.dbo.Sand_Mining_Trip_Sheet_History WHERE Permit_No=? AND System_Id=? AND Client_Id=? " +
													  " AND Date_TS BETWEEN DATEADD(mi,-330,?) AND DATEADD(mi,-330,?) ";
	
	public static final String GET_CROSS_BORDER_REPORT = " SELECT VEHICLE_NO,ISNULL(WAY_BILL_NO,'') AS WAY_BILL_NO, ISNULL(EWAYBILL_DATE,'') AS EWAYBILL_DATE,ISNULL(EXPECTED_TRAVEL_TIME,'') "+
														 " AS EXPECTED_TRAVEL_TIME,ISNULL(TIME_OF_BORDER_CROSSED,'') AS TIME_OF_BORDER_CROSSED,ISNULL(DESTINATION_REACHED,'') AS DESTINATION_REACHED "+
														 " FROM dbo.CROSEED_BORDER_DATA WHERE SYSTEM_ID=? and CUSTOMER_ID=? and TIME_OF_BORDER_CROSSED BETWEEN ? AND ? AND WAY_BILL_NO<>'' ";

	public static final String MDP_DETAILS= " SELECT ISNULL(b.STATUS,'') as STATUS, ISNULL(b.LATITUDE,'')as LATITUDE,ISNULL(b.LONGITUDE,'')as LONGITUDE,isnull(b.From_Place,'') as From_Place,isnull(DATEADD (mi,330,b.Date_TS),'') as Date_TS,isnull(b.To_Palce,'') as To_Palce,isnull (b.CUSTOMER_NAME,'') AS CUSTOMER_NAME,isnull(b.Driver_Name,'') as Driver_Name "+ 
											" from Sand_Mining_Trip_Sheet b where b.Vehicle_No=? and b.Trip_Sheet_No=? union "+
											" SELECT ISNULL(b.STATUS,'') as STATUS, ISNULL(b.LATITUDE,'')as LATITUDE,ISNULL(b.LONGITUDE,'')as LONGITUDE, isnull(b.From_Place,'') as From_Place,isnull(DATEADD (mi,330,b.Date_TS),'') as Date_TS,isnull(b.To_Palce,'') as To_Palce,isnull (b.CUSTOMER_NAME,'') AS CUSTOMER_NAME,isnull(b.Driver_Name,'') as Driver_Name "+ 
											" from Sand_Mining_Trip_Sheet_History b where b.Vehicle_No=? and b.Trip_Sheet_No=? ";
	
	
	public static final String TAMPERING_ALERT = "select isnull(m.STATUS,'') as STATUS,n.TIME_OF_BORDER_CROSSED,isnull(m.Date_TS,'') as Date_TS,n.LOCATION,n.REGISTRATION_NO,isnull(m.Trip_Sheet_No,'') as Trip_Sheet_No,isnull(m.LATITUDE,'') as LATITUDE,isnull(m.LONGITUDE,'') as LONGITUDE ,isnull(m.From_Place,'') as From_Place ,isnull(m.To_Palce,'') as To_Palce,isnull(m.CUSTOMER_NAME,'') as CUSTOMER_NAME,isnull(m.Driver_Name,'') as Driver_Name from "+
	"(select e.REGISTRATION_NO,e.LOCATION,e.TIME_OF_BORDER_CROSSED from (select a.SLNO as [SL NO],a.REGISTRATION_NO as [REGISTRATION_NO],dateadd(mi,330,a.GMT) as [TIME_OF_BORDER_CROSSED],isnull(a.LOCATION,'') as [LOCATION] "+
	"from Alert a inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER "+
	"left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID "+
	"left outer join tblVehicleMaster vm on a.REGISTRATION_NO = vm.VehicleNo "+
	"inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no "+
	"where a.GMT BETWEEN dateadd(mi,-330,?) AND dateadd(mi,-330,?) and b.SYSTEM_ID=? and b.CLIENT_ID=? and a.TYPE_OF_ALERT=? and a.ISREDALERT<>'Y' and v.User_id=? "+
	"UNION ALL "+
	"select a.SLNO as [SL NO],a.REGISTRATION_NO as [VEHICLE_NO],dateadd(mi,330,a.GMT) as [TIME_OF_BORDER_CROSSED],ISNULL(a.LOCATION,'') AS LOCATION "+
	"from Alert_History a inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER "+
	"left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID "+
	"left outer join tblVehicleMaster vm on a.REGISTRATION_NO = vm.VehicleNo "+
	"inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no "+
	"where a.GMT BETWEEN dateadd(mi,-330,?) AND dateadd(mi,-330,?) and b.SYSTEM_ID=? and b.CLIENT_ID=? and a.TYPE_OF_ALERT=? and a.ISREDALERT<>'Y' and v.User_id=? "+
	") e ) n Left outer join "+
	"(( select f.Trip_Sheet_No,f.Vehicle_No,f.LATITUDE,f.LONGITUDE,f.From_Place,f.To_Palce,f.CUSTOMER_NAME,f.Driver_Name,f.Date_TS,f.STATUS from "+
	"( SELECT b.Vehicle_No,Trip_Sheet_No,ISNULL(b.STATUS,'') as STATUS, ISNULL(b.LATITUDE,'')as LATITUDE,ISNULL(b.LONGITUDE,'')as LONGITUDE,isnull(b.From_Place,'') as From_Place,isnull(DATEADD (mi,330,b.Date_TS),'') as Date_TS,isnull(b.To_Palce,'') as To_Palce,isnull (b.CUSTOMER_NAME,'') AS CUSTOMER_NAME,isnull(b.Driver_Name,'') as Driver_Name "+
	"from Sand_Mining_Trip_Sheet b where Date_TS between dateadd(mi,-330,?) AND dateadd(mi,-330,?) union "+
	"SELECT b.Vehicle_No,Trip_Sheet_No,ISNULL(b.STATUS,'') as STATUS, ISNULL(b.LATITUDE,'')as LATITUDE,ISNULL(b.LONGITUDE,'')as LONGITUDE, isnull(b.From_Place,'') as From_Place,isnull(DATEADD (mi,330,b.Date_TS),'') as Date_TS,isnull(b.To_Palce,'') as To_Palce,isnull (b.CUSTOMER_NAME,'') AS CUSTOMER_NAME,isnull(b.Driver_Name,'') as Driver_Name "+
	"from Sand_Mining_Trip_Sheet_History b where Date_TS between dateadd(mi,-330,?) AND dateadd(mi,-330,?) ) f ) )m  "+
	"on m.Vehicle_No =n.REGISTRATION_NO  ";
}
