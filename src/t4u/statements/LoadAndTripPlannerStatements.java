package t4u.statements;

public class LoadAndTripPlannerStatements {
	
	public static final String INSERT_EXCEL_DATA="insert into AMS.dbo.ORDER_DETAILS(PRIORITY,CUSTOMER_NO,CUSTOMER_NAME,LATITUDE,LONGITUDE,ORDER_NO,ORDER_DATE,ORDER_VALUE,DELIVERY_NO,DELIVERY_DATE,DELIVERY_TIME,TOTAL_WEIGHT,WEIGHT_UNIT,TOTAL_VOLUME,VOLUME_UNIT,UNIQUE_ID,DESTINATION_NUMBER,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_GMT,STATUS) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),'uploded');";
	
	public static final String INSERT_OPTIMIZED_VEHICLE_ROUTE="insert into AMS.dbo.OPTIMISED_VEHICLE_ROUTE_DETAILS(VEHICLE_NO,CAPACITY,UNIQUE_ID,INSERTED_BY,ORDER_OF_CHECKPOINTS,LEASE_RECOMMENDED,VEHICLE_TYPE,LOADING_LEVEL,LOADING_EFFICIENCY,VISIT_DISTANCE,VISIT_DURATION,OPTIMIZED_OUTPUT_ORDERS,INSERTED_GMT) values (?,?,?,?,?,?,?,?,?,?,?,?,getutcdate())";
	
	public static final String GET_OPTIMIZED_TRIP_DETAILS = " select a.TRIP_ID as tripId,isnull(a.VEHICLE_NO,'') as vehicleNo,isnull(a.CAPACITY,0) as capacity, " +
	" isnull(a.UNIQUE_ID,'') as UID,isnull(a.ORDER_OF_CHECKPOINTS,'') as seq,isnull(a.STATUS,'') as status, isnull(a.LEASE_RECOMMENDED,'') as LEASE_RECOMMENDED,isnull(a.VEHICLE_TYPE,'') as VEHICLE_TYPE,isnull(OPTIMIZED_OUTPUT_ORDERS,'') as ORDER_DETAILS from AMS.dbo.OPTIMISED_VEHICLE_ROUTE_DETAILS a " +
	" where a.UNIQUE_ID=? order by a.TRIP_ID ";
	
	public static final String GET_ALL_DESTINATIONS = "select isnull(OPTIMIZED_OUTPUT_ORDERS,'') as sequence from dbo.OPTIMISED_VEHICLE_ROUTE_DETAILS where UNIQUE_ID=? and TRIP_ID=?";
	
	public static final String GET_LAT_LONG = "select isnull(LATITUDE,0) as lat,isnull(LONGITUDE,0) as lon,isnull(DESTINATION_NUMBER,'') as dest,isnull(CUSTOMER_NAME,'') as customer,isnull(DESTINATION_ETA,'') as destETA,isnull(MAX_ETA,'') as maxETA" +
	" from dbo.ORDER_DETAILS where UNIQUE_ID=? and DESTINATION_NUMBER=?";

	public static final String INSERT_INTO_TRIP_TRACK_DETAILS = "insert into AMS.dbo.TRACK_TRIP_DETAILS (ASSET_NUMBER,SHIPMENT_ID,TRIP_START_TIME,STATUS,INSERTED_TIME,SYSTEM_ID," +
	" CUSTOMER_ID,ROUTE_ID,TRIP_STATUS,INSERTED_BY) values (?,?,?,?,getutcdate(),?,?,?,?,?)";

	public static final String INSERT_INTO_DES_TRIP_DETAILS = "insert into AMS.dbo.DES_TRIP_DETAILS (TRIP_ID,PLANNED_ARR_DATETIME,SEQUENCE,STATUS,ROUTE_ID,LATITUDE,LONGITUDE,NAME)" +
	" values (?,?,?,?,?,?,?,?)";

	public static final String GET_ORDER_DETAILS = "select count(ID) as orders,sum(TOTAL_WEIGHT/1000) as filled,isnull(sum(TOTAL_WEIGHT),0) as weight from AMS.dbo.ORDER_DETAILS where UNIQUE_ID=?";

	public static final String GET_ORDER_DETAILS_FOR_TRIP = "select distinct isnull(CUSTOMER_NAME,'') as name,isnull(dateadd(mi,?,DELIVERY_DATE),'') as deliveryDate," +
	" isnull(LATITUDE,'') as lat,isnull(LONGITUDE,'') as lon from AMS.dbo.ORDER_DETAILS where UNIQUE_ID=? and DESTINATION_NUMBER=?";

	public static final String UPDATE_TRIP_TABLE = "update AMS.dbo.OPTIMISED_VEHICLE_ROUTE_DETAILS set STATUS=? where UNIQUE_ID=? and TRIP_ID=?";

	public static final String GET_ALL_ORDER_DETAILS = "select isnull(CUSTOMER_NAME,'') as customer,isnull(ORDER_NO,0) as orderNo,isnull(dateadd(mi,?,DELIVERY_DATE),'') as date," +
	" isnull(TOTAL_WEIGHT,'0') as weight,isnull(ORDER_VALUE,0) as value,isnull(DELIVERY_TIME,'') as dTime from AMS.dbo.ORDER_DETAILS where UNIQUE_ID=? and ORDER_NO=?  ";
	
	public static final String GET_ORDER_DETAILS_INSERTED=" select PRIORITY,CUSTOMER_NO,CUSTOMER_NAME, DELIVERY_DATE, "+
	"isnull(DELIVERY_TIME,'') as DELIVERY_TIME,ORDER_NO, ORDER_DATE,ORDER_VALUE,TOTAL_WEIGHT "+
	"from AMS.dbo.ORDER_DETAILS "+
	"where UNIQUE_ID=? and SYSTEM_ID=? and CUSTOMER_ID=? "+
	"order by DELIVERY_TIME  desc ";
	
	public static final String UPDATE_ETA_FOR_ORDER_DETAILS_TABLE="update ORDER_DETAILS set DESTINATION_ETA=?,MAX_ETA=?,OUTPUT_ORDERS=? where UNIQUE_ID=? and DESTINATION_NUMBER=?";
	
	public static final String GET_ALL_DESTINATIONS_FOR_MAP = "select isnull(ORDER_OF_CHECKPOINTS,'') as sequence from dbo.OPTIMISED_VEHICLE_ROUTE_DETAILS where UNIQUE_ID=? and TRIP_ID=?";

}
