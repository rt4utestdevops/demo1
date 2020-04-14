package t4u.distributionlogistics;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.CommonFunctions;
import t4u.functions.CreateTripFunction;
import t4u.functions.DistributionLogisticsFunctions;
import t4u.functions.HistoryAnalysisFunction;


public class IndentMasterDetails extends Action{
	public ActionForward execute(ActionMapping map,ActionForm form,HttpServletRequest req,HttpServletResponse resp){
		try{
			HttpSession session = req.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
			SimpleDateFormat ddmmyyyy1 = new SimpleDateFormat("dd/MM/yyyy");
			int systemId = 0;
			int clientId = 0;
			int offset = 0;
			int userId = 0;
			int isLtsp = 0;
			int nonCommHrs = 0;
			String lang = "";
			if(loginInfo != null){
				systemId = loginInfo.getSystemId();
				clientId = loginInfo.getCustomerId();
				offset = loginInfo.getOffsetMinutes();
				userId = loginInfo.getUserId();
				isLtsp = loginInfo.getIsLtsp();
				nonCommHrs = loginInfo.getNonCommHrs();
				lang = loginInfo.getLanguage();
			}
			
			String param = "";
			if(req.getParameter("param") != null){
				param = req.getParameter("param");
			}
			JSONArray jArr = new JSONArray();
			JSONObject obj = null;
			DistributionLogisticsFunctions gf = new DistributionLogisticsFunctions();
			CreateTripFunction creatTripFunc =new CreateTripFunction();
			HistoryAnalysisFunction historyTrackingFunctions = new HistoryAnalysisFunction();
			CommonFunctions cf=new CommonFunctions();
			String serverName=req.getServerName();
			String sessionId = req.getSession().getId();
			if(param.equals("getIndentMasterDetails")){
				String custId = req.getParameter("custId");
				String mllCust = req.getParameter("mllCust");
				String userAuthority = req.getParameter("userAuthority");
				try{
					obj = new JSONObject();
						jArr = gf.getIndentMasterDetails(systemId,custId,offset,userId,mllCust,userAuthority);
						if(jArr.length() > 0){
							obj.put("indentMasterRoot", jArr);
						}else{
							obj.put("indentMasterRoot", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}
			else if(param.equals("saveIndentDetails")){
				String custId = req.getParameter("CustId");
				String region = req.getParameter("region");
				String dedicatedCount = req.getParameter("dedicated");
				String adhocCount = req.getParameter("adhoc");
				String supervisorName = req.getParameter("superName");
				String supervisorContact = req.getParameter("superContact");
				String hubId = req.getParameter("node");
				String mllCust = req.getParameter("mllCust");
				String message="";
				String action = req.getParameter("action");
				int indentId = 0;
				if(req.getParameter("indentMasterId") != null){
					indentId = Integer.parseInt(req.getParameter("indentMasterId"));
				}
				
				try{
					obj = new JSONObject();
					
					if(action.equals("add")){
						JSONArray indentsForHub = gf.getIndentByHubId(systemId,custId,mllCust,hubId);
						if(indentsForHub.length() >=1)
						{
							message = "Indent already exists for the node";
						}
						else{
							message = gf.insertIndentMasterDetails(systemId,Integer.parseInt(custId),offset,userId,region,Integer.parseInt(dedicatedCount),Integer.parseInt(adhocCount),
									  supervisorName,supervisorContact,Integer.parseInt(hubId),mllCust);
						}
					}
					else if(action.equals("modify")){
						message = gf.updateIndentMasterDetails(indentId,region,Integer.parseInt(dedicatedCount),Integer.parseInt(adhocCount),
								  supervisorName,supervisorContact);
					}
					obj.put("indentMasterRoot",message);
					resp.getWriter().print(message.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if (param.equalsIgnoreCase("getAssetType")) {
	            try {
	            	obj = new JSONObject();
	            	jArr = gf.getAssetTypeDetails(systemId, userId);
	                if (jArr.length() > 0) {
	                    obj.put("assetTypeRoot", jArr);
	                } else {
	                    obj.put("assetTypeRoot", "");
	                }
	                resp.getWriter().print(obj.toString());
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        } else if (param.equalsIgnoreCase("getMake")) {
	            try {
	            	obj = new JSONObject();
	            	jArr = gf.getMakes(systemId, clientId);
	                if (jArr.length() > 0) {
	                    obj.put("makeRoot", jArr);
	                } else {
	                    obj.put("makeRoot", "");
	                }
	                resp.getWriter().print(obj.toString());
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }else if(param.equals("getIndentMasterDetails1")){
				String uniqueId = req.getParameter("uniqueId");
				try{
					obj = new JSONObject();
						jArr = gf.getIndentVehicleDetails(systemId,uniqueId,offset,userId);
						if(jArr.length() > 0){
							obj.put("indentMasterRoot1", jArr);
						}else{
							obj.put("indentMasterRoot1", "");
						}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("saveIndentVehicleDetails")){
				String id = req.getParameter("id");
				String vehicleType = req.getParameter("vehicleType");
				String make = req.getParameter("make");
				String noOfVehicles = req.getParameter("noOfVehicles");
				String DedicaedAdhoc = req.getParameter("DedicaedAdhoc");
				String placementTime = req.getParameter("placementTime");
				String action = req.getParameter("action");
				int indentMasterId = Integer.parseInt(req.getParameter("indentMasterId"));
				try{
					obj = new JSONObject();
					if(action.equals("add")){
						jArr = gf.insertIndentVehicleDetails(systemId,Integer.parseInt(id),offset,userId,vehicleType,Integer.parseInt(noOfVehicles),DedicaedAdhoc,
								placementTime,make);
					}if(action.equals("modify")){
						jArr = gf.updateIndentVehicleDetails(systemId,id,indentMasterId,Integer.parseInt(noOfVehicles),DedicaedAdhoc,vehicleType,placementTime,make);
					}
					obj.put("indentDetailRoot", jArr);
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getTotalCount")){
				String id = req.getParameter("id");
				try{
					obj = new JSONObject();
					jArr = gf.getTotalCount(Integer.parseInt(id));
					if(jArr.length() > 0){
						obj.put("countroot", jArr);
					}else{
						obj.put("countroot", "");
					}
					resp.getWriter().print(obj.toString());
				}catch(Exception e){
					e.printStackTrace();
				}
			}else if(param.equals("getCustomer")){
				try {
					obj = new JSONObject();
					jArr = creatTripFunc.getCustomer(clientId, systemId);
					obj.put("customerRoot", jArr);
					resp.getWriter().print(obj.toString());
					
					cf.insertDataIntoAuditLogReport(sessionId, null, "Leg Route Creation", "View", userId, serverName, systemId, clientId,
					"Visited This Page");
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if(param.equals("getIndentById")){
				try {
					obj = new JSONObject();
					int id = Integer.parseInt(req.getParameter("id"));
					jArr = gf.getIndentById(id);
					
					obj.put("indentRoot", jArr);
					resp.getWriter().print(obj.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equalsIgnoreCase("importIndentMasterExcel")) {
				try {
					obj = new JSONObject();
					HashMap<String, String> returValues = saveFileToDisk(req,systemId,userId);
					IndentMasterExcelImport indentImport = new IndentMasterExcelImport();
					obj = indentImport.importExcelData(returValues.get("FILE"), userId, systemId, clientId, Integer.parseInt(returValues.get("CUST_ID")),loginInfo.getZone());
					req.getSession().setAttribute("validIndentDataList", indentImport.getValidIndentList());
					resp.getWriter().print(obj.toString());	
					
				  } catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equalsIgnoreCase("saveIndentMasterImportData")) {
				Integer custId = Integer.parseInt(req.getParameter("custId"));
				String mllCust = req.getParameter("mllCust");
				List<IndentMasterData> indentDataList = (List<IndentMasterData> )req.getSession().getAttribute("validIndentDataList");
				IndentMasterExcelImport indentImport = new IndentMasterExcelImport() ;
				//validate for Duplciate node
				List<String> errors = indentImport.validateBeforeSave(indentDataList, clientId, systemId, Integer.parseInt(mllCust));
				int totalRecordsSaved = gf.importIndentMasterMasterDetails(indentDataList, systemId, custId, mllCust, userId);
				
				resp.getWriter().print(formatError(errors,totalRecordsSaved));	
				
			}else if (param.equalsIgnoreCase("getImportIndentMasterStdFormat")) {
				String applciationPath = req.getSession().getServletContext().getRealPath(File.separator);
				String webappPath = applciationPath.substring(0, applciationPath.indexOf("webapps")+7);
				String formatPath= webappPath+ "/ApplicationImages/ExcelImportFormats/ImportIndentStandardFormat.xlsx";
				IndentMasterExcelImport.downloadStandardFormt(formatPath,"ImportIndentStandardFormat",req,resp);
				
			}
			else if (param.equalsIgnoreCase("importIndentDetailsExcel")) {
				try {
					obj = new JSONObject();
					IndentDetailsExcelImport indentImport = new IndentDetailsExcelImport() ;
					HashMap<String, String> returValues = saveFileToDisk(req,systemId,userId);
					obj = indentImport.importExcelData(returValues.get("FILE"), userId, systemId, clientId, Integer.parseInt(returValues.get("CUST_ID")),loginInfo.getZone());
					req.getSession().setAttribute("validIndentDetailsList", indentImport.getValidIndentVehicleDetails());
					resp.getWriter().print(obj.toString());	
				} catch (Exception e) {
					e.printStackTrace();
				}
			}else if (param.equalsIgnoreCase("saveIndentDetailsImportData")) {
				Integer custId = Integer.parseInt(req.getParameter("custId"));
				String mllCust = req.getParameter("mllCust");
				List<IndentVehicleDetailsData> indentList = (List<IndentVehicleDetailsData>) req.getSession().getAttribute("validIndentDetailsList");
				IndentDetailsExcelImport indentImport = new IndentDetailsExcelImport() ;
				List<String> errors = indentImport.validateIndentDetailsBeforeSave(indentList, systemId, clientId, Integer.parseInt(mllCust), userId);
				int totalRecordsSaved = gf.importIndentVehicleDetails(indentList, systemId, custId, mllCust, userId);
				resp.getWriter().print(formatError(errors,totalRecordsSaved));	
			}
			else if (param.equalsIgnoreCase("getImportIndentVehicleStdFormat")) {
				String applciationPath = req.getSession().getServletContext().getRealPath(File.separator);
				String webappPath = applciationPath.substring(0, applciationPath.indexOf("webapps")+7);
				String formatPath= webappPath+ "/ApplicationImages/ExcelImportFormats/ImportIndentModelStdFormat.xlsx";
				IndentMasterExcelImport.downloadStandardFormt(formatPath,"ImportIndentModelStdFormat",req, resp);
				
			}
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}	
	
	
	private HashMap<String,String> saveFileToDisk(HttpServletRequest req,int systemId, int userId) throws Exception{
		boolean isMultipart = ServletFileUpload.isMultipartContent(req);
		String fileName = null;
		File uploadedFile = null;
		HashMap<String,String> returnValues = new HashMap<String,String>();
		if (isMultipart) {
			FileItemFactory factory = new DiskFileItemFactory();
			ServletFileUpload upload = new ServletFileUpload(factory);
			List items = upload.parseRequest(req);
			Iterator iter = items.iterator();
			Properties properties = ApplicationListener.prop;
			String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
			
			while (iter.hasNext()) {
				FileItem item = (FileItem) iter.next();
				if (item.isFormField() && item.getFieldName().equalsIgnoreCase("mllCust")) {
					returnValues.put("CUST_ID", item.getString());
					
					} 
				else if (!item.isFormField()) {
					File f = null;
					if (item.getName() != "") {
						fileName = item.getName();
						String fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());
						String excelPath = path + "IndentDetailsImportData-" + systemId+ userId + fileExtension;
						uploadedFile = new File(excelPath);
						f = new File(path);
						if (!f.exists()) {
							f.mkdirs();
						}
						item.write(uploadedFile);
						returnValues.put("FILE", uploadedFile.getPath());
					}
				}
			}
		} else {
			System.out.println("Request Does Not Support Multipart");
		}
		return returnValues;
	}
	
	private String formatError(List<String> errors,int totalRecordsSaved){
		StringBuffer sb = new StringBuffer();
		sb.append("Successfully saved ");
		sb.append(totalRecordsSaved);
		sb.append(" records");
		sb.append("<br>");
		if(errors.size() > 0){
			sb.append("Error saving "+errors.size()+ " record");
			sb.append("<br>");
			int slNo=1;
			for(String error : errors){
				sb.append(slNo +". "+error);
				sb.append("<br>");
				slNo++;
			}
		}
		return sb.toString();
	}
	
}