package t4u.school;

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
import t4u.functions.SchoolFunctions;


public class SendSchoolSmsAction extends Action{


	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {

		String param = "";
		String message="";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int userId = loginInfo.getUserId();
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		SchoolFunctions SendschoolSms=new SchoolFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getSchoolTypeDetails")) {
			try {
				String customerId = request.getParameter("CustId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (customerId != null && !customerId.equals("")) {
					ArrayList <Object> list1 = SendschoolSms.getSchoolType(systemId, Integer.parseInt(customerId));
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("sendSchoolSmsRoot", jsonArray);
					} else {
						jsonObject.put("sendSchoolSmsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getRouteDetails")) {
			try {
				String customerId = request.getParameter("CustId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (customerId != null && !customerId.equals("")) {
					ArrayList < Object > rlist = SendschoolSms.getRouteDetails(systemId, Integer.parseInt(customerId));
					jsonArray = (JSONArray) rlist.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("sendSchoolSmsRouteRoot", jsonArray);
					} else {
						jsonObject.put("sendSchoolSmsRouteRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getCountryList")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = SendschoolSms.getCountryList();
				if (jsonArray.length() > 0) {
					jsonObject.put("CountryRoot", jsonArray);
				} else {
					jsonObject.put("CountryRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getSMSCount")){
			try {
				String customerId=request.getParameter("CustId");
				jsonObject = new JSONObject();
				if (customerId != null && !customerId.equals("")) {
					jsonArray = SendschoolSms.getSmsSizeCount(systemId,Integer.parseInt(customerId));
					if (jsonArray.length() > 0) {
						jsonObject.put("SMSCountRoot", jsonArray);
					} else {
						jsonObject.put("SMSCountRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getStudentCount")){
			try {
				String customerId=request.getParameter("CustId");
				String firstjsondata = request.getParameter("FristGridValues");
				String secondjsondata = request.getParameter("SecondGridValues");
				String manualphNo=request.getParameter("manualphNo");
				String isdCode = request.getParameter("isdCode");

				//System.out.println("isdCode"+isdCode);
				//System.out.println("manualphNo---->"+manualphNo);

				//System.out.println("firstjsondata-->"+firstjsondata);
				//System.out.println("secondjsondata-->"+secondjsondata);
				jsonObject = new JSONObject();
				JSONArray firstGridData;
				JSONArray secondGridData;
				if (customerId != null && !customerId.equals("") && firstjsondata != null && !firstjsondata.equals("")&& secondjsondata != null && !secondjsondata.equals("")) {
					String st = "[" + firstjsondata + "]";                    
					String ft = "[" + secondjsondata + "]"; 
					firstGridData = new JSONArray(st.toString());
					secondGridData= new JSONArray(ft.toString());
					String[] mobileArray1 = manualphNo.split(",");
					jsonArray = SendschoolSms.getStudentSizeCount(firstGridData,secondGridData,mobileArray1,systemId,Integer.parseInt(customerId),isdCode);
					if (jsonArray.length() > 0) {
						response.getWriter().print(jsonArray);
					} else {
						jsonArray.put(0);
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("SubmitDetails")){
			String firstjsondata = request.getParameter("FristGridValues");
			String secondjsondata = request.getParameter("SecondGridValues");
			String MessageText = request.getParameter("MessageText");
			String ManualPhoneNO = request.getParameter("ManualphNo");
			String customerId = request.getParameter("custId");		
			String isdCode = request.getParameter("isdCode");

			//System.out.println("ManualPhoneNO"+ManualPhoneNO);

			//mobno = new ArrayList<String>(Arrays.asList(ManualPhoneNO.split("\\s*,\\s*")));
			String[] mobileArray = ManualPhoneNO.split(",");
			JSONArray firstGridData;
			JSONArray secondGridData;
			try {
				if (firstjsondata !=null && !firstjsondata.equals("") && secondjsondata !=null && !secondjsondata.equals("")) {
					String st = "[" + firstjsondata + "]";                    
					String ft = "[" + secondjsondata + "]"; 
					firstGridData = new JSONArray(st.toString());
					secondGridData= new JSONArray(ft.toString()); 
					message=SendschoolSms.submitDetails(firstGridData,secondGridData,MessageText,mobileArray,systemId,Integer.parseInt(customerId),isdCode);
					response.getWriter().print(message);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}	    
}
