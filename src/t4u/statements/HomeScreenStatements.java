package t4u.statements;

public class HomeScreenStatements {

	public  static final String GET_VERTICAL_ASSOCIATION_FOR_CUSTOMER="select a.PROCESS_ID,c.LANG_ENGLISH,c.LANG_ARABIC from dbo.CUSTOMER_PROCESS_ASSOC a " +
																	"inner join PRODUCT_PROCESS b on a.PROCESS_ID = b.PROCESS_ID " +
																	"inner join LANG_LOCALIZATION c on b.PROCESS_LABEL_ID = c.LABEL_ID " +
																	"where a.SYSTEM_ID = ? and a.CUSTOMER_ID = ? " +
																	"and b.PROCESS_TYPE_LABEL_ID='Vertical_Sol' ";
	
	public static final String GET_MENU_GROUP_LABELS_FOR_VERTICAL="select a.MENU_GROUP_ID,a.SUB_PROCESS_ID,b.LANG_ENGLISH,b.LANG_ARABIC from dbo.MENU_GROUP a "+
															"inner join LANG_LOCALIZATION b on b.LABEL_ID=a.MENU_GROUP_LABEL_ID  "+
															"where  a.PROCESS_ID = ? order by a.SUB_PROCESS_ID,a.MENU_GROUP_ID,a.ORDER_OF_DISPALY";
	
	public static final String GET_MENU_LINKS_FOR_VERTICAL="select a.SUB_PROCESS_ID,isnull(a.MENU_GROUP_ID,0) as MENU_GROUP_ID,b.MENU_LABEL_ID,c.ELEMENT_NAME,d.LANG_ENGLISH,d.LANG_ARABIC from dbo.VERTICAL_MENU_DISPLAY a  "+
															"inner join MENU_MASTER b on a.MENU_ID = b.MENU_ID  "+
															"inner join LANG_LOCALIZATION d on b.MENU_LABEL_ID = d.LABEL_ID  "+
															"inner join PRODUCT_ELEMENT c on b.ELEMENT_ID = c.ELEMENT_ID  "+
															"where  a.MENU_ID not in (select MENU_ID from ADMINISTRATOR.dbo.USER_PROCESS_DETACHMENT where SYSTEM_ID=? and USER_ID=?) "+
															"and a.PROCESS_ID =? "+
															"and b.PROCESS_ID in (select PROCESS_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where CUSTOMER_ID=? and SYSTEM_ID=?) "+
															"and (c.ELEMENT_NAME in ('/Jsps/Admin/AdminTab.jsp','/Jsps/Common/Alert.jsp','/Jsps/SandMining/Dashboard.jsp','/Jsps/CashVanManagement/Dashboard.jsp','/Jsps/CargoManagement/ExecutiveDashboard.jsp','/Jsps/Consignment/ConsignmentDashBoard.jsp','/Jsps/Common/ListView.jsp') "+
															"or c.ELEMENT_NAME collate database_default in (select distinct(c.program_name) from AMS.dbo.menu_item_master c where c.system_id=?)) "+
															"order by a.SUB_PROCESS_ID,a.MENU_GROUP_ID,a.ORDER_OF_DISPLAY";
	
	public static final String GET_HORIZANTAL_MENU_LABELS="select a.SUB_PROCESS_ID,b.LANG_ENGLISH,b.LANG_ARABIC from SUB_PROCESS a " +
															"inner join LANG_LOCALIZATION b on a.SUB_PROCESS_LABEL_ID = b.LABEL_ID " +
															"where a.PROCESS_ID = ? order by a.ORDER_OF_DISPLAY";
}
