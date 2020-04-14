package t4u.GeneralVertical;

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

import t4u.common.DBConnection;
import t4u.functions.CTDashboardFunctions;

public class HubshiftsupervisorExcelImport {
	private static final int EXCEL_UPLOAD_LIMIT = 100;

	public String importExcelData(File inFile, String fileExtension, int systemId, int clientId, int userId) {
		List<HubshiftsupervisorData> dataSupervisorListAll = new ArrayList<HubshiftsupervisorData>();
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

	private String saveExcelDataToDB(List<HubshiftsupervisorData> supervisordataListAll, int systemId, int clientId,
			int userId) {
		String message = "No data to upload";
		CTDashboardFunctions ctAdminFunc = new CTDashboardFunctions();
		Connection con = null;
		try {
			con = DBConnection.getConnectionToDB("AMS");
			for (HubshiftsupervisorData supervisordataDetails : supervisordataListAll) {
				ctAdminFunc.saveUploadedHubDetails(systemId, clientId, supervisordataDetails, userId, con);
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

	private List<HubshiftsupervisorData> readDataFromXlsx(XSSFSheet sheet) {
		List<HubshiftsupervisorData> list = new ArrayList<HubshiftsupervisorData>();
		HubshiftsupervisorData supervisorData = null;
		try {
			XSSFRow row;
			XSSFCell cell;
			int nRows = sheet.getPhysicalNumberOfRows();
			for (int rowNo = 1; rowNo <= nRows; rowNo++) {
				row = sheet.getRow(rowNo);
				if (row != null) {
					supervisorData = new HubshiftsupervisorData();
					for (int c = 0; c < 4; c++) {
						cell = row.getCell((short) c);
						switch (c) {
						case 0:
							supervisorData.setHubId(getXSSCellValue(cell));
							break;
						case 1:
							supervisorData.setSupervisorName(getXSSCellValue(cell));
							break;
						case 2:
							supervisorData.setHubName(getXSSCellValue(cell));
							break;
						case 3:
							supervisorData.setHubCode(getXSSCellValue(cell));
							break;
						case 4:
							supervisorData.setShiftStartTiming(getXSSCellValue(cell));
							break;
						case 5:
							supervisorData.setShiftEndTiming(getXSSCellValue(cell));
							break;
						case 6:
							supervisorData.setContactNumber(getXSSCellValue(cell));
							break;
						}
						list.add(supervisorData);
					}
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
	private List<HubshiftsupervisorData> readDataFromXls(HSSFSheet sheet) {
		List<HubshiftsupervisorData> list = new ArrayList<HubshiftsupervisorData>();
		HubshiftsupervisorData supervisorData = null;
		try {
			HSSFRow row;
			HSSFCell cell;
			int nRows = sheet.getPhysicalNumberOfRows();
			for (int rowNo = 1; rowNo <= nRows; rowNo++) {

				row = sheet.getRow(rowNo);
				if (row != null) {
					supervisorData = new HubshiftsupervisorData();
					for (int c = 0; c < 4; c++) {
						cell = row.getCell((short) c);
						switch (c) {
						case 0:
							supervisorData.setHubId(getXSSCellValue(cell));
							break;
						case 1:
							supervisorData.setSupervisorName(getXSSCellValue(cell));
							break;
						case 2:
							supervisorData.setHubName(getXSSCellValue(cell));
							break;
						case 3:
							supervisorData.setHubCode(getXSSCellValue(cell));
							break;
						case 4:
							supervisorData.setShiftStartTiming(getXSSCellValue(cell));
							break;
						case 5:
							supervisorData.setShiftEndTiming(getXSSCellValue(cell));
							break;
						case 6:
							supervisorData.setContactNumber(getXSSCellValue(cell));
							break;
						}
					}
					list.add(supervisorData);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;

	}
}
