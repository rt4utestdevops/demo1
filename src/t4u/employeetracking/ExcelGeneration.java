package t4u.employeetracking;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import jxl.write.DateFormat;
import jxl.write.Label;
import jxl.write.NumberFormat;
import jxl.write.NumberFormats;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

public class ExcelGeneration {
	File outFile;
	String dateStr;
	String enddate;
	String Typebooking;
	String ClientName;
	int rowNo;
	int cellStart = 0;
	int cellEnd;
	int mid;
	int quarter;
	int noOfLinesPerSheet;
	int pmh;
	File imageFile;
	boolean pngCreated;
	
	int cc = 0;
	int st = 0;
    ArrayList<ArrayList> dataHeaderList = new ArrayList<ArrayList>();
    HashMap<String,ArrayList<ArrayList>> dataMap = new HashMap<String,ArrayList<ArrayList>>();
    
    /*.................................formating elements...........................................*/
	BorderLineStyle lineStyleTHICK = BorderLineStyle.THICK;
	
	Colour GROUP_HEADER_ROW_BKG = Colour.GRAY_50;
	Colour GROUP_SUMMARY_ROW_BKG = Colour.GRAY_25;
	Colour BLANK_ROW_BKG = Colour.LIGHT_ORANGE;
	Colour TITLE_BKG = Colour.LIGHT_ORANGE;
	Colour HEADER_BKG = Colour.ICE_BLUE;
	
	WritableFont titleWF = new WritableFont(WritableFont.ARIAL,WritableFont.DEFAULT_POINT_SIZE, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE, Colour.DARK_BLUE2);
	WritableFont summaryWF = new WritableFont(WritableFont.ARIAL,8, WritableFont.BOLD);
	WritableFont headerWF = new WritableFont(WritableFont.ARIAL,9, WritableFont.BOLD);
	WritableFont dataWF = new WritableFont(WritableFont.ARIAL,8, WritableFont.BOLD);
	
	WritableCellFormat intFormat = new WritableCellFormat(dataWF,NumberFormats.INTEGER);
	WritableCellFormat intCell = new WritableCellFormat(intFormat);
	
	
	WritableCellFormat floatFormat = new WritableCellFormat(dataWF,NumberFormats.FLOAT);
	WritableCellFormat floatCell = new WritableCellFormat(floatFormat);
	
	NumberFormat dp2 = new NumberFormat("0.00");
    WritableCellFormat dp2cell = new WritableCellFormat(dataWF,dp2);
    
    DateFormat dateFormat = new DateFormat ("dd/MM/yyyy HH:mm:ss"); 
    WritableCellFormat dateCell = new WritableCellFormat (dataWF,dateFormat); 
    
    DateFormat shortDateFormat = new DateFormat ("dd/MM/yyyy"); 
    WritableCellFormat shortDateCell = new WritableCellFormat (dataWF,shortDateFormat); 
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
    SimpleDateFormat shortSdf2 = new SimpleDateFormat("dd/MM/yyyy");
	
	public ExcelGeneration(HashMap<String,ArrayList<ArrayList>> dataMap,String dateStr,String enddate,String Typebooking,File outFile){
    	this.dataMap = dataMap;
    	this.outFile=outFile;
    	this.dateStr=dateStr;
    	this.enddate=enddate;
    	this.Typebooking=Typebooking;
    	//this.ClientName=ClientName;
    	
    	this.dataHeaderList=dataMap.get("headerlist");
		dataMap.remove("headerlist");
		this.cellEnd=dataHeaderList.get(0).size();
		this.mid=(cellEnd+cellStart) /2;
		this.quarter=(cellEnd+cellStart) /3;
		this.pmh=quarter*2;
		
		Set keys = dataMap.keySet();
		createExcel();
    	
    }
	
	/*.............................createExcel main..............................................*/
	public void createExcel(){
		try{
			WritableWorkbook workbook = Workbook.createWorkbook(outFile);
			int dataSize = dataMap.size();
			
			int sheetNo = 0;
			for(int i = 0; i < dataSize; i ++){
				int startLineNo = i;
				int endLineNo = (i+noOfLinesPerSheet)>dataSize?dataSize:(i+noOfLinesPerSheet);
				if(startLineNo==0){
					
					//rowNo = 0;
					String sheetName = "Sheet - "+(++st);
					WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
					writeReportTitlePeriod(sheet);
					writeDataHeader(sheet);
					writeData(sheet,startLineNo,endLineNo);
					sheetNo++;
				}
				else if((endLineNo - startLineNo) < (noOfLinesPerSheet - 1)){
					
					//rowNo++;
					String sheetName = "Sheet - "+(++st);
					WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
					writeReportTitlePeriod(sheet);
					writeDataHeader(sheet);
					writeData(sheet,startLineNo,endLineNo);
					sheetNo++;
				}
				else{
					
					//rowNo++;
					String sheetName = "Sheet - "+(++st);
					WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
					writeReportTitlePeriod(sheet);
					writeDataHeader(sheet);
					writeData(sheet,startLineNo,endLineNo);
					sheetNo++;
				}
			}
			
			workbook.write();
		    workbook.close();
	
		}catch(Exception e){
			e.printStackTrace();
		}
		}
/*.............................writeDataHeader..........................................................*/
	public void writeDataHeader(WritableSheet sheet){
		try{
			
		    WritableCellFormat cf = new WritableCellFormat(headerWF);
		    cf.setBackground(HEADER_BKG);
		    cf.setWrap(false);
		    int row = rowNo++;
		    int col = cellStart;
		    int size =  dataHeaderList.size();
		    for(int i = 0; i < dataHeaderList.get(0).size(); i ++){
		    	String lbStr = (String) dataHeaderList.get(0).get(i);
		    	Label label = new Label(col,row,lbStr,cf);
			    sheet.addCell(label);
			    col++;
		    }
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	/*.................................report title .....................................*/
	public void writeReportTitlePeriod(WritableSheet sheet){
		try{
		    WritableCellFormat cf = new WritableCellFormat(titleWF);
		    cf.setBackground(TITLE_BKG);
		    cf.setAlignment(Alignment.LEFT);
		    cf.setWrap(false);
		    
		    int row = rowNo++;
	    	
		    	String heading="ContainerBookingReport";
		    	String bookingtype="Booking Type:"+Typebooking;
		    	String startDate1="Start Date:"+dateStr;
		    	String endDate="End Date:"+enddate;
		    	Label label1 = new Label(cellStart,row,heading,cf);
		    	sheet.addCell(label1);
		    	sheet.mergeCells(cellStart, row, mid, row); 
		    	Label label2 = new Label(mid+1,row,bookingtype,cf);
		    	sheet.addCell(label2);
		    	sheet.mergeCells(mid+1, row, cellEnd, row); 
		    	row = rowNo++;
		    	if(!Typebooking.trim().equalsIgnoreCase("Open Booking"))
		    	{
		    		Label label3 = new Label(cellStart,row,startDate1,cf);
			    	sheet.addCell(label3);
			    	sheet.mergeCells(cellStart, row, mid, row);
			    	Label label4 = new Label(mid+1,row,endDate,cf);
			    	sheet.addCell(label4);
		    	}
		    	sheet.mergeCells(mid+1, row, cellEnd, row);
		    	row = rowNo;
		    	
		    	
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
	public void writeData(WritableSheet sheet,int startLineNo,int endLineNo){
		try{
		   createDataRow(dataMap,sheet);
	}
		catch(Exception e){
			e.printStackTrace();
		}
  }

public void createDataRow(HashMap<String,ArrayList<ArrayList>> hashmap,WritableSheet sheet){
	try{
	    WritableCellFormat cf = new WritableCellFormat(dataWF);
	    cf.setWrap(false);
	    int row = rowNo++;
	    int size = hashmap.size();
	    Set keys = hashmap.keySet();
	    Iterator<String> itr = keys.iterator();
 	    int col = cellStart;
	    boolean rowSplited = false;
	    while(itr.hasNext()){
	    	String dataStr = null;
	    	ArrayList<ArrayList> list = hashmap.get(itr.next());
	    	
	    	for(int j = 0; j <list.size(); j ++){
	    		
	    	for(int i = 0; i <list.get(j).size(); i ++){
	    	String kk = "";
	    	if((list.get(j).get(i) != null && !(list.get(j).get(i)).equals(""))){
		    kk = list.get(j).get(i).toString();//System.out.println("kk"+kk);
		    }
	    	else{
	    	}
	    	sheet.addCell(new Label(col, row,kk,cf));
	    	col++;
	    	
	    	}
	    	col = cellStart;
	    	row++;	    	
	        }
	  
	  }
	}catch(Exception e){
		e.printStackTrace();
	}
 }

}
