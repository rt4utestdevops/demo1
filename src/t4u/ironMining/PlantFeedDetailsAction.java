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

public class PlantFeedDetailsAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		//int offset = loginInfo.getOffsetMinutes();
		//String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if(param.equals("getTCNumber")){
			try {
				String CustomerId = request.getParameter("clientId");
				jsonObject = new JSONObject();
				jsonArray = ironfunc.getTCnumber(systemId, Integer.parseInt(CustomerId),userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("tcNoRoot", jsonArray);
				} else {
					jsonObject.put("tcNoRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if(param.equals("getOCode")){
			try {
				String CustomerId = request.getParameter("clientId");
				jsonObject = new JSONObject();
				jsonArray = ironfunc.getOCode(systemId, Integer.parseInt(CustomerId),userId);
				if (jsonArray.length() > 0) {
					jsonObject.put("oCodeRoot", jsonArray);
				} else {
					jsonObject.put("oCodeRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if(param.equals("getplantIdAndName")){
			try {
				String CustomerId = request.getParameter("clientId");
				String orgId = request.getParameter("orgId");
				jsonObject = new JSONObject();
				jsonArray = ironfunc.getOrgCodeAndName(systemId, Integer.parseInt(CustomerId),orgId);
				if (jsonArray.length() > 0) {
					jsonObject.put("plantNameRoot", jsonArray);
				} else {
					jsonObject.put("plantNameRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if(param.equals("getRomChallan")){
			try {
				String CustomerId = request.getParameter("clientId");
				String tcID = request.getParameter("tcID");
				jsonObject = new JSONObject();
				jsonArray = ironfunc.getRomChallan(systemId, Integer.parseInt(CustomerId),Integer.parseInt(tcID));
				if (jsonArray.length() > 0) {
					jsonObject.put("romChallanRoot", jsonArray);
				} else {
					jsonObject.put("romChallanRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
			else if (param.equalsIgnoreCase("getPlantFeedDetails")) {
	        try {
	            String CustomerId = request.getParameter("CustId");
	    		System.out.println("CustomerId:"+CustomerId);
	            String CustName= request.getParameter("CustName");
	            String jspName=request.getParameter("jspName");
	    		
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            
	            if (CustomerId != null && !CustomerId.equals("")) {
	            	
	            	ArrayList < Object > list =ironfunc.getPlantFeedDetails(systemId, Integer.parseInt(CustomerId),userId);
	            	jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("plantfeedDetailsRoot", jsonArray);
	                } else {
	                    jsonObject.put("plantfeedDetailsRoot", "");
	                }
	            ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("CustName", CustName);
				response.getWriter().print(jsonObject.toString());
	        }} catch (Exception e) {
	            e.printStackTrace();
	        }
    	}
		else if (param.equalsIgnoreCase("AddorModifyPlantFeedDetails")) {
			try {

				String buttonValue = request.getParameter("buttonValue");
				String type = request.getParameter("type");
				String remarks = request.getParameter("remark");
				int CustId=0;
				int organCode=0;
				int plantId=0;
				String date="";
				float rom=0;
				float romQty=0;
				float lump1= 0;
				float lump2=0;
				float lump3=0;
				float lump4=0;
				float lump5=0;
				float lump6=0;
				float fine1=0;
				float fine2=0;
				float fine3=0;
				float fine4=0;
				float fine5=0;
				float fine6=0;
				float concentrate1=0;
				float concentrate2=0;
				float concentrate3=0;
				float concentrate4=0;
				float concentrate5=0;
				float concentrate6=0;
				float tailing=0;
				float reject=0;
				float UFO=0;
				int uniqueId=0;
				float usedqty=0;
				
				if(request.getParameter("oCode") != null && !request.getParameter("oCode").equals("")){
					organCode = Integer.parseInt(request.getParameter("oCode"));
				}
				if(request.getParameter("plantId") != null && !request.getParameter("plantId").equals("")){
					plantId = Integer.parseInt(request.getParameter("plantId"));
				}
				if(request.getParameter("date") != null && !request.getParameter("date").equals("")){
					date = request.getParameter("date");
				}
				if(request.getParameter("rom") != null && !request.getParameter("rom").equals("")){
					rom = Float.parseFloat(request.getParameter("rom"));
				}
				if(request.getParameter("romQty") != null && !request.getParameter("romQty").equals("")){
					romQty = Float.parseFloat(request.getParameter("romQty"));
				}
				if(request.getParameter("lump1") != null && !request.getParameter("lump1").equals("")){
					lump1 = Float.parseFloat(request.getParameter("lump1"));
				}
				if(request.getParameter("lump2") != null && !request.getParameter("lump2").equals("")){
					lump2 = Float.parseFloat(request.getParameter("lump2"));
				}
				if(request.getParameter("lump3") != null && !request.getParameter("lump3").equals("")){
					lump3 = Float.parseFloat(request.getParameter("lump3"));
				}
				if(request.getParameter("lump4") != null && !request.getParameter("lump4").equals("")){
					lump4 = Float.parseFloat(request.getParameter("lump4"));
				}
				if(request.getParameter("lump5") != null && !request.getParameter("lump5").equals("")){
					lump5 = Float.parseFloat(request.getParameter("lump5"));
				}
				if(request.getParameter("lump6") != null && !request.getParameter("lump6").equals("")){
					lump6 = Float.parseFloat(request.getParameter("lump6"));
				}
				if(request.getParameter("fine1") != null && !request.getParameter("fine1").equals("")){
					fine1 = Float.parseFloat(request.getParameter("fine1"));
				}
				if(request.getParameter("fine2") != null && !request.getParameter("fine2").equals("")){
					fine2 = Float.parseFloat(request.getParameter("fine2"));
				}
				if(request.getParameter("fine3") != null && !request.getParameter("fine3").equals("")){
					fine3 = Float.parseFloat(request.getParameter("fine3"));
				}
				if(request.getParameter("fine4") != null && !request.getParameter("fine4").equals("")){
					fine4 = Float.parseFloat(request.getParameter("fine4"));
				}
				if(request.getParameter("fine5") != null && !request.getParameter("fine5").equals("")){
					fine5 = Float.parseFloat(request.getParameter("fine5"));
				}
				if(request.getParameter("fine6") != null && !request.getParameter("fine6").equals("")){
					fine6 = Float.parseFloat(request.getParameter("fine6"));
				}
				if(request.getParameter("concentrate1") != null && !request.getParameter("concentrate1").equals("")){
					concentrate1 = Float.parseFloat(request.getParameter("concentrate1"));
				}
				if(request.getParameter("concentrate2") != null && !request.getParameter("concentrate2").equals("")){
					concentrate2 = Float.parseFloat(request.getParameter("concentrate2"));
				}
				if(request.getParameter("concentrate3") != null && !request.getParameter("concentrate3").equals("")){
					concentrate3 = Float.parseFloat(request.getParameter("concentrate3"));
				}
				if(request.getParameter("concentrate4") != null && !request.getParameter("concentrate4").equals("")){
					concentrate4 = Float.parseFloat(request.getParameter("concentrate4"));
				}
				if(request.getParameter("concentrate5") != null && !request.getParameter("concentrate5").equals("")){
					concentrate5 = Float.parseFloat(request.getParameter("concentrate5"));
				}
				if(request.getParameter("concentrate6") != null && !request.getParameter("concentrate6").equals("")){
					concentrate6 = Float.parseFloat(request.getParameter("concentrate6"));
				}
				if(request.getParameter("tailing") != null && !request.getParameter("tailing").equals("")){
					tailing = Float.parseFloat(request.getParameter("tailing"));
				}
				if(request.getParameter("reject") != null && !request.getParameter("reject").equals("")){
					reject = Float.parseFloat(request.getParameter("reject"));
				}
				if(request.getParameter("UFO") != null && !request.getParameter("UFO").equals("")){
					UFO = Float.parseFloat(request.getParameter("UFO"));
				}
				if(request.getParameter("id") != null && !request.getParameter("id").equals("")){
					uniqueId = Integer.parseInt(request.getParameter("id"));
				}
				if(request.getParameter("usedqty") != null && !request.getParameter("usedqty").equals("")){
					usedqty = Float.parseFloat(request.getParameter("usedqty"));
				}
				String message="";
				if(request.getParameter("CustId") != null && !request.getParameter("CustId").equals("")){
					CustId = Integer.parseInt(request.getParameter("CustId"));
				}
				if(buttonValue.equals("Add"))
				{
                    message=ironfunc.addPlantFeedDetails(userId,organCode,date,rom,lump1,lump2,lump3,lump4,lump5,lump6,fine1,fine2,fine3,fine4,fine5,fine6,concentrate1,concentrate2,concentrate3,concentrate4,concentrate5,concentrate6,tailing,reject,UFO,systemId,CustId,usedqty,plantId,romQty,type,remarks);
				}else if(buttonValue.equals("Modify"))
				{
					//message=ironfunc.modifyPlantFeedDetails(userId,uniqueId,rom,lump1,lump2,lump3,lump4,lump5,lump6,fine1,fine2,fine3,fine4,fine5,fine6,concentrate1,concentrate2,concentrate3,concentrate4,concentrate5,concentrate6,tailing,reject,UFO,systemId,CustId,plantId);
				}
				response.getWriter().print(message); 
			 }catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equalsIgnoreCase("cancelPlantFeed")) {
			String customerId = request.getParameter("CustID");
			String id = request.getParameter("id");
			String type =request.getParameter("type");
			String qty= request.getParameter("qty");
			String totalFinesTf = request.getParameter("totalFinesTf");
			String totalLumpsTf = request.getParameter("totalLumpsTf");
			String totalConcentratesTf = request.getParameter("totalConcentratesTf");
			String tailings = request.getParameter("tailings");
			String plantId = request.getParameter("plantId");
			String remark=request.getParameter("remark");
			String ufo=request.getParameter("ufo");
			String message1="";
			if (customerId != null && !customerId.equals("") && id != null && !id.equals("")) {
				try {
					message1 = ironfunc.cancelPlantFeed(Integer.parseInt(customerId),systemId,userId,Integer.parseInt(id),
							type,qty,Float.parseFloat(totalFinesTf),Float.parseFloat(totalLumpsTf),Float.parseFloat(totalConcentratesTf),Float.parseFloat(tailings),Integer.parseInt(plantId),remark,Float.parseFloat(ufo));
					response.getWriter().print(message1);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		return null;
	}
}
