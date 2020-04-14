package t4u.CarRental;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import jxl.write.Label;
import jxl.write.NumberFormats;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;

import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;

public class StoppageLocationExcel extends HttpServlet {
	File outFile;
	int rowNo;
	int cellStart;
	int cellEnd;
	int mid;
	int noOfLinesPerSheet;
	int cc;
	int st;
	int leftAlign;
	ArrayList dataHeaderList;
	ArrayList<Integer> colSpanList;
	ArrayList dataList;	
	ArrayList dataTypeList;
	
	Colour BLANK_ROW_BKG ;
	Colour TITLE_BKG;
	Colour HEADER_BKG;
	
	WritableFont titleWF;
	WritableFont headerWF;
	WritableFont dataWF;
	WritableCellFormat intFormat;
	WritableCellFormat intCell;		
	WritableCellFormat floatFormat;
	WritableCellFormat floatCell;	

	Date  curDate;
	Calendar cal;
	SimpleDateFormat sdf;
	SimpleDateFormat df;
	public static final String GET_DAYWISE_STOP_DETAILS = "select isnull(tc1.STATE_NAME,'')as STATE,isnull(a.DISTANCE,0) as DISTANCE,a.ASSET_NUMBER,a.GROUP_ID,isnull(b.GROUP_NAME,'')as GROUP_NAME,isnull(tc.CityName,'')as CITY,a.COMMUNICATING,dateadd(mi,330,a.DATE)as DATE,(isnull(a.DURATION,' ')+'##'+isnull(a.LOCATION,' ')+'##'+CONVERT(varchar(10), isnull(a.DISTANCE,0)))as LOCATION from AMS.dbo.DAYWISE_STOP_DETAILS a "+ 
														" left outer join ADMINISTRATOR.dbo.ASSET_GROUP b on a.GROUP_ID=b.GROUP_ID and a.SYSTEM_ID=b.SYSTEM_ID and a.CUSTOMER_ID=b.CUSTOMER_ID "+
														" left outer join Maple.dbo.tblCity tc on tc.CityID=b.CITY "+
														" left outer join ADMINISTRATOR.dbo.STATE_DETAILS tc1 on tc1.STATE_CODE=b.STATE "+
														" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.GROUP_ID in (#) and a.DATE>dateadd(dd,-31,getUtcDate()) order by a.GROUP_ID,a.ASSET_NUMBER desc ";
	
    @SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
    	cellStart = 0;
    	cc = 0;
    	st = 0;
    	colSpanList = new ArrayList<Integer>();
    	
    	BLANK_ROW_BKG = Colour.LIGHT_ORANGE;
    	TITLE_BKG = Colour.LIGHT_ORANGE;
    	HEADER_BKG = Colour.ICE_BLUE;
    	
    	titleWF = new WritableFont(WritableFont.ARIAL,14, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE, Colour.DARK_BLUE2);
    	headerWF = new WritableFont(WritableFont.ARIAL,10, WritableFont.BOLD);
    	dataWF = new WritableFont(WritableFont.ARIAL,8, WritableFont.BOLD);
    	intFormat = new WritableCellFormat(dataWF,NumberFormats.INTEGER);
    	intCell = new WritableCellFormat(intFormat);		
    	floatFormat = new WritableCellFormat(dataWF,NumberFormats.FLOAT);
    	floatCell = new WritableCellFormat(floatFormat);
    	
    	curDate=new Date();
    	cal=Calendar.getInstance();
    	sdf = new SimpleDateFormat("dd MMMMM yyyy");
    	df = new SimpleDateFormat("dd/MM/yy");
    	
    	
    	int systemId =0;
   		String clientid = "";
   		int offset=0;
   		String serviceDeliveredBy = "Rane t4u";
   		JSONArray jsonarray = new JSONArray();
   		ArrayList<String> datalists = new ArrayList<String>();
   		ArrayList reportList = new ArrayList();	    
		ArrayList<String> headersList = new ArrayList<String>();
		
		String reportTitle = "Stoppage Location Report";
		int nonDateHeaders = 8;//Slno,VehicleNumber,GroupName,City,GPSStatus,Remarks,Severity Flag,State
		
   		try
		      {   
				HttpSession session = request.getSession();
				LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");				
			    systemId = loginInfoBean.getSystemId();		        
		        offset=loginInfoBean.getOffsetMinutes();
				clientid= request.getParameter("custId");
				String selectedGroup= request.getParameter("selectedGroup")!=null?request.getParameter("selectedGroup"):"";

				headersList.add("SlNo");
				headersList.add("Vehicle Number");
				headersList.add("Group Name");
				headersList.add("City");
				headersList.add("GPS Communicating");
				headersList.add("Remarks");
				headersList.add("Severity Flag");
				headersList.add("State");
				for(int i=1;i<=30;i++){
					headersList.add(sdf.format(new Date(curDate.getTime()-i*24*60*60*1000l)));
				}

				List<StoppageLocationReportBean> beanList=getStoppageLoctionDetails(systemId,Integer.parseInt(clientid),selectedGroup);
				Collections.sort(beanList);
			    for (StoppageLocationReportBean bean :beanList) {				
					datalists = new ArrayList<String>();
					
					datalists.add(bean.getAssetNo());
					datalists.add(bean.getGroupName());
					datalists.add(bean.getCity());
					datalists.add(bean.getCommStatus());
					datalists.add(bean.getRemarks());
					datalists.add(bean.getSeverity());
					datalists.add(bean.getState());
					String []strArr = bean.getDay1().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay2().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay3().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay4().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay5().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay6().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay7().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay8().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay9().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay10().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay11().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay12().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay13().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay14().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay15().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay16().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay17().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay18().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay19().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay20().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay21().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay22().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay23().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay24().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay25().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay26().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay27().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay28().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay29().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
					
					strArr = bean.getDay30().split("##");
					datalists.add(strArr.length>1?strArr[1]:" ");
					datalists.add(strArr[0]!=null?strArr[0]:" ");
					datalists.add(strArr.length>2?strArr[2]:"0");
				
					reportList.add(datalists);										
				     }				
			    ServletOutputStream servletOutputStream=response.getOutputStream();
			    Properties properties = ApplicationListener.prop;
			    String excelpath =  properties.getProperty("Builtypath");
				refreshdir(excelpath);
				String formno="StoppageLocationReport"+systemId;							
				String excel = excelpath+formno+".xls";
				File outFile = new File(excel);

		ArrayList colSpanDataTypeList = getColspanDataTypeList("string",headersList,nonDateHeaders);
		ArrayList<Integer> colSpanList = (ArrayList)colSpanDataTypeList.get(0);
		ArrayList dataTypeList = (ArrayList)colSpanDataTypeList.get(1);
		int noOfLinePerSheet = reportList.size();
			

		prepareExcel(excel,systemId,request,headersList, reportList,colSpanList, dataTypeList, cellStart, noOfLinePerSheet,outFile,leftAlign,reportTitle,serviceDeliveredBy,nonDateHeaders);						
		printExcel(response,servletOutputStream,systemId,excel,"Stoppage Location Report-"+df.format(curDate));

	}
	catch (Exception e) 
	{
		e.printStackTrace();
	}
	
 }//end of doget method
   
    @SuppressWarnings("unchecked")
	public void prepareExcel(String excel,int systemId,HttpServletRequest request,ArrayList headersList,ArrayList reportList,ArrayList<Integer> colSpanList,ArrayList dataTypeList,int cellStart,int noOfLinesPerSheet,File outFile,int leftAlign,String reportTitle,String serviceDeliveredBy,int nonDateHeaders){    
		this.dataHeaderList = headersList;
		this.colSpanList = colSpanList;
		this.dataList = reportList;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.leftAlign = leftAlign;
		this.dataTypeList = dataTypeList;
    	this.colSpanList.add(0,1);
    	this.dataTypeList.add(0,"int");		
    	cellEnd = getCellEnd();
		mid = (cellStart+cellEnd) / 9;
		this.noOfLinesPerSheet = noOfLinesPerSheet;
		
		generateExcel(excel,reportTitle,headersList,reportList,noOfLinesPerSheet,systemId,request,serviceDeliveredBy,nonDateHeaders);		
	
    }
    
    @SuppressWarnings("unchecked")
	public void generateExcel(String pdf,String reportTitle,ArrayList headersList,ArrayList reportList,int noOfLinesPerSheet,int systemId,HttpServletRequest request,String serviceDeliveredBy,int nonDateHeaders){	
			
			try{
				
				WritableWorkbook workbook = Workbook.createWorkbook(outFile);								
				int dataSize = reportList.size();
				int sheetNo = 0;
				String sheetName = "Stoppage Location Report";
				WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
				for(int i = 0; i < reportList.size(); i ++){
					int startLineNo = i;
					int endLineNo = (i+noOfLinesPerSheet)>dataSize?dataSize:(i+noOfLinesPerSheet);
					if(startLineNo==0){
						rowNo = 0;
						writeReportTitle(sheet,reportTitle);
						writeDataHeader(sheet,nonDateHeaders);
						writeData(sheet,startLineNo,endLineNo);
						writeReportFooter(sheet,serviceDeliveredBy);
						
					}
				}	
				workbook.write();
			    workbook.close();
		
			}catch(Exception e){
				System.out.println("Error in generateExcel");
				e.printStackTrace();
			}
		
		}//end generate
		
		
		public void writeReportTitle(WritableSheet sheet,String reportTitle){
			try{
			    WritableCellFormat cf = new WritableCellFormat(titleWF);
			    cf.setBackground(TITLE_BKG);
			    cf.setAlignment(Alignment.CENTRE);
			    cf.setWrap(false);
			    	int row = rowNo++;
			    	Label title = new Label(cellStart,row,reportTitle,cf); 
			    	sheet.addCell(title);
			    	sheet.mergeCells(cellStart, row, cellEnd-1, row); 
				    
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		public void writeReportFooter(WritableSheet sheet,String serviceDeliveredBy){
			try{
			    WritableCellFormat cf = new WritableCellFormat(headerWF);
			    cf.setBackground(HEADER_BKG);
			    cf.setAlignment(Alignment.CENTRE);
			    cf.setWrap(false);
			    	int row = rowNo++;
			    	Label title = new Label(cellStart,row,"Service Delivered By - "+serviceDeliveredBy,cf); 
			    	sheet.addCell(title);
			    	sheet.mergeCells(cellStart, row, cellEnd-1, row); 
				    
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		
		@SuppressWarnings("deprecation")
		public void writeDataHeader(WritableSheet sheet,int nonDateHeaders){

			try{
			    WritableCellFormat cf = new WritableCellFormat(headerWF);
			    cf.setBackground(HEADER_BKG);
			    //cf.setBorder(Border.ALL,jxl.write.BorderLineStyle.THICK);
			    cf.setWrap(false);
			    WritableCellFormat cf1 = new WritableCellFormat(headerWF);
			    cf1.setBackground(jxl.format.Colour.LIME);
			    cf1.setBorder(Border.LEFT,jxl.write.BorderLineStyle.HAIR);
			    cf1.setAlignment(Alignment.CENTRE);
			    cf1.setWrap(false);
			    int row = rowNo++;
			    int col = cellStart;
			    int size =  dataHeaderList.size();
			    for(int i = 0; i < size; i ++){
			    	String lbStr = (String) dataHeaderList.get(i);
			    	int colSpanVal = colSpanList.get(i);
			    	Label label = null;
				    
				    if(i<nonDateHeaders){
				    	label = new Label(col,row,lbStr,cf); 
					    sheet.addCell(label);
				    	sheet.mergeCells(col, row, col, row+1);
				    }else{
				    	label = new Label(col,row,lbStr,cf1); 
					    sheet.addCell(label);
				    	sheet.mergeCells(col, row, col+2, row);
				    	
				    	label = new Label(col,row+1,"Location",cf); 
					    sheet.addCell(label);
				    	sheet.mergeCells(col, row+1, col, row+1);
				    	
				    	label = new Label(col+1,row+1,"Duration(HH:MM:SS)",cf); 
					    sheet.addCell(label);
				    	sheet.mergeCells(col+1, row+1, col+1, row+1);
				    	
				    	label = new Label(col+2,row+1,"Distance From Center",cf); 
					    sheet.addCell(label);
				    	sheet.mergeCells(col+2, row+1, col+2, row+1);
				    	
				    	col+=2;
				    	//sheet.mergeCells(col, row, col, row+1);
				    }
				    if(colSpanVal > 1){
				    	int extraCell = colSpanVal - 1;
				    	sheet.mergeCells(col, row, col+extraCell, row);
				    	col = col + extraCell;
				    }
				    col++;
			    }
			    rowNo++;
			}
			catch(Exception e){
				e.printStackTrace();
			}
		
		}		
			
		@SuppressWarnings("unchecked")
		public void writeData(WritableSheet sheet,int startLineNo,int endLineNo){        
         cc=0;
			try{
				WritableCellFormat cf =null;
			    WritableCellFormat cf1 = new WritableCellFormat(dataWF);
			    cf1.setBackground(jxl.format.Colour.GRAY_25);
			    cf1.setWrap(false);
			    WritableCellFormat cf2 = new WritableCellFormat(dataWF);
			    cf2.setBackground(jxl.format.Colour.LIGHT_TURQUOISE);
			    cf2.setWrap(false);
				
				for(int i = startLineNo; i < endLineNo; i ++){
					if(i%2==0){
						cf=cf1;
					}else{
						cf=cf2;
					}
			    	if(dataList.get(i)!=null && dataList.get(i) instanceof ArrayList){
			    	ArrayList rowList = (ArrayList)dataList.get(i);			    	
			    	createDataRow(rowList,sheet,"dataRow",cf);	
			    	}			    	
			    }
			}
			catch(Exception e){
				System.out.println("Error in writeData");
				e.printStackTrace();
			}
		
	  }

		@SuppressWarnings("unchecked")
		public void createDataRow(ArrayList rowList,WritableSheet sheet,String rowtype,WritableCellFormat cf)
		{
			try{
			    
			    WritableCellFormat firstCell = new WritableCellFormat(intFormat);
			    firstCell.setWrap(false);
			    firstCell.setAlignment(Alignment.LEFT);
			    WritableCellFormat cfC = new WritableCellFormat(dataWF);
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
		    			sheet.addCell(new jxl.write.Number(col,row,data,cf));
		    		}
		    		else{
		    			sheet.addCell(new Label(col, row,"",cf));
		    		}
		    	}			    	
			   	 else if(type.equals("string") && rowtype.equals("dataRow")){
			    		if(dataStr != null && !dataStr.equals("")){			    			
			    			String data = dataStr;
			    			sheet.addCell(new Label(col,row,data,cf));	
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
			    	
			   	  	if (dataStr.equalsIgnoreCase("L1")){
			   	  		cfC.setBackground(jxl.format.Colour.YELLOW);
			    		sheet.addCell(new Label(col, row, dataStr,cfC));
			    	}else if (dataStr.equalsIgnoreCase("L2")){
			    		cfC.setBackground(jxl.format.Colour.ORANGE);
			    		sheet.addCell(new Label(col, row, dataStr,cfC));
			    	}else if (dataStr.equalsIgnoreCase("L3")){
			    		cfC.setBackground(jxl.format.Colour.RED);
			    		sheet.addCell(new Label(col, row, dataStr,cfC));
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
				System.out.println("Error in createDataRow");
				e.printStackTrace();
			}
		}
		@SuppressWarnings("unchecked")
		public ArrayList getColspanDataTypeList(String reportType,ArrayList headerList,int nonDateHeaders)
		{
			ArrayList colSpanDataTypeList = new ArrayList();
			ArrayList dataTypeList = new ArrayList();
			ArrayList<Integer> colSpanList = new ArrayList<Integer>();
			for(int i = 0; i < (headerList.size()*3)-nonDateHeaders; i++)
			{
				dataTypeList.add(reportType);
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
		
	/** if directory not exists then create it */	
	private void refreshdir(String reportpath)
	{
		try{
		File f = new File(reportpath);
		if(!f.exists())
		{
			f.mkdirs();
		}
		}catch (Exception e) {
			System.out.println("Error creating Excel for Stoppage Location :  ");
			e.printStackTrace();
		}
	}
	
	/*.........................................writing into the excel,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/
	
	private void printExcel(HttpServletResponse response,ServletOutputStream servletOutputStream,int systemId,String excel,String formno)
	{
		try
		{			
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
	public List<StoppageLocationReportBean> getStoppageLoctionDetails(int systemId,int clientid,String selectedGroup)
	{
		List<StoppageLocationReportBean> beanList = new ArrayList<StoppageLocationReportBean>();
		StoppageLocationReportBean bean = null;
		List<JSONObject>jsonArrayDB = null;
		JSONObject jsonObject = null;
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		
		try 
		{
			con = DBConnection.getConnectionToDB("AMS");
			jsonArrayDB = new ArrayList<JSONObject>();
			jsonObject = new JSONObject();
			Set<String> assetSet =new HashSet<String>();
			pstmt = con.prepareStatement(GET_DAYWISE_STOP_DETAILS.replace("(#)", "("+selectedGroup+")"));
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,clientid);
			rs = pstmt.executeQuery();
			while (rs.next()) 
			{
				jsonObject = new JSONObject();
				assetSet.add(rs.getString("ASSET_NUMBER"));
				jsonObject.put("assetNo", rs.getString("ASSET_NUMBER"));
				jsonObject.put("groupId", rs.getInt("GROUP_ID"));
				jsonObject.put("commStatus", rs.getString("COMMUNICATING"));
				jsonObject.put("groupName", rs.getString("GROUP_NAME"));
				jsonObject.put("city", rs.getString("CITY"));
				jsonObject.put("day", TimeUnit.DAYS.convert(curDate.getTime() - rs.getDate("DATE").getTime(),TimeUnit.MILLISECONDS));
				jsonObject.put("location", rs.getString("LOCATION"));
				jsonObject.put("distance", rs.getString("DISTANCE"));
				jsonObject.put("state",rs.getString("STATE"));
				jsonArrayDB.add(jsonObject);	
			}
			con.close();
			for (String asset : assetSet) {
				bean=new StoppageLocationReportBean();
				int i=0,j=0,k=0;
				String sFlag="None";
				for (JSONObject jObj : jsonArrayDB) {
					if(asset.equals(jObj.getString("assetNo"))){
						int day=jObj.getInt("day");
						bean.setAssetNo(asset);
						bean.setGroupNo(jObj.getInt("groupId"));
						bean.setGroupName(jObj.getString("groupName"));
						bean.setCity(jObj.getString("city"));
						bean.setState(jObj.getString("state"));
						if(day==1){
							bean.setCommStatus(jObj.getString("commStatus"));
						}
						String distance=jObj.getString("distance");
						if(day<5 && Double.parseDouble(distance)>=100){i++;}
						if(day<4 && Double.parseDouble(distance)>=100){j++;}
						if(day<3 && Double.parseDouble(distance)>=100){k++;}
						if(k==2){sFlag="L1";}
						if(j==3){sFlag="L2";}
						if(i==4){sFlag="L3";}
						if(day==1 && Double.parseDouble(distance)>=200){
							sFlag="L2";
						}if(day==1 && Double.parseDouble(distance)>=300){
							sFlag="L3";
						}
						bean.setSeverity(sFlag);
						bean.setDistance(Double.parseDouble(distance));
						switch (day) {
						case 1:{bean.setDay1(jObj.getString("location")); break;}
						case 2:{bean.setDay2(jObj.getString("location")); break;}
						case 3:{bean.setDay3(jObj.getString("location")); break;}
						case 4:{bean.setDay4(jObj.getString("location")); break;}
						case 5:{bean.setDay5(jObj.getString("location")); break;}
						case 6:{bean.setDay6(jObj.getString("location")); break;}
						case 7:{bean.setDay7(jObj.getString("location")); break;}
						case 8:{bean.setDay8(jObj.getString("location")); break;}
						case 9:{bean.setDay9(jObj.getString("location")); break;}
						case 10:{bean.setDay10(jObj.getString("location"));	break;}
						case 11:{bean.setDay11(jObj.getString("location"));	break;}
						case 12:{bean.setDay12(jObj.getString("location"));	break;}
						case 13:{bean.setDay13(jObj.getString("location"));	break;}
						case 14:{bean.setDay14(jObj.getString("location"));	break;}
						case 15:{bean.setDay15(jObj.getString("location"));	break;}
						case 16:{bean.setDay16(jObj.getString("location"));	break;}
						case 17:{bean.setDay17(jObj.getString("location"));	break;}
						case 18:{bean.setDay18(jObj.getString("location"));	break;}
						case 19:{bean.setDay19(jObj.getString("location"));	break;}
						case 20:{bean.setDay20(jObj.getString("location"));	break;}
						case 21:{bean.setDay21(jObj.getString("location"));	break;}
						case 22:{bean.setDay22(jObj.getString("location"));	break;}
						case 23:{bean.setDay23(jObj.getString("location"));	break;}
						case 24:{bean.setDay24(jObj.getString("location"));	break;}
						case 25:{bean.setDay25(jObj.getString("location"));	break;}
						case 26:{bean.setDay26(jObj.getString("location"));	break;}
						case 27:{bean.setDay27(jObj.getString("location"));	break;}
						case 28:{bean.setDay28(jObj.getString("location"));	break;}
						case 29:{bean.setDay29(jObj.getString("location"));	break;}
						case 30:{bean.setDay30(jObj.getString("location"));	break;}
						default: break;
						}
					}
				}
				beanList.add(bean);
			}
		} 
		catch (Exception e){	
			e.printStackTrace();	
		} 
		finally 
		{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return beanList;
	}
			
  }// StoppageLocationExcel class close here
