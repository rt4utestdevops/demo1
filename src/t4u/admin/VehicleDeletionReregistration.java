package t4u.admin;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import t4u.common.ApplicationListener;
import t4u.functions.AssetDelitionAndRegistrationFunction;


public class VehicleDeletionReregistration extends Action{
	

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		
		String param="";
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		
		if (param != null && param.equals("getLTSPNames")) {
			AssetDelitionAndRegistrationFunction assetDetails = new AssetDelitionAndRegistrationFunction();
			jsonArray = assetDetails.getLTSP();
			try {
				jsonObject = new JSONObject();
				jsonObject.put("ltspNameList", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if (param.equals("getClientNameswrtSystem")) {
			try {				
				AssetDelitionAndRegistrationFunction assetDetails = new AssetDelitionAndRegistrationFunction();			
				String sysid = request.getParameter("systemid");
				jsonArray = assetDetails.getClientList(sysid);
				jsonObject.put("clientNameList", jsonArray);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out.println("Error in getting the Client List in Action:" + e.toString());
				e.printStackTrace();
			}
		}else if (param.equalsIgnoreCase("importUnitDetailsExcel")) {
			String messages = "";
			String importMessage = "";						
			String systemId=null;//request.getParameter("ltsp");
			String clientId=null;//request.getParameter("client");
			try {
				
				String fileName = null;				
				
				boolean isMultipart = ServletFileUpload.isMultipartContent(request);
				if (isMultipart) {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
					File uploadedFile = null;
					String fileExtension = "";
					while (iter.hasNext()) {
						FileItem item = (FileItem) iter.next();						
						if (!item.isFormField()) {							
							File f = null;
							if (item.getName() != "") {
								fileName = item.getName();
								fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());
								String excelPath = path+ "AssetDelitionRegistration_"+ fileExtension;
								uploadedFile = new File(excelPath);
								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}						
						}
						if (item.isFormField() && item.getFieldName().equalsIgnoreCase("ltsp")) {
							systemId =item.getString();
							} 
						if (item.isFormField() && item.getFieldName().equalsIgnoreCase("client")) {
							clientId =item.getString();
							} 
					}
					AssetDetailsExcelImport dei = new AssetDetailsExcelImport(uploadedFile, Integer.parseInt(systemId),Integer.parseInt(clientId), fileExtension);							
					importMessage = dei.importExcelData();
					messages = dei.getMessage();
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
		}else if (param.equalsIgnoreCase("getImportAssetDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String fuelImportResponse = request.getParameter("assetImportResponse");
				if (fuelImportResponse.equals("{success:true}")) {
					jsonArray = AssetDetailsExcelImport.globalJsonArray;
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
		}else if(param.equals("openStandardFileFormats")){
			try{
				File stdFile;
				String filename;
				Properties properties = ApplicationListener.prop;
				String path=properties.getProperty("TempFileDownloadPath").trim()+"/";
				stdFile = new File(path + "StandardFormatAssetDeletionRegistration.xls");
				filename = "AssetDetails";
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
		}else if(param.equalsIgnoreCase("saveImportAssetDetails")){
			String messages = "";
			JSONArray ast = null;
			String assetData = request.getParameter("unitDataSaveParam");
			String ltsp = request.getParameter("ltsp");
			String client = request.getParameter("client");
			String ltspName=request.getParameter("ltspName");
			String custName=request.getParameter("clientName");
			try {
				if (assetData != null && !assetData.equals("")) {
					try {
						ast = new JSONArray(assetData.toString());
						AssetDelitionAndRegistrationFunction assetDetails = new AssetDelitionAndRegistrationFunction();
							messages =  assetDetails.DeleteFromRegistrationAndReregistration( ltspName,custName,Integer.parseInt(ltsp), Integer.parseInt(client),AssetDetailsExcelImport.dataMap.get("Valid"));
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					messages = "No Asset Details To Save";
				}
				response.getWriter().print(messages);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;		
	}
}
