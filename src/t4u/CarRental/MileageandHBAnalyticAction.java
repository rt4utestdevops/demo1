package t4u.CarRental;

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
import t4u.functions.MileageandHBAnalysisFunctions;

public class MileageandHBAnalyticAction extends Action {
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
			int clientId = loginInfo.getCustomerId();
			int offset = loginInfo.getOffsetMinutes();
			String param = "";
			if(req.getParameter("param") != null){
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			MileageandHBAnalysisFunctions hbfunc = new MileageandHBAnalysisFunctions();
			
			if(param.equals("getHBDetilsforGraph")){
				String startDate = req.getParameter("startDate");
				String endDate = req.getParameter("endDate");
				int cityId = 0;
				if(req.getParameter("cityId") != null && !req.getParameter("cityId").equals("")){
					cityId = Integer.parseInt(req.getParameter("cityId"));
				}
				try{
					obj = new JSONObject();
					if(startDate != null && !startDate.equals("") && endDate != null && !endDate.equals("")){
						jArr = hbfunc.getHBAnalysisForGraph(systemId,clientId,startDate,endDate,offset,cityId);
						if(jArr.length() > 0){
							obj.put("HBAnalysisRoot", jArr);
						}else{
							obj.put("HBAnalysisRoot", "");
						}
					}else{
						obj.put("HBAnalysisRoot", "");
					}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}	
			else if(param.equalsIgnoreCase("getModelWiseMileage")){
				JSONObject jsonobject = new JSONObject();
				JSONArray jsonArray = new JSONArray();
				jsonArray=hbfunc.getDayWiseMileage();
				if(jsonArray.length()>0){
					jsonobject.put("getModelWiseMileage", jsonArray);
				}else{
					jsonobject.put("getModelWiseMileage", "");
				}
				resp.getWriter().print(jsonobject);
			}else if(param.equals("getGroupNames")){
				try{
					obj = new JSONObject();
					jArr = hbfunc.getGroupNameList(systemId,clientId);
					resp.getWriter().println(jArr.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			
			else if(param.equalsIgnoreCase("getVechileWiseMileage")){
				JSONObject jsonobject = new JSONObject();
				JSONArray jsonArray = new JSONArray();
				String city =  req.getParameter("City");
				String modelName =  req.getParameter("ModelName");
				jsonArray=hbfunc.getVechileWiseMileage(city,modelName,systemId,clientId);
				if(jsonArray.length()>0){
					jsonobject.put("VechileWiseMileage", jsonArray);
				}else{
					jsonobject.put("VechileWiseMileage", "");
				}
				resp.getWriter().print(jsonobject.toString());
			}
			
			else if(param.equalsIgnoreCase("getVehicleRefuelData")){
				JSONObject jsonobject = new JSONObject();
				JSONArray jsonArray = new JSONArray();
				//String vehicleNo = req.getParameter("vehicleNo");
				
				String vehicleNo =  req.getParameter("vehicleNo");
				jsonArray=hbfunc.getVehicleFuelSummary(vehicleNo,systemId,clientId);
				if(jsonArray.length()>0){
					jsonobject.put("VehicleRefuelData", jsonArray);
				}else{
					jsonobject.put("VehicleRefuelData", "");
				}
				resp.getWriter().print(jsonobject.toString());
			}
			else if(param.equalsIgnoreCase("getCityWiseAvgMileage")){
				JSONObject jsonobject = new JSONObject();
				JSONArray jsonArray = new JSONArray();
				jsonArray=hbfunc.getCityWiseAvgMileage(systemId,clientId);
				if(jsonArray.length()>0){
					jsonobject.put("CityWiseAvgMileage", jsonArray);
				}else{
					jsonobject.put("CityWiseAvgMileage", "");
				}
				resp.getWriter().print(jsonobject.toString());
			}
			/*added on 10-10-2017*/
			 else if(param.equalsIgnoreCase("getcountHb")){
					JSONObject jsonobject = new JSONObject();
					JSONArray jsonArray = new JSONArray();
					//String vehicleNo =  req.getParameter("vehicleNo");
					String startDate = req.getParameter("startDate");
					String endDate = req.getParameter("endDate");
					int cityId = 0;
					if(req.getParameter("cityId") != null && !req.getParameter("cityId").equals("")){
						cityId = Integer.parseInt(req.getParameter("cityId"));
					}
					if(startDate != null && !startDate.equals("") && endDate != null && !endDate.equals("")){
						jsonArray=hbfunc.getHbCountReport(systemId,clientId, offset, cityId,startDate,endDate);
						if(jsonArray.length()>0){
							jsonobject.put("hbCountReport", jsonArray);
						}else{
							jsonobject.put("hbCountReport", "");
						}
					}else{
						jsonobject.put("hbCountReport", "");
					}
					
					resp.getWriter().print(jsonobject.toString());
				}
			
				else if(param.equalsIgnoreCase("getHBpoints")){
					JSONObject jsonobject = new JSONObject();
					JSONArray jsonArray = new JSONArray();
					jsonArray=hbfunc.getHarshBrakHeatMapLatLng(systemId,clientId);
					if(jsonArray.length()>0){
						jsonobject.put("getHBpointsData", jsonArray);
					}else{
						jsonobject.put("getHBpointsData", "");
					}
					resp.getWriter().print(jsonobject.toString());
				}
			
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return null;
	}
}
