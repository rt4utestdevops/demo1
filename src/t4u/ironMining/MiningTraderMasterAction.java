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
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class MiningTraderMasterAction extends Action{

	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		//int offset = loginInfo.getOffsetMinutes();
		int countryCode=loginInfo.getCountryCode();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String message="";
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getTraderMasterDetails")) {
			try {
				String CustomerId = request.getParameter("CustId");
				String custName=request.getParameter("custName");
				String jspName=request.getParameter("jspName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					ArrayList < Object > list=ironfunc.getTraderMasterDetails(Integer.parseInt(CustomerId), systemId);
					jsonArray = (JSONArray) list.get(0);
                    if (jsonArray.length() > 0) {
						jsonObject.put("traderMasterDetailsRoot", jsonArray);
					} else {
						jsonObject.put("traderMasterDetailsRoot", "");
					}
					reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("custName", custName);
					request.getSession().setAttribute("reportName", "Trader Master");
				}	
					response.getWriter().print(jsonObject.toString());
				 
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println(e.toString());
			}
		}
		else if (param.equalsIgnoreCase("AddorModifyTraderMasterDetails")){
			        try {
			        	String CustId= request.getParameter("CustId");
			        	String buttonValue = request.getParameter("buttonValue");
			        	String ibmAppNo = request.getParameter("ibmAppNo");
			        	String appDate = request.getParameter("appDate");
			        	String type = request.getParameter("type");
			        	String ibmTraderNo = request.getParameter("ibmTraderNo");
			        	String nameOfTrader = request.getParameter("nameOfTrader");
			        	String address= request.getParameter("address");
			        	String panNo = request.getParameter("panNo");
			        	String iecNo= request.getParameter("iecNo");
			        	String tinNo = request.getParameter("tinNo");
			        	String dmgTraderNo= request.getParameter("dmgTraderNo");
			        	String dateOfIssue = request.getParameter("dateOfIssue");
			        	String Id = request.getParameter("id");
			        	String aliasName=request.getParameter("aliasName");
			        	String gstNo=request.getParameter("gstNo");
			        	String appNoTBR=request.getParameter("appNoTBR");
			        	
			            if (buttonValue.equals("Add") && CustId != null && !CustId.equals("")) {
			              message = ironfunc.insertTraderMasterInformation(Integer.parseInt(CustId),systemId,ibmAppNo,appDate,type,ibmTraderNo,nameOfTrader,address,panNo,iecNo,tinNo,dmgTraderNo,dateOfIssue,userId,aliasName,gstNo,appNoTBR);
			            }
			            else if (buttonValue.equals("Modify")&& CustId != null && !CustId.equals("")) {
				              message = ironfunc.modifyTraderMasterInformation(Integer.parseInt(CustId),systemId,ibmAppNo,appDate,ibmTraderNo,nameOfTrader,address,panNo,iecNo,tinNo,dmgTraderNo,dateOfIssue,userId,Integer.parseInt(Id),aliasName,gstNo,appNoTBR);
				            
				            }
			            response.getWriter().print(message);
			        } catch (Exception e) {
			            e.printStackTrace();
			        }
				}
		
		
			return null;
		}
	
}
