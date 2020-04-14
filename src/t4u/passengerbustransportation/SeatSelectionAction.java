package t4u.passengerbustransportation;

import java.util.Properties;

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
import t4u.common.ApplicationListener;
import t4u.functions.PassengerBusTransportationFunctions;

public class SeatSelectionAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		String param = "";
		Properties properties = ApplicationListener.prop;
		int customerID=0;
		int systemID=0;
		HttpSession session = request.getSession();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		if(loginInfo!=null)
		{
		systemID = loginInfo.getSystemId();
		customerID = loginInfo.getCustomerId();	
		}else{
		customerID=Integer.parseInt(properties.getProperty("customerID").trim());
		systemID=Integer.parseInt(properties.getProperty("systemID").trim());
		}
		
		PassengerBusTransportationFunctions ptf = new PassengerBusTransportationFunctions();
		JSONArray jsonArray = null;
		JSONObject jsonObject =null;
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
			
		if(param.equals("getTerminalNames")){
			String source=null;
			String destination=null;
			try{
				if(request.getParameter("source")!=null){
					source=request.getParameter("source").toString();
				}
				if(request.getParameter("destination")!=null){
					destination=request.getParameter("destination").toString();
				}
			String terminalNames=ptf.getTerminalNames(systemID, customerID,source,destination);
			if(terminalNames!=null){
				response.getWriter().print(terminalNames);
			} else {
				response.getWriter().print("");
			}
			}catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getOrigin")){			
			try{				
				String origin=ptf.getOrigin(systemID,customerID);
				if(origin!=null){
					response.getWriter().print(origin);
				} else {
					response.getWriter().print("");
				}
			}catch (Exception e) {
				e.printStackTrace();
			}
			
		}else if (param.equals("getDestination")){
			String source=null;
			if(request.getParameter("source")!=null){
				source=request.getParameter("source").toString();
			}
			
			try{
				String destination=ptf.getDestination(systemID, customerID, source);
				if(destination!=null){
					response.getWriter().print(destination);
				} else {
					response.getWriter().print("");
				}
				
			}catch (Exception e) {
				e.printStackTrace();
			}
			
			
		}else if (param.equals("getServiceNames")){
			String terminalName=null;
			String startJourneyDate=null;
			String origin=null;
			String destination=null;
			String endJourneyDate=null;
			try{
				if(request.getParameter("terminalName")!=null){
					terminalName=request.getParameter("terminalName").toString();
				}
				if(request.getParameter("source")!=null){
					origin=request.getParameter("source").toString();
				}
				if(request.getParameter("destination")!=null){
					destination=request.getParameter("destination").toString();
				}
				if(request.getParameter("startJourney")!=null){
					startJourneyDate=request.getParameter("startJourney").toString();
				}
				if(request.getParameter("endJourney")!=null){
					endJourneyDate=request.getParameter("endJourney").toString();
				}
				
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if(startJourneyDate!=null && !startJourneyDate.equals("")){
				jsonArray=ptf.getServiceNameBasedOnTerminalSearch(systemID,customerID,terminalName,origin,destination,startJourneyDate);
				}else if(endJourneyDate!=null && !endJourneyDate.equals("")){
					jsonArray=ptf.getServiceNameBasedOnTerminalSearch(systemID,customerID,terminalName,origin,destination,endJourneyDate);
				}
				if (jsonArray.length() > 0) {
					jsonObject.put("servicenameroot", jsonArray);
				} else {
					jsonObject.put("servicenameroot", "");
				}
				response.getWriter().print(jsonObject.toString());
			}catch (Exception e) {
				e.printStackTrace();
			}
		}else if(param.equals("getBookedSeats")){
			String terminalName=null;
			String serviceName=null;
			String routeName=null;
			String journeyDate=null;
			int serviceID=0;
			int terminalID=0;
			int rateID=0;
			if(request.getParameter("terminalName")!=null && !request.getParameter("terminalName").equals("")){
				terminalName=request.getParameter("terminalName").toString();
			}
			if(request.getParameter("serviceName")!=null && !request.getParameter("serviceName").equals("")){
				serviceName=request.getParameter("serviceName").toString();
			}
			if(request.getParameter("routeName")!=null && !request.getParameter("routeName").equals("")){
				routeName=request.getParameter("routeName").toString();
			}
			if(request.getParameter("journeyDate")!=null && !request.getParameter("journeyDate").equals("")){
				journeyDate=request.getParameter("journeyDate").toString();
			}
			if(request.getParameter("serviceID")!=null && !request.getParameter("serviceID").equals("")){
				serviceID=Integer.parseInt(request.getParameter("serviceID").toString());
			}
			if(request.getParameter("terminalID")!=null && !request.getParameter("terminalID").equals("")){
				terminalID=Integer.parseInt(request.getParameter("terminalID").toString());
			}
			if(request.getParameter("rateID")!=null && !request.getParameter("rateID").equals("")){
				rateID=Integer.parseInt(request.getParameter("rateID").toString());
			}
			String bookedSeats=ptf.getBookedSeatNumbers(terminalID, rateID, serviceName, terminalName, serviceID, routeName, journeyDate);
			if(bookedSeats!=null){
				response.getWriter().print(bookedSeats);
			} else {
				response.getWriter().print("");
			}
		}else if(param.equals("saveBookedSeats")){					
			String journeyDate=null;
			String serviceID=null;
			String terminalID=null;
			String rateID=null;
			String seatCount=null;
			String seatNumbers=null;
			String trip=null;
			String returnJourneyDate=null;
			String returnJourneyServiceID=null;
			String returnJourneyTerminalID=null;
			String returnJourneyRateID=null;
			String retrunJourneySeatNumbers=null;
			String temiID=null;
			if(request.getParameter("serviceID")!=null && !request.getParameter("serviceID").equals("")){
				serviceID=request.getParameter("serviceID").toString();
			}
			if(request.getParameter("terminalID")!=null && !request.getParameter("terminalID").equals("")){
				terminalID=request.getParameter("terminalID").toString();
			}
			if(request.getParameter("rateID")!=null && !request.getParameter("rateID").equals("")){
				rateID=request.getParameter("rateID").toString();
			}
			if(request.getParameter("journeyDate")!=null && !request.getParameter("journeyDate").equals("")){
				journeyDate=request.getParameter("journeyDate").toString();
			}
			if(request.getParameter("noOfSeats")!=null && !request.getParameter("noOfSeats").equals("")){
				seatCount=request.getParameter("noOfSeats").toString();
			}
			if(request.getParameter("seatNumbers")!=null && !request.getParameter("seatNumbers").equals("")){
				seatNumbers=request.getParameter("seatNumbers").toString();
			}
			if(request.getParameter("trip")!=null && !request.getParameter("trip").equals("")){
				trip=request.getParameter("trip").toString();
			}
			if(request.getParameter("returnDate")!=null && !request.getParameter("returnDate").equals("")){
				returnJourneyDate=request.getParameter("returnDate").toString();
			}
			if(request.getParameter("returnServiceID")!=null && !request.getParameter("returnServiceID").equals("")){
				returnJourneyServiceID=request.getParameter("returnServiceID").toString();
			}
			
			if(request.getParameter("returnTerminalID")!=null && !request.getParameter("returnTerminalID").equals("")){
				returnJourneyTerminalID=request.getParameter("returnTerminalID").toString();
			}
			
			if(request.getParameter("returnRateID")!=null && !request.getParameter("returnRateID").equals("")){
				returnJourneyRateID=request.getParameter("returnRateID").toString();
			}
			
			if(request.getParameter("returnSeatNumbers")!=null && !request.getParameter("returnSeatNumbers").equals("")){
				retrunJourneySeatNumbers=request.getParameter("returnSeatNumbers").toString();
			}
		
			if(trip.equals("round")){
			 temiID=ptf.insertIntoRoundTripTemepTransaction(trip,Integer.parseInt(seatCount), Integer.parseInt(serviceID), Integer.parseInt(returnJourneyServiceID), Integer.parseInt(terminalID),
					Integer.parseInt(returnJourneyTerminalID), Integer.parseInt(rateID), Integer.parseInt(returnJourneyRateID), journeyDate, returnJourneyDate, seatNumbers, retrunJourneySeatNumbers);
			}else{
				temiID=ptf.insertIntoTempTransaction(Integer.parseInt(seatCount),  Integer.parseInt(serviceID), Integer.parseInt(terminalID), Integer.parseInt(rateID), journeyDate, seatNumbers);
			}
			
			if(temiID!=null){
				response.getWriter().print(temiID);
			} else {
				response.getWriter().print("");
			}
		}else if (param.equals("getSeatingStructureDesign")){
			String seatingStructure=null;			
			String structureName=null;
			if(request.getParameter("structureName")!=null){
				structureName=request.getParameter("structureName");
			}
			seatingStructure=ptf.getSeatingStructure(systemID,customerID,structureName);
			if(seatingStructure!=null){
				response.getWriter().print(seatingStructure);
			} else {
				response.getWriter().print("");
			}
		}
		
		
		return null;
	}

}
