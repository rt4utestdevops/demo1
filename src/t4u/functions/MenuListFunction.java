package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;

/**
 * 
 * @author mallikarjuna.c
 *  To fetch the the header menu list 
 * @param : systemId,customerId,userId,lang
 *  @return :  JsonObject 
 */

public class MenuListFunction {

	public  static final String GET_VERTICAL_ASSOCIATION_FOR_CUSTOMER="select a.PROCESS_ID,c.LANG_ENGLISH,c.LANG_ARABIC from dbo.CUSTOMER_PROCESS_ASSOC a " +
	"inner join PRODUCT_PROCESS b on a.PROCESS_ID = b.PROCESS_ID " +
	"inner join LANG_LOCALIZATION c on b.PROCESS_LABEL_ID = c.LABEL_ID " +
	"where a.SYSTEM_ID =? and a.CUSTOMER_ID =? " +
	"and b.PROCESS_TYPE_LABEL_ID='Vertical_Sol' ";

	public static final String GET_MENU_GROUP_LABELS_FOR_VERTICAL=" select a.MENU_GROUP_ID,a.SUB_PROCESS_ID,b.LANG_ENGLISH,b.LANG_ARABIC from dbo.MENU_GROUP a  "+
	" inner join LANG_LOCALIZATION b on b.LABEL_ID=a.MENU_GROUP_LABEL_ID   "+
	" where  a.PROCESS_ID = ?  and a.MENU_GROUP_ID in (select distinct isnull(a.MENU_GROUP_ID,0) as MENU_GROUP_ID "+
	" from dbo.VERTICAL_MENU_DISPLAY a   "+
	" inner join MENU_MASTER b on a.MENU_ID = b.MENU_ID "+
	" where  a.MENU_ID not in (select MENU_ID from ADMINISTRATOR.dbo.USER_PROCESS_DETACHMENT where SYSTEM_ID=? and USER_ID=?)  "+
	" and a.PROCESS_ID =? "+
	" and b.PROCESS_ID in (select PROCESS_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where CUSTOMER_ID=? and SYSTEM_ID=?) ) order by a.SUB_PROCESS_ID,a.MENU_GROUP_ID,a.ORDER_OF_DISPALY ";

	public static final String GET_MENU_LINKS_FOR_VERTICAL="select a.SUB_PROCESS_ID,isnull(a.MENU_GROUP_ID,0) as MENU_GROUP_ID,b.MENU_LABEL_ID,c.ELEMENT_NAME,d.LANG_ENGLISH,d.LANG_ARABIC from dbo.VERTICAL_MENU_DISPLAY a  "+
	"inner join MENU_MASTER b on a.MENU_ID = b.MENU_ID  "+
	"inner join LANG_LOCALIZATION d on b.MENU_LABEL_ID = d.LABEL_ID  "+
	"inner join PRODUCT_ELEMENT c on b.ELEMENT_ID = c.ELEMENT_ID "+
	"where  a.MENU_ID not in (select MENU_ID from ADMINISTRATOR.dbo.USER_PROCESS_DETACHMENT where SYSTEM_ID=? and USER_ID=?) "+
	"and a.PROCESS_ID =? "+
	"and b.PROCESS_ID in (select PROCESS_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where CUSTOMER_ID=? and SYSTEM_ID=?) "+
	"and (c.ELEMENT_NAME in ('/Jsps/Admin/AdminTab.jsp','/Jsps/Common/Alert.jsp','/Jsps/SandMining/Dashboard.jsp','/Jsps/CashVanManagement/Dashboard.jsp','/Jsps/CargoManagement/ExecutiveDashboard.jsp','/Jsps/Consignment/ConsignmentDashBoard.jsp','/Jsps/Common/ListView.jsp') "+
	"or c.ELEMENT_NAME collate database_default in (select distinct(c.program_name) from AMS.dbo.menu_item_master c where c.system_id=?)) "+
	"order by a.SUB_PROCESS_ID,a.MENU_GROUP_ID,a.ORDER_OF_DISPLAY";

	public static final String GET_HORIZANTAL_MENU_LABELS="select a.SUB_PROCESS_ID,b.LANG_ENGLISH,b.LANG_ARABIC from SUB_PROCESS a " +
	"inner join LANG_LOCALIZATION b on a.SUB_PROCESS_LABEL_ID = b.LABEL_ID " +
	"where a.PROCESS_ID = ? # order by a.ORDER_OF_DISPLAY";

	private static final String CHECK_USERT_TRIP_CUSTOMER_ASSOCIATION = "select TRIP_CUSTOMER_ID from AMS.dbo.USER_TRIP_CUST_ASSOC where SYSTEM_ID=? and USER_ID=?";

	public static final String GET_MENU_LINKS_FOR_VERTICAL_ROLE_BASED = "select a.SUB_PROCESS_ID,isnull(a.MENU_GROUP_ID,0) as MENU_GROUP_ID,b.MENU_LABEL_ID,c.ELEMENT_NAME,d.LANG_ENGLISH,d.LANG_ARABIC from dbo.VERTICAL_MENU_DISPLAY a  "
			+ "inner join MENU_MASTER b on a.MENU_ID = b.MENU_ID  "
			+ "inner join LANG_LOCALIZATION d on b.MENU_LABEL_ID = d.LABEL_ID  "
			+ "inner join PRODUCT_ELEMENT c on b.ELEMENT_ID = c.ELEMENT_ID "
			+ "where  a.MENU_ID   in (select MENU_ID from ADMINISTRATOR.dbo.ROLE_MENU where SYSTEM_ID=? and CUSTOMER_ID=?  and ROLE_ID = ? AND STATUS = 'Active') "
			+ "and a.PROCESS_ID in  ( select PROCESS_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where CUSTOMER_ID=? and SYSTEM_ID=? ) "
			+ "and b.PROCESS_ID in (select PROCESS_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where CUSTOMER_ID=? and SYSTEM_ID=?) "
			+ "and (c.ELEMENT_NAME in ('/Jsps/Admin/AdminTab.jsp','/Jsps/Common/Alert.jsp','/Jsps/SandMining/Dashboard.jsp','/Jsps/CashVanManagement/Dashboard.jsp','/Jsps/CargoManagement/ExecutiveDashboard.jsp','/Jsps/Consignment/ConsignmentDashBoard.jsp','/Jsps/Common/ListView.jsp') "
			+ "or c.ELEMENT_NAME collate database_default in (select distinct(c.program_name) from AMS.dbo.menu_item_master c where c.system_id=?)) "
			+ "order by a.SUB_PROCESS_ID,a.MENU_GROUP_ID,a.ORDER_OF_DISPLAY";

	public static String getLanuage = "LANG_ENGLISH";
	public static String dashBoardTitle = "";
	public static String defaultLink = "";

	public  JSONObject getMenuList(int systemId,int customerId,int userId,String lang ){
		Connection con=null;
		JSONObject finalObj = null;
		defaultLink = "";
		try {
			con=DBConnection.getConnectionToDB("ADMINISTRATOR");
			int processId=0;
			if(lang.equals("ar"))
			{
				getLanuage="LANG_ARABIC";
			}else{
				getLanuage="LANG_ENGLISH";
			}
			Map<Integer, String> pId = getProcessId(con, systemId, customerId);
			if(pId!=null){
				Iterator<Entry<Integer, String>> vmenu = pId.entrySet().iterator();
				if(vmenu.hasNext()){
					Entry<Integer, String> verticalMenu = vmenu.next();
					processId=verticalMenu.getKey();
				}
				Map<Integer, String> horizontalMenu = getHorizontalMenu(con, processId, userId, systemId);
				HashMap<String, String> verticalMenu = getMenuGroup(con, systemId, customerId, processId, userId);
				Map<String, JSONArray> menuItems = getVerticalMenus(con, systemId, customerId, processId, userId, horizontalMenu, verticalMenu);
				JSONArray finalJson = getMenuGroup1(horizontalMenu, verticalMenu, menuItems);
				Iterator<Entry<String, JSONArray>> map = menuItems.entrySet().iterator();
				if (map.hasNext()) {
					JSONArray array = map.next().getValue();
					
					for (int k = 0; k < array.length(); k++) {
						JSONObject obj = new JSONObject();
						obj = (JSONObject) array.get(k);
						if (obj.length() > 0) {
							if (obj.get("link").toString().length() > 0){
								defaultLink = obj.get("link").toString();
								break;
							}else{
								JSONArray jarr = obj.getJSONArray("sub");
								for (int j= 0;j<jarr.length();j++){
									JSONObject objj = jarr.getJSONObject(j);
									if (objj.get("link").toString().length() > 0){
										defaultLink = objj.get("link").toString();
										break;
									}
								}
								
							}
							
						}
					}
				}
				
				JSONArray finalNewJson = new JSONArray();
				
				for (int j=0;j<finalJson.length();j++){
					JSONObject obj = finalJson.getJSONObject(j);
					 if (obj.length() > 0 && obj !=null){
						 JSONArray subArr = obj.getJSONArray("sub");
						  		if (subArr.length() > 0){
						  			finalNewJson.put(obj);
						  		}
					 }
				}
				
				finalObj = new JSONObject();
				finalObj.put("title", dashBoardTitle);
				finalObj.put("defaultLink", defaultLink);
				finalObj.put("menu", finalNewJson);
			} else {
				System.out.println("processid is null");
			}


		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, null, null);
		}
		return finalObj;
	}

	public static JSONArray getMenuGroup1(Map<Integer, String> horizontalMenu,HashMap<String, String> verticalMenu,Map<String, JSONArray> menuItems){
		JSONObject hMenuJson=null;
		JSONArray finalJson = new JSONArray();
		try {

			Iterator<Entry<String, JSONArray>> menuitems = menuItems.entrySet().iterator();
			while(menuitems.hasNext()){
				Entry<String, JSONArray> items = menuitems.next();
				String key = items.getKey();
				JSONArray menuArray = items.getValue();
				boolean submenu = verticalMenu.containsKey(key);
				if(submenu){
					String menu = verticalMenu.get(key);
					JSONObject vmenu= new JSONObject();
					JSONArray array=new JSONArray();
					vmenu.put("name", menu);
					vmenu.put("link", "");
					vmenu.put("sub", menuArray);
					array.put(vmenu);
					menuItems.put(key, array);
				}
			}

			Iterator<Entry<Integer, String>> itr = horizontalMenu.entrySet().iterator();
			while(itr.hasNext()){
				hMenuJson = new JSONObject();
				Entry<Integer, String> hmenu = itr.next();
				int hmenuId=hmenu.getKey();
				String hmenuName=hmenu.getValue();
				List<JSONArray> hmenuList = new ArrayList<JSONArray>();
				Iterator<Entry<String, JSONArray>> menuitems1 = menuItems.entrySet().iterator();
				while(menuitems1.hasNext()){
					Entry<String, JSONArray> items = menuitems1.next();
					String key = items.getKey();
					  if (key.length() > 0 && key.contains("@")) {
							String[] hmenu1 = key.split("@");
							if (Integer.parseInt(hmenu1[0]) == (hmenuId)) {
								hmenuList.add(items.getValue());
							}
					  }
				}
				if(hmenuName.equalsIgnoreCase("Dashboard")){
					hMenuJson.put("name", hmenuName);
					hMenuJson.put("link", "");
					hMenuJson.put("sub", hmenuList);
					finalJson.put(hMenuJson);
				}else{
					hMenuJson.put("name", hmenuName);
					hMenuJson.put("link", "");
					hMenuJson.put("sub", hmenuList);
					finalJson.put(hMenuJson);
				}
				
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return finalJson;

	}

	public static HashMap<String, String> getMenuGroup(Connection con,int systemId,int customerId,int processId,int userId){
		PreparedStatement pstmt =null;
		ResultSet rs=null;
		HashMap<String, String> menuGroupNames = new HashMap<String, String>();
		try {
			pstmt = con.prepareStatement(GET_MENU_GROUP_LABELS_FOR_VERTICAL);
			pstmt.setInt(1, processId);
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userId);
			pstmt.setInt(4, processId);
			pstmt.setInt(5, customerId);
			pstmt.setInt(6, systemId);
			rs = pstmt.executeQuery();
			while(rs.next()){				
				menuGroupNames.put(rs.getString("SUB_PROCESS_ID")+"@"+rs.getString("MENU_GROUP_ID"), rs.getString(getLanuage));

			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return menuGroupNames;
	}

	public static Map<String, JSONArray> getVerticalMenus(Connection con, int systemId, int customerId, int processId, int userId, Map<Integer, String> horizontalMenu,
			HashMap<String, String> verticalMenu) {
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		CommonFunctions cf = new CommonFunctions();
		int totalVeh = -1;
		boolean roleBased = false;
		Map<String, JSONArray> menuItems = new LinkedHashMap<String, JSONArray>();

		try {
			roleBased = cf.checkForRoleBasedMenu(systemId, customerId);

			if (roleBased) {
				int roleId = cf.getRoleIdByUserId(con, systemId, userId);
				pstmt = con.prepareStatement(GET_MENU_LINKS_FOR_VERTICAL_ROLE_BASED);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, roleId);
				// pstmt.setInt(4, processId);
				pstmt.setInt(4, customerId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, customerId);
				pstmt.setInt(7, systemId);
				pstmt.setInt(8, systemId);
			} else {
				pstmt = con.prepareStatement(GET_MENU_LINKS_FOR_VERTICAL);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, processId);
				pstmt.setInt(4, customerId);
				pstmt.setInt(5, systemId);
				pstmt.setInt(6, systemId);
			}
			rs = pstmt.executeQuery();
			String presentKey = "";
			String previousKey = "";
			String path = "";
			//CommonFunctions cf = new CommonFunctions();
			totalVeh = cf.getVehicleCount(customerId,systemId,userId);
			JSONArray array = new JSONArray();
			while (rs.next()) {
				int currentSubProcessID = rs.getInt("SUB_PROCESS_ID");
				int currentMenuGroupId = rs.getInt("MENU_GROUP_ID");
				String name = rs.getString(getLanuage);
				String link = "";
				if (rs.getString("ELEMENT_NAME").substring(0, 5).equals("/Jsps")) {
					path = "/Telematics4uApp";
					if ((systemId==262) && rs.getString("ELEMENT_NAME").equals("/Jsps/Common/ListView.jsp")) {
						link = path + "/Jsps/Common/LiveVisionWithTableData.jsp";
					} 
					else if((systemId==261 ) && rs.getString("ELEMENT_NAME").equals("/Jsps/Common/ListView.jsp") && totalVeh > 4000) {
					    link = path + "/Jsps/Common/LiveVisionWithTableData.jsp";
					}else{
						link = path + rs.getString("ELEMENT_NAME");
					}
				} else {
					 link=rs.getString("ELEMENT_NAME");
				}
				String sub=null;
				presentKey=currentSubProcessID+"@"+currentMenuGroupId;
				if(rs.getRow()==1){
					previousKey=presentKey;
				}
				if(!presentKey.equalsIgnoreCase(previousKey)){
					menuItems.put(previousKey, array);
					array = new JSONArray();
					JSONObject json = new JSONObject();
					json.put("name", name);
					json.put("link", link);
					json.put("sub",sub);
					if(!((systemId==223 ) && link.equals("/Telematics4uApp/Jsps/Common/Alert.jsp"))){
						array.put(json);	
					}
				}else{
					JSONObject json = new JSONObject();
					json.put("name", name);
					json.put("link", link);
					json.put("sub",sub);
					if(!((systemId==223 ) && link.equals("/Telematics4uApp/Jsps/Common/Alert.jsp"))){
						array.put(json);	
					}
				}
				previousKey=presentKey;
			}
			menuItems.put(previousKey, array);
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return menuItems;
	}

	public static Map<Integer, String> getProcessId(Connection con,int systemId,int customerId){
		PreparedStatement pstmt =null;
		ResultSet rs=null;
		Map<Integer, String> horizontalMap = null;
		try {
			horizontalMap = new HashMap<Integer, String>();
			pstmt=con.prepareStatement(GET_VERTICAL_ASSOCIATION_FOR_CUSTOMER);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,customerId);
			rs=pstmt.executeQuery();
			if(rs.next()){
				horizontalMap.put(rs.getInt("PROCESS_ID"), rs.getString(getLanuage));
				dashBoardTitle=rs.getString(getLanuage);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return horizontalMap;
	}
	public static  Map<Integer, String> getHorizontalMenu(Connection con,int processId,int userId,int systemId){
		PreparedStatement pstmt =null;
		ResultSet rs=null;
		Map<Integer, String> horizontalMap = new LinkedHashMap<Integer, String>();
		String stmt = GET_HORIZANTAL_MENU_LABELS;
		try {
			/* This block will check the USER_TRIP_CUSTOMER_ASSOC table.
			 * If records are there, User is Customer User Login, else he is just a client login.
			 * For Customer User Login Live Vision and Alert are excluded , others those will be visible 
			 * It is developed for DHL purpose now. 
			 */
			pstmt = con.prepareStatement(CHECK_USERT_TRIP_CUSTOMER_ASSOCIATION);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, userId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				stmt = stmt.replace("#", " and LANG_ENGLISH not in ('Live Vision','Alerts')");
			}else{
				stmt = stmt.replace("#", " ");
			}
			pstmt=con.prepareStatement(stmt);
			pstmt.setInt(1,processId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				if (processId == 24) {

					if ((rs.getInt("SUB_PROCESS_ID") != 10)
							&& (rs.getInt("SUB_PROCESS_ID") != 11)
							&& (rs.getInt("SUB_PROCESS_ID") != 12)
							&& (rs.getInt("SUB_PROCESS_ID") != 17)) {
						horizontalMap.put(rs.getInt("SUB_PROCESS_ID"), rs.getString(getLanuage));
					}
				} else {
					horizontalMap.put(rs.getInt("SUB_PROCESS_ID"), rs.getString(getLanuage));
				}
				//horizontalMap.put(rs.getInt("SUB_PROCESS_ID"), rs.getString(getLanuage));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}

		return horizontalMap;
	}

}
