package t4u.passengerbustransportation;

import java.text.DecimalFormat;
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


public class TerminalRouteMasterAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		String param = "";
		String message = "";		
		HttpSession session = request.getSession();
		DecimalFormat df = new DecimalFormat("##.##");
		PassengerBusTransportationFunctions routeMaster = new PassengerBusTransportationFunctions();
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

		if (param.equals("getTerminalName")) {
			try {
				String CustId = request.getParameter("CustId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustId != null && !CustId.equals("")) {
					jsonArray = routeMaster.getTerminalName(systemId,Integer.parseInt(CustId));
					if (jsonArray.length() > 0) {
						jsonObject.put("getTerminalName", jsonArray);
					} else {
						jsonObject.put("getTerminalName", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
				else {
					jsonObject.put("getTerminalName", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
		
		if (param.equals("getTerminalRouteMasterDetails")) {
			 try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					String jspName=request.getParameter("jspName");
					String custName=request.getParameter("CustName");
					String CustId = request.getParameter("CustId");
					
					if (request.getParameter("CustId") != null && !request.getParameter("CustId").equals("")) {
					ArrayList < Object > list1= routeMaster.getTerminalRouteMasterDetails(Integer.parseInt(CustId), systemId,lang);
						jsonArray = (JSONArray) list1.get(0);
				
					if (jsonArray.length() > 0) {
						jsonObject.put("getTerminalRouteMasterDetails", jsonArray);
					} else {
						jsonObject.put("getTerminalRouteMasterDetails", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("customerId", custName);
	               	}else{
						jsonObject.put("getTerminalRouteMasterDetails", "");
					}
					response.getWriter().print(jsonObject.toString()); 

				} catch (Exception e) {
					e.printStackTrace();
				}
		}
		
		 else if (param.equalsIgnoreCase("TerminalRouteMasterDetailsAddAndModify")) {
			    try {
					        String CustID = request.getParameter("CustID");
				        	String buttonValue = request.getParameter("buttonValue");
				            String  terminalId= request.getParameter("terminalId");
				            String  terminalName= request.getParameter("terminalName");
				            String  origin= request.getParameter("origin");
				            String  destination= request.getParameter("destination");
				            String  routeName= request.getParameter("routeName");
				            String  kms= request.getParameter("kms");
				            
				            String  duration1= request.getParameter("duration");
				            String duration2= duration1.replace(':', '.'); 
				            float dur1=Float.parseFloat(duration2);
				            String duration=df.format(dur1);
				           
				            
				            String  status= request.getParameter("status");
				            String  id= request.getParameter("id");
				            
				           
				            message="";
				            if (buttonValue.equals("Add") && CustID != null && !CustID.equals("")) {
				                message = routeMaster.insertTerminalRouteMasterDetails(Integer.parseInt(terminalId),terminalName,origin,destination,routeName,Float.parseFloat(kms),Float.parseFloat(duration),status,systemId,Integer.parseInt(CustID),userId);
				            } else if (buttonValue.equals("Modify") && CustID != null && !CustID.equals("")) {
				            	 message = routeMaster.modifyTerminalRouteMasterDetails(Integer.parseInt(id),Integer.parseInt(terminalId),terminalName,origin,destination,routeName,Float.parseFloat(kms),Float.parseFloat(duration),status,systemId,Integer.parseInt(CustID),userId);
				            }
				            response.getWriter().print(message);
				        } catch (Exception e) {
				            e.printStackTrace();
				        }
				    }
		return null;
	}
}
