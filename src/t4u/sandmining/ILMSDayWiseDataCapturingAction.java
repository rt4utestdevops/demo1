package t4u.sandmining;

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

import t4u.admin.SimDetailsExcelImport;
import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;
import t4u.functions.ILMSDetailsImportFunctions;

public class ILMSDayWiseDataCapturingAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int customerId = 0;
		String customerName = "";
		int userId = 0;
		int offset = 0;
		//HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		AdminFunctions adminFun= new AdminFunctions();
		systemId = loginInfo.getSystemId();
		//String lang = loginInfo.getLanguage();
		customerId = loginInfo.getCustomerId();
		customerName = loginInfo.getCustomerName();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		zone = loginInfo.getZone();
		CommonFunctions cf = new CommonFunctions();
		String message="";
		ILMSDetailsImportFunctions ilms=new ILMSDetailsImportFunctions();

		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equals("getIlmsCountData")) {
			String jspName = request.getParameter("jspName");
			String startDate = request.getParameter("startDate").replace("T", " ");
			String endDate = request.getParameter("endDate");
			endDate=endDate.substring(0, endDate.indexOf("T"))+" 23:59:59";
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList list  = ilms.getIlmsCountDetails(systemId,customerId,startDate,endDate,jsonObject,offset);
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("ilmsdataRoot", jsonArray);
				} else {
					jsonObject.put("ilmsdataRoot", "");
				}
				ReportHelper reportHelper=(ReportHelper)list.get(1);
				request.getSession().setAttribute(jspName,reportHelper);
				//request.getSession().setAttribute("customerName",customerName);
				request.getSession().setAttribute("startDate", startDate);
				request.getSession().setAttribute("endDate", endDate);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equals("getInnerGridILMSDetails")) {
			String uploadDate = request.getParameter("uploadDate");
			String jspName=request.getParameter("innerGridjspName");
			
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList list  = ilms.getInnerGridILMSDetails(systemId,customerId,uploadDate);
				jsonArray= (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("ILMSDetailsInnergridRoot", jsonArray);
				} else {
					jsonObject.put("ILMSDetailsInnergridRoot", "");
				}
				ReportHelper reportHelper=(ReportHelper)list.get(1);
				request.getSession().setAttribute(jspName,reportHelper);
				//request.getSession().setAttribute("customerName",customerName);
				request.getSession().setAttribute("uploadDate", uploadDate);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equalsIgnoreCase("importILMSDetailsExcel")) {

			String importMessage = "";
			try {
				String messages = "";
				String fileName = null;
				int clientIdInt = 0;
				String fromDate=request.getParameter("fromDate")+" 00:00:00";
				String toDate =request.getParameter("toDate")+" 23:59:59";
				String dateFormate=request.getParameter("dateFormate");
				boolean isMultipart = ServletFileUpload.isMultipartContent(request);
				if (isMultipart) {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					String path = properties.getProperty("ILMSDayWiseDataCapturing").trim()+ "//";
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
										+ "ILMSDetailsImportData-" + systemId
										+ userId + fileExtension;
								uploadedFile = new File(excelPath);

								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							ILMSDetailsExcelImport dei = new ILMSDetailsExcelImport(
									uploadedFile, userId, systemId,
									clientIdInt, offset, fileExtension,fromDate,toDate,Integer.parseInt(dateFormate) );
							

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
		else if (param.equalsIgnoreCase("getImportILMSDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String fuelImportResponse = request.getParameter("ilmsImportResponse");
				if (fuelImportResponse.equals("{success:true}")) {
					jsonArray = ILMSDetailsExcelImport.globalJsonArray;
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("ILMSDetailsImportRoot", jsonArray);
				} else {
					jsonObject.put("ILMSDetailsImportRoot", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equalsIgnoreCase("saveImportIlmsDetails")){
			String messages = "";
			String saveUnitData = request.getParameter("ilmsDataSaveParam");
			try {
				if (saveUnitData != null && !saveUnitData.equals("")) {
					JSONArray fuelJs = null;
					try {
						fuelJs = new JSONArray(saveUnitData.toString());
						
							messages = ilms.saveImportedILMSDetails(systemId,customerId, userId,fuelJs,offset,ILMSDetailsExcelImport.allILMSImporteddetails);
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					messages = "No Data To Save";
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
				String path=properties.getProperty("ILMSDayWiseDataCapturing").trim()+"/";
				stdFile = new File(path + "ILMSStandardFormate.xls");
				filename = "ILMSDayWiseDataCapturing";
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
		return null;
	}
}
