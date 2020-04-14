<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	Properties prop = ApplicationListener.prop;
	String RFIDwebServicePath=prop.getProperty("WebServiceUrlPathForRFID");
	String WEIGHTwebServicePath=prop.getProperty("WebServiceUrlPathForWeight");
	if(request.getParameter("list")!=null)
	{
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
	if(str.length>9){
		loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
		loginInfo.setUserName(str[10].trim());
	}
		session.setAttribute("loginInfoDetails",loginInfo);
	
	}
	
	CommonFunctions cf = new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	
	ArrayList<String> tobeConverted=new ArrayList<String>();	
	tobeConverted.add("Trip_Summary_Report");
	tobeConverted.add("Customer_Name");
	tobeConverted.add("Select_Customer");
	
	tobeConverted.add("SLNO");
	tobeConverted.add("Next");		
	tobeConverted.add("No_Records_Found");
	tobeConverted.add("Clear_Filter_Data");
	tobeConverted.add("Select_Single_Row");
	tobeConverted.add("Excel");
	tobeConverted.add("PDF");
	
	tobeConverted.add("Total_Kms_By_Veh_ODO");		
	tobeConverted.add("Total_Kms_By_GPS");
	tobeConverted.add("No_Of_Points_Visited");
	tobeConverted.add("Total_Trip_Hrs");
	tobeConverted.add("Trip_Start_Veh_ODO");
	tobeConverted.add("Trip_End_Veh_ODO");
	tobeConverted.add("Trip_Start_Date_Time");
    tobeConverted.add("Trip_End_Date_Time");
    
    tobeConverted.add("Trip_No");
	tobeConverted.add("Vehicle_No");
	
	tobeConverted.add("Month_Validation");
    tobeConverted.add("Select_Start_Date");
    tobeConverted.add("Select_End_Date");
    tobeConverted.add("View");
    
	tobeConverted.add("Driver_Name");
	tobeConverted.add("Custodian_Name");
	tobeConverted.add("Gunman_Name");
	
	tobeConverted.add("Hub");
	tobeConverted.add(" Route");
	tobeConverted.add("Region");
	tobeConverted.add("Location");		
	tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
	
	tobeConverted.add("Enter_Vehicle_No");
	tobeConverted.add("Read_RFID");
	tobeConverted.add("Something_Wrong_in_RFID");
	tobeConverted.add("kgs");
	tobeConverted.add("Capture");
	tobeConverted.add("Capture_Quantity");
	tobeConverted.add("Something_Wrong_In_weight");
	tobeConverted.add("Save");
	tobeConverted.add("Cancel");
	tobeConverted.add("Weight_Date_Time");
	tobeConverted.add("Enter_Tare_Weight");
	tobeConverted.add("Tare_Weight");
	tobeConverted.add("select_vehicle_No");
	
	ArrayList<String> convertedWords=new ArrayList<String>();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted, language);	
	
	String TripSummaryReport = convertedWords.get(0);	
	String CustomerName = convertedWords.get(1);
	String SelectCustomer = convertedWords.get(2);
	
	String SlNo = convertedWords.get(3);
	String Next = convertedWords.get(4);	
	String NoRecordsFound = convertedWords.get(5);
	String ClearFilterData = convertedWords.get(6);
	String SelectSingleRow = convertedWords.get(7); 
	String Excel = convertedWords.get(8); 
	String PDF = convertedWords.get(9); 	
	
	String TotalKmsByOdometer=convertedWords.get(10);
	String TotalDistance=convertedWords.get(11); 	
	String VisistedPoints=convertedWords.get(12); 	
	String TotalTripHrs=convertedWords.get(13); 	
	String TripStartVehODO=convertedWords.get(14); 	
	String TripEndVehODO=convertedWords.get(15); 	
	String TripStartDate=convertedWords.get(16); 	
	String TripEndDate=convertedWords.get(17); 	

	String TripNo=convertedWords.get(18); 	
	String VehicleNo=convertedWords.get(19); 	
	String MonthValidation=convertedWords.get(20); 	
	String SelectStartDate=convertedWords.get(21); 	
	String SelectEndDate=convertedWords.get(22); 	
	String View=convertedWords.get(23); 	
	
    String DriverName=convertedWords.get(24); 	
	String CustodianName=convertedWords.get(25); 	
    String Gunman=convertedWords.get(26); 	
    String Hub=convertedWords.get(27); 	
    String Route=convertedWords.get(28); 	
    String Region=convertedWords.get(29); 	
    String Location=convertedWords.get(30); 
    String EndDateMustBeGreaterthanStartDate = convertedWords.get(31);

	String EnterVehicleNo=convertedWords.get(32);
	String ReadRFID=convertedWords.get(33);
	String SomethingWronginRFID=convertedWords.get(34);
	String kgs=convertedWords.get(35);
	String Capture=convertedWords.get(36);
	String CaptureQuantity=convertedWords.get(36);
	String SomethingWronginweight=convertedWords.get(38);
	String Save=convertedWords.get(39);
	String Cancel=convertedWords.get(40);
	String WeightDateTime=convertedWords.get(41);
	String enterTareWeight=convertedWords.get(42);
	String TareWeight=convertedWords.get(43);
	String selectVehicleNO=convertedWords.get(44);
%>

<jsp:include page="../Common/header.jsp" />
 		<title>Sand Weigh Bridge</title>		
 
<style>
  	.x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
		</style>
	 <%}%>
   <script>
   
    var grid;
	var myWin;
	var buttonValue;
	var uniqueId;
	var closewin;
	var outerPanel;
	var AssetNo;
 	var jspName='WeighBridgeMaster';
   	var exportDataType = "int,string,string,string,string,number,string,string,string";
   	var tareWeight=0;
   	var transitPass="";
    var dtprev = dateprev;
	var dtcur = datecur;
	var dtnxt = datenext;
	var listOfAssetnum = [];
	var titelForInnerPanel;
	var transitPassQuantity;
	var orderId;
	var transitPassDate;
	var tsOnlineDataStatus;
	var checkTransitstatus;
	
	 //*********************** Store For Customer *****************************************//
	var customercombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function (custstore, records, success, options) {
            if ( <%= customerId %> > 0) {            
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
            }
        }
    }
});

//************************ Combo for Customer Starts Here***************************************//
	var custnamecombo = new Ext.form.ComboBox({
    store: customercombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select customer',
    selectOnFocus: true,
    resizable: true,
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
                                                                  
            }
        }
    }
	});
	
	var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        title:'',
        id: 'panelId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 12
        },
		items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'custnamelab'
       },
            custnamecombo,
            {width:'30px'},
        {
            xtype: 'label',
            text: 'Start Date' + ' :',
            cls: 'labelstyle',
            id: 'StartDtLabelId'
        }, {
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            value:dtprev,
            id: 'StartDtId'
        }, {width:'30px'},{
            xtype: 'label',
            text: 'End Date' + ' :',
            cls: 'labelstyle',
            id: 'EndDtLabelId'
        },{
            xtype: 'datefield',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            value:dtcur,
            id: 'EndDtId'
        },{width:'30px'},{
  		        xtype: 'button',
  		        text: '<%=View%>',
  		        id: 'addbuttonid',
  		        cls: ' ',
  		        width: 80,
  		        listeners: {
  		                click: {
  		                    fn: function () {
  		                        if (Ext.getCmp('custcomboId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectCustomer%>");
  		                            Ext.getCmp('custcomboId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('StartDtId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectStartDate%>");
  		                            Ext.getCmp('StartDtId').focus();
  		                            return;
  		                        }
  		                        if (Ext.getCmp('EndDtId').getValue() == "") {
  		                            Ext.example.msg("<%=SelectEndDate%>");
  		                            Ext.getCmp('EndDtId').focus();
  		                            return;
  		                        }
  		                        var startdates = Ext.getCmp('StartDtId').getValue();
  		                        var enddates = Ext.getCmp('EndDtId').getValue();
  		                        
  		                      if (dateCompare(startdates,enddates) == -1) {
                             Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                             Ext.getCmp('EndDtId').focus();
                             return;
                               }
                                if (checkMonthValidation(startdates, enddates)) {
  		                            Ext.example.msg("<%=MonthValidation%>");
  		                            Ext.getCmp('EndDtId').focus();
  		                            return;
  		                        }
  		                        SummaryReportStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        CustName : Ext.getCmp('custcomboId').getRawValue(),
  		                                startDate: Ext.getCmp('StartDtId').getValue(),
  		                                endDate: Ext.getCmp('EndDtId').getValue(),
 		                                jspName:jspName
                                    }
                                });  
  		                    }
  		                }
  		            }
  		    }
		
		
		]
    }); // End of Panel	s
    
	
//----------------------------------------------------------------//	
 var vehicleRFIDPanel =  new Ext.form.FormPanel({ 
       	standardSubmit: true,
	    collapsible: false,
	    autoScroll: true,
	    height: 325,
	    width: 690,
	    frame: true,
	    id: 'innerPanelForMDPGeneratorId',
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
	        id: 'weightDetailsId',
	        width: 680,
	        height:300,
	        frame: false,
	        layout: 'table',
	        layoutConfig: {
	            columns: 6
        	},	
			items:[
               {
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryRfid1'
               },{
	                xtype: 'label',
	                text: '',
	                cls: 'mandatoryfield',
	                id: 'mandatoryRfid2'
	            },{width : 52},
               {
                   xtype:'button',
                   text:'<%=ReadRFID%>',
                   width:80,
                   id: 'RFIDButtId',
                   cls: 'buttonstyle',
                    listeners: {
		            click: {
		                fn: function () {
							var RFIDValue;
							$.ajax({
							type:"GET",
				    		url:'<%=RFIDwebServicePath%>',   			
				   			success:
				       		function(data){
				       		if(data.indexOf('RSSOURCE') >=0 || data.indexOf('RSDESTINATION')>=0 || data.indexOf('TRANSACTION_NO')>=0){ 
                               split1=data.split('RSSOURCE');
                               split2=split1[1].split('RSDESTINATION');
                               split3=split2[1].split('TRANSACTION_NO');
                              
                               RFIDValue1 = split1[0].split('==');
                               RFIDValue=RFIDValue1[1];
                               rsSource=split2[0].replace('==','');
                               rsDestination=split3[0].replace('==','');
                               transactionNo=split3[1].replace('==','');
                             }else{  
                               RFIDValue=data;
                               rsSource="";
                               rsDestination="";
                               transactionNo="";
                             }
                             console.log(RFIDValue+','+rsSource+','+rsDestination+','+transactionNo);
				            Ext.Ajax.request({
		                            url: '<%=request.getContextPath()%>/SandTSMDCAction.do?param=getWeighBridgeRFID',
		                            method: 'POST',
		                            params: {
		                            RFIDValue:RFIDValue,
		                            CustID: Ext.getCmp('custcomboId').getValue()
		                            },
		                            success: function (response, options) {
										var message = response.responseText;
										var  result= JSON.parse(message);
										
										var vehicleNos = message.replace(/[\:'",.\{\}\[\]\\\/]/gi,'');
										if(vehicleNos=="vno"){
										Ext.example.msg("<%=SomethingWronginRFID%>");
										Ext.getCmp('RFIDvehicleNo').setValue("<%=EnterVehicleNo%>");
										}else{
										Ext.getCmp('transitPermitTxtId').reset();
										Ext.getCmp('RFIDvehicleNo').reset();
										Ext.getCmp('tareWeightTxtId').reset();
										console.log(result['vno'][0].vehicleNo);
										console.log("transit pass--"+result['vno'][0].transitPermit);
										console.log("transit qty--"+result['vno'][0].transitPermitQty);
										console.log("order id--"+result['vno'][0].orderId);
										console.log("transit pass date--"+result['vno'][0].transitPermitDate);
										console.log("TsOnlineDatastatus--"+result['vno'][0].TsOnlineDatastatus);
										console.log("TsOnlineDatastatus--"+result['vno'][0].checkTransitstatus);
										var vehicleNo = result['vno'][0].vehicleNo;
										tareWeight = result['vno'][0].tareWeight;
										transitPass = result['vno'][0].transitPermit;
										transitPassQuantity = result['vno'][0].transitPermitQty;
										orderId = result['vno'][0].orderId; 
										transitPassDate = result['vno'][0].transitPermitDate;
										tsOnlineDataStatus = result['vno'][0].TsOnlineDatastatus;
										checkTransitstatus = result['vno'][0].checkTransitstatus;
										Ext.getCmp('RFIDvehicleNo').setValue(vehicleNo);
										Ext.getCmp('tareWeightTxtId').setValue(tareWeight);
									//	Ext.getCmp('transitPassQtyTxtId').setValue(transitPassQuantity);
										
											if(transitPass != ""){
												Ext.getCmp('transitPermitTxtId').setValue(transitPass);
												Ext.getCmp('transitPermitTxtId').disable();
											}else{
												Ext.getCmp('transitPermitTxtId').enable();
											}
											if(tsOnlineDataStatus != ""){
												Ext.example.msg("Alert:"+tsOnlineDataStatus);
											}
											if(checkTransitstatus == "Already Weighed"){
												Ext.example.msg("Transit pass Id Already Weighed");
											}
										}
		                            },
		                            failure: function () {
										Ext.example.msg("<%=SomethingWronginRFID%>");
		                            }
		                        });
				        	},error:function(){
					        	Ext.example.msg("<%=SomethingWronginRFID%>");
					        	}
							});
		                }//fun
		            }//click
      			  }//listeners
               },
                {
	                xtype: 'label',
	                text: '',
	                cls: 'mandatoryfield',
	                id: 'mandatoryRfid3'
	            },
	            {
	                height:40
	            },
	            {
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryRfid'
               },{
                   xtype: 'label',
                   text: '<%=VehicleNo%>:',
                   cls: 'labelstyle',
                   id: 'RFIDIDs'
               },{width:52},{
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   emptyText: '<%=EnterVehicleNo%>',
                   allowBlank: false,
				   readOnly:true,
                   blankText: '<%=EnterVehicleNo%>',
                   id: 'RFIDvehicleNo'
               },{width:20},{height:40},
	            {
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryTransitPermit'
               },{
                   xtype: 'label',
                   text: 'Transit Pass Id:',
                   cls: 'labelstyle',
                   id: 'transitPermitLabId'
               },{width:52},{
                   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   emptyText: 'Enter Transit Pass',
                   allowBlank: false,
                   blankText: 'Enter Transit Pass',
                   id: 'transitPermitTxtId'
               },{width:20},
          /*     {
               	   xtype: 'textfield',
                   cls: 'selectstylePerfect',
                   emptyText: 'Transit Pass Quantity',
                   allowBlank: false,
                   readOnly:true,
                   blankText: 'Transit Pass Quantity',
                   id: 'transitPassQtyTxtId'
                }, */
                {height:40},
               {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryTareWeight'
	            },{
	                xtype: 'label',
	                text: '<%=TareWeight%>'+'  :',
	                cls: 'labelstyle',
	                id: 'tareWeightLabelId'
	            },{width:52},{
				    xtype: 'textfield',
				    width: 50,
                    height: 60,
                    //cls: 'quantityBox',
	                cls: 'selectstylePerfect',  
	                readOnly:true,  
	                emptyText: '',
	                blankText: '',
	                id: 'tareWeightTxtId',
	            },{
	                xtype: 'label',
	                text: 'Kg',
	                cls: 'labelstyle',
	                id: 'mandatoryTareWeight1'
	            },{
	                height:40
	            },
	            {
	                xtype: 'label',
	                text: '',
	                cls: 'mandatoryfield',
	                id: 'mandatoryCaptureWeight'
	            },
	            {
	                xtype: 'label',
	                text: '',
	                cls: 'mandatoryfield',
	                id: 'mandatoryCaptureWeight1'
	            },{width:52},
	            {
                   xtype:'button',
                   text:'Capture Weight',
                   iconCls: 'capturebutton',
                   scale: 'large',
                   name:'filepath',
                   id:'captureWeightId',
                   width:80,
                   cls: 'buttonstyle',
                    listeners: {
		            click: {
		                fn: function () {
							var buttonValue='<%=CaptureQuantity%>';
							
							$.ajax({
								type:"GET",
					    		url:'<%=WEIGHTwebServicePath%>',   			
					   			 success:function(data){
                					if(data.indexOf('Something is wrong. Please check')<0){
									var netBW;
					                   Ext.getCmp('grossWeightTextId').setValue(parseFloat(data));
					                   netBW=data-tareWeight;
                                       if(netBW <= 0){
                                      	Ext.example.msg("Gross Weight Should Greater Than Tare Weight");
                                      	Ext.getCmp('netWeightTextId').setValue(0);
                                      	}else{
                                      	Ext.getCmp('netWeightTextId').setValue(parseFloat(netBW));
                                      	}
                                      }
					        	}
					        	,error:function(){
					        	Ext.example.msg("<%=SomethingWronginweight%>");
					        	}	
							});
		                }//fun
		            }//click
      			  }//listeners
               },
               {
	                xtype: 'label',
	                text: '',
	                cls: 'mandatoryfield',
	                id: 'mandatoryCaptureWeight2'
	            },
	            {
	               height:40
	            },
	            
	            {
	                xtype: 'label',
	                text: '*',
	                cls: 'mandatoryfield',
	                id: 'mandatoryGrossWeight'
	            },
	            {
		            xtype: 'label',
		            text: 'Gross Weight' + ' :',
		            cls: 'labelstyle',
		            //cls: 'labelstyle',
		            id: 'grossWeightLabId'
		        },{width:52},{
					xtype: 'textfield',
					width: 50,
                    height: 60,
                    //cls: 'quantityBox',
					cls: 'selectstylePerfect',
					allowBlank: false,
					size: "100", 
					blankText: '',
					emptyText: '',
					labelSeparator: '',
					readOnly:true,
					id: 'grossWeightTextId'
				},{
		            xtype: 'label',
		            text: 'Kg',
		            cls: 'labelstyle',
		            id:'loadKgsId'
	        	},{
	                height:40
	            },
	            {
	                xtype: 'label',
	                text: '*',
	                cls: 'mandatoryfield',
	                id: 'mandatoryNetWeight'
	            },{
		            xtype: 'label',
		            text: 'Net Weight' + ' :',
		            cls: 'labelstyle',
		            id: 'netWeightLabId'
		        },{width:52},{
					xtype: 'textfield',
					width: 50,
                    height: 60,
                    //cls: 'quantityBox',
					cls: 'selectstylePerfect',
					allowBlank: false,
					size: "100", 
					blankText: '',
					emptyText: '',
					labelSeparator: '',
					readOnly:true,
					id: 'netWeightTextId'
				},{
		            xtype: 'label',
		            text: 'Kg',
		            cls: 'labelstyle',
		            id:'netKgsId'
	        	},{
	               height:20
	            }
			   ]
			}]
    }); 

	//****************************** Window For Adding Trip Information****************************
   var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height:50,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [ {width:245},{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        iconCls : 'savebutton',
        width: 80,
        listeners: {
            click: {
                fn: function () {
                
                
                if (Ext.getCmp('transitPermitTxtId').getValue() == "") {
				    Ext.example.msg("Enter Transit Permit");
				    Ext.getCmp('transitPermitTxtId').focus();
				    return;
				    }
					
					if (Ext.getCmp('RFIDvehicleNo').getValue() == "") {
				    Ext.example.msg("<%=selectVehicleNO%>");
				    Ext.getCmp('RFIDvehicleNo').focus();
				    return;
				    }
					
					if (Ext.getCmp('tareWeightTxtId').getValue() == "") {
				    Ext.example.msg("<%=enterTareWeight%>");
				    Ext.getCmp('tareWeightTxtId').focus();
				    return;
				    }
				    
				    if (Ext.getCmp('grossWeightTextId').getValue() == "") {
				    Ext.example.msg("Enter Gross Weight");
				    Ext.getCmp('grossWeightTextId').focus();
				    return;
				    }

				    var VehicleNoBaseType="";
				    var globalClientId=Ext.getCmp('custcomboId').getValue();
                    var customerName=Ext.getCmp('custcomboId').getRawValue();
				    
			
                    OuterPanelWindow.getEl().mask();
                    //Performs Save Operation
                     //Ajax request starts here
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SandTSMDCAction.do?param=saveWeighBridgeData',
                            method: 'POST',
                            params: {
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            transitPermit: Ext.getCmp('transitPermitTxtId').getValue(),
                            vehicleNo:Ext.getCmp('RFIDvehicleNo').getValue(),
                            tareWeight:Ext.getCmp('tareWeightTxtId').getValue(),
                            CustName: Ext.getCmp('custcomboId').getRawValue(),
                            grossWeight:Ext.getCmp('grossWeightTextId').getValue(),
                            netWeight:Ext.getCmp('netWeightTextId').getValue(),
                            transitPassQuantity : transitPassQuantity,
							orderId : orderId,
							transitPassDate : transitPassDate
                            
                            },
                            success: function (response, options) {
								var message = response.responseText;
								Ext.example.msg(message);
                        		Ext.getCmp('transitPermitTxtId').reset();
								Ext.getCmp('RFIDvehicleNo').reset();
								Ext.getCmp('tareWeightTxtId').reset();
				                Ext.getCmp('grossWeightTextId').reset(); 
								Ext.getCmp('netWeightTextId').reset();
                    		    OuterPanelWindow.getEl().unmask();  
                    		    myWin.hide();
                    		    SummaryReportStore.load({
                                    params: {
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        CustName : Ext.getCmp('custcomboId').getRawValue(),
  		                                startDate: Ext.getCmp('StartDtId').getValue(),
  		                                endDate: Ext.getCmp('EndDtId').getValue(),
 		                                jspName:jspName
                                    }
                                });
                    		   
                            },
                            failure: function () {
								Ext.example.msg("Error");
								Ext.getCmp('transitPermitTxtId').reset();
								Ext.getCmp('RFIDvehicleNo').reset();
								Ext.getCmp('tareWeightTxtId').reset();
				                Ext.getCmp('grossWeightTextId').reset(); 
								Ext.getCmp('netWeightTextId').reset();
								myWin.hide();
								OuterPanelWindow.getEl().unmask();
								
                            }
                        });
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls : 'cancelbutton',
        width: '80',
        listeners: {
            click: {
                fn: function () {
				        
                Ext.getCmp('transitPermitTxtId').reset();
				Ext.getCmp('RFIDvehicleNo').reset();
				Ext.getCmp('tareWeightTxtId').reset();
                Ext.getCmp('grossWeightTextId').reset(); 
				Ext.getCmp('netWeightTextId').reset();
				myWin.hide();
                }
            }
        }
    }]
});

var OuterPanelWindow = new Ext.Panel({
    width: 700,
    height: 400,
    standardSubmit: true,
    frame: false,
    items: [vehicleRFIDPanel,winButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 420,
    width: 700,
    id: 'myWin',
    items: [OuterPanelWindow]
});
function addRecord() {

    
    buttonValue = 'Add';
    titelForInnerPanel = 'Add Weight Details';
  
    myWin.setPosition(400, 100);
    myWin.show();
    //  myWin.setHeight(350);
    Ext.getCmp('transitPermitTxtId').reset();
	Ext.getCmp('RFIDvehicleNo').reset();
	Ext.getCmp('tareWeightTxtId').reset();
    Ext.getCmp('grossWeightTextId').reset(); 
	Ext.getCmp('netWeightTextId').reset();
 	
    myWin.setTitle(titelForInnerPanel);
}

function modifyData() {
   
    if (summaryGrid.getSelectionModel().getCount() == 0) {
     Ext.example.msg("No Rows Selected");
        return;
    }
    if (summaryGrid.getSelectionModel().getCount() > 1) {
     Ext.example.msg("Select Single Row");
        return;
    }
    buttonValue = 'PDF';
    var selected = summaryGrid.getSelectionModel().getSelected();
    var orderId = selected.get('orderIdDataIndex');
    var transitPermit = selected.get('transitPermitDataIndex');
	var vehicleNo = selected.get('vehicleNoDataIndex');
	var tareWeight = selected.get('tareWeightDataIndex');
	var grossWeight = selected.get('grossWeightDataIndex');
	var netWeight = selected.get('netWeightDataIndex');	
	var weightDate = selected.get('DateDataIndex');		
	var custId = Ext.getCmp('custcomboId').getValue();
	var serialNo = 1;
	//pdfRecord(transitPermit,vehicleNo,tareWeight,grossWeight,netWeight)
	
	Ext.Ajax.request({
	  url: '<%=request.getContextPath()%>/SandTSMDCAction.do?param=maxSerialNo',
	  method: 'POST',
	  params:
	  {
		ClientId: Ext.getCmp('custcomboId').getValue()
	  },
	  success:function(response, options)
	  {
		serialNo=response.responseText;
		window.open("<%=request.getContextPath()%>/Sand_Weigh_Bridge_Reciept?systemId="+<%=systemId%>+"&orderId="+orderId+"&transitPermit="+transitPermit+"&vehicleNo="+vehicleNo+"&tareWeight="+tareWeight+"&grossWeight="+grossWeight+"&netWeight="+netWeight+"&serialNo="+serialNo+"&weightDate="+weightDate+"&custId="+custId);
	  }, // end of success
	  	failure: function(response, options)
	  {
	  	window.open("<%=request.getContextPath()%>/Sand_Weigh_Bridge_Reciept?systemId="+<%=systemId%>+"&orderId="+orderId+"&transitPermit="+transitPermit+"&vehicleNo="+vehicleNo+"&tareWeight="+tareWeight+"&grossWeight="+grossWeight+"&netWeight="+netWeight+"&serialNo="+serialNo+"&weightDate="+weightDate+"&custId="+custId);
	  }// end of failure
	});	
             		    
}

  var reader = new Ext.data.JsonReader({
        idProperty: 'readerId',
        root: 'weighBridgeDetailsRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        },{
            name: 'orderIdDataIndex'
        },{
            name: 'transitPermitDataIndex'
        },{
            name: 'vehicleNoDataIndex'
        },{
            name: 'tareWeightDataIndex'
        },{
            name: 'grossWeightDataIndex'
        },{
            name: 'netWeightDataIndex'
        },{
            name: 'DateDataIndex',
        }]
    });

    var SummaryReportStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/SandTSMDCAction.do?param=getSandWeighBridgeDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'weightStoreId',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'orderIdDataIndex'
        },{
            type: 'string',
            dataIndex: 'transitPermitDataIndex'
        },  {
            type: 'string',
            dataIndex: 'vehicleNoDataIndex'
        },  {
            type: 'numeric',
            dataIndex: 'tareWeightDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'grossWeightDataIndex'
        }, {
            type: 'numeric',
            dataIndex: 'netWeightDataIndex'
        }, {
            type: 'date',
            dataIndex: 'DateDataIndex'
        }]
    });
    
   //************************************Column Model Config******************************************
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SlNo%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SlNo%></span>",
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Order Id</span>",
                dataIndex: 'orderIdDataIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Transit Permit No.</span>",
                dataIndex: 'transitPermitDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=VehicleNo%></span>",
                dataIndex: 'vehicleNoDataIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Tare Weight(kg)</span>",
                dataIndex: 'tareWeightDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Gross Weight(kg)</span>",
                dataIndex: 'grossWeightDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Net Weight(kg)</span>",
                dataIndex: 'netWeightDataIndex',
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Weighed Date</span>",
                dataIndex: 'DateDataIndex',
                filter: {
                    type: 'date'
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
   
    summaryGrid = getGrid('', '<%=NoRecordsFound%>', SummaryReportStore, screen.width - 35, 400, 22, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, '<%=PDF%>', true, 'Add', true, 'Print PDF', false, 'Delete');

	Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
   	
   	outerPanel = new Ext.Panel({
  	  title:'Weigh Bridge Challan Generation',
      renderTo: 'content',
      standardSubmit: true,
      frame: true,
      cls: 'outerpanel',
      height: 520,
      width:screen.width-24,
      layout: 'table',
      layoutConfig: {
          columns: 1
      },
      items: [innerPanel, summaryGrid]
      //bbar: ctsb
     });
     if(<%=customerId%> > 0)
	   {
	   Ext.getCmp('custnamelab').hide();
	   Ext.getCmp('custcomboId').hide();
	   }
	    var cm = summaryGrid.getColumnModel();  
	    for (var j = 1; j < cm.getColumnCount(); j++) {
	       cm.setColumnWidth(j,195);
	    }
    });
 
   </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
