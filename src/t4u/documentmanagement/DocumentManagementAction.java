package t4u.documentmanagement;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

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
import t4u.functions.DocumentManagementFunctions;

public class DocumentManagementAction extends Action {
	@SuppressWarnings({ "deprecation", "unchecked" })
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		HttpSession session = request.getSession();

		LoginInfoBean loginInfo = (LoginInfoBean) session
				.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int userId = loginInfo.getUserId();

		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equalsIgnoreCase("fileUpload")) {

			String uploadMessage = "";
			DocumentManagementFunctions cf = new DocumentManagementFunctions();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			try {
				String fileName = null;
				String category = request.getParameter("category");
				int ClientId = 0;
				if (request.getParameter("ClientId")!=null && !"undefined".equals(request.getParameter("ClientId")) && 
						!request.getParameter("ClientId").equals("") && !request.getParameter("ClientId").equals("null")) {
					ClientId = Integer.parseInt(request.getParameter("ClientId"));
				}
				
				String value = request.getParameter("value");
				if ("VEHICLE".equals(category)) {
					ClientId = cf.getClientId(value, systemId);
				}
				boolean isMultipart = ServletFileUpload.isMultipartContent(request);
				if (isMultipart) {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					Date d = new Date();
					Calendar cal = Calendar.getInstance();
					cal.setTime(d);
					int year = cal.get(Calendar.YEAR);
					int month = cal.get(Calendar.MONTH);
					int day = cal.get(Calendar.DAY_OF_MONTH);
					month = month + 1;
					String yearString = "" + year;
					String monthString = "" + month;
					String dayString = "" + day;
					String dateTime = sdf.format(d);
					String path = properties.getProperty("DocumentUploadPath").trim()+ "/" ;
					//+ "\\" + yearString + "\\" + monthString + "\\" + dayString + "\\";
					while (iter.hasNext()) {
						FileItem item = (FileItem) iter.next();
						if (!item.isFormField()) {
							File uploadedFile = null;
							File f = null;
							if (item.getName() != "") {
								fileName = item.getName();
								if (fileName!=null && !fileName.equals("") && fileName.contains("\\")) {
									String[] a = fileName.split("\\\\");
									fileName = a[a.length-1];
								}
								String fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());
								String DestinationPath = path + fileName;
								uploadedFile = new File(DestinationPath);
								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
								
								int id=cf.insertFileDetails(path, fileName, category, value, ClientId, systemId, userId, dateTime, fileExtension);
								/**
								 * Rename
								 */
								File oldFileName = new File(DestinationPath);
								File newFileNameWithId = new File(path+id+fileExtension);
								if (oldFileName.exists()) {
									oldFileName.renameTo(newFileNameWithId);
								}
								uploadMessage = "Success";
							}
						}
					}
				}
				if (uploadMessage.equals("Success")) {
					response.getWriter().print("{success:true}");
				} else {
					response.getWriter().print("{success:false}");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getDocuments")){
			try{
				DocumentManagementFunctions cf = new DocumentManagementFunctions();
				String category = request.getParameter("category");
				int ClientId = 0;
				if (request.getParameter("ClientId")!=null && !"undefined".equals(request.getParameter("ClientId")) && 
						!request.getParameter("ClientId").equals("") && !request.getParameter("ClientId").equals("null")) {
					ClientId = Integer.parseInt(request.getParameter("ClientId"));
				}
				
				String value = request.getParameter("value");
				if ("VEHICLE".equals(category)) {
					ClientId = cf.getClientId(value, systemId);
				}
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				
				jsonArray= cf.getDocuments(request, ClientId, value, systemId);
				if(jsonArray.length()>0){
				jsonObject.put("images", jsonArray);
				}else{
				jsonObject.put("images", "");
				}
				
				response.getWriter().print(jsonObject.toString());
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		return null;
	}

}