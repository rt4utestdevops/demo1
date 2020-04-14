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


public class PromoCodeManagementAction extends Action {
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

		//************************************ Promo Code Management********************************//
		 if (param.equalsIgnoreCase("getAssetModel")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String CustId=request.getParameter("CustId");
				if (CustId != null && !CustId.equals("")) {
					jsonArray = sdf.getAssetModelList(systemId, userId, Integer.parseInt(CustId));
					if (jsonArray.length() > 0) {
						jsonObject.put("assetModelRoot", jsonArray);
					} else {
						jsonObject.put("assetModelRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} 

		else if(param.equals("getPromocodeDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String CustId = request.getParameter("CustId");
				if (request.getParameter("CustId") != null && !request.getParameter("CustId").equals("")) {
					ArrayList < Object > list1= sdf.PromocodeDetails(Integer.parseInt(CustId),systemId,userId);
					jsonArray = (JSONArray) list1.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("getPromocodeDetails", jsonArray);
					} else {
						jsonObject.put("getPromocodeDetails", "");
					}
				}else
				{
					jsonObject.put("getPromocodeDetails", "");
				}
				response.getWriter().print(jsonObject.toString()); 

			} catch (Exception e) {
				e.printStackTrace();
			}

		}
		
		else if (param.equalsIgnoreCase("promoCodeDetailsAddModify")) {
		    try {
				        String  CustID = request.getParameter("CustID");
				        String  buttonValue = request.getParameter("buttonValue");
				        String  hub = request.getParameter("hub");
				        String  carModel  = request.getParameter("carModel");
				        String  promoCode = request.getParameter("promoCode");
				        String  discountRate = request.getParameter("discountRate");
				        String  startDate= request.getParameter("startDate");
				        String  endDate = request.getParameter("endDate");
				        String  minTripDuration = request.getParameter("minTripDuration");
				        String  frequency= request.getParameter("frequency");
		                String  status= request.getParameter("status");
			            String  id= request.getParameter("id");
		                String  carIdModify= request.getParameter("carIdModify");
			            String  hubIdModify= request.getParameter("hubIdModify");
			            
			            if(frequency != null && !frequency.equals("")){
			            	frequency=request.getParameter("frequency");
						}else{
							frequency="0";
						}
			            
			            if(minTripDuration != null && !minTripDuration.equals("")){
			            	minTripDuration=request.getParameter("minTripDuration");
						}else{
							minTripDuration="0";
						}
			           
			            String message="";
			            if (buttonValue.equals("Add") && CustID != null && !CustID.equals("")) {
			                message = sdf.insertPromoCodeDetails(promoCode,Integer.parseInt(discountRate),startDate,endDate,hub,carModel,Integer.parseInt(minTripDuration),frequency,Integer.parseInt(CustID),systemId,userId);
			            }else if (buttonValue.equals("Modify")&& CustID != null && !CustID.equals("")) {
							message = sdf.updatePromoCodeDetails(Integer.parseInt(id),promoCode,Integer.parseInt(discountRate),startDate,endDate,hubIdModify,carIdModify,Integer.parseInt(minTripDuration),frequency,Integer.parseInt(CustID),systemId,userId);
						} 
			            response.getWriter().print(message);
			        } catch (Exception e) {
			            e.printStackTrace();
			        }
			    }
		return null;
	}
}
