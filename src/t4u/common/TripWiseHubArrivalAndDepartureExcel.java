package t4u.common;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Map.Entry;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import jxl.write.Label;
import jxl.write.NumberFormat;

import org.apache.commons.lang.SystemUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFClientAnchor;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFPatriarch;
import org.apache.poi.hssf.usermodel.HSSFPicture;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.ClientAnchor;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.Drawing;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.RegionUtil;
import org.apache.poi.util.IOUtils;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtilities;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.category.BarRenderer;
import org.jfree.chart.title.LegendTitle;
import org.jfree.data.category.CategoryDataset;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.ui.RectangleEdge;
import java.awt.*;
import java.io.*;
import t4u.beans.LoginInfoBean;
import t4u.functions.CommonFunctions;
import t4u.beans.SubListBean;

public class TripWiseHubArrivalAndDepartureExcel extends HttpServlet {

	/**
	 * @author Bhagyashree
	 */
	private static final long serialVersionUID = 1L;
	FileOutputStream outFile;
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
	
	NumberFormat dp2 = new NumberFormat("0.00");
	
	DecimalFormat df1 = new DecimalFormat("##.##");
	List<Integer> nwdList=null;
	List<String> regnoList=null;
	List<String> totalKMList=null;
	List<Double> vehicleUsageList=null;
	
	HSSFRow  row = null;
	HSSFCell cell = null;
	    
	HSSFWorkbook workbook = null;
	HSSFWorkbook wb = null;
	HSSFFont fontBold = null;
	HSSFFont fontForHeader =null;
	HSSFCellStyle cellStyle = null;
	HSSFCellStyle borderStyle = null;
	HSSFCellStyle headerStyle = null;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		LoginInfoBean logininfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = logininfo.getSystemId();
		int offset = logininfo.getOffsetMinutes();
		String locationzone = logininfo.getZone();
		String requestParams = request.getParameter("requestParameter");
		int month = 0;
		int year = 0;
		String regNo = "";
		List<String> regList=new ArrayList<String>();
		
		int clientId = 0;
		String reportName = "TripWise Hub Arrival And Departure Report";
		requestParams = requestParams.replace("|", ":");
		if (!requestParams.equals(null) && !requestParams.equals("") && requestParams.contains(":")) {
			String requestParamsarr[] = requestParams.split(":");
			month = Integer.parseInt(requestParamsarr[1]);
			year = Integer.parseInt(requestParamsarr[0].trim());

			regNo = requestParamsarr[3];
			String regNoArray[]=regNo.trim().split(",");
			for(int i=0;i<regNoArray.length;i++)
			{
				if(!regNoArray[i].equalsIgnoreCase("ALL"))
					regList.add(regNoArray[i]);
			}
			clientId = Integer.parseInt(requestParamsarr[2]);
			reportName =  requestParamsarr[4];
		}

		SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy/MM/dd");
		SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyy/MM/dd");

		SimpleDateFormat sdf2 = new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		SimpleDateFormat formatter2 = new java.text.SimpleDateFormat("hh:mm");

		SimpleDateFormat sdf3 = new java.text.SimpleDateFormat("yyyy/MM/dd");
		SimpleDateFormat formatter3 = new java.text.SimpleDateFormat("dd-MM-yyyy");

		Calendar c1 = Calendar.getInstance();
		c1.set(Calendar.YEAR, year);
		c1.set(Calendar.MONTH, month);
		c1.set(Calendar.DAY_OF_MONTH, 1);

		Calendar c2 = Calendar.getInstance();
		c2.set(Calendar.YEAR, year);
		c2.set(Calendar.MONTH, month);
		c2.set(Calendar.DAY_OF_MONTH, c2.getActualMaximum(Calendar.DAY_OF_MONTH));

		String startTime = sdf.format(c1.getTime());
		String endTime = sdf.format(c2.getTime());

		Date startDate = null;
		Date endDate = null;
		try {
			startDate = formatter.parse(startTime);
			endDate = formatter.parse(endTime);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		Calendar start = Calendar.getInstance();
		start.setTime(startDate);
		Calendar end = Calendar.getInstance();
		end.setTime(endDate);

		CommonFunctions funobj = new CommonFunctions();
		ArrayList < String > headerDataList = null;
		ArrayList < String > summaryDataList = new ArrayList < String > ();
		HashMap < String, ArrayList < SubListBean >> dataMap = new HashMap < String, ArrayList < SubListBean >> ();
		HashMap < String, ArrayList < Object >> mainmap = new HashMap < String, ArrayList < Object >> ();
		int MaxtripCount = 1;
		int noOfWorkingDays = 0;
		int noOfDysInMon = 1;
		long diffDays = (endDate.getTime() - startDate.getTime());
		diffDays = diffDays / (24 * 60 * 60 * 1000)+1;
		noOfDysInMon = (int) diffDays;
		String regNum = "";
		try {
			String excelpath = null;
			if(SystemUtils.IS_OS_LINUX || SystemUtils.IS_OS_UNIX){
				excelpath = "/opt/cluster/platform/filePath/Reports/";
			}else{
				excelpath = "C:\\Reports\\";
			}	
			refreshdir(excelpath);
			String formno = "TripWiseHubArrivalAndDeparture";
			String excel = excelpath + formno + ".xls";
			outFile = new FileOutputStream(excel);
			workbook=new HSSFWorkbook();
			
			fontBold = workbook.createFont();
			fontBold.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			fontBold.setFontHeightInPoints((short)12);
			
			fontForHeader = workbook.createFont();
			fontForHeader.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
			fontForHeader.setFontHeightInPoints((short)10);
			
		    cellStyle = workbook.createCellStyle();
		    borderStyle = workbook.createCellStyle();
		    headerStyle = workbook.createCellStyle();
		    
			cellStyle.setFillForegroundColor(HSSFColor.CORNFLOWER_BLUE.index);
			cellStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
			cellStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			cellStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
			cellStyle.setWrapText(true);
			cellStyle.setFont(fontBold);
			
			//borderStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);	
		    borderStyle.setAlignment(HSSFCellStyle.ALIGN_RIGHT);
		    borderStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		    borderStyle.setWrapText(true);
		    
		    headerStyle.setFillForegroundColor(HSSFColor.LIGHT_BLUE.index);
		    headerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
		    headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
		    headerStyle.setVerticalAlignment(HSSFCellStyle.VERTICAL_CENTER);
		    headerStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		 
		    headerStyle.setWrapText(true);
		    headerStyle.setFont(fontForHeader);
			
			ServletOutputStream servletOutputStream = null;

			nwdList=new ArrayList<Integer>();  
			regnoList=new ArrayList<String>();
			totalKMList=new ArrayList<String>();
			vehicleUsageList=new ArrayList<Double>();
			for(int ii=0;ii<regList.size();ii++)
			{

				String regNo1=regList.get(ii);
				mainmap = funobj.getHubArrivalAndDepartureDetails(systemId, month, year, regNo1, clientId, offset,locationzone);
				start = Calendar.getInstance();
				start.setTime(startDate);
				end = Calendar.getInstance();
				end.setTime(endDate);	
				//System.out.println("Map "+mainmap);
				if(!mainmap.isEmpty()){
					// if multiple regno put it in a for loop
					headerDataList = new ArrayList < String > ();
					for (Map.Entry < String, ArrayList < Object >> entry: mainmap.entrySet()) {	
						regNum = entry.getKey();
						ArrayList < Object > tripdetails = entry.getValue();
						MaxtripCount = (Integer) tripdetails.get(0);
						summaryDataList = (ArrayList < String > ) tripdetails.get(1);
						dataMap = (HashMap < String, ArrayList < SubListBean >> ) tripdetails.get(2);
						noOfWorkingDays = dataMap.size();
					}
					System.out.println("MaxtripCount ="+MaxtripCount);
					// generate header list
					headerDataList.add("SL_NO");
					headerDataList.add("DATE");
					for (int i = 0; i < MaxtripCount; i++) {
						headerDataList.add("InTime");
						headerDataList.add("OutTime");
						headerDataList.add("Branch");
					}
					headerDataList.add("TotalTime");
					headerDataList.add("Comments");

					ArrayList < ArrayList < String >> reportList = new ArrayList < ArrayList < String >> ();
					ArrayList < String > dataList = new ArrayList < String > ();
					// generate data list
					int SLNO = 0;

					for (Date date = start.getTime(); start.before(end) || start.equals(end); start.add(Calendar.DATE, 1), date = start.getTime()) {

						ArrayList < SubListBean > innerList = new ArrayList < SubListBean > ();
						String dates = formatter.format(date);

						if (dataMap.containsKey(dates)) {
							SLNO++;
							dataList = new ArrayList < String > ();
							innerList = new ArrayList < SubListBean > ();
							innerList = dataMap.get(dates);

							dataList.add(String.valueOf(SLNO));
							dates = formatter3.format(sdf3.parse(dates));

							dataList.add(dates);
							String inTime = "";
							String outTime = "";
							
							double duration = 0.0;
							for (int y = 0; y < innerList.size(); y++) {
								try {
									inTime = innerList.get(y).getInTime().toString();
									inTime = inTime.substring(0, inTime.indexOf("."));
									inTime = formatter2.format(sdf2.parse(inTime));
									outTime = innerList.get(y).getOutTime().toString();
									outTime = outTime.substring(0, outTime.indexOf("."));
									outTime = formatter2.format(sdf2.parse(outTime));
									duration = duration + innerList.get(y).getDuration();
								} catch (Exception e) {
									e.printStackTrace();
								}
								dataList.add(inTime);
								dataList.add(outTime);
								if(innerList.get(y).getBranchName().toString()!=null&&!innerList.get(y).getBranchName().toString().equalsIgnoreCase(""))
								{
									String branchName[]=innerList.get(y).getBranchName().toString().split(",");
									dataList.add(branchName[0]);
								}
								else
								{
									dataList.add("");
								}
							}
							int emptycolumns = 0;
							if (headerDataList.size() > dataList.size()) {
								emptycolumns = headerDataList.size() - dataList.size();
							}
							for (int i = 0; i < emptycolumns; i++) {
								dataList.add("");
							}
							int hrs = (int) (duration/60);
							int mins =(int) duration%60;
							String durations = hrs+":"+mins;

							dataList.set(dataList.size() - 2, durations);
							reportList.add(dataList);

						} else {	
							SLNO++;
							dataList = new ArrayList < String > ();
							dataList.add(String.valueOf(SLNO));
							dates = formatter3.format(sdf3.parse(dates));
							dataList.add(dates);
							int emptycolumns = 0;
							if (headerDataList.size() > dataList.size()) {
								emptycolumns = headerDataList.size() - dataList.size();
							}
							for (int i = 0; i < emptycolumns; i++) {
								dataList.add("");
							}
							String durations = "00:00";
							dataList.set(dataList.size() - 2, durations);
							reportList.add(dataList);
						}
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
					reportTitleList.add("Vehicle Type: " + summaryDataList.get(1));
					reportTitleList.add("Vehicle Model: " + summaryDataList.get(2));
					reportTitleList.add("Total KM: " + summaryDataList.get(3));
					reportTitleList.add("Vehicle Number: " + regNum);
					reportTitleList.add("Date: " + startTime + " To " + endTime);

					prepareExcel(summaryDataList.get(3),regNum,workbook,excel, systemId, request, headerDataList, reportList, reportTitleList, colSpanList, dataTypeList, cellStart, noOfLinePerSheet, outFile,MaxtripCount,noOfWorkingDays,noOfDysInMon);
				}
				//else part  can be added here which is helpful for printing the vehicle details to excel when there is no data
			}

			HSSFSheet sheet = workbook.createSheet("Statistics");
			String lbStr="Vehicle No";

			int col1 = 1;
			int rowNum = 1;
			
			row = sheet.createRow(rowNum);
            cell = row.createCell((short)col1);
            cell.setCellValue(lbStr);
            sheet.autoSizeColumn(col1);

			lbStr = " Total Operating Days Per Month ";
			col1++;
			cell = row.createCell((short)col1);
	        cell.setCellValue(lbStr);
	        sheet.autoSizeColumn(col1);

			lbStr = " Net Working Days Per Month ";
			col1++;
			cell = row.createCell((short)col1);
	        cell.setCellValue(lbStr);
	        sheet.autoSizeColumn(col1);

	        lbStr = " Vehicle Availability ";
			col1++;
			cell = row.createCell((short)col1);
	        cell.setCellValue(lbStr);
	        sheet.autoSizeColumn(col1);
			// sheet.mergeCells(col1, row, cellEnd-2, row);

			lbStr = " Vehicle Usage ";
			col1++;
			cell = row.createCell((short)col1);
	        cell.setCellValue(lbStr);
	        sheet.autoSizeColumn(col1);

			lbStr = " Total KM ";
			col1++;
			cell = row.createCell((short)col1);
	        cell.setCellValue(lbStr);
	        sheet.autoSizeColumn(col1);

			System.out.println("nwdList ="+nwdList);
			System.out.println("regnoList ="+regnoList);
			System.out.println("noOfDysInMon ="+noOfDysInMon);
			System.out.println("totalKMList ="+totalKMList);

			col1=1;
			for(int i=0;i<regnoList.size();i++)
			{
				rowNum++; 
				String regno = regnoList.get(i);
				Integer noOfWork=nwdList.get(i);
				String totalKM=totalKMList.get(i);
				
				row = sheet.createRow(rowNum);
				cell = row.createCell((short)col1);
		        cell.setCellValue(regno);
		        sheet.autoSizeColumn(col1);
				col1++; 

				cell = row.createCell((short)col1);
		        cell.setCellValue(String.valueOf(noOfWork));
		        sheet.autoSizeColumn(col1);
				
				col1++; 
				cell = row.createCell((short)col1);
		        cell.setCellValue(String.valueOf(noOfWork));
		        sheet.autoSizeColumn(col1);

				col1++; 
				cell = row.createCell((short)col1);
		        cell.setCellValue("100%");
		        sheet.autoSizeColumn(col1);
				
				col1++; 
				double vehicleUsage =1.0;
				if(noOfWorkingDays!=0){
					vehicleUsage =  ( Double.parseDouble(String.valueOf(noOfWork * 100 ))/Double.parseDouble(String.valueOf(noOfDysInMon)));
				}
				vehicleUsage = Double.parseDouble(df1.format(vehicleUsage));

				cell = row.createCell((short)col1);
		        cell.setCellValue(vehicleUsage+"%");
		        sheet.autoSizeColumn(col1);

				col1++; 
				cell = row.createCell((short)col1);
		        cell.setCellValue(totalKM);
		        sheet.autoSizeColumn(col1);
				col1=1; 
			}
			setBordersToMergedCells(workbook,sheet);
			rowNum++;
			
			String graphElements[]={"Vehicle Availability","Vehicle Usage","Total KM"};
			for(int i=0;i<graphElements.length;i++)
			{
				 CategoryDataset catDataset=createDataset(sheet,graphElements[i]);
				 JFreeChart BarChartObject=null;
				 if(graphElements[i].equals("Total KM"))
				 {
					  BarChartObject=ChartFactory.createBarChart(graphElements[i],"Vehicles",graphElements[i],catDataset,PlotOrientation.VERTICAL,true,true,false); 
				 }
				 else
				 {
					  BarChartObject=ChartFactory.createBarChart(graphElements[i],"Vehicles",graphElements[i]+" (%)",catDataset,PlotOrientation.VERTICAL,true,true,false); 
				 }
				 int row=drawImage(BarChartObject,sheet,rowNum);
				 rowNum=row;
			}
             
			workbook.write(outFile);
			outFile.flush();
			outFile.close();
			printExcel(response, servletOutputStream, systemId, "", "", excel,"TripWiseHubArrivalAndDeparture");

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private CategoryDataset createDataset(HSSFSheet sheet,String title){
		DefaultCategoryDataset dataset = new DefaultCategoryDataset();
		if(title.equals("Vehicle Availability"))
        {
	         for(String regNo:regnoList)
	         {
	        	 dataset.addValue(100, "", regNo);        	 
	         }
         }
         else if(title.equals("Vehicle Usage")){
        	Map<String,String> vehicleToUsageMap=null;
     		vehicleToUsageMap = new LinkedHashMap<String,String>();
     		for(int i=0;i<regnoList.size();i++){
     			vehicleToUsageMap.put(regnoList.get(i), vehicleUsageList.get(i).toString());
     		}
     		for(Entry<String, String> vehicleUsageEntry : vehicleToUsageMap.entrySet()) {
       	      dataset.addValue(Double.parseDouble(vehicleUsageEntry.getValue()), "", vehicleUsageEntry.getKey());     
     		}
         }
         else if(title.equals("Total KM"))
         {
        		Map<String,String> vehicleToTotalKm=null;
        		vehicleToTotalKm = new LinkedHashMap<String,String>();
        		for(int i=0;i<regnoList.size();i++){
        			vehicleToTotalKm.put(regnoList.get(i), totalKMList.get(i).toString());
        		}
        		for(Entry<String, String> totalKMEntry : vehicleToTotalKm.entrySet()) {
             	      dataset.addValue(Double.parseDouble(totalKMEntry.getValue()), "", totalKMEntry.getKey());     
             	}
         }
		return dataset;
	}
	public int drawImage(JFreeChart BarChartObject,HSSFSheet sheet,int rowNum)
	{
		int r=0;
		try
		{		
		         ByteArrayOutputStream chart_out = new ByteArrayOutputStream(); 
		         /* Create the drawing container */
		         HSSFPatriarch drawing = sheet.createDrawingPatriarch();
		         int width=700; /* Width of the chart */
		         int height=480; /* Height of the chart */   
		     	 CategoryPlot categoryPlot = BarChartObject.getCategoryPlot();
		     	 LegendTitle legend = BarChartObject.getLegend();
		     	 ChartUtilities.writeChartAsPNG(chart_out,BarChartObject,width,height);
				 BarRenderer br = (BarRenderer) categoryPlot.getRenderer();
				 br.setSeriesPaint(0, new Color(12, 35, 255));
				// br.setMaximumBarWidth(.30); 
				 br.setItemMargin(.1);
				 legend.setPosition(RectangleEdge.TOP);
				 //legend.setVisible(false); 
		         /* We can now read the byte data from output stream and stamp the chart to Excel worksheet */
		         int my_picture_id = workbook.addPicture(chart_out.toByteArray(), Workbook.PICTURE_TYPE_PNG);
		         /* we close the output stream as we don't need this anymore */
		         chart_out.close();
		         /* Create an anchor point */
		         ClientAnchor my_anchor = new HSSFClientAnchor();
		         /* Define top left corner, and we can resize picture suitable from there */
		         my_anchor.setCol1(1);
		         my_anchor.setRow1(++rowNum);
		         /* Invoke createPicture and pass the anchor point and ID */
		         HSSFPicture  my_picture = drawing.createPicture(my_anchor, my_picture_id);
		         /* Call resize method, which resizes the image */
		         my_picture.resize();
		         r=rowNum+30;
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
		return r;
	}

	public void prepareExcel(String totalkm,String regNum,HSSFWorkbook workbook,String excel, int systemId, HttpServletRequest request, ArrayList headersList, ArrayList reportList, ArrayList reportTitleList, ArrayList < Integer > colSpanList, ArrayList dataTypeList, int cellStart, int noOfLinesPerSheet, FileOutputStream outFile,int MaxtripCount,int noOfWorkingDays,int noOfDysInMon) {
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

		generateExcel(totalkm,regNum,workbook,excel, headersList, reportList, noOfLinesPerSheet, systemId, request,MaxtripCount,noOfWorkingDays,noOfDysInMon);

	}

	public void generateExcel(String totalkm,String regNum,HSSFWorkbook workbook,String pdf, ArrayList headersList, ArrayList reportList, int noOfLinePerSheet, int systemId, HttpServletRequest request,int MaxtripCount,int noOfWorkingDays,int noOfDysInMon) {
		try {
			int dataSize = reportList.size();
			String sheetName = regNum;
			sheetNo++;
			HSSFSheet sheet = workbook.createSheet(sheetName);
			for (int i = 0; i < reportList.size(); i++) {
				int startLineNo = i;
				int endLineNo = (i + noOfLinesPerSheet) > dataSize ? dataSize : (i + noOfLinesPerSheet);
				if (startLineNo == 0) {
					rowNo = 0;
					writeReportTitle(sheet);
					writeReportSummary(sheet);
					writeDataHeader(sheet);    		     
					writeData(sheet, startLineNo, endLineNo);
				}
			}
			writeReportSummaryAsFooter(totalkm,regNum,sheet,noOfWorkingDays,MaxtripCount,noOfDysInMon);
			setBordersToMergedCells(workbook,sheet);
		} catch (Exception e) {
			e.printStackTrace();
		}

	} //end generate

	private void setBordersToMergedCells(HSSFWorkbook workBook, HSSFSheet sheet) {
        int numMerged = sheet.getNumMergedRegions();

    for(int i= 0; i<numMerged;i++){
        CellRangeAddress mergedRegions = sheet.getMergedRegion(i);
        RegionUtil.setBorderTop(CellStyle.BORDER_THIN, mergedRegions, sheet, workBook);
        RegionUtil.setBorderLeft(CellStyle.BORDER_THIN, mergedRegions, sheet, workBook);
        RegionUtil.setBorderRight(CellStyle.BORDER_THIN, mergedRegions, sheet, workBook);
        RegionUtil.setBorderBottom(CellStyle.BORDER_THIN, mergedRegions, sheet, workBook);
    }
}
	
	public void  writeReportSummaryAsFooter(String totalkm,String regNum,HSSFSheet sheet,int noOfWorkingDays,int MaxtripCount,int noOfDysInMon) {
		try {
			
			nwdList.add(noOfWorkingDays);
			regnoList.add(regNum);
			totalKMList.add(totalkm);	    

			double vehicleUsage =1.0;
			if(noOfWorkingDays!=0){
				vehicleUsage =  ( Double.parseDouble(String.valueOf(noOfWorkingDays *100 ))/Double.parseDouble(String.valueOf(noOfDysInMon)));
			}
			vehicleUsage = Double.parseDouble(df1.format(vehicleUsage));
			vehicleUsageList.add(vehicleUsage);

			String lbStr = " Total Operating Days Per Month ";
			rowNo++;
			int col3 = cellStart;
			int rowNum = rowNo;
			
			row = sheet.createRow(rowNum);
            cell = row.createCell((short)col3);
            cell.setCellValue(lbStr);
            cell.setCellStyle(borderStyle);
            sheet.addMergedRegion(new Region(rowNum,(short)col3, rowNum, (short)(cellEnd-2)));
			
            cell = row.createCell((short)cellEnd-1);
            cell.setCellValue(String.valueOf(noOfWorkingDays));
            cell.setCellStyle(borderStyle);
            sheet.addMergedRegion(new Region(rowNum,(short)(cellEnd-1), rowNum, (short)(cellEnd-1)));
            
	
			lbStr = " Number of Days The Vehicle Is Out Of Service";
			rowNo++;
			col3 = cellStart;
			rowNum=rowNo;
			
			row = sheet.createRow(rowNum);
		    sheet.addMergedRegion(new Region(rowNum,(short)col3, rowNum, (short)(cellEnd-2)));
            cell = row.createCell((short)col3);
            cell.setCellValue(lbStr);
            cell.setCellStyle(borderStyle);
			
            sheet.addMergedRegion(new Region(rowNum,(short)(cellEnd-1), rowNum, (short)(cellEnd-1)));
            cell = row.createCell((short)(cellEnd-1));
            cell.setCellValue(""); 
            cell.setCellStyle(borderStyle);
           
			for(int i=1;i<=MaxtripCount;i++){
				lbStr = " Number of Vehicles Has Been Breakdown During The Trip "+i;
				rowNo++;
				col3 = cellStart;
				rowNum = rowNo;
				
				row = sheet.createRow(rowNum);
			    sheet.addMergedRegion(new Region(rowNum,(short)col3, rowNum, (short)(cellEnd-2)));
		        cell = row.createCell((short)col3);
		        cell.setCellValue(lbStr);
		        cell.setCellStyle(borderStyle);
				
		        sheet.addMergedRegion(new Region(rowNum,(short)(cellEnd-1), rowNum, (short)(cellEnd-1)));
	            cell = row.createCell((short)(cellEnd-1));
	            cell.setCellValue("");
	            cell.setCellStyle(borderStyle);
			}

			lbStr = " Net Working Days ";
			rowNo++;
			col3 = cellStart;
			rowNum = rowNo;
			
			   row = sheet.createRow(rowNum);
			   sheet.addMergedRegion(new Region(rowNum,(short)col3, rowNum, (short)(cellEnd-2)));
		        cell = row.createCell((short)col3);
		        cell.setCellValue(lbStr);
		        cell.setCellStyle(borderStyle);
				
		        sheet.addMergedRegion(new Region(rowNum,(short)(cellEnd-1), rowNum, (short)(cellEnd-1)));
	            cell = row.createCell((short)(cellEnd-1));
	            cell.setCellValue(String.valueOf(noOfWorkingDays)); 
	            cell.setCellStyle(borderStyle);
			
			lbStr = " Number of Days In Month ";
			rowNo++;
			col3 = cellStart;
			rowNum = rowNo;
			
			row = sheet.createRow(rowNum);
			sheet.addMergedRegion(new Region(rowNum,(short)col3, rowNum, (short)(cellEnd-2)));
		    cell = row.createCell((short)col3);
		    cell.setCellValue(lbStr);
		    cell.setCellStyle(borderStyle);
				
		    sheet.addMergedRegion(new Region(rowNum,(short)(cellEnd-1), rowNum, (short)(cellEnd-1)));
	        cell = row.createCell((short)(cellEnd-1));
	        cell.setCellValue(String.valueOf(noOfDysInMon)); 
	        cell.setCellStyle(borderStyle);

			lbStr = " Vehicle Availability ";
			rowNo++;
			col3 = cellStart;
			rowNum = rowNo;
			
			row = sheet.createRow(rowNum);
			sheet.addMergedRegion(new Region(rowNum,(short)col3, rowNum, (short)(cellEnd-2)));
		    cell = row.createCell((short)col3);
		    cell.setCellValue(lbStr);
		    cell.setCellStyle(borderStyle);
				
	        sheet.addMergedRegion(new Region(rowNum,(short)(cellEnd-1), rowNum, (short)(cellEnd-1)));
            cell = row.createCell((short)(cellEnd-1));
	        cell.setCellValue("100%");
	        cell.setCellStyle(borderStyle);
	        
			lbStr = " Vehicle Usage";
			rowNo++;
			col3 = cellStart;
			rowNum = rowNo;
			
			row = sheet.createRow(rowNum);
			sheet.addMergedRegion(new Region(rowNum,(short)col3, rowNum, (short)(cellEnd-2)));
		    cell = row.createCell((short)col3);
		    cell.setCellValue(lbStr);
		    cell.setCellStyle(borderStyle);
				
		    sheet.addMergedRegion(new Region(rowNum,(short)(cellEnd-1), rowNum, (short)(cellEnd-1)));
	        cell = row.createCell((short)(cellEnd-1));
	        cell.setCellValue(vehicleUsage+"%");
	        cell.setCellStyle(borderStyle);
		
			rowNo++;

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public void writeReportTitle(HSSFSheet sheet) {
		try {
			Properties p=ApplicationListener.prop;
			String imagePath=p.getProperty("ImagePath").trim();
			InputStream inputStream = new FileInputStream(imagePath+"logokbf.png");
			byte[] imageBytes = IOUtils.toByteArray(inputStream);
			int pictureureIdx = workbook.addPicture(imageBytes, Workbook.PICTURE_TYPE_PNG);
			inputStream.close();
			CreationHelper helper = workbook.getCreationHelper();
			Drawing drawing = sheet.createDrawingPatriarch();
			ClientAnchor anchor = helper.createClientAnchor();
			anchor.setCol1(0);
			anchor.setRow1(1);
			drawing.createPicture(anchor, pictureureIdx).resize();
			
			if (reportTitleList.size() > 0) {
				String lbStr = (String) reportTitleList.get(0);
				rowNo++;	     
				int rowNum=rowNo;		  
				  row = sheet.createRow(rowNum);
	              sheet.addMergedRegion(new Region((short)rowNum,(short)cellStart, (short)rowNum+1, (short)cellEnd));
	              cell = row.createCell((short)0);
	              cell.setCellValue(lbStr);            
	              cell.setCellStyle(cellStyle);
			}
			rowNo++;
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void writeReportSummary(HSSFSheet sheet) {
		try {
			
			if (reportTitleList.size() > 0) {
				for (int i = 1; i < reportTitleList.size(); i++) {
					String lbStr = (String) reportTitleList.get(i);
					rowNo++;
					int col3 = cellStart;
					row= sheet.createRow(rowNo);
					sheet.addMergedRegion(new Region(rowNo,(short)0, rowNo, (short)(col3+5)));
					cell = row.createCell((short)0);
		            cell.setCellValue(lbStr); 
				}
				rowNo++;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void writeDataHeader(HSSFSheet sheet) {
		try {
			
			int rowNum = rowNo++;
			rowNo++;
			int col = cellStart;
			int col2 = cellStart;
			int size = dataHeaderList.size();
			int tripCount = 1;
			row = sheet.createRow(rowNum);
			for (int i = 0; i < size; i++) {
				String lbStr = (String) dataHeaderList.get(i);
				int colSpanVal = colSpanList.get(i);
				if (i == 0 || i == 1 || i == (size - 2) || i == (size - 1)) {
					row=sheet.getRow(rowNum);
					sheet.addMergedRegion(new Region(rowNum,(short)col, rowNum+1, (short)col));
					cell = row.createCell((short)col);
		            cell.setCellValue(lbStr); 
		            cell.setCellStyle(headerStyle);
		            sheet.autoSizeColumn(col);
					col++;
					col2++;
					} else {
					if (col2 <= size - 4) {
						row=sheet.getRow(rowNum);
						sheet.addMergedRegion(new Region(rowNum,(short)col2, rowNum, (short)(col2+2)));
						cell = row.createCell((short)col2);
			            cell.setCellValue("Trip " + tripCount); 
			            cell.setCellStyle(headerStyle);
			            sheet.autoSizeColumn(col2);
						col2 = col2 + 3;
						tripCount++;
					}
					if(col==2)
					{
						row = sheet.createRow(rowNum+1);	
					}
					row=sheet.getRow(rowNum+1);
					sheet.addMergedRegion(new Region(rowNum+1,(short)col, rowNum+1, (short)col));
					cell = row.createCell((short)col);
		            cell.setCellValue(lbStr);
		            cell.setCellStyle(headerStyle);
		            sheet.autoSizeColumn(col);
					col++;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void writeData(HSSFSheet sheet, int startLineNo, int endLineNo) {
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

	public void createDataRow(ArrayList rowList, HSSFSheet sheet, String rowtype) {
		try {	

			int rowNum = rowNo++;
			int size = rowList.size();
			int col = cellStart;
			row = sheet.createRow(rowNum);
			for (int i = 0; i < size; i++) {
				String dataStr = null;
				if (rowList.get(i) != null) {
					dataStr = rowList.get(i).toString();
				}
				String type = (String) dataTypeList.get(i);

				if (type.equals("int") && rowtype.equals("dataRow")) {
					cell = row.createCell((short)col);
					if (dataStr != null && !dataStr.equals("")) {
						int data = Integer.parseInt(dataStr);
						//sheet.addMergedRegion(new Region(rowNum,(short)col, rowNum+1, (short)col));
			            cell.setCellValue(data);
					} else {
						 cell.setCellValue("");
					}
				} else if (type.equals("string") && rowtype.equals("dataRow")) {
					cell = row.createCell((short)col);
					if (dataStr != null && !dataStr.equals("")) {
						cell.setCellValue(dataStr);
					} else {
						cell.setCellValue("");
					}
				} else {
					if (dataStr == null) {
						dataStr = "";
					}
					cell.setCellValue(dataStr);
				}

				int colSpanVal = colSpanList.get(i);
				if (colSpanVal > 1) {
					int extraCell = colSpanVal - 1;
					sheet.addMergedRegion(new Region(rowNum,(short)col, rowNum, (short)(col + extraCell)));
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

	private void printExcel(HttpServletResponse response, ServletOutputStream servletOutputStream, int systemId, String division, String dateToDisplay, String excel,String formno) {
		try 
		{
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