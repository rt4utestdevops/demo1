<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String checkDashBoardDetails="";
String fromdateformonitoringpage="";
String todateformonitoringpage ="";
if(request.getParameter("fromdate") != null && request.getParameter("todate") !=null){
	String fromdatemonitoring = request.getParameter("fromdate");
if(fromdatemonitoring.contains("+0530")){
	fromdateformonitoringpage = fromdatemonitoring.replace("+0530 ", " ");
}else{
	fromdateformonitoringpage = fromdatemonitoring.replace(" 0530 ", " ");
}
String todatemonitoring=request.getParameter("todate");
if(todatemonitoring.contains("+0530")){
	todateformonitoringpage = todatemonitoring.replace("+0530 ", " ");
}else{
	todateformonitoringpage = todatemonitoring.replace(" 0530 ", " ");
}
checkDashBoardDetails=request.getParameter("checkDashBoardDetails");
}

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
	
	

ArrayList<String> convertedWords = new ArrayList<String>();

String My_Jsp="APMTTripDetails";
String Trip_Date="Trip Date";
String Start_Location="Start Location";
String End_Location="End Location";
String In_Time_Start_Location="In time(StartLocation)";
String Out_Time_Start_Location="Out time(StartLocation)";
String Port_Detention_Start_Location="Port Detention(StartLocation)";
String Total_Enroute_Stoppage_from_Port_to_Milestone_3="Total Enroute Stoppage from PORT to CFS";
String Total_Enroute_Stoppage_from_Milestone_1_to_Port=" Total Enroute Stoppage from Import CFS/Yard to Port";
String Name_of_Milestone_1="Name of Milestone 1";
String Milestone_1_In_time="Milestone 1:In-time";
String Milestone_1_Out_time= "Milestone 1:Out-time";
String Detention_at_Milestone_1="Detention at Milestone 1";

String Name_of_Milestone_2="Name of Milestone 2";
String Milestone_2_In_time="Milestone 2: In-time";
String Milestone_2_Out_time= "Milestone2 Out-time";
String Detention_at_Milestone_2="Detention at Milestone 2";

String Name_of_Milestone_3="Name of Milestone 3";
String Milestone_3_In_time="Milestone 3:In-time";
String Milestone_3_Out_time= "Milestone 3:Out-time";
String Detention_at_Milestone_3="Detention at Milestone 3";
String Src_Milestone_Stoppage="Enroute Stoppage from PORT to Last Milestone";
String Stoppage_Count="Stoppage Count";
String at_Milestones_Port_to_CFS="Total Detention at Milestones(Port to CFS)";
String Total_Detention_at_Milestones_Port_to_CFS="Transit time from Port to Import CFS/Yard";
String In_Time_End_Location="In Time(End Location)";
String Out_Time_End_Location="Out Time(End Location)";
String Detention_End_Location="Detention(End Location)";
String Name_of_Milestone_4="Name of Milestone 4";
String Milestone_4_In_time="Milestone 4:In-time";
String Milestone_4_Out_time= "Milestone 4:Out-time";
String Detention_at_Milestone_4="Detention at Milestone 4";
String Name_of_Milestone_5="Name of Milestone 5";
String Milestone_5_In_time="Milestone 5:In-time";
String Milestone_5_Out_time= "Milestone 5:Out-time";
String Detention_at_Milestone_5="Detention at Milestone 5";
String Name_of_Milestone_6="Name of Milestone 6";
String Milestone_6_In_time="Milestone 6:In-time";
String Milestone_6_Out_time= "Milestone 6:Out-time";
String Detention_at_Milestone_6="Detention at Milestone 6";
String Dest_Milestone_Stoppage="Enroute Stoppage from First Milestone to PORT";
String Transit_time_from_CFS_to_port="Transit time from CFS to port";
String Vehicle_No="Vehicle No";
String at_Milestones_CFS_to_Port="Total Detention at Milestones(CFS to Port)";
String Return_to_Port_Name =" Return to Port(Port Name)" ;
String Return_to_Port_In_time ="Return to Port(In-time)";
String Total_Round_Trip_time="Total Round Trip time";
String SelectCustomer="Select Customer";
String CustomerName="Customer Name";
String StartDate="Start Date";
String SelectStartDate="Select Start Date";
String EndDate="End Date";
String SelectEndDate="Select End Date";
String SLNO="SL No";
String PleaseSelectCustomer="Please Select Customer";
String PleaseSelectReportType="Please Select Report Type";
String PleaseSelectStartDate="Please Select StartDate";
String PleaseSelectEndDate="Please Select End Date";
String EndDateMustBeGreaterthanStartDate="End Date Must Be Greater than Start Date";
String monthValidation="month Validation";
String NoRecordsfound="No Records found";
String Excel="Excel";
String Export_In_Time="Export In Time";
String Export_Out_Time="Export Out Time";
String Export_Detention="Export Detention";
String Transit_time_from_Import_to_Export_CFSyard="Transit time from Import CFS/Yard to Export CFS/Yard";
String Transit_time_from_Export_yard_to_Port="Transit time from Export yard to Port";
String Total_Enroute_Stoppage_from_Export_CFSyard_to_Import_CFSyard="Total Enroute Stoppage from Import CFS/Yard to Export CFS/Yard";
String Export_Location="Export Location";
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">
    
    <title>Trip Details</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->

 
 <style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}


	
</style>
		
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
		<jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			label {
				display : inline !important;
			}
			.footer {
				bottom : -4px !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
			.x-btn-noicon .x-btn-small .x-btn-text {	
				font-size: 15px !important;
			}
		</style>
		<script>
   var outerPanel;
   var checkDashBoardDetails='<%=checkDashBoardDetails%>';
    var dtprev = dateprev;
  var dtcur = datecur;
  var jspName = "APMTTripDetailsReport";
  var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
  var endDate = "";
  var grid;
  window.onload = function () { 
		loadPreviousRecords();
	}
  var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
        type: 'int',
            dataIndex: 'slnoIndex'
        }, {
            type: 'Date',
            dataIndex: 'TripDateDataIndex'
        }, {
            type: 'string',
            dataIndex: 'VehiclenoDataIndex'
     
        }, {
            type: 'string',
            dataIndex: 'StartLocationDataIndex'
        }, {
            type: 'string',
            dataIndex: 'EndLocationDataIndex'
        }, {
            type: 'string',
            dataIndex: 'InTimestartLocationDataIndex'
        }, {
            type: 'string',
            dataIndex: 'OutTimestartLocationDataIndex'
        }, {
            type: 'string',
            dataIndex: 'PortDetentionstartLocationDataIndex'
        },{
            type: 'string',
            dataIndex: 'NameofMilestone1DataIndex'
        },{
            type: 'Date',
            dataIndex: 'Milestone1InTimeDataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'Milestone1OutTimeDataIndex'
        },
        {
            type: 'string',
            dataIndex: 'DetentionatMilestone1DataIndex'
        },
        {
            type: 'string',
            dataIndex: 'NameofMilestone2DataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'Milestone2InTimeDataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'Milestone2OutTimeDataIndex'
        },
        {
            type: 'string',
            dataIndex: 'DetentionatMilestone2DataIndex'
        },
        {
            type: 'string',
            dataIndex: 'NameofMilestone3DataIndex'
        },{
            type: 'Date',
            dataIndex: 'Milestone3InTimeDataIndex'
        },{
            type: 'Date',
            dataIndex: 'Milestone3OutTimeDataIndex'
        },{
            type: 'string',
            dataIndex: 'DetentionatMilestone3DataIndex'
        },{
            type: 'string',
            dataIndex: 'Src_Milestone_Stoppage'
        },
        {
            type: 'string',
            dataIndex: 'atMilestonesPorttoCFSDataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'InTimeEndLocationDataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'OutTimeEndLocationDataIndex'
        },
        {
            type: 'string',
            dataIndex: 'DetentionEndLocationDataIndex'
        },
        {
            type: 'string',
            dataIndex: 'DetentionPortandCFSDataIndex'
        },
        {
            type: 'string',
            dataIndex: 'NameofMilestone4DataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'Milestone4InTimeDataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'Milestone4OutTimeDataIndex'
        },
        {
            type: 'string',
            dataIndex: 'DetentionatMilestone4DataIndex'
        },
        {
            type: 'string',
            dataIndex: 'NameofMilestone5DataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'Milestone5InTimeDataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'Milestone5OutTimeDataIndex'
        },
        {
            type: 'string',
            dataIndex: 'DetentionatMilestone5DataIndex'
        },
        {
            type: 'string',
            dataIndex: 'NameofMilestone6DataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'Milestone6InTimeDataIndex'
        },
        {
            type: 'Date',
            dataIndex: 'Milestone6OutTimeDataIndex'
        },{
            type: 'string',
            dataIndex: 'Dest_Milestone_Stoppage'
        },
        {
            type: 'string',
            dataIndex: 'DetentionatMilestone6DataIndex'
        },
        {
            type: 'string',
            dataIndex: 'DetentionatCfsAndPortDataIndex'
        },
        {
            type: 'string',
            dataIndex: 'atMilestonesCFStoPortDataIndex'
        },{
            type: 'string',
            dataIndex: 'exportLocationIndex'
        },{
            type: 'string',
            dataIndex: 'exportInTimeIndex'
        },{
            type: 'string',
            dataIndex: 'exportOutTimeIndex'
        },{
            type: 'string',
            dataIndex: 'exportDetentionIndex'
        },{
            type: 'string',
            dataIndex: 'transitTimeImportToExportCFSYardIndex'
        },{
            type: 'string',
            dataIndex: 'transitTimeExportYardToPortIndex'
        },{
            type: 'string',
            dataIndex: 'totalStoppageExportToImportCFSYardIndex'
        },{
            type: 'string',
            dataIndex: 'PortNameDataIndex'
        },{
            type: 'string',
            dataIndex: 'ReturntoPortInTimeDataIndex'
        },{
            type:'String',
            dataIndex: 'StoppagecountDataIndex'
        },{
        type:'String',
            dataIndex: 'Enrotestoppagemilestone3DataIndex'
        },{
        type:'String',
            dataIndex: 'Enrotestoppagemilestone1DataIndex'
        },{
            type: 'string',
            dataIndex: 'TotalRoundTriptimeDataIndex'
        }
        ]
    });
    
  
  
   var reader = new Ext.data.JsonReader({
         idProperty: 'servicedetailid',
        root: 'ServiceTypeRoot',
        totalProperty: 'total',
        fields: [{
        name: 'slnoIndex'
        }, {
            name: 'TripDateDataIndex',
            type: 'date'
        }, {
      
            name: 'VehiclenoDataIndex'
        }, {
            name: 'StartLocationDataIndex'
        }, 
        {
            name: 'EndLocationDataIndex'
        },{
            name: 'InTimestartLocationDataIndex'
        }, {
            name: 'OutTimestartLocationDataIndex'
        }, {
            name: 'PortDetentionstartLocationDataIndex'
        },
        {
            name: 'NameofMilestone1DataIndex'
        },
        {
            name: 'Milestone1InTimeDataIndex'
        },
        {
            name: 'Milestone1OutTimeDataIndex'
        },
        {
           
            name: 'DetentionatMilestone1DataIndex'
        },
        {
            name: 'NameofMilestone2DataIndex'
        },
        {
            name: 'Milestone2InTimeDataIndex'
        },
        {
             name: 'Milestone2OutTimeDataIndex'
        },
        {
            name: 'DetentionatMilestone2DataIndex'
        },
        {
            name: 'NameofMilestone3DataIndex'
        },
        {
            name: 'Milestone3InTimeDataIndex'
        },
        {
            name: 'Milestone3OutTimeDataIndex'
        },
        {
            name: 'DetentionatMilestone3DataIndex'
        },
        {
            name: 'Src_Milestone_Stoppage'
        },
        {
            name: 'atMilestonesPorttoCFSDataIndex'
        },
        {
            name: 'InTimeEndLocationDataIndex'
        },
        {
            name: 'OutTimeEndLocationDataIndex'
        },
        {
            name: 'DetentionEndLocationDataIndex'
        },
        {
            name: 'DetentionPortandCFSDataIndex'
        },
        {
            name: 'NameofMilestone4DataIndex'
        },
        {
            name: 'Milestone4InTimeDataIndex'
        },
        {
            name: 'Milestone4OutTimeDataIndex'
        },
        {
            name: 'DetentionatMilestone4DataIndex'
        },
        {
            name: 'NameofMilestone5DataIndex'
        },
        {
            name: 'Milestone5InTimeDataIndex'
        },
        {
            name: 'Milestone5OutTimeDataIndex'
        },
        {
            name: 'DetentionatMilestone5DataIndex'
        },
        {
            name: 'NameofMilestone6DataIndex'
        },
        {
            name: 'Milestone6InTimeDataIndex'
        },
        {
            name: 'Milestone6OutTimeDataIndex'
        },
        {
            name: 'DetentionatMilestone6DataIndex'
        },
        {
            name: 'Dest_Milestone_Stoppage'
        },
        {
            name: 'DetentionatCfsAndPortDataIndex'
        },
        {
            name: 'atMilestonesCFStoPortDataIndex'
        },
        {
            name: 'exportLocationIndex'
        },
        {
            name: 'exportInTimeIndex'
        },
        {
            name: 'exportOutTimeIndex'
        },
        {
            name: 'exportDetentionIndex'
        },
        {
            name: 'transitTimeImportToExportCFSYardIndex'
        },
        {
            name: 'transitTimeExportYardToPortIndex'
        },
        {
            name: 'totalStoppageExportToImportCFSYardIndex'
        },
        {
            name: 'PortNameDataIndex'
        },
        {
            name: 'ReturntoPortInTimeDataIndex'
        },
        {
            name: 'StoppagecountDataIndex'
        },
        {
            name: 'Enrotestoppagemilestone3DataIndex'
        },
        {
            name: 'Enrotestoppagemilestone1DataIndex'
        },
        {
            name: 'TotalRoundTriptimeDataIndex'
        }
        ]
    });
  
   var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/StoppageReportAction.do?param=getAPMTTripDetails',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'TripDateDataIndex',
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
                     jspName: jspName
                    
                };
            }, this);
  
  
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
<!--                      servicenamestore.load({-->
<!--                         params: {-->
<!--                           customerID: Ext.getCmp('custcomboId').getValue()-->
<!--                        }-->
<!--                   });-->
                  
              }
          }
      }
  });
  
  function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {
if (grid.getSelectionModel().getCount() == 1) {
 var selected = grid.getSelectionModel().getSelected();
var startDate=selected.get('OutTimestartLocationDataIndex');
var EndDate=selected.get('ReturntoPortInTimeDataIndex');
var VehicleNo=selected.get('VehiclenoDataIndex');
var customerID= Ext.getCmp('custcomboId').getValue();
var fromdate= Ext.getCmp('startdate').getValue();
var todate= Ext.getCmp('enddate').getValue();
               //window.location="http://localhost:8080/Telematics4uApp/Jsps/AutomotiveLogistics/APMTPage.jsp?StartDate="+StartDate1+"&EndDate="+EndDate1+"";
           window.location = "<%=request.getContextPath()%>/Jsps/DistributionLogistics/StoppageReport.jsp?startDate="+startDate+"&EndDate="+EndDate+"&VehicleNo="+VehicleNo+"&cutomerID="+customerID+"&fromdate="+fromdate+"&todate="+todate;
} 
}
      

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
<!--                      servicenamestore.load({-->
<!--                         params: {-->
<!--                           customerID: Ext.getCmp('custcomboId').getValue()-->
<!--                        }-->
<!--                   });-->
                   
              }
          }
      }
  });
  var editInfo1 = new Ext.Button({
      text: 'Submit',
      id: 'submitId',
      cls: 'buttonStyle',
      width: 80,
  
        handler: function () {
           //store.load();
          var clientName = Ext.getCmp('custcomboId').getValue();
          var startdate = Ext.getCmp('startdate').getValue();
          var enddate = Ext.getCmp('enddate').getValue();
           if (Ext.getCmp('custcomboId').getValue() == "") {

              Ext.example.msg("<%=PleaseSelectCustomer%>");
              Ext.getCmp('custcomboId').focus();
              return;
          }
<!--           if (Ext.getCmp('serviceTypeComboId').getValue() == "") {-->
<!--             -->
<!--              Ext.example.msg("<%=PleaseSelectReportType%>");-->
<!--              Ext.getCmp('custcomboId').focus();-->
<!--              return;-->
<!--          }-->
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
               if (dateCompare(Ext.getCmp('enddate').getValue(), dtcur)== -1) {
                  Ext.example.msg("Endate should not be greater than Current date");
                  Ext.getCmp('enddate').focus();
                  return;
              }
          store.load({
              params: {
                  CustId: Ext.getCmp('custcomboId').getValue(),
                  custName: Ext.getCmp('custcomboId').getRawValue(),
                  startDate: Ext.getCmp('startdate').getValue(),
                  endDate: Ext.getCmp('enddate').getValue(),
                  jspName: jspName
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
              width: 100
         
          },
          {
              width: 100
         
          },
          {
              width: 100
         
          },
          {
              width: 100
         
          },
          {
              width: 100
         
          },
         {
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
          },
           {
              width: 80
          },editInfo1
      ]
  });
  
  
  var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 60
        }), {
        dataIndex: 'slnoIndex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 20,
            filter: {
                type: 'int'
                },
                hidden:true
       }, {
            dataIndex: 'TripDateDataIndex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=Trip_Date%></span>",
            width: 200,
            renderer: Ext.util.Format.dateRenderer('d/m/Y'),
            filter: {
                type: 'Date'
            }
            }, {
            dataIndex: 'VehiclenoDataIndex',
            hidden: false,
            header: "<span style=font-weight:bold;><%=Vehicle_No%></span>",
            width: 200,
            filter: {
                type: 'String'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Start_Location%></span>",
            hidden: false,
            width: 300,
            //sortable: false,
            dataIndex: 'StartLocationDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=End_Location%></span>",
            hidden: false,
            width: 200,
            //sortable: true,
            dataIndex: 'EndLocationDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=In_Time_Start_Location%></span>",
            hidden: false,
            width: 300,
            //sortable: true,
            dataIndex: 'InTimestartLocationDataIndex',
          //  renderer: Ext.util.Format.dateRenderer('Y-m-d H:i:s'),
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=Out_Time_Start_Location%></span>",
            hidden: false,
            width: 300,
            //sortable: true,
          // renderer: Ext.util.Format.dateRenderer('Y-m-d H:i:s'),
            dataIndex: 'OutTimestartLocationDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=Port_Detention_Start_Location%></span>",
            hidden: false,
            width: 300,
            //sortable: true,
            dataIndex: 'PortDetentionstartLocationDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Name_of_Milestone_1%></span>",
            hidden: false,
            width: 300,
            //sortable: true,
            dataIndex: 'NameofMilestone1DataIndex',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Milestone_1_In_time%></span>",
            hidden: false,
            width: 300,
            //sortable: true,
            dataIndex: 'Milestone1InTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Milestone_1_Out_time%></span>",
            hidden: false,
            width: 200,
           // sortable: true,
            dataIndex: 'Milestone1OutTimeDataIndex',
            filter: {
                type: 'Date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Detention_at_Milestone_1%></span>",
            hidden: false,
            width: 200,
           // sortable: true,
            dataIndex: 'DetentionatMilestone1DataIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Name_of_Milestone_2%></span>",
            hidden: false,
           width: 300,
            //sortable: true,
            dataIndex: 'NameofMilestone2DataIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Milestone_2_In_time%></span>",
            hidden: false,
            width: 300,
            //sortable: true,
            dataIndex: 'Milestone2InTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Milestone_2_Out_time%></span>",
            hidden: false,
           width:300,
            //sortable: true,
            dataIndex: 'Milestone2OutTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Detention_at_Milestone_2%></span>",
            hidden:false,
           width: 300,
            //sortable: true,
            dataIndex: 'DetentionatMilestone2DataIndex',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Name_of_Milestone_3%></span>",
            hidden:false,
          width: 300,
            //sortable: true,
            dataIndex: 'NameofMilestone3DataIndex',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Milestone_3_In_time%></span>",
            hidden:false,
           width: 300,
            //sortable: true,
            dataIndex: 'Milestone3InTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Milestone_3_Out_time%></span>",
            hidden:false,
            width: 320,
            //sortable: true,
            dataIndex: 'Milestone3OutTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Detention_at_Milestone_3%></span>",
            hidden:false,
            width: 320,
            //sortable: true,
            dataIndex: 'DetentionatMilestone3DataIndex',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Src_Milestone_Stoppage%></span>",
            hidden:false,
            width: 320,
            //sortable: true,
            dataIndex: 'Src_Milestone_Stoppage',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=at_Milestones_Port_to_CFS%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'atMilestonesPorttoCFSDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=In_Time_End_Location%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'InTimeEndLocationDataIndex',
            filter: {
                type: 'Date'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Out_Time_End_Location%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'OutTimeEndLocationDataIndex',
            filter: {
                type: 'Date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Detention_End_Location%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'DetentionEndLocationDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Total_Detention_at_Milestones_Port_to_CFS%></span>",
            hidden: false,
            width: 20,
            //sortable: true,
            dataIndex: 'DetentionPortandCFSDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Export_Location%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'exportLocationIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Export_In_Time%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'exportInTimeIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Export_Out_Time%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'exportOutTimeIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Export_Detention%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'exportDetentionIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Transit_time_from_Import_to_Export_CFSyard%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'transitTimeImportToExportCFSYardIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Name_of_Milestone_4%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'NameofMilestone4DataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Milestone_4_In_time%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'Milestone4InTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Milestone_4_Out_time%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'Milestone4OutTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Detention_at_Milestone_4%></span>",
            hidden: false,
           width: 320,
            //sortable: true,
            dataIndex: 'DetentionatMilestone4DataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Name_of_Milestone_5%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'NameofMilestone5DataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Milestone_5_In_time%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'Milestone5InTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Milestone_5_Out_time%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'Milestone5OutTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Detention_at_Milestone_5%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'DetentionatMilestone5DataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Name_of_Milestone_6%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex:'NameofMilestone6DataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Milestone_6_In_time%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'Milestone6InTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Milestone_6_Out_time%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'Milestone6OutTimeDataIndex',
            filter: {
                type: 'Date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Detention_at_Milestone_6%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'DetentionatMilestone6DataIndex',
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Dest_Milestone_Stoppage%></span>",
            hidden:false,
            width: 320,
            //sortable: true,
            dataIndex: 'Dest_Milestone_Stoppage',
            filter: {
                type: 'string'
            }
        }
        ,{
            header: "<span style=font-weight:bold;><%=Transit_time_from_CFS_to_port%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'DetentionatCfsAndPortDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=at_Milestones_CFS_to_Port%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'atMilestonesCFStoPortDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Transit_time_from_Export_yard_to_Port%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'transitTimeExportYardToPortIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Total_Enroute_Stoppage_from_Export_CFSyard_to_Import_CFSyard%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'totalStoppageExportToImportCFSYardIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Return_to_Port_Name%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'PortNameDataIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Return_to_Port_In_time%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
           // renderer: Ext.util.Format.dateRenderer('Y-m-d H:i:s'),
            dataIndex: 'ReturntoPortInTimeDataIndex',
            filter: {
                type: 'string'
            }
        },{
         header: "<span style=font-weight:bold;><%=Stoppage_Count%></span>",
            hidden: false,
           width: 320,
            //sortable: true,
            dataIndex: 'StoppagecountDataIndex',
            filter: {
                type: 'String'
            }
        },{
         header: "<span style=font-weight:bold;><%=Total_Enroute_Stoppage_from_Port_to_Milestone_3%></span>",
            hidden: false,
           width: 320,
            //sortable: true,
            dataIndex: 'Enrotestoppagemilestone3DataIndex',
            filter: {
                type: 'String'
            }
        },{
         header: "<span style=font-weight:bold;><%=Total_Enroute_Stoppage_from_Milestone_1_to_Port%></span>",
            hidden: false,
           width: 320,
            //sortable: true,
            dataIndex: 'Enrotestoppagemilestone1DataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=Total_Round_Trip_time%></span>",
            hidden: false,
            width: 320,
            //sortable: true,
            dataIndex: 'TotalRoundTriptimeDataIndex',
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
grid = getGrid('', '<%=NoRecordsfound%>', store, screen.width-40, 350, 60, filters,'', false, '', 60, false, '', false, '', true, '<%=Excel%>',jspName, exportDataType);

grid.on({
      "cellclick": {
          fn: onCellClickOnGrid
      }
  });
 

function loadPreviousRecords(){
		if(checkDashBoardDetails == '1'){
		
		 var prevfromdate = '<%=fromdateformonitoringpage%>';
			 var dt = new Date(prevfromdate);
			 var mnth = ("0" + (dt.getMonth()+1)).slice(-2);
			 var day  = ("0" + dt.getDate()).slice(-2);
			 var prevfromdates= [day,mnth,dt.getFullYear() ].join("-");
			 
			 var prevtodate = '<%=todateformonitoringpage%>';
			 var dts = new Date(prevtodate);
			 var mnths = ("0" + (dts.getMonth()+1)).slice(-2);
			 var days  = ("0" + dts.getDate()).slice(-2);
			 var prevtodates= [days,mnths,dts.getFullYear() ].join("-");
			 
			  Ext.getCmp('startdate').setValue(prevfromdates);
			 Ext.getCmp('enddate').setValue(prevtodates);
			 
			 Ext.getCmp('custcomboId').setValue('<%=customerId%>');
			   store.load({
              params: {
                  CustId: Ext.getCmp('custcomboId').getValue(),
                  custName: Ext.getCmp('custcomboId').getRawValue(),
                  startDate: Ext.getCmp('startdate').getValue(),
                  endDate: Ext.getCmp('enddate').getValue(),
                  jspName: jspName
              }
          });
          
          }
	}

   Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 180000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Trip Details',
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
        items: [clientPanel,grid]
    });
    
    var cm = grid.getColumnModel();
        for (var j = 1; j < cm.getColumnCount(); j++) {
            cm.setColumnWidth(j, 170);
        }
    setTimeout(function(){

     store.load({
              params: {
                  CustId: Ext.getCmp('custcomboId').getValue(),
                  custName: Ext.getCmp('custcomboId').getRawValue(),
                  startDate: Ext.getCmp('startdate').getValue(),
                  endDate: Ext.getCmp('enddate').getValue(),
                  jspName: jspName
              }
          }); 
          }, 1000);
});

   </script>
	 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    