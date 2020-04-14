package t4u.statements;

/**
 * 
 * This class is used to write admin module sql statements
 *
 */
public class SccStatements {
	public static final String CHECK_FOR_EXISTENCE="SELECT UID FROM SCC_UNIT_ASSOC WHERE UPPER(UID)=?";
	
	public static final String INSERT_INTO_SCC_UNIT_ASSOC="INSERT INTO SCC_UNIT_ASSOC(UID,UNIT_NO,INTERVAL,ASSOCIATED_BY,SYSTEM_ID,CLIENT_ID,REMARKS,ASSOCIATED_DATE) VALUES (?,?,?,?,?,?,?,GETUTCDATE())";
	
	public static final String UPDATE_SCC_UNIT_ASSOC="UPDATE SCC_MASTER SET INTERVAL=?,REMARKS=?,MODIFIED_BY=?,UNIT_NO=?,MODIFIED_DATE=GETUTCDATE() WHERE UID=? AND SYSTEM_ID=? AND CLIENT_ID=?";
	
	public static final String GET_VEHICLE_MOBILE_NUM= "select REGISTRATION_NO,isnull(b.MOBILE_NUMBER,'')as MOBILE_NUMBER from AMS.dbo.gpsdata_history_latest inner join ADMINISTRATOR.dbo.UNIT_MASTER b on UNIT_NO=UNIT_NUMBER  collate database_default where UNIT_NUMBER= ?";
	
	public static final String DELETE_SCC_DATA_OUT="delete from Data_Out_SCC where DEVICE_ID=? and PACKET_PARAMS!='success' and PACKET_TYPE like 'SCC_%' ";
	
	public static final String GET_SCC_MASTER_DATA=" select s.UNIT_NO,s.UID,Registration_no,ISNULL(BT_MAC_ADDRESS,'') as BT_MAC_ADDRESS,INTERVAL,ASSOCIATED_DATE,"+
	  " MODIFIED_DATE,ISNULL(REMARKS,'') AS REMARKS,(isnull(u.Firstname,'')+' '+isnull(u.Lastname,'')) as ASSOCIATED_BY, "+
	  " (isnull(um.Firstname,'')+' '+isnull(um.Lastname,'')) as MODIFIED_BY from dbo.SCC_UNIT_ASSOC s "+ 
      " inner join dbo.Vehicle_association v on s.UNIT_NO=v.Unit_Number  "+
	  " left outer join AMS.dbo.Users u on s.ASSOCIATED_BY=u.User_id and s.SYSTEM_ID = u.System_id "+
	  " left outer join AMS.dbo.Users um on s.MODIFIED_BY=um.User_id and s.SYSTEM_ID = um.System_id "+
	  " where s.SYSTEM_ID=? and s.CLIENT_ID=? and Registration_no in ((select Registration_no from AMS.dbo.Vehicle_User where User_id = ? and System_id = ?))ORDER BY s.UID";
	  
	public static final String MOVE_TO_HISTORY= " INSERT INTO SCC_UNIT_ASSOC_HISTORY(SLNO,UNIT_NO,UID,BT_MAC_ADDRESS,INTERVAL,ASSOCIATED_DATE,MODIFIED_DATE,ASSOCIATED_BY,MODIFIED_BY,SYSTEM_ID,CLIENT_ID,FW_VERSION,NAME_STATUS) "+
	  " SELECT SLNO,UNIT_NO,UID,BT_MAC_ADDRESS,INTERVAL,ASSOCIATED_DATE,MODIFIED_DATE,ASSOCIATED_BY,MODIFIED_BY,SYSTEM_ID,CLIENT_ID,FW_VERSION,NAME_STATUS FROM SCC_UNIT_ASSOC WHERE UID=? AND UNIT_NO=? AND SYSTEM_ID=? AND CLIENT_ID=?";

	  
	public static final String DELETE_FROM_SCC_MASTER="DELETE FROM SCC_MASTER WHERE UID=? AND UNIT_NO=? AND SYSTEM_ID=? AND CLIENT_ID=? ";
	
	public static final String MOVE_TO_HISTORY_MASTER= " insert into SCC_MASTER_HISTORY select * from SCC_MASTER WHERE UID=? AND UNIT_NO=? AND SYSTEM_ID=? AND CLIENT_ID=?";

	  
	public static final String DELETE_FROM_SCC_UNIT_ASSOC="DELETE FROM SCC_UNIT_ASSOC WHERE UID=? AND UNIT_NO=? AND SYSTEM_ID=? AND CLIENT_ID=? ";
	  
	public static final String GET_UNIT_NUMBERS_FOR_SCC_MASTER=" select a.UNIT_NUMBER,a.UNIT_REFERENCE_ID,isnull(b.UNIT_NAME,'') as Unit_type_desc,isnull(c.MANUFACTURE_NAME,'') as Manufacture_name "+
			" from ADMINISTRATOR.dbo.UNIT_MASTER (NOLOCK) a "+
			" left outer join ADMINISTRATOR.dbo.UNIT_TYPE (NOLOCK) b on a.UNIT_TYPE_CODE=b.UNIT_TYPE_CODE  "+
			" left outer join ADMINISTRATOR.dbo.UNIT_MANUFACTURE (NOLOCK) c on a.MANUFACTURE_ID=c.MANUFACTURE_ID  "+
			" where a.SYSTEM_ID=? and a.STATUS='ACTIVE' and UNIT_NUMBER collate database_default in  "+
			" (select Unit_Number from AMS.dbo.Vehicle_association (NOLOCK) where System_id=? and Client_id=? and Registration_no in (select Registration_no from AMS.dbo.Vehicle_User where User_id = ? and System_id = ?))  "+
			" and UNIT_NUMBER collate database_default not in (select UNIT_NO from dbo.SCC_UNIT_ASSOC where SYSTEM_ID=? and CLIENT_ID=?) ";
	
	  public static final String GET_VEHICLE_NUMBERS_FOR_SCC_MASTER = " Select REGISTRATION_NO as VehicleNo from AMS.dbo.gpsdata_history_latest gps inner join SCC_UNIT_ASSOC ua on  gps.UNIT_NO=ua.UNIT_NO where System_id = ? and CLIENTID = ? and REGISTRATION_NO in (select Registration_no from AMS.dbo.Vehicle_User where User_id = ? and System_id = ? )  order by REGISTRATION_NO " ;

	  public static final String GET_OTP_DETAILS =  "select top 15 * from " +
	  		" (select GENERATED_DATE,ID,UNIT_NO,UID,OTP,USED_DATETIME,OTP_TYPE, case OTP_STATUS  when 1 then 'AVAILABLE' when 2 then 'MOBILE' when 3 then 'USED' else 'NA' end as OTP_STATUS  from  AMS.dbo.SCC_OTP_DETAILS   where UNIT_NO in ( select UNIT_NO from AMS.dbo.gpsdata_history_latest where System_id = ? and CLIENTID = ? and REGISTRATION_NO =? ) and OTP_TYPE in ('UNLOCK') and OTP_STATUS in (1,2,3) " +
	  		" union all "+
	  		" select GENERATED_DATE,ID,UNIT_NO,UID,OTP,USED_DATETIME,OTP_TYPE, case OTP_STATUS  when 1 then 'AVAILABLE' when 2 then 'MOBILE' when 3 then 'USED' else 'NA' end as OTP_STATUS from AMS.dbo.SCC_OTP_DETAILS_HISTORY  where UNIT_NO in ( select UNIT_NO from AMS.dbo.gpsdata_history_latest where System_id = ? and CLIENTID = ? and REGISTRATION_NO =? ) and OTP_TYPE in ('LOCK','UNLOCK') ) a order by GENERATED_DATE desc";
	  
	  public static final String GET_OTP_DETAILS_LOCK = "select GENERATED_DATE,ID,UNIT_NO,UID,OTP,USED_DATETIME,OTP_TYPE, case OTP_STATUS  when 1 then 'AVAILABLE' when 2 then 'MOBILE' when 3 then 'USED' else 'NA' end as OTP_STATUS  from  AMS.dbo.SCC_OTP_DETAILS   where UNIT_NO in ( select UNIT_NO from AMS.dbo.gpsdata_history_latest where System_id = ? and CLIENTID = ? and REGISTRATION_NO =? ) and OTP_TYPE in ('LOCK') and OTP_STATUS in (1,2,3) ";
	 
	  public static final String LOCK_UNLOCK_COUNT = " select isnull( SCC_LK_COUNT,0) as LOCK_COUNT , isnull( SCC_UK_COUNT,0) as UNLOCK_COUNT  from dbo.SCC_MASTER where SYSTEM_ID = ? and CLIENT_ID = ? and UNIT_NO = ( select UNIT_NO from AMS.dbo.gpsdata_history_latest where System_id = ? and CLIENTID = ? and REGISTRATION_NO =?  )  ";
	  
	  public static String GET_MAX_PACKET_NO_SCC="select CASE when MAX(PACKET_NO)=0 then 1 else MAX(PACKET_NO)+1 end as PACKET_NO from Data_Out_SCC";
	  
	  public static String INSERT_OTA_DETAILS_SCC="insert into Data_Out_SCC(PACKET_NO,DEVICE_ID,PACKET_TYPE,PACKET_MODE,PACKET_PARAMS,INSERTED_DATETIME,STATUS,UNIT_TYPE,IP_ADDRESS,MOBILE_NUMBER) values (?,?,?,?,?,getUTCDATE(),?,?,?,?)";
}


