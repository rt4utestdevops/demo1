package t4u.passengerbustransportation;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.util.LabelValueBean;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;

import t4u.functions.CommonFunctions;
import t4u.functions.PassengerBusTransportationFunctions;

public class TerminalMasterAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		String param = "";
		String message = "";		
		HttpSession session = request.getSession();
		PassengerBusTransportationFunctions tmf = new PassengerBusTransportationFunctions();
		LoginInfoBean  logininfo=(LoginInfoBean)session.getAttribute("loginInfoDetails"); 
		CommonFunctions cfuncs = new CommonFunctions();
		int systemId = logininfo.getSystemId();
		int userId = logininfo.getUserId();
		String lang = logininfo.getLanguage();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		 if (param.equals("getTerminaMasterDetails")) {

			 try {

					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					
					String jspName=request.getParameter("jspName");
					String custName=request.getParameter("custname");
					String customerId = request.getParameter("CustId");
					
					if (request.getParameter("CustId") != null && !request.getParameter("CustId").equals("")) {
				
					ArrayList < Object > list1= tmf.getTerminalMasterDetails(Integer.parseInt(customerId), systemId,lang);
						jsonArray = (JSONArray) list1.get(0);
				
					if (jsonArray.length() > 0) {
						jsonObject.put("terminalMasterDetails", jsonArray);
					} else {
						jsonObject.put("terminalMasterDetails", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("customerId", custName);
	               	}else
					{
						jsonObject.put("terminalMasterDetails", "");
					}
					response.getWriter().print(jsonObject.toString()); 

				} catch (Exception e) {
					e.printStackTrace();
					System.out
							.println("Error in TerminalMasterAction"
									+ e);
				}

			
			 
	}

		 else if (param.equalsIgnoreCase("TerminalDetailsAddAndModify")) {
		     

			 try {
		        	String custId = request.getParameter("CustId");
		        	String buttonValue = request.getParameter("buttonValue");
		            String terminalName = request.getParameter("terminalName");
		            String terminalId = request.getParameter("terminalId");
		            String id= request.getParameter("id");
		            String location = request.getParameter("location");
		            String status = request.getParameter("status");
		            String gridStatus=request.getParameter("gridStatus");
		            message="";
		            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
		                message = tmf.insertTerminalMasterDetails(Integer.parseInt(custId),terminalId,terminalName,location,status,systemId,userId);
		            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
		            	 message = tmf.modifyTerminalMasterDetails(Integer.parseInt(custId),terminalId,Integer.parseInt(id),terminalName,location,status,systemId,userId,gridStatus);
		            }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
			 
	
		 
		 return null;
	}
}
