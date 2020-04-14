package t4u.containercargomanagement;

import java.io.*;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileItemFactory;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;


import t4u.beans.LoginInfoBean;
import t4u.beans.RakeShiftDetailsExcelImport;
import t4u.common.ApplicationListener;
import t4u.functions.RakeShiftingFunctions;


public class RakeShiftBookingAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = request.getSession(); 
		String param = "";
		int systemid = 0;
		int offset = 0;
		int ClientId=0;
		String Offset = "";
		
		int userid = 0;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		RakeShiftingFunctions rakeShiftFunc = new RakeShiftingFunctions();
			if(loginInfo!=null)
			{
			ClientId = loginInfo.getCustomerId();
			systemid = loginInfo.getSystemId();
			userid = loginInfo.getUserId();
			offset = loginInfo.getOffsetMinutes();
			Offset = Offset + offset;
			}		  
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		if (param.equals("saveRakeShiftBooking")) {
			String datajson = request.getParameter("datajson");
			String bookingType = request.getParameter("bookingType");
			String Branch= request.getParameter("Branch");
			String message = "";
			try {
				message = rakeShiftFunc.addRakeShiftBookingDetails(datajson,systemid, ClientId, userid, bookingType,Branch);
				response.getWriter().print(message);
			} catch (IOException e) {
				e.printStackTrace();
			}

		} else if (param.equalsIgnoreCase("viewBooking")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String bookingType = request.getParameter("bookingType");
				String Branch= request.getParameter("Branch");
				if (bookingType != null && !bookingType.isEmpty()&& Branch!=null && !Branch.isEmpty()) {
					jsonArray = rakeShiftFunc.getBookingDetails(bookingType, systemid, ClientId,Branch);
					if (jsonArray.length() > 0) {
						jsonObject.put("bookingDetailsroot", jsonArray);
					} else {
						jsonObject.put("bookingDetailsroot", "");
					}
				} else {
					jsonObject.put("bookingDetailsroot", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equals("getLocation")) {
			try {	            	    		
				jsonObject = new JSONObject();
//				ClientId=Integer.parseInt(request.getParameter("ClientId"));
    			jsonArray =rakeShiftFunc.getLocation(systemid, ClientId);

				if(jsonArray.length()>0)
				{
				jsonObject.put("locationStoreRoot", jsonArray);
				}
	    		else 
	    		{
					jsonObject.put("locationStoreRoot", "");				}
	  		
				response.getWriter().print(jsonObject.toString());
				} 
			catch (Exception e) {
			e.printStackTrace();
			}
		}
		else if (param.equals("getBranchList")) {
			try {	            	    		
				jsonObject = new JSONObject();
    			jsonArray =rakeShiftFunc.getBranchList(systemid, ClientId);
				if(jsonArray.length()>0)
				{
				jsonObject.put("BranchRoot", jsonArray);
				}
	    		else 
	    		{
					jsonObject.put("BranchRoot", "");				}
	  		
				response.getWriter().print(jsonObject.toString());
				} 
				catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("getBillingCustomer")) {
			try {
				jsonObject = new JSONObject();
				jsonArray = rakeShiftFunc.getBillingCustomer(systemid, ClientId, userid);
				if (jsonArray.length() > 0) {
					jsonObject.put("billingCustomerStoreRoot", jsonArray);
				} else {
					jsonObject.put("billingCustomerStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equals("saveContainerInformation")) {
			String completejsonData = request.getParameter("completejsonData");
			String datajson = request.getParameter("jsonData");
			String bookingId = request.getParameter("bookingId");
			String bookingType = request.getParameter("bookingType");
			
			String message = "";
			try {
				message = rakeShiftFunc.addModifyContainerDetails(completejsonData,datajson,systemid, ClientId, userid, bookingId, bookingType);
				response.getWriter().print(message);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getContainerData")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String bookingId = request.getParameter("bookingId");
					jsonArray = rakeShiftFunc.getContainerDetails(bookingId, systemid, ClientId);
					if (jsonArray.length() > 0) {
						jsonObject.put("ContainerInfoRoot", jsonArray);
					} else {
						jsonObject.put("ContainerInfoRoot", "");
					}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if (param.equalsIgnoreCase("getApprovalData")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				String Branch= request.getParameter("Branch");
					jsonArray = rakeShiftFunc.getApproveDetails( systemid, ClientId,Branch);
					if (jsonArray.length() > 0) {
						jsonObject.put("ApprovalRoot", jsonArray);
					} else {
						jsonObject.put("ApprovalRoot", "");
					}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		
		else if (param.equals("approveOrCancleDetails")) {
			String datajson = request.getParameter("jsonData");
			String buttonValue = request.getParameter("buttonValue");
			String message = "";
			String status="";
			try {
				if(buttonValue.equalsIgnoreCase("Approve")){
					status = "Approved";
				}else{
					status = "Cancelled";
				}
				message = rakeShiftFunc.approveContainerDetails(datajson,systemid, ClientId, userid,status);
				response.getWriter().print(message);
			} catch (IOException e) {
				e.printStackTrace();
			}

		}
		//---------------allocate fuel----------------------
		else if (param.equals("getVendorNames")) 
		{
			//String clientFromJsp = request.getParameter("clientId");

			try 
			{
				JSONArray list = new JSONArray();
				JSONObject rslt = new JSONObject();

				list = rakeShiftFunc.getVendorDetailsForAllocateFuel(systemid, ClientId);
				rslt.put("vendornames", list);
				response.getWriter().print(rslt.toString());

			} 
			catch (Exception e) 
			{
				System.out.println("Error in getvendorNameForGridInAction.."+ e);
			}

		}
		else if (param.equals("getActiveVendorNames")) 
		{
			String clientFromJsp = request.getParameter("clientId");

			try 
			{
				JSONArray list = new JSONArray();
				JSONObject rslt = new JSONObject();

				list = rakeShiftFunc.getActiveVendorDetailsForAllocateFuel(systemid, ClientId);
				rslt.put("vendornames", list);
				response.getWriter().print(rslt.toString());

			} 
			catch (Exception e) 
			{
				System.out.println("Error in getvendorNameForGridInAction.."+ e);
			}

		}else if(param.equals("getActiveBillingCustomer")){
			try{
				jsonObject = new JSONObject();
				jsonArray = rakeShiftFunc.getActiveBillingCustStore(systemid,ClientId);	
				jsonObject.put("BillingCustStoreRoot", jsonArray);
				response.getWriter().print(jsonObject.toString());
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		else if(param.equals("openStandardFileFormat")){
			try{
				String bookingType = request.getParameter("bookingType");
				File stdFile;
				String filename;
				Properties properties = ApplicationListener.prop;
				String path=properties.getProperty("TempFileDownloadPath").trim()+"/";
				
				if(bookingType.equals("1"))
				{
					stdFile = new File(path + "RakeShiftStandardFormate.xls");
					filename = "RakeShiftContainerInfo";
					response.setContentType("application/xls");	
					response.setHeader("Content-disposition","attachment;filename="+filename+".xls");
					FileInputStream fis = new FileInputStream(stdFile);
					ServletOutputStream servletOutputStream = response.getOutputStream();
					DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);
					byte [] buffer = new byte [1024];
					int len = 0;
					while ( (len = fis.read(buffer)) >= 0 ) 
					{
						outputStream.write(buffer, 0, len);
					}
					outputStream.flush();
					outputStream.close();
				}
				else if(bookingType.equals("2"))
				{
					stdFile = new File(path + "RakeShiftStandardFormateForShift.xls");
					filename = "RakeShiftContainerInfoShift";
					response.setContentType("application/xls");	
					response.setHeader("Content-disposition","attachment;filename="+filename+".xls");
					FileInputStream fis = new FileInputStream(stdFile);
					ServletOutputStream servletOutputStream = response.getOutputStream();
					DataOutputStream outputStream = new	DataOutputStream(servletOutputStream);
					byte [] buffer = new byte [1024];
					int len = 0;
					while ( (len = fis.read(buffer)) >= 0 ) 
					{
						outputStream.write(buffer, 0, len);
					}
					outputStream.flush();
					outputStream.close();
				}
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		if (param.equalsIgnoreCase("importRakeShiftDetailsExcel")) {

			String importMessage = "";
			String bookingType = request.getParameter("bookingType");
			try {
				String message = "";
				String fileName = null;
				int clientIdInt = 0;
				boolean isMultipart = ServletFileUpload.isMultipartContent(request);
				if (isMultipart) {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					String path = properties.getProperty("TempFileDownloadPath").trim()+ "//";
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
										+ "ILMSDetailsImportData-" + systemid
										+ userid + fileExtension;
								uploadedFile = new File(excelPath);

								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							RakeShiftDetailsExcelImport rake = new RakeShiftDetailsExcelImport(
									uploadedFile, userid, systemid,
									ClientId, offset, fileExtension);
							

							importMessage = rake.importExcelData(bookingType);
							message = rake.getMessage();
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
		else if (param.equalsIgnoreCase("getImportILMSDetails")) {

			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String fuelImportResponse = request.getParameter("ilmsImportResponse");
				if (fuelImportResponse.equals("{success:true}")) {
					jsonArray = RakeShiftDetailsExcelImport.globalJsonArray;
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("RakeShiftDetailsImportRoot", jsonArray);
				} else {
					jsonObject.put("RakeShiftDetailsImportRoot", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equalsIgnoreCase("saveImportIlmsDetails")){
			String messages = "";
			String saveUnitData = request.getParameter("ilmsDataSaveParam");
			String bookingId=request.getParameter("bookingId");
			String bookingType = request.getParameter("bookingType");
			try {
				if (saveUnitData != null && !saveUnitData.equals("")) {
					JSONArray fuelJs = null;
					try {
						fuelJs = new JSONArray(saveUnitData.toString());
						
							messages = rakeShiftFunc.saveImportedILMSDetails(systemid,ClientId,bookingId,userid,RakeShiftDetailsExcelImport.rake_shiftImportedDetails,bookingType);
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					messages = "No Data To Save";
				}
				response.getWriter().print(messages);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}

}
