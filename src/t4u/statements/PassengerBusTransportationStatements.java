package t4u.statements;

public class PassengerBusTransportationStatements {
	
	
	public static final String CHECK_TERMINAL_MASTER_INFORMATION = "select * from AMS.dbo.TERMINAL_DETAILS where TERMINAL_ID=? and CUSTOMER_ID = ? and SYSTEM_ID=? ";
	
	public static final String CHECK_TERMINAL_NAME = "select * from AMS.dbo.TERMINAL_DETAILS where TERMINAL_NAME=? and CUSTOMER_ID = ? and SYSTEM_ID=? ";
	
	public static final String INSERT_TERMINAL_MASTER_INFORMATION = "insert into AMS.dbo.TERMINAL_DETAILS (TERMINAL_ID,TERMINAL_NAME,LOCATION,STATUS,SYSTEM_ID,CUSTOMER_ID,INSERTED_DATETIME,INSERTED_BY)values(?,?,?,?,?,?,getutcdate(),?)";

	public static final String UPDATE_TERMINAL_MASTER_INFORMATION = "update AMS.dbo.TERMINAL_DETAILS set TERMINAL_NAME=?,LOCATION=?,STATUS=?,UPDATED_DATETIME=getutcdate(),UPDATED_BY=? where ID=? and TERMINAL_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";

	public static final String GET_TERMINAL_MASTER_DETAILS = " select ID,isnull(TERMINAL_ID,'') as TERMINAL_ID,isnull(TERMINAL_NAME,'') as TERMINAL_NAME, "
		                                                    + " isnull(LOCATION,'') as LOCATION,isnull(STATUS,'') as STATUS from AMS.dbo.TERMINAL_DETAILS WHERE SYSTEM_ID=? AND CUSTOMER_ID=? order by TERMINAL_ID" ;
  
//---------------------------------------Terminal Route Master Statements-----------------------------------------------------------//
	
	public static final String 	GET_TERMINAL_NAMES="select isnull(ID,0) as TERMINAL_ID , isnull(TERMINAL_NAME,'') as TERMINAL_NAME  "+
				"from dbo.TERMINAL_DETAILS  where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active' ";
	
	public static final String 	GET_TERMINAL_ROUTE_MASTER_DETAILS="select a.ROUTE_ID,isnull(b.ID,'') as TERMINAL_ID ,isnull(a.ROUTE_NAME,'') as ROUTE_NAME ,isnull(b.TERMINAL_NAME,'') as TERMINAL_NAME , "+
				"isnull(a.SOURCE,'') as Origin ,isnull(a.DESTINATION,'') as DESTINATION ,isnull(a.DISTANCE,0) as KMS ,isnull(a.DURATION,'') as  DURATION,isnull(a.STATUS,'') as STATUS "+
				"from  AMS.dbo.TERMINAL_ROUTE_MASTER a "+
				"inner join AMS.dbo.TERMINAL_DETAILS b on a.TERMINAL_ID=b.ID "+
				"where a.SYSTEM_ID=? and a.CUSTOMER_ID=?  ";
	
	public static final String 	INSERT_INTO_TERMINAL_ROUTE_MASTER="insert into AMS.dbo.TERMINAL_ROUTE_MASTER "+
				"(TERMINAL_ID,SOURCE,DESTINATION,ROUTE_NAME,DISTANCE,DURATION,STATUS, "+
				"SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME) "+
				"values(?,?,?,?,?,?,?,?,?,?,getUtcDate()) ";
	
	public static final String 	UPDATE_TERMINAL_ROUTE_MASTER=" update AMS.dbo.TERMINAL_ROUTE_MASTER set TERMINAL_ID=?,SOURCE=?,DESTINATION=?, "+
				" ROUTE_NAME=?, DISTANCE=?,DURATION=?,STATUS=?,UPDATED_DATETIME=getUtcDate(),UPDATED_BY=? "+
				" WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND ROUTE_ID=?   ";
	
	public static final String CHECK_IF_PRESENT="Select TERMINAL_ID,ROUTE_NAME from AMS.dbo.TERMINAL_ROUTE_MASTER where TERMINAL_ID=? AND ROUTE_NAME=? AND SYSTEM_ID=? and CUSTOMER_ID=?  ";
	
	public static final String GET_PREPAID_CARD_DETAILS = "select CARD_ID,CARD_HOLDER_NAME,MOBILE_NUMBER,EMAIL_ID,AMOUNT,isnull(PENDING_AMOUNT,0)as PENDING_AMOUNT  from AMS.dbo.PREPAID_CARD_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and COUPON_GEN_MODE='prepaid' ";
	
	public static final String CHECK_PREPAID_CARD_DETAILS = "select EMAIL_ID from AMS.dbo.PREPAID_CARD_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and EMAIL_ID=? and CARD_HOLDER_NAME=?";
	
	public static final String INSERT_PREPAID_CARD_DETAILS = "insert into AMS.dbo.PREPAID_CARD_MASTER(REFERENCE_NUMBER,COUPON_CODE,CARD_HOLDER_NAME,MOBILE_NUMBER,EMAIL_ID,AMOUNT,PENDING_AMOUNT,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,STATUS,COUPON_GEN_MODE) "
														     +" values(?,?,?,?,?,?,?,?,?,?,getutcdate(),'OPEN','prepaid')";
	
	public static final String UPDATE_PREPAID_CARD_DETAILS = "update AMS.dbo.PREPAID_CARD_MASTER set CARD_HOLDER_NAME=?, MOBILE_NUMBER=?, EMAIL_ID=?, AMOUNT=?, UPDATED_BY=?, UPDATED_DATETIME=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and CARD_ID=? ";
	
	public static final String SELECT_PREPAID_CARD_DETAILS = "select REFERENCE_NUMBER,COUPON_CODE from AMS.dbo.PREPAID_CARD_MASTER where CARD_ID=? ";
	
public static final String GET_ROUTE_NAME = " SELECT ROUTE_ID,ROUTE_NAME,DISTANCE,DURATION FROM AMS.dbo.TERMINAL_ROUTE_MASTER WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND TERMINAL_ID=? AND STATUS='Active' ";
	
	public static final String SAVE_RATE_MASTER_DETAILS = " INSERT INTO [AMS].[dbo].[TICKET_RATE_MASTER] "+
														  " ([AMOUNT],[TERMINAL_ID],[ROUTE_ID],[DISTANCE],[DURATION],[DEPARTURE_TIME],[ARRIVAL_TIME],[VEHICLE_MODEL_ID] "+
														  " ,[SEATING_STRUCTURE_ID],[DAY_TYPE],[STATUS],[SYSTEM_ID],[CUSTOMER_ID],[INSERTED_BY],[INSERTED_DATETIME]) "+
														  " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,GETDATE()) ";
	
	public static final String GET_VEHICLE_MODEL = " SELECT ModelTypeId,ModelName FROM FMS.dbo.Vehicle_Model WHERE SystemId=? AND ClientId=? "; 
	
	public static final String GET_SEATING_STRUCTURE = " SELECT STRUCTURE_ID,STRUCTURE_NAME FROM AMS.dbo.ASSET_SEATING_STRUCTURE WHERE SYSTEM_ID=? AND CUSTOMER_ID=? and STATUS='Active' ";
	
	public static final String GET_RATE_MASTER_DETAILS = " SELECT a.[RATE_ID],a.[AMOUNT],a.[TERMINAL_ID],b.[TERMINAL_NAME],a.[ROUTE_ID],c.[ROUTE_NAME],a.[DISTANCE],a.[DURATION],a.[DEPARTURE_TIME], "+
														 " a.[ARRIVAL_TIME],a.[VEHICLE_MODEL_ID],d.[ModelName],a.[SEATING_STRUCTURE_ID],e.[STRUCTURE_NAME],a.[DAY_TYPE],a.[STATUS] "+ 
														 " FROM [AMS].[dbo].[TICKET_RATE_MASTER] a "+ 
														 " LEFT OUTER JOIN [AMS].[dbo].[TERMINAL_DETAILS] b ON a.TERMINAL_ID=b.ID AND a.SYSTEM_ID=b.SYSTEM_ID AND a.CUSTOMER_ID=b.CUSTOMER_ID "+
														 " LEFT OUTER JOIN [AMS].[dbo].[TERMINAL_ROUTE_MASTER] c ON a.ROUTE_ID = c.ROUTE_ID AND a.SYSTEM_ID=b.SYSTEM_ID AND a.CUSTOMER_ID=b.CUSTOMER_ID "+
														 " LEFT OUTER JOIN [FMS].[dbo].[Vehicle_Model] d ON a.VEHICLE_MODEL_ID=d.ModelTypeId AND a.SYSTEM_ID=d.SystemId AND a.CUSTOMER_ID=d.CLientId "+
														 " LEFT OUTER JOIN [AMS].[dbo].[ASSET_SEATING_STRUCTURE] e ON a.SEATING_STRUCTURE_ID = e.STRUCTURE_ID AND a.SYSTEM_ID=b.SYSTEM_ID AND a.CUSTOMER_ID=b.CUSTOMER_ID "+
														 " WHERE a.[SYSTEM_ID]=? AND a.[CUSTOMER_ID]=? "; 
	
	public static final String UPDATE_RATE_MASTER_DETAILS = " UPDATE [AMS].[dbo].[TICKET_RATE_MASTER] SET [DAY_TYPE]=?,[TERMINAL_ID]=?,[ROUTE_ID]=?,[DISTANCE] = ?,[DURATION] = ?, "+
															" [DEPARTURE_TIME] = ? ,[ARRIVAL_TIME] = ?,[VEHICLE_MODEL_ID] = ?,[SEATING_STRUCTURE_ID] = ?,[AMOUNT] = ?,[STATUS] = ?, "+
															" [UPDATED_BY] = ?,[UPDATED_DATETIME] = GETDATE() WHERE [SYSTEM_ID]=? AND [CUSTOMER_ID]=? AND [RATE_ID]=? ";
	
	public static final String CHECK_RATE_MASTER_DETAILS = " SELECT * FROM [AMS].[dbo].[TICKET_RATE_MASTER] WHERE [SYSTEM_ID]=? AND [CUSTOMER_ID]=? AND [TERMINAL_ID]=? AND "+ 
														   " [ROUTE_ID]=? AND [SEATING_STRUCTURE_ID]=? AND [VEHICLE_MODEL_ID]=? AND [DAY_TYPE]=? AND [DISTANCE]=? AND [DURATION]=? "+
														   " AND [DEPARTURE_TIME]=? AND [ARRIVAL_TIME]=? AND [AMOUNT]=? AND [STATUS]=? ";
	
	
	public static final String CHECK_PREPAID_CARD_REFERENCE_NUMBER = "select REFERENCE_NUMBER from AMS.dbo.PREPAID_CARD_MASTER where REFERENCE_NUMBER=?";

	public static final String CHECK_PREPAID_CARD_COUPON_CODE = "select COUPON_CODE from AMS.dbo.PREPAID_CARD_MASTER where COUPON_CODE=?";
	
	public static final String INSERT_INTO_EMAIL_QUEUE_FOR_REFERENCE_AND_COUPON_CODE_GENERATION = " insert into AMS.dbo.CUSTOMIZED_EMAIL_QUEUE (SUBJECT,BODY,EMAIL_LIST,DATE_TIME,SYSTEM_ID,CUSTOMER_ID) values(?,?,?,getutcdate(),?,?)";
	
	public static final String INSERT_SMS ="INSERT INTO dbo.SEND_SMS(PhoneNo,Message,Status,ClientId,SystemId,InsertedTime) values (?,?,?,?,?,getUTCDate())";

	public static final String GET_PREPAID_CARD_REFUND_DETAILS = "select CARD_HOLDER_NAME,MOBILE_NUMBER,EMAIL_ID,AMOUNT,STATUS,PENDING_AMOUNT from AMS.dbo.PREPAID_CARD_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and REFERENCE_NUMBER=? and EMAIL_ID=? ";

	public static final String CHECK_PREPAID_CARD_REFUND_DETAILS = "select * from AMS.dbo.PREPAID_CARD_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and REFERENCE_NUMBER=? and EMAIL_ID=? ";

	public static final String CHECK_EMAIL_REFERENCE_CODE= "select * from AMS.dbo.PREPAID_CARD_MASTER where SYSTEM_ID=? and CUSTOMER_ID=? and REFERENCE_NUMBER=?";
	
	public static final String UPDATE_PREPAID_CARD_REFUND_DETAILS="update AMS.dbo.PREPAID_CARD_MASTER set PENDING_AMOUNT=0,STATUS='CLOSE', REFUNDED_BY=?,REFUNDED_DATETIME=getutcdate() where SYSTEM_ID=? and CUSTOMER_ID=? and REFERENCE_NUMBER=? and EMAIL_ID=?";
	//---------------------------------------------------- Trip Planner Statements ------------------------------------------------------
	
	public static final String 	GET_ROUTES_NAMES =  " SELECT TRM.RATE_ID,RM.ROUTE_ID,ROUTE_NAME "+
	                                                " FROM  AMS.dbo.TICKET_RATE_MASTER TRM "+
	                                                " INNER JOIN AMS.dbo.TERMINAL_ROUTE_MASTER RM ON TRM.ROUTE_ID = RM.ROUTE_ID "+
	                                                " INNER JOIN AMS.dbo.TERMINAL_DETAILS TD ON  TRM.TERMINAL_ID = TD.ID "+
	                                                " WHERE TRM.SYSTEM_ID =? AND TRM.CUSTOMER_ID =? AND TRM.TERMINAL_ID =? AND TRM.STATUS = 'Active' "+
	                                                " AND TRM.DAY_TYPE = ? ";

	   
	
	
	public static final String 	GET_ROUTES_DETAILS = " SELECT TRM.RATE_ID,TRM.ROUTE_ID,RM.SOURCE+'-'+RM.DESTINATION AS ORIGIN_DESTINATION,RM.DISTANCE,RM.DURATION,RM.DISTANCE,TRM.DEPARTURE_TIME,TRM.ARRIVAL_TIME,TRM.AMOUNT," +
		                                             " VM.ModelName AS MODEL_NAME,BS.STRUCTURE_NAME AS SEATING_STRUCTURE FROM  TICKET_RATE_MASTER TRM "+
													 " INNER JOIN AMS.dbo.TERMINAL_DETAILS TM ON TRM.TERMINAL_ID = TM.ID "+
	                                                 " INNER JOIN AMS.dbo.TERMINAL_ROUTE_MASTER RM ON TRM.ROUTE_ID  = RM.ROUTE_ID "+
													 " INNER JOIN FMS.dbo.Vehicle_Model VM ON TRM.VEHICLE_MODEL_ID = VM.ModelTypeId "+
													 " INNER JOIN AMS.dbo.ASSET_SEATING_STRUCTURE BS ON TRM.SEATING_STRUCTURE_ID = BS.STRUCTURE_ID"+
													 " WHERE TRM.SYSTEM_ID  = ? AND TRM.CUSTOMER_ID =? AND TRM.TERMINAL_ID = ? AND DAY_TYPE = ?  AND TRM.STATUS  = 'Active' AND TRM.RATE_ID  =?  ";
  
	public static final String INSERT_INTO_SERVICE_MASTER = " INSERT INTO AMS.dbo.SERVICE_MASTER ( SERVICE_NAME,DAY_TYPE,TERMINAL_ID,ROUTE_ID,RATE_ID,STATUS,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME ) "+
                                                            " values "+
                                                            " (?,?,?,?,?,?,?,?,?,GETUTCDATE())";
	
	public static final String CHECK_DUPLICATE = " SELECT SERVICE_NAME FROM AMS.dbo.SERVICE_MASTER WHERE SERVICE_NAME = ? AND SYSTEM_ID  = ? AND CUSTOMER_ID  = ? ";
	
	public static final String UPDATE_SERVICE_MASTER = " UPDATE AMS.dbo.SERVICE_MASTER SET DAY_TYPE = ? , TERMINAL_ID = ? , ROUTE_ID = ?, RATE_ID = ?, STATUS = ?, UPDATED_BY = ?, UPDATED_DATETIME = GETUTCDATE()  WHERE  SYSTEM_ID = ? AND  CUSTOMER_ID = ? AND SERVICE_NAME  = ? AND SERVICE_ID = ?  ";
	
	public static final String GET_SERVICE_DETAILS = " SELECT SM.SERVICE_ID,SM.SERVICE_NAME,TRM.DAY_TYPE,TM.TERMINAL_NAME,RM.ROUTE_NAME,RM.SOURCE+' - '+RM.DESTINATION AS ORIGIN_DESTINATION," +
			                                         " RM.DISTANCE,RM.DURATION,RM.DISTANCE, TRM.DEPARTURE_TIME, TRM.ARRIVAL_TIME,TRM.AMOUNT,VM.ModelName AS MODEL_NAME,BS.STRUCTURE_NAME AS SEATING_STRUCTURE,SM.STATUS, " +
	                                                 " TRM.TERMINAL_ID,TRM.ROUTE_ID,SM.RATE_ID "+
	                                                 " FROM AMS.dbo.SERVICE_MASTER SM "+
	                                                 " INNER JOIN  AMS.dbo.TICKET_RATE_MASTER TRM ON SM.RATE_ID = TRM.RATE_ID "+
	                                                 " INNER JOIN AMS.dbo.TERMINAL_DETAILS TM ON TRM.TERMINAL_ID = TM.ID "+
	                                                 " INNER JOIN AMS.dbo.TERMINAL_ROUTE_MASTER RM ON TRM.ROUTE_ID  = RM.ROUTE_ID "+
	                                                 " INNER JOIN FMS.dbo.Vehicle_Model VM ON TRM.VEHICLE_MODEL_ID = VM.ModelTypeId "+
	                                                 " INNER JOIN AMS.dbo.ASSET_SEATING_STRUCTURE BS ON TRM.SEATING_STRUCTURE_ID = BS.STRUCTURE_ID "+
	                                                 " WHERE SM.SYSTEM_ID  =? AND SM.CUSTOMER_ID =? ";
	
	public static final String GET_SEATING_STRUCTURE_DETAILS="select STRUCTURE_ID,STRUCTURE_NAME,STATUS from AMS.dbo.ASSET_SEATING_STRUCTURE where SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String CHECK_STRUCTURE_NAME_EXISTS="select STRUCTURE_NAME,STRUCTURE_ID,STRUCTURE_DESIGN  from AMS.dbo.ASSET_SEATING_STRUCTURE where SYSTEM_ID=? and CUSTOMER_ID=? and STRUCTURE_NAME=?";
	
	public static final String UPDATE_STRUCTURE_DETAILS="update AMS.dbo.ASSET_SEATING_STRUCTURE set STATUS=? where STRUCTURE_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
	//---------------------------------------------------- Service Vehicle Association ------------------------------------------------------ 

	public static final String GET_SERVICE_VEHICLE_ASSOCIATION ="select a.ID,a.SERVICE_ID,sm.SERVICE_NAME,isnull(a.REGISTRATION_NO,'')as REGISTRATION_NO,a.DATE_TIME,b.DAY_TYPE,d.TERMINAL_NAME,c.ROUTE_NAME,(c.SOURCE+' - '+c.DESTINATION) as ORIGIN_DESTINATION, "+ 
																" b.DISTANCE,b.DEPARTURE_TIME,b.ARRIVAL_TIME,b.DURATION,VM.ModelName as VEHICLE_MODEL,ss.STRUCTURE_NAME as SEATING_STRUCTURE,b.AMOUNT as Rate,a.STATUS,a.DRIVER_EXPENSE,a.WORKER_FEE,a.MISCELLANEOUS_EXPENSE,a.DISPATCH_AMOUNT,a.INSURANCE,a.TAX,isnull(a.TOTAL,0) as TOTAL "+ 
																" from AMS.dbo.VEHICLE_SERVICE_ASSOCIATION a "+
																" inner join AMS.dbo.SERVICE_MASTER sm on sm.SERVICE_ID = a.SERVICE_ID and sm.SYSTEM_ID = a.SYSTEM_ID and sm.CUSTOMER_ID = a.CUSTOMER_ID "+ 
																" inner join AMS.dbo.TICKET_RATE_MASTER b on b.RATE_ID = sm.RATE_ID and b.SYSTEM_ID = sm.SYSTEM_ID and b.CUSTOMER_ID = sm.CUSTOMER_ID "+
																" inner join AMS.dbo.ASSET_SEATING_STRUCTURE ss on ss.STRUCTURE_ID = b.SEATING_STRUCTURE_ID and ss.SYSTEM_ID=b.SYSTEM_ID and ss.CUSTOMER_ID=b.CUSTOMER_ID "+
																" inner join AMS.dbo.TERMINAL_ROUTE_MASTER c on c.ROUTE_ID = b.ROUTE_ID and c.SYSTEM_ID = b.SYSTEM_ID and c.CUSTOMER_ID = b.CUSTOMER_ID "+ 
																" inner join AMS.dbo.TERMINAL_DETAILS d on d.ID = c.TERMINAL_ID and d.SYSTEM_ID = c.SYSTEM_ID and d.CUSTOMER_ID = c.CUSTOMER_ID "+ 
																" inner join FMS.dbo.Vehicle_Model VM ON VM.ModelTypeId = b.VEHICLE_MODEL_ID  and b.SYSTEM_ID=VM.SystemId and b.CUSTOMER_ID=VM.ClientId "+
																" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? order by a.DATE_TIME asc,sm.SERVICE_NAME asc ";
	
	public static final String GET_SERVICE_VEHICLE_NUMBER_LIST ="select  a.REGISTRATION_NO as REGISTRATION_NO from gpsdata_history_latest a "+
																" inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id "+
																" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "+
																" where a.CLIENTID = ? and a.System_id =? and b.User_id=? and a.REGISTRATION_NO not in (select REGISTRATION_NO from AMS.dbo.VEHICLE_SERVICE_ASSOCIATION where DATE_TIME=? and SYSTEM_ID=? and CUSTOMER_ID=? and REGISTRATION_NO is not null)";

	
	public static final String GET_SERVICE_NAME_LIST = "select sm.SERVICE_ID,sm.SERVICE_NAME from AMS.dbo.SERVICE_MASTER sm "+
														"inner join AMS.dbo.TERMINAL_DETAILS td on td.ID = sm.TERMINAL_ID "+
														"where sm.TERMINAL_ID=? and td.SYSTEM_ID=? and td.CUSTOMER_ID=?"; 
	
	public static final String CHECK_SERVICE_VEHICLE_NO_ASSOC = "select DATE_TIME,STATUS,SERVICE_ID from AMS.dbo.VEHICLE_SERVICE_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? AND DATE_TIME = ?  and  SERVICE_ID = ?  ";

	public static final String CHECK_SERVICE_VEHICLE_NO_ASSOC_WITH_VEHICLE = "select DATE_TIME,STATUS,SERVICE_ID from AMS.dbo.VEHICLE_SERVICE_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=? AND DATE_TIME = ?  and REGISTRATION_NO=? ";

	
public static final String CHECK_SERVICE_VEHICLE_NO_ASSOC_WITH_DATE = "select DATE_TIME,STATUS,SERVICE_ID from AMS.dbo.VEHICLE_SERVICE_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=?  and  REGISTRATION_NO = ? AND DATE_TIME = ? ";
	
 	public static final String CHECK_SERVICE_VEHICLE_NO_ASSOC_WITH_DATE_MODIFIED = "select DATE_TIME,STATUS,SERVICE_ID from AMS.dbo.VEHICLE_SERVICE_ASSOCIATION where SYSTEM_ID=? and CUSTOMER_ID=?  and  REGISTRATION_NO = ? AND DATE_TIME = ? and  SERVICE_ID = ? AND STATUS = ? ";

	
	public static final String INSERT_SERVICE_VEHICLE_NO_ASSOC = "insert into AMS.dbo.VEHICLE_SERVICE_ASSOCIATION(DATE_TIME,SERVICE_ID,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,STATUS) values(?,?,?,?,?,getutcdate(),?)";
	
	public static final String UPDATE_SERVICE_VEHICLE_NO_ASSOC = "update AMS.dbo.VEHICLE_SERVICE_ASSOCIATION set  UPDATED_BY=?, UPDATED_DATETIME=getutcdate(),STATUS=? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";
	
	public static final String ADD_VEHICLE = "update AMS.dbo.VEHICLE_SERVICE_ASSOCIATION set REGISTRATION_NO=?,DRIVER_EXPENSE=?,WORKER_FEE=?,MISCELLANEOUS_EXPENSE=?,DISPATCH_AMOUNT=?,INSURANCE=?,TAX=?,TOTAL=? where SYSTEM_ID=? and CUSTOMER_ID=? and ID=? ";

	public static final String UPDATE_TRANSACTION_DETAILS_REGI = "update dbo.TRANSACTION_DETAILS set REGISTRATION_NUMBER=? where SERVICE_ID=? and JOURNEY_DATE=?";

	
	public static final String GET_SERVICE_VEHICLE_ASSOC_BASED_ON_SERVICEID="select b.DAY_TYPE,d.TERMINAL_NAME,c.ROUTE_NAME,(c.SOURCE+' - '+c.DESTINATION) as ORIGIN_DESTINATION, "+  
																			" b.DISTANCE,b.DEPARTURE_TIME,b.ARRIVAL_TIME,b.DURATION,VM.ModelName as VEHICLE_MODEL,ss.STRUCTURE_NAME as SEATING_STRUCTURE,b.AMOUNT as Rate,b.STATUS "+
																			" from AMS.dbo.SERVICE_MASTER sm "+ 
																			" inner join AMS.dbo.TICKET_RATE_MASTER b on b.RATE_ID = sm.RATE_ID and b.SYSTEM_ID = sm.SYSTEM_ID and b.CUSTOMER_ID = sm.CUSTOMER_ID "+ 
																			" inner join AMS.dbo.ASSET_SEATING_STRUCTURE ss on ss.STRUCTURE_ID = b.SEATING_STRUCTURE_ID and ss.SYSTEM_ID=b.SYSTEM_ID and ss.CUSTOMER_ID=b.CUSTOMER_ID "+
																			" inner join AMS.dbo.TERMINAL_ROUTE_MASTER c on c.ROUTE_ID = b.ROUTE_ID and c.SYSTEM_ID = b.SYSTEM_ID and c.CUSTOMER_ID = b.CUSTOMER_ID "+ 
																			" inner join AMS.dbo.TERMINAL_DETAILS d on d.ID = c.TERMINAL_ID and d.SYSTEM_ID = c.SYSTEM_ID and d.CUSTOMER_ID = c.CUSTOMER_ID "+ 
																			" inner join FMS.dbo.Vehicle_Model VM ON VM.ModelTypeId = b.VEHICLE_MODEL_ID  and b.SYSTEM_ID=VM.SystemId and b.CUSTOMER_ID=VM.ClientId "+
																			" where sm.SERVICE_ID=? and  sm.SYSTEM_ID=? and sm.CUSTOMER_ID=?";
//---------------------------------------------------- End of Service Vehicle Association ------------------------------------------------------
	 public static final String INSERT_INTO_EmailQueue = "insert into AMS.dbo.CUSTOMIZED_EMAIL_QUEUE (SUBJECT,BODY,EMAIL_LIST,DATE_TIME,SYSTEM_ID,CUSTOMER_ID) values(?,?,?,getutcdate(),?,?)";

	 public static final String GET_ROUTE_NAME_BASED_ON_TERMINAL="SELECT DISTINCT SOURCE FROM AMS.dbo.TERMINAL_ROUTE_MASTER WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND STATUS='Active' ";
	 
	 public static final String GET_DESTINATION="SELECT DISTINCT DESTINATION FROM AMS.dbo.TERMINAL_ROUTE_MASTER WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND SOURCE=? AND STATUS='Active' ";
	 
	 public static final String GET_TERMINAL="select TERMINAL_NAME from AMS.dbo.TERMINAL_DETAILS where SYSTEM_ID=? and CUSTOMER_ID=? and STATUS='Active' and ID in ( SELECT TERMINAL_ID " +
	 		"								 FROM AMS.dbo.TERMINAL_ROUTE_MASTER WHERE SYSTEM_ID=? AND CUSTOMER_ID=? AND SOURCE=? AND DESTINATION=? AND STATUS='Active' )";
	   
	 public static final String GET_SERVICE_NAME_BASED_ON_SEARCH="select td.ID,td.TERMINAL_NAME,sm.SERVICE_ID,sm.SERVICE_NAME,sm.RATE_ID,sm.STATUS,vm.ModelName,st.STRUCTURE_NAME,st.SEATING_CAPACITY,tr.DEPARTURE_TIME,tr.DURATION,tr.ARRIVAL_TIME,tr.AMOUNT,trm.ROUTE_NAME from AMS.dbo.SERVICE_MASTER sm "
		   															+"inner  join AMS.dbo.TICKET_RATE_MASTER tr on sm.RATE_ID=tr.RATE_ID and sm.SYSTEM_ID=tr.SYSTEM_ID and sm.CUSTOMER_ID=tr.CUSTOMER_ID and tr.STATUS='Active' "
		   															+"inner join FMS.dbo.Vehicle_Model vm ON vm.ModelTypeId = tr.VEHICLE_MODEL_ID  and tr.SYSTEM_ID=vm.SystemId and tr.CUSTOMER_ID=vm.ClientId "
		   															+"inner join AMS.dbo.ASSET_SEATING_STRUCTURE st on st.STRUCTURE_ID=tr.SEATING_STRUCTURE_ID and st.CUSTOMER_ID=sm.CUSTOMER_ID and st.SYSTEM_ID=tr.SYSTEM_ID and st.STATUS='Active' "
		   															+"inner  join AMS.dbo.TERMINAL_ROUTE_MASTER trm on trm.ROUTE_ID=tr.ROUTE_ID and trm.SYSTEM_ID=tr.SYSTEM_ID and trm.CUSTOMER_ID=tr.CUSTOMER_ID  and trm.STATUS='Active' "
		   															+"inner  join AMS.dbo.TERMINAL_DETAILS td on td.ID=trm.TERMINAL_ID and td.ID=tr.TERMINAL_ID and td.SYSTEM_ID=trm.SYSTEM_ID and td.CUSTOMER_ID=trm.CUSTOMER_ID and td.STATUS='Active' "
		   															+" left outer join AMS.dbo.System_Master s on s.System_id=td.SYSTEM_ID "
		   															+"where sm.SYSTEM_ID=? and sm.CUSTOMER_ID=? and td.ID=? and trm.SOURCE=? and trm.DESTINATION=?  and sm.STATUS='Active' "
		   															+"and sm.SERVICE_ID in (select SERVICE_ID from AMS.dbo.VEHICLE_SERVICE_ASSOCIATION where DATE_TIME =? and STATUS='Active') and sm.STATUS='Active'" +
		   															" and DATEDIFF(mi,dateadd(mi,cast(s.OffsetMin as int),getutcdate()),dateadd(hh,cast(SUBSTRING(cast(tr.DEPARTURE_TIME as char),1,2) as int),dateadd(mi,cast(SUBSTRING(cast(tr.DEPARTURE_TIME as char),4,LEN(tr.DEPARTURE_TIME)) as int),?)))>0  order by sm.SERVICE_ID";
	   
	 public static final String FIND_TOTAL_BOOKED_SEATS_AVALIABLE_FOR_SERVICE="select sum(NUMBER_OF_SEATS) as BOOKED_SEATS,SUM(CASE WHEN DATEDIFF(mi,td.INSERTED_DATETIME,getutcdate())>=8 and tm.TRANSACTION_STATUS='pending' THEN 1 ELSE 0 END)AS PENDING  FROM AMS.dbo.TRANSACTION_DETAILS td " +
	 																		  "inner join  AMS.dbo.TRANSACTION_MASTER tm on td.TRANSACTION_REF_ID=tm.TRANSACTION_REF_ID "+
	 		"																   where SERVICE_NAME=? and ROUTE_NAME=? and TERMINAL_NAME=? and  JOURNEY_DATE=? and tm.TRANSACTION_STATUS in ('success','pending')";
	   
	 public static final String GET_BOOKED_SEATS_FROM_TEMP_TRANSACTION="select sum (temp.TOTAL_SEAT_SELECTED)as TOTAL_SEAT_SELECTED from (select DISTINCT TOTAL_SEAT_SELECTED,SERVICE_ID,TERMINAL_ID,RATE_ID,JOURNEY_DATE,SELECTED_SEATS " +
	   																	 "from AMS.dbo.TEMPORARY_TRANSACTION where SERVICE_ID=? and TERMINAL_ID=? and RATE_ID=? and JOURNEY_DATE=? and DATEDIFF(mi,INSERTED_DATETIME,getutcdate())<=8 ) temp";

	   
	 public static final String GET_BOOKED_SEAT_NO_FROM_TRANSACTION="select pd.SEAT_NUMBER FROM AMS.dbo.TRANSACTION_DETAILS td "
		   																+"inner join AMS.dbo.TRANSACTION_MASTER tm on td.TRANSACTION_REF_ID=tm.TRANSACTION_REF_ID "
		   																+"inner join AMS.dbo.PASSANGER_DETAILS pd on pd.TRANSACTION_ID=tm.TRANSACTION_REF_ID and td.SERVICE_ID=pd.SERVICE_ID "
		   																+"where SERVICE_NAME=? and ROUTE_NAME=? and TERMINAL_NAME=? and  JOURNEY_DATE=? and tm.TRANSACTION_STATUS in ('success','pending')";
	 
	 public static final String GET_PENDING_SEAT_NO_GREATER_THEN_SEAT_LOCK_TIME="select DISTINCT pd.SEAT_NUMBER FROM AMS.dbo.TRANSACTION_DETAILS td "
		   																+"inner join AMS.dbo.TRANSACTION_MASTER tm on td.TRANSACTION_REF_ID=tm.TRANSACTION_REF_ID "
		   																+"inner join AMS.dbo.PASSANGER_DETAILS pd on pd.TRANSACTION_ID=tm.TRANSACTION_REF_ID and td.SERVICE_ID=pd.SERVICE_ID "
		   																+"where SERVICE_NAME=? and ROUTE_NAME=? and TERMINAL_NAME=? and  JOURNEY_DATE=? and DATEDIFF(mi,td.INSERTED_DATETIME,getutcdate())>=8 and tm.TRANSACTION_STATUS in ('pending')";
	   
	 public static final String GET_BOOKED_SEAT_NO_FROM_TEM_TRANSACTION="select SELECTED_SEATS from AMS.dbo.TEMPORARY_TRANSACTION where SERVICE_ID=? and TERMINAL_ID=? and RATE_ID=? and JOURNEY_DATE=? and DATEDIFF(mi,INSERTED_DATETIME,getutcdate())<=8 ";
	   
	 public static final String INSERT_INTO_TEMP_TRANSACTION="insert into AMS.dbo.TEMPORARY_TRANSACTION(TOTAL_SEAT_SELECTED,SERVICE_ID,TERMINAL_ID,RATE_ID,JOURNEY_DATE,SELECTED_SEATS,INSERTED_DATETIME) values (?,?,?,?,?,?,getutcdate())";

	 public static final String GET_TEMP_ID_FROM_TRANSACTION="select TEMP_ID from AMS.dbo.TEMPORARY_TRANSACTION where SERVICE_ID=? and TERMINAL_ID=? and RATE_ID=? and JOURNEY_DATE=? and INSERTED_DATETIME=?";

	   
	   //**********************************************Email Response**************************************//
	   public static String GET_MailDetails=  "select c.SEAT_NUMBER,SUBSTRING ( a.PHONE_NUMBER,4 ,LEN(a.PHONE_NUMBER)) as PHONE_NUMBER,a.EMAIL_ID,CONVERT(VARCHAR(11),JOURNEY_DATE,106) AS JOURNEY_DATE,b.DEPARTURE_TIME,b.SEATING_STRUCTURE,b.SOURCE,a.TOTAL_AMOUNT,b.VEHICLE_MODEL, "
           +"CONVERT(VARCHAR(11),a.INSERTED_DATETIME,106) as INSERTED_DATETIME,c.PASSANGER_NAME,a.TICKET_NUMBER,b.DESTINATION,b.TERMINAL_NAME, b.NUMBER_OF_SEATS,  "
           +"convert(char(5), (DATEADD(mi,-15,(CONVERT(datetime ,DEPARTURE_TIME) ))),108) AS  REPORTING_TIME , DATENAME(dw,JOURNEY_DATE) as WEEKDAY "
		   +"FROM AMS.dbo.PASSANGER_DETAILS c "
           +"inner join AMS.dbo.TRANSACTION_DETAILS b on b.TRANSACTION_REF_ID=c.TRANSACTION_ID "
           +"inner join AMS.dbo.TRANSACTION_MASTER a on a.TRANSACTION_REF_ID=c.TRANSACTION_ID where c.TRANSACTION_ID= ? ";

	   
	   
	   public static final String INSERT_INTO_EMAIL_QUEUE="insert into AMS.dbo.CUSTOMIZED_EMAIL_QUEUE (SUBJECT,BODY,EMAIL_LIST,DATE_TIME,SYSTEM_ID,CUSTOMER_ID) values(?,?,?,getutcdate(),?,?)";

	   public static final String UPDATE_TRANSACTION_STATUS=" update AMS.dbo.TRANSACTION_MASTER set TRANSACTION_STATUS=? where TRANSACTION_REF_ID=? ";
	   
	   public static final String GET_RESPONSE_DESCRIPTION="select RESPONSE_DESCRIPTION,RESPONSE_CODE from AMS.dbo.PAYMENT_RESPONSE_DETAILS WHERE TRANSACTION_ID=?";

	   public static final String INSERT_SMS_QUERY=" INSERT INTO dbo.SEND_SMS(PhoneNo,Message,Status,InsertedTime) values (?,?,?,getUTCDate())";
		
	   public static final String GET_TRANSACTION_TYPE = "SELECT IS_ROUND_TRIP FROM AMS.dbo.TRANSACTION_MASTER WHERE TRANSACTION_REF_ID = ?";
	                                                     
	   public static final String GET_TRANS_DETAILLS_FOR_ROUNDTRIP = 
	   " select CONVERT(VARCHAR(11),b.JOURNEY_DATE,106) AS JOURNEY_DATE,CONVERT(VARCHAR(11),a.INSERTED_DATETIME,106) as INSERTED_DATETIME,b.DEPARTURE_TIME,b.SEATING_STRUCTURE,b.SOURCE,b.AMOUNT,"+
       " a.TICKET_NUMBER,b.DESTINATION,b.TERMINAL_NAME,a.TICKET_NUMBER,b.SERVICE_ID,b.VEHICLE_MODEL, "+
       " convert(char(5), (DATEADD(mi,-15,(CONVERT(datetime ,DEPARTURE_TIME) ))),108) AS  REPORTING_TIME, "+
	   " b.NUMBER_OF_SEATS,DATENAME(dw,JOURNEY_DATE) as WEEKDAY "+										
	   " FROM AMS.dbo.TRANSACTION_DETAILS b "+
       " inner join AMS.dbo.TRANSACTION_MASTER a on a.TRANSACTION_REF_ID=b.TRANSACTION_REF_ID where b.TRANSACTION_REF_ID = ?  ORDER BY b.JOURNEY_DATE ASC "; 

	   public static final String GET_PASSANGER_DETAIL_FOR_MAIL = "select TOP 1 b.PASSANGER_NAME,SUBSTRING ( a.PHONE_NUMBER,4 ,LEN(a.PHONE_NUMBER)) as PHONE_NUMBER,a.EMAIL_ID,b.GENDER FROM AMS.dbo.PASSANGER_DETAILS b INNER JOIN AMS.dbo.TRANSACTION_MASTER a on a.TRANSACTION_REF_ID  = b.TRANSACTION_ID WHERE b.TRANSACTION_ID = ? ";

	   public static final String GET_BOOKED_SEATS = " SELECT SEAT_NUMBER,PASSANGER_NAME,GENDER FROM dbo.PASSANGER_DETAILS WHERE TRANSACTION_ID = ? ";
	   
//	   public static final String GET_BOOKED_SEATS_ROUNDTRIP = " SELECT SEAT_NUMBER FROM dbo.PASSANGER_DETAILS pd "+ 
//	                                                        " INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on pd.TRANSACTION_ID=td.TRANSACTION_REF_ID "+
//	                                                        " WHERE td.TRANSACTION_REF_ID = ? AND pd.SERVICE_ID = ?";

	   public static final String GET_BOOKED_SEATS_ROUNDTRIP =" SELECT SEAT_NUMBER,PASSANGER_NAME,GENDER FROM AMS.dbo.PASSANGER_DETAILS where TRANSACTION_ID=? AND  SERVICE_ID=? ";
	   // **************************************************** payment statemts **********************************************
		   

			public static final String INSERT_INTO_TRANSACTION_MASTER = " INSERT INTO AMS.dbo.TRANSACTION_MASTER ( TRANSACTION_REF_ID,TICKET_NUMBER,PAYMENT_MODE,IS_ROUND_TRIP,TOTAL_AMOUNT,COUPON_CODE,TRANSACTION_STATUS,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,PHONE_NUMBER,EMAIL_ID,BOOKED_BY  ) VALUES ( ?,?,?,?,?,?,'pending',?,?,?,?,?,'web' )";
			
			public static final String GET_DETAILS_FOR_PAYMENTS = " SELECT TR.ROUTE_NAME,TR.SOURCE,TR.DESTINATION,TD.TERMINAL_NAME,TR.DISTANCE,TR.DURATION,TRM.DEPARTURE_TIME,TRM.ARRIVAL_TIME,VM.ModelName AS MODEL_NAME," +
					                                              " SM.SERVICE_NAME,TRM.AMOUNT,AST.STRUCTURE_NAME,TRM.DAY_TYPE "+
			                                                      " FROM AMS.dbo.TICKET_RATE_MASTER TRM "+
			                                                      " INNER JOIN AMS.dbo.SERVICE_MASTER SM ON TRM.RATE_ID = SM.RATE_ID "+
			                                                      " INNER JOIN AMS.dbo.TERMINAL_ROUTE_MASTER TR ON TRM.ROUTE_ID = TR.ROUTE_ID "+
			                                                      " INNER JOIN AMS.dbo.TERMINAL_DETAILS TD ON TRM.TERMINAL_ID = TD.ID "+
			                                                      " INNER JOIN FMS.dbo.Vehicle_Model VM ON  TRM.VEHICLE_MODEL_ID = VM.ModelTypeId "+
			                                                      " INNER JOIN AMS.dbo.ASSET_SEATING_STRUCTURE AST ON AST.STRUCTURE_ID = TRM.SEATING_STRUCTURE_ID "+
			                                                      " WHERE TRM.RATE_ID = ? AND SM.SERVICE_ID = ? AND TD.ID = ? AND SM.SYSTEM_ID = ? AND SM.CUSTOMER_ID = ? ";

		   public static final String CHECK_COUPON_CODE = " SELECT * FROM AMS.dbo.PREPAID_CARD_MASTER "+
		                                                  " WHERE EMAIL_ID = ? AND COUPON_CODE = ?  AND PENDING_AMOUNT > 0 "+
				                                          " AND COUPON_GEN_MODE != 'prepaid' AND STATUS = 'OPEN' "+
				                                          " AND ((CASE WHEN COUPON_GEN_MODE = 'open' "+
				                                          " THEN DATEDIFF(day,INSERTED_DATETIME,GETUTCDATE())"+
				                                          " ELSE NULL END) <= 30 "+
				                                          " OR (CASE WHEN COUPON_GEN_MODE = 'cancel' "+
				                                          " THEN DATEDIFF(day,INSERTED_DATETIME,GETUTCDATE())"+
				                                          " ELSE NULL END) > = 0 )";       
			   
			   //" SELECT * FROM AMS.dbo.PREPAID_CARD_MASTER WHERE EMAIL_ID = ? AND COUPON_CODE = ? AND STATUS = 'OPEN' AND COUPON_GEN_MODE != 'prepaid' AND ( DATEDIFF(day,INSERTED_DATETIME,GETUTCDATE()))<= 30 ";

		   public static final String CHECK_COUPON_CODE_FOR_PRE_PAID_CARD = " SELECT * FROM AMS.dbo.PREPAID_CARD_MASTER WHERE EMAIL_ID = ? AND COUPON_CODE = ? AND STATUS = 'OPEN' AND COUPON_GEN_MODE = 'prepaid' AND PENDING_AMOUNT > 0 ";
		   
		   public static final String DEDUCT_THE_AMOUNT_FROM_PREPAID_CARD_MASTER = " UPDATE AMS.dbo.PREPAID_CARD_MASTER SET  PENDING_AMOUNT = PENDING_AMOUNT - ? WHERE EMAIL_ID = ? AND COUPON_CODE = ? ";

		   public static final String DEDUCT_THE_AMOUNT_FROM_PREPAID_CARD_MASTER_FOR_COUPON_CODE = " UPDATE AMS.dbo.PREPAID_CARD_MASTER SET  PENDING_AMOUNT = PENDING_AMOUNT - ?,STATUS = 'CLOSE' WHERE EMAIL_ID = ? AND COUPON_CODE = ? ";
		   
		   public static final String INSERT_INTO_TRANSACTION_DETAILS_TABEL = " INSERT INTO AMS.dbo.TRANSACTION_DETAILS (TRANSACTION_REF_ID,JOURNEY_DATE,TERMINAL_NAME, "+   
				                                                               " ROUTE_NAME,SOURCE,DESTINATION,DISTANCE,DURATION,DEPARTURE_TIME,ARRIVAL_TIME,VEHICLE_MODEL, "+
				                                                               " SEATING_STRUCTURE,DAY_TYPE,[SERVICE_NAME],REGISTRATION_NUMBER, "+
				                                                               " NUMBER_OF_SEATS,AMOUNT,INSERTED_DATETIME,SERVICE_ID,TICKET_RATE) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,GETUTCDATE(),?,?) ";
		   
		    public static final String INSERT_INTO_PASSANGER_DETAILS = " INSERT INTO AMS.dbo.PASSANGER_DETAILS (TRANSACTION_ID,SEAT_NUMBER,PASSANGER_NAME,AGE,GENDER,PHONE_NUMBER,EMAIL_ID,INSERTED_DATETIME,SERVICE_ID ) VALUES ( ?,?,?,?,?,?,?,getUtcDate(),? )  ";

		    public static final String UPDATE_SUCCESS_STATUS_IN_TRANSACTION_MASTER = "  UPDATE  AMS.dbo.TRANSACTION_MASTER SET TRANSACTION_STATUS = ?  WHERE TRANSACTION_REF_ID  = ?   ";

		    public static final String DELETE_DETAILS_FROM_TEMP_TABLE_AFTER_TRANSACTION = " DELETE AMS.dbo.TEMPORARY_TRANSACTION WHERE TEMP_ID = ? ";
		    
		    public static final String DELETE_DETAILS_FROM_TEMP_TABLE_AFTER_TRANSACTION_FOR_ROUND_TRIP = " DELETE AMS.dbo.TEMPORARY_TRANSACTION WHERE TEMP_ID in( ?,? ) ";

		    public static final String GET_DETAILS_FROM_TEMP_TABLE = " SELECT TOTAL_SEAT_SELECTED,RATE_ID,SERVICE_ID,CONVERT(VARCHAR(10), JOURNEY_DATE,105) AS JOURNEY_DATE,SELECTED_SEATS,TERMINAL_ID FROM AMS.dbo.TEMPORARY_TRANSACTION WHERE TEMP_ID = ?";
		      
		    
			public static final String INSERT_INTO_TRANSACTION_MASTER_FOR_SPLIT_PAYMENT = " INSERT INTO AMS.dbo.TRANSACTION_MASTER ( TRANSACTION_REF_ID,TICKET_NUMBER,PAYMENT_MODE,IS_ROUND_TRIP,TOTAL_AMOUNT,COUPON_CODE,TRANSACTION_STATUS,PRI_PAYMENT_AMOUNT,SEC_PAYMENT_MODE,SEC_COUPON_CODE,SEC_PAYMENT_AMOUNT,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,PHONE_NUMBER,EMAIL_ID,BOOKED_BY  ) VALUES ( ?,?,?,?,?,?,'pending',?,?,?,?,?,?,?,?,?,'web')";
		    
			public static final String DEDUCT_THE_AMOUNT_FROM_PREPAID_CARD_MASTER_SPLIT_PAYMENT = " UPDATE AMS.dbo.PREPAID_CARD_MASTER SET  PENDING_AMOUNT = PENDING_AMOUNT - ? WHERE  COUPON_CODE = ? ";

			public static final String DEDUCT_THE_AMOUNT_FROM_PREPAID_CARD_MASTER_FOR_COUPON_CODE_SPLIT_PAYMENT = " UPDATE AMS.dbo.PREPAID_CARD_MASTER SET  PENDING_AMOUNT = PENDING_AMOUNT - ?,STATUS = 'CLOSE' WHERE  COUPON_CODE = ? ";
			  
		    public static final String CHECK_TRANSACTION_ID_TO_AVOID_DUPLICATE = "  SELECT TRANSACTION_REF_ID FROM AMS.dbo.TRANSACTION_MASTER WHERE  TRANSACTION_REF_ID = ? ";
		    
		    // -------------------------------------------For Cancel Ticket----------------------------------------------
			   
			public static final String GET_TRANSACTION_DETAILS="select td.JOURNEY_DATE,td.TERMINAL_NAME,td.VEHICLE_MODEL,td.SOURCE,td.DESTINATION,td.SERVICE_ID from AMS.dbo.TRANSACTION_MASTER tm "+
																	"inner join AMS.dbo.TRANSACTION_DETAILS  td on tm.TRANSACTION_REF_ID=td.TRANSACTION_REF_ID "+	
																	"inner join  AMS.dbo.PASSANGER_DETAILS pd on td.TRANSACTION_REF_ID=pd.TRANSACTION_ID and td.SERVICE_ID=pd.SERVICE_ID "+ 
																	"inner join AMS.dbo.System_Master sm on sm.System_id=tm.SYSTEM_ID "+
																	"where tm.TRANSACTION_REF_ID=? and tm.PHONE_NUMBER=? and tm.EMAIL_ID=? and tm.TRANSACTION_STATUS='success' and tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? and " +
																	"DATEDIFF(mi,dateadd(mi,cast(sm.OffsetMin as int),getutcdate()),dateadd(hh,cast(SUBSTRING(DEPARTURE_TIME,1,2) as int),dateadd(mi,cast(SUBSTRING(DEPARTURE_TIME,4,LEN(DEPARTURE_TIME)) as int),JOURNEY_DATE)))>0 order by td.JOURNEY_DATE" ;
			   
			   
			public static final String GET_SEATS_FROM_TRANSACTION_DETAILS="select tm.IS_ROUND_TRIP,td.SERVICE_ID,pd.SEAT_NUMBER,pd.PASSANGER_NAME,tm.TOTAL_AMOUNT from AMS.dbo.TRANSACTION_MASTER tm "+
																			"inner join AMS.dbo.TRANSACTION_DETAILS  td on tm.TRANSACTION_REF_ID=td.TRANSACTION_REF_ID "+ 
																			"inner join  AMS.dbo.PASSANGER_DETAILS pd on td.TRANSACTION_REF_ID=pd.TRANSACTION_ID and td.SERVICE_ID=pd.SERVICE_ID "+ 
																			"where tm.TRANSACTION_REF_ID=? and tm.TRANSACTION_STATUS='success' order by td.JOURNEY_DATE";
					  
			public static final String INSERT_CANCEL_PREPAID_CARD_DETAILS = "insert into AMS.dbo.PREPAID_CARD_MASTER(COUPON_CODE,CARD_HOLDER_NAME,MOBILE_NUMBER,EMAIL_ID,AMOUNT,PENDING_AMOUNT,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,STATUS,COUPON_GEN_MODE) "
				     +" values(?,?,?,?,?,?,?,?,?,getutcdate(),'OPEN','cancel')";		   
			
			
			public static final String GET_PARTIAL_CANCEL_TRIP_DETAILS="select td.JOURNEY_DATE,td.NUMBER_OF_SEATS,td.AMOUNT,tm.IS_ROUND_TRIP,pd.PASSANGER_NAME,td.TICKET_RATE from AMS.dbo.TRANSACTION_DETAILS td "+
																		"inner join AMS.dbo.TRANSACTION_MASTER tm on tm.TRANSACTION_REF_ID=td.TRANSACTION_REF_ID "+
																		"inner join  AMS.dbo.PASSANGER_DETAILS pd on td.TRANSACTION_REF_ID=pd.TRANSACTION_ID and td.SERVICE_ID=pd.SERVICE_ID "+
																		"where td.TRANSACTION_REF_ID=? and td.JOURNEY_DATE=? and td.SERVICE_ID=?";
			
			public static final String UPDATE_TRANSACTION_DETAILS="update AMS.dbo.TRANSACTION_DETAILS set NUMBER_OF_SEATS=?,AMOUNT=AMOUNT-? where TRANSACTION_REF_ID=? and SERVICE_ID=? and JOURNEY_DATE=?";
			
			public static final String UPDATE_TRANSACTION_DETAILS_WITH_NO_AMOUNT="update AMS.dbo.TRANSACTION_DETAILS set NUMBER_OF_SEATS=? where TRANSACTION_REF_ID=? and SERVICE_ID=? and JOURNEY_DATE=?";
			
			public static final String INSERT_INTO_TRANSACTION_HISTORY_WITH_NO_AMOUNT="insert into AMS.dbo.TRANSACTION_HISTORY(TRANSACTION_REF_ID,JOURNEY_DATE,PERCENTAGE,NUMBER_OF_SEATS,AMOUNT_REFUNDED,TOTAL_AMOUNT,SERVICE_ID,SEAT_NUMBERS) values(?,?,0,?,0,?,?,?) ";
			
			public static final String INSERT_INTO_TRANSACTION_HISTORY_FOR_SINGLE_TRIP_CANCEL="insert into AMS.dbo.TRANSACTION_HISTORY(TRANSACTION_REF_ID,JOURNEY_DATE,PERCENTAGE,NUMBER_OF_SEATS,AMOUNT_REFUNDED,TOTAL_AMOUNT,SERVICE_ID,SEAT_NUMBERS,COUPON_CODE) values (?,?,?,?,?,?,?,?,?)";
			
			public static final String UPDATE_TRANSACTION_MASTER="update AMS.dbo.TRANSACTION_MASTER set IS_ROUND_TRIP=?,TOTAL_AMOUNT=TOTAL_AMOUNT-? where TRANSACTION_REF_ID=?";
			
			public static final String UPDATE_TRANSACTION_MASTER_FOR_ROUND_TRIP_CANCEL="update AMS.dbo.TRANSACTION_MASTER set IS_ROUND_TRIP=? where TRANSACTION_REF_ID=?";
			
			public static final String UPDATE_TRANSCATION_MASTER_FOR_ROUND_TRIP_WITH_CANCEL="update AMS.dbo.TRANSACTION_MASTER set TRANSACTION_STATUS='cancel',IS_ROUND_TRIP=? where TRANSACTION_REF_ID=?";
																										   
		    public static final String UPDATE_TRANSACTION_MASTER_FOR_CANCEL_TICKET = "update AMS.dbo.TRANSACTION_MASTER set TRANSACTION_STATUS='cancel',IS_ROUND_TRIP=?,TOTAL_AMOUNT=TOTAL_AMOUNT-? where TRANSACTION_REF_ID=?";
			
		    
		    // -------------------------------------------For Update Trip----------------------------------------------
		    
		    
		    public static final String CHECK_TRIP_NO= " select TRANSACTION_REF_ID,EMAIL_ID,PHONE_NUMBER from  dbo.TRANSACTION_MASTER  where EMAIL_ID=? and PHONE_NUMBER=? and TRANSACTION_REF_ID=? and SYSTEM_ID = ? and CUSTOMER_ID  = ? and TRANSACTION_STATUS='success' ";
			    
			public static final String UPDATE_TRIP_DETAILS= " update AMS.dbo.TRANSACTION_MASTER set PHONE_NUMBER=?, EMAIL_ID=? where TRANSACTION_REF_ID=? and TRANSACTION_STATUS='success' ";
			
		    // -------------------------------------------For Open Trip----------------------------------------------

			public static final String INSERT_INTO_TRANSACTION_HISTORY_FOR_OPEN_TICKET="insert into AMS.dbo.TRANSACTION_HISTORY(TRANSACTION_REF_ID,JOURNEY_DATE,PERCENTAGE,NUMBER_OF_SEATS,AMOUNT_REFUNDED,TOTAL_AMOUNT,SERVICE_ID,SEAT_NUMBERS,COUPON_CODE) values (?,?,100,?,?,?,?,?,?)";
			
			public static final String INSERT_OPEN_PREPAID_CARD_DETAILS = "insert into AMS.dbo.PREPAID_CARD_MASTER(COUPON_CODE,CARD_HOLDER_NAME,MOBILE_NUMBER,EMAIL_ID,AMOUNT,PENDING_AMOUNT,SYSTEM_ID,CUSTOMER_ID,INSERTED_BY,INSERTED_DATETIME,STATUS,COUPON_GEN_MODE) "
			     +" values(?,?,?,?,?,?,?,?,?,getutcdate(),'OPEN','open')";		   

		    public static final String CHECK_TRANSACTION_WITH_OPEN_COUPON_CODE="select * from AMS.dbo.TRANSACTION_MASTER where TRANSACTION_REF_ID=?";
		    
		    public static final String CHECK_COUPON_CODE_WITH_OPEN="select * from AMS.dbo.PREPAID_CARD_MASTER where COUPON_CODE=? and COUPON_GEN_MODE='open' and SYSTEM_ID=? and CUSTOMER_ID=?";
		    
		    public static final String UPDATE_TRANSACTION_MASTER_TO_OPEN="update AMS.dbo.TRANSACTION_MASTER set TRANSACTION_STATUS='open',IS_ROUND_TRIP=?,TOTAL_AMOUNT=TOTAL_AMOUNT-? where TRANSACTION_REF_ID=?";
		    
		    public static final String UPDATE_TRANSACTION_MASTER_FOR_USED_COUPON_CODE="update AMS.dbo.TRANSACTION_MASTER set TRANSACTION_STATUS='open',IS_ROUND_TRIP=? where TRANSACTION_REF_ID=?";
		    
		    //-----------------------------------------------------------------------------------vikas-----------
		    public static final String GET_TICKETS_COUNT_BY_DAYS="select count(tm.TICKET_NUMBER) AS TICKET_COUNT,SUBSTRING ( DATENAME(dw,tm.INSERTED_DATETIME) ,0 , 4 ) as WEEKDAY "+
																"from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on "+
																"tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+ 
																"and tm.INSERTED_DATETIME between dateadd(dd,-7,getdate()) and getdate() "+
																"group by CONVERT(VARCHAR(10), tm.INSERTED_DATETIME, 111),DATENAME(dw,tm.INSERTED_DATETIME) "+ 
																"order by CONVERT(VARCHAR(10), tm.INSERTED_DATETIME, 111) DESC";
		    
		    public static final String GET_TICKETS_COUNT_BY_MONTHS="select count(tm.TICKET_NUMBER) AS TICKET_COUNT,SUBSTRING ( DATENAME(month,tm.INSERTED_DATETIME) ,0,4) as MONTHNAME "+ 
																"from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on "+
																"tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+
																"and tm.INSERTED_DATETIME between dateadd(dd,-365,getdate()) and getdate() "+ 
																"group by DATENAME(month,tm.INSERTED_DATETIME) "+
																"order by DATENAME(month,tm.INSERTED_DATETIME) asc";
		    
		    public static final String GET_TICKETS_COUNT_BY_WEB_AND_MOBILE="SELECT SUBSTRING ( piv.JOURNEY_DATE,0,4) as JOURNEY_DATE,isnull(piv.web,0) as web,isnull(piv.mobile,0) as mobile "+
																		"FROM ( "+
																		"select count(isNull(tm.TICKET_NUMBER,0)) AS TICKET_COUNT,tm.BOOKED_BY as BOOKED_BY,DATENAME(dw ,td.JOURNEY_DATE) as JOURNEY_DATE "+
																		"from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on "+
																		"tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+
																		"and tm.BOOKED_BY  = 'web' and td.JOURNEY_DATE between dateadd(dw,-7,getdate()) and getdate() "+
																		"group by tm.BOOKED_BY,DATENAME(dw ,td.JOURNEY_DATE) "+
																		"union "+
																		"select count(isNull(tm.TICKET_NUMBER,0)) AS TICKET_COUNT,tm.BOOKED_BY,DATENAME(dw ,td.JOURNEY_DATE) as JOURNEY_DATE "+
																		"from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on "+
																		"tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+
																		"and tm.BOOKED_BY  = 'mobile' and td.JOURNEY_DATE  between dateadd(dw,-7,getdate()) and getdate() "+
																		"group by tm.BOOKED_BY,DATENAME(dw ,td.JOURNEY_DATE) "+
																		") as s "+
																		"PIVOT "+
																		"( "+
																		 " SUM(TICKET_COUNT) "+
																		  "FOR [BOOKED_BY] IN ([web],[mobile]) "+
																		") AS piv";
		    
		    public static final String GET_TICKETS_COUNT_BY_ROUTE="SELECT Top 5 ROUTE_NAME, COUNT(ROUTE_NAME) as TICKET_COUNT "+
																"FROM AMS.dbo.TRANSACTION_DETAILS td "+
																"inner join AMS.dbo.TRANSACTION_MASTER tm on tm.TRANSACTION_REF_ID=td.TRANSACTION_REF_ID "+
																"where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? and td.INSERTED_DATETIME between DATEADD(mm, DATEDIFF(mm, 0, getutcdate()), 0) and getutcdate() "+
																"GROUP BY "+
																"ROUTE_NAME "+
																"HAVING "+
																"COUNT(ROUTE_NAME) > 1 "+
																"order by TICKET_COUNT desc";
//_____________________________________________ FOR TICKET SUMMARY REPORT _____________________________________________
		    
		    public static final String GET_ROUTE_WISE_TICKET_SUMMARY =  " select isnull(  CONVERT(VARCHAR(11), sv.DATE_TIME ,103),'') as SCHEDULED_DATE ,count(DISTINCT isnull( sv.SERVICE_ID,0)) AS NO_OF_BUS, "+
		    															" isnull(tm.TERMINAL_NAME,'') as TERMINAL_NAME ,isnull( tr.ROUTE_NAME , '' ) as ROUTE_NAME,count(DISTINCT tsm.TICKET_NUMBER) AS TICKET_COUNT "+ 
		    															" from AMS.dbo.VEHICLE_SERVICE_ASSOCIATION  sv "+
		    															" inner join AMS.dbo.SERVICE_MASTER  sm on sm.SERVICE_ID  = sv.SERVICE_ID "+
		    															" inner join AMS.dbo.TERMINAL_DETAILS tm  on sm.TERMINAL_ID  = tm.ID "+
		    															" inner join AMS.dbo.TERMINAL_ROUTE_MASTER tr on sm.ROUTE_ID = tr.ROUTE_ID "+
		    															" left outer join AMS.dbo.TRANSACTION_DETAILS td on sv.DATE_TIME = td.JOURNEY_DATE and sv.SERVICE_ID = td.SERVICE_ID "+
		    															" inner join AMS.dbo.TRANSACTION_MASTER tsm on tsm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID "+
		    															" where sv.SYSTEM_ID = ? and sv.CUSTOMER_ID = ? and sv.DATE_TIME between ? and ? and tsm.TRANSACTION_STATUS = 'success' "+ 
		    															" group by sv.DATE_TIME,tm.TERMINAL_NAME,tr.ROUTE_NAME " ;
		   
		    public static final String GET_DAILY_TICKET_SOLD_BY_WEB_MOBILE = " SELECT CONVERT(VARCHAR(11), piv.[JOURNEY_DATE],103) as JOURNEY_DATE ,isnull(piv.[web-user],0) as WEB_USER, isnull(piv.[web-consumer],0) as WEB_CONSUMER, isnull(piv.[mobile-user],0) as MOBILE_USER,isnull(piv.[mobile-consumer],0) as MOBILE_CONSUMER "+
                                                                             " FROM ( select count(tm.TICKET_NUMBER) AS TICKET_COUNT,tm.BOOKED_BY+'-consumer' as BOOKED_BY,td.JOURNEY_DATE "+
                                                                             " from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on  "+
                                                                             " tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+
                                                                             " and tm.BOOKED_BY  = 'web' and tm.INSERTED_BY = 0 and TRANSACTION_STATUS = 'success' and td.JOURNEY_DATE between ? and ? "+
                                                                             " group by tm.BOOKED_BY,td.JOURNEY_DATE "+
                                                                             " union  "+
                                                                             " select count(tm.TICKET_NUMBER) AS TICKET_COUNT,tm.BOOKED_BY+'-user' as BOOKED_BY,td.JOURNEY_DATE "+
                                                                             " from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on  "+
                                                                             " tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+
                                                                             " and tm.BOOKED_BY  = 'web' and  tm.INSERTED_BY != 0 and TRANSACTION_STATUS = 'success' and td.JOURNEY_DATE  between ? and ? "+
                                                                             " group by tm.BOOKED_BY,td.JOURNEY_DATE "+
                                                                             " union  "+
                                                                             " select count(tm.TICKET_NUMBER) AS TICKET_COUNT,tm.BOOKED_BY+'-consumer' as BOOKED_BY,td.JOURNEY_DATE "+
                                                                             " from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on  "+
                                                                             " tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+
                                                                             " and tm.BOOKED_BY  = 'mobile' and  tm.INSERTED_BY = 0 and TRANSACTION_STATUS = 'success' and td.JOURNEY_DATE  between ? and ? "+
                                                                             " group by tm.BOOKED_BY,td.JOURNEY_DATE "+
                                                                             " union  "+
                                                                             " select count(tm.TICKET_NUMBER) AS TICKET_COUNT,tm.BOOKED_BY+'-user' as BOOKED_BY,td.JOURNEY_DATE "+
                                                                             " from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on  "+
                                                                             " tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+
                                                                             " and tm.BOOKED_BY  = 'mobile' and tm.INSERTED_BY != 0 and TRANSACTION_STATUS = 'success' and td.JOURNEY_DATE  between ? and ? "+
                                                                             " group by tm.BOOKED_BY,td.JOURNEY_DATE  "+
                                                                             " ) as s PIVOT( SUM(TICKET_COUNT) FOR [BOOKED_BY] IN ([web-user],[web-consumer],[mobile-user],[mobile-consumer])) AS piv ";

           public static final String GET_MONTHLY_TICKET_SOLD_BY_WEB_MOBILE = " SELECT piv.MONTHYEARNAME AS MONTH_YEAR, isnull ( piv.[web-user],0) as WEB_USER, isnull( piv.[web-consumer],0) as WEB_CONSUMER,isnull ( piv.[mobile-user],0) as MOBILE_USER,isnull (piv.[mobile-consumer],0) as MOBILE_CONSUMER    FROM ( "+
           																	  " select count(tm.TICKET_NUMBER) AS TICKET_COUNT,tm.BOOKED_BY+'-consumer' as BOOKED_BY,DATENAME(month,td.JOURNEY_DATE)+'-'+DATENAME(year,td.JOURNEY_DATE) as MONTHYEARNAME "+ 
           																	  " from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on "+
                                                                              " tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? and "+
                                                                              " tm.BOOKED_BY  = 'web' and tm.INSERTED_BY = 0 and TRANSACTION_STATUS = 'success' and td.JOURNEY_DATE between ?  and ?  "+
                                                                              " group by tm.BOOKED_BY,DATENAME(month,td.JOURNEY_DATE)+'-'+DATENAME(year,td.JOURNEY_DATE) "+
                                                                              " union "+
                                                                              " select count(tm.TICKET_NUMBER) AS TICKET_COUNT,tm.BOOKED_BY+'-user' as BOOKED_BY,DATENAME(month,td.JOURNEY_DATE)+'-'+DATENAME(year,td.JOURNEY_DATE) as MONTHYEARNAME "+
                                                                              " from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on "+
                                                                              " tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? and "+
                                                                              " tm.BOOKED_BY  = 'web' and tm.INSERTED_BY != 0 and TRANSACTION_STATUS = 'success' and td.JOURNEY_DATE between ? and ? "+
                                                                              " group by tm.BOOKED_BY,tm.BOOKED_BY,DATENAME(month,td.JOURNEY_DATE)+'-'+DATENAME(year,td.JOURNEY_DATE) "+
                                                                              " union "+
                                                                              " select count(tm.TICKET_NUMBER) AS TICKET_COUNT,tm.BOOKED_BY+'-consumer' as BOOKED_BY,DATENAME(month,td.JOURNEY_DATE)+'-'+DATENAME(year,td.JOURNEY_DATE) as MONTHYEARNAME "+
                                                                              " from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on "+
                                                                              " tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? and "+
                                                                              " tm.BOOKED_BY  = 'mobile' and tm.INSERTED_BY = 0 and TRANSACTION_STATUS = 'success' and td.JOURNEY_DATE between ? and ? "+
                                                                              " group by tm.BOOKED_BY,DATENAME(month,td.JOURNEY_DATE)+'-'+DATENAME(year,td.JOURNEY_DATE) "+
                                                                              " union "+
                                                                              " select count(tm.TICKET_NUMBER) AS TICKET_COUNT,tm.BOOKED_BY+'-user' as BOOKED_BY,DATENAME(month,td.JOURNEY_DATE)+'-'+DATENAME(year,td.JOURNEY_DATE) as MONTHYEARNAME "+
                                                                              " from AMS.dbo.TRANSACTION_MASTER tm INNER JOIN AMS.dbo.TRANSACTION_DETAILS td on "+
                                                                              " tm.TRANSACTION_REF_ID = td.TRANSACTION_REF_ID where tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? and "+
                                                                              " tm.BOOKED_BY  = 'mobile' and tm.INSERTED_BY != 0 and TRANSACTION_STATUS = 'success' and td.JOURNEY_DATE between ? and ? "+
                                                                              " group by tm.BOOKED_BY,DATENAME(month,td.JOURNEY_DATE)+'-'+DATENAME(year,td.JOURNEY_DATE) "+
                                                                              " )  as s   PIVOT(SUM(TICKET_COUNT)FOR [BOOKED_BY] IN ([web-user],[web-consumer],[mobile-user],[mobile-consumer]) "+
                                                                              " ) AS piv ";

		   public static final String GET_AMOUNT_OF_TRANSACTION = " SELECT PAYMENT_MODE,PRI_PAYMENT_AMOUNT,SEC_PAYMENT_MODE,SEC_PAYMENT_AMOUNT,TOTAL_AMOUNT,COUPON_CODE FROM AMS.dbo.TRANSACTION_MASTER WHERE TRANSACTION_REF_ID = ?  ";    
		    
		   public static final String INSERT_INTO_GATEWAY_DETAILS = " INSERT INTO  AMS.dbo.PAYMENT_RESPONSE_DETAILS ( TRANSACTION_ID,AMOUNT,RESPONSE_CODE,RESPONSE_DESCRIPTION,INSERTED_DATETIME,TRANSACTION_DATE,PAYMENT_REFERENCE ) values ( ? , ? ,? , ? , getutcdate(),?,? )  ";
		   
		   public static final String UPDATE_INTO_GATEWAY_DETAILS = " UPDATE  AMS.dbo.PAYMENT_RESPONSE_DETAILS SET AMOUNT=?,RESPONSE_CODE=?,RESPONSE_DESCRIPTION=?,UPDATED_DATETIME=getutcdate(),TRANSACTION_DATE=?,PAYMENT_REFERENCE=? where TRANSACTION_ID=? ";
		   
		   public static final String CHECK_TRANSACTION_ID_ALREADY_EXIST = "select TRANSACTION_ID from  AMS.dbo.PAYMENT_RESPONSE_DETAILS WHERE TRANSACTION_ID=?";
		   
           public static final String DEDUCT_CARD_AMOUNT = " UPDATE AMS.dbo.PREPAID_CARD_MASTER SET  PENDING_AMOUNT = PENDING_AMOUNT - ?,STATUS = 'CLOSE' WHERE  COUPON_CODE = ? ";
           
    
           
           public static final String GET_VEHICLES_TICKET_DETAIS="select  a.REGISTRATION_NO as REGISTRATION_NO from gpsdata_history_latest a " +
												           		" inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id=b.System_id  " +
												           		" inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id  " +
												           		" where a.CLIENTID = ? and a.System_id =? and b.User_id=?";
												
           public static final String GET_ROUTE_NAME_TICKET_DETAIS="select ROUTE_NAME from dbo.TERMINAL_ROUTE_MASTER where CUSTOMER_ID=? and SYSTEM_ID=?";	
           
           public static final String GET_TERMINAL_NAME_TICKET_DETAIS="select TERMINAL_NAME from dbo.TERMINAL_DETAILS where CUSTOMER_ID=? and SYSTEM_ID=?";
           
           public static final String GET_TICKET_DETAIS_ROUTE_WISE="select isnull(a.JOURNEY_DATE,'')as JOURNEY_DATE,DATENAME(MONTH, a.JOURNEY_DATE) as MONTHNAME ,isnull(a.DEPARTURE_TIME,'')as DEPARTURE_TIME, " +
           		"  isnull(a.VEHICLE_MODEL,'')as VEHICLE_MODEL,isnull(a.REGISTRATION_NUMBER,'')as REGISTRATION_NO, " +
           		"  count(b.TICKET_NUMBER) as TOTAL_TICKET_SOLD,isnull(a.TERMINAL_NAME,'')as TERMINAL_NAME, " +
           		" isnull(a.SOURCE,'') as SOURCE,isnull(a.DESTINATION,'')as DESTINATION,isnull(a.DURATION,'')as DURATION,a.ROUTE_NAME " +
           		" from TRANSACTION_DETAILS a " +
           		" inner join  dbo.TRANSACTION_MASTER b on b.TRANSACTION_REF_ID=a.TRANSACTION_REF_ID " +
           		" where  JOURNEY_DATE between ? and ? " +
           		" and ROUTE_NAME in (#) and TRANSACTION_STATUS='success' and b.CUSTOMER_ID=? and b.SYSTEM_ID=? group by JOURNEY_DATE,DEPARTURE_TIME,REGISTRATION_NUMBER, " +
           		" VEHICLE_MODEL,TERMINAL_NAME,SOURCE,DESTINATION,DURATION,ROUTE_NAME";
           
           public static final String GET_TICKET_DETAIS_VEHICLE_WISE="select isnull(a.JOURNEY_DATE,'')as JOURNEY_DATE ,DATENAME(MONTH, a.JOURNEY_DATE) as MONTHNAME,isnull(a.DEPARTURE_TIME,'')as DEPARTURE_TIME, " +
      		"  isnull(a.VEHICLE_MODEL,'')as VEHICLE_MODEL,isnull(a.REGISTRATION_NUMBER,'')as REGISTRATION_NO, " +
      		"  count(b.TICKET_NUMBER) as TOTAL_TICKET_SOLD,isnull(a.TERMINAL_NAME,'')as TERMINAL_NAME, " +
      		" isnull(a.SOURCE,'') as SOURCE,isnull(a.DESTINATION,'')as DESTINATION,isnull(a.DURATION,'')as DURATION ,a.ROUTE_NAME" +
      		" from TRANSACTION_DETAILS a " +
      		" inner join  dbo.TRANSACTION_MASTER b on b.TRANSACTION_REF_ID=a.TRANSACTION_REF_ID " +
      		" where  JOURNEY_DATE between ? and ? " +
      		" and REGISTRATION_NUMBER in (#) and TRANSACTION_STATUS='success' and b.CUSTOMER_ID=? and b.SYSTEM_ID=? group by JOURNEY_DATE,DEPARTURE_TIME,REGISTRATION_NUMBER, " +
      		" VEHICLE_MODEL,TERMINAL_NAME,SOURCE,DESTINATION,DURATION,ROUTE_NAME";
           
           public static final String GET_TICKET_DETAIS_TERMINAL_WISE="select isnull(a.JOURNEY_DATE,'')as JOURNEY_DATE,DATENAME(MONTH, a.JOURNEY_DATE) as MONTHNAME ,isnull(a.DEPARTURE_TIME,'')as DEPARTURE_TIME, " +
     		"  isnull(a.VEHICLE_MODEL,'')as VEHICLE_MODEL,isnull(a.REGISTRATION_NUMBER,'')as REGISTRATION_NO, " +
     		"  count(b.TICKET_NUMBER) as TOTAL_TICKET_SOLD,isnull(a.TERMINAL_NAME,'')as TERMINAL_NAME, " +
     		" isnull(a.SOURCE,'') as SOURCE,isnull(a.DESTINATION,'')as DESTINATION,isnull(a.DURATION,'')as DURATION,a.ROUTE_NAME" +
     		" from TRANSACTION_DETAILS a " +
     		" inner join  dbo.TRANSACTION_MASTER b on b.TRANSACTION_REF_ID=a.TRANSACTION_REF_ID " +
     		" where  JOURNEY_DATE between ? and ? " +
     		" and TERMINAL_NAME in(#) and TRANSACTION_STATUS='success' and b.CUSTOMER_ID=? and b.SYSTEM_ID=? group by JOURNEY_DATE,DEPARTURE_TIME,REGISTRATION_NUMBER, " +
     		" VEHICLE_MODEL,TERMINAL_NAME,SOURCE,DESTINATION,DURATION,ROUTE_NAME ";		    
      
           public static final String GET_PROFIT_AND_LOSS_DATA_TERMINAL_WISE="select td.REGISTRATION_NUMBER,td.SERVICE_NAME,CONVERT(CHAR(10), td.JOURNEY_DATE, 120) as JOURNEY_DATE,td.ROUTE_NAME,td.TERMINAL_NAME,sum(td.NUMBER_OF_SEATS) as TOTAL_SEATS, "
        	+"sum(tm.TOTAL_AMOUNT) as TOTAL_AMOUNT,isnull(vsa.TOTAL,0) as TRIP_EXPENSE,(select sum(r.NET) from "
        	+"(select isnull(sum(ActualCost),0)as NET "
        	+"from  FMS.dbo.JobCard_In_Mstr where  RegistrationNo=td.REGISTRATION_NUMBER collate database_default and SystemId=? and ClientId=? and JobCardStatus='Closed' " 
        	+"and VehicleOutTime>= dateadd(mi,-?,td.JOURNEY_DATE)  and VehicleOutTime<dateadd(mi,1440,dateadd(mi,-?,td.JOURNEY_DATE)) "
        	+"union all "
        	+"select isnull(sum(ActualCost),0)as NET "
        	+"from FMS.dbo.JobCard_Ext_Mstr where  RegistrationNo=td.REGISTRATION_NUMBER collate database_default and SystemId=? and ClientId=? and JobCardStatus='Closed'  "
        	+"and VehicleOutTime>= dateadd(mi,-?,td.JOURNEY_DATE)  and VehicleOutTime<dateadd(mi,1440,dateadd(mi,-?,td.JOURNEY_DATE)))r) as MAINTANENCE_EXPENSE "
        	+"from AMS.dbo.TRANSACTION_MASTER tm "
        	+"inner join AMS.dbo.TRANSACTION_DETAILS td on tm.TRANSACTION_REF_ID=td.TRANSACTION_REF_ID  "
        	+"left outer join AMS.dbo.VEHICLE_SERVICE_ASSOCIATION vsa on vsa.SERVICE_ID=td.SERVICE_ID and vsa.DATE_TIME=td.JOURNEY_DATE "
        	+"where TRANSACTION_STATUS in ('success','open','cancel') and JOURNEY_DATE>= ? and JOURNEY_DATE<? and td.REGISTRATION_NUMBER<>''  and td.TERMINAL_NAME in(#) and tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "
        	+"group by td.SERVICE_NAME,td.ROUTE_NAME,td.TERMINAL_NAME,td.JOURNEY_DATE,td.REGISTRATION_NUMBER,vsa.TOTAL order by td.JOURNEY_DATE desc";
           
           public static final String GET_MONTHLY_PROFIT_AND_LOSS_DATA_TERMINAL_WISE="select temp.REGISTRATION_NUMBER,count(temp.SERVICE_NAME) as DAYS_OPERATED,temp.MONTHNAME,temp.MONTH_NUMBER,sum(temp.TOTAL_SEATS) as TOTAL_SEATS,sum(temp.TOTAL_AMOUNT) as TOTAL_AMOUNT, " +
      		"sum(temp.TRIP_EXPENSE) as TRIP_EXPENSE,temp.TERMINAL_NAME from (select td.REGISTRATION_NUMBER,td.TERMINAL_NAME,td.SERVICE_NAME,month( td.JOURNEY_DATE) as MONTH_NUMBER,DATENAME(MONTH, td.JOURNEY_DATE) as MONTHNAME , sum(td.NUMBER_OF_SEATS) as TOTAL_SEATS, "+
       		"sum(tm.TOTAL_AMOUNT) as TOTAL_AMOUNT,isnull(vsa.TOTAL,0) as TRIP_EXPENSE "+
       		"from AMS.dbo.TRANSACTION_MASTER tm "+
       		"inner join AMS.dbo.TRANSACTION_DETAILS td on tm.TRANSACTION_REF_ID=td.TRANSACTION_REF_ID  "+
       		"left outer join AMS.dbo.VEHICLE_SERVICE_ASSOCIATION vsa on vsa.SERVICE_ID=td.SERVICE_ID and vsa.DATE_TIME=td.JOURNEY_DATE "+
       		"where TRANSACTION_STATUS in ('success','open','cancel') and JOURNEY_DATE >= DATEADD(month,?-1,DATEADD(year,?-1900,0))  and JOURNEY_DATE<DATEADD(month,?,DATEADD(year,?-1900,0)) and td.REGISTRATION_NUMBER<>''  and td.TERMINAL_NAME in(#)  and tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+
       		"group by td.JOURNEY_DATE,td.TERMINAL_NAME,td.REGISTRATION_NUMBER,vsa.TOTAL,td.SERVICE_NAME) temp "+
       		"group by temp.REGISTRATION_NUMBER,temp.MONTHNAME,temp.MONTH_NUMBER,temp.TERMINAL_NAME "+
       		"having  count(MONTH_NUMBER)>=1";
      
           public static final String GET_PROFIT_AND_LOSS_DATA_ROUTE_WISE="select td.REGISTRATION_NUMBER,td.SERVICE_NAME,CONVERT(CHAR(10), td.JOURNEY_DATE, 120) as JOURNEY_DATE,td.ROUTE_NAME,td.TERMINAL_NAME,sum(td.NUMBER_OF_SEATS) as TOTAL_SEATS, "
        	+"sum(tm.TOTAL_AMOUNT) as TOTAL_AMOUNT,isnull(vsa.TOTAL,0) as TRIP_EXPENSE,(select sum(r.NET) from "
        	+"(select isnull(sum(ActualCost),0)as NET "
        	+"from  FMS.dbo.JobCard_In_Mstr where  RegistrationNo=td.REGISTRATION_NUMBER collate database_default and SystemId=? and ClientId=? and JobCardStatus='Closed' " 
        	+"and VehicleOutTime>=dateadd(mi,-?,td.JOURNEY_DATE)  and VehicleOutTime<dateadd(mi,1440,dateadd(mi,-?,td.JOURNEY_DATE)) "
        	+"union all "
        	+"select isnull(sum(ActualCost),0)as NET "
        	+"from FMS.dbo.JobCard_Ext_Mstr where  RegistrationNo=td.REGISTRATION_NUMBER collate database_default and SystemId=? and ClientId=? and JobCardStatus='Closed'  "
        	+"and VehicleOutTime>=dateadd(mi,-?,td.JOURNEY_DATE)  and VehicleOutTime<dateadd(mi,1440,dateadd(mi,-?,td.JOURNEY_DATE)))r) as MAINTANENCE_EXPENSE "
        	+"from AMS.dbo.TRANSACTION_MASTER tm "
        	+"inner join AMS.dbo.TRANSACTION_DETAILS td on tm.TRANSACTION_REF_ID=td.TRANSACTION_REF_ID  "
        	+"left outer join AMS.dbo.VEHICLE_SERVICE_ASSOCIATION vsa on vsa.SERVICE_ID=td.SERVICE_ID and vsa.DATE_TIME=td.JOURNEY_DATE "
        	+"where TRANSACTION_STATUS in ('success','open','cancel') and JOURNEY_DATE>= ? and JOURNEY_DATE<? and td.REGISTRATION_NUMBER<>''  and td.ROUTE_NAME in(#) and tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "
        	+"group by td.SERVICE_NAME,td.ROUTE_NAME,td.TERMINAL_NAME,td.JOURNEY_DATE,td.REGISTRATION_NUMBER,vsa.TOTAL order by td.JOURNEY_DATE desc";
           
           public static final String GET_MONTHLY_PROFIT_AND_LOSS_DATA_ROUTE_WISE="select temp.REGISTRATION_NUMBER,count(temp.SERVICE_NAME) as DAYS_OPERATED,temp.MONTHNAME,temp.MONTH_NUMBER,sum(temp.TOTAL_SEATS) as TOTAL_SEATS,sum(temp.TOTAL_AMOUNT) as TOTAL_AMOUNT, " +
           		"sum(temp.TRIP_EXPENSE) as TRIP_EXPENSE,temp.TERMINAL_NAME from (select td.REGISTRATION_NUMBER,td.SERVICE_NAME,td.TERMINAL_NAME,month( td.JOURNEY_DATE) as MONTH_NUMBER,DATENAME(MONTH, td.JOURNEY_DATE) as MONTHNAME , sum(td.NUMBER_OF_SEATS) as TOTAL_SEATS, "+
           		"sum(tm.TOTAL_AMOUNT) as TOTAL_AMOUNT,isnull(vsa.TOTAL,0) as TRIP_EXPENSE "+
           		"from AMS.dbo.TRANSACTION_MASTER tm "+
           		"inner join AMS.dbo.TRANSACTION_DETAILS td on tm.TRANSACTION_REF_ID=td.TRANSACTION_REF_ID  "+
           		"left outer join AMS.dbo.VEHICLE_SERVICE_ASSOCIATION vsa on vsa.SERVICE_ID=td.SERVICE_ID and vsa.DATE_TIME=td.JOURNEY_DATE "+
           		"where TRANSACTION_STATUS in ('success','open','cancel') and JOURNEY_DATE >= DATEADD(month,?-1,DATEADD(year,?-1900,0))  and JOURNEY_DATE<DATEADD(month,?,DATEADD(year,?-1900,0)) and td.REGISTRATION_NUMBER<>''  and td.ROUTE_NAME in(#)  and tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+
           		"group by td.JOURNEY_DATE,td.REGISTRATION_NUMBER,td.TERMINAL_NAME,vsa.TOTAL,td.SERVICE_NAME) temp "+
           		"group by temp.REGISTRATION_NUMBER,temp.MONTHNAME,temp.MONTH_NUMBER,temp.TERMINAL_NAME  "+
           		"having  count(MONTH_NUMBER)>=1";
      
           public static final String GET_MONTHLY_PROFIT_AND_LOSS_DATA_VEHICLE_WISE="select temp.REGISTRATION_NUMBER,count(temp.SERVICE_NAME) as DAYS_OPERATED,temp.MONTHNAME,temp.MONTH_NUMBER,sum(temp.TOTAL_SEATS) as TOTAL_SEATS,sum(temp.TOTAL_AMOUNT) as TOTAL_AMOUNT, " +
      		"sum(temp.TRIP_EXPENSE) as TRIP_EXPENSE,temp.TERMINAL_NAME from (select td.REGISTRATION_NUMBER,td.SERVICE_NAME,td.TERMINAL_NAME,month( td.JOURNEY_DATE) as MONTH_NUMBER,DATENAME(MONTH, td.JOURNEY_DATE) as MONTHNAME , sum(td.NUMBER_OF_SEATS) as TOTAL_SEATS, "+
       		"sum(tm.TOTAL_AMOUNT) as TOTAL_AMOUNT,isnull(vsa.TOTAL,0) as TRIP_EXPENSE "+
       		"from AMS.dbo.TRANSACTION_MASTER tm "+
       		"inner join AMS.dbo.TRANSACTION_DETAILS td on tm.TRANSACTION_REF_ID=td.TRANSACTION_REF_ID  "+
       		"left outer join AMS.dbo.VEHICLE_SERVICE_ASSOCIATION vsa on vsa.SERVICE_ID=td.SERVICE_ID and vsa.DATE_TIME=td.JOURNEY_DATE "+
       		"where TRANSACTION_STATUS in ('success','open','cancel') and JOURNEY_DATE>=DATEADD(month,?-1,DATEADD(year,?-1900,0))  and JOURNEY_DATE<DATEADD(month,?,DATEADD(year,?-1900,0)) and td.REGISTRATION_NUMBER<>''  and td.REGISTRATION_NUMBER in(#) and tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "+
       		"group by td.JOURNEY_DATE,td.REGISTRATION_NUMBER,td.TERMINAL_NAME,vsa.TOTAL,td.SERVICE_NAME) temp "+
       		"group by temp.REGISTRATION_NUMBER,temp.MONTHNAME,temp.MONTH_NUMBER,temp.TERMINAL_NAME  "+
       		"having  count(MONTH_NUMBER)>=1";
           
           public static final String GET_PROFIT_AND_LOSS_DATA_VEHICLE_WISE="select td.REGISTRATION_NUMBER,td.SERVICE_NAME,CONVERT(CHAR(10), td.JOURNEY_DATE, 120) as JOURNEY_DATE,td.ROUTE_NAME,td.TERMINAL_NAME,sum(td.NUMBER_OF_SEATS) as TOTAL_SEATS, "
        	+"sum(tm.TOTAL_AMOUNT) as TOTAL_AMOUNT,isnull(vsa.TOTAL,0) as TRIP_EXPENSE,(select sum(r.NET) from "
        	+"(select isnull(sum(ActualCost),0)as NET "
        	+"from  FMS.dbo.JobCard_In_Mstr where  RegistrationNo=td.REGISTRATION_NUMBER collate database_default and SystemId=? and ClientId=? and JobCardStatus='Closed' " 
        	+"and VehicleOutTime>=dateadd(mi,-?,td.JOURNEY_DATE)  and VehicleOutTime<dateadd(mi,1439,dateadd(mi,-?,td.JOURNEY_DATE)) "
        	+"union all "
        	+"select isnull(sum(ActualCost),0)as NET "
        	+"from FMS.dbo.JobCard_Ext_Mstr where  RegistrationNo=td.REGISTRATION_NUMBER collate database_default and SystemId=? and ClientId=? and JobCardStatus='Closed'  "
        	+"and VehicleOutTime>=dateadd(mi,-?,td.JOURNEY_DATE)  and VehicleOutTime<dateadd(mi,1439,dateadd(mi,-?,td.JOURNEY_DATE)))r) as MAINTANENCE_EXPENSE "
        	+"from AMS.dbo.TRANSACTION_MASTER tm "
        	+"inner join AMS.dbo.TRANSACTION_DETAILS td on tm.TRANSACTION_REF_ID=td.TRANSACTION_REF_ID  "
        	+"left outer join AMS.dbo.VEHICLE_SERVICE_ASSOCIATION vsa on vsa.SERVICE_ID=td.SERVICE_ID and vsa.DATE_TIME=td.JOURNEY_DATE "
        	+"where TRANSACTION_STATUS in ('success','open','cancel') and JOURNEY_DATE>=? and JOURNEY_DATE<? and td.REGISTRATION_NUMBER<>''  and td.REGISTRATION_NUMBER in(#) and tm.SYSTEM_ID=? and tm.CUSTOMER_ID=? "
        	+"group by td.SERVICE_NAME,td.TERMINAL_NAME,td.ROUTE_NAME,td.JOURNEY_DATE,td.REGISTRATION_NUMBER,vsa.TOTAL order by td.JOURNEY_DATE desc";
     
           public static final String GET_ACTUAL_AMOUNT="select RegistrationNo,ActualCost,CONVERT (CHAR(10),dateadd(mi,?,VehicleOutTime),120) as CLOSED_DATE from FMS.dbo.JobCard_In_Mstr  "
        	   	+"where RegistrationNo in(#) and JobCardStatus='Closed'  and VehicleOutTime>=dateadd(mi,-?, ?) and VehicleOutTime<dateadd(mi,-?,?) and SystemId=? and ClientId=? "
        	   	+"union all  "
        	   	+"select RegistrationNo,ActualCost,CONVERT (CHAR(10),dateadd(mi,?,VehicleOutTime),120) as CLOSED_DATE from FMS.dbo.JobCard_Ext_Mstr  "
        	   	+"where RegistrationNo in (#) and JobCardStatus='Closed'  and VehicleOutTime>=dateadd(mi,-?, ?) and VehicleOutTime<dateadd(mi,-?,?) and SystemId=? and ClientId=? ";
           
           public static final String GET_MONTHLY_ACTUAL_AMOUNT="select r.RegistrationNo,sum(ActualCost) as ActualCost,r.CLOSED_DATE from "
        	   +"(select RegistrationNo,ActualCost, month(dateadd(mi,?,VehicleOutTime)) as CLOSED_DATE from FMS.dbo.JobCard_In_Mstr "
        	   +"where RegistrationNo in (#) and JobCardStatus='Closed'  and VehicleOutTime>=dateadd(mi,-?,DATEADD(month,?-1,DATEADD(year,?-1900,0))) and VehicleOutTime<dateadd(mi,-?,DATEADD(month,?,DATEADD(year,?-1900,0)))  and SystemId=? and ClientId=? "
        	   +"union all  "
        	   +"select RegistrationNo,ActualCost,month(dateadd(mi,?,VehicleOutTime)) as CLOSED_DATE from FMS.dbo.JobCard_Ext_Mstr "
        	   +"where RegistrationNo in (#) and JobCardStatus='Closed'  and VehicleOutTime>=dateadd(mi,-?,DATEADD(month,?-1,DATEADD(year,?-1900,0)))  and  VehicleOutTime<dateadd(mi,-?,DATEADD(month,?,DATEADD(year,?-1900,0))) and SystemId=? and ClientId=? ) r "
        	   +"group by r.RegistrationNo,r.CLOSED_DATE "
        	   +"having count(r.CLOSED_DATE)>=1"; 
           
           //***************************************STATEMENTS FOR INTERSWITCH TRANSACTION DETAILS*********************
           public static final String GET_INTERSWITCH_TRANSACTION_DETAILS=   " select tm.TRANSACTION_REF_ID,tm.PHONE_NUMBER,tm.EMAIL_ID,tm.TRANSACTION_STATUS,isnull(prd.RESPONSE_CODE,'') as RESPONSE_CODE, "+  
        	   																 " isnull(prd.RESPONSE_DESCRIPTION,'') as RESPONSE_DESCRIPTION,isnull(prd.TRANSACTION_DATE,'') as TRANSACTION_DATE,tm.INSERTED_DATETIME "+  
        	   																 " from AMS.dbo.TRANSACTION_MASTER tm  "+ 
        	   																 " left outer join AMS.dbo.PAYMENT_RESPONSE_DETAILS prd on prd.TRANSACTION_ID=tm.TRANSACTION_REF_ID  "+  
        	   																 " WHERE SYSTEM_ID=? and CUSTOMER_ID=? and tm.INSERTED_DATETIME between ? and ? "+ 
        	   																 " and tm.TRANSACTION_STATUS in( 'pending','success','failed') and ( PAYMENT_MODE='debitcard' or SEC_PAYMENT_MODE='debitcard') ";

           

           //***************************************STATEMENTS FOR  TRANSACTION REQUERY DETAILS*********************
           public static final String GET_TRANSACTION_REQUERY_DETAILS="select tm.TRANSACTION_REF_ID,tm.TRANSACTION_STATUS,tm.PHONE_NUMBER,tm.EMAIL_ID from AMS.dbo.TRANSACTION_MASTER tm " +
																	" where TRANSACTION_STATUS = 'pending' and ( PAYMENT_MODE='debitcard' or SEC_PAYMENT_MODE='debitcard')" +  
																	" and SYSTEM_ID=? and CUSTOMER_ID=? and tm.INSERTED_DATETIME between ? and ? ";
        	    

          public static final String CHECK_SEAT_NUMBER = " SELECT SEAT_NUMBER FROM AMS.dbo.PASSANGER_DETAILS A "+
	     " INNER JOIN AMS.dbo.TRANSACTION_DETAILS B  ON A.TRANSACTION_ID = B.TRANSACTION_REF_ID AND A.SERVICE_ID = B.SERVICE_ID  "+
	     " INNER JOIN AMS.dbo.TRANSACTION_MASTER C ON A.TRANSACTION_ID = C.TRANSACTION_REF_ID "+
	     " WHERE B.SERVICE_ID = ? "+
	     " AND B.JOURNEY_DATE = ? " +
	     " AND  C.TRANSACTION_STATUS = 'success'  AND A.SEAT_NUMBER IN (#) "+
	     " OR ((CASE WHEN C.TRANSACTION_STATUS = 'pending' AND A.SEAT_NUMBER IN (#) "+
	     " THEN DATEDIFF(mi,A.INSERTED_DATETIME,GETUTCDATE())"+
	     " ELSE NULL END)< 8) ";
}
