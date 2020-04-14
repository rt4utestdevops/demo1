package t4u.containercargomanagement;

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
import t4u.functions.ContainerCargoManagementFunctions;

public class DetentionReportAction extends Action{

	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		
		HttpSession session = (HttpSession) request.getSession();
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		int ltsp = loginInfo.getIsLtsp();
		ContainerCargoManagementFunctions cfunc = new ContainerCargoManagementFunctions();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		String param = "";
		ArrayList<Object> list = new ArrayList<Object>();
		if(request.getParameter("param") != null) {
			param = request.getParameter("param");
		}
		if(param.equals("getBranch")) {
			try {
				if(ltsp == 0){
					jsonArray = cfunc.getBranch(systemId,String.valueOf(customerId));
				}else{
					jsonArray = cfunc.getUserAssociatedBranches(systemId,customerId,userId);
				}
				if(jsonArray.length() > 0) {
					jsonObject.put("loadingBranchNameList", jsonArray);
				} else {
					jsonObject.put("loadingBranchNameList", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equals("getVehicles")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = cfunc.getVehiclesAll( systemId, String.valueOf(customerId), userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehiclesList", jsonArray);
				} else {
					jsonObject.put("vehiclesList", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getDetentionDetails")){
			String branchId = request.getParameter("branchId");
			String vehicleNo = request.getParameter("vehicleNo");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String jspName = request.getParameter("jspName");
			String branchName = request.getParameter("branchName"); 
			try{
				jsonObject = new JSONObject();
				if(branchId != null && !branchId.equals("")){
					list = cfunc.getDetentionChargesDetails(systemId,customerId,Integer.parseInt(branchId),vehicleNo,startDate,endDate,offset);
					if(list.size()>0){
						jsonArray = (JSONArray) list.get(0);
						jsonObject.put("DetentionReportDetailsRoot", jsonArray);
						ReportHelper reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName, reportHelper);
						request.getSession().setAttribute("branchName", branchName);
						request.getSession().setAttribute("vehicleNo", vehicleNo);
						request.getSession().setAttribute("startDate",startDate.replace("T", " "));
						request.getSession().setAttribute("endDate",endDate.replace("T", " "));
					}else{
						jsonObject.put("DetentionReportDetailsRoot", "");
					}
				}else{
					jsonObject.put("DetentionReportDetailsRoot", "");
				}
				response.getWriter().println(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		} 
		return null;
	
	}
}
