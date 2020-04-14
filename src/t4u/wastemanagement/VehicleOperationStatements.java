package t4u.wastemanagement;

public class VehicleOperationStatements {

	public static final String GET_VEHICLE_NO = " select isnull(c.VehicleNo,'') as VehicleNo,isnull(c.VehicleType,'') as AssetType,isnull(hl.DRIVER_NAME,'')as DriverName ,isnull(hl.DRIVER_MOBILE,'')as DriverContactNo   " +
												" from  AMS.dbo.tblVehicleMaster (NOLOCK) c  " +    
    										    " inner join AMS.dbo.gpsdata_history_latest hl (NOLOCK) on hl.REGISTRATION_NO=c.VehicleNo and hl.System_id=c.System_id " +
    										    " inner join AMS.dbo.Vehicle_User vu (NOLOCK) on c.VehicleNo=vu.Registration_no and c.System_id=vu.System_id  " + 
    										    " left join AMS.dbo.ASSET_OPERATION_DETAILS d on c.VehicleNo = d.ASSET_NUMBER  "+
											    " where c.System_id=? and hl.CLIENTID=? and vu.User_id=? and c.Status='Active' and d.ASSET_NUMBER is null order by c.VehicleNo " ;
											    
	public static final String INSERT_VEHICLE_DETAILS = " insert into AMS.dbo.ASSET_OPERATION_DETAILS (ASSET_NUMBER,ASSET_TYPE,DRIVER_NAME,DRIVER_MOBILE_NUMBER,DISTRICT, DEPARTMENT,GOVERNATE,DEPT_OFFICE_NUMBER,DEPT_SUPERVISOR, CONTRACTOR,DEPT_MANAGER,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME) " + 
														" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,getUtcDate())" ;
	
	public static final String UPDATE_VEHICLE_DETAILS = " update AMS.dbo.ASSET_OPERATION_DETAILS set ASSET_NUMBER=?,ASSET_TYPE=?,DRIVER_NAME=?,DRIVER_MOBILE_NUMBER=?,DISTRICT=?,DEPARTMENT=?,GOVERNATE=?,DEPT_OFFICE_NUMBER=?,DEPT_SUPERVISOR=?,CONTRACTOR=?,DEPT_MANAGER=? , " +
														" UPDATED_BY = ?,UPDATED_DATETIME=getUtcDate() where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";
	
	public static final String GET_VEHICLE_DETAILS = " select ASSET_NUMBER,ASSET_TYPE,DRIVER_NAME,DRIVER_MOBILE_NUMBER,DISTRICT,DEPARTMENT,GOVERNATE,DEPT_OFFICE_NUMBER,DEPT_SUPERVISOR,CONTRACTOR,DEPT_MANAGER,ID from AMS.dbo.ASSET_OPERATION_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? " ;
	
	public static final String CHECK_VEHICLE_NO = " select ASSET_NUMBER from AMS.dbo.ASSET_OPERATION_DETAILS where SYSTEM_ID=? and ASSET_NUMBER=? " ;
	
}
