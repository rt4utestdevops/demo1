package t4u.containercargomanagement;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.EnglishNumberToWords;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.ContainerCargoManagementFunctions;

import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class PdfForSummaryInvoice extends HttpServlet{
	private static final long serialVersionUID = 1L;
	static BaseFont baseFont = null;
	DecimalFormat doubleDecimal = new DecimalFormat("00.00"); 
	SimpleDateFormat ddmmyyhhiiss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	SimpleDateFormat ddmmyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat yyyymmdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	ContainerCargoManagementFunctions ccmFunc = new ContainerCargoManagementFunctions();
	JSONArray jArr = new JSONArray();
	JSONObject obj = null;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    	try{   
    		HttpSession session = request.getSession();
            LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
            int systemId = loginInfo.getSystemId();
            int clientId = loginInfo.getCustomerId();
            int offset = loginInfo.getOffsetMinutes();
            String principalId = request.getParameter("principalId");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String typeId = request.getParameter("typeId");
            String invoiceType = request.getParameter("invoiceType"); 
    		ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath =  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String pdfFileName="summaryInvoice";
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath+ pdfFileName + ".pdf";
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4.rotate(), 40, 40, 40, 30);
			@SuppressWarnings("unused")
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			document.open();
			String sDate = yyyymmdd.format(ddmmyyhhiiss.parse(startDate));
			String eDate = yyyymmdd.format(ddmmyyhhiiss.parse(endDate));
			jArr = ccmFunc.getSumarryInvoiceDetails(systemId,clientId,principalId,typeId,sDate,eDate,offset,invoiceType);
			
			generatePdf(document,bill,jArr,systemId,clientId,typeId,principalId,startDate,endDate);
			
			printBill(servletOutputStream, response, bill, pdfFileName);
    	}catch (Exception e) {
    		e.printStackTrace();
    	}
    }

    private void generatePdf(Document document, String bill,JSONArray jArray,int systemId, int clientId, String typeId,String principalId,String startDate, String endDate) {
    	try {
    		PdfPTable customerAndDate = createHeader(systemId,clientId);
			document.add(customerAndDate);
			
			PdfPTable emptyTable = createEmptyTable();
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			
			PdfPTable billNoandDateTable = createbillNoandDateTable(systemId,clientId,typeId);
			document.add(billNoandDateTable);
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			
			PdfPTable principalDetails = createPrincipalDetails(systemId,clientId,principalId);
			document.add(principalDetails);
			document.add(emptyTable);
			document.add(emptyTable);
			
			String text = "";
			if(typeId.equals("1")){
				text = "Dear Sir,\n" +
						"		Hire charges for Truck used for Transportation of your New Drums in Vetical Position" +
						"	for the period of "+ddmmyy.format(ddmmyyhhiiss.parse(startDate))+" to "+ ddmmyy.format(ddmmyyhhiiss.parse(endDate));
			}else{
				text = "Labour bill for the period of "+ddmmyy.format(ddmmyyhhiiss.parse(startDate))+" to "+ ddmmyy.format(ddmmyyhhiiss.parse(endDate));
			}
			PdfPTable subjectText = createSubjectTextTable(text);
			document.add(subjectText);
			document.add(emptyTable);
			document.add(emptyTable);
			
			PdfPTable summaryDetails = createsummaryDetails(jArray);
			document.add(summaryDetails);
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			double tot = 0;
			JSONObject jsObj = null;
			for(int i = 0; i < jArray.length(); i++){
				jsObj = jArray.getJSONObject(i);
				tot = tot + jsObj.getDouble("amountDI");
			}
			PdfPTable amountInWords = createamountInWordsTable(tot);
			document.add(amountInWords);
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			
			PdfPTable noteMSG;
			if(typeId.equals("1")){
				noteMSG = createNoteMessageBilling();
			}else{
				noteMSG = createNoteMessageUnloading();
			}
			document.add(noteMSG);
			document.newPage();
			document.close();
    	} catch (Exception e) {
				e.printStackTrace();
		}	
	}
    
	private PdfPTable createSubjectTextTable(String text) {
		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			myPhrase=new Phrase(text,new Font(baseFont, 9, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}

	private PdfPTable createamountInWordsTable(double totalamount) {
		String inwords = "";
		int value = 0;
		double diffsubTotal = 0;
		value = (int)totalamount;
		diffsubTotal = totalamount - value;
		
		if(diffsubTotal>=0.5)
		{
			totalamount = Math.ceil(totalamount);
			diffsubTotal = 1 - diffsubTotal;
		}else
		{
			totalamount = Math.floor(totalamount);
		}	
		
		String amount = doubleDecimal.format(totalamount);
	    
		if(!(amount.equals("0.00")||amount.equals("0"))){
		if(amount.contains(".")){
			String data = amount;
			data = data.replace(".","/");
			String[] number = data.split("/");
			inwords = EnglishNumberToWords.convert(Long.parseLong(number[0]));
			if((!number[1].equals("")) && number[1].length() >=1){
				inwords =inwords+" rupees and "+EnglishNumberToWords.convert(Long.parseLong(number[1]))+" paise.";
			}else{
				inwords =inwords+" rupees";
			}
		}else{
			inwords = EnglishNumberToWords.convert(Long.parseLong(amount))+" rupees";
		}
		}else{
			inwords = "Zero rupees and Zero paise.";
		}
		float[] width = {100};
		PdfPTable t = new PdfPTable(1);
		try
		{
			t.setWidthPercentage(100.0f);
			t.setWidths(width);
			
			Phrase myPhrase=new Phrase("Amount in Words: "+inwords,new Font(baseFont, 9, Font.NORMAL));
			PdfPCell c = new PdfPCell(myPhrase);
			c.setBackgroundColor(Color.white);
			c.setHorizontalAlignment(Element.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
		}
		catch (Exception e) 
		{
			e.printStackTrace();
		}	
		return t;
	}
	private PdfPTable createPrincipalDetails(int systemId, int clientId, String principalId) {
		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			ArrayList<String> principalDetails = ccmFunc.getPrincipalDetails(systemId,clientId,principalId);
			
			for(int i = 0; i < principalDetails.size(); i++){
				myPhrase=new Phrase(principalDetails.get(i),new Font(baseFont, 9, Font.BOLD));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(c);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}

	private PdfPTable createbillNoandDateTable(int systemId, int clientId, String type) {
		float[] widths = {35,30,35};
		PdfPTable t = new PdfPTable(3);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase = null;
			PdfPCell c = null;
			String billNo = "";
			billNo = ccmFunc.generateInvoiceNumber(systemId,clientId,"DIN");
			
			myPhrase=new Phrase("Bill No : "+billNo,new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Date : "+ ddmmyy.format(new Date()),new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}

	private PdfPTable createEmptyTable() {
		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase = null;
			PdfPCell c = null;
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}

	private PdfPTable createsummaryDetails(JSONArray jArr) {
		float[] widths = {40,15,15,15,15};
		PdfPTable t = new PdfPTable(5);
		try{
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			
			Phrase myPhrase=new Phrase("Consignee",new Font(baseFont, 9, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Quantity",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Billing Type",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Rate",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Amount",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			double totalQuantity = 0;
			double totalAmount = 0;
			for(int i = 0; i < jArr.length(); i++){
				obj = jArr.getJSONObject(i);
				myPhrase=new Phrase(obj.getString("consigneeDI"),new Font(baseFont, 8, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				t.addCell(c);
				
				myPhrase=new Phrase(doubleDecimal.format(obj.getDouble("quantityDI")),new Font(baseFont, 8, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				t.addCell(c);
				
				myPhrase=new Phrase(obj.getString("typeDI"),new Font(baseFont, 8, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				
				if(obj.getString("typeDI").equals("Fixed")){
					myPhrase=new Phrase(doubleDecimal.format(obj.getDouble("amountDI")),new Font(baseFont, 8, Font.NORMAL));
				}else{
					myPhrase=new Phrase(doubleDecimal.format(obj.getDouble("rateDI")),new Font(baseFont, 8, Font.NORMAL));
				}
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				t.addCell(c);
				
				myPhrase=new Phrase(doubleDecimal.format(obj.getDouble("amountDI")),new Font(baseFont, 8, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				t.addCell(c);
				
				totalQuantity = totalQuantity + obj.getDouble("quantityDI");
				totalAmount = totalAmount + obj.getDouble("amountDI");
			}
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setColspan(4);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setColspan(4);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("Grand Total",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			t.addCell(c);
			
			myPhrase=new Phrase(doubleDecimal.format(totalQuantity),new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			t.addCell(c);
			
			myPhrase=new Phrase(doubleDecimal.format(totalAmount),new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			t.addCell(c);
		}catch(Exception e){
			e.printStackTrace();
		}
		return t;
	}

	private PdfPTable createHeader(int systemId, int clientId) {
		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			
			ArrayList<String> headerDetails = ccmFunc.invoiceHeaderDetails(systemId,clientId, "Invoice Header");
			
			Phrase myPhrase = null;
			PdfPCell c = null;
			for(int i = 0; i < headerDetails.size(); i++){
				if(i == 0){
					myPhrase=new Phrase(headerDetails.get(i),new Font(baseFont, 9, Font.BOLD));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c);
				}else{
					myPhrase=new Phrase(headerDetails.get(i),new Font(baseFont, 8, Font.BOLD));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					t.addCell(c);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}

	private void printBill(ServletOutputStream servletOutputStream,HttpServletResponse resp, String bill, String pdfFileName) {
		try{
			resp.setContentType("application/pdf");
			resp.setHeader("Content-disposition","inline;filename="+pdfFileName+".pdf");
			FileInputStream fis = new FileInputStream(bill);
			DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);
			byte [] buffer = new byte [1024];
			int len = 0;
			while ((len = fis.read(buffer)) >= 0 ) {
				outputStream.write(buffer, 0, len);
			}
			servletOutputStream.flush();
			servletOutputStream.close();
		}catch (Exception e) {
			e.printStackTrace();
		}
	}

	/** if directory not exixts then create it */
	private void refreshdir(String reportpath){
		try{
			File f = new File(reportpath);
			if(!f.exists()){
				f.mkdir();
			}
		} catch (Exception e) {
			System.out.println("Error creating folder for Report: " + e);
			e.printStackTrace();
		}
	}
	
	private PdfPTable createNoteMessageBilling() {
		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			myPhrase=new Phrase("For PADMA TRAVELS",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			myPhrase=new Phrase(" ",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			myPhrase=new Phrase(" ",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			myPhrase=new Phrase(" ",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			myPhrase=new Phrase("Authorised Signatory",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}
		private PdfPTable createNoteMessageUnloading() {
		float[] widths = {50,50};
		PdfPTable t = new PdfPTable(2);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			myPhrase=new Phrase("(SERVICE TAX DIRECTLY PAYABLE BY CUSTOMER)",new Font(baseFont, 9, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			myPhrase=new Phrase("PADMA TRAVELS",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			t.addCell(c);
			myPhrase=new Phrase(" ",new Font(baseFont, 9, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setColspan(1);
			t.addCell(c);
			myPhrase=new Phrase(" ",new Font(baseFont, 9, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setColspan(1);
			t.addCell(c);
			myPhrase=new Phrase(" ",new Font(baseFont, 9, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setColspan(1);
			t.addCell(c);
			myPhrase=new Phrase(" ",new Font(baseFont, 9, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setColspan(1);
			t.addCell(c);
			myPhrase=new Phrase("PLEASE PAY BY A/C. PAYEES CHEQUE ONLY",new Font(baseFont, 9, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			myPhrase=new Phrase("MANAGER / AUTHORISED",new Font(baseFont, 9, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			t.addCell(c);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}
}