package t4u.ironMining;

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
import t4u.beans.ReportHelper;

import t4u.functions.IronMiningFunction;

public class PermitReportAction  extends Action{
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		IronMiningFunction ironMiningFunction = new IronMiningFunction();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
		String zone=loginInfo.getZone();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
				 if (param.equalsIgnoreCase("getOrganisationName")) {
					try {
						String custId=request.getParameter("CustID");
						jsonArray = new JSONArray();
						jsonObject = new JSONObject();
							jsonArray =ironMiningFunction.getOrganisationName(Integer.parseInt(custId),systemId,userId);
							if (jsonArray.length() > 0) {
								jsonObject.put("OrgStoreRoot", jsonArray);
							} else {
								jsonObject.put("OrgStoreRoot", "");
							}
							response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				  }
				 
				 else if (param.equalsIgnoreCase("getPermitReportDetails")) {
				        try {
				        	SimpleDateFormat ymd=new SimpleDateFormat("yyyy-MM-dd");
							SimpleDateFormat dmy = new SimpleDateFormat("dd/MM/yyyy");
				        	ArrayList list=null;
				            String CustomerId = request.getParameter("CustID");
				            String jspName=request.getParameter("jspName");
				            String customerName=request.getParameter("CustName");
							String OrgID=request.getParameter("OrgID");
							String Organizationname=request.getParameter("Orgname");
							String mineral=request.getParameter("mineral");
							String startdate = request.getParameter("startdate").replace('T', ' ');
							String startd1=startdate;
							startd1=startd1.substring(0,10);
							String enddate = request.getParameter("enddate").replace('T', ' ');
							String endd1=enddate;
							endd1=endd1.substring(0,10);
					        jsonArray = new JSONArray();
				            jsonObject = new JSONObject();
				            
				            if (CustomerId != null && !CustomerId.equals("")) {
				            	
				                list =ironMiningFunction.getPermitReportDetails(systemId, Integer.parseInt(CustomerId),Integer.parseInt(OrgID),mineral,startd1,endd1);
				                jsonArray = (JSONArray) list.get(0);
				                if (jsonArray.length() > 0) {
				                    jsonObject.put("permitroot", jsonArray);
				                } else {
				                    jsonObject.put("permitroot", "");
				                }	            	
				            } else {
				                jsonObject.put("permitroot", "");
				            }
				            if(!startd1.equals("") && !endd1.equals("")){
					    		startd1 =dmy.format(ymd.parse(startd1));
					    		endd1 =dmy.format(ymd.parse(endd1));
					    	}
				            ReportHelper reportHelper = (ReportHelper) list.get(1);
							request.getSession().setAttribute(jspName, reportHelper);
			                request.getSession().setAttribute("custName",customerName);
			                request.getSession().setAttribute("startDate", startd1);
			                request.getSession().setAttribute("endDate", endd1);
			                request.getSession().setAttribute("OrgID", OrgID);
			                request.getSession().setAttribute("Organizationname", Organizationname);
			                request.getSession().setAttribute("mineral", mineral);
			                response.getWriter().print(jsonObject.toString());
				            
				        } catch (Exception e) {
				            e.printStackTrace();
				        }
			    	}
				 else if (param.equalsIgnoreCase("getPermitSummaryDetails")) {
						jsonObject = new JSONObject();
						jsonArray = new JSONArray();
						try {
							int customerId=Integer.parseInt(request.getParameter("CustId"));
							String custName=request.getParameter("custName");
							systemId=Integer.parseInt(request.getParameter("systemId"));
							String jspName=request.getParameter("jspName");
							String startDate=request.getParameter("startdate");
							startDate=startDate.replaceAll("T00:00:00", "");
	                        String endDate=request.getParameter("enddate");
	                        endDate=endDate.replaceAll("T00:00:00", "");
	                        String mineralType=request.getParameter("mineralType");
	                        ArrayList < Object > list=ironMiningFunction.getPermitSummeryDetails(systemId,customerId,userId,startDate,endDate,mineralType);
	                        jsonArray = (JSONArray) list.get(0);
	                        if (jsonArray.length() > 0) {
								jsonObject.put("PermitSummaryDetailsRoot", jsonArray);
							} else {
								jsonObject.put("PermitSummaryDetailsRoot", "");
							}
	                        ReportHelper reportHelper = (ReportHelper) list.get(1);
							request.getSession().setAttribute(jspName, reportHelper);
							request.getSession().setAttribute("custName", custName);
							request.getSession().setAttribute("startDate", startDate);
							request.getSession().setAttribute("endDate", endDate);
							request.getSession().setAttribute("mineralType", mineralType);
							response.getWriter().print(jsonObject.toString());
	                        
						}
						catch (Exception e) {
							e.printStackTrace();
						}
						
					}
				 return null;
			}
		}

