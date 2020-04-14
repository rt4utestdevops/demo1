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
import t4u.functions.SandExcavationFunction;
import t4u.functions.SandMiningFunctions;

public class SandExcavationReportAction extends Action  {
	
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
        HttpSession session = request.getSession();
        String param = "";
     //   String zone = "";
        int systemId = 0;
       // int userId = 0;
        int offset = 0;
    	//SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    //	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        systemId = loginInfo.getSystemId();
       int custId1= loginInfo.getCustomerId();
      //  zone = loginInfo.getZone();
      //  userId = loginInfo.getUserId();
       offset = loginInfo.getOffsetMinutes();
    //    String lang = loginInfo.getLanguage();
      //  zone = loginInfo.getZone();
      //  CashVanManagementFunctions cvmf=new CashVanManagementFunctions();
        CreateTripFunction creatTripFunc = new CreateTripFunction();
        SandMiningFunctions smfunc = new SandMiningFunctions();
        SandExcavationFunction sandef= new SandExcavationFunction();
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
        
    	else if (param.equals("getSandExcavationReport")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String tpId = request.getParameter("tpId");
	            String startDate = request.getParameter("startdate");
	            String endDate = request.getParameter("enddate")+" "+ "23:59:59";
	            jsonObject = new JSONObject();
	            jsonArray = new JSONArray();
	            if (customerId != null && !customerId.equals("")) {
	            	startDate = startDate.replaceAll("T", " ");
	            	endDate = endDate.replaceAll("T", " ");
	                ArrayList < Object > list1 = smfunc.getSandExcavationReport(systemId, Integer.parseInt(customerId),startDate,endDate,offset , Integer.parseInt(tpId));
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
        
        /*
         *  added by Mallikarjuna C for sand Excavation report 
         */
        
        
    	else if(param.equals("getCustomerList")){
			try {
				jsonObject = new JSONObject();
				if (custId1 != 0) {
					jsonArray = sandef.getCustomer(custId1, systemId);
					jsonObject.put("customerRoot", jsonArray);
				}
				else{
					jsonObject.put("customerRoot", "");
					}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
    	else if (param.equals("getTPownerNameList")) {
			try {
				
				String clientId = request.getParameter("CustId").trim();
				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = sandef.getTPOwners(systemId,Integer.parseInt(clientId));
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
        
    	else if (param.equals("getboatNames")) {
			try {
				
				String clientId = request.getParameter("CustId").trim();
				String tpId = request.getParameter("tpId").trim();
				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = sandef.getBoatNames(systemId,Integer.parseInt(clientId),Integer.parseInt(tpId));
					jsonObject.put("boatName", jsonArray);
				}
				else{
					jsonObject.put("boatName", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}
        
    	else if (param.equals("getAssHubList")) {
			try {
				
				String clientId = request.getParameter("CustId").trim();
				String hubId = request.getParameter("hubId").trim();
				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = sandef.getAssociatedHub(systemId,Integer.parseInt(clientId),Integer.parseInt(hubId));
					jsonObject.put("assHubName", jsonArray);
				}
				else{
					jsonObject.put("assHubName", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}
        
    	else if (param.equals("getDiSAssHubList")) {
			try {
				String clientId = request.getParameter("CustId").trim();
				String hubId = request.getParameter("hubId").trim();
				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = sandef.getDisAssociatedHub(systemId,Integer.parseInt(clientId),Integer.parseInt(hubId));
					jsonObject.put("disAssHubName", jsonArray);
				}
				else{
					jsonObject.put("disAssHubName", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}
        
    	else if (param.equals("getSandExcavationDetails")) {
			try {
				
				String clientId = request.getParameter("CustId").trim();
				String tpId = request.getParameter("tpId").trim();
				String assetNumber = request.getParameter("assetNumber");
				String assetId = request.getParameter("assetId");
				String startDur = request.getParameter("startDur");
				String endDur = request.getParameter("endDur");
				String startAsscDis = request.getParameter("startAsscDis");
				String endAsscDis = request.getParameter("endAsscDis");
				String startDisAsscDis = request.getParameter("startDisAsscDis");
				String endDisAsscDis = request.getParameter("endDisAsscDis");
				String associatedHubId = request.getParameter("associatedHubId");
				String disAsscHubId = request.getParameter("disAsscHubId");
				String dateRange = request.getParameter("dateRange");
				String[] dates = dateRange.split("-");
				String startDate =dates[0].trim().replace("/", "-")+" 00:00:00";
				String endDate = dates[1].trim().replace("/", "-")+" 23:59:59";
				String aHubName = request.getParameter("aHubName");
				String uHubName = request.getParameter("uHubName");
				
				
				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = sandef.getExcavationTrip(systemId,Integer.parseInt(clientId),Integer.parseInt(tpId),assetNumber,
							Integer.parseInt(assetId),
							Integer.parseInt(startDur),
							Integer.parseInt(endDur),
							Integer.parseInt(startAsscDis),
							Integer.parseInt(endAsscDis),
							Integer.parseInt(startDisAsscDis),
							Integer.parseInt(endDisAsscDis),
							Integer.parseInt(associatedHubId),
							Integer.parseInt(disAsscHubId),
							startDate,endDate,aHubName,uHubName,offset);
					jsonObject.put("sandReport", jsonArray);
				}
				else{
					jsonObject.put("sandReport", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}
        
        
    	else if (param.equals("getExcavationDetails")) {
			try {
				String clientId = request.getParameter("CustId").trim();
				String tripNO = request.getParameter("tripNO").trim();
				String assetNumber = request.getParameter("assetNumber").trim();
				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = sandef.getExcavatioDetails(Integer.parseInt(clientId), systemId, Integer.parseInt(tripNO), assetNumber,offset);
					jsonObject.put("excavationDetails", jsonArray);
				}
				else{
					jsonObject.put("excavationDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}
        
    	else if (param.equals("getTPWiseBoatAssociationDetails")) {
			try {
				String clientId = String.valueOf(custId1);
				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = sandef.getTPWiseBoatAssociationDetails(clientId, systemId);
					jsonObject.put("tpWiseBoatAssocReportDetails", jsonArray);
				}
				else{
					jsonObject.put("tpWiseBoatAssocReportDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}
        
    	else if (param.equals("getZeroValueCooordinatesDetails")) {
			try {
				String clientId = String.valueOf(custId1);
				jsonObject = new JSONObject();
				if (clientId != null) {
					jsonArray = sandef.getZeroValueCooordinatesDetails(clientId, systemId);
					jsonObject.put("zeroValueCooordinatesDetails", jsonArray);
				}
				else{
					jsonObject.put("zeroValueCooordinatesDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			}

			catch (Exception e) {
				e.printStackTrace();
			}
		}
        
        
		return null;

	}
	}
