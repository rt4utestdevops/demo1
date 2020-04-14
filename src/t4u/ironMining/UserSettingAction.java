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

public class UserSettingAction extends Action{

	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int ltsp = loginInfo.getIsLtsp();
		//int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String message="";
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		 if (param.equalsIgnoreCase("getUserNames")) {
			try {
				String custId="0";
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(request.getParameter("CustID")!=null && !request.getParameter("CustID").equals("")){
					custId=request.getParameter("CustID");
				}
					jsonArray =ironfunc.getUsersForUserSetting(Integer.parseInt(custId), systemId,ltsp,userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("userRoot", jsonArray);
					} else {
						jsonObject.put("userRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				 
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getSourcehubNew")) {
			try {
				String custID="0";
				String userID="0";
				if(request.getParameter("userID")!=null && !request.getParameter("userID").equals("")){
					userID=request.getParameter("userID");
				}
				if(request.getParameter("custID")!=null && !request.getParameter("custID").equals("")){
					custID=request.getParameter("custID");
				}
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
					jsonArray =ironfunc.getWBForUserSetting(Integer.parseInt(custID),systemId,Integer.parseInt(userID));
					if (jsonArray.length() > 0) {
						jsonObject.put("sourceHubStoreRoot", jsonArray);
					} else {
						jsonObject.put("sourceHubStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }
		else if (param.equalsIgnoreCase("getBargeHubs")) {
			try {
				String custID="0";
				if(request.getParameter("custID")!=null && !request.getParameter("custID").equals("")){
					custID=request.getParameter("custID");
				}
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
					jsonArray =ironfunc.getBargeForUserSetting(Integer.parseInt(custID),systemId);
					if (jsonArray.length() > 0) {
						jsonObject.put("bargeHubStoreRoot", jsonArray);
					} else {
						jsonObject.put("bargeHubStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }
		else if (param.equalsIgnoreCase("getWeighbridgesAssociatedToUser")) {
			try {
				String userID="0";
					
				if(request.getParameter("userId")!=null && !request.getParameter("userId").equals("")){
					userID=request.getParameter("userId");
				}
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray =ironfunc.getWeighbridgesAssociatedToUser(systemId,Integer.parseInt(userID));
				jsonObject.length();
				if (jsonArray.length() > 0) {
					jsonObject.put("UserAssociatedWBStoreRoot", jsonArray);
				} else {
					jsonObject.put("UserAssociatedWBStoreRoot", "");
				}
				//System.out.println("JSON="+jsonObject.toString());
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		  }
		else if (param.equalsIgnoreCase("getDataForNonAssociation")) {
            try {
            	String custId="0";
				String userID="0";
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(request.getParameter("CustId")!=null && !request.getParameter("CustId").equals("")){
					custId=request.getParameter("CustId");
				}
				if(request.getParameter("userId")!=null && !request.getParameter("userId").equals("")){
					userID=request.getParameter("userId");
				}
				jsonArray =ironfunc.getNonAssociatedPermits(Integer.parseInt(custId),systemId,Integer.parseInt(userID),userId);
					if (jsonArray!=null && jsonArray.length() > 0) {
                        jsonObject.put("firstGridRoot", jsonArray);
     	               } else {
                        jsonObject.put("firstGridRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    	
        else if (param.equalsIgnoreCase("getDataForAssociation")) {
            try {
            	String custId="0";
				String userID="0";
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(request.getParameter("CustId")!=null && !request.getParameter("CustId").equals("")){
					custId=request.getParameter("CustId");
				}
				if(request.getParameter("userId")!=null && !request.getParameter("userId").equals("")){
					userID=request.getParameter("userId");
				}
				jsonArray =ironfunc.getAssociatedPermits(Integer.parseInt(custId),systemId,Integer.parseInt(userID),userId);
                    if (jsonArray!=null && jsonArray.length() > 0) {
                        jsonObject.put("secondGridRoot", jsonArray);
                    } else {
                        jsonObject.put("secondGridRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        else if (param.equalsIgnoreCase("associateGroup")) {
            message = "";
            String customerId = request.getParameter("CustID");
            String s = request.getParameter("gridData");
            String userIdFromJsp = request.getParameter("userIdFromJsp");
            String sourceHubId = request.getParameter("sourceHubId")!=""?request.getParameter("sourceHubId"):"0";
            String destnationHubId = request.getParameter("destnationHubId")!=""?request.getParameter("destnationHubId"):"0";
            String bargeHubId =  request.getParameter("bargeHubId")!=""?request.getParameter("bargeHubId"):"0";
            String type = request.getParameter("type")!=""?request.getParameter("type"):"";
            String closedType = request.getParameter("closedType")!=""?request.getParameter("closedType"):"";
            String operationType = request.getParameter("operationType");
            try {
                if (s != null) {
                    String st = "[" + s + "]";
                    JSONArray js = null;
                    try {
                        js = new JSONArray(st.toString());
                       // if (js.length() > 0) {
                            message = ironfunc.associatePermitToUser(Integer.parseInt(customerId), systemId, Integer.parseInt(userIdFromJsp), js,userId,Integer.parseInt(sourceHubId),Integer.parseInt(destnationHubId),Integer.parseInt(bargeHubId),type,closedType,operationType,userId);
                        //} else {
                         //   message = "";
                        //}
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
        
        else if (param.equalsIgnoreCase("dissociateGroup")) {
            message = "";
            String customerId = request.getParameter("CustID");
            String s = request.getParameter("gridData2");
            String userIdFromJsp = request.getParameter("userIdFromJsp");
            String sourceHubId = request.getParameter("sourceHubId")!=""?request.getParameter("sourceHubId"):"0";
            String destnationHubId = request.getParameter("destnationHubId")!=""?request.getParameter("destnationHubId"):"0";
            String bargeHubId =  request.getParameter("bargeHubId")!=""?request.getParameter("bargeHubId"):"0";
            String type = request.getParameter("type")!=""?request.getParameter("type"):"";
            String closedType = request.getParameter("closedType")!=""?request.getParameter("closedType"):"";
            String operationType = request.getParameter("operationType");
            try {
                if (s != null) {
                    String st = "[" + s + "]";
                    JSONArray js = null;
                    try {
                        js = new JSONArray(st.toString());
                        if (js.length() > 0) {
                            message = ironfunc.disassociatePermitFromUser(Integer.parseInt(customerId), systemId, Integer.parseInt(userIdFromJsp), js,userId,Integer.parseInt(sourceHubId),Integer.parseInt(destnationHubId),Integer.parseInt(bargeHubId),type,closedType,operationType,userId);
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
        
		else if (param.equalsIgnoreCase("AddorModifyUserSetting")) {
			try {

				String buttonValue = request.getParameter("buttonValue");
				String CustId=request.getParameter("CustId");
				String Tcno="0";
				String permitNo=request.getParameter("permitNo");
				String sourceHub=request.getParameter("sourceHub");
				String destinationHub=request.getParameter("destinationHub");
				String type= request.getParameter("type");
				String userName= request.getParameter("userName");
				String orgCode= "0";
				String closeType=request.getParameter("closeType");
				
			    String message1="";
			    if(!request.getParameter("tcno").equals("") && request.getParameter("tcno") != null ){
			    	Tcno=request.getParameter("tcno");
			    }
			    if(!request.getParameter("orgCode").equals("") && request.getParameter("orgCode") != null ){
			    	orgCode=request.getParameter("orgCode");
			    }
				if(buttonValue.equals("Add") && CustId != null && !CustId.equals(""))
				{
                     message1=ironfunc.addUserSetting(Integer.parseInt(CustId),systemId,userId,Integer.parseInt(Tcno),permitNo,sourceHub,destinationHub,type,Integer.parseInt(userName),Integer.parseInt(orgCode),closeType);
				}
				
				response.getWriter().print(message1);
			} catch (Exception e) {
				e.printStackTrace();
			}

	}
	     //***********************************getMineDetails***********************************//
	     
		else if (param.equalsIgnoreCase("getUserSettingDetails")) {
		        try {
		        	ArrayList list=null;
		            String CustomerId = request.getParameter("CustId");
		    		
		            jsonArray = new JSONArray();
		            jsonObject = new JSONObject();
		            
		            if (CustomerId != null && !CustomerId.equals("")) {
		            	
		                list =ironfunc.getUserSettingDetails(systemId, Integer.parseInt(CustomerId),userId);
		                jsonArray = (JSONArray) list.get(0);
		            //    System.out.println(jsonArray.toString());
		                if (jsonArray.length() > 0) {
		                    jsonObject.put("userSettingRoot", jsonArray);
		                } else {
		                    jsonObject.put("userSettingRoot", "");
		                }
		                response.getWriter().print(jsonObject.toString());
		            	
		            } else {
		                jsonObject.put("userSettingRoot", "");
		                response.getWriter().print(jsonObject.toString());
		            }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
	    	}
		
		

		return null;
	}
	
}