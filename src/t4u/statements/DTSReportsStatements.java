package t4u.statements;

public class DTSReportsStatements {
	
//	public static final String GET_ALL_ORDER_NO=" select ORDER_NO from AMS.dbo.TRIP_ORDER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID = ? ";
	public static final String GET_ALL_ORDER_NO="select ORDER_NO from AMS.dbo.TRIP_ORDER_DETAILS where TRIP_ID IN(SELECT TRIP_ID FROM [AMS].[dbo].[TRACK_TRIP_DETAILS] WHERE INSERTED_TIME BETWEEN ? AND ?  AND SYSTEM_ID=? AND CUSTOMER_ID=?) ";
	
	public static final String GET_DRIVER_NAMES=" select Driver_id,isnull(dm.Fullname,'') as DRIVER_NAME "+
							"from AMS.dbo.Driver_Master dm where System_id = ? and Client_id=? order by DRIVER_NAME desc";
	
	public static final String GET_DELIVERY_REPORT_DATA = " select tod.DES_TRIP_ID, isnull(tod.ORDER_NO,'') as ORDER_NO,isnull(tod.DELIVERY_TICKET_NO,'') as DELIVERY_TICKET,isnull(tod.DELIVERY_NOTE_NO,'') as DELIVERY_NOTE, " +
		" isnull(dateadd(mi,?,tod.DELIVERED_TIME),'') as DELIVERED_TIME,isnull(tod.REMARKS,'') as REMARKS, isnull(tod.TRIP_CUSTOMER_NAME,'') as TRIP_CUSTOMER_NAME," +
		" isnull(dateadd(mi,?,ttd.ACTUAL_TRIP_START_TIME),'') as DISPATCH_TIME,isnull(ttds.LOADING_PARTNER,'') as LOADING_PARTNER, " +
		" isnull(DRIVER_NAME,'') as DRIVER_NAME, isnull(DRIVER_NUMBER,'')as DRIVER_NUMBER ,isnull(dateadd(mi,?,tod.ACKNOWLEDGE_ORDER),'') as ACK_DATE, " +
		" tod.ORDER_TYPE, tod.LOADING_PARTNER as CUST_COLL_LOADING_PARTNER, ISNULL(tod.COLLECTED_BY,'') AS COLLECTED_BY , ISNULL(tod.MOBILE_NUMBER,'') AS MOBILE_NUMBER , ISNULL(tod.VEHICLE_NUMBER,'') AS VEHICLE_NUMBER " +
		" from AMS.dbo.TRIP_ORDER_DETAILS tod " +
		" left outer join AMS.dbo.DES_TRIP_DETAILS des on des.ID=tod.DES_TRIP_ID " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS ttd on ttd.TRIP_ID = des.TRIP_ID " +
		" left outer join AMS.dbo.TRACK_TRIP_DETAILS_SUB ttds on ttd.TRIP_ID=ttds.TRIP_ID " +
		" where tod.SYSTEM_ID = ? and tod.CUSTOMER_ID = ? and ttd.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) # $ %" ;
	
	public static final String GET_DRIVER_EFFICIENCY_REPORT = "select ttd.DRIVER_ID,ttd.DRIVER_NAME, COUNT (ASSET_NUMBER) NO_OF_TRIPS , sum(DATEDIFF(mi,ACTUAL_TRIP_START_TIME,ACTUAL_TRIP_END_TIME)) as DURATION "+
		" from AMS.dbo.TRACK_TRIP_DETAILS ttd where SYSTEM_ID = ? and CUSTOMER_ID=? and ttd.STATUS='CLOSED' "+
		" and ttd.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)  # group by ttd.DRIVER_ID,ttd.DRIVER_NAME";
}