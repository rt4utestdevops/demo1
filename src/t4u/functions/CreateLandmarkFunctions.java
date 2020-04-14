package t4u.functions;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.CreateLandmarkLocationData;
import t4u.common.DBConnection;
import t4u.statements.AdminStatements;
import t4u.statements.CreateLandmarkStatements;

import com.microsoft.sqlserver.jdbc.SQLServerException;
import com.mongodb.BasicDBObject;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.MongoClient;
import com.vividsolutions.jts.geom.Coordinate;
import com.vividsolutions.jts.geom.Geometry;
import com.vividsolutions.jts.geom.GeometryFactory;
import com.vividsolutions.jts.geom.LinearRing;
import com.vividsolutions.jts.geom.Polygon;

public class CreateLandmarkFunctions {
	private int clientId;
	private int systemId;
	Connection con; 
	ArrayList<String> existingLocationNames = new ArrayList<String>();
	ArrayList<String> existingGeoFenceNames =  new ArrayList<String>(Arrays.asList("HUB", "BORDER", "PROCESSINGPLANT","DEPOT"));  
	CommonFunctions cf=new CommonFunctions();
 

	ArrayList<String> existingManufacturers = new ArrayList<String>();
	private String message = "Location Import History  : \n";
	
	private int rowNo;
	private String location;
	private String radius;
	private String latitude;
	private String longitude;
	private String offset;
	private String city;
	private String state;
	private String country;
	private String hubId;
	private String type;
	private final int startColIdx = 0;
	private final int startRowIdx = 1;
	private String stdDur;
	private Properties pp =null;
	CreateLandmarkStatements createLandmark = new CreateLandmarkStatements();
	GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
    
	public JSONArray getGeoFenceTypes() {
		Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(createLandmark.GET_GEO_FENCE_TYPES);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				jsonObject = new JSONObject();
                jsonObject.put("operationId", rs.getString("OperationId"));
                jsonObject.put("operationType", rs.getString("TypeOfOperation"));
                jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			System.out.println("Error in get Geo Fence types" + e);
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	
	public ArrayList<String> getGMTList() {
		Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        ArrayList<String> GMTList = new ArrayList<String>();
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(createLandmark.GET_GMTLIST);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				GMTList.add(rs.getString("COUNTRY"));
				GMTList.add(rs.getString("GMT"));
			}
		} catch (Exception e) {
			System.out.println("Error in geting GMT list : " + e);
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return GMTList;
	}
	
	public synchronized String saveAuthorizedLocation(String location,
			String clientid, String radius, String latitude, String longitude,
			String GMT, String systemid, String stdDuration) {
		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int autlocid = 0;
		int inserted = 0;

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(createLandmark.CHECK_NAME_EXISTS_IN_AUTHORIZED_LOCATION);
			pstmt.setString(1, location.toUpperCase());
			pstmt.setInt(2, Integer.parseInt(systemid));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				message = "<p class='errormessage'>Location Name Already Exists</p>"+"##"+0;
				return message;
			}
			pstmt = con.prepareStatement(createLandmark.GET_MAX_ID_AUTHORIZED_LOCATION);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("maxid") != null) {
					autlocid = rs.getInt("maxid");
				}
			}
			autlocid++;
			int totalMin = 0;
			if (stdDuration != null) {
				String dur[] = stdDuration.split(":");
				if (dur.length == 2) {
					int hh = Integer.parseInt(dur[0].trim());
					int mm = Integer.parseInt(dur[1].trim());

					totalMin = mm + (hh * 60);
				}
			}
			pstmt = con.prepareStatement(createLandmark.SAVE_AUTHORIZED_LOCATION);
			pstmt.setInt(1, autlocid);
			pstmt.setString(2, location);
			pstmt.setDouble(3, Double.parseDouble(radius));
			pstmt.setDouble(4, Double.parseDouble(latitude));
			pstmt.setDouble(5, Double.parseDouble(longitude));
			pstmt.setString(6, GMT);
			pstmt.setInt(7, Integer.parseInt(systemid));
			pstmt.setInt(8, totalMin);
			inserted = pstmt.executeUpdate();
			if (Integer.parseInt(clientid) > 0 && inserted > 0) {
				pstmt = con.prepareStatement(createLandmark.SAVE_AUTHORIZED_LOCATION_ASSOCIATION);
				pstmt.setInt(1, autlocid);
				pstmt.setInt(2, Integer.parseInt(clientid));
				pstmt.setInt(3, Integer.parseInt(systemid));
				inserted = pstmt.executeUpdate();
			}
			if (inserted > 0) {
				message = "<p class='successmessage'>Authorized Location Saved Successfully</p>";
			} else {
				message = "<p class='errormessage'>Error Saving Authorized Location</p>";
			}
		} catch (Exception e) {
			System.out.println("Exception saving Authorized Location : " + e);
			e.printStackTrace();
			message = "<p class='errormessage'>Error Saving Authorized Location</p>";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	
	public synchronized String saveLocationBuffer(String location, String Type,
			String clientid, String radius, String latitude, String longitude,
			String image, String GMT, String systemid, String stdDuration,String pageName,String sessionId,String serverName,int userid,
			String checkBoxValue,int ClientId,int isLtsp, String region, String tripCustomerId,String contactPerson,String address,String desc,String city,String state,String pincode,String district) 
	throws FileNotFoundException, IOException {
		
		MongoClient mongo=null;
		mongo=DBConnection.getMongoConnection();
		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		int mapid = 0;
		String zone = "";
		int typeId = 0;
		ArrayList<String> tableList=new ArrayList<String>();
		int hubid=0;
		try {
			 pp = ApplicationListener.prop;
			DBCollection collection=mongo.getDB("LOCATION").getCollection("CUSTOMER_POI");
			DBCollection collection1=mongo.getDB("LOCATION").getCollection("CUSTOMER_LANDMARK");
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);

			pstmt = con.prepareStatement(createLandmark.SELECT_ZONE_FROM_SYSTEM_ID);
			pstmt.setString(1, systemid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("Zone") != null) {
					zone = rs.getString("Zone");					
				}
			}
			if("QTP".equals(pageName)){
				pstmt = con.prepareStatement(createLandmark.CHECK_NAME_EXISTS.replace("LOCATION","LOCATION_ZONE_"+zone));
				pstmt.setString(1, location.toUpperCase());
				pstmt.setString(2, clientid);
				pstmt.setString(3, systemid);
				pstmt.setString(4, tripCustomerId);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					message = "<p class='errormessage'>Location Name Already Exists</p>"+"##"+0;
					return message;
				}
			} else {
				pstmt = con.prepareStatement(createLandmark.CHECK_NAME_EXISTS_IN_LOCATION_BUFFER.replace("LOCATION","LOCATION_ZONE_"+zone));
				pstmt.setString(1, location.toUpperCase());
				pstmt.setString(2, clientid);
				pstmt.setString(3, systemid);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					message = "<p class='errormessage'>Location Name Already Exists</p>"+"##"+0;
					return message;
				}
			}
			
			pstmt = con.prepareStatement(createLandmark.GET_MAX_ID_LOCATION_BUFFER.replace("LOCATION","LOCATION_ZONE_"+zone));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("maxmapid") != null) {
					mapid = rs.getInt("maxmapid");
				}
			}
			mapid++;
			int totalMin = 0;
			if (stdDuration != null) {
				String dur[] = stdDuration.split(":");
				if (dur.length == 2) {
					int hh = Integer.parseInt(dur[0].trim());
					int mm = Integer.parseInt(dur[1].trim());

					totalMin = mm + (hh * 60);
				}
			}

			if (radius.equalsIgnoreCase("-1")) {
				int insertLocation = 0;
				int updateLocation = 0;
				int insertPolygon = 0;
				/** save polygon location */
				pstmt = con.prepareStatement(createLandmark.GET_OPERATION_ID);
				pstmt.setString(1, Type);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					typeId = rs.getInt("OperationId");
				}
				double lat=0;
				double longi=0;
				double sumlat=0;
				double sumlon=0;
				String[] lats = latitude.toString().split(",");
				String[] lons = longitude.toString().split(",");
				for (int i = 0; i < lats.length; i++) {
					sumlat=sumlat+Double.parseDouble(lats[i].trim());
					sumlon=sumlon+Double.parseDouble(lons[i].trim());
				}
				if(lats.length>0)
				{
					lat=sumlat/lats.length;
					longi=sumlon/lats.length;
				}

				if(lats.length >= 3){
					if("QTP".equals(pageName)){
						pstmt=con.prepareStatement(createLandmark.CHECK_LAT_LONG_EXISTS.replace("LOCATION","LOCATION_ZONE_"+zone));
						pstmt.setDouble(1,lat);
						pstmt.setDouble(2, longi);
						pstmt.setString(3, tripCustomerId);
						rs=pstmt.executeQuery();
						if(rs.next()) {
							message="<p class='errormessage'>Latitude And Longitude Already Exists</p>"+"##"+0;
							return message;
						}
					} else{
						pstmt=con.prepareStatement(createLandmark.CHECK_LAT_LONG_EXISTS_IN_LOCATION_BUFFER.replace("LOCATION","LOCATION_ZONE_"+zone));
						pstmt.setDouble(1,lat);
						pstmt.setDouble(2, longi);
						rs=pstmt.executeQuery();
						if(rs.next()){
							message="<p class='errormessage'>Latitude And Longitude Already Exists</p>"+"##"+0;
							return message;
						}
					}
					pstmt = con.prepareStatement(createLandmark.SAVE_LOCATION_BUFFER.replace("LOCATION","LOCATION_ZONE_"+zone), Statement.RETURN_GENERATED_KEYS);
					pstmt.setString(1, location);
					pstmt.setString(2, image);
					pstmt.setDouble(3, Double.parseDouble(radius));
					pstmt.setDouble(4, lat);
					pstmt.setDouble(5, longi);
					pstmt.setInt(6, Integer.parseInt(clientid));
					pstmt.setInt(7, Integer.parseInt(systemid));
					pstmt.setDouble(8, mapid);
					pstmt.setString(9, GMT);
					pstmt.setInt(10, 0);
					pstmt.setInt(11, typeId);
					pstmt.setInt(12, totalMin);
					pstmt.setString(13, region);
					pstmt.setString(14, tripCustomerId);
					pstmt.setString(15, contactPerson);
					pstmt.setString(16, address);
					pstmt.setString(17, desc);
					pstmt.setString(18, city);
					pstmt.setString(19, state);
					pstmt.setString(20, pincode);
					insertLocation = pstmt.executeUpdate();
					ResultSet rs1 = pstmt.getGeneratedKeys();
					double[][] latLng=new double[lats.length+1][lats.length+1];
					
					if (rs1.next()) {
						hubid=rs1.getInt(1);
						int i=0;
						for (i = 0; i < lats.length; i++) {
							pstmt = con.prepareStatement(createLandmark.SAVE_POLYGON_LOCATION_DETAILS);
							pstmt.setInt(1, rs1.getInt(1));
							pstmt.setInt(2, i + 1);
							pstmt.setDouble(3, Double.parseDouble(lats[i]));
							pstmt.setDouble(4, Double.parseDouble(lons[i]));						
							pstmt.setInt(5, Integer.parseInt(systemid));
							pstmt.setInt(6, Integer.parseInt(clientid));
							insertPolygon = insertPolygon + pstmt.executeUpdate();
							double[] platLng={Double.parseDouble(lats[i]),Double.parseDouble(lons[i])};
							latLng[i]=platLng;
						}
						double[] platLng={Double.parseDouble(lats[0]),Double.parseDouble(lons[0])};
				        latLng[i]=platLng;
						if(insertPolygon == lats.length){
							pstmt = con.prepareStatement(createLandmark.UPDATE_LOCATION_HUBID_WITH_GENERATED_KEY.replace("LOCATION","LOCATION_ZONE_"+zone));
							pstmt.setInt(1, rs1.getInt(1));
							pstmt.setInt(2, rs1.getInt(1));
							updateLocation = pstmt.executeUpdate();
						}	
					}
					if(typeId!=2 && typeId!=13 && typeId!=999 && lats.length>=3 && typeId!=22 && typeId!=42 )
					{	
						double[][][] polygonCordinates={latLng};
						final BasicDBObject document=new BasicDBObject();
						double[] loc={longi,lat};
						document.put("NAME",location);
						document.put("GEO_CODE",loc);
						document.put("LONGITUDE", longi);
						document.put("LATITUDE", lat);
						document.put("RADIUS",Float.parseFloat(radius));
						document.put("HUBID", rs1.getInt(1));
						document.put("CLIENTID",Integer.parseInt(clientid));
						document.put("SYSTEMID", Integer.parseInt(systemid));
						document.put("OPERATION_ID", typeId);
						document.put("STANDARD_DURATION", totalMin);
						document.put("NESTED_HUB",'N');
						document.put("HUB_DETAILS", new BasicDBObject("type","Polygon").append("coordinates", polygonCordinates));
						collection.insert(document);
					}
				}
				if(checkBoxValue.equals("true")){
	            		pstmt1 = con.prepareStatement(AdminStatements.SAVE_USER_HUB_ASSOC);
	                    pstmt = con.prepareStatement(AdminStatements.SELECT_USER_LIST_FOR_CLIENT);
	                    pstmt.setInt(1, Integer.parseInt(systemid));
	                    pstmt.setInt(2, Integer.parseInt(clientid));
	                    rs = pstmt.executeQuery();
	                    while (rs.next()) {
	                        pstmt1.setInt(1, rs.getInt("User_id"));
	                        pstmt1.setInt(2, hubid);
	                        pstmt1.setInt(3, Integer.parseInt(clientid));
	                        pstmt1.setInt(4, Integer.parseInt(systemid));
	                        try {
	                            int up=pstmt1.executeUpdate();
	                        } catch (SQLServerException e) {
	                        	e.printStackTrace();
	                        }
	                     }
	                    if(isLtsp==0) {
		            		 pstmt1 = con.prepareStatement(AdminStatements.SAVE_USER_HUB_ASSOC);
		            		 pstmt = con.prepareStatement(AdminStatements.SELECT_USER_LIST_FOR_CLIENT);
			                 pstmt.setInt(1, Integer.parseInt(systemid));
			                 pstmt.setInt(2, 0);
			                 rs = pstmt.executeQuery();
			                 
			                 while (rs.next()) {
		                        pstmt1.setInt(1, rs.getInt("User_id"));
		                        pstmt1.setInt(2, hubid);
		                        pstmt1.setInt(3, 0);
		                        pstmt1.setInt(4, Integer.parseInt(systemid));
		                        try {
		                            int up=pstmt1.executeUpdate();
		                        } catch (SQLServerException e) {
		                        	e.printStackTrace();
		                        }
		                     }
		            	 }
	             } else {
	            	 if(ClientId==0){
	            		 pstmt1 = con.prepareStatement(AdminStatements.SAVE_USER_HUB_ASSOC);

	                     pstmt1.setInt(1, userid);
	                     pstmt1.setInt(2, hubid);
	                     pstmt1.setInt(3, ClientId);
	                     pstmt1.setInt(4, Integer.parseInt(systemid));
	                     try {
	                         int up=pstmt1.executeUpdate();
	                     } catch (SQLServerException e) {
	                     	e.printStackTrace();
	                     }
	            	 } else {
	            		 pstmt1 = con.prepareStatement(AdminStatements.SAVE_USER_HUB_ASSOC);

	                     pstmt1.setInt(1, userid);
	                     pstmt1.setInt(2, hubid);
	                     pstmt1.setInt(3, Integer.parseInt(clientid));
	                     pstmt1.setInt(4, Integer.parseInt(systemid));
	                     try {
	                         int up=pstmt1.executeUpdate();
	                     } catch (SQLServerException e) {
	                     	e.printStackTrace();
	                     }
	            	 }
	            }
				if(insertLocation > 0 && insertPolygon == lats.length && updateLocation > 0){
					con.commit();
					message = "<p class='successmessage'>Location Saved Successfully</p>"+"##"+hubid;
					tableList.add("Update"+"##"+"AMS.dbo.LOCATION".replace("LOCATION","LOCATION_ZONE_"+zone));
					tableList.add("Insert"+"##"+"AMS.dbo.POLYGON_LOCATION_DETAILS");
					List<String>consumersSystemIds=Arrays.asList(((pp.getProperty("jsmdcSysID")).toString()).split(","));
					if((consumersSystemIds.contains(systemid) && (typeId==23 || typeId==35)))
						{
						int DistrictId=0;
						PreparedStatement pstmt2 =con.prepareStatement(CreateLandmarkStatements.GET_DISTRICT_ID);
						pstmt2.setString(1, (district.toUpperCase()));
						ResultSet rs1=pstmt2.executeQuery();
						if(rs1.next())
						{
							DistrictId=rs1.getInt(1);
						}
						pstmt2.close();
						rs1.close();
						long time = System.currentTimeMillis();
						java.sql.Date date = new java.sql.Date(time);	
						Connection conn=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
							pstmt=conn.prepareStatement(CreateLandmarkStatements.INSERT_INTO_STOCKYARD_DETAILS_IN_CONSUMER_MODEL);
							pstmt.setString(1,((location.trim()).split(","))[0]);
							pstmt.setString(2, location);
							pstmt.setInt(3,Integer.parseInt(systemid));
							pstmt.setDate(4,date);
							pstmt.setDate(5,date);
//							pstmt.setInt(6, Integer.parseInt(clientid));
							pstmt.setDouble(6, lat);
							pstmt.setDouble(7, longi);
							pstmt.setInt(8, hubid);
							pstmt.setInt(9,DistrictId);
							pstmt.setInt(10,typeId);
							pstmt.setInt(11,391);
							pstmt.setBoolean(12,true);
							pstmt.setInt(13,0);
							pstmt.setInt(14,0);
							pstmt.setInt(15,0);
							pstmt.setInt(16,0);
							pstmt.setInt(17,0);
							pstmt.setInt(18,0);
							pstmt.executeUpdate();
							//FETCH NEWLY CREATED STOCKYARD ID
							if(typeId==23)
							{
								pstmt=conn.prepareStatement(CreateLandmarkStatements.GET_LATEST_STOCKYARD_ID);
								pstmt.setInt(1, hubid);
								rs1=pstmt.executeQuery();
								int stockyarId=0;
								if(rs1.next())
								{
									stockyarId=rs1.getInt(1);
									pstmt.close();
									pstmt=conn.prepareStatement(CreateLandmarkStatements.INSERT_INTO_SAND_QUALITY_MASTER);
									pstmt.setInt(1, stockyarId);
									pstmt.executeUpdate();
								}
							}
//							conn.commit();
							if(pstmt!=null)
							pstmt.close();
							conn.close();
						}
					}
				else{
					try{
						if(con!=null){
							con.rollback();
							message = "<p class='errormessage'>Error While Saving Location</p>"+"##"+0;
						}
					}catch(Exception e){
						e.printStackTrace();
					}
				}
			} else {
				/** save buffer location */
				int insertLocation = 0;
				int updateLocation = 0;
				// int gridNo = clf.getGridId(Double.parseDouble(longitude),
				// Double.parseDouble(latitude), zone);
				int gridNo = 0;
				double radius1=Double.parseDouble(radius);
				/*
				 * if(gridNo==0){
				 * message="<p class='errormessage'>Could not save Location." +
				 * "Location out of bounds for this LTSP." +
				 * " Kindly contact T4U Administrator for details.</p>"; return
				 * message; }
				 */
				pstmt = con.prepareStatement(createLandmark.GET_OPERATION_ID);
				pstmt.setString(1, Type);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					typeId = rs.getInt("OperationId");
				}
				if(!"QTP".equals(pageName)){
					pstmt=con.prepareStatement(createLandmark.CHECK_LAT_LONG_EXISTS_IN_LOCATION_BUFFER.replace("LOCATION","LOCATION_ZONE_"+zone));
					pstmt.setString(1,latitude);
					pstmt.setString(2, longitude);
					rs=pstmt.executeQuery();
					if(rs.next()){
						
						message="<p class='errormessage'>Latitude And Longitude Already Exists</p>"+"##"+0;
						return message;
					}
				}
				
				pstmt = con.prepareStatement(createLandmark.SAVE_LOCATION_BUFFER.replace("LOCATION","LOCATION_ZONE_"+zone), Statement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, location);
				pstmt.setString(2, image);
				pstmt.setDouble(3, radius1);
				pstmt.setDouble(4, Double.parseDouble(latitude));
				pstmt.setDouble(5, Double.parseDouble(longitude));
				pstmt.setInt(6, Integer.parseInt(clientid));
				pstmt.setInt(7, Integer.parseInt(systemid));
				pstmt.setDouble(8, mapid);
				pstmt.setString(9, GMT);
				pstmt.setInt(10, gridNo);
				pstmt.setInt(11, typeId);
				pstmt.setInt(12, totalMin);
				pstmt.setString(13, region);
				pstmt.setString(14, tripCustomerId);
				pstmt.setString(15, contactPerson);
				pstmt.setString(16, address);
				pstmt.setString(17, desc);
				pstmt.setString(18, city);
				pstmt.setString(19, state);
				pstmt.setString(20, pincode);
				insertLocation = pstmt.executeUpdate();
				ResultSet rs1 = pstmt.getGeneratedKeys();
				if (rs1.next()) {
					pstmt = con.prepareStatement(createLandmark.UPDATE_LOCATION_HUBID_WITH_GENERATED_KEY.replace("LOCATION","LOCATION_ZONE_"+zone));
					pstmt.setInt(1, rs1.getInt(1));
					hubid=rs1.getInt(1);
					pstmt.setInt(2, rs1.getInt(1));
					updateLocation = pstmt.executeUpdate();
				}
				if(typeId!=2 && typeId!=13 && typeId!=999 && radius1>0 && typeId!=22 && typeId!=42)
				{	
					final BasicDBObject document=new BasicDBObject();
					double log=Double.parseDouble(longitude);
					double lat=Double.parseDouble(latitude);
					double[] loc={log,lat};
					document.put("NAME",location);
					document.put("GEO_CODE",loc);
					document.put("LONGITUDE", log);
					document.put("LATITUDE", lat);
					document.put("RADIUS",Float.parseFloat(radius));
					document.put("HUBID", rs1.getInt(1));
					document.put("CLIENTID",Integer.parseInt(clientid));
					document.put("SYSTEMID", Integer.parseInt(systemid));
					document.put("OPERATION_ID", typeId);
					document.put("STANDARD_DURATION", totalMin);
					document.put("NESTED_HUB",'N');
					//System.out.println("document"+document);
					collection.insert(document);
					
				}
				else if(typeId!=2 && typeId!=13 && typeId!=999 && radius1==0 && typeId!=22)
				{
					final BasicDBObject document=new BasicDBObject();
					double log=Double.parseDouble(longitude);
					double lat=Double.parseDouble(latitude);
					double[] loc={log,lat};
					document.put("NAME",location);
					document.put("GEO_CODE",loc);
					document.put("LONGITUDE", log);
					document.put("LATITUDE", lat);
					document.put("RADIUS",radius1);
					document.put("HUBID", rs1.getInt(1));
					document.put("CLIENTID",Integer.parseInt(clientid));
					document.put("SYSTEMID", Integer.parseInt(systemid));
					document.put("OPERATION_ID", typeId);
					//System.out.println("document"+document);
					collection1.insert(document);
				}
				if(radius1!=0){
				if(checkBoxValue.equals("true")){
            		pstmt1 = con.prepareStatement(AdminStatements.SAVE_USER_HUB_ASSOC);
                    pstmt = con.prepareStatement(AdminStatements.SELECT_USER_LIST_FOR_CLIENT);
                    pstmt.setInt(1, Integer.parseInt(systemid));
                    pstmt.setInt(2, Integer.parseInt(clientid));
                    rs = pstmt.executeQuery();
                    while (rs.next()) {
                        pstmt1.setInt(1, rs.getInt("User_id"));
                        pstmt1.setInt(2, hubid);
                        pstmt1.setInt(3, Integer.parseInt(clientid));
                        pstmt1.setInt(4, Integer.parseInt(systemid));
                        try {
                            int up=pstmt1.executeUpdate();
                        } catch (SQLServerException e) {
                        	e.printStackTrace();
                        }
                     }
                    if(isLtsp==0){
	            		 pstmt1 = con.prepareStatement(AdminStatements.SAVE_USER_HUB_ASSOC);
	            		 pstmt = con.prepareStatement(AdminStatements.SELECT_USER_LIST_FOR_CLIENT);
		                 pstmt.setInt(1, Integer.parseInt(systemid));
		                 pstmt.setInt(2, 0);
		                 rs = pstmt.executeQuery();
		                 
		                 while (rs.next()) {
	                        pstmt1.setInt(1, rs.getInt("User_id"));
	                        pstmt1.setInt(2, hubid);
	                        pstmt1.setInt(3, 0);
	                        pstmt1.setInt(4, Integer.parseInt(systemid));
	                        try {
	                            int up=pstmt1.executeUpdate();
	                        } catch (SQLServerException e) {
	                        	e.printStackTrace();
	                        }
	                     }
	            	 }
				}else{
	            	 if(ClientId==0){
	            		 pstmt1 = con.prepareStatement(AdminStatements.SAVE_USER_HUB_ASSOC);

	                     pstmt1.setInt(1, userid);
	                     pstmt1.setInt(2, hubid);
	                     pstmt1.setInt(3, ClientId);
	                     pstmt1.setInt(4, Integer.parseInt(systemid));
	                     try {
	                         int up=pstmt1.executeUpdate();
	                     } catch (SQLServerException e) {
	                     	e.printStackTrace();
	                     }
	            	 }else{
	            		 pstmt1 = con.prepareStatement(AdminStatements.SAVE_USER_HUB_ASSOC);

	                     pstmt1.setInt(1, userid);
	                     pstmt1.setInt(2, hubid);
	                     pstmt1.setInt(3, Integer.parseInt(clientid));
	                     pstmt1.setInt(4, Integer.parseInt(systemid));
	                     try {
	                         int up=pstmt1.executeUpdate();
	                     } catch (SQLServerException e) {
	                     	e.printStackTrace();
	                     }
	            	 }
	            }
			}
				if (insertLocation > 0 && updateLocation > 0) {
					con.commit();
					message = "<p class='successmessage'>Location Saved Successfully</p>"+"##"+hubid;
					tableList.add("Update"+"##"+"AMS.dbo.LOCATION".replace("LOCATION","LOCATION_ZONE_"+zone));
					List<String>consumersSystemIds=Arrays.asList(pp.getProperty("jsmdcSysID").toString().split(","));
					if((consumersSystemIds.contains(systemid) && (typeId==23 || typeId==35)))
						{
						int DistrictId=0;
						PreparedStatement pstmt2 =con.prepareStatement(CreateLandmarkStatements.GET_DISTRICT_ID);
						pstmt2.setString(1, (district.toUpperCase()));
						ResultSet rs2=pstmt2.executeQuery();
						if(rs2.next())
						{
							DistrictId=rs2.getInt(1);
						}
						pstmt2.close();
						rs2.close();
						Connection conn=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
						long time = System.currentTimeMillis();
						java.sql.Date date = new java.sql.Date(time);
						System.out.println("----------Location---------");
						pstmt=conn.prepareStatement(CreateLandmarkStatements.INSERT_INTO_STOCKYARD_DETAILS_IN_CONSUMER_MODEL);
							pstmt.setString(1, ((location.trim()).split(","))[0]);
							pstmt.setString(2, location);
							pstmt.setInt(3,Integer.parseInt(systemid));
							pstmt.setDate(4,date);
							pstmt.setDate(5, date);
//							pstmt.setInt(5, Integer.parseInt(clientid));
							pstmt.setDouble(6,Double.parseDouble(latitude));
							pstmt.setDouble(7, Double.parseDouble(longitude));
							pstmt.setInt(8, hubid);
							pstmt.setInt(9, DistrictId);
							pstmt.setInt(10,typeId);
							pstmt.setInt(11,391);
							pstmt.setBoolean(12,true);
							pstmt.setInt(13,0);
							pstmt.setInt(14,0);
							pstmt.setInt(15,0);
							pstmt.setInt(16,0);
							pstmt.setInt(17,0);
							pstmt.setInt(18,0);
							pstmt.executeUpdate();
							
							//FETCH NEWLY CREATED STOCKYARD ID
							if(typeId==23)
							{
								pstmt=conn.prepareStatement(CreateLandmarkStatements.GET_LATEST_STOCKYARD_ID);
								pstmt.setInt(1, hubid);
								rs2=pstmt.executeQuery();
								int stockyarId=0;
								if(rs2.next())
								{
									stockyarId=rs2.getInt(1);
									pstmt.close();
									pstmt=conn.prepareStatement(CreateLandmarkStatements.INSERT_INTO_SAND_QUALITY_MASTER);
									pstmt.setInt(1, stockyarId);
									pstmt.executeUpdate();
								}
							}
//							conn.commit();
							if(pstmt!=null)
							pstmt.close();
							conn.close();
						}
				} else {
					try{
						if(con!=null){
							con.rollback();
							message = "<p class='errormessage'>Error While Saving Location</p>"+"##"+0;
						}
					}catch(Exception e){
						e.printStackTrace();
					}
				}
			}
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "ADD", userid, serverName, typeId, Integer.parseInt(clientid),"Created Landmark");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			try{
				if(con!=null){
					con.rollback();
					message = "<p class='errormessage'>Error While Saving Location</p>"+"##"+0;
				}
				e.printStackTrace();
			}catch(Exception ex){
				ex.printStackTrace();
			}
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			mongo.close();
		}
		return message;
	}
	
	
	
	//______________________________________FOR IMPORT EXCEL____________________________________________

	public void initializeExistingTyreList() {
		con = DBConnection.getConnectionToDB("AMS");
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			pstmt = con
					.prepareStatement("select NAME,HUBID from LOCATION where  CLIENTID=? and SYSTEMID=?");
			pstmt.setInt(1, clientId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				existingLocationNames.add(rs.getString("NAME"));

			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			closeConnection();
		}
	}

	/** return message */
	public String getMessage() {
		return message;
	}

	// --------------------------SAVE LOCATION EXCEL--------------------
	public String saveLocationDetails(int systemId, int clientId,List<CreateLandmarkLocationData> list) {
		Connection con = null;
		PreparedStatement pstmt = null;
		String message = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);
			if(!(list.isEmpty())){
			for (CreateLandmarkLocationData locationDetails : list) {
						insertLocationDetails(locationDetails.hubname,locationDetails.radius, locationDetails.latitude,
						locationDetails.longitude, locationDetails.offset,locationDetails.city, locationDetails.state,
						locationDetails.country, locationDetails.geoFence,locationDetails.stdDuration, clientId, systemId);
			}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
	
	public boolean isHubNameExists() {
		boolean isHubNameExists = false;
		int size = existingLocationNames.size();
		for (int i = 0; i < size; i++) {
			if (existingLocationNames.get(i).toUpperCase().equals(
					(location + "," + city + "," + state + "," + country)
							.toUpperCase())) {
				isHubNameExists = true;
				message = message
						+ "\n"
						+ "Line No : "
						+ rowNo
						+ " HubName  : "
						+ location
						+ "  Failure !! HubName already exists, Please remove it then try.";
				break;
			}
		}
		return isHubNameExists;
	}

	public boolean isGeoFenceNameExits() {
		boolean exists = true;
		String upperType = type.toUpperCase();
		if (existingGeoFenceNames.contains(upperType)) {
			exists = true;

		}
		return exists;
	}

	/** all mandatory information is provided or not */
	public boolean locationDetailsContainsOtherMandatoryInformation() {
		if (location == null || location.trim().equals("")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure..!! "
					+ " HubName : " + location + "  can not be blank";
			return false;
		} else if (location.contains("'") || location.contains("&")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure..!! "
					+ " HubName : " + location + "  sholud not contain & or '";
			return false;
		} else if (radius == null || radius.trim().equals("")
				|| radius.contains("-")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure..!! "
					+ " Radius  For HubName: " + location
					+ " can not be blank or negative.";
			return false;
		} else if (latitude == null || latitude.trim().equals("")
				|| latitude.equals("0")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure !!"
					+ " Latitude For HubName  : " + location
					+ " can not be blank or 0.";
			return false;
		} else if (longitude == null || longitude.trim().equals("")
				|| longitude.equals("0")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure !!"
					+ " Longitude For HubName  : " + location
					+ " can not be blank or 0.";
			return false;
		} else if (offset == null || offset.trim().equals("")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure !!"
					+ " OffSet For HubName  : " + location
					+ " can not be blank.";
			return false;
		} else if (city == null || city.trim().equals("")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure !!"
					+ " City For HubName  : " + location + " can not be blank.";
			return false;
		} else if (city.contains("'") || city.contains("&")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure !!"
					+ " City For HubName  : " + location
					+ " should not contain ' of &.";
			return false;
		} else if (state == null || state.trim().equals("")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure !!"
					+ " State For HubName  : " + location
					+ " can not be blank.";
			return false;
		} else if (state.contains("'") || state.contains("&")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure !!"
					+ " State For HubName  : " + location
					+ " should not contain ' of &.";
			return false;
		} else if (country == null || country.trim().equals("")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure !!"
					+ " Country For HubName  : " + location
					+ " can not be blank.";
			return false;
		} else if (country.contains("'") || country.contains("&")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure !!"
					+ " Country For HubName  : " + location
					+ " should not contain ' of &.";
			return false;
		}

		else if (stdDur == null || stdDur.trim().equals("")) {
			message = message + "\n" + "Line No : " + rowNo + " Failure !!"
					+ " Standard Duration For HubName  : " + location
					+ " can not be blank.";
			return false;
		}

		else {
			return true;
		}

	}

	public String editStrings(String str) {
		String s = "";
		int length = str.length();
		str = str.trim();
		if (str.contains(" ")) {
			String[] sd = str.split(" ");
			if (sd.length != 0) {
				for (int i = 0; i < sd.length; i++) {
					if(!sd[i].equals("")){
					String secondstr = sd[i].substring(0, 1).toUpperCase()
							+ sd[i].substring(1, sd[i].length());
					s = s + " " + secondstr;
					}
				}
			}
		} else {
			str = str.substring(0, 1).toUpperCase()
					+ str.substring(1, str.length());
			s = str;
		}
		return s.trim();
	}

	public boolean islatLongIsCorrect() {
		boolean correct = true;
		if (latitude != null && !latitude.trim().equals("")
				&& longitude != null && !longitude.trim().equals("")) {
			try {
				double lat = Double.parseDouble(latitude);
				double log = Double.parseDouble(longitude);
				correct = true;
			} catch (Exception e) {
				message = message
						+ "\n"
						+ "Line No : "
						+ rowNo
						+ " HubName  : "
						+ location
						+ "  Failure !! Please give the valid latitude and longitude values.";
				correct = false;
			}

		}

		return correct;
	}

	public boolean isGivenOffsetCorrect() {
		boolean correct = true;
		if (offset != null && !offset.trim().equals("")) {
			if (!offset.contains(":")) {
				message = message
						+ "\n"
						+ "Line No : "
						+ rowNo
						+ " HubName  : "
						+ location
						+ "  Failure !! Offset format should be like this format:- 05:30";
				correct = false;
			} else {
				try {
					String[] stt = offset.split(":");
					if (stt.length != 2) {
						message = message
								+ "\n"
								+ "Line No : "
								+ rowNo
								+ " HubName  : "
								+ location
								+ "  Failure !! Offset format should be like this format:- 05:30";
						correct = false;
					} else {
						int offsetHours = Integer.parseInt(stt[0]);
						int pffsetMinutes = Integer.parseInt(stt[1]);
						if (offsetHours > 24) {
							message = message
									+ "\n"
									+ "Line No : "
									+ rowNo
									+ " HubName  : "
									+ location
									+ "  Failure !! Offset hours sholud not be greater than 24.";
							correct = false;
						} else if (pffsetMinutes > 60) {
							message = message
									+ "\n"
									+ "Line No : "
									+ rowNo
									+ " HubName  : "
									+ location
									+ "  Failure !! Offset minutes sholud not be greater than 60.";
							correct = false;
						} else {
							correct = true;
						}
					}
				} catch (Exception e) {
					message = message
							+ "\n"
							+ "Line No : "
							+ rowNo
							+ " HubName  : "
							+ location
							+ "  Failure !! Offset format should be like this format:- 05:30";
					correct = false;
				}
			}

		}
		return correct;
	}

	public boolean isGivenStdDurationCorrect() {
		boolean correct = true;
		if (stdDur != null && !stdDur.trim().equals("")) {
			if (!stdDur.contains(":")) {
				message = message
						+ "\n"
						+ "Line No : "
						+ rowNo
						+ " HubName  : "
						+ location
						+ "  Failure !! Standard Duration format should be like this format:- HH:MM";
				correct = false;
			} else {
				try {
					String[] stt = stdDur.split(":");
					if (stt.length != 2) {
						message = message
								+ "\n"
								+ "Line No : "
								+ rowNo
								+ " HubName  : "
								+ location
								+ "  Failure !! Standard Duration format should be like this format:- HH:MM";
						correct = false;
					} else {
						int hh = Integer.parseInt(stt[0]);
						int mm = Integer.parseInt(stt[1]);
						if (hh > 24) {
							message = message
									+ "\n"
									+ "Line No : "
									+ rowNo
									+ " HubName  : "
									+ location
									+ "  Failure !! Standard Duration Hours should not be greater than 24.";
							correct = false;
						} else if (mm > 60) {
							message = message
									+ "\n"
									+ "Line No : "
									+ rowNo
									+ " HubName  : "
									+ location
									+ "  Failure !! Standard Duration minutes should not be greater than 60.";
							correct = false;
						} else {
							correct = true;
						}
					}
				} catch (Exception e) {
					message = message
							+ "\n"
							+ "Line No : "
							+ rowNo
							+ " HubName  : "
							+ location
							+ "  Failure !! Standard Duration format should be like this format:- HH:MM";
					correct = false;
				}
			}

		}
		return correct;
	}

	public void insertLocationDetails(String loc, String rad, String lat,
			String log, String ofset, String cty, String ste, String cunty,
			String geoFenceType, String stdDur, int clientId, int systemId) {
		// JDBCConnection jc = new JDBCConnection();;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String zone = "";
		int hubid = 0;
		int mapid = 0;
		int geoFenceTypeID = 0;
		String locationString = editStrings(loc) + "," + editStrings(cty) + ","
				+ editStrings(ste) + "," + editStrings(cunty);
		try {

			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement("select Zone from System_Master where System_id=?");
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("Zone") != null) {
					zone = rs.getString("Zone");
				}
			}// select NAME,HUBID from LOCATION where upper(NAME)=? and
				// CLIENTID=? and SYSTEMID=?
			String query = getLocationQuery(
					"select NAME,HUBID from LOCATION where upper(NAME)=? and CLIENTID=? and SYSTEMID=?",
					zone);
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, locationString.toUpperCase());
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			boolean isExists = false;
			if (rs.next()) {
				message = message + "\n" + "Line No : " + rowNo
						+ " HubName  : " + location
						+ "  Failure !! HubName already exists.";
				isExists = true;
			}
			pstmt = con.prepareStatement(CreateLandmarkStatements.GET_GEOFENCE_TYPEID);
			pstmt.setString(1, geoFenceType.trim());
			rs = pstmt.executeQuery();
			if(rs.next())
			{
				geoFenceTypeID = rs.getInt("OperationId");
			}
			// =================================================================================================================================
			// System.out.println("stdDuration: "+stdDuration);
			int totalMin = 0;
			if (stdDur != null) {
				String dur[] = stdDur.split(":");
				if (dur.length == 2) {
					int hh = Integer.parseInt(dur[0].trim());
					int mm = Integer.parseInt(dur[1].trim());

					totalMin = mm + (hh * 60);
				}
			}

			if (!isExists) {
				query = getLocationQuery(
						"select max(HUBID) as maxid,max(MAPID) as maxmapid from LOCATION",
						zone);
				pstmt = con.prepareStatement(query);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					if (rs.getString("maxid") != null) {
						hubid = rs.getInt("maxid");
					}
					if (rs.getString("maxmapid") != null) {
						mapid = rs.getInt("maxmapid");
					}
				}
				hubid++;
				mapid++;
				query = getLocationQuery(
						"insert into LOCATION (NAME,RADIUS,LATITUDE,LONGITUDE,CLIENTID,SYSTEMID,MAPID,OFFSET,OPERATION_ID,Standard_Duration,TRIP_CUSTOMER_ID) values(?,?,?,?,?,?,?,?,?,?,0)",
						zone);
				pstmt = con.prepareStatement(query,
						Statement.RETURN_GENERATED_KEYS);
				pstmt.setString(1, locationString);
				pstmt.setDouble(2, Double.parseDouble(rad));
				pstmt.setDouble(3, Double.parseDouble(lat));
				pstmt.setDouble(4, Double.parseDouble(log));
				pstmt.setInt(5, clientId);
				pstmt.setInt(6, systemId);
				pstmt.setDouble(7, mapid);
				pstmt.setString(8, ofset);
				pstmt.setInt(9, geoFenceTypeID);
				pstmt.setInt(10, totalMin);

				int inserted = pstmt.executeUpdate();
				ResultSet rs1 = pstmt.getGeneratedKeys();
				if (rs1.next()) {
					query = getLocationQuery(
							CreateLandmarkStatements.UPDATE_LOCATION_HUBID_WITH_GENERATED_KEY,
							zone);
					hubid = rs1.getInt(1);
					pstmt = con.prepareStatement(query);
					pstmt.setInt(1, hubid);
					pstmt.setInt(2, hubid);
					inserted = pstmt.executeUpdate();
				}
				if (inserted > 0) {
					message = message + "\n" + "Line No : " + rowNo
							+ " HubName  : " + locationString.toUpperCase()
							+ "  is inserted SuccessFully.";
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
	}

	public void closeConnection() {
		try {
			con.close();
			System.out.println("Connection closed");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String getLocationQuery(CharSequence query, String zone) {
		String retValue = query.toString();
		if (zone.equalsIgnoreCase("")) {
		} else {
			retValue = query.toString().replaceAll("LOCATION",
					"LOCATION_ZONE_" + zone);
		}
		return retValue;
	}
	
	
	
	public synchronized String saveRouteHubLocation(String location,float radius,int clientid,double speedLimit,int systemid,String latitude,
			String longitude,String status)
	{
		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		int insertLocation = 0;
		int routeHubId = 0;
		int childRouteHubId = 0;
		ResultSet rs= null;
		boolean exist = false;
		
		try {
			con = DBConnection.getConnectionToDB("AMS");			
			pstmt = con.prepareStatement(CreateLandmarkStatements.GET_MAX_ROUTE_HUB_ID);			
			rs = pstmt.executeQuery();
			if (rs.next()) {
					routeHubId = rs.getInt("ROUTE_HUB_ID");
			}
			routeHubId++;
			if(radius > 0)
			{
				Coordinate[] coords2 = new Coordinate[] {
						new Coordinate(Double.parseDouble(latitude), Double.parseDouble(longitude)) 						
						};				
				exist = checkAndCompareInseidepolygon(con,coords2,"buffer",Double.parseDouble(latitude),Double.parseDouble(longitude),radius);
				
				
				if(exist == false){
				pstmt = con.prepareStatement(CreateLandmarkStatements.SAVE_ROUTE_HUB);
				pstmt.setString(1, location);
				pstmt.setDouble(2, radius);
				pstmt.setDouble(3, Double.parseDouble(latitude));
				pstmt.setDouble(4, Double.parseDouble(longitude));
				pstmt.setDouble(5, speedLimit);
				pstmt.setInt(6, clientid);
				pstmt.setInt(7, systemid);
				pstmt.setInt(8, routeHubId);
				pstmt.setInt(9, 0);
				pstmt.setString(10, status);
				insertLocation = pstmt.executeUpdate();
				if(insertLocation > 0)
				{					
					message = "Location saved successfully";
				}else {
					message = "Error While Saving Location";
				}
				}
				else {
					
					message = "Hub Already Exists In This Route.";
				}
				
			
			} else if(radius == -1)
			{
				String[] lats = latitude.toString().split(",");
				String[] lons = longitude.toString().split(",");
				int insertPolygon = 0;				
				Coordinate[] coords2 = new Coordinate[lats.length];
				for(int i=0;i<lats.length;i++)
				{
					coords2 [i] = new Coordinate(Double.parseDouble(lats[i]), Double.parseDouble(lons[i]));																						
				}
				exist = checkAndCompareInseidepolygon(con,coords2,"polygon",0.0,0.0,0);
				
				if(exist == false){
				for(int i=0;i<lats.length;i++)
				{
					pstmt = con.prepareStatement(CreateLandmarkStatements.SAVE_ROUTE_HUB);
					pstmt.setString(1, location);
					pstmt.setDouble(2, radius);
					pstmt.setDouble(3, Double.parseDouble(lats[i]));
					pstmt.setDouble(4, Double.parseDouble(lons[i]));
					pstmt.setDouble(5, speedLimit);
					pstmt.setInt(6, clientid);
					pstmt.setInt(7, systemid);
					pstmt.setInt(8, routeHubId);
					pstmt.setInt(9, i+1);
					pstmt.setString(10, status);
					insertPolygon = insertPolygon + pstmt.executeUpdate();
				}
				if(insertPolygon == lats.length)
				{
					message = "Location saved successfully";
				}else {
					message = "Error While Saving Location";
				}
			}
				else {
					
					message = "Hub Already Exists In This Route.";
				}
				
			}
			
		}catch (Exception e) {
			message = "Error While Saving Location";
			e.printStackTrace();			
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}

	
	public static boolean checkAndCompareInseidepolygon(Connection con,Coordinate[] coords2 , String type ,double latitude,double longitude,double radius) {
		PreparedStatement pstmt = null;	
		ResultSet rs= null;
		boolean exist = false;
		int prehubId = 0;
		int currentHubId = 0;
		int size =0;
		int i =0 ;
		try {
		int count = 0;
		int rad = 0;
		Coordinate[] coords1 =null;
		double latitudeb = 0.0;
		double longitudeb = 0.0;
		double radiusb  = 0.0;		
		int rowsize = 0;
		rowsize = getRowSize(con);
		pstmt = con.prepareStatement(CreateLandmarkStatements.GET_ALL_ROUTE_HUB_ID);
		rs = pstmt.executeQuery();		
		while (rs.next()) {
			rad = rs.getInt("RADIUS");
			if(rad>0){
			currentHubId = rs.getInt("ROUTE_HUB_ID");
			coords1 = new Coordinate[1] ;	
		    coords1[0] = new Coordinate(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"));		
            latitudeb = rs.getDouble("LATITUDE");
	        longitudeb = rs.getDouble("LONGITUDE");
	        radiusb = rs.getDouble("RADIUS");
	        String type2 = "buffer";
			exist = checkInseidepolygon(coords1, coords2,type,latitude,longitude,radius,latitudeb,longitudeb,radiusb,type2);	
			prehubId =currentHubId;
			}else{
				String type2 = "polygon";
			if(count == 0 ){				
				prehubId = rs.getInt("ROUTE_HUB_ID");				
				currentHubId = rs.getInt("ROUTE_HUB_ID");
				size = 1;
				if(rs.getInt("SEQUENCE")!=0){
					size = rs.getInt("SEQUENCE");	
				}
				i =0 ;
			    coords1 = new Coordinate[size] ;	
				coords1[i] = new Coordinate(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"));						
				i++;				
				prehubId =currentHubId; 				
			}
			else{
				currentHubId = rs.getInt("ROUTE_HUB_ID");				
				if(prehubId!=currentHubId){					
					if( coords1.length >2  && coords1.length == size  ){
						exist = checkInseidepolygon(coords1, coords2,type,latitude,longitude,radius,latitudeb,longitudeb,radiusb,type2);						
						}				
					size = 1;
					if(rs.getInt("SEQUENCE")!=0){
						size = rs.getInt("SEQUENCE");	
					}
					i =0 ;
					coords1 = new Coordinate[size] ;	
					coords1[i] = new Coordinate(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"));	
					i++;					
					prehubId =currentHubId;									
				}else if(prehubId == currentHubId ){											
					coords1[i] = new Coordinate(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"));	
					i++;					
					prehubId =currentHubId;					
				}				
				if(count == rowsize-1){
					exist = checkInseidepolygon(coords1, coords2,type,latitude,longitude,radius,latitudeb,longitudeb,radiusb,type2);							
				}				
			}
			}
			if(exist == true){
				break;
			}
			count++;
		}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		finally
		{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);
		}
		return exist;
	}
	
	public static int getHubIdCount(Connection con ){
		int i = 0;
		PreparedStatement pstmt =null; 
		ResultSet rs = null;
		try{
		pstmt = con.prepareStatement(CreateLandmarkStatements.GET_ALL_ROUTE_HUB_COUNT_ID);
		rs = pstmt.executeQuery();
		if(rs.next()){
		i = rs.getInt("routeHubCount");
		}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);	
		}
		return i;		
	}
	
	public static int getRowSize(Connection con ){
		int i = 0;
		PreparedStatement pstmt =null; 
		ResultSet rs = null;
		try{
		pstmt = con.prepareStatement(CreateLandmarkStatements.GET_ROWSIZE);
		rs = pstmt.executeQuery();
		if(rs.next()){
		i = rs.getInt("rowsize");
		}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(null, pstmt, rs);	
		}
		return i;		
	}
	
	public static boolean checkInseidepolygon(Coordinate[] coords1 , Coordinate[] coords2 , String type ,double latitude,double longitude, double radius, double latitudeb, double longitudeb, double radiusb,String type2) {
	    boolean check = false;
	    GeometryFactory geometryFactory = new GeometryFactory();
		if(type.equals("polygon")){
		    Coordinate[] coords22 = new Coordinate[coords2.length+1];
			for(int i =0;i<coords22.length;i++){
				if(i==coords22.length-1){
					coords22[i] = coords2[0];
				}else{
				coords22[i] = coords2[i];
				}
			}			
			if(type2.equalsIgnoreCase("buffer")){

				for(int i =0;i<coords22.length;i++){
					double latt = 0.0;
					double longt = 0.0;
					String coordinates = coords22[i].toString();
					coordinates = coordinates.replace(")", "").replace("(", "");
					String coordinateArray [] = coordinates.split(",");
					latt = Double.parseDouble(coordinateArray[0]);
					longt = Double.parseDouble(coordinateArray[1]);
					
					com.vividsolutions.jts.geom.Point pointb =geometryFactory.createPoint(new Coordinate(latitudeb, longitudeb));
					Geometry geb = pointb.buffer(radiusb*0.0102);
			    	
					com.vividsolutions.jts.geom.Point point =geometryFactory.createPoint(new Coordinate(latt, longt));
					//Geometry ge = point.buffer(1*0.0102);
					check = geb.contains(point);
					
					if(check==false){
						LinearRing ring2 = geometryFactory.createLinearRing(coords22);
						Polygon polygon2 = geometryFactory.createPolygon(ring2, null);
						
						com.vividsolutions.jts.geom.Point pointb2 =geometryFactory.createPoint(new Coordinate(latitudeb, longitudeb));
						Geometry geb2 = pointb2.buffer(radiusb*0.0102);
						
						check =  polygon2.contains(geb2);
					}
					
					if(check==true){
						break;
					}
				}				
		    	
			}else{
			Coordinate[] coords11 = new Coordinate[coords1.length+1];
			for(int i =0;i<coords11.length;i++){
				if(i==coords11.length-1){
					coords11[i] = coords1[0];
				}else{
				coords11[i] = coords1[i];
				}
			}
			LinearRing ring1 = geometryFactory.createLinearRing(coords11);
			Polygon polygon1 = geometryFactory.createPolygon(ring1, null);
			
			LinearRing ring2 = geometryFactory.createLinearRing(coords22);
			Polygon polygon2 = geometryFactory.createPolygon(ring2, null);
			
			check = polygon1.contains(polygon2);
			if(check == false){
				check = polygon2.contains(polygon1);
			}
			if(check == false){
				for(int i =0;i<coords22.length;i++){
					double latt = 0.0;
					double longt = 0.0;
					String coordinates = coords22[i].toString();
					coordinates = coordinates.replace(")", "").replace("(", "");
					String coordinateArray [] = coordinates.split(",");
					latt = Double.parseDouble(coordinateArray[0]);
					longt = Double.parseDouble(coordinateArray[1]);
					
					com.vividsolutions.jts.geom.Point point =geometryFactory.createPoint(new Coordinate(latt, longt));	
					check = polygon1.contains(point);	
					if(check==true){
						break;
					}
				}				
			}
			}  
			
		}
		
	    if(type.equals("buffer")){
	    	if(type2.equalsIgnoreCase("polygon")){
	    		Coordinate[] coords11 = new Coordinate[coords1.length+1];
				for(int i =0;i<coords11.length;i++){
					if(i==coords11.length-1){
						coords11[i] = coords1[0];
					}else{
					coords11[i] = coords1[i];
					}
				}
				LinearRing ring1 = geometryFactory.createLinearRing(coords11);
				Polygon polygon1 = geometryFactory.createPolygon(ring1, null);
				
				com.vividsolutions.jts.geom.Point point =geometryFactory.createPoint(new Coordinate(latitude, longitude));	
				check = polygon1.contains(point);	
				
				if(check == false){
					for(int i =0;i<coords11.length;i++){
						double latt = 0.0;
						double longt = 0.0;
						String coordinates = coords11[i].toString();
						coordinates = coordinates.replace(")", "").replace("(", "");
						String coordinateArray [] = coordinates.split(",");
						latt = Double.parseDouble(coordinateArray[0]);
						longt = Double.parseDouble(coordinateArray[1]);
						
						com.vividsolutions.jts.geom.Point point1 =geometryFactory.createPoint(new Coordinate(latt, longt));	
						
						com.vividsolutions.jts.geom.Point point2 =geometryFactory.createPoint(new Coordinate(latitude, longitude));
						Geometry ge = point2.buffer(radius*0.0102);
						check = ge.contains(point1);	
						if(check==true){
							break;
						}
					}
				}
				
	    	}else{
	    	com.vividsolutions.jts.geom.Point pointb =geometryFactory.createPoint(new Coordinate(latitudeb, longitudeb));
			Geometry geb = pointb.buffer(radiusb*0.0102);
	    	
			com.vividsolutions.jts.geom.Point point =geometryFactory.createPoint(new Coordinate(latitude, longitude));
			Geometry ge = point.buffer(radius*0.0102);
			
			check = geb.contains(ge);
			if(check == false){
				check = ge.contains(geb);
			}if(check == false){
				check = geb.contains(point);	
			}if(check == false){
				check = ge.contains(pointb);	
			}
	    }
	    }
		return check;
	}
	
	public ArrayList getLocationDetailsforGrid(int systemId, int clientId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String zone = "";
		int TotalHrs = 0;
		String TotalHrs1 = "";
		int hrs = 0;
		int mins = 0;
		String hrs1 = "";
		String mins1 = "";
		ArrayList finlist1 = new ArrayList();
		 	ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		    ArrayList < String > headersList = new ArrayList < String > ();
		    ReportHelper finalreporthelper = new ReportHelper();
		    ArrayList < Object > finlist = new ArrayList < Object > ();
		int count = 0;
		DecimalFormat df=new DecimalFormat("#.##");
		try {
			
			
			
			headersList.add("Sl No");
	        headersList.add("Landmark Name");
	        headersList.add("Hub/POI Name");
	        headersList.add("Geo Fence Operation Type");
	        headersList.add("Radius");
	        headersList.add("Latitude");
	        headersList.add("Longitude");
	        headersList.add("GMT Offset");
	        headersList.add("Trip Customer");
	        headersList.add("Address");
	        headersList.add("City");
	        headersList.add("State");
	        headersList.add("Country");
	        headersList.add("Region");
	        headersList.add("Contact Person");
	        headersList.add("Standard Duration");
	        headersList.add("HUB ID");
	        headersList.add("ID");
			
			con = DBConnection.getConnectionToDB("AMS");
			String[] locArray = null;
			int i = 0;
			String location = "";
			String country = "";
			String state = "";
			String city = "";
			String locName = "";
			pstmt = con.prepareStatement(CreateLandmarkStatements.SELECT_ZONE_FROM_SYSTEM_ID);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("Zone") != null) {
					zone = rs.getString("Zone");
				}
			}
			double converfactor= cf.getUnitOfMeasureConvertionsfactor(systemId);
			String query = getLocationQuery(CreateLandmarkStatements.GET_EDIT_LOCATION_DETAILS_NEW,zone);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			
			while (rs.next()) {
				 // JsonObject = new JSONObject();
		            ArrayList < Object > informationList = new ArrayList < Object > ();
		            ReportHelper reporthelper = new ReportHelper();
				count++;
				obj1 = new JSONObject();
				TotalHrs = rs.getInt("Standard_Duration");

				hrs = (TotalHrs) / 60;
				mins = (TotalHrs) % 60;

				if (hrs < 10) {
					hrs1 = "0" + hrs;
				} else {
					hrs1 = Integer.toString(hrs);
				}

				if (mins < 10) {
					mins1 = "0" + mins;
				} else {
					mins1 = Integer.toString(mins);
				}

				TotalHrs1 = hrs1 + ":" + mins1;
				obj1.put("slnoIndex", count);
				informationList.add(count);
				
				location = rs.getString("NAME").trim();
				country = "";
				state = "";
				city = "";
				locName = "";
				locArray = null;
				
				
				if (location != null && !location.equals("")) {
					locArray = location.split(",");

					for (i = locArray.length - 1; i >= 0; i--) {
						if (i == locArray.length - 1) {
							country = locArray[i];
						}
						if (i == locArray.length - 2) {
							state = locArray[i];
						}
						if (i == locArray.length - 3) {
							city = locArray[i];
						}
						if (i == locArray.length - 4) {
							for (int k = 0; k <= i; k++) {
								locName = locName + locArray[k] + ",";
							}
						}
					}
				}
				double radius =0;
				obj1.put("landmarkNameDataIndex", rs.getString("NAME"));
				informationList.add(rs.getString("NAME"));
				if(!locName.equals(""))
				{
					obj1.put("locationNameDataIndex", locName.substring(0, locName.length() - 1));
					informationList.add(locName.substring(0, locName.length() - 1));
				}
				else
				{
					obj1.put("locationNameDataIndex", "");
					informationList.add("");
				}
				obj1.put("geoFenceDataIndex", rs.getString("TypeOfOperation"));
				informationList.add(rs.getString("TypeOfOperation"));
				String radiusnew =rs.getString("RADIUS");
				if(!radiusnew.equalsIgnoreCase("-1.0")){
					radius = (Double.parseDouble(radiusnew)*converfactor);
					radiusnew=df.format(radius);
				}
				obj1.put("radiusDataIndex", radiusnew);
				informationList.add(radiusnew);
				
				obj1.put("latitudeDataIndex", rs.getString("LATITUDE"));
				informationList.add(rs.getString("LATITUDE"));
				
				obj1.put("longitudeDataIndex", rs.getString("LONGITUDE"));
				informationList.add(rs.getString("LONGITUDE"));
				
				obj1.put("gmtOffsetDataIndex", rs.getString("OFFSET"));
				informationList.add(rs.getString("OFFSET"));
				
				obj1.put("tripCustomerIndex", rs.getString("TRIP_CUSTOMER"));
				informationList.add(rs.getString("TRIP_CUSTOMER"));
				
				obj1.put("addressIndex", rs.getString("ADDRESS"));
				informationList.add(rs.getString("ADDRESS"));
				
				obj1.put("cityDataIndex", city);
				informationList.add(city);
				
				obj1.put("stateDataIndex", state);
				informationList.add(state);
				
				obj1.put("countryDataIndex", country);
				informationList.add(country);
				
				obj1.put("regionDataIndex", rs.getString("REGION"));
				informationList.add(rs.getString("REGION"));
				
				obj1.put("contactPersonIndex", rs.getString("CONTACT_PERSON"));
				informationList.add(rs.getString("CONTACT_PERSON"));
				
				obj1.put("stdDurationDataIndex", TotalHrs1);
				informationList.add(TotalHrs1);
				
				obj1.put("hubIdDataIndex", rs.getString("HUBID"));
				informationList.add(rs.getString("HUBID"));
				
				obj1.put("idIndex", rs.getString("ID"));
				informationList.add(rs.getString("ID"));
				
				jsonArray.put(obj1);
				reporthelper.setInformationList(informationList);
	            reportsList.add(reporthelper);
			}
		} 
		catch (Exception e) {
			System.out.println("Error in getting Grid Details:" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		//finlist.add(jsonArray);
		
		 finalreporthelper.setReportsList(reportsList);
	        finalreporthelper.setHeadersList(headersList);
	        finlist.add(jsonArray);
	        finlist.add(finalreporthelper);

		
		return finlist;
	}

	public String deleteLandMarkDetails(String systemid, int clientId,
			String totalLandmarkName, int userId,String pageName,String sessionId,String serverName) throws FileNotFoundException,
			IOException {
		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		PreparedStatement pstmt2 = null;
		int deleted = 0;
		String zone = "";
		String landmarkName = "";
		int hubId = 0;
		boolean polygon = false;
		MongoClient mongo = null;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			pp = ApplicationListener.prop;
			con = DBConnection.getConnectionToDB("AMS");
			mongo = DBConnection.getMongoConnection();
			DBCollection collection = mongo.getDB("LOCATION").getCollection("CUSTOMER_POI");
			DBCollection collection1 = mongo.getDB("LOCATION").getCollection("CUSTOMER_LANDMARK");
			pstmt = con.prepareStatement(CreateLandmarkStatements.SELECT_ZONE_FROM_SYSTEM_ID);
			pstmt.setInt(1, Integer.parseInt(systemid));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("Zone") != null) {
					zone = rs.getString("Zone");
				}
			}
			String lName[] = totalLandmarkName.split("@");
			for (int i = 0; i < lName.length; i++) {
				landmarkName = lName[i];
				String query1 = getLocationQuery(CreateLandmarkStatements.GET_HUB_ID_NEW, zone);
				pstmt = con.prepareStatement(query1);
				pstmt.setInt(1, Integer.parseInt(systemid));
				pstmt.setInt(2, clientId);
				pstmt.setString(3, landmarkName);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					hubId = rs.getInt("HUBID");
				}
				String mapId = null;
				String name = null;
				String lon = null;
				String lat = null;
				String radius = null;
				String hubIdDel = null;
				String clientIdDel = null;
				String systemId = null;
				String offset = null;
				String operationId = null;
				String zoneDel = null;
				String query = getLocationQuery(CreateLandmarkStatements.SELECT_LOCATION_DETAILS, zone);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, hubId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					mapId = rs.getString("MAPID");
					name = rs.getString("NAME");
					lon = rs.getString("LONGITUDE");
					lat = rs.getString("LATITUDE");
					radius = rs.getString("RADIUS");
					hubIdDel = rs.getString("HUBID");
					clientIdDel = rs.getString("CLIENTID");
					systemId = rs.getString("SYSTEMID");
					offset = rs.getString("OFFSET");
					operationId = rs.getString("OPERATION_ID");
				}
				query = getLocationQuery(CreateLandmarkStatements.DELETE_LOCATION_DETAILS, zone);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, hubId);
				deleted = pstmt.executeUpdate();
				BasicDBObject obj = new BasicDBObject();
				obj.put("HUBID", hubId);
				obj.put("CLIENTID", clientId);
				DBCursor cursor = collection.find(obj);
				if (cursor.hasNext() == true) {
					collection.remove(obj);
				} else {
					collection1.remove(obj);
				}
				if (deleted > 0) {
					query = CreateLandmarkStatements.INSERT_INTO_HUB_HISTORY;
					pstmt = con.prepareStatement(query);
					pstmt.setString(1, mapId);
					pstmt.setString(2, name);
					pstmt.setString(3, lon);
					pstmt.setString(4, lat);
					pstmt.setString(5, radius);
					pstmt.setString(6, hubIdDel);
					pstmt.setString(7, clientIdDel);
					pstmt.setString(8, systemId);
					pstmt.setString(9, offset);
					pstmt.setString(10, operationId);
					pstmt.setString(11, zone);
					pstmt.setInt(12, userId);
					pstmt.executeUpdate();
				}
				if (radius != null && radius != "") {
					if (radius.equals("-1") || radius.equals("-1.0")) {
						polygon = true;
					}
				}
				if (polygon && deleted > 0) {
					pstmt = con
							.prepareStatement(CreateLandmarkStatements.DELETE_POLYGON_LOCATION_DETAILS);
					pstmt.setInt(1, hubId);
					pstmt.executeUpdate();
					
				}
				if (deleted > 0) {
					pstmt1 = con
							.prepareStatement(CreateLandmarkStatements.DELETE_STATUS_FROM_VEHICLE_BORDER_STATUS);
					pstmt1.setInt(1, hubId);
					pstmt1.executeUpdate();

					pstmt2 = con
							.prepareStatement(CreateLandmarkStatements.DELETE_STATUS_FROM_VEHICLE_STATUS);
					pstmt2.setInt(1, hubId);
					pstmt2.executeUpdate();
					
					List<String>consumersSystemIds=Arrays.asList(((pp.getProperty("jsmdcSysID")).toString()).split(","));
					if(consumersSystemIds.contains(systemid))
						{
						Connection conn=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
						PreparedStatement pstmt3 =conn.prepareStatement(CreateLandmarkStatements.DEACTIVATE_STOCKYARD_IN_CONSUMER_PF);
						pstmt3.setInt(1, hubId);
						int  count=pstmt3.executeUpdate();
						pstmt3.close();
						conn.close();
						}
					
				}
				if (deleted > 0) {
					message = "Location Deleted Successfully";
				} else {
					message = "Error Deleting Location " + landmarkName;
				}
			}//for
			tableList.add("Delete"+"##"+"AMS.dbo.LOCATION".replace("LOCATION","LOCATION_ZONE_"+zone));
			tableList.add("Insert"+"##"+"dbo.HUB_HISTORY");
			
			tableList.add("Delete"+"##"+"POLYGON_LOCATION_DETAILS");
			tableList.add("Delete"+"##"+"Vehicle_Status_Border");
			tableList.add("Delete"+"##"+"Vehicle_Status");
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "DELETE", userId, serverName, deleted, clientId,"Deleted landmark");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("Error Deleting Location Details : " + e);
			message = "Error Deleting Location";
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, null);
			DBConnection.releaseConnectionToDB(null, pstmt2, null);
			mongo.close();
		}
		return message;
	}

	public boolean checkPolygonLocation(int locationId, int systemid) {
		boolean polygon = false;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String zone = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateLandmarkStatements.SELECT_ZONE_FROM_SYSTEM_ID);
			pstmt.setInt(1, systemid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("Zone") != null) {
					zone = rs.getString("Zone");
				}
			}
			String query = getLocationQuery(CreateLandmarkStatements.CHECK_IF_POLYGON_LOCATION, zone);
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1, locationId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				if (rs.getString("RADIUS") != null
						&& rs.getDouble("RADIUS") < 0) {
					polygon = true;
				}
			}
		} catch (Exception e) {
			System.out.println("Exception in check Polygon Location : " + e);
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);

		}
		return polygon;
	}

	public String updateModifiedLandmarkDetails(String locName, String type,
			String radius, String lat, String lon, String gmt, int systemId,
			int clientId, String stdDuration, String id, String hubId,
			String pageName,String sessionId,String serverName,int userid,
			String region, String contactPerson, String address, String desc, String city, String state, String pincode,String district)
			throws FileNotFoundException, IOException {
		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null, rs1 = null;
		String zone = "";
		String polygonNestedHub = "N";
		String bufferNestedHub = "N";
		MongoClient mongo = null;
		int typeId = 0;
		ArrayList<String> tableList=new ArrayList<String>();
		try {
			 pp = ApplicationListener.prop;
			String[] latscalculated = lat.toString().split(",");
			con = DBConnection.getConnectionToDB("AMS");
			mongo = DBConnection.getMongoConnection();
			con.setAutoCommit(false);
			DBCollection collection = mongo.getDB("LOCATION").getCollection("CUSTOMER_POI");
			DBCollection collection1 = mongo.getDB("LOCATION").getCollection("CUSTOMER_LANDMARK");
			pstmt = con.prepareStatement(CreateLandmarkStatements.SELECT_ZONE_FROM_SYSTEM_ID);
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("Zone") != null) {
					zone = rs.getString("Zone");
				}
			}
			pstmt = con.prepareStatement(CreateLandmarkStatements.GET_OPERATION_ID);
			pstmt.setString(1, type);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				typeId = rs.getInt("OperationId");
			}
			
			try {
				pstmt = con.prepareStatement(getLocationQuery(CreateLandmarkStatements.CHECK_IF_LATLONG_CHANGED,zone));
				pstmt.setInt(1, Integer.parseInt(hubId));
				pstmt.setDouble(2, Double.parseDouble(lat));
				pstmt.setDouble(3, Double.parseDouble(lon));
				rs = pstmt.executeQuery();
				if(rs.next()){
					pstmt = con.prepareStatement(CreateLandmarkStatements.INSERT_INTO_USER_LOG_DETAILS);
					pstmt.setInt(1, Integer.parseInt(hubId));
					pstmt.setDouble(2, Double.parseDouble(rs.getString("LATITUDE")));
					pstmt.setDouble(3, Double.parseDouble(rs.getString("LONGITUDE")));
					pstmt.setDouble(4, Double.parseDouble(lat));
					pstmt.setDouble(5, Double.parseDouble(lon));
					pstmt.setInt(6, userid);
					pstmt.setInt(7, systemId);
					pstmt.setInt(8, clientId);
					pstmt.setInt(9, rs.getInt("TRIP_CUSTOMER_ID"));
					pstmt.executeUpdate();
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			String query = getLocationQuery(CreateLandmarkStatements.CHECK_NAME_EXISTS_IN_LOCATION_BUFFER,zone);
			query = query + " and ID != ?";
			pstmt = con.prepareStatement(query);
			pstmt.setString(1, locName.toUpperCase());
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, systemId);
			pstmt.setInt(4, Integer.parseInt(id));
			rs = pstmt.executeQuery();
			if (rs.next()) {
				message = "<p class='errormessage'>Location Name Already Exists</p>";
				return message;
			}
			int totalMin = 0;
			if (stdDuration != null) {
				String dur[] = stdDuration.split(":");
				if (dur.length == 2) {
					int hh = Integer.parseInt(dur[0].trim());
					int mm = Integer.parseInt(dur[1].trim());
					totalMin = mm + (hh * 60);
				}
			}
			if (Double.parseDouble(radius) < 0) {
				/** update polygon location */
				int updated = 0;
				int deleted = 0;
				int inserted = 0;
				double lati = 0;
				double longi = 0;
				double sumlat = 0;
				double sumlon = 0;
				String[] lats = lat.toString().split(",");
				String[] lons = lon.toString().split(",");
				for (int i = 0; i < lats.length; i++) {
					sumlat = sumlat + Double.parseDouble(lats[i].trim());
					sumlon = sumlon + Double.parseDouble(lons[i].trim());
				}
				if (lats.length > 0) {
					lati = sumlat / lats.length;
					longi = sumlon / lats.length;
				}
				if (latscalculated.length >= 3) {
					query = getLocationQuery(CreateLandmarkStatements.UPDATE_LOCATION_ZONE, zone);
					pstmt = con.prepareStatement(query);
					pstmt.setString(1, locName);
					pstmt.setDouble(2, Double.parseDouble(radius));
					pstmt.setDouble(3, lati);
					pstmt.setDouble(4, longi);
					pstmt.setString(5, gmt);
					pstmt.setInt(6, 0);
					pstmt.setInt(7, totalMin);
					pstmt.setString(8, region);
					pstmt.setString(9, contactPerson);
					pstmt.setString(10, address);
					pstmt.setString(11, desc);
					pstmt.setString(12, city);
					pstmt.setString(13, state);
					pstmt.setString(14, pincode);
					pstmt.setInt(15, Integer.parseInt(id));
					pstmt.setInt(16, Integer.parseInt(hubId));
					
					updated = pstmt.executeUpdate();
					query = getLocationQuery(CreateLandmarkStatements.SELECT_LOCATION_ZONE_NESTED_HUB_DETAILS,zone);
					pstmt = con.prepareStatement(query);
					pstmt.setInt(1, Integer.parseInt(id));
					pstmt.setInt(2, Integer.parseInt(hubId));
					rs1 = pstmt.executeQuery();
					if (rs1.next()) {
						polygonNestedHub = rs1.getString("NESTED_HUB");
					}
					if (rs1 != null) {
						rs1.close();
					}
					if (typeId != 2 && typeId!=999 && typeId != 13 && typeId != 22) {
						double[][] latLng = new double[lats.length + 1][lats.length + 1];
						int i = 0;
						for (i = 0; i < lats.length; i++) {
							double[] platLng = { Double.parseDouble(lats[i]),
									Double.parseDouble(lons[i]) };
							latLng[i] = platLng;
						}
						double[] platLng = { Double.parseDouble(lats[0]),
								Double.parseDouble(lons[0]) };
						latLng[i] = platLng;
						double[][][] polygonCordinates = { latLng };
						BasicDBObject document = new BasicDBObject();
						double[] loc = { longi, lati };
						document.put("NAME", locName);
						document.put("GEO_CODE", loc);
						document.put("LONGITUDE", longi);
						document.put("LATITUDE", lati);
						document.put("RADIUS", Float.parseFloat(radius));
						document.put("CLIENTID", clientId);
						document.put("SYSTEMID", systemId);
						document.put("HUBID", Integer.parseInt(hubId));
						document.put("OPERATION_ID", typeId);
						document.put("NESTED_HUB", polygonNestedHub);
						document.put("STANDARD_DURATION", totalMin);
						document.put("HUB_DETAILS", new BasicDBObject("type",
								"Polygon").append("coordinates",polygonCordinates));
						BasicDBObject searchQuery = new BasicDBObject();
						searchQuery.put("HUBID", Integer.parseInt(hubId));
						searchQuery.put("CLIENTID",clientId);

						collection.findAndModify(searchQuery, document);
					}
				} else {
					message = "Location Name cannot be update. Please plot atleast 3 points on Map";
					return message;
				}
				if (updated > 0) {
					pstmt = con.prepareStatement(CreateLandmarkStatements.DELETE_POLYGON_LOCATION_DETAILS);
					pstmt.setInt(1, Integer.parseInt(hubId));
					deleted = pstmt.executeUpdate();
					for (int i = 0; i < lats.length; i++) {
						pstmt = con.prepareStatement(CreateLandmarkStatements.SAVE_POLYGON_LOCATION_DETAILS);
						pstmt.setInt(1, Integer.parseInt(hubId));
						pstmt.setInt(2, i + 1);
						pstmt.setDouble(3, Double.parseDouble(lats[i]));
						pstmt.setDouble(4, Double.parseDouble(lons[i]));
						pstmt.setInt(5, systemId);
						pstmt.setInt(6, clientId);
						inserted = inserted + pstmt.executeUpdate();
					}
				}
				if (updated > 0 && deleted > 0 && inserted == lats.length) {
					tableList.add("Update"+"##"+"AMS.dbo.LOCATION".replace("LOCATION","LOCATION_ZONE_"+zone));
					tableList.add("Delete"+"##"+"AMS.dbo.POLYGON_LOCATION_DETAILS");
					tableList.add("Insert"+"##"+"AMS.dbo.POLYGON_LOCATION_DETAILS");
					con.commit();
					message = "Updated Sucessfully.";
					double lati1 = 0;
					double longi1 = 0;
					if (Double.parseDouble(radius) < 0) 
					{
						double sumlat1 = 0;
						double sumlon1 = 0;
						String[] lats1 = lat.toString().split(",");
						String[] lons1 = lon.toString().split(",");
						for (int i = 0; i < lats1.length; i++) {
							sumlat1 = sumlat1 + Double.parseDouble(lats1[i].trim());
							sumlon1 = sumlon1 + Double.parseDouble(lons1[i].trim());
						}
						if (lats1.length > 0) {
							lati1 = sumlat1 / lats1.length;
							longi1 = sumlon1 / lats1.length;
						}
					}
					else
					{
						lati1=Double.valueOf(lat);
						longi1=Double.valueOf(lon);
					}
					List<String>consumersSystemIds=Arrays.asList(((pp.getProperty("jsmdcSysID")).toString()).split(","));
					if(consumersSystemIds.contains(systemId))
						{
						if(district!=null)
						{
							if((district.length()!=0))
							{
						int DistrictId=0;
						PreparedStatement pstmt2 =con.prepareStatement(CreateLandmarkStatements.GET_DISTRICT_ID);
						pstmt2.setString(1, (district.toUpperCase()));
						ResultSet rs2=pstmt2.executeQuery();
						if(rs2.next())
						{
							DistrictId=rs2.getInt(1);
						}
						pstmt2.close();
						rs2.close();
						Connection conn=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
						long time = System.currentTimeMillis();
						java.sql.Date date = new java.sql.Date(time);
						pstmt=conn.prepareStatement(CreateLandmarkStatements.UPDATE_STOCKYARD_IN_CONSUMER_PF);
							pstmt.setString(1, ((locName.trim()).split(","))[0]);
							pstmt.setString(2, locName);
							pstmt.setInt(3,DistrictId);
//							pstmt.setInt(5, Integer.parseInt(clientid));
							pstmt.setDouble(4,(lati1));
							pstmt.setDouble(5, (longi1));
							pstmt.setDate(6, date);
							pstmt.setInt(7,Integer.parseInt(hubId));
							pstmt.executeUpdate();
//							conn.commit();
							pstmt.close();
							conn.close();
						}
						}
						}
					else
					{
						Connection conn=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
						long time = System.currentTimeMillis();
						java.sql.Date date = new java.sql.Date(time);
						pstmt=conn.prepareStatement(CreateLandmarkStatements.UPDATE_STOCKYARD_IN_CONSUMER_PF_WITHOUT_DISTRICT_ID);
							pstmt.setString(1, ((locName.trim()).split(","))[0]);
							pstmt.setString(2, locName);
							//pstmt.setInt(3,DistrictId);
//							pstmt.setInt(5, Integer.parseInt(clientid));
							pstmt.setDouble(3,lati1);
							pstmt.setDouble(4,longi1);
							pstmt.setDate(5, date);
							pstmt.setInt(6,Integer.parseInt(hubId));
							pstmt.executeUpdate();
					//		conn.commit();
							pstmt.close();
							conn.close();
					}
					
				} else {
					try {
						if (con != null) {
							con.rollback();
							message = "Error While Updating Location";
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			} else {
				/** update buffer location */
				int updated = 0;
				int gridNo = 0;
				/*
				 * if(gridNo==0){
				 * message="<p class='errormessage'>Could not edit Location." +
				 * "Location out of bounds for this LTSP." +
				 * " Kindly contact T4U Administrator for details.</p>"; return
				 * message; }
				 */
				query = getLocationQuery(CreateLandmarkStatements.UPDATE_LOCATION_ZONE, zone);
				pstmt = con.prepareStatement(query);
				pstmt.setString(1, locName);
				pstmt.setDouble(2, Double.parseDouble(radius));
				pstmt.setDouble(3, Double.parseDouble(lat));
				pstmt.setDouble(4, Double.parseDouble(lon));
				pstmt.setString(5, gmt);
				pstmt.setInt(6, gridNo);
				pstmt.setInt(7, totalMin);
				pstmt.setString(8, region);
				pstmt.setString(9, contactPerson);
				pstmt.setString(10, address);
				pstmt.setString(11, desc);
				pstmt.setString(12, city);
				pstmt.setString(13, state);
				pstmt.setString(14, pincode);
				pstmt.setInt(15, Integer.parseInt(id));
				pstmt.setInt(16, Integer.parseInt(hubId));
				
				updated = pstmt.executeUpdate();
				query = getLocationQuery(CreateLandmarkStatements.SELECT_LOCATION_ZONE_NESTED_HUB_DETAILS,zone);
				pstmt = con.prepareStatement(query);
				pstmt.setInt(1, Integer.parseInt(id));
				pstmt.setInt(2, Integer.parseInt(hubId));
				rs1 = pstmt.executeQuery();
				if (rs1.next()) {
					bufferNestedHub = rs1.getString("NESTED_HUB");
				}
				if (typeId != 2 && typeId!=999 && typeId != 13 && Float.parseFloat(radius) > 0
						&& typeId != 22) {
					BasicDBObject document = new BasicDBObject();
					double[] loc = { Double.parseDouble(lon),Double.parseDouble(lat) };
					document.put("NAME", locName);
					document.put("GEO_CODE", loc);
					document.put("LONGITUDE", Double.parseDouble(lon));
					document.put("LATITUDE", Double.parseDouble(lat));
					document.put("RADIUS", Float.parseFloat(radius));
					document.put("HUBID", Integer.parseInt(hubId));
					document.put("CLIENTID", clientId);
					document.put("SYSTEMID", systemId);
					document.put("OPERATION_ID", typeId);
					document.put("NESTED_HUB", bufferNestedHub);
					document.put("STANDARD_DURATION", totalMin);
					BasicDBObject searchQuery = new BasicDBObject();
					searchQuery.put("HUBID", Integer.parseInt(hubId));
					searchQuery.put("CLIENTID",clientId);
					collection.findAndModify(searchQuery, document);
				} else if (Float.parseFloat(radius) == 0) {
					BasicDBObject document = new BasicDBObject();
					double[] loc = { Double.parseDouble(lon),Double.parseDouble(lat) };
					document.put("NAME", locName);
					document.put("GEO_CODE", loc);
					document.put("LONGITUDE", Double.parseDouble(lon));
					document.put("LATITUDE", Double.parseDouble(lat));
					document.put("RADIUS", Float.parseFloat(radius));
					document.put("HUBID", Integer.parseInt(hubId));
					document.put("CLIENTID", clientId);
					document.put("SYSTEMID", systemId);
					document.put("OPERATION_ID", typeId);
					BasicDBObject searchQuery = new BasicDBObject();
					searchQuery.put("HUBID", Integer.parseInt(hubId));
					searchQuery.put("CLIENTID",clientId);
					collection1.findAndModify(searchQuery, document);
				}
				if (updated > 0) {
					con.commit();
					message = "Location Updated Successfully";
					tableList.add("Update"+"##"+"AMS.dbo.LOCATION".replace("LOCATION","LOCATION_ZONE_"+zone));
					double lati1 = 0;
					double longi1 = 0;
					if (Double.parseDouble(radius) < 0) 
					{
						double sumlat1 = 0;
						double sumlon1 = 0;
						String[] lats1 = lat.toString().split(",");
						String[] lons1 = lon.toString().split(",");
						for (int i = 0; i < lats1.length; i++) {
							sumlat1 = sumlat1 + Double.parseDouble(lats1[i].trim());
							sumlon1 = sumlon1 + Double.parseDouble(lons1[i].trim());
						}
						if (lats1.length > 0) {
							lati1 = sumlat1 / lats1.length;
							longi1 = sumlon1 / lats1.length;
						}
					}
					else
					{
						lati1=Double.valueOf(lat);
						longi1=Double.valueOf(lon);
					}
					List<String>consumersSystemIds=Arrays.asList(((pp.getProperty("jsmdcSysID")).toString()).split(","));
					if(consumersSystemIds.contains(systemId))
						{
						if(district!=null)
						{
							if((district.length()!=0))
							{
						int DistrictId=0;
						PreparedStatement pstmt2 =con.prepareStatement(CreateLandmarkStatements.GET_DISTRICT_ID);
						pstmt2.setString(1, (district.toUpperCase()));
						ResultSet rs2=pstmt2.executeQuery();
						if(rs2.next())
						{
							DistrictId=rs2.getInt(1);
						}
						pstmt2.close();
						rs2.close();
						Connection conn=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
						long time = System.currentTimeMillis();
						java.sql.Date date = new java.sql.Date(time);
						pstmt=conn.prepareStatement(CreateLandmarkStatements.UPDATE_STOCKYARD_IN_CONSUMER_PF);
							pstmt.setString(1, ((locName.trim()).split(","))[0]);
							pstmt.setString(2, locName);
							pstmt.setInt(3,DistrictId);
//							pstmt.setInt(5, Integer.parseInt(clientid));
							pstmt.setDouble(4,lati1);
							pstmt.setDouble(5, longi1);
							pstmt.setDate(6, date);
							pstmt.setInt(7,Integer.parseInt(hubId));
							pstmt.executeUpdate();
//							conn.commit();
							pstmt.close();
							conn.close();
						}
						}
						}
					else
					{
						Connection conn=DBConnection.getConnectionMysToMysqlDBJSMDC("sand_consumer_model");
						long time = System.currentTimeMillis();
						java.sql.Date date = new java.sql.Date(time);
						pstmt=conn.prepareStatement(CreateLandmarkStatements.UPDATE_STOCKYARD_IN_CONSUMER_PF_WITHOUT_DISTRICT_ID);
							pstmt.setString(1, ((locName.trim()).split(","))[0]);
							pstmt.setString(2, locName);
							//pstmt.setInt(3,DistrictId);
//							pstmt.setInt(5, Integer.parseInt(clientid));
							pstmt.setDouble(3,lati1);
							pstmt.setDouble(4, longi1);
							pstmt.setDate(5, date);
							pstmt.setInt(6,Integer.parseInt(hubId));
							pstmt.executeUpdate();
//							conn.commit();
							pstmt.close();
							conn.close();
					}
					
				} else {
					try {
						if (con != null) {
							con.rollback();
							message = "Error in Updating";
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
			try {
				cf.insertDataIntoAuditLogReport(sessionId, tableList, pageName, "MODIFY", userid, serverName, systemId, clientId,"Updated Already Created Landmark Details");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, null, rs1);
			mongo.close();
		}
		return message;
	}
	
	public void updateLegAndRouteOfHub(String hubid,int customerid,int systemid,String sessinid,int userid,String servername)
    {
        try {
        	Properties pp = ApplicationListener.prop;
        	String webserviceurl = pp.getProperty("LegRouteWebServiceURL");
            URL url = new URL(webserviceurl);
            HttpURLConnection connection = null;
            JSONObject json = new JSONObject();
                       
            try {
            	
//            	{
//            		"hubid": 771748,
//            		"clientid": 5008,
//            		"userId": 23,
//            		"sessionId": "dddd",
//            		"serverName": "trr",
//            		"systemId": 12
//            		}
            	json.put("hubid", hubid);
            	json.put("clientid", customerid);
            	json.put("userId", userid);
            	json.put("sessionId", sessinid);
            	json.put("serverName", servername);
            	json.put("systemId", systemid);
            	System.out.println(json);
                connection = (HttpURLConnection) url.openConnection();
                connection.setRequestMethod("POST");
                connection.setRequestProperty("Content-Type","application/json");
                connection.setRequestProperty("username", "DHL");
                connection.setRequestProperty("password", "Admin@123");
                connection.setDoOutput(true);
               
                System.out.println("arr="+json.toString());
                OutputStream os = connection.getOutputStream();
                Writer wout = new OutputStreamWriter(os);
                wout.write(json.toString());
                wout.flush();
                wout.close();
                os.flush();
                System.out.println("connection.getResponseCode()"+ connection.getResponseCode());

                String pushedStatus = "" + connection.getResponseCode();
                System.out.println("pushedstatus=="+pushedStatus);
                InputStreamReader reader = new InputStreamReader(connection.getInputStream());
                StringBuilder buf = new StringBuilder();
                char[] cbuf = new char[2048];
                int num;
                while (-1 != (num = reader.read(cbuf))) {
                    buf.append(cbuf, 0, num);
                }

                System.out.println(buf.toString());


                if (pushedStatus.equals("200") ) {
                    System.out.println("succesfull");

                } else{
                    System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&7777");
                }

            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                connection.disconnect();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

	public ArrayList getLocationByHubId(int hubId, int systemid) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		PreparedStatement pstmt1 = null;
		String zone = "";
		JSONArray jsonArray = new JSONArray();
		JSONObject obj1 = null;
		int TotalHrs = 0;
		String TotalHrs1 = "";
		int hrs = 0;
		int mins = 0;
		String hrs1 = "";
		String mins1 = "";
		ArrayList finlist = new ArrayList();
		int count = 0;
		 DecimalFormat df=new DecimalFormat("#.##");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			String[] locArray = null;
			pstmt = con.prepareStatement(CreateLandmarkStatements.SELECT_ZONE_FROM_SYSTEM_ID);
			pstmt.setInt(1, systemid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("Zone") != null) {
					zone = rs.getString("Zone");
				}
			}
			boolean polygon = checkPolygonLocation(hubId, systemid);
			String location = "";
			String country = "";
			String state = "";
			String city = "";
			String locName = "";
			String locType = "";
			int i = 0;
			double converfactor= cf.getUnitOfMeasureConvertionsfactor(systemid);
			String query = getLocationQuery(CreateLandmarkStatements.SELECT_LOCATION_DETAILS, zone);
			pstmt1 = con.prepareStatement(query);
			pstmt1.setInt(1, hubId);
			rs1 = pstmt1.executeQuery();
			while (rs1.next()) {
				count++;
				obj1 = new JSONObject();
				TotalHrs = rs1.getInt("Standard_Duration");
				hrs = (TotalHrs) / 60;
				mins = (TotalHrs) % 60;
				if (hrs < 10) {
					hrs1 = "0" + hrs;
				} else {
					hrs1 = Integer.toString(hrs);
				}
				if (mins < 10) {
					mins1 = "0" + mins;
				} else {
					mins1 = Integer.toString(mins);
				}
				TotalHrs1 = hrs1 + ":" + mins1;

				obj1.put("slnoIndex", count);
				location = rs1.getString("NAME").trim();
				country = "";
				state = "";
				city = "";
				locName = "";
				locArray = null;
				if (location != null && !location.equals("")) {
					locArray = location.split(",");
					if(locArray.length > 1){
						for (i = locArray.length - 1; i >= 0; i--) {
							if (i == locArray.length - 1) {
								country = locArray[i];
							}
							if (i == locArray.length - 2) {
								state = locArray[i];
							}
							if (i == locArray.length - 3) {
								city = locArray[i];
							}
							if (i == locArray.length - 4) {
								for (int k = 0; k <= i; k++) {
									locName = locName + locArray[k] + ",";
								}
	
							}
						}
					}else{
						locName = location;
					}
				}
				if (!rs1.getString("RADIUS").equals("")
						&& rs1.getString("RADIUS") != null) {
					double rad = Double.parseDouble(rs1.getString("RADIUS"));
					if (rad == 0 || rad == 0.0) {
						locType = "Location";
					} else if (rad == -1.0 || rad == -1) {
						locType = "Polygon";
					} else if (rad > 0 || rad > 0.0) {
						locType = "Buffer";
					}
				}
				obj1.put("landmarkNameDataIndex", rs1.getString("NAME"));
				obj1.put("locationNameDataIndex", locName.substring(0, locName.length() - 1));
				obj1.put("locationTypeDataIndex", locType);
				obj1.put("operationIdDataIndex", rs1.getString("OPERATION_ID"));
				obj1.put("geoFenceDataIndex", rs1.getString("TypeOfOperation"));
				String radiusnew =rs1.getString("RADIUS");
				double radius =0;
				if(!radiusnew.equalsIgnoreCase("-1.0")){
					radius = (Double.parseDouble(radiusnew)*converfactor);
					radiusnew=df.format(radius);
				}
				obj1.put("radiusDataIndex", radiusnew);
				obj1.put("latitudeDataIndex", rs1.getString("LATITUDE"));
				obj1.put("longitudeDataIndex", rs1.getString("LONGITUDE"));
				obj1.put("gmtOffsetDataIndex", rs1.getString("OFFSET"));
				obj1.put("idDataIndex", rs1.getString("ID"));
				obj1.put("countryDataIndex", country);
				obj1.put("stateDataIndex", state);
				obj1.put("cityDataIndex", city);
				obj1.put("stdDurationDataIndex", TotalHrs1);
				obj1.put("regionDataIndex", rs1.getString("REGION"));
				if(rs1.getString("TRIP_CUSTOMER").equals("")){
					obj1.put("tripCustomerDataIndex","None");
				}else{
					obj1.put("tripCustomerDataIndex", rs1.getString("TRIP_CUSTOMER"));
				}
				obj1.put("contactPersonDataIndex", rs1.getString("CONTACT_PERSON"));
				obj1.put("addressDataIndex", rs1.getString("ADDRESS"));
				obj1.put("descDataIndex", rs1.getString("DESCRIPTION"));
				jsonArray.put(obj1);
			}
		} 
		catch (Exception e) {
			System.out.println("Error in getting Grid Details:" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		finlist.add(jsonArray);
		return finlist;
	}

	public JSONArray getPolygonCoordinates(String hubId, int systemid) {

		JSONArray PolygonArray = new JSONArray();
		JSONObject PolygonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String zone = "";
		try {
			PolygonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(CreateLandmarkStatements.SELECT_ZONE_FROM_SYSTEM_ID);
			pstmt1.setInt(1, systemid);
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				if (rs1.getString("Zone") != null) {
					zone = rs1.getString("Zone");
				}
			}
			pstmt = con.prepareStatement(CreateLandmarkStatements.GET_POLYGON_COORDINATES
							.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone));
			pstmt.setString(1, hubId);

			rs = pstmt.executeQuery();
			while (rs.next()) {
				PolygonObject = new JSONObject();
				PolygonObject.put("latitude", rs.getString("LATITUDE"));
				PolygonObject.put("longitude", rs.getString("LONGITUDE"));
				PolygonObject.put("sequence", rs.getString("SEQUENCE_ID"));
				PolygonObject.put("hubid", rs.getString("HUBID"));
				PolygonArray.put(PolygonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return PolygonArray;
	}
	
	public JSONArray getMapViewBuffers(int customerId, int systemId) {

		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(CreateLandmarkStatements.GET_BUFFERS_FOR_MAP_VIEW);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BufferObject = new JSONObject();
				BufferObject.put("buffername", rs.getString("LOCATION"));
				BufferObject.put("latitude", rs.getString("LATITUDE"));
				BufferObject.put("longitude", rs.getString("LONGITUDE"));
				BufferObject.put("radius", rs.getString("RADIUS"));
				BufferObject.put("imagename", "");
				BufferObject.put("hubId", rs.getString("HUBID"));
				BufferArray.put(BufferObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return BufferArray;

	}
	
	public JSONArray getMapViewPolygons(int customerId, int systemId) {

		JSONArray PolygonArray = new JSONArray();
		JSONObject PolygonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			PolygonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(CreateLandmarkStatements.GET_POLYGONS_FOR_MAP);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PolygonObject = new JSONObject();
				PolygonObject.put("polygonname", rs.getString("NAME"));
				PolygonObject.put("latitude", rs.getString("LATITUDE"));
				PolygonObject.put("longitude", rs.getString("LONGITUDE"));
				PolygonObject.put("sequence", rs.getString("SEQUENCE"));
				PolygonObject.put("hubid", rs.getString("ROUTE_HUB_ID"));
				PolygonArray.put(PolygonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return PolygonArray;
	}
	public JSONArray getLocation(int customerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject object = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateLandmarkStatements.GET_LOCATION);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				object = new JSONObject();
				object.put("locName", rs.getString("LOCATION"));
				object.put("locId", rs.getString("ROUTE_HUB_ID"));
				object.put("speedLimitId", rs.getString("SPEED_LIMIT"));
				object.put("status", rs.getString("STATUS"));
				object.put("locType", rs.getString("LOCATION_TYPE"));
				jsonArray.put(object);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
	public synchronized String modifyRouteHubLocation(String location,float radius,int clientid,double speedLimit,int systemid,String status,int routeId)
	{
		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		int updateLocation = 0;
		ResultSet rs= null;
		try {
			con = DBConnection.getConnectionToDB("AMS");			
			pstmt = con.prepareStatement(CreateLandmarkStatements.UPDATE_ROUTE_HUB);
			pstmt.setDouble(1, speedLimit);
			pstmt.setString(2, status);
			pstmt.setInt(3, clientid);
			pstmt.setInt(4, systemid);
			pstmt.setInt(5, routeId);
			updateLocation = pstmt.executeUpdate();
			if(updateLocation > 0)
			{					
				message = "Location Updated successfully";
			}else {
				message = "Error While Modifying Location";
			}
			
		}catch (Exception e) {
			message = "Error While Modifying Location";
			e.printStackTrace();			
		}
		finally
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	
	public JSONArray getPolygonCoordinatesForRouteMap(String hubId, int systemid) {

		JSONArray PolygonArray = new JSONArray();
		JSONObject PolygonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String zone = "";
		try {
			PolygonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateLandmarkStatements.GET_POLYGON_DETAILS);
			pstmt.setString(1, hubId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PolygonObject = new JSONObject();
				PolygonObject.put("latitude", rs.getString("LATITUDE"));
				PolygonObject.put("longitude", rs.getString("LONGITUDE"));
				PolygonObject.put("sequence", rs.getString("SEQUENCE"));
				PolygonObject.put("hubid", rs.getString("ROUTE_HUB_ID"));
				PolygonObject.put("radius", rs.getString("RADIUS"));
				PolygonArray.put(PolygonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return PolygonArray;
	}
	
	public JSONArray getTripCustomer(int cutomerId, int systemId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			pstmt = con.prepareStatement(CreateLandmarkStatements.GET_TRIP_CUSTOMER_NAMES);
			pstmt.setInt(1,cutomerId);
			pstmt.setInt(2,systemId);
			rs=pstmt.executeQuery();
			jsonObject = new JSONObject();
			jsonObject.put("CustomerId", "0");
			jsonObject.put("CustomerName", "None");
			jsonArray.put(jsonObject);
			while(rs.next()){
				jsonObject = new JSONObject();
				jsonObject.put("CustomerId", rs.getString("ID"));
				jsonObject.put("CustomerName", rs.getString("NAME"));
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
	public String checkHubInLegDetails(String hubId) {
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		int routecount=0;
		int legcount=0;
		String message="";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			
			pstmt = con.prepareStatement(CreateLandmarkStatements.CHECK_LEGS_AND_ROUTES_FOR_GIVEN_HUB_ID);
			pstmt.setString(1,hubId);
			pstmt.setString(2,hubId);
			rs=pstmt.executeQuery();
			message="Hub is not associated to leg";
			if(rs.next()){
				legcount = rs.getInt("Legcount");
				routecount = rs.getInt("routecount");
			}
			if (legcount>0 || routecount>0) {
				message=" This geo-fence is associated to "+legcount+" leg(s) and "+routecount+" route(s) ";
			}
			
		}catch(Exception e){
			System.out.println("Error in checkHubInLegDetails "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}	
		return message;
	
	}
	
	public JSONArray getArea(String regionName) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		JSONObject jsonObject1 = null;
		try
		{
						if(regionName.equalsIgnoreCase("North"))
						{
							for(int i=1;i<=2;i++)
							{
								jsonObject=new JSONObject();
								jsonObject.put("areaID","North "+i);
								jsonObject.put("areaName","North "+i);
								jsonArray.put(jsonObject);
							}
						}
						else if(regionName.equalsIgnoreCase("South"))
						{
							for(int i=1;i<=2;i++)
						{
							jsonObject=new JSONObject();
							jsonObject.put("areaID","South "+i);
							jsonObject.put("areaName","South "+i);
							jsonArray.put(jsonObject);
						}
						}
						else if(regionName.equalsIgnoreCase("East"))
						{
							for(int i=1;i<=2;i++)
							{
								jsonObject=new JSONObject();
								jsonObject.put("areaID","East "+i);
								jsonObject.put("areaName","East "+i);
								jsonArray.put(jsonObject);
							}
						}
						else if(regionName.equalsIgnoreCase("West"))
						{
							for(int i=1;i<=2;i++)
							{
								jsonObject=new JSONObject();
								jsonObject.put("areaID","West "+i);
								jsonObject.put("areaName","West "+i);
								jsonArray.put(jsonObject);
							}
						}
						else if(regionName.equalsIgnoreCase("North East"))
						{
							for(int i=1;i<=2;i++)
							{
								jsonObject=new JSONObject();
								jsonObject.put("areaID","North East "+i);
								jsonObject.put("areaName","North East "+i);
								jsonArray.put(jsonObject);
							}
						}
						else if(regionName.equalsIgnoreCase("North West"))
						{
							for(int i=1;i<=2;i++)
							{
								jsonObject=new JSONObject();
								jsonObject.put("areaID","North West "+i);
								jsonObject.put("areaName","North West "+i);
								jsonArray.put(jsonObject);
							}
						}
						else if(regionName.equalsIgnoreCase("South East"))
						{
							for(int i=1;i<=2;i++)
							{
								jsonObject=new JSONObject();
								jsonObject.put("areaID","South East "+i);
								jsonObject.put("areaName","South East "+i);
								jsonArray.put(jsonObject);
							}
						}
						else if(regionName.equalsIgnoreCase("South West"))
						{
							for(int i=1;i<=2;i++)
							{
								jsonObject=new JSONObject();
								jsonObject.put("areaID","South West "+i);
								jsonObject.put("areaName","South West "+i);
								jsonArray.put(jsonObject);
							}
						}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return jsonArray;
	}
	public JSONArray isHubNameExist(int systemid, int ClientId,int tripCustId) {

		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		String zone = "";
		String hubName="";
		String hubValue="";
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt1 = con.prepareStatement(CreateLandmarkStatements.SELECT_ZONE_FROM_SYSTEM_ID);
			pstmt1.setInt(1, systemid);
			rs1 = pstmt1.executeQuery();
			if (rs1.next()) {
				if (rs1.getString("Zone") != null) {
					zone = rs1.getString("Zone");
				}
			}
			if(tripCustId != -1){
				pstmt = con.prepareStatement(CreateLandmarkStatements.IS_HUB_NAME_EXIST
					.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone));
				pstmt.setInt(1, systemid);
				pstmt.setInt(2, ClientId);
				pstmt.setInt(3, tripCustId);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					hubName=rs.getString("NAME");
					//System.out.println(hubName);
					hubName=hubName.replaceAll(",", "@");
					String hubArray[]=hubName.split("@");
					jsonObject=new JSONObject();
					if(!hubArray[0].equals("") || hubArray[0]!=null)
					{
						hubValue = hubArray[0].toUpperCase();
					}
						jsonObject.put("hubNameExist", hubValue);
					jsonArray.put(jsonObject);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return jsonArray;
	}
	
	public String getLegAssociatedHubs(int systemid,String hubs) {
		Connection con=null;
		PreparedStatement pstmt=null,pstmt1=null;
		ResultSet rs=null,rs1=null;
		String message="", message1="", message2="";
		String zone="";
		Set<String> set = new HashSet<String>();
		String[] jspHubs = hubs.split("_");
		try{
			con = DBConnection.getConnectionToDB("AMS");
			message1="Hub is not associated to leg";
			pstmt = con.prepareStatement(CreateLandmarkStatements.SELECT_ZONE_FROM_SYSTEM_ID);
			pstmt.setInt(1, systemid);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				if (rs.getString("Zone") != null) {
					zone = rs.getString("Zone");					
				}
			}
			
			for (String hub : jspHubs){
				pstmt = con.prepareStatement(CreateLandmarkStatements.CHECK_HUB_IN_LEGS_DETAILS);
				pstmt.setString(1,hub);
				rs=pstmt.executeQuery();
				
				while(rs.next()){
					if(rs.getString("STATUS").equalsIgnoreCase("Active")){
						message2="Hubs # are associated to route leg. So can't Delete !!!";
						pstmt1 = con.prepareStatement(CreateLandmarkStatements.HUB_NAME_FROM_HUB_ID.replace("LOCATION_ZONE", "LOCATION_ZONE_" + zone));
						pstmt1.setString(1, hub);
						rs1 = pstmt1.executeQuery();
						if (rs1.next()) {
							if (rs1.getString("NAME") != null) {
								set.add(rs1.getString("NAME"));
							}
						}
						
					}
				}
			}
			
			if (message2.contains("#")){
				
				message = message2.replace("#", set.toString());
			}else{
				message = message1;
			}
		}catch(Exception e){
			System.out.println("Error in checkHubInLegDetails "+e.toString());
		}	
		finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
		}	
		return message;
	
	}
	public JSONArray getLocationDetailsByHubId(int hubId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject object = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			jsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CreateLandmarkStatements.GET_LOCATION_DETAILS);
			pstmt.setInt(1, hubId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				object = new JSONObject();
				object.put("hubId", rs.getString("HUBID"));
				object.put("name", rs.getString("NAME"));
				object.put("radius", rs.getString("RADIUS"));
				object.put("image", rs.getString("IMAGE"));
				object.put("latitude", rs.getString("LATITUDE"));
				object.put("longitude", rs.getString("LONGITUDE"));
				object.put("offset", rs.getString("OFFSET"));
				object.put("gridId", rs.getString("GRIDID"));
				object.put("typeOfOperation", rs.getString("TypeOfOperation"));
				object.put("standardDuration", rs.getString("Standard_Duration"));
				object.put("tripCustomerId", rs.getString("TRIP_CUSTOMER_ID"));
				object.put("region", rs.getString("REGION"));
				object.put("area", rs.getString("AREA"));
				object.put("description", rs.getString("DESCRIPTION"));
				object.put("address", rs.getString("ADDRESS"));
				object.put("contactPerson", rs.getString("CONTACT_PERSON"));
				object.put("city", rs.getString("HUB_CITY"));
				object.put("state", rs.getString("HUB_STATE"));
				jsonArray.put(object);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return jsonArray;
	}
}// end of class


