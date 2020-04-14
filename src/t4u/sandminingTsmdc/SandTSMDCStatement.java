package t4u.sandminingTsmdc;

public class SandTSMDCStatement {

	public static final String GET_SAND_VEHICLE_MASTER_DETAILS=" select ID,isnull(a.VEHICLE_NO,'') as VEHICLE_NO,isnull(a.CHASSIS_NO,'') as CHASSIS_NO,isnull(a.OWNER_NAME,'') as OWNER_NAME, " +
			"isnull(a.VEHICLE_CAPACITY,'') as VEHICLE_CAPACITY,isnull(TARE_WEIGHT,0) as TARE_WEIGHT,isnull(a.RFID_NO,'') as RFID_NO, " +
			"isnull(a.INSERTED_DATE_TIME,'') as INSERTED_DATE,isnull(u.Firstname,'') UPDATED_BY, " +
			"isnull(UPDATED_DATE_TIME,'') as UPDATED_DATE from SAND_VEHICLE_MASTER a " +
			"left outer join Users u on u.User_id=a.UPDATED_BY and u.System_id=a.SYSTEM_ID " +
			"where SYSTEM_ID=? AND CUSTOMER_ID=? and TARE_WEIGHT is not null AND RFID_NO is not null ";
	
	public static final String GET_VEHICLE_NO_LIST="select ID,isnull(a.VEHICLE_NO,'') as VEHICLE_NO,isnull(a.CHASSIS_NO,'') as CHASSIS_NO,isnull(a.OWNER_NAME,'') as OWNER_NAME,isnull(a.VEHICLE_CAPACITY,'') as VEHICLE_CAPACITY from SAND_VEHICLE_MASTER a " +
			"where TARE_WEIGHT is null AND RFID_NO is null ";
	
	public static final String CHECK_VEHICLE_NO_ALREADY_EXIST="select VEHICLE_NO from dbo.SAND_VEHICLE_MASTER where ID=? and TARE_WEIGHT is not NULL and RFID_NO is not NULL ";

	public static final String INSERT_VEHICLE_MASTER_DETAILS="update dbo.SAND_VEHICLE_MASTER set TARE_WEIGHT=?,RFID_NO=?,SYSTEM_ID=?,CUSTOMER_ID=?,UPDATED_BY=?,UPDATED_DATE_TIME=getdate(),CHASSIS_NO=?,OWNER_NAME=?,VEHICLE_CAPACITY=? " +
			" where VEHICLE_NO=? and ID=? ";
	
	public static final String UPDATE_VEHICLE_MASTER_DETAILS="update dbo.SAND_VEHICLE_MASTER set TARE_WEIGHT=?, RFID_NO=? where VEHICLE_NO=? and ID=? ";
	
	//--------T4U445-----------------//
	public static final String GET_VEHICLE_NUMBER_BASED_ON_RFID_FOR_WEIGH_BRIDGE = " select TOP 1 isnull(a.VEHICLE_NO,'') as VEHICLE_NO,isnull(a.TARE_WEIGHT,0) as TARE_WEIGHT,isnull(b.TRANSIT_PERMIT_NO,'') as TRANSIT_PERMIT_NO" +
			" from dbo.SAND_VEHICLE_MASTER a" +
			" left outer join dbo.SAND_TSMDC_TRANSIT_PERMIT_DETAILS b on b.VEHICLE_NO=a.VEHICLE_NO " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.RFID_NO=?" +
			" order by b.TRANSIT_PASS_DATE_TIME desc ";
	
	public static final String SAVE_SAND_WEIGH_BRIDGE_DATA = " insert into dbo.SAND_MINING_WEIGH_BRIDGE_DATA (TRANSIT_PERMIT,VEHICLE_NO,TARE_WEIGHT,GROSS_WEIGHT,NET_WEIGHT,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATE_TIME,ORDER_ID,TRANSIT_PASS_QUANTITY,TRANSIT_PASS_DATE) " +
			" values (?,?,?,?,?,?,?,?,getdate(),?,?,?) ";
	
	public static final String GET_SAND_WEIGH_BRIDGE_DETAILS=" select isnull(a.TRANSIT_PERMIT,'') as TRANSIT_PERMIT,isnull(a.VEHICLE_NO,'') as VEHICLE_NO," +
			" isnull(a.TARE_WEIGHT,0) as TARE_WEIGHT,isnull(a.GROSS_WEIGHT,0) as GROSS_WEIGHT,isnull(a.NET_WEIGHT,0) " +
			" as NET_WEIGHT,isnull(a.INSERTED_DATE_TIME,'') as INSERTED_DATE_TIME,isnull(a.ORDER_ID,'') as ORDER_ID " +
			" from dbo.SAND_MINING_WEIGH_BRIDGE_DATA a  " +
			" where SYSTEM_ID=? and CUSTOMER_ID=? and a.INSERTED_DATE_TIME between ? and ? ";
	
	
	public static final String GET_TRANSIT_PERMIT_VIOLATION_DETAILS=" select isnull(a.TRANSIT_PERMIT_NO,'') as TRANSIT_PERMIT,isnull(a.VEHICLE_NO,'') as VEHICLE_NO," +
			" isnull(a.TRANSIT_PASS_DATE_TIME,'') as TRANSIT_PASS_TIME,isnull(a.DELIVERED_QUANTITY,0) as TRANSIT_QUANTITY," +
			" isnull(cast(NET_WEIGHT/1529.20 as decimal(10,2)),0) as WEIGH_BRIDGE_QTY ," +
			" isnull(b.INSERTED_DATE_TIME,'') as WEIGH_BRIDGE_TIME,DATEDIFF(minute,a.TRANSIT_PASS_DATE_TIME,isnull(b.INSERTED_DATE_TIME,GETDATE())) as DETENTION_TIME," +
			" isnull(c.ORDER_ID,'') as ORDER_ID,isnull(c.CUSTOMER_NAME,'') as CUSTOMER_NAME," +
			" isnull(cast(b.NET_WEIGHT/1529.20 as decimal(10,2)),0) - isnull(a.DELIVERED_QUANTITY,0)  as WEIGHT_DIFFERENCE " +
			" from SAND_TSMDC_TRANSIT_PERMIT_DETAILS a" +
			" inner join dbo.SAND_MINING_WEIGH_BRIDGE_DATA b on a.TRANSIT_PERMIT_NO=b.TRANSIT_PERMIT" +
			" inner join dbo.SAND_TSMDC_ORDER_DETAILS c on c.ORDER_ID=a.ORDER_ID" +
			" where #  and TRANSIT_PASS_DATE_TIME between ? and ? order by TRANSIT_PASS_DATE_TIME desc ";
	
	
	public static final String GET_WEIGH_BRIDGE_VIOLATION_DETAILS=" select isnull(a.TRANSIT_PERMIT,'') as TRANSIT_PERMIT,isnull(a.VEHICLE_NO,'') as VEHICLE_NO,isnull(cast(a.TARE_WEIGHT/1529.20 as decimal(10,2)),0) as TARE_WEIGHT," +
			" isnull(cast(a.GROSS_WEIGHT/1529.20 as decimal(10,2)),0) as GROSS_WEIGHT,isnull(cast(a.NET_WEIGHT/1529.20 as decimal(10,2)),0) as NET_WEIGHT," +
			" isnull(a.TARE_WEIGHT,0) as TARE_WEIGHT_KG,isnull(a.GROSS_WEIGHT,0) as GROSS_WEIGHT_KG,isnull(a.NET_WEIGHT,0) as NET_WEIGHT_KG," +
			" isnull(a.INSERTED_DATE_TIME,'') as INSERTED_DATE_TIME," +
			" isnull(a.ORDER_ID,'') as ORDER_ID,isnull(a.TRANSIT_PASS_QUANTITY,'') as TRANSIT_PASS_QUANTITY,isnull(a.TRANSIT_PASS_DATE,'') as TRANSIT_PASS_DATE," +
			" isnull(cast(NET_WEIGHT/1529.20 as decimal(10,2)),0) - isnull(TRANSIT_PASS_QUANTITY,0) as WEIGHT_DIFFERENCE" +
			" from dbo.SAND_MINING_WEIGH_BRIDGE_DATA a" +
			" where # a.INSERTED_DATE_TIME between ? and ? order by a.INSERTED_DATE_TIME desc ";
	
	public static final String GET_ORDER_DETAILS_REPORT=" select sq.*,wq.WEIGHT_QUANTITY from" +
			" (select a.ORDER_ID,a.CUSTOMER_NAME,a.ORDERED_QUANTITY,sum(b.DELIVERED_QUANTITY) as SOLD_QUANTITY," +
			" a.ORDER_DATE,a.VEHICLE_NO"+
			" from  dbo.SAND_TSMDC_ORDER_DETAILS a" +
			" inner join dbo.SAND_TSMDC_TRANSIT_PERMIT_DETAILS b on a.ORDER_ID=b.ORDER_ID" +
			" group by a.ORDER_ID,a.CUSTOMER_NAME,a.ORDERED_QUANTITY,a.ORDER_DATE,a.VEHICLE_NO) sq" +
			" inner join" +
			" (select a.ORDER_ID,isnull(cast(sum(c.NET_WEIGHT/1529.20) as decimal(10,2)),0) as WEIGHT_QUANTITY" +
			" from  dbo.SAND_TSMDC_ORDER_DETAILS a" +
			" inner join dbo.SAND_TSMDC_TRANSIT_PERMIT_DETAILS b on a.ORDER_ID=b.ORDER_ID" +
			" inner join dbo.SAND_MINING_WEIGH_BRIDGE_DATA c on b.TRANSIT_PERMIT_NO=c.TRANSIT_PERMIT" +
			" group by a.ORDER_ID) wq on wq.ORDER_ID = sq.ORDER_ID";
	
	public static final String GET_MAX_SERIAL_NO=" select value from dbo.General_Settings where name='TSMDC_Serial_No' and System_Id=? and Client_Id=? ";
	
	public static final String UPDATE_MAX_SERIAL_NO=" update dbo.General_Settings  set value=? where name='TSMDC_Serial_No' and System_Id=? and Client_Id=? ";

	public static final String INSERT_MAX_SERIAL_NO=" insert into dbo.General_Settings  (value,name,System_Id,Client_Id) values (?,'TSMDC_Serial_No',?,?)";

	public static final String GET_WEIGHT_CHARGES=" select value from dbo.General_Settings where name='TSMDC_weightCharges' and System_Id=? and Client_Id=? ";

	public static final String SELECT_VEHICLE_NO_VALIDITY=" select VEHICLE_NO from dbo.SAND_VEHICLE_MASTER where VEHICLE_NO=? ";

	public static final String SAVE_VEHICLE_EXCEL_DETAILS=" insert into dbo.SAND_VEHICLE_MASTER (VEHICLE_NO,CHASSIS_NO,OWNER_NAME,VEHICLE_CAPACITY,SYSTEM_ID,CUSTOMER_ID,INSERTED_DATE_TIME) values (?,?,?,?,?,?,getdate()) ";
	
	public static final String GET_EMAIL_DETAILS=" select value from dbo.General_Settings where name='TSMDC_Email_List' and System_Id=? ";
}
