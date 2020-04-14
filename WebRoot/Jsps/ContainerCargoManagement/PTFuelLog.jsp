<%@ page  language="java" import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
	String currency = cf.getCurrency(systemId);
	
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Fuel_Log_Book");
tobeConverted.add("Select_Vehicle");
tobeConverted.add("Vehicle_Number");
tobeConverted.add("Select_Vehicle_Number");
tobeConverted.add("SLNO");
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Select_Start_Date");
tobeConverted.add("Select_End_Date");
tobeConverted.add("View");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Date");
tobeConverted.add("Vendor_Name");
tobeConverted.add("Fuel_Rate"); 
tobeConverted.add("Refill_Quantity");
tobeConverted.add("Refill_Amount");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Excel");
tobeConverted.add("Fuel_Log_Book_Title");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Add");
tobeConverted.add("Fuel_Vendor");
tobeConverted.add("Net_Price");
tobeConverted.add("Enter_Quantity");
tobeConverted.add("Select_Fuel_Vendor");
tobeConverted.add("Enter_Refill_Quantity");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Available_Fuel");
tobeConverted.add("Reset_Fuel");
tobeConverted.add("Reset_By");
tobeConverted.add("Enter_Reset_Fuel");
tobeConverted.add("Please_Enter_Reset_Fuel_Less_Than_Available_Fuel");

ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);

String FuelLogBook=convertedWords.get(0);
String SelectVehicle=convertedWords.get(1);
String VehicleNo=convertedWords.get(2);
String SelectVehicalNo=convertedWords.get(3);
String slno=convertedWords.get(4);
String FromDate=convertedWords.get(5);
String ToDate=convertedWords.get(6);
String SelectStartDate=convertedWords.get(7);
String SelectEndDate=convertedWords.get(8);
String View=convertedWords.get(9);
String startDateEndDateValication=convertedWords.get(10);
String monthValidation=convertedWords.get(11);	
String Date=convertedWords.get(12);	
String VendorName=convertedWords.get(13);
String FuelRate=convertedWords.get(14);
String RefillQuantity=convertedWords.get(15);
String RefillAmount=convertedWords.get(16);
String NoRecordsFound=convertedWords.get(17);
String ClearFilterData=convertedWords.get(18);
String Excel=convertedWords.get(19);
String FuelLogBookTitle=convertedWords.get(20);
String Save=convertedWords.get(21);
String Cancel=convertedWords.get(22);
String Add=convertedWords.get(23);
String FuelVendor=convertedWords.get(24);
String NetPrice=convertedWords.get(25);
String EnterQuantity=convertedWords.get(26);
String SelectFuelVendor=convertedWords.get(27);
String EnterRefillQuantity=convertedWords.get(28);
String vehicleNo=convertedWords.get(29);
String availableFuel = convertedWords.get(30);
String resetFuel = convertedWords.get(31);
String resetBy = convertedWords.get(32);
String EnterFuelReset = convertedWords.get(33);
String PleaseEnterResetFuelLessThanAvailableFuel = convertedWords.get(34);

%>
<jsp:include page="../Common/header.jsp" />
    <title><%=FuelLogBook%></title>

  <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	#addbuttonid{
	margin-top: -9px !important ;
	}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
    <!-- for exporting to excel***** -->
   <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			label {
				display : inline !important;
			}
			.x-window-tl *.x-window-header {
				height : 42px !important;
			}
		 </style>
    
    <script>
    var outerPanel;
 	var ctsb;
 	var dtprev = previousDate;
 	var dtcur = currentDate;
 	var jspName="FuelLogBook";
 	var jspNameFuelReset = "FuelReset";
 	var exportDataType="int,string,date,string,string,number,number";
 	var exportDataTypeFuelReset="int,string,date,number,number,string";
 	var selected;
 	var grid;
 	var buttonValue;
 	var titel;
 	var globalCustomerID=parent.globalCustomerID;
 	var myWin;
 	var netprice;
 	var amount;
 	var regex = new RegExp("^[0-9]*$");
 	var tripNumber = '';
 	var availFuelCharges = 0;
 	
 	//override function for showing first row in grid
 	Ext.override(Ext.grid.GridView, {
    	afterRender: function(){
        this.mainBody.dom.innerHTML = this.renderRows();
        this.processRows(0, true);
        if(this.deferEmptyText !== true){
            this.applyEmptyText();
        }
        this.fireEvent("viewready", this);//new event
    	}   
	});
	 //***** vehicle combo *******		
	var allVehicleStore= new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PTFuelLogAction.do?param=getVehiclesAll',
        id: 'vehicleStoreId',
	    root: 'allVehicleStoreRoot',
	    autoload: true,
	    remoteSort: true,
	    fields: ['VehicleNo']
	});
	
	var vehicleStore= new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PTFuelLogAction.do?param=getVehicles',
	    root: 'vehicleStoreRoot',
	    autoload: true,
	    remoteSort: true,
	    fields: ['VehicleNo']
	});
	
	var fuelResetVehicleStore= new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PTFuelLogAction.do?param=getVehiclesNotInTrip',
	    root: 'fuelResetVehicleStoreRoot',
	    autoload: true,
	    remoteSort: true,
	    fields: ['VehicleNo']
	});
	
	 //***** available fuel store *******		
	var availableFuelStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PTFuelLogAction.do?param=getAvailableFuel',
	    root: 'availFuelStoreRoot',
	    autoload: true,
	    remoteSort: true,
	    fields: ['tripNo','availFuelInLtrs','availFuelCost']
	});
	  var vehiclecombo = new Ext.form.ComboBox({
        store: allVehicleStore,
        id: 'vehiclecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectVehicle%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'VehicleNo',
        displayField: 'VehicleNo',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	                vehId = Ext.getCmp('vehiclecomboId').getValue();
	                
	                summaryGrid.store.clearData();
  		            summaryGrid.view.refresh();
	            }
	        }
	    }
	});	
	var windowvehiclecombo = new Ext.form.ComboBox({
        store: vehicleStore,
        id: 'windowvehiclecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectVehicle%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'VehicleNo',
        displayField: 'VehicleNo',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	            	
	            }
	        }
	    }
	});
	
		var assetCombo = new Ext.form.ComboBox({
        store: fuelResetVehicleStore,
        id: 'assetComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectVehicle%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'VehicleNo',
        displayField: 'VehicleNo',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	            	fuelResetPanelWindow.getEl().mask('Loading...');
	            	availableFuelStore.load({params:{
	            		assetNo: Ext.getCmp('assetComboId').getValue()
	            	},
	            	callback: function() {
	            		var rec = availableFuelStore.getAt(0);
	            		if(rec != null){
	            			Ext.getCmp('availableFuelText').setValue(rec.data['availFuelInLtrs']);
	            			tripNumber = rec.data['tripNo'];
 							availFuelCharges = rec.data['availFuelCost'];
	            		}
	            		fuelResetPanelWindow.getEl().unmask();
	            	}
	            	});
	            }
	        }
	    }
	});
	//***** Fuel Vendor combo *******		
	  var fuelvendorStore= new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/PTFuelLogAction.do?param=getFuelVendor',
        id: 'fuelvendorStoreId',
		root: 'FuelVendorStoreRoot',
		autoload: false,
		remoteSort: true,
		fields: ['VendorName','VendorId', 'fuelRate']
	});
	  var fuelvendorcombo = new Ext.form.ComboBox({
        store: fuelvendorStore,
        id: 'fuelvendorcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Vendor Name',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'VendorId',
        displayField: 'VendorName',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	            	var row = fuelvendorStore.find('VendorId',Ext.getCmp('fuelvendorcomboId').getValue());
					var record = fuelvendorStore.getAt(row);
					netprice = record.data['fuelRate'];
					
					amount = netprice * Ext.getCmp('refillqutid').getValue();
					Ext.getCmp('NetPriceid').setText(netprice+' ('+'<%=currency%>'+')');
					Ext.getCmp('RefillAmtid').setText(amount+' ('+'<%=currency%>'+')');
	            }
	        }
	    }
	});	

	//********* innerPanel ********		
	var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'fuelMaster',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 15
        },
        items: [{width:30},
        		{
                xtype: 'label',
                text: '<%=VehicleNo%>' + ' :',
                cls: 'labelstyle',
                id: 'vehiclelab'
               
            	},
            	{width:10},
            	vehiclecombo,
     			{width:85},
			    {
			    xtype: 'label',
			    text : '<%=FromDate%>' + ' :',
			    cls: 'labelstyle',
			    id: 'startdatelab',
			    width:60
			    },{width:10},
			    {
  		            xtype: 'datefield',
  		            cls: 'selectstylePerfect',
  		            width: 185,
  		            format: getDateTimeFormat(),
  		            emptyText: '<%=SelectStartDate%>',
  		            allowBlank: false,
  		            blankText: '<%=SelectStartDate%>',
  		            id: 'startdate',
  		            value: dtprev,
  		            vtype: 'daterange',
  		            endDateField: 'enddate'
  		        },{width:85},
			    {
			    xtype: 'label',
			    text : '<%=ToDate%>' + ':',
			    cls: 'labelstyle',
			    id: 'enddatelab',
			    width:60
			    },{width:10},
			    {
  		            xtype: 'datefield',
  		            cls: 'selectstylePerfect',
  		            width: 185,
  		            format: getDateTimeFormat(),
  		            emptyText: '<%=SelectEndDate%>',
  		            allowBlank: false,
  		            blankText: '<%=SelectEndDate%>',
  		            id: 'enddate',
  		            value: dtcur,
  		            vtype: 'daterange',
  		            startDateField: 'startdate'
  		        },{width:95},
			    { 
			    	xtype:'button',
			    	text:'<%=View%>',
			    	id: 'addbuttonid',
			    	width:80,
			    	hidden:false,
			    	listeners: 
	       			{
		        		click:
		        		{
			       			fn:function()
			       			{
				   			 	if(Ext.getCmp('vehiclecomboId').getValue() == "" )
							    {
						                 Ext.example.msg("<%=SelectVehicalNo%>");
						                 Ext.getCmp('vehiclecomboId').focus();
				                      	 return;
							    }
							    if(Ext.getCmp('startdate').getValue() == "" )
							    {
						             Ext.example.msg("<%=SelectStartDate%>");
						             Ext.getCmp('startdate').focus();
				                     return;
							    }
							    if(Ext.getCmp('enddate').getValue() == "" )
							    {
						             Ext.example.msg("<%=SelectEndDate%>");
						             Ext.getCmp('enddate').focus();
				                     return;
							    }
							    
							    var startdates=Ext.getCmp('startdate').getValue();
            		 			var enddates=Ext.getCmp('enddate').getValue();
            		 			
            		 			var d1 = new Date(startdates);
            		 			var d2 = new Date(enddates);
            		 			
               		 			if(d1>d2)
            		 			{
										Ext.example.msg("<%=startDateEndDateValication%>");
										return;
								}	
								
								if (checkMonthValidation(startdates, enddates)) {
  		                           Ext.example.msg("<%=monthValidation%>");
  		                           Ext.getCmp('enddate').focus();
  		                           return;
  		                        }
            		 						
				       			FuelLogStore.load({
				                        params: {
				                            vehId: Ext.getCmp('vehiclecomboId').getValue(),
				                            startDate: Ext.getCmp('startdate').getValue(),
                            				endDate:Ext.getCmp('enddate').getValue(),
                            				jspName: jspName
                       				}
				                });
				                FuelResetStore.load({
				                        params: {
				                            vehId: Ext.getCmp('vehiclecomboId').getValue(),
				                            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d H:i:s'),
                            				endDate:Ext.getCmp('enddate').getValue().format('Y-m-d H:i:s'),
                            				jspNameFuelReset: jspNameFuelReset
                       				}
				                });
			       			}
	       				}
       				}
			    }	
        	]
   		 }); // End of innerPanel 
   	//********************************************* Inner Pannel Window **************************************************************************************	 
   
   	var innerPanelWindow = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: false,
        height: 260,
        width: '100%',
        frame: true,
        id: 'custMaster',
        layout: 'table',
        layoutConfig: {
            columns: 5
        },
         items: [
         	{
                cls: 'mandatoryfield'
            },{
                cls: 'labelstyle'
            },{
                cls: 'labelstyle'
            },{},{},
         	{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorydate'
            	},
            {
                xtype: 'label',
                text: '<%=Date%>'+' :',
                cls: 'labelstyle',
                id: 'DateValuetxt'
            },
            {
            	xtype: 'datefield', 
            	cls: 'selectstylePerfect', 
            	id: 'DateValueid',
            	editable:false,
  		        format: getDateTimeFormat(),
  		        allowBlank: false,
  		        value: dtcur,
  		        vtype: 'daterange',
            	
            },{},{},
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryveh'
            	},
            {
                xtype: 'label',
                text: '<%=VehicleNo%>'+' :',
                cls: 'labelstyle',
                id: 'Vehicletxt'
            },windowvehiclecombo,
            {},{},
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryvendor'
            	},
            {
                xtype: 'label',
                text: '<%=FuelVendor%>'+' :',
                cls: 'labelstyle',
                id: 'FuelVendortxt'
            },fuelvendorcombo,
            {
                xtype: 'label',
                text: '<%=NetPrice%> :',
                cls: 'labelstyle',
                id: 'NetPricetxt'
            },{
				xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'NetPriceid'            
            },
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryQty'
            	},
            {
                xtype: 'label',
                text: '<%=RefillQuantity%>'+' :',
                cls: 'labelstyle',
                id: 'RefillQtytxt'
            },{
                xtype: 'numberfield',
                cls: 'textrnumberstyle',
                maskRe: /([0-9]+)$/,
                id: 'refillqutid',
                emptyText: '<%=EnterQuantity%>',
                blankText: '<%=EnterQuantity%>',
                listeners: {
                change: function(field, newValue, oldValue) {
                   if(!regex.test(Ext.getCmp('refillqutid').getValue()))
				    {
			                 Ext.example.msg("Enter Numeric value only");
			                 Ext.getCmp('refillqutid').focus();
	                      	 return;
				    }
                  amount = netprice*newValue;
                  Ext.getCmp('RefillAmtid').setText(amount+' ('+'<%=currency%>'+')');
                }
            }
            },
            {
            	xtype: 'label',
                text: '(Litres)',
                cls: 'labelstyle',
                id: 'litertxt'	
            },{},
            {
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryamt'
            	},
            {
                xtype: 'label',
                text: '<%=RefillAmount%>'+' :',
                cls: 'labelstyle',
                id: 'RefillAmttxt'
            },
            {
            	xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'RefillAmtid'
            }
            
        ]
       
    }); 
   		   
     var winButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 50,
        width: '100%',
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons:[{
            xtype: 'button',
            text: '<%=Save%>',
            id: 'addButtId',
            iconCls:'savebutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: 
	       	{
		     click:
		      {
			  fn:function()
			   {
				if(Ext.getCmp('windowvehiclecomboId').getValue() == "" )
				{
					Ext.example.msg("<%=SelectVehicalNo%>");
					Ext.getCmp('windowvehiclecomboId').focus();
				    return;
				}
					if(Ext.getCmp('fuelvendorcomboId').getValue() == "" )
					{
						Ext.example.msg("<%=SelectFuelVendor%>");
						Ext.getCmp('fuelvendorcomboId').focus();
				        return;
					}
						if(Ext.getCmp('refillqutid').getValue() == "" || Ext.getCmp('refillqutid').getValue() == "0")
						{
						  Ext.example.msg("<%=EnterRefillQuantity%>");
						  Ext.getCmp('refillqutid').focus();
				          return;
						}
						outerPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PTFuelLogAction.do?param=saveFuelLog',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                fuelVendorName: Ext.getCmp('fuelvendorcomboId').getRawValue(),
                                dateVal: Ext.getCmp('DateValueid').getValue(),
                                vhitxt: Ext.getCmp('windowvehiclecomboId').getValue(),
                                fuelVendorId: Ext.getCmp('fuelvendorcomboId').getValue(),                              
                                netPrice: netprice,                              
                                refillQty:Ext.getCmp('refillqutid').getValue(),
								refillAmt:amount
                                
                            },
                            success: function (response, options) {
                                var str=response.responseText;
								var array = str.split(",");
								var message = array[0];
								var groupid = array[1];
				       	  		FuelLogStore.load({
				          			params: {
				            			vehId: Ext.getCmp('vehiclecomboId').getValue(),
				            			startDate: Ext.getCmp('startdate').getValue(),
                            			endDate:Ext.getCmp('enddate').getValue(),
                            			jspName:jspName
                       	    				}
				       			});
				       			FuelResetStore.load({
				                        params: {
				                            vehId: Ext.getCmp('vehiclecomboId').getValue(),
				                            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d H:i:s'),
                            				endDate:Ext.getCmp('enddate').getValue().format('Y-m-d H:i:s'),
                            				jspNameFuelReset: jspNameFuelReset
                       				}
				                });
				       		Ext.example.msg(message);
                                outerPanelWindow.getEl().unmask();  
                                myWin.hide();

                            },
                            failure: function () {

                                Ext.example.msg("Error");
                                outerPanelWindow.getEl().unmask();  
                                myWin.hide();
                            }
                            
                        });
			       }
	       	   }
       	    }
        }, {
            xtype: 'button',
            text: '<%=Cancel%>',
            id: 'canButtId',
            iconCls:'cancelbutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function () {
                        myWin.hide();
						
                    }
                }
            }
        }]

    });
   		 
   	 var outerPanelWindow = new Ext.Panel({
        width: '100%',
        height:330,
        standardSubmit: true,
        frame: false,
        items: [innerPanelWindow, winButtonPanel]
    });
    	 
   	 myWin = new Ext.Window({
        title: titel,
        closable: false,
        resizable:false,
        modal: true,
        autoScroll: false,
        height: 365,
        width: '40%',
        id: 'myWin',
        items: [outerPanelWindow]
    });	 
   
   		 
   	//*************************************************Function for ADD button**************************************************************************

   function addRecord() {
		Ext.getCmp('DateValueid').setValue(new Date);
        buttonValue = "add";
        titel = 'Add Fuel Log';
        myWin.show();
        myWin.setTitle(titel);
        fuelvendorStore.load();
        Ext.getCmp('DateValuetxt').show();
        Ext.getCmp('Vehicletxt').show();
        Ext.getCmp('FuelVendortxt').show();
        Ext.getCmp('NetPricetxt').show();
        Ext.getCmp('RefillQtytxt').show();
        Ext.getCmp('RefillAmttxt').show();
        Ext.getCmp('windowvehiclecomboId').reset();
        Ext.getCmp('fuelvendorcomboId').reset();
        Ext.getCmp('NetPriceid').setText('');
        Ext.getCmp('refillqutid').setValue('');
        Ext.getCmp('RefillAmtid').setText('');
        
   }		
		//============================ Grid table creation ================================
		//********** reader *************
     	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'FuelLogRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{ 
        	name: 'VehicleNoIndex'
        },{
            name: 'dateIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        }, {
            name: 'vendorNameIndex'
        }, {
            name: 'fuelRateIndex'
        }, {
            name: 'refillQtyIndex'
        }, {
            name: 'refillAmountIndex'
        }]
    });
		//********** store *****************
		var FuelLogStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           	url: '<%=request.getContextPath()%>/PTFuelLogAction.do?param=getFuelLogData',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'darstore',
        reader: reader
    	});
    	
		//*********** filters **********
		var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'VehicleNoIndex'
        },{
            type: 'date',
            dataIndex: 'dateIndex'
        }, {
            type: 'string',
            dataIndex: 'vendorNameIndex'
        }, {
            type: 'int',
            dataIndex: 'fuelRateIndex'
        }, {
            type: 'float',
            dataIndex: 'refillQtyIndex'
        }, {
            type: 'float',
            dataIndex: 'refillAmountIndex'
        }]
      });
		
		//************************************Column Model Config******************************************
    	var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=slno%></span>",
                width: 50
            }),{
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=slno%></span>",
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=vehicleNo%></span>",
                dataIndex: 'VehicleNoIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
        		header: "<span style=font-weight:bold;><%=Date%></span>",
           	 	dataIndex: 'dateIndex',
            	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            	filter: {
            	type: 'date'
            	}
        	}, {
                header: "<span style=font-weight:bold;><%=VendorName%></span>",
                dataIndex: 'vendorNameIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=FuelRate%></span>",
                dataIndex: 'fuelRateIndex',
                width: 100,
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=RefillQuantity%></span>",
                dataIndex: 'refillQtyIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=RefillAmount%></span>",
                dataIndex: 'refillAmountIndex',
                filter: {
                    type: 'numeric'
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
	//***************** getGrid1 ****************************	
	summaryGrid = getGrid('', '<%=NoRecordsFound%>', FuelLogStore, screen.width - 35, 225, 10, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, 'PDF',true,'<%=Add%>');
	
//============================ fuel reset Grid details ================================
			
//********************************************* Inner Panel Window for Fuel Reset **************************************************************************************
	var fuelResetInnerPanelWindow = new Ext.Panel({
        standardSubmit: false,
        collapsible: false,
        autoScroll: false,
        height: 180,
        width: '100%',
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
         items: [
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryvehicleId'
            },
            {
                xtype: 'label',
                text: '<%=VehicleNo%>'+' :',
                cls: 'labelstyle',
                id: 'assetNo'
            },assetCombo,{width:10},
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryAvailFuelId'
            },
            {
                xtype: 'label',
                text: '<%=availableFuel%>'+' :',
                cls: 'labelstyle',
                id: 'availableFuelLabel'
            },{
            	xtype: 'textfield',
                text: 'ltrs',
                readOnly: true,
                cls: 'textrnumberstyle',
                id: 'availableFuelText'
            },{
				xtype: 'label',
                text: 'ltrs',
                cls: 'labelstyle'         
            },
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'resetFuelMandatory'
            },
            {
                xtype: 'label',
                text: '<%=resetFuel%> :',
                cls: 'labelstyle',
                id: 'resetFuelLabel'
            },{
				xtype: 'numberfield',
                cls: 'textrnumberstyle',
                id: 'resetFuelText'            
            },{
				xtype: 'label',
                text: 'ltrs',
                cls: 'labelstyle',
                id: 'ltrsText'            
            }
        ]
       
    }); 	
    
    var fuelResetButtonPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 50,
        width: '100%',
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons:[{
            xtype: 'button',
            text: '<%=Save%>',
            id: 'fuelResetButtId',
            iconCls:'savebutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: 
	       	{
		     click:
		      {
			  fn:function()
			   {
				if(Ext.getCmp('assetComboId').getValue() == "" )
				{
					Ext.example.msg("<%=SelectVehicalNo%>");
					Ext.getCmp('assetComboId').focus();
				    return;
				}
				if(Ext.getCmp('resetFuelText').getValue() == "" )
				{
				  Ext.example.msg("<%=EnterFuelReset%>");
				  Ext.getCmp('resetFuelText').focus();
		          return;
				}
				if(Ext.getCmp('resetFuelText').getValue() > Ext.getCmp('availableFuelText').getValue())
				{
				  Ext.example.msg("<%=PleaseEnterResetFuelLessThanAvailableFuel%>");
				  Ext.getCmp('resetFuelText').focus();
		          return;
				}
				fuelResetPanelWindow.getEl().mask();
                Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PTFuelLogAction.do?param=saveFuelReset',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                assetNo: Ext.getCmp('assetComboId').getValue(),
                                resetFuel: Ext.getCmp('resetFuelText').getValue(),
								availFuel: Ext.getCmp('availableFuelText').getValue(),
		            			tripNo: tripNumber,
 								availFuelCost: availFuelCharges 
                            },
                            success: function (response, options) {
                                var msg = response.responseText;
                                if(msg == "Error"){
                                	Ext.example.msg("Error");
                                } else if(msg == "Success"){
                                	Ext.example.msg("Saved successfully");
                                }else {
                                	Ext.example.msg(msg);
                                }
				       	  		FuelLogStore.load({
				          			params: {
				            			vehId: Ext.getCmp('vehiclecomboId').getValue(),
				            			startDate: Ext.getCmp('startdate').getValue(),
                            			endDate:Ext.getCmp('enddate').getValue(),
                            			jspName: jspName
                       	    		}
				       			});
					       		FuelResetStore.load({
				                        params: {
				                            vehId: Ext.getCmp('vehiclecomboId').getValue(),
				                            startDate: Ext.getCmp('startdate').getValue().format('Y-m-d H:i:s'),
                            				endDate:Ext.getCmp('enddate').getValue().format('Y-m-d H:i:s'),
                            				jspNameFuelReset: jspNameFuelReset
                       				}
				                });
	                            fuelResetPanelWindow.getEl().unmask();  
	                            fuelResetWin.hide();

                            },
                            failure: function () {
                                Ext.example.msg("Error");
                                fuelResetPanelWindow.getEl().unmask();  
                                fuelResetWin.hide();
                            }
                            
                        });
			       }
	       	   }
       	    }
        }, {
            xtype: 'button',
            text: '<%=Cancel%>',
            iconCls:'cancelbutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function () {
                        fuelResetWin.hide();
						
                    }
                }
            }
        }]

    });
	var notePanel = new Ext.Panel({
		standardSubmit: false,
		collapsible: false,
		autoScroll: false,
		height: 50,
		width: '100%',
		frame: true,
		layout: 'table',
		layoutConfig: {
			columns: 2
		},
		 items: [
			{
				xtype:'label',
				text:'* ',
				cls:'mandatoryfield'
			},
			{
				xtype: 'label',
				text: "Note : Vehicles which are on trip won't be available for fuel reset.",
				cls: 'labelstyle'
			}
		]
	}); 
   	var fuelResetPanelWindow = new Ext.Panel({
        width: '100%',
        height:330,
        standardSubmit: true,
        frame: false,
        items: [fuelResetInnerPanelWindow,notePanel,fuelResetButtonPanel]
    });
    	 
   	var fuelResetWin = new Ext.Window({
        title: 'Fuel Reset',
        closable: false,
        resizable:false,
        modal: true,
        autoScroll: false,
        height: 365,
        width: '40%',
        id: 'fuelResetWin',
        items: [fuelResetPanelWindow]
    });	 	
    		
	function modifyData(){
		buttonValue='modify';
		title='<%=resetFuel%>';
		fuelResetWin.setTitle(title);
		fuelResetWin.show();
		Ext.getCmp('assetComboId').setValue("");
		Ext.getCmp('availableFuelText').setValue('');
		Ext.getCmp('resetFuelText').setValue('');
	} 
 
		//********** reader *************
     	var fuelResetReader = new Ext.data.JsonReader({
        root: 'FuelResetRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{ 
        	name: 'assetNoIndex'
        },{
            name: 'resetDateIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        }, {
            name: 'availableFuelIndex'
        }, {
            name: 'resetFuelIndex'
        }, {
            name: 'resetByIndex'
        }]
    });
		//********** store *****************
		var FuelResetStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           	url: '<%=request.getContextPath()%>/PTFuelLogAction.do?param=getFuelResetData',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'fuelResetStoreId',
        reader: fuelResetReader
    	});
    	
		//*********** filters **********
		var fuelResetFilters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'assetNoIndex'
        },{
            type: 'date',
            dataIndex: 'resetDateIndex'
        }, {
            type: 'float',
            dataIndex: 'availableFuelIndex'
        }, {
            type: 'float',
            dataIndex: 'resetFuelIndex'
        }, {
            type: 'string',
            dataIndex: 'resetByIndex'
        }]
      });
		
		//************************************Column Model Config******************************************
    	var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=slno%></span>",
                width: 50
            }),{
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=slno%></span>",
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=vehicleNo%></span>",
                dataIndex: 'assetNoIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            }, {
        		header: "<span style=font-weight:bold;><%=Date%></span>",
           	 	dataIndex: 'resetDateIndex',
            	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            	filter: {
            	type: 'date'
            	}
        	}, {
                header: "<span style=font-weight:bold;><%=availableFuel%></span>",
                dataIndex: 'availableFuelIndex',
                width: 100,
                filter: {
                    type: 'float'
                }
            }, {
                header: "<span style=font-weight:bold;><%=resetFuel%></span>",
                dataIndex: 'resetFuelIndex',
                width: 100,
                filter: {
                    type: 'float'
                }
            }, {
                header: "<span style=font-weight:bold;><%=resetBy%></span>",
                dataIndex: 'resetByIndex',
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
	//***************** getGrid ****************************	
	fuelResetGrid = getGrid1('<%=resetFuel%>', '<%=NoRecordsFound%>', FuelResetStore, screen.width - 35, 200, 7, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspNameFuelReset, exportDataTypeFuelReset, true, 'PDF',false,'<%=Add%>', true, '<%=resetFuel%>');
	
	//fule reste grid end
	
	//*****main starts from here*************************
 	Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'<%=FuelLogBook%>',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			cls:'outerpanel',
			border:false,
			items: [innerPanel,summaryGrid,fuelResetGrid]  
			//bbar:ctsb			
			}); 
			vehicleStore.load();
			fuelResetVehicleStore.load();
			allVehicleStore.load();
			
	}); 
    </script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
