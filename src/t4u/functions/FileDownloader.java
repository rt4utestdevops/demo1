package t4u.functions;

import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.Properties;
 
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import t4u.common.ApplicationListener;
 
public class FileDownloader extends HttpServlet {
	
	
    public void doGet(HttpServletRequest request, HttpServletResponse response)
    throws javax.servlet.ServletException, java.io.IOException {
		Properties p=ApplicationListener.prop;
		String logPath=p.getProperty("logsPath");
    	String filePath=logPath;//"c://logs/";
    	 String fileName = filePath+request.getParameter("fileName");
        startDownload(request, response,fileName);
    }
 
    public void doPost(HttpServletRequest request, HttpServletResponse response)
    throws javax.servlet.ServletException, java.io.IOException {
		Properties p=ApplicationListener.prop;
		String logPath=p.getProperty("logsPath");
    	String filePath=logPath;//"c://logs/";
   	 String fileName = filePath+request.getParameter("fileName");
        startDownload(request, response,fileName);
    }
 
    public void startDownload(HttpServletRequest request,
        HttpServletResponse response,String fileName)
    throws javax.servlet.ServletException, java.io.IOException {
 
        File file = new File(fileName);
 
        ServletOutputStream stream = null;
        BufferedInputStream buf = null;
        try {
            stream = response.getOutputStream();
            // set response headers
            response.setContentType("application/msword");
            response.setDateHeader("Expires", 0);
            response.addHeader("Content-Disposition",
                "attachment; filename=ExportExcel.xls");
            response.setContentLength((int) file.length());
            buf = new BufferedInputStream(new FileInputStream(file));
            int readBytes = 0;
            while ((readBytes = buf.read()) != -1)
                stream.write(readBytes);
        } finally {
            if (stream != null)
                stream.flush();
            stream.close();
            if (buf != null)
                buf.close();
            
            if(file.delete())
            {
               // System.out.println("File deleted successfully");
            }
            else
            {
                System.out.println("Failed to delete the file");
            }
        }
    }
}