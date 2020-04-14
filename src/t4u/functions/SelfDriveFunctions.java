package t4u.functions;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.SelfDriveStatements;

public class SelfDriveFunctions {

	CommonFunctions cf=new CommonFunctions();
	
 //----------------------------------------------Hub Expense Master functions----------------------------------------------------------------------------------//
	public JSONArray getHUbList(int systemId, int customerId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("ADMINISTRATOR");
			pstmt = con.prepareStatement(SelfDriveStatements.GET_HUB_LIST);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("HUB_ID", rs.getString("hub_id"));
				JsonObject.put("HUB_NAME", rs.getString("hub_name"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public JSONArray getVehicleNo(int systemId,int hubId,int customerId) {
		JSONArray JsonArray = null;
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int count = 0;
		try {
			JsonArray = new JSONArray();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SelfDriveStatements.GET_VHICLE_NO);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, customerId);
			pstmt.setInt(3, hubId);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
				JsonObject = new JSONObject();
				JsonObject.put("VehicleNo", rs.getString("VehicleNo"));
				JsonArray.put(JsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}

	public String insertHubExpenseInformation(Integer hubId ,String vehicleNo,String comments,
			 float keylost,float cardent,Float carscratch,float tow,float carpuncture,float refuel1,float localconveyance,float carwashing,float others,
			int CustId ,int systemId,Integer  userId ) {	
		String message = "";
		try {
		URL url = new URL("http://orangeselfdrive.com/rest/expense/saveExpense");
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setDoOutput(true);
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type", "application/json");
		String input = "{" +
				"\"id\":0," +
				"\"hubId\":" +hubId+","+                       
				"\"regNO\":" +"\""+vehicleNo+"\""+","+
				"\"carWash\":" +carwashing+","+  
				"\"keyLost\":" +keylost+","+  
				"\"carDent\":" +cardent+","+  
				"\"carScratch\":" +carscratch+","+  
				"\"towing\":" +tow+","+  
				"\"carPuncture\":" +carpuncture+","+  
				"\"carRefuel\":" +refuel1+","+  
				"\"localConvenience\":" +localconveyance+","+  
				"\"remarks\":" +"\""+comments+"\""+","+          
				"\"other\":" +others+","+  
				"\"systemId\":" +systemId+","+  
				"\"clientId\":" +CustId+","+  
				"\"userId\":" +userId+
				"}";
		OutputStream os = conn.getOutputStream();
		os.write(input.getBytes());
		os.flush();

		if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
			throw new RuntimeException("Failed : HTTP error code : "
				+ conn.getResponseCode());
		}

		BufferedReader br = new BufferedReader(new InputStreamReader(
				(conn.getInputStream())));

		String output;
			while ((output = br.readLine()) != null) {
				System.out.println("Insert :"+output);
				message="Saved Successfully";
		}
		conn.disconnect();
	  }catch (MalformedURLException e) {
		e.printStackTrace();
	  } catch (IOException e) {
		e.printStackTrace();
	 }
		return message;
	}

	public String modifyHubExpenseInformation(int id,int hubId,String vehicleNo,String comments,
			float keylost,float cardent,float carscratch,float tow,float carpuncture,float refuel1,float localconveyance,float carwashing,float others,
			int CustId ,int systemId,Integer  userId){
		String message = "";
		try {
		URL url = new URL("http://orangeselfdrive.com/rest/expense/saveExpense");
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setDoOutput(true);
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type", "application/json");
		String input = "{" +
		"\"id\":"+id+","+
		"\"hubId\":" +hubId+","+                       
		"\"regNO\":" +"\""+vehicleNo+"\""+","+
		"\"carWash\":" +carwashing+","+  
		"\"keyLost\":" +keylost+","+  
		"\"carDent\":" +cardent+","+  
		"\"carScratch\":" +carscratch+","+  
		"\"towing\":" +tow+","+  
		"\"carPuncture\":" +carpuncture+","+  
		"\"carRefuel\":" +refuel1+","+  
		"\"localConvenience\":" +localconveyance+","+  
		"\"remarks\":" +"\""+comments+"\""+","+          
		"\"other\":" +others+","+  
		"\"systemId\":" +systemId+","+  
		"\"clientId\":" +CustId+","+  
		"\"userId\":" +userId+
		"}";
		OutputStream os = conn.getOutputStream();
		os.write(input.getBytes());
		os.flush();

		if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
			throw new RuntimeException("Failed : HTTP error code : "
				+ conn.getResponseCode());
		}

		BufferedReader br = new BufferedReader(new InputStreamReader(
				(conn.getInputStream())));

		String output;
			while ((output = br.readLine()) != null) {
				System.out.println("update :"+output);
				message = "Updated Successfully";
		}
		conn.disconnect();

	  }catch (MalformedURLException e) {
		e.printStackTrace();
	  } catch (IOException e) {
		e.printStackTrace();
	 }
		return message;
	}

	public ArrayList < Object > getHubExpenseDetails( int CustId,int HubId,String startDate,String endDate,int systemId,String language,int offset) {
		ArrayList < ReportHelper > reportsList = new ArrayList < ReportHelper > ();
		ArrayList < String > headersList = new ArrayList < String > ();
		ReportHelper finalreporthelper = new ReportHelper();    
		String startDate1=startDate.replaceAll("T","%20");
		String endDate1=endDate.replaceAll("T", "%20");
		JSONArray JsonArray = new JSONArray();
		JSONObject jsonObject = null;
		JSONObject jsonObject1 = null;
		SimpleDateFormat sd=new SimpleDateFormat("dd-MM-yyyy HH:mm" );
		SimpleDateFormat sdd=new SimpleDateFormat("MM-dd-yyyy HH:mm" );
		ArrayList < Object > finlist = new ArrayList < Object > ();
		try {
			int count = 0;
			headersList.add(cf.getLabelFromDB("SLNO", language));
			headersList.add(cf.getLabelFromDB("Hub_Id", language));
			headersList.add(cf.getLabelFromDB("Vehicle_No", language));
			headersList.add(cf.getLabelFromDB("Date", language));
			headersList.add(cf.getLabelFromDB("Key_Lost", language));
			headersList.add(cf.getLabelFromDB("Car_Dent", language));
			headersList.add(cf.getLabelFromDB("Car_Scratch", language));
			headersList.add(cf.getLabelFromDB("Towing", language));
			headersList.add(cf.getLabelFromDB("Car_Puncture", language));
			headersList.add(cf.getLabelFromDB("Refuel", language));
			headersList.add(cf.getLabelFromDB("Local_Conveyance", language));
			headersList.add(cf.getLabelFromDB("Car_Washing", language));
			headersList.add(cf.getLabelFromDB("Others", language));
			headersList.add(cf.getLabelFromDB("Comments", language));
			headersList.add(cf.getLabelFromDB("Total", language));
			URL url = new URL("http://orangeselfdrive.com/rest/expense/getExpenses?clientId="+CustId+"&systemId="+systemId+"&hubId="+HubId+"&startDate="+startDate1+"&endDate="+endDate1);
			HttpURLConnection myUrlConnection = (HttpURLConnection) url.openConnection();
			myUrlConnection.setDoOutput(true);
			myUrlConnection.setRequestMethod("GET");
			BufferedReader in = new BufferedReader(new InputStreamReader(myUrlConnection.getInputStream()));
			String urlString = "";
			String current;
			while((current = in.readLine()) != null)
			{
				urlString += current;
				urlString = urlString.replace("[",  "{" +"\"hub\":"+"[").replace("]", "]"+"}");
				JSONObject root = new JSONObject(urlString.toString());
				JSONArray hubDetailsArray = root.getJSONArray("hub");
				for (int i = 0; i < hubDetailsArray.length(); i++) {
					 jsonObject1 = new JSONObject();
					ArrayList<Object> informationList = new ArrayList<Object>();
					ReportHelper reporthelper = new ReportHelper();
					count++;
					jsonObject = hubDetailsArray.getJSONObject(i);
					
					jsonObject1.put("slnoIndex", count);
					informationList.add(count);

					jsonObject1.put("hubIdDataIndex", jsonObject.getString("hubId"));
					informationList.add(jsonObject.getString("hubId"));

					jsonObject1.put("vehicleNoDataIndex", jsonObject.getString("regNO"));
					informationList.add(jsonObject.getString("regNO"));

					if(jsonObject.getString("creationDate")!=null && !jsonObject.getString("creationDate").equals(""))
					{
					jsonObject1.put("dateDataIndex",  sdd.format((sd.parseObject(jsonObject.getString("creationDate")))));
					}
					else{
					jsonObject1.put("dateDataIndex",  "");	
					}
					informationList.add(jsonObject.getString("creationDate"));
					
					jsonObject1.put("keyLostDataIndex", jsonObject.getString("keyLost"));
					informationList.add(jsonObject.getString("keyLost"));

					jsonObject1.put("carDentDataIndex", jsonObject.getString("carDent"));
					informationList.add(jsonObject.getString("carDent"));

					jsonObject1.put("carScratchDataIndex", jsonObject.getString("carScratch"));
					informationList.add(jsonObject.getString("carScratch"));

					jsonObject1.put("towingDataIndex", jsonObject.getString("towing"));
					informationList.add(jsonObject.getString("towing"));

					jsonObject1.put("carPunctureDataIndex", jsonObject.getString("carPuncture"));
					informationList.add(jsonObject.getString("carPuncture"));

					jsonObject1.put("refuelDataIndex", jsonObject.getString("carRefuel"));
					informationList.add(jsonObject.getString("carRefuel"));

					jsonObject1.put("loacalConveyanceDataIndex", jsonObject.getString("localConvenience"));
					informationList.add(jsonObject.getString("localConvenience"));

					jsonObject1.put("carWashingDataIndex", jsonObject.getString("carWash"));
					informationList.add(jsonObject.getString("carWash"));

					jsonObject1.put("otherServiceDataIndex", jsonObject.getString("other"));
					informationList.add(jsonObject.getString("other"));

					jsonObject1.put("commentDataIndex", jsonObject.getString("remarks"));
					informationList.add(jsonObject.getString("remarks"));

					jsonObject1.put("totalDataIndex", jsonObject.getString("total"));
					informationList.add(jsonObject.getString("total"));

					jsonObject1.put("IdDataIndex", jsonObject.getString("id"));
					JsonArray.put(jsonObject1);  
					reporthelper.setInformationList(informationList);
					reportsList.add(reporthelper);
				}
			}
			finalreporthelper.setReportsList(reportsList);
			finalreporthelper.setHeadersList(headersList);
			finlist.add(JsonArray);
			finlist.add(finalreporthelper);
			myUrlConnection.disconnect();
		} catch(Exception e) {
			e.printStackTrace();
		} 
		return finlist;

	}

	
	///*************************************Promo code Management Function ****************************************//
	public JSONArray getAssetModelList(int systemId, int userId, int CustId) {
	    JSONArray JsonArray = null;
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        JsonArray = new JSONArray();
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(SelfDriveStatements.GET_ASSET_MODEL);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, CustId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            JsonObject.put("ModelName", rs.getString("ModelName"));
	            JsonObject.put("Value", rs.getString("ModelTypeId"));
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	
	
	public ArrayList < Object > PromocodeDetails( int CustId,int systemId,int userId) {
		JSONArray JsonArray = new JSONArray();
		JSONObject jsonObject = null;
		JSONObject jsonObject1 = null;
		ArrayList < Object > finlist = new ArrayList < Object > ();
		SimpleDateFormat sd=new SimpleDateFormat("dd/MM/yy HH:mm" );
		SimpleDateFormat sdd=new SimpleDateFormat("MM/dd/yy HH:mm" );
		
		try {
		      URL url = new URL("http://orangeselfdrive.com/rest/discount/getPromos?systemId="+systemId+"&clientId="+CustId);
					HttpURLConnection myUrlConnection = (HttpURLConnection) url.openConnection();
					myUrlConnection.setDoOutput(true);
					myUrlConnection.setRequestMethod("GET");
					BufferedReader in = new BufferedReader(new InputStreamReader(myUrlConnection.getInputStream()));
					String urlString = "";
					String current;
					String carName=null; 
					String hubName=null;
					int count=0;
			   	        while((current = in.readLine()) != null)
			   	        {
			   	        	urlString += current;
			   	        	urlString = urlString.replace("[",  "{" +"\"promo\":"+"[").replace("]", "]"+"}");
			   	        	JSONObject root = new JSONObject(urlString.toString());
			   	        	JSONArray promoCodeArray = root.getJSONArray("promo");
			   	        	for (int i = 0; i < promoCodeArray.length(); i++) {
			   	        		jsonObject = promoCodeArray.getJSONObject(i);
								count++;
								jsonObject1 =new JSONObject();
								jsonObject1.put("slnoIndex", count);
								
			   	        		String carId=jsonObject.getString("carModel");
			   	        		if (carId != null && !carId.equals("")) {
			   	        			carName =getCarName(systemId,CustId,Integer.parseInt(carId));
			   	        			jsonObject1.put("carModelDataIndex", carName);
			   	        		}else{
			   	        			jsonObject1.put("carModelDataIndex", "");
			   	        		}
			   	        		String hubId=jsonObject.getString("hub");
			   	        		if (hubId != null && !hubId.equals("")) {
			   	        			hubName =getHubName(systemId,CustId,Integer.parseInt(hubId));
			   	        			jsonObject1.put("hubDataIndex", hubName);
			   	        		}else{
			   	        			jsonObject1.put("hubDataIndex", "");
			   	        		}
			   	        		jsonObject1.put("idDataIndex", jsonObject.getString("id"));
			   	        		jsonObject1.put("promoCodeDataIndex", jsonObject.getString("promoCode"));
			   	        		jsonObject1.put("discountDataIndex", jsonObject.getString("discountRate"));
			   	        		jsonObject1.put("carModelIdDataIndex", jsonObject.getString("carModel"));
			   	        		jsonObject1.put("hubIdDataIndex", jsonObject.getString("hub"));
			   	        		jsonObject1.put("tripDurationDataIndex", jsonObject.getString("minTripDuration"));
			   	        		jsonObject1.put("noOfTimesDataIndex", jsonObject.getString("frequency"));
			   	        		jsonObject1.put("statusDataIndex", "Active");
			   	        		if(jsonObject.getString("startDate") != null && !jsonObject.getString("startDate").equals(""))
			   	        		{
			   	        		jsonObject1.put("startDateDataIndex", sdd.format((sd.parseObject(jsonObject.getString("startDate")))));
			   	        		}
			   	        		else{
			   	        			jsonObject1.put("startDateDataIndex", "");
			   	        		}
			   	        		if(jsonObject.getString("endDate") != null && !jsonObject.getString("endDate").equals(""))
			   	        		{
			   	        		jsonObject1.put("endDateDataIndex", sdd.format((sd.parseObject(jsonObject.getString("endDate")))));
			   	        		}
			   	        		else{
			   	        			jsonObject1.put("endDateDataIndex", "");
			   	        		}
			   	        		jsonObject1.put("idDateDataIndex", jsonObject.getString("id"));

			   	        		JsonArray.put(jsonObject1);  
			   	        		
			   	        	}
			   	        }
	finlist.add(JsonArray);
	myUrlConnection.disconnect();
	} catch(Exception e) {
		e.printStackTrace();
	} 
	return finlist;

	}
	public String getCarName(int systemId, int CustId, int carId ) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String CarName="";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(SelfDriveStatements.GET_CAR_MODEL_NAME);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, CustId);
	        pstmt.setInt(3, carId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	 CarName = rs.getString("ModelName");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return CarName;
	}
	public String getHubName(int systemId, int CustId, int hubId ) {
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    String hubName="";
	    try {
	        con = DBConnection.getConnectionToDB("AMS");
	        pstmt = con.prepareStatement(SelfDriveStatements.GET_HUB_NAME);
	        pstmt.setInt(1, systemId);
	        pstmt.setInt(2, CustId);
	        pstmt.setInt(3, hubId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	 hubName = rs.getString("HUB_NAME");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return hubName;
	}
	public String insertPromoCodeDetails(String promoCode,int discountRate,String startDate,String endDate,String hub,String carModel,int minTripDuration,String frequency,int CustID,int systemId,int userId ) 
	{	
			String message = "";
			try {
			URL url = new URL("http://orangeselfdrive.com/rest/discount/savePromo");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			String input = "{" +
					"\"id\":0," +
					"\"promoCode\":" +"\""+promoCode+"\""+","+
					"\"discountRate\":" +discountRate+","+
					"\"startDate\":" +"\""+startDate+"\""+","+
					"\"endDate\":"+"\""+endDate+"\""+","+
					"\"hub\":" +"\""+hub+"\""+","+
					"\"carModel\":"+"\""+carModel+"\""+","+
					"\"minTripDuration\":"+minTripDuration+","+
					"\"frequency\":" +"\""+frequency+"\""+","+
					"\"clientId\":"+CustID+","+
					"\"systemId\":"+systemId+","+
					"\"userId\":"+userId+
					"}";
			OutputStream os = conn.getOutputStream();
			os.write(input.getBytes());
			os.flush();

			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				throw new RuntimeException("Failed : HTTP error code : "
					+ conn.getResponseCode());
			}

			BufferedReader br = new BufferedReader(new InputStreamReader(
					(conn.getInputStream())));

			String output;
				while ((output = br.readLine()) != null) {
					System.out.println("Insert :"+output);
					message="Saved Successfully";
			}
			conn.disconnect();
		  }catch (MalformedURLException e) {
			e.printStackTrace();
		  } catch (IOException e) {
			e.printStackTrace();
		 }
			return message;
		}
	public String updatePromoCodeDetails(int id,String promoCode,int discountRate,String startDate,String endDate,String hub,String carModel,int minTripDuration,String frequency,int CustID,int systemId,int userId ) 
	{	
			String message = "";
			try {
			URL url = new URL("http://orangeselfdrive.com/rest/discount/savePromo");
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			String input = "{" +
			 		"\"id\":"+id+","+
					"\"promoCode\":" +"\""+promoCode+"\""+","+
					"\"discountRate\":" +discountRate+","+
					"\"startDate\":" +"\""+startDate+"\""+","+
					"\"endDate\":"+"\""+endDate+"\""+","+
					"\"hub\":" +"\""+hub+"\""+","+
					"\"carModel\":"+"\""+carModel+"\""+","+
					"\"minTripDuration\":"+minTripDuration+","+
					"\"frequency\":" +"\""+frequency+"\""+","+
					"\"clientId\":"+CustID+","+
					"\"systemId\":"+systemId+","+
					"\"userId\":"+userId+
					"}";
			OutputStream os = conn.getOutputStream();
			os.write(input.getBytes());
			os.flush();

			if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
				throw new RuntimeException("Failed : HTTP error code : "
					+ conn.getResponseCode());
			}

			BufferedReader br = new BufferedReader(new InputStreamReader(
					(conn.getInputStream())));

			String output;
				while ((output = br.readLine()) != null) {
					System.out.println("update :"+output);
					message = "Updated Successfully";
			}
			conn.disconnect();

		  }catch (MalformedURLException e) {
			e.printStackTrace();
		  } catch (IOException e) {
			e.printStackTrace();
		 }
			return message;
		}
//----------------------------------------------Penalty Master functions----------------------------------------------------------------------------------//
	
	//**************************************Insert Penalty Master Information  *********************************************// 
	public String insertPenaltyMasterInformation(String penaltyType,String penaltyDescription,Double penaltyCost ,int systemId,int CustId,int userId){
		String message = "";
		try {
		URL url = new URL("http://orangeselfdrive.com/rest/penalty/savePenalty");
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setDoOutput(true);
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type", "application/json");
		String input = "{" +
				"\"id\":0," +
				"\"name\":" +"\""+penaltyType+"\""+","+
				"\"description\":" +"\""+penaltyDescription+"\""+","+
				"\"systemId\":" +systemId+","+  
				"\"clientId\":" +CustId+","+  
				"\"cost\":" +penaltyCost+ 
			//	"\"userId\":" +userId+ 
				"}";
		OutputStream os = conn.getOutputStream();
		os.write(input.getBytes());
		os.flush();

		if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
			throw new RuntimeException("Failed : HTTP error code : "
				+ conn.getResponseCode());
		}

		BufferedReader br = new BufferedReader(new InputStreamReader(
				(conn.getInputStream())));

		String output;
			while ((output = br.readLine()) != null) {
				System.out.println("Insert :"+output);
				message="Saved Successfully";
		}
		conn.disconnect();
	  }catch (MalformedURLException e) {
		e.printStackTrace();
	  } catch (IOException e) {
		e.printStackTrace();
	 }
		return message;
	}
	//----------------------------------------Modify Penalty Master Information-------------------------------------------//
	public String modifyPenaltyMasterInformation(int id ,String penaltyType,String penaltyDescription,Double penaltyCost ,int systemId,int CustId,int userId){
		String message = "";
		try {
		URL url = new URL("http://orangeselfdrive.com/rest/penalty/savePenalty");
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setDoOutput(true);
		conn.setRequestMethod("POST");
		conn.setRequestProperty("Content-Type", "application/json");
		String input = "{" +
		 		"\"id\":"+id+","+
		 		"\"name\":" +"\""+penaltyType+"\""+","+
				"\"description\":" +"\""+penaltyDescription+"\""+","+
				"\"systemId\":" +systemId+","+  
				"\"clientId\":" +CustId+","+  
				"\"cost\":" +penaltyCost+ 
			//	"\"userId\":" +userId+
				"}";
		OutputStream os = conn.getOutputStream();
		os.write(input.getBytes());
		os.flush();

		if (conn.getResponseCode() != HttpURLConnection.HTTP_CREATED) {
			throw new RuntimeException("Failed : HTTP error code : "
				+ conn.getResponseCode());
		}

		BufferedReader br = new BufferedReader(new InputStreamReader(
				(conn.getInputStream())));

		String output;
			while ((output = br.readLine()) != null) {
				System.out.println("update :"+output);
				message = "Updated Successfully";
		}
		conn.disconnect();

	  }catch (MalformedURLException e) {
		e.printStackTrace();
	  } catch (IOException e) {
		e.printStackTrace();
	 }
		return message;
	}

	public ArrayList < Object > getPenaltyMasterDetails( int systemid,int CustId) {

		JSONArray JsonArray = new JSONArray();
		JSONObject jsonObject = null;
		ArrayList < Object > finlist = new ArrayList < Object > ();
		try {
			  URL url = new URL("http://orangeselfdrive.com/rest/penalty/getPenalties?systemId="+systemid+"&clientId="+CustId+"");
				HttpURLConnection myUrlConnection = (HttpURLConnection) url.openConnection();
				myUrlConnection.setDoOutput(true);
				myUrlConnection.setRequestMethod("GET");
				BufferedReader in = new BufferedReader(new InputStreamReader(myUrlConnection.getInputStream()));
				String urlString = "";
				String current;
				int count=0;
			   	        while((current = in.readLine()) != null)
			   	        {
			   	        	urlString += current;
			   	        	urlString = urlString.replace("[",  "{" +"\"peanlty\":"+"[").replace("]", "]"+"}");
			   	        	JSONObject root = new JSONObject(urlString.toString());
			   	        	JSONArray penaltyDetailsArray = root.getJSONArray("peanlty");
			   	        	for (int i = 0; i < penaltyDetailsArray.length(); i++) {
			   	        		jsonObject = penaltyDetailsArray.getJSONObject(i);
								count++;
								jsonObject.put("slnoIndex", count);
			   	        		jsonObject.put("penaltyTypeDataIndex", jsonObject.getString("name"));
			   	        		jsonObject.put("penaltyDescriptionDataIndex", jsonObject.getString("description"));
			   	        		jsonObject.put("costDataIndex", jsonObject.getString("cost"));
			   	        		jsonObject.put("IdDataIndex", jsonObject.getString("id"));
									JsonArray.put(jsonObject);  
		   	        	}
			   	        }
	finlist.add(JsonArray);
	myUrlConnection.disconnect();
	} catch(Exception e) {
		e.printStackTrace();
	} 
	return finlist;

	}
}
