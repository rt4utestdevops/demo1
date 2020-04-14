package t4u.export;


import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Properties;

import t4u.beans.LanguageWordsBean;
import t4u.common.ApplicationListener;


import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Document;

import com.itextpdf.text.Element;
import com.itextpdf.text.ExceptionConverter;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;


import com.itextpdf.text.PageSize;

import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;


import com.itextpdf.text.pdf.PdfAction;
import com.itextpdf.text.pdf.PdfContentByte;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfPageEventHelper;

import com.itextpdf.text.pdf.PdfTemplate;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.text.pdf.draw.LineSeparator;


/**
 * creating class ExportPDFCreator and extending it to PdfPageEventHelper for getting page no.
 *
 */
public class ExportPDFCreatorForDriverPerformanceReport extends PdfPageEventHelper {

	protected static PdfPTable header;
	protected static PdfPTable footer;
	ByteArrayOutputStream baos = new ByteArrayOutputStream();
	PdfTemplate total;
	private static Font redFont = new Font(Font.FontFamily.TIMES_ROMAN, 12,
			Font.NORMAL, BaseColor.RED);
	protected BaseFont helv;

	/*
	 * ............................inputs..........................................
	 * 
	 */
	ArrayList<String> startTitleList = new ArrayList<String>();
	ArrayList<String> summaryHeaderList = new ArrayList<String>();
	ArrayList<String> dataHeaderList = new ArrayList<String>();
	ArrayList<Integer> colSpanList = new ArrayList<Integer>();
	ArrayList<String> dataTypeList = new ArrayList<String>();
	ArrayList<ArrayList> dataList = new ArrayList<ArrayList>();
	ArrayList<String> summaryFooterList = new ArrayList<String>();
	ArrayList<String> endTitleList = new ArrayList<String>();

	File outFile;
	int rowNo;
	int cellStart;
	int cellEnd;
	int mid;
	int noOfLinesPerSheet;
	String language;
	PdfPTable pt;
	public ExportPDFCreatorForDriverPerformanceReport() {
	}

	public ExportPDFCreatorForDriverPerformanceReport(ArrayList<String> startTitleList,
		ArrayList<String> summaryHeaderList,
		ArrayList<String> dataHeaderList, ArrayList<Integer> colSpanList,
		ArrayList<String> dataTypeList, ArrayList<ArrayList> dataList,
		ArrayList<String> summaryFooterList,
		ArrayList<String> endTitleList, int cellStart,
		 File outFile, String language,PdfPTable pt) {
		this.startTitleList = startTitleList;
		this.summaryHeaderList = summaryHeaderList;
		this.dataHeaderList = dataHeaderList;
		this.colSpanList = colSpanList;
		this.dataList = dataList;
		this.summaryFooterList = summaryFooterList;
		this.endTitleList = endTitleList;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.dataTypeList = dataTypeList;
		
		this.language = language;
		this.pt=pt;

	}
	
	
	String systemid = "0";
	String userId = "0";
	String clientId = "0";
	String serviceProvider = "";
	String reportpath = "";
	
	 /**
     * first overridden method of class PdfPageEventHelper
     * this method is used to count total no of page
     */
    public void onOpenDocument(PdfWriter writer, Document document) {
            total = writer.getDirectContent().createTemplate(100, 100);
            total.setBoundingBox(new Rectangle(-20, -20, 100, 100));
            try {
                helv = BaseFont.createFont(BaseFont.HELVETICA, BaseFont.WINANSI,
                                BaseFont.NOT_EMBEDDED);
        } catch (Exception e) {
                throw new ExceptionConverter(e);
        }
            
    }

    /**
     * second overridden method of class PdfPageEventHelper
     * this method is used to set the tag at right corner of PDF
     */
    public void onEndPage(PdfWriter writer, Document document) {
            PdfContentByte cb = writer.getDirectContent();
            cb.saveState();
            String text = "Page " + writer.getPageNumber() + " of ";
            float textBase = document.bottom() - 20;
            float textSize = helv.getWidthPoint(text, 12);
            cb.beginText();
            cb.setFontAndSize(helv, 12);
         // for odd numbers, show the footer at the right
            if ((writer.getPageNumber() % 2) == 1) {
            	 float adjust = helv.getWidthPoint("0", 12);
                 cb.setTextMatrix(document.right() - textSize - adjust, textBase);
                 cb.showText(text);
                 cb.endText();
                 cb.addTemplate(total, document.right() - adjust, textBase);
            }
            // for even numbers, show the footer at the right
            else {
                    float adjust = helv.getWidthPoint("0", 12);
                    cb.setTextMatrix(document.right() - textSize - adjust, textBase);
                    cb.showText(text);
                    cb.endText();
                    cb.addTemplate(total, document.right() - adjust, textBase);
            }
            cb.restoreState();
    }

	/***
	 * ** function for creating PDF
	 *function definition for Exporting PDF
	 * *****/
	public void createPDF() {
		try {
			
			Properties properties = null;
			try 
			{
				properties = ApplicationListener.prop;
			} 
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			//declare document for starting creation of PDF
			Document document = new Document(PageSize.A4.rotate());
			String encoding = properties.getProperty("Encoding");
			//String encoding = "Identity-H";
			//getting fontpath directory
            String fontpath=properties.getProperty("FontPath");
           
			Font fontNormal = FontFactory.getFont(fontpath+"ARIALUNI.TTF", encoding, BaseFont.EMBEDDED, 8, Font.BOLD, BaseColor.BLACK);
	        Font dateFont = new Font(Font.FontFamily.HELVETICA, 9,Font.BOLD, BaseColor.BLACK);
	        Font HeaderFont = new Font(Font.FontFamily.HELVETICA, 11,Font.BOLD, BaseColor.BLACK);
	        
			
            //for selecting language case
			if (language.equals("ar")) {
				// putting header in PDF
				header = new PdfPTable(3);
				header.getDefaultCell().setBorder(0);
				header.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
				header.addCell("");
				header.addCell(new Phrase(new Chunk(startTitleList.get(0)+ "\n",fontNormal).setAction(new PdfAction(PdfAction.FIRSTPAGE))));
				header.setRunDirection(PdfWriter.RUN_DIRECTION_RTL);
				header.addCell("");

				// putting footer in PDF
				footer = new PdfPTable(3);
				footer.getDefaultCell().setBorder(0);
				footer.getDefaultCell().setHorizontalAlignment(Element.ALIGN_RIGHT);
				footer.addCell("");
				footer.addCell(new Phrase(new Chunk(summaryFooterList.get(0)+ "\n",fontNormal)));
				footer.setRunDirection(PdfWriter.RUN_DIRECTION_RTL);
				footer.addCell("");
				footer.getDefaultCell().setBorderWidthTop(1);
				
			} else {
				// putting header in PDF
				header = new PdfPTable(3);
				header.getDefaultCell().setBorder(0);
				header.addCell("");
				header.addCell(new Phrase(new Chunk(startTitleList.get(0))
						.setAction(new PdfAction(PdfAction.FIRSTPAGE))));
				header.addCell("");

				// putting footer in PDF
				footer = new PdfPTable(3);
				footer.getDefaultCell().setBorder(0);
				footer.addCell("");
				footer.addCell(new Phrase(new Chunk(summaryFooterList.get(0)+ "\n",fontNormal)));
				footer.addCell("");
				footer.getDefaultCell().setBorderWidthTop(1);
			}

			
            
			// strat of PDF formatting
			
			PdfWriter pdfWriter = PdfWriter.getInstance(document,new FileOutputStream(outFile));
			pdfWriter.setPageEvent(new ExportPDFCreator());
			Phrase blankphrase = new Phrase(" ");
			HashMap langConverted=ApplicationListener.langConverted;
			LanguageWordsBean lwb=null;
			/*String summaryList;
			lwb=(LanguageWordsBean)langConverted.get("Customer_Selection");
			if(language.equals("ar")){
				summaryList=lwb.getArabicWord();
			}else{
				summaryList=lwb.getEnglishWord();
			}
			lwb=null;
			langConverted=null;
			
*/			String summaryList="Summary List";
			
            //opening of document
			document.open();
			document.add(pt);
			document.add(header);
			document.add(blankphrase);
			PdfPCell c=new PdfPCell(blankphrase);
			c.setBorder(0);
			PdfPCell c1=new PdfPCell(new Phrase(new Chunk(summaryList)+ "\n",dateFont));
			c1.setHorizontalAlignment(Element.ALIGN_CENTER);
			c1.setBackgroundColor(new BaseColor(216,216,216));
			int dataheaderlistsize = dataHeaderList.size();
			// table2 for adding start date and end date
			PdfPTable table2 = new PdfPTable(3);
			if (language.equals("ar")) {
			
				table2.addCell(c);
				table2.addCell(c);
				table2.addCell(c1);
				for (int i = 0; i < summaryHeaderList.size(); i++) {
					table2.addCell(c);
					table2.addCell(c);
					Chunk chunkA = new Chunk(summaryHeaderList.get(i) + "\n",fontNormal);
					PdfPCell cellA = new PdfPCell(new Phrase(chunkA));
					cellA.setHorizontalAlignment(Element.ALIGN_CENTER);
					cellA.setRunDirection(PdfWriter.RUN_DIRECTION_RTL);
					table2.addCell(cellA);
					
				}
		
		}else{
			table2.addCell(c);
			table2.addCell(c);
			table2.addCell(c1);
			for (int i = 0; i < summaryHeaderList.size(); i++) {
				table2.addCell(c);
				table2.addCell(c);
				Chunk chunkA = new Chunk(summaryHeaderList.get(i) + "\n",dateFont);
				PdfPCell cellA = new PdfPCell(new Phrase(chunkA));
				cellA.setHorizontalAlignment(Element.ALIGN_CENTER);
				table2.addCell(cellA);
			}
			}
			
			document.add(table2);
			document.add(blankphrase);
			PdfPTable table = new PdfPTable(dataheaderlistsize);
			PdfPTable table1 = new PdfPTable(dataheaderlistsize);
			BaseColor bs=new BaseColor(255, 255, 255);
			
			
			
			// function for adding header list according to language
		    for (int i = 0; i < dataheaderlistsize; i++) {
			if (language.equals("ar")) {
				Chunk chunkAr = new Chunk(dataHeaderList.get(i) + "\n",fontNormal);
				PdfPCell cellAr = new PdfPCell(new Phrase(chunkAr));
				cellAr.setRunDirection(PdfWriter.RUN_DIRECTION_RTL);
				cellAr.setHorizontalAlignment(Element.ALIGN_CENTER);
				cellAr.setBackgroundColor(BaseColor.LIGHT_GRAY);
				table.addCell(cellAr);
			} else {
				Chunk chunkAr = new Chunk(dataHeaderList.get(i) + "\n",fontNormal);
				PdfPCell cellAr = new PdfPCell(new Phrase(chunkAr));
				cellAr.setHorizontalAlignment(Element.ALIGN_CENTER);
				cellAr.setBackgroundColor(new BaseColor( 250,192,144));
				table.addCell(cellAr);
			}

			}
			// function for adding data in pdf table according to language
			for (int j = 0; j < dataList.size(); j++) {
				//int n=Integer.parseInt(((ArrayList)dataList.get(j)).get(0).toString());
				
				if(Float.parseFloat(((ArrayList)dataList.get(j)).get(3).toString()) == 0){
					bs=new BaseColor(255, 255, 255);
				}
				else if(Float.parseFloat(((ArrayList)dataList.get(j)).get(dataList.get(j).size()-1).toString())<2){
					bs=new BaseColor(70,156,48);
					
				}else if(Float.parseFloat(((ArrayList)dataList.get(j)).get(dataList.get(j).size()-1).toString())>=2 && Float.parseFloat(((ArrayList)dataList.get(j)).get(dataList.get(j).size()-1).toString())<5)
				{ 
					 bs=new BaseColor(249,241,10);
					// bs=new BaseColor(249,241,10);
				}
				else if(Float.parseFloat(((ArrayList)dataList.get(j)).get(dataList.get(j).size()-1).toString())>=5)
				{
					bs=new BaseColor(192,22,22); 
				}
				for (int i = 0; i < dataheaderlistsize; i++) {
					
					if (language.equals("ar")) {
						Chunk chunkAr = new Chunk(((ArrayList) dataList.get(j)).get(i).toString()+ "\n", fontNormal);
						PdfPCell cellAr = new PdfPCell(new Phrase(chunkAr));
						cellAr.setRunDirection(PdfWriter.RUN_DIRECTION_RTL);
						cellAr.setBackgroundColor(bs);
						table1.addCell(cellAr);
					} else {
						Chunk chunkAr = new Chunk(((ArrayList) dataList.get(j)).get(i).toString()+ "\n", fontNormal);
						PdfPCell cellAr = new PdfPCell(new Phrase(chunkAr));
						cellAr.setBackgroundColor(bs);
						table1.addCell(cellAr);
					}
				}

			}
			document.add(table);
			document.add(table1);
			document.add(blankphrase);
			//adding horizontal line before footer
			PdfPTable table3=new PdfPTable(1);
	        PdfPCell cell1=new PdfPCell();
	        cell1.setBorderColorTop(BaseColor.WHITE);
	        cell1.setBorderColorLeft(BaseColor.WHITE);
	        cell1.setBorderColorRight(BaseColor.WHITE);
	        table3.addCell(cell1);
	        document.add(table3);
		      
			document.add(footer);
			document.newPage();
			document.close();

		} catch (Exception e) {
			System.out.println("Exception in ExportPDFCreator" + e);
			e.printStackTrace();
		}

	}

	 /**
     * on close event for setting page no format X of Y
     */
    public void onCloseDocument(PdfWriter writer, Document document) {
            total.beginText();
            total.setFontAndSize(helv, 12);
            total.setTextMatrix(0, 0);
            total.showText(String.valueOf(writer.getPageNumber() - 1));
            total.endText();
    }
	
	

}
