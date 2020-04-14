package t4u.admin;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.formula.functions.Offset;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.AdminFunctions;

public class CustomerMasterReportAction extends Action{
	

	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String param = "";
	    HttpSession session = request.getSession();
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    AdminFunctions CustomerMasterReport = new AdminFunctions();
	    int offset=0;
	    int systemId = loginInfo.getSystemId();
	    String lang = loginInfo.getLanguage();
	    int userId = loginInfo.getUserId();
	    offset=loginInfo.getOffsetMinutes();
	    CommonFunctions cf = new CommonFunctions();
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();

	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
	    
	    
	    
 //************************************************************************************************************//
	    if (param.equals("getRegion")) {
	        try {
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            jsonArray = CustomerMasterReport.getRegion(systemId);
	            if (jsonArray.length() > 0) {
	                jsonObject.put("regionRoot", jsonArray);
	            } else {
	                jsonObject.put("regionRoot", "");
	            }
	            response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } 
	    
	    

 //**************************************************Customer Master  Report **********************************************************************************************************//	    
	    
	    else if (param.equalsIgnoreCase("getCustomerMasterReport")) {
	        try {
	            String jspName= request.getParameter("JspName");
	            String RegionId=request.getParameter("regionid");
	            String RegionName = request.getParameter("regionName");
	            int regionid=Integer.parseInt(RegionId);
	            jsonArray = new JSONArray();
	            if (RegionId != null && !RegionId.equals("")) {
	                ArrayList < Object > list1 = CustomerMasterReport.getCustomerMasterReport( systemId ,lang,regionid );
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("customerMasterReport", jsonArray); 
	                } else {
	                    jsonObject.put("customerMasterReport", "");
	                }
	                
	             ReportHelper reportHelper = (ReportHelper) list1.get(1);  
		          request.getSession().setAttribute(jspName, reportHelper);
		           request.getSession().setAttribute("RegionId",  RegionName);
	                response.getWriter().print(jsonObject.toString());
	            }
	            else {
	                jsonObject.put("customerMasterReport", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	 }
	  
//***********************************************************************************************************************//	
//------------------------------------------------Modify-----------------------------------------------------------------//
	    
	    else if (param.equalsIgnoreCase("CustomerMasterModify")) {
	        try {
	             String regionId = request.getParameter("regionId");
	            String buttonValue = request.getParameter("buttonValue");
	            String place = request.getParameter("place");
	            String verticalStream="";
	            verticalStream = request.getParameter("verticalStream");
	            
	            String pendingPotentialReason="";
	            if(request.getParameter("pendingPotential").equals("")|| request.getParameter("pendingPotential")==null)
	            {
	              pendingPotentialReason = "";
	            }else
	            {
	            	pendingPotentialReason = request.getParameter("pendingPotential");
	            }
	            
	            String lastCallDate ="";
	            if(request.getParameter("lastCallDate").equals("")|| request.getParameter("lastCallDate")==null)
	            {
	            	lastCallDate = "";
	            }else
	            {
	            	lastCallDate = request.getParameter("lastCallDate");
	            }
	            
	            
	            String lastCall ="";
	            if(request.getParameter("lastCall").equals("")|| request.getParameter("lastCall")==null)
	            {
	            	lastCall = "";
	            }else
	            {
	            	lastCall = request.getParameter("lastCall");
	            }
	            
	            String issueDate="";
	            if(request.getParameter("issueDate").equals("")|| request.getParameter("issueDate")==null)
	            {
	            	issueDate = "";
	            }else
	            {
	            	issueDate = request.getParameter("issueDate");
	            }
	            
	            String contactPerson="";
	            if(request.getParameter("contactPerson").equals("")|| request.getParameter("contactPerson")==null)
	            {
	            	contactPerson = "";
	            }else
	            {
	            	contactPerson = request.getParameter("contactPerson");
	            }
	            
	            String contactNumber="";
	            if(request.getParameter("contactNumber").equals("")|| request.getParameter("contactNumber")==null)
	            {
	            	contactNumber = "";
	            }else
	            {
	            	contactNumber = request.getParameter("contactNumber");
	            }
	            
	            String ltspName= request.getParameter("ltspName");
	            String custName = request.getParameter("custName");
	            String businessVertical = request.getParameter("businessVertical");
	            String noOfVehicles = request.getParameter("noOfVehicles");
	            String acqDate = request.getParameter("acqDate");
	            String systemIdFromJsp= request.getParameter("systemId1");
	            String custId= request.getParameter("custId");
	            String verticalId = request.getParameter("verticalId");
	            
	            String morePotential="";
	            if(request.getParameter("morePotential").equals("")|| request.getParameter("morePotential")==null)
	            {
	            	morePotential = "";
	            }else
	            {
	            	morePotential = request.getParameter("morePotential");
	            }
	            
	            String IdFromCustomerMaster = request.getParameter("IdFromCustomerMaster");
	            String message="";
	            if (buttonValue.equals("Modify") && regionId != null && !regionId.equals("")) {
	                message = CustomerMasterReport.modifyCustomerInformation(Integer.parseInt(regionId),place,verticalStream,pendingPotentialReason,lastCallDate,lastCall,issueDate,contactPerson,contactNumber,ltspName,custName,businessVertical,Integer.parseInt(noOfVehicles),acqDate,Integer.parseInt(systemIdFromJsp),Integer.parseInt(custId),Integer.parseInt(verticalId),morePotential,Integer.parseInt(IdFromCustomerMaster));
	            } 
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
//----------------------------------------------------------------------------------------------------------------//
	
	    return null;
	}
	
	}