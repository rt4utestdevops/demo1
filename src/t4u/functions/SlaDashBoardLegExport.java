package t4u.functions;

import java.io.File;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;

import t4u.GeneralVertical.LegDetailsBean;
import t4u.GeneralVertical.LegInfoBean;
import t4u.common.ApplicationListener;

public class SlaDashBoardLegExport {
	SimpleDateFormat sdfDBMMDD = new SimpleDateFormat("yyyy-MM-dd");
	CommonFunctions cf = new CommonFunctions();
	DecimalFormat df2=new DecimalFormat("0.00");
	DecimalFormat df3 = new DecimalFormat("00");
	DecimalFormat df1 = new DecimalFormat("00");
	SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	SimpleDateFormat mmddyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");	
	
	public static final String headerList[]={
		"Leg ID",
		"Driver 1 Name",
		"Driver 1 Contact",
		"Driver 2 Name",
		"Driver 2 Contact",
		"Origin",
		"Destination",
		"STD",
		"ATD",
		"Departure Delay wrt STD (HH:mm:ss)",
		"Planned Transit Time (incl. planned stoppages)(HH:mm:ss)",
		"STA wrt ATD",
		"ETA",
		"ATA",
		"Actual Transit Time (incl. planned and unplanned stoppages)(HH:mm:ss)",
		"Transit Delay (HH:mm:ss)",
		"Trip Status",
		"Leg Distance (Kms)",
	};
	
 	public String CreateExcel(Connection con,ArrayList<LegDetailsBean> legBean){
 		
 		String completePath=null;
		try {
			Calendar cal= Calendar.getInstance();
			Date endDate = cal.getTime();
			cal.add(Calendar.DATE, -1);
			Date startDate = cal.getTime();
			String name = "Leg Details Report";
			String customername="DHL_LEG_REPORT";
			Properties properties = ApplicationListener.prop;
			String rootPath =  properties.getProperty("legCreatePath");
			//String rootPath ="C:\\LegDetailsExcel";
			//completePath = rootPath + "//" + name + "_"+customername+"_"+ sdfDBMMDD.format(startDate) +"_"+sdfDBMMDD.format(endDate)+ ".xls";
			completePath = rootPath + "//" +customername+ Calendar.getInstance().getTimeInMillis()+ ".xls";
			File f = new File(rootPath);
			if (!f.exists()) {
				f.mkdir();
			}
			
			FileOutputStream fileOut = new FileOutputStream(completePath);

			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet worksheet = workbook.createSheet("Report");
			HSSFRow customerNameRow=null;
			
			CreationHelper createHelper = workbook.getCreationHelper();

			
			HSSFFont font = null;
			font = workbook.createFont();
			font.setBoldweight(Font.BOLDWEIGHT_BOLD); 
			
			HSSFFont titleFont = null;
			titleFont = workbook.createFont();
			titleFont.setFontName(HSSFFont.FONT_ARIAL);
			titleFont.setFontHeightInPoints((short)15);
			titleFont.setBoldweight(Font.BOLDWEIGHT_BOLD); 
			
			HSSFCellStyle headerStyle = workbook.createCellStyle();
			headerStyle.setFont(titleFont);
			headerStyle.setAlignment(HSSFCellStyle.ALIGN_CENTER);
			
			HSSFCellStyle styleForCustomer = workbook.createCellStyle();
			styleForCustomer.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			
			CellStyle blankOrNAStyle = workbook.createCellStyle();
			blankOrNAStyle.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
			blankOrNAStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
			blankOrNAStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			blankOrNAStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			blankOrNAStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			blankOrNAStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			blankOrNAStyle.setAlignment(CellStyle.ALIGN_RIGHT);
			
			DataFormat fmt = workbook.createDataFormat();
			HSSFCellStyle timeStyleForLegs = workbook.createCellStyle();
			timeStyleForLegs.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			timeStyleForLegs.setDataFormat(fmt.getFormat("@"));
			
			HSSFCellStyle decimalStyleForLegs = workbook.createCellStyle();
			decimalStyleForLegs.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			decimalStyleForLegs.setDataFormat(fmt.getFormat("0.00"));
			
			
			// Create Cell Style for formatting Date
			CellStyle dateCellStyle = workbook.createCellStyle();
			dateCellStyle.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy HH:mm:ss"));
			dateCellStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			dateCellStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			dateCellStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			dateCellStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			dateCellStyle.setAlignment(CellStyle.ALIGN_RIGHT);
			
			CellStyle dateStyleForTrips = workbook.createCellStyle();
			dateStyleForTrips.setFont(font);
			dateStyleForTrips.setFillForegroundColor(IndexedColors.GREY_40_PERCENT.index);
			dateStyleForTrips.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND); 
			dateStyleForTrips.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			dateStyleForTrips.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			dateStyleForTrips.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			dateStyleForTrips.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			dateStyleForTrips.setAlignment(CellStyle.ALIGN_RIGHT);
			dateStyleForTrips.setDataFormat(createHelper.createDataFormat().getFormat("dd/MM/yyyy HH:mm:ss"));
			
			

			// Create Cell Style for formatting as Text
			CellStyle defaultCellStyle = workbook.createCellStyle();
			defaultCellStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			defaultCellStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			defaultCellStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			defaultCellStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			DataFormat fmt1 = workbook.createDataFormat();
			defaultCellStyle.setDataFormat( fmt1.getFormat("@"));
			
			CellStyle decimalStyle = workbook.createCellStyle();
			decimalStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			decimalStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			decimalStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			decimalStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			decimalStyle.setAlignment(CellStyle.ALIGN_RIGHT);
			decimalStyle.setDataFormat(fmt1.getFormat("0.00"));


			CellStyle integerStyle = workbook.createCellStyle();
			integerStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			integerStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			integerStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			integerStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			integerStyle.setAlignment(CellStyle.ALIGN_RIGHT);
			integerStyle.setDataFormat(fmt1.getFormat("0"));
			
			CellStyle 	SintegerStyle = workbook.createCellStyle();
			SintegerStyle.setFont(font);
			SintegerStyle.setFillForegroundColor(IndexedColors.GREY_40_PERCENT.index);
			SintegerStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND); 
			SintegerStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			SintegerStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			SintegerStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			SintegerStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);
			SintegerStyle.setAlignment(CellStyle.ALIGN_RIGHT);
			SintegerStyle.setDataFormat(fmt1.getFormat("0"));
			
			CellStyle summaryStyle = workbook.createCellStyle();
			summaryStyle.setFont(font);
			summaryStyle.setFillForegroundColor(IndexedColors.GREY_40_PERCENT.index);
			summaryStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND); 
			//summaryStyle.setBorderTop((short) 1); // single line border
			//summaryStyle.setBorderBottom((short) 1); // single line border
			summaryStyle.setAlignment(HSSFCellStyle.ALIGN_LEFT);
			summaryStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			summaryStyle.setBorderTop(HSSFCellStyle.BORDER_MEDIUM);
			summaryStyle.setBorderRight(HSSFCellStyle.BORDER_MEDIUM);
			summaryStyle.setBorderLeft(HSSFCellStyle.BORDER_MEDIUM);

			
			HSSFCellStyle style1 = workbook.createCellStyle();
			style1.setFont(font);
			
			HSSFRow row=worksheet.createRow((short)0);
			worksheet.createFreezePane(0, 4);
			
			HSSFCell titleCellC1 = row.createCell((short)0);
			titleCellC1.setCellValue("SLA Leg Wise Details");
			titleCellC1.setCellStyle(headerStyle);
			worksheet.addMergedRegion(new Region(0,(short)0,1,(short)13));
			
			//System.out.println("legBean.size() ::"+legBean.size());
			int rowNumber=3;
			
			HSSFRow row1 = worksheet.createRow((short) rowNumber);
			
			HSSFCell cellA1 = row1.createCell((short) 0);
			cellA1.setCellValue("S.No");
			cellA1.setCellStyle(style1);

			for(int i = 0; i < headerList.length; i++) {
				Cell cell = row1.createCell(i);
				cell.setCellValue(headerList[i]);
				cell.setCellStyle(style1);

			}
			
			int summaryRowCount = 0;
			for(int i=0;i<legBean.size();i++)
			{
				
				long sDepartureDelay=0;
				long sPlannedT=0;
				long sActualT=0;
				long sTransitDelay=0;
				double sLegDistance=0.0;
				
				//rowNumber++;
			    if(legBean.get(i).getLegDetails().size()>0)
			    {
			    	rowNumber++;
					customerNameRow = worksheet.createRow((short)rowNumber);
			    	
					HSSFCell cellC1 = customerNameRow.createCell((short)0);
					//cellC1.setCellValue(legBean.get(i).getCustomerName());
					cellC1.setCellStyle(styleForCustomer);
					worksheet.addMergedRegion(new Region(rowNumber,(short)0,rowNumber,(short)13));
					
					rowNumber++;
			    						
					worksheet.addMergedRegion(new Region(rowNumber,(short)0,rowNumber,(short)13));
					int count = 0;
					
					String std = "";
					String atd = "";
					String sta = "";
					String ata = "";
					String eta ="";
					Double totalDistance = 0.0;
					
			    	for (int ii = 0; ii < legBean.get(i).getLegDetails().size(); ii++) 
					{
			    		std=legBean.get(i).getSTD();
			    		atd=legBean.get(i).getATD();
			    		eta=legBean.get(i).getETA();
			    		ata=legBean.get(i).getATA();
			    		List<LegInfoBean> internalLegBean = legBean.get(i).getLegDetails();
						//String customerName = internalLegBean.getShipmentId();
						//System.out.println(" legBean.get(i).getLegDetails().size();;"+ legBean.get(i).getLegDetails().size());
						count++;
						rowNumber++;
						HSSFRow row2 = worksheet.createRow((short) rowNumber);
						row2.setRowStyle(styleForCustomer);
						
						
						Cell cellL0 = row2.createCell((short) 0);
						if(internalLegBean.get(ii).getLegName().equalsIgnoreCase("")||internalLegBean.get(ii).getLegName().equalsIgnoreCase("NA"))
						{
							cellL0.setCellValue(internalLegBean.get(ii).getLegName());// "" or NA
							cellL0.setCellStyle(blankOrNAStyle);
						}
						else
						{
							cellL0.setCellValue(internalLegBean.get(ii).getLegName());///Driver 1 Name 
							cellL0.setCellStyle(defaultCellStyle);
						}
						
						    Cell  cell1 = row2.createCell((short) 1);
							if(internalLegBean.get(ii).getDriver1().equalsIgnoreCase("")||internalLegBean.get(ii).getDriver1().equalsIgnoreCase("NA"))
							{
								cell1.setCellValue(internalLegBean.get(ii).getDriver1());// "" or NA
								cell1.setCellStyle(blankOrNAStyle);
							}
							else
							{
								cell1.setCellValue(internalLegBean.get(ii).getDriver1());///Driver 1 Name 
								cell1.setCellStyle(defaultCellStyle);
							}
							
							Cell cellM1 = row2.createCell((short) 2);	
							if(internalLegBean.get(ii).getDriver1Contact().equalsIgnoreCase("")||internalLegBean.get(ii).getDriver1Contact().equalsIgnoreCase("NA")){
								cellM1.setCellValue(internalLegBean.get(ii).getDriver1Contact());//"" or NA 
								cellM1.setCellStyle(blankOrNAStyle);
							}else{
								cellM1.setCellValue(internalLegBean.get(ii).getDriver1Contact());//Driver 1 Contact 
								cellM1.setCellStyle(defaultCellStyle);
							}
							
							Cell cellN1 = row2.createCell((short) 3);
							if(internalLegBean.get(ii).getDriver2().equalsIgnoreCase("")||internalLegBean.get(ii).getDriver2().equalsIgnoreCase("NA"))
							{
								cellN1.setCellValue(internalLegBean.get(ii).getDriver2());//"" or NA
								cellN1.setCellStyle(blankOrNAStyle);
							}
							else
							{
								cellN1.setCellValue(internalLegBean.get(ii).getDriver2());//Driver 2 Name
								cellN1.setCellStyle(defaultCellStyle);
							}
							
							 Cell cellO1 = row2.createCell((short) 4);	
							if(internalLegBean.get(ii).getDriver2Contact().equalsIgnoreCase("")||internalLegBean.get(ii).getDriver2Contact().equalsIgnoreCase("NA")){
								cellO1.setCellValue(internalLegBean.get(ii).getDriver2Contact());//"" OR NA
								cellO1.setCellStyle(blankOrNAStyle);
							}else{
								cellO1.setCellValue(internalLegBean.get(ii).getDriver2Contact());//Driver 2 Contact
								cellO1.setCellStyle(defaultCellStyle);
							}
							
							Cell cellP1 = row2.createCell((short) 5);
							if(internalLegBean.get(ii).getSource().equalsIgnoreCase("")||internalLegBean.get(ii).getSource().equalsIgnoreCase("NA")){
								cellP1.setCellValue(internalLegBean.get(ii).getSource());//"" or NA
								cellP1.setCellStyle(blankOrNAStyle);
							}else{
								cellP1.setCellValue(internalLegBean.get(ii).getSource());//Origin
								cellP1.setCellStyle(defaultCellStyle);
							}
							
							Cell cellQ1 = row2.createCell((short) 6);	
							if(internalLegBean.get(ii).getDestination().equalsIgnoreCase("")||internalLegBean.get(ii).getDestination().equalsIgnoreCase("NA")){
								cellQ1.setCellValue(internalLegBean.get(ii).getDestination());//"" or NA
								cellQ1.setCellStyle(blankOrNAStyle);
							}else{
								cellQ1.setCellValue(internalLegBean.get(ii).getDestination());//Destination
								cellQ1.setCellStyle(defaultCellStyle);
							}
							
							Cell cellR1 = row2.createCell((short) 7);
							if(internalLegBean.get(ii).getLegSTD().equalsIgnoreCase("")||internalLegBean.get(ii).getLegSTD().equalsIgnoreCase("NA")){
								cellR1.setCellValue(internalLegBean.get(ii).getLegSTD());//"" or NA
								cellR1.setCellStyle(blankOrNAStyle);
							}else{
								cellR1.setCellValue(internalLegBean.get(ii).getLegSTD());//STD
								cellR1.setCellStyle(dateCellStyle);
							}

							Cell cellS1 = row2.createCell((short) 8);	
							if(internalLegBean.get(ii).getLegATD().equalsIgnoreCase("")||internalLegBean.get(ii).getLegATD().equalsIgnoreCase("NA"))
							{
								cellS1.setCellValue(internalLegBean.get(ii).getLegATD());//"" or NA
								cellS1.setCellStyle(blankOrNAStyle);
							}else{
								cellS1.setCellValue(internalLegBean.get(ii).getLegATD());//ATD
								cellS1.setCellStyle(dateCellStyle);
							}
							
							Cell cellU1 = row2.createCell((short) 9);	
							if(internalLegBean.get(ii).getDepartureDelayWrtSTD().equalsIgnoreCase("")||internalLegBean.get(ii).getDepartureDelayWrtSTD().equalsIgnoreCase("NA")){
								cellU1.setCellValue(internalLegBean.get(ii).getDepartureDelayWrtSTD());//"" or NA
								cellU1.setCellStyle(blankOrNAStyle);
							}else
							{
								sDepartureDelay+=internalLegBean.get(ii).getsDepartureDelay();
								cellU1.setCellValue(internalLegBean.get(ii).getDepartureDelayWrtSTD());//delayedDepartureATD_STD
								cellU1.setCellStyle(defaultCellStyle);
							}
							
							//plannedTransitTime
							Cell cellpt = row2.createCell((short) 10);	
							if(internalLegBean.get(ii).getPlannedTransitTime().equalsIgnoreCase("")||internalLegBean.get(ii).getPlannedTransitTime().equalsIgnoreCase("NA")){
								cellpt.setCellValue(internalLegBean.get(ii).getPlannedTransitTime());//"" or NA
								cellpt.setCellStyle(blankOrNAStyle);
							}else{
								cellpt.setCellValue(internalLegBean.get(ii).getPlannedTransitTime());//plannedTransitTime
								cellpt.setCellStyle(defaultCellStyle);
								sPlannedT+=internalLegBean.get(ii).getsPlannedT();
							}
							
							
							///date
							Cell cellswa = row2.createCell((short) 11);	
							if(internalLegBean.get(ii).getSTAwrtATD().equalsIgnoreCase("")||internalLegBean.get(ii).getSTAwrtATD().equalsIgnoreCase("NA")){
								cellswa.setCellValue(internalLegBean.get(ii).getSTAwrtATD());//"" or NA
								cellswa.setCellStyle(blankOrNAStyle);
							}else{
								cellswa.setCellValue(internalLegBean.get(ii).getSTAwrtATD());//ETA
								cellswa.setCellStyle(defaultCellStyle);
							}
						
							
							Cell cellT1 = row2.createCell((short) 12);	
							if(internalLegBean.get(ii).getLegETA().equalsIgnoreCase("")||internalLegBean.get(ii).getLegETA().equalsIgnoreCase("NA")){
								cellT1.setCellValue(internalLegBean.get(ii).getLegETA());//"" or NA
								cellT1.setCellStyle(blankOrNAStyle);
							}else{
								cellT1.setCellValue(internalLegBean.get(ii).getLegETA());//ETA
								cellT1.setCellStyle(dateCellStyle);
							}
							
							Cell cellata = row2.createCell((short) 13);	
							if(internalLegBean.get(ii).getLegATA().equalsIgnoreCase("")||internalLegBean.get(ii).getLegATA().equalsIgnoreCase("NA")){
								cellata.setCellValue(internalLegBean.get(ii).getLegATA());//"" or nA
								cellata.setCellStyle(blankOrNAStyle);
							}else{
								cellata.setCellValue(internalLegBean.get(ii).getLegATA());//ATA
								cellata.setCellStyle(dateCellStyle);
							}
							
							Cell cellV1 = row2.createCell((short) 14);	
							if(internalLegBean.get(ii).getActualTransitTime().equalsIgnoreCase("")||internalLegBean.get(ii).getActualTransitTime().equalsIgnoreCase("NA")){
								cellV1.setCellValue(internalLegBean.get(ii).getActualTransitTime());//"" or NA
								cellV1.setCellStyle(blankOrNAStyle);
							}else{
								cellV1.setCellValue(internalLegBean.get(ii).getActualTransitTime());//ActualTransitTime
								cellV1.setCellStyle(defaultCellStyle);
								sActualT+=internalLegBean.get(ii).getsActualT();
							}
							
							Cell cell15 = row2.createCell((short) 15);	
							if(internalLegBean.get(ii).getTransitDelay().equalsIgnoreCase("")||internalLegBean.get(ii).getTransitDelay().equalsIgnoreCase("NA")){
								cell15.setCellValue(internalLegBean.get(ii).getTransitDelay());//"" or NA
								cell15.setCellStyle(blankOrNAStyle);
							}else{
								cell15.setCellValue(internalLegBean.get(ii).getTransitDelay());//getTransitDelay
								cell15.setCellStyle(defaultCellStyle);
								sTransitDelay+=internalLegBean.get(ii).getsTransitDelay();
							}
							
							Cell cell16 = row2.createCell((short) 16);	
							cell16.setCellValue(legBean.get(i).getStatus());//getTransitDelay
							cell16.setCellStyle(defaultCellStyle);
							
							Cell cell17 = row2.createCell((short) 17);	
							if(internalLegBean.get(ii).getLegDistance()==0){
								cell17.setCellValue(internalLegBean.get(ii).getLegDistance());//"" or NA
								cell17.setCellStyle(blankOrNAStyle);
							}else{
								cell17.setCellValue(internalLegBean.get(ii).getLegDistance());//getTransitDelay
								cell17.setCellStyle(decimalStyle);
								sLegDistance+=internalLegBean.get(ii).getLegDistance();
							}
						
						
							totalDistance = totalDistance +  Double.parseDouble(internalLegBean.get(ii).getTotalDistance());
			    		
					}
			    	rowNumber++;
			    	HSSFRow tripNameRow = worksheet.createRow((short)rowNumber);
			    	//tripNameRow.setRowStyle(summaryStyle);
			    	
			    	Cell c0 = tripNameRow.createCell((short)0);
			    	c0.setCellValue("");//Seria Number
			    	c0.setCellStyle(summaryStyle);

			    	Cell c1 = tripNameRow.createCell((short)1);
			    	c1.setCellValue("");//Seria Number
			    	c1.setCellStyle(summaryStyle);
					
			    	Cell c2 = tripNameRow.createCell((short)2);
			    	c2.setCellValue("");//Seria Number
			    	c2.setCellStyle(summaryStyle);
					
			    	Cell c3 = tripNameRow.createCell((short)3);
			    	c3.setCellValue("");//Seria Number
			    	c3.setCellStyle(summaryStyle);
					
			    	Cell c4 = tripNameRow.createCell((short)4);
			    	c4.setCellValue("");//Seria Number
			    	c4.setCellStyle(summaryStyle);
			    	
					Cell cell5 = tripNameRow.createCell((short) 5);	
					cell5.setCellValue(legBean.get(i).getOrigin());//Origin
					cell5.setCellStyle(summaryStyle);
					
					Cell cell6 = tripNameRow.createCell((short) 6);	
					cell6.setCellValue(legBean.get(i).getDestination());//Destination
					cell6.setCellStyle(summaryStyle);
					
					
					
					Cell cell7 = tripNameRow.createCell((short) 7);	
					cell7.setCellValue(std);//STD
					cell7.setCellStyle(dateStyleForTrips); //summaryStyle

					Cell cell8 = tripNameRow.createCell((short) 8);	
					cell8.setCellValue(atd);//ATD
					cell8.setCellStyle(dateStyleForTrips);  //summaryStyle
					
					
					//departureDelaywrtSTD
					Cell cell9 = tripNameRow.createCell((short) 9);	
					//cell9.setCellValue(legBean.get(i).getDepartureDelayWrtSTD());
					cell9.setCellValue((sDepartureDelay!=0)?formattedHoursMinutesSeconds(sDepartureDelay):"");
					cell9.setCellStyle(summaryStyle);
					
					//plannedTransitTime
					Cell cell10 = tripNameRow.createCell((short) 10);	
					//cell10.setCellValue(legBean.get(i).getPlannedTransitTime());
					cell10.setCellValue((sPlannedT!=0)?formattedHoursMinutesSeconds(sPlannedT):"");
					
					cell10.setCellStyle(summaryStyle);
					
					//plannedTransitTime
					Cell cell11 = tripNameRow.createCell((short) 11);	
					cell11.setCellValue(legBean.get(i).getStawrtatd());//ATD
					cell11.setCellStyle(summaryStyle);
					
					Cell cell12= tripNameRow.createCell((short) 12);	
					cell12.setCellValue(legBean.get(i).getETA());//ETA
					cell12.setCellStyle(dateStyleForTrips);
					
					Cell cell14= tripNameRow.createCell((short) 13);	
					cell14.setCellValue(ata);//ATA
					cell14.setCellStyle(dateStyleForTrips);
					
					//actualTransitTime
					Cell cell15 = tripNameRow.createCell((short) 14);	
					//cell15.setCellValue(legBean.get(i).getActualTransitTime());//ATD
					cell15.setCellValue((sActualT!=0)?formattedHoursMinutesSeconds(sActualT):"");
					cell15.setCellStyle(summaryStyle);
					
					Cell cell16 = tripNameRow.createCell((short) 15);	
					//cell16.setCellValue(legBean.get(i).getDelay());//Total Delay (HH:mm)
					cell16.setCellValue((sTransitDelay!=0)?formattedHoursMinutesSeconds(sTransitDelay):"");
					cell16.setCellStyle(summaryStyle);

					Cell cell17 = tripNameRow.createCell((short) 16);	
					cell17.setCellValue(legBean.get(i).getStatus());//Distance (Kms)
					cell17.setCellStyle(summaryStyle);
					
					Cell cell18 = tripNameRow.createCell((short) 17);	
					cell18.setCellValue(df2.format(sLegDistance));//Distance (Kms)
					cell18.setCellStyle(SintegerStyle);
					
					

				
			    }
			}

			workbook.write(fileOut);
			fileOut.flush();
			fileOut.close();
			
			//workbook.write(response.getOutputStream());
						
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return completePath;
	}
	public  String formattedHoursMinutesSeconds(long diff) {
		String hhmmssformat="";
		String format="";
		boolean negative=false;
		try {
			diff=(diff*60)*1000;
			if(diff==0){
				return hhmmssformat="";
			}
			long diffSeconds = diff / 1000 % 60;
			long diffMinutes = diff / (60 * 1000) % 60;
			long diffHours = diff / (60 * 60 * 1000);
			//hhmmssformat=diffHours+":"+diffMinutes+":"+diffSeconds;
			hhmmssformat=df1.format(diffHours)+":"+df1.format(diffMinutes)+":"+df1.format(diffSeconds);
			negative = hhmmssformat.contains("-")?true:false;
			format=negative?"-"+hhmmssformat.replaceAll("-", ""):hhmmssformat;
		} catch (Exception e) {
			System.out.println("hh:mm:ss exception :::::   "+e.getLocalizedMessage());
			e.printStackTrace();

		}
		return format;

	}
}
