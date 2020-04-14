package t4u.admin;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
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
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;

public class SimDetailsAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		//HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		AdminFunctions adminFun= new AdminFunctions();
		systemId = loginInfo.getSystemId();
		//String lang = loginInfo.getLanguage();
		System.out.println(systemId);
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		zone = loginInfo.getZone();
		CommonFunctions cf = new CommonFunctions();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		String message="";

		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getsimsData")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList < Object > list = adminFun.getSimDetails(systemId,offset);
				jsonArray = (JSONArray) list.get(0);
				//System.out.println(jsonArray.length());
				//System.out.println(jsonArray.toString());
				if (jsonArray.length() > 0) {
					jsonObject.put("simdataRoot", jsonArray);
				} else {
					jsonObject.put("simdataRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("saveSimInformation")) {
			String mobileNumber = request.getParameter("mobileNumber");
			String serviceProvider = request.getParameter("serviceProvider");
			String simNumber = request.getParameter("simNumber");
			String STATUS=request.getParameter("status");
			String gridStatus=request.getParameter("StatusGrid");
			String buttonvalue=request.getParameter("buttonValue");

			String gridServiceProvider=request.getParameter("serviceProviderGrid");
			String gridSimNumber=request.getParameter("simNumberGrid");
			String validityStartDate=request.getParameter("validityStartDate");
			String validityEndDate=request.getParameter("validityEndDate");
			String pageName=request.getParameter("pageName");

			try {
				if (buttonvalue.equals("add")) {
					message=adminFun.simDetailsInsert(mobileNumber,serviceProvider,simNumber,STATUS,userId,systemId,validityStartDate,validityEndDate,offset,pageName,sessionId,serverName);
				} else if(buttonvalue.equals("modify")) {
						message=adminFun.simDetailsUpdate(mobileNumber,serviceProvider,simNumber,STATUS,userId,systemId,validityStartDate,validityEndDate,offset,pageName,sessionId,serverName);
				} 
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("importSimDetailsExcel")) {

			String importMessage = "";
			try {
				String messages = "";
				String fileName = null;
				int clientIdInt = 0;
				
				boolean isMultipart = ServletFileUpload.isMultipartContent(request);
				if (isMultipart) {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
					while (iter.hasNext()) {
						FileItem item = (FileItem) iter.next();
						String fileExtension = "";
						if (!item.isFormField()) {
							File uploadedFile = null;
							File f = null;
							if (item.getName() != "") {
								fileName = item.getName();
								fileExtension = fileName.substring(
										fileName.lastIndexOf("."), fileName
												.length());

								String excelPath = path
										+ "SimDetailsImportData-" + systemId
										+ userId + fileExtension;
								uploadedFile = new File(excelPath);

								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							SimDetailsExcelImport dei = new SimDetailsExcelImport(
									uploadedFile, userId, systemId,
									clientIdInt, offset, fileExtension);
							

							importMessage = dei.importExcelData();
							message = dei.getMessage();
						}
					}
				} else {
					System.out.println("Request Does Not Support Multipart");
				}
				if (importMessage.equals("Success")) {
					response.getWriter().print("{success:true}");
				} else {
					response.getWriter().print("{success:false}");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getImportSimDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String fuelImportResponse = request.getParameter("simImportResponse");
				if (fuelImportResponse.equals("{success:true}")) {
					jsonArray = SimDetailsExcelImport.globalJsonArray;
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("SimDetailsImportRoot", jsonArray);
				} else {
					jsonObject.put("SimDetailsImportRoot", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equalsIgnoreCase("saveImportSimDetails")){
			String messages = "";
			String saveUnitData = request.getParameter("simDataSaveParam");
			try {
				if (saveUnitData != null && !saveUnitData.equals("")) {
					JSONArray fuelJs = null;
					try {
						fuelJs = new JSONArray(saveUnitData.toString());
							messages = adminFun.saveSimDetails(systemId, userId,fuelJs,offset);
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					messages = "No Fuel Data To Save";
				}
				response.getWriter().print(messages);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if(param.equals("openStandardFileFormats")){
			try{
				File stdFile;
				String filename;
				Properties properties = ApplicationListener.prop;
				String path=properties.getProperty("TempFileDownloadPath").trim()+"/";
				stdFile = new File(path + "StandardFormatImportSIM.xls");
				filename = "SimDetails";
				response.setContentType("application/xls");
				response.setHeader("Content-disposition","attachment;filename="+filename+".xls");
				FileInputStream fis = new FileInputStream(stdFile);
				ServletOutputStream servletOutputStream = response.getOutputStream();
				DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);
				byte [] buffer = new byte [1024];
				int len = 0;
				while ( (len = fis.read(buffer)) >= 0 ) 
				{
					outputStream.write(buffer, 0, len);
				}
				outputStream.flush();
				outputStream.close();
			}catch(Exception e){
				e.printStackTrace();
			}
		}

		else if (param.equals("deleteSimDetails")) {
			String mobileNumber = request.getParameter("mobileNumber");
			String serviceProvider = request.getParameter("serviceProvider");
			String simNumber = request.getParameter("SimNumber");
			String pageName=request.getParameter("pageName");

			try {
				message=adminFun.simDetailsDelete(mobileNumber,systemId,pageName,sessionId,serverName,userId);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}

		}


		return null;
	}
}
