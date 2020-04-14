package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import t4u.common.DBConnection;
import t4u.statements.HomeScreenStatements;

public class HomeScreenFunctions {	
	String getLanuage="LANG_ENGLISH";	
	public HashMap<Object, Object> getVerticalMenus(String path, int systemId, int customerId, int userId,String processId,String language,int totalVehicles) {
		System.out.println(systemId + " " + customerId + " " + userId );
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rsIntial = null;
		ResultSet rs = null;
		ResultSet rs1 = null;	
		
			
		StringBuilder sbMenuList = new StringBuilder();
		HashMap<Object, Object> verticalMenusList = new HashMap<Object, Object>();
		HashMap<String, String> menuGroupNames = new HashMap<String, String>();
		int verticalMenusCount = 0;
		int subVerticalMenusCount = 0;
		int defaultDashboard=0;
		int defaultLiveVision=0;
		int dashboardSubProcessId=0;
		int livevisionSubProcessId=0;
		String defaultDashboardPath="";
		String defaultLiveVisionPath="";
		String listOfMenus = "";
		int count=0;		
		try {
			
			if(language.equals("ar"))
			{
				getLanuage="LANG_ARABIC";
			}
			connection = DBConnection.getConnectionToDB("ADMINISTRATOR");
			
			pstmt = connection.prepareStatement(HomeScreenStatements.GET_VERTICAL_ASSOCIATION_FOR_CUSTOMER);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rsIntial = pstmt.executeQuery();
			if(rsIntial.next()){				
				String defaultLink = "";
				int defaultLinkId = 0;				
				pstmt = connection.prepareStatement(HomeScreenStatements.GET_MENU_GROUP_LABELS_FOR_VERTICAL);
				pstmt.setInt(1, rsIntial.getInt("PROCESS_ID"));
				rs = pstmt.executeQuery();
				while(rs.next()){				
						menuGroupNames.put(rs.getString("MENU_GROUP_ID")+"@"+rs.getString("SUB_PROCESS_ID"), rs.getString(getLanuage));
					
				}
					
					boolean firstLineCode = true;	
					int previousMenuGroupId = 0;
					int currentMenuGroupId = 0;
					int currentSubProcessID=0;
					int previousSubProcessID=0;
						pstmt = connection.prepareStatement(HomeScreenStatements.GET_MENU_LINKS_FOR_VERTICAL);	
						pstmt.setInt(1, systemId);
						pstmt.setInt(2, userId);
						pstmt.setInt(3, rsIntial.getInt("PROCESS_ID"));
						pstmt.setInt(4, customerId);
						pstmt.setInt(5, systemId);						
						pstmt.setInt(6, systemId);						
						
						  final long startTime = System.currentTimeMillis();		
					rs1 = pstmt.executeQuery();		
					final long endTime = System.currentTimeMillis();					
					System.out.println("-Total execution time: " + (endTime - startTime)/1000 );
					while (rs1.next()) {
						if(rs1.getRow()==1)
						{
							currentSubProcessID=rs1.getInt("SUB_PROCESS_ID");
							previousSubProcessID=rs1.getInt("SUB_PROCESS_ID");
						}else{
							previousSubProcessID=currentSubProcessID;
							currentSubProcessID=rs1.getInt("SUB_PROCESS_ID");
						}
						if(count!=0){
							if( currentSubProcessID!=previousSubProcessID){
								if(count!=0){								
									if(previousMenuGroupId != 0){
										sbMenuList.append("</ul>");
										sbMenuList.append("\n");
										sbMenuList.append("</div>");
										sbMenuList.append("\n");
										sbMenuList.append("</li>");
										sbMenuList.append("\n");
									}													
										sbMenuList.append("</div>");
																
									}
								 firstLineCode = true;	
								 previousMenuGroupId = 0;
								 currentMenuGroupId = 0;
							}
						}
						
						if (rs1.getString("ELEMENT_NAME").substring(0, 5).equals("/Jsps")) {
							path = "/Telematics4uApp";
							if (verticalMenusCount == 0) {
								defaultLink = path + rs1.getString("ELEMENT_NAME");
								defaultLinkId = rs1.getInt("SUB_PROCESS_ID");
							}
						} else {
							path = "";
						}
						if(rs1.getString("MENU_LABEL_ID").equals("Vertical_Dashboard")){
							defaultDashboard++;
							defaultDashboardPath=path+rs1.getString("ELEMENT_NAME");
							dashboardSubProcessId=rs1.getInt("SUB_PROCESS_ID");
						}
						
						if(rs1.getString("MENU_LABEL_ID").equals("Mapview")){
							defaultLiveVision++;
							defaultLiveVisionPath=path+rs1.getString("ELEMENT_NAME");
							livevisionSubProcessId=rs1.getInt("SUB_PROCESS_ID");
						}
						
						verticalMenusCount++;							
						if (firstLineCode) {							
							sbMenuList.append("<div id = 'div"+rs1.getInt("SUB_PROCESS_ID")+"' hidden = 'true'>");
							sbMenuList.append("\n");
						}
						
						if(rs1.getInt("MENU_GROUP_ID")!= 0){							
							currentMenuGroupId = rs1.getInt("MENU_GROUP_ID");
															
							if(previousMenuGroupId == 0 || currentMenuGroupId != previousMenuGroupId){
								if(previousMenuGroupId != 0 && currentMenuGroupId != previousMenuGroupId){
									sbMenuList.append("</ul>");
									sbMenuList.append("\n");
									sbMenuList.append("</div>");
									sbMenuList.append("\n");
									sbMenuList.append("</li>");
									sbMenuList.append("\n");
								}
							
								String subMenuName = menuGroupNames.get(rs1.getInt("MENU_GROUP_ID")+"@"+rs1.getInt("SUB_PROCESS_ID"));
								subVerticalMenusCount ++;
								sbMenuList.append("<li onclick=@$toggleSubMenuFunction('subListId"+subVerticalMenusCount+"')@$ class = 'subIcons verticalList'><a class='gn-icon gn-icon-videos'>"+subMenuName+"<img id = 'subMenuImageID"+subVerticalMenusCount+"' src ='/ApplicationImages/ApplicationButtonIcons/icon_plus.png' alt></a>");
								sbMenuList.append("\n");
								sbMenuList.append("<div id = 'subListId"+subVerticalMenusCount+"' hidden= 'true'>");
								sbMenuList.append("\n");
								sbMenuList.append("<ul>");
								sbMenuList.append("\n");	
								sbMenuList.append("<li class = 'verticalList'  id='verticalSubMenu' onclick=@$getJSPPage('"+ path + rs1.getString("ELEMENT_NAME")+"', '#list"+verticalMenusCount+"')@$><a id = 'list"+verticalMenusCount+"' class='gn-icon gn-icon-videos' style='font-weight: bolder'>"+rs1.getString(getLanuage)+"</a></li>");
								sbMenuList.append("\n");
							} else if(previousMenuGroupId == currentMenuGroupId) {
								sbMenuList.append("<li class = 'verticalList'  id='verticalSubMenu' onclick=@$getJSPPage('"+ path + rs1.getString("ELEMENT_NAME")+"', '#list"+verticalMenusCount+"')@$><a id = 'list"+verticalMenusCount+"' class='gn-icon gn-icon-videos' style='font-weight: bolder'>"+rs1.getString(getLanuage)+"</a></li>");
								sbMenuList.append("\n");
							}
							previousMenuGroupId = currentMenuGroupId;
						} else {
							sbMenuList.append("<li class = 'verticalList'  id='verticalSubMenu' onclick=@$getJSPPage('"+path+ rs1.getString("ELEMENT_NAME")+"', '#list"+verticalMenusCount+"')@$><a id = 'list"+verticalMenusCount+"' class='gn-icon gn-icon-videos' style='font-weight: bolder'>"+rs1.getString(getLanuage)+"</a></li>");						
						}
						sbMenuList.append("\n");
						firstLineCode = false;	
						count++;
					
					}	
								
				
				if(defaultDashboard==1){
					verticalMenusList.put("dashboardProcessId", dashboardSubProcessId);
					verticalMenusList.put("dashboardPath", defaultDashboardPath);
				}
				if(defaultLiveVision==1){
					verticalMenusList.put("liveVisionProcessId", livevisionSubProcessId);
					verticalMenusList.put("liveVisionPath", defaultLiveVisionPath);
				}
					
				listOfMenus = sbMenuList.toString().replace("@$", "\"");			
				verticalMenusList.put("verticalMenus", listOfMenus);
				verticalMenusList.put("subVerticalMenusCount", String.valueOf(subVerticalMenusCount));
				verticalMenusList.put("verticalMenusCount", String.valueOf(verticalMenusCount));
				verticalMenusList.put("verticalName", rsIntial.getString(getLanuage));
				verticalMenusList.put("defaultLink", defaultLink);
				verticalMenusList.put("defaultLinkId", defaultLinkId);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				DBConnection.releaseConnectionToDB(connection, pstmt, rsIntial);
				DBConnection.releaseConnectionToDB(null, null, rs);
				DBConnection.releaseConnectionToDB(null, null, rs1);				
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return verticalMenusList;
	}
	
	public HashMap<Object, Object> getHorizontalMenus(int systemId,
			int customerId, int userId, String processId, String language) {
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rsIntial = null;
		ResultSet rs = null;
		StringBuilder sbHorizontalMenus = new StringBuilder();
		HashMap<Object, Object> horizontalMenus = new HashMap<Object, Object>();
		ArrayList<Integer> horizontalMenusSubId = new ArrayList<Integer>();
		int horizontalMenusCount = 0;
		String listOfMenus = "";
		try {
			if (language.equals("ar")) {
				getLanuage = "LANG_ARABIC";
			}
				connection = DBConnection.getConnectionToDB("ADMINISTRATOR");
				pstmt = connection.prepareStatement(HomeScreenStatements.GET_VERTICAL_ASSOCIATION_FOR_CUSTOMER);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, customerId);
				rsIntial = pstmt.executeQuery();
				if (rsIntial.next()) {
					pstmt = connection.prepareStatement(HomeScreenStatements.GET_HORIZANTAL_MENU_LABELS);
					pstmt.setInt(1, rsIntial.getInt("PROCESS_ID"));
					rs = pstmt.executeQuery();
					while (rs.next()) {
						// This if block should be removed after moving all ltsp
						// to new vertical
						if (rsIntial.getInt("PROCESS_ID") == 24) {

							if ((rs.getInt("SUB_PROCESS_ID") != 10)
									&& (rs.getInt("SUB_PROCESS_ID") != 11)
									&& (rs.getInt("SUB_PROCESS_ID") != 12)
									&& (rs.getInt("SUB_PROCESS_ID") != 17)) {
								horizontalMenusCount++;
								sbHorizontalMenus.append("<li id = '"+ rs.getInt("SUB_PROCESS_ID")+ "' onclick = @$getVerticalMenus('#menu"+ horizontalMenusCount+ "', "+ rs.getInt("SUB_PROCESS_ID")+ ")@$><a id = 'menu"+ horizontalMenusCount+ "'>"+ rs.getString(getLanuage).toUpperCase()+ "</a></li>");
								sbHorizontalMenus.append("\n");
								horizontalMenusSubId.add(rs.getInt("SUB_PROCESS_ID"));
							}
						} else {
							horizontalMenusCount++;
							sbHorizontalMenus.append("<li id = '"+ rs.getInt("SUB_PROCESS_ID")+ "' onclick = @$getVerticalMenus('#menu"+ horizontalMenusCount + "', "+ rs.getInt("SUB_PROCESS_ID")+ ")@$><a id = 'menu"+ horizontalMenusCount + "'>"+ rs.getString(getLanuage).toUpperCase()+ "</a></li>");
							sbHorizontalMenus.append("\n");
							horizontalMenusSubId.add(rs.getInt("SUB_PROCESS_ID"));
						}
					}
				}
				/*
				 * For Secure Value History Analysis No Action to be taken on
				 * Dashboard
				 */
			if (systemId == 257 && customerId == 4522 && userId == 198) {
				sbHorizontalMenus.setLength(0);
				sbHorizontalMenus.append("<li id = '25' onclick = @$getVerticalMenus('#menu1', 25)@$><a id = 'menu1'>DASHBOARD</a></li>");
				sbHorizontalMenus.append("<li id = '26' onclick = @$getVerticalMenus('#menu2', 26)@$><a id = 'menu2'>HISTORY ANALYSIS</a></li>");
			}
			listOfMenus = sbHorizontalMenus.toString();
			listOfMenus = listOfMenus.replace("@$", "\"").toString();
			horizontalMenus.put("horizontalMenus", listOfMenus.toString());
			horizontalMenus.put("horizontalMenusSubId", horizontalMenusSubId);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				DBConnection.releaseConnectionToDB(connection, pstmt, rsIntial);
				DBConnection.releaseConnectionToDB(null, null, rs);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return horizontalMenus;
	}
}