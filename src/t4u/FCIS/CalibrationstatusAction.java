package t4u.FCIS;

import java.text.DecimalFormat;
import java.util.ArrayList;
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
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.functions.CalibrationstatusFunctions;
import t4u.functions.CommonFunctions;

public class CalibrationstatusAction extends Action {

	public ActionForward execute(ActionMapping mapping, ActionForm form,HttpServletRequest request, HttpServletResponse response)throws Exception {
		String param = "";
		HttpSession session = request.getSession();
		CommonFunctions cf=new CommonFunctions();
		String serverName=request.getServerName();
		String sessionId = request.getSession().getId();
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");

		int systemId = loginInfo.getSystemId();
		int userId = loginInfo.getUserId();
		int clientId = loginInfo.getCustomerId();
		int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		
		JSONArray jsonArray = null;
		JSONObject jsonObject = new JSONObject();
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}

		CalibrationstatusFunctions calibrationstatus = new CalibrationstatusFunctions();

		if (param.equalsIgnoreCase("getCalibrationStatus")) {
			try {
				String custId = request.getParameter("custId");
				jsonArray = new JSONArray();
				if (custId != null && !custId.equalsIgnoreCase("")) {
					ArrayList<Object> list = calibrationstatus.getCalibrationDetails(Integer.parseInt(custId), systemId, offset, lang);
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("calibrationroot", jsonArray);
					} else {
						jsonObject.put("calibrationroot", "");
					}
				}
				response.getWriter().print(jsonObject.toString());

				cf.insertDataIntoAuditLogReport(sessionId, null, "Calibration Details", "View", userId, serverName, systemId, clientId,
				"Visited This Page");
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("getFuelMultiValue")) {
			try {
				String VehicleNo = request.getParameter("VehicleNo");
				jsonArray = new JSONArray();
				if (VehicleNo != null && !VehicleNo.equalsIgnoreCase("")) {
//					ArrayList<Object> list = calibrationstatus.getFuelMultiValueDetails(VehicleNo);
					jsonArray = calibrationstatus.getFuelMultiValueDetails(VehicleNo);;
					if (jsonArray.length() > 0) {
						jsonObject.put("voltageFuelRoot", jsonArray);
					} else {
						jsonObject.put("voltageFuelRoot", "");
					}
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		} 
		
		else if (param.equals("CalibrationSave")) {
			try {
				
				Properties properties = ApplicationListener.prop;
				String fuelConstantFactorUnitType = properties.getProperty("FuelConstantFactorUnitType");
				String fuelConstantFactorForCelloF = properties.getProperty("FuelConstantFactorForCelloF");
				int uidInt = 0;
				
				String buttonValue = request.getParameter("buttonValue");
				String uid = request.getParameter("UID");
				String VehicleNo = request.getParameter("VehicleNo");
				String Minimumfuel = request.getParameter("Minimumfuel");
				String VoltageMinimumfuel = request.getParameter("VoltageMinimumfuel");
				String MaximumFuel = request.getParameter("MaximumFuel");
				String VoltageMaximumfuel = request.getParameter("VoltageMaximumfuel");
				String MinMileage = request.getParameter("MinMileage");
				String MaxMileage = request.getParameter("MaxMileage");
				String Calibrationdate = request.getParameter("Calibrationdate");
				String Calibratedby = request.getParameter("Calibratedby");
				String EndCustomer = request.getParameter("EndCustomer");
				String Remarks = request.getParameter("Remarks");
				String clientstr = request.getParameter("custId");
				String lastdate = request.getParameter("lastdate");
				String fuelVoltJson = request.getParameter("fuelVoltjson");
				int speed = Integer.parseInt(request.getParameter("speed"));
				String ignition=request.getParameter("ignition");
				String deltaDistance=request.getParameter("deltaDistance");
				String message = "";
				String fuelConstantFactor = "";
				
				if(uid!=null && !uid.equals("")) {
			    	uidInt = Integer.parseInt(uid);
			    }
				
				double Minimumfueldouble = 0;
				double VoltageMinimumfueldouble = 0;
				double MaximumFueldouble = 0;
				double VoltageMaximumdouble = 0;

				DecimalFormat df = new DecimalFormat("#.##");

				if (clientstr != null && !clientstr.equals("")) {
					if (Minimumfuel != null && !Minimumfuel.equals("")) {
						Minimumfueldouble = Double.parseDouble(Minimumfuel);
						Minimumfuel = df.format(Minimumfueldouble);
						Minimumfueldouble = Double.parseDouble(Minimumfuel);
					}
					if (VoltageMinimumfuel != null && !VoltageMinimumfuel.equals("")) {
						VoltageMinimumfueldouble = Double.parseDouble(VoltageMinimumfuel);
						VoltageMinimumfuel = df.format(VoltageMinimumfueldouble);
						VoltageMinimumfueldouble = Double.parseDouble(VoltageMinimumfuel);
					}
					if (MaximumFuel != null && !MaximumFuel.equals("")) {
						MaximumFueldouble = Double.parseDouble(MaximumFuel);
						MaximumFuel = df.format(MaximumFueldouble);
						MaximumFueldouble = Double.parseDouble(MaximumFuel);
					}
					if (VoltageMaximumfuel != null && !VoltageMaximumfuel.equals("")) {
						VoltageMaximumdouble = Double.parseDouble(VoltageMaximumfuel);
						VoltageMaximumfuel = df.format(VoltageMaximumdouble);
						VoltageMaximumdouble = Double.parseDouble(VoltageMaximumfuel);
					}
					double M_cof = 0;
					double C_cof = 0;
//					double diff=(VoltageMaximumdouble-VoltageMinimumfueldouble);
//				    
//				    if(diff!=0) {
//				    	 M_cof=(MaximumFueldouble-Minimumfueldouble)/(diff);				    	
//				    }
//				   
//				    C_cof=Minimumfueldouble-(M_cof*VoltageMinimumfueldouble);
				    
					String fuelConstantFactorUnitTypeDB = calibrationstatus.getFuelConstantFactorUnitType(VehicleNo,systemId);
					if(fuelConstantFactorUnitTypeDB.equals(fuelConstantFactorUnitType)){
						fuelConstantFactor = fuelConstantFactorForCelloF;
					} else {
						fuelConstantFactor = "1";
					}
					
					if (buttonValue.equals("Add")) {
						
						message = calibrationstatus.insertCalibrationInformation(VehicleNo,Minimumfueldouble,VoltageMinimumfueldouble,MaximumFueldouble,VoltageMaximumdouble, MinMileage,
								  MaxMileage, offset, Integer.parseInt(clientstr), systemId,speed, M_cof, C_cof, lastdate,Calibrationdate, Calibratedby,EndCustomer, Remarks, userId, fuelConstantFactor, fuelVoltJson,ignition,Float.parseFloat(deltaDistance));
						
						calibrationstatus.updateLastExeDateTime(offset, Integer.parseInt(clientstr), systemId, VehicleNo, lastdate);
						
					} else if (buttonValue.equals("Modify")) {
						
						message = calibrationstatus.updateCalibrationInformation(VehicleNo,Minimumfueldouble,VoltageMinimumfueldouble,MaximumFueldouble,VoltageMaximumdouble, MinMileage,
								  MaxMileage, offset, Integer.parseInt(clientstr), systemId,lastdate, Calibrationdate,Calibratedby, EndCustomer, Remarks,userId,fuelConstantFactor,M_cof, C_cof,speed,uidInt, fuelVoltJson,ignition,Float.parseFloat(deltaDistance));
						
						calibrationstatus.updateLastExeDateTime(offset, Integer.parseInt(clientstr), systemId, VehicleNo, lastdate);
						
					}
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				System.out.println("Error in Asset Group Action:-save "+ e.toString());
			}
		}

		else if (param.equalsIgnoreCase("getVehicleNumber")) {
			try {
				String customerId = request.getParameter("CustId");
				if (customerId != null && !customerId.equals("")) {
					jsonArray = calibrationstatus.getVehicleNumber(systemId, Integer.parseInt(customerId));
					jsonObject.put("vehicleNoRoot", jsonArray);
				} else {
					jsonObject.put("vehicleNoRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("getMonitoringFDASDetails")) {

			try {
				jsonArray = new JSONArray();
				String jspname = request.getParameter("jspName");
				ArrayList<Object> list = calibrationstatus.getMonitoringFDASDetails("en");
				jsonArray = (JSONArray) list.get(0);

				if (jsonArray.length() > 0) {
					jsonObject.put("MonitoringFDASRoot", jsonArray);
				} else {

					jsonObject.put("MonitoringFDASRoot", "");
				}
				ReportHelper reportHelper = (ReportHelper) list.get(1);
				request.getSession().setAttribute(jspname, reportHelper);
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}

		} else if (param.equalsIgnoreCase("getVehicleNumber")) {
			try {
				String customerId = request.getParameter("CustId");
				if (customerId != null && !customerId.equals("")) {
					jsonArray = calibrationstatus.getVehicleNumber(systemId,Integer.parseInt(customerId));
					jsonObject.put("vehicleNoRoot", jsonArray);
				} else {
					jsonObject.put("vehicleNoRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equalsIgnoreCase("getrefuelDetails")) {
			try {

				String customerId = request.getParameter("CustId");
				String assetno = request.getParameter("assetNumber");
				jsonArray = new JSONArray();
				if (customerId != null && !customerId.equalsIgnoreCase("")) {
					ArrayList<Object> list = calibrationstatus.getrefuelDetails(assetno, systemId, Integer.parseInt(customerId),lang, offset);
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("refuelroot", jsonArray);
					} else {

						jsonObject.put("refuelroot", "");
					}
				}
				response.getWriter().print(jsonObject.toString());

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("RefuelSave")) {
			try {
				String customerId = request.getParameter("CustId");
				String buttonValue = request.getParameter("buttonValue");
				String VehicleNo = request.getParameter("VehicleNo");
				String Refuel = request.getParameter("Refuel");
				String Litres = request.getParameter("Litres");
				String Source = request.getParameter("Source");
				String Remarks1 = request.getParameter("Remarks1");
				String id = request.getParameter("id");
				String message = "";
				if (buttonValue.equals("Add")) {
					message = calibrationstatus.insertRefuelInformation(VehicleNo, Refuel, Litres, Source, Remarks1,systemId, Integer.parseInt(customerId), userId,offset);
				} else if (buttonValue.equals("Modify")) {
					message = calibrationstatus.updateRefuelInformation(Integer.parseInt(id), VehicleNo, Refuel, Litres, Source,Remarks1, systemId, Integer.parseInt(customerId),userId);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("approveSave")) {
			try {
				String customerId = request.getParameter("CustId");
				String VehicleNo = request.getParameter("VehicleNo");
				String buttonValue = request.getParameter("buttonValue");
				String eneterdBy = request.getParameter("Reviewby");
				String Remark = request.getParameter("Remark2");
				String message = "";
				if (buttonValue.equals("Approve") && customerId != null && !customerId.equals("") && VehicleNo != null && !VehicleNo.equals("")) {
					message = calibrationstatus.updateapproveInformation(VehicleNo, eneterdBy, Remark, systemId, Integer.parseInt(customerId), userId);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("VerifySave")) {
			try {
				String customerId = request.getParameter("CustId");
				String VehicleNo = request.getParameter("VehicleNo");
				String buttonValue = request.getParameter("buttonValue");
				String Remarks2 = request.getParameter("Remarks2");
				String id = request.getParameter("id");
				String message = "";
				if (buttonValue.equals("Verify") && id != null && !id.equals("") && customerId != null && !customerId.equals("") && VehicleNo != null && !VehicleNo.equals("")) {
					message = calibrationstatus.updateVerifyInformation(Integer.parseInt(id), VehicleNo, Remarks2, systemId,Integer.parseInt(customerId), userId);
				}
				response.getWriter().print(message);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		else if (param.equals("getvehicleno")) {
			try {
				String custId = request.getParameter("custId");
				if (!custId.equals("null") || !custId.equals("")) {
					jsonArray = calibrationstatus.getVehicleNoRefuel(Integer.parseInt(custId), systemId, userId);
					jsonObject.put("vehicleNoRoot", jsonArray);
				} else {
					jsonObject.put("vehicleNoRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}
}
