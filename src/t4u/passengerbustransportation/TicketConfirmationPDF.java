package t4u.passengerbustransportation;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.PassengerBusTransportationStatements;


import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Image;
import com.lowagie.text.List;
import com.lowagie.text.ListItem;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;

import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class TicketConfirmationPDF extends HttpServlet {

	
	BaseFont baseFont = null;
	Font FONT5 = FontFactory.getFont(FontFactory.TIMES_ROMAN, 5);
		
		protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
							
			String clientId = "";
			String systemId = "";
			String transaction = "";
			
			try
				{   					
			        clientId = request.getParameter("clientId");
					systemId= request.getParameter("systemId");
					transaction = request.getParameter("transaction");
					
					ServletOutputStream servletOutputStream = response.getOutputStream();
					Properties p=ApplicationListener.prop;
					String crystalReport=p.getProperty("crystalReport");
					String pdfpath= crystalReport; //"C:\\Reports\\CrystalReports\\";
					refreshdir(pdfpath);
					String formno="TicketConfirmation_"+transaction;
					String verdanaFontPath=p.getProperty("verdanaFontPath");
					String fontPath = verdanaFontPath;//"C:\\verdana.ttf";
					baseFont = BaseFont.createFont(fontPath, BaseFont.CP1250, BaseFont.NOT_EMBEDDED);					 
					String pdf = pdfpath+formno+".pdf";
				
					getTicketInformation(pdf,request,transaction,Integer.parseInt(clientId),Integer.parseInt(systemId));					
					printPdf(servletOutputStream,response,pdf,formno);//same for all								
				}
				catch (Exception e) 
				{
					e.printStackTrace();
				}
			}

				

	     public void generatePdfForSingleTrip(String pdf,String weekday,String passangerNames,String totalSeats,String vehicelModel,String reportingtime,String transaction, String name, String destination,String ticketNo,String seatNO, String phoneNo,String emailId,String journeyDate, String departureTime,String seatingStructure,String source,int grandtotal,String boardingOn,String terminalname,int customerID,int systemID) {										 
					try
					{			
						FileOutputStream fileOut = new FileOutputStream(pdf);
						Document document = new Document(PageSize.A4.rotate(), 80, 80, 15, 15);
						PdfWriter writer = PdfWriter.getInstance(document,fileOut);
						document.open();
						
					        PdfPTable headerTableTitle = createPdfHead(customerID,systemID); 
					        PdfPTable emptyline = createPdfemptyline();
					        PdfPTable breakline = createPdfBreakLine();
					    	PdfPTable details1 = createDetails1(source,destination,weekday,journeyDate,ticketNo);
					    	PdfPTable details2 = createDetails2(transaction);
					    	PdfPTable details3 = createDetails3();
					    	PdfPTable details4 = createDetails4(vehicelModel,seatingStructure,reportingtime,departureTime,totalSeats);
					    	PdfPTable details5 = createDetails5();
					    	PdfPTable details6 = createDetails6(passangerNames,seatNO,terminalname,phoneNo,emailId);
					    	PdfPTable details7 = createDetails7(grandtotal);
					        
					    	Paragraph paragraph = new Paragraph("Ticket cancellation Policies",new Font(baseFont,(float) 8, Font.NORMAL));
							paragraph.setAlignment(Element.ALIGN_JUSTIFIED);
						         List list = new List(false, 10);
								 list.setListSymbol(new Chunk("\u2022", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD)));
								 ListItem listItem = new ListItem("", new Font(baseFont,(float) 8, Font.NORMAL));
								 list.add(listItem);
								 listItem = new ListItem(new Chunk("Within 24hrs from the station departure time:40% deduction.\n", new Font(baseFont,(float) 8, Font.NORMAL)));
								 list.add(listItem);
								 listItem = new ListItem(new Chunk("Between 1 to 3 days before station departure time:30% deduction.\n", new Font(baseFont,(float) 8, Font.NORMAL)));
								 list.add(listItem);
								 listItem = new ListItem(new Chunk("Between 3 to 7 days before station departure time:20% deduction.\n", new Font(baseFont,(float) 8, Font.NORMAL)));
								 list.add(listItem);
								 listItem = new ListItem(new Chunk("Between 7 to 30 days before station departure time:10% deduction.\n", new Font(baseFont,(float) 8, Font.NORMAL)));
								 list.add(listItem);	    		      
						         paragraph.add(list);
					    	
						    document.add(headerTableTitle);						
							document.add(emptyline); 
							document.add(breakline);							
							document.add(emptyline);							
							document.add(details1);
							document.add(details2);
							document.add(emptyline); 
							document.add(breakline);							
							document.add(emptyline);
							document.add(details3);
							document.add(details4);
							document.add(emptyline); 
							document.add(breakline);							
							document.add(emptyline);
							document.add(details5);
							document.add(details6);
							document.add(emptyline); 
							document.add(breakline);							
							document.add(emptyline);
							document.add(details7);
							document.add(emptyline); 
							document.add(breakline);							
							document.add(emptyline); 							
						    document.add(paragraph); 
						    
				            document.close();
						
						}
					catch (Exception e) 
					{
						e.printStackTrace();
					}
				}
		
		
		private PdfPTable createPdfHead(int customerID,int systemID)
		{

			float[] widths = {20,50,50}; 
			PdfPTable t = new PdfPTable(3);
			try
			{
				t.setWidthPercentage(100); 
				t.setWidths(widths);
							
				String path = System.getProperty("catalina.base")+"//webapps//ApplicationImages//CustomerLogos//custlogo_"+systemID+"_"+customerID+".gif" ;
				Image img1 = Image.getInstance(path);
				PdfPCell cell = new PdfPCell();
				cell.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				cell.setBorder(Rectangle.NO_BORDER);
				cell.addElement(img1);
				t.addCell(cell);
				
				Phrase myPhrase=new Phrase("eTICKET",new Font(baseFont, 14));
				PdfPCell c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBackgroundColor(Color.WHITE);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(1);
				t.addCell(c);
				
				Phrase phrase2 = new Phrase("Need help with your trip?\n\n"+"01-4531091/08170765674\n"+"info@ysgtransport.com \n customercare@ysgtransport.com");
				PdfPCell cell2 = new PdfPCell(phrase2);
				cell2.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				cell2.setBorder(Rectangle.NO_BORDER);
				t.addCell(cell2);
				

			}
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			return t;

		}
		
		private PdfPTable createPdfBreakLine()
		{
			float[] widths = {80};
			PdfPTable t = new PdfPTable(1);
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				PdfPCell c = new PdfPCell();			
				c.setBorder(1);
				c.setBorderColor(Color.gray);
				c.setHorizontalAlignment(Element.ALIGN_LEFT);
				c.setVerticalAlignment(Element.ALIGN_CENTER);
				t.addCell(c);
							
			}
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			return t;	
		}
		
		private PdfPTable createPdfemptyline()
		{
			float[] widths = {80};
			PdfPTable t = new PdfPTable(1);
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrase1=new Phrase("\n");
				PdfPCell c = new PdfPCell(myPhrase1);
				c.setBackgroundColor(Color.white);
				c.setBorder(Rectangle.NO_BORDER);
				t.addCell(c);
							
			}
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			return t;	
		}
		
		
	
		
		private PdfPTable createDetails1(String source,String destination,String weekday,String journeyDate,String ticketNo){
		
			float[] widths = {300,150,150,250};
			PdfPTable t = new PdfPTable(4);		
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrased=new Phrase(source+" TO "+destination,new Font(baseFont,(float) 12, Font.BOLD));
				PdfPCell cd = new PdfPCell(myPhrased);
				cd.setBackgroundColor(Color.white);
				cd.setBorder(Rectangle.NO_BORDER);
				cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(cd);
				
				Phrase myPhrase=new Phrase(weekday,new Font(baseFont,(float) 12, Font.BOLD));
				PdfPCell c1 = new PdfPCell(myPhrase);
				c1.setBackgroundColor(Color.white);
				c1.setBorder(Rectangle.NO_BORDER);
				c1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(c1);
								
				Phrase myPhrase2=new Phrase(journeyDate,new Font(baseFont,(float) 12, Font.BOLD));
				PdfPCell c2 = new PdfPCell(myPhrase2);
				c2.setBackgroundColor(Color.white);
				c2.setBorder(Rectangle.NO_BORDER);
				c2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(c2);
				
				Phrase myPhrase3=new Phrase("Ticket No: "+ticketNo+"\n",new Font(baseFont,(float) 10, Font.BOLD));
				PdfPCell c3 = new PdfPCell(myPhrase3);
				c3.setBackgroundColor(Color.white);
				c3.setBorder(Rectangle.NO_BORDER);
				c3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				t.addCell(c3);
			
			}
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			return t;	
		}	
				
		private PdfPTable createDetails2(String transaction){
			
			float[] widths = {300,150,150,250};
			PdfPTable t = new PdfPTable(4);		
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrased=new Phrase("");
				PdfPCell cd = new PdfPCell(myPhrased);
				cd.setBackgroundColor(Color.white);
				cd.setBorder(Rectangle.NO_BORDER);
				cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(cd);
				
				Phrase myPhrase=new Phrase("");
				PdfPCell c1 = new PdfPCell(myPhrase);
				c1.setBackgroundColor(Color.white);
				c1.setBorder(Rectangle.NO_BORDER);
				c1.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c1);
				
				
				Phrase myPhrase2=new Phrase("");
				PdfPCell c2 = new PdfPCell(myPhrase2);
				c2.setBackgroundColor(Color.white);
				c2.setBorder(Rectangle.NO_BORDER);
				c2.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c2);
				
				Phrase myPhrase3=new Phrase("Transaction No:\n"+transaction+"\n");
				PdfPCell c3 = new PdfPCell(myPhrase3);
				c3.setBackgroundColor(Color.white);
				c3.setBorder(Rectangle.NO_BORDER);
				c3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				t.addCell(c3);
			
			}
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			return t;	
		}	
private PdfPTable createDetails3(){
			
			float[] widths = {300,150,150,250};
			PdfPTable t = new PdfPTable(4);		
			try
			{
				t.setWidthPercentage(100);
				t.setWidths(widths);
				
				Phrase myPhrased=new Phrase("Vehicle Model:");
				PdfPCell cd = new PdfPCell(myPhrased);
				cd.setBackgroundColor(Color.white);
				cd.setBorder(Rectangle.NO_BORDER);
				cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(cd);
				
				Phrase myPhrased1=new Phrase("Reporting Time:");
				PdfPCell cd1 = new PdfPCell(myPhrased1);
				cd1.setBackgroundColor(Color.white);
				cd1.setBorder(Rectangle.NO_BORDER);
				cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(cd1);
				
				Phrase myPhrased2=new Phrase("Departure Time");
				PdfPCell cd2 = new PdfPCell(myPhrased2);
				cd2.setBackgroundColor(Color.white);
				cd2.setBorder(Rectangle.NO_BORDER);
				cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(cd2);
				
				Phrase myPhrased3=new Phrase("No. Of Seats Booked");
				PdfPCell cd3 = new PdfPCell(myPhrased3);
				cd3.setBackgroundColor(Color.white);
				cd3.setBorder(Rectangle.NO_BORDER);
				cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				t.addCell(cd3);
			
			}
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			return t;	
		}	
		
private PdfPTable createDetails4(String vehicelModel,String seatingStructure,String reportingtime,String departureTime, String seatNO){
	
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase(vehicelModel+"-"+seatingStructure,new Font(baseFont,(float) 10, Font.BOLD));
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrased1=new Phrase(reportingtime,new Font(baseFont,(float) 10, Font.BOLD));
		PdfPCell cd1 = new PdfPCell(myPhrased1);
		cd1.setBackgroundColor(Color.white);
		cd1.setBorder(Rectangle.NO_BORDER);
		cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd1);
		
		Phrase myPhrased2=new Phrase(departureTime,new Font(baseFont,(float) 10, Font.BOLD));
		PdfPCell cd2 = new PdfPCell(myPhrased2);
		cd2.setBackgroundColor(Color.white);
		cd2.setBorder(Rectangle.NO_BORDER);
		cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd2);
		
		Phrase myPhrased3=new Phrase(seatNO+"\n",new Font(baseFont,(float) 10, Font.BOLD));
		PdfPCell cd3 = new PdfPCell(myPhrased3);
		cd3.setBackgroundColor(Color.white);
		cd3.setBorder(Rectangle.NO_BORDER);
		cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(cd3);
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return t;	
}	

private PdfPTable createDetails5(){
	
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase("Passenger Details:");
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrased1=new Phrase("Booked Seats:");
		PdfPCell cd1 = new PdfPCell(myPhrased1);
		cd1.setBackgroundColor(Color.white);
		cd1.setBorder(Rectangle.NO_BORDER);
		cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd1);
		
		Phrase myPhrased2=new Phrase("Terminal Name:");
		PdfPCell cd2 = new PdfPCell(myPhrased2);
		cd2.setBackgroundColor(Color.white);
		cd2.setBorder(Rectangle.NO_BORDER);
		cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd2);
		
		Phrase myPhrased3=new Phrase("Contact Details:");
		PdfPCell cd3 = new PdfPCell(myPhrased3);
		cd3.setBackgroundColor(Color.white);
		cd3.setBorder(Rectangle.NO_BORDER);
		cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(cd3);
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return t;	
}	
private PdfPTable createDetails6(String passangerNames,String seatNO,String terminalname,String phoneNo,String emailId){
	
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase(passangerNames,new Font(baseFont,(float) 10, Font.BOLD));
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrased1=new Phrase(seatNO,new Font(baseFont,(float) 10, Font.BOLD));
		PdfPCell cd1 = new PdfPCell(myPhrased1);
		cd1.setBackgroundColor(Color.white);
		cd1.setBorder(Rectangle.NO_BORDER);
		cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd1);
		
		Phrase myPhrased2=new Phrase(terminalname,new Font(baseFont,(float) 10, Font.BOLD));
		PdfPCell cd2 = new PdfPCell(myPhrased2);
		cd2.setBackgroundColor(Color.white);
		cd2.setBorder(Rectangle.NO_BORDER);
		cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd2);
		
		Phrase myPhrased3=new Phrase("Phone: "+phoneNo+"\n EmailId: "+emailId+"\n");
		PdfPCell cd3 = new PdfPCell(myPhrased3);
		cd3.setBackgroundColor(Color.white);
		cd3.setBorder(Rectangle.NO_BORDER);
		cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(cd3);
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return t;	
}	

private PdfPTable createDetails7(int grandtot){
	
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase("Total Fare: NGN "+grandtot,new Font(baseFont,(float) 12, Font.BOLD));
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrased1=new Phrase("");
		PdfPCell cd1 = new PdfPCell(myPhrased1);
		cd1.setBackgroundColor(Color.white);
		cd1.setBorder(Rectangle.NO_BORDER);
		cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd1);
		
		Phrase myPhrased2=new Phrase("");
		PdfPCell cd2 = new PdfPCell(myPhrased2);
		cd2.setBackgroundColor(Color.white);
		cd2.setBorder(Rectangle.NO_BORDER);
		cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd2);
		
		Phrase myPhrased3=new Phrase("");
		PdfPCell cd3 = new PdfPCell(myPhrased3);
		cd3.setBackgroundColor(Color.white);
		cd3.setBorder(Rectangle.NO_BORDER);
		cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(cd3);
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return t;	
}	

	

public void generatePdfForRoudTrip(String pdf,String weekday1,String weekday2,String passangerNames,String totalSeats,String vehiclemodel1,String vehiclemodel2,String reportingtime1,String reportingtime2,String name,String phoneNo,String emailId,String Ticketno,String seatNo1,String seatNo2,String journeyDate1,String departureTime1, String seatingStructure1,String source1,int grandtot1,String boardingOn1,String destination1,String terminalname1,String journeyDate2,String departureTime2,String seatingStructure2,String source2,int grandtot2,String boardingOn2,String destination2,String terminalname2, String transaction,int customerID,int systemID){
	
	try
	{			
		FileOutputStream fileOut = new FileOutputStream(pdf);
		Document document = new Document(PageSize.A4.rotate(), 80, 80, 5, 5);
		PdfWriter writer = PdfWriter.getInstance(document,fileOut);
		document.open();
		String journeyType = "Onward Journey:";
		int tot = grandtot1+grandtot2;
	        PdfPTable headerTableTitle = createPdfHead(customerID,systemID); 
	        PdfPTable emptyline = createPdfemptyline();
	        PdfPTable breakline = createPdfBreakLine();
	        PdfPTable detailsOnward = createDetailsForRoundTrip1(journeyType);
	    	PdfPTable details1 = createDetails1(source1,destination1,weekday1,journeyDate1,Ticketno);
	    	PdfPTable details2 = createDetails2(transaction);
	    	PdfPTable details3 = createDetails3();
	    	PdfPTable details4 = createDetails4(vehiclemodel1,seatingStructure1,reportingtime1,departureTime1,totalSeats);
	    	PdfPTable details5 = createDetailsForRoundTrip5();
	    	PdfPTable details6 = createDetailsForRoundTrip6(seatNo1,terminalname1);
	    	journeyType = "Return Journey:";
	    	PdfPTable detailsReturn = createDetailsForRoundTrip1(journeyType);
	    	PdfPTable retundetails = createDetailsForReturnJourney(source2,destination2,weekday2,journeyDate2);
	    	PdfPTable detailsRoundTrip3 = createDetails3();
	    	PdfPTable detailsForRoundTrip4 = createDetails4(vehiclemodel2,seatingStructure2,reportingtime2,departureTime2,totalSeats);
	    	PdfPTable detailsForRoundTrip5 = createDetailsForRoundTrip5();
	    	PdfPTable detailsForRoundTrip6 = createDetailsForRoundTrip6(seatNo2,terminalname2);
	    	PdfPTable passengerDetails = passengerDetailsForRoundTrip(emailId,passangerNames,phoneNo);
	    	
	    	PdfPTable details7 = createDetailsForRoundTrip7(grandtot1,grandtot2);
	    	PdfPTable details8 = createDetailsForRoundTrip8(tot);
	    		    	
	    	Paragraph paragraph = new Paragraph("Ticket cancellation Policies",new Font(baseFont,(float) 8, Font.NORMAL));
			paragraph.setAlignment(Element.ALIGN_JUSTIFIED);
		      List list = new List(false, 10);
				 list.setListSymbol(new Chunk("\u2022", FontFactory.getFont(FontFactory.HELVETICA, 10, Font.BOLD)));
				 ListItem listItem = new ListItem("", new Font(baseFont,(float) 8, Font.NORMAL));
				 list.add(listItem);
				 listItem = new ListItem(new Chunk("Within 24hrs from the station departure time:40% deduction.\n", new Font(baseFont,(float) 8, Font.NORMAL)));
				 list.add(listItem);
				 listItem = new ListItem(new Chunk("Between 1 to 3 days before station departure time:30% deduction.\n", new Font(baseFont,(float) 8, Font.NORMAL)));
				 list.add(listItem);
				 listItem = new ListItem(new Chunk("Between 3 to 7 days before station departure time:20% deduction.\n", new Font(baseFont,(float) 8, Font.NORMAL)));
				 list.add(listItem);
				 listItem = new ListItem(new Chunk("Between 7 to 30 days before station departure time:10% deduction.\n", new Font(baseFont,(float) 8, Font.NORMAL)));
				 list.add(listItem);	    		      
		         paragraph.add(list);
	    	
		    document.add(headerTableTitle);						
			document.add(emptyline); 
			document.add(breakline);										
			document.add(detailsOnward);
			document.add(details1);
			document.add(details2); 
			document.add(breakline);							
			document.add(details3);
			document.add(details4);
			document.add(emptyline); 
			document.add(breakline);							
			document.add(details5);
			document.add(details6);
			document.add(emptyline); 
			document.add(breakline);							
			document.add(emptyline);
			document.add(detailsReturn);
			document.add(retundetails);
			document.add(emptyline);
			document.add(breakline);	
			document.add(detailsRoundTrip3);
			document.add(detailsForRoundTrip4);
			document.add(emptyline); 
			document.add(breakline);							
			document.add(detailsForRoundTrip5);
			document.add(detailsForRoundTrip6);
			document.add(emptyline); 
			document.add(breakline);							
			document.add(passengerDetails);
			document.add(emptyline); 
			document.add(breakline);							
			document.add(details7);
			document.add(details8);
			document.add(breakline);										
		    document.add(paragraph); 
           
		    document.close();
		
		}
	catch (Exception e) 
	{
		e.printStackTrace();
	}

}
private PdfPTable createDetailsForReturnJourney(String source,String destination,String weekday,String journeyDate){
	
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase(source+" TO "+destination,new Font(baseFont,(float) 12, Font.BOLD));
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrase=new Phrase(weekday,new Font(baseFont,(float) 12, Font.BOLD));
		PdfPCell c1 = new PdfPCell(myPhrase);
		c1.setBackgroundColor(Color.white);
		c1.setBorder(Rectangle.NO_BORDER);
		c1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(c1);
						
		Phrase myPhrase2=new Phrase(journeyDate,new Font(baseFont,(float) 12, Font.BOLD));
		PdfPCell c2 = new PdfPCell(myPhrase2);
		c2.setBackgroundColor(Color.white);
		c2.setBorder(Rectangle.NO_BORDER);
		c2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(c2);
		
		Phrase myPhrase3=new Phrase("");
		PdfPCell c3 = new PdfPCell(myPhrase3);
		c3.setBackgroundColor(Color.white);
		c3.setBorder(Rectangle.NO_BORDER);
		c3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(c3);
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return t;	
}	
private PdfPTable createDetailsForRoundTrip6(String seatNo1, String terminalname1){
	
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase(terminalname1,new Font(baseFont,(float) 10, Font.BOLD));
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrased1=new Phrase("");
		PdfPCell cd1 = new PdfPCell(myPhrased1);
		cd1.setBackgroundColor(Color.white);
		cd1.setBorder(Rectangle.NO_BORDER);
		cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd1);
		
		Phrase myPhrased2=new Phrase("");
		PdfPCell cd2 = new PdfPCell(myPhrased2);
		cd2.setBackgroundColor(Color.white);
		cd2.setBorder(Rectangle.NO_BORDER);
		cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd2);
		
		Phrase myPhrased3=new Phrase(seatNo1+"\n",new Font(baseFont,(float) 10, Font.BOLD));
		PdfPCell cd3 = new PdfPCell(myPhrased3);
		cd3.setBackgroundColor(Color.white);
		cd3.setBorder(Rectangle.NO_BORDER);
		cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(cd3);
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return t;	
}	
private PdfPTable createDetailsForRoundTrip1(String journeyType){
	
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase(journeyType);
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrased1=new Phrase("");
		PdfPCell cd1 = new PdfPCell(myPhrased1);
		cd1.setBackgroundColor(Color.white);
		cd1.setBorder(Rectangle.NO_BORDER);
		cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd1);
		
		Phrase myPhrased2=new Phrase("");
		PdfPCell cd2 = new PdfPCell(myPhrased2);
		cd2.setBackgroundColor(Color.white);
		cd2.setBorder(Rectangle.NO_BORDER);
		cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd2);
		
		Phrase myPhrased3=new Phrase("");
		PdfPCell cd3 = new PdfPCell(myPhrased3);
		cd3.setBackgroundColor(Color.white);
		cd3.setBorder(Rectangle.NO_BORDER);
		cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(cd3);
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return t;	
}


private PdfPTable createDetailsForRoundTrip5(){
	
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase("Terminal Name:");
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrased1=new Phrase("");
		PdfPCell cd1 = new PdfPCell(myPhrased1);
		cd1.setBackgroundColor(Color.white);
		cd1.setBorder(Rectangle.NO_BORDER);
		cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd1);
		
		Phrase myPhrased2=new Phrase("");
		PdfPCell cd2 = new PdfPCell(myPhrased2);
		cd2.setBackgroundColor(Color.white);
		cd2.setBorder(Rectangle.NO_BORDER);
		cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd2);
		
		Phrase myPhrased3=new Phrase("Booked Seats:");
		PdfPCell cd3 = new PdfPCell(myPhrased3);
		cd3.setBackgroundColor(Color.white);
		cd3.setBorder(Rectangle.NO_BORDER);
		cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(cd3);
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return t;	
}	

private PdfPTable passengerDetailsForRoundTrip(String emailId,String passangerNames,String phoneNo){
	
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase("Passanger Details: ");
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrased1=new Phrase(passangerNames);
		PdfPCell cd1 = new PdfPCell(myPhrased1);
		cd1.setBackgroundColor(Color.white);
		cd1.setBorder(Rectangle.NO_BORDER);
		cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd1);
		
		Phrase myPhrased2=new Phrase("Contact Details: ");
		PdfPCell cd2 = new PdfPCell(myPhrased2);
		cd2.setBackgroundColor(Color.white);
		cd2.setBorder(Rectangle.NO_BORDER);
		cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd2);
		
		Phrase myPhrased3=new Phrase("Phone: "+phoneNo+"\n"+"Email: "+emailId+"\n");
		PdfPCell cd3 = new PdfPCell(myPhrased3);
		cd3.setBackgroundColor(Color.white);
		cd3.setBorder(Rectangle.NO_BORDER);
		cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(cd3);
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return t;	
}	

private PdfPTable createDetailsForRoundTrip7(int grandtot1,int grandtot2){
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase( "Onward Fare: NGN "+grandtot1+"\n"+"Return Fare: NGN "+grandtot2+"\n",new Font(baseFont,(float) 10, Font.NORMAL) );
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrased1=new Phrase("");
		PdfPCell cd1 = new PdfPCell(myPhrased1);
		cd1.setBackgroundColor(Color.white);
		cd1.setBorder(Rectangle.NO_BORDER);
		cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd1);
		
		Phrase myPhrased2=new Phrase("");
		PdfPCell cd2 = new PdfPCell(myPhrased2);
		cd2.setBackgroundColor(Color.white);
		cd2.setBorder(Rectangle.NO_BORDER);
		cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd2);
		
		Phrase myPhrased3=new Phrase("");
		PdfPCell cd3 = new PdfPCell(myPhrased3);
		cd3.setBackgroundColor(Color.white);
		cd3.setBorder(Rectangle.NO_BORDER);
		cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(cd3);
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	return t;	
}	

private PdfPTable createDetailsForRoundTrip8(int tot){
	
	float[] widths = {300,150,150,250};
	PdfPTable t = new PdfPTable(4);		
	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);
		
		Phrase myPhrased=new Phrase( "Total Fare: NGN "+tot, new Font(baseFont,(float) 12, Font.BOLD));
		PdfPCell cd = new PdfPCell(myPhrased);
		cd.setBackgroundColor(Color.white);
		cd.setBorder(Rectangle.NO_BORDER);
		cd.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd);
		
		Phrase myPhrased1=new Phrase("");
		PdfPCell cd1 = new PdfPCell(myPhrased1);
		cd1.setBackgroundColor(Color.white);
		cd1.setBorder(Rectangle.NO_BORDER);
		cd1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd1);
		
		Phrase myPhrased2=new Phrase("");
		PdfPCell cd2 = new PdfPCell(myPhrased2);
		cd2.setBackgroundColor(Color.white);
		cd2.setBorder(Rectangle.NO_BORDER);
		cd2.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
		t.addCell(cd2);
		
		Phrase myPhrased3=new Phrase("");
		PdfPCell cd3 = new PdfPCell(myPhrased3);
		cd3.setBackgroundColor(Color.white);
		cd3.setBorder(Rectangle.NO_BORDER);
		cd3.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
		t.addCell(cd3);
	
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
		/////////////////////////////////////////////// get mail notification function////////////////////////////////
		
		
		public void getTicketInformation(String pdf, HttpServletRequest request,String transaction,int customerID,int systemID)
		{
			 
			PreparedStatement pstmt = null;
			Connection con = null;		   
		    String phoneNo="";
		    String seatNO="";
		    String passangerNames = "";
		    String emailId="";
		    String name = "";
		    String name1 = "";
		    String ticketNo="";    
		    ResultSet rs = null;
		    String roundtrip = "";
		    int  count = 0;
		    try {
		    con = DBConnection.getConnectionToDB("AMS");
		    
		    pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TRANSACTION_TYPE);
		    pstmt.setString(1, transaction);
		    rs=pstmt.executeQuery();
			if(rs.next())
			{
				roundtrip=rs.getString("IS_ROUND_TRIP");	
			}
			if(roundtrip.equals("false")){
				String journeyDate="";
			    String departureTime="";
			    String seatingStructure="";
			    String source="";
			    double totalAmount=0.0;
			    int grandtotal=0;
			    String boardingOn="";
			    String destination="";
			    String terminalname="";
			    String vehicelModel = "";
			    String reportingtime = "";
			    String totalSeats = "";
			    String weekday = "";
			pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_MailDetails);
			pstmt.setString(1, transaction);	
			rs=pstmt.executeQuery();
				if(rs.next())
				{
					phoneNo=rs.getString("PHONE_NUMBER");
					emailId=rs.getString("EMAIL_ID");
					journeyDate=rs.getString("JOURNEY_DATE");
					departureTime=rs.getString("DEPARTURE_TIME");
					String departuretimeFormat = departureTime.substring(0,departureTime.indexOf(":"));
					departureTime = getTimeFormat(Integer.parseInt(departuretimeFormat),departureTime);
					seatingStructure=rs.getString("SEATING_STRUCTURE");
					source=rs.getString("SOURCE");
					totalAmount=rs.getDouble("TOTAL_AMOUNT");
					Long L = Math.round(totalAmount);
					grandtotal = Integer.valueOf(L.intValue());
					boardingOn=rs.getString("INSERTED_DATETIME");
					name1=rs.getString("PASSANGER_NAME");
					name=name1.toUpperCase();
					ticketNo=rs.getString("TICKET_NUMBER");
					destination=rs.getString("DESTINATION");
					terminalname=rs.getString("TERMINAL_NAME");
					vehicelModel = rs.getString("VEHICLE_MODEL");
					reportingtime = rs.getString("REPORTING_TIME");
					String departuretimeFormat1 = reportingtime.substring(0,reportingtime.indexOf(":"));
					reportingtime = getTimeFormat(Integer.parseInt(departuretimeFormat1),reportingtime);
					totalSeats = rs.getString("NUMBER_OF_SEATS");
					weekday = rs.getString("WEEKDAY");
				    }
				 pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_BOOKED_SEATS);
		    	 pstmt.setString(1, transaction);	
		    	 rs=pstmt.executeQuery();
				 while(rs.next()){	    		 
				 String seatNo = rs.getString("SEAT_NUMBER");
				 String passangerName = rs.getString("PASSANGER_NAME");
				 String mrMs = rs.getString("GENDER");
				 if(mrMs.equals("F")){
					 mrMs = "Mis/Mrs." ;
				 }else{
					 mrMs = "Mr." ;
				 }
				 passangerName = mrMs+passangerName.toUpperCase();
			     seatNO = seatNO+", "+seatNo;
			     passangerNames = passangerNames+", "+passangerName;
			     }
				 seatNO = seatNO.substring(1);
				 passangerNames = passangerNames.substring(1);
				 generatePdfForSingleTrip(pdf,weekday,passangerNames,totalSeats,vehicelModel,reportingtime,transaction,name,destination,ticketNo,seatNO,phoneNo,emailId,journeyDate,departureTime,seatingStructure,source,grandtotal,boardingOn,terminalname,customerID,systemID);
					
				
			}
			else if(roundtrip.equals("true")){
			    	   String journeyDate1="";
			    	   String departureTime1="";
		    	       String seatingStructure1="";
			    	   String source1="";
			    	   double totalAmount1=0.0;
			    	   int grandtot1 = 0;
			    	   double totalAmount2=0.0;
			    	   int grandtot2 = 0;
			    	   String boardingOn1="";
			    	   String destination1="";
			    	   String terminalname1="";
			    	   String journeyDate2="";
			    	   String departureTime2="";
			    	   String seatingStructure2="";
			    	   String source2="";
			    	   String boardingOn2="";
			    	   String destination2="";
			    	   String terminalname2="";
			    	   String seatNo1 = "";
			    	   String seatNo2 = "";
			    	   String Ticketno="";
			    	   String serviceId1="";
			    	   String serviceId2="";
			    	   String weekday1="";
			    	   String weekday2="";
			    	   String totalSeats="";
			    	   String vehiclemodel1="";
			    	   String vehiclemodel2="";
			    	   String reportingtime1="";
			    	   String reportingtime2="";
			    	   pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_TRANS_DETAILLS_FOR_ROUNDTRIP);
			    		pstmt.setString(1, transaction);	
			    		rs=pstmt.executeQuery();
			    		while (rs.next()){
			    		count=count+1;
			    		if(count == 1){
						journeyDate1=rs.getString("JOURNEY_DATE");
						departureTime1=rs.getString("DEPARTURE_TIME");
						String departuretimeFormat1 = departureTime1.substring(0,departureTime1.indexOf(":"));
						departureTime1 = getTimeFormat(Integer.parseInt(departuretimeFormat1),departureTime1);
					    seatingStructure1=rs.getString("SEATING_STRUCTURE");
						source1=rs.getString("SOURCE");
						totalAmount1=rs.getDouble("AMOUNT");
						Long L = Math.round(totalAmount1);
						grandtot1 = Integer.valueOf(L.intValue());
						boardingOn1=rs.getString("INSERTED_DATETIME");	
						destination1=rs.getString("DESTINATION");
						terminalname1=rs.getString("TERMINAL_NAME");	
						Ticketno=rs.getString("TICKET_NUMBER");
						serviceId1=rs.getString("SERVICE_ID");
						vehiclemodel1 = rs.getString("VEHICLE_MODEL");
						reportingtime1 = rs.getString("REPORTING_TIME");
						String departuretimeFormat = reportingtime1.substring(0,reportingtime1.indexOf(":"));
						reportingtime1 = getTimeFormat(Integer.parseInt(departuretimeFormat),reportingtime1);
						totalSeats = rs.getString("NUMBER_OF_SEATS");
						weekday1 = rs.getString("WEEKDAY");
			    		}
			    		if(count == 2){
			    			journeyDate2=rs.getString("JOURNEY_DATE");
							departureTime2=rs.getString("DEPARTURE_TIME");
							String departuretimeFormat1 = departureTime2.substring(0,departureTime2.indexOf(":"));
							departureTime2 = getTimeFormat(Integer.parseInt(departuretimeFormat1),departureTime2);
							seatingStructure2=rs.getString("SEATING_STRUCTURE");
							source2=rs.getString("SOURCE");
							totalAmount2=rs.getDouble("AMOUNT");
							Long L = Math.round(totalAmount2);
							grandtot2 = Integer.valueOf(L.intValue());
							boardingOn2=rs.getString("INSERTED_DATETIME");	
							destination2=rs.getString("DESTINATION");
							terminalname2=rs.getString("TERMINAL_NAME");
							Ticketno=rs.getString("TICKET_NUMBER");
							serviceId2=rs.getString("SERVICE_ID");
							vehiclemodel2 = rs.getString("VEHICLE_MODEL");
							reportingtime2 = rs.getString("REPORTING_TIME");
							String departuretimeFormat = reportingtime2.substring(0,reportingtime2.indexOf(":"));
							reportingtime2 = getTimeFormat(Integer.parseInt(departuretimeFormat),reportingtime2);
							totalSeats = rs.getString("NUMBER_OF_SEATS");
							weekday2 = rs.getString("WEEKDAY");
			    		}
			    	
		        }
			    		
			    		 pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_PASSANGER_DETAIL_FOR_MAIL);
				    	 pstmt.setString(1, transaction);	
				    	 rs=pstmt.executeQuery();
			    		 if(rs.next()){
			    			 phoneNo=rs.getString("PHONE_NUMBER");
			    		     emailId=rs.getString("EMAIL_ID");
			    		     name1 = rs.getString("PASSANGER_NAME"); 
			    		     name = name1.toUpperCase();	    		     
			    		}
			    		 
			    		 pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_BOOKED_SEATS_ROUNDTRIP);
				    	 pstmt.setString(1, transaction);	
				    	 pstmt.setString(2, serviceId1);
				    	// pstmt.setString(3,journeyDate1);
				    	 rs=pstmt.executeQuery();
			    		 while(rs.next()){	    		 
			    		  String seatNO1 =rs.getString("SEAT_NUMBER");
			    		  seatNo1 = seatNo1 +", "+seatNO1;
			    		  String passangerName = rs.getString("PASSANGER_NAME");
				    		 String mrMs = rs.getString("GENDER");
				    		 if(mrMs.equals("F")){
				    			 mrMs = "Mis/Mrs." ;
				    		 }else{
				    			 mrMs = "Mr." ;
				    		 }
				    		 passangerName = mrMs+passangerName.toUpperCase();
				    		 passangerNames = passangerNames+", "+passangerName;
			    		  }	    		
			    		 passangerNames = passangerNames.substring(1);
			    		 passangerNames = passangerNames.substring(1);
			    		 seatNo1 = seatNo1.substring(1);
			    		 pstmt = con.prepareStatement(PassengerBusTransportationStatements.GET_BOOKED_SEATS_ROUNDTRIP);
				    	 pstmt.setString(1, transaction);	
				    	 pstmt.setString(2, serviceId2);
				    	// pstmt.setString(3,journeyDate2);
				    	 rs=pstmt.executeQuery();
			    		 while(rs.next()){	    		 
			    		   String seatNO2=rs.getString("SEAT_NUMBER");
			    		   seatNo2=seatNo2 + ", " + seatNO2;
			    		   
			    		}
			    		 seatNo2 = seatNo2.substring(1);
				            generatePdfForRoudTrip(pdf,weekday1,weekday2,passangerNames,totalSeats,vehiclemodel1,vehiclemodel2,reportingtime1,reportingtime2,name,phoneNo,emailId,Ticketno,seatNo1,seatNo2,journeyDate1,departureTime1,seatingStructure1,source1,grandtot1,boardingOn1,destination1,terminalname1,journeyDate2,departureTime2,seatingStructure2,source2,grandtot2,boardingOn2,destination2,terminalname2,transaction,customerID,systemID);
			     }
			
			}
			   catch (Exception e) {
					e.printStackTrace();
				} finally {
					DBConnection.releaseConnectionToDB(con, pstmt,rs);
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

	
		public String getTimeFormat(int time,String timeString){
			String timeformat = "";	
			
			if(time >= 0 && time <= 11 ){
				timeformat = timeString+" AM";  	
			}else if(time == 12) {
				timeformat = timeString+" PM";  
			}else{
				time = time%12;
			    if(time>=1 && time<=9){
			    	timeformat = "0"+time+":"+timeString.substring(3,5)+" PM";
			    }else{
			    	timeformat = +time+":"+timeString.substring(3,5)+" PM";  	
			    }				
			}
			return timeformat;
		}
		
}// end of servelet
