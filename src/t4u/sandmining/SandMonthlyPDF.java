package t4u.sandmining;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.geom.Rectangle2D;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.jfree.chart.ChartFactory;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.CategoryLabelPositions;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.axis.SubCategoryAxis;
import org.jfree.chart.axis.ValueAxis;
import org.jfree.chart.labels.ItemLabelAnchor;
import org.jfree.chart.labels.ItemLabelPosition;
import org.jfree.chart.labels.StandardCategoryItemLabelGenerator;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.Plot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.category.BarRenderer;
import org.jfree.chart.renderer.category.GroupedStackedBarRenderer;
import org.jfree.chart.title.LegendTitle;
import org.jfree.data.KeyToGroupMap;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.ui.GradientPaintTransformType;
import org.jfree.ui.RectangleEdge;
import org.jfree.ui.StandardGradientPaintTransformer;
import org.jfree.ui.TextAnchor;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;


import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.HeaderFooter;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.DefaultFontMapper;
import com.lowagie.text.pdf.PdfContentByte;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfTemplate;
import com.lowagie.text.pdf.PdfWriter;

public class SandMonthlyPDF extends HttpServlet {
	static BaseFont baseFont = null;
	static int font=9;
	int systemId ;
	int clientId ;
	int userId;
	String month;
	String year;
	String systemName="";
	String startdatenew="";
	String strDate="";
	String endDate;
	String startDate;
	String monthName;
	int offset;
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {	
		try
		{
			HttpSession session = request.getSession();
			LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			systemId = loginInfoBean.getSystemId();
			systemName= loginInfoBean.getSystemName();
			clientId = loginInfoBean.getCustomerId();
			offset=loginInfoBean.getOffsetMinutes();
			userId = loginInfoBean.getUserId();
			DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
			Date newdate = new Date(); 
			strDate = dateFormat.format(newdate);
			SimpleDateFormat simpleDateFormatddMMYYYYDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			startdatenew=request.getParameter("monthName")+" - "+request.getParameter("year");
			month = request.getParameter("month");
			year = request.getParameter("year");
			Calendar c = Calendar.getInstance();
		    int yearNum = Integer.parseInt(year);
		    int monthNum =  Integer.parseInt(month)+1;
		    c.set(yearNum, monthNum, 0);
		    int LastDayofMonth = c.getActualMaximum(Calendar.DAY_OF_MONTH);
		    String d1 = year+"-"+monthNum+"-01";
		    String d2 = year+"-"+monthNum+"-"+Integer.toString(LastDayofMonth);
		    java.util.Date startdate = sdf.parse(d1);
		    startDate  = simpleDateFormatddMMYYYYDB.format(startdate);
		    java.util.Date enddate = sdf.parse(d2);
		    endDate = simpleDateFormatddMMYYYYDB.format(enddate);
			ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String pdfFileName="SandMonthly";
			//String fontPath = "C:\\timesNew.ttf";
			String formno="MONTHLY SAND REPORT";
			baseFont = BaseFont.createFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, false);
			String bill = billpath+ pdfFileName + ".pdf";
			generateBill(bill);
			printBill(servletOutputStream,response,bill,formno);
			
		}
		catch (Exception e) 
		{
			System.out.println("Error generating pdf form : " + e);
			e.printStackTrace();
		}
	}

	@SuppressWarnings("static-access")
	private void generateBill(String bill) {
		//Document document = new Document();
		Document document = new Document(PageSize.A4, 40, 40, 30, 20);
		Image img = null;   
		
	      try
	      {
	    	  
	    	 ArrayList<Object> RevenueDetailsAL = new ArrayList<Object>();
			 RevenueDetailsAL=getRevenueDetails(); 
			 
			 ArrayList<Object> subTripTotalAL = new ArrayList<Object>();
			 subTripTotalAL=getSubTripTotalDetails(); 
			 
			 ArrayList<Object> unAuthorizedAL = new ArrayList<Object>();
			 unAuthorizedAL=getUnAthorizedDetails(); 
			 
			 ArrayList<Object> crossBorderAL = new ArrayList<Object>();
			 crossBorderAL=getCrossBorderDetails();
			 
			 ArrayList<Object> TamperedPoweroffAL = new ArrayList<Object>();
			 TamperedPoweroffAL=getTamperedPoweroffDetails();
			 
			 try {
				 
				img = Image.getInstance(System.getProperty("catalina.base")+"/webapps/ApplicationImages/CustomerLogos/defaultImage.gif");//defaultImage
				img.setAbsolutePosition(document.right()-100, document.top()-85);//setAlignment(document.right()-50, document.top()-50);//Image.AY);//(document.right()-50, document.top()-50);
				img.scaleAbsolute(85, 85);
			 } catch (MalformedURLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		//	Chunk chunk = new Chunk(img, 0, -45);
			
		//	 document.setHeader(new HeaderFooter(new Phrase(chunk), false));
			 
			// Paragraph HeaderText = new Paragraph("Sand Transportation Surveillance Report", new Font(baseFont, 14, Font.NORMAL)); // Phrase 1

			//Paragraph HeaderImage = new Paragraph(chunk); // LOGO
			//HeaderImage.setAlignment(Element.ALIGN_RIGHT);
			 
			Paragraph para = new Paragraph();
			//para.add(HeaderText);
			//para.add(HeaderImage);
		
//			LineBorder border = new LineBorder(Color.black);
//			border.createBlackLineBorder();
			//border.createGrayLineBorder();

			 HeaderFooter header=new HeaderFooter(new Phrase("Sand Transportation Surveillance Report \n \n \n",new Font(baseFont, 15, Font.BOLD)),false);
		//	 HeaderFooter header=new HeaderFooter(HeaderText,HeaderImage);
			 header.setPageNumber(0);
			 header.setAlignment(HeaderFooter.ALIGN_CENTER);
			 header.setBorder(Rectangle.NO_BORDER);
			 
			 HeaderFooter footer=new HeaderFooter(new Phrase("Contact Telematics4u Services:- \n Email:-t4uhelpdesk@telematics4u.com | LL – 080-22179789/90/93                                                                                         ",new Font(baseFont,10, Font.NORMAL)), true);
			 footer.setPageNumber(0);
			 footer.setBorder(Rectangle.NO_BORDER);
			 footer.setAlignment(HeaderFooter.ALIGN_LEFT);
	         PdfWriter writer = PdfWriter.getInstance(document, new FileOutputStream(bill));
	         
	        
	         //***************Adding Image PdfContentByte*************************
	     /*    PdfContentByte byte1 = writer.getDirectContent();
             PdfTemplate tp1 = byte1.createTemplate(600, 150);
             tp1.addImage(img);

             PdfContentByte byte2 = writer.getDirectContent();
             PdfTemplate tp2 = byte2.createTemplate(600, 150);
             tp2.addImage(img);

             byte1.addTemplate(tp1, 0, 715);
             byte2.addTemplate(tp2, 0, 0);

             Phrase phrase1 = new Phrase(byte1 + "shahid Kapoor", FontFactory.getFont(FontFactory.TIMES_ROMAN, 7, Font.NORMAL));
             Phrase phrase2 = new Phrase(byte2 + "", FontFactory.getFont(FontFactory.TIMES_ROMAN, 7, Font.NORMAL));

             HeaderFooter header1 = new HeaderFooter(phrase1, true)*/;
	         
	         document.setHeader(header);
	         document.setFooter(footer);//(footer);
	         //document.add(HeaderImage);
	        // document.add((Element) border);
	         document.open();
    
	       //******Page Border***********************
	     //  document.getPageSize().setBorderWidth(3);
	         Rectangle custA4=PageSize.A4;
             Rectangle layout = new Rectangle(custA4.getLeft()+20,custA4.getTop()-15,custA4.getRight()-20,custA4.getBottom()+15);
	         layout.setBorderColor(Color.BLACK);  //Border color
	         layout.setBorderWidth(2);      //Border width  
	         layout.setBorder(Rectangle.BOX);  //Border on 4 sides
	         document.add(layout);
	         
	         document.add(img);
	         
	         document.add(new Paragraph(" "));
	          
	         PdfPTable formHeader=createHeader();
			 document.add(formHeader);
			 
			 document.add(new Paragraph(" "));
			
			 PdfPTable SummaryTable=createSummaryTable();
			 document.add(SummaryTable);
			 
			 document.add(new Paragraph(" "));
			 document.add(new Paragraph(" "));
			 document.add(new Paragraph(" "));
			 document.add(new Paragraph(" "));
			 document.add(new Paragraph(" "));
			 document.add(new Paragraph(" "));
			// document.add(new Paragraph(" "));
			// document.add(new Paragraph(" "));
			 
			 PdfPTable formHeader1=createHeader1();
			 document.add(formHeader1);
			 
			 document.newPage();
			 document.add(layout);
	
			 Chunk underline = new Chunk(" SUB DIVISION WISE REVENUE EARNING REPORT: ");
	         underline.setUnderline(0.1f, -1f);
	         document.add(underline);
	         
	         document.add(new Paragraph(" "));
	         document.add(new Paragraph(" "));
		 
			 PdfPTable RevenueTable=createRevenueTable(RevenueDetailsAL,subTripTotalAL);
			 document.add(RevenueTable);
			
			 document.newPage();
			 document.add(layout);
			 
			 Chunk underline1 = new Chunk(" MDPs Vs Revenue generated: ");
	         underline1.setUnderline(0.1f, -1f);
	         document.add(underline1);
	         
	         document.add(new Paragraph(" "));
	         document.add(new Paragraph(" "));
	         
			 JFreeChart chart1 = getMdpRevenue();
			 PdfContentByte contentByte1 = writer.getDirectContent();
		     PdfTemplate template1 = contentByte1.createTemplate(500, 600);
		     Graphics2D graphics2d1 = template1.createGraphics(500, 600, new DefaultFontMapper());
			 Rectangle2D rectangle2d1 = new Rectangle2D.Double(0, 0, 500, 600);
			 chart1.draw(graphics2d1, rectangle2d1);
			 graphics2d1.dispose();
			 contentByte1.addTemplate(template1, 50, 120);
			 
			 document.newPage();
			 document.add(layout);
			 
			 Chunk underline3 = new Chunk(" TOTAL SAND QUANTITY CHART: ");
	         underline3.setUnderline(0.1f, -1f);
	         document.add(underline3);
	         
	         document.add(new Paragraph(" "));
	         document.add(new Paragraph(" "));
	         
			 JFreeChart chart = getTripSheets();
			 //  JFreeChart chart = generateBarChart();
			     
		     PdfContentByte contentByte = writer.getDirectContent();
		     PdfTemplate template = contentByte.createTemplate(500, 600);
		     Graphics2D graphics2d = template.createGraphics(500, 600, new DefaultFontMapper());
			 Rectangle2D rectangle2d = new Rectangle2D.Double(0, 0, 500, 600);
			 chart.draw(graphics2d, rectangle2d);
			 graphics2d.dispose();
			 contentByte.addTemplate(template, 50,120);
			 
			 document.newPage();
			 document.add(layout);
				 
			 Chunk underline4 = new Chunk(" Performance Analysis: ");
	         underline4.setUnderline(0.1f, -1f);
	         document.add(underline4);
	         
	         document.add(new Paragraph(" "));
	         document.add(new Paragraph(" "));
				 
			 JFreeChart chart2 = getPerformenceChart();
			 PdfContentByte contentByte2 = writer.getDirectContent();
		     PdfTemplate template2 = contentByte2.createTemplate(500, 600);
		     Graphics2D graphics2d2 = template2.createGraphics(500, 600, new DefaultFontMapper());
			 Rectangle2D rectangle2d2 = new Rectangle2D.Double(0, 0, 500, 600);
			 chart2.draw(graphics2d2, rectangle2d2);
			 graphics2d2.dispose();
			 contentByte2.addTemplate(template2, 50, 120);
			 
			 document.newPage();
			 document.add(layout);
			 
			 JFreeChart chart3 = getAverageMDPQuantity();
			 PdfContentByte contentByte3 = writer.getDirectContent();
		     PdfTemplate template3 = contentByte3.createTemplate(500, 600);
		     Graphics2D graphics2d3 = template3.createGraphics(500, 600, new DefaultFontMapper());
			 Rectangle2D rectangle2d3 = new Rectangle2D.Double(0, 0, 500, 600);
			 chart3.draw(graphics2d3, rectangle2d3);
			 graphics2d3.dispose();
			 contentByte3.addTemplate(template3, 50, 120);
			 
			 document.newPage();
			 document.add(layout);
			 
			 JFreeChart chart4 = getAverageMDPRevenue();
			 PdfContentByte contentByte4 = writer.getDirectContent();
		     PdfTemplate template4 = contentByte4.createTemplate(500, 600);
		     Graphics2D graphics2d4 = template4.createGraphics(500, 600, new DefaultFontMapper());
			 Rectangle2D rectangle2d4 = new Rectangle2D.Double(0, 0, 500, 600);
			 chart4.draw(graphics2d4, rectangle2d4);
			 graphics2d4.dispose();
			 contentByte4.addTemplate(template4, 50, 120);
			 
			 document.newPage();
			 document.add(layout);
			 
			 Chunk underline2 = new Chunk(" Exceptions /Alerts Report: \n\n a. Unauthorized port entry (without Permit)");
	         underline2.setUnderline(0.1f, -1f);
	         document.add(underline2);
	         
	         document.add(new Paragraph(" "));
	         
	        // Chunk underline2 = new Chunk(" a.Unauthorized port entry (without Permit) ");
	       //  underline1.setUnderline(0.1f, -1f);
	        // document.add(underline2);
	         
	         PdfPTable UnauthorizedTable=createUnauthorizedTable(unAuthorizedAL);
	         document.add(UnauthorizedTable);
	         
	         document.newPage();
			 document.add(layout); 
			 
	         Chunk underline5 = new Chunk(" b. Border Crossed");
	         underline5.setUnderline(0.1f, -1f);
	         document.add(underline5);
	         
	         document.add(new Paragraph(" "));
	         
	         PdfPTable BorderCrossedTable=createCrossBorderTable(crossBorderAL);
	         document.add(BorderCrossedTable);
	         
	         document.newPage();
			 document.add(layout); 
			 
	         Chunk underline6 = new Chunk(" c.	Tampered/Power off");
	         underline6.setUnderline(0.1f, -1f);
	         document.add(underline6);
	         
	         document.add(new Paragraph(" "));
	         
	         PdfPTable TamperedPoweroff=createTamperedPoweroffTable(TamperedPoweroffAL);
	         document.add(TamperedPoweroff);
	        
	         document.close();
	         writer.close();
	      } catch (DocumentException e)
	      {
	         e.printStackTrace();
	      } catch (FileNotFoundException e)
	      {
	         e.printStackTrace();
	      }
		
	}

	/** if directory not exists then create it */
	private void refreshdir(String reportpath)
	{
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
			System.out.println("Error creating PDF form for Mining :  " + e);
			e.printStackTrace();
		}
	}
	
	private void printBill(ServletOutputStream servletOutputStream,HttpServletResponse response,String bill,String PDForm)
	{
		try
		{
			String formno=PDForm;
			response.setContentType("application/pdf");
			response.setHeader("Content-disposition","attachment;filename="+formno+".pdf");
			FileInputStream fis = new FileInputStream(bill);
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
			System.out.println("Error printing pdf form : " + e);
			e.printStackTrace();
		}
	}
	
	 private PdfPTable createHeader () {

			float[] width = {100};
			PdfPTable Headertable = new PdfPTable(1);
			
			try {
				
				Headertable.setWidthPercentage(100);
				Headertable.setWidths(width);
			
				String District = getDistrictName();
				
				/*Phrase myPhrase=new Phrase("Sand Transportation Surveillance Report",new Font(baseFont,14, Font.BOLD));
			    PdfPCell c1 = new PdfPCell(myPhrase);
			    c1.setBorder(Rectangle.NO_BORDER);
			    c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c1.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c1);*/
			    
			    //Empty line
				Phrase myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c2 = new PdfPCell(myPhrase);
			    c2.setBorder(Rectangle.NO_BORDER);
			    c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c2.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c2);
			    
				myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c3 = new PdfPCell(myPhrase);
			    c3.setBorder(Rectangle.NO_BORDER);
			    c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c3.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c3);
			    
				myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c4 = new PdfPCell(myPhrase);
			    c4.setBorder(Rectangle.NO_BORDER);
			    c4.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c4.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c4);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c5 = new PdfPCell(myPhrase);
			    c5.setBorder(Rectangle.NO_BORDER);
			    c5.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c5.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c5);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c5extra1 = new PdfPCell(myPhrase);
			    c5extra1.setBorder(Rectangle.NO_BORDER);
			    c5extra1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c5extra1.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c5extra1);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c5extra2 = new PdfPCell(myPhrase);
			    c5extra2.setBorder(Rectangle.NO_BORDER);
			    c5extra2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c5extra2.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c5extra2);
			    
			    //District Name
			    myPhrase=new Phrase("District Name : "+District+ ",  KARNATAKA",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c6 = new PdfPCell(myPhrase);
			    c6.setBorder(Rectangle.NO_BORDER);
			    c6.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c6.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c6);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c7 = new PdfPCell(myPhrase);
			    c7.setBorder(Rectangle.NO_BORDER);
			    c7.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c7.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c7);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c8 = new PdfPCell(myPhrase);
			    c8.setBorder(Rectangle.NO_BORDER);
			    c8.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c8.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c8);
			    
			    //Sand Mining Operation Date
			    myPhrase=new Phrase("Sand Mining Operation Month : "+startdatenew,new Font(baseFont,12, Font.BOLD));
			    PdfPCell c9 = new PdfPCell(myPhrase);
			    c9.setBorder(Rectangle.NO_BORDER);
			    c9.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c9.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c9);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c10 = new PdfPCell(myPhrase);
			    c10.setBorder(Rectangle.NO_BORDER);
			    c10.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c10.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c10);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c12 = new PdfPCell(myPhrase);
			    c12.setBorder(Rectangle.NO_BORDER);
			    c12.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c12.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c12);
			    
			    
			    //Report Submission Date 
			    myPhrase=new Phrase("Report Generation Date : "+strDate,new Font(baseFont,12, Font.BOLD));
			    PdfPCell c13 = new PdfPCell(myPhrase);
			    c13.setBorder(Rectangle.NO_BORDER);
			    c13.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c13.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c13);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c14 = new PdfPCell(myPhrase);
			    c14.setBorder(Rectangle.NO_BORDER);
			    c14.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c14.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c14);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c15 = new PdfPCell(myPhrase);
			    c15.setBorder(Rectangle.NO_BORDER);
			    c15.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c15.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c15);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c16 = new PdfPCell(myPhrase);
			    c16.setBorder(Rectangle.NO_BORDER);
			    c16.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c16.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c16);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c17 = new PdfPCell(myPhrase);
			    c17.setBorder(Rectangle.NO_BORDER);
			    c17.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c17.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c17);
			      
			} catch (Exception e) {
				e.printStackTrace();
			}
			return Headertable;
		}
	
	 //*****************************note**********************//
	 private PdfPTable createHeader1 () {

			float[] width = {100};
			PdfPTable Headertable = new PdfPTable(1);
			
			try {
				
				Headertable.setWidthPercentage(100);
				Headertable.setWidths(width);
				
				Phrase myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c2 = new PdfPCell(myPhrase);
			    c2.setBorder(Rectangle.NO_BORDER);
			    c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c2.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c2);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c3 = new PdfPCell(myPhrase);
			    c3.setBorder(Rectangle.NO_BORDER);
			    c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c3.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c3);
			    
				myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c4 = new PdfPCell(myPhrase);
			    c4.setBorder(Rectangle.NO_BORDER);
			    c4.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c4.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c4);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c5 = new PdfPCell(myPhrase);
			    c5.setBorder(Rectangle.NO_BORDER);
			    c5.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c5.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c5);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c5extra1 = new PdfPCell(myPhrase);
			    c5extra1.setBorder(Rectangle.NO_BORDER);
			    c5extra1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c5extra1.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c5extra1);
			    
			    myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c5extra2 = new PdfPCell(myPhrase);
			    c5extra2.setBorder(Rectangle.NO_BORDER);
			    c5extra2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			    c5extra2.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c5extra2);
			    
			    myPhrase=new Phrase("NOTE : More details available at following pages",new Font(baseFont,12, Font.NORMAL));
			    PdfPCell c13 = new PdfPCell(myPhrase);
			    c13.setBorder(Rectangle.NO_BORDER);
			    c13.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c13.setBackgroundColor(Color.WHITE);
			    Headertable.addCell(c13);
			    
			} catch (Exception e) {
				e.printStackTrace();
			}
			return Headertable;
		}
	 	//*****************************Summary Table***********************************************
		private PdfPTable createSummaryTable() {
			float[] widths = {75,35};
			PdfPTable summaryTable = new PdfPTable(2);
			
			try
			{
				summaryTable.setWidthPercentage(100);
				summaryTable.setWidths(widths);
				
				ArrayList<String> count=totalcount();
				Phrase myPhrase=new Phrase("SUMMARY Of OPERATIONS",new Font(baseFont,12, Font.BOLD));
				PdfPCell c1 = new PdfPCell(myPhrase);
				c1.disableBorderSide(Rectangle.BOTTOM);
				c1.disableBorderSide(Rectangle.RIGHT);
				c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c1.setFixedHeight(30);
				c1.setBackgroundColor(Color.YELLOW); 
				summaryTable.addCell(c1);
				
				myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
				PdfPCell c2 = new PdfPCell(myPhrase);
				c2.disableBorderSide(Rectangle.BOTTOM);
				c2.disableBorderSide(Rectangle.LEFT);
				c2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				c2.setFixedHeight(30);
				c2.setBackgroundColor(Color.YELLOW);
				summaryTable.addCell(c2);
				
				myPhrase=new Phrase("No.Of Permits(MDPs) given",new Font(baseFont, 10, Font.NORMAL));
				PdfPCell c3 = new PdfPCell(myPhrase);
				c3.setFixedHeight(25);
				c3.setBackgroundColor(Color.WHITE);
				//c3.disableBorderSide(Rectangle.RIGHT);
				c3.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				summaryTable.addCell(c3);
				
				myPhrase=new Phrase(count.get(0),new Font(baseFont,font, Font.BOLD)); //Dynamic No of TS
				PdfPCell c4 = new PdfPCell(myPhrase);
				c4.setFixedHeight(25);
				c4.setBackgroundColor(Color.WHITE);
				c4.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c4);
				
				myPhrase=new Phrase("Total Quantity In cubic meter",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c5 = new PdfPCell(myPhrase);
				c5.setFixedHeight(25);
				c5.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c5);
				
				myPhrase=new Phrase(count.get(1),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c6 = new PdfPCell(myPhrase);
				c6.setFixedHeight(25);
				c6.setBackgroundColor(Color.WHITE);
				c6.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c6);
				
				myPhrase=new Phrase("Total Revenue Generated In INR",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c7 = new PdfPCell(myPhrase);
				c7.setFixedHeight(25);
				c7.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c7);
				
				myPhrase=new Phrase(count.get(2),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c8 = new PdfPCell(myPhrase);
				c8.setFixedHeight(25);
				c8.setBackgroundColor(Color.WHITE);
				c8.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c8);
				
				//*********************************Vehicle details Registered In our PF************************************
				ArrayList<String> nogps=getNoGps();
				myPhrase=new Phrase("No.Of Vehicles Registered In Platform",new Font(baseFont,12, Font.NORMAL));
				PdfPCell c9 = new PdfPCell(myPhrase);
				c9.disableBorderSide(Rectangle.BOTTOM);
				c9.setFixedHeight(25);
				c9.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c9);
				
				myPhrase=new Phrase("",new Font(baseFont,10, Font.NORMAL)); //Dynamic Quantity
				PdfPCell c10 = new PdfPCell(myPhrase);
				c10.setFixedHeight(25);
				c10.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c10);
				
				//With GPS
				myPhrase=new Phrase("    a. With GPS As on "+strDate +" ------------------------------------------------------------->",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c11 = new PdfPCell(myPhrase);
				c11.disableBorderSide(Rectangle.BOTTOM);
				c11.disableBorderSide(Rectangle.TOP);
			//	c11.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c11.setFixedHeight(20);
				c11.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c11);
				
				myPhrase=new Phrase(nogps.get(3),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c12 = new PdfPCell(myPhrase);
				c12.setFixedHeight(20);
				c12.setBackgroundColor(Color.WHITE);
				c12.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c12);
				
				//Without GPS
				myPhrase=new Phrase("    b. Without GPS As on "+strDate +" ---------------------------------------------------------->",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c13 = new PdfPCell(myPhrase);
				c13.disableBorderSide(Rectangle.BOTTOM);
				c13.disableBorderSide(Rectangle.TOP);
			//	c13.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c13.setFixedHeight(20);
				c13.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c13);
				
				myPhrase=new Phrase(nogps.get(0),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c14 = new PdfPCell(myPhrase);
				c14.setFixedHeight(20);
				c14.setBackgroundColor(Color.WHITE);
				c14.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c14);
				
				//Communicating
				myPhrase=new Phrase("    c. Communicating As on "+strDate +" -------------------------------------------------------->",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c15 = new PdfPCell(myPhrase);
				c15.disableBorderSide(Rectangle.BOTTOM);
				c15.disableBorderSide(Rectangle.TOP);
				//c15.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c15.setFixedHeight(20);
				c15.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c15);
				
				myPhrase=new Phrase(nogps.get(1),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c16 = new PdfPCell(myPhrase);
				c16.setFixedHeight(20);
				c16.setBackgroundColor(Color.WHITE);
				c16.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c16);
				
				//Non Communicating
				myPhrase=new Phrase("    d. Non Communicating As on "+strDate +" ---------------------------------------------------->",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c17 = new PdfPCell(myPhrase);
				c17.disableBorderSide(Rectangle.BOTTOM);
				c17.disableBorderSide(Rectangle.TOP);
				//c17.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c17.setFixedHeight(20);
				c17.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c17);
				
				myPhrase=new Phrase(nogps.get(2),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c18 = new PdfPCell(myPhrase);
				c18.setFixedHeight(20);
				c18.setBackgroundColor(Color.WHITE);
				c18.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c18);
				
				//New Vehicles Registerd
				ArrayList<String> vehicleregisterd=getVehicleRegistered();
				myPhrase=new Phrase("    e. New Vehicles Registered ---------------------------------------------->",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c19 = new PdfPCell(myPhrase);
				c19.disableBorderSide(Rectangle.BOTTOM);
				c19.disableBorderSide(Rectangle.TOP);
				//c19.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c19.setFixedHeight(20);
				c19.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c19);
				
				myPhrase=new Phrase(vehicleregisterd.get(0),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c20 = new PdfPCell(myPhrase);
				c20.setFixedHeight(20);
				c20.setBackgroundColor(Color.WHITE);
				c20.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c20);
				
				//Vehicles Unregistered
				ArrayList<String> vehicleUnregisterd=getVehicleUnRegistered();
				myPhrase=new Phrase("    f. Vehicles Unregistered -------------------------------------------->",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c21 = new PdfPCell(myPhrase);
				c21.disableBorderSide(Rectangle.BOTTOM);
				c21.disableBorderSide(Rectangle.TOP);
				//c21.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c21.setFixedHeight(20);
				c21.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c21);
				
				myPhrase=new Phrase(vehicleUnregisterd.get(0),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c22 = new PdfPCell(myPhrase);
				c22.setFixedHeight(20);
				c22.setBackgroundColor(Color.WHITE);
				c22.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c22);
				
				//**********************************Exceptions/Alert Reports***************************************************
				ArrayList<String> port=getUnAuthPort();
				myPhrase=new Phrase("Exceptions / Alerts Report",new Font(baseFont,12, Font.NORMAL));
				PdfPCell c23 = new PdfPCell(myPhrase);
				c23.disableBorderSide(Rectangle.BOTTOM);
				c23.setFixedHeight(25);
				c23.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c23);
				
				myPhrase=new Phrase("",new Font(baseFont,10, Font.NORMAL)); //Dynamic Quantity
				PdfPCell c24 = new PdfPCell(myPhrase);
				c24.setFixedHeight(25);
				c24.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c24);
				
				//Unauthorized port Entry
				myPhrase=new Phrase("    a. Unauthorized Port Entry ----------------------------------------------------->",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c25 = new PdfPCell(myPhrase);
				c25.disableBorderSide(Rectangle.BOTTOM);
				c25.disableBorderSide(Rectangle.TOP);
				c25.setFixedHeight(20);
				c25.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c25);
				
				myPhrase=new Phrase(port.get(0),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c26 = new PdfPCell(myPhrase);
				c26.setFixedHeight(20);
				c26.setBackgroundColor(Color.WHITE);
				c26.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c26);
				
				//Border Crossed
				ArrayList<String> crossBorder=getborderCrossed();
				myPhrase=new Phrase("    b. Border Crossed -------------------------------------------------------------->",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c27 = new PdfPCell(myPhrase);
				c27.disableBorderSide(Rectangle.BOTTOM);
				c27.disableBorderSide(Rectangle.TOP);
				c27.setFixedHeight(20);
				c27.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c27);
				
				myPhrase=new Phrase(crossBorder.get(0),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c28 = new PdfPCell(myPhrase);
				c28.setFixedHeight(20);
				c28.setBackgroundColor(Color.WHITE);
				c28.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c28);
				
				//Tampered/Power Off
				myPhrase=new Phrase("    c. Tampered / Power Off--------------------------------------------------------->",new Font(baseFont,10, Font.NORMAL));
				PdfPCell c29 = new PdfPCell(myPhrase);
				//c29.disableBorderSide(Rectangle.BOTTOM);
				c29.disableBorderSide(Rectangle.TOP);
				c29.setFixedHeight(20);
				c29.setBackgroundColor(Color.WHITE);
				summaryTable.addCell(c29);
				
				myPhrase=new Phrase(crossBorder.get(1),new Font(baseFont,10, Font.BOLD)); //Dynamic Quantity
				PdfPCell c30 = new PdfPCell(myPhrase);
				c30.setFixedHeight(20);
				c30.setBackgroundColor(Color.WHITE);
				c30.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				summaryTable.addCell(c30);
				
				myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c31 = new PdfPCell(myPhrase);
			    c31.setBorder(Rectangle.NO_BORDER);
			    c31.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c31.setBackgroundColor(Color.WHITE);
			    summaryTable.addCell(c31);
			    
				myPhrase=new Phrase("",new Font(baseFont,12, Font.BOLD));
			    PdfPCell c32 = new PdfPCell(myPhrase);
			    c32.setBorder(Rectangle.NO_BORDER);
			    c32.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			    c32.setBackgroundColor(Color.WHITE);
			    summaryTable.addCell(c32);
			
			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining :  " + e);
				e.printStackTrace();
			}
			return summaryTable;	
		}
	
		private PdfPTable createRevenueTable(ArrayList<Object> revenueDetailsAL, ArrayList<Object> subTripTotalAL) {
			float[] widths = {30,40,25,25,25};
			PdfPTable RevenueTable = new PdfPTable(5);
			
			try
			{
				RevenueTable.setWidthPercentage(100);
				RevenueTable.setWidths(widths);
				
				Phrase myPhrase=new Phrase("",new Font(baseFont,10, Font.BOLD));
				PdfPCell c110 = new PdfPCell(myPhrase);
				c110.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			//	c110.disableBorderSide(Rectangle.LEFT);
				c110.disableBorderSide(Rectangle.RIGHT);
				c110.setFixedHeight(25);
				c110.setBackgroundColor(Color.ORANGE);
				RevenueTable.addCell(c110);
				
				myPhrase=new Phrase("REVENUE EARNING",new Font(baseFont,12, Font.BOLD));
				PdfPCell c111 = new PdfPCell(myPhrase);
				c111.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c111.disableBorderSide(Rectangle.LEFT);
				c111.disableBorderSide(Rectangle.RIGHT);
				c111.setFixedHeight(25);
				c111.setBackgroundColor(Color.ORANGE);
				RevenueTable.addCell(c111);
				
				myPhrase=new Phrase("REPORT - ",new Font(baseFont,12, Font.BOLD));
				PdfPCell c112 = new PdfPCell(myPhrase);
				c112.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				c112.disableBorderSide(Rectangle.LEFT);
				c112.disableBorderSide(Rectangle.RIGHT);
				c112.setFixedHeight(25);
				c112.setBackgroundColor(Color.ORANGE);
				RevenueTable.addCell(c112);
				
				myPhrase=new Phrase("",new Font(baseFont,10, Font.BOLD));
				PdfPCell c113 = new PdfPCell(myPhrase);
				c113.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c113.disableBorderSide(Rectangle.LEFT);
				c113.disableBorderSide(Rectangle.RIGHT);
				c113.setFixedHeight(25);
				c113.setBackgroundColor(Color.ORANGE);
				RevenueTable.addCell(c113);
				
				myPhrase=new Phrase("",new Font(baseFont,10, Font.BOLD));
				PdfPCell c114 = new PdfPCell(myPhrase);
				c114.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c114.disableBorderSide(Rectangle.LEFT);
			//	c114.disableBorderSide(Rectangle.RIGHT);
				c114.setFixedHeight(25);
				c114.setBackgroundColor(Color.ORANGE);
				RevenueTable.addCell(c114);
				
				myPhrase=new Phrase("TALUK",new Font(baseFont,10, Font.BOLD));
				PdfPCell c1 = new PdfPCell(myPhrase);
				c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c1.setFixedHeight(25);
				c1.setBackgroundColor(Color.CYAN);
				RevenueTable.addCell(c1);
				
				myPhrase=new Phrase("PORT NAME",new Font(baseFont,10, Font.BOLD));
				PdfPCell c2 = new PdfPCell(myPhrase);
				c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c2.setFixedHeight(30);
				c2.setBackgroundColor(Color.CYAN);
				RevenueTable.addCell(c2);
				
				myPhrase=new Phrase("TOTAL TRIP SHEETS",new Font(baseFont,10, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase);
				c3.setFixedHeight(25);
				c3.setBackgroundColor(Color.CYAN);
				//c3.disableBorderSide(Rectangle.RIGHT);
				c3.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				RevenueTable.addCell(c3);
				
				myPhrase=new Phrase("TOTAL SAND QUANTITY(CBM)",new Font(baseFont,10, Font.BOLD)); 
				PdfPCell c4 = new PdfPCell(myPhrase);
				c4.setFixedHeight(25);
				c4.setBackgroundColor(Color.CYAN);
				c4.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				RevenueTable.addCell(c4);
				
				myPhrase=new Phrase("AMOUNT COLLECTED (RS)",new Font(baseFont,10, Font.BOLD));
				PdfPCell c5 = new PdfPCell(myPhrase);
				c5.setFixedHeight(25);
				c5.setBackgroundColor(Color.CYAN);
				c5.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				RevenueTable.addCell(c5);
				String str ="";
				int j = 0;
				if(revenueDetailsAL.size()>0){
					for(int i=0;i<revenueDetailsAL.size();i++){
						if(i%5==0){
							if(!str.equalsIgnoreCase((String)revenueDetailsAL.get(i))){
								if(i>0){
									myPhrase=new Phrase("SUBTOTAL",new Font(baseFont,font, Font.BOLD));
									PdfPCell c6 = new PdfPCell(myPhrase);
									c6.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
									c6.setBackgroundColor(Color.WHITE);
									RevenueTable.addCell(c6);
									
									myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
									PdfPCell c7 = new PdfPCell(myPhrase);
									c7.setBackgroundColor(Color.WHITE);
									RevenueTable.addCell(c7);
									
									myPhrase=new Phrase((String)subTripTotalAL.get(j++),new Font(baseFont,font, Font.BOLD));
									PdfPCell c8 = new PdfPCell(myPhrase);
									c8.setBackgroundColor(Color.WHITE);
									RevenueTable.addCell(c8);
									
									myPhrase=new Phrase((String)subTripTotalAL.get(j++),new Font(baseFont,font, Font.BOLD));
									PdfPCell c9 = new PdfPCell(myPhrase);
									c9.setBackgroundColor(Color.WHITE);
									RevenueTable.addCell(c9);
									
									myPhrase=new Phrase((String)subTripTotalAL.get(j++),new Font(baseFont,font, Font.BOLD));
									PdfPCell c10 = new PdfPCell(myPhrase);
									c10.setBackgroundColor(Color.WHITE);
									RevenueTable.addCell(c10);
									j++;
								}
								str = (String)revenueDetailsAL.get(i);
								myPhrase=new Phrase((String) revenueDetailsAL.get(i),new Font(baseFont,font, Font.NORMAL));
								PdfPCell c9 = new PdfPCell(myPhrase);
								c9.setBackgroundColor(Color.WHITE);
								c9.disableBorderSide(Rectangle.BOTTOM);
								RevenueTable.addCell(c9);
							}else{
								myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
								PdfPCell c9 = new PdfPCell(myPhrase);
								c9.setBackgroundColor(Color.WHITE);
								if(i!=revenueDetailsAL.size()-5)
								c9.disableBorderSide(Rectangle.BOTTOM);
								c9.disableBorderSide(Rectangle.TOP);
								RevenueTable.addCell(c9);
							}
							
						}
						else{
							myPhrase=new Phrase((String) revenueDetailsAL.get(i),new Font(baseFont,font, Font.NORMAL));
							PdfPCell c9 = new PdfPCell(myPhrase);
							c9.setBackgroundColor(Color.WHITE);
							RevenueTable.addCell(c9);
							if(i==revenueDetailsAL.size()-1){
								myPhrase=new Phrase("SUBTOTAL",new Font(baseFont,font, Font.BOLD));
								PdfPCell c6 = new PdfPCell(myPhrase);
								c6.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
								c6.setBackgroundColor(Color.WHITE);
								RevenueTable.addCell(c6);
								
								myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
								PdfPCell c7 = new PdfPCell(myPhrase);
								c7.setBackgroundColor(Color.WHITE);
								RevenueTable.addCell(c7);
								
								myPhrase=new Phrase((String)subTripTotalAL.get(j++),new Font(baseFont,font, Font.BOLD));
								PdfPCell c8 = new PdfPCell(myPhrase);
								c8.setBackgroundColor(Color.WHITE);
								RevenueTable.addCell(c8);
								
								myPhrase=new Phrase((String)subTripTotalAL.get(j++),new Font(baseFont,font, Font.BOLD));
								c9 = new PdfPCell(myPhrase);
								c9.setBackgroundColor(Color.WHITE);
								RevenueTable.addCell(c9);
								
								myPhrase=new Phrase((String)subTripTotalAL.get(j++),new Font(baseFont,font, Font.BOLD));
								PdfPCell c10 = new PdfPCell(myPhrase);
								c10.setBackgroundColor(Color.WHITE);
								RevenueTable.addCell(c10);
								j++;
								
								myPhrase=new Phrase("GRAND TOTAL",new Font(baseFont,font, Font.BOLD));
								c6 = new PdfPCell(myPhrase);
								c6.setBackgroundColor(Color.GREEN);
								RevenueTable.addCell(c6);
								
								myPhrase=new Phrase("",new Font(baseFont,font, Font.NORMAL));
								 c7 = new PdfPCell(myPhrase);
								c7.setBackgroundColor(Color.GREEN);
								RevenueTable.addCell(c7);
								
								myPhrase=new Phrase((String)subTripTotalAL.get(j++),new Font(baseFont,font, Font.BOLD));
								 c8 = new PdfPCell(myPhrase);
								c8.setBackgroundColor(Color.GREEN);
								RevenueTable.addCell(c8);
								
								myPhrase=new Phrase((String)subTripTotalAL.get(j++),new Font(baseFont,font, Font.BOLD));
								c9 = new PdfPCell(myPhrase);
								c9.setBackgroundColor(Color.GREEN);
								RevenueTable.addCell(c9);
								
								myPhrase=new Phrase((String)subTripTotalAL.get(j++),new Font(baseFont,font, Font.BOLD));
								 c10 = new PdfPCell(myPhrase);
								c10.setBackgroundColor(Color.GREEN);
								RevenueTable.addCell(c10);
							}
						}
					
					}
				}
			
			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining :  " + e);
				e.printStackTrace();
			}
			return RevenueTable;	
		} 
		
		private PdfPTable createUnauthorizedTable(ArrayList<Object> unAuthorizedDetailsAL){
				float[] widths ={10,25,30,25,25,35};
				PdfPTable UnauthorizedTable = new PdfPTable(6);
				
				try
				{
					UnauthorizedTable.setWidthPercentage(100);
					UnauthorizedTable.setWidths(widths);
					
					Phrase myPhrase=new Phrase(("SLNO"),new Font(baseFont,11, Font.BOLD));
					PdfPCell c001 = new PdfPCell(myPhrase);
					c001.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c001.setBackgroundColor(Color.WHITE);
					UnauthorizedTable.addCell(c001);
					
					myPhrase=new Phrase(("Asset Number"),new Font(baseFont,11, Font.BOLD));
					PdfPCell c1 = new PdfPCell(myPhrase);
					c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c1.setBackgroundColor(Color.WHITE);
					UnauthorizedTable.addCell(c1);
					
					myPhrase=new Phrase(("Sand Block Name"),new Font(baseFont,11, Font.BOLD));
					PdfPCell c01 = new PdfPCell(myPhrase);
					c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c01.setBackgroundColor(Color.WHITE);
					UnauthorizedTable.addCell(c01);
					
					myPhrase=new Phrase(("Arrived Date & Time") ,new Font(baseFont,11, Font.BOLD));
					PdfPCell c02 = new PdfPCell(myPhrase);
					c02.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c02.setBackgroundColor(Color.WHITE);
					UnauthorizedTable.addCell(c02);
					
					myPhrase=new Phrase(("Detention in Minutes"),new Font(baseFont,11, Font.BOLD));
					PdfPCell c03 = new PdfPCell(myPhrase);
					c03.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c03.setBackgroundColor(Color.WHITE);
					UnauthorizedTable.addCell(c03);
					
					myPhrase=new Phrase(("Remarks") ,new Font(baseFont,11, Font.BOLD));
					PdfPCell c04 = new PdfPCell(myPhrase);
					c04.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					c04.setBackgroundColor(Color.WHITE);
					UnauthorizedTable.addCell(c04);
					
					if(unAuthorizedDetailsAL.size()>0){
						for(int i=0;i<unAuthorizedDetailsAL.size();i++){
							
							Phrase myPhrase11=new Phrase((String) unAuthorizedDetailsAL.get(i),new Font(baseFont,11, Font.NORMAL));
							PdfPCell c11 = new PdfPCell(myPhrase11);
							c11.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
							c11.setBackgroundColor(Color.WHITE);
							UnauthorizedTable.addCell(c11);
						}
					}
					
				}
				catch (Exception e) 
				{
					System.out.println("Error creating PDF form for Mining :  " + e);
					e.printStackTrace();
				}
				return UnauthorizedTable;	
			
		}
		
		private PdfPTable createCrossBorderTable(ArrayList<Object> crossBorderDetailsAL){
			float[] widths ={10,25,35,35};
			PdfPTable CrossBorderTable = new PdfPTable(4);
			
			try
			{
				CrossBorderTable.setWidthPercentage(100);
				CrossBorderTable.setWidths(widths);
				
				Phrase myPhrase1=new Phrase(("SLNO") ,new Font(baseFont,11, Font.BOLD));
				PdfPCell c01 = new PdfPCell(myPhrase1);
				c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c01.setBackgroundColor(Color.WHITE);
				CrossBorderTable.addCell(c01);
				
				myPhrase1=new Phrase(("Registration No") ,new Font(baseFont,11, Font.BOLD));
				PdfPCell c002 = new PdfPCell(myPhrase1);
				c002.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c002.setBackgroundColor(Color.WHITE);
				CrossBorderTable.addCell(c002);
				
				myPhrase1=new Phrase(("Alert Date") ,new Font(baseFont,11, Font.BOLD));
				PdfPCell c001 = new PdfPCell(myPhrase1);
				c001.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c001.setBackgroundColor(Color.WHITE);
				CrossBorderTable.addCell(c001);
				
				myPhrase1=new Phrase(("Location"),new Font(baseFont,11, Font.BOLD));
				PdfPCell c003 = new PdfPCell(myPhrase1);
				c003.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c003.setBackgroundColor(Color.WHITE);
				CrossBorderTable.addCell(c003);
				
				if(crossBorderDetailsAL.size()>0){
					for(int i=0;i<crossBorderDetailsAL.size();i++){
						Phrase myPhrase=new Phrase((String) crossBorderDetailsAL.get(i),new Font(baseFont,11, Font.NORMAL));
						PdfPCell c1 = new PdfPCell(myPhrase);
						c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
						c1.setBackgroundColor(Color.WHITE);
						CrossBorderTable.addCell(c1);
					}
				}
				
			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining :  " + e);
				e.printStackTrace();
			}
			return CrossBorderTable;	
		
	}
		
		private PdfPTable createTamperedPoweroffTable(ArrayList<Object> crossBorderDetailsAL){
			float[] widths ={10,25,35,35};
			PdfPTable CrossBorderTable = new PdfPTable(4);
			
			try
			{
				CrossBorderTable.setWidthPercentage(100);
				CrossBorderTable.setWidths(widths);
				
				Phrase myPhrase1=new Phrase(("SLNO") ,new Font(baseFont,11, Font.BOLD));
				PdfPCell c01 = new PdfPCell(myPhrase1);
				c01.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c01.setBackgroundColor(Color.WHITE);
				CrossBorderTable.addCell(c01);
				
				myPhrase1=new Phrase(("Registration No") ,new Font(baseFont,11, Font.BOLD));
				PdfPCell c002 = new PdfPCell(myPhrase1);
				c002.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c002.setBackgroundColor(Color.WHITE);
				CrossBorderTable.addCell(c002);
				
				myPhrase1=new Phrase(("Alert Date") ,new Font(baseFont,11, Font.BOLD));
				PdfPCell c001 = new PdfPCell(myPhrase1);
				c001.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c001.setBackgroundColor(Color.WHITE);
				CrossBorderTable.addCell(c001);
				
				myPhrase1=new Phrase(("Location"),new Font(baseFont,11, Font.BOLD));
				PdfPCell c003 = new PdfPCell(myPhrase1);
				c003.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c003.setBackgroundColor(Color.WHITE);
				CrossBorderTable.addCell(c003);
				
				if(crossBorderDetailsAL.size()>0){
					for(int i=0;i<crossBorderDetailsAL.size();i++){
						Phrase myPhrase=new Phrase((String) crossBorderDetailsAL.get(i),new Font(baseFont,11, Font.NORMAL));
						PdfPCell c1 = new PdfPCell(myPhrase);
						c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
						c1.setBackgroundColor(Color.WHITE);
						CrossBorderTable.addCell(c1);
					}
				}
				
			}
			catch (Exception e) 
			{
				System.out.println("Error creating PDF form for Mining :  " + e);
				e.printStackTrace();
			}
			return CrossBorderTable;	
		
	}
		private ArrayList<Object> getRevenueDetails() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<Object> informationList = new ArrayList<Object>();
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select sum(Counts) as Counts,sum(TotalFee) as TotalFees,sum(Total) as TotalQuantity,Taluk,From_Place from "
						+ " (select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet with(NOLOCK) "
						+ " where  System_Id=?  and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place "
						+ "union all " 
						+ "select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee , sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet_History with(NOLOCK) " 
						+ "where  System_Id=?  and Printed='Y' and Printed_Date between  dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place "
						+ ") sm group by Taluk,From_Place order by Taluk ");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, startDate);
				pstmt.setString(6, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					informationList.add( rs.getString("Taluk"));
					informationList.add( rs.getString("From_Place"));
					informationList.add( rs.getString("Counts"));
					informationList.add( rs.getString("TotalQuantity"));
					informationList.add( rs.getString("TotalFees"));
					
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return informationList;
		}
		
		//***********************To get SubTrip Total********************************************
		private ArrayList<Object> getSubTripTotalDetails() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<Object> SubTripTotalList = new ArrayList<Object>();
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select sum(Counts) as Counts,sum(TotalFee) as TotalFee,sum(Total) as TotalQuantity,Taluk from "
						+ "(select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk from Sand_Mining_Trip_Sheet with(NOLOCK) "
						+ "where  System_Id=?  and Printed='Y' and Printed_Date between  dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk "
						+ "union all " 
						+ "select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee , sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk from Sand_Mining_Trip_Sheet_History with(NOLOCK) "
						+ "where  System_Id=?  and Printed='Y' and Printed_Date between  dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk ) sm group by Taluk ");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, startDate);
				pstmt.setString(6, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					SubTripTotalList.add( rs.getString("Counts"));
					SubTripTotalList.add( rs.getString("TotalQuantity"));
					SubTripTotalList.add( rs.getString("TotalFee"));
					SubTripTotalList.add( rs.getString("Taluk"));
				}
				
				pstmt = con.prepareStatement("select sum(Counts) as Counts,sum(TotalFee) as TotalFee,sum(Total) as TotalQuantity from "
						+ "(select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total from Sand_Mining_Trip_Sheet with(NOLOCK) "
						+ "where   System_Id=? and Printed='Y' and Printed_Date between  dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) "
						+ "union all "
						+ "select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee , sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total from Sand_Mining_Trip_Sheet_History with(NOLOCK) "
						+ "where  System_Id=? and Printed='Y' and Printed_Date between  dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) ) sm ");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, startDate);
				pstmt.setString(6, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					SubTripTotalList.add( rs.getString("Counts"));
					SubTripTotalList.add( rs.getString("TotalQuantity"));
					SubTripTotalList.add( rs.getString("TotalFee"));
				}
				
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return SubTripTotalList;
		}
		
		//***********************************UnAuthorized Port Entry Table*****************************************
		private ArrayList<Object> getUnAthorizedDetails() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<Object> unAuthurizedList = new ArrayList<Object>();
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select ASSET_NUMBER,isnull(u.REMARKS,'') as REMARKS,s.Port_Name as SAND_BLOCK,l.NAME,dateadd(mi,330,ARRIVAL_TIME) as ARRIVAL_TIME,isnull(DETENTION,0) as DETENTION from dbo.UNAUTHORIZED_PORT_ENTRY u with(NOLOCK)"
											+ "left outer join dbo.LOCATION_ZONE_A l on l.HUBID=u.HUB_ID "
											+ "left outer join dbo.Sand_Port_Details s on s.UniqueId=u.PORT_NO " 
											+ "where u.SYSTEM_ID=? and  ARRIVAL_TIME between  dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) order by ASSET_NUMBER desc");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					unAuthurizedList.add(String.valueOf(count));
					unAuthurizedList.add( rs.getString("ASSET_NUMBER"));
					unAuthurizedList.add( rs.getString("SAND_BLOCK"));
					unAuthurizedList.add( rs.getString("ARRIVAL_TIME"));
					unAuthurizedList.add( rs.getString("DETENTION"));
					unAuthurizedList.add( rs.getString("REMARKS"));
					
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return unAuthurizedList;
		}
		
//*********************CROSS BORDER************************************************
	//	private HashMap<String,ArrayList<String>> getCrossBorderDetails() {
			private ArrayList<Object> getCrossBorderDetails() {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<Object> crossBorderList = new ArrayList<Object>();
			HashMap<String, ArrayList<String>> hashMap=new HashMap<String, ArrayList<String>>();
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select a.SLNO,a.REGISTRATION_NO,a.LOCATION,a.GPS_DATETIME,a.GMT,a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID "
											+ "from Alert a "
										//	+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no "
										//	+ "left outer join VEHICLE_CLIENT c on a.REGISTRATION_NO = c.REGISTRATION_NUMBER " 
											+ "where a.SYSTEM_ID=? and a.TYPE_OF_ALERT= 84 and " 													
											+ "a.GMT >= dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) "
											+ "and  (MONITOR_STATUS is null or MONITOR_STATUS='N') order by GPS_DATETIME desc ");
				pstmt.setInt(1, systemId);
				//pstmt.setInt(2, typeOfAlert);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					crossBorderList.add(String.valueOf(count));
					crossBorderList.add( rs.getString("REGISTRATION_NO"));
					crossBorderList.add( rs.getString("GPS_DATETIME"));
					crossBorderList.add( rs.getString("LOCATION"));
					//hashMap.put(rs.getString("REGISTRATION_NO"), crossBorderList);
										
				}
		
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return crossBorderList;
		}
		
			//*********************TAMPERED/POWER OFF************************************************
					private ArrayList<Object> getTamperedPoweroffDetails() {
					Connection con = null;
					PreparedStatement pstmt = null;
					ResultSet rs = null;
					ArrayList<Object> crossBorderList = new ArrayList<Object>();
					HashMap<String, ArrayList<String>> hashMap=new HashMap<String, ArrayList<String>>();
					try {
						int count=0;
						con = DBConnection.getConnectionToDB("AMS");
						pstmt = con.prepareStatement("select a.SLNO,a.REGISTRATION_NO,a.LOCATION,a.GPS_DATETIME,a.GMT,a.STOP_HOURS,isnull(a.REMARKS,'') as  REMARKS,a.HUB_ID "
													+ "from Alert a "
												//	+ "inner join Vehicle_User b on a.REGISTRATION_NO = b.Registration_no "
												//	+ "left outer join VEHICLE_CLIENT c on a.REGISTRATION_NO = c.REGISTRATION_NUMBER " 
													+ "where a.SYSTEM_ID=? and a.TYPE_OF_ALERT= 7 and " 													
													+ "a.GMT >= dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) "
													+ "and  (MONITOR_STATUS is null or MONITOR_STATUS='N') order by GPS_DATETIME desc ");
						pstmt.setInt(1, systemId);
						//pstmt.setInt(2, typeOfAlert);
						rs = pstmt.executeQuery();
						while (rs.next()) {
							count++;
							crossBorderList.add(String.valueOf(count));
							crossBorderList.add( rs.getString("REGISTRATION_NO"));
							crossBorderList.add( rs.getString("GPS_DATETIME"));
							crossBorderList.add( rs.getString("LOCATION"));
							//hashMap.put(rs.getString("REGISTRATION_NO"), crossBorderList);
												
						}
				
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
						DBConnection.releaseConnectionToDB(con, pstmt, rs);
					}

					return crossBorderList;
				}
				
			
//************************Total Trip Sheets*****************************************************
		private JFreeChart getTripSheets() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<String> informationList = new ArrayList<String>();
			DefaultCategoryDataset dataSet = null;
			JFreeChart chart = null;
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select sum(Counts) as Counts,sum(TotalFee) as TotalFees,sum(Total) as TotalQuantity,Taluk,From_Place from "
											+ " (select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet with(NOLOCK) "
											+ " where  System_Id=? and Printed='Y' and Printed_Date between  dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place "
											+ "union all " 
											+ "select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee , sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet_History with(NOLOCK) " 
											+ "where  System_Id=? and Printed='Y' and Printed_Date between  dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place "
											+ ") sm group by Taluk,From_Place order by Taluk ");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, startDate);
				pstmt.setString(6, endDate);
				rs = pstmt.executeQuery();
				dataSet = new DefaultCategoryDataset();
				while (rs.next()) {
					count++;
					
					String str = rs.getString("Counts");
					int ts = Integer.parseInt(str);
					String FromPlace = rs.getString("From_Place");
					dataSet.setValue(ts, "Quantity", FromPlace);
				
					chart = ChartFactory.createBarChart("Total Quantity Chart",  "","", dataSet,
							PlotOrientation.VERTICAL, false, true, false);
					CategoryPlot plot = chart.getCategoryPlot();
			        CategoryAxis axis = plot.getDomainAxis();//ports
			        java.awt.Font font = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 7);
			        axis.setTickLabelFont(font);
			        axis.setCategoryLabelPositions(CategoryLabelPositions.UP_45);

			        CategoryPlot p = chart.getCategoryPlot(); 
			        ValueAxis axis2 = p.getRangeAxis();//quantity
			        java.awt.Font font2 = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 7);
			        axis2.setTickLabelFont(font2);
			        
			        BarRenderer renderer = (BarRenderer) p.getRenderer();
			        renderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
			        renderer.setBaseItemLabelsVisible(true);
			        renderer.setSeriesItemLabelFont(0, new java.awt.Font("Times New Roman",Font.NORMAL,8));
			        renderer.setBasePositiveItemLabelPosition(new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BASELINE_CENTER));
			      
			        LegendTitle legend = new LegendTitle(plot.getRenderer());
			        java.awt.Font font3 = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 15);
			        legend.setItemFont(font3); 
			        legend.setPosition(RectangleEdge.BOTTOM); 
			        chart.addLegend(legend); 

				}	
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return chart;
		}

		//************************MDP Revenue *****************************************************
		private JFreeChart getMdpRevenue() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			DefaultCategoryDataset dataSet = null;
			JFreeChart chart = null;
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select sum(Counts) as Counts,sum(TotalFee) as TotalFees,sum(Total) as TotalQuantity,Taluk,From_Place from "
						+ " (select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet with(NOLOCK) "
						+ " where  System_Id=? and Printed='Y' and Printed_Date between  dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place "
						+ "union all " 
						+ "select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee , sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet_History with(NOLOCK) " 
						+ "where  System_Id=?  and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place "
						+ ") sm group by Taluk,From_Place order by Taluk ");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, startDate);
				pstmt.setString(6, endDate);
				rs = pstmt.executeQuery();
				dataSet = new DefaultCategoryDataset();
				while (rs.next()) {
					count++;
					
					String str = rs.getString("Counts");
					
					Double Revenue = rs.getDouble("TotalFees")/100000.00;
					
					String FromPlace = rs.getString("From_Place");
					
					int ts = Integer.parseInt(str);
				
					dataSet.addValue(ts,  "TOTAL MDPs generated", FromPlace);//(ts,, );
					dataSet.addValue(Revenue,  "AMOUNT COLLECTED(Rs in Lakhs)", FromPlace);//(ts,, );
				
					chart = ChartFactory.createBarChart("MDPs Vs Revenue",  "","", dataSet,
							PlotOrientation.VERTICAL, false, true, false);
					
					GroupedStackedBarRenderer renderer = new GroupedStackedBarRenderer();
			        renderer.setItemMargin(0.0);
			        Plot plot2 = chart.getPlot();
			        renderer.setItemMargin(0.0);
			        
			        renderer.setSeriesPaint(0, Color.blue);
			       // renderer.setSeriesPaint(1, Color.green);
		            renderer.setGradientPaintTransformer(
		                    new StandardGradientPaintTransformer(GradientPaintTransformType.HORIZONTAL)
		                ); 
			        KeyToGroupMap map = new KeyToGroupMap("G1");
			        map.mapKeyToGroup("TOTAL MDPs generated", "G1");
			        map.mapKeyToGroup("AMOUNT COLLECTED(Rs in Lakhs)", "G2");
			        renderer.setSeriesToGroupMap(map);
			        
			        BarRenderer barRenderer = (BarRenderer)((CategoryPlot) plot2).getRenderer();
			        barRenderer.setSeriesPaint(0, Color.blue);
			        barRenderer.setSeriesPaint(1, Color.red);
			        barRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
			        barRenderer.setBaseItemLabelsVisible(true);
			        barRenderer.setSeriesItemLabelFont(0, new java.awt.Font("Times New Roman",Font.NORMAL,10));
			        barRenderer.setSeriesPositiveItemLabelPosition(0, new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BOTTOM_CENTER, TextAnchor.CENTER, -Math.PI/2));
			        barRenderer.setSeriesItemLabelFont(1, new java.awt.Font("Times New Roman",Font.NORMAL,10));
			        barRenderer.setSeriesPositiveItemLabelPosition(1, new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BOTTOM_CENTER, TextAnchor.CENTER, -Math.PI/2));
			        
			        SubCategoryAxis domainAxis = new SubCategoryAxis("Product / Month");
		            domainAxis.addSubCategory("TOTAL MDPs generated");
		            domainAxis.addSubCategory("AMOUNT COLLECTED(Rs in Lakhs)");
		            
		            CategoryPlot p = chart.getCategoryPlot();
		            BarRenderer renderer2 = (BarRenderer) p.getRenderer();
		            renderer2.setItemMargin(0.01);
		            
		            CategoryPlot plot = chart.getCategoryPlot();
		            NumberAxis axis = (NumberAxis)plot.getRangeAxis();
		            axis.setAutoRange(true);
		           // axis.setRange(0, 500);
		            java.awt.Font font = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 7);
			        axis.setTickLabelFont(font);
		        
					CategoryPlot plot1 = chart.getCategoryPlot();
			        CategoryAxis axis1 = plot1.getDomainAxis();//Revenue
			        axis1.setCategoryLabelPositions(CategoryLabelPositions.UP_45);
			       //axis5.setCategoryLabelPositions(CategoryLabelPositions.createUpRotationLabelPositions(Math.PI / 8.0));
			        java.awt.Font font2 = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 7);
			        axis1.setTickLabelFont(font2);
			        
			        LegendTitle legend = new LegendTitle(plot.getRenderer());
			        java.awt.Font font3 = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 10);
			        legend.setItemFont(font3); 
			        legend.setPosition(RectangleEdge.BOTTOM); 
			        chart.addLegend(legend); 
				}	
						
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return chart;
		}

		//*******************************Performence Chart********************************************//
		private JFreeChart getPerformenceChart() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			DefaultCategoryDataset dataSet = null;
			JFreeChart chart = null;
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select sum(Counts) as Counts,PrevCount,sum(TotalFee) as TotalFees,sum(Total) as TotalQuantity,Taluk,From_Place from " +
						  					" (select count(TS_ID) as Counts,(count(TS_ID)/DAY(DATEADD(DD,-1,DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)))) as PrevCount,sum(Total_Fee) as TotalFee,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet with(NOLOCK) " +
					  						" where  System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place " +
					  						" union all  " +
					  						" select count(TS_ID) as Counts,(count(TS_ID)/DAY(DATEADD(DD,-1,DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)))) as PrevCount,sum(Total_Fee) as TotalFee , sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet_History with(NOLOCK) " +  
					  						" where  System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place ) sm group by Taluk,From_Place,PrevCount order by Taluk ");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, startDate);
				pstmt.setString(6, endDate);
				rs = pstmt.executeQuery();
				dataSet = new DefaultCategoryDataset();
				while (rs.next()) {
					count++;
					
					String str = rs.getString("Counts");
					
					Double PrevCount = rs.getDouble("PrevCount");
					
					String FromPlace = rs.getString("From_Place");
					
					int ts = Integer.parseInt(str);
					
					dataSet.addValue(ts,  "MDPs generated Today", FromPlace);//(ts,, );
					dataSet.addValue(PrevCount,  "Average Trip sheets generrated in previous Month", FromPlace);//(ts,, );
				
					chart = ChartFactory.createBarChart("MDPs generated Vs Average of Previous Month",  "","", dataSet,
							PlotOrientation.VERTICAL, false, true, false);
					
					GroupedStackedBarRenderer renderer = new GroupedStackedBarRenderer();
			        renderer.setItemMargin(0.0);
			        Plot plot2 = chart.getPlot();
			        renderer.setItemMargin(0.0);
			        
			        renderer.setSeriesPaint(0, Color.blue);
			       // renderer.setSeriesPaint(1, Color.green);
		            renderer.setGradientPaintTransformer(
		                    new StandardGradientPaintTransformer(GradientPaintTransformType.HORIZONTAL)
		                ); 
			        KeyToGroupMap map = new KeyToGroupMap("G1");
			        map.mapKeyToGroup("MDPs generated Today", "G1");
			        map.mapKeyToGroup("Average Trip sheets generrated in previous Month", "G2");
			        renderer.setSeriesToGroupMap(map);
			        
			        BarRenderer barRenderer = (BarRenderer)((CategoryPlot) plot2).getRenderer();
			        barRenderer.setSeriesPaint(0, Color.blue);
			        barRenderer.setSeriesPaint(1, Color.red);
			        barRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
			        barRenderer.setBaseItemLabelsVisible(true);
			        barRenderer.setSeriesItemLabelFont(0, new java.awt.Font("Times New Roman",Font.NORMAL,10));
			        barRenderer.setSeriesPositiveItemLabelPosition(0, new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BOTTOM_CENTER, TextAnchor.CENTER, -Math.PI/2));
			        barRenderer.setSeriesItemLabelFont(1, new java.awt.Font("Times New Roman",Font.NORMAL,10));
			        barRenderer.setSeriesPositiveItemLabelPosition(1, new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BOTTOM_CENTER, TextAnchor.CENTER, -Math.PI/2));
			        
			        SubCategoryAxis domainAxis = new SubCategoryAxis("Product / Month");
		            domainAxis.addSubCategory("MDPs generated Today");
		            domainAxis.addSubCategory("Average Trip sheets generrated in previous Month");
		            
		            CategoryPlot p = chart.getCategoryPlot();
		            BarRenderer renderer2 = (BarRenderer) p.getRenderer();
		            renderer2.setItemMargin(0.01);
		            
		            CategoryPlot plot = chart.getCategoryPlot();
		            NumberAxis axis = (NumberAxis)plot.getRangeAxis();
		            axis.setAutoRange(true);
		          //  axis.setRange(0, 500);
		            java.awt.Font font = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 7);
			        axis.setTickLabelFont(font);
		        
					CategoryPlot plot1 = chart.getCategoryPlot();
			        CategoryAxis axis1 = plot1.getDomainAxis();//Revenue
			        axis1.setCategoryLabelPositions(CategoryLabelPositions.UP_45);
			       //axis5.setCategoryLabelPositions(CategoryLabelPositions.createUpRotationLabelPositions(Math.PI / 8.0));
			        java.awt.Font font2 = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 7);
			        axis1.setTickLabelFont(font2);
			        
			        LegendTitle legend = new LegendTitle(plot.getRenderer());
			        java.awt.Font font3 = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 10);
			        legend.setItemFont(font3); 
			        legend.setPosition(RectangleEdge.BOTTOM); 
			        chart.addLegend(legend); 
				}	
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		
			return chart;
		}
		
		//***************************MDP's Quantity Vs Average MDP's Quantity in Previous Month***************************//
		private JFreeChart getAverageMDPQuantity() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			DefaultCategoryDataset dataSet = null;
			JFreeChart chart = null;
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select sum(Counts) as Counts,sum(TotalFee) as TotalFees,sum(Total) as TotalQuantity,(sum(Total)/DAY(DATEADD(DD,-1,DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)))) as PrevQty,Taluk,From_Place from "
						+ " (select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet with(NOLOCK) "
						+ " where  System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place "
						+ "union all " 
						+ "select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee , sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet_History with(NOLOCK) " 
						+ "where  System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place "
						+ ") sm group by Taluk,From_Place order by Taluk ");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, startDate);
				pstmt.setString(6, endDate);
				rs = pstmt.executeQuery();
				dataSet = new DefaultCategoryDataset();
				while (rs.next()) {
					count++;
					
					Double str = rs.getDouble("TotalQuantity");
					
					Double PrevQty = rs.getDouble("PrevQty");
					
					String FromPlace = rs.getString("From_Place");
					
					dataSet.setValue(str,  "MDP's Quantity", FromPlace);//(ts,, );
					dataSet.setValue(PrevQty,  "Average MDP's quantity in previous Month", FromPlace);//(ts,, );
				
					chart = ChartFactory.createBarChart("MDP's Quantity Vs Average MDP's Quantity in Previous Month",  "","", dataSet,
							PlotOrientation.VERTICAL, false, true, false);
					
					GroupedStackedBarRenderer renderer = new GroupedStackedBarRenderer();
			        renderer.setItemMargin(0.0);
			        Plot plot2 = chart.getPlot();
			        renderer.setItemMargin(0.0);
			        
			        renderer.setSeriesPaint(0, Color.blue);
			       // renderer.setSeriesPaint(1, Color.green);
		            renderer.setGradientPaintTransformer(
		                    new StandardGradientPaintTransformer(GradientPaintTransformType.HORIZONTAL)
		                ); 
			        KeyToGroupMap map = new KeyToGroupMap("G1");
			        map.mapKeyToGroup("MDP's Quantity", "G1");
			        map.mapKeyToGroup("Average MDP's Quantity in Previous Month", "G2");
			        renderer.setSeriesToGroupMap(map);
			        
			        BarRenderer barRenderer = (BarRenderer)((CategoryPlot) plot2).getRenderer();
			        barRenderer.setSeriesPaint(0, Color.blue);
			        barRenderer.setSeriesPaint(1, Color.red);
			        barRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
			        barRenderer.setBaseItemLabelsVisible(true);
			        barRenderer.setSeriesItemLabelFont(0, new java.awt.Font("Times New Roman",Font.NORMAL,10));
			        barRenderer.setSeriesPositiveItemLabelPosition(0, new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BOTTOM_CENTER, TextAnchor.CENTER, -Math.PI/2));
			        barRenderer.setSeriesItemLabelFont(1, new java.awt.Font("Times New Roman",Font.NORMAL,10));
			        barRenderer.setSeriesPositiveItemLabelPosition(1, new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BOTTOM_CENTER, TextAnchor.CENTER, -Math.PI/2));
			        
			        SubCategoryAxis domainAxis = new SubCategoryAxis("Product / Month");
		            domainAxis.addSubCategory("MDP's Quantity");
		            domainAxis.addSubCategory("Average MDP's quantity in previous Month");
		            
		            CategoryPlot p = chart.getCategoryPlot();
		            BarRenderer renderer2 = (BarRenderer) p.getRenderer();
		            renderer2.setItemMargin(0.01);
		            
		            CategoryPlot plot = chart.getCategoryPlot();
		            NumberAxis axis = (NumberAxis)plot.getRangeAxis();
		            axis.setAutoRange(true);
		          //  axis.setRange(0, 500);
		            java.awt.Font font = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 7);
			        axis.setTickLabelFont(font);
		        
					CategoryPlot plot1 = chart.getCategoryPlot();
			        CategoryAxis axis1 = plot1.getDomainAxis();//Revenue
			        axis1.setCategoryLabelPositions(CategoryLabelPositions.UP_45);
			       //axis5.setCategoryLabelPositions(CategoryLabelPositions.createUpRotationLabelPositions(Math.PI / 8.0));
			        java.awt.Font font2 = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 7);
			        axis1.setTickLabelFont(font2);
			        
			        LegendTitle legend = new LegendTitle(plot.getRenderer());
			        java.awt.Font font3 = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 10);
			        legend.setItemFont(font3); 
			        legend.setPosition(RectangleEdge.BOTTOM); 
			        chart.addLegend(legend); 
				}	
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
			return chart;
		}
		
		//***************************MDP's Revenue Vs Average MDP's Revenue in Previous Month***************************//
		private <HorizontalCategoryAxis> JFreeChart getAverageMDPRevenue() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			DefaultCategoryDataset dataSet = null;
			JFreeChart chart = null;
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select sum(Counts) as Counts,sum(TotalFee) as TotalFees,(sum(TotalFee)/DAY(DATEADD(DD,-1,DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)))) as PrevFee,sum(Total) as TotalQuantity,Taluk,From_Place from "
						+ " (select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet with(NOLOCK) "
						+ " where  System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place "
						+ "union all " 
						+ "select count(TS_ID) as Counts,sum(Total_Fee) as TotalFee , sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Total,Taluk,From_Place from Sand_Mining_Trip_Sheet_History with(NOLOCK) " 
						+ "where  System_Id=? and Printed='Y' and Printed_Date between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) group by Taluk,From_Place "
						+ ") sm group by Taluk,From_Place order by Taluk ");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, startDate);
				pstmt.setString(6, endDate);
				rs = pstmt.executeQuery();
				dataSet = new DefaultCategoryDataset();
				while (rs.next()) {
					count++;
					
					Double str = rs.getDouble("TotalFees")/100000.00;
					//String str="municipality";
					Double PrevFee = rs.getDouble("PrevFee");
					
					String FromPlace = rs.getString("From_Place");
				    
					dataSet.setValue(str,"MDP's Revenue",FromPlace);//(ts,, );
					dataSet.setValue(PrevFee,  "Average MDP's Revenue in previous Month (Rs in Lakhs )", FromPlace);
				
					chart = ChartFactory.createBarChart("MDP's Revenue Vs Average MDP's Revenue in Previous Month",  "","", dataSet,
							PlotOrientation.VERTICAL, false, true, false);
					
					GroupedStackedBarRenderer renderer = new GroupedStackedBarRenderer();
			        renderer.setItemMargin(0.0);
			        Plot plot2 = chart.getPlot();
			        renderer.setItemMargin(0.0);
			        
			        renderer.setSeriesPaint(0, Color.blue);
			       // renderer.setSeriesPaint(1, Color.green);
		            renderer.setGradientPaintTransformer(
		                    new StandardGradientPaintTransformer(GradientPaintTransformType.HORIZONTAL)
		                ); 
			        KeyToGroupMap map = new KeyToGroupMap("G1");
			        map.mapKeyToGroup("MDP's Quantity", "G1");
			        map.mapKeyToGroup("Average MDP's quantity in previous Month", "G2");
			        renderer.setSeriesToGroupMap(map);
			        
			        BarRenderer barRenderer = (BarRenderer)((CategoryPlot) plot2).getRenderer();
			        barRenderer.setSeriesPaint(0, Color.blue);
			        barRenderer.setSeriesPaint(1, Color.red);
			        barRenderer.setBaseItemLabelGenerator(new StandardCategoryItemLabelGenerator());
			        barRenderer.setBaseItemLabelsVisible(true);
			        barRenderer.setSeriesItemLabelFont(0, new java.awt.Font("Times New Roman",Font.NORMAL,10));
			        barRenderer.setSeriesPositiveItemLabelPosition(0, new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BOTTOM_CENTER, TextAnchor.CENTER, -Math.PI/2));
			        barRenderer.setSeriesItemLabelFont(1, new java.awt.Font("Times New Roman",Font.NORMAL,10));
			        barRenderer.setSeriesPositiveItemLabelPosition(1, new ItemLabelPosition(ItemLabelAnchor.OUTSIDE12, TextAnchor.BOTTOM_CENTER, TextAnchor.CENTER, -Math.PI/2));
			        
			        SubCategoryAxis domainAxis = new SubCategoryAxis("Product / Month");
		            domainAxis.addSubCategory("MDP's Quantity");
		            domainAxis.addSubCategory("Average MDP's quantity in previous Month");
		            
		            CategoryPlot p = chart.getCategoryPlot();
		            BarRenderer renderer2 = (BarRenderer) p.getRenderer();
		            renderer2.setItemMargin(0.01);
		            
		            CategoryPlot plot = chart.getCategoryPlot();
		            NumberAxis axis = (NumberAxis)plot.getRangeAxis();
		            axis.setAutoRange(true);
		            //axis.setRange(0, 750);
		            java.awt.Font font = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 7);
			        axis.setTickLabelFont(font);
		        
					CategoryPlot plot1 = chart.getCategoryPlot();
			        CategoryAxis axis1 = plot1.getDomainAxis();//Revenue
			        axis1.setCategoryLabelPositions(CategoryLabelPositions.UP_45);
			       //axis5.setCategoryLabelPositions(CategoryLabelPositions.createUpRotationLabelPositions(Math.PI / 8.0));
			        java.awt.Font font2 = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 7);
			        axis1.setTickLabelFont(font2);
			        
			        LegendTitle legend = new LegendTitle(plot.getRenderer());
			        java.awt.Font font3 = new java.awt.Font("Dialog", Font.TIMES_ROMAN, 10);
			        legend.setItemFont(font3); 
			        legend.setPosition(RectangleEdge.BOTTOM); 
			        chart.addLegend(legend); 
				}	
				
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}
		
			return chart;
		}
		
		//*******************************total count******************************//
		private ArrayList<String> totalcount() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<String> informationList = new ArrayList<String>();
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select sum(tsNo) as TS_No,sum(Quantity) as Quantity , sum(revenue) as Revenue from ( " + 
											" (select count(Trip_Sheet_No) as tsNo,isnull(sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))),0) as Quantity, " +
											"isnull (sum(Total_Fee),0)as revenue from Sand_Mining_Trip_Sheet with(NOLOCK) " +
											" where Printed='Y' and System_Id=? and Printed_Date between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) " +
											"union " +
											" select count(Trip_Sheet_No) as tsNo,sum (cast(Left(SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000), PatIndex('%[^0-9.-]%', SubString(Quantity, PatIndex('%[0-9.-]%', Quantity), 8000) + 'X')-1) AS decimal (18,2))) as Quantity, " +
											"isnull(sum(Total_Fee),0)as revenue  from Sand_Mining_Trip_Sheet_History with(NOLOCK) " +
											"where Printed='Y' and System_Id=? and Printed_Date between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)))) tbl");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				pstmt.setInt(4, systemId);
				pstmt.setString(5, startDate);
				pstmt.setString(6, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					informationList.add( rs.getString("TS_No"));
					informationList.add( rs.getString("Quantity"));
					informationList.add( rs.getString("Revenue"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return informationList;
		}
		//**********************************nogps*************************************//
		private ArrayList<String> getNoGps() {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			int comm=0;
			int nonComm=0;
			ArrayList<String> informationList = new ArrayList<String>();
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select SUM(CASE WHEN LOCATION ='No GPS Device Connected' THEN 1 ELSE 0 END) AS NOGPS," +
											 "SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) < 6 and LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END)AS COMM, " +
											 "SUM(CASE WHEN DATEDIFF(hh,GMT,getutcdate()) >=6  and LOCATION !='No GPS Device Connected' THEN 1 ELSE 0 END)AS NONCOMM  " +
											 " from AMS.dbo.gpsdata_history_latest with(NOLOCK) where System_id=? and CLIENTID IN (select CUSTOMER_ID from ADMINISTRATOR.dbo.CUSTOMER_PROCESS_ASSOC where SYSTEM_ID=? and PROCESS_ID=29)");
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, systemId);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					informationList.add( rs.getString("NOGPS"));
					comm=Integer.parseInt(rs.getString("COMM"));
					informationList.add(String.valueOf(comm));
					nonComm=Integer.parseInt(rs.getString("NONCOMM"));
					informationList.add(String.valueOf(nonComm));
					informationList.add(String.valueOf(comm+nonComm));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return informationList;
		}
		//*************************************vehicle registered*********************************//
		
		private ArrayList<String> getVehicleRegistered() {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<String> informationList = new ArrayList<String>();
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(" select count(RegistrationNo) as count from dbo.VehicleRegistration where SystemId=? and RegistrationDateTime between dateadd(mi,-330,?) and ?");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					informationList.add( rs.getString("count"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return informationList;
		}
	//*************************************vehicle Unregistered*********************************//
		
		private ArrayList<String> getVehicleUnRegistered() {
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<String> informationList = new ArrayList<String>();
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(" select count(RegistrationNo) as count from dbo.VehicleRegistration where SystemId=? and CancellationDateTime between dateadd(mi,-330,?) and ?");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					informationList.add( rs.getString("count"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return informationList;
		}
		//**********************************unauthorized port*************************************//
		private ArrayList<String> getUnAuthPort() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<String> informationList = new ArrayList<String>();
			try {
				int count=0;
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select count(*)ASSET_NUMBER from dbo.UNAUTHORIZED_PORT_ENTRY with(NOLOCK)" +
						 					" where SYSTEM_ID=? and  ARRIVAL_TIME between dateadd(mi,-330,?) and dateadd(day,1,dateadd(mi,-330,?)) ");
				pstmt.setInt(1, systemId);
				pstmt.setString(2, startDate);
				pstmt.setString(3, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					count++;
					informationList.add( rs.getString("ASSET_NUMBER"));
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return informationList;
		}
		//**********************************crossed border*************************************//
		private ArrayList<String> getborderCrossed() {
			 
			Connection con = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			ArrayList<String> informationList = new ArrayList<String>();
			try {
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement("select a.TYPE_OF_ALERT,count(a.REGISTRATION_NO) as COUNT from Alert a with(NOLOCK)  " +
						 					 " where a.SYSTEM_ID=? and a.TYPE_OF_ALERT in (7,84) and  " +													
						 					 " a.GMT >= dateadd(mi,-330,DATEADD(day, DATEDIFF(day, 0, getdate()), 0)) " +
						 					 " and (MONITOR_STATUS is null or MONITOR_STATUS='N')group by a.TYPE_OF_ALERT");
				pstmt.setInt(1, systemId);
				rs = pstmt.executeQuery();
				while(rs.next()) {
					informationList.add(rs.getString("COUNT"));
				}
				if(!rs.next()){
					informationList.add("0");
					informationList.add("0");
				//	informationList.add("0");
					
					
				}
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				DBConnection.releaseConnectionToDB(con, pstmt, rs);
			}

			return informationList;
		}
		
		//*******************************District Name****************
		private String getDistrictName() {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String District="";
		try {
		con = DBConnection.getConnectionToDB("AMS");
		pstmt = con.prepareStatement("select top 1 Port_District,isnull(d.DISTRICT_NAME,'') as DISTRICT_NAME  from Sand_Port_Details a with(NOLOCK) inner join DISTRICT_MASTER d on d.DISTRICT_ID=a.Port_District where System_Id=? and Port_District is not null");
		pstmt.setInt(1, systemId);

		rs = pstmt.executeQuery();
		while (rs.next()) {
		District = rs.getString("DISTRICT_NAME");
		}
		} catch (Exception e) {
		e.printStackTrace();
		} finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}

		return District;
		}
}
