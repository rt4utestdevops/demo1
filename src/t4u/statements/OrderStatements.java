package t4u.statements;

public class OrderStatements {
	//public final static String GET_ROUTE_DETAILS="select LATITUDE,LONGITUDE from ORDER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=?";

	//public final static String GET_STOCK_AND_ORDER="select DESTINATION_NUMBER,CUSTOMER_NAME,ORDER_NO,isnull(DELIVERY_DATE,'') as DELIVERY_DATE,TOTAL_WEIGHT,PRIORITY,WEIGHT_UNIT from ORDER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=?";

	//public final static String GET_FREE_VEHICLES="select top 18 REGISTRATION_NO,isnull(LoadingCapacity,0) as LoadingCapacity from gpsdata_history_latest gps inner join tblVehicleMaster on REGISTRATION_NO=VehicleNo where gps.System_id=? and LoadingCapacity>4000";

	public final static String GET_ROUTE_DETAILS="select  DESTINATION_NUMBER,LATITUDE,LONGITUDE,PRIORITY,DELIVERY_TIME,ID from ORDER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=? ORDER BY ID   ";

	public final static String GET_STOCK_AND_ORDER="select DESTINATION_NUMBER,CUSTOMER_NAME,ORDER_NO,TOTAL_WEIGHT,WEIGHT_UNIT from ORDER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=?";

	public final static String GET_FREE_VEHICLES="select  ISNULL(a.LoadingCapacity,2000) as LoadingCapacity ,a.VehicleNo as VehicleNo from tblVehicleMaster a  "+
	"inner join  AMS.dbo.gpsdata_history_latest b on  a.VehicleNo=b.REGISTRATION_NO  "+
	"where a.System_id=? and b.CLIENTID=?  ";

}