package t4u.util;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONException;
import org.json.JSONObject;

public class GenerateExcelUtil {

	public static void generateExcelForHubDetails(List<JSONObject> list, String path, String name) throws SQLException,
			JSONException, FileNotFoundException, IOException {
		XSSFWorkbook wb = new XSSFWorkbook();
		XSSFSheet sheet = wb.createSheet("Hub Details");

		CellStyle unlockedCellStyle = wb.createCellStyle();
		unlockedCellStyle.setLocked(true);
		getHeadersForHubDetails(sheet);
		for (int c = 0; c < list.size(); c++) {
			XSSFRow row = sheet.createRow(c + 1);
			row.createCell(0).setCellStyle(unlockedCellStyle);
			row.createCell(0).setCellValue(String.valueOf(list.get(c).get("hubId")));
			row.createCell(1).setCellStyle(unlockedCellStyle);
			row.createCell(1).setCellValue(String.valueOf(list.get(c).get("hubName")));
		}
		String fileName = path + "" + name + ".xlsx";
		FileOutputStream fileOut = new FileOutputStream(fileName);
		wb.write(fileOut);
		fileOut.close();
		System.out.println("Created Excel for :: " + path);
	}

	public static void getHeadersForHubDetails(XSSFSheet sheet) {
		XSSFRow rowhead = sheet.createRow(0);
		rowhead.createCell(0).setCellValue("Hub Id");
		rowhead.createCell(1).setCellValue("SuperVisor Name");
		rowhead.createCell(2).setCellValue("Hub Name");
		rowhead.createCell(3).setCellValue("Hub Code");
		rowhead.createCell(4).setCellValue("Shift Start Timing ( e.g. 09:00 )");
		rowhead.createCell(5).setCellValue("Shift End Time (e.g. 15:30 )");
		rowhead.createCell(6).setCellValue("Contact Number");
	}
	
	public static void getHeadersForHubDetails(HSSFSheet sheet) {
		HSSFRow rowhead = sheet.createRow(0);
		rowhead.createCell(0).setCellValue("Hub Id");
		rowhead.createCell(1).setCellValue("SuperVisor Name");
		rowhead.createCell(2).setCellValue("Hub Name");
		rowhead.createCell(3).setCellValue("Hub Code");
		rowhead.createCell(4).setCellValue("Shift Start Timing ( e.g. 09:00 )");
		rowhead.createCell(5).setCellValue("Shift End Time (e.g. 15:30 )");
		rowhead.createCell(6).setCellValue("Contact Number");
	}

	//****************************************************************************************//

	public static void generateExcelForDelay(List<JSONObject> list, String path, String name)
			throws SQLException, JSONException, FileNotFoundException, IOException {
		XSSFWorkbook wb = new XSSFWorkbook();
		XSSFSheet sheet = wb.createSheet("Aggressive TAT");

		CellStyle unlockedCellStyle = wb.createCellStyle();
		unlockedCellStyle.setLocked(true);
		getHeadersForDelay(sheet);
		for (int c = 0; c < list.size(); c++) {
			XSSFRow row = sheet.createRow(c + 1);
			row.createCell(0).setCellValue(String.valueOf(list.get(c).get("DELAY ATTRIBUTION")));
			row.createCell(1).setCellValue(String.valueOf(list.get(c).get("DELAY CODE")));
			row.createCell(3).setCellValue(String.valueOf(list.get(c).get("DELAY TYPE")));
		}
		String fileName = path + "" + name + ".xlsx";
		FileOutputStream fileOut = new FileOutputStream(fileName);
		wb.write(fileOut);
		fileOut.close();
		System.out.println("Created Excel for :: " + path);
	}

	public static void getHeadersForDelay(XSSFSheet sheet) {
		XSSFRow rowhead = sheet.createRow(0);
		rowhead.createCell(0).setCellValue("LegId");
		rowhead.createCell(1).setCellValue("Source");
		rowhead.createCell(2).setCellValue("Destination");
		rowhead.createCell(3).setCellValue("Aggressive TAT in (HH:MM)");
	}
	
	public static void getHeadersForDelay(HSSFSheet sheet) {
		HSSFRow rowhead = sheet.createRow(0);
		rowhead.createCell(0).setCellValue("LegId");
		rowhead.createCell(1).setCellValue("Source");
		rowhead.createCell(2).setCellValue("Destination");
		rowhead.createCell(3).setCellValue("Aggressive TAT in (HH:MM)");
	}
	
	//****************************************************************************************//

	public static void generateExcelForAggressiveTAT(List<JSONObject> list, String path, String name)
			throws SQLException, JSONException, FileNotFoundException, IOException {
		XSSFWorkbook wb = new XSSFWorkbook();
		XSSFSheet sheet = wb.createSheet("Hub Details");

		CellStyle unlockedCellStyle = wb.createCellStyle();
		unlockedCellStyle.setLocked(true);
		getHeadersForAggressiveTAT(sheet);
		for (int c = 0; c < list.size(); c++) {
			XSSFRow row = sheet.createRow(c + 1);
			row.createCell(0).setCellStyle(unlockedCellStyle);
			row.createCell(0).setCellValue(String.valueOf(list.get(c).get("source")));
			row.createCell(1).setCellStyle(unlockedCellStyle);
			row.createCell(1).setCellValue(String.valueOf(list.get(c).get("destination")));
			row.createCell(2).setCellStyle(unlockedCellStyle);
			row.createCell(3).setCellValue(String.valueOf(list.get(c).get("aggressiveTAT")));
		}
		String fileName = path + "" + name + ".xlsx";
		FileOutputStream fileOut = new FileOutputStream(fileName);
		wb.write(fileOut);
		fileOut.close();
		System.out.println("Created Excel for :: " + path);
	}

	public static void getHeadersForAggressiveTAT(XSSFSheet sheet) {
		XSSFRow rowhead = sheet.createRow(0);
		rowhead.createCell(0).setCellValue("LegId");
		rowhead.createCell(1).setCellValue("Source");
		rowhead.createCell(2).setCellValue("Destination");
		rowhead.createCell(3).setCellValue("Aggressive TAT in (HH:MM)");
	}

	public static void getHeadersForAggressiveTAT(HSSFSheet sheet) {
		HSSFRow rowhead = sheet.createRow(0);
		rowhead.createCell(0).setCellValue("LegId");
		rowhead.createCell(1).setCellValue("Source");
		rowhead.createCell(2).setCellValue("Destination");
		rowhead.createCell(3).setCellValue("Aggressive TAT in (HH:MM)");
	}
}
