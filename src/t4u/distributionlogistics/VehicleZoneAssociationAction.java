package t4u.distributionlogistics;

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
import t4u.functions.TripCreationFunctions;
import t4u.functions.VehicleZoneAssociationFunctions;

/**
 * @author praveen.j
 *
 */
public class VehicleZoneAssociationAction 	extends Action {

		@SuppressWarnings({ "unchecked" })
		public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {

			String param = "";
			String message = "";		
			HttpSession session = request.getSession();
			LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
			
			int systemId = loginInfo.getSystemId();
			int userId = loginInfo.getUserId();
			String zone = loginInfo.getZone();
			String userName = loginInfo.getUserName();
			JSONArray jsonArray = null;
			JSONObject jsonObject = new JSONObject();
			
			VehicleZoneAssociationFunctions vzaf= new VehicleZoneAssociationFunctions();
			
			if(request.getParameter("param")!=null){
				param=request.getParameter("param").toString();
			}
			
		if (param.equalsIgnoreCase("getVehicleZoneDetails")) {
			try {

				String customer = request.getParameter("CustId");
				int customerid = 0;
				if ((customer == null || customer.equals(""))) {
					customerid = 0;
				}else{
					customerid = Integer.parseInt(customer);
				}
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				jsonArray = vzaf.getVehicleZoneDetails(customerid, systemId);
				if (jsonArray.length() > 0) {
					jsonObject.put("vehicleZoneDetails", jsonArray);
				} else {
					jsonObject.put("vehicleZoneDetails", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				System.out
						.println("Exception in VehicleZoneAssociationAction:-getVehicleZoneDetails "
								+ e.toString());
			}
		}
			
			// ****************************** GET VEHICLE NO*****************************

			if (param.equalsIgnoreCase("getVehicles")) {
				String StartDate="";
				String ClientId = request.getParameter("CustId");
				StartDate=request.getParameter("sdate");
				if (ClientId != null && !ClientId.equals("")) {
					JSONArray jsonarray = null;
					try {
						jsonarray = vzaf.getVehicleNoWithVendorName(ClientId, systemId, userId);
						if (jsonarray.length() > 0) {
							jsonObject.put("VehicleRoot", jsonarray);
						} else {
							jsonObject.put("VehicleRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

			}
			if (param.equalsIgnoreCase("getZones")) {
				String StartDate="";
				String ClientId = request.getParameter("CustId");
				
				if (ClientId != null && !ClientId.equals("")) {
					JSONArray jsonarray = null;
					try {
						jsonarray = vzaf.getZone_HUBID(ClientId, systemId, userId,zone);
						if (jsonarray.length() > 0) {
							jsonObject.put("ZoneRoot", jsonarray);
						} else {
							jsonObject.put("ZoneRoot", "");
						}
						response.getWriter().print(jsonObject.toString());
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

			}
			
			
			 if(param.equalsIgnoreCase("AddorModify"))
				{

					try
					{
						String buttonValue = request.getParameter("buttonValue");
						String custId=request.getParameter("CustId");			
						String zoneOrHubId = request.getParameter("ZoneId");
						String zoneName = request.getParameter("zoneName");
						String vehicleNo = request.getParameter("VehicleNo");
						String vehicleGroup = request.getParameter("VehicleGroup");
						
					
						//String message="";
						if(buttonValue.equals("Add") && custId != null && !custId.equals(""))
						{
							message=vzaf.addVenicleTOZone(vehicleNo,vehicleGroup,zoneOrHubId,zoneName,systemId,Integer.parseInt(custId),userName);
							
						}else if(buttonValue.equals("Modify") && custId != null && !custId.equals(""))
						{
							String id=request.getParameter("uniqueId");
							message=vzaf.modifyVenicleTOZone(vehicleNo,vehicleGroup,zoneOrHubId,zoneName,systemId,Integer.parseInt(custId),userName,Integer.parseInt(id));
						}
						
						response.getWriter().print(message);
					}catch(Exception e)
					{
						e.printStackTrace();
					}
				
				}
			return null;
		}
}
