package t4u.cashvanmanagement;

import java.io.File;
import java.io.IOException;

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

import t4u.common.ApplicationListener;
import t4u.functions.CashVanManagementFunctions;



public class QuotationAction  extends Action {


public ActionForward execute(ActionMapping mapping,ActionForm form, HttpServletRequest request, HttpServletResponse response){
		
		HttpSession session = request.getSession();
	    String param = "";
	    int systemId = 0;
	    int userId = 0;
	    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	    systemId = loginInfo.getSystemId();
	    userId = loginInfo.getUserId();
	    
	    int CountryCode = loginInfo.getCountryCode();
	    CashVanManagementFunctions cashVanfunc = new CashVanManagementFunctions();
	    JSONArray jsonArray = null;
	    if (request.getParameter("param") != null) {
	        param = request.getParameter("param").toString();
	    }
if(request.getParameter("param").equals("location")){
	 try {
 jsonArray=cashVanfunc.getLocationByCountryCode(CountryCode);
 if(jsonArray !=null && jsonArray.length()>0){

	response.getWriter().print(jsonArray.toString());
 }else{
	 response.getWriter().print("");
 }
} catch (IOException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}

}
else if (param.equalsIgnoreCase("updateQuotation")) {

	String buttonValue = request.getParameter("buttonValue");
	String quotationNo = request.getParameter("quotationNo");
	String validFrom = request.getParameter("validFrom");
	String validTo = request.getParameter("validTo");
	String location = request.getParameter("location");
	String quoteFor = request.getParameter("quoteFor");
	String customer = request.getParameter("customer");
	String quotationCustId = request.getParameter("quotationCustId");
	String tariffType = request.getParameter("tariffType");
	String tariffAmt = request.getParameter("tariffAmt");
	//String CustId = request.getParameter("CustId");
	String systemQuoteNo =request.getParameter("systemQuoteNo");

	try {
		
		String str ="";				
			if(buttonValue.equalsIgnoreCase("Modify")){

	str=cashVanfunc.updateQuote(systemQuoteNo,quotationNo, validFrom, validTo, location, quoteFor, customer, tariffType, tariffAmt,userId,Integer.parseInt(quotationCustId));
	
	   
	   if (str.equals("Success")) {
			response.getWriter().print("{success:true}");

		}else {
			response.getWriter().print("{success:false}");
		}
			}else {
				response.getWriter().print("{success:false}");
			}
}catch(Exception e){
	e.printStackTrace();
}
}

else if (param.equalsIgnoreCase("fileUpload")) {

	String uploadMessage = "";
	String DestinationPath = "";
	String DestinationPath2 = "";
	String buttonValue = request.getParameter("buttonValue");
	String quotationNo = request.getParameter("quotationNo");
	String validFrom = request.getParameter("validFrom");
	String validTo = request.getParameter("validTo");
	String location = request.getParameter("location");
	String quoteFor = request.getParameter("quoteFor");
	String customer = request.getParameter("customer");
	String quotationCustId = request.getParameter("quotationCustId");
	String tariffType = request.getParameter("tariffType");
	String uploadedFile2 = request.getParameter("uploadedFile");
	String tariffAmt = request.getParameter("tariffAmt");
	String CustId = request.getParameter("CustId");
	String systemQuoteNo =request.getParameter("systemQuoteNo");
	
	try {
		
	String str ="";	
	boolean bool=false;
	 if(buttonValue.equalsIgnoreCase("Modify")){
		 bool=ServletFileUpload.isMultipartContent(request);
		   str=cashVanfunc.updateQuote(systemQuoteNo,quotationNo, validFrom, validTo, location, quoteFor, customer, tariffType, tariffAmt,userId,Integer.parseInt(quotationCustId));
		   str=str+"-"+systemQuoteNo;
			if(str.contains("Success")){
				String	systemQuoteNos [] = str.split("-");
				systemQuoteNo = systemQuoteNos[1];
				str = systemQuoteNos[0];
				}
}
	
	 else if(buttonValue.equalsIgnoreCase("Add") ){
		 bool=ServletFileUpload.isMultipartContent(request);
		str=cashVanfunc.saveQuote(quotationNo, validFrom, validTo, location, quoteFor, customer, tariffType, uploadedFile2, tariffAmt,userId,systemId,Integer.parseInt(CustId),Integer.parseInt(quotationCustId));
		if(str.contains("Success")){
			String	systemQuoteNos [] = str.split("-");
			systemQuoteNo = systemQuoteNos[1];
			str = systemQuoteNos[0];
			if( !bool){
			response.getWriter().print("{success:true}");
			return null;
			}
			}
	
	}

		
		
				
			
			if(str.equalsIgnoreCase("Success") && !systemQuoteNo.equals("0")){
				
				String fileName = null;
				
				boolean isMultipart = ServletFileUpload.isMultipartContent(request);
				if (isMultipart) {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					
					String path = properties.getProperty("DocumentUploadPathForQuotation").trim();
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

								fileNameExcludeExtension = fileNameExcludeExtension+"-"+quotationNo+"_"+systemQuoteNo;
								String fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());
								DestinationPath = path + fileNameExcludeExtension + fileExtension;
								uploadedFile = new File(DestinationPath);
								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								
								 if(buttonValue.equalsIgnoreCase("Modify")){
										
										DestinationPath2 = cashVanfunc.getFilePathFromDB(systemId, Integer.parseInt(CustId), Integer.parseInt(systemQuoteNo));
									
										//DestinationPath2 = DestinationPath2.substring(30, DestinationPath2.length());
										if(DestinationPath2==null || DestinationPath2.equals("")){
											DestinationPath2=DestinationPath;
										}else{
										DestinationPath2 = DestinationPath2.substring(DestinationPath2.lastIndexOf("//"), DestinationPath2.length());		
										}
										DestinationPath2 = DestinationPath2.substring(2);
										
										String excelpath = properties.getProperty("DocumentDownloadPathForQuotation").trim();
									    
										DestinationPath2 = excelpath+DestinationPath2;
												File oldFileName = new File(DestinationPath2);
												if (oldFileName.exists()) {
												   oldFileName.delete();
												}
										
									 }
								
								item.write(uploadedFile);
							

								uploadMessage = "Success";
							}
						}
					}
				}
				if (uploadMessage.equals("Success")) {
					int update = cashVanfunc.updateFilepathInDB(DestinationPath,systemId,Integer.parseInt(CustId),Integer.parseInt(systemQuoteNo));
					if(update>0){
					response.getWriter().print("{success:true}");
				} else {
					response.getWriter().print("{success:false}");
				}
				}else {
					response.getWriter().print("{success:false}");
				}
			}else{
				response.getWriter().print("{success:false}");	
			}
			
	
	
		
	} catch (Exception e) {
		e.printStackTrace();
	}
}




else if(request.getParameter("param").equals("getData")){
	String customerId = request.getParameter("CustId");
	 JSONArray JsonArray = new JSONArray();
	 JSONObject jsonobj=new JSONObject();

	try{
		if(customerId!=null&& !customerId.equals("")){
			JsonArray=cashVanfunc.getQuotes(Integer.parseInt(customerId),systemId);
		}
	 
	 if(JsonArray !=null && JsonArray.length()>0){
		//System.out.println(JsonArray);
		 jsonobj.put("quotationMasterRoot", JsonArray);
		
		 response.getWriter().print(jsonobj.toString());
		 }else{
			 jsonobj.put("quotationMasterRoot", "");
			 response.getWriter().print(jsonobj.toString());
		 }
	}catch(Exception e){
		e.printStackTrace();
	}
}

else if(request.getParameter("param").equals("getRevisionData")){
	String customerId = request.getParameter("CustId");
	String sysQuotationId =      request.getParameter("QuotationId");
	 JSONArray JsonArray = new JSONArray();
	 JSONObject jsonobj=new JSONObject();

	try{
		if(customerId!=null&& !customerId.equals("")){
			JsonArray=cashVanfunc.getRevisionQuotes(Integer.parseInt(customerId),systemId,Integer.parseInt(sysQuotationId));
		}
	 
	 if(JsonArray !=null && JsonArray.length()>0){
		//System.out.println(JsonArray);
		 jsonobj.put("quotationRevisionMasterRoot", JsonArray);
		
		 response.getWriter().print(jsonobj.toString());
		 }else{
			 jsonobj.put("quotationRevisionMasterRoot", "");
			 response.getWriter().print(jsonobj.toString());
		 }
	}catch(Exception e){
		e.printStackTrace();
	}
}

	return null;
}

}
