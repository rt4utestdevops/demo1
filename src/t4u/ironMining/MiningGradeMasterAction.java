package t4u.ironMining;



import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.formula.functions.Offset;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.AdminFunctions;
import t4u.functions.IronMiningFunction;

public class MiningGradeMasterAction extends Action{
	

	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String param = "";
	    HttpSession session = request.getSession();
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    IronMiningFunction gradeMaster = new IronMiningFunction();
	    int systemId = loginInfo.getSystemId();
	    String lang = loginInfo.getLanguage();
	    int userId = loginInfo.getUserId();
	    CommonFunctions cf = new CommonFunctions();
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();

	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
 //*************************************************Grade Mater Details **********************************************************************************************************//	    
	     if  (param.equalsIgnoreCase("getGradeMasterDetails")) {
	        try {
	            String CustId= request.getParameter("CustId");
	            String custName= request.getParameter("CustName");
	            String jspName= request.getParameter("jspName");
	            jsonArray = new JSONArray();
	            if (CustId != null && !CustId.equals("")) {
	                ArrayList < Object > list = gradeMaster.getGradeMasterDetails( systemId ,lang,Integer.parseInt(CustId) );
	                jsonArray = (JSONArray) list.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("getGradeMasterDetails", jsonArray); 
	                } else {
	                    jsonObject.put("getGradeMasterDetails", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("custName", custName);
					request.getSession().setAttribute("reportName", "Grade Master Details");
	                response.getWriter().print(jsonObject.toString());   
	             
	            }
	            else {
	                jsonObject.put("getGradeMasterDetails", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	            
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	 }
 //-------------------------------------Insert Grade Information-----------------------------------------------------------//
	     else if (param.equalsIgnoreCase("gradeMasterAddModify")) {
		        try {
		        	 String CustId= request.getParameter("CustID");
		        	 String buttonValue = request.getParameter("buttonValue");
		        	String month = request.getParameter("month");
		        	String year = request.getParameter("year");
		        	String grade = request.getParameter("grade");
		        	String rate = request.getParameter("rate");
		        	String mineralCode = request.getParameter("mineral");
		        	String id = request.getParameter("id");
		        	String json = request.getParameter("json");
		        	String typenew="";
		        	if(mineralCode.equalsIgnoreCase("Fe")){
		        		typenew = request.getParameter("type");
		        	}
		        	else{
		        		typenew=request.getParameter("type1");
		        	}
					JSONArray js = null;
					String message = "";
					if(json!=null  && (!json.equals("")))
					{
						String st = "["+ json +"]";
						try
						{
							js = new JSONArray(st.toString());
						}
						catch (JSONException e)
					    {
							e.printStackTrace();
						}
					}
//					if(js.length()>0){
		            
		            if (buttonValue.equals("Add") && CustId != null && !CustId.equals("") && js.length()>0) {
		                message = gradeMaster.insertGradeMasterInformations(month, Integer.parseInt(year) ,js, mineralCode, typenew, Integer.parseInt(CustId),systemId,userId);
		            }
					
		            else if (buttonValue.equals("Modify")&& CustId != null && !CustId.equals("")) {
		                message = gradeMaster.modifyGradeMasterInformation(Integer.parseInt(id),month, Integer.parseInt(year), grade,Double.parseDouble(rate), mineralCode, typenew, Integer.parseInt(CustId),systemId,userId);
		            }
		            response.getWriter().print(message);
//		        }
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
		    } 
	//*****************************************************Mineral_Code Information ******************************************************//
	     else if (param.equals("getMineralCode")) {
	    	 try {
	    		 String CustId = request.getParameter("CustId");
	    		 jsonArray = new JSONArray();
	    		 jsonObject = new JSONObject();
	    		 if (CustId != null && !CustId.equals("")) {
	    			 jsonArray = gradeMaster.getMineralCode(systemId,Integer.parseInt(CustId));
	    			 if (jsonArray.length() > 0) {
	    				 jsonObject.put("mineralCodeRoot", jsonArray);
	    			 } else {
	    				 jsonObject.put("mineralCodeRoot", "");
	    			 }
	    			 response.getWriter().print(jsonObject.toString());
	    		 }
	    		 else {
	    			 jsonObject.put("mineralCodeRoot", "");
	    		 }
	    	 } catch (Exception e) {
	    		 e.printStackTrace();
	    	 }
	     } 
	     
       //***********************************Get Grade***********************************************************//
	     else if (param.equals("getGrade")) {
	    	 try {
	    		 String mineral =request.getParameter("mineral");
	    		 jsonArray = new JSONArray();
	    		 jsonObject = new JSONObject();
	    		
	    			 jsonArray = gradeMaster.getGrade(mineral);
	    			 if (jsonArray.length() > 0) {
	    				 jsonObject.put("gradeRoot", jsonArray);
	    			 } else {
	    				 jsonObject.put("gradeRoot", "");
	    			 }
	    			 response.getWriter().print(jsonObject.toString());
	    		 
	    	 } catch (Exception e) {
	    		 e.printStackTrace();
	    	 }
	     }
	     
	     //*************************************get grid data*********************************************//
	     else if (param.equalsIgnoreCase("getGridData")) {
	    		try {
	    			ArrayList list=null;
	    			String CustomerId = request.getParameter("CustID");
	    			String mineralCode= request.getParameter("mineralCode");
	    			String mineralType= request.getParameter("mineralType");
	    			jsonArray = new JSONArray();
	    			jsonObject = new JSONObject();
	    			if (CustomerId != null && !CustomerId.equals("")) {
	    				list =gradeMaster.getGridDataForMineGrade(mineralCode,mineralType);
	    				jsonArray = (JSONArray) list.get(0);
	    				if (jsonArray.length() > 0) {
	    					jsonObject.put("gradeRoot", jsonArray);
	    				} else {
	    					jsonObject.put("gradeRoot", "");
	    				}
	    				response.getWriter().print(jsonObject.toString());
	    			} else {
	    				jsonObject.put("gradeRoot", "");
	    				response.getWriter().print(jsonObject.toString());
	    			}
	    		} catch (Exception e) {
	    			e.printStackTrace();
	    		}
	    			}
	     
	     return null;
	}
	
	}
