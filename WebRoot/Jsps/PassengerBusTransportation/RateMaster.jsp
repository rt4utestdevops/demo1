<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	
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
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		loginInfo.setStyleSheetOverride("N");
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		session.setAttribute("loginInfoDetails", loginInfo);

	}

	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request,response);
	String responseaftersubmit = "''";
	String feature = "1";
	if (session.getAttribute("responseaftersubmit") != null) {
		responseaftersubmit = "'"+ session.getAttribute("responseaftersubmit").toString() + "'";
		session.setAttribute("responseaftersubmit", null);
	}

	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
	ArrayList<String> tobeConverted = new ArrayList<String>();

	tobeConverted.add("Rate_Master");
	tobeConverted.add("Rate_Master_Details");
	tobeConverted.add("Select_Customer");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Day_Type");
	tobeConverted.add("Terminal_Name");
	tobeConverted.add("Terminal_ID");
	tobeConverted.add("Route_Name");
	tobeConverted.add("Route_Id");
	tobeConverted.add("Distance(KMs)");
	tobeConverted.add("Duration(HH:MM)");
	tobeConverted.add("Departure(HH:MM)");
	tobeConverted.add("Arrival(HH:MM)");
	tobeConverted.add("Vehicle_Model");
	tobeConverted.add("Vehicle_Model_Id");
	tobeConverted.add("Seating_Structure");
	tobeConverted.add("Seating_Structure_Id");
	tobeConverted.add("Rate");
	tobeConverted.add("Status");
	tobeConverted.add("Save");
	tobeConverted.add("Cancel");
	tobeConverted.add("Modify");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("SLNO");
	tobeConverted.add("Rate_Id");
	tobeConverted.add("No_Rows_Selected");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	tobeConverted.add("Add");
	tobeConverted.add("Select_Day_Type");
	tobeConverted.add("Select_Terminal_Name");
	tobeConverted.add("Select_Route_Name");
	tobeConverted.add("Enter_Departure");
	tobeConverted.add("Select_Status");
	tobeConverted.add("Invalid_Departure");
	tobeConverted.add("Select_Vehicle_Model");
	tobeConverted.add("Select_Seating_Capacity");
	tobeConverted.add("Enter_Amount");
	tobeConverted.add("Add_Details");
	tobeConverted.add("Modify_Details");
	tobeConverted.add("Error");
	tobeConverted.add("Weekday_Holiday");
	tobeConverted.add("Enter_Arrival_Time");
	tobeConverted.add("Invalid_Arrival");
	tobeConverted.add("No_Field_Has_Changed_To_Save");
	
	ArrayList<String> convertedWords = new ArrayList<String>();
	convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

	String RateMaster = convertedWords.get(0);
	String RateMasterDetails = convertedWords.get(1);
	String SelectCustomerName = convertedWords.get(2);
	String CustomerName = convertedWords.get(3);
	String DayType = convertedWords.get(4);
	String Terminal = convertedWords.get(5);
	String TerminalId = convertedWords.get(6);
	String RouteName = convertedWords.get(7);
	String RouteId = convertedWords.get(8);
	String Distance = convertedWords.get(9);
	String Duration = convertedWords.get(10);
	String Departure = convertedWords.get(11);
	String Arrival = convertedWords.get(12);
	String VehicleModel = convertedWords.get(13);
	String VehicleModelId = convertedWords.get(14);
	String SeatingStructure = convertedWords.get(15);
	String SeatingStructureId = convertedWords.get(16);
	String Rate = convertedWords.get(17);
	String Status = convertedWords.get(18);
	String Save = convertedWords.get(19);
	String Cancel = convertedWords.get(20);
	String Modify = convertedWords.get(21);
	String ClearFilterData = convertedWords.get(22);
	String NoRecordsFound = convertedWords.get(23);
	String SLNO = convertedWords.get(24);
	String RATEID = convertedWords.get(25);
	String NoRowsSelected = convertedWords.get(26);
	String SelectSingleRow = convertedWords.get(27);
	String Excel = convertedWords.get(28);
	String PDF = convertedWords.get(29);
	String Add = convertedWords.get(30);
	String SelectDay = convertedWords.get(31);
	String SelectTerminalName = convertedWords.get(32);
	String SelectRouteName = convertedWords.get(33);
	String EnterDeparture = convertedWords.get(34);
	String SelectStatus = convertedWords.get(35);
	String InvalidDeparture = convertedWords.get(36);
	String SelectVehicleModel = convertedWords.get(37);
	String SelectSeatingCapacity = convertedWords.get(38);
	String EnterAmount = convertedWords.get(39);
	String AddDetails = convertedWords.get(40);
	String ModifyDetails = convertedWords.get(41);
	String Error = convertedWords.get(42);
	String WeekDayHoliday = convertedWords.get(43);
	String EnterArrival = convertedWords.get(44);
	String InvalidArrival = convertedWords.get(45);
	String NoChanges = convertedWords.get(46);
%>

<jsp:include page="../Common/header.jsp" />
 	<title><%=RateMaster%></title>
<style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	
		
</style>

  
   	<%
      		if (loginInfo.getStyleSheetOverride().equals("Y")) {
      	%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%
		} else {
	%>
	<jsp:include page="../Common/ImportJS.jsp" /><%
		}
	%>
    <jsp:include page="../Common/ExportJS.jsp" />
	<style>

		
	
	.x-form-text {
			height: 26px !important;
		}
		
			label
		{
			display : inline !important;
		}
		.ext-strict .x-form-text 
		{
			height : 21px !important;
		}
		
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
		}
		</style>
<script>
	var outerPanel;
	var ctsb;
	var jspName = "RateMaster";
	var exportDataType = "int,int,string,int,string,int,string,double,double,double,double,int,string,int,string,double,string";
	var selected;
	var grid;
	var buttonValue;
	var titelForInnerPanel;
	var myWin;

	var clientcombostore = new Ext.data.JsonStore({
    					   url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    					   id: 'CustomerStoreId',
    					   root: 'CustomerRoot',
    					   autoLoad: true,
    					   remoteSort: true,
    					   fields: ['CustId', 'CustName'],
    					   listeners: {
        				   load: function (custstore, records, success, options) {
            			   	    if ( <%=customerId%> > 0) {
                					Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                					custId = Ext.getCmp('custcomboId').getValue();
                					TerminalStore.load({
                     					params: {
                         					CustId: custId
                     					}
                 					});
                 					VehicleModelStore.load({
                 					      params: {
                 					          CustId: custId
                 					      }
                 					});
                 					SeatingCapacityStore.load({
                 	  						params: {
                 								CustId: custId
                 	  						}
                 					});
                 				   store.load({
                                       params: {
                                          CustId: Ext.getCmp('custcomboId').getValue(),
 		                                  jspName:jspName
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
    emptyText: '<%=SelectCustomerName%>',
    blankText: '<%=SelectCustomerName%>',
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
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                
                store.load({
                         params: {
                             CustId: Ext.getCmp('custcomboId').getValue(),
 		                     jspName:jspName
                         }
                });
                
                TerminalStore.load({
                     params: {
                         CustId: custId
                     }
                 });
                 VehicleModelStore.load({
                 	  params: {
                 		CustId: custId
                 	  }
                 });
                 SeatingCapacityStore.load({
                 	  params: {
                 		CustId: custId
                 	  }
                 });
            }
        }
      }
	});
	var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 40,
    height: 40,
    layoutConfig: {
        columns: 20
    },
    items: [{
            	xtype: 'label',
            	text: '<%=CustomerName%>' + ' :',
            	cls: 'labelstyle'
        	},
        	Client,{width:30}
    	   ]
	});

	  	var DayTypeStore = [['Weekday','Weekday'],['Weekend','Weekend'],['Holiday','Holiday']];   
	  	
		var DayTypeStore = new  Ext.data.SimpleStore({
			       	   data:DayTypeStore,
				       fields: ['HoliDayId','HoliDay']
	  	});
	
		var DayTypeCombo = new Ext.form.ComboBox({
	  	frame:true,
	 	store: DayTypeStore,
	 	id:'DayTypeId',
	 	width: 150,
	 	cls: 'selectstylePerfect',
	 	hidden:false,
	 	anyMatch:true,
	 	onTypeAhead:true,
	 	forceSelection:true,
	 	enableKeyEvents:true,
	 	mode: 'local',
	 	value:'Weekday',
	 	emptyText:'<%=SelectDay%>',
	 	blankText:'<%=SelectDay%>',
	 	triggerAction: 'all',
	 	displayField: 'HoliDay',
	 	valueField: 'HoliDayId',
	 	listeners: {
		             select: {
		                 	   fn:function(){
		                 	   	  	  
		                 	   }
		                 	}
		          }	    
      });
      
      var TerminalStore = new Ext.data.JsonStore({
				   		   url:'<%=request.getContextPath()%>/PassengerRateMasterAction.do?param=getTerminal',
			       		   root: 'TerminalRoot',
			       		   autoLoad: false,
				           fields: ['TERMINAL_ID','TERMINAL_NAME']
	  });
		
	  var TerminalCombo = new Ext.form.ComboBox({
	  frame:true,
	  store: TerminalStore,
	  id:'TerminalId',
	  width: 150,
	  cls: 'selectstylePerfect',
	  hidden:false,
	  anyMatch:true,
	  onTypeAhead:true,
	  forceSelection:true,
	  enableKeyEvents:true,
	  mode: 'local',
	  emptyText:'<%=SelectTerminalName%>',
	  blankText:'<%=SelectTerminalName%>',
	  triggerAction: 'all',
	  displayField: 'TERMINAL_NAME',
	  valueField: 'TERMINAL_ID',
	  listeners: {
		             select: {
		                	   fn:function(){
		                	   		  custId = Ext.getCmp('custcomboId').getValue();
		                	   		  Ext.getCmp('RouteId').reset();
		                	   		  Ext.getCmp('DistanceFieldId').reset();
                                	  Ext.getCmp('DurationFieldId').reset();
                                	  Ext.getCmp('DepartureFieldId').reset();
                                	  Ext.getCmp('ArrivalFieldId').reset();
		                 	   	  	  RouteStore.load({
                    						 params: {
                         					 	CustId: custId,
                         					 	TerminalId : Ext.getCmp('TerminalId').getValue()
                     						 }
                 					  });
		                 	   }
		                 	}
		          }	    
      });
    		  
      var RouteStore = new Ext.data.JsonStore({
				   		   url:'<%=request.getContextPath()%>/PassengerRateMasterAction.do?param=getRouteName',
			       		   root: 'RouteRoot',
			       		   autoLoad: false,
				           fields: ['RouteId','RouteName','DistanceId','DurationId']
	  });
	  
	  var RouteCombo = new Ext.form.ComboBox({
	  frame:true,
	  store: RouteStore,
	  id:'RouteId',
	  width: 150,
	  cls: 'selectstylePerfect',
	  hidden:false,
	  anyMatch:true,
	  onTypeAhead:true,
	  forceSelection:true,
	  enableKeyEvents:true,
	  mode: 'local',
	  emptyText:'<%=SelectRouteName%>',
	  blankText:'<%=SelectRouteName%>',
	  triggerAction: 'all',
	  displayField: 'RouteName',
	  valueField: 'RouteId',
	  listeners: {
		             select: {
		                	   fn:function(){
		                	    	  var row = RouteStore.find('RouteId',Ext.getCmp('RouteId').getValue());
									  var rec = RouteStore.getAt(row);
		                 	   	  	  Ext.getCmp('DistanceFieldId').setValue(rec.data['DistanceId']);
		                 	   	  	  Ext.getCmp('DurationFieldId').setValue(rec.data['DurationId']);
		                 	   	  	  var departure = Ext.getCmp('DepartureFieldId').getValue();
                					  if(departure!=""){
                					    var value1 = parseFloat(departure.replace(":",".")).toFixed(2)
                					  	var value2= parseFloat(Ext.getCmp('DurationFieldId').getValue().replace(":",".")).toFixed(2);
                					  	var splitvalue1 = value1.toString().split(".");
                					  	var splitvalue2 = value2.toString().split(".");
                					  	var sum = parseInt(splitvalue1[0])*60 + parseInt(splitvalue1[1]) + parseInt(splitvalue2[0]*60) + parseInt(splitvalue2[1]);
                					  	var hh = parseInt(sum/60)%24;
                					  	var mm = sum%60;
                					  	var arrivalTime = hh+"."+mm;
                					    	if(arrivalTime.length<3){
					 							arrivalTime = arrivalTime+".00";
											}
											if(arrivalTime.indexOf(".")!=2){
												arrivalTime = "0"+arrivalTime;
											}
											if(arrivalTime.length<5){
					 							arrivalTime = arrivalTime+"0";
											}
                					   	Ext.getCmp('ArrivalFieldId').setValue(arrivalTime.replace(".",":"));
                					 }
		                 	   }
		                 	}
		          }	    
      });
      
      var VehicleModelStore = new Ext.data.JsonStore({
				   		   url:'<%=request.getContextPath()%>/PassengerRateMasterAction.do?param=getVehicleModel',
			       		   root: 'VehicleModelRoot',
			       		   autoLoad: false,
				           fields: ['VehicleModelId','VehicleModelName']
	  });
	     
	  var VehicleModelCombo = new Ext.form.ComboBox({
	  	frame:true,
	 	store: VehicleModelStore,
	 	id:'VehicleModelId',
	 	width: 150,
	 	cls: 'selectstylePerfect',
	 	hidden:false,
	 	anyMatch:true,
	 	onTypeAhead:true,
	 	forceSelection:true,
	 	enableKeyEvents:true,
	 	mode: 'local',
	 	emptyText:'<%=SelectVehicleModel%>',
	 	blankText:'<%=SelectVehicleModel%>',
	 	triggerAction: 'all',
	 	displayField: 'VehicleModelName',
	 	valueField: 'VehicleModelId'
      }); 


	  var SeatingCapacityStore = new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/PassengerRateMasterAction.do?param=getSeatingCapacity',
			       root: 'SeatingCapacityRoot',
			       autoLoad: false,
				   fields: ['SeatingCapacityId','SeatingCapacityType']
	  }); 

 	  var SeatingCapacityCombo = new Ext.form.ComboBox({
	 	  frame:true,
		  store: SeatingCapacityStore,
	 	  id:'SeatingCapacityId',
	 	  width: 150,
	 	  cls: 'selectstylePerfect',
	 	  hidden:false,
	 	  anyMatch:true,
	 	  onTypeAhead:true,
	 	  forceSelection:true,
	 	  enableKeyEvents:true,
	 	  mode: 'local',
	 	  emptyText:'<%=SelectSeatingCapacity%>',
	 	  blankText:'<%=SelectSeatingCapacity%>',
	 	  triggerAction: 'all',
	 	  displayField: 'SeatingCapacityType',
	 	  valueField: 'SeatingCapacityId'
      }); 

	  var arrayStore = [['Active','Active'],['Inactive','Inactive']];   
	  var StatusStore = new  Ext.data.SimpleStore({
			       	   data:arrayStore,
				       fields: ['StatusId','Status']
	  });
		       
 	  var StatusCombo = new Ext.form.ComboBox({
				  frame:true,
				  store: StatusStore,
				  cls: 'selectstylePerfect',
				  id:'StatusId',
				  width: 175,
				  forceSelection:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  anyMatch:true,
	              onTypeAhead:true,
				  triggerAction: 'all',
				  value:'Active',
				  displayField: 'Status',
				  valueField: 'StatusId', 
	        	  
	        	  emptyText:''
	  });
	   
 var innerPanelForRateMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 320,
    width: 400,
    frame: true,
    id: 'innerPanelForRateMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'RateMasterId',
        width: 370,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'DayTypeMandotoryId'
        	},{
            		xtype: 'label',
            		text: '<%=DayType%>' + ' :',
            		cls: 'labelstyle',
            		id: 'DayTypeLabelId'
        	},
        			DayTypeCombo
        	,{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'TerminalMandotoryId'
        	},{
        			xtype: 'label',
            		text: '<%=Terminal%>' + ' :',
            		cls: 'labelstyle',
            		id: 'TerminalLabelId'
        	},
					TerminalCombo
			,{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'RouteNameMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=RouteName%>' + ' :',
            		cls: 'labelstyle',
            		id: 'RouteNameLabelId'
			},
					RouteCombo
			,{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'DistanceMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=Distance%>' + ' :',
            		cls: 'labelstyle',
            		id: 'DistanceLabelId'
			},{
					xtype: 'numberfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		labelSeparator: '',
            		allowBlank: false,
            		disabled : true,
            		allowDecimals:true,
            		id: 'DistanceFieldId'
			},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'DurationMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=Duration%>' + ' :',
            		cls: 'labelstyle',
            		id: 'DurationLabelId'
			},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		labelSeparator: ':',
            		allowBlank: false,
            		labelSeparator: ':',
            		disabled : true,
            		id: 'DurationFieldId'
			},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'DepartureMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=Departure%>' + ' :',
            		cls: 'labelstyle',
            		id: 'DepartureLabelId'
			},{
					xtype: 'textfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		labelSeparator: ':',
            		allowBlank: false,
            		regex:/^\s*([01]?\d|2[0-3]):+([0-5]\d)\s*$/,
            		disabled : false,
            		id: 'DepartureFieldId',
            		listeners: {
            					change: function(field, value) {
                					var duration = Ext.getCmp('DurationFieldId').getValue();
                					if(duration!=""){
                					  var value1 = parseFloat(duration.replace(":",".")).toFixed(2)
                					  var value2= parseFloat(value.replace(":",".")).toFixed(2);
                					  var splitvalue1 = value1.toString().split(".");
                					  var splitvalue2 = value2.toString().split(".");
                					  var sum = parseInt(splitvalue1[0])*60 + parseInt(splitvalue1[1]) + parseInt(splitvalue2[0]*60) + parseInt(splitvalue2[1]);
                					  var hh = parseInt(sum/60)%24;
                					  var mm = sum%60;
                					  var arrivalTime = hh+"."+mm;
                					    if(arrivalTime.length<3){
					 						arrivalTime = arrivalTime+".00";
										}
										if(arrivalTime.indexOf(".")!=2){
											arrivalTime = "0"+arrivalTime;
										}
										if(arrivalTime.length<5){
					 						arrivalTime = arrivalTime+"0";
										}
                					   	Ext.getCmp('ArrivalFieldId').setValue(arrivalTime.replace(".",":"));
            					}
            				}	
        			}
			},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'ArrivalMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=Arrival%>' + ' :',
            		cls: 'labelstyle',
            		id: 'ArrivalLabelId'
			},{
					xtype: 'textfield',
					cls: 'selectstylePerfect',
            		allowBlank: false,
            		labelSeparator: ':',
            		allowBlank: false,
            		regex:/^\s*([01]?\d|2[0-3]):+([0-5]\d)\s*$/,
            		disabled : false,
            		id: 'ArrivalFieldId'
			},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'VehicleModelMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=VehicleModel%>' + ' :',
            		cls: 'labelstyle',
            		id: 'VehicleModelLabelId'
			},
					VehicleModelCombo
			,{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'SeatingStructureMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=SeatingStructure%>' + ' :',
            		cls: 'labelstyle',
            		id: 'SeatingStructureLabelId'
			},
					SeatingCapacityCombo
			,{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'RateMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=Rate%>' + ' :',
            		cls: 'labelstyle',
            		id: 'RateLabelId'
			},{
					xtype: 'numberfield',
            		cls: 'selectstylePerfect',
            		allowBlank: false,
            		blankText: '<%=EnterAmount%>',
            		emptyText: '<%=EnterAmount%>',
            		labelSeparator: '',
            		allowBlank: false,
            		minValue:0,
            		disabled : false,
            		decimalPrecision:2,
            		id: 'RateFieldId'
			},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'RateMandotoryId'
        	},{
            		xtype: 'label',
            		text: '*',
            		cls: 'mandatoryfield',
            		id: 'StatusMandotoryId'
        	},{
					xtype: 'label',
            		text: '<%=Status%>' + ' :',
            		cls: 'labelstyle',
            		id: 'StatusLabelId'
			},
				StatusCombo
       ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 70,
    width: 400,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        iconCls: 'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                  
                    if (Ext.getCmp('DayTypeId').getValue() == "") {
     				    Ext.example.msg("<%=SelectDay%>");
         				Ext.getCmp('DayTypeId').focus();
         				return;
    				}else if (Ext.getCmp('TerminalId').getValue() == "") {
     				    Ext.example.msg("<%=SelectTerminalName%>");
         				Ext.getCmp('TerminalId').focus();
         				return;
    				}else if (Ext.getCmp('RouteId').getValue() == "") {
     				    Ext.example.msg("<%=SelectRouteName%>");
         				Ext.getCmp('RouteId').focus();
         				return;
    				}else if (Ext.getCmp('DepartureFieldId').getValue() == "") {
     				    Ext.example.msg("<%=EnterDeparture%>");
         				Ext.getCmp('DepartureFieldId').focus();
         				return;
    				}else if (Ext.getCmp('ArrivalFieldId').getValue() == "") {
     				    Ext.example.msg("<%=EnterArrival%>");
         				Ext.getCmp('ArrivalFieldId').focus();
         				return;
    				}else if (Ext.getCmp('VehicleModelId').getValue() == "") {
     				    Ext.example.msg("<%=SelectVehicleModel%>");
         				Ext.getCmp('VehicleModelId').focus();
         				return;
    				}else if (Ext.getCmp('SeatingCapacityId').getValue() == "") {
     				    Ext.example.msg("<%=SelectSeatingCapacity%>");
         				Ext.getCmp('SeatingCapacityId').focus();
         				return;
    				}else if (Ext.getCmp('RateFieldId').getValue() == "") {
     				    Ext.example.msg("<%=EnterAmount%>");
         				Ext.getCmp('RateFieldId').focus();
         				return;
    				}else if (Ext.getCmp('StatusId').getValue() == "") {
     				    Ext.example.msg("<%=SelectStatus%>");
         				Ext.getCmp('StatusId').focus();
         				return;
    				}
    				
    				var regdep = /^\s*([01]?\d|2[0-3]):+([0-5]\d)\s*$/;
    				var departure = Ext.getCmp('DepartureFieldId').getValue();
    				if(!regdep.test(departure)){
    					Ext.example.msg("<%=InvalidDeparture%>");
    					Ext.getCmp('DepartureFieldId').focus();
         				return;
    				}
    				
    				var arrival = Ext.getCmp('ArrivalFieldId').getValue();
    				if(!regdep.test(arrival)){
    					Ext.example.msg("<%=InvalidArrival%>");
    					Ext.getCmp('ArrivalFieldId').focus();
         				return;
    				}
    				
                    if (innerPanelForRateMasterDetails.getForm().isValid()) {
                     	
                     	var id=0;
                      	if(buttonValue == 'Modify'){
                    		var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('RateIdDataIndex');
                            if(selected.get('DayTypeDataIndex')== Ext.getCmp('DayTypeId').getValue() && parseInt(selected.get('TerminalIdDataIndex'))==  parseInt(Ext.getCmp('TerminalId').getValue()) && (parseInt(selected.get('RouteIdDataIndex')) == parseInt(Ext.getCmp('RouteId').getValue()) || selected.get('RouteNameDataIndex') == Ext.getCmp('RouteId').getValue()) && parseFloat(selected.get('DistanceDataIndex'))== parseFloat(Ext.getCmp('DistanceFieldId').getValue()) && selected.get('DurationDataIndex')== Ext.getCmp('DurationFieldId').getValue() && selected.get('DepartureDataIndex')== Ext.getCmp('DepartureFieldId').getValue() && selected.get('ArrivalDataIndex')== Ext.getCmp('ArrivalFieldId').getValue() && selected.get('VehicleModelIdDataIndex') == Ext.getCmp('VehicleModelId').getValue() && parseInt(selected.get('SeatingStructureIdDataIndex')) == parseInt(Ext.getCmp('SeatingCapacityId').getValue()) && parseFloat(selected.get('RateDataIndex')) == parseFloat(Ext.getCmp('RateFieldId').getValue()) && selected.get('StatusDataIndex') == Ext.getCmp('StatusId').getValue()){
                               Ext.example.msg("<%=NoChanges%>");
                               return;
                            }
                            if(selected.get('RouteNameDataIndex') == Ext.getCmp('RouteId').getValue()){
                                  Ext.getCmp('RouteId').setValue(selected.get('RouteIdDataIndex'));
                            }
                      	}
                      	
                       RateMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PassengerRateMasterAction.do?param=saveRateMaster',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                DayType: Ext.getCmp('DayTypeId').getValue(),
                                TerminalId: Ext.getCmp('TerminalId').getValue(),
                                RouteId: Ext.getCmp('RouteId').getValue(),
                                Distance: Ext.getCmp('DistanceFieldId').getValue(),
                                Duration:Ext.getCmp('DurationFieldId').getValue(),
                                DepartureTime:Ext.getCmp('DepartureFieldId').getValue(),
                                ArrivalTime:Ext.getCmp('ArrivalFieldId').getValue(),
                                VehicleModelId: Ext.getCmp('VehicleModelId').getValue(),
                                SeatingStructureId:Ext.getCmp('SeatingCapacityId').getValue(),
                                Amount: Ext.getCmp('RateFieldId').getValue(),
                                Status: Ext.getCmp('StatusId').getValue(),
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                Id:id
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('DayTypeId').reset();
                                Ext.getCmp('TerminalId').reset();
                                Ext.getCmp('RouteId').reset();
                                Ext.getCmp('DistanceFieldId').reset();
                                Ext.getCmp('DurationFieldId').reset();
                                Ext.getCmp('DepartureFieldId').reset();
                                Ext.getCmp('ArrivalFieldId').reset();
                                Ext.getCmp('VehicleModelId').reset();
                                Ext.getCmp('SeatingCapacityId').reset();
                                Ext.getCmp('RateFieldId').reset();
                                Ext.getCmp('StatusId').reset();
                                myWin.hide();

                                RateMasterOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
 		                                jspName:jspName
                                    }
                                });
                            },
                            failure: function () {
                                 Ext.example.msg("<%=Error%>");
                                 store.reload();
                                 myWin.hide();
                            }
                        });
                    }
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
                fn: function () {
                    myWin.hide();
                }
            }
        }
    }]
});

var RateMasterOuterPanelWindow = new Ext.Panel({
    width: 410,
    height: 420,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForRateMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 433,
    width: 420,
    id: 'myWin',
    items: [RateMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
         Ext.example.msg("<%=SelectCustomerName%>");
         Ext.getCmp('custcomboId').focus();
         return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddDetails%>';
    myWin.setPosition(450, 50);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('DayTypeId').reset();
	Ext.getCmp('TerminalId').reset();
    Ext.getCmp('RouteId').reset();
    Ext.getCmp('DistanceFieldId').reset();
    Ext.getCmp('DurationFieldId').reset();
    Ext.getCmp('DepartureFieldId').reset();
    Ext.getCmp('ArrivalFieldId').reset();
    Ext.getCmp('VehicleModelId').reset();
    Ext.getCmp('SeatingCapacityId').reset();
    Ext.getCmp('RateFieldId').reset();
    Ext.getCmp('StatusId').reset();
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 50);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('DayTypeId').setValue(selected.get('DayTypeDataIndex'));
    Ext.getCmp('TerminalId').setValue(selected.get('TerminalIdDataIndex'));
    Ext.getCmp('RouteId').setValue(selected.get('RouteNameDataIndex'));
    Ext.getCmp('DistanceFieldId').setValue(selected.get('DistanceDataIndex'));
    Ext.getCmp('DurationFieldId').setValue(selected.get('DurationDataIndex'));
    Ext.getCmp('DepartureFieldId').setValue(selected.get('DepartureDataIndex'));
    Ext.getCmp('ArrivalFieldId').setValue(selected.get('ArrivalDataIndex'));
    Ext.getCmp('VehicleModelId').setValue(selected.get('VehicleModelIdDataIndex'));
    Ext.getCmp('SeatingCapacityId').setValue(selected.get('SeatingStructureIdDataIndex'));
    Ext.getCmp('RateFieldId').setValue(selected.get('RateDataIndex'));
    Ext.getCmp('StatusId').setValue(selected.get('StatusDataIndex'));
}    

var reader = new Ext.data.JsonReader({
    idProperty: 'RateMasterRootId',
    root: 'RateMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    },{
        name: 'RateIdDataIndex'
    },{
    	name: 'DayTypeDataIndex'
    },{
        name: 'TerminalDataIndex'
    },{
        name: 'TerminalIdDataIndex'
    },{
        name: 'RouteNameDataIndex'
    },{
        name: 'RouteIdDataIndex'
    }, {
        name: 'DistanceDataIndex'
    },{
        name: 'DurationDataIndex'
	}, {
        name: 'DepartureDataIndex'
    }, {
        name: 'ArrivalDataIndex'
    },{
        name: 'VehicleModelIdDataIndex'
    },{
        name: 'VehicleModelDataIndex'
    },{
        name: 'SeatingStructureIdDataIndex'
    },{
        name: 'SeatingStructureDataIndex'
    },{
        name: 'RateDataIndex'
    },{
        name: 'StatusDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/PassengerRateMasterAction.do?param=getRateMasterDetails',
        method: 'POST'
    }),
    storeId: 'PassengerBusTransportationId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },{
    	type:'string',
    	dataIndex: 'DayTypeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'TerminalDataIndex'
    }, {
        type: 'string',
        dataIndex: 'RouteNameDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'DistanceDataIndex'
    },{
        type: 'string',
        dataIndex: 'DurationDataIndex'
    },{
        type: 'string',
        dataIndex: 'DepartureDataIndex'
    },{
        type: 'string',
        dataIndex: 'ArrivalDataIndex'
    },{
        type: 'string',
        dataIndex: 'VehicleModelDataIndex'
    },{
        type: 'string',
        dataIndex: 'SeatingStructureDataIndex'
    },{	
    	type: 'float',
        dataIndex: 'RateDataIndex'
    },{
    	type: 'string',
        dataIndex: 'StatusDataIndex'
    }]
});

var createColModel = function (finish, start) {
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
        }, {
            dataIndex: 'RateIdDataIndex',
            hidden: true,
            header: "<span style=font-weight:bold;><%=RATEID%></span>"
        }, {
            dataIndex: 'DayTypeDataIndex',
            header: "<span style=font-weight:bold;><%=WeekDayHoliday%></span>",
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=TerminalId%></span>",
            dataIndex: 'TerminalIdDataIndex',
            hidden: true,
            width: 20
        },{
            header: "<span style=font-weight:bold;><%=Terminal%></span>",
            dataIndex: 'TerminalDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=RouteId%></span>",
            dataIndex: 'RouteIdDataIndex',
            hidden: true,
            width: 20
        }, {
            header: "<span style=font-weight:bold;><%=RouteName%></span>",
            dataIndex: 'RouteNameDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Distance%></span>",
            dataIndex: 'DistanceDataIndex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Duration%></span>",
            dataIndex: 'DurationDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Departure%></span>",
            dataIndex: 'DepartureDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Arrival%></span>",
            dataIndex: 'ArrivalDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=VehicleModelId%></span>",
            dataIndex: 'VehicleModelIdDataIndex',
            hidden: true,
            width: 20
        }, {
            header: "<span style=font-weight:bold;><%=VehicleModel%></span>",
            dataIndex: 'VehicleModelDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=SeatingStructureId%></span>",
            dataIndex: 'SeatingStructureIdDataIndex',
            hidden: true,
            width: 20
        },{
            header: "<span style=font-weight:bold;><%=SeatingStructure%></span>",
            dataIndex: 'SeatingStructureDataIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Rate%></span>",
            dataIndex: 'RateDataIndex',
            width: 100,
            filter: {
                type: 'float'
            }
        },{
            header: "<span style=font-weight:bold;><%=Status%></span>",
            dataIndex: 'StatusDataIndex',
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
grid = getGrid('<%=RateMasterDetails%>','<%=NoRecordsFound%>', store, screen.width - 40, 420, 18, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, true, '<%=PDF%>', true, '<%=Add%>',true,'<%=Modify%>');
//******************************************************************************************************************************************************
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=RateMaster%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-28,
        height: 540,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
});</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->