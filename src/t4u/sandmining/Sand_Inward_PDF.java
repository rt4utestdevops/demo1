package t4u.sandmining;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.SandMiningPermitFunctions;



import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;


public class Sand_Inward_PDF extends HttpServlet {

	static BaseFont baseFont = null;
	SandMiningPermitFunctions sqlfun=new SandMiningPermitFunctions();
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{	try
	{
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
		SimpleDateFormat sdfFormatDatedd = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");


		int offset=330;
		HttpSession session = request.getSession();
		if (session.getAttribute("loginInfoDetails")!=null) {
			LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			offset=loginInfoBean.getOffsetMinutes();
		}


		String uids = request.getParameter("uids");
		String systemid = request.getParameter("systemId");
		String ts = request.getParameter("ts");
		String clientId = request.getParameter("clientId");
		uids=uids.substring(1);
		//System.out.println("#####################################"+systemid);
		ArrayList printList=sqlfun.getPrintList(uids,offset);
		//System.out.println("list=="+printList.toString());

		SimpleDateFormat simpleDateFormatddMMYY = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
		Calendar calendar = Calendar.getInstance();		
		Date TodayDate = calendar.getTime();
		String date=simpleDateFormatddMMYY.format(TodayDate);
		date= date.replaceAll("/", "");
		date=date.replaceAll(":", "");
		date=date.replaceAll(" ", "_");

		ServletOutputStream servletOutputStream = response.getOutputStream();
		Properties properties = ApplicationListener.prop;
		String billpath=  properties.getProperty("Builtypath");
		refreshdir(billpath);
		String formno="Trip_Sheet_Print_"+systemid+"_"+date;
		String fontPath = properties.getProperty("FontPathForMaplePDF");
		baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
		String bill = billpath+ formno + ".pdf";

		generateBill(bill,systemid,request,printList, clientId);
		printBill(servletOutputStream,response,bill,formno);

		//		}
	}
	catch (Exception e) 
	{
		System.out.println("Error generating sms bill : " + e);
		e.printStackTrace();
	}
	}



	private void generateBill(String bill,  String systemid, HttpServletRequest request, ArrayList printList, String clientId ) {		
		try
		{			
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4.rotate(), 40, 40, 30, 20);
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			document.open();
		//	SandMiningSQLFunction sqlfun=new SandMiningSQLFunction();
			
			//System.out.println("printList "+printList.toString());
			for (int i = 0; i < printList.size(); i++) {
				ArrayList list=(ArrayList) printList.get(i);
				
				String permitId=list.get(0).toString();
				String permitNo=list.get(1).toString();
				String permitDate=list.get(2).toString(); 
				String contractorName=list.get(3).toString(); 
				String contractorNo=list.get(4).toString(); 
				String vehicleNo=list.get(5).toString(); 
				String quantity=list.get(6).toString(); 
				String sandBlockFrom=list.get(7).toString(); 
				String stockyardTo=list.get(8).toString(); 
				String validFrom=list.get(9).toString(); 
				String validTo=list.get(10).toString(); 
				String processingFees=list.get(11).toString(); 
				String vhicleType=list.get(12).toString();
// =======================================================================================================				
				
							

				String headingString1 =        "KARNATAKA PUBLIC WORKS,";
				String headingString2 = "PORTS & INLAND WATER TRANSPORT";
				String headingString2i="DEPARTMENT"; 
				String headingString3="SAND INWARD PERMIT SHEET";
				String headingString4=" This is not Permit, Only Record for transportation of Sand from Sand Block to " +"                Stockyard" ;
                String headingString5="";
				
//********************Generic Sub Header From General_Settings**************************
                String headingString2ii = sqlfun.getSIPHeader(Integer.parseInt(systemid));
				

				//Top note
				PdfPTable headerTableTop = createBilldata();
				document.add(headerTableTop);
				
				PdfPTable headerTable0 = createBillhead0("",request); 
				document.add(headerTable0);

				// For heading
				PdfPTable headerTable = createBillhead("",headingString1);
				document.add(headerTable);
				PdfPTable headerTable1 = createBillheadi("",headingString2);
				document.add(headerTable1);
				PdfPTable headerTable1i = createBilldataii(headingString2i);
				document.add(headerTable1i);
				
				if(headingString2ii!=null){
					PdfPTable headerTable1ii = createBillheadiNew("",headingString2ii);
					document.add(headerTable1ii);
				}
			
				PdfPTable headerTable2 = createBillhead("",headingString3);
				document.add(headerTable2);

				//empty space
				PdfPTable headerTable45 =createBilldata24();
				document.add(headerTable45);
				
				headerTable = createBillhead2("",headingString4);
				document.add(headerTable);
				//headerTable = createBillhead2("",headingString5);
				//document.add(headerTable);
				document.add(headerTable45);
				//For date and TS No
				
				PdfPTable headerTable5i = createBilldata5(permitDate);
				document.add(headerTable5i);
				
				PdfPTable headerTablepdate = createBillheader2();
				document.add(headerTablepdate);
				
				PdfPTable headerTable5ii = createBilldata5i(permitNo);
				document.add(headerTable5ii);
				
				PdfPTable headerTable6i = createBillheader2();
				document.add(headerTable6i);
 
               // VALID FROM
				PdfPTable headerTable5 = createBilldataValidFrom(validFrom);
				document.add(headerTable5);
				
				PdfPTable headerTable6ii = createBillheader2();
				document.add(headerTable6ii);
				
				//VALID TO
				PdfPTable headerTable5x = createBilldataValidTo(validTo);
				document.add(headerTable5x);
				
				PdfPTable headerTable6iii = createBillheader2();
				document.add(headerTable6iii);
				


				// VEHICLE no
				PdfPTable headerTable5iii = createBilldata1(vehicleNo);
				document.add(headerTable5iii);

				PdfPTable headerTable6 = createBillheader2();
				document.add(headerTable6);

				//VEHICLETYPE
				PdfPTable headerTableVEHICLETYPE = createBilldataVEHICLETYPE(vhicleType);
				document.add(headerTableVEHICLETYPE);

				PdfPTable headerTableVEHICLETYPE1 = createBillheader2();
				document.add(headerTableVEHICLETYPE1);

				//contractor name
				PdfPTable headerContractor = createBilldataContractorName(contractorName);
				document.add(headerContractor);

				PdfPTable headerTableContractor1 = createBillheader2();
				document.add(headerTableContractor1);
				
				//contract NO
				PdfPTable headerContractorNo = createBilldataContractNo(contractorNo);
				document.add(headerContractorNo);

				PdfPTable headerTableContractor2 = createBillheader2();
				document.add(headerTableContractor2);
				
				// QUANTITY
				PdfPTable headerTable15 = createBilldata6(quantity);
				document.add(headerTable15);

				PdfPTable headerTable16 = createBillheader2();
				document.add(headerTable16);
				
				//Sand Block from
				PdfPTable sandBlock = createBilldataSandBlock(sandBlockFrom);
				document.add(sandBlock);

				PdfPTable sandBlock1 = createBillheader2();
				document.add(sandBlock1);
				
				//Sand Stock yard to
				PdfPTable stockYard = createBilldataStockyard(stockyardTo);
				document.add(stockYard);

				PdfPTable stockYard1 = createBillheader2();
				document.add(stockYard1);
				
				//processing fees
				PdfPTable procFees = createBilldataProcFees(processingFees);
				document.add(procFees);

				PdfPTable procFees1 = createBillheader2();
				document.add(procFees1);
				
				// EMPTY SPACE
				
				
				PdfPTable headerTableEmpty =createBilldata25();
				document.add(headerTableEmpty);
				
				//PERMIT ISSUER'S SIGNATURE
				PdfPTable headerTable23 = createBilldata10();
				document.add(headerTable23);


		

				if (i!=printList.size()-1) {
					//System.out.println("******");
					document.newPage();
				}
				//				//Sign n Seal
				//				PdfPTable headerTable29 = createBillheaderfoedns123();
				//				document.add(headerTable29);

			}
			document.close();
		}
		catch (Exception e) 
		{
			System.out.println("Error generating report : " + e);
			e.printStackTrace();
		}
	}


	private PdfPTable createBillhead2(String string, String headingString) {
		float[] widths = {5,75,25,75,25,75,5};
		PdfPTable t = new PdfPTable(7);




		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			Phrase myPhrase=new Phrase(headingString,new Font(baseFont,(float) 8, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBackgroundColor(Color.WHITE);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase=new Phrase(headingString,new Font(baseFont,(float) 8, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase=new Phrase(headingString,new Font(baseFont,(float) 8, Font.BOLD));
			PdfPCell c5 = new PdfPCell(myPhrase);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c41 = new PdfPCell(myPhrase1);
			c41.setBackgroundColor(Color.WHITE);
			c41.setBorder(Rectangle.NO_BORDER);
			t.addCell(c41);




		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	
	}



	



	/** if directory not exixts then create it */
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
			System.out.println("Error creating folder for Builty Report: " + e);
			e.printStackTrace();
		}
	}

	private PdfPTable createBilldataii(String header) {


		float[] widths = {40,50,68,50,77,50,40};
		PdfPTable t = new PdfPTable(7);
		


		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("                ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(" "+header+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);

			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("      "+header+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase1=new Phrase("                   ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase("       "+header+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.NO_BORDER);
			t.addCell(c6);

			myPhrase1=new Phrase("                ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c31 = new PdfPCell(myPhrase1);
			c31.setBackgroundColor(Color.WHITE);
			c31.setBorder(Rectangle.NO_BORDER);
			t.addCell(c31);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}
	
	private PdfPTable createBilldata() {


		float[] widths = {40,50,68,50,77,50,40};
		PdfPTable t = new PdfPTable(7);
		String Top1="OFFICE COPY";
		String	Top2="STOCKYARD COPY";
		String	Top3="DRIVER COPY";


		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("                ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(" "+Top1+"   ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);

			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("   "+Top2+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase1=new Phrase("                ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase("     "+Top3+"  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.NO_BORDER);
			t.addCell(c6);

			myPhrase1=new Phrase("                ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c31 = new PdfPCell(myPhrase1);
			c31.setBackgroundColor(Color.WHITE);
			c31.setBorder(Rectangle.NO_BORDER);
			t.addCell(c31);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}

	private PdfPTable createBillheadi(String PDForm,String headingString)
	{
		float[] widths = {15,60,35,60,35,60,15};
		PdfPTable t = new PdfPTable(7);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			Phrase myPhrase=new Phrase(headingString,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);

			myPhrase1=new Phrase(" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBackgroundColor(Color.WHITE);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase=new Phrase(headingString,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase("  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase=new Phrase(headingString,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c5 = new PdfPCell(myPhrase);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c41 = new PdfPCell(myPhrase1);
			c41.setBackgroundColor(Color.WHITE);
			c41.setBorder(Rectangle.NO_BORDER);
			t.addCell(c41);





		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	
	}	
	
//***************
	private PdfPTable createBillheadiNew(String PDForm,String headingString)
	{
	float[] widths = {15,60,35,60,35,60,15};
	PdfPTable t = new PdfPTable(7);

	try
	{
		t.setWidthPercentage(100);
		t.setWidths(widths);

		Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 6.7, Font.BOLD));
		PdfPCell c = new PdfPCell(myPhrase1);
		c.setBackgroundColor(Color.WHITE);
		c.setBorder(Rectangle.NO_BORDER);
		t.addCell(c);

		Phrase myPhrase=new Phrase(headingString+"\n\n\n",new Font(baseFont,(float) 6.6, Font.BOLD));
		PdfPCell c1 = new PdfPCell(myPhrase);
		c1.setBorder(Rectangle.NO_BORDER);
		t.addCell(c1);

		myPhrase1=new Phrase("",new Font(baseFont,(float) 6.6, Font.BOLD));
		PdfPCell c2 = new PdfPCell(myPhrase1);
		c2.setBackgroundColor(Color.WHITE);
		c2.setBorder(Rectangle.NO_BORDER);
		t.addCell(c2);

		myPhrase=new Phrase(headingString+"\n\n\n",new Font(baseFont,(float) 6.6, Font.BOLD));
		PdfPCell c3 = new PdfPCell(myPhrase);
		c3.setBorder(Rectangle.NO_BORDER);
		t.addCell(c3);

		myPhrase1=new Phrase("",new Font(baseFont,(float) 6.6, Font.BOLD));
		PdfPCell c4 = new PdfPCell(myPhrase1);
		c4.setBackgroundColor(Color.WHITE);
		c4.setBorder(Rectangle.NO_BORDER);
		t.addCell(c4);

		myPhrase=new Phrase(headingString+"\n\n\n",new Font(baseFont,(float) 6.6, Font.BOLD));
		PdfPCell c5 = new PdfPCell(myPhrase);
		c5.setBorder(Rectangle.NO_BORDER);
		t.addCell(c5);

		myPhrase1=new Phrase("",new Font(baseFont,(float) 6.6, Font.BOLD));
		PdfPCell c41 = new PdfPCell(myPhrase1);
		c41.setBackgroundColor(Color.WHITE);
		c41.setBorder(Rectangle.NO_BORDER);
		t.addCell(c41);





	}
	catch (Exception e) 
	{
		System.out.println("Error creating bill2 details for SMS Bills : " + e);
		e.printStackTrace();
	}
	return t;	

	}
	private PdfPTable createBillhead(String PDForm,String headingString)
	{
		float[] widths = {20,60,35,60,35,60,15};
		PdfPTable t = new PdfPTable(7);

		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			Phrase myPhrase=new Phrase(" "+headingString,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);

			myPhrase1=new Phrase(" ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBackgroundColor(Color.WHITE);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase=new Phrase("  "+headingString,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase("  ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase=new Phrase("   "+headingString,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c5 = new PdfPCell(myPhrase);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);

			myPhrase1=new Phrase("",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c41 = new PdfPCell(myPhrase1);
			c41.setBackgroundColor(Color.WHITE);
			c41.setBorder(Rectangle.NO_BORDER);
			t.addCell(c41);





		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	
	}	




	private PdfPTable createBilldata1(String vendorname) {
	float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);
       try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("VEHICLE NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLDITALIC));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("VEHICLE NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5 ,Font.BOLDITALIC));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("VEHICLE NO. ",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5,Font.BOLDITALIC));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);



		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}








	private PdfPTable createBilldataVEHICLETYPE(String vehAddr) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("VEHICLE TYPE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+vehAddr,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("VEHICLE TYPE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vehAddr,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("VEHICLE TYPE",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vehAddr,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}

	

	private PdfPTable createBilldata5(String permitDate) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("PERMIT DATE & TIME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+permitDate,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("PERMIT DATE & TIME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+permitDate,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("PERMIT DATE & TIME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+permitDate,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}


	private PdfPTable createBilldata5i(String permitNo) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("PERMIT NO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+permitNo,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("PERMIT NO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+permitNo,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("PERMIT NO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+permitNo,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}
	

	private PdfPTable createBilldataValidFrom(String validFrom) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("VALID FROM",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+validFrom,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("VALID FROM",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+validFrom,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("VALID FROM",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+validFrom,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}

	private PdfPTable createBilldataSandBlock(String sandBlock) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("SAND BLOCK",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+sandBlock,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("SAND BLOCK",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+sandBlock,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("SAND BLOCK",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+sandBlock,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}
	
	private PdfPTable createBilldata25() {

		float[] widths = {60,60,60};
		PdfPTable t = new PdfPTable(3);


		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("                                          ",new Font(baseFont, 10, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase("                                 ",new Font(baseFont,10, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			//c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.LEFT);
			t.addCell(c1);



			myPhrase1=new Phrase("                ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.LEFT);
			t.addCell(c2);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}
	
	private PdfPTable createBilldataContractNo(String sandBlock) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("CONTRACT NO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+sandBlock,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("CONTRACT NO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+sandBlock,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("CONTRACT NO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+sandBlock,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}
	
	private PdfPTable createBilldataContractorName(String sandBlock) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("CONTRACTOR NAME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+sandBlock,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("CONTRACTOR NAME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+sandBlock,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("CONTRACTOR NAME",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+sandBlock,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}
	
	private PdfPTable createBilldataStockyard(String stockYard) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("SAND STOCKYARD",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+stockYard,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("SAND STOCKYARD",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+stockYard,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("SAND STOCKYARD",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+stockYard,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}
	
	private PdfPTable createBilldataProcFees(String processingFee) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("PROCESSING FEES",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+processingFee,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("PROCESSING FEES",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+processingFee,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("PROCESSING FEES",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+processingFee,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}
	
	private PdfPTable createBilldataValidTo(String validTo) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("VALID TO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+validTo,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("VALID TO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+validTo,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("VALID TO",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+validTo,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	


	}
	
	private PdfPTable createBilldata6(String vendorname) {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("TOTAL QUANTITY",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("TOTAL QUANTITY",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("TOTAL QUANTITY",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":  "+vendorname,new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}

	
	private PdfPTable createBilldata10() {
		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("PERMIT ISSUER'S SIGN & SEAL",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase(":",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);

			myPhrase1=new Phrase("PERMIT ISSUER'S SIGN & SEAL",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.LEFT);
			t.addCell(c3);

			myPhrase1=new Phrase(":",new Font(baseFont,(float) 7.5, Font.BOLD));	
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setBackgroundColor(Color.WHITE);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);



			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setBorder(Rectangle.NO_BORDER);
			t.addCell(c5);


			myPhrase1=new Phrase("PERMIT ISSUER'S SIGN & SEAL",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setBackgroundColor(Color.WHITE);
			c6.setBorder(Rectangle.LEFT);
			t.addCell(c6);

			myPhrase1=new Phrase(":",new Font(baseFont,(float) 7.5, Font.BOLD));
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setBackgroundColor(Color.WHITE);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);



			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setBorder(Rectangle.NO_BORDER);
			t.addCell(c8);

		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}

	


	private PdfPTable createBilldata24() {

		float[] widths = {60,60,60};
		PdfPTable t = new PdfPTable(3);


		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase("                                          ",new Font(baseFont, 10, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase1);
			c.setBackgroundColor(Color.WHITE);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);

			myPhrase1=new Phrase("                                 ",new Font(baseFont,10, Font.BOLD));
			PdfPCell c1 = new PdfPCell(myPhrase1);
			//c1.setBackgroundColor(Color.WHITE);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);



			myPhrase1=new Phrase("                ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

	}
	private PdfPTable createBillheader2() {

		float[] widths = {20,35,10,20,35,10,20,35,10};
		PdfPTable t = new PdfPTable(9);



		try
		{
			t.setWidthPercentage(100);
			t.setWidths(widths);

			Phrase myPhrase1=new Phrase(" ");
			PdfPCell c1 = new PdfPCell(myPhrase1);
			c1.setFixedHeight(1);
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);

			myPhrase1=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase1);
			c2.setFixedHeight(1);
			c2.setBackgroundColor(Color.BLACK);
			t.addCell(c2);



			myPhrase1=new Phrase(" ");
			PdfPCell c3 = new PdfPCell(myPhrase1);
			c3.setFixedHeight(1);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			myPhrase1=new Phrase(" ");
			PdfPCell c4 = new PdfPCell(myPhrase1);
			c4.setFixedHeight(1);
			c4.setBorder(Rectangle.NO_BORDER);
			t.addCell(c4);

			myPhrase1=new Phrase(" ");
			PdfPCell c5 = new PdfPCell(myPhrase1);
			c5.setFixedHeight(1);
			c5.setBackgroundColor(Color.BLACK);
			t.addCell(c5);



			myPhrase1=new Phrase(" ");
			PdfPCell c6 = new PdfPCell(myPhrase1);
			c6.setFixedHeight(1);
			c6.setBorder(Rectangle.NO_BORDER);
			t.addCell(c6);


			myPhrase1=new Phrase(" ");
			PdfPCell c7 = new PdfPCell(myPhrase1);
			c7.setFixedHeight(1);
			c7.setBorder(Rectangle.NO_BORDER);
			t.addCell(c7);

			myPhrase1=new Phrase(" ");
			PdfPCell c8 = new PdfPCell(myPhrase1);
			c8.setFixedHeight(1);
			c8.setBackgroundColor(Color.BLACK);
			t.addCell(c8);



			myPhrase1=new Phrase(" ");
			PdfPCell c9 = new PdfPCell(myPhrase1);
			c9.setFixedHeight(1);
			c9.setBorder(Rectangle.NO_BORDER);
			t.addCell(c9);


		}
		catch (Exception e) 
		{
			System.out.println("Error creating bill2 details for SMS Bills : " + e);
			e.printStackTrace();
		}
		return t;	

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
			System.out.println("Error printing SMS Bills : " + e);
			e.printStackTrace();
		}
	}




	private PdfPTable createBillhead0(String PDForm, HttpServletRequest request)
	{

		//System.out.println("INSIDE createBillhead0");

		float[] widths = {70,20,90,20,90,20,90}; 
		PdfPTable t = new PdfPTable(7);
		try
		{
			t.setWidthPercentage(120); 
			t.setWidths(widths);

			String path = System.getProperty("catalina.base")+"//webapps//ApplicationImages//ApplicationButtonIcons//govt-kar.gif";
			
			Image img1 = Image.getInstance(path);

			Phrase myPhrase6=new Phrase(" ");
			PdfPCell c1 = new PdfPCell(myPhrase6);
			c1.setBackgroundColor(Color.WHITE); 
			c1.setBorder(Rectangle.NO_BORDER);
			t.addCell(c1);

			PdfPCell cell = new PdfPCell();
			cell.setHorizontalAlignment(0);
			cell.setBorderColor(Color.white);
			cell.addElement(img1);
			t.addCell(cell);

			myPhrase6=new Phrase(" ");
			PdfPCell c2 = new PdfPCell(myPhrase6);
			c2.setBackgroundColor(Color.WHITE);
			c2.setBorder(Rectangle.NO_BORDER);
			t.addCell(c2);


			PdfPCell cell1 = new PdfPCell();
			cell1.setHorizontalAlignment(0);
			cell1.setBorderColor(Color.white);
			cell1.addElement(img1);
			t.addCell(cell1);

			myPhrase6=new Phrase(" ");
			PdfPCell c3 = new PdfPCell(myPhrase6);
			c3.setBackgroundColor(Color.WHITE);
			c3.setBorder(Rectangle.NO_BORDER);
			t.addCell(c3);

			PdfPCell cell2 = new PdfPCell();
			cell2.setHorizontalAlignment(0);
			cell2.setBorderColor(Color.white);
			cell2.addElement(img1);
			t.addCell(cell2);

			myPhrase6=new Phrase(" ");
			PdfPCell c31 = new PdfPCell(myPhrase6);
			c31.setBackgroundColor(Color.WHITE);
			c31.setBorder(Rectangle.NO_BORDER);
			t.addCell(c31);



		}
		catch (Exception e) 
		{
			System.out.println("Error creating in header : " + e);
			e.printStackTrace();
		}
		return t;

	}









}
