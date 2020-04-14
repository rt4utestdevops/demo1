package t4u.coldchainlogistics;

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
import t4u.functions.ColdChainLogisticsFunctions;
import t4u.functions.CommonFunctions;

public class PeakOrNonPeakHrsReportAction extends Action{

	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		HttpSession session=request.getSession();
		LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfoBean.getSystemId();
		int offset = loginInfoBean.getOffsetMinutes();
		int userId = loginInfoBean.getUserId();
		String language = loginInfoBean.getLanguage();
		String param = "";
		CommonFunctions cf = new CommonFunctions();
		ColdChainLogisticsFunctions cclf = new ColdChainLogisticsFunctions();
		
		if(request.getParameter("param")!=null && !request.getParameter("param").equals("")){
			param = request.getParameter("param");
		}
		
		if(param.equals("getPickOrNonPickReportSummary")){
			
			String custId = request.getParameter("CustId");
			String startDate = request.getParameter("startdate");
			String endDate = request.getParameter("enddate");
			
			JSONArray jsonArr = new JSONArray();
			JSONObject jsonObj = new JSONObject();
			
			jsonArr = cclf.getPeakOrNonPeakReportSummary(systemId,custId,startDate,endDate,offset,userId);
			if(jsonArr.length()>0){
				jsonObj.put("peakOrNonPeakReportSummaryReader", jsonArr);
			} else {
				jsonObj.put("peakOrNonPeakReportSummaryReader", "");
			}
			
			response.getWriter().print(jsonObj.toString());
			
		} else if(param.equals("getPeakorNonPeakHrsReportsDetails")){
			try
			{
				String custId = request.getParameter("CustId");
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate");
				String jspName = request.getParameter("jspName");
			
				JSONObject jsonObj = new JSONObject();
				JSONArray jsonArray = null;
				ArrayList<Object> list = cclf.getPeakOrNonPeakReportDetails(systemId,custId,startDate,endDate,offset,userId,language);
				jsonArray = (JSONArray) list.get(0);
				if(jsonArray != null){
					if(jsonArray.length()>0){
						jsonObj.put("peakOrNonPeakReportDetailsReader", jsonArray);
					}
				} else {
						jsonObj.put("peakOrNonPeakReportDetailsReader", "");
				}
				response.getWriter().print(jsonObj.toString());
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("startDate", cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
				request.getSession().setAttribute("endDate", cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
		
			}catch (Exception e){
				e.printStackTrace();
			}
		}
		return null;
	}

	
}
