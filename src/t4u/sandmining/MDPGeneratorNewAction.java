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

public class MDPGeneratorNewAction extends Action{
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
		if(param.equals("getApplicationDetails")){
			 try{
				 String clientId=request.getParameter("clientId");
				 String tpno=request.getParameter("tpno");
				 jsonObject =new JSONObject();
				 jsonArray=smpf.getApplicationDetails(systemId,clientId,userId,tpno);
				 jsonObject.put("ApplicationNoStoreList", jsonArray);
				 response.getWriter().print(jsonObject.toString());
			 }catch(Exception e){
				 e.printStackTrace();
			 }
		}else if(param.equals("getTpNo")){
			try{
				 String clientId=request.getParameter("clientId");
				 jsonObject =new JSONObject();
				 jsonArray=smpf.getTpNo(systemId,clientId,userId);
				 jsonObject.put("TpNoStoreList", jsonArray);
				 response.getWriter().print(jsonObject.toString());
			 }catch(Exception e){
				 e.printStackTrace();
			 }
		}else if(param.equals("getFromLocLatLong")){
			 try{
				 String clientId=request.getParameter("clientId");
				 String tpno=request.getParameter("tpno");
				 jsonObject =new JSONObject();
				 jsonArray=smpf.getFromLocLatLong(systemId,clientId,userId,tpno);
				 jsonObject.put("FromLatLongStoreList", jsonArray);
				 response.getWriter().print(jsonObject.toString());
			 }catch(Exception e){
				 e.printStackTrace();
			 }
		}
		else if(param.equals("getGRIDDetails"))
		{
		 
			String clientIdFromJsp = request.getParameter("ClientId");
			String custName = request.getParameter("custname");
			String jspName="";
			try{
				JSONArray jsonArray1 = new JSONArray(); 
				JSONObject jsonObject1 = new JSONObject();
				 if(request.getParameter("jspname")!=null)
		         jspName=request.getParameter("jspname");
				 
				ArrayList finlist = smpf.getGRIDDetails(systemId,clientIdFromJsp,offset,userId);
				jsonArray1= (JSONArray) finlist.get(0);
				if(jsonArray1.length()>0)
				{
					jsonObject1.put("newGridRoot", jsonArray1);
				} else {
					jsonObject1.put("newGridRoot", "");
				}
					
				ReportHelper reportHelper=(ReportHelper)finlist.get(1);
				request.getSession().setAttribute(jspName,reportHelper);
				request.getSession().setAttribute("custId", custName);
				response.getWriter().print(jsonObject1.toString());
	        	}
			catch(Exception e)
			{
				System.out.println("Error in getting Master Details:"+e.toString());
				e.printStackTrace();
	        }
			
		}
		else if(param.equals("saveGRIDDetails"))
	    {
		 try {
			 String buttonValue=request.getParameter("buttonValue");
			 String custId= request.getParameter("custId");
			 String mdpNoAdd = request.getParameter("mdpNoAdd");
			 String permitNoAdd = request.getParameter("permitNoAdd");
			 String transporterNameAdd = request.getParameter("transporterNameAdd");
			 String loadingTypeAdd = request.getParameter("loadingTypeAdd");
			 String validFromAdd = request.getParameter("validFromAdd");
			 String distanceAdd = request.getParameter("distanceAdd");
			 String validToAdd = request.getParameter("validToAdd");
			 String customerNameAdd =request.getParameter("customerNameAdd");
			 String driverNameAdd = request.getParameter("driverNameAdd");
			 String viaRouteAdd = request.getParameter("viaRouteAdd");
             String applicationNoAdd = request.getParameter("applicationNoAdd");
			 String vehicleNoAdd = request.getParameter("vehicleNoAdd");
             String latitude=request.getParameter("latitude");
             String longitude=request.getParameter("longitude");
             String quantity = request.getParameter("quantityAdd");
             String fromPlace = request.getParameter("fromPlaceAdd");
			 String toPlace = request.getParameter("toPlaceAdd");
			 String tripcode= request.getParameter("tripcode");
			 String barcode = request.getParameter("barcode");
			 String Lessetype="";
			 String village=request.getParameter("Village");
			 String taluk=request.getParameter("Taluk");
			 String Bank_Name=request.getParameter("Bank_Name");
			 String SandLoadingFromTime=request.getParameter("SandLoadingFromTime");
			 String SandLoadingToTime=request.getParameter("SandLoadingToTime");
			 String DD_No=request.getParameter("DD_No");
			 String DD_Date=request.getParameter("DD_Date");
			 String port_no=request.getParameter("port_no");
			 int royalty=60;
			 double totalfee= royalty * Double.parseDouble(quantity);
			 String surveyNo="";
			 String MineralType=request.getParameter("Sand_type");
			 String VehicleType=request.getParameter("VehicleType");
			 
			 if(buttonValue.equals("Add"))
			    {
			    	message = smpf.insert_GRID_Details(mdpNoAdd,permitNoAdd,transporterNameAdd,vehicleNoAdd,systemId,custId,validFromAdd,validToAdd,loadingTypeAdd,driverNameAdd,viaRouteAdd,customerNameAdd,applicationNoAdd,distanceAdd,latitude,longitude,quantity,userId,fromPlace,toPlace,offset,village,taluk,royalty,surveyNo,MineralType,Lessetype,Integer.parseInt(tripcode),Integer.parseInt(barcode),Bank_Name,SandLoadingFromTime,SandLoadingToTime,DD_No,DD_Date,port_no,VehicleType,totalfee);
			    }
  
			 response.getWriter().print(message);
		 } catch(Exception e){
				e.printStackTrace();
		}
		   
}
		else if (param.equals("getTripSheetCode")) {
			try {
				jsonObject =new JSONObject();
				String tripStartCode = request.getParameter("storeTripStartCode");
				String tripEndCode = request.getParameter("storeTripEndCode");
				String customerId = request.getParameter("globalClientId");
				if(customerId != null && !customerId.equals("") && tripStartCode != null && !tripStartCode.equals("") && tripEndCode != null && !tripEndCode.equals("")){
					jsonArray = smpf.getTripSheetCode1(systemId, Integer.parseInt(customerId),Integer.parseInt(tripStartCode),Integer.parseInt(tripEndCode), userId);
				}
				jsonObject.put("tripSheetCodeRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equals("getBarCode")) {
			
			try {
				jsonObject =new JSONObject();
				String barStartCode = request.getParameter("storeBarStartCode");
				String barEndCode = request.getParameter("storeBarEndCode");
				String customerId = request.getParameter("globalClientId");
				if(customerId != null && !customerId.equals("") && barStartCode != null && !barStartCode.equals("") && barEndCode != null && !barEndCode.equals("")){
					jsonArray = smpf.getBarCode1(systemId, Integer.parseInt(customerId),Integer.parseInt(barStartCode),Integer.parseInt(barEndCode), userId);
				}
				jsonObject.put("barCodeRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
