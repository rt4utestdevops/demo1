package t4u.containercargomanagement;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import t4u.functions.ContainerCargoManagementFunctions;

public class ViewAdditionalExpenseInvoicePT extends HttpServlet{


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	File outFile;
	ContainerCargoManagementFunctions ccmFunc = new ContainerCargoManagementFunctions();
	
	
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{


		try
		{   
			String id = request.getParameter("id");

			JSONObject jsonObject = new JSONObject();

			jsonObject= ccmFunc.getAddExpDocuments( id );


//			response.getWriter().print(jsonObject.toString());


			String destinationPath = "";
			String fileExtension = "";
			String fileName = "";
			destinationPath = jsonObject.getString("url");
			fileExtension = jsonObject.getString("fileExtension");
			fileName = jsonObject.getString("name");

//			System.out.println("filePath ===========================  "+destinationPath);
			/*if(filePath != null){
				filePath = filePath.substring(30, filePath.length());
				System.out.println("filePath === "+filePath);
			}*/		
			ServletOutputStream servletOutputStream=response.getOutputStream();

//			Properties properties = ApplicationListener.prop;

//			String destinationPath = properties.getProperty("DocumentDownloadPathForQuotation").trim();

//			String destinationPath = new File(System.getProperty("catalina.base"))+ "/webapps/ApplicationImages/TempImageFile/";
			
//			if(!filePath.equals("")){
//				destinationPath = destinationPath+filePath;
//			}
//			System.out.println(" destinationPath  ==== "+destinationPath);				

			viewInvoice(response, servletOutputStream, destinationPath, fileExtension, fileName);

		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}

	}

	private void viewInvoice(HttpServletResponse response,ServletOutputStream servletOutputStream,String destinationPath, String fileExtension, String fileName)
	{

		try
		{			
			if(fileExtension.equalsIgnoreCase("pdf")){
				response.setContentType("application/pdf");
			} else if(fileExtension.equalsIgnoreCase(".jpg") || fileExtension.equalsIgnoreCase(".jpeg")) {
				response.setContentType("application/jpg");
			}
			
			response.setHeader("Content-disposition","inline;filename="+fileName);				
			DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);						
			FileInputStream fis = new FileInputStream(destinationPath);
			byte [] buffer = new byte [1024];
			int len = 0;
			while ((len = fis.read(buffer)) >= 0 ) 
			{
				outputStream.write(buffer, 0, len);
			}
			servletOutputStream.flush();
			servletOutputStream.close();
		}
		catch (Exception e){
			e.printStackTrace();
		}
	
		
	}	
			
  


}
