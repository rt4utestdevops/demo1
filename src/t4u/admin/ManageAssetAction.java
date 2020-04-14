package t4u.admin;
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
import t4u.functions.LTSP_Subscription_Payment_Function;
public class ManageAssetAction extends Action {
    public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        AdminFunctions adfunc = new AdminFunctions();
        systemId = loginInfo.getSystemId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        String ltspName = loginInfo.getSystemName();
        String userName = loginInfo.getUserName();
        CommonFunctions cf = new CommonFunctions();
        LTSP_Subscription_Payment_Function ltspFunction = new LTSP_Subscription_Payment_Function();
        String serverName=request.getServerName();
        String sessionId = request.getSession().getId();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        
        if (param.equalsIgnoreCase("getAssetType")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                jsonArray = adfunc.getAssetTypeDetails(systemId, userId);
                if (jsonArray.length() > 0) {
                    jsonObject.put("assetTypeRoot", jsonArray);
                } else {
                    jsonObject.put("assetTypeRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equalsIgnoreCase("getAssetModel")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String customerId = request.getParameter("CustId");
                if (customerId != null && !customerId.equals("")) {
                    jsonArray = adfunc.getAssetModelDetails(systemId, userId, Integer.parseInt(customerId));
                    if (jsonArray.length() > 0) {
                        jsonObject.put("assetModelRoot", jsonArray);
                    } else {
                        jsonObject.put("assetModelRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equalsIgnoreCase("getUnitType")) {
            try {
                String customerId = request.getParameter("CustId");
                jsonArray = new JSONArray();
                if (customerId != null && !customerId.equals("")) {
                    jsonArray = adfunc.getUnitNumber(systemId, userId, Integer.parseInt(customerId));
                    if (jsonArray.length() > 0) {
                        jsonObject.put("unitTypeRoot", jsonArray);
                    } else {
                        jsonObject.put("unitTypeRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("unitTypeRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equalsIgnoreCase("getMobileNo")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                jsonArray = adfunc.getMobileNumber(systemId, userId);
                if (jsonArray.length() > 0) {
                    jsonObject.put("mobileNoRoot", jsonArray);
                } else {
                    jsonObject.put("mobileNoRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equals("getGroups")) {
            int clientId = 0;
            String customerId = request.getParameter("CustId");
            if (customerId != null && !customerId.equals("")) {
                clientId = Integer.parseInt(customerId);
            }
            jsonArray = adfunc.getGroupNameList(systemId, clientId, userId);
            try {
                if (jsonArray != null) {
                    jsonObject.put("groupNameList", jsonArray);
                } else {
                    jsonObject.put("groupNameList", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equalsIgnoreCase("getManageRegistrationReport")) {
            try {
                String customerId = request.getParameter("CustId");
                String vehicleNo = request.getParameter("vehicleNo");
                jsonArray = new JSONArray();
                if (customerId != null && !customerId.equals("")) {
                    ArrayList < Object > list1 = adfunc.getManageRegistrationReport(systemId, Integer.parseInt(customerId), userId, lang,offset,vehicleNo);
                    jsonArray = (JSONArray) list1.get(0);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("assetRegistrationRoot", jsonArray);
                    } else {
                        jsonObject.put("assetRegistrationRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("assetRegistrationRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            }catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equalsIgnoreCase("addModifyRegisterInformation")) {
            try {
                String CustID = request.getParameter("CustID");
                String custName = request.getParameter("custName");
                String buttonValue = request.getParameter("buttonValue");
                String assetType = request.getParameter("assetType");
                String registrationNoFromJsp = request.getParameter("registrationNo");
                String groupId = request.getParameter("groupId");
                String groupName = request.getParameter("groupName");
                String assetModel = request.getParameter("assetModel");
                String ownerName = request.getParameter("ownerName");
                String ownerAddress = request.getParameter("ownerAddress");
                String ownerPhoneNo = request.getParameter("ownerPhoneNo");
                String ownerEmailId = request.getParameter("ownerEmailId");
                String assetId = request.getParameter("assetId");
                String custIdFormodify = request.getParameter("custIdFormodify");
                String SelectedCheckBox = request.getParameter("selectedCheckbox");
                String pageName=request.getParameter("pageName");
                String message = "";
                String unitNo = "";
                String mobileNo = "";
                String amount = "";
                if (request.getParameter("unitType").equals("None")) {
                    unitNo = "";
                } else {
                    unitNo = request.getParameter("unitType").trim();
                }
                if (request.getParameter("mobileNo").equals("None")) {
                    mobileNo = "";
                } else {
                    mobileNo = request.getParameter("mobileNo");
                }
                int ownerId = 0;
                if (request.getParameter("ownerId") != null && (!request.getParameter("ownerId").equals(""))) {
                    ownerId = Integer.parseInt(request.getParameter("ownerId"));
                }
                String registrationNo = registrationNoFromJsp.toUpperCase();
                
                if (request.getParameter("amount") != null){
                	amount = request.getParameter("amount");
                }else{
                	amount = null;
                }
                
                boolean isPrePaymentMode = adfunc.IsPrePaymentMode(systemId);
                
                if (buttonValue.equals("Add New")) {
                    if ((registrationNo != "" || !registrationNo.equals(""))) {
                    	registrationNo = registrationNo.trim();
                    	if (isPrePaymentMode){
                    		 message = adfunc.registerNewVehiclePrePaymentMode(assetType, registrationNo, Integer.parseInt(groupId), unitNo, mobileNo, systemId, userId,
                             		offset, Integer.parseInt(CustID), ltspName, groupName, custName, assetModel, ownerName, ownerAddress, ownerPhoneNo, assetId,
                             		zone, ownerId, SelectedCheckBox,pageName,sessionId,serverName,0,ownerEmailId,amount,"Registration","","",0);
                    	}else{
                    		
                            message = adfunc.registerNewVehicle(assetType, registrationNo, Integer.parseInt(groupId), unitNo, mobileNo, systemId, userId,
                            		offset, Integer.parseInt(CustID), ltspName, groupName, custName, assetModel, ownerName, ownerAddress, ownerPhoneNo, assetId,
                            		zone, ownerId, SelectedCheckBox,pageName,sessionId,serverName,0,ownerEmailId);
                    	}
                    	
                    	
                    }
                } else if (buttonValue.equals("Modify")) {
                        message = adfunc.modifyRegisteredVehicle(assetType, registrationNo, Integer.parseInt(groupId), unitNo, mobileNo, systemId,
                        		userId, offset, Integer.parseInt(CustID), ltspName, groupName, custName, assetModel, ownerName, ownerAddress, ownerPhoneNo, 
                        		assetId, Integer.parseInt(custIdFormodify), ownerId, SelectedCheckBox,pageName,sessionId,serverName,ownerEmailId);
                }
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equals("deleteRecord")) {
            try {
                String vehicleRegistrationNo = request.getParameter("vehicleRegistrationNo");
                String reason = request.getParameter("reason");
                String customerId = request.getParameter("custId");
                String custName = request.getParameter("custName");
                String assetType =request.getParameter("assettype");
                String pageName=request.getParameter("pageName");
                String unitNumber = "";
                if (request.getParameter("unitNumber").equals("None")) {
                    unitNumber = "";
                } else {
                    unitNumber = request.getParameter("unitNumber");
                }
                String message = "";
                if (customerId != null && !customerId.equals("")) {
                    message = adfunc.functionToDeleteVehicle(vehicleRegistrationNo, systemId, userId, ltspName, offset, reason, Integer.parseInt(customerId),
                    		userName, custName, unitNumber, assetType,pageName,sessionId,serverName,0,"");
                    response.getWriter().print(message);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        
        else if (param.equals("getOwnerNames")) {
            try {
                String customerId = request.getParameter("CustId");
                jsonObject = new JSONObject();
                if (customerId != null) {
                    jsonArray = adfunc.getOwnerNames(systemId, Integer.parseInt(customerId), userId);
                    jsonObject.put("ownerRoot", jsonArray);
                } else {
                    jsonObject.put("ownerRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        else if (param.equalsIgnoreCase("getReason")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                jsonArray = adfunc.getReason();
                if (jsonArray.length() > 0) {
                    jsonObject.put("reasonStoreRoot", jsonArray);
                } else {
                    jsonObject.put("reasonStoreRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
        else if (param.equalsIgnoreCase("getBlockedVehicleList")) {
            try {
            	String customerId = request.getParameter("CustId");
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                jsonArray = adfunc.getBlockedVehicleDetails(systemId,Integer.parseInt(customerId));
                if (jsonArray.length() > 0) {
                    jsonObject.put("blockedVehicleRoot", jsonArray);
                } else {
                    jsonObject.put("blockedVehicleRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }else if (param.equalsIgnoreCase("getMobileNoCLA")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String unitNumber = request.getParameter("unitNumber");
                jsonArray = adfunc.getMobileNumberCLA(systemId, userId,unitNumber);
                if (jsonArray.length() > 0) {
                    jsonObject.put("mobileNoRoot", jsonArray);
                } else {
                    jsonObject.put("mobileNoRoot", "");
                }
                response.getWriter().print(jsonObject.toString());
            } catch (Exception e) {
                e.printStackTrace();
            }
        }  
        else if(param.equals("viewAssetDetails")){
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String customerId = request.getParameter("CustId");
               jsonArray = adfunc.viewAssetDetails(systemId, userId, customerId);
               if (jsonArray != null) {
                   jsonObject.put("assetNoRoot", jsonArray);
               } else {
                   jsonObject.put("assetNoRoot", "");
               }
               response.getWriter().print(jsonObject.toString());
           } catch (Exception e) {
               e.printStackTrace();
           }
       }
        else if(param.equals("getPaymentTransaction")){
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                String customerId = request.getParameter("custId");
                String startDate = request.getParameter("startDate");
                String endDate = request.getParameter("endDate");
               jsonArray = adfunc.getPaymentTransaction(systemId, userId, Integer.parseInt(customerId),startDate,endDate,offset);
               if (jsonArray != null) {
                   jsonObject.put("paymentTransactionRoot", jsonArray);
               } else {
                   jsonObject.put("paymentTransactionRoot", "");
               }
               response.getWriter().print(jsonObject.toString());
           } catch (Exception e) {
               e.printStackTrace();
           }
       }else if(param.equals("resendPaymentLink")){
           try {
               String transactionId = request.getParameter("Id");
               String customerId = request.getParameter("custId");
               String msg = adfunc.resendPaymentLink(systemId, userId, Integer.parseInt(customerId),Integer.parseInt(transactionId),offset);
               response.getWriter().print(msg);
          } catch (Exception e) {
              e.printStackTrace();
          }
      }


        
       
        return null;
    }
}