package t4u.ironMining;

import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
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
import t4u.common.DBConnection;
import t4u.functions.CommonFunctions;
import t4u.functions.IronMiningFunction;
import t4u.functions.LogWriter;

public class TripSheetGenerationAction extends Action {
	private static final Object LOCK = new Object();

	@SuppressWarnings("unchecked")
	public ActionForward execute(ActionMapping mapping, ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		HttpSession session = request.getSession();
		ReportHelper reportHelper = null;
		LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
		int systemId = loginInfo.getSystemId();
		//int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		//int offset = loginInfo.getOffsetMinutes();
		String lang = loginInfo.getLanguage();
		CommonFunctions cf = new CommonFunctions();
		IronMiningFunction ironfunc = new IronMiningFunction();
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		String message = "";
		String param = "";
		SimpleDateFormat yyyyMMddHHmmss = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		SimpleDateFormat ddMMyyyy = new SimpleDateFormat("dd-MM-yyyy");
		if (request.getParameter("param") != null) {
			param = request.getParameter("param").toString();
		}
		// ****************************** GET VEHICLE NO*****************************

		if (param.equalsIgnoreCase("getVehicleList")) {
			String ClientId = request.getParameter("CustId");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getVehicleNoList(ClientId, systemId);
					if (jsonarray.length() > 0) {
						jsonObject.put("vehicleComboStoreRoot", jsonarray);
					} else {
						jsonObject.put("vehicleComboStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		// ****************************** GET TCLEASE NAME*****************************
		else if (param.equalsIgnoreCase("getTCNameList")) {
			String ClientId = request.getParameter("CustId");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getTCNameList(ClientId, systemId);
					if (jsonarray.length() > 0) {
						jsonObject.put("tcLeaseNameRoot", jsonarray);
					} else {
						jsonObject.put("tcLeaseNameRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
		// ****************************** GET ROUTE NAME*****************************

		else if (param.equalsIgnoreCase("getRouteList")) {
			String ClientId = request.getParameter("CustId");
			String orgId = request.getParameter("orgId");
			String permitType = request.getParameter("permitType");
			String rsPermit = request.getParameter("permit");
			if (ClientId != null && !ClientId.equals("") && orgId != null && !orgId.equals("") && rsPermit != null
					&& !rsPermit.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getRouteNameList(ClientId, systemId, Integer.parseInt(orgId), permitType,
							Integer.parseInt(rsPermit));
					if (jsonarray.length() > 0) {
						jsonObject.put("routeComboStoreRoot", jsonarray);
					} else {
						jsonObject.put("routeComboStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
		// ****************************** GET GRADE NAME*****************************
		else if (param.equalsIgnoreCase("getGradeAndMineralsList")) {
			String ClientId = request.getParameter("CustId");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getGradeList(ClientId, systemId);
					if (jsonarray.length() > 0) {
						jsonObject.put("gradeAndMineralsRoot", jsonarray);
					} else {
						jsonObject.put("gradeAndMineralsRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
		//******************************GET RFID*************************************//
		else if (param.equalsIgnoreCase("getRFID")) {
			String ClientId = request.getParameter("CustID");
			String rfidValue = request.getParameter("RFIDValue");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					String ip = request.getRemoteAddr();
					jsonarray = ironfunc.getRFID(ClientId, systemId, rfidValue);
					if (jsonarray.length() > 0) {
						jsonObject.put("tripRoot", jsonarray);
					} else {
						jsonObject.put("tripRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		//******************************GET CAPTURE QUANTITY************************//
		else if (param.equalsIgnoreCase("getCaptureQuantity")) {
			String ClientId = request.getParameter("CustID");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					String ip = request.getRemoteAddr();
					jsonarray = ironfunc.getWeightFromFile(ClientId, systemId, ip);
					if (jsonarray.length() > 0) {
						jsonObject.put("Weight", jsonarray);
					} else {
						jsonObject.put("Weight", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		//******************************GET WightFromFile *************************************//
		else if (param.equalsIgnoreCase("getCaptureWeight")) {
			String ClientId = request.getParameter("CustID");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					String ip = request.getRemoteAddr();
					jsonarray = ironfunc.getWeightFromFileForInterval(ClientId, systemId, ip);
					if (jsonarray.length() > 0) {
						jsonObject.put("rfidRoot", jsonarray);
					} else {
						jsonObject.put("rfidRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}
		//---------------------------------------------------------------------------------------------//
		else if (param.equalsIgnoreCase("getMiningTripSheetDetails")) {
			try {
				ArrayList list = null;
				String CustomerId = request.getParameter("CustID");
				String jspName = request.getParameter("jspName");
				String customerName = request.getParameter("CustName");
				String fromDate = request.getParameter("startDate");
				fromDate = fromDate.replace('T', ' ');

				String endDate = request.getParameter("endDate");
				endDate = endDate.replace('T', ' ');
				String status = request.getParameter("status");
				jsonArray = new JSONArray();
				jsonObject = new JSONObject();
				if (CustomerId != null && !CustomerId.equals("")) {
					list = ironfunc.getTripSheetDetails(customerName, systemId, Integer.parseInt(CustomerId), userId,
							lang, fromDate, endDate, status);
					jsonArray = (JSONArray) list.get(0);
					if (jsonArray.length() > 0) {
						jsonObject.put("miningTripSheetDetailsRoot", jsonArray);
					} else {
						jsonObject.put("miningTripSheetDetailsRoot", "");
					}
					reportHelper = (ReportHelper) list.get(1);
					request.getSession().setAttribute(jspName, reportHelper);
					request.getSession().setAttribute("jspPageName", "Mining Trip Sheet Generation");
					request.getSession().setAttribute("custId", customerName);
					request.getSession().setAttribute("startdate", ddMMyyyy.format(yyyyMMddHHmmss.parse(fromDate)));
					request.getSession().setAttribute("enddate", ddMMyyyy.format(yyyyMMddHHmmss.parse(endDate)));
					response.getWriter().print(jsonObject.toString());
				} else {
					jsonObject.put("miningTripSheetDetailsRoot", "");
					response.getWriter().print(jsonObject.toString());
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("saveormodifyGenrateTripSheet")) {
			Connection con = null;
			try {
				SimpleDateFormat sdf = new SimpleDateFormat("dd-MM-yyyy");
				Properties properties = ApplicationListener.prop;
				String logFile = properties.getProperty("LogFileForTruckTripsheetAction");
				String logFileName = logFile.substring(0, logFile.lastIndexOf("."));
				String logFileExt = logFile.substring(logFile.lastIndexOf(".") + 1, logFile.length());
				logFile = logFileName + "-" + sdf.format(new Date()) + "." + logFileExt;
				PrintWriter pw;
				LogWriter logWriter = null;
				if (logFile != null) {
					try {
						pw = new PrintWriter(new FileWriter(logFile, true), true);
						logWriter = new LogWriter(
								"saveormodifyGenrateTripSheet" + "---- " + session.getId() + "-----" + userId,
								LogWriter.INFO, pw);
						;
						logWriter.setPrintWriter(pw);
					} catch (IOException e) {
						logWriter.log("Can't open the log file: " + logFile + ". Using System.err instead",
								LogWriter.ERROR);
					}
				}
				logWriter.log(" Begining of the method ", LogWriter.INFO);
				String buttonValue = request.getParameter("buttonValue");
				String CustomerId = request.getParameter("CustID");
				String type = request.getParameter("type");
				String AssetNo = request.getParameter("vehicleNo");
				String leaseName = request.getParameter("tcLeaseName");
				String quantity = request.getParameter("quantity");
				String validityDateTime = request.getParameter("validityDateTime");
				String grade = request.getParameter("grade");
				String gradetype = request.getParameter("gradetype");
				String routeId = request.getParameter("routeId");
				String uniqueId = request.getParameter("uniqueId");
				String CustName = request.getParameter("CustName");
				String leaseModify = request.getParameter("leaseModify");
				String gradeModify = request.getParameter("gradeModify");
				String routeModify = request.getParameter("routeModify");
				String order = request.getParameter("order");
				String quantity1 = request.getParameter("quantity1");
				String srcHubId = request.getParameter("srcHubId");
				String desHubId = request.getParameter("desHubId");
				String permitNo = request.getParameter("permitNo");
				String pId = request.getParameter("pId");
				String actualQuantity = request.getParameter("actualQuantity");
				String userSettingId = request.getParameter("userSettingId");
				String orgCode = "0";
				String rsSource = request.getParameter("rsSource");
				String rsDestination = request.getParameter("rsDestination");
				String transactionNo = request.getParameter("transactionNo");
				String nonCommHrs = request.getParameter("nonCommHrs");
				String permitbal = request.getParameter("permitBal");
				message = "";
				if (request.getParameter("orgCode") != null && !request.getParameter("orgCode").equals("")) {
					orgCode = request.getParameter("orgCode");
				}
				logWriter.log(
						"buttonValue===" + buttonValue + " type== " + type + " AssetNo== " + AssetNo + " quantity== "
								+ quantity + " permitNo== " + permitNo + "  quantity1====  " + quantity1,
						LogWriter.INFO);
				logWriter.log("SESSION ID=== " + session.getId(), LogWriter.INFO);
				logWriter.log("USER ID=== " + userId, LogWriter.INFO);
				if (buttonValue.equals("add")) {

					if (CustomerId != null || AssetNo != null || leaseName != null || quantity != null || grade != null
							|| routeId != null) {
						con = DBConnection.getConnectionToDB("AMS");
						String finalMsg = ironfunc.getValidationStatus(con, nonCommHrs, AssetNo,
								Integer.parseInt(CustomerId), systemId);
						logWriter.log("Validation Status message == " + finalMsg, LogWriter.INFO);
						String[] msgArr = finalMsg.split("##");
						if (msgArr[0].equalsIgnoreCase("success")) {
							logWriter.log("Before balance check " + "permit bal==" + permitbal + " ", LogWriter.INFO);
							//							float bal = Float.parseFloat(permitbal);
							//							if(bal>200){
							//								logWriter.log("Before asynchronized ",LogWriter.INFO);
							message = ironfunc.saveTripSheetDetailsInformation(Integer.parseInt(CustomerId), type,
									AssetNo, leaseName, quantity, validityDateTime, grade, routeId, userId, systemId,
									CustName, quantity1, srcHubId, desHubId, permitNo, Integer.parseInt(pId),
									Float.parseFloat(actualQuantity), Integer.parseInt(userSettingId),
									Integer.parseInt(orgCode), gradetype, rsSource, rsDestination, transactionNo,
									nonCommHrs, order, con, msgArr[1], msgArr[2], msgArr[3], session.getId());
							//								logWriter.log("After asynchronized ",LogWriter.INFO);
							//							}else{
							//								logWriter.log("Before synchronized ",LogWriter.INFO);
							//								synchronized (LOCK) {
							//								message = ironfunc.saveTripSheetDetailsInformation(Integer.parseInt(CustomerId),type,AssetNo,leaseName,quantity,validityDateTime,grade,
							//										routeId,userId,systemId,CustName,quantity1,srcHubId,desHubId,permitNo,Integer.parseInt(pId),
							//										Float.parseFloat(actualQuantity),Integer.parseInt(userSettingId),Integer.parseInt(orgCode),
							//										gradetype,rsSource,rsDestination,transactionNo,nonCommHrs,order,con,msgArr[1],msgArr[2],msgArr[3],session.getId());
							//								}
							//								logWriter.log("After synchronized ",LogWriter.INFO);
							//							}
						} else {
							message = msgArr[0];
						}

					}
				} else if (buttonValue.equals("modify")) {

					if (CustomerId != null || AssetNo != null || leaseName != null || quantity != null || grade != null
							|| routeId != null) {
						logWriter.log("Inside Modify ", LogWriter.INFO);
						message = ironfunc.modifyTripSheetDetailsInformation(Integer.parseInt(CustomerId), type,
								AssetNo, leaseName, quantity, validityDateTime, grade, routeId, userId, systemId,
								CustName, leaseModify, gradeModify, routeModify, uniqueId, order);
					}
				}
				response.getWriter().print(message);
				logWriter.log(" Ending of the method ", LogWriter.INFO);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Mining Trip Generation Action:-saveORmodifyDetails" + e.toString());
			} finally {
				DBConnection.releaseConnectionToDB(con, null, null);
			}
		}

		else if (param.equalsIgnoreCase("getTripDetails")) {
			String ClientId = request.getParameter("CustID");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getTripDetails(ClientId, systemId, userId);
					if (jsonarray.length() > 0) {
						jsonObject.put("tripRoot", jsonarray);
					} else {
						jsonObject.put("tripRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		else if (param.equalsIgnoreCase("getTripDetailsForTare")) {
			String ClientId = request.getParameter("CustID");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getTripDetailsForTare(ClientId, systemId, userId);
					if (jsonarray.length() > 0) {
						jsonObject.put("tripRoot", jsonarray);
					} else {
						jsonObject.put("tripRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		else if (param.equalsIgnoreCase("getVehicleListForTare")) {
			String ClientId = request.getParameter("CustId");
			String buttonValue = request.getParameter("buttonValue");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {

					jsonarray = ironfunc.getVehicleDetailsForTare(ClientId, systemId, userId, buttonValue);
					if (jsonarray.length() > 0) {
						jsonObject.put("vehicleComboStoreRoot", jsonarray);
					} else {
						jsonObject.put("vehicleComboStoreRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		else if (param.equalsIgnoreCase("saveormodifyGenrateTripSheetForTare")) {
			try {
				String buttonValue = request.getParameter("buttonValue");
				String CustomerId = request.getParameter("CustID");

				String AssetNo = request.getParameter("vehicleNo");
				String validityDateTime = request.getParameter("validityDateTime");
				String grade = request.getParameter("grade");
				String quantity = request.getParameter("quantity");
				String closingType = request.getParameter("closingType");
				String closeQuantity = request.getParameter("closeQuantity");
				String tareqty = request.getParameter("tareqty");
				String grossqty = request.getParameter("grossqty");
				String type = request.getParameter("type");
				String closeReason = request.getParameter("closeReasson");
				String tripNo = "0";
				message = "";
				if (request.getParameter("tripNo") != null && !request.getParameter("tripNo").equals("")) {
					tripNo = request.getParameter("tripNo");
				}
				if (buttonValue.equals("tareWeight")) {

					if (CustomerId != null || AssetNo != null) {
						//						synchronized (LOCK) {
						message = ironfunc.saveTripSheetDetailsInformationForTare(Integer.parseInt(CustomerId), AssetNo,
								quantity, validityDateTime, grade, userId, systemId, closingType, closeQuantity, type,
								Integer.parseInt(tripNo), closeReason, session.getId());
						//						}
					}

				} else if (buttonValue.equals("closetrip") || buttonValue.equals("manualClose")) {

					if (CustomerId != null || AssetNo != null) {
						//						synchronized (LOCK) {
						message = ironfunc.saveTripSheetDetailsInformationForCloseTrip(Integer.parseInt(CustomerId),
								AssetNo, quantity, validityDateTime, grade, userId, systemId, tareqty, grossqty,
								buttonValue, closingType, type, Integer.parseInt(tripNo), closeReason, session.getId());
						//						}
					}
				}
				response.getWriter().print(message);

			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("Error in Mining Trip Generation Action:-saveORmodifyDetails" + e.toString());
			}

		}

		else if (param.equalsIgnoreCase("getRFIDForTareWeight")) {
			String ClientId = request.getParameter("CustID");
			String rfidValue = request.getParameter("RFIDValue");
			String buttonValue = request.getParameter("buttonValue");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					String ip = request.getRemoteAddr();
					jsonarray = ironfunc.getRFIDForTare(ClientId, systemId, rfidValue, buttonValue, userId);
					if (jsonarray.length() > 0) {
						jsonObject.put("tripRoot", jsonarray);
					} else {
						jsonObject.put("tripRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		else if (param.equalsIgnoreCase("getPermitBalForModify")) {
			String ClientId = request.getParameter("CustID");
			String pid = request.getParameter("pId");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getPermitBalForModify(ClientId, systemId, pid);
					if (jsonarray.length() > 0) {
						jsonObject.put("tripRoot", jsonarray);
					} else {
						jsonObject.put("tripRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		else if (param.equalsIgnoreCase("getPermitNo")) {
			String ClientId = request.getParameter("CustID");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getPermitNo(ClientId, systemId, userId);
					if (jsonarray.length() > 0) {
						jsonObject.put("permitRoot", jsonarray);
					} else {
						jsonObject.put("permitRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		else if (param.equalsIgnoreCase("getGrade")) {
			String ClientId = request.getParameter("CustId");
			String pid = request.getParameter("permitID");
			String permitno = request.getParameter("permitNo");
			String srcType = request.getParameter("srcType");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getGradefortrip(ClientId, systemId, userId, pid, permitno, srcType);
					if (jsonarray.length() > 0) {
						jsonObject.put("gradeRoot", jsonarray);
					} else {
						jsonObject.put("gradeRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

		}

		else if (param.equalsIgnoreCase("cancelTrip")) {
			String customerId = request.getParameter("CustID");
			String id = request.getParameter("id");
			String permitNo = request.getParameter("permitNo");
			String tcId = "0";
			String routeId = "0";
			String assetNo = request.getParameter("assetNo");
			int issuedUser = Integer.parseInt(request.getParameter("issuedUser"));
			boolean isLTSP = loginInfo.getIsLtsp() == 0;
			boolean isLogedIn = issuedUser == userId;
			if (request.getParameter("tcId") != null && !request.getParameter("tcId").equals("")) {
				tcId = request.getParameter("tcId");
			}
			if (request.getParameter("routeId") != null && !request.getParameter("routeId").equals("")) {
				routeId = request.getParameter("routeId");
			}
			String message1 = "";
			if (customerId != null && !customerId.equals("") && id != null && !id.equals("")) {
				try {
					synchronized (LOCK) {
						message1 = ironfunc.cancelTrip(customerId, systemId, userId, id, permitNo,
								Integer.parseInt(tcId), Integer.parseInt(routeId), assetNo, isLTSP, isLogedIn);
						response.getWriter().print(message1);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else if (param.equalsIgnoreCase("getServerTime")) {
			String CustID = request.getParameter("CustID");
			JSONArray jsonarray = null;
			jsonObject = new JSONObject();
			if (CustID != null && !CustID.equals("")) {
				try {
					jsonarray = ironfunc.getServerTime(Integer.parseInt(CustID), systemId);
					if (jsonarray.length() > 0) {
						jsonObject.put("timeRoot", jsonarray);
					} else {
						jsonObject.put("timeRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else if (param.equalsIgnoreCase("getOperationType")) {
			JSONArray jsonarray = null;
			jsonObject = new JSONObject();
			try {
				jsonarray = ironfunc.getOperationType(systemId, userId);
				if (jsonarray.length() > 0) {
					jsonObject.put("operationTypeRoot", jsonarray);
				} else {
					jsonObject.put("operationTypeRoot", "");
				}
				response.getWriter().print(jsonObject.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (param.equalsIgnoreCase("transferTrip")) {
			String ClientId = request.getParameter("CustId");
			String extVehicleNo = request.getParameter("extVehicleNo");
			String tripSheetNo = request.getParameter("tripSheetNo");
			String replaceVehicleNo = request.getParameter("ReplaceVehicleNo");
			String remark = request.getParameter("remark");
			String tripId = request.getParameter("tripId");
			String Transfertareweight = request.getParameter("Transfertareweight");

			if (ClientId != null && !ClientId.equals("")) {
				jsonObject = new JSONObject();
				try {
					message = ironfunc.transferTrip(ClientId, systemId, extVehicleNo, tripSheetNo, replaceVehicleNo,
							remark, tripId, Transfertareweight, userId);
					response.getWriter().print(message);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else if (param.equalsIgnoreCase("getBargeTripNo")) {
			String ClientId = request.getParameter("CustID");
			if (ClientId != null && !ClientId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getBargeTripNo(ClientId, systemId, userId);
					if (jsonarray.length() > 0) {
						jsonObject.put("bargeStoreroot", jsonarray);
					} else {
						jsonObject.put("bargeStoreroot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else if (param.equalsIgnoreCase("transferBargeTrip")) {
			String ClientId = request.getParameter("CustId");
			String remark = request.getParameter("remark");
			String tripId = request.getParameter("tripId");
			String bargeId = request.getParameter("bargeId");
			String tripSheetNo = request.getParameter("tripSheetNo");
			String quantity = request.getParameter("quantity");
			String quantity1 = request.getParameter("quantity1");
			String permitId = request.getParameter("permitId");
			String bargeStatus = request.getParameter("bargeStatus");
			String bargeQty = request.getParameter("bargeQty");
			String bargeCapacity = request.getParameter("bargeCapacity");
			String vehicleNo = request.getParameter("vehicleNo");
			String truckTripNo = request.getParameter("truckTripNo");

			if (ClientId != null && !ClientId.equals("")) {
				jsonObject = new JSONObject();
				try {
					message = ironfunc.transferBargeTrip(Integer.parseInt(ClientId), systemId, tripId, bargeId,
							tripSheetNo, remark, userId, quantity, quantity1, Integer.parseInt(permitId), bargeStatus,
							Float.parseFloat(bargeQty), Float.parseFloat(bargeCapacity), vehicleNo, truckTripNo);
					response.getWriter().print(message);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}

		else if (param.equalsIgnoreCase("getTripsheetLimit")) {
			String customerId = request.getParameter("custId");
			String routeId = request.getParameter("routeId");
			if (customerId != null && !customerId.equals("") && routeId != null && !routeId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {
					jsonarray = ironfunc.getTripsheetCount(Integer.parseInt(customerId), systemId,
							Integer.parseInt(routeId));
					if (jsonarray.length() > 0) {
						jsonObject.put("tripsheetLimitRoot", jsonarray);
					} else {
						jsonObject.put("tripsheetLimitRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else if (param.equalsIgnoreCase("getVehicleListForTripTransfer")) {
			String CustId = request.getParameter("CustId");
			if (CustId != null && !CustId.equals("")) {
				JSONArray jsonarray = null;
				jsonObject = new JSONObject();
				try {

					jsonarray = ironfunc.getVehiclesForTripTransfer(CustId, systemId);
					if (jsonarray.length() > 0) {
						jsonObject.put("tripTranferVehiclesRoot", jsonarray);
					} else {
						jsonObject.put("tripTranferVehiclesRoot", "");
					}
					response.getWriter().print(jsonObject.toString());
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return null;
	}
}
