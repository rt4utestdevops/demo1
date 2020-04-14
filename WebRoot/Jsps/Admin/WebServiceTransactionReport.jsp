<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	loginInfo.setStyleSheetOverride("N");
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());

	}
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
    
 if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
  
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Web_Service_Transaction_Report");
tobeConverted.add("Type");
tobeConverted.add("Select_Type");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("SLNO");
tobeConverted.add("Asset_Number");
tobeConverted.add("Service_Name");
tobeConverted.add("Excel");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Last_Service_Date");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Expiry_Date");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Please_Select_Report_Type");
tobeConverted.add("Please_Select_Start_Date");
tobeConverted.add("Please_Select_End_Date");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Shipment");
tobeConverted.add("Data");
tobeConverted.add("Status");
tobeConverted.add("Date&Time");
tobeConverted.add("Trip_Id");
tobeConverted.add("Trip_Start_Time");
tobeConverted.add("Received_Time");
tobeConverted.add("Sequence");
tobeConverted.add("Location_Id");
tobeConverted.add("Latitude");
tobeConverted.add("Longitude");
tobeConverted.add("Push_Status");
tobeConverted.add("In_Time");
tobeConverted.add("Out_Time");
tobeConverted.add("Closed_Time");
tobeConverted.add("Re_Pushed");
tobeConverted.add("Park_Name");
tobeConverted.add("Plant_Name");
tobeConverted.add("Park_In");
tobeConverted.add("Plant_In");
tobeConverted.add("Plant_Out");
tobeConverted.add("Park_Out");
tobeConverted.add("Transporter");
tobeConverted.add("Trailer_Type");
tobeConverted.add("Total_TAT");
tobeConverted.add("Plant_Tat");
tobeConverted.add("Incoming_Park_TAT");
tobeConverted.add("Outgoing_Park_TAT");
tobeConverted.add("Source_Plant");
tobeConverted.add("Source_Plant_Gate_Out");
tobeConverted.add("Destination_Plant");
tobeConverted.add("Destination_Park_In");
tobeConverted.add("Destination_Plant_Gate_In");
tobeConverted.add("Enroute_Distance");
tobeConverted.add("Enroute_Transit_Time");
tobeConverted.add("Enroute_Stoppage_Time");
tobeConverted.add("Destination_Plant_Outside_Wait_Time");
tobeConverted.add("Group_Name");
tobeConverted.add("Source");
tobeConverted.add("Destination");
tobeConverted.add("Trip_Sheet_Recieved_Time");
tobeConverted.add("Shipment_Closer_Status");
tobeConverted.add("Waiting_Time");
tobeConverted.add("Running_Time");
tobeConverted.add("Shipment_Received_Date_Time");
tobeConverted.add("Shipment_Actual_Start_Date_Time");
tobeConverted.add("Shipment_Start_Date_Time");
tobeConverted.add("Data_Transfer_Status");
tobeConverted.add("XML_Data");
tobeConverted.add("Asset_Status");
tobeConverted.add("Shipment_Status");
tobeConverted.add("Schedule_Trip_Start_Date_Time");
tobeConverted.add("Transport_Vendor");
tobeConverted.add("Shipment_Repushed");
tobeConverted.add("Shipment_Close_Date_Time");
tobeConverted.add("Service_Provider");
tobeConverted.add("Unit_Number");
tobeConverted.add("Source_ETA");
tobeConverted.add("Destination_ETA");
tobeConverted.add("Closed_Type");
tobeConverted.add("PUSHED_TIME");




ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String WebServicesResponseReport=convertedWords.get(0);
String Type=convertedWords.get(1);
String SelectType=convertedWords.get(2);
String SelectCustomer=convertedWords.get(3);
String CustomerName=convertedWords.get(4);
String StartDate=convertedWords.get(5);
String SelectStartDate=convertedWords.get(6);
String EndDate=convertedWords.get(7);
String SelectEndDate=convertedWords.get(8);
String SLNO=convertedWords.get(9);
String AssetNumber=convertedWords.get(10);
String ServiceName=convertedWords.get(11);
String Excel=convertedWords.get(12);
String ClearFilterData=convertedWords.get(13);
String LastServiceDate=convertedWords.get(14);
String NoRecordsfound=convertedWords.get(15);
String ExpiryDate=convertedWords.get(16);
String PleaseSelectCustomer=convertedWords.get(17);
String PleaseSelectReportType=convertedWords.get(18);
String PleaseSelectStartDate=convertedWords.get(19);
String PleaseSelectEndDate=convertedWords.get(20);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(21);
String monthValidation=convertedWords.get(22);
String Shipment = convertedWords.get(23);
String Data = convertedWords.get(24);
String Response = convertedWords.get(25);
String Date = convertedWords.get(26);
String Status = convertedWords.get(25);
String TripId = convertedWords.get(27);
String TripStartTime = convertedWords.get(28);
String ReceivedTime = convertedWords.get(29);
String Sequence = convertedWords.get(30);
String LocationId = convertedWords.get(31);
String Lat = convertedWords.get(32);
String Longi = convertedWords.get(33);
String PushStatus = convertedWords.get(34);
String InTime = convertedWords.get(35);
String OutTime = convertedWords.get(36);
String ClosedTime = convertedWords.get(37);
String RePushed=convertedWords.get(38);
String ParkName=convertedWords.get(39);
String PlantName=convertedWords.get(40);
String ParkIn=convertedWords.get(41);
String PlantIn=convertedWords.get(42);
String PlantOut=convertedWords.get(43);
String ParkOut=convertedWords.get(44);
String Transporter=convertedWords.get(45);
String TrailerType=convertedWords.get(46);
String TripTat=convertedWords.get(47);
String PlantTat=convertedWords.get(48);
String WaitingInTat=convertedWords.get(49);
String WaitingOutTat=convertedWords.get(50);
tobeConverted.add("Source_Plant");
tobeConverted.add("Source_Plant_Gate_Out");
tobeConverted.add("Destination_Plant");
tobeConverted.add("Destination_Plant_Gate_In");
tobeConverted.add("Enroute_Distance");
tobeConverted.add("Enroute_Transit_Time");
tobeConverted.add("Enroute_Stoppage_Time");
tobeConverted.add("Destination_Plant_Outside_Wait_Time");

String sourceplantName= convertedWords.get(51);
String sourcePlantOut= convertedWords.get(52);
String destinationPlant= convertedWords.get(53);
String destinationParkIn= convertedWords.get(54);
String destinationPlantIn= convertedWords.get(55);
String enrouteDistance= convertedWords.get(56);
String enrouteTransitTime= convertedWords.get(57);
String enrouteStoppageTime= convertedWords.get(58);
String destinationWaitingOutTat= convertedWords.get(59);
String groupName= convertedWords.get(60);
String source= convertedWords.get(61);
String destination=convertedWords.get(62);
String tripSheetRecievedTime= convertedWords.get(63);
String shipmentCloserStatus= convertedWords.get(64);
String waitingTime=convertedWords.get(65);
String runningTime=convertedWords.get(66);
String ShipmentReceivedDateTime=convertedWords.get(67);
String ShipmentActualStartDateTime=convertedWords.get(68);
String ShipmentStartDateTime=convertedWords.get(69);
String DataTransferStatus=convertedWords.get(70);
String XMLData=convertedWords.get(71);
String AssetStatus=convertedWords.get(72);
String ShipmentStatus=convertedWords.get(73);
String ScheduleTripStartDateTime=convertedWords.get(74);
String TransportVendor=convertedWords.get(75);
String ShipmentRepushed=convertedWords.get(76);
String ShipmentCloseDateTime=convertedWords.get(77);
String ServiceProvider=convertedWords.get(78);
String UnitNo=convertedWords.get(79);
String SourceETA=convertedWords.get(80);
String DestinationETA=convertedWords.get(81);
String ClosedType=convertedWords.get(82);
String PushedTime=convertedWords.get(83);

%>

<jsp:include page="../Common/header.jsp" />
<!-- <html class="largehtml">  -->

		<title><%=WebServicesResponseReport%></title>

	<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}
label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.footer {
			bottom : -15px !important;
		}
</style>
	
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		</style>
		<script>
		
   var outerPanel;
  var dtprev = dateprev;
  var dtcur = datecur;
  var jspName = "WebServiceTransactionReport";
  var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
  var startDate = "";
  var endDate = "";
  var grid;
  window.onload = function () { 
		refresh();
  }
    
  var customercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
      id: 'CustomerStoreId',
      root: 'CustomerRoot',
      autoLoad: true,
      remoteSort: true,
      fields: ['CustId', 'CustName'],
      listeners: {
          load: function (custstore, records, success, options) {
              if ( <%= customerId %> > 0) {
                  Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                  custId = Ext.getCmp('custcomboId').getValue();
                  custName = Ext.getCmp('custcomboId').getRawValue();
                   parent.globalCustomerID=Ext.getCmp('custcomboId').getValue();
                      Ext.getCmp('serviceTypeComboId').reset();
                      servicenamestore.load({
                         params: {
                           customerID: Ext.getCmp('custcomboId').getValue()
                        }
                   });
                   
              
              }
          }
      }
  });
  
  var custnamecombo = new Ext.form.ComboBox({
      store: customercombostore,
      id: 'custcomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectCustomer%>',
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'CustId',
      displayField: 'CustName',
      cls: 'selectstylePerfect',
      listeners: {
          select: {
              fn: function () {
                   parent.globalCustomerID=Ext.getCmp('custcomboId').getValue();
                      Ext.getCmp('serviceTypeComboId').reset();
                      servicenamestore.load({
                         params: {
                           customerID: Ext.getCmp('custcomboId').getValue()
                        }
                   });
                   
              }
          }
      }
  });



 var servicenamestore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=getType',
       id: 'servicetypeid',
       root: 'ServiceRoot',
       autoLoad: false,
       remoteSort: true,
       fields: ['Id','Type'],
       listeners: {
          load: function (custstore, records, success, options) {
              if ( <%= customerId %> > 0) {
                  Ext.getCmp('servicetypeid').setValue('<%=customerId%>');
              }
          }
      },
      sortInfo: {
            field: 'Id',
            direction: 'ASC'
        }
   });
  
  var serviceTypeCombo = new Ext.form.ComboBox({
      store: servicenamestore,
      id: 'serviceTypeComboId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      emptyText: '<%=SelectType%>',
      valueField: 'Type',
      displayField: 'Type',
      cls: 'selectstylePerfect',
      listeners:{
       'select': function(combo, record) {
              if(Ext.getCmp('serviceTypeComboId').getValue()=="TAT")
              {
              store.removeAll();
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(3, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(3, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(4, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(4, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(5, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(5, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(6, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(6, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(7, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(7, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(8, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(8, 120,false);  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(13, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(13, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(14, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(14, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(15, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(15, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(16, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(16, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(17, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(17, 120,false);  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(18, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(18, 120,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(29, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(29, 120,false);   
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(9, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(10, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(11, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(12, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(19, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(20, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(21, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(22, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(23, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(24, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(25, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(26, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(27, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(28, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(30, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(31, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(32, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(33, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(34, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(35, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(36, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(37, true);  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(38, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(39, true); 
               Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(40, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(41, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(42, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(43, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(44, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(45, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(46, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(47, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(48, true);
               Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(49, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(50, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(51, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(52, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(53, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(54, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(55, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(56, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(57, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(58, true);
              Ext.getCmp('notePanelID').show();
              }
              if(Ext.getCmp('serviceTypeComboId').getValue()=="ENROUTE_TAT")
              {
              store.removeAll();
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(2, 100,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(3, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(4, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(5, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(6, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(7, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(8, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(9, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(9, 150,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(12, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(13, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(13, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(14, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(14, 100,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(15, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(16, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(17, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(18, true);  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(10, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(11, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(12, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(19, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(19, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(20, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(20, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(21, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(21, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(22, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(22, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(23, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(23, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(24, false);  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(24, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(25, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(25, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(26, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(26, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(27, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(27, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(28, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(28, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(29, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(30, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(31, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(32, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(33, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(34, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(34, 160,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(35, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(35, 160,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(36, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(37, true);  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(38, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(39, true); 
               Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(40, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(41, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(42, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(43, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(44, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(45, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(46, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(47, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(48, true);
               Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(49, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(50, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(51, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(52, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(53, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(54, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(55, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(56, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(57, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(58, true);
              Ext.getCmp('notePanelID').hide();
              }
              if(Ext.getCmp('serviceTypeComboId').getValue()=="X7")
              {
              store.removeAll();
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(3, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(4, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(5, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(6, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(7, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(8, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(9, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(9, 80,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(10, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(10, 80,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(11, true);
              
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(12, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(12, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(13, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(14, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(15, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(16, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(17, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(18, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(19, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(20, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(21, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(22, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(23, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(24, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(25, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(26, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(27, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(28, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(29, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(30, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(31, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(32, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(33, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(34, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(35, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(36, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(37, true);  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(38, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(38, 140,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(39, true);
               Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(40, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(41, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(42, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(43, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(44, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(45, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(46, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(47, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(48, true);
               Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(49, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(50, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(51, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(52, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(53, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(54, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(55, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(56, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(57, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(58, true);
              Ext.getCmp('notePanelID').hide();
              }
              if(Ext.getCmp('serviceTypeComboId').getValue()=="TDBAC")
              {
              store.removeAll();
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(3, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(4, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(5, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(6, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(7, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(8, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(9, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(9, 80,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(10, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(10, 80,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(11, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(12, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(13, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(14, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(15, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(16, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(17, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(18, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(19, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(20, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(21, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(22, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(23, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(24, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(25, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(26, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(27, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(28, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(29, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(30, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(31, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(32, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(33, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(34, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(35, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(36, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(37, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(38, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(38, 140,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(39, true);  
               Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(40, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(41, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(42, false);  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(42, 180,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(43, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(44, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(45, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(46, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(47, true);
              if(<%=systemId%>==4){
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(48, true);
              }else{
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(48, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnHeader(48, '<span style=font-weight:bold;><%=PushedTime%></span>');
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(48, 180,false);
               Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(49, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(50, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(51, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(52, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(53, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(54, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(55, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(56, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(57, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(58, true);
              }
              Ext.getCmp('notePanelID').hide();
              }
              if(Ext.getCmp('serviceTypeComboId').getValue()=="SHIPMENT")
              {
              store.removeAll();
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(3, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(4, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(5, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(6, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(7, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(8, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(10, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(13, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(14, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(15, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(16, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(17, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(18, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(9, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(9, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(11, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(12, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(19, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(20, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(21, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(22, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(23, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(24, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(25, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(26, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(27, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(28, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(29, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(30, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(30, 140,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(31, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(31, 150,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(32, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(32, 200,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(33, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(33, 180,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(34, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(35, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(36, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(37, true);  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(36, 190,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(38, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(39, 160,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(39, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(40, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(40, 200,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(41, 150,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(41, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(42, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(43, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(44, false);
              if(<%=systemId%>==200){
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(45, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(46, false);
              }
              else{ 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(45, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(46, true);
              }
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(43, 130,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(44, 130,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(45, 130,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(46, 130,false);
              if(<%=systemId%>==4){
              	Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(47, true);
              	Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(48, true);
              }else{
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(47, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(47, 130,false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(48, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnHeader(48, '<span style=font-weight:bold;><%=ClosedTime%></span>');
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(48, 190,false);
               Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(49, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(50, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(51, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(52, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(53, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(54, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(55, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(56, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(57, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(58, true);
              }
              Ext.getCmp('notePanelID').hide();
              }
              
               if(Ext.getCmp('serviceTypeComboId').getValue()=="SHIPMENT/X6")
              { 
             // exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";	        			        
              store.removeAll(); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(3, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(4, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(5, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(6, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(7, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(8, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(10, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(13, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(14, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(15, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(16, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(17, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(18, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(9, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(9, 120,false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(11, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(12, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(19, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(20, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(21, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(22, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(23, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(24, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(25, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(26, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(27, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(28, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(29, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(30, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(30, 140,true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(31, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(31, 150,true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(32, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(32, 200,true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(33, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(33, 180,true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(34, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(35, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(36, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(37, true);  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(36, 190,true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(38, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(39, 160,true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(39, true); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(40, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(40, 200,true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(41, 150,true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(41, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(42, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(43, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(44, true);
              if(<%=systemId%>==200){
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(45, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(46, true);
              }
              else{  
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(45, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(46, true);
              }
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(43, 130,true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(44, 130,true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(45, 130,true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(46, 130,true);
              if(<%=systemId%>==4){
              	Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(47, true);
              	Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(48, true);
              }else{
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(47, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(47, 130,true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(48, true);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setColumnWidth(48, 190,false);
               Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(49, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(50, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(51, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(52, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(53, false); 
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(54, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(55, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(56, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(57, false);
              Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(58, false);
              }
              Ext.getCmp('notePanelID').hide();
              }
             }
         
      }
  });
  
    var notePanel = new Ext.Panel({
 	standardSubmit: true,
 	id:'notePanelID',
 	hidden:true,
    collapsible:false,
	items: [{
	 html: "<div >NOTE:</div>",
	 style: 'font-weight:bold;font-size:14px;',
	 cellCls: 'bskExtStyle'	
	},{
	
	 html:" <table> <tr><td>*PLANT TAT      </td><td>= Plant Gate Out - Plant Gate In (Hrs:Min:Sec) </td></tr> <tr><td> *INCOMING PARK TAT </td><td>= Plant Gate In - Parking In </td></tr> <tr><td> *OUTGOING PARK TAT </td><td>= Parking Out - Plant Gate Out  </td></tr> <tr><td>*TOTAL TAT        </td><td> = Parking Out - Parking In (Hrs:Min:Sec)</td></tr></table>",
	 style: 'font-size:12px;',
	 cellCls: 'bskExtStyle'	
	}]
	 });
	 
	
  var editInfo1 = new Ext.Button({
      text: 'Submit',
      id: 'submitId',
      cls: 'buttonStyle',
      width: 70,
      handler: function () {
          // store.load();
          var clientName = Ext.getCmp('custcomboId').getValue();
          var startdate = Ext.getCmp('startdate').getValue();
          var enddate = Ext.getCmp('enddate').getValue();
           if (Ext.getCmp('custcomboId').getValue() == "") {

              Ext.example.msg("<%=PleaseSelectCustomer%>");
              Ext.getCmp('custcomboId').focus();
              return;
          }
           if (Ext.getCmp('serviceTypeComboId').getValue() == "") {
             
              Ext.example.msg("<%=PleaseSelectReportType%>");
              Ext.getCmp('custcomboId').focus();
              return;
          }
              if (Ext.getCmp('startdate').getValue() == "") {
           
                  Ext.example.msg("<%=PleaseSelectStartDate%>");
                  Ext.getCmp('startdate').focus();
                  return;
              }
              if (Ext.getCmp('enddate').getValue() == "") {
                 
                  Ext.example.msg("<%=PleaseSelectEndDate%>");
                  Ext.getCmp('enddate').focus();
                  return;
              }
              if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                  
                  Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                  Ext.getCmp('enddate').focus();
                  return;
              }
              if (checkMonthValidation(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue())) {
                  Ext.example.msg("<%=monthValidation%>");
                  Ext.getCmp('enddate').focus();
                  return;
              }
          store.load({
              params: {
                  CustId: Ext.getCmp('custcomboId').getValue(),
                  custName: Ext.getCmp('custcomboId').getRawValue(),
                  startDate: Ext.getCmp('startdate').getValue(),
                  endDate: Ext.getCmp('enddate').getValue(),
                  jspName: jspName,
                  serviceType: Ext.getCmp('serviceTypeComboId').getValue()
              }
          });
      }
  });
  
  var clientPanel = new Ext.Panel({
      standardSubmit: true,
      collapsible: false,
      id: 'clientPanelId',
      layout: 'table',
      frame: true,
      width: screen.width - 40,
      height: 70,
      layoutConfig: {
          columns: 7
      },
      items: [{
              xtype: 'label',
              text: '<%=CustomerName%>' + ' :',
              cls: 'labelstyle',
              id: 'custnamelab'
          },
          custnamecombo, {
              width: 80
          }, {
              xtype: 'label',
              text: '<%=Type%>' + ' :',
              cls: 'labelstyle',
              id: 'assetTypelab'
          },
          serviceTypeCombo, {
              width: 5
          },
          editInfo1, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'startdatelab',
              text: '<%=StartDate%>' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 185,
              format: getDateFormat(),
              emptyText: '<%=SelectStartDate%>',
              allowBlank: false,
              blankText: '<%=SelectStartDate%>',
              id: 'startdate',
              maxValue:dtprev,
               value: dtprev,
              endDateField: 'enddate'
          }, {
              width: 80
          }, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'enddatelab',
              text: '<%=EndDate%>' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 185,
              format: getDateFormat(),
              emptyText: '<%=SelectEndDate%>',
              allowBlank: false,
              blankText: '<%=SelectEndDate%>',
              id: 'enddate',
              maxValue:dtprev.add(Date.DAY,1),
              //minValue:dtprev.add(Date.DAY,1),
              value: datecur,
              startDateField: 'startdate'
          }, {
              width: 80
          }
      ]
  });
  
 if(<%=systemId%>==200 || <%=systemId%>==4  || (<%=systemId%>==214) )
 {

    var reader = new Ext.data.JsonReader({
        idProperty: 'servicedetailid',
        root: 'ServiceTypeRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'assetNumber'
        }, 
        {
            name: 'shipment'
        },{
            name: 'data'
        }, {
            name: 'status'
        }, {
            name: 'triggeredTime'
        },
        {
            name: 'parkName'
        },
        {
            name: 'plantName'
        },
        {
            name: 'parkIn'
        },
        {
            name: 'plantIn'
        },
        {
            name: 'plantOut'
        },
        {
            name: 'parkOut'
        },
        {
            name: 'transporter'
        },
        {
            name: 'trailerType'
        },
        {
            name: 'totalTat'
        },
        {
            name: 'plantTat'
        },
        {
            name: 'incomingParkTAT'
        },
        {
            name: 'outgoingParkTAT'
        },
        {
            name: 'tripId'
        },
        {
            name: 'shipment'
        },
        {
            name: 'sourceplantName'
        },
        {
            name: 'sourcePlantOut'
        },
        {
            name: 'destinationPlant'
        },
        {
            name: 'destinationParkIn'
        },
        {
            name: 'destinationPlantIn'
        },
        {
            name: 'enrouteDistance'
        },
        {
            name: 'enrouteTransitTime'
        },
        {
            name: 'enrouteStoppageTime'
        },
        {
            name: 'destinationWaitingOutTat'
        },
        {
            name: 'groupName'
        },
        {
            name: 'source'
        },
        {
            name: 'destination'
        },
        {
            name: 'ShipmentReceivedDateTime'
        },
        {
            name: 'AssetStatus'
        },
        {
            name: 'waitingTime'
        },
        {
            name: 'runningTime'
        },
        {
            name: 'ShipmentActualStartDateTime'
        },
        {
            name: 'ShipmentStartDateTime'
        },
        {
            name: 'DataTransferStatus'
        },
        {
            name: 'ShipmentStatus'
        },{
            name: 'ScheduleTripStartDateTime'
        },{
            name: 'ShipmentRepushed'
        },{
            name: 'ShipmentCloseDateTime'
        },{
            name: 'ServiceProvider'
        },{
            name: 'UnitNo'
        },{
            name: 'SourceETA'
        },{
            name: 'DestinationETA'
        },{
            name: 'ClosedType'
        },{
            name: 'ClosedTime'
        },{
            name: 'tripStartTime'
        },{
            name: 'receivedTime'
        },{
            name: 'sequence'
        },{
            name: 'locationId'
        },{
            name: 'lat'
        },{
            name: 'longi'
        },{
            name: 'pushStatus'
        },{
            name: 'inTime'
        },{
            name: 'outTime'
        },{
            name: 'rePushed'
        }
        ]
    });
            
 var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'assetNumber'
        }, {
            type: 'string',
            dataIndex: 'shipment'
        }, {
            type: 'string',
            dataIndex: 'data'
        }, {
            type: 'string',
            dataIndex: 'status'
        }, {
            type: 'string',
            dataIndex: 'triggeredTime'
        },{
            type: 'string',
            dataIndex: 'parkName'
        },{
            type: 'string',
            dataIndex: 'plantName'
        },
        {
            type: 'string',
            dataIndex: 'parkIn'
        },
        {
            type: 'string',
            dataIndex: 'plantIn'
        },
        {
            type: 'string',
            dataIndex: 'plantOut'
        },
        {
            type: 'string',
            dataIndex: 'parkOut'
        },
        {
            type: 'string',
            dataIndex: 'transporter'
        },
        {
            type: 'string',
            dataIndex: 'trailerType'
        },
        {
            type: 'string',
            dataIndex: 'totalTat'
        },{
            type: 'string',
            dataIndex: 'plantTat'
        },{
            type: 'string',
            dataIndex: 'incomingParkTAT'
        },{
            type: 'string',
            dataIndex: 'outgoingParkTAT'
        },{
            type: 'string',
            dataIndex: 'tripId'
        },
        {
            type: 'string',
            dataIndex: 'shipment'
        },
        {
            type: 'string',
            dataIndex: 'sourceplantName'
        },
        {
            type: 'string',
            dataIndex: 'sourcePlantOut'
        },
        {
            type: 'string',
            dataIndex: 'destinationPlant'
        },
        {
            type: 'string',
            dataIndex: 'destinationParkIn'
        },
        {
            type: 'string',
            dataIndex: 'destinationPlantIn'
        },
        {
            type: 'string',
            dataIndex: 'enrouteDistance'
        },
        {
            type: 'string',
            dataIndex: 'enrouteTransitTime'
        },
        {
            type: 'string',
            dataIndex: 'enrouteStoppageTime'
        },
        {
            type: 'string',
            dataIndex: 'destinationWaitingOutTat'
        },
        {
            type: 'string',
            dataIndex: 'groupName'
        },
        {
            type: 'string',
            dataIndex: 'source'
        },
        {
            type: 'string',
            dataIndex: 'destination'
        },
        {
            type: 'string',
            dataIndex: 'ShipmentReceivedDateTime'
        },
        {
            type: 'string',
            dataIndex: 'AssetStatus'
        },
        {
            type: 'string',
            dataIndex: 'waitingTime'
        },
        {
            type: 'string',
            dataIndex: 'runningTime'
        },{
            type: 'string',
            dataIndex: 'ShipmentActualStartDateTime'
        },{
            type: 'string',
            dataIndex: 'ShipmentStartDateTime'
        },{
            type: 'string',
            dataIndex: 'DataTransferStatus'
        },{
            type: 'string',
            dataIndex: 'ShipmentStatus'
        },{
            type: 'string',
            dataIndex: 'ScheduleTripStartDateTime'
        },{
            type: 'string',
            dataIndex: 'ShipmentRepushed'
        },{
            type: 'string',
            dataIndex: 'ShipmentCloseDateTime'
        },{
            type: 'string',
            dataIndex: 'ServiceProvider'
        },{
            type: 'string',
            dataIndex: 'UnitNo'
        },{
            type: 'string',
            dataIndex: 'SourceETA'
        },{
            type: 'string',
            dataIndex: 'DestinationETA'
        },{
            type: 'string',
            dataIndex: 'ClosedType'
        },{
            type: 'string',
            dataIndex: 'ClosedTime'
        },{
            type: 'string',
            dataIndex: 'tripStartTime' 
        },{
            type: 'string',
            dataIndex: 'receivedTime'
        },{
            type: 'string',
            dataIndex: 'sequence'
        },{
            type: 'string',
            dataIndex: 'locationId'
        },{
            type: 'string',
            dataIndex: 'lat' 
        },{
            type: 'string',
            dataIndex: 'longi'
            
        },{
            type: 'string',
            dataIndex: 'pushStatus'
        },{
            type: 'string',
            dataIndex: 'inTime'
        },{
            type: 'string',
            dataIndex: 'outTime'
        },{
            type: 'string',
            dataIndex: 'rePushed'
        }]
    });
  
  var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=getServiceTypeDetails',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'triggeredTime',
            direction: 'ASC'
        },
        storeId: 'servicetypedetailid',
        reader: reader
        });
        store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                     CustId: Ext.getCmp('custcomboId').getValue(),
                     custName: Ext.getCmp('custcomboId').getRawValue(),
                     startDate: Ext.getCmp('startdate').getValue(),
                     endDate: Ext.getCmp('enddate').getValue(),
                     jspName: jspName,
                     serviceType: Ext.getCmp('serviceTypeComboId').getValue()
                };
            }, this);
  
  
  var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 60
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 20,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=AssetNumber%></span>",
            hidden: false,
            //width: 100,
            //sortable: false,
            dataIndex: 'assetNumber',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=ParkName%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'parkName',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=PlantName%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'plantName',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ParkIn%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'parkIn',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=PlantIn%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'plantIn',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=PlantOut%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'plantOut',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=ParkOut%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'parkOut',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Shipment%></span>",
            hidden: false,
            //width: 100,
           // sortable: true,
            dataIndex: 'shipment',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=XMLData%></span>",
            hidden: true,
            //width: 100,
           // sortable: true,
            dataIndex: 'data',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Response%></span>",
            hidden: false,
            //width: 120,
            //sortable: true,
            dataIndex: 'status',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Date%></span>",
            hidden: false,
            //width: 120,
            //sortable: true,
            dataIndex: 'triggeredTime',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=TransportVendor%></span>",
            hidden: false,
            //width: 120,
            //sortable: true,
            dataIndex: 'transporter',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=TrailerType%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'trailerType',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=TripTat%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'totalTat',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=PlantTat%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'plantTat',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=WaitingInTat%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'incomingParkTAT',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=WaitingOutTat%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'outgoingParkTAT',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=TripId%></span>",
            hidden: false,
            //width: 120,
            //sortable: true,
            dataIndex: 'tripId',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=sourceplantName%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'sourceplantName',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=sourcePlantOut%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'sourcePlantOut',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=destinationPlant%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'destinationPlant',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=destinationParkIn%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'destinationParkIn',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=destinationPlantIn%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'destinationPlantIn',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=enrouteDistance%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'enrouteDistance',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=enrouteTransitTime%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'enrouteTransitTime',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=enrouteStoppageTime%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'enrouteStoppageTime',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=destinationWaitingOutTat%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'destinationWaitingOutTat',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=groupName%></span>",
            hidden: false,
            //width: 120,
            //sortable: true,
            dataIndex: 'groupName',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=source%></span>",
            hidden: false,
            //width: 120,
            //sortable: true,
            dataIndex: 'source',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=destination%></span>",
            hidden: false,
            //width: 120,
            //sortable: true,
            dataIndex: 'destination',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ShipmentReceivedDateTime%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'ShipmentReceivedDateTime',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=AssetStatus%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'AssetStatus',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=waitingTime%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'waitingTime',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=runningTime%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'runningTime',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ShipmentActualStartDateTime%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'ShipmentActualStartDateTime',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ShipmentStartDateTime%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'ShipmentStartDateTime',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=DataTransferStatus%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'DataTransferStatus',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ShipmentStatus%></span>",
            hidden: false,
            //width: 120,
            //sortable: true,
            dataIndex: 'ShipmentStatus',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ScheduleTripStartDateTime%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'ScheduleTripStartDateTime',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ShipmentRepushed%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'ShipmentRepushed',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ShipmentCloseDateTime%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'ShipmentCloseDateTime',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ServiceProvider%></span>",
            hidden: false,
            //width: 120,
            //sortable: true,
            dataIndex: 'ServiceProvider',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=UnitNo%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'UnitNo',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=SourceETA%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'SourceETA',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=DestinationETA%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'DestinationETA',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ClosedType%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'ClosedType',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=ClosedTime%></span>",
            hidden: true,
            //width: 120,
            //sortable: true,
            dataIndex: 'ClosedTime',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=TripStartTime%></span>",
            hidden: false,
            dataIndex: 'tripStartTime',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ReceivedTime%></span>",
            hidden: false,
            dataIndex: 'receivedTime',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Sequence%></span>",
            hidden: false,
            dataIndex: 'sequence',
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=LocationId%></span>",
            hidden: false,
            dataIndex: 'locationId',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Lat%></span>",
            hidden: false,
            dataIndex: 'lat',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Longi%></span>",
            hidden: false,
            dataIndex: 'longi',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=PushStatus%></span>",
            hidden: false,
            dataIndex: 'pushStatus',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=InTime%></span>",
            hidden: false,
            dataIndex: 'inTime',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=OutTime%></span>",
            hidden: false,
            dataIndex: 'outTime',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=RePushed%></span>",
            hidden: false,
            dataIndex: 'rePushed',
            filter: {
                type: 'string'
            }
        }
        
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};
}

//********************************grid***************************//

grid = getGrid('', '<%=NoRecordsfound%>', store, screen.width-40, 350, 60, filters,'', false, '', 60, false, '', false, '', true, '<%=Excel%>',jspName, exportDataType);

 Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 180000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Web Service Transaction Details',
        renderTo: 'content',
        id:'outerPanel',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        width:screen.width-22,
        height:550,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel,grid,notePanel]
    });
       var cm = grid.getColumnModel();
        for (var j = 1; j < cm.getColumnCount(); j++) {
            cm.setColumnWidth(j, 170);
        }
    store.load();
});

   </script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->