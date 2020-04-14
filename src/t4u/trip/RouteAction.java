package t4u.trip;

import java.sql.Connection;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.LinkedList;
import java.util.List;
import java.util.Properties;
import java.util.regex.Pattern;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.json.JSONArray;
import org.json.JSONObject;

import com.t4u.activity.VehicleActivity;
import com.t4u.activity.VehicleActivity.DataListBean;

import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.functions.CommonFunctions;
import t4u.functions.RMCFunctions;
import t4u.functions.TripFunction;

public class RouteAction extends Action {
TripFunction tripfunc=new TripFunction();
@SuppressWarnings("unchecked")
public ActionForward execute(ActionMapping mapping, ActionForm form,
				HttpServletRequest request, HttpServletResponse response)
				throws Exception {		
				HttpSession session = request.getSession();
				JSONArray jsonArray = new JSONArray();
				JSONObject jsonObject = new JSONObject();
				LoginInfoBean loginInfo =(LoginInfoBean)session.getAttribute("loginInfoDetails");
				int systemId = loginInfo.getSystemId();
				int customerId = loginInfo.getCustomerId();
				int userId = loginInfo.getUserId();
				int offmin = loginInfo.getOffsetMinutes();
				String param = request.getParameter("param");
				
				
				if (param.equals("getRouteNames")) {
					try {
						String customerIDHistory = request.getParameter("clId");
						String clientNameHistory = request.getParameter("Cid");
						int customerID =0;
						String clientIdSelected ="";
						if(!clientNameHistory.equals(""))
						{
							if(!request.getParameter("clId").equals("") && request.getParameter("clId") !=null)
							{
								clientIdSelected = request.getParameter("clId");
							}else
							{
							clientIdSelected = request.getParameter("CustId");
							}
						} else {
							clientIdSelected = request.getParameter("CustId");
						}
						jsonObject = new JSONObject();
						if (clientIdSelected != null && !clientIdSelected.equals("")) {
							jsonArray = tripfunc.getRoutenames(Integer.parseInt(clientIdSelected), systemId);
							jsonObject.put("RouteNameRoot", jsonArray);
						} else {
							jsonObject.put("RouteNameRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				
				else if(param.equals("getRouteCreation"))
				{
					try {
						String s = request.getParameter("routeValue");
						String customerIDHistory = request.getParameter("clId");
						String clientNameHistory = request.getParameter("Cid");
						String routeName=request.getParameter("routeName");
						int customerID =0;
						String routeNameReverse[] = routeName.split("-");
						String routeReverse="";
						String routeArrayReverse = "";
						int j=1;
						for (int i=(routeNameReverse.length-1);i>=0;i--)
						{
							if(i!=0)
							{
							routeReverse += routeNameReverse[i]+"-";
							} else {
							routeReverse += routeNameReverse[i];
							}
						}
						if(customerIDHistory !=null && !customerIDHistory.equals(""))
						{
							 customerID = Integer.parseInt(request.getParameter("clId"));
						} else {
							 customerID = Integer.parseInt(request.getParameter("CustID"));
						}
						s = s.substring(1,s.length()-2);
						String[] routeArray = s.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
						for(int i=(routeArray.length-1);i>=0;i--)
						{
							String routeArrayRev="";
							routeArrayRev = routeArray[i];
							routeArrayRev = routeArrayRev.replaceFirst((routeArrayRev.substring(1, routeArrayRev.indexOf(","))), ""+j);
							routeArrayReverse+=routeArrayRev+"-,";
							j++;
						}
						String routeArrayReverse1[]=routeArrayReverse.split("-,");
						String message=tripfunc.ceateRouteMaster(routeName, routeArray, systemId, customerID, routeArrayReverse1, routeReverse );
						response.getWriter().print(message);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				else if (param.equals("getRouteDetails")) {
					try {
						String customerIDHistory = request.getParameter("clId");
						String clientNameHistory = request.getParameter("Cid");
						int customerID =0;
						String clientIdSelected = "";
						if(!clientNameHistory.equals(""))
						{
							
							if(!request.getParameter("clId").equals("") && request.getParameter("clId") !=null)
							{
								clientIdSelected = request.getParameter("clId");
							}else
							{
							clientIdSelected = request.getParameter("CustId");
							}
						} else {
						    clientIdSelected = request.getParameter("CustId");
						}
						String routeId = request.getParameter("RouteId");
						jsonObject = new JSONObject();
						if (clientIdSelected != null && !clientIdSelected.equals("")) {
							jsonArray = tripfunc.getRouteDetails(Integer.parseInt(routeId),Integer.parseInt(clientIdSelected), systemId);
							jsonObject.put("RouteDetailsRoot", jsonArray);
						} else {
							jsonObject.put("RouteDetailsRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				
				else if (param.equals("updateRouteDetails")) {
					try {
						String s = request.getParameter("routeValue");
						String customerIDHistory = request.getParameter("clId");
						String clientNameHistory = request.getParameter("Cid");
						int customerID =0;
						if(!clientNameHistory.equals(""))
						{
							if(!request.getParameter("clId").equals("") && request.getParameter("clId") !=null)
							{
								customerID = Integer.parseInt(request.getParameter("clId"));
							}else
							{
								customerID = Integer.parseInt(request.getParameter("CustID"));
							}
							
						} else {
							 customerID = Integer.parseInt(request.getParameter("CustID"));
						}
						String routeId=request.getParameter("routeId");
						s = s.substring(1,s.length()-2);
						String[] routeArray = s.replaceAll("^[^{]*|[^}]*$", "").split("(?<=\\})[^{]*");
						String message=tripfunc.updateRouteMaster(Integer.parseInt(routeId), routeArray, systemId, customerID);
						response.getWriter().print(message);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

				else if (param.equals("getPlotRouteDetails")) {
					try {
						String reg = request.getParameter("reg");
						String startDate = request.getParameter("startDate");
						String startHour = request.getParameter("startHour");
						String StartMin = request.getParameter("StartMin");
						String endDate = request.getParameter("endDate");
						String EndHour = request.getParameter("EndHour");
						String EndMin = request.getParameter("EndMin");
						String timeBand = request.getParameter("timeBand");
						String clId = request.getParameter("clId");
						String sysId = request.getParameter("sysId");
						SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
						SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
						Connection con = null;
						
						con = DBConnection.getConnectionToDB("AMS");
						JSONArray jsonArray1 =null;
						
						int tBandValueInt=0;
						if(timeBand != null && !timeBand.equals("")){
							tBandValueInt = Integer.parseInt(timeBand);
						}
						
						String startDateTime=startDate+" "+startHour+":"+StartMin+":"+"00";
						startDateTime=getFormattedDateStartingFromMonth(startDateTime);
						startDateTime= getLocalDateTime(startDateTime, offmin);
							
							String endDateTime=endDate+" "+EndHour+":"+EndMin+":"+"00";
							endDateTime=getFormattedDateStartingFromMonth(endDateTime);
							endDateTime= getLocalDateTime(endDateTime, offmin);
							
							
						    LinkedList<DataListBean> HistoryAnalysis=new LinkedList<DataListBean>();
							
							VehicleActivity vi=new VehicleActivity(con, reg, sdfFormatDate.parse(startDateTime), sdfFormatDate.parse(endDateTime), offmin, Integer.parseInt(sysId), Integer.parseInt(clId), tBandValueInt);
							HistoryAnalysis=vi.getFinalList();
							
							try {
								jsonArray1= new JSONArray();
								int j=1;
								for(int i=0;i<HistoryAnalysis.size();i++){
									DataListBean dlb = HistoryAnalysis.get(i);
									double latitude =dlb.getLatitude();
									double longitude =dlb.getLongitude();
									jsonObject = new JSONObject();
									jsonObject.put("sequence", j++);
									jsonObject.put("lat", latitude);
									jsonObject.put("long", longitude);
									jsonArray1.put(jsonObject);
								}
								jsonObject = new JSONObject();
								if (jsonArray1.length() > 0) {
									jsonObject.put("PlotRouteDetailsRoot", jsonArray1);
								} else {
									jsonObject.put("PlotRouteDetailsRoot", "");
								}
								response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
					catch(Exception e){
						e.printStackTrace();
					}
				}
				else if (param.equals("deleteRoute")) {
					try {
						String s = request.getParameter("routeValue");
						String customerIDHistory = request.getParameter("clId");
						String clientNameHistory = request.getParameter("Cid");
						int customerID =0;
						if(!clientNameHistory.equals(""))
						{
							
							if(!request.getParameter("clId").equals("") && request.getParameter("clId") !=null)
							{
								customerID = Integer.parseInt(request.getParameter("clId"));
							}else
							{
								customerID = Integer.parseInt(request.getParameter("CustID"));
							}
							
						} else {
							 customerID = Integer.parseInt(request.getParameter("CustID"));
						}
						String routeId=request.getParameter("routeId");
						String message=tripfunc.deleteRoute(Integer.parseInt(routeId), systemId, customerID);
						System.out.println("action");
						response.getWriter().print(message);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				else if(param.equals("checkRoutesAssociatedWithVehicle")) {
					try {
						String routeId = request.getParameter("routeId");
						String message = tripfunc.checkRoutesAssociatedWithVehicle(Integer.parseInt(routeId));
						response.getWriter().print(message);
					}
					catch(Exception e) {
						e.printStackTrace();
					}
				}
				

				return null;
			}

public String getFormattedDateStartingFromMonth(String inputDate){
						 String formattedDate="";
						 SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
						 SimpleDateFormat sdfFormatDate = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
						 try{
							 if(inputDate!=null && !inputDate.equals("")){
							   java.util.Date d=sdf.parse(inputDate);
							   formattedDate=sdfFormatDate.format(d);
							 }
						 }
						 catch(Exception e)
						 {
							 System.out.println("Error in getFormattedDateStartingFromMonth() method"+e);
							 e.printStackTrace();
						 }
						 return formattedDate;
					 }

public String getLocalDateTime(String inputDate, int offSet) {
	String retValue = inputDate;
	Date convDate = null;
	convDate = convertStringToDate(inputDate);
	if (convDate != null) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(convDate);
		cal.add(Calendar.MINUTE, -offSet);

		int day = cal.get(Calendar.DATE);
		int y = cal.get(Calendar.YEAR);
		int m = cal.get(Calendar.MONTH) + 1;
		int h = cal.get(Calendar.HOUR_OF_DAY);
		int mi = cal.get(Calendar.MINUTE);
		int s = cal.get(Calendar.SECOND);

		String yyyy = String.valueOf(y);
		String month = String.valueOf(m > 9 ? String.valueOf(m) : "0"
				+ String.valueOf(m));
		String date = String.valueOf(day > 9 ? String.valueOf(day) : "0"
				+ String.valueOf(day));
		String hour = String.valueOf(h > 9 ? String.valueOf(h) : "0"
				+ String.valueOf(h));
		String minute = String.valueOf(mi > 9 ? String.valueOf(mi) : "0"
				+ String.valueOf(mi));
		String second = String.valueOf(s > 9 ? String.valueOf(s) : "0"
				+ String.valueOf(s));

		retValue = month + "/" + date + "/" + yyyy + " " + hour + ":"
				+ minute + ":" + second;
		// System.out.println("New Date:::"+retValue);

	}
	return retValue;
}
public Date convertStringToDate(String inputDate) {
	Date dDateTime = null;
	// String pDate="";

	SimpleDateFormat sdfFormatDate = new SimpleDateFormat(
			"MM/dd/yyyy HH:mm:ss");
	// SimpleDateFormat sdfFormatDate = new SimpleDateFormat(format);

	try {
		if (inputDate != null && !inputDate.equals("")) {
			dDateTime = sdfFormatDate.parse(inputDate);
			java.sql.Timestamp timest = new java.sql.Timestamp(dDateTime
					.getTime());
			dDateTime = timest;
		}

	} catch (Exception e) {
		System.out.println("Error in convertStringToDate method" + e);
		e.printStackTrace();
	}
	// System.out.println("dDateTime:"+dDateTime);
	return dDateTime;
}
				}
