package t4u.obd;

import java.util.ArrayList;

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
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.OBDFunctions;


public class OBDActions extends Action{
	
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		HttpSession session = req.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int clientId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offmin = loginInfo.getOffsetMinutes();
		int offset =loginInfo.getOffsetMinutes();
		String param = "";
		if(req.getParameter("param") != null){
			param = req.getParameter("param");
		}
		JSONArray jArr = new JSONArray();
		JSONObject obj = null;
		OBDFunctions obdf = new OBDFunctions();
		CommonFunctions cf=new CommonFunctions();
		String serverName=req.getServerName();
		String sessionId = req.getSession().getId();
		
		if (param.equalsIgnoreCase("getErrorCodeCount")) {
			try {
				jArr =  OBDFunctions.getErrorCodAggregate(systemId,clientId,userId);
				if (jArr.length() > 0) {
					
				} else {
					jArr.put("[]");
				}
				resp.getWriter().print(jArr.toString());
				
			} catch (Exception e) {

			}
		}else if(param.equals("getAlertCount"))
		{
			try {
				 String alertList = ""; //request.getParameter("alertList");
				 
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				jsonArray = OBDFunctions.getAlertCount(alertList,systemId, clientId, userId, offmin);
				if (jsonArray.length() > 0) {
					jsonObject.put("AlertCountRoot", jsonArray);
				} else {
					jsonObject.put("AlertCountRoot", "");
				}
				
				resp.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}else if(param.equals("getAlertCountSecondary"))
		{
			try {
				 String alertList = "OverSpeed"; //req.getParameter("alertList");
				 
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				jsonArray = OBDFunctions.getAlertCountSecondary(alertList,systemId, clientId, userId, offmin);
				if (jsonArray.length() > 0) {
					jsonObject.put("AlertCountSecRoot", jsonArray);
				} else {
					jsonObject.put("AlertCountSecRoot", "");
				}
				resp.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}else if (param.equalsIgnoreCase("getCommNonCommunicatingVehicles")) {
			try
			{
		//	String clientId=req.getParameter("custID");
			JSONArray jsonArray = new JSONArray();
			JSONObject jsonObject = new JSONObject();	
			int isLtsp=0;
			String zone="";
			 
			jsonArray=OBDFunctions.getCommNonCommVehicles(""+clientId, systemId,userId,isLtsp,offmin,zone);
			if(jsonArray.length()>0)
			{
			jsonObject.put("CommNoncommroot", jsonArray);
			}
			else
			{
			jsonObject.put("CommNoncommroot", "");
			}
			resp.getWriter().print(jsonObject.toString());
			}
			catch(Exception e)
			{
				
			}
		}else if (param.equals("getAlertDetails")) {
			
			try {
				
				int isLtsp=0;
				 
				 String alertId = "2"; //let overspeed be default
					String type="All"; //req.getParameter("type");
					 if(req.getParameter("alertParam")!=null){
						 String alertParam=req.getParameter("alertParam");
						 if(alertParam.equalsIgnoreCase("CrossBorder")){
							 alertId ="84";
						 }else if(alertParam.equalsIgnoreCase("NonComm")){
							 alertId ="85";
						 }else if(alertParam.equalsIgnoreCase("DeviceBattery")){
							 alertId ="DeviceBattery";
						 }else if(alertParam.equalsIgnoreCase("TamperCrossBorder")){
							 alertId ="148";
						 }else if(alertParam.equalsIgnoreCase("OverSpeed")){
							 alertId ="2";
						 }
					 }
				
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				jsonArray = OBDFunctions.getAlertDetails(offmin, alertId,systemId, clientId, userId,type);
				if (jsonArray.length() > 0) {
					jsonObject.put("AlertDetailsRoot", jsonArray);
				} else {
					jsonObject.put("AlertDetailsRoot", "");
				}
				resp.getWriter().print(jsonObject.toString());
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getErrorCodeDetails"))
		{
			try {
				 String type="";
				if(req.getParameter("errorType")!=null){
					type=req.getParameter("errorType");
				}
				 JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				try {
					cf.insertDataIntoAuditLogReport(sessionId, null, "OBD Error Code Details", "View", userId, serverName, systemId, clientId, "OBD Error Code Report");
				} catch (Exception e) {
					e.printStackTrace();
				}
				jsonArray = OBDFunctions.getErrorCodeDetails(systemId, clientId,offmin,type,userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("errorCodeDetailsRoot", jsonArray);
				} else {
					jsonObject.put("errorCodeDetailsRoot", "");
				}
				
				resp.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		}else if(param.equals("getVehicleDiagnosticDeatails")){
			String vehicleNo = req.getParameter("vehicleNo");			
			try{
				obj = new JSONObject();
				jArr = obdf.getVehicleDiagnosticDeatails(systemId,clientId,vehicleNo);
				if(jArr.length() > 0){
					obj.put("vehicleDiagnosisDetailsRoot", jArr);
				}else{
					obj.put("vehicleDiagnosisDetailsRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getErrorDeatails")){
			String vehicleNo = req.getParameter("vehicleNo");
			try{
				obj = new JSONObject();
				jArr = obdf.getErrorDeatails(systemId,clientId,vehicleNo,offmin);
				if(jArr.length() > 0){
					obj.put("errorDetailsRoot", jArr);
				}else{
					obj.put("errorDetailsRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getFuelLevelDetails")){
			try{
				obj = new JSONObject();
				jArr = obdf.getFuelLevelDetails(systemId,clientId);
				if(jArr.length() > 0){
					obj.put("fuelDetailsRoot", jArr);
				}else{
					obj.put("fuelDetailsRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getRegNos")){
			try {
				obj = new JSONObject();
				jArr = obdf.getOBDAssetNumberList(systemId, clientId,userId);
				if(jArr.length() > 0){
					obj.put("RegNos", jArr);
				}else{
					obj.put("RegNos", "");
				}
				 resp.getWriter().print(obj);
			} catch (Exception e) {
				e.printStackTrace();
		  }
		}else if(param.equalsIgnoreCase("getOBDFuelReport")){
				try{
	            String startDate = req.getParameter("startdate");
				String endDate = req.getParameter("enddate");
				String jspName=req.getParameter("jspName");
				String vehNo=req.getParameter("vehicleNo");
				obj = new JSONObject();
				ArrayList<Object> list = new ArrayList<Object>();
	            if (vehNo != null && !vehNo.equals("")) {
	            	list = obdf.OBDFuelReport(clientId,systemId,offmin,startDate,endDate,vehNo);
	            	if (list.size() > 0) {
	            		jArr = (JSONArray) list.get(0);
	            		obj.put("OBDFuelConsumptionRoot", jArr);
	            		
	            		ReportHelper reportHelper = (ReportHelper) list.get(1);
	            		req.getSession().setAttribute(jspName, reportHelper);
	            		req.getSession().setAttribute("vehicleNo", vehNo);
	            		req.getSession().setAttribute("startDate", startDate.replace("T", " "));
	            		req.getSession().setAttribute("endDate", endDate.replace("T", " "));
	                } else {
	                	obj.put("OBDFuelConsumptionRoot", "");
	                }
	            } else {
	            	obj.put("OBDFuelConsumptionRoot", "");
	            }
	            resp.getWriter().print(obj.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
		}
		
		else if(param.equals("getCountOfAllAlerts"))
		{
			try {
				String vehicle=req.getParameter("vehicle");
				if(vehicle==null){
					vehicle="";
				}
				obj = new JSONObject();
				jArr=obdf.getCountofDTCAlerts(systemId,clientId,userId,vehicle);
				
				if (jArr.length() > 0) {
					 obj.put("OBDDTCErrorCount", jArr);
				} else {
					 obj.put("OBDDTCErrorCount", "");
				}
				resp.getWriter().print(obj.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "OBD Dashboard", "View", userId, serverName, systemId, clientId,
				"Visited This Page/Dashboard");
			}catch (Exception e) {
				System.out.println("Error in Common Action:-getVehicleModel"
						+ e.getMessage());
			}
		}
		
		else if(param.equals("showDataInPopUp"))
		{
			try {
				String popidVal = req.getParameter("popid");
				String regNo =req.getParameter("vehiNo");
				if(regNo==null){
					regNo="";
				}
				
				//System.out.println("The pop value"+popidVal);
				obj = new JSONObject();
				jArr=obdf.getShowDataInPopUp(systemId,clientId,popidVal,userId,regNo);
				
				if (jArr.length() > 0) {
					 obj.put("listOfContents", jArr);
				} else {
					 obj.put("listOfContents", "");
				}
				resp.getWriter().print(obj.toString());
				
			}catch (Exception e) {
				System.out.println("Error in Common Action:-showDataInPopUp"
						+ e.getMessage());
			}
		}
		
		    
		    else if(param.equals("showDataInPopUpInAlertCard"))
			{
				try {
					String popidVal = req.getParameter("altpopid");
				//	System.out.println("The pop value"+popidVal);
					obj = new JSONObject();
					jArr=obdf.getShowDataInPopUpInAlert(systemId,clientId,popidVal,userId);
					
					if (jArr.length() > 0) {
						 obj.put("listOfContentsAlert", jArr);
					} else {
						 obj.put("listOfContentsAlert", "");
					}
					resp.getWriter().print(obj.toString());
					
				}catch (Exception e) {
					System.out.println("Error in Common Action:-showDataInPopUp"
							+ e.getMessage());
				}
			}else if(param.equals("getParameterConfigDetails")){
				String vehicleModel = req.getParameter("vehicleModel");
				try{
					obj = new JSONObject();
					jArr = obdf.getParameterConfigDetails(systemId,clientId,vehicleModel);
					if(jArr.length() > 0){
						obj.put("parameterConfigRootRoot", jArr);
					}else{
						obj.put("parameterConfigRootRoot", "");	
					}
					resp.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getVehicleMake")){
				try{
					obj = new JSONObject();
					jArr = obdf.getVehicleMake(systemId,clientId);
					if(jArr.length() > 0){
						obj.put("vehicleMakeStoreRoot", jArr);
					}else{
						obj.put("vehicleMakeStoreRoot", "");
					}
					resp.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getVehicleModel")){
				String vehicleMake = req.getParameter("vehicleMake");
				try{
					obj = new JSONObject();
					jArr = obdf.getVehicleModel(systemId,clientId,vehicleMake);
					if(jArr.length() > 0){
						obj.put("modelComboStoreRoot", jArr);
					}else{
						obj.put("modelComboStoreRoot", "");
					}
					resp.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getLimitType")){
				try{
					obj = new JSONObject();
					jArr = obdf.getLimitType();
					if(jArr.length() > 0){
						obj.put("limitTypeCombostoreRoot", jArr);
					}else{
						obj.put("limitTypeCombostoreRoot", "");
					}
					resp.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("saveParameterSetting")){
				String json = req.getParameter("json");
				String vehicleModel = req.getParameter("vehicleModel");
				String message = "";
				try{
					message = obdf.saveParameterSetting(systemId,clientId,json,vehicleModel,userId);
					resp.getWriter().println(message.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getErrorReportDetails")){
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				String jpName = req.getParameter("jspName");
				ArrayList<Object> list = new ArrayList<Object>();
				try{
					obj = new JSONObject();
					if(startDate != null && !startDate.equals("")){
						list = obdf.getErrorCodeReportDetails(systemId,clientId,startDate,endDate,offmin,userId);
						if(list.size() > 0){
							jArr = (JSONArray) list.get(0);
							obj.put("errorCodeReportRoot", jArr);
							
							ReportHelper reportHeper = (ReportHelper) list.get(1);
							req.getSession().setAttribute(jpName, reportHeper);
							req.getSession().setAttribute("startDate", startDate.replace("T", " "));
							req.getSession().setAttribute("endDate", endDate.replace("T", " "));
						}else{
							obj.put("errorCodeReportRoot", "");
						}
					}else{
						obj.put("errorCodeReportRoot", "");
					}
					resp.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("addRemarks")){
				String UID = req.getParameter("UID");
				String remarks = req.getParameter("remarks");
				String message = "";
				try{
					message = obdf.saveRemarks(systemId,clientId,remarks,UID);
					resp.getWriter().println(message.toString()); 
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getVehicleUser")){
				try{
					obj = new JSONObject();
					jArr = obdf.getVehicleUser(systemId,clientId,userId);
					resp.getWriter().println(jArr);
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getErrorCodeDetailsForDiagnostic")){
				String vehicleNo = req.getParameter("vehicleNo");			
				try{
					obj = new JSONObject();
					jArr = obdf.getErrorCodeDetails(systemId,clientId,vehicleNo);
					if(jArr.length() > 0){
						obj.put("errorCodeDetailsRoot", jArr);
					}else{
						obj.put("errorCodeDetailsRoot", "");
					}
					resp.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getIgnitionStatus")){
				String ignitionStatus = "";
				String vehicleNo = req.getParameter("vehicleNo");			
				try{
					obj = new JSONObject();
					ignitionStatus = obdf.getIgnitionStatus(systemId,clientId,vehicleNo);
					resp.getWriter().println(ignitionStatus.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("getIgnitionStatus1")){
				String ignitionStatus1 = "";
				String vehicleNo = req.getParameter("vehicleNo");			
				try{
					obj = new JSONObject();
					ignitionStatus1 = obdf.getIgnitionStatus1(systemId,clientId,vehicleNo,offset);
					resp.getWriter().println(ignitionStatus1.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else  if (param.equals("getGroups")) {
	            try {
	                String customerid = req.getParameter("CustId");
	                jArr = new JSONArray();
	 	            obj = new JSONObject();
	            if (customerid != null && !customerid.equals("")) {
	            	 clientId = Integer.parseInt(customerid);
	            	 jArr = obdf.getGroupNameList(systemId, clientId, userId);
	                if (jArr != null) {
	                	obj.put("groupNameList", jArr);
	                } else {
	                	obj.put("groupNameList", "");
	                }
	                resp.getWriter().print(obj.toString());
	            }else {
	            	obj.put("groupNameList", "");
				}
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        } else  if (param.equals("getDetailsofOBDVehicle")){
	        	ArrayList<Object> list = new ArrayList<Object>();
	        	String CustId = req.getParameter("CustId");	
	        	String RegNo = req.getParameter("RegNo");	
	        	String StartDate = req.getParameter("StartDate");	
	        	String EndDate = req.getParameter("EndDate");	
	        	String jspName = req.getParameter("jspName");
	        	StartDate = StartDate.replaceAll("T", " ");
	        	EndDate = EndDate.replaceAll("T", " ");
				try {
				
					obj = new JSONObject();
					list =obdf.getDetailsofOBDVehicle(systemId,clientId,userId,RegNo,StartDate,EndDate,offmin);
					jArr = (JSONArray) list.get(0);
	                if (jArr.length() > 0) {
	                	obj.put("OBDExportReportDetailsRoot", jArr);
	                } else {
	                	obj.put("OBDExportReportDetailsRoot", "");
	                }
		            ReportHelper reportHelper = (ReportHelper) list.get(1);
					req.getSession().setAttribute(jspName, reportHelper);					
					req.getSession().setAttribute("custName", CustId);
					req.getSession().setAttribute("startDate", StartDate);
					req.getSession().setAttribute("endDate", EndDate);
					req.getSession().setAttribute("vehicleNo", RegNo);
					resp.getWriter().print(obj.toString());
						
					
				}catch (Exception e) {
					System.out.println("Error in OBD Action:-getDetailsofOBDVehicle"
							+ e.getMessage());
				}
			
	        }		
	        else  if (param.equals("getIndexesofOBDVehicle")){
                ArrayList<Object> list = new ArrayList<Object>();
                String CustId = req.getParameter("CustId");    
                String VehicleNo = req.getParameter("RegNo");    
                String jspName = req.getParameter("jspName");
                try {
                
                    obj = new JSONObject();
                    list =obdf.getIndexesofOBDVehicle(systemId,clientId,userId,VehicleNo);
                    jArr = (JSONArray) list.get(0);
                    if (jArr.length() > 0) {
                        obj.put("StroreIndexList", jArr);
                    } else {
                        obj.put("StroreIndexList", "");
                    }
                    ReportHelper reportHelper = (ReportHelper) list.get(1);
                    req.getSession().setAttribute(jspName, reportHelper);                    
                    req.getSession().setAttribute("custName", CustId);
                    resp.getWriter().print(obj.toString());                                            
                }catch (Exception e) {
                    System.out.println("Error in OBD Action:-getIndexesofOBDVehicle"
                            + e.getMessage());
                }
            
            }
	        else  if (param.equals("getOBDExcel")){
	        	ArrayList<Object> list = new ArrayList<Object>();
	        	String CustId = req.getParameter("CustId");	
	        	String RegNo = req.getParameter("RegNo");	
	        	String StartDate = req.getParameter("StartDate");		        	
	        	String EndDate = req.getParameter("EndDate");	
	        	String jspName = req.getParameter("jspName");
	        	StartDate = StartDate.replaceAll("T", " ");
	        	EndDate = EndDate.replaceAll("T", " ");
				try {
				
					String path = "";
				    path =obdf.getOBDExcel(systemId,clientId,userId,RegNo,StartDate,EndDate,offmin);				
					resp.getWriter().print(path);
					
				}catch (Exception e) {
					e.printStackTrace();
					System.out.println("Error in OBD Action:-getDetailsofOBDVehicle"
							+ e.getMessage());
				}
			
	        }  else  if (param.equals("getOBDExcelNew")){
	        	ArrayList<Object> list = new ArrayList<Object>();
	        	String CustId = req.getParameter("CustId");	
	        	String RegNo = req.getParameter("RegNo");	
	        	String StartDate = req.getParameter("StartDate");		        	
	        	String EndDate = req.getParameter("EndDate");	
	        	String jspName = req.getParameter("jspName");
	        	StartDate = StartDate.replaceAll("T", " ");
	        	EndDate = EndDate.replaceAll("T", " ");
				try {
				
					String path = "";
				    path =obdf.getOBDExcelNew(systemId,clientId,userId,RegNo,StartDate,EndDate,offmin);				
					resp.getWriter().print(path);
					
				}catch (Exception e) {
					e.printStackTrace();
					System.out.println("Error in OBD Action:-getDetailsofOBDVehicle"
							+ e.getMessage());
				}
			
	        }
	        else if(param.equals("getVehicleDiagnosticDeatails2x2")){
	        	String vehicleNo = req.getParameter("vehicleNo");			
				try{
					obj = new JSONObject();
					jArr = obdf.getVehicleDiagnosticDeatails2x2(systemId,clientId,vehicleNo);
					if(jArr.length() > 0){
						obj.put("vehicleDiagnosisDetailsRoot2x2", jArr);
					}else{
						obj.put("vehicleDiagnosisDetailsRoot2x2", "");
					}
					resp.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
	        }
		
		return null;
	}
}	
