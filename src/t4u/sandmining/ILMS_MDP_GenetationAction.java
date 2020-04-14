package t4u.sandmining;

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
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.SandMiningPermitFunctions;

public class ILMS_MDP_GenetationAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		String message="";
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		AdminFunctions adfunc = new AdminFunctions();
		SandMiningPermitFunctions smpf = new SandMiningPermitFunctions();
		systemId = loginInfo.getSystemId();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		String ltspName = loginInfo.getSystemName();
		String userName = loginInfo.getUserName();
		CommonFunctions cf = new CommonFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		} 
		if (param.equals("getFromSandPortStore")) {
			 try{
					String clientId=request.getParameter("clientId");
					jsonObject =new JSONObject();
					jsonArray = smpf.getFromSandPort(systemId,clientId,userId);
					jsonObject.put("FromSandPortStoreList", jsonArray);
					response.getWriter().print(jsonObject.toString());	
				}
				catch(Exception e){
					e.printStackTrace();
				}
		}else if(param.equals("saveGRID"))
	    {
		 try {
			 String buttonValue=request.getParameter("buttonValue");
			 String custId= request.getParameter("custId");
			 String vehicleNoAdd = request.getParameter("vehicleNoAdd");
			 String permitNoAdd = request.getParameter("permitNoAdd");
			 String mdpNoAdd = request.getParameter("mdpNoAdd");
			 String fromPlaceAdd = request.getParameter("fromPlaceAdd");
			 String toPlaceAdd = request.getParameter("toPlaceAdd");
			 String validFromAdd = request.getParameter("validFromAdd");
			 String validToAdd = request.getParameter("validToAdd");
			 String distanceAdd = request.getParameter("distanceAdd");
			 String processingFeeAdd = request.getParameter("processingFeeAdd");
			 String printedAdd = request.getParameter("printedAdd");
			 String TSDateAdd = request.getParameter("TSDateAdd");
			 String groupIdAdd = request.getParameter("groupIdAdd");
			 String groupNameAdd = request.getParameter("groupNameAdd");
			 String uniqueId = request.getParameter("uniqueID");
			 String contactNoAdd = request.getParameter("contactNoAdd");
			 String customerNameOrAddressAdd = request.getParameter("customerNameOrAddressAdd");
			 String unloadWeight = request.getParameter("unloadWeight");
			 String loadWeight = request.getParameter("loadWeight");
			 String destLat = request.getParameter("destLat");
			 String destLng = request.getParameter("destLng");
			 String netWeight = request.getParameter("netWeight");
			 
			 //String transporterNameAdd = request.getParameter("transporterNameAdd");
			// String loadingTypeAdd = request.getParameter("loadingTypeAdd");
			// String surveyNoAdd = request.getParameter("surveyNoAdd");
			// String villageAdd = request.getParameter("villageAdd");
			// String talukAdd = request.getParameter("talukAdd");
			// String districtAdd = request.getParameter("districtAdd");
			// String quantityAdd = request.getParameter("quantityAdd");
			// String amountAdd = request.getParameter("amountAdd");
			// String totalFeeAdd = request.getParameter("totalFeeAdd");
			// String sandPortNoAdd = request.getParameter("sandPortNoAdd");
			// String sandPortUniqueIdAdd = request.getParameter("sandPortUniqueIdAdd");
			// String customerNameAdd =request.getParameter("customerNameAdd");
			// String driverNameAdd = request.getParameter("driverNameAdd");
			// String viaRouteAdd = request.getParameter("viaRouteAdd");
			// String mineralTypeAdd = request.getParameter("mineralTypeAdd");
            // String applicationNoAdd = request.getParameter("applicationNoAdd");
            // String validityPeriodAdd =request.getParameter("validityPeriodAdd");
			// String transporterAdd = request.getParameter("transporterAdd");
             //String MlNoModify = request.getParameter("custId");
			// String vehicleAddrAdd = request.getParameter("vehicleAddrAdd");
			// String DDNoAdd = request.getParameter("DDNoAdd");
			// String bankNameAdd = request.getParameter("bankNameAdd");
			// String DDDateAdd =request.getParameter("DDDateAdd");
			// String vehicleNoAdd = request.getParameter("vehicleNoAdd");
			// String SandLoadingFromTimeAdd = request.getParameter("SandLoadingFromTimeAdd");
            // String SandLoadingToTimeAdd = request.getParameter("SandLoadingToTimeAdd");
            // String sandExtraction=request.getParameter("sandExtraction");
             String fromstockyard=request.getParameter("fromstockyard");
             String fromstockyardId=request.getParameter("fromstockyardId");
             
			 String mineralTypeModify = request.getParameter("mineralTypeModify");
			 String uniqueIdModify = request.getParameter("uniqueIdModify");
			 String validityPeriodModify = request.getParameter("validityPeriodModify");
			 String transporterModify = request.getParameter("transporterModify");
			 //String MlNoModify = request.getParameter("MlNoModify");
			 String processingFeeModify = request.getParameter("processingFeeModify");
			 String vehicleAddrModify = request.getParameter("vehicleAddrModify");
			 String printedModify = request.getParameter("printedModify");
			 String TSDateModify = request.getParameter("TSDateModify");
			 String DDNoModify = request.getParameter("DDNoModify");
			 String bankNameModify = request.getParameter("bankNameModify");
			 String DDDateModify = request.getParameter("DDDateModify");
			 String groupIdModify = request.getParameter("groupIdModify");
			 String groupNameModify = request.getParameter("groupNameModify");
			 String vehicleNoModify = request.getParameter("vehicleNoModify");
			 String SandLoadingFromTimeModify = request.getParameter("SandLoadingFromTimeModify");
             String SandLoadingToTimeModify = request.getParameter("SandLoadingToTimeModify");
             String quantityModify = request.getParameter("quantityModify");
             String sandportUniqueidModify=request.getParameter("sandportUniqueidModify");
             String extractionTypeModify=request.getParameter("extractionTypeModify");
             String latitude=request.getParameter("latitude");
             String longitude=request.getParameter("longitude");
         
			 if(buttonValue.equals("Add"))
			    {
			    	message = smpf.insert_ILMS_MDP_GRID(uniqueId,mdpNoAdd,permitNoAdd,vehicleNoAdd,fromPlaceAdd,toPlaceAdd,validFromAdd,printedAdd,systemId,custId,offset,processingFeeAdd,validToAdd,TSDateAdd,userId,groupIdAdd,groupNameAdd,distanceAdd,contactNoAdd,customerNameOrAddressAdd,unloadWeight,loadWeight,destLat,destLng,netWeight);
			    }
			    
			 response.getWriter().print(message);
		 } catch(Exception e){
				e.printStackTrace();
		}
		   
	   }else if(param.equals("getPermitsNewGRID")){
			try{
				String clientId=request.getParameter("clientId");
				String sourceLat = request.getParameter("sourceLat");
				String sourceLng=request.getParameter("sourceLong");
				jsonObject =new JSONObject();
				jsonArray = smpf.getPermitNosForILMS(systemId,clientId,userId,offset,sourceLat,sourceLng);
				jsonObject.put("PermitstoreNewList", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}else if(param.equals("getVehicleWeight")){
			 try{
				 String permitNo=request.getParameter("permitNo");
				 jsonObject =new JSONObject();
				 jsonArray=smpf.getVehicleWeight(permitNo,systemId);
				 if(jsonArray.length() > 0){
					 jsonObject.put("velicleWeightStoreList", jsonArray);
				 }else{
					 jsonObject.put("velicleWeightStoreList", "");
				 }
				 response.getWriter().print(jsonObject.toString());
			 }catch(Exception e){
				 e.printStackTrace();
			 }
			 
		 }
		else if(param.equals("getMDPTripSheetTimings"))
		{
			try {
				String globalClientId = request.getParameter("clientId");
				
				if(globalClientId != null && !globalClientId.equals("")){		
				jsonArray = smpf.getMDPTimengs(systemId, Integer.parseInt(globalClientId) );
				}	
				jsonObject.put("MDPTripSheetTimingsRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
				}				
			catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equals("getUnrecordedWeighBridgeReport")) {
			String custId=request.getParameter("CustId");
			String CustName=request.getParameter("CustName");
        	String jspName=request.getParameter("jspName");
        	String startDate=request.getParameter("startDate").replaceAll("T"," ");
        	String endDate=request.getParameter("endDate");
        	endDate=endDate.substring(0, endDate.indexOf("T"))+" 23:59:59";
			try {
				jsonObject = new JSONObject();
				
				ArrayList<Object> weightDetails= smpf.getUnrecordedWeighBridgeReport(startDate,endDate,systemId,Integer.parseInt(custId),offset);
				jsonArray = (JSONArray) weightDetails.get(0);
				if (jsonArray.length() > 0){
					jsonObject.put("UnrecordedWeighBridgeRoot", jsonArray);
					ReportHelper reportHelper = (ReportHelper) weightDetails.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("custId", CustName);
			     	request.getSession().setAttribute("startDate", startDate);
			     	request.getSession().setAttribute("endDate", endDate);
				} else {
					jsonObject.put("UnrecordedWeighBridgeRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
		    }
		} 
	    else if(param.equals("getUnladenWeight")){
			try{
				String vehicleNo = request.getParameter("vehicleNo");
				jsonObject =new JSONObject();
				jsonArray = smpf.getUnladenWeight(systemId,userId,vehicleNo);
				jsonObject.put("UnladenList", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
	    else if(param.equals("getMDPCountForLocation4")){
			try{
				String vehicleNo = request.getParameter("vehicleNo");
				jsonObject =new JSONObject();
				jsonArray = smpf.getMDPCountForLocation4(systemId,userId,vehicleNo);
				jsonObject.put("MDPCountForLocationList", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
	    else if(param.equals("getMdpCountAndLoadingCapacityFromDb")){
			try{
				//int custId = Integer.parseInt(request.getParameter("clientId"));
				String custId = request.getParameter("clientId");
				int portId = Integer.parseInt(request.getParameter("portId"));
				System.out.println("custId :::: " + custId);
				jsonObject =new JSONObject();
				jsonArray = smpf.getMdpCountAndLoadingCapacityFromDb(systemId, custId,portId);
				jsonObject.put("MdpCountLoadingCapacityList", jsonArray);
				System.out.println("jsonArray ::: " + jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
	    else if(param.equals("getMDPCountForLocation6")){
			try{
				String vehicleNo = request.getParameter("vehicleNo");
				jsonObject =new JSONObject();
				jsonArray = smpf.getMDPCountForLocation6(systemId,userId,vehicleNo);
				jsonObject.put("MDPCountForLocationList", jsonArray);
				response.getWriter().print(jsonObject.toString());	
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
	   
		return null;
	}
}