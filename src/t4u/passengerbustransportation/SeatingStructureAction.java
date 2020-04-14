package t4u.passengerbustransportation;

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
import t4u.functions.PassengerBusTransportationFunctions;

public class SeatingStructureAction extends Action{
@Override
public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		
	HttpSession session = request.getSession();
	PassengerBusTransportationFunctions tmf = new PassengerBusTransportationFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String param = "";
	JSONArray jsonArray = null;
	JSONObject jsonObject = new JSONObject();
	
	if(request.getParameter("param")!=null)
	{
		param=request.getParameter("param").toString();
	}
	if(loginInfo!=null){
		int systemID=loginInfo.getSystemId();
		int userID=loginInfo.getUserId();
		String language=loginInfo.getLanguage();
		if(param.equals("getSeatingStructureDetails")){
			try{
			String customerID=null;			
			if(request.getParameter("customerID")!=null){
				customerID=request.getParameter("customerID");
			}			
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			ArrayList<Object> returnList=tmf.getSeatingStructureDetials(systemID, customerID, language);
			jsonArray=(JSONArray) returnList.get(0);
			if (jsonArray.length() > 0) {
				jsonObject.put("structureDetailsRoot", jsonArray);
			} else {
				jsonObject.put("structureDetailsRoot", "");
			}
			
			}catch (Exception e) {
				e.printStackTrace();
			}
			response.getWriter().print(jsonObject.toString());
		}else if (param.equals("saveormodifySeatingStructure")){
			try{
				String buttonValue=null;				
				int structureID=0;
				String status=null;
				String message=null;
				int customerID=0;
				if(request.getParameter("buttonValue")!=null){
					buttonValue=request.getParameter("buttonValue");
				}
				if(request.getParameter("status")!=null){
					status=request.getParameter("status");
				}
				if(request.getParameter("structureId")!=null && !request.getParameter("structureId").equals("") ){
					structureID=Integer.parseInt(request.getParameter("structureId"));
				}
				if(request.getParameter("customerID")!=null && !request.getParameter("customerID").equals("")){
					customerID=Integer.parseInt(request.getParameter("customerID"));
				}
				if(buttonValue.equals("modify")){
					
					message=tmf.modifyBusSeatingStructure(systemID, customerID, status, userID,structureID);	
				}
				response.getWriter().print(message);
			}catch (Exception e) {
				e.printStackTrace();
			}
			
		}else if(param.equals("getSeatingStructure")){
			String seatingStructure=null;
			String customerID=null;
			String structureName=null;
			if(request.getParameter("customerID")!=null){
				customerID=request.getParameter("customerID");
			}
			if(request.getParameter("structureName")!=null){
				structureName=request.getParameter("structureName");
			}
			seatingStructure=tmf.getSeatingStructure(systemID,Integer.parseInt(customerID),structureName);
			if(seatingStructure!=null){
				response.getWriter().print(seatingStructure);
			} else {
				response.getWriter().print("");
			}
		}
		
	}else {
		if(param.equalsIgnoreCase("checkSession")){
			response.getWriter().print("InvalidSession");
		}
		
	}
	return null;
	
}
	
}
