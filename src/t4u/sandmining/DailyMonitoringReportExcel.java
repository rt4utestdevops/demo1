package t4u.sandmining;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.SandMiningFunctions;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import jxl.write.Label;
import jxl.write.NumberFormat;
import jxl.write.NumberFormats;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

public class DailyMonitoringReportExcel extends HttpServlet {
	File outFile;
	int rowNo;
	int cellStart = 0;
	int cellEnd;
	int mid;
	int noOfLinesPerSheet;
	int cc = 0;
	int st = 0;
	int leftAlign;
	ArrayList reportTitleList ;
	ArrayList dataHeaderList;
	ArrayList<Integer> colSpanList = new ArrayList<Integer>();
	ArrayList dataList;	
	ArrayList dataTypeList;
	
		
	BorderLineStyle lineStyleTHICK = BorderLineStyle.THICK;	
	Colour GROUP_HEADER_ROW_BKG = Colour.GRAY_50;
	Colour GROUP_SUMMARY_ROW_BKG = Colour.GRAY_25;
	Colour BLANK_ROW_BKG = Colour.LIGHT_ORANGE;
	Colour TITLE_BKG = Colour.LIGHT_ORANGE;
	Colour HEADER_BKG = Colour.ICE_BLUE;
	Colour COLOR_CON_BKG = Colour.WHITE;
	Colour CELL_BKG_ACTION_REQUIRED = Colour.RED;
	Colour CELL_BKG_SAFE_ZONE = Colour.GREEN;
	Colour CELL_BKG_TO_BE_OBSERVED = Colour.YELLOW;
	
	
	WritableFont titleWF = new WritableFont(WritableFont.ARIAL,14, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE, Colour.DARK_BLUE2);
	WritableFont summaryWF = new WritableFont(WritableFont.ARIAL,8, WritableFont.BOLD);
	WritableFont headerWF = new WritableFont(WritableFont.ARIAL,9, WritableFont.BOLD);
	WritableFont dataWF = new WritableFont(WritableFont.ARIAL,8, WritableFont.BOLD);	
	WritableCellFormat intFormat = new WritableCellFormat(dataWF,NumberFormats.INTEGER);
	WritableCellFormat intCell = new WritableCellFormat(intFormat);		
	WritableCellFormat floatFormat = new WritableCellFormat(dataWF,NumberFormats.FLOAT);
	WritableCellFormat floatCell = new WritableCellFormat(floatFormat);	
	NumberFormat dp2 = new NumberFormat("0.00");
    WritableCellFormat dp2cell = new WritableCellFormat(dataWF,dp2); 

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    	String date =""; 
   		int systemId =0;
   		String dateToDisplay ="";
   		String clientid = "";
   		String division = "";
   		int offset=0;
   		JSONArray jsonarray = new JSONArray();
   		ArrayList<String> datalists = new ArrayList<String>();
   		ArrayList reportList = new ArrayList();	    
		ArrayList<String> headersList = new ArrayList<String>();   				
   		try
		      {   
				HttpSession session = request.getSession();
				LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");				
			    systemId = loginInfoBean.getSystemId();		        
		        offset=loginInfoBean.getOffsetMinutes();
				division = request.getParameter("clientName");
				clientid= request.getParameter("clientId");
				date = request.getParameter("date");					
				dateToDisplay = date;		
				String[] dateFormat = date.split("-");
				date = dateFormat[2]+"-"+dateFormat[1]+"-"+dateFormat[0];				
			
				headersList.add("SlNo");
				headersList.add("Vehicle Number");
				headersList.add("Live Status");
				headersList.add("Over Speed Status");
				headersList.add("Permit Status");
				headersList.add("Port Entry Status");
				headersList.add("Multiple MDP");
				headersList.add("Near To Border");
				headersList.add("Cross Border");
				headersList.add("Restrictive Port Entry");
				headersList.add("Insurance Status");
				headersList.add("Asset Fitness Status");
				headersList.add("Emission Status");

				SandMiningFunctions  smf = new SandMiningFunctions(); 
			    jsonarray = smf.getDailyMonitorReport(systemId, clientid, date, offset);    
				
			    for (int i = 0; i < jsonarray.length(); i++) {				
					datalists = new ArrayList<String>();
					JSONObject obj = jsonarray.getJSONObject(i);
					
					String assetNumber = obj.getString("assetNumber");
					String liveStatus = obj.getString("liveStatus");
					String overSpeedStatus = obj.getString("overSpeedStatus");
					String permitStatus = obj.getString("permitStatus");
					String portEntryStatus = obj.getString("portEntryStatus");
					String multipleMDP = obj.getString("multipleMDP");
					String nearToBorder = obj.getString("nearToBorder");
					String CrossBorder = obj.getString("CrossBorder");
					String restrictivePortEntry = obj.getString("restrictivePortEntry");
					String insuranceStatus = obj.getString("insuranceStatus");
					String assetFitnesStatus = obj.getString("assetFitnesStatus");
					String emissionStatus = obj.getString("emissionStatus");
										
					datalists.add(assetNumber);
					datalists.add(liveStatus);
					datalists.add(overSpeedStatus);
					datalists.add(permitStatus);
					datalists.add(portEntryStatus);
					datalists.add(multipleMDP);
					datalists.add(nearToBorder);
					datalists.add(CrossBorder);
					datalists.add(restrictivePortEntry);
					datalists.add(insuranceStatus);
					datalists.add(assetFitnesStatus);
					datalists.add(emissionStatus);					
					reportList.add(datalists);										
				     }				
			    ServletOutputStream servletOutputStream=response.getOutputStream();
				Properties p=ApplicationListener.prop;
				String crystalReport=p.getProperty("crystalReport");
				String excelpath=  crystalReport;
				refreshdir(excelpath);
				String formno="DailyMonitoring"+systemId;							
				String excel = excelpath+formno+".xls";
				File outFile = new File(excel);

		ArrayList colSpanDataTypeList = getColspanDataTypeList(" ",headersList);
		ArrayList<Integer> colSpanList = (ArrayList)colSpanDataTypeList.get(0);
		ArrayList dataTypeList = (ArrayList)colSpanDataTypeList.get(1);
		int noOfLinePerSheet = reportList.size();
		
		ArrayList<String> reportTitleList = new ArrayList<String>();
		reportTitleList.add("Daily Monitoring Report");	
		reportTitleList.add("Division: "+division);
		reportTitleList.add("Date: "+dateToDisplay);
		reportTitleList.add("Action Required:");
		reportTitleList.add("Wthin Safe Zone:");
		reportTitleList.add("To Be Observed:");

		prepareExcel(excel,systemId,division,dateToDisplay,request,headersList, reportList,reportTitleList,colSpanList, dataTypeList, cellStart, noOfLinePerSheet,outFile,leftAlign);						
		printExcel(response,servletOutputStream,systemId,division,dateToDisplay,excel);

	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	
 }//end of doget method
   
    public void prepareExcel(String excel,int systemId,String division,String dateToDisplay,HttpServletRequest request,ArrayList headersList,ArrayList reportList,ArrayList reportTitleList,ArrayList<Integer> colSpanList,ArrayList dataTypeList,int cellStart,int noOfLinesPerSheet,File outFile,int leftAlign){    
		this.reportTitleList = reportTitleList;		
		this.dataHeaderList = headersList;
		this.colSpanList = colSpanList;
		this.dataList = reportList;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.leftAlign = leftAlign;
		this.dataTypeList = dataTypeList;
       // this.dataHeaderList.add(0,"SLNO");
    	this.colSpanList.add(0,1);
    	this.dataTypeList.add(0,"int");		
    	cellEnd = getCellEnd();
		mid = (cellStart+cellEnd) / 7;
		this.noOfLinesPerSheet = noOfLinesPerSheet;
		
		generateExcel(excel,headersList,reportList,noOfLinesPerSheet,systemId,division,dateToDisplay,request);		
	
    }
    
    public void generateExcel(String pdf,ArrayList headersList,ArrayList reportList,int noOfLinePerSheet,int systemId,String division,String dateToDisplay,HttpServletRequest request){	
			
			try{
				
				WritableWorkbook workbook = Workbook.createWorkbook(outFile);								
				int dataSize = reportList.size();
				int sheetNo = 0;
				for(int i = 0; i < reportList.size(); i ++){
					int startLineNo = i;
					int endLineNo = (i+noOfLinesPerSheet)>dataSize?dataSize:(i+noOfLinesPerSheet);
					if(startLineNo==0){
						rowNo = 0;
						String sheetName = "Sheet - "+(++st);
						WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);						
						writeReportTitle(sheet);
						writeDataHeader(sheet);
						writeData(sheet,startLineNo,endLineNo);												
					}
				}				
				workbook.write();
			    workbook.close();
		
			}catch(Exception e){
				e.printStackTrace();
			}
		
		}//end generate
		
		
		public void writeReportTitle(WritableSheet sheet){
			try{
			    WritableCellFormat cf = new WritableCellFormat(titleWF);
			    cf.setBackground(TITLE_BKG);
			    cf.setAlignment(Alignment.CENTRE);
			    cf.setWrap(false);
			    if(reportTitleList.size() > 0){
			    	String lbStr = (String) reportTitleList.get(0);
			    	int row = rowNo++;
			    	Label title = new Label(cellStart,row,lbStr,cf); 
			    	sheet.addCell(title);
			    	sheet.mergeCells(cellStart, row, cellEnd-1, row); 
			   // }
			   // if(reportTitleList.size() >= 6){
			    	String lbStr1 = (String) reportTitleList.get(1);
			    	String lbStr2 = (String) reportTitleList.get(2);			    	
			    	
			    	row = rowNo++;
			    	WritableCellFormat cf1 = new WritableCellFormat(summaryWF);
			    	cf1.setBackground(HEADER_BKG);
					cf1.setAlignment(Alignment.LEFT);
					cf1.setWrap(false);
					
					Label division = new Label(cellStart,row,lbStr1,cf1);
				    sheet.addCell(division);
				    sheet.mergeCells(cellStart, row, cellEnd-1, row);
					
				    
				    row = rowNo++;
					WritableCellFormat cf2 = new WritableCellFormat(summaryWF);
					cf2.setAlignment(Alignment.LEFT);
					cf2.setBackground(HEADER_BKG);
					cf2.setWrap(false);
				   
				    Label dates = new Label(cellStart,row,lbStr2,cf2);
				    sheet.addCell(dates);
				    sheet.mergeCells(cellStart, row, cellEnd-1, row);
					
				    WritableCellFormat cfcolor = new WritableCellFormat(summaryWF);
				    cfcolor.setAlignment(Alignment.LEFT);
				    cfcolor.setBackground(COLOR_CON_BKG);
				    cfcolor.setWrap(false);
				    
				    WritableCellFormat cfr = new WritableCellFormat(intFormat);
				    cfr.setAlignment(Alignment.LEFT);
				    cfr.setBorder(Border.ALL,BorderLineStyle.THIN,Colour.BLACK);
				    cfr.setBackground(CELL_BKG_ACTION_REQUIRED);
				    cfr.setWrap(false);
				    
				    WritableCellFormat cfg = new WritableCellFormat(intFormat);
				    cfg.setAlignment(Alignment.LEFT);
				    cfg.setBorder(Border.ALL,BorderLineStyle.THIN,Colour.BLACK);
				    cfg.setBackground(CELL_BKG_SAFE_ZONE);
				    cfg.setWrap(false);
				    
				    WritableCellFormat cfy = new WritableCellFormat(intFormat);
				    cfy.setAlignment(Alignment.LEFT);
				    cfy.setBorder(Border.ALL,BorderLineStyle.THIN,Colour.BLACK);
				    cfy.setBackground(CELL_BKG_TO_BE_OBSERVED);
				    cfy.setWrap(false);
				    
				    for(int i = 3;i<=5;i++){				    
				    	row = rowNo++;				    
						String StrColorCode = (String) reportTitleList.get(i);				    	
				    	Label label3 = new Label(cellStart,row,StrColorCode,cfcolor);
					    sheet.addCell(label3);
					    sheet.mergeCells(cellStart,row, mid, row);
					    
					    if(StrColorCode.equals("Action Required:")){					    	
					    String StrColor = "";				    	
				    	Label labelcolor = new Label(mid+1,row,StrColor,cfr);
					    sheet.addCell(labelcolor);
					    sheet.mergeCells(mid+1,row, mid+1, row);
					    }
					    else if(StrColorCode.equals("Wthin Safe Zone:")){ 
					    	    String StrColor = "";				    	
						    	Label labelcolor = new Label(mid+1,row,StrColor,cfg);
							    sheet.addCell(labelcolor);
							    sheet.mergeCells(mid+1,row, mid+1, row);
					    }
					    else if(StrColorCode.equals("To Be Observed:")){ 
					    	  String StrColor = "";				    	
						    	Label labelcolor = new Label(mid+1,row,StrColor,cfy);
							    sheet.addCell(labelcolor);
							    sheet.mergeCells(mid+1,row, mid+1, row);  
					    }
					    else{					     
						    	String StrColor = "";				    	
							    Label labelcolor = new Label(mid+1,row,StrColor,cf);
								sheet.addCell(labelcolor);
								sheet.mergeCells(mid+1,row, mid+1, row); 
					    }
				    }
				 }    
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		public void writeDataHeader(WritableSheet sheet){

			try{
			    WritableCellFormat cf = new WritableCellFormat(headerWF);
			    cf.setBackground(TITLE_BKG);
			    cf.setWrap(false);
			    int row = rowNo++;
			    int col = cellStart;
			    int size =  dataHeaderList.size();
			    for(int i = 0; i < size; i ++){
			    	String lbStr = (String) dataHeaderList.get(i);
			    	int colSpanVal = colSpanList.get(i);
			    	Label label = new Label(col,row,lbStr,cf); 
				    sheet.addCell(label);
				    
				    if(colSpanVal > 1){
				    	int extraCell = colSpanVal - 1;
				    	sheet.mergeCells(col, row, col+extraCell, row);
				    	col = col + extraCell;
				    }
				    col++;
			    }
			}
			catch(Exception e){
				e.printStackTrace();
			}
		
		}		
			
		public void writeData(WritableSheet sheet,int startLineNo,int endLineNo){        
         cc=0;
			try{
				
				for(int i = startLineNo; i < endLineNo; i ++){
					
			    	if(dataList.get(i) instanceof ArrayList){
			    	ArrayList rowList = (ArrayList)dataList.get(i);			    	
			    	createDataRow(rowList,sheet,"dataRow");	
			    
			    	}			    	
			    }
			}
			catch(Exception e){
				e.printStackTrace();
			}
		
	  }

		public void createDataRow(ArrayList rowList,WritableSheet sheet,String rowtype)
		{
			try{
				
			    WritableCellFormat cf = new WritableCellFormat(dataWF);
			    cf.setWrap(false);
			    
			    WritableCellFormat cfR = new WritableCellFormat(intFormat);
			    cfR.setBackground(CELL_BKG_ACTION_REQUIRED);
			    cfR.setBorder(Border.ALL,BorderLineStyle.THIN,Colour.BLACK);
			    cfR.setWrap(false);
			    
			    WritableCellFormat cfG = new WritableCellFormat(intFormat);
			    cfG.setBackground(CELL_BKG_SAFE_ZONE);
			    cfG.setBorder(Border.ALL,BorderLineStyle.THIN,Colour.BLACK);
			    cfG.setWrap(false);
			    
			    WritableCellFormat cfY = new WritableCellFormat(intFormat);
			    cfY.setBorder(Border.ALL,BorderLineStyle.THIN,Colour.BLACK);
			    cfY.setBackground(CELL_BKG_TO_BE_OBSERVED);
			    cfY.setWrap(false);
			    
			    WritableCellFormat firstCell = new WritableCellFormat(intFormat);
			    firstCell.setWrap(false);
			    firstCell.setAlignment(Alignment.LEFT);
			    
			    if(rowtype.equals("dataRow")){			    	
			    	rowList.add(0,++cc);
			    }
			    else{
			    	rowList.add(0,"");
			    }
			    int row = rowNo++;
			    int size = rowList.size();
			    int col = cellStart;
			    for(int i = 0; i < size; i ++){
			    	String dataStr = null;
			    	if(rowList.get(i) != null){			    		
			    		dataStr = rowList.get(i).toString();
			    	}
			    	String type = (String) dataTypeList.get(i);
			    	
			   	 if(type.equals("int") && rowtype.equals("dataRow")){		    	
		    		  if(dataStr != null && !dataStr.equals("")){
		    			int data = Integer.parseInt(dataStr);		    			
		    			sheet.addCell(new jxl.write.Number(col,row,data,firstCell));
		    		}
		    		else{
		    			sheet.addCell(new Label(col, row,"",cf));
		    		}
		    	}			    	
			   	 else if(type.equals("string") && rowtype.equals("dataRow")){
			    		if(dataStr != null && !dataStr.equals("")){			    			
			    			String data = dataStr;
			    			if(data.equals("Red")) {
			    				data = "";
			    			sheet.addCell(new Label(col,row,data,cfR));
			    			}
			    			else if(data.equals("Green")){
			    				data = "";
			    			sheet.addCell(new Label(col,row,data,cfG));	
			    			}
			    			else if(data.equals("Yellow")){
			    				data = "";
				    			sheet.addCell(new Label(col,row,data,cfY));	
				    			}
			    			else {
			    				sheet.addCell(new Label(col,row,data,firstCell));	
			    			}
			    		}
			    		else{
			    			sheet.addCell(new Label(col, row, "",cf));
			    		}
			    	}

			    	else{
			    		if(dataStr==null){
			    			dataStr = "";
			    		}
			    		sheet.addCell(new Label(col, row, dataStr,cf));
			    	}
			    	
			    	int colSpanVal = colSpanList.get(i);
			    	if(colSpanVal > 1){
				    	int extraCell = colSpanVal - 1;
				    	sheet.mergeCells(col, row, col+extraCell, row);
				    	col = col + extraCell;
				    }
			    	col++;
			    }
			  
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		public ArrayList getColspanDataTypeList(String reportType,ArrayList headerList)
		{
			ArrayList colSpanDataTypeList = new ArrayList();
			ArrayList dataTypeList = new ArrayList();
			ArrayList<Integer> colSpanList = new ArrayList<Integer>();
			
			for(int i = 0; i < headerList.size(); i++)
			{
				dataTypeList.add("string");
				colSpanList.add(1);
			}
			
			colSpanDataTypeList.add(colSpanList);
			colSpanDataTypeList.add(dataTypeList);
			return colSpanDataTypeList;
		}  
		public int getCellEnd(){
			int cellEnd = 0;
			for(int i = 0; i < colSpanList.size(); i++){
				cellEnd = cellEnd + colSpanList.get(i);
			}
			cellEnd--;
			return (cellEnd + cellStart);
		}	
		
	private void refreshdir(String reportpath)
	{
		File f = new File(reportpath);
		if(!f.exists())
		{
			f.mkdirs();
		}
	}	
	/*.........................................writing into the excel,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/
	
	private void printExcel(HttpServletResponse response,ServletOutputStream servletOutputStream,int systemId,String division,String dateToDisplay,String excel)
	{
		try
		{			
			String formno=excel;
			response.setContentType("application/xls");
			response.setHeader("Content-disposition","attachment;filename="+formno+".xls");				
			DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);						
			FileInputStream fis = new FileInputStream(excel);
			byte [] buffer = new byte [1024];
			int len = 0;
			while ((len = fis.read(buffer)) >= 0 ) 
			{
				outputStream.write(buffer, 0, len);
			}
			servletOutputStream.flush();
			servletOutputStream.close();
		}
		catch (Exception e){
			e.printStackTrace();
		}
	}	
			
  }// DailyMonitoringReportExcel class close here
