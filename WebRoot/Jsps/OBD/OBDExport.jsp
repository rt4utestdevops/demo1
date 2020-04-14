<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		int systemId = loginInfo.getSystemId();
		int customerId = loginInfo.getCustomerId();
		int userId = loginInfo.getUserId();
		String RegNO="";
			 ArrayList<String> tobeConverted = new ArrayList<String>();
			 
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

	


%>
<jsp:include page="../Common/header.jsp" />
<!DOCTYPE HTML>
<html>
<link rel="shortcut icon" href="">
  <head>
    <base href="<%=basePath%>">
    <title>OBD Report</title>
				<style>
				.labelstyle {
					spacing: 10px;
					height: 20px;
					width: 150 px !important;
					min-width: 150px !important;
					margin-bottom: 5px !important;
					margin-left: 5px !important;
					font-size: 12px;
					font-family: sans-serif;
				}
				.selectstylePerfect {
					height: 20px;
					width: 140px !important;
					listwidth: 120px !important;
					max-listwidth: 120px !important;
					min-listwidth: 120px !important;
					margin: 0px 0px 5px 5px !important;
				}
				.x-btn-text addbutton{font-family: 'Helvetica', sans-serif;
	                                                  font-size: 12px !important;}
				.x-btn-text editbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text excelbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text pdfbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;}
				.x-btn-text clearfilterbutton{font-family: 'Helvetica', sans-serif;
				                                                  font-size: 12px !important;
				}
	</style>
  </head>
 
  <!-- <body> -->
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
		 <style>
		 	.ext-strict .x-form-text {
    			height: 21px !important;
			}
			 .x-form-radio {
			 	margin-bottom : 7px !important;
			 }
			 .x-form-field-trigger-wrap {
			 	width : 163px !important;			 	
			 }
			 div#enddatepanelId {
			 	margin-left : 40px !important;
			 }
			 .x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			 }
		 </style>
 <script><!--
    //-------------------------------------------------------------------------------//
    var outerPanel;
    var jspName = "OBD Report";
    var exportDataType = "int,date,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
    var dtprev = dateprev;
    var dtcur = datecur;
    var json = "";
    var startDate = "";
    var endDate = "";
    var OBDGrid;
    
    var now = new Date();        
    var year    = now.getFullYear();
    var month   = now.getMonth()+1; 
    var day     = now.getDate();
    var day1     = now.getDate()-1;
    if(month < 10)
    {
    	month='0'+month;
    }
    
var prevDate = day1+'-'+month+'-'+year+ ' '+'00:00:00';
var prevDate1 = day+'-'+month+'-'+year+ ' '+'00:00:00';

   
    //----------------------------------customer store---------------------------// 
    var customercombostore = new Ext.data.JsonStore({
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
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    groupStore.load({
                        params: {
                            CustId: custId
                        }
                    });
                }
            }
        }
    });

    //******************************************************************customer Combo******************************************//
    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Customer Name',
        resizable: true,
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
                    globalAssetNumber = "";
                    custId = Ext.getCmp('custcomboId').getValue();
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    groupStore.load({
                        params: {
                            CustId: custId
                        }
                    });

                    Ext.getCmp('VehicleNameComboId').reset();
                    //OBDGrid.show();
                    OBDGrid.hide();
                   // store.load();

                    if ( <%= customerId %> > 0) {
                        Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                        custId = Ext.getCmp('custcomboId').getValue();
                        custName = Ext.getCmp('custcomboId').getRawValue();
                        groupStore.load({
                            params: {
                                CustId: custId
                            }
                        });
                        Ext.getCmp('VehicleNameComboId').reset();
                       //OBDGrid.show();
                       OBDGrid.hide();
                       
                    }
                }
            }
        }
    });
var storeIndex = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/OBDAction.do?param=getIndexesofOBDVehicle',
         id: 'StoreIndexId',
        root: 'StroreIndexList',
        autoLoad: false,
        remoteSort: true,
        fields: ['DataListIndex']
    });


    var groupStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/OBDAction.do?param=getGroups',
        id: 'groupId',
        root: 'groupNameList',
        autoLoad: false,
        remoteSort: true,
        fields: ['groupId', 'groupName']
    });
       
//******************************************************************vehicle Combo******************************************//
    var groupNameCombo = new Ext.form.ComboBox({
        fieldLabel: '',
        store: groupStore,
        id: 'VehicleNameComboId',
         width: 150,
        emptyText: 'Registration Number',
        blankText: 'Registration Number',
       //  labelWidth: 100,
        resizable: true,
        hidden: false,
        forceSelection: true,
        enableKeyEvents: true,
        mode: 'local',
        triggerAction: 'all',
	    autoload: true,
	    anyMatch: true,
	    typeAhead: false,
        
        displayField: 'groupName',
        valueField: 'groupId',
        loadingText: 'Searching...',
        cls: 'selectstylePerfect',
        //minChars: 3,
        listeners: {
            select: {
                fn: function() {
                    CustId = Ext.getCmp('custcomboId').getRawValue();
                    groupId = Ext.getCmp('VehicleNameComboId').getValue();                 
                 	RegNO = Ext.getCmp('VehicleNameComboId').getValue();  
                 	
                    //OBDGrid.show();
                    OBDGrid.hide();
                    OBDGrid.setWidth(screen.width - 35);
                }
            }
        }
    });

    //-------------------------------------------------------------------------------------------------------//
    
var StartDate = new Ext.form.DateField({
	    	fieldLabel:'StartDate',
		    id:'startdate',
           format: getDateTimeFormat(),
            cls: 'selectstylePerfect',
            //value: datecur,
            //value: dtprev,
            value: prevDate,
            endDateField: 'enddate',
            //width: 100,
            width: 185,
             allowBlank:false,
             menuListeners: {
               select: function(m, d){
            	 this.setValue(d);
                     if(Ext.getCmp('startdate').value!="" && Ext.getCmp('enddate').value!=""){
                           var startdate=Ext.getCmp('startdate').value;
                           var enddate=Ext.getCmp('enddate').value;
                     }
                  }
			}
	   	 });

var startdatepanel = new Ext.Panel({
					title:'',
					id:'startdatepanelId',
	    	   		layout:'table',
    				layoutConfig: {
       					columns:3
    				},
    				items: [
    				{
        			xtype: 'label',
					text: 'Start Date',
					width : 100,
					cls: 'labelstyle'
				  },{width:32},StartDate]
			});
			
	var EndDate = new Ext.form.DateField({
	    	 fieldLabel: 'EndDate',
			 id:'enddate',
			 format: getDateTimeFormat(),
			 cls: 'selectstylePerfect',
             //value:"currentDate",
             value: prevDate1,
             startDateField: 'startdate',
             allowBlank:false,
             //width: 100,
             width: 185,
             menuListeners: {
                select: function(m, d){
            	         this.setValue(d);
                         if(Ext.getCmp('startdate').value!="" && Ext.getCmp('enddate').value!=""){
                             var startdate=Ext.getCmp('startdate').value;
                             var enddate=Ext.getCmp('enddate').value;
                         }
                 }
			 } 				
	   	 });	
		
	   var enddatepanel = new Ext.Panel({					
					title:'',
					id:'enddatepanelId',
	    	   		layout:'table',
    				layoutConfig: {
       					columns:3
    				},
    				items: [
    				{
        			xtype: 'label',
					text: 'End Date',
					//width : 70,
					width: 185,
					//cls: 'bskExtStyle'
					cls: 'labelstyle'
				  },{width:5},EndDate ]
			});
		
//******************************************************************Trip Store******************************************//
    var  tripStore = new Ext.data.JsonStore({
	url		:'<%=request.getContextPath()%>/TripMasterDetails.do?param=getTripNames',
	root	: 'tripRoot',
	autoLoad: false,
	fields	: ['tripId','tripName','assetNo','vehicleType','startDate','endDate','VehicleId']
 })
    
var tripNameText =  new Ext.form.ComboBox({
              mode: 'local',
              value: '',
              displayField: 'tripName',
              valueField: 'tripId',
              enableKeyEvents: true,
              resizable:true,
              anyMatch:true,
              triggerAction: 'all',
              emptyText: 'Select Trip Name',
              selectOnFocus: true,
              id: 'tripComboId',
              width: 180,
              labelWidth: 140,
              store: tripStore,
              hidden:true,
              listeners: {
                   select: {
                       fn: function () {
	                       var id = Ext.getCmp('tripComboId').getValue();
	                       var row = tripStore.findExact('tripId', id);
	                       var rec = tripStore.getAt(row);
	                       tripAssetNo = rec.data['assetNo'];
	                       tripVehicleType = rec.data['vehicleType'];
	                       tripstartDate= rec.data['startDate'];
	                       tripendDate= rec.data['endDate'];
	                       tripVehicleId=rec.data['VehicleId'];
	
	                       Ext.getCmp('VehicleNameComboId').setValue(tripAssetNo);
		            	   Ext.getCmp('startdate').setValue(tripstartDate);
		            	   Ext.getCmp('enddate').setValue(tripendDate);
                       }
                    }
					 }	    			
	    			});

var custPanel = new Ext.Panel({
            title: '',
            layout: 'table',
            layoutConfig: {
                columns: 2
            },
            width: 640,
            items: [{
                xtype: 'label',
                text: 'Customer Name' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
            },custnamecombo]
            });

var radioPanel = new Ext.Panel({
            title: '',
            layout: 'table',
            layoutConfig: {
                columns: 8
            },
            width: 640,
            style:'padding-left: 10px',
            items: [{
                xtype: 'label',
                text: 'View Report By: ',
                width: 120,
                cls: 'labelstyle'
            }, {width:20},{
                xtype: 'radio',
                id: 'regNoRadioId',
                checked: true,                
                boxLabel: 'Registration Number',                
                name: 'radioHubReg',
                listeners: {
                    check: function () {
                        if (this.checked) {
                           
			            	Ext.getCmp('VehicleNameComboId').enable();
			            	Ext.getCmp('startdate').enable();
			            	Ext.getCmp('enddate').enable();			            	
		            	   
		            	   	Ext.getCmp('VehicleNameComboId').setValue("");			            	
                            Ext.getCmp('tripComboId').hide();
                            Ext.getCmp('tripNameLblId').hide();
                            
                            if (Ext.getCmp('custcomboId').getValue() == "") {
                                Ext.example.msg("Select Customer");
                                Ext.getCmp('custcomboId').focus();
                                return;
                            }

                            //if (Ext.getCmp('VehicleNameComboId').getValue() == "") {
                              //  Ext.example.msg("Select Vehicle Number");
                   				// Ext.getCmp('VehicleNameComboId').focus();
                                //return;
                           // }
                            

                            if (Ext.getCmp('startdate').getValue() == "") {
                                Ext.example.msg("Select Start Date");
                                Ext.getCmp('startdate').focus();
                                return;
                            }

                            if (Ext.getCmp('enddate').getValue() == "") {
                                Ext.example.msg("Select End Date");
                                Ext.getCmp('enddate').focus();
                                return;
                            }

                            
                            
                            
                        }
                    }
                }
            }, {width:20},{
                xtype: 'radio',
                id: 'radioTrip',
                boxLabel: 'Trip',
                name: 'radioHubReg',
                listeners: {
                    check: function () {
                        if (this.checked) {
                            Ext.getCmp('VehicleNameComboId').disable();
			            	Ext.getCmp('startdate').disable();
			            	Ext.getCmp('enddate').disable();
                            
		            	   	Ext.getCmp('VehicleNameComboId').setValue("");			        
                            Ext.getCmp('tripComboId').show();
                            Ext.getCmp('tripNameLblId').show();
                            Ext.getCmp('tripComboId').reset();
                            tripStore.load();
                        }
                    }
                }
            }]
        });

var generateButton = new Ext.Button({
        			text: 'Generate Report',
        			listeners: {
                    click: {
                        fn: function() {
                                                                       
                          if (Ext.getCmp('radioTrip').checked == true) {                                
		                                if (Ext.getCmp('tripComboId').getValue() == "") {
			                                Ext.example.msg("Select Trip Name");
			                   				Ext.getCmp('tripComboId').focus();
			                                return;
		                           		}	 
                           }
                          if (Ext.getCmp('regNoRadioId').checked == true) {
                               	  if (Ext.getCmp('VehicleNameComboId').getValue() == "") {
		                                Ext.example.msg("Select Vehicle Number");
		                   				 Ext.getCmp('VehicleNameComboId').focus();
		                                return;
                            		}
                           }	   
                            	  
                           if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                                Ext.example.msg("End date must be greater than the Start date");
                                Ext.getCmp('enddate').focus();
                                return;
                            }
								var Startdates = Ext.getCmp('startdate').getValue();
                                var Enddates = Ext.getCmp('enddate').getValue();
                                var dateDifrnc = new Date(Enddates).add(Date.DAY, -7);
                                if (Startdates <= dateDifrnc) {
                                Ext.example.msg("Difference between two dates should not be greater than 7 days ");
                                Ext.getCmp('enddate').focus();
                                return;
                            } 	  
                            	  
                            	  
                            	                 	
                            var cm = OBDGrid.getColumnModel();
					        for (var j = 4; j < cm.getColumnCount(); j++) {
					            cm.setHidden(j, true);
					        }		
					        			       
					        
        Ext.MessageBox.show({
		        title: 'Please wait',
		        msg: 'Processing...',
		        progressText: 'Processing...',
		        width: 300,
		        progress: true,
		        closable: false,		        
		});
                    	
					Ext.Ajax.request({
                      url: '<%=request.getContextPath()%>/OBDAction.do?param=getOBDExcel',
                      method: 'POST',
                      params: {
                            CustId:  Ext.getCmp('custcomboId').getValue(),
                            RegNo : Ext.getCmp('VehicleNameComboId').getValue(),
                            StartDate: Ext.getCmp('startdate').getValue(),
                            EndDate: Ext.getCmp('enddate').getValue(),
                            jspName: jspName
                      },
                        success: function (response,options) {
                        //var  locationResponseImportData  = Ext.util.JSON.decode(response.responseText);
						Ext.MessageBox.hide();
                        var  locationResponseImportData  = response.responseText;
                       
                         window.open("<%=request.getContextPath()%>/LegDetailsExport?relativePath="+locationResponseImportData);
                           
                        },
                        failure: function () {
                          Ext.example.msg("Error");
                      }
                  });
                    	
                        }
                    }
                }
					});

	var generatepanel = new Ext.Panel({
   						width: 100,
	    			 	items: [generateButton]
      			});	
var StopDetails = new Ext.Panel({
				layout:'table',
				frame: false,
				//width:screen.width-48, 
				collapsible : false,
				id: 'StopDetails',
				layoutConfig: {
						columns: 6
				},
				style:'padding-left: 2px',
				items: [{width:20},startdatepanel,{width:15},enddatepanel,{width:15},generatepanel]
			});

var p1 = new Ext.Panel({
   					width:screen.width-5,
   					layout:'table',
   					id:'p1panelid',
    				layoutConfig: {
       					columns:8
    				},
    				style:'padding-left: 10px',
	    			 	items: [{width:5},	    			 	
	    			 	{xtype:'label',
	    			 	text:'Registration No',
	    			 	id: 'assetGrouplab',
	    			 	//cls: 'bskExtStyle'
	    			 	cls: 'labelstyle'
	    			 	},{width:10},groupNameCombo,
	    			 	{width:20},
	    			 	{xtype:'label',
	    			 	text:'Trip Name',
	    			 	id:'tripNameLblId',
	    			 	hidden:true,
	    			 	//cls: 'bskExtStyle'
	    			 	cls: 'labelstyle'
	    			 	},{width:10},tripNameText
		                ]
      			});	
     
    
    
         var clientPanel = new Ext.Panel({
			 layout		 :'table',
		     title		 : '',
			 width		 : screen.width-5,
			 frame		 : false,
			 id			 : 'p2combo',
			 layoutConfig: {columns: 1},
			 items: [custPanel,{height:10},radioPanel,{height:10},p1,{height:10},StopDetails]
	 	 });  
      
          
    //-------------------------------------------------------------------------------------------------------//
    
    //---------------------------------------------------Reader-------------------------------------------------------//
     var reader = new Ext.data.JsonReader({
        idProperty: 'obdExportId',
        root: 'OBDExportReportDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNODataIndex',
            type: 'int'
        },{
        	name: 'GPSDATETIMEDataIndex'
        }, {
            name: 'ABSAMBERWARNDataIndex'
        }, {
            name: 'ABSSWITCHDataIndex'
        }, {
            name: 'ACDataIndex'
        }, {
            name: 'ACCPEDALPOSDataIndex'
        }, {
            name: 'ACCPEDALSWITCHDataIndex'
        }, {
            name: 'ACTTORQDataIndex'
        }, {
            name: 'AIRFLOWRATEDataIndex'
        }, {
            name: 'ANTILOCKBRAKEDataIndex'
        }, {
            name: 'ASRSWITCHDataIndex'
        },, {
            name: 'BRAKEPEDALDataIndex'
        }, {
            name: 'CLUTCHDataIndex'
        }, {
            name: 'COOLANTTEMPDataIndex'
        }, {
            name: 'DISTANCEMILDataIndex'
        }, {
            name: 'DISTANCESCCDataIndex'
        }, {
            name: 'DOORDataIndex'
        }, {
            name: 'DOORLOCKDataIndex'
        }, {
            name: 'DOORPDataIndex'
        }, {
            name: 'DOORRLDataIndex'
        }, {
            name: 'DOORRRDataIndex'
        }, {
            name: 'DRDEMTORQDataIndex'
        },  {
            name: 'ENGDEMTORQDataIndex'
        },{
            name: 'ENGFUELECODataIndex'
        }, {
            name: 'ENGINEBRAKEDataIndex'
        }, {
            name: 'ENGINECOOLANTPERDataIndex'
        }, {
            name: 'ENGINEINSFUELECODataIndex'
        }, {
        	name: 'ENGIMFTEMPDataIndex'
        },{
            name: 'ENGINELOADDataIndex'
        }, {
            name: 'ENGINESPEEDDataIndex'
        }, {
            name: 'FUELCONSUMEDDataIndex'
        }, {
            name: 'FUELLEVELDataIndex'
        }, {
            name: 'FUELPRESSUREDataIndex'
        }, {
            name: 'FUELRATEDataIndex'
        }, {
            name: 'FUELTEMPDataIndex'
        }, {
            name: 'HEADLIGHTDataIndex'
        }, {
            name: 'IMAPRESSUREDataIndex'
        }, {
            name: 'INAIRTEMPDataIndex'
        }, {
            name: 'ODOMETERDataIndex'
        }, {
            name: 'OILPRESSUREDataIndex'
        }, {
            name: 'PARKBRAKEDataIndex'
        }, {
            name: 'POWERINPUTDataIndex'
        }, {
            name: 'REVERSEDataIndex'
        }, {
            name: 'SEATBELTDataIndex'
        }, {
            name: 'SPEEDDataIndex'
        }, {
            name: 'VEHICLESPEEDDataIndex'
        }]
    });
 
   

    //-----------------------------------------Reader configs Ends-------------------------------------------//
    //-----------------------------------------------store---------------------------------------------------//
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/OBDAction.do?param=getDetailsofOBDVehicle',
            method: 'POST'
        }),
        remoteSort: false,        
        bufferSize: 700,
        reader: reader
    });
      
    var store1 = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/OBDAction.do?param=getOBDExcel',
            method: 'POST'
        }),
        remoteSort: false,        
      //  bufferSize: 700,
        reader: reader
    }); 
    
 
    //------------------------------------------Filters--------------------------------------------------------//
   
	var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            dataIndex: 'SLNODataIndex',
            type: 'numeric'
        }, {
        	dataIndex:'GPSDATETIMEDataIndex',
        	type: 'string'
        }, {
            dataIndex: 'ABSAMBERWARNDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ABSSWITCHDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ACDataIndex',
            type: 'string'
        }, {
            dataIndex: 'ACCPEDALPOSDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ACCPEDALSWITCHDataIndex',
            type: 'string'
        }, {
            dataIndex: 'ACTTORQDataIndex',
            type: 'float'
        }, {
            dataIndex: 'AIRFLOWRATEDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ANTILOCKBRAKEDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ASRSWITCHDataIndex',
            type: 'float'
        }, {
            dataIndex: 'BRAKEPEDALDataIndex',
            type: 'string'
        }, {
            dataIndex: 'CLUTCHDataIndex',
            type: 'string'
        }, {
            dataIndex: 'COOLANTTEMPDataIndex',
            type: 'float'
        }, {
            dataIndex: 'DISTANCEMILDataIndex',
            type: 'float'
        }, {
            dataIndex: 'DISTANCESCCDataIndex',
            type: 'float'
        }, {
            dataIndex: 'DOORDataIndex',
            type: 'string'
        }, {
            dataIndex: 'DOORLOCKDataIndex',
            type: 'string'
        }, {
            dataIndex: 'DOORPDataIndex',
            type: 'string'
        }, {
            dataIndex: 'DOORRLDataIndex',
            type: 'float'
        }, {
            dataIndex: 'DOORRRDataIndex',
            type: 'float'
        }, {
            dataIndex: 'DRDEMTORQDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ENGDEMTORQDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ENGFUELECODataIndex',
            type: 'float'
        }, {
            dataIndex: 'ENGINEBRAKEDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ENGIMFTEMPDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ENGINECOOLANTPERDataIndex',
            type: 'float'
        },{
            dataIndex: 'ENGINEINSFUELECODataIndex',
            type: 'float'
        }, {
            dataIndex: 'ENGINELOADDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ENGINESPEEDDataIndex',
            type: 'float'
        }, {
            dataIndex: 'FUELCONSUMEDDataIndex',
            type: 'float'
        }, {
            dataIndex: 'FUELLEVELDataIndex',
            type: 'float'
        }, {
            dataIndex: 'FUELPRESSUREDataIndex',
            type: 'float'
        }, {
            dataIndex: 'FUELRATEDataIndex',
            type: 'float'
        }, {
            dataIndex: 'FUELTEMPDataIndex',
            type: 'float'
        }, {
            dataIndex: 'HEADLIGHTDataIndex',
            type: 'string'
        }, {
            dataIndex: 'IMAPRESSUREDataIndex',
            type: 'float'
        }, {
            dataIndex: 'INAIRTEMPDataIndex',
            type: 'float'
        }, {
            dataIndex: 'ODOMETERDataIndex',
            type: 'float'
        }, {
            dataIndex: 'OILPRESSUREDataIndex',
            type: 'float'
        }, {
            dataIndex: 'PARKBRAKEDataIndex',
            type: 'string'
        }, {
            dataIndex: 'POWERINPUTDataIndex',
            type: 'float'
        }, {
            dataIndex: 'REVERSEDataIndex',
            type: 'float'
        }, {
            dataIndex: 'SEATBELTDataIndex',
            type: 'string'
        }, {
            dataIndex: 'SPEEDDataIndex',
            type: 'float'
        }, {
            dataIndex: 'VEHICLESPEEDDataIndex',
            type: 'float'
        }]
    });
	
    //--------------------------------------------------column Model---------------------------------------//
   
    var createColModel = function(finish, start) {
        var columns = [
            new Ext.grid.RowNumberer({
                header: '<b>Sl No</b>',
                width: 50
            }), {
                header: '<b>Sl No</b>',
                sortable: true,
               hidden:true,
                dataIndex: 'SLNODataIndex'
            }, {
                header: '<b>GPS Date Time</b>',
                //hidden: true,
                sortable: true,
               // width: 150,
                renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
              dataIndex: 'GPSDATETIMEDataIndex' ,
                filter: {
                type: 'date'
               }
            }, {
                header: '<b>Speed (Km/h)</b>',
                hidden: false,
                sortable: true,
                //width: 120,
                dataIndex: 'SPEEDDataIndex'
            }, {
                header: '<b>ABS AMBER WARN</b>',
                hidden: true,
                sortable: true,
               // width: 150,
                dataIndex: 'ABSAMBERWARNDataIndex'
            },{
                header: '<b>ABS Switch</b>',
                hidden: true,
                sortable: true,
               // width: 150,
                dataIndex: 'ABSSWITCHDataIndex'
            },{
                header: '<b>AC</b>',
                hidden: true,
                sortable: true,
               // width: 150,
                dataIndex: 'ACDataIndex'
            }, {
                header: '<b>Accelerator Pedal Position (%)</b>',
                hidden: true,
                sortable: true,
                //width: 200,
                dataIndex: 'ACCPEDALPOSDataIndex'
            }, {
                header: '<b>Accelerator Pedal Switch</b>',
                hidden: true,
                sortable: true,
                //width: 200,
                dataIndex: 'ACCPEDALSWITCHDataIndex'
            }, {
                header: '<b>Actual TORQ(nm)</b>',
                hidden: true,
                sortable: true,
                //width: 170,
                dataIndex: 'ACTTORQDataIndex'
            }, {
                header: '<b>Airflow Rate</b>',
                hidden: true,
                sortable: true,
               // width: 90,
                dataIndex: 'AIRFLOWRATEDataIndex'
            }, {
                header: '<b>Anti Lock Brake</b>',
                hidden: true,
                sortable: true,
               // width: 90,
                dataIndex: 'ANTILOCKBRAKEDataIndex'
            }, {
                header: '<b>ASR Switch</b>',
                hidden: true,
                sortable: true,
               // width: 90,
                dataIndex: 'ASRSWITCHDataIndex'
            }, {
                header: '<b>Brake Pedal</b>',
                hidden: true,
                sortable: true,
                //width: 150,
                dataIndex: 'BRAKEPEDALDataIndex'
            }, {
                header: '<b>Clutch</b>',
                hidden: true,
                sortable: true,
                //width: 140,
                dataIndex: 'CLUTCHDataIndex',
                hideable: true
            }, {
                header: '<b>Coolant Temperature (°C)</b>',
                hidden: true,
                sortable: true,
                //width: 90,
                dataIndex: 'COOLANTTEMPDataIndex'
            }, {
                header: '<b>Distance Malfunction Indicator (Km)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'DISTANCEMILDataIndex'
            }, {
                header: '<b>Distance since code cleared</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'DISTANCESCCDataIndex'
            }, {
                header: '<b>Door</b>',
                hidden: true,
                sortable: true,
               // width: 170,
                dataIndex: 'DOORDataIndex'
            }, {
                header: '<b>Door Lock</b>',
                hidden: true,
                sortable: true,
               // width: 170,
                dataIndex: 'DOORLOCKDataIndex'
            }, {
                header: '<b>Door Passanger</b>',
                hidden: true,
                sortable: true,
               // width: 120,
                dataIndex: 'DOORPDataIndex'
            }, {
                header: '<b>Door RL</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'DOORRLDataIndex'
            }, {
                header: '<b>Door RR</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'DOORRRDataIndex'
            }, {
                header: '<b>Driver Demand TORQ(nm)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'DRDEMTORQDataIndex'
            }, {
                header: '<b>Engine Demand TORQ(nm)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'ENGDEMTORQDataIndex'
            }, {
                header: '<b>Engine Fuel Economy</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'ENGFUELECODataIndex'
            }, {
                header: '<b>Engine Brake</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'ENGINEBRAKEDataIndex'
            }, {
                header: '<b>Engine Coolant Percentage (%)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'ENGINECOOLANTPERDataIndex'
            }, {
                header: '<b>Engine Instantaneous Fuel Economy (L/h)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'ENGINEINSFUELECODataIndex'
            }, {
                header: '<b>Engine IMF Temperature (L/h)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'ENGIMFTEMPDataIndex'
            }, {
                header: '<b>Engine Load (%)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'ENGINELOADDataIndex'
            }, {
                header: '<b>Engine Speed (rpm)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'ENGINESPEEDDataIndex'
            }, {
                header: '<b>Fuel Consumed (L/h)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'FUELCONSUMEDDataIndex'
            }, {
                header: '<b>Fuel Level (%)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'FUELLEVELDataIndex'
            }, {
                header: '<b>Fuel Pressure (kPa)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'FUELPRESSUREDataIndex'
            }, {
                header: '<b>Fuel Rate</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'FUELRATEDataIndex'
            }, {
                header: '<b>Fuel Temperature (°C)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'FUELTEMPDataIndex'
            }, {
                header: '<b>Head Light</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'HEADLIGHTDataIndex'
            }, {
                header: '<b>IMA Pressure (kPa)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'IMAPRESSUREDataIndex'
            }, {
                header: '<b>Intake Air Tempertature (°C)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'INAIRTEMPDataIndex'
            }, {
                header: '<b>Oil Pressure (kPa)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'OILPRESSUREDataIndex'
            }, {
                header: '<b>Odometer (Km)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'ODOMETERDataIndex'
            },  {
                header: '<b>Power Input (V)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'POWERINPUTDataIndex'
            },{
                header: '<b>Park Brake</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'PARKBRAKEDataIndex'
            }, {
                header: '<b>Reverse</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'REVERSEDataIndex'
            }, {
                header: '<b>Seat Belt</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'SEATBELTDataIndex'
            }, {
                header: '<b>Vehicle Speed (Km/h)</b>',
                hidden: true,
                sortable: true,
                //width: 120,
                dataIndex: 'VEHICLESPEEDDataIndex'
            }
        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
        };
    //---------------------------------------------------------grid-------------------------------------------//

  OBDGrid = getGridforRightIcons('OBD Report', 'No Records found', store, screen.width - 45, 400, 55, filters, 'Clear Filter Data', false, '', 50, false, '', false, '', true, 'Excel', jspName, exportDataType, false, ''); 

    //--------------------------------------------------------------------------------------------------------//

  

    var mainPanel = new Ext.Panel({
        standardSubmit: true,
        frame: true,
        //autoScroll: true,
        width: screen.width - 20,
        height: 420,
        id:'obdgridid',
        layout: 'table',
        layoutConfig: {
            columns: 2
        },
        items: [
            OBDGrid
        ]
    });



	
    Ext.onReady(function() {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.Ajax.timeout = 360000;
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '',
            renderTo: 'content',
            standardSubmit: true,
            autoScroll: false,
            frame: true,
            border: false,
            id: 'outer',
            layout: 'table',
            width: 1360,
            height: 600,
            cls: 'outerpanel',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, mainPanel]
        });
       
        //OBDGrid.show();
        OBDGrid.hide();
         var cm = OBDGrid.getColumnModel();
        for (var j = 1; j < cm.getColumnCount(); j++) {
            cm.setColumnWidth(j, 150);
        }
       // vehiclePanel.hide();
    });
    
--></script>
  </body>
<jsp:include page="../Common/footer.jsp" />
	<!-- </body>   -->
<!-- </html> -->
 
<%}%>
