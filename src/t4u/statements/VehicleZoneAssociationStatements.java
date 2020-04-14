/**
 * 
 */
package t4u.statements;

/**
 * @author praveen.j
 *
 */
public class VehicleZoneAssociationStatements {
	
	/*public static final String GETVEHICLEZONEASSOCATION_DETAILS="SELECT ID,VEHICLE_NO,VEHICLE_GROUP,ZONE_NAME,CREATED_BY,CREATED_TIME  FROM dbo.VEHICLE_ZONE_ASSOCIATION "+
																 "WHERE SYSTEM_ID=?  AND CUSTOMER_ID=? ";
*/	
	public static final String GETVEHICLEZONEASSOCATION_DETAILS="SELECT vz.ID,vz.VEHICLE_NO,vz.VEHICLE_GROUP,lz.NAME as ZONE_NAME,vz.ZONE_OR_HUB_ID,vz.CREATED_BY,vz.CREATED_TIME FROM dbo.VEHICLE_ZONE_ASSOCIATION  vz "+
									"left outer join LOCATION_ZONE_A lz on lz.SYSTEMID=vz.SYSTEM_ID and lz.HUBID=vz.ZONE_OR_HUB_ID WHERE vz.SYSTEM_ID=?  AND vz.CUSTOMER_ID=? and lz.OPERATION_ID=22";
	
	public static final String GET_VEHILCE_NUMBER_FOR_TRIP_DETAILS_WITH_DATE="select vc.REGISTRATION_NUMBER,a.GROUP_NAME,(select top 1 OPENING_ODOMETER from AMS.dbo.CVS_TRIP_DETAILS where SYSTEM_ID=vc.SYSTEM_ID and CUSTOMER_ID=vc.CLIENT_ID and ASSET_NUMBER=vc.REGISTRATION_NUMBER order by TRIP_START_TIME desc) as OPENING_ODOMETER from dbo.VEHICLE_CLIENT vc " +
	"left outer join ADMINISTRATOR.dbo.ASSET_GROUP a on vc.SYSTEM_ID=a.SYSTEM_ID and vc.CLIENT_ID=a.CUSTOMER_ID and vc.GROUP_ID=a.GROUP_ID  " +
	"left outer join dbo.Vehicle_User vu on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER=vu.Registration_no  " +
	"left outer join dbo.tblVehicleMaster vm on vc.SYSTEM_ID=vm.System_id and vc.REGISTRATION_NUMBER=vm.VehicleNo  " +
	"left outer join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on vc.SYSTEM_ID=b.SYSTEM_ID and b.GROUP_ID=a.GROUP_ID and vu.User_id=b.USER_ID  " +
	"where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? and REGISTRATION_NUMBER not in " +
	"(select ASSET_NUMBER from CVS_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and TRIP_START_TIME =?) order by vc.REGISTRATION_NUMBER ";

	public static final String GET_VEHILCE_MARKET_NUMBER_FOR_TRIP_DETAILS="select isnull(ASSET_NUMBER,'')as ASSET_NUMBER,isnull(OPENING_ODOMETER,0)as OPENING_ODOMETER from AMS.dbo.CVS_TRIP_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Open' order by TRIP_START_TIME desc";
	
	public static final String GET_VEHILCE_NUMBER_FOR_TRIP_DETAILS=" select vc.REGISTRATION_NUMBER,a.GROUP_NAME,(select top 1 OPENING_ODOMETER from AMS.dbo.CVS_TRIP_DETAILS where SYSTEM_ID=vc.SYSTEM_ID and CUSTOMER_ID=vc.CLIENT_ID and ASSET_NUMBER=vc.REGISTRATION_NUMBER order by TRIP_START_TIME desc) as OPENING_ODOMETER from dbo.VEHICLE_CLIENT vc " +
	"left outer join ADMINISTRATOR.dbo.ASSET_GROUP a on vc.SYSTEM_ID=a.SYSTEM_ID and vc.CLIENT_ID=a.CUSTOMER_ID and vc.GROUP_ID=a.GROUP_ID " +
	"left outer join dbo.Vehicle_User vu on vc.SYSTEM_ID=vu.System_id and vc.REGISTRATION_NUMBER=vu.Registration_no " +
	"left outer join dbo.tblVehicleMaster vm on vc.SYSTEM_ID=vm.System_id and vc.REGISTRATION_NUMBER=vm.VehicleNo " +
	"left outer join ADMINISTRATOR.dbo.USER_ASSET_GROUP_ASSOCIATION b on vc.SYSTEM_ID=b.SYSTEM_ID and b.GROUP_ID=a.GROUP_ID and vu.User_id=b.USER_ID " +
	"where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and vu.User_id=? order by vc.REGISTRATION_NUMBER ";
	
	
	public static final String GET_ZONE_HUBID="SELECT NAME as ZONE_NAME,HUBID  from LOCATION WHERE SYSTEMID = ?  AND CLIENTID = ? and  OPERATION_ID=22";
	
	public static final String CHECK_VEHICLE_ZONE_ALREADY_EXIST = " select * from AMS.dbo.VEHICLE_ZONE_ASSOCIATION  where VEHICLE_NO = ? and  CUSTOMER_ID = ? and SYSTEM_ID = ? and ZONE_OR_HUB_ID = ? ";
	
	public static final String ADD_VEHICLE_ZONE="INSERT INTO [AMS].[dbo].[VEHICLE_ZONE_ASSOCIATION] "+
	                         "([SYSTEM_ID],[CUSTOMER_ID],[VEHICLE_NO],[VEHICLE_GROUP],[ZONE_OR_HUB_ID],[ZONE_NAME],[CREATED_BY],[CREATED_TIME]) "+
	                          " VALUES(?,?,?,?,?,?,?,getUtcdate())";
	
	public static final String UPDATE_VEHICL_ZONE="UPDATE [AMS].[dbo].[VEHICLE_ZONE_ASSOCIATION] "+  
								"SET [ZONE_OR_HUB_ID] = ? ,[ZONE_NAME] = ? ,[UPDATED_BY] = ? ,[UPDATED_TIME] =getUtcdate()"+ 
								"WHERE [VEHICLE_NO] = ? and [VEHICLE_GROUP] = ? and [SYSTEM_ID] = ?  and [CUSTOMER_ID] = ? and [ID]=? ";
		}
