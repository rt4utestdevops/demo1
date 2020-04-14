package t4u.wastemanagement;

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
import t4u.functions.WastemanagementFunctions;


/**
 * 
 * This class is used to get,add,modify and delete trader
 *
 */
public class TraderAction extends Action{
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response){
		HttpSession session = request.getSession();
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		WastemanagementFunctions wfuncs=new WastemanagementFunctions();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId=loginInfo.getSystemId();
		int createdUser=loginInfo.getUserId();
		
		String param = "";
		if(request.getParameter("param")!=null)
		{
			param=request.getParameter("param").toString();
		}
		/**
		 * To get Trader(Licence Holder) id and name from database
		 */
		if(param.equals("getTrader")){
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				String customerId="0";
				if(request.getParameter("custId")!=null){
					customerId=request.getParameter("custId").toString();
				}				
				jsonArray=wfuncs.getTrader(systemId, customerId);
				if(jsonArray.length()>0){
					jsonObject.put("TraderRoot", jsonArray);
					}else{
						jsonObject.put("TraderRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}catch(Exception e){
					System.out.println("Error in Trader Action:-getTrader "+e.toString());
				}			
		}
		/**
		 * To get Trader(Licence Holder) details from database
		 */
		else if(param.equals("getTraderDetails")){
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				String customerId="0";
				if(request.getParameter("custId")!=null){
					customerId=request.getParameter("custId").toString();
				}		
				String traderId="0";
				if(request.getParameter("traderId")!=null){
					traderId=request.getParameter("traderId").toString();
				}
				jsonArray=wfuncs.getTraderDetails(systemId, customerId,traderId);
				if(jsonArray.length()>0){
					jsonObject.put("TraderDetailsRoot", jsonArray);
					}else{
						jsonObject.put("TraderDetailsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}catch(Exception e){
					System.out.println("Error in Trader Action:-getTraderDetails "+e.toString());
				}			
		}
		/**
		 * saving or modifying the trader master details in database
		 */
		else if(param.equals("savermodifyTrader")){
			try{
				String buttonValue= request.getParameter("buttonvalue");
				
				String custId= request.getParameter("custId");
				
				String tradername=request.getParameter("tradername");
				
				String newtradername= request.getParameter("newtradername");
				
				String licno ="";
				if(request.getParameter("licno")!=null){
				licno =request.getParameter("licno");
				}
				
				String address ="";
				if(request.getParameter("address")!=null){
				address = request.getParameter("address");
				}
				
				String trade ="";
				if(request.getParameter("trade")!=null){
				trade =request.getParameter("trade");
				}
				
				String tradename ="";
				if(request.getParameter("tradename")!=null){
				tradename = request.getParameter("tradename");
				}
				
				String doorno ="";
				if(request.getParameter("doorno")!=null){
					doorno =request.getParameter("doorno");
				}
				
				String wardname ="";
				if(request.getParameter("wardname")!=null){
					wardname = request.getParameter("wardname");
				}
				
				String wardno ="";
				if(request.getParameter("wardno")!=null){
					wardno =request.getParameter("wardno");
				}
				
				String area ="";
				if(request.getParameter("area")!=null){
					area = request.getParameter("area");
				}
				
				String mobile ="";
				if(request.getParameter("mobile")!=null){
					mobile = request.getParameter("mobile");
				}
				
				String rfidcode =request.getParameter("rfidcode");
				
				String status =request.getParameter("status");
				
				String message=wfuncs.saveTraderDetails(systemId,createdUser,buttonValue,custId,tradername,newtradername,licno,address,trade,tradename,doorno,wardname,wardno,area,mobile,rfidcode,status);
				
				response.getWriter().print(message);	
			}catch(Exception e){
				System.out.println("Error in Trader Action:-savermodifyTrader "+e.toString());
			}			
		}
		/**
		 * Deletes the trader details from database
		 */
		else if(param.equals("deleteTraderDetails")){
			try{
				String CustId="0";
				if(request.getParameter("custId")!=null){
					CustId=request.getParameter("custId");
				}
				String TraderId="0";
				if(request.getParameter("traderId")!=null){
					TraderId=request.getParameter("traderId");
				}
				String message=wfuncs.deleteTraderDetails(systemId,CustId,TraderId);
				response.getWriter().print(message);
			}catch(Exception e){
				System.out.println("Error in Trader Action:-deleteTraderDetails "+e.toString());
			}
		}
		return null;
	}
}
