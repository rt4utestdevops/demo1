package t4u.admin;


import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;


import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.AdminFunctions;
/**
 * This Class is used Application Download and saving the details of downloader
 * @author Administrator
 *
 */
public class AppsDownloadAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		HttpSession session = request.getSession();
		AdminFunctions adfunc= new AdminFunctions();
		LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId=loginInfo.getSystemId();
		int createdUser=loginInfo.getUserId();
		int customerId=loginInfo.getCustomerId();
		
        String param = "";
		
		if(request.getParameter("param")!=null)
		{
			param=request.getParameter("param").toString();
		}
		/**
		 * 
		 * saving application downloader Details
		 *
		 */
		if(param.equals("saveAppsDownloaderDetails")){
			
			try {
			String custName=request.getParameter("CustName");
			String mobNo=request.getParameter("MobileNo");
			String email="";
			if(request.getParameter("EmailAddress")!=null){
			email=request.getParameter("EmailAddress");
			}
			String designation="";
			if(request.getParameter("Designation")!=null){
				designation=request.getParameter("Designation");
			}
			
			adfunc.saveAppsDownloaderDetails(systemId,customerId,createdUser ,custName, mobNo, email, designation);
			
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println(e);
			}
		}
		/**
		 * code for downloading the Application
		 */
		if(param.equals("AppsDownloaderDetails")){
				try {	
			Properties properties = ApplicationListener.prop;
			String idocPath=properties.getProperty("TempFileDownloadPath").trim()+"/";
			String fileName="mobile.apk";
			String filePath=idocPath+fileName;
			response.setContentType("application/vnd.android.package-archive apk");
			String disHeader="Attachement;Filename="+fileName;
			response.setHeader("Content-Disposition",disHeader);
			File file=new File(filePath);
			FileInputStream fis = new FileInputStream(file);
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
			
			} catch (Exception e) {
				System.out.println("Error in AppsDownloadAction:-AppDownloaderDetails"+e);
			}
		}
		
		
		
		return null;
	}
}
