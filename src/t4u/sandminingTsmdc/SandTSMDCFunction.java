package t4u.sandminingTsmdc;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.sandminingTsmdc.VehicleRegistrationDetailsData;
import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.sandminingTsmdc.SandTSMDCStatement;
import t4u.statements.AdminStatements;
import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.nio.charset.Charset;
import java.io.StringReader;
import java.io.UnsupportedEncodingException;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.Unmarshaller;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONObject;


import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPMessage;

import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class SandTSMDCFunction {
	
	SimpleDateFormat simpleDateFormatYYYY = new SimpleDateFormat(
	"MM/dd/yyyy HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat(
	"yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYYYDB1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

	SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat(
	"dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat simpleDateFormatddMMYYAMPM = new SimpleDateFormat(
	"dd/MM/yyyy hh:mm aa");
	SimpleDateFormat simpleDateFormatddMMYY1 = new SimpleDateFormat(
	"dd/MM/yyyy");
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	SimpleDateFormat simpleDateFormatdd_MM_YY = new SimpleDateFormat(
	"dd-MM-yyyy");
	DecimalFormat df = new DecimalFormat("#.##");

	/**
	 * converts minutes into HH.MM format
	 * @param minutes
	 * @return
	 */
	public String convertMinutesToHHMMFormat1(int minutes) 
	{
		String duration="";
		
		long durationHrslong = minutes / 60;
		String durationHrs = String.valueOf(durationHrslong);
		if(durationHrs.length()==1)
		{
			durationHrs = "0"+ durationHrs;
		}
		
		long durationMinsLong = minutes % 60;
		String durationMins = String.valueOf(durationMinsLong);
		if(durationMins.length()==1)
		{
			durationMins = "0"+ durationMins;
		}
		
		duration = durationHrs + ":" + durationMins;
		
		return duration;
	}
	public ArrayList<Object> getSandVehicleMasterDetails(int systemId,int clientId)
	{
		
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	int slcount = 0; 
    	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
    	ArrayList<Object> finlist = new ArrayList<Object>();
    	
    	headersList.add("ID");
    	headersList.add("SLNO");
    	headersList.add("Vehicle Number");
    	headersList.add("Chassis NO");
    	headersList.add("Owner Name");
    	headersList.add("Vehicle Capacity");
    	headersList.add("Tare Weight (kg)");
    	headersList.add("RFID No");
    	headersList.add("Updated By");
    	headersList.add("Updated Date");
    	
    	try{
    		con = DBConnection.getConnectionToDB("AMS");
    		pstmt = con.prepareStatement(SandTSMDCStatement.GET_SAND_VEHICLE_MASTER_DETAILS);
	    	pstmt.setInt(1, systemId);
	    	pstmt.setInt(2, clientId);
	    	rs = pstmt.executeQuery();
    		while (rs.next()) {
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			
    			informationList.add(rs.getInt("ID"));
    			obj.put("IdIndex", rs.getString("ID"));
    			
    			informationList.add(Integer.toString(slcount));
    			obj.put("slnoIndex", slcount);
    			
    			informationList.add(rs.getString("VEHICLE_NO"));
    			obj.put("vehicleNoIndex", rs.getString("VEHICLE_NO"));
    			
    			informationList.add(rs.getString("CHASSIS_NO"));
    			obj.put("chassisNoIndex", rs.getString("CHASSIS_NO"));
    			
    			
    			informationList.add(rs.getString("OWNER_NAME"));
    			obj.put("ownerNameIndex", rs.getString("OWNER_NAME"));
    			
    			informationList.add(rs.getString("VEHICLE_CAPACITY"));
    			obj.put("vehicleCapacityIndex", rs.getString("VEHICLE_CAPACITY"));
    			
    			informationList.add(rs.getString("TARE_WEIGHT"));
    			obj.put("tareWeightIndex", rs.getString("TARE_WEIGHT"));
    			
    			informationList.add(rs.getString("RFID_NO"));
    			obj.put("RFIDNoIndex", rs.getString("RFID_NO"));
    			
    			informationList.add(rs.getString("UPDATED_BY"));
    			obj.put("updatedByIndex", rs.getString("UPDATED_BY"));
    			
    			if(!rs.getString("UPDATED_DATE").contains("1900")){
        			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("UPDATED_DATE"))));
        			obj.put("updatedDateIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("UPDATED_DATE"))));
        			}else{
    					obj.put("updatedDateIndex", "");
    					informationList.add("");
    				}
    	
    			jsArr.put(obj);
    			reporthelper.setInformationList(informationList);
    			reportsList.add(reporthelper);
    		}
    		finlist.add(jsArr);
    		finalreporthelper.setReportsList(reportsList);
    		finalreporthelper.setHeadersList(headersList);
    		finlist.add(finalreporthelper);
    	} catch (Exception e) {
    		e.printStackTrace();
    	} finally {
    		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    	}
    		return finlist;
	}
	public JSONArray getVehicleNoList(int systemId,int clientId)
	{
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		JSONArray jsArr = new JSONArray();		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandTSMDCStatement.GET_VEHICLE_NO_LIST);
			rs = pstmt.executeQuery();
			JSONObject jsObj = new JSONObject();
			while(rs.next()) {
				jsObj = new JSONObject();
				jsObj.put("Id", rs.getString("ID"));
				jsObj.put("VehicleNo", rs.getString("VEHICLE_NO"));
				jsObj.put("ChassisNo", rs.getString("CHASSIS_NO"));
				jsObj.put("OwnerName", rs.getString("OWNER_NAME"));
				jsObj.put("VehicleCapacity", rs.getString("VEHICLE_CAPACITY"));
				jsArr.put(jsObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
            DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
		return jsArr;
	}
	
	public String addVehicleMasterDetails(int id,String vehicleNo,String tareWeight, String rfidNo, int systemId,int custId,int userId,String chassisNo,String ownerName,String vehicleCapacity){
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		try{
			if(chassisNo == null || chassisNo.equals("")){
				chassisNo="";
			}if(ownerName == null || ownerName.equals("")){
				ownerName="";
			}if(vehicleCapacity == null || vehicleCapacity.equals("")){
				vehicleCapacity="";
			}
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandTSMDCStatement.CHECK_VEHICLE_NO_ALREADY_EXIST);
			pstmt.setInt(1, id);
			rs = pstmt.executeQuery(); 
			if(rs.next()){
				message="Record already exist, You can modify...";
				return message; 
			}else {
				pstmt = con.prepareStatement(SandTSMDCStatement.INSERT_VEHICLE_MASTER_DETAILS);
				pstmt.setString(1,tareWeight);
				pstmt.setString(2, rfidNo);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, custId);
				pstmt.setInt(5, userId);
				pstmt.setString(6,chassisNo);
				pstmt.setString(7, ownerName);
				pstmt.setString(8, vehicleCapacity);
				pstmt.setString(9, vehicleNo);
				pstmt.setInt(10, id);
				int inserted = pstmt.executeUpdate();
				if (inserted > 0) {
					message = "Record saved successfully...";
				}
			}
		} catch (Exception e){
			System.out.println("error in:-save vehicle details "+e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
	}
	public String modifyVehicleMasterDetails(int id,String vehicleNo,String tareWeight, String rfidNo, int systemId,int custId,int userId){
		Connection con = null;
		PreparedStatement pstmt= null;
		ResultSet rs = null;
		String message="";
		
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandTSMDCStatement.UPDATE_VEHICLE_MASTER_DETAILS);
			pstmt.setString(1, tareWeight);
			pstmt.setString(2, rfidNo);
			pstmt.setString(3, vehicleNo);
			pstmt.setInt(4, id);
			int inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				message = "Record updated successfully...";
			}
		} catch (Exception e){
			System.out.println("error in:-update vehicle details "+e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
		return message;
	}
	//-----------------t4u445-------------------//
	public JSONArray getRFIDForWeighBridge(int clientId, int systemId, String rfidNumber) {
		JSONArray JsonArray = new JSONArray();
		JSONArray arr = new JSONArray();
		JSONObject JsonObject = new JSONObject();
		JSONObject JsonObject1 = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String vehicleNo = "";
		String tareWeight="0.0";
		String transitPass="";
		String transitPermitQty="";
		String orderId="";
		String transitPermitDate="";
		String status="";
		try {
			//rfidNumber=getRFIDFromFile(ip);
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandTSMDCStatement.GET_VEHICLE_NUMBER_BASED_ON_RFID_FOR_WEIGH_BRIDGE);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, rfidNumber);
			rs = pstmt.executeQuery();
			JsonObject = new JSONObject();
			while (rs.next()) {
				vehicleNo = rs.getString("VEHICLE_NO");
				tareWeight = rs.getString("TARE_WEIGHT");
				
				arr= getTsOnlineWebServiceData(vehicleNo);
				JsonObject1 = new JSONObject();
				JsonObject1=arr.getJSONObject(0);
				
				orderId=(String)JsonObject1.get("ORDER_ID");
				transitPass=(String)JsonObject1.get("TRANSIT_NO");
				transitPermitDate=(String)JsonObject1.get("TRANSIT_DATE");
				transitPermitQty=(String)JsonObject1.get("TRANSIT_QUANTITY");
				status=(String)JsonObject1.get("STATUS");
				
				String checkTransit=checkTransit (transitPass, vehicleNo);
				
				JsonObject.put("vehicleNo", vehicleNo);
				JsonObject.put("tareWeight", tareWeight);
				JsonObject.put("transitPermit", transitPass);
				JsonObject.put("transitPermitQty", transitPermitQty);
				JsonObject.put("orderId", orderId);
				JsonObject.put("transitPermitDate", transitPermitDate);
				JsonObject.put("TsOnlineDatastatus", status);
				JsonObject.put("checkTransitstatus", checkTransit);
				
				JsonArray.put(JsonObject);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return JsonArray;
	}
	
	
	
	//-------------------------------SAVE SAND WEIGHT DETAILS-----------------------------------//
	public String saveWeighBridgeInformation( int systemId, int userId, int customerId,String transitPermit, String assetNo, String tareWeight,
			String grossWeight, String netWeight,String transitPassQuantity,String orderId,String transitPassDate) {

		String message = "";
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		double weighedQty=0.0;
		String uploadWeighingDataStatus="";
		double transitPassQty=0.0;
		try {
			int inserted = 0;
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandTSMDCStatement.SAVE_SAND_WEIGH_BRIDGE_DATA);
			pstmt.setString(1, transitPermit);
			pstmt.setString(2, assetNo);
			pstmt.setString(3, tareWeight);
			pstmt.setString(4, grossWeight);
			pstmt.setString(5, netWeight);
			pstmt.setInt(6, systemId);
			pstmt.setInt(7, customerId);
			pstmt.setInt(8, userId);
			pstmt.setString(9, orderId);
			pstmt.setString(10, transitPassQuantity);
			pstmt.setString(11, transitPassDate);
			inserted = pstmt.executeUpdate();
			if (inserted > 0) {
				//message = "Weight Details Saved Successfully";
				weighedQty = Double.parseDouble(netWeight);
				weighedQty = weighedQty/1529.20;
				if((orderId != null && !orderId.equals("")) && (transitPermit != null && !transitPermit.equals("")) && (assetNo!=null && !assetNo.equals("")) && (transitPassQuantity != null && !transitPassQuantity.equals("")) ){
					uploadWeighingDataStatus = uploadVehicleWeighingQuantity (orderId,transitPermit,assetNo,weighedQty);
						if(uploadWeighingDataStatus.equals("True")){
							message = "Weight Details Saved and Uploaded to TsOnline Successfully ";
						}else{
							message = "Weight Details Saved Successfully and Error in uploading to TsOnline";
						} 
				}else{
					message = "Weight Details Saved Successfully";
				}
			} else {
				message = "Error in Saving Weight Details";
			}
			transitPassQty = Double.parseDouble(transitPassQuantity);
			if(weighedQty > transitPassQty){
				pstmt = con.prepareStatement(SandTSMDCStatement.GET_EMAIL_DETAILS);
				pstmt.setInt(1, systemId);
				rs = pstmt.executeQuery();
				if(rs.next()){
					String emailList = rs.getString("value");
					//triggerMail(con,transitPermit,assetNo, systemId, customerId, netWeight, orderId, transitPassDate,  transitPassQty,weighedQty,emailList);
				}
				
			}
			
		} catch (Exception e) {
			System.out.println("Error in Saving Weight Details :-saveWeighBridgeInformation" + e.toString());
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return message;
	}
	public ArrayList<Object> getSandWeighBridgeDetails(String startDate,String endDate,int systemId,int clientId)
	{
		
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	int slcount = 0; 
    	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
    	ArrayList<Object> finlist = new ArrayList<Object>();
    	
    	headersList.add("SLNO");
    	headersList.add("Order Id");
    	headersList.add("Transit Permit");
    	headersList.add("Vehicle No.");
    	headersList.add("Tare Weight");
    	headersList.add("Gross Weight");
    	headersList.add("Net Weight");
    	headersList.add("Date");
    	
    	try{
    		con = DBConnection.getConnectionToDB("AMS");
    		pstmt = con.prepareStatement(SandTSMDCStatement.GET_SAND_WEIGH_BRIDGE_DETAILS);
	    	pstmt.setInt(1, systemId);
	    	pstmt.setInt(2, clientId);
	    	pstmt.setString(3, startDate);
	    	pstmt.setString(4, endDate);
	    	
	    	rs = pstmt.executeQuery();
    		while (rs.next()) {
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			
    			informationList.add(Integer.toString(slcount));
    			obj.put("slnoIndex", slcount);
    			
    			informationList.add(rs.getString("ORDER_ID"));
    			obj.put("orderIdDataIndex", rs.getString("ORDER_ID"));
    			
    			informationList.add(rs.getString("TRANSIT_PERMIT"));
    			obj.put("transitPermitDataIndex", rs.getString("TRANSIT_PERMIT"));
    			
    			informationList.add(rs.getString("VEHICLE_NO"));
    			obj.put("vehicleNoDataIndex", rs.getString("VEHICLE_NO"));
    			
    			informationList.add(rs.getString("TARE_WEIGHT"));
    			obj.put("tareWeightDataIndex", rs.getString("TARE_WEIGHT"));
    			
    			informationList.add(rs.getString("GROSS_WEIGHT"));
    			obj.put("grossWeightDataIndex", rs.getString("GROSS_WEIGHT"));
    			
    			informationList.add(rs.getString("NET_WEIGHT"));
    			obj.put("netWeightDataIndex", rs.getString("NET_WEIGHT"));
    			
    			if(!rs.getString("INSERTED_DATE_TIME").contains("1900")){
        			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("INSERTED_DATE_TIME"))));
        			obj.put("DateDataIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("INSERTED_DATE_TIME"))));
        			}else{
    					obj.put("DateDataIndex", "");
    					informationList.add("");
    				}
    	
    			jsArr.put(obj);
    			reporthelper.setInformationList(informationList);
    			reportsList.add(reporthelper);
    		}
    		finlist.add(jsArr);
    		finalreporthelper.setReportsList(reportsList);
    		finalreporthelper.setHeadersList(headersList);
    		finlist.add(finalreporthelper);
    	} catch (Exception e) {
    		e.printStackTrace();
    	} finally {
    		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    	}
    		return finlist;
	}
	public ArrayList<Object> getTransitViolationDetails(String startDate,String endDate,int systemId,int clientId,int reportType)
	{
		
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	int slcount = 0; 
    	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
    	ArrayList<Object> finlist = new ArrayList<Object>();
    	double weightDifference = 0.0;
    	String weightDiff = "";
    	
    	headersList.add("SLNO");
    	headersList.add("Order Id");
    	headersList.add("Sand Customer Name");
    	headersList.add("Transit Permit");
    	headersList.add("Vehicle No");
    	headersList.add("Transit Permit Date/Time");
    	headersList.add("Transit Issued Quantity (CuM)");
    	headersList.add("Weigh Bridge Quantity (CuM)");
    	headersList.add("Weigh Bridge Date/Time");
    	headersList.add("Time Difference (min)");
    	headersList.add("Weight Difference (CuM)");
    	
    	try{
    		con = DBConnection.getConnectionToDB("AMS");
    		if(reportType == 1){
    			pstmt = con.prepareStatement(SandTSMDCStatement.GET_TRANSIT_PERMIT_VIOLATION_DETAILS.replace("#", " DATEDIFF(minute,a.TRANSIT_PASS_DATE_TIME,isnull(b.INSERTED_DATE_TIME,GETDATE())) > 120 "));
    		}else if(reportType == 2){
    			pstmt = con.prepareStatement(SandTSMDCStatement.GET_TRANSIT_PERMIT_VIOLATION_DETAILS.replace("#", " isnull(cast(b.NET_WEIGHT/1529.20 as decimal(10,2)),0) - isnull(a.DELIVERED_QUANTITY,0) > 0 "));
    		}
    		pstmt.setString(1, startDate);
	    	pstmt.setString(2, endDate);
	    	rs = pstmt.executeQuery();
    		while (rs.next()) {
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			
    			informationList.add(Integer.toString(slcount));
    			obj.put("slnoIndex", slcount);
    			
    			informationList.add(rs.getString("ORDER_ID"));
    			obj.put("orderIdDataIndex", rs.getString("ORDER_ID"));
    			
    			informationList.add(rs.getString("CUSTOMER_NAME"));
    			obj.put("customerDataIndex", rs.getString("CUSTOMER_NAME"));
    			
    			informationList.add(rs.getString("TRANSIT_PERMIT"));
    			obj.put("transitPermitDataIndex", rs.getString("TRANSIT_PERMIT"));
    			
    			informationList.add(rs.getString("VEHICLE_NO"));
    			obj.put("vehicleNoDataIndex", rs.getString("VEHICLE_NO"));
    			
    			if(!rs.getString("TRANSIT_PASS_TIME").contains("1900")){
        			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("TRANSIT_PASS_TIME"))));
        			obj.put("transitDateDataIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("TRANSIT_PASS_TIME"))));
        			}else{
    					obj.put("transitDateDataIndex", "");
    					informationList.add("");
    				}
    			
    			informationList.add(rs.getString("TRANSIT_QUANTITY"));
    			obj.put("transitQtyDataIndex", rs.getString("TRANSIT_QUANTITY"));
    			
    			informationList.add(rs.getString("WEIGH_BRIDGE_QTY"));
    			obj.put("weighBridgeQtyDataIndex", rs.getString("WEIGH_BRIDGE_QTY"));
    			

    			if(!rs.getString("WEIGH_BRIDGE_TIME").contains("1900")){
        			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("WEIGH_BRIDGE_TIME"))));
        			obj.put("weighBridgeDateDataIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("WEIGH_BRIDGE_TIME"))));
        			}else{
    					obj.put("weighBridgeDateDataIndex", "");
    					informationList.add("");
    				}
    			
    			String detentionTime=convertMinutesToHHMMFormat1(Integer.parseInt(rs.getString("DETENTION_TIME")));
                if(detentionTime!=null && !detentionTime.equals("")){
                	informationList.add(detentionTime);
        			obj.put("timeDiffDataIndex", detentionTime);
                }else{
	    			informationList.add("");
	    			obj.put("timeDiffDataIndex", "");
                }
                
    			weightDifference = rs.getDouble("WEIGHT_DIFFERENCE");
    			if(weightDifference>0)
    				weightDiff = df.format(Math.abs(weightDifference))+" CuM More";
    			else if(weightDifference<0)
    				weightDiff = df.format(Math.abs(weightDifference))+" CuM Less";
    			else
    				weightDiff = String.valueOf(Math.abs(weightDifference));
    			
    			informationList.add(weightDiff);
    			obj.put("weightDiffDataIndex", weightDiff);
    	
    			jsArr.put(obj);
    			reporthelper.setInformationList(informationList);
    			reportsList.add(reporthelper);
    		}
    		finlist.add(jsArr);
    		finalreporthelper.setReportsList(reportsList);
    		finalreporthelper.setHeadersList(headersList);
    		finlist.add(finalreporthelper);
    	} catch (Exception e) {
    		e.printStackTrace();
    	} finally {
    		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    	}
    		return finlist;
	}
	public ArrayList<Object> getWeighBridgeViolationDetails(String startDate,String endDate,int systemId,int clientId,int reportType)
	{
		
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	int slcount = 0; 
    	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
    	ArrayList<Object> finlist = new ArrayList<Object>();
    	double weightDifference = 0.0;
    	String weightDiff = "";
    	
    	headersList.add("SLNO");
    	headersList.add("Order Id");
    	headersList.add("Transit Permit");
    	headersList.add("Vehicle No");
    	headersList.add("Transit Permit Quantity");
    	headersList.add("Tare Weight (CuM)");
    	headersList.add("Gross Weight (CuM)");
    	headersList.add("Net Weight (CuM)");
    	headersList.add("Tare Weight (kg)");
    	headersList.add("Gross Weight (kg)");
    	headersList.add("Net Weight (kg)");
    	headersList.add("Insert Date/Time");
    	headersList.add("Weighr Difference");
    	
    	
    	try{
    		con = DBConnection.getConnectionToDB("AMS");
    		if(reportType == 1){
    			pstmt = con.prepareStatement(SandTSMDCStatement.GET_WEIGH_BRIDGE_VIOLATION_DETAILS
    					.replace("#", " "));
    		}
    		else if(reportType == 2){
    			pstmt = con.prepareStatement(SandTSMDCStatement.GET_WEIGH_BRIDGE_VIOLATION_DETAILS
    					.replace("#", " TRANSIT_PERMIT in (select TRANSIT_PERMIT from dbo.SAND_MINING_WEIGH_BRIDGE_DATA group by TRANSIT_PERMIT having count(*)>1 ) and "));
    		}
    		pstmt.setString(1, startDate);
	    	pstmt.setString(2, endDate);
	    	rs = pstmt.executeQuery();
    		while (rs.next()) {
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			
    			informationList.add(Integer.toString(slcount));
    			obj.put("slnoIndex", slcount);
    			
    			informationList.add(rs.getString("ORDER_ID"));
    			obj.put("orderIdDataIndex", rs.getString("ORDER_ID"));
    			
    			informationList.add(rs.getString("TRANSIT_PERMIT"));
    			obj.put("transitPermitDataIndex", rs.getString("TRANSIT_PERMIT"));
    			
    			informationList.add(rs.getString("VEHICLE_NO"));
    			obj.put("vehicleNoDataIndex", rs.getString("VEHICLE_NO"));
    			
    			informationList.add(rs.getString("TRANSIT_PASS_QUANTITY"));
    			obj.put("transitPassQtyDataIndex", rs.getString("TRANSIT_PASS_QUANTITY"));
    			
    			informationList.add(rs.getString("TARE_WEIGHT"));
    			obj.put("tareWeightDataIndex", rs.getString("TARE_WEIGHT"));
    			
    			informationList.add(rs.getString("GROSS_WEIGHT"));
    			obj.put("grossWeightDataIndex", rs.getString("GROSS_WEIGHT"));
    			
    			informationList.add(rs.getString("NET_WEIGHT"));
    			obj.put("netWeightDataIndex", rs.getString("NET_WEIGHT"));
    			
    			informationList.add(rs.getString("TARE_WEIGHT_KG"));
    			obj.put("tareWeightKgDataIndex", rs.getString("TARE_WEIGHT_KG"));
    			
    			informationList.add(rs.getString("GROSS_WEIGHT_KG"));
    			obj.put("grossWeightKgDataIndex", rs.getString("GROSS_WEIGHT_KG"));
    			
    			informationList.add(rs.getString("NET_WEIGHT_KG"));
    			obj.put("netWeightKgDataIndex", rs.getString("NET_WEIGHT_KG"));
    			
    			if(!rs.getString("INSERTED_DATE_TIME").contains("1900")){
        			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("INSERTED_DATE_TIME"))));
        			obj.put("insertDateDataIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("INSERTED_DATE_TIME"))));
        			}else{
    					obj.put("insertDateDataIndex", "");
    					informationList.add("");
    				}
    			
    			weightDifference = rs.getDouble("WEIGHT_DIFFERENCE");
    			if(weightDifference>0)
    				weightDiff = df.format(Math.abs(weightDifference))+" CuM Over Weight";
    			else if(weightDifference<0)
    				weightDiff = df.format(Math.abs(weightDifference))+" CuM Under Weight";
    			else
    				weightDiff = String.valueOf(Math.abs(weightDifference));
    			
    			informationList.add(weightDiff);
    			obj.put("weightDiffDataIndex", weightDiff);
    			
    			
    			jsArr.put(obj);
    			reporthelper.setInformationList(informationList);
    			reportsList.add(reporthelper);
    		}
    		finlist.add(jsArr);
    		finalreporthelper.setReportsList(reportsList);
    		finalreporthelper.setHeadersList(headersList);
    		finlist.add(finalreporthelper);
    	} catch (Exception e) {
    		e.printStackTrace();
    	} finally {
    		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    	}
    		return finlist;
	}
	
	public ArrayList<Object> getOrderDetailsReport(String startDate,String endDate,int systemId,int clientId)
	{
		
		SimpleDateFormat sdfyyyymmddhhmmss=new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    	Connection con = null;
    	PreparedStatement pstmt = null;
    	ResultSet rs = null;
    	JSONArray jsArr = new JSONArray();
    	JSONObject obj = new JSONObject();
    	double remainingQty = 0.0;
    	double excessQty = 0.0;
    	int slcount = 0; 
    	ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
    	ArrayList<String> headersList = new ArrayList<String>();
    	ReportHelper finalreporthelper = new ReportHelper();
    	ArrayList<Object> finlist = new ArrayList<Object>();
    	
    	headersList.add("SLNO");
    	headersList.add("Order Id");
    	headersList.add("Order Date");
    	headersList.add("Sand Customer Name");
    	headersList.add("Vehicle No");
    	headersList.add("Ordered Quantity (Cu M)");
    	headersList.add("Sold Quantity (Cu M)");
    	headersList.add("Weigh Bridge Quantity (Cu M)");
    	
    	try{
    		con = DBConnection.getConnectionToDB("AMS");
    	
    			pstmt = con.prepareStatement(SandTSMDCStatement.GET_ORDER_DETAILS_REPORT);
    		
    		//pstmt.setString(1, startDate);
	    	//pstmt.setString(2, endDate);
	    	rs = pstmt.executeQuery();
    		while (rs.next()) {
    			obj = new JSONObject();
    			ArrayList<Object> informationList=new ArrayList<Object>();
    			ReportHelper reporthelper=new ReportHelper();
    			slcount++;
    			
    			informationList.add(Integer.toString(slcount));
    			obj.put("slnoIndex", slcount);
    			
    			informationList.add(rs.getString("ORDER_ID"));
    			obj.put("orderIdDataIndex", rs.getString("ORDER_ID"));
    			
    			if(!rs.getString("ORDER_DATE").contains("1900")){
        			informationList.add(sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parseObject(rs.getString("ORDER_DATE"))));
        			obj.put("orderDateDataIndex", sdfyyyymmddhhmmss.format(simpleDateFormatddMMYYYYDB.parse(rs.getString("ORDER_DATE"))));
        			}else{
    					obj.put("orderDateDataIndex", "");
    					informationList.add("");
    				}
    			
    			informationList.add(rs.getString("CUSTOMER_NAME"));
    			obj.put("customerNameDataIndex", rs.getString("CUSTOMER_NAME"));
    			
    			informationList.add(rs.getString("VEHICLE_NO"));
    			obj.put("VehicleNoDataIndex", rs.getString("VEHICLE_NO"));
    			
    			informationList.add(rs.getString("ORDERED_QUANTITY"));
    			obj.put("orderQtyDataIndex", rs.getString("ORDERED_QUANTITY"));
    			
    			informationList.add(rs.getString("SOLD_QUANTITY"));
    			obj.put("soldQtyDataIndex", rs.getString("SOLD_QUANTITY"));
    			
    			double orderQty = Double.parseDouble(rs.getString("ORDERED_QUANTITY"));
    			double soldQty = Double.parseDouble(rs.getString("SOLD_QUANTITY"));
    			remainingQty =  orderQty - soldQty;
    			
    			informationList.add(df.format(remainingQty));
    			obj.put("remainingQtyDataIndex", df.format(remainingQty));
    			
    			informationList.add(rs.getString("WEIGHT_QUANTITY"));
    			obj.put("weightQtyDataIndex", rs.getString("WEIGHT_QUANTITY"));
    			
    			double weightQty = Double.parseDouble(rs.getString("WEIGHT_QUANTITY"));
    			excessQty = weightQty - soldQty;
    			
    			informationList.add(df.format(excessQty));
    			obj.put("excessQtyDataIndex", df.format(excessQty));
    			
    			jsArr.put(obj);
    			reporthelper.setInformationList(informationList);
    			reportsList.add(reporthelper);
    		}
    		finlist.add(jsArr);
    		finalreporthelper.setReportsList(reportsList);
    		finalreporthelper.setHeadersList(headersList);
    		finlist.add(finalreporthelper);
    	} catch (Exception e) {
    		e.printStackTrace();
    	} finally {
    		DBConnection.releaseConnectionToDB(con, pstmt, rs);
    	}
    		return finlist;
	}
	public int getMaxSerialNo(int sid, String cid) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		int max =1;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandTSMDCStatement.GET_MAX_SERIAL_NO);
			pstmt.setInt(1, sid);
			pstmt.setString(2, cid);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				max = rs.getInt("value") + 1;
				
				pstmt = con.prepareStatement(SandTSMDCStatement.UPDATE_MAX_SERIAL_NO);
				pstmt.setInt(1, max);
				pstmt.setInt(2, sid);
				pstmt.setString(3, cid);
				pstmt.executeUpdate();
			}else{
				pstmt = con.prepareStatement(SandTSMDCStatement.INSERT_MAX_SERIAL_NO);
				pstmt.setInt(1, max);
				pstmt.setInt(2, sid);
				pstmt.setString(3, cid);
				pstmt.executeUpdate();
			}
		} catch (Exception e) {
			System.out.println("Exception getting getMaxTSno(): " + e);
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return max;
	}
	public String getWeightCharges(int sid, int cid) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String weightCharges ="0";
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(SandTSMDCStatement.GET_WEIGHT_CHARGES);
			pstmt.setInt(1, sid);
			pstmt.setInt(2, cid);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				weightCharges = rs.getString("value");
			}
		} catch (Exception e) {
			System.out.println("Exception getting getWeightCharges(): " + e);
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return weightCharges;
	}
	public String saveVehicleExcelDetails(int systemId,int userId,int clientId,List<VehicleRegistrationDetailsData> list){
		Connection con = null;
		PreparedStatement pstmt = null;
		int Insertcount=0;
		String message="";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			con.setAutoCommit(false);
			for(VehicleRegistrationDetailsData vehicleDetails:list){
				
				pstmt = con.prepareStatement(SandTSMDCStatement.SAVE_VEHICLE_EXCEL_DETAILS);
				pstmt.setString(1, vehicleDetails.vehicleNumber);
				pstmt.setString(2, vehicleDetails.chassisNumber);
				pstmt.setString(3, vehicleDetails.ownerName);
				pstmt.setString(4,vehicleDetails.vehicleCapacity);
				pstmt.setInt(5,systemId);
				pstmt.setInt(6,clientId);
				Insertcount = pstmt.executeUpdate();
			
				
			}
			con.commit();
			if (Insertcount == 1) {
				message = "<p  >Vehicle Numbers added successfully.</p>";
			}
		}catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, null);
		}
		return message;
	}
	
	public JSONArray getTsOnlineWebServiceData (String vehicle_No){
		JSONArray jsonArray=null;
		try {
		String input1 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"+
		"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"+
		 " <soap:Header>"+
		  "  <UserDetails xmlns=\"http://tempuri.org/\">"+
		   "   <userName>TSMDC@WHG</userName>"+
		    "  <password>TSMDC@WHG@123</password>"+
		    "</UserDetails>"+
		  "</soap:Header>"+
		  "<soap:Body>"+
		    "<DownloadVehicleTransit xmlns=\"http://tempuri.org/\">"+
		     " <VehicleNo>"+vehicle_No+"</VehicleNo>"+
		    "</DownloadVehicleTransit>"+
		  "</soap:Body>"+
		"</soap:Envelope>";
			

				HttpPost httpPost = new HttpPost("http://125.16.9.136:8080/TSSandWeighingWebService/WebServices/SandService.asmx?wsdl");
				StringEntity entity;
				entity = new StringEntity(input1);
				//System.out.println(input1);
				entity.setContentType("application/xml");
				httpPost.setEntity(entity);
				HttpClient httpClient = new DefaultHttpClient();
				httpPost.addHeader("Accept", "text/xml");
				httpPost.setHeader("Content-type", "text/xml");
				HttpResponse httpresponse = httpClient.execute(httpPost);
				String responseBody = EntityUtils.toString(httpresponse.getEntity());
				//System.out.println(responseBody);
				
		        // create message factory
		        MessageFactory mf = MessageFactory.newInstance();
		        // headers for a SOAP message
		        MimeHeaders header = new MimeHeaders();     
		        header.addHeader("Content-Type", "text/xml");

		        // inputStream with your SOAP content... for the 
		        // test I use a fileInputStream pointing to a file
		        // which contains the request showed below
		        InputStream fis = new ByteArrayInputStream(responseBody.getBytes(Charset.forName("UTF-8")));

		        // create the SOAPMessage
		        SOAPMessage soapMessage = mf.createMessage(header,fis);
		        // get the body
		        SOAPBody soapBody = soapMessage.getSOAPBody();
		        // find your node based on tag name
		        NodeList nodes = soapBody.getElementsByTagName("DownloadVehicleTransitResult");

		        // check if the node exists and get the value
		        String someMsgContent = null;
		        Node node = nodes.item(0);
		        someMsgContent = node != null ? node.getTextContent() : "";
		        someMsgContent = someMsgContent.replaceAll("\\[", "");
		        //System.out.println(someMsgContent);
		        //JSONArray jsonArray = new JSONArray(someMsgContent);
		        String status=null;
		        String orderId=null;
		        String transitNo=null;
		        String vehicleNo=null;
		        String transitDate=null;
		        String transitQuantity=null;
		        
		        if(someMsgContent.contains("Status") || someMsgContent.contains("No Data Found")){
		        	status = "No Data Found";
		        	JSONObject jsnobjet1=new JSONObject();
		        	jsonArray=new JSONArray();
		        	jsnobjet1.put("ORDER_ID", "");
		        	jsnobjet1.put("TRANSIT_NO", "");
		        	jsnobjet1.put("VEHICLE_NO", "");
		        	jsnobjet1.put("TRANSIT_DATE", "");
		        	jsnobjet1.put("TRANSIT_QUANTITY", "");
		        	jsnobjet1.put("STATUS", status);
		        	jsonArray.put(jsnobjet1);
		        }else{
		        JSONObject jsnobjet1=new JSONObject();
		        jsonArray=new JSONArray();
		        JSONObject jsnobject = new JSONObject(someMsgContent);
		        orderId = (String) jsnobject.get("ORDER_ID");
		        jsnobjet1.put("ORDER_ID", orderId);
		        transitNo = (String) jsnobject.get("TRANSIT_NO");
		        jsnobjet1.put("TRANSIT_NO", transitNo);
		        vehicleNo = (String) jsnobject.get("VEHICLE_NO");
		        jsnobjet1.put("VEHICLE_NO", vehicleNo);
		        transitDate = (String) jsnobject.get("TRANSIT_DATE");
		        jsnobjet1.put("TRANSIT_DATE", transitDate);
		        transitQuantity = (String) jsnobject.get("TRANSIT_QUANTITY");
		        jsnobjet1.put("TRANSIT_QUANTITY", transitQuantity);
		        jsnobjet1.put("STATUS", "");
		        jsonArray.put(jsnobjet1);
		        }
			}catch (Exception e) {
				e.printStackTrace();
			}
			return jsonArray;
	}
	
	public String uploadVehicleWeighingQuantity (String orderId,String transitNo,String vehicle_No,Double weighinQty){
		String status=null;
		try {
		String input1 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"+
		"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"+
		 " <soap:Header>"+
		  "  <UserDetails xmlns=\"http://tempuri.org/\">"+
		   "   <userName>TSMDC@WHG</userName>"+
		    "  <password>TSMDC@WHG@123</password>"+
		    "</UserDetails>"+
		  "</soap:Header>"+
		  "<soap:Body>"+
		   
		    "<UploadVehicleWeighingQuantity xmlns=\"http://tempuri.org/\">"+
		      "<OrderID>"+orderId+"</OrderID>"+
		      "<TransitNo>"+transitNo+"</TransitNo>"+
		      "<VehicleNo>"+vehicle_No+"</VehicleNo>"+
		      "<WeighingQuantity>"+weighinQty+"</WeighingQuantity>"+
		    "</UploadVehicleWeighingQuantity>"+
		  "</soap:Body>"+
		"</soap:Envelope>";
			

				HttpPost httpPost = new HttpPost("http://125.16.9.136:8080/TSSandWeighingWebService/WebServices/SandService.asmx?wsdl");
				StringEntity entity;
				entity = new StringEntity(input1);
				//System.out.println(input1);
				entity.setContentType("application/xml");
				httpPost.setEntity(entity);
				HttpClient httpClient = new DefaultHttpClient();
				httpPost.addHeader("Accept", "text/xml");
				httpPost.setHeader("Content-type", "text/xml");
				HttpResponse httpresponse = httpClient.execute(httpPost);
				String responseBody = EntityUtils.toString(httpresponse.getEntity());
				//System.out.println(responseBody);
				
		        // create message factory
		        MessageFactory mf = MessageFactory.newInstance();
		        // headers for a SOAP message
		        MimeHeaders header = new MimeHeaders();     
		        header.addHeader("Content-Type", "text/xml");

		        // inputStream with your SOAP content... for the 
		        // test I use a fileInputStream pointing to a file
		        // which contains the request showed below
		        InputStream fis = new ByteArrayInputStream(responseBody.getBytes(Charset.forName("UTF-8")));

		        // create the SOAPMessage
		        SOAPMessage soapMessage = mf.createMessage(header,fis);
		        // get the body
		        SOAPBody soapBody = soapMessage.getSOAPBody();
		        // find your node based on tag name
		        NodeList nodes = soapBody.getElementsByTagName("UploadVehicleWeighingQuantityResult");

		        // check if the node exists and get the value
		        String someMsgContent = null;
		        Node node = nodes.item(0);
		        someMsgContent = node != null ? node.getTextContent() : "";
		        someMsgContent = someMsgContent.replaceAll("\\[", "");
		        //System.out.println(someMsgContent);
		        //JSONArray jsonArray = new JSONArray(someMsgContent);
		        JSONObject jsnobject = new JSONObject(someMsgContent);
		        status = (String) jsnobject.get("Status");
		        System.out.println(status);
		        if(someMsgContent.contains("True")){
		        	status = "True";
		        	
		        }else{
		        	status = "False";
		        } 
			}catch (Exception e) {
				e.printStackTrace();
			}
			return status;
	}
	
	public String checkTransit (String transitNo,String vehicle_No){
		String status=null;
		try {
		String input1 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"+
		"<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"+
		 " <soap:Header>"+
		  "  <UserDetails xmlns=\"http://tempuri.org/\">"+
		   "   <userName>TSMDC@WHG</userName>"+
		    "  <password>TSMDC@WHG@123</password>"+
		    "</UserDetails>"+
		  "</soap:Header>"+
		  "<soap:Body>"+
		   
		    "<CheckTransit xmlns=\"http://tempuri.org/\">"+
		       "<VehicleNo>"+vehicle_No+"</VehicleNo>"+
		       "<TransitNo>"+transitNo+"</TransitNo>"+
		    "</CheckTransit>"+
		  "</soap:Body>"+
		"</soap:Envelope>";
			

				HttpPost httpPost = new HttpPost("http://125.16.9.136:8080/TSSandWeighingWebService/WebServices/SandService.asmx?wsdl");
				StringEntity entity;
				entity = new StringEntity(input1);
				//System.out.println(input1);
				entity.setContentType("application/xml");
				httpPost.setEntity(entity);
				HttpClient httpClient = new DefaultHttpClient();
				httpPost.addHeader("Accept", "text/xml");
				httpPost.setHeader("Content-type", "text/xml");
				HttpResponse httpresponse = httpClient.execute(httpPost);
				String responseBody = EntityUtils.toString(httpresponse.getEntity());
				//System.out.println(responseBody);
				
		        // create message factory
		        MessageFactory mf = MessageFactory.newInstance();
		        // headers for a SOAP message
		        MimeHeaders header = new MimeHeaders();     
		        header.addHeader("Content-Type", "text/xml");

		        // inputStream with your SOAP content... for the 
		        // test I use a fileInputStream pointing to a file
		        // which contains the request showed below
		        InputStream fis = new ByteArrayInputStream(responseBody.getBytes(Charset.forName("UTF-8")));

		        // create the SOAPMessage
		        SOAPMessage soapMessage = mf.createMessage(header,fis);
		        // get the body
		        SOAPBody soapBody = soapMessage.getSOAPBody();
		        // find your node based on tag name
		        NodeList nodes = soapBody.getElementsByTagName("CheckTransitResult");

		        // check if the node exists and get the value
		        String someMsgContent = null;
		        Node node = nodes.item(0);
		        someMsgContent = node != null ? node.getTextContent() : "";
		        someMsgContent = someMsgContent.replaceAll("\\[", "");
		        
		        //JSONArray jsonArray = new JSONArray(someMsgContent);
		        JSONObject jsnobject = new JSONObject(someMsgContent);
		        status = (String) jsnobject.get("Status");
		        
			}catch (Exception e) {
				e.printStackTrace();
			}
			return status;
	}
	
	//--------------Triger mail ---------------------------//
	public static void triggerMail(Connection con,String transitPermit,String assetNo,int systemId,int customerId,String netWeight,String orderId,String transitPassDate, double transitPassQty, 
	    	  double weighedQty,String emailId){
	    try {
	      MailGenerator mailGenerator = new MailGenerator();
	      
	      ArrayList<String> emailList =new  ArrayList<String>();
	      String[] emailIds= emailId.split(",");
	      
	      for(int i=0;i<emailIds.length;i++){
	    	  emailList.add(emailIds[i]);
	      }

	      HashMap<Integer, String> emailTemplate1 = getEmailTemplate(con,transitPermit, assetNo, systemId, customerId, netWeight, orderId, transitPassDate,  transitPassQty, 
					weighedQty );
	      //System.out.println("subject::"+emailTemplate1.get(1));
	      //System.out.println("body::"+emailTemplate1.get(2));

	      String message1 =mailGenerator.send(con, emailList, emailTemplate1.get(2), "CC", true, emailTemplate1.get(1),systemId);
	      
	      if ("Sent".equalsIgnoreCase(message1)) {
	        message1 = "Mail Sent Successfully";
	        System.out.println("Mail Sent Successfully");
	      } else if ("Invalid Mail Address".equalsIgnoreCase(message1)) {
	        message1 = "Falied ,Please Enter Proper Mail Address and try again";
	      } else {
	        message1 = "Not Insetred";
	      }

	    } catch (Exception e) {
	      StringWriter errors = new StringWriter();
	      e.printStackTrace();
	  
	    } finally {
	      DBConnection.releaseConnectionToDB(null, null, null);
	    }
	  }
		
	  public static HashMap<Integer, String> getEmailTemplate(Connection con,String transitPermit,String assetNo,int systemId,int customerId,String netWeight,String orderId,String transitPassDate, double transitPassQty, 
	    	  double weighedQty){
		    HashMap<Integer, String> hashTemplate = null;
		    StringBuilder subject = null;
		    StringBuilder body = null;
		    try {
		      subject = new StringBuilder();
		      body = new StringBuilder();
		      hashTemplate = new HashMap<Integer, String>();

		      body.append("<html><body>" +
		      //Generic body for email
		          "<table border = 0 align=center width=100% height=50 bgcolor=#F80000>"
		          + "<tr><td align=left><font style=font-family:arial size=5 bgcolor=#000000<b>Alert Notification</b></font></td></tr>" + "</table>"
		          + "<p><b>Dear Customer,</b></p>" + "<table>" + "<tr>" + "<td><b>Asset Number</td>" + "<td>:&nbsp; " + assetNo + "</td>"
		          + "<tr>" +"<td><b>Transit Pass Id<b></td>"
		          + "<td>:&nbsp; " + transitPermit + "</td>" + "<tr>" + "<td><b>Order Id</td>" + "<td>:&nbsp; " + orderId + "</td>" 
		          + "<tr>" + "<td><b>Transit Pass Quantity</td>" + "<td>:&nbsp; " + transitPassQty + "</td>" + "<tr>"
		          + "<td><b>Transit Pass Date<b></td>" + "<td>:&nbsp; " + transitPassDate + "</td>"
		          + "<tr>" + "<td><b>Weighed Quantity</td>" + "<td>:&nbsp; " + weighedQty + "</td>" );
		     
		      subject.append("Alert Notification for : " + assetNo);
		      
			  body.append("</body></html>");
		      hashTemplate.put(1, subject.toString());
		      hashTemplate.put(2, body.toString());
		    } catch (Exception e) {
		      StringWriter errors = new StringWriter();
		    }
		    return hashTemplate;
		  }
	
	
}
