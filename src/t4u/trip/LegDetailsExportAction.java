package t4u.trip;

import java.io.File;
import java.io.FileOutputStream;
import java.sql.Connection;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.Region;
import org.apache.poi.ss.usermodel.Font;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;

import t4u.GeneralVertical.LegDetailsBean;
import t4u.GeneralVertical.LegInfoBean;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.CommonFunctions;
import t4u.functions.GeneralVerticalFunctions;
public class LegDetailsExportAction extends Action {
	 private static final long serialVersionUID = 2067115822080269398L;
	 SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	 SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"); 
	 SimpleDateFormat yyyyMMdd = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	 SimpleDateFormat ddmmyyyy = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	 SimpleDateFormat ddmmyyyy1 = new SimpleDateFormat("dd/MM/yyyy");
	 DecimalFormat df = new DecimalFormat("00.00");
	 DecimalFormat df1=new DecimalFormat("#.##");
	 CommonFunctions cf = new CommonFunctions();
	 
	 GeneralVerticalFunctions gf=new GeneralVerticalFunctions();

	 public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		ArrayList<String> headersList = new ArrayList<String>();  

		HttpSession session = request.getSession();
		
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		String param=null;
		int systemId = loginInfo.getSystemId();
		int	clientId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset=loginInfo.getOffsetMinutes();
		String zone=loginInfo.getZone();
	
		String groupId =request.getParameter("groupId");
		String unit = request.getParameter("unit");
		//String custName = request.getParameter("custName");
		String custId = request.getParameter("custId");
		String routeId = request.getParameter("routeId");
		String status = request.getParameter("status");
		String path="";
		
	    
		if (request.getParameter("param") != null) {
            param = request.getParameter("param").toString();
        }
        if(param.equals("createLegExcel"))
        {
        	String startDateRange = request.getParameter("startDateRange");
			String endDateRange = request.getParameter("endDateRange");
			String custType = request.getParameter("custType");
			String tripType = request.getParameter("tripType");
    		try{
    			path=gf.getLegDetaisReport(systemId,clientId,offset,groupId,unit,userId,custId,routeId,status,startDateRange,endDateRange,custType,tripType,zone);
    			response.getWriter().print(path);
    		}catch (Exception e) {
    			e.printStackTrace();
    		}
		} else if (param.equals("createDriverPerformanceLegWiseExcel")) {
			JSONArray jArr = new JSONArray();
			try {
				String startDate = yyyyMMdd.format(ddmmyyyy1.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy.parse(request.getParameter("endDate")+" 23:59:59"));
				int driverId = Integer.parseInt(request.getParameter("driverId") == null || "".equals(request.getParameter("driverId"))
						|| "ALL".equalsIgnoreCase(request.getParameter("driverId")) ? "0" : request.getParameter("driverId"));
				String hubList = request.getParameter("hubList");

				String completePath = "";
				jArr = gf.getDriverCountDetails(systemId, clientId, offset, startDate, endDate, driverId, hubList, zone);
				
				completePath = gf.CreateDriverPerformanceExcelExport(jArr, startDate, endDate);
				response.getWriter().print(completePath);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("createLegReportForDriverScoreExcel")) {
			JSONArray jArr = new JSONArray();
			try {
				String startDate = yyyyMMdd.format(ddmmyyyy1.parse(request.getParameter("startDate")));
				String endDate = yyyyMMdd.format(ddmmyyyy1.parse(request.getParameter("endDate")+" 23:59:59"));
				int driverId = Integer.parseInt(request.getParameter("driverId") == null || "".equals(request.getParameter("driverId"))
						|| "ALL".equalsIgnoreCase(request.getParameter("driverId")) ? "0" : request.getParameter("driverId"));
				String hubList = request.getParameter("hubList");
				String completePath = "";
				jArr = gf.getLegReportForDriverScoreData(systemId, clientId,offset,startDate,endDate,driverId,hubList,zone);

				completePath = gf.CreateLegReportDriverScoreExcelExport(jArr, startDate, endDate);
				response.getWriter().print(completePath);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	return null;		
	}
	

 	
 	public  void CreateExcel(Connection con,ArrayList<LegDetailsBean> legBean,String completePath){
		try {
			System.out.println("#############Excel report start##############");
//			Date endDate = cal.getTime();
//			cal.add(Calendar.DATE, -1);
//			Date startDate = cal.getTime();
//			String name = "Leg Details Report";
//			String customername="DHL";
			Properties properties = ApplicationListener.prop;
			String rootPath =  properties.getProperty("legCreatePath");
			//String rootPath ="C:\\LegDetailsExcel";
//			String completePath = rootPath + "\\" + name + "_"+customername+"_"+ sdfDBMMDD.format(startDate) +"_"+sdfDBMMDD.format(endDate)+ ".xls";

			File f = new File(rootPath);
			if (!f.exists()) {
				f.mkdir();
			}
			
			FileOutputStream fileOut = new FileOutputStream(completePath);

			HSSFWorkbook workbook = new HSSFWorkbook();
			HSSFSheet worksheet = workbook.createSheet("Report");
			HSSFRow customerNameRow=null;
			
			HSSFFont font = null;
			font = workbook.createFont();
			font.setBoldweight(Font.BOLDWEIGHT_BOLD); 
			
			HSSFFont fontForNoLeg = null;
			fontForNoLeg = workbook.createFont();
			fontForNoLeg.setBoldweight(Font.BOLDWEIGHT_BOLD); 
			fontForNoLeg.setColor(HSSFFont.COLOR_RED);
			
			HSSFCellStyle styleForCustomer = workbook.createCellStyle();
			styleForCustomer.setFont(font);
			styleForCustomer.setAlignment(styleForCustomer.ALIGN_CENTER);
			styleForCustomer.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			
			HSSFCellStyle noLegStyle = workbook.createCellStyle();
			noLegStyle.setFont(fontForNoLeg);
			noLegStyle.setAlignment(styleForCustomer.ALIGN_CENTER);
			noLegStyle.setBorderBottom(HSSFCellStyle.BORDER_MEDIUM);
			
			HSSFCellStyle style1 = workbook.createCellStyle();
			style1.setFont(font);
			
			System.out.println("legBean.size() ::"+legBean.size());
			int rowNumber=2;
			
			HSSFRow row1 = worksheet.createRow((short) rowNumber);

			HSSFCell cellB1 = row1.createCell((short) 0);
			cellB1.setCellValue("Leg Name");
			cellB1.setCellStyle(style1);

			HSSFCell cellD1 = row1.createCell((short) 1);
			cellD1.setCellValue("Driver 1");
			cellD1.setCellStyle(style1);

			HSSFCell cellE1 = row1.createCell((short) 2);
			cellE1.setCellValue("Driver 2");
			cellE1.setCellStyle(style1);

			HSSFCell cellF1 = row1.createCell((short) 3);
			cellF1.setCellValue("STD");
			cellF1.setCellStyle(style1);

			HSSFCell cellG1 = row1.createCell((short) 4);
			cellG1.setCellValue("STA");
			cellG1.setCellStyle(style1);

			HSSFCell cellH1 = row1.createCell((short) 5);
			cellH1.setCellValue("ATD");
			cellH1.setCellStyle(style1);

			HSSFCell cellI1 = row1.createCell((short) 6);
			cellI1.setCellValue("ATA");
			cellI1.setCellStyle(style1);

			HSSFCell cellJ1 = row1.createCell((short) 7);
			cellJ1.setCellValue("Total Distance (km)");
			cellJ1.setCellStyle(style1);

			HSSFCell cellK1 = row1.createCell((short) 8);
			cellK1.setCellValue("Average Speed (kmph)");
			cellK1.setCellStyle(style1);
			
			HSSFCell cellL1 = row1.createCell((short) 9);
			cellL1.setCellValue("Fuel Consumed");
			cellL1.setCellStyle(style1);

			HSSFCell cellM1 = row1.createCell((short) 10);
			cellM1.setCellValue("Mileage");
			cellM1.setCellStyle(style1);
			
			HSSFCell cellN1 = row1.createCell((short) 11);
			cellN1.setCellValue("OBD Mileage");
			cellN1.setCellStyle(style1);
			
			HSSFCell cellO1 = row1.createCell((short) 12);
			cellO1.setCellValue("Travel Duration");
			cellO1.setCellStyle(style1);
			
			HSSFCell cellP1 = row1.createCell((short) 13);
			cellP1.setCellValue("ETA");
			cellP1.setCellStyle(style1);
			
			
			for(int i=0;i<legBean.size();i++)
			{
				rowNumber++;
				customerNameRow = worksheet.createRow((short)rowNumber);
				
				HSSFCell cellC1 = customerNameRow.createCell((short) 0);
				cellC1.setCellValue("");
				cellC1.setCellStyle(styleForCustomer);
				worksheet.addMergedRegion(new Region(rowNumber,(short)0,rowNumber,(short)13));
				
				rowNumber++;
			    if(legBean.get(i).getLegDetails().size()>0)
			    {
			    
					HSSFRow tripNameRow = worksheet.createRow((short)rowNumber);
					HSSFCell celltrip = tripNameRow.createCell((short) 0);
					celltrip.setCellValue(legBean.get(i).getShipmentId());
					celltrip.setCellStyle(styleForCustomer);
					
					worksheet.addMergedRegion(new Region(rowNumber,(short)0,rowNumber,(short)13));
			    	for (int ii = 0; ii < legBean.get(i).getLegDetails().size(); ii++) 
					{
						List<LegInfoBean> internalLegBean = legBean.get(i).getLegDetails();
						//String customerName = internalLegBean.getShipmentId();
						System.out.println(" legBean.get(i).getLegDetails().size();;"+ legBean.get(i).getLegDetails().size());
						
						rowNumber++;
						HSSFRow row2 = worksheet.createRow((short) rowNumber);

						cellB1 = row2.createCell((short) 0);
						cellB1.setCellValue(internalLegBean.get(ii).getLegName());
						//cellB1.setCellValue("leg1");

						cellD1 = row2.createCell((short) 1);
						cellD1.setCellValue(internalLegBean.get(ii).getDriver1());
						//cellD1.setCellValue("leg1");
						
						cellE1 = row2.createCell((short) 2);
						cellE1.setCellValue(internalLegBean.get(ii).getDriver2());
						//cellE1.setCellValue("leg1");
						
						cellF1 = row2.createCell((short) 3);
						cellF1.setCellValue(internalLegBean.get(ii).getLegSTD());
						//cellF1.setCellValue("leg1");

						cellG1 = row2.createCell((short) 4);
						cellG1.setCellValue(internalLegBean.get(ii).getLegSTA());
						//cellG1.setCellValue("leg1");

						cellH1 = row2.createCell((short) 5);
						cellH1.setCellValue(internalLegBean.get(ii).getLegATD());
						//cellH1.setCellValue("leg1");
					
						cellI1 = row2.createCell((short) 6);
					    cellI1.setCellValue(internalLegBean.get(ii).getLegATA());
						//cellI1.setCellValue("leg1");

						cellJ1 = row2.createCell((short) 7);
						cellJ1.setCellValue(internalLegBean.get(ii).getTotalDistance());
						//cellJ1.setCellValue("leg1");

						cellK1 = row2.createCell((short) 8);	
						cellK1.setCellValue(internalLegBean.get(ii).getAvgSpeed());
						//cellK1.setCellValue("leg1");
						
						cellL1 = row2.createCell((short) 9);	
						cellL1.setCellValue(internalLegBean.get(ii).getFuelConsumed());
						//cellL1.setCellValue("leg1");
						
						cellM1 = row2.createCell((short) 10);	
						cellM1.setCellValue(internalLegBean.get(ii).getMileage());
						//cellM1.setCellValue("leg1");
						
						cellN1 = row2.createCell((short) 11);	
						cellN1.setCellValue(internalLegBean.get(ii).getOBDMileage());
						//cellN1.setCellValue("leg1");
						
						cellO1 = row2.createCell((short) 12);	
						cellO1.setCellValue(internalLegBean.get(ii).getTravelDuration());
						//cellO1.setCellValue("leg1");
						
						cellP1 = row2.createCell((short) 13);	
						cellP1.setCellValue(internalLegBean.get(ii).getLegETA());
						//cellP1.setCellValue("leg1");
					}
			    	//rowNumber++;
			    }
//			    else
//			    {
//			    	HSSFRow legNorFound = worksheet.createRow((short)rowNumber);
//					HSSFCell celltrip = legNorFound.createCell((short) 0);
//					celltrip.setCellValue("Leg not found for "+legBean.get(i).getShipmentId());
//					celltrip.setCellStyle(noLegStyle);
//					worksheet.addMergedRegion(new Region(rowNumber,(short)0,rowNumber,(short)13));
//			    }
			}

			workbook.write(fileOut);
			fileOut.flush();
			fileOut.close();
			
			//workbook.write(response.getOutputStream());
						
			System.out.println("#############Excel report End##############");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
