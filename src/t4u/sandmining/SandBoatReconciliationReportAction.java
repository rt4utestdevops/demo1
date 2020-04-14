package t4u.sandmining;

import java.text.SimpleDateFormat;
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
import t4u.functions.CashVanManagementFunctions;
import t4u.functions.CreateTripFunction;
import t4u.functions.SandMiningFunctions;

public class SandBoatReconciliationReportAction extends Action  {
	
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
    	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        systemId = loginInfo.getSystemId();
        int custId1= loginInfo.getCustomerId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        zone = loginInfo.getZone();
        CashVanManagementFunctions cvmf=new CashVanManagementFunctions();
        CreateTripFunction creatTripFunc = new CreateTripFunction();
        SandMiningFunctions smfunc = new SandMiningFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        if(param.equals("getCustomer")){
			try {
				String clientIdSelected=request.getParameter("CustId");
				jsonObject = new JSONObject();
				if (clientIdSelected != null && !clientIdSelected.equals("")) {
					jsonArray = creatTripFunc.getCustomer(Integer.parseInt(clientIdSelected), systemId);
					jsonObject.put("customerRoot", jsonArray);
				} else {
					jsonObject.put("customerRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
    	else if (param.equals("getTPownerName")) {
			try {
				
				String clientId = request.getParameter("CustId");
				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = smfunc.getTPownerName(systemId,Integer.parseInt(clientId));
					jsonObject.put("TPowners", jsonArray);
				}
				else{
					jsonObject.put("TPowners", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}
        
    	else if (param.equals("getSandBoatReconciliationReport")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String tpId = request.getParameter("tpId");
	            String startDate = request.getParameter("startdate");
	            String endDate = request.getParameter("enddate")+" "+ "23:59:59";
	            String tpName = request.getParameter("tpName");
	            
	            
	            jsonObject = new JSONObject();
	            jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	            	startDate = startDate.replaceAll("T", " ");
	            	endDate = endDate.replaceAll("T", " ");
	                ArrayList < Object > list1 = smfunc.getSandBoatReconciliationReport(systemId, Integer.parseInt(customerId),startDate,endDate,offset , Integer.parseInt(tpId) ,tpName);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("ticketDetailsRoot",jsonArray);
	                } else {
	                    jsonObject.put("ticketDetailsRoot", "");
	                }
	               // reportHelper = (ReportHelper) list1.get(1);
//	             	request.getSession().setAttribute(jspName, reportHelper);
//	             	request.getSession().setAttribute("customerId", custName);
	             	response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("ticketDetailsRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
        
		return null;

	}
	}
