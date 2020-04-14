package t4u.sandmining;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;
import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.SandMiningFunctions;


public class DailyMonitoringReportPDF extends HttpServlet {
	
BaseFont baseFont = null;
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		String date =""; 
		int systemId =0;
		String dateToDisplay ="";
		String clientid = "";
		String division = "";
		int offset=0;
		JSONArray jsonarray = new JSONArray();
		ArrayList<String> datalists = new ArrayList<String>();
		ArrayList reportList = new ArrayList();
		try
			{   
				HttpSession session = request.getSession();
				LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");				
			    systemId = loginInfoBean.getSystemId();		        
		        offset=loginInfoBean.getOffsetMinutes();
				division = request.getParameter("clientName");
				clientid= request.getParameter("clientId");
				date = request.getParameter("date");
					
				dateToDisplay = date;		
				String[] dateFormat = date.split("-");
				date = dateFormat[2]+"-"+dateFormat[1]+"-"+dateFormat[0];				
			    
			    SandMiningFunctions  smf = new SandMiningFunctions(); 
			    jsonarray = smf.getDailyMonitorReport(systemId, clientid, date, offset);
               
				for (int i = 0; i < jsonarray.length(); i++) {				
					datalists = new ArrayList<String>();
					JSONObject obj = jsonarray.getJSONObject(i);
					String assetNumber = obj.getString("assetNumber");
					String liveStatus = obj.getString("liveStatus");
					String overSpeedStatus = obj.getString("overSpeedStatus");
					String permitStatus = obj.getString("permitStatus");
					String portEntryStatus = obj.getString("portEntryStatus");
					String multipleMDP = obj.getString("multipleMDP");
					String nearToBorder = obj.getString("nearToBorder");
					String CrossBorder = obj.getString("CrossBorder");
					String restrictivePortEntry = obj.getString("restrictivePortEntry");
					String insuranceStatus = obj.getString("insuranceStatus");
					String assetFitnesStatus = obj.getString("assetFitnesStatus");
					String emissionStatus = obj.getString("emissionStatus");
										
					datalists.add(assetNumber);
					datalists.add(liveStatus);
					datalists.add(overSpeedStatus);
					datalists.add(permitStatus);
					datalists.add(portEntryStatus);
					datalists.add(multipleMDP);
					datalists.add(nearToBorder);
					datalists.add(CrossBorder);
					datalists.add(restrictivePortEntry);
					datalists.add(insuranceStatus);
					datalists.add(assetFitnesStatus);
					datalists.add(emissionStatus);
					
					reportList.add(datalists);
										
				     }
 
				ServletOutputStream servletOutputStream = response.getOutputStream();
				
				Properties p=ApplicationListener.prop;
				String crystalReport=p.getProperty("crystalReport");
				String verdanaFontPath=p.getProperty("verdanaFontPath");
				String pdfpath=  crystalReport;
				refreshdir(pdfpath);
				String formno="DailyMonitoring"+systemId;
				String fontPath = verdanaFontPath;
				baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
				String pdf = pdfpath+formno+".pdf";
			
				ArrayList<String> headersList = new ArrayList<String>();
				headersList.add("SlNo");
				headersList.add("Vehicle Number");
				headersList.add("Live Status");
				headersList.add("Over Speed Status");
				headersList.add("Permit Status");
				headersList.add("Port Entry Status");
				headersList.add("Multiple MDP");
				headersList.add("Near To Border");
				headersList.add("Cross Border");
				headersList.add("Restrictive Port Entry");
				headersList.add("Insurance Status");
				headersList.add("Asset Fitness Status");
				headersList.add("Emission Status");
	
				generatePdf(pdf,headersList,reportList,systemId,division,dateToDisplay,request);
			
				printPdf(servletOutputStream,response,pdf,formno);//same for all								
			}
			catch (Exception e) 
			{
				e.printStackTrace();
			}
		}

			

     private void generatePdf(String pdf,ArrayList<String> headerList,ArrayList<String> reportList,int systemId,String division, String dateToDisplay, HttpServletRequest request) {										 
				try
				{			
					FileOutputStream fileOut = new FileOutputStream(pdf);
					Document document = new Document(PageSize.A4.rotate(), 20, 20, 30, 20);
					PdfWriter writer = PdfWriter.getInstance(document,fileOut);
					document.open();
					
					String headingString0 = "Division: " +division;
					String headingString2 = "Date: "+dateToDisplay;
					String headingString3 = "Action required:  ";
					String headingString4 = "To be observed:  ";
				    String headingString5 = "Within safe zone:  ";	
				    
			
					    PdfPTable headerTableTitle = createPdfHead("",request); 
					    document.add(headerTableTitle);
					
						PdfPTable headerTable = createPdfSubHead1("",headingString0);
						document.add(headerTable);
						PdfPTable headerTable1 = createPdfSubhead2("",headingString2);
						document.add(headerTable1);
						
						PdfPTable headerRed = createActionRequiredHeader("",headingString3);
						document.add(headerRed);
						PdfPTable headerYellow = createToBeObserved("",headingString4);
						document.add(headerYellow);
						PdfPTable headerGreen = createWithinSafeZone("",headingString5);
						document.add(headerGreen);
						
						PdfPTable emptySpace= createSpace("",headingString0);
						document.add(emptySpace);
											
						PdfPTable headerForTable = getHeaderTable(headerList);
						document.add(headerForTable);
						
						PdfPTable dataPdfPTable = getDataPdftableformaintreport(reportList,headerList.size());					
						document.add(dataPdfPTable);
	
					    document.close();
					
					}
				catch (Exception e) 
				{
					e.printStackTrace();
				}
			}
	
	
	private PdfPTable createPdfHead(String PDForm, HttpServletRequest request)
	{

		float[] widths = {5,100}; 
		PdfPTable t = new PdfPTable(2);
		try
		{
			t.setWidthPercentage(120); 
			t.setWidths(widths);
						
			Phrase phrase = new Phrase("\n\n\n\n");
			PdfPCell cell = new PdfPCell(phrase);
			cell.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			cell.setBorder(Rectangle.NO_BORDER);
			t.addCell(cell);
			
			Phrase myPhrase=new Phrase("Daily Monitoring Report",new Font(baseFont, 14, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(1);
			t.addCell(c);
			
			Phrase phrase2 = new Phrase("\n\n\n");
			PdfPCell cell2 = new PdfPCell(phrase2);
			cell2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			cell2.setBorder(Rectangle.NO_BORDER);
			t.addCell(cell2);

		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return t;

	}
	
	private PdfPTable createPdfSubHead1(String PDForm,String headingString)
	{
		float[] widths = {5,100};
		PdfPTable t = new PdfPTable(2);
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			Phrase myPhrase=new Phrase(headingString,new Font(baseFont,(float) 10.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);			
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return t;	
	}
	
	private PdfPTable createPdfSubhead2(String PDForm,String headingString){
		float[] widths = {5,100};
		PdfPTable t = new PdfPTable(2);	
		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);
			
			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.white);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			Phrase myPhrase=new Phrase(headingString,new Font(baseFont, 10, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);	
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return t;	
     }	
	
	private PdfPTable createActionRequiredHeader(String PDForm,String headingString){
	
		float[] widths = {20,5,2};
		PdfPTable t = new PdfPTable(3);		
		try
		{
			t.setWidthPercentage(70);
			t.setWidths(widths);
			
			Phrase myPhrased=new Phrase("                                             ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell cd = new PdfPCell(myPhrased);
			cd.setBackgroundColor(Color.white);
			cd.setBorder(Rectangle.NO_BORDER);				
			t.addCell(cd);
			
			Phrase myPhrase=new Phrase(headingString,new Font(baseFont,(float) 10.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBackgroundColor(Color.white);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			t.addCell(c1);
			
			
			Phrase myPhrase2=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c2 = new PdfPCell(myPhrase2);
			c2.setBackgroundColor(Color.red);
			c2.setBorder(Rectangle.CELL);
			c2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c2);

			
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return t;	
	}	
	
	private PdfPTable createToBeObserved(String PDForm,String headingString){
	
		float[] widths = {20,5,2};
		PdfPTable t = new PdfPTable(3);
        try{
			t.setWidthPercentage(70);
			t.setWidths(widths);

			Phrase myPhrased=new Phrase("                                             ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell cd = new PdfPCell(myPhrased);
			cd.setBackgroundColor(Color.white);
			cd.setBorder(Rectangle.NO_BORDER);				
			t.addCell(cd);
			
			Phrase myPhrase=new Phrase(headingString,new Font(baseFont,(float) 10.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBackgroundColor(Color.white);
			c1.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);		
			
			Phrase myPhrase2=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c2 = new PdfPCell(myPhrase2);
			c2.setBackgroundColor(Color.yellow);
			c2.setBorder(Rectangle.CELL);
			c2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c2);			
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return t;	
	}
	
	private PdfPTable createWithinSafeZone(String PDForm,String headingString){
	
		float[] widths = {20,5,2};
		PdfPTable t = new PdfPTable(3);
		try
		{
			t.setWidthPercentage(70);
			t.setWidths(widths);

			Phrase myPhrased=new Phrase("                                             ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell cd = new PdfPCell(myPhrased);
			cd.setBackgroundColor(Color.white);
			cd.setBorder(Rectangle.NO_BORDER);				
			t.addCell(cd);
			
			Phrase myPhrase=new Phrase(headingString,new Font(baseFont,(float) 10.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBackgroundColor(Color.white);
			c1.setBorder(Rectangle.NO_BORDER);
			c1.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			t.addCell(c1);

			Phrase myPhrase2=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c2 = new PdfPCell(myPhrase2);
			c2.setBackgroundColor(Color.green);
			c2.setBorder(Rectangle.CELL);
			c2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c2);
	
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return t;	
	}
	
	
	public PdfPTable getHeaderTable(ArrayList<String> dataList){
	
		float[] dataCellsSize = {12.5f,12.5f,12.5f,12.5f,12.5f,12.5f,12.5f,12.5f}; 
		PdfPTable dataTable = makeTable(dataList.size());
		try 
		{
			dataTable.setWidthPercentage(90);	
			for(int i=0;i<dataList.size();i++)
			{
				Phrase dataPhrase = new Phrase(dataList.get(i).toString(),new Font(baseFont, 9, Font.BOLD));
				PdfPCell dataCell = new PdfPCell(dataPhrase);
				dataCell.setBorder(Rectangle.NO_BORDER);
				dataCell.setBackgroundColor(Color.LIGHT_GRAY);
				dataCell.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				dataTable.addCell(dataCell);
			}			
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}
		return dataTable;
	}

	public PdfPTable getDataPdftableformaintreport(ArrayList dataList,int size){
	            
		        PdfPTable mainDataListTable = null;
				PdfPTable mainDataTable=null;
				boolean summaryRow = false;
				//dataList.add(0,"break");
				
				try 
				{
					int cc = 0;
					Phrase dataPhrase = null;
					Phrase colorPhrase = null;
					PdfPCell dataCell = null;
					mainDataTable=makeTable(1);
					mainDataTable.setWidthPercentage(90);
					
					for(int i =0;i < dataList.size(); i++)
					{
						
						if(i==0)
						{
							
						}
						if (dataList.get(i) instanceof ArrayList) 
						{
							mainDataListTable=makeTable(size);
							ArrayList data = (ArrayList) dataList.get(i);
							
							if(summaryRow == false){
								data.add(0,++cc);
							}
							else{
								data.add(0,"");
							}
							
							for (int j = 0; j < data.size(); j++){
								int font = Font.NORMAL;
								int fontSize = 7;
								if(summaryRow)
								{
									font = Font.BOLD;
									fontSize = 7;
								}
								if(data.get(j) != null)
								{
									dataPhrase = new Phrase(data.get(j).toString(),new Font(baseFont, fontSize, font));
								}
								else
								{
									dataPhrase = new Phrase("",new Font(baseFont, fontSize, font));
								}
								if(data.get(j).toString().equals("Red")){
								dataPhrase = new Phrase("",new Font(baseFont, fontSize, font));
								dataCell = new PdfPCell(dataPhrase);
								dataCell.setBorder(Rectangle.CELL);
								dataCell.setBackgroundColor(Color.red);								
								dataCell.setHorizontalAlignment(1);								
								mainDataListTable.addCell(dataCell);
							   }
								else if(data.get(j).toString().equals("Green")){
									dataPhrase = new Phrase("",new Font(baseFont, fontSize, font));
									dataCell = new PdfPCell(dataPhrase);									
									dataCell.setBorder(Rectangle.CELL);
									dataCell.setBackgroundColor(Color.green);								
									dataCell.setHorizontalAlignment(1);								
									mainDataListTable.addCell(dataCell);	
								}
								else if(data.get(j).toString().equals("Yellow")){
									dataPhrase = new Phrase("",new Font(baseFont, fontSize, font));
									dataCell = new PdfPCell(dataPhrase);									
									dataCell.setBorder(Rectangle.CELL);
									dataCell.setBackgroundColor(Color.yellow);								
									dataCell.setHorizontalAlignment(1);								
									mainDataListTable.addCell(dataCell);	
								}
								else{
								dataCell = new PdfPCell(dataPhrase);
								dataCell.setBorder(Rectangle.CELL);
								dataCell.setHorizontalAlignment(Rectangle.CELL);								
								mainDataListTable.addCell(dataCell);
								}
							}
							mainDataTable.addCell(mainDataListTable);
							summaryRow = false;
						}
						else
						{
						
							PdfPTable emptyTable=makeTable(1);
							emptyTable.setWidthPercentage(100);
							colorPhrase = new Phrase("No Records found",new Font(baseFont, 8, Font.BOLD));
							dataCell = new PdfPCell(colorPhrase);
							dataCell.setBorder(Rectangle.CELL);
							dataCell.setHorizontalAlignment(Rectangle.CELL);								
							mainDataListTable.addCell(dataCell);
											
						}
						
					}
								
				}
				catch (Exception e) 
				{
					e.printStackTrace();
				}
				return mainDataTable;
			}
	
	private PdfPTable makeTable(int rows) {
				
					PdfPTable table = new PdfPTable(rows);
					table.getDefaultCell().setBorder(1);
					table.getDefaultCell().setBorderWidth(1);					
					return table;			
			}
	public PdfPCell makeCell(Phrase phrase, int alignment) {
				PdfPCell cell = new PdfPCell(phrase);
				cell.setHorizontalAlignment(alignment);
				cell.setBackgroundColor(Color.red);
				cell.setBorder(1);
				return cell;
			}

	
	
	private PdfPTable createSpace(String PDForm,String headingString){
	
		float[] widths = {100}; 
		PdfPTable t = new PdfPTable(1);
		try
		{
			t.setWidthPercentage(120); 
			t.setWidths(widths);	
			Phrase phrase = new Phrase("\n\n\n");
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
	private void refreshdir(String reportpath){	
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
	}
	
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

 }// end of main

