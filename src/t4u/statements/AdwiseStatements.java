package t4u.statements;

public class AdwiseStatements {
	public static final String GET_UID="select UID ,IMEI_NO  from ADWISE.dbo.SITE_MASTER where MONITORING='yes' and VENDOR_NAME='Atlanta'";
	public static final String INSERT_DETAILS="insert into AMS.dbo.Data_Out(PACKET_NO,DEVICE_ID,PACKET_TYPE,PACKET_MODE,PACKET_PARAMS,INSERTED_DATETIME,STATUS,FLAG,UNIT_TYPE)"
								+"values(?,?,?,?,?,getUtcDate(),?,?,?)";
	public static final String GET_DETAILS="select a.UNIT_NO,a.ATTR,a.DESCR,dateadd(mi, CAST(left(OFFSET,charindex(':',OFFSET)-1) AS INT)*60+CAST(right(OFFSET,charindex(':',OFFSET)) AS INT),a.UPDATED_GMT) as UPDATED_GPSTIME,b.POWER,isNull(b.MAIN_BATTERY_VOLTAGE,'') as MAIN_BATTERY_VOLTAGE,b.IB_VOLTAGE,b.GPS_DATETIME " +
			"from AMS.dbo.ADWISE_CAM_DET a " +
			"inner join AMS.dbo.gpsdata_history_latest b on a.UNIT_NO = b.UNIT_NO where a.UNIT_NO =? ";
	public static final String GET_MAX_PACKET="select max(PACKET_NO) from AMS.dbo.Data_Out ";
	public static final String GET_PACKET_PARAMS="select PACKET_NO,PACKET_PARAMS from AMS.dbo.Data_Out where DEVICE_ID=? and PACKET_PARAMS!='success' and PACKET_TYPE like 'CAM_%'";
	public static final String INSERT_INTO_HISTORY="insert into Data_Out_History select * from Data_Out where DEVICE_ID=? and PACKET_TYPE=? and UNIT_TYPE= ?";
			//"insert into AMS.dbo.Data_Out_History(PACKET_NO,DEVICE_ID,PACKET_TYPE,PACKET_MODE,PACKET_PARAMS,INSERTED_DATETIME,STATUS,FLAG,UNIT_TYPE)"
	//+"values(?,?,?,?,?,?,?,?,?)";
	
	public static final String DELETE_FROM_DATA_OUT="Delete from  AMS.dbo.Data_Out where DEVICE_ID=? and PACKET_PARAMS='success' and PACKET_TYPE=? and UNIT_TYPE=?";
	public static final String SELECT_FROM_DATA_OUT="select * from AMS.dbo.Data_Out where DEVICE_ID=? and PACKET_PARAMS='success' and PACKET_TYPE like 'CAM_%'";
	public static final String GET_CAMERA_DETAILS="select count(*) as CAMERA_NUMBERS from ADWISE.dbo.SITE_CAMERA_ASSOCIATION where UID=?";
	public static final String GET_COMMUNICATION_STATUS="select count(*) as DEVICE_COMMUNICATION from AMS.dbo.gpsdata_history_latest where UNIT_NO=? and GMT>dateadd(mi,-20,getutcdate())";
}
