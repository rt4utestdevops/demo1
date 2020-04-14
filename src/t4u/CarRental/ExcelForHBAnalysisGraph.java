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
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.Map;
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
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import jxl.write.Label;
import jxl.write.NumberFormats;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;

@SuppressWarnings("serial")
public class ExcelForHBAnalysisGraph extends HttpServlet {
	File outFile;
	int rowNo;
	int cellStart;
	int cellEnd;
	int mid;
	int leftAlign;
	ArrayList<String> dataHeaderList;
	Colour TITLE_BKG;
	Colour HEADER_BKG;
	WritableFont titleWF;
	WritableFont headerWF;
	WritableFont dataWF;
	WritableCellFormat floatFormat;
	WritableCellFormat floatCell;
	Colour TOP_HEADER_BKG;
	public static final String GET_DAYWISE_HB_DETAILS_ALL = "select REGISTRATION_NO,CAST(ROUND(AVERAGE,0) / 60 as INT) as mins,CAST(ROUND(AVERAGE,0) % 60 AS INT) as sec,dateadd(mi,?,GMT) as date," +
	" DATEDIFF(dd,dateadd(mi,-?,?),hb.GMT) as DAY from AMS.dbo.HB_ANALYSIS hb where hb.SYSTEM_ID=? and hb.CUSTOMER_ID=? and hb.GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?)";
	
	private static final String GET_REGISTRATION_NO_ALL = "select  REGISTRATION_NO,sum(TOTAL_HB_DUR_COUNT+1) as hbCOunt,sum(AVERAGE)/count(REGISTRATION_NO) average from AMS.dbo.HB_ANALYSIS" +
	" where SYSTEM_ID=? and CUSTOMER_ID=? and GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) group by REGISTRATION_NO order by count(REGISTRATION_NO)desc,average";
	
	private static final String GET_REGISTRATION_NO_CITY_WISE = "select  hb.REGISTRATION_NO,sum(hb.TOTAL_HB_DUR_COUNT+1) as hbCOunt,sum(hb.AVERAGE)/count(hb.REGISTRATION_NO) average" +
	" from AMS.dbo.HB_ANALYSIS hb" +
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=hb.CUSTOMER_ID and ag.GROUP_ID=hb.VEHICLE_GROUP"+
	" left outer join Maple.dbo.tblCity tc on tc.cityID=ag.CITY"+ 
	" where hb.SYSTEM_ID=? and hb.CUSTOMER_ID=? and ag.CITY=? and hb.GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?) group by hb.REGISTRATION_NO order by count(hb.REGISTRATION_NO)desc,average";
	
	private static final String GET_DAYWISE_HB_DETAILS_CITY_WISE = "select hb.REGISTRATION_NO,hb.TOTAL_HB_DUR_COUNT+1 as hbCount,CAST(ROUND(AVERAGE,0) / 60 as INT) as mins,"+ 
	" CAST(ROUND(AVERAGE,0) % 60 AS INT) as sec,dateadd(mi,?,hb.GMT) as date,DATEDIFF(dd,dateadd(mi,-?,?),hb.GMT) as DAY from AMS.dbo.HB_ANALYSIS hb"+
	" left outer join ADMINISTRATOR.dbo.ASSET_GROUP ag on ag.CUSTOMER_ID=hb.CUSTOMER_ID and ag.GROUP_ID=hb.VEHICLE_GROUP"+
	" left outer join Maple.dbo.tblCity tc on tc.cityID=ag.CITY"+ 
	" where hb.SYSTEM_ID=? and hb.CUSTOMER_ID=? and ag.CITY=? and hb.GMT between dateadd(mi,-?,?) and dateadd(mi,-?,?)";
	
@SuppressWarnings("unchecked")
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
	cellStart = 0;	
	TITLE_BKG = Colour.LIGHT_ORANGE;
	HEADER_BKG = Colour.ICE_BLUE;
	TOP_HEADER_BKG = Colour.LIGHT_TURQUOISE;
	titleWF = new WritableFont(WritableFont.ARIAL,14, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE, Colour.DARK_BLUE2);
	headerWF = new WritableFont(WritableFont.ARIAL,10, WritableFont.BOLD);
	dataWF = new WritableFont(WritableFont.ARIAL,8, WritableFont.BOLD);
	floatFormat = new WritableCellFormat(dataWF,NumberFormats.FLOAT);
	floatCell = new WritableCellFormat(floatFormat);
	
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd-MM-yyyy");
	
	int systemId =0;
	int clientId = 0;
	int offset = 0;
	String serviceDeliveredBy = "Rane t4u";
	ArrayList<String> headersList = new ArrayList<String>();
	try{   
		HttpSession session = request.getSession();
		LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");				
	    systemId = loginInfoBean.getSystemId();		        
	    clientId = loginInfoBean.getCustomerId();
		offset = loginInfoBean.getOffsetMinutes();
		
	    ServletOutputStream servletOutputStream=response.getOutputStream();
	    Properties properties = ApplicationListener.prop;
	    String excelpath =  properties.getProperty("Builtypath");
		refreshdir(excelpath);
		String formno="ExcelReport"+systemId;							
		String excel = excelpath+formno+".xls";
		File outFile = new File(excel);
		
		ArrayList<Object> finalList = null;
		String reportTitle=null;
		String fileName=null;
		String sheetName = null;
		int cityId = 0;
		String startDate = request.getParameter("startDate");
		String endDate = request.getParameter("endDate");
		if(request.getParameter("groupId") != null && !request.getParameter("groupId").equals("")){
			cityId = Integer.parseInt(request.getParameter("groupId"));
		}
		String cityName = request.getParameter("groupName");
		Date d1 = ddmmyyyy.parse(startDate);
		Date d2 = ddmmyyyy.parse(endDate);
		long diff = d2.getTime() - d1.getTime();
		int days = (int) TimeUnit.DAYS.convert(diff, TimeUnit.MILLISECONDS);
		long sDate = d1.getTime();
		long eDate = d2.getTime();

		reportTitle = "Harsh Brake Analysis Report";
		fileName="Harsh Brake Analysis Report-";
		sheetName="Harsh Brake Analysis Report";
		finalList = getdayWiseHBDetails(systemId,clientId,offset,sDate,days,offset,eDate,cityId);
		headersList = (ArrayList<String>) finalList.get(0);
		Map<String,dayWiseHBDetailsBean> beanMap=(LinkedHashMap<String, dayWiseHBDetailsBean>) finalList.get(1);
		prepareExcel(excel,systemId,request,headersList, headersList.size(),beanMap, cellStart, outFile,leftAlign,reportTitle,serviceDeliveredBy,sheetName,days,cityName);
		printExcel(response,servletOutputStream,systemId,excel,fileName+ ddmmyyyy.format(new Date()));
	}
	catch (Exception e){ e.printStackTrace();}
 }//end of doGet method
   
    @SuppressWarnings("unchecked")
	public void prepareExcel(String excel,int systemId,HttpServletRequest request,ArrayList headersList,int rowSize,Map<String,dayWiseHBDetailsBean> beanMap,int cellStart,
			File outFile,int leftAlign,String reportTitle,String serviceDeliveredBy,String sheetName,int noOfDays,String cityName){    
		this.dataHeaderList = headersList;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.leftAlign = leftAlign;
    	cellEnd = rowSize;
		mid = (cellStart+cellEnd) / rowSize;
		generateExcel(excel,reportTitle,headersList,rowSize,beanMap,systemId,request,serviceDeliveredBy,sheetName,noOfDays,cityName);		
    }
    
    @SuppressWarnings({ "unchecked", "deprecation" })
	public void generateExcel(String pdf,String reportTitle,ArrayList headersList,int rowSize,Map<String,dayWiseHBDetailsBean> beanMap,int systemId,HttpServletRequest request,
			String serviceDeliveredBy,String sheetName,int noOfDays,String cityName){	
		try{
			WritableWorkbook workbook = Workbook.createWorkbook(outFile);								
			int sheetNo = 1;
			WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
			for(int i = 0; i < rowSize; i ++){
				int startLineNo = i;
				if(startLineNo==0){
					rowNo = 0;
					writeReportTitle(sheet,reportTitle);
					writeHeader(sheet,headersList,rowSize,cityName);
					writeDataHeader(sheet,headersList,rowSize);
				    WritableCellFormat cf1 = new WritableCellFormat(dataWF);
				    cf1.setBackground(jxl.format.Colour.WHITE);
				    cf1.setBorder(Border.ALL,jxl.write.BorderLineStyle.THIN,Colour.GRAY_25);
				    cf1.setWrap(false);
					writeData(sheet,startLineNo,beanMap,rowSize,null,cf1,noOfDays);
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
 		
	@SuppressWarnings({ "deprecation", "unchecked" })
	private void writeHeader(WritableSheet sheet, ArrayList headersList, int rowSize,String cityName) {
		try{
		    WritableCellFormat cf = new WritableCellFormat(headerWF);
		    WritableCellFormat cf1 = new WritableCellFormat(headerWF);
		    WritableCellFormat cf2 = new WritableCellFormat(headerWF);
		    cf.setBackground(TOP_HEADER_BKG);
		    cf1.setBackground(TOP_HEADER_BKG);
		    cf2.setBackground(TOP_HEADER_BKG);
		    //cf.setBorder(Border.ALL,jxl.write.BorderLineStyle.THICK);
		    cf.setWrap(false);
		    cf1.setWrap(true);
		    cf2.setWrap(false);
		    
		    cf2.setBorder(Border.LEFT,jxl.write.BorderLineStyle.HAIR);
		    cf1.setBorder(Border.LEFT,jxl.write.BorderLineStyle.HAIR);
		    cf1.setAlignment(Alignment.CENTRE);
		   
		    int row = rowNo++;
		    int col = cellStart;
		    sheet.addCell(new Label(col,row,"City Name : "+cityName,cf));
	    	sheet.mergeCells(col, row, col+1, row);
	    	sheet.addCell(new Label(col+2,row,"",cf2));
	    	sheet.mergeCells(col+2, row, col+2, row);
		    sheet.addCell(new Label(col+3,row,"Each days average duration in mins",cf1));
		    sheet.mergeCells(col+3, row, rowSize, row);
		}
		catch(Exception e){	e.printStackTrace(); }
	}

	public void writeReportTitle(WritableSheet sheet,String reportTitle){
		try{
		    WritableCellFormat cf = new WritableCellFormat(titleWF);
		    cf.setBackground(TITLE_BKG);
		    cf.setAlignment(Alignment.CENTRE);
		    cf.setWrap(false);
		    	int row = rowNo++;
		    	Label title = new Label(cellStart,row,reportTitle,cf); 
		    	sheet.addCell(title);
		    	sheet.mergeCells(cellStart, row, cellEnd, row); 
		}catch(Exception e){ e.printStackTrace(); }
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
		    	sheet.mergeCells(cellStart, row, cellEnd, row); 
		}catch(Exception e){ e.printStackTrace(); }
	}
		
	@SuppressWarnings({ "unchecked", "deprecation" })
	public void writeDataHeader(WritableSheet sheet,ArrayList headersList,int rowSize){
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
		    Label label = null; 
		    sheet.addCell(new Label(col,row,"SLNO",cf));
	    	sheet.mergeCells(col, row, col, row);
	    	col++;
		    for(int i = 0; i < rowSize; i ++){
		    	label = new Label(col,row,(String) headersList.get(i),cf); 
			    sheet.addCell(label);
		    	sheet.mergeCells(col, row, col, row);
		    	col++;
		    }
		}
		catch(Exception e){	e.printStackTrace(); }
	}		
			
	public void writeData(WritableSheet sheet,int startLineNo,Map<String,dayWiseHBDetailsBean> beanMap,int rowSize,WritableCellFormat cf,WritableCellFormat cf1,
			int noOfDays){        
		try{
		    int slno=1;
		    int row=0;
		    int col=0;
		    Set<String> keySet = beanMap.keySet();
		    
		    for(String regNo: keySet){
		    	row = rowNo++;
			    col = cellStart;
			    sheet.addCell(new jxl.write.Number(col++,row,slno++,cf1));// For Auto increament SLNO
			    dayWiseHBDetailsBean bean= beanMap.get(regNo);
			    sheet.addCell(new Label(col++,row,bean.getRegNo(),cf1));
			    sheet.addCell(new Label(col++,row,bean.getHbCount()+"",cf1));
			    double []qtyArr={bean.getDay1(),bean.getDay2(),bean.getDay3(),bean.getDay4(),bean.getDay5(),bean.getDay6(),bean.getDay7(),bean.getDay8(),bean.getDay9(),
			    		bean.getDay10(),bean.getDay11(),bean.getDay12(),bean.getDay13(),bean.getDay14(),bean.getDay15(),bean.getDay16(),bean.getDay17(),bean.getDay18(),
			    		bean.getDay19(),bean.getDay20(), bean.getDay21(),bean.getDay22(),bean.getDay23(),bean.getDay24(),bean.getDay25(),bean.getDay26(),bean.getDay27(),
			    		bean.getDay28(),bean.getDay29(),bean.getDay30(),bean.getDay31()};
			    double totalQty=0;
			    for(int i=0;i<noOfDays;i++){
			    	sheet.addCell(new jxl.write.Number(col++,row,qtyArr[i],cf1));
			    	totalQty=totalQty+qtyArr[i];
			    }
			    sheet.addCell(new jxl.write.Number(col++,row,totalQty,cf1));
		    }
		}
		catch(Exception e){ System.out.println("Error in writeData"); e.printStackTrace(); }
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
			System.out.println("Error creating Excel for Stoppage Location :  "); e.printStackTrace();
		}
	}
	
	/*.........................................writing into the excel,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/
	
	private void printExcel(HttpServletResponse response,ServletOutputStream servletOutputStream,int systemId,String excel,String formno){
	try{			
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
	catch (Exception e){ e.printStackTrace(); }
	}
	
	public ArrayList<Object> getdayWiseHBDetails(int systemId,int custId, int userId, long startDate,int noOfDays, int offset, long endDate, int cityId){
		SimpleDateFormat sdf = new SimpleDateFormat("dd MMM yyyy");
		Map<String,dayWiseHBDetailsBean> beanMap = new LinkedHashMap<String,dayWiseHBDetailsBean>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList<Object> finlist = new ArrayList<Object>();
		ArrayList<String> headersList = new ArrayList<String>();
		headersList.add("Registration No");
		headersList.add("HB Count");
		for(int i=0;i<noOfDays;i++){
			headersList.add(sdf.format(new Date(startDate+(i*86400000L))));
		}
		headersList.add("TOTAL");
		try {
			con = DBConnection.getConnectionToDB("AMS");
			if(cityId == 0){
				pstmt = con.prepareStatement(GET_REGISTRATION_NO_ALL);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,custId);
				pstmt.setInt(3, offset);
				pstmt.setDate(4, new java.sql.Date(startDate));
				pstmt.setInt(5, offset);
				pstmt.setDate(6, new java.sql.Date(endDate));
			}else{
				pstmt = con.prepareStatement(GET_REGISTRATION_NO_CITY_WISE);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,custId);
				pstmt.setInt(3,cityId);
				pstmt.setInt(4, offset);
				pstmt.setDate(5, new java.sql.Date(startDate));
				pstmt.setInt(6, offset);
				pstmt.setDate(7, new java.sql.Date(endDate));
			}
			
			rs= pstmt.executeQuery();
			while (rs.next()) {
				dayWiseHBDetailsBean bean = new dayWiseHBDetailsBean();
				bean.setRegNo(rs.getString("REGISTRATION_NO"));
				bean.setHbCount(rs.getInt("hbCOunt"));
				beanMap.put(rs.getString("REGISTRATION_NO"), bean);
			}
			if(cityId == 0){
				pstmt = con.prepareStatement(GET_DAYWISE_HB_DETAILS_ALL);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setDate(3, new java.sql.Date(startDate));
				pstmt.setInt(4,systemId);
				pstmt.setInt(5,custId);
				pstmt.setInt(6, offset);
				pstmt.setDate(7, new java.sql.Date(startDate));
				pstmt.setInt(8, offset);
				pstmt.setDate(9, new java.sql.Date(endDate));
			}else{
				pstmt = con.prepareStatement(GET_DAYWISE_HB_DETAILS_CITY_WISE);
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setDate(3, new java.sql.Date(startDate));
				pstmt.setInt(4,systemId);
				pstmt.setInt(5,custId);
				pstmt.setInt(6,cityId);
				pstmt.setInt(7, offset);
				pstmt.setDate(8, new java.sql.Date(startDate));
				pstmt.setInt(9, offset);
				pstmt.setDate(10, new java.sql.Date(endDate));
			}
			rs= pstmt.executeQuery();
			while (rs.next()) {
				dayWiseHBDetailsBean bean = null;
				bean=beanMap.get(rs.getString("REGISTRATION_NO"));
				switch (rs.getInt("DAY")) {
				case 1:{bean.setDay1(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));   break;}
				case 2:{bean.setDay2(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 3:{bean.setDay3(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 4:{bean.setDay4(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 5:{bean.setDay5(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 6:{bean.setDay6(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 7:{bean.setDay7(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 8:{bean.setDay8(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 9:{bean.setDay9(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 10:{bean.setDay10(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 11:{bean.setDay11(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 12:{bean.setDay12(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 13:{bean.setDay13(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 14:{bean.setDay14(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 15:{bean.setDay15(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 16:{bean.setDay16(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 17:{bean.setDay17(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 18:{bean.setDay18(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 19:{bean.setDay19(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 20:{bean.setDay20(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 21:{bean.setDay21(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 22:{bean.setDay22(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 23:{bean.setDay23(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 24:{bean.setDay24(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 25:{bean.setDay25(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 26:{bean.setDay26(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 27:{bean.setDay27(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 28:{bean.setDay28(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 29:{bean.setDay29(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 30:{bean.setDay30(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				case 31:{bean.setDay31(Double.parseDouble(rs.getInt("mins")+"."+rs.getInt("sec")));	break;}
				default: break;
			}
			finlist.add(headersList);
			finlist.add(beanMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}
  }
