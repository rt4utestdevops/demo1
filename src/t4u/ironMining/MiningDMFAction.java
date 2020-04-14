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
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.IronMiningFunction;

public class MiningDMFAction extends Action{
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String message="";
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getDMFfieldValues")) {
			try {
				ArrayList list=null;
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				list =ironfunc.getDMFfieldValues(systemId,userId);
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("dmfRoot", jsonArray);
				} else {
					jsonObject.put("dmfRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getDMFAmount")){
			try {
				jsonObject = new JSONObject();
				jsonArray = ironfunc.getDMFAmount(systemId, userId, customerId);
				if (jsonArray.length() > 0) {
					jsonObject.put("dmfAmtRoot", jsonArray);
				} else {
					jsonObject.put("dmfAmtRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getMonthValidation")){
			try {
				jsonObject = new JSONObject();
				jsonArray = new JSONArray();
				String date = request.getParameter("year");
				jsonArray = ironfunc.getDMFMonth(systemId, userId, customerId,date);
				if (jsonArray.length() > 0) {
					jsonObject.put("dmfValidRoot", jsonArray);
				} else {
					jsonObject.put("dmfValidRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getDMFDetails")) {
			try {
				ArrayList list=null;
				String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
				String endDate=request.getParameter("endDate");
				String startDate = request.getParameter("startDate");
				SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat ddMMyyyy = new SimpleDateFormat("dd-MM-yyyy");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				list =ironfunc.getDMFDetails(customerId,systemId,startDate,endDate);
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("DMFMasterRoot", jsonArray);
				} else {
					jsonObject.put("DMFMasterRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
                request.getSession().setAttribute("custId", customerName);
                request.getSession().setAttribute("startDate", ddMMyyyy.format(yyyymmdd.parse(startDate)));
                request.getSession().setAttribute("endDate", ddMMyyyy.format(yyyymmdd.parse(endDate)));
				response.getWriter().print(jsonObject.toString());
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
		//**************addOrModify*****************
		else if (param.equalsIgnoreCase("saveDMFDetails")) {
		     try {
		    	  
		    	 String date = request.getParameter("date");
		    	 String Tnorthdmf = request.getParameter("northdmf");
		    	 String Tsouthdmf = request.getParameter("southdmf");
		    	 String totaldmf = request.getParameter("totaldmf");
		    	 String json = request.getParameter("json");
	        	 JSONArray js = null;
		         if(json!=null){
		        	 String st = "["+json+"]";
						try
						{
							js = new JSONArray(st.toString());
						}
						catch (JSONException e)
					    {
							e.printStackTrace();
						}
		         }
		         message = ironfunc.saveDMFDetails(systemId,customerId,js,date,userId,Tnorthdmf,Tsouthdmf,totaldmf);
		         response.getWriter().print(message);
	         } catch (Exception e) {
	        	 System.out.println("error in dmf Details "+e.toString());
	            e.printStackTrace();
	         }
		  }
		return null;
}
}
