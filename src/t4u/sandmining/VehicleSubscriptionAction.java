package t4u.sandmining;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;


import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
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
import t4u.functions.LTSP_Subscription_Payment_Function;
import t4u.functions.SandMiningFunctions;
import t4u.functions.SandMiningPermitFunctions;

public class VehicleSubscriptionAction extends Action {
public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        //HttpSession session = request.getSession();
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        SandMiningFunctions sandfunc = new SandMiningFunctions();
        SandMiningPermitFunctions sandpermitfunc=new SandMiningPermitFunctions();
        systemId = loginInfo.getSystemId();
        //String lang = loginInfo.getLanguage();
        int clientId=loginInfo.getCustomerId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        zone = loginInfo.getZone();
        
        CommonFunctions cf = new CommonFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        LTSP_Subscription_Payment_Function LTSPFunction = new LTSP_Subscription_Payment_Function();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        if(param.equals("getVehicleNo")){
			try{
				String customerId=request.getParameter("CustId");
				jsonObject =new JSONObject();
				jsonArray = LTSPFunction.getVehicleNo(systemId,Integer.parseInt(customerId),userId,offset);
				jsonObject.put("vehiclestoreList", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
        else if(param.equals("getSubscriptionDetails")){
			try{
				String customerId=request.getParameter("CustId");
				String sysId=request.getParameter("pagesystemId");
				if(clientId == 9999 && !sysId.trim().equalsIgnoreCase("")){					
					systemId= Integer.parseInt(sysId);
				}
				jsonObject =new JSONObject();
				jsonArray = LTSPFunction.getLTSPSubscriptionDetails(systemId,Integer.parseInt(customerId),userId);
				jsonObject.put("subscriptionList", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
  else if (param.equals("addModifyVehicleSubscriptionDetails"))
		{
			try{
				 String buttonValue = request.getParameter("buttonValue"); 
		         String custId =request.getParameter("custId");
		         String vehicleNo = request.getParameter("vehicleNo");
		         String startDate=request.getParameter("startDate").replace("T", " ");
	             String endDate=request.getParameter("endDate").replace("T", " ");
	             String remainderDate=request.getParameter("remainderDate").replace("T", " ");
	             String modeOfPayment=request.getParameter("modeOfPayment");
	             String ddNo=request.getParameter("ddNo");
	             String ddDate=request.getParameter("ddDate").replace("T", " ");
	             String bankName=request.getParameter("bankName");
	             String totalAmount = request.getParameter("totalAmount");   
	             String subscription = request.getParameter("subscription"); 
	             String id = request.getParameter("id");
	             String billing = request.getParameter("billing");
	             String message = "";
	             if(clientId == 9999){
						String sysId=request.getParameter("pagesystemId");
						systemId= Integer.parseInt(sysId);
					}
	             if(buttonValue.equals("Add") && custId != null && !custId.equals("")){
	            	 message = LTSPFunction.addVehicleSubscriptionDetails(systemId, Integer.parseInt(custId),userId, vehicleNo, startDate, endDate, remainderDate, modeOfPayment, ddNo, ddDate, bankName, Integer.parseInt(totalAmount), Integer.parseInt(subscription));	         
	             }else{
	            	 message = LTSPFunction.modifyVehicleSubscriptionDetails(systemId, Integer.parseInt(custId),userId, vehicleNo, startDate, endDate, remainderDate, modeOfPayment, ddNo, ddDate, bankName, Integer.parseInt(totalAmount), Integer.parseInt(subscription),Integer.parseInt(id),billing);
	             }
	             response.getWriter().print(message);
			} catch (Exception e) {
	         	 e.printStackTrace();
	          }
	  }
        else if (param.equals("getVehicleSubscriptionDetails"))
		{
		try{
		jsonArray = new JSONArray();
        jsonObject = new JSONObject();
        String jspName=null;
        String custId=request.getParameter("CustId");
        String custName=request.getParameter("custName");
        String sysId=request.getParameter("pagesystemId");
        if(clientId == 9999 && sysId != null && !sysId.trim().equalsIgnoreCase("")){			
			systemId= Integer.parseInt(sysId);
		}
		  if(request.getParameter("jspname")!=null)
		     jspName=request.getParameter("jspname");
		     else
		     jspName=""; 
		     ArrayList<Object> list1 = LTSPFunction.getVehicleSubscriptionDetails(systemId,Integer.parseInt(custId));
		     jsonArray = (JSONArray) list1.get(0);
		 	if (jsonArray.length() > 0) {
		 	jsonObject.put("vehicleSubscriptiontroot", jsonArray);
		 	}
		 	else
		 	{
		 	jsonObject.put("vehicleSubscriptiontroot", "");
		 	}	
		 	ReportHelper reportHelper = (ReportHelper) list1.get(1);
		 	request.getSession().setAttribute(jspName, reportHelper);
		 	request.getSession().setAttribute("custId", custName);
		 	response.getWriter().print(jsonObject.toString());
		 	
		     } catch (Exception e) {
		     	 e.printStackTrace();
		      }
}else if (param.equals("getMonthDetails")){
			 try{
					String subscription=request.getParameter("subscription");
					jsonObject =new JSONObject();
					jsonArray = new JSONArray();
					JSONObject jsonObject1 = new JSONObject();
					JSONObject jsonObject2 = new JSONObject();
					JSONObject jsonObject3 = new JSONObject();
					JSONObject jsonObject4 = new JSONObject();
					JSONObject jsonObject5 = new JSONObject();
					JSONObject jsonObject6 = new JSONObject();
					JSONObject jsonObject7 = new JSONObject();
					JSONObject jsonObject8 = new JSONObject();
					JSONObject jsonObject9 = new JSONObject();
					JSONObject jsonObject10 = new JSONObject();
					JSONObject jsonObject11 = new JSONObject();
					JSONObject jsonObject12 = new JSONObject();
					if(Integer.parseInt(subscription) == 12){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
						jsonObject3.put("durationMonths", "3");
						jsonArray.put(jsonObject3);
						jsonObject4.put("durationMonths", "4");
						jsonArray.put(jsonObject4);
						jsonObject5.put("durationMonths", "5");
						jsonArray.put(jsonObject5);
						jsonObject6.put("durationMonths", "6");
						jsonArray.put(jsonObject6);
						jsonObject7.put("durationMonths", "7");
						jsonArray.put(jsonObject7);
						jsonObject8.put("durationMonths", "8");
						jsonArray.put(jsonObject8);
						jsonObject9.put("durationMonths", "9");
						jsonArray.put(jsonObject9);
						jsonObject10.put("durationMonths", "10");
						jsonArray.put(jsonObject10);
						jsonObject11.put("durationMonths", "11");
						jsonArray.put(jsonObject11);
						jsonObject12.put("durationMonths", "12");
						jsonArray.put(jsonObject12);
					}else if(Integer.parseInt(subscription) == 11){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
						jsonObject3.put("durationMonths", "3");
						jsonArray.put(jsonObject3);
						jsonObject4.put("durationMonths", "4");
						jsonArray.put(jsonObject4);
						jsonObject5.put("durationMonths", "5");
						jsonArray.put(jsonObject5);
						jsonObject6.put("durationMonths", "6");
						jsonArray.put(jsonObject6);
						jsonObject7.put("durationMonths", "7");
						jsonArray.put(jsonObject7);
						jsonObject8.put("durationMonths", "8");
						jsonArray.put(jsonObject8);
						jsonObject9.put("durationMonths", "9");
						jsonArray.put(jsonObject9);
						jsonObject10.put("durationMonths", "10");
						jsonArray.put(jsonObject10);
						jsonObject11.put("durationMonths", "11");
						jsonArray.put(jsonObject11);
					
					}else if(Integer.parseInt(subscription) == 10){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
						jsonObject3.put("durationMonths", "3");
						jsonArray.put(jsonObject3);
						jsonObject4.put("durationMonths", "4");
						jsonArray.put(jsonObject4);
						jsonObject5.put("durationMonths", "5");
						jsonArray.put(jsonObject5);
						jsonObject6.put("durationMonths", "6");
						jsonArray.put(jsonObject6);
						jsonObject7.put("durationMonths", "7");
						jsonArray.put(jsonObject7);
						jsonObject8.put("durationMonths", "8");
						jsonArray.put(jsonObject8);
						jsonObject9.put("durationMonths", "9");
						jsonArray.put(jsonObject9);
						jsonObject10.put("durationMonths", "10");
						jsonArray.put(jsonObject10);
					}else if(Integer.parseInt(subscription) ==9){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
						jsonObject3.put("durationMonths", "3");
						jsonArray.put(jsonObject3);
						jsonObject4.put("durationMonths", "4");
						jsonArray.put(jsonObject4);
						jsonObject5.put("durationMonths", "5");
						jsonArray.put(jsonObject5);
						jsonObject6.put("durationMonths", "6");
						jsonArray.put(jsonObject6);
						jsonObject7.put("durationMonths", "7");
						jsonArray.put(jsonObject7);
						jsonObject8.put("durationMonths", "8");
						jsonArray.put(jsonObject8);
						jsonObject9.put("durationMonths", "9");
						jsonArray.put(jsonObject9);
					}else if(Integer.parseInt(subscription) == 8){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
						jsonObject3.put("durationMonths", "3");
						jsonArray.put(jsonObject3);
						jsonObject4.put("durationMonths", "4");
						jsonArray.put(jsonObject4);
						jsonObject5.put("durationMonths", "5");
						jsonArray.put(jsonObject5);
						jsonObject6.put("durationMonths", "6");
						jsonArray.put(jsonObject6);
						jsonObject7.put("durationMonths", "7");
						jsonArray.put(jsonObject7);
						jsonObject8.put("durationMonths", "8");
						jsonArray.put(jsonObject8);
					}else if(Integer.parseInt(subscription) == 7){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
						jsonObject3.put("durationMonths", "3");
						jsonArray.put(jsonObject3);
						jsonObject4.put("durationMonths", "4");
						jsonArray.put(jsonObject4);
						jsonObject5.put("durationMonths", "5");
						jsonArray.put(jsonObject5);
						jsonObject6.put("durationMonths", "6");
						jsonArray.put(jsonObject6);
						jsonObject7.put("durationMonths", "7");
						jsonArray.put(jsonObject7);
					}else if(Integer.parseInt(subscription) == 6){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
						jsonObject3.put("durationMonths", "3");
						jsonArray.put(jsonObject3);
						jsonObject4.put("durationMonths", "4");
						jsonArray.put(jsonObject4);
						jsonObject5.put("durationMonths", "5");
						jsonArray.put(jsonObject5);
						jsonObject6.put("durationMonths", "6");
						jsonArray.put(jsonObject6);
					}else if(Integer.parseInt(subscription) == 5){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
						jsonObject3.put("durationMonths", "3");
						jsonArray.put(jsonObject3);
						jsonObject4.put("durationMonths", "4");
						jsonArray.put(jsonObject4);
						jsonObject5.put("durationMonths", "5");
						jsonArray.put(jsonObject5);	
					}else if(Integer.parseInt(subscription) == 4){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
						jsonObject3.put("durationMonths", "3");
						jsonArray.put(jsonObject3);
						jsonObject4.put("durationMonths", "4");
						jsonArray.put(jsonObject4);
					}else if(Integer.parseInt(subscription) == 3){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
						jsonObject3.put("durationMonths", "3");
						jsonArray.put(jsonObject3);
					}else if(Integer.parseInt(subscription) == 2){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
						jsonObject2.put("durationMonths", "2");
						jsonArray.put(jsonObject2);
					}else if(Integer.parseInt(subscription) == 1){
						jsonObject1.put("durationMonths", "1");
						jsonArray.put(jsonObject1);
					}
					jsonObject.put("MonthStoreIdList", jsonArray);
					response.getWriter().print(jsonObject.toString());	
				}
				catch(Exception e){
					e.printStackTrace();
				}
 }else if(param.equals("renawalOfSubscription")){
			 String message="";
			 String custId=request.getParameter("CustId");
		     String endDate=request.getParameter("Enddate");
		     String startDate=request.getParameter("Startdate");
		     String vechNumber=request.getParameter("vechNumber");
		     String id=request.getParameter("id");
		     if(clientId == 9999){
					String sysId=request.getParameter("pagesystemId");
					systemId= Integer.parseInt(sysId);
				}
		     message = LTSPFunction.RenwalOfVehicleSubscriptionDetails(systemId, Integer.parseInt(custId),userId, vechNumber, startDate, endDate,id,offset);
		     response.getWriter().print(message);	
		 }
		 else if(param.equals("getSubscriptionVehicleReportDetails")){
						try {
							jsonArray = new JSONArray();
							jsonObject = new JSONObject();
							String jspName = null;
							String custId = request.getParameter("custId");
							String startdate = request.getParameter("startdate");
							String enddate = request.getParameter("enddate");
							String custName = request.getParameter("custName");
							if (request.getParameter("jspName") != null)
								jspName = request.getParameter("jspName");
							else
								jspName = "";
							ArrayList<Object> list1 = LTSPFunction.getVehicleSubscriptionReportDetails(systemId, Integer.parseInt(custId),startdate.replace('T', ' '),enddate.replace('T', ' '),offset);
							if(list1.size()>0){
							jsonArray = (JSONArray) list1.get(0);
							}
							if (jsonArray.length() > 0) {
								jsonObject.put("vehicleSubscriptiontroot", jsonArray);
							} else {
								jsonObject.put("vehicleSubscriptiontroot", "");
							}
							ReportHelper reportHelper = (ReportHelper) list1.get(1);
							request.getSession().setAttribute(jspName, reportHelper);
							request.getSession().setAttribute("startdate", startdate.replace('T', ' '));
							request.getSession().setAttribute("enddate", enddate.replace('T', ' '));
							request.getSession().setAttribute("custName",custName);
							response.getWriter().print(jsonObject.toString());
			
						} catch (Exception e) {
				     	 e.printStackTrace();
				      }
				    }else if (param.equals("getCustomer")) {
						try {
							jsonArray = new JSONArray();
							jsonObject = new JSONObject();
							String ltsp = "no";							
							String page = request.getParameter("pageName");
							if (request.getParameter("paramforltsp") != null) {
								ltsp = request.getParameter("paramforltsp").toString();
							}
							String sysId=request.getParameter("pagesystemId");
					        if(clientId == 9999 && sysId != null){		
					        	page="Admin";
								systemId = Integer.parseInt(sysId);
							}
							jsonArray = LTSPFunction.getCustomer(systemId, ltsp, clientId,page);
							if (jsonArray.length() > 0) {
								jsonObject.put("CustomerRoot", jsonArray);
							} else {
								jsonObject.put("CustomerRoot", "");
							}
							response.getWriter().print(jsonObject.toString());
						} catch (Exception e) {
							System.out.println("Error in Vehicle Subscription Action:-getCustomer "
									+ e.toString());
						}
					} 
					 else if(param.equals("getReconcelationReportDetails")){
							try {
								jsonArray = new JSONArray();
								jsonObject = new JSONObject();
								String jspName = null;
								String custId = request.getParameter("custId");
								String year = request.getParameter("year");
								String month = request.getParameter("month");
								String custName = request.getParameter("custName");
								if (request.getParameter("jspName") != null)
									jspName = request.getParameter("jspName");
								else
									jspName = "";
								ArrayList<Object> list1 = LTSPFunction.getReconcelationReportDetails(systemId, Integer.parseInt(custId),Integer.parseInt(month),Integer.parseInt(year),offset);
								if(list1.size()>0){
								jsonArray = (JSONArray) list1.get(0);
								}
								if (jsonArray.length() > 0) {
									jsonObject.put("reconciliationtroot", jsonArray);
								} else {
									jsonObject.put("reconciliationtroot", "");
								}
								ReportHelper reportHelper = null  ; 
								if(list1.size()>0){
									reportHelper= (ReportHelper) list1.get(1);
								}
								request.getSession().setAttribute(jspName, reportHelper);
								request.getSession().setAttribute("custName",custName);
								response.getWriter().print(jsonObject.toString());
				
							} catch (Exception e) {
					     	 e.printStackTrace();
					      }
					    }
					 else if(param.equals("getSubscriptionVehicleReportDetails")){
							try {
								jsonArray = new JSONArray();
								jsonObject = new JSONObject();
								String jspName = null;
								String custId = request.getParameter("custId");
								String startdate = request.getParameter("startdate");
								String enddate = request.getParameter("enddate");
								String custName = request.getParameter("custName");
								if (request.getParameter("jspName") != null)
									jspName = request.getParameter("jspName");
								else
									jspName = "";
								ArrayList<Object> list1 = LTSPFunction.getVehicleSubscriptionReportDetails(systemId, Integer.parseInt(custId),startdate.replace('T', ' '),enddate.replace('T', ' '),offset);
								if(list1.size()>0){
								jsonArray = (JSONArray) list1.get(0);
								}
								if (jsonArray.length() > 0) {
									jsonObject.put("vehicleSubscriptiontroot", jsonArray);
								} else {
									jsonObject.put("vehicleSubscriptiontroot", "");
								}
								ReportHelper reportHelper = (ReportHelper) list1.get(1);
								request.getSession().setAttribute(jspName, reportHelper);
								request.getSession().setAttribute("startdate", startdate.replace('T', ' '));
								request.getSession().setAttribute("enddate", enddate.replace('T', ' '));
								request.getSession().setAttribute("custName",custName);
								response.getWriter().print(jsonObject.toString());
				
							} catch (Exception e) {
					     	 e.printStackTrace();
					      }
					 }
  	else if (param.equals("getDeleteVehicleSubcriptionDetails")) {

			try {
                System.out.println("Inside getDeleteVehicleSubcriptionDetails");
				String startdate = request.getParameter("startdate");
				String enddate = request.getParameter("enddate");
				String vehicleNo = request.getParameter("vehicleNo");
				String str = "";
				if (vehicleNo != null && !vehicleNo.equals("")) {
			    str = LTSPFunction.getVehicleSubscriptionDelete(startdate,enddate, vehicleNo);
				}
				response.getWriter().print(str);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
        
        
        
					 else if(param.equals("getSubscriptionVehicleReport")){
							try {
								jsonArray = new JSONArray();
								jsonObject = new JSONObject();
								String jspName = null;
								String custId = request.getParameter("custId");
								String startdate = request.getParameter("startdate");
								String enddate = request.getParameter("enddate");
								String custName = request.getParameter("custName");
								if (request.getParameter("jspName") != null)
									jspName = request.getParameter("jspName");
								else
									jspName = "";
								ArrayList<Object> list1 = LTSPFunction.getVehicleSubscriptionReport(systemId, Integer.parseInt(custId),startdate.replace('T', ' '),enddate.replace('T', ' '),offset);
								if(list1.size()>0){
								jsonArray = (JSONArray) list1.get(0);
								}
								if (jsonArray.length() > 0) {
									jsonObject.put("vehicleSubscriptionReportRoot", jsonArray);
								} else {
									jsonObject.put("vehicleSubscriptionReportRoot", "");
								}
								ReportHelper reportHelper = (ReportHelper) list1.get(1);
								request.getSession().setAttribute(jspName, reportHelper);
								request.getSession().setAttribute("startdate", startdate.replace('T', ' '));
								request.getSession().setAttribute("enddate", enddate.replace('T', ' '));
								request.getSession().setAttribute("custName",custName);
								response.getWriter().print(jsonObject.toString());
								System.out.println("jsonArray " + jsonArray);
							} catch (Exception e) {
					     	 e.printStackTrace();
					      }
					    }
        				
        
        
        return null;
    }
	
}

