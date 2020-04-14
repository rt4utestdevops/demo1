package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.List;
import java.util.Properties;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.GeneralVertical.CommonUtil;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.common.LocationLocalization;
import t4u.statements.MapViewStatements;
import t4u.statements.OBDStatements;

public class MapViewFunctions {
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	
	DecimalFormat df = new DecimalFormat("0.##");
	DecimalFormat df1 = new DecimalFormat("###.###");
	boolean acHrsCheck=false;
	String getLanuage="LANG_ENGLISH";
    CommonFunctions cf=new CommonFunctions();
    
	public JSONArray getMapViewVehicles(String vehicleType,String listOfCustomer, int offset,int userId, int customerId, int systemId,int isLtsp,String language, int nonCommHrs) {
//System.out.println(" came here for map view function!!!!!!!1");
//System.out.println(" userID ==== "+userId+"  systemId ====== "+systemId);
		
		//Added condition for customer filter listOfCustomer
		if(listOfCustomer.equals("")){
			listOfCustomer = "All";
		}
		String customerFilter = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and g.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
		
		
		
		boolean impreciseSetting = false;
		impreciseSetting = cf.CheckImpreciseSetting(userId, systemId);
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String ETHA="";
		String ETA="";
		
		try {
			Properties properties = ApplicationListener.prop;
			String vehicleImagePath = properties.getProperty("vehicleImagePath");
			VehicleDetailsArray = new JSONArray();			
			con = DBConnection.getConnectionToDB("AMS");
			
			if(isLtsp==0 || customerId==0){
				String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and VehicleNo in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
				
	           	 pstmt=con.prepareStatement(MapViewStatements.GET_REGISTERED_VEHICLE_LIST_TYPE_FOR_CLIENT.concat(customerFilterloc));
	           	 pstmt.setInt(1,userId);
	       		 pstmt.setInt(2,systemId);
	       		 pstmt.setInt(3,systemId);
	       		 pstmt.setInt(4, customerId);
         }else{
        	 String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and VehicleNo in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
				
	             pstmt=con.prepareStatement(MapViewStatements.SELECT_REGISTRATION_NO_FROM_USER_VEHICLE_TYPE_WITH_ACTIVE.concat(customerFilterloc));
	       		 pstmt.setInt(1,userId);
	       		 pstmt.setInt(2,systemId);
	       		 pstmt.setInt(3,systemId);
	       		 pstmt.setInt(4, customerId);
         	}
			rs = pstmt.executeQuery();
			StringBuffer sb=new StringBuffer();
			int a=0;
			while(rs.next()){
				String vehicleNo1 = rs.getString("VehicleNo");			
			
			    if(a==0){
			    	sb.append("'"+vehicleNo1+"'");
			    	a=1;
			    }else{
			    	 sb.append(",'"+vehicleNo1+"'");
			    }			   
		    }  
			 String regList=sb.toString();
			 if(regList.equals("")){
				 regList="''";
			}
			 
			if(isLtsp==0 && customerId==0){
				if (vehicleType.equalsIgnoreCase("all")) {
					if(impreciseSetting == true){
						 // System.out.println(" imprecise true!!!!!!!!!!!");
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
						
							pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW_FOR_IMPRECISE_LOCATION.concat(customerFilterloc).concat(" order by a.REGISTRATION_NO "));	  
						  }else{
					    String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
								
						  pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(customerFilterloc).concat(" order by a.REGISTRATION_NO "));
						  }
				} else if (vehicleType.equalsIgnoreCase("comm")) {
					if(impreciseSetting == true){
						 // System.out.println(" imprecise true!!!!!!!!!!!");
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
						
							pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW_FOR_IMPRECISE_LOCATION.concat(customerFilterloc).concat(" and DATEDIFF(hh,a.GMT,getutcdate()) < "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
						  }else{
							  String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
								
							pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(customerFilterloc).concat(" and DATEDIFF(hh,a.GMT,getutcdate()) < "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
						  }
				} else if (vehicleType.equalsIgnoreCase("noncomm")) {
					if(impreciseSetting == true){
						//  System.out.println(" imprecise true!!!!!!!!!!!");
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
						
							pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW_FOR_IMPRECISE_LOCATION.concat(customerFilterloc).concat(" and DATEDIFF(hh,a.GMT,getutcdate()) >= "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
						  }else{
							  String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
								
								pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(customerFilterloc).concat(" and DATEDIFF(hh,a.GMT,getutcdate()) >= "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));  
						  }
				} else if (vehicleType.equalsIgnoreCase("noGPS")) {
					if(impreciseSetting == true){
						//  System.out.println(" imprecise true!!!!!!!!!!!");
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
						
							pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW_FOR_IMPRECISE_LOCATION.concat(customerFilterloc).concat(" and a.LOCATION ='No GPS Device Connected' order by a.REGISTRATION_NO "));  
						  }else{
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
								
						   pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(customerFilterloc).concat(" and a.LOCATION ='No GPS Device Connected' order by a.REGISTRATION_NO "));	  
						  }
				} else if (vehicleType.equalsIgnoreCase("Running")) {
					if(impreciseSetting == true){
					//	  System.out.println(" imprecise true!!!!!!!!!!!");
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
						
							pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW_FOR_IMPRECISE_LOCATION.concat(customerFilterloc).concat(" and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED>isNull(a.SPEED_LIMIT,10)) order by a.REGISTRATION_NO "));
						  }else{
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
								
							pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(customerFilterloc).concat(" and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED>isNull(a.SPEED_LIMIT,10)) order by a.REGISTRATION_NO "));	  
						  }
				}	else if (vehicleType.equalsIgnoreCase("Stoppage")) {
					if(impreciseSetting == true){
						//  System.out.println(" imprecise true!!!!!!!!!!!");
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
						
							pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW_FOR_IMPRECISE_LOCATION.concat(customerFilterloc).concat(" and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=0 and a.SPEED<=isNull(a.SPEED_LIMIT,10)) order by a.REGISTRATION_NO "));  
						  }else{
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
								
							pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(customerFilterloc).concat(" and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=0 and a.SPEED<=isNull(a.SPEED_LIMIT,10)) order by a.REGISTRATION_NO ")); 
						  }
				}	else if (vehicleType.equalsIgnoreCase("Idle")) {
					if(impreciseSetting == true){
						//  System.out.println(" imprecise true!!!!!!!!!!!");
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
						
							pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW_FOR_IMPRECISE_LOCATION.concat(customerFilterloc).concat(" and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED<=isNull(a.SPEED_LIMIT,10)) order by a.REGISTRATION_NO "));
						  }else{
						String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
								
						  pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(customerFilterloc).concat(" and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED<=isNull(a.SPEED_LIMIT,10)) order by a.REGISTRATION_NO "));
						  }
				}							
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, userId);
				
			}else{
				String customerFilterloc = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and a.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
				
	//runningHoursInMill :			
				if (vehicleType.equalsIgnoreCase("all")) {
					if(impreciseSetting == true){
						//  System.out.println(" imprecise true!!!!!!!!!!!");
						
							pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where a.REGISTRATION_NO in ("+regList+") "+ customerFilterloc +" order by a.REGISTRATION_NO"));	  
						  }else{
							pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+") "+ customerFilterloc +" order by a.REGISTRATION_NO"));	  
						  }
				} else if (vehicleType.equalsIgnoreCase("comm")) {
					if(impreciseSetting == true){
						//  System.out.println(" imprecise true!!!!!!!!!!!");
						  pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where a.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,a.GMT,getutcdate()) < "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' "+ customerFilterloc +" order by a.REGISTRATION_NO "));  
						  }else{
						  pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,a.GMT,getutcdate()) < "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' " + customerFilterloc + " order by a.REGISTRATION_NO "));  
						  }
				} else if (vehicleType.equalsIgnoreCase("noncomm")) {
					if(impreciseSetting == true){
						//  System.out.println(" imprecise true!!!!!!!!!!!");
							pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where a.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,a.GMT,getutcdate()) >= "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' "+ customerFilterloc +"   order by a.REGISTRATION_NO "));
						  }else{
							pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,a.GMT,getutcdate()) >= "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' "+ customerFilterloc +" order by a.REGISTRATION_NO "));  
						  }
				} else if (vehicleType.equalsIgnoreCase("noGPS")) {
					if(impreciseSetting == true){
						//  System.out.println(" imprecise true!!!!!!!!!!!");
							pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where a.REGISTRATION_NO in ("+regList+" )  and a.LOCATION ='No GPS Device Connected' "+customerFilterloc+"  order by a.REGISTRATION_NO"));
						  }else{
						  pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )  and a.LOCATION ='No GPS Device Connected' "+customerFilterloc+" order by a.REGISTRATION_NO"));	  
						  }
				} else if (vehicleType.equalsIgnoreCase("Running")) {
					if(impreciseSetting == true){
						//  System.out.println(" imprecise true!!!!!!!!!!!");
						pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED>a.SPEED_LIMIT) "+customerFilterloc+" order by a.REGISTRATION_NO"));
						  }else{
						pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED>a.SPEED_LIMIT) "+customerFilterloc+" order by a.REGISTRATION_NO")); 
						  }
				} else if (vehicleType.equalsIgnoreCase("Stoppage")) {
					if(impreciseSetting == true){
					//	  System.out.println(" imprecise true!!!!!!!!!!!");
							pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=0 and a.SPEED<=a.SPEED_LIMIT) "+customerFilterloc+" order by a.REGISTRATION_NO"));
						  }else{
								pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=0 and a.SPEED<=a.SPEED_LIMIT) "+customerFilterloc+" order by a.REGISTRATION_NO"));		  
						  }
				} else if (vehicleType.equalsIgnoreCase("Idle")) {
					if(impreciseSetting == true){
						//  System.out.println(" imprecise true!!!!!!!!!!!");
							pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED<=a.SPEED_LIMIT) "+customerFilterloc+" order by a.REGISTRATION_NO"));  
						  }else{
							pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED<=a.SPEED_LIMIT) "+customerFilterloc+" order by a.REGISTRATION_NO"));  
						  }
				}	
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				
			}
			rs = pstmt.executeQuery();	
			int speed = 0;
			int speedLimit = 0;
			boolean stopFlag = false;
			boolean idleFlag = false;
			while (rs.next()) {			
				speed = rs.getInt("SPEED");
				speedLimit = rs.getInt("SPEED_LIMIT");
				
				  stopFlag = false;
    			  idleFlag = false;
    			//System.out.println("ign "+ignition+" speed "+speed+" speedlim "+speedLimit);
    			if(rs.getInt("IGNITION")==0){
    				 stopFlag = true;
    				speed = 0;
    			}
    			else if(rs.getInt("IGNITION")==1 && speed  <= speedLimit){
    				 idleFlag = true;
    				speed = 0;
    			}
				
				VehicleDetailsObject = new JSONObject();				
				String location=null;
				if(language.equals("ar") && !rs.getString("LOCATION").equals("")){
					location=LocationLocalization.getAppendLocationLocalization(rs.getString("LOCATION"), language);
					}else{
						location=rs.getString("LOCATION");
					}
				if(!rs.getString("VEHICLE_ID").equals("")){
					VehicleDetailsObject.put("assetNo", rs.getString("REGISTRATION_NO")+" ["+rs.getString("VEHICLE_ID")+"]");
				}else{
					VehicleDetailsObject.put("assetNo", rs.getString("REGISTRATION_NO"));
				}
				VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				VehicleDetailsObject.put("latitude", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("longitude", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", location);
				VehicleDetailsObject.put("gmt", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
				VehicleDetailsObject.put("drivername", rs.getString("DRIVER_NAME"));
				VehicleDetailsObject.put("groupname",rs.getString("GROUP_NAME"));
				VehicleDetailsObject.put("groupId",rs.getString("GROUP_ID"));
				VehicleDetailsObject.put("LRNO", rs.getString("LR_NO"));
				VehicleDetailsObject.put("tripNo", rs.getString("TRIP_NO"));
				VehicleDetailsObject.put("routeName", rs.getString("ROUTE_NAME"));
				
				VehicleDetailsObject.put("customerName", rs.getString("CUSTOMER_NAME"));				
				
				if(!rs.getString("ETHA").contains("1900")){
					ETHA = sdf.format(sdfDB.parse(rs.getString("ETHA")));
				}
				if(!rs.getString("ETA").contains("1900")){
					ETA = sdf.format(sdfDB.parse(rs.getString("ETA")));
				}
				VehicleDetailsObject.put("etaDest", ETA);
				VehicleDetailsObject.put("etaNextPt", ETHA);
				if(rs.getString("IGNITION").equals("0")){
					
					VehicleDetailsObject.put("ignition","Off");
				}
				if(rs.getString("IGNITION").equals("1")){
					
					VehicleDetailsObject.put("ignition","On");
				}
				if(rs.getInt("DELAY")<0){
					VehicleDetailsObject.put("delay", 0);
				}else{
					VehicleDetailsObject.put("delay", rs.getString("DELAY"));
				}
				VehicleDetailsObject.put("currentStoppageTime", stoppageTimeInHHMM(rs.getString("STOPPAGE_TIME")));
				VehicleDetailsObject.put("currentIdlingTime", stoppageTimeInHHMM(rs.getString("IDLE_TIME")));
				
				VehicleDetailsObject.put("category",rs.getString("CATEGORY"));
				VehicleDetailsObject.put("prevlat",rs.getString("PREV_LAT"));
				VehicleDetailsObject.put("prevlong",rs.getString("PREV_LONG"));
				String path=rs.getString("IMAGE_NAME");
			    String vehicleImage="";
			    String vehicleImage1="";
			    String vehicleImageServerPath = "";
			    String imagePath = "";
				if(path==null || path.equals("")){			            								   
				       vehicleImage= "default";	 
				}else{
					if(!path.contains("default"))
					{
					   vehicleImage= path.substring(path.lastIndexOf("/")+1, path.lastIndexOf("_"));
					} else {
						vehicleImage= path.substring(path.lastIndexOf("/")+1, path.indexOf("_"));
					}
				}
				VehicleDetailsObject.put("imagePath",vehicleImage);
				if(path==null || path.equals("")){	
//						if(rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED")>10)
//						{
//							vehicleImage1= "<img src='"+vehicleImagePath+"default_BG.png' width='20' height='20' style='margin-top: -3px;'></img>";	
//							vehicleImageServerPath = vehicleImagePath+"default_BG.png";
//						} else
						if(stopFlag){
							vehicleImage1= "<img src='"+vehicleImagePath+"default_BR.png' width='20' height='20' style='margin-top: -3px;'></img>";	
							vehicleImageServerPath = vehicleImagePath+"default_BR.png";
						}else if(idleFlag){
							vehicleImage1= "<img src='"+vehicleImagePath+"default_BL.png' width='20' height='20' style='margin-top: -3px;'></img>";	 
							vehicleImageServerPath = vehicleImagePath+"default_BL.png";
						}else {
							vehicleImage1= "<img src='"+vehicleImagePath+"default_BG.png' width='20' height='20' style='margin-top: -3px;'></img>";	 
							vehicleImageServerPath = vehicleImagePath+"default_BG.png";
						}
				}else{
					 imagePath=path.substring(path.lastIndexOf("/")+1, path.lastIndexOf("_"));	
					 if(imagePath.contains("default"))
					 {
//						 if(rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED")>10)
//						 {
//							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BG.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
//							 vehicleImageServerPath = vehicleImagePath+""+imagePath+"_BG.png";
//						 } else 
						 if(stopFlag){
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BR.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
							 vehicleImageServerPath = vehicleImagePath+""+imagePath+"_BR.png";
						 } else if(idleFlag){
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BL.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
							 vehicleImageServerPath = vehicleImagePath+""+imagePath+"_BL.png";
						 } else{
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BG.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
							 vehicleImageServerPath = vehicleImagePath+""+imagePath+"_BG.png";
						 }
					 } else {
//						 if(rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED")>10)
//						 {
//							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BG.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";	
//							 vehicleImageServerPath = vehicleImagePath+""+imagePath+"_BG.png";
//						 }else 
						if(stopFlag){
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BR.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
							 vehicleImageServerPath = vehicleImagePath+""+imagePath+"_BR.png";
						 }else if(idleFlag){
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BL.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
							 vehicleImageServerPath = vehicleImagePath+""+imagePath+"_BL.png";
						 }else{
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BG.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";	
							 vehicleImageServerPath = vehicleImagePath+""+imagePath+"_BG.png";
						 }
					 }
				}  
				VehicleDetailsObject.put("vehicleImageServerPath",vehicleImageServerPath);
				VehicleDetailsObject.put("imageIcon",vehicleImage1);
				VehicleDetailsObject.put("vehicleMake", rs.getString("Vehicle_Make"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public JSONArray getMapViewVehiclesForDMG(int customerID,int systemId) {

		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		String ignition="";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			VehicleDetailsArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
					pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS_DMG);
				    pstmt.setInt(1, customerID);
				    pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				VehicleDetailsObject = new JSONObject();
				if(rs.getInt("IGNITION")==1)
				{
					ignition="On";
				}
				else
				{
					ignition="Off";
				}
				VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				VehicleDetailsObject.put("latitude", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("longitude", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("gmt", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
				VehicleDetailsObject.put("drivername", rs.getString("DRIVER_NAME"));
				VehicleDetailsObject.put("groupname", rs.getString("GROUP_NAME"));
				VehicleDetailsObject.put("ignition",ignition);
				VehicleDetailsObject.put("category",rs.getString("CATEGORY"));
				VehicleDetailsObject.put("status", rs.getString("STATUS"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public JSONArray getIronMiningMapViewVehicles(String vehicleType, int offset,int userId, int customerId, int systemId,String asset) {

		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			VehicleDetailsArray = new JSONArray();
			String ignition="";
			con = DBConnection.getConnectionToDB("AMS");
			if (vehicleType.equalsIgnoreCase("all")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_IRON_MINING_MAP_VIEW_DETAILS);
			} else if (vehicleType.equalsIgnoreCase("comm")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_IRON_MINING_MAP_VIEW_COMM_DETAILS);
			} else if (vehicleType.equalsIgnoreCase("noncomm")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_IRON_MINING_MAP_VIEW_NON_COMM_DETAILS);
			} else if (vehicleType.equalsIgnoreCase("noGPS")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_IRON_MINING_MAP_VIEW_NO_GPS_DETAILS);
			}
			pstmt.setInt(1, userId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, asset);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				VehicleDetailsObject = new JSONObject();
				if(rs.getInt("IGNITION")==1)
				{
					ignition="On";
				}
				else
				{
					ignition="Off";
				}
				VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				VehicleDetailsObject.put("latitude", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("longitude", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("gmt", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
				VehicleDetailsObject.put("drivername", rs.getString("DRIVER_NAME"));
				VehicleDetailsObject.put("groupname", rs.getString("GROUP_NAME"));
				VehicleDetailsObject.put("ignition",ignition);
				VehicleDetailsObject.put("category",rs.getString("CATEGORY"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	
	public JSONArray getMapViewBuffers(int userId,int customerId, int systemId,String zone,int isLTSP) {

		JSONArray BufferArray = new JSONArray();
		JSONObject BufferObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			BufferArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if(customerId==0){
				pstmt = con.prepareStatement(MapViewStatements.GET_BUFFERS_FOR_LTSP_MAP_VIEW.replace("LOCATION", "LOCATION_ZONE_"+zone));
				pstmt.setInt(1, systemId);
			}else if(isLTSP == -1 && customerId > 0){
				pstmt = con.prepareStatement(MapViewStatements.GET_BUFFERS_FOR_USER_MAP_VIEW.replace("LOCATION", "LOCATION_ZONE_"+zone));
				 pstmt.setInt(1, systemId);
                 pstmt.setInt(2, customerId);
                 pstmt.setInt(3, systemId);
                 pstmt.setInt(4, userId);
                 pstmt.setInt(5, customerId);
                 pstmt.setInt(6, systemId);
			}else{
				pstmt = con.prepareStatement(MapViewStatements.GET_BUFFERS_FOR_MAP_VIEW.replace("LOCATION", "LOCATION_ZONE_"+zone));
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
			}			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BufferObject = new JSONObject();
				BufferObject.put("buffername", rs.getString("NAME"));
				BufferObject.put("latitude", rs.getString("LATITUDE"));
				BufferObject.put("longitude", rs.getString("LONGITUDE"));
				BufferObject.put("radius", rs.getString("RADIUS"));
				if(rs.getString("IMAGE")!="")
				BufferObject.put("imagename", rs.getString("IMAGE"));
				else
				BufferObject.put("imagename", rs.getString("IMAGE"));
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

	public JSONArray getMapViewPolygons(int userId,int customerId, int systemId,String zone,int isLTSP) {

		JSONArray PolygonArray = new JSONArray();
		JSONObject PolygonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			PolygonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if(customerId==0){
				pstmt = con.prepareStatement(MapViewStatements.GET_POLYGONS_FOR_LTSP_MAP.replace("LOCATION_ZONE","LOCATION_ZONE_"+zone));			
				pstmt.setInt(1, systemId);
			}else if(isLTSP == -1 && customerId > 0){
				pstmt = con.prepareStatement(MapViewStatements.GET_POLYGONS_FOR_USER_MAP.replace("LOCATION_ZONE", "LOCATION_ZONE_"+zone));
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userId);
				pstmt.setInt(3, customerId);
				pstmt.setInt(4, systemId);
			}else{
				pstmt = con.prepareStatement(MapViewStatements.GET_POLYGONS_FOR_MAP.replace("LOCATION_ZONE","LOCATION_ZONE_"+zone));
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
			}			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				PolygonObject = new JSONObject();
				PolygonObject.put("polygonname", rs.getString("NAME"));
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
		}
		return PolygonArray;
	}
	public JSONArray getServiceStation(int customerId, int systemId,String zone,String assetMake,int groupId) {

		JSONArray serviceStationArray = new JSONArray();
		JSONObject serviceStationObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pst = null;
		ResultSet result = null;
		try {
			serviceStationArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if(customerId==0){
				pstmt = con.prepareStatement(MapViewStatements.GET_SERVICE_STATION_FOR_LTSP_MAP.replace("LOCATION_ZONE","LOCATION_ZONE_"+zone));			
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, systemId);
				pstmt.setString(3, assetMake);
				pstmt.setInt(4, groupId);
			}else{
				pstmt = con.prepareStatement(MapViewStatements.GET_SERVICE_STATION_FOR_MAP.replace("LOCATION_ZONE","LOCATION_ZONE_"+zone));
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, customerId);
				pstmt.setString(5, assetMake);
				pstmt.setInt(6, groupId);
			}			
			rs = pstmt.executeQuery();
			while(rs.next()){
				serviceStationObject = new JSONObject();
				serviceStationObject.put("serviceStationName", rs.getString("NAME"));
				serviceStationObject.put("latitude", rs.getString("LATITUDE"));
				serviceStationObject.put("longitude", rs.getString("LONGITUDE"));
				serviceStationObject.put("sequenceNo", rs.getString("SEQUENCE_ID"));
				serviceStationObject.put("hubId", rs.getString("HUBID"));
				serviceStationObject.put("lat", rs.getString("LAT"));
				serviceStationObject.put("long", rs.getString("LONG"));
				serviceStationObject.put("radius", rs.getString("RADIUS"));
				serviceStationArray.put(serviceStationObject);
			}
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pst, result);
		}
		return serviceStationArray;
	}

	public JSONArray getMapViewVehiclesDetails(String vehicleNo, int offset,int userId, int customerId, int systemId) {

		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			VehicleDetailsArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_ASSET_DETAILS);
			pstmt.setInt(1, offset);
			pstmt.setString(2, vehicleNo);
			pstmt.setInt(3, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				VehicleDetailsObject = new JSONObject();
				if(rs.getString("ACTUAL_ARRIVAL")=="" || rs.getString("ACTUAL_ARRIVAL").contains("1900"))
				{
				VehicleDetailsObject.put("lastPortArrival", "");
				}
				else
				VehicleDetailsObject.put("lastPortArrival", rs.getString("NAME")+" <br>at "+ddmmyyyy.format(yyyymmdd.parse(rs.getString("ACTUAL_ARRIVAL"))));
				VehicleDetailsObject.put("ownerName", rs.getString("OwnerName"));
				VehicleDetailsObject.put("ownerNo", rs.getString("OwnerContactNo"));
				VehicleDetailsObject.put("uniqueSandId", rs.getString("UniqueSandId"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public JSONArray getMapCashVanViewVehiclesDetails(String vehicleNo,
			int offmin, int userID, int customerID, int systemId,String language,int isLtsp,String processId) {


		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rsIntial = null;
		String ignition="";
		double speedFinal=0;
		String temp="";
		try {
			VehicleDetailsArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");			
			HashMap <String,Double> vehTypeDistFactorMap = new HashMap <String,Double>();
			pstmt = con.prepareStatement(MapViewStatements.GET_VEHICLE_TYPE_DIST_FACTOR_MAP);
			rsIntial = pstmt.executeQuery();
        	while(rsIntial.next()){
        		vehTypeDistFactorMap.put(rsIntial.getString("VehicleTypeName"), rsIntial.getDouble("ConversionFactor"));
        	}  
        	
			pstmt = con.prepareStatement(MapViewStatements.GET_CASH_VAN_MAP_VIEW_ASSET_DETAILS);
			pstmt.setInt(1, offmin);
			pstmt.setInt(2, offmin);
			pstmt.setInt(3, offmin);
			pstmt.setString(4, vehicleNo);
			pstmt.setInt(5, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				
				 String SpeedLimit=rs.getString("SPEED_LIMIT");
				 double distFactor  =cf.getUnitOfMeasureConvertionsfactor(systemId);//1; //default distance unit is kms
	        		if(vehTypeDistFactorMap.get(rs.getString("VEHICLE_TYPE")) != null){
	        			distFactor = Double.parseDouble(vehTypeDistFactorMap.get(rs.getString("VEHICLE_TYPE")).toString());
	        		}		          
 				
 				double speedLimit=Double.parseDouble(SpeedLimit);//getSpeedLimits(registrationNo,ldb.getClientId(),systemId,con,imageCon,pstmt,rs);commented by pooja
 				/* convert speed limit from kms to proper conversion unit of that vehicle based on type of the vehicle */
 				speedLimit = speedLimit * distFactor;
 				double speed = rs.getInt("SPEED");
     			/* get speed from kms value  to proper unit value based on the type of vehicle */
     			speed = speed * distFactor;	
     			
     			
     			
     			if(rs.getInt("IGNITION")==0){     				
     				speed = 0;
     			}
     			else if(rs.getInt("IGNITION")==1 && speed  <= speedLimit){     				 
     				speed = 0;
     			}
     			
     			double spd = Double.parseDouble(df.format(speed));
 				if (spd > 0) {
 					speedFinal=spd;
					} else {
						speedFinal=0;
					}
				
				if(rs.getInt("IGNITION")==1)
				{
					ignition="On";
				}
				else
				{
					ignition="Off";
				}
				VehicleDetailsObject = new JSONObject();
				
				String driverName=null;
				String vehicleGroup=null;
				String ignitionStatus=null;
				String vehicleTypeName=null; 
				
				String lrNo = null;
				String tripNo = null;
				String routeName = null;
				String customerName = null;
				
				String ETHA="";
				String ETA="";
				String ATD="";
				
				if(language.equals("ar") && !rs.getString("DRIVER_NAME").equals("")){
					driverName=LocationLocalization.getLocationLocalization(rs.getString("DRIVER_NAME"), language);
					}else{
						driverName=rs.getString("DRIVER_NAME");
					}
 				if(language.equals("ar") && !rs.getString("LR_NO").equals("")){
					lrNo=LocationLocalization.getLocationLocalization(rs.getString("LR_NO"), language);
					}else{
						lrNo=rs.getString("LR_NO");
					}
				if(language.equals("ar") && !rs.getString("TRIP_NO").equals("")){
					tripNo=LocationLocalization.getLocationLocalization(rs.getString("TRIP_NO"), language);
					}else{
						tripNo=rs.getString("TRIP_NO");
					}
				if(language.equals("ar") && !rs.getString("ROUTE_NAME").equals("")){
					routeName=LocationLocalization.getLocationLocalization(rs.getString("ROUTE_NAME"), language);
					}else{
						routeName=rs.getString("ROUTE_NAME");
					}
				if(language.equals("ar") && !rs.getString("CUSTOMER_NAME").equals("")){					
					customerName=LocationLocalization.getLocationLocalization(rs.getString("CUSTOMER_NAME"), language);
					}else{
						customerName=rs.getString("CUSTOMER_NAME");
					}
				
				if(language.equals("ar") && !rs.getString("GROUP_NAME").equals("")){
					vehicleGroup=LocationLocalization.getApplicationResourcesValuesForArabicNew(rs.getString("GROUP_NAME"));
				}else{
					vehicleGroup=rs.getString("GROUP_NAME");
				}
				if(language.equals("ar")){
					ignitionStatus=LocationLocalization.getApplicationResourcesValuesForArabic(ignition);
				}else{
					ignitionStatus=ignition;
				}	
				if(language.equals("ar") && !rs.getString("VEHICLE_TYPE").equals("")){
					vehicleTypeName=LocationLocalization.getApplicationResourcesValuesForArabic(rs.getString("VEHICLE_TYPE"));
				}else{
					vehicleTypeName=rs.getString("VEHICLE_TYPE");
					}
				
				 if(rs.getString("Temperature").equalsIgnoreCase("10000") || rs.getString("Temperature").equalsIgnoreCase("10000.0") || rs.getString("Temperature").equalsIgnoreCase("300") || rs.getString("Temperature").equalsIgnoreCase("300.0")){
   					     temp = "";
   					 }
   					 else{
   						 temp=rs.getString("Temperature");
   					 }
					if(rs.getInt("DELAY")<0){
						VehicleDetailsObject.put("delay", 0);
					}else{
						VehicleDetailsObject.put("delay", rs.getString("DELAY"));
					}
					VehicleDetailsObject.put("currentStoppageTime", stoppageTimeInHHMM(rs.getString("STOPPAGE_TIME")));
					VehicleDetailsObject.put("currentIdlingTime", stoppageTimeInHHMM(rs.getString("IDLE_TIME")));

				VehicleDetailsObject.put("vehicleNo", rs.getString("VehicleNo"));					
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("gmt", ddmmyyyy.format(yyyymmdd.parse(rs.getString("DATETIME"))));
				VehicleDetailsObject.put("drivername", driverName);
				VehicleDetailsObject.put("groupname", vehicleGroup);
				VehicleDetailsObject.put("ignition",ignitionStatus);
				VehicleDetailsObject.put("vehicleType", vehicleTypeName);
				VehicleDetailsObject.put("model", rs.getString("MODEL"));
				VehicleDetailsObject.put("ownerName", rs.getString("OWNER_NAME"));
				VehicleDetailsObject.put("status", rs.getString("STATUS"));
				VehicleDetailsObject.put("cashin", rs.getString("CASH_IN"));
				VehicleDetailsObject.put("cashout", rs.getString("CASH_OUT"));
				VehicleDetailsObject.put("cashbalance", rs.getString("CASH_BALANCE"));
				VehicleDetailsObject.put("drivermobile", rs.getString("DRIVER_MOBILE"));
				VehicleDetailsObject.put("direction", rs.getString("DIRECTION"));
				VehicleDetailsObject.put("speed", speedFinal);
				VehicleDetailsObject.put("temperature", temp);
				
				VehicleDetailsObject.put("LRNO", lrNo);
				VehicleDetailsObject.put("tripNo", tripNo);
				VehicleDetailsObject.put("routeName", routeName);
				VehicleDetailsObject.put("customerName", customerName);
				if(!rs.getString("ETHA").contains("1900")){
					ETHA = sdf.format(sdfDB.parse(rs.getString("ETHA")));
				}
				if(!rs.getString("ETA").contains("1900")){
					ETA = sdf.format(sdfDB.parse(rs.getString("ETA")));
				}
				VehicleDetailsObject.put("etaDest", ETA);
				VehicleDetailsObject.put("etaNextPt", ETHA);
				if(!rs.getString("ATD").contains("1900")){
					ATD = sdf.format(sdfDB.parse(rs.getString("ATD")));
				}
				VehicleDetailsObject.put("ATD", ATD);
				
			}
			if(processId != null){
				pstmt = con.prepareStatement(MapViewStatements.LIVE_VISION_HEADERS_BY_LABEL);
				pstmt.setString(1,processId);
				pstmt.setString(2,"OBD_Type");
				rs = pstmt.executeQuery();
				if(rs.next()){
					OBDFunctions obdFunction = new OBDFunctions();
					VehicleDetailsObject.put("obd", obdFunction.getVehicleDiagnosticDeatails(systemId, customerID, vehicleNo));
				}else{
					VehicleDetailsObject.put("obd","");
				}
			}else{
				VehicleDetailsObject.put("obd","");
			}
			VehicleDetailsArray.put(VehicleDetailsObject);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    DBConnection.releaseConnectionToDB(null, null, rsIntial);
		}
		return VehicleDetailsArray;
	
	}
	
	public JSONArray getDMGTripDetails(String vehicleNo,int clientId,int systemId) {

		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			VehicleDetailsArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");			
			VehicleDetailsObject = new JSONObject();				
//				pstmt = con.prepareStatement(MapViewStatements.GET_DMG_TRIP_DETAILS);
//				pstmt.setInt(1, systemId);
//				pstmt.setInt(2, clientId);
//				pstmt.setString(3, vehicleNo);
//				pstmt.setInt(4, systemId);
//				pstmt.setInt(5, clientId);
//				pstmt.setString(6, vehicleNo);
//				rs = pstmt.executeQuery();
//				if (rs.next()) {				
//					VehicleDetailsObject.put("tripNo", rs.getString("TRIP_NO"));
//					VehicleDetailsObject.put("startDate", rs.getString("START_TIME"));
//					VehicleDetailsObject.put("tripStaus", rs.getString("STATUS"));
//					VehicleDetailsArray.put(VehicleDetailsObject);				
//				}
//					VehicleDetailsArray = new JSONArray();
//					pstmt = con.prepareStatement(MapViewStatements.GET_DMG_TRIP_DETAILS_FRESH1);
//					pstmt.setInt(1, systemId);
//					pstmt.setInt(2, clientId);
//					pstmt.setString(3, vehicleNo);
//					pstmt.setInt(4, systemId);
//					pstmt.setInt(5, clientId);
//					pstmt.setString(6, vehicleNo);
//					pstmt.setInt(7, systemId);
//					pstmt.setInt(8, clientId);
//					pstmt.setString(9, vehicleNo);
//					pstmt.setInt(10, systemId);
//					pstmt.setInt(11, clientId);
//					pstmt.setString(12, vehicleNo);
//					pstmt.setInt(13, systemId);
//					pstmt.setInt(14, clientId);
//					pstmt.setString(15, vehicleNo);
//					rs = pstmt.executeQuery();
//					if (rs.next()) {				
//					VehicleDetailsObject.put("freshTripNo", rs.getString("TRIP_NO"));
//					VehicleDetailsObject.put("freshStartDate", rs.getString("START_TIME"));
//					VehicleDetailsObject.put("freshTripStatus", rs.getString("STATUS"));
//					VehicleDetailsObject.put("issuedDate", rs.getString("ISSUED_DATE"));
//					VehicleDetailsArray.put(VehicleDetailsObject);		
//			}
					pstmt = con.prepareStatement(MapViewStatements.GET_DMG_TRIP_DETAILS_FRESH1);
					pstmt.setInt(1, systemId);
					pstmt.setInt(2, clientId);
					pstmt.setString(3, vehicleNo);
					pstmt.setInt(4, systemId);
					pstmt.setInt(5, clientId);
					pstmt.setString(6, vehicleNo);
					pstmt.setInt(7, systemId);
					pstmt.setInt(8, clientId);
					pstmt.setString(9, vehicleNo);
					pstmt.setInt(10, systemId);
					pstmt.setInt(11, clientId);
					pstmt.setString(12, vehicleNo);
					pstmt.setInt(13, systemId);
					pstmt.setInt(14, clientId);
					pstmt.setString(15, vehicleNo);
					rs = pstmt.executeQuery();
					if(rs.next()){
						if(rs.getString("MINERAL").equals("Iron Ore(E-Auction)")){
							VehicleDetailsObject.put("tripNo", rs.getString("TRIP_NO"));
							VehicleDetailsObject.put("startDate", rs.getString("START_TIME"));
							VehicleDetailsObject.put("tripStaus", rs.getString("STATUS"));
							VehicleDetailsObject.put("netQty", rs.getString("NET_QTY"));
							VehicleDetailsObject.put("issuedDate", rs.getString("ISSUED_DATE"));
							VehicleDetailsArray.put(VehicleDetailsObject);		
						}else{
							VehicleDetailsObject.put("freshTripNo", rs.getString("TRIP_NO"));
							VehicleDetailsObject.put("freshStartDate", rs.getString("START_TIME"));
							VehicleDetailsObject.put("freshTripStatus", rs.getString("STATUS"));
							VehicleDetailsObject.put("issuedDate", rs.getString("ISSUED_DATE"));
							VehicleDetailsObject.put("netQty", rs.getString("NET_QTY"));
							VehicleDetailsArray.put(VehicleDetailsObject);		
						}
						
					}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	
	}
	
	public JSONArray getDMGMapViewVehiclesDetails(String vehicleNo,int clientId,int systemId) {

		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rsIntial = null;
		String ignition="";
		double speedFinal=0;
		String subscription="";
		String remainderDate="";
		try {
			VehicleDetailsArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");		
			HashMap <String,Double> vehTypeDistFactorMap = new HashMap <String,Double>();
			pstmt = con.prepareStatement(MapViewStatements.GET_VEHICLE_TYPE_DIST_FACTOR_MAP);
			rsIntial = pstmt.executeQuery();
        	while(rsIntial.next()){
        		vehTypeDistFactorMap.put(rsIntial.getString("VehicleTypeName"), rsIntial.getDouble("ConversionFactor"));
        	}
               	     		
			pstmt = con.prepareStatement(MapViewStatements.GET_DMG_MAP_VIEW_ASSET_DETAILS);
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,clientId);
			rs = pstmt.executeQuery();
			if (rs.next()) {				
				 String SpeedLimit=rs.getString("SPEED_LIMIT");
		            double distFactor = 1.0;		           
		            if(vehTypeDistFactorMap.get(rs.getString("VehicleType")) != null){
	        			distFactor = Double.parseDouble(vehTypeDistFactorMap.get(rs.getString("VehicleType")).toString());
	        		} 				
 				double speedLimit=Double.parseDouble(SpeedLimit);//getSpeedLimits(registrationNo,ldb.getClientId(),systemId,con,imageCon,pstmt,rs);commented by pooja
 				speedLimit = speedLimit * distFactor;
 				double speed = rs.getInt("SPEED");
     			speed = speed * distFactor;
     	
     			if(rs.getInt("IGNITION")==0 && speed  < speedLimit){     				
     				speed = 0;
     			}
     			else if(rs.getInt("IGNITION")==1 && speed  < speedLimit){     				 
     				speed = 0;
     			}
     			
     			double spd = Double.parseDouble(df.format(speed));
 				if (spd!=0) {
 					speedFinal=spd;
					} else {
						speedFinal=0;
					}
				
				if(rs.getInt("IGNITION")==1)
				{
					ignition="On";
				}
				else
				{
					ignition="Off";
				}
				if(!rs.getString("SUBSCRIPTION_VALIDITY").contains("1900"))
				{
					subscription=ddmmyyyy.format(yyyymmdd.parse(rs.getString("SUBSCRIPTION_VALIDITY")));
				}
				
				if(!rs.getString("REMINDER_DATE").contains("1900"))
				{
					remainderDate=ddmmyyyy.format(yyyymmdd.parse(rs.getString("REMINDER_DATE")));
				}				
				VehicleDetailsObject = new JSONObject();				
				VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("datetime", ddmmyyyy.format(yyyymmdd.parse(rs.getString("DATETIME"))));
				VehicleDetailsObject.put("driverName", rs.getString("DRIVER_NAME"));
				VehicleDetailsObject.put("ignition",ignition);
				VehicleDetailsObject.put("speed", speedFinal);
				VehicleDetailsObject.put("vehicleId", rs.getString("VEHICLE_ID"));
				VehicleDetailsObject.put("ownerName", rs.getString("OWNER_NAME"));
				VehicleDetailsObject.put("status", rs.getString("Status"));
				VehicleDetailsObject.put("subscriptionValidity", subscription);
				VehicleDetailsObject.put("remainderDate", remainderDate);
				VehicleDetailsArray.put(VehicleDetailsObject);				
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, null, rsIntial);
		}
		return VehicleDetailsArray;
	
	}

	/***************************************************************************************************************************************************
	 * Generic Live Vision List View 
	 ***************************************************************************************************************************************************/
	public ArrayList<Object> getLiveVisionListVehiclesDetails(int offmin, int userID, int customerID, int systemId,String language,String vehicleType,String listOfCustomer,int processID,int isLtsp,String category,boolean checkFDAS, int nonCommHrs) {
    //    System.out.println(" userID ==== "+userID+"  systemId ====== "+systemId);
		
		//Added condition for customer filter listOfCustomer
		if(listOfCustomer.equals("")){
			listOfCustomer = "All";
		}
		String customerFilter = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and g.REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
		
		
		boolean impreciseSetting = false;
		impreciseSetting = cf.CheckImpreciseSetting(userID, systemId);
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		List<String > liveVisionHeader= new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList < Object > finlist = new ArrayList < Object > ();
		
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		Date dt = new Date();
		Connection con = null,conLms=null;
		PreparedStatement pstmt = null,pstmtLms=null;
		ResultSet rs = null,rsLms=null,rsLiveVisionHeaders=null;;
		VehicleDetailsArray = new JSONArray();
		String tripName="";
		String tripStartDate="";
		double engineHRS1=0.0;
		double engineHRS2=0.0;
		String IOPort="";
		String ignition="";				
		double speedFinal=0;
		double idleTime=0;
		String acStatus="";
		double acHoursNew=0.0;
		double STOP=0.0;
		String STOPPAGE="";
		String boookingCustomer="";
		String containerNos="";
		String status="";	
		StringBuilder image=new StringBuilder("");
		String initionStatus=null;
		String driverName=null;
		String location=null;
		String vehicleTypeName=null;
		String vehicleGroup=null;
		
		String tripNo = null;
		String routeName = null;
		String lrNo = null;
		String trip_Customer = null;
		String temp_info_for_TCL = null;
		String set_Temp_limits_for_on_trip = null;
		
		String etp = null;
		String atp = null;
		String eta = null;
		String ata = null;
		String city = null;
		
		try {
			Properties properties = null;
			properties = ApplicationListener.prop;
			String vehicleImagePath = properties.getProperty("vehicleImagePath");
			String key = properties.getProperty("GoogleMapApiKey");
			con = DBConnection.getConnectionToDB("AMS");
			// If we are uploading new Telematics4uApp war file to KNG server then we need to comment the below conLms connection.
			conLms = DBConnection.getConnectionToDB("LMS");		
			HashMap vehTypeDistFactorMap = new HashMap();			
			Hashtable IOColumnNameTable = new Hashtable();
			IOColumnNameTable=getACIONumberForAllVehicle(con,pstmt,rs,systemId);
			String unit = cf.getUnitOfMeasure(systemId);
			if(language.equals("ar"))
			{
				getLanuage="LANG_ARABIC";
			}
			
			//customerFilter
			String customerFilterForGettingRegisteredVehicle = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and VehicleNo in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";
			
			pstmt = con.prepareStatement(MapViewStatements.GET_VEHICLE_TYPE_DIST_FACTOR_MAP);
        	rs = pstmt.executeQuery();
        	while(rs.next()){
        		vehTypeDistFactorMap.put(rs.getString("VehicleTypeName"), rs.getDouble("ConversionFactor"));
        	}        
        	
        	if(isLtsp==0 || customerID==0){
	           	 pstmt=con.prepareStatement(MapViewStatements.GET_REGISTERED_VEHICLE_LIST_TYPE_FOR_CLIENT.concat(customerFilterForGettingRegisteredVehicle));
	           	 pstmt.setInt(1,userID);
	       		 pstmt.setInt(2,systemId);
	       		 pstmt.setInt(3,systemId);
	       		 pstmt.setInt(4, customerID);
          }
    	 else{
    		//customerFilter
 			String customerFilterForActive = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and VehicleNo in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";

	             pstmt=con.prepareStatement(MapViewStatements.SELECT_REGISTRATION_NO_FROM_USER_VEHICLE_TYPE_WITH_ACTIVE.concat(customerFilterForActive));
	       		 pstmt.setInt(1,userID);
	       		 pstmt.setInt(2,systemId);
	       		 pstmt.setInt(3,systemId);
	       		 pstmt.setInt(4, customerID);
         }
			rs = pstmt.executeQuery();
			StringBuffer sb=new StringBuffer();
			int a=0;
			while(rs.next()){
				String vehicleNo1 = rs.getString("VehicleNo");			
			
			    if(a==0){
			    	sb.append("'"+vehicleNo1+"'");
			    	a=1;
			    }else{
			    	 sb.append(",'"+vehicleNo1+"'");
			    }			   
		    }  
			 String regList=sb.toString();
			 if(regList.equals("")){
				 regList="''";
			}
			headersList.add(cf.getLabelFromDB("SLNO", language));
			pstmt=con.prepareStatement(MapViewStatements.LIVE_VISION_HEADERS);
			pstmt.setInt(1, processID);
			rsLiveVisionHeaders=pstmt.executeQuery();			
			while(rsLiveVisionHeaders.next()){				
				liveVisionHeader.add(rsLiveVisionHeaders.getString("DATA_FIELD_LABEL_ID"));
				if(rsLiveVisionHeaders.getString("DATA_FIELD_LABEL_ID").equalsIgnoreCase("Speed"))
				{
					headersList.add(rsLiveVisionHeaders.getString(getLanuage)+"("+unit+"/hr)");	
				}else{
				    headersList.add(rsLiveVisionHeaders.getString(getLanuage));
				}
	        }
			
			if(!checkFDAS){
				int index=liveVisionHeader.indexOf("Fuel_Guage");
				if(index!=-1){
				liveVisionHeader.remove(index);
				headersList.remove(index+1);
				}
			}
	        int count = 0;
	        int vehicleCount = 0;
			
	        // This is for getting all vehicle counts for LTSP
	       
	      //customerFilter
 			String customerFilterForLTSP = listOfCustomer.equalsIgnoreCase("ALL") ? "" : " and REGISTRATION_NO in (select ASSET_NUMBER from AMS.dbo.TRACK_TRIP_DETAILS where STATUS='OPEN' and TRIP_CUSTOMER_ID in ( " + listOfCustomer + " ))";

	        if(isLtsp== 0 && customerID==0){
	        	pstmt = con.prepareStatement(OBDStatements.GET_VEHICLE_COUNT_NEW.concat(customerFilterForLTSP));
	        }else{
	        	pstmt = con.prepareStatement(OBDStatements.GET_VEHICLE_COUNT_NEW.concat(customerFilterForLTSP) +" and a.CLIENTID="+customerID);
	        }	
			pstmt.setInt(1, systemId);	
			pstmt.setInt(2,userID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				vehicleCount = rs.getInt("vehicleCount");
			}
			
			
	        if(vehicleType.equalsIgnoreCase("all")){	
	        	// System.out.println(" 1111111111111111111111111 ");
	        	 if(isLtsp== 0 && customerID==0){
	        		 if(impreciseSetting == true){	
	        		// System.out.println(" imprecise true!!!!!!!!!!!");
		        	 pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD_FOR_IMPRECISE_LOCATION.concat(customerFilter).concat(" order by g.GPS_DATETIME desc "));
	        		 }else{
	        		 pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD.concat(customerFilter).concat(" order by g.GPS_DATETIME desc "));
	        		 }
	        		    pstmt.setInt(1, offmin);
	        		 	pstmt.setInt(2, offmin);
	        		 	pstmt.setInt(3, offmin);
	        		 	pstmt.setInt(4, offmin);
	        		 	pstmt.setInt(5, systemId);
	        		 	pstmt.setInt(6, userID);
	               
	        	 }else{	  
	        		 if(impreciseSetting == true){
	        	  //  System.out.println(" imprecise true!!!!!!!!!!!");
			        pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS_FOR_IMPRECISE_LOCATION.concat(customerFilter).concat(" where g.REGISTRATION_NO in ("+regList+" )  order by g.GPS_DATETIME desc"));
                    }else{
	        		pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS.concat(customerFilter).concat(" where g.REGISTRATION_NO in ("+regList+" )  order by g.GPS_DATETIME desc"));
                    }
	        		 	 pstmt.setInt(1, offmin);
	        		 	 pstmt.setInt(2, offmin);
	        		 	 pstmt.setInt(3, offmin);
	        		 	 pstmt.setInt(4, offmin);
	        	 }        	 
				 }
                 else if (vehicleType.equalsIgnoreCase("comm")) {
                	// System.out.println(" 222222222222222222222222222 ");
                	 if(isLtsp==0 && customerID==0){
                		if(impreciseSetting == true){
                	//	System.out.println(" imprecise true!!!!!!!!!!!");
               		    pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD_FOR_IMPRECISE_LOCATION.concat(customerFilter).concat( " and DATEDIFF(hh,g.GMT,getutcdate())< "+nonCommHrs+" and g.LOCATION !='No GPS Device Connected' order by g.GPS_DATETIME desc "));
                		}else{
                   		 pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD.concat(customerFilter).concat( " and DATEDIFF(hh,g.GMT,getutcdate())< "+nonCommHrs+" and g.LOCATION !='No GPS Device Connected' order by g.GPS_DATETIME desc "));
	
                		}
                		 pstmt.setInt(1, offmin);
		        		 pstmt.setInt(2, offmin);
		        		 pstmt.setInt(3, offmin);
		        		 pstmt.setInt(4, offmin);
		        		 pstmt.setInt(5, systemId);
		        		 pstmt.setInt(6, userID);
    	                
                	 }else{   
                		 if(impreciseSetting == true){
                     	//	System.out.println(" imprecise true!!!!!!!!!!!");
                   		    pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS_FOR_IMPRECISE_LOCATION.concat(customerFilter).concat(" where g.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,g.GMT,getutcdate())< "+nonCommHrs+" and g.LOCATION !='No GPS Device Connected' order by g.GPS_DATETIME desc "));
                     		}else{
                       		 pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS.concat(customerFilter).concat(" where g.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,g.GMT,getutcdate())< "+nonCommHrs+" and g.LOCATION !='No GPS Device Connected' order by g.GPS_DATETIME desc "));	
                     		}
                		 	 pstmt.setInt(1, offmin);
    	        		 	 pstmt.setInt(2, offmin);
    	        		 	 pstmt.setInt(3, offmin);
    	        		 	 pstmt.setInt(4, offmin);
                	 }
   				 } else if (vehicleType.equalsIgnoreCase("noncomm")) {
   					//System.out.println("33333333333333333333333333333");
   					 	if(isLtsp==0 && customerID==0){
   					 	if(impreciseSetting == true){
   					 	//  System.out.println(" imprecise true!!!!!!!!!!!");
     					  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD_FOR_IMPRECISE_LOCATION.concat(customerFilter).concat(" and DATEDIFF(hh,g.GMT,getutcdate()) >= "+nonCommHrs+" and g.LOCATION !='No GPS Device Connected' order by g.GPS_DATETIME desc "));
   					 	  }else{
   	   					  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD.concat(customerFilter).concat(" and DATEDIFF(hh,g.GMT,getutcdate()) >= "+nonCommHrs+" and g.LOCATION !='No GPS Device Connected' order by g.GPS_DATETIME desc "));  
   					 	  }	
   					    pstmt.setInt(1, offmin);
	        		 	pstmt.setInt(2, offmin);
	        		 	pstmt.setInt(3, offmin);
	        		 	pstmt.setInt(4, offmin);
	        		 	pstmt.setInt(5, systemId);
	        		 	pstmt.setInt(6, userID);
   					 	}else{
   					 	if(impreciseSetting == true){
   					 	//  System.out.println(" imprecise true!!!!!!!!!!!");
     					 	pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS_FOR_IMPRECISE_LOCATION.concat(customerFilter).concat(" where g.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,g.GMT,getutcdate()) >= "+nonCommHrs+" and g.LOCATION !='No GPS Device Connected' order by g.GPS_DATETIME desc "));
   					 	  }else{
   	   					 	pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS.concat(customerFilter).concat(" where g.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,g.GMT,getutcdate()) >= "+nonCommHrs+" and g.LOCATION !='No GPS Device Connected' order by g.GPS_DATETIME desc "));  
   					 	  }	
   					 	pstmt.setInt(1, offmin);
	        		 	pstmt.setInt(2, offmin);
	        		 	pstmt.setInt(3, offmin);
	        		 	pstmt.setInt(4, offmin);
   					 	}
   					 
   				 } else if (vehicleType.equalsIgnoreCase("noGPS")) {
   				//	System.out.println(" 44444444444444444444444444 ");
   					 		if(isLtsp==0 && customerID==0){
   					 		if(impreciseSetting == true){
   					 	//	  System.out.println(" imprecise true!!!!!!!!!!!");
    					 	  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD_FOR_IMPRECISE_LOCATION.concat(customerFilter).concat(" and g.LOCATION ='No GPS Device Connected' order by g.GPS_DATETIME desc "));
   					 		  }else{
   	   					 	  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD.concat(customerFilter).concat(" and g.LOCATION ='No GPS Device Connected' order by g.GPS_DATETIME desc "));
   					 		  }	
   					 		 pstmt.setInt(1, offmin);
   		        		 	 pstmt.setInt(2, offmin);
   		        		 	 pstmt.setInt(3, offmin);
   		        		 	 pstmt.setInt(4, offmin);
   		        		 	 pstmt.setInt(5, systemId);
   		        		 	 pstmt.setInt(6, userID);
   					 		}else{    					 			
   					 		if(impreciseSetting == true){
   					 	//	  System.out.println(" imprecise true!!!!!!!!!!!");
    		   				  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION ='No GPS Device Connected'").concat(customerFilter)+" order by g.GPS_DATETIME desc ");  
   					 		  }else{
    		   				  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION ='No GPS Device Connected' ").concat(customerFilter)+" order by g.GPS_DATETIME desc ");  
   					 		  }	 			
   		   						 pstmt.setInt(1, offmin);
   		   						 pstmt.setInt(2, offmin);
   		   						 pstmt.setInt(3, offmin);
   		   					     pstmt.setInt(4, offmin);
   					 		}
   					
   				 }else if (vehicleType.equalsIgnoreCase("Running")) {
   				//	System.out.println("55555555555555555555555");
				 		if(isLtsp==0 && customerID==0){
				 			if(impreciseSetting == true){
				 		//	System.out.println(" imprecise true!!!!!!!!!!!");
 					 		 pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD_FOR_IMPRECISE_LOCATION.concat(customerFilter).concat(" and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=1 and g.SPEED>isNull(g.SPEED_LIMIT,10)) order by g.GPS_DATETIME desc "));	  
				 				  }else{
			  				pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD.concat(customerFilter).concat(" and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=1 and g.SPEED>isNull(g.SPEED_LIMIT,10)) order by g.GPS_DATETIME desc "));	  
				 				  }
  					 		 pstmt.setInt(1, offmin);
  		        		 	 pstmt.setInt(2, offmin);
  		        		 	 pstmt.setInt(3, offmin);
  		        		 	 pstmt.setInt(4, offmin);
  		        		 	 pstmt.setInt(5, systemId);
  		        		 	 pstmt.setInt(6, userID);
  					 		}else{
  					 			if(impreciseSetting == true){
  					 			//  System.out.println(" imprecise true!!!!!!!!!!!");
   		   						  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=1 and g.SPEED>isNull(g.SPEED_LIMIT,10)) ").concat(customerFilter)+ " order by g.GPS_DATETIME desc ");
  					 			  }else{
  	  		   					  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=1 and g.SPEED>isNull(g.SPEED_LIMIT,10))").concat(customerFilter)+ " order by g.GPS_DATETIME desc ");
  					 			  }
  		   						 pstmt.setInt(1, offmin);
  		   						 pstmt.setInt(2, offmin);
  		   						 pstmt.setInt(3, offmin);
  		   					     pstmt.setInt(4, offmin);
  					 		}
  					
  				 }else if (vehicleType.equalsIgnoreCase("Stoppage")) {
  				//	System.out.println(" 666666666666666666666666666 ");
				 		if(isLtsp==0 && customerID==0){				 			
				 			if(impreciseSetting == true){
				 				//  System.out.println(" imprecise true!!!!!!!!!!!");
					  		pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD_FOR_IMPRECISE_LOCATION.concat(customerFilter).concat(" and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=0 and g.SPEED<=isNull(g.SPEED_LIMIT,10)) order by g.GPS_DATETIME desc "));	  	  
				 				  }else{
			  				 pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD.concat(customerFilter).concat(" and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=0 and g.SPEED<=isNull(g.SPEED_LIMIT,10)) order by g.GPS_DATETIME desc "));	  
				 				  }				 			
  					 		 pstmt.setInt(1, offmin);
  		        		 	 pstmt.setInt(2, offmin);
  		        		 	 pstmt.setInt(3, offmin);
  		        		 	 pstmt.setInt(4, offmin);
  		        		 	 pstmt.setInt(5, systemId);
  		        		 	 pstmt.setInt(6, userID);
  					 		}else{
  					 			if(impreciseSetting == true){
  					 			//  System.out.println(" imprecise true!!!!!!!!!!!");
   		   						 pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=0 and g.SPEED<=isNull(g.SPEED_LIMIT,10)) ").concat(customerFilter)+ " order by g.GPS_DATETIME desc ");  
  					 			  }else{
  	  		   					pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=0 and g.SPEED<=isNull(g.SPEED_LIMIT,10)) ").concat(customerFilter)+ " order by g.GPS_DATETIME desc ");  
  					 			  }
  		   						 pstmt.setInt(1, offmin);
  		   						 pstmt.setInt(2, offmin);    
  		   						 pstmt.setInt(3, offmin);
  		   					     pstmt.setInt(4, offmin);
  					 		}
  					
  				 }else if (vehicleType.equalsIgnoreCase("Idle")) {
  					//System.out.println(" 77777777777777777777777777777 ");
				 		if(isLtsp==0 && customerID==0){
				 			if(impreciseSetting == true){
				 				//  System.out.println(" imprecise true!!!!!!!!!!!");
		  					 	  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD_FOR_IMPRECISE_LOCATION.concat(customerFilter).concat(" and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=1 and g.SPEED<=isNull(g.SPEED_LIMIT,10)) order by g.GPS_DATETIME desc "));
				 				  }else{
			  					  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_LTSP_DASHBOARD.concat(customerFilter).concat(" and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=1 and g.SPEED<=isNull(g.SPEED_LIMIT,10)) order by g.GPS_DATETIME desc "));	  
				 				  }
  					 		 pstmt.setInt(1, offmin);
  		        		 	 pstmt.setInt(2, offmin);
  		        		 	 pstmt.setInt(3, offmin);
  		        		 	 pstmt.setInt(4, offmin);
  		        		 	 pstmt.setInt(5, systemId);
  		        		 	 pstmt.setInt(6, userID);
  					 		}else{   
  					 			if(impreciseSetting == true){
  					 			//  System.out.println(" imprecise true!!!!!!!!!!!");
   		   						  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=1 and g.SPEED<=isNull(g.SPEED_LIMIT,10)) ").concat(customerFilter)+ " order by g.GPS_DATETIME desc "); 
  					 			  }else{
  	  		   					  pstmt = con.prepareStatement(MapViewStatements.GET_LIVE_VISION_VIEW_ASSET_DETAILS.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION !='No GPS Device Connected' and (g.IGNITION=1 and g.SPEED<=isNull(g.SPEED_LIMIT,10)) ").concat(customerFilter)+ " order by g.GPS_DATETIME desc ");
  					 			  }
  		   						 pstmt.setInt(1, offmin);
  		   						 pstmt.setInt(2, offmin);
  		   						 pstmt.setInt(3, offmin);
  		   					     pstmt.setInt(4, offmin);
  					 		}
  					
  				 }else if (category!=null && category.equals("stoppage")){
  					//System.out.println(" 88888888888888888888888888888 ");
  					if(impreciseSetting == true){
  					//  System.out.println(" imprecise true!!!!!!!!!!!");
 						pstmt = con.prepareStatement(MapViewStatements.GET_STOPPAGE_VEHICLE_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,g.GMT,getutcdate()) < 6 and g.CATEGORY='stoppage'").concat(customerFilter)+"  order by g.GPS_DATETIME desc ");	 
  					  }else{
	   				   pstmt = con.prepareStatement(MapViewStatements.GET_STOPPAGE_VEHICLE_DETAILS.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,g.GMT,getutcdate()) < 6 and g.CATEGORY='stoppage' ").concat(customerFilter)+ " order by g.GPS_DATETIME desc ");	 
  					  }
		   						pstmt.setInt(1, offmin);
		   						pstmt.setInt(2, offmin);
		   						pstmt.setInt(3, offmin);
		   						pstmt.setInt(4, offmin);
   	   				 }else if (category!=null && category.equals("running")){
   	   			//	System.out.println(" 9999999999999999999999999999 ");
   	   			     if(impreciseSetting == true){
   	   		      //   System.out.println(" imprecise true!!!!!!!!!!!");
   					 	pstmt = con.prepareStatement(MapViewStatements.GET_RUNNING_VEHICLE_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where g.REGISTRATION_NO in ("+regList+" )   and g.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,g.GMT,getutcdate()) < 6 and g.CATEGORY='running' ").concat(customerFilter)+" order by g.GPS_DATETIME desc ");	 
   	   		         }else{
	   					 	pstmt = con.prepareStatement(MapViewStatements.GET_RUNNING_VEHICLE_DETAILS.concat(" where g.REGISTRATION_NO in ("+regList+" )   and g.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,g.GMT,getutcdate()) < 6 and g.CATEGORY='running' ").concat(customerFilter)+" order by g.GPS_DATETIME desc ");	 
   	   		          }
	   	   					 	pstmt.setInt(1, offmin);
	   	   					 	pstmt.setInt(2, offmin);
	   	   					 	pstmt.setInt(3, offmin);
	   	   					    pstmt.setInt(4, offmin);
   	       				 }else if (category!=null && category.equals("idle")){	
   	       			//	System.out.println(" 1000000000000000000000000000000000000 ");
   	       			    if(impreciseSetting == true){
   	       		    //    System.out.println(" imprecise true!!!!!!!!!!!");
	       					 pstmt = con.prepareStatement(MapViewStatements.GET_IDLE_VEHICLE_DETAILS_FOR_IMPRECISE_LOCATION.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,g.GMT,getutcdate()) < 6 and g.CATEGORY='idle' ").concat(customerFilter)+" order by g.GPS_DATETIME desc ");		 
   	       		        }else{
  	       					 pstmt = con.prepareStatement(MapViewStatements.GET_IDLE_VEHICLE_DETAILS.concat(" where g.REGISTRATION_NO in ("+regList+" )  and g.LOCATION !='No GPS Device Connected' and DATEDIFF(hh,g.GMT,getutcdate()) < 6 and g.CATEGORY='idle' ").concat(customerFilter)+" order by g.GPS_DATETIME desc ");		 
   	       		         }
	   	       					 pstmt.setInt(1, offmin);
	   	       					 pstmt.setInt(2, offmin);
	   	       					 pstmt.setInt(3, offmin);
	   	       				     pstmt.setInt(4, offmin);
   	           				 }
   	       				 else if(category!=null && category.equals("satCount")){  
   	       			//	System.out.println(" 11111111111111111111111111111111111 ");
   	       			if(impreciseSetting == true){
   	       	//	  System.out.println(" imprecise true!!!!!!!!!!!");
   					 pstmt = con.prepareStatement(MapViewStatements.GET_POOR_SAT_VISIBILITY_FOR_IMPRECISE_LOCATION.concat(" where g.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,g.INVALID_UPDATETIME,getutcdate()) <6 and  g.VALID='N' and g.INVALID_UPDATETIME is not null ").concat(customerFilter)+" order by g.GPS_DATETIME desc ");		 
   	       		  }else{
       				 pstmt = con.prepareStatement(MapViewStatements.GET_POOR_SAT_VISIBILITY.concat(" where g.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,g.INVALID_UPDATETIME,getutcdate()) <6 and  g.VALID='N' and g.INVALID_UPDATETIME is not null ").concat(customerFilter)+" order by g.GPS_DATETIME desc ");		 
   	       		  }
	   	       					 pstmt.setInt(1, offmin);
	   	       					 pstmt.setInt(2, offmin);
	   	       					 pstmt.setInt(3, offmin);
	   	       				     pstmt.setInt(4, offmin);
   	           					 
   	           				 }
	        double distFactor =cf.getUnitOfMeasureConvertionsfactor(systemId);// 1.0; //default distance unit is kms
	         final long startTime = System.currentTimeMillis();
				 rs = pstmt.executeQuery();				 
				 final long endTime = System.currentTimeMillis();   
				//	System.out.println("Total time taken to fetch the records inside function:  " + (endTime - startTime)/1000 );
				 while (rs.next())
				 {      
					    VehicleDetailsObject = new JSONObject();
						ArrayList < Object > informationList = new ArrayList < Object > ();
			            ReportHelper reporthelper = new ReportHelper();
			            count++;
			            
			            String SpeedLimit=rs.getString("SPEED_LIMIT");			           
		        		if(vehTypeDistFactorMap.get(rs.getString("VehicleType")) != null){
		        			distFactor = Double.parseDouble(vehTypeDistFactorMap.get(rs.getString("VehicleType")).toString());
		        		}			          
        				
        				double speedLimit=Double.parseDouble(SpeedLimit);//getSpeedLimits(registrationNo,ldb.getClientId(),systemId,con,imageCon,pstmt,rs);commented by pooja
        				/* convert speed limit from kms to proper conversion unit of that vehicle based on type of the vehicle */
        				speedLimit = speedLimit * distFactor;
        				double speed = rs.getInt("SPEED");
            			/* get speed from kms value  to proper unit value based on the type of vehicle */
            			speed = speed * distFactor;
            			
            			/*.................deciding stop or idle or moving...........................*/
            			boolean stopFlag = false;
            			boolean idleFlag = false;
            			//System.out.println("ign "+ignition+" speed "+speed+" speedlim "+speedLimit);
            			if(rs.getInt("IGNITION")==0){
            				 stopFlag = true;
            				speed = 0;
            			}
            			else if(rs.getInt("IGNITION")==1 && speed  <= speedLimit){
            				 idleFlag = true;
            				speed = 0;
            			}
            			
            			double spd = Double.parseDouble(df.format(speed));
        				if (spd > 0) {
        					speedFinal=spd;
						} else {
							speedFinal=0;
						}
			            if(rs.getInt("IGNITION")==1)
						{
							ignition="On";
						}
						else
						{
							ignition="Off";
						}
						
						STOPPAGE= rs.getString("StopIdle");
						if(stopFlag==true){
							STOP=stoppageTime(STOPPAGE);
						}
						if(idleFlag==true){
							idleTime=idleTime(STOPPAGE);
						}
						
                        
					//********************* Status  *******************************//
						
						if(rs.getString("STATUS")!=null){
							String vehicleStatus = rs.getString("STATUS");
							if (vehicleStatus.equals("")){
								vehicleStatus = "Vehicle Available";
							}
							String hubArrDepTime="";
							if(rs.getString("HUBNAME")!=null && !rs.getString("HUBNAME").equals("")){
								
								if(rs.getString("HUBDATETIME")!=null)
								{
									hubArrDepTime=changeDateFormat(rs.getString("HUBDATETIME"));
								//	status=	rs.getString("HUBNAME")+" : "+rs.getString("STATUS")+" AT "+hubArrDepTime;
									status=	rs.getString("HUBNAME")+" : "+vehicleStatus+" AT "+hubArrDepTime;
								}
								
							}else{							
							status=vehicleStatus;//rs.getString("STATUS");
							}
						}
							
					//************************for system id=77 **********************************//				
					//This block is for trip_name and trip_start_date functionality
					/*if (systemId == 77) {
						pstmtLms = conLms.prepareStatement(MapViewStatements.GET_TRIP_DETAILS);
						pstmtLms.setString(1, rs.getString("VehicleNo"));
						pstmtLms.setInt(2, customerID);
						pstmtLms.setInt(3, systemId);
						rsLms = pstmtLms.executeQuery();
						String tripid = "";
						String chartid = "";
						String RouteNameStr = "";
						String customer = "";
						String containerNo = "";
						while (rsLms.next()) {
							tripid = rsLms.getString("TripId");
							chartid = rsLms.getString("ChartId");
							if (rsLms.getString("RouteName") != null) {
								tripName = rsLms.getString("RouteName");
							}
							tripStartDate = rsLms.getString("StartTime");
							if (rsLms.getString("RouteNameStr") != null) {
								RouteNameStr = rsLms.getString("RouteNameStr");
							}
							if (tripName.equalsIgnoreCase("") || tripName.equalsIgnoreCase("0")) {
								tripName = RouteNameStr;
	
							}
						}
						customer = "";
						containerNo = "";
						pstmtLms = conLms.prepareStatement(MapViewStatements.GET_BOOKING_CUSTOMER);
						pstmtLms.setString(1, tripid);
						pstmtLms.setString(2, chartid);
						pstmtLms.setInt(3, customerID);
						rsLms = pstmtLms.executeQuery();
						while (rsLms.next()) {
							customer = rsLms.getString("Customer") + ",";
							containerNo = rsLms.getString("ContainerNo") + ",";
						}
						if (customer != null && !customer.equalsIgnoreCase("")) {
							customer = customer.substring(0, customer.length() - 1);
							containerNo = containerNo.substring(0,containerNo.length()-1);
						}
						if (rsLms != null) {
							rsLms.close();
						}
						if (pstmtLms != null) {
							pstmtLms.close();
						}
						if (tripName != null) {
	
						} else {
							tripName = "";
						}
	
						SimpleDateFormat simpleDateFormatYYYY = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
						SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
						SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	
						if (tripStartDate != null && !tripStartDate.equals("")) {
							java.util.Date date = simpleDateFormatddMMYYYYDB.parse(tripStartDate);
							tripStartDate = simpleDateFormatYYYY.format(date);
							tripStartDate = cf.AddOffsetToGmt(tripStartDate, offmin);
							java.util.Date date1 = simpleDateFormatYYYY.parse(tripStartDate);
							tripStartDate = simpleDateFormatddMMYY.format(date1);
							String substr = tripStartDate.substring(6, 10);
							if (substr.equals("1900")) {
								tripStartDate = "";
							}
						} else {
							tripStartDate = "";
						}
	
						if (tripStartDate != null) {
	
						} else {
							tripStartDate = "";
						}
						if (customer != null) {
							boookingCustomer = customer;
							containerNos = containerNo;
							if (!customer.equals("")) {
								status = "On Trip";
							}
						} else {
							boookingCustomer = "";
							containerNos = "";
						}
					}*/
					if(systemId == 15){
						SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
						tripName=rs.getString("TRIP_NO");
						if(rs.getString(("VALIDITY_DATE")).contains("1900")){
							tripStartDate="";
						}else{
							tripStartDate=simpleDateFormatddMMYY.format(rs.getTimestamp(("VALIDITY_DATE")));
						}
					}
									
					//********************AC STATUS ***************************//	
					 if(IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+47) != null){
   					 boolean acOn = getACStatusForVehicle(rs.getString("VehicleNo"),IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+47).toString(),rs.getInt("IO3"),rs.getInt("IO4"),rs.getInt("IO5"),rs.getInt("IO6"),rs.getInt("IO7"));
   					 if(acOn == true){
   						   acHrsCheck = true;
   						   acStatus="On";
   					   }
   					   else{
   						   acStatus="Off";
   						   acHrsCheck = false;
   					   }
   				   }
   				   
					//**************************AC HOURS********************************//
					if(rs.getInt("ACHOURS")!=0 && rs.getString("ACHOURS")!=null && rs.getInt("ACHOURS")>0) 
					{
					acHoursNew=getAcHours(rs.getInt("ACHOURS"),acHrsCheck);	
					}	
					HashMap<Enum, String> tripInfo =null;
					//if(systemId == 268) {
						// tripInfo = getNewLiveVisionListVehiclesDetails(con , rs.getString("VehicleNo"), offmin,status);
						 
					//}	
					//*********** Adding data to for grid and excel based on live vision headers  ***************************/
					
					 informationList.add(count);
			            VehicleDetailsObject.put("slnoIndex", count);			        	
			            for(String header:liveVisionHeader){
			            	switch (LiveVisionHeaders.valueOf(header)) {
			            	
			            	case AC :					informationList.add(acStatus);
														VehicleDetailsObject.put("acindex", acStatus);
														break;
													
			            	case AC_HOURS:				informationList.add(acHoursNew);
														VehicleDetailsObject.put("achoursindex", acHoursNew);
														break;
							// Remove this comment block for border status cloumn after adding in query.						
			           /* 	case Border_Status:			informationList.add(rs.getString("BorderStatus"));
				            							VehicleDetailsObject.put("borderstatusindex", rs.getString("BorderStatus"));	
				            							break;*/
				            						
			            	case Customer_Name:			informationList.add(rs.getString("CLIENTNAME"));
			            								VehicleDetailsObject.put("customernameindex", rs.getString("CLIENTNAME"));	
			            								break;
			            							
			            	case Date_Time:       		dt = rs.getTimestamp("DATETIME");
			            								informationList.add(sdfyyyymmddhhmmss.format(dt));
			            								VehicleDetailsObject.put("datetimeindex", sdfyyyymmddhhmmss.format(dt));
			            								break;
			            							
			            	case Door_Status:			if(IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+38) != null){
			  					   							boolean acOn = getACStatusForVehicle(rs.getString("VehicleNo"),IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+38).toString(),rs.getInt("IO3"),rs.getInt("IO4"),rs.getInt("IO5"),rs.getInt("IO6"),rs.getInt("IO7"));
			  					   								if(acOn == true)
			  					   									IOPort="Closed";
			  					   									else IOPort="Open";
			            									}
			            								informationList.add(IOPort);
														VehicleDetailsObject.put("doorstatusindex", IOPort);
														break;
													
			            	case Driver_Name:			driverName=null;
			            								if(language.equals("ar") && !rs.getString("DRIVER_NAME").equals("")){
			            									driverName=LocationLocalization.getLocationLocalization(rs.getString("DRIVER_NAME"), language);
			            									}else{
			            										driverName=rs.getString("DRIVER_NAME");
			            									}
			            								informationList.add(driverName);
			            								VehicleDetailsObject.put("drivernameindex", driverName);
			            								break;
			            							
			            	case Driver_Number:			informationList.add(rs.getString("DRIVER_MOBILE"));
				            							VehicleDetailsObject.put("drivernumberindex", rs.getString("DRIVER_MOBILE"));
				            							break;
				            						
			            	case Engine_2_Hours:		if(rs.getString("ENGINEHOURS2")!=null){
			            		
														engineHRS2=rs.getFloat("ENGINEHOURS2");
														engineHRS2=getEngineHours(engineHRS2);
														}
			            								informationList.add(engineHRS2);
			            								VehicleDetailsObject.put("engine2hoursindex", engineHRS2);	
			            								break;
			            							
			            	case Engine_Hours:			if(rs.getString("ENGINEHOURS1")!=null){
			            		
														engineHRS1=rs.getFloat("ENGINEHOURS1");
														engineHRS1=getEngineHours(engineHRS1);
														}
			            								informationList.add(engineHRS1);
			            								VehicleDetailsObject.put("enginehoursindex", engineHRS1);	
			            								break;
			            							
			            	case GMT:					dt = rs.getTimestamp("GMT");
				            							informationList.add(sdfyyyymmddhhmmss.format(dt));					          
				            							VehicleDetailsObject.put("gmtindex", sdfyyyymmddhhmmss.format(dt));		
				            							break;
				            						
			            	case IDLETIME_ALERT:		informationList.add(idleTime);
			            								VehicleDetailsObject.put("idletimeindex", idleTime);
			            								break;
			            							
			            	case Ignition:				initionStatus=null;
			            								if(language.equals("ar")){
			            									initionStatus=LocationLocalization.getApplicationResourcesValuesForArabic(ignition);
			            								}else{
			            									initionStatus=ignition;
			            								}			            								
			            								informationList.add(initionStatus);
				            							VehicleDetailsObject.put("ignitionindex", initionStatus);	
				            							break;
				            						
			            	case Ignition_2:			String ignition2="";
														if(IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+59) != null){								   
															boolean acOn = getACStatusForVehicle(rs.getString("VehicleNo"),IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+59).toString(),rs.getInt("IO3"),rs.getInt("IO4"),rs.getInt("IO5"),rs.getInt("IO6"),rs.getInt("IO7"));
								 								if(acOn == true){
																	ignition2="ON"; 
																	}
																else{
																	ignition2="OFF";  
																}
															}
															else{
																ignition2="OFF";
															}
														informationList.add(ignition2);
														VehicleDetailsObject.put("ignition2index", ignition2);		
														break;
			            							
			            	case Location:				location=null;
			            								if(language.equals("ar") && !rs.getString("LOCATION").equals("")){
			            									location=LocationLocalization.getAppendLocationLocalization(rs.getString("LOCATION"), language);
			            								}else{
			            									location=rs.getString("LOCATION");
			            								}
			            								informationList.add(location);
			            								VehicleDetailsObject.put("locationindex", location);
			            								break;
			            							
			            	case Owner_Name:			informationList.add(rs.getString("OWNER_NAME"));
				            							VehicleDetailsObject.put("ownernameindex", rs.getString("OWNER_NAME"));	
				            							break;
				            						
			            	case Remarks:          		informationList.add(rs.getString("REMARKS"));
			            								VehicleDetailsObject.put("remarksindex", rs.getString("REMARKS"));	
			            								break;
			            							
			            	case Speed:					informationList.add(speedFinal);
			            								VehicleDetailsObject.put("speedindex", speedFinal);	
			            								break;
			            							
			            	case Status:				informationList.add(status);
						    							VehicleDetailsObject.put("statusindex", status);
						    							break;
						    						
			            	case STOPPAGE_TIME_ALERT: 	informationList.add(STOP);
				            							VehicleDetailsObject.put("stoppagetimeindex", STOP);  	
				            							break;
				            							
			            	case TAXIMETER:				String taxiMeterStatus="";
			            								if(IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+64) != null)	{
														taxiMeterStatus=getTaxiMeterStatusForVehicle(rs.getString("VehicleNo"),IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+64).toString(),rs.getInt("IO3"),rs.getInt("IO4"),rs.getInt("IO5"),rs.getInt("IO6"),rs.getInt("IO7"));
															if((taxiMeterStatus.equals("MeterOn") && ignition == null) || (taxiMeterStatus.equals("MeterOn") && ignition.equals("Off"))){
																	taxiMeterStatus="MeterOff";
															}
														}	
			            								informationList.add(taxiMeterStatus);
														VehicleDetailsObject.put("taximeterindex", taxiMeterStatus);	
														break;
														
			            	case Trip_Name:				informationList.add(tripName);
				            							VehicleDetailsObject.put("tripnameindex", tripName);
				            							break;
				            							
			            	case Trip_Start_Date:       informationList.add(tripStartDate);
				            							VehicleDetailsObject.put("tripstartdateindex", tripStartDate); 		
				            							break;
				            							
			            	case Vehicle_Group:  		vehicleGroup=null;
			            								if(language.equals("ar") && !rs.getString("GROUP_NAME").equals("")){
			            									vehicleGroup=LocationLocalization.getApplicationResourcesValuesForArabicNew(rs.getString("GROUP_NAME"));
			            								}else{
			            									vehicleGroup=rs.getString("GROUP_NAME");
			            								}			            									
			            								informationList.add(vehicleGroup);
			            								VehicleDetailsObject.put("vehiclegroupindex", vehicleGroup);	
			            								break;
			            							
			            	case Vehicle_Id:			informationList.add(rs.getString("VEHICLE_ID"));
				            							VehicleDetailsObject.put("vehicleidindex", rs.getString("VEHICLE_ID"));	
				            							break;
				            							
			            	case Vehicle_Model:    		informationList.add(rs.getString("ModelName"));
			            								VehicleDetailsObject.put("vehiclemodelindex", rs.getString("ModelName")); 	
			            								break;
			            								
			            	case Vehicle_No:     		informationList.add(rs.getString("VehicleNo"));
			            								VehicleDetailsObject.put("vehiclenoindex", rs.getString("VehicleNo"));
			            								break;
			            								
			            	case Vehicle_Status:   		informationList.add(rs.getString("VEH_STATUS"));
				            							VehicleDetailsObject.put("vehiclestatusindex", rs.getString("VEH_STATUS"));	
				            							break;
				            							
			            	case Vehicle_Type:     		vehicleTypeName=null;
			            								if(language.equals("ar") && !rs.getString("VehicleType").equals("")){
			            									vehicleTypeName=LocationLocalization.getApplicationResourcesValuesForArabic(rs.getString("VehicleType"));
														}else{
															vehicleTypeName=rs.getString("VehicleType");
															}
			            								informationList.add(vehicleTypeName);
			            								VehicleDetailsObject.put("vehicletypeindex", vehicleTypeName);	
			            								break; 
			            	
			            	case Booking_Customer:     	informationList.add(boookingCustomer);
														VehicleDetailsObject.put("bookingcustomerindex", boookingCustomer);	
														break;
														
			               case Container_No:     	    informationList.add(containerNos);
														VehicleDetailsObject.put("containerNoindex", containerNos);	
														break;
														
			            	case Fuel_Guage:     	    if(rs.getString("FUEL_LEVEL_PERCENTAGE")!=null){
															image = new StringBuilder();
															image.append("<html><head><body><pre><img src='/ApplicationImages/ApplicationButtonIcons/fuel_gauge_small.jpg' height='17'></pre></body></head></html>");
														}
			            								informationList.add(rs.getString("FUEL_LEVEL_PERCENTAGE"));
														VehicleDetailsObject.put("fuelguageindex", image);	
														break;
														
			            	case Temperature:     	    String temp=null;
														if(rs.getString("Temperature")==null){
															temp = "";
										   				 }
										   				 else if(rs.getString("Temperature").equalsIgnoreCase("10000") || rs.getString("Temperature").equalsIgnoreCase("10000.0") || rs.getString("Temperature").equalsIgnoreCase("300") || rs.getString("Temperature").equalsIgnoreCase("300.0")){
										   					     temp = "";
										   					 }
										   					 else{
										   						 temp=rs.getString("Temperature");
										   					 }
										            	informationList.add(temp);
														VehicleDetailsObject.put("temperatureindex", temp);	
														break;
			            	case Beacon_On_Of_Time:      String beconDate="";
			            								if(!rs.getString("BEACON_ON_OFF_TIME").equals("") && !rs.getString("BEACON_ON_OFF_TIME").contains("1900")){
			            									beconDate=rs.getString("BEACON_ON_OFF_TIME");
			            								}
			            								informationList.add(beconDate);
			            								VehicleDetailsObject.put("beacononoffindex", beconDate);	
			            								break;
			            									
			            	case Odometer:      		informationList.add(rs.getFloat("Odometer"));
			            								VehicleDetailsObject.put("odometerindex", rs.getFloat("Odometer"));	
			            								break;
			            								
			            	case OBD_Odometer:      	float obd=  (rs.getFloat("OBDOdometer"));
			            		                        informationList.add(df.format(obd));
							                            VehicleDetailsObject.put("obdodometerindex", df.format(obd));	
							                            break;
							                            
							                            
			            	case OBD_DateTime:       	if(rs.getTimestamp("OBDDateTime") != null && !"".equals(rs.getTimestamp("OBDDateTime"))){
			            									informationList.add(sdfyyyymmddhhmmss.format(rs.getTimestamp("OBDDateTime")));
								                            VehicleDetailsObject.put("obddatetimeindex", sdfyyyymmddhhmmss.format(rs.getTimestamp("OBDDateTime")));
			            								}else{
			            									informationList.add("");
								                            VehicleDetailsObject.put("obddatetimeindex", "");
			            								}
							                            break;
							                            
			            	case OBD_CONNECTION_STATUS:  informationList.add(rs.getString("OBDConnectionStatus"));
                                                          VehicleDetailsObject.put("obdconnectionstatusindex", rs.getString("OBDConnectionStatus"));	
                                                        break;
							                            
							                            
			             /*	case Speed_Odometer:    informationList.add(rs.getFloat("SpeedOdometer"));
                                                        VehicleDetailsObject.put("speedodometerindex", rs.getFloat("SpeedOdometer"));	
                                                        break;*/
			            	                            
							
							
			            	case Seat_Belt:         	String seatBeltAlert="";
			            								if(IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+37) != null){
			            									boolean acOn = getACStatusForVehicle(rs.getString("VehicleNo"),IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+37).toString(),rs.getInt("IO3"),rs.getInt("IO4"),rs.getInt("IO5"),rs.getInt("IO6"),rs.getInt("IO7"));
			            										if(acOn == true){
			            											seatBeltAlert="Clicked";
			            										}else{
			            											seatBeltAlert="UnClicked";
			            										}
			            								}
														informationList.add(seatBeltAlert);
														VehicleDetailsObject.put("seatbeltindex", seatBeltAlert);
														break;   								
			            	case IB_Voltage:			String ibVoltage=rs.getString("IB_VOLTAGE");
			            								informationList.add(ibVoltage);
			            								VehicleDetailsObject.put("ibvoltageindex", ibVoltage);
			            								break; 
			            								
			            	case Battery_Voltage:		float batteryVoltage= Float.parseFloat(rs.getString("Battery_Voltage"));
			            	                            String batteryVoltage1 =  df1.format(batteryVoltage);
														informationList.add(batteryVoltage1);
														VehicleDetailsObject.put("batteryVoltageIndex", batteryVoltage1);
														break; 	
														
			            	case AD_Light:			String adLight="";
													if(IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+147) != null){								   
														boolean acOn = getACStatusForVehicle(rs.getString("VehicleNo"),IOColumnNameTable.get(rs.getString("VehicleNo")+"-"+147).toString(),rs.getInt("IO3"),rs.getInt("IO4"),rs.getInt("IO5"),rs.getInt("IO6"),rs.getInt("IO7"));
							 								if(acOn == true){
							 									adLight="ON"; 
																}
															else{
																adLight="OFF";  
															}
														}
														else{
															adLight="OFF";
														}
														informationList.add(adLight);
														VehicleDetailsObject.put("adlightindex", adLight);		
														break;							
			            								
			            	case Vehicle_Image:        String path=rs.getString("ImageName");
			            						       String vehicleImage="";
			            						       String imagePath=null;
			            							   if(path==null || path.equals("")){	
			            								   if(stopFlag){
			            									   vehicleImage= "<img src='"+vehicleImagePath+"default_BR.png' width='20' height='20' style='margin-top: -3px;'></img>";
			            								   } else if(idleFlag){
			            									   vehicleImage= "<img src='"+vehicleImagePath+"default_BL.png' width='20' height='20' style='margin-top: -3px;'></img>";
			            								   } 
			            								  // else if(ignition.equals("On") && speedFinal>10){
			            								//	   vehicleImage= "<img src='"+vehicleImagePath+"default_BG.png' width='20' height='20' style='margin-top: -3px;'></img>";	 
			            								 //  }
			            								   else{
			            									   vehicleImage= "<img src='"+vehicleImagePath+"default_BG.png' width='20' height='20' style='margin-top: -3px;'></img>";	 
			            								   }
			            							   }else{
			            								   imagePath=path.substring(path.lastIndexOf("/")+1, path.length());
			            								   if(imagePath.contains("default"))
			            								   {
			            									   if(stopFlag){
				            									   vehicleImage= "<img src='"+vehicleImagePath+"default_BR.png' width='20' height='20' style='margin-top: -3px;'></img>";
				            								   } else if(idleFlag){
				            									   vehicleImage= "<img src='"+vehicleImagePath+"default_BL.png' width='20' height='20' style='margin-top: -3px;'></img>";
				            								   } 
//				            								   else if(ignition.equals("On") && speedFinal>10){
//				            									   vehicleImage= "<img src='"+vehicleImagePath+"default_BG.png' width='20' height='20' style='margin-top: -3px;'></img>";	 
//				            								   }
				            								   else {
				            									   vehicleImage= "<img src='"+vehicleImagePath+"default_BG.png' width='20' height='20' style='margin-top: -3px;'></img>";	 
				            								   }
			            								   } else {
			            									   imagePath= path.substring(path.lastIndexOf("/")+1, path.lastIndexOf("_"));
			            									   if(stopFlag){
			            										   vehicleImage= "<img src='"+vehicleImagePath+""+imagePath+"_BR.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
			            									   }  else if(idleFlag){
			            										   vehicleImage= "<img src='"+vehicleImagePath+""+imagePath+"_BL.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
			            									   } 
//			            									   else if(ignition.equals("On") && speedFinal>10){
//			            										   vehicleImage= "<img src='"+vehicleImagePath+""+imagePath+"_BG.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
//			            									   } 
			            									   else {
			            										   vehicleImage= "<img src='"+vehicleImagePath+""+imagePath+"_BG.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
			            									   }
			            								   }
			            							   }          							   
			            							 	informationList.add(vehicleImage);
			            								VehicleDetailsObject.put("vehicleimageindex", vehicleImage);
			            								break;
			            	case Person_Status:		   String personStatus=rs.getString("PERSON_STATUS");
			            							   informationList.add(personStatus);
			            							   VehicleDetailsObject.put("personstatusindex", personStatus);
			            							   break;
			            							   
				            case Direction:		   	   String direction = rs.getString("DIRECTION");
								   					   informationList.add(direction);
													   VehicleDetailsObject.put("directionindex", direction);
													   break;
				            case Internal_Battery_Voltage:
														float ibvoltage = Float.parseFloat(rs.getString("Internal_Battery_Voltage"));
														String ibvolts = df.format(ibvoltage);
														informationList.add(ibvolts);
													    VehicleDetailsObject.put("internalbatteryindex", ibvolts);
													    break;
			            	
				            case OBD_Type: 				String obdVehicle = "";
														if(!rs.getString("obd").equals("")){
															obdVehicle = "OBD";
														}
														informationList.add(obdVehicle);
														//System.out.println(systemId);
														if(vehicleCount > 4000 && systemId == 261){
															VehicleDetailsObject.put("obdIndex", "<html><a href='/Telematics4uApp/Jsps/OBD/VehicleDiagnosticDashBoard.jsp?RegNo="+rs.getString("VehicleNo")+"&ParamId=liveVisionNew' style='text-decoration: underline;'>"+obdVehicle+"</a></html>");
														}else if( systemId == 333) {
															VehicleDetailsObject.put("obdIndex", "<html><a href='/Telematics4uApp/Jsps/OBD/VehicleDiagnosticDashboard2x2.jsp?RegNo="+rs.getString("VehicleNo")+"&ParamId=liveVision' style='text-decoration: underline;'>"+obdVehicle+"</a></html>");
														}else{
															VehicleDetailsObject.put("obdIndex", "<html><a href='/Telematics4uApp/Jsps/OBD/VehicleDiagnosticDashBoard.jsp?RegNo="+rs.getString("VehicleNo")+"&ParamId=liveVision' style='text-decoration: underline;'>"+obdVehicle+"</a></html>");
														}	
														break;
														
				            case Operating_On_Mine:
														String operatingOnMine = rs.getString("OPERATING_ON_MINE");
														informationList.add(operatingOnMine);
													    VehicleDetailsObject.put("operatingOnMineIndex", operatingOnMine);
													    break;	
				            case Fuel_Litre:
										//	String operatingOnMine = rs.getString("OPERATING_ON_MINE");
				            	if(!(rs.getFloat("FUEL_LTR")==-1)){
									informationList.add(df.format(rs.getFloat("FUEL_LTR")));
								    VehicleDetailsObject.put("fuelLtrIndex", rs.getFloat("FUEL_LTR"));
				            	}else{
				            		informationList.add("");
								    VehicleDetailsObject.put("fuelLtrIndex", "");
				            	}
							    break;
							    
				            case Last_Fuel_Time:
				            		if(rs.getString(("Last_Fuel_Time"))==null){
				            			informationList.add("");
										 VehicleDetailsObject.put("fuelTimeIndex", "");
				            		}else if(rs.getString(("Last_Fuel_Time")).contains("1900")){
								    	 informationList.add("");
										 VehicleDetailsObject.put("fuelTimeIndex", "");
								    }else{
								    	informationList.add(ddmmyyyy.format(yyyymmdd.parse((rs.getString("Last_Fuel_Time")))));
								    	VehicleDetailsObject.put("fuelTimeIndex", ddmmyyyy.format(yyyymmdd.parse((rs.getString("Last_Fuel_Time")))));
								    }
				            	   break;
				            	   
				            	   
			case Trip_No:	            			tripNo=null;
							if(language.equals("ar") && !rs.getString("TRIP_NO").equals("")){
								tripNo=LocationLocalization.getLocationLocalization(rs.getString("TRIP_NO"), language);
							}else{
								tripNo=rs.getString("TRIP_NO");
							}
							informationList.add(tripNo);
							VehicleDetailsObject.put("tripNoindex", tripNo);
							break;
            case Route_Name:			routeName=null;
								if(language.equals("ar") && !rs.getString("ROUTE_NAME").equals("")){
									routeName=LocationLocalization.getLocationLocalization(rs.getString("ROUTE_NAME"), language);
								}else{
									routeName=rs.getString("ROUTE_NAME");
								}
								informationList.add(routeName);
								VehicleDetailsObject.put("routeNameindex", routeName);
								break;
            case LR_No:			lrNo=null;
							if(language.equals("ar") && !rs.getString("LR_NO").equals("")){
								lrNo=LocationLocalization.getLocationLocalization(rs.getString("LR_NO"), language);
							}else{
								lrNo=rs.getString("LR_NO");
							}
							informationList.add(lrNo);
							VehicleDetailsObject.put("lrNoindex", lrNo);
							break;	 
							
            case Trip_Customer:		
            				//trip_Customer = (tripInfo.get(LiveVisionHeaders.Trip_Customer) != null)? tripInfo.get(LiveVisionHeaders.Trip_Customer):"";
							if(language.equals("ar") && !rs.getString("Trip_Customer").equals("")){
							    trip_Customer=LocationLocalization.getLocationLocalization(rs.getString("Trip_Customer"), language);
							}else{
								trip_Customer=rs.getString("Trip_Customer");
							}
							informationList.add(trip_Customer);
							VehicleDetailsObject.put("tripCustomerindex", trip_Customer);
							break;	 
							
            case Temp_info_for_TCL:	 
            				//temp_info_for_TCL=(tripInfo.get(LiveVisionHeaders.Temp_info_for_TCL) != null)? tripInfo.get(LiveVisionHeaders.Temp_info_for_TCL):"";
							if(language.equals("ar") && !rs.getString("Temp_info_for_TCL").equals("")){
								temp_info_for_TCL=LocationLocalization.getLocationLocalization(rs.getString("Temp_info_for_TCL"), language);
							}else{
								temp_info_for_TCL=rs.getString("Temp_info_for_TCL");
							}
							informationList.add(temp_info_for_TCL);
							VehicleDetailsObject.put("tempInfoForTCLindex", temp_info_for_TCL);
							break;	 
			
			
            
			
            case Set_Temp_limits_for_on_trip:			
            			//	set_Temp_limits_for_on_trip = (tripInfo.get(LiveVisionHeaders.Set_Temp_limits_for_on_trip) != null)? tripInfo.get(LiveVisionHeaders.Set_Temp_limits_for_on_trip):"";
							if(language.equals("ar") && !rs.getString("Set_Temp_limits_for_on_trip").equals("")){
								set_Temp_limits_for_on_trip=LocationLocalization.getLocationLocalization(rs.getString("Set_Temp_limits_for_on_trip"), language);
							}else{
								set_Temp_limits_for_on_trip=rs.getString("Set_Temp_limits_for_on_trip");
							}
							informationList.add(set_Temp_limits_for_on_trip);
							VehicleDetailsObject.put("setTempLimitsForOnTripindex", set_Temp_limits_for_on_trip);
							break;	 
							
            case ETP:			//etp=null;
            				//etp = tripInfo.get(LiveVisionHeaders.ETP);
            				//etp = (tripInfo.get(LiveVisionHeaders.ETP) != null)? tripInfo.get(LiveVisionHeaders.ETP):"";
							if(language.equals("ar") && !rs.getString("ETP").equals("")){
							 	etp=LocationLocalization.getLocationLocalization(rs.getString("ETP"), language);
							}else{
								 	etp=rs.getString("ETP");
							}
							etp = etp.contains("1900") ? "": ddmmyyyy.format(yyyymmdd.parse(etp));
							informationList.add(etp);
							VehicleDetailsObject.put("ETPindex", etp);
							break;	
							
            case ATP:			//atp=null;
            			//	atp = (tripInfo.get(LiveVisionHeaders.ATP) != null)? tripInfo.get(LiveVisionHeaders.ATP):"";
							if(language.equals("ar") && !rs.getString("ATP").equals("")){
									atp=LocationLocalization.getLocationLocalization(rs.getString("ATP"), language);
							}else{
									atp=rs.getString("ATP");
							}
							atp = atp.contains("1900") ? "": ddmmyyyy.format(yyyymmdd.parse(atp));
							informationList.add(atp);
							VehicleDetailsObject.put("ATPindex", atp);
							break;					
				           				
							
            case ETA:			//eta=null;
            				//eta = (tripInfo.get(LiveVisionHeaders.ETA) != null)? tripInfo.get(LiveVisionHeaders.ETA):"";
							if(language.equals("ar") && !rs.getString("ETA").equals("")){
									eta=LocationLocalization.getLocationLocalization(rs.getString("ETA"), language);
							}else{
									eta=rs.getString("ETA");
							}
							eta = eta.contains("1900") ? "": ddmmyyyy.format(yyyymmdd.parse(eta));
							informationList.add(eta);
							VehicleDetailsObject.put("ETAindex", eta);
							break;		
							
            case ATA:			//ata=null;
            				//ata = (tripInfo.get(LiveVisionHeaders.ATA) != null)? tripInfo.get(LiveVisionHeaders.ATA):"";
							if(language.equals("ar") && !rs.getString("ATA").equals("")){
									ata=LocationLocalization.getLocationLocalization(rs.getString("ATA"), language);
							}else{
									ata=rs.getString("ATA");
							}
							ata = ata.contains("1900") ? "": ddmmyyyy.format(yyyymmdd.parse(ata));
							informationList.add(ata);
							VehicleDetailsObject.put("ATAindex", ata);
							break;					
							
            case City:			//city=null;
            				//city = getCity(rs.getDouble("LATITUDE"), rs.getDouble("LONGITUDE"), rs.getString("LOCATION"),key);//(tripInfo.get(LiveVisionHeaders.City) != null)? tripInfo.get(LiveVisionHeaders.City):"";
							if(language.equals("ar") && !rs.getString("City").equals("")){
								city=LocationLocalization.getLocationLocalization(rs.getString("City").toUpperCase(), language);
							}else{
									city=rs.getString("City").toUpperCase();
							}
							informationList.add(city.trim());
							VehicleDetailsObject.put("Cityindex", city.trim());
							break;		
							
            case Ageing:	double ageing = 00.00;
            				DecimalFormat df = new DecimalFormat("00.00");
            				//ageing = (tripInfo.get(LiveVisionHeaders.Ageing) != null)? tripInfo.get(LiveVisionHeaders.Ageing):"";
							if(language.equals("ar") && !rs.getString("Ageing").equals("")){
								ageing = 00.00;
								//ageing=LocationLocalization.getLocationLocalization(rs.getString("Ageing"), language);
							}else{
									ageing= rs.getString("Ageing").equals("") ? 00.00 : Double.parseDouble(rs.getString("Ageing").replace(":", "."));
							}
							informationList.add(ageing);
							VehicleDetailsObject.put("Ageingindex", ageing);
							break;
							
			            		}
			            }			           
						VehicleDetailsArray.put(VehicleDetailsObject);
						reporthelper.setInformationList(informationList);
				        reportsList.add(reporthelper);
                        IOPort="";
                        tripStartDate="";
						tripName="";
						status="";
						boookingCustomer="";
						acStatus="";
						acHoursNew=0.0;
						STOP=0.0;
						idleTime=0.0;
				 }
	        
	     
			finalreporthelper.setReportsList(reportsList);
	        finalreporthelper.setHeadersList(headersList);
	        finlist.add(VehicleDetailsArray);
	        finlist.add(finalreporthelper);	      
		
		}catch (Exception e) {
			e.printStackTrace();
		} finally {
			
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(conLms, pstmtLms, rsLms);			
		}
		return finlist;
	
	}
	
	
	public String AddRemarks(String vehicleNo,int systmeId,String remarks)
	{   
		Connection connection = null;
		PreparedStatement pstmt = null;
		int count=0;
		String msg="";
		try
		{
			connection=DBConnection.getConnectionToDB("AMS");
			pstmt = connection.prepareStatement(MapViewStatements.UPDATE_REMARKS);
			pstmt.setString(1,remarks);
			pstmt.setString(2, vehicleNo);
			pstmt.setInt(3, systmeId);
			
			count=pstmt.executeUpdate();
			if(count>0)
			msg="Remarks Updated Successfully";
			else
			msg="Error While Updating";
		}
		catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(connection, pstmt, null);
		}
        return msg;
		
	}
	
	
	
	
	public JSONArray getIronMiningMapViewVehiclesDetails(String vehicleNo,
			int offmin, int userID, int customerID, int systemId) {


		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			VehicleDetailsArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MapViewStatements.GET_IRON_MINING_ASSET_DETAILS);
			pstmt.setString(1, vehicleNo);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("vehicleId", rs.getString("VEHICLE_ID"));
				VehicleDetailsObject.put("ownerName", rs.getString("OWNER_NAME"));
				VehicleDetailsObject.put("status", rs.getString("STATUS"));
				if(rs.getString("TRIP_STATUS").contains("In Transit") )
				{
					VehicleDetailsObject.put("tripNo", rs.getString("TRIP_NO"));
					VehicleDetailsObject.put("tripvalidity", rs.getString("START_TIME"));
				}
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	
	}

	public JSONArray getHistoryData(String vehicleNo, int offmin,
			int userID, int customerID, int systemId,String lastCommTime)
	{


		JSONArray VehicleHistoryDetailsArray = new JSONArray();
		JSONObject VehicleHistoryDetailsObject = null;
		Connection con = null;
//		com.mysql.jdbc.Connection mysqlCon = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
//		com.mysql.jdbc.PreparedStatement st=null;
//		ResultSet rs1=null;
		try {
			VehicleHistoryDetailsArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
//			mysqlCon = DBConnection.getConnectionMysql();
//			st =  (com.mysql.jdbc.PreparedStatement) mysqlCon.prepareStatement(cf.getGeQuery(MapViewStatements.GET_GE_DATA_FROM_MYSQL, systemId));
//			st.setInt(1, offmin);
//			st.setString(2, vehicleNo);
//			st.setString(3, lastCommTime);
//			st.setString(4, lastCommTime);
//			rs1=st.executeQuery();
//			while(rs1.next()){
//				VehicleHistoryDetailsObject = new JSONObject();
//				VehicleHistoryDetailsObject.put("location", rs1.getString("LOCATION"));
//				VehicleHistoryDetailsObject.put("datetime", rs1.getString("LOCAL_TIME"));
//				VehicleHistoryDetailsObject.put("speed", rs1.getString("SPEED"));
//				VehicleHistoryDetailsObject.put("packettype", rs1.getString("PACKET_TYPE"));
//				VehicleHistoryDetailsObject.put("batteryvoltage", rs1.getString("COMMAND_ID"));
//				VehicleHistoryDetailsObject.put("nosatelites", rs1.getString("SATELLITE"));
//				VehicleHistoryDetailsArray.put(VehicleHistoryDetailsObject);
//			}
			pstmt = con.prepareStatement(cf.getHistoryQuery(MapViewStatements.GET_HISTORY_DATA,systemId));
			pstmt.setInt(1, offmin);
			pstmt.setString(2, vehicleNo);
			pstmt.setString(3, lastCommTime);
			pstmt.setString(4, lastCommTime);
			pstmt.setInt(5, offmin);
			pstmt.setString(6, vehicleNo);
			pstmt.setString(7, lastCommTime);
			pstmt.setString(8, lastCommTime);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				VehicleHistoryDetailsObject = new JSONObject();
				VehicleHistoryDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleHistoryDetailsObject.put("datetime", rs.getString("LOCALTIME"));
				VehicleHistoryDetailsObject.put("speed", rs.getString("SPEED"));
				VehicleHistoryDetailsObject.put("packettype", rs.getString("PACKET_TYPE"));
				VehicleHistoryDetailsObject.put("batteryvoltage", rs.getString("COMMAND_ID"));
				VehicleHistoryDetailsObject.put("nosatelites", rs.getString("SATELLITE"));
				VehicleHistoryDetailsArray.put(VehicleHistoryDetailsObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
//			DBConnection.releaseConnectionToMysqlDB(mysqlCon, st, rs1);
		}
		return VehicleHistoryDetailsArray;
	
	}

	public JSONArray getIronMiningNonCommStatus(String vehicleNo, int offmin,
			int userID, int customerID, int systemId) {

		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			   VehicleDetailsArray = new JSONArray();
			   con = DBConnection.getConnectionToDB("AMS");
			   if(customerID==0){
				   pstmt = con.prepareStatement(MapViewStatements.GET_MAIN_POWER_ON_OFF_FOR_LTSP);
				   pstmt.setInt(1, offmin);
					pstmt.setString(2, vehicleNo);					
					pstmt.setInt(3, systemId);
			   }else{
				   pstmt = con.prepareStatement(MapViewStatements.GET_MAIN_POWER_ON_OFF);
					pstmt.setInt(1, offmin);
					pstmt.setString(2, vehicleNo);
					pstmt.setInt(3, customerID);
					pstmt.setInt(4, systemId); 
			   }
				
				rs = pstmt.executeQuery();
				if (rs.next()) {
					if(rs.getInt("HUB_ID")==0)
					{
						VehicleDetailsObject.put("mainPower","Off");
						VehicleDetailsObject.put("mainPowerOffLocation",rs.getString("LOCATION"));
						VehicleDetailsObject.put("mainPowerOffTime",rs.getString("LOCALTIME"));
						VehicleDetailsArray.put(VehicleDetailsObject);
					}
					else
					{
						VehicleDetailsObject.put("mainPower","On");
						VehicleDetailsObject.put("mainPowerOffLocation","");
						VehicleDetailsObject.put("mainPowerOffTime","");
						VehicleDetailsArray.put(VehicleDetailsObject);
					}
				}
				else
				{
						VehicleDetailsObject.put("mainPower","On");
						VehicleDetailsObject.put("mainPowerOffLocation","");
						VehicleDetailsObject.put("mainPowerOffTime","");
						VehicleDetailsArray.put(VehicleDetailsObject);
				}
				pstmt.close();
				rs.close();
				if(customerID==0){
					pstmt = con.prepareStatement(MapViewStatements.GET_VOLTAGE_DETAILS_FOR_LTSP);
					pstmt.setInt(1, offmin);
					pstmt.setString(2, vehicleNo);
					pstmt.setInt(3, systemId);				
				}else{
					pstmt = con.prepareStatement(MapViewStatements.GET_VOLTAGE_DETAILS);
					pstmt.setInt(1, offmin);
					pstmt.setString(2, vehicleNo);
					pstmt.setInt(3, systemId);
					pstmt.setInt(4, customerID);
				}
				
				rs = pstmt.executeQuery();
				if (rs.next()) {					
					VehicleDetailsObject.put("vehicleNo",vehicleNo);
					if (rs.getInt("BATTERY_VOLTAGE")==12)
					{
					 	   if(rs.getInt("MAIN_BATTERY_VOLTAGE") >= 9)
								{
					 		     VehicleDetailsObject.put("batteryHealth","Good");
								 VehicleDetailsArray.put(VehicleDetailsObject);
								}
							else
								{
								 VehicleDetailsObject.put("batteryHealth","Poor");
								 VehicleDetailsArray.put(VehicleDetailsObject);
								}
					}else if (rs.getInt("BATTERY_VOLTAGE")==24)
						{
						   if(rs.getInt("MAIN_BATTERY_VOLTAGE") >=20)
								{
							     VehicleDetailsObject.put("batteryHealth","Good");
								 VehicleDetailsArray.put(VehicleDetailsObject);
								}
							else
								{
								 VehicleDetailsObject.put("batteryHealth","Poor");
								 VehicleDetailsArray.put(VehicleDetailsObject);
								}
						}
					else
					{
						VehicleDetailsObject.put("batteryHealth","");
						VehicleDetailsArray.put(VehicleDetailsObject);	
					}
			            
					if(rs.getString("VALID")=="N")
					{
						VehicleDetailsObject.put("invalidPacket","Vehicle Sending Invalid Packets since "+rs.getString("INVALID_UPDATETIME"));
						VehicleDetailsArray.put(VehicleDetailsObject);	
					}
					else
					{
						VehicleDetailsObject.put("invalidPacket","NO");
						VehicleDetailsArray.put(VehicleDetailsObject);	 
					}
					VehicleDetailsObject.put("lastCommDateTime",rs.getString("LOCALTIME"));
					VehicleDetailsObject.put("lastCommGMTDateTime", rs.getString("GMT"));
					VehicleDetailsObject.put("lastCommLocation",rs.getString("LOCATION"));
					VehicleDetailsObject.put("nonCommHours",cf.convertMinutesToHHMMFormat(rs.getInt("NONCOMM_HOURS")));	
					VehicleDetailsObject.put("batteryVoltage",rs.getInt("MAIN_BATTERY_VOLTAGE") +"V");	
					VehicleDetailsObject.put("noOfSatellites",rs.getString("SATELLITE"));	
					VehicleDetailsArray.put(VehicleDetailsObject);
				}
				
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	
	
	

	public JSONArray getCustomerLandmarks(int customerId,int systemId,String zone)
	{
		JSONArray LandmarksDetailsArray = new JSONArray();
		int locCount=1;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MapViewStatements.GET_CUSTOMER_LANDMARKS_NAMES.replace("LOCATION", "LOCATION_ZONE_"+zone));
			pstmt.setInt(1, customerId);
			pstmt.setInt(2, systemId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				JSONObject LandmarksDetailsObject = new JSONObject();
				LandmarksDetailsObject.put("id",locCount++);
				LandmarksDetailsObject.put("locationName", rs.getString("NAME"));
				LandmarksDetailsArray.put(LandmarksDetailsObject);
			}
		}
			catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return LandmarksDetailsArray;
		}
	
	
	public JSONArray getCustomerLandmarksLatLong(int customerId,String names,int systemId,String zone)
	{
		JSONArray LandmarksDetailsArray = new JSONArray();
		int locCount=1;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String imageName="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
		
				pstmt = con.prepareStatement(MapViewStatements.GET_CUSTOMER_LANDMARKS_LAT_LONG.replace("LOCATION", "LOCATION_ZONE_"+zone));
				pstmt.setString(1, names);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, systemId);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					JSONObject LandmarksDetailsObject = new JSONObject();
					LandmarksDetailsObject.put("name", rs.getString("NAME"));
					LandmarksDetailsObject.put("latitude",rs.getFloat("LATITUDE"));
					LandmarksDetailsObject.put("longitude",rs.getFloat("LONGITUDE"));
					if(rs.getString("IMAGE")!="")
						LandmarksDetailsObject.put("imagename", rs.getString("IMAGE"));
						else
							LandmarksDetailsObject.put("imagename", imageName);
					
					LandmarksDetailsArray.put(LandmarksDetailsObject);
				
			}
			
		}
			catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return LandmarksDetailsArray;
		}
	
	

	
	
	public String getFormattedDateStartingFromMonth(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		SimpleDateFormat sdfFormatDate = new SimpleDateFormat(
				"MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdf.parse(inputDate);
				formattedDate = sdfFormatDate.format(d);
			}
		} catch (Exception e) {
			System.out
					.println("Error in getFormattedDateStartingFromMonth() method"
							+ e);
		}
		return formattedDate;
	}
	public String getFormattedDateStartingFromyear(String inputDate) {
		String formattedDate = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		try {
			if (inputDate != null && !inputDate.equals("")) {
				java.util.Date d = sdfFormatDate.parse(inputDate);
				formattedDate = sdf.format(d);
			}
		} catch (Exception e) {
			System.out
					.println("Error in getFormattedDateStartingFromMonth() method"
							+ e);
		}
		return formattedDate;
	}
	
	
	public JSONArray getVehicleForMLLECommerce(String vehicleNo) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		StringBuilder sb=null;
		String stmt="";
		try {
			
			stmt=MapViewStatements.GET_VEHICLE_FOR_MLL_ECOMMERCE;
		    sb=new StringBuilder(stmt);
		    stmt=sb.toString().replace("vehicleNo",vehicleNo);
			VehicleDetailsArray = new JSONArray();
			String ignition="";
			con = DBConnection.getConnectionToDB("AMS");
			pstmt=con.prepareStatement(stmt);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				VehicleDetailsObject = new JSONObject();
				if(rs.getInt("IGNITION")==1)
				{
					ignition="On";
				}
				else
				{
					ignition="Off";
				}
				VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				VehicleDetailsObject.put("latitude", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("longitude", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", rs.getString("LOCATION"));
				VehicleDetailsObject.put("gmt", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
				VehicleDetailsObject.put("drivername", rs.getString("DRIVER_NAME"));
				VehicleDetailsObject.put("groupname", rs.getString("GROUP_NAME"));
				VehicleDetailsObject.put("ignition",ignition);
				VehicleDetailsObject.put("category",rs.getString("CATEGORY"));
				VehicleDetailsObject.put("speed",rs.getString("SPEED"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}

	public JSONArray getTaxiMapViewVehicles(String vehicleType, int offmin,
		int userId, int customerId, int systemId, int isLtsp) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		String vehicle=null;
		String sb="";
		String vehListIO = "";
//		String RegistrationNo=null;
//		List<String> vehicleList=new ArrayList<String>();
		try {
			VehicleDetailsArray = new JSONArray();
			String ignition="";
			con = DBConnection.getConnectionToDB("AMS");
			
			if(userId==0)
			{
				pstmt = con.prepareStatement(MapViewStatements.GET_ALL_TAXI_MAP_VIEW_DRIVER_LOG_VEHICLES);
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
			}
			else
			{
				pstmt = con.prepareStatement(MapViewStatements.GET_TAXI_MAP_VIEW_DRIVER_LOG_VEHICLES);
				pstmt.setInt(1, userId);
				pstmt.setInt(2, customerId);
				pstmt.setInt(3, systemId);
			}
			
			rs = pstmt.executeQuery();
				while (rs.next()) {
					VehicleDetailsObject = new JSONObject();
					if(rs.getString(rs.getString("IO")).equals("0"))
					{
						vehicle=rs.getString("REGISTRATION_NO");
						
						sb = sb+"'"+vehicle+"',";
						
						if( (vehicleType.equalsIgnoreCase("driverLog")||(vehicleType.equalsIgnoreCase("all"))))
						{
							VehicleDetailsObject.put("taxiMeter","DriverLog");
							if(rs.getInt("IGNITION")==1)
							{
								ignition="On";
							}
							else
							{
								ignition="Off";
							}
							
							VehicleDetailsObject.put("flag", rs.getInt("FLAG"));
							VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
							VehicleDetailsObject.put("latitude", rs.getString("LATITUDE"));
							VehicleDetailsObject.put("longitude", rs.getString("LONGITUDE"));
							VehicleDetailsObject.put("location", rs.getString("LOCATION"));
							VehicleDetailsObject.put("gmt", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
							VehicleDetailsObject.put("drivername", rs.getString("DRIVER_NAME"));
							VehicleDetailsObject.put("groupname", rs.getString("GROUP_NAME"));
							VehicleDetailsObject.put("ignition",ignition);
							VehicleDetailsObject.put("category",rs.getString("CATEGORY"));
							VehicleDetailsObject.put("speed",rs.getString("SPEED"));
							VehicleDetailsArray.put(VehicleDetailsObject);
						}
					}
				}
				
				if(sb!="") {
					sb=sb.substring(0,sb.length()-1);
				} else {
					sb = "''";
				}
				
				vehListIO = getUserVehicleList(con, userId, systemId, customerId, sb, isLtsp);
				if(vehListIO == "")
					vehListIO = "''";
					

				if (userId==0) {
				if (vehicleType.equalsIgnoreCase("all")) {
//					if(vehListIO!=""){
						pstmt = con.prepareStatement(MapViewStatements.GET_ALL_TAXI_MAP_VIEW_DETAILS + " and a.REGISTRATION_NO in("+vehListIO+")");
					/*}else{
						pstmt = con.prepareStatement(MapViewStatements.GET_ALL_TAXI_MAP_VIEW_DETAILS);
					}*/
				} else if (vehicleType.equalsIgnoreCase("readyforBooking")||vehicleType.equalsIgnoreCase("meterOn")||vehicleType.equalsIgnoreCase("vehicelisMoving")) {
//					if(vehListIO!=""){
					pstmt = con.prepareStatement(MapViewStatements.GET_ALL_TAXI_MAP_VIEW_COMM_DETAILS + " and a.REGISTRATION_NO in("+vehListIO+")");
					/*}else{
						pstmt = con.prepareStatement(MapViewStatements.GET_ALL_TAXI_MAP_VIEW_COMM_DETAILS);
					}*/
				}else if (vehicleType.equalsIgnoreCase("noncomm")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_ALL_TAXI_MAP_VIEW_NON_COMM_DETAILS + " and a.REGISTRATION_NO in("+vehListIO+")");
				} else if (vehicleType.equalsIgnoreCase("noGPS")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_ALL_TAXI_MAP_VIEW_NO_GPS_DETAILS + " and a.REGISTRATION_NO in("+vehListIO+")");
				}
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
				
				}else{
					if (vehicleType.equalsIgnoreCase("all")) {
//						if(vehListIO!=""){
							pstmt = con.prepareStatement(MapViewStatements.GET_TAXI_MAP_VIEW_DETAILS+" and a.REGISTRATION_NO in("+vehListIO+")");
//						}else{
//							pstmt = con.prepareStatement(MapViewStatements.GET_TAXI_MAP_VIEW_DETAILS);
//						}
					} else if (vehicleType.equalsIgnoreCase("readyforBooking")||vehicleType.equalsIgnoreCase("meterOn")||vehicleType.equalsIgnoreCase("vehicelisMoving")) {
//						if(vehListIO!=""){
							pstmt = con.prepareStatement(MapViewStatements.GET_TAXI_MAP_VIEW_COMM_DETAILS + " and a.REGISTRATION_NO in("+vehListIO+")");
//						}else{
//							pstmt = con.prepareStatement(MapViewStatements.GET_TAXI_MAP_VIEW_COMM_DETAILS);
//						}		
					}else if (vehicleType.equalsIgnoreCase("noncomm")) {
						pstmt = con.prepareStatement(MapViewStatements.GET_TAXI_MAP_VIEW_NON_COMM_DETAILS + " and a.REGISTRATION_NO in("+vehListIO+")");
					} else if (vehicleType.equalsIgnoreCase("noGPS")) {
						pstmt = con.prepareStatement(MapViewStatements.GET_TAXI_MAP_VIEW_NO_GPS_DETAILS + " and a.REGISTRATION_NO in("+vehListIO+")");
					}
//					pstmt.setInt(1, userId);
					pstmt.setInt(1, customerId);
					pstmt.setInt(2, systemId);
				}
				rs = pstmt.executeQuery();
				while (rs.next()) {
				VehicleDetailsObject = new JSONObject();
				if(vehicleType.equalsIgnoreCase("readyforBooking")||vehicleType.equalsIgnoreCase("meterOn")||vehicleType.equalsIgnoreCase("vehicelisMoving"))
				{
					if(rs.getString("IO").equals("NA") || rs.getString("LOCATION") =="No GPS Device Connected" || !getTaxiStatus(vehicleType,rs.getString(rs.getString("IO")),rs.getInt("SPEED")))
					{
						continue;
					}
				}
				if(!vehicleType.equalsIgnoreCase("noncomm") && !vehicleType.equalsIgnoreCase("noGPS") ){
					if(!rs.getString("IO").equals("NA")&& rs.getString("LOCATION") !="No GPS Device Connected")
					{
						if(rs.getString(rs.getString("IO")).equals("1") && rs.getInt("ALERTID")==64 )
						{
							VehicleDetailsObject.put("taxiMeter","MeterOff");
						}
						else
						{
							VehicleDetailsObject.put("taxiMeter","MeterOn");
						}
					}
				}
				else
				{
					VehicleDetailsObject.put("taxiMeter","NA");
				}
				
				if(rs.getInt("IGNITION")==1)
				{
					ignition="On";
				}
				else
				{
					ignition="Off";
				}
				
				if(!vehicleType.equalsIgnoreCase("driverLog"))
				{
					VehicleDetailsObject.put("flag", rs.getInt("FLAG"));
					VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
					VehicleDetailsObject.put("latitude", rs.getString("LATITUDE"));
					VehicleDetailsObject.put("longitude", rs.getString("LONGITUDE"));
					VehicleDetailsObject.put("location", rs.getString("LOCATION"));
					VehicleDetailsObject.put("gmt", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
					VehicleDetailsObject.put("drivername", rs.getString("DRIVER_NAME"));
					VehicleDetailsObject.put("groupname", rs.getString("GROUP_NAME"));
					VehicleDetailsObject.put("ignition",ignition);
					VehicleDetailsObject.put("category",rs.getString("CATEGORY"));
					VehicleDetailsObject.put("speed",rs.getString("SPEED"));
					VehicleDetailsArray.put(VehicleDetailsObject);
				
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		}
		return VehicleDetailsArray;
	}



	private Boolean getTaxiStatus(String vehicleType, String taxiMeter, int speed) {
	 boolean taxiStatus=false;
	  if(vehicleType.equals("meterOn")&&taxiMeter.equals("0"))
		{
		  	  taxiStatus=true;
		}
	  else if(vehicleType.equals("readyforBooking")&&taxiMeter.equals("1")&&speed<5)
		{
			  taxiStatus=true;
		}
	  else if(vehicleType.equals("vehicelisMoving")&&taxiMeter.equals("1")&&speed>5)
	  {
		  	  taxiStatus=true;
	  }
	 
	return taxiStatus;
	}
	
	
	public JSONArray getConsignmentDetails(String conNo,int systemIdFromLogin,String iP,String remoteHost) {
	    JSONArray JsonArray = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs = null;
	    ResultSet rs1 = null;
	    DecimalFormat df = new DecimalFormat("0.##");
	    JSONObject obj1 = new JSONObject();
	    try {
	    	String RegNo="";
	    	int systemId=0;
	    	int customerId=0;
	    	String consignmentNumber="";
	    	String status="";
	    	String ConsignmentExists="No";
	    	int customerIdForHistory=0;
	    	
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(MapViewStatements.GET_CONSIGNMENT_DETAILS);
	        pstmt.setString(1, conNo.toUpperCase());
	        pstmt.setInt(2, systemIdFromLogin);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	        	ConsignmentExists="Yes";
	        	RegNo=rs.getString("VehicleNo");
	        	systemId=rs.getInt("System_Id");
	        	customerId=rs.getInt("Client_Id");	
	        	consignmentNumber  =rs.getString("ConsignmentNo");
	        	status = rs.getString("Status");
	        	customerIdForHistory = rs.getInt("Client_Id");	
	        	
		        pstmt1 = con.prepareStatement(MapViewStatements.GET_OTHER_DETAILS_FROM_gpsdata_history_latest);
		        pstmt1.setInt(1, systemId);
		        pstmt1.setInt(2, customerId);
		        pstmt1.setString(3, RegNo);
		        rs1 = pstmt1.executeQuery();
		        if (rs1.next()) {
		          obj1.put("location", rs1.getString("LOCATION"));
		        	 if (rs1.getString("GPS_DATETIME") == null || rs1.getString("GPS_DATETIME").equals("") || rs1.getString("GPS_DATETIME").contains("1900")) {
		        		   obj1.put("dateTime", "");
			            } else {
			               obj1.put("dateTime", ddmmyyyy.format(rs1.getTimestamp("GPS_DATETIME")));
			            }
		        	
		        	
		        	obj1.put("speed", rs1.getString("SPEED"));
		        	obj1.put("latitude", rs1.getString("LATITUDE"));
		        	obj1.put("longtitude", rs1.getString("LONGITUDE"));
		        	obj1.put("category", rs1.getString("CATEGORY"));
		        	String ignition=rs1.getString("IGNITION");
		        	  if(ignition.equals("0"))
		        	    {
		        		   ignition="OFF";
		        	    }
		        	 else  
		        	    {
		        		ignition="ON";
		        	    }
		        	obj1.put("ignition", ignition);
			        obj1.put("regNo", RegNo);
			        obj1.put("ConsignmentNo", consignmentNumber);
			        obj1.put("status", status);
			        obj1.put("ShippingDate", ddmmyyyy.format(rs.getTimestamp("Scheduled_Shipping_Date")));
		        	obj1.put("ScheduleDeliveryDate", ddmmyyyy.format(rs.getTimestamp("Scheduled_Delivery_Date")));
		        	obj1.put("RevisedDeliveryDate", ddmmyyyy.format(rs.getTimestamp("Revised_Delivery_Date")));
		        	
		        	String distanceTravelled = rs.getString("Total_Distance");
			        String coveredDistance = rs.getString("Travelled_Distance");
			        float remainingDistance = Float.parseFloat(distanceTravelled)- Float.parseFloat(coveredDistance);
			        double remdistance= Double.parseDouble(new DecimalFormat("##.##").format(remainingDistance));
		        	obj1.put("DistanceCovered", coveredDistance);
		        	obj1.put("RemainingDistance",remdistance);
			        JsonArray.put(obj1);
		        }
		        else
		        {
		        	obj1.put("location","");
		        	obj1.put("dateTime", "");
		        	obj1.put("speed","");
		        	obj1.put("ignition", "");
		        	obj1.put("regNo", "");
		        	obj1.put("latitude", "");
		        	obj1.put("longtitude", "");
		        	obj1.put("category", "");
		        	obj1.put("ConsignmentNo", "");
		        	obj1.put("status", "");
		        	obj1.put("ShippingDate", "");
		        	obj1.put("ScheduleDeliveryDate", "");
		        	obj1.put("RevisedDeliveryDate", "");
		        	obj1.put("DistanceCovered", "");
		        	obj1.put("RemainingDistance", "");
		        	JsonArray.put(obj1);
		        }
	        }else
	        {
	        	obj1.put("location","");
	        	obj1.put("dateTime", "");
	        	obj1.put("speed","");
	        	obj1.put("ignition", "");
	        	obj1.put("regNo", "");
	        	obj1.put("latitude", "");
	        	obj1.put("longtitude", "");
	        	obj1.put("category", "");
	        	obj1.put("ConsignmentNo", "");
	        	obj1.put("status", "");
	        	obj1.put("ShippingDate", "");
	        	obj1.put("ScheduleDeliveryDate", "");
	        	obj1.put("RevisedDeliveryDate", "");
	        	obj1.put("DistanceCovered", "");
	        	obj1.put("RemainingDistance", "");
	        	JsonArray.put(obj1);
	        }
          
	        pstmt = con.prepareStatement(MapViewStatements.SAVE_CONSIGNMENT_DETAILS_IN_LOGIN_HISTORY);
	        pstmt.setString(1, conNo.toUpperCase());
	        pstmt.setString(2, ConsignmentExists);
	        pstmt.setInt(3, systemIdFromLogin);
	        pstmt.setInt(4,customerIdForHistory);
	        pstmt.setString(5,iP);
	        pstmt.setString(6,remoteHost);
	        pstmt.executeUpdate();
	        
		    } 
	    catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	    }
	    return JsonArray;
	    
	}
	
/*****************************************CONSIGNMENT DASHBOARD FUNCTIONS***************************************************************************************/	
	
	//Block of Code for getting a data to map in the dashboard
	public JSONArray getConsignmentDetailsForDashBoard(int systemId, int custId, String consignmentStatus, String region,int userId,String bookingCustomer) {
	    JSONArray JsonArray = null;
	    Connection con = null;
	    PreparedStatement pstmt1 = null;
	    JSONObject obj1 = null;
	    ResultSet rs1 = null;
	    String query ="";
	    String query1 ="";
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        if (consignmentStatus.equals("All")) {
              //Block of code after clicking View
	        	
	        	if(custId == 0)
	        	{
		            if(region.equals("ALL"))
		            {
		                  query = MapViewStatements.GET_DETAILS_FROM_CONSIGNMENT_DASHBOARD_DEATILS_For_View_FOR_ALL;
		            } else {
		                  query = MapViewStatements.GET_DETAILS_FROM_CONSIGNMENT_DASHBOARD_DEATILS_For_View_FOR_ALL + " and REGION='" + region + "'";
		            }	
	        	}else
	        	{
	        		if(region.equals("ALL"))
		            {
		                  query = MapViewStatements.GET_DETAILS_FROM_CONSIGNMENT_DASHBOARD_DEATILS_For_View_FOR_ALL + " and a.CUSTOMER_ID=" +custId;
		            } else {
		                  query = MapViewStatements.GET_DETAILS_FROM_CONSIGNMENT_DASHBOARD_DEATILS_For_View_FOR_ALL + " and REGION='" + region + "'" + " and a.CUSTOMER_ID=" +custId;
		            }	
	        	}
	            
	            
	            if(!bookingCustomer.equals("ALL"))
	            {
	                  query = query + " and a.BOOKING_CUSTOMER_ID="+bookingCustomer;
	            }
	            
	            pstmt1 = con.prepareStatement(query);
	            pstmt1.setInt(1, systemId);
              //  pstmt1.setInt(2, custId);
                pstmt1.setInt(2, userId);
                rs1 = pstmt1.executeQuery();
                
	        } else {
	        	//Block of code for checkbox
	        	if(custId == 0)
	        	{
	        		if(region.equals("ALL"))
		            {
		                  query1 = MapViewStatements.GET_DETAILS_FOR_REGION_ALL_AND_FOR_CHECKBOX;
		            } else {
		                  query1 = MapViewStatements.GET_DETAILS_FOR_REGION_ALL_AND_FOR_CHECKBOX + " and REGION='" + region + "'";
		            }
	        	}else
	        	{
		        	if(region.equals("ALL"))
		            {
		                  query1 = MapViewStatements.GET_DETAILS_FOR_REGION_ALL_AND_FOR_CHECKBOX + " and a.CUSTOMER_ID=" +custId;
		            } else {
		                  query1 = MapViewStatements.GET_DETAILS_FOR_REGION_ALL_AND_FOR_CHECKBOX + " and REGION='" + region + "'" + " and a.CUSTOMER_ID=" +custId;
		            }	
	        	}
	        	if(!bookingCustomer.equals("ALL"))
	            {
	                  query1 = query1 + " and a.BOOKING_CUSTOMER_ID="+bookingCustomer;
	            }
	            
	            
	            pstmt1 = con.prepareStatement(query1);
                pstmt1.setInt(1, systemId);
                //pstmt1.setInt(2, custId);
                pstmt1.setString(2, consignmentStatus);
                pstmt1.setInt(3, userId);
                rs1 = pstmt1.executeQuery();
	        }
	        while (rs1.next()) {
	            obj1 = new JSONObject();
	            if (rs1.getString("DateTime") == null || rs1.getString("DateTime").equals("") || rs1.getString("DateTime").contains("1900")) {
	                obj1.put("dateTime", "");
	            } else {
	                obj1.put("dateTime", ddmmyyyy.format(rs1.getTimestamp("DateTime")));
	            }
	            obj1.put("regNo", rs1.getString("VehicleNo"));
	            obj1.put("location", rs1.getString("LOCATION"));
	            obj1.put("speed", rs1.getString("SPEED"));
	            obj1.put("latitude", rs1.getString("LATITUDE"));
	            obj1.put("longtitude", rs1.getString("LONGITUDE"));
	            obj1.put("status", rs1.getString("ConsignmentStatus"));
	            JsonArray.put(obj1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt1, rs1);
	    }
	    return JsonArray;
	}	
	
	
	//Block of Code to get data for the consignmentSummary Report after clicking from dashboard.
	public ArrayList < Object > getConsignmentSummaryDetails(int systemId, int custId, String consignmentStatus, String region, String fieldCondition, int userId, String language, String bookingCustomer,String TotalRegion) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs1 = null;
	    ReportHelper finalreporthelper = new ReportHelper();
	    ArrayList < String > headersList = new ArrayList < String > ();
	    ArrayList < Object > finlist = new ArrayList < Object > ();
	    ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
	    SimpleDateFormat ddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	    SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	    DecimalFormat decformat = new DecimalFormat("#0.00");
	    String Dealers = "";
	    String dealersAddress = "";
	    String dealersCity = "";
	    String dealersState = "";
	    String query = "";
	    String query1 = "";
	    String query2 = "";
	    String query3 = "";
	    String query4 = "";
	    String query5 = "";
	    String query6 = "";
	    String query7 = "";
	    String query8 = "";
	    String customerName="";
	    try {
	        headersList.add(cf.getLabelFromDB("SLNO", language));
	        if (custId == 0) {
	        	headersList.add(cf.getLabelFromDB("Customer_Name", language));
            }else
            {
            	headersList.add("");
            }
	        
	        if (bookingCustomer.equals("ALL")) {
	        	headersList.add(cf.getLabelFromDB("Booking_Customer", language));
            }else
            {
            	headersList.add("");
            }
	        
	        headersList.add(cf.getLabelFromDB("Registration_Number", language));
	        headersList.add(cf.getLabelFromDB("Date_Time", language));
	        headersList.add(cf.getLabelFromDB("Current_Location", language));
	        headersList.add(cf.getLabelFromDB("Consignment_Number", language));
	        headersList.add(cf.getLabelFromDB("Status", language));
	        headersList.add(cf.getLabelFromDB("Speed", language));
	        headersList.add(cf.getLabelFromDB("Dealer_Name", language));
	        headersList.add(cf.getLabelFromDB("Dealer_Destination", language));
	        headersList.add(cf.getLabelFromDB("Dealer_City", language));
	        headersList.add(cf.getLabelFromDB("Dealer_State", language));
	        headersList.add(cf.getLabelFromDB("Region", language));
	        headersList.add(cf.getLabelFromDB("Total_Distance", language));
	        headersList.add(cf.getLabelFromDB("Covered_Distance", language));
	        headersList.add(cf.getLabelFromDB("Remaining_Distance", language));
	        
	        if (!region.equals("Total")) {
	            if (!fieldCondition.equals("Vehicles")) {
	                headersList.add(cf.getLabelFromDB("Schedule_Delivery_Date", language));
	                headersList.add(cf.getLabelFromDB("Revised_Delivery_Date", language));
	            } else {
	                headersList.add("");
	                headersList.add("");
	            }
	        } else {
	            headersList.add(cf.getLabelFromDB("Schedule_Delivery_Date", language));
	            headersList.add(cf.getLabelFromDB("Revised_Delivery_Date", language));
	        }
	        
	        
          
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	        if (consignmentStatus.equals("EastFieldBox")) {
	            //This block is for 4boxes East,west,North,South     
	        	if(custId == 0)
	        	{
		            if (consignmentStatus.equals("EastFieldBox")) {
		                query = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_REGION_BOXES;
		            }
		            if (!bookingCustomer.equals("ALL")) {
		                query = query + " and a.BOOKING_CUSTOMER_ID=" + bookingCustomer;
		            }

	        	}else
	        	{	
		            if (consignmentStatus.equals("EastFieldBox")) {
		                query = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_REGION_BOXES + " and a.CUSTOMER_ID=" +custId;
		            }
		            if (!bookingCustomer.equals("ALL")) {
		                query = query + " and a.BOOKING_CUSTOMER_ID=" + bookingCustomer;
		            }
	        	}
	            pstmt = con.prepareStatement(query);
	            pstmt.setInt(1, systemId);
	           // pstmt.setInt(2, custId);
	            pstmt.setString(2, region);
	            pstmt.setInt(3, userId);
	            rs = pstmt.executeQuery();
	        }
	        /*****************************************************************************************************************************************************/
	        else if (region.equals("Total")) {                      /****/
	           if (fieldCondition.equals("Vehicles")) {
	                //This block is for Total and only Vehicles Column.
	        	   
	        	   if(custId == 0)
	        	   {
	        		   if(TotalRegion.equals("ALL"))
		        	   {
		        		   query1 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS;
		        	   }else
		        	   {
		        		   query1 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS + " and a.REGION='" + TotalRegion + "'"; 
		        	   }
	        	   }else
	        	   {
	        		   if(TotalRegion.equals("ALL"))
		        	   {
		        		   query1 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS + " and a.CUSTOMER_ID=" +custId;
		        	   }else
		        	   {
		        		   query1 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS + " and a.REGION='" + TotalRegion + "'" + " and a.CUSTOMER_ID=" +custId; 
		        	   }
	        	   }
	        	   
	                
	                if (!bookingCustomer.equals("ALL")) {
	                    query1 = query1 + " and a.BOOKING_CUSTOMER_ID=" + bookingCustomer;
	                }
	                pstmt = con.prepareStatement(query1);
	                pstmt.setInt(1, systemId);
	                //pstmt.setInt(2, custId);
	                pstmt.setString(2, consignmentStatus);
	                pstmt.setInt(3, userId);
	                rs = pstmt.executeQuery();
	            } 
	            
	            else if (fieldCondition.equals("Delay")) {
	            	
	            	if(custId == 0)
	            	{

		            	 if(TotalRegion.equals("ALL"))
			        	   {
			        		   query2 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DELAY;
			        	   }else
			        	   {
			        		   query2 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DELAY + " and a.REGION='" + TotalRegion + "'";
			        	   }
	            	}else
	            	{

		            	 if(TotalRegion.equals("ALL"))
			        	   {
			        		   query2 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DELAY + " and a.CUSTOMER_ID=" +custId;
			        	   }else
			        	   {
			        		   query2 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DELAY + " and a.REGION='" + TotalRegion + "'" + " and a.CUSTOMER_ID=" +custId;
			        	   }
	            	}
	            	
	                //This block is for Total and only Delay Column.
	                
	                if (!bookingCustomer.equals("ALL")) {
	                    query2 = query2 + " and a.BOOKING_CUSTOMER_ID=" + bookingCustomer;
	                }
	                pstmt = con.prepareStatement(query2);
	                pstmt.setInt(1, systemId);
	              // pstmt.setInt(2, custId);
	                pstmt.setString(2, consignmentStatus);
	                pstmt.setInt(3, userId);
	                rs = pstmt.executeQuery();
	            } 
	            
	            else if (fieldCondition.equals("OnTime")) {
	                //This block is for Total and only OnTime Column.
	            	if(custId == 0)
	            	{
	            		 if(TotalRegion.equals("ALL"))
			        	   {
			        		   query3 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ONTIME;
			        	   }else
			        	   {
			        		   query3 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ONTIME + " and a.REGION='" + TotalRegion + "'";
			        	   }
	            	}else
	            	{
	            		 if(TotalRegion.equals("ALL"))
			        	   {
			        		   query3 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ONTIME + " and a.CUSTOMER_ID=" +custId;
			        	   }else
			        	   {
			        		   query3 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ONTIME + " and a.REGION='" + TotalRegion + "'" + " and a.CUSTOMER_ID=" +custId;
			        	   }
	            	}
	            	
	               
	                if (!bookingCustomer.equals("ALL")) {
	                    query3 = query3 + " and a.BOOKING_CUSTOMER_ID=" + bookingCustomer;
	                }
	                pstmt = con.prepareStatement(query3);
	                pstmt.setInt(1, systemId);
	               // pstmt.setInt(2, custId);
	                pstmt.setString(2, consignmentStatus);
	                pstmt.setInt(3, userId);
	                rs = pstmt.executeQuery();
	            } 
	            
	            else {
	            	
	            	if(custId == 0)
	            	{
	            		 if(TotalRegion.equals("ALL"))
			        	   {
			        		   query4 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ALERTS;
			        	   }else
			        	   {
			        		   query4 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ALERTS + " and a.REGION='" + TotalRegion + "'";
			        	   }
	            	}else
	            	{
	            		 if(TotalRegion.equals("ALL"))
			        	   {
			        		   query4 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ALERTS + " and a.CUSTOMER_ID=" +custId;
			        	   }else
			        	   {
			        		   query4 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ALERTS + " and a.REGION='" + TotalRegion + "'"  + " and a.CUSTOMER_ID=" +custId;
			        	   }
	            	}
	            	
	               
	                if (!bookingCustomer.equals("ALL")) {
	                    query4 = query4 + " and a.BOOKING_CUSTOMER_ID=" + bookingCustomer;
	                }
	                pstmt = con.prepareStatement(query4);
	                pstmt.setInt(1, systemId);
	               // pstmt.setInt(2, custId);
	                pstmt.setString(2, consignmentStatus);
	                pstmt.setInt(3, userId);
	                rs = pstmt.executeQuery();
	            }
	        }
	        /****************************************************************After clicking on cell except the total cells*********************************************************************************************/
	        else {
	            if (fieldCondition.equals("Vehicles")) {
	            	
	            	if(custId == 0)
	            	{
	            		 query5 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS + " and a.REGION='" + region + "'";
	            	}else
	            	{
	            		 query5 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS + " and a.REGION='" + region + "'" + " and a.CUSTOMER_ID=" +custId;
	            	}
	            	
	               
	                if (!bookingCustomer.equals("ALL")) {
	                    query5 = query5 + " and a.BOOKING_CUSTOMER_ID=" + bookingCustomer;
	                }
	                pstmt = con.prepareStatement(query5);
	                pstmt.setInt(1, systemId);
	               // pstmt.setInt(2, custId);
	                pstmt.setString(2, consignmentStatus);
	                pstmt.setInt(3, userId);
	                rs = pstmt.executeQuery();
	            } 
	            
	            else if (fieldCondition.equals("Delay")) {
	            	
	            	if(custId == 0)
	            	{
	            		 query6 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DELAY + " and a.REGION='" + region + "'";
	            	}else
	            	{
	            		 query6 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DELAY + " and a.REGION='" + region + "'" + " and a.CUSTOMER_ID=" +custId;
	            	}
	               
	                if (!bookingCustomer.equals("ALL")) {
	                    query6 = query6 + " and a.BOOKING_CUSTOMER_ID=" + bookingCustomer;
	                }
	                pstmt = con.prepareStatement(query6);
	                pstmt.setInt(1, systemId);
	             //   pstmt.setInt(2, custId);
	                pstmt.setString(2, consignmentStatus);
	                pstmt.setInt(3, userId);
	                rs = pstmt.executeQuery();
	            } 
	            
	            else if (fieldCondition.equals("OnTime")) {
	            	
	            	if(custId == 0)
	            	{
	            		 query7 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ONTIME + " and a.REGION='" + region + "'";
	            	}else
	            	{
	            		 query7 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ONTIME + " and a.REGION='" + region + "'" + " and a.CUSTOMER_ID=" +custId;
	            	}
	            	
	               
	                if (!bookingCustomer.equals("ALL")) {
	                    query7 = query7 + " and a.BOOKING_CUSTOMER_ID=" + bookingCustomer;
	                }
	                pstmt = con.prepareStatement(query7);
	                pstmt.setInt(1, systemId);
	             //   pstmt.setInt(2, custId);
	                pstmt.setString(2, consignmentStatus);
	                pstmt.setInt(3, userId);
	                rs = pstmt.executeQuery();
	            } 
	            
	            else {
	            	
	            	if(custId == 0)
	            	{
	            		query8 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ALERTS + " and a.REGION='" + region + "'";
	            	}else
	            	{
	            		query8 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_ALERTS + " and a.REGION='" + region + "'" + " and a.CUSTOMER_ID=" +custId;
	            	}
	                
	                if (!bookingCustomer.equals("ALL")) {
	                    query8 = query8 + " and a.BOOKING_CUSTOMER_ID=" + bookingCustomer;
	                }
	                pstmt = con.prepareStatement(query8);
	                pstmt.setInt(1, systemId);
	             //   pstmt.setInt(2, custId);
	                pstmt.setString(2, consignmentStatus);
	                pstmt.setInt(3, userId);
	                rs = pstmt.executeQuery();
	            }
	        }
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	            ArrayList < Object > informationList = new ArrayList < Object > ();
	            ReportHelper reporthelper = new ReportHelper();
	            if (!consignmentStatus.equals("EastFieldBox")) {
	            	if(custId == 0)
	            	{
	            		pstmt1 = con.prepareStatement(MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_DELAY2);
	            	}else
	            	{
	            		pstmt1 = con.prepareStatement(MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_DELAY2 + " and c.Client_Id=" +custId);
	            	}
	                pstmt1.setInt(1, systemId);
	              //  pstmt1.setInt(2, custId);
	                pstmt1.setString(2, rs.getString("ConsignmentNumber"));
	                pstmt1.setString(3, consignmentStatus);
	                rs1 = pstmt1.executeQuery();
	                Dealers = "";
	                dealersAddress = "";
	                dealersCity = "";
	                dealersState = "";
	                while (rs1.next()) {
	                    Dealers = Dealers + rs1.getString("DealerName") + ",";
	                    dealersAddress = dealersAddress + rs1.getString("Address") + ",";
	                    dealersCity = dealersCity + rs1.getString("City") + ",";
	                    dealersState = dealersState + rs1.getString("State") + ",";
	                    customerName = rs1.getString("CustomerName");
	                }
	            } else {
	            	if(custId == 0)
	            	{
	            		pstmt1 = con.prepareStatement(MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_DELAY2_FOR_BOXES);
	            	}else
	            	{
	            		pstmt1 = con.prepareStatement(MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_DELAY2_FOR_BOXES + " and c.Client_Id=" +custId);
	            	}
	                pstmt1.setInt(1, systemId);
	             //   pstmt1.setInt(2, custId);
	                pstmt1.setString(2, rs.getString("ConsignmentNumber"));
	                rs1 = pstmt1.executeQuery();
	                Dealers = "";
	                dealersAddress = "";
	                dealersCity = "";
	                dealersState = "";
	                while (rs1.next()) {
	                    Dealers = Dealers + rs1.getString("DealerName") + ",";
	                    dealersAddress = dealersAddress + rs1.getString("Address") + ",";
	                    dealersCity = dealersCity + rs1.getString("City") + ",";
	                    dealersState = dealersState + rs1.getString("State") + ",";
	                    customerName = rs1.getString("CustomerName");
	                }
	            }
	            informationList.add(count);
	            JsonObject.put("slnoIndex", count);
	            
	            JsonObject.put("CustomerNameIndex", customerName);
	            informationList.add(customerName);

	            JsonObject.put("bookingCustomerNameIndex", rs.getString("BookingName"));
	            informationList.add(rs.getString("BookingName"));
	         
	            JsonObject.put("registrationNumberDataIndex", rs.getString("VehicleNo"));
	            informationList.add(rs.getString("VehicleNo"));
	            
	            if (rs.getString("dateTime") == null || rs.getString("dateTime").equals("") || rs.getString("dateTime").contains("1900")) {
	                JsonObject.put("dateTimeDataIndex", "");
	                informationList.add("");
	            } else {
	                JsonObject.put("dateTimeDataIndex", sdf.format(rs.getTimestamp("dateTime")));
	                informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("dateTime")));
	            }
	            
	            JsonObject.put("currentLocationDataIndex", rs.getString("CurrentLocation"));
	            informationList.add(rs.getString("CurrentLocation"));
	            
	            JsonObject.put("consignmentNumberDataIndex", rs.getString("ConsignmentNumber"));
	            informationList.add(rs.getString("ConsignmentNumber"));
	            
	            JsonObject.put("statusDataIndex", rs.getString("Status"));
	            informationList.add(rs.getString("Status"));
	            
	            JsonObject.put("speedDataIndex", rs.getString("Speed"));
	            informationList.add(rs.getString("Speed"));
	            
	            if (Dealers.equals("")) {
	                JsonObject.put("dealerNameDataIndex", "");
	                informationList.add("");
	            } else {
	                JsonObject.put("dealerNameDataIndex", Dealers.substring(0, Dealers.length() - 1));
	                informationList.add(Dealers.substring(0, Dealers.length() - 1));
	            }
	            
	            if (dealersAddress.equals("")) {
	                JsonObject.put("dealerDestinationDataIndex", "");
	                informationList.add("");
	            } else {
	                JsonObject.put("dealerDestinationDataIndex", dealersAddress.substring(0, dealersAddress.length() - 1));
	                informationList.add(dealersAddress.substring(0, dealersAddress.length() - 1));
	            }
	            
	            if (dealersCity.equals("")) {
	                JsonObject.put("dealerCityDataIndex", "");
	                informationList.add("");
	            } else {
	                JsonObject.put("dealerCityDataIndex", dealersCity.substring(0, dealersCity.length() - 1));
	                informationList.add(dealersCity.substring(0, dealersCity.length() - 1));
	            }
	            
	            if (dealersState.equals("")) {
	                JsonObject.put("dealerStateDataIndex", "");
	                informationList.add("");
	            } else {
	                JsonObject.put("dealerStateDataIndex", dealersState.substring(0, dealersState.length() - 1));
	                informationList.add(dealersState.substring(0, dealersState.length() - 1));
	            }
	            
	            JsonObject.put("regionDataIndex", rs.getString("Region"));
	            informationList.add(rs.getString("Region"));
	            
	            float distanceTravelled = rs.getFloat("totalDistance");
	            float coveredDistance = rs.getFloat("distancetravelled");
	            float remainingDistance = distanceTravelled - coveredDistance;
	            
	            JsonObject.put("totalDistanceDataIndex", decformat.format(distanceTravelled));
	            informationList.add(decformat.format(distanceTravelled));
	            
	            JsonObject.put("coveredDistanceDataIndex", decformat.format(coveredDistance));
	            informationList.add(decformat.format(coveredDistance));
	            
	            JsonObject.put("remainingDistanceDataIndex", decformat.format(remainingDistance));
	            informationList.add(decformat.format(remainingDistance));
	            
	            if (rs.getString("scheduledDeliverydate") == null || rs.getString("scheduledDeliverydate").equals("") || rs.getString("scheduledDeliverydate").contains("1900")) {
	                JsonObject.put("scheduledDeliverydateDataIndex", "");
	            } else {
	                JsonObject.put("scheduledDeliverydateDataIndex", sdf.format(rs.getTimestamp("scheduledDeliverydate")));
	            }
	            
	            if (rs.getString("revisedDeliveryDate") == null || rs.getString("revisedDeliveryDate").equals("") || rs.getString("revisedDeliveryDate").contains("1900")) {
	                JsonObject.put("revisedDeliveryDateDataIndex", "");
	            } else {
	                JsonObject.put("revisedDeliveryDateDataIndex", sdf.format(rs.getTimestamp("revisedDeliveryDate")));
	            }
	            
	            if (rs.getString("scheduledDeliverydate") == null || rs.getString("scheduledDeliverydate").equals("") || rs.getString("scheduledDeliverydate").contains("1900")) {
	                JsonObject.put("scheduledDeliverydateDataIndex", "");
	                if (!region.equals("Total")) {
	                    if (fieldCondition.equals("Vehicles")) {
	                        informationList.add("");
	                    } else {
	                        informationList.add("");
	                    }
	                } else {
	                    informationList.add("");
	                }
	            } else {
	                JsonObject.put("scheduledDeliverydateDataIndex", sdf.format(rs.getTimestamp("scheduledDeliverydate")));
	                if (!region.equals("Total")) {
	                    if (fieldCondition.equals("Vehicles")) {
	                        informationList.add("");
	                    } else {
	                        informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("scheduledDeliverydate")));
	                    }
	                } else {
	                    informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("scheduledDeliverydate")));
	                }
	            }
	            
	            if (rs.getString("revisedDeliveryDate") == null || rs.getString("revisedDeliveryDate").equals("") || rs.getString("revisedDeliveryDate").contains("1900")) {
	                JsonObject.put("revisedDeliveryDateDataIndex", "");
	                if (!region.equals("Total")) {
	                    if (fieldCondition.equals("Vehicles")) {
	                        informationList.add("");
	                    } else {
	                        informationList.add("");
	                    }
	                } else {
	                    informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("revisedDeliveryDate")));
	                }
	            } else {
	                JsonObject.put("revisedDeliveryDateDataIndex", sdf.format(rs.getTimestamp("revisedDeliveryDate")));
	                if (!region.equals("Total")) {
	                    if (fieldCondition.equals("Vehicles")) {
	                        informationList.add("");
	                    } else {
	                        informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("revisedDeliveryDate")));
	                    }
	                } else {
	                    informationList.add(ddMMyyyyHHmmss.format(rs.getTimestamp("revisedDeliveryDate")));
	                }
	            }
	            
	         
	            JsonArray.put(JsonObject);
	            reporthelper.setInformationList(informationList);
	            reportsList.add(reporthelper);
	        }
	        finalreporthelper.setReportsList(reportsList);
	        finalreporthelper.setHeadersList(headersList);
	        finlist.add(JsonArray);
	        finlist.add(finalreporthelper);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	    }
	    return finlist;
	}
	
	
	
	 //for whole table
	public JSONArray getConsignmentDetailsForDashBoardTable(int systemId, int custId, String region,String bookingCustomer) {
	    JSONObject JsonObject = null;
	    JSONArray JsonArray = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONObject obj1 = null;
	    int totalLoadVehicleCount = 0;
	    int totalLoadOnTimeCount = 0;
	    int totalLoadDelayCount = 0;
	    int totalLoadAlertsCount = 0;
	    int totalEmptyVehicleCount = 0;
	    int totalEmptyOnTimeCount = 0;
	    int totalEmptyDelayCount = 0;
	    int totalEmptyAlertsCount = 0;
	    int totalReturnVehicleCount = 0;
	    int totalReturnOnTimeCount = 0;
	    int totalReturnDelayCount = 0;
	    int totalReturnAlertsCount = 0;
	    int finalTotalCountForVehicles = 0;
	    int finalTotalCountForOnTime = 0;
	    int finalTotalCountForDelay = 0;
	    int finalTotalCountForAlerts = 0;
	    String query6="";
	    String query7="";
	    try {
	        int count = 0;
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        if(custId == 0)
	        {
	            if (region.equals("ALL")) {
		        	query6 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE_FOR_ALL;
		            
		            if(bookingCustomer.equals("ALL"))
		            {
		            pstmt = con.prepareStatement(MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE_FOR_ALL1 + " group by CONSIGNMENT_STATUS,REGION ");
		           }
		            else if (!bookingCustomer.equals("ALL")) {
	                    query6 = query6 + " and BOOKING_CUSTOMER_ID=" + bookingCustomer;
	                    pstmt = con.prepareStatement(query6);
	                }
		            pstmt.setInt(1, systemId);
	                rs = pstmt.executeQuery();
		        } else {
		        	query7 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE;
		            
		            if(bookingCustomer.equals("ALL"))
		            {
		            	pstmt = con.prepareStatement(MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE_FOR_ALL_FOR_REGION + " group by CONSIGNMENT_STATUS,REGION");
		  	         }
		            else if (!bookingCustomer.equals("ALL")) {
	                    query7 = query7 + " and BOOKING_CUSTOMER_ID=" + bookingCustomer;
	                    pstmt = con.prepareStatement(query7);
	    	            } 
		            pstmt.setInt(1, systemId);
		            pstmt.setString(2, region);
		            rs = pstmt.executeQuery();
		        }
	        }
	        
	        
	        
	        else
	        {
	        if (region.equals("ALL")) {
	        	query6 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE_FOR_ALL + " and CUSTOMER_ID=" +custId;
	            
	            if(bookingCustomer.equals("ALL"))
	            {
	            pstmt = con.prepareStatement(MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE_FOR_ALL1 + " and CUSTOMER_ID=" +custId + " group by CONSIGNMENT_STATUS,REGION ");
	           }
	            else if (!bookingCustomer.equals("ALL")) {
                    query6 = query6 + " and BOOKING_CUSTOMER_ID=" + bookingCustomer + " group by  CONSIGNMENT_STATUS,REGION,ASSET_COUNT,ON_TIME_COUNT,DELAY_COUNT,ALERTS_COUNT ";
                    pstmt = con.prepareStatement(query6);
                }
	            pstmt.setInt(1, systemId);
	          //  pstmt.setInt(2, custId);
                rs = pstmt.executeQuery();
	        } else {
	        	query7 = MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE + " and CUSTOMER_ID=" +custId;
	            
	            if(bookingCustomer.equals("ALL"))
	            {
	            	pstmt = con.prepareStatement(MapViewStatements.GET_CONSIGNMENT_SUMMARY_DETAILS_FOR_DASHBOARD_TABLE_FOR_ALL_FOR_REGION + " and CUSTOMER_ID=" +custId+ " group by CONSIGNMENT_STATUS,REGION");
	  	         }
	            else if (!bookingCustomer.equals("ALL")) {
                    query7 = query7 + " and BOOKING_CUSTOMER_ID=" + bookingCustomer ;
                    pstmt = con.prepareStatement(query7);
    	            } 
	            pstmt.setInt(1, systemId);
	           // pstmt.setInt(2, custId);
	            pstmt.setString(2, region);
	            rs = pstmt.executeQuery();
	        }
	      }
	        while (rs.next()) {
	            obj1 = new JSONObject();
	            count++;
	            obj1.put("vehicles", rs.getString("vehicles"));
	            obj1.put("onTime", rs.getString("onTime"));
	            obj1.put("delay", rs.getString("delay"));
	            obj1.put("alerts", rs.getString("alerts"));
	            obj1.put("consignmentStatus", rs.getString("consignmentStatus"));
	            obj1.put("region", rs.getString("region"));
	            //to get the total count for all data
	            if (region.equals("ALL")) {
	                if (rs.getString("consignmentStatus").equals("Load")) {
	                    totalLoadVehicleCount = totalLoadVehicleCount + rs.getInt("vehicles");
	                    totalLoadOnTimeCount = totalLoadOnTimeCount + rs.getInt("onTime");
	                    totalLoadDelayCount = totalLoadDelayCount + rs.getInt("delay");
	                    totalLoadAlertsCount = totalLoadAlertsCount + rs.getInt("alerts");
	                }
	                if (rs.getString("consignmentStatus").equals("Empty")) {
	                    totalEmptyVehicleCount = totalEmptyVehicleCount + rs.getInt("vehicles");
	                    totalEmptyOnTimeCount = totalEmptyOnTimeCount + rs.getInt("onTime");
	                    totalEmptyDelayCount = totalEmptyDelayCount + rs.getInt("delay");
	                    totalEmptyAlertsCount = totalEmptyAlertsCount + rs.getInt("alerts");
	                }
	                if (rs.getString("consignmentStatus").equals("Return Load")) {
	                    totalReturnVehicleCount = totalReturnVehicleCount + rs.getInt("vehicles");
	                    totalReturnOnTimeCount = totalReturnOnTimeCount + rs.getInt("onTime");
	                    totalReturnDelayCount = totalReturnDelayCount + rs.getInt("delay");
	                    totalReturnAlertsCount = totalReturnAlertsCount + rs.getInt("alerts");
	                }
	                //to get final total
	                finalTotalCountForVehicles = totalLoadVehicleCount + totalEmptyVehicleCount + totalReturnVehicleCount;
	                finalTotalCountForOnTime = totalLoadOnTimeCount + totalEmptyOnTimeCount + totalReturnOnTimeCount;
	                finalTotalCountForDelay = totalLoadDelayCount + totalEmptyDelayCount + totalReturnDelayCount;
	                finalTotalCountForAlerts = totalLoadAlertsCount + totalEmptyAlertsCount + totalReturnAlertsCount;
	            } else {
	                totalLoadVehicleCount = rs.getInt("vehicles");
	                totalLoadOnTimeCount = rs.getInt("onTime");
	                totalLoadDelayCount = rs.getInt("delay");
	                totalLoadAlertsCount = rs.getInt("alerts");
	                totalEmptyVehicleCount = rs.getInt("vehicles");
	                totalEmptyOnTimeCount = rs.getInt("onTime");
	                totalEmptyDelayCount = rs.getInt("delay");
	                totalEmptyAlertsCount = rs.getInt("alerts");
	                totalReturnVehicleCount = rs.getInt("vehicles");
	                totalReturnOnTimeCount = rs.getInt("onTime");
	                totalReturnDelayCount = rs.getInt("delay");
	                totalReturnAlertsCount = rs.getInt("alerts");
	                finalTotalCountForVehicles = finalTotalCountForVehicles + totalLoadVehicleCount;
	                finalTotalCountForOnTime = finalTotalCountForOnTime + totalLoadOnTimeCount;
	                finalTotalCountForDelay = finalTotalCountForDelay + totalLoadDelayCount;
	                finalTotalCountForAlerts = finalTotalCountForAlerts + totalLoadAlertsCount;
	            }
	            obj1.put("totalLoadVehicleCount", totalLoadVehicleCount);
	            obj1.put("totalLoadOnTimeCount", totalLoadOnTimeCount);
	            obj1.put("totalLoadDelayCount", totalLoadDelayCount);
	            obj1.put("totalLoadAlertsCount", totalLoadAlertsCount);
	            obj1.put("totalEmptyVehicleCount", totalEmptyVehicleCount);
	            obj1.put("totalEmptyOnTimeCount", totalEmptyOnTimeCount);
	            obj1.put("totalEmptyDelayCount", totalEmptyDelayCount);
	            obj1.put("totalEmptyAlertsCount", totalEmptyAlertsCount);
	            obj1.put("totalReturnVehicleCount", totalReturnVehicleCount);
	            obj1.put("totalReturnOnTimeCount", totalReturnOnTimeCount);
	            obj1.put("totalReturnDelayCount", totalReturnDelayCount);
	            obj1.put("totalReturnAlertsCount", totalReturnAlertsCount);
	            obj1.put("finalTotalCountForVehicles", finalTotalCountForVehicles);
	            obj1.put("finalTotalCountForOnTime", finalTotalCountForOnTime);
	            obj1.put("finalTotalCountForDelay", finalTotalCountForDelay);
	            obj1.put("finalTotalCountForAlerts", finalTotalCountForAlerts);
	            JsonArray.put(obj1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}

	
	
	
	public String insertCustomerInformation(int custId, String customer_id,String name,String email,String phone,String mobile,String fax,String tin,String address,String city,String userid,String password,String state,String region,String status,int userId,int systemId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        
	        pstmt = con.prepareStatement(MapViewStatements.CHECK_IF_USER_ID_ALREADY_EXISTS);
	        pstmt.setString(1, userid);

	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            message = "User Id Already Exists";
	        } else {
	        pstmt = con.prepareStatement(MapViewStatements.INSERT_CUSTOMER_INFORMATION);
	        pstmt.setString(1, customer_id);
	        pstmt.setString(2, name.toUpperCase());
	        pstmt.setString(3, email);
	        pstmt.setString(4, phone);
	        pstmt.setString(5, mobile);
	        pstmt.setString(6, fax);
	        pstmt.setString(7, tin);
	        pstmt.setString(8, address);
	        pstmt.setString(9, city);
	        pstmt.setString(10, userid);
	        pstmt.setString(11, password);
	        pstmt.setString(12, state);
	        pstmt.setString(13, region);
            pstmt.setString(14, status);
            pstmt.setInt(15, custId);
            pstmt.setInt(16, systemId);
            pstmt.setInt(17, userId);
	        int inserted = pstmt.executeUpdate();
	        if (inserted > 0) {
	            message = "Saved Successfully";
	        }
	    }
	        } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return message;
	}

	
	public String modifyCustomerInformation(int custId, String customer_id,String name,String email,String phone,String mobile,String fax,String tin,String address,String city,String userid,String password,String state,String region,String status,int systemId,int uniqueId,int userId) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String message = "";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(MapViewStatements.CHECK_IF_USER_ID_ALREADY_EXISTS+" and ID!=? ");
	        pstmt.setString(1, userid);
	        pstmt.setInt(2, uniqueId);
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            message = "User Id Already Exists";
	        } else {
	        pstmt = con.prepareStatement(MapViewStatements.UPDATE_CUSTOMER_INFORMATION);
	        pstmt.setString(1, customer_id);
	        pstmt.setString(2, name.toUpperCase());
	        pstmt.setString(3, email);
	        pstmt.setString(4, phone);
	        pstmt.setString(5, mobile);
	        pstmt.setString(6, fax);
	        pstmt.setString(7, tin);
	        pstmt.setString(8, address);
	        pstmt.setString(9, city);
	        pstmt.setString(10, userid);
	        pstmt.setString(11, password);
	        pstmt.setString(12, state);
	        pstmt.setString(13, region);
            pstmt.setString(14, status);
            pstmt.setInt(15, userId);
            pstmt.setFloat(16, systemId);
            pstmt.setInt(17, custId);
	        pstmt.setInt(18, uniqueId);
	        int updated = pstmt.executeUpdate();
                    if (updated > 0) {
                         message = "Updated Successfully";
                    }
	    }
	    }catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	    	DBConnection.releaseConnectionToDB(con, pstmt, rs);
	        
	    }
	    return message;
	}
	
	public ArrayList < Object > getBookingCustomerReport(int clientId, int systemid,int userId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
		ArrayList < Object > finlist = new ArrayList < Object > ();
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("AMS");
	            pstmt = con.prepareStatement(MapViewStatements.GET_BOOKING_CUSTOMER_DETAILS);
	            pstmt.setInt(1, systemid);
	            pstmt.setInt(2, clientId);
	            rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	        	ArrayList<Object> informationList = new ArrayList<Object>();
				ReportHelper reporthelper = new ReportHelper();
				
	        	informationList.add(count);
			    JsonObject.put("slnoIndex", count);
			   
	            JsonObject.put("customerIdDataIndex", rs.getString("BOOKING_CUSTOMER_ID"));
	            
 	            JsonObject.put("customerNameDataIndex", rs.getString("BOOKING_CUSTOMER_NAME"));
 	          
	            JsonObject.put("emailDataIndex", rs.getString("EMAIL_ID"));
	           
	            JsonObject.put("phoneDataIndex", rs.getString("PHONE_NO"));
	           
	            JsonObject.put("mobileDataIndex", rs.getString("MOBILE_NO"));
	           
	            JsonObject.put("faxDataIndex", rs.getString("FAX"));
	           
				JsonObject.put("tinDataIndex", rs.getString("TIN"));
				
				JsonObject.put("addressDataIndex", rs.getString("ADDRESS"));
				
				JsonObject.put("cityDataIndex", rs.getString("CITY"));
				
				JsonObject.put("stateDataIndex", rs.getString("STATE_NAME"));
				
				JsonObject.put("uniqueIdDataIndex", rs.getString("ID"));
				
				JsonObject.put("stateIdDataIndex", rs.getString("STATE"));
				
				JsonObject.put("regionDataIndex", rs.getString("REGION"));
				
				JsonObject.put("statusDataIndex", rs.getString("STATUS"));
				
				JsonObject.put("userIdDataIndex", rs.getString("USER_ID"));
			
				JsonObject.put("passwordDataIndex", rs.getString("PASSWORD"));
			
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
	

	
	//Block of code to get the count for east,west,north,south boxes in the dashboard
	public JSONArray getCountForBoxes(int systemId, int custId, String region,int userId,String bookingCustomer,String transporter) {
	    JSONObject JsonObject = null;
	    JSONArray JsonArray = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    //ResultSet rs = null;
	    ResultSet rs = null;
	    JSONObject obj1 = null;
	    String query3="";
	    String query4="";
	    String status[] = {
	        "East", "West", "North", "South"
	    };
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        obj1 = new JSONObject();
	        if (region.equals("ALL")) {
	            for (int i = 0; i < status.length; i++) {
	            	
	            	if(custId == 0)
	            	{
	            		query3 = MapViewStatements.GET_COUNT_OF_VEHICLES_FOR_REGION_ALL ;
	            	}
	            	else
	            	{
	                query3 = MapViewStatements.GET_COUNT_OF_VEHICLES_FOR_REGION_ALL + " and CUSTOMER_ID=" +custId ;
	            	}
	            	
	                if(!bookingCustomer.equals("ALL"))
		            {
		                  query3 = query3 + " and a.BOOKING_CUSTOMER_ID="+bookingCustomer;
		            }
		            
		            query3 = query3 + " group by c.Region order by c.Region ";
		            pstmt = con.prepareStatement(query3);
	                pstmt.setInt(1, systemId);
	                //pstmt.setInt(2, custId);
	                pstmt.setInt(2, userId);
	                pstmt.setString(3, status[i]);
	                rs = pstmt.executeQuery();
	                if (rs.next()) {
	                    obj1 = new JSONObject();
	                    if (status[i].equals("East")) {
	                        obj1.put("eastVehiclesCount", rs.getString("VehiclesCount"));
	                    } else if (status[i].equals("West")) {
	                        obj1.put("westVehiclesCount", rs.getString("VehiclesCount"));
	                    } else if (status[i].equals("North")) {
	                        obj1.put("northVehiclesCount", rs.getString("VehiclesCount"));
	                    } else if (status[i].equals("South")) {
	                        obj1.put("southVehiclesCount", rs.getString("VehiclesCount"));
	                    }
	                } else {
	                	
	                    if (status[i].equals("East")) {
	                        obj1.put("eastVehiclesCount", "0");
	                    }
	                    if (status[i].equals("West")) {
	                        obj1.put("westVehiclesCount", "0");
	                    }
	                    if (status[i].equals("North")) {
	                        obj1.put("northVehiclesCount", "0");
	                    }
	                    if (status[i].equals("South")) {
	                        obj1.put("southVehiclesCount", "0");
	                    }
	                }
	                JsonArray.put(obj1);
	            }
	        } else {
	        	if(custId == 0)
            	{
	        		query4 = MapViewStatements.GET_COUNT_OF_VEHICLES;
            	}else
            	{
	        	query4 = MapViewStatements.GET_COUNT_OF_VEHICLES + " and CUSTOMER_ID=" +custId ;
            	}
	        	if(!bookingCustomer.equals("ALL"))
	            {
	                  query4 = query4 + " and a.BOOKING_CUSTOMER_ID="+bookingCustomer;
	            }
	            
	        	
	            query4 = query4 + " group by c.Region order by c.Region";
	            pstmt = con.prepareStatement(query4);
	            pstmt.setInt(1, systemId);
	            //pstmt.setInt(2, custId);
	            pstmt.setInt(2, userId);
	            pstmt.setString(3, region);
	            rs = pstmt.executeQuery();
	            if (rs.next()) {
	                obj1 = new JSONObject();
	                if (region.equals("East")) {
	                    obj1.put("eastVehiclesCount", rs.getString("VehiclesCount"));
	                    obj1.put("westVehiclesCount", "0");
	                    obj1.put("northVehiclesCount", "0");
	                    obj1.put("southVehiclesCount", "0");
	                } else if (region.equals("West")) {
	                    obj1.put("westVehiclesCount", rs.getString("VehiclesCount"));
	                    obj1.put("eastVehiclesCount", "0");
	                    obj1.put("northVehiclesCount", "0");
	                    obj1.put("southVehiclesCount", "0");
	                } else if (region.equals("North")) {
	                    obj1.put("northVehiclesCount", rs.getString("VehiclesCount"));
	                    obj1.put("eastVehiclesCount", "0");
	                    obj1.put("westVehiclesCount", "0");
	                    obj1.put("southVehiclesCount", "0");
	                } else if (region.equals("South")) {
	                    obj1.put("southVehiclesCount", rs.getString("VehiclesCount"));
	                    obj1.put("eastVehiclesCount", "0");
	                    obj1.put("westVehiclesCount", "0");
	                    obj1.put("northVehiclesCount", "0");
	                }
	            } else {
	                obj1 = new JSONObject();
	                obj1.put("eastVehiclesCount", "0");
	                obj1.put("westVehiclesCount", "0");
	                obj1.put("northVehiclesCount", "0");
	                obj1.put("southVehiclesCount", "0");
	            }
	            JsonArray.put(obj1);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}    

	public JSONArray getGroupNameList(int systemId, int clientId, int userId) {
	    JSONArray JsonArray = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONObject JsonObject = new JSONObject();
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(MapViewStatements.SELECT_GROUP_LIST);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, clientId);
	        pstmt.setInt(3, userId);
	        rs = pstmt.executeQuery();
	        JsonObject.put("groupId", "0");
	        JsonObject.put("groupName", "ALL");
	        JsonArray.put(JsonObject);
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            JsonObject.put("groupId", rs.getString("GROUP_ID"));
	            JsonObject.put("groupName", rs.getString("GROUP_NAME"));
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	
	public JSONArray getBookingCustomer(int systemId, int clientId, String region) {
	    JSONArray JsonArray = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONObject JsonObject = new JSONObject();
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        if(clientId == 0)
	        {
	            pstmt = con.prepareStatement(MapViewStatements.SELECT_BOOKING_CUSTOMER_LIST_FOR_ALL);
		        pstmt.setInt(1, systemId);
		     
	        }else
	        {
	        	 pstmt = con.prepareStatement(MapViewStatements.SELECT_BOOKING_CUSTOMER_LIST);
	        	 pstmt.setInt(1, clientId);
	  	         pstmt.setInt(2, systemId);
	  	     
	        }
	     //   pstmt.setString(1, region);
	         rs = pstmt.executeQuery();
	        JsonObject.put("bookingCustId", "0");
	        JsonObject.put("bookingCustName", "ALL");
	        JsonArray.put(JsonObject);
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            JsonObject.put("bookingCustId", rs.getString("ID"));
	            JsonObject.put("bookingCustName", rs.getString("BOOKING_CUSTOMER_NAME"));
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
		

}	

	public JSONArray getCustomer(int SystemId, String ltsp, int customerID, String LtspIdForNissan, int isLtsp) {
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONObject JsonObject = new JSONObject();
	    JSONArray JsonArray = null;
	    String systemIdList[] = {
	        ""
	    };
	    try {
	        jsonArray = new JSONArray();
	        jsonObject = new JSONObject();
	        if (LtspIdForNissan != null) {
	            if (LtspIdForNissan.contains(",")) {
	                systemIdList = LtspIdForNissan.split(",");
	            } else {
	                systemIdList[0] = LtspIdForNissan;
	            }
	        }
	        conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
	                if (isLtsp == 0 && LtspIdForNissan.contains("'"+SystemId+"'")) {
	                        pstmt = conAdmin.prepareStatement(MapViewStatements.GET_CUSTOMER);
	                        pstmt.setInt(1, SystemId);
	                } else {
	                	// if Client Login
	                        pstmt = conAdmin.prepareStatement(MapViewStatements.GET_CUSTOMER_FOR_LOGGED_CUST);
	                        pstmt.setInt(1, SystemId);
	                        pstmt.setInt(2, customerID);
	                }
	    	           
	        rs = pstmt.executeQuery();
               //if we want to give option to select whole ltsp
	        if (ltsp.equals("yes")) {
	            jsonObject = new JSONObject();
	            jsonObject.put("CustId", 0);
	            jsonObject.put("CustName", "LTSP");
	            jsonArray.put(jsonObject);
	        }
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            int custId = rs.getInt("CUSTOMER_ID");
	            String custName = rs.getString("NAME");
	            String status = rs.getString("STATUS");
	            String activationstatus = rs.getString("ACTIVATION_STATUS");
	            jsonObject.put("CustId", custId);
	            jsonObject.put("CustName", custName);
	            jsonObject.put("Status", status);
	            jsonObject.put("ActivationStatus", activationstatus);
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}
	
	public JSONArray getCustomersForDashBoard(int SystemId, String ltsp, int customerID, String LtspIdForNissan, int isLtsp) {
	    JSONArray jsonArray = new JSONArray();
	    JSONObject jsonObject = new JSONObject();
	    Connection conAdmin = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    JSONObject JsonObject = new JSONObject();
	    JSONArray JsonArray = null;
	    String systemIdList[] = {
	        ""
	    };
	    try {
	        jsonArray = new JSONArray();
	        jsonObject = new JSONObject();
	        if (LtspIdForNissan != null) {
	            if (LtspIdForNissan.contains(",")) {
	                systemIdList = LtspIdForNissan.split(",");
	            } else {
	                systemIdList[0] = LtspIdForNissan;
	            }
	        }
	        conAdmin = DBConnection.getConnectionToDB("ADMINISTRATOR");
	                if (isLtsp == 0 && LtspIdForNissan.contains("'"+SystemId+"'")) {
	                        pstmt = conAdmin.prepareStatement(MapViewStatements.GET_CUSTOMER);
	                        pstmt.setInt(1, SystemId);
	                } else {
	                	// if Client Login
	                        pstmt = conAdmin.prepareStatement(MapViewStatements.GET_CUSTOMER_FOR_LOGGED_CUST);
	                        pstmt.setInt(1, SystemId);
	                        pstmt.setInt(2, customerID);
	                }
	    	           
	        rs = pstmt.executeQuery();
	        if(isLtsp == 0)
	        {
	        jsonObject.put("CustId", "0");
	        jsonObject.put("CustName", "ALL");
	        jsonArray.put(jsonObject);
	        }
	        if (ltsp.equals("yes")) {
	            jsonObject = new JSONObject();
	            jsonObject.put("CustId", 0);
	            jsonObject.put("CustName", "LTSP");
	            jsonArray.put(jsonObject);
	        }
	        while (rs.next()) {
	            jsonObject = new JSONObject();
	            int custId = rs.getInt("CUSTOMER_ID");
	            String custName = rs.getString("NAME");
	            String status = rs.getString("STATUS");
	            String activationstatus = rs.getString("ACTIVATION_STATUS");
	            jsonObject.put("CustId", custId);
	            jsonObject.put("CustName", custName);
	            jsonObject.put("Status", status);
	            jsonObject.put("ActivationStatus", activationstatus);
	            jsonArray.put(jsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
	    }
	    return jsonArray;
	}

	public JSONArray getMapViewBorders(int customerId, int systemId,String zone) {

		JSONArray borderArray = new JSONArray();
		JSONObject borderObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			borderArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			if(customerId==0){
				pstmt = con.prepareStatement(MapViewStatements.GET_BORDERS_FOR_LTSP_MAP.replace("LOCATION_ZONE","LOCATION_ZONE_"+zone));			
				pstmt.setInt(1, systemId);
			}else{
				pstmt = con.prepareStatement(MapViewStatements.GET_BORDERS_FOR_MAP.replace("LOCATION_ZONE","LOCATION_ZONE_"+zone));
				pstmt.setInt(1, customerId);
				pstmt.setInt(2, systemId);
			}			
			rs = pstmt.executeQuery();
			while (rs.next()) {
				borderObject = new JSONObject();
				borderObject.put("borderName", rs.getString("NAME"));
				borderObject.put("latitude", rs.getString("LATITUDE"));
				borderObject.put("longitude", rs.getString("LONGITUDE"));
				borderObject.put("borderSequence", rs.getString("SEQUENCE_ID"));
				borderObject.put("borderHubid", rs.getString("HUBID"));
				borderObject.put("lat", rs.getString("LAT"));
				borderObject.put("long", rs.getString("LONG"));
				borderObject.put("borderRadius", rs.getString("RADIUS"));
				borderArray.put(borderObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return borderArray;
	}
	//*************************************************SPEED and STOPPAGE*****************************************************//
	
	
	public double stoppageTime(String stop)
	{
	
	double stopValue=0.0;
	if(stop!=null)
	{
	String vehDetails[] = new String[2];

	String arr[]=stop.split("@");


	if(arr.length>0)
	{
	vehDetails[0] = arr[0];
	vehDetails[1]=arr[1];
	}

	if("stoppage".equals(vehDetails[0])){
	double d = Double.parseDouble(vehDetails[1]);

	int hrs = (int)d;
	int min = (int)((d - hrs) * 60);
	String idletime="0.0";
	if(min < 10){
	idletime=String.valueOf(hrs)+".0"+String.valueOf(min);
	}else{
	idletime=String.valueOf(hrs)+"."+String.valueOf(min);
	}
	if (idletime!=null) {
	stopValue=Double.parseDouble(idletime);
	} else {
	stopValue=0.0;
	}
	}

	}

	return stopValue;
	}
	public double idleTime(String idle)
	{
	double d=0.0;
	double idleValue=0.0;
	if(idle!=null)
	{
	String vehDetails[] = new String[2];

	String arr[]=idle.split("@");


	if(arr.length>0)
	{
	vehDetails[0] = arr[0];
	vehDetails[1]=arr[1];
	}

	
	if("idle".equals(vehDetails[0])){
	d = Double.parseDouble(vehDetails[1]);
	
	int hrs = (int)d;
	int min = (int)((d - hrs) * 60);
	String idletime="0.0";
	if(min < 10){
	idletime=String.valueOf(hrs)+".0"+String.valueOf(min);
	}else{
	idletime=String.valueOf(hrs)+"."+String.valueOf(min);
	}
	if (idletime!=null) {
	idleValue=Double.parseDouble(idletime);
	} else {
	idleValue=0.0;
	}
	}
	}

	return idleValue;
	}

	public double stoppageTimeInHHMM(String stop){
		double d = Double.parseDouble(stop);
		double value=0;

		int hrs = (int)d;
		int min = (int)((d - hrs) * 60);
		String idletime="0.0";
		if(min < 10){
		  idletime=String.valueOf(hrs)+".0"+String.valueOf(min);
		}else{
		  idletime=String.valueOf(hrs)+"."+String.valueOf(min);
		}
		if (idletime!=null) {
			value=Double.parseDouble(idletime);
		} else {
			value=0.0;
		}
		return value;
		}
	
 public double getEngineHours(double ingineHrs)
 {
	            String engineHrsStr="0.0";
	            if(ingineHrs!=0){
		        double engineHrs = ingineHrs;
		 		int hrs = (int)engineHrs;
		 		int min = (int)((engineHrs - hrs) * 60);
		 	    
		 		if(min < 10){
		 			engineHrsStr=String.valueOf(hrs)+".0"+String.valueOf(min);
		 		}
		 		else{
		 			engineHrsStr=String.valueOf(hrs)+"."+String.valueOf(min);
		 		} 
		 	
	   }
	        return Double.parseDouble(engineHrsStr);
 }
 public Hashtable getACIONumberForAllVehicle(Connection con,PreparedStatement pstmt,ResultSet rs,int systemId)
	{
		Hashtable acStatusTable=new Hashtable();
		try
		{
				pstmt=con.prepareStatement(MapViewStatements.GET_ACIO_COLUMN_NAME);
				// ALERT ID for AC ON/OFF is 47 in ALERT_MASTER_DETAILS , if it is changed in database to make 
				// here alse you have to change the below statement to make online data window work properly
				//pstmt.setInt(1,alertId);
				pstmt.setInt(1,systemId);
				rs = pstmt.executeQuery();
				while(rs.next())
				{   				
					String registrationNo=rs.getString("REGISTRATION_NO");
					//System.out.println("registrationNo:"+registrationNo);
					int alertVal=rs.getInt("ALERTID");
					//System.out.println("alertid:"+alertVal);
					String ioColName=rs.getString("IONO");
					//System.out.println("ioColName:"+ioColName);
					String key=registrationNo+"-"+alertVal;
					//System.out.println("key:"+key);
					acStatusTable.put(key,ioColName);
				}  
				//System.out.println("acStatusTable:"+acStatusTable);
		}
		catch(Exception e)
		{
			//e.printStackTrace();
			System.out.println("Exception in getACIONumberForAllVehicle():"+e);
		}
		return acStatusTable;
	}
 public boolean getACStatusForVehicle(String regNo, String ioColName,int io3,int io4,int io5,int io6,int io7){
		
		boolean acStatus = false;
		try{
			if(ioColName.equals("IO3")){
			if(io3==1)
			acStatus = true;
			}
			else if(ioColName.equals("IO4")){
			if(io4==1)
			acStatus = true;
			}
			else if(ioColName.equals("IO5")){
			if(io5==1)
			acStatus = true;
			}
			else if(ioColName.equals("IO6")){
			if(io6==1)
			acStatus = true;
			}else if(ioColName.equals("IO7")){
			if(io7==1)
			acStatus = true;
			}
			else{
			acStatus = false;
			}
			
		}
		catch(Exception e){
			//e.printStackTrace();
			System.out.println("Exception in getACStatusForVehicle():"+e);
		}
		return acStatus;
	}	
 
public String getTaxiMeterStatusForVehicle(String regNo, String ioColName,int io3,int io4,int io5,int io6,int io7){
		
		String acStatus = "";
		try{
			if(ioColName.equals("IO3")){
			if(io3==1)
			acStatus = "MeterOff";
			else
			acStatus = "MeterOn";	
			}
			else if(ioColName.equals("IO4")){
			if(io4==1)
			acStatus = "MeterOff";
			else
			acStatus = "MeterOn";	
			}
			else if(ioColName.equals("IO5")){
			if(io5==1)
			acStatus = "MeterOff";
			else
			acStatus = "MeterOn";	
			}
			else if(ioColName.equals("IO6")){
			if(io6==1)
			acStatus = "MeterOff";
			else
			acStatus = "MeterOn";	
			}else if(ioColName.equals("IO7")){
			if(io7==1)
			acStatus = "MeterOff";
			else
			acStatus = "MeterOn";	
			}
			}
		catch(Exception e){
			//e.printStackTrace();
			System.out.println("Exception in getACStatusForVehicle():"+e);
		}
		return acStatus;
	}
	
public double getAcHours(int achrs,boolean acHrsCheck ){
        
	    int hrs = achrs/60;
		int min = achrs%60;
		double achours=0.0;
	    String acHrsStr="0.0";
		if(min < 10){
			acHrsStr=String.valueOf(hrs)+".0"+String.valueOf(min);
		}
		else{
			acHrsStr=String.valueOf(hrs)+"."+String.valueOf(min);
		} 
		if(acHrsCheck)
		{
		if (acHrsStr!=null) {
		   achours=Double.parseDouble(acHrsStr);	
		} 
		}
		
return achours;		
}

public String changeDateFormat(String inputDate) {
	String dDateTime = "";
	// String pDate="";

	SimpleDateFormat sdfFormatDate = new SimpleDateFormat(
			"yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

	try {
		if (inputDate != null && !inputDate.equals("")) {
			Date DateTime = sdfFormatDate.parse(inputDate);
			dDateTime = sdf.format(DateTime);

		}

	} catch (Exception e) {
		System.out.println("Error in changeDateFormat method" + e);
	}
	// System.out.println("dDateTime:"+dDateTime);
	return dDateTime;
}

public enum LiveVisionHeaders {
	AC,
	AC_HOURS,
	Border_Status,
	Customer_Name,
	Date_Time,
	Door_Status,
	Driver_Name,
	Driver_Number,
	Engine_2_Hours,
	Engine_Hours,
	GMT,
	IDLETIME_ALERT,
	Ignition,
	Ignition_2,
	Location,
	Owner_Name,
	Remarks,
	Speed,
	Status,
	STOPPAGE_TIME_ALERT,
	TAXIMETER,
	Trip_Name,
	Trip_Start_Date,
	Vehicle_Group,
	Vehicle_Id,
	Vehicle_Model,
	Vehicle_No,
	Vehicle_Status,
	Vehicle_Type,
	Booking_Customer,
	Container_No,
	Fuel_Guage,
	Temperature,
	Beacon_On_Of_Time,
	Odometer,
	Seat_Belt,
	IB_Voltage,
	Battery_Voltage,
	AD_Light,
	Vehicle_Image,
	Person_Status,
	Direction,
	Internal_Battery_Voltage,
	OBD_Type,
	Operating_On_Mine,
	Fuel_Litre,
	Last_Fuel_Time,
	Trip_No,
	Route_Name,
	LR_No,
	Trip_Customer,
	Temp_info_for_TCL,
	Set_Temp_limits_for_on_trip,
	ETP,
	ATP,
	ETA,
	ATA,
	City,
	Ageing,
	OBD_Odometer,
	OBD_DateTime,
	OBD_CONNECTION_STATUS
}
//Speed_Odometer

public JSONArray getContainerCargoManagementDetails(int systemId, String containerNo, String iP, String remostHost, String bookingNo, int customerId) {

	Connection con = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	ResultSet rs1 = null;
	JSONObject obj = new JSONObject();
	JSONArray jsonArray = new JSONArray();

	try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement(MapViewStatements.GET_CONTAINER_DETAILS);
		pstmt.setString(1, containerNo);
		pstmt.setString(2, bookingNo);
		pstmt.setInt(3, systemId);
		pstmt.setInt(4, customerId);
		rs = pstmt.executeQuery();

		if(rs.next()){
			systemId = rs.getInt("SystemId");
			String regNo = rs.getString("VehicleNo");
			String contNo = rs.getString("ContainerNo");
			String bNo = rs.getString("BookingId");
			String consignmentNumber = bNo + "-" +contNo;

			//get live details

			pstmt = con.prepareStatement(MapViewStatements.GET_OTHER_DETAILS_FROM_gpsdata_history_latest);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setString(3, regNo);
			rs1 = pstmt.executeQuery();
			if(rs1.next()){
				obj.put("location", rs1.getString("LOCATION"));
				if (rs1.getString("GPS_DATETIME") == null || rs1.getString("GPS_DATETIME").equals("") || rs1.getString("GPS_DATETIME").contains("1900")) {
					obj.put("dateTime", "");
				} else {
					obj.put("dateTime", ddmmyyyy.format(rs1.getTimestamp("GPS_DATETIME")));
				}

				obj.put("speed", rs1.getString("SPEED"));
				obj.put("latitude", rs1.getString("LATITUDE"));
				obj.put("longtitude", rs1.getString("LONGITUDE"));
				obj.put("category", rs1.getString("CATEGORY"));
				String ignition=rs1.getString("IGNITION");
				
				if(ignition.equals("0")) {
					ignition="OFF";
				} else {
					ignition="ON";
				}
				
				obj.put("ignition", ignition);
				obj.put("regNo", regNo);
				obj.put("ConsignmentNo", consignmentNumber);
				jsonArray.put(obj);
			} else {
				obj.put("location", "");
				obj.put("dateTime", "");
				obj.put("speed", "");
				obj.put("latitude", "");
				obj.put("longtitude", "");
				obj.put("category", "");
				obj.put("ignition", "");
				obj.put("regNo", "");
				obj.put("ConsignmentNo", "");
				jsonArray.put(obj);
			}
		} else {
			obj.put("location", "");
			obj.put("dateTime", "");
			obj.put("speed", "");
			obj.put("latitude", "");
			obj.put("longtitude", "");
			obj.put("category", "");
			obj.put("ignition", "");
			obj.put("regNo", "");
			obj.put("ConsignmentNo", "");
			jsonArray.put(obj);
		}
		
	} catch (Exception e) {
		e.printStackTrace();
	} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, null, rs1);
	}
	return jsonArray;
}
	
	public String getUserVehicleList(Connection con, int userId, int systemId, int customerId, String sb, int isLtsp){
		String vehList = "";
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			if(userId == 0){
				pstmt=con.prepareStatement(MapViewStatements.GET_ALL_CLIENT_VEHICLE + " and REGISTRATION_NUMBER not in ("+sb+")");
				pstmt.setInt(1,systemId);
				pstmt.setInt(2, customerId);
			} else {
				if(isLtsp==0){
					pstmt=con.prepareStatement(MapViewStatements.GET_REGISTERED_VEHICLE_LIST_TYPE_FOR_CLIENT + " and VehicleNo not in ("+sb+")");
				} else {
					pstmt=con.prepareStatement(MapViewStatements.SELECT_REGISTRATION_NO_FROM_USER_VEHICLE_TYPE_WITH_ACTIVE + " and VehicleNo not in ("+sb+")");
				}
				pstmt.setInt(1,userId);
				pstmt.setInt(2,systemId);
				pstmt.setInt(3,systemId);
				pstmt.setInt(4, customerId);
			}
			
			rs = pstmt.executeQuery();
			while(rs.next()){
				if(vehList.equals(""))
					vehList = "'"+rs.getString("VehicleNo")+"'";
				else
					vehList = vehList + ",'"+rs.getString("VehicleNo")+"'"; 
			}
			pstmt.close();
			rs.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return vehList;
	}
	
	public String getLatLongForCenter(int systemId){
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String latLong = "";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(MapViewStatements.GET_LAT_LONG_FOR_MAP_CENTER);			
			pstmt.setInt(1, systemId);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				latLong = rs.getString("Latitude")+","+rs.getString("Longitude");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return latLong;
	}
	public JSONArray getVehicleList(String vehicleType,int offset,int userId, int customerId, int systemId,int isLtsp,String language,int nonCommHrs) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			VehicleDetailsArray = new JSONArray();			
			con = DBConnection.getConnectionToDB("AMS");
			if(isLtsp==0 || customerId==0){
				
	           	 pstmt=con.prepareStatement(MapViewStatements.GET_REGISTERED_VEHICLE_LIST_TYPE_FOR_CLIENT);
	           	 pstmt.setInt(1,userId);
	       		 pstmt.setInt(2,systemId);
	       		 pstmt.setInt(3,systemId);
	       		 pstmt.setInt(4, customerId);
			}else{
	             pstmt=con.prepareStatement(MapViewStatements.SELECT_REGISTRATION_NO_FROM_USER_VEHICLE_TYPE_WITH_ACTIVE);
	       		 pstmt.setInt(1,userId);
	       		 pstmt.setInt(2,systemId);
	       		 pstmt.setInt(3,systemId);
	       		 pstmt.setInt(4, customerId);
         	}
			rs = pstmt.executeQuery();
			StringBuffer sb=new StringBuffer();
			int a=0;
			while(rs.next()){
				String vehicleNo1 = rs.getString("VehicleNo");			
			    if(a==0){
			    	sb.append("'"+vehicleNo1+"'");
			    	a=1;
			    }else{
			    	 sb.append(",'"+vehicleNo1+"'");
			    }			   
		    }  
			 String regList=sb.toString();
			 if(regList.equals("")){
				 regList="''";
			}
			 
			if(isLtsp==0 && customerId==0){
				if (vehicleType.equalsIgnoreCase("all")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(" order by a.REGISTRATION_NO "));
				} else if (vehicleType.equalsIgnoreCase("comm")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(" and DATEDIFF(hh,a.GMT,getutcdate()) < "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
				} else if (vehicleType.equalsIgnoreCase("noncomm")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(" and DATEDIFF(hh,a.GMT,getutcdate()) >= "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
				} else if (vehicleType.equalsIgnoreCase("noGPS")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(" and a.LOCATION ='No GPS Device Connected' order by a.REGISTRATION_NO "));
				} else if (vehicleType.equalsIgnoreCase("Running")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(" and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED>isNull(a.SPEED_LIMIT,10)) order by a.REGISTRATION_NO "));
				}	else if (vehicleType.equalsIgnoreCase("Stoppage")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(" and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=0 and a.SPEED<=isNull(a.SPEED_LIMIT,10)) order by a.REGISTRATION_NO "));
				}	else if (vehicleType.equalsIgnoreCase("Idle")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_LTSP_MAP_VIEW_DETAILS_NEW.concat(" and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED<=isNull(a.SPEED_LIMIT,10)) order by a.REGISTRATION_NO "));
				}							
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, userId);
				
			}else{
				
				if (vehicleType.equalsIgnoreCase("all")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+")  order by a.REGISTRATION_NO"));
				} else if (vehicleType.equalsIgnoreCase("comm")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,a.GMT,getutcdate()) < "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
				} else if (vehicleType.equalsIgnoreCase("noncomm")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,a.GMT,getutcdate()) >= "+nonCommHrs+" and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
				} else if (vehicleType.equalsIgnoreCase("noGPS")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )  and a.LOCATION ='No GPS Device Connected' order by a.REGISTRATION_NO"));
				} else if (vehicleType.equalsIgnoreCase("Running")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED>a.SPEED_LIMIT) order by a.REGISTRATION_NO"));
				} else if (vehicleType.equalsIgnoreCase("Stoppage")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=0 and a.SPEED<=a.SPEED_LIMIT) order by a.REGISTRATION_NO"));
				} else if (vehicleType.equalsIgnoreCase("Idle")) {
					pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED<=a.SPEED_LIMIT) order by a.REGISTRATION_NO"));
				}	
			}
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			rs = pstmt.executeQuery();		
			
			while (rs.next()) {			
				VehicleDetailsObject = new JSONObject();
				VehicleDetailsObject.put("id",rs.getString("REGISTRATION_NO"));
				VehicleDetailsObject.put("name",rs.getString("REGISTRATION_NO"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	public JSONArray getOlaMapViewVehicles(String vehicleType, int offset,int userId, int customerId, int systemId,int isLtsp,String language,String regList) {
		JSONArray VehicleDetailsArray = new JSONArray();
		JSONObject VehicleDetailsObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			Properties properties = ApplicationListener.prop;
			String vehicleImagePath = properties.getProperty("vehicleImagePath");
			VehicleDetailsArray = new JSONArray();			
			con = DBConnection.getConnectionToDB("AMS");
			if (vehicleType.equalsIgnoreCase("all")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+")  order by a.REGISTRATION_NO"));
			} else if (vehicleType.equalsIgnoreCase("comm")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,a.GMT,getutcdate()) < 6 and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
			} else if (vehicleType.equalsIgnoreCase("noncomm")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )  and DATEDIFF(hh,a.GMT,getutcdate()) >= 6 and a.LOCATION !='No GPS Device Connected' order by a.REGISTRATION_NO "));
			} else if (vehicleType.equalsIgnoreCase("noGPS")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )  and a.LOCATION ='No GPS Device Connected' order by a.REGISTRATION_NO"));
			} else if (vehicleType.equalsIgnoreCase("Running")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED>a.SPEED_LIMIT) order by a.REGISTRATION_NO"));
			} else if (vehicleType.equalsIgnoreCase("Stoppage")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=0 and a.SPEED<=a.SPEED_LIMIT) order by a.REGISTRATION_NO"));
			} else if (vehicleType.equalsIgnoreCase("Idle")) {
				pstmt = con.prepareStatement(MapViewStatements.GET_MAP_VIEW_DETAILS.concat(" where a.REGISTRATION_NO in ("+regList+" )   and a.LOCATION !='No GPS Device Connected' and (a.IGNITION=1 and a.SPEED<=a.SPEED_LIMIT) order by a.REGISTRATION_NO"));
			}	
			pstmt.setInt(1, offset);
			pstmt.setInt(2, offset);
			rs = pstmt.executeQuery();	
			
			while (rs.next()) {			
				VehicleDetailsObject = new JSONObject();				
				String location=null;
				if(language.equals("ar") && !rs.getString("LOCATION").equals("")){
					location=LocationLocalization.getAppendLocationLocalization(rs.getString("LOCATION"), language);
				}else{
					location=rs.getString("LOCATION");
				}
				if(!rs.getString("VEHICLE_ID").equals("")){
					VehicleDetailsObject.put("assetNo", rs.getString("REGISTRATION_NO")+" ["+rs.getString("VEHICLE_ID")+"]");
				}else{
					VehicleDetailsObject.put("assetNo", rs.getString("REGISTRATION_NO"));
				}
				VehicleDetailsObject.put("vehicleNo", rs.getString("REGISTRATION_NO"));
				VehicleDetailsObject.put("latitude", rs.getString("LATITUDE"));
				VehicleDetailsObject.put("longitude", rs.getString("LONGITUDE"));
				VehicleDetailsObject.put("location", location);
				VehicleDetailsObject.put("gmt", ddmmyyyy.format(yyyymmdd.parse(rs.getString("GPS_DATETIME"))));
				VehicleDetailsObject.put("drivername", "");
				VehicleDetailsObject.put("groupname",rs.getString("GROUP_NAME"));
				VehicleDetailsObject.put("groupId",rs.getString("GROUP_ID"));
				VehicleDetailsObject.put("ignition","");
				VehicleDetailsObject.put("category",rs.getString("CATEGORY"));
				VehicleDetailsObject.put("prevlat",rs.getString("PREV_LAT"));
				VehicleDetailsObject.put("prevlong",rs.getString("PREV_LONG"));
				String path=rs.getString("IMAGE_NAME");
			    String vehicleImage="";
			    String vehicleImage1="";
			    String imagePath = "";
				if(path==null || path.equals("")){			            								   
				       vehicleImage= "default";	 
				}else{
					if(!path.contains("default")){
					   vehicleImage= path.substring(path.lastIndexOf("/")+1, path.lastIndexOf("_"));
					} else {
						vehicleImage= path.substring(path.lastIndexOf("/")+1, path.indexOf("_"));
					}
				}
				VehicleDetailsObject.put("imagePath",vehicleImage);
				if(path==null || path.equals("")){	
						if(rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED")>10){
							vehicleImage1= "<img src='"+vehicleImagePath+"default_BG.png' width='20' height='20' style='margin-top: -3px;'></img>";	 
						} else if(rs.getString("IGNITION").equals("0") && rs.getFloat("SPEED") == 0){
							vehicleImage1= "<img src='"+vehicleImagePath+"default_BR.png' width='20' height='20' style='margin-top: -3px;'></img>";	 
						}else if(rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED")<=10){
							vehicleImage1= "<img src='"+vehicleImagePath+"default_BL.png' width='20' height='20' style='margin-top: -3px;'></img>";	 
						}else {
							vehicleImage1= "<img src='"+vehicleImagePath+"default_BG.png' width='20' height='20' style='margin-top: -3px;'></img>";	 
						}
				}else{
					 imagePath=path.substring(path.lastIndexOf("/")+1, path.lastIndexOf("_"));	
					 if(imagePath.contains("default")){
						 if(rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED")>10){
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BG.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
						 } else if(rs.getString("IGNITION").equals("0") && rs.getFloat("SPEED") == 0){
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BR.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
						 } else if(rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED")<=10){
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BL.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";	
						 } else {
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BG.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";
						 }
					 } else {
						 if(rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED")>10){
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BG.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";	
						 }else if(rs.getString("IGNITION").equals("0") && rs.getFloat("SPEED") == 0){
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BR.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";	
						 }else if(rs.getString("IGNITION").equals("1") && rs.getFloat("SPEED")<=10){
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BL.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";	
						 }else{
							 vehicleImage1= "<img src='"+vehicleImagePath+""+imagePath+"_BG.png"+"' width='20' height='20' style='margin-top: -3px;'></img>";	
						 }
					 }
				}  
				
				VehicleDetailsObject.put("imageIcon",vehicleImage1);
				VehicleDetailsObject.put("vehicleMake", rs.getString("Vehicle_Make"));
				VehicleDetailsArray.put(VehicleDetailsObject);
			}			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return VehicleDetailsArray;
	}
	public JSONArray getColumnHeaderBuffer(int processId,String language,boolean checkFDAS,int systemid,int userID,int customerID)
	{
		String getLanuage="LANG_ENGLISH";
		Connection con = null;
		PreparedStatement pstmt = null,pstmt1=null;
		ResultSet rs = null,rs1=null;
		CommonFunctions cf = new CommonFunctions();
		JSONArray jArr = new JSONArray(); 
		JSONObject obj = null;
		try {
			if(language.equals("ar"))
			{
				getLanuage="LANG_ARABIC";
			}
			
		  con = DBConnection.getConnectionToDB("AMS");
		  pstmt1=con.prepareStatement(MapViewStatements.LIVE_VISION_FILTER_DATA_CHECK_BEFORE_DELETION);
		  pstmt1.setInt(1,systemid);
		  pstmt1.setInt(2,customerID);
		  pstmt1.setInt(3,userID);
		  rs1=pstmt1.executeQuery();
		  if(rs1.next()){
			 pstmt = con.prepareStatement(MapViewStatements.GET_HEADERS_FROM_USER_SETTING1);
			 pstmt.setInt(1,systemid);
			 pstmt.setInt(2,customerID);
			 pstmt.setInt(3,userID);
		  }
		  
		  else{
		  pstmt=con.prepareStatement(MapViewStatements.LIVE_VISION_HEADERS_FOR_FILTER);
		  pstmt.setInt(1, processId);
		  }
		  rs=pstmt.executeQuery(); 
		  
		  while(rs.next()){
			  obj = new JSONObject();
			  obj.put("nameIndex",rs.getString("LANG_ENGLISH"));
			  obj.put("valueIndex", rs.getString("DATA_FIELD_LABEL_ID"));
			  obj.put("visibilityIndex", rs.getString("Visibility"));
			  jArr.put(obj);
		  }
		 
	    }
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
		
		return jArr;
	}
	
	public String postColumnDataInTable(int customerId,int userId,int systemid,String order)
	{
	
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String msg = "";		
		int update = 0;
		List<String> orderStringArray = Arrays.asList(order.split(","));
		//ArrayList<String> elephantList = Arrays.asList(str.split(","));
		try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(MapViewStatements.LIVE_VISION_FILTER_DATA_CHECK_BEFORE_DELETION);
		pstmt.setInt(1,systemid);
		  pstmt.setInt(2,customerId);
		  pstmt.setInt(3,userId);
		  rs=pstmt.executeQuery();
		  if(rs.next()){
			  pstmt=con.prepareStatement(MapViewStatements.LIVE_VISION_FILTER_DATA_DELETION);
			  pstmt.setInt(1,systemid);
			  pstmt.setInt(2,customerId);
			  pstmt.setInt(3,userId);
			  pstmt.executeUpdate();
		  }
		 int colNum=0;
		 //SystemId,ColumnName,ColumnOrder,Visibility,ClientId,UserId
		  for(int i=0;i<(orderStringArray.size()/3);i++){
			  
		  pstmt=con.prepareStatement(MapViewStatements.LIVE_VISION_FILTER_DATA);
		  pstmt.setInt(1,systemid);
		  pstmt.setString(2,orderStringArray.get(colNum).trim());
		  pstmt.setString(3, orderStringArray.get(colNum+1).trim());
		  pstmt.setString(4,orderStringArray.get(colNum+2).trim());
		  pstmt.setInt(5,customerId);
		  
		  pstmt.setInt(6,userId);
		  colNum=colNum+3;
		  update = pstmt.executeUpdate();
		  
		  }
		  if(update > 0){
			 msg = "Success"; 
		  }else{
			  msg = "Error";
		  }
		  
	    }
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
		return msg;
	
	}
	public String resetColumnDataInTable(int customerId,int userId,int systemid)
	{
	
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String msg = "";		
		int update = 0;
		try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt=con.prepareStatement(MapViewStatements.LIVE_VISION_FILTER_DATA_DELETION);
		pstmt.setInt(1,systemid);
		pstmt.setInt(2,customerId);
		pstmt.setInt(3,userId);
		update=pstmt.executeUpdate();
		  
		  
		  if(update > 0){
			 msg = "Success"; 
		  }else{
			  msg = "Error";
		  }
		  
	    }
		catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);			
		}
		return msg;
	
	}
	

	public HashMap<Enum,String> getNewLiveVisionListVehiclesDetails(Connection con, String vehicleNo, int offmin,String status) {
		 HashMap<Enum,String>  liveVisionData = new  HashMap<Enum,String>();
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String productLine = "";
		String range = "";
		try{
			 pstmt=con.prepareStatement(MapViewStatements.GET_TRIP_DETAILS_FOR_LIVE_VISION);
			 pstmt.setInt(1,offmin);
			 pstmt.setInt(2,offmin);
			 pstmt.setInt(3,offmin);
			 pstmt.setInt(4,offmin);
			 pstmt.setString(5,vehicleNo);
			 
			 rs=pstmt.executeQuery();
			 
			 if(rs.next()){
				 
				 liveVisionData.put(LiveVisionHeaders.Trip_Customer, rs.getString("CUSTOMER_NAME"));
				 if(rs.getString("TEMPERATURE_DATA") != null){
					 liveVisionData.put(LiveVisionHeaders.Temp_info_for_TCL,rs.getString("TEMPERATURE_DATA"));
				 }
				 else{
					 liveVisionData.put(LiveVisionHeaders.Temp_info_for_TCL,"");
				 }
				 productLine = rs.getString("PRODUCT_LINE");
				 if (!productLine.equalsIgnoreCase("Dry")){
					   range = "Green: " + rs.getString("negativeMax") + " to " + rs.getString("positiveMin") + ", Yellow: " + rs.getString("negativeMax")
		                + " to " + rs.getString("negativeMin") + "; " + rs.getString("positiveMin") + " to " + rs.getString("positiveMax") + ", Red: > "
		                + rs.getString("positiveMax") + "; < " + rs.getString("negativeMin");
				 }
				 
	
				 liveVisionData.put(LiveVisionHeaders.Set_Temp_limits_for_on_trip,range);
			
				 liveVisionData.put(LiveVisionHeaders.ETP, (rs.getTimestamp("ETP")!=null && rs.getTimestamp("ATP")==null) ? ddmmyyyy.format(rs.getTimestamp("ETP")):"");
				 liveVisionData.put(LiveVisionHeaders.ATP, rs.getTimestamp("ATP")!=null ? ddmmyyyy.format(rs.getTimestamp("ATP")):"");
				 liveVisionData.put(LiveVisionHeaders.ETA, (rs.getTimestamp("ETA")!=null && rs.getTimestamp("ATA")==null) ? ddmmyyyy.format(rs.getTimestamp("ETA")):"");
				 liveVisionData.put(LiveVisionHeaders.ATA, rs.getTimestamp("ATA")!=null ? ddmmyyyy.format(rs.getTimestamp("ATA")):"");
			 }
			 liveVisionData.put(LiveVisionHeaders.Ageing,status.equalsIgnoreCase("Vehicle Available") ? getAgeing(vehicleNo,con):"");
		}catch(Exception e){
			e.printStackTrace();
		}
		return liveVisionData;
    }
		
	public String getCity(double latitude, double longitude, String location,String key){
		String address[] = {};
		 String city = "";
		 int count = 0;
		
		 if(location.startsWith(("No GPS Device Connected"),0)) {
			 city = "";
			 return city;
		 }
		 if(location.startsWith("Inside", 0)){
			 address = location.split(",");
			 count=address.length;
			 if(address.length >0){
				 city = (address[count-3]);
			 }
		 }else{
			 if(key != null){
				 city = CommonUtil.getCityFomGoogleAPI(latitude, longitude, key);
			 }
		 }
		 return city;
	}
		
	
	public String getAgeing(String vehicleNo,Connection con)
	{
		 
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int age = 0;
		String aging="";
		try {
			pstmt=con.prepareStatement(MapViewStatements.GET_AGEING);
			pstmt.setString(1, vehicleNo);
			rs=pstmt.executeQuery();
			 if(rs.next()){
				 age = rs.getInt("AGING");
			 }
			 
			 if (age > 0){ 
				 aging =  String.format("%02d:%02d", (age/60), (age%60)); //(age/60) +":"+ String.format("%02d",(age%60));
			 }
		 }
		catch (Exception e) {
			e.printStackTrace();
		} finally {
		}
		return aging;
	
	}
	
	
}
