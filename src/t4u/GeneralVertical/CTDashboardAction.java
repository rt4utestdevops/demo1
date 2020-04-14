package t4u.GeneralVertical;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

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
import org.json.JSONObject;

import t4u.GeneralVertical.AggressiveTATExcelImport;
import t4u.beans.LoginInfoBean;
import t4u.common.ApplicationListener;
import t4u.functions.CTDashboardFunctions;
import t4u.functions.CommonFunctions;
import t4u.util.GenerateExcelUtil;

public class CTDashboardAction extends Action {
	static Properties properties = ApplicationListener.prop;

	@SuppressWarnings("deprecation")
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession();
		String param = "";
		int systemId = 0;
		int userId = 0;
		int clientId = 0;
		int nonCommHrs = 0;
		String sessionId = request.getSession().getId();
		String serverName = request.getServerName();
		Properties properties = ApplicationListener.prop;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		systemId = loginInfo.getSystemId();
		clientId = loginInfo.getCustomerId();
		userId = loginInfo.getUserId();
		CommonFunctions cf=new CommonFunctions();
		nonCommHrs = loginInfo.getNonCommHrs();
		int offset = loginInfo.getOffsetMinutes();
		String userName = loginInfo.getUserName();
		JSONArray jsonArray = null;
		CTDashboardFunctions ctf = new CTDashboardFunctions();
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getCTAdminDashboardCounts")) {
			jsonArray = new JSONArray();
			jsonObject = new JSONObject();
			try {
				jsonObject = new JSONObject();
				jsonArray = ctf.getCTAdminDashboardCounts(clientId, systemId, userId, nonCommHrs);
				if (jsonArray.length() > 0) {
					jsonObject.put("dashboardCounts", jsonArray);
				} else {
					jsonObject.put("dashboardCounts", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		} else if (param.equals("getVehicleType")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getVehicleType(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleTypeRoot", jsonArray);
				} else {
					jsonObject.put("vehicleTypeRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getCustNames")) {
			try {

				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getCustNames(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("customerRoot", jsonArray);
				} else {
					jsonObject.put("customerRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getUsers")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getUsers(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("userRoot", jsonArray);
				} else {
					jsonObject.put("userRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("associateVehiclesToUsers")) {
			try {
				String vehicleList = request.getParameter("vehicleList");
				String user = request.getParameter("userId");
				String message = ctf.associateVehiclesToUsers(systemId, clientId, vehicleList, user);
				response.getWriter().print(message.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getAssciationDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String userList = request.getParameter("userId");
				String criteriaId = request.getParameter("criteriaId");
				jsonArray = ctf.getAssociationData(systemId, clientId, userList, criteriaId);
				if (jsonArray.length() > 0) {
					jsonObject.put("associationRoot", jsonArray);
				} else {
					jsonObject.put("associationRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getUnassignedVehicles")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getUnassignedVehicles(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("unassignedVehicleRoot", jsonArray);
				} else {
					jsonObject.put("unassignedVehicleRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "CT Admin Dashboard", "View", userId, serverName, systemId, clientId,
				"Visited This Page/Dashboard");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getAvailableVehicles")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String type = request.getParameter("type");
				jsonArray = ctf.getAvailableVehicles(systemId, clientId, offset, type);
				if (jsonArray.length() > 0) {
					jsonObject.put("availableVehiclesRoot", jsonArray);
				} else {
					jsonObject.put("availableVehiclesRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getNonCommunicationVehicles")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String type = request.getParameter("type");
				jsonArray = ctf.getNonCommunicationVehicles(systemId, clientId, offset, type);
				if (jsonArray.length() > 0) {
					jsonObject.put("nonCommVehiclesRoot", jsonArray);
				} else {
					jsonObject.put("nonCommVehiclesRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getUnloadingVehicles")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String type = request.getParameter("type");
				jsonArray = ctf.getUnloadingVehicles(systemId, clientId, offset, type);
				if (jsonArray.length() > 0) {
					jsonObject.put("unloadingVehiclesRoot", jsonArray);
				} else {
					jsonObject.put("unloadingVehiclesRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getSourceAndDestination")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getSourceAndDestination(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("sourceAndDestRoot", jsonArray);
				} else {
					jsonObject.put("sourceAndDestRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getTATDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getTATDetails(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("tatRoot", jsonArray);
				} else {
					jsonObject.put("tatRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("saveAggressiveTatDetails")) {
			try {
				String source = request.getParameter("source");
				String destination = request.getParameter("destination");
				String TAT = request.getParameter("TAT");
				String message = ctf.saveAggressiveTatDetails(systemId, clientId, source, destination, TAT);
				response.getWriter().print(message.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("updateAggressiveTatDetails")) {
			try {
				String source = request.getParameter("source");
				String destination = request.getParameter("destination");
				String TAT = request.getParameter("TAT");
				String message = ctf.updateAggressiveTatDetails(systemId, clientId, source, destination, TAT);
				response.getWriter().print(message.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("saveDelayDetails")) {
			try {
				String issueType = request.getParameter("issueType");
				String delayCode = request.getParameter("delayCode");
				String subIssue = request.getParameter("subIssue");
				String message = ctf.saveDelayDetails(systemId, clientId, issueType, delayCode, subIssue);
				response.getWriter().print(message.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getUserWiseVehicleCount")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getUserWiseVehicleCount(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleCount", jsonArray);
				} else {
					jsonObject.put("vehicleCount", "");
				}
				response.getWriter().print(jsonObject.toString());
				
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getAllAssociatedVehicles")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getAllAssociatedVehicles(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("associatedVehicles", jsonArray);
				} else {
					jsonObject.put("associatedVehicles", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getDelayDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getDelayDetails(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("delayDetailsRoot", jsonArray);
				} else {
					jsonObject.put("delayDetailsRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("openStandardFileFormat")) {
			String activeTab = request.getParameter("tabID");
			try {

				File stdFile = null;
				String filename = null;
				String path = properties.getProperty("TempFileDownloadPath").trim() + "/";
				List<JSONObject> list = new ArrayList<JSONObject>();
				if (activeTab.equalsIgnoreCase("HubTab")) {
					filename = "StandardHubImportDetailsFormat";
					//list = ctf.getHubDetails(systemId, clientId);
					GenerateExcelUtil.generateExcelForHubDetails(list, path, filename);
					stdFile = new File(path + "StandardHubImportDetailsFormat.xlsx");
				} else if (activeTab.equalsIgnoreCase("aggressiveTab")) {
					filename = "StandardAggressiveTATFormat";
					//list = ctf.getAggressiveTATdata(systemId, clientId);
					GenerateExcelUtil.generateExcelForAggressiveTAT(list, path, filename);
					stdFile = new File(path + "StandardAggressiveTATFormat.xlsx");
				} else if (activeTab.equalsIgnoreCase("delayTab")) {
					filename = "StandardDelayDetailsFormat";
					stdFile = new File(path + "StandardDelayDetailsFormat.xlsx");
				}
				response.setContentType("application/xlsx");
				response.setHeader("Content-disposition", "attachment;filename=" + filename + ".xlsx");
				FileInputStream fis = new FileInputStream(stdFile);
				ServletOutputStream servletOutputStream = response.getOutputStream();
				DataOutputStream outputStream = new DataOutputStream(servletOutputStream);
				int len = 0;
				while ((len = fis.read()) != -1) {
					outputStream.write(len);
				}
				outputStream.close();

			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("importSmartHubDetailsExcel")) {
			String fileName = null;
			String fileExtension = "";
			String message = "";
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
			if (isMultipart) {
				try {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List<?> items = upload.parseRequest(request);
					Iterator<?> iter = items.iterator();
					String path = properties.getProperty("TempFileDownloadPath").trim() + "/";
					while (iter.hasNext()) {
						FileItem item = (FileItem) iter.next();
						if (!item.isFormField()) {
							File uploadedFile = null;
							File f = null;
							if (item.getName() != "") {
								fileName = item.getName();
								fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());
								String excelPath = path + "HubShiftsupervisorDetails-" + systemId + clientId + fileExtension;
								uploadedFile = new File(excelPath);
								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							HubshiftsupervisorExcelImport hubSupervisor = new HubshiftsupervisorExcelImport();
							message = hubSupervisor.importExcelData(uploadedFile, fileExtension, systemId, clientId, userId);
						} else {
							System.out.println("error");
						}
						response.getWriter().print(message);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		} else if (param.equalsIgnoreCase("importAggressiveTATDetailsExcel")) {
			String fileName = null;
			String fileExtension = "";
			String message = "";
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
			if (isMultipart) {
				try {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List<?> items = upload.parseRequest(request);
					Iterator<?> iter = items.iterator();
					String path = properties.getProperty("TempFileDownloadPath").trim() + "/";
					while (iter.hasNext()) {
						FileItem item = (FileItem) iter.next();
						if (!item.isFormField()) {
							File uploadedFile = null;
							File f = null;
							if (item.getName() != "") {
								fileName = item.getName();
								fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());
								String excelPath = path + "StandardAggressiveTATFormat-" + systemId + clientId + fileExtension;
								uploadedFile = new File(excelPath);
								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							AggressiveTATExcelImport aggressiveTat = new AggressiveTATExcelImport();
							message = aggressiveTat.importExcelData(uploadedFile, fileExtension, systemId, clientId, userId);
						} else {
							System.out.println("error");
						}
						response.getWriter().print(message);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else if (param.equalsIgnoreCase("getCTUserDashboardVehicleCounts")) {
			JSONArray jArr = new JSONArray();
			JSONObject obj = new JSONObject();
			int userIdFromJsp = 0;
			try {
				if (request.getParameter("user") != null && Integer.parseInt(request.getParameter("user")) == 9999) {
					userIdFromJsp = userId;
				} else {
					userIdFromJsp = Integer.parseInt(request.getParameter("user"));
				}
				jArr = ctf.getCTUserDashboardVehicleCount(systemId, clientId, userIdFromJsp, nonCommHrs);
				if (jArr.length() > 0) {
					obj.put("dashboardTripVehicleRoot", jArr.get(0));
				} else {
					obj.put("dashboardTripVehicleRoot", "");
				}
				response.getWriter().print(obj.toString());
				
				cf.insertDataIntoAuditLogReport(sessionId, null, "CT Executive Dashboard", "View", userId, serverName, systemId, clientId,
				"Visited This Page/Dashboard");
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getCTUserDashboardTripCounts")) {
			JSONArray jArr = new JSONArray();
			JSONObject obj = new JSONObject();
			int userIdFromJsp = 0;
			try {
				if (request.getParameter("user") != null && Integer.parseInt(request.getParameter("user")) == 9999) {
					userIdFromJsp = userId;
				} else {
					userIdFromJsp = Integer.parseInt(request.getParameter("user"));
				}
				jArr = ctf.getCTUserDashboardTripCount(systemId, clientId, userIdFromJsp);
				if (jArr.length() > 0) {
					obj.put("dashboardTripCountRoot", jArr.get(0));
				} else {
					obj.put("dashboardTripCountRoot", "");
				}
				response.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getCTUserDashboardAlertCounts")) {
			JSONArray jArr = new JSONArray();
			JSONObject obj = new JSONObject();
			int userIdFromJsp = 0;
			try {
				if (request.getParameter("user") != null && Integer.parseInt(request.getParameter("user")) == 9999) {
					userIdFromJsp = userId;
				} else {
					userIdFromJsp = Integer.parseInt(request.getParameter("user"));
				}
				jArr = ctf.getCTUserDashboardAlertCount(systemId, clientId, userIdFromJsp);
				if (jArr.length() > 0) {
					obj.put("dashboardAlertCountRoot", jArr.get(0));
				} else {
					obj.put("dashboardAlertCountRoot", "");
				}
				response.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}  else if (param.equalsIgnoreCase("getCTUserDashboardSnoozeCounts")) {
			JSONArray jArr = new JSONArray();
			JSONObject obj = new JSONObject();
			int userIdFromJsp = 0;
			try {
				if (request.getParameter("user") != null && Integer.parseInt(request.getParameter("user")) == 9999) {
					userIdFromJsp = userId;
				} else {
					userIdFromJsp = Integer.parseInt(request.getParameter("user"));
				}
				jArr = ctf.getSnoozeCounts(systemId, clientId, userIdFromJsp);
				if (jArr.length() > 0) {
					obj.put("dashboardSnoozeCountRoot", jArr.get(0));
				} else {
					obj.put("dashboardSnoozeCountRoot", "");
				}
				response.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getCTUserDashboardListDetails")) {
			JSONArray jArr = new JSONArray();
			JSONObject obj = new JSONObject();
			String type = request.getParameter("type");
			int userIdFromJsp = 0;
			try {
				if (request.getParameter("user") != null && Integer.parseInt(request.getParameter("user")) == 9999) {
					userIdFromJsp = userId;
				} else {
					userIdFromJsp = Integer.parseInt(request.getParameter("user"));
				}
				jArr = ctf.getCTUserDashboardListDetails(systemId, clientId, userIdFromJsp, offset, nonCommHrs, type);
				if (jArr.length() > 0) {
					obj.put("getCTUserDashboardListDetailsRoot", jArr);
				} else {
					obj.put("getCTUserDashboardListDetailsRoot", "");
				}
				response.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getAllTouchPointNames")) {
			JSONArray jArr = new JSONArray();
			JSONObject obj = new JSONObject();
			String tripId = request.getParameter("tripNo");
			try {
				jArr = ctf.getAllTouchPointsofTrip(tripId);
				if (jArr.length() > 0) {
					obj.put("getAllTouchPointDetailsRoot", jArr);
				} else {
					obj.put("getAllTouchPointDetailsRoot", "");
				}
				response.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getIssueTypeFromCTAdmin")) {
			JSONArray jArr = new JSONArray();
			JSONObject obj = new JSONObject();
			try {
				jArr = ctf.getIssueTypeFromCTAdmin(systemId, clientId);
				if (jArr.length() > 0) {
					obj.put("issueTypeRoot", jArr);
				} else {
					obj.put("issueTypeRoot", "");
				}
				response.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getDelayType")) {
			JSONArray jArr = new JSONArray();
			JSONObject obj = new JSONObject();
			try {
				jArr = ctf.getSubIssueTypeFromCTAdmin(systemId, clientId);
				if (jArr.length() > 0) {
					obj.put("subIssueTypeRoot", jArr);
				} else {
					obj.put("subIssueTypeRoot", "");
				}
				response.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("saveRemarksDetails")) {
			try {
				String delayType = request.getParameter("delayType");
				String delayTime = request.getParameter("delay");
				String remarks = request.getParameter("remarks");
				String startDate = request.getParameter("startDate");
				String endDate = request.getParameter("endDate");
				String tripId = request.getParameter("tripId");
				String vehicleNo = request.getParameter("vehicleNo");

				String message = ctf.saveRemarksDetails(systemId, clientId, userId, startDate, endDate, delayType, delayTime, remarks, tripId, offset, vehicleNo);
				response.getWriter().print(message.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getDelayReasons")) {
			JSONArray jArr = new JSONArray();
			JSONObject obj = new JSONObject();
			String tripId = request.getParameter("tripId");
			try {
				jArr = ctf.getDelayRasons(tripId, offset);
				if (jArr.length() > 0) {
					obj.put("delayReasonDetailsRoot", jArr);
				} else {
					obj.put("delayReasonDetailsRoot", "");
				}
				response.getWriter().print(obj.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("loadAllSupervisorSchedule")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.loadAllSupervisorSchedule(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("supervisorSchedule", jsonArray);
				} else {
					jsonObject.put("supervisorSchedule", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("loadPincodeRegion")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String cityList = request.getParameter("newCityList");
				String message = ctf.saveNewCityDetails(cityList);
				response.getWriter().print(message.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("updateRemarks")) {
			try {
				String alertId = request.getParameter("alertId");
				String uniqueId = request.getParameter("detail");
				if (uniqueId != null && !uniqueId.equals("")) {
					JSONArray responseList = ctf.updateRemarks(systemId, uniqueId, userName, alertId);
					JSONObject finalObject = new JSONObject();
					finalObject.put("snoozedArr", responseList.length() > 0 ? responseList.get(0) : new JSONArray());
					finalObject.put("alreadySnoozedArr", responseList.length() > 0 ? responseList.get(1) : new JSONArray());
					finalObject.put("errorList", responseList.length() > 0 ? responseList.get(2) : new JSONArray());
					finalObject.put("updatedRemarksArr", responseList.length() > 0 ? responseList.get(3) : new JSONArray());
					finalObject.put("oldRemarksArr", responseList.length() > 0 ? responseList.get(4) : new JSONArray());
					response.getWriter().print(finalObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getAlertDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String alertId = request.getParameter("alertId");
				int userIdFromJsp = 0;
				if (request.getParameter("userId") != null && Integer.parseInt(request.getParameter("userId")) == 9999) {
					userIdFromJsp = userId;
				} else {
					userIdFromJsp = Integer.parseInt(request.getParameter("userId"));
				}
				jsonArray = ctf.getAlertDetails(systemId, clientId, Integer.parseInt(alertId), userIdFromJsp);
				if (jsonArray.length() > 0) {
					jsonObject.put("alertDetails", jsonArray);
				} else {
					jsonObject.put("alertDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getRoles")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getRoles(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("roleDetails", jsonArray);
				} else {
					jsonObject.put("roleDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getCriteriaDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getCriteriaDetails(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("criteriaRoot", jsonArray);
				} else {
					jsonObject.put("criteriaRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getCriteria")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = ctf.getCriteria(systemId, clientId);
				if (jsonArray.length() > 0) {
					jsonObject.put("criteriaDetails", jsonArray);
				} else {
					jsonObject.put("criteriaDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("saveCriteriaDetails")) {
			try {
				String tripCustIds = request.getParameter("tripCustNames");
				String custType = request.getParameter("custType");
				String vehType = request.getParameter("vehType");
				String vehicleCategory = request.getParameter("vehicleCategory");
				String criteriaName = request.getParameter("criteriaName");
				String buttonValue = request.getParameter("buttonValue");
				String criteriaId = request.getParameter("criteriaId");

				String message = ctf.saveCriteria(systemId, clientId, userId, tripCustIds, custType, vehType, vehicleCategory, criteriaName, buttonValue, criteriaId);
				response.getWriter().print(message.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("associateCriteriaToUser")) {
			try {
				String userList = request.getParameter("userList");
				String criteriaId = request.getParameter("criteriaName");
				String message = ctf.associateCriteriaToUser(systemId, clientId, userId, userList, criteriaId);
				response.getWriter().print(message.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equals("getCriteriaForEdit")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String criteriaId = request.getParameter("criteriaId");
				jsonArray = ctf.getCriteriaForEdit(systemId, clientId, criteriaId);
				if (jsonArray.length() > 0) {
					jsonObject.put("criteriaForEdit", jsonArray);
				} else {
					jsonObject.put("criteriaForEdit", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}