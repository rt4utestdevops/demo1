package t4u.statements;

public class SelfDriveStatements {
  //------------------------------------------------------Hub Maintenance Report Statements -----------------------------------------------------------//

  public static final String GET_HUB_LIST="select GROUP_NAME as hub_name,GROUP_ID  as hub_id from ADMINISTRATOR.dbo.ASSET_GROUP where SYSTEM_ID=? and CUSTOMER_ID=? order by GROUP_NAME";

  public static final String  GET_VHICLE_NO="select vc.REGISTRATION_NUMBER as VehicleNo ,ag.GROUP_ID as Hub_id from AMS.dbo.VEHICLE_CLIENT vc " + 
  "inner join  ADMINISTRATOR.dbo.ASSET_GROUP ag on vc.SYSTEM_ID=ag.SYSTEM_ID and ag.CUSTOMER_ID=vc.CLIENT_ID " +
  "and ag.GROUP_ID=vc.GROUP_ID " +
  "where vc.SYSTEM_ID=? and vc.CLIENT_ID=? and ag.GROUP_ID=? ";
  
  //------------------------------------------------------PromoCode Management Statements -----------------------------------------------------------//
  
  public static final String GET_ASSET_MODEL="select isnull(ModelTypeId,0) as ModelTypeId ,isnull(ModelName,'') as ModelName " +
	"from  FMS.dbo.Vehicle_Model  where  SystemId=? and ClientId=? order by ModelName ";
  
  public static final String GET_CAR_MODEL_NAME="select isnull(ModelName,'') as ModelName "+
  "from  FMS.dbo.Vehicle_Model  where  SystemId=? and ClientId=? and ModelTypeId=? order by ModelName ";

  public static final String GET_HUB_NAME="select GROUP_NAME as HUB_NAME from ADMINISTRATOR.dbo.ASSET_GROUP "+
  "where SYSTEM_ID=? and CUSTOMER_ID=? and GROUP_ID=? order by GROUP_NAME ";

}
