<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
        <%
        	String path = request.getContextPath();
        	String basePath = request.getScheme() + "://"
        			+ request.getServerName() + ":" + request.getServerPort()
        			+ path + "/";

        	String SelectCustomer = "Select Customer Name";
        	String CustomerName = "Customer Name";
        	String SelectLTSP = "Select Ltsp Name";
        	String LTSPName = "Ltsp Name";
        %>
<!DOCTYPE HTML>
<html  lang="en">

<head>
		
		<base href="<%=basePath%>">
		<title>SandMiningMDPTimeSetting</title>
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

<!-- for lovcombo -->
<pack:style src="../../Main/resources/css/LovCombo/Ext.ux.form.LovCombo.css"></pack:style>
	  	<pack:style src="../../Main/resources/css/LovCombo/empty.css"></pack:style>
	  	<pack:style src="../../Main/resources/css/LovCombo/lovcombo.css"></pack:style>
	  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.form.LovComboSearch.js"></pack:script>
	  	<pack:script src="../../Main/Js/LovCombo/Ext.ux.ThemeCombo.js"></pack:script>

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
				    url: '<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=getMiningTimes',
				    id: 'timesStoreId',
				    autoLoad: false,
				    root: 'timesStoreRoot',
				    remoteStore: true,
				    fields: ['startHrsInx','endHrsInx','brStartHrsInx','startMntInx','endMntInx','brStartMntInx','blockedVehicleInx','nonCommunicatingInx','nonCommunicatingHrsInx','nonCommunicatingMntInx','insideHubInx','quantityMeasureInx','bufferDistanceInx','vehGroupInx','MDPbufferDistanceInx','paymentDaysIndex','paymentHoursIndex','paymentMinutesIndex']
				    });
                   
                   var LTSPStore= new Ext.data.JsonStore({
					   url:'<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=getLTSPS',
					   id:'LTSPSRoreId',
				       root: 'LTSPRoot',
				       autoLoad: true,
				       remoteSort:true,
					   fields: ['ltspId','ltspName']
				     });
                   var clientcombostore = new Ext.data.JsonStore({
                      url: '<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=getCustomersForLTSP',
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
                       maskRe: /[a-zA-Z0-9]/,
                       listeners: {
                           select: {
                               fn: function() {
                               	   Ext.getCmp('startTimeHId').reset();
                               	   Ext.getCmp('startTimeMId').reset();
                               	   Ext.getCmp('endTimeHId').reset();
                               	   Ext.getCmp('endTimeMId').reset();
                               	   Ext.getCmp('brStartTimeHId').reset();
                               	   Ext.getCmp('brStartTimeMId').reset();
                               	   Ext.getCmp('custcomboId').reset();
                               	   Ext.getCmp('blockedVehicleId').reset();
				                   Ext.getCmp('nonCommunicatingId').reset();
				                   Ext.getCmp('nonCommunicatingHId').reset();
				                   Ext.getCmp('nonCommunicatingMId').reset();
				                   Ext.getCmp('insideHubId').reset();
				                   Ext.getCmp('qmId').reset();
				                   
				                   
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
                        maskRe: /[a-zA-Z0-9]/,
                       listeners: {
                           select: {
                               fn: function() {
                               	   Ext.getCmp('startTimeHId').reset();
                               	   Ext.getCmp('startTimeMId').reset();
                               	   Ext.getCmp('endTimeHId').reset();
                               	   Ext.getCmp('endTimeMId').reset();
                               	   Ext.getCmp('brStartTimeHId').reset();
                               	   Ext.getCmp('brStartTimeMId').reset();
                               	   Ext.getCmp('blockedVehicleId').reset();
				                   Ext.getCmp('nonCommunicatingId').reset();
				                   Ext.getCmp('nonCommunicatingHId').reset();
				                   Ext.getCmp('nonCommunicatingMId').reset();
				                   Ext.getCmp('insideHubId').reset();
				                   Ext.getCmp('qmId').reset();
				                   Ext.getCmp('bufferDistanceId').reset();
				                   Ext.getCmp('groupcomboId').reset();
				                   Ext.getCmp('MDPbufferDistanceId').reset();
				                   
				                   StockYardStore.load({
                                      params:{
                                       stockYardSystemId: Ext.getCmp('LTSPcomboId').getValue(),
                                       stockYardClientId: Ext.getCmp('custcomboId').getValue()
                                      }
                                      });
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
		                                      	Ext.getCmp('blockedVehicleId').setValue(rec.data['blockedVehicleInx']);
				                                Ext.getCmp('nonCommunicatingId').setValue(rec.data['nonCommunicatingInx']);
				                                var mtd=HrsStore.getAt(Number(rec.data['nonCommunicatingHrsInx']));
				                                Ext.getCmp('nonCommunicatingHId').setValue(mtd.data['val']);
				                                var mt4=mntsStore.getAt(Number(rec.data['nonCommunicatingMntInx']));
				                                Ext.getCmp('nonCommunicatingMId').setValue(mt4.data['val']);
				                                Ext.getCmp('insideHubId').setValue(rec.data['insideHubInx']);
												Ext.getCmp('qmId').setValue(rec.data['quantityMeasureInx']);
				                                if(rec.data['bufferDistanceInx']!="0"){
				                                Ext.getCmp('bufferDistanceId').setValue(rec.data['bufferDistanceInx']);
				                                }
				                               if(rec.data['vehGroupInx'] !="0"){
				                               Ext.getCmp('groupcomboId').setValue(rec.data['vehGroupInx']);
				                               }
				                               if(rec.data['MDPbufferDistanceInx']!="0"){
				                                Ext.getCmp('MDPbufferDistanceId').setValue(rec.data['MDPbufferDistanceInx']);
				                                }
												
												Ext.getCmp('paymentDaysId').setValue(rec.data['paymentDaysIndex']);
												Ext.getCmp('paymentHoursId').setValue(rec.data['paymentHoursIndex']);
												Ext.getCmp('paymentMinsId').setValue(rec.data['paymentMinutesIndex']);
		                                  }    	
                                      }
                                    });
                                    groupNamestore.load({
                                      params:{
                                       ltspSystemId: Ext.getCmp('LTSPcomboId').getValue(),
                                       custId: Ext.getCmp('custcomboId').getValue()
                                      }
                                      });
                               }
                           }
                       }
                   });
         var groupNamestore = new Ext.data.JsonStore({
                      url: '<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=getGroupName',
					  id: 'GroupStoreId',
					  root: 'GroupNameRoot',
					  autoLoad: false,
					  remoteSort: true,
					  fields: ['groupId', 'groupName'],
                   });
          var groupNameCombo = new Ext.form.ComboBox({
                       store: groupNamestore,
                       id: 'groupcomboId',
                       mode: 'local',
                       forceSelection: true,
                       emptyText: 'Select Group Name',
                       blankText: 'Select Group Name',
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'groupId',
                       displayField: 'groupName',
                       cls: 'selectstylePerfect',
                        maskRe: /[a-zA-Z0-9]/,
                       listeners: {
                           select: {
                               fn: function() {
                               groupId: Ext.getCmp('groupcomboId').getValue()
                               }
                           }
                       }
                   }); 
                   
      /*     var groupNameCombo = new Ext.ux.form.LovCombo({
				store: groupNamestore,
                id: 'groupcomboId',
				mode: 'local',
		        cls: 'selectstylePerfect',
			    forceSelection: true,
			    resizable: true,
			    emptyText: 'Select Group Name',
			    //blankText: '',
			    maxSelections : 10,
			    lazyRender: true,
			    selectOnFocus: true,
			    allowBlank: false,
			    autoload: true,
			    anyMatch: true,
			    typeAhead: false,
			    triggerAction: 'all',
			    valueField: 'groupId',
			    displayField: 'groupName',
			    multiSelect:true,
				beforeBlur: Ext.emptyFn,
		   		listeners: {
		          select:function(record, index) {     
						var newVeh=[];
						newVeh = Ext.getCmp('groupcomboId').getRawValue().trim().split(',');
					}
			     }
			}); */
		/*********************************Main Panel Data**************************************/
		var days = [["00","00"],["01","01"],["02","02"],["03","03"],["4","04"],["05","05"],["06","06"],["07","07"],["08","08"],["09","09"],["10","10"]];	
		
		var Hrs = [["00","00"],["01","01"],["02","02"],["03","03"],["4","04"],["05","05"],["06","06"],["07","07"],["08","08"],["09","09"],["10","10"],["11","11"],["12","12"],["13","13"],["14","14"],["15","15"],["16","16"],["17","17"],["18","18"],["19","19"],["20","20"],["21","21"],["22","22"],["23","23"]];		   
		var nonCommunicationHrs = [["00","00"],["01","01"],["02","02"],["03","03"],["4","04"],["05","05"],["06","06"],["07","07"],["08","08"],["09","09"],["10","10"],["11","11"],["12","12"],["13","13"],["14","14"],["15","15"],["16","16"],["17","17"],["18","18"],["19","19"],["20","20"],["21","21"],["22","22"],["23","23"],['24','24'],['25','25'],['26','26'],['27','27'],['28','28'],['29','29'],['30','30'],['31','31'],['32','32'],['33','33'],['34','34'],['35','35'],['36','36'],['37','37'],['38','38'],['39','39'],['40','40'],['41','41'],['42','42'],['43','43'],['44','44'],['45','45'],['46','46'],['47','47'],['48','48'],['49','49'],['50','50']];
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
				        data: nonCommunicationHrs
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
					
					var paymentDaysStore  = new Ext.data.SimpleStore({
				        id: 'DaysStoreId',
				        autoLoad: false,
				        fields:['val','num'],
				        data: days
				    });
					
					var paymentHrsStore  = new Ext.data.SimpleStore({
				        id: 'HrsStoreId',
				        autoLoad: false,
				        fields:['val','num'],
				        data: Hrs
				    });
					var paymentMntsStore  = new Ext.data.SimpleStore({
				        id: 'mntsStoreId',
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
                        //restricts user to 2 chars max, cannot enter 7th char
            		     autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2,
                       //cls: 'selectstylePerfect',
                       width:60,
                    //   maskRe: /[0-9]/,
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
                         autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2,
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
                          autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2,
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
                          autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2,
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
                          autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2,
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
                          autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2,
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
                   
                   
                       var nonCommunicatingH = new Ext.form.ComboBox({
                       store: HrsStore4,
                       id: 'nonCommunicatingHId',
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
                         autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                   });
                   var nonCommunicatingM = new Ext.form.ComboBox({
                       store: mntsStore4,
                       id: 'nonCommunicatingMId',
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
                        autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2, 
                       listeners: {
                           select: {
                               fn: function() {}
                           }
                       }
                   });
				   
					  var PaymentDays = new Ext.form.ComboBox({
                       store: paymentDaysStore,
                       id: 'paymentDaysId',
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
                        //restricts user to 2 chars max, cannot enter 7th char
            		     autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2,
                       width:60,
					   listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                   });
					
                      var PaymentHours = new Ext.form.ComboBox({
                       store: paymentHrsStore,
                       id: 'paymentHoursId',
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
                        //restricts user to 2 chars max, cannot enter 7th char
            		     autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2,
                       //cls: 'selectstylePerfect',
                       width:60,
                    //   maskRe: /[0-9]/,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                   });
                   var PaymentMins = new Ext.form.ComboBox({
                       store: paymentMntsStore,
                       id: 'paymentMinsId',
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
                         autoCreate :  { //restricts user to 2 chars max, cannot enter 7th char
            		   tag: "input", 
             		   maxlength : 2, 
		               type: "text", 
                       maskRe: /[0-9]/,
                       size: "2", 
                       autocomplete: "off"},
                       maskRe: /[0-9]/,
                       maxlength : 2,
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
                    //    width: 590,
                        height: 90,
                        items: [{width:40},{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'ml1'
				               },{
				               xtype: 'label',
				               text: 'MDP Start Time' + ' :',
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
				               text: 'MDP End Time' + ' :',
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
				                text: '',
				                cls: 'mandatoryfield',
				                id: 'ml3'
				               },{
				               xtype: 'label',
				               text: 'MDP Validity Time' + ' :',
				               cls: 'labelstyle',
				               style: 'padding-right : 45px;'
				           	   },brStartTimeH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle'
				           	   },{height: 30,width:33},brStartTimeM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle'
				           	   },{
				               xtype: 'label',
				               text: '',
				               cls: 'mandatoryfield',
				               id: 'ml4'
				               }
				           	   <!-- ,{},{ -->
				               <!--  xtype: 'label', -->
				                <!--  text: '', -->
				                <!--  cls: 'mandatoryfield', -->
				                <!--  id: 'ml4' -->
				               <!--  }
<!--				               ,{-->
<!--				               xtype: 'label',-->
<!--				               text: 'MDP Valid End Time' + ' :',-->
<!--				               cls: 'labelstyle'-->
<!--				           	   },brEndTimeH,{-->
<!--				               xtype: 'label',-->
<!--				               text: 'Hrs',-->
<!--				               cls: 'labelstyle'-->
<!--				           	   },{height: 30,width:33},brEndTimeM,-->
<!--				           	   {-->
<!--				               xtype: 'label',-->
<!--				               text: 'Min',-->
<!--				               cls: 'labelstyle'-->
<!--				           	   }-->
				           	   ]
                    });
                    
                    
                       var quantityMeasureStore= new Ext.data.SimpleStore({
					   id:'quantityMeasureId',
				       autoLoad: false,
					   fields: ['quantityMeasureId','quantityMeasureName'],
					   data : [
     						   ["1", "Metric Tons"],
					           ["2", "Cubic Meters"]
   						      ]
   						      });
				     
				     var QuantityMeasure = new Ext.form.ComboBox({
    					 fieldLabel: 'Choose Quantity Measure',
					     store: quantityMeasureStore,
					     id : 'qmId',
   					   valueField: 'quantityMeasureName',
                       displayField: 'quantityMeasureName',
                       cls: 'selectstylePerfect',
                        mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                        maskRe: /[a-zA-Z]/,
                 //      width:100,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                       
					});
					
					
					var totalMdpCountStoreType1Vehicle= new Ext.data.SimpleStore({
					   id:'mdpStoreIdType1Vehicle',
				       autoLoad: false,
					   fields: ['mdpId','mdpName'],
					   data : [
     						   ["1", "1"],
					           ["2", "2"],
					           ["3", "3"],
					           ["4", "4"],
					           ["5", "5"],
					           ["6", "6"]
   						      ]
   						      });
							  
					 var totalMDPCountComboType1Vehicle = new Ext.form.ComboBox({
    					 fieldLabel: 'Choose Quantity Measure',
					     store: totalMdpCountStoreType1Vehicle,
					     id : 'mdpComboIdType1Vehicle',
   					   valueField: 'mdpName',
                       displayField: 'mdpName',
                       cls: 'selectstylePerfect',
                        mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                        maskRe: /[a-zA-Z]/,
                 //      width:100,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                       
					});
					var totalMdpCountStoreType2Vehicle= new Ext.data.SimpleStore({
					   id:'mdpStoreIdType2Vehicle',
				       autoLoad: false,
					   fields: ['mdpId','mdpName'],
					   data : [
     						   ["1", "1"],
					           ["2", "2"],
					           ["3", "3"],
					           ["4", "4"],
					           ["5", "5"],
					           ["6", "6"]
   						      ]
   						      });
							  
					var totalMDPCountComboType2Vehicle = new Ext.form.ComboBox({
    					 fieldLabel: 'Choose Quantity Measure',
					     store: totalMdpCountStoreType2Vehicle,
					     id : 'mdpComboIdType2Vehicle',
   					   valueField: 'mdpName',
                       displayField: 'mdpName',
                       cls: 'selectstylePerfect',
                        mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                        maskRe: /[a-zA-Z]/,
                 //      width:100,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                       
					});
					var totalMdpCountStoreType3Vehicle= new Ext.data.SimpleStore({
					   id:'mdpStoreIdType3Vehicle',
				       autoLoad: false,
					   fields: ['mdpId','mdpName'],
					   data : [
     						   ["1", "1"],
					           ["2", "2"],
					           ["3", "3"],
					           ["4", "4"],
					           ["5", "5"],
					           ["6", "6"]
   						      ]
   						      });
				     
				    var totalMDPCountComboType3Vehicle = new Ext.form.ComboBox({
    					 fieldLabel: 'Choose Quantity Measure',
					     store: totalMdpCountStoreType3Vehicle,
					     id : 'mdpComboIdType3Vehicle',
   					   valueField: 'mdpName',
                       displayField: 'mdpName',
                       cls: 'selectstylePerfect',
                        mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                        maskRe: /[a-zA-Z]/,
                 //      width:100,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                       
					});
					
					var totalLoadingCapacityStoreType1Vehicle= new Ext.data.SimpleStore({
					   id:'capacityStoreId',
				       autoLoad: false,
					   fields: ['capacityId','capacityName'],
					   data : [
     						   ["1", "100"],
     						   ["2", "200"],
     						   ["3", "300"],
     						   ["4", "400"],
     						   ["5", "500"],
     						   ["6", "600"],
     						   ["7", "700"],
     						   ["8", "800"],
     						   ["9", "900"],
     						   ["10", "1000"],
     						   ["11", "2000"],
     						   ["12", "3000"],
     						   ["13", "4000"]
   						      ]
   						      });
   						      
   					 var totalLoadingCapacityComboType1Vehicle = new Ext.form.ComboBox({
    					 fieldLabel: 'Choose Capacity Measure',
					     store: totalLoadingCapacityStoreType1Vehicle,
					     id : 'capacityComboIdType1Vehicle',
   					   valueField: 'capacityName',
                       displayField: 'capacityName',
                       cls: 'selectstylePerfect',
                        mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                        maskRe: /[a-zA-Z]/,
                 //      width:100,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                       
					});
   						      
   					var totalLoadingCapacityStoreType2Vehicle= new Ext.data.SimpleStore({
					   id:'capacityStoreId',
				       autoLoad: false,
					   fields: ['capacityId','capacityName'],
					   data : [
     						   ["1", "4001"],
     						   ["2", "5000"],
     						   ["3", "6000"],
     						   ["4", "7000"],
     						   ["5", "8000"],
     						   ["6", "9000"],
     						   ["7", "10000"]
   						      ]
   						      });
   					
   					 var totalLoadingCapacityComboType2Vehicle = new Ext.form.ComboBox({
    					 fieldLabel: 'Choose Capacity Measure',
					     store: totalLoadingCapacityStoreType2Vehicle,
					     id : 'capacityComboIdType2Vehicle',
   					   valueField: 'capacityName',
                       displayField: 'capacityName',
                       cls: 'selectstylePerfect',
                        mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                        maskRe: /[a-zA-Z]/,
                 //      width:100,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                       
					});
   						      	      
				     var totalLoadingCapacityStoreType3Vehicle= new Ext.data.SimpleStore({
					   id:'capacityStoreId',
				       autoLoad: false,
					   fields: ['capacityId','capacityName'],
					   data : [
     						   ["1", "10001"],
     						   ["2", "11000"],
     						   ["3", "12000"],
     						   ["4", "13000"],
     						   ["5", "14000"],
     						   ["6", "15000"],
     						   ["7", "16000"],
     						   ["8", "17000"],
     						   ["9", "18000"],
     						   ["10", "19000"],
     						   ["11", "20000"]
   						      ]
   						      });
   						      
				     var totalLoadingCapacityComboType3Vehicle = new Ext.form.ComboBox({
    					 fieldLabel: 'Choose Capacity Measure',
					     store: totalLoadingCapacityStoreType3Vehicle,
					     id : 'capacityComboIdType3Vehicle',
   					   valueField: 'capacityName',
                       displayField: 'capacityName',
                       cls: 'selectstylePerfect',
                        mode: 'local',
                       forceSelection: true,
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                        maskRe: /[a-zA-Z]/,
                 //      width:100,
                       listeners: {
                           select: {
                               fn: function() {
                               }
                           }
                       }
                       
					});
					
                   var StockYardStore= new Ext.data.JsonStore({
					   url:'<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=getStockYards',
					   id:'StockYardStoreId',
				       root: 'StockYardsRoot',
				       autoLoad: false,
				       remoteSort:true,
					   fields: ['stockYardId','stocksYardName']
				     });
				     
	
	var stockYardsCombo = new Ext.ux.form.LovCombo({
		id:'stockYardsComboId',	
		store: StockYardStore,
		mode: 'local',
        cls: 'selectstylePerfect',
	    forceSelection: true,
	     resizable: true,
	   // emptyText: 'Choose StockYards',
	    //blankText: '',
	    width: 400,
	    maxSelections : 10,
	    lazyRender: true,
	    selectOnFocus: true,
	    allowBlank: false,
	    autoload: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'stockYardId',
	    displayField: 'stocksYardName',
	    multiSelect:true,
		beforeBlur: Ext.emptyFn,
   		listeners: {
          select:function(record, index) {     
				var newStockYards=[];
				newStockYards = Ext.getCmp('stockYardsComboId').getValue().trim().split(',');
				//alert(newStockYards);
			}
	     }
	});
	Ext.override(Ext.ux.form.LovCombo, {
		beforeBlur: Ext.emptyFn
	});
				     
				    
					  var innerPanel3 = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'innerPanel3Id',
                        layout: 'table',
                        bodyStyle: 'padding-left: 40px;',
                        layoutConfig: {
				           columns: 5
				        }, 
                        frame: false,
                        width: 810,
                        height: 200,
                        items: [{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield'
				               },{
				               xtype: 'label',
				               text: 'Quantity Measure' + ' :',
				               cls: 'labelstyle'
				           	   },
				           	   QuantityMeasure,{},
				           	   {
				                xtype: 'label',
				                text: '',
				                cls: 'mandatoryfield'
				               },{
				               xtype: 'label',
				               text: 'UPE Buffer Distance' + ' :',
				               cls: 'labelstyle'
				           	   },{
				                xtype: 'label',
				                text: '',
				                cls: ''
				               },
				           	   {
						            xtype: 'numberfield',
						            cls: 'selectstylePerfect',
						            allowBlank: false,
						            blankText: '0',
						            emptyText: '0',
						            labelSeparator: '',
						            readOnly: false,
						            autoCreate : { 
										 tag: "input", 
										 maxlength : 6, 
										 type: "text", 
										 size: "6", 
										 autocomplete: "off",
									},
						            id: 'bufferDistanceId',
						        },{
						        	xtype: 'label',
				                	text: 'Km',
				                	cls: 'labelstyle'
				                	},
						        {
				                xtype: 'label',
				                text: '',
				                cls: 'mandatoryfield'
				               },{
				               xtype: 'label',
				               text: 'Group Id' + ' :',
				               cls: 'labelstyle'
				           	   }, {width : 45},
				           	   groupNameCombo,{},
				           	   {
				                xtype: 'label',
				                text: '',
				                cls: 'mandatoryfield'
				               },{
				               xtype: 'label',
				               text: 'MDP Buffer Distance' + ' :',
				               cls: 'labelstyle'
				           	   }, {width : 45},
				           	   {
						            xtype: 'numberfield',
						            cls: 'selectstylePerfect',
						            allowBlank: false,
						            blankText: '0',
						            emptyText: '0',
						            labelSeparator: '',
						            readOnly: false,
						            autoCreate : { 
										 tag: "input", 
										 maxlength : 6, 
										 type: "text", 
										 size: "6", 
										 autocomplete: "off",
									},
						            id: 'MDPbufferDistanceId',
						        },{
						        	xtype: 'label',
				                	text: 'Km',
				                	cls: 'labelstyle'
				                },
				                // new changes
				                {
				                xtype: 'label',
				                text: '',
				                cls: ''
				               },{
				               xtype: 'label',
				               text: 'Stock Yards ' + ' :',
				               cls: 'labelstyle'
				           	   }, {width : 45},stockYardsCombo,
									{
						        	xtype: 'label',
				                	text: '',
				                	cls: 'labelstyle'
				                },
								{
				                xtype: 'label',
				                text: '',
				                cls: ''
				               },
				           	   {
				               xtype: 'label',
				               text: 'Total Loading Capacity ' + ' :',
				               cls: 'labelstyle'
				           	   }, {width : 45},totalLoadingCapacityComboType1Vehicle,totalLoadingCapacityComboType2Vehicle,totalLoadingCapacityComboType3Vehicle,
								{
				               xtype: 'label',
				               text: 'Total MDP Count ' + ' :',
				               cls: 'labelstyle'
				           	   }, {width : 45},totalMDPCountComboType1Vehicle,totalMDPCountComboType2Vehicle,totalMDPCountComboType3Vehicle,
									{
						        	xtype: 'label',
				                	text: '',
				                	cls: 'labelstyle'
				                }				           	   ]
                        });
					
					
					 var checkboxPanel1 = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'checkBoxPanel1Id',
                        layout:  {
                        		  type: 'hbox',
       							 align: 'middle'
       							 },
                        frame: false,
                        bodyStyle: 'padding-left: 65px;',
                        width: 590,
                      //  height: 20,
                        items: [{
				                xtype: 'label',
				                text: 'Blocked Vehicles  : ',
				                cls: 'labelstyle'
				                },{width: 12 },{
				                 xtype: 'checkbox',
				                 name: 'blockedVehicles',
				                 id : 'blockedVehicleId',
				                 checked: true,
						         cls: 'checkboxFont',
				                 autoHeight: true,
				                 inputValue: true,
				                 uncheckedValue: false,
				                 disabled  :true
					            }]
					            });
					            
					            
					            
					    var checkboxPanel2 = new Ext.Panel({
                        standardSubmit: true,
                        bodyPadding: 90,
                        collapsible: false,
                        layout:  {
                        		  type: 'hbox',
       							 align: 'middle'
       							 },
                        frame: false,
                        bodyStyle: 'padding-left: 40px;',
                        width: 590,
                        height: 35,
                        items: [{
				                xtype: 'label',
				                text: '',
				                cls: 'mandatoryfield'
				               },{
				                xtype: 'label',
				                text: 'Inside Hub  : ',
				                cls: 'labelstyle'
				                },{width: 12 },{
               					 xtype: 'checkbox',
				                 name: 'insideHub',
				                 id: 'insideHubId',
				                 checked: false,
				                 inputValue: true, 
				                 uncheckedValue: false
					            }]
					            });       
          
					
					    var checkboxPanel3 = new Ext.Panel({
                        standardSubmit: true,
                        bodyPadding: 90,
                        collapsible: false,
                        layout:  {
                        		  type: 'hbox',
       							 align: 'middle'
       							 },
                        frame: false,
                        bodyStyle: 'padding-left: 40px;',
                        width: 590,
                        height: 35,
                        items: [{
				                xtype: 'label',
				                text: '',
				                cls: 'mandatoryfield',
				                id: 'innerpanel4MandlabelId'
				               },{
				                xtype: 'label',
				                text: 'Non Communicating  : ',
				                cls: 'labelstyle'
				                },{width: 12 },{
               					 xtype: 'checkbox',
				                 name: 'checkBoxPanel3',
				                 id: 'nonCommunicatingId',
				                 checked: false,
				                 inputValue: true, 
				                 uncheckedValue: false,
				                  listeners: {
                    check: function () {
                        if (this.checked) {                       
                        Ext.getCmp('innerpanel4MandlabelId').show();
						Ext.getCmp('innerpanel4labelId').show(); 
						Ext.getCmp('innerpanel4HrslabelId').show();
						Ext.getCmp('innerpanel4MinlabelId').show();
						Ext.getCmp('nonCommunicatingHId').show();
						Ext.getCmp('nonCommunicatingMId').show();
						Ext.getCmp('nonCommunicatingHId').reset();
        				 Ext.getCmp('nonCommunicatingMId').reset();
					 }
					 else {       
				
                        Ext.getCmp('innerpanel4MandlabelId').hide();
						Ext.getCmp('innerpanel4labelId').hide(); 
						Ext.getCmp('innerpanel4HrslabelId').hide();
						Ext.getCmp('innerpanel4MinlabelId').hide();
						Ext.getCmp('nonCommunicatingHId').hide();
						Ext.getCmp('nonCommunicatingMId').hide();
					
						Ext.getCmp('nonCommunicatingHId').setValue("00");
        				 Ext.getCmp('nonCommunicatingMId').setValue("00");
                    	}
					  }    
					}
				}]
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
	                                       Ext.example.msg("Select MDP Valid Time Hours");
	                                       Ext.getCmp('brStartTimeHId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('brStartTimeMId').getValue() == "") {
	                                       Ext.example.msg("Select MDP Valid Time Minutes");
	                                       Ext.getCmp('brStartTimeMId').focus();
	                                       return;
	                                   }
	                                  	 if(Ext.getCmp('nonCommunicatingId').getValue() == true){
	                                   
	                                   		if(Ext.getCmp('nonCommunicatingHId').getValue() == ""){
                                               Ext.example.msg("Select Non Communication Hours");
                                               Ext.getCmp('nonCommunicatingHId').focus();
                                               return;
                                               }
	                               	         if(Ext.getCmp('nonCommunicatingMId').getValue() == ""){
	                               	            Ext.example.msg("Select Non Communication Minutes");
	                                            Ext.getCmp('nonCommunicatingMId').focus();
	                                             return;
	                                            }	
	                                           if((Ext.getCmp('nonCommunicatingHId').getValue() == "00")&&(Ext.getCmp('nonCommunicatingMId').getValue() == "00")){
	                               	            Ext.example.msg("Give Non Communication Time");
	                                            Ext.getCmp('nonCommunicatingMId').focus();
	                                             return;
	                                            }                    
	                                    }
	                                    
	                                    if (Ext.getCmp('qmId').getValue() == "") {
	                                       Ext.example.msg("Select Quantity Measure");
	                                       Ext.getCmp('qmId').focus();
	                                       return;
	                                   }
	                                   var groupName=Ext.getCmp('groupcomboId').getValue();
				                       if(isNaN(groupName))
				                       {
				                       		groupName=groupName.trim();
								            
								            var group = groupNamestore.find('groupName', groupName);
		                                    if(group >= 0)
		                                    {
		                                     	var record = groupNamestore.getAt(group);
		                                     	Ext.getCmp('groupcomboId').setValue(record.data['groupId']);
		                                    }
		                                    else
		                                    {
		                                     Ext.getCmp('groupcomboId').setValue('');
		                                    }
				                       }
				                  /*     if (Ext.getCmp('capacityComboId').getValue() == "") {
	                                       Ext.example.msg("Select Total Loading Capacity");
	                                       Ext.getCmp('capacityComboId').focus();
	                                       return;
	                                   }
	                                   
	                                  if (Ext.getCmp('mdpComboId').getValue() == "") {
	                                       Ext.example.msg("Select MDP Measure");
	                                       Ext.getCmp('mdpComboId').focus();
	                                       return;
	                                   }  */
	                                  
	                                   innerPanel.getEl().mask();
									   Ext.Ajax.request({
			                            url: '<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=saveMiningTimes',
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
			                                nonCommunicatingId: Ext.getCmp('nonCommunicatingId').getValue(),
			                                nonCommunicationHrs: Ext.getCmp('nonCommunicatingHId').getValue(),
			                                nonCommunicationMins: Ext.getCmp('nonCommunicatingMId').getValue(),
			                                blockedVehicles: Ext.getCmp('blockedVehicleId').getValue(),
			                                insideHub: Ext.getCmp('insideHubId').getValue(),
			                                quantityMeasureId: Ext.getCmp('qmId').getValue(),
			                                bufferDistance: Ext.getCmp('bufferDistanceId').getValue(),
			                                vehGroup : Ext.getCmp('groupcomboId').getValue(),
			                                MDPbufferDistance: Ext.getCmp('MDPbufferDistanceId').getValue(),
			                                stockYards: Ext.getCmp('stockYardsComboId').getValue(),
			                                totalLoadingCapacityType1Vehicle: Ext.getCmp('capacityComboIdType1Vehicle').getRawValue(),
											totalLoadingCapacityType2Vehicle: Ext.getCmp('capacityComboIdType2Vehicle').getRawValue(),
											totalLoadingCapacityType3Vehicle: Ext.getCmp('capacityComboIdType3Vehicle').getRawValue(),
			                                totalMDPCountType1Vehicle: Ext.getCmp('mdpComboIdType1Vehicle').getRawValue(),
											totalMDPCountType2Vehicle: Ext.getCmp('mdpComboIdType2Vehicle').getRawValue(),
											totalMDPCountType3Vehicle: Ext.getCmp('mdpComboIdType3Vehicle').getRawValue(),
											
											paymentDays:  Ext.getCmp('paymentDaysId').getValue() == "" ? 0 : Ext.getCmp('paymentDaysId').getValue(),
											paymentHours: Ext.getCmp('paymentHoursId').getValue() == "" ? 0 : Ext.getCmp('paymentHoursId').getValue(),
			                                paymentMins:  Ext.getCmp('paymentMinsId').getValue() == "" ? 0 : Ext.getCmp('paymentMinsId').getValue(),			                                
			                                
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
				                                      	
														Ext.getCmp('blockedVehicleId').setValue(rec.data['blockedVehicleInx']);
				                                		Ext.getCmp('nonCommunicatingId').setValue(rec.data['nonCommunicatingInx']);
				                                		var mtd=HrsStore.getAt(Number(rec.data['nonCommunicatingHrsInx']));
				                                		Ext.getCmp('nonCommunicatingHId').setValue(mtd.data['val']);
				                                		var mt4=mntsStore.getAt(Number(rec.data['nonCommunicatingMntInx']));
				                                		Ext.getCmp('nonCommunicatingMId').setValue(mt4.data['val']);
				                                		Ext.getCmp('insideHubId').setValue(rec.data['insideHubInx']);
														Ext.getCmp('qmId').setValue(rec.data['quantityMeasureInx']);	
				                               		    if(rec.data['bufferDistanceInx']!="0"){
				                                			Ext.getCmp('bufferDistanceId').setValue(rec.data['bufferDistanceInx']);
						                                }
						                               if(rec.data['vehGroupInx'] !="0"){
						                               		Ext.getCmp('groupcomboId').setValue(rec.data['vehGroupInx']);
						                               }			  
						                               if(rec.data['MDPbufferDistanceInx']!="0"){
				                                			Ext.getCmp('MDPbufferDistanceId').setValue(rec.data['MDPbufferDistanceInx']);
						                                }                                    	
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
                    
                    var innerPanel4 = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'innerPanel4Id',
                        layout: 'table',
                        layoutConfig: {
				           columns: 8
				        }, 
                        frame: false,
                        bodyStyle: 'padding-left: 40px;',
                        width: 590,
                 //       height: 40,
                        items: [{
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield',
				                id: 'innerpanel4MandlabelId'
				               },{
				               xtype: 'label',
				               text: 'Non Communication Time' + ' :',
				               cls: 'labelstyle',
				               id: 'innerpanel4labelId'
				           	   },nonCommunicatingH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle',
				               id: 'innerpanel4HrslabelId'
				           	   },{height: 30,width:33},nonCommunicatingM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle',
				               id: 'innerpanel4MinlabelId'
				           	   }]
                    });
					
			        var paymentPanel = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'paymentPanelId',
                        layout: 'table',
                        layoutConfig: {
				           columns: 8
				        }, 
                        frame: false,
                        bodyStyle: 'padding-left: 40px;',
                        width: 500,
                 //       height: 40,
                        items: [{
				               xtype: 'label',
				               text: 'Online Payment Link Expiry' + ' :',
				               cls: 'labelstyle',
				               id: 'paymentPanellabelId'
				           	   },PaymentDays,{
				               xtype: 'label',
				               text: 'Days',
				               cls: 'labelstyle',
				               id: 'paymentPanelDayslabelId'
				           	   },PaymentHours,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle',
				               id: 'paymentPanelHrslabelId'
				           	   },{height: 30,width:10},PaymentMins,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle',
				               id: 'paymentPanelMinlabelId'
				           	   }]
                    });		
                    
                    
                    var notePanel = new Ext.Panel({
					    standardSubmit: true,
					    frame:false,
					    hidden:false,
					    id:'noteId',
					    layout:'table',
					    height : 65,
					    width:600,
						layoutConfig: {
							columns:2
						},
					    items: [{ html: "<td><font size='2'><td><font size='2',font color='black'>Note : MDP validity time should be set to max validity destination reach time.<br> UPE Buffer Distance - is the vehicle buffer distance for UPE alert report <br> Group ID -is for vehicles which are under selected group will be skipped in UPE report <br> MDP Buffer Distance - is for distance of vehicle from associated hub </font></td> "}]
		 			}); // END OF notePanel
                    var innerPanel = new Ext.Panel({
                        title: 'MDP Timings',
                        standardSubmit: true,
                        collapsible: false,
                        id: 'innerPanelId',
                        layout: 'table',
                        layoutConfig: {
				           columns: 1
				        }, 
                        frame: true,
                        width: 850,
                        height: 650,
                        items: [innerPanel1,innerPanel2,checkboxPanel1,checkboxPanel3,innerPanel4,checkboxPanel2,innerPanel3,paymentPanel,notePanel,buttonPanel]
                        });

                    var mainPanel = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'mainPanelId',
                        layout: 'table',
                        frame: false,
                        width: '100%',
                        height: 650,
                        layoutConfig: {
                            columns: 2,
                        },
                        items: [{width: 200},innerPanel]
                    });
                    

                    Ext.onReady(function() {
                    	ctsb = tsb;
                        Ext.QuickTips.init();
                        Ext.form.Field.prototype.msgTarget = 'side';
                        Ext.getCmp('innerpanel4MandlabelId').hide();
						Ext.getCmp('innerpanel4labelId').hide(); 
						Ext.getCmp('innerpanel4HrslabelId').hide();
						Ext.getCmp('innerpanel4MinlabelId').hide();
						Ext.getCmp('nonCommunicatingHId').hide();
						Ext.getCmp('nonCommunicatingMId').hide();
						Ext.getCmp('nonCommunicatingHId').setValue("00");
						Ext.getCmp('nonCommunicatingMId').setValue("00");
                        outerPanel = new Ext.Panel({
                            title: '',
                            renderTo: 'content',
                            standardSubmit: true,
                            frame: true,
                            width: screen.width-10,
                            height: 700,
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