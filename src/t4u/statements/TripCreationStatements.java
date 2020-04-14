package t4u.statements;

public class TripCreationStatements {

	public static final String GET_VEHILCE_NUMBER_FOR_TRIP_DETAILS=" select vc.REGISTRATION_NUMBER,a.GROUP_NAME,(select top 1 OPENING_ODOMETER from AMS.dbo.CVS_TRIP_DETAILS where SYSTEM_ID=vc.SYSTEM_ID and CUSTOMER_ID=vc.CLIENT_ID and ASSET_NUMBER=vc.REGISTRATION_NUMBER order by TRIP_START_TIME desc) as OPENING_ODOMETER from dbo.VEHICLE_CLIENT vc " +
	"left outer join ADMINISTRATOR.dbo.ASSET_GROUP a on vc.SYSTEM_ID=a.SYSTEM_ID and vc.CLIENT_ID=a.CUSTOMER_ID and vc.GROUP_ID=a.GROUP_ID " +
	"left outer join dbo.Vehicle_User vu on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER=vu.Registration_no " +
	"left outer join dbo.tblVehicleMaster vm on vc.SYSTEM_ID=vm.System_id and vc.REGISTRATION_NUMBER=vm.VehicleNo " +
	"left outer join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on vc.SYSTEM_ID=b.SYSTEM_ID and b.GROUP_ID=a.GROUP_ID and vu.User_id=b.USER_ID " +
	"where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? order by vc.REGISTRATION_NUMBER ";


	public static final String GET_VEHILCE_NUMBER_FOR_TRIP_DETAILS_WITH_DATE="select vc.REGISTRATION_NUMBER,a.GROUP_NAME,(select top 1 OPENING_ODOMETER from AMS.dbo.CVS_TRIP_DETAILS where SYSTEM_ID=vc.SYSTEM_ID and CUSTOMER_ID=vc.CLIENT_ID and ASSET_NUMBER=vc.REGISTRATION_NUMBER order by TRIP_START_TIME desc) as OPENING_ODOMETER from dbo.VEHICLE_CLIENT vc " +
	"left outer join ADMINISTRATOR.dbo.ASSET_GROUP a on vc.SYSTEM_ID=a.SYSTEM_ID and vc.CLIENT_ID=a.CUSTOMER_ID and vc.GROUP_ID=a.GROUP_ID  " +
	"left outer join dbo.Vehicle_User vu on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER=vu.Registration_no  " +
	"left outer join dbo.tblVehicleMaster vm on vc.SYSTEM_ID=vm.System_id and vc.REGISTRATION_NUMBER=vm.VehicleNo  " +
	"left outer join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on vc.SYSTEM_ID=b.SYSTEM_ID and b.GROUP_ID=a.GROUP_ID and vu.User_id=b.USER_ID  " +
	"where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? and REGISTRATION_NUMBER not in " +
	"(select ASSET_NUMBER from CVS_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_START_TIME =?) order by vc.REGISTRATION_NUMBER ";

	public static final String GET_VEHILCE_MARKET_NUMBER_FOR_TRIP_DETAILS="select isnull(ASSET_NUMBER,'')as ASSET_NUMBER,isnull(OPENING_ODOMETER,0)as OPENING_ODOMETER from AMS.dbo.CVS_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Open' order by TRIP_START_TIME desc";
	
	public static final String GET_TRIP_STATUS_DETAILS="SELECT VALUE FROM AMS.dbo.LOOKUP_DETAILS WHERE TYPE=? ";

	public static final String GET_REASON_OFF_ROUTE_ROAD_DETAILS="SELECT VALUE FROM AMS.dbo.LOOKUP_DETAILS WHERE TYPE=? ";
	
	public static final String GET_ASSET_NUMBER_TIME_VALIDATE="select isnull(ASSET_NUMBER,'')as ASSET_NUMBER,TRIP_START_TIME from AMS.dbo.CVS_TRIP_DETAILS where ASSET_NUMBER=? and TRIP_START_TIME=? ";
	
	public static final String GET_MARKET_ASSET_NUMBER_EXISTS="select isnull(ASSET_NUMBER,'')as ASSET_NUMBER,TRIP_START_TIME from AMS.dbo.CVS_TRIP_DETAILS where ASSET_NUMBER=? and TRIP_START_TIME=? ";

	public static final String GET_TIME_VALIDATE="select ID,isnull(ASSET_NUMBER,'')as ASSET_NUMBER,dateadd(mi,-?,TRIP_START_TIME)as TRIP_START_TIME,isnull(OPENING_ODOMETER,0)as OPENING_ODOMETER from AMS.dbo.CVS_TRIP_DETAILS where ASSET_NUMBER=? and SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Open' ";

	public static final String GET_MARKET_TIME_VALIDATE="select ID,isnull(ASSET_NUMBER,'')as ASSET_NUMBER,dateadd(mi,-?,TRIP_START_TIME)as TRIP_START_TIME,isnull(OPENING_ODOMETER,0)as OPENING_ODOMETER from AMS.dbo.CVS_TRIP_DETAILS where ASSET_NUMBER=? and SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Open' ";
	
	public static final String SAVE_TRIP_INFORMATION="insert into CVS_TRIP_DETAILS(TRIP_START_TIME,STATE,LOCATION,ASSET_NUMBER,TRIP_STATUS,OPENING_ODOMETER,REASONS_OFF_ROUTE,HIRED_ASSET_NUMBER,HIRED_AMOUNT,HIRED_DISTANCE,STATUS,DELETED,SYSTEM_ID,CUSTOMER_ID) " +
	"  values(?,?,?,?,?,?,?,?,?,?,'Open','N',?,?)";
	
	public static final String SAVE_MARKET_TRIP_INFORMATION="insert into CVS_TRIP_DETAILS(TRIP_START_TIME,STATE,LOCATION,ASSET_NUMBER,HIRED_AMOUNT,HIRED_DISTANCE,STATUS,DELETED,SYSTEM_ID,CUSTOMER_ID) " +
	"  values(?,?,?,?,?,?,'Open','N',?,?)";

	public static final String MODIFY_TRIP_INFORMATION=" update AMS.dbo.CVS_TRIP_DETAILS set STATE=?,LOCATION=?,TRIP_STATUS=?,REASONS_OFF_ROUTE=?," +
	"HIRED_ASSET_NUMBER=?,HIRED_AMOUNT=?,HIRED_DISTANCE=? " +
	"where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? and STATUS='Open' and DELETED='N'";

	public static final String MODIFY_MARKET_TRIP_INFORMATION=" update AMS.dbo.CVS_TRIP_DETAILS set STATE=?,LOCATION=?," +
	"ASSET_NUMBER=?,HIRED_AMOUNT=?,HIRED_DISTANCE=? " +
	"where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? and STATUS='Open' and DELETED='N'";

	public static final String GET_TRIP_INFORMATION=" select ctd.ID,ctd.ASSET_NUMBER,vm.OwnerName,dateadd(mi,?,ctd.TRIP_START_TIME) as TRIP_START_TIME,isNull(ctd.TRIP_START_LOC,'NA') as TRIP_START_LOC," 
		+ " isNull(ctd.TRIP_END_LOC,'NA') as  TRIP_END_LOC "
		+ " from CVS_TRIP_DETAILS ctd left outer join dbo.tblVehicleMaster vm on ctd.SYSTEM_ID=vm.System_id " 
		+ " and ctd.ASSET_NUMBER=vm.VehicleNo where ctd.STATUS='Open' and ctd.DELETED='N' and ctd.SYSTEM_ID=? and ctd.CUSTOMER_ID=? order by ctd.ASSET_NUMBER ";

	public static final String CLOSE_TRIP_DETAILS=" update AMS.dbo.CVS_TRIP_DETAILS "
		+ " set STATUS='Closed',TRIP_END_TIME=?,GPS_DISTANCE=?,CLOSING_ODOMETER=? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";
	
	public static final String MARKET_CLOSE_TRIP_DETAILS=" update AMS.dbo.CVS_TRIP_DETAILS "
		+ " set STATUS='Closed',TRIP_END_TIME=?,MANUAL_DISTANCE=?,HIRED_DISTANCE=? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String GET_TRIP_CREATION_REPORT= " select ctd.ID,ctd.TRIP_START_TIME as TRIP_START_TIME,ctd.STATE,ms.STATE_NAME as STATE_NAME,ctd.LOCATION,ctd.ASSET_NUMBER,ctd.TRIP_STATUS,ctd.REASONS_OFF_ROUTE,ctd.OPENING_ODOMETER,(ctd.CLOSING_ODOMETER-ctd.OPENING_ODOMETER)as ODO_KMS,ctd.GPS_DISTANCE," +
	"ctd.HIRED_ASSET_NUMBER,ctd.HIRED_AMOUNT,ctd.HIRED_DISTANCE,ctd.STATUS from dbo.CVS_TRIP_DETAILS ctd " +
	"left outer join ADMINISTRATOR.dbo.STATE_DETAILS ms on ctd.STATE=ms.STATE_CODE  "+
	"where ctd.SYSTEM_ID=? and ctd.CUSTOMER_ID=? and ctd.TRIP_START_TIME between ? and ? " +
	"order by ctd.STATUS DESC,ctd.TRIP_START_TIME desc";	

	public static final String GET_DAY_WISE_NO_SHOW_TRIP_REPORT= "select vc.REGISTRATION_NUMBER,a.GROUP_NAME from dbo.VEHICLE_CLIENT vc " +
	"left outer join ADMINISTRATOR.dbo.ASSET_GROUP a on vc.SYSTEM_ID=a.SYSTEM_ID and vc.CLIENT_ID=a.CUSTOMER_ID and vc.GROUP_ID=a.GROUP_ID  " +
	"left outer join dbo.Vehicle_User vu on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER=vu.Registration_no  " +
	"left outer join dbo.tblVehicleMaster vm on vc.SYSTEM_ID=vm.System_id and vc.REGISTRATION_NUMBER=vm.VehicleNo  " +
	"left outer join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on vc.SYSTEM_ID=b.SYSTEM_ID and b.GROUP_ID=a.GROUP_ID and vu.User_id=b.USER_ID  " +
	"where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? and REGISTRATION_NUMBER not in " +
	"(select ASSET_NUMBER from CVS_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_START_TIME =?) order by vc.REGISTRATION_NUMBER ";

//-------------------------------Business Details report Statements----------------------------------------------//	

	public static final String GET_BUSINESS_TYPE="SELECT VALUE FROM AMS.dbo.LOOKUP_DETAILS WHERE TYPE=? ";
	
	public static final String GET_ROUTE_TYPE="select ID,ROUTE_ID,ROUTE_TYPE,ROUTE_NAME from AMS.dbo.CVS_ROUTE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active' order by ROUTE_ID ";
	
	public static final String GET_BUSINESS_DETAILS_REPORT="select a.ID,a.BUSINESS_ID,a.BUSINESS_TYPE,a.MSP,a.BANK,a.ADDRESS,a.EMAIL_IDS,a.REGION,a.LOCATION,a.HUB_LOCATION,b.ID as uniqueRouteid,b.ROUTE_ID,b.ROUTE_TYPE,b.ROUTE_NAME,a.LATITUDE,a.LONGITUDE, "+
		"isnull(a.STATUS,'Active') as STATUS,a.RADIUS from AMS.dbo.CVS_BUSINESS_DETAILS a "+
		"left outer join AMS.dbo.CVS_ROUTE_DETAILS b on b.SYSTEM_ID=a.SYSTEM_ID and b.CUSTOMER_ID=a.CUSTOMER_ID and b.ID=a.ROUTE_ID "+
		"where a.SYSTEM_ID=? and a.CUSTOMER_ID=? "+
		"order by INSERTED_TIME desc " ;
	public static final String GET_BUSINESS_ID_VALIDATE="select BUSINESS_ID from AMS.dbo.CVS_BUSINESS_DETAILS where BUSINESS_ID=? ";
	
	public static final String SAVE_BUSINESS_INFORMATION="insert into AMS.dbo.CVS_BUSINESS_DETAILS (BUSINESS_ID,BUSINESS_TYPE,MSP,BANK,ADDRESS,REGION,LOCATION,HUB_LOCATION,ROUTE_ID,ROUTE_TYPE,ROUTE_NAME,STATUS,RADIUS,LATITUDE,LONGITUDE,EMAIL_IDS,INSERTED_BY,SYSTEM_ID,CUSTOMER_ID,CVS_CUSTOMER_ID) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	
	public static final String MODIFY_BUSINESS_INFORMATION="update AMS.dbo.CVS_BUSINESS_DETAILS set BUSINESS_ID=?,BUSINESS_TYPE=?,MSP=?,BANK=?,ADDRESS=?,REGION=?,LOCATION=?,HUB_LOCATION=?,ROUTE_ID=?,ROUTE_TYPE=?,ROUTE_NAME=?,STATUS=?,RADIUS=?,LATITUDE=?,LONGITUDE=?,EMAIL_IDS=?,UPDATED_BY=?, UPDATED_DATE_TIME=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String CHECK_BUSINESSID_ALREADY_EXIST_FOR_MODIFY = " select BUSINESS_ID from AMS.dbo.CVS_BUSINESS_DETAILS where BUSINESS_ID=? and ID!=? ";
	
	public static final String GET_OPENED_TRIP_DETAILS = "select TOP 1 * from AMS.dbo.CVS_TRIP_DETAILS where SYSTEM_ID = ? AND ASSET_NUMBER = ? AND CUSTOMER_ID=? AND STATUS = 'Closed' ORDER BY TRIP_START_TIME DESC ";
	
	public static final String DELETE_OPENED_TRIP = "delete from AMS.dbo.CVS_TRIP_DETAILS where SYSTEM_ID = ?   AND CUSTOMER_ID = ? AND ID=? AND STATUS = 'Open'" ;
 	
	public static final String OPEN_AND_UPDATE_PREVIOUS_TRIP = "update AMS.dbo.CVS_TRIP_DETAILS set TRIP_END_TIME = NULL , GPS_DISTANCE = NULL , CLOSING_ODOMETER = NULL ,STATUS = 'Open' where SYSTEM_ID = ? AND ASSET_NUMBER = ? and ID = ? AND CUSTOMER_ID=? ";
      
	public static final String GET_CVS_CUSTOMER= " select CustomerId,CustomerName from LMS.dbo.Customer_Information where ClientId = ? and SystemId = ?  ";

	public static final String GET_CVS_CUSTOMER_DETAILS= " select CustomerName,State,Address from LMS.dbo.Customer_Information where ClientId = ? and SystemId = ? and CustomerId =? ";

}
