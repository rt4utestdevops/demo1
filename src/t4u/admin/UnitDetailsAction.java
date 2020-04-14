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
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.AdminFunctions;
import t4u.functions.CommonFunctions;

public class UnitDetailsAction extends Action{

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		String zone = "";
		int systemId = 0;
		int userId = 0;
		int offset = 0;
		int customerid = 0;
		String customerName="";
		String customerId=request.getParameter("CustId");
		//HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		AdminFunctions adminFun= new AdminFunctions();
		systemId = loginInfo.getSystemId();
		customerName= loginInfo.getSystemName();
		zone = loginInfo.getZone();
		userId = loginInfo.getUserId();
		customerid = loginInfo.getCustomerId();
		offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		zone = loginInfo.getZone();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		CommonFunctions cf = new CommonFunctions();
		
		String message="";
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equalsIgnoreCase("getManufacturer")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = adminFun.getManufacturerDetails(systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("manufacturerRoot", jsonArray);
				} else {
					jsonObject.put("manufacturerRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}catch (Exception e) {
              e.printStackTrace();
			}
		} 
		
		else if(param.equalsIgnoreCase("getunittypes")){
			String manufacturerCode = "0";
			if (request.getParameter("manufacturerCode") != null || request.getParameter("manufacturerCode").equals("")) {
				manufacturerCode = request.getParameter("manufacturerCode").trim();
			}
			try{
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (!manufacturerCode.equals("0")) {
					jsonArray = adminFun.getUnitTypes(manufacturerCode,systemId);
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("unitTypeRoot", jsonArray);
				} else {
					jsonObject.put("unitTypeRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}catch (Exception e) {
				e.printStackTrace();
			}

		}
		else if (param.equalsIgnoreCase("getUnitDetails")) {
			String jspname=request.getParameter("jspName");
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				ArrayList < Object > list1 = adminFun.getUnitDetails(offset,systemId,lang);
				jsonArray = (JSONArray) list1.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("unitDetailsRoot", jsonArray);
				} else {
					jsonObject.put("unitDetailsRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list1.get(1);
				request.getSession().setAttribute(jspname,reportHelper);
				request.getSession().setAttribute("customerId", customerName);
				response.getWriter().print(jsonObject.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "Asset Operation", "View", userId, serverName, systemId, customerid,
				"Visited This Page");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("saveUnitInformation")) {
			String UnitNumber = request.getParameter("UnitNumber").trim();
			String ManufactureCode = request.getParameter("ManufactureCode");
			String UnitTypeCode = request.getParameter("UnitTypeCode");
			String unitReferenceId=request.getParameter("UnitRefId");
			String DateAndTime = "";
			String STATUS = request.getParameter("STATUS");
			String buttonvalue=request.getParameter("buttonValue");
			String lastDownloadedDateAndTime="";
			String id= request.getParameter("id");

			String ManufacturerGrid=request.getParameter("manufacturerGrid");
			String unitrefGrid=request.getParameter("UnitRef");
			String DateAndTimeGrid=request.getParameter("dateAndTimeGrid");
			String RFIDGrid=request.getParameter("Status");
			String predefinedMobileNumGrid=request.getParameter("predefinedMobileNumGrid");
			String predefinedMobileNum=request.getParameter("mobileNum");
			String pageName=request.getParameter("pageName");
			String  transModeStr=request.getParameter("transMode");
			String  transModeGrid=request.getParameter("transModeGrid");
			int transMode=0;
			if(transModeStr.equalsIgnoreCase("ACTIVE")){
				transMode=1;
			}
			if(unitReferenceId==null)
			{
				unitReferenceId="";
			}

			try {
				if (buttonvalue.equals("add")) {
					message=adminFun.unitDetailsInsert(UnitNumber,ManufactureCode,UnitTypeCode,unitReferenceId,lastDownloadedDateAndTime,offset,userId,
							STATUS,systemId,predefinedMobileNum,pageName,sessionId,serverName,transMode);
				} else if(buttonvalue.equals("modify")) {
					if (!ManufactureCode.equals(ManufacturerGrid)||!UnitTypeCode.equals(id)||!unitReferenceId.equals(unitrefGrid)||!DateAndTime.equals(DateAndTimeGrid)||!STATUS.equals(RFIDGrid)||!predefinedMobileNum.equals(predefinedMobileNumGrid)||!transModeStr.equals(transModeGrid)) {
						message=adminFun.unitDetailsUpdate(UnitNumber,ManufactureCode,UnitTypeCode,unitReferenceId,lastDownloadedDateAndTime,offset,
								userId,STATUS,systemId,id,predefinedMobileNum,pageName,sessionId,serverName,transMode);
					} else {
						message="<p>No Changes has to be done to Save...</p>";
					}
				} 
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("importUnitDetailsExcel")) {

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
										+ "UnitDetailsImportData-" + systemId
										+ userId + fileExtension;
								uploadedFile = new File(excelPath);

								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							UnitDetailsExcelImport dei = new UnitDetailsExcelImport(
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
		else if (param.equalsIgnoreCase("getImportUnitDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String fuelImportResponse = request.getParameter("unitImportResponse");
				if (fuelImportResponse.equals("{success:true}")) {
					jsonArray = UnitDetailsExcelImport.globalJsonArray;
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("UnitDetailsImportRoot", jsonArray);
				} else {
					jsonObject.put("UnitDetailsImportRoot", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if(param.equalsIgnoreCase("saveImportUnitDetails")){
			String messages = "";
			JSONArray fuelJs = null;
			String saveUnitData = request.getParameter("unitDataSaveParam");
			try {
				if (saveUnitData != null && !saveUnitData.equals("")) {
					try {
						fuelJs = new JSONArray(saveUnitData.toString());
							messages = adminFun.saveUnitDetails(systemId, userId, UnitDetailsExcelImport.dataMap.get("Valid"));
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
				stdFile = new File(path + "StandardFormatImportUNIT.xls");
				filename = "UnitDetails";
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
		else if (param.equalsIgnoreCase("deleteUnitDetails")){

			String UnitNumber = request.getParameter("UnitNumber");
			//String ManufactureCode = request.getParameter("ManufactureCode");
			//String UnitTypeCode = request.getParameter("UnitTypeCode");
			//String DateAndTime = request.getParameter("DateAndTime");
			String STATUS = request.getParameter("STATUS");
			String pageName=request.getParameter("pageName");
			try {
				message=adminFun.unitDetailsDelete(UnitNumber,systemId,STATUS,pageName,sessionId,serverName,userId);
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equalsIgnoreCase("getMobileNoForCLA")) {
            try {
                jsonArray = new JSONArray();
                jsonObject = new JSONObject();
                jsonArray = adminFun.getMobileNumberForUnitDetailsCLA(systemId, userId);
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
		return null;
	}
}