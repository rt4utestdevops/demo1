<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
    <%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
        <%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";

String SelectCustomer="Select Customer"; 
String CustomerName="Customer Name";
String SelectLTSP="Select Ltsp Name";
String LTSPName="Ltsp Name";
String NoRecordsFound = "No Record Found";
String ClearFilterData = "Clear Filter Data";
String Add = "Add";
String SLNO = "SLNO";
String AddDetails = "Add Subscription Payment Details";
String Save = "Save";
String Cancel = "Cancel";

%>
<!DOCTYPE HTML>
<head>
		
		<base href="<%=basePath%>">
		<title>LTSP Subscription Payment</title>
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

	var outerPanel;
	var ctsb;
	var exportDataType = "int,String,string,string,string,string,string,numeric,numeric,numeric,string,string,numeric";
	var jspName ="LTSP Subscription Payment Setting";	
	var buttonValue;
	var unitResponseImportData;
	var start_time ;
	var titelForInnerPanel;
	var curdate=datecur;

	function isValid(amount) {
		var result = false;
    	var patternWholeNo = new RegExp('^[0-9]+$');
		var patternDecimal = new RegExp(/^\d+\.\d{0,2}$/);
		result = (patternWholeNo.test(amount) || patternDecimal.test(amount));
    	return result;
	}
 var ltspNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=getLTSPNames',
        id: 'ltspNameStoreId',
        root: 'ltspNameList',
        autoLoad: true,
        remoteSort: true,
        fields: ['Systemid', 'SystemName','paymentMode']
    });
	
	 var selectLtspDropDown = new Ext.form.ComboBox({
        store: ltspNameStore,
        displayField: 'SystemName',
        valueField: 'Systemid',
        typeAhead: false,
        id: 'selectLtspDropDownID',
        cls: 'selectstylePerfect',
        mode: 'local',
        width: 180,
        triggerAction: 'all',
        emptyText: 'Select LTSP',
        selectOnFocus: true,
        listeners: {
            select: {
                fn: function () {
				
					var pagesystemId = Ext.getCmp('selectLtspDropDownID').getValue();                    
                    clientNameStore.reload({
                        params: {
                            systemid: pagesystemId
                        }
                    });
                    DistrictStore.reload({
                        params: {
                            globalltsp: pagesystemId
                        }
                    });
                    Ext.getCmp('clientId').reset();
            		Ext.getCmp('districtId').reset();
                    Ext.getCmp('workOrderId').reset();
                    Ext.getCmp('startDateId').reset();
                    Ext.getCmp('endDateId').reset();
                    Ext.getCmp('subscriptionId').reset();
                    Ext.getCmp('amountTextId').reset();
                    Ext.getCmp('totalAmountTextId').reset();
                    Ext.getCmp('moperAmountTextId').reset();
					
					var row = ltspNameStore.find('Systemid',pagesystemId);
	                var rec = ltspNameStore.getAt(row);
	                
					 try{ if(rec.data['paymentMode'] == "Y"){
						  Ext.getCmp('radioOverride').hide();
						  Ext.getCmp('overradiolabelid').hide();
						}else{
						  Ext.getCmp('radioOverride').show();
						  Ext.getCmp('overradiolabelid').show();
						}
					}catch(err){
						 Ext.getCmp('radioOverride').disable();
						  Ext.getCmp('overradiolabelid').disable();
					}		
					  
                }
            }
        }
    });
	
	 var clientNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=getClientNameswrtSystem',
        root: 'clientNameList',
        autoLoad: false,
        fields: ['clientid', 'clientname']
    });

    var clientNameSelect = new Ext.form.ComboBox({
        fieldLabel: '',
        standardSubmit: true,
        width: 180,
        selectOnFocus: true,
        cls: 'selectstylePerfect',
        forceSelection: true,
        anyMatch: true,
        OnTypeAhead: true,
        store: clientNameStore,
        displayField: 'clientname',
        valueField: 'clientid',
        mode: 'local',
        emptyText: 'Select Client',
        triggerAction: 'all',
        labelSeparator: '',
        id: 'clientId',
        value: "",
        minChars: 2,
        listeners: {
            select: {
                fn: function () {
                  Ext.getCmp('districtId').reset();
                    Ext.getCmp('workOrderId').reset();
                    Ext.getCmp('startDateId').reset();
                    Ext.getCmp('endDateId').reset();
                    Ext.getCmp('subscriptionId').reset();
                    Ext.getCmp('amountTextId').reset();
                    Ext.getCmp('totalAmountTextId').reset();
                    Ext.getCmp('moperAmountTextId').reset();
                } // END OF FUNCTION
            } // END OF SELECT
        } // END OF LISTENERS		
    });
    
    var DistrictStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=getDistrictNames',
				   id:'districtStoreId',
			       root: 'districtListNew',
			       autoLoad: false,
			       remoteSort:true,
				   fields: ['districtid','districtname']
			     })	
    
    var districtName = new Ext.form.ComboBox({
        fieldLabel: '',
        standardSubmit: true,
        width: 180,
        selectOnFocus: true,
        cls: 'selectstylePerfect',
        forceSelection: true,
        anyMatch: true,
        OnTypeAhead: true,
        store: DistrictStore,
        displayField: 'districtname',
        valueField: 'districtid',
        mode: 'local',
        emptyText: 'Select District',
        triggerAction: 'all',
        labelSeparator: '',
        id: 'districtId',
        value: "",
        minChars: 2,
        listeners: {
            select: {
                fn: function () {
                   Ext.getCmp('workOrderId').reset();
                    Ext.getCmp('startDateId').reset();
                    Ext.getCmp('endDateId').reset();
                    Ext.getCmp('subscriptionId').reset();
                    Ext.getCmp('amountTextId').reset();
                    Ext.getCmp('totalAmountTextId').reset();
                    Ext.getCmp('moperAmountTextId').reset(); 
                } // END OF FUNCTION
            } // END OF SELECT
        } // END OF LISTENERS		
    });


	var subscriptionStore = new Ext.data.SimpleStore({
	    id: 'subscriptionStoreId',
	    autoLoad: true,
	    fields: ['durationNo'],
	    data: [['1'],['2'],['3'],['4'],['5'],['6'],['7'],['8'],['9'],['10'],['11'],['12']]
});
	
	var subscriptionCombo = new Ext.form.ComboBox({
        fieldLabel: '',
        standardSubmit: true,
        width: 180,
        cls: 'selectstylePerfect',
        selectOnFocus: true,
        forceSelection: true,
        anyMatch: true,
        OnTypeAhead: true,
        store: subscriptionStore,
        displayField: 'durationNo',
        valueField: 'durationNo',
        mode: 'local',
        emptyText: 'Select Duration',
        triggerAction: 'all',
        labelSeparator: '',
        id: 'subscriptionId',
        value: "",
        minChars: 2,
        listeners: {
            select: {
                fn: function () {
                    Ext.getCmp('amountTextId').reset();
                    Ext.getCmp('totalAmountTextId').reset();
                    Ext.getCmp('moperAmountTextId').reset();
                } // END OF FUNCTION
            } // END OF SELECT
        } // END OF LISTENERS		
    });
    
    
  var innerPanelForUnitDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true, 
    width: screen.width - 12,
    height:40,
    frame: false,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 10
    },
     items: [
            {width:40},
            {	
            	xtype:'button',
				text: 'Refresh',
				width:70,
				listeners: {
				click: {fn:function(){
				
                store.load({
                params: {
                    jspName: jspName
                }
            });
                       	   
        			   }
        			}
        		}
        	}
        ]
});  

var innerPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: false,
    height: 390,
    width: 450,
    frame: true,
    id: 'innerPanelId',
    layout: 'table',
    layoutConfig: {
        columns: 5
    },
    items: [{
        xtype: 'fieldset',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'sandBlockDetailsId',       
        height: 400,
        width: 440,
        layout: 'table',
        layoutConfig: {
            columns: 5
        },
        items: [{height : 20},{
            	xtype: 'label',
            	text: '*',
            	cls: 'mandatoryfield',
            	id: 'mandId1'
        	},{
                xtype: 'label',
                text: 'Select LTSP :',
                cls: 'labelstyle',
                id: 'UnitNoid'
            },  selectLtspDropDown,{},
            {height : 30},{
            	xtype: 'label',
            	text: '*',
            	cls: 'mandatoryfield',
            	id: 'mandId2'
        	},{
                xtype: 'label',
                text: 'Select Client :',
                cls: 'labelstyle',
                id: 'labelclintId'
            },	clientNameSelect,{},
            {height : 30},{
            	xtype: 'label',
            	text: '',
            	cls: 'mandatoryfield',
            	id: 'mandId3'
        	},{
                xtype: 'label',
                text: 'Select District :',
                cls: 'labelstyle',
                id: 'labeldistrictId'
            },	districtName,{},
            {height : 30},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandId4'
        }, {
            xtype: 'label',
            text: 'Work Order Issued By' + ' :',
            cls: 'labelstyle',
            id: 'workLabelid'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Work Order Issued By',
            emptyText: 'Enter Work Order Issued By',
            labelSeparator: '',
            id: 'workOrderId'
        },{}, {height : 30}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandId5'
        }, {
            xtype: 'label',
            text: 'Validity Start Date' + ' :',
            cls: 'labelstyle',
            id: 'startlabelid'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            allowBlank: false,
            //value:curdate,
            //maxValue: curdate, 
            editable: false,
            emptyText: 'Enter Start Date',
            emptyText: 'Enter Start Date',
            id: 'startDateId'
        },{}, {height : 30}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandId6'
        }, {
            xtype: 'label',
            text: 'Validity End Date' + ':',
            cls: 'labelstyle',
            id: 'endlabelid'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            allowBlank: false,
            //value:curdate,
            //minValue: curdate, 
            editable: false,
            emptyText: 'Enter End Date',
            emptyText: 'Enter End Date',
            id: 'endDateId'
        }, {},{height : 30}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandId7'
        }, {
            xtype: 'label',
            text: 'Subscription Duration' + ' :',
            cls: 'labelstyle',
            id: 'subscriptionLabId2'
        }, subscriptionCombo, 
        {
        	xtype: 'label',
        	text: ' (Months)',
        	cls: 'labelstyle'
        },
        {height : 30},  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandId8'
        }, {
            xtype: 'label',
            text: 'Total Amount' + ' :',
            cls: 'labelstyle',
            id: 'amountLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            allowNegative:false,
            blankText: 'Enter Amount',
            emptyText: 'Enter Amount',
            labelSeparator: '',
            regex : /^[0-9]+$/,
            id: 'totalAmountTextId',
            listeners: {
		          'change':function(){
		                var r=0;
						var total=Ext.getCmp('totalAmountTextId').getValue();
						var subscription = Ext.getCmp('subscriptionId').getValue();
						var amt = parseFloat(total) / parseFloat(subscription);
						Ext.getCmp('amountTextId').setValue(amt);
						}
					}
        }, {},{height : 30}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandId9'
        }, {
            xtype: 'label',
            text: 'Amount Per Month' + ' :',
            cls: 'labelstyle',
            id: 'totalAmountLabelId2'
        }, {
	         xtype: 'numberfield',
	         cls: 'selectstylePerfect',
	         allowBlank: false,
	         allowNegative:false,
	         readOnly: true,
	         labelSeparator: '',
	         id: 'amountTextId'
   		},{},{height : 30}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandId10'
        }, {
            xtype: 'label',
            text: 'LTSP Share Per Month' + ' :',
            cls: 'labelstyle',
            id: 'MoperAmountLabelId2'
        }, {
	         xtype: 'numberfield',
	         cls: 'selectstylePerfect',
	         allowBlank: false,
	         allowNegative:false,
	         labelSeparator: '',
	         id: 'moperAmountTextId'
   		},{},{},{height : 30},{
                xtype: 'radio',
                id: 'radioRegister',
                checked: true,
                name: 'radioRegister',
                listeners: {
                    check: function () {
                        if (this.checked) {  
                            if(radioRegister.checked){
                              Ext.getCmp('radioOverride').setValue(false);
                            }
                           
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: 'Register',
                cls: 'labelstyle',
                id:'RegradiolabelId'
            },{},{},{},{
                xtype: 'radio',
                id: 'radioOverride',
                checked: false, 
                name: 'radioOverride',
                listeners: {
                    check: function () {
                        if (this.checked) {                       
                        if(radioRegister.checked){                                         
                         Ext.getCmp('radioRegister').setValue(false);
                            } 
                        }
                    }
                }
            }, {
                xtype: 'label',
                text: 'Override',
                cls: 'labelstyle',
                id : 'overradiolabelid'
            }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 30,
    width: 450,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls:'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                
	                var radioCheck ='Register'; 
	                   
	                if(Ext.getCmp('radioOverride').getValue()==true){
	                    radioCheck='Override'
                   	}
                   		
                	if (Ext.getCmp('selectLtspDropDownID').getValue() == "") {
                        Ext.example.msg("Select LTSP");
                        Ext.getCmp('selectLtspDropDownID').focus();
                        return;
                    }
                    if (Ext.getCmp('clientId').getValue() == "") {
                        Ext.example.msg("Select Client");
                        Ext.getCmp('clientId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('workOrderId').getValue() == "") {
                        Ext.example.msg("Enter Work Order Issued By");
                        Ext.getCmp('workOrderId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('startDateId').getValue() == "") {
                        Ext.example.msg("Select Start Date");
                        Ext.getCmp('startDateId').focus();
                        return;
                    }
                    if (Ext.getCmp('endDateId').getValue() == "") {
                        Ext.example.msg("Select End Date");
                        Ext.getCmp('endDateId').focus();
                        return;
                    }
                    var sdate = Ext.getCmp('startDateId').getValue();
                    var edate = Ext.getCmp('endDateId').getValue();
                    if(sdate > edate){
                    	Ext.example.msg("End Date Must Be Greater Than Start Date");
                    	return;
                    }

                    if (Ext.getCmp('subscriptionId').getValue() == "") {
                        Ext.example.msg("Select Subscription Duration");
                        Ext.getCmp('subscriptionId').focus();
                        return;
                    }
                    if (Ext.getCmp('amountTextId').getValue() == "") {
                        Ext.example.msg("Enter Amount Per Month");
                        Ext.getCmp('amountTextId').focus();
                        return;
                    }
                    var amountId = Ext.getCmp('amountTextId').getValue();
                    if(!isValid(amountId)){
        				Ext.example.msg("Enter Valid Amount ");
     					return;
    				}
                    
                    if (Ext.getCmp('totalAmountTextId').getValue() == "") {
                         Ext.example.msg("Enter Total Amount");
                         Ext.getCmp('totalAmountTextId').focus();
                        return;
                    }
                    if (Ext.getCmp('moperAmountTextId').getValue() == "") {
                         Ext.example.msg("Enter Moper Amount");
                         Ext.getCmp('moperAmountTextId').focus();
                        return;
                    }
                    var MoperAmt=Ext.getCmp('moperAmountTextId').getValue();
	                    if(MoperAmt>=amountId){
	                         Ext.example.msg(" LTSP Share per Month should be less than Amount per Month ");
	                         Ext.getCmp('moperAmountTextId').focus();
	                        return;
	                    }
						
					 
           		     OuterPanelWindow.getEl().mask();
                     Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=addSubscriptionPaymentDetails',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            globalltsp:Ext.getCmp('selectLtspDropDownID').getValue(),
                            custId: Ext.getCmp('clientId').getValue(),
                            districtName: Ext.getCmp('districtId').getValue(),
                            workOrder: Ext.getCmp('workOrderId').getValue(),
                            startDate: Ext.getCmp('startDateId').getValue(),
                            endDate: Ext.getCmp('endDateId').getValue(),
                            subscription: Ext.getCmp('subscriptionId').getValue(),
                            amount: Ext.getCmp('amountTextId').getValue(),
                            totalAmount: Ext.getCmp('totalAmountTextId').getValue(),
                            MoperAmount:  Ext.getCmp('moperAmountTextId').getValue(),
                            radioCheck:radioCheck
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('selectLtspDropDownID').reset();
			                Ext.getCmp('clientId').reset();
			                Ext.getCmp('districtId').reset();
                            Ext.getCmp('workOrderId').reset();
                            Ext.getCmp('startDateId').reset();
                            Ext.getCmp('endDateId').reset();
                            Ext.getCmp('subscriptionId').reset();
                            Ext.getCmp('amountTextId').reset();
                            Ext.getCmp('totalAmountTextId').reset();
                            Ext.getCmp('moperAmountTextId').reset();
                            myWin.hide();
                            OuterPanelWindow.getEl().unmask();
                            store.load();
                            
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            myWin.hide();
                        }
                    });  
                    //  }
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
			                Ext.getCmp('selectLtspDropDownID').reset();
			                Ext.getCmp('clientId').reset();
			                Ext.getCmp('districtId').reset();
                            Ext.getCmp('workOrderId').reset();
                            Ext.getCmp('startDateId').reset();
                            Ext.getCmp('endDateId').reset();
                            Ext.getCmp('subscriptionId').reset();
                            Ext.getCmp('amountTextId').reset();
                            Ext.getCmp('totalAmountTextId').reset();
                            Ext.getCmp('moperAmountTextId').reset();
                    myWin.hide();
                }
            }
        }
    }]
});

var OuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 520,
    standardSubmit: true,
    frame: false,
    items: [innerPanel,innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    width: 460,
     height: 520,
    id: 'myWin',
    items: [OuterPanelWindow]
});

function addRecord() {
	
      buttonValue="Add";
      titelForInnerPanel = '<%=AddDetails%>';
      myWin.setPosition(500, 80);
      myWin.setTitle(titelForInnerPanel);
      myWin.show();
}

 var reader = new Ext.data.JsonReader({
    idProperty: 'sandBlockid',
    root: 'subscriptionPaymentroot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'ltspNameindex'
    }, {
        name: 'clientindex'
    }, {
        name: 'districtindex'
    }, {
        name: 'workOrderindex'
    }, {
        name: 'startDateindex'
    }, {
        name: 'endDateindex' 
    }, {
        name: 'subscriptionindex'
    },{
        name: 'amountPerMonthindex'
    }, {
        name: 'totalAmountindex'
    }, {
        name: 'insertedDateindex'
    }, {
        name: 'SubscriptionStatusindex'
    }, {
        name: 'LTSPShareindex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/LTSP_Subscription_Payment_Action.do?param=getSubscriptionPaymentDetails',
        method: 'POST'
    }),
    storeId: 'sandId',
    reader: reader
});   
    
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'ltspNameindex'
    }, {
        type: 'string',
        dataIndex: 'clientindex'
    }, {
        type: 'string',
        dataIndex: 'districtindex'
    }, {
        type: 'string',
        dataIndex: 'workOrderindex'
    }, {
        type: 'string',
        dataIndex: 'startDateindex'
    }, {
        type: 'string',
        dataIndex: 'endDateindex'
    }, {
        type: 'numeric',
        dataIndex: 'subscriptionindex'
    }, {
        type: 'numeric',
        dataIndex: 'amountPerMonthindex'
    }, {
        type: 'numeric',
        dataIndex: 'totalAmountindex'
    }, {
        type: 'string',
        dataIndex: 'insertedDateindex'
    },{
        type: 'string',
        dataIndex: 'SubscriptionStatusindex'
    }, {
        type: 'numeric',
        dataIndex: 'LTSPShareindex'
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
        },{
            dataIndex: 'ltspNameindex',
            header: "<span style=font-weight:bold;>LTSP Name</span>",
           filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'clientindex',
            header: "<span style=font-weight:bold;>Client Name</span>",
           filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'districtindex',
            header: "<span style=font-weight:bold;>District Name</span>",
           filter: {
                type: 'string'
            }
        }, {
            dataIndex: 'workOrderindex',
            header: "<span style=font-weight:bold;>Work Order Issued</span>",
           filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Validity Start Date</span>",
            dataIndex: 'startDateindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Validity End Date</span>",
            dataIndex: 'endDateindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Subscription Duration (Months)</span>",
            dataIndex: 'subscriptionindex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Amount Per Month</span>",
            dataIndex: 'amountPerMonthindex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        },  {
            header: "<span style=font-weight:bold;>Total Amount</span>",
            dataIndex: 'totalAmountindex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        },  {
            header: "<span style=font-weight:bold;>LTSP Share Amount</span>",
            dataIndex: 'LTSPShareindex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Inserted Date</span>",
            dataIndex: 'insertedDateindex',
            width: 100,
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
    
//*****************************************************************Grid *******************************************************************************
var grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 60, 420, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', false, 'Modify', false, '');    
    
 var importPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: true,
    layout: 'column',
    //width: screen.width - 50,
    height:500,
    layoutConfig: {
        columns: 1
    },
    items: [innerPanelForUnitDetails,grid]
});   
 Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 720000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'LTSP Subscription Payment Setting',
        renderTo: 'content',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        width : screen.width-50,
        layout: 'table',
        height:550,
        cls: 'outerpanel',
        items: [importPanelWindow]      
    });
    store.load({
                params: {
                    jspName: jspName
                }
            });
});   
</script>   
</body>
</html>