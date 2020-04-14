package t4u.SelfDrive;

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
import t4u.functions.SelfDriveFunctions;

public class HubMaintenanceAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		SelfDriveFunctions sdf = new SelfDriveFunctions();
		CommonFunctions cf = new CommonFunctions();
		int offset=0;
		int systemId = loginInfo.getSystemId();
		String lang = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();
		offset=loginInfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equalsIgnoreCase("gethubNames")) {
			try {
				String CustId=request.getParameter("CustId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustId != null && !CustId.equals("")) {
					jsonArray = sdf.getHUbList(systemId,Integer.parseInt(CustId));
					if (jsonArray.length() > 0) {
						jsonObject.put("gethubNames", jsonArray);
					} else {
						jsonObject.put("gethubNames", "");
					}
					response.getWriter().print(jsonObject.toString());
				}else{
					jsonObject.put("gethubNames", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	
		else if (param.equalsIgnoreCase("getVehicleNo")) {
			try {
				String CustId=request.getParameter("CustId");
				String hubId=request.getParameter("hubId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustId != null && !CustId.equals("") && hubId != null && !hubId.equals("")) {
					jsonArray = sdf.getVehicleNo(systemId,Integer.parseInt(hubId),Integer.parseInt(CustId));
					if (jsonArray.length() > 0) {
						jsonObject.put("VehicleNo", jsonArray);
					} else {
						jsonObject.put("VehicleNo", "");
					}
					response.getWriter().print(jsonObject.toString());
				}else{
					jsonObject.put("VehicleNo", "");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("hubExpenseMasterAddModify")) {
			try {
				String CustId= request.getParameter("CustID");
				String buttonValue = request.getParameter("buttonValue");
				String hubId = request.getParameter("hubId");
				String vehicleNo= request.getParameter("vehicleNo");
				String comments = request.getParameter("comments");
				String id = request.getParameter("id");
				String  keyLost= request.getParameter("keyLost");
				String  carDent= request.getParameter("carDent");
				String  carScrathch= request.getParameter("carScrathch");
				String  towing= request.getParameter("towing");
				String  carPuncture= request.getParameter("carPuncture");
				String  refuel= request.getParameter("refuel");
				String  localConveyance= request.getParameter("localConveyance");
				String  carWashing= request.getParameter("carWashing");
				String  other= request.getParameter("other");
				String  hubIdModify= request.getParameter("hubIdModify");
				float keylost = 0;
				float cardent=0;
				float carscratch=0;
				float tow=0;
				float carpuncture=0;
				float refuel1=0;
				float localconveyance=0;
				float carwashing=0;
				float others=0;
				float emptyValue=0;


				if(keyLost != null && !keyLost.equals("")){
					keylost=Float.parseFloat(keyLost);
				}else{
					keylost=emptyValue;
				}

				if(carDent != null && !carDent.equals("")){
					cardent=Float.parseFloat(carDent);
				}else{
					cardent=emptyValue;
				}

				if(carScrathch != null && !carScrathch.equals("")){
					carscratch=Float.parseFloat(carScrathch);
				}else{
					carscratch=emptyValue;
				}

				if(towing != null && !towing.equals("")){
					tow=Float.parseFloat(towing);
				}else{
					tow=emptyValue;
				}

				if(carPuncture != null && !carPuncture.equals("")){
					carpuncture=Float.parseFloat(carPuncture);
				}else{
					carpuncture=emptyValue;
				}

				if(refuel != null && !refuel.equals("")){
					refuel1=Float.parseFloat(refuel);
				}else{
					refuel1=emptyValue;
				}

				if(localConveyance != null && !localConveyance.equals("")){
					localconveyance=Float.parseFloat(localConveyance);
				}else{
					localconveyance=emptyValue;
				}

				if(carWashing != null && !carWashing.equals("")){
					carwashing=Float.parseFloat(carWashing);
				}else{
					carwashing=emptyValue;
				}

				if(other != null && !other.equals("")){
					others=Float.parseFloat(other);
				}else{
					others=emptyValue;
				}

				String message = "";
				if (buttonValue.equals("Add") && CustId != null && !CustId.equals("")) {
					message = sdf.insertHubExpenseInformation(Integer.parseInt(hubId),vehicleNo,comments,
							keylost,cardent,carscratch,tow,carpuncture,refuel1,localconveyance,carwashing,others,
							Integer.parseInt(CustId),systemId,userId);
				} 
				else if (buttonValue.equals("Modify")&& CustId != null && !CustId.equals("")) {
					message = sdf.modifyHubExpenseInformation(Integer.parseInt(id),Integer.parseInt(hubIdModify),vehicleNo,comments,
							keylost,cardent,carscratch,tow,carpuncture,refuel1,localconveyance,carwashing,others,
							Integer.parseInt(CustId),systemId,userId);
				} 
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}


		else if(param.equals("getHubExpenseDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String custName=request.getParameter("custName");
				String customerId = request.getParameter("CustId");
				String jspName=request.getParameter("jspName");
				String startDate=request.getParameter("startDate");
				String endDate=request.getParameter("endDate");
				String HubId=request.getParameter("HubId");
				String HubName=request.getParameter("HubName");
				if (request.getParameter("CustId") != null && !request.getParameter("CustId").equals("")) {

					ArrayList < Object > list1= sdf.getHubExpenseDetails(Integer.parseInt(customerId),Integer.parseInt(HubId),startDate,endDate,systemId,lang,offset);
					jsonArray = (JSONArray) list1.get(0);

					if (jsonArray.length() > 0) {
						jsonObject.put("getHubExpenseDetails", jsonArray);
					} else {
						jsonObject.put("getHubExpenseDetails", "");
					}
					ReportHelper reportHelper = (ReportHelper) list1.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("customerId", custName);
					request.getSession().setAttribute("HubName", HubName);
					request.getSession().setAttribute("startDate", cf.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
					request.getSession().setAttribute("endDate", cf.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
				}else
				{
					jsonObject.put("getHubExpenseDetails", "");
				}
				response.getWriter().print(jsonObject.toString()); 

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
