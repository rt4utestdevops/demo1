package t4u.GeneralVertical.aggrasivetat;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFCell;
import org.apache.poi.xssf.usermodel.XSSFRow;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import t4u.beans.AggressiveTATData;
import t4u.common.DBConnection;
import t4u.functions.CTDashboardFunctions;

public class DBUploadPinCodeOriginDestinationFromXls {

	private static final int EXCEL_UPLOAD_LIMIT = 100;

	public String importExcelData(File inFile, String fileExtension, int systemId, int clientId, int userId) {
		List<AggressiveTATData> dataSupervisorListAll = new ArrayList<AggressiveTATData>();
		try {
			if (fileExtension.equals(".xls")) {
				InputStream excelFileToRead = new FileInputStream(inFile);
				HSSFWorkbook wb = new HSSFWorkbook(excelFileToRead);
				HSSFSheet sheet = wb.getSheetAt(0);
				if (sheet.getPhysicalNumberOfRows() > EXCEL_UPLOAD_LIMIT) {
					return "Number of rows exceeds the supported upload limit" + EXCEL_UPLOAD_LIMIT;
				}
				dataSupervisorListAll = readDataFromXls(sheet);
			} else if (fileExtension.equals(".xlsx")) {
				InputStream excelFileToRead = new FileInputStream(inFile);
				XSSFWorkbook wb = new XSSFWorkbook(excelFileToRead);
				XSSFSheet sheet = wb.getSheetAt(0);
				if (sheet.getPhysicalNumberOfRows() > EXCEL_UPLOAD_LIMIT) {
					return "Number of rows exceeds the supported upload limit" + EXCEL_UPLOAD_LIMIT;
				}
				dataSupervisorListAll = readDataFromXlsx(sheet);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return saveExcelDataToDB(dataSupervisorListAll, systemId, clientId, userId);

	}

	private String saveExcelDataToDB(List<AggressiveTATData> supervisordataListAll, int systemId, int clientId,
			int userId) {
		String message = "No data to upload";
		CTDashboardFunctions ctAdminFunc = new CTDashboardFunctions();
		Connection con = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (AggressiveTATData supervisordataDetails : supervisordataListAll) {
				//ctAdminFunc.saveAggressiveTATDetails(systemId, clientId, supervisordataDetails, userId, con);
				message = "Uploaded Successfully";
			}
		} catch (Exception e) {
			message = "Error while uploading the excel..";
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, null, null);
		}
		return message;

	}

	private List<AggressiveTATData> readDataFromXlsx(XSSFSheet sheet) {
		List<AggressiveTATData> list = new ArrayList<AggressiveTATData>();
		AggressiveTATData agressiveTatData = null;
		try {
			XSSFRow row;
			XSSFCell cell;
			int nRows = sheet.getPhysicalNumberOfRows();
			for (int rowNo = 1; rowNo <= nRows; rowNo++) {

				row = sheet.getRow(rowNo);
				if (row != null) {
					agressiveTatData = new AggressiveTATData();
					for (int c = 0; c < 4; c++) {
						cell = row.getCell((short) c);
						switch (c) {
						case 0:
							agressiveTatData.setId(getXSSCellValue(cell));
							break;
						case 1:
							agressiveTatData.setSource(getXSSCellValue(cell));
							break;
						case 2:
							agressiveTatData.setDestination(getXSSCellValue(cell));
							break;
						case 3:
							agressiveTatData.setAggressiveTAT(getXSSCellValue(cell));
							break;
						}
					}
					list.add(agressiveTatData);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;

	}

	private String getXSSCellValue(XSSFCell cell) {
		String cellValue = "";
		if (cell != null) {

			if (cell.getCellType() == XSSFCell.CELL_TYPE_STRING)
				cellValue = cell.getStringCellValue();
			else if (cell.getCellType() == XSSFCell.CELL_TYPE_NUMERIC) {
				cell.setCellType(XSSFCell.CELL_TYPE_STRING);
				cellValue = cell.getStringCellValue();
			} else {
			}
		} else {
			cellValue = "";
		}
		return cellValue;
	}

	private String getXSSCellValue(HSSFCell cell) {
		String cellValue = "";
		if (cell != null) {
			if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING)
				cellValue = cell.getStringCellValue();
			else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
				cell.setCellType(HSSFCell.CELL_TYPE_STRING);
				cellValue = cell.getStringCellValue();
			} else {
			}
		} else {
			cellValue = "";
		}
		return cellValue;
	}

	@SuppressWarnings("deprecation")
	private List<AggressiveTATData> readDataFromXls(HSSFSheet sheet) {
		List<AggressiveTATData> list = new ArrayList<AggressiveTATData>();
		AggressiveTATData agressiveTatData = null;
		try {
			HSSFRow row;
			HSSFCell cell;
			int nRows = sheet.getPhysicalNumberOfRows();
			for (int rowNo = 1; rowNo <= nRows; rowNo++) {

				row = sheet.getRow(rowNo);
				if (row != null) {
					agressiveTatData = new AggressiveTATData();
					for (int c = 0; c < 4; c++) {
						cell = row.getCell((short) c);
						switch (c) {
						case 0:
							agressiveTatData.setId(getXSSCellValue(cell));
							break;
						case 1:
							agressiveTatData.setSource(getXSSCellValue(cell));
							break;
						case 2:
							agressiveTatData.setDestination(getXSSCellValue(cell));
							break;
						case 3:
							agressiveTatData.setAggressiveTAT(getXSSCellValue(cell));
							break;
						}
					}
					list.add(agressiveTatData);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;

	}

}
