package t4u.GeneralVertical;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

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
import t4u.functions.CommonFunctions;
import t4u.functions.GeneralVerticalFunctions;
import t4u.statements.GeneralVerticalStatements;

@SuppressWarnings("serial")
public class SmartHubWeeklyReport extends HttpServlet {

	File outFile;
	int rowNo;
	int cellStart;
	int cellEnd;
	int mid;
	int leftAlign;
	ArrayList<ArrayList<String>> dataHeaderList;
	Colour TITLE_BKG;
	Colour HEADER_BKG;
	WritableFont titleWF;
	WritableFont headerWF;
	WritableFont dataWF;
	WritableCellFormat floatFormat;
	WritableCellFormat floatCell;	

	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	SimpleDateFormat sdf1 = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");//yyu
	SimpleDateFormat sdfDBMMDD = new SimpleDateFormat("yyyy-MM-dd");		
	SimpleDateFormat mmddyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");	
	SimpleDateFormat timef = new SimpleDateFormat("HH:mm");
	SimpleDateFormat timenew = new SimpleDateFormat("HH:mm:ss");
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy");
	DecimalFormat df = new DecimalFormat("00.00");
	DecimalFormat df1=new DecimalFormat("#.##");
	DecimalFormat df2=new DecimalFormat("0.00");
	DecimalFormat df3 = new DecimalFormat("00");
	CommonFunctions cf = new CommonFunctions();
	GeneralVerticalFunctions gf = new GeneralVerticalFunctions();
	
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	cellStart = 0;	
	TITLE_BKG = Colour.LIGHT_ORANGE;
	HEADER_BKG = Colour.ICE_BLUE;
	
	titleWF = new WritableFont(WritableFont.ARIAL,14, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE, Colour.DARK_BLUE2);
	headerWF = new WritableFont(WritableFont.ARIAL,10, WritableFont.BOLD);
	dataWF = new WritableFont(WritableFont.ARIAL,8, WritableFont.BOLD);
	floatFormat = new WritableCellFormat(dataWF,NumberFormats.FLOAT);
	floatCell = new WritableCellFormat(floatFormat);
	
	int systemId =0;
	int custId = 0;
	String zone = "A";
	String serviceDeliveredBy = "Rane t4u";
	ArrayList<String> headersList1 = new ArrayList<String>();
	ArrayList<String> headersList2 = new ArrayList<String>();
	ArrayList<String> headersList3 = new ArrayList<String>();
	ArrayList<String> headersList4 = new ArrayList<String>();
	try{   
		HttpSession session = request.getSession();
		LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");				
	    systemId = loginInfoBean.getSystemId();		        
		custId= loginInfoBean.getCustomerId();
		zone = loginInfoBean.getZone();
		
		headersList1.add("Trip Status");
		headersList1.add("Trip No");
		headersList1.add("Vehicle No");
		headersList1.add("ETA (HH:MM)");
		headersList1.add("STA wrt ATD");
		headersList1.add("Delay");
		headersList1.add("Net Delay");
        
		headersList2.add("Trip Status");
		headersList2.add("Trip ID");
		headersList2.add("Trip No");
		headersList2.add("ATP");
		headersList2.add("Placement Delay");
		headersList2.add("ATD");
		headersList2.add("Next Touch Point");
		headersList2.add("ETA to Destination");
		headersList2.add("STA wrt ATD");
		headersList2.add("ATA@Destination");
		
		headersList3.add("Trip Status");
		headersList3.add("Trip ID");
		headersList3.add("Trip No");
		headersList3.add("ETA (HH:MM)");
		headersList3.add("STA");
		headersList3.add("Delay");
		headersList3.add("Net Delay");
		
		headersList4.add("Trip Status");
		headersList4.add("Trip No");
		headersList4.add("Vehicle No");
		headersList4.add("ATA@SH");
		headersList4.add("ATD@SH");
		headersList4.add("Excess Detention");
        
        
	    ServletOutputStream servletOutputStream=response.getOutputStream();
	    Properties properties = ApplicationListener.prop;
	    String excelpath =  properties.getProperty("Builtypath");
		refreshdir(excelpath);
		String formno="ExcelReport"+systemId;							
		String excel = excelpath+formno+".xls";
		File outFile = new File(excel);
		
		ArrayList<ArrayList<String>> headersListArr = new ArrayList<ArrayList<String>>();
		ArrayList<Integer> rowSizeList = new ArrayList<Integer>();
		ArrayList<List<ArrayList<String>>> dataList = new ArrayList<List<ArrayList<String>>>();
		ArrayList<String> sheetNameList = new ArrayList<String>();
		
		headersListArr.add(headersList1);
		headersListArr.add(headersList2);
		headersListArr.add(headersList3);
		headersListArr.add(headersList4);
		
		rowSizeList.add(headersList1.size());
		rowSizeList.add(headersList2.size());
		rowSizeList.add(headersList3.size());
		rowSizeList.add(headersList4.size());
		
		String reportTitle=null;
		String fileName=null;
		int offset = loginInfoBean.getOffsetMinutes();//Integer.parseInt(request.getParameter("offset"));
		int userId = loginInfoBean.getUserId();//Integer.parseInt(request.getParameter("userId"));
		String hubIds = request.getParameter("hubIds");
		String startDate = sdfDB.format(ddmmyyyy.parse(request.getParameter("startDate")));
        String endDate = sdfDB.format(ddmmyyyy.parse(request.getParameter("endDate")));
		reportTitle = "Smart Hub Report";
		fileName="Smart Hub Report";
		List<ArrayList<String>> inboundSHTrips = getInBoundSHTrips(systemId, custId, offset, userId, hubIds, startDate, endDate);
		List<ArrayList<String>> outboundCHTrips = getOutBoundOriginCHTrips(systemId, custId, offset, userId, hubIds, startDate, endDate, zone);
		List<ArrayList<String>> inboundDestTrips = getInBoundDestinationCHTrips(systemId, custId, offset, userId, hubIds, startDate, endDate,zone);
		List<ArrayList<String>> outboundSHTrips = getOutBoundSHTrips(systemId, custId, offset, userId, hubIds, startDate, endDate);
		
		dataList.add(inboundSHTrips);
		dataList.add(outboundCHTrips);
		dataList.add(inboundDestTrips);
		dataList.add(outboundSHTrips);
		
		sheetNameList.add("Inbound Smart Hub - Leg Level");
		sheetNameList.add("Outbound Origin - Customer Hub - Trip Level");
		sheetNameList.add("Inbound Destination - Customer Hub - Trip Level");
		sheetNameList.add("Outbound Intransit Smart Hub - Leg Level");
		
		prepareExcel(excel,systemId,request,headersListArr,rowSizeList,dataList,cellStart,outFile,leftAlign,reportTitle,serviceDeliveredBy,sheetNameList);
		printExcel(response,servletOutputStream,systemId,excel,fileName);
	}
	catch (Exception e){
		e.printStackTrace();
	}
 }//end of doGet method

	public void prepareExcel(String excel,int systemId,HttpServletRequest request,ArrayList<ArrayList<String>> headersListArr,ArrayList<Integer> rowSizeList,ArrayList<List<ArrayList<String>>> dataList,int cellStart,File outFile,int leftAlign,String reportTitle,String serviceDeliveredBy,ArrayList<String> sheetNameList){    
		this.dataHeaderList = headersListArr;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.leftAlign = leftAlign;
		generateExcel(excel,reportTitle,headersListArr,rowSizeList,dataList,systemId,request,serviceDeliveredBy,sheetNameList);		
    }
	@SuppressWarnings("deprecation")
	public void generateExcel(String pdf,String reportTitle,ArrayList<ArrayList<String>> headersListArr,ArrayList<Integer> rowSizeList,ArrayList<List<ArrayList<String>>> dataList,int systemId,HttpServletRequest request,String serviceDeliveredBy,ArrayList<String> sheetNameList){	
		try{
			WritableWorkbook workbook = Workbook.createWorkbook(outFile);								
			int sheetNo = 1;
			for(int j = 0; j<4;j++){
				cellEnd = rowSizeList.get(j);
				mid = (cellStart+cellEnd) / rowSizeList.get(j);
				WritableSheet sheet = workbook.createSheet(sheetNameList.get(j), sheetNo);
				for(int i = 0; i < rowSizeList.get(j); i ++){
					int startLineNo = i;
					if(startLineNo==0){
						rowNo = 0;
						writeReportTitle(sheet,reportTitle);
						writeDataHeader(sheet,headersListArr.get(j),rowSizeList.get(j));
						WritableCellFormat cf1 = new WritableCellFormat(dataWF);
					    cf1.setBackground(jxl.format.Colour.WHITE);
					    cf1.setBorder(Border.ALL,jxl.write.BorderLineStyle.THIN,Colour.GRAY_25);
					    cf1.setWrap(false);
					    WritableCellFormat cff1 = new WritableCellFormat(floatCell);
					    cff1.setWrap(false);
						writeData(sheet,startLineNo,dataList.get(j),rowSizeList.get(j),cf1,cff1);
						writeReportFooter(sheet,serviceDeliveredBy);
					}
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
		    	sheet.mergeCells(cellStart, row, cellEnd, row); 
		}catch(Exception e){ e.printStackTrace(); }
	}
	
	public void writeReportFooter(WritableSheet sheet,String serviceDeliveredBy){
		try{
		    WritableCellFormat cf = new WritableCellFormat(headerWF);
		    cf.setBackground(Colour.LIGHT_ORANGE);
		    cf.setAlignment(Alignment.CENTRE);
		    cf.setWrap(false);
		    	int row = rowNo++;
		    	Label title = new Label(cellStart,row,"Service Delivered By - "+serviceDeliveredBy,cf); 
		    	sheet.addCell(title);
		    	sheet.mergeCells(cellStart, row, cellEnd, row); 
		}catch(Exception e){ e.printStackTrace(); }
	}
		
	@SuppressWarnings({ "deprecation" })
	public void writeDataHeader(WritableSheet sheet,ArrayList<String> headersListArr,int rowSize){
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
		    	label = new Label(col,row,headersListArr.get(i),cf); 
			    sheet.addCell(label);
		    	sheet.mergeCells(col, row, col, row);
		    	col++;
		    }
		}
		catch(Exception e){	e.printStackTrace(); }
	}		
	public void writeData(WritableSheet sheet,int startLineNo,List<ArrayList<String>> dataList,int rowSize,WritableCellFormat cf,WritableCellFormat cf1){        
		try{
		    int slno=1;
		    int row=0;
		    int col=0;
		    for(int k = 0;k<dataList.size();k++){

		    	row = rowNo++;
			    col = cellStart;
			    sheet.addCell(new jxl.write.Number(col++,row,slno++,cf));// For Auto increament SLNO
		    	for(int i=0;i< rowSize;i++){
		    		 sheet.addCell(new Label(col++,row,dataList.get(k).get(i),cf)); 
		    	}
		    }
		}
		catch(Exception e){ System.out.println("Error in writeData"); e.printStackTrace(); }
		finally{  }
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
	
	
	public List<ArrayList<String>> getInBoundSHTrips(int systemId, int clientId, int offset, int userId, String hubIds, String startDate, String endDate) {

		ArrayList<String> dataList = null;
		List<ArrayList<String>> finalList = new ArrayList<ArrayList<String>>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String hubArray= "";
			String hubList  ="";
			if(!hubIds.equals("")){
				hubArray= (hubIds.substring(0, hubIds.length() - 1));
				hubList  ="'"+hubArray.toString().replace(",","','")+"'";	
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_INBOUND_SH_TRIPS.replace("$$", " and td.STATUS!='CANCEL' ").replace("##", " and ds.HUB_ID in ("+hubList +")").concat(" and td.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)"));//.concat(" and td.INSERTED_TIME between dateadd(mi,-330,?) and dateadd(mi,-330,?)")
				
				pstmt.setInt(1, systemId);
				pstmt.setInt(2, clientId);
				pstmt.setInt(3, offset);
				pstmt.setString(4, startDate);
				pstmt.setInt(5, offset);
				pstmt.setString(6, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					dataList = new ArrayList<String>();
					dataList.add(rs.getString("status")+"-"+rs.getString("STATUS"));
					dataList.add(rs.getString("TRIP_NO"));
					dataList.add(rs.getString("VEHICLE_NO"));
//					if(rs.getInt("ETA") < 0){
//						dataList.add("-"+cf.convertMinutesToHHMMFormat(Math.abs(rs.getInt("ETA"))));
//					} else {
//						dataList.add(cf.convertMinutesToHHMMFormat(rs.getInt("ETA")));
//					}
					dataList.add(rs.getString("ETA").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("ETA"))));
					dataList.add(rs.getString("STA_WRT_STD").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("STA_WRT_STD"))));
					if(rs.getInt("DELAY") < 0){
						dataList.add("-"+cf.convertMinutesToHHMMFormat(Math.abs(rs.getInt("DELAY"))));
					} else{
						dataList.add(cf.convertMinutesToHHMMFormat(rs.getInt("DELAY")));
					}
					int netDelay = gf.calculateNetDelayForSH(rs.getInt("ID"),con,rs.getInt("SEQUENCE"));
					dataList.add(cf.convertMinutesToHHMMFormat(rs.getInt("DELAY")-netDelay));
				
					finalList.add(dataList);
				}
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	
	}

	public List<ArrayList<String>> getInBoundDestinationCHTrips(int systemId, int clientId, int offset, int userId, String hubIds, String startDate, String endDate, String zone) {

		ArrayList<String> dataList = null;
		List<ArrayList<String>> finalList = new ArrayList<ArrayList<String>>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String hubArray= "";
			String hubList  ="";
			if(!hubIds.equals("")){
				hubArray= (hubIds.substring(0, hubIds.length() - 1));
				hubList  ="'"+hubArray.toString().replace(",","','")+"'";	
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_INBOUND_DESTINATION_TRIPS.replace("$$", " and td.STATUS!='CANCEL' ").replace("##", " where HUB_ID in ("+hubList +")").concat(" and td.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)").replace("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+ zone ));
				pstmt.setInt(1, offset);
				pstmt.setInt(2, systemId);
				pstmt.setInt(3, clientId);
				pstmt.setInt(4, offset);
				pstmt.setString(5, startDate);
				pstmt.setInt(6, offset);
				pstmt.setString(7, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					
					dataList = new ArrayList<String>();
					dataList.add(rs.getString("status")+"-"+rs.getString("STATUS"));
					dataList.add(rs.getString("TRIP_ID"));
					dataList.add(rs.getString("TRIP_NO"));
//					if(rs.getInt("ETA_HH_MM") < 0){
//						dataList.add("-"+cf.convertMinutesToHHMMFormat(Math.abs(rs.getInt("ETA_HH_MM"))));
//					} else {
//						dataList.add(cf.convertMinutesToHHMMFormat(rs.getInt("ETA_HH_MM")));
//					}
					dataList.add(rs.getString("ETA_HH_MM").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("ETA_HH_MM"))));
					dataList.add(rs.getString("STA_WRT_ATD").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("STA_WRT_ATD"))));
					if(rs.getInt("DELAY") < 0){
						dataList.add("-"+cf.convertMinutesToHHMMFormat(Math.abs(rs.getInt("DELAY"))));
					} else{
						dataList.add(cf.convertMinutesToHHMMFormat(rs.getInt("DELAY")));
					}
					int netDelay = gf.calculateNetDelayForDestination(rs.getInt("ID"),con);
					dataList.add(cf.convertMinutesToHHMMFormat(rs.getInt("DELAY")-netDelay));
					finalList.add(dataList);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	
	}


	public List<ArrayList<String>> getOutBoundSHTrips(int systemId, int clientId, int offset, int userId, String hubIds, String startDate, String endDate) {

		ArrayList<String> dataList = null;
		List<ArrayList<String>> finalList = new ArrayList<ArrayList<String>>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String hubArray= "";
			String hubList  ="";
			if(!hubIds.equals("")){
				hubArray= (hubIds.substring(0, hubIds.length() - 1));
				hubList  ="'"+hubArray.toString().replace(",","','")+"'";	
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_OUTBOUND_SH_TRIPS.replace("$$", " and td.STATUS!='CANCEL' ").replace("##", " and ds.HUB_ID in ("+hubList +")").concat(" and td.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)"));
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, systemId);
				pstmt.setInt(4, clientId);
				pstmt.setInt(5, offset);
				pstmt.setString(6, startDate);
				pstmt.setInt(7, offset);
				pstmt.setString(8, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					dataList = new ArrayList<String>();
					dataList.add(rs.getString("status")+"-"+rs.getString("STATUS"));
					dataList.add(rs.getString("TRIP_NO"));
					dataList.add(rs.getString("VEHICLE_NO"));
					dataList.add(rs.getString("ATA@SH").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("ATA@SH"))));
					dataList.add(rs.getString("ATD@SH").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("ATD@SH"))));
					if(rs.getInt("EXCESS_DETENTION")<0){
						dataList.add("0");
					} else{
						dataList.add(cf.convertMinutesToHHMMFormat(rs.getInt("EXCESS_DETENTION")));
					}
					finalList.add(dataList);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	
	}

	public List<ArrayList<String>> getOutBoundOriginCHTrips(int systemId, int clientId, int offset, int userId, String hubIds, String startDate, String endDate, String zone) {

		ArrayList<String> dataList = null;
		List<ArrayList<String>> finalList = new ArrayList<ArrayList<String>>();
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			String hubArray= "";
			String hubList  ="";
			if(!hubIds.equals("")){
				hubArray= (hubIds.substring(0, hubIds.length() - 1));
				hubList  ="'"+hubArray.toString().replace(",","','")+"'";	
				con = DBConnection.getConnectionToDB("AMS");
				pstmt = con.prepareStatement(GeneralVerticalStatements.GET_OUTBOUND_ORIGIN_TRIPS.replace("$$", " and td.STATUS!='CANCEL' ").replace("##", " where HUB_ID in ("+hubList +")").concat(" and td.INSERTED_TIME between dateadd(mi,-?,?) and dateadd(mi,-?,?)").replace("AMS.dbo.LOCATION", "AMS.dbo.LOCATION_ZONE_"+ zone ));
				pstmt.setInt(1, offset);
				pstmt.setInt(2, offset);
				pstmt.setInt(3, offset);
				pstmt.setInt(4, offset);
				pstmt.setInt(5, offset);
				pstmt.setInt(6, systemId);
				pstmt.setInt(7, clientId);
				pstmt.setInt(8, offset);
				pstmt.setString(9, startDate);
				pstmt.setInt(10, offset);
				pstmt.setString(11, endDate);
				rs = pstmt.executeQuery();
				while (rs.next()) {
					dataList = new ArrayList<String>();
					dataList.add(rs.getString("status")+"-"+rs.getString("STATUS"));
					dataList.add(rs.getString("TRIP_ID"));
					dataList.add(rs.getString("TRIP_NO"));
					dataList.add(rs.getString("ATP").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("ATP"))));
					if(rs.getInt("PLACEMENT_DELAY") < 0){
						dataList.add("-"+cf.convertMinutesToHHMMFormat(Math.abs(rs.getInt("PLACEMENT_DELAY"))));
					} else{
						dataList.add(cf.convertMinutesToHHMMFormat(rs.getInt("PLACEMENT_DELAY")));
					}
					dataList.add(rs.getString("ATD").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("ATD"))));
					dataList.add(rs.getString("NEXT_TOUCH_POINT"));
					dataList.add(rs.getString("DESTINATION_ETA").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("DESTINATION_ETA"))));
					dataList.add(rs.getString("STA_WRT_ATD").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("STA_WRT_ATD"))));
					dataList.add(rs.getString("ATA").contains("1900")? "" :  mmddyyy.format(sdfDB.parse(rs.getString("ATA"))));
					finalList.add(dataList);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finalList;
	
	}

}
