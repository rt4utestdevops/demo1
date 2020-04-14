package t4u.ironMining;

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

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.IronMiningFunction;

public class TripFeedDetailsAction extends Action {

	@SuppressWarnings({ "unchecked", "unchecked", "deprecation" })
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		IronMiningFunction ironfunc = new IronMiningFunction();
		int systemId = loginInfo.getSystemId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		// ------------------------------------- Trip Feed Information-----------------------------------------------------------//

		if (param.equalsIgnoreCase("getTripFeedDetails")) {
			try {
				String custId = request.getParameter("custId");
				String CustName = request.getParameter("CustName");
				String jspName = request.getParameter("jspName");
				jsonArray = new JSONArray();
				ArrayList<Object> list = ironfunc.getTripFeedDetails(Integer.parseInt(custId), systemId, userId);
				jsonArray = (JSONArray) list.get(0);
				if (jsonArray.length() > 0) {
					jsonObject.put("tripFeedRoot", jsonArray);
				} else {
					jsonObject.put("tripFeedRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspName, reportHelper);
				request.getSession().setAttribute("CustName", CustName);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("addTripFeedDetails")) {
			try {
				String custId = request.getParameter("custId");
				String buttonValue = request.getParameter("buttonValue");
				String tcId = request.getParameter("tcId") != null && !request.getParameter("tcId").equals("") ? request.getParameter("tcId") : "0";
				String orgId = request.getParameter("orgId") != null && !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
				String permitId = request.getParameter("permitId") != null && !request.getParameter("permitId").equals("") ? request.getParameter("permitId"): "0";
				String plantId = request.getParameter("plantId") != null && !request.getParameter("plantId").equals("") ? request.getParameter("plantId"): "0";
				String ROMQuantity = request.getParameter("ROMQuantity");
				String vehicleNo = request.getParameter("vehicleNo");
				String message = "";
				if (buttonValue.equals("Add") && custId != null && !custId.equals("")) {
					message = ironfunc.addTripFeedDetails(Integer.parseInt(custId),
									systemId, Integer.parseInt(tcId), Integer.parseInt(orgId), Integer.parseInt(permitId), Integer.parseInt(plantId),
									Float.parseFloat(ROMQuantity), userId,vehicleNo);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getTcNumber")) {
			try {
				String custId = request.getParameter("custId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getTCNumberforTripFeed(Integer.parseInt(custId), systemId, userId);
					if (jsonArray.length() > 0) {
						jsonObject.put("TcNumberRoot", jsonArray);
					} else {
						jsonObject.put("TcNumberRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getPermitNumber")) {
			try {
				String custId = request.getParameter("custId");
				String tcId = request.getParameter("tcId") != null && !request.getParameter("tcId").equals("") ? request.getParameter("tcId") : "0";
				String orgId = request.getParameter("orgId") != null && !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
				String permitType =request.getParameter("permitType");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getPermitNumberForTripFeed(Integer.parseInt(custId), systemId, Integer.parseInt(tcId),userId,Integer.parseInt(orgId),permitType);
					if (jsonArray.length() > 0) {
						jsonObject.put("PermitNumRoot", jsonArray);
					} else {
						jsonObject.put("PermitNumRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getPermitNumberForSelfConsumption")) {
			try {
				String custId = request.getParameter("custId");
				String tcId = request.getParameter("tcId") != null && !request.getParameter("tcId").equals("") ? request.getParameter("tcId") : "0";
				String orgId = request.getParameter("orgId") != null && !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
				String permitType =request.getParameter("permitType");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getPermitNumberForSelfConsumption(Integer.parseInt(custId), systemId, Integer.parseInt(tcId),userId,Integer.parseInt(orgId),permitType);
					if (jsonArray.length() > 0) {
						jsonObject.put("PermitNumRoot1", jsonArray);
					} else {
						jsonObject.put("PermitNumRoot1", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getPlantNames")) {
			try {
				String custId = request.getParameter("custId");
				String orgId = request.getParameter("orgId") != null && !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
				String destHubId = request.getParameter("destHubId") != null && !request.getParameter("destHubId").equals("") ? request.getParameter("destHubId"): "0";
				String mineral = request.getParameter("mineral");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getPlantNames(Integer.parseInt(custId), systemId, Integer.parseInt(orgId), Integer.parseInt(destHubId),mineral);
					if (jsonArray.length() > 0) {
						jsonObject.put("plantNameRoot", jsonArray);
					} else {
						jsonObject.put("plantNameRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("addSelfConsumptionDetails")) {
			try {
				String custId = request.getParameter("custId");
				String buttonValue = request.getParameter("buttonValue");
				String tcId = request.getParameter("tcId") != null && !request.getParameter("tcId").equals("") ? request.getParameter("tcId") : "0";
				String orgId = request.getParameter("orgId") != null && !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
				String permitId = request.getParameter("permitId") != null && !request.getParameter("permitId").equals("") ? request.getParameter("permitId"): "0";
				String ROMQuantity = request.getParameter("ROMQuantity");
				String vehicleNo = request.getParameter("vehicleNo");
				String message = "";
				if (buttonValue.equals("closetrip") && custId != null && !custId.equals("")) {
					message = ironfunc.addSelfConsumptionDetails(Integer.parseInt(custId),
							systemId, Integer.parseInt(tcId), Integer.parseInt(orgId), Integer.parseInt(permitId),
							Float.parseFloat(ROMQuantity), userId,vehicleNo);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("importRTPDetails")) {

			String importMessage = "";
			try {
				String fileName = null;
				boolean isMultipart = ServletFileUpload.isMultipartContent(request);
				String custId = request.getParameter("custId") != null && !request.getParameter("custId").equals("") ? request.getParameter("custId") : "0";
				if (isMultipart) {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
					while (iter.hasNext()) {
						FileItem item = (FileItem) iter.next();
						String fileExtension = "";
						if (!item.isFormField()) {
							File uploadedFile = null;
							File f = null;
							if (item.getName() != "") {
								fileName = item.getName();
								fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());

								String excelPath = path+ "RTPDetailsImportData-" + systemId + userId + fileExtension;
								uploadedFile = new File(excelPath);

								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							ImportExcelForRTPDetails dei = new ImportExcelForRTPDetails(uploadedFile, userId, systemId, Integer.parseInt(custId),
									offset,fileExtension);

							importMessage = dei.ImportRTPTripDetails();
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

		else if (param.equalsIgnoreCase("getImportRTPDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String importResponse = request.getParameter("importResponse");
				if (importResponse.equals("{success:true}")) {
					jsonArray = ImportExcelForRTPDetails.globalJsonArray;
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("RTPImportRoot", jsonArray);
				} else {
					jsonObject.put("RTPImportRoot", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("saveImportDetailsForRTP")) {
			String messages = "";
			String json = request.getParameter("json");
			String customerId = request.getParameter("custId");
			try {
				if (json != null && !json.equals("")) {
					JSONArray jsonarray = null;
					try {
						jsonarray = new JSONArray(json.toString());
						messages = ironfunc.saveImportDetailsForRTP(jsonarray,Integer.parseInt(customerId), systemId, userId);
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					messages = "No Trip Data To Save";
				}
				response.getWriter().print(messages);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("addChallanTripDetails")) {
			try {
				String custId = request.getParameter("custId");
				String orgId = request.getParameter("orgId") != null && !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
				String challanId = request.getParameter("challanId") != null&& !request.getParameter("challanId").equals("") ? request.getParameter("challanId"): "0";
				String chaplantId = request.getParameter("chaplantId") != null&& !request.getParameter("chaplantId").equals("") ? request.getParameter("chaplantId"): "0";
				String quantity = request.getParameter("quantity");
				String vehicleNo = request.getParameter("vehicleNo");
				String mineral=request.getParameter("mineral");
				String message = "";
				if (custId != null && !custId.equals("")) {
					message = ironfunc.addChallanTripDetails(Integer.parseInt(custId), systemId, Integer.parseInt(orgId), Integer.parseInt(challanId),Integer.parseInt(chaplantId), Float.parseFloat(quantity), userId, vehicleNo,mineral);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getOrgNames")) {
			try {
				String custId = request.getParameter("custId");
				String type = request.getParameter("type")!=null && request.getParameter("type")!="" ? request.getParameter("type"):"";
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getOrgNameforTripFeed(Integer.parseInt(custId), systemId, userId, type);
					if (jsonArray.length() > 0) {
						jsonObject.put("orgRoot", jsonArray);
					} else {
						jsonObject.put("orgRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("getChallanNumber")) {
			try {
				String custId = request.getParameter("custId");
				String tcId = request.getParameter("tcId") != null&& !request.getParameter("tcId").equals("") ? request.getParameter("tcId") : "0";
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getChallanNumber(Integer.parseInt(custId),systemId, Integer.parseInt(tcId));
					if (jsonArray.length() > 0) {
						jsonObject.put("challanNumRoot", jsonArray);
					} else {
						jsonObject.put("challanNumRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getPlantNamesForCha")) {
			try {
				String custId = request.getParameter("custId");
				String mineral = request.getParameter("mineral");
				String orgId = request.getParameter("orgId") != null&& !request.getParameter("orgId").equals("") ? request.getParameter("orgId") : "0";
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (custId != null && !custId.equals("")) {
					jsonArray = ironfunc.getPlantNamesForCha(Integer.parseInt(custId), systemId, Integer.parseInt(orgId),mineral);
					if (jsonArray.length() > 0) {
						jsonObject.put("plantNameRoot1", jsonArray);
					} else {
						jsonObject.put("plantNameRoot1", "");
					}
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("importPOChallanDetails")) {

			String importMessage = "";
			try {
				@SuppressWarnings("unused")
				String fileName = null;
				String custId = request.getParameter("custId") != null&& !request.getParameter("custId").equals("") ? request.getParameter("custId") : "0";

				boolean isMultipart = ServletFileUpload.isMultipartContent(request);
				if (isMultipart) {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
					while (iter.hasNext()) {
						FileItem item = (FileItem) iter.next();
						String fileExtension = "";
						if (!item.isFormField()) {
							File uploadedFile = null;
							File f = null;
							if (item.getName() != "") {
								fileName = item.getName();
								fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());
								String excelPath = path+ "POChallanDetailsImportData-" + systemId + userId + fileExtension;
								uploadedFile = new File(excelPath);

								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							ImportExcelForProcessedOreChallan dei = new ImportExcelForProcessedOreChallan(uploadedFile, userId, systemId,
									Integer.parseInt(custId), offset,fileExtension);
							importMessage = dei.ImportProcessedChallanDetails();
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
		} else if (param.equalsIgnoreCase("getImportPOChallanDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String importResponse = request.getParameter("importResponse");
				if (importResponse.equals("{success:true}")) {
					jsonArray = ImportExcelForProcessedOreChallan.globalJsonArray;
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("POImportRoot1", jsonArray);
				} else {
					jsonObject.put("POImportRoot1", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("saveImportDetailsForPOChallan")) {
			String messages = "";
			String json = request.getParameter("json1");
			String customerId = request.getParameter("custId");
			try {
				if (json != null && !json.equals("")) {
					JSONArray jsonarray = null;
					try {
						jsonarray = new JSONArray(json.toString());
						messages = ironfunc.saveImportDetailsForPOChallan(jsonarray, Integer.parseInt(customerId),systemId, userId);
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					messages = "No Trip Data To Save";
				}
				response.getWriter().print(messages);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("getVehicleNo")) {
			String custId = request.getParameter("custId");
			if (custId != null && !custId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getVehicleNoList(custId, systemId);
					if (jsonarray.length() > 0) {
						jsonObject.put("vehicleRoot", jsonarray);
					} else {
						jsonObject.put("vehicleRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}else if (param.equals("openStandardFileFormats")) {
			try {
				File stdFile;
				String filename;
				Properties properties = ApplicationListener.prop;
				String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
				stdFile = new File(path + "StandardFormatImportRTPTrip.xls");
				filename = "RTPTripDetails";
				response.setContentType("application/xls");
				response.setHeader("Content-disposition",
						"attachment;filename=" + filename + ".xls");
				FileInputStream fis = new FileInputStream(stdFile);
				ServletOutputStream servletOutputStream = response
						.getOutputStream();
				DataOutputStream outputStream = new DataOutputStream(
						servletOutputStream);
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
		}else if (param.equals("openStandardFileFormats1")) {
			try {
				File stdFile;
				String filename;
				Properties properties = ApplicationListener.prop;
				String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
				stdFile = new File(path + "StandardFormatImportPOChallan.xls");
				filename = "POChallanDetails";
				response.setContentType("application/xls");
				response.setHeader("Content-disposition",
						"attachment;filename=" + filename + ".xls");
				FileInputStream fis = new FileInputStream(stdFile);
				ServletOutputStream servletOutputStream = response
						.getOutputStream();
				DataOutputStream outputStream = new DataOutputStream(
						servletOutputStream);
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
		}
		else if (param.equalsIgnoreCase("cancelTripFeed")) {
			String customerId = request.getParameter("CustID");
			String id = request.getParameter("id");
			String challanNo= request.getParameter("challanNo");
			String permitId = request.getParameter("permitId") != null && !request.getParameter("permitId").equals("") ? request.getParameter("permitId"): "0";
			String plantId = request.getParameter("plantId") != null && !request.getParameter("plantId").equals("") ? request.getParameter("plantId"): "0";
			String qty= request.getParameter("qty");
			String remarks=request.getParameter("remark");
			String message1="";
			if (customerId != null && !customerId.equals("") && id != null && !id.equals("")) {
				try {
					message1 = ironfunc.cancelTripFeed(Integer.parseInt(customerId), systemId,userId,Integer.parseInt(id),
							Integer.parseInt(plantId),qty,Integer.parseInt(permitId),challanNo,remarks);
					response.getWriter().print(message1);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return null;
    }
}
