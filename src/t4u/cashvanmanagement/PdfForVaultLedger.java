package t4u.cashvanmanagement;

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

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.CashVanManagementFunctions;

import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class PdfForVaultLedger extends HttpServlet{
	private static final long serialVersionUID = 1L;
	static BaseFont baseFont = null;
	CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
	DecimalFormat doubleDecimal = new DecimalFormat("00.00"); 
	SimpleDateFormat ddmmyyyhhiiss = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    	try{   
    		HttpSession session = request.getSession();
            LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
            int systemId = loginInfo.getSystemId();
            int clientId = loginInfo.getCustomerId();
            int offset = loginInfo.getOffsetMinutes();
            String cvsCustId = request.getParameter("cvsCustId");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");
            String custType = request.getParameter("custType");
    		ServletOutputStream servletOutputStream = response.getOutputStream();
			Properties properties = ApplicationListener.prop;
			String billpath=  properties.getProperty("Builtypath");
			refreshdir(billpath);
			String pdfFileName="VaultLedgerReport";
			String fontPath = properties.getProperty("FontPathForMaplePDF");
			baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
			String bill = billpath+ pdfFileName + ".pdf";
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4.rotate(), 40, 40, 40, 30);
			@SuppressWarnings("unused")
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			document.open();
			String customerName = "";
			if(cvsCustId.equals("0")){
				customerName = "All";
			}else{
				customerName = cashVanfunc.getCustomerName(systemId,clientId,Integer.parseInt(cvsCustId));
			}
			ArrayList<ArrayList<String>> ledgerDetails = cashVanfunc.getLedgerDetails(systemId,clientId,cvsCustId,startDate,endDate,offset,custType);
			ArrayList<String> currentVaultDetails = cashVanfunc.getCurrentVaultDetailsForPdf(systemId,clientId,cvsCustId);
			
			generatePdf(document,bill,customerName,startDate,endDate,ledgerDetails,currentVaultDetails);
			
			printBill(servletOutputStream, response, bill, pdfFileName);
    	}catch (Exception e) {
    		e.printStackTrace();
    	}
    }

    private void generatePdf(Document document, String bill,String custName,String startDate,String endDate,ArrayList<ArrayList<String>> ledgerDetails,ArrayList<String> currentVaultDetails) {
    	try {
    		double totalCashDispense = 0; 
    		double totalCashInward = 0;
    		double totalSealBagDispense  = 0;
    		double totalSealBagInward = 0;
    		double totalChequeDispense  = 0;
    		double totalChequeInward = 0;
    		double totalJewelleryDispense  = 0;
    		double totalJewelleryInward = 0;
    		double totalForexDispense  = 0;
    		double totalForexInward = 0;
    		for(int i =0; i< ledgerDetails.size(); i++){
    			ArrayList<String> array = ledgerDetails.get(i);
        		totalCashDispense = totalCashDispense + Double.parseDouble(array.get(6));
        		totalCashInward = totalCashInward + Double.parseDouble(array.get(7));
        		totalSealBagDispense = totalSealBagDispense + Double.parseDouble(array.get(8));
        		totalSealBagInward = totalSealBagInward + Double.parseDouble(array.get(9));
        		totalChequeDispense = totalChequeDispense + Double.parseDouble(array.get(11));
        		totalChequeInward = totalChequeInward + Double.parseDouble(array.get(10));
        		totalJewelleryDispense = totalJewelleryDispense + Double.parseDouble(array.get(13));
        		totalJewelleryInward = totalJewelleryInward + Double.parseDouble(array.get(12));
        		totalForexDispense = totalForexDispense + Double.parseDouble(array.get(15));
        		totalForexInward = totalForexInward + Double.parseDouble(array.get(14));
    		}
    		double ledgerBalance = Double.parseDouble(currentVaultDetails.get(0));
    		double availableBalance = Double.parseDouble(currentVaultDetails.get(1));
    		double sealBagBalance = Double.parseDouble(currentVaultDetails.get(2));
    		double totalBalance = Double.parseDouble(currentVaultDetails.get(3));
    		double totalChequeBalance = Double.parseDouble(currentVaultDetails.get(4));
    		double totalJewelleryBalance = Double.parseDouble(currentVaultDetails.get(5));
    		double totalForexBalance = Double.parseDouble(currentVaultDetails.get(6));
    		
    		PdfPTable customerAndDate = createcustomerAndDate(custName,startDate,endDate);
			document.add(customerAndDate);
			
			PdfPTable ledgerDetailsTable = createLedgerDetails(ledgerDetails);
			document.add(ledgerDetailsTable);
			
			PdfPTable emptyTable = createEmptyTable();
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			
			PdfPTable inwardDispenseDetails = createInwardDispenseDetails(totalCashDispense,totalCashInward,totalSealBagDispense,totalSealBagInward,
								ledgerBalance,availableBalance,sealBagBalance,totalBalance,totalChequeDispense,totalChequeInward,totalJewelleryDispense,totalJewelleryInward,
								totalForexDispense,totalForexInward,totalChequeBalance,totalJewelleryBalance,totalForexBalance);
			document.add(inwardDispenseDetails);
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			
			PdfPTable noteMSG = createnoteMSG();
			document.add(noteMSG);
			document.newPage();
			document.close();
    	} catch (Exception e) {
				e.printStackTrace();
		}	
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
	private String valueWithCommas(double value){
	
		return String.format("%,.2f",value);
		
	}
	private String valueWithCommas1(String value){
		if(value=="Null"){
			return "0.00";
		}
		else{
		return value.replaceAll("(\\d)(?=(\\d\\d\\d)+(?!\\d))", "$1,");
		}
	}
	private PdfPTable createInwardDispenseDetails(double totalCashDispense, double totalCashInward, double totalSealBagDispense, double totalSealBagInward,
						double ledgerBalance, double availableBalance, double sealBagBalance, double totalBalance,double totalChequeDispense,double totalChequeInward, double totalJewelleryDispense,
						double totalJewelleryInward,double totalForexDispense,double totalForexInward,double totalChequeBalance,double totalJewelleryBalance,double totalForexBalance) {
		float[] widths = {23,23,8,23,23};
		PdfPTable t = new PdfPTable(5);
		try{
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			
			Phrase myPhrase=new Phrase("Total Cash Dispense ",new Font(baseFont, 8, Font.BOLD));
			PdfPCell c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.disableBorderSide(Rectangle.LEFT);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.BOTTOM);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalCashDispense)+" Dr",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.BOTTOM);
			t.addCell(c);
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.disableBorderSide(Rectangle.LEFT);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.BOTTOM);
			t.addCell(c);
			
			myPhrase=new Phrase("Total Cash Inward ",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.disableBorderSide(Rectangle.LEFT);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.BOTTOM);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalCashInward)+" Cr",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.BOTTOM);
			t.addCell(c);
			
			myPhrase=new Phrase("Total Sealed Bag Dispense ",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalSealBagDispense)+" Dr",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("Total Sealed Bag Inward ",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalSealBagInward)+" Cr",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("Total Cheque Dispense ",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalChequeDispense)+" Dr",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("Total Cheque Inward ",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalChequeInward)+" Cr",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("Total Jewellery Dispense ",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalJewelleryDispense)+" Dr",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("Total Jewellery Inward ",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalJewelleryInward)+" Cr",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("Total Foreign Currency Dispense ",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalForexDispense)+" Dr",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("Total Foreign Currency Inward ",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalForexInward)+" Cr",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(5);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(5);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(ddmmyyyhhiiss.format(new Date()),new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			t.addCell(c);
			
			myPhrase=new Phrase("Ledger Balance",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(ledgerBalance),new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			t.addCell(c);
			
			myPhrase=new Phrase("Available Balance",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(availableBalance),new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			t.addCell(c);
			
			myPhrase=new Phrase("Sealed Bag Balance",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(sealBagBalance),new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			t.addCell(c);
			
			myPhrase=new Phrase("Cheque Balance",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalChequeBalance),new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			t.addCell(c);
			
			myPhrase=new Phrase("Jewellery Balance",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalJewelleryBalance),new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			t.addCell(c);
			
			myPhrase=new Phrase("Foreign Currency Balance",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalForexBalance),new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			c.setColspan(3);
			t.addCell(c);
			
			myPhrase=new Phrase("Overall Total Value",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas(totalBalance),new Font(baseFont, 8, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			t.addCell(c);
		}catch(Exception e){
			e.printStackTrace();
		}
		return t;
	}

	private PdfPTable createLedgerDetails(ArrayList<ArrayList<String>> ledgerDetails) {
		float[] widths = {4,16,16,16,16,16,16};
		PdfPTable t = new PdfPTable(7);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase = null;
			PdfPCell c = null;
			myPhrase=new Phrase("Sl No",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Date Time",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Trip No",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Customer Type",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("On Account Of",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Business Id",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Amount (Cr/Dr)",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			int count = 0;
			for(int i=0; i<ledgerDetails.size();i++){
				count++;
				ArrayList<String> details = ledgerDetails.get(i);
				myPhrase=new Phrase(String.valueOf(count),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				t.addCell(c);
				if(details.get(16).equals("SUSPEND TRIP")){
					
					myPhrase=new Phrase(details.get(0),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBackgroundColor(Color.GRAY);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					c.setBackgroundColor(Color.GRAY);
					t.addCell(c);
					
					myPhrase=new Phrase(details.get(1),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					c.setBackgroundColor(Color.GRAY);
					t.addCell(c);
					
					myPhrase=new Phrase(details.get(2),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					c.setBackgroundColor(Color.GRAY);
					t.addCell(c);
					
					myPhrase=new Phrase(details.get(3),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					c.setBackgroundColor(Color.GRAY);
					t.addCell(c);
					
					myPhrase=new Phrase(details.get(4),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					c.setBackgroundColor(Color.GRAY);
					t.addCell(c);
					
					myPhrase=new Phrase(valueWithCommas1(details.get(5)),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
					c.setBackgroundColor(Color.GRAY);
					t.addCell(c);
				}else{
				
					
					myPhrase=new Phrase(details.get(0),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					t.addCell(c);
					
					myPhrase=new Phrase(details.get(1),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					t.addCell(c);
					
					myPhrase=new Phrase(details.get(2),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					t.addCell(c);
					
					myPhrase=new Phrase(details.get(3),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					t.addCell(c);
					
					myPhrase=new Phrase(details.get(4),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					t.addCell(c);
					
					
					myPhrase=new Phrase(valueWithCommas1(details.get(5)),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
					t.addCell(c);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}

	private PdfPTable createcustomerAndDate(String custName, String startDate,	String endDate) {
		float[] widths = {40,10,50};
		PdfPTable t = new PdfPTable(3);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase = null;
			PdfPCell c = null;
			myPhrase=new Phrase("Customer Name : "+custName,new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("Statement from :  "+startDate+"   To   "+endDate,new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 8, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			t.addCell(c);
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
			System.out.println("Error creating folder for Builty Report: " + e);
			e.printStackTrace();
		}
	}
	
	private PdfPTable createnoteMSG() {
		float[] widths = {100};
		PdfPTable t = new PdfPTable(1);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase = null;
			PdfPCell c = null;
			myPhrase=new Phrase("Note : SB - indicates sealed bag amount, CQ - indicates cheque amount, JW - indicates jewellery amount, FX - indicates foreign currency ",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return t;
	}
			
}
