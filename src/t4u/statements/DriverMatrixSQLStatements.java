package t4u.statements;

public class DriverMatrixSQLStatements 
 {
	 public static final String SELECT_SETTINGS="select score_setting_name,score_setting_id from score_setting_master where system_id=? and client_id=? order by score_setting_name";
	 public static final String SELECT_SETTING_VALUES="select b.setting_param_id as paramid,b.score_range as scorerange,b.score as score,"+
	 "a.overspeed_criteria as criteria,a.overspeed as overspeed from score_setting_master a,"+
	 "score_setting_association b where "+
	 "a.score_setting_id=b.setting_id and a.score_setting_id=?"+
	 " and a.system_id=? and a.system_id=b.system_id and b.setting_param_id=?";
	 
	 
	 
	 public static final String SELECT_SETTING_PARAMS="select distinct b.setting_param_id as paramid,a.overspeed_criteria as criteria," +
	 		"a.overspeed as overspeed,stoppage_start_time as stoppagestarttime,stoppage_end_time as stoppagendtime, " +
	 		"idle_start_time as idlestarttime,idle_end_time as idleendtime "+
	 		"from score_setting_master a,"+
	 "score_setting_association b where "+ 
	 "a.score_setting_id=b.setting_id and a.score_setting_id=?"+
	 " and a.system_id=? and a.system_id=b.system_id";
	 /*public static final String SELECT_SETTING_PARAMS="select distinct b.setting_param_id as paramid,a.overspeed_criteria as criteria," +
		"a.overspeed as overspeed from score_setting_master a,"+
"score_setting_association b where "+ 
"a.score_setting_id=b.setting_id and a.score_setting_id=?"+
" and a.system_id=? and a.system_id=b.system_id";*/ 
	 
	//not used any where:Nikhil
	 public static final String GET_OVERSPEED_DATA="select count(*) from HISTORY_DATA where SPEED ? and REGISTRATION_NO=? and GPS_DATETIME between ? and ?";
	 
	 public static final String GET_SETTING_PARAMS = "select setting_param_id,setting_param_name from setting_param where system_id=?";
	 
	 public static final String SELECT_SETTING_NAME="select score_setting_name as sname from score_setting_master where " +
		"upper(score_setting_name)=? and system_id=?";


public static final String SELECT_MAX_SETTING_ID="select max(score_setting_id) as sid from score_setting_master where system_id=?";
public static final String INSERT_SETTING_MASTER="insert into score_setting_master values(?,?,?,?,?,?,?,?,?,?)";

public static final String INSERT_SETTING_SCORES="insert into score_setting_association values(?,?,?,?,?)";





public static final String UPDATE_SETTING_MASTER="update score_setting_master set client_id=?,overspeed_criteria=?,overspeed=?," +
		" stoppage_start_time=?,stoppage_end_time=?,idle_start_time=?,idle_end_time=?" +
		" where score_setting_id=? and system_id=?";

public static final String DELETE_SETTING_SCORES="delete from score_setting_association where system_id=? and setting_id=?";

public static final String GET_SETTING_VALUES="SELECT score_setting_name as settingname,overspeed_criteria as criteria,overspeed as overspeed, " +
		" stoppage_start_time as stoppagestarttime,stoppage_end_time as stoppagendtime,idle_start_time as idlestarttime,idle_end_time as idleendtime " +
		"from score_setting_master where system_id=? and score_setting_id=? and client_id=?";

//added by chetana
public static final String DELETE_SETTING_MASTER="delete from score_setting_master where system_id=? and score_setting_id=?";

public static final String GET_SETTING_NAME="select score_setting_name as settingname from score_setting_master where score_setting_id=? and system_id=?";


public static final String SELECT_TRIP_DATA="select distinct a.Registration_no as regno,b.Driver_id as driverid,a.StartDate,a.EndDate,c.Fullname as fullname from " +
"Trip_Allocation_Hist a,Trip_Driver_Association_History b,Driver_Master c where a.Trip_Allocation_id=b.Trip_Allocation_id "+
"and a.System_id = b.System_id and a.System_id=? and b.Driver_id=c.Driver_id and b.System_id=c.System_id";



public static final String SELECT_DRIVER_VEHICLE_DATA="(select distinct a.REGISTRATION_NO as regno,a.DRIVER_ID as driverid," +
" a.FROM_DATE_TIME as StartDate,a.TO_DATE_TIME as EndDate,b.Fullname as fullname,'0' as val " +
" from DRIVER_VEHICLE_HISTORY a,Driver_Master b where a.SYSTEM_ID=? " +
"and a.DRIVER_ID=b.Driver_id and a.SYSTEM_ID=b.System_id";

public static final String GET_ROUTE_DEVAITION_FOR_DRIVER="select count(*) from dbo.Alert_History where "+
" REGISTRATION_NO=? and GMT between ? and ? and TYPE_OF_ALERT=5 and SYSTEM_ID=?";

public static final String SELECT_ARRIVAL_TIME_FOR_DRIVER="select datediff(hh,EndDate,Sch_Arrival) from dbo.Trip_Allocation_Hist where "+
" Registration_no=? and StartDate between ? and ? and System_id=?";

public static final String SELECT_STOPPAGETIME_FOR_DRIVER="select sum(IDLE_TIME) from IDLETIME_HISTORY where "+
" REGISTRATION_NO=? and GMT between ? and ? and IGNITION=?"+
" UNION "+
"select sum(IDLE_TIME) from IDLETIME where "+
" REGISTRATION_NO=? and GMT between ? and ? and IGNITION=?";

//commented by Nikhil on 02/06/2013
//public static final String SELECT_TOTAL_DISTANCE="select case  when sum(DELTADISTANCE) <> 0 "+
//	" then"+
//		 " round(sum(DELTADISTANCE),2)"+
//		"else"+   
//		 " round(max(ODOMETER)-min(ODOMETER),2) end as TOTDISTANCE"+ 
//" from HISTORY_DATA where REGISTRATION_NO=? and GPS_DATETIME between ? and ? "+
//" group by REGISTRATION_NO" +
//
//" UNION select case  when sum(DELTADISTANCE) <> 0 "+
//" then"+
//	 " round(sum(DELTADISTANCE),2)"+
//	"else"+   
//	 " round(max(ODOMETER)-min(ODOMETER),2) end as TOTDISTANCE"+ 
//" from AMS_Archieve.dbo.GENERIC_DATA where REGISTRATION_NO=? and GPS_DATETIME between ? and ?  and System_id=?"+
//" group by REGISTRATION_NO";

public static final String GET_COUNT_FOR_HARSH_BREAK="select count(*) from  Alert where  "+
	" REGISTRATION_NO=? and GMT between ? and ? and SYSTEM_ID=?  and TYPE_OF_ALERT=?  "+

	"UNION"+

	" select count(*) from  dbo.Alert_History where "+ 
	" REGISTRATION_NO=? and GMT between ? and ? and   SYSTEM_ID=?   AND TYPE_OF_ALERT=?";


public static final String GET_DATA_FOR_HARSH_ACC_DEACC="SELECT DATEADD(mi,?,GMT) as gpsdatetime,"+
	"LOCATION as location,SPEED as speed,RATE_OF_CHANGE as 'RATEOFRANGE'"+ 
	"from Alert where "+
	" REGISTRATION_NO=? and GMT between ? and ? and SYSTEM_ID=?  and TYPE_OF_ALERT=?  "+
	
	"UNION "+

	"SELECT DATEADD(mi,?,GMT) as gpsdatetime,"+
	"LOCATION as location,SPEED as speed,RATE_OF_CHANGE as 'RATEOFRANGE'"+ 
	"From Alert_History where "+ 
	" REGISTRATION_NO=? and GMT between ? and ? and   SYSTEM_ID=?   AND TYPE_OF_ALERT=?";


public static final String SELECT_STOPPAGETIME_DETAILS_DRIVER="SELECT DATEADD(mi,?,GMT) as gpsdatetime,"+

	"IDLE_TIME as [idletime],IDLE_START_LOCATION as location from IDLETIME_HISTORY where "+
	
    " REGISTRATION_NO=? and GMT between ? and ? and IGNITION=?"+

    " UNION "+

    "SELECT DATEADD(mi,?,GMT) as gpsdatetime,"+

    "IDLE_TIME as [idletime],IDLE_START_LOCATION as location from IDLETIME where "+

    " REGISTRATION_NO=? and GMT between ? and ? and IGNITION=?";


/**   rejwan on 10 th Sept*/
	public static final String DELETE_SETTING_WEIGHT="delete from score_setting_weight where system_id=? and setting_id=?";
	public static final String INSERT_SETTING_WEIGHT="insert into score_setting_weight(system_id,setting_id,setting_param_id,weight) "+
		"values(?,?,?,?)";	

	public static final String GET_SETTING_WEIGHT="select setting_param_id,weight from score_setting_weight where system_id=? and setting_id=? order by setting_param_id";

	public static final String SELECT_LTSP_DRIVER_SETTINGS="select score_setting_name,score_setting_id from score_setting_master where system_id=? and client_id=? order by score_setting_name";

	public static final String  SELECT_LTSP_DRIVER_SETTINGS_DETAILS="select setting_param_id,score_range,score from score_setting_association "+
		"where system_id=? and setting_id=?";
	
	public static final String GET_WEIGHT_PARAREMTERS = "select setting_param_id,weight from score_setting_weight where system_id=? and setting_id=? order by setting_param_id";
	
	public static final String GET_DRIVERS_ASSOCIATE_TO_GROUP = "select Driver_id,Fullname from Driver_Master where  System_id=? and Client_id=? and  GroupId=? and Race='Active' ";
   
    public static final String GET_CLIENT_NAME="select CustomerName from dbo.tblCustomerMaster where System_id=? and CustomerId=?";
    
    public static final String GET_DRIVERS_FOR_CLIENT = "select Driver_id,Fullname from Driver_Master where  System_id=? and Client_id=? and Race='Active' ";
 }