<%@ page language="java" import="java.util.*" pageEncoding="ISO-8859-1"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%@page import="t4u.functions.CommonFunctions"%>
<%@page import="t4u.beans.LoginInfoBean"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
	
	ArrayList<String> tobeConverted = new ArrayList<String>();
	tobeConverted.add("Select_Customer_Name");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Please_Select_customer");
	tobeConverted.add("Start_Date");
	tobeConverted.add("Select_Start_Date");
	tobeConverted.add("Please_Select_Start_Date");
	tobeConverted.add("End_Date");
	tobeConverted.add("Select_End_Date");
	tobeConverted.add("Please_Select_End_Date");
	tobeConverted.add("SLNO");
	tobeConverted.add("Asset_Number");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	tobeConverted.add("Vehicle_Group");
	tobeConverted.add("Select_Group_Name");
	tobeConverted.add("Total_Trip_Duration");
	tobeConverted.add("Utilization_Graph");
	tobeConverted.add("Vehicle_No");
	tobeConverted.add("Asset_Utilization_Reports");
	tobeConverted.add("Month_Validation");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectCustomer=convertedWords.get(0);
String CustomerName=convertedWords.get(1);
String PleaseSelectCustomer=convertedWords.get(2);
String StartDate=convertedWords.get(3);
String SelectStartDate=convertedWords.get(4);
String PleaseSelectStartDate = convertedWords.get(5);
String EndDate=convertedWords.get(6);
String SelectEndDate=convertedWords.get(7);
String PleaseSelectEndDate = convertedWords.get(8);
String SLNO=convertedWords.get(9);
String assetNumber = convertedWords.get(10);
String Excel=convertedWords.get(11);
String PDF=convertedWords.get(12);
String ClearFilterData=convertedWords.get(13);
String NoRecordsfound=convertedWords.get(14);
String EndDateMustBeGreaterthanStartDate = convertedWords.get(15);
String VehicleGroup = convertedWords.get(16);
String SelectVehicleGroup = convertedWords.get(17); 
String TotalTripDuration = convertedWords.get(18);
String Graph =  convertedWords.get(19);
String VehicleNo = convertedWords.get(20);
String vehicleUtilizationReport = convertedWords.get(21);
String monthValidation = convertedWords.get(22);
String ReportType = "Report Type";
String ShiftName = "Shift Name";
String ShiftTime = "Shift Time";
String SelectShiftName = "Select Shift Name";
String SelectReportType = "Select Report Type";
%>

<jsp:include page="../Common/header.jsp" />
    <title>Vehicle Utilization Report</title>
    <style>		
		.x-panel-header
		{
				height: 7% !important;
		}
		label {
			display: inline !important;
			
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		</style>
    <pack:style src="../../Main/src/widgets/chart/Chart.js"/>
  
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   
   <script>
   Ext.Ajax.timeout = 360000;
   var CustId = 0;
   var ReportTypeId = 0;
   var vehGroupComboId = 0;
   var startTime = "00:00";
   var endTime = "00:00";
   function dateComparecustomized(fromDate, toDate) {
	
	if(fromDate < toDate) {
		return 1;
	} else if(toDate < fromDate) {
		return -1;
	}
	return 0;
}	          
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
            
            var rownum = ShiftNameComboStore.findExact( 'ShiftId', Ext.getCmp('ShiftNameComboId').getValue());
                    if(rownum>=0){
                  var record =   ShiftNameComboStore.getAt(rownum);
                 startTime = record.data['StartTime'];
                 endTime = record.data['EndTime'];
                 Ext.getCmp('SatrtTimeText').setText(startTime+" to "+endTime);
                    }
                    
                      }   
            }
        }
    
});
   
   
       var reportTypeComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/VehicleTripSummaryAction.do?param=getReportType',
        root: 'TypeRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['ReportTypeId', 'ReportTypeName']
    });

    var ReportTypeCombo = new Ext.form.ComboBox({
        store: reportTypeComboStore,
        id: 'reportTypeComboStoreId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=ReportType%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'ReportTypeId',
        displayField: 'ReportTypeName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                  ReportTypeId = Ext.getCmp('reportTypeComboStoreId').getValue();
      if(ReportTypeId  == 1){            
Ext.getCmp('assetTypelab2').show();
Ext.getCmp('ShiftNameComboId').show();
Ext.getCmp('startTimeLabelId').show();
Ext.getCmp('SatrtTimeText').show();
ShiftNameComboStore.load({
                  params:{
                  CustId : Ext.getCmp('custComboId').getValue(),
                  BranchId : vehGroupComboId
                                    }
                  });

   }else{  
startTime = "00:00";
endTime = "00:00";    
Ext.getCmp('assetTypelab2').hide();
Ext.getCmp('ShiftNameComboId').hide();
Ext.getCmp('startTimeLabelId').hide();
Ext.getCmp('SatrtTimeText').hide();
Ext.getCmp('ShiftNameComboId').reset();
Ext.getCmp('SatrtTimeText').setText(startTime+" to "+endTime);
   
   }         
                }
            }
        }
    });
   
   
   //start customer combo
   var customerComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName'],
        listeners: {
            load: function(custstore, records, success, options) {
               if (<%= customerId %> > 0) {
                    Ext.getCmp('custComboId').setValue('<%=customerId%>');
                  	vehicleGroupComboStore.load({ params:{
                  		CustId : Ext.getCmp('custComboId').getValue()
                  	}
                  });                                                                                                 
                }
            }
        }
    });

    var customerCombo = new Ext.form.ComboBox({
        store: customerComboStore,
        id: 'custComboId',
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
                  CustId = Ext.getCmp('custComboId').getValue();
                  vehicleGroupComboStore.load({ params:{
                  		CustId : Ext.getCmp('custComboId').getValue()
                  		}
                  });
                }
            }
        }
    });
    //end customer combo
    //start vehicle group
    var vehicleGroupComboStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getgroup',
        id: 'vehicleGroupStoreId',
        root: 'GroupRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['GroupId', 'GroupName', 'ActivationStatus']
    });

    var vehicleGroupCombo = new Ext.form.ComboBox({
        store: vehicleGroupComboStore,
        id: 'vehicleGroupComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectVehicleGroup%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'GroupId',
        displayField: 'GroupName',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
                  vehGroupComboId = Ext.getCmp('vehicleGroupComboId').getValue();
                }
            }
        }
    });
    
   var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'clientPanelId',
        layout: 'table',
        frame: false,
        width: screen.width - 35,    
        layoutConfig: {
            columns: 3
        },
        items: [{width: 400},{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },
            customerCombo,
			{  width:400 }, 
			{
                xtype: 'label',
                text: '<%=VehicleGroup%>' + ' :',
                cls: 'labelstyle',
                id: 'assetTypelab'
            }, 
			vehicleGroupCombo,{ width:400 }, 
			{
                xtype: 'label',
                text: '<%=ReportType%>' + ' :',
                cls: 'labelstyle',
                id: 'assetTypelab1'
            }, 
			ReportTypeCombo,
            
			{width:400},
			{
                xtype: 'label',
                text: '<%=ShiftName%>' + ' :',
                cls: 'labelstyle',
                id: 'assetTypelab2',
                hidden:true
            }, 
			ShiftNameCombo,
			{width:400},
			{
			
			    xtype: 'label',
                text: '<%=ShiftTime%>' + ' :',
                cls: 'labelstyle',
                id: 'startTimeLabelId',
                hidden:true
			
			},
			{
			    xtype: 'label',
                text: startTime+' to '+endTime,
                cls: 'labelstyle',
                id: 'SatrtTimeText',
                width:40,
                height :100,
                hidden:true
			},
			{width:400},
			{ xtype: 'label',
                text: '',
                id: 'custnamelab1231',
                height:10
                },
			{xtype: 'label',
                text: '',
                id: 'custnamelab12321',
                height:10},
			{width:400},
			{ xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'custnamelab12311',
                height:10
                },
			{xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'custnamelab12312',
                height:10},
			{width:400},
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
            id: 'startDateId',        
            cls: 'selectstylePerfect' ,
            format: getDateFormat(),
            value: previousDate, 
            maxValue: previousDate        
            },
			{ width:400 },
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
            id: 'endDateId',        
            cls: 'selectstylePerfect' ,
            format: getDateFormat(),
            value: currentDate, 
            maxValue: currentDate         
            },
			{ width:400 },{width:200},
			{
            xtype: 'button',
            text: 'Generate Report',
            id: 'ViewButtonId',
            cls: 'buttonStyle',
            width: 60,
            handler: function() {
            	CustId = Ext.getCmp('custComboId').getValue();
            	vehGroupId = Ext.getCmp('vehicleGroupComboId').getValue();
            	vehGroupName = Ext.getCmp('vehicleGroupComboId').getRawValue();
				endDate = Ext.getCmp('endDateId').getValue().format('d-m-Y H:i:s');
				startDate = Ext.getCmp('startDateId').getValue().format('d-m-Y H:i:s');
				ReportTypeId = Ext.getCmp('reportTypeComboStoreId').getValue();
				var ShiftId = Ext.getCmp('ShiftNameComboId').getValue();
				var ShiftName = Ext.getCmp('ShiftNameComboId').getRawValue();
				 if(Ext.getCmp('custComboId').getValue() == "") {
  		                   Ext.example.msg("<%=SelectCustomer%>");
  		                   Ext.getCmp('custComboId').focus();
  		                   return;
  		         }
  		         if(Ext.getCmp('vehicleGroupComboId').getValue() == "") {
  		                   Ext.example.msg("<%=SelectVehicleGroup%>");
  		                   Ext.getCmp('vehicleGroupComboId').focus();
  		                   return;
  		         }
  		         if(Ext.getCmp('reportTypeComboStoreId').getValue() == "") {
  		                   Ext.example.msg("<%=SelectReportType%>");
  		                   Ext.getCmp('reportTypeComboStoreId').focus();
  		                   return;
  		         } 	         
  		         
  		         if(Ext.getCmp('startDateId').getValue() == "") {
  		                   Ext.example.msg("<%=SelectStartDate%>");
  		                   Ext.getCmp('startDateId').focus();
  		                   return;
  		         }
  		         if(Ext.getCmp('endDateId').getValue() == "") {
  		                   Ext.example.msg("<%=SelectEndDate%>");
  		                   Ext.getCmp('endDateId').focus();
  		                   return;
  		         } 
  		         if(ReportTypeId == 0){  	
  		         if (dateCompare(Ext.getCmp('startDateId').getValue(), Ext.getCmp('endDateId').getValue()) == -1) {
                           Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                           Ext.getCmp('endDateId').focus();
                           return;
                 } 
                 }
				 if (checkMonthValidation(Ext.getCmp('startDateId').getValue(), Ext.getCmp('endDateId').getValue())) {
  		                    Ext.example.msg("<%=monthValidation%>");
  		                    Ext.getCmp('endDateId').focus();
  		                    return;
  		         }
  		          if(ReportTypeId == 1){ 
  		          if ( dateComparecustomized(Ext.getCmp('startDateId').getValue(), Ext.getCmp('endDateId').getValue()) == -1 ) {
                           Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                           Ext.getCmp('endDateId').focus();
                           return;
                 } 		           	
  		          if(Ext.getCmp('ShiftNameComboId').getValue() == "") {
  		                   Ext.example.msg("<%=SelectShiftName%>");
  		                   Ext.getCmp('ShiftNameComboId').focus();
  		                   return;
  		                   }
  		        endDate = Ext.getCmp('endDateId').getValue().format('d-m-Y');
				startDate = Ext.getCmp('startDateId').getValue().format('d-m-Y'); 		        
  		        endDate = endDate+" "+endTime+":00";
  		        startDate = startDate+" "+startTime+":00";  
  		        
  		                Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/VehicleTripSummaryAction.do?param=validate',
                            method: 'POST',
                            params: {                              
                                endDate:Ext.getCmp('endDateId').getValue(),
                                ShiftId : Ext.getCmp('ShiftNameComboId').getValue(),
                                BranchId : Ext.getCmp('vehicleGroupComboId').getValue(),
                                CustId : Ext.getCmp('custComboId').getValue()
                                                           
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                              if(message == 'success'){
							  
			            	parent.open('<%=request.getContextPath()%>'+"/vehUtilization?custId="+ CustId +"&vehGroupId="+vehGroupId+"&endDate="+endDate+"&startDate="+startDate+"&vehGroupName="+vehGroupName+"&ReportTypeId="+ReportTypeId+"&ShiftId="+ShiftId+"&ShiftName="+ShiftName+"&systemId="+'<%=systemId%>');
				  
							  
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
  		         }else{
			            	parent.open('<%=request.getContextPath()%>'+"/vehUtilization?custId="+ CustId +"&vehGroupId="+vehGroupId+"&endDate="+endDate+"&startDate="+startDate+"&vehGroupName="+vehGroupName+"&ReportTypeId="+ReportTypeId+"&ShiftId="+ShiftId+"&ShiftName="+ShiftName+"&systemId="+'<%=systemId%>');
                }
        }
        }
        ]
    });
    
   //*****main starts from here*************************
	 Ext.onReady(function(){
		ctsb=tsb;
		Ext.QuickTips.init();
		Ext.form.Field.prototype.msgTarget = 'side';			         	   			
	 	outerPanel = new Ext.Panel({
				title:'Vehicle Utilization Report',
				renderTo : 'content',
				standardSubmit: true,
				autoScroll:false,
				frame:true,
				border:false,
				width:screen.width-38,
				height:500,
				cls:'outerpanel',
				items: [clientPanel]
				//bbar:ctsb
		});
	});
   </script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
