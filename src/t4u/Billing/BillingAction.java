package t4u.Billing;

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
import t4u.functions.BillingFunctions;
import t4u.functions.CommonFunctions;


public class BillingAction extends Action{
	

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String param = "";
	    String zone = "";
	    int systemId = 0;
	    int userId = 0;
	    int offset = 0;
	    HttpSession session = request.getSession();
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    BillingFunctions billing = new BillingFunctions();
	    systemId = loginInfo.getSystemId();
	    //String lang = loginInfo.getLanguage();
	    zone = loginInfo.getZone();
	    userId = loginInfo.getUserId();
	    offset = loginInfo.getOffsetMinutes();
	    String lang = loginInfo.getLanguage();
	    zone = loginInfo.getZone();
	    CommonFunctions cf = new CommonFunctions();
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();
	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
	    
	    if (param.equals("getLtsp")) {
	        try {
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            jsonArray = billing.getLtsp(systemId);
	            if (jsonArray.length() > 0) {
	                jsonObject.put("lpstRoot", jsonArray);
	            } else {
	                jsonObject.put("lpstRoot", "");
	            }
	            response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } 
	    
	    else if (param.equalsIgnoreCase("getBillingReport")) {
	        try {
	            String ltspId = request.getParameter("ltspId");
	            String ltspName = request.getParameter("ltspName");
	            String jspName = request.getParameter("jspName");
	            String invoiceNo = request.getParameter("invoiceNo");
	            String month = request.getParameter("month");
	            String billYear = request.getParameter("billYear");
	            String InvoiceNo="";
	            String months = "";
	            String monthForQuery = "";
	            String  nextMonthInsertedDate ="";
	            int invoiceNo1;
	            if (month == null) {
	                month = "";
	            }
	            if (month.equals("January")) {
	                months = "0";
	                monthForQuery = "01";
	            }
	            if (month.equals("February")) {
	                months = "1";
	                monthForQuery = "02";
	            }
	            if (month.equals("March")) {
	                months = "2";
	                monthForQuery = "03";
	            }
	            if (month.equals("April")) {
	                months = "3";
	                monthForQuery = "04";
	            }
	            if (month.equals("May")) {
	                months = "4";
	                monthForQuery = "05";
	            }
	            if (month.equals("June")) {
	                months = "5";
	                monthForQuery = "06";
	            }
	            if (month.equals("July")) {
	                months = "6";
	                monthForQuery = "07";
	            }
	            if (month.equals("August")) {
	                months = "7";
	                monthForQuery = "08";
	            }
	            if (month.equals("September")) {
	                months = "8";
	                monthForQuery = "09";
	            }
	            if (month.equals("October")) {
	                months = "9";
	                monthForQuery = "10";
	            }
	            if (month.equals("November")) {
	                months = "10";
	                monthForQuery = "11";
	            }
	            if (month.equals("December")) {
	                months = "11";
	                monthForQuery = "12";
	            }
	            
	            String insertedDate = billYear+"-"+monthForQuery+"-"+"01";
	            jsonArray = new JSONArray();
	            if (ltspId != null && !ltspId.equals("")) {
	                ArrayList < Object > list1 = billing.getBillingReport(Integer.parseInt(ltspId), invoiceNo, lang, Integer.parseInt(months),insertedDate);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("billingreportRoot", jsonArray);
	                } else {
	                    jsonObject.put("billingreportRoot", "");
	                }
	                
	                invoiceNo1=Integer.parseInt(invoiceNo);
	        		
	        		if(invoiceNo1<10){
	        			 InvoiceNo="000"+invoiceNo1;
	        		}
	        		else if(invoiceNo1<100){
	        			 InvoiceNo="00"+invoiceNo1;
	        		}
	        		else if(invoiceNo1<1000){
	        			 InvoiceNo="0"+invoiceNo1;
	        		}
	        		else {
	        			InvoiceNo=""+invoiceNo1;
	        		}
	        		
	        		String currentyear = billYear.substring(Math.max(billYear.length() - 2, 0));
	     			int nextYear = Integer.parseInt(currentyear)+1;
	     			InvoiceNo="T4U/"+currentyear+"-"+nextYear+"/SUB/"+InvoiceNo;
	     			
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("ltspId", ltspName);
	                request.getSession().setAttribute("month", month);
	                request.getSession().setAttribute("billYear", billYear);
	                request.getSession().setAttribute("InvoiceNo", InvoiceNo);
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("billingreportRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    if (param.equals("getInvoiceNumber")) {
	        try {
	            jsonArray = new JSONArray();
	            String ltspId = request.getParameter("ltspId");
	            String billMonth = request.getParameter("billMonth");
	            String billYear = request.getParameter("billYear");
	            if (billMonth.equals("January")) {
	                billMonth = "1";
	            }
	            if (billMonth.equals("February")) {
	                billMonth = "2";
	            }
	            if (billMonth.equals("March")) {
	                billMonth = "3";
	            }
	            if (billMonth.equals("April")) {
	                billMonth = "4";
	            }
	            if (billMonth.equals("May")) {
	                billMonth = "5";
	            }
	            if (billMonth.equals("June")) {
	                billMonth = "6";
	            }
	            if (billMonth.equals("July")) {
	                billMonth = "7";
	            }
	            if (billMonth.equals("August")) {
	                billMonth = "8";
	            }
	            if (billMonth.equals("September")) {
	                billMonth = "9";
	            }
	            if (billMonth.equals("October")) {
	                billMonth = "10";
	            }
	            if (billMonth.equals("November")) {
	                billMonth = "11";
	            }
	            if (billMonth.equals("December")) {
	                billMonth = "12";
	            }
	            jsonObject = new JSONObject();
	            if (ltspId != null && !ltspId.equals("")) {
	                jsonArray = billing.getInvoiceNumber(ltspId, billMonth, billYear);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("invoiceRoot", jsonArray);
	                } else {
	                    jsonObject.put("invoiceRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("invoiceRoot", "");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    if (param.equals("getMonth")) {
	        try {
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            jsonArray = billing.getMonth();
	            if (jsonArray.length() > 0) {
	                jsonObject.put("monthRoot", jsonArray);
	            } else {
	                jsonObject.put("monthRoot", "");
	            }
	            response.getWriter().print(jsonObject.toString());
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    return null;
	}
	}