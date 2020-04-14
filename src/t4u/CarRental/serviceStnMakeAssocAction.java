package t4u.CarRental;

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
import t4u.functions.serviceStnMakeAssocFunctions;


public class serviceStnMakeAssocAction  extends Action {
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		try {
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");			
			int systemId = loginInfo.getSystemId();
			int userId = loginInfo.getUserId();
			String zone=loginInfo.getZone();
		
			JSONObject jsonObject = null;			
			JSONArray jsonArray = null;
			String param = "";
			serviceStnMakeAssocFunctions adfunc=new serviceStnMakeAssocFunctions();
			if (request.getParameter("param") != null) {
				param = request.getParameter("param").toString();
			}
			
			if (param.equalsIgnoreCase("getDataForNonAssociation")) {
		        try {
		            String customerId = request.getParameter("CustId");
		            String groupid = request.getParameter("groupId");
		            jsonArray = new JSONArray();
		            jsonObject= new JSONObject();
		            if (customerId != null && !customerId.equals("")) {
		            	jsonArray = adfunc.getDataForNonAssociation(Integer.parseInt(groupid),Integer.parseInt(customerId), systemId,zone);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("firstGridRoot", jsonArray);
		                } else {
		                    jsonObject.put("firstGridRoot", "");
		                }
		                response.getWriter().print(jsonObject.toString());
		            } else {
		                jsonObject.put("firstGridRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }	
			
		    else if (param.equalsIgnoreCase("getDataForAssociation")) {
		        try {
		            String customerId = request.getParameter("CustId");		         
		            String groupid = request.getParameter("groupId");
		            String assetMake = request.getParameter("assetMake");
		            
		            jsonObject= new JSONObject();
		            jsonArray = new JSONArray();
		            if (customerId != null && !customerId.equals("") && groupid != null && !groupid.equals("")) {
		            	jsonArray = adfunc.getDataForAssociation(Integer.parseInt(customerId), systemId
		                		  ,zone,Integer.parseInt(groupid),assetMake);
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("secondGridRoot", jsonArray);
		                } else {
		                    jsonObject.put("secondGridRoot", "");
		                }
		                response.getWriter().print(jsonObject.toString());
		            } else {
		                jsonObject.put("secondGridRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    }else if (param.equalsIgnoreCase("associateGroup")) {
		        String message = "";
		        String customerId = request.getParameter("CustID");
		        String s = request.getParameter("gridData");
		        String groupid = request.getParameter("groupId");
	            String assetMake = request.getParameter("assetMake");
		        try {
		            if (s != null) {
		                String st = "[" + s + "]";
		                JSONArray js = null;
		                try {
		                    js = new JSONArray(st.toString());
		                    if (js.length() > 0) {
		                        message = adfunc.associateGroup(Integer.parseInt(customerId), systemId,Integer.parseInt(groupid),assetMake,js,userId);
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
		    }else if (param.equalsIgnoreCase("dissociateGroup")) {
		        String message = "";
		        String customerId = request.getParameter("CustID");
		        String s = request.getParameter("gridData2");
		        String groupid = request.getParameter("groupId");
	            String assetMake = request.getParameter("assetMake");
		        try {
		            if (s != null) {
		                String st = "[" + s + "]";
		                JSONArray js = null;
		                try {
		                    js = new JSONArray(st.toString());
		                    if (js.length() > 0) {
		                        message = adfunc.dissociateGroup(Integer.parseInt(customerId), systemId,Integer.parseInt(groupid),assetMake,js,userId);
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
		    }else if (param.equals("getAssetMake")) {
				try {
					jsonArray = new JSONArray();
					jsonObject = new JSONObject();
					 String custId = request.getParameter("CustId");				      
				     String grpid = request.getParameter("groupId");
					jsonArray = adfunc.getVehicleDocumentTypeList(systemId,Integer.parseInt(custId),Integer.parseInt(grpid) );					
					if (jsonArray.length() > 0) {
						jsonObject.put("assetMakeRoot", jsonArray);
					} else {
						jsonObject.put("assetMakeRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
					System.out.println("Error in Asset Group Action "+ e.toString());
				}

			}if(param.equalsIgnoreCase("getAssetGroupDetails")){
			 try{
				String customerid=request.getParameter("customerID");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();			
				jsonArray=adfunc.getAssetGroupdetails(customerid,systemId,zone);
				if(jsonArray.length()>0){
				jsonObject.put("AssetGroupRoot", jsonArray);
				}
				else{
				jsonObject.put("AssetGroupRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				}
				catch(Exception e){
					System.out.println("Exception in AssetGroupAction:-getAssetGroupDetails "+e.toString());
				}
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
			
		}
}
