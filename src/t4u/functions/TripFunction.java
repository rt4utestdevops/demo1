package t4u.functions;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import org.json.JSONArray;
import org.json.JSONObject;
import t4u.common.DBConnection;
import t4u.statements.TripStatements;


public class TripFunction {
    
    public String ceateRouteMaster(String routeName,String[] routeArray,int systemId,int customerId,String[] routeArrayReverse1,String routeReverse) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		String message = "";
		int routeId=0;
		int segmentId=0;
		int distance=0;
		float startlat=0;
		float startlong=0;
		float endlat=0;
		float endlong=0;
		int count=0;
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
			while(count<2)
			{
			count++;
			pstmt = con.prepareStatement(TripStatements.GET_MAX_ROUTE_ID);
			rs=pstmt.executeQuery();	
			if(rs.next())
			{
				routeId=rs.getInt(1)+1;
			}
			pstmt=null;
			rs=null;
			if(routeId>0)
			{
				if(count==2)
				{
					routeName = routeReverse;
					routeArray = routeArrayReverse1;
					distance = 0;
				}
				pstmt = con.prepareStatement(TripStatements.SAVE_ROUTE_ID);
				pstmt.setInt(1,routeId);
				pstmt.setString(2,routeName);
				pstmt.setInt(3,systemId);
				pstmt.setInt(4,customerId);
				int insertResult=pstmt.executeUpdate();	
				pstmt=null;
				rs=null;
				pstmt = con.prepareStatement(TripStatements.GET_MAX_SEGMENT_ID);
				rs=pstmt.executeQuery();	
				if(rs.next())
				{
					segmentId=rs.getInt(1)+1;
				}
				pstmt=null;
				rs=null;
				if(insertResult>0 && segmentId>0)
				{
					
					for(String routes:routeArray)
						{
							routes=routes.substring(1,routes.length()-2);
							String[] routesdetails = routes.split(",");	
							if(Integer.parseInt(routesdetails[0])==1||Integer.parseInt(routesdetails[0])==routeArray.length)
							{
								segmentId++;
								if(Integer.parseInt(routesdetails[0])==1)
								{
									startlat=Float.valueOf(routesdetails[1]);
									startlong=Float.valueOf(routesdetails[2]);
								}
								else if(Integer.parseInt(routesdetails[0])==routeArray.length)
								{
									endlat=Float.valueOf(routesdetails[1]);
									endlong=Float.valueOf(routesdetails[2]);
									distance=(int)calculatedistance(startlat, startlong, endlat, endlong);
								}
								pstmt = con.prepareStatement(TripStatements.SAVE_ROUTE_PICK_UP_POINT);
								pstmt.setInt(1,routeId);
								pstmt.setInt(2,segmentId);
								pstmt.setInt(3,1);
								pstmt.setInt(4,distance/1000);
								pstmt.executeUpdate();	
								pstmt=null;
								rs=null;
								
								pstmt = con.prepareStatement(TripStatements.SAVE_ROUTE_DETAIL);
								pstmt.setInt(1,routeId);
								pstmt.setInt(2,segmentId);
								pstmt.setInt(3,1);
								pstmt.setString(4,routesdetails[1]);
								pstmt.setString(5,routesdetails[2]);
								pstmt.executeUpdate();	
								pstmt=null;
								rs=null;
							}
							else
							{	
							pstmt = con.prepareStatement(TripStatements.SAVE_ROUTE_DETAIL);
							pstmt.setInt(1,routeId);
							pstmt.setInt(2,segmentId);
							pstmt.setString(3,routesdetails[0]);
							pstmt.setString(4,routesdetails[1]);
							pstmt.setString(5,routesdetails[2]);
							pstmt.executeUpdate();	
							pstmt=null;
							rs=null;
							}
						}
				}
			}
			}
					message="Route Created";
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return message;
	}



	public JSONArray getRoutenames(int cutomerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(TripStatements.GET_ROUTE_NAMES);
			pstmt.setInt(1,cutomerId);
			pstmt.setInt(2,systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("RouteId", rs.getString("RouteID"));
				jsonObject.put("RouteName", rs.getString("RouteName"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			System.out.println("Error in getCustomer "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}
	
	public JSONArray getRouteDetails(int routeId,int cutomerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(TripStatements.GET_ROUTE_DETAILS);
			pstmt.setInt(1,routeId);
			pstmt.setInt(2,cutomerId);
			pstmt.setInt(3,systemId);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("sequence", rs.getString("Route_sequence"));
				jsonObject.put("lat", rs.getString("Latitude"));
				jsonObject.put("long", rs.getString("Longitude"));
				jsonArray.put(jsonObject);				
			}
		}catch(Exception e){
			e.printStackTrace();
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return jsonArray;
	
	}



	public String updateRouteMaster(int routeId, String[] routeArray,int systemId, int customerID) {

		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs=null;
		String message = "";
		int segmentId=0;
		int distance=0;
		float startlat=0;
		float startlong=0;
		float endlat=0;
		float endlong=0;
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(TripStatements.DELETE_ROUTE_PICKUP);
				pstmt.setInt(1,routeId);
				pstmt.executeUpdate();	
				pstmt=null;
				rs=null;
				pstmt = con.prepareStatement(TripStatements.DELETE_ROUTE_DETAILS);
				pstmt.setInt(1,routeId);
				int insertResult=pstmt.executeUpdate();	
				pstmt=null;
				rs=null;
				pstmt = con.prepareStatement(TripStatements.GET_MAX_SEGMENT_ID);
				rs=pstmt.executeQuery();	
				if(rs.next())
				{
					segmentId=rs.getInt(1)+1;
				}
				pstmt=null;
				rs=null;
				if(insertResult>0 && segmentId>0)
				{
					
					for(String routes:routeArray)
						{
							routes=routes.substring(1,routes.length()-2);
							String[] routesdetails = routes.split(",");	
							if(Integer.parseInt(routesdetails[0])==1||Integer.parseInt(routesdetails[0])==routeArray.length)
							{
								segmentId++;
								if(Integer.parseInt(routesdetails[0])==1)
								{
									startlat=Float.valueOf(routesdetails[1]);
									startlong=Float.valueOf(routesdetails[2]);
								}
								else if(Integer.parseInt(routesdetails[0])==routeArray.length)
								{
									endlat=Float.valueOf(routesdetails[1]);
									endlong=Float.valueOf(routesdetails[2]);
									distance=(int)calculatedistance(startlat, startlong, endlat, endlong);
								}
								pstmt = con.prepareStatement(TripStatements.SAVE_ROUTE_PICK_UP_POINT);
								pstmt.setInt(1,routeId);
								pstmt.setInt(2,segmentId);
								pstmt.setInt(3,1);
								pstmt.setInt(4,distance/1000);
								pstmt.executeUpdate();	
								pstmt=null;
								rs=null;
								
								pstmt = con.prepareStatement(TripStatements.SAVE_ROUTE_DETAIL);
								pstmt.setInt(1,routeId);
								pstmt.setInt(2,segmentId);
								pstmt.setInt(3,1);
								pstmt.setString(4,routesdetails[1]);
								pstmt.setString(5,routesdetails[2]);
								pstmt.executeUpdate();	
								pstmt=null;
								rs=null;
							}
							else
							{	
							pstmt = con.prepareStatement(TripStatements.SAVE_ROUTE_DETAIL);
							pstmt.setInt(1,routeId);
							pstmt.setInt(2,segmentId);
							pstmt.setString(3,routesdetails[0]);
							pstmt.setString(4,routesdetails[1]);
							pstmt.setString(5,routesdetails[2]);
							pstmt.executeUpdate();	
							pstmt=null;
							rs=null;
							}
						}
					message="Route Modified";
				}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return message;
	
	}
	
	public static float calculatedistance(float lat1, float lng1, float lat2, float lng2) {
	    double earthRadius = 3958.75;
	    double dLat = Math.toRadians(lat2-lat1);
	    double dLng = Math.toRadians(lng2-lng1);
	    double a = Math.sin(dLat/2) * Math.sin(dLat/2) +
	               Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2)) *
	               Math.sin(dLng/2) * Math.sin(dLng/2);
	    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
	    double dist = earthRadius * c;

	    int meterConversion = 1609;

	    return (float) (dist * meterConversion);
	    }



	public String deleteRoute(int routeId, int systemId, int customerID) {
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs=null;
		String message = "";
		try
		{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripStatements.DELETE_ROUTE_MASTER);
			pstmt.setInt(1,routeId);
			pstmt.setInt(2,customerID);
			pstmt.setInt(3,systemId);
			if(pstmt.executeUpdate()>0)	
			{
				message="Route Deleted";
				pstmt=null;
				rs=null;
				pstmt = con.prepareStatement(TripStatements.DELETE_ROUTE_PICKUP);
				pstmt.setInt(1,routeId);
				if(pstmt.executeUpdate()>0)	
				{
					pstmt=null;
					rs=null;
					pstmt = con.prepareStatement(TripStatements.DELETE_ROUTE_DETAILS);
					pstmt.setInt(1,routeId);
					pstmt.executeUpdate();
					pstmt=null;
					rs=null;
					
				}
				
				pstmt1 = con.prepareStatement(TripStatements.DELETE_ROUTES_ASSOCIATED_VEHICLES);
				pstmt1.setInt(1, routeId);
				pstmt1.executeUpdate();
		}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
		}	
		return message;
	}
	
	public JSONArray getClientNames(int systemId,int clientId) 
	{
		JSONArray jlist = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			con = DBConnection.getConnectionToDB("AMS");
			if(clientId>0)
			{
				pstmt = con.prepareStatement(TripStatements.GET_CLIENT);
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);				
			}else
			{				
			pstmt = con.prepareStatement(TripStatements.GET_CLIENTS);
			pstmt.setInt(1, systemId);
			}
			
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				JSONObject obj = new JSONObject();
				obj.put("clientId", rs.getString("CustomerId"));
				obj.put("clientName", rs.getString("CustomerName"));
				jlist.put(obj);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jlist;
	}
	
	public JSONArray getHub(int systemId,int customerId)
	{
		JSONArray jlist = new JSONArray();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try 
		{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripStatements.GET_HUBS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
						
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				JSONObject obj = new JSONObject();
				obj.put("hubid", rs.getString("HUBID"));
				obj.put("hubname", rs.getString("NAME"));
				jlist.put(obj);
			}
		} 
		catch (Exception e) 
		{
			e.printStackTrace();
		} 
		finally 
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jlist;
	}
	
	public String insertTrip(String routeCodeID,int hubid,String buttonValue,int customerId,int systemid,int createdBy)
	{	
		Connection con =null;
		String msg="";
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		try{
			con= DBConnection.getConnectionToDB("AMS");
				if(buttonValue.equals("add")){
					pstmt = con.prepareStatement(TripStatements.CHECK_DUPLICATE);
					pstmt.setInt(1,systemid );
					pstmt.setInt(2,customerId );
					pstmt.setString(3,routeCodeID );
					rs = pstmt.executeQuery();
					if(rs.next()) {
						  msg="Customer Location Name " + routeCodeID + " already exists ";
					}
					else
					{	
						pstmt = con.prepareStatement(TripStatements.INSERT_TRIP);
						pstmt.setString(1,routeCodeID);
						pstmt.setInt(2,hubid);
						pstmt.setInt(3,customerId);
						pstmt.setInt(4,systemid);
						pstmt.setInt(5, createdBy);
						int count=pstmt.executeUpdate();
						if(count>0)
						{
							msg="Saved Successfully";
						}
						else
						{
							msg = "Unable to Save";
						}
					}
			      }	
			
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
		
	}
	
	public String updauteTrip(String routeCodeID, int hubid,String buttonValue, int customerId, int systemId, int clientLoggedIn) 
	{
		Connection con =null;
		String msg="";
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		try{
			con= DBConnection.getConnectionToDB("AMS");
			 if(buttonValue.equals("modify")) 
			 {
    	  		pstmt = con.prepareStatement(TripStatements.UPDATE_TRIP);
    	  		pstmt.setInt(1,hubid);
    	  		pstmt.setInt(2,systemId);
    	  		pstmt.setInt(3,customerId);
    	  		pstmt.setString(4,routeCodeID);
	
    	  		int count=pstmt.executeUpdate();
    	  		if(count>0)
    	  		{
    	  			msg="Modified Successfully";
    	  		}
    	  		else
    	  		{
    	  			msg="Unable to Modify";
    	  		}
			 }
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
		
	}
	
	public  JSONArray getcustomerRouteDetails(int systemid,int customerId,int offset) 
	{
		JSONArray jlist = new JSONArray();
		Connection con =null;	
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		Date date;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripStatements.GET_CUST_ROUTE_DETAILS );
			pstmt.setInt(1, offset);
			pstmt.setInt(2, systemid);
			pstmt.setInt(3, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				JSONObject obj = new JSONObject();
				obj.put("customerLocationName", rs.getString("CUSTOMER_LOCATION_NAME"));
				obj.put("hubid", rs.getString("HubName"));
				obj.put("created By", rs.getString("CREATED_BY"));
				date = rs.getTimestamp("CREATED_TIME");
				obj.put("created Time", sdfyyyymmddhhmmss.format(date));
				
				jlist.put(obj);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jlist;
		
	}
	
	public JSONArray getCustomerRouteList(int systemId,int customerId){
		JSONArray rlist = new JSONArray();
		Connection con =null;	
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripStatements.GET_CUSTOMER_ROUTE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				JSONObject obj = new JSONObject();
				obj.put("RouteName", rs.getString("RouteName"));
				obj.put("RouteId", rs.getInt("RouteID"));
				rlist.put(obj);
			}

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Problem in Getting Route List");
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return rlist;
	}
	
	public JSONArray getGroupNameList(int systemId,int customerId,int userId){
		JSONArray glist = new JSONArray();
		Connection con =null;	
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripStatements.GET_GROUP_NAME);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, userId);
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				JSONObject obj = new JSONObject();
				obj.put("GroupName", rs.getString("GROUP_NAME"));
				obj.put("GroupId", rs.getInt("GROUP_ID"));
				glist.put(obj);
			}

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Problem in Getting Group List");
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return glist;
	}
	
	public JSONArray getVehicleList(int systemId,int customerId,int userId,int groupId,int routeId,String vehicleNo){
		JSONArray vlist = new JSONArray();
		Connection con =null;	
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		try {
			if(!vehicleNo.equals("") && vehicleNo!=null){
				JSONObject obj1 = new JSONObject();
				obj1.put("vehicleNo", vehicleNo);
				vlist.put(obj1);	
			}
			
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripStatements.GET_VEHICLE_ACCORDING_TO_GROUP_NAME);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, groupId);
			pstmt.setInt(4, userId);
			pstmt.setInt(5, routeId);
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				JSONObject obj = new JSONObject();
				obj.put("vehicleNo", rs.getString("REGISTRATION_NUMBER"));
				vlist.put(obj);
			}

		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Problem in Getting Vehicle List");
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return vlist;
	}
	
	public ArrayList < Object > getRouteVehicleAssociationReport(int systemId, int customerId,int userId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripStatements.GET_ROUTE_VEHICLE_ASSOCIATION_REPORT);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, systemId);
	        pstmt.setInt(3, systemId);
	        pstmt.setInt(4, userId);
	        pstmt.setInt(5, systemId);
	        pstmt.setInt(6, customerId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	            JsonObject.put("slnoIndex", count);
	            JsonObject.put("routeIdDataIndex", rs.getString("ROUTE_ID"));
	            JsonObject.put("routeDataIndex", rs.getString("ROUTE_NAME"));
	            JsonObject.put("vehicleNoDataIndex", rs.getString("REGISTRATION_NO"));
	            JsonObject.put("vehicleGroupIdDataIndex", rs.getString("GROUP_ID"));
	            JsonObject.put("vehicleGroupDataIndex", rs.getString("GROUP_NAME"));
	            JsonObject.put("createdByDataIndex", rs.getString("CREATED_BY"));
	            JsonObject.put("updatedByDataIndex", rs.getString("UPDATED_BY"));
	            JsonObject.put("createdDateDataIndex", (rs.getString("CREATED_TIME").contains("1900"))? "":rs.getString("CREATED_TIME"));
	            JsonObject.put("updatedDateDataIndex", (rs.getString("UPDATED_TIME").contains("1900"))?"":rs.getString("UPDATED_TIME"));
	            JsonArray.put(JsonObject);
	        }
	        finlist.add(JsonArray);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return finlist;
	}
	
	public String saveRouteVehicleAssociation(int userId,String regNo,int routeId) {
	Connection con = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt1 = null;
    ResultSet rs = null;
    String message = "";
    int inserted = 0;
    String []vehicleList = regNo.split(",");
    
    try {
        con = DBConnection.getConnectionToDB("AMS");
        for(String regno:vehicleList){
        pstmt = con.prepareStatement(TripStatements.CHECK_EXISTING_ROUTE_VEHICLE_ASSOCIATION);
    	pstmt.setString(1,regno.replace("\'","").trim());
        pstmt.setInt(2, routeId);
        rs=pstmt.executeQuery();
        if(rs.next()){
        	if(rs.getInt("Count")==0){
        		pstmt1 = con.prepareStatement(TripStatements.INSERT_ROUTE_VEHICLE_ASSOCIATION);
        		pstmt1.setString(1,regno.replace("\'","").trim());
                pstmt1.setInt(2, routeId);
                pstmt1.setInt(3,userId);
                inserted = pstmt1.executeUpdate();
                }
                if (inserted > 0) {
                    message = "Saved Successfully";
                }
        	}
        }
        if(message.equals("")){
        	message = "Vehicle Already Associated with Exiting Route";
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        DBConnection.releaseConnectionToDB(con, pstmt, rs);
        DBConnection.releaseConnectionToDB(null, pstmt1, null);
    }
    return message;
	}
	
	public String modifyRouteVehicleAssociation(int userId,String regNo,int routeId,String updatedRegNo) {
		 Connection con = null;
		 PreparedStatement pstmt = null;
		 String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(TripStatements.UPDATE_ROUTE_VEHICLE_ASSOCIATION);
    		pstmt.setString(1, regNo);
    		pstmt.setInt(2, userId);
    		pstmt.setInt(3, routeId);
    		pstmt.setString(4, updatedRegNo);
    		int updated = pstmt.executeUpdate();
    		if(updated>0){
    			message="Updated Successfully";
    		}else{
    			message="Updation Fails";
    		}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt,null);
		}
		return message;
	}
	
	public String deleteRouteVehicleAssociation(int routeId,String vehicleNo) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	     
	        pstmt = con.prepareStatement(TripStatements.DELETE_ROUTE_VEHICLE_ASSOCIATION);
	        pstmt.setString(1, vehicleNo);
	        pstmt.setInt(2, routeId);
	        int inserted = pstmt.executeUpdate();
	        if (inserted > 0) {
	        	message = "Deleted Successfully";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, null);
	    }
	    return message;
	}
	
	public String checkRoutesAssociatedWithVehicle(int routeId)
	{	
		Connection con =null;
		String msg="";
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		try{
			con= DBConnection.getConnectionToDB("AMS");
					pstmt = con.prepareStatement(TripStatements.CHECK_ROUTES_ASSOCIATED_VEHICLE);
					pstmt.setInt(1,routeId);
					rs = pstmt.executeQuery();
					if(rs.next()) {
						  msg="All Vehicle route associations will get deleted along with the Route.Are you sure you want to delete?";
					}
					else
					{	
						//msg = "This " + routeId + "is not associated with any vehicles.";
						msg = "Are you sure want to delete?";
					}
		}catch(Exception e) {
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
		
	}
	
}