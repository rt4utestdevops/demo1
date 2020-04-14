package t4u.containercargomanagement;

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
import t4u.functions.ContainerCargoManagementFunctions;

public class ProfitAndLossAction extends Action{
	public ActionForward execute(ActionMapping mapping,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		HttpSession session = req.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int clientId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		String param = "";
		if(req.getParameter("param") != null){
			param = req.getParameter("param");
		}
		JSONArray jArr = new JSONArray();
		JSONObject obj = new JSONObject();
		ContainerCargoManagementFunctions ccmfunc = new ContainerCargoManagementFunctions();
		ArrayList<Object> List = new ArrayList<Object>();
		ReportHelper reportHelper = new ReportHelper();
		if(param.equals("getVehicleNo")){
			try{
			jArr = ccmfunc.getVehicles(systemId,String.valueOf(clientId),userId);
			if(jArr.length() > 0){
				obj.put("vehicleGridRoot", jArr);
			}else{
				obj.put("vehicleGridRoot", "");
			}
			resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getProfitAndLossDetails")){
			String vehicleNo = req.getParameter("vehicleNo");
			String fromDate = req.getParameter("fromDate");
			String toDate = req.getParameter("toDate");
			String jspName = req.getParameter("jspName");
			SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat monthFormat = new SimpleDateFormat("MMM yyyy");
			try{
				obj = new JSONObject();
				List = ccmfunc.getProfitAndLossDetails(systemId,clientId,offset,vehicleNo,fromDate,toDate);
				if(List.size() > 0){
					jArr = (JSONArray) List.get(0);
					obj.put("profitLossRoot", jArr);
					reportHelper = (ReportHelper) List.get(1);
					req.getSession().setAttribute(jspName, reportHelper);
					req.getSession().setAttribute("startDate", monthFormat.format(sdfDB.parse(fromDate.replace("T", " "))));
					req.getSession().setAttribute("endDate", monthFormat.format(sdfDB.parse(toDate.replace("T", " "))));
					}else{
					obj.put("profitLossRoot", "");
				}
				resp.getWriter().println(obj.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return null;
	}
}
