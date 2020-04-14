<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
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
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
int customerId=loginInfo.getCustomerId();
int offset = loginInfo.getOffsetMinutes();
int custidpassed=0;
if(request.getParameter("cutomerIDPassed")!= null)
{
customerId=Integer.parseInt(request.getParameter("cutomerIDPassed"));
}
int list=0;

%>


<jsp:include page="../Common/header.jsp" />

<title>FMS DASHBOARD</title>

<link rel="stylesheet" type="text/css" href="../../Main/modules/cashVan/dashBoard/css/layout.css" />
<link rel="stylesheet" type="text/css" href="../../Main/modules/fleetDashBoard/css/fleetDashBoard.css" />
                              
<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
<pack:script src="../../Main/Js/T4UStatusBar.js"></pack:script>
<pack:script src="../../Main/Js/MsgBox.js"></pack:script>
<pack:script src="../../Main/Js/Common.js"></pack:script>
<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/StatusBar.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/ValidationStatus.js"></pack:script>
<pack:script src="../../Main/resources/ux/fileuploadfield/FileUploadField.js"></pack:script>
<!-- for grid -->
<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
<pack:style src="../../Main/resources/css/ext-all.css" />
<pack:style src="../../Main/resources/css/chooser.css" />

<pack:style src="../../Main/modules/sandMining/theme/css/component.css" />
<pack:style src="../../Main/resources/css/dashboard.css" />
<pack:style src="../../Main/modules/sandMining/theme/css/EXTJSExtn.css" />
<pack:style src="../../Main/resources/css/commonnew.css" />
<pack:style src="../../Main/iconCls/icons.css" />
<pack:style src="../../Main/resources/ux/statusbar/css/statusbar.css" />
<!-- for grid -->
<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
<pack:script src="../../Main/Js/examples1.js"></pack:script>
<pack:style src="../../Main/resources/css/examples1.css" />
<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
<pack:script src="../../Main/Js/jquery-ui.js"></pack:script>	
<pack:script src="../../Main/Js/MonthPickerPlugin.js"></pack:script>
           
<style type="text/css">
            
*.x-panel-body-noheader, *.x-panel-mc *.x-panel-body{
border: white;
}
            
.x-form-field-wrap .x-form-trigger {
 background-image: url(/ApplicationImages/DashBoard/combonew.png) !important;
 border-bottom-color: transparent !important;
 height: 25px;
  }

 .x-form-text,
 textarea.x-form-field {
 border: solid 2px #3897C4 !important;
 height: 25px !important;
 }
                
 .x-form-text,.x-form-textarea,.x-combo-list{
  direction: ltr;
}

</style>

<div class="headerbox">
            <p>
                    FLEET DASHBOARD
            </p>
            </div>
            <img id="loadImage" src="/ApplicationImages/ApplicationButtonIcons/loader.gif" style=" width: 40px; position: absolute;z-index: 4;left: 50%;top: 50%;">
          <div class="alert-mask" id="alert-mask-id"></div>
<script>
if('<%=language%>'=='ar'){
	document.documentElement.setAttribute("dir", "rtl");
}else if('<%=language%>'=='en'){
	document.documentElement.setAttribute("dir", "ltr");
}
function getwindow(jsp){
window.location=jsp;
 }
</script>
  <table id="tableID" style="width:100%;height:90%;background-color:#FFFFFF;margin-top: 0;overflow:hidden" align="center">
  <tr valign="top" height="99%">
  <td height="99%" id="content">
  </td>
  </tr>
</table>
 
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<!-- <script type="text/javascript" src="../../Main/Js/jsapi.js"></script> -->
            
<script>

 // ******************************** all variables declared here  ***********************
var font = 13;
var outerPanel;
var vehicleType = 'CARS';
var viewId = 1;
var ctsb;
var panel1;
var overspeedcount = "";
var alertpannelorder = "";
var googleLoad = false;
Ext.Ajax.timeout = 360000;
var loaded = false;
var dtprev = new Date().add(Date.DAY, -2);
var datecur = new Date().add(Date.DAY, -1);
var maxdate =new Date().add(Date.DAY, -0);
dtprev = dtprev.format('d-m-Y');
dtprev = dtprev+" 00:00:00";
var haxistitle = "Region Names";
datecur = datecur.format('d-m-Y');
datecur = datecur+" 23:59:59";
maxdate = maxdate+" 23:59:59";
var titleOfTheGraph = "";
var vaxistitle = "";
var titleOfTheGraph1 = "";
var vaxistitle1 = "";
var logic = ""
var coulourb=[];
coulourb[0]='#E0502E'; // red
coulourb[1]='#228B22'; // green


var couloury=[];
couloury[0] = '#E7BD1B'; // yellow

var coulourr=[];
coulourr[0] = '#E0502E'; // red

var coulouryrg=[];
coulouryrg[0] = '#228B22'; // green
coulouryrg[1] = '#f59c49'; // orrange
coulouryrg[2] = '#E7BD1B'; // yellow

var coulourarr = [];
coulourarr = couloury;             

var view = true;

//****************************** all stores starts here ************************
var custmastcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getallCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function(cutstore, records, success, options) {
            if (<%=custidpassed%> > 0) {
                Ext.getCmp('custmastcomboId').setValue('<%=custidpassed%>');


            } else if (<%=customerId%> > 0) {
                Ext.getCmp('custmastcomboId').setValue('<%=customerId%>');

            }
        }
    }
});

var viewData = '[{"ViewId":"1","ViewName":"Idling %"},{"ViewId":"2","ViewName":"Idling Trend"},{"ViewId":"3","ViewName":"Average Overspeed Count"},{"ViewId":"4","ViewName":"Fuel Efficiency"},{"ViewId":"5","ViewName":"Preventive Maintenance"},{"ViewId":"6","ViewName":"Statutory Details"},{"ViewId":"7","ViewName":"PM Compliance %"}]';
var viewstore = new Ext.data.JsonStore({
    id: 'ViewTypesStroreId',
    fields: ['ViewId', 'ViewName']
});
viewstore.loadData(Ext.decode(viewData));


var IdlingStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FMSDashBoardAction.do?param=getIdlingdetails',
    id: 'IdlingrootId',
    root: 'Idlingroot',
    autoLoad: false,
    remoteSort: true,
    fields: ['groupName', 'percentage']

});

var IdlingTrendStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FMSDashBoardAction.do?param=getIdlingTrend',
    id: 'IdlingTrendrootId',
    root: 'IdlingTrendroot',
    autoLoad: false,
    remoteSort: true,
    fields: ['groupName', 'percentage1', 'percentage2', 'percentage3']

});

var IdlingTrendStore2 = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FMSDashBoardAction.do?param=getIdlingTrend2',
    id: 'IdlingTrendrootId2',
    root: 'IdlingTrendroot2',
    autoLoad: false,
    remoteSort: true,
    fields: ['groupName', 'percentage1', 'percentage2', 'percentage3']

});

var IdlingStoreNew = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FMSDashBoardAction.do?param=getIdlingdetailsNew',
    id: 'IdlingrootIdNew',
    root: 'IdlingrootNew',
    autoLoad: false,
    remoteSort: true,
   fields: ['groupName', 'percentage1', 'percentage2']

});
var vehicelTypeStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/FMSDashBoardAction.do?param=getTypesNew',
    id: 'vehicelTypeStoreId',
    root: 'vehicelTypeStoreIdRoot',
    autoLoad: false,
   fields: ['VehicleTypeId', 'VehicleTypeName']

});

var statutoryTypeeData = '[{"TypeId":"1","TypeName":"Insurance"},{"TypeId":"2","TypeName":"Goods Token Tax"},{"TypeId":"3","TypeName":"FCI"},{"TypeId":"4","TypeName":"Emission"},{"TypeId":"5","TypeName":"Permit"},{"TypeId":"6","TypeName":"Registration"},{"TypeId":"7","TypeName":"Driver Licence"}]';
var statutoryTypeStore = new Ext.data.JsonStore({
    id: 'vehicelTypeStoreId2',
    fields: ['TypeId', 'TypeName']
});
statutoryTypeStore.loadData(Ext.decode(statutoryTypeeData));


var durationData = '[{DurationId:"1", "DurationName":"Daily" },{"DurationId":"2","DurationName":"Weekly"},{"DurationId":"3","DurationName":"Monthly"}]';
var durationStore = new Ext.data.JsonStore({
    id: 'DurationStroreId',
    fields: ['DurationId', 'DurationName'],
    data: durationData
});
durationStore.loadData(Ext.decode(durationData));

//****************************** all stores ends here ************************    
            

// ******************************** all functions starts here  ***********************
google.load("visualization", "1", {
    packages: ["corechart"]
});
google.setOnLoadCallback(setGoogleLoad());

function setGoogleLoad() {
    googleLoad = true;
}

function CheckSession() {
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/CVSStatusDashboardAction.do?param=checkSession',
        method: 'POST',
        success: function(response, options) {
            if (response.responseText == 'InvalidSession') {
                window.location.href = "<%=request.getContextPath()%>/Jsps/Common/SessionDestroy.html";
            }
        },
        failure: function() {}
    });
}


function callAlertFunction(graphType, vehType) {
    CheckSession();

    if (Ext.getCmp('viewComboId').getValue() == "" || Ext.getCmp('viewComboId').getValue() == 'undefined') {
        Ext.example.msg('Please View Type');
        return;
    }
    if (graphType == '2' || graphType == '5' || graphType == '6' ) {
        if (Ext.getCmp('durationComboId').getValue() == "" || Ext.getCmp('durationComboId').getValue() == 'undefined') {
            Ext.example.msg('Please Select Duration');
            return;
        }
    }
    if(graphType == '6'){
     if (Ext.getCmp('statutoryDropdown').getValue() == "" || Ext.getCmp('statutoryDropdown').getValue() == 'undefined') {
            Ext.example.msg('Please Select Statutory Type');
            return;
        }   
    }
    if (Ext.getCmp('vehicleTypecomboId').getRawValue() == "" || Ext.getCmp('vehicleTypecomboId').getRawValue() == 'undefined') {
        Ext.example.msg('Please Select VehicleType');
        return;
    }
    if (Ext.getCmp('enddate').getValue() == "" || Ext.getCmp('enddate').getValue() == 'undefined') {
        Ext.example.msg('Please Select End Date');
        return;
    }

    if (Ext.getCmp('startdate').getValue() == "" || Ext.getCmp('startdate').getValue() == 'undefined') {
        Ext.example.msg('Please Select Start Date');
        return;
    }
if(graphType == '1' || graphType == '3' || graphType == '7'){
   if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                    Ext.example.msg("End Date Must Be Greater Than Start Date.");
                    Ext.getCmp('enddate').focus();
                    return;
                }
    }            
    
    document.getElementById('barchartddiv').innerHTML = "";
    document.getElementById('barchartddivforall').innerHTML = "";
    document.getElementById('barchartddivforall2').innerHTML = "";


    if (Ext.getCmp('vehicleTypecomboId').getValue() == 1 || Ext.getCmp('vehicleTypecomboId').getValue() == 2 || Ext.getCmp('vehicleTypecomboId').getValue() == 0 ) {
        Ext.getCmp('innermainpannel').show();
        Ext.getCmp('innersecondmainpannel').show();
        Ext.getCmp('innermainpannelforall').hide();
        Ext.getCmp('innerthirdmainpannel').hide();

    } 
<!--    else if (Ext.getCmp('vehicleTypecomboId').getValue() == 0) {-->
<!--        Ext.getCmp('innermainpannel').hide();-->
<!--        Ext.getCmp('innersecondmainpannel').hide();-->
<!--        Ext.getCmp('innermainpannelforall').show();-->
<!--        Ext.getCmp('innerthirdmainpannel').show();-->
<!--    }-->

    var el = document.getElementById('loadImage');
    el.style.visibility = 'visible';            
                
    if (graphType == '1' || graphType == '3' || graphType == '7' ) {

            Ext.getCmp('barchartpanel1id').show();
            Ext.getCmp('barchartpanel1idforall').hide();
            Ext.getCmp('barchartpanel1idforall2').hide();
            BarChart(graphType, vehType);


    } else if ( graphType == '2' || graphType == '4' || graphType == '5' || graphType == '6' ) {
       if(graphType != '6'){
             
            Ext.getCmp('barchartpanel1id').show();
            Ext.getCmp('barchartpanel1idforall').hide();
            Ext.getCmp('barchartpanel1idforall2').hide();
            TrendBarChart(graphType, vehType);

        }else if(graphType == '6'){
        
            Ext.getCmp('barchartpanel1id').show();
            Ext.getCmp('barchartpanel1idforall').hide();
            Ext.getCmp('barchartpanel1idforall2').hide();
            StatutoryTrendBarChart(graphType, vehType);
        
        }

    }
}
//******************************************** BarChart**********************************************************		
function BarChart(ReportType, vType) {

    vehicleType = vType;
    if( ReportType != 7){
    IdlingStore.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vType,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d')
        },
        callback: function() {
            if (IdlingStore.getTotalCount() > 0) {
                var newData = [];
                for (var i = 0; i < IdlingStore.getTotalCount(); i++) {
                    var insidetabledata = [];
                    var rec = IdlingStore.getAt(i);
                    insidetabledata[0] = rec.data['groupName'];
                    insidetabledata[1] = rec.data['percentage'];
                    newData.push(insidetabledata);
                }
                barchartdata = new google.visualization.DataTable();
                var numRows = newData.length;
                var numCols = newData[0].length;
                barchartdata.addColumn('string', newData[0][0]);

                for (var i = 1; i < numCols; i++)
                    barchartdata.addColumn('number', newData[0][i]);

                for (var i = 1; i < numRows; i++)
                    barchartdata.addRow(newData[i]);

                if (ReportType == 1) {
                if( vehicleType != 'ALL' ){
                    titleOfTheGraph = vehicleType + ' IDLING %';
                    }else if(vehicleType == 'ALL'){
                    titleOfTheGraph = 'IDLING %';
                    }
                    coulourarr = couloury;
                } else if (ReportType == 3) {
                 if( vehicleType != 'ALL' ){
                    titleOfTheGraph = vehicleType + ' AVERAGE OVERSPEED COUNT'
                    }else if(vehicleType == 'ALL'){
                    titleOfTheGraph = 'AVERAGE OVERSPEED COUNT';
                    }
                    coulourarr = coulourr;
                }
                if (ReportType == 1) {
                    vaxistitle = 'Idling %';
                } else if (ReportType == 3) {
                    vaxistitle = 'Average Overspeed Count'
                }
if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                var options = {
                    title: titleOfTheGraph,
                    titleTextStyle: {
                        color: '#686262',
                        fontSize: 13,
                        fontName: 'sans-serif'
                    },
                    pieSliceText: "value",
                    legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                    colors: coulourarr,
                    sliceVisibilityThreshold: 0,
                    backgroundColor: '#E4E4E4',

                    vAxis: {
                        title: vaxistitle,
                        viewWindow: {
                            min: 0
                        },
                        maxValue: 4,
                        gridlines: {
                            count: 6
                        },
                        titleTextStyle: {
                            italic: false,
                            fontSize: 13
                        }
                    },
                     chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                };


                var statutorybargraph = new google.visualization.ColumnChart(document.getElementById('barchartddiv'));
                statutorybargraph.draw(barchartdata, options);
                var test = document.getElementById("barchartddiv").complete;
                if(ReportType == 1 || ReportType == 3 ){
                google.visualization.events.addListener(statutorybargraph, 'select', selectHandler);
                }
            }

           setTimeout(myFunction, 2000);
           
 function selectHandler() {
  var selection = statutorybargraph.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata.getValue(item.row,0); 
      var columname = item.column ;       
  } 
  }
 Ext.getCmp('innermainpannel').hide();  
 Ext.getCmp('gridpanelid').show();
 showcolumnFunctions(ReportType);
 store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vType,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
             groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            barnumber  : columname    
        }
 });
 
 
}
}
});
}           
else if(ReportType == 7){
   IdlingStoreNew.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vType,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d')
        },
        callback: function() {
                       if (IdlingStoreNew.getTotalCount() > 0) {
                var newData = [];
                for (var i = 0; i < IdlingStoreNew.getTotalCount(); i++) {
                    var insidetabledata = [];
                    var rec = IdlingStoreNew.getAt(i);
                    insidetabledata[0] = rec.data['groupName'];
                    insidetabledata[1] = rec.data['percentage1'];
                    insidetabledata[2] = rec.data['percentage2'];
                    newData.push(insidetabledata);
                }
                console.log(newData);
                barchartdata = new google.visualization.DataTable();
                var numRows = newData.length;
                var numCols = newData[0].length;
                barchartdata.addColumn('string', newData[0][0]);

                for (var i = 1; i < numCols; i++)
                    barchartdata.addColumn('number', newData[0][i]);

                for (var i = 1; i < numRows; i++)
                    barchartdata.addRow(newData[i]);

                if( vehicleType != 'ALL' ){
                    titleOfTheGraph = vehicleType + ' PM COMPLIANCE % ';
                    }else if(vehicleType == 'ALL'){
                    titleOfTheGraph = ' PM COMPLIANCE % ';
                    }
                    coulourarr = coulouryrg;              
                    vaxistitle = 'PM Compliance %'
                if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}

                var options = {
                    title: titleOfTheGraph,
                    isStacked: true,
                    titleTextStyle: {
                        color: '#686262',
                        fontSize: 13,
                        fontName: 'sans-serif'
                    },
                    pieSliceText: "value",
                   legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                    colors: coulourb,
                    sliceVisibilityThreshold: 0,
                    backgroundColor: '#E4E4E4',

                    vAxis: {
                        title: vaxistitle,
                        viewWindow: {
                            min: 0
                        },
                        maxValue: 4,
                        gridlines: {
                            count: 5
                        },
                        titleTextStyle: {
                            italic: false,
                            fontSize: 13
                        }
                    },
                    chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                };


                var statutorybargraph = new google.visualization.ColumnChart(document.getElementById('barchartddiv'));
                statutorybargraph.draw(barchartdata, options);
                var test = document.getElementById("barchartddiv").complete;
                if (ReportType == 7) {
                google.visualization.events.addListener(statutorybargraph, 'select', selectHandler1);
                }
            }

           setTimeout(myFunction, 2000);
 function selectHandler1() {
  var selection = statutorybargraph.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata.getValue(item.row,0);  
       var columname = item.column ;  
  } 
  }
 Ext.getCmp('innermainpannel').hide();  
 Ext.getCmp('gridpanelid').show();
 showcolumnFunctions(ReportType);
  store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vType,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
            groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),           
            barnumber  : columname             
        }
 });
 
 
}
           }
           });
           }          
}


function BarChartforall(ReportType, vType) {
var statutorybargraph;
var statutorybargraph1;

    if(ReportType != 7){
    var vehicleType1 = "CARS";
    IdlingStore.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType1,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d')
        },
        callback: function() {
            if (IdlingStore.getTotalCount() > 0) {
                var newData = [];
                for (var i = 0; i < IdlingStore.getTotalCount(); i++) {
                    var insidetabledata = [];
                    var rec = IdlingStore.getAt(i);
                    insidetabledata[0] = rec.data['groupName'];
                    insidetabledata[1] = rec.data['percentage'];
                    newData.push(insidetabledata);
                }
               var barchartdata1 = new google.visualization.DataTable();
                var numRows1 = newData.length;
                var numCols1 = newData[0].length;
                barchartdata1.addColumn('string', newData[0][0]);

                for (var i = 1; i < numCols1; i++)
                    barchartdata1.addColumn('number', newData[0][i]);

                for (var i = 1; i < numRows1; i++)
                    barchartdata1.addRow(newData[i]);
                if (ReportType == 1) {
                    titleOfTheGraph1 = vehicleType1 + ' IDLING %';
                     coulourarr1 = couloury;
                } else if (ReportType == 3) {
                    titleOfTheGraph1 = vehicleType1 + ' AVERAGE OVERSPEED COUNT'
                     coulourarr1 = coulourr;
                }else if (ReportType == 7) {
                    titleOfTheGraph1 = vehicleType1 + ' PM COMPLIANCE % ';
                    coulourarr = couloury;
                } 
                if (ReportType == 1 ) {
                    vaxistitle1 = 'Idling %';
                } else if (ReportType == 3) {
                    vaxistitle1 = 'Average Overspeed Count '
                }else if (ReportType == 7) {
                    vaxistitle1 = 'PM Compliance %'
                }
                if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                var options1 = {
                    title: titleOfTheGraph1,
                    titleTextStyle: {
                        color: '#686262',
                        fontSize: 13,
                        fontName: 'sans-serif'
                    },
                    pieSliceText: "value",
                     legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                    colors: coulourarr1,
                    sliceVisibilityThreshold: 0,
                    backgroundColor: '#E4E4E4',

                    vAxis: {
                        title: vaxistitle1,
                        viewWindow: {
                            min: 0
                        },
                        maxValue: 4,
                        gridlines: {
                            count: 5
                        },
                        titleTextStyle: {
                            italic: false,
                            fontSize: 13
                        }
                    }, chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                };
            }

            vehicleType = "TRUCKS";
            IdlingStore.load({
                params: {
                    custID: '<%=customerId%>',
                    vehicleType: vehicleType,
                    reportType: ReportType,
                    startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
                    endDate: Ext.getCmp('enddate').getValue().format('Y-m-d')

                },
                callback: function() {
                    if (IdlingStore.getTotalCount() > 0) {
                        var newData = [];
                        for (var i = 0; i < IdlingStore.getTotalCount(); i++) {
                            var insidetabledata = [];
                            var rec = IdlingStore.getAt(i);
                            insidetabledata[0] = rec.data['groupName'];
                            insidetabledata[1] = rec.data['percentage'];
                            newData.push(insidetabledata);
                        }
                        barchartdata = new google.visualization.DataTable();
                        var numRows = newData.length;
                        var numCols = newData[0].length;
                        barchartdata.addColumn('string', newData[0][0]);

                        for (var i = 1; i < numCols; i++)
                            barchartdata.addColumn('number', newData[0][i]);

                        for (var i = 1; i < numRows; i++)
                            barchartdata.addRow(newData[i]);
                        if (ReportType == 1) {
                            if(vehicleType != 'ALL'){
                            titleOfTheGraph = vehicleType + ' IDLING %';
                            }if(vehicleType == 'ALL'){
                            titleOfTheGraph = ' IDLING %';
                            }
                            
                             coulourarr = couloury;
                        } else if (ReportType == 3) {
                        if(vehicleType != 'ALL'){
                            titleOfTheGraph = vehicleType + ' AVERAGE OVERSPEED COUNT';
                            }else if(vehicleType == 'ALL'){
                             titleOfTheGraph =   'AVERAGE OVERSPEED COUNT';
                            }
                             coulourarr = coulourr;
                        }else if (ReportType == 7) {
                             if(vehicleType != 'ALL'){
                             titleOfTheGraph = vehicleType + ' PM COMPLIANCE % ';
                             }else if(vehicleType == 'ALL'){
                             titleOfTheGraph =   ' PM COMPLIANCE % ';
                             }
                             coulourarr = couloury;
                        } 
                        if (ReportType == 1 || ReportType == 2) {
                            vaxistitle = 'Idling %';
                        } else if (ReportType == 3) {
                            vaxistitle = 'Average Overspeed Count'
                        }else if (ReportType == 7) {
                         vaxistitle = 'PM Compliance %'
                          }
if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                        var options = {
                            title: titleOfTheGraph,
                            titleTextStyle: {
                                color: '#686262',
                                fontSize: 13,
                                fontName: 'sans-serif'
                            },
                            pieSliceText: "value",
                           legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                            colors: coulourarr,
                            sliceVisibilityThreshold: 0,
                            backgroundColor: '#E4E4E4',
                            vAxis: {
                                title: vaxistitle,
                                viewWindow: {
                                    min: 0
                                },
                                maxValue: 4,
                                gridlines: {
                                    count: 5
                                },
                                titleTextStyle: {
                                    italic: false,
                                    fontSize: 13
                                }
                            },
                            chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                        };

                statutorybargraph1 = new google.visualization.ColumnChart(document.getElementById('barchartddivforall'));
                statutorybargraph1.draw(barchartdata1, options1);
                var test1 = document.getElementById("barchartddivforall").complete;
                 if (ReportType == 1  || ReportType == 3 ) {
                         google.visualization.events.addListener(statutorybargraph1, 'select', selectHandler3);
                         }
                        statutorybargraph = new google.visualization.ColumnChart(document.getElementById('barchartddivforall2'));
                        statutorybargraph.draw(barchartdata, options);
                        var test = document.getElementById("barchartddivforall2").complete;
                         if (ReportType == 1  || ReportType == 3 ) {
                     google.visualization.events.addListener(statutorybargraph, 'select', selectHandler4);
                     }
                    }

                }
            });
setTimeout(myFunction, 2000);
        
         function selectHandler3() {
  var selection = statutorybargraph1.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata1.getValue(item.row,0);  
       var columname = item.column ; 
  } 
  }
 Ext.getCmp('innermainpannelforall').hide();  
 Ext.getCmp('gridpanelid').show();
 showcolumnFunctions(ReportType);
 store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType1,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
             groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            barnumber  : columname            
        }
 });
 
 
}


        function selectHandler4() {
  var selection = statutorybargraph.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata.getValue(item.row,0);  
       var columname = item.column ; 
  } 
  }
 Ext.getCmp('innermainpannelforall').hide();  
 Ext.getCmp('gridpanelid').show();
 showcolumnFunctions(ReportType);
 store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
            groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            barnumber  : columname 
            
        }
 });
 
 
}
          
        }

    });
    }else if(ReportType == 7){
var statutorybargraph;
var statutorybargraph1;
        var vehicleType1 = "CARS";
    IdlingStoreNew.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType1,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d')
        },
        callback: function() {
            if (IdlingStoreNew.getTotalCount() > 0) {
                var newData = [];
                for (var i = 0; i < IdlingStoreNew.getTotalCount(); i++) {
                    var insidetabledata = [];
                    var rec = IdlingStoreNew.getAt(i);
                    insidetabledata[0] = rec.data['groupName'];
                    insidetabledata[1] = rec.data['percentage1'];
                    insidetabledata[2] = rec.data['percentage2'];
                    newData.push(insidetabledata);
                }
               var barchartdata1 = new google.visualization.DataTable();
                var numRows1 = newData.length;
                var numCols1 = newData[0].length;
                barchartdata1.addColumn('string', newData[0][0]);

                for (var i = 1; i < numCols1; i++)
                    barchartdata1.addColumn('number', newData[0][i]);

                for (var i = 1; i < numRows1; i++)
                    barchartdata1.addRow(newData[i]);
                                    
                    titleOfTheGraph1 = vehicleType1 + ' PM COMPLIANCE % ';
                    coulourarr1 = coulourb;                
                    vaxistitle1 = 'PM Compliance %'
                if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                var options1 = {
                    title: titleOfTheGraph1,
                    isStacked: true,
                    titleTextStyle: {
                        color: '#686262',
                        fontSize: 13,
                        fontName: 'sans-serif'
                    },
                    pieSliceText: "value",
                    legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                    colors: coulourarr1,
                    sliceVisibilityThreshold: 0,
                    backgroundColor: '#E4E4E4',

                    vAxis: {
                        title: vaxistitle1,
                        viewWindow: {
                            min: 0
                        },
                        maxValue: 4,
                        gridlines: {
                            count: 5
                        },
                        titleTextStyle: {
                            italic: false,
                            fontSize: 13
                        }
                    }, chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                };
            }

            vehicleType = "TRUCKS";
            IdlingStoreNew.load({
                params: {
                    custID: '<%=customerId%>',
                    vehicleType: vehicleType,
                    reportType: ReportType,
                    startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
                    endDate: Ext.getCmp('enddate').getValue().format('Y-m-d')

                },
                callback: function() {
                    if (IdlingStoreNew.getTotalCount() > 0) {
                        var newData = [];
                        for (var i = 0; i < IdlingStoreNew.getTotalCount(); i++) {
                            var insidetabledata = [];
                            var rec = IdlingStoreNew.getAt(i);
                            insidetabledata[0] = rec.data['groupName'];
                            insidetabledata[1] = rec.data['percentage1'];
                            insidetabledata[2] = rec.data['percentage2'];
                            newData.push(insidetabledata);
                        }
                        barchartdata = new google.visualization.DataTable();
                        var numRows = newData.length;
                        var numCols = newData[0].length;
                        barchartdata.addColumn('string', newData[0][0]);

                        for (var i = 1; i < numCols; i++)
                            barchartdata.addColumn('number', newData[0][i]);

                        for (var i = 1; i < numRows; i++)
                            barchartdata.addRow(newData[i]);      
                                              
                             titleOfTheGraph = vehicleType + ' PM COMPLIANCE % ';
                             coulourarr = coulourb;                                           
                             vaxistitle = 'PM Compliance %'                         
if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                        var options = {
                            title: titleOfTheGraph,
                             isStacked: true,
                            titleTextStyle: {
                                color: '#686262',
                                fontSize: 13,
                                fontName: 'sans-serif'
                            },
                            pieSliceText: "value",
                          legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                            colors: coulourarr,
                            sliceVisibilityThreshold: 0,
                            backgroundColor: '#E4E4E4',
                            vAxis: {
                                title: vaxistitle,
                                viewWindow: {
                                    min: 0
                                },
                                maxValue: 4,
                                gridlines: {
                                    count: 5
                                },
                                titleTextStyle: {
                                    italic: false,
                                    fontSize: 13
                                }
                            }, chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                        };

                statutorybargraph1 = new google.visualization.ColumnChart(document.getElementById('barchartddivforall'));
                statutorybargraph1.draw(barchartdata1, options1);
                var test1 = document.getElementById("barchartddivforall").complete;
                        if (ReportType == 7) {
                         google.visualization.events.addListener(statutorybargraph1, 'select', selectHandler3);
                         } 
                        statutorybargraph = new google.visualization.ColumnChart(document.getElementById('barchartddivforall2'));
                        statutorybargraph.draw(barchartdata, options);
                        var test = document.getElementById("barchartddivforall2").complete;
                     if (ReportType == 7 ) {
                         google.visualization.events.addListener(statutorybargraph, 'select', selectHandler4);
                         }
                    }

                }
            });
setTimeout(myFunction, 2000);
          
  function selectHandler3() {
  var selection = statutorybargraph1.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata1.getValue(item.row,0);
     var columname = item.column ;    
  } 
  }
 Ext.getCmp('innermainpannelforall').hide();  
 Ext.getCmp('gridpanelid').show();
 showcolumnFunctions(ReportType);
 store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType1,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
            groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            barnumber  : columname 
            
        }
 });
 
 
}


        function selectHandler4() {
  var selection = statutorybargraph.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata.getValue(item.row,0);   
      var columname = item.column ;
  } 
  }
 Ext.getCmp('innermainpannelforall').hide();  
 Ext.getCmp('gridpanelid').show();
 showcolumnFunctions(ReportType);
 store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
            groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            barnumber  : columname 
        }
 });
 
 
}
          
          
          
        }

    });
    
    }
    
}
function myFunction(){
  var el = document.getElementById('loadImage');
  el.style.visibility = 'hidden';
}
function TrendBarChart(ReportType, vType) {
    vehicleType = vType;
    IdlingTrendStore.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vType,
            reportType: ReportType,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            selectedDate: Ext.getCmp('startdate').getValue().format('Y-m-d')

        },
        callback: function() {
            if (IdlingTrendStore.getTotalCount() > 0) {
                var newData = [];
                for (var i = 0; i < IdlingTrendStore.getTotalCount(); i++) {
                    var insidetabledata = [];
                    var rec = IdlingTrendStore.getAt(i);
                    insidetabledata[0] = rec.data['groupName'];
                    insidetabledata[1] = rec.data['percentage1'];
                    insidetabledata[2] = rec.data['percentage2'];
                    insidetabledata[3] = rec.data['percentage3'];
                    newData.push(insidetabledata);
                }
                barchartdata = new google.visualization.DataTable();
                var numRows = newData.length;
                var numCols = newData[0].length;
                barchartdata.addColumn('string', newData[0][0]);

                for (var i = 1; i < numCols; i++)
                    barchartdata.addColumn('number', newData[0][i]);

                for (var i = 1; i < numRows; i++)
                    barchartdata.addRow(newData[i]);
                 if (ReportType == 2) {
                 if(vehicleType != 'ALL'){
                    titleOfTheGraph = vehicleType + ' IDLING TREND %';
                    }else if(vehicleType == 'ALL'){
                    titleOfTheGraph =   ' IDLING TREND %';
                    }
                     coulourarr = coulouryrg;
                } else if (ReportType == 4) {
                if(vehicleType != 'ALL'){
                    titleOfTheGraph = vehicleType + ' FUEL EFFICIENCY (KMPL)';
                    }else if(vehicleType == 'ALL'){
                     titleOfTheGraph = 'FUEL EFFICIENCY (KMPL)';
                    }
                     coulourarr = coulouryrg;
                }else if (ReportType == 5) {
                    if(vehicleType != 'ALL'){
                    titleOfTheGraph = vehicleType + ' PREVENTIVE MAINTENANCE';
                    }else if(vehicleType == 'ALL'){
                     titleOfTheGraph =   ' PREVENTIVE MAINTENANCE';
                    }
                     coulourarr = coulouryrg;
                }else if (ReportType == 6) {
                    if(vehicleType != 'ALL'){
                    titleOfTheGraph = vehicleType + ' STATUTORY DETAILS';
                    }else if(vehicleType == 'ALL'){
                     titleOfTheGraph =   ' STATUTORY DETAILS';
                    }
                     coulourarr = coulouryrg;
                }
                if (ReportType == 2) {
                    vaxistitle = 'Idling %';
                } else if (ReportType == 4) {
                    vaxistitle = 'Fuel Efficiency (Kmpl) '
                }else if (ReportType == 5) {
                    vaxistitle = 'Preventive Maintenance Count '
                }else if (ReportType == 6) {
                    vaxistitle = 'Statutory Details Count '
                }
if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                var options = {
                    title: titleOfTheGraph,
                    titleTextStyle: {
                        color: '#686262',
                        fontSize: 13,
                        fontName: 'sans-serif'
                    },
                    pieSliceText: "value",
                  legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                    colors: coulourarr,
                    sliceVisibilityThreshold: 0,
                    backgroundColor: '#E4E4E4',

                    vAxis: {
                        title: vaxistitle,
                        viewWindow: {
                            min: 0
                        },
                        maxValue: 4,
                        gridlines: {
                            count: 5
                        },
                        titleTextStyle: {
                            italic: false,
                            fontSize: 13
                        }
                    }, chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                };


                var statutorybargraph = new google.visualization.ColumnChart(document.getElementById('barchartddiv'));
                statutorybargraph.draw(barchartdata, options);
                var test = document.getElementById("barchartddiv").complete;
                if (ReportType == 5  || ReportType == 2 || ReportType == 4  ) {
                google.visualization.events.addListener(statutorybargraph, 'select', selectHandler1);
                }

            }

         setTimeout(myFunction, 2000);

function selectHandler1() {
  var selection = statutorybargraph.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata.getValue(item.row,0);   
      var columname = item.column ;           
  } 
  }
 Ext.getCmp('innermainpannel').hide();  
 Ext.getCmp('gridpanelid').show();
showcolumnFunctions(ReportType);
  store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vType,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
            groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            barnumber: columname 
        }
 });
}

        }
    });

}


function TrendBarChartforall(ReportType, vType) {
var statutorybargraph;
var statutorybargraph1;
    var vehicleType1 = "CARS";
    IdlingTrendStore.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType1,
            reportType: ReportType,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            selectedDate: Ext.getCmp('startdate').getValue().format('Y-m-d')
        },
        callback: function() {
            if (IdlingTrendStore.getTotalCount() > 0) {
                var newData = [];
                for (var i = 0; i < IdlingTrendStore.getTotalCount(); i++) {
                    var insidetabledata = [];
                    var rec = IdlingTrendStore.getAt(i);
                    insidetabledata[0] = rec.data['groupName'];
                    insidetabledata[1] = rec.data['percentage1'];
                    insidetabledata[2] = rec.data['percentage2'];
                    insidetabledata[3] = rec.data['percentage3'];
                    newData.push(insidetabledata);
                }
                var barchartdata1 = new google.visualization.DataTable();
                var numRows1 = newData.length;
                var numCols1 = newData[0].length;
                barchartdata1.addColumn('string', newData[0][0]);

                for (var i = 1; i < numCols1; i++)
                    barchartdata1.addColumn('number', newData[0][i]);

                for (var i = 1; i < numRows1; i++)
                    barchartdata1.addRow(newData[i]);
               if (ReportType == 2) {
                    titleOfTheGraph1 = vehicleType1 + ' IDLING % TREND';
                     coulourarr = coulouryrg;
                } else if (ReportType == 4) {
                    titleOfTheGraph1 = vehicleType1 + ' FUEL EFFICIENCY (KMPL)';
                     coulourarr = coulouryrg;
                }else if (ReportType == 5) {
                    titleOfTheGraph1 = vehicleType1 + ' PREVENTIVE MAINTENANCE';
                     coulourarr = coulouryrg;
                }else if (ReportType == 6) {
                    titleOfTheGraph1 = vehicleType1 + ' STATUTORY DETAILS';
                     coulourarr = coulouryrg;
                }
                if (ReportType == 2) {
                    vaxistitle1 = 'Idling %';
                } else if (ReportType == 4) {
                    vaxistitle1 = 'Fuel Efficiency (Kmpl) '
                }else if (ReportType == 5) {
                    vaxistitle1 = 'Preventive Maintenance Count '
                }else if (ReportType == 6) {
                    vaxistitle1 = 'Statutory Details Count '
                }
                if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                var options1 = {
                    title: titleOfTheGraph1,
                    titleTextStyle: {
                        color: '#686262',
                        fontSize: 13,
                        fontName: 'sans-serif'
                    },
                    pieSliceText: "value",
                   legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                    colors: coulourarr,
                    sliceVisibilityThreshold: 0,
                    backgroundColor: '#E4E4E4',

                    vAxis: {
                        title: vaxistitle1,
                        viewWindow: {
                            min: 0
                        },
                        maxValue: 4,
                        gridlines: {
                            count: 5
                        },
                        titleTextStyle: {
                            italic: false,
                            fontSize: 13
                        }
                    }, chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                };
              
            }
            vehicleType = "TRUCKS";
            IdlingTrendStore.load({
                params: {
                    custID: '<%=customerId%>',
                    vehicleType: vehicleType,
                    reportType: ReportType,
                    duration: Ext.getCmp('durationComboId').getRawValue(),
                    selectedDate: Ext.getCmp('startdate').getValue().format('Y-m-d')

                },
                callback: function() {
                    if (IdlingTrendStore.getTotalCount() > 0) {
                        var newData = [];
                        for (var i = 0; i < IdlingTrendStore.getTotalCount(); i++) {
                            var insidetabledata = [];
                            var rec = IdlingTrendStore.getAt(i);
                            insidetabledata[0] = rec.data['groupName'];
                            insidetabledata[1] = rec.data['percentage1'];
                            insidetabledata[2] = rec.data['percentage2'];
                            insidetabledata[3] = rec.data['percentage3'];
                            newData.push(insidetabledata);
                        }
                        barchartdata = new google.visualization.DataTable();
                        var numRows = newData.length;
                        var numCols = newData[0].length;
                        barchartdata.addColumn('string', newData[0][0]);

                        for (var i = 1; i < numCols; i++)
                            barchartdata.addColumn('number', newData[0][i]);

                        for (var i = 1; i < numRows; i++)
                            barchartdata.addRow(newData[i]);
                if (ReportType == 2) {
                     titleOfTheGraph = vehicleType + ' IDLING % TREND';
                     coulourarr = coulouryrg;
                } else if (ReportType == 4) {
                    titleOfTheGraph = vehicleType + ' FUEL EFFICIENCY (KMPL)';
                     coulourarr = coulouryrg;
                }else if (ReportType == 5) {
                    titleOfTheGraph = vehicleType + ' PREVENTIVE MAINTENANCE';
                     coulourarr = coulouryrg;
                }else if (ReportType == 6) {
                    titleOfTheGraph = vehicleType + ' STATUTORY DETAILS';
                     coulourarr = coulouryrg;
                }
                if (ReportType == 2) {
                    vaxistitle = 'Idling %';
                } else if (ReportType == 4) {
                    vaxistitle = 'Fuel Efficiency (Kmpl) '
                }else if (ReportType == 5) {
                    vaxistitle = 'Preventive Maintenance Count '
                }else if (ReportType == 6) {
                    vaxistitle = 'Statutory Details Count '
                }
if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                        var options = {
                            title: titleOfTheGraph,
                            titleTextStyle: {
                                color: '#686262',
                                fontSize: 13,
                                fontName: 'sans-serif'
                            },
                            pieSliceText: "value",
                          legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                            colors: coulourarr,
                            sliceVisibilityThreshold: 0,
                            backgroundColor: '#E4E4E4',
                            vAxis: {
                                title: vaxistitle,
                                viewWindow: {
                                    min: 0
                                },
                                maxValue: 4,
                                gridlines: {
                                    count: 5
                                },
                                titleTextStyle: {
                                    italic: false,
                                    fontSize: 13
                                }
                            }, chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                        };

                statutorybargraph1 = new google.visualization.ColumnChart(document.getElementById('barchartddivforall'));
                statutorybargraph1.draw(barchartdata1, options1);
                var test1 = document.getElementById("barchartddivforall").complete;
                if ( ReportType == 5 || ReportType == 2  || ReportType == 4  ) {
                google.visualization.events.addListener(statutorybargraph1, 'select', selectHandler3);
                }
                        statutorybargraph = new google.visualization.ColumnChart(document.getElementById('barchartddivforall2'));
                        statutorybargraph.draw(barchartdata, options);
                        var test = document.getElementById("barchartddivforall2").complete;
                        if (ReportType == 5 || ReportType == 2  || ReportType == 4 ) {
                        google.visualization.events.addListener(statutorybargraph, 'select', selectHandler4);
                        }
                    }
                }
            });
            
          if(Ext.getCmp('durationComboId').getRawValue() == 'Monthly'){
          if (ReportType == 5 || ReportType == 4) {
          setTimeout(myFunction, 5000);
          }else{
           setTimeout(myFunction, 5000);
          }
          }else if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
          if (ReportType == 5) {
          setTimeout(myFunction, 5000);
          }else{
           setTimeout(myFunction, 3000);
          }
          }else if(Ext.getCmp('durationComboId').getRawValue() == 'Daily'){
          if (ReportType == 5) {
          setTimeout(myFunction, 3000);
          }else{
           setTimeout(myFunction, 2000);
          }
          }


         function selectHandler3() {
  var selection = statutorybargraph1.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata1.getValue(item.row,0);  
       var columname = item.column ;  
  } 
  }
 Ext.getCmp('innermainpannelforall').hide();  
 Ext.getCmp('gridpanelid').show();
 showcolumnFunctions(ReportType);
 store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType1,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
            groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            barnumber  : columname 
            
        }
 });
 
 
}


        function selectHandler4() {
  var selection = statutorybargraph.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata.getValue(item.row,0); 
      var columname = item.column ;  
  } 
  }
 Ext.getCmp('innermainpannelforall').hide();  
 Ext.getCmp('gridpanelid').show();
showcolumnFunctions(ReportType);
 store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType,
            reportType: ReportType,
            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
            groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            barnumber  : columname 
            
        }
 });
 
 
}


        }



    });


}


function StatutoryTrendBarChart(ReportType, vType) {
    vehicleType = vType;
    IdlingTrendStore2.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vType,
            StatutoryType: Ext.getCmp('statutoryDropdown').getRawValue(),
            reportType: ReportType,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            selectedDate: new Date().format('Y-m-d')

        },
        callback: function() {
        
            if (IdlingTrendStore2.getTotalCount() > 0) {
                var newData = [];
                for (var i = 0; i < IdlingTrendStore2.getTotalCount(); i++) {
                    var insidetabledata = [];
                    var rec = IdlingTrendStore2.getAt(i);
                    insidetabledata[0] = rec.data['groupName'];
                    insidetabledata[1] = rec.data['percentage1'];
                    insidetabledata[2] = rec.data['percentage2'];
                    insidetabledata[3] = rec.data['percentage3'];
                    newData.push(insidetabledata);
                }
                barchartdata = new google.visualization.DataTable();
                var numRows = newData.length;
                var numCols = newData[0].length;
                barchartdata.addColumn('string', newData[0][0]);

                for (var i = 1; i < numCols; i++)
                    barchartdata.addColumn('number', newData[0][i]);

                for (var i = 1; i < numRows; i++)
                    barchartdata.addRow(newData[i]);
                 if (ReportType == 2) {
                 if(vehicleType != 'ALL' ){
                    titleOfTheGraph = vehicleType + ' IDLING % TREND';
                    }else if(vehicleType == 'ALL' ){
                    titleOfTheGraph = 'IDLING % TREND';
                    }
                     coulourarr = coulouryrg;
                } else if (ReportType == 4) {
                    if(vehicleType != 'ALL' ){
                    titleOfTheGraph = vehicleType + ' FUEL EFFICIENCY (KMPL)';
                    }else if(vehicleType == 'ALL'){
                    titleOfTheGraph = ' FUEL EFFICIENCY (KMPL)';
                    }
                     coulourarr = coulouryrg;
                }else if (ReportType == 5) {
                    if(vehicleType != 'ALL'){
                    titleOfTheGraph = vehicleType + ' PREVENTIVE MAINTENANCE';
                    }else if(vehicleType == 'ALL'){
                    titleOfTheGraph ='PREVENTIVE MAINTENANCE';
                    }
                     coulourarr = coulouryrg;
                }else if (ReportType == 6) {
                if(vehicleType != 'ALL'){
                 titleOfTheGraph = vehicleType + ' STATUTORY DETAILS'+' ( '+Ext.getCmp('statutoryDropdown').getRawValue()+' )';
                }else if(vehicleType == 'ALL'){
                titleOfTheGraph = ' STATUTORY DETAILS'+' ( '+Ext.getCmp('statutoryDropdown').getRawValue()+' )';                
                }
                 coulourarr = coulouryrg;
                }
                if (ReportType == 2) {
                    vaxistitle = 'Idling %';
                } else if (ReportType == 4) {
                    vaxistitle = 'Fuel Efficiency (Kmpl) '
                }else if (ReportType == 5) {
                    vaxistitle = 'Preventive Maintenance Count '
                }else if (ReportType == 6) {
                    vaxistitle = 'Statutory Details Count '
                }
if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                var options = {
                    title: titleOfTheGraph,
                    titleTextStyle: {
                        color: '#686262',
                        fontSize: 13,
                        fontName: 'sans-serif'
                    },
                    pieSliceText: "value",
                    legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                    colors: coulourarr,
                    sliceVisibilityThreshold: 0,
                    backgroundColor: '#E4E4E4',

                    vAxis: {
                        title: vaxistitle,
                        viewWindow: {
                            min: 0
                        },
                        maxValue: 4,
                        gridlines: {
                            count: 5
                        },
                        titleTextStyle: {
                            italic: false,
                            fontSize: 13
                        }
                    }, chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                };


                var statutorybargraph = new google.visualization.ColumnChart(document.getElementById('barchartddiv'));
                statutorybargraph.draw(barchartdata, options);
                var test = document.getElementById("barchartddiv").complete;
                 google.visualization.events.addListener(statutorybargraph, 'select', selectHandler1);


            }

         setTimeout(myFunction, 2000);

function selectHandler1() {
  var selection = statutorybargraph.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata.getValue(item.row,0); 
      var columname = item.column ;  
  } 
  }
 Ext.getCmp('innermainpannel').hide();  
 Ext.getCmp('gridpanelid').show();
showcolumnFunctions(ReportType);
  store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vType,
            reportType: ReportType,
            startDate: new Date().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
            groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            StatutoryType : Ext.getCmp('statutoryDropdown').getRawValue(),
            barnumber  : columname 
            
        }
 });
}


        }
    });

}


function StatutoryTrendBarChartforall(ReportType, vType) {
var statutorybargraph2;
var statutorybargraph3;
    var vehicleType1 = "CARS";
    IdlingTrendStore2.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType1,
            StatutoryType: Ext.getCmp('statutoryDropdown').getRawValue(),
            reportType: ReportType,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            selectedDate: new Date().format('Y-m-d')
        },
        callback: function() {
            if (IdlingTrendStore2.getTotalCount() > 0) {
                var newData = [];
                for (var i = 0; i < IdlingTrendStore2.getTotalCount(); i++) {
                    var insidetabledata = [];
                    var rec = IdlingTrendStore2.getAt(i);
                    insidetabledata[0] = rec.data['groupName'];
                    insidetabledata[1] = rec.data['percentage1'];
                    insidetabledata[2] = rec.data['percentage2'];
                    insidetabledata[3] = rec.data['percentage3'];
                    newData.push(insidetabledata);
                }
                var barchartdata1 = new google.visualization.DataTable();
                var numRows1 = newData.length;
                var numCols1 = newData[0].length;
                barchartdata1.addColumn('string', newData[0][0]);

                for (var i = 1; i < numCols1; i++)
                    barchartdata1.addColumn('number', newData[0][i]);

                for (var i = 1; i < numRows1; i++)
                    barchartdata1.addRow(newData[i]);
               if (ReportType == 2) {
                    titleOfTheGraph1 = vehicleType1 + ' IDLING TREND';
                     coulourarr = coulouryrg;
                } else if (ReportType == 4) {
                    titleOfTheGraph1 = vehicleType1 + ' FUEL EFFICIENCY';
                     coulourarr = coulouryrg;
                }else if (ReportType == 5) {
                    titleOfTheGraph1 = vehicleType1 + ' PREVENTIVE MAINTENANCE';
                     coulourarr = coulouryrg;
                }else if (ReportType == 6) {
                   titleOfTheGraph1 = vehicleType1 + ' STATUTORY DETAILS'+' ( '+Ext.getCmp('statutoryDropdown').getRawValue()+' )';               
                   coulourarr = coulouryrg;
                }
                if (ReportType == 2) {
                    vaxistitle1 = 'Idling %';
                } else if (ReportType == 4) {
                    vaxistitle1 = 'Fuel Efficiency (Kmpl) '
                }else if (ReportType == 5) {
                    vaxistitle1 = 'Preventive Maintenance Count '
                }else if (ReportType == 6) {
                    vaxistitle1 = 'Statutory Details Count '
                }
                if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                var options1 = {
                    title: titleOfTheGraph1,
                    titleTextStyle: {
                        color: '#686262',
                        fontSize: 13,
                        fontName: 'sans-serif'
                    },                  
                    pieSliceText: "value",
                    legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                    colors: coulourarr,
                    sliceVisibilityThreshold: 0,
                    backgroundColor: '#E4E4E4',

                    vAxis: {
                        title: vaxistitle1,
                        viewWindow: {
                            min: 0
                        },
                        maxValue: 4,
                        gridlines: {
                            count: 5
                        },
                        titleTextStyle: {
                            italic: false,
                            fontSize: 13
                        }
                    }, chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                };
              
            }
            vehicleType = "TRUCKS";
            IdlingTrendStore2.load({
                params: {
             custID: '<%=customerId%>',
            vehicleType: vehicleType,
            StatutoryType: Ext.getCmp('statutoryDropdown').getRawValue(),
            reportType: ReportType,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            selectedDate: new Date().format('Y-m-d')

                },
                callback: function() {
                    if (IdlingTrendStore2.getTotalCount() > 0) {
                        var newData = [];
                        for (var i = 0; i < IdlingTrendStore2.getTotalCount(); i++) {
                            var insidetabledata = [];
                            var rec = IdlingTrendStore2.getAt(i);
                            insidetabledata[0] = rec.data['groupName'];
                            insidetabledata[1] = rec.data['percentage1'];
                            insidetabledata[2] = rec.data['percentage2'];
                            insidetabledata[3] = rec.data['percentage3'];
                            newData.push(insidetabledata);
                        }
                        barchartdata = new google.visualization.DataTable();
                        var numRows = newData.length;
                        var numCols = newData[0].length;
                        barchartdata.addColumn('string', newData[0][0]);

                        for (var i = 1; i < numCols; i++)
                            barchartdata.addColumn('number', newData[0][i]);

                        for (var i = 1; i < numRows; i++)
                            barchartdata.addRow(newData[i]);
                if (ReportType == 2) {
                     titleOfTheGraph = vehicleType + ' IDLING % TREND ';
                     coulourarr = coulouryrg;
                } else if (ReportType == 4) {
                    titleOfTheGraph = vehicleType + ' FUEL EFFICIENCY ( KMPL )';
                     coulourarr = coulouryrg;
                }else if (ReportType == 5) {
                    titleOfTheGraph = vehicleType + ' PREVENTIVE MAINTENANCE';
                     coulourarr = coulouryrg;
                }else if (ReportType == 6) {
                    titleOfTheGraph = vehicleType + ' STATUTORY DETAILS'+' ( '+Ext.getCmp('statutoryDropdown').getRawValue()+' )';
                     coulourarr = coulouryrg;
                }
                if (ReportType == 2) {
                    vaxistitle = 'Idling %';
                } else if (ReportType == 4) {
                    vaxistitle = 'Fuel Efficiency (Kmpl) '
                }else if (ReportType == 5) {
                    vaxistitle = 'Preventive Maintenance Count '
                }else if (ReportType == 6) {
                    vaxistitle = 'Statutory Details Count '
                }
if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
font = 11;
}else{
font = 13;
}
                        var options = {
                            title: titleOfTheGraph,
                            titleTextStyle: {
                                color: '#686262',
                                fontSize: 13,
                                fontName: 'sans-serif'
                            },
                            pieSliceText: "value",
                       legend: {
                        position: 'bottom',
                        alignment : 'start',
                        textStyle: {fontSize: font }
                    },
                            colors: coulourarr,
                            sliceVisibilityThreshold: 0,
                            backgroundColor: '#E4E4E4',
                            vAxis: {
                                title: vaxistitle,
                                viewWindow: {
                                    min: 0
                                },
                                maxValue: 4,
                                gridlines: {
                                    count: 5
                                },
                                titleTextStyle: {
                                    italic: false,
                                    fontSize: 13
                                }
                            }, chartArea: {
                     top:38,
                     left:100,
                     height: '48%',
                     width:'80%'                     
                     },
                    hAxis:{
                    title: haxistitle
                    }
                        };

                statutorybargraph2 = new google.visualization.ColumnChart(document.getElementById('barchartddivforall'));
                statutorybargraph2.draw(barchartdata1, options1);
                var test1 = document.getElementById("barchartddivforall").complete;
                google.visualization.events.addListener(statutorybargraph2, 'select', selectHandler3);
                      
                        statutorybargraph3 = new google.visualization.ColumnChart(document.getElementById('barchartddivforall2'));
                        statutorybargraph3.draw(barchartdata, options);
                        var test = document.getElementById("barchartddivforall2").complete;
                         google.visualization.events.addListener(statutorybargraph3, 'select', selectHandler4);
                   
                    }
                }
            });           
          if(Ext.getCmp('durationComboId').getRawValue() == 'Monthly'){
          setTimeout(myFunction, 5000);
          }else if(Ext.getCmp('durationComboId').getRawValue() == 'Weekly'){
          setTimeout(myFunction, 3000);
          }else if(Ext.getCmp('durationComboId').getRawValue() == 'Daily'){
          setTimeout(myFunction, 2000);
          }


         function selectHandler3() {
  var selection = statutorybargraph2.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata1.getValue(item.row,0);        
      var columname = item.column ;  
  } 
  }
 Ext.getCmp('innermainpannelforall').hide();  
 Ext.getCmp('gridpanelid').show();
 showcolumnFunctions(ReportType);
 store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType1,
            reportType: ReportType,
            startDate: new Date().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
            groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            StatutoryType : Ext.getCmp('statutoryDropdown').getRawValue(),
            barnumber  : columname             
        }
 });
 
 
}


        function selectHandler4() {
  var selection = statutorybargraph3.getSelection();
  var message = '';
  if(selection.length>0){
  var item = selection[0];
  if (item.row != null && item.column != null) {
      var rowname = barchartdata.getValue(item.row,0);  
        var columname = item.column ; 
  } 
  }
 Ext.getCmp('innermainpannelforall').hide();  
 Ext.getCmp('gridpanelid').show();
showcolumnFunctions(ReportType);
 store.load({
        params: {
            custID: '<%=customerId%>',
            vehicleType: vehicleType,
            reportType: ReportType,
            startDate: new Date().format('Y-m-d'),
            endDate: Ext.getCmp('enddate').getValue().format('Y-m-d'),
            groupName : rowname,
            duration: Ext.getCmp('durationComboId').getRawValue(),
            StatutoryType : Ext.getCmp('statutoryDropdown').getRawValue(),
            barnumber  : columname 
            
        }
 });
 
 
}


        }



    });


}



// ******************************** all functions ends here  ***********************
// ************************* grid function starts


function getGridForFleetDashBoard(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,back,backstr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid1',
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
	
		if(back)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:backstr,
			    iconCls : 'Back',
			    handler : function(){
			    ShowGraph();

			    }    
			  }]);
		}	
		
	return grid;
}


function ShowGraph(){
Ext.getCmp('gridpanelid').hide();
viewId =  Ext.getCmp('viewComboId').getValue();
vehicleType =  Ext.getCmp('vehicleTypecomboId').getRawValue(); 
                  
callAlertFunction(viewId, vehicleType);
}

      var reader = new Ext.data.JsonReader({
        idProperty: 'IdlingrootclickId',
        root: 'IdlingrootIdclick',
        totalProperty: 'total',
        fields: [
        {
            type: 'numeric',
            name: 'slnoIndex'
        }, {
            type: 'string',
            name: 'vehicleNoDateIndex'
        }, {
             type: 'string',
            name: 'groupNameDataIndex'
        }, {
             type: 'float',
            name: 'idlinghrsDataIndex'
        }, {
            type: 'float',
            name: 'enginehrsDataIndex'
        },{          
            name: 'startDateDataIndex',
            type: 'date',
            dateFormat:'d/m/Y'
        }, {
           
            name: 'startDateNewDataIndex',
              type: 'date',
             dateFormat:'d/m/Y H:i:s'
        },{
           
            name: 'endDateDataIndex',
             type: 'date',
            dateFormat:'d/m/Y H:i:s'
        },{
             type: 'float',
            name: 'idlingCountDataIndex'
        },{
             type: 'numeric',
            name: 'pmCountDataIndex'
        }, {
            type: 'string',
            name: 'pmCountbeforeexpDataIndex'
        },{
             type: 'numeric',
            name: 'pmCountafterexpDataIndex'
        },{
            
            name: 'pmDateDataIndex',
             type: 'date',
             dateFormat:'d/m/Y'
        },{
             type: 'string',
            name: 'startLocationDataIndex'
        },{
             type: 'string',
            name: 'endLocationDataIndex'
        },{
            
            name: 'DueDateDataIndex',
             type: 'date',
             dateFormat:'d/m/Y H:i:s'
        },{
             type: 'float',
            name: 'DistanceDataIndex'
        },{
             type: 'float',
            name: 'FuelDataIndex'
        },{
             type: 'float',
            name: 'MileageDataIndex'
        },{
             type: 'string',
            name: 'PMStatusDataIndex'
        },{
             type: 'string',
            name: 'vehicleTypeDateIndex'
        }
        
        ]
    });

var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/FMSDashBoardAction.do?param=getIdlingdetailsforclick',
            method: 'POST'
        }),
        remoteSort: false,
        id: 'IdlingrootIdclck',
        reader: reader
    });
	


    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [
        
        {
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'vehicleNoDateIndex'
        }, {
             type: 'string',
            dataIndex: 'groupNameDataIndex'
        }, {
             type: 'float',
            dataIndex: 'idlinghrsDataIndex'
        }, {
            type: 'float',
            dataIndex: 'enginehrsDataIndex'
        },{
             type: 'date',
            dataIndex: 'startDateDataIndex'
        }, {
             type: 'date',
            dataIndex: 'startDateNewDataIndex'
        },{
            type: 'date',
            dataIndex: 'endDateDataIndex'
        },{
             type: 'float',
            dataIndex: 'idlingCountDataIndex'
        },{
             type: 'numeric',
            dataIndex: 'pmCountDataIndex'
        }, {
            type: 'string',
            dataIndex: 'pmCountbeforeexpDataIndex'
        },{
             type: 'numeric',
            dataIndex: 'pmCountafterexpDataIndex'
        },{
             type: 'date',
            dataIndex: 'pmDateDataIndex'
        },{
             type: 'string',
            dataIndex: 'startLocationDataIndex'
        },{
             type: 'string',
            dataIndex: 'endLocationDataIndex'
        },{
             type: 'date',
            dataIndex: 'DueDateDataIndex'
        },{
             type: 'float',
            dataIndex: 'DistanceDataIndex'
        },{
             type: 'float',
            dataIndex: 'FuelDataIndex'
        },{
             type: 'float',
            dataIndex: 'MileageDataIndex'
        },{
             type: 'string',
            dataIndex: 'PMStatusDataIndex'
        },{
             type: 'string',
            dataIndex: 'vehicleTypeDateIndex'
        }
        ]
    });

    var createColModel = function(finish, start) {
        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SLNO</span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;>SLNO</span>",
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>VEHICLE NO</span>",
                dataIndex: 'vehicleNoDateIndex',
                width: 200,
               // hidden:true,
                filter: {
                    type: 'string'
                }
            },  {
                header: "<span style=font-weight:bold;>GROUP NAME</span>",
                dataIndex: 'groupNameDataIndex',
                width: 200,
               // hidden:true,
                filter: {
                    type: 'string'
                }
            },  {
                header: "<span style=font-weight:bold;>IDLE HRS (HH:MM)</span>",
                dataIndex: 'idlinghrsDataIndex',
                width: 200,
               // hidden:true,
                filter: {
                    type: 'float'
                }
            },  {
                header: "<span style=font-weight:bold;>ENG HRS (HH:MM)</span>",
                dataIndex: 'enginehrsDataIndex',
                width: 200,
                filter: {
                    type: 'float'
                }
            },  {
                header: "<span style=font-weight:bold;>SERVICE DATE</span>",
                dataIndex: 'startDateDataIndex',
                renderer: Ext.util.Format.dateRenderer('d/m/Y'),
                width: 400,
               // hidden:true,
                filter: {
                    type: 'date'
                }
            },{
                header: "<span style=font-weight:bold;> START DATE </span>",
                dataIndex: 'startDateNewDataIndex',
                renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),               
                width: 400,
               // hidden:true,
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;>END DATE</span>",
                dataIndex: 'endDateDataIndex',
                 renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),   
                width: 400,
               // hidden:true,
                filter: {
                    type: 'date'
                    }
                }, {
                header: "<span style=font-weight:bold;>IDLING %</span>",
                dataIndex: 'idlingCountDataIndex',
                width: 400,
               // hidden:true,
                filter: {
                    type: 'float'
                }
            },{
                header: "<span style=font-weight:bold;>PM COUNT</span>",
                dataIndex: 'pmCountDataIndex',
                width: 400,
              //  hidden:true,
                filter: {
                    type: 'numeric'
                }
                },
				 {
                header: "<span style=font-weight:bold;>PM STATUS</span>",
                dataIndex: 'pmCountbeforeexpDataIndex',
                width: 400,
               // hidden:true,
                filter: {
                    type: 'string'
                }
                },
				 {
                header: "<span style=font-weight:bold;>PM COUNT AFTER EXPIRE</span>",
                dataIndex: 'pmCountafterexpDataIndex',
                width: 400,
               // hidden:true,
                filter: {
                    type: 'numeric'
                }
             },{
                header: "<span style=font-weight:bold;>PM DATE</span>",
                dataIndex: 'pmDateDataIndex',
                width: 400,
                 renderer: Ext.util.Format.dateRenderer('d/m/Y'),   
               // hidden:true,
                filter: {
                    type: 'date'
                }
             }, {
                header: "<span style=font-weight:bold;>START LOCATION</span>",
                dataIndex: 'startLocationDataIndex',
                width: 400,
               // hidden:true,
                filter: {
                    type: 'string'
                }
             },
             {
                header: "<span style=font-weight:bold;>END LOCATION</span>",
                dataIndex: 'endLocationDataIndex',
                width: 400,
               // hidden:true,
                filter: {
                    type: 'string'
                }
             }, {
                header: "<span style=font-weight:bold;>DUE DATE</span>",
                dataIndex: 'DueDateDataIndex',
                 renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),   
                width: 400,
               // hidden:true,
                filter: {
                    type: 'date'
                }
             },{
                header: "<span style=font-weight:bold;>DISTANCE</span>",
                dataIndex: 'DistanceDataIndex',
                width: 400,
               // hidden:true,
                filter: {
                    type: 'float'
                }
             },{
                header: "<span style=font-weight:bold;>FUEL</span>",
                dataIndex: 'FuelDataIndex',
                width: 400,
               // hidden:true,
                filter: {
                    type: 'float'
                }
             },{
                header: "<span style=font-weight:bold;>MILEAGE</span>",
                dataIndex: 'MileageDataIndex',
                width: 400,
               // hidden:true,
                filter: {
                    type: 'float'
                }
             },{
                header: "<span style=font-weight:bold;>PM STATUS</span>",
                dataIndex: 'PMStatusDataIndex',
                width: 400,
               // hidden:true,
                filter: {
                    type: 'string'
                }
             },{
                header: "<span style=font-weight:bold;>VEHICLE TYPE</span>",
                dataIndex: 'vehicleTypeDateIndex',
                width: 200,
               // hidden:true,
                filter: {
                    type: 'string'
                }
            },
             
        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };
  var grid = getGridForFleetDashBoard('', 'NoRecordsfound', store, screen.width - 35, 410, 23, filters, 'ClearFilterData', true, 'BACK');
 
// *************************** grid functions ends

// ****************************** all combos starts here ************************
       var custnamecombo = new Ext.form.ComboBox({
           store: custmastcombostore,
           id: 'custmastcomboId',
           mode: 'local',
           hidden: false,
           resizable: true,
           forceSelection: true,
           emptyText: 'Select Customer',
           blankText: 'Select Customer',
           selectOnFocus: true,
           allowBlank: false,
           typeAhead: true,
           triggerAction: 'all',
           lazyRender: true,
           height: 25,
           valueField: 'CustId',
           displayField: 'CustName',
           cls: 'selectstylePerfectForFms',

           listeners: {
               select: {
                   fn: function() {
                     //  Ext.getCmp('vehicleTypecomboId').reset();
                   }

               }
           }
       });

       var viewCombo = new Ext.form.ComboBox({
           store: viewstore,
           id: 'viewComboId',
           mode: 'local',
           hidden: false,
           resizable: true,
           forceSelection: true,
           emptyText: 'Select View Type',
           blankText: 'Select View Type',
           selectOnFocus: true,
           allowBlank: false,
           typeAhead: true,
           triggerAction: 'all',
           lazyRender: true,
           valueField: 'ViewId',
           displayField: 'ViewName',
           cls: 'selectstylePerfectForFms',
           listeners: {
               select: {
                   fn: function() {
                   view = true;
                  
                       viewId = Ext.getCmp('viewComboId').getValue();
                      // Ext.getCmp('vehicleTypecomboId').reset();
                      if(Ext.getCmp('viewComboId').getValue() == 5){
                      Ext.getCmp('startdatelab').setText("Today's Date : ");
                      }else{
                      Ext.getCmp('startdatelab').setText("Start Date : ");
                      }
                       if (Ext.getCmp('viewComboId').getValue() == 1 || Ext.getCmp('viewComboId').getValue() == 3 || Ext.getCmp('viewComboId').getValue() == 7 ) {

                           Ext.getCmp('statutoryLabel').hide();
                           Ext.getCmp('statutoryDropdown').hide();
                           
                           Ext.getCmp('startdatelab').show();
                           Ext.getCmp('startdate').show();
                           
                           Ext.getCmp('startdate').setReadOnly(false);
                           var dat1 = new Date().add(Date.DAY, -1).format('d-m-Y');
                           dat1 = dat1+" 00:00:00";
                           Ext.getCmp('startdate').setValue(dat1);
                           
                           Ext.getCmp('enddatelab').show();
                           Ext.getCmp('enddate').show();

                           Ext.getCmp('selectdurationId').hide();
                           Ext.getCmp('durationComboId').hide();

                       }
                       if (Ext.getCmp('viewComboId').getValue() == 2 || Ext.getCmp('viewComboId').getValue() == 4 || Ext.getCmp('viewComboId').getValue() == 5 || Ext.getCmp('viewComboId').getValue() == 6 ) {
                           if(Ext.getCmp('viewComboId').getValue() != 6 ){
                           
                           Ext.getCmp('statutoryLabel').hide();
                           Ext.getCmp('statutoryDropdown').hide();
                           
                           Ext.getCmp('enddatelab').hide();
                           Ext.getCmp('enddate').hide();

                           Ext.getCmp('selectdurationId').show();
                           Ext.getCmp('durationComboId').show();

                           Ext.getCmp('startdatelab').show();
                           Ext.getCmp('startdate').show();
                           if( Ext.getCmp('viewComboId').getValue() == 5 || Ext.getCmp('viewComboId').getValue() == 6 ){
                           Ext.getCmp('startdate').setReadOnly(true);
                           var dat1 = new Date().add(Date.DAY, -0).format('d-m-Y');
                           dat1 = dat1+" 00:00:00";
                           Ext.getCmp('startdate').setMaxValue(maxdate);                          
                           Ext.getCmp('startdate').setValue(dat1);
                           
                           }else{
                           Ext.getCmp('startdate').setReadOnly(false);
                           var dat2 = new Date().add(Date.DAY, -1).format('d-m-Y');
                           dat2 = dat2+" 00:00:00";
                           Ext.getCmp('startdate').setMaxValue(maxdate);
                           Ext.getCmp('startdate').setValue(dat2);
                           }
                           if ( Ext.getCmp('viewComboId').getValue() == 2 || Ext.getCmp('viewComboId').getValue() == 5 || Ext.getCmp('viewComboId').getValue() == 6) {
                           Ext.getCmp('durationComboId').setValue(durationStore.getAt(0).data['DurationId']);
                           Ext.getCmp('durationComboId').setReadOnly(false);
                           }else if (Ext.getCmp('viewComboId').getValue() == 4) {
                           Ext.getCmp('durationComboId').setValue(durationStore.getAt(2).data['DurationId']);
                           Ext.getCmp('durationComboId').setReadOnly(true);
                           }
                           
                           }else if(Ext.getCmp('viewComboId').getValue() == 6 ){
                           
                           Ext.getCmp('startdatelab').hide();
                           Ext.getCmp('startdate').hide();
                           Ext.getCmp('enddatelab').hide();
                           Ext.getCmp('enddate').hide();

                           Ext.getCmp('selectdurationId').show();
                           Ext.getCmp('durationComboId').show();

                           Ext.getCmp('statutoryLabel').show();
                           Ext.getCmp('statutoryDropdown').show();
                                                     
                           Ext.getCmp('durationComboId').setValue(durationStore.getAt(0).data['DurationId']);
                           Ext.getCmp('durationComboId').setReadOnly(false);
                          
                           
                           }
                       }
                   }

               }
           }
       });


       var durationCombo = new Ext.form.ComboBox({
           store: durationStore,
           id: 'durationComboId',
           mode: 'local',
           hidden: false,
           resizable: true,
           forceSelection: true,
           emptyText: 'Select Duration',
           blankText: 'Select Duration',
           selectOnFocus: true,
           allowBlank: false,
           typeAhead: true,
           triggerAction: 'all',
           lazyRender: true,
           hidden: true,
           valueField: 'DurationId',
           displayField: 'DurationName',
           cls: 'selectstylePerfectForFms',
           listeners: {
               select: {
                   fn: function() {
                      // Ext.getCmp('vehicleTypecomboId').reset();
                   }

               }
           }
       });

       var vehicleTypecombo = new Ext.form.ComboBox({
           store: vehicelTypeStore,
           id: 'vehicleTypecomboId',
           mode: 'local',
           hidden: false,
           resizable: true,
           forceSelection: true,
           emptyText: 'Select Vehicle Type',
           blankText: 'Select Vehicle Type',
           selectOnFocus: true,
           allowBlank: false,
           triggerAction: 'all',
           valueField: 'VehicleTypeId',
           displayField: 'VehicleTypeName',
           cls: 'selectstylePerfectForFms',
           listeners: {
               select: {
                   fn: function() {
                       vehicleType = Ext.getCmp('vehicleTypecomboId').getRawValue();
                   }

               }
           }
       });         



     var statutoryTypeStoreCombo = new Ext.form.ComboBox({
           store: statutoryTypeStore,
           id: 'statutoryDropdown',
           mode: 'local',
           hidden: false,
           resizable: true,
           forceSelection: true,
           emptyText: 'Select Type',
           blankText: 'Select Type',
           selectOnFocus: true,
           allowBlank: false,
           typeAhead: true,
           triggerAction: 'all',
           lazyRender: true,

           valueField: 'TypeId',
           displayField: 'TypeName',
           cls: 'selectstylePerfectForFms',
           listeners: {
               select: {
                   fn: function() {
                       statutoryType = Ext.getCmp('statutoryDropdown').getValue();
                      
                   }

               }
           }
       });         




// ****************************** all combos starts here ************************

                var barchartPannel = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    hidden: true,
                    border: false,
                    bodyCssClass: 'barchartfmspannel',
                    id: 'barchartpanel1id',
                    items: [{
                        xtype: 'panel',
                        id: 'barchartpiepannelid',
                        cls: 'barchartpiepannelidcls',
                        border: false,
                        html: '<table width="100%"><tr><tr> <td> <div id="barchartddiv" class="barchartddivstatusfmsclass" align="left" onload="test()"> </div></td></tr></table>'
                    }]
                });

                var barchartPannelforall = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    hidden: true,
                    border: false,
                    bodyCssClass: 'barchartfmspannelforall',
                    id: 'barchartpanel1idforall',
                    items: [{
                        xtype: 'label',
                        id: 'statutaryHeader',
                        hidden: true,
                        text: '',
                        cls: 'dashboardpiechartheader'
                    }, {
                        xtype: 'panel',
                        id: 'barchartpiepannelidforall',
                        cls: 'barchartpiepannelidclsforall',
                        border: false,
                        html: '<table width="100%"><tr><tr> <td> <div id="barchartddivforall" class="barchartddivstatusfmsclassforall" align="left" onload="test()"> </div></td></tr></table>'
                    }]
                });

                var barchartPannelforall2 = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    hidden: true,
                    border: false,
                    bodyCssClass: 'barchartfmspannelforall',
                    id: 'barchartpanel1idforall2',
                    items: [{
                        xtype: 'label',
                        id: 'statutaryHeader',
                        hidden: true,
                        text: 'Stautory Alert of Vehicles',
                        cls: 'dashboardpiechartheader'
                    }, {
                        xtype: 'panel',
                        id: 'barchartpiepannelidforall2',
                        cls: 'barchartpiepannelidclsforall',
                        border: false,
                        html: '<table width="100%"><tr><tr> <td> <div id="barchartddivforall2" class="barchartddivstatusfmsclassforall" align="right" onload="test()"> </div></td></tr></table>'
                    }]
                });

                function test() {}
                var graphpannel = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    border: false,
                    width: '80%',
                    id: 'graphpannel',
                    items: [barchartPannel]
                });


                graphpannelforall = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    border: false,
                    width: '49%',
                    paddingRight: '1%',
                    id: 'graphpannelforall',
                    items: [barchartPannelforall]
                });

                graphpannelforall2 = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    border: false,
                    width: '49%',
                    paddingRight: '1%',
                    id: 'graphpannelforall2',
                    items: [barchartPannelforall2]
                });

                var innerSecondMainPannel = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    border: false,
                    hidden: true,
                    bodyCssClass: 'innersecondmainpannelfmsdashboard',
                    id: 'innersecondmainpannel',
                    items: [graphpannel]
                });

                var innerThirdMainPanel = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    border: false,
                    hidden: true,
                    bodyCssClass: 'innerthirdmainpannelfmsdashboard',
                    id: 'innerthirdmainpannel',
                    layout: 'column',
                    layoutConfig: {
                        columns: 2
                    },
                    items: [graphpannelforall, graphpannelforall2]
                });

                var innerMainPannel = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    border: false,
                    width: '100%',
                    hidden: true,
                    id: 'innermainpannel',
                    bodyCssClass: 'innermainpannelcss',
                    items: [innerSecondMainPannel]
                });

                var innerMainPannelforall = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    border: false,
                    width: '100%',
                    hidden: true,
                    id: 'innermainpannelforall',
                    bodyCssClass: 'innermainpannelcssforall',
                    items: [innerThirdMainPanel]
                });



 var gridpanel = new Ext.Panel({
                    standardSubmit: true,
                    frame: false,
                    border: false,
                    width: '100%',
                    hidden: true,
                    id: 'gridpanelid',
                    bodyCssClass: 'gridpannelcss',
                    items: [grid]
                });
                var customerPannel = new Ext.Panel({
                    standardSubmit: true,
                    collapsible: false,
                    border: false,
                    frame: false,
                    width: '100%',
                    bodyCssClass: 'customerPannelcss',
                    id: 'custMaster',
                    layout: 'table',
                    layoutConfig: {
                        columns: 26
                    },
                    items: [{
                            xtype: 'label',
                            text: 'Select Customer' + ':',
                            allowBlank: false,
                            hidden: false,
                            cls: 'dashBoardlabelstyle',
                            id: 'custnamhidlab1'
                        }, custnamecombo, {
                            width: 10
                        },
                        {
                            xtype: 'label',
                            text: 'Select View' + ':',
                            allowBlank: false,
                            hidden: false,
                            cls: 'dashBoardlabelstyle',
                            id: 'custnamhidlab2'
                        },
                        viewCombo, {
                            width: 10
                        },  {
                            xtype: 'label',
                            cls: 'dashBoardlabelstyle',
                            id: 'selectdurationId',
                            text: 'Select Duration' + ':',
                            hidden: true
                        },
                        durationCombo, {
                            width: 10
                        },{
                            xtype: 'label',
                            cls: 'dashBoardlabelstyle',
                            id: 'startdatelab',
                            text: 'Start Date' + ':',
                            hidden: true
                        }, {
                            width: 10
                        }, {
                            xtype: 'datefield',
                            cls: 'selectstylePerfectForFms',
                            width: 180,
                            format: getDateTimeFormat(),
                            emptyText: 'Select Start Date',
                            allowBlank: false,
                            blankText: 'Select Start Date',
                            id: 'startdate',
                            value: dtprev,
                            maxValue:datecur,
                            endDateField: 'enddate',
                            hidden: true,
                            listeners: {
                                change: function(field, newValue, oldValue){
                               var NewValues = newValue.format('d-m-Y');
                                   NewValues = NewValues+" 00:00:00";
					            field.setValue(NewValues);
                                }
                            }
                        }, {
                            width: 10
                        },{
                            xtype: 'label',
                            cls: 'dashBoardlabelstyle',
                            id: 'statutoryLabel',
                            text: 'Select Type' + ':',
                            hidden: true
                        }, {
                            width: 10
                        }, statutoryTypeStoreCombo, {
                            width: 10
                        },{
                            xtype: 'label',
                            cls: 'dashBoardlabelstyle',
                            id: 'enddatelab',
                            text: 'End Date' + ':',
                            hidden: true
                        }, {
                            width: 10
                        }, {
                            xtype: 'datefield',
                            cls: 'selectstylePerfectForFms',
                            width: 180,
                            format: getDateTimeFormat(),
                            emptyText: 'Select End Date',
                            allowBlank: false,
                            blankText: 'Select End Date',
                            id: 'enddate',
                            value: datecur,
                            maxValue:maxdate,
                            startDateField: 'startdate',
                            hidden: true,
                            listeners: {
                                change: function(field, newValue, oldValue){
					             var NewValues = newValue.format('d-m-Y');
                                   NewValues = NewValues+" 23:59:59";
					            field.setValue(NewValues);
                                }
                            }
                        }, {
                            width: 10
                        },
                       
                        {
                            xtype: 'label',
                            text: 'Vehicle Type' + ':',
                            allowBlank: false,
                            hidden: false,
                            cls: 'dashBoardlabelstyle',
                            id: 'selectVehicleLableId'
                        },
                        vehicleTypecombo,{width:50},{
        xtype: 'button',
        text: 'View',
        id: 'submitId',
        cls: 'buttonStyle',
        width: 60,
        handler: function() {                          
        ShowGraph();
        }
        }
                    ]
                });


function showcolumnFunctions(ReportType){
 
  if(ReportType == 1) {
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleNoDateIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('groupNameDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateNewDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endDateDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlinghrsDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('enginehrsDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlingCountDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountbeforeexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountafterexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmDateDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startLocationDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endLocationDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DueDateDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DistanceDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('FuelDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('MileageDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('PMStatusDataIndex'), true);
  
 }
  else if(ReportType == 2){
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleNoDateIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('groupNameDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateNewDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endDateDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlinghrsDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('enginehrsDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlingCountDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountbeforeexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountafterexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmDateDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startLocationDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endLocationDataIndex'), true); 
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DueDateDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DistanceDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('FuelDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('MileageDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('PMStatusDataIndex'), true);
  }
  else if(ReportType == 3) {
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleNoDateIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('groupNameDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateNewDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endDateDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlinghrsDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('enginehrsDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlingCountDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountbeforeexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountafterexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmDateDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startLocationDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endLocationDataIndex'), false);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DueDateDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DistanceDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('FuelDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('MileageDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('PMStatusDataIndex'), true);
 
 }
 else if(ReportType == 4){
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleNoDateIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('groupNameDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateNewDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endDateDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlinghrsDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('enginehrsDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlingCountDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountbeforeexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountafterexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmDateDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startLocationDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endLocationDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DueDateDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DistanceDataIndex'), false);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('FuelDataIndex'), false);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('MileageDataIndex'), false);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('PMStatusDataIndex'), true);
 
  }
  else if(ReportType == 5){
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleNoDateIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('groupNameDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateDataIndex'), false);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateNewDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endDateDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlinghrsDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('enginehrsDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlingCountDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountbeforeexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountafterexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmDateDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startLocationDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endLocationDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DueDateDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DistanceDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('FuelDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('MileageDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('PMStatusDataIndex'), false);
 
  }
    else if(ReportType == 6){
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleNoDateIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('groupNameDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateNewDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endDateDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlinghrsDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('enginehrsDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlingCountDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountbeforeexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountafterexpDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmDateDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startLocationDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endLocationDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DueDateDataIndex'), false);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DistanceDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('FuelDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('MileageDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('PMStatusDataIndex'), true);
 
  }
  
   else if(ReportType == 7){
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('vehicleNoDateIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('groupNameDataIndex'), false);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startDateNewDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endDateDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlinghrsDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('enginehrsDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('idlingCountDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountDataIndex'), true); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountbeforeexpDataIndex'), false); 
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmCountafterexpDataIndex'), true); 
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('pmDateDataIndex'), false); 
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('startLocationDataIndex'), true);
 grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('endLocationDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DueDateDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('DistanceDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('FuelDataIndex'), true);
  grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('MileageDataIndex'), true);
   grid.getColumnModel().setHidden(grid.getColumnModel().findColumnIndex('PMStatusDataIndex'), true);
 
 
  } 
}



                //***************************  Main starts from here **************************************************
                Ext.onReady(function() {
                    Ext.QuickTips.init();
                    Ext.form.Field.prototype.msgTarget = 'side';

                    outerPanel = new Ext.Panel({
                        renderTo: 'content',
                        standardSubmit: true,
                        border: false,
                        bodyCssClass: 'outerpaneldashboard',
                        items: [customerPannel,innerMainPannel,innerMainPannelforall,gridpanel]
                    });
                    var firstview = viewstore.getAt(0).data['ViewId'];
                    Ext.getCmp('viewComboId').setValue(firstview);
                    reportType = firstview;
                    Ext.getCmp('startdatelab').show();
                    Ext.getCmp('startdate').show();
                    Ext.getCmp('enddatelab').show();
                    Ext.getCmp('enddate').show();
                    Ext.getCmp('statutoryLabel').hide();
                    Ext.getCmp('statutoryDropdown').hide();
                    Ext.getCmp('selectdurationId').hide();
                    Ext.getCmp('durationComboId').hide();
                       Ext.getCmp('innermainpannel').show();
                    Ext.getCmp('innermainpannelforall').hide();
                    Ext.getCmp('innersecondmainpannel').show();
                    Ext.getCmp('innerthirdmainpannel').hide();    
                    vehicelTypeStore.load({
                     callback:function(){
                    Ext.getCmp('vehicleTypecomboId').setValue(vehicelTypeStore.getAt(0).data['VehicleTypeId']); 
                    ShowGraph();                  
                    }
                    });
                         
                   
                });
            </script>
        <jsp:include page="../Common/footer.jsp" />
		<!-- </body>   -->
		<!-- </html> -->