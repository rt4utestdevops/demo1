package t4u.FFM;

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
import t4u.functions.FFMFunctions;

public class AddCustomerAction extends Action {
    public ActionForward execute(ActionMapping mapping, ActionForm form,
        HttpServletRequest request, HttpServletResponse response)
    throws Exception {
        HttpSession session = request.getSession();
        String param = "";
        String zone = "";
        int systemId = 0;
        int userId = 0;
        int offset = 0;

        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
        systemId = loginInfo.getSystemId();
        zone = loginInfo.getZone();
        userId = loginInfo.getUserId();
        offset = loginInfo.getOffsetMinutes();
        String lang = loginInfo.getLanguage();
        zone = loginInfo.getZone();
        FFMFunctions cvmf = new FFMFunctions();
        JSONArray jsonArray = null;
        JSONObject jsonObject = new JSONObject();
        if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        if (param.equalsIgnoreCase("getASM")) {
            try {
                String custID = request.getParameter("custId");
                jsonArray = new JSONArray();
                if (custID != null && !custID.equals("")) {
                    jsonArray = cvmf.getASM(Integer.parseInt(custID), systemId);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("asmRoot", jsonArray);
                    } else {
                        jsonObject.put("asmRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("asmRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
      
      	else if (param.equalsIgnoreCase("getProducts")) {
            try {
                String custID = request.getParameter("custId");
                jsonArray = new JSONArray();
                if (custID != null && !custID.equals("")) {
                    jsonArray = cvmf.getProducts(Integer.parseInt(custID), systemId);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("productRoot", jsonArray);
                    } else {
                        jsonObject.put("productRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("productRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }
      
      	else if (param.equalsIgnoreCase("getChannelPartner")) {
            try {
                String custID = request.getParameter("custId");

                jsonArray = new JSONArray();
                if (custID != null && !custID.equals("")) {

                    if (jsonArray.length() > 0) {
                        jsonObject.put("channelPartnerRoot", jsonArray);
                    } else {
                        jsonObject.put("channelPartnerRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("channelPartnerRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
      
      	else if (param.equalsIgnoreCase("getDST")) {
            try {
                String custID = request.getParameter("custId");
                jsonArray = new JSONArray();
                if (custID != null && !custID.equals("")) {

                    if (jsonArray.length() > 0) {
                        jsonObject.put("dstRoot", jsonArray);
                    } else {
                        jsonObject.put("dstRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("dstRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
      
      	else if (param.equalsIgnoreCase("getEmail")) {
            try {
                String custID = request.getParameter("custId");

                String location = request.getParameter("locationId");
                jsonArray = new JSONArray();
                if (custID != null && !custID.equals("")) {
                    jsonArray = cvmf.getEmail(Integer.parseInt(custID), systemId);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("emailRoot", jsonArray);
                    } else {
                        jsonObject.put("emailRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("emailRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } 
      
      	else if (param.equalsIgnoreCase("customerAddAndModify")) {
            try {

                String custId = request.getParameter("custId");
                String buttonValue = request.getParameter("buttonValue");
                int accType = Integer.parseInt(request.getParameter("accountType"));
                String firstMeetDate = request.getParameter("firstMeetDate");
                String visittype = request.getParameter("visittype");
                String accountName = request.getParameter("accountName");
                String accountsegment = request.getParameter("accountsegment");
                String customerName = request.getParameter("customerName");
                String mobileNo = request.getParameter("mobileNo");
                String landLineNo = request.getParameter("landLineNo");
                String emailId = request.getParameter("emailId");
                String accountstatus = request.getParameter("accountstatus");
                String customerstatus = request.getParameter("customerstatus");
                String products = request.getParameter("products");
                String amounts = request.getParameter("amounts");
                String message = "Inside action";
                String fmDate[] = firstMeetDate.split("T");
                String product[] = products.split(",");
                String amount[] = amounts.split(",");
                String accAddress = request.getParameter("accAddress");


                int refId = Integer.parseInt(request.getParameter("refId"));
                String accountType = "";
                if (accType == 1) {
                    accountType = "IOIP";
                } else {
                    accountType = "COCP";
                }
                if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
                    String asm = request.getParameter("asm");
                    String tsm = request.getParameter("tsm");
                    String channelpartner = request.getParameter("channelpartner");
                    String dst = request.getParameter("dst");
                    String escalation1 =request.getParameter("escalation1");
                    String escalation2 = request.getParameter("escalation2");
                    String escalation3 = request.getParameter("escalation3");
                    String escalation4 = request.getParameter("escalation4");

                    message = cvmf.insertCustomerInformation(Integer.parseInt(custId), accountType, fmDate[0], asm, tsm, channelpartner, dst, visittype, accountName, accAddress, accountsegment, customerName, mobileNo, landLineNo, emailId, accountstatus, customerstatus, escalation1,
                        escalation2, escalation3, escalation4, product, amount, systemId, offset);
                } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {

                    String asmModify = request.getParameter("asmModify");
                    String tsmModify =request.getParameter("tsmModify");
                    String channelpartnerModify = request.getParameter("channelPartnerModify");
                    String dstModify =request.getParameter("dstModify");
                    String visittypeModify = request.getParameter("visitTypeModify");
                    String accountsegmentModify = request.getParameter("accountsegmentModify");
                    String accountstatusModify = request.getParameter("accstatusModify");
                    String customerstatusModify = request.getParameter("customerstatusModify");
                    String escalation1Modify =request.getParameter("escalation1Modify");
                    String escalation2Modify = request.getParameter("escalation2Modify");
                    String escalation3Modify = request.getParameter("escalation3Modify");
                    String escalation4Modify =request.getParameter("escalation4Modify");

                    message = cvmf.updateCustomerInformation(Integer.parseInt(custId), accountType, fmDate[0], asmModify, tsmModify, channelpartnerModify, dstModify, visittypeModify, accountName, accAddress, accountsegmentModify, customerName, mobileNo, landLineNo, emailId, accountstatusModify, customerstatusModify, escalation1Modify,
                        escalation2Modify, escalation3Modify, escalation4Modify, product, amount, systemId, offset, refId);
                }
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
  
  		else if (param.equalsIgnoreCase("getCustomerDetails")) {
            try {
                String customerId = request.getParameter("custId");
                jsonArray = new JSONArray();
                if (customerId != null && !customerId.equals("")) {
                    ArrayList < Object > list1 = cvmf.getCustomerDetails(Integer.parseInt(customerId), systemId, offset);
                    jsonArray = (JSONArray) list1.get(0);
                    if (jsonArray.length() > 0) {
                        jsonObject.put("customerRoot", jsonArray);
                    } else {
                        jsonObject.put("customerRoot", "");
                    }
                    response.getWriter().print(jsonObject.toString());
                } else {
                    jsonObject.put("customerRoot", "");
                    response.getWriter().print(jsonObject.toString());
                }
            } catch (Exception e) {
                e.printStackTrace();
            }       
        }   		
  		else if (param.equalsIgnoreCase("deleteData")) {
            try {
                String customerId = request.getParameter("custId");
                int refId = Integer.parseInt(request.getParameter("refId"));
                String message = "Could Not Delete Data";
                if (customerId != null && !customerId.equals("")) {
                    message = cvmf.deleteData(Integer.parseInt(customerId), systemId, refId);
                } else {
                    response.getWriter().print(message);
                }
                response.getWriter().print(message);
            } catch (Exception e) {
                e.printStackTrace();
            }

        }        
        return null;
    }

}