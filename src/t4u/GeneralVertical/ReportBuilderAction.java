package t4u.GeneralVertical;
import java.util.Properties;

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
import t4u.common.ApplicationListener;
import t4u.functions.CommonFunctions;
import t4u.functions.ReportBuilderFunctions;
import t4u.functions.ReportBuilderPDFFunction;

public class ReportBuilderAction extends Action{
	String key="";
	
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = 0;
			int clientId = 0;
			int userId = 0;
			int offset = 0;
			String zone = "";
			Properties properties = ApplicationListener.prop;
			CommonFunctions cf=new CommonFunctions();
			String serverName=req.getServerName();
			String sessionId = req.getSession().getId();
			if( properties.getProperty("GoogleMapApiKey") != null){
				key = properties.getProperty("GoogleMapApiKey").trim();
			}
			if(loginInfo != null){
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				userId = loginInfo.getUserId();
				offset = loginInfo.getOffsetMinutes();
				zone = loginInfo.getZone();
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			ReportBuilderFunctions rbFunc = new ReportBuilderFunctions();
			ReportBuilderPDFFunction rbFuncPDF = new ReportBuilderPDFFunction();
			
			String param = "";
			if(req.getParameter("param") != null){
				param = req.getParameter("param");
			}
			if(param.equals("getVehicleNo")){
				try{
					obj = rbFunc.getUserVehicles(systemId,clientId,userId,zone);
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getReportMaster")){
				try{
					obj = new JSONObject();
					jArr = rbFunc.getReportMaster(systemId,clientId,userId);
					if(jArr.length() > 0){
						obj.put("reportJanon", jArr);
					}else{
						obj.put("reportJanon", "");
					}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("generateReport")){
				String categoryId = req.getParameter("categoryId");
				String parameterSelectedNew = req.getParameter("parameterSelectedNew");//"truck,truckOEM";// for multiSelect reports
				String reportId = req.getParameter("reportId"); //"23,24" ;//
				String parameterSelected = req.getParameter("parameterSelected"); // for single select reports
				String vehicleNo = req.getParameter("vehicles"); // array
				String startDate = req.getParameter("startDate")+" 00:00:00";
				String endDate = req.getParameter("endDate")+" 23:59:59";
				String trips = req.getParameter("trips");
				String radius = req.getParameter("radius");
				try{
					obj = new JSONObject();
					if(categoryId != null && categoryId.equals("5")){
						jArr = rbFunc.generateMultipleReports(systemId,clientId,categoryId,reportId,parameterSelectedNew,vehicleNo,startDate,endDate,trips,offset);
					}
					else if (categoryId != null && categoryId.equals("1")){
						jArr = rbFunc.generateMultipleReportsForUnAssignedPlacement(systemId,clientId,categoryId,reportId,parameterSelectedNew,vehicleNo,startDate,endDate,trips,offset);
					}
					else if (categoryId != null && categoryId.equals("2")){
						jArr = rbFunc.generateMultipleReportsForLoading(systemId,clientId,categoryId,reportId,parameterSelectedNew,vehicleNo,startDate,endDate,trips,offset);
					}
					else if (categoryId != null && categoryId.equals("3")){
						jArr = rbFunc.generateMultipleReportsForOnRoute(systemId,clientId,categoryId,reportId,parameterSelectedNew,vehicleNo,startDate,endDate,trips,offset);
					}
					else if(reportId.equals("30") || reportId.equals("38") || reportId.equals("39") || reportId.equals("2") || reportId.equals("40") || reportId.equals("41") ||reportId.equals("43")
							||reportId.equals("20")||reportId.equals("21") ||reportId.equals("22") ||reportId.equals("50")){
						jArr = rbFunc.getGenerateReportDetailsUsingVehicleActivity(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}else if(reportId.equals("42")){
						jArr = rbFunc.getGenerateReportDetails1(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}else if(reportId.equals("45") || "48".equals(reportId) || "60".equals(reportId)) {
						jArr = rbFunc.getReportWithRegistrationNo(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}else if(reportId.equals("44")) {// needs to updated to 44
						jArr = rbFunc.getEmployeeSwipeDetailsReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}else if(reportId.equals("46")) {
						jArr = rbFunc.consolidatedDelayReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset,userId);
					}else if(reportId.equals("47")){
						if(radius != null && !radius.equals("") && !radius.equals("0") && vehicleNo.split(",").length==1)//vehicleNo is Hub in this case,single selection required
						{
							jArr = rbFunc.getIncomingVehicleReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset,Integer.parseInt(radius),key);
						}
					}else if(reportId.equals("51")){
						jArr = rbFunc.getLoadingUnloadingTimeReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}else if(reportId.equals("54")){
						jArr = rbFunc.getUnloadingToNextLoadReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}else if(reportId.equals("55")){
						jArr = rbFunc.getGenerateReportDetailsFromTrackTrip(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}else if(reportId.equals("56")){
						jArr = rbFunc.getUnloadingTimeDetentionReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}else if(reportId.equals("57")){
						jArr = rbFunc.getGenerateDryRunKmReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}else if(reportId.equals("58") || reportId.equals("59")){
						jArr = rbFunc.getGenerateReportDetailsFromTrackTrip(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}
					else {
						jArr = rbFunc.getGenerateReportDetails(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
					}
					if(jArr.length() > 0){
						obj.put("tableReponsejson", jArr);
					}else{
						obj.put("tableReponsejson", "");
					}
					resp.getWriter().print(obj.toString());
					
					cf.insertDataIntoAuditLogReport(sessionId, null, "Report Builder", "View", userId, serverName, systemId, clientId,
					"Visited This Page");
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getExcelData")){
				try{
					obj = new JSONObject();
//					String tableData = req.getParameter("gridData");
//					String reportName = req.getParameter("reportName");
//					String startDate = req.getParameter("startDate");
//					String endDate = req.getParameter("endDate");
//					String reportInfo = req.getParameter("reportInfo");
					String message = "";//rbFunc.DownloadExcel(systemId,clientId,userId,tableData,reportName,startDate,endDate,reportInfo);
					resp.getWriter().print(message);
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getPDFReportData")){
				try{
					obj = new JSONObject();
//					String tableData = req.getParameter("gridData");
//					String reportName = req.getParameter("reportName");
//					String startDate = req.getParameter("startDate");
//					String endDate = req.getParameter("endDate");
//					String reportInfo = req.getParameter("reportInfo");
					String message = "";//rbFuncPDF.DownloadPDF(systemId,clientId,userId,tableData,reportName,startDate,endDate,reportInfo);
					resp.getWriter().print(message);
				}catch(Exception e){
					System.out.println("Exception creating pdf : " + e);
					e.printStackTrace();
				}
			}else if (param.equalsIgnoreCase("exportData")){
					String typeParam1= req.getParameter("typeParam1");
					String categoryId = req.getParameter("categoryId");
					String parameterSelectedNew = req.getParameter("parameterSelectedNew");//"truck,truckOEM";// for multiSelect reports
					String reportId = req.getParameter("reportId"); //"23,24" ;//
					String parameterSelected = req.getParameter("parameterSelected"); // for single select reports
					String vehicleNo = req.getParameter("vehicles"); // array
					String startDate = req.getParameter("startDate")+" 00:00:00";
					String endDate = req.getParameter("endDate")+" 23:59:59";
					String trips = req.getParameter("trips");
					String radius = req.getParameter("radius");
					String reportName = req.getParameter("reportName");
					String reportInfo = req.getParameter("reportInfo");
					
						obj = new JSONObject();
						if(categoryId != null && categoryId.equals("5")){
							jArr = rbFunc.generateMultipleReports(systemId,clientId,categoryId,reportId,parameterSelectedNew,vehicleNo,startDate,endDate,trips,offset);
						}
						else if (categoryId != null && categoryId.equals("1")){
							jArr = rbFunc.generateMultipleReportsForUnAssignedPlacement(systemId,clientId,categoryId,reportId,parameterSelectedNew,vehicleNo,startDate,endDate,trips,offset);
						}
						else if (categoryId != null && categoryId.equals("2")){
							jArr = rbFunc.generateMultipleReportsForLoading(systemId,clientId,categoryId,reportId,parameterSelectedNew,vehicleNo,startDate,endDate,trips,offset);
						}
						else if (categoryId != null && categoryId.equals("3")){
							jArr = rbFunc.generateMultipleReportsForOnRoute(systemId,clientId,categoryId,reportId,parameterSelectedNew,vehicleNo,startDate,endDate,trips,offset);
						}
						else if(reportId.equals("30") || reportId.equals("38") || reportId.equals("39") || reportId.equals("2") || reportId.equals("40") || reportId.equals("41") ||reportId.equals("43")
								||reportId.equals("20")||reportId.equals("21") ||reportId.equals("22") ||reportId.equals("50")){
							jArr = rbFunc.getGenerateReportDetailsUsingVehicleActivity(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}else if(reportId.equals("42")){
							jArr = rbFunc.getGenerateReportDetails1(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}else if(reportId.equals("45") || "48".equals(reportId) || "60".equals(reportId)) {
							jArr = rbFunc.getReportWithRegistrationNo(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}else if(reportId.equals("44")) {// needs to updated to 44
							jArr = rbFunc.getEmployeeSwipeDetailsReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}else if(reportId.equals("46")) {
							jArr = rbFunc.consolidatedDelayReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset,userId);
						}else if(reportId.equals("47")){
							if(radius != null && !radius.equals("") && !radius.equals("0") && vehicleNo.split(",").length==1)//vehicleNo is Hub in this case,single selection required
							{
								jArr = rbFunc.getIncomingVehicleReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset,Integer.parseInt(radius),key);
							}
						}else if(reportId.equals("51")){
							jArr = rbFunc.getLoadingUnloadingTimeReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}else if(reportId.equals("54")){
							jArr = rbFunc.getUnloadingToNextLoadReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}else if(reportId.equals("55")){
							jArr = rbFunc.getGenerateReportDetailsFromTrackTrip(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}else if(reportId.equals("56")){
							jArr = rbFunc.getUnloadingTimeDetentionReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}else if(reportId.equals("57")){
							jArr = rbFunc.getGenerateDryRunKmReport(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}else if(reportId.equals("58") || reportId.equals("59")){
							jArr = rbFunc.getGenerateReportDetailsFromTrackTrip(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}
						else {
							jArr = rbFunc.getGenerateReportDetails(systemId,clientId,reportId,parameterSelected,vehicleNo,startDate,endDate,trips,offset);
						}
						
						if(typeParam1.equalsIgnoreCase("EXCEL")) {
							String message = rbFunc.DownloadExcel(systemId,clientId,userId,jArr,reportName,startDate,endDate,reportInfo,vehicleNo);
							resp.getWriter().print(message);
						}else if(typeParam1.equalsIgnoreCase("PDF")) {
							String message = rbFuncPDF.DownloadPDF(systemId,clientId,userId,jArr,reportName,startDate,endDate,reportInfo,vehicleNo);
							resp.getWriter().print(message);
						}
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}	
		return null;
	}		
}
