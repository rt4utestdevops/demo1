package t4u.cashvanmanagement;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.StringTokenizer;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.CommonFunctions;
import t4u.functions.FuelMileageFunctions;

public class FuelMileageAction extends Action {
	@Override
	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		HttpSession session = request.getSession();

		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		int offset = loginInfo.getOffsetMinutes();
		String language = loginInfo.getLanguage();
		int userId = loginInfo.getUserId();

		FuelMileageFunctions fuelMileageFunction = new FuelMileageFunctions();
		CommonFunctions commFunctions = new CommonFunctions();

		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		/*******************************************************************************************************************************
		 * Getting Fuel Mileage Date based on Customer Name and Vehicle Number
		 ********************************************************************************************************************************/
		if (param.equalsIgnoreCase("getFuelMileageData")) {
			try {
				String assetGroupId = request.getParameter("assetGroupId");
				String assetGroupName = request.getParameter("assetGroupName");
				String startDate = request.getParameter("startdate");
				String endDate = request.getParameter("enddate");
				String clientIdFromJsp = request.getParameter("clientId");
				String jspName = request.getParameter("jspName");

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (clientIdFromJsp != null && !clientIdFromJsp.equals("")) {

					ArrayList<Object> fuelMileageList = fuelMileageFunction.getFuelMileageDetails(assetGroupId, startDate,endDate, systemId, Integer.parseInt(clientIdFromJsp), offset,language);
					jsonArray = (JSONArray) fuelMileageList.get(0);

					if (jsonArray.length() > 0) {
						jsonObject.put("FuelMileageRoot", jsonArray);
					} else {
						jsonObject.put("FuelMileageRoot", "");
					}
					ReportHelper reportHelper = (ReportHelper) fuelMileageList.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("assetGroupName",assetGroupName);
					request.getSession().setAttribute("startdate",commFunctions.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
					request.getSession().setAttribute("enddate",commFunctions.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("FuelMileageRoot", "");
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("getFuelMileageSummaryData")) {
			try {
				String assetGroupId = request.getParameter("assetGroupId");
				String assetGroupName = request.getParameter("assetGroupName");
				String startDate = request.getParameter("startdate");
				String endDate = request.getParameter("enddate");
				String clientIdFromJsp = request.getParameter("clientId");
				String jspNameSummary = request.getParameter("jspNameSummary");

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (clientIdFromJsp != null && !clientIdFromJsp.equals("")) {
					ArrayList<Object> fuelMileageSummaryList = fuelMileageFunction.getFuelMileageSummaryDetails(assetGroupId,startDate, endDate, systemId, Integer.parseInt(clientIdFromJsp), offset,language);
					jsonArray = (JSONArray) fuelMileageSummaryList.get(0);

					if (jsonArray.length() > 0) {
						jsonObject.put("FuelMileageSummaryRoot", jsonArray);
					} else {
						jsonObject.put("FuelMileageSummaryRoot", "");
					}

					ReportHelper reportHelper = (ReportHelper) fuelMileageSummaryList.get(1);
					request.getSession().setAttribute(jspNameSummary,reportHelper);
					request.getSession().setAttribute("assetGroupName",assetGroupName);
					request.getSession().setAttribute("startdate",commFunctions.getFormattedDateddMMYYYY(startDate.replaceAll("T", " ")));
					request.getSession().setAttribute("enddate",commFunctions.getFormattedDateddMMYYYY(endDate.replaceAll("T", " ")));
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("FuelMileageSummaryRoot", "");
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("validateFuelMileage")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String fueldata = request.getParameter("fueldata");
				String customerId = request
						.getParameter("validationCustomerId");
				if (fueldata != null) {
					String st = fueldata;
					JSONArray js = null;
					try {
						if (st.startsWith("[")) {
							js = new JSONArray(st.toString());
						} else {
							String fuel = "[" + st + "]";
							js = new JSONArray(fuel.toString());
						}

						if (customerId != null && !customerId.equals("")) {
							jsonArray = fuelMileageFunction.getValidationFuelMileageDetails(Integer.parseInt(customerId), systemId, js);

							if (jsonArray.length() > 0) {
								jsonObject.put("FuelMileageImportRoot",jsonArray);
							} else {
								jsonObject.put("FuelMileageImportRoot", "");
							}
							response.getWriter().print(jsonObject.toString());
						}
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("saveFuelMileageDetails")) {
			String message = "";
			String customerId = request.getParameter("customerIdSaveParam");
			String buttonValue = request.getParameter("buttonSaveParam");
			String saveFuelData = request.getParameter("fuelDataSaveParam");
			try {
				if (saveFuelData != null && !saveFuelData.equals("")
						&& customerId != null && !customerId.equals("")) {
					JSONArray fuelJs = null;
					try {
						fuelJs = new JSONArray(saveFuelData.toString());

						if (fuelJs.length() > 0 && buttonValue.equals("save")) {
							message = fuelMileageFunction.savefuelMileageDetails(Integer.parseInt(customerId), systemId,offset, userId, fuelJs);
						} else {
							message = "No Fuel Data To Save";
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					message = "No Fuel Data To Save";
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("importFuelMileageExcel")) {

			String importMessage = "";
			try {
				String message = "";
				String fileName = null;
				int clientIdInt = 0;
				String customerId = request.getParameter("importCustomerId");
				if (customerId != null) {
					clientIdInt = Integer.parseInt(customerId);
				}
				boolean isMultipart = ServletFileUpload.isMultipartContent(request);
				if (isMultipart) {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					String path = properties
							.getProperty("TempFileDownloadPath").trim()
							+ "/";
					while (iter.hasNext()) {
						FileItem item = (FileItem) iter.next();
						String fileExtension = "";
						if (!item.isFormField()) {
							File uploadedFile = null;
							File f = null;
							if (item.getName() != "") {
								fileName = item.getName();
								fileExtension = fileName.substring(
										fileName.lastIndexOf("."), fileName
												.length());

								String excelPath = path
										+ "FuelMileageImportData-" + systemId
										+ userId + fileExtension;
								uploadedFile = new File(excelPath);

								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							FuelMileageExcelImport dei = new FuelMileageExcelImport(
									uploadedFile, userId, systemId,
									clientIdInt, offset, fileExtension);
							importMessage = dei.importData();
							message = dei.getMessage();
							// message = importData(uploadedFile,
							// userId,systemId, clientIdInt, offset);
							File errorFile = new File(path
									+ "FuelMileageLogFile" + systemId + userId
									+ ".txt");
							writeMessageToTextFile(message, errorFile);
							deleteFile(uploadedFile);
						}
					}
				} else {
					System.out.println("Request Does Not Support Multipart");
				}
				if (importMessage.equals("Success")) {
					response.getWriter().print("{success:true}");
				} else {
					response.getWriter().print("{success:false}");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getImportFuelMileage")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String fuelImportResponse = request.getParameter("fuelImportResponse");
				if (fuelImportResponse.equals("{success:true}")) {
					jsonArray = FuelMileageExcelImport.globalJsonArray;
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("FuelMileageImportRoot", jsonArray);
				} else {
					jsonObject.put("FuelMileageImportRoot", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("openLogFile")) {
			try {

				Properties properties = ApplicationListener.prop;
				String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
				File errorFile = new File(path + "FuelMileageLogFile"+ systemId + userId + ".txt");
				String filename = "lastLog";
				response.setContentType("application/txt");
				response.setHeader("Content-disposition","attachment;filename=" + filename + ".txt");
				FileInputStream fis = new FileInputStream(errorFile);
				ServletOutputStream servletOutputStream = response.getOutputStream();
				DataOutputStream outputStream = new DataOutputStream(servletOutputStream);
				byte[] buffer = new byte[1024];
				int len = 0;
				while ((len = fis.read(buffer)) >= 0) {
					outputStream.write(buffer, 0, len);
				}
				outputStream.flush();
				outputStream.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if(param.equals("getPetroCardNumber")){
			try {
				jsonObject = new JSONObject();
				String vehicleNo = request.getParameter("VehicleNo");
				jsonArray = fuelMileageFunction.getPetroCardNumber(systemId, vehicleNo);
				
				if(jsonArray.length() > 0){
					jsonObject.put("PetroCardRoot", jsonArray);
				} else {
					jsonObject.put("PetroCardRoot", "");
				}
				
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if(param.equals("deleteFuelMileageDetails")){
			
			String message = "";
			
			try {
				jsonObject = new JSONObject();
				String deleteRegNo = request.getParameter("deleteRegNo");
				String deleteOdometer = request.getParameter("deleteOdometer");
				String customerId = request.getParameter("customerIdDeleteParam");
				
				if(customerId != null && customerId != ""){
					message = fuelMileageFunction.deleteFuelData(Integer.parseInt(customerId), systemId, userId, deleteRegNo, deleteOdometer, offset);
				}
				
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	public void deleteFile(File uploadedFile) {
		if (uploadedFile.exists()) {
			uploadedFile.delete();
		}
	}

	public void writeMessageToTextFile(String message, File errorFile) {
		try {
			PrintWriter pw = new PrintWriter(errorFile);
			StringTokenizer st = new StringTokenizer(message, "\n");
			while (st.hasMoreElements()) {
				String line = st.nextToken();
				pw.println(line);
				pw.println(".....................................................................................");
			}
			pw.flush();
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}