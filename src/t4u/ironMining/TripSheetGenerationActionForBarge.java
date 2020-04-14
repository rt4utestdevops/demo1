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
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class TripSheetGenerationActionForBarge extends Action{
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		//int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String message="";
		String param = "";
		SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddMMyyyy = new SimpleDateFormat("dd-MM-yyyy");
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if (param.equalsIgnoreCase("getVehicleList")) {
			String ClientId = request.getParameter("CustId");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getBargeNoList(ClientId, systemId,userId);
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
		
	   if (param.equalsIgnoreCase("saveormodifyGenrateTripSheetForBarge")) {
			try {
				String buttonValue=request.getParameter("buttonValue");
				String CustomerId = request.getParameter("CustID");
				String type=request.getParameter("type");
				String AssetNo=request.getParameter("vehicleNo");
				String bargeCapacity=request.getParameter("bargeCapacity");
				String validityDateTime=request.getParameter("validityDateTime");
				String uniqueId=request.getParameter("uniqueId");
				String CustName=request.getParameter("CustName");
				String bargeQuantity= request.getParameter("bargeQuantity");
				String userSettingId = request.getParameter("userSettingId");
				String vesselName = request.getParameter("vesselName");
				String destination = request.getParameter("destination");
				String boatNote = request.getParameter("boatNote");
				String reason = request.getParameter("reason");
				String status =request.getParameter("status");
				String flag =request.getParameter("flag");
				float modBargeQty=request.getParameter("modBargeQty")!=null&&!request.getParameter("modBargeQty").equals("")?Float.parseFloat(request.getParameter("modBargeQty")):0;
				String bargeLocId ="0";
				String orgId="0";
				String tripSheetType="";
				String divQty="0";
				String tripSheetNo=""; 
				if(request.getParameter("tripSheetType")!=null && !request.getParameter("tripSheetType").equals("")){
					tripSheetType=request.getParameter("tripSheetType");
				}
				if(request.getParameter("orgId")!=null && !request.getParameter("orgId").equals("")){
					orgId=request.getParameter("orgId");
				}
				if(request.getParameter("bargeLocId")!=null && !request.getParameter("bargeLocId").equals("")){
					bargeLocId=request.getParameter("bargeLocId");
				}
				if(request.getParameter("divQty")!=null && !request.getParameter("divQty").equals("")){
					divQty=request.getParameter("divQty");
				}
				if(request.getParameter("tripSheetNo")!=null && !request.getParameter("tripSheetNo").equals("")){
					tripSheetNo=request.getParameter("tripSheetNo");
					String []arr=tripSheetNo.split("-");
					tripSheetNo=arr[0]!=null?arr[0]:tripSheetNo;
				}
				message = "";
				if (buttonValue.equals("add")) {

					if (CustomerId != null || AssetNo != null ||
							bargeCapacity != null ) {
						message = ironfunc.saveTripSheetDetailsInformationForBarge(Integer.parseInt(CustomerId),type,AssetNo,bargeCapacity,bargeQuantity,validityDateTime,
								userId,systemId,CustName,Integer.parseInt(userSettingId),tripSheetType,Integer.parseInt(orgId),Integer.parseInt(bargeLocId));
					}

				} 
				else if (buttonValue.equals("modify")) {

					if (CustomerId != null){
						message = ironfunc.modifyBargeDetails(validityDateTime,vesselName,destination,boatNote,reason,Integer.parseInt(uniqueId),Integer.parseInt(CustomerId),systemId,status,flag,Float.parseFloat(divQty),modBargeQty,tripSheetNo,userId);
					}
				}
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Mining Trip Generation Action:-saveORmodifyDetails"+e.toString());
			}

		}	
	   
	   else if (param.equalsIgnoreCase("getMiningTripSheetDetails")) {
			try {
				ArrayList list=null;
				String CustomerId = request.getParameter("CustID");
				String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
				String fromDate=request.getParameter("startDate");
				fromDate = fromDate.replace('T', ' ');
				
				String endDate=request.getParameter("endDate");
				endDate=endDate.replace('T', ' ');
			//System.out.println("CustomerId:"+CustomerId+"jspName:"+jspName);
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list =ironfunc.getTripSheetDetailsForBarge(systemId, Integer.parseInt(CustomerId),userId,lang,fromDate,endDate);
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("miningTripSheetDetailsRoot", jsonArray);
					} else {
						jsonObject.put("miningTripSheetDetailsRoot", "");
					}
					reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName,reportHelper);
					request.getSession().setAttribute("jspPageName","Mining Trip Sheet Generation For Barge");
					request.getSession().setAttribute("custId", customerName);
					request.getSession().setAttribute("startdate",ddMMyyyy.format(yyyyMMddHHmmss.parse(fromDate)));
					request.getSession().setAttribute("enddate", ddMMyyyy.format(yyyyMMddHHmmss.parse(endDate)));
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("miningTripSheetDetailsRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	   
		else if (param.equalsIgnoreCase("closeTrip")) {
			try {
				
				String CustomerId = request.getParameter("CustID");
				String assetNo=request.getParameter("assetNo");
				String tripSheetNo=request.getParameter("tripSheetNo");
				message = "";
				
					if (CustomerId != null || assetNo != null){
						message = ironfunc.closeTripForBarge(Integer.parseInt(CustomerId),assetNo,tripSheetNo,userId,systemId);
					}
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Mining Trip Generation Action:-saveORmodifyDetails"+e.toString());
			}
		}	
		// ****************************** GET VEHICLE NO*****************************

		else if (param.equalsIgnoreCase("getVehicleListForBarge")) {
			String ClientId = request.getParameter("CustId");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getVehicleListForBarge(ClientId, systemId);
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
					jsonarray = ironfunc.getRFIDForBarge(ClientId, systemId,rfidValue,userId);
					if (jsonarray.length() > 0) {
						jsonObject.put("tripRoot",jsonarray);
					} else {
						jsonObject.put("tripRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
	   
		else if (param.equalsIgnoreCase("stopblo")) {
			try {
				
				String CustomerId = request.getParameter("CustID");
				String assetNo=request.getParameter("assetNo");
				String tripSheetNo=request.getParameter("tripSheetNo");
				message = "";
				
					if (CustomerId != null || assetNo != null){
						message = ironfunc.stopBloForBarge(Integer.parseInt(CustomerId),assetNo,tripSheetNo,userId,systemId);
					}
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Mining Trip Generation Action:-stopBlo"+e.toString());
			}
		}
	   
		else if (param.equalsIgnoreCase("cancelTrip")) {
			try {
				String remark = request.getParameter("remark");
				String reason = request.getParameter("reason");
				String CustomerId = request.getParameter("custId");
				int uniqueId = Integer.parseInt(request.getParameter("uniqueNo"));
				message = "";
				
					if (CustomerId != null ){
						message = ironfunc.cancelTripOfBarge(Integer.parseInt(CustomerId),uniqueId,systemId,reason,remark);
					}
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Mining Trip Generation Action:-cancelTrip"+e.toString());
			}
		}	

		   else if (param.equalsIgnoreCase("getTrainTripSheetDetails")) {
				try {
					ArrayList list=null;
					String CustomerId = request.getParameter("CustID");
					String jspName=request.getParameter("jspName");
					String customerName=request.getParameter("CustName");
					String fromDate=request.getParameter("startDate");
					fromDate = fromDate.replace('T', ' ');
					
					String endDate=request.getParameter("endDate");
					endDate=endDate.replace('T', ' ');
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					if (CustomerId != null && !CustomerId.equals("")) {
						list =ironfunc.getTrainTripSheetDetails(systemId, Integer.parseInt(CustomerId),userId,lang,fromDate,endDate);
						jsonArray = (JSONArray) list.get(0);
						if (jsonArray.length() > 0) {
							jsonObject.put("trainTripSheetDetailsRoot", jsonArray);
						} else {
							jsonObject.put("trainTripSheetDetailsRoot", "");
						}
						reportHelper = (ReportHelper) list.get(1);
						request.getSession().setAttribute(jspName,reportHelper);
						request.getSession().setAttribute("jspPageName","Mining Trip Sheet Generation For Train");
						request.getSession().setAttribute("custId", customerName);
						request.getSession().setAttribute("startdate",ddMMyyyy.format(yyyyMMddHHmmss.parse(fromDate)));
						request.getSession().setAttribute("enddate", ddMMyyyy.format(yyyyMMddHHmmss.parse(endDate)));
						response.getWriter().print(jsonObject.toString());
					} else {
						jsonObject.put("trainTripSheetDetailsRoot", "");
						response.getWriter().print(jsonObject.toString());
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		   else if (param.equalsIgnoreCase("getOrgNameForBarge")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getOrgNameForBarge(userId,systemId);
					if (jsonarray.length() > 0) {
						jsonObject.put("orgRoot",jsonarray);
					} else {
						jsonObject.put("orgRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equalsIgnoreCase("getBargeStatus")) {
				//String ClientId = request.getParameter("CustID");
				//if (ClientId != null && !ClientId.equals("")) {
					JSONArray jsonarray = null;
					jsonObject = new JSONObject();
					try {
						jsonarray = ironfunc.getBargeStatus(customerId, systemId,userId);
						if (jsonarray.length() > 0) {
							jsonObject.put("bargeroot",jsonarray);
						} else {
							jsonObject.put("bargeroot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
			}
			else if (param.equalsIgnoreCase("getBargeStatus1")) {
					JSONArray jsonarray = null;
					jsonObject = new JSONObject();
					String bargeNo=request.getParameter("bargeNo");
					try {
						jsonarray = ironfunc.getBargeStatus1(customerId, systemId,bargeNo);
						if (jsonarray.length() > 0) {
							jsonObject.put("bargeroot1",jsonarray);
						} else {
							jsonObject.put("bargeroot1", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
			}
		return null;
	}
}
