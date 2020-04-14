package t4u.statements;

public class UnitMessageUnionStatements 
{

	public static final String Get_ASSET_NUMBER_LIST="select gps.REGISTRATION_NO as ASSET_NUMBER from gpsdata_history_latest gps "+
	"left outer join Vehicle_association va on gps.REGISTRATION_NO = va.Registration_no "+
	"inner join dbo.Vehicle_User vu on vu.Registration_no=gps.REGISTRATION_NO  "+
	"inner join dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=gps.REGISTRATION_NO "+
	"inner join dbo.VEHICLE_GROUP vg on vg.GROUP_ID = vc.GROUP_ID "+
	"and gps.System_id = va.System_id "+
	"and gps.CLIENTID=va.Client_id where va.System_id = ? and va.Client_id=?  and vu.User_id=?  and Unit_Type_Code in (select Unit_type_code from Unit_Type_Master where Manufacture_code=7) order by gps.REGISTRATION_NO ";
		
	public static final String GET_VEHICLE_MESSAGE_UNION_INFO = " select REGISTRATION_NO,MESSAGE_TYPE,COMPORT,PURPOSE,ID from ADMINISTRATOR.dbo.VEHICLE_MESSAGE_UNION vm " +
			" left outer join Vehicle_association va on vm.REGISTRATION_NO = va.Registration_no collate database_default " +
			" inner join dbo.Vehicle_User vu on vu.Registration_no=vm.REGISTRATION_NO  collate database_default " +
			" inner join dbo.VEHICLE_CLIENT vc on vc.REGISTRATION_NUMBER=vm.REGISTRATION_NO collate database_default " +
			" inner join dbo.VEHICLE_GROUP vg on vg.GROUP_ID = vc.GROUP_ID and vm.SYSTEM_ID = va.System_id and vm.CUSTOMER_ID=va.Client_id " +
			" where va.System_id = ? and va.Client_id=?  and vu.User_id=? order by vm.REGISTRATION_NO";
	
	 public static final String GET_VEHICLE_MESSAGE_UNION_INFO_REG = " select REGISTRATION_NO,MESSAGE_TYPE,COMPORT,PURPOSE,ID from ADMINISTRATOR.dbo.VEHICLE_MESSAGE_UNION where REGISTRATION_NO=?";
	  
	  public static final String GET_TYPE_SETTING = "select VALUE from dbo.LOOKUP_DETAILS where VERTICAL=? order by ORDER_OF_DISPLAY";
	  
	  public static final String IS_UNION_PRESENT ="select * from ADMINISTRATOR.dbo.VEHICLE_MESSAGE_UNION where REGISTRATION_NO=? and MESSAGE_TYPE=? and COMPORT=? ";
	  
	  public static final String INSERT_UNIT_MSG_UNION="insert into ADMINISTRATOR.dbo.VEHICLE_MESSAGE_UNION(REGISTRATION_NO,MESSAGE_TYPE,COMPORT,PURPOSE,SYSTEM_ID,CUSTOMER_ID,INSERTED_USER_ID,INSERTED_GMT)values(?,?,?,?,?,?,?,getutcdate())";
	  
	  public static final String DELETE_UNIT_MSG_UNION="delete from ADMINISTRATOR.dbo.VEHICLE_MESSAGE_UNION where REGISTRATION_NO=? and MESSAGE_TYPE=? and ID=?";
	  
	  public static final String UPDATE_USER_UNIT_MSG_UNION="update ADMINISTRATOR.dbo.VEHICLE_MESSAGE_UNION set UPDATED_USER_ID=?,UPDATED_GMT=getutcdate() where REGISTRATION_NO=? and ID=?";
	  
	  public static final String INS_HIST_UNIT_MSG_UNION="insert into ADMINISTRATOR.dbo.VEHICLE_MESSAGE_UNION_HISTORY select * from ADMINISTRATOR.dbo.VEHICLE_MESSAGE_UNION where REGISTRATION_NO=? and ID=?";
	  
	  public static final String IS_UNION_UPDATE_PRESENT ="select * from ADMINISTRATOR.dbo.VEHICLE_MESSAGE_UNION where REGISTRATION_NO=? and ID=?";
	  
	  public static final String UPDATE_UNION_MSG ="update ADMINISTRATOR.dbo.VEHICLE_MESSAGE_UNION set MESSAGE_TYPE=?,COMPORT=?,PURPOSE=?,UPDATED_USER_ID=?,UPDATED_GMT=getutcdate() where REGISTRATION_NO=? and SYSTEM_ID=? and ID=?";
}
