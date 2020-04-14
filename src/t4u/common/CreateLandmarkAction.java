package t4u.common;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.DecimalFormat;
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
import t4u.functions.CommonFunctions;
import t4u.functions.CreateLandmarkFunctions;
import t4u.functions.ExtractKML;

public class CreateLandmarkAction extends Action {
	
	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response) {
		HttpSession session = ((HttpServletRequest) request).getSession();
		LoginInfoBean logininfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");	
		CreateLandmarkFunctions createLandmarkFunctions = new CreateLandmarkFunctions();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		CommonFunctions cf = new CommonFunctions();
		String param = "";		
		
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		int ltsp = 2;
		int customerid = 0;
		int ClientId = 0;
		int systemid = 0;
		int offset = 0;
		String Offset="";
		int userid = 0;
		String zone = "";
		int  isLtsp=0;
		JSONArray jsonArray = new JSONArray();
		JSONObject jsonObject = new JSONObject();
		if(logininfo!=null){
			customerid = logininfo.getCustomerId();
			ltsp = logininfo.getIsLtsp();
			ClientId = logininfo.getCustomerId();
			systemid = logininfo.getSystemId();
			userid = logininfo.getUserId();
			offset = logininfo.getOffsetMinutes();	
			
			Offset=Offset+offset;
			zone = logininfo.getZone();
			isLtsp=logininfo.getIsLtsp();
		}
		
		if (param.equalsIgnoreCase("getGeoFenceType")) {
			try {
				jsonArray = createLandmarkFunctions.getGeoFenceTypes();
				if (jsonArray.length() > 0) {
					jsonObject.put("geofenceRoot", jsonArray);
				} else {
					jsonObject.put("geofenceRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if(param.equalsIgnoreCase("saveLocation"))
		{
			double converfactor= cf.getUnitOfMeasureConvertionsfactor(systemid);
			try {
				String location = "";
				String Type = "";
				String clientid = "";
				String radius = "";
				String latitude = "";
				String longitude = "";
				String image = "";
				String GMT = "";
				String stdDuration = "";
				String isModify = "";
				String message  = "";
				String city  = "";
				String state  = "";
				String country  = "";
				String hubId = "";
				String id = "";
				String region="";
				//String area="";
				String tripCustomerId="0";
				String contactPerson="";
				String address="";
				String description="";
				//String subRegion="";
				double newradius =0.0;
				String district="";
				DecimalFormat df=new DecimalFormat("#.##");
				if (request.getParameter("locationName") != null) 
				{
					location = request.getParameter("locationName");
				}
				if (request.getParameter("geofenceType") != null) 
				{
					Type = request.getParameter("geofenceType");
				}
				if (request.getParameter("CustID") != null) 
				{
					clientid = request.getParameter("CustID");
				}
				if (request.getParameter("radius") != null) 
				{
					radius = request.getParameter("radius");
					if(!radius.equalsIgnoreCase("-1")){
						newradius = (Double.parseDouble(radius)/converfactor);
						radius=df.format(newradius);
					}
				}
				if (request.getParameter("latitude") != null) 
				{
					latitude = request.getParameter("latitude");
				}
				if (request.getParameter("longitude") != null) 
				{
					longitude = request.getParameter("longitude");
				}
				if (request.getParameter("gmt") != null) 
				{
					GMT = request.getParameter("gmt");
				}
				if (request.getParameter("standardDuration") != null) 
				{
					stdDuration = request.getParameter("standardDuration");
				}
				if (request.getParameter("hubId") != null) 
				{
					hubId = request.getParameter("hubId");
				}
				if (request.getParameter("id") != null) 
				{
					id = request.getParameter("id");
				}
				if (request.getParameter("region") != null) 
				{
					region = request.getParameter("region");
				}
				/*if(request.getParameter("area") != null)
				{
					area = request.getParameter("area");
				}*/
				if (request.getParameter("tripCustomerId") != null) 
				{
					tripCustomerId = request.getParameter("tripCustomerId");
				}
				if (request.getParameter("contactPerson") != null) 
				{
					contactPerson = request.getParameter("contactPerson");
				}
				if (request.getParameter("address") != null) 
				{
					address = request.getParameter("address");
				}
				if (request.getParameter("desc") != null) 
				{
					description = request.getParameter("desc");
				}
				if (request.getParameter("city") != null) 
				{
					city = request.getParameter("city");
				}
				if (request.getParameter("state") != null) 
				{
					state = request.getParameter("state");
				}
				/*if(request.getParameter("subRegion")!=null)
				{
					subRegion=request.getParameter("subRegion");
				}*/
				if (request.getParameter("district") != null) 
				{
					district = request.getParameter("district");
				}
				String checkBoxValue=request.getParameter("checkBoxValue");
				isModify = request.getParameter("isModify");
				String pageName=request.getParameter("pageName");
				String pincode = request.getParameter("pincode");
				//System.out.println("Pin ::" + pincode);
				if (isModify.equalsIgnoreCase("true")) {
					message = createLandmarkFunctions
							.updateModifiedLandmarkDetails(location, Type,
									radius, latitude, longitude, GMT, systemid,
									Integer.parseInt(clientid), stdDuration,
									id, hubId,pageName,sessionId,serverName,userid,
									region, contactPerson, address, description,city,state,pincode,district);
					
					//createLandmarkFunctions.updateLegAndRouteOfHub(hubId, customerid, systemid, sessionId, userid, serverName);
				} else {
					message = createLandmarkFunctions.saveLocationBuffer(
							location, Type, clientid, radius, latitude,
							longitude, image, GMT, String.valueOf(systemid),
							stdDuration,pageName,sessionId,serverName,userid,
							checkBoxValue,ClientId,isLtsp,region, tripCustomerId,
							contactPerson, address,description,city,state,pincode,district);
				}
				String[] messageArr = message.split("##");
				response.getWriter().print(messageArr[0]);
			} catch (Exception e) {
				e.printStackTrace();
			}
	}else if (param.equals("importExcel")) {
			String importMessage = "";
			String message = "";
			String clientIdFromJsp = request.getParameter("clientId");
			if (clientIdFromJsp != null && !clientIdFromJsp.equals("")) {
				ClientId = Integer.parseInt(clientIdFromJsp);
				// System.out.println("clientIdFromJsp "+clientId);
			}
			String fileName = null;
			String fileExtension = "";
			boolean isMultipart = ServletFileUpload.isMultipartContent(request);
			if (isMultipart) {
				// System.out.println("IsMultiPart");
				try {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					// System.out.println(items.toString());
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
					while (iter.hasNext()) {
						FileItem item = (FileItem) iter.next();
						if (!item.isFormField()) {
							File uploadedFile = null;
							File f = null;
							if (item.getName() != "") {
								fileName = item.getName();
								fileExtension = fileName.substring(fileName.lastIndexOf("."), fileName.length());
								String excelPath = path+ "LocationImportDetails-" + systemid+ ClientId + fileExtension;
								uploadedFile = new File(excelPath);
								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
							}
							CreateLandmarkExcelImport cle = new CreateLandmarkExcelImport(uploadedFile, userid, systemid, ClientId, fileExtension);
							importMessage = cle.importExcelData();
							message = cle.getMessage();
						} else {
							System.out.println("Request Does Not Support Multipart");
						}
						if (importMessage.equals("Success")) {
							response.getWriter().print("{success:true}");
						} else {
							response.getWriter().print("{success:false}");
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			

		}else if (param.equalsIgnoreCase("getImportLocationDetails")) {
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();

				String locationImportResponse = request.getParameter("LocationImportResponse");
				if (locationImportResponse.equals("{success:true}")) {
					jsonArray = CreateLandmarkExcelImport.globalJsonArray;
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("LocationDetailsImportRoot", jsonArray);
				} else {
					jsonObject.put("LocationDetailsImportRoot", "");
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equalsIgnoreCase("saveImportLocationDetails")){
			String clientIdFromJsp= request.getParameter("clientId");
        	if(clientIdFromJsp != null && !clientIdFromJsp.equals("")){
        		ClientId = Integer.parseInt(clientIdFromJsp);String messages = "";
			JSONArray fuelJs = null;
			CreateLandmarkFunctions clFun=new CreateLandmarkFunctions();
			String saveLocationData = request.getParameter("locationDataSaveParam");
			try {
				if (saveLocationData != null && !saveLocationData.equals("")) {
					try {
						fuelJs = new JSONArray(saveLocationData.toString());
							messages = clFun.saveLocationDetails(systemid, ClientId, CreateLandmarkExcelImport.dataMap.get("Valid"));
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else {
					messages = "No Fuel Data To Save";
				}
				response.getWriter().print(messages);
			} catch (Exception e) {
				e.printStackTrace();
			}
        	}
		}else if(param.equalsIgnoreCase("openStandardFileFormat")){
		try{
			File stdFile;
			String filename;
			Properties properties = ApplicationListener.prop;
			String path=properties.getProperty("TempFileDownloadPath").trim()+"/";
			stdFile = new File(path + "standardLocationDetailsExcelFormat.xls");
			filename = "standardLocationDetailsExcelFormat";
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
		}catch(Exception e){
			e.printStackTrace();
		}
		}else if(param.equalsIgnoreCase("saveRouteHub"))
		   {
			try 
			{
				String location = "";
				float radius = 0;
				int clientid = 0;
				double speedLimit = 0;
				String latitude = "";
				String longitude = "";
				int checked=0;
				int routeId=0;
				
				if (request.getParameter("locationName") != null) 
				{
					location = request.getParameter("locationName");
				}
				if (request.getParameter("radius") != null) 
				{
					radius = Float.parseFloat(request.getParameter("radius"));
				}
				if (request.getParameter("CustID") != null) 
				{
					clientid = Integer.parseInt(request.getParameter("CustID"));
				}
				if (request.getParameter("speedLimit") != null) 
				{
					speedLimit = Double.parseDouble(request.getParameter("speedLimit"));
				}
				if (request.getParameter("latitude") != null) 
				{
					latitude = request.getParameter("latitude");
				}
				if (request.getParameter("longitude") != null) 
				{
					longitude = request.getParameter("longitude");
				}
				if (request.getParameter("checked") != null) 
				{
					checked = Integer.parseInt(request.getParameter("checked"));
				}
				if (request.getParameter("routeId") != null && !request.getParameter("routeId").equals("")) 
				{
					routeId = Integer.parseInt(request.getParameter("routeId"));
				}
				String status=request.getParameter("status");
				String message="";
				if(checked==1){
					message = createLandmarkFunctions.saveRouteHubLocation(location,radius,clientid,speedLimit,systemid,latitude,longitude,status);
				}else if(checked==2){
					message = createLandmarkFunctions.modifyRouteHubLocation(location,radius,clientid,speedLimit,systemid,status,routeId);
				}
				
				response.getWriter().print(message);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		 
		if (param.equals("getModifyData")) {
			String custId = request.getParameter("custId");
			String hubId = request.getParameter("hubId");
			try {
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (Integer.parseInt(custId) != 0) {
					ArrayList finlist = (ArrayList) createLandmarkFunctions
							.getLocationByHubId(Integer.parseInt(hubId),systemid);
					jsonArray = (JSONArray) finlist.get(0);
					jsonObject.put("NewGridRoot", jsonArray);
				} else {
					jsonObject.put("NewGridRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equalsIgnoreCase("getPolygon")) {
			try {
				String hubId = request.getParameter("hubId");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = createLandmarkFunctions.getPolygonCoordinates(
						hubId, systemid);
				if (jsonArray.length() > 0) {
					jsonObject.put("PolygonModify", jsonArray);
				} else {
					jsonObject.put("PolygonModify", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equalsIgnoreCase("getBufferMapView")) {
			try {
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = createLandmarkFunctions.getMapViewBuffers(ClientId,systemid);
				if (jsonArray.length() > 0) {
					jsonObject.put("BufferMapView", jsonArray);
				} else {
					jsonObject.put("BufferMapView", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		if (param.equalsIgnoreCase("getPolygonMapView")) {
			try {
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = createLandmarkFunctions.getMapViewPolygons(ClientId,systemid);
				if (jsonArray.length() > 0) {
					jsonObject.put("PolygonMapView", jsonArray);
				} else {
					jsonObject.put("PolygonMapView", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		if (param.equalsIgnoreCase("getLocation")) {
			try {
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = createLandmarkFunctions.getLocation(ClientId,systemid);
				if (jsonArray.length() > 0) {
					jsonObject.put("locationRoot", jsonArray);
				} else {
					jsonObject.put("locationRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {

			}
		}
		
		else if (param.equalsIgnoreCase("getPolygonData")) {
			try {
				String hubId = request.getParameter("hubId");
				System.out.println(hubId);
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = createLandmarkFunctions.getPolygonCoordinatesForRouteMap(
						hubId, systemid);
				if (jsonArray.length() > 0) {
					jsonObject.put("polyRoot", jsonArray);
				} else {
					jsonObject.put("polyRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equals("getTripCustomer")){
			try {
				String clientIdSelected=request.getParameter("CustId");
				jsonObject = new JSONObject();
				ClientId = (clientIdSelected != null && clientIdSelected !="0") ? Integer.parseInt(clientIdSelected) :ClientId;
				//if (clientIdSelected != null && !clientIdSelected.equals("")) {
					jsonArray = createLandmarkFunctions.getTripCustomer(ClientId, systemid);
					jsonObject.put("TripCustomerRoot", jsonArray);
			//	} else {
					//jsonObject.put("TripCustomerRoot", "");
				//}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
			
		}
		else if(param.equalsIgnoreCase("checkHubInLegDetails"))
		{
			try {
				String hubId="";
				String message="";
				if (request.getParameter("hubId") != null) 
				{
					hubId = request.getParameter("hubId");
				}
					message = createLandmarkFunctions
							.checkHubInLegDetails(hubId);
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
			}
	}
		if (param.equalsIgnoreCase("getArea")) {
			try {
				String regionName = request.getParameter("regionName");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = createLandmarkFunctions.getArea(regionName);
				if (jsonArray.length() > 0) {
					jsonObject.put("areaStoreRoot", jsonArray);
				} else {
					jsonObject.put("areaStoreRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		if (param.equalsIgnoreCase("isHubNameExists")) {
			try {
				String tripCustId = request.getParameter("tripCustId");
				//System.out.println(hubId);
				if(tripCustId == null || tripCustId ==""){
					tripCustId = "-1";
				}
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = createLandmarkFunctions.isHubNameExist(
						 systemid,ClientId,Integer.parseInt(tripCustId));
				//System.out.println(jsonArray);
				if (jsonArray.length() > 0) {
					jsonObject.put("hubNameExistRoot", jsonArray);
				} else {
					jsonObject.put("hubNameExistRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		else if(param.equalsIgnoreCase("getLegAssociatedHubs"))
		{
			try {
				String message="";
				String hubs = request.getParameter("hubs");
				message = createLandmarkFunctions
							.getLegAssociatedHubs(systemid,hubs);
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		/*
		 * This will upload the file to a temp location on the server and extract Co ordinates from
		 * the file.
		 */
		else if (param.equals("importKML")) {
			
			boolean isKMLMultipart = ServletFileUpload.isMultipartContent(request);
			if (isKMLMultipart) {
				// System.out.println("IsMultiPart");
				try {
					FileItemFactory factory = new DiskFileItemFactory();
					ServletFileUpload upload = new ServletFileUpload(factory);
					List items = upload.parseRequest(request);
					// System.out.println(items.toString());
					Iterator iter = items.iterator();
					Properties properties = ApplicationListener.prop;
					String path = properties.getProperty("TempFileDownloadPath").trim()+ "/";
					String filePath=null;
					while (iter.hasNext()) {
						FileItem item = (FileItem) iter.next();
						if (!item.isFormField()) {
							File uploadedFile = null;
							File f = null;
							if (item.getName() != "") {
								String fileName = item.getName();
								filePath = path+ "temp.kml";
								uploadedFile = new File(filePath);
								f = new File(path);
								if (!f.exists()) {
									f.mkdirs();
								}
								item.write(uploadedFile);
								ExtractKML.extractKML(filePath);
								response.getWriter().print("{success:true}");
							}
						} else {
							System.out.println("Request Does Not Support Multipart");
						}
						
					}
					
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		 }
		/*
		 * This will load the Co ordinates into a JSONArray and be sent back
		 * as a response
		 */
          else if (param.equals("loadKML")) {
 	           
        	    JSONArray kmlArray=ExtractKML.globalJsonArray;
				try {
					JSONObject jObj = new JSONObject();
					jObj.put("kmlArray", kmlArray.toString());
					response.getWriter().print(jObj.toString());
					
				} catch (Exception e) {
					e.printStackTrace();
				}
		 }
		return null;
	}
}

