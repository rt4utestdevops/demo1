package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;


import org.json.JSONArray;
import org.json.JSONObject;

import t4u.common.DBConnection;
import t4u.statements.LTSPStatements;

public class LTSPFunctions {
	String language;
	String getLanuage="LANG_ENGLISH";
	public HashMap<String,String> getLTSPVerticals(int systemId,String language)
	{
		StringBuilder verticalComponents=new StringBuilder();
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		int verticalStyle=0;
		String defaultVertical="";
		String firstVertical =  null;
		HashMap<String,String> verticalCompMap = new HashMap<String,String>();
		String detailsButton="/ApplicationImages/ApplicationButtonIcons/icon_minus.png";
		try
		{
			if(language.equals("ar"))
			{
				getLanuage="LANG_ARABIC";
			}
			connection = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = connection.prepareStatement(LTSPStatements.GET_LTSP_VERTICALS);	
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(count>0)
				{
					defaultVertical="style='display:none;'";
					detailsButton="/ApplicationImages/ApplicationButtonIcons/icon_plus.png";
				}
				count++;
				verticalStyle++;
				verticalComponents.append("<div class='vertical-box"+verticalStyle+"' id='"+rs.getString(getLanuage)+"-box' onclick=getVerticalDetails("+rs.getInt("VERTICAL_ID")+",'"+rs.getString(getLanuage).replaceAll("\\W", "")+"',"+rs.getInt("VERTICAL_ID")+");>");
				verticalComponents.append("<table class='vertical-header"+verticalStyle+"' id='vertical-header'><tr><td width='20%'><div class='vertical-image'><img src='"+rs.getString("IMAGE_PATH")+"'  height='80' padding='1%'></div></td><td width='70%'><div class='vertical-name'>"+rs.getString(getLanuage)+"</div></td><td width='10%'> <div class='detailstab' id='detailstab"+count+"'><img id='verticalimg"+rs.getInt("VERTICAL_ID")+"' src='"+detailsButton+"'</img></div></td></tr></table>");
				verticalComponents.append("<div id='vertical"+rs.getInt("VERTICAL_ID")+"-desc' "+defaultVertical+">");
				verticalComponents.append(rs.getString("DESCRIPTION"));
				verticalComponents.append("<span class='vertical_details' onclick=showDetails("+rs.getInt("VERTICAL_ID")+",'"+rs.getString(getLanuage).replaceAll("\\W", "")+"',"+count+");>Read more..</span></div></div>");
				if(count==1)
				{
					firstVertical = rs.getString("VERTICAL_ID");
					verticalComponents.append("<script>getVerticalDetails("+rs.getString("VERTICAL_ID")+",'"+rs.getString(getLanuage)+"',"+firstVertical+")</script>");
				}
				if(count%4==0)
				{
					verticalStyle=0;
				}
				verticalCompMap.put("processId",firstVertical);
				verticalCompMap.put("verticalComponents",verticalComponents.toString());
			}
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}
		finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return (HashMap<String,String>) verticalCompMap;
	}
	
	public String getLTSPNewVerticals(int systemId,String language)
	{
		StringBuilder verticalComponents=new StringBuilder();
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count=0;
		int verticalStyle=0;
		try
		{
			if(language.equals("ar"))
			{
				getLanuage="LANG_ARABIC";
			}
			connection = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = connection.prepareStatement(LTSPStatements.GET_LTSP_NEW_VERTICALS);	
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				count++;
				verticalStyle++;
				verticalComponents.append("<div class='newvertical-box' id='"+rs.getString(getLanuage)+"-box' onclick=getVerticalDetails("+rs.getInt("VERTICAL_ID")+",'"+rs.getString(getLanuage).replaceAll("\\W", "")+"',"+count+");>");
				verticalComponents.append("<div class='vertical-header"+verticalStyle+"' id='vertical-header'><div class='vertical-image'><img src='"+rs.getString("IMAGE_PATH")+"'  height='80' padding='1%'></div><div class='vertical-name'>"+rs.getString(getLanuage)+" </div></div>");
				verticalComponents.append("<div id='vertical"+count+"-desc'>");
				verticalComponents.append(rs.getString("DESCRIPTION"));
				verticalComponents.append("<span class='vertical_details' onclick=showDetails("+rs.getInt("VERTICAL_ID")+",'"+rs.getString(getLanuage).replaceAll("\\W", "")+"',"+count+");>Read more..</span></div></div>");
				if(count%4==0)
				{
					verticalStyle=0;
				}
			}
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return verticalComponents.toString();
	}

	public JSONArray getClientList(String processID, int systemId, int nonCommHrs) {


		JSONArray ClientDetailsArray = new JSONArray();
		JSONObject ClientDetailsObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			ClientDetailsArray = new JSONArray();
			con = DBConnection.getDashboardConnection("ADMINISTRATOR");
			pstmt = con.prepareStatement(LTSPStatements.GET_CLIENT_LIST,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, nonCommHrs);
			pstmt.setInt(2, nonCommHrs);
			pstmt.setString(3, processID);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				ClientDetailsObject = new JSONObject();
				ClientDetailsObject.put("customerid",rs.getString("CUSTOMER_ID"));
				ClientDetailsObject.put("customername",rs.getString("CUSTOMER_NAME"));
				ClientDetailsObject.put("totalno",rs.getString("TOTAL_VEHICLES"));
				ClientDetailsObject.put("comm",rs.getString("COMM"));
				ClientDetailsObject.put("noncomm",rs.getString("NONCOMM"));
				ClientDetailsArray.put(ClientDetailsObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return ClientDetailsArray;
	}
	
	
	
	public String getAdministratorMenu(int systemId,int userid,String language)
	{
		StringBuilder adminMenuList=new StringBuilder();
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int list=115;
		String path="";
		int count=0;
		this.language=language;
		try
		{
			if(language.equals("ar"))
			{
				getLanuage="LANG_ARABIC";
			}
			connection = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = connection.prepareStatement(LTSPStatements.GET_ADMINISTRATOR_MENU);	
			pstmt.setInt(1, systemId);		
			pstmt.setInt(2, systemId);
			pstmt.setInt(3, userid);
			rs = pstmt.executeQuery();
			while(rs.next()){
				count++;
				if (rs.getString("ELEMENT_NAME").substring(0, 5).equals("/Jsps")) {
					path = "/Telematics4uApp"+rs.getString("ELEMENT_NAME");
				}
				else
				{	
					path=rs.getString("ELEMENT_NAME");
				}
				adminMenuList.append("<li class = 'admin_sub_menu'  id='adminSubMenu' onclick=\"getJSPPage('"+path+"', '#list"+list+"')\"><a id = 'list"+list+"' class='gn-icon gn-icon-videos'>"+rs.getString(getLanuage)+"</a></li>");
				list++;
			}
			if(count == 0){
				pstmt = connection.prepareStatement(LTSPStatements.GET_ADMINISTRATOR_MENU_WITHOUT_ASSOC);	
				pstmt.setInt(1, systemId);				
				rs = pstmt.executeQuery();
				while(rs.next()){
					count++;
					if (rs.getString("ELEMENT_NAME").substring(0, 5).equals("/Jsps")) {
						path = "/Telematics4uApp"+rs.getString("ELEMENT_NAME");
					}
					else
					{	
						path=rs.getString("ELEMENT_NAME");
					}
					adminMenuList.append("<li class = 'admin_sub_menu'  id='adminSubMenu' onclick=\"getJSPPage('"+path+"', '#list"+list+"')\"><a id = 'list"+list+"' class='gn-icon gn-icon-videos'>"+rs.getString(getLanuage)+"</a></li>");
					list++;
				}
				
			}
		}
		catch(Exception e)
		{
		e.printStackTrace();	
		}finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		return adminMenuList.toString();
	}
	public HashMap<String,String> getReadMoreInfo(int processID){
		Connection connection = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String description="";		
		Map<String, String> map = new HashMap<String, String>();
		try {
			connection = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = connection.prepareStatement(LTSPStatements.GET_READ_MORE_INFO);
			pstmt.setInt(1, processID);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				description = rs.getString("CONTENTS");	
			}
			
			String[] contentarea=description.split("@");	
				for(int i=0;i<=contentarea.length-1;i++){
					map.put("wrapper",contentarea[0]);
					map.put("firstBanner",contentarea[1]);
					map.put("secondBanner",contentarea[2]);
					map.put("thirdBanner",contentarea[3]);
					map.put("fourthBanner",contentarea[4]);
					map.put("contents",contentarea[5]);
					}
				
		} 
		catch (Exception e) {
			e.printStackTrace();
		} 
		finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, rs);
		}
		
		return (HashMap<String, String>) map;
		
	}
	public JSONArray getLstpDashboardCount( int systemId,int userId, int nonCommHrs) {
		JSONArray ltspDetailsArray = new JSONArray();
		JSONObject ltspDetailsObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int totalCount=0;
		int communicating=0;
		int nonCommunicating=0;
		int noGps=0;
		try {
			ltspDetailsArray = new JSONArray();
			con = DBConnection.getDashboardConnection("AMS");
			pstmt = con.prepareStatement(LTSPStatements.GET_COMMU_NONCOMMU_COUNT_FOR_LTSP);
			pstmt.setInt(1, nonCommHrs);
			pstmt.setInt(2, nonCommHrs);
			pstmt.setInt(3, systemId);	
			pstmt.setInt(4, userId);	
			rs = pstmt.executeQuery();
			if (rs.next()) {
				totalCount=rs.getInt("TOTAL_VEHICLES");
				communicating=rs.getInt("COMM");
				nonCommunicating=rs.getInt("NONCOMM");
				noGps=rs.getInt("NOGPS");
			}			
			
			
			ltspDetailsObject = new JSONObject();
			ltspDetailsObject.put("totalAssetCount",totalCount);
			ltspDetailsObject.put("commCount",communicating);
			ltspDetailsObject.put("nonCommCount",nonCommunicating);
			ltspDetailsObject.put("noGpsCount",noGps);				
			ltspDetailsArray.put(ltspDetailsObject);
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return ltspDetailsArray;
	}
	public JSONArray getCustomerNames(int systemId) {

		JSONArray customerNameArray = new JSONArray();
		JSONObject customerNameObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			customerNameArray = new JSONArray();
			con = DBConnection.getDashboardConnection("ADMINISTRATOR");
			pstmt = con.prepareStatement(LTSPStatements.GET_CUSTOMER_NAMES,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				customerNameObject = new JSONObject();
				customerNameObject.put("customername",rs.getString("CUSTOMER_NAME"));
				customerNameArray.put(customerNameObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return customerNameArray;
	}
	public JSONArray getCustStoreBasedOnCustName(String custName,int systemId, int nonCommHrs) {

		JSONArray custNameArray = new JSONArray();
		JSONObject custNameObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			custNameArray = new JSONArray();
			con = DBConnection.getDashboardConnection("ADMINISTRATOR");
			pstmt = con.prepareStatement(LTSPStatements.GET_CUSTOMER_BASED_ON_NAME,ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
			pstmt.setInt(1, nonCommHrs);
			pstmt.setInt(2, nonCommHrs);
			pstmt.setString(3, custName);
			pstmt.setInt(4, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				custNameObject = new JSONObject();				
				custNameObject.put("customerid",rs.getString("CUSTOMER_ID"));
				custNameObject.put("customername",rs.getString("CUSTOMER_NAME"));
				custNameObject.put("totalno",rs.getString("TOTAL_VEHICLES"));
				custNameObject.put("comm",rs.getString("COMM"));
				custNameObject.put("noncomm",rs.getString("NONCOMM"));
				custNameObject.put("processId", rs.getString("PROCESS_ID"));
				custNameArray.put(custNameObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return custNameArray;
	}
}
