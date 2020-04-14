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
		<title>Sand Boat Hub Buffer Setting</title>
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
 
 var emailregex =  /^(\w+)([\-+.\'][\w]+)*@(\w[\-\w]*\.){1,5}([A-Za-z]){2,6}$/;
 
                   var getStore = new Ext.data.JsonStore({
				    url: '<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=getBoatHubBufferData',
				    id: 'getStoreId',
				    autoLoad: false,
				    root: 'getStoreRoot',
				    remoteStore: true,
				    fields: ['bufferDistanceInx','startHrsInx','startMntInx']
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
                   
                   var Hrs = [["00","00"],["01","01"],["02","02"],["03","03"],["4","04"],["05","05"],["06","06"],["07","07"],["08","08"],["09","09"],["10","10"],["11","11"],["12","12"],["13","13"],["14","14"],["15","15"],["16","16"],["17","17"],["18","18"],["19","19"],["20","20"],["21","21"],["22","22"],["23","23"]];		   
				   var mnts = [['00','00'],['01','01'],['02','02'],['03','03'],['04','04'],['05','05'],['06','06'],['07','07'],['08','08'],['09','09'],['10','10'],['11','11'],['12','12'],['13','13'],['14','14'],['15','15'],['16','16'],['17','17'],['18','18'],['19','19'],['20','20'],['21','21'],['22','22'],['23','23'],['24','24'],['25','25'],['26','26'],['27','27'],['28','28'],['29','29'],['30','30'],['31','31'],['32','32'],['33','33'],['34','34'],['35','35'],['36','36'],['37','37'],['38','38'],['39','39'],['40','40'],['41','41'],['42','42'],['43','43'],['44','44'],['45','45'],['46','46'],['47','47'],['48','48'],['49','49'],['50','50'],['51','51'],['52','52'],['53','53'],['54','54'],['55','55'],['56','56'],['57','57'],['58','58'],['59','59']];

				   var HrsStore  = new Ext.data.SimpleStore({
				        id: 'HrsStoreId',
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
                               	   Ext.getCmp('bufferDistanceId').reset();
				                   //Ext.getCmp('emailAddressTextId').reset();
				                   Ext.getCmp('startTimeHId').reset();
				                   Ext.getCmp('startTimeMId').reset();
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
                               	   Ext.getCmp('bufferDistanceId').reset();
				                   
				                   getStore.load({
                                      params:{
                                       ltspSystemId: Ext.getCmp('LTSPcomboId').getValue(),
                                       custId: Ext.getCmp('custcomboId').getValue()
                                      },
                                      callback: function(){
		                                        if(getStore != null && getStore.getAt(0) != null){
		                                      	var rec = getStore.getAt(0);
		                                      	
				                                if(rec.data['bufferDistanceInx']!="0"){
				                                Ext.getCmp('bufferDistanceId').setValue(rec.data['bufferDistanceInx']);
				                                }
				                               // Ext.getCmp('emailAddressTextId').setValue(rec.data['emailList']);
				                                var mta=HrsStore.getAt(Number(rec.data['startHrsInx']));
		                                      	Ext.getCmp('startTimeHId').setValue(mta.data['val']);
		                                      	var mt1=mntsStore.getAt(Number(rec.data['startMntInx']));
		                                      	Ext.getCmp('startTimeMId').setValue(mt1.data['val']);
		                                  }    	
                                      } 
                                    });
                                   
                               }
                           }
                       }
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
                        id: 'innerPanel3Id',
                        layout: 'table',
                        bodyStyle: 'padding-left: 40px;',
                        layoutConfig: {
				           columns: 5
				        }, 
                        frame: false,
                        width: 590,
                        height: 100,
                        items: [
                        {height:50},{},{},{},{},
				           	   {
				                xtype: 'label',
				                text: '*',
				                cls: 'mandatoryfield'
				               },{
				               xtype: 'label',
				               text: 'Buffer Distance' + ' :',
				               cls: 'labelstyle'
				           	   }, {width : 30},
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
				                	}
				  /*              {
					                xtype: 'label',
					                text: '*',
					                cls: 'mandatoryfield'
				               },{
					               xtype: 'label',
					               text: 'Emial Address' + ' :',
					               cls: 'labelstyle'
				           	   }, {width : 45},{
						            xtype: 'textarea',
						            //cls: 'selectstylePerfect',
						            id: 'emailAddressTextId',
						            width: 200,
						            height: 60,
						            emptyText: 'Enter Email Address'
						        },{} */
				           	   ]
                        });
	            
	            var innerPanel3 = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'innerPanel2Id',
                        layout: 'table',
                        layoutConfig: {
				           columns: 9
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
				               text: 'Detention Time' + ' :',
				               cls: 'labelstyle'
				           	   },{width : 30},startTimeH,{
				               xtype: 'label',
				               text: 'Hrs',
				               cls: 'labelstyle'
				           	   },{height: 30,width:33},startTimeM,
				           	   {
				               xtype: 'label',
				               text: 'Min',
				               cls: 'labelstyle'
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
                        height: 40,
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
	                                  if (Ext.getCmp('bufferDistanceId').getValue() == "") {
	                                       Ext.example.msg("Enter Buffer Distance");
	                                       Ext.getCmp('bufferDistanceId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('startTimeHId').getValue() == "") {
	                                       Ext.example.msg("Select Detention Hours");
	                                       Ext.getCmp('startTimeHId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('startTimeMId').getValue() == "") {
	                                       Ext.example.msg("Select Detention Minutes");
	                                       Ext.getCmp('startTimeMId').focus();
	                                       return;
	                                   } 
	                                   
	                                 /*  else{
	                                   		var emailList = Ext.getCmp('emailAddressTextId').getValue();
											var emailarray = emailList.split(",");
											for(var i=0;i<emailarray.length;i++){
												trueOrFalse = emailregex.test(emailarray[i]);
												if(!emailregex.test(emailarray[i])){
												Ext.example.msg("Enter valid email : " +emailarray[i]);
					                            Ext.getCmp('emailAddressTextId').focus();
					                            return;
												}
											}
	                                   } */
	                                  
	                                   innerPanel.getEl().mask();
				                        Ext.Ajax.request({
			                            url: '<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=saveBoatHubBufferSettings',
			                            method: 'POST',
			                            params: {
			                                ltspSystemId: Ext.getCmp('LTSPcomboId').getValue(),
			                                custId: Ext.getCmp('custcomboId').getValue(),
			                                bufferDistance: Ext.getCmp('bufferDistanceId').getValue(),
			                                detentionHrs: Ext.getCmp('startTimeHId').getValue(),
			                                detentionMnt: Ext.getCmp('startTimeMId').getValue()
			                               // emailList: Ext.getCmp('emailAddressTextId').getValue()
			                                
			                            },
			                            success: function(response, options) {
			                                var message = response.responseText;
	                                        Ext.example.msg(message);
	                                        getStore.load({
		                                      params:{
		                                       ltspSystemId: Ext.getCmp('LTSPcomboId').getValue(),
		                                       custId: Ext.getCmp('custcomboId').getValue()
		                                      },
		                                      callback: function(){
				                                        if(getStore != null && getStore.getAt(0) != null){
				                                      	var rec = getStore.getAt(0);	
				                               		    if(rec.data['bufferDistanceInx']!="0"){
				                                			Ext.getCmp('bufferDistanceId').setValue(rec.data['bufferDistanceInx']);
						                                }
						                                //Ext.getCmp('emailAddressTextId').setValue(rec.data['detentionTime']);
						                                var mta=HrsStore.getAt(Number(rec.data['startHrsInx']));
				                                      	Ext.getCmp('startTimeHId').setValue(mta.data['val']);
				                                      	var mt1=mntsStore.getAt(Number(rec.data['startMntInx']));
				                                      	Ext.getCmp('startTimeMId').setValue(mt1.data['val']);
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
                        title: 'Sand Boat Hub Buffer Distance Setting',
                        standardSubmit: true,
                        collapsible: false,
                        id: 'innerPanelId',
                        layout: 'table',
                        layoutConfig: {
				           columns: 1
				        }, 
                        frame: true,
                        width: 610,
                        height: 340,
                        items: [innerPanel1,innerPanel2,innerPanel3,buttonPanel]
                        });

                    var mainPanel = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'mainPanelId',
                        layout: 'table',
                        frame: false,
                        width: '100%',
                        height: 360,
                        layoutConfig: {
                            columns: 2,
                        },
                        items: [{width: 400},innerPanel]
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
                            width: screen.width-10,
                            height: 400,
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