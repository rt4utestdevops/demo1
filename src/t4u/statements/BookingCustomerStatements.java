package t4u.statements;

public class BookingCustomerStatements {


public static final String INSERT_CUSTOMER_INFORMATION= "insert into AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER" +
		"(BOOKING_CUSTOMER_ID,BOOKING_CUSTOMER_NAME,EMAIL_ID,PHONE_NO,MOBILE_NO,FAX,TIN,ADDRESS,CITY,USER_ID,PASSWORD,STATE,REGION,STATUS,CUSTOMER_ID,SYSTEM_ID,CREATED_TIME,CREATED_BY)"
	+ "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getUtcDate(),?)";

public static final String UPDATE_CUSTOMER_INFORMATION=  "update AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER set BOOKING_CUSTOMER_ID=?,BOOKING_CUSTOMER_NAME=?,EMAIL_ID=?,PHONE_NO=?,MOBILE_NO=?, "
	+  "FAX=?,TIN=?,ADDRESS=?,CITY=?,USER_ID=?,PASSWORD=?,STATE=?,REGION=?,STATUS=?,UPDATED_BY=?,UPDATED_TIME=getUtcDate() where SYSTEM_ID=? and CUSTOMER_ID=?  and ID=?";


public static final String CHECK_IF_USER_ID_ALREADY_EXISTS = "select USER_ID from AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER where USER_ID=?";

public static final String CHECK_IF_CUSTOMER_NAME_ALREADY_EXISTS = "select BOOKING_CUSTOMER_NAME from AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER where BOOKING_CUSTOMER_NAME=? and CUSTOMER_ID=? and SYSTEM_ID=? ";

public static final String GET_BOOKING_CUSTOMER_DETAILS="select ID, isnull(BOOKING_CUSTOMER_ID,'')as BOOKING_CUSTOMER_ID ,BOOKING_CUSTOMER_NAME,EMAIL_ID," +
		" PHONE_NO, isnull(MOBILE_NO,'') as MOBILE_NO,isnull(FAX,'') as FAX, isnull(TIN,'') as TIN," +
		" ADDRESS,isnull(CITY,'') as CITY,isnull(b.STATE_NAME,'') as STATE_NAME,a.STATE,REGION,STATUS,isnull(a.USER_ID,'')as USER_ID,isnull(a.PASSWORD,'')as PASSWORD from AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER a" +
		" left outer join ADMINISTRATOR.dbo.STATE_DETAILS b on a.STATE=b.STATE_CODE  where SYSTEM_ID=? and CUSTOMER_ID=?";

public static final String GET_CUSTOMER_FOR_LOGGED_CUST=" select a.CUSTOMER_ID,a.NAME,a.STATUS,a.ACTIVATION_STATUS from ADMINISTRATOR.dbo.CUSTOMER_MASTER a "
+ " inner join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC b on b.CUSTOMER_ID=a.CUSTOMER_ID and b.SYSTEM_ID=a.SYSTEM_ID "
+ " where a.SYSTEM_ID=? and a.CUSTOMER_ID=? "
+ " and a.STATUS='Active' and a.ACTIVATION_STATUS='Complete' and PROCESS_ID=34 order by NAME asc ";

public static final String GET_DEALERS = "select distinct a.DealerName,a.DealerId from AMS.dbo.Consignment_Details a " 
							       + " inner join  AMS.dbo.DEALER_TRACKING_HISTORY b  on b.SYSTEM_ID=a.System_Id and b.CUSTOMER_ID=a.Client_Id "
							       + " and b.CONSIGNMENT_NO=a.ConsignmentNo where SYSTEM_ID=? ";

public static final String GET_CONSIGNMENT_TRACKING_DETAILS = "select a.CONSIGNMENT_NO,b.NAME,dateadd(mi,?,a.SEARCH_DATETIME) as SEARCH_DATETIME,c.DealerName from AMS.dbo.DEALER_TRACKING_HISTORY a "
															  + " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
															  + " inner join AMS.dbo.Consignment_Details c on c.ConsignmentNo=a.CONSIGNMENT_NO and c.System_Id=a.SYSTEM_ID and c.Client_Id=a.CUSTOMER_ID "
															  + " where a.SYSTEM_ID = ? and c.DealerId=? and a.SEARCH_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)";

public static final String GET_CONSIGNMENT_TRACKING_DETAILS_FOR_ALL_DEALERS = "select a.CONSIGNMENT_NO,b.NAME,dateadd(mi,?,a.SEARCH_DATETIME) as SEARCH_DATETIME,c.DealerName from AMS.dbo.DEALER_TRACKING_HISTORY a "
	  + " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "
	  + " inner join AMS.dbo.Consignment_Details c on c.ConsignmentNo=a.CONSIGNMENT_NO and c.System_Id=a.SYSTEM_ID and c.Client_Id=a.CUSTOMER_ID "
	  + " where a.SYSTEM_ID = ? and a.SEARCH_DATETIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)";

public static final String INSERT_COSIGNMENT_BOOKING_DETAILS="insert into AMS.dbo.Consignment_Booking_Details(BookingDate,VehicleNumber,Dealers,ConsignmentNumber, " +
														" ScheduledShippingDate,ScheduledDelivery,System_Id,Client_Id,Deleted,Email,SMS,Total_Distance, " +
														"Average_Distance,From_Location,To_Location,Status,To_DealerId,From_DealerId,ConsignmentStatus,BOOKING_CUSTOMER_ID) values  " +
														" (?,?,?,?,?,?,?,?,'N',?,?,?,?,?,?,'Processing',?,?,?,?)";

public static final String INSERT_COSIGNMENT_DETAILS="insert into AMS.dbo.Consignment_Details(ConsignmentNo,VehicleNo,DealerName,BookedDate,System_Id,Client_Id,Deleted,Email,SMS,ScheduledShippingDate,ScheduledDelivery,Status,DealerId,ConsignmentStatus) values (?,?,?,?,?,?,'N',?,?,?,?,'Processing',?,?)";

public static final String CHECK_CUSTOMER_ASSOCIATED_TO_DEALER="select BOOKING_CUSTOMER_ID from Consignment_Dealer_Master where BOOKING_CUSTOMER_ID=? ";
 
public static final String GET_DEALER_NAME="select DealerName,Slno as DealerId from Consignment_Dealer_Master where" +
											" SystemId=? and ClientId=? and BOOKING_CUSTOMER_ID=? and STATUS='Active' and " +
											" (BaseLocation='N' or BaseLocation is null) and DealerName in (#) order by DealerName";

public static final String GET_CONSIGNMENT_NUMBER="select ConsignmentNumber  from AMS.dbo.Consignment_Booking_Details where System_Id=?  and ConsignmentNumber=?";

public static final String GET_FROM_LOACTION="select Address,Slno as DealerId from Consignment_Dealer_Master where SystemId=? and ClientId=? and BaseLocation='Y' and Address=?";

public static final String GET_DEALER_ID="select Slno as DealerId from Consignment_Dealer_Master where SystemId=? and ClientId=? and DealerName in (#)  ";
public static final String GET_TO_LOCATIONS="select Address,Slno from Consignment_Dealer_Master where SystemId=? and ClientId=? and Slno in (#) and Address=?";
public static final String GET_TO_LOCATION_ID="select Address,Slno from Consignment_Dealer_Master where SystemId=? and ClientId=? and DealerName in (#) and Address=?";
public static final String GET_BOOKING_CUSTOMER_DETAILS1="select ID from CONSIGNMENT_BOOKING_CUSTOMER where BOOKING_CUSTOMER_NAME=? and CUSTOMER_ID=? and SYSTEM_ID=?";

public static final String CHECK_LOGIN_DETAILS=" select b.NAME,BOOKING_CUSTOMER_NAME,ID,a.SYSTEM_ID,a.CUSTOMER_ID,a.REGION from AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER a "
+ " inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on b.CUSTOMER_ID=a.CUSTOMER_ID and b.SYSTEM_ID=a.SYSTEM_ID "
+ " where USER_ID=? ";

public static final String CHECK_IF_USER_ID_ALREADY_EXISTS_FOR_LOGIN = "select USER_ID from AMS.dbo.CONSIGNMENT_BOOKING_CUSTOMER where USER_ID=? and PASSWORD=? and SYSTEM_ID=? ";


}
