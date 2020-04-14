<%@ page language="java"
import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
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
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int offset = loginInfo.getOffsetMinutes();
	int customerId = loginInfo.getCustomerId();
	int customeridlogged=loginInfo.getCustomerId();
String customerName1="null";
if(customeridlogged>0)
{
customerName1=cf.getCustomerName(String.valueOf(customeridlogged),systemId);
}
ArrayList<String> tobeConverted = new ArrayList<String>();

tobeConverted.add("Select_Report_Type");
tobeConverted.add("Select_Report_Type");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Report_Type");
tobeConverted.add("Start_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("SLNO");
tobeConverted.add("Asset_Number");
tobeConverted.add("Service_Name");
tobeConverted.add("Renewal_By");
tobeConverted.add("Due_Days");
tobeConverted.add("Due_Mileage");
tobeConverted.add("Excel");
tobeConverted.add("PDF");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Last_Service_Date");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Expiry_Date");
tobeConverted.add("Alert_Type");
tobeConverted.add("Remarks");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("Please_Select_Report_Type");
tobeConverted.add("Please_Select_Start_Date");
tobeConverted.add("Please_Select_End_Date");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Terminal_Name");
tobeConverted.add("Route_Name");
tobeConverted.add("Start_Month");
tobeConverted.add("End_Month");
tobeConverted.add("Scheduled_Date");
tobeConverted.add("Consumer_Booking _By_Web");
tobeConverted.add("Consumer_Booking_By_Mobile");
tobeConverted.add("User_Booking_By_Web");
tobeConverted.add("User_Booking_By_Mobile");
tobeConverted.add("Total_Tickets_Booked");
tobeConverted.add("No_Of_Bus");
tobeConverted.add("Ticket_Summary_Report");

String clientID=request.getParameter("cutomerID");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectReportType=convertedWords.get(1);
String SelectCustomer=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String ReportType=convertedWords.get(4);
String StartDate=convertedWords.get(5);
String SelectStartDate=convertedWords.get(6);
String EndDate=convertedWords.get(7);
String SelectEndDate=convertedWords.get(8);
String SLNO=convertedWords.get(9);
String Excel=convertedWords.get(15);
String PDF=convertedWords.get(16);
String ClearFilterData=convertedWords.get(17);
String NoRecordsfound=convertedWords.get(19);
String PleaseSelectCustomer=convertedWords.get(23);
String PleaseSelectReportType=convertedWords.get(24);
String PleaseSelectStartDate=convertedWords.get(25);
String PleaseSelectEndDate=convertedWords.get(26);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(27);
String monthValidation=convertedWords.get(28);
String TerminalName=convertedWords.get(29);
String RouteName=convertedWords.get(30);
String StartMonthYear =convertedWords.get(31);
String EndMonthYear =convertedWords.get(32);
String ScheduledDate =convertedWords.get(33);
String ConsumerBookingByWeb =convertedWords.get(34);
String ConsumerBookingByMobile =convertedWords.get(35);
String UserBookingByWeb =convertedWords.get(36);
String UserBookingByMobile =convertedWords.get(37);
String TotalTicketsBooked =convertedWords.get(38);
String NoOfBus =convertedWords.get(39);
String TripSummaryReport="ShiftWise Trip Summary Report";//convertedWords.get(40);
String TripSummaryReportDateWise = "DateWise Trip Summary Report";
String TripDetails = "Trip Details";
String SelectShiftName = "Select Shift Name";
String ShiftName = "Shift Name";
String Branch  = "Group";
String SelectBranch = "Select Group";
String Date = "Date";
String  PleaseSelectBranch = "Please Select Group";
String PleaseSelectShift = "Please Select Shift";
String PleaseSelectDate = "Please Select Date";
String	VehicleNo = "Vehicle No";
String VehicleId="Vehicle Id";
String GroupName = "Group Name";
String NoOfTrips = "No Of Trips";
String TotalKmsTravelled ="Total Kms Travelled";
String AvrageKmPerTrip = "Average Kms";
String TotalDuration = "Total Duration";
String AvrageDuration = "Average Duration";
String Odometer = "Odometer";
String LastKnownDate = "Last Known Time";
String TripDuration ="Trip Duration";
String MaxSpeed = "Max Speed";
String SpeedLimit = "Speed Limit";
String OSCount = "OS Count";
String HACount = "HA Count";
String HBCount = "HB Count";
String IdleCount = "Idle Count";
String IdleDuration = "Idle Duration";
String PathOsDuration = "Path OS Duration";
String PathOsCount = "Path OS Count";
String SeatBeltCount = "SeatBelt Count" ;

%>

<!DOCTYPE HTML>
<html class="largehtml">
	<head>
		<title><%=TripSummaryReport%></title>
	</head>
	<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}
.x-form-invalid-icon {
    left: 170px;
    top: 0px;
    visibility: visible;
}
</style>
	<body>
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		

<script>
 	Ext.Ajax.timeout = 360000;
    var dt;
    var dt1 = dateprev; 
    dt = dt1; // -1 day from current day  
    var outerPanel;
    var dtprev = dt;
    var prevmonth = new Date().add(Date.MONTH, -1);
    var currmonth = new Date();
    var nextDaate = new Date().add(Date.DAY, 1);
    var datecurEnd = new Date();
    var  datecurSatrt = new Date();
    
    datecurSatrt = datecurSatrt.format('d-m-Y');
    
    var jspName = '<%=TripSummaryReport%>';
    var reportName = '<%=TripSummaryReport%>';
    var exportDataType = "int,string,number,number,number,string,string,number,string,string,number,number,number,number,number,number,number,string,numeric,numeric";
    var startDate = "";
    var endDate = "";
    var newDate = new Date().add(Date.DAY, -1);
    var grid;  
    var buttonClick = ''; 
    var buttonValue = 'ShiftWise';
    var StartTime = 'Start Time';
    var EndTime = 'End Time';
   
   function dateCompare2(fromDate, toDate) {
	
	if(fromDate < toDate) {
		return 1;
	} else if(toDate < fromDate) {
		return -1;
	}
	return 0;
}  
function addRecord(){
    if (grid.getSelectionModel().getCount() == 0) {
       Ext.example.msg("No Rows Selected");
       return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
       Ext.example.msg("Select Single Row");
       return;
    }
    var selected = grid.getSelectionModel().getSelected();
    vehicleNo=selected.get('vehicleNoDataIndex');
    noOfTrip=selected.get('NoOfTripsDataIndex');
    if(vehicleNo=='<B>TOTAL</B>'){
       Ext.example.msg("Not Allowed");
       return;
    }
    if(noOfTrip=='0'){
       Ext.example.msg("No records found");
       return;
    }
    var stimeArray=[];
    var etimeArray=[];
	sd=selected.get('startDateTimeIndex');
	ed=selected.get('endDateTimeIndex');
	stimeArray=sd.split(" ");
	etimeArray=ed.split(" ");
	startDate=stimeArray[0];
	endDate=etimeArray[0];
	starttime=stimeArray[1];
	endtime=etimeArray[1];
	branchId=Ext.getCmp('BranchNameComboId').getValue();
	shiftId=Ext.getCmp('ShiftNameComboId').getValue();
	custId= Ext.getCmp('custcomboId').getValue();
	var url='<%=request.getContextPath()%>/Jsps/StaffTransportationSolution/ShiftwiseTripDetails.jsp?vehicleNo='+vehicleNo+'&startDate='+startDate+'&endDate='+endDate+'&branchId='+branchId+'&shiftId='+shiftId+'&custId='+custId+'&starttime='+starttime+'&endtime='+endtime;
	console.log(url);
	parent.Ext.getCmp('detailsTab').enable();
    parent.Ext.getCmp('detailsTab').show();
    parent.Ext.getCmp('detailsTab').update("<iframe style='width:100%;height:525px;border:0;' src='" + url + "'></iframe>");
}
   function buttonFunction(){
   
           if (Ext.getCmp('custcomboId').getValue() == "") {
                Ext.example.msg("<%=PleaseSelectCustomer%>");
                Ext.getCmp('custcomboId').focus();
                return;
            }
			
			 if (Ext.getCmp('BranchNameComboId').getValue() == "") {
                Ext.example.msg("<%=PleaseSelectBranch%>");
                Ext.getCmp('BranchNameComboId').focus();
                return;
            }
			if(Ext.getCmp('radio2').getValue() != true){
			 if (Ext.getCmp('ShiftNameComboId').getValue() == "") {
                Ext.example.msg("<%=PleaseSelectShift%>");
                Ext.getCmp('ShiftNameComboId').focus();
                return;
            }
            }
			
			 if (Ext.getCmp('startdate2').getValue() == "") {
                Ext.example.msg("<%=PleaseSelectDate%>");
                Ext.getCmp('startdate2').focus();
                return;
            }
             if (Ext.getCmp('endDatePmr').getValue() == "") {
                Ext.example.msg("<%=SelectEndDate%>");
                Ext.getCmp('endDatePmr').focus();
                return;
            }            
           
            if (dateCompare2(Ext.getCmp('startdate2').getValue(), Ext.getCmp('endDatePmr').getValue()) == -1) {
                    Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                    Ext.getCmp('endDatePmr').focus();
                    return;
                }
           
           
           
           
           if(buttonValue == 'DateWise'){
           
            if(buttonClick == 'pdf'){
           buttonClick = '';
           var offset = '<%=offset%>';
               var SystemId = '<%=systemId%>';
               var  CustId = Ext.getCmp('custcomboId').getValue();
               var    BranchId = Ext.getCmp('BranchNameComboId').getValue();
               var   ShiftId=Ext.getCmp('ShiftNameComboId').getValue();
               var   Date=Ext.getCmp('startdate2').getValue().format('Y-m-d H:i:s');
               var   JspName=jspName;
               var   CustName=Ext.getCmp('custcomboId').getRawValue();
               var  BranchName=Ext.getCmp('BranchNameComboId').getRawValue();
               var  ShiftName=Ext.getCmp('ShiftNameComboId').getRawValue();
               var  endDate=Ext.getCmp('endDatePmr').getValue().format('Y-m-d H:i:s');
               startTime = Ext.getCmp('SatrtTimeText').getValue();
               endTime =   Ext.getCmp('EndTimeText').getValue();
               var buttonValue2 = buttonValue;
            window.open('<%=request.getContextPath()%>/ShiftWiseTripSummaryReportPDF?CustId=' + CustId + '&SystemId=' + SystemId + ' &BranchId=' + BranchId + '&ShiftId=' + ShiftId + '&Date=' + Date + '&JspName=' + JspName + '&CustName=' + CustName + '&BranchName=' + BranchName + '&ShiftName=' + ShiftName + '&offset= ' + offset + '&buttonValue=' + buttonValue2 + '&endDate=' + endDate + '&startTime='+startTime+'&endTime='+endTime+'');
           
           }else{
           
           
               store.load({
                  params:{
                  CustId : Ext.getCmp('custcomboId').getValue(),
                  BranchId : Ext.getCmp('BranchNameComboId').getValue(),
                  ShiftId:Ext.getCmp('ShiftNameComboId').getValue(),
                  Date:Ext.getCmp('startdate2').getValue(),
                  JspName:jspName,
                  CustName:Ext.getCmp('custcomboId').getRawValue(),
                  BranchName:Ext.getCmp('BranchNameComboId').getRawValue(),
                  ShiftName:Ext.getCmp('ShiftNameComboId').getRawValue(),
                  endDate:Ext.getCmp('endDatePmr').getValue(),
                  buttonValue : buttonValue
                  }
                  });
                  }
           }
           
         else{
           
              Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/VehicleTripSummaryAction.do?param=validate',
                            method: 'POST',
                            params: {                              
                                endDate:Ext.getCmp('endDatePmr').getValue(),
                                ShiftId : Ext.getCmp('ShiftNameComboId').getValue(),
                                BranchId : Ext.getCmp('BranchNameComboId').getValue(),
                                CustId : Ext.getCmp('custcomboId').getValue()
                                                           
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                              if(message == 'success'){
                              
          
            if(buttonClick == 'pdf'){
           buttonClick = '';
           var offset = '<%=offset%>';
               var SystemId = '<%=systemId%>';
               var  CustId = Ext.getCmp('custcomboId').getValue();
               var    BranchId = Ext.getCmp('BranchNameComboId').getValue();
               var   ShiftId=Ext.getCmp('ShiftNameComboId').getValue();
               var   Date=Ext.getCmp('startdate2').getValue().format('Y-m-d');
               var   JspName=jspName;
               var   CustName=Ext.getCmp('custcomboId').getRawValue();
               var  BranchName=Ext.getCmp('BranchNameComboId').getRawValue();
               var  ShiftName=Ext.getCmp('ShiftNameComboId').getRawValue();
               var  endDate=Ext.getCmp('endDatePmr').getValue().format('Y-m-d');
               startTime = Ext.getCmp('SatrtTimeText').getValue();
               endTime =   Ext.getCmp('EndTimeText').getValue();
               var buttonValue2 = buttonValue;
            window.open('<%=request.getContextPath()%>/ShiftWiseTripSummaryReportPDF?CustId=' + CustId + '&SystemId=' + SystemId + ' &BranchId=' + BranchId + '&ShiftId=' + ShiftId + '&Date=' + Date + '&JspName=' + JspName + '&CustName=' + CustName + '&BranchName=' + BranchName + '&ShiftName=' + ShiftName + '&offset= ' + offset + ' &buttonValue=' + buttonValue2 + '&endDate=' + endDate + '&startTime='+startTime+'&endTime='+endTime+'');
           
           }else{
           
           
               store.load({
                  params:{
                  CustId : Ext.getCmp('custcomboId').getValue(),
                  BranchId : Ext.getCmp('BranchNameComboId').getValue(),
                  ShiftId:Ext.getCmp('ShiftNameComboId').getValue(),
                  Date:Ext.getCmp('startdate2').getValue(),
                  JspName:jspName,
                  CustName:Ext.getCmp('custcomboId').getRawValue(),
                  BranchName:Ext.getCmp('BranchNameComboId').getRawValue(),
                  ShiftName:Ext.getCmp('ShiftNameComboId').getRawValue(),
                  endDate:Ext.getCmp('endDatePmr').getValue(),
                  buttonValue : buttonValue,
                  SatrtTime: Ext.getCmp('SatrtTimeText').getValue(),
                  EndTime : Ext.getCmp('EndTimeText').getValue()
                  }
                  });
                  }
                              }else{
                              if(Ext.getCmp('ShiftNameComboId').getValue() == 999 ){
                               Ext.example.msg("All Shifts Are Not Completed For Selected Date");
                              }else{
                               Ext.example.msg("Shift Has Not Completed For Selected Date");
                               }
                              }
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                
                            }
                        });
                        }
           
   }
   
 
    var customercombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function(custstore, records, success, options) {
               if (<%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                  BranchComboStore.load({
                  params:{
                  clientId : Ext.getCmp('custcomboId').getValue()
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
                fn: function() {
                    custId = Ext.getCmp('custcomboId').getValue();
                    Ext.getCmp('BranchNameComboId').reset();
                    Ext.getCmp('ShiftNameComboId').reset();                   
                  BranchComboStore.load({
                  params:{
                  clientId : Ext.getCmp('custcomboId').getValue()
                  }
                  });
                }
            }
        }
    });
  var BranchComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/VehicleTripSummaryAction.do?param=getVehicleGroup',
    id: 'BranchComboStoreId',
    root: 'BranchStoreRootUser',
    autoLoad: false,
    remoteSort: true,
    fields: ['BranchId','BranchName']
});

BranchNameCombo = new Ext.form.ComboBox({
    store: BranchComboStore,
    id: 'BranchNameComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectBranch%>',
    blankText: '<%=SelectBranch%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'BranchId',
    displayField: 'BranchName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            
            buttonValue = 'ShiftWise'; 
          	jspName = '<%=TripSummaryReport%>';
          	reportName = '<%=TripSummaryReport%>';
          	Ext.getCmp('radio1').setValue(true);
            Ext.getCmp('assetTypelab2').show();
Ext.getCmp('ShiftNameComboId').show();
Ext.getCmp('startTimeLabelId').show();
Ext.getCmp('SatrtTimeText').show();
Ext.getCmp('endTimeLabelId').show();
Ext.getCmp('EndTimeText').show(); 
            
            
            Ext.getCmp('ShiftNameComboId').reset();
            Ext.getCmp('SatrtTimeText').setValue("00:00");
            Ext.getCmp('EndTimeText').setValue("00:00"); 
                    ShiftNameComboStore.load({
                  params:{
                  CustId : Ext.getCmp('custcomboId').getValue(),
                  BranchId : Ext.getCmp('BranchNameComboId').getValue()
                  }
                  });
                      }   

            }
        }
    
});
  

  var ShiftNameComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/VehicleTripSummaryAction.do?param=getShiftNames',
    id: 'ShiftStoreId',
    root: 'ShiftRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['ShiftId','ShiftName','StartTime','EndTime']
});

var ShiftNameCombo = new Ext.form.ComboBox({
    store: ShiftNameComboStore,
    id: 'ShiftNameComboId',
    hidden:true,
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectShiftName%>',
    blankText: '<%=SelectShiftName%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'ShiftId',
    displayField: 'ShiftName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            jspName = '<%=TripSummaryReport%>';
            reportName = '<%=TripSummaryReport%>';
            var rownum = ShiftNameComboStore.findExact( 'ShiftId', Ext.getCmp('ShiftNameComboId').getValue());
                    if(rownum>=0){
                  var record =   ShiftNameComboStore.getAt(rownum);
                 Ext.getCmp('SatrtTimeText').setValue(record.data['StartTime']);
                 Ext.getCmp('EndTimeText').setValue(record.data['EndTime']);
                    }
                    
                      }   
            }
        }
    
});
  
  
  
  var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'clientPanelId',
        layout: 'table',
        frame: true,
        width: screen.width - 35,    
        layoutConfig: {
            columns: 18
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            custnamecombo,
			{   xtype: 'label',
                text: '',
                cls: 'labelstyle',
                width:50,
                id: 'empty1'
			}, 
            {
                xtype: 'label',
                text: '<%=Branch%>' + ' :',
                cls: 'labelstyle',
                id: 'assetTypelab'
            }, 
			BranchNameCombo,
			{   xtype: 'label',
                text: '',
                cls: 'labelstyle',
                 width:50,
                id: 'empty2'
			}, 
			{
                xtype: 'label',
                text: '<%=ShiftName%>' + ' :',
                cls: 'labelstyle',
                id: 'assetTypelab2',
                hidden:true
            }, 
			ShiftNameCombo,{width:20},
			{
			
			    xtype: 'label',
                text: 'Start Time' + ' :',
                cls: 'labelstyle',
                id: 'startTimeLabelId',
                hidden:true
			
			},
			{
			   
			    xtype: 'textfield',
                text: '00:00',
                //cls: 'labelstyle',
                id: 'SatrtTimeText',
                width:40,
                hidden:true,
                readOnly : true 
			},
			{
			    xtype: 'label',
                text: 'End Time' + ' :',
                cls: 'labelstyle',
                id: 'endTimeLabelId',
                hidden:true
			
			},
			{
			    xtype: 'textfield',
                text: '00:00',
                //cls: 'labelstyle',
                id: 'EndTimeText',
                width:40,
                hidden:true,
                readOnly : true
			},
			
			{
           
            xtype: 'radio',
            id:'radio1',
            fieldlabel:'',
   			width    : 30,
		  	checked  : true,
		  	name     : 'option',
   			value	: 'ShiftWise',
   			hidden:true,
   			style:'margin-left:20px',  	
    	  	listeners: {
     	  	check : function(){
          	if(this.checked){
          	buttonValue = 'ShiftWise'; 
          	jspName = '<%=TripSummaryReport%>';
          	reportName = '<%=TripSummaryReport%>';
            Ext.getCmp('assetTypelab2').show();
Ext.getCmp('ShiftNameComboId').show();
Ext.getCmp('startTimeLabelId').show();
Ext.getCmp('SatrtTimeText').show();
Ext.getCmp('endTimeLabelId').show();
Ext.getCmp('EndTimeText').show(); 
                }
              }
           }           
        },{
            xtype: 'label',
            text: ' Shift Wise ',
            cls: 'labelstyle',
            id: 'shiftWiseLabelId',
            hidden:true
        },
		
		{
           
            xtype: 'radio',
            id:'radio2',
            fieldlabel:'',
   			width    : 30,
		  	checked  : false,
		  	hidden:true,
		  	name     : 'option',
   			value	: 'DateWise',
   			style:'margin-left:20px',  	
    	  	listeners: {
     	  	check : function(){
          	if(this.checked){
          	jspName = '<%=TripSummaryReportDateWise%>';
          	reportName = '<%=TripSummaryReportDateWise%>';
          	
          	buttonValue = 'DateWise';  
          	Ext.getCmp('assetTypelab2').hide();
Ext.getCmp('ShiftNameComboId').hide();
Ext.getCmp('startTimeLabelId').hide();
Ext.getCmp('SatrtTimeText').hide();
Ext.getCmp('endTimeLabelId').hide();
Ext.getCmp('EndTimeText').hide();
                }
              }
           }           
        },{
            xtype: 'label',
            text: ' Date Wise ',
            cls: 'labelstyle',
            id: 'dateWiseLabelId',
            hidden:true
        },
			
			
			
			{   xtype: 'label',
                text: '',
                cls: 'labelstyle',
                 width:50,
                id: 'empty4'
			},
			{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'startdatelab2',
            width: 200,
            text: '<%=StartDate%>' + ' :'
            },  
			{
            xtype: 'datefield',          
            emptyText: '<%=SelectStartDate%>',
            allowBlank: false,
            blankText: '<%=SelectStartDate%>',
            id: 'startdate2',        
            cls: 'selectstylePerfect' ,
            format: getDateFormat(),
            value: datecurSatrt, 
            maxValue: datecurEnd        
            },
			{
			    xtype: 'label',
                text: '',
                cls: 'labelstyle',
                width:50,
                id: 'empty3'
			},
			{
            xtype: 'label',
            cls: 'labelstyle',
            id: 'endDatelablepmr',
            width: 200,
            text: '<%=EndDate%>' + ' :'
            },  
			{
            xtype: 'datefield',          
            emptyText: '<%=SelectEndDate%>',
            allowBlank: false,
            blankText: '<%=SelectEndDate%>',
            id: 'endDatePmr',        
            cls: 'selectstylePerfect' ,
            format: getDateFormat(),
            value:  new Date(), 
            maxValue: nextDaate           
            },
			
			{   xtype: 'label',
                text: '',
                cls: 'labelstyle',
                width:50,
                id: 'emptyPm'
			},
			{   xtype: 'label',
                text: '',
                cls: 'labelstyle',
                 width:100,
                id: 'emptyp'
			},
			{
            xtype: 'button',
            text: 'View',
            id: 'submitId2',
            cls: 'buttonStyle',
            width: 60,
            handler: function() {
            buttonFunction();
        }
        }
        ]
    });

    var reader = new Ext.data.JsonReader({
        idProperty: 'ReportId',
        root: 'ViewRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'vehicleNoDataIndex'
        },  {
            name: 'NoOfTripsDataIndex'
        }, {
            name: 'TotalKmsTravelledDataIndex'
        },{
            name: 'AvrageKmPerTripDataIndex'
        }, {
            name: 'TotalDurationDataIndex'
        }, {
            name: 'AvrageDurationDatIndex'
        }, {        
            name: 'OdometerDataIndex'
        }, {
            name: 'LastKnownDateDataIndex',
            type: 'date',
            dateFormat: getDateTimeFormat()
            
        }, {
	            name: 'tripDurationIndex'
	        },{
	            name: 'maxSpeedIndex'
	        }, {
	            name: 'speedLimitIndex'
	        }, {        
	            name: 'OSCountIndex'
	        }, {        
	            name: 'HACountIndex'
	        },{        
	            name: 'HBCountIndex'
	        },{        
	            name: 'IdleCountIndex'
	        },{        
	            name: 'SeatBeltCountIndex'
	        },{        
	            name: 'IdledurationIndex'
	        },{        
	            name: 'PathOSdurationIndex'
	        },{        
	            name: 'PathOSCountIndex'
	        },{        
	            name: 'startDateTimeIndex'
	        },{        
	            name: 'endDateTimeIndex'
	        }]
    });
    
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/VehicleTripSummaryAction.do?param=View',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'ViewRootId',
        reader: reader
    });
    
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
       
         type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'vehicleNoDataIndex'
        },  {
             type: 'numeric',
            dataIndex: 'NoOfTripsDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'TotalKmsTravelledDataIndex'
        },{
            type: 'numeric',
            dataIndex: 'AvrageKmPerTripDataIndex'
        },{
             type: 'string',
            dataIndex: 'TotalDurationDataIndex'
        },{
            type: 'string',
            dataIndex: 'AvrageDurationDatIndex'
        }, {
            type: 'numeric',
            dataIndex: 'OdometerDataIndex'
        }, {
            type: 'date',
            dataIndex: 'LastKnownDateDataIndex'
        },{
	            type: 'numeric',
	            dataIndex: 'tripDurationIndex'
	        },{
	             type: 'numeric',
	            dataIndex: 'maxSpeedIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'speedLimitIndex'
	        }, {
	            type: 'numeric',
	            dataIndex: 'OSCountIndex'
	        }, {
	            type: 'numeric',
	            dataIndex: 'HACountIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'HBCountIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'IdleCountIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'SeatBeltCountIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'IdledurationIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'PathOSdurationIndex'
	        },{
	            type: 'numeric',
	            dataIndex: 'PathOSCountIndex'
	        }
        ]
    });

    var createColModel = function(finish, start) {
        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                filter: {
                    type: 'numeric'
                }
            },
		   {
                header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
                dataIndex: 'vehicleNoDataIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },
            			
		    {
                header: "<span style=font-weight:bold;><%=NoOfTrips%></span>",
                dataIndex: 'NoOfTripsDataIndex',
                width: 100,                
                filter: {
                    type: 'numeric'
                }
            },
			{
                header: "<span style=font-weight:bold;><%=TotalKmsTravelled%></span>",
                dataIndex: 'TotalKmsTravelledDataIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },
			{
                header: "<span style=font-weight:bold;><%=AvrageKmPerTrip%></span>",
                dataIndex: 'AvrageKmPerTripDataIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },
			{
                header: "<span style=font-weight:bold;><%=TotalDuration%></span>",
                dataIndex: 'TotalDurationDataIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },
			{
                header: "<span style=font-weight:bold;><%=AvrageDuration%></span>",
                dataIndex: 'AvrageDurationDatIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },
			{
                header: "<span style=font-weight:bold;><%=Odometer%></span>",
                dataIndex: 'OdometerDataIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            },
            {
                header: "<span style=font-weight:bold;><%=LastKnownDate%></span>",
                dataIndex: 'LastKnownDateDataIndex',
                width: 100,
                filter: {
                    type: 'date'
                },
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat())
            },{
	                header: "<span style=font-weight:bold;><%=TripDuration%></span>",
	                dataIndex: 'tripDurationIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },
				{
	                header: "<span style=font-weight:bold;><%=MaxSpeed%></span>",
	                dataIndex: 'maxSpeedIndex',
	                width: 80,
	                filter: {
	                    type: 'numeric'
	                }
	            },
				{
	                header: "<span style=font-weight:bold;><%=SpeedLimit%></span>",
	                dataIndex: 'speedLimitIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=OSCount%></span>",
	                dataIndex: 'OSCountIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=HACount%></span>",
	                dataIndex: 'HACountIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=HBCount%></span>",
	                dataIndex: 'HBCountIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=IdleCount%></span>",
	                dataIndex: 'IdleCountIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=SeatBeltCount%></span>",
	                dataIndex: 'SeatBeltCountIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },
				{
	                header: "<span style=font-weight:bold;><%=IdleDuration%></span>",
	                dataIndex: 'IdledurationIndex',
	                width: 100,
	                filter: {
	                    type: 'numeric'
	                }
	            },
				{
	                header: "<span style=font-weight:bold;><%=PathOsDuration%></span>",
	                dataIndex: 'PathOSdurationIndex',
	                width: 50,
	                filter: {
	                    type: 'numeric'
	                }
	            },{
	                header: "<span style=font-weight:bold;><%=PathOsCount%></span>",
	                dataIndex: 'PathOSCountIndex',
	                width: 50,
	                filter: {
	                    type: 'numeric'
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
    var grid = CustomizedGrid('', '<%=NoRecordsfound%>', store, screen.width - 70, 400, 26, filters, '<%=ClearFilterData%>', false, '', 14, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>',true,'Trip Details');
 
 
   function CustomizedGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
                render : function(grid){
                  grid.store.on('load', function(store, records, options){
                    grid.getSelectionModel().selectFirstRow();       
                  });                      
                }
               },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
            text: reconfigurestr,
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
			    if(Ext.getCmp('radio2').getValue()== true){
			jspName = '<%=TripSummaryReportDateWise%>';
          	reportName = '<%=TripSummaryReportDateWise%>'; 
			    }else{
			jspName = '<%=TripSummaryReport%>';
          	reportName = '<%=TripSummaryReport%>';
			    }
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			   buttonClick = 'pdf';
			   buttonFunction();
			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importExcelData();

			    }    
			  }]);
		}
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}

	return grid;
}
 
    Ext.onReady(function() {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '<%=TripSummaryReport%>',
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            cls: 'outerpanel',
            layout: 'table',
            height: 516,
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, grid]
  
        });
        sb = Ext.getCmp('form-statusbar');
jspName = '<%=TripSummaryReport%>'; 
reportName = '<%=TripSummaryReport%>';
Ext.getCmp('assetTypelab2').show();
Ext.getCmp('ShiftNameComboId').show();
Ext.getCmp('startTimeLabelId').show();
Ext.getCmp('SatrtTimeText').show();
Ext.getCmp('endTimeLabelId').show();
Ext.getCmp('EndTimeText').show();
    });
 
</script>
 </body>
</html>