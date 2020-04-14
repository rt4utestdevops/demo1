<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
        <%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";

String SelectCustomer="Select Customer"; 
String CustomerName="Customer Name";
String SelectLTSP="Select Ltsp Name";
String LTSPName="Ltsp Name";

%>
<!DOCTYPE HTML>
<html  lang="en">

<head>
		
		<base href="<%=basePath%>">
		<title>MiningTimeSetting</title>
</head>
<style>
   .x-panel-tl {
       border-bottom: 0px solid !important;
   }
</style>
<style>
.x-form-text,.x-form-textarea,.x-combo-list{
	 direction: ltr;
}
</style>
<body>

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
<pack:style src="../../Main/resources/css/xtheme-DeepBlue.css" />
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

<script>
document.documentElement.setAttribute("dir", "ltr");
function getwindow(jsp){
window.location=jsp;
 }
</script>
  <table id="tableID" style="width:100%;height:99%;background-color:#FFFFFF;margin-top: 0;overflow:hidden" align="center">
  <tr valign="top" height="99%">
  <td height="99%" id="content">
  </td>
  </tr>
</table>
              
               
 <script>
                   var timesStore = new Ext.data.JsonStore({
				    url: '<%=request.getContextPath()%>/MiningTimes.do?param=getMiningTimes',
				    id: 'timesStoreId',
				    autoLoad: false,
				    root: 'timesStoreRoot',
				    remoteStore: true,
				    fields: ['startHrsInx','endHrsInx','brStartHrsInx','brEndHrsInx','startMntInx','endMntInx','brStartMntInx','brEndMntInx','nonComHrsInx','firstResStartHrsInx','firstResStartMntInx','firstResEndHrsInx','firstResEndMntInx','secondResStartHrsInx','secondResStartMntInx','secondResEndHrsInx','secondResEndMntInx']
				    });
                   
                   var LTSPStore= new Ext.data.JsonStore({
					   url:'<%=request.getContextPath()%>/MiningTimes.do?param=getLTSPS',
					   id:'LTSPSRoreId',
				       root: 'LTSPRoot',
				       autoLoad: true,
				       remoteSort:true,
					   fields: ['ltspId','ltspName']
				     });
                   
                   var clientcombostore = new Ext.data.JsonStore({
                      url: '<%=request.getContextPath()%>/MiningTimes.do?param=getCustomersForLTSP',
					  id: 'CustomerStoreId',
					  root: 'CustomerRoot',
					  autoLoad: false,
					  remoteSort: true,
					  fields: ['CustId', 'CustName'],
                   });
                   var LTSP = new Ext.form.ComboBox({
                       store: LTSPStore,
                       id: 'LTSPcomboId',
                       mode: 'local',
                       forceSelection: true,
                       emptyText: '<%=SelectLTSP%>',
                       blankText: '<%=SelectLTSP%>',
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'ltspId',
                       displayField: 'ltspName',
                       cls: 'selectstylePerfect',
                       listeners: {
                           select: {
                               fn: function() {
                               	   Ext.getCmp('startTimeHId').reset();
                               	   Ext.getCmp('startTimeMId').reset();
                               	   Ext.getCmp('endTimeHId').reset();
                               	   Ext.getCmp('endTimeMId').reset();
                               	   Ext.getCmp('brStartTimeHId').reset();
                               	   Ext.getCmp('brStartTimeMId').reset();
                               	   Ext.getCmp('brEndTimeHId').reset();
                               	   Ext.getCmp('brEndTimeMId').reset();
                               	   Ext.getCmp('firstResStartTimeHId').reset();
                               	   Ext.getCmp('firstResStartTimeMId').reset();
                               	   Ext.getCmp('firstResEndTimeHId').reset();
                               	   Ext.getCmp('firstResEndTimeMId').reset();
                               	   Ext.getCmp('secondResStartTimeHId').reset();
                               	   Ext.getCmp('secondResStartTimeMId').reset();
                               	   Ext.getCmp('secondResEndTimeHId').reset();
                               	   Ext.getCmp('secondResEndTimeMId').reset();
                               	   Ext.getCmp('nonComHrsId').reset();
                               	   Ext.getCmp('custcomboId').reset();
                               	   clientcombostore.load({
	                               	   	params:{
	                               	   	   ltspSystemId: Ext.getCmp('LTSPcomboId').getValue()
	                               	   	}
                               	   });
                               }
                           }
                       }
                   });

                   var Client = new Ext.form.ComboBox({
                       store: clientcombostore,
                       id: 'custcomboId',
                       mode: 'local',
                       forceSelection: true,
                       emptyText: '<%=SelectCustomer%>',
                       blankText: '<%=SelectCustomer%>',
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
                               	   Ext.getCmp('startTimeHId').reset();
                               	   Ext.getCmp('startTimeMId').reset();
                               	   Ext.getCmp('endTimeHId').reset();
                               	   Ext.getCmp('endTimeMId').reset();
                               	   Ext.getCmp('brStartTimeHId').reset();
                               	   Ext.getCmp('brStartTimeMId').reset();
                               	   Ext.getCmp('brEndTimeHId').reset();
                               	   Ext.getCmp('brEndTimeMId').reset();
                               	   Ext.getCmp('nonComHrsId').reset();
                               	   Ext.getCmp('firstResStartTimeHId').reset();
                               	   Ext.getCmp('firstResStartTimeMId').reset();
                               	   Ext.getCmp('firstResEndTimeHId').reset();
                               	   Ext.getCmp('firstResEndTimeMId').reset();
                               	   Ext.getCmp('secondResStartTimeHId').reset();
                               	   Ext.getCmp('secondResStartTimeMId').reset();
                               	   Ext.getCmp('secondResEndTimeHId').reset();
                               	   Ext.getCmp('secondResEndTimeMId').reset();
                                   timesStore.load({
                                      params:{
                                       ltspSystemId: Ext.getCmp('LTSPcomboId').getValue(),
                                       custId: Ext.getCmp('custcomboId').getValue()
                                      },
                                      callback: function(){
		                                        if(timesStore != null && timesStore.getAt(0) != null){
		                                      	var rec = timesStore.getAt(0);
		                                      	var mta=HrsStore.getAt(Number(rec.data['startHrsInx']));
		                                      	Ext.getCmp('startTimeHId').setValue(mta.data['val']);
		                                      	var mt1=mntsStore.getAt(Number(rec.data['startMntInx']));
		                                      	Ext.getCmp('startTimeMId').setValue(mt1.data['val']);
		                                      	var mtb=HrsStore.getAt(Number(rec.data['endHrsInx']));
		                                      	Ext.getCmp('endTimeHId').setValue(mtb.data['val']);
		                                      	var mt2=mntsStore.getAt(Number(rec.data['endMntInx']));
		                                      	Ext.getCmp('endTimeMId').setValue(mt2.data['val']);
		                                      	var mtc=HrsStore.getAt(Number(rec.data['brStartHrsInx']));
		                                      	Ext.getCmp('brStartTimeHId').setValue(mtc.data['val']);
		                                      	var mt3=mntsStore.getAt(Number(rec.data['brStartMntInx']));
		                                      	Ext.getCmp('brStartTimeMId').setValue(mt3.data['val']);
		                                      	var mtd=HrsStore.getAt(Number(rec.data['brEndHrsInx']));
		                                      	Ext.getCmp('brEndTimeHId').setValue(mtd.data['val']);
		                                      	var mt4=mntsStore.getAt(Number(rec.data['brEndMntInx']));
		                                      	Ext.getCmp('brEndTimeMId').setValue(mt4.data['val']);
		                                      	var mte=HrsStore.getAt(Number(rec.data['firstResStartHrsInx']));
		                                      	Ext.getCmp('firstResStartTimeHId').setValue(mte.data['val']);
		                                      	var mt5=mntsStore.getAt(Number(rec.data['firstResStartMntInx']));
		                                      	Ext.getCmp('firstResStartTimeMId').setValue(mt5.data['val']);
		                                      	var mtf=HrsStore.getAt(Number(rec.data['firstResEndHrsInx']));
		                                      	Ext.getCmp('firstResEndTimeHId').setValue(mtf.data['val']);
		                                      	var mt6=mntsStore.getAt(Number(rec.data['firstResEndMntInx']));
		                                      	Ext.getCmp('firstResEndTimeMId').setValue(mt6.data['val']);
		                                      	var mtg=HrsStore.getAt(Number(rec.data['secondResStartHrsInx']));
		                                      	Ext.getCmp('secondResStartTimeHId').setValue(mtg.data['val']);
		                                      	var mt7=mntsStore.getAt(Number(rec.data['secondResStartMntInx']));
		                                      	Ext.getCmp('secondResStartTimeMId').setValue(mt7.data['val']);
		                                      	var mth=HrsStore.getAt(Number(rec.data['secondResEndHrsInx']));
		                                      	Ext.getCmp('secondResEndTimeHId').setValue(mth.data['val']);
		                                      	var mt8=mntsStore.getAt(Number(rec.data['secondResEndMntInx']));
		                                      	Ext.getCmp('secondResEndTimeMId').setValue(mt8.data['val']);
		                                      	Ext.getCmp('nonComHrsId').setValue(rec.data['nonComHrsInx']);
		                                  }    	
                                      }
                                    });
                               }
                           }
                       }
                   });
		/*********************************Main Panel Data**************************************/
		var Hrs = [["0","00"],["1","01"],["2","02"],["3","03"],["4","04"],["5","05"],["6","06"],["7","07"],["8","08"],["9","09"],["10","10"],["11","11"],["12","12"],["13","13"],["14","14"],["15","15"],["16","16"],["17","17"],["18","18"],["19","19"],["20","20"],["21","21"],["22","22"],["23","23"]];		   
		var mnts = [['00','00'],['01','01'],['02','02'],['03','03'],['04','04'],['05','05'],['06','06'],['07','07'],['08','08'],['09','09'],['10','10'],['11','11'],['12','12'],['13','13'],['14','14'],['15','15'],['16','16'],['17','17'],['18','18'],['19','19'],['20','20'],['21','21'],['22','22'],['23','23'],['24','24'],['25','25'],['26','26'],['27','27'],['28','28'],['29','29'],['30','30'],['31','31'],['32','32'],['33','33'],['34','34'],['35','35'],['36','36'],['37','37'],['38','38'],['39','39'],['40','40'],['41','41'],['42','42'],['43','43'],['44','44'],['45','45'],['46','46'],['47','47'],['48','48'],['49','49'],['50','50'],['51','51'],['52','52'],['53','53'],['54','54'],['55','55'],['56','56'],['57','57'],['58','58'],['59','59']];
					
					var HrsStore  = new Ext.data.SimpleStore({
				        id: 'HrsStoreId',
				        autoLoad: false,
				        fields:['val','num'],
				        data: Hrs
				    });
				    var HrsStore2  = new Ext.data.SimpleStore({
				        id: 'HrsStoreId',
				        autoLoad: false,
				        fields:['val','num'],
				        data: Hrs
				    });
				    var HrsStore3  = new Ext.data.SimpleStore({
				        id: 'HrsStoreId',
				        autoLoad: false,
				        fields:['val','num'],
				        data: Hrs
				    });
				    var HrsStore4  = new Ext.data.SimpleStore({
				        id: 'HrsStoreId',
				        autoLoad: false,
				        fields:['val','num'],
				        data: Hrs
				    });
				    var HrsStore5  = new Ext.data.SimpleStore({
				        id: 'HrsStore5Id',
				        autoLoad: false,
				        fields:['val','num'],
				        data: Hrs
				    });
				     var HrsStore6  = new Ext.data.SimpleStore({
				        id: 'HrsStore6Id',
				        autoLoad: false,
				        fields:['val','num'],
				        data: Hrs
				    });
				     var HrsStore7  = new Ext.data.SimpleStore({
				        id: 'HrsStore7Id',
				        autoLoad: false,
				        fields:['val','num'],
				        data: Hrs
				    });
				     var HrsStore8  = new Ext.data.SimpleStore({
				        id: 'HrsStore8Id',
				        autoLoad: false,
				        fields:['val','num'],
				        data: Hrs
				    });
					var mntsStore  = new Ext.data.SimpleStore({
				        id: 'mntsStoreId',
				        autoLoad: false,
				        fields:['val','num'],
				        data: mnts
				    });
				    var mntsStore2  = new Ext.data.SimpleStore({
				        id: 'mntsStoreId',
				        autoLoad: false,
				        fields:['val','num'],
				        data: mnts
				    });
				    var mntsStore3  = new Ext.data.SimpleStore({
				        id: 'mntsStoreId',
				        autoLoad: false,
				        fields:['val','num'],
				        data: mnts
				    });
				    var mntsStore4  = new Ext.data.SimpleStore({
				        id: 'mntsStoreId',
				        autoLoad: false,
				        fields:['val','num'],
				        data: mnts
				    });
				     var mntsStore5  = new Ext.data.SimpleStore({
				        id: 'mntsStore5Id',
				        autoLoad: false,
				        fields:['val','num'],
				        data: mnts
				    });
				     var mntsStore6  = new Ext.data.SimpleStore({
				        id: 'mntsStore6Id',
				        autoLoad: false,
				        fields:['val','num'],
				        data: mnts
				    });
				     var mntsStore7  = new Ext.data.SimpleStore({
				        id: 'mntsStore7Id',
				        autoLoad: false,
				        fields:['val','num'],
				        data: mnts
				    });
				     var mntsStore8  = new Ext.data.SimpleStore({
				        id: 'mntsStore8Id',
				        autoLoad: false,
				        fields:['val','num'],
				        data: mnts
				    });
				    var startTimeH = new Ext.form.ComboBox({
                       store: HrsStore,
                       id: 'startTimeHId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                   });
                   var startTimeM = new Ext.form.ComboBox({
                       store: mntsStore,
                       id: 'startTimeMId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   
				   var endTimeH = new Ext.form.ComboBox({
                       store: HrsStore2,
                       id: 'endTimeHId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                   });
                   var endTimeM = new Ext.form.ComboBox({
                       store: mntsStore2,
                       id: 'endTimeMId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   			
				   var brStartTimeH = new Ext.form.ComboBox({
                       store: HrsStore3,
                       id: 'brStartTimeHId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                   });
                    var brStartTimeM = new Ext.form.ComboBox({
                       store: mntsStore3,
                       id: 'brStartTimeMId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   
				   var brEndTimeH = new Ext.form.ComboBox({
                       store: HrsStore4,
                       id: 'brEndTimeHId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   var brEndTimeM = new Ext.form.ComboBox({
                       store: mntsStore4,
                       id: 'brEndTimeMId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   
                   var firstRestrictiveStartTimeH = new Ext.form.ComboBox({
                       store: HrsStore5,
                       id: 'firstResStartTimeHId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                   });
                    var firstRestrictiveStartTimeM = new Ext.form.ComboBox({
                       store: mntsStore5,
                       id: 'firstResStartTimeMId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   
				   var firstRestrictiveEndTimeH = new Ext.form.ComboBox({
                       store: HrsStore6,
                       id: 'firstResEndTimeHId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   var firstRestrictiveEndTimeM = new Ext.form.ComboBox({
                       store: mntsStore6,
                       id: 'firstResEndTimeMId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   var secondRestrictiveStartTimeH = new Ext.form.ComboBox({
                       store: HrsStore7,
                       id: 'secondResStartTimeHId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                   });
                    var secondRestrictiveStartTimeM = new Ext.form.ComboBox({
                       store: mntsStore7,
                       id: 'secondResStartTimeMId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   
				   var secondRestrictiveEndTimeH = new Ext.form.ComboBox({
                       store: HrsStore8,
                       id: 'secondResEndTimeHId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   var secondRestrictiveEndTimeM = new Ext.form.ComboBox({
                       store: mntsStore8,
                       id: 'secondResEndTimeMId',
                       mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'val',
                       displayField: 'num',
                       //cls: 'selectstylePerfect',
                       width:60,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
 /************************************************************ Panels ********************************************************************/                   
                    var innerPanel1 = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'innerPanel1Id',
                        layout: 'table',
                        layoutConfig: {
				           columns: 5
				        }, 
                        frame: false,
                        width: 590,
                        height: 40,
                        items: [{xtype: 'label',
				               text: '<%=LTSPName%>' + ' :',
				               cls: 'labelstyle'
				           	   }, LTSP,
				           	   {width:30},
				           	   {xtype: 'label',
				               text: '<%=CustomerName%>' + ' :',
				               cls: 'labelstyle'
				           	   }, Client]
                        });
          
                    var innerPanel2 = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'innerPanel2Id',
                        layout: 'table',
                        layoutConfig: {
				           columns: 8
				        }, 
                        frame: false,
                        width: 590,
                        height: 300,
                        items: [{width:40},{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'ml1'
				               },{
				               xtype: 'label',
				               text: 'Start Time' + ' :',
				               cls: 'labelstyle'
				           	   },startTimeH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle'
				           	   },{height: 30,width:33},startTimeM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle'
				           	   },{},{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'ml2'
				               },{
				               xtype: 'label',
				               text: 'End Time' + ' :',
				               cls: 'labelstyle'
				           	   },endTimeH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle'
				           	   },{height: 30,width:33},endTimeM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle'
				           	   },{},{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'ml3'
				               },{
				               xtype: 'label',
				               text: 'Break Start Time' + ' :',
				               cls: 'labelstyle'
				           	   },brStartTimeH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle'
				           	   },{height: 30,width:33},brStartTimeM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle'
				           	   },{},{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'ml4'
				               },{
				               xtype: 'label',
				               text: 'Break End Time' + ' :',
				               cls: 'labelstyle'
				           	   },brEndTimeH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle'
				           	   },{height: 30,width:33},brEndTimeM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle'
				           	   },{},{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'ml5'
				               },{
				               xtype: 'label',
				               text: 'First Restrictive Start Time' + ' :',
				               cls: 'labelstyle'
				           	   },firstRestrictiveStartTimeH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle'
				           	   },{height: 30,width:33},firstRestrictiveStartTimeM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle'
				           	   },{},{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'ml6'
				               },{
				               xtype: 'label',
				               text: 'First Restrictive End Time' + ' :',
				               cls: 'labelstyle'
				           	   },firstRestrictiveEndTimeH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle'
				           	   },{height: 30,width:33},firstRestrictiveEndTimeM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle'
				           	   },{},{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'ml7'
				               },{
				               xtype: 'label',
				               text: 'Second Restrictive Start Time' + ' :',
				               cls: 'labelstyle'
				           	   },secondRestrictiveStartTimeH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle'
				           	   },{height: 30,width:33},secondRestrictiveStartTimeM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle'
				           	   },{},{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'ml8'
				               },{
				               xtype: 'label',
				               text: 'Second Restrictive End Time' + ' :',
				               cls: 'labelstyle'
				           	   },secondRestrictiveEndTimeH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle'
				           	   },{height: 30,width:33},secondRestrictiveEndTimeM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle'
				           	   },{},{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'ml9'
				               },{
				               xtype: 'label',
				               text: 'Non Communication Hours' + ' :',
				               cls: 'labelstyle',
				               columns: 2
				           	   },{
				           	   xtype: 'textfield',
				           	   //cls: 'selectstylePerfect',
				           	   width:60,
                			   id: 'nonComHrsId',
               				   mode: 'local'
				           	   }
				           	   ]
                    });
                    
                    var buttonPanel = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'buttonPanelId',
                        layout: 'table',
                        layoutConfig: {
				           columns: 2
				        }, 
                        frame: false,
                        width: '100%',
                        height: 70,
                        items: [{width: 250 },
                        	   {xtype: 'button',
				                text: 'Save',
				                iconCls : 'savebutton',
				                cls: 'buttonstyle',
				                listeners: {
	                             click: {
	                               fn: function() {
	                               	   if (Ext.getCmp('LTSPcomboId').getValue() == "") {
	                                       Ext.example.msg("<%=SelectLTSP%>");
	                                       Ext.getCmp('LTSPcomboId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('custcomboId').getValue() == "") {
	                                       Ext.example.msg("<%=SelectCustomer%>");
	                                       Ext.getCmp('custcomboId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('startTimeHId').getValue() == "") {
	                                       Ext.example.msg("Select Start Time Hours");
	                                       Ext.getCmp('startTimeHId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('startTimeMId').getValue() == "") {
	                                       Ext.example.msg("Select Start Time Minutes");
	                                       Ext.getCmp('startTimeMId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('endTimeHId').getValue() == "") {
	                                       Ext.example.msg("Select End Time Hours");
	                                       Ext.getCmp('endTimeHId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('endTimeMId').getValue() == "") {
	                                       Ext.example.msg("Select End Time Minutes");
	                                       Ext.getCmp('endTimeMId').focus();
	                                       return;
	                                   }

	                                   var startTime =Number(Ext.getCmp('startTimeHId').getValue()+"."+Ext.getCmp('startTimeMId').getValue());
	                                   var endTime =Number(Ext.getCmp('endTimeHId').getValue()+"."+Ext.getCmp('endTimeMId').getValue());
	                                   
	                                   if(startTime>endTime){
	                                       Ext.example.msg("End Time should not less than Start Time");
	                                       return;
	                                   }
	                                   
	                                   if (Ext.getCmp('brStartTimeHId').getValue() == "") {
	                                       Ext.example.msg("Select Break Start Time Hours");
	                                       Ext.getCmp('brStartTimeHId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('brStartTimeMId').getValue() == "") {
	                                       Ext.example.msg("Select Break Start Time Minutes");
	                                       Ext.getCmp('brStartTimeMId').focus();
	                                       return;
	                                   }
	                                   var breakStartTime =Number(Ext.getCmp('brStartTimeHId').getValue()+"."+Ext.getCmp('brStartTimeMId').getValue());
	                                   
	                                   if (startTime>breakStartTime) {    
	                                       Ext.example.msg("Break Start Time should not less than Start Time");
	                                       return;
	                                   }
	                                   if (endTime<breakStartTime) {    
	                                       Ext.example.msg("Break Start Time should not greater than End Time");
	                                       return;
	                                   }
	                                   
	                                   if (Ext.getCmp('brEndTimeHId').getValue() == "") {
	                                       Ext.example.msg("Select Break End Time Hours");
	                                       Ext.getCmp('brEndTimeHId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('brEndTimeMId').getValue() == "") {
	                                       Ext.example.msg("Select Break End Time Minutes");
	                                       Ext.getCmp('brEndTimeMId').focus();
	                                       return;
	                                   }
	                                   var breakEndTime =Number(Ext.getCmp('brEndTimeHId').getValue()+"."+Ext.getCmp('brEndTimeMId').getValue());
	                                   
	                                   if (breakEndTime<breakStartTime) {    
	                                       Ext.example.msg("Break End Time should not less than Break Start Time");
	                                       return;
	                                   }
	                                   if (breakEndTime>endTime) {    
	                                       Ext.example.msg("Break End Time should not greater than End Time");
	                                       return;
	                                   }
	                                   if (Ext.getCmp('firstResStartTimeHId').getValue() == "") {
	                                       Ext.example.msg("Select First Restrictive Start Time Hours");
	                                       Ext.getCmp('firstResStartTimeHId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('firstResStartTimeMId').getValue() == "") {
	                                       Ext.example.msg("Select First Restrictive Start Time Minutes");
	                                       Ext.getCmp('firstResStartTimeMId').focus();
	                                       return;
	                                   }
	                                   var firstResStartTime =Number(Ext.getCmp('firstResStartTimeHId').getValue()+"."+Ext.getCmp('firstResStartTimeMId').getValue());
	                                   
	                                   if (Ext.getCmp('firstResEndTimeHId').getValue() == "") {
	                                       Ext.example.msg("Select First Restrictive End Time Hours");
	                                       Ext.getCmp('firstResEndTimeHId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('firstResEndTimeMId').getValue() == "") {
	                                       Ext.example.msg("Select First Restrictive End Time Minutes");
	                                       Ext.getCmp('firstResEndTimeMId').focus();
	                                       return;
	                                   }
	                                   var firstResEndTime =Number(Ext.getCmp('firstResEndTimeHId').getValue()+"."+Ext.getCmp('firstResEndTimeMId').getValue());
	                                   
	                                   if (firstResEndTime<firstResStartTime) {    
	                                       Ext.example.msg("First Restrictive End Time should not less than First Restrictive Start Time");
	                                       return;
	                                   }
	                                   if (Ext.getCmp('secondResStartTimeHId').getValue() == "") {
	                                       Ext.example.msg("Select Second Restrictive Start Time Hours");
	                                       Ext.getCmp('secondResStartTimeHId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('secondResStartTimeMId').getValue() == "") {
	                                       Ext.example.msg("Select Second Restrictive Start Time Minutes");
	                                       Ext.getCmp('secondResStartTimeMId').focus();
	                                       return;
	                                   }
	                                   var secondResStartTime =Number(Ext.getCmp('secondResStartTimeHId').getValue()+"."+Ext.getCmp('secondResStartTimeMId').getValue());
	                                   
	                                   if (Ext.getCmp('secondResEndTimeHId').getValue() == "") {
	                                       Ext.example.msg("Select Second Restrictive End Time Hours");
	                                       Ext.getCmp('secondResEndTimeHId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('secondResEndTimeMId').getValue() == "") {
	                                       Ext.example.msg("Select Second Restrictive End Time Minutes");
	                                       Ext.getCmp('secondResEndTimeMId').focus();
	                                       return;
	                                   }
	                                   var secondResEndTime =Number(Ext.getCmp('secondResEndTimeHId').getValue()+"."+Ext.getCmp('secondResEndTimeMId').getValue());
	                                   
	                                   if (secondResEndTime<secondResStartTime) {    
	                                       //Ext.example.msg("Second Restrictive End Time should not less than Second Restrictive Start Time");
	                                       //return;
	                                   }
	                                   if (Ext.getCmp('nonComHrsId').getValue() == "") {
	                                       Ext.example.msg("Enter Non Communication Hours");
	                                       Ext.getCmp('nonComHrsId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('nonComHrsId').getValue() == "00:00") {
	                                       Ext.example.msg("Non Communication Hours can not be 00:00 ");
	                                       Ext.getCmp('nonComHrsId').focus();
	                                       return;
	                                   }
	                                   var datePattern = /^([01]\d|2[0-3]):?([0-5]\d)$/;
							           if(!datePattern.test(Ext.getCmp('nonComHrsId').getValue())){
							           	   Ext.example.msg("Enter Non Communication Hours as HH:mm format");
	                                       Ext.getCmp('nonComHrsId').focus();
							           	   return;
							           }
	                                   innerPanel.getEl().mask();
				                        Ext.Ajax.request({
			                            url: '<%=request.getContextPath()%>/MiningTimes.do?param=saveMiningTimes',
			                            method: 'POST',
			                            params: {
			                                ltspSystemId: Ext.getCmp('LTSPcomboId').getValue(),
			                                custId: Ext.getCmp('custcomboId').getValue(),
			                                startTimeHrs: Ext.getCmp('startTimeHId').getValue(),
			                                startTimeMnt: Ext.getCmp('startTimeMId').getValue(),
			                                endTimeHrs: Ext.getCmp('endTimeHId').getValue(),
			                                endTimeMnt: Ext.getCmp('endTimeMId').getValue(),
			                                brStartTimeHrs: Ext.getCmp('brStartTimeHId').getValue(),
			                                brStartTimeMnt: Ext.getCmp('brStartTimeMId').getValue(),
			                                brEndTimeHrs: Ext.getCmp('brEndTimeHId').getValue(),
			                                brEndTimeMnt: Ext.getCmp('brEndTimeMId').getValue(),
			                                firstResStartTimeHrs: Ext.getCmp('firstResStartTimeHId').getValue(),
			                                firstResStartTimeMnt: Ext.getCmp('firstResStartTimeMId').getValue(),
			                                firstResEndTimeHrs: Ext.getCmp('firstResEndTimeHId').getValue(),
			                                firstResEndTimeMnt: Ext.getCmp('firstResEndTimeMId').getValue(),
			                                secondResStartTimeHrs: Ext.getCmp('secondResStartTimeHId').getValue(),
			                                secondResStartTimeMnt: Ext.getCmp('secondResStartTimeMId').getValue(),
			                                secondResEndTimeHrs: Ext.getCmp('secondResEndTimeHId').getValue(),
			                                secondResEndTimeMnt: Ext.getCmp('secondResEndTimeMId').getValue(),
			                                nonComHrs: Ext.getCmp('nonComHrsId').getValue()
			                            },
			                            success: function(response, options) {
			                                var message = response.responseText;
	                                        Ext.example.msg(message);
	                                        timesStore.load({
		                                      params:{
		                                       ltspSystemId: Ext.getCmp('LTSPcomboId').getValue(),
		                                       custId: Ext.getCmp('custcomboId').getValue()
		                                      },
		                                      callback: function(){
				                                        if(timesStore != null && timesStore.getAt(0) != null){
				                                      	var rec = timesStore.getAt(0);
				                                      	var mta=HrsStore.getAt(Number(rec.data['startHrsInx']));
				                                      	Ext.getCmp('startTimeHId').setValue(mta.data['val']);
				                                      	var mt1=mntsStore.getAt(Number(rec.data['startMntInx']));
				                                      	Ext.getCmp('startTimeMId').setValue(mt1.data['val']);
				                                      	var mtb=HrsStore.getAt(Number(rec.data['endHrsInx']));
				                                      	Ext.getCmp('endTimeHId').setValue(mtb.data['val']);
				                                      	var mt2=mntsStore.getAt(Number(rec.data['endMntInx']));
				                                      	Ext.getCmp('endTimeMId').setValue(mt2.data['val']);
				                                      	var mtc=HrsStore.getAt(Number(rec.data['brStartHrsInx']));
				                                      	Ext.getCmp('brStartTimeHId').setValue(mtc.data['val']);
				                                      	var mt3=mntsStore.getAt(Number(rec.data['brStartMntInx']));
				                                      	Ext.getCmp('brStartTimeMId').setValue(mt3.data['val']);
				                                      	var mtd=HrsStore.getAt(Number(rec.data['brEndHrsInx']));
				                                      	Ext.getCmp('brEndTimeHId').setValue(mtd.data['val']);
				                                      	var mt4=mntsStore.getAt(Number(rec.data['brEndMntInx']));
				                                      	Ext.getCmp('brEndTimeMId').setValue(mt4.data['val']);
				                                      	var mte=HrsStore.getAt(Number(rec.data['firstResStartHrsInx']));
				                                      	Ext.getCmp('firstResStartTimeHId').setValue(mte.data['val']);
				                                      	var mt5=mntsStore.getAt(Number(rec.data['firstResStartMntInx']));
				                                      	Ext.getCmp('firstResStartTimeMId').setValue(mt5.data['val']);
				                                      	var mtf=HrsStore.getAt(Number(rec.data['firstResEndHrsInx']));
				                                      	Ext.getCmp('firstResEndTimeHId').setValue(mtf.data['val']);
				                                      	var mt6=mntsStore.getAt(Number(rec.data['firstResEndMntInx']));
				                                      	Ext.getCmp('firstResEndTimeMId').setValue(mt6.data['val']);
				                                      	var mtg=HrsStore.getAt(Number(rec.data['secondResStartHrsInx']));
				                                      	Ext.getCmp('secondResStartTimeHId').setValue(mtg.data['val']);
				                                      	var mt7=mntsStore.getAt(Number(rec.data['secondResStartMntInx']));
				                                      	Ext.getCmp('secondResStartTimeMId').setValue(mt7.data['val']);
				                                      	var mth=HrsStore.getAt(Number(rec.data['secondResEndHrsInx']));
				                                      	Ext.getCmp('secondResEndTimeHId').setValue(mth.data['val']);
				                                      	var mt8=mntsStore.getAt(Number(rec.data['secondResEndMntInx']));
				                                      	Ext.getCmp('secondResEndTimeMId').setValue(mt8.data['val']);
				                                      	Ext.getCmp('nonComHrsId').setValue(rec.data['nonComHrsInx']);
				                                   }   	
		                                      }
		                                    }); 
			                             }
			                            });        
	                                   innerPanel.getEl().unmask();
	                               }
	                              }
	                            }
				           	   }]
                    });
                    var innerPanel = new Ext.Panel({
                        title: 'Mining Timings',
                        standardSubmit: true,
                        collapsible: false,
                        id: 'innerPanelId',
                        layout: 'table',
                        layoutConfig: {
				           columns: 1
				        }, 
                        frame: true,
                        width: 610,
                        height: 500,
                        items: [innerPanel1,innerPanel2,buttonPanel]
                        });

                    var mainPanel = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'mainPanelId',
                        layout: 'table',
                        frame: false,
                        width: '100%',
                        height: 480,
                        layoutConfig: {
                            columns: 2,
                        },
                        items: [{width: 350},innerPanel]
                    });
                    

                    Ext.onReady(function() {
                    	ctsb = tsb;
                        Ext.QuickTips.init();
                        Ext.form.Field.prototype.msgTarget = 'side';
                        outerPanel = new Ext.Panel({
                            title: '',
                            renderTo: 'content',
                            standardSubmit: true,
                            frame: true,
                            width: screen.width - 38,
                            height: 540,
                            layout: 'table',
                            layoutConfig: {
                                columns: 1
                            },
                            items: [mainPanel]
                        });
                        sb = Ext.getCmp('form-statusbar');
                  });
  </script>
 </body>
</html>