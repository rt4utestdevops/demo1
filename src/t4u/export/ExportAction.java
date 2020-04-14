package t4u.export;

import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Properties;
import java.util.StringTokenizer;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import t4u.beans.ExportForm;
import t4u.beans.LoginInfoBean;
import t4u.beans.ReportHelper;
import t4u.common.ApplicationListener;
import t4u.common.DBConnection;
import t4u.functions.CommonFunctions;

import com.itextpdf.text.BaseColor;
import com.itextpdf.text.Chunk;
import com.itextpdf.text.Font;
import com.itextpdf.text.FontFactory;
import com.itextpdf.text.Image;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.Rectangle;
import com.itextpdf.text.pdf.BaseFont;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;

@SuppressWarnings( { "unchecked" })
public class ExportAction extends Action {
	CommonFunctions cf = new CommonFunctions();

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response) {
		ExportForm exForm = (ExportForm) form;
		LoginInfoBean loginInfoBean = (LoginInfoBean) request.getSession().getAttribute("loginInfoDetails");
		String serviceProvider = "";

		Properties properties = null;
		try {
			properties = ApplicationListener.prop;
		} catch (Exception e) {
			e.printStackTrace();
		}

		if (loginInfoBean != null) {
			if (loginInfoBean.getCategory().equalsIgnoreCase("Enterprise")) {
				String platformName = properties.getProperty("Platform_Name");
				serviceProvider = platformName;
			} else {
				serviceProvider = loginInfoBean.getSystemName();
			}
		}

		String language = loginInfoBean.getLanguage();

		try {

			ArrayList<String> dataTypeList = null;
			ArrayList<Integer> colSpanList = null;
			int leftAlign = 0;

			HttpSession session = request.getSession();

			response.setCharacterEncoding("UTF-8");
			ServletOutputStream servletOutputStream = response.getOutputStream();

			String reportpath = properties.getProperty("ExcelReportPath");
			String reportpathpdf = properties.getProperty("PDFReportPath");

			refreshdir(reportpath);
			refreshdir(reportpathpdf);
			ArrayList headers = null;
			ArrayList footers = null;

			String type = exForm.getReporttype();
			String filename = exForm.getFilename();
			String report = exForm.getReport();
			String filteredRecords = exForm.getFilteredRecords();
			String hiddencolumns = exForm.getHiddencolumns();
			String exportdataType = exForm.getExportDataType();
			String subTotal=exForm.getSubtotal();
			String clientId = String.valueOf(loginInfoBean.getCustomerId());
			String systemid = String.valueOf(loginInfoBean.getSystemId());
			String userId = String.valueOf(loginInfoBean.getUserId());

			String urlxls = reportpath + filename + "_" + systemid + "_" + userId + ".xls";
			String urlpdf = reportpathpdf + filename + "_" + systemid + "_" + userId + ".pdf";
			String serviceReceiver = "";
			if (loginInfoBean.getCustomerName() != null && !loginInfoBean.getCustomerName().equals("")) {
				serviceReceiver = loginInfoBean.getCustomerName();				
			} else {
				serviceReceiver = loginInfoBean.getSystemName();				
			}
			// *******for any file export set here**/
			if (filename.equals("DailyAssetUtilizationReport")) {
				headers = getHeadersForDailyAssetUtilization(serviceReceiver,language, session.getAttribute("gname").toString(), session.getAttribute("date").toString());
			} 
			else if (filename.equals("VehicleWiseReport")) {
			//	System.out.println("______________________________ "+session.getAttribute("length").toString());
				headers = getHeadersForVehicleWiseReport(serviceReceiver,language, 
						session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),
						session.getAttribute("custId").toString(),session.getAttribute("NoRuns").toString());
			} 
			else if (filename.equals("CustomerWiseReport")) {
				headers = getHeadersForCustomerWiseReport(serviceReceiver,language, 
						session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),
						session.getAttribute("custId").toString(),session.getAttribute("NoRuns").toString());
			}else if (filename.equals("RealTimeDataReport")) {
				headers = getHeadersRealTimeDataReport(serviceReceiver,language,session.getAttribute("routeId").toString(), session.getAttribute("tripSheetNo").toString());
			}
			else if (filename.equals("MonthlyAssetUtilizationReport")) {
				headers = getHeadersForMonthlyAssetUtilization(serviceReceiver,language, session.getAttribute("gname").toString(),session.getAttribute("sdate").toString(), session.getAttribute("edate").toString());
			} 
			else if(filename.equals("VehicleSubscriptionRenwal")){
				headers = getHeadersForVehicleSubscriptionRenwalReport(serviceReceiver, language,
						session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),
						session.getAttribute("custName").toString());
			}
			else if(filename.equals("SandReconciliationReport")){
				headers = getHeadersForSandReconciliationReport(serviceReceiver, language,
						session.getAttribute("custName").toString());
			}
			else if(filename.equals("Route_Master_Details_Report")){				
				headers = getHeadersForRouteDetailsReport(serviceReceiver,session.getAttribute("custName").toString());	
			}
			else if(filename.equals("VehicleReportingDetails")){				
				headers = getHeadersForVehicleReportingDetailsReport(serviceReceiver,session.getAttribute("custName").toString());	
			}
			else if (filename.equals("DailyAttendanceReport")) {
				headers = getHeadersForDailyAttendance(serviceReceiver,language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			} 

			else if (filename.equals("RMCOperationHourReport")) {
				headers = getHeadersForRMCOperationHourReport(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}

			else if (filename.equals("UnauthorizedPortEntryReport")) {
				headers = getHeadersForUnauthorizedPortEntryReport(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}

			else if (filename.equals("YearlyRevenuePermitReport")) {
				headers = getHeadersForYearlyRevenuePermitReport(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}

			else if (filename.equals("VehicleUtilizationDuringWorkingDaysAfterWorkingHrs")) {
				headers = getHeadersForVehicleUtilization(serviceReceiver, language, session.getAttribute("customerId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());
			}
			else if (filename.equals("MonthlyRevenuePermitReport")) {
				headers = getHeadersForMonthlyRevenuePermitReport(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}

			else if (filename.equals("AssetEnrolment")) {
				headers = getHeadersForVehicleEnlisting(serviceReceiver,language);
			}

			else if (filename.equals("NonCommunicatingReport")) {
				headers = getHeadersForSandCommNonCommReport(serviceReceiver, language);
			}
			else if (filename.equals("NonCommunicatingVehiclesReport")) {
				headers = getHeadersForSandNonCommReport(serviceReceiver, language);
			}
			else if (filename.equals("RMCActivityReport")) {
				headers = getHeadersForRMCActivityReport(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}

			else if(filename.equals("FDAR")){
				headers=getHeadersForFuelConsolidatedReport(serviceReceiver,session.getAttribute("CustName").toString(),language,session.getAttribute("gname").toString(),session.getAttribute("startdate").toString(),session.getAttribute("enddate").toString());
			}

			else if(filename.equals("TripCreationReport")){				
				headers = getHeadersForTripCreationReport(serviceReceiver, language, session.getAttribute("customerid").toString(),session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}

			else if(filename.equals("AssetDelistingReport")){				
				headers = getHeadersForVehicleDelisting(serviceReceiver, language);
			}

			//KLERequest Module
			else if(filename.equals("KLERequest")){
				headers = getHeadersForKLERequestReport(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}
			
			//VehicleMobilizeManagement Module
			else if(filename.equals("VehicleMobilizeManagement")){
				headers = getHeadersForVehicleMobilizeManagement(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}
			
			//Consignment Module
			else if(filename.equals("consignmenttrackingusagereport")){
				headers = getHeadersForConsignmentTrackingUsageReport(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}
			//SMS Report
			else if(filename.equals("SMSReport")){
				headers = getHeadersForSMSReport(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}
			
			// Fuel Module
			else if(filename.equals("FuelReconciliationReport")){
				headers = getHeadersForFuelMileageReport(serviceReceiver, language, session.getAttribute("assetGroupName").toString(),session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),subTotal);
			}
			
			//Penalty System
			else if(filename.equals("PenaltySystem")){
				headers = getHeadersForPenaltySystemReport(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}
			
			//Rate Master
			else if(filename.equals("RateMaster")){
				headers = getHeadersForRateMasterReport(serviceReceiver,session.getAttribute("customerName").toString(),language);
			}

			//Trip Planner
			else if(filename.equals("Trip Planner")){
				headers = getHeadersForTripPlannerReport(serviceReceiver,session.getAttribute("customerId").toString(),language);
			}
			else if(filename.equals("FuelReconciliationSummaryReport")){
				headers = getHeadersForFuelMileageSummaryReport(serviceReceiver, language, session.getAttribute("assetGroupName").toString(),session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),subTotal);
			}
			
			else if(filename.equals("MDPCheckingReport")){
				headers =getMDPCheckingReport(serviceReceiver, language, session.getAttribute("custName").toString());	
			}
			else if(filename.equals("ShiftWiseTripDetails")){
				headers = getHeadersForshiftwiseTrip(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(), session.getAttribute("vehicleNo").toString());
			}

	
			// Marine Module
			else if(filename.equals("MarineVesselLiveReport")){
				headers = getHeadersForMarineVesselLive(serviceReceiver, language, session.getAttribute("assetNumber").toString(),
						session.getAttribute("proximityValue").toString(), session.getAttribute("groupName").toString(),
						session.getAttribute("latitude").toString(), session.getAttribute("longitude").toString(),
						session.getAttribute("driverName").toString(),session.getAttribute("driverNumber").toString(),
						session.getAttribute("ownerName").toString(),session.getAttribute("ownerNumber").toString(),
						session.getAttribute("lastCommunicated").toString(),session.getAttribute("communicationStatus").toString());
			}

			else if(filename.equals("MarineVesselHistoryReport")){
				headers = getHeadersForMarineVesselHistory(serviceReceiver, language, session.getAttribute("assetNumber").toString(), 
						session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("groupName").toString(),
						session.getAttribute("latitude").toString(), session.getAttribute("longitude").toString(),
						session.getAttribute("driverName").toString(),session.getAttribute("driverNumber").toString(),
						session.getAttribute("ownerName").toString(),session.getAttribute("ownerNumber").toString());
			}

			else if(filename.equals("MarineVesselLocationReport")){
				headers = getHeadersForMarineVesselByLocation(serviceReceiver, language, session.getAttribute("customerName").toString(), session.getAttribute("latitude").toString(), session.getAttribute("longitude").toString(),session.getAttribute("proximity").toString(), session.getAttribute("date").toString());
			}	
			// Accident Analysis Reports
			else if(filename.equals("AccidentExpenditureSummary")){
				headers = getHeadersForAccidentExpenditureSummary(serviceReceiver, language, session.getAttribute("customerName").toString());
			}

			else if(filename.equals("AccidentExpenditureDetails")){
				headers = getHeadersForAccidentExpenditureDetails(serviceReceiver, language, session.getAttribute("customerName").toString(), session.getAttribute("assetNumber").toString());
			}
			else if(filename.equals("MonitoringFDASReport")){
				headers = getHeadersForMonitoringFDASReport(serviceReceiver, language);
			}

			else if(filename.equals("PreventiveMaintenance")){				
				headers = getHeadersForTaskMaster(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			
			else if(filename.equals("HUB DETAILS")){				
				headers = getHeadersForHubDetails(serviceReceiver, language, session.getAttribute("custId").toString());
			}

			else if(filename.equals("Employee Information")){
				headers=getHeadersForEmployeeInformation(serviceReceiver,language,session.getAttribute("customerId").toString());
			}
			
			else if(filename.equals("ManageTasks")){				
				headers = getHeadersForManageTasks(serviceReceiver, language, session.getAttribute("custId").toString());	
			}


			else if(filename.equals("SweepingOperationsReport")){
				headers = getHeadersForSweepingManagementSummaryReport(serviceReceiver, language, session.getAttribute("custId").toString(),session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}

			else if(filename.equals("DailyWasteManagementSummaryReport")){				
				headers = getHeadersForWasteManagementSummaryReport(serviceReceiver, language, session.getAttribute("custId").toString(),session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}

			else if(filename.equals("PlannedMovementReport")){	
				headers = getHeadersForPlantMovementReport(serviceReceiver, language, session.getAttribute("customerId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}

			else if(filename.equals("VehicleUtilizationDuringHolidaysAndWeekends")){	
				headers = getHeadersForVehicleUtilizationDuringHolidayAndWeekends(serviceReceiver, language, session.getAttribute("customerId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());
			}

			else if(filename.equals("VehicleUtilizationDuringWorkingDays")){	
				headers = getHeadersForVehicleUtilizationDuringWorkingDays(serviceReceiver, language, session.getAttribute("customerId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}

			else if(filename.equals("LidAndValvesReport")){	
				headers = getHeadersForLidAndValvesReport(serviceReceiver, language, session.getAttribute("customerId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}

			else if(filename.equals("VehicleUtilizationDuringWorkingDaysAndWorkingHours")){	
				headers = getHeadersForUtilizationDaysHrs(serviceReceiver, language, session.getAttribute("customerId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}
			else if(filename.equals("VehicleUtilizationSummaryReport")){
				headers = getHeadersForVehicleUtilizationSummaryReport(serviceReceiver, language, session.getAttribute("customerId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());
			}
			else if (filename.equals("RouteDetails")) {
				headers = getHeadersForSchoolRouteAlloctionReport(serviceReceiver, language, session.getAttribute("customerId").toString());
			}
			else if (filename.equals("ManageStudents")) {
				headers = getHeadersForSchoolStudentDetailsReport(serviceReceiver, language, session.getAttribute("customerId").toString());
			}
			else if(filename.equals("PreventiveServicesReport")){	
				headers = getHeadersForPreventiveMaintenanceReport(serviceReceiver, language, session.getAttribute("custId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString(),session.getAttribute("type").toString());	
			}
			else if(filename.equals("CustomerHistoryReport")){
				headers=getHeadersForFFMCustomerVisitHistory(serviceReceiver,language,session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());
			}
			else if(filename.equals("PeakorNon-PeakHrsReportDetails")){
				headers=getHeadersPeakorNonPeakHrsReportDetails(serviceReceiver,language,session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());
			}
			else if(filename.equals("LiveVision")){
				headers = getHeadersForMapView(serviceReceiver, language,session.getAttribute("custId").toString());	
			}
			else if(filename.equals("UnitDetails")){
				headers = getHeadersForUnitDetailsReport(serviceReceiver, language,session.getAttribute("customerId").toString());
			}
			
			else if(filename.equals("ConsignmentSummaryDetails")){
				headers = getHeadersForConsignmentSummaryDetails(serviceReceiver, language,session.getAttribute("custId").toString(),session.getAttribute("region").toString(),session.getAttribute("consignmentStatus").toString(),session.getAttribute("fieldCondition").toString(),session.getAttribute("bookingCustomer").toString());
			}
			else if(filename.equals("BillingMatrixReport")){	
				headers = getHeadersForBillingMatrixReport(serviceReceiver, language, session.getAttribute("ltspId").toString(),session.getAttribute("month").toString(),session.getAttribute("billYear").toString(),session.getAttribute("invoiceNo").toString());	
			}
			
			else if(filename.equals("WebServiceTransactionReport")){	
				headers = getHeadersForWebServiceTransactionReport(serviceReceiver, language, session.getAttribute("custName").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}
			
			else if(filename.equals("TripSheetReport")){				
				headers = getHeadersForTripSheetReport(serviceReceiver, language, session.getAttribute("custId").toString(),session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(), session.getAttribute("groupName").toString());	
			}
			else if(filename.equals("DayWiseNoShowReport")){				
				headers = getHeadersForDayWiseNoShowReport(serviceReceiver, language, session.getAttribute("customerid").toString(),session.getAttribute("startdate").toString());
			}
			
			else if(filename.equals("HubArrivalHubDepartureReport")){				
			headers = getHeadersForHubArrDepReport(serviceReceiver, language , session.getAttribute("startdate").toString(),session.getAttribute("enddate").toString());
			}
			else if(filename.equals("MiningOverSpeedReport")){				
				headers = getHeadersForMiningOverSpeedReport(serviceReceiver, language, session.getAttribute("custId").toString(),session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(), session.getAttribute("groupName").toString());	
			}
			
			else if(filename.equals("Sand_Inward_Trip_Sheet")){				
				headers = sandnwardTripreport(serviceReceiver, language, session.getAttribute("custId").toString())	;
			}
			
			else if(filename.equals("Sand_Consumer_Credit_Master")){				
				headers = sandConsumerCreditHeaders(serviceReceiver, language, session.getAttribute("custId").toString())	;
			}
			
			else if(filename.equals("Consumer_MDP_Generator")){				
				headers = consumerMDPGenerator(serviceReceiver, language, session.getAttribute("custId").toString())	;
			}
			
			else if(filename.equals("ConsumerEnrolmentForm")){				
				headers = ConsumerEnrolmentForm(serviceReceiver, language, session.getAttribute("custId").toString())	;
			}
			
			else if(filename.equals("Terminal Master")){				
				headers = getHeadersForTerminalMasterDetails(serviceReceiver, language, session.getAttribute("customerId").toString())	;
			}
			/*****************Prepaid Card Master Report*****************/
			else if(filename.equals("Prepaid_Card_Master")){				
				headers = getHeadersForPrepaidCardMasterDetails(serviceReceiver, language, session.getAttribute("custId").toString())	;
			}
			/*****************Service Vehicle Association Report*****************/
			else if(filename.equals("Service_Vehicle_Association")){				
				headers = getHeadersForVehicleAssociationReport(serviceReceiver, language, session.getAttribute("custId").toString())	;
			}
			/*****************Monthly Returns Report*****************/
			else if(filename.equals("Monthly_Returns")){				
				headers = getHeadersForMonthlyReturnsReport(serviceReceiver, language, session.getAttribute("custId").toString())	;
			}
			else if(filename.equals("Monthly_Returns_Dashboard_Details")){				
				headers = getHeadersForMonthlyReturnsDashboardDetailsReport(serviceReceiver, language, session.getAttribute("custId").toString())	;
			}
			else if(filename.equals("Vehicle_Maintance_Window")){
				headers = getHeadersForVehicleMaintanceDetails(serviceReceiver, language,session.getAttribute("custId").toString());	
			}
			else if(filename.equals("SandBlockManagementReport")){
				headers = getHeadersForSandBlockManagementReport(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			else if(filename.equals("StockyardInformation")){
				headers = getHeadersForDivisionInformationReport(serviceReceiver, language, session.getAttribute("customerId").toString());	
			}
			// Vertical Summary report//
			else if(filename.equals("VerticalSummaryReport")){
				headers = getHeadersForVerticalSummaryReport(serviceReceiver, language, session.getAttribute("ReportName").toString());	
			}

			// Asset Enrollment Report Ironmining
			else if(filename.equals("MiningAssetEnrollmentReport")){				
				headers = getHeadersForMiningAssetEnrollmentReport(serviceReceiver, language, session.getAttribute("custId").toString());	
			}

			else if(filename.equals("ContractorInformation")){ 
						headers = getHeadersForContractorInformationReport(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			
			//Order Completion
			else if(filename.equals("OrderCompletionDetails")){
				headers = getHeadersForOrderCompletionDetails(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}

			//Route Deviation Report
			else if(filename.equals("RouteDeviation")){
				headers = getHeadersForRouteDeviation(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}
			
			//Excess Halting Report
			else if(filename.equals("ExcessHaltingReport")){
				headers = getHeadersForExcessHalting(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}
			
			//Same Vehicle Same Destination Report
			else if(filename.equals("SameVehicleSameDestination")){
				headers = getHeadersForSameVehicleSameDestination(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}
			
			//Multiple Vehicle Same Destination Report
			else if(filename.equals("MultipleVehicleSameDestination")){
				headers = getHeadersForMultipleVehicleSameDestination(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}
			
			//Idle Time Report
			else if(filename.equals("IdleTimeReport")){
				headers = getHeadersForIdleTimeReport(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}
			
			//Tampering Report
			else if(filename.equals("TamperingTurnOffReport")){
				headers = getHeadersForTamparingTurnOffReport(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}
			
			//Cross Border Report
			else if(filename.equals("CrossBorderReport")){
				headers = getHeadersForCrossBorderReport(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}
			
			//EwayBill VS Visits Report
			else if(filename.equals("eWayBillVsReachVisits")){
				headers = getHeadersForeWayBillVsReachVisits(serviceReceiver,session.getAttribute("customerName").toString(),language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}
			
			else if(filename.equals("CustomerMasterReport")){
				headers =getCustomerMasterReport(serviceReceiver, language, session.getAttribute("RegionId").toString());	
			}
			else if(filename.equals("ExecutiveDashBoardDetails")){
				headers = getHeadersForExecutiveDashBoard(serviceReceiver, language,session.getAttribute("custId").toString());	
			}
			else if(filename.equals("SummaryOfSandMiningROKReport")){
				headers = getHeadersForSandMiningSummary(serviceReceiver, language,session.getAttribute("sdate1").toString(),session.getAttribute("edate1").toString());	
			}
			else if(filename.equals("Parts_Pending_For_Approval")){
				headers = getHeadersForPartsPendingDetails(serviceReceiver, language,session.getAttribute("custId").toString());	
			}
			//Terminal Route Master//
			else if(filename.equals("Route Master")){
				headers = getHeadersForTerminalRouteMasterDetails(serviceReceiver, language,session.getAttribute("customerId").toString());	
			}else if(filename.equals("Seating Structure")){
				headers=getHeadersForSeatingStructure(serviceReceiver, language, session.getAttribute("customerId").toString());
			}
			else if(filename.equals("Trip_Summary_Report")){
				headers = getHeadersForTripSummaryReport(serviceReceiver, language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("custId").toString());	
			}
			else if(filename.equalsIgnoreCase("DriverBehaviourReport")){
				headers = getHeadersForDriverBehaviourReport(serviceReceiver, language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("custname").toString());	
			}
			else if(filename.equalsIgnoreCase("JetFleetTripExceptionReport")){
				headers = getHeadersforjfTripExceptionReport(serviceReceiver,language,session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString(),session.getAttribute("custName").toString());
			}
			else if(filename.equalsIgnoreCase("PowerConnectionReport")){
				headers = getHeadersforPowerConnectionReport(serviceReceiver,language,session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString(),session.getAttribute("custName").toString());
			}
			else if(filename.equalsIgnoreCase("JetFleetTripDetailsReport")){
				headers = getHeadersforjfTripDetailsReport(serviceReceiver,language,session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString(),session.getAttribute("custName").toString());
			}
			else if(filename.equals("Trip_Details_Report")){
				headers = getHeadersForTripDetailsReport(serviceReceiver, language,session.getAttribute("custId").toString(),session.getAttribute("tripNo").toString());	
			}	
			//Hub Maintenance Report//
			else if(filename.equals("Hub Maintenance Report")){
				headers = getHeadersForHubMaintenanceReport(serviceReceiver, language,session.getAttribute("customerId").toString(),session.getAttribute("HubName").toString(),session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString());
			}
			
			else if(filename.equals("Challan Reconcilation Report")){				
				headers = getHeadersForReconcilationReport(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			
			else if(filename.equals("Challan Details")){				
				headers = getHeadersForSummaryDetails(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			else if(filename.equals("Mine Details")){				
				headers = getHeadersForMineDetails(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			else if(filename.equals("ManageRoute")){				
				headers = getHeadersForManageRouteDetails(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			else if(filename.equals("MonitoringDashboardNew")){				
				headers = getHeadersForMonitoringDashboardDetails(serviceReceiver, language,session.getAttribute("FromDate").toString(),session.getAttribute("ToDate").toString(),session.getAttribute("FromLocation").toString(),session.getAttribute("ToLocation").toString(),session.getAttribute("Type").toString(),session.getAttribute("TripStatus").toString());	
			}
			//Sand Inward Report
			else if(filename.equals("SandInwardReport")){				
				headers = getHeadersForSandInwardReportDetails(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}
			//Sand Boat Report
			else if(filename.equals("SandBoatReport")){				
				headers = getHeadersForSandBoatReportDetails(serviceReceiver, language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());	
			}
			//Vehicle Without GPS Report
			else if(filename.equals("VehWithoutGPSReport")){				
				headers = getHeadersForVehWithoutGPSDetails(serviceReceiver, language);	
			}
			
			else if(filename.equals("DeductiionClaimedReport")){				
				headers = getHeadersForDeductionClaimedReport(serviceReceiver, language, session.getAttribute("custId").toString(),session.getAttribute("monthYear").toString(),session.getAttribute("mineralName").toString(),session.getAttribute("deductioinClaimed").toString());	
			}
			else if(filename.equals("SalesDispatchReport")){				
				headers = getHeadersForSalesDispatchReport(serviceReceiver, language, session.getAttribute("custId").toString(),session.getAttribute("monthYear").toString(),session.getAttribute("mineralName").toString(),session.getAttribute("grade").toString());	
			}
			else if(filename.equals("Production_Of_ROM_Report")){				
				headers = getHeadersForProductionDetails(serviceReceiver, language, session.getAttribute("custId").toString(),session.getAttribute("month").toString(),session.getAttribute("year").toString(),session.getAttribute("mineralType").toString(),session.getAttribute("category").toString());	
			}
			 //Employment and Wages paid
			else if(filename.equals("Employment and Wages Paid Report")){				
				headers = getHeadersForEmploymentDetails(serviceReceiver, language, session.getAttribute("custId").toString(), session.getAttribute("month").toString(), session.getAttribute("mineralName").toString(), session.getAttribute("labour").toString(), session.getAttribute("workPlace").toString());	
			}
			//ticketSummaryReport
			else if(filename.equals("Ticket Summary Report")){				
				headers = getHeadersForTicketSummaryReport(serviceReceiver, language, session.getAttribute("custId").toString(), session.getAttribute("type").toString(), session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}
			
			else if(filename.equals("Ticket Details")){				
				headers = getHeadersForTicketDetails(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			else if(filename.equals("Profit And Loss Report")){				
				headers = getHeadersForProfitandLoss(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			else if(filename.equals("MineFeedDetails")){				
				headers = getHeadersForMineFeedDetails(serviceReceiver, language, session.getAttribute("CustName").toString());	
			}
			
			else if(filename.equals("Interswitch Transaction Details")){				
				headers = getHeadersForInterswitchTransaction(serviceReceiver, language, session.getAttribute("custId").toString(), session.getAttribute("fromDate").toString(), session.getAttribute("toDate").toString());	
			}
			
			else if(filename.equals("StockYard Master")){				
				headers = getHeadersForStockYardMaster(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			else if(filename.equals("Route Density Report")){				
				headers = getHeadersForRouteDensityReport(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			else if(filename.equals("Trip Report")){				
				headers = getHeadersForTripReport(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			else if(filename.equals("ChallanDetails")){				
				headers = getHeadersForChallanDetails(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			
			else if(filename.equals("MiningTripSheetGenerationReport")){
				headers = getHeadersForMiningTripSheetGeneration(serviceReceiver, language,
						session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("custId").toString(),session.getAttribute("jspPageName").toString());
			}
			
			else if(filename.equals("MiningTripSheetGenerationForTruck")){
				headers = getHeadersForMiningTripSheetGenerationForTruck(serviceReceiver, language);
			}
			
			else if(filename.equals("Permit Details")){
				headers = getHeadersForPermitDetails(serviceReceiver, language,session.getAttribute("custName").toString());
			}
			else if(filename.equals("GPSTamperingDetails")){
				headers = getHeadersForGPSTamperingDetails(serviceReceiver, language,session.getAttribute("custName").toString());
			}
			else if(filename.equals("TC Master Details")){
				headers = getHeadersForTcMasterDetails(serviceReceiver, language,session.getAttribute("custId").toString());
			}
			
			else if(filename.equals("Owner Master Details")){
				headers = getHeadersForOwnerMasterDetails(serviceReceiver, language,session.getAttribute("custId").toString());
			}
			
			else if(filename.equals("Plant Master Details")){
				headers = getHeadersForPlantMasterDetails(serviceReceiver, language,session.getAttribute("custId").toString());
			}
			else if(filename.equals("Sand Boat Association")){
				headers = getHeadersForSandBoatAssociation(serviceReceiver, language,session.getAttribute("custId").toString());
			}
			else if(filename.equals("LOT REPORT")){
				headers = getHeadersForLOTREPORT(serviceReceiver, language,session.getAttribute("custId").toString());
			}
			else if(filename.equals("Quotation_History")){
				headers = getHeadersForQuotationMasterHistoryReport(serviceReceiver,session.getAttribute("customerId").toString(),language);
			}
			
			// *************************************************************************************************************************//
			
			//**********Mining Module(MRF Grade Wise Report)*******************
			else if(filename.equals("MRFGradeWiseReport")){
				headers = getHeadersForMRFGradeWiseReport(serviceReceiver, language, session.getAttribute("custId").toString(),session.getAttribute("date").toString(),session.getAttribute("mineralName").toString(),session.getAttribute("grade").toString());
			}
			
			else if(filename.equals("PlantFeedDetails")){
				headers = getHeadersForPlantFeedDetails(serviceReceiver, language, session.getAttribute("CustName").toString());
			}
			else if(filename.equals("TripFeedDetails")){
				headers = getHeadersForTripFeedDetails(serviceReceiver, language, session.getAttribute("CustName").toString());
			}
			else if(filename.equals("LotDetails")){
				headers = getHeadersForLotDetails(serviceReceiver, language, session.getAttribute("CustName").toString());
			}
			else if(filename.equals("HubArrDepCountReport")){
				headers = getHubArrDepCountReportHeaders(serviceReceiver, language, "");
			}
			
			else if(filename.equals("VehicleBatteryReport")){
				headers = getVehiclebatteryReportHeaders(serviceReceiver, language, session.getAttribute("date").toString());
			}
			else if(filename.equals("OffRoadAlertReport")){
				headers = getOffRoadAlertReportHeaders(serviceReceiver, language, session.getAttribute("date").toString());
			}
			else if(filename.equals("SystemHealthDetails")){
				headers = getSystemHealthDetails(serviceReceiver,language);
			}
			
			else if(filename.equals("APMTTripDetailsReport")){	
				headers = getHeadersForAPMTTripDetailsReport(serviceReceiver, language, session.getAttribute("custName").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
            }
			else if(filename.equalsIgnoreCase("tamperedCrossBorderReport")){
				headers = getHeadersforGpsTamperedReport(serviceReceiver,language,session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString(),session.getAttribute("custName").toString());
			}
			
			else if(filename.equals("ShiftWise Trip Summary Report")){				
				headers = getHeadersForVehicleTripSummaryReport(serviceReceiver, language,
						session.getAttribute("custId").toString(), 
						session.getAttribute("jspName").toString(), 
						session.getAttribute("branchName").toString(), 
						session.getAttribute("shiftName").toString(), 
						session.getAttribute("startDate").toString(), 
						session.getAttribute("endDate").toString(),
				        session.getAttribute("startTime").toString(), 
				        session.getAttribute("endTime").toString());	
			}
			else if(filename.equals("DateWise Trip Summary Report")){				
				headers = getHeadersForVehicleTripSummaryReport2(serviceReceiver, language,
						session.getAttribute("custId").toString(), 
						session.getAttribute("jspName").toString(), 
						session.getAttribute("branchName").toString(), 
						session.getAttribute("startDate").toString(), 
						session.getAttribute("endDate").toString());
				       	
			}
			
			else if(filename.equals("Speeding Report")){				
				headers = getHeadersForSpeedingReport(serviceReceiver, language,
						session.getAttribute("custId").toString(), 
						session.getAttribute("jspName").toString(), 
						session.getAttribute("branchName").toString(), 
						session.getAttribute("startDate").toString(), 
						session.getAttribute("endDate").toString());
				       	
			}
			else if (filename.equals("FuelLogBook")) {
				headers = getHeadersForFuelLogBook(serviceReceiver,language, session.getAttribute("vehId").toString(), session.getAttribute("sdate").toString(), session.getAttribute("edate").toString());
			}
			else if (filename.equals("FuelReset")) {
				headers = getHeadersForFuelReset(serviceReceiver,language, session.getAttribute("vehId").toString(), session.getAttribute("sdate").toString(), session.getAttribute("edate").toString());
			}
			else if (filename.equals("OperationSummaryReportLog")) {
				headers = getHeadersForCityWiseOperationLog(serviceReceiver,session.getAttribute("cusId").toString(),session.getAttribute("cityId").toString(),(String) session.getAttribute("startd1".toString()));
			}
			
			else if(filename.equals("DeviceWireConnectionReport")){	
				headers = getHeadersForDeviceWireConnectionReport(serviceReceiver, language, session.getAttribute("custName").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}
			else if(filename.equals("PermitWiseTripSheets")){
				headers = getHeadersForPermitWiseTripSheets(serviceReceiver, language,session.getAttribute("jspTitle").toString(),session.getAttribute("custName").toString(),session.getAttribute("permitNo").toString());
			}
			else if(filename.equals("BargeTruckTripSheet")){
				headers = getHeadersForBargeTruckTripSheetReport(serviceReceiver, language);
			}
			else if (filename.equals("TripHistory")) {
				headers = getHeadersForTripHistory(serviceReceiver,language, session.getAttribute("branchName").toString(), session.getAttribute("vehId").toString(), session.getAttribute("sdate").toString(), session.getAttribute("edate").toString());
			}
			else if(filename.equals("profitandLossReport")){
				headers = getHeadersForProfitandLossReport(serviceReceiver, language, session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());
			}
			else if(filename.equals("Armory Inventory Details")){
				headers = getHeadersForArmoryInventoryDetails(serviceReceiver, language, session.getAttribute("custName").toString());
			}
			else if(filename.equals("CityWiseCrossBorderReport")){
				headers = getHeadersForCityWiseCrossBorderReport(serviceReceiver, language, session.getAttribute("custName").toString(),session.getAttribute("cityName").toString(),session.getAttribute("startd1").toString());
			}
			else if(filename.equals("routeVehicleAssociation")){
				headers = getHeadersForrouteVehicleAssociation(serviceReceiver, language, session.getAttribute("custName").toString());
			}
			
			else if(filename.equals("OrganizationMaster")||filename.equals("GradeMaster")||filename.equals("Trader Master")||filename.equals("OverSpeedDebarring")||filename.equals("ProductionSummaryReport")){				
				headers = getHeadersForDMGMastersReport(serviceReceiver, language, session.getAttribute("reportName").toString(),session.getAttribute("custName").toString());	
			}
			else if (filename.equals("CashBook")) {
				headers = getHeadersForCashBook(serviceReceiver,language, session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString(), session.getAttribute("openingBal").toString(), session.getAttribute("closingBal").toString());
			}
			else if(filename.equals("MPLBalancesReport")||filename.equals("Ewallet Details")||filename.equals("ImportsExportsReport")||filename.equals("Mother Route Master")){				
				headers = getHeadersForDMGMastersReport(serviceReceiver, language, session.getAttribute("reportName").toString(),session.getAttribute("custName").toString());	
			}
			else if(filename.equals("Wallet Reconciliation Report")){				
				headers = getHeadersForWalletReconciliationReport(serviceReceiver, language, session.getAttribute("reportName").toString(),session.getAttribute("orgName").toString());	
			}
			else if(filename.equals("Stock Reconciliation Report")){				
				headers = getHeadersForStockReconciliationReport(serviceReceiver, language, session.getAttribute("reportName").toString());	
			}
			else if (filename.equals("VehicleLedgerReport")) {
				headers = getHeadersForVehicleLedgerReport(serviceReceiver,language, session.getAttribute("vehId").toString(), session.getAttribute("sdate").toString(), session.getAttribute("edate").toString());
			}else if(filename.equals("DetentionReport")){
				headers = getHeadersForDetentionChargesReport(serviceReceiver,session.getAttribute("branchName").toString(),session.getAttribute("vehicleNo").toString(),
										session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString());
			}
			else if (filename.equals("CashBookReport")) {
				headers = getHeadersForCashBookReport(serviceReceiver,language, session.getAttribute("branch").toString(), session.getAttribute("transacType").toString(),session.getAttribute("year").toString());
			}
			else if (filename.equals("Expense Approval")) {
				headers = getHeadersForExpenseApproval(serviceReceiver,language, session.getAttribute("status").toString(), session.getAttribute("sdate").toString(), session.getAttribute("edate").toString());
			}
			else if (filename.equals("Staff Activity Summary Report")) {
				headers = getHeadersForStaffActivitySummaryReport(serviceReceiver,language, session.getAttribute("groupName").toString(), session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());
			}
			else if (filename.equals("Unblock Sand Vehicles")) {
				headers = getHeadersForUnblockSandVehicles(serviceReceiver,language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString());
			}
			else if (filename.equals("Block And Unblock Vehicles Report")) {
				headers = getHeadersForBlockUnblockVehiclesReport(serviceReceiver,language, session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("type").toString());
			}
			else if(filename.equalsIgnoreCase("VehicleStatusReport")){
				headers = getHeadersforVehicleStatusReport(serviceReceiver,language,session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString(),session.getAttribute("custName").toString(),session.getAttribute("jspTitle").toString());
			}
			else if(filename.equals("Route Master Details")){
				headers = getHeadersForRouteMasterDetails(serviceReceiver, language,session.getAttribute("custId").toString());
			}
			else if (filename.equals("Cashbook_Approval_Reject")) {
				headers = getHeadersForCashBookApproveReject(serviceReceiver,language, session.getAttribute("branch").toString(), session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString(),session.getAttribute("status").toString());
			}
			else if(filename.equals("MDPGeneratorNew")){				
				headers = getHeadersForMDPGeneratorNew(serviceReceiver, language, session.getAttribute("custId").toString());	
			}
			else if (filename.equals("NtcTripDetils")) {
				headers = getHeadersForNtcTripDetails(serviceReceiver,session.getAttribute("cusName").toString());
			}
			else if (filename.equals("SandPortQuantityUpdation")) {
				headers = getHeadersForSandPortQuantityUpdation(serviceReceiver, session.getAttribute("sdate").toString(), session.getAttribute("edate").toString());
			}
			else if(filename.equals("PERMIT REPORT")){	
				headers = getHeadersForPERMITREPORT(serviceReceiver, language, session.getAttribute("custName").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString(),session.getAttribute("mineral").toString(),session.getAttribute("Organizationname").toString());	
			}
			else if(filename.equals("PermitSummaryReport")){				
				headers = getHeadersForPermitSummaryReport(serviceReceiver,session.getAttribute("custName").toString(),session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString(),session.getAttribute("mineralType").toString());	
			}
			else if(filename.equals("Milk_Distribution_Report")){
				headers = getHeadersForMilkDistributionReport(serviceReceiver,session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString(),session.getAttribute("vehicleNo").toString(),session.getAttribute("routeName").toString());
			}
			else if(filename.equals("TripSheetSummaryReport")){
				headers = getheadersForTripSheetSummaryReport(serviceReceiver,session.getAttribute("custName").toString(),session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString(),session.getAttribute("mineralType").toString());	
			}
			else if(filename.equals("Distribution_Details")){
				headers = getHeadersForMilkDistributionPointDetails(serviceReceiver,session.getAttribute("vehicleNo").toString(),session.getAttribute("date").toString(),session.getAttribute("source").toString(),session.getAttribute("routeName").toString(),
						session.getAttribute("schldDepTime").toString(),session.getAttribute("permittedBuffer").toString(),session.getAttribute("actualDepTime").toString());
			}
			else if(filename.equals("MD_Route_Master")){
				headers = getHeadersForMDRouteMasterDestails(serviceReceiver);
			}
			else if(filename.equals("MD_Trip_Management")){
				headers = getHeadersForMDTripDestails(serviceReceiver);
			}
			else if(filename.equals("Trip_Generation")){
				headers = getheadersForTripGenerationReport(serviceReceiver,session.getAttribute("custName").toString());	
			}
			else if(filename.equals("VehicleReporting")){
				headers = getheadersForVehicleReporting(serviceReceiver,session.getAttribute("custName").toString(), session.getAttribute("groupName").toString(), session.getAttribute("dateId").toString());	
			}
			else if(filename.equals("ProductionMaster")){				
				headers = ProductionMaster(serviceReceiver, language, session.getAttribute("reportName").toString(),session.getAttribute("custName").toString(),session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString());	
			}
			else if(filename.equals("Mining DMF Details")){				
				headers = getheadersForMiningDMFDetails(serviceReceiver, language, session.getAttribute("custId").toString(),session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString());	
			}
			else if(filename.equals("ILMSDayWiseDataCapturing")){				
				headers = getheadersILMSDayWiseDataCapturing(serviceReceiver, session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString());	
			}
			else if(filename.equals("ILMSDayWiseDataCapturingInnerGrid")){				
				headers = ILMSDayWiseDataCapturingInnerGrid(serviceReceiver, session.getAttribute("uploadDate").toString());	
			}else if(filename.equals("dtcErrorCodeReport")){
				headers = getHeadersForDTCErrorCodeReport(serviceReceiver, session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString());
			}else if(filename.equals("OBDFuelConsumption")){
				headers = getHeadersFOrOBDFuelConsumptionReport(serviceReceiver, session.getAttribute("vehicleNo").toString(), session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());
			}else if(filename.equals("MDP_Generation_Limit")){
				headers = getHeadersFOrMDP_Generation_LimitReport(serviceReceiver, session.getAttribute("custId").toString(), session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());
			}else if(filename.equals("rakeExpenseMasterDetails")){
				headers = getHeadersFOrRakeExpenseMasterDetails(serviceReceiver);
			}
			if (filename.equals("HubArrivalandDepReport")) {
				headers = getHeadersForHubArrivalandDepReport(serviceReceiver, session.getAttribute("type").toString(), session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString());
			}
			
			if (filename.equals("UnAuthorized Block Entry Report")) {
				headers = getHeadersForUnAuthBlockEntryReport(serviceReceiver,session.getAttribute("cName").toString(),session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString());
			}
			
			else if(filename.equals("SandTPYearlyPermitReport")){				
				headers = getheadersSandTPYearlyPermitReport(serviceReceiver, session.getAttribute("TPNumber").toString(), session.getAttribute("startdate").toString(),session.getAttribute("enddate").toString());	
			}
			else if(filename.equals("LTSP Subscription Payment Setting")){				
				headers = getheadersLTSPSubscriptionReport(serviceReceiver);	
			}
			else if(filename.equals("Vehicle Subscription Details")){				
				headers = getheadersVehicleSubscriptionReport(serviceReceiver,session.getAttribute("custId").toString());	
			}
			
			else if(filename.equals("Trip_Summary_Report")){
				headers = getHeadersForDESTripSummaryReport(serviceReceiver, language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("custId").toString());	
			}
			
			else if(filename.equals("TP Owner Updation")){				
				headers = getheadersTPOwnerUpdationReport(serviceReceiver, session.getAttribute("sysName").toString(), session.getAttribute("customerName").toString());	
			}
			else if(filename.equals("Restrictive Hours Trip Details")){
				headers = getHeadersForRestrictiveHoursTripReport(serviceReceiver, language, session.getAttribute("custName").toString(),session.getAttribute("date").toString() );	
			}
			else if(filename.equals("OBD Report")){
				headers = getHeadersForOBDDHLReport(serviceReceiver, language,session.getAttribute("vehicleNo").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString() );	
			}
			else if(filename.equals("Vehicle Pause Time")){				
				headers = getheadersVehiclePauseTimeReport(serviceReceiver,session.getAttribute("custId").toString());	
			}
			else if(filename.equals("UnitMessageUnion")){				
				headers = getheadersUnitMessageUnionReport(serviceReceiver);	
			}
			else if(filename.equals("Atm Replenishment Report")){
				headers = getHeadersForAtmReplenishmentReport(serviceReceiver, language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("custId").toString());	
			}
			else if(filename.equals("Quotation Report")){
				headers = getHeadersForQuotationReport(serviceReceiver, language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("custId").toString());	
			}
			else if(filename.equals("Trip Operation Report")){
				headers = getHeadersForTripOperationReport(serviceReceiver, language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("custId").toString());	
			}
			else if(filename.equals("Armory Operation Report")){
				headers = getHeadersForArmoryOperationReport(serviceReceiver, language,session.getAttribute("startdate").toString(), session.getAttribute("enddate").toString(),session.getAttribute("custId").toString());	
			}
			else if(filename.equals("sandVehicleMasterDetails")){
				headers = getHeadersForSandVehicleMasterDetails(serviceReceiver);	
			}
			else if(filename.equals("WeighBridgeReport")){
				headers = getHeadersForSandWeighBridgeReport(serviceReceiver,session.getAttribute("custId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}
			else if(filename.equals("Transit_Validity_Violation_Report")){
				headers = getHeadersForTransitViolationReport(serviceReceiver,session.getAttribute("custId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}
			else if(filename.equals("Weigh_Bridge_Violation_Report")){
				headers = getHeadersForWeighBridgeViolationReport(serviceReceiver,session.getAttribute("custId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}
			else if(filename.equals("Order_Details_Report")){
				headers = getHeadersForOrderDetailsReport(serviceReceiver,session.getAttribute("custId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}
			else if(filename.equals("Unrecorded_Weigh_Bridge_Report")){
				headers = getHeadersForUnrecordedWeighBridgeReport(serviceReceiver,session.getAttribute("custId").toString(),session.getAttribute("startDate").toString(), session.getAttribute("endDate").toString());	
			}
			else if (filename.equals("SandTripSummaryReport")) {
				headers = getHeadersForSandTripSummaryReport(serviceReceiver, session.getAttribute("type").toString(), session.getAttribute("startDate").toString(),session.getAttribute("endDate").toString());
			}
			
			
			ArrayList tempFooters = null;
			tempFooters = getFooter(serviceProvider, language);

			ReportHelper Report = new ReportHelper();
			Report = (ReportHelper) session.getAttribute(report);

			ArrayList headerList = new ArrayList();
			ArrayList tempHeaderList = (ArrayList) Report.getHeadersList();
			ArrayList dataList = (ArrayList) Report.getReportsList();

			ReportHelper reportData = new ReportHelper();
			ArrayList data = new ArrayList();
			ArrayList reportdataList = new ArrayList();
			ArrayList hiddenList = new ArrayList();
			ArrayList hiddenHeaderList = new ArrayList();

			dataTypeList = getDataTypeList(tempHeaderList, exportdataType);
			colSpanList = getColSpanList(tempHeaderList);

			ArrayList<String> delListData = new ArrayList<String>();
			ArrayList<Integer> delListCol = new ArrayList<Integer>();

			delListData.add(null);
			delListCol.add(null);

			if (hiddencolumns != null) {
				
				StringTokenizer st = new StringTokenizer(hiddencolumns, ",");
				String indexStr = "";
				while (st.hasMoreTokens()) {
					indexStr = (String) st.nextToken();
					hiddenList.add(Integer.parseInt(indexStr));
					hiddenHeaderList.add(tempHeaderList.get(Integer.parseInt(indexStr)));

					dataTypeList.set(Integer.parseInt(indexStr), null);
					colSpanList.set(Integer.parseInt(indexStr), null);
				}

			}
			for (int j = 0; j < tempHeaderList.size(); j++) {
				headerList.add(tempHeaderList.get(j));
			}

			headerList.removeAll(hiddenHeaderList);
			dataTypeList.removeAll(delListData);
			colSpanList.removeAll(delListCol);

			dataTypeList.add(0, "int");
			colSpanList.add(0, 1);

			headerList.add(0, cf.getLabelFromDB("SLNO", language));
			reportdataList.add(headerList);

			footers = new ArrayList();
			footers = tempFooters;
			if (filteredRecords != null) { 
				ArrayList filterList = new ArrayList();
				String s = filteredRecords;
				StringTokenizer st = new StringTokenizer(s, ",");

				while (st.hasMoreTokens()) {
					filterList.add(st.nextToken());
					reportdataList.add(new ArrayList());
				}
				int counter = 1;
				for (int i = 0; i < dataList.size(); i++) {
					reportData = (ReportHelper) dataList.get(i);
					data = (ArrayList) reportData.getInformationList();
					ArrayList tempData = new ArrayList();
					for (int j = 0; j < data.size(); j++) {
						tempData.add(data.get(j));
					}
						//System.out.println(" tempData "  + tempData);
					if (filterList.contains(String.valueOf(data.get(0)))) {

						int index = filterList.indexOf(String.valueOf(data
								.get(0)));
						Collections.sort(hiddenList);
						for (int k = hiddenList.size() - 1; k >= 0; k--) {
							int in = (Integer) hiddenList.get(k);
							tempData.remove(in);

						}
						tempData.add(0, index + 1);
						counter++;
						reportdataList.set(index + 1, tempData);
					}

				}

			} else {

				for (int i = 0; i < dataList.size(); i++) {

					reportData = (ReportHelper) dataList.get(i);
					data = (ArrayList) reportData.getInformationList();
					ArrayList tempData = new ArrayList();
					ArrayList dataHiddenList = new ArrayList();
					for (int j = 0; j < data.size(); j++) {
						tempData.add(data.get(j));
					}
					for (int k = 0; k < hiddenList.size(); k++) {
						dataHiddenList.add(data
								.get((Integer) hiddenList.get(k)));
					}
					tempData.removeAll(dataHiddenList);
					reportdataList.add(tempData);
				}
			}

			if (type.equals("xls")) {

				try {

					ArrayList<String> startTitleList = new ArrayList<String>();
					startTitleList.add(headers.get(0).toString());
					ArrayList<String> endTitleList = getEndTitleList(footers);
					ArrayList<String> summaryFooterList = FooterList(footers);
					String noOfLPerSheet = properties.getProperty("NoOfLinePerSheet");
					int noOfLinePerSheet=0;
					if(properties.getProperty("NoOfLinePerSheet")!=null){
						noOfLinePerSheet=Integer.parseInt(noOfLPerSheet);
					}

					File f = new File(urlxls);

					ArrayList summaryHeaders = headers;
					summaryHeaders.remove(0);
					reportdataList.remove(0);
					noOfLinePerSheet = reportdataList.size();
					if(filename.equalsIgnoreCase("DriverBehaviourReport")){
						ExportExcelDriverBehaviourReport ee1 = null;
						ee1 = new ExportExcelDriverBehaviourReport(startTitleList, summaryHeaders,
								headerList, colSpanList, dataTypeList,
								reportdataList, summaryFooterList, endTitleList,
								leftAlign, noOfLinePerSheet, f,filename);
						ee1.createExcel();
					}	else {
					
					ExportExcelCreator ee = null;
					if(summaryHeaders.size()>2){
					String headr=(String) summaryHeaders.get(1); //done for certis
					if((startTitleList.toString().contains("CustomerWise Report") || startTitleList.toString().contains("VehicleWise Report"))&&headr.contains("Number of Runs")){
						summaryHeaders.set(1,"Number of Runs : "+ reportdataList.size()+"");
					}
					}
					ee = new ExportExcelCreator(startTitleList, summaryHeaders,
							headerList, colSpanList, dataTypeList,
							reportdataList, summaryFooterList, endTitleList,
							leftAlign, noOfLinePerSheet, f);
					ee.createExcel();
					}
				} catch (Exception e) {
					System.out.println("Exception creating excel : " + e);
					e.printStackTrace();
				}
				try {
					response.setContentType("application/xls");
					response.setHeader("Content-disposition",
							"attachment;filename=" + filename + ".xls");
					FileInputStream fis = new FileInputStream(urlxls);
					DataOutputStream outputStream = new DataOutputStream(
							servletOutputStream);
					byte[] buffer = new byte[1024];
					int len = 0;
					while ((len = fis.read(buffer)) >= 0) {
						outputStream.write(buffer, 0, len);
					}
				} catch (Exception e) {
					System.out.println("Exception opening excel : " + e);
				}

				//
			} else if (type.equals("pdf")) {
				try {
					ArrayList<String> startTitleList = new ArrayList<String>();
					startTitleList.add(headers.get(0).toString());
					ArrayList<String> endTitleList = getEndTitleList(footers);
					ArrayList<String> summaryFooterList = FooterList(footers);
					File f = new File(urlpdf);
					ArrayList summaryHeaders = headers;
					summaryHeaders.remove(0);
					reportdataList.remove(0);
					ExportPDFCreator epc = null;
					String headr=(String) summaryHeaders.get(1); //done for certis
					if((startTitleList.toString().contains("CustomerWise Report") || startTitleList.toString().contains("VehicleWise Report"))&&headr.contains("Number of Runs")){
						summaryHeaders.set(1,"Number of Runs : "+ reportdataList.size()+"");
					}
					PdfPTable pt = createimageHeader(summaryHeaders, systemid,
							clientId, request);
					epc = new ExportPDFCreator(startTitleList, summaryHeaders,
							headerList, colSpanList, dataTypeList,
							reportdataList, summaryFooterList, endTitleList,
							leftAlign,f, language, pt);
					epc.createPDF();

				} catch (Exception e) {
					System.out.println("Exception creating pdf : " + e);
					e.printStackTrace();
				}
				try {
					/** opening PDF file **/

					response.setContentType("application/pdf");
					response.setCharacterEncoding("UTF-8");
					response.setHeader("Content-disposition",
							"attachment;filename=" + filename + ".pdf");
					FileInputStream fis = new FileInputStream(urlpdf);
					DataOutputStream outputStream = new DataOutputStream(
							servletOutputStream);
					byte[] buffer = new byte[1024];
					int len = 0;
					while ((len = fis.read(buffer)) >= 0) {
						outputStream.write(buffer, 0, len);
					}
				} catch (Exception e) {
					System.out.println("Exception opening pdf : " + e);
				}
			}

			servletOutputStream.flush();
			servletOutputStream.close();
		} catch (Exception e) {
			System.out.println("Exception in Report Servlet Ordinary : " + e);
			e.printStackTrace();
		}

		return null;
	}

	private ArrayList getHeadersForVehicleWiseReport(
			String serviceReceiver, String language, String startDate,
			String endDate, String Vehicle,String NoRuns) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("VehicleWise Report : "+serviceReceiver);
		headers.add("Vehicle Number: "+Vehicle);
		headers.add("Number of Runs: "+NoRuns);
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersRealTimeDataReport(
			String serviceReceiver, String language, String RouteId,
			String tripSheetNo) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Real Time Data Report : "+serviceReceiver);
		headers.add("Route Id : "+RouteId);
		headers.add("Trip Sheet Number : "+tripSheetNo);
		return headers;
	}
	private ArrayList getHeadersForCustomerWiseReport(
			String serviceReceiver, String language, String startDate,
			String endDate, String Customer,String NoRuns) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("CustomerWise Report : "+serviceReceiver);
		headers.add("Customer Name: "+Customer);
		headers.add("Number of Runs: "+NoRuns);
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	
	private ArrayList getHeadersForVehicleSubscriptionRenwalReport(
			String serviceReceiver, String language, String startDate,
			String endDate, String Customer) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Vehicle Subscription Renwal Report : "+serviceReceiver);
		headers.add("Customer Name: "+Customer);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	
	private ArrayList getHeadersForSandReconciliationReport(
			String serviceReceiver, String language, String Customer) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Reconciliation  Report : "+serviceReceiver);
		headers.add("Customer Name: "+Customer);
		headers.add("");
		return headers;
	}

	private ArrayList getheadersUnitMessageUnionReport(String serviceReceiver) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Vehicle Message Association Report : "+serviceReceiver);
		return headers;
	}

	private ArrayList getHeadersForHubArrivalandDepReport(String serviceReceiver, String type,String startDate, String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Hub Arrival and Departure Summary Report : "+serviceReceiver);
		headers.add("Type: "+type);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	
	private ArrayList getHeadersFOrOBDFuelConsumptionReport(String serviceReceiver, String vehicleNo, String startDate,	String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Fuel Consumption Report : "+serviceReceiver);
		headers.add("Asset No : "+vehicleNo);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}

	private ArrayList getHeadersForDTCErrorCodeReport(String serviceReceiver, String startDate, String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Error Code Report : "+serviceReceiver);
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}

	private ArrayList getHeadersForMDTripDestails(String serviceReceiver) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Trip Details : "+serviceReceiver);
		return headers;
	}

	private ArrayList getHeadersForMDRouteMasterDestails(String serviceReceiver) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Route Master Details : "+serviceReceiver);
		return headers;
	}

	private ArrayList getHeadersForMilkDistributionPointDetails(String serviceReceiver, String vehicleNo, String date,String source, String routeName,
					String schdldDepTime, String buffer, String actualDepTime) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Distribution Point Details Report : "+serviceReceiver);
		headers.add("Vehicle No : "+vehicleNo);
		headers.add("Date : "+date);
		headers.add("Source : "+source);
		headers.add("");
		headers.add("Route Name : "+routeName);
		headers.add("Scheduled Dep Time : "+schdldDepTime);
		headers.add("Permitted Buffer : "+buffer);
		headers.add("Actula Dep Time : "+actualDepTime);
		return headers;
	}

	private ArrayList getHeadersForMilkDistributionReport(String serviceReceiver, String fromDate, String toDate, String vehicleNo, String routeNo) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Milk Distribution Report : "+serviceReceiver);
		headers.add("From Date : "+fromDate);
		headers.add("To Date : "+toDate);
		if(!vehicleNo.equals("")){
			headers.add("Vehicle No : "+vehicleNo);
		}
		if(!routeNo.equals("")){
			headers.add("Route Name : "+routeNo);
		}
		return headers;
	}
	
	private ArrayList getHeadersForCityWiseOperationLog(String serviceReceiver, String cusName, String cityName, String startd1) {
		ArrayList<String> headers =new ArrayList<String>();
		headers.add("Operation Summary Report :"+serviceReceiver);
		headers.add("Customer  : "+cusName);
		headers.add("City : "+cityName);
		headers.add("Date : "+startd1);
		return headers;
	}

	private ArrayList getHeadersForDetentionChargesReport(String serviceReceiver,String branchName,String vehicleNo,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Detention Charges Report - "+serviceReceiver);
		headers.add("Loading Branch : "+branchName);
		headers.add("Vehicle No : "+vehicleNo);
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}

	private ArrayList getHeadersForCashBook(String serviceReceiver, String language, String startDate, String endDate, String openingBal, String closingBal) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Cash Book - "+serviceReceiver);
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		headers.add("Opening Balance : "+openingBal);
		headers.add("Closing Balance : "+closingBal);
		return headers;
	}
	
	private ArrayList getHeadersForCashBookReport(String serviceReceiver, String language, String branch, String transacType, String year) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Cash Book Report - "+serviceReceiver);
		headers.add("Branch : "+branch);
		headers.add("Transaction Type : "+transacType);
		headers.add("Year : "+year);
		return headers;
	}
	
	private ArrayList getHeadersForCashBookApproveReject(String serviceReceiver, String language, String branch, String startDate, String endDate, String status) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Cash Book Approve reject - "+serviceReceiver);
		headers.add("Branch : "+branch);
		headers.add("Status : "+ status);
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}

	private ArrayList getHeadersForProfitandLossReport(String serviceReceiver,String language, String startDate, String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Profit and Loss Details - "+serviceReceiver);
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForArmoryInventoryDetails(String serviceReceiver, String language, String customerName) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Armory Inventory Details- " + serviceReceiver);
	    headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;
	}
	private ArrayList getHeadersForCityWiseCrossBorderReport(String serviceReceiver, String language, String customerName,String cityName,String startd1) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("CityWiseCrossBorderReport- " + serviceReceiver);
	    headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
	    headers.add(cf.getLabelFromDB("City",language)+" : "+ cityName);
	    headers.add(cf.getLabelFromDB("Date",language)+" : "+ startd1);
	    
		return headers;
	}
	private ArrayList getHeadersForrouteVehicleAssociation(String serviceReceiver, String language, String customerName) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("routeVehicleAssociation- " + serviceReceiver);
	    headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;
	}
	

	private ArrayList getHeadersforjfTripExceptionReport(
			String serviceReceiver, String language, String startDate,
			String endDate, String custName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Trip_Exception_Report", language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language)+" : "+startDate);
		headers.add(cf.getLabelFromDB("End_Date", language)+" : "+endDate);
		
		return headers;
	}
	
	private ArrayList getHeadersforPowerConnectionReport(String serviceReceiver, String language, String startDate,String endDate, String custName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Power_Disconnection_And_Reconnection_Report", language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language)+" : "+startDate);
		headers.add(cf.getLabelFromDB("End_Date", language)+" : "+endDate);
		
		return headers;
	}
	
	private ArrayList getHeadersforjfTripDetailsReport(
			String serviceReceiver, String language, String startDate,
			String endDate, String custName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Trip_Details_Report", language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language)+" : "+startDate);
		headers.add(cf.getLabelFromDB("End_Date", language)+" : "+endDate);
		
		return headers;
	}

	private ArrayList getHeadersForFFMCustomerVisitHistory(
			String serviceReceiver, String language,String sdate,String edate) {
		
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Customer_History", language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date", language)+" : "+edate);
		
		return headers;	
	}
	private ArrayList getHeadersPeakorNonPeakHrsReportDetails(
			String serviceReceiver, String language,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Peak_or_Non-Peak_Hrs_Report_Details",language)+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+startDate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+endDate);
		return headers;
	}


	private ArrayList getHeadersForDailyAssetUtilization(
			String serviceReceiver, String language, String gname, String date) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Daily_AssetUtilization_Report",
				language)
				+ " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Group_Name", language) + " : " + gname);
		headers.add(cf.getLabelFromDB("Date", language) + " : " + date);

		return headers;
	}

	private ArrayList getHeadersForMonthlyAssetUtilization(
			String serviceReceiver, String language, String gname,
			String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Monthly_Asset_Utilization_Report",
				language)
				+ " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Group_Name", language) + " : " + gname);
		headers.add(cf.getLabelFromDB("Start_Date", language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date", language) + " : " + edate);

		return headers;
	}

	private ArrayList getHeadersForDailyAttendance(String serviceReceiver,
			String language, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Daily_Attendance_Report", language)
				+ " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date", language) + " : " + edate);

		return headers;
	}
	private ArrayList getHeadersForSandCommNonCommReport(
			String serviceReceiver, String language) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Non_Communication_Report", language)
				+ " - " + serviceReceiver);

		return headers;
	}
	private ArrayList getHeadersForSandNonCommReport(
			String serviceReceiver, String language) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Non_Communication_Report", language)
				+ " - " + serviceReceiver);

		return headers;
	}
	private ArrayList getHeadersForRMCOperationHourReport(
			String serviceReceiver, String language, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("RMC_Operation_Hour_Report", language)
				+ " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date", language) + " : " + edate);

		return headers;
	}
	private ArrayList getHeadersForUnauthorizedPortEntryReport(
			String serviceReceiver, String language, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Unauthorized_Port_Entry_Report", language)
				+ " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date", language) + " : " + edate);

		return headers;
	}

	private ArrayList getHeadersForYearlyRevenuePermitReport(
			String serviceReceiver, String language, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Yearly_Revenue_Permit_Report", language)
				+ " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date", language) + " : " + edate);
		return headers;
	}
	private ArrayList getHeadersForVehicleUtilization(String serviceReceiver, String language, String custId, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Vehicle_Utilization_During_Working_Days_After_Working_Hrs",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);
		return headers;
	}

	private ArrayList getHeadersForEmployeeInformation(String serviceReceiver,
			String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Employee_Information",language)+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		
		return headers;
	}
	
	private ArrayList getHeadersForTerminalMasterDetails(String serviceReceiver,
			String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Terminal_Master",language)+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		return headers;
	}
	private ArrayList getHeadersForPrepaidCardMasterDetails(String serviceReceiver,
			String language, String custId){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Prepaid_Card_Master",language)+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		return headers;
	}
	private ArrayList getHeadersForVehicleAssociationReport(String serviceReceiver,
			String language, String custId){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Service_Vehicle_Association",language)+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		return headers;
	}
	private ArrayList getHeadersForMonthlyReturnsReport(String serviceReceiver,
			String language, String custId){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Monthly_Returns",language)+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		return headers;
	}
	private ArrayList getHeadersForMRFGradeWiseReport(String serviceReceiver,
			String language, String custId,String date,String mineralName,String grade){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("MRF GradeWise Report" + " - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		headers.add("Date "+" : " + date );
		headers.add("Mineral Name "+" : " + mineralName );
		headers.add("Grade "+" : " + grade );
		return headers;
	}
	
	private ArrayList getHeadersForPlantFeedDetails(String serviceReceiver,
			String language, String custId){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Plant Feed Details" + " - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		return headers;
	}
	private ArrayList getHeadersForTripFeedDetails(String serviceReceiver,
			String language, String custId){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Trip Feed Details" + " - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		return headers;
	}
	private ArrayList getHeadersForLotDetails(String serviceReceiver,
			String language, String custId){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Lot Details" + " - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		return headers;
	}
	private ArrayList getHeadersForMonthlyReturnsDashboardDetailsReport(String serviceReceiver,
			String language, String custId){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Monthly_Returns_Dashboard_Details",language)+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		return headers;
	}
	private ArrayList getHeadersForMonthlyRevenuePermitReport(
			String serviceReceiver, String language, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Yearly_Revenue_Permit_Report", language)
				+ " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date", language) + " : " + edate);
		return headers;
	}

	private ArrayList getHubArrDepCountReportHeaders(String serviceReceiver,
			String language, String custId){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Hub Arr/Dep Count" + " - "+serviceReceiver);
		//headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		return headers;
	}
	
	private ArrayList getVehiclebatteryReportHeaders(String serviceReceiver,
			String language, String date){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Vehicle Battery Voltage Report");
		//headers.add(cf.getLabelFromDB("Customer", langua
		headers.add("Date:"+date);
		return headers;
	}
	
	private ArrayList getOffRoadAlertReportHeaders(String serviceReceiver,String language, String date){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Off Road Alert Report");
		headers.add("Date:"+date);
		return headers;
	}
	
	private ArrayList getSystemHealthDetails(String serviceReceiver, String language) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("System_Health_Details",language)+" - " + serviceReceiver);		
		return headers;
	}
	

	private ArrayList getHeadersForAPMTTripDetailsReport(String serviceReceiver, String language, String customerName, String startdate,String enddate) {
			ArrayList<String> headers = new ArrayList<String>();
			headers.add("APMT TRIP_DETAILS- " + serviceReceiver);
			//headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
			return headers;
		}
	
	private ArrayList getHeadersForDeviceWireConnectionReport(String serviceReceiver, String language, String customerName, String startdate,String enddate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Device/Wire Connection Report- " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+ startdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+ enddate);
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;
	}
	private ArrayList getHeadersForPERMITREPORT(String serviceReceiver, String language, String customerName, String startdate,String enddate,String mineral, String Organizationname) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("PERMIT REPORT- " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+ startdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+ enddate);
		headers.add(cf.getLabelFromDB("Mineral_Type",language)+" : "+ mineral);
		headers.add(cf.getLabelFromDB("Organization_Name",language)+" : "+ Organizationname);
	    return headers;
	}
	private ArrayList getHeadersForPermitSummaryReport(String serviceReceiver,String custName,String startDate,String endDate,String mineralType) {
		ArrayList<String> headers = new ArrayList<String>();
		
		headers.add("Permit Summary Report"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custName);
		headers.add("Mineral Type" + " : " + mineralType);
		headers.add("Start Date" + " : " + startDate);
		headers.add("End Date" + " : " + endDate);
		return headers;
		}
	
	private ArrayList getheadersForTripSheetSummaryReport(String serviceReceiver,String custName,String startDate,String endDate,String mineralType) {
		ArrayList<String> headers = new ArrayList<String>();
		
		headers.add("Permit Summary Report"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custName);
		headers.add("Mineral Type" + " : " + mineralType);
		headers.add("Start Date" + " : " + startDate);
		headers.add("End Date" + " : " + endDate);
		return headers;
		}
	//private ArrayList getHeadersForTripReport(
	//		String serviceReceiver, String language, String sdate, String edate) {
	//	ArrayList<String> headers = new ArrayList<String>();

	//	headers.add(cf.getLabelFromDB("Trip_Report", language) + " - " + serviceReceiver);
	//	headers.add(cf.getLabelFromDB("Duration_From", language) + " : " + sdate);
	//	headers.add(cf.getLabelFromDB("Duration_To", language) + " : " + edate);
	//  	return headers;
	//}


	private ArrayList getHeadersForVehicleEnlisting(String serviceReceiver, String language) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Asset_Enlisting", language)
				+ " - " + serviceReceiver);

		return headers;
	}


	private ArrayList getHeadersForRMCActivityReport(String serviceReceiver,String language,String sdate,String edate) 
	{
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("RMC_Activity_Report",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);


		return headers;
	}
	private ArrayList getHeadersForFuelConsolidatedReport(String serviceReceiver,String CustName,String language,String groupName,String sdate,String edate) 
	{
		ArrayList<String> headers = new ArrayList<String>();
		ArrayList<String> tobeConverted=new ArrayList<String>();
		tobeConverted.add("Fuel_Reports");
		tobeConverted.add("Customer_Name");
		tobeConverted.add("Group_Name");
		tobeConverted.add("Start_Date");
		tobeConverted.add("End_Date");
		ArrayList<String> convertedWords=new ArrayList<String>();
		convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);

		headers.add(convertedWords.get(0)+"-"+serviceReceiver);                //cf.getLabelFromDB("RMC_Operation_Hour_Report",language)+" - " + serviceReceiver);
		headers.add(convertedWords.get(1)+"-"+CustName);
		headers.add(convertedWords.get(2)+"-"+groupName);//cf.getLabelFromDB("Start_Date",language)+" : "+groupName);
		headers.add(convertedWords.get(3)+" : "+sdate);
		headers.add(convertedWords.get(4)+" : "+edate);


		return headers;
	}
	
	private ArrayList getHeadersForKLERequestReport(String serviceReceiver, String language, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("KLE_Request_Information",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}
	
	private ArrayList getHeadersForVehicleMobilizeManagement(String serviceReceiver, String language, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Vehicle_Mobilize_Management_Information",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}
	
	private ArrayList getHeadersForshiftwiseTrip(String serviceReceiver, String language, String sdate,String edate,String vehicleNo) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Shiftwise Trip Details"+" - " + serviceReceiver);		
		headers.add("Start Date"+" : "+sdate);
		headers.add("End Date"+" : "+edate);
		headers.add("Vehicle No"+" : "+vehicleNo);

		return headers;
	}
	private ArrayList getHeadersForConsignmentTrackingUsageReport(String serviceReceiver, String language, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Consignment_Tracking_Usage_Report",language)+" : " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}
	private ArrayList getHeadersForFuelMileageReport(String serviceReceiver, String language, String assetGroupName, String sdate,String edate,String subtotal) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Fuelly_Report_Title",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Asset_Group", language) + " : " + assetGroupName);
		headers.add(cf.getLabelFromDB("Grand_Total_Amount",language)+ " : " + subtotal);
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}

	private ArrayList getHeadersForFuelMileageSummaryReport(String serviceReceiver, String language, String assetGroupName, String sdate,String edate,String subtotal) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Fuel_Mileage_Summary",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Asset_Group", language) + " : " + assetGroupName);
		headers.add(cf.getLabelFromDB("Grand_Total_Amount",language)+ " : " + subtotal);
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}

	private ArrayList getHeadersForPenaltySystemReport(String serviceReceiver,String customerName, String language, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Penalty_System_Details",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : " + customerName);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}
	
	private ArrayList getHeadersForRateMasterReport(String serviceReceiver,String customerName, String language) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Rate_Master_Details",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : " + customerName);
		return headers;
	}
	
	private ArrayList getHeadersForTripPlannerReport(String serviceReceiver,String customerName, String language) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Trip_Planner_Details",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : " + customerName);
		return headers;
	}
		
	private ArrayList getHeadersForQuotationMasterHistoryReport(String serviceReceiver,String customerName, String language) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Quotation_History",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : " + customerName);
		return headers;
	}
	
	private ArrayList getHeadersForSMSReport(String serviceReceiver,String customerName, String language, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("SMS_Report_to_Parent",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : " + customerName);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date", language) + " : " +sdate);
		headers.add(cf.getLabelFromDB("End_Date", language) + " : " +edate);

		return headers;
	}
	
	private ArrayList getMDPCheckingReport(String serviceReceiver, String language, String CustName) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("MDP Checking Report: "+"  - " + serviceReceiver);
		headers.add("Customer Name:" + " : " + CustName);
		return headers;
	}
	private ArrayList getHeadersForMarineVesselLive(String serviceReceiver, String language, String assetNumber, String proximityValue, String groupName,
			String latitude, String longitude, String driverName, String driverNumber, String ownerName, String ownerNumber,
			String lastCommunicatedDate, String communicationStatus) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Vessel_Live_Information",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Vessel_Name", language) + " : " + assetNumber);
		headers.add(cf.getLabelFromDB("Group_Name", language) + " : " + groupName);
		headers.add(cf.getLabelFromDB("Latitude", language) + " : " + latitude);
		headers.add(cf.getLabelFromDB("Longitude", language) + " : " + longitude);
		headers.add(cf.getLabelFromDB("Driver_Name", language) + " : " + driverName);
		headers.add(cf.getLabelFromDB("Driver_Number", language) + " : " + driverNumber);
		headers.add(cf.getLabelFromDB("Owner_Name", language) + " : " + ownerName);
		headers.add(cf.getLabelFromDB("Owner_Number", language) + " : " + ownerNumber);
		headers.add(cf.getLabelFromDB("Last_Communicated", language) + " : " + lastCommunicatedDate);
		headers.add(cf.getLabelFromDB("Communication_Status", language) + " : " + communicationStatus);
		headers.add("Below mentioned vessels are within "+ proximityValue + " Nauticle miles from " + assetNumber);
		return headers;
	}

	private ArrayList getHeadersForMarineVesselHistory(String serviceReceiver, String language, String assetNumber, String sdate, String edate,
			String groupName,String latitude, String longitude, String driverName, String driverNumber, String ownerName, String ownerNumber) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Vessel_History_Analysis",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Vessel_Name", language) + " : " + assetNumber);	
		headers.add(cf.getLabelFromDB("Group_Name", language) + " : " + groupName);
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);
		headers.add(cf.getLabelFromDB("Latitude", language) + " : " + latitude);
		headers.add(cf.getLabelFromDB("Longitude", language) + " : " + longitude);
		headers.add(cf.getLabelFromDB("Driver_Name", language) + " : " + driverName);
		headers.add(cf.getLabelFromDB("Driver_Number", language) + " : " + driverNumber);
		headers.add(cf.getLabelFromDB("Owner_Name", language) + " : " + ownerName);
		headers.add(cf.getLabelFromDB("Owner_Number", language) + " : " + ownerNumber);

		return headers;
	}

	private ArrayList getHeadersForMarineVesselByLocation(String serviceReceiver, String language, String customerName, String latitude, String longitude, String proximity, String date) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Vessel_By_Location_Analysis",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		headers.add(cf.getLabelFromDB("DateTime",language)+" : "+ date);
		headers.add(cf.getLabelFromDB("Latitude", language) + " : " + latitude);	
		headers.add(cf.getLabelFromDB("Longitude",language)+" : "+ longitude);
		headers.add("Below mentioned vessels are within "+ proximity + " Nauticle miles from latitude" + latitude + " and longitude " + longitude);
		return headers;
	}

	private ArrayList getHeadersForTripCreationReport(String serviceReceiver, String language, String customerid, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Trip_Report",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Customer",language) + " : " + customerid);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : " + edate);
		return headers;
	}


	private ArrayList getHeadersForVehicleDelisting(String serviceReceiver, String language) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Asset_Delisting_Report",language)+" - " + serviceReceiver);		
		return headers;
	}

	private ArrayList getHeadersForTaskMaster(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Preventive_Maintenance",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Customer",language)+" : "+ custId);
		return headers;
	}
	
	private ArrayList getHeadersForHubDetails(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("HUB/POI Details "+ " - " + serviceReceiver);	
		headers.add(cf.getLabelFromDB("Customer",language)+" : "+ custId);
		return headers;
	}

	private ArrayList getHeadersForManageTasks(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Manage_Tasks",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Customer",language)+" : "+ custId);
		return headers;
	}


	private ArrayList getHeadersForSweepingManagementSummaryReport(String serviceReceiver, String language, String custId, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Sweeping_Operation_Summary_Report",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}

	private ArrayList getHeadersForWasteManagementSummaryReport(String serviceReceiver, String language, String custId, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Daily_Waste_Management_Summary_Report",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}

	private ArrayList getHeadersForPlantMovementReport(String serviceReceiver, String language, String custId, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Planned_Movement_Report",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}
	//------------------------------------VehicleUtilizationDuringHolidayAndWeekends------------------------------------//
	private ArrayList getHeadersForVehicleUtilizationDuringHolidayAndWeekends(String serviceReceiver, String language, String custId, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Vehicle_Utilization_During_Holidays_And_Weekends",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}
	//--------------------------------------getHeadersForVehicleUtilizationSummaryReport--------------------------------//
	private ArrayList getHeadersForVehicleUtilizationSummaryReport(String serviceReceiver, String language, String custId, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Vehicle_Utilization_Summary_Report",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}
	//---------------------------------------------schoolRouteAllocationReport Start-------------------------------------------------//
	private ArrayList getHeadersForSchoolRouteAlloctionReport(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Route_Details",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		return headers;
	}
	//------------------------------------------------------schoolStydentDetails------------------------------------------------------------//
	private ArrayList getHeadersForSchoolStudentDetailsReport(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Manage_Students",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		return headers;
	}
	//------------------------------------------------------TripsheetForIronMining--------------------------------------------------//
	private ArrayList getHeadersForTripSheetReport(String serviceReceiver, String language, String custId, String sdate,String edate,String groupName) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Trip_Sheet_Report",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add(cf.getLabelFromDB("Asset_Group", language) + " : " + groupName);
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}
	//------------------------------------------------------AssetEnrollmentForIronMining--------------------------------------------------//
	private ArrayList getHeadersForMiningAssetEnrollmentReport(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Mining_Asset_Enrollment",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		return headers;
	}
	private ArrayList getHeadersForContractorInformationReport(String serviceReceiver,
			String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Contractor Information Report"+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		return headers;
	}
	//------------------------------------------------------overSpeedreportForIronMining--------------------------------------------------//
	private ArrayList getHeadersForMiningOverSpeedReport(String serviceReceiver, String language, String custId, String sdate,String edate,String groupName) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Mining_Over_Speed_Report",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add(cf.getLabelFromDB("Asset_Group", language) + " : " + groupName);
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}

	//------------------------------------------------------end---------------------------------------------------//
	
	private ArrayList getHeadersForUtilizationDaysHrs(String serviceReceiver, String language, String custId, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Vehicle_Utilization_During_Working_Days_And_Working_Hours",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}

	private ArrayList getHeadersForVehicleUtilizationDuringWorkingDays(String serviceReceiver, String language, String custId, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Vehicle_Utilization_During_Working_Days",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}

	private ArrayList getHeadersForPreventiveMaintenanceReport(String serviceReceiver, String language, String custId, String sdate,String edate,String type) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Preventive_Services_Report",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add(cf.getLabelFromDB("Report_Type", language) + " : " + type);
		if(type.equals("Service History") || (type.equals("Service OverDue")))
		{
			headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
			headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);
		}else
		{
			headers.add("");
			headers.add("");

		}

		return headers;
	}

	private ArrayList getHeadersForBillingMatrixReport(String serviceReceiver, String language, String ltspId,String month,String billYear,String invoiceNo) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Billing_Matrix_Details",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("LTSP", language) + " : " + ltspId);
		headers.add(cf.getLabelFromDB("Invoice_No", language) + " : " + invoiceNo);
		headers.add(cf.getLabelFromDB("Bill_Month",language)+" : "+month);
		headers.add(cf.getLabelFromDB("Bill_Year",language)+" : "+billYear);
		return headers;
	}

	private ArrayList getHeadersForLidAndValvesReport(String serviceReceiver, String language, String custId, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Lid_And_Valves_Report",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : "+sdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : "+edate);

		return headers;
	}


	private ArrayList getHeadersForAccidentExpenditureSummary(String serviceReceiver, String language, String customerName) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Accident_Expenditure_Summary",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;
	}

	private ArrayList getHeadersForAccidentExpenditureDetails(String serviceReceiver, String language, String customerName, String assetNumber) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Accident_Expenditure_Details",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		headers.add(cf.getLabelFromDB("Asset_Number",language)+" : "+ assetNumber);
		return headers;
	}

	private ArrayList getHeadersForMonitoringFDASReport(String serviceReceiver, String language) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Monitoring_FDAS_Report",language)+" - " + serviceReceiver);		
		return headers;
	}

	//************************************MapView headers***********************************************//
	private ArrayList getHeadersForMapView(String serviceReceiver, String language, String customerName)
	{
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Mapview",language)+" - " + serviceReceiver);	
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;	
	}
	//-----------------------------------Unit Details Headers-------------------------------------------//
	private ArrayList getHeadersForUnitDetailsReport(String serviceReceiver, String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Unit_Details",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;
	}
	
	private ArrayList getHeadersForDayWiseNoShowReport(String serviceReceiver, String language, String customerid, String sdate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Day_Wise_No_Show_Report",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Customer",language) + " : " + customerid);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : " + sdate);
		return headers;
	}
	
	private ArrayList getHeadersForHubArrDepReport(String serviceReceiver, String language , String startdate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Hub_Arrival_Hub_Departure_Report",language)+" - " + serviceReceiver);		
		headers.add(cf.getLabelFromDB("Start_Date",language)+" : " + startdate);
		headers.add(cf.getLabelFromDB("End_Date",language)+" : " + endDate);
		return headers;
	}
	
	private ArrayList sandnwardTripreport(String serviceReceiver, String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Sand_Inward_Trip_Sheet",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;
	}
	
	private ArrayList sandConsumerCreditHeaders(String serviceReceiver, String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Sand_Consumer_Credit_Master",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;
	}
	
	private ArrayList consumerMDPGenerator(String serviceReceiver, String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Consumer_MDP_Generator",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;
	}
	
	private ArrayList ConsumerEnrolmentForm(String serviceReceiver, String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Consumer_Enrolment_Form",language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;
	}
	
	private ArrayList getHeadersforGpsTamperedReport(String serviceReceiver, String language, String startDate,String endDate, String custName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("GPS Tampered Crossed Border Report" +" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language)+" : "+startDate);
		headers.add(cf.getLabelFromDB("End_Date", language)+" : "+endDate);
		
		return headers;
	}
	private ArrayList getHeadersForConsignmentSummaryDetails(String serviceReceiver, String language,String customerName, String region, String consignmentStatus, String fieldCondition,String bookingCustomer) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Consignment_Summary_Details",language)+" - " + serviceReceiver);
		//headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		headers.add(cf.getLabelFromDB("Type",language)+" : "+ fieldCondition);
		if(region.equals("Total"))
		{
			headers.add("");
			
		}else
		{
			headers.add(cf.getLabelFromDB("Region",language)+" : "+ region);
			
		}
		if(consignmentStatus.equals("EastFieldBox"))
		{
			headers.add("");
			
		}else
		{
			headers.add(cf.getLabelFromDB("Status",language)+" : "+ consignmentStatus);
			
		}
		if(bookingCustomer.equals("ALL"))
		{
			headers.add("");
		}else
		{
			headers.add(cf.getLabelFromDB("Booking_Customer",language)+" : "+ bookingCustomer);
		}
		
		if(customerName.equals("ALL"))
		{
			headers.add("");
		}else
		{
			headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		}
		return headers;
	}
	private ArrayList getHeadersForWebServiceTransactionReport(String serviceReceiver, String language, String customerName, String sdate,String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("WebServiceResponseReport - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name",language)+" : "+ customerName);
		return headers;
	}
	
	private ArrayList getHeadersForVehicleMaintanceDetails(String serviceReceiver,
			String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Vehicle Operation Report"+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		return headers;
	}
	
	private ArrayList getHeadersForSandBlockManagementReport(String serviceReceiver,
			String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Sand Block Management Report"+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		return headers;
	}
	
	private ArrayList getHeadersForDivisionInformationReport(String serviceReceiver,
			String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Stockyard Information Report"+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		return headers;
	}
	
	private ArrayList getHeadersForVerticalSummaryReport(String serviceReceiver,
			String language,String ReportName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Vertical_Summary_Report", language) +" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Report_Type",language) +" : "+ReportName);
		return headers;
	}
	
	private ArrayList getHeadersForOrderCompletionDetails(String serviceReceiver,String customerName, String language, String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Order Completion Details  - " + serviceReceiver);
		headers.add("Customer Name : " + customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForRouteDeviation(String serviceReceiver,String customerName, String language, String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Route Deviation Details  - " + serviceReceiver);
		headers.add("Customer Name : " + customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForExcessHalting(String serviceReceiver,String customerName, String language,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Excess Halting Details  - " + serviceReceiver);
		headers.add("Customer Name : " + customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForSameVehicleSameDestination(String serviceReceiver,String customerName, String language, String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Same Vehicle Same Destination Details  - " + serviceReceiver);
		headers.add("Customer Name : " + customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers; 
	}
	private ArrayList getHeadersForMultipleVehicleSameDestination(String serviceReceiver,String customerName, String language, String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Multiple Vehicle Same Destination Details  - " + serviceReceiver);
		headers.add("Customer Name : " + customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForIdleTimeReport(String serviceReceiver,String customerName, String language,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Idle Time Report - " + serviceReceiver);
		headers.add("Customer Name : " + customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForTamparingTurnOffReport(String serviceReceiver,String customerName, String language, String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Tampering Turn Off Report - " + serviceReceiver);
		headers.add("Customer Name : " + customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForCrossBorderReport(String serviceReceiver,String customerName, String language, String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Cross Border Report - " + serviceReceiver);
		headers.add("Customer Name : " + customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForeWayBillVsReachVisits(String serviceReceiver,String customerName, String language, String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("No Of E-WayBill VS Reach Visits - " + serviceReceiver);
		headers.add("Customer Name : " + customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getCustomerMasterReport(String serviceReceiver, String language, String RegionId) {
		ArrayList<String> headers = new ArrayList<String>();

	//	headers.add("Customer Master Report: "+"  - " + serviceReceiver);
	//	headers.add("Report Type:" + " : " + RegionId);
		headers.add(cf.getLabelFromDB("Customer_Master_Report", language) +" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Report_Type",language) +" : "+RegionId);
	
		return headers;
	}
	private ArrayList getHeadersForExecutiveDashBoard(String serviceReceiver,
			String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Executive Dashboard Details"+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		return headers;
	}
	
	private ArrayList getHeadersForSandMiningSummary(String serviceReceiver,
			String language,String sdate1,String edate1) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Summary Of SandMining ROK"+" - "+serviceReceiver);
		headers.add("Start Date:"+sdate1);
		headers.add("End Date:"+edate1);
		return headers;
	}
	
	private ArrayList getHeadersForPartsPendingDetails(String serviceReceiver,
			String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Parts Pending For Approval "+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		return headers;
	}
	private ArrayList getHeadersForTripSummaryReport(String serviceReceiver,
			String language,String startDate,String endDate,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Trip Summary Report "+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForDriverBehaviourReport(String serviceReceiver,String language,String startDate,
				String endDate,String customerName){
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Driving_Behaviour_Report", language)+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date", language)+" : "+startDate);
		headers.add(cf.getLabelFromDB("End_Date", language)+" : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForTripDetailsReport(String serviceReceiver,
			String language,String customerName,String tripNo) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Trip Details Report "+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		headers.add("TripNo : "+tripNo);
		return headers;
	}
	private ArrayList getHeadersForTerminalRouteMasterDetails(String serviceReceiver,
			String language,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Route Master "+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		return headers;
	}
	
	private ArrayList getHeadersForSeatingStructure(String serviceReceiver,
			String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Seating_Structure",language)+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		return headers;
	}
	
	private ArrayList getHeadersForHubMaintenanceReport(String serviceReceiver,
			String language, String custId,String HubName,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Hub_Maintenance_Report", language)  +" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : "+custId);
		headers.add(cf.getLabelFromDB("Hub_Name", language)  + " : "+HubName);
		headers.add(cf.getLabelFromDB("Start_Date", language) + " : "+startDate);
		headers.add(cf.getLabelFromDB("End_Date", language) + " : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForProductionDetails(String serviceReceiver, String language, String custId,String month,String year,String mineral,String category) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Production Of ROM Details"+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		headers.add("Date" + " : " + month+" "+year);
		headers.add("Mineral Type" + " : " + mineral);
		headers.add("Category" + " : " + category);
		return headers;
	}
	
		private ArrayList getHeadersForDeductionClaimedReport(String serviceReceiver, String language, String custId, String monthYear,String mineralName,String deductioinClaimed ) {
		ArrayList<String> headers = new ArrayList<String>();
		
		headers.add("Deduction Claimed Report"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);
		headers.add(cf.getLabelFromDB("Month_Year", language) + " : " + monthYear);
		headers.add(cf.getLabelFromDB("Mineral_Name", language) + " : " + mineralName);
		headers.add("Deductioin Claimed" + " : " + deductioinClaimed);
		return headers;
		}
		private ArrayList getHeadersForSalesDispatchReport(String serviceReceiver, String language, String custId, String monthYear,String mineralName,String grade ) {
		ArrayList<String> headers = new ArrayList<String>();
		
		headers.add("Sales Dispatch Report"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);
		headers.add(cf.getLabelFromDB("Month_Year", language) + " : " + monthYear);
		headers.add(cf.getLabelFromDB("Mineral_Name", language) + " : " + mineralName);
		headers.add("Grade" + " : " + grade);
		return headers;
		}
	//-----------------------------------------------------Reconcilation Report For Ironmining-------------------------------------------
	
	private ArrayList getHeadersForReconcilationReport(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Challan Reconcilation Report"+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		return headers;
	}
	private ArrayList getHeadersForRouteDetailsReport(String serviceReceiver,String custName) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Route_Master_Details_Report"+" - " + serviceReceiver);
		headers.add("Customer" + " : " + custName);
		return headers;
	}
	private ArrayList getHeadersForVehicleReportingDetailsReport(String serviceReceiver,String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Vehicle Reporting Details"+" - " + serviceReceiver);
		headers.add("Customer" + " : " + custId);
		return headers;
	}
	private ArrayList getHeadersForSummaryDetails(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Challan Details"+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		return headers;
	}
	private ArrayList getHeadersForMineDetails(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Mine Details"+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		return headers;
	}
	private ArrayList getHeadersForTicketDetails(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Ticket Details"+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		return headers;
	}
	
	private ArrayList getHeadersForProfitandLoss(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Ticket Details"+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		return headers;
	}
	//
	private ArrayList getHeadersForManageRouteDetails(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Manage Route"+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer", language) + " : " + custId);
		return headers;
	}
	private ArrayList getHeadersForMonitoringDashboardDetails(String serviceReceiver, String language,String fromDate,String toDate,String fromLocation,String toLocation,String Type,String tripstatus) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Operational Dashboard"+" - " + serviceReceiver);
		headers.add("From Date" + " : " + fromDate);
		headers.add("To Date" + " : " + toDate);
		headers.add("From Location" + " : "+fromLocation);
		headers.add("To Location" + " : "+toLocation);
		headers.add("Type" + " : "+Type);
		headers.add("Trip Status" + " : "+tripstatus);
		return headers;
	}
	private ArrayList getHeadersForSandInwardReportDetails(String serviceReceiver, String language, String sdate ,String ddate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Sand Inward Report "+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date", language) + " : " + ddate);
		return headers;
	}
	private ArrayList getHeadersForSandBoatReportDetails(String serviceReceiver, String language, String sdate ,String ddate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Sand Boat Report "+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date", language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date", language) + " : " + ddate);
		return headers;
	}
	private ArrayList getHeadersForVehWithoutGPSDetails(String serviceReceiver, String language) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("eWayBill Without GPS Report "+" - " + serviceReceiver);
		
		return headers;
	}
	private ArrayList getHeadersForEmploymentDetails(String serviceReceiver, String language, String custId,String month,String mineralName,String labour,String workPlace ) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Employment And Wages Paid Report"+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : " + custId);
		headers.add("Month/Year"+" - " + month);
		headers.add("Mineral Name"+" - " + mineralName);
		headers.add("Labour"+" - " + labour);
		headers.add("WorkPlace"+" - " + workPlace);
		
		return headers;
	}
	private ArrayList getHeadersForTicketSummaryReport(String serviceReceiver, String language, String custId,String type,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
       int type1=Integer.parseInt(type);
		if(type1==1){
		headers.add("Route Wise Ticket Summary" +" - " + serviceReceiver);
		}
		else if(type1==2){
			headers.add("Ticket Sold By Web/Mobile (Daily)" +" - " + serviceReceiver);
			}
		else if(type1==3){
			headers.add("Ticket Sold By Web/Mobile (Monthly)" +" - " + serviceReceiver);
			}
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : " + custId);
		headers.add(" ");
		headers.add("Start Date"+" - " + startDate);
		headers.add("End Date"+" - " + endDate);
		return headers;
	}
	
	private ArrayList getHeadersForVehicleTripSummaryReport(String serviceReceiver, String language, String custId,String reportName,String branchName,String shiftName,String startDate,String endDate, String startTime,String endTime) {
		ArrayList<String> headers = new ArrayList<String>();
     
		headers.add(reportName+" - " + serviceReceiver);
		
		headers.add("Customer Name " + " : " + custId);
		headers.add("Group Name - "+branchName);		
		headers.add("Start Date"+" - " + startDate);
		headers.add("End Date"+" - " + endDate);
		headers.add("Shift Name - "+shiftName);
		headers.add("");
		System.out.println(" shiftName in action class  === "+shiftName);
		if(( startTime != null && !startTime.equals("") && endTime != null && !endTime.equals("") )){
			if(!shiftName.equalsIgnoreCase("ALL")){
			headers.add("Shift Start Time"+" - " + startTime);
			headers.add("Shift End Time - "+endTime);	
		}
		}
		return headers;
	}
	
	private ArrayList getHeadersForVehicleTripSummaryReport2(String serviceReceiver, String language, String custId,String reportName,String branchName,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
     
		headers.add(reportName+" - " + serviceReceiver);
		
		headers.add("Customer Name " + " : " + custId);
		headers.add("Group Name - "+branchName);		
		headers.add("Start Date"+" - " + startDate);
		headers.add("End Date"+" - " + endDate);
		
		return headers;
	}
	
	private ArrayList getHeadersForSpeedingReport(String serviceReceiver, String language, String custId,String reportName,String branchName,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
     
		headers.add(reportName+" - " + serviceReceiver);
		
		headers.add("Customer Name " + " : " + custId);
		headers.add("Group Name - "+branchName);		
		headers.add("Start Date"+" - " + startDate);
		headers.add("End Date"+" - " + endDate);
		
		return headers;
	}
	
	private ArrayList getHeadersForMineFeedDetails(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Mine Feed Details"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);
		return headers;
	}
	
	private ArrayList getHeadersForInterswitchTransaction(String serviceReceiver, String language, String custId,String fromdate,String todate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Interswitch Transaction Details" +
				""+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);
		headers.add(" ");
		headers.add("From Date"+" - " + fromdate);
		headers.add("To Date"+" - " + todate);
		return headers;
	}
	
	private ArrayList getHeadersForStockYardMaster(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("StockYard Master"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);		
		return headers;
	}
	
	private ArrayList getHeadersForRouteDensityReport(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Route Density Report"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);		
		return headers;
	}
	private ArrayList getHeadersForTripReport(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Trip Details"+" - " + serviceReceiver);
		return headers;
	}
	
	private ArrayList getHeadersForChallanDetails(String serviceReceiver, String language, String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Challan Details"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);		
		return headers;
	}
	private ArrayList getheadersForMiningDMFDetails(String serviceReceiver, String language, String custId,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("DMF Details"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);		
		headers.add("");	
		headers.add("Start Date" + " : " + startDate);
		headers.add("End Date" + " : " + endDate);
		return headers;
	}
	
	private ArrayList getHeadersForMiningTripSheetGeneration(String serviceReceiver, String language,String startDate,String endDate, String custId,String jspPageName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(jspPageName+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);	
		headers.add("");	
		headers.add("Start Date" + " : " + startDate);
		headers.add("End Date" + " : " + endDate);
		return headers;
	}
	
	private ArrayList getHeadersForMiningTripSheetGenerationForTruck(String serviceReceiver, String language) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Mining Trip Sheet Generation"+" - " + serviceReceiver);
		return headers;
	}
	
	private ArrayList getHeadersForPermitDetails(String serviceReceiver, String language,String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Permit Details"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);	
		return headers;
	}
	private ArrayList getHeadersForGPSTamperingDetails(String serviceReceiver, String language,String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("GPS Tampering Details"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);	
		return headers;
	}
	private ArrayList getHeadersForTcMasterDetails(String serviceReceiver, String language,String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Tc Master Details"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);	
		return headers;
	}
	private ArrayList getHeadersForOwnerMasterDetails(String serviceReceiver, String language,String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Owner Master Details"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);	
		return headers;
	}
	private ArrayList getHeadersForPlantMasterDetails(String serviceReceiver, String language,String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Plant Master Details"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);	
		return headers;
	}
	private ArrayList getHeadersForSandBoatAssociation(String serviceReceiver, String language,String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Sand Boat Association Details"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);	
		return headers;
	}
	private ArrayList getHeadersForLOTREPORT(String serviceReceiver, String language,String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("LOT REPORT"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);	
		return headers;
	}
	private ArrayList getHeadersForFuelLogBook(
			String serviceReceiver,String language, String vehId, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Fuel_Log_Book_Title",language) + " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Vehicle_Number",language) + " : " + vehId);
		headers.add(" ");
		headers.add(cf.getLabelFromDB("Start_Date",language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date",language) + " : " + edate);
		return headers;
	}
	private ArrayList getHeadersForFuelReset(String serviceReceiver,String language, String vehId, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Reset_Fuel",language) + " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Vehicle_Number",language) + " : " + vehId);
		headers.add(" ");
		headers.add(cf.getLabelFromDB("Start_Date",language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date",language) + " : " + edate);
		return headers;
	}
	private ArrayList getHeadersForPermitWiseTripSheets(String serviceReceiver, String language,String title,String custName,String permitNo) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(title+" - " + serviceReceiver);
		headers.add("Customer Name"+" : "+custName);
		headers.add("Permit No"+" : "+permitNo);
		return headers;
	}
	private ArrayList getHeadersForBargeTruckTripSheetReport(String serviceReceiver, String language) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Barge Truck Trip Sheet Report"+" - " + serviceReceiver);
		return headers;
	}
	private ArrayList getHeadersForTripHistory(
			String serviceReceiver,String language, String branchName, String vehId, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Trip_History_Report",language) + " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Loading_Branch_Name",language) + " : " + branchName);
		headers.add(cf.getLabelFromDB("Vehicle_Number",language) + " : " + vehId);
		headers.add(cf.getLabelFromDB("Start_Date",language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date",language) + " : " + edate);
		return headers;
	}
	private ArrayList getHeadersForDMGMastersReport(
			String serviceReceiver,String language, String reportName, String custName) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(reportName+ " - " + serviceReceiver);
		headers.add("Customer Name"+ " : " + custName);
		return headers;
	}
	
	private ArrayList getHeadersForWalletReconciliationReport(
			String serviceReceiver,String language, String reportName, String custName) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(reportName+ " - " + serviceReceiver);
		return headers;
	}
	private ArrayList getHeadersForStockReconciliationReport(
			String serviceReceiver,String language, String reportName) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(reportName+ " - " + serviceReceiver);
		return headers;
	}
	private ArrayList getHeadersForEwalletDetails(String serviceReceiver, String language,String title,String custName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(title+" - " + serviceReceiver);
		headers.add("Customer Name"+" : "+custName);
		return headers;
	}
	private ArrayList getHeadersForVehicleLedgerReport(
			String serviceReceiver,String language, String vehId, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB("Vehicle_Ledger_Report",language) + " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Vehicle_Number",language) + " : " + vehId);
		headers.add(" ");
		headers.add(cf.getLabelFromDB("Start_Date",language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date",language) + " : " + edate);
		return headers;
	}
	private ArrayList getHeadersForExpenseApproval(
			String serviceReceiver,String language, String status, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(cf.getLabelFromDB("Expense_Approval_Reject_Report",language) + " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Status",language) + " : " + status);
		headers.add(" ");
		headers.add(cf.getLabelFromDB("Start_Date",language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date",language) + " : " + edate);
		return headers;
	}
	private ArrayList getHeadersForStaffActivitySummaryReport(String serviceReceiver,String language, String groupName, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Staff Activity Summary Report" + " - " + serviceReceiver);
		headers.add("Group Name" + " : " + groupName);
		headers.add(" ");
		headers.add(cf.getLabelFromDB("Start_Date",language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date",language) + " : " + edate);
		return headers;
	}private ArrayList getHeadersForUnblockSandVehicles(String serviceReceiver,String language, String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Unblock Sand Vehicles" + " - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Start_Date",language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date",language) + " : " + edate);
		return headers;
	}
	private ArrayList getHeadersForBlockUnblockVehiclesReport(String serviceReceiver,String language, String sdate, String edate,String type) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("Block And Unblock Vehicles Report" + " - " + serviceReceiver);
		headers.add("Type" + " : " + type);
		headers.add(cf.getLabelFromDB("Start_Date",language) + " : " + sdate);
		headers.add(cf.getLabelFromDB("End_Date",language) + " : " + edate);
		return headers;
	}
	private ArrayList getHeadersforVehicleStatusReport(String serviceReceiver, String language, String startDate,String endDate, String custName,String jspTitle) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add(cf.getLabelFromDB(jspTitle, language)+" - " + serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language)+" : "+custName);
		if(jspTitle.equals("In_Transit_Vehicles_Report")){
		headers.add("");
		headers.add(cf.getLabelFromDB("Start_Date", language)+" : "+startDate);
		headers.add(cf.getLabelFromDB("End_Date", language)+" : "+endDate);
		}
		return headers;
	}
	private ArrayList getHeadersForRouteMasterDetails(String serviceReceiver, String language,String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Route Master Details"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);	
		return headers;
	}
	private ArrayList getHeadersForMDPGeneratorNew(String serviceReceiver, String language,String custId) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("MDPGeneratorNew"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custId);	
		return headers;
	}
	
	private ArrayList getHeadersForNtcTripDetails(String serviceReceiver, String cusName) {
		ArrayList<String> headers =new ArrayList<String>();
		headers.add("NTC Trip Details Report :"+serviceReceiver);
		headers.add("Customer  : "+cusName);
		return headers;
	}
	private ArrayList getHeadersForSandPortQuantityUpdation(
			String serviceReceiver,String sdate, String edate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Sand Port Quantity Updation" + " - " + serviceReceiver);
		headers.add("Start Date" + " : " + sdate);
		headers.add("End Date" + " : " + edate);
		return headers;
	}
	private ArrayList getheadersForTripGenerationReport(String serviceReceiver,String custName) {
		ArrayList<String> headers = new ArrayList<String>();
		
		headers.add("Trip Generation Report"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custName);
		return headers;
		}
	private ArrayList getheadersForVehicleReporting(String serviceReceiver,String custName, String groupName, String dateId ) {
		ArrayList<String> headers = new ArrayList<String>();
		
		headers.add("Vehicle Reporting"+" - " + serviceReceiver);
		headers.add("Customer Name" + " : " + custName);
		headers.add("Group Name" + " : " + groupName);
		headers.add("Date" + " : " + dateId);
		return headers;
		}
	private ArrayList ProductionMaster(
			String serviceReceiver,String language, String reportName, String custName,String startDate, String endDate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add(reportName+ " - " + serviceReceiver);
		headers.add("Customer Name"+ " : " + custName);
		headers.add("");
		headers.add("From Date"+ " : " + startDate);
		headers.add("To Date"+ " : " + endDate);
		return headers;
	}
	private ArrayList getheadersILMSDayWiseDataCapturing(
			String serviceReceiver, String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("ILMS Data Capturing Count Details"+ " - " + serviceReceiver);
		headers.add("Customer Name"+ " : " + serviceReceiver);
		headers.add("");
		headers.add("From Date"+ " : " + startDate);
		headers.add("To Date"+ " : " + endDate);
		
		return headers;
	}
	private ArrayList ILMSDayWiseDataCapturingInnerGrid(
			String serviceReceiver, String uploadDate ) {
		ArrayList<String> headers = new ArrayList<String>();

		headers.add("ILMS Data Capturing"+ " - " + serviceReceiver);
		headers.add("Customer Name"+ " : " + serviceReceiver);
		headers.add("Upload Date"+ " : " + uploadDate);
		
		return headers;
	}
	private ArrayList getHeadersFOrMDP_Generation_LimitReport(String serviceReceiver, String custName, String startDate,	String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("MDP Generation Limit Report : "+serviceReceiver);
		headers.add("Customer Name: "+custName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersFOrRakeExpenseMasterDetails(String serviceReceiver) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Rake Expense Master Report  : "+serviceReceiver);
		return headers;
	}
	private ArrayList getHeadersForUnAuthBlockEntryReport(String serviceReceiver, String customerName, String startDate, String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Un Authorized Block Entry Report : "+serviceReceiver);
		headers.add("Customer Name: "+customerName);
		headers.add("");
		headers.add("Start Date: "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getheadersSandTPYearlyPermitReport(String serviceReceiver, String TPNumber,String startDate, String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("TP Wise Yearls Transaction Report : "+serviceReceiver);
		headers.add("TP Number :"+TPNumber);
		headers.add("Year : "+startDate + "-" +endDate);
		return headers;
	}
	private ArrayList getheadersLTSPSubscriptionReport(String serviceReceiver) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("LTSP Subscription Report : "+serviceReceiver);
		return headers;
	}
	private ArrayList getheadersVehicleSubscriptionReport(String serviceReceiver,String custName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Vehicle Subscription Report : "+serviceReceiver);
		headers.add("Customer Name : "+custName);
		return headers;
	}
	private ArrayList getHeadersForDESTripSummaryReport(String serviceReceiver,
			String language,String startDate,String endDate,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Trip Summary Report "+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getheadersTPOwnerUpdationReport(String serviceReceiver, String sysName,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Tp Owner Details : "+serviceReceiver);
		headers.add("LTSP :"+sysName);
		headers.add("Customer Name : "+customerName);
		return headers;
	}
	private ArrayList getHeadersForRestrictiveHoursTripReport(String serviceReceiver,
			String language,String customerName, String date) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Restrictive Hours Trip Details Report"+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		headers.add(cf.getLabelFromDB("Date", language) + " : "+date);
		return headers;
	}
	private ArrayList getHeadersForOBDDHLReport(String serviceReceiver,String language,String vehicleNo, String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("OBD Report Details : "+serviceReceiver);
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		headers.add("Vehicle No : "+vehicleNo);
		return headers;
	}
	private ArrayList getheadersVehiclePauseTimeReport(String serviceReceiver,String custName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Vehicle Pause Time Report : "+serviceReceiver);
		headers.add("Customer Name : "+custName);
		return headers;
	}
	private ArrayList getHeadersForQuotationReport(String serviceReceiver,
			String language,String startDate,String endDate,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Quotation Report "+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForTripOperationReport(String serviceReceiver,
			String language,String startDate,String endDate,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Trip Operation Report "+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForAtmReplenishmentReport(String serviceReceiver,
			String language,String startDate,String endDate,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Atm Replenishment Report"+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForArmoryOperationReport(String serviceReceiver,
			String language,String startDate,String endDate,String customerName) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Armory Operation Report "+" - "+serviceReceiver);
		headers.add(cf.getLabelFromDB("Customer_Name", language) + " : "+customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForSandVehicleMasterDetails(String serviceReceiver) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Vehicle Master Report  : "+serviceReceiver);
		return headers;
	}
	private ArrayList getHeadersForSandWeighBridgeReport(String serviceReceiver,
			String customerName,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Weigh Bridge Report "+" - "+serviceReceiver);
		headers.add("Customer Name" + " : "+customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForTransitViolationReport(String serviceReceiver,
			String customerName,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Transit Pass Report "+" - "+serviceReceiver);
		headers.add("Customer Name" + " : "+customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForWeighBridgeViolationReport(String serviceReceiver,
			String customerName,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Weigh Bridge Report "+" - "+serviceReceiver);
		headers.add("Customer Name" + " : "+customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForOrderDetailsReport(String serviceReceiver,
			String customerName,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Order Details Report "+" - "+serviceReceiver);
		headers.add("Customer Name" + " : "+customerName);
		headers.add("");
		//headers.add("Start Date : "+startDate);
		//headers.add("End Date : "+endDate);
		return headers;
	}
	private ArrayList getHeadersForUnrecordedWeighBridgeReport(String serviceReceiver,
			String customerName,String startDate,String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Unrecorded Weigh Bridge Report "+" - "+serviceReceiver);
		headers.add("Customer Name" + " : "+customerName);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	
	private ArrayList getHeadersForSandTripSummaryReport(String serviceReceiver, String type,String startDate, String endDate) {
		ArrayList<String> headers = new ArrayList<String>();
		headers.add("Sand Trip Summary Report  : "+serviceReceiver);
		headers.add("");
		headers.add("Start Date : "+startDate);
		headers.add("End Date : "+endDate);
		return headers;
	}
	
	/** 
	 * headers alignment
	 * @return
	 */
	public ArrayList getHeaderAlignment()
	{
		ArrayList headerAlign = new ArrayList();
		headerAlign.add(0);
		return headerAlign;
	}

	/**
	 * Footers alignment
	 * @return
	 */
	public ArrayList getFooterAlignment(){
		ArrayList footerAlign = new ArrayList();
		footerAlign.add(1);
		return footerAlign;
	}

	/**
	 * creating the directory if not present
	 * @param reportpath
	 */
	private void refreshdir(String reportpath)
	{
		File f = new File(reportpath);
		if(!f.exists())
		{
			f.mkdir();
		}
	}

	/**
	 * Default footer defnition
	 * @param serviceProvider
	 * @param language
	 * @return
	 */
	public ArrayList getFooter(String serviceProvider,String language)
	{
		ArrayList<String> tobeConverted=new ArrayList<String>();
		tobeConverted.add("Service_Delivered_By");
		ArrayList<String> convertedWords=new ArrayList<String>();
		convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
		ArrayList footers = new ArrayList();
		footers.add(convertedWords.get(0)+" - "+serviceProvider);
		return footers;
	}

	/**
	 * Generating data type
	 * @param headers
	 * @param exportdataType
	 * @return
	 */
	public ArrayList<String> getDataTypeList(ArrayList headers,String exportdataType)
	{
		ArrayList<String> dataTypeList = new ArrayList<String>();

		String dataType[] = exportdataType.split(",");
		if(dataType.length > 0)
		{
			for(int i = 0; i < dataType.length; i ++)
			{
				dataTypeList.add(dataType[i]);
			}
		}
		else
		{
			for(int i = 0; i < headers.size(); i ++)
			{
				dataTypeList.add("string");
			}
		}

		return dataTypeList;
	}

	/**
	 * Generating column span
	 * @param headers
	 * @return
	 */
	public ArrayList<Integer> getColSpanList(ArrayList headers)
	{
		ArrayList<Integer> colSpanList = new ArrayList<Integer>();

		for(int i = 0; i < headers.size(); i ++)
		{
			colSpanList.add(1);
		}

		return colSpanList;
	}

	/**
	 * Generating excel footer
	 * @param footers
	 * @return
	 */
	public ArrayList FooterList(ArrayList footers)
	{
		ArrayList<String> excelFooterSummary = new ArrayList<String>();
		if(footers != null && footers.size() > 0)
		{
			String footerStr = (String)footers.get(0);
			StringTokenizer st = new StringTokenizer(footerStr,"\n");
			while(st.hasMoreTokens())
			{
				String footer = (String)st.nextToken();
				excelFooterSummary.add(footer);
			}
		}
		return excelFooterSummary;
	}

	/**
	 * Adding end title 
	 * @param footers
	 * @return
	 */
	public ArrayList getEndTitleList(ArrayList footers)
	{
		ArrayList<String> endTitleList = new ArrayList<String>();
		if(footers != null && footers.size() > 1)
		{
			String endTitleStr = (String)footers.get(1);
			endTitleList.add(endTitleStr);
		}
		return endTitleList;
	}

	/**
	 * Adjusting the widths for excel cell
	 * @param headerList
	 * @return
	 */
	public float[] getLocationAdjustedCellWidths(ArrayList headerList)
	{
		float total = 100;
		int headerSize = headerList.size();
		float widths[] = new float[headerSize];
		float normalWidth = total / headerSize;

		for(int i = 0; i < headerSize; i ++)
		{
			widths[i] = normalWidth;
		}

		return widths;
	}



	public PdfPTable getPdfTable1(ArrayList headers, String systemid, String
			clientId, HttpServletRequest request) { PdfPTable t = new PdfPTable(1);
			float[] widths = { 100 }; PdfPCell c1;



			try { t.setWidthPercentage(100); t.setWidths(widths);
			t.getDefaultCell().setBorder(0); t.setHorizontalAlignment(1);


			Properties properties = null;
			try 
			{
				properties = ApplicationListener.prop;
			} 
			catch (Exception e) 
			{
				e.printStackTrace();
			}
			String fontpath=properties.getProperty("FontPath");
			String encoding = "Identity-H";
			Font fontNormal = FontFactory.getFont(fontpath+"ARIALUNI.TTF", encoding, BaseFont.EMBEDDED, 8, Font.NORMAL);

			Chunk chunkA = new Chunk("" + "\n",fontNormal);
			Phrase myPhrase=new Phrase(chunkA);

			c1= new PdfPCell(myPhrase); c1.setBorder(0);
			c1.setHorizontalAlignment(1); t.addCell(c1);


			} catch (Exception e) {
				System.out.println("Exception creating pdf header : " + e);
				e.printStackTrace(); } return t; }


	/***************************** Setting client logo and T4U logos for PDF file ************************************/

	private PdfPTable createimageHeader(ArrayList headers, String systemid,
			String clientId, HttpServletRequest request) {

		float[] widths = { 2, 16, 64, 16, 2 };
		PdfPTable t = new PdfPTable(5);
		Connection con = null;
		Connection con1 = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {

			t.setWidthPercentage(100);
			t.setWidths(widths);
			Phrase blankphrase = new Phrase(" ");

			PdfPCell blankcell = new PdfPCell(blankphrase);
			blankcell.setBorder(0);
			blankcell.setHorizontalAlignment(0);
			t.addCell(blankcell);

			String imgName = "";
			boolean exists = false;
			String ltspLogo = "";
			Image img1 = null;
			
			Properties properties = null;
			try {
				properties = ApplicationListener.prop;
			} catch (Exception e) {
				e.printStackTrace();
			}
			try {

				con1 = DBConnection.getConnectionToDB("ADMINISTRATOR");
				pstmt = con1.prepareStatement(" select isNull(SHOW_LOGO,'') as SHOW_LOGO from ADMINISTRATOR.dbo.CUSTOMER_MASTER where CUSTOMER_ID=? and SYSTEM_ID=? ");
				pstmt.setInt(1, Integer.parseInt(clientId));
				pstmt.setString(2, systemid);
				rs = pstmt.executeQuery();
				if (rs.next()) {
					ltspLogo = rs.getString("SHOW_LOGO");
				}

			} catch (Exception e) {
				System.out.println("Error in getting showLtsplogo.." + e);
			}
			
			String imagepath = properties.getProperty("ImagePath");
			if (ltspLogo.equalsIgnoreCase("Y")) {
				if (Integer.parseInt(clientId) != 0) {
	
					imgName = imagepath + "custlogo_" + systemid + "_" + clientId
					+ ".gif";
	
					System.out.println("imgName..WHEN SYSTEMID!=0..." + imgName);
					System.out.println("Image path" + imagepath);
	
					File f = new File(imagepath + "custlogo_" + systemid + "_"
							+ clientId + ".gif");
	
					if (f.exists()) {
						exists = true;
					}
	
				}
				if (Integer.parseInt(clientId) == 0 || !exists) {
					imgName = imagepath + "custlogo_" + systemid + ".gif";

					System.out.println("imgName.. WHEN CLIENT ID==0--" + imgName);
				}
				img1 = Image.getInstance(imgName);
			}

			PdfPCell cell = new PdfPCell();
			cell.setHorizontalAlignment(0);

			cell.addElement(img1);
			cell.setBorderColor(BaseColor.WHITE);
			t.addCell(cell);


			PdfPTable pt = getPdfTable1(headers, systemid, clientId,
					request); PdfPCell c = new PdfPCell(pt);
					c.setBorder(Rectangle.NO_BORDER); c.setHorizontalAlignment(1);
					t.addCell(c);

					String path1 = "";
					Image img2 = null;
					String logonew = "";
					// =====================================================================================
					try {

						con = DBConnection.getConnectionToDB("AMS");
						pstmt = con
						.prepareStatement(" select Show_t4u_logo from AMS.dbo.System_Master where System_id=? ");
						pstmt.setString(1, systemid);
						rs = pstmt.executeQuery();
						if (rs.next()) {
							logonew = rs.getString("Show_t4u_logo");
						}

					} catch (Exception e) {
						System.out.println("Error in getting showlogo.." + e);
					}

					// =====================================================================================
					if (logonew.equalsIgnoreCase("Yes")) {
						path1 = imagepath + "t4u_White_logo1.gif";

						System.out.println("imgName...NEW LOGO.." + path1);
						img2 = Image.getInstance(path1);
					}
					PdfPCell cell1 = new PdfPCell();
					cell1.setHorizontalAlignment(0);
					// cell1.setBorderColor(Color.white);
					cell1.setBorderColor(BaseColor.WHITE);					
					cell1.addElement(img2);
					t.addCell(cell1);

					PdfPCell blankcell1 = new PdfPCell(blankphrase);
					blankcell1.setBorder(0);
					blankcell1.setHorizontalAlignment(0);
					t.addCell(blankcell1);
		} catch (Exception e) {
			System.out.println("Error creating Builty details : " + e);
			e.printStackTrace();
		} finally {
			DBConnection.releaseConnectionToDB(con, pstmt, rs);
			DBConnection.releaseConnectionToDB(con1, null, null);
		}

		return t;
	}

}
