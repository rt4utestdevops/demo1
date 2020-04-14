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
import org.json.JSONArray;
import org.json.JSONObject;
import java.sql.Types;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.statements.IronMiningStatement;

public class AllChallansOrPermitsExcel extends HttpServlet {
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
		ArrayList finalList=null;
		String reportTitle=null;
		String fileName=null;
		String sheetName = null;
		String requestingFor=request.getParameter("requesrtingFor");
		if(requestingFor.equalsIgnoreCase("ChallanDetails")){
			reportTitle = "Challan Details Report";
			fileName="Challan Report-";
			sheetName="Challan Report";
			finalList=getChallanDetailsRS(systemId,custId);
			headersList=(ArrayList<String>)finalList.get(0);
			String []JHeaders=(String[]) finalList.get(1);
			int []headersType=(int[]) finalList.get(2);
			JSONArray jDataArray=(JSONArray)finalList.get(3);
			prepareExcel(excel,systemId,request,headersList, headersList.size(),headersType,JHeaders, jDataArray,  cellStart, outFile,leftAlign,reportTitle,serviceDeliveredBy,sheetName);
		}else if(requestingFor.equalsIgnoreCase("PermitDetails")){
			reportTitle = "Permit Details Report";
			fileName="Permit Report-";
			sheetName = "Permit Report";
			rs=getPermitDetailsRS(systemId, custId);
			ResultSetMetaData rsmd =rs.getMetaData();
			int rowSize=rsmd.getColumnCount();
			for(int i=1;i<=rowSize;i++){	headersList.add(rsmd.getColumnName(i));	}
			prepareExcel(excel,systemId,request,headersList,rowSize,rs,cellStart,outFile,leftAlign,reportTitle,serviceDeliveredBy,sheetName);
		}
		printExcel(response,servletOutputStream,systemId,excel,fileName+df.format(new Date()));
	}
	catch (Exception e){ e.printStackTrace();}
 }//end of doGet method
   
    @SuppressWarnings("unchecked")
	public void prepareExcel(String excel,int systemId,HttpServletRequest request,ArrayList headersList,int rowSize,int headersType[],String []JHeaders,JSONArray jDataArray,int cellStart,File outFile,int leftAlign,String reportTitle,String serviceDeliveredBy,String sheetName){    
		this.dataHeaderList = headersList;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.leftAlign = leftAlign;
    	cellEnd = rowSize;
		mid = (cellStart+cellEnd) / rowSize;
		generateExcel(excel,reportTitle,headersList,rowSize,headersType,JHeaders,jDataArray,systemId,request,serviceDeliveredBy,sheetName);		
    }
    @SuppressWarnings("unchecked")
	public void prepareExcel(String excel,int systemId,HttpServletRequest request,ArrayList headersList,int rowSize,ResultSet crs,int cellStart,File outFile,int leftAlign,String reportTitle,String serviceDeliveredBy,String sheetName){    
		this.dataHeaderList = headersList;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.leftAlign = leftAlign;
    	cellEnd = rowSize;
		mid = (cellStart+cellEnd) / rowSize;
		generateExcel(excel,reportTitle,headersList,rowSize,crs,systemId,request,serviceDeliveredBy,sheetName);		
    }
    
    @SuppressWarnings("unchecked")
	public void generateExcel(String pdf,String reportTitle,ArrayList headersList,int rowSize,int headersType[],String []JHeaders,JSONArray jDataArray,int systemId,HttpServletRequest request,String serviceDeliveredBy,String sheetName){	
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
					writeData(sheet,startLineNo,headersType,JHeaders,jDataArray,rowSize,null,cf1,cf2,null,cff1,cff2);
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
    @SuppressWarnings("unchecked")
	public void generateExcel(String pdf,String reportTitle,ArrayList headersList,int rowSize,ResultSet crs,int systemId,HttpServletRequest request,String serviceDeliveredBy,String sheetName){	
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
					writeData(sheet,startLineNo,crs,rowSize,null,cf1,cf2,null,cff1,cff2);
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
			
	public void writeData(WritableSheet sheet,int startLineNo,int headersType[],String []JHeaders,JSONArray jDataArray,int rowSize,WritableCellFormat cf,WritableCellFormat cf1,WritableCellFormat cf2,WritableCellFormat cff,WritableCellFormat cff1,WritableCellFormat cff2){        
		try{
		    int slno=1;
		    int row=0;
		    int col=0;
		    for(int i=0;i<jDataArray.length();i++){
		    	row = rowNo++;
			    col = cellStart;
			    if(row%2==1){ cf=cf2;cff=cff2; }else{ cf=cf1;cff=cff1; }// for even-odd coloring
			    sheet.addCell(new jxl.write.Number(col++,row,slno++,cf));// For Auto increament SLNO
			    JSONObject jObj=(JSONObject)jDataArray.get(i);
		    	for(int j=0;j<JHeaders.length;j++){
		    		switch (headersType[j]) {
					case 1: { sheet.addCell(new jxl.write.Number(col++,row,jObj.getInt(JHeaders[j]),cf)); break; }
					case 2: { sheet.addCell(new Label(col++,row,jObj.getString(JHeaders[j]),cf)); break; }
					case 3: { sheet.addCell(new jxl.write.Number(col++,row,jObj.getDouble(JHeaders[j]),cff)); break; }
					default: { sheet.addCell(new Label(col++,row,jObj.getString(JHeaders[j]),cf)); break; }
					}
		    	}
		    	if(i%1000==0){
		    		runGarbageCollector();
		    	}
		    }
		}
		catch(Exception e){ System.out.println("Error in writeData"); e.printStackTrace(); }
	  }
	public void writeData(WritableSheet sheet,int startLineNo,ResultSet rs,int rowSize,WritableCellFormat cf,WritableCellFormat cf1,WritableCellFormat cf2,WritableCellFormat cff,WritableCellFormat cff1,WritableCellFormat cff2){        
		try{
		    SimpleDateFormat df = new SimpleDateFormat("dd-MM-yyyy");
		    int slno=1;
		    int row=0;
		    int col=0;
		    ResultSetMetaData rsmd =rs.getMetaData();
		    while(rs.next()){
		    	row = rowNo++;
			    col = cellStart;
			    if(row%2==1){ cf=cf2;cff=cff2; }else{ cf=cf1;cff=cff1; }// for even-odd coloring
			    sheet.addCell(new jxl.write.Number(col++,row,slno++,cf));// For Auto increament SLNO
		    	for(int i=1;i<=rowSize;i++){
		    		switch (rsmd.getColumnType(i)) {
					case Types.INTEGER: { sheet.addCell(new jxl.write.Number(col++,row,rs.getInt(i),cf)); break; }
					case Types.VARCHAR: { sheet.addCell(new Label(col++,row,rs.getString(i),cf)); break; }
					case Types.TIMESTAMP: { sheet.addCell(new Label(col++,row,rs.getString(i)==null?"":rs.getString(i).contains("1900")?"":df.format(rs.getTimestamp(i)),cf)); break; }
					case Types.NUMERIC: { sheet.addCell(new jxl.write.Number(col++,row,rs.getDouble(i),cff)); break; }
					case Types.DOUBLE: { sheet.addCell(new jxl.write.Number(col++,row,rs.getDouble(i),cff)); break; }
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
	public ArrayList getChallanDetailsRS(int systemId,int custId)
	{
		JSONArray JsonArray = new JSONArray();
		JSONObject JsonObject = null;
		Connection con = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		ResultSet rs1 = null;
		int count = 0;
		float qty=0;
		float rate=0;
		double dmf=0;
	    double nmet=0;
	    float processingFee=0;
	    double totalPay=0;
	    double payable=0;
		ArrayList < Object > finlist = new ArrayList < Object > ();
		ArrayList<String> headersList = new ArrayList<String>();
		double LmeRate=0;
	    double tdsPerc=0;
		double dollarRate=0;
		double gradeRate=0;
		double rateB=0;
		double cellAmt=0;
		double processFeeRate=0;
		double qtyB=0;
		double totalRoyality=0;
		double royality=0;
		double totalChallanAmt=0;

		headersList.add("Challan Number");
		headersList.add("Status");
		headersList.add("Payment A/C Head");
		headersList.add("Tc Number");
		headersList.add("Lease Name");
		headersList.add("Organization Name");
		headersList.add("Total Quantity");
		headersList.add("Used Quantity");
		headersList.add("Royalty");
		headersList.add("DMF");
		headersList.add("NMET");
		headersList.add("Processing Fee Amount");
		headersList.add("PF Payable");
		headersList.add("GIOPF");
		headersList.add("Total Challan Amount");
		headersList.add("Type");
		headersList.add("Mine Code");
		headersList.add("Mine Owner");
		headersList.add("IBM Average Sale Price Month ");
		headersList.add("Transportation Month");
		headersList.add("Royalty Date");
		headersList.add("Mineral Type");
		headersList.add("Mineral Code");
		headersList.add("Challan Type");
		headersList.add("Financial Year");
		headersList.add("Payment Description");
		headersList.add("Date");
		headersList.add("Bank Transaction Number");
		headersList.add("Bank");
		headersList.add("Branch");
		headersList.add("Amount Paid");
		headersList.add("Payment Descriptoin");
		headersList.add("Acknowledgement Generation Datetime");
		headersList.add("Closed Permit No");
		headersList.add("E-Wallet Balence");
		headersList.add("E-Wallet Used");
		headersList.add("Total Payable");
		headersList.add("Processing Fee");
		headersList.add("Royalty Challan No");
		headersList.add("Royalty Challan Date");
		headersList.add("DMF Challan No");
		headersList.add("DMF Challan Date");
		headersList.add("NMET Challan No");
		headersList.add("NMET Challan Date");
		headersList.add("PF Challan No");
		headersList.add("PF Challan Date");
		headersList.add("GIOPF Challan No");
		headersList.add("GIOPF Challan Date");
		headersList.add("Organization/Trader Code");
		headersList.add("Issued Date Time");
		headersList.add("District Name");
		int []headersType={2,2,2,2,2,2,3,3,3, 3,3,3,3,3,3,2,2,2,2, 2,2,2,2,2,2,2,2,2,2, 2,3,2,2,2,3,2,3,3,2, 2,2,2,2,2,2,2,2,2,2,2, 2,2,2,2,2,2};//Here 1:=int, 2:=string, 3:=number
		String []jHeaderList={"challanNumberDataIndex","openStatusDataIndex","paymentAcHeadDataIndex","TCNODataIndex","MineNameDataIndex","orgNameDataIndex","totalQtyDataIndex","usedQtyDataIndex","royaltyAmtDataIndex","DMFDataIndex","NMETDataIndex","pFeeAmtDataIndex","totalPayableDataIndex","GIDataIndex","payableDataIndex",
				"typeDataIndex","MineCodeDataIndex","ownerNameDataIndex","royaltyDataIndex","TransMonthIndex","royaltyDateDataIndex","mineralTypeDataIndex","mineralCodeDataIndex","challanTypeDataIndex","financialYrDataIndex","paymentDescriptionDataIndex","dateDataIndex",
				"transactionDataIndex","bankDataIndex","branchDataIndex","amountDataIndex","paymentDataIndex","AckGenDataIndex","closedPermitNoDataIndex","ewalletBalance2DataIndex","ewalletBalanceDataIndex","ewalletPayableDataIndex","pFeeDataIndex","challanNoDataIndex","challanDateDataIndex","DMFchallanNoDataIndex","DMFchallanDateDataIndex","NMETchallanNoDataIndex","NMETchallanDateDataIndex",
				"PFchallanNoDataIndex","PFchallanDateDataIndex","GIchallanNoDataIndex","GIchallanDateDataIndex","organizationCodeDataIndex","insertedTimeInd","districtNameInd"};
		SimpleDateFormat diffddMMyyyyHHmmss = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
		SimpleDateFormat diffddMMyyyyHHmmss1 = new SimpleDateFormat("dd-MM-yyyy");
		SimpleDateFormat MMddyyyy = new SimpleDateFormat("MM-dd-yyyy");
		SimpleDateFormat MMMMMyyyy = new SimpleDateFormat("MMMMM yyyy");
		DecimalFormat df=new DecimalFormat("0.00");

		try {
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(IronMiningStatement.GET_MINING_CHALLAN_DETAILS.replace("#conditions#", ""));
			pstmt.setInt(1,330);
			pstmt.setInt(2,systemId);
			pstmt.setInt(3,custId);
			rs= pstmt.executeQuery();
			while (rs.next()) {
				qty=0;
				rate=0;
				dmf=0;
			    nmet=0;
			    processingFee=0;
			    totalPay=0;
			    payable=0;
				JsonObject = new JSONObject();
				count++;
				JsonObject.put("slnoIndex", count);
				JsonObject.put("challanNumberDataIndex", rs.getString("CHALLAN_NO"));
				JsonObject.put("openStatusDataIndex", rs.getString("STATUS"));
				JsonObject.put("paymentAcHeadDataIndex", rs.getString("PAYMENT_ACC_HEAD"));
				JsonObject.put("TCNODataIndex", rs.getString("TC_NO"));
				JsonObject.put("MineNameDataIndex", rs.getString("MINING_LEASE"));
				if(!rs.getString("ORGANIZATION_NAME").equals("")){
					JsonObject.put("orgNameDataIndex", rs.getString("ORGANIZATION_NAME"));
				}else{
					JsonObject.put("orgNameDataIndex", rs.getString("ORGANIZATION_NAME_PF"));
				}
				pstmt = con.prepareStatement(IronMiningStatement.GET_MINING_CHALLAN_GRADE_DETAILS);
				pstmt.setInt(1,rs.getInt("ID"));
				rs1= pstmt.executeQuery();
				while (rs1.next()) {
				qty= qty+rs1.getFloat("QUANTITY");
				rate = rate+rs1.getFloat("RATE");
				payable=payable+rs1.getFloat("PAYABLE");
				if(rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Bauxite Challan")){
					if(rs1.getString("GRADE").equals("LME RATE")){
			        	   LmeRate=rs1.getDouble("RATE");
			           }if(rs1.getString("GRADE").equals("DOLLAR RATE")){
			        	   dollarRate=rs1.getDouble("RATE");
			           }if(rs1.getString("GRADE").equals("GRADE RATE")){
			        	   gradeRate=rs1.getDouble("RATE");
			           }if(rs1.getString("GRADE").equals("RATE")){
			        	   rateB=rs1.getDouble("RATE");
			           }if(rs1.getString("GRADE").equals("QUANTITY")){
			        	   qtyB=rs1.getDouble("RATE");
			           }if(rs1.getString("GRADE").equals("CELL AMOUNT RATE")){
			        	   cellAmt=rs1.getDouble("RATE");
			           }if(rs1.getString("GRADE").equals("PROCESSING FEE RATE")){
			        	   processFeeRate=rs1.getDouble("RATE");
			           }if(rs1.getString("GRADE").equals("TDS PERCENTAGE")){
			        	   tdsPerc=(rs1.getDouble("RATE"))/100;
			           }
				}
				}
				payable = Math.round(payable);
				dmf=Math.round(payable*(0.3));
				nmet=Math.round(payable*(0.02));
				if(rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Others")){
					dmf=0;
					nmet=0;
					processingFee=0;
				}
				if(rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Bauxite Challan")){
					royality=(LmeRate*dollarRate*gradeRate)*(rateB/100);
		            totalRoyality=((LmeRate*dollarRate*gradeRate)*(rateB/100))* qtyB ;
		            totalChallanAmt=(totalRoyality)+(totalRoyality * 0.3)+(qtyB * processFeeRate)+(qtyB * cellAmt)+(totalRoyality * tdsPerc)+(totalRoyality * 0.02);
					dmf=totalRoyality * 0.3;
					nmet=totalRoyality * 0.02;
					processingFee=(float) (qtyB * processFeeRate);
					payable=totalRoyality;
					qty=(float) qtyB;
				}
				if(rs.getFloat("PROCESSING_FEE")!=0){
					processingFee=qty*rs.getFloat("PROCESSING_FEE");
				}
				totalPay=Math.round(dmf+nmet+payable+processingFee+(rs.getDouble("GIOPF_PAYABLE")));
				JsonObject.put("totalQtyDataIndex", df.format(qty));
				JsonObject.put("usedQtyDataIndex", df.format(rs.getDouble("USED_QTY")/1000));
				JsonObject.put("royaltyAmtDataIndex", df.format(payable));
				JsonObject.put("DMFDataIndex", df.format(dmf));
				JsonObject.put("NMETDataIndex", df.format(nmet));
				JsonObject.put("pFeeAmtDataIndex", df.format(processingFee));
				JsonObject.put("totalPayableDataIndex", rs.getString("TOTAL_PAYABLE"));
				JsonObject.put("GIDataIndex", df.format(rs.getDouble("GIOPF_PAYABLE")));
				if(rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Bauxite Challan")){
					JsonObject.put("payableDataIndex", df.format(totalChallanAmt));
				}else{
					JsonObject.put("payableDataIndex", df.format(totalPay));
				}
				JsonObject.put("typeDataIndex", rs.getString("TYPE"));
				JsonObject.put("MineCodeDataIndex", rs.getString("MINE_CODE"));
				JsonObject.put("ownerNameDataIndex", rs.getString("LEASE_NAME"));
				if(rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Processing Fee")){
					JsonObject.put("royaltyDataIndex", "");
					JsonObject.put("TransMonthIndex","");
					JsonObject.put("royaltyDateDataIndex", "");
				}else{
					JsonObject.put("royaltyDataIndex", rs.getString("ROYALITY_FOR_MONTH"));
					if(rs.getString("PREVIOUS_CHALLAN_DATE").contains("1900"))
					{ JsonObject.put("TransMonthIndex",""); 
					} else{ JsonObject.put("TransMonthIndex", MMMMMyyyy.format(rs.getTimestamp("PREVIOUS_CHALLAN_DATE"))); }
					
					if(rs.getString("ROY_DATE").contains("1900"))
					{ JsonObject.put("royaltyDateDataIndex",""); 
					} else{ JsonObject.put("royaltyDateDataIndex", MMddyyyy.format(rs.getTimestamp("ROY_DATE"))); }
				}
				JsonObject.put("mineralTypeDataIndex", rs.getString("MINERAL_TYPE"));
				JsonObject.put("mineralCodeDataIndex", rs.getString("MINERAL_CODE"));
				JsonObject.put("challanTypeDataIndex", rs.getString("CHALLAN_TYPE"));
				JsonObject.put("financialYrDataIndex", rs.getString("FINANCIAL_YEAR"));
				JsonObject.put("paymentDescriptionDataIndex", rs.getString("PAYMENT_DESC"));
				if(rs.getString("CHALLAN_DATETIME").contains("1900"))
				{ JsonObject.put("dateDataIndex","");
				}else{ JsonObject.put("dateDataIndex", new SimpleDateFormat("dd-MM-yyyy").format(rs.getTimestamp("CHALLAN_DATETIME"))); }

				JsonObject.put("transactionDataIndex", rs.getString("BANK_TRANS_NO"));
				JsonObject.put("bankDataIndex", rs.getString("BANK_NAME"));
				JsonObject.put("branchDataIndex", rs.getString("BRANCH"));
				JsonObject.put("amountDataIndex", rs.getString("AMOUNT_PAID"));
				JsonObject.put("paymentDataIndex", rs.getString("ACK_PAYMENT_DESC"));
				if(rs.getString("ACK_DATETIME").contains("1900"))
				{ JsonObject.put("AckGenDataIndex","");
				}else{ JsonObject.put("AckGenDataIndex", diffddMMyyyyHHmmss.format(rs.getTimestamp("ACK_DATETIME"))); }
				JsonObject.put("closedPermitNoDataIndex", rs.getString("PERMIT_NO"));
				JsonObject.put("ewalletBalance2DataIndex", rs.getString("E_WALLET_BALANCE"));
				JsonObject.put("ewalletBalanceDataIndex", rs.getString("E_WALLET_USED"));
				if(rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Others")){
					JsonObject.put("ewalletPayableDataIndex", df.format(payable));
				}else if(rs.getString("CHALLAN_TYPE").equalsIgnoreCase("Bauxite Challan")){
					JsonObject.put("ewalletPayableDataIndex", df.format(totalChallanAmt));
				}else{ JsonObject.put("ewalletPayableDataIndex", rs.getString("TOTAL_EWALLET_PAYABLE")); }
				JsonObject.put("pFeeDataIndex", rs.getString("PROCESSING_FEE"));
				JsonObject.put("challanNoDataIndex", rs.getString("NIC_CHALLAN_NO"));
				if(rs.getString("NIC_CHALLAN_DATE").contains("1900"))
				{ JsonObject.put("challanDateDataIndex","");
				}else{ JsonObject.put("challanDateDataIndex", diffddMMyyyyHHmmss1.format(rs.getTimestamp("NIC_CHALLAN_DATE"))); }
				JsonObject.put("DMFchallanNoDataIndex", rs.getString("DMF_NIC_CHALLAN_NO"));
				if(rs.getString("DMF_NIC_CHALLAN_DATE").contains("1900"))
				{ JsonObject.put("DMFchallanDateDataIndex","");
				}else{ JsonObject.put("DMFchallanDateDataIndex", diffddMMyyyyHHmmss1.format(rs.getTimestamp("DMF_NIC_CHALLAN_DATE"))); }
				JsonObject.put("NMETchallanNoDataIndex", rs.getString("NMET_NIC_CHALLAN_NO"));
				if(rs.getString("NMET_NIC_CHALLAN_DATE").contains("1900"))
				{ JsonObject.put("NMETchallanDateDataIndex","");
				}else{ JsonObject.put("NMETchallanDateDataIndex", diffddMMyyyyHHmmss1.format(rs.getTimestamp("NMET_NIC_CHALLAN_DATE"))); }
				JsonObject.put("PFchallanNoDataIndex", rs.getString("PF_NIC_CHALLAN_NO"));
				if(rs.getString("PF_NIC_CHALLAN_DATE").contains("1900"))
				{ JsonObject.put("PFchallanDateDataIndex","");
				}else{ JsonObject.put("PFchallanDateDataIndex", diffddMMyyyyHHmmss1.format(rs.getTimestamp("PF_NIC_CHALLAN_DATE"))); }
				JsonObject.put("GIchallanNoDataIndex", rs.getString("GIOPF_NIC_CHALLAN_NO"));
				if(rs.getString("GIOPF_NIC_CHALLAN_DATE").contains("1900"))
				{ JsonObject.put("GIchallanDateDataIndex","");
				}else{ JsonObject.put("GIchallanDateDataIndex", diffddMMyyyyHHmmss1.format(rs.getTimestamp("GIOPF_NIC_CHALLAN_DATE"))); }
				JsonObject.put("organizationCodeDataIndex", rs.getString("ORGANIZATION_CODE"));
				JsonObject.put("insertedTimeInd", rs.getString("INSERTED_DATETIME"));
				JsonObject.put("districtNameInd", rs.getString("DISTRICT_NAME"));
				
				JsonArray.put(JsonObject);
				if(count%1000==0){
					runGarbageCollector();
				}
			}
			finlist.add(headersList);
			finlist.add(jHeaderList);
			finlist.add(headersType);
		    finlist.add(JsonArray);
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
		DBConnection.releaseConnectionToDB(con, pstmt, rs);
		DBConnection.releaseConnectionToDB(null, pstmt, rs1);
		}
		return finlist;
	}
	public ResultSet getPermitDetailsRS(int systemId,int custId){
		Connection con=null;
		PreparedStatement pstmt=null;
		ResultSet rs=null;
		try {
		    String query="select isnull(a.APPLICATION_NO,'') as 'Application No',isnull(a.PERMIT_NO,'') as 'Permit No',isnull(a.STATUS,'') as Status,isnull(a.DATE,'') as 'Date',isnull(a.FINANCIAL_YEAR,'')as 'Financial Year',isnull(a.PERMIT_REQUEST_TYPE,'')as 'Permit Request Type',isnull(a.OWNER_TYPE,'')as'Owner Type',isnull(a.PERMIT_TYPE,'')as 'Permit Type', "+
			"case when PERMIT_TYPE in ('Rom Transit','Rom Sale')and SRC_TYPE='E-Wallet' then isnull((select top 1 GRADE from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID and (GRADE like '%(ROM)' or GRADE like '%(High Court)')),'') when popd.TYPE in('Fines','Lumps','Concentrates','Tailings') then '' else isnull(popd.GRADE,'') end as ROM, "+ 
			"case when PERMIT_TYPE in ('Rom Transit','Rom Sale')and SRC_TYPE='E-Wallet' then isnull((select top 1 GRADE from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID and GRADE like '%(Fines)'),'')when popd.TYPE='Fines' then isnull(popd.GRADE,'') else'' end as 'Fines', "+
			"case when PERMIT_TYPE in ('Rom Transit','Rom Sale')and SRC_TYPE='E-Wallet' then isnull((select top 1 GRADE from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID and GRADE like '%(Lumps)'),'')when popd.TYPE='Lumps' then isnull(popd.GRADE,'') else'' end as 'Lumps', "+
			"case when popd.TYPE='Concentrates' then isnull(popd.GRADE,'') else'' end as 'Concentrates',case when popd.TYPE='Tailings' then isnull(popd.GRADE,'') else'' end as 'Tailings', "+
			"cast(case when isnull((select sum(QUANTITY) from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID),0)>0 then isnull((select sum(QUANTITY) from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID),0) else isnull((select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=a.ID),0)end as numeric(18,3)) as 'Permit Quantity',cast(isnull(a.TRIPSHEET_QTY,0)/1000 as numeric(18,3)) as 'Used Quantity', "+
			"cast(case when a.STATUS in('CLOSE','CANCEL')then 0 else (case when isnull((select sum(QUANTITY) from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID),0)>0 then isnull((select sum(QUANTITY) from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID),0) else isnull((select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=a.ID),0)end-(isnull(a.TRIPSHEET_QTY,0)/1000))end as numeric(18,3)) as 'Permit Balance', "+
			"cast(case when a.STATUS not in('CLOSE','CANCEL')then 0 else (case when isnull((select sum(QUANTITY) from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID),0)>0 then isnull((select sum(QUANTITY) from AMS.dbo.CHALLAN_GRADE_DETAILS where CHALLAN_ID=a.CHALLAN_ID),0) else isnull((select sum(QUANTITY) from AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS where PERMIT_ID=a.ID),0)end-(isnull(a.TRIPSHEET_QTY,0)/1000))end as numeric(18,3)) as 'To Source', "+
			"(select isnull(sum(QTY),0) from MINING.dbo.MINE_TRIP_FEED_DETAILS where PERMIT_ID=a.ID and PLANT_ID is null and isnull(STATUS,'')!='Cancelled') as 'Self Consumption Quantity',isnull(popd.PROCESSING_FEE,0) as 'Processing Fee',isnull(popd.TOTAL_PROCESSING_FEE,0)as 'Total Processing Fee',isnull(a.CLOSED_QTY,0) as 'Closed Quantity',isnull(d.TC_NO,'') as 'TC No', "+
			"isnull(d.MINE_CODE,'')as 'Mine Code',isnull(b.LEASE_NAME,'') as 'Lease Name',isnull(d.NAME_OF_MINE,'')as 'Lease Owner', "+
			"case when (PERMIT_TYPE in ('Rom Transit','Rom Sale')and SRC_TYPE!='ROM')or PERMIT_TYPE='Bauxite Transit' then '' else isnull(h.ORGANIZATION_CODE,'')end as 'Organization/Trader Code', "+
			"case when (PERMIT_TYPE in ('Rom Transit','Rom Sale')and SRC_TYPE!='ROM')or PERMIT_TYPE='Bauxite Transit' then isnull(e.ORGANIZATION_NAME,'') else isnull(h.ORGANIZATION_NAME,'') end as 'Organization/Trader Name',isnull(a.MINERAL,'') as 'Mineral Type', "+
			"isnull(rd.ROUTE_NAME,'') as 'Route Id',isnull(lz1.NAME,'') as 'From Location',isnull(lz2.NAME,'') as 'To Location',isnull(g.CHALLAN_NO,'') as 'Ref',isnull(a.REMARKS,'') as 'Remarks',isnull(a.START_DATE,'') as 'Start Date',isnull(a.END_DATE,'') as 'End Date', "+  
			"case when a.PERMIT_TYPE in ('Domestic Export','International Export')or IMPORT_TYPE in ('Domestic Import','International Import')then isnull(a.BUYER_NAME,'')else ''end as 'Buyer Name', "+
			"case when a.PERMIT_TYPE in ('International Export','Purchased Rom Sale Transit Permit','Rom Sale','Processed Ore Sale','Processed Ore Sale Transit')or IMPORT_TYPE in ('International Import')then isnull(COUNTRY_NAME,'')else ''end as 'Country', "+ 
			"case when a.PERMIT_TYPE in ('Purchased Rom Sale Transit Permit','Rom Sale','Processed Ore Sale','Processed Ore Sale Transit')then isnull(COUNTRY_NAME,'')else ''end as 'State', "+ 
			"case when a.PERMIT_TYPE='International Export' or IMPORT_TYPE='International Import'then isnull(SHIP_NAME,'')else ''end as 'Vessel Name', "+
			"isnull(bo.ORGANIZATION_NAME,'') as 'Buying Org/Trader Name',isnull(bo.ORGANIZATION_CODE,'') as 'Buying Org/Trader Code',isnull((select PERMIT_NO from AMS.dbo.MINING_PERMIT_DETAILS where ID=a.EXISTING_PERMIT_ID),'')as 'Existing Permit No',isnull(IMPORT_TYPE,'')as 'Import Type',isnull(lz.NAME,'')as 'Source HubName', "+
			"isnull(DEST_TYPE,'') as 'To Location',isnull(SRC_TYPE,'') as 'Source Type',isnull(rd.ROUTE_TYPE,'') as 'Route Type',isnull(mrm.NAME,'') as 'Mother Route' "+
			"from AMS.dbo.MINING_PERMIT_DETAILS a (NOLOCK) "+    
			"left outer join AMS.dbo.MINING_TC_MASTER d (NOLOCK) on a.TC_ID=d.ID and a.SYSTEM_ID=d.SYSTEM_ID and a.CUSTOMER_ID=d.CUSTOMER_ID "+     
			"left outer join AMS.dbo.MINE_OWNER_MASTER b (NOLOCK) on d.SYSTEM_ID=b.SYSTEM_ID and d.CUSTOMER_ID=b.CUSTOMER_ID  and d.TC_NO=b.TC_NO "+   
			"left outer join AMS.dbo.MINING_MINE_MASTER e (NOLOCK) on e.ID=d.MINE_ID and e.SYSTEM_ID=d.SYSTEM_ID and e.CUSTOMER_ID=d.CUSTOMER_ID "+    
			"left outer join AMS.dbo.MINING_CHALLAN_DETAILS (NOLOCK) g on g.ID=a.CHALLAN_ID and g.SYSTEM_ID=a.SYSTEM_ID and g.CUSTOMER_ID=a.CUSTOMER_ID "+  
			"left outer join AMS.dbo.MINING_ORGANIZATION_MASTER (NOLOCK) h on h.ID=a.ORGANIZATION_CODE and h.SYSTEM_ID=a.SYSTEM_ID and h.CUSTOMER_ID=a.CUSTOMER_ID "+ 
			"left outer join AMS.dbo.MINING_ORGANIZATION_MASTER (NOLOCK) bo on bo.ID=a.BUYING_ORG_ID and bo.SYSTEM_ID=a.SYSTEM_ID and bo.CUSTOMER_ID=a.CUSTOMER_ID "+ 
			"left outer join ADMINISTRATOR.dbo.STATE_DETAILS sd (NOLOCK) on sd.STATE_CODE=a.STATE "+   
			"left outer join ADMINISTRATOR.dbo.COUNTRY_DETAILS cd (NOLOCK) on cd.COUNTRY_CODE=a.COUNTRY "+   
			"left outer join AMS.dbo.PROCESSED_ORE_PERMIT_DETAILS popd (NOLOCK) on popd.PERMIT_ID=a.ID "+ 
			"left outer join MINING.dbo.IMPORT_PERMIT_DETAILS ipd (NOLOCK) on ipd.PERMIT_ID=a.ID "+ 
			"left outer join AMS.dbo.LOCATION_ZONE_A lz (NOLOCK) on lz.HUBID=a.ROUTE_ID "+ 
			"left outer join MINING.dbo.ROUTE_DETAILS rd (NOLOCK) on rd.ID=a.ROUTE_ID and rd.SYSTEM_ID=a.SYSTEM_ID and rd.CUSTOMER_ID=a.CUSTOMER_ID "+ 
			" left outer join MINING.dbo.MOTHER_ROUTE_MASTER mrm (NOLOCK) on mrm.ID=rd.MOTHER_ROUTE_ID " +
			"left outer join AMS.dbo.LOCATION_ZONE_A lz1 (NOLOCK) on lz1.HUBID=rd.SOURCE_HUB_ID "+ 
			"left outer join AMS.dbo.LOCATION_ZONE_A lz2 (NOLOCK) on lz2.HUBID=rd.DESTINATION_HUB_ID "+  
			"where a.SYSTEM_ID=? and a.CUSTOMER_ID=? order by a.ID desc ";
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(query);
			pstmt.setInt(1,systemId);
			pstmt.setInt(2,custId);
			rs = pstmt.executeQuery();
		} 
		catch (Exception e){	e.printStackTrace();	} 
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
