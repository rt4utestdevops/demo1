package t4u.GeneralVertical;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.xssf.usermodel.XSSFSheet;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.GeneralVertical.aggrasivetat.PinCodeOriginDestinationModel;
import t4u.common.ApplicationListener;
import t4u.functions.CTDashboardFunctions;

public class UploadTemplateExcelToDB extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private boolean isMultipart;
	CTDashboardFunctions ctf = new CTDashboardFunctions();

	public UploadTemplateExcelToDB() {
		super();
	}

	@SuppressWarnings( { "deprecation", "unchecked" })
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		@SuppressWarnings("unused")
		Properties properties = null;
		properties = ApplicationListener.prop;
		JSONArray responseList = new JSONArray();
		Boolean noRecords = false;
		isMultipart = ServletFileUpload.isMultipartContent(request);
		response.setContentType("text/html");
		if (!isMultipart) {
			return;
		}
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// Create a new file upload handler
		ServletFileUpload up = new ServletFileUpload(factory);
		try {
			List<FileItem> fileItems = up.parseRequest(request);

			for (FileItem file : fileItems) {
				byte[] fileName = file.getName().getBytes();
				try {
					String uploadName = new String(fileName, "utf-8");

					File writeFile = new File(uploadName);

					file.write(writeFile);
					FileInputStream fileIS = new FileInputStream(writeFile);
					XSSFWorkbook workbook = new XSSFWorkbook(fileIS);
					XSSFSheet sheet = workbook.getSheetAt(0);
					Row row;
					List<PinCodeOriginDestinationModel> pinCodeOriginDestinationList = new ArrayList<PinCodeOriginDestinationModel>();
					PinCodeOriginDestinationModel pinCodeOriginDestinationModel = null;

					DataFormatter dataFormatter = new DataFormatter();

					for (int i = 3; i <= sheet.getLastRowNum(); i++) {
						row = (Row) sheet.getRow(i); // sheet number
						pinCodeOriginDestinationModel = new PinCodeOriginDestinationModel();

						Integer pinCode = (int) row.getCell(0).getNumericCellValue();
						if (dataFormatter.formatCellValue(row.getCell(0)) == "" || pinCode == 0) {
							pinCode = 0;
						}
						pinCodeOriginDestinationModel.setPinCode(pinCode);

						String name;
						if (dataFormatter.formatCellValue(row.getCell(1)) == "" || dataFormatter.formatCellValue(row.getCell(1)) == null) {
							name = "";
						} else {
							name = dataFormatter.formatCellValue(row.getCell(1));
						}
						if (pinCode  > 0 && name.length() > 0){
							pinCodeOriginDestinationModel.setName(name.toUpperCase());
							pinCodeOriginDestinationList.add(pinCodeOriginDestinationModel);
						} 

					}
					if (pinCodeOriginDestinationList.size() == 0) {
						responseList = new JSONArray();
						noRecords =  true;
						
					} else {
						responseList = ctf.uploadPinCodeOriginDestinationFromList(pinCodeOriginDestinationList);

					}
				} catch (Exception e) {
					e.printStackTrace();
				}

			}
			JSONObject finalObject = new JSONObject();
			finalObject.put("newCityRoot", responseList.length() > 0 ? responseList.get(0):"");
			finalObject.put("errorList", responseList.length() > 0  ? responseList.get(1) : "");
			finalObject.put("noRecords", noRecords);
			response.getWriter().print(finalObject.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
