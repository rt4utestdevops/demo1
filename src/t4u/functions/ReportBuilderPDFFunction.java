package t4u.functions;

import java.awt.Color;
import java.io.File;
import java.io.FileOutputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

import org.apache.commons.lang.SystemUtils;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.common.ApplicationListener;

import com.google.gson.internal.LinkedTreeMap;
import com.lowagie.text.Document;
import com.lowagie.text.PageSize;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import com.lowagie.text.Font;

@SuppressWarnings("deprecation")
public class ReportBuilderPDFFunction {
	
	CommonFunctions cf = new CommonFunctions();
	public static Object lock = new Object();
	AdminFunctions adFunc = new AdminFunctions();
	SimpleDateFormat ddmmyyyyhhmmss = new SimpleDateFormat("ddMMyyyyHHmmss");

	BaseFont baseFont = null;

//	public String DownloadPDF(int systemId, int clientId, int userId,
//			String tableData, String reportName, String startDate,
//			String endDate, String reportInfo) throws Exception {
		public String DownloadPDF(int systemId, int clientId, int userId,
				JSONArray tableData, String reportName, String startDate,
				String endDate, String reportInfo,String vehicleNo ) throws Exception {		
		String message = null;
		Properties properties = ApplicationListener.prop;

		//JSONObject obj = new JSONObject(tableData.toString());
		JSONArray jsonArray = tableData;//(JSONArray) obj.get("tableReponsejson");

	/*	String excelpath = properties.getProperty("ReportBuilderPath");
		refreshdir(excelpath);   */
		Date date = new Date();
		String formno = ddmmyyyyhhmmss.format(date);
		String fontPath = properties.getProperty("FontPathForMaplePDF");
		baseFont = BaseFont.createFont(fontPath, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
		String bill = "";
		if(SystemUtils.IS_OS_LINUX || SystemUtils.IS_OS_UNIX){
			bill = "/opt/cluster/platform/filePath/Reports/CrystalReports/" + "ReportBuilder" +formno + ".pdf";
		}else{
			bill = "c://Reports/CrystalReports/" + "ReportBuilder" +formno + ".pdf";
		}
		//String bill = excelpath + formno + ".pdf";
		FileOutputStream fileOut = new FileOutputStream(bill);
		// Document document = new Document(PageSize.A4, 50, 50, 50, 50);
		Document document = new Document(PageSize.A4.rotate());
		PdfWriter writer = PdfWriter.getInstance(document, fileOut);
		
		
		String[] vehArr = vehicleNo.split(",");
		
		document.open();
		generateBill(document, jsonArray, systemId, startDate, endDate, reportName + (vehicleNo.split(",").length == 1 ? ("--" + vehicleNo) : ""));
		document.close();
		message = bill;
		return message;
	}

/*	private void refreshdir(String reportpath) {
		try {
			File f = new File(reportpath);
			if (!f.exists()) {
				f.mkdir();
			}
		} catch (Exception e) {
			System.out.println("Error creating folder for GST Report: " + e);
			e.printStackTrace();
		}
	}
*/
	private void generateBill(Document document, JSONArray tableData,
			int systemId, String startDate, String endDate, String reportName) {
		try {

			CommonFunctions cf = new CommonFunctions();

			PdfPTable dateDetailsTable = createDateDetails(startDate, endDate, reportName);
			document.add(dateDetailsTable);
			PdfPTable data = createTableForGrid(tableData);
			document.add(data);

		} catch (Exception e) {
			System.out.println("Error generating report : " + e);
			e.printStackTrace();
		}
	}

	private PdfPTable createDateDetails(String startDate,String endDate, String reportName) {
		int font = 10;
		PdfPTable table1 = new PdfPTable(2);
		float[] regDatewidths = {65,35};
		try {
			table1.setWidthPercentage(100.0f);
			table1.setWidths(regDatewidths);

			Phrase datePhras=new Phrase("Report Name: " + reportName,new Font(baseFont, font, Font.BOLD));
			PdfPCell datecel = new PdfPCell(datePhras);
			datecel.setBorder(Rectangle.NO_BORDER);
			table1.addCell(datecel);
			
			datePhras = new Phrase("Start Date: " + startDate + " " + "End Date: " + endDate, new Font(baseFont, font,Font.BOLD));
			datecel = new PdfPCell(datePhras);
			datecel.setBorder(Rectangle.NO_BORDER);
			table1.addCell(datecel);
			

		} catch (Exception e) {
			e.printStackTrace();
		}
		return table1;
	}

	private PdfPTable createTableForGrid(JSONArray gridData)
			throws JSONException {

		PdfPTable t = null;
		try {
			int counter = 0;

			Phrase myPhrase = new Phrase("Sl No", new Font(baseFont, 10,Font.BOLD));
			ArrayList<String> columnArray = null;
			ArrayList<String> dataTypeArray = null;
			
			JSONObject columnObj = new JSONObject(gridData.get(0).toString());

			dataTypeArray = new ArrayList<String>();
			for (int i = 0; i < columnObj.length(); i++) {
				JSONArray colArray = (JSONArray) columnObj.get(String.valueOf(i));
				counter++;
			}
			counter = counter + 1;
			float[] widths = new float[counter];
			JSONObject obj = gridData.getJSONObject(0);
			t = new PdfPTable(counter);

			for (int z = 0; z < counter; z++) {
				widths[z] = 1;
			}

			t.setWidthPercentage(100);
			t.setWidths(widths);

			JSONObject columnObj1 = null;

			int rowCounter = 0;

			for (int x = 0; x < gridData.length(); x++) {
				PdfPCell c1 = null;
				if (x == 0) {
					myPhrase = new Phrase("Sl.No", new Font(baseFont, 7,Font.BOLD, Color.WHITE));
					c1 = new PdfPCell(myPhrase);
					c1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					c1.setBackgroundColor(Color.GRAY);
					t.addCell(c1);
					for (int i = 0; i < columnObj.length(); i++) {
						JSONArray colArray = (JSONArray) columnObj.get(String.valueOf(i));
						for (int j = 0; j < colArray.length(); j++) {
							JSONObject headerobj = new JSONObject(colArray.get(j).toString());
							//System.out.println("headerobj :: " + headerobj);
							myPhrase = new Phrase((String) headerobj.get("title"), new Font(baseFont, 7,Font.BOLD, Color.WHITE));
							c1 = new PdfPCell(myPhrase);
							c1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
							c1.setBackgroundColor(Color.GRAY);
							t.addCell(c1);
						}
					}
				} else {
					columnObj1 = new JSONObject(gridData.get(x).toString());
					myPhrase = new Phrase(String.valueOf(++rowCounter),
							new Font(baseFont, 7, Font.NORMAL));
					c1 = new PdfPCell(myPhrase);
					c1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
					c1.setBackgroundColor(Color.WHITE);
					t.addCell(c1);
					for (int y = 0; y < columnObj1.length(); y++) {
						myPhrase = new Phrase(columnObj1.getString(String.valueOf(y)),new Font(baseFont, 7, Font.NORMAL));
						c1 = new PdfPCell(myPhrase);
						c1.setHorizontalAlignment(Rectangle.ALIGN_LEFT);
						c1.setBackgroundColor(Color.WHITE);
						t.addCell(c1);
					}
				}
			}

		} catch (Exception e) {
			System.out.println("Error creating PDF form for Mining  : " + e);
			e.printStackTrace();
		}
		return t;
	}

}
