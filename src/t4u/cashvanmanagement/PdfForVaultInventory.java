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
import java.util.Date;
import java.util.Properties;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

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

public class PdfForVaultInventory extends HttpServlet{

	private static final long serialVersionUID = 1L;
	static BaseFont baseFont = null;
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	SimpleDateFormat yyyymmddhhiiss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyyhhmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
	DecimalFormat df=new DecimalFormat("##.##");
	protected void doGet(HttpServletRequest request, HttpServletResponse response){
		try{
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			int systemId = loginInfo.getSystemId();
            int clientId = loginInfo.getCustomerId();
            String jsonDenom = session.getAttribute("jsonDenom").toString();
            String jsonSb = session.getAttribute("jsonSb").toString();
            String jsonChq = session.getAttribute("jsonChq").toString();
            String jsonJw = session.getAttribute("jsonJw").toString();
            String jsonFx = session.getAttribute("jsonFx").toString();
            String cvsCustId = request.getParameter("cvsCustId");
            ServletOutputStream servletOutputStream = response.getOutputStream();
            Properties properties = ApplicationListener.prop;
            String billpath=  properties.getProperty("Builtypath");
            refreshdir(billpath);
            String pdfFileName="VaultInventoryReport";
            String fontPath = properties.getProperty("FontPathForMaplePDF");
            baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
            String bill = billpath+ pdfFileName + ".pdf";
			FileOutputStream fileOut = new FileOutputStream(bill);
			Document document = new Document(PageSize.A4.rotate(),40,40,30,30);
			@SuppressWarnings("unused")
			PdfWriter writer = PdfWriter.getInstance(document,fileOut);
			document.open();
			String custName = getCustName(systemId,clientId,cvsCustId);
			generatePdf(document,bill,jsonDenom,jsonSb,jsonChq,jsonJw,jsonFx,systemId,clientId,custName);
			printBill(servletOutputStream, response, bill, pdfFileName);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	private String getCustName(int systemId, int clientId, String cvsCustId) {
		String custName = "";
		PreparedStatement pstmt = null;
		Connection con = null;
		ResultSet rs = null;
		try{
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(CashVanManagementStatements.GET_CUSTOMER_NAMES.replace("#", cvsCustId));
			pstmt.setInt(1, systemId);
			pstmt.setInt(2, clientId);
			rs = pstmt.executeQuery();
			if(rs.next()){
				custName = rs.getString("customerName");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return custName;
	}
	private void generatePdf(Document document,String bill,String jsonDenom,String jsonSb,String jsonChq,String jsonJw,String jsonFx,int systemId,int clientId,String custName) {
		try{
			JSONArray js1 = null;
			if(jsonDenom != null){
				String st = "["+jsonDenom+"]";
				try{
					js1 = new JSONArray(st.toString());
				}catch(JSONException e1){
					e1.printStackTrace();
				}
			}
			PdfPTable custNameTable = createCustNameTable(custName);
			document.add(custNameTable);
			PdfPTable emptyTable = createEmptyTable();
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			
			PdfPTable denominationTable = createDenominationTable(js1);
			document.add(denominationTable);
			
			document.add(emptyTable);
			document.add(emptyTable);
			document.add(emptyTable);
			
			JSONArray js2 = null;
			if(jsonSb != null){
				String st = "["+jsonSb+"]";
				try{
					js2 = new JSONArray(st.toString());
				}catch(JSONException e1){
					e1.printStackTrace();
				}
			}
			if(!jsonSb.equals("empty")){
				PdfPTable sealBagTable = selaBagTable(js2);
				document.add(sealBagTable);
				
				document.add(emptyTable);
				document.add(emptyTable);
				document.add(emptyTable);
			}
			JSONArray js3 = null;
			if(jsonChq != null){
				String st = "["+jsonChq+"]";
				try{
					js3 = new JSONArray(st.toString());
				}catch(JSONException e1){
					e1.printStackTrace();
				}
			}
			if(!jsonChq.equals("empty")){
				PdfPTable ChequeTable = chequeTable(js3);
				document.add(ChequeTable);
				
				document.add(emptyTable);
				document.add(emptyTable);
				document.add(emptyTable);
			}
			JSONArray js4 = null;
			if(jsonJw != null){
				String st = "["+jsonJw+"]";
				try{
					js4 = new JSONArray(st.toString());
				}catch(JSONException e1){
					e1.printStackTrace();
				}
			}
			if(!jsonJw.equals("empty")){
				PdfPTable jewelleryTable = jwewlleryTable(js4);
				document.add(jewelleryTable);
				
				document.add(emptyTable);
				document.add(emptyTable);
				document.add(emptyTable);
			}
			JSONArray js5 = null;
			if(jsonFx != null){
				String st = "["+jsonFx+"]";
				try{
					js5 = new JSONArray(st.toString());
				}catch(JSONException e1){
					e1.printStackTrace();
				}
			}
			if(!jsonFx.equals("empty")){
				PdfPTable foreXTable = foreXTable(js5,jsonFx);
				document.add(foreXTable);
			}
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
	private PdfPTable foreXTable(JSONArray js,String json) {
		float[] widths = {33,34,33};
		PdfPTable mainTable = new PdfPTable(3);
		try{
			mainTable.setWidthPercentage(100.0f);
			mainTable.setWidths(widths);
			
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			for(int k = 0; k < 3; k++){
				myPhrase=new Phrase("Foreign Currency - Amount - Code",new Font(baseFont, 9, Font.BOLD));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
			}
			if(json.contains("empty")){
				myPhrase=new Phrase("",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase("",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase("",new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
			}else{
				for(int i = 0; i < js.length(); i++){
					JSONObject obj = js.getJSONObject(i);
					myPhrase=new Phrase(obj.getString("ForexAmount1"),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					mainTable.addCell(c);
					
					myPhrase=new Phrase(obj.getString("ForexAmount2"),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					mainTable.addCell(c);
					
					myPhrase=new Phrase(obj.getString("ForexAmount3"),new Font(baseFont, 7, Font.NORMAL));
					c = new PdfPCell(myPhrase);
					c.setBorder(Rectangle.NO_BORDER);
					c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
					mainTable.addCell(c);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return mainTable;
	}
	private PdfPTable jwewlleryTable(JSONArray js) {
		float[] widths = {33,34,33};
		PdfPTable mainTable = new PdfPTable(3);
		try{
			mainTable.setWidthPercentage(100.0f);
			mainTable.setWidths(widths);
			
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			for(int k = 0; k < 3; k++){
				myPhrase=new Phrase("Jewellery Ref No - Amount",new Font(baseFont, 9, Font.BOLD));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
			}
			for(int i = 0; i < js.length(); i++){
				JSONObject obj = js.getJSONObject(i);
				myPhrase=new Phrase(obj.getString("JewelleryAmount1"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(obj.getString("JewelleryAmount2"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(obj.getString("JewelleryAmount3"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return mainTable;
	}
	private PdfPTable chequeTable(JSONArray js) {
		float[] widths = {33,34,33};
		PdfPTable mainTable = new PdfPTable(3);
		try{
			mainTable.setWidthPercentage(100.0f);
			mainTable.setWidths(widths);
			
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			for(int k = 0; k < 3; k++){
				myPhrase=new Phrase("Check No - Amount",new Font(baseFont, 9, Font.BOLD));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
			}
			for(int i = 0; i < js.length(); i++){
				JSONObject obj = js.getJSONObject(i);
				myPhrase=new Phrase(obj.getString("CheckAmount1"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(obj.getString("CheckAmount2"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(obj.getString("CheckAmount3"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return mainTable;
	}
	private PdfPTable selaBagTable(JSONArray js) {
		float[] widths = {33,34,33};
		PdfPTable mainTable = new PdfPTable(3);
		try{
			mainTable.setWidthPercentage(100.0f);
			mainTable.setWidths(widths);
			
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			for(int k = 0; k < 3; k++){
				myPhrase=new Phrase("Seal Bag - Amount - Remarks",new Font(baseFont, 9, Font.BOLD));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
			}
			for(int i = 0; i < js.length(); i++){
				JSONObject obj = js.getJSONObject(i);
				myPhrase=new Phrase(obj.getString("SealBagAmount1"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(obj.getString("SealBagAmount2"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(obj.getString("SealBagAmount3"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
			}
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
	
	private PdfPTable createDenominationTable(JSONArray js){
		float[] widths = {10,10,10,10,10,10,10,10,10,10};
		PdfPTable mainTable = new PdfPTable(10);
		try{
			mainTable.setWidthPercentage(100.0f);
			mainTable.setWidths(widths);
			
			Phrase myPhrase = null;
			PdfPCell c = null;
			
			myPhrase=new Phrase("Denominations",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Good No. of Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Bad No. of Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Soiled No. of Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Counterfeit No. of Notes",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Value",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			
			myPhrase=new Phrase("Total Amount",new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
			mainTable.addCell(c);
			for(int i=0; i<js.length(); i++){
				JSONObject obj = js.getJSONObject(i);
				
				myPhrase=new Phrase(obj.getString("DenominationDataIndex"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(obj.getString("GoodNoOfNotesDataIndex"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);

				myPhrase=new Phrase(valueWithCommas1(obj.getString("GoodValueDataIndex")),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
			
				myPhrase=new Phrase(obj.getString("BadNoOfNotesDataIndex"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(valueWithCommas1(obj.getString("BadValueDataIndex")),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(obj.getString("SoiledNoOfNotesDataIndex"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				c.setBorder(Rectangle.NO_BORDER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(valueWithCommas1(obj.getString("SoiledValueDataIndex")),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(obj.getString("CounterfeitNoOfNotesDataIndex"),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_CENTER);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(valueWithCommas1(obj.getString("CounterfeitValueDataIndex")),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				mainTable.addCell(c);
				
				myPhrase=new Phrase(valueWithCommas1(obj.getString("TotalAmountDataIndex")),new Font(baseFont, 7, Font.NORMAL));
				c = new PdfPCell(myPhrase);
				c.setBorder(Rectangle.NO_BORDER);
				c.setHorizontalAlignment(Rectangle.ALIGN_RIGHT);
				mainTable.addCell(c);
			}	
		}catch(Exception e){
			e.printStackTrace();
		}
		return mainTable;
	}

	private PdfPTable createCustNameTable(String custName) {
		float[] widths = {50,50};
		PdfPTable t = new PdfPTable(2);
		try {
			t.setWidthPercentage(100.0f);
			t.setWidths(widths);
			Phrase myPhrase = null;
			PdfPCell c = null;
			myPhrase=new Phrase("Customer Name : "+custName,new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
			t.addCell(c);
			myPhrase=new Phrase("Date : "+ddmmyyyyhhmmss.format(new Date()),new Font(baseFont, 9, Font.BOLD));
			c = new PdfPCell(myPhrase);
			c.setBorder(Rectangle.NO_BORDER);
			c.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
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
	//To create new directory if not existance 
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
}
