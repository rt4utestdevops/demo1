package t4u.GeneralVertical.SupervisorSchedule;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.CTDashboardFunctions;

public class UploadExcelToDB extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private boolean isMultipart;
	private String message;
	private File file;
	CTDashboardFunctions ctf = new CTDashboardFunctions();
	public UploadExcelToDB() {
		super();
	}
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}


	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		Properties properties = null;
		properties = ApplicationListener.prop;
		//String FileDestination = properties.getProperty("CreateTripImage");
		String message ="";
        HttpSession session = request.getSession();
        LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
        int customerId = loginInfo.getCustomerId();
        
		isMultipart = ServletFileUpload.isMultipartContent(request);
		response.setContentType("text/html");
		if (!isMultipart) {
			message="No Upload This Time";
			System.out.println("No Upload This Time");
			return;
		}
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// Create a new file upload handler
		ServletFileUpload up = new ServletFileUpload(factory);
		try {
			List <FileItem> fileItems = up.parseRequest(request);
			
			for ( FileItem file : fileItems )
		    {
		        byte[] fileName = file.getName().getBytes();
		        ByteArrayInputStream inStream = new ByteArrayInputStream(fileName);
		        try
		        {
		            String uploadName = new String( fileName, "utf-8" );
		            System.out.println( uploadName );

		            File writeFile = new File( uploadName );

		            file.write(writeFile);
		            FileInputStream fileIS = new FileInputStream(writeFile);
			        XSSFWorkbook workbook = new XSSFWorkbook(fileIS); 
			        XSSFSheet sheet = workbook.getSheetAt(0); 
			        Row row;
			        List<SupervisorScheduleModel> supervisorScheduleList = new ArrayList<SupervisorScheduleModel>();
			        SupervisorScheduleModel supervisorScheduleModel = null;
			        
			        DataFormatter dataFormatter = new DataFormatter();
			        
			        for(int i=2; i<=sheet.getLastRowNum(); i++){  //points to the starting of excel i.e excel first row
			            row = (Row) sheet.getRow(i);  //sheet number
			            supervisorScheduleModel = new SupervisorScheduleModel();
			            
			                String supervisorName;
			                if( dataFormatter.formatCellValue(row.getCell(0))== "" || row.getCell(0).getStringCellValue()==null) {
			                	supervisorName = ""; 
			                	}
			                else supervisorName= row.getCell(0).getStringCellValue();
			                supervisorScheduleModel.setSupervisorName(supervisorName);
			                
			                   String hubName;
			                if( dataFormatter.formatCellValue(row.getCell(1))== "" || dataFormatter.formatCellValue(row.getCell(1))== null) {
			                	hubName = "";
			                	}  //suppose excel cell is empty then its set to 0 the variable
			                   else hubName = dataFormatter.formatCellValue(row.getCell(1));//row.getCell(1).toString();   //else copies cell data to name variable
			                supervisorScheduleModel.setHubName(hubName);
			                
			                   String hubCode;
			                if( dataFormatter.formatCellValue(row.getCell(2))== "" || dataFormatter.formatCellValue(row.getCell(2)) ==null) { 
			                	hubCode = "";  
			                	}else{
			                	   		hubCode   = dataFormatter.formatCellValue(row.getCell(2));//row.getCell(2).toString();
			                	   
			                   }
			                supervisorScheduleModel.setHubCode(hubCode);
			                
			                String shiftStartTiming;
			                if( dataFormatter.formatCellValue(row.getCell(3))== "" || row.getCell(3).getNumericCellValue()==0) {
			                	shiftStartTiming = "";   
			                	}
			                else  shiftStartTiming   =  dataFormatter.formatCellValue(row.getCell(3));
			                
			                supervisorScheduleModel.setShiftStartTiming(shiftStartTiming);
			                
			                String shiftEndTiming;
			                if( dataFormatter.formatCellValue(row.getCell(4))== "" || row.getCell(4).getNumericCellValue()==0) {
			                	shiftEndTiming = "";  
			                	}
			                   else  shiftEndTiming   = dataFormatter.formatCellValue(row.getCell(4));
			                supervisorScheduleModel.setShiftEndTiming(shiftEndTiming);
			                
			                String contactNumber;
			                if( dataFormatter.formatCellValue(row.getCell(5))== "" || row.getCell(5)== null) {
			                	contactNumber = "";   }
			                   else{
			                	   //contactNumber   = NumberToTextConverter.toText(row.getCell(5).getNumericCellValue());
			                	   contactNumber   = dataFormatter.formatCellValue(row.getCell(5));
			                   }
			                supervisorScheduleModel.setContactNumber(contactNumber);
			                supervisorScheduleModel.setSystemId(systemId);
			                supervisorScheduleModel.setCustomerId(customerId);
			                
			                supervisorScheduleList.add(supervisorScheduleModel);

			        }    
			        if(supervisorScheduleList.size()==0){
			        	message = "No Data to Insert.";
			        }else{
			        	message = ctf.uploadSupervisorScheduleTableFromExcel(supervisorScheduleList);
			        	
			        }
					response.getWriter().print(message.toString());


		        } catch ( Exception e )
		        {
		        	message = "Failed.";
		            e.printStackTrace();
		        }

		    }
			String excelUploadMsg = message;
			session.setAttribute("excelUploadMsg", excelUploadMsg);
				 response.sendRedirect(request.getContextPath()+"/Jsps/GeneralVertical/CTAdminDashboard.jsp");
		} catch (Exception e) {
			String excelUploadMsg="Failed";
			session.setAttribute("excelUploadMsg", excelUploadMsg);
			e.printStackTrace();
			response.sendRedirect(request.getContextPath()+"/Jsps/GeneralVertical/CTAdminDashboard.jsp");
		}
	}
	
	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init() throws ServletException {
		// Put your code here
	}

}
