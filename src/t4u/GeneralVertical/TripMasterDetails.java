package t4u.GeneralVertical;

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
import t4u.functions.CommonFunctions;
import t4u.functions.CreateTripFunction;
import t4u.functions.GeneralVerticalFunctions;


public class TripMasterDetails extends Action{
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			CommonFunctions cf=new CommonFunctions();
			String serverName=req.getServerName();
			String sessionId = req.getSession().getId();
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
			CreateTripFunction creatTripFunc =new CreateTripFunction();			
			GeneralVerticalFunctions gvf = new GeneralVerticalFunctions();

			if(param.equals("getCustomerMasterDetails")){
				String custId = req.getParameter("custId");
				try{
					obj = new JSONObject();
						jArr = gvf.getCustomerMasterDetails(systemId,custId,offset,userId);
						if(jArr.length() > 0){
							obj.put("customerMasterRoot", jArr);
						}else{
							obj.put("customerMasterRoot", "");
						}
					resp.getWriter().print(obj.toString());
					
					cf.insertDataIntoAuditLogReport(sessionId, null, "Customer Details", "View", userId, serverName, systemId, clientId,
					"Visited This Page");
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("saveCustomerDetails")){
				String custId = req.getParameter("CustId");
				String custName = req.getParameter("custName");
				String contactPerson = req.getParameter("contactPerson");
				String contactNo = req.getParameter("contactNo");
				String contactNo2 = req.getParameter("contactNo2");
				String status=req.getParameter("status");
				String contactAddress = req.getParameter("contactAddress");
				String custRefId = req.getParameter("reference");
				String custType = req.getParameter("custtypeId");
				String message="";
				try{
					obj = new JSONObject();
						message = gvf.insertCustomerMasterDetails(systemId,Integer.parseInt(custId),offset,userId,custName,contactPerson,contactNo,
								contactAddress,custRefId,status,custType,contactNo2);
						
						obj.put("customerMasterRoot", message);
					resp.getWriter().print(message.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("saveEditCustomerDetails")){
				String id = req.getParameter("id");
				String custId = req.getParameter("custId");
				String customerName = req.getParameter("customerName");
				String contactPerson = req.getParameter("contactPerson");
				String contactNo = req.getParameter("contactNo");
				String contactNo2 = req.getParameter("contactNo2");
				String status=req.getParameter("status");
				String contactAddress = req.getParameter("contactAddress");
				String custRefId = req.getParameter("reference");
				String custType = req.getParameter("custtypeId1");
				String message="";
				try{
					obj = new JSONObject();
					message = gvf.updateCustomerMasterDetails(systemId,Integer.parseInt(custId),offset,userId,customerName,contactPerson,contactNo,
							contactAddress,custRefId,Integer.parseInt(id),status,custType,contactNo2);
					
					obj.put("customerMasterRoot", message);
				
					resp.getWriter().print(message.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getCustomer")){
				try {
					obj = new JSONObject();
					jArr = creatTripFunc.getCustomer(clientId, systemId);
					obj.put("customerRoot", jArr);
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			} 
			else if(param.equals("loadcustomertype")){
				try {
					obj = new JSONObject();
					jArr = creatTripFunc.getCustomerType(clientId, systemId);
					if (jArr.length() > 0) {
						obj.put("custype", jArr);
					} else {
						obj.put("custype", "");
					}
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
				
			} 
			else if (param.equals("getTripNames")) {
							try {
								obj = new JSONObject();
								jArr = gvf.getTripNames(systemId, clientId,offset);
								//jsonObject = new JSONObject();
								if (jArr != null && jArr.length() != 0) {
									obj.put("tripRoot", jArr);
								} else {
									obj.put("tripRoot", "");
								}
								resp.getWriter().print(obj.toString());
								//response.getWriter().print(jsonObject.toString());
							} catch (Exception e) {
								e.printStackTrace();
							}
						}			
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}	
}