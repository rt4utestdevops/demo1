package t4u.statements;
public class ContainerCargoManagementStatements {
    public static final String GET_CLIENT_NAMES = "select CustomerId,CustomerName from AMS.dbo.tblCustomerMaster where System_id=? ";
    
    public static final String GET_BRANCH_NAME = " select isnull(BranchId,0) as BranchId,isnull(BranchName,'') as BranchName from Maple.dbo.tblBranchMaster where SystemId=? and ClientId=?";
    
    public static final String GET_BOOKING_COUNT = " select count(*) as count from LMS.dbo.Trip_Chart_Booking tcb " +
        " left outer join LMS.dbo.Booking_Master bm on bm.SystemId=tcb.SystemId and bm.ClientId=tcb.ClientId and bm.BookingNo=tcb.BookingId " +
        " where tcb.ClientId=? and tcb.SystemId=? and bm.BranchName=? and tcb.BookingType=? " +
        " and bm.DateofBooking between dateadd(mi,-?,?) and dateadd(mi,-?,?) and tcb.DELETED=0 and (tcb.Status='closed' or tcb.Status='open')";
    
    public static final String GET_BOOKING_TYPE = "select * from LMS.dbo.Booking_Type where SystemId=? and ClientId=?";
    
    public static final String GET_FUEL_LOG_DETAILS_ALL = " select isNull(vm.VendorName,'') as VendorName,isNull(td.ASSET_NO,'') as VehicleNo, isnull(dateadd(mi,?,fat.InsertedDate),'') as Date," + 
	  	" isNull(PricePerLiter,'0') as FuelRate,isNull(FuelRequired,'0') as FuelRequired,isNull(fat.Amount,'0') as Amount" +
	  	" from LMS.dbo.Fuel_Allocation_Table fat" +
	  	" inner join LMS.dbo.Vendor_Master vm on vm.VendorId=fat.VendorName and vm.SystemId=fat.SystemId and vm.ClientId=fat.ClientId" +
	  	" inner join LMS.dbo.TRIP_DETAILS td on td.SYSTEM_ID=fat.SystemId and td.CUSTOMER_ID=fat.ClientId  and td.TRIP_NO=fat.TripId" +
	  	" where fat.SystemId=? and fat.ClientId=? and InsertedDate between dateadd(mi,-?,?) and dateadd(mi,-?,?) " +
	  	" union " +
	  	" select isNull(vm.VendorName,'') as VendorName,isNull(fat.SubTripId,'') as VehicleNo, isnull(dateadd(mi,?,fat.InsertedDate),'') as Date,isNull(PricePerLiter,'0') as FuelRate," +
	  	"isNull(FuelRequired,'0') as FuelRequired,isNull(fat.Amount,'0') as Amount " +
	  	"from LMS.dbo.Fuel_Allocation_Table fat " +
	  	"inner join LMS.dbo.Vendor_Master vm on vm.VendorId=fat.VendorName and vm.SystemId=fat.SystemId and vm.ClientId=fat.ClientId " +
	  	"where fat.SystemId=? and fat.ClientId=? and AD=? " +
	  	"and InsertedDate between dateadd(mi,-?,?) and dateadd(mi,-?,?)";

	public static final String GET_FUEL_LOG_DETAILS = " select isNull(vm.VendorName,'') as VendorName,isNull(td.ASSET_NO,'') as VehicleNo,isnull(dateadd(mi,?,fat.InsertedDate),'') as Date," + 
	  	" isNull(PricePerLiter,'0') as FuelRate,isNull(FuelRequired,'0') as FuelRequired,isNull(fat.Amount,'0') as Amount" +
	  	" from LMS.dbo.Fuel_Allocation_Table fat" +
	  	" inner join LMS.dbo.Vendor_Master vm on vm.VendorId=fat.VendorName and vm.SystemId=fat.SystemId and vm.ClientId=fat.ClientId" +
	  	" left outer join LMS.dbo.TRIP_DETAILS td on td.SYSTEM_ID=fat.SystemId and td.CUSTOMER_ID=fat.ClientId  and td.TRIP_NO=fat.TripId" +
	  	" where fat.SystemId=? and fat.ClientId=? and td.ASSET_NO=? and InsertedDate between dateadd(mi,-?,?) and dateadd(mi,-?,?) " +
	  	" union " +
	  	" select isNull(vm.VendorName,'') as VendorName,isNull(fat.SubTripId,'') as VehicleNo, isnull(dateadd(mi,?,fat.InsertedDate),'') as Date,isNull(PricePerLiter,'0') as FuelRate," +
	  	"isNull(FuelRequired,'0') as FuelRequired,isNull(fat.Amount,'0') as Amount " +
	  	"from LMS.dbo.Fuel_Allocation_Table fat " +
	  	"inner join LMS.dbo.Vendor_Master vm on vm.VendorId=fat.VendorName and vm.SystemId=fat.SystemId and vm.ClientId=fat.ClientId " +
	  	"where fat.SystemId=? and fat.ClientId=? and fat.SubTripId=? and AD=? " +
	  	"and InsertedDate between dateadd(mi,-?,?) and dateadd(mi,-?,?)";
	
	
	public static final String GET_UNASSIGNED_VEHICLES = " select REGISTRATION_NUMBER from VEHICLE_CLIENT vc "+
		" inner join Vehicle_User vu on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no "+
		" where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? "+
		" and REGISTRATION_NUMBER not in " +
		" (select RegistrationNo COLLATE DATABASE_DEFAULT from FMS.dbo.JobCard_Ext_Mstr where JobCardStatus ='Open' and SystemId=? and ClientId=? "+
		" union " +
		" select ASSET_NO from LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT where SYSTEM_ID=? and CUSTOMER_ID=?) ";
	 
public static final String GET_PRINCIPAL_STORE_DETAILS = "select isnull(CustomerId,0) as principalId,isnull(CompanyName,'') as principalName " +
						" from LMS.dbo.Customer_Information where SystemId=? and ClientId=? and CustomerType=? and STATUS = 'Active' ";

public static final String GET_CONSIGNEE_STORE_DETAILS = "select isnull(CustomerId,0) as principalId,isnull(CompanyName,'') as principalName " +
						" from LMS.dbo.Customer_Information where SystemId=? and ClientId=? and CustomerType=? and STATUS = 'Active' ";

public static final String CHECK_VEHICLE_ASSIGNED = " select UID from LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT where ASSET_NO=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String SAVE_ASSIGN_VEHICLE_DETAILS= " insert into LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT(ASSET_NO,PRINCIPAL_ID,CONSIGNEE_ID,SYSTEM_ID,CUSTOMER_ID,CREATED_BY,CREATED_DATE) values(?,?,?,?,?,?,getUTCDate())";

public static final String MODIFY_ASSIGN_VEHICLE_DETAILS=" update LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT set PRINCIPAL_ID=?,CONSIGNEE_ID=?,UPDATED_BY=?,UPDATED_DATE=getutcdate() where UID=? and SYSTEM_ID=? and CUSTOMER_ID=? ";

public static final String GET_ASSIGNED_VEHICLE_DETAILS= " select isnull(cva.UID,0) as UID, isnull(cva.ASSET_NO,'') as VEHICLE_NO, isnull(ci1.CompanyName,'') as Principal, isnull(ci.CompanyName,'') as Consignee, "+
							" isnull(u1.Firstname,'') as createdBy,isnull(u2.Firstname,'') as updatedBy,isnull(dateadd(mi,?,cva.CREATED_DATE),'') as createdDate,isnull(dateadd(mi,?,cva.UPDATED_DATE),'') as updatedDate "+
							" from LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT cva " +
							" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=cva.SYSTEM_ID and ci.ClientId=cva.CUSTOMER_ID and ci.CustomerId=cva.CONSIGNEE_ID "+
							" left outer join LMS.dbo.Customer_Information ci1 on ci1.SystemId=cva.SYSTEM_ID and ci1.ClientId=cva.CUSTOMER_ID and ci1.CustomerId=cva.PRINCIPAL_ID "+
							" left outer join AMS.dbo.Users u1 on u1.System_id=cva.SYSTEM_ID and u1.User_id=cva.CREATED_BY "+
							" left outer join AMS.dbo.Users u2 on u2.System_id=cva.SYSTEM_ID and u2.User_id=cva.UPDATED_BY "+
							" where cva.SYSTEM_ID=? and cva.CUSTOMER_ID=? ";

public static final String GET_VEHICLE_LIST = "select REGISTRATION_NUMBER from VEHICLE_CLIENT vc, Vehicle_User vu " +
							"where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? " +
							"and vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no order by REGISTRATION_NUMBER";

public static final String GET_VEHICLES_NOT_ON_TRIP = "select REGISTRATION_NUMBER from VEHICLE_CLIENT vc, Vehicle_User vu " +
"where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? " +
"and vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER= vu.Registration_no and REGISTRATION_NUMBER not in (" +
"select ASSET_NO COLLATE DATABASE_DEFAULT from LMS.dbo.TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='OPEN') order by REGISTRATION_NUMBER";

public static final String GET_PENDING_EXPENSE_DETAILS = "select isNull(ae.UNIQUE_ID,0) as UID,isNull(ae.TRIP_NO,'') as TRIP_NO,isNull(dateadd(mi,?,td.CREATED_TIME),'') as TripDate,isNull(cip.CompanyName,'') as Principal, " +
		"isNull(cic.CompanyName,'') as Consignee,isNull(ae.AMOUNT,0) as Amount,isNull(ae.REMARKS,'') as Description,0 as Approved_Amount,''  as AccHeader,isNull(td.BRANCH_ID,0) as BranchId,isNull(td.DRIVER_ID,0) as DriverId,isNull(td.ASSET_NO,'') as Asset_No, " +
		"'' as Remarks,dateadd(mi,?,ae.INSERTED_DATE) as INSERTED_DATE,isNull(ae.BILLING_TYPE_ID,0) as BILLING_TYPE_ID  " +
		"from LMS.dbo.ADDITIONAL_EXPENSES ae " +
		"inner join LMS.dbo.TRIP_DETAILS td on td.SYSTEM_ID=ae.SYSTEM_ID and td.CUSTOMER_ID=ae.CUSTOMER_ID and td.TRIP_NO=ae.TRIP_NO " +
		"inner join LMS.dbo.Customer_Information cip on cip.SystemId=ae.SYSTEM_ID and cip.ClientId=td.CUSTOMER_ID and cip.CustomerId=td.PRINCIPAL_ID " +
		"left outer join LMS.dbo.Customer_Information cic on cic.SystemId=ae.SYSTEM_ID and cic.ClientId=td.CUSTOMER_ID and cic.CustomerId=td.CONSIGNEE_ID " +
		"where ae.SYSTEM_ID =? and ae.CUSTOMER_ID =? and ae.STATUS=? and ae.INSERTED_DATE between dateadd(mi,?,?) and dateadd(mi,?,?)";

public static final String GET_APPROVED_EXPENSE_DETAILS = "select isNull(ae.UNIQUE_ID,0) as UID,isNull(ae.TRIP_NO,'') as TRIP_NO,isNull(dateadd(mi,?,td.CREATED_TIME),'') as TripDate,isNull(cip.CompanyName,'') as Principal," +
		"isNull(cic.CompanyName,'') as Consignee,isNull(ae.AMOUNT,0) as Amount,isNull(ae.REMARKS,'') as Description, isNull(ae.APPROVED_AMOUNT,0) as Approved_Amount,isNull(cc.DATA,'')  as AccHeader,isNull(td.BRANCH_ID,0) as BranchId,isNull(td.ASSET_NO,'') as Asset_No," +
		"isNull(td.DRIVER_ID,0) as DriverId,isNull(cb.DESCRIPTION,'') as Remarks,dateadd(mi,?,ae.INSERTED_DATE) as INSERTED_DATE,isNull(ae.BILLING_TYPE_ID,0) as BILLING_TYPE_ID " +
		"from LMS.dbo.ADDITIONAL_EXPENSES ae " +
		"inner join LMS.dbo.TRIP_DETAILS td on td.SYSTEM_ID=ae.SYSTEM_ID and td.CUSTOMER_ID=ae.CUSTOMER_ID and td.TRIP_NO=ae.TRIP_NO " +
		"inner join LMS.dbo.CASH_BOOK cb on cb.SYSTEM_ID=ae.SYSTEM_ID and cb.CUSTOMER_ID=ae.CUSTOMER_ID  and ae.UNIQUE_ID=cb.ADD_EXP_ID and cb.ACC_HEADER_ID <>15 " +
		"inner join LMS.dbo.CCM_LOOKUP cc on cc.SYSTEM_ID=ae.SYSTEM_ID and cc.CUSTOMER_ID=ae.CUSTOMER_ID and cc.ID=cb.ACC_HEADER_ID " +
		"inner join LMS.dbo.Customer_Information cip on cip.SystemId=ae.SYSTEM_ID and cip.ClientId=td.CUSTOMER_ID and cip.CustomerId=td.PRINCIPAL_ID " +
		"inner join LMS.dbo.Customer_Information cic on cic.SystemId=ae.SYSTEM_ID and cic.ClientId=td.CUSTOMER_ID and cic.CustomerId=td.CONSIGNEE_ID " +
		"where ae.SYSTEM_ID =? and ae.CUSTOMER_ID =? and ae.STATUS=? and cb.TRANSAC_DATE between dateadd(mi,?,?) and dateadd(mi,?,?) and cb.ADD_EXP_ID is not null ";

public static final String GET_REJECTED_EXPENSE_DETAILS = "select isNull(ae.UNIQUE_ID,0) as UID,isNull(ae.TRIP_NO,'') as TRIP_NO,isNull(dateadd(mi,?,td.CREATED_TIME),'') as TripDate,isNull(cip.CompanyName,'') as Principal,isNull(td.ASSET_NO,'') as Asset_No," +
		"isNull(cic.CompanyName,'') as Consignee,isNull(ae.AMOUNT,0) as Amount,isNull(ae.REMARKS,'') as Description, isNull(cb.AMOUNT,0) as Approved_Amount,isNull(cc.DATA,'')  as AccHeader," +
		"isNull(td.BRANCH_ID,0) as BranchId,isNull(td.DRIVER_ID,0) as DriverId,isNull(cb.DESCRIPTION,'') as Remarks,dateadd(mi,?,ae.INSERTED_DATE) as INSERTED_DATE,isNull(ae.BILLING_TYPE_ID,0) as BILLING_TYPE_ID " +
		"from LMS.dbo.ADDITIONAL_EXPENSES ae " +
		"inner join LMS.dbo.TRIP_DETAILS td on td.SYSTEM_ID=ae.SYSTEM_ID and td.CUSTOMER_ID=ae.CUSTOMER_ID and td.TRIP_NO=ae.TRIP_NO " +
		"inner join LMS.dbo.CASH_BOOK cb on cb.SYSTEM_ID=ae.SYSTEM_ID and cb.CUSTOMER_ID=ae.CUSTOMER_ID and cb.ADD_EXP_ID=ae.UNIQUE_ID and cb.ACC_HEADER_ID=15 " +
		"inner join LMS.dbo.CCM_LOOKUP cc on cc.SYSTEM_ID=ae.SYSTEM_ID and cc.CUSTOMER_ID=ae.CUSTOMER_ID and cc.ID=cb.ACC_HEADER_ID " +
		"inner join LMS.dbo.Customer_Information cip on cip.SystemId=ae.SYSTEM_ID and cip.ClientId=td.CUSTOMER_ID and cip.CustomerId=td.PRINCIPAL_ID " +
		"inner join LMS.dbo.Customer_Information cic on cic.SystemId=ae.SYSTEM_ID and cic.ClientId=td.CUSTOMER_ID and cic.CustomerId=td.CONSIGNEE_ID " +
		"where ae.SYSTEM_ID =? and ae.CUSTOMER_ID =? and cb.TRANSAC_DATE between dateadd(mi,?,?) and dateadd(mi,?,?) and cb.ADD_EXP_ID is not null ";

public static final String GET_ACC_HEADER_DETAILS = "select isnull(ID,0) as typeId,isnull(DATA,'') as typeName from LMS.dbo.CCM_LOOKUP where SYSTEM_ID=? and CUSTOMER_ID=? and TYPE=? order by ID";

public static final String GET_USERS_BRANCH = "select isnull(bm.BranchId,0) as id,isnull(bm.BranchName,'') as branchName"+
							" from Maple.dbo.tblBranchMaster bm"+ 
							" left outer join LMS.dbo.USER_BRANCH_ASSOCIATION uba on bm.SystemId=uba.SYSTEM_ID and bm.ClientId=uba.CUSTOMER_ID and bm.BranchId=uba.BRANCH_ID"+
							" where bm.SystemId=? and bm.ClientId=? and uba.USER_ID=?";

public static final String UPDATE_ADDITIONAL_EXPENSE = "update LMS.dbo.ADDITIONAL_EXPENSES set APPROVED_AMOUNT=?,STATUS=? where SYSTEM_ID=? and CUSTOMER_ID=? and UNIQUE_ID=?";

public static final String UPDATE_TRIP_DETAILS = "update LMS.dbo.TRIP_DETAILS set ADD_COST=(select sum(isNull(APPROVED_AMOUNT,0))" +
" from LMS.dbo.ADDITIONAL_EXPENSES where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_NO=?) where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_NO=?";

public static final String GET_TRIP_HISTORY_DETAILS = "select isNull(td.ASSET_NO,'') as AssetNo,isNull(tbm.BranchName,'') as BranchName,isNull(vm.ModelName,'') as Model,isNull(td.TRIP_NO,'') as TripNo, "+
							" isNull(cic.CompanyName,'') as ConsigneeName,isNull(cip.CompanyName,'') as PrincipleName,isNull(dm.Fullname,'') as DriverName, "+
							" isNull(dm.Mobile,'') as DriverMobile, isNull(dateadd(mi,?,td.CREATED_TIME),'') as TripStartTime,isNull(dateadd(mi,?,td.CLOSED_TIME),'') as TripEndTime, "+
							" isNull(td.GR_NO,'') as GRNo, isNull(NO_OF_BARREL,0) as Drums,isNull(td.MASTER_KMS,0) as MasterKms, "+
							" isNull(REQ_FUEL,0) as FuelConsumption,isNull(R_FEE,0) as RFee,isNull(B_FEE,0) as BFee,isNull(T_FEE,0) as Toll,isNull(DRIVER_INCENTIVE,0) as DriverIncentive, "+
							" isNull(POLICE,0) Police, isNull(ESCORT,0) as Escort,isNull(LOADING,0) as Loading,isNull(td.LABOUR_CHARGES,0) as LabourCharges,isNull(OCTROI,0) as Octroi, "+
							" isNull(OTHERS_FEE,0) as OtherExpenses,isNull(MRNG_INCENTIVE,0) as MrngIncentive,isNull(CONVEYANCE,0) as Conveyance,isNull(ADD_COST,0) as ApprovedAddExpenses, "+
							" (isNull(R_FEE,0) + isNull(B_FEE,0) + isNull(T_FEE,0) + isNull(DRIVER_INCENTIVE,0) + isNull(POLICE,0) + isNull(ESCORT,0) + isNull(LOADING,0) + isNull(td.LABOUR_CHARGES,0) "+
							" + isNull(OCTROI,0) + isNull(OTHERS_FEE,0) + isNull(MRNG_INCENTIVE,0) + isNull(CONVEYANCE,0) + isNull(ADD_COST,0)) as TotalTripExp, "+
							" (isNull(ADV_CASH,0) + isNull(ae.DriverAdv1,0)) as DriverAdv,isNull(inv.ReceiptedAmount,0) as ReceiptedAmount, "+
							" isNull(inv.BillingAmount,0) as BillingAmount,isNull(inv.DetentionAmount,0) as DetentionAmount,isNull(inv.UnloadingAmount,0) as UnloadingAmount, "+
							" (isNull(inv.ReceiptedAmount,0) + isNull(inv.BillingAmount,0) + isNull(inv.DetentionAmount,0) + isNull(inv.UnloadingAmount,0)) as TotalBill, "+
							" ((isNull(inv.ReceiptedAmount,0) + isNull(inv.BillingAmount,0) + isNull(inv.DetentionAmount,0) + isNull(inv.UnloadingAmount,0)) - "+
							" (isNull(R_FEE,0) + isNull(B_FEE,0) + isNull(T_FEE,0) + isNull(DRIVER_INCENTIVE,0) + isNull(POLICE,0) + isNull(ESCORT,0) + isNull(LOADING,0) + isNull(td.LABOUR_CHARGES,0) "+ 
							" + isNull(OCTROI,0) + isNull(OTHERS_FEE,0) + isNull(MRNG_INCENTIVE,0) + isNull(CONVEYANCE,0) + isNull(ADD_COST,0))) as ProfitLoss "+
							" from LMS.dbo.TRIP_DETAILS td "+
							" inner join LMS.dbo.Customer_Information cip on cip.CustomerId=td.PRINCIPAL_ID and cip.SystemId=td.SYSTEM_ID and cip.ClientId=td.CUSTOMER_ID "+
							" inner join LMS.dbo.Customer_Information cic on cic.CustomerId=td.CONSIGNEE_ID and cic.SystemId=td.SYSTEM_ID and cic.ClientId=td.CUSTOMER_ID "+
							" inner join Maple.dbo.tblBranchMaster tbm on tbm.BranchId=td.BRANCH_ID and tbm.SystemId=td.SYSTEM_ID and tbm.ClientId=td.CUSTOMER_ID "+
							" left outer join AMS.dbo.Driver_Master dm on dm.Driver_id=td.DRIVER_ID and dm.System_id=td.SYSTEM_ID and dm.Client_id=td.CUSTOMER_ID "+
							" inner join AMS.dbo.tblVehicleMaster tvm on tvm.System_id=td.SYSTEM_ID and td.ASSET_NO=tvm.VehicleNo collate database_default "+
							" left outer join FMS.dbo.Vehicle_Model vm on vm.ModelTypeId=tvm.Model and vm.SystemId=tvm.System_id "+
							" left outer join "+
							" ( "+
							" select sum(isNull(AMOUNT,0) - isNull(APPROVED_AMOUNT,0)) as DriverAdv1,TRIP_NO,SYSTEM_ID,CUSTOMER_ID from LMS.dbo.ADDITIONAL_EXPENSES "+
							" where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS in ('APPROVED','REJECTED') group by TRIP_NO,SYSTEM_ID,CUSTOMER_ID "+
							" ) ae "+
							" on ae.SYSTEM_ID=td.SYSTEM_ID and ae.CUSTOMER_ID=td.CUSTOMER_ID and ae.TRIP_NO=td.TRIP_NO "+
							" left outer join "+
							" ( "+
							" select TRIP_ID,SYSTEM_ID,CUSTOMER_ID,sum(isNull(EXPENSES,0)) as ReceiptedAmount,sum(isNull(BILLING_RATE,0)) as BillingAmount, "+
							" sum(isNull(DETENTION_AMOUNT,0)) as DetentionAmount,sum(isNull(ORIGINAL_BILLING_RATE,0)) as UnloadingAmount "+
							" from  LMS.dbo.INVOICE_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? group by TRIP_ID,SYSTEM_ID,CUSTOMER_ID "+
							" ) inv "+
							" on inv.SYSTEM_ID=td.SYSTEM_ID and inv.CUSTOMER_ID=td.CUSTOMER_ID and inv.TRIP_ID=td.TRIP_NO "+
							" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.BRANCH_ID=? and td.ASSET_NO=? and td.CREATED_TIME between ? and ? and DETENTION_GEN='Y' and BILLING_GEN='Y' and RECEIPTED_GEN='Y' and RECEIPTED_GEN='Y' " +
							" and td.TRIP_NO not in ( select distinct TRIP_NO from LMS.dbo.ADDITIONAL_EXPENSES where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='PENDING')"; 
 
public static final String GET_PROFIT_LOSS_DETAILS = "select isnull(td.ASSET_NO,'') as vehicleNo,isnull(td.TRIP_NO,'') as tripNo,month(dateadd(mi,?,td.CLOSED_TIME)) as Month,isnull(dateadd(mi,?,td.CLOSED_TIME),'') as tripClosedTime,isnull(td.MASTER_KMS,0) as Kms," +
"(sum(isnull(ind.BILLING_RATE,0))+sum(isnull(ind.DETENTION_AMOUNT,0))+sum(isnull(ind.EXPENSES,0))+sum(isnull(ind.ORIGINAL_BILLING_RATE,0))) as invoiceReceived," +
"(isnull(td.R_FEE,0)+isnull(td.B_FEE,0)+isnull(td.T_FEE,0)+isnull(td.DRIVER_INCENTIVE,0)+isnull(td.OTHERS_FEE,0)+isnull(td.LOADING,0)+isnull(td.ESCORT,0)+isnull(td.UNLOADING,0)+isnull(td.OCTROI,0)+isnull(td.POLICE,0)+isnull(td.LABOUR_CHARGES,0)+isnull(td.MRNG_INCENTIVE,0)+" +
"isnull(td.CONVEYANCE,0)+isnull(td.ADD_COST,0)+isnull(td.GPS_FUEL_COST,0)) as expenses"+
" from LMS.dbo.TRIP_DETAILS td"+
" left outer join LMS.dbo.INVOICE_DETAILS ind on ind.SYSTEM_ID=td.SYSTEM_ID and ind.CUSTOMER_ID=td.CUSTOMER_ID and ind.TRIP_ID=td.TRIP_NO"+
" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.ASSET_NO in (#) and td.CLOSED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,dateadd(m,1,?)) and td.STATUS='CLOSED' and DETENTION_GEN='Y' and UNLOADING_GEN='Y' and BILLING_GEN='Y' and RECEIPTED_GEN='Y' " +
"and td.TRIP_NO not in (select distinct TRIP_NO from LMS.dbo.ADDITIONAL_EXPENSES where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='PENDING')" +
" group by td.ASSET_NO,td.TRIP_NO,td.CLOSED_TIME,td.MASTER_KMS,td.R_FEE,td.B_FEE,td.T_FEE,td.DRIVER_INCENTIVE,td.OTHERS_FEE,td.FUEL_COST,td.LOADING,td.ESCORT,td.UNLOADING,td.OCTROI,td.POLICE,td.LABOUR_CHARGES,td.MRNG_INCENTIVE,td.CONVEYANCE,td.ADD_COST,td.GPS_FUEL_COST"+
" order by vehicleNo,Month,tripNo";

public static final String GET_USER_BRANCH_LIST = "select isNull(tbm.BranchId,0) as BranchId,isNull(tbm.BranchName,'') + '(' +isNull(tbm.BranchCode,'') + ')' as BranchName " +
"from LMS.dbo.USER_BRANCH_ASSOCIATION uba " +
"inner join Maple.dbo.tblBranchMaster tbm on tbm.SystemId=uba.SYSTEM_ID and tbm.ClientId=uba.CUSTOMER_ID and tbm.BranchId=uba.BRANCH_ID " +
"where SYSTEM_ID=? and CUSTOMER_ID=? and USER_ID=? and STATUS='Active'";

public static final String GET_LOOK_UP_LIST = "select isNull(DATA,'') as DATA,isNull(ID,0) as ID from LMS.dbo.CCM_LOOKUP where SYSTEM_ID=? and CUSTOMER_ID=? and TYPE=? order by ID";

public static final String GET_CLEANERS_LIST = "select _ID,CONDUCTOR_NAME from AMS.dbo.CONDUCTOR_MASTER where SYSTEM_ID=? and CLIENT_ID=? and STATUS='Active'";

public static final String GET_DRIVER_LIST = "select Driver_id,isNull(Fullname,'') as DriverName from AMS.dbo.Driver_Master where System_id=? and Client_id=?";

public static final String ADD_CASH_BOOK_DETAILS = "insert into LMS.dbo.CASH_BOOK (SYSTEM_ID,CUSTOMER_ID,BRANCH_ID,TRANSAC_TYPE_ID,TRANSAC_DATE,AMOUNT,ACC_HEADER_ID,DESCRIPTION," +
"BILL_NO,ASSET_NO,DRIVER_ID,CLEANER_ID,CREATED_BY,ADD_EXP_ID,TRIP_NO,REMARKS,STATUS) values(?,?,?,?,dateadd(mi,-?,?),?,?,?,?,?,?,?,?,?,?,?,?)";

public static final String UPDATE_CASH_BOOK = "update LMS.dbo.CASH_BOOK set FILE_NAME=?,EXTENSION=? where ID=?";

public static final String GET_CASH_BOOK_DETAILS = "select cb.ID,dateadd(mi,?,TRANSAC_DATE) as TRANSAC_DATE,isNull(bm.BranchCode,'') as BranchCode,luah.DATA as ACC_HEADER,ASSET_NO," +
"isNull(dm.Fullname,'') as DRIVER,isNull(cm.CONDUCTOR_NAME,'') as CLEANER_NAME,BILL_NO,DESCRIPTION,AMOUNT,lu.DATA as TRANSAC_TYPE,(isNull(FILE_NAME,'')+isNull(EXTENSION,'')) as FileName,isNull(TRIP_NO,'') as TRIP_NO " +
"from LMS.dbo.CASH_BOOK cb " +
"inner join LMS.dbo.CCM_LOOKUP lu on lu.SYSTEM_ID=cb.SYSTEM_ID and lu.CUSTOMER_ID=cb.CUSTOMER_ID and lu.TYPE='TransactionType' and lu.ID=cb.TRANSAC_TYPE_ID " +
"inner join Maple.dbo.tblBranchMaster bm on bm.SystemId=cb.SYSTEM_ID and bm.ClientId=cb.CUSTOMER_ID and bm.BranchId=cb.BRANCH_ID " +
"inner join LMS.dbo.CCM_LOOKUP luah on luah.SYSTEM_ID=cb.SYSTEM_ID and luah.CUSTOMER_ID=cb.CUSTOMER_ID and luah.TYPE='AccountHeader' and luah.ID=cb.ACC_HEADER_ID " +
"left outer join AMS.dbo.Driver_Master dm on dm.Driver_id=cb.DRIVER_ID and dm.System_id=cb.SYSTEM_ID and dm.Client_id=cb.CUSTOMER_ID " +
"left outer join AMS.dbo.CONDUCTOR_MASTER cm on cm._ID=cb.CLEANER_ID and cm.SYSTEM_ID=cb.SYSTEM_ID and cm.CLIENT_ID=cb.CUSTOMER_ID " +
"where cb.SYSTEM_ID=? and cb.CUSTOMER_ID=? and cb.BRANCH_ID=? and cb.TRANSAC_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and cb.STATUS='APPROVED'";


public static final String GET_UPLOADED_INVOICE = "select ID,isNull(FILE_NAME,'') as FILE_NAME,CREATED_DATE,isNull(EXTENSION,'') as EXTENSION from LMS.dbo.CASH_BOOK where ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";

public static final String GET_VEHICLE_COUNT_WITH_STATUS = "select count(*) as CountOfVehicles,'Assigned Vehicle' as Status from LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT where SYSTEM_ID=? and CUSTOMER_ID=? " +
"union " +
"select count(*) as CountOfVehicles,'Under Repair' as Status from FMS.dbo.JobCard_Ext_Mstr a  where a.SystemId=? and a.ClientId=? and a.JobCardStatus='Open' " +
"union " +
"select count(distinct RegistrationNo) as CountOfVehicles,'Repaired' as Status from FMS.dbo.JobCard_Ext_Mstr a  where a.SystemId=? and a.ClientId=? and a.JobCardStatus='Closed' and a.UpdatedDateTime>dateadd(dd,-2,getutcdate()) " +
"and RegistrationNo not in " +
"(select ASSET_NO from LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT where SYSTEM_ID=? and CUSTOMER_ID=? " +
"union " +
"select distinct ASSET_NO from LMS.dbo.TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and CREATED_TIME>a.UpdatedDateTime " +
"union " +
"select RegistrationNo from FMS.dbo.JobCard_Ext_Mstr a  where a.SystemId=? and a.ClientId=? and a.JobCardStatus='Open' " +
") ";

public static final String GET_DASHBOARD_ASSIGNED_VEHICLE_DETAILS = "select isNull(cip.CustomerId,'0') as PrincipalId,isNull(cip.CompanyName,'') as PrincipalCode," +
		"(isNull(ASSET_NO,'')+'('+isNull(cic.CompanyName,'') +')') as AssetNoWithCustCode,'Assigned Vehicle' as Status " +
		"from LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT cha " +
		"inner join LMS.dbo.Customer_Information cip on cip.CustomerId=cha.PRINCIPAL_ID and cip.SystemId=cha.SYSTEM_ID and cip.ClientId=cha.CUSTOMER_ID " +
		"left outer join LMS.dbo.Customer_Information cic on cic.CustomerId=cha.CONSIGNEE_ID and cic.SystemId=cha.SYSTEM_ID and cic.ClientId=cha.CUSTOMER_ID " +
		"where SYSTEM_ID=? and CUSTOMER_ID=? order by PrincipalCode ";

public static final String GET_CUSTOMER_BASED_ON_TYPE = "select ((isNull(cast(CustomerId as varchar),'')) + ',' +isNull(CompanyName,'')) as CustCode " +
		"from LMS.dbo.Customer_Information where SystemId=? and ClientId=? and CustomerType=? order by CustCode";

public static final String GET_DASHOBORD_UNDER_MAINTENANCE_VEHICLE_DETAILS = "select isNull(RegistrationNo,'') as AssetNo,isNull(dateadd(mi,?,InsertedDateTime),'') as RST " +
		"from FMS.dbo.JobCard_Ext_Mstr where SystemId=? and ClientId=? and JobCardStatus='Open'";

public static final String GET_DASHOBORD_REPAIRED_VEHICLE_DETAILS = "select isNull(RegistrationNo,'') as AssetNo,max(isNull(dateadd(mi,?,UpdatedDateTime),'')) as RET " +
		"from FMS.dbo.JobCard_Ext_Mstr a  where a.SystemId=? and a.ClientId=? and a.JobCardStatus='Closed' and a.UpdatedDateTime>dateadd(dd,-2,getutcdate()) " +
		"and RegistrationNo not in " +
		"(select ASSET_NO from LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT where SYSTEM_ID=? and CUSTOMER_ID=? " +
		"union " + 
		"select distinct ASSET_NO from LMS.dbo.TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and CREATED_TIME>a.UpdatedDateTime " +
		"union " +
		"select RegistrationNo from FMS.dbo.JobCard_Ext_Mstr a  where a.SystemId=? and a.ClientId=? and a.JobCardStatus='Open' " +
		") " +
		"group by RegistrationNo";

public static final String GET_DA_ASSIGNED_VEHICLE_DETAILS = "select count(cha.ASSET_NO) as CountOfVehicles,isNull(cip.CustomerId,'0') as PrincipalId,isNull(cip.CompanyName,'') as PrincipalCode,'Assigned Vehicle' as Status " +
		"from LMS.dbo.Customer_Information cip " +
		"left outer join LMS.dbo.CUSTOMER_VEHICLE_ASSIGNMENT cha on cip.CustomerId=cha.PRINCIPAL_ID and cip.SystemId=cha.SYSTEM_ID and cip.ClientId=cha.CUSTOMER_ID " +
		"where SystemId=? and ClientId=? and CustomerType='PRINCIPAL' group by cip.CustomerId,cip.CompanyName";

public static final String GET_TRIP_DONE_IN_LAST_THREE_MONTHS = "select count(*) as NoOfTrips,CONVERT(VARCHAR(10), DATEADD(MI,?,CREATED_TIME), 105) as Date from LMS.dbo.TRIP_DETAILS " +
		"WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND DATEPART(dd,DATEADD(MI,?,CREATED_TIME)) = DATEPART(dd,GETDATE()) and DATEDIFF(mm, DATEADD(MI,?,CREATED_TIME), GETDATE()) < 3 " +
		"group by CONVERT(VARCHAR(10),DATEADD(MI,?,CREATED_TIME), 105) order by Date";

public static final String GET_FUEL_VENDOR = "select a.VendorId,b.VendorName+'('+a.FuelTypeName+')' as VendorName,a.FuelPricePerLitre from LMS.dbo.Fuel_Type_Master a "+
	"left outer join LMS.dbo.Vendor_Master b on b.VendorId=a.VendorId and b.SystemId=a.SystemId and b.ClientId=a.ClientId "+
	"where a.SystemId=? and a.ClientId=? and a.FuelType='DIESEL' and a.STATUS=?";

public static final String SAVE_FUEL_LOG_DETAILS = "insert into LMS.dbo.Fuel_Allocation_Table(FuelTypeName,VendorName,PricePerLiter,FuelRequired,Amount,InsertedDate,ClientId,SystemId,SubTripId,AD) "+
	"values(?,?,?,?,?,dateadd(mi,-?,?),?,?,?,?)";

public static final String GET_VEHICLE_LEDGER_DETAILS = "select dateadd(mi,?,td.CREATED_TIME) as TripStartDate,isNull(td.TRIP_NO,'') as TripNo,isNull(cip.CompanyName,'') as Principle,isNull(cic.CompanyName,'') as Consignee,isNull(dm.Fullname,'') as DriverName," +
		" isNull(td.R_FEE,0) as RFee,isNull(td.B_FEE,0) as BFee,isNull(td.T_FEE,0) as TollFee,isNull(td.DRIVER_INCENTIVE,0) as DriverIncentive,isNull(td.POLICE,0) as Police,isNull(td.ESCORT,0) as Escort," +
		" isNull(td.LOADING,0) as Loading,isNull(td.UNLOADING,0) as Unloading,isNull(td.OCTROI,0) as Octroi,isNull(td.LABOUR_CHARGES,0) as LabourCost,IsNull(td.OTHERS_FEE,0) as OthersCost," +
		" (isNull(td.R_FEE,0)+isNull(td.B_FEE,0)+isNull(td.T_FEE,0)+isNull(td.DRIVER_INCENTIVE,0)+isNull(td.POLICE,0)+isNull(td.ESCORT,0)+isNull(td.LOADING,0)+isNull(td.UNLOADING,0)+isNull(td.OCTROI,0)+" +
		" isNull(td.LABOUR_CHARGES,0)+IsNull(td.OTHERS_FEE,0)) as TotalExpense,isNull(td.ADV_CASH,0) as AdvanceCash,isNull(td.ADD_COST,0) as ApprovedAddExpense,isNull(td.MRNG_INCENTIVE,0) as MrngIncentive,isNull(td.CONVEYANCE,0) as Conveyance" +
		" from LMS.dbo.TRIP_DETAILS td" +
		" inner join LMS.dbo.Customer_Information cip on cip.CustomerId=td.PRINCIPAL_ID and cip.SystemId=td.SYSTEM_ID and cip.ClientId=td.CUSTOMER_ID" +
		" inner join LMS.dbo.Customer_Information cic on cic.CustomerId=td.CONSIGNEE_ID and cic.SystemId=td.SYSTEM_ID and cic.ClientId=td.CUSTOMER_ID" +
		" inner join AMS.dbo.Driver_Master dm on dm.Driver_id=td.DRIVER_ID and dm.System_id=td.SYSTEM_ID and dm.Client_id=td.CUSTOMER_ID" +
		" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.CREATED_TIME BETWEEN ? AND ? and td.GR_STATUS='CLOSED' and td.TRIP_NO not in ( " +
		" select distinct TRIP_NO from LMS.dbo.ADDITIONAL_EXPENSES where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='PENDING') and td.ASSET_NO=? order by DriverName ";

public static final String GET_DETENTION_CHARGES_DETAILS = "select isnull(bm.BranchName,'') as branchName, isnull(td.ASSET_NO,'') as vehicleNo,isnull(dm.Fullname,'') as driverName,isnull(dm.Mobile,0) as driverNo," +
		" isnull(td.TRIP_NO,'') as tripNo,isnull(ci1.CompanyName,'') as principalName,isnull(ci2.CompanyName,'') as consigneeName,isnull(dateadd(mi,?,td.CONSIGN_ARR_TIME),'') as arrivalTime," +
		" isnull(dateadd(mi,?,td.CONSIGN_DEP_TIME),'') as depTime,isnull(td.DEST_ARR_DETEN_TIME,0) as detentionHrs,isnull(td.DEST_ARR_DETEN_COST,0) as detentionCharge"+
		" from LMS.dbo.TRIP_DETAILS td"+
		" left outer join Maple.dbo.tblBranchMaster bm on bm.SystemId=td.SYSTEM_ID and bm.ClientId=td.CUSTOMER_ID and bm.BranchId=td.BRANCH_ID"+
		" left outer join AMS.dbo.Driver_Master dm on dm.System_id=td.SYSTEM_ID and dm.Client_id=td.CUSTOMER_ID and dm.Driver_id=td.DRIVER_ID"+
		" left outer join LMS.dbo.Customer_Information ci1 on ci1.SystemId=td.SYSTEM_ID and ci1.CLientId=td.CUSTOMER_ID and ci1.CustomerId=td.PRINCIPAL_ID"+
		" left outer join LMS.dbo.Customer_Information ci2 on ci2.SystemId=td.SYSTEM_ID and ci2.CLientId=td.CUSTOMER_ID and ci2.CustomerId=td.CONSIGNEE_ID"+
		" where td.SYSTEM_ID=? and td.CUSTOMER_ID=? and td.BRANCH_ID=? and td.CLOSED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and td.ASSET_NO=? order by td.CLOSED_TIME";
	
public static final String GET_OPENING_BALANCE_FOR_CUURENT_YEAR = "SELECT isNull(OPENING_BAL,0) as OPENING_BAL,isNull(CLOSING_BAL,0) as CLOSING_BAL,month(getdate()) as CurrentMonth FROM LMS.dbo.CASH_BOOK_MONTHLY_DETAILS " +
"where SYSTEM_ID=? and CUSTOMER_ID=? and BRANCH_ID=? and MONTH=? and YEAR=?";

public static final String GET_MONTHLY_CASHBOOK_REPORT = "select cl.DATA as ACC_HEADER,case when cb.TRANSAC_TYPE_ID = 1 then sum(isNull(cb.AMOUNT,0)) else -sum(isNull(cb.AMOUNT,0)) end as AMOUNT," +
"cb.TRANSAC_TYPE_ID,month(dateadd(mi,#,cb.TRANSAC_DATE)) as MonthNo,year(dateadd(mi,#,cb.TRANSAC_DATE)) as Years, sum(isNull(cb.AMOUNT,0)) as SumAmount " +
"from LMS.dbo.CASH_BOOK cb " +
"inner join LMS.dbo.CCM_LOOKUP cl on cl.SYSTEM_ID=cb.SYSTEM_ID and cl.CUSTOMER_ID=cb.CUSTOMER_ID and cl.ID=cb.ACC_HEADER_ID and cl.TYPE='AccountHeader' " +
"where cb.STATUS='APPROVED' and cb.SYSTEM_ID=# and cb.CUSTOMER_ID=# and cb.BRANCH_ID=# and cb.TRANSAC_TYPE_ID IN (#) and " +
"((month(dateadd(mi,#,cb.TRANSAC_DATE))># and year(dateadd(mi,#,cb.TRANSAC_DATE))=#) or (month(dateadd(mi,#,cb.TRANSAC_DATE))<# and year(dateadd(mi,#,cb.TRANSAC_DATE))=#)) " +
"group by cl.DATA,cb.TRANSAC_TYPE_ID,month(dateadd(mi,#,cb.TRANSAC_DATE)),year(dateadd(mi,#,cb.TRANSAC_DATE)) " +
"union " +
"select 'Add Exp(Pending)' as ACC_HEADER,sum(isNull((-1*ae.AMOUNT),0)) as AMOUNT, '2' as TRANSAC_TYPE_ID, month(dateadd(mi,#,ae.INSERTED_DATE)) as MonthNo,year(dateadd(mi,#,ae.INSERTED_DATE)) as Years, " +
"sum(isNull(ae.AMOUNT,0)) as SumAmount " +
"from LMS.dbo.ADDITIONAL_EXPENSES ae " +
"inner join LMS.dbo.TRIP_DETAILS td on td.SYSTEM_ID=ae.SYSTEM_ID and ae.CUSTOMER_ID=td.CUSTOMER_ID and td.TRIP_NO=ae.TRIP_NO " +
"where ((month(dateadd(mi,#,ae.INSERTED_DATE))># and year(dateadd(mi,#,ae.INSERTED_DATE))=#) " +
"or (month(dateadd(mi,#,ae.INSERTED_DATE))<# and year(dateadd(mi,#,ae.INSERTED_DATE))=#)) and ae.STATUS='PENDING' and td.BRANCH_ID=# and " +
"ae.SYSTEM_ID=# and ae.CUSTOMER_ID=# group by month(dateadd(mi,#,ae.INSERTED_DATE)), year(dateadd(mi,#,ae.INSERTED_DATE)) order by ACC_HEADER,Years,MonthNo,TRANSAC_TYPE_ID ";

public static final String GET_CB_DETAILS_EXISTS = "select * from LMS.dbo.CASH_BOOK_MONTHLY_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and BRANCH_ID=? and MONTH=month(dateadd(mi,?,?)) and YEAR = Year(dateadd(mi,?,?))";

public static final String UPDATE_CB_MONTHLY_DETAILS = "update LMS.dbo.CASH_BOOK_MONTHLY_DETAILS set MONTHLY_BAL = MONTHLY_BAL + ?, CLOSING_BAL = CLOSING_BAL + ?, LEDGER_BAL = isNull(LEDGER_BAL,0) + ? " +
		"where SYSTEM_ID=? and CUSTOMER_ID=? and BRANCH_ID=? and MONTH=month(dateadd(mi,?,?)) and YEAR = Year(dateadd(mi,?,?)) " ;

public static final String GET_CBMD_LAST_MONTH_RECORD = "select top 1 * from LMS.dbo.CASH_BOOK_MONTHLY_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and BRANCH_ID=? order by ID desc";

public static final String INSERT_INTO_CBMD = "insert into LMS.dbo.CASH_BOOK_MONTHLY_DETAILS (SYSTEM_ID,CUSTOMER_ID,BRANCH_ID,MONTH,YEAR,MONTHLY_BAL,OPENING_BAL,CLOSING_BAL,LEDGER_BAL) values(?,?,?,month(?),year(?),?,?,?,?)";

public static final String GET_BRANCH_CURRENT_BALANCE = "select top 1 isNull(CLOSING_BAL,0) as CurrentBalance,isNull(LEDGER_BAL,0) as LedgerBalance,isNull(cd.CURRENCY_SYMBOL,'') as Currency " +
		"from LMS.dbo.CASH_BOOK_MONTHLY_DETAILS cbmd " +
		"inner join AMS.dbo.System_Master sm on sm.System_id=cbmd.SYSTEM_ID " +
		"inner join ADMINISTRATOR.dbo.COUNTRY_DETAILS cd on cd.COUNTRY_CODE=sm.CountryCode " +
		"where SYSTEM_ID=? and CUSTOMER_ID=? and BRANCH_ID=? ORDER BY ID desc";

public static final String GET_CASH_BOOK_APPROVE_REJECT_DETAILS = "select cb.ID,dateadd(mi,?,TRANSAC_DATE) as TRANSAC_DATE,isNull(bm.BranchCode,'') as BranchCode,luah.DATA as ACC_HEADER,ASSET_NO," +
"isNull(dm.Fullname,'') as DRIVER,isNull(cm.CONDUCTOR_NAME,'') as CLEANER_NAME,BILL_NO,DESCRIPTION,AMOUNT,lu.DATA as TRANSAC_TYPE,(isNull(FILE_NAME,'')+isNull(EXTENSION,'')) as FileName,cb.BRANCH_ID,isNull(APP_REJ_AMOUNT,0) as AppRejAmount " +
"from LMS.dbo.CASH_BOOK cb " +
"inner join LMS.dbo.CCM_LOOKUP lu on lu.SYSTEM_ID=cb.SYSTEM_ID and lu.CUSTOMER_ID=cb.CUSTOMER_ID and lu.TYPE='TransactionType' and lu.ID=cb.TRANSAC_TYPE_ID " +
"inner join Maple.dbo.tblBranchMaster bm on bm.SystemId=cb.SYSTEM_ID and bm.ClientId=cb.CUSTOMER_ID and bm.BranchId=cb.BRANCH_ID " +
"inner join LMS.dbo.CCM_LOOKUP luah on luah.SYSTEM_ID=cb.SYSTEM_ID and luah.CUSTOMER_ID=cb.CUSTOMER_ID and luah.TYPE='AccountHeader' and luah.ID=cb.ACC_HEADER_ID " +
"left outer join AMS.dbo.Driver_Master dm on dm.Driver_id=cb.DRIVER_ID and dm.System_id=cb.SYSTEM_ID and dm.Client_id=cb.CUSTOMER_ID " +
"left outer join AMS.dbo.CONDUCTOR_MASTER cm on cm._ID=cb.CLEANER_ID and cm.SYSTEM_ID=cb.SYSTEM_ID and cm.CLIENT_ID=cb.CUSTOMER_ID " +
"where cb.SYSTEM_ID=? and cb.CUSTOMER_ID=? and cb.STATUS=? and cb.TRANSAC_DATE between dateadd(mi,-?,?) and dateadd(mi,-?,?) and cb.BRANCH_ID=? and cb.REMARKS='CASH_BOOK'";

public static final String APPROVE_CASH_BOOK = "update CASH_BOOK set AMOUNT=?, APP_REJ_AMOUNT=?, UPDATED_BY=?, STATUS=?, UPDATED_DATE=getutcdate() where ID=?";

public static final String CASH_BOOK = "select SYSTEM_ID,CUSTOMER_ID,BRANCH_ID,TRANSAC_TYPE_ID,TRANSAC_DATE,ACC_HEADER_ID,DESCRIPTION,dateadd(mi,?,TRANSAC_DATE) as GPS_TRANSAC_DATE," +
"BILL_NO,ASSET_NO,DRIVER_ID,CLEANER_ID,CREATED_BY,REMARKS,STATUS from LMS.dbo.CASH_BOOK where ID=?";

public static final String APP_REJ_CASH_BOOK_DETAILS = "insert into LMS.dbo.CASH_BOOK (SYSTEM_ID,CUSTOMER_ID,BRANCH_ID,TRANSAC_TYPE_ID,TRANSAC_DATE,AMOUNT,APP_REJ_AMOUNT,ACC_HEADER_ID,DESCRIPTION," +
"BILL_NO,ASSET_NO,DRIVER_ID,CLEANER_ID,CREATED_BY,REMARKS,STATUS,S_ID,UPDATED_BY,UPDATED_DATE) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,getutcdate())";

public static final String GET_PENDING_FUEL_RATE = "select isNull(FuelTypeId,0) as FuelTypeId,isNull(FuelTypeName,'') as FuelCompanyName,isNull(FuelType,'') as FuelType,isNull(STATUS,'') as Status " +
		"from dbo.Fuel_Type_Master where SystemId=? and ClientId=? and AUTHORITY_STATUS=?";

public static final String GET_PENDING_FUEL_RATE_BASED_ON_ID = "Select 'Current' as FT,isNull(vm.VendorName,'') as VendorName,isnull(ftm.Location,'') as Location,isnull(ftm.City,'') as City,isnull(ftm.State,'') as State, " +
		"ftm.FuelTypeName,ftm.FuelPricePerLitre,dateadd(mi,?,ftm.EffectiveFrom) as EffectiveFrom,dateadd(mi,?,ftm.EffectiveTo) as EffectiveTo,ftm.FuelType, AUTHORITY_STATUS " +
		"from Fuel_Type_Master ftm " +
		"left outer join  LMS.dbo.Vendor_Master vm on ftm.SystemId=vm.SystemId and ftm.ClientId=vm.ClientId and ftm.VendorId=vm.VendorId " +
		"where ftm.SystemId=? and ftm.ClientId=? and ftm.FuelTypeId=? " +
		"union " +
		"Select 'Previous' as FT ,isNull(vm.VendorName,'') as VendorName,isnull(ftmh.Location,'') as Location,isnull(ftmh.City,'') as City,isnull(ftmh.State,'') as State,ftmh.FuelTypeName, ftmh.FuelPricePerLitre, " +
		"dateadd(mi,?,ftmh.EffectiveFrom) as EffectiveFrom,dateadd(mi,?,ftmh.EffectiveTo) as EffectiveTo,ftmh.FuelType,AUTHORITY_STATUS  " +
		"from (select top 1 * from Fuel_Type_Master_Hist where SystemId=? and ClientId=? and FuelTypeId=? order by UpdatedDate desc) ftmh " +
		"left outer join  LMS.dbo.Vendor_Master vm on ftmh.SystemId=vm.SystemId and ftmh.ClientId=vm.ClientId and ftmh.VendorId=vm.VendorId " +
		"where ftmh.SystemId=? and ftmh.ClientId=? and ftmh.FuelTypeId=?";

public static final String APPROVE_FUEL_RATE = "update Fuel_Type_Master set AUTHORITY_STATUS='APPROVED' " +
		"where SystemId=? and ClientId=? and FuelTypeId=?";

public static final String GET_TOP_1_FUEL_RATE_BASED_ON_ID = "select top 1 * from Fuel_Type_Master_Hist where SystemId=? and ClientId=? and FuelTypeId=? order by UpdatedDate desc";

public static final String UPDATE_FUEL_RATE_MASTER = "Update Fuel_Type_Master set  FuelTypeName=?, FuelPricePerLitre=?, FuelType=?,VendorId=?, " +
		"EffectiveFrom=?,EffectiveTo=?,UpdatedBy=?,UpdatedDate=getUTCDate(),State=?,City=?,Location=?, STATUS=?,AUTHORITY_STATUS=? "+
		"where  SystemId=? and ClientId=? and FuelTypeId=?";

public static final String INSERT_INTO_FUEL_RATE_HISTORY = "insert into Fuel_Type_Master_Hist(FuelTypeId,FuelTypeName,FuelType,FuelPricePerLitre,VendorId,EffectiveFrom,EffectiveTo," +
		"CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,SystemId,ClientId,Location,City,State,STATUS,AUTHORITY_STATUS) select FuelTypeId,FuelTypeName,FuelType,FuelPricePerLitre,VendorId," +
		"EffectiveFrom,EffectiveTo,CreatedBy,CreatedDate,UpdatedBy,UpdatedDate,SystemId,ClientId,Location,City,State,STATUS,'REJECTED' " +
		"from Fuel_Type_Master where SystemId=? and ClientId=? and FuelTypeId=?";

public static final String DELETE_FUEL_RATE_MASTER = "delete from Fuel_Type_Master where  SystemId=? and ClientId=? and FuelTypeId=?";

public static final String GET_PENDING_BILLING_AND_UNLOADING_DATA = "select isNull(UniqueId,0) as UniqueId,isNull(cip.CustomerName,'') as PrincipalName,isNull(cic.CustomerName,'') as ConsigneeName " +
		"from dbo.Billing_Matrix bm " +
		"inner join Customer_Information cip on cip.SystemId=bm.SystemId and cip.ClientId=bm.ClientId and cip.CustomerId=bm.CustomerName " +
		"inner join Customer_Information cic on cic.SystemId=bm.SystemId and cic.ClientId=bm.ClientId and cic.CustomerId=bm.CONSIGNEE_ID " +
		"where bm.SystemId=? and bm.ClientId=? and bm.BILLING_TYPE=? and bm.AUTHORITY_STATUS=? ";

public static final String GET_PENDING_BILLING_AND_UNLOADING_DETAILS_BASED_ON_ID = "select 'Current' as FT,isNull(Rate,0) as FixedRate,isNull(RATE_PERMT,0) as RatePerDrum, " +
		"isNull(dateadd(mi,?,EffectiveFrom),'') as EffecFrom, isNull(dateadd(mi,?,EffectiveTo),'') as EffecTo " +
		"from dbo.Billing_Matrix " +
		"where SystemId=? and ClientId=? and BILLING_TYPE=? and UniqueId=? " +
		"union " +
		"select 'Previous' as FT,isNull(Rate,0) as FixedRate,isNull(RATE_PERMT,0) as RatePerDrum,isNull(dateadd(mi,?,EffectiveFrom),'') as EffecFrom, isNull(dateadd(mi,?,EffectiveTo),'') as EffecTo " +
		"from (select top 1 * from dbo.Billing_Matrix_History where SystemId=? and ClientId=? and BILLING_TYPE=? and UniqueId=? order by UpdatedDateTime desc) bmh " +
		"where SystemId=? and ClientId=? and BILLING_TYPE=? and UniqueId=?";

public static final String APPROVE_BILLING_AND_UPLOADING_MASTER = "update dbo.Billing_Matrix set AUTHORITY_STATUS='APPROVED' where SystemId=? and ClientId=? and UniqueId=? and BILLING_TYPE=?";

public static final String GET_TOP_1_BILLING_AND_UNLOADING_MASTER_BASED_ON_ID = "select top 1 * from dbo.Billing_Matrix_History where SystemId=? and ClientId=? and UniqueId=? order by UpdatedDateTime desc";

public static final String UPDATE_BILLING_AND_UNLOADING_DETAILS = " update Billing_Matrix set Rate=?,RATE_PERMT=?,EffectiveFrom=?,EffectiveTo=?,AUTHORITY_STATUS=?,UpdateBy=?,UpdatedDateTime=getutcdate() " +
		"where SystemId=? and ClientId=? and UniqueId=? ";

public static final String DELETE_BILLING_AND_UNLOADING_DETAILS = "delete from dbo.Billing_Matrix where SystemId=? and ClientId=? and UniqueId=?";

public static final String GET_PENDING_HSC_MASTER_DETAILS = "select isNull(ID,0) as Id,isNull(ci.CustomerName,'') as CompanyName, isNull(COMPANY_TYPE_ID,'') as CompanyType " +
		"from HSC_MASTER hm " +
		"inner join Customer_Information ci on ci.CustomerId=hm.COMPANY_ID and ci.SystemId=hm.SYSTEM_ID and ci.ClientId=hm.CUSTOMER_ID " +
		"where SYSTEM_ID=? and CUSTOMER_ID=? and hm.AUTHORITY_STATUS=?";

public static final String GET_PENDING_HSC_MASTER_BASED_ON_ID = "select 'Current' as FT,case when LICENCE=1 then 'Y' else 'N' end as LICENCE,case when INSURANCE=1 then 'Y' else 'N' end as INSURANCE," +
		"case when POLLUTION=1 then 'Y' else 'N' end as POLLUTION, case when SHOES=1 then 'Y' else 'N' end as SHOES,case when F_JACKET=1 then 'Y' else 'N' end as F_JACKET," +
		"case when REVERSE_HORN=1 then 'Y' else 'N' end as REVERSE_HORN,case when NO_SMOKING_NO_FIRE=1 then 'Y' else 'N' end as NO_SMOKING_NO_FIRE,case when FITNESS=1 then 'Y' else 'N' end as FITNESS "+
		"from HSC_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? " +
		"union " +
		"select 'Previous' as FT,case when LICENCE=1 then 'Y' else 'N' end as LICENCE,case when INSURANCE=1 then 'Y' else 'N' end as INSURANCE,case when POLLUTION=1 then 'Y' else 'N' end as POLLUTION," +
		"case when SHOES=1 then 'Y' else 'N' end as SHOES,case when F_JACKET=1 then 'Y' else 'N' end as F_JACKET, " +
		"case when REVERSE_HORN=1 then 'Y' else 'N' end as REVERSE_HORN,case when NO_SMOKING_NO_FIRE=1 then 'Y' else 'N' end as NO_SMOKING_NO_FIRE,case when FITNESS=1 then 'Y' else 'N' end as FITNESS "+
		"from HSC_MASTER_HISTORY " +
		"where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

public static final String APPROVE_HSC_MASTER = "update HSC_MASTER set AUTHORITY_STATUS='APPROVED' where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

public static final String GET_HSC_MASTER_BASED_ON_ID = "select * from HSC_MASTER  where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

public static final String UPDATE_HSC_MASTER =  "update HSC_MASTER set COMPANY_ID=?,COMPANY_TYPE_ID=?,LICENCE=?,INSURANCE=?,POLLUTION=?,SHOES=?," +
"F_JACKET=? , AUTHORITY_STATUS =?, UPDATED_BY=?, UPDATED_DATETIME = getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

public static final String DELETE_HSC_MASTER = "delete from dbo.HSC_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

public static final String GET_PENDING_LEAVE_MASTER_DETAILS = "select isNull(ID,0) as Id,isNull(REASON,'') as HolidayName from HOLIDAY_LIST where SYSTEM_ID=? and CUSTOMER_ID=? and AUTHORITY_STATUS=?";

public static final String GET_PENDING_LEAVE_MASTER_BASED_ON_ID = "select 'Current' as FT,isNull(REASON,'') as HolidayName,isNull(dateadd(mi,?,DATE),'') as HolidayDate " +
		"from HOLIDAY_LIST where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? " +
		"union " +
		"select 'Previous' as FT,isNull(REASON,'') as HolidayName,isNull(dateadd(mi,?,DATE),'') as HolidayDate " +
		"from HOLIDAY_LIST_HISTORY where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

public static final String APPROVE_LEAVE_MASTER = "update HOLIDAY_LIST set AUTHORITY_STATUS='APPROVED' where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

public static final String GET_LEAVE_MASTER_BASED_ON_ID = "select * from HOLIDAY_LIST  where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

public static final String UPDATE_LEAVE_MASTER =  "update dbo.HOLIDAY_LIST set DATE=?,REASON=?,AUTHORITY_STATUS=?,UPDATED_BY=?,UPDATED_TIME=getUtcDate() " +
		"where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

public static final String DELETE_LEAVE_MASTER = "delete from HOLIDAY_LIST where SYSTEM_ID=? and CUSTOMER_ID=? and ID=?";

public static final String GET_PENDING_CONDUCTOR_MASTER_DETAILS = "select _ID as Id,isNull(CONDUCTOR_NAME,'') as ConductorName,isNull(ADDRESS,'') as Address,isNull(STATUS,'') as Status " +
		"from CONDUCTOR_MASTER where SYSTEM_ID=? and CLIENT_ID=? and AUTHORITY_STATUS=?";

public static final String GET_PENDING_CONDUCTOR_MASTER_BASED_ON_ID = "select 'Current' as FT,isNull(STATE,'') as State,isNull(PHONE_NO,'') as PhoneNo," +
		"isNull(EMPLOYEE_ID,'') as CleanerId,isNull(SALARY,0) as Salary " +
		"from CONDUCTOR_MASTER where SYSTEM_ID=? and CLIENT_ID=? and _ID=? " +
		"union " +
		"select 'Previous' as FT,isNull(STATE,'') as State,isNull(PHONE_NO,'') as PhoneNo,isNull(EMPLOYEE_ID,'') as CleanerId,isNull(SALARY,0) as Salary " +
		"from CONDUCTOR_MASTER_HISTORY where SYSTEM_ID=? and CLIENT_ID=? and ID=?";

public static final String APPROVE_CONDUCTOR_MASTER = "update CONDUCTOR_MASTER set AUTHORITY_STATUS='APPROVED' where SYSTEM_ID=? and CLIENT_ID=? and _ID=?";

public static final String GET_CONDUCTOR_MASTER_BASED_ON_ID = "select * from CONDUCTOR_MASTER_HISTORY where SYSTEM_ID=? and CLIENT_ID=? and ID=?";

public static final String UPDATE_CONDUCTOR_MASTER =  "update AMS.dbo.CONDUCTOR_MASTER set EMPLOYEE_ID=?,CONDUCTOR_NAME=?,ADDRESS=?,DOB=?,FATHER_NAME=?," +
"NATIONALITY=?,GENDER=?,PHONE_NO=?,COUNTRY=?,STATE=?,CITY=?,OTHERCITY=?,CONTACT_PERSON=?,CONTACT_PERSON_PHNO=?, SALARY=?, AUTHORITY_STATUS=?, UPDATED_BY=?," +
"UPDATED_DATE_TIME=getutcdate(), STATUS=? where SYSTEM_ID=? and CLIENT_ID =? and _ID=?";

public static final String DELETE_CONDUCTOR_MASTER = "delete from CONDUCTOR_MASTER where SYSTEM_ID=? and CLIENT_ID=? and ID=?";
//------------------------------------------------------
public static final String GET_PENDING_TOLL_MODEL_RATE_MASTER_DETAILS = "select ID as Id, isNull(TOLL_NAME,'') as Location,isNull(vm.ModelName,'') as Model " +
		"from LMS.dbo.TOLL_MODEL_ASSOC tma " +
		"inner join TOLL_MASTER tm on tm.TOLL_ID=tma.TOLL_ID " +
		"inner join FMS.dbo.Vehicle_Model vm on tma.MODEL_ID=vm.ModelTypeId " +
		"where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? and AUTHORITY_STATUS=?";

public static final String GET_PENDING_TOLL_MODEL_RATE_MASTER_BASED_ON_ID = "select 'Current' as FT, isNull(TOLL_RATE,'') as TollRate," +
		"dateadd(mi,?,EFFECTIVE_FROM) as EffecFrom,dateadd(mi,?,EFFECTIVE_TO) as EffecTo,isNull(TOLL_ID,0) as TollId,isNull(MODEL_ID,0) as Model " +
		"from TOLL_MODEL_ASSOC where ID=? " +
		"union " +
		"select 'Previous' as FT, isNull(tmh.TOLL_RATE,'') as TollRate,dateadd(mi,?,tmh.EFFECTIVE_FROM) as EffecFrom,dateadd(mi,?,tmh.EFFECTIVE_TO) as EffecTo," +
		"isNull(TOLL_ID,0) as TollId,isNull(MODEL_ID,0) as Model " +
		"from (select top 1 * from TOLL_MODEL_ASSOC_HISTORY where ID=? order by UPDATED_TIME desc) tmh where ID=?";

public static final String APPROVE_TOLL_MODEL_RATE_MASTER = "update TOLL_MODEL_ASSOC set AUTHORITY_STATUS='APPROVED' where ID=?";

public static final String GET_TOP_1_TOLL_MODEL_RATE_MASTER_BASED_ON_ID = "select * from TOLL_MODEL_ASSOC_HISTORY where ID=? order by UPDATED_TIME desc";

public static final String UPDATE_TOLL_MODEL_RATE_MASTER =  "update LMS.dbo.TOLL_MODEL_ASSOC set TOLL_RATE=?,UPDATED_BY=?,EFFECTIVE_FROM=?," +
		"EFFECTIVE_TO=?,UPDATED_TIME=getutcdate(),AUTHORITY_STATUS=? where ID=?";

public static final String DELETE_TOLL_MODEL_RATE_MASTER = "delete from TOLL_MODEL_ASSOC where ID=?";

public static final String UPDATE_TOLL_MODEL_RATE_IN_EXPENSE_MASTER = "update EXPENSE_MASTER set TOLL_FEE=TOLL_FEE-?+? where SYSTEM_ID=? and CUSTOMER_ID=? and MODEL=? and TOLL_IDS like ?";

public static final String GET_PENDING_CUSTOMER_MASTER_DETAILS = "select CustomerId, isNull(CustomerName,'') as CustName,isNull(CompanyName,'') as CmpnyCode,isNull(CustomerType,'') as CustType, " +
		"case when INCLUSIVE_TAX=1 then 'Single' when INCLUSIVE_TAX=2 then 'Multiple' when INCLUSIVE_TAX=0 then '' end as InvType,isNull(STATUS,'') as Status " +
		"from Customer_Information where SystemId=? and ClientId=? and AUTHORITY_STATUS=?";

public static final String GET_PENDING_CUSTOMER_MASTER_BASED_ON_ID = "select 'Current' as FT,isNull(Address,'') as Address,isNull(City,'') as City,isNull(State,'') as State," +
		"isNull(COUNTRY_NAME,'') as COUNTRY_ID,isNull(Factory1,'') as Factory1,isNull(Mobile,'') as Mobile,isNull(EmailId,'') as EmailId,isNull(PhoneNo,'') as PhoneNo," +
		"isNull(ContactPerson,'') as ContactPerson,isNull(ContactPersonPhoneNo,'') as ContactPersonPhoneNo,isNull(PANNumber,'') as PanNo,isNull(TINNumber,'') as TinNo,isNull(TAX_NO,'') as STNo " +
		"from Customer_Information ci " +
		"left outer join ADMINISTRATOR.dbo.COUNTRY_DETAILS cd on cd.COUNTRY_CODE=ci.COUNTRY_ID "+
		"where SystemId=? and ClientId=? and CustomerId=? " +
		"union " +
		"select 'Previous' as FT,isNull(ADDRESS,'') as Address,isNull(CITY,'') as City,isNull(STATE,'') as State,isNull(COUNTRY_NAME,'') as COUNTRY_ID,isNull(FACTORY1,'') as Factory1," +
		"isNull(MOBILE,'') as Mobile,isNull(EMAIL_ID,'') as EmailId,isNull(PHONE_NO,'') as PhoneNo,isNull(CONTACT_PERSON,'') as ContactPerson," +
		"isNull(CONTACT_PERSON_PHONE_NO,'') as ContactPersonPhoneNo,isNull(PAN_Number,'') as PanNo,isNull(TIN_Number,'') as TinNo,isNull(TAX_NO,'') as STNo " +
		"from CUSTOMER_INFORMATION_HISTORY cih " +
		"left outer join ADMINISTRATOR.dbo.COUNTRY_DETAILS cd on cd.COUNTRY_CODE=cih.COUNTRY_ID "+
		"where SYSTEM_ID=? and CLIENT_ID=? and CUSTOMER_ID=?";

public static final String UPDATE_LMSCUSTOMER_MASTER_WITH_CLIENT="update Customer_Information set CustomerName=?,CompanyName=?,COUNTRY_ID = ?,City=?,State=?,CustomerType=?," +
"PaymentType=?,BillingType=?,Address=?,PhoneNo=?,Fax=?,Mobile=?,EmailId=?,ContactPerson=?,ContactPersonPhoneNo=?,Factory1=?,Factory2=?,Factory3=?,Factory4=?,PANNumber=?,TINNumber=?," +
"UpdatedBy=?,UpdatedDateTime=getutcdate(),PhoneNo2=?,Mobile2=?,EmailId2=?,STATUS=?,AUTHORITY_STATUS=?,INVOICE_TARIFF=?,PDA_ACCOUNT_NO=?,TAX_LIABILITY=?,TAX_NO=?,INCLUSIVE_TAX=? " +
"where CustomerId=? and SystemId=? and ClientId=? ";

public static final String APPROVE_CUSTOMER_MASTER = "update Customer_Information set AUTHORITY_STATUS='APPROVED' where CustomerId=?";

public static final String GET_CUSTOMER_MASTER_BASED_ON_ID = "select * from CUSTOMER_INFORMATION_HISTORY where CUSTOMER_ID=?";

public static final String DELETE_CUSTOMER_MASTER = "delete from Customer_Information where CustomerId=?";

public static final String GET_PENDING_EXPENSE_MASTER_DETAILS = "select UID,isNull(ModelName,'') as VehModel,isNull(cip.CustomerName,'') as PrincipalName,isNull(cic.CustomerName,'') as ConsigneeName,isNull(DIESEL_REQ,0) as FuelConsumption " +
		"from EXPENSE_MASTER em " +
		"inner join Customer_Information cip on cip.CustomerId=em.PRINCIPAL_ID and cip.SystemId=em.SYSTEM_ID and cip.ClientId=em.CUSTOMER_ID " +
		"inner join Customer_Information cic on cic.CustomerId=em.CONSIGNEE_ID and cic.SystemId=em.SYSTEM_ID and cic.ClientId=em.CUSTOMER_ID " +
		"inner join FMS.dbo.Vehicle_Model vm on vm.ModelTypeId=em.MODEL and vm.SystemId=em.SYSTEM_ID and vm.ClientId=em.CUSTOMER_ID " +
		"where em.SYSTEM_ID=? and em.CUSTOMER_ID=? and em.AUTHORITY_STATUS=?";

public static final String GET_PENDING_EXPENSE_MASTER_BASED_ON_ID = "select 'Current' as FT,isNull(KMS,0) as Kms, isNull(RTO_FEE,0) as RFee,isNull(BORDER_FEE,0) as BFee,isNull(TOLL_FEE,0) as TFee, isNull(DRIVER_INCENTIVE,0) as DriverIncentive," +
		"isNull(POLICE,0) as Police, isNull(ESCORT,0) as Escort, isNull(LABOUR_CHARGES,0) as LabourCharges, isNull(OTHER_EXPENSES,0) as OthersExp," +
		"(isNull(RTO_FEE,0) + isNull(BORDER_FEE,0) + isNull(TOLL_FEE,0) + isNull(DRIVER_INCENTIVE,0) + isNull(POLICE,0) + isNull(ESCORT,0) + isNull(LABOUR_CHARGES,0) + isNull(OTHER_EXPENSES,0)) as Total " +
		"from EXPENSE_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and UID=? " +
		"union " +
		"select 'Previous' as FT,isNull(KMS,0) as Kms, isNull(RTO_FEE,0) as RFee,isNull(BORDER_FEE,0) as BFee,isNull(TOLL_FEE,0) as TFee, isNull(DRIVER_INCENTIVE,0) as DriverIncentive,isNull(POLICE,0) as Police, " +
		"isNull(ESCORT,0) as Escort, isNull(LABOUR_CHARGES,0) as LabourCharges, isNull(OTHER_EXPENSES,0) as OthersExp," +
		"(isNull(RTO_FEE,0) + isNull(BORDER_FEE,0) + isNull(TOLL_FEE,0) + isNull(DRIVER_INCENTIVE,0) + isNull(POLICE,0) + isNull(ESCORT,0) + isNull(LABOUR_CHARGES,0) + isNull(OTHER_EXPENSES,0)) as Total " +
		"from EXPENSE_MASTER_HISTORY where SYSTEM_ID=? and CUSTOMER_ID=? and UID=?";

public static final String APPROVE_EXPENSE_MASTER = "update EXPENSE_MASTER set AUTHORITY_STATUS='APPROVED' where UID=?";

public static final String GET_EXPENSE_MASTER_BASED_ON_ID = "select * from EXPENSE_MASTER_HISTORY where UID=?";

public static final String UPDATE_EXPENSE_DETAILS = " update EXPENSE_MASTER set KMS=?,DIESEL_REQ=?,RTO_FEE=?,BORDER_FEE=?,TOLL_FEE=?,OTHER_EXPENSES=?," +
" DRIVER_INCENTIVE=?,POLICE=?,ESCORT=?,LOADING=?,OCTROI=?,LABOUR_CHARGES=?,AUTHORITY_STATUS=?,UPDATED_BY=?,UPDATED_DATE=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and UID=?";

public static final String DELETE_EXPENSE_MASTER = "delete from EXPENSE_MASTER where UID=?";

public static final String GET_PENDING_DETENTION_MASTER_DETAILS = "select isNull(dcm.PRINCIPAL_FROM,0) as PrincipalFrom,isNull(DATA,'') as DetentionType,isNull(cip.CustomerName,'') as PrincipalName," +
		"isNull(cic.CustomerName,'') as ConsigneeName,isNull(dcm.PRINCIPAL_ID,0) as PrincipalId,isNull(dcm.CONSIGNEE_ID,0) as ConsigneeId,isNull(dcm.DETENTION_TYPE,0) as DetentionTypeId " +
		"from DETENTION_CHARGES_MASTER dcm " +
		"inner join Customer_Information cip on cip.CustomerId=dcm.PRINCIPAL_ID and cip.SystemId=dcm.SYSTEM_ID and cip.ClientId=dcm.CUSTOMER_ID " +
		"inner join Customer_Information cic on cic.CustomerId=dcm.CONSIGNEE_ID and cic.SystemId=dcm.SYSTEM_ID and cic.ClientId=dcm.CUSTOMER_ID " +
		"inner join CCM_LOOKUP cl on cl.ID=dcm.DETENTION_TYPE and cl.SYSTEM_ID=dcm.SYSTEM_ID and cl.CUSTOMER_ID=dcm.CUSTOMER_ID and cl.TYPE='DetentionType'" +
		"where dcm.SYSTEM_ID=? and dcm.CUSTOMER_ID=? and dcm.AUTHORITY_STATUS=?";

public static final String GET_PENDING_DETENTION_MASTER_BASED_ON_ID = "select 'Current' as FT,isNull(PRINCIPAL_FROM,0) as PrincipalFrom, isNull(PRINCIPAL_TO,0) as PrincipalTo,isNull(PRINCIPAL_CHARGE,0) as PrincipalCost," +
		"isNull(CONSIGNEE_FROM,0) as ConsigneeFrom, isNull(CONSIGNEE_TO,0) as ConsigneeTo,isNull(CONSIGNEE_CHARGE,0) as ConsigneeCost " +
		"from DETENTION_CHARGES_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and PRINCIPAL_FROM=? and PRINCIPAL_ID=? and CONSIGNEE_ID=? and DETENTION_TYPE=? " +
		"union " +
		"select 'Previous' as FT,isNull(PRINCIPAL_FROM,0) as PrincipalFrom, isNull(PRINCIPAL_TO,0) as PrincipalTo,isNull(PRINCIPAL_CHARGE,0) as PrincipalCost,isNull(CONSIGNEE_FROM,0) as ConsigneeFrom, " +
		"isNull(CONSIGNEE_TO,0) as ConsigneeTo,isNull(CONSIGNEE_CHARGE,0) as ConsigneeCost " +
		"from DETENTION_CHARGES_MASTER_HISTORY where SYSTEM_ID=? and CUSTOMER_ID=? and PRINCIPAL_FROM=? and PRINCIPAL_ID=? and CONSIGNEE_ID=? and DETENTION_TYPE=?";

public static final String APPROVE_DETENTION_MASTER = "update DETENTION_CHARGES_MASTER set AUTHORITY_STATUS='APPROVED' " +
		"where SYSTEM_ID=? and CUSTOMER_ID=? and PRINCIPAL_FROM=? and PRINCIPAL_ID=? and CONSIGNEE_ID=? and DETENTION_TYPE=?";

public static final String GET_DETENTION_MASTER_BASED_ON_ID = "select * from DETENTION_CHARGES_MASTER_HISTORY where SYSTEM_ID=? and CUSTOMER_ID=? and PRINCIPAL_FROM=? and PRINCIPAL_ID=? and CONSIGNEE_ID=? and DETENTION_TYPE=?";;

public static final String UPDATE_DETENTION_CHARGES_DETAILS = "update DETENTION_CHARGES_MASTER set PRINCIPAL_CHARGE=?,CONSIGNEE_CHARGE=?,UPDATED_BY=?,AUTHORITY_STATUS=?,UPDATED_DATE=getutcdate() " +
		"where SYSTEM_ID=? and CUSTOMER_ID=? and DETENTION_TYPE=? and PRINCIPAL_ID=? and CONSIGNEE_ID=? and PRINCIPAL_FROM=? ";

public static final String DELETE_DETENTION_MASTER = "delete from DETENTION_CHARGES_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and PRINCIPAL_FROM=? and PRINCIPAL_ID=? and CONSIGNEE_ID=? and DETENTION_TYPE=?";;

public static final String GET_AVAILABLE_FUEL_IN_LAST_TRIP = "select top 1 isNull(AVAIL_FUEL,0) as TripClosingFuel,isNull(AVAIL_FUEL_COST,0) as TripClosingFuelCost, CLOSED_TIME,getutcdate() as CurrentTime, CREATED_TIME,isNull(TRIP_NO,'') as TripNo " +
"from LMS.dbo.TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NO=? and STATUS=? order by CLOSED_TIME desc ";

public static final String GET_NON_TRIP_FILLED_FUEL = "SELECT FuelRequired as NTFilledFuel,Amount FROM LMS.dbo.Fuel_Allocation_Table where SystemId=? and ClientId=? and SubTripId=? and InsertedDate between ? and getutcdate() and AD=1;";

public static final String GET_DISTANCE_CONVERSION_FACTOR_FROM_VEHICLE_TYPE = "select UnitName,ConversionFactor from tblDistanceUnitMaster where UnitId = (select DistanceUnitId from Vehicle_Category_Master where Category_name = ("
	+ "select VehicleType from tblVehicleMaster where System_id=? and VehicleNo=?))";

public static final String SAVE_FUEL_RESET = "insert into FUEL_RESET (SYSTEM_ID,CUSTOMER_ID,ASSET_NO,TRIP_NO,AVAIL_FUEL,AVAIL_FUEL_COST,RESET_FUEL,RESET_FUEL_COST,INSERTED_BY) values(?,?,?,?,?,?,?,?,?)";

public static final String UPDATE_RESET_FUEL_IN_TRIP_DETAILS = "update LMS.dbo.TRIP_DETAILS set AVAIL_FUEL=?,AVAIL_FUEL_COST=?,IS_RESET_FUEL=? where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NO=? and TRIP_NO=?";

public static final String GET_FUEL_RESET_DETAILS = "select isNull(ASSET_NO,'') as AssetNo,isNull(AVAIL_FUEL,0) as AvailFuel,isNull(RESET_FUEL,0) as ResetFuel,isNull(u.Firstname,'') as ResetBy,dateadd(mi,?,INSERTED_TIME) as ResetDate " +
		"from FUEL_RESET fr " +
		"inner join AMS.dbo.Users u on u.System_id=fr.SYSTEM_ID and u.User_id=fr.INSERTED_BY " +
		"where SYSTEM_ID=? and CUSTOMER_ID=? and INSERTED_TIME between dateadd(mi,?,?) and dateadd(mi,?,?)";

public static final String IS_FUEL_RESET = "select * from LMS.dbo.TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and ASSET_NO=? and TRIP_NO=? and IS_RESET_FUEL=?";

public static final String GET_SUMMARY_INVOICE_DETAILS_MULTIPLE = "select isnull(ci.CustomerName,'') as consignee,isnull(sum(td.NO_OF_BARREL),0) as qty,case when isnull(bm.RATE_PERMT,0)= 0 then 'Fixed' else 'Drum Wise' end as billingType," +
	" case when ind.REMARKS='Billing Tariff Invoice' then isnull(sum(ind.BILLING_RATE),0) else isnull(sum(ind.ORIGINAL_BILLING_RATE),0) end as amount,isnull(bm.RATE_PERMT,0) as rate"+
	" from LMS.dbo.INVOICE_DETAILS ind"+
	" left outer join TRIP_DETAILS td on td.UNIQUE_ID=ind.CI_UNIQUE_ID"+
	" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=ind.SYSTEM_ID and ci.ClientId=ind.CUSTOMER_ID and ci.CustomerId=ind.BILLING_CUSTOMER"+
	" left outer join Billing_Matrix bm on bm.SystemId=ind.SYSTEM_ID and bm.ClientId=ind.CUSTOMER_ID and bm.CustomerName=ind.CUSTOMER and bm.CONSIGNEE_ID=ind.BILLING_CUSTOMER and BILLING_TYPE=?"+
	" where ind.SYSTEM_ID=? and ind.CUSTOMER_ID=? and ind.CUSTOMER=? and td.CREATED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and ind.REMARKS = ?"+
	" group by ind.BILLING_CUSTOMER,ci.CustomerName,bm.RATE_PERMT,ind.REMARKS";

public static final String GET_INVOICE_HEADER_DETAILS = "select isnull(DATA,'') as data from CCM_LOOKUP where SYSTEM_ID=? and CUSTOMER_ID=? and TYPE=? order by SEQUENCE";

public static final String GET_INVOICE_NO = "select isNull(INVOICE_NO,0) as invoiceNo from dbo.Latest_Running_GR_No where ClientId=? and SystemId=? and TripType=?";

public static final String IS_PRESENT_INVOICE_NO = "select * from Latest_Running_GR_No where ClientId=? and SystemId=? and TripType=?";

public static final String UPDATE_INVOICE_NO = "update Latest_Running_GR_No set INVOICE_NO=? where ClientId=? and SystemId=? and TripType=?";

public static final String INSERT_INVOICE_NO = "insert into Latest_Running_GR_No (INVOICE_NO,ClientId,SystemId,TripType) values (?,?,?,?)";

public static final String GET_PRINCIPAL_ADDRESS = "select isnull(CustomerName,'') as name,isnull(Address,'') as address from Customer_Information where SystemId=? and ClientId=? and CustomerId=? and STATUS='Active'";

public static final String GET_LEDGER_BAL_OF_PREV_MONTH = "select isNull(LEDGER_BAL,0) as LEDGER_BAL from LMS.dbo.CASH_BOOK_MONTHLY_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and BRANCH_ID=? and " +
	"MONTH=DATEPART(m, DATEADD(m, -1, ?)) and YEAR=DATEPART(YYYY, DATEADD(m, -1, ?))";

public static final String GET_APPROVED_TRANSAC_TILL_START_DATE = "select case when TRANSAC_TYPE_ID = 1 then sum(isNull(AMOUNT,0)) else -sum(isNull(AMOUNT,0)) end as AMOUNT, TRANSAC_TYPE_ID from LMS.dbo.CASH_BOOK " +
	"where SYSTEM_ID=? and CUSTOMER_ID=? and BRANCH_ID=? and dateadd(mi,?,TRANSAC_DATE) > DATEADD(month, DATEDIFF(month, 0, dateadd(mm,0,?)), 0) " +
	"and dateadd(mi,?,TRANSAC_DATE) < ? and STATUS  in ('APPROVED') group by TRANSAC_TYPE_ID";

public static final String GET_APPROVED_TRANSAC_TILL_END_DATE = "select case when TRANSAC_TYPE_ID = 1 then sum(isNull(AMOUNT,0)) else -sum(isNull(AMOUNT,0)) end as AMOUNT, TRANSAC_TYPE_ID from LMS.dbo.CASH_BOOK " +
	"where SYSTEM_ID=? and CUSTOMER_ID=? and BRANCH_ID=? and dateadd(mi,?,TRANSAC_DATE) > DATEADD(month, DATEDIFF(month, 0, dateadd(mm,0,?)), 0) " +
	"and dateadd(mi,?,TRANSAC_DATE) < ? and STATUS  in ('APPROVED') group by TRANSAC_TYPE_ID";

public static final String GET_PRINCIPAL_DETAILS = "select isnull(CustomerId,0) as principalId,isnull(CompanyName,'') as principalName,isnull(INCLUSIVE_TAX,0) as invoiceType " +
						" from LMS.dbo.Customer_Information where SystemId=? and ClientId=? and CustomerType=? and STATUS = 'Active' ";

public static final String GET_SUMMARY_INVOICE_DETAILS_SINGLE = "select isnull(ci.CustomerName,'') as consignee,isnull(sum(td.NO_OF_BARREL),0) as qty," +
	" case when isnull(bm.RATE_PERMT,0)= 0 then 'Fixed' else 'Drum Wise' end as billingType,# as amount,isnull(bm.RATE_PERMT,0) as rate"+
	" from LMS.dbo.INVOICE_DETAILS ind"+
	" left outer join TRIP_DETAILS td on td.UNIQUE_ID=ind.CI_UNIQUE_ID"+
	" left outer join LMS.dbo.Customer_Information ci on ci.SystemId=ind.SYSTEM_ID and ci.ClientId=ind.CUSTOMER_ID and ci.CustomerId=ind.BILLING_CUSTOMER"+
	" left outer join Billing_Matrix bm on bm.SystemId=ind.SYSTEM_ID and bm.ClientId=ind.CUSTOMER_ID and bm.CustomerName=ind.CUSTOMER and bm.CONSIGNEE_ID=ind.BILLING_CUSTOMER and BILLING_TYPE=?"+
	" where ind.SYSTEM_ID=? and ind.CUSTOMER_ID=? and ind.CUSTOMER=? and td.CREATED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?) and ind.REMARKS = ?"+
	" group by ind.BILLING_CUSTOMER,ci.CustomerName,bm.RATE_PERMT,ind.REMARKS";

public static final String GET_ADD_EXP_INVOICE = "select UNIQUE_ID,isNull(FILE_NAME,'') as FILE_NAME,INSERTED_DATE from LMS.dbo.ADDITIONAL_EXPENSES where UNIQUE_ID=?";

}