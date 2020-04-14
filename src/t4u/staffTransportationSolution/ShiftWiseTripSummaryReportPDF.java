package t4u.staffTransportationSolution;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.StaffTransportationSolutionFunctions;

import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class ShiftWiseTripSummaryReportPDF extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	BaseFont baseFont = null;
		
		@SuppressWarnings("unchecked")
		protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{

			try{
				HttpSession session = request.getSession();
				LoginInfoBean loginInfo = (LoginInfoBean)session.getAttribute("loginInfoDetails");
				
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
				int offset = loginInfo.getOffsetMinutes();
				String systemId = request.getParameter("SystemId").trim();
				String customerId = request.getParameter("CustId").trim();
				String branchId = request.getParameter("BranchId").trim();
				String startTime = request.getParameter("startTime");
				String endTime = request.getParameter("endTime");
				String shiftId = "0";
				Properties properties = ApplicationListener.prop;
				String imagepath = properties.getProperty("ImagePath");
				String imgName = imagepath + "custlogo_" + systemId  + "_"+ customerId + ".gif";

				if(request.getParameter("ShiftId").trim()!=null && !request.getParameter("ShiftId").trim().equals("")){
					shiftId = request.getParameter("ShiftId").trim();
				}
				String date = request.getParameter("Date");

				String custName = request.getParameter("CustName");
				String branchName =  request.getParameter("BranchName");
				String shiftName =  request.getParameter("ShiftName");           
				String eDate = request.getParameter("endDate");
				String buttonValue = request.getParameter("buttonValue");

				date = date.replace("T", " ");
				eDate=eDate.replace("T", " ");
				sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				df = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
				String starttimeforshow = date;
				String endtimeforshow = eDate;
				if(buttonValue.equals("DateWise")){
					starttimeforshow = df.format(sdf.parse(date));
					endtimeforshow = df.format(sdf.parse(eDate));
				}
				StaffTransportationSolutionFunctions  sbj = new StaffTransportationSolutionFunctions(); 
				if (customerId != null && !customerId.equals("")) {
					ArrayList < Object > list = sbj.getViewDetails(Integer.parseInt(systemId), Integer.parseInt(customerId),Integer.parseInt(branchId),Integer.parseInt(shiftId), date,eDate,offset,buttonValue);

					ReportHelper reportHelper = (ReportHelper) list.get(1);
					ArrayList reportdataList = new ArrayList();

					ReportHelper Report = new ReportHelper();
					Report = reportHelper ;
					ReportHelper reportData = new ReportHelper();
					ArrayList headerList = (ArrayList) Report.getHeadersList();
					ArrayList dataLists = (ArrayList) Report.getReportsList();
					ArrayList dataList = (ArrayList) Report.getReportsList();

					for (int i = 0; i < dataLists.size(); i++) {
						reportData = (ReportHelper) dataLists.get(i);
						dataList = (ArrayList) reportData.getInformationList();

						ArrayList finalData = new ArrayList();
						for (int j = 1; j < dataList.size(); j++) {
							finalData.add(dataList.get(j));
						}

						reportdataList.add(finalData);
					}


					ServletOutputStream servletOutputStream = response.getOutputStream();
					String pdfpath=  properties.getProperty("Builtypath");

					String formno="ShiftWiseTripSummaryReport"+systemId;
					String fontPath = properties.getProperty("FontPathForMaplePDF");
					baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
					String pdf = pdfpath+formno+".pdf";
					FileOutputStream fileOut = new FileOutputStream(pdf);
					Document document = new Document(PageSize.A4.rotate());
					@SuppressWarnings("unused")
					PdfWriter writer = PdfWriter.getInstance(document,fileOut);
					document.open();
					generatePdf(document,pdf,headerList,reportdataList,Integer.parseInt(systemId),request,  custName, branchName, shiftName,  date,  eDate,starttimeforshow,endtimeforshow,buttonValue, imgName, startTime, endTime);
					document.close();
					printPdf(servletOutputStream,response,pdf,formno);//same for all	

				}
			}catch(Exception e){
				e.printStackTrace();
			}

		}	
		
		 private void generatePdf(Document document,String pdf,ArrayList<String> headerList,ArrayList<String> reportList,int systemId, HttpServletRequest request, String custName,String branchName,String shiftName,String  date, String Edate,String starttimeforshow,String endtimeforshow,String buttonValue, String imgPath, String startTime, String endTime) {										 
				try
				{			
					String headingString0 = "Customer Name : "+custName;
					String headingString1 = "Group Name : "+branchName;
					String headingString2 = "";	
					String headingString3 = "";
					String header = "";
					if(buttonValue.equals("ShiftWise")){
						headingString2 = "Shift Name :  " + shiftName +" ("+startTime+"-"+endTime+")";
						header = "Vehicle Trip Summary Report(Shift Wise)";	
						headingString3 = "Date :  "+starttimeforshow+" to "+endtimeforshow ;	
					}else if(buttonValue.equals("DateWise")){
						headingString2 = "";
						header = "Vehicle Trip Summary Report(Date Wise)";
						headingString3 = "Date :  "+starttimeforshow+" to "+endtimeforshow;	
					}
								    
					    PdfPTable headerTableTitle = createPdfHead(header,request, imgPath); 
					    document.add(headerTableTitle);
										    
						PdfPTable headerTable = createPdfSubHeader(headingString0,headingString1,headingString2,headingString3);
						document.add(headerTable);
						
						PdfPTable emptySpace2= createSpace("",headingString0);
						document.add(emptySpace2);
												
						PdfPTable dataPdfPTable = createTableDetails(headerList,reportList,headerList.size());					
						document.add(dataPdfPTable);
					
					}
				catch (Exception e) 
				{
					e.printStackTrace();
				}
			}
		
	private PdfPTable createPdfHead(String PDForm, HttpServletRequest request, String imagepath)
	{

		float[] widths = {10,90}; 
		PdfPTable t = new PdfPTable(2);
		try
		{
			t.setWidthPercentage(100); 
			t.setWidths(widths);
			t.setSpacingAfter(10f);		
			try {
				Image img1 = Image.getInstance(imagepath);
				PdfPCell c = new PdfPCell(img1);
				c.setBorderColor(Color.white);
				c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(c);
			} catch (Exception e) {
				System.out.println(e.toString());
				PdfPCell c = new PdfPCell();
				c.setBorderColor(Color.white);
				t.addCell(c);
			}
			
			PdfPCell c = new PdfPCell(new Phrase(PDForm,new Font(baseFont, 11, Font.BOLD)));
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);

		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return t;

	}
	
	private PdfPTable createPdfSubHeader(String headingString0,String headingString1,String headingString2,String headingString3)
	{
		float[] widths = {50,50};
		PdfPTable t = new PdfPTable(2);
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			PdfPCell c1 = new PdfPCell(new Phrase(headingString0+"\n\n"+headingString1+"\n\n",new Font(baseFont,9, Font.BOLD)));
			c1.setBorder(Rectangle.TOP | Rectangle.BOTTOM | Rectangle.LEFT);
			c1.setBorderWidth(1);
			c1.setBorderColor(Color.GRAY);
			c1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c1);
			
			
			PdfPCell c3 = new PdfPCell(new Phrase(headingString2+"\n\n"+headingString3+"\n\n",new Font(baseFont,9, Font.BOLD)));
			c3.setBorder(Rectangle.TOP | Rectangle.BOTTOM | Rectangle.RIGHT);
			c3.setBorderWidth(1);
			c3.setBorderColor(Color.GRAY);
			c3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			t.addCell(c3);
				
			
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return t;	
	}

	
	@SuppressWarnings({ "unchecked" })
	private PdfPTable createTableDetails(ArrayList headerList,ArrayList dataList,int size)
	{ 
	
		
		PdfPTable t = new PdfPTable(headerList.size());
		Phrase myPhrase =null;
		PdfPCell c =null;
		try 
		{
			t.setWidthPercentage(100);	
			for(int i=0;i<headerList.size();i++)
			{
				myPhrase = new Phrase(headerList.get(i).toString(),new Font(baseFont, 9, Font.BOLD));
				PdfPCell dataCell = new PdfPCell(myPhrase);
				dataCell.setBorderWidth(0.5f);
				dataCell.setBorder(Rectangle.LEFT|Rectangle.TOP|Rectangle.BOTTOM);
				dataCell.setBackgroundColor(Color.LIGHT_GRAY);
				dataCell.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(dataCell);
			}			
		
			int slno=0;
			
			for(int i=0;i<dataList.size();i++)
			{
				slno++;
				
			ArrayList items = new ArrayList(); 
				items = (ArrayList) dataList.get(i);
				String vehicleNo =items.get(0).toString();
				int NoOfTrips = items.get(1) != null && !items.get(1).equals("") ? Integer.parseInt(items.get(1).toString()): 0;
				double TotalKmsTravelled = items.get(2) != null && !items.get(2).equals("") ? Double.parseDouble(items.get(2).toString()): 0;
				double AverageKms = items.get(3) != null && !items.get(3).equals("") ? Double.parseDouble(items.get(3).toString()): 0;
				String TotalDuration =items.get(4).toString();
				String AverageDuration = items.get(5).toString();		 
				double Odometer = items.get(6) != null && !items.get(6).equals("") ? Double.parseDouble(items.get(6).toString()): 0;
				String LastKnownTime = items.get(7).toString();
	            String tripDuration =items.get(8).toString();
	            String maxSpeed="";
	            if(items.get(9)!=null){
	            	maxSpeed = items.get(9).toString();
	            }
	            String speedLimit="";
	            if(items.get(10)!=null){
	            	speedLimit = items.get(10).toString();
	            }
	           
	            String OScount = items.get(11).toString();
	            String HAcount = items.get(12).toString();
	            String HBcount = items.get(13).toString();
	            String idleCount =items.get(14).toString();
	            String SBAlertCount = items.get(15).toString();
	            String idleDuration = items.get(16).toString();
								
				myPhrase=new Phrase("\n"+ +slno +".",new Font(baseFont, 6, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+vehicleNo+"",new Font(baseFont, 6, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+NoOfTrips+"",new Font(baseFont, 6, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
			
				myPhrase=new Phrase("\n"+TotalKmsTravelled+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+AverageKms+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+TotalDuration+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+AverageDuration +"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
			
				myPhrase=new Phrase("\n"+Odometer+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+LastKnownTime+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+tripDuration+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+maxSpeed+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);

				myPhrase=new Phrase("\n"+speedLimit+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+OScount+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+HAcount+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+HBcount+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+idleCount+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+SBAlertCount+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n"+idleDuration+"",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				myPhrase=new Phrase("\n",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
			}
					
			
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return t;				
	}

	private PdfPTable createSpace(String PDForm,String headingString){
	
		float[] widths = {100}; 
		PdfPTable t = new PdfPTable(1);
		try
		{
			t.setWidthPercentage(120); 
			t.setWidths(widths);	
			Phrase phrase = new Phrase("\n");
			PdfPCell cell = new PdfPCell(phrase);
			cell.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			cell.setBorder(Rectangle.NO_BORDER);
			t.addCell(cell);				
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return t;

	}		
	/** if directory not exixts then create it */
	/*private void refreshdir(String reportpath){	
		try
		{
			File f = new File(reportpath);
			if(!f.exists())
			{
				f.mkdir();
			}
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
	}*/
	
/////////////////////////////////print pdf//////////////////////////////////////////////////////////////////////////////

	private void printPdf(ServletOutputStream servletOutputStream,HttpServletResponse response,String pdf,String PDForm){
			
				try
				{
					String formno=PDForm;
					response.setContentType("application/pdf");
					response.setHeader("Content-disposition","attachment;filename="+formno+".pdf");
					FileInputStream fis = new FileInputStream(pdf);
					DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);
					byte [] buffer = new byte [1024];
					int len = 0;
					while ((len = fis.read(buffer)) >= 0 ) 
					{
						outputStream.write(buffer, 0, len);
					}
					
					servletOutputStream.flush();
					servletOutputStream.close();
				}
				catch (Exception e) 
				{
					e.printStackTrace();
				}
			}	


		
		
}
