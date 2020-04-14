package t4u.cashvanmanagement;

import java.io.IOException;
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
import t4u.functions.AdminFunctions;
import t4u.functions.CashVanManagementFunctions;

public class CustomerMasterAction extends Action {

public ActionForward execute(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response){
	
	HttpSession session = request.getSession();
    String param = "";
    String zone = "";
    int systemId = 0;
    int userId = 0;
    int offset = 0;
    int countryId=0;
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    AdminFunctions adfunc = new AdminFunctions();
    systemId = loginInfo.getSystemId();
    countryId=loginInfo.getCountryCode();
    zone = loginInfo.getZone();
    userId = loginInfo.getUserId();
    offset = loginInfo.getOffsetMinutes();
    String lang = loginInfo.getLanguage();
    String ltspName = loginInfo.getSystemName();
    String userName = loginInfo.getUserName();      
    String category = loginInfo.getCategory();
    String categoryType = loginInfo.getCategoryType();
    CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
    JSONArray jsonArray = null;
    JSONObject jsonObject = new JSONObject();
    if (request.getParameter("param") != null) {
        param = request.getParameter("param").toString();
    }
    if(param.equalsIgnoreCase("AddorModify"))
	{

		try
		{
			String buttonValue = request.getParameter("buttonValue");
			String custId=request.getParameter("CustId");			
			String cumpanyName = request.getParameter("CumpanyName");
			String companyType = request.getParameter("CompanyType");
			String region = request.getParameter("Region");
			String address = request.getParameter("Address");
			String contactPesrson = request.getParameter("ContactPesrson");
			String phoneNo = request.getParameter("PhoneNo");
			String mobile = request.getParameter("Mobile");
			String email = request.getParameter("Email");
			String status=request.getParameter("Status");
			String contactPesrson2 = request.getParameter("ContactPesrson2");
			String phoneNo2 = request.getParameter("PhoneNo2");
			String mobile2 = request.getParameter("Mobile2");
			String message="";
			if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
			{
				message=cashVanfunc.addCustomerDetails(cumpanyName,companyType,region,address,contactPesrson,phoneNo,mobile,email,status,systemId,Integer.parseInt(custId),userName,phoneNo2,mobile2,contactPesrson2);
				
			}else if(buttonValue.equals("Modify") && custId != null && !custId.equals(""))
			{
				message=cashVanfunc.modifyCustomerDetails(cumpanyName,companyType,region,address,contactPesrson,phoneNo,mobile,email,status,systemId,Integer.parseInt(custId),userName,phoneNo2,mobile2,contactPesrson2);
			}
			
			response.getWriter().print(message);
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	
	}
    
       else if(param.equalsIgnoreCase("getCustomerMasterDetails"))
	{
    	try {
            String customerId = request.getParameter("CustId");
            jsonArray = new JSONArray();
            if (customerId != null && !customerId.equals("")) {
                ArrayList < Object > list1 = cashVanfunc.getCustomerMasterDetails(systemId, Integer.parseInt(customerId),offset);
                jsonArray = (JSONArray) list1.get(0);
                if (jsonArray.length() > 0) {
                    jsonObject.put("customerMasterRoot", jsonArray);
                } else {
                    jsonObject.put("customerMasterRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } else {
                jsonObject.put("customerMasterRoot", "");
                response.getWriter().print(jsonObject.toString());
            }
        }catch (Exception e) {
			e.printStackTrace();
		}	
    }
    
    if(param.equalsIgnoreCase("customer")){
    	String loc= request.getParameter("location");
    	 String customerId = request.getParameter("CustId");
    	 JSONArray JsonArray = null;
    	 if(customerId !=null){
    		 JsonArray =cashVanfunc.getCustomersByLocation(systemId, Integer.parseInt(customerId), loc);
    	 try {
			response.getWriter().print(JsonArray.toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
    		
    }
	
return null;

}}
	


