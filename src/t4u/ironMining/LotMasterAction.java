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
import t4u.functions.IronMiningFunction;

public class LotMasterAction  extends Action{
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		IronMiningFunction ironfunc = new IronMiningFunction();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
		String zone=loginInfo.getZone();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

      if (param.equalsIgnoreCase("getLotMasterDetails")) {
	        try {
	        	ArrayList list=null;
	            String CustomerId = request.getParameter("CustID");
	            String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            
	            if (CustomerId != null && !CustomerId.equals("")) {
	            	
	                list =ironfunc.getLotMasterDetails(systemId, Integer.parseInt(CustomerId));
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("lotroot", jsonArray);
	                } else {
	                    jsonObject.put("lotroot", "");
	                }	            	
	            } else {
	                jsonObject.put("lotroot", "");
	            }
	            ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
                request.getSession().setAttribute("custId", customerName);
                response.getWriter().print(jsonObject.toString());
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
		else if (param.equalsIgnoreCase("addmodifyLotMasterDetails")) {
			try {

				String buttonValue = request.getParameter("buttonValue");
				String custId=request.getParameter("custId");
				String LotNo=request.getParameter("LotNo");
				String LotLocation=request.getParameter("LotLocation");
				String grade= request.getParameter("grade");
				String type= request.getParameter("type");
				String quantity= request.getParameter("quantity");
				String remarks= request.getParameter("remarks");
				String amount40= request.getParameter("amount");
				String date40= request.getParameter("date").replace('T', ' ');;
				String amount60= request.getParameter("amount1");
				String date60= request.getParameter("date1").replace('T', ' ');;
				String id=request.getParameter("id");
				 String message="";
				if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
				{
                     message=ironfunc.addLotMaster(LotNo,Integer.parseInt(LotLocation),grade,type,quantity,remarks,amount40,date40,amount60,date60,systemId,Integer.parseInt(custId),userId);
				}
				else if (buttonValue.equals("Modify") && custId != null && !custId.equals(""))
				{
					message=ironfunc.modifyLotMaster(amount40,date40,amount60,date60,remarks,systemId,Integer.parseInt(custId),userId,id);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("addLotDetails")) {
			try {
				String custId = request.getParameter("custId");
				String lotNo = request.getParameter("lotNo");
				String orgId = request.getParameter("orgId") != null && !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
				String quantity = request.getParameter("quantity");
				String lotLoc = request.getParameter("lotLoc") != null && !request.getParameter("lotLoc").equals("") ? request.getParameter("lotLoc") : "0";
				String type = request.getParameter("type");
				String message = "";
				if (custId != null && !custId.equals("")) {
					message = ironfunc.addLotDetails(Integer.parseInt(custId),
									systemId, Integer.parseInt(orgId),Double.valueOf(quantity), userId,lotNo,Integer.parseInt(lotLoc),type);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getLotNo")) {
			try {
				String custId = request.getParameter("custId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getLotNo(Integer.parseInt(custId), systemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("lotNameRoot", jsonArray);
					} else {
						jsonObject.put("lotNameRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getOrgNames")) {
			try {
				String custId = request.getParameter("custId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getOrganizationCode(Integer.parseInt(custId), systemId,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("orgRoot", jsonArray);
					} else {
						jsonObject.put("orgRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getLotDetails")) {
			try {
				String custId = request.getParameter("custId");
				String CustName = request.getParameter("CustName");
				String jspName = request.getParameter("jspName");
				jsonArray = new JSONArray();
				ArrayList<Object> list = ironfunc.getLotDetails(Integer.parseInt(custId), systemId, userId);
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("lotDetailsRoot", jsonArray);
				} else {
					jsonObject.put("lotDetailsRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("CustName", CustName);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("cancelLotMasterDetails")) {
			String customerId = request.getParameter("CustID");
			String id = request.getParameter("id");
			String remarks= request.getParameter("remark");
			
			String message1="";
			if (customerId != null && !customerId.equals("") && id != null && !id.equals("")) {
				try {
					message1 = ironfunc.cancelLotMasterDetails(Integer.parseInt(customerId), systemId,userId,Integer.parseInt(id),remarks);
					response.getWriter().print(message1);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
      
		else if (param.equalsIgnoreCase("cancelLotDetails")) {
			String customerId = request.getParameter("CustID");
			String id = request.getParameter("id");
			String remarks= request.getParameter("remark");
			String orgId= request.getParameter("orgId");
			String quantity= request.getParameter("quantity");
			String lotLoc= request.getParameter("lotLoc");
			String type= request.getParameter("type");
			String message1="";
			if (customerId != null && !customerId.equals("") && id != null && !id.equals("")) {
				try {
					message1 = ironfunc.cancelLotAllocationDetails(Integer.parseInt(customerId), systemId,userId,Integer.parseInt(id),remarks,Integer.parseInt(orgId),Float.parseFloat(quantity),Integer.parseInt(lotLoc),type);
					response.getWriter().print(message1);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return null;
	}

}
