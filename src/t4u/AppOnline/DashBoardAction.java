package t4u.AppOnline;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.common.DBConnection;
import t4u.functions.CommonFunctions;

public class DashBoardAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		
		int systemId = 0;
		int clientId = 0;
		int userId=0;
	
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	
		systemId = loginInfo.getSystemId();
		clientId = loginInfo.getCustomerId();
		userId = loginInfo.getUserId();
		
		String param = "";
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		
		JSONArray JsonArray = null;
	    JSONObject JsonObject = null;
	    
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getDashboardDetails")) {
			try {
			String startDate = sdf.format(sdf.parse(request.getParameter("startDate").replace('T', ' ')));
			String endDate =  sdf.format(sdf.parse(request.getParameter("endDate").replace('T', ' ')));
			String value = request.getParameter("value");
			JsonObject = new JSONObject();
			 switch(Integer.parseInt(value))
			 {
			 case 1: JsonArray = getRouteDeviationDetails(clientId,startDate,endDate);
             if(JsonArray.length()>0){
                 JsonObject.put("routeDeviationRoot", JsonArray);
            } else {
                 JsonObject.put("routeDeviationRoot", "");
            }
		 break;
	
			 case 2: JsonArray = getSameVehicleSameDestinationDetails(startDate,endDate,systemId,clientId);
	                 if(JsonArray.length()>0){
	                     JsonObject.put("sameVehcileSameDestinationRoot", JsonArray);
	                } else {
	                     JsonObject.put("sameVehcileSameDestinationRoot", "");
	                }
				 break;
			 case 3:JsonArray = new JSONArray();
                JsonArray = getMultipleVehicleSameDestination(startDate,endDate,systemId,clientId);
                if(JsonArray.length()>0){
                       JsonObject.put("multipleVehcileDestinationRoot", JsonArray);
                } else {
                       JsonObject.put("multipleVehcileDestinationRoot", "");
                }
				 break;
			 case 4:JsonArray = new JSONArray();
	                JsonArray = getExcessHaltingDashBoardDetails(clientId,startDate,endDate);
	                if(JsonArray.length()>0){
	                       JsonObject.put("excessHaltingDashBoardRoot", JsonArray);
	                } else {
	                       JsonObject.put("excessHaltingDashBoardRoot", "");
	                }
				 break;
			 case 5:JsonArray = new JSONArray();
             JsonArray = getInCompleteOrderDashBoardDetails(clientId,startDate,endDate);
             if(JsonArray.length()>0){
                    JsonObject.put("vehicleswithIncompleteRoot", JsonArray);
             } else {
                    JsonObject.put("vehicleswithIncompleteRoot", "");
             }
			 break;
			 case 6:JsonArray = getNoOfeWayBillsVsVisitsDetails(clientId,startDate,endDate,systemId);
	                if(JsonArray.length()>0){
	                     JsonObject.put("noOfewayBillDetailsRoot", JsonArray);
	                } else {
	                      JsonObject.put("noOfewayBillDetailsRoot", "");
	                }
				 break;
			 case 7:JsonArray = new JSONArray();
					JsonArray = getTamparingDashBoardDetails(startDate,endDate,systemId,clientId,userId);
					if(JsonArray.length()>0){
					JsonObject.put("tamperedDetailsRoot", JsonArray);
					}else{
					JsonObject.put("tamperedDetailsRoot", "");
					}
			 break;
			 case 8:JsonArray = new JSONArray();
	             JsonArray = getIdletimeDashBoardDetails(startDate,endDate,systemId,clientId);
	             if(JsonArray.length()>0){
	                   JsonObject.put("BranchMasterDetailsRoot", JsonArray);
	             } else {
	                   JsonObject.put("BranchMasterDetailsRoot", "");
	             }
				 break;
			 case 9:JsonArray = new JSONArray();
                JsonArray = getCrossBroder(startDate,endDate,systemId,clientId,userId);
                if(JsonArray.length()>0){
                       JsonObject.put("crossBoarderDetailsRoot", JsonArray);
                } else {
                       JsonObject.put("crossBoarderDetailsRoot", "");
                }
				 break;
			 }
				response.getWriter().print(JsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}finally {
		        //DBConnection.releaseConnectionToDB(null, pstmt, rs);
		    }
		} 
	return null;
}
	
	private JSONArray getRouteDeviationDetails(int clientId,String startDate, String endDate) {
		JSONArray JsonArray = new JSONArray();
        JSONObject JsonObject = new JSONObject();
        Connection con = null;
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        PreparedStatement pstmt1 = null;
        ResultSet rs1 = null;
        PreparedStatement pstmt2 = null;
        ResultSet rs2 = null;
        
        try {
              JsonObject.put("slnoIndex", 1);
              con = DBConnection.getConnectionToDB("AMS");
              pstmt= con.prepareStatement("select count(VEHICLE_NO) as VEHICLENO from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='Not Completed' and VALID_FROM_DATE between ? and ? and CUSTOMER_ID=? ");
              pstmt.setString(1, startDate);
              pstmt.setString(2, endDate);
              pstmt.setInt(3, clientId);
              rs = pstmt.executeQuery();
              while(rs.next()) {
            	  	JsonObject.put("totalNoOfRouteDeviationIndex", rs.getString("VEHICLENO"));
              }
              
              pstmt1= con.prepareStatement("select count(*) as LOCATION from AMS.dbo.gpsdata_history_latest where LOCATION<>'No GPS Device Connected' and LOCATION is not null and System_id=229 and CLIENTID=? ");
              pstmt1.setInt(1, clientId);
              rs1 = pstmt1.executeQuery();
              while(rs1.next()) {
            	  JsonObject.put("noOfVehicleIndex", rs1.getString("LOCATION"));  
              }
              
              pstmt2= con.prepareStatement("select count(WAY_BILL_NO) as WAYBILLNO from AMS.dbo.SAND_ORDER_COMPLETION where WAY_BILL_NO is not null and WAY_BILL_NO!='' and VALID_FROM_DATE between ? and ? and CUSTOMER_ID=? ");
              pstmt2.setString(1, startDate);
              pstmt2.setString(2, endDate);
              pstmt2.setInt(3, clientId);
              rs2 = pstmt2.executeQuery();
              while(rs2.next()) {
                    JsonObject.put("eWayBillAssignedIndex", rs2.getString("WAYBILLNO"));
              }
              
              
              JsonArray.put(JsonObject);
              
        } catch (Exception e) {
              e.printStackTrace();
        }finally {
              DBConnection.releaseConnectionToDB(con, pstmt, rs);
        }
        return JsonArray;


	}

	private JSONArray getInCompleteOrderDashBoardDetails(int clientId,String startDate,
			String endDate) {
		 JSONArray JsonArray = new JSONArray();
	        JSONObject JsonObject = new JSONObject();
	        Connection con = null;
	        DecimalFormat df = new DecimalFormat("#.##");
	        PreparedStatement pstmt = null;
	        ResultSet rs = null;
	        
	        PreparedStatement pstmt1 = null;
	        ResultSet rs1 = null;
	        
	        PreparedStatement pstmt2 = null;
	        ResultSet rs2 = null;
	        
	        PreparedStatement pstmt3 = null;
	        ResultSet rs3 = null;
	        
	       double WAYBILLNO =0; 
	       double notComp = 0;
	       double per =0;
	        
	        try {
	              JsonObject.put("slnoIndex", 1);
	              con = DBConnection.getConnectionToDB("AMS");
	              pstmt= con.prepareStatement("select count(*) as LOCATION from AMS.dbo.gpsdata_history_latest where LOCATION<>'No GPS Device Connected' and LOCATION is not null and System_id=229 and CLIENTID=? ");
	              pstmt.setInt(1, clientId);
	              rs = pstmt.executeQuery();
	              while(rs.next()) {
	            	  JsonObject.put("NoofvehiclewithGPSIndex", rs.getString("LOCATION"));  
	              }
	              
	              pstmt1= con.prepareStatement("select count(WAY_BILL_NO) as WAYBILLNO from AMS.dbo.SAND_ORDER_COMPLETION where VALID_FROM_DATE between ? and ? and CUSTOMER_ID=? ");
	              pstmt1.setString(1, startDate);
	              pstmt1.setString(2, endDate);
	              pstmt1.setInt(3, clientId);
	              rs1 = pstmt1.executeQuery();
	              while(rs1.next()) {
	            	  	WAYBILLNO=Double.parseDouble(rs1.getString("WAYBILLNO"));
	                    JsonObject.put("NoofvehicleEwayBillsAssignedDataIndex", rs1.getString("WAYBILLNO"));
	              }
	              

	              pstmt2= con.prepareStatement("select count(VEHICLE_NO) as VEHICLENO,  flag=1 from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='Completed' and VALID_FROM_DATE between ? and ? and CUSTOMER_ID=? "+
                                                "union all "+
												"select count(VEHICLE_NO) as VEHICLENO, flag=2 from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='Not Completed' and VALID_FROM_DATE between  ? and ? and CUSTOMER_ID=? "+
												"union all "+
												"select count(VEHICLE_NO) as VEHICLENO, flag=3 from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='In Progress' and VALID_FROM_DATE between  ? and ? and CUSTOMER_ID=? "+
												"union all "+
												"select count(VEHICLE_NO) as VEHICLENO, flag=4 from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='Completed With Delay' and VALID_FROM_DATE between  ? and ? and CUSTOMER_ID=? "+
												"union all "+
												"select count(VEHICLE_NO) as VEHICLENO, flag=5 from AMS.dbo.SAND_ORDER_COMPLETION where ORDER_STATUS='Destination Not Availabe' and VALID_FROM_DATE between  ? and ? and CUSTOMER_ID=? order by flag ");
	              pstmt2.setString(1, startDate);
	              pstmt2.setString(2, endDate);
	              pstmt2.setInt(3, clientId);
	              pstmt2.setString(4, startDate);
	              pstmt2.setString(5, endDate);
	              pstmt2.setInt(6, clientId);
	              pstmt2.setString(7, startDate);
	              pstmt2.setString(8, endDate);
	              pstmt2.setInt(9, clientId);
	              pstmt2.setString(10, startDate);
	              pstmt2.setString(11, endDate);
	              pstmt2.setInt(12, clientId);
	              pstmt2.setString(13, startDate);
	              pstmt2.setString(14, endDate);
	              pstmt2.setInt(15, clientId);
	              rs2 = pstmt2.executeQuery();
	              while(rs2.next()) {
	            	  switch(rs2.getInt("flag"))
	            	  {
	            	  case 1 : JsonObject.put("VehiclecompleteddeliverycycleDataIndex", rs2.getString("VEHICLENO"));
	            	           break;
	            	  case 2 : notComp=Double.parseDouble(rs2.getString("VEHICLENO"));
	                           JsonObject.put("VehiclenotcompleteddeliveryDataIndex", rs2.getString("VEHICLENO"));
	                           break;
	            	  case 3 : JsonObject.put("inprogressDataIndex", rs2.getString("VEHICLENO"));
	            	  		   break;
	            	  case 4 : 	JsonObject.put("completedelayDataIndex", rs2.getString("VEHICLENO"));	
	            	           break;
	            	  case 5 : JsonObject.put("destinationNADataIndex", rs2.getString("VEHICLENO"));
	            	           break;
	            	  }
	              }

	              if (WAYBILLNO==0)
	              {
	            	per=0;    
	              }
	              else per = (notComp/WAYBILLNO)*100; 
	              String percentage=String.valueOf(per);
	              df.parse(percentage);
	              JsonObject.put("deliverynotcompletedDataIndex", per);
	              
	              JsonArray.put(JsonObject);
	              
	        } catch (Exception e) {
	              e.printStackTrace();
	        }finally {
	              DBConnection.releaseConnectionToDB(con, pstmt, rs);
	              DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
	              DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
	              DBConnection.releaseConnectionToDB(null, pstmt3, rs3);
	        }
	        return JsonArray;
	}

	public JSONArray getSameVehicleSameDestinationDetails(String startDate, String endDate, int systemId, int clientId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			pstmt=conAdmin.prepareStatement("select Vehicle_No,To_Palce as destinationAddress,count(Vehicle_No) as VehicleCount from AMS.dbo.Sand_Mining_Trip_Sheet where "+ 
											" System_Id=? and Client_Id=? and Remarks!='NOT AVAILABLE' and Date_TS between ? and ? group by Vehicle_No,To_Palce union " +
											"select Vehicle_No,To_Palce as destinationAddress,count(Vehicle_No) as VehicleCount from AMS.dbo.Sand_Mining_Trip_Sheet_History where "+ 
											" System_Id=? and Client_Id=? and Remarks!='NOT AVAILABLE' and Date_TS between ? and ? group by Vehicle_No,To_Palce order by count(Vehicle_No) desc ");
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
			pstmt.setString(7, startDate);
			pstmt.setString(8, endDate);
			rs=pstmt.executeQuery();
			while(rs.next()){
				jsonObject=new JSONObject();
				jsonObject.put("vehicleNumberDataIndex", rs.getString("Vehicle_No"));
				jsonObject.put("destinationIndex", rs.getString("destinationAddress"));
				jsonObject.put("noOfTripsDataIndex",  rs.getString("VehicleCount"));
				jsonArray.put(jsonObject);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
		}
		return jsonArray;
	}
	
	public JSONArray getNoOfeWayBillsVsVisitsDetails(int clientId, String startDate, String endDate,int systemId) {
		JSONArray jsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection conAdmin=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		CommonFunctions cf=new CommonFunctions();
		PreparedStatement pstmt1=null;
		ResultSet rs1=null;
		
		PreparedStatement pstmt2=null;
		ResultSet rs2=null;
		
		int reachCount = 0;
		int wayBillCount = 0;
		int differenceCount = 0;
		try {
			conAdmin=DBConnection.getConnectionToDB("AMS");
			
			pstmt=conAdmin.prepareStatement("select count(*) as COUNT,flag=1 from AMS.dbo.gpsdata_history_latest where LOCATION<>'No GPS Device Connected' and LOCATION is not null and System_id=? and CLIENTID=? "+
					"union all "+
					"select count(REACH_NAME) as COUNT,flag=2 from dbo.NO_OF_EWAYBILLS_AND_VISITS where REACH_ENTRY_DATE between ? and ? and CUSTOMER_ID=? and REACH_NAME!='' "+
					"union all "+
					"select count(WAY_BILL_NO) as COUNT,flag=3 from dbo.NO_OF_EWAYBILLS_AND_VISITS where WAY_BILL_NO!='' and WAY_BILL_NO is not null and REACH_ENTRY_DATE between ? and ? and CUSTOMER_ID=? "+
					"union all "+
					"select count(WAY_BILL_NO) as COUNT,flag=4 from AMS.dbo.SAND_ORDER_COMPLETION where VALID_FROM_DATE between ? and ? and CUSTOMER_ID=? order by flag ");
					
					
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, startDate);
			pstmt.setString(4, endDate);
			pstmt.setInt(5, clientId);
			pstmt.setString(6, startDate);
			pstmt.setString(7, endDate);
			pstmt.setInt(8, clientId);
			pstmt.setString(9, startDate);
			pstmt.setString(10, endDate);
			pstmt.setInt(11, clientId);
			
			
			rs=pstmt.executeQuery();
			JsonObject=new JSONObject();
			while(rs.next()){
				      JsonObject.put("slnoDataIndex", 1);
				       switch(rs.getInt("flag"))
	            	  {
	            	  case 1 : JsonObject.put("noOfvehiclesDataIndex", rs.getString("COUNT"));
	            	           break;
	            	  case 2 : JsonObject.put("noOfReachVisitsDataIndex", rs.getString("COUNT"));
	            	           reachCount=rs.getInt("COUNT");
                               break;
	                  case 3 : JsonObject.put("noOfReachVisitseWayBillsDataIndex", rs.getString("COUNT"));
	                           wayBillCount=rs.getInt("COUNT");
	            	  		   break;
	            	  case 4 : 	JsonObject.put("noOfWayBillsIssuedDataIndex", rs.getString("COUNT"));	
	            	           break;
	            	  
	            	  }
			}
			pstmt=conAdmin.prepareStatement("With temp (S)as (select COUNT(*) as COUNT from dbo.Sand_Mining_Trip_Sheet where Remarks='NOT AVAILABLE' "+
                    "and Date_TS between  dateadd(mi,-330,?) and dateadd(mi,-330,?) and System_Id= ? and UPPER(District) = ? union all "+
                    "select COUNT(*) as COUNT from dbo.Sand_Mining_Trip_Sheet_History where Remarks='NOT AVAILABLE' "+
                    "and Date_TS between  dateadd(mi,-330,?) and dateadd(mi,-330,?) and System_Id= ? and UPPER(District) = ? ) select isnull(sum(S),0) as COUNT from temp  ");
			
			pstmt.setString(1, startDate);
			pstmt.setString(2, endDate);
			pstmt.setInt(3, systemId);
			pstmt.setString(4, cf.getCustomerName(String.valueOf(clientId), systemId));
			pstmt.setString(5, startDate);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, systemId);
			pstmt.setString(8, cf.getCustomerName(String.valueOf(clientId), systemId));
			
			rs=pstmt.executeQuery();
			if(rs.next())
			{
				JsonObject.put("withoutGPSDataIndex", rs.getString("COUNT"));
			}
			differenceCount = reachCount - wayBillCount;
			if(differenceCount < 0)
			differenceCount=Math.abs(differenceCount);	
			JsonObject.put("perOfDifferenceInVisitandWayBillDataIndex", differenceCount);
			jsonArray.put(JsonObject);
		} catch (Exception e) {
			e.printStackTrace();
		}
		finally{
			DBConnection.releaseConnectionToDB(conAdmin, pstmt, rs);
			DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
			DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
		}
		return jsonArray;
	}
	
	private JSONArray getExcessHaltingDashBoardDetails(int clientId,String startDate,String endDate) {
		
        JSONArray JsonArray = new JSONArray();
        JSONObject JsonObject = new JSONObject();
        Connection con = null;
        
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        PreparedStatement pstmt1 = null;
        ResultSet rs1 = null;
        
        PreparedStatement pstmt2 = null;
        ResultSet rs2 = null;
        
        try {
              JsonObject.put("slnoIndex", 1);
              con = DBConnection.getConnectionToDB("AMS");
              
              pstmt= con.prepareStatement("select count(*) as LOCATION from AMS.dbo.gpsdata_history_latest where LOCATION<>'No GPS Device Connected' and LOCATION is not null and System_id=229 and CLIENTID=? ");
              pstmt.setInt(1, clientId);
              rs = pstmt.executeQuery();
              while(rs.next()) {
            	  JsonObject.put("NoofvehiclewithGPSIndex", rs.getString("LOCATION"));  
              }
              
              pstmt1= con.prepareStatement("select count(WAY_BILL_NO) as WAYBILLNO from AMS.dbo.SAND_ORDER_COMPLETION where VALID_FROM_DATE between ? and ? and CUSTOMER_ID=? ");
              pstmt1.setString(1, startDate);
              pstmt1.setString(2, endDate);
              pstmt1.setInt(3, clientId);
              rs1 = pstmt1.executeQuery();
              while(rs1.next()) {
            	  	JsonObject.put("NoofvehicleEwayBillsAssignedDataIndex", rs1.getString("WAYBILLNO"));
              }
              pstmt= con.prepareStatement("select count(VEHICLE_NO)as HALT1 from AMS.dbo.EXCESS_HALTING_VEHICLE where SYSTEM_ID=229 and TIMES_OF_HALT=1 and EWAYBILL_DATE between ? and ?  and CUSTOMER_ID=? ");
              pstmt.setString(1, startDate);
              pstmt.setString(2, endDate);
              pstmt.setInt(3, clientId);
              rs = pstmt.executeQuery();
              if(rs.next()) {
                    JsonObject.put("NoofVehicleHaltingOneTimeDataIndex", rs.getString("HALT1"));
              }
              
              pstmt1= con.prepareStatement("select count(VEHICLE_NO)as HALT2 from AMS.dbo.EXCESS_HALTING_VEHICLE where SYSTEM_ID=229 and TIMES_OF_HALT=2 and EWAYBILL_DATE between ? and ? and CUSTOMER_ID=? ");
              pstmt1.setString(1, startDate);
              pstmt1.setString(2, endDate);
              pstmt1.setInt(3, clientId);
              rs1 = pstmt1.executeQuery();
              if(rs1.next()) {
                    JsonObject.put("NoofVehicleHaltingTwoTimeDataIndex", rs1.getString("HALT2"));
              }

              pstmt2= con.prepareStatement("select count(VEHICLE_NO)as HALT3 from AMS.dbo.EXCESS_HALTING_VEHICLE where SYSTEM_ID=229 and TIMES_OF_HALT>2  and EWAYBILL_DATE between ? and ? and CUSTOMER_ID=? ");
              pstmt2.setString(1, startDate);
              pstmt2.setString(2, endDate);
              pstmt2.setInt(3, clientId);
              rs2 = pstmt2.executeQuery();
              if(rs2.next()) {
                    JsonObject.put("NoofVehicleHaltingThreeTimeDataIndex", rs2.getString("HALT3"));
              }

              JsonArray.put(JsonObject);
              
        } catch (Exception e) {
              e.printStackTrace();
        }finally {
              DBConnection.releaseConnectionToDB(con, pstmt, rs);
              DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
              DBConnection.releaseConnectionToDB(null, pstmt2, rs2);
        }
        return JsonArray;
  }
	public JSONArray getCrossBroder(String startDate, String endDate, int systemId, int clientId,int userId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    PreparedStatement pstmt1 = null;
	    ResultSet rs1 = null;
	    PreparedStatement pstmt2 = null;
	    ResultSet rs2 = null;
	   try {
	        int count = 0;
            JsonObject = new JSONObject();
            con = DBConnection.getConnectionToDB("AMS");
	        pstmt=con.prepareStatement("With temp (S)as ( "+
	        		"select Count(*) as S from Alert a inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER "+ 
	        		"left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID   "+
	        		"left outer join tblVehicleMaster vm on  a.REGISTRATION_NO = vm.VehicleNo   "+
	        		"inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no  "+
	        		"where a.GMT BETWEEN dateadd(mi,-330,?) AND dateadd(mi,-330,?) and b.SYSTEM_ID=? and b.CLIENT_ID=? and  a.TYPE_OF_ALERT=? and a.ISREDALERT<>'Y' and  v.User_id=? "+
	        		"UNION ALL  "+ 
	        		"select Count(*) as S from Alert_History a inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER  "+
	        		"left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID  "+ 
	        		"left outer join tblVehicleMaster vm on  a.REGISTRATION_NO = vm.VehicleNo  "+ 
	        		"inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no "+ 
	        		"where a.GMT BETWEEN dateadd(mi,-330,?) AND dateadd(mi,-330,?) and b.SYSTEM_ID=? and b.CLIENT_ID=? and  a.TYPE_OF_ALERT=? and a.ISREDALERT<>'Y' and  v.User_id=? ) select isnull(sum(S),0) as COUNT from temp");
	        				   	
	        				 	pstmt.setString(1, startDate);
	        				   	pstmt.setString(2, endDate);
	        				   	pstmt.setInt(3, systemId);
	        					pstmt.setInt(4, clientId);
	        					pstmt.setInt(5, 84);
	        					pstmt.setInt(6, userId);
	        					pstmt.setString(7, startDate);
	        				   	pstmt.setString(8, endDate);
	        				   	pstmt.setInt(9, systemId);
	        					pstmt.setInt(10, clientId);
	        					pstmt.setInt(11, 84);
	        					pstmt.setInt(12, userId);
	        				   	rs = pstmt.executeQuery();
	        rs = pstmt.executeQuery();
	        if (rs.next()) {
	            //count++;
	            JsonObject.put("noOfVehiclesDataIndex",rs.getString("COUNT"));
	        }
	        
	        pstmt1= con.prepareStatement("select count(*) as LOCATION from AMS.dbo.gpsdata_history_latest where LOCATION<>'No GPS Device Connected' and LOCATION is not null and System_id=? and CLIENTID=? ");
	        pstmt1.setInt(1, systemId);
	        pstmt1.setInt(2, clientId);
	        rs1 = pstmt1.executeQuery();
            while(rs1.next()) {
          	  JsonObject.put("noOfVehicleIndex", rs1.getString("LOCATION"));  
            }
	        
            
            pstmt2= con.prepareStatement("select count(WAY_BILL_NO) as WAYBILLNO from AMS.dbo.SAND_ORDER_COMPLETION where SYSTEM_ID=? and CUSTOMER_ID=? and VALID_FROM_DATE between ? and ?");
            pstmt2.setInt(1, systemId);
			pstmt2.setInt(2, clientId);
            pstmt2.setString(3, startDate);
            pstmt2.setString(4, endDate);
            rs2 = pstmt2.executeQuery();
            while(rs2.next()) {
                  JsonObject.put("eWayBillAssignedIndex", rs2.getString("WAYBILLNO"));
            }
            
            JsonArray.put(JsonObject);

            
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	
	
	public JSONArray getMultipleVehicleSameDestination(String startDate, String endDate, int systemId, int clientId) {
	    JSONArray JsonArray = new JSONArray();
	    JSONObject JsonObject = null;
	    Connection con = null;
	    PreparedStatement pstmt = null;
	    ResultSet rs = null;
	    try {
	        int count = 0;
	        con = DBConnection.getConnectionToDB("ADMINISTRATOR");
	        pstmt = con.prepareStatement("select count(distinct Vehicle_No) as vehicleNo,isnull(To_Palce,'') as destinationPlace,count(Vehicle_No) as tripNo from AMS.dbo.Sand_Mining_Trip_Sheet where "+ 
	        							" System_Id=? and Client_Id=? and Remarks!='NOT AVAILABLE' and Date_TS between ? and ? group by To_Palce union " +
	        							"select count(distinct Vehicle_No) as vehicleNo,isnull(To_Palce,'') as destinationPlace,count(Vehicle_No) as tripNo from AMS.dbo.Sand_Mining_Trip_Sheet_History where "+ 
	        							" System_Id=? and Client_Id=? and Remarks!='NOT AVAILABLE' and Date_TS between ? and ? group by To_Palce order by tripNo desc");
	        pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
	        pstmt.setString(3, startDate);
	        pstmt.setString(4, endDate);
	        pstmt.setInt(5, systemId);
			pstmt.setInt(6, clientId);
	        pstmt.setString(7, startDate);
	        pstmt.setString(8, endDate);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	            JsonObject = new JSONObject();
	            count++;
	            JsonObject.put("noOfVehiclesDataIndex", rs.getString("vehicleNo"));
	            JsonObject.put("sameDestinationIndex", rs.getString("destinationPlace"));
	            JsonObject.put("noOfTripsDataIndex", rs.getString("tripNo"));
	            JsonArray.put(JsonObject);
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        DBConnection.releaseConnectionToDB(con, pstmt, rs);
	    }
	    return JsonArray;
	}
	
	public JSONArray getTamparingDashBoardDetails(String startDate ,String endDate, int systemId, int clientId,int userId){
		JSONArray jsonArray = new JSONArray();
		   	JSONObject JsonObject = null;
		   	Connection con = null;
		   	PreparedStatement pstmt = null,pstmt1=null;
		   	ResultSet rs = null,rs1 = null;
		   	PreparedStatement pstmt2 = null;
		   	ResultSet rs2 = null;
		   	int tampringalert=0;
		   	int turnoffalert=0;
		   	try {
		   	int count = 0;
		   	JsonObject = new JSONObject();
		   	count++;
		   	con = DBConnection.getConnectionToDB("AMS");
		   	
		   	pstmt=con.prepareStatement("With temp (S)as ( "+
"select Count(*) as S from Alert a inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER "+ 
"left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID   "+
"left outer join tblVehicleMaster vm on  a.REGISTRATION_NO = vm.VehicleNo   "+
"inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no  "+
"where a.GMT BETWEEN dateadd(mi,-330,?) AND dateadd(mi,-330,?) and b.SYSTEM_ID=? and b.CLIENT_ID=? and  a.TYPE_OF_ALERT=? and a.ISREDALERT<>'Y' and  v.User_id=? "+
"UNION ALL  "+ 
"select Count(*) as S from Alert_History a inner join VEHICLE_CLIENT b on a.REGISTRATION_NO = b.REGISTRATION_NUMBER  "+
"left outer join VEHICLE_GROUP c on b.GROUP_ID=c.GROUP_ID  "+ 
"left outer join tblVehicleMaster vm on  a.REGISTRATION_NO = vm.VehicleNo  "+ 
"inner join Vehicle_User v on b.REGISTRATION_NUMBER = v.Registration_no "+ 
"where a.GMT BETWEEN dateadd(mi,-330,?) AND dateadd(mi,-330,?) and b.SYSTEM_ID=? and b.CLIENT_ID=? and  a.TYPE_OF_ALERT=? and a.ISREDALERT<>'Y' and  v.User_id=? ) select isnull(sum(S),0) as COUNT from temp");
		   	
		    pstmt.setString(1, startDate);
		   	pstmt.setString(2, endDate);
		   	pstmt.setInt(3, systemId);
			pstmt.setInt(4, clientId);
			pstmt.setInt(5, 7);
			pstmt.setInt(6, userId);
			pstmt.setString(7, startDate);
		   	pstmt.setString(8, endDate);
		   	pstmt.setInt(9, systemId);
			pstmt.setInt(10, clientId);
			pstmt.setInt(11, 7);
			pstmt.setInt(12, userId);
		   	rs = pstmt.executeQuery();
		   	
		   	if(rs.next()){
		   		 JsonObject.put("noOfVehiclesGPSTurnOffDataIndex",rs.getString("COUNT"));
		   		 JsonObject.put("noOfVehiclesGPSTamperedDataIndex",rs.getString("COUNT"));
            		}
		   	
		   
		   	
		   	pstmt1= con.prepareStatement("select count(*) as LOCATION from AMS.dbo.gpsdata_history_latest where LOCATION<>'No GPS Device Connected' and LOCATION is not null and System_id=? and CLIENTID=? ");
		    pstmt1.setInt(1, systemId);
		    pstmt1.setInt(2, clientId);
		   	rs1 = pstmt1.executeQuery();
            while(rs1.next()) {
          	  JsonObject.put("noOfVehicleIndex", rs1.getString("LOCATION"));  
            }
            
            pstmt2= con.prepareStatement("select count(WAY_BILL_NO) as WAYBILLNO from AMS.dbo.SAND_ORDER_COMPLETION where SYSTEM_ID=? and CUSTOMER_ID=? and VALID_FROM_DATE between ? and ?");
            pstmt2.setInt(1, systemId);
			pstmt2.setInt(2, clientId);
            pstmt2.setString(3, startDate);
            pstmt2.setString(4, endDate);
            rs2 = pstmt2.executeQuery();
            while(rs2.next()) {
                  JsonObject.put("eWayBillAssignedIndex", rs2.getString("WAYBILLNO"));
            }
 
            jsonArray.put(JsonObject);

		   	} catch (Exception e) {
		   	e.printStackTrace();
		   	}finally {
		    DBConnection.releaseConnectionToDB(con, pstmt, rs);
		    DBConnection.releaseConnectionToDB(null, pstmt1, rs1);
		   	}
		   	return jsonArray;
		}
	private JSONArray getIdletimeDashBoardDetails(String startDate,String endDate,int systemId, int clientId) {
      JSONArray JsonArray = new JSONArray();
      JSONObject JsonObject = new JSONObject();
      Connection con = null;
   
      PreparedStatement pstmt2 = null,pstmt=null;
      ResultSet rs2 = null,rs=null;
      
      try {
            JsonObject.put("slnoIndex", 1);
            con = DBConnection.getConnectionToDB("AMS");
            
            pstmt= con.prepareStatement("select count(*) as LOCATION from AMS.dbo.gpsdata_history_latest where LOCATION<>'No GPS Device Connected' and LOCATION is not null and System_id=? and CLIENTID=? ");
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, clientId);
            rs = pstmt.executeQuery();
            while(rs.next()) {
          	  JsonObject.put("NoofvehiclewithGPSIndex", rs.getString("LOCATION"));  
            }
            
            pstmt= con.prepareStatement("select count(WAY_BILL_NO) as WAYBILLNO from AMS.dbo.SAND_ORDER_COMPLETION where SYSTEM_ID=? and CUSTOMER_ID=? and VALID_FROM_DATE between ? and ?");
            pstmt.setInt(1, systemId);
            pstmt.setInt(2, clientId);
            pstmt.setString(3, startDate);
            pstmt.setString(4, endDate);
            rs = pstmt.executeQuery();
            while(rs.next()) {
          	  	JsonObject.put("NoofvehicleEwayBillsAssignedDataIndex", rs.getString("WAYBILLNO"));
            }
            
            
            pstmt2=con.prepareStatement("select count(*)as VEHICLE1,flag=1 from NO_OF_EWAYBILLS_AND_VISITS where SYSTEM_ID=? and CUSTOMER_ID=? and DETENTION is not null and DETENTION>1 and DETENTION <= 2 and WAY_BILL_NO is not null and WAY_BILL_NO<>'' and REACH_ENTRY_DATE between ? and ? "+
										"union all "+
										"select count(*)as VEHICLE1,flag=2 from NO_OF_EWAYBILLS_AND_VISITS where SYSTEM_ID=? and CUSTOMER_ID=? and DETENTION is not null and DETENTION > 2.0 and DETENTION < 5.0 and WAY_BILL_NO is not null and WAY_BILL_NO<>'' and REACH_ENTRY_DATE between ? and ?  "+
										"union all "+
										"select count(*)as VEHICLE1,flag=3 from NO_OF_EWAYBILLS_AND_VISITS where SYSTEM_ID=? and CUSTOMER_ID=? and DETENTION is not null and DETENTION >=5 and WAY_BILL_NO is not null and WAY_BILL_NO<>'' and REACH_ENTRY_DATE between ? and ?  "+
										"union all "+
										"select count(*)as VEHICLE1,flag=4 from NO_OF_EWAYBILLS_AND_VISITS where SYSTEM_ID=? and CUSTOMER_ID=? and DETENTION is not null and DETENTION>1 and DETENTION <= 2 and WAY_BILL_NO is not null and WAY_BILL_NO = '' and REACH_ENTRY_DATE between ? and ?  "+
										"union all "+
										"select count(*)as VEHICLE1,flag=5 from NO_OF_EWAYBILLS_AND_VISITS where SYSTEM_ID=? and CUSTOMER_ID=? and DETENTION is not null and DETENTION>2 and DETENTION < 5 and WAY_BILL_NO is not null and WAY_BILL_NO = '' and REACH_ENTRY_DATE between ? and ?  "+
										"union all "+
										"select count(*)as VEHICLE1,flag=6 from NO_OF_EWAYBILLS_AND_VISITS where SYSTEM_ID=? and CUSTOMER_ID=? and DETENTION is not null and DETENTION >=5  and WAY_BILL_NO is not null and WAY_BILL_NO = '' and REACH_ENTRY_DATE between ? and ?  order by flag ");
            pstmt2.setInt(1, systemId);
            pstmt2.setInt(2, clientId);							 
            pstmt2.setString(3, startDate);
            pstmt2.setString(4, endDate);
            pstmt2.setInt(5, systemId);
            pstmt2.setInt(6, clientId);		
            pstmt2.setString(7, startDate);
            pstmt2.setString(8, endDate);
            pstmt2.setInt(9, systemId);
            pstmt2.setInt(10, clientId);		
            pstmt2.setString(11, startDate);
            pstmt2.setString(12, endDate);
            pstmt2.setInt(13, systemId);
            pstmt2.setInt(14, clientId);		
            pstmt2.setString(15, startDate);
            pstmt2.setString(16, endDate);
            pstmt2.setInt(17, systemId);
            pstmt2.setInt(18, clientId);		
            pstmt2.setString(19, startDate);
            pstmt2.setString(20, endDate);
            pstmt2.setInt(21, systemId);
            pstmt2.setInt(22, clientId);		
            pstmt2.setString(23, startDate);
            pstmt2.setString(24, endDate);
            rs2=pstmt2.executeQuery();
            while(rs2.next())
            {
            switch(rs2.getInt("flag"))
            {
				case 1:
					JsonObject.put("idle1to2hrewaybillIndex", rs2
							.getString("VEHICLE1"));
					break;
				case 2:
					JsonObject.put("idle2to5hrewaybillIndex", rs2
							.getString("VEHICLE1"));
					break;
				case 3:
					JsonObject.put("idle5hrewaybillIndex", rs2
							.getString("VEHICLE1"));
					break;
				case 4:
					JsonObject.put("idle1to2hrNoewaybillIndex", rs2
							.getString("VEHICLE1"));
					break;
				case 5:
					JsonObject.put("idle2to5hrNoewaybillIndex", rs2
							.getString("VEHICLE1"));
					break;
				case 6:
					JsonObject.put("idle5hrNoewaybillIndex", rs2
							.getString("VEHICLE1"));
					break;
            }           
            }
            JsonArray.put(JsonObject);
            
            
      } catch (Exception e) {
            e.printStackTrace();
      }finally {
            DBConnection.releaseConnectionToDB(con, pstmt2, rs2);
            
      }
      return JsonArray;
}

}
