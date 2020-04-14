package t4u.ironMining;

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
import t4u.functions.IronMiningFunction;

public class MiningTareWeightMasterAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		//int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String message="";
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		//---------------------------------------------------------------------------------------------//
		if (param.equalsIgnoreCase("getMiningTareWeightDetails")) {
			try {
				ArrayList list=null;
				String CustomerId = request.getParameter("CustID");
				String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
				String ButtonValue=request.getParameter("buttonValue");
				String Assetnumber=request.getParameter("Assetnumber");
				String startdate=request.getParameter("startdate");
				String enddate=request.getParameter("enddate");
			//System.out.println("CustomerId:"+CustomerId+"jspName:"+jspName);
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list =ironfunc.getTareWeightDetails(customerName,systemId, Integer.parseInt(CustomerId),Assetnumber,ButtonValue,startdate,enddate,userId,lang);
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("miningTareWeightDetailsRoot", jsonArray);
					} else {
						jsonObject.put("miningTareWeightDetailsRoot", "");
					}
					//reportHelper = (ReportHelper) list.get(1);
					//request.getSession().setAttribute(jspName,reportHelper);
					//request.getSession().setAttribute("custId", customerName);
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("miningTareWeightDetailsRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	
//-----------------------------------------SAVE OR MODIFY TARE WEIGHT---------------------//		
		else if (param.equalsIgnoreCase("saveormodifyTareWeight")) {
			try {
				String buttonValue=request.getParameter("buttonValue");
				String CustomerId = request.getParameter("CustID");
				String type=request.getParameter("type");
				String AssetNo=request.getParameter("vehicleNo");
				String tareWeight=request.getParameter("tareWeight");
				String quantity=request.getParameter("quantity");
				String weightDateTime=request.getParameter("weightDateTime");
				String uniqueId=request.getParameter("uniqueId");
				String CustName=request.getParameter("CustName");	
				message = "";
				if (buttonValue.equals("add")) {

					if (CustomerId != null || AssetNo != null
							|| tareWeight != null || quantity != null
							||  weightDateTime!= null ) {
						message = ironfunc.saveTareWeightDetailsInformation(Integer.parseInt(CustomerId),type,AssetNo,tareWeight,quantity,weightDateTime,userId,systemId,CustName);
					}

				} else if (buttonValue.equals("modify")) {

					if (CustomerId != null || AssetNo != null
							|| tareWeight != null || quantity != null || weightDateTime != null ) {
						message = ironfunc.modifyTareWeightDetailsInformation(
								Integer.parseInt(CustomerId),type,AssetNo,tareWeight,quantity,weightDateTime,userId,systemId,uniqueId);
					}
				}
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Mining Tare Weight Action:-saveORmodifyDetails"+e.toString());
			}

		}	
		
		if (param.equalsIgnoreCase("getVehicleList")) {
			String ClientId = request.getParameter("CustId");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getVehicleNoListForTareWeight(ClientId, systemId);
					if (jsonarray.length() > 0) {
						jsonObject.put("vehicleComboStoreRoot", jsonarray);
					} else {
						jsonObject.put("vehicleComboStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
		else if (param.equalsIgnoreCase("getRFID")) {
			String ClientId = request.getParameter("CustID");
			String rfidValue=request.getParameter("RFIDValue");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					String ip = request.getRemoteAddr();
					jsonarray = ironfunc.getRFIDForTareWeight(ClientId, systemId,rfidValue);
					String VehicleNo=(String) jsonarray.getJSONObject(0).get("jsonString");
					if (jsonarray.length() > 0) {
						jsonObject.put("vno",VehicleNo);
					} else {
						jsonObject.put("vno", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
		return null;
	}
	
	
}
