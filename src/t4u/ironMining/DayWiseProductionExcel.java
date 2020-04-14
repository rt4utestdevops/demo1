package t4u.ironMining;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.Vector;

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
import org.json.JSONArray;
import org.json.JSONObject;
import java.sql.Types;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.IronMiningStatement;

public class DayWiseProductionExcel extends HttpServlet {
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
	
	public static final String GET_ORG_NAMES ="select distinct a.TC_ID,a.ORG_ID,tc.TC_NO,tc.NAME_OF_MINE,mom.ORGANIZATION_NAME from MINING.dbo.PRODUCTION_DETAILS (NOLOCK)a "+
						" inner join AMS.dbo.MINING_ORGANIZATION_MASTER mom (NOLOCK) on mom.ID=a.ORG_ID and mom.CUSTOMER_ID=a.CUSTOMER_ID "+
						" inner join AMS.dbo.MINING_TC_MASTER tc (NOLOCK) on tc.ID=a.TC_ID and a.CUSTOMER_ID=tc.CUSTOMER_ID "+
						" where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? and(a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "+ 
						" a.ORG_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID))";

	public static final String GET_DAY_WISE_PRODUCTION= "select a.TC_ID,a.ORG_ID,a.PRODUCTION_QTY,a.DATE,DATEDIFF(dd,? ,a.DATE)as DAY from MINING.dbo.PRODUCTION_DETAILS a "+
						" where a.SYSTEM_ID=? AND a.CUSTOMER_ID=? and a.DATE between  DATEADD(dd, 0, ?) and DATEADD(dd, 31, ?)" +
						"and(a.TC_ID in (select TC_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and  SYSTEM_ID=a.SYSTEM_ID and TC_ID!=0) or "+ 
						" a.ORG_ID in (select ORG_ID from MINING.dbo.USER_TC_ASSOCIATION where USER_ID=? and SYSTEM_ID=a.SYSTEM_ID))";
protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
	cellStart = 0;	
	TITLE_BKG = Colour.LIGHT_ORANGE;
	HEADER_BKG = Colour.ICE_BLUE;
	
	titleWF = new WritableFont(WritableFont.ARIAL,14, WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE, Colour.DARK_BLUE2);
	headerWF = new WritableFont(WritableFont.ARIAL,10, WritableFont.BOLD);
	dataWF = new WritableFont(WritableFont.ARIAL,8, WritableFont.BOLD);
	floatFormat = new WritableCellFormat(dataWF,NumberFormats.FLOAT);
	floatCell = new WritableCellFormat(floatFormat);
	
	SimpleDateFormat df = new SimpleDateFormat("dd/MM/yy");
	
	int systemId =0;
	int custId = 0;
	int userId = 0;
	String serviceDeliveredBy = "Rane t4u";
	ArrayList<String> headersList = new ArrayList<String>();
	try{   
		HttpSession session = request.getSession();
		LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");				
	    systemId = loginInfoBean.getSystemId();		        
		custId= loginInfoBean.getCustomerId();
		userId= loginInfoBean.getUserId();
		
	    ServletOutputStream servletOutputStream=response.getOutputStream();
	    Properties properties = ApplicationListener.prop;
	    String excelpath =  properties.getProperty("Builtypath");
		refreshdir(excelpath);
		String formno="ExcelReport"+systemId;							
		String excel = excelpath+formno+".xls";
		File outFile = new File(excel);
		
		ArrayList finalList=null;
		String reportTitle=null;
		String fileName=null;
		String sheetName = null;
		Date date=request.getParameter("date")!=null?new SimpleDateFormat("dd-MM-yy").parse(request.getParameter("date")):new Date();
		int noOfDays=request.getParameter("days")!=null?Integer.parseInt(request.getParameter("days")):31;
		long currDate=date.getTime()-8640000L;
			reportTitle = "Day Wise Production Report";
			fileName="Production Report-";
			sheetName="Production Report";
			finalList=getReportDetails(systemId,custId,userId,currDate,noOfDays);
			headersList=(ArrayList<String>)finalList.get(0);
			Map<Integer,DayWiseProductionBean> beanMap=(LinkedHashMap<Integer, DayWiseProductionBean>) finalList.get(1);
			prepareExcel(excel,systemId,request,headersList, headersList.size(),beanMap, cellStart, outFile,leftAlign,reportTitle,serviceDeliveredBy,sheetName,noOfDays);
			printExcel(response,servletOutputStream,systemId,excel,fileName+df.format(new Date()));
	}
	catch (Exception e){ e.printStackTrace();}
 }//end of doGet method
   
    @SuppressWarnings("unchecked")
	public void prepareExcel(String excel,int systemId,HttpServletRequest request,ArrayList headersList,int rowSize,Map<Integer,DayWiseProductionBean> beanMap,int cellStart,File outFile,int leftAlign,String reportTitle,String serviceDeliveredBy,String sheetName,int noOfDays){    
		this.dataHeaderList = headersList;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.leftAlign = leftAlign;
    	cellEnd = rowSize;
		mid = (cellStart+cellEnd) / rowSize;
		generateExcel(excel,reportTitle,headersList,rowSize,beanMap,systemId,request,serviceDeliveredBy,sheetName,noOfDays);		
    }
    
    @SuppressWarnings("unchecked")
	public void generateExcel(String pdf,String reportTitle,ArrayList headersList,int rowSize,Map<Integer,DayWiseProductionBean> beanMap,int systemId,HttpServletRequest request,String serviceDeliveredBy,String sheetName,int noOfDays){	
		try{
			WritableWorkbook workbook = Workbook.createWorkbook(outFile);								
			int sheetNo = 1;
			WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
			for(int i = 0; i < rowSize; i ++){
				int startLineNo = i;
				if(startLineNo==0){
					rowNo = 0;
					writeReportTitle(sheet,reportTitle);
					writeDataHeader(sheet,headersList,rowSize);
				    WritableCellFormat cf1 = new WritableCellFormat(dataWF);
				    cf1.setBackground(jxl.format.Colour.GRAY_25);
				    cf1.setWrap(false);
				    WritableCellFormat cf2 = new WritableCellFormat(dataWF);
				    cf2.setBackground(jxl.format.Colour.GREY_40_PERCENT);
				    cf2.setWrap(false);
				    WritableCellFormat cff1 = new WritableCellFormat(floatCell);
				    cff1.setBackground(jxl.format.Colour.GRAY_25);
				    cff1.setWrap(false);
				    WritableCellFormat cff2 = new WritableCellFormat(floatCell);
				    cff2.setBackground(jxl.format.Colour.GREY_40_PERCENT);
				    cff2.setWrap(false);
					writeData(sheet,startLineNo,beanMap,rowSize,null,cf1,cf2,null,cff1,cff2,noOfDays);
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
			
	public void writeData(WritableSheet sheet,int startLineNo,Map<Integer,DayWiseProductionBean> beanMap,int rowSize,WritableCellFormat cf,WritableCellFormat cf1,WritableCellFormat cf2,WritableCellFormat cff,WritableCellFormat cff1,WritableCellFormat cff2,int noOfDays){        
		try{
		    int slno=1;
		    int row=0;
		    int col=0;
		    Set<Integer> keySet=beanMap.keySet();
		    
		    for(Integer tcId: keySet){
		    	row = rowNo++;
			    col = cellStart;
			    if(row%2==1){ cf=cf2;cff=cff2; }else{ cf=cf1;cff=cff1; }// for even-odd coloring
			    sheet.addCell(new jxl.write.Number(col++,row,slno++,cf));// For Auto increament SLNO
			    DayWiseProductionBean bean=beanMap.get(tcId);
			    sheet.addCell(new Label(col++,row,bean.getTcNo(),cf));
			    sheet.addCell(new Label(col++,row,bean.getLeaseName(),cf));
			    sheet.addCell(new Label(col++,row,bean.getOrgName(),cf));
			    double []qtyArr={bean.getDay1(),bean.getDay2(),bean.getDay3(),bean.getDay4(),bean.getDay5(),bean.getDay6(),bean.getDay7(),bean.getDay8(),bean.getDay9(),bean.getDay10(),
			    				 bean.getDay11(),bean.getDay12(),bean.getDay13(),bean.getDay14(),bean.getDay15(),bean.getDay16(),bean.getDay17(),bean.getDay18(),bean.getDay19(),bean.getDay20(),
			    				 bean.getDay21(),bean.getDay22(),bean.getDay23(),bean.getDay24(),bean.getDay25(),bean.getDay26(),bean.getDay27(),bean.getDay28(),bean.getDay29(),bean.getDay30(),bean.getDay31()};
			    double totalQty=0;
			    for(int i=0;i<noOfDays;i++){
			    	sheet.addCell(new jxl.write.Number(col++,row,qtyArr[i],cff));
			    	totalQty=totalQty+qtyArr[i];
			    }
			    sheet.addCell(new jxl.write.Number(col++,row,totalQty,cff));
			    
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
	public ArrayList getReportDetails(int systemId,int custId, int userId, long currDate,int noOfDays)
	{
		SimpleDateFormat sdf = new SimpleDateFormat("dd MMMMM yyyy");
		Map<Integer,DayWiseProductionBean> beanMap=new LinkedHashMap<Integer,DayWiseProductionBean>();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ArrayList finlist=new ArrayList();
		ArrayList<String> headersList = new ArrayList<String>();
		headersList.add("TC NO");
		headersList.add("Lease Name");
		headersList.add("Organization Name");
		for(int i=1;i<=noOfDays;i++){
			headersList.add(sdf.format(new Date(currDate+(i*86400000L))));
		}
		headersList.add("TOTAL");
		DecimalFormat df=new DecimalFormat("#0.00");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_ORG_NAMES);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,custId);
			pstmt.setInt(3,userId);
			pstmt.setInt(4,userId);
			rs= pstmt.executeQuery();
			while (rs.next()) {
				DayWiseProductionBean bean=new DayWiseProductionBean();
				bean.setTcId(rs.getInt("TC_ID"));
				bean.setTcNo(rs.getString("TC_NO"));
				bean.setOrgId(rs.getInt("ORG_ID"));
				bean.setOrgName(rs.getString("ORGANIZATION_NAME"));
				bean.setLeaseName(rs.getString("NAME_OF_MINE"));
				beanMap.put(rs.getInt("TC_ID"), bean);
			}
			pstmt = con.prepareStatement(GET_DAY_WISE_PRODUCTION);
			pstmt.setDate(1, new java.sql.Date(currDate));
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,custId);
			pstmt.setDate(4, new java.sql.Date(currDate));
			pstmt.setDate(5, new java.sql.Date(currDate));
			pstmt.setInt(6,userId);
			pstmt.setInt(7,userId);
			rs= pstmt.executeQuery();
			DayWiseProductionBean bean=null;
			while (rs.next()) {
				bean=beanMap.get(rs.getInt("TC_ID"));
				switch (rs.getInt("DAY")) {
				case 1:{bean.setDay1(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 2:{bean.setDay2(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 3:{bean.setDay3(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 4:{bean.setDay4(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 5:{bean.setDay5(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 6:{bean.setDay6(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 7:{bean.setDay7(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 8:{bean.setDay8(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 9:{bean.setDay9(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 10:{bean.setDay10(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 11:{bean.setDay11(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 12:{bean.setDay12(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 13:{bean.setDay13(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 14:{bean.setDay14(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 15:{bean.setDay15(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 16:{bean.setDay16(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 17:{bean.setDay17(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 18:{bean.setDay18(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 19:{bean.setDay19(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 20:{bean.setDay20(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 21:{bean.setDay21(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 22:{bean.setDay22(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 23:{bean.setDay23(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 24:{bean.setDay24(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 25:{bean.setDay25(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 26:{bean.setDay26(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 27:{bean.setDay27(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 28:{bean.setDay28(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 29:{bean.setDay29(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 30:{bean.setDay30(rs.getDouble("PRODUCTION_QTY"));	break;}
				case 31:{bean.setDay31(rs.getDouble("PRODUCTION_QTY"));	break;}
				default: break;
				}
			}
			finlist.add(headersList);
			finlist.add(beanMap);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return finlist;
	}
	/**
	 * Runs garbage collection
	 */
	public void runGarbageCollector(){
		//Runtime.getRuntime().gc();
		System.out.println("run gc();");
	}
  }
