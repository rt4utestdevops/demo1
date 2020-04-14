package t4u.statements;

public class SchoolStatments {

	public static final String GET_SCHOOLTYPE = "select distinct Class as SCHOOL_TYPE  from RouteStudentDetails where Class is not null and System_Id=? and Client_Id=?";

	public static final String GET_ROUTE = "select distinct Route as ROUTE from RouteStudentDetails where Route is not null and System_Id=? and Client_Id=?";

	public static final String GET_SCHOOL_STUDENT_DETAILS = "select distinct(isNull(cast(CountryCode as varchar)+''+cast (Mobile as varchar),''))as MOBILE from  dbo.RouteStudentDetails "
		+ "where Class in (#) and Route in ($) and System_Id=? and Client_Id=? ";

	public static final String SCHOOL_SUBMIT_DETAILS_INSERT_INTO_SEND_SMS = "INSERT INTO dbo.SEND_SMS(PhoneNo,Message,Status,ClientId,SystemId,InsertedTime) values (?,?,?,?,?,getUTCDate())";

	public static final String CHECK_MESSAGE_VOLUME = "select SMS_VOLUME ,SMS_USED from SMS.dbo.CLIENT_SMS_MASTER A,SMS.dbo.SMS_PROVIDER_MASTER B where CLIENT_ID=? and A.PROVIDER_ID=B.PROVIDER_ID order by SMS_VOLUME";

	public static final String Get_COUNTRY_LIST = "select ISD_CODE,COUNTRY_NAME from ADMINISTRATOR.dbo.COUNTRY_DETAILS (NOLOCK) where ISD_CODE is not NULL";

	public static final String GET_TOTAL_SMS_COUNT = "select SMS_VOLUME as TOTAL_SMS_SIZE from SMS.dbo.CLIENT_SMS_MASTER A,SMS.dbo.SMS_PROVIDER_MASTER B where CLIENT_ID=? and A.PROVIDER_ID=B.PROVIDER_ID order by SMS_VOLUME";

	public static final String GET_TOTAL_STUDENTS = "select count(distinct(Mobile)) as STUDENT_COUNT from  dbo.RouteStudentDetails "
		+ " where Class in (@) and Route in (%) and System_Id=? and Client_Id=? ";

	/*****************************************************SchoolRouteAllocation********************************************************************/	

	public static final String GET_ALL_ROUTE_ALLOCATION_DETAILS="select _id as ID,isnull(Route,'') as ROUTE ,isnull(Schedule,'')as START_TIME,isnull(Allocated,'')as ASSET_NUMBER,isnull(DropType,'')as TYPE from dbo.RouteAllocation where System_Id=? and Client_Id=?";

	public static final String Get_ASSET_NUMBER_LIST="select gps.REGISTRATION_NO as ASSET_NUMBER from gpsdata_history_latest gps left outer join Vehicle_association va on gps.REGISTRATION_NO = va.Registration_no and gps.System_id = va.System_id and gps.CLIENTID=va.Client_id where va.System_id = ? and va.Client_id=? order by GMT desc  ";

	public static final String SELECT_START_TIME_VALIDATE = "SELECT Schedule,Allocated from dbo.RouteAllocation where Schedule between ? and ? and Allocated=? and System_Id=? and Client_Id=? and Allocated <>'NONE'";

	public static final String ROUTE_ALLOCATION_INSERT="INSERT INTO dbo.RouteAllocation(Route,Schedule,Allocated,System_Id,Client_Id,DropType,time,SchoolType)VALUES(?,?,?,?,?,?,getutcdate(),'primary')";

	public static final String UPDATE_ROUTE_ALLOCATION_DETAILS="UPDATE dbo.RouteAllocation SET Route=?,Schedule= ?,Allocated=?,DropType=? WHERE System_Id=? and Client_Id=? and _id=?";

	public static final String SELECT_START_TIME_VALIDATE_IN_UPDATE = "SELECT Schedule,Allocated from dbo.RouteAllocation where Schedule between ? and ? and Allocated=?  and System_Id=? and Client_Id=? and _id <> ? and Allocated <>'NONE' ";

	public static final String DELETE_ROUTE_ALLOCATION_DETAILS="DELETE FROM dbo.RouteAllocation WHERE System_Id=? and Client_Id=? and _id=?";
	
	public static final String UPDATE_ROUTE_STUDENT_DETAILS="UPDATE dbo.RouteStudentDetails SET Route=null  where Route=? and System_Id=? and Client_Id=? ";
	
	public static final String UPDATE_ROUTE_STUDENT_DETAILS_FOR_ROUTE="UPDATE dbo.RouteStudentDetails SET Route=? where Route=? and DropType=? and System_Id=? and Client_Id=? ";

	/**********************************************************SchoolRouteStudentDetails***************************************************************************/
	
	public static final String GET_ALL_ROUTE_STUDENT_DETAILS="select isnull(a.StudentName,'')as STUDENT_NAME,isnull(a.Class,'')as STANDARD,isnull(a.Section,'')as SECTION,isnull(a.ParentName,'') as PARENT_NAME,isnull(a.Mobile,'')as PARENT_MOBILE,isnull(a.CountryCode,'') as COUNTRY_CODE,isnull(a.EmailId,'')as EMAIL_ID,a.Latitude as LATITUDE,a.Longitude as LONGITUDE,a.Radius as RADIUS , b.BRANCH_ID ,isnull(a.Branch_Id,'')as BRANCH_ID ,isnull(g.GROUP_NAME,'') as BRANCH_NAME,b.GROUP_ID from RouteStudentDetails a " +
			"left join dbo.SCHOOL_BRANCH_MASTER b on a.Branch_Id=b.BRANCH_ID and a.System_Id=b.SYSTEM_ID and a.Client_Id=b.CUSTOMER_ID " +
			"left join ADMINISTRATOR.dbo.ASSET_GROUP g on b.GROUP_ID=g.GROUP_ID and b.SYSTEM_ID=g.SYSTEM_ID and b.CUSTOMER_ID=g.CUSTOMER_ID " +
			"where a.System_Id =? and a.Client_Id =? " +
			"group by a.StudentName,a.Class,a.Section,a.ParentName, a.Mobile,a.CountryCode,a.EmailId,a.Latitude,a.Longitude,a.Radius,b.BRANCH_ID,g.GROUP_NAME,b.GROUP_ID ,a.Branch_Id order by a.Branch_Id";
	
	public static final String GET_ALL_ROUTE_STUDENT_DETAILS1="select isnull(a.StudentName,'')as STUDENT_NAME,isnull(a.Class,'')as STANDARD,isnull(a.Section,'')as SECTION,isnull(a.ParentName,'') as PARENT_NAME,isnull(a.Mobile,'')as PARENT_MOBILE,isnull(a.CountryCode,'') as COUNTRY_CODE,isnull(a.EmailId,'')as EMAIL_ID,a.Latitude as LATITUDE,a.Longitude as LONGITUDE,a.Radius as RADIUS ,b.BRANCH_ID,isnull(a.Branch_Id,'') as BRANCH_ID,isnull(g.GROUP_NAME,'') as BRANCH_NAME,b.GROUP_ID from RouteStudentDetails a " +
			"left join dbo.SCHOOL_BRANCH_MASTER b on a.Branch_Id=b.BRANCH_ID and a.System_Id=b.SYSTEM_ID and a.Client_Id=b.CUSTOMER_ID " +
			"left join ADMINISTRATOR.dbo.ASSET_GROUP g on b.GROUP_ID=g.GROUP_ID and b.SYSTEM_ID=g.SYSTEM_ID and b.CUSTOMER_ID=g.CUSTOMER_ID " +
			"where a.System_Id =? and a.Client_Id =? and a.Branch_Id=? " +
			"group by a.StudentName,a.Class,a.Section,a.ParentName, a.Mobile,a.CountryCode,a.EmailId,a.Latitude,a.Longitude,a.Radius,b.BRANCH_ID,g.GROUP_NAME,b.GROUP_ID,a.Branch_Id order by a.Branch_Id ";
	
	public static final String GET_STUDENTS_ROUTE_AND_TYPE_GRID="select _id as ID,isnull(Route,'') as ROUTE_NO,isnull(DropType,'') as TYPE from RouteStudentDetails where StudentName = ? and Mobile = ? " +
			//"and Class = ? " +
			"and System_Id=? and Client_Id=?";
   
	public static final String GET_PICKUP_CODE="select Route as ROUTE_NO from dbo.RouteAllocation where System_Id=? and Client_Id=? and DropType like 'pickup'";
	
	public static final String GET_DROP_CODE="select Route as ROUTE_NO from dbo.RouteAllocation where System_Id=? and Client_Id=? and DropType like 'drop'";
	
    public static final String ROUTE_STUDENT_DETAILS_INSERT="INSERT INTO dbo.RouteStudentDetails(StudentName,Class,Section,ParentName,Mobile,CountryCode,EmailId,Latitude,Longitude," +
    		"Radius,Route,DropType,Branch_Id,System_Id,Client_Id)VALUES(LTRIM(RTRIM(?)),?,LTRIM(RTRIM(?)),LTRIM(RTRIM(?)),?,?,?,?,?,?,?,?,?,?,?)";
    
    public static final String ROUTE_STUDENT_DETAILS_UPDATE="UPDATE dbo.RouteStudentDetails SET StudentName=LTRIM(RTRIM(?)),Class=?,Section=LTRIM(RTRIM(?)),ParentName=LTRIM(RTRIM(?)),Mobile=?,CountryCode=?,EmailId=?,Latitude=?,Longitude=?,Radius=?,Route=?,DropType=?,Branch_Id=? where System_Id=? and Client_Id=? and _id=?";
    
    public static final String DELETE_ROUTE_STUDENT_DETAILS="DELETE FROM dbo.RouteStudentDetails WHERE System_Id=? and Client_Id=? and _id=?";

	public static final String GET_STANDARD_LIST_FROM_CLASS_MASTER="select ID,CLASS as STANDARD from dbo.CLASS_INFORMATION where SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static String GET_BRANCH_LIST="select isnull(bm.BRANCH_ID,'') as BRANCH_ID,isnull(g.GROUP_NAME,'')as BRANCH_NAME,g.GROUP_ID from dbo.SCHOOL_BRANCH_MASTER bm " +
			"left join ADMINISTRATOR.dbo.ASSET_GROUP g on bm.GROUP_ID=g.GROUP_ID and g.SYSTEM_ID=bm.SYSTEM_ID and g.CUSTOMER_ID=bm.CUSTOMER_ID where bm.SYSTEM_ID=? and bm.CUSTOMER_ID=?";	
	
	public static String GET_BRANCH_LIST_POPUP="select isnull(bm.BRANCH_ID,'') as BRANCH_ID,isnull(g.GROUP_NAME,'')as BRANCH_NAME,g.GROUP_ID from dbo.SCHOOL_BRANCH_MASTER bm " +
			"left join ADMINISTRATOR.dbo.ASSET_GROUP g on bm.GROUP_ID=g.GROUP_ID and g.SYSTEM_ID=bm.SYSTEM_ID and g.CUSTOMER_ID=bm.CUSTOMER_ID where bm.SYSTEM_ID=? and bm.CUSTOMER_ID=?";
	
/**********************************************************SchoolBranchMasterDetails***************************************************************************/
	
	public static final String GET_ALL_BRANCH_MASTER_DETAILS = "select bm.BRANCH_ID, CUST_BRANCH_ID, bm.GROUP_ID as GROUP_ID, g.GROUP_NAME, bm.COUNTRY as COUNTRY_ID, c.COUNTRY_NAME, bm.STATE as STATE_ID, s.STATE_NAME, bm.CITY, bm.CONTACT_NO, bm.EMAIL_ID, bm.MOBILE_NO, " +
			"bm.HUB_ID as HUB_ID, l.NAME as HUBNAME, isnull(u.FIRST_NAME,'')+' '+isnull(u.LAST_NAME,'') as CREATED_USERNAME , dateadd(mi,?,bm.CREATED_TIME) as CREATED_TIME from dbo.SCHOOL_BRANCH_MASTER bm LEFT JOIN ADMINISTRATOR.dbo.COUNTRY_DETAILS c " +
			"on bm.COUNTRY = c.COUNTRY_CODE LEFT JOIN ADMINISTRATOR.dbo.STATE_DETAILS s on bm.STATE = s.STATE_CODE LEFT JOIN ADMINISTRATOR.dbo.ASSET_GROUP g " +
			"on bm.GROUP_ID = g.GROUP_ID LEFT JOIN dbo.LOCATION_ZONE l on bm.HUB_ID = l.HUBID " +
			"LEFT JOIN ADMINISTRATOR.dbo.USERS u on bm.CREATED_BY = u.USER_ID and bm.SYSTEM_ID = u.SYSTEM_ID " +
			"where bm.SYSTEM_ID=? and bm.CUSTOMER_ID=?";

	
	public static final String BRANCH_MASTER_DETAILS_INSERT = "INSERT INTO dbo.SCHOOL_BRANCH_MASTER(CUST_BRANCH_ID, GROUP_ID, COUNTRY, STATE, CITY, CONTACT_NO, EMAIL_ID, MOBILE_NO, HUB_ID, " +
										"CUSTOMER_ID, SYSTEM_ID, CREATED_BY)VALUES((LTRIM(RTRIM(?))),?,?,?,(LTRIM(RTRIM(?))),?,?,?,?,?,?,?)";

	public static final String BRANCH_MASTER_DETAILS_UPDATE="UPDATE dbo.SCHOOL_BRANCH_MASTER SET CUST_BRANCH_ID = (LTRIM(RTRIM(?))), GROUP_ID = ?, COUNTRY = ?, STATE = ?, CITY = (LTRIM(RTRIM(?))), CONTACT_NO = ?, EMAIL_ID = ?, MOBILE_NO = ?, HUB_ID = ? where SYSTEM_ID=? and CUSTOMER_ID=? and BRANCH_ID=?";
	
	public static final String CHECKING_GROUP_ID = "select count(*) COUNT from dbo.SCHOOL_BRANCH_MASTER where GROUP_ID = ? ";
	
	public static final String CHECKING_GROUP_ID_MODIFY = "select count(*) COUNT from dbo.SCHOOL_BRANCH_MASTER where GROUP_ID = ? and BRANCH_ID != ?";
    
    public static final String DELETE_BRANCH_MASTER_DETAILS = "DELETE FROM dbo.SCHOOL_BRANCH_MASTER WHERE SYSTEM_ID=? and CUSTOMER_ID=? and BRANCH_ID=?";
    
    public static final String UPDATE_ROUTE_STUDENT_DETAILS_BRANCHID = "UPDATE  dbo.RouteStudentDetails set Branch_Id = null where System_Id = ? and Client_Id = ? and Branch_Id = ?";
    
	public static final String GET_START_END_LOCATION_BASED_ON_OPERATIONAL_ID=" select NAME,HUBID from dbo.LOCATION_ZONE where OPERATION_ID not in (2,3) "
		+ "and SYSTEMID=? and CLIENTID=? ";
	
	/**
	 * getting country name list from country details table
	 */
	public static final String GET_COUNTRY_LIST = "select COUNTRY_CODE,COUNTRY_NAME from dbo.COUNTRY_DETAILS";
	/**
	 * getting state list from state details table
	 */
	public static final String GET_STATE_LIST = "select STATE_CODE,STATE_NAME from dbo.STATE_DETAILS where COUNTRY_CODE=? order by STATE_NAME asc";

	
    /**********************************************************ClassInformationDetails***************************************************************************/
    
    public static final String GET_CUSTOMER_FOR_LOGGED_IN_CUST="select  CustomerId, CustomerName as NAME from dbo.tblCustomerMaster where System_id=? and CustomerId=? ";

	public static final String GET_CUSTOMER="select CustomerId, CustomerName as NAME from dbo.tblCustomerMaster where System_id=? ";
	
	public static final String GET_CLASS_INFORMATION_REPORT="select ci.ID as ID,ci.CLASS,isNull(u.FIRST_NAME+' '+u.LAST_NAME,'') as SUPERVISOR_NAME,isNull(u1.FIRST_NAME+' '+u1.LAST_NAME,'') as CREATED_NAME,ci.SUPERVISOR as SUPERVISOR_ID, ci.CREATED_BY,dateadd(mi,?,ci.CREATED_TIME) as CREATED_TIME from AMS.dbo.CLASS_INFORMATION ci left outer join ADMINISTRATOR.dbo.USERS u on ci.SYSTEM_ID = u.SYSTEM_ID and ci.SUPERVISOR= u.USER_ID left outer join ADMINISTRATOR.dbo.USERS u1 on ci.SYSTEM_ID = u1.SYSTEM_ID and ci.CREATED_BY= u1.USER_ID where ci.SYSTEM_ID = ? and ci.CUSTOMER_ID = ? ";

	public static final String INSERT_CLASS_INFORMATION=" insert into dbo.CLASS_INFORMATION(CLASS,SUPERVISOR,SYSTEM_ID,CUSTOMER_ID,CREATED_BY) "
        												+ " values(?,?,?,?,?) ";
	
	public static final String UPDATE_CLASS_INFORMATION=" update dbo.CLASS_INFORMATION set SUPERVISOR=?  where CUSTOMER_ID=? and SYSTEM_ID=? and ID=? ";

	public static final String UPDATE_CLASS_INFO=" update dbo.CLASS_INFORMATION set CLASS=?, SUPERVISOR=?, CREATED_BY=?  where CUSTOMER_ID=? and SYSTEM_ID=? and ID=? ";

	public static final String DELETE_CLASS_INFORMATION="delete from dbo.CLASS_INFORMATION where CUSTOMER_ID=? and SYSTEM_ID=? and ID = ?";
	
	public static final String GET_USER_NAMES="select USER_ID as ID, isnull(FIRST_NAME,'')+' '+isnull(LAST_NAME,'') as NAME from dbo.USERS where SYSTEM_ID=? and CUSTOMER_ID= ? and STATUS='Active'";

	public static final String UPDATE_ROUTE_STUDENT_CLASS = "update dbo.RouteStudentDetails set Class=? where Class=? and Client_Id=? and System_Id=? ";
	
	public static final String UPDATE_SCHOOL_HOLIDAY_LIST = "update dbo.SchoolHolidayList set Schooltype=? where Schooltype=? and SystemId=? and ClientId=? ";
	
	public static final String UPDATE_ROUTE_STUDENT = "update dbo.RouteStudentDetails set Class=null where Class=? and Client_Id=? and System_Id=? ";

	public static final String CHECK_EXISTING_CLASSNAME_MODIFY = "select count(*) as COUNT from dbo.CLASS_INFORMATION where CUSTOMER_ID =? and SYSTEM_ID=? and CLASS = ? and  ID != ? ";

	public static final String CHECK_EXISTING_CLASSNAME_INSERT = "select count(*) as COUNT from dbo.CLASS_INFORMATION where CUSTOMER_ID =? and SYSTEM_ID=? and CLASS=? ";

	
	/****************************************************************Holiday List**************************************************************************/
	public static String GET_HOLIDAY_LIST_DETAILS="select ID,Schooltype as STANDARD, Date as FROM_DATE,EndDate as TO_DATE,datediff (d, Date, EndDate) as DAYS from dbo.SchoolHolidayList where SystemId=? and ClientId=?";
	
	public static final String GET_STANDARD_LIST_FROM_CLASS="select CLASS as STANDARD from dbo.CLASS_INFORMATION where SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String HOLIDAY_INFORMATION_INSERT="insert into SchoolHolidayList(Schooltype,Date,EndDate,SystemId,ClientId)values(?,?,?,?,?)";
	
	public static final String HOLIDAY_INFORMATION_UPDATE="UPDATE dbo.SchoolHolidayList SET Schooltype=?,Date=?,EndDate=? where SystemId=? and ClientId=? and ID=?";
	
	public static final String DELETE_HOLIDAY_DETAILS="DELETE FROM dbo.SchoolHolidayList WHERE SystemId=? and ClientId=? and ID=?";
	
	public static String Get_LIST ="select Schooltype as TITLE,CONVERT(VARCHAR(10),Date,112) as START,CONVERT(VARCHAR(10),EndDate,112) as Ends from dbo.SchoolHolidayList where SystemId=? and ClientId=?";
	
	public static final String GET_SMS_TO_PARENT_DETAILS = " SELECT VehicleNo,SchoolId,isnull(AlertTypeForSchool,'') as ParentName,PhoneNo,Message,dateadd(mi,?,InsertedTime) as InsertedTime,isnull(DriverName,'') as SchoolDriverName "+ 
														   " FROM AMS.dbo.SEND_SMS where SystemId=? and ClientId=? and SchoolId is not null and SchoolId<>'' and InsertedTime between ? and ?  "+
														   " UNION "+ 
														   " SELECT VehicleNo,SchoolId,isnull(AlertTypeForSchool,'') as ParentName,PhoneNo,Message,dateadd(mi,?,InsertedTime) as InsertedTime,isnull(DriverName,'') as SchoolDriverName " +
														   " FROM AMS.dbo.SEND_SMS_HISTORY where SystemId=? and ClientId=? and SchoolId is not null and SchoolId<>'' and InsertedTime between ? and ? "+
														   " order by InsertedTime desc "; 
}
