package t4u.containercargomanagement;

import java.io.File;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

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
import t4u.common.DBConnection;
import t4u.functions.ContainerCargoManagementFunctions;

public class CashBookAction extends Action{
	
	@SuppressWarnings({ "deprecation", "unchecked" })
	public ActionForward execute(ActionMapping mapping, ActionForm form,
	        HttpServletRequest request, HttpServletResponse response)
	throws Exception {

		String param = "";
		int systemId = 0;
		int userId = 0;
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		systemId = loginInfo.getSystemId();
		userId = loginInfo.getUserId();
		int isLtsp = loginInfo.getIsLtsp();
		int offset = loginInfo.getOffsetMinutes();
		String language = loginInfo.getLanguage();
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		ContainerCargoManagementFunctions ccmFunc = new ContainerCargoManagementFunctions();

		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("getUserBranchList")) {
			String custId = request.getParameter("custId");

			if(isLtsp == 0) {
				jsonArray = ccmFunc.getBranch(systemId,custId);
			} else {
				jsonArray = ccmFunc.getUserBranchList(systemId, custId, userId);
			}
			if(jsonArray != null) {
				jsonObject.put("userBranchRoot", jsonArray);
			} else {
				jsonObject.put("userBranchRoot", "");
			}
//			System.out.println("userBranchRoot : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());

		} else if(param.equals("getBranchList")) {
			String custId = request.getParameter("custId");
			
			if(isLtsp == 0) {
				jsonArray = ccmFunc.getBranch(systemId,custId);
			} else {
				jsonArray = ccmFunc.getUserBranchList(systemId, custId, userId);
			}
			if(jsonArray != null) {
				jsonObject.put("branchRoot", jsonArray);
			} else {
				jsonObject.put("branchRoot", "");
			}
//			System.out.println("userBranchRoot : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());
		} else if (param.equals("getTransactionTypeList")) {
			String custId = request.getParameter("custId");
			jsonArray = ccmFunc.getTransactionTypeList(systemId, custId, userId);
			if(jsonArray != null) {
				jsonObject.put("transactionTypeRoot", jsonArray);
			} else {
				jsonObject.put("transactionTypeRoot", "");
			}
//			System.out.println("transactionTypeRoot : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());

		} else if (param.equals("getAccountHeaderList")) {
			String custId = request.getParameter("custId");

			jsonArray = ccmFunc.getAccountHeaderList(systemId, custId, userId);
			if(jsonArray != null) {
				jsonObject.put("accountHeaderRoot", jsonArray);
			} else {
				jsonObject.put("accountHeaderRoot", "");
			}
//			System.out.println("accountHeaderRoot : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());

		} else if (param.equals("getCleanerList")) {
			String custId = request.getParameter("custId");

			jsonArray = ccmFunc.getCleaners(systemId, custId);
			if(jsonArray != null) {
				jsonObject.put("cleanerRoot", jsonArray);
			} else {
				jsonObject.put("cleanerRoot", "");
			}
//			System.out.println("getCleanerList : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());
		} else if (param.equals("getVehicles")) {
			String custId = request.getParameter("custId");

			jsonArray = ccmFunc.getVehicles(systemId, custId, userId);
			if(jsonArray != null) {
				jsonObject.put("vehicleRoot", jsonArray);
			} else {
				jsonObject.put("vehicleRoot", "");
			}
//			System.out.println("vehicleRoot : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());
		} else if (param.equals("getdriverList")) {
			String custId = request.getParameter("custId");

			jsonArray = ccmFunc.getDrivers(systemId, custId);
			if(jsonArray != null) {
				jsonObject.put("driverRoot", jsonArray);
			} else {
				jsonObject.put("driverRoot", "");
			}
//			System.out.println("driverRoot : "+jsonArray.toString());
			response.getWriter().print(jsonObject.toString());
		} else if (param.equals("saveCashBookDetails")) {

			String custId = request.getParameter("custId");
			String buttonValue = request.getParameter("buttonValue");	
			String branchId = request.getParameter("branchId");	
			String transacTypeId = request.getParameter("transacTypeId");	
			String transactionDate = request.getParameter("transactionDateId");	
			String amount = request.getParameter("amountId");	
			String accHeaderId = request.getParameter("accHeaderId");	
			String description = request.getParameter("descriptionid");	
			String vehicleId = request.getParameter("vehId");	
			String driverId = request.getParameter("drivId");
			String cleanerId = request.getParameter("cleaId");	
			String billNo = request.getParameter("billNoId");
		    String uploadFileFlag = request.getParameter("uploadFileFlag");	
		    String fileExtension = ""; 
			int id = 0;
			Connection con = null;
			String status = "PENDING";
			try {
				
				con = DBConnection.getConnectionToDB("LMS");
				con.setAutoCommit(false);
				
//System.out.println(uploadFileFlag + "	custId	" +custId+ "	buttonValue	"+buttonValue + "	branchId	"+branchId+"	transacTypeId	"+transacTypeId+
//		"	transactionDate"+transactionDate+"	amount	"+amount+"	accHeaderId	"+accHeaderId+"	description	"+description+"	vehicleId	"+vehicleId+"	cleanerId	"+cleanerId+"	billNo	"+billNo);

				if(buttonValue.equals("add"))
					id = ccmFunc.saveCashBookDetails(con ,systemId, custId, userId, branchId, transacTypeId, transactionDate, amount, accHeaderId, description, vehicleId, driverId, cleanerId, billNo, offset, status);

				if(id > 0 && uploadFileFlag.equals("true")) {
//				System.out.println("if : "+uploadFileFlag);
					String fileName = null;
					String destinationPath = "";
					String uploadMessage = "";
					Date d = new Date();
					Calendar cal = Calendar.getInstance();
					cal.setTime(d);
					int year = cal.get(Calendar.YEAR);
					int month = cal.get(Calendar.MONTH);
					int day = cal.get(Calendar.DAY_OF_MONTH);
					month = month + 1;
					String yearString = "" + year;
					String monthString = "" + month;
					String dayString = "" + day;

					boolean isMultipart = ServletFileUpload.isMultipartContent(request);
					if (isMultipart) {
						FileItemFactory factory = new DiskFileItemFactory();
						ServletFileUpload upload = new ServletFileUpload(factory);
						List items = upload.parseRequest(request);
						Iterator iter = items.iterator();
						Properties properties = ApplicationListener.prop;

						String path = properties.getProperty("DocumentUploadPath").trim() + "/" + "Padma_Invoice" + "/" + yearString + "/" + monthString + "/" + dayString + "/" ;
						while (iter.hasNext()) {
							FileItem item = (FileItem) iter.next();
							if (!item.isFormField()) {
								File uploadedFile = null;
								File f = null;
								if (item.getName() != "") {
									fileName = item.getName();
									if (fileName!=null && !fileName.equals("") && fileName.contains("\\")) {
										String[] a = fileName.split("\\\\");
										fileName = a[a.length-1];
									}
									String fileNameExcludeExtension = fileName.substring(0,fileName.lastIndexOf("."));

									fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());
									destinationPath = path + fileNameExcludeExtension + fileExtension;
									uploadedFile = new File(destinationPath);
									f = new File(path);
									if (!f.exists()) {
										f.mkdirs();
									}

									item.write(uploadedFile);

									/**
									 * Rename
									 */
									File oldFileName = new File(destinationPath);
									File newFileNameWithId = new File(path+id+fileExtension);
									if (oldFileName.exists()) {
										oldFileName.renameTo(newFileNameWithId);
									}
									
									uploadMessage = "Success";
									if (uploadMessage.equals("Success")) {
										int update = ccmFunc.updateFileDetails(con, fileName, id, Integer.parseInt(custId), systemId, userId, fileExtension);
										if(update>0){
											con.commit();
											response.getWriter().print("{success:true}");
										} else {
											con.commit();
											response.getWriter().print("{success:false}");
										}
									}else {
										con.commit();
										response.getWriter().print("{success:false}");
									}
								}
							}
						}
					}
				} else if(id > 0 && uploadFileFlag.equals("false")) {
					con.commit();
//				System.out.println("else if : "+uploadFileFlag);
					response.getWriter().print("{success:true}");
				} else {
					con.commit();
//				System.out.println("else : "+uploadFileFlag);
					response.getWriter().print("{success:false}");
				}
			} catch (Exception e) {
				try {
	        		if(con != null){
	        			con.rollback();
	        		}
				} catch (Exception e2) {
					e2.printStackTrace();
				}
				e.printStackTrace();
			} finally {
				if(con != null){
					con.close();
				}
			}

		} else if(param.equals("getCashBookDetails")) {
			String custId = request.getParameter("custId");
			String branchId = request.getParameter("branchId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			String jspName = request.getParameter("jspName");
			JSONArray openingAndClosingBal = ccmFunc.getOpeningAndClosingBal(systemId, custId, branchId, startDate, endDate, offset);
			
			if(openingAndClosingBal.length() > 0){
				JSONObject obj = (JSONObject)openingAndClosingBal.get(0);
				request.getSession().setAttribute("openingBal", obj.get("openingBal"));
				request.getSession().setAttribute("closingBal", obj.get("closingBal"));
			}
			
			ArrayList<Object> cashBookList = ccmFunc.getCashBookDetails(systemId, custId, userId, branchId, offset, startDate, endDate, language);
			if(cashBookList != null) {
				if(cashBookList.size() > 0){
				jsonArray = (JSONArray)cashBookList.get(0);
				if(jsonArray.length() > 0) {
					jsonObject.put("cashBookRoot", jsonArray);
					ReportHelper reportHelper = (ReportHelper) cashBookList.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("startDate", startDate);
					request.getSession().setAttribute("endDate", endDate);
				} else {
					jsonObject.put("cashBookRoot", "");
				}
			} else {
				jsonObject.put("cashBookRoot", "");
			}
				response.getWriter().print(jsonObject.toString());
			}
		} else if(param.equals("isInvoiceExists")) {
			String custId = request.getParameter("custId");
			String id = request.getParameter("id");
			String sysId = request.getParameter("systemId");
			
			JSONObject obj = ccmFunc.getDocuments(custId, id, sysId);
			response.getWriter().print(obj.get("id"));
			
		} else if(param.equals("getBranchCurrentBalance")) {
			String custId = request.getParameter("custId");
			String branchId = request.getParameter("branchId");
			
			jsonArray = ccmFunc.getBranchCurrentBalance(systemId, custId, branchId);
			
			if(jsonArray != null ){
				jsonObject.put("branchCurrentBalanceRoot", jsonArray);
			} else {
				jsonObject.put("branchCurrentBalanceRoot", "");
			}
			
			response.getWriter().print(jsonObject.toString());
		} else if(param.equals("getOpeningAndClosingBal")) {
			String custId = request.getParameter("custId");
			String branchId = request.getParameter("branchId");
			String startDate = request.getParameter("startDate");
			String endDate = request.getParameter("endDate");
			
			jsonArray = ccmFunc.getOpeningAndClosingBal(systemId, custId, branchId, startDate, endDate, offset);
			//System.out.println("opening bal  : " +jsonArray.toString());
			if(jsonArray != null ){
				jsonObject.put("balanceRoot", jsonArray);
			} else {
				jsonObject.put("balanceRoot", "");
			}
			
			response.getWriter().print(jsonObject.toString());
		}

		return null;
	}


}
