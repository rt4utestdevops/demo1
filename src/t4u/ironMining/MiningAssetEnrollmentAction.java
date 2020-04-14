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

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;

public class MiningAssetEnrollmentAction extends Action {
	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
		int systemId  = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf=new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject=null;
		String message="";
		String param = "";
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		if (param.equalsIgnoreCase("getAssetEnrollmentDetails")) {
			try {
				ArrayList list=null;
				String CustomerId = request.getParameter("CustID");
				String jspName=request.getParameter("jspName");
				String customerName=request.getParameter("CustName");
				//System.out.println("CustomerId:"+CustomerId+"jspName:"+jspName);
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list =ironfunc.getAssetEnrollmentDetails(customerName,systemId, Integer.parseInt(CustomerId),userId,lang);
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("miningAssetEnrollDetailsRoot", jsonArray);
					} else {
						jsonObject.put("miningAssetEnrollDetailsRoot", "");
					}
					reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName,reportHelper);
					request.getSession().setAttribute("custId", customerName);
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("miningAssetEnrollDetailsRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getimportAddDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String importResponse = request.getParameter("importResponse");
				if (importResponse.equals("{success:true}")) {
					jsonArray = ImportExcelForAddDetails.globalJsonArray;
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("AssetMining", jsonArray);
				} else {
					jsonObject.put("AssetMining", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getImportInsuranceDetails")) {

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

								String excelPath = path+ "AddDetailsImportData-" + systemId + userId + fileExtension;
								uploadedFile = new File(excelPath);

								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							ImportExcelForAddDetails dei = new ImportExcelForAddDetails(uploadedFile, userId, systemId, Integer.parseInt(custId),
									offset,fileExtension);

							importMessage = dei.ImportInsuranceDetails();
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
		else if (param.equalsIgnoreCase("importAssetUpdateDetails")) {

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

								String excelPath = path+ "UpdateAssetEnrollmentData-" + systemId + userId + fileExtension;
								uploadedFile = new File(excelPath);

								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							ImpportModifyExcelForAssertEnroll dei = new ImpportModifyExcelForAssertEnroll(uploadedFile, userId, systemId, Integer.parseInt(custId),
									offset,fileExtension);

							importMessage = dei.getModifiedImportExcellDetails();
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
		else if (param.equalsIgnoreCase("getImportAssetUpdateDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String importResponse = request.getParameter("importResponse");
				if (importResponse.equals("{success:true}")) {
					jsonArray = ImpportModifyExcelForAssertEnroll.globalJsonArray;
					//System.out.println(jsonArray.toString());
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("modImpAssetRoot", jsonArray);
				} else {
					jsonObject.put("modImpAssetRoot", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("openStandardFileFormatsForModify")) {
			try {
				File stdFile;
				String filename;
				Properties properties = ApplicationListener.prop;
				String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
				stdFile = new File(path + "AssetEnrollmentDetailsModification.xls");
				filename = "Asset_Enrollment_Details_Modification";
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
				else if (param.equalsIgnoreCase("updateImportDetailsForAsset")) {
			String messages = "";
			String json = request.getParameter("updateJson");
			String customerId = request.getParameter("custId");
			try {
				String CustName=request.getParameter("CustName");
				if (json != null && !json.equals("")) {
					JSONArray jsonarray = null;
					try {
						jsonarray = new JSONArray(json.toString());
						messages = ironfunc.updateAssetEnrollmentImportDetails(jsonarray,Integer.parseInt(customerId), systemId, userId,CustName);
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					messages = "No valid Asset Data To Update";
				}
				response.getWriter().print(messages);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("openStandardFileFormats")) {
			try {
				File stdFile;
				String filename;
				Properties properties = ApplicationListener.prop;
				String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
				stdFile = new File(path + "AssetEnrollmentDetails.xls");
				filename = "Asset Enrollment Details";
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
		
		else if (param.equalsIgnoreCase("saveormodifyAssetEnrollment")) {
			String princiaplBal="0.0";
			String overDues="0.0";
			String InterestBal="0.0";
			String MobileNo="0";
			String PhoneNo="0";
			try {
				String buttonValue=request.getParameter("buttonValue");
				String CustomerId = request.getParameter("CustID");
				String AssetNo=request.getParameter("AssetNo");
				String RegDate=request.getParameter("RegDate");
				String engineNo=request.getParameter("engineNo");
				String CarriageCapacity=request.getParameter("CarriageCapacity");
				String operationMine=request.getParameter("operationMine");
				String location=request.getParameter("location");
				String leaseNo=request.getParameter("leaseNo");
				String ChassisNo=request.getParameter("ChassisNo");
				String InsurancePolicyNo=request.getParameter("InsurancePolicyNo");
				String InsuranceExpiryDate=request.getParameter("InsuranceExpiryDate");
				String PucNumber=request.getParameter("PucNumber");
				String PucExpiryDate=request.getParameter("PucExpiryDate");
				String ownerName=request.getParameter("ownerName");
				String houseNo=request.getParameter("houseNo");
				String locality=request.getParameter("locality");
				String city=request.getParameter("city");
				String taluk=request.getParameter("taluk");
				String district = request.getParameter("district") != null && !request.getParameter("district").equals("") ? request.getParameter("district") : "0";
				String state = request.getParameter("state") != null && !request.getParameter("state").equals("") ? request.getParameter("state") : "0";
				String epicNo=request.getParameter("epicNo");
				String panNo=request.getParameter("panNo");
				MobileNo=request.getParameter("MobileNo");
				PhoneNo=request.getParameter("PhoneNo");
				if (MobileNo.equals("")||PhoneNo.equals("")) {
					MobileNo="0";
					PhoneNo="0";
				}
				String adharNo=request.getParameter("adharNo");
				String EnrollDate=request.getParameter("EnrollDate");
				String Bank=request.getParameter("Bank");
				String Branch=request.getParameter("Branch");
				princiaplBal=request.getParameter("princiaplBal");
				overDues=request.getParameter("overDues");
				InterestBal=request.getParameter("InterestBal");
				if (princiaplBal.equals("")||overDues.equals("")||InterestBal.equals("")) {
					princiaplBal="0.0";
					overDues="0.0";
					InterestBal="0.0";
				}
				String AccountNo=request.getParameter("AccountNo");
				String uniqueId=request.getParameter("uniqueId");
				String CustName=request.getParameter("CustName");
				String assemblyName=request.getParameter("assemblyName");
				String roadTaxValidityDate = request.getParameter("roadTaxValidityDate");
				String permitValidityDate = request.getParameter("permitValidityDate");
				message = "";
				if (buttonValue.equals("add")) {

					if (CustomerId != null || AssetNo != null
							|| CarriageCapacity != null || ownerName != null) {
						message = ironfunc.saveAssetEnrollmentInformation(
								Integer.parseInt(CustomerId),AssetNo,RegDate,engineNo,CarriageCapacity,operationMine,location,leaseNo,
								ChassisNo,InsurancePolicyNo,InsuranceExpiryDate,PucNumber,PucExpiryDate,ownerName,houseNo,locality,city,taluk,district,state,
								epicNo,panNo,MobileNo,PhoneNo,adharNo,EnrollDate,Bank,Branch,princiaplBal,overDues,InterestBal,AccountNo,userId,systemId,CustName,assemblyName,roadTaxValidityDate,permitValidityDate);
					}

				} else if (buttonValue.equals("modify")) {

					if (CustomerId != null || AssetNo != null
							|| CarriageCapacity != null || ownerName != null || district != null
							|| state != null) {
						message = ironfunc.modifyAssetEnrollmentInformation(
								Integer.parseInt(CustomerId),AssetNo,RegDate,engineNo,CarriageCapacity,operationMine,location,leaseNo,
								ChassisNo,InsurancePolicyNo,InsuranceExpiryDate,PucNumber,PucExpiryDate,ownerName,houseNo,locality,city,taluk,district,state,
								epicNo,panNo,MobileNo,PhoneNo,adharNo,EnrollDate,Bank,Branch,princiaplBal,overDues,InterestBal,AccountNo,userId,uniqueId,systemId,assemblyName,roadTaxValidityDate,permitValidityDate);
					}
				}
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Asset Enrollment Action:-saveORmodifyAssetEnrollmentDetails"+e.toString());
			}

		}
		else if (param.equalsIgnoreCase("acknowledgeSave")) {
			String messages="";
			String ackuniqueId= request.getParameter("ackuniqueId");
			String CustomerId = request.getParameter("CustId");
			String AssetNos=request.getParameter("VehicleNo");
			String challenNo=request.getParameter("challenNo");
			String challendate=request.getParameter("challendate");
			String BankTransactionNumber=request.getParameter("BankTransactionNumber");
			String PaidAmount=request.getParameter("PaidAmount");
			String ValidityDate=request.getParameter("ValidityDate");
            String  enrolNoGrid= request.getParameter("enrollNumberIds");
			String  enrollDateGrid= request.getParameter("EnrollDateIds");
			String  assetNumberGrid= request.getParameter("assetNumberIds");
			String  regstartdateGrid= request.getParameter("regstartdates");
			String  carriageCapacityGrid= request.getParameter("carriageCapacityIds");
			String  operatingOnMineGrid= request.getParameter("operatingOnMineIds");
			String  locationGrid= request.getParameter("locationIds");
			String  miningLeaseNoGrid= request.getParameter("MiningLeaseNoIds");
			String  chassisNoGrid= request.getParameter("ChassisNoIds");
			String  ownerNameGrid= request.getParameter("OwnerNameIds");
			String  assemblyNameGrid= request.getParameter("AssemblyNameIds");
			String  houseNoGrid= request.getParameter("houseNoIds");
			String  localityGrid= request.getParameter("LocalityIds");
			String  enterCityGrid= request.getParameter("enterCityIds");
			String  talukaGrid= request.getParameter("talukaIds");
			String  districtcomboGrid= request.getParameter("districtcomboIds");
			String  statecomboGrid= request.getParameter("statecomboIds");
			String  EPICNoGrid= request.getParameter("EPICNoIds");
			String  PANNoGrid= request.getParameter("PANNoIds");
			String  mobileNoGrid= request.getParameter("MobileNoIds");
			String  phoneNoGrid= request.getParameter("PhoneNoIds");
			String  adharNoGrid= request.getParameter("adharNoIds");
			String  bankGrid= request.getParameter("BankIds");
			String  branchGrid= request.getParameter("BranchIds");
			String  principalBalanceGrid= request.getParameter("PrincipalBalanceIds");
			String  principalOverDuesGrid= request.getParameter("PrincipalOverDuesIds");
			String  interestBalanceGrid= request.getParameter("InterestBalanceIds");
			String  accountNoGrid= request.getParameter("AccountNoIds");
			String  challenNoGrid= request.getParameter("challenNoIds");
			String  challenDataGrid= request.getParameter("challenDataDates");
			String  banktransactionGrid= request.getParameter("banktransactions");
			String  amountPaidGrid= request.getParameter("amountPaidDatas");
			String  validityDateGrid= request.getParameter("validityDatedatas");
			String StatusGrid=request.getParameter("StatusGrid");
			
			//System.out.println(ackuniqueId);
			//System.out.println("CustomerId:-->"+CustomerId+"AssetNos:-->"+AssetNos+":challenNo"+challenNo+challendate+BankTransactionNumber+PaidAmount+ValidityDate);
			try {
				String ChallenDate ="";
				String validityDate="";
				String ChallenDataGrid="";
				String ValidityDateGrid="";
				if (challendate.contains("T")) {
					ChallenDate = challendate.substring(0,challendate.indexOf("T"))+ " "+ challendate.substring(challendate.indexOf("T") + 1, challendate.length());
					if (challenDataGrid.contains("T")) {
						ChallenDataGrid = challenDataGrid.substring(0,challenDataGrid.indexOf("T"))+ " "+ challenDataGrid.substring(challenDataGrid.indexOf("T") + 1, challenDataGrid.length());
					}
				}
				if (ValidityDate.contains("T")) {
					validityDate = ValidityDate.substring(0,ValidityDate.indexOf("T"))+ " "+ ValidityDate.substring(ValidityDate.indexOf("T") + 1, ValidityDate.length());
					if (validityDateGrid.contains("T")) {
						ValidityDateGrid = validityDateGrid.substring(0,validityDateGrid.indexOf("T"))+ " "+ validityDateGrid.substring(validityDateGrid.indexOf("T") + 1, validityDateGrid.length());
					}
				}
				messages = ironfunc.saveAssetAcknowledgementInformation(
						Integer.parseInt(CustomerId),AssetNos,challenNo,ChallenDate,BankTransactionNumber,PaidAmount,validityDate,userId,systemId,ackuniqueId,
						enrolNoGrid,enrollDateGrid,assetNumberGrid,regstartdateGrid,carriageCapacityGrid,operatingOnMineGrid,locationGrid,miningLeaseNoGrid,chassisNoGrid,ownerNameGrid,
						assemblyNameGrid,houseNoGrid,localityGrid,enterCityGrid,talukaGrid,districtcomboGrid,statecomboGrid,EPICNoGrid,PANNoGrid,mobileNoGrid,phoneNoGrid,adharNoGrid,bankGrid,branchGrid,
						principalBalanceGrid,principalOverDuesGrid,interestBalanceGrid,accountNoGrid,challenNoGrid,ChallenDataGrid,banktransactionGrid,amountPaidGrid,ValidityDateGrid,StatusGrid);
				//System.out.println(messages);
				response.getWriter().print(messages);
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Inside Aknoledgement Action"+e.toString());
			}
		}
		
		else if (param.equalsIgnoreCase("saveImportDetailsForInsurance")) {
			String messages = "";
			String json = request.getParameter("json");
			String customerId = request.getParameter("custId");
			try {
				String CustName=request.getParameter("CustName");
				if (json != null && !json.equals("")) {
					JSONArray jsonarray = null;
					try {
						jsonarray = new JSONArray(json.toString());
						messages = ironfunc.saveImportDetailsForInsurance(jsonarray,Integer.parseInt(customerId), systemId, userId,CustName);
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
		}
	return null;
	}

}