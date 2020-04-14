package t4u.employeetracking;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.http.HttpServletResponse;

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
/**
 * 
 * 
 * This class is used to generate excel for the given data and stores in a particular location.
 * This class accepts 4 parameters which is explained below.
 * 
 * First Parameter 'dataMap' : This is the Hash map which contains data which want to be generated, having sheet name as a key and data as a value.
 * 	  Value present in the hash map also has to be in the particular format as explained below
 *    1)First start title i.e title which you have to be in the top of the excel sheet.
 *      eg:"Driver Statutory Notification Alert Report-WSG "
 *    2)Second is the start date and end date .
 *    3)Third  is the header list i.e column names .
 *    4)Fourth is the column span list.
 *    5)Sixth is the data type list ,type of each column mentioned in the header list.
 *    6)Seventh is the actual data that want to be in the excel sheet.
 *    7)Eighth is note,If you need any note to put in the excel sheet u need to put in this list.
 *    8)Ninth is to mention the end title list eg:"Service Delivered By -WSG";
 *    9)Tenth is the number of lines of data in the excel sheet,that is size of actual data that your adding in the seventh point.
 *    
 *    all the points mentioned above should be added in different array lists later all these array lists should be added in single array list.
 *    and this array list must be put in to hash map with respective key(which has to be sheet name).
 *    
 * Second Parameter 'vehicleList' : If your excel has to be generated in sheet wise then u need specify the sheet name in the second parameters
 *    which must be in a same order as specified in the hash map.
 *    
 * Third Parameter 'cellStart' : Left align parameter is a integer parameter to specify the no of columns to ignore
 * 	i.e if it is given as 2 then the first 2 columns are left blank.
 * 
 * Fourth Parameter 'outFile' : This is the path saying where the generated file has to get saved.
 * 
 * For reference you can see getFormatedData method of Statutory Notification Alert.
 * 
 *
 */
public class GenerateExcel {
	
	ArrayList<String> startTitleList = new ArrayList<String>();
	ArrayList<String> summaryHeaderList = new ArrayList<String>();
	ArrayList<String> dataHeaderList = new ArrayList<String>();
	ArrayList<Integer> colSpanList = new ArrayList<Integer>();
	ArrayList<String> dataTypeList = new ArrayList<String>();
	@SuppressWarnings("unchecked")
	ArrayList<ArrayList> dataList = new ArrayList<ArrayList>();
	ArrayList<String> summaryFooterList = new ArrayList<String>();
	ArrayList<String> endTitleList = new ArrayList<String>();
	@SuppressWarnings("unchecked")
	ArrayList<ArrayList> datas = new ArrayList<ArrayList>();
	@SuppressWarnings("unchecked")
	HashMap<String,ArrayList<ArrayList>> alldata = new HashMap<String,ArrayList<ArrayList>>();
	ArrayList<String> vehicleList = new ArrayList<String>();


	
	File outFile;
	int rowNo;
	int cellStart;
	int cellEnd;
	int mid;
	int noOfLinesPerSheet;
	
	BorderLineStyle lineStyleTHICK = BorderLineStyle.THICK;
	
	Colour BLANK_ROW_BKG = Colour.LIGHT_ORANGE;
	Colour TITLE_BKG = Colour.LIGHT_ORANGE;
	Colour HEADER_BKG = Colour.ICE_BLUE;
	Colour RED_COLOR =Colour.CORAL;
	
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
    @SuppressWarnings("static-access")
	WritableCellFormat twoDigitsAfterPt = new WritableCellFormat(dataWF,dp3.FORMAT3);
    
    DateFormat dateFormat = new DateFormat ("dd/MM/yyyy HH:mm:ss"); 
    WritableCellFormat dateCell = new WritableCellFormat (dataWF,dateFormat); 
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
    SimpleDateFormat sdf2 = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	
	@SuppressWarnings("unchecked")
	public GenerateExcel(HashMap<String,ArrayList<ArrayList>> dataMap,ArrayList<String> vehicleList,int cellStart,File outFile) {
		this .alldata=dataMap;
		this.vehicleList=vehicleList;
		this.cellStart = cellStart;
		this.outFile = outFile;
	}
	/**
	 * this is the method need to be called after all the above mentioned parameters are initialised.
	 */
	@SuppressWarnings("unchecked")
	public void createExcel(HttpServletResponse response) {
		try {
			WritableWorkbook workbook = Workbook.createWorkbook(outFile);
			int dataSize = alldata.size();
			
			int sheetNo = 0;

			for (int i = 0; i < dataSize; i++) {	
				cellEnd = getCellEnd(vehicleList.get(i));
				mid = (cellStart+cellEnd) / 2;
				
				ArrayList allList=alldata.get(vehicleList.get(i));
			    ArrayList secondarray=(ArrayList)allList.get(0);
			    int noOfLinesPerSheet=Integer.parseInt(secondarray.get(9).toString());
				
				int startLineNo = 0;
				int endLineNo = noOfLinesPerSheet;
				
				if (startLineNo==0) {
					rowNo = 0;
					String sheetName = vehicleList.get(i);
					WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
					writeStartTitle(sheet,vehicleList.get(i));
					writeSummaryHeader(sheet,vehicleList.get(i));
					writeSecondaryDataHeader(sheet,vehicleList.get(i));
					writeDataHeader(sheet,vehicleList.get(i));
					writeData(sheet,startLineNo,endLineNo,vehicleList.get(i));
					addBlankRow(sheet);
					writeSummaryFooter(sheet,vehicleList.get(i));
					writeEndTitle(sheet,vehicleList.get(i));
					sheetNo++;
				}
			}
			workbook.write();
		    workbook.close();
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	@SuppressWarnings("unchecked")
	private void writeSecondaryDataHeader(WritableSheet sheet, String vehicleNo) {
		try {
		    WritableCellFormat cf = new WritableCellFormat(headerWF);
		    cf.setBackground(HEADER_BKG);
		    cf.setWrap(false);
		    int row = rowNo++;
		    int col = cellStart;
		    ArrayList allList=alldata.get(vehicleNo);
		    ArrayList secondarray=(ArrayList)allList.get(0);
		    ArrayList dataHeaderList=(ArrayList)secondarray.get(2);
		    ArrayList colSpanList=(ArrayList)secondarray.get(4);
		    int size =  dataHeaderList.size();
		    for (int i = 0; i < size; i ++) {
		    	String lbStr = (String) dataHeaderList.get(i);
		    	int colSpanVal = Integer.parseInt(colSpanList.get(i).toString());
		    	Label label = new Label(col,row,lbStr,cf); 
			    sheet.addCell(label);
			    
			    if (colSpanVal > 1) {
			    	int extraCell = colSpanVal - 1;
			    	sheet.mergeCells(col, row, col+extraCell, row);
			    	col = col + extraCell;
			    }
			    col++;
		    }
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 
	 * @param sheet
	 * @param vehicleList
	 * This function will write the start title in the excel sheet which is called by create excel method.
	 */
	@SuppressWarnings("unchecked")
	public void writeStartTitle(WritableSheet sheet,String vehicleList) {
		try {
		    WritableCellFormat cf = new WritableCellFormat(titleWF);
		    cf.setBackground(TITLE_BKG);
		    cf.setAlignment(Alignment.CENTRE);
		    cf.setWrap(false);

		    ArrayList allList=alldata.get(vehicleList);
		    ArrayList secondarray=(ArrayList)allList.get(0);
		    ArrayList startTitleList1=(ArrayList)secondarray.get(0);

		    for (int i = 0; i < startTitleList1.size(); i ++) {
		    	String lbStr = (String) startTitleList1.get(i);
		    	int row = rowNo++;
		    	Label label = new Label(cellStart,row,lbStr,cf); 
			    sheet.addCell(label);
			    sheet.mergeCells(cellStart, row, cellEnd, row); 
		    }
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 
	 * @param sheet
	 * @param vehicleList
	 * This function will write the start date and end date in the excel sheet.
	 */
	@SuppressWarnings("unchecked")
	public void writeSummaryHeader(WritableSheet sheet,String vehicleNo) {
		try {
		    WritableCellFormat cf1 = new WritableCellFormat(summaryWF);
		    cf1.setAlignment(Alignment.LEFT);
		    cf1.setWrap(false);
		   
		    WritableCellFormat cf2 = new WritableCellFormat(summaryWF);
		    cf2.setAlignment(Alignment.RIGHT);
		    cf2.setWrap(false);
		    
		    ArrayList<?> allList=alldata.get(vehicleNo);
		    ArrayList secondarray=(ArrayList)allList.get(0);
		    ArrayList summaryHeaderList=(ArrayList)secondarray.get(1);
		   
		    
		    for (int i = 0; i < summaryHeaderList.size(); i+=2) {
		    		String lbStr1 = (String) summaryHeaderList.get(i);
		    		String lbStr2 = "";
		    		if(i + 1 < summaryHeaderList.size())
		    		{
		    			lbStr2 = (String) summaryHeaderList.get(i+1);
		    		}
		    	
		    		int row = rowNo++;
		    	
		    		Label label = new Label(cellStart,row,lbStr1,cf1); 
		    		sheet.addCell(label);
		    		sheet.mergeCells(cellStart, row, mid, row); 
			    
			   
		    		label = new Label(mid+1,row,lbStr2,cf2); 
		    		sheet.addCell(label);
		    		sheet.mergeCells(mid+1, row, cellEnd, row); 
		    	
		    }
		    
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 
	 * @param sheet
	 * @param vehicleNo
	 * This is to write the headers in the excel sheet.
	 */
	@SuppressWarnings("unchecked")
	public void writeDataHeader(WritableSheet sheet,String vehicleNo) {
		try {
		    WritableCellFormat cf = new WritableCellFormat(headerWF);
		    cf.setBackground(HEADER_BKG);
		    cf.setWrap(false);
		    int row = rowNo++;
		    int col = cellStart;
		    ArrayList allList=alldata.get(vehicleNo);
		    ArrayList secondarray=(ArrayList)allList.get(0);
		    ArrayList dataHeaderList=(ArrayList)secondarray.get(3);
		    ArrayList colSpanList=(ArrayList)secondarray.get(4);
		    int size =  dataHeaderList.size();
		    for(int i = 0; i < size; i ++) {
		    	String lbStr = (String) dataHeaderList.get(i);
		    	int colSpanVal = Integer.parseInt(colSpanList.get(i).toString());
		    	Label label = new Label(col,row,lbStr,cf); 
			    sheet.addCell(label);
			    
			    if (colSpanVal > 1) {
			    	int extraCell = colSpanVal - 1;
			    	sheet.mergeCells(col, row, col+extraCell, row);
			    	col = col + extraCell;
			    }
			    col++;
		    }
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 
	 * @param sheet
	 * @param startLineNo
	 * @param endLineNo
	 * @param vehicleNo
	 * 
	 * This is to write the data in to your excel sheet.
	 */
	@SuppressWarnings("unchecked")
	public void writeData(WritableSheet sheet,int startLineNo,int endLineNo,String vehicleNo) {
		try {
		    for (int i = startLineNo; i < endLineNo; i ++) {
		    	ArrayList allList=alldata.get(vehicleNo);
			    ArrayList secondarray=(ArrayList)allList.get(0);
			    ArrayList dataList=(ArrayList)secondarray.get(6);
		    	ArrayList rowList = (ArrayList) dataList.get(i);
		    	createDataRow(rowList,sheet,vehicleNo);
		    }
		} catch(Exception e) {
			e.printStackTrace();
		}
	}
	/**
	 * 
	 * @param rowList
	 * @param sheet
	 * @param vehicleNo
	 * This function is called by writeData which writes the data in to your excel sheet cell by cell.
	 */
	@SuppressWarnings("unchecked")
	public void createDataRow(ArrayList rowList,WritableSheet sheet,String vehicleNo) {
		try
		{
		    WritableCellFormat cf = new WritableCellFormat(dataWF);
		    cf.setWrap(false);
		    
		    WritableCellFormat firstCell = new WritableCellFormat(intFormat);
		    firstCell.setWrap(false);
		    firstCell.setAlignment(Alignment.LEFT);
		  
		    WritableCellFormat redValueCell = new WritableCellFormat(floatFormat);
		    redValueCell.setWrap(false);
		    redValueCell.setAlignment(Alignment.LEFT);
		    redValueCell.setBackground(RED_COLOR);
		    
		    int row = rowNo++;
		    int size = rowList.size();
		    int col = cellStart;
		    String redAlert = "";
		    for(int i = 0; i < size; i ++)
		    {
		    	String dataStr = rowList.get(i).toString();
		    	ArrayList allList=alldata.get(vehicleNo);
			    ArrayList secondarray=(ArrayList)allList.get(0);
			    ArrayList dataTypeList=(ArrayList)secondarray.get(5);
			    ArrayList colSpanList=(ArrayList)secondarray.get(4);
			    
			    redAlert=rowList.get(size-1).toString();

		    	String type = (String) dataTypeList.get(i);
		    	if(i == 0 && type.equals("int"))
		    	{
		    		int data = 0;
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			data = Integer.parseInt(dataStr);
		    		}
		    		/**
		    		 * this condition is to shows the particular row in red band when the last column of the data Y
		    		 */
		    		if(redAlert.equals("Y"))
	    			{
				    	sheet.addCell(new jxl.write.Number(col,row,data,redValueCell));
	    			}
		    		else
		    		{
		    			sheet.addCell(new jxl.write.Number(col,row,data,firstCell));
		    		}
		    	}
		    	else if(type.equals("number"))
		    	{
		    		Double data = 0.00;
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			data = Double.parseDouble(dataStr);
		    			
		    		}
		    		if(redAlert.equals("Y"))
	    			{
				    	sheet.addCell(new jxl.write.Number(col,row,data,redValueCell));
	    			}
		    		else
		    		{
			    		sheet.addCell(new jxl.write.Number(col,row,data,twoDigitsAfterPt));
		    		}
		    		
		    	}
		    	else if(type.equals("int"))
		    	{
		    		int data = 0;
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			data = Integer.parseInt(dataStr);
		    		}
		    		if(redAlert.equals("Y"))
	    			{
				    	sheet.addCell(new jxl.write.Number(col,row,data,redValueCell));
	    			}
		    		else
		    		{
			    		sheet.addCell(new jxl.write.Number(col,row,data,intCell));
		    		}
		    	}
		    	else if(type.equals("datetime"))
		    	{
		    		Date date =new Date();
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			 date = sdf.parse(dataStr);
		    		}
		    		if(redAlert.equals("Y"))
	    			{
				    	sheet.addCell(new DateTime(col,row,date,redValueCell));
	    			}
		    		else
		    		{
			    		sheet.addCell(new DateTime(col, row, date,dateCell));
		    		}

		    	}
		    	else if(type.equals("datetime1"))
		    	{
		    		Date date =new Date();
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			 date = sdf2.parse(dataStr);
		    		}
		    		if(redAlert.equals("Y"))
	    			{
				    	sheet.addCell(new DateTime(col,row,date,redValueCell));
	    			}
		    		else
		    		{
			    		sheet.addCell(new DateTime(col, row, date,dateCell));
		    		}

		    	}
		    	else if(type.equals("string"))
		    	{
		    		String data ="";
		    		if(dataStr != null && !dataStr.equals(""))
		    		{
		    			
		    			 data = dataStr;
		    		}
		    		Label lb1;
		    		if(redAlert.equals("Y"))
	    			{
			    		lb1=new Label(col, row, data,redValueCell);
	    			}
		    		else
		    		{
			    		lb1=new Label(col, row, data,cf);
		    		}
		    		sheet.addCell(lb1);
		    	}		    	
		    	else
		    	{
		    		if(dataStr==null)
		    		{
		    			dataStr = "";
		    		}
		    		if(redAlert.equals("Y"))
	    			{
			    		sheet.addCell(new Label(col, row, dataStr,redValueCell));
	    			}
		    		else
		    		{
			    		sheet.addCell(new Label(col, row, dataStr,cf));
		    		}
		    	}
		    	
		    	int colSpanVal = Integer.parseInt(colSpanList.get(i).toString());
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
	/**
	 * 
	 * @param sheet
	 * @param vehicleNo
	 * This function write the note or disclaimer at the end of the sheet.
	 */
	@SuppressWarnings("unchecked")
	public void writeSummaryFooter(WritableSheet sheet,String vehicleNo)
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
			    ArrayList allList=alldata.get(vehicleNo);
			    ArrayList secondarray=(ArrayList)allList.get(0);
			    ArrayList summaryFooterList=(ArrayList)secondarray.get(7);
			    for(int i = 0; i < summaryFooterList.size(); i++)
			    {
			    	String lbStr1 = (String) summaryFooterList.get(i);
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
	/**
	 * 
	 * @param sheet
	 * @param vehicleNo
	 * This function is to write the end title.
	 */
	@SuppressWarnings("unchecked")
	public void writeEndTitle(WritableSheet sheet,String vehicleNo)
	{
		try
		{
			 WritableCellFormat cf = new WritableCellFormat(titleWF);
			    cf.setBackground(TITLE_BKG);
			    cf.setAlignment(Alignment.CENTRE);
			    cf.setWrap(false);
			    ArrayList allList=alldata.get(vehicleNo);
			    ArrayList secondarray=(ArrayList)allList.get(0);
			    ArrayList startTitleList=(ArrayList)secondarray.get(8);
			    for(int i = 0; i < startTitleList.size(); i ++)
			    {
			    	String lbStr = (String) startTitleList.get(i);
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
		    cf.setBackground(BLANK_ROW_BKG);
		   
		    int row = rowNo++;
		    
		    Label label = new Label(cellStart,row,"",cf); 
		    sheet.addCell(label);
		    sheet.mergeCells(cellStart, row, cellEnd, row);
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	@SuppressWarnings("unchecked")
	public int getCellEnd(String vehicleNo)
	{
		int cellEnd = 0;
		ArrayList allList=alldata.get(vehicleNo);
	    ArrayList secondarray=(ArrayList)allList.get(0);
	    ArrayList colSpanList=(ArrayList)secondarray.get(4);
		for(int i = 0; i < colSpanList.size(); i++)
		{
			int column = Integer.parseInt(colSpanList.get(i).toString());
			cellEnd = cellEnd + column;
		}
		cellEnd--;
		return (cellEnd + cellStart);
	}
	
}

