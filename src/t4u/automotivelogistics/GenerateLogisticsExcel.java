package t4u.automotivelogistics;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.logging.Logger;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import jxl.write.DateFormat;
import jxl.write.DateTime;
import jxl.write.Label;
import jxl.write.NumberFormat;
import jxl.write.NumberFormats;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
@SuppressWarnings({"unchecked","static-access"})

/**
 * Generating excel with information 
 */
public class GenerateLogisticsExcel 
{
	SimpleDateFormat date = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");

	public static Logger logger = Logger.getLogger("ExportExcel");
	
	/*............................inputs..................................................*/
	ArrayList<String> startTitleList = new ArrayList<String>();
	ArrayList<String> currentDate = new ArrayList<String>();
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
	
	
	
	/*.................................formating elements...........................................*/
	BorderLineStyle lineStyleTHICK = BorderLineStyle.THICK;
	
	Colour BLANK_ROW_BKG = Colour.LIGHT_ORANGE;
	Colour TITLE_BKG = Colour.LIGHT_ORANGE;
	Colour HEADER_BKG = Colour.ICE_BLUE;
	Colour ROW_BKG = Colour.WHITE;
	
	
	WritableFont titleWF = new WritableFont(WritableFont.ARIAL,WritableFont.DEFAULT_POINT_SIZE, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE, Colour.DARK_BLUE2);
	WritableFont summaryWF = new WritableFont(WritableFont.ARIAL,8, WritableFont.BOLD);
	WritableFont headerWF = new WritableFont(WritableFont.ARIAL,9, WritableFont.BOLD);
	WritableFont dataWF = new WritableFont(WritableFont.ARIAL,8, WritableFont.BOLD);
	
	WritableCellFormat intFormat = new WritableCellFormat(dataWF,NumberFormats.INTEGER);
	WritableCellFormat intCell = new WritableCellFormat(intFormat);
	
	
	WritableCellFormat floatFormat = new WritableCellFormat(dataWF,NumberFormats.FLOAT);
	WritableCellFormat floatCell = new WritableCellFormat(floatFormat);
	
	NumberFormat dp2 = new NumberFormat("#.##");
    WritableCellFormat dp2cell = new WritableCellFormat(dataWF,dp2);

	NumberFormats dp3 = new NumberFormats();
	WritableCellFormat twoDigitsAfterPt = new WritableCellFormat(dataWF,dp3.FORMAT3);
    
    DateFormat dateFormat = new DateFormat ("dd/MM/yyyy HH:mm:ss"); 
    WritableCellFormat dateCell = new WritableCellFormat (dataWF,dateFormat); 
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	
    Colour COLOR1 = Colour.ICE_BLUE;
	Colour COLOR2 =Colour.CORAL;
	Colour COLOR3 =Colour.GRAY_50;
	Colour COLOR4 =Colour.YELLOW;
	Colour COLOR5 =Colour.ORANGE;
	Colour COLOR6 =Colour.RED;
	/**
	 * Generating excel with information 
	 */
	public GenerateLogisticsExcel(ArrayList<String> startTitleList,ArrayList<String> currentDate,ArrayList<String> dataHeaderList,ArrayList<Integer> colSpanList,ArrayList<String> dataTypeList,ArrayList<ArrayList> reportdataList,ArrayList<String> summaryFooterList,int cellStart,int noOfLinesPerSheet,File outFile)
	{
		this.startTitleList = startTitleList;
		this.currentDate = currentDate;
		this.dataHeaderList = dataHeaderList;
		this.colSpanList = colSpanList;
		this.dataList = reportdataList;
		this.summaryFooterList = summaryFooterList;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.dataTypeList = dataTypeList;
		cellEnd = getCellEnd();
		mid = (cellStart+cellEnd) / 2;
		this.noOfLinesPerSheet = noOfLinesPerSheet;
		
	}
	
	/*.............................createExcel main..............................................*/
	public void createExcel()
	{
		try
		{
			WritableWorkbook workbook = Workbook.createWorkbook(outFile);
			int dataSize = dataList.size();
			int sheetNo = 0;
			for(int i = 0; i < dataSize; i+=noOfLinesPerSheet)
			{
				int startLineNo = i;
				int endLineNo = (i+noOfLinesPerSheet)>dataSize?dataSize:(i+noOfLinesPerSheet);
				if(startLineNo==0)
				{
					rowNo = 0;
					String sheetName = (startLineNo+1) + " - " + endLineNo;
					WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
					writeStartTitle(sheet);
					writeStartEndDate(sheet,currentDate);
					writeSummaryHeader(sheet);
					writeDataHeader(sheet);
					writeData(sheet,startLineNo,endLineNo);
					addBlankRow(sheet);
					
					/* if no of row < no of line per sheet then print the footer in the same page */
					if(dataSize < noOfLinesPerSheet)
					{
						writeSummaryFooter(sheet);
						writeEndTitle(sheet);
					}
					
					sheetNo++;
				}
				else if((endLineNo - startLineNo) < (noOfLinesPerSheet - 1))
				{
					rowNo = 0;
					String sheetName = (startLineNo+1) + " - " + endLineNo;
					WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
					writeDataHeader(sheet);
					writeData(sheet,startLineNo,endLineNo);
					addBlankRow(sheet);
					writeSummaryFooter(sheet);
					writeEndTitle(sheet);
					sheetNo++;
				}
				else
				{
					rowNo=0;
					String sheetName = (startLineNo+1) + " - " + endLineNo;
					WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
					writeDataHeader(sheet);
					writeData(sheet,startLineNo,endLineNo);
					addBlankRow(sheet);
					sheetNo++;
				}
			}
			workbook.write();
		    workbook.close();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	
	/*......................................................................*/
	public void writeStartTitle(WritableSheet sheet)
	{
		try
		{
		    WritableCellFormat cf = new WritableCellFormat(titleWF);
		    cf.setBackground(TITLE_BKG);
		    cf.setAlignment(Alignment.CENTRE);
		    cf.setWrap(false);
		    for(int i = 0; i < startTitleList.size(); i ++)
		    {
		    	String lbStr = startTitleList.get(i);
		    	int row = rowNo++;
		    	Label label = new Label(cellStart,row,lbStr,cf); //(cell,row,data,cellformat)
			    sheet.addCell(label);
			    sheet.mergeCells(cellStart, row, cellEnd, row); //(col1, row1, col2, row2)
		    }
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public void writeStartEndDate(WritableSheet sheet,ArrayList<String> currentDate)
	{
		try
		{
		  
		    WritableCellFormat cf1 = new WritableCellFormat(titleWF);
		    cf1.setBackground(ROW_BKG);
		    cf1.setAlignment(Alignment.LEFT);
		    cf1.setWrap(false);
		   
		    WritableCellFormat cf2 = new WritableCellFormat(titleWF);
		    cf2.setBackground(ROW_BKG);
		    cf2.setAlignment(Alignment.RIGHT);
		    cf2.setWrap(false);

		    for(int i = 0; i < currentDate.size(); i+=2)
	    	{ 
		    	String lbStr1 = "From Date : "+currentDate.get(i);
		    	String lbStr2 ="";
		    	if(i + 1 < currentDate.size())
		    	{
		    		lbStr2 = "End Date : "+currentDate.get(i+1);
		    	}
	           int row = rowNo++;
		    	
		    	Label label = new Label(cellStart,row,lbStr1,cf1); 
			    sheet.addCell(label);
			    sheet.mergeCells(cellStart, row, mid, row); 
			    
			   
			    label = new Label(mid+1,row,lbStr2,cf2); 
			    sheet.addCell(label);
			    sheet.mergeCells(mid+1, row, cellEnd, row); 
		}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	/*..............................................................................*/
	public void writeSummaryHeader(WritableSheet sheet)
	{
		try
		{
		    WritableCellFormat cf1 = new WritableCellFormat(summaryWF);
		    cf1.setAlignment(Alignment.LEFT);
		    cf1.setWrap(false);
		   
		    WritableCellFormat cf2 = new WritableCellFormat(summaryWF);
		    cf2.setAlignment(Alignment.RIGHT);
		    cf2.setWrap(false);
		    
		    String activityReportData = "";
		    if(summaryHeaderList.size()>0)
		    {
		    	activityReportData=summaryHeaderList.get(0);
		    }
		    if(activityReportData.equalsIgnoreCase("activityreportinternationalize"))
		    {
		    	summaryHeaderList.remove(0);
		    	for(int i = 0; i < summaryHeaderList.size(); i+=4)
		    	{
			    	String lbStr1 = summaryHeaderList.get(i);
			    	String lbStr2 = "";
			    	if(i + 1 < summaryHeaderList.size())
			    	{
			    		lbStr2 = summaryHeaderList.get(i+1);
			    	}
			    	
			    	String lbStr3 =  summaryHeaderList.get(i+2);
			    	String lbStr4 =  summaryHeaderList.get(i+3);
			    	
			    	int row = rowNo++;
			    	Label label = new Label(cellStart,row,lbStr1,cf1); 
			    	sheet.addCell(label);
				    sheet.mergeCells(cellStart, row, mid, row); 
				    label = new Label(mid+1,row,lbStr2,cf2); 
				    sheet.addCell(label);
				    sheet.mergeCells(mid+1, row, mid+1, row);
				    label = new Label(mid+2,row,lbStr3,cf2); 
				    sheet.addCell(label);
				    sheet.mergeCells(mid+2, row, mid+2, row);
				    label = new Label(mid+3,row,lbStr4,cf2); 
				    sheet.addCell(label);
				    sheet.mergeCells(mid+3, row, cellEnd, row);
		        }
		   }	
		   else
		   {
		    for(int i = 0; i < summaryHeaderList.size(); i+=2)
		    {
		    	String lbStr1 = summaryHeaderList.get(i);
		    	String lbStr2 = "";
		    	if(i + 1 < summaryHeaderList.size())
		    	{
		    		lbStr2 = summaryHeaderList.get(i+1);
		    	}
		    	
		    	int row = rowNo++;
		    	
		    	Label label = new Label(cellStart,row,lbStr1,cf1); 
			    sheet.addCell(label);
			    sheet.mergeCells(cellStart, row, mid, row); 
			    
			   
			    label = new Label(mid+1,row,lbStr2,cf2); 
			    sheet.addCell(label);
			    sheet.mergeCells(mid+1, row, cellEnd, row); 
		    }
		  }
		    
		}catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	/*.......................................................................................*/
	public void writeDataHeader(WritableSheet sheet)
	{
		try
		{
		    WritableCellFormat cf = new WritableCellFormat(headerWF);
		    cf.setBackground(HEADER_BKG);
		    cf.setWrap(false);
		    int row = rowNo++;
		    int col = cellStart;
		    int size =  dataHeaderList.size();
		    for(int i = 0; i < size; i ++)
		    {
		    	String lbStr = dataHeaderList.get(i);
		    	int colSpanVal = colSpanList.get(i);
		    	Label label = new Label(col,row,lbStr,cf); //(cell,row,data,cellformat)
			    sheet.addCell(label);
			    if(colSpanVal > 1)
			    {
			    	int extraCell = colSpanVal - 1;
			    	sheet.mergeCells(col, row, col+extraCell, row);
			    	col = col + extraCell;
			    }
			    col++;
		    }
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	/*.......................................................................................*/
	public void writeData(WritableSheet sheet,int startLineNo,int endLineNo)
	{
		try
		{
		    for(int i = startLineNo; i < endLineNo; i ++)
		    {
		    	ArrayList rowList = (ArrayList) dataList.get(i);
		    	createDataRow(rowList,sheet);
		    	
		    }
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	/*.......................................................................................*/
	public void createDataRow(ArrayList rowList,WritableSheet sheet)
	{
		try
		{
		    WritableCellFormat cf = new WritableCellFormat(dataWF);
		    cf.setWrap(false);
		    
		    WritableCellFormat firstCell = new WritableCellFormat(intFormat);
		    firstCell.setWrap(false);
		    firstCell.setAlignment(Alignment.LEFT);
		    
		    WritableCellFormat color1 = new WritableCellFormat(floatFormat);
		    color1.setWrap(false);
		    color1.setAlignment(Alignment.LEFT);
		    color1.setBackground(COLOR1);
		    
		    WritableCellFormat color2 = new WritableCellFormat(intFormat);
		    color2.setWrap(false);
		    color2.setAlignment(Alignment.LEFT);
		    color2.setBackground(COLOR2);
		    
		    WritableCellFormat color3 = new WritableCellFormat(dataWF);
		    color3.setWrap(false);
		    color3.setBackground(COLOR3);
		    
		    WritableCellFormat color4 = new WritableCellFormat(dataWF);
		    color4.setWrap(false);
		    color4.setBackground(COLOR4);
		    
		    WritableCellFormat color5 = new WritableCellFormat(dataWF);
		    color5.setWrap(false);
		    color5.setBackground(COLOR5);
		    
		    WritableCellFormat color6 = new WritableCellFormat(dataWF);
		    color6.setWrap(false);
		    color6.setBackground(COLOR6);
		

		    int row = rowNo++;
		    int size = rowList.size();
		    int col = cellStart;
		    for(int i = 0; i < size; i ++)
		    {
		    	String dataStr = rowList.get(i).toString();
		    	String type = dataTypeList.get(i);
		    	if(i == 0 && type.equals("int"))
		    	{
		    		int data = 0;
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			data = Integer.parseInt(dataStr);
		    		}
		    		sheet.addCell(new jxl.write.Number(col,row,data,firstCell));
		    	}
		    	else if(type.equals("number"))
		    	{
		    		Double data = 0.00;
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			data = Double.parseDouble(dataStr);
		    			
		    		}
		    		sheet.addCell(new jxl.write.Number(col,row,data,twoDigitsAfterPt));
		    		
		    	}
		    	else if(type.equals("int"))
		    	{
		    		int data = 0;
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			data = Integer.parseInt(dataStr);
		    		}
		    		sheet.addCell(new jxl.write.Number(col,row,data,intCell));
		    	}
		    	else if(type.equals("datetime"))
		    	{
		    		Date date =new Date();
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			 date = sdf.parse(dataStr);
		    		}
		    		sheet.addCell(new DateTime(col, row, date,dateCell));
		    	}
		    	else if(type.equals("datetime1"))
		    	{
		    		Date date =new Date();
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			 date = sdf2.parse(dataStr);
		    		}
		    		sheet.addCell(new DateTime(col, row, date,dateCell));
		    	}
		    	else if(type.equals("string"))
		    	{
		    		String data ="";
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			 data=dataStr;
		    			 if (data.contains("Hours and More")) {
			    			String d = data.substring(0,data.indexOf("Hours")-1);
			    			int dd = Integer.parseInt(d);
							if (dd>=1 && dd <2) {
								Label lb1=new Label(col, row, ">1<2 Hours Delay",color3);
					    		sheet.addCell(lb1);
							}else if(dd>=2 && dd<4){
								Label lb1=new Label(col, row, ">2<4 Hours Delay",color4);
					    		sheet.addCell(lb1);
							}
							else if(dd>=4 && dd<6)
							{
								Label lb1=new Label(col, row, ">4<6 Hours Delay",color5);
					    		sheet.addCell(lb1);
							}
							else if(dd>=6)
							{
								Label lb1=new Label(col, row, "6 Hours and More",color6);
					    		sheet.addCell(lb1);
							}
						 }else{
							data = dataStr;
							Label lb1=new Label(col, row, data,cf);
				    		sheet.addCell(lb1);
						 }
		    			 
		    		}else{
		    			Label lb1=new Label(col, row, data,cf);
			    		sheet.addCell(lb1);
		    		}
		    		
		    	}		    	
		    	else
		    	{
		    		if(dataStr==null)
		    		{
		    			dataStr = "";
		    		}
		    		sheet.addCell(new Label(col, row, dataStr,cf));
		    	}
		    	
		    	int colSpanVal = colSpanList.get(i);
		    	if(colSpanVal > 1)
		    	{
			    	int extraCell = colSpanVal - 1;
			    	sheet.mergeCells(col, row, col+extraCell, row);
			    	col = col + extraCell;
			    }
		    	col++;
		    }
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public void writeSummaryFooter(WritableSheet sheet)
	{
		try
		{
			try
			{
			    WritableCellFormat cf1 = new WritableCellFormat(summaryWF);
			    cf1.setAlignment(Alignment.LEFT);
			    cf1.setWrap(false);
			   
			    WritableCellFormat cf2 = new WritableCellFormat(summaryWF);
			    cf2.setAlignment(Alignment.RIGHT);
			    cf2.setWrap(false);
			    for(int i = 0; i < summaryFooterList.size(); i++)
			    {
			    	String lbStr1 = summaryFooterList.get(i);
			    	int row = rowNo++;
			    	Label label = new Label(cellStart,row,lbStr1,cf1);
				    sheet.addCell(label);
				    sheet.mergeCells(cellStart, row, cellEnd, row);
			    }
			    
			}
			catch(Exception e)
			{
				e.printStackTrace();
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	public void writeEndTitle(WritableSheet sheet)
	{
		try
		{
			 WritableCellFormat cf = new WritableCellFormat(titleWF);
			    cf.setBackground(TITLE_BKG);
			    cf.setAlignment(Alignment.CENTRE);
			    cf.setWrap(false);
			    for(int i = 0; i < startTitleList.size(); i ++)
			    {
			    	String lbStr = startTitleList.get(i);
			    	int row = rowNo++;
			    	Label label = new Label(cellStart,row,lbStr,cf); 
				    sheet.addCell(label);
				    sheet.mergeCells(cellStart, row, cellEnd, row); 
			    }
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	public void addBlankRow(WritableSheet sheet)
	{
		try
		{
			WritableFont wf = new WritableFont(WritableFont.ARIAL,WritableFont.DEFAULT_POINT_SIZE, WritableFont.BOLD, false,  
		    		  						   UnderlineStyle.NO_UNDERLINE, Colour.DARK_BLUE2);
		    WritableCellFormat cf = new WritableCellFormat(wf);
		    cf.setAlignment(Alignment.CENTRE);
		    cf.setBackground(BLANK_ROW_BKG);
		    int row = rowNo++;
		    Label label = new Label(cellStart,row,summaryFooterList.get(0),cf); 
		    sheet.addCell(label);
		    sheet.mergeCells(cellStart, row, cellEnd, row);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	/* return the last cell's cell no horizantlly */
	public int getCellEnd()
	{
		int cellEnd = 0;
		for(int i = 0; i < colSpanList.size(); i++)
		{
			cellEnd = cellEnd + colSpanList.get(i);
		}
		cellEnd--;
		return (cellEnd + cellStart);
	}
}
