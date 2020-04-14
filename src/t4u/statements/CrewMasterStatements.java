package t4u.statements;

public class CrewMasterStatements {

	public static final String UPDATE_PERSONAL_INFORMATION="update AMS.dbo.Driver_Master set Fullname=?,LastName=?,PresentAddress=?,PermanentAddress=?,City=?,OtherCity=?,State=?,Country=?,Telephone=?,Mobile=?,Dob=dateadd(mi,-?,?),Gender=?,Nationality=?,MaritalStatus=?,UPDATED_BY=?,UPDATED_TIME=getUTCDate(),PASSPORT_NUMBER=?,EXPIRY_DATE=dateadd(mi,-?,?) where Driver_id=? and System_id=? and Client_id=?";

	public static final String UPDATE_EMPLOYMENT_INFORMATION="update AMS.dbo.Driver_Master set EmploymentType=?,EmployeeID=?,Date_of_join=dateadd(mi,-?,?),Date_of_leaving=dateadd(mi,-?,?),Blood=?,GroupId=?,Race=?,Remarks=?,GOVERMENT_RESIDENCE_ID=?,GOVERMENT_RESIDENCE_EXP_DATE=dateadd(mi,-?,?),DriverCodeFromUnit=?,UPDATED_BY=?,UPDATED_TIME=getUTCDate(),WORKMAN_COMPENSATION_ID=?,WORKMAN_COMPENSATION_EXPIRY_DATE=dateadd(mi,-?,?) where System_id=? and Client_id=? and Driver_id=?";
	
	public static final String UPDATE_INSURANCE_INFORMATION="update AMS.dbo.Driver_Master set MEDICAL_INSURANCE_NUMBER=?,MEDICAL_INSURANCE_COMPANY=?,MEDICAL_INSURANCE_EXP_DATE=dateadd(mi,-?,?),UPDATED_BY=?,UPDATED_TIME=getUTCDate() where System_id=? and Client_id=? and Driver_id=?";
	 
	public static final String UPDATE_DRIVER_INFORMATION="update AMS.dbo.Driver_Master set Lic_no=?,Lic_place=?,Lic_issue_date=dateadd(mi,-?,?),Lic_renew_date=dateadd(mi,-?,?),Lic_expiry_date=dateadd(mi,-?,?),PREFERED_COMPANY = ?,UPDATED_BY=?,UPDATED_TIME=getUTCDate() where Client_id=? and System_id=? and Driver_id=?";
	 
	public static final String UPDATE_GUNMEN_INFORMATION="update AMS.dbo.Driver_Master set Lic_no=?,GunLicenseType=?,Lic_issue_date=dateadd(mi,-?,?),Lic_place=?,Lic_expiry_date=dateadd(mi,-?,?),UPDATED_BY=?,UPDATED_TIME=getUTCDate() where Client_id=? and System_id=? and Driver_id=?";
	
	public static final String GET_DRIVER_NAMES="Select isnull(f.VALUE,'') as EMPLOYMENT_VALUE,(isnull(a.Fullname,'')+' '+isnull(a.LastName,'')) as Fullname,isnull(a.Fullname,'') as FULLNAME ,isnull(a.EmploymentType,'') as EMPLOYMENT_TYPE,isnull(a.Driver_id,'') as Driver_id ,isnull(a.LastName,'') as LAST_NAME,CASE WHEN LEN(a.PresentAddress) <= 50 THEN a.PresentAddress ELSE LEFT(a.PresentAddress, 47) + '...' END  As PresentAddress , CASE WHEN LEN(a.PermanentAddress) <= 50 THEN a.PermanentAddress ELSE LEFT(a.PermanentAddress, 47) + '...' END  As PermanentAddress,isnull(a.City,'') as CITY_NEW ,isnull(a.OtherCity,'') as OtherCity ,isnull(c.STATE_NAME,'') as STATE_NAME,isnull(a.State,'') as STATE_ID,isnull(a.Country,'') as COUNTRY_ID,isnull(a.GroupId,'') as GROUP_ID,isnull(b.COUNTRY_NAME,'') as COUNTRY_NAME,isnull(a.Telephone,'') as Telephone ,isnull(a.Mobile,'') as Mobile,dateadd(mi,?,a.Dob) as Dob,isnull(a.Gender,'') as Gender ,isnull(a.Nationality,'') as Nationality ,isnull(a.MaritalStatus,'') as MaritalStatus,isnull(a.EmploymentType,'') as EMPLOYMENT_TYPE ,isnull(a.EmployeeID,'') as EmployeeID,dateadd(mi,?,a.Date_of_join) as Date_of_join,dateadd(mi,?,a.Date_of_leaving) as Date_of_leaving,isnull(a.Blood,'') as Blood,isnull(d.GROUP_NAME,'') as GROUP_NAME,isnull(a.Race,'') as Race,CASE WHEN LEN(a.Remarks) <= 45 THEN a.Remarks ELSE LEFT(a.Remarks, 42) + '...' END  As Remarks,isnull(a.GOVERMENT_RESIDENCE_ID,'') as GOVERMENT_RESIDENCE_ID,dateadd(mi,?,a.GOVERMENT_RESIDENCE_EXP_DATE) as GOVERMENT_RESIDENCE_EXP_DATE,isnull(a.DriverCodeFromUnit,'') as DriverCodeFromUnit ,isnull(a.MEDICAL_INSURANCE_NUMBER,'') as MEDICAL_INSURANCE_NUMBER ,isnull(a.MEDICAL_INSURANCE_COMPANY,'') as MEDICAL_INSURANCE_COMPANY,dateadd(mi,?,a.MEDICAL_INSURANCE_EXP_DATE) as MEDICAL_INSURANCE_EXP_DATE,isnull(a.Lic_no,'') as Lic_no ,isnull(a.Lic_place,'') as Lic_place ,dateadd(mi,?,a.Lic_issue_date) as Lic_issue_date,dateadd(mi,?,a.Lic_renew_date) as Lic_renew_date,dateadd(mi,?,a.Lic_expiry_date) as Lic_expiry_date,isnull(a.GunLicenseType,'') as LICENSE_TYPE,isnull(PASSPORT_NUMBER,'') as PASSPORT_NUMBER,dateadd(mi,?,a.EXPIRY_DATE) as EXPIRY_DATE,isnull(WORKMAN_COMPENSATION_ID,'') as WORKMAN_COMPENSATION_ID,dateadd(mi,?,a.WORKMAN_COMPENSATION_EXPIRY_DATE) as WORKMAN_COMPENSATION_EXPIRY_DATE,isnull(a.PREFERED_COMPANY,'') as PREFERED_COMPANY  from AMS.dbo.Driver_Master a (NOLOCK)" +
			" left outer join ADMINISTRATOR.dbo.COUNTRY_DETAILS (NOLOCK) b on a.Country=b.COUNTRY_CODE " +
			" left outer join ADMINISTRATOR.dbo.STATE_DETAILS (NOLOCK) c on a.State=c.STATE_CODE " +
			" left outer join AMS.dbo.LOOKUP_DETAILS f on a.EmploymentType= cast(f.TYPE as int) " +
			" left outer join AMS.dbo.VEHICLE_GROUP (NOLOCK) d on a.GroupId=d.GROUP_ID where f.VERTICAL='CREW_TYPE' and a.Client_id=? and a.System_id=? ";

	public static final String Get_COUNTRY_LIST = "select COUNTRY_CODE,COUNTRY_NAME from ADMINISTRATOR.dbo.COUNTRY_DETAILS (NOLOCK)";
	
	public static final String Get_STATE_LIST = "select STATE_CODE,STATE_NAME from ADMINISTRATOR.dbo.STATE_DETAILS (NOLOCK) where COUNTRY_CODE=? order by STATE_NAME asc";

	public static final String SELECT_GROUP_LIST = "select GROUP_ID,GROUP_NAME from AMS.dbo.VEHICLE_GROUP (NOLOCK) where SYSTEM_ID = ? and CLIENT_ID = ?";
	
	public static final String GET_EMPLOYMENT_TYPE="SELECT TYPE,VALUE FROM AMS.dbo.LOOKUP_DETAILS WHERE VERTICAL='CREW_TYPE' ";
	
	public static final String SELECT_MAX_DRIVER_ID="select MAX(Driver_id) as Driver_id from AMS.dbo.Driver_Master (NOLOCK) ";
	
	public static final String UPDATE_GUNMEN_INFORMATION_FOR_ADD_CREW="insert into AMS.dbo.Driver_Master(Driver_id,Fullname,LastName,PresentAddress,PermanentAddress,City,OtherCity,State,Country,Telephone,Mobile,Dob,Gender,Nationality,MaritalStatus, "
			+ "EmploymentType,EmployeeID,Date_of_join,Date_of_leaving,Blood,GroupId,Race,Remarks,GOVERMENT_RESIDENCE_ID,GOVERMENT_RESIDENCE_EXP_DATE,DriverCodeFromUnit, "
			+ "MEDICAL_INSURANCE_NUMBER,MEDICAL_INSURANCE_COMPANY,MEDICAL_INSURANCE_EXP_DATE, "
			+ "Lic_no,Lic_place,Lic_issue_date,Lic_renew_date,Lic_expiry_date,Client_id,System_id,CREATED_BY,CREATED_TIME,PASSPORT_NUMBER,EXPIRY_DATE,WORKMAN_COMPENSATION_ID,WORKMAN_COMPENSATION_EXPIRY_DATE,PREFERED_COMPANY) values(?,?,?,?,?,?,?,?,?,?,?,dateadd(mi,-?,?),?,?,?,?,?,dateadd(mi,-?,?),dateadd(mi,-?,?),?,?,?,?,?,dateadd(mi,-?,?),?,?,?,dateadd(mi,-?,?),?,?,dateadd(mi,-?,?),dateadd(mi,-?,?),dateadd(mi,-?,?),?,?,?,getUTCDate(),?,dateadd(mi,-?,?),?,dateadd(mi,-?,?),?)";
	
	public static final String INSERT_GUNMEN_INFORMATION_FOR_ADD_CREW="insert into AMS.dbo.Driver_Master(Driver_id,Fullname,LastName,PresentAddress,PermanentAddress,City,OtherCity,State,Country,Telephone,Mobile,Dob,Gender,Nationality,MaritalStatus, "
		+ "EmploymentType,EmployeeID,Date_of_join,Date_of_leaving,Blood,GroupId,Race,Remarks,GOVERMENT_RESIDENCE_ID,GOVERMENT_RESIDENCE_EXP_DATE,DriverCodeFromUnit, "
		+ "MEDICAL_INSURANCE_NUMBER,MEDICAL_INSURANCE_COMPANY,MEDICAL_INSURANCE_EXP_DATE, "
		+ "Lic_no,GunLicenseType,Lic_issue_date,Lic_place,Lic_expiry_date,Client_id,System_id,CREATED_BY,CREATED_TIME,PASSPORT_NUMBER,EXPIRY_DATE,WORKMAN_COMPENSATION_ID,WORKMAN_COMPENSATION_EXPIRY_DATE,PREFERED_COMPANY) values(?,?,?,?,?,?,?,?,?,?,?,dateadd(mi,-?,?),?,?,?,?,?,dateadd(mi,-?,?),dateadd(mi,-?,?),?,?,?,?,?,dateadd(mi,-?,?),?,?,?,dateadd(mi,-?,?),?,?,dateadd(mi,-?,?),?,dateadd(mi,-?,?),?,?,?,getUTCDate(),?,dateadd(mi,-?,?),?,dateadd(mi,-?,?),?)";

	public static final String SELECT_EMPLOYEE_ID = "select EmployeeID from AMS.dbo.Driver_Master where EmployeeID=? and System_id=? and Client_id=?";
	
	public static final String SELECT_DRIVER_LIST_EXISTED = " select REGISTRATION_NO,DRIVER_ID,SYSTEM_ID,DATE_TIME from AMS.dbo.Driver_Vehicle (NOLOCK) where  SYSTEM_ID=? and DRIVER_ID=?";
	
	public static final String INSERT_VDASSOCIATION_HISTORY = "insert into AMS.dbo.DRIVER_VEHICLE_HISTORY(REGISTRATION_NO,DRIVER_ID,SYSTEM_ID,FROM_DATE_TIME,TO_DATE_TIME) values(?,?,?,?,getUTCdate())";
	
	public static final String DELETE_VDASSOCIATION_DRIVER = "delete from AMS.dbo.Driver_Vehicle where REGISTRATION_NO=? and DRIVER_ID=?";
	
	public static final String UPDATE_DRIVER_NAME_AND_ID = "update AMS.dbo.gpsdata_history_latest set DRIVER_NAME=?,DRIVER_ASSOC_ID=? where REGISTRATION_NO=?";

	public static final String GET_DRIVER_NAMES_FOR_VEHICLE_AND_SYSTEM = "select Fullname,Mobile,Driver_id from AMS.dbo.Driver_Master where Driver_id in (select DRIVER_ID from AMS.dbo.Driver_Vehicle"
		+ " where REGISTRATION_NO=?) and System_id=? order by Fullname";
	
	public static final String UPDATE_GPS_DATA_HISTORY_LATEST=" update AMS.dbo.gpsdata_history_latest set " +
	" DRIVER_NAME=?,DRIVER_MOBILE=? where REGISTRATION_NO=? and System_id=? and CLIENTID=?";
	
	public static final String SELECT_REG_NO="select REGISTRATION_NO from AMS.dbo.Driver_Vehicle where SYSTEM_ID=? " 
		+ " and DRIVER_ID=?  ";
	
	public static final String DELETE_FROM_STATUTORY="delete from AMS.dbo.StatutoryAlert where DriverId=? and SystemId=? and ClientId=? ";

			
}









