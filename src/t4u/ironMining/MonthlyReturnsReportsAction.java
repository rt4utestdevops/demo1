package t4u.ironMining;



import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class MonthlyReturnsReportsAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) {
		try {
			HttpSession session = request.getSession();
			String param = "";
			int systemId = 0;
			int userId = 0;
			int customerId = 0;
			int custId=0;
			int offset = 0;
			String zone = "";
			String message = "";
			String lang ="";
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			if (loginInfo != null) {
				systemId = loginInfo.getSystemId();
				userId = loginInfo.getUserId();
				customerId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				zone = loginInfo.getZone();
				lang = loginInfo.getLanguage();
				IronMiningFunction ironMiningFunction = new IronMiningFunction();
				JSONArray jsonArray = null;
				JSONObject jsonObject = null;
				if (request.getParameter("param") != null) {
					param = request.getParameter("param").toString();
				}
				if (param.equalsIgnoreCase("getDeductionDetails")) {
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
						customerId=Integer.parseInt(request.getParameter("CustId"));
						String custName=request.getParameter("custName");
						systemId=Integer.parseInt(request.getParameter("systemId"));
						String jspName=request.getParameter("jspName");
						String monthYear=request.getParameter("monthYear");
                        String mineralName=request.getParameter("mineralname");
                        String deductioinClaimed=request.getParameter("deductioinClaimed");
                        String deductionClaimedvalue=request.getParameter("deductionClaimedvalue");
                        ArrayList < Object > list=ironMiningFunction.getDeductionClaimDetails(systemId,customerId,monthYear,mineralName,deductionClaimedvalue);
                        jsonArray = (JSONArray) list.get(0);
                        if (jsonArray.length() > 0) {
							jsonObject.put("DeductionDetailsRoot", jsonArray);
						} else {
							jsonObject.put("DeductionDetailsRoot", "");
						}
                        ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custId", custName);
						request.getSession().setAttribute("monthYear", monthYear);
						request.getSession().setAttribute("mineralName", mineralName);
						request.getSession().setAttribute("deductioinClaimed", deductioinClaimed);
						response.getWriter().print(jsonObject.toString());
                        
					}
					catch (Exception e) {
						e.printStackTrace();
					}
					
				}
				else if (param.equalsIgnoreCase("getGradeDetails")) {
					jsonArray = new JSONArray();
					jsonObject=new JSONObject();
					try { 
						String mineral =request.getParameter("mineral");
						jsonArray=ironMiningFunction.getGradeWiseProductionDespatchList(mineral,"Dispatch");
					
						if (jsonArray.length() > 0) {
							jsonObject.put("GradeRoot", jsonArray);
						} else {
							jsonObject.put("GradeRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					}
					catch (Exception e) {
						e.printStackTrace();
					}
					
				}
				
				else if (param.equalsIgnoreCase("getProductionReport")) {
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					CommonFunctions cf = new  CommonFunctions();
					String jspName = request.getParameter("jspName");
					String mineralName =request.getParameter("mineralName");
					String category =request.getParameter("category");
					String month=request.getParameter("month");
					String year=request.getParameter("year");
					String customerid=request.getParameter("custId");
					try {
						ArrayList < Object > list = ironMiningFunction.getProductionOfROMReport(mineralName,category,month,systemId,Integer.parseInt(customerid),year);
						jsonArray = (JSONArray) list.get(0);
						if (jsonArray.length() > 0) {
							jsonObject.put("productionReportRoot", jsonArray);
						} else {
							jsonObject.put("productionReportRoot", "");
						}
						ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
		                request.getSession().setAttribute("custId", cf.getCustomerName(String.valueOf(customerid), systemId));
		                request.getSession().setAttribute("month",month);
		                request.getSession().setAttribute("year",year);
		                request.getSession().setAttribute("mineralType", mineralName);
		                request.getSession().setAttribute("category",category );
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				if (param.equalsIgnoreCase("getCategory")) {
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
						String typeOfOre = "";
						if(request.getParameter("typeOfOre") != null && !request.getParameter("typeOfOre").equals("")){
							typeOfOre = request.getParameter("typeOfOre");
						}
						jsonArray = ironMiningFunction.getCategory(typeOfOre);
						if (jsonArray.length() > 0) {
							jsonObject.put("categoryRoot", jsonArray);
						} else {
							jsonObject.put("categoryRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				if (param.equalsIgnoreCase("getSalesDispatchDetails")) {
					jsonObject = new JSONObject();
					jsonArray = new JSONArray();
					try {
						customerId=Integer.parseInt(request.getParameter("CustId"));
						String custName=request.getParameter("custName");
						systemId=Integer.parseInt(request.getParameter("systemId"));
						String jspName=request.getParameter("jspName");
						String monthYear=request.getParameter("monthYear");
                        String mineralName=request.getParameter("mineralname");
                        String grade=request.getParameter("grade");
                        ArrayList < Object > list=ironMiningFunction.getSalesDispatchDetails(systemId,customerId,monthYear,mineralName,grade);
                        jsonArray = (JSONArray) list.get(0);
                        if (jsonArray.length() > 0) {
							jsonObject.put("GradeDetailsRoot", jsonArray);
						} else {
							jsonObject.put("GradeDetailsRoot", "");
						}
                        ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("custId", custName);
						request.getSession().setAttribute("monthYear", monthYear);
						request.getSession().setAttribute("mineralName", mineralName);
						request.getSession().setAttribute("grade", grade);
						response.getWriter().print(jsonObject.toString());
                        
					}
					catch (Exception e) {
						e.printStackTrace();
					}
					
				}
				if (param.equalsIgnoreCase("getEmploymentDetails")) {
			    	try {
						ArrayList list=null;
						String jspName = request.getParameter("jspName");
						String custName = request.getParameter("custName");
						jsonArray = new JSONArray();
						jsonObject = new JSONObject();

						if(request.getParameter("custId") != null && !request.getParameter("custId").equals("")){
							custId = Integer.parseInt(request.getParameter("custId")); 
						
						String labour = request.getParameter("labour");
						String workPlace=request.getParameter("workPlace");
						String mineralName= request.getParameter("mineralName");
						String month = request.getParameter("month");
						String year = request.getParameter("year");
						list = ironMiningFunction.getEmploymentDetails(custId,systemId,labour,workPlace,mineralName,month,year);
						jsonArray = (JSONArray) list.get(0);
						if (jsonArray.length() > 0) {
							jsonObject.put("employmentReportRoot", jsonArray);
						} else {
							jsonObject.put("employmentReportRoot", "");
						}
						ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName,reportHelper);
						request.getSession().setAttribute("custId", custName);
						request.getSession().setAttribute("month", month+" "+year);
						request.getSession().setAttribute("mineralName", mineralName);
						request.getSession().setAttribute("labour", labour);
						request.getSession().setAttribute("workPlace", workPlace);
						
						
						response.getWriter().print(jsonObject.toString());				}
					}
					catch (Exception e) {
						e.printStackTrace();
					}
			      }
				 else if (param.equalsIgnoreCase("getGrade")) {
						jsonObject = new JSONObject();
						jsonArray = new JSONArray();
						try {
							String mineralName = "";
							if(request.getParameter("typeOfOre") != null && !request.getParameter("typeOfOre").equals("")){
								mineralName = request.getParameter("typeOfOre");
							}
							jsonArray = ironMiningFunction.getGradeWiseProductionDespatchList(mineralName,"Grades");
							if (jsonArray.length() > 0) {
								jsonObject.put("gradeRoot", jsonArray);
							} else {
								jsonObject.put("gradeRoot", "");
							}
							response.getWriter().print(jsonObject.toString());
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
					else if(param.equalsIgnoreCase("getMRFGradeWiseReport")){
				    	jsonObject = new JSONObject();
						jsonArray = new JSONArray();
						int custsId = 0;
						String mineralName = request.getParameter("typeOfOre");
						String custName=request.getParameter("custName");
						String jspName = request.getParameter("jspName");
						String grade = request.getParameter("grade");
						String month = request.getParameter("month");
						String year = request.getParameter("year");
						try {
							if(request.getParameter("custId") != null && !request.getParameter("custId").equals("") && request.getParameter("custName") != null && !request.getParameter("custName").equals("") && request.getParameter("jspName") != null && !request.getParameter("jspName").equals("")){
								custsId = Integer.parseInt(request.getParameter("custId"));
							}
							ArrayList<Object> mrfGradeDetails = ironMiningFunction.getMRFGradewiseDetails(systemId,custsId,month,year,mineralName,grade);
							jsonArray = (JSONArray) mrfGradeDetails.get(0);
							if (jsonArray.length() > 0) {
								jsonObject.put("gradeWiseRoot", jsonArray);
							} else {
								jsonObject.put("gradeWiseRoot", "");
							}
							ReportHelper reportHelper = (ReportHelper) mrfGradeDetails.get(1);
							request.getSession().setAttribute(jspName, reportHelper);
			                request.getSession().setAttribute("custId", custName);
			                request.getSession().setAttribute("date", month+" "+year);
			                request.getSession().setAttribute("mineralName", mineralName);
			                request.getSession().setAttribute("grade", grade);
							response.getWriter().print(jsonObject.toString());
						} catch (Exception e) {
							e.printStackTrace();
						}
				    }
			} else {
				if (request.getParameter("param").equals("checkSession")) {
					response.getWriter().print("InvalidSession");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
}
