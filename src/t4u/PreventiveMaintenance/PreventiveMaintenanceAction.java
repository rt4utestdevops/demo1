package t4u.PreventiveMaintenance;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.ss.formula.functions.Offset;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.PreventiveMaintenanceFunctions;

public class PreventiveMaintenanceAction extends Action{
	
	
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) throws Exception {
	    String param = "";
	    HttpSession session = request.getSession();
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    PreventiveMaintenanceFunctions PreventiveMaintenance = new PreventiveMaintenanceFunctions();
	    int offset=0;
	    int systemId = loginInfo.getSystemId();
	    String lang = loginInfo.getLanguage();
	    int userId = loginInfo.getUserId();
	    offset=loginInfo.getOffsetMinutes();
	    CommonFunctions cf = new CommonFunctions();
	    JSONArray jsonArray = null;
	    JSONObject jsonObject = new JSONObject();
	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }

	    /****************************************************TASK MASTER****************************************************************************************************************************************************************************/

	    if (param.equalsIgnoreCase("taskMasterAddModify")) {
	        try {
	            String custId = request.getParameter("CustID");
	            String buttonValue = request.getParameter("buttonValue");
	            String taskName = request.getParameter("taskName");
	            String type = request.getParameter("type");
	            String defaultDays = request.getParameter("defaultDays");
	            String defaultDistance = request.getParameter("defaultDistance");
	            String status = request.getParameter("status");
	            String id = request.getParameter("id");
	            String autoUpdate = request.getParameter("autoUpdate");
	            int detentionTime = 0;
	            if(request.getParameter("detentionTime") != null && !request.getParameter("detentionTime").equals("")){
	            	detentionTime = Integer.parseInt(request.getParameter("detentionTime"));
	            }
	            String message = "";

	            int thersholdDays = Integer.parseInt(defaultDays) - (int)(((float) 10 / 100) * Integer.parseInt(defaultDays));
	            int thersholdDistance = Integer.parseInt(defaultDistance) - (int)(((float) 10 / 100) * Integer.parseInt(defaultDistance));

	            if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
	                message = PreventiveMaintenance.insertTaskMasterInformation(taskName, type, defaultDays, defaultDistance, status, Integer.parseInt(custId), systemId, thersholdDays, thersholdDistance,autoUpdate,detentionTime);
	            } else if (buttonValue.equals("Modify") && custId != null && !custId.equals("")) {
	                message = PreventiveMaintenance.modifyTaskMasterInformation(Integer.parseInt(id), taskName, type, defaultDays, defaultDistance, status, Integer.parseInt(custId), systemId, thersholdDays, thersholdDistance,autoUpdate,detentionTime);
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } else if (param.equalsIgnoreCase("getTaskMasterDetails")) {
	        try {
	            String jspName = request.getParameter("jspName");
	            String custId = request.getParameter("CustID");
	            String CustName = request.getParameter("custName");
	            jsonArray = new JSONArray();
	            if (custId != null && !custId.equals("")) {
	                ArrayList < Object > list1 = PreventiveMaintenance.getTaskMasterDetails(Integer.parseInt(custId), systemId, lang);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("taskMasterRoot", jsonArray);
	                } else {
	                    jsonObject.put("taskMasterRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("custId", CustName);
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }


	    /********************************************************MANAGE TASKS*************************************************************************************************/
	    else if (param.equalsIgnoreCase("getAssetNumber")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String alertType = request.getParameter("Type");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            if (customerId != null && !customerId.equals("")) {

	                jsonArray = PreventiveMaintenance.getAssetNumberDetails(systemId, Integer.parseInt(customerId), userId,alertType);

	                if (jsonArray.length() > 0) {
	                    jsonObject.put("managerAssetRoot", jsonArray);
	                } else {
	                    jsonObject.put("managerAssetRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("managerAssetRoot", "");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    else if (param.equalsIgnoreCase("manageTaskAddModify")) {

	        try {
	            String customerId = request.getParameter("CustId");
	            String buttonValue = request.getParameter("buttonValue");
	            String assetNumber = request.getParameter("assetNumber");
	            String taskName = request.getParameter("taskName");
	            String distance = request.getParameter("distance");
	            String days = request.getParameter("days");
	            String threshouldDistance = request.getParameter("threshouldDistance");
	            String threshouldDays = request.getParameter("threshouldDays");
	            String lastServiceDate = request.getParameter("lastServiceDate");
	            String id = request.getParameter("id");
	            String message = "";

	            if (buttonValue.equals("Add") && customerId != null && !customerId.equals("")) {
	                message = PreventiveMaintenance.insertManageTaskDetails(taskName, distance, days, threshouldDistance, threshouldDays, lastServiceDate, systemId, Integer.parseInt(customerId), assetNumber, userId, offset);
	            } else if (buttonValue.equals("Modify") && customerId != null && !customerId.equals("")) {
	                message = PreventiveMaintenance.modifyManageTaskDetails(Integer.parseInt(id), assetNumber, taskName, distance, days, threshouldDistance, threshouldDays, lastServiceDate, systemId, Integer.parseInt(customerId), userId);
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } 
	    
	    else if (param.equalsIgnoreCase("getTaskNameList")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String taskId = request.getParameter("taskId");
	            String assetNumber = request.getParameter("assetNumber");
	             jsonObject = new JSONObject();
	            if (customerId != null && !customerId.equals("")) {
	                jsonArray = PreventiveMaintenance.getTaskNameList(systemId, Integer.parseInt(customerId),taskId,assetNumber);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("taskNameList", jsonArray);
	                } else {
	                    jsonObject.put("taskNameList", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("taskNameList", "");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } 
	    
	    else if (param.equalsIgnoreCase("getManageTasksDetails")) {
	        try {
	            String assetNumber = request.getParameter("assetNumber");
	            String custId = request.getParameter("CustId");
	            String CustName = request.getParameter("custName");
	            String jspName = request.getParameter("jspName");
	            jsonArray = new JSONArray();
	            if (custId != null && !custId.equals("")) {
	                ArrayList < Object > list1 = PreventiveMaintenance.getManageTasksDetails(Integer.parseInt(custId), systemId, assetNumber, lang, offset);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("manageTasksRoot", jsonArray);
	                } else {
	                    jsonObject.put("manageTasksRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("custId", CustName);
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } 
	    
	    else if (param.equalsIgnoreCase("getAssetNumberAndModelToCopyDetails")) {
	        try {
	            String customerId = request.getParameter("CustId");
	            String assetNumber = request.getParameter("assetNumber");
	            jsonArray = new JSONArray();
	            jsonObject = new JSONObject();
	            String reg = "";
	            if (customerId != null && !customerId.equals("")) {
	                jsonArray = PreventiveMaintenance.getAssetNumberAndModelToCopyDetails(Integer.parseInt(customerId), systemId, userId, assetNumber);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("copyRoot", jsonArray);
	                } else {
	                    jsonObject.put("copyRoot", "");
	                }
	                response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("copyRoot", "");
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } 
	    
	    else if (param.equalsIgnoreCase("saveCopyDetails")) {
	        String message = "";
	        String customerId = request.getParameter("CustId");
	        String buttonValue = request.getParameter("buttonValue");
	        String saveManageData = request.getParameter("manageDataSaveParam");
	        String s = request.getParameter("gridData");
	       // String taskName = request.getParameter("taskName");
	        try {
	            if (saveManageData != null && !saveManageData.equals("") && customerId != null && !customerId.equals("")) {
	                String st1 = "[" + saveManageData + "]";
	                JSONArray fuelJs = null;
	                if (s != null) {
	                    String st = "[" + s + "]";
	                    JSONArray manageGridData = null;
	                    try {
	                        fuelJs = new JSONArray(st1.toString());
	                        manageGridData = new JSONArray(st.toString());
	                        if (fuelJs.length() > 0 && manageGridData.length() > 0 && buttonValue.equals("Replicate")) {
	                            message = PreventiveMaintenance.saveCopyDetails(Integer.parseInt(customerId), systemId, userId, fuelJs, manageGridData,offset);
	                        } else {
	                            message = "";
	                        }
	                    } catch (Exception e) {
	                        e.printStackTrace();
	                    }
	                }
	            } else {
	                message = "No Data To Save";
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }

	    /***********************************************************************EXPIRING SOON**********************************************************************************************************************/
	    else if (param.equalsIgnoreCase("saveExpiringSoonDetails")) {

	        try {
	        	String buttonValue = request.getParameter("buttonValue");
	            String customerId = request.getParameter("CustId");
	            String assetNumber = request.getParameter("assetNumber");
	            String lastServiceDate = request.getParameter("lastServiceDate");
	            String taskId = request.getParameter("taskId");
	            String Remarks = request.getParameter("Remarks");
	            String message = "";
	            if (buttonValue.equals("ExpiryRenew") && customerId != null && !customerId.equals("")) {
	            	int typeOfAlert = 2;
	                message = PreventiveMaintenance.modifyExpiringSoonDetails(assetNumber,lastServiceDate,systemId, Integer.parseInt(customerId),userId,Integer.parseInt(taskId),Remarks,typeOfAlert);
	            } else if(buttonValue.equals("ExpiredRenew") && customerId != null && !customerId.equals("")) {
	            	int typeOfAlert = 1;
	                message = PreventiveMaintenance.modifyExpiringSoonDetails(assetNumber,lastServiceDate,systemId, Integer.parseInt(customerId),userId,Integer.parseInt(taskId),Remarks,typeOfAlert);
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } 
	    
	    else if (param.equalsIgnoreCase("getExpiringSoonDetails")) {
	        try {
	            String jspName = request.getParameter("jspName");
	            String custId = request.getParameter("CustId");
	            String assetNumber = request.getParameter("assetNumber");
	            String CustName = request.getParameter("custName");
	            jsonArray = new JSONArray();
	            if (custId != null && !custId.equals("")) {
	                ArrayList < Object > list1 = PreventiveMaintenance.getExpiringSoonDetails(Integer.parseInt(custId), systemId, lang,assetNumber,offset);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("expiringSoonRoot", jsonArray);
	                } else {
	                    jsonObject.put("expiringSoonRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("custId", CustName);
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    /**************************************************************ALREADY EXPIRED*******************************************************************************************************************************************************************/
//	    else if (param.equalsIgnoreCase("saveAlreadyExpiredDetails")) {
//
//	    try {
//        	String buttonValue = request.getParameter("buttonValue");
//            String customerId = request.getParameter("CustId");
//            String assetNumber = request.getParameter("assetNumber");
//            String lastServiceDate = request.getParameter("lastServiceDate");
//            String taskId = request.getParameter("taskId");
//            String Remarks = request.getParameter("Remarks");
//            String message = "";
//
//            if (buttonValue.equals("Renew") && customerId != null && !customerId.equals("")) {
//            	int typeOfAlert = 1;
//                message = PreventiveMaintenance.modifyAlreadyExpiredDetails(assetNumber,lastServiceDate,systemId, Integer.parseInt(customerId),userId,Integer.parseInt(taskId),Remarks);
//            }
//            response.getWriter().print(message);
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    } 
	    
	    else if (param.equalsIgnoreCase("getAlreadyExpiredDetails")) {
	        try {
	            String custId = request.getParameter("CustId");
	            String assetNumber = request.getParameter("assetNumber");
	            jsonArray = new JSONArray();
	            if (custId != null && !custId.equals("")) {
	                ArrayList < Object > list1 = PreventiveMaintenance.getAlreadyExpiredDetails(Integer.parseInt(custId), systemId, lang,assetNumber, offset);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("expiringSoonRoot", jsonArray);
	                } else {
	                    jsonObject.put("expiringSoonRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }


	    /**********************************************************TASKS HISTORY***********************************************************************************************************************************************************************************/
	    else if (param.equalsIgnoreCase("getTasksHistoryDetails")) {
	        try {
	            String custId = request.getParameter("CustId");
	            String assetNumber = request.getParameter("assetNumber");
	            jsonArray = new JSONArray();
	            if (custId != null && !custId.equals("")) {
	                ArrayList < Object > list1 = PreventiveMaintenance.getTasksHistoryDetails(Integer.parseInt(custId), systemId, lang,assetNumber,offset);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("tasksHistoryRoot", jsonArray);
	                } else {
	                    jsonObject.put("tasksHistoryRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
//***********************************Preventive Maintenannce Report**********************************************************************************************************//	    
	    
	    else if (param.equalsIgnoreCase("getPreventiveMaintenanceReport")) {
	        try {
	            String custId = request.getParameter("CustId");
	            String custName = request.getParameter("custName");
	            String startDate = request.getParameter("startDate");
	            String endDate = request.getParameter("endDate");
	            String jspName = request.getParameter("jspName");
	            String type = request.getParameter("type");
	            String type1="";
	            if(type!=null)
	            {
		            if(type.equals("1"))
	            {
	            	type1="Service OverDue";
	            }
	            else if(type.equals("2"))
	            {
	            	type1="Due For Renewal";
	            }else
	            {
	            	type1="Service History";
	            }
	            }
	            jsonArray = new JSONArray();
	            if (custId != null && !custId.equals("")) {
	                ArrayList < Object > list1 = PreventiveMaintenance.getPreventiveMaintenanceReport(Integer.parseInt(custId), systemId, lang,Integer.parseInt(type),offset,startDate,endDate,userId);
	                jsonArray = (JSONArray) list1.get(0);
	                if (jsonArray.length() > 0) {
	                    jsonObject.put("preventiveMaintenanceRoot", jsonArray);
	                } else {
	                    jsonObject.put("preventiveMaintenanceRoot", "");
	                }
	                ReportHelper reportHelper = (ReportHelper) list1.get(1);
	                request.getSession().setAttribute(jspName, reportHelper);
	                request.getSession().setAttribute("custId", custName);
	                request.getSession().setAttribute("type", type1);
	                request.getSession().setAttribute("startDate",cf.getFormattedDate(startDate.replaceAll("T", " ")));
		    		request.getSession().setAttribute("endDate",cf.getFormattedDate(endDate.replaceAll("T", " ")));
		    		
		    		response.getWriter().print(jsonObject.toString());
	            } else {
	                jsonObject.put("preventiveMaintenanceRoot", "");
	                response.getWriter().print(jsonObject.toString());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	    
	    
	    else if (param.equalsIgnoreCase("savePostponeDetails")) {

	        try {
	        	String buttonValue = request.getParameter("buttonValueForPostPone");
	            String customerId = request.getParameter("customerIdForPostPone");
	            String assetNumber = request.getParameter("assetNumberForPostPone");
	            String postponeDate = request.getParameter("postponeDate");
	            String taskId = request.getParameter("taskIdForPostPone");
	            String reason = request.getParameter("reasonForPostPone");
	            String message = "";
	            String typeOfAlert="1";
	            if (buttonValue.equals("Postpone") && customerId != null && !customerId.equals("")) {
	                message = PreventiveMaintenance.updatePostponeDetails(assetNumber,postponeDate,systemId, Integer.parseInt(customerId),userId,Integer.parseInt(taskId),reason,Integer.parseInt(typeOfAlert));
	            }
	            response.getWriter().print(message);
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    } 
	    
	    
	    return null;
	}
	}