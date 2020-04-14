<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
        <%
        	String path = request.getContextPath();
        	String basePath = request.getScheme() + "://"
        			+ request.getServerName() + ":" + request.getServerPort()
        			+ path + "/";

        	String SelectTaluk = "Select Taluk Name";
        	String TalukName = "Taluk Name";
        	String SelectLTSP = "Select Ltsp Name";
        	String LTSPName = "Ltsp Name";
        	String SelectMDPLimit = "Select MDP Limit";
        	String SelectMDP = "MDP Limit";
        	String SelectClient = "Select Client Name";
        	String CustName = "Customer Name";
        	int customerid;

        %>
<!DOCTYPE HTML>
<html  lang="en">

<head>
		
		<base href="<%=basePath%>">
		<title>SandMiningMDPUserSetting</title>
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
					  id: 'ClientStoreId',
					  root: 'CustomerRoot',
					  autoLoad: false,
					  remoteSort: true,
					  fields: ['CustId', 'CustName'],
                   });
                   var talukcombostore = new Ext.data.JsonStore({
                      url: '<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=getTaluksForLTSP',
					  id: 'TalukStoreId',
					  root: 'TalukRoot',
					  autoLoad: false,
					  remoteSort: true,
					  fields: ['TalukName', 'TalukName'],
                   });
                   var MDPcombostore = new Ext.data.JsonStore({
                      url: '<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=getMDPLimit',
					  id: 'MDPStoreId',
					  root: 'MDPRoot',
					  autoLoad: false,
					  remoteSort: true,
					  fields: ['MDPLimit', 'MDPLimit'],
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
                               Ext.getCmp('ClientcomboId').reset();
                               Ext.getCmp('talukcomboId').reset();
                               Ext.getCmp('mdpLimitId').reset();
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
                       id: 'ClientcomboId',
                       mode: 'local',
                       forceSelection: true,
                       emptyText: '<%=SelectClient%>',
                       blankText: '<%=SelectClient%>',
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
                                Ext.getCmp('talukcomboId').reset();
                                Ext.getCmp('mdpLimitId').reset();
                               	   talukcombostore.load({
	                               	   	params:{
	                               	   	   ltspSystemId: Ext.getCmp('LTSPcomboId').getValue(),
	                               	   	   custId: Ext.getCmp('ClientcomboId').getValue()
	                               	   	}
                                   });
                                }
                           }
                       }
                   });
                   var Taluk = new Ext.form.ComboBox({
                       store: talukcombostore,
                       id: 'talukcomboId',
                       mode: 'local',
                       forceSelection: true,
                       emptyText: '<%=SelectTaluk%>',
                       blankText: '<%=SelectTaluk%>',
                       selectOnFocus: true,
                       allowBlank: false,
                       anyMatch: true,
                       typeAhead: false,
                       triggerAction: 'all',
                       lazyRender: true,
                       valueField: 'TalukName',
                       displayField: 'TalukName',
                       cls: 'selectstylePerfect',
                        maskRe: /[a-zA-Z0-9]/,
                       listeners: {
                           select: {
                               fn: function() {
                               MDPcombostore.load({
	                               	   	params:{
	                               	   	   ltspSystemId: Ext.getCmp('LTSPcomboId').getValue(),
	                               	   	   custId: Ext.getCmp('ClientcomboId').getValue(),
	                               	   	   talukId: Ext.getCmp('talukcomboId').getValue()
	                               	   	},
	                               	   	callback: function(){
	                            Ext.getCmp('mdpLimitId').reset();
								var rec = MDPcombostore.getAt(0);
		                        Ext.getCmp('mdpLimitId').setValue(rec.data['MDPLimit']);
                    	}
                                   });
                               }
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
				               text: '<%=CustName%>' + ' :',
				               cls: 'labelstyle'
				           	   }, Client,
				           	   ]
                        });
          
                    var innerPanel2 = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'innerPanel4Id',
                        layout: 'table',
                        layoutConfig: {
				           columns: 5
				        }, 
                        frame: false,
                        //bodyStyle: 'padding-left: 3px;',
                        width: 590,
                        height: 40,
                        items: [{xtype: 'label',
				               text: '<%=TalukName%>' + ' :',
				               cls: 'labelstyle'
				           	   }, Taluk,{width:61},
                        {
				               xtype: 'label',
				               text: '<%=SelectMDP%>' + ' :',
				               cls: 'labelstyle'
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
										 maxlength : 3, 
										 type: "text", 
										 size: "6", 
										 autocomplete: "off",
									},
									
						            id: 'mdpLimitId',
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
	                                   if (Ext.getCmp('talukcomboId').getValue() == "") {
	                                       Ext.example.msg("<%=SelectTaluk%>");
	                                       Ext.getCmp('talukcomboId').focus();
	                                       return;
	                                   }
	                                   if (Ext.getCmp('mdpLimitId').getValue() == "") {
	                                       Ext.example.msg("<%=SelectMDPLimit%>");
	                                       Ext.getCmp('mdpLimitId').focus();
	                                       return;
	                                   } 
	                                   if (Ext.getCmp('ClientcomboId').getValue() == "") {
	                                       Ext.example.msg("<%=SelectClient%>");
	                                       Ext.getCmp('ClientcomboId').focus();
	                                       return;
	                                   } 
	                                   innerPanel.getEl().mask();
				                        Ext.Ajax.request({
			                            url: '<%=request.getContextPath()%>/SandMDPTimeSettingAction.do?param=saveUserSettings',
			                            method: 'POST',
			                            params: {
			                                ltspSystemId: Ext.getCmp('LTSPcomboId').getValue(),
			                                custId: Ext.getCmp('ClientcomboId').getValue(),
			                                talukId: Ext.getCmp('talukcomboId').getValue(),
			                                MDPLimit: Ext.getCmp('mdpLimitId').getValue()
			                                
			                            },
			                            success: function(response, options) {
			                                var message = response.responseText;
	                                        Ext.example.msg(message);
	                                       
			                             }
			                            });        
	                                   innerPanel.getEl().unmask();
	                               }
	                              }
	                            }
				           	   }]
                    });
                    
                    
                    var innerPanel = new Ext.Panel({
                        title: 'MDP User Settings',
                        standardSubmit: true,
                        collapsible: false,
                        id: 'innerPanelId',
                        layout: 'table',
                        layoutConfig: {
				           columns: 1
				        }, 
                        frame: true,
                        width: 610,
                        //height: 540,
                        items: [innerPanel1,innerPanel2,buttonPanel]
                        });

                    var mainPanel = new Ext.Panel({
                        standardSubmit: true,
                        collapsible: false,
                        id: 'mainPanelId',
                        layout: 'table',
                        frame: false,
                        width: '100%',
                        height: 560,
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
                            height: 600,
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