package t4u.containercargomanagement;

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
import t4u.functions.ContainerCargoManagementFunctions;

public class SumarryInvoicePTAction extends Action{
	public ActionForward execute(ActionMapping map, ActionForm form, HttpServletRequest req, HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
			int clientId = loginInfo.getCustomerId();
			int offset = loginInfo.getOffsetMinutes();
			String param = "";
			if(req.getParameter("param") != null && !req.getParameter("param").equals("")){
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			ContainerCargoManagementFunctions ccmFunc = new ContainerCargoManagementFunctions();
			
			if(param.equals("getSumarryInvoiceDetails")){
				String principalId = req.getParameter("principalId");
				String typeId = req.getParameter("typeId");
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				String invoiceType = req.getParameter("invoiceType");
				try{
					obj = new JSONObject();
					if(principalId != null && !principalId.equals("")){
						jArr = ccmFunc.getSumarryInvoiceDetails(systemId,clientId,principalId,typeId,startDate,endDate,offset,invoiceType);
						if(jArr.length() > 0){
							obj.put("summaryGridRoot", jArr);
						}else{
							obj.put("summaryGridRoot", "");
						}
					}else{
						obj.put("summaryGridRoot", "");
					}
					resp.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getPrincipal")){
				try{
					jArr = ccmFunc.getPrincipalStore(systemId, clientId);
					obj = new JSONObject();
					if(jArr.length() > 0){
						obj.put("PrincipalRoot", jArr);
					}else{
						obj.put("PrincipalRoot", "");
					}
					resp.getWriter().println(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
}
