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
import java.sql.Types;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;

@SuppressWarnings("serial")
public class ChallanReport extends HttpServlet {
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

@SuppressWarnings("unchecked")
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
	String serviceDeliveredBy = "Rane t4u";
	ArrayList<String> headersList = new ArrayList<String>();
	try{   
		HttpSession session = request.getSession();
		LoginInfoBean loginInfoBean = (LoginInfoBean) session.getAttribute("loginInfoDetails");				
	    systemId = loginInfoBean.getSystemId();		        
		custId= loginInfoBean.getCustomerId();
		
	    ServletOutputStream servletOutputStream=response.getOutputStream();
	    Properties properties = ApplicationListener.prop;
	    String excelpath =  properties.getProperty("Builtypath");
		refreshdir(excelpath);
		String formno="ExcelReport"+systemId;							
		String excel = excelpath+formno+".xls";
		File outFile = new File(excel);
		
		ResultSet rs=null;
		@SuppressWarnings("unused")
		ArrayList finalList=null;
		String reportTitle=null;
		String fileName=null;
		String sheetName = null;
		String orgId = request.getParameter("orgId") != null && !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
		String date=request.getParameter("date");
		reportTitle = "Challan Report";
		fileName="Challan Report-";
		sheetName = "Challan Report";
		rs=getPermitDetailsRS(systemId, custId,Integer.parseInt(orgId),date);
		ResultSetMetaData rsmd =rs.getMetaData();
		int rowSize=rsmd.getColumnCount();
		for(int i=1;i<=rowSize;i++){
			headersList.add(rsmd.getColumnName(i));	
		}
		prepareExcel(excel,systemId,request,headersList,rowSize,rs,cellStart,outFile,leftAlign,reportTitle,serviceDeliveredBy,sheetName);
		printExcel(response,servletOutputStream,systemId,excel,fileName+df.format(new Date()));
	}
	catch (Exception e){
		e.printStackTrace();
	}
 }//end of doGet method

	public void prepareExcel(String excel,int systemId,HttpServletRequest request,ArrayList<String> headersList,int rowSize,ResultSet crs,int cellStart,File outFile,int leftAlign,String reportTitle,String serviceDeliveredBy,String sheetName){    
		this.dataHeaderList = headersList;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.leftAlign = leftAlign;
    	cellEnd = rowSize;
		mid = (cellStart+cellEnd) / rowSize;
		generateExcel(excel,reportTitle,headersList,rowSize,crs,systemId,request,serviceDeliveredBy,sheetName);		
    }
	public void generateExcel(String pdf,String reportTitle,ArrayList<String> headersList,int rowSize,ResultSet crs,int systemId,HttpServletRequest request,String serviceDeliveredBy,String sheetName){	
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
				    cf1.setBackground(jxl.format.Colour.WHITE);
				    cf1.setBorder(Border.ALL,jxl.write.BorderLineStyle.THIN,Colour.GRAY_25);
				    cf1.setWrap(false);
				    WritableCellFormat cff1 = new WritableCellFormat(floatCell);
				    cff1.setWrap(false);
					writeData(sheet,startLineNo,crs,rowSize,cf1,cff1);
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
		    cf.setBackground(Colour.LIGHT_ORANGE);
		    cf.setAlignment(Alignment.CENTRE);
		    cf.setWrap(false);
		    	int row = rowNo++;
		    	Label title = new Label(cellStart,row,"Service Delivered By - "+serviceDeliveredBy,cf); 
		    	sheet.addCell(title);
		    	sheet.mergeCells(cellStart, row, cellEnd, row); 
		}catch(Exception e){ e.printStackTrace(); }
	}
		
	@SuppressWarnings({ "deprecation", "deprecation" })
	public void writeDataHeader(WritableSheet sheet,ArrayList<String> headersList,int rowSize){
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
		    	label = new Label(col,row,headersList.get(i),cf); 
			    sheet.addCell(label);
		    	sheet.mergeCells(col, row, col, row);
		    	col++;
		    }
		}
		catch(Exception e){	e.printStackTrace(); }
	}		
	public void writeData(WritableSheet sheet,int startLineNo,ResultSet rs,int rowSize,WritableCellFormat cf,WritableCellFormat cf1){        
		try{
		    SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
		    DecimalFormat df1 = new DecimalFormat("##0.00");
		    int slno=1;
		    int row=0;
		    int col=0;
		    ResultSetMetaData rsmd =rs.getMetaData();
		    while(rs.next()){
		    	row = rowNo++;
			    col = cellStart;
			    sheet.addCell(new jxl.write.Number(col++,row,slno++,cf));// For Auto increament SLNO
		    	for(int i=1;i<=rowSize;i++){
		    		switch (rsmd.getColumnType(i)) {
					case Types.INTEGER: { sheet.addCell(new jxl.write.Number(col++,row,rs.getInt(i),cf)); break; }
					case Types.VARCHAR: { sheet.addCell(new Label(col++,row,rs.getString(i),cf)); break; }
					case Types.TIMESTAMP: { sheet.addCell(new Label(col++,row,rs.getString(i)==null?"":rs.getString(i).contains("1900")?"":df.format(rs.getTimestamp(i)),cf)); break; }
					case Types.NUMERIC: { sheet.addCell(new jxl.write.Number(col++,row,rs.getDouble(i),cf1)); break; }
					case Types.DOUBLE: { sheet.addCell(new jxl.write.Number(col++,row,rs.getDouble(i),cf1)); break; }
					default: { sheet.addCell(new Label(col++,row,rs.getString(i),cf)); break; }
					}
		    	}
		    	if(row%1000==0){
		    		runGarbageCollector();
		    	}
		    }
		}
		catch(Exception e){ System.out.println("Error in writeData"); e.printStackTrace(); }
		finally{ DBConnection.releaseConnectionToDB(null, null, rs); }
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
	public ResultSet getPermitDetailsRS(int systemId,int custId,int orgId,String date){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		String queryNew="";
		try {
			con = DBConnection.getConnectionToDB("AMS");
		    String query="select c.ORGANIZATION_NAME as 'ORGANIZATION NAME',isnull(d.TC_NO,'') as 'TC NO',CHALLAN_DATETIME as 'DATE',CHALLAN_NO as 'DMG CHALLAN NO', " +
			" isnull(t2.QUANTITY,0) as 'QUANTITY',isnull(t2.AMOUNT,0) as 'AMOUNT',isnull(t2.PAYMENT_TYPE,0) as 'PAYMENT_TYPE',CHALLAN_TYPE as 'CHALLAN TYPE',t2.NO as 'RECEIPT NO' " +
			" from AMS.dbo.MINING_CHALLAN_DETAILS a " +
			" left outer join AMS.dbo.MINING_TC_MASTER d on a.TC_NO=d.ID and a.SYSTEM_ID=d.SYSTEM_ID and a.CUSTOMER_ID=d.CUSTOMER_ID  " +
			" left outer join AMS.dbo.MINING_MINE_MASTER c on c.ID=d.MINE_ID and d.CUSTOMER_ID=c.CUSTOMER_ID " +
			" left outer join AMS.dbo.MINE_OWNER_MASTER b on d.SYSTEM_ID=b.SYSTEM_ID and d.CUSTOMER_ID=b.CUSTOMER_ID and d.TC_NO=b.TC_NO   " +
			" cross apply ( " +
			" select a.NIC_CHALLAN_NO as NO,'ROYALTY' as PAYMENT_TYPE,isnull(sum(QUANTITY),0) as QUANTITY,isnull(sum(PAYABLE),0) as AMOUNT from AMS.dbo.CHALLAN_GRADE_DETAILS where a.ID=CHALLAN_ID " +
			" union " +
			" select a.DMF_NIC_CHALLAN_NO as NO,'DMF' as PAYMENT_TYPE,isnull(sum(QUANTITY),0) as QUANTITY,isnull((30*sum(PAYABLE)/100),0) as AMOUNT  from AMS.dbo.CHALLAN_GRADE_DETAILS where a.ID=CHALLAN_ID " +
			" union " +
			" select a.NMET_NIC_CHALLAN_NO as NO,'NMET' as PAYMENT_TYPE,isnull(sum(QUANTITY),0) as QUANTITY,isnull((2*sum(PAYABLE)/100),0) as AMOUNT from AMS.dbo.CHALLAN_GRADE_DETAILS where a.ID=CHALLAN_ID " +
			" union  " +
			" select a.GIOPF_NIC_CHALLAN_NO as NO,'GIOPF' as PAYMENT_TYPE,a.GIOPF_QTY as QUANTITY,isnull((a.GIOPF_QTY*a.GIOPF_RATE),0) as AMOUNT from AMS.dbo.CHALLAN_GRADE_DETAILS where a.ID=CHALLAN_ID " +
			" ) t2   " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='APPROVED' " +
			" *conditions* " +
			" union  " +
			" select isnull(om.ORGANIZATION_NAME,'') as 'ORGANIZATION NAME','' as 'TC NO',CHALLAN_DATETIME as 'DATE',CHALLAN_NO as 'DMG CHALLAN NO', " +
			" 0 as 'QUANTITY',isnull(a.TOTAL,0) as 'AMOUNT','PROCESSING FEE' as 'PAYMENT_TYPE',CHALLAN_TYPE as 'CHALLAN TYPE',PF_NIC_CHALLAN_NO as 'RECEIPT NO' " +
			" from AMS.dbo.MINING_CHALLAN_DETAILS a " +
			" inner join AMS.dbo.MINING_ORGANIZATION_MASTER om on om.ID=a.ORGANIZATION_ID and a.CUSTOMER_ID=om.CUSTOMER_ID AND a.SYSTEM_ID=om.SYSTEM_ID  " +
			" where a.SYSTEM_ID=? and a.CUSTOMER_ID=? and a.STATUS='APPROVED' #conditions# " +
			" order by a.CHALLAN_DATETIME asc ";
		    
		    if(orgId!=0){
		    	queryNew=query.replace("#conditions#", " and a.ORGANIZATION_ID=?").replace("*conditions*", "and a.TC_NO in (select a1.ID from AMS.dbo.MINING_TC_MASTER a1  " +
		    	" left outer join AMS.dbo.MINING_MINE_MASTER b1 on b1.ID=a1.MINE_ID and a1.CUSTOMER_ID=b1.CUSTOMER_ID where b1.ORG_ID=?) " );
		    	pstmt = con.prepareStatement(queryNew);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,custId);
				pstmt.setInt(3,orgId);
				pstmt.setInt(4,systemId);
				pstmt.setInt(5,custId);
				pstmt.setInt(6,orgId);
		    }else{
		    	queryNew=query.replace("#conditions#", " and CHALLAN_DATETIME between dateadd(mi,-330,?) and dateadd(mi,-330,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,?)+1,0)))").replace("*conditions*", " and CHALLAN_TYPE!='Processing Fee' and CHALLAN_DATETIME between dateadd(mi,-330,?) and dateadd(mi,-330,DATEADD(s,-1,DATEADD(mm, DATEDIFF(m,0,?)+1,0)))") ;
		    	pstmt = con.prepareStatement(queryNew);
				pstmt.setInt(1,systemId);
				pstmt.setInt(2,custId);
				pstmt.setString(3,date);
				pstmt.setString(4,date);
				pstmt.setInt(5,systemId);
				pstmt.setInt(6,custId);
				pstmt.setString(7,date);
				pstmt.setString(8,date);
		    }
			rs = pstmt.executeQuery();
		} 
		catch (Exception e){
			e.printStackTrace();	
		} 
		return rs;
	}
	/**
	 * Runs garbage collection
	 */
	public void runGarbageCollector(){
		Runtime.getRuntime().gc();
		System.out.println("run gc();");
	}
  }
