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
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class DMGDashBoardAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
			int customerId = loginInfo.getCustomerId();
			int userId = loginInfo.getUserId();
			int offmin = loginInfo.getOffsetMinutes();
			int isLtsp = loginInfo.getIsLtsp();
			String zone=loginInfo.getZone();
			IronMiningFunction iFunc = new IronMiningFunction();
			CommonFunctions cfuncs=new CommonFunctions();
			JSONArray jsonArray = null;
			String param = "";
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			if(param.equals("getDashBoardElementCount")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getDashBoardElementCount(systemId, customerId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("dashBoardRoot", jsonArray);
					} else {
						jsonObject.put("dashBoardRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getTripSheetCountAndQuantity")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getTripSheetCountAndQuantity(systemId, customerId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("tripsheetRoot", jsonArray);
					} else {
						jsonObject.put("tripsheetRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getTripsheetCountForChart")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getTripsheetCountForChart(systemId, customerId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("chartCountRoot", jsonArray);
					} else {
						jsonObject.put("chartCountRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getTripsheetQuantityForChart")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getTripsheetQuantityForChart(systemId, customerId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("chartQuantityRoot", jsonArray);
					} else {
						jsonObject.put("chartQuantityRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equals("getCustomer")) {
				try {
					jsonArray = new JSONArray();
					String ltsp = "no";
					if (request.getParameter("paramforltsp") != null) {
						ltsp = request.getParameter("paramforltsp").toString();
					}
					jsonArray = cfuncs.getCustomer(systemId, ltsp, customerId);
					response.getWriter().print(jsonArray.toString());
				} catch (Exception e) {
					System.out.println("Error in Common Action:-getCustomer "
							+ e.toString());
				}
			}
			if(param.equals("getDashBoardCounts")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getDashBoardCounts(systemId, customerId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("DBoardRoot", jsonArray);
					} else {
						jsonObject.put("DBoardRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getGradeDataForChart")){
				try {
					String type=request.getParameter("type");
					String month=request.getParameter("month");
					String year=request.getParameter("year");
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getGradeDataForChart(systemId, customerId,userId,type,month,year);
					if (jsonArray.length() > 0) {
						jsonObject.put("chartQuantityRoot", jsonArray);
						System.out.println(jsonArray);
					} else {
						jsonObject.put("chartQuantityRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getDaywiseProduction")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getDaywiseProduction(systemId, customerId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("daywiseproductionRoot", jsonArray);
					} else {
						jsonObject.put("daywiseproductionRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getTripsheetQty")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getTripsheetQtyForDasboard(systemId, customerId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("tripQtyRoot", jsonArray);
					} else {
						jsonObject.put("tripQtyRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getProductionChartData")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getProductionChartData(systemId, customerId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("productionChartRoot", jsonArray);
					} else {
						jsonObject.put("productionChartRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getProductionSummary")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getProductionSummary(systemId, customerId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("productionSummaryRoot", jsonArray);
					} else {
						jsonObject.put("productionSummaryRoot", "");
					}
					response.getWriter().print(jsonArray.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getGradeData")){
				try {
					JSONObject jsonObject = new JSONObject();
					String month=request.getParameter("month");
					String year=request.getParameter("year");
					String gradeType=request.getParameter("gradeType");
					jsonArray = iFunc.getGradeData(systemId, customerId,userId,gradeType,month,year);
					if (jsonArray.length() > 0) {
						jsonObject.put("gradeRoot", jsonArray);
					} else {
						jsonObject.put("gradeRoot", "");
					}
					response.getWriter().print(jsonArray.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			
			else if(param.equals("getRoyaltyForDashBoard")){
				try {
					JSONObject jsonObject = new JSONObject();
					String month=request.getParameter("month");
					String year=request.getParameter("year");
					jsonArray = iFunc.getRoyaltyForDashBoard(systemId, customerId,userId,month,year);
					if (jsonArray.length() > 0) {
						jsonObject.put("challanQtyRoot", jsonArray);
					} else {
						jsonObject.put("challanQtyRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getOrgRoyaltyForDashBoard")){
				try {
					String finacialYear = request.getParameter("financialYear");
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getOrgRoyaltyForDashBoard(systemId, customerId,userId,finacialYear);
					if (jsonArray.length() > 0) {
						jsonObject.put("orgRoyaltyRoot", jsonArray);
					} else {
						jsonObject.put("orgRoyaltyRoot", "");
					}
					//System.out.println(jsonObject.toString());
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getAccountDetailsForDashBoard")){
				try {
					String finacialYear = request.getParameter("financialYear");
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getAccountDetailsForDashBoard(systemId, customerId,userId,finacialYear);
					if (jsonArray.length() > 0) {
						jsonObject.put("accountDetailsRoot", jsonArray);
					} else {
						jsonObject.put("accountDetailsRoot", "");
					}
					//System.out.println(jsonObject.toString());
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getMonthlyAccountDetailsForDashBoard")){
				try {
					JSONObject jsonObject = new JSONObject();
					String finacialYear = request.getParameter("financialYear");
					jsonArray = iFunc.getMonthlyAccountDetailsForDashBoard(systemId, customerId,userId,finacialYear);
					if (jsonArray.length() > 0) {
						jsonObject.put("monthlyAccountDetailsRoot", jsonArray);
					} else {
						jsonObject.put("monthlyAccountDetailsRoot", "");
					}
					//System.out.println(jsonObject.toString());
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if(param.equals("getLatest7DaysProduction")){
				try {
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getLatest7DaysProduction(systemId, customerId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("Latest7DaysProductionRoot", jsonArray);
					} else {
						jsonObject.put("Latest7DaysProductionRoot", "");
					}
					//System.out.println(jsonObject.toString());
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}	
			else if(param.equals("getTypeWiseDMFDeatils")){
				try {
					JSONObject jsonObject = new JSONObject();
					String finacialYear = request.getParameter("financialYear");
					jsonArray = iFunc.getDMFDetailsForDashBoard(systemId, customerId, userId, finacialYear);
					if (jsonArray.length() > 0) {
						jsonObject.put("TypeWisedmfDetailsRoot", jsonArray);
					} else {
						jsonObject.put("TypeWisedmfDetailsRoot", "");
					}
					//System.out.println(jsonObject.toString());
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}	
			else if(param.equals("getTotalDmfForFinancialYear")){
				try {
					String finacialYear = request.getParameter("financialYear");
					JSONObject jsonObject = new JSONObject();
					jsonArray = iFunc.getTotalDmfForFinancialYear(systemId, customerId,userId,finacialYear);
					if (jsonArray.length() > 0) {
						jsonObject.put("totalDmfRoot", jsonArray);
					} else {
						jsonObject.put("totalDmfRoot", "");
					}
					//System.out.println(jsonObject.toString());
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return null;
	}
}
