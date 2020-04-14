<%@ page language="java"
	import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
	CommonFunctions cf = new CommonFunctions();
	SandMiningFunctions smf = new SandMiningFunctions();

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int customerId = loginInfo.getCustomerId();
	int systemid=loginInfo.getSystemId();
	ArrayList<String> tobeConverted = new ArrayList<String>();
	
	boolean isModelCKM;
	isModelCKM = smf.isChikkmagalurModel(systemid);
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Application_No");
	tobeConverted.add("Name");
	tobeConverted.add("Mobile_Number");
	tobeConverted.add("Permit_No");
	tobeConverted.add("Type");
	tobeConverted.add("Destination");	
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
	
	String SLNO=convertedWords.get(0);
	String applicationNo=convertedWords.get(1);
	String nameLable=convertedWords.get(2);
	String mobileNoLable=convertedWords.get(3);
	String quantityReqLbl=convertedWords.get(4);
	String typeLbl=convertedWords.get(5);
	String Destinationlbl=convertedWords.get(6);			
%>

<jsp:include page="../Common/header.jsp" />
		<title>Approval Screen</title>

	<style>
	.pmrmandatoryfieldL{
	font-weight:bold;
	font-size: 1.3em;
	line-height: 150%;
	color: hsl(240, 100%, 40%);
	}
	.pmrmandatoryfield{
	font-weight:bold;
	font-size: 1.3em;
	line-height: 150%;
	}
	.pmrmandatoryfieldP{
	font-weight:bold;
	font-size: 1.3em;
	line-height: 150%;
	margin-right: 36px;
	color: hsl(240, 100%, 40%);
	}
	.pmrmandatoryfieldq{
	font-weight:bold;
	font-size: 1.3em;
	line-height: 150%;
	margin-right: 93px;
	color: hsl(240, 100%, 40%);
	}
	.pmrmandatoryfieldN{
	font-weight:bold;
	font-size: 1.5em;
	}
	.pmrmandatoryfieldr{
	font-weight:bold;
	font-size: 1.3em;
	line-height: 150%;
	margin-right: 80px;
	color: hsl(240, 100%, 40%);
	}
	#checkBoxpanelId {
    padding-left: 15px;
    /* padding-right: 36px; */
    font-size: 1.15em;
    font-family: sans-serif;
	}
	#qtyFromSand{
	padding-top: 20px;
	}
	#PreviousApproveLabId{
	padding-right:0px !important;
	}
	</style>
   <div height="100%"">
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
		<jsp:include page="../Common/ImportJSSandMining.jsp" />
		<%}else{%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%}%>
		<!-- for exporting to excel***** -->
		<jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			label {
				display : inline !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
		</style>
		<script>
            var jspName = 'SandConsumerApproval';
            var dtcur = datecur;
       		var dtprev = dateprev;
       		var datenxt=datenext;
       		var startdatepassed;
       		var custId;
       		var enddatepassed;          
            var exportDataType = " ";
            var myWin;
            var myWinReject;
            var myWinHold;
            var mobileNumber='';
            var applicationNo='';
            var AppStatus='';
            var balanceSandQty='';
//-----------------*********client Store**********--------------------------------

	 var clientcombostore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
	    id: 'CustomerStoreId',
	    root: 'CustomerRoot',
	    autoLoad: true,
	    remoteSort: true,
	    fields: ['CustId', 'CustName'],
	    listeners: {
	        load: function(custstore, records, success, options) {
	            if ( <%= customerId %> > 0) {
	                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
	                  Ext.getCmp('radioStatusReport').hide();
	                if(<%=isModelCKM%>){
		                 Ext.getCmp('baleceIDlbl').hide();
		                 Ext.getCmp('fromID').hide();
		                 Ext.getCmp('fromID1').hide();
	                }else{
	                 	 Ext.getCmp('fromID3').hide();
	                }
	             Ext.getCmp('applicationTypeCombo').setValue('pending');
	             store.load({
	                    params: {
	                        ClientId: Ext.getCmp('custcomboId').getValue(),
	                        Type:'pending'
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
	    emptyText: 'Select Division',
	    blankText: 'Select Division',
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
	                  Ext.getCmp('radioStatusReport').hide();
	                 if(<%=isModelCKM%>){
		                 Ext.getCmp('baleceIDlbl').hide();
		                 Ext.getCmp('fromID').hide();
		                 Ext.getCmp('fromID1').hide();
	                 }else{
	                  	 Ext.getCmp('fromID3').hide();
	                }	
	                Ext.getCmp('applicationTypeCombo').setValue('pending');
	               store.load({
	                    params: {
	                        ClientId: Ext.getCmp('custcomboId').getValue(),
	                        Type:'pending'
	                    }
	                });           
	            }
	        }
	    }
	});
	
	
	var Store = [
	    ["pending", "Pending Applications"],
	    ["approved", "Approved Applications"],
	    ["rejected", "Rejected Applications"],
	    ["hold", "Hold Applications"]
	];
	var typeStore = new Ext.data.SimpleStore({
	    data: Store,
	     fields: ['value', 'display']
	});
	 
	var applicationType = new Ext.form.ComboBox({
	  	store : typeStore , 
	    id: 'applicationTypeCombo',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: 'Select Application',
	    blankText: 'Select Application',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',   
	    valueField: 'value',
	    displayField: 'display',
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function() {
	             var status=Ext.getCmp('applicationTypeCombo').getValue();
	             store.load({
	                    params: {
	                        ClientId: Ext.getCmp('custcomboId').getValue(),
	                        Type:status
	                    }
	                });
	            if(status=='pending'){
					Ext.getCmp('approveButId').enable();	
					Ext.getCmp('rejectButId').enable();
				}else{
					Ext.getCmp('approveButId').disable();	
					Ext.getCmp('rejectButId').disable();	
				}
	           }
	        }
	    }
	});
	
      var customDatePanel = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'table',
            layoutConfig: {
                columns:7
            },
           items: [{
        			xtype: 'label',
					text: 'Client :',
					width : 90,
					cls: 'labelstyle'
			     },Client,{width:10},{width:10},{
        			xtype: 'label',
					text: 'Status :',
					width : 90,
					cls: 'labelstyle'
			     },applicationType,
			     {width:25}
            ]
        });
        
         var PanelBut = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'table',
            layoutConfig: {
                columns:7
            },
           items: [
			        {width:25},
			        {width:25},{
			    	xtype:'button',
			    	id:'approveButId',
			    	text:'Approve',
			    	cls: 'bskExtStyle',
			    	width:100,			    	
			    	listeners:{
			    	click:{
					   fn:function(){
					    Ext.getCmp('addButtId').enable();  					   
						approveApplication();
						}
			    	  }
			    	}
				}, {width:25},{
			    	xtype:'button',
			    	id:'rejectButId',
			    	text:'Reject',
			    	cls: 'bskExtStyle',
			    	width:100,			    	
			    	listeners:{
			    	click:{
					   fn:function(){
					    Ext.getCmp('myWinRejectButId').enable();
						rejectApplication();
						}
			    	  }
			    	}
				}
            ]
        });
          
        var mainPanel = new Ext.Panel({
          	title:'Approval Screen',
            frame: true,
            items: [customDatePanel]
        });
		
		 var ButtonPanel = new Ext.Panel({
          title:'List of Consumer Details',
            frame: true,
            items: [PanelBut]
        });
        
    var panelForInter = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'table',
            layoutConfig: {
                columns:3
            },
           items: [{
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'	          
	        }, {
	            xtype: 'label',
	            text:'Consumer/Buyer Application Number' + '  : ',
	            cls: 'pmrmandatoryfieldN'
	            
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfieldN',
	            id: 'ApplicationNoID'
	        }
            ]
        });
        
	var panelForInterQtyReq = new Ext.Panel({
            frame: false,        
            layout: 'table',
            height:80,
            id:'qtyFromSand',
            layoutConfig: {
                columns:5
            },
           items: [{
	            xtype: 'label',
	            text:'Quantity Requested',
	            cls: 'pmrmandatoryfieldN'
	            
	        },{
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfieldN',
	            id: 'QuantityRequiredID'
	        },{width:30}, {
	            xtype: 'label',
	            text:'From : ',
	            id:'fromID1',
	            cls: 'pmrmandatoryfieldN'	            
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfieldN',
	            id: 'fromID'
	        },
	        {
	            xtype: 'label',
	            text:'Previous Approved Quantity',
	            hidden: true,
	            cls: 'pmrmandatoryfieldN',
	            id: 'PreviousApproveLabId'
	            
	        },{
	            xtype: 'label',
	            text: '',
	            hidden: true,
	            cls: 'pmrmandatoryfieldN',
	            id: 'PreviousApproveQtyId'
	        }, {}, {
	            xtype: 'label',
	            text:''	                      
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfieldN',
	            id: 'baleceIDlbl'
	        },
	        {
	            xtype: 'label',
	            text:'Dispatched Quantity',
	            hidden: true,
	            cls: 'pmrmandatoryfieldN',
	            id: 'DispatchQtyLabId'
	            
	        },{
	            xtype: 'label',
	            text: '',
	            hidden: true,
	            cls: 'pmrmandatoryfieldN',
	            id: 'DispatchedQtyId'
	        }
            ]
        });
        
      var panelForInterPanl = new Ext.Panel({
            frame: false,
            layout: 'table',
            layoutConfig: {
                columns:2
            },
           items: [{
	            xtype: 'label',
	            text:'Consumer Name',
	            cls: 'pmrmandatoryfieldL'	            
	        },{
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfield',
	            id: 'consumerNameID'
	        }, {
	            xtype: 'label',
	            text:'Mobile',
	            cls: 'pmrmandatoryfieldL'	            
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfield',
	            id: 'mobileNoID'
	        },
	        {
	            xtype: 'label',
	            text:' Consumer Type',
	            cls: 'pmrmandatoryfieldL'
	            
	        },{
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfield',
	            id: 'consumerTypeID'
	        }
            ]
        });
        
          var panelForInterPanlNw1 = new Ext.Panel({
            frame: false,          
            layout: 'table',
            layoutConfig: {
                columns:2
            },
           items: [
	        {
	            xtype: 'label',
	            text:'Destination',	            
	            cls: 'pmrmandatoryfieldP'	            
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfield',
	            id: 'destinationID'
	        }
            ]
        });
        
         var panelForInterPanlNw2 = new Ext.Panel({
            frame: false,            
            layout: 'table',          
            layoutConfig: {
                columns:2
            },
           items: [
	        {
	            xtype: 'label',
	            text:'Via',
	            cls: 'pmrmandatoryfieldq'
	        },{
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfield',
	            id: 'viaID'
	        }
            ]
        });
        
        var panelForInterPanlNw3 = new Ext.Panel({
            frame: false,            
            layout: 'table',      
            id:'fromID3' ,    
            layoutConfig: {
                columns:2
            },
           items: [
	        {
	            xtype: 'label',
	            text:' From',
	            cls: 'pmrmandatoryfieldr'
	            
	        },{
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfield',
	            id: 'formTypeID'
	        },{
	            xtype: 'label',
	            text:' Property Assessment No',
	            cls: 'pmrmandatoryfieldr'
	            
	        },{
	            xtype: 'label',
	            text: '',
	            cls: 'pmrmandatoryfield',
	            id: 'propertyAssessmentId'
	        }
            ]
        });
/*********************inner panel for displaying form field in window***********************/
  var innerPanel = new Ext.form.FormPanel({
		standardSubmit: true,
	    collapsible: false,    
	    autoScroll: true,    
	    height: 420,
	    width: 560,
	    frame: true,
	    id: 'custMaster',
	    layout: 'table',
	    layoutConfig: {
	        columns: 1
	    },
	    items: [panelForInter,
		    panelForInterPanl,
		    panelForInterPanlNw1,
		    panelForInterPanlNw2,
		    panelForInterPanlNw3,
		    panelForInterQtyReq,
	     {
	        title: 'Document verification',
	        cls: 'fieldsetpanel',	        
	        id: 'checkBoxpanelId',
	        collapsible: false,
	        layout: 'table',
			 layoutConfig: {
	            columns: 3
	        },
            items: [ {
            	xtype: 'checkbox',
                boxLabel: 'Building Plan Verified',                 
                id: 'checkbox1'                         
            },{width:20}, {
            	xtype: 'checkbox',
                boxLabel: 'Attached Aadhar copy Verified',                
                id: 'checkbox2'            
            }, {    
            	xtype: 'checkbox',           
                boxLabel: 'Owner Name Verified',                 
                id: 'checkbox3'                    
            },{width:20},{
            	xtype: 'checkbox',
                boxLabel: 'Status Report Verified',           
                id: 'checkbox4',
                listeners: {
				    change: function() {
				        if(Ext.getCmp('checkbox4').checked==false){
				        Ext.getCmp('radioStatusReport').show();
				          }else{
				        Ext.getCmp('radioStatusReport').hide();
				        }
				       
				    }
				}
                    
            },{
            	xtype: 'checkbox',
                boxLabel: 'Photo of Building Verified',                 
                id: 'checkbox5'            
            },{width:20}, {
	            xtype: 'radiogroup',
	            fieldLabel: 'Auto Layout',	           
	            id:'radioStatusReport',
	            items: [
	                {boxLabel: 'AEE', name: 'rb-auto', inputValue: 1},
	                {boxLabel: 'CO', name: 'rb-auto', inputValue: 2},
	                {boxLabel: 'EO', name: 'rb-auto', inputValue: 3},
	                {boxLabel: 'PDO', name: 'rb-auto', inputValue: 4}               
	            ]
            }]
        },{ 
	        xtype: 'fieldset',
	        title: '',
	        cls: 'fieldsetpanel',
	        collapsible: false,
	        colspan: 3,
	        id: 'custpanelid',
	        layout: 'table',
	        layoutConfig: {
	            columns: 3
	        },
	        items: [{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'mandatoryphoneno'
	        }, {
	            xtype: 'label',
	            text: 'Approved Quantity' + '  :',
	            cls: 'pmrmandatoryfield',
	            id: 'ApprovedQtyLabid'
	        }, {
	            xtype: 'numberfield',	           
	            cls: 'textrnumberstyle',     	           
	            id: 'approvedQuantity',
	            maskRe: /[0-9]+(\.[0-9][0-9]?)?/
	        }]
	    }]
	});
	
	
    function manageDetails(qty,reasonForReject,rem,newQty){

			var selected = grid.getSelectionModel().getSelected();
			var uniqueId=selected.get('uniqueIdDataIndex');			
			var tpIdJs=selected.get('tpIdDataIndex');
			
			Ext.getCmp('addButtId').disable();
            Ext.getCmp('myWinRejectButId').disable();
            Ext.getCmp('myWinHoldButId').disable();
            
	 		Ext.Ajax.request({
	             url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=manageDataOfConsumerEnrolement',
	             method: 'POST',
	             params: {
	                 Status: buttonValue,
	                 ClientId: Ext.getCmp('custcomboId').getValue(),
	                 UniqueId: uniqueId,
	                 ApprovedQty:qty,
	                 TpId:tpIdJs,
	                 remarks:rem,
	                 mobile:mobileNumber,
	                 appNo:applicationNo,
	                 Reason:reasonForReject,
	                 BalanceSandQty:balanceSandQty,
	                 AppStatus : AppStatus,
	                 newQty : newQty
	             },
	             success: function(response, options){             
                     Ext.example.msg(response.responseText);                                    
                     myWin.hide();
                     myWinReject.hide();
                     myWinHold.hide();
					 store.load({
	                    params: {
	                        ClientId: Ext.getCmp('custcomboId').getValue(),
	                        Type:Ext.getCmp('applicationTypeCombo').getValue()
	                    }
	                });
	              }, 
	              failure: function(){
	                     Ext.example.msg("error");                                   
	                     myWin.hide();
	                     store.load({
		                    params: {
		                        ClientId: Ext.getCmp('custcomboId').getValue(),
		                        Type:Ext.getCmp('applicationTypeCombo').getValue()
		                    }
	                	});
	                 } // END OF FAILURE 
	         }); // END OF AJAX		
    } 		 
 var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    cls: 'windowbuttonpanel',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 2
    },
    buttons: [{
        xtype: 'button',
        text: 'Approve',
        id: 'addButtId',
        iconCls: 'savebutton',
        cls: 'buttonstyle',
        width: 80,
        listeners: {
            click: {
                fn: function() {
                 
                    if (Ext.getCmp('approvedQuantity').getValue() == "") {
                        Ext.example.msg("Please enter Approval Quantity");
                        Ext.getCmp('approvedQuantity').focus();
                        return;
                    }
                    if (Ext.getCmp('approvedQuantity').getValue() <= 0) {
                        Ext.example.msg("Approving Quantity cannot be less than or equal Zero");
                        Ext.getCmp('approvedQuantity').focus();
                        return;
                    }
                     var qty=Ext.getCmp('approvedQuantity').getValue();
                     var selected = grid.getSelectionModel().getSelected();
					 var reqQty=selected.get('qtyReqDataIndex');
					 var balenceCreated=(selected.get('balanceDataIndex'));
					 var newQty='';
					 
					 if(AppStatus=='approved'){
					 	 selected = grid.getSelectionModel().getSelected();
						 reqQty=selected.get('qtyReqDataIndex');
						 newQty=Ext.getCmp('approvedQuantity').getValue();
						 var prevQty=parseFloat(selected.get('approvedQtyDataIndex'));
					 	 qty = newQty + prevQty;
					 	 var b1=parseFloat(selected.get('balanceSandQuantity'));
					 	 var b2=Ext.getCmp('approvedQuantity').getValue();
					 	 balanceSandQty = b1 + b2;
					 
					 }
					
                    if(qty>reqQty){
						Ext.example.msg("Approving Quantity must be less than or equal to Requested Quantity");
                        Ext.getCmp('approvedQuantity').focus();
                        return;
					}
					if(balenceCreated<(qty*60) && !<%=isModelCKM%>){
						Ext.example.msg("TP Credit balance is low compare to approving quantity!! ");
                        Ext.getCmp('approvedQuantity').focus();
                        return;
					}
					 if (Ext.getCmp('checkbox1').checked==false || Ext.getCmp('checkbox2').checked==false 
					    || Ext.getCmp('checkbox3').checked==false || Ext.getCmp('checkbox4').checked==false
					     || Ext.getCmp('checkbox5').checked==false) {
                        Ext.example.msg("Please verify all the Documents");                       
                        return;
                    }
 			 		manageDetails(qty,'','',newQty);
                }
            }
        }
    },{
        xtype: 'button',
        text: 'Hold',
        id: 'holdButtId',
        iconCls: 'savebutton',
        cls: 'buttonstyle',
        width: 80,
        listeners: {
            click: {
                fn: function() {                 
					holdApplication();
                }
            }
        }
    },{
        xtype: 'button',
        text: 'Reject',
        id: 'rejectButtId',
        iconCls: 'savebutton',
        cls: 'buttonstyle',
        width: 80,
        listeners: {
            click: {
                fn: function() {                 
					rejectApplication();
                }
            }
        }
    }, {
        xtype: 'button',
        text: 'Cancel',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: '80',
        listeners: {
            click: {
                fn: function() {                 
                    myWin.hide();
                }
            }
        }
    }]
});


/***********panel contains window content info***************************/

var outerPanelWindow = new Ext.Panel({ 
    standardSubmit: true,
    frame: false,
    items: [innerPanel, winButtonPanel]
});

/***********************window for form field****************************/

myWin = new Ext.Window({
    title: 'Consumer Approval',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    width: 570,
    cls: 'mywindow',
    id: 'myWin',
    items: [outerPanelWindow]
});

/*function for add button in grid that will open form window*/

 	function approveApplication() {
 
		  if(grid.getSelectionModel().getCount()==0){
                Ext.example.msg("Please select one row");
  					return;
				}
		  if(grid.getSelectionModel().getCount()>1){
                  Ext.example.msg("Please select one row");
 					return;
			    }
			    
			Ext.getCmp('checkbox1').reset();
			
			Ext.getCmp('checkbox2').reset();
			
			Ext.getCmp('checkbox3').reset();
			Ext.getCmp('checkbox4').reset();
			
			Ext.getCmp('checkbox5').reset();
			
			Ext.getCmp('testAreaHold').setValue('');
			Ext.getCmp('testAreaReject').setValue('');
			Ext.getCmp('applicationTypeRejectId').setValue('');
			Ext.getCmp('applicationTypeHoldId').setValue('');   
		    Ext.getCmp('approvedQuantity').setValue('');
		    var selected = grid.getSelectionModel().getSelected();
			var uniqueId=selected.get('uniqueIdDataIndex');
			Ext.getCmp('ApplicationNoID').setText(selected.get('applicationNoDataIndex'));
			Ext.getCmp('consumerNameID').setText(' : '+selected.get('ConsumerNameDataIndex'));
			Ext.getCmp('mobileNoID').setText(' : '+selected.get('MobileDataIndex'));
			Ext.getCmp('consumerTypeID').setText(' : '+selected.get('typeDataIndex'));
			Ext.getCmp('destinationID').setText(' : '+selected.get('destinationDataIndex'));
			var qtyReqP=parseFloat(selected.get('qtyReqDataIndex'));
			Ext.getCmp('QuantityRequiredID').setText(' : '+qtyReqP.toFixed(2));
			var balQtyP=parseFloat(selected.get('balanceDataIndex'));
			Ext.getCmp('fromID').setText('[ TP NO : '+selected.get('tpNoDataIndex')+' ]');
			Ext.getCmp('baleceIDlbl').setText('[ TP BAL : '+balQtyP.toFixed(2)+' Rs ]');
			Ext.getCmp('viaID').setText(' : '+selected.get('viaDataIndex'));
			Ext.getCmp('formTypeID').setText(' : '+selected.get('stockyardDataIndex'));
			Ext.getCmp('propertyAssessmentId').setText(' : '+selected.get('propertyAssessmentDataIndex'));
			var qtyApproved=parseFloat(selected.get('approvedQtyDataIndex'));
			Ext.getCmp('PreviousApproveQtyId').setText(': '+qtyApproved.toFixed(2));
			var dispatchQty=parseFloat(selected.get('totalDispatchQty'));
			Ext.getCmp('DispatchedQtyId').setText(' : '+dispatchQty.toFixed(2));
			
		    buttonValue = "approved";
		    myWin.show();  
		    myWin.setPosition(380, 40); 
    }

  var StoreReject = [
	    ["Stock not available", "Stock not available"],
	    ["Not a valid Consumer", "Not a valid Consumer"],
	    ["Duplicate Consumer", "Duplicate Consumer"],
	    ["Insufficient Documents", "Insufficient Documents"]
	];
	var typeStoreReject = new Ext.data.SimpleStore({
	    data: StoreReject,
	     fields: ['value', 'display']
	});
	 
	var applicationTypeReject = new Ext.form.ComboBox({
	  	store : typeStoreReject , 
	    id: 'applicationTypeRejectId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: 'Select Reason',
	    blankText: 'Select Reason',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',   
	    valueField: 'value',
	    displayField: 'display',
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function() {

	           }
	        }
	    }
	});
	
	  var innerPanelReject = new Ext.form.FormPanel({
		standardSubmit: true,
	    collapsible: false,    
	    autoScroll: true,    
	    height: 100,
	    width: '100%',
	    frame: true,	 
	    layout: 'table',
	    layoutConfig: {
	        columns: 3
	    },
	    items: [{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'	          
	        }, {
	            xtype: 'label',
	            text: 'Please Select Reason for Rejection :',
	            cls: 'pmrmandatoryfield'	           
	        },applicationTypeReject,{
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'	          
	        }, {
	            xtype: 'label',
	            text: 'Please Enter remarks for Rejection : ',
	            cls: 'pmrmandatoryfield'	           
	        },{
	        	xtype: 'textarea',	           
	            cls: 'selectstylePerfect',
	            height :40,
	            id:'testAreaReject'
	           }]
	});
	
var winButtonPanelReject = new Ext.Panel({
    id: 'winbuttonidRej',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    cls: 'windowbuttonpanel',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 2
    },
    buttons: [{
        xtype: 'button',
        text: 'Reject',
        id:'myWinRejectButId',
        iconCls: 'savebutton',
        cls: 'buttonstyle',
        width: 80,
        listeners: {
            click: {
                fn: function() {
                 	var reasonForReject = Ext.getCmp('applicationTypeRejectId').getValue();
                    if (reasonForReject == "") {
                        Ext.example.msg("Please Select Reason to reject");
                        Ext.getCmp('applicationTypeRejectId').focus();
                        return;
                    }
 			 		manageDetails(0,reasonForReject,Ext.getCmp('testAreaReject').getValue());
                }
            }
        }
    }, {
        xtype: 'button',
        text: 'Cancel',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: '80',
        listeners: {
            click: {
                fn: function() {                 
                    myWinReject.hide();
                }
            }
        }
    }]
});
	var StoreHold = [
	    ["Building Plan not matching","Building Plan not matching"],
	    ["Owner name not matching","Owner name not matching"],
	    ["Photo of Building not matching","Photo of Building not matching"],
	    ["Attached Aadhar copy not matching","Attached Aadhar copy not matching"],
	    ["Status Report not matching","Status Report not matching"]
	   
	];
	var typeStoreHold = new Ext.data.SimpleStore({
	    data: StoreHold,
	     fields: ['value', 'display']
	});
var applicationTypeHold = new Ext.form.ComboBox({
	  	store : typeStoreHold , 
	    id: 'applicationTypeHoldId',
	    mode: 'local',
	    forceSelection: true,
	    emptyText: 'Select Reason',
	    blankText: 'Select Reason',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',   
	    valueField: 'value',
	    displayField: 'display',
	    cls: 'selectstylePerfect',
	    listeners: {
	        select: {
	            fn: function() {

	           }
	        }
	    }
	});
	  var innerPanelHold = new Ext.form.FormPanel({
		standardSubmit: true,
	    collapsible: false,    
	    autoScroll: true,    
	    height: 100,
	    width: '100%',
	    frame: true,	 
	    layout: 'table',
	    layoutConfig: {
	        columns: 3
	    },
	    items: [{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'	          
	        }, {
	            xtype: 'label',
	            text: 'Please Select Reason for Hold :',
	            cls: 'pmrmandatoryfield'	           
	        },applicationTypeHold,
	        {
	            xtype: 'label',
	            text: ' ',
	            cls: 'mandatoryfield'	          
	        }, {
	            xtype: 'label',
	            text: 'Please Enter remarks for Hold : ',
	            cls: 'pmrmandatoryfield'	           
	        },{
	        	xtype: 'textarea',	           
	            cls: 'selectstylePerfect',
	            height :40,
	            id:'testAreaHold'
	           }]
	});
	
var winButtonPanelHold = new Ext.Panel({
    id: 'winbuttonidHold',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    cls: 'windowbuttonpanel',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 2
    },
    buttons: [{
        xtype: 'button',
        text: 'Hold',
        id:'myWinHoldButId',
        iconCls: 'savebutton',
        cls: 'buttonstyle',
        width: 80,
        listeners: {
            click: {
                fn: function() {
                 	var reasonForReject = Ext.getCmp('applicationTypeHoldId').getValue();
                    if (reasonForReject == "") {
                        Ext.example.msg("Please Select Reason to Hold");
                        Ext.getCmp('applicationTypeHoldId').focus();
                        return;
                    }
 			 		manageDetails(0,reasonForReject,Ext.getCmp('testAreaHold').getValue());
                }
            }
        }
    }, {
        xtype: 'button',
        text: 'Cancel',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: '80',
        listeners: {
            click: {
                fn: function() {                 
                    myWinHold.hide();
                }
            }
        }
    }]
});
var outerPanelWindowHold = new Ext.Panel({ 
    standardSubmit: true,
    frame: false,
    items: [innerPanelHold, winButtonPanelHold]
});
 myWinHold = new Ext.Window({
    title: 'Do you want to Hold this application ?',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: 'mywindow',
    id: 'myWinHold',
    items: [outerPanelWindowHold]
});
  function holdApplication() {	 
		    buttonValue = "hold";    
			myWinHold.show();	
	}

var outerPanelWindowReject = new Ext.Panel({ 
    standardSubmit: true,
    frame: false,
    items: [innerPanelReject, winButtonPanelReject]
});

 myWinReject = new Ext.Window({
    title: 'Do you want to Reject this application ?',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: 'mywindow',
    id: 'myWinReject',
    items: [outerPanelWindowReject]
});
	function rejectApplication() {
	 
		  if(grid.getSelectionModel().getCount()==0){
		          Ext.example.msg("Please select one row");
				  return;
				}
	      if(grid.getSelectionModel().getCount()>1){
                  Ext.example.msg("Please select one row");
 				  return;
				} 
    buttonValue = "rejected";    
	myWinReject.show();
	
	}


      //********************************* Reader Config***********************************
      
            var reader = new Ext.data.JsonReader({
                idProperty: 'gridrootid',
                root: 'ConsumerEnrolementDataRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'slnoIndex'
                    },{
                		name: 'uniqueIdDataIndex'
                	},{
                		name: 'ConsumerNameDataIndex'
                	},{
                	    name: 'applicationNoDataIndex'
                	},{
                        name: 'MobileDataIndex'
                    },{
                        name: 'qtyReqDataIndex'
                    },{
                        name: 'typeDataIndex'
                    },{
                       name: 'destinationDataIndex'
                    },{
                        name: 'tpNoDataIndex'
                    },{
                       name: 'tpIdDataIndex'
                    },{
                       name: 'viaDataIndex'
                    },{
                       name: 'balanceDataIndex'
                    },{
                       name: 'approvedQtyDataIndex'
                    },{
                       name: 'remarksDataIndex'
                    },{
                       name: 'stockyardDataIndex'
                    },{
                       name:'propertyAssessmentDataIndex'
                    },{
                       name:'totalDispatchQty'
                    },{
                       name:'balanceSandQuantity'
                    }
                ]
            });
      //******************************** Grid Store*************************************** 
      
            var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getDataForConsumerApproval',
                    method: 'POST'
                }),
                remoteSort: false,
                storeId: 'gridStore',
                reader: reader
            });
        
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'numeric',
                        dataIndex: 'slnoIndex'
                    },{
                        dataIndex: 'ConsumerNameDataIndex',
                        type: 'string'
                    }, {
                        type: 'string',
                        dataIndex: 'applicationNoDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'MobileDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'qtyReqDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'typeDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'destinationDataIndex'
                    },{
                        type: 'string',
                        dataIndex: 'tpNoDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'tpIdDataIndex'
                    }, {
                        type: 'numeric',
                        dataIndex: 'balanceDataIndex'
                    }, {
                        type: 'string',
                        dataIndex: 'stockyardDataIndex'
                    }, {
                    	type:'string',
                    	dataIndex:'propertyAssessmentDataIndex'
                    }
                    
                ]
            });
            
             //**************************** Grid Pannel Config ******************************************

            var createColModel = function (finish, start) {
                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        width: 50
                    }),{
                        dataIndex: 'slnoIndex',
                        hidden: true,
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        filter: {
                            type: 'numeric'
                        }
                    },{
                        dataIndex: 'uniqueIdDataIndex',
                        hidden: true,
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        filter: {
                            type: 'numeric'
                        }
                    },  {
                        header: "<span style=font-weight:bold;><%=applicationNo%></span>",
                        dataIndex: 'applicationNoDataIndex',
                        //width:40,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=nameLable%></span>",
                        dataIndex: 'ConsumerNameDataIndex',
                        //width:30,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=mobileNoLable%></span>",
                        dataIndex: 'MobileDataIndex',
                        //width:30,
                        filter: {
                            type: 'string'
                            }
                    }, {
                        header: "<span style=font-weight:bold;>Quantity Required</span>",
                        dataIndex: 'qtyReqDataIndex',
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;><%=typeLbl%></span>",
                        dataIndex: 'typeDataIndex',
                        filter: {
                            type: 'string'
                        }
                    }, {
                       header: "<span style=font-weight:bold;><%=Destinationlbl%></span>",
                       dataIndex: 'destinationDataIndex',
                       filter: {
                           type: 'string'
                       }
                    },
                    {
                        header: "<span style=font-weight:bold;>TP NO</span>",
                        dataIndex: 'tpNoDataIndex',                      
                        filter: {
                            type: 'string'
                        }
                    }, {
                       header: "<span style=font-weight:bold;>TP ID</span>",
                       dataIndex: 'tpIdDataIndex',
                       hidden: true,
                       filter: {
                           type: 'string'
                       }
                    },{
                       header: "<span style=font-weight:bold;>CHECK POST</span>",
                       dataIndex: 'viaDataIndex',
                       filter: {
                           type: 'string'
                       }
                    },{
                       header: "<span style=font-weight:bold;>APPROVED QUANTITY</span>",
                       dataIndex: 'approvedQtyDataIndex',
                       filter: {
                           type: 'string'
                       }
                    },{
                       header: "<span style=font-weight:bold;>REMARKS</span>",
                       dataIndex: 'remarksDataIndex',
                       filter: {
                           type: 'string'
                       }
                    },{
                       header: "<span style=font-weight:bold;>STOCK YARD</span>",
                       dataIndex: 'stockyardDataIndex',
                       filter: {
                           type: 'string'
                       }
                    },{
                       header: "<span style=font-weight:bold;>PROPERTY ASSESSMENT NUMBER</span>",
                       dataIndex: 'propertyAssessmentDataIndex',
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
            
             //**************************** Grid Panel Config ends here**********************************
            var grid = getGrid('', 'No Records Found', store, screen.width - 25, 375, 21, filters, 'Clear Filter Data', false, '', 7, false, '', false, '', false, '', jspName, exportDataType, false, '');
            grid.on({
                cellclick: {
                    fn: function (grid, rowIndex, columnIndex, e) {
                    }
                },
                celldblclick: {
                    fn: function (grid, rowIndex, columnIndex, e) {
		                    
		                   	AppStatus= Ext.getCmp('applicationTypeCombo').getValue();
			                   if(AppStatus=='pending' || AppStatus=='hold'){
			                      approveApplication(); 
		                     		Ext.getCmp('addButtId').enable();
		                     		Ext.getCmp('rejectButtId').show();
						            Ext.getCmp('holdButtId').show();	
						            Ext.getCmp('myWinRejectButId').enable();
						            Ext.getCmp('myWinHoldButId').enable();
						            Ext.getCmp('PreviousApproveLabId').hide();
						            Ext.getCmp('PreviousApproveQtyId').hide();
						            Ext.getCmp('DispatchQtyLabId').hide();
						            Ext.getCmp('DispatchedQtyId').hide(); 	
						            Ext.getCmp('ApprovedQtyLabid').setText('Approved Quantity ' + '  :');
						            var row= grid.getSelectionModel().getSelected();
		                    		mobileNumber=row.get('MobileDataIndex');
		                    		applicationNo=row.get('applicationNoDataIndex');
			                   }
			                   if(AppStatus=='approved'){
			                      approveApplication(); 
		                     		Ext.getCmp('addButtId').enable();
						            Ext.getCmp('rejectButtId').hide();
						            Ext.getCmp('holdButtId').hide();	
						            Ext.getCmp('PreviousApproveLabId').show();
						            Ext.getCmp('PreviousApproveQtyId').show();
						            Ext.getCmp('DispatchQtyLabId').show();
						            Ext.getCmp('DispatchedQtyId').show(); 	
						            Ext.getCmp('ApprovedQtyLabid').setText(' Present Approved Quantity ' + '  :');				          
						            var row= grid.getSelectionModel().getSelected();
		                    		mobileNumber=row.get('MobileDataIndex');
		                    		applicationNo=row.get('applicationNoDataIndex');
			                   }
                    }
                }
            });
            
          //***************************  Main starts from here **************************************************
            Ext.onReady(function () {
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    renderTo: 'content',
                    standardSubmit: true,
		  			frame:false,
		  			border:true,
                    width : screen.width-22,
	        		height : 550,
					cls: 'mainpanelpercentage',
                    items: [ mainPanel,grid ]
                });
            });
    </script>
	</div>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->

