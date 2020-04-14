package t4u.functions;

import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.FileUtils;
import org.eclipse.jdt.internal.jarinjarloader.JarRsrcLoader;
import org.json.JSONArray;
import org.json.JSONObject;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.LoadAndTripPlannerStatements;
import tool.LoadAndRoutePlanner;

public class LoadAndTripPlannerFunctions {
	DecimalFormat df = new DecimalFormat("0.00");
	SimpleDateFormat hour = new SimpleDateFormat("HH");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdfDB1 = new SimpleDateFormat("yyyy-MM-dd");
	SimpleDateFormat date = new SimpleDateFormat("dd/MM/yyyy");
	//final static String PROPERTIES_PATH="C://cluster//shareddir//application.properties";
	
	public JSONArray readExcelData(int systemId,int customerId, int userId){
		JSONArray jsonArray=null;
		JSONObject jsonobject = new JSONObject();
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		Connection con =null;
		try {
			LoadOptimization load = new LoadOptimization();
			String uniqueId=load.ImportExcelDatatoDb(systemId, customerId, userId);
			jsonArray= new JSONArray();
			if(!(uniqueId.equalsIgnoreCase("failure"))){
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(LoadAndTripPlannerStatements.GET_ORDER_DETAILS_INSERTED);
				pstmt.setString(1, uniqueId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, customerId);
				rs = pstmt.executeQuery();
				int slno=0;
				while(rs.next()){
					jsonobject = new JSONObject();
					String orderDate=date.format(sdfDB.parse(rs.getString("ORDER_DATE")));
					String deleveryDate=date.format(sdfDB.parse(rs.getString("DELIVERY_DATE")));
					String deleveryTime=rs.getString("DELIVERY_TIME");
					jsonobject.put("slno",++slno);
					jsonobject.put("priority", rs.getInt("PRIORITY"));
					jsonobject.put("customerNo", rs.getString("CUSTOMER_NO"));
					jsonobject.put("customerName", rs.getString("CUSTOMER_NAME"));
					jsonobject.put("deliveryDate", deleveryDate);
					if(deleveryTime.trim().equalsIgnoreCase("")){
						jsonobject.put("deliveryTime", "18:00");
					}else{
						jsonobject.put("deliveryTime", rs.getString("DELIVERY_TIME"));
					}
					jsonobject.put("orderNumber", rs.getString("ORDER_NO"));
					jsonobject.put("orderDate", orderDate);
					jsonobject.put("orderValue", rs.getString("ORDER_VALUE"));
					jsonobject.put("totalWeight", rs.getString("TOTAL_WEIGHT"));
					jsonobject.put("uniqueCode", uniqueId);
					jsonArray.put(jsonobject);
				}			
				
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return jsonArray;
	}
	
	// changed on 5:15 PM 12/26/2017
	public  String optimizedRouteandLoad(String uniqueId,int userId,int systemId,int customerId)
	{
		PreparedStatement pstmt = null;
		PreparedStatement pstmt2=null;
		Connection con=null;
		String message = "";
		
		try {
			/// delete the 
			Properties properties = ApplicationListener.prop;
			String createXmlPath=properties.getProperty("createXmlPath").trim();
			//String batFileName=properties.getProperty("batFileName");
		//	String batfileFolder=properties.getProperty("batfileFolder");
			LoadOptimization load=new LoadOptimization();
			boolean created=load.xmlsCreate(uniqueId, systemId, customerId, createXmlPath+"\\config");
			con=DBConnection.getConnectionToDB("AMS");
			if(created){
				/*
				 * GENERATING OUTPUT CALLING batch file which calls OPTIMIZATION ENGINE 
				 * 
				 */			
				
				//load.runProcess(batFileName, batfileFolder);
				LoadAndRoutePlanner objLoadAndRoute = new LoadAndRoutePlanner();
				System.out.println(createXmlPath);
				if(objLoadAndRoute.Execute(createXmlPath)) {
				// Successfully created plan
					System.out.println("Successfully created plan");
				} else {
				// Unable to create plan
					System.out.println("Unable to create plan");
				}
			}else{
				System.out.println("failed to generate xml");
				message="failed to Optimise ";
			}
			
			//DocumentBuilderFactory docBuild =new org.apache.xerces.jaxp.DocumentBuilderFactoryImpl();
			DocumentBuilderFactory docBuild = DocumentBuilderFactory.newInstance();
			DocumentBuilder docBuilder = docBuild.newDocumentBuilder();
			//new org.apache.xerces.jaxp.DocumentBuilderFactoryImpl()
			FileInputStream fis = new FileInputStream(createXmlPath+"/logs/visits.xml");
			InputSource is = new InputSource(fis);
			Document doc = docBuilder.parse(is);
			
			// get the first element
			Element element = doc.getDocumentElement();

			//String textVal=null;
			// get all child nodes
			NodeList nodes = element.getElementsByTagName("visit");

			// NodeList nodes2=element.getElementsByTagName("visit");

			// print the text content of each child						
			for (int i = 0; i < nodes.getLength(); i++) {
				String value[]= nodes.item(i).getTextContent().split("\n");
		
				String reg_num=value[1];
				String vehicle_type=value[2].substring(2).replaceAll("\\s", "->");
				String capacity=value[3].substring(2).replaceAll("\\s", ",");//capacity
				//String destno=value[2].substring(2).replaceAll("\\s", ",");
				String loadingLevel=value[4].substring(2).replaceAll("\\s", ","); // loading_level 
				String leaseRecommended=value[8].substring(2).replaceAll("\\s", ",");
				String loadingEfficiency=value[5].substring(2).replaceAll("\\s",","); 
				String visitDistance=value[6].substring(2).replaceAll("\\s",",");
				String visitDuration=value[7].substring(2).replaceAll("\\s",",");
				String vehicle_Route=value[9].substring(2).replaceAll("\\s", "->"); // order of check points
				String dst_eta=value[10].substring(2).replaceAll("\\s", "->"); 
				String max_eta=value[11].substring(2).replaceAll("\\s", "->");
				
				String orders = value[12].substring(2).replaceAll("\\s", "@");
				
				String destination_Array[]=vehicle_Route.split("->");
				String destetaarray[]=dst_eta.split("->");
				String maxetaarray[]= max_eta.split("->"); //
				
				String orderArray[]=orders.split("@");
			
				System.out.println(vehicle_type);
				System.out.println(leaseRecommended);
				Map<String, String> map1 = new HashMap<String, String>();
				for (int j = 0; j < destination_Array.length; j++) {
					if(!destination_Array[j].equalsIgnoreCase("s1"))
					{
						map1.put(destetaarray[j]+"#"+maxetaarray[j]+"#"+orderArray[j],destination_Array[j]);
					}
				}
				
				System.out.println(map1);				
				
				//System.out.println(value[1]+" "+vehicle_Route+" "+vehicle_Route.contains("d"));
				reg_num=""+reg_num.trim();
				if(vehicle_Route.contains("d")){
					pstmt= con.prepareStatement(LoadAndTripPlannerStatements.INSERT_OPTIMIZED_VEHICLE_ROUTE);
					pstmt.setString(1,reg_num);
					pstmt.setString(2,capacity);
					pstmt.setString(3,uniqueId);
					pstmt.setInt(4,userId);
					pstmt.setString(5, vehicle_Route);
					pstmt.setString(6, leaseRecommended);
					pstmt.setString(7, vehicle_type);
					pstmt.setString(8, loadingLevel);
					pstmt.setString(9, loadingEfficiency);
					pstmt.setString(10, visitDistance);
					pstmt.setString(11, visitDuration);
					pstmt.setString(12, orders);
					
					
					int x=pstmt.executeUpdate();
					if(x>0)
					{	
					//	System.out.println("Success................");
						message="Success";
						
						Iterator ii=(Iterator)map1.entrySet().iterator();
						
						while(ii.hasNext())
						{
							pstmt2=con.prepareStatement(LoadAndTripPlannerStatements.UPDATE_ETA_FOR_ORDER_DETAILS_TABLE);
							Map.Entry<String,String> entry=(Map.Entry<String,String>)ii.next();
							String eta=(String)entry.getKey();
							String desti=(String)entry.getValue();
							String s[]=eta.split("#");
							
							pstmt2.setString(1, s[0]); //des eta
							pstmt2.setString(2, s[1]); //max eta
							pstmt2.setString(3, s[2]); //orders 
							pstmt2.setString(4, uniqueId);
							pstmt2.setString(5, desti);
							
							int y=pstmt2.executeUpdate();
							if(y>0)
							{
								//System.out.println("Success.........!");
							}							
						}						
						//System.out.println("Success................");
					}
				}
		//	}
			
			//Delete the excel file 
			String fileUploadPath=properties.getProperty("fileUploadPath");
			String xmlfiles=properties.getProperty("createXmlPath");
	        File file = new File(fileUploadPath+"//LoadPlanner.xlsx");
	        File xmlFiles = new File(xmlfiles+"//config");
	        File outputFile = new File(xmlfiles+"//logs//visits.xml");
	        
	            if(file.delete()){
	           System.out.println(fileUploadPath+"//LoadPlanner.xlsx - deleted ");
	        }
	        if(outputFile.delete()){
	        	System.out.println(xmlfiles+"//logs//visits.xml - deleted ");
	        }
	     
	        try {
	        	
	        	/*String[] myFiles;  
	        	if(xmlFiles.isDirectory()){
	        		myFiles = xmlFiles.list();
	        		for (int i1=0; i1<myFiles.length; i1++) {
	        			File myFile = new File(xmlFiles, myFiles[i1]); 
	        			if(myFile.delete()){
	        	        	System.out.println(myFile+" file delete  ");
	        	        }
	        		}
	        	} */
	        } catch (Exception e) {
	        	e.printStackTrace();
	        }
		}
	} catch (Exception e) {
			e.printStackTrace();
			message="failed to Optimise ";
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
	
	public JSONArray getTripDetails(int systemId, int clientId, int offset,	int userId, String uniqueId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		int count = 0;
		String vehicleNo = "";
		String capacity = "0";
		String UID = "0";
		String sequence []={};
		String orders ="";
		String dest = "";
		String orderdest="";
		int order = 0;
		double filled = 0;
		int tripId = 0;
		String status = "";
		String leaseRecommended="";
		String vehicleType="";
		double weight = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(LoadAndTripPlannerStatements.GET_OPTIMIZED_TRIP_DETAILS);
			pstmt.setString(1, uniqueId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				order = 0;
				filled = 0;
				dest = "";
				status = "";
				weight = 0;
				
				vehicleNo = rs.getString("vehicleNo");
			
				capacity = df.format(rs.getDouble("capacity"));
				UID = rs.getString("UID");
				tripId = rs.getInt("tripId");
				sequence = rs.getString("seq").split("->");
				status = rs.getString("status");
				leaseRecommended=rs.getString("LEASE_RECOMMENDED");
				vehicleType=rs.getString("VEHICLE_TYPE");
				orders = rs.getString("ORDER_DETAILS").replaceAll("@", ",");
				for(int i = 1; i < sequence.length-1; i++){
					dest = dest+","+"'"+sequence[i]+"'";
				}
				/*for(int i = 1; i < orders.length-1; i++){
					orderdest = orderdest+","+"'"+orders[i]+"'";
				}*/
				
				System.out.println("output >>"+ orders.substring(4,orders.length()-4));
				
				pstmt1 = con.prepareStatement(LoadAndTripPlannerStatements.GET_ORDER_DETAILS+" and ORDER_NO in ("+orders.substring(4,orders.length()-4)+")");
				pstmt1.setString(1, rs.getString("UID"));
				rs1 = pstmt1.executeQuery();
				if(rs1.next()){
					order = rs1.getInt("orders");
					filled = Double.parseDouble(df.format(rs1.getDouble("filled")));
					weight = Double.parseDouble(df.format(rs1.getDouble("weight")));
				}
				obj = new JSONObject();
				count++;
				obj.put("slNo", count);
				if(vehicleType.equalsIgnoreCase("LEASE"))
				{
					obj.put("vehicleNo", "<p style='color:red'>"+vehicleNo+"</p>");
				}
				else
				{
					obj.put("vehicleNo", vehicleNo);
				}
				obj.put("orders", "<a href = '#'>"+order+"</a>");
				double tonCap=(Double.parseDouble(capacity)/1000);
				obj.put("capacity", tonCap);
				obj.put("filledCapacity", filled);
				obj.put("viewMap", "<a href= '#'>Click here</a>");
				if(status.equals("OPEN")){
					obj.put("createTrip", "<a class='btn btn-info btn-xs' role='button' disabled style='background: green; border-color: green'>Trip Created</a>");
				}else{
					obj.put("createTrip", "<a class='btn btn-info btn-xs' role='button' >Create Trip</a>");
				}	
				obj.put("uniqueId", UID);
				obj.put("tripId", tripId);
				obj.put("status", status);
				obj.put("weight", weight);
				if(leaseRecommended.equalsIgnoreCase("None"))
				{
					obj.put("leaseRecommended","<p style='color:red'>NA</p>");
				}
				else
				{
					obj.put("leaseRecommended","<p style='color:green'>"+leaseRecommended+"</p>");
				}
				jsonArray.put(obj);
			} 
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public JSONArray getRouteDetails(int systemId, int clientId, String uniqueId, String tripId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String sequence [] = {};
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(LoadAndTripPlannerStatements.GET_ALL_DESTINATIONS_FOR_MAP);
			pstmt.setString(1,uniqueId);
			pstmt.setString(2, tripId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				sequence = rs.getString("sequence").split("->");
			}
			for(int i = 0; i < sequence.length; i++){
				pstmt1 = con.prepareStatement(LoadAndTripPlannerStatements.GET_LAT_LONG);
				pstmt1.setString(1, uniqueId);
				pstmt1.setString(2, sequence[i].trim());
				rs1 = pstmt1.executeQuery();
				if(rs1.next()){
					obj = new JSONObject();
					obj.put("lat", rs1.getString("lat"));
					obj.put("lon", rs1.getString("lon"));
					obj.put("dest", rs1.getString("dest"));
					obj.put("customer", rs1.getString("customer"));
					obj.put("destETA", rs1.getString("destETA"));
					obj.put("maxETA", rs1.getString("maxETA"));
					jsonArray.put(obj);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}

	public String createTrip(int systemId, int clientId, int userId, String vehicleNo, String uniqueId, String tripIds, int offset) {
		String msg = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		Properties properties = null;
		String sequence [] = {};
		String tripStartTime = "";
		int seq = 0;
		int tripUID = 0;
		int update = 0;
		int update1 = 0;
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			properties = ApplicationListener.prop;
			String data [] = properties.getProperty("sourceLatLng").split(",");
			String sourceLat = data[0];
			String sourceLon = data[1];
			String sourceName = properties.getProperty("sourceName");
			
			Date d = new Date();
			Calendar today = Calendar.getInstance();
			today.setTime(d);
			String hh = hour.format(d);
			if(Double.parseDouble(hh) > 8){
				today.add(Calendar.DATE, 1);
				tripStartTime = dateFormat.format(today.getTime());
			}else{
				tripStartTime = dateFormat.format(today.getTime());
			}
			tripStartTime = tripStartTime +" 08:00:00";
			// insert into trip track details
			pstmt = con.prepareStatement(LoadAndTripPlannerStatements.INSERT_INTO_TRIP_TRACK_DETAILS, Statement.RETURN_GENERATED_KEYS);
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, 0);
			pstmt.setString(3, tripStartTime);
			pstmt.setString(4, "OPEN");
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setInt(7, 0);
			pstmt.setString(8, "NEW");
			pstmt.setInt(9, userId);
			pstmt.executeUpdate();
			rs = pstmt.getGeneratedKeys();
			if(rs.next()){
				tripUID = rs.getInt(1);
			}
			if(tripUID > 0){
				pstmt = con.prepareStatement(LoadAndTripPlannerStatements.GET_ALL_DESTINATIONS);
				pstmt.setString(1,uniqueId);
				pstmt.setString(2, tripIds);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					sequence = rs.getString("sequence").split("->");
				}
				// insert for source
				pstmt1 = con.prepareStatement(LoadAndTripPlannerStatements.INSERT_INTO_DES_TRIP_DETAILS);
				pstmt1.setInt(1, tripUID);
				pstmt1.setString(2, tripStartTime);
				pstmt1.setInt(3, 0);
				pstmt1.setString(4, "ON TIME");
				pstmt1.setInt(5, 0);
				pstmt1.setString(6, sourceLat);
				pstmt1.setString(7, sourceLon);
				pstmt1.setString(8, sourceName);
				update = pstmt1.executeUpdate();
				pstmt1.close();
				
				for(int i = 1; i < sequence.length-1; i++){
					if(i == sequence.length-2){
						seq = 100;
					}else{
						seq = i;
					}
					pstmt = con.prepareStatement(LoadAndTripPlannerStatements.GET_ORDER_DETAILS_FOR_TRIP);
					pstmt.setInt(1, offset);
					pstmt.setString(2, uniqueId);
					pstmt.setString(3, sequence[i]);
					rs = pstmt.executeQuery();
					if(rs.next()){
						// insert into des trip details
						pstmt1 = con.prepareStatement(LoadAndTripPlannerStatements.INSERT_INTO_DES_TRIP_DETAILS);
						pstmt1.setInt(1, tripUID);
						pstmt1.setString(2, rs.getString("deliveryDate"));
						pstmt1.setInt(3, seq);
						pstmt1.setString(4, "ON TIME");
						pstmt1.setInt(5, 0);
						pstmt1.setString(6, rs.getString("lat"));
						pstmt1.setString(7, rs.getString("lon"));
						pstmt1.setString(8, rs.getString("name"));
						update = pstmt1.executeUpdate();
					}
				}
				if(update > 0){
					// update trip created
					pstmt = con.prepareStatement(LoadAndTripPlannerStatements.UPDATE_TRIP_TABLE);
					pstmt.setString(1, "OPEN");
					pstmt.setString(2, uniqueId);
					pstmt.setString(3, tripIds);
					update1 = pstmt.executeUpdate();
				}
			}
			if(update > 0 && update1 > 0){
				msg = "Success";
			}else{
				msg = "failure";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return msg;
	}
	public JSONArray getOrderDetails(int systemId, int clientId, String uniqueId, String tripId, int offset) {
		JSONArray jsonArray = new JSONArray();
		JSONObject obj = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String sequence = "";
		int count = 0;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(LoadAndTripPlannerStatements.GET_ALL_DESTINATIONS);
			pstmt.setString(1,uniqueId);
			pstmt.setString(2, tripId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				sequence = rs.getString("sequence").replaceAll("@",",");
			}
			sequence = sequence.substring(4, sequence.length()-4);
			
		     String arr[]=sequence.split(",");
			
			
			
			System.out.println("sequence.substring(4, sequence.length()-4)"+ sequence);
			for(int i = 0; i < arr.length; i++){
				pstmt1 = con.prepareStatement(LoadAndTripPlannerStatements.GET_ALL_ORDER_DETAILS);
				pstmt1.setInt(1, offset);
				pstmt1.setString(2, uniqueId);
				pstmt1.setString(3, arr[i]);
				rs1 = pstmt1.executeQuery();
				while(rs1.next()){
					count++;
					obj = new JSONObject();
					obj.put("slNo", count);
					obj.put("customer", rs1.getString("customer"));
					obj.put("orderDate", date.format(sdfDB.parse(rs1.getString("date")))+" "+rs1.getString("dTime"));
					obj.put("orderWeight", df.format(rs1.getDouble("weight")));
					obj.put("orderValue", df.format(rs1.getDouble("value")));
					jsonArray.put(obj);
				}
				System.out.println("jsonArray >>"+ jsonArray);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
}
