package t4u.ironMining;


import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

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


public class MiningTimeSettingAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		IronMiningFunction ironfunc = new IronMiningFunction();
		CommonFunctions cfuncs = new CommonFunctions();
		HttpSession session = request.getSession();
		String param = "";
		int systemId = 0;
		int offset = 0;
		int clientId = 0;
		String custName="";
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		systemId=loginInfo.getSystemId();
		clientId=loginInfo.getCustomerId();
		offset=loginInfo.getOffsetMinutes();
		custName=loginInfo.getCustomerName();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		
			if (param.equalsIgnoreCase("getMiningTimes")) {
			try {
				String ltspSystemId=request.getParameter("ltspSystemId")!=null ?request.getParameter("ltspSystemId"):"0";
				String custId=request.getParameter("custId")!=null ?request.getParameter("custId"):"0";
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
					jsonArray =ironfunc.getMiningTimes(Integer.parseInt(custId),Integer.parseInt(ltspSystemId));
					if (jsonArray.length() > 0) {
						jsonObject.put("timesStoreRoot", jsonArray);
					} else {
						jsonObject.put("timesStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }
		  else if (param.equalsIgnoreCase("saveMiningTimes")) {
				try {
					String message="";
					String ltspSystemId=request.getParameter("ltspSystemId")!=null ?request.getParameter("ltspSystemId"):"0";
					String custId=request.getParameter("custId")!=null ?request.getParameter("custId"):"0";
					String startTimeHrs=request.getParameter("startTimeHrs");
					String startTimeMnt=request.getParameter("startTimeMnt");
					String endTimeHrs=request.getParameter("endTimeHrs");
					String endTimeMnt=request.getParameter("endTimeMnt");
					String brStartTimeHrs=request.getParameter("brStartTimeHrs");
					String brStartTimeMnt=request.getParameter("brStartTimeMnt");
					String brEndTimeHrs=request.getParameter("brEndTimeHrs");
					String brEndTimeMnt=request.getParameter("brEndTimeMnt");
					String firstResStartTimeHrs=request.getParameter("firstResStartTimeHrs");
					String firstResStartTimeMnt=request.getParameter("firstResStartTimeMnt");
					String firstResEndTimeHrs=request.getParameter("firstResEndTimeHrs");
					String firstResEndTimeMnt=request.getParameter("firstResEndTimeMnt");
					String secondResStartTimeHrs=request.getParameter("secondResStartTimeHrs");
					String secondResStartTimeMnt=request.getParameter("secondResStartTimeMnt");
					String secondResEndTimeHrs=request.getParameter("secondResEndTimeHrs");
					String secondResEndTimeMnt=request.getParameter("secondResEndTimeMnt");
					String nonComHrs=request.getParameter("nonComHrs");
			        message = ironfunc.saveMiningTimes(Integer.parseInt(ltspSystemId),Integer.parseInt(custId),startTimeHrs+":"+startTimeMnt,endTimeHrs+":"+endTimeMnt,brStartTimeHrs+":"+brStartTimeMnt,brEndTimeHrs+":"+brEndTimeMnt,nonComHrs,firstResStartTimeHrs+":"+firstResStartTimeMnt,firstResEndTimeHrs+":"+firstResEndTimeMnt,secondResStartTimeHrs+":"+secondResStartTimeMnt,secondResEndTimeHrs+":"+secondResEndTimeMnt);
					response.getWriter().print(message);
				} catch (Exception e) {
					e.printStackTrace();
				}
		  }
		  else if (param.equalsIgnoreCase("getLTSPS")) {
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				try {
					jsonArray = cfuncs.getLTSPS();				
					if(jsonArray.length()>0){
						jsonObject.put("LTSPRoot",jsonArray);
					}else{
						jsonObject.put("LTSPRoot","");
					}
					response.getWriter().print(jsonObject.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			else if (param.equalsIgnoreCase("getCustomersForLTSP")) {
				int ltspSystemId=0;
				if(request.getParameter("ltspSystemId")!=null && !request.getParameter("ltspSystemId").equals("")){
					ltspSystemId=Integer.parseInt(request.getParameter("ltspSystemId"));
				}
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				try {
					jsonArray = cfuncs.getCustomersForLTSP(ltspSystemId);				
					if(jsonArray.length()>0){
						jsonObject.put("CustomerRoot",jsonArray);
					}else{
						jsonObject.put("CustomerRoot","");
					}
					response.getWriter().print(jsonObject.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			 else if (param.equalsIgnoreCase("getRestrictiveHoursTripDetails")) {
				 String date=request.getParameter("date");	
				 String jspName=request.getParameter("jspName");
				 custName=request.getParameter("custName");	
				 String dateArray[]=date.split("T");
				 String dt=dateArray[0];
				 String oldFormat = "yyyy-MM-dd";
				 String newFormat = "dd-MM-yyyy";
				 SimpleDateFormat sdf = new SimpleDateFormat(oldFormat);
				 Date ds = sdf.parse(dt);
				 sdf.applyPattern(newFormat);
				String newDate = sdf.format(ds);
				 
				 try {
						jsonArray = new JSONArray();
						jsonObject = new JSONObject();
						
							ArrayList list = (ArrayList) ironfunc.getRestrictiveHoursTripDetails(date,systemId,clientId,offset);
							jsonArray = (JSONArray) list.get(0);
							if (jsonArray.length() > 0) {
								jsonObject.put("RestrictiveHoursTripDetailsRoot", jsonArray);
							} else {
								jsonObject.put("RestrictiveHoursTripDetailsRoot", "");
							}
		                    ReportHelper reportHelper = (ReportHelper) list.get(1);
							request.getSession().setAttribute(jspName, reportHelper);
							request.getSession().setAttribute("custName", custName);
							request.getSession().setAttribute("date", newDate);
							response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
		
		}
	  return null;
	}
}
