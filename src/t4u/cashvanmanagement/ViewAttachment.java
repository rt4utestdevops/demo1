package t4u.cashvanmanagement;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;

import java.io.IOException;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import t4u.common.ApplicationListener;
import t4u.functions.CashVanManagementFunctions;


public class ViewAttachment extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	File outFile;
	CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
	
	
	
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    	
   		 				
   		try
		      {   
				
				String quotionId = 	request.getParameter("systemQuotationId");
				String sysId = request.getParameter("systemId");
				String custId = request.getParameter("clientId");
				String filePath = "";
				filePath = cashVanfunc.getFilePathFromDB(Integer.parseInt(sysId),Integer.parseInt(custId),Integer.parseInt(quotionId));

				if(filePath != null && !filePath.equals("")){
					filePath = filePath.substring(filePath.lastIndexOf("//"), filePath.length());		

				   filePath = filePath.substring(2);
				
				}		
			    ServletOutputStream servletOutputStream=response.getOutputStream();
			    
			    Properties properties = ApplicationListener.prop;
				
				String excelpath = properties.getProperty("DocumentDownloadPathForQuotation").trim();
				
				if(!filePath.equals("")){
				excelpath = excelpath+filePath;
				}else if(filePath.equals("")){
					excelpath = excelpath+"Blank.xls";	
				}

		printExcel(response,servletOutputStream,excelpath);

	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	
 }

	private void printExcel(HttpServletResponse response,ServletOutputStream servletOutputStream,String excel)
	{

		try
		{			
			String formno=excel;
			response.setContentType("application/octet-stream");
			response.setHeader("Content-disposition","inline;filename="+formno);				
			DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);						
			FileInputStream fis = new FileInputStream(excel);
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

