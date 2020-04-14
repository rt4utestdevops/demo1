package t4u.statements;

public class LTSPStatements {

	public static final String GET_LTSP_VERTICALS="select a.PROCESS_ID as[VERTICAL_ID],c.LANG_ENGLISH,c.LANG_ARABIC,isnull(IMAGE_PATH,'NA')as IMAGE_PATH,isnull(DESCRIPTION,'NA') as DESCRIPTION from dbo.PRODUCT_PROCESS a "+
													"inner join dbo.LANG_LOCALIZATION c on  c.LABEL_ID=a.PROCESS_LABEL_ID "+
													"inner join dbo.PRODUCT_DESCRIPTION d on a.PROCESS_ID=d.PROCESS_ID "+
													"where a.PROCESS_ID in (select DISTINCT PROCESS_ID from dbo.CUSTOMER_PROCESS_ASSOC where SYSTEM_ID=?) and a.PROCESS_TYPE_LABEL_ID='Vertical_Sol' "+
													"group by a.PROCESS_ID,c.LANG_ENGLISH,c.LANG_ARABIC,IMAGE_PATH,DESCRIPTION";
   
	public static final String GET_CLIENT_LIST="select a.CUSTOMER_ID,b.NAME as CUSTOMER_NAME,count(REGISTRATION_NO) as TOTAL_VEHICLES, "+
								"SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) < ? and c.LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END)AS COMM, "+
								"SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >=? THEN 1 ELSE 0 END)AS NONCOMM "+
								"from dbo.CUSTOMER_PROCESS_ASSOC a  "+
								"inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID "+
								"left outer join AMS.dbo.gpsdata_history_latest c on c.CLIENTID=a.CUSTOMER_ID and c.System_id=a.SYSTEM_ID "+
								"where PROCESS_ID=? and a.SYSTEM_ID=? and b.STATUS='Active' and b.ACTIVATION_STATUS='Complete' group by b.NAME,a.CUSTOMER_ID";


   public static final String GET_ADMINISTRATOR_MENU="select e.LANG_ENGLISH,e.LANG_ARABIC,d.ELEMENT_NAME  from ADMINISTRATOR.dbo.MENU_MASTER a "+
													   "inner join LANG_LOCALIZATION e on e.LABEL_ID=a.MENU_LABEL_ID "+
													   "inner join ADMINISTRATOR.dbo.PRODUCT_ELEMENT d on d.ELEMENT_ID=a.ELEMENT_ID "+
													   "where a.PROCESS_ID in (20,21) and (a.SUB_PROCESS_ID in (1,5) or a.MENU_LABEL_ID in('Alert_User_Association') ) and (d.ELEMENT_NAME in ('/Jsps/Admin/AdminTab.jsp') or d.ELEMENT_NAME collate database_default in (select distinct(c.program_name) from AMS.dbo.menu_item_master c where c.system_id=?)) "+
													   "and  a.MENU_ID not in (select MENU_ID from ADMINISTRATOR.dbo.USER_PROCESS_DETACHMENT where SYSTEM_ID=? and USER_ID=?) "+
													   "order by a.PROCESS_ID,a.SUB_PROCESS_ID,a.ORDER_OF_DISPLAY asc ";
   
   public static final String GET_ADMINISTRATOR_MENU_WITHOUT_ASSOC="select e.LANG_ENGLISH,e.LANG_ARABIC,d.ELEMENT_NAME  from ADMINISTRATOR.dbo.MENU_MASTER a "+
																   "inner join LANG_LOCALIZATION e on e.LABEL_ID=a.MENU_LABEL_ID "+
																   "inner join ADMINISTRATOR.dbo.PRODUCT_ELEMENT d on d.ELEMENT_ID=a.ELEMENT_ID "+
																   "where a.PROCESS_ID in (20,21) and (a.SUB_PROCESS_ID in (1,5) or a.MENU_LABEL_ID in('Alert_User_Association')) and (d.ELEMENT_NAME in ('/Jsps/Admin/AdminTab.jsp') or d.ELEMENT_NAME collate database_default in (select distinct(c.program_name) from AMS.dbo.menu_item_master c where c.system_id=?)) "+
																   "order by a.PROCESS_ID,a.SUB_PROCESS_ID,a.ORDER_OF_DISPLAY asc";
   
   public static final String GET_LTSP_NEW_VERTICALS="select e.PROCESS_ID as[VERTICAL_ID],g.LANG_ENGLISH,g.LANG_ARABIC,isnull(IMAGE_PATH,'NA')as IMAGE_PATH,isnull(DESCRIPTION,'NA') as DESCRIPTION from dbo.PRODUCT_PROCESS e  "+
													   "inner join dbo.PRODUCT_DESCRIPTION f on e.PROCESS_ID=f.PROCESS_ID "+
													   "inner join dbo.LANG_LOCALIZATION g on g.LABEL_ID=e.PROCESS_LABEL_ID "+
													   "where e.PROCESS_ID not in (select DISTINCT a.PROCESS_ID from dbo.CUSTOMER_PROCESS_ASSOC a where a.SYSTEM_ID=?)";
  
   public static final String GET_READ_MORE_INFO = "select CONTENTS from dbo.PRODUCT_DESCRIPTION where PROCESS_ID=?";
   
//   public static final String GET_COMMU_NONCOMMU_COUNT_FOR_LTSP="select count(*) as TOTAL_VEHICLES, "+ 
//													"SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) < 6 and LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END)AS COMM, "+
//													"SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >=6  and LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END)AS NONCOMM , "+
//													"SUM(CASE WHEN LOCATION ='No GPS Device Connected' THEN 1 ELSE 0 END)AS NOGPS "+
//													"from AMS.dbo.gpsdata_history_latest where System_id=? ";	
   
   public static final String GET_COMMU_NONCOMMU_COUNT_FOR_LTSP = " select count(*) as TOTAL_VEHICLES, "+
   " SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) < ? and LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END)AS COMM, "+
   " SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >=?  and LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END)AS NONCOMM , "+
   " SUM(CASE WHEN LOCATION ='No GPS Device Connected' THEN 1 ELSE 0 END)AS NOGPS "+
   " from AMS.dbo.gpsdata_history_latest a "+
   " inner join AMS.dbo.Vehicle_User b on a.REGISTRATION_NO = b.Registration_no and a.System_id = b.System_id "+
   " inner join tblVehicleMaster c on b.Registration_no=c.VehicleNo and b.System_id=c.System_id "+
   " where a.System_id=? and b.User_id = ? ";
   
   public static final String GET_CUSTOMER_NAMES = "select b.NAME as CUSTOMER_NAME from dbo.CUSTOMER_PROCESS_ASSOC a "+
													"inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID "+													
													"where a.SYSTEM_ID=? and b.STATUS='Active' and b.ACTIVATION_STATUS='Complete' group by b.NAME,a.CUSTOMER_ID";

   public static final String GET_CUSTOMER_BASED_ON_NAME = "select d.PROCESS_ID,a.CUSTOMER_ID,b.NAME as CUSTOMER_NAME,count(REGISTRATION_NO) as TOTAL_VEHICLES, "+
														"SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) < ? and c.LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END)AS COMM,"+ 
														"SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >=? THEN 1 ELSE 0 END)AS NONCOMM "+  
														"from dbo.PRODUCT_PROCESS d "+ 
														"inner join dbo.CUSTOMER_PROCESS_ASSOC a on  a.PROCESS_ID=d.PROCESS_ID "+ 
														"inner join ADMINISTRATOR.dbo.CUSTOMER_MASTER b on a.CUSTOMER_ID=b.CUSTOMER_ID and a.SYSTEM_ID=b.SYSTEM_ID "+
														"left outer join AMS.dbo.gpsdata_history_latest c on c.CLIENTID=b.CUSTOMER_ID and c.System_id=b.SYSTEM_ID "+  
														"where b.NAME=? and b.SYSTEM_ID=? and b.STATUS='Active' and b.ACTIVATION_STATUS='Complete' and d.PROCESS_TYPE_LABEL_ID='Vertical_Sol' "+" group by b.NAME,a.CUSTOMER_ID,d.PROCESS_ID";

}
