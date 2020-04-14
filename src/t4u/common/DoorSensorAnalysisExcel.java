package t4u.common;


import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;

import java.util.ArrayList;

import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;


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
import jxl.format.VerticalAlignment;
import jxl.write.Label;
import jxl.write.NumberFormat;
import jxl.write.NumberFormats;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;

import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;


import org.apache.commons.lang.SystemUtils;
import org.json.JSONObject;

import t4u.GeneralVertical.DoorAnalysis;

import t4u.beans.LoginInfoBean;

import t4u.beans.SubListBean;

public class DoorSensorAnalysisExcel extends HttpServlet {

	/**
	 * @author Bhagyashree
	 */
	private static final long serialVersionUID = 1L;
	File outFile;
	int rowNo;
	int cellStart = 0;
	int cellEnd;
	int mid;
	int noOfLinesPerSheet;
	int cc = 0;
	int sheetNo = 0;
	int leftAlign;
	ArrayList reportTitleList;
	ArrayList dataHeaderList;
	ArrayList < Integer > colSpanList = new ArrayList < Integer > ();
	ArrayList dataList;
	ArrayList dataTypeList;

	public static final String GET_TEMPERATURE_REPORT = " select isnull(LOCATION,'') as LOCATION,REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,IO_VALUE,IO_ID,IO_CATEGORY from  AMS.dbo.RS232_LIVE " +
	" where REGISTRATION_NO=?  " +
	" and GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?) "+
	" union all "+
	" select isnull(LOCATION,'') as LOCATION,REGISTRATION_NO,dateadd(mi,?,GMT)as GMT ,IO_VALUE,IO_ID,IO_CATEGORY from  AMS.dbo.RS232_HISTORY " +
	" where REGISTRATION_NO=?  " +
	" and  GMT between dateadd(mi,-?,?) and  dateadd(mi,-?,?)   order by GMT ";
	
	
	Colour COLOR_CON_BKG = Colour.WHITE;
	WritableFont summaryWF = new WritableFont(WritableFont.ARIAL, 8, WritableFont.BOLD);
	WritableFont headerWF = new WritableFont(WritableFont.ARIAL, 9, WritableFont.BOLD);
	WritableFont dataWF = new WritableFont(WritableFont.ARIAL, 8, WritableFont.BOLD);
	WritableCellFormat intFormat = new WritableCellFormat(dataWF, NumberFormats.INTEGER);
	WritableCellFormat intCell = new WritableCellFormat(intFormat);
	WritableCellFormat floatFormat = new WritableCellFormat(dataWF, NumberFormats.FLOAT);
	WritableCellFormat floatCell = new WritableCellFormat(floatFormat);
	NumberFormat dp2 = new NumberFormat("0.00");
	WritableCellFormat dp2cell = new WritableCellFormat(dataWF, dp2);
	DecimalFormat df1 = new DecimalFormat("##.##");
	List<Integer> nwdList=null;
	List<String> regnoList=null;
	List<String> totalKMList=null;


	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		LoginInfoBean logininfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = logininfo.getSystemId();
		int offset = logininfo.getOffsetMinutes();
		int userId = logininfo.getUserId();
		String requestParams = request.getParameter("requestParameter");		
		String regNo = "";
		int clientId = 0;
		String date1 = "";
		String date2 = "";
		
		String reportName = "Door Sensor Analysis Report";
	//	requestParams = requestParams.replace("^", "@");
	//	if (!requestParams.equals(null) && !requestParams.equals("") && requestParams.contains("@")) {
	//		String requestParamsarr[] = requestParams.split("@");
			date1  = request.getParameter("date1");
			date2 = request.getParameter("date2");
			regNo = request.getParameter("regNo");	
			clientId = Integer.parseInt(request.getParameter("clientId"));
	//	}
 
		String startTime = date1;
		String endTime = date2;
		ArrayList < String > headerDataList = new ArrayList<String>();		
		HashMap < String, ArrayList < Object >> mainmap = new HashMap < String, ArrayList < Object >> ();
	
		try {
			String excelpath = null;
			if(SystemUtils.IS_OS_LINUX || SystemUtils.IS_OS_UNIX){
				excelpath = "/opt/cluster/platform/filePath/Reports/";
			}else{
				excelpath = "C:\\Reports\\";
			}
			refreshdir(excelpath);
			String formno = "DoorSensorAnalysisReport";
			String excel = excelpath + formno + ".xls";
			File outFile = new File(excel);

			List<DoorAnalysis>	beanList = new ArrayList<DoorAnalysis> ();
			beanList = getTemperatureReport(systemId, clientId, offset, userId, startTime, endTime, regNo);
			ArrayList < ArrayList < String >> reportList = new ArrayList < ArrayList < String >> ();
			ArrayList < String > dataList = new ArrayList < String > ();				
			int SLNO = 0;			
			ServletOutputStream servletOutputStream = null;
			
					headerDataList.add("SL_NO");
					headerDataList.add("REGISTRATION NUMBER");
					headerDataList.add("DATE");
					headerDataList.add("LOCATION");
					headerDataList.add("L1");
					headerDataList.add("L2");
					headerDataList.add("L3");
					headerDataList.add("L4");
					headerDataList.add("R1");
					headerDataList.add("R2");
					headerDataList.add("R3");
					headerDataList.add("R4");
					headerDataList.add("BL");
					headerDataList.add("BR");
					headerDataList.add("TEMPERATURE1");					
					headerDataList.add("TEMPERATURE2");				
					headerDataList.add("IBUTTON1");
				
					
			
						 for(DoorAnalysis bean  : beanList) {
							 SLNO++;
								dataList = new ArrayList < String > ();
								dataList.add(String.valueOf(SLNO));
								dataList.add(bean.getRegistrationNo());
								dataList.add(bean.getGMT());
								dataList.add(bean.getLocation());
								dataList.add(bean.getINPT1Value());
								dataList.add(bean.getINPT2Value());
								dataList.add(bean.getINPT3Value());
								dataList.add(bean.getINPT4Value());
								dataList.add(bean.getINPT5Value());
								dataList.add(bean.getINPT6Value());
								dataList.add(bean.getINPT7Value());
								dataList.add(bean.getINPT8Value());
								dataList.add(bean.getINPT9Value());
								dataList.add(bean.getINPT10Value());					
								dataList.add(bean.getTEMEPERATURE1Value());				
								dataList.add(bean.getTEMEPERATURE2Value());
								dataList.add(bean.getBUTTON1Value());
								reportList.add(dataList);
					    }												
					try {
						servletOutputStream = response.getOutputStream();
					} catch (IOException e) {
						e.printStackTrace();
					}

					ArrayList colSpanDataTypeList = getColspanDataTypeList(" ", headerDataList);
					ArrayList < Integer > colSpanList = (ArrayList) colSpanDataTypeList.get(0);
					ArrayList dataTypeList = (ArrayList) colSpanDataTypeList.get(1);
					int noOfLinePerSheet = reportList.size();

					ArrayList < String > reportTitleList = new ArrayList < String > ();
					reportTitleList.add(reportName);
					reportTitleList.add("Date: " + startTime + " To " + endTime);

					prepareExcel(regNo,excel, systemId, request, headerDataList, reportList, reportTitleList, colSpanList, dataTypeList, cellStart, noOfLinePerSheet, outFile);
				
			        printExcel(response, servletOutputStream, systemId, "", "", excel,"DoorSensorAnalysisReport");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void prepareExcel(String regNum,String excel, int systemId, HttpServletRequest request, ArrayList headersList, ArrayList reportList, ArrayList reportTitleList, ArrayList < Integer > colSpanList, ArrayList dataTypeList, int cellStart, int noOfLinesPerSheet, File outFile) {
		this.reportTitleList = reportTitleList;
		this.dataHeaderList = headersList;
		this.colSpanList = colSpanList;
		this.dataList = reportList;
		this.cellStart = cellStart;
		this.outFile = outFile;
		this.dataTypeList = dataTypeList;
		cellEnd = getCellEnd();
		mid = (cellStart + cellEnd) / 7;
		this.noOfLinesPerSheet = noOfLinesPerSheet;

		generateExcel(regNum,excel, headersList, reportList, noOfLinesPerSheet, systemId, request);

	}

	public void generateExcel(String regNum,String pdf, ArrayList headersList, ArrayList reportList, int noOfLinePerSheet, int systemId, HttpServletRequest request) {
		try {
			WritableWorkbook workbook = Workbook.createWorkbook(outFile);
			int dataSize = dataList.size();
			int sheetNo = 0;
			for(int i = 0; i < dataSize; i +=noOfLinesPerSheet)
			{
				int startLineNo = i;
				int endLineNo = (i+noOfLinesPerSheet)>dataSize?dataSize:(i+noOfLinesPerSheet);
				if(startLineNo==0)
				{
					rowNo = 0;
					String sheetName = (startLineNo+1) + " - " + endLineNo;
					WritableSheet sheet = workbook.createSheet(sheetName, sheetNo);
							writeReportTitle(sheet);
							writeReportSummary(sheet);
							writeDataHeader(sheet);    		     
							writeData(sheet, startLineNo, endLineNo);
							sheetNo++;
						}
					}
					workbook.write();
					workbook.close();
					
			
		} catch (Exception e) {
			e.printStackTrace();
		}

	} //end generate

	public void writeReportTitle(WritableSheet sheet) {
		try {
			WritableFont titleWF = new WritableFont(WritableFont.ARIAL, 11, WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE, Colour.DARK_BLUE2);
			WritableCellFormat cf = new WritableCellFormat(titleWF);
			WritableCellFormat cfs = new WritableCellFormat(summaryWF);
			cf.setBackground(Colour.ICE_BLUE);
			cf.setAlignment(Alignment.CENTRE);
			cf.setWrap(false);
			
			if (reportTitleList.size() > 0) {
				
				String lbStr = (String) reportTitleList.get(0);
				Label title=null;				
				rowNo++;	     
				int row = rowNo;
				title = new Label(cellStart, row, lbStr, cf);
				sheet.addCell(title);
				sheet.mergeCells(cellStart, row, cellEnd, row+1);	   
			}
			rowNo++;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void writeReportSummary(WritableSheet sheet) {
		try {
			WritableCellFormat cf = new WritableCellFormat(summaryWF);
			cf.setBackground(COLOR_CON_BKG);
			cf.setBorder(Border.ALL, BorderLineStyle.THIN, Colour.BLACK);
			cf.setAlignment(Alignment.LEFT);
			cf.setWrap(false);
			if (reportTitleList.size() > 0) {
					String lbStr = (String) reportTitleList.get(1);
					rowNo++;
					int col3 = cellStart;
					int row = rowNo;
					Label title = new Label(col3, row, lbStr, cf);
					sheet.addCell(title);
				rowNo++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void writeDataHeader(WritableSheet sheet) {

		try {
			WritableCellFormat cf = new WritableCellFormat(headerWF);
			cf.setBackground(Colour.GRAY_25);
			cf.setBorder(Border.ALL, BorderLineStyle.MEDIUM, Colour.BLACK);
			cf.setAlignment(Alignment.CENTRE);
			cf.setVerticalAlignment(VerticalAlignment.CENTRE);
			cf.setWrap(false);

			WritableCellFormat cf2 = new WritableCellFormat(headerWF);
			cf2.setBackground(Colour.GRAY_25);
			cf2.setAlignment(Alignment.CENTRE);
			cf2.setVerticalAlignment(VerticalAlignment.TOP);
			cf2.setBorder(Border.ALL, BorderLineStyle.MEDIUM, Colour.BLACK);
			cf2.setWrap(false);
			int row = rowNo++;
			rowNo++;
			int col = cellStart;
			int col2 = cellStart;
			int size = dataHeaderList.size();
			int tripCount = 1;
			for (int i = 0; i < size; i++) {
				String lbStr = (String) dataHeaderList.get(i);
				Label label = new Label(col, row, lbStr, cf);
				sheet.addCell(label);
				col++;

			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public void writeData(WritableSheet sheet, int startLineNo, int endLineNo) {
		cc = 0;
		try {

			for (int i = startLineNo; i < endLineNo; i++) {

				if (dataList.get(i) instanceof ArrayList) {
					ArrayList rowList = (ArrayList) dataList.get(i);
					createDataRow(rowList, sheet, "dataRow");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void createDataRow(ArrayList rowList, WritableSheet sheet, String rowtype) {
		try {

			WritableCellFormat cf = new WritableCellFormat(dataWF);
			cf.setWrap(false);

			WritableCellFormat firstCell = new WritableCellFormat(intFormat);
			firstCell.setWrap(false);
			firstCell.setAlignment(Alignment.LEFT);

			int row = rowNo++;
			int size = rowList.size();
			int col = cellStart;
			for (int i = 0; i < size; i++) {
				String dataStr = null;
				if (rowList.get(i) != null) {
					dataStr = rowList.get(i).toString();
				}
				String type = (String) dataTypeList.get(i);

				if (type.equals("int") && rowtype.equals("dataRow")) {
					if (dataStr != null && !dataStr.equals("")) {
						int data = Integer.parseInt(dataStr);
						sheet.addCell(new jxl.write.Number(col, row, data, firstCell));
					} else {
						sheet.addCell(new Label(col, row, "", cf));
					}
				} else if (type.equals("string") && rowtype.equals("dataRow")) {
					if (dataStr != null && !dataStr.equals("")) {
						sheet.addCell(new Label(col, row, dataStr, firstCell));
					} else {
						sheet.addCell(new Label(col, row, "", cf));
					}
				} else {
					if (dataStr == null) {
						dataStr = "";
					}
					sheet.addCell(new Label(col, row, dataStr, cf));
				}

				int colSpanVal = colSpanList.get(i);
				if (colSpanVal > 1) {
					int extraCell = colSpanVal - 1;
					sheet.mergeCells(col, row, col + extraCell, row);
					col = col + extraCell;
				}
				col++;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public ArrayList getColspanDataTypeList(String reportType, ArrayList headerList) {
		ArrayList colSpanDataTypeList = new ArrayList();
		ArrayList dataTypeList = new ArrayList();
		ArrayList < Integer > colSpanList = new ArrayList < Integer > ();

		for (int i = 0; i < headerList.size(); i++) {
			dataTypeList.add("string");
			colSpanList.add(1);
		}

		colSpanDataTypeList.add(colSpanList);
		colSpanDataTypeList.add(dataTypeList);
		return colSpanDataTypeList;
	}
	public int getCellEnd() {
		int cellEnd = 0;
		for (int i = 0; i < colSpanList.size(); i++) {
			cellEnd = cellEnd + colSpanList.get(i);
		}
		cellEnd--;
		return (cellEnd + cellStart);
	}

	private void refreshdir(String reportpath) {
		File f = new File(reportpath);
		if (!f.exists()) {
			f.mkdirs();
		}
	}

	
	public List<DoorAnalysis> getTemperatureReport(int systemId,int clientId,int offset,int userId,String startDate,String endDate,String regNo){

		JSONObject JsonObject = new JSONObject();
		Connection con = null;
		PreparedStatement pstmt = null;		 
		ResultSet rs = null;	
		
		List<JSONObject>expList =null;
		List<DoorAnalysis> beanList =null;
		DoorAnalysis ieBean=null;
		try {
			LinkedHashSet<Date> tempSet =new LinkedHashSet<Date>();
			con = DBConnection.getConnectionToDB("AMS");
			pstmt = con.prepareStatement(GET_TEMPERATURE_REPORT);
			pstmt.setInt(1, offset);
			pstmt.setString(2, regNo);
			pstmt.setInt(3, offset);
			pstmt.setString(4, startDate);
			pstmt.setInt(5, offset);
			pstmt.setString(6, endDate);
			pstmt.setInt(7, offset);
			pstmt.setString(8, regNo);
			pstmt.setInt(9, offset);
			pstmt.setString(10, startDate);
			pstmt.setInt(11, offset);
			pstmt.setString(12, endDate);
			rs = pstmt.executeQuery();
		    expList = new ArrayList<JSONObject>();
		    String reffer="";
		    int count=0;
		    while(rs.next()){
		    	count++;
		    	 JsonObject = new JSONObject();
		    	 JsonObject.put("regNo", regNo);
				 JsonObject.put("datetime", rs.getTimestamp("GMT"));
				 JsonObject.put("ioValue", rs.getString("IO_VALUE"));
				 JsonObject.put("ioCategory", rs.getString("IO_CATEGORY"));
				 JsonObject.put("ioID", rs.getString("IO_ID"));
				 JsonObject.put("location", rs.getString("LOCATION"));
				 expList.add(JsonObject);
		    	 tempSet.add(rs.getTimestamp("GMT"));
		    }
		    beanList =new ArrayList<DoorAnalysis>();
		    for (Date date : tempSet) {
		    	ieBean =new DoorAnalysis();
		    	for (JSONObject obj : expList) {
		    		if(obj.get("datetime").equals(date)){
		    			String ioValue = "";
		    			ieBean.setGMT(obj.getString("datetime"));
		    			ieBean.setRegistrationNo(obj.getString("regNo"));
		    			ieBean.setLocation(obj.getString("location"));
		    			if(obj.getString("ioValue").equals("0")){
		    				ioValue = "CLOSE";
		    			} else if (obj.getString("ioValue").equals("1")) {
		    				ioValue = "OPEN";
		    			} else {
		    				ioValue = "";
		    			}
		    		  if(obj.getString("ioID").equals("INP1")){
		    			  ieBean.setINPT1Value(ioValue);
		    		  }	
		    		  if(obj.getString("ioID").equals("INP2")){
		    			  ieBean.setINPT2Value(ioValue);
		    		  }
		    		  if (obj.getString("ioID").equals("INP3")){
		    			  ieBean.setINPT3Value(ioValue);
		    		  }
		    		  if(obj.getString("ioID").equals("INP4")){
		    			  ieBean.setINPT4Value(ioValue);
		    		  }
		    		  if(obj.getString("ioID").equals("INP5")){
		    			  ieBean.setINPT5Value(ioValue);
		    		  }
		    		  if(obj.getString("ioID").equals("INP6")){
		    			  ieBean.setINPT6Value(ioValue);
		    		  }
		    		  if(obj.getString("ioID").equals("INP7")){
		    			  ieBean.setINPT7Value(ioValue);
		    		  }
		    		  if(obj.getString("ioID").equals("INP8")){
		    			  ieBean.setINPT8Value(ioValue);
		    		  }
		    		 if(obj.getString("ioID").equals("INP9")){
		    			  ieBean.setINPT9Value(ioValue);
		    		  }
		    		  if(obj.getString("ioID").equals("INP10")){
		    			  ieBean.setINPT10Value(ioValue);
		    		  }
		    		 if(obj.getString("ioCategory").equals("TEMPERATURE1")){
		    			  ieBean.setTEMEPERATURE1Value(obj.getString("ioValue"));
		    		  }
		    		 if(obj.getString("ioCategory").equals("TEMPERATURE2")){
		    			  ieBean.setTEMEPERATURE2Value(obj.getString("ioValue"));
		    		  }
		    		  if(obj.getString("ioCategory").equals("IBUTTON1")){
		    			  ieBean.setBUTTON1Value(obj.getString("ioValue"));
		    		  }
		    		}
				}
		    	beanList.add(ieBean);		    	
			}
		   Collections.sort(beanList);
		
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
		}
		return beanList;
}

	
	private void printExcel(HttpServletResponse response, ServletOutputStream servletOutputStream, int systemId, String division, String dateToDisplay, String excel,String formno) {
		try {

			response.setContentType("application/xls");
			response.setHeader("Content-disposition", "attachment;filename=" + formno + ".xls");
			DataOutputStream outputStream = new DataOutputStream(servletOutputStream);
			FileInputStream fis = new FileInputStream(excel);
			byte[] buffer = new byte[1024];
			int len = 0;
			while ((len = fis.read(buffer)) >= 0) {
				outputStream.write(buffer, 0, len);
			}
			servletOutputStream.flush();
			servletOutputStream.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}