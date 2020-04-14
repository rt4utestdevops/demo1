package t4u.statements;

public class RakeShiftingStatements {

	
	public static final String  CHECK_LOCATION_ALREADY_EXIST=" select LOCATION from LMS.dbo.RAKE_EXPENSE_MASTER where LOCATION=? AND LOAD_TYPE=? AND SYSTEM_ID=? AND CUSTOMER_ID=?";
	
	public static final String INSERT_RAKE ="insert into LMS.dbo.RAKE_EXPENSE_MASTER(LOCATION,LOAD_TYPE,FUEL_LTRS,FUEL_AMT,INCENTIVE,INSERTED_BY,INSERTED_DATE,SYSTEM_ID,CUSTOMER_ID) VALUES(?,?,?,?,?,?,getutcdate(),?,?)";
	
	public static final String  CHECK_LOCATION_IF_ALREADY_EXIST_FOR_MODIFY ="select LOCATION from LMS.dbo.RAKE_EXPENSE_MASTER where LOCATION=?  AND ID !=?";
	
	public static final String UPDATE_RAKE = "update LMS.dbo.RAKE_EXPENSE_MASTER set FUEL_LTRS=?,FUEL_AMT=?,INCENTIVE=?,UPDATED_BY=?,UPDATED_DATE=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

	public static final String GET_RAKE_MASTER_DETAILS = "select a.ID as ID ,isnull(a.LOCATION,'') as LOCATION,isnull(a.LOAD_TYPE,0) as LOAD_TYPE,isnull(a.FUEL_LTRS,0) as FUEL_LTRS,isnull(a.FUEL_AMT, 0) as FUEL_AMT," +
			" isnull(a.INCENTIVE,0) as INCENTIVE,isnull(b.FIRST_NAME,'') as INSERTED_BY ,dateadd(mi,?,a.INSERTED_DATE) as INSERTED_DATE,isnull(c.FIRST_NAME,'') as UPDATED_BY,isnull(dateadd(mi,?,a.UPDATED_DATE),'') as UPDATED_DATE" +
			" from LMS.dbo.RAKE_EXPENSE_MASTER a " +
			" left outer join ADMINISTRATOR.dbo.USERS b on a.SYSTEM_ID = b.SYSTEM_ID and a.INSERTED_BY=b.USER_ID " +
			" left outer join ADMINISTRATOR.dbo.USERS c on a.SYSTEM_ID = c.SYSTEM_ID and a.UPDATED_BY=c.USER_ID " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? order by a.INSERTED_DATE";
	
	public static final String INSERT_RAKE_SHIFTING_BOOKING="insert into dbo.RAKE_SHIFT_BOOKING(SYSTEM_ID, CUSTOMER_ID, BOOKING_NO, BOOKING_TYPE, BOOKING_DATE, RAKE_NO, RAIL_NO, ARRIVAL_DATE, DEP_DATE,FROM_PLACE, TO_PLACE," +
			" NO_OF_CONTAINER, CREATED_DATE, CREATED_BY,BILLING_CUSTOMER,SHIPPER_NAME,BRANCH_ID) values(?,?,?,?,?,?,?,?,?,?,?,?,getdate(),?,?,?,?) ";
	
	public static final String GET_BOOKING_DETAILS=" select UID, isnull(BOOKING_NO,'') as BOOKING_NO,isnull(BOOKING_TYPE,'') as BOOKING_TYPE,isnull(BOOKING_DATE,'') as BOOKING_DATE, isnull(RAKE_NO,'') as RAKE_NO," +
			" isnull(RAIL_NO,'') as RAIL_NO,isnull(ARRIVAL_DATE,'') as ARRIVAL_DATE,isnull(DEP_DATE,'') as DEPARTURE_DATE,isnull(FROM_PLACE,'') as FROM_PLACE,isnull(TO_PLACE,'') as TO_PLACE," +
			" isnull(NO_OF_CONTAINER,'') as NO_OF_CONTAINER,isnull(BILLING_CUSTOMER,0) as billingCust,isnull(SHIPPER_NAME,'') as shipperName,isnull(BRANCH_ID,'') as BRANCH_ID from LMS.dbo.RAKE_SHIFT_BOOKING" +
			" where SYSTEM_ID = ? and CUSTOMER_ID = ? and BOOKING_TYPE = ? and BRANCH_ID=? order by BOOKING_NO desc ";

	public static final String GET_BOOKING_ID="select max (BOOKING_NO) as MAX_BOOKING_NO from LMS.dbo.RAKE_SHIFT_BOOKING where SYSTEM_ID = ? and CUSTOMER_ID = ? "; 

	public static final String UPDATE_RAKE_SHIFTING_BOOKING=" update LMS.dbo.RAKE_SHIFT_BOOKING set BOOKING_DATE = ?,RAKE_NO = ?,RAIL_NO = ?,ARRIVAL_DATE = ?,DEP_DATE = ?, FROM_PLACE = ?,TO_PLACE = ?,NO_OF_CONTAINER = ?," +
			" UPDATED_BY = ?,UPDATED_DATE = getdate(),BILLING_CUSTOMER=?,SHIPPER_NAME=? where UID = ?";
	
	public static final String GET_BRANCH_NAME="SELECT BranchId,BranchName FROM Maple.dbo.tblBranchMaster where SystemId=? AND ClientId=? AND Category=0";
	
	public static final String GET_VEHICLE_NUMBERS_TDP=" select REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT vc, AMS.dbo.Vehicle_User vu "+
		"where vc.CLIENT_ID=? and vc.SYSTEM_ID=? and vu.User_id=? and "+
		"vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no "+
		"and REGISTRATION_NUMBER not in (select VehicleNo COLLATE DATABASE_DEFAULT from LMS.dbo.Trip_Chart where ClientId=? and SystemId=? and Status='open') "+
		"and REGISTRATION_NUMBER not in (select VEHICLE_NO COLLATE DATABASE_DEFAULT from LMS.dbo.RAKE_SHIFT_TRIP_DEATILS where CUSTOMER_ID=? and  SYSTEM_ID=? and STATUS='open')"+
		"order by REGISTRATION_NUMBER ";
	
	public static final String GET_VEHICLE_NUMBERS_MV="select VehicleNo from LMS.dbo.MarketVehicleMaster where ClientId=? and SystemId=? and STATUS='Active'"+
		"and VehicleNo not in (select MVNo from LMS.dbo.Market_Vehicle_Trip_Chart where SystemId=? and ClientId=? and STATUS='Open')"+
		"and VehicleNo not in ((select VEHICLE_NO COLLATE DATABASE_DEFAULT from LMS.dbo.RAKE_SHIFT_TRIP_DEATILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='open'))"+
		"order by VehicleNo";
	
	public static final String SELECT_ACTIVE_TRANSPORTERS="select CustomerId,CustomerName from Customer_Information where SystemId=? and clientId=? and STATUS='Active'";

		public static final String SELECT_DRIVER_NAMES="select a.DRIVER_ID,b.Fullname+'('+isnull(cast(b.EmployeeID as varchar(50)),'')+')' as Fullname,a.REGISTRATION_NO as RegNO from AMS.dbo.Driver_Master b left outer join dbo.Driver_Vehicle a on"+
		" a.SYSTEM_ID=b.System_id and b.Driver_id=a.DRIVER_ID"+ 
		" where a.SYSTEM_ID=? and a.REGISTRATION_NO=?";
	
	public static final String INSERT_TRIP="insert into dbo.RAKE_SHIFT_TRIP_DEATILS(CREATED_BY,SYSTEM_ID,CUSTOMER_ID,VEHICLE_NO,TRIP_CHART_NO,DRIVER_NAME,OWNER_NAME,TRIP_TYPE,DRIVER_CONTACT,TPT_NAME,DRIVER_LICENCE,BRANCH_ID,CREATED_DATE,STATUS)  values(?,?,?,?,?,?,?,?,?,?,?,?,getutcdate(),'Open')";
	
	public static final String UPDATE_TRIP="update dbo.RAKE_SHIFT_TRIP_DEATILS set VEHICLE_NO=?, DRIVER_NAME=?, OWNER_NAME=?, DRIVER_CONTACT=?, TPT_NAME=?, DRIVER_LICENCE=?, UPDATED_BY=?, UPDATED_DATE=getutcdate()"+
	"where UID=? AND SYSTEM_ID=? AND CUSTOMER_ID=? ";
	
	public static final String GET_TRIP_NO="select isNull(RunningNo,0) as TRIP_NO from dbo.Latest_Running_GR_No where ClientId=? and SystemId=? and TripType=?";
	
	public static final String IS_PRESENT_TRIP_NO="select * from Latest_Running_GR_No where ClientId=? and SystemId=? and TripType=? ";
	
	public static final String UPDATE_TRIP_NO="update Latest_Running_GR_No set RunningNo=? where ClientId=? and SystemId=? and TripType=?";
	
	public static final String INSERT_TRIP_NO="insert into Latest_Running_GR_No (RunningNo, ClientId, SystemId,TripType) values (?,?,?,?)";
	
	public static final String GET_RAKE_TRIP_DETAILs="select isnull(a.UID,0) as UID, isnull(a.TRIP_ID,0) as tripNo, isnull(a.TRIP_CHART_NO,'') as TripChartNO, isnull(a.VEHICLE_NO,'') as VehicleNO, isnull(a.DRIVER_NAME,'') as DriverName, isNull(a.DRIVER_CONTACT,0) as DriverContact,isNull(a.TPT_NAME,'') as TPTName,isNull(a.DRIVER_LICENCE,0) as DriverLicence, isnull(a.OWNER_NAME,'') as OwnerName, "+
	"isnull(b.FIRST_NAME,0) as CreatedBy, isnull(a.CREATED_DATE,'') as createdDate, isnull(a.CLOSED_BY,'') as closedBy, isnull(a.CLOSED_DATE,'') as closedDate ,isnull(a.STATUS,'') as Status "+
	"from dbo.RAKE_SHIFT_TRIP_DEATILS a left outer join ADMINISTRATOR.dbo.USERS b on a.SYSTEM_ID = b.SYSTEM_ID and a.CREATED_BY=b.USER_ID " +
	"where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? AND a.TRIP_TYPE=? AND a.BRANCH_ID=?";
	
	public static final String GET_TRIP_APPROVAL_DETAILS="select a.UID as UID,isnull(a.BOOKING_ID,0) as BOOKING_NO,  isnull(b.BOOKING_DATE,'') as BOOKING_DATE, isnull(a.CONTAINER_NO,'') as CONTAINER_NO, isnull(a.CONTAINER_SIZE,0) as SIZE, isnull(a.LOAD_TYPE,0) as LOAD_TYPE, isnull(a.LOCATION,'') as LOCATION, isnull(a.SHIPPING_NAME,'') as SHIPPING_NAME, isnull(c.CustomerName,'') as BILLING_CUSTOMER, isnull(a.WEIGHT,0) as WEIGHT, isnull(a.SB_BL_NO,'') as SB_BL_NO, isnull(d.FUEL_LTRS,0) as FUEL_LTRS, isnull(d.FUEL_AMT,0) as FUEL_AMT, isnull(d.INCENTIVE,0) as INCENTIVE " + 
		"from dbo.RAKE_SHIFT_CONTAINER_DETAILS a "+
		" left outer join dbo.RAKE_EXPENSE_MASTER d on a.LOAD_TYPE = d.LOAD_TYPE AND a.LOCATION = d.LOCATION "+
		"left outer join dbo.RAKE_SHIFT_BOOKING b on a.BOOKING_ID = b.BOOKING_NO "+
		"left outer join dbo.Customer_Information c on a.BILLING_CUSTOMER=c.CustomerId "+
		"where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? AND a.ALLOCATED <> 'Y' AND a.UID=?";
		
	public static final String UPDATE_TRIP_ALLOCATION_DETAILS="update dbo.RAKE_SHIFT_CONTAINER_DETAILS set ALLOCATED=?, TRIP_NO=? where SYSTEM_ID=? AND CUSTOMER_ID=? AND UID=?";
		
	public static final String GET_ALLOCATED_TRIP_DETAILS="select isnull(a.UID,0) as UID, isnull(a.SYSTEM_ID,0) as SYSTEM_ID, isnull(a.CUSTOMER_ID,0) as CUSTOMER_ID, isnull(a.BOOKING_ID,0) as BOOKING_ID, isnull(b.BOOKING_DATE,'') as BOOKING_DATE, isnull(a.CONTAINER_NO,'') as CONTAINER_NO,isnull(a.CONTAINER_SIZE,'') AS SIZE,isnull(a.LOAD_TYPE,'') as LOAD_TYPE,isnull(a.LOCATION,'') as LOCATION ,isnull(a.SHIPPING_NAME,'') as SHIPPING_NAME,isnull(a.BILLING_CUSTOMER,'') as BILLING_CUSTOMER, isnull(a.WEIGHT,0) as WEIGHT,isnull(a.SB_BL_NO,'') as SB_BL_NO,isnull(a.ALLOCATED,'') as ALLOCATED,isnull(a.TRIP_NO,0) as TRIP_NO from dbo.RAKE_SHIFT_CONTAINER_DETAILS a "+
		" left outer join dbo.RAKE_SHIFT_BOOKING b on a.BOOKING_ID = b.BOOKING_NO "+
		"where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? AND a.ALLOCATED = 'Y' AND a.UID=?";
	
	
	//public static final String GET_LOCATION_LIST = " select ID,isnull(LOCATION,'') as location from LMS.dbo.RAKE_EXPENSE_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String GET_LOCATION_LIST = "select LoadId, LoadingorOffloading from LMS.dbo.Loading_Offloading_Master where SystemId=? and ClientId=? and STATUS='Active'";

	public static final String GET_BRANCH_LIST = "select BranchId, BranchName from Maple.dbo.tblBranchMaster where SystemId=? and ClientId=? ";

	public static final String GET_BILLING_CUSTOMER_LIST = "select isnull(CustomerId,0) as customerId,isnull(CustomerName,'') as customerName from LMS.dbo.Customer_Information where SystemId=? and ClientId=? and STATUS='Active'";
	
	public static final String INSERT_CONTAINER_DETAILS = " INSERT INTO LMS.dbo.RAKE_SHIFT_CONTAINER_DETAILS (SYSTEM_ID,CUSTOMER_ID,BOOKING_ID,CONTAINER_NO,CONTAINER_SIZE,LOAD_TYPE,LOCATION,SHIPPING_NAME,BILLING_CUSTOMER,WEIGHT,SB_BL_NO,REMARKS,CREATED_BY,CREATED_DATE,STATUS) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,getdate(),'Pending') ";

	public static final String UPDATE_CONTAINER_DETAILS = " update LMS.dbo.RAKE_SHIFT_CONTAINER_DETAILS set CONTAINER_NO=?, CONTAINER_SIZE=?, LOAD_TYPE=?, LOCATION=?, SHIPPING_NAME=?, BILLING_CUSTOMER=?, WEIGHT=?, SB_BL_NO=?, REMARKS=?, UPDATED_BY=?, UPDATED_DATE=getdate() where SYSTEM_ID=? and CUSTOMER_ID=? and UID=? ";

	public static final String GET_CONTAINER_DETAILS = " select UID,isnull(CONTAINER_NO,'') as containerNo, isnull(CONTAINER_SIZE,'') as containerSize, LOAD_TYPE,LOCATION,SHIPPING_NAME," +
			" BILLING_CUSTOMER,WEIGHT,isnull(REMARKS,'')as REMARKS,SB_BL_NO,CREATED_BY,CREATED_DATE,isnull(ALLOCATED,'') as ALLOCATED,STATUS from LMS.dbo.RAKE_SHIFT_CONTAINER_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and BOOKING_ID=? ";

	public static final String GET_APPROVE_DETAILS = "select a.UID, isnull(a.CONTAINER_NO,'') as CONTAINER_NO, isnull(a.CONTAINER_SIZE,'') as CONTAINER_SIZE,isnull(a.LOAD_TYPE,0) as LOAD_TYPE,isnull(a.LOCATION,'') as LOCATION,isnull(a.SHIPPING_NAME,'') as SHIPPING_NAME,isnull(b.CustomerName,'') as BILLING_CUSTOMER,isnull(a.WEIGHT,0) as WEIGHT,isnull(a.SB_BL_NO,'') as SB_BL_NO," +
			" isnull(a.BOOKING_ID,0) as BOOKING_ID,c.BOOKING_DATE as BOOKING_DATE from LMS.dbo.RAKE_SHIFT_CONTAINER_DETAILS a" +
			" left outer join LMS.dbo.Customer_Information b on a.SYSTEM_ID=b.SystemId and a.BILLING_CUSTOMER=b.CustomerId" +
			" left outer join LMS.dbo.RAKE_SHIFT_BOOKING c on a.BOOKING_ID=c.BOOKING_NO " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='Pending' and c.BRANCH_ID=? ";

	public static final String UPDATE_CONTAINER_INFO_STATUS="update LMS.dbo.RAKE_SHIFT_CONTAINER_DETAILS set STATUS=?,APPROVED_CANCELLED_BY=?,APPROVED_CANCELLED_DATE=getdate() where SYSTEM_ID=? and CUSTOMER_ID=? and UID=?";

	public static final String GET_VENDOR_NAMES_FOR_ALLOCATE_FUEL="select a.VendorId,b.VendorName+'('+a.FuelTypeName+')' as VendorName,a.FuelPricePerLitre from dbo.Fuel_Type_Master a "+
	"left outer join dbo.Vendor_Master b on b.VendorId=a.VendorId and b.SystemId=a.SystemId and b.ClientId=a.ClientId "+
	"where a.ClientId=? and a.SystemId=? and a.FuelType='DIESEL' ";

	public static final String GET_ACTIVE_VENDOR_NAMES_FOR_ALLOCATE_FUEL="select a.VendorId,b.VendorName+'('+a.FuelTypeName+')' as VendorName,a.FuelPricePerLitre from dbo.Fuel_Type_Master a "+
	"left outer join dbo.Vendor_Master b on b.VendorId=a.VendorId and b.SystemId=a.SystemId and b.ClientId=a.ClientId "+
	"where a.ClientId=? and a.SystemId=? and a.FuelType='DIESEL' and a.STATUS='Active' ";
	
	public static final String ADD_ADDITIONAL_AMOUNT="update dbo.RAKE_SHIFT_TRIP_DEATILS set ADD_CASH=? where UID=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String ADD_ADDITIONAL_FUEL_AND_AMOUNT="update dbo.RAKE_SHIFT_TRIP_DEATILS set ADD_FUEL_LTR=?,ADD_FUEL_AMT=? where UID=? and SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String UPDATE_RAKE_SHIFT_TRIP_STATUS="update dbo.RAKE_SHIFT_TRIP_DEATILS set STATUS=? where SYSTEM_ID=? and CUSTOMER_ID=? and UID=?";

	public static final String GET_ACTIVE_BILLING_CUSTOMER = "select isnull(CustomerId,0) as customerId,isnull(CustomerName,'') as customerName from Customer_Information" +
			" where SystemId=? and CLientId=? and Status='Active'";
	
	public static final String SELECT_RAKE_LOCATION_VALIDATE="select LoadingorOffloading from LMS.dbo.Loading_Offloading_Master where SystemId=? and ClientId=? and STATUS='Active' and LoadingorOffloading=? ";

	public static final String INSERT_RAKE_SHIFT_IMPORT_DETAILS="INSERT INTO LMS.dbo.RAKE_SHIFT_CONTAINER_DETAILS(SYSTEM_ID,CUSTOMER_ID,BOOKING_ID,CONTAINER_NO,CONTAINER_SIZE,LOAD_TYPE,LOCATION,SHIPPING_NAME,BILLING_CUSTOMER,WEIGHT,SB_BL_NO,CREATED_BY,CREATED_DATE,REMARKS,STATUS) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,getdate(),?,'Pending') ";

	public static final String SELECT_RAKE_BILLING_VALIDATE="select isnull(CustomerId,0) as customerId,isnull(CustomerName,'') as customerName from LMS.dbo.Customer_Information where SystemId=? and ClientId=? and customerName=? and STATUS='Active'";

	public static final String GET_MVNO1="select isnull(RegOwnerName,'') as RegOwnerName from LMS.dbo.MarketVehicleMaster where ClientId=? and SystemId=? and VehicleNo=? and STATUS='Active'";
}
