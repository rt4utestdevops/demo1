package t4u.statements;

public class FFMStatements {

	public static final String GET_ASM="select isNull(Firstname,'')+''+isNull(Lastname,'') as ASMName, isNull(User_id,0) as ASMId from AMS.dbo.Users where System_id=? and Client_id=?";
	
	public static final String GET_EMAIL="select isNull(Emailed,'') as EmailName,isNull(User_id,0) as EmailId from AMS.dbo.Users where System_id=? and Client_id=?";

	public static final String INSERT_FF_CUSTOMER="INSERT INTO AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER(ACCOUNT_TYPE,MEETING_DATE,ASM,TSM,CHANNEL_PARTNER,DST,VISIT_TYPE,COMPANY_NAME,"+
												"ACCOUNT_ADDRESS,ACCOUNT_SEGMENT,CUSTOMER_MOBILE,CUSTOMER_LANDLINE,CUSTOMER_EMAIL,ACCOUNT_STATUS,CUSTOMER_STATUS,EMAIL_LEVEL_1,"+
												"EMAIL_LEVEL_2,EMAIL_LEVEL_3,EMAIL_LEVEL_4,CLIENT_ID,SYSTEM_ID,CUSTOMER_NAME) VALUES(?,dateadd(mi,-?,?),?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	public static final String INSERT_FF_CUST_PROD_DETAILS="INSERT INTO AMS.dbo.FIELD_FORCE_CUSTOMER_PRODUCT_DETAILS(REF_ID,ID,AMOUNT,SYSTEM_ID,CUSTOMER_ID) VALUES (?,?,?,?,?)";

	public static final String SELECT_MAX_CUST_ID ="select MAX(CUSTOMER_ID) from AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER where SYSTEM_ID=? and CLIENT_ID=?";
	
	public static final String GET_FFM_CUST_DETAILS="SELECT isNull(CUSTOMER_ID,0) as RefId,isNull(ACCOUNT_TYPE,'') as AccType,dateadd(mi,?,isNull(MEETING_DATE,'')) as FirstMeetDate,"+
	"isNull(ASM,'') as Asm,isNull(TSM,'') as Tsm,isNull(CHANNEL_PARTNER,'') as ChannelPartner,isNull(DST,'') as Dst,"+
	"isNull(VISIT_TYPE,'') as VisitType,isNull(COMPANY_NAME,'') as AccName,isNull(ACCOUNT_ADDRESS,'') as AccAddress,isNull(ACCOUNT_SEGMENT,'') as AccSegment,isNull(CUSTOMER_NAME,'') as CustName," +
	"isNull(CUSTOMER_MOBILE,'') as MobileNum,isNull(CUSTOMER_LANDLINE,'') as LandlineNum,isNull(CUSTOMER_EMAIL,'') as Email,isNull(ACCOUNT_STATUS,'') as AccStatus,isNull(CUSTOMER_STATUS,'') as CustStatus,"+
	"isNull(EMAIL_LEVEL_1,'') as EscEmail1,isNull(EMAIL_LEVEL_2,'') as EscEmail2,isNull(EMAIL_LEVEL_3,'') as EscEmail3,isNull(EMAIL_LEVEL_4,'') as EscEmail4 FROM AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER"+ 
	" where SYSTEM_ID=? and CLIENT_ID =?";
	
	public static final String GET_FFM_CUST_PROD_DETAILS="SELECT ID as Product,AMOUNT as Amount FROM AMS.dbo.FIELD_FORCE_CUSTOMER_PRODUCT_DETAILS where REF_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String GET_PRODUCT ="select ID as ProductId,VALUE as ProductName from AMS.dbo.FF_LOOKUP_DETAILS WHERE TYPE='PRODUCT_TYPE'";
	
	public static final String MODIFY_FF_CUST_PROD_DETAILS="UPDATE AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER SET ACCOUNT_TYPE = ?,MEETING_DATE = dateadd(mi,-?,?),ASM = ?,TSM = ?,CHANNEL_PARTNER = ?,DST = ?,VISIT_TYPE = ?,"+
	"COMPANY_NAME = ?,ACCOUNT_ADDRESS = ?,ACCOUNT_SEGMENT = ?,CUSTOMER_NAME = ?,CUSTOMER_MOBILE = ?,CUSTOMER_LANDLINE = ?,CUSTOMER_EMAIL = ?,ACCOUNT_STATUS =?,CUSTOMER_STATUS = ?,EMAIL_LEVEL_1 = ?,EMAIL_LEVEL_2 = ?,"+
	"EMAIL_LEVEL_3 = ?,EMAIL_LEVEL_4 = ? WHERE CLIENT_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";
    
	public static final String DELETE_FF_CUST_PROD_DETAILS="delete from AMS.dbo.FIELD_FORCE_CUSTOMER_PRODUCT_DETAILS where REF_ID=? and SYSTEM_ID=? and CUSTOMER_ID=?";
	
	public static final String DELETE_FF_CUSTOMER_DETAILS="delete from AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER where CUSTOMER_ID=? and SYSTEM_ID=? and CLIENT_ID=?";
	
	public static final String GET_FOLLOW_UPS="select vu.Registration_no as RegistrationNo,isnull(ag.GROUP_NAME,'') as GroupName,gps.LATITUDE as Latitude,gps.LONGITUDE as Longitude,gps.LOCATION as Location,va.Unit_Number as PhoneNo from AMS.dbo.Vehicle_User (NOLOCK) vu"+
	" left outer join AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) on vu.Registration_no=vc.REGISTRATION_NUMBER and vu.System_id=vc.SYSTEM_ID"+
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag (NOLOCK) on vc.SYSTEM_ID=ag.SYSTEM_ID and vc.CLIENT_ID=ag.CUSTOMER_ID and vc.GROUP_ID=ag.GROUP_ID"+
	" left outer join AMS.dbo.gpsdata_history_latest gps on vu.Registration_no = gps.REGISTRATION_NO"+
	" left outer join AMS.dbo.Vehicle_association va on va.Registration_no = gps.REGISTRATION_NO"+
	" where vu.System_id=? and vu.User_id=? and vc.CLIENT_ID=? order by vu.Registration_no,ag.GROUP_NAME";
	
	public static final String GET_SYS_FOLLOW_UPS="select distinct vu.Registration_no as RegistrationNo,isnull(ag.GROUP_NAME,'') as GroupName,gps.LATITUDE as Latitude,gps.LONGITUDE as Longitude,gps.LOCATION as Location,va.Unit_Number as PhoneNo from AMS.dbo.Vehicle_User (NOLOCK) vu"+
	" left outer join AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) on vu.Registration_no=vc.REGISTRATION_NUMBER and vu.System_id=vc.SYSTEM_ID"+
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag (NOLOCK) on vc.SYSTEM_ID=ag.SYSTEM_ID and vc.CLIENT_ID=ag.CUSTOMER_ID and vc.GROUP_ID=ag.GROUP_ID"+
	" left outer join AMS.dbo.gpsdata_history_latest gps on vu.Registration_no = gps.REGISTRATION_NO"+
	" left outer join AMS.dbo.Vehicle_association va on va.Registration_no = gps.REGISTRATION_NO"+
	" where vu.System_id=? AND vc.CLIENT_ID=? order by vu.Registration_no";
	
	
	public static final String GET_USERNAME_CUST=" select distinct isNull(Firstname,'')+' '+isNull(Lastname,'') as ASMName, isNull(User_id,0) as ASMId from AMS.dbo.Users a "+
                                                 " inner join ADMINISTRATOR.dbo.ASSET_GROUP b on a.Client_id=b.CUSTOMER_ID AND a.System_id= b.SYSTEM_ID "+
                                                 " where a.System_id=? and a.Client_id=? ";

/*	public static final String GET_USERNAME_LTSP=" select distinct isNull(Firstname,'')+' '+isNull(Lastname,'') as ASMName, isNull(User_id,0) as ASMId from AMS.dbo.Users a "+
                                                 " inner join ADMINISTRATOR.dbo.ASSET_GROUP b on a.Client_id=b.CUSTOMER_ID AND a.System_id= b.SYSTEM_ID "+
                                                 " where a.System_id=? and a.Client_id=? ";*/
		
	public static final String GET_NO_OF_VISITS="select count(*) as NumVisit from AMS.dbo.FIELD_FORCE_CUSTOMER_UPDATE_HISTORY where SYSTEM_ID=? and USER_ID = ? and UPDATED_DATETIME between DATEADD(dd, 0, DATEDIFF(dd, 0, getutcdate())) and getutcdate()";
	
	
	public static final String GET_NO_OF_VISITS_WITHOUT_USERID = " select count(*) as NumVisit from AMS.dbo.FIELD_FORCE_CUSTOMER_UPDATE_HISTORY where SYSTEM_ID=? and UPDATED_DATETIME between DATEADD(dd, 0, DATEDIFF(dd, 0, getutcdate())) and getutcdate() ";
	
	public static final String GET_SYS_VISIT_DETAILS="select isNull(cm.CUSTOMER_NAME,'') as CustomerName,isNull(ch.COMPANY_NAME,'') as CompanyName,isNull(ch.CALL_TYPE,'') as CallType,isNull(ch.CUSTOMER_LAST_REMARKS,'') as Remarks,dateadd(mi,?,isNull(ch.UPDATED_DATETIME,'')) as UpdatedTime from AMS.dbo.FIELD_FORCE_CUSTOMER_UPDATE_HISTORY ch"+
	"  left outer join AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER cm on(ch.CUSTOMER_ID=cm.CUSTOMER_ID) where ch.SYSTEM_ID=? and (ch.UPDATED_DATETIME between DATEADD(dd, 0, DATEDIFF(dd, 0, getutcdate())) and getutcdate())";
	
	public static final String GET_VISIT_DETAILS="select isNull(cm.CUSTOMER_NAME,'') as CustomerName,isNull(ch.COMPANY_NAME,'') as CompanyName,isNull(ch.CALL_TYPE,'') as CallType,isNull(ch.CUSTOMER_LAST_REMARKS,'') as Remarks,dateadd(mi,?,isNull(ch.UPDATED_DATETIME,'')) as UpdatedTime from AMS.dbo.FIELD_FORCE_CUSTOMER_UPDATE_HISTORY ch"+
	"  left outer join AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER cm on(ch.CUSTOMER_ID=cm.CUSTOMER_ID) where ch.SYSTEM_ID=? and ch.USER_ID=? and (ch.UPDATED_DATETIME between DATEADD(dd, 0, DATEDIFF(dd, 0, getutcdate())) and getutcdate())";
	
	public static final String GET_SYS_PENDING_FOLLOW_UPS="select distinct vu.Registration_no as RegistrationNo,isnull(ag.GROUP_NAME,'') as GroupName,gps.LATITUDE as Latitude,gps.LONGITUDE as Longitude,gps.LOCATION as Location,va.Unit_Number as PhoneNo from AMS.dbo.Vehicle_User (NOLOCK) vu"+
	" left outer join AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) on vu.Registration_no=vc.REGISTRATION_NUMBER and vu.System_id=vc.SYSTEM_ID"+
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag (NOLOCK) on vc.SYSTEM_ID=ag.SYSTEM_ID and vc.CLIENT_ID=ag.CUSTOMER_ID and vc.GROUP_ID=ag.GROUP_ID"+
	" left outer join AMS.dbo.gpsdata_history_latest gps on vu.Registration_no = gps.REGISTRATION_NO"+
	" left outer join AMS.dbo.Vehicle_association va on va.Registration_no = gps.REGISTRATION_NO"+
	" where vu.System_id=? and vc.CLIENT_ID=? and gps.GMT <dateadd(hh,-6,getutcdate()) order by vu.Registration_no";
	
	public static final String GET_PENDING_FOLLOW_UPS="select vu.Registration_no as RegistrationNo,isnull(ag.GROUP_NAME,'') as GroupName,gps.LATITUDE as Latitude,gps.LONGITUDE as Longitude,gps.LOCATION as Location,va.Unit_Number as PhoneNo from AMS.dbo.Vehicle_User (NOLOCK) vu"+
	" left outer join AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) on vu.Registration_no=vc.REGISTRATION_NUMBER and vu.System_id=vc.SYSTEM_ID"+
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag (NOLOCK) on vc.SYSTEM_ID=ag.SYSTEM_ID and vc.CLIENT_ID=ag.CUSTOMER_ID and vc.GROUP_ID=ag.GROUP_ID"+
	" left outer join AMS.dbo.gpsdata_history_latest gps on vu.Registration_no = gps.REGISTRATION_NO"+
	" left outer join AMS.dbo.Vehicle_association va on va.Registration_no = gps.REGISTRATION_NO"+
	" where vu.System_id=? and vu.User_id=? and vc.CLIENT_ID=? and  gps.GMT <dateadd(hh,-6,getutcdate()) order by vu.Registration_no,ag.GROUP_NAME";

	/*public static final String GET_CUSTOMER_HISTORY ="select ffm.COMPANY_NAME as employee, (isNull(u.Firstname,'')+' '+isNull(u.Lastname,'')) as supervisor,cm.CUSTOMER_NAME as Customer, dateadd(mi,?,isnull(ffm.UPDATED_DATETIME,'')) as dateofupdate,ffm.CALL_TYPE as calltype "+
													" from AMS.dbo.FIELD_FORCE_CUSTOMER_UPDATE_HISTORY ffm  "+
													" left outer join  AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER cm on ffm.SYSTEM_ID=cm.SYSTEM_ID and ffm.CUSTOMER_ID=cm.CUSTOMER_ID "+
													" left outer join AMS.dbo.Users u on ffm.SYSTEM_ID=u.System_id and ffm.USER_ID=u.User_id where ffm.CUSTOMER_ID=? and ffm.SYSTEM_ID=? and ffm.UPDATED_DATETIME BETWEEN dateadd(mi,-?,?) and dateadd(mi,-?,?) ";
*/
	
	
	public static final String GET_CUSTOMER_HISTORY= " select distinct ffm.COMPANY_NAME as company,isnull(u.Firstname,'')+' '+isnull(u.Lastname,'')as employee,cm.CUSTOMER_NAME as Customer,"+
		" dateadd(mi,?,isnull(ffm.UPDATED_DATETIME,'')) as dateofupdate,ffm.CALL_TYPE as calltype, ffm.CUSTOMER_LAST_REMARKS as Remarks"+
		" from AMS.dbo.FIELD_FORCE_CUSTOMER_UPDATE_HISTORY ffm"+
		" left outer join AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER cm on ffm.SYSTEM_ID=cm.SYSTEM_ID and ffm.CUSTOMER_ID=cm.CUSTOMER_ID"+
		" left outer join AMS.dbo.Users u on ffm.SYSTEM_ID=u.System_id and ffm.USER_ID = u.User_id"+
		" where ffm.SYSTEM_ID=? and ffm.UPDATED_DATETIME BETWEEN dateadd(mi,-?,?) and dateadd(mi,-?,?)";
	
	public static final String GET_FFM_LTSP_CUST_FOR_APPT="select isNull(CUSTOMER_NAME,'') as CustomerName,isNull(CUSTOMER_ID,0) as Id from AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER where SYSTEM_ID=?";

	public static final String GET_FFM_CUST_FOR_APPT="select isNull(CUSTOMER_NAME,'') as CustomerName,isNull(CUSTOMER_ID,0) as Id from AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER where SYSTEM_ID=? and CLIENT_ID=?";
	
	public static final String GET_FFM_EMPLOYEES="select distinct vu.Registration_no as EmployeeName from AMS.dbo.Vehicle_User (NOLOCK) vu"+
	" left outer join AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) on vu.Registration_no=vc.REGISTRATION_NUMBER and vu.System_id=vc.SYSTEM_ID"+
	" where vu.System_id=? and vc.CLIENT_ID=? order by vu.Registration_no";
		
	public static final String INSERT_FFM_APPOINTMENT ="insert into AMS.dbo.FIELD_FORCE_CUSTOMER_APPOINTMENT(CUSTOMER_NAME,SUPERVISOR,EMPLOYEE,APPOINTMENT_TIME,REMARK,FOLLOWUP_DATE,SYSTEM_ID,CLIENT_ID,STATUS,USER_ID) values(?,?,?,?,?,dateadd(mi,-?,?),?,?,?,?)";
		
	public static final String MODIFY_FFM_APPOINTMENT="UPDATE AMS.dbo.FIELD_FORCE_CUSTOMER_APPOINTMENT SET CUSTOMER_NAME = ?,SUPERVISOR = ?,EMPLOYEE=?,APPOINTMENT_TIME = ?,REMARK =?,FOLLOWUP_DATE = dateadd(mi,-?,?),LAST_UPDATED_TIME=getutcdate(),STATUS=?,USER_ID=? WHERE ID=? and SYSTEM_ID = ? and CLIENT_ID=?";
	
	public static final String GET_FFM_APPOINTMENT_DETAILS="select ID as UniqueId,isNull(cm.CUSTOMER_NAME,'') as CustomerName,isNull(us.Firstname,'')+' '+isNull(us.Lastname,'') as Supervisor,isNull(ca.EMPLOYEE,'') as Employee,isNull(ca.APPOINTMENT_TIME,'') as AppointmentTime,isNull(ca.REMARK,'') as Remark,isNull(ca.STATUS,0) as Status,"+
	" isNull(usr.Firstname,'')+' '+isNull(usr.Lastname,'') as EmpUser,dateadd(mi,?,isNull(ca.FOLLOWUP_DATE,'')) as FollowUpDate,isNull(ca.LAST_UPDATED_LOCATION,'') as Location,dateadd(mi,?,isNull(ca.LAST_UPDATED_TIME,'')) as LastUpdatedTime FROM AMS.dbo.FIELD_FORCE_CUSTOMER_APPOINTMENT ca left outer join AMS.dbo.Users us on (ca.SYSTEM_ID=us.System_id and ca.SUPERVISOR=us.User_id)"+ 
	" left outer join AMS.dbo.FIELD_FORCE_CUSTOMER_MASTER cm on ca.CLIENT_ID=cm.CLIENT_ID and ca.SYSTEM_ID=cm.SYSTEM_ID and ca.CUSTOMER_NAME=cm.CUSTOMER_ID left outer join AMS.dbo.Users usr on (ca.SYSTEM_ID=usr.System_id and ca.USER_ID=usr.User_id) where ca.SYSTEM_ID=? and ca.CLIENT_ID=? and dateadd(mi,?,ca.APPOINTMENT_TIME) between ? and ?";

	public static final String DELETE_FFM_APPOINTMENT="delete from AMS.dbo.FIELD_FORCE_CUSTOMER_APPOINTMENT where SYSTEM_ID=? and CLIENT_ID=? and ID=?";
	
	public static final String GET_SYS_PEND_FOLLOW_UP="select count(*) as PendingFollowUp from AMS.dbo.FIELD_FORCE_CUSTOMER_APPOINTMENT where SYSTEM_ID=? and STATUS=0 and CLIENT_ID=? ";
	
	public static final String GET_PEND_FOLLOW_UP="select count(*) as PendingFollowUp from AMS.dbo.FIELD_FORCE_CUSTOMER_APPOINTMENT where SYSTEM_ID=? and USER_ID=? and STATUS=0 and CLIENT_ID=? ";
	
	public static final String GET_SYS_TOTAL_FOLLOW_UP="select count(*) as TotalFollowUp from AMS.dbo.FIELD_FORCE_CUSTOMER_APPOINTMENT where SYSTEM_ID=? and CLIENT_ID=? ";

	public static final String GET_TOTAL_FOLLOW_UP="select count(*) as TotalFollowUp from AMS.dbo.FIELD_FORCE_CUSTOMER_APPOINTMENT where SYSTEM_ID=? and USER_ID=? and CLIENT_ID=? ";
   
	public static final String GET_SYS_PENDING_FOLLOW_UPS_FOR_COMMUNICATING = "select distinct vu.Registration_no as RegistrationNo,isnull(ag.GROUP_NAME,'') as GroupName,gps.LATITUDE as Latitude,gps.LONGITUDE as Longitude,gps.LOCATION as Location,va.Unit_Number as PhoneNo from AMS.dbo.Vehicle_User (NOLOCK) vu"+
	" left outer join AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) on vu.Registration_no=vc.REGISTRATION_NUMBER and vu.System_id=vc.SYSTEM_ID"+
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag (NOLOCK) on vc.SYSTEM_ID=ag.SYSTEM_ID and vc.CLIENT_ID=ag.CUSTOMER_ID and vc.GROUP_ID=ag.GROUP_ID"+
	" left outer join AMS.dbo.gpsdata_history_latest gps on vu.Registration_no = gps.REGISTRATION_NO"+
	" left outer join AMS.dbo.Vehicle_association va on va.Registration_no = gps.REGISTRATION_NO"+
	" where vu.System_id=? and vc.CLIENT_ID=? and gps.GMT >dateadd(hh,-6,getutcdate()) order by vu.Registration_no"; 
	
	public static final String GET_PENDING_FOLLOW_UPS_FOR_COMMUNICATING = "select vu.Registration_no as RegistrationNo,isnull(ag.GROUP_NAME,'') as GroupName,gps.LATITUDE as Latitude,gps.LONGITUDE as Longitude,gps.LOCATION as Location,va.Unit_Number as PhoneNo from AMS.dbo.Vehicle_User (NOLOCK) vu"+
	" left outer join AMS.dbo.VEHICLE_CLIENT vc (NOLOCK) on vu.Registration_no=vc.REGISTRATION_NUMBER and vu.System_id=vc.SYSTEM_ID"+
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag (NOLOCK) on vc.SYSTEM_ID=ag.SYSTEM_ID and vc.CLIENT_ID=ag.CUSTOMER_ID and vc.GROUP_ID=ag.GROUP_ID"+
	" left outer join AMS.dbo.gpsdata_history_latest gps on vu.Registration_no = gps.REGISTRATION_NO"+
	" left outer join AMS.dbo.Vehicle_association va on va.Registration_no = gps.REGISTRATION_NO"+
	" where vu.System_id=? and vu.User_id=? and vc.CLIENT_ID=? and  gps.GMT >dateadd(hh,-6,getutcdate()) order by vu.Registration_no,ag.GROUP_NAME";

}
