
package t4u.cashvanmanagement;

import java.awt.Color;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;

import java.io.IOException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jfree.ui.Size2D;

import com.itextpdf.text.Element;
import com.itextpdf.text.pdf.BarcodeQRCode;
import com.lowagie.text.BadElementException;
import com.lowagie.text.Chunk;
import com.lowagie.text.Document;
import com.lowagie.text.DocumentException;
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


import t4u.common.ApplicationListener;
import t4u.functions.CashVanManagementFunctions;
import t4u.functions.CommonFunctions;


public class QRCodeGenerationForPdf extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	static BaseFont baseFont = null;
	CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
	
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    	
   		 				
   		try
		      {   
				
				String selectedassets = request.getParameter("selectedassets");
				String custId = request.getParameter("clientId");
				String sysId = request.getParameter("systemId");
				ServletOutputStream servletOutputStream = response.getOutputStream();
				Properties properties = ApplicationListener.prop;
				String billpath=  properties.getProperty("Builtypath");
				refreshdir(billpath);
				String pdfFileName="QRCodeGenerations";
				String fontPath = properties.getProperty("FontPathForMaplePDF");
				baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
				String bill = billpath+ pdfFileName + ".pdf";

				FileOutputStream fileOut = new FileOutputStream(bill);
				Document document = new Document(PageSize.A4.rotate(), 40, 40, 40, 30);
				PdfWriter writer = PdfWriter.getInstance(document,fileOut);
				document.open();
				//PdfContentByte canvas = writer.getDirectContent();
				
					generateTripSheet(document,bill,selectedassets,custId,sysId);
					document.close();
					printBill(servletOutputStream, response, bill, pdfFileName);
				 
	
	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	
 }

    
    private void generateTripSheet(Document document, String bill, String selectedassets,String custId,String sysId) {
			try {
				
				int count =0;
				ArrayList<ArrayList<String>> selectedassetsFromDb = new ArrayList<ArrayList<String>>();
				selectedassetsFromDb =cashVanfunc.getAssetDetails(Integer.parseInt(sysId),Integer.parseInt(custId),selectedassets);
				PdfPTable signDetailsTable = null;
				if(selectedassetsFromDb.size()>0){
				count =selectedassetsFromDb.size();
				}

		    	if(count>0){
		    	int remain = count%5;
		    	if(remain>0){
		    	for(int i=0; i<5-remain;i++){
		    		ArrayList<String> innerlist = new ArrayList<String>();
		    		innerlist.add("");
		    		innerlist.add("");
		    		innerlist.add("");
		    		selectedassetsFromDb.add(innerlist);
		    	}
		    	}
		    	}
				signDetailsTable=createSignDetailsTable(selectedassetsFromDb,document);
				document.add(signDetailsTable);

			
				
			} catch (Exception e) {
				e.printStackTrace();
			}	
	}
	
    private PdfPTable createSignDetailsTable(ArrayList<ArrayList<String>> selectedassetsFromDb,Document document) {
    
		PdfPTable SignDetailsTable=new PdfPTable(5);	
		float[] widthSignDetails = {20,20,20,20,20};
    
		try {
			SignDetailsTable.setWidthPercentage(80.0f);
			SignDetailsTable.setWidths(widthSignDetails);
		
			for( int i=0; i<selectedassetsFromDb.size();i++){
	    		ArrayList<String> outerlist = new ArrayList<String>();
                outerlist =selectedassetsFromDb.get(i);
                String assetNumber= "";
    			String assetName= "";
    			String QRdata = ""; 
    			Image finalQRImage = null;
				assetNumber= outerlist.get(0);
				assetName= outerlist.get(1);
				QRdata = outerlist.get(2); 
				if(!QRdata.equals("") && QRdata != null){
			    finalQRImage=getQrCode(QRdata, 25, 25);				
				finalQRImage.scaleToFit(100, 100);		
				}else{
					String path = getServletContext().getRealPath("/")+"Main/modules/cashVan/images/Empty.png";
					finalQRImage=Image.getInstance(path);			
					finalQRImage.scaleToFit(100, 100);
				}
			    Phrase SignDetailsMyPhras=new Phrase(assetName+"\n"+assetNumber+"\n\n",new Font(baseFont, 13, Font.BOLD));		   			
				SignDetailsMyPhras.add(new Chunk(finalQRImage, 0, 0));			   
			    PdfPCell SignDetailsCel = new PdfPCell(SignDetailsMyPhras);
				SignDetailsCel.enableBorderSide(Rectangle.LEFT);
				SignDetailsCel.enableBorderSide(Rectangle.BOTTOM);
				SignDetailsCel.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
				SignDetailsTable.addCell(SignDetailsCel);
			
				
			}


		} catch (Exception e) {
			e.printStackTrace();
	  }
		return SignDetailsTable;
	}
	private Image getQrCode(String text,int width,int height){
		Image finalQRImage = null;
		try {
			BarcodeQRCode qrcode = new BarcodeQRCode(text.trim(), width, width, null);
			java.awt.Image qr_awt_image = qrcode.createAwtImage(Color.BLACK,Color.WHITE);
			//java.awt.Image  qrImage = qrcode.createAwtImage(Color.WHITE,new Color(0, 0, 0, 0));
			finalQRImage = Image.getInstance(qr_awt_image, null);
		} catch (BadElementException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return finalQRImage;
		
	}
	private void printBill(ServletOutputStream servletOutputStream,
			HttpServletResponse resp, String bill, String pdfFileName) {
		try
		{
			resp.setContentType("application/pdf");
			resp.setHeader("Content-disposition","attachment;filename="+pdfFileName+".pdf");
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
			e.printStackTrace();
		}
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
    
    
    
			
  }

