package t4u.GeneralVertical;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

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
import t4u.functions.TemperatureReportFunction;
import t4u.util.TemperatureConfiguration;
import t4u.util.TemperatureConfigurationBean;

public class TemperatureReportAction  extends Action{

	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			if(loginInfo != null){
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
			}
			String param = "";
			if(req.getParameter("param") != null){
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			TemperatureReportFunction gf = new TemperatureReportFunction();
		
			if(param.equals("getTempDetails")){
				try {
					JSONObject jsonObject = new JSONObject();
					String regNo = req.getParameter("vehicleNo");
					String startdate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("startdate")));
					String enddate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("enddate")));					
					String category = req.getParameter("category");
					category = category.replaceAll(",$", "");
					obj = new JSONObject();
					jArr = gf.getTempDetails(systemId,clientId,offset,userId,startdate,enddate,regNo,category);
					if (jArr.length() > 0) {
						jsonObject.put("tempRoot", jArr);
					} else {
						jsonObject.put("tempRoot", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getTemperatureReport")){
				try {
					JSONObject jsonObject = new JSONObject();
					String regNo = req.getParameter("vehicleNo");
					String startdate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("startdate")));
					String enddate = yyyyMMdd.format(ddmmyyyy.parse(req.getParameter("enddate")));
					obj = new JSONObject();
					jArr = gf.getTemperatureReport(systemId,clientId,offset,userId,startdate,enddate,regNo);
					if (jArr.length() > 0) {
						jsonObject.put("tempReportRoot", jArr);
					} else {
						jsonObject.put("tempReportRoot", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getTrip")){
				try {
					JSONObject jsonObject = new JSONObject();
					obj = new JSONObject();
					jArr = gf.getTrip(systemId,clientId,offset,userId);
					if (jArr.length() > 0) {
						jsonObject.put("tripNames", jArr);
					} else {
						jsonObject.put("tripNames", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getVehicles")){
				try {
					JSONObject jsonObject = new JSONObject();
					obj = new JSONObject();
					jArr = gf.getVehicles(systemId,clientId,offset,userId);
					if (jArr.length() > 0) {
						jsonObject.put("vehicleDetails", jArr);
					} else {
						jsonObject.put("vehicleDetails", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getTripData")){
				try {
					JSONObject jsonObject = new JSONObject();
					String tripId=req.getParameter("tripId");
					obj = new JSONObject();
					jArr = gf.getTripData(offset,Integer.parseInt(tripId),clientId);
					if (jArr.length() > 0) {
						jsonObject.put("tripData", jArr);
					} else {
						jsonObject.put("tripData", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getTempConfigurations")) {
				String regNo = req.getParameter("regNo");
				try {
					List<TemperatureConfigurationBean> tempConfigDetails = TemperatureConfiguration.getTemperatureConfigurationDetails(systemId,clientId, regNo);
					obj = new JSONObject();
					List<String> headerArray = new ArrayList<String>();
					List<String> hArray = new ArrayList<String>();

					for (TemperatureConfigurationBean aTempConfigDetails : tempConfigDetails) {
						headerArray.add(aTempConfigDetails.getName());
						hArray.add(aTempConfigDetails.getSensorName());
					}
					jArr.put(headerArray);
					jArr.put(hArray);
					if (jArr.length() > 0) {
						obj.put("tempConfigDetails", jArr);
					} else {
						obj.put("tempConfigDetails", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getTrip")){
				try {
					JSONObject jsonObject = new JSONObject();
					obj = new JSONObject();
					jArr = gf.getTrip(systemId,clientId,offset,userId);
					if (jArr.length() > 0) {
						jsonObject.put("tripNames", jArr);
					} else {
						jsonObject.put("tripNames", "");
					}
					resp.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
	  }
		catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}

}
