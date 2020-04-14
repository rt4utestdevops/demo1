package t4u.statements;

public class BillingStatements {

	
	public static final String GET_LTSP="select System_id,System_Name from AMS.dbo.System_Master order by System_Name";
	
	public static final String GET_BILLING_MATRIX_REPORT=" select VehicleNo,CAST(DAY(StartDate) AS VARCHAR(2)) + ' ' + DATENAME(MM, StartDate) + ' ' + CAST(YEAR(StartDate) AS VARCHAR(4)) as StartDate "
		+ " ,CAST(DAY(EndDate) AS VARCHAR(2)) + ' ' + DATENAME(MM, EndDate) + ' ' + CAST(YEAR(EndDate) AS VARCHAR(4)) as EndDate, "
		+ " VehicleId,GroupName,ModelName,UnitNo,CAST(DAY(InstallationDate) AS VARCHAR(2)) + ' ' + DATENAME(MM, InstallationDate) + ' ' + CAST(YEAR(InstallationDate) "
		+ " AS VARCHAR(4)) as installed,'HID ProxPro 5355' as hid,'Yes' as eam, "
		+ " (case when ClientName='NONE' then 'ACCENTURE-Client' else ClientName end) as ClientName ,GpsInstalled, "
		+ " (VehicleDays+NongpsVehicleDays) as noOfDays,VehicleDays as gpsvehicledays,NongpsVehicleDays,PerDayCost,NongpsPerDayCost,TotalCost "
		+ " from Billing.dbo.VehicleWiseBillDetails "
		+ " where InvoiceNo=? and LtspId=? and InsertedDate between ? and dateadd(mm,2,?) "
	    + " union all "
	    + " select VehicleNo,CAST(DAY(StartDate) AS VARCHAR(2)) + ' ' + DATENAME(MM, StartDate) + ' ' + CAST(YEAR(StartDate) AS VARCHAR(4)) as StartDate "
		+ " ,CAST(DAY(EndDate) AS VARCHAR(2)) + ' ' + DATENAME(MM, EndDate) + ' ' + CAST(YEAR(EndDate) AS VARCHAR(4)) as EndDate, "
		+ " VehicleId,GroupName,ModelName,UnitNo,CAST(DAY(InstallationDate) AS VARCHAR(2)) + ' ' + DATENAME(MM, InstallationDate) + ' ' + CAST(YEAR(InstallationDate) "
		+ " AS VARCHAR(4)) as installed,'HID ProxPro 5355' as hid,'Yes' as eam, "
		+ " (case when ClientName='NONE' then 'ACCENTURE-Client' else ClientName end) as ClientName ,GpsInstalled, "
		+ " (VehicleDays+NongpsVehicleDays) as noOfDays,VehicleDays as gpsvehicledays,NongpsVehicleDays,PerDayCost,NongpsPerDayCost,TotalCost "
		+ " from Billing.dbo.VehicleWiseBillDetailsHistory "
		+ " where InvoiceNo=? and LtspId=? and InsertedDate between ? and dateadd(mm,2,?) "
		+ " order by ClientName,VehicleNo asc ";
	
	public static final String GET_INVOICE_NUMBER="select InvoiceNo as INVOICE_NO from Billing.dbo.LtspWiseBillDetails where LtspId=? and BillMonth=? and BillYear=? ";

	
	
	public static final String GET_VERTICAL_WIZE_BILLING_DETAILS=" WITH Temp AS( "
		+ " (select r.VerticalName as VerticalName,sum(r.vehicalCount) as Vehicalcount,sum(r.TotalCost) as Amount from " 
		+ " (select LANG_ENGLISH as VerticalName,count(c.VehicleNo) as vehicalCount,c.VehicleNo,c.TotalCost "
		+ " from Billing.dbo.VehicleWiseBillDetails c "
		+ " inner join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC b on c.LtspId=b.SYSTEM_ID and b.CUSTOMER_ID=c.ClientId " 
		+ " inner join ADMINISTRATOR.dbo.PRODUCT_PROCESS a on a.PROCESS_ID=b.PROCESS_ID " 
		+ " inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION d on d.LABEL_ID=a.PROCESS_LABEL_ID "  
		+ " where c.LtspId=?  and c.InvoiceNo=? and c.InsertedDate between ? and dateadd(mm,1,?) "
		+ " and a.PROCESS_TYPE_LABEL_ID='Vertical_Sol' "
		+ " group by LANG_ENGLISH,c.VehicleNo,c.TotalCost) r " 
		+ " group by r.VerticalName " 
		+ " union all "
		+ " select r.VerticalName as VerticalName,sum(r.vehicalCount) as Vehicalcount,sum(r.TotalCost) as Amount from " 
		+ " (select LANG_ENGLISH as VerticalName,count(c.VehicleNo) as vehicalCount,c.VehicleNo,c.TotalCost " 
		+ " from Billing.dbo.VehicleWiseBillDetailsHistory c " 
		+ " inner join ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC b on c.LtspId=b.SYSTEM_ID and b.CUSTOMER_ID=c.ClientId " 
		+ " inner join ADMINISTRATOR.dbo.PRODUCT_PROCESS a on a.PROCESS_ID=b.PROCESS_ID " 
		+ " inner join ADMINISTRATOR.dbo.LANG_LOCALIZATION d on d.LABEL_ID=a.PROCESS_LABEL_ID "  
		+ " where c.LtspId=?  and c.InvoiceNo=? and c.InsertedDate between ? and dateadd(mm,1,?) "
		+ " and a.PROCESS_TYPE_LABEL_ID='Vertical_Sol' "
		+ " group by LANG_ENGLISH,c.VehicleNo,c.TotalCost) r "
		+ " group by r.VerticalName "
		+ " ) "
		+ " union all "

		+ " select r.VerticalName as VerticalName,sum(r.vehicalCount) as Vehicalcount,sum(r.TotalCost) as Amount from " 
		+ " (select 'OTHERS' as VerticalName,count(c.VehicleNo) as vehicalCount,c.VehicleNo,c.TotalCost "
		+ " from Billing.dbo.VehicleWiseBillDetails c "
		+ " where c.LtspId=?  and c.InvoiceNo=? and c.InsertedDate between ? and dateadd(mm,1,?) and c.ClientId not in (select CUSTOMER_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where PROCESS_ID in (select PROCESS_ID from ADMINISTRATOR.dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Vertical_Sol')) "
		+ " group by c.VehicleNo,c.TotalCost) r "
		+ " group by r.VerticalName "

		+ " union all "
		+ " select r.VerticalName as VerticalName,sum(r.vehicalCount) as Vehicalcount,sum(r.TotalCost) as Amount from " 
		+ " (select 'OTHERS' as VerticalName,count(c.VehicleNo) as vehicalCount,c.VehicleNo,c.TotalCost "
		+ " from Billing.dbo.VehicleWiseBillDetailsHistory c "
		+ " where c.LtspId=?  and c.InvoiceNo=? and c.InsertedDate between ? and dateadd(mm,1,?) and c.ClientId not in (select CUSTOMER_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where PROCESS_ID in (select PROCESS_ID from ADMINISTRATOR.dbo.PRODUCT_PROCESS where PROCESS_TYPE_LABEL_ID='Vertical_Sol')) "
		+ " group by c.VehicleNo,c.TotalCost) r " 
		+ " group by r.VerticalName "
		+ " ) "
		+ " select VerticalName,Vehicalcount,Amount from Temp "
		+ " union all "
		+ " select 'zzzzz' as VerticalName,sum(Vehicalcount) as Vehicalcount,sum (Amount) as Amount from Temp " ;

	public static final String GET_GROUP = " select BILLING_GROUP_NAME,ID from Billing.dbo.VEHICLE_GROUP_BILL_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? ";

	public static final String INSERT_GROUP_DETAILS = " insert into Billing.dbo.VEHICLE_GROUP_BILL_DETAILS (SYSTEM_ID,CUSTOMER_ID,BILLING_GROUP_ADDRESS,BILLING_GROUP_NAME,INSERTED_DATETIME) values (?,?,?,?,getutcdate()) ";

//	public static final String GET_DATA_FOR_NON_ASSOCIATION = " select vc.GROUP_ID,GROUP_NAME,REGISTRATION_NUMBER from AMS.dbo.VEHICLE_CLIENT vc " +
//		" inner join AMS.dbo.VEHICLE_GROUP vg on vg.GROUP_ID=vc.GROUP_ID " +
//		" where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and REGISTRATION_NUMBER not in (select REGISTRATION_NO collate database_default from billing.dbo.BILL_VEHICLE_GROUP_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=?)";

	public static final String GET_DATA_FOR_NON_ASSOCIATION = " select isnull(vg.GROUP_ID,0) as GROUP_ID,isnull(GROUP_NAME,'NONE') as GROUP_NAME,VehicleNo as REGISTRATION_NUMBER from AMS.dbo.VMIS vc (NOLOCK) "+
															  " left outer join AMS.dbo.VEHICLE_GROUP vg (NOLOCK) on vg.GROUP_ID=vc.Group_Id "+ 
															  " where vc.Date between dateadd(mm,-2,getdate()) and getdate() and vc.SystemId=? and vc.Customer_Id=? "+
															  " and VehicleNo not in (select REGISTRATION_NO collate database_default from billing.dbo.BILL_VEHICLE_GROUP_ASSOCIATION (NOLOCK) where SYSTEM_ID=? and CUSTOMER_ID=?) "+
															  " group by VehicleNo,vg.GROUP_ID,GROUP_NAME ";
	
//	public static final String GET_DATA_FOR_ASSOCIATION = " select vg.GROUP_NAME,REGISTRATION_NO from billing.dbo.BILL_VEHICLE_GROUP_ASSOCIATION vga " +
//		" inner join AMS.dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=vga.REGISTRATION_NO collate database_default "+
//		" inner join  AMS.dbo.VEHICLE_GROUP vg on vg.GROUP_ID=vc.GROUP_ID "+
//		" where vga.SYSTEM_ID=? AND vga.CUSTOMER_ID=? and vga.BILL_GROUP_ID=? ";
	
	public static final String GET_DATA_FOR_ASSOCIATION = " select vg.GROUP_NAME,REGISTRATION_NO,VehicleNo from billing.dbo.BILL_VEHICLE_GROUP_ASSOCIATION vga (NOLOCK) "+ 
														  " left outer join AMS.dbo.VMIS vc (NOLOCK) on vc.VehicleNo=vga.REGISTRATION_NO collate database_default "+
														  " left outer join AMS.dbo.VEHICLE_GROUP vg (NOLOCK) on vg.GROUP_ID=vc.Group_Id "+ 	 
														  " where vga.SYSTEM_ID=? AND vga.CUSTOMER_ID=? and vga.BILL_GROUP_ID=? and SystemId=vga.SYSTEM_ID and vc.Date between dateadd(mm,-2,getdate()) and getdate() "+
														  " group by REGISTRATION_NO,VehicleNo,GROUP_NAME ";

	public static final String CHECK_IF_PRESENT = " select * from billing.dbo.BILL_VEHICLE_GROUP_ASSOCIATION where SYSTEM_ID=? AND CUSTOMER_ID=? and BILL_GROUP_ID=? and REGISTRATION_NO=?" ;

	public static final String MOVE_DATA_TO_VEHICLE_GROUP_HISTORY = " insert into billing.dbo.BILL_VEHICLE_GROUP_DISASSOCIATION (ID,BILL_GROUP_ID,SYSTEM_ID,CUSTOMER_ID,INSERTED_DATETIME,DISASSOCIATED_TIME,REGISTRATION_NO)" +
	" SELECT ID,BILL_GROUP_ID,SYSTEM_ID,CUSTOMER_ID,INSERTED_DATETIME,getutcdate(),REGISTRATION_NO from billing.dbo.BILL_VEHICLE_GROUP_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? AND BILL_GROUP_ID=? AND REGISTRATION_NO=? " ;
	
	public static final String DELETE_FROM_VEHICLE_GROUP = " delete from billing.dbo.BILL_VEHICLE_GROUP_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? AND BILL_GROUP_ID=? AND REGISTRATION_NO=? ";

	public static final String INSERT_INTO_VEHICLE_GROUP_ASSOCIATION = " insert into billing.dbo.BILL_VEHICLE_GROUP_ASSOCIATION (BILL_GROUP_ID,SYSTEM_ID,CUSTOMER_ID,REGISTRATION_NO,INSERTED_DATETIME) values (?,?,?,?,getutcdate())";

	
}
