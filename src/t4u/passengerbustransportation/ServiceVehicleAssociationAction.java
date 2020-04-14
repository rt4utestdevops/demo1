package t4u.passengerbustransportation;

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
import t4u.functions.PassengerBusTransportationFunctions;

public class ServiceVehicleAssociationAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		String param = "";
		String message = "";
		int customersId = 0;
		int userId = 0;
		int systemId = 0;
		HttpSession session = request.getSession();
		PassengerBusTransportationFunctions transportationFunctions = new PassengerBusTransportationFunctions();
		LoginInfoBean  logininfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		systemId = logininfo.getSystemId();
		userId = logininfo.getUserId();
		customersId = logininfo.getCustomerId();
		String lang = logininfo.getLanguage();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getServiceVehicleAssociationList")) {
			try {				
				String jspName = request.getParameter("jspName");
				customersId = Integer.parseInt(request.getParameter("custId"));
				CommonFunctions cf = new  CommonFunctions();
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList < Object > list = transportationFunctions.getServiceVehicleAssociationList(systemId,customersId,lang);
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("serviceVehicleAssociation", jsonArray);
				} else {
					jsonObject.put("serviceVehicleAssociation", "");
				}
				 ReportHelper reportHelper = (ReportHelper) list.get(1);
				 request.getSession().setAttribute(jspName, reportHelper);
                 request.getSession().setAttribute("custId", cf.getCustomerName(String.valueOf(customersId), systemId));
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		if (param.equalsIgnoreCase("getVehicleRegList")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				customersId = Integer.parseInt(request.getParameter("custId"));
				String date=request.getParameter("date");
				date = date.replace('T', ' ');
				jsonArray = transportationFunctions.getVehicleRegistrationList(customersId,userId,systemId,date);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleRegNumber", jsonArray);
				} else {
					jsonObject.put("vehicleRegNumber", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equalsIgnoreCase("getTerminalNameList")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				customersId = Integer.parseInt(request.getParameter("custId"));
				jsonArray = transportationFunctions.getTerminalName(systemId,customersId);
				if (jsonArray.length() > 0) {
					jsonObject.put("terminalName", jsonArray);
				} else {
					jsonObject.put("terminalName", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		if (param.equalsIgnoreCase("getServiceNameList")) {
			try {
				String terminalId = request.getParameter("terminalId");
				customersId = Integer.parseInt(request.getParameter("custId"));
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = transportationFunctions.getServiceNameList(terminalId,systemId,customersId);
				if (jsonArray.length() > 0) {
					jsonObject.put("serviceName", jsonArray);
				} else {
					jsonObject.put("serviceName", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equalsIgnoreCase("addOrModifyServiceVehicleAssocList")) {
			 try {
				    String checkValue = request.getParameter("check");
		        	String buttonValue = request.getParameter("buttonValue");
		        	String regNo = request.getParameter("vehicleNo");
		        	String serviceId = request.getParameter("serviceId");
		        	String date = request.getParameter("date");
		        	date = date.replace('T', ' ');
		        	customersId = Integer.parseInt(request.getParameter("custId"));
		        	String status = request.getParameter("status");
		        	int Id = Integer.parseInt(request.getParameter("Id"));
		            message="";
		            if (buttonValue.equals("Add")) {
		            	message = transportationFunctions.insertServiceVehicleAssoc(checkValue,regNo,Integer.parseInt(serviceId),date,systemId,customersId,userId,status);
		            } else if (buttonValue.equals("modify")) {
		            	message = transportationFunctions.modifyServiceVehicleAssoc(regNo,Integer.parseInt(serviceId),systemId,customersId,userId,Id,status,date);
		            }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
		if (param.equalsIgnoreCase("addVehicle")) {
			 try {
				 	float insurance=0.0f;
				 	float driverExpense=0.0f;
				 	float workerFee=0.0f;
				 	float misfee=0.0f;
				 	float dispatchFee=0.0f;
				 	float tax=0.0f;
				 	float total=0.0f;
		        	String regNo = request.getParameter("vehicleNo");
		        	customersId = Integer.parseInt(request.getParameter("custId"));
		        	int Id = Integer.parseInt(request.getParameter("Id"));
		        	if(request.getParameter("driverExpense")!=null && !request.getParameter("driverExpense").equals("")){
                	driverExpense=Float.parseFloat(request.getParameter("driverExpense"));
		        	}
		        	if(request.getParameter("workerFee")!=null && !request.getParameter("workerFee").equals("")){
		        	workerFee=Float.parseFloat(request.getParameter("workerFee"));
		        	}
		        	if(request.getParameter("misfee")!=null && !request.getParameter("misfee").equals("")){
		        	misfee=Float.parseFloat(request.getParameter("misfee"));
		        	}
		        	if(request.getParameter("dispatchFee")!=null && !request.getParameter("dispatchFee").equals("")){
		        	dispatchFee=Float.parseFloat(request.getParameter("dispatchFee"));
		        	}
		        	if(request.getParameter("insurance")!=null && !request.getParameter("insurance").equals("")){
		        	insurance=Float.parseFloat(request.getParameter("insurance"));
		        	}
		        	if(request.getParameter("tax")!=null && !request.getParameter("tax").equals("")){
		        	tax=Float.parseFloat(request.getParameter("tax"));
		        	}
		        	if(request.getParameter("total")!=null && !request.getParameter("total").equals("")){
			        total=Float.parseFloat(request.getParameter("total"));
			        }
		        	String vehicleGrid=request.getParameter("vehicleGrid");
		        	String addFlag=request.getParameter("addFlag");
		        	String date = request.getParameter("date");
		        	date = date.replace('T', ' ');
		        	int serviceId=Integer.parseInt(request.getParameter("serviceId"));

		            message="";
	            	message = transportationFunctions.addVehicle(regNo,date,systemId,customersId,Id,driverExpense,workerFee,misfee,dispatchFee,insurance,tax,total,vehicleGrid,addFlag,serviceId);

		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
		if (param.equalsIgnoreCase("getStoreBasedOnServiceId")) {
			try {
				String serviceId = request.getParameter("serviceId");
				customersId = Integer.parseInt(request.getParameter("custId"));
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = transportationFunctions.getStoreBasedOnServiceId(Integer.parseInt(serviceId),systemId,customersId);
				if (jsonArray.length() > 0) {
					jsonObject.put("storeBasedOnServiceId", jsonArray);
				} else {
					jsonObject.put("storeBasedOnServiceId", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}		return null;
	}
}
