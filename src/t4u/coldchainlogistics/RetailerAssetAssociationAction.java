package t4u.coldchainlogistics;


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
import t4u.functions.ColdChainLogisticsFunctions;

public class RetailerAssetAssociationAction extends Action {
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		
		HttpSession session=request.getSession();
		LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();

		int systemId = loginInfoBean.getSystemId();		
		int userid=loginInfoBean.getUserId();
	    
		String param="";
		ColdChainLogisticsFunctions coldchain=new ColdChainLogisticsFunctions();
		if(request.getParameter("param")!=null)
		{
			param = request.getParameter("param");
		}

		if(param.equals("getRetailer"))
		{			
			try
			{
				JSONArray list = new JSONArray(); 
				JSONObject rslt = new JSONObject();	
				
				if( request.getParameter("CustId") != null ){
					String clientIds = request.getParameter("CustId") ;
				    int clientIdFrmJsp = Integer.parseInt(clientIds);
		       
					list=coldchain.getRetailerDetails(systemId, clientIdFrmJsp);
				    rslt.put("retailerRoot", list);
				    response.getWriter().print(rslt.toString());
				}else{
					 response.getWriter().print("");
				}
				}
				  
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}	
		  else if (param.equalsIgnoreCase("getNonAssociatedAssetDetails")) {
		        try {
		            String retailerId = request.getParameter("selectedRetIdFrmJsp");
		            String customerId = request.getParameter("custIdFrmJsp");
		            String groupId=request.getParameter("selectGrpIdFrmJsp");
					
		            if (customerId != null && !customerId.equals("") && retailerId != null && !retailerId.equals("") && groupId != null && !groupId.equals("")) { 
		                ArrayList < Object > list1 = coldchain.getNonAssociatedAssetDetails(userid,systemId,Integer.parseInt(customerId),Integer.parseInt(retailerId),Integer.parseInt(groupId));
		                jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("NonassociatedGridRoot", jsonArray);
		                } else {
		                    jsonObject.put("NonassociatedGridRoot", "");
		                }
		                response.getWriter().print(jsonObject.toString());
		            } else {
		                jsonObject.put("NonassociatedGridRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }	
		    else if (param.equalsIgnoreCase("getAssociatedAssetDetails")) {
		        try {
		            String retailerId = request.getParameter("selectedRetIdFrmJsp");
		            String customerId = request.getParameter("custIdFrmJsp");
		            String groupId=request.getParameter("selectGrpIdFrmJsp");

		            jsonArray = new JSONArray();
		            if (customerId != null && !customerId.equals("") && retailerId != null && !retailerId.equals("")  && groupId != null && !groupId.equals("")) {
		              ArrayList < Object > list1 = coldchain.getAssociatedAssetDetails(userid,Integer.parseInt(customerId), systemId, Integer.parseInt(retailerId),Integer.parseInt(groupId));
		               jsonArray = (JSONArray) list1.get(0);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("AssociatedGridRoot", jsonArray);
		                } else {
		                    jsonObject.put("AssociatedGridRoot", "");
		                }
		                response.getWriter().print(jsonObject.toString());
		            } else {
		                jsonObject.put("AssociatedGridRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }	
		    else if (param.equalsIgnoreCase("associateAsset")) {
		        String message = "";
		        String customerId = request.getParameter("custIdFrmJsp");
		        String s = request.getParameter("gridData");
	            String retailerId = request.getParameter("selectedRetIdFrmJsp");
		        try {
		            if (s != null) {
		                String st = "[" + s + "]";
		                JSONArray js = null;
		                try {
		                    js = new JSONArray(st.toString());
		                    if (js.length() > 0) {
		                      message = coldchain.associateAsset(Integer.parseInt(customerId), systemId, Integer.parseInt(retailerId), js,userid);
		                    } else {
		                        message = "";
		                    }
		                } catch (Exception e) {
		                    e.printStackTrace();
		                }
		            } else {
		                message = "No Data To Save";
		            }
		            response.getWriter().print(message);
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }
		    else if(param.equalsIgnoreCase("dissociateAsset")) {
		    	String message= " ";
		    	String customerId = request.getParameter("custIdFrmJsp");
		    	String s = request.getParameter("gridData1");
		    	String retailerId = request.getParameter("selectedRetIdFrmJsp");
		    	try{
		    		if(s != null){
		    			String st = "[" + s + "]";
		    			JSONArray js = null;
		    			try{
		    		js = new JSONArray(st.toString());
		    		if (js.length() > 0) {
		    			message = coldchain.dissociateAsset(Integer.parseInt(customerId), systemId, Integer.parseInt(retailerId), js,userid);
		    		}
		    		else{
		    			message = "";
		    		}
		    	}catch(Exception e) {
		    		e.printStackTrace();
		    	}
		    	}else {
	                message = "No Data To Save";
	            }
		    	response.getWriter().print(message);
		    }catch (Exception e) {
		    	e.printStackTrace();
		    }
	}
		return null;
	
}
}

