package t4u.cashvanmanagement;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.CashVanManagementStatements;

import com.lowagie.text.Document;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

public class PdfForSuspenseReprint extends HttpServlet{

	private static final long serialVersionUID = 1L;
	static BaseFont baseFont = null;
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat yyyymmddhhiiss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	DecimalFormat df=new DecimalFormat("##.##");
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
		try{
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
            int clientId = loginInfo.getCustomerId();
            String custName = "";
            String atmId = "";
            String businessId = "";
            String date = "";
            String tripId = "";
            String businessType = "";
            String uniqueId = request.getParameter("uniqueId");
            ArrayList<String> customerDetails = getCustomerDetails(uniqueId,systemId,clientId);
            if(customerDetails.size() > 0){
            	custName = customerDetails.get(0);
            	date = customerDetails.get(1);
            	atmId = customerDetails.get(2);
            	businessId = customerDetails.get(3);
            	tripId = customerDetails.get(4);
            	businessType = customerDetails.get(6);
            }
            ServletOutputStream servletOutputStream = response.getOutputStream();
            Properties properties = ApplicationListener.prop;
            String billpath=  properties.getProperty("Builtypath");
            refreshdir(billpath);
            String pdfFileName="SuspenseReport";
            String fontPath = properties.getProperty("FontPathForMaplePDF");
            baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            String bill = billpath+ pdfFileName + ".pdf";
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4.rotate(),40,40,30,30);
			@SuppressWarnings("unused")
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			document.open();
			generatePdf(document,bill,custName,atmId,businessId,uniqueId,systemId,clientId,date,tripId,businessType);
			printBill(servletOutputStream, response, bill, pdfFileName);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	private void generatePdf(Document document,String bill,String custName,String atmId,String businessId,String uniqueId,
				int systemId,int clientId,String date,String tripId,String businessType) {
		try{
			
			PdfPTable custNameandDateTable = createCustNameandDateTable(custName,atmId);
			document.add(custNameandDateTable);
			PdfPTable emptyTable = createEmptyTable();
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			if(businessType.equals("ATM Replenishment")){
				PdfPTable previousLoadedTable = createPreviousLoadedDetailsTable(businessId,uniqueId,atmId,systemId,clientId,date,tripId);
				document.add(previousLoadedTable);
				
				document.add(emptyTable);
				document.add(emptyTable);
				document.add(emptyTable);
				document.add(emptyTable);
				document.add(emptyTable);
			}
			PdfPTable discrepancyTable = createDiscrepancyTable(uniqueId,systemId,clientId);
			document.add(discrepancyTable);
			document.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	private String valueWithCommas1(String value){
		if(value=="Null"){
			return "0.00";
		}
		else{
		return value.replaceAll("(\\d)(?=(\\d\\d\\d)+(?!\\d))", "$1,");
		}
	}
	private PdfPTable createDiscrepancyTable(String uniqueId,int systemId,int clientId) {
		float[] widths = {9,7,9,8,9,7,9,8,9,7,8,4,5};
		PdfPTable mainTable = new PdfPTable(13);
		try{
			mainTable.setWidthPercentage(100.0f);
			mainTable.setWidths(widths);
			ArrayList<ArrayList<String>> denominationDetails = getDenominationDetailsReprint(Integer.parseInt(uniqueId),systemId,clientId);
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("As Per Journal",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setColspan(2);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Physical Cash Balance",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setColspan(4);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Rejected Cash Balance",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setColspan(4);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Discrepancy",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setColspan(2);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Denomination",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("No. of Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("No. of Good Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("No. of Bad Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("No. of Good Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("No. of Bad Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Short",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Excess",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			double totalJournalAmt = 0;
			double totalPhysicalGoodAmt = 0;
			double totalPhysicalBadAmt = 0;
			double totalRejectedGoodAmt = 0;
			double totalRejectedBadAmt = 0;
			int totalShort = 0;
			int totalExcess = 0;
			
			ArrayList<String> array = new ArrayList<String>();
			for(int i=0; i<denominationDetails.size(); i++){
				array = denominationDetails.get(i);
				myPhrase=new Phrase(array.get(0),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.disableBorderSide(Rectangle.TOP);
				c.disableBorderSide(Rectangle.BOTTOM);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(array.get(1),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(valueWithCommas1(df.format(Double.parseDouble(array.get(0)) * Double.parseDouble(array.get(1)))),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c.disableBorderSide(Rectangle.LEFT);
				c.disableBorderSide(Rectangle.TOP);
				c.disableBorderSide(Rectangle.BOTTOM);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(array.get(2),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(valueWithCommas1(df.format(Double.parseDouble(array.get(0)) * Double.parseDouble(array.get(2)))),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(array.get(3),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(valueWithCommas1(df.format(Double.parseDouble(array.get(0)) * Double.parseDouble(array.get(3)))),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c.disableBorderSide(Rectangle.LEFT);
				c.disableBorderSide(Rectangle.TOP);
				c.disableBorderSide(Rectangle.BOTTOM);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(array.get(4),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(valueWithCommas1(df.format(Double.parseDouble(array.get(0)) * Double.parseDouble(array.get(4)))),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(array.get(5),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(valueWithCommas1(df.format(Double.parseDouble(array.get(0)) * Double.parseDouble(array.get(5)))),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c.disableBorderSide(Rectangle.LEFT);
				c.disableBorderSide(Rectangle.TOP);
				c.disableBorderSide(Rectangle.BOTTOM);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(array.get(6),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.disableBorderSide(Rectangle.LEFT);
				c.disableBorderSide(Rectangle.TOP);
				c.disableBorderSide(Rectangle.BOTTOM);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(array.get(7),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.disableBorderSide(Rectangle.LEFT);
				c.disableBorderSide(Rectangle.TOP);
				c.disableBorderSide(Rectangle.BOTTOM);
				mainTable.addCell(c);
				
				totalJournalAmt = totalJournalAmt + (Double.parseDouble(array.get(0)) * Double.parseDouble(array.get(1)));
				totalPhysicalGoodAmt = totalPhysicalGoodAmt + (Double.parseDouble(array.get(0)) * Double.parseDouble(array.get(2)));
				totalPhysicalBadAmt = totalPhysicalBadAmt + (Double.parseDouble(array.get(0)) * Double.parseDouble(array.get(3)));
				totalRejectedGoodAmt = totalRejectedGoodAmt + (Double.parseDouble(array.get(0)) * Double.parseDouble(array.get(4)));
				totalRejectedBadAmt = totalRejectedBadAmt + (Double.parseDouble(array.get(0)) * Double.parseDouble(array.get(5)));
				totalShort = totalShort + Integer.parseInt(array.get(6));
				totalExcess = totalExcess + Integer.parseInt(array.get(7));
			}
			myPhrase=new Phrase("Total Amt",new Font(baseFont, 7, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas1(df.format(totalJournalAmt)),new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas1(df.format(totalPhysicalGoodAmt)),new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas1(df.format(totalPhysicalBadAmt)),new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas1(df.format(totalRejectedGoodAmt)),new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.disableBorderSide(Rectangle.RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas1(df.format(totalRejectedBadAmt)),new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas1(String.valueOf(totalShort)),new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas1(String.valueOf(totalExcess)),new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.disableBorderSide(Rectangle.LEFT);
			mainTable.addCell(c);
		}catch(Exception e){
			e.printStackTrace();
		}
		return mainTable;
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
	private PdfPTable createPreviousLoadedDetailsTable(String businessId, String uniqueId,String atmId,int systemId,int clientId,String date,String tripId){
		float[] widths = {40,20,40};
		PdfPTable mainTable = new PdfPTable(3);
		try{
			mainTable.setWidthPercentage(100.0f);
			mainTable.setWidths(widths);
			
			float[] leftTableWidth = {16,11,13};
			float[] rightTableWidth = {15,11,14};
			
			PdfPTable leftTable = new PdfPTable(3);
			PdfPTable rightTable = new PdfPTable(3);
			
			leftTable.setWidthPercentage(100.0f);
			leftTable.setWidths(leftTableWidth);
			rightTable.setWidthPercentage(100.0f);
			rightTable.setWidths(rightTableWidth);
			ArrayList<String> previousDenominationDetails = getPreviousDenominationDetails(businessId,uniqueId,atmId,systemId,clientId);
			ArrayList<String> currentLoadedDenominationDetails = getCurrentLoadedDetails(businessId,uniqueId,systemId,clientId);
			ArrayList<String> prevDateAndTripNo = getPrevDate(businessId,uniqueId,atmId,systemId,clientId); 
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			myPhrase=new Phrase("Last Cash Loaded Details",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			leftTable.addCell(c);
			
			myPhrase=new Phrase("Trip No: "+prevDateAndTripNo.get(1),new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			leftTable.addCell(c);
			
			if(prevDateAndTripNo.get(0).equals("")){
				myPhrase=new Phrase("Date: ",new Font(baseFont, 9, Font.BOLD));
			}else{
				myPhrase=new Phrase("Date: "+ddmmyyyy.format(yyyymmddhhiiss.parse(prevDateAndTripNo.get(0))),new Font(baseFont, 9, Font.BOLD));
			}
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			leftTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setColspan(3);
			leftTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setColspan(3);
			leftTable.addCell(c);
			
			myPhrase=new Phrase("Denomination",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			leftTable.addCell(c);
			
			myPhrase=new Phrase("No of Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			leftTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			leftTable.addCell(c);
			double totalPrevAmount = 0;
			for(int i=0; i<previousDenominationDetails.size(); i++){
				if(i == 0){
					myPhrase=new Phrase("5000",new Font(baseFont, 7, Font.NORMAL));
				}else if(i == 1){
					myPhrase=new Phrase("2000",new Font(baseFont, 7, Font.NORMAL));
				}else if(i == 2){
					myPhrase=new Phrase("1000",new Font(baseFont, 7, Font.NORMAL));
				}else if(i == 3){
					myPhrase=new Phrase("500",new Font(baseFont, 7, Font.NORMAL));
				}else if(i == 4){
					myPhrase=new Phrase("100",new Font(baseFont, 7, Font.NORMAL));
				}
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				leftTable.addCell(c);
				
				myPhrase=new Phrase(previousDenominationDetails.get(i),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				leftTable.addCell(c);
				double amount = 0;
				if(i == 0){
					amount = Integer.parseInt(previousDenominationDetails.get(i)) * 5000;
				}else if(i == 1){
					amount = Integer.parseInt(previousDenominationDetails.get(i)) * 2000;
				}else if(i == 2){
					amount = Integer.parseInt(previousDenominationDetails.get(i)) * 1000;
				}else if(i == 3){
					amount = Integer.parseInt(previousDenominationDetails.get(i)) * 500;
				}else if(i == 4){
					amount = Integer.parseInt(previousDenominationDetails.get(i)) * 100;
				}
				totalPrevAmount = totalPrevAmount + amount;
				myPhrase=new Phrase(df.format(amount),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c.setBorder(Rectangle.NO_BORDER);
				leftTable.addCell(c);
			}
			myPhrase=new Phrase("Total Amt",new Font(baseFont, 7, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			leftTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			leftTable.addCell(c);
			
			myPhrase=new Phrase(df.format(totalPrevAmount),new Font(baseFont, 7, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			leftTable.addCell(c);
			
			myPhrase=new Phrase("Fresh Loading Details",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			rightTable.addCell(c);
			
			myPhrase=new Phrase("Trip No: "+tripId,new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			rightTable.addCell(c);
			
			myPhrase=new Phrase("Date: "+date,new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			rightTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setColspan(3);
			rightTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			c.setColspan(3);
			rightTable.addCell(c);
			
			myPhrase=new Phrase("Denomination",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			rightTable.addCell(c);
			
			myPhrase=new Phrase("No of Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			rightTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			rightTable.addCell(c);
			double totalCurrAmount = 0;
			for(int i=0; i<currentLoadedDenominationDetails.size(); i++){
				if(i == 0){
					myPhrase=new Phrase("5000",new Font(baseFont, 7, Font.NORMAL));
				}else if(i == 1){
					myPhrase=new Phrase("2000",new Font(baseFont, 7, Font.NORMAL));
				}else if(i == 2){
					myPhrase=new Phrase("1000",new Font(baseFont, 7, Font.NORMAL));
				}else if(i == 3){
					myPhrase=new Phrase("500",new Font(baseFont, 7, Font.NORMAL));
				}else if(i == 4){
					myPhrase=new Phrase("100",new Font(baseFont, 7, Font.NORMAL));
				}
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				rightTable.addCell(c);
				
				myPhrase=new Phrase(currentLoadedDenominationDetails.get(i),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				rightTable.addCell(c);
				
				double amount = 0;
				if(i == 0){
					amount = Integer.parseInt(currentLoadedDenominationDetails.get(i)) * 5000;
				}else if(i == 1){
					amount = Integer.parseInt(currentLoadedDenominationDetails.get(i)) * 2000;
				}else if(i == 2){
					amount = Integer.parseInt(currentLoadedDenominationDetails.get(i)) * 1000;
				}else if(i == 3){
					amount = Integer.parseInt(currentLoadedDenominationDetails.get(i)) * 500;
				}else if(i == 4){
					amount = Integer.parseInt(currentLoadedDenominationDetails.get(i)) * 100;
				}
				totalCurrAmount =  totalCurrAmount + amount;
				myPhrase=new Phrase(valueWithCommas1(df.format(amount)),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c.setBorder(Rectangle.NO_BORDER);
				rightTable.addCell(c);
			}
			myPhrase=new Phrase("Total Amt",new Font(baseFont, 7, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			rightTable.addCell(c);
			
			myPhrase=new Phrase("",new Font(baseFont, 7, Font.NORMAL));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			rightTable.addCell(c);
			
			myPhrase=new Phrase(valueWithCommas1(df.format(totalCurrAmount)),new Font(baseFont, 7, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
			c.setBorder(Rectangle.NO_BORDER);
			rightTable.addCell(c);
			
			mainTable.addCell(leftTable);
			myPhrase=new Phrase("",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			c.setBorder(Rectangle.NO_BORDER);
			mainTable.addCell(c);
			mainTable.addCell(rightTable);
			
		}catch(Exception e){
			e.printStackTrace();
		}
		return mainTable;
	}

	private PdfPTable createCustNameandDateTable(String custName,String atmId) {
		float[] widths = {40,20,40};
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
			
			myPhrase=new Phrase("Business Id : "+atmId,new Font(baseFont, 9, Font.BOLD));
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
	private void printBill(ServletOutputStream servletOutputStream,	HttpServletResponse response, String bill, String pdfFileName) {
		try{
			response.setContentType("application/pdf");
			response.setHeader("Content-disposition","inline;filename="+pdfFileName+".pdf");
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
	//To create new directory if not existence 
	private void refreshdir(String reportpath) {
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
	private ArrayList<String> getPreviousDenominationDetails(String businessId, String uniqueId, String atmId, int systemId,int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> denominationDetails =  new ArrayList<String>();
		String denom5000 = "0";
		String denom2000 = "0";
		String denom1000 = "0";
		String denom500 = "0";
		String denom100 = "0";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_PREV_DENOMINATION_DETAILS_FOR_ATM_REP);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, atmId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, Integer.parseInt(uniqueId));
			pstmt.setInt(7, Integer.parseInt(businessId));
			rs = pstmt.executeQuery();
			while(rs.next()){
				denom5000 = rs.getString("denom5000");
				denom2000 = rs.getString("denom2000");
				denom1000 = rs.getString("denom1000");
				denom500 = rs.getString("denom500");
				denom100 = rs.getString("denom100");
			}
			denominationDetails.add(denom5000);
			denominationDetails.add(denom2000);
			denominationDetails.add(denom1000);
			denominationDetails.add(denom500);
			denominationDetails.add(denom100);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return denominationDetails;
	}
	private ArrayList<String> getPrevDate(String businessId, String uniqueId, String atmId, int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		String date = "";
		String tripId = "";
		ArrayList<String> dateAndTripArray = new ArrayList<String>();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_PREV_DENOMINATION_DETAILS_FOR_ATM_REP);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setString(3, atmId);
			pstmt.setInt(4, systemId);
			pstmt.setInt(5, clientId);
			pstmt.setInt(6, Integer.parseInt(uniqueId));
			pstmt.setInt(7, Integer.parseInt(businessId));
			rs = pstmt.executeQuery();
			if(rs.next()){
				date = rs.getString("date");
				tripId = rs.getString("tripId");
			}
			dateAndTripArray.add(date);
			dateAndTripArray.add(tripId);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return dateAndTripArray;
	}
	private ArrayList<String> getCurrentLoadedDetails(String businessId,String uniqueId, int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> denominationDetails =  new ArrayList<String>();
		String denom5000 = "0";
		String denom2000 = "0";
		String denom1000 = "0";
		String denom500 = "0";
		String denom100 = "0";
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_FRESH_DENOMINATION_DETAILS_FOR_ATM_REP);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, Integer.parseInt(uniqueId));
			rs = pstmt.executeQuery();
			while(rs.next()){
				denom5000 = rs.getString("denom5000");
				denom2000 = rs.getString("denom2000");
				denom1000 = rs.getString("denom1000");
				denom500 = rs.getString("denom500");
				denom100 = rs.getString("denom100");
			}
			denominationDetails.add(denom5000);
			denominationDetails.add(denom2000);
			denominationDetails.add(denom1000);
			denominationDetails.add(denom500);
			denominationDetails.add(denom100);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return denominationDetails;
	}
	private ArrayList<String> getCustomerDetails( String uniqueId, int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> customerDetails = new ArrayList<String>();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SUSPENSE_REPRINT_CUSTOMER_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, Integer.parseInt(uniqueId));
			rs = pstmt.executeQuery();
			while(rs.next()){
				customerDetails.add(rs.getString("customerName"));
				customerDetails.add(ddmmyyyy.format(yyyymmddhhiiss.parse(rs.getString("date"))));
				customerDetails.add(rs.getString("businessId"));
				customerDetails.add(rs.getString("atmId"));
				customerDetails.add(rs.getString("tripId"));
				customerDetails.add(rs.getString("tripSheetNo"));
				customerDetails.add(rs.getString("businessType"));
			}	
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return customerDetails;
	}
	private ArrayList<ArrayList<String>> getDenominationDetailsReprint(int uniqueId, int systemId, int clientId) {
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<String> denominationDetails = null;
		ArrayList<ArrayList<String>> finalDenominationDetails = new ArrayList<ArrayList<String>>();
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_SUSPENSE_DENOMINATION_DETAILS);
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			pstmt.setInt(3, uniqueId);
			rs = pstmt.executeQuery();
			while(rs.next()){
				denominationDetails = new ArrayList<String>();
				denominationDetails.add(rs.getString("denomination"));
				denominationDetails.add(rs.getString("gernal"));
				denominationDetails.add(rs.getString("physicalGood"));
				denominationDetails.add(rs.getString("physicalBad"));
				denominationDetails.add(rs.getString("rejectedGood"));
				denominationDetails.add(rs.getString("rejectedBad"));
				denominationDetails.add(rs.getString("short"));
				denominationDetails.add(rs.getString("excess"));
				finalDenominationDetails.add(denominationDetails);
			}	
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalDenominationDetails;
	}
}
