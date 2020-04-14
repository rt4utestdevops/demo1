package t4u.functions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.ReportHelper;
import t4u.common.DBConnection;
import t4u.statements.ApOnlineStatements;


public class ApOnlineFunctions {
	
	Connection con = null;
	PreparedStatement pstmt = null,pstmt1=null;
	ResultSet rs = null;
	ResultSet rs1 = null;
	SimpleDateFormat sdfyyyymmddhhmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

	public ArrayList<Object> getNoofEwayBillVSVisitsDetails(int clientId,String startDate,String endDate) {
		
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> ewayBillDetailsFinalList = new ArrayList<Object>();
		
		int count = 0;
		 
		headersList.add("SLNO");
		headersList.add("UNIQUE_ID");
		headersList.add("Vehicle Number");
		headersList.add("Reach Name");
		headersList.add("Reach Entry Date And Time");
		headersList.add("Reach Exit Date and Time");
		headersList.add("eWayBill No");
		headersList.add("Remarks1");
		headersList.add("Remarks2");
		headersList.add("Latitude");
		headersList.add("Longitude");
		headersList.add("Destination");
		 
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ApOnlineStatements.GET_NOOF_EWAYBILLS_VS_VISITS);
			pstmt.setString(1, startDate);
	        pstmt.setString(2, endDate);
	        pstmt.setInt(3, clientId);
	        rs = pstmt.executeQuery();
	        while (rs.next()) {
	        	count++;
	        	jsonObject = new JSONObject();
		        ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();
					
				informationList.add(count);
				jsonObject.put("slnoIndex", count);
				
				informationList.add(rs.getString("UNIQUE_ID"));
			 	jsonObject.put("uniqueIdDataIndex", rs.getString("UNIQUE_ID"));
			 	
			 	informationList.add(rs.getString("VEHICLE_NO"));
			 	jsonObject.put("vehicleNumberDataIndex", rs.getString("VEHICLE_NO"));
	            
	            informationList.add(rs.getString("REACH_NAME"));
	            jsonObject.put("reachNameDataIndex", rs.getString("REACH_NAME"));
	            
	            informationList.add(rs.getString("REACHENTRYDATE"));
	            jsonObject.put("reachEntryDateTimeDataIndex", rs.getString("REACHENTRYDATE"));
	            
				informationList.add(rs.getString("REACHEXITDATE"));
				jsonObject.put("reachExitDateTimeDataIndex", rs.getString("REACHEXITDATE"));
				
				informationList.add(rs.getString("WAY_BILL_NO"));
				jsonObject.put("eWayBillDataIndex", rs.getString("WAY_BILL_NO"));
				
				informationList.add(rs.getString("REMARKS1"));
				jsonObject.put("Remarks1dataIndex", rs.getString("REMARKS1"));
				
				informationList.add(rs.getString("REMARKS2"));
				jsonObject.put("Remarks2dataIndex", rs.getString("REMARKS2"));
				
				if(rs.getString("WAY_BILL_NO")!=null && !rs.getString("WAY_BILL_NO").equals("")){
					
					pstmt = con.prepareStatement(ApOnlineStatements.MDP_DETAILS);
					pstmt.setString(1, rs.getString("VEHICLE_NO"));
			        pstmt.setString(2, rs.getString("WAY_BILL_NO"));
			        pstmt.setString(3, rs.getString("VEHICLE_NO"));
			        pstmt.setString(4, rs.getString("WAY_BILL_NO"));
			        rs1 = pstmt.executeQuery();
			        while (rs1.next()){
			        
			        	informationList.add(rs1.getString("LATITUDE"));
			        	jsonObject.put("latitudeIndex", rs1.getString("LATITUDE"));
					
			        	informationList.add(rs1.getString("LONGITUDE"));
						jsonObject.put("longitudeIndex", rs1.getString("LONGITUDE"));
					
						informationList.add(rs1.getString("To_Palce"));
						jsonObject.put("destinationIndex", rs1.getString("To_Palce"));
			        }
				}
				
				else{
					informationList.add("");
				
		        	informationList.add("");
				
					informationList.add("");
					
				}
	          
	            jsonArray.put(jsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
	        }
	        
	        ewayBillDetailsFinalList.add(jsonArray);
	        finalreporthelper.setReportsList(reportsList);
		    finalreporthelper.setHeadersList(headersList);
		    ewayBillDetailsFinalList.add(finalreporthelper);
		    
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return ewayBillDetailsFinalList; 
	}
	
	
	public String AddRemarks(String uniqueId,int systmeId,String remarks,String recno,int userId)
	{   
		Connection connection = null;
		PreparedStatement pstmt = null;
		int count=0;
		String msg="";
		try
		{
			connection=DBConnection.getConnectionToDB("AMS");
			if (recno.equals("8")){
			pstmt = connection.prepareStatement(ApOnlineStatements.UPDATE_REMARKS1);
			
			}
			else if(recno.equals("9")){
				pstmt = connection.prepareStatement(ApOnlineStatements.UPDATE_REMARKS2);
			}
				pstmt.setString(1,remarks);
				pstmt.setInt(2,userId);
				pstmt.setString(3, uniqueId);
				pstmt.setInt(4, systmeId);
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

	public ArrayList<Object> getVehiclewithOrderCompletionDetails(int clientId,String startDate,String endDate) {
		
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> orderCompletionDetailsFinalList = new ArrayList<Object>();
		
		int count = 0;
		
		headersList.add("SLNO");
		headersList.add("Vehicle Number");
		headersList.add("eWayBill No");
		headersList.add("Sand Reach Name");
		headersList.add("eWayBill Date And Time");
		headersList.add("eWayBill Validity");
		headersList.add("Destination As Per eWayBill");
		headersList.add("ETA");
		headersList.add("Destination Reached Time");
		headersList.add("Delay(Min)");
		headersList.add("Order Status");
		headersList.add("Destination Latitude");
		headersList.add("Destination Longitude");
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ApOnlineStatements.GET_VEHICLE_WITH_ORDER_COMPLETION);
			pstmt.setString(1,startDate);
			pstmt.setString(2,endDate);
			pstmt.setInt(3,clientId);
		    rs = pstmt.executeQuery();
		    while (rs.next()) {
	        	count++;
	            jsonObject = new JSONObject();
	            ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();
				
				informationList.add(count);
				jsonObject.put("slnoIndex", count);
				
				if (rs.getString("VEHICLE_NO") == null || rs.getString("VEHICLE_NO").equals("") || rs.getString("VEHICLE_NO").contains("1900")) {
					informationList.add("");
					jsonObject.put("vehicleNumberDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("VEHICLE_NO"));
	                jsonObject.put("vehicleNumberDataIndex", rs.getString("VEHICLE_NO"));
	            }
				
				if (rs.getString("WAY_BILL_NO") == null || rs.getString("WAY_BILL_NO").equals("") || rs.getString("WAY_BILL_NO").contains("1900")) {
					informationList.add("");
					jsonObject.put("ewayBillNumber", "");
	            } else {
	            	informationList.add(rs.getString("WAY_BILL_NO"));
	                jsonObject.put("ewayBillNumber", rs.getString("WAY_BILL_NO"));
	            }	
				informationList.add(rs.getString("FROM_PLACE"));
                jsonObject.put("reachdataindex", rs.getString("FROM_PLACE"));
				
				if (rs.getString("VALID_FROM_DATE") == null || rs.getString("VALID_FROM_DATE").equals("") || rs.getString("VALID_FROM_DATE").contains("1900")) {
					informationList.add("");
					jsonObject.put("ewayBillDateAndTimeDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("VALID_FROM_DATE"));
	                jsonObject.put("ewayBillDateAndTimeDataIndex", rs.getString("VALID_FROM_DATE"));
	            }
				
				if (rs.getString("VALID_TO_DATE") == null || rs.getString("VALID_TO_DATE").equals("") || rs.getString("VALID_TO_DATE").contains("1900")) {
					informationList.add("");
					jsonObject.put("ewayBillvalidityDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("VALID_TO_DATE"));
	                jsonObject.put("ewayBillvalidityDataIndex", rs.getString("VALID_TO_DATE"));
	            }
	          
				if (rs.getString("TO_PLACE") == null || rs.getString("TO_PLACE").equals("") || rs.getString("TO_PLACE").contains("1900")) {
					informationList.add("");
					jsonObject.put("destinationAsPereWayBillDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("TO_PLACE"));
	                jsonObject.put("destinationAsPereWayBillDataIndex", rs.getString("TO_PLACE"));
	            }
	            
				if (rs.getString("ETA") == null || rs.getString("ETA").equals("") || rs.getString("ETA").contains("1900")) {
					informationList.add("");
					jsonObject.put("expectedDestinationTimeDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("ETA"));
	                jsonObject.put("expectedDestinationTimeDataIndex", rs.getString("ETA"));
	            }
	            
				if (rs.getString("DESTINATION_REACH_TIME") == null || rs.getString("DESTINATION_REACH_TIME").equals("") || rs.getString("DESTINATION_REACH_TIME").contains("1900")) {
					informationList.add("");
					jsonObject.put("destinationReachedTimeDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("DESTINATION_REACH_TIME"));
	                jsonObject.put("destinationReachedTimeDataIndex", rs.getString("DESTINATION_REACH_TIME"));
	            }
	           
	            String delay = "";
	            
	            if(rs.getString("ETA")!=null && !rs.getString("ETA").contains("1900") && rs.getString("DESTINATION_REACH_TIME")!=null){
	            delay = getDate(rs.getString("ETA"),rs.getString("DESTINATION_REACH_TIME"));
	            if(Double.parseDouble(delay) < 0)
	            delay="0";
	            }
	            informationList.add(delay);
	            jsonObject.put("delayDataIndex", delay);
	            
	            String status="";
	            status=rs.getString("ORDER_STATUS");
	            if(status.equals("Destination Not Availabe"))
	            status="Destination Not Available";
	            informationList.add(status);
                jsonObject.put("orderstatusDataIndex", status);
                
	            informationList.add(rs.getString("DESTINATION_LATITUDE"));
                jsonObject.put("latitudeIndex", rs.getString("DESTINATION_LATITUDE"));
                
                informationList.add(rs.getString("DESTINATION_LONGITUDE"));
                jsonObject.put("longitudeIndex", rs.getString("DESTINATION_LONGITUDE"));

	            jsonArray.put(jsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
	         }
		    
		     orderCompletionDetailsFinalList.add(jsonArray);
	         finalreporthelper.setReportsList(reportsList);
	         finalreporthelper.setHeadersList(headersList);
	         orderCompletionDetailsFinalList.add(finalreporthelper);
	         
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		
		return orderCompletionDetailsFinalList; 
	}

	public ArrayList<Object> getRouteDeviationDetails(int clientId,String startDate,String endDate) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> routeDeviationDetailsFinalList = new ArrayList<Object>();
		
		int count = 0;
		
		headersList.add("SLNO");
		headersList.add("Vehicle Number");
		headersList.add("eWayBill No");
		headersList.add("Sand Reach Name");
		headersList.add("eWayBill Date");
		headersList.add("Customer Name");
		headersList.add("Customer Address");
		headersList.add("Destination Reached");
		headersList.add("Distance Between Delivery To Order Location");
		headersList.add("Destination Latitude");
		headersList.add("Destination Longitude");
		headersList.add("Driver Name");
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ApOnlineStatements.GET_ROUTE_DEVIATION);
			pstmt.setString(1,startDate);
			pstmt.setString(2,endDate);
			pstmt.setInt(3,clientId);
			pstmt.setString(4,startDate);
			pstmt.setString(5,endDate);
			pstmt.setInt(6,clientId);
			
			
		    rs = pstmt.executeQuery();
			while (rs.next()) {
				count++;
	            ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();
				jsonObject = new JSONObject();
	            
	            informationList.add(count);
	            jsonObject.put("slnoIndex", count);
				
				if (rs.getString("VEHICLE_NO") == null || rs.getString("VEHICLE_NO").equals("") || rs.getString("VEHICLE_NO").contains("1900")) {
					informationList.add("");
					jsonObject.put("vehicleNumber1DataIndex", "");
	            } else {
	            	informationList.add(rs.getString("VEHICLE_NO"));
	            	jsonObject.put("vehicleNumber1DataIndex", rs.getString("VEHICLE_NO"));
	            }
				
				if (rs.getString("WAY_BILL_NO") == null || rs.getString("WAY_BILL_NO").equals("") || rs.getString("WAY_BILL_NO").contains("1900")) {
					informationList.add("");
					jsonObject.put("wayBillNumberDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("WAY_BILL_NO"));
	            	jsonObject.put("wayBillNumberDataIndex", rs.getString("WAY_BILL_NO"));
	            }
				
				if (rs.getString("FROM_PLACE") == null || rs.getString("FROM_PLACE").equals("") || rs.getString("FROM_PLACE").contains("1900")) {
					informationList.add("");
					jsonObject.put("reachNameDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("FROM_PLACE"));
	            	jsonObject.put("reachNameDataIndex", rs.getString("FROM_PLACE"));
	            }
	            
				if (rs.getString("VALID_FROM_DATE") == null || rs.getString("VALID_FROM_DATE").equals("") || rs.getString("VALID_FROM_DATE").contains("1900")) {
					informationList.add("");
					jsonObject.put("ewaybilldateindex", "");
	            } else {
	            	informationList.add(rs.getString("VALID_FROM_DATE"));
	            	jsonObject.put("ewaybilldateindex", rs.getString("VALID_FROM_DATE"));
	            }
	            
				if (rs.getString("CUSTOMER_NAME") == null || rs.getString("CUSTOMER_NAME").equals("") || rs.getString("CUSTOMER_NAME").contains("1900")) {
					informationList.add("");
					jsonObject.put("clientNameDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("CUSTOMER_NAME"));
	            	jsonObject.put("clientNameDataIndex", rs.getString("CUSTOMER_NAME"));
	            }
	            
				if (rs.getString("TO_PLACE") == null || rs.getString("TO_PLACE").equals("") || rs.getString("TO_PLACE").contains("1900")) {
					informationList.add("");
					jsonObject.put("clientAddressDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("TO_PLACE"));
	            	jsonObject.put("clientAddressDataIndex", rs.getString("TO_PLACE"));
	            }
				
				informationList.add("N/A");
				jsonObject.put("destinationReachedDataIndex", "N/A");
				
				informationList.add("");
				//jsonObject.put("distanceDataIndex", "");
				
	           
				if (rs.getString("DESTINATION_LATITUDE") == null || rs.getString("DESTINATION_LATITUDE").equals("") || rs.getString("DESTINATION_LATITUDE").contains("1900")) {
					informationList.add("");
					jsonObject.put("latitudeindex", "");
	            } else {
	            	informationList.add(rs.getString("DESTINATION_LATITUDE"));
	            	jsonObject.put("latitudeindex", rs.getString("DESTINATION_LATITUDE"));
	            }
	            
				if (rs.getString("DESTINATION_LONGITUDE") == null || rs.getString("DESTINATION_LONGITUDE").equals("") || rs.getString("DESTINATION_LONGITUDE").contains("1900")) {
					informationList.add("");
					jsonObject.put("longitudeindex", "");
	            } else {
	            	informationList.add(rs.getString("DESTINATION_LONGITUDE"));
	            	jsonObject.put("longitudeindex", rs.getString("DESTINATION_LONGITUDE"));
	            }
				
				if (rs.getString("Driver_Name") == null || rs.getString("Driver_Name").equals("") || rs.getString("Driver_Name").contains("1900")) {
					informationList.add("");
					jsonObject.put("driverNameIndex", "");
	            } else {
	            	informationList.add(rs.getString("Driver_Name"));
	            	jsonObject.put("driverNameIndex", rs.getString("Driver_Name"));
	            }
	            
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
	        }
			routeDeviationDetailsFinalList.add(jsonArray);
			finalreporthelper.setReportsList(reportsList);
		    finalreporthelper.setHeadersList(headersList);
		    routeDeviationDetailsFinalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return routeDeviationDetailsFinalList;
	}

	public ArrayList<Object> getExcessHaltingDetails(int clientId,String startDate,String endDate,int time_Of_Halt) {
        
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		if(time_Of_Halt==3)
		time_Of_Halt=1;
		else if(time_Of_Halt==4)
		time_Of_Halt=2;
		else time_Of_Halt=3;
			
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> excessHaltingDetailsFinalList = new ArrayList<Object>();
		
		int count = 0;
		
		headersList.add("SLNO");
		headersList.add("VEHICLE NUMBER");
		headersList.add("ISSUED E-WAY BILL NO");
		headersList.add("Sand Reach Name");
		headersList.add("eWayBill DateTime");
		headersList.add("Destination As Per eWayBill");
		headersList.add("Customer Name & Mob No");
		headersList.add("HALT 1 ADDRESS");
		headersList.add("HALT 1 DURATION (DD:HH:MM)");
		headersList.add("HALT 2 ADDRESS");
		headersList.add("HALT 2 DURATION (DD:HH:MM)");
		headersList.add("HALT 3 ADDRESS");
		headersList.add("HALT 3 DURATION (DD:HH:MM)");
		headersList.add("Latitude");
		headersList.add("Longitude");
		
		try {
			 con = DBConnection.getConnectionToDB("AMS");
			 if(time_Of_Halt==3)
				 pstmt= con.prepareStatement(ApOnlineStatements.GET_EXCESS_HALTING.concat(" and TIMES_OF_HALT>=?"));
			 else
				 pstmt= con.prepareStatement(ApOnlineStatements.GET_EXCESS_HALTING.concat(" and TIMES_OF_HALT=?"));
			 
			 pstmt.setString(1,startDate);
			 pstmt.setString(2,endDate);
			 pstmt.setInt(3,clientId);
			 pstmt.setInt(4,time_Of_Halt);
			 rs = pstmt.executeQuery();
			 while (rs.next()) {
				
				count++;
				jsonObject = new JSONObject();
				ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();
				
				informationList.add(count);
				jsonObject.put("slnoIndex", count);
				
				if (rs.getString("VEHICLE_NO") == null || rs.getString("VEHICLE_NO").equals("") || rs.getString("VEHICLE_NO").contains("1900")) {
					informationList.add("");
					jsonObject.put("vehicleNumberDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("VEHICLE_NO"));
	            	jsonObject.put("vehicleNumberDataIndex", rs.getString("VEHICLE_NO"));
	            }
				
				if (rs.getString("WAY_BILL_NO") == null || rs.getString("WAY_BILL_NO").equals("") || rs.getString("WAY_BILL_NO").contains("1900")) {
					informationList.add("");
					jsonObject.put("issedeWayBillNoDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("WAY_BILL_NO"));
	            	jsonObject.put("issedeWayBillNoDataIndex", rs.getString("WAY_BILL_NO"));
	            }	
				
				if(rs.getString("WAY_BILL_NO")!=null && !rs.getString("WAY_BILL_NO").equals("")){
						
					 pstmt1=con.prepareStatement(ApOnlineStatements.MDP_DETAILS);
					 pstmt1.setString(1, rs.getString("VEHICLE_NO"));
					 pstmt1.setString(2, rs.getString("WAY_BILL_NO"));
					 pstmt1.setString(3, rs.getString("VEHICLE_NO"));
					 pstmt1.setString(4, rs.getString("WAY_BILL_NO"));
					 rs1=pstmt1.executeQuery();
				
					 if(rs1.next())
				   {
					informationList.add(rs1.getString("From_Place"));
	            	jsonObject.put("reachdataindex", rs1.getString("From_Place"));	
	            	
	            	informationList.add(rs1.getString("Date_TS"));
	            	jsonObject.put("ewaybilldateIndex", rs1.getString("Date_TS"));	
	            	
	            	informationList.add(rs1.getString("To_Palce"));
	            	jsonObject.put("destinationIndex", rs1.getString("To_Palce"));	
	            	
	            	informationList.add(rs1.getString("CUSTOMER_NAME"));
	            	jsonObject.put("customerDataIndex", rs1.getString("CUSTOMER_NAME"));	
	            	
	            
				 }
					 else
					 {
						 informationList.add("");
						 informationList.add("");
						 informationList.add("");
						 informationList.add("");
						
					 }
				 }
				 
				
				if (rs.getString("HALT_ADDRESS_1") == null || rs.getString("HALT_ADDRESS_1").equals("") || rs.getString("HALT_ADDRESS_1").contains("1900")) {
					informationList.add("");
					jsonObject.put("halt1AddressDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("HALT_ADDRESS_1"));
	            	jsonObject.put("halt1AddressDataIndex", rs.getString("HALT_ADDRESS_1"));
	            }	
				
				if (rs.getString("DURATION_1") == null || rs.getString("DURATION_1").equals("") || rs.getString("DURATION_1").contains("1900")) {
					informationList.add("");
					jsonObject.put("halt1DurationDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("DURATION_1"));
	            	jsonObject.put("halt1DurationDataIndex", rs.getString("DURATION_1"));
	            }	
				
				if (rs.getString("HALT_ADDRESS_2") == null || rs.getString("HALT_ADDRESS_2").equals("") || rs.getString("HALT_ADDRESS_2").contains("1900")) {
					informationList.add("");
					jsonObject.put("halt2AddressDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("HALT_ADDRESS_2"));
	            	jsonObject.put("halt2AddressDataIndex", rs.getString("HALT_ADDRESS_2"));
	            }	
				
				if (rs.getString("DURATION_2") == null || rs.getString("DURATION_2").equals("") || rs.getString("DURATION_2").contains("1900")) {
					informationList.add("");
					jsonObject.put("halt2DurationDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("DURATION_2"));
	            	jsonObject.put("halt2DurationDataIndex", rs.getString("DURATION_2"));
	            }	
				
				if (rs.getString("HALT_ADDRESS_3") == null || rs.getString("HALT_ADDRESS_3").equals("") || rs.getString("HALT_ADDRESS_3").contains("1900")) {
					informationList.add("");
					jsonObject.put("halt3AddressDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("HALT_ADDRESS_3"));
	            	jsonObject.put("halt3AddressDataIndex", rs.getString("HALT_ADDRESS_3"));
	            }	
				
				if (rs.getString("DURATION_3") == null || rs.getString("DURATION_3").equals("") || rs.getString("DURATION_3").contains("1900")) {
					informationList.add("");
					jsonObject.put("halt3DurationDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("DURATION_3"));
	            	jsonObject.put("halt3DurationDataIndex", rs.getString("DURATION_3"));
	            }
				
				if(rs.getString("WAY_BILL_NO")!=null && !rs.getString("WAY_BILL_NO").equals("")){
					
					informationList.add(rs1.getString("LATITUDE"));
		        	jsonObject.put("latitudeIndex", rs1.getString("LATITUDE"));
				
		        	informationList.add(rs1.getString("LONGITUDE"));
					jsonObject.put("longitudeIndex", rs1.getString("LONGITUDE"));	
    	
				} else
				 {
				 informationList.add("");
				 informationList.add("");
				 }
				 
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			excessHaltingDetailsFinalList.add(jsonArray);
			finalreporthelper.setReportsList(reportsList);
		    finalreporthelper.setHeadersList(headersList);
		    excessHaltingDetailsFinalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return excessHaltingDetailsFinalList;
	}

	public ArrayList<Object> getSameVehicleSameDestinationDetails(String vehicleNo,String destinationName,String startDate,String endDate,int systemId, int clientId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> sameVehicleSameDestinationDetailsFinalList = new ArrayList<Object>();
		
		int count = 0;
		
		 headersList.add("SLNO");
		 headersList.add("Vehicle Number");
		 headersList.add("eWayBill No");
		 headersList.add("Delivery Address");
		 headersList.add("Date Of Delivery");
		 headersList.add("Customer Name");
		 headersList.add("No Of Trips");
		 headersList.add("GPS Location");
		 
		 try {
			 con = DBConnection.getConnectionToDB("AMS");
	         pstmt = con.prepareStatement(ApOnlineStatements.GET_SAME_VEHICLE_SAME_DESTINATION);
	         pstmt.setString(1, vehicleNo);
	         pstmt.setString(2, destinationName);
	         pstmt.setInt(3, systemId);
	         pstmt.setInt(4, clientId);
	         pstmt.setString(5, startDate);
	         pstmt.setString(6, endDate);
	         pstmt.setString(7, vehicleNo);
	         pstmt.setString(8, destinationName);
	         pstmt.setInt(9, systemId);
	         pstmt.setInt(10, clientId);
	         pstmt.setString(11, startDate);
	         pstmt.setString(12, endDate);
	         rs = pstmt.executeQuery();
			 while (rs.next()) {
		        	count++;
		        	jsonObject = new JSONObject();
		            ReportHelper reporthelper = new ReportHelper();
					ArrayList<Object> informationList = new ArrayList<Object>();
					
					informationList.add(count);
					jsonObject.put("slnoIndex", count);
		            
					if (rs.getString("Vehicle_No") == null || rs.getString("Vehicle_No").equals("") || rs.getString("Vehicle_No").contains("1900")) {
						informationList.add("");
						jsonObject.put("vehicleNumberDataIndex", "");
		            } else {
		            	informationList.add(rs.getString("Vehicle_No"));
		            	jsonObject.put("vehicleNumberDataIndex", rs.getString("Vehicle_No"));
		            }
					
					if (rs.getString("Trip_Sheet_No") == null || rs.getString("Trip_Sheet_No").equals("") || rs.getString("Trip_Sheet_No").contains("1900")) {
						informationList.add("");
						jsonObject.put("eWayBillsDataIndex", "");
		            } else {
		            	informationList.add(rs.getString("Trip_Sheet_No"));
		            	jsonObject.put("eWayBillsDataIndex", rs.getString("Trip_Sheet_No"));
		            }
					
					if (rs.getString("To_Palce") == null || rs.getString("To_Palce").equals("") || rs.getString("To_Palce").contains("1900")) {
						informationList.add("");
						jsonObject.put("deliveryAddressDataIndex", "");
		            } else {
		            	informationList.add(rs.getString("To_Palce"));
		            	jsonObject.put("deliveryAddressDataIndex", rs.getString("To_Palce"));
		            }
					
					if (rs.getString("To_Date") == null || rs.getString("To_Date").equals("") || rs.getString("To_Date").contains("1900")) {
						informationList.add("");
						jsonObject.put("dateOfDeliveryDataIndex", "");
		            } else {
		            	informationList.add(rs.getString("To_Date"));
		            	jsonObject.put("dateOfDeliveryDataIndex", rs.getString("To_Date"));
		            }
					
					if (rs.getString("CUSTOMER_NAME") == null || rs.getString("CUSTOMER_NAME").equals("") || rs.getString("CUSTOMER_NAME").contains("1900")) {
						informationList.add("");
						jsonObject.put("customerNameDataIndex", "");
		            } else {
		            	informationList.add(rs.getString("CUSTOMER_NAME"));
		            	jsonObject.put("customerNameDataIndex", rs.getString("CUSTOMER_NAME"));
		            }
					
					informationList.add("1");
					jsonObject.put("noOfTripsDataIndex", "1");
		            
		            if (rs.getString("To_Palce") == null || rs.getString("To_Palce").equals("") || rs.getString("To_Palce").contains("1900")) {
						informationList.add("");
						jsonObject.put("gpsLocationDataIndex", "");
		            } else {
		            	informationList.add(rs.getString("To_Palce"));
		            	jsonObject.put("gpsLocationDataIndex", rs.getString("To_Palce"));
		            }
		            jsonArray.put(jsonObject);
		            reporthelper.setInformationList(informationList);
					reportsList.add(reporthelper);
		        }
			 	
			 	 sameVehicleSameDestinationDetailsFinalList.add(jsonArray);
		         finalreporthelper.setReportsList(reportsList);
			     finalreporthelper.setHeadersList(headersList); 
			     sameVehicleSameDestinationDetailsFinalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return sameVehicleSameDestinationDetailsFinalList;
	}

	public ArrayList<Object> getMultipleVehicleSameDestinationDetails(String destinationName,String startDate,String endDate,int systemId,int clientId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> multipleVehicleSameDestinationDetailsFinalList = new ArrayList<Object>();
		
		int count = 0;
		
		headersList.add("SLNO");
		headersList.add("Vehicle Number");
		headersList.add("eWayBill No");
		headersList.add("Delivery Address");
		headersList.add("Date Of Delivery");
		headersList.add("Customer Name");
		headersList.add("No Of Trips");
		headersList.add("GPS Location");
		 
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ApOnlineStatements.GET_MULTIPLE_VEHICLE_SAME_DESTINATION);
			pstmt.setString(1, destinationName);
			pstmt.setInt(2, systemId);
	        pstmt.setInt(3, clientId);
			pstmt.setString(4, startDate);
			pstmt.setString(5, endDate);
			pstmt.setString(6, destinationName);
			pstmt.setInt(7, systemId);
	        pstmt.setInt(8, clientId);
			pstmt.setString(9, startDate);
			pstmt.setString(10, endDate);
			rs = pstmt.executeQuery();
			while (rs.next()) {
	        	count++; 
	            jsonObject = new JSONObject();
	            ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();
				
				informationList.add(count);
				jsonObject.put("slnoIndex", count);
				
				if (rs.getString("Vehicle_No") == null || rs.getString("Vehicle_No").equals("") || rs.getString("Vehicle_No").contains("1900")) {
					informationList.add("");
					jsonObject.put("vehicleNumberDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("Vehicle_No"));
	                jsonObject.put("vehicleNumberDataIndex", rs.getString("Vehicle_No"));
	            }
				
				if (rs.getString("Trip_Sheet_No") == null || rs.getString("Trip_Sheet_No").equals("") || rs.getString("Trip_Sheet_No").contains("1900")) {
					informationList.add("");
					jsonObject.put("ewayBills", "");
	            } else {
	            	informationList.add(rs.getString("Trip_Sheet_No"));
	                jsonObject.put("ewayBills", rs.getString("Trip_Sheet_No"));
	            }
	            
				if (rs.getString("To_Palce") == null || rs.getString("To_Palce").equals("") || rs.getString("To_Palce").contains("1900")) {
					informationList.add("");
					jsonObject.put("deliveryAddressDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("To_Palce"));
	                jsonObject.put("deliveryAddressDataIndex", rs.getString("To_Palce"));
	            }
				
				if (rs.getString("To_Date") == null || rs.getString("To_Date").equals("") || rs.getString("To_Date").contains("1900")) {
					informationList.add("");
					jsonObject.put("dateOfDeliveryDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("To_Date"));
	                jsonObject.put("dateOfDeliveryDataIndex", rs.getString("To_Date"));
	            }
				
				if (rs.getString("CUSTOMER_NAME") == null || rs.getString("CUSTOMER_NAME").equals("") || rs.getString("CUSTOMER_NAME").contains("1900")) {
					informationList.add("");
					jsonObject.put("customerNameDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("CUSTOMER_NAME"));
	                jsonObject.put("customerNameDataIndex", rs.getString("CUSTOMER_NAME"));
	            }
				
				if (rs.getString("TripCount") == null || rs.getString("TripCount").equals("") || rs.getString("TripCount").contains("1900")) {
					informationList.add("");
					jsonObject.put("noOfTripsDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("TripCount"));
	                jsonObject.put("noOfTripsDataIndex", rs.getString("TripCount"));
	            }
				
				if (rs.getString("To_Palce") == null || rs.getString("To_Palce").equals("") || rs.getString("To_Palce").contains("1900")) {
					informationList.add("");
					jsonObject.put("gpsLocationDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("To_Palce"));
	                jsonObject.put("gpsLocationDataIndex", rs.getString("To_Palce"));
	            }
				
				jsonArray.put(jsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			multipleVehicleSameDestinationDetailsFinalList.add(jsonArray);
	        finalreporthelper.setReportsList(reportsList);
		    finalreporthelper.setHeadersList(headersList);
		    multipleVehicleSameDestinationDetailsFinalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		 
		return multipleVehicleSameDestinationDetailsFinalList;
	}

	public ArrayList<Object> getIdleTimeReportDetails(String startDate,String endDate,int recordNo,int systemId,int clientId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> idleTimeDetailsFinalList = new ArrayList<Object>();
		
		int count = 0;

		headersList.add("SLNO");
		headersList.add("VEHICLE NUMBER");
        headersList.add("E-WAY BILL");
        headersList.add("SAND REACH NAME");
        headersList.add("E-WAYBILL DATE");
		headersList.add("REACH ENTRY DATE AND TIME");
		headersList.add("REACH EXIT DATE AND TIME");
		headersList.add("TOTAL WAITING TIME(HH.MM)");
		
		try {
			 con = DBConnection.getConnectionToDB("AMS");
			 if(recordNo==3)
				 pstmt= con.prepareStatement(ApOnlineStatements.GET_IDLE_TIME_REPORT.concat(" AND a.DETENTION>1 AND a.DETENTION<=2 AND a.WAY_BILL_NO IS NOT NULL AND a.WAY_BILL_NO<>'' "));
			 else if(recordNo==4)
				 pstmt= con.prepareStatement(ApOnlineStatements.GET_IDLE_TIME_REPORT.concat(" AND a.DETENTION>2 and a.DETENTION <5 AND a.WAY_BILL_NO IS NOT NULL AND a.WAY_BILL_NO<>'' "));
			 else if(recordNo==5)
				 pstmt= con.prepareStatement(ApOnlineStatements.GET_IDLE_TIME_REPORT.concat(" AND a.DETENTION>=5 AND a.WAY_BILL_NO IS NOT NULL AND a.WAY_BILL_NO<>'' "));
			 else if(recordNo==6)
				 pstmt= con.prepareStatement(ApOnlineStatements.GET_IDLE_TIME_REPORT.concat(" AND a.DETENTION>1 AND a.DETENTION<=2 AND a.WAY_BILL_NO=''"));
			 else if(recordNo==7)
				 pstmt= con.prepareStatement(ApOnlineStatements.GET_IDLE_TIME_REPORT.concat(" AND a.DETENTION>2 AND a.DETENTION<5 AND a.WAY_BILL_NO=''"));
			 else if(recordNo==8)
				 pstmt= con.prepareStatement(ApOnlineStatements.GET_IDLE_TIME_REPORT.concat(" AND a.DETENTION>=5 AND a.WAY_BILL_NO=''"));
			 if(recordNo > 2){
			
			 pstmt.setInt(1, systemId);
			 pstmt.setInt(2, clientId);
			 pstmt.setString(3, startDate);
			 pstmt.setString(4, endDate);
			 rs = pstmt.executeQuery();
			 while (rs.next()) {
				jsonObject = new JSONObject();
				count++;
	            ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();
				
				informationList.add(count);
				jsonObject.put("slnoIndex", count);
				
				if (rs.getString("VEHICLE_NO") == null || rs.getString("VEHICLE_NO").equals("") ) {
					informationList.add("");
					jsonObject.put("vehicleNumberDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("VEHICLE_NO"));
	            	jsonObject.put("vehicleNumberDataIndex", rs.getString("VEHICLE_NO"));
	            }
				if (rs.getString("WAY_BILL_NO") == null || rs.getString("WAY_BILL_NO").equals("") ) {
					informationList.add("");
					jsonObject.put("eWayBillDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("WAY_BILL_NO"));
	            	jsonObject.put("eWayBillDataIndex", rs.getString("WAY_BILL_NO"));
	            }	
				
				if (rs.getString("REACH_NAME") == null || rs.getString("REACH_NAME").equals("") ) {
					informationList.add("");
					jsonObject.put("reachdataindex", "");
	            } else {
	            	informationList.add(rs.getString("REACH_NAME"));
	            	jsonObject.put("reachdataindex", rs.getString("REACH_NAME"));
	            }
				
				if (rs.getString("Date_TS") == null || rs.getString("Date_TS").equals("") || rs.getString("Date_TS").contains("1900")) {
					informationList.add("");
					jsonObject.put("eWayBillDateandTimeDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("Date_TS"));
	            	jsonObject.put("eWayBillDateandTimeDataIndex", rs.getString("Date_TS"));
	            }
	
				if (rs.getString("REACH_ENTRY_DATE") == null || rs.getString("REACH_ENTRY_DATE").equals("") || rs.getString("REACH_ENTRY_DATE").contains("1900")) {
					informationList.add("");
					jsonObject.put("vehicleEntryDateandTimeDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("REACH_ENTRY_DATE"));
	            	jsonObject.put("vehicleEntryDateandTimeDataIndex", rs.getString("REACH_ENTRY_DATE"));
	            }
				
				if (rs.getString("REACH_EXIT_DATE") == null || rs.getString("REACH_EXIT_DATE").equals("") || rs.getString("REACH_EXIT_DATE").contains("1900")) {
					informationList.add("");
					jsonObject.put("vehicleExitDateandTimeDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("REACH_EXIT_DATE"));
	            	jsonObject.put("vehicleExitDateandTimeDataIndex", rs.getString("REACH_EXIT_DATE"));
	            }
				
				if (rs.getString("DETENTION") == null || rs.getString("DETENTION").equals("")) {
					informationList.add("");
					jsonObject.put("totalWaitingTimeDataIndex", "");
	            } else {
	            	String detention=rs.getString("DETENTION").replace(".", ":");
	            	String arr[]=detention.split(":");
	            	int minutes=Integer.parseInt(arr[1]);
	            	if(minutes>59)
	            	{
	            		minutes=minutes-60;
	            	}
	            	detention=arr[0]+"."+String.valueOf(minutes);
	            	informationList.add(detention);
	            	jsonObject.put("totalWaitingTimeDataIndex", detention);
	            }
				jsonArray.put(jsonObject);
				reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
			}
			 }
			idleTimeDetailsFinalList.add(jsonArray);
			finalreporthelper.setReportsList(reportsList);
		    finalreporthelper.setHeadersList(headersList);
		    idleTimeDetailsFinalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return idleTimeDetailsFinalList;
	}

	public ArrayList<Object> getTamperingReportDetails(String startDate,String endDate,int systemId,int clientId,int userId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> tamperingDetailsFinalList = new ArrayList<Object>();
		
		int count = 0;
		
		PreparedStatement pstmt1 = null;
		ResultSet rs1 = null;
		
		headersList.add("SLNO");
		headersList.add("Tampering Location");
		headersList.add("eWayBill No");
		headersList.add("Sand Reach Name");
		headersList.add("eWayBill Date And Time");
		headersList.add("Destination");
		headersList.add("Customer Name");
		headersList.add("Vehicle Number");
		headersList.add("Latitude");
		headersList.add("Longitude");
		
		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(ApOnlineStatements.TAMPERING_ALERT);
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
			pstmt.setString(13, startDate);
		   	pstmt.setString(14, endDate);
		   	pstmt.setString(15, startDate);
		   	pstmt.setString(16, endDate);
    		rs = pstmt.executeQuery();
    		while(rs.next()){
    			count++;
    			jsonObject = new JSONObject();
 	            ReportHelper reporthelper = new ReportHelper();
 				ArrayList<Object> informationList = new ArrayList<Object>();
 				
 				
    			informationList.add(count);
 				jsonObject.put("slnoIndex", count);
 				
    			String vehicleNo=rs.getString("REGISTRATION_NO");
    			String location=rs.getString("LOCATION")+"-"+rs.getString("TIME_OF_BORDER_CROSSED");
    			
    			informationList.add(vehicleNo);
	            	jsonObject.put("vehicleNumberDataIndex",vehicleNo);
	            	
	            	informationList.add(location);
            		jsonObject.put("placeofTamperingDataIndex", location) ;
	            	
	            	
    				informationList.add(rs.getString("Trip_Sheet_No"));
   	            	jsonObject.put("wayBillNumberDataIndex",rs.getString("Trip_Sheet_No"));
   	            	
   	            	informationList.add(rs.getString("From_Place"));
   	            	jsonObject.put("reachNameDataIndex",rs.getString("From_Place"));
            		
   	            	if (rs.getString("Date_TS") == null || rs.getString("Date_TS").equals("") || rs.getString("Date_TS").contains("1900")) {
   		            	informationList.add("");
   		            	jsonObject.put("ewayBillDateAndTimeDataIndex", "");
   		            }else{
   	            	informationList.add(rs.getString("Date_TS"));
            		jsonObject.put("ewayBillDateAndTimeDataIndex", rs.getString("Date_TS")); 
   		            }
            		
            		informationList.add(rs.getString("To_Palce"));
					jsonObject.put("destinationDataIndex", rs.getString("To_Palce"));
            		
            		informationList.add(rs.getString("CUSTOMER_NAME"));
   	            	jsonObject.put("clientNameDataIndex",rs.getString("CUSTOMER_NAME"));
            		
            		informationList.add(rs.getString("LATITUDE"));
		        	jsonObject.put("latitudeIndex", rs.getString("LATITUDE"));
				
		        	informationList.add(rs.getString("LONGITUDE"));
					jsonObject.put("longitudeIndex", rs.getString("LONGITUDE"));
					
            	
            		
    			
    			jsonArray.put(jsonObject);
        		reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
    		}
    		
    		tamperingDetailsFinalList.add(jsonArray);
    		finalreporthelper.setReportsList(reportsList);
  	        finalreporthelper.setHeadersList(headersList);
  	        tamperingDetailsFinalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return tamperingDetailsFinalList;
	}

	public ArrayList<Object> getCrossBorderReportDetails(String startDate,String endDate,int systemId,int clientId,int userId) {

		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = null;
		
		ArrayList<ReportHelper> reportsList = new ArrayList<ReportHelper>();
		ArrayList<String> headersList = new ArrayList<String>();
		ReportHelper finalreporthelper = new ReportHelper();
		ArrayList<Object> crossBorderDetailsFinalList = new ArrayList<Object>();
		
		int count = 0;
		
		headersList.add("SLNO");
		headersList.add("Vehicle Number");
		headersList.add("eWayBill No");
		headersList.add("Sand Reach Name");
		headersList.add("eWayBill Date And Time");
		headersList.add("Customer Name");
		headersList.add("Time Of Border Crossed");
		headersList.add("Destination Reached");
		headersList.add("Order Status");
		
		String sandReachName="";
		String custName="";
		String status="";
		String waybillno="";
		
		try {
			 con = DBConnection.getConnectionToDB("AMS");
			 pstmt = con.prepareStatement(ApOnlineStatements.TAMPERING_ALERT);
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
				pstmt.setString(13, startDate);
			   	pstmt.setString(14, endDate);
			   	pstmt.setString(15, startDate);
			   	pstmt.setString(16, endDate);
			    rs = pstmt.executeQuery();
			 while (rs.next()) {
	        	count++;
	        	jsonObject = new JSONObject();
	            ReportHelper reporthelper = new ReportHelper();
				ArrayList<Object> informationList = new ArrayList<Object>();
				
				informationList.add(count);
				jsonObject.put("slnoIndex", count);
				
				informationList.add(rs.getString("REGISTRATION_NO"));
				jsonObject.put("vehicleNumberDataIndex", rs.getString("REGISTRATION_NO"));
	            
	        	informationList.add(rs.getString("Trip_Sheet_No"));
		        jsonObject.put("ewayBillNumber", rs.getString("Trip_Sheet_No"));
		        	
			    if(rs.getString("Trip_Sheet_No")!=null && !rs.getString("Trip_Sheet_No").equals("")){
	        		 jsonObject.put("reachNameDataIndex", rs.getString("From_Place"));
		             informationList.add(rs.getString("From_Place"));
		         } else {
		             jsonObject.put("reachNameDataIndex", "");
		             informationList.add("");
			     }

	        	if (rs.getString("Date_TS") == null || rs.getString("Date_TS").equals("") || rs.getString("Date_TS").contains("1900")) {
	            	informationList.add("");
	            	jsonObject.put("ewayBillDateAndTimeDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("Date_TS"));
	            	jsonObject.put("ewayBillDateAndTimeDataIndex", rs.getString("Date_TS"));
	            }
	             
	          
	            
	            if(rs.getString("Trip_Sheet_No")!=null && !rs.getString("Trip_Sheet_No").equals("")){
	            	jsonObject.put("clientNameDataIndex", rs.getString("CUSTOMER_NAME"));
	            	informationList.add(rs.getString("CUSTOMER_NAME"));
	            }else {
	            	jsonObject.put("clientNameDataIndex", "");
	            	informationList.add("");
		        }
	            
	            if (rs.getString("TIME_OF_BORDER_CROSSED") == null || rs.getString("TIME_OF_BORDER_CROSSED").equals("") || rs.getString("TIME_OF_BORDER_CROSSED").contains("1900")) {
	            	informationList.add("");
	            	jsonObject.put("timeOfBroderCrossedDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("TIME_OF_BORDER_CROSSED"));
	            	jsonObject.put("timeOfBroderCrossedDataIndex", rs.getString("TIME_OF_BORDER_CROSSED"));
	            }
	            
	            if (rs.getString("To_Palce") == null || rs.getString("To_Palce").equals("")) {
	            	informationList.add("");
	            	jsonObject.put("destinationReachedDataIndex", "");
	            } else {
	            	informationList.add(rs.getString("To_Palce"));
	            	jsonObject.put("destinationReachedDataIndex",  rs.getString("To_Palce"));
	            }
	            
	            if(rs.getString("STATUS").equalsIgnoreCase("InTrip"))
	            	status="In Progress";
	            else status=rs.getString("STATUS");
	            
	            if(rs.getString("STATUS")!=null && !rs.getString("STATUS").equals("")){
	            	jsonObject.put("orderStatusDataIndex", status);
	            	informationList.add(status);
		        }else {
		        	jsonObject.put("orderStatusDataIndex", "");
	            	informationList.add("");
		        }
	            
	            jsonArray.put(jsonObject);
	            reporthelper.setInformationList(informationList);
				reportsList.add(reporthelper);
	        }
			 
			crossBorderDetailsFinalList.add(jsonArray);
	        finalreporthelper.setReportsList(reportsList);
	        finalreporthelper.setHeadersList(headersList); 
	        crossBorderDetailsFinalList.add(finalreporthelper);
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return crossBorderDetailsFinalList;
	}
	
	private String getDate(String startDate, String endDate) {
		
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  

		Date d1 = null;
		Date d2 = null;
		try {
		    d1 = format.parse(startDate);
		    d2 = format.parse(endDate);
		} catch (Exception e) {
		    e.printStackTrace();
		}    

		long diff = d2.getTime() - d1.getTime();
		long diffHours = diff / (60 * 60 * 1000);   
		long diffMinutes = diff / (60 * 1000) % 60;
		diffMinutes = diffMinutes + diffHours *60;
		return diffMinutes+"";
	}
}
