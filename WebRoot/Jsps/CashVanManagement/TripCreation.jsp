<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Customer_Name");
tobeConverted.add("Managed_Trip");
tobeConverted.add("Managed_Trip_Details");
tobeConverted.add("Select_State");
tobeConverted.add("Select_Status");
tobeConverted.add("Select_Registration_No");
tobeConverted.add("Please_Select_customer");
tobeConverted.add("SLNO");
tobeConverted.add("Start_Date");
tobeConverted.add("State");
tobeConverted.add("Location");
tobeConverted.add("Asset_Number");
tobeConverted.add("Trip_Status");
tobeConverted.add("Reason_For_Off_Road/Route");
tobeConverted.add("Opening_KMS");
tobeConverted.add("Odometer_kms");
tobeConverted.add("GPS_KMS");
tobeConverted.add("Hired_Vehicle_Number");
tobeConverted.add("Hired_Vehicle_KMS");
tobeConverted.add("Hired_Amount");
tobeConverted.add("Status");
tobeConverted.add("Please_Select_Start_Date");
tobeConverted.add("Please_Select_End_Date");
tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
tobeConverted.add("Month_Validation");
tobeConverted.add("Select_Customer");
tobeConverted.add("Start_Date");
tobeConverted.add("End_Date");
tobeConverted.add("Enter_Location");
tobeConverted.add("Vehicle_Number");
tobeConverted.add("Asset_Group");
tobeConverted.add("Opening_Odometer");
tobeConverted.add("Enter_Opening_KMS");
tobeConverted.add("Hired_Details");
tobeConverted.add("Asset_Number");
tobeConverted.add("Hired_Amount");
tobeConverted.add("Vehicle_KMS");
tobeConverted.add("Vehicle_KMS");
tobeConverted.add("Select_Trip_Status");
tobeConverted.add("Please_Enter_Opening_Odometer");
tobeConverted.add("Select_Reason_for_Off_Road/Off_Route");
tobeConverted.add("Save");
tobeConverted.add("Trip_Details");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Cancel");
tobeConverted.add("Error");
tobeConverted.add("Add_Trip_Information");
tobeConverted.add("Modify_Trip_Information");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Delete");
tobeConverted.add("want_to_delete");
tobeConverted.add("Deleting");


ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);

String selectCustomer=convertedWords.get(0);
String tripCreation=convertedWords.get(1);
String tripCreationDetails=convertedWords.get(2);
String SelectState=convertedWords.get(3);
String SelectStatus=convertedWords.get(4);
String SelectRegistrationNo=convertedWords.get(5);
String pleaseSelectcustomer=convertedWords.get(6);
String SLNO=convertedWords.get(7);
String tripStartDateTime=convertedWords.get(8);
String State=convertedWords.get(9);
String location=convertedWords.get(10);
String assetNumber=convertedWords.get(11);
String tripStatus=convertedWords.get(12);
String reason=convertedWords.get(13);
String openingKMS=convertedWords.get(14);
String oDOKMSRun=convertedWords.get(15);
String GPSKMS=convertedWords.get(16);
String hiredVehicleNumber=convertedWords.get(17);
String hiredKMSRun=convertedWords.get(18);
String hiredAmount=convertedWords.get(19);
String Status=convertedWords.get(20);
String selectStartDate=convertedWords.get(21);
String selectendDate=convertedWords.get(22);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(23);
String monthValidation=convertedWords.get(24);
String SelectCustomerName=convertedWords.get(25);
String startDate=convertedWords.get(26);
String endDate=convertedWords.get(27);
String enterLocation=convertedWords.get(28);
String vehicleNumber=convertedWords.get(29);
String vehicleGroup=convertedWords.get(30);
String openingOdometer=convertedWords.get(31);
String enterOpeningKMS=convertedWords.get(32);
String hiredVehicleDetails=convertedWords.get(33);
String enterHiredVechileNumber=convertedWords.get(34);
String enterHiredAmount=convertedWords.get(35);
String hiredVehicleKMS=convertedWords.get(36);
String enterHiredVehicleKMS=convertedWords.get(37);
String selectTripStatus =convertedWords.get(38);
String pleaseEnterOpeningOdometer =convertedWords.get(39);
String selectReason=convertedWords.get(40);
String save =convertedWords.get(41);
String tripDetails=convertedWords.get(42);
String noRecordsFound=convertedWords.get(43);
String cancel=convertedWords.get(44);
String error=convertedWords.get(45);
String addTripInformation=convertedWords.get(46);
String modifyTripInformation=convertedWords.get(47);
String SelectSingleRow=convertedWords.get(48);
String delete=convertedWords.get(49);
String wantToDelete=convertedWords.get(50);
String deleting=convertedWords.get(51);

String currentTime = cf.getCurrentDateTime(loginInfo.getOffsetMinutes());

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
	
		<title><%=tripCreationDetails%></title>
	<style>
	.x-table-layout td {
    vertical-align: inherit !important;
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
	<body>
		<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp" />                                                    
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
        <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.selectstylePerfect {
				height: 22px !important;
			    margin: 0px 0px 2px 5px !important;
			}
			
		</style>
        <script>
		var dtprev=dateprev;
		var grid;
		var myWin;
		var buttonValue;
		var uniqueId;
		var closewin;
		var callodo="";
		var Mcallodo="";
		var hubStartId;
		var hubEndId;
		var dtcur=datecur;
		var globaltripId;	
	 	var jspName='TripCreationReport';
    	var exportDataType = "int,string,string,string,string,string,string,number,number,number,string,number,number,string";
    	var currentTime = new Date();
	    var minDate = dateprev.add(Date.Month, -30);
	   // var maxDate = dtcur.add(Date.Month, 30);
	 //******************************************function******************************//  
	//**************************************Combo For STATE**************************
        
	var stateComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getStates',
    id: 'stateStoreId',
    root: 'StateRoot',
    autoload: true,
    remoteSort: true,
    fields: ['StateID', 'stateName'],
    listeners: {
        load: function() {}
    }
});

var stateCombo = new Ext.form.ComboBox({
    store: stateComboStore,
    id: 'statecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectState%>',
    blankText: '<%=SelectState%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'StateID',
    displayField: 'stateName',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            }
        }
    }
});
		
var tripStatusStore =new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/TripCreation.do?param=getTripStatus',
        id:'tripstatusId',
		root: 'tripStatusRoot',
        autoLoad:false,
		remoteSort: true,
        fields:['tripStatusId']
    });

         var tripStatusCombo = new Ext.form.ComboBox({
            store: tripStatusStore,
            id: 'tripStatusComboId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            selectOnFocus: true,
            width: 175,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            value:'On Route',
            lazyRender: true,
            valueField: 'tripStatusId',
            displayField: 'tripStatusId',
            emptyText:'<%=SelectStatus%>',
            cls: 'selectstylePerfect',
            listeners: {
                select: {
                    fn: function () {
                    globaltripId=Ext.getCmp('tripStatusComboId').getValue();
                        Ext.getCmp('reasonComboId').reset();   
                    	//Ext.getCmp('openKmsId').reset();    
                        Ext.getCmp('reasonComboId').reset();  
                    	Ext.getCmp('hiredvehicleNoId').reset();   
                    	Ext.getCmp('hiredAmountId').reset();   
                    	Ext.getCmp('hiredVechKmsId').reset();
                    	  
                    if(globaltripId=="On Route"){
                        Ext.getCmp('hiredDetailsPanelId').hide();
                        Ext.getCmp('hiredvehicleNoLabelId').hide();
						Ext.getCmp('hiredAmountLabelId').hide();
						Ext.getCmp('hiredVechKmsLabelId').hide();
				        Ext.getCmp('hiredvehicleNoId').hide();  
                    	Ext.getCmp('hiredAmountId').hide();   
                    	Ext.getCmp('hiredVechKmsId').hide();
				    	Ext.getCmp('reasonlabelId').hide();
				    	Ext.getCmp('reasonId').hide();
				    	Ext.getCmp('reasonComboId').hide(); 
                    }else{
                    if (buttonValue == 'modify') {
                     var selected = grid.getSelectionModel().getSelected();
		                Ext.getCmp('reasonComboId').setValue(selected.get('reasonForOffRoad'));
	 					Ext.getCmp('hiredvehicleNoId').setValue(selected.get('hiredVehicleNo'));
				        Ext.getCmp('hiredAmountId').setValue(selected.get('hiredAmount'));
				        Ext.getCmp('hiredVechKmsId').setValue(selected.get('hiredVehicleKmsRun')); 
                    	Ext.getCmp('reasonlabelId').show();
				   	 	Ext.getCmp('reasonId').show();
				    	Ext.getCmp('reasonComboId').show();
				    	Ext.getCmp('hiredDetailsPanelId').show();
				    	Ext.getCmp('hiredvehicleNoLabelId').show();
						Ext.getCmp('hiredAmountLabelId').show();
						Ext.getCmp('hiredVechKmsLabelId').show();
				    	Ext.getCmp('hiredvehicleNoId').show(); 
                    	Ext.getCmp('hiredAmountId').show();   
                    	Ext.getCmp('hiredVechKmsId').show();
				    }
				        Ext.getCmp('hiredDetailsPanelId').show();
				        Ext.getCmp('hiredvehicleNoLabelId').show();
						Ext.getCmp('hiredAmountLabelId').show();
						Ext.getCmp('hiredVechKmsLabelId').show();
				        Ext.getCmp('hiredvehicleNoId').show();  
                    	Ext.getCmp('hiredAmountId').show();   
                    	Ext.getCmp('hiredVechKmsId').show();
                    	Ext.getCmp('reasonlabelId').show();
				   	 	Ext.getCmp('reasonId').show();
				    	Ext.getCmp('reasonComboId').show();
				    	//alert('modiOut2'); 
                    }
                    
<!--                    if (globaltripId=="Off Route"||globaltripId=="Off Road"){-->
<!--                    alert('inside trip1');-->
<!--                    var selected = grid.getSelectionModel().getSelected();-->
<!--				         Ext.getCmp('hiredDetailsPanelId').show();-->
<!--				        Ext.getCmp('hiredpanelId').setTitle('Hired Details');-->
<!--				        Ext.getCmp('mandatoryhiredvechNo').setText('');-->
<!--						Ext.getCmp('mandatoryhiredAmount').setText('');-->
<!--						Ext.getCmp('mandatoryhiredVechKms').setText('');-->
<!--				        Ext.getCmp('hiredDetailsPanelId').show();-->
<!--                    	Ext.getCmp('reasonlabelId').show();-->
<!--				   	 	Ext.getCmp('reasonId').show();-->
<!--				    	Ext.getCmp('reasonComboId').show();-->
<!--				    	//Ext.getCmp('hiredDetailsPanelId').enable();-->
<!--                   }-->
<!--                        Ext.getCmp('hiredDetailsPanelId').show();-->
<!--                    	Ext.getCmp('reasonlabelId').show();-->
<!--				   	 	Ext.getCmp('reasonId').show();-->
<!--				    	Ext.getCmp('reasonComboId').show();-->
                  
  			      }//function
                }//select
            }//listeners
        });
        
     var reasonStore =new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/TripCreation.do?param=getReasonOffRouteRoadStatus',
        id:'reasonId',
		root: 'reasonRoot',
        autoLoad:false,
		remoteSort: true,
        fields:['reasonId']
        });

        
         var reasonCombo = new Ext.form.ComboBox({
            store: reasonStore,
            id: 'reasonComboId',
            mode: 'local',
            hidden: false,
            resizable: true,
            forceSelection: true,
            selectOnFocus: true,
            width: 175,
            allowBlank: false,
            typeAhead: true,
            triggerAction: 'all',
            lazyRender: true,
            valueField: 'reasonId',
            displayField: 'reasonId',
            emptyText:'<%=SelectStatus%>',
            cls: 'selectstylePerfect',
            listeners: {
                select: {
                    fn: function () {
                    var reasonName = Ext.getCmp('reasonComboId').getRawValue();
  					}
                }
            }
        });   
        	
	//**********************Strore For Vehicle Starts Here*********************************************
	
	var vehiclestore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripCreation.do?param=getVehicles',
    id: 'VehicleStoreId',
    root: 'VehicleRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['Registration_No','Vehicle_group','odoMeter']
});

	//**********************Strore For Vehicle Ends Here*********************************************
//******************************************** Combo For Vehicle Starts Here*************************
	var vehiclecombo = new Ext.form.ComboBox({
    store: vehiclestore,
    id: 'vehiclecomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=SelectRegistrationNo%>',
    selectOnFocus: true,
    allowBlank: false,
    resizable: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Registration_No',
    displayField: 'Registration_No',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
				   var assetNoId = Ext.getCmp('vehiclecomboId').getValue();
                   var row = vehiclestore.find('Registration_No',Ext.getCmp('vehiclecomboId').getValue());
                   var rec = vehiclestore.getAt(row);
                   Ext.getCmp('vehicleGroupId').setValue(rec.data['Vehicle_group']);
                   callodo=rec.data['odoMeter'];
		           // alert('cal'+callodo);
            }
        }
    }
	});
var  endDateMinVal = datecur.add(Date.DAY,-30);
var StartDate = new Ext.form.DateField({
			width: 185,
			format: getDateFormat(),
			id: 'startDateTime',
            value: datecur,
            minValue:endDateMinVal,
   			maxValue: new Date(),
            vtype: 'daterange',
			cls:'selectstylePerfect',
		    blankText: '<%=selectStartDate%>',
		    allowBlank:false,
				listeners: 	{
				     select:{
				         fn: function(){
				         Ext.getCmp('vehiclecomboId').reset();
				  		 custId=Ext.getCmp('custcomboId').getValue();
				  		 sdates=Ext.getCmp('startDateTime').getValue();
				      	 vehiclestore.load({
                            params: {
                          CustId: custId,
                          sdate:sdates
                               }
                             });
				         }//function
				       }//select
					}//listeners
	    });	
	 
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
             //getMarketOdo();               
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                sdate=Ext.getCmp('enddate').getValue();
                 vehiclestore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue(),
                         sdate:Ext.getCmp('enddate').getValue()
                   }
                });
                stateComboStore.load();
                tripStatusStore.load({
                    params: {
                        CustId: <%= customerId %>
                    }
                });
                reasonStore.load({
                    params: {
                        CustId: <%= customerId %>
                    }
                });
            }
        }
    }
});

	//*********************** Store For Customer Ends Here*****************************************//
		
	//************************ Combo for Customer Starts Here***************************************//
	
	var custnamecombo = new Ext.form.ComboBox({
    store: customercombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=pleaseSelectcustomer%>',
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
             //getMarketOdo();
                custId = Ext.getCmp('custcomboId').getValue();
                 vehiclestore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue(),
                         sdate:Ext.getCmp('enddate').getValue()
                   }
                });
               stateComboStore.load();
               tripStatusStore.load({
                    params: {
                        CustId: <%= customerId %>
                    }
                });
                reasonStore.load({
                    params: {
                        CustId: <%= customerId %>
                    }
                });

               store.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        custName : Ext.getCmp('custcomboId').getRawValue(),
                        jspName: jspName
                  }

               });
            }
        }
    }
	});
	
	
	//************************ Combo for Customer Ends Here***************************************//	
	
	
	 //********************************************Grid config starts***********************************
  
  
    // **********************************************Reader configs Starts******************************
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
    	root: 'TripCreationRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'sdate',
        type: 'date',
        dateFormat: getDateTimeFormat()
    	},{
    	name: 'stateId'
    	},{
    	name: 'state'
    	},{
    	name: 'location'
    	},{
        name: 'registrationNo'
    	}, {
    	name: 'tripStatusIds'
    	},{
        name: 'tripStatus'
    	},{
    	name: 'reasonIndex'
    	},{
        name: 'reasonForOffRoad'
    	}, {
        name: 'OpeningKms'
    	}, {
        name: 'odoKmsRun'
    	}, {
        name: 'gpsKmsRun'
    	}, {
        name: 'hiredVehicleNo'
    	}, {
        name: 'hiredVehicleKmsRun'
    	}, {
        name: 'hiredAmount'
    	}, {
        name: 'uniqueIdDataIndex'
        }, {
        name: 'status'
        }]
    });
    
    // **********************************************Reader configs Ends******************************

    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/TripCreation.do?param=getTripDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'tripDetailsStore',
        reader: reader
        });
        
   //********************************************Store Configs For Grid Ends*************************
 
   
     
    //********************************************************************Filter Config***************
       
    	var filters = new Ext.ux.grid.GridFilters({
        local: true,
    	filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    	}, {
        type: 'date',
        dataIndex: 'sdate'
    	},{
        type: 'string',
        dataIndex: 'state'
    	}, {
    	type: 'string',
        dataIndex: 'location'
    	}, {
        type: 'string',
        dataIndex: 'registrationNo'
    	}, {
        type: 'string',
        dataIndex: 'tripStatus'
    	}, {
        type: 'string',
        dataIndex: 'reasonForOffRoad'
    	}, {
        type: 'int',
        dataIndex: 'OpeningKms'
    	}, {
        type: 'int',
        dataIndex: 'odoKmsRun'
    	}, {
        type: 'int',
        dataIndex: 'gpsKmsRun'
    	}, {
        type: 'string',
        dataIndex: 'hiredVehicleNo'
    	}, {
        type: 'int',
        dataIndex: 'hiredVehicleKmsRun'
    	}, {
        type: 'string',
        dataIndex: 'hiredAmount'
    	}, {
        type: 'string',
        dataIndex: 'status'
    	}]
    	});
    	
    	
    	//***************************************************Filter Config Ends ***********************

    //*********************************************Column model config**********************************
    
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
        	header: "<span style=font-weight:bold;>SLNO</span>",
        	width: 50
    		}), {
        	dataIndex: 'slnoIndex',
        	hidden: true,
        	header: "<span style=font-weight:bold;><%=SLNO%></span>",
        	filter: {
            type: 'numeric'
        	}
    		}, {
        	dataIndex: 'sdate',
        	header: "<span style=font-weight:bold;><%=tripStartDateTime%></span>",
        	 renderer: Ext.util.Format.dateRenderer('d-m-Y'),
        	width: 110,        	
        	filter: {
            type: 'date'
        	}
    		},
			 {
    		header: "<span style=font-weight:bold;><%=State%></span>",
    		dataIndex: 'state',
    		width: 110,    
    		sortable: true,		
    		filter: {
    		type: 'string'
    		}
    		},{
    		header: "<span style=font-weight:bold;><%=location%></span>",
    		dataIndex: 'location',
    		width: 110,    		
    		filter: {
    		type: 'string'
    		}
    		},{
        	header: "<span style=font-weight:bold;><%=assetNumber%></span>",
        	dataIndex: 'registrationNo',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=tripStatus%></span>",
        	dataIndex: 'tripStatus',
        	width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=reason%></span>",
        	dataIndex: 'reasonForOffRoad',
        	width: 120,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=openingKMS%></span>",
        	dataIndex: 'OpeningKms',
        	width: 80,
        	filter: {
            type: 'int'
        	}
    		}, {
        	header: "<span style=font-weight:bold;><%=oDOKMSRun%></span>",
        	dataIndex: 'odoKmsRun',
        	width: 80,
        	filter: {
            type: 'int'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=GPSKMS%></span>",
        	dataIndex: 'gpsKmsRun',
        	width: 80,
        	filter: {
            type: 'int'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=hiredVehicleNumber%></span>",
        	dataIndex: 'hiredVehicleNo',
        	width: 110,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=hiredAmount%></span>",
        	dataIndex: 'hiredAmount',
        	width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=hiredKMSRun%></span>",
        	dataIndex: 'hiredVehicleKmsRun',
        	width: 80,
        	filter: {
            type: 'int'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=Status%></span>",
        	dataIndex: 'status',
        	width: 80,
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
    
    
     //*********************************************Column model config Ends***************************
   
    //******************************************Creating Grid By Passing Parameter***********************
   
   
    grid = getGrid('<%=tripCreationDetails%>', '<%=noRecordsFound%>', store,screen.width-55,420, 18, filters, 'Clear Filter Data', false, '', 14, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', true, 'Create Trip', true, 'Modify Trip', true, 'Delete',false,'', false , '');	
		
	//**********************************End Of Creating Grid By Passing Parameter*************************	
		
		 var editInfo1 = new Ext.Button({
            text: 'View',
            cls: 'buttonStyle',
            width: 70,
            handler: function ()

            {   
                var clientName = Ext.getCmp('custcomboId').getValue();
                var startdate = Ext.getCmp('startdate').getValue();
                var enddate = Ext.getCmp('enddate').getValue();
               // alert(clientName);alert(startdate);alert(enddate);
              
                if (Ext.getCmp('custcomboId').getValue() == "") {
                	Ext.example.msg("<%=pleaseSelectcustomer%>");
                    Ext.getCmp('custcomboId').focus();
                    return;
                }

                if (Ext.getCmp('startdate').getValue() == "") {
                	Ext.example.msg("<%=selectStartDate%>");
                    Ext.getCmp('startdate').focus();
                    return;
                }
                if (Ext.getCmp('enddate').getValue() == "") {
                	Ext.example.msg("<%=selectendDate%>");
					Ext.getCmp('enddate').focus();
                    return;
                }
                 
                  if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                  		Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                        Ext.getCmp('enddate').focus();
                           return;
                       }
                       
                       if(checkMonthValidation(Ext.getCmp('startdate').getValue(),Ext.getCmp('enddate').getValue()))
            		 	{
            		 		Ext.example.msg("<%=monthValidation%>");
            		 		Ext.getCmp('enddate').focus(); 
               		    	return;
            		 	} 

                store.load({
                    params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        startdate: Ext.getCmp('startdate').getValue(),
                        enddate: Ext.getCmp('enddate').getValue(),
                        custName : Ext.getCmp('custcomboId').getRawValue(),
                        jspName: jspName
                  }

               });

            }
        });

		
			
   	// ***********************   Pannel For Customer For Adding Trip Inforamtion**************************		
 
   			var customerPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'customerMaster',
    			layout: 'table',
    			cls: 'innerpanelsmallest',
    			frame: false,
    			width: '100%',
    			layoutConfig: {
        		columns: 11
    			},
    			items: [{
            		xtype: 'label',
           		    text: '<%=selectCustomer%>' + ' :',
            		cls: 'labelstyle',
            		id: 'custnamelab'
        			},
        			custnamecombo, {
                    width: 50
                }, {
                    xtype: 'label',
                    text: '<%=startDate%>'+ ' :',
                    width: 20,
                    cls: 'labelstyle'

                },{
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width: 185,
               format: getDateFormat(),
               allowBlank: false,
               id: 'startdate',
               value: dtprev,
               endDateField: 'enddate'
            },{
                    width: 50
                },
                {
                    xtype: 'label',
                    text: '<%=endDate%> ' +' :',
                    width: 20,
                    cls: 'labelstyle'
                },{
               xtype: 'datefield',
               cls: 'selectstylePerfect',
               width: 185,
               format: getDateFormat(),
               emptyText: '',
               allowBlank: false,
               blankText: '',
               id: 'enddate',
               value: datecur,
               startDateField: 'startdate'
           },{
                    width: 50
                },editInfo1
    				]
				});
   		
    //****************************** Inner Pannel radio button pannel Here For Adding Trip Inforamtion ***************
   
   var innerPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 80,
    width: 460,
    frame: false,
    id: 'addFuel',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorydateStartDateTime'
            }, {
                xtype: 'label',
                text: '<%=tripStartDateTime%>'+'  :',
                cls: 'labelstyle',
                id: 'startdateTimeLabelId'
            },{
                width:50
            },StartDate,
            //-------------------------------//
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorystate'
            },{
                xtype: 'label',
                text: '<%=State%>'+'  :',
                cls: 'labelstyle',
                id: 'stateLabelId'
            },{
                width:50
            },  stateCombo,
            //--------------------------------//
            
            {
                xtype: 'label',
                text: ' ',
                cls: 'mandatoryfield',
                id: 'mandatorydateTime'
            }, {
                xtype: 'label',
                text: '<%=location%>' +' :',
                cls: 'labelstyle',
                id: 'locationLabelId'
            },{
                width:50
            }, {
                xtype: 'textfield',
                cls: 'selectstylePerfect',               
                stripCharsRe :/[,]/,
                emptyText: '<%=enterLocation%>',
                blankText: '<%=enterLocation%>',
                id: 'locationId'
            }
        ]
});
	//**********************************radio button pannel*******************************************//
   	var radioButtonPanel = new Ext.form.FormPanel({
    id: 'rabuttonid',
    standardSubmit: true,
    collapsible: false,
    height:30,
    width: 360,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 8
    },
    items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryownerVehTime'
            }, {
                xtype: 'label',
                text: 'Own Vehicle'+'  :',
                cls: 'labelstyle',
                id: 'OwnVehicleLabelId'
            },{width:10},{
                   xtype: 'radio',
	               id:'ownerVehId',
                   text: '',
                   checked:true,
                   name:'option1',
           listeners:{
					check:{fn:function()
					{
					Ext.getCmp('vehiclecomboId').reset();
					Ext.getCmp('vehicleGroupId').reset();
					Ext.getCmp('reasonComboId').reset();  
					Ext.getCmp('openKmsId').reset();
					 if(this.checked){
					 //alert('inside radio 1st');
					    Ext.getCmp('mandatoryhiredvechNo').setText('');
						Ext.getCmp('mandatoryhiredAmount').setText('');
						Ext.getCmp('mandatoryhiredVechKms').setText('');
					    Ext.getCmp('bottomPanelid').show();
						Ext.getCmp('mandatoryopeningKms').show();
						Ext.getCmp('openKmsId').show();
						Ext.getCmp('openKmsLabelId').show();
						Ext.getCmp('vehiclecomboId').show();
						Ext.getCmp('assetNumberLabelId').show();
				   	 	Ext.getCmp('mandatoryassetNumber').show();
                    	Ext.getCmp('mandatorystatus').show();
                    	Ext.getCmp('tripStatusComboId').reset();
				   	 	Ext.getCmp('tripStatusLabelId').show();
				    	Ext.getCmp('tripStatusComboId').show();
						Ext.getCmp('vehicleGrouplId').show();
						Ext.getCmp('vehicleGroupId').show();
						Ext.getCmp('hiredDetailsPanelId').hide();
						Ext.getCmp('hiredvehicleNoLabelId').hide();
						Ext.getCmp('hiredAmountLabelId').hide();
						Ext.getCmp('hiredVechKmsLabelId').hide();
						Ext.getCmp('hiredvehicleNoId').hide();  
						Ext.getCmp('hiredAmountId').hide(); 
					    Ext.getCmp('hiredVechKmsId').hide();
		if (buttonValue == 'modify') {
          //alert('own');
				   }
                   }//if
                   }//check
                  }  
                 }  
                },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatorydateStartDateTime'
            }, {
                xtype: 'label',
                text: 'Market Vehicle'+'  :',
                cls: 'labelstyle',
                id: 'MarketvehicleLabelId'
            },{width:10},{
                   xtype: 'radio',
	               id:'marketVehId',
                   text: '',
                   checked:false,
                   name:'option1',
           listeners:{
					check:{fn:function()
					{
					 if(this.checked){
					  Ext.getCmp('hiredpanelId').setTitle('Market Vehicle');
					  Ext.getCmp('mandatoryhiredvechNo').setText('*');
					  Ext.getCmp('mandatoryhiredAmount').setText('*');
					  Ext.getCmp('mandatoryhiredVechKms').setText('*');
					    Ext.getCmp('bottomPanelid').hide();
						Ext.getCmp('mandatoryopeningKms').hide();
						Ext.getCmp('openKmsId').hide();
						Ext.getCmp('openKmsLabelId').hide();
						Ext.getCmp('vehiclecomboId').hide();
						Ext.getCmp('assetNumberLabelId').hide();
				   	 	Ext.getCmp('mandatoryassetNumber').hide();
                    	Ext.getCmp('mandatorystatus').hide();
				   	 	Ext.getCmp('tripStatusLabelId').hide();
				    	Ext.getCmp('tripStatusComboId').hide();
						Ext.getCmp('vehicleGrouplId').hide();
						Ext.getCmp('vehicleGroupId').hide();
						Ext.getCmp('reasonlabelId').hide();
				    	Ext.getCmp('reasonId').hide();
				    	Ext.getCmp('reasonComboId').hide();
						Ext.getCmp('hiredDetailsPanelId').show();
						Ext.getCmp('hiredvehicleNoLabelId').show();
						Ext.getCmp('hiredAmountLabelId').show();
						Ext.getCmp('hiredVechKmsLabelId').show();
						Ext.getCmp('hiredvehicleNoId').show();   
					    Ext.getCmp('hiredAmountId').show();  
					    Ext.getCmp('hiredVechKmsId').show();  
					    
					    if(buttonValue == 'modify'){
					    //alert('radio');
					     var selected = grid.getSelectionModel().getSelected();
		                Ext.getCmp('startDateTime').setValue(selected.get('sdate'));
				        Ext.getCmp('statecomboId').setValue(selected.get('state'));
				        Ext.getCmp('locationId').setValue(selected.get('location'));
						Ext.getCmp('reasonComboId').setValue(selected.get('reasonForOffRoad'));
	 					Ext.getCmp('hiredvehicleNoId').setValue(selected.get('registrationNo'));
				        Ext.getCmp('hiredAmountId').setValue(selected.get('hiredAmount'));
				        Ext.getCmp('hiredVechKmsId').setValue(selected.get('hiredVehicleKmsRun')); 
                    	Ext.getCmp('reasonlabelId').show();
				   	 	Ext.getCmp('reasonId').show();
				    	Ext.getCmp('reasonComboId').show();
				    	//alert('modi');
				    	Ext.getCmp('hiredDetailsPanelId').show();
				    	Ext.getCmp('hiredvehicleNoLabelId').show();
						Ext.getCmp('hiredAmountLabelId').show();
						Ext.getCmp('hiredVechKmsLabelId').show();
						//alert('between');
				    	Ext.getCmp('hiredvehicleNoId').show(); 
                    	Ext.getCmp('hiredAmountId').show();   
                    	Ext.getCmp('hiredVechKmsId').show();
                    	//alert('modi2');
					    }
                   }
                   } 
                  }  
                 }  
                }]
	});	
//**********************************radio button pannel*******************************************//
   	var bottomPanel = new Ext.form.FormPanel({
    id: 'bottomPanelid',
    standardSubmit: true,
    collapsible: false,
    height:130,
    width: 400,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 5
    },
    items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryassetNumber'
            },{
                xtype: 'label',
                text: '<%=assetNumber%>'+'  :',
                cls: 'labelstyle',
                id: 'assetNumberLabelId'
            },  vehiclecombo,{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorydate7'
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorydate8'
            },
      //----------------------------------//      
            {
                xtype: 'label',
                text: ' ',
                cls: 'labelstyle',
                id: 'mandatoryVehicleGroup'
            }, {
                xtype: 'label',
                text: '<%=vehicleGroup%>' +' :',
                cls: 'labelstyle',
                id: 'vehicleGrouplId'
            },{
                xtype: 'textfield',
                allowBlank: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=vehicleGroup%>',
                blankText: '<%=vehicleGroup%>',
                id: 'vehicleGroupId'
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorydate9'
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorydate10'
            },
    //---------------------------------------//        
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorystatus'
            }, {
                xtype: 'label',
                text: '<%=tripStatus%>' + ':',
                cls: 'labelstyle',
                id: 'tripStatusLabelId'
            }, tripStatusCombo,{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorydate11'
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorydate12'
            },
      //-----------------------------------//      
            {   
               xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'reasonlabelId'
            }, {
                xtype: 'label',
                text: '<%=reason%>' + ':',
                cls: 'labelstyle',
                id: 'reasonId'
            }, reasonCombo,{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorydate13'
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorydate14'
            },
     //-------------------------------------//       
            {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryopeningKms'
            }, {
                xtype: 'label',
                text: '<%=openingOdometer%>' +' :',
                cls: 'labelstyle',
                id: 'openKmsLabelId'
            },{
                xtype: 'numberfield',
                allowBlank: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=enterOpeningKMS%>',
                blankText: '<%=enterOpeningKMS%>',
                id: 'openKmsId'
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorydate15'
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'mandatorydate16'
            }]
	});	
	

 var secondPanelForHiredDetails = new Ext.form.FormPanel({
       standardSubmit: true,
       collapsible: false,
       id: 'hiredDetailsPanelId',
       layout: 'table',
       frame: false,
       hidden: true,
       items: [{
        xtype: 'fieldset',
        title: '<%=hiredVehicleDetails%>',
        id:'hiredpanelId',
        collapsible: false,
        width: 400,
        height:92,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryhiredvechNo'
            }, {
                xtype: 'label',
                text: '<%=enterHiredVechileNumber%>' +' :',
                cls: 'labelstyle',
                id: 'hiredvehicleNoLabelId'
            },{width:70},{
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                emptyText: '<%=enterHiredVechileNumber%>',
                blankText: '<%=enterHiredVechileNumber%>',
                id: 'hiredvehicleNoId',
                mode: 'local',
                forceSelection: true,
                selectOnFocus: true,
                listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
            },
			{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryhiredAmount'
            }, {
                xtype: 'label',
                text: '<%=hiredAmount%>' +' :',
                cls: 'labelstyle',
                id: 'hiredAmountLabelId'
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle'
            },{
                xtype: 'numberfield',
                allowBlank: false,
                allowDecimal:true,
                cls: 'selectstylePerfect',
                emptyText: '<%=enterHiredAmount%>',
                blankText: '<%=enterHiredAmount%>',
                id: 'hiredAmountId'
            },
			{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryhiredVechKms'
            }, {
                xtype: 'label',
                text: '<%=hiredVehicleKMS%>' +' :',
                cls: 'labelstyle',
                id: 'hiredVechKmsLabelId'
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle'
            },{
                xtype: 'numberfield',
                allowBlank: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=enterHiredVehicleKMS%>',
                blankText: '<%=enterHiredVehicleKMS%>',
                id: 'hiredVechKmsId'
            }]
	}]
});

       var caseInnerPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       height: 420,
       width: 480,
       frame: true,
       id: 'addCaseInfo',
       layout: 'table',
       layoutConfig: {
           columns: 2
       },
       items: [{
        xtype: 'fieldset',
        title: '<%=tripDetails%>',
        collapsible: false,
        id: 'fuelmileagepanelid',
          colspan: 3,
           width: 430,
            height: 395,
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
           items: [innerPanel,radioButtonPanel,bottomPanel,secondPanelForHiredDetails]
       }]
   });
   
     
   //****************************** Inner Pannel Ends Here ***************************************
   
   //****************************** Window For Adding Trip Information****************************
   
   var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    height:100,
    cls: 'windowbuttonpanel',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 3
    },
    items: [{
        width: 240
    }, {
        xtype: 'button',
        text: '<%=save%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        iconCls : 'savebutton',
        width: 80,
        listeners: {
         
            click: {
           
                fn: function () {
                     var ownV=Ext.getCmp('ownerVehId').getValue();
                     var marketV=Ext.getCmp('marketVehId').getValue();
                    if (Ext.getCmp('startDateTime').getValue() == "") {
                    	Ext.example.msg("<%=selectStartDate%>");
                    	Ext.getCmp('startDateTime').focus();
                        return;
                    }
                    if (Ext.getCmp('statecomboId').getValue() == "") {
                    	Ext.example.msg("<%=SelectState%>");
                    	Ext.getCmp('statecomboId').focus();
                        return;
                    }
					//if (Ext.getCmp('locationId').getValue() == "") {
                    //    ctsb.setStatus({
                    //        text: getMessageForStatus("<%=enterLocation%>"),
                    //        iconCls: '',
                   //         clear: true
                  //      });
                 //       Ext.getCmp('locationId').focus();
                 //       return;
                  //  }
					if(ownV==true){				
					if (Ext.getCmp('vehiclecomboId').getValue() == "") {
                     	Ext.example.msg("<%=SelectRegistrationNo%>");
                     	Ext.getCmp('vehiclecomboId').focus();
                        return;
                    }
                    if (Ext.getCmp('tripStatusComboId').getValue() == "") {
                     	Ext.example.msg("<%=selectTripStatus%>");
                        Ext.getCmp('tripStatusComboId').focus();
                        return;
                    }       
                   
                    if (Ext.getCmp('openKmsId').getValue() == "") {
                        Ext.example.msg("<%=pleaseEnterOpeningOdometer%>");
                   		Ext.getCmp('openKmsId').focus();
                        return;
                    }
                    globaltripId=Ext.getCmp('tripStatusComboId').getValue();
                    
                    
                    //alert(globaltripId);
                    if(globaltripId=="Off Route"||globaltripId=="Off Road"){
					if (Ext.getCmp('reasonComboId').getValue() == "") {
					 	Ext.example.msg("<%=selectReason%>");
                   	 	Ext.getCmp('reasonComboId').focus();
                        return;
                      }
                    }
                    }
//--------------------checking Value------------------------------//                
					if(ownV==true){
                        var currentOdo=Ext.getCmp('openKmsId').getValue();
                    	var preodometer=callodo;
                    	//alert('odometer'+preodometer+'---------->'+currentOdo);
                    	//alert(parseInt(currentOdo) - parseInt(preodometer));
                    if ((preodometer - Ext.getCmp('openKmsId').getValue())>0) {
                        Ext.example.msg("Opening Odometer should be greater than previous Odometer..");
    					Ext.getCmp('openKmsId').focus();
                        return;
                      }
                      }
              if(ownV==true){	
                    if (Ext.getCmp('openKmsId').getValue() == "") {
                        Ext.example.msg("<%=pleaseEnterOpeningOdometer%>");
                        Ext.getCmp('openKmsId').focus();
                        return;
                    }
                    }
  //-------------------------------------------------------------------------------------------------------//
					if(marketV==true){
                    if (Ext.getCmp('hiredvehicleNoId').getValue() == "") {
                        Ext.example.msg("<%=enterHiredVechileNumber%>");
                        Ext.getCmp('hiredvehicleNoId').focus();
                        return;
                    }	
					if (Ext.getCmp('hiredAmountId').getValue() == "") {
						Ext.example.msg("<%=enterHiredAmount%>");
						Ext.getCmp('hiredAmountId').focus();
						return;
						}
					if (Ext.getCmp('hiredVechKmsId').getValue() == "") {
						Ext.example.msg("<%=enterHiredVehicleKMS%>");
						Ext.getCmp('hiredVechKmsId').focus();
						return;
						}
						//getMarketOdo();
					}
					if(marketV==true){
					    var McurrentOdo=Ext.getCmp('hiredVechKmsId').getValue();
                    	var Mpreodometer=Mcallodo;
                    if ((Mpreodometer - Ext.getCmp('hiredVechKmsId').getValue())>0) {
                        Ext.example.msg("Market Vehicle Opening Odometer should be greater than previous Odometer..");
    					Ext.getCmp('hiredVechKmsId').focus();
                        return;
                      }
					}
//--------------------------------------------------------------------------------------------------------------------//
					var stateModify;
					var stateModifyName;
					var statusIdModify;
					var statusNameModify;
					var reasonIdsModify;
					var reasonNameModify;
                    if (buttonValue == 'modify') {
                        var selected = grid.getSelectionModel().getSelected();
                        uniqueId = selected.get('uniqueIdDataIndex');
                        if (selected.get('state') != Ext.getCmp('statecomboId').getValue()) {
                            stateModify = Ext.getCmp('statecomboId').getValue();
                            stateModifyName=Ext.getCmp('statecomboId').getRawValue();
                        } else {
                            stateModify = selected.get('stateId');
                            stateModifyName=Ext.getCmp('statecomboId').getRawValue();
                        }
                        if (selected.get('tripStatus') != Ext.getCmp('tripStatusComboId').getValue()) {
                            statusIdModify = Ext.getCmp('tripStatusComboId').getValue();
                            statusNameModify=Ext.getCmp('tripStatusComboId').getRawValue();
                        } else {
                            statusIdModify = selected.get('tripStatusIds');
                            statusNameModify=Ext.getCmp('tripStatusComboId').getRawValue();
                        }
                        if (selected.get('reasonForOffRoad') != Ext.getCmp('reasonComboId').getValue()) {
                            reasonIdsModify = Ext.getCmp('reasonComboId').getValue();
                            reasonNameModify=Ext.getCmp('reasonComboId').getRawValue();
                        } else {
                            reasonIdsModify = selected.get('reasonIndex');
                            reasonNameModify=Ext.getCmp('reasonComboId').getRawValue();
                        }
                    }
                    myWin.getEl().mask();
                    //Performs Save Operation
                     //Ajax request starts here
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/TripCreation.do?param=saveormodifyAssetGroup',
                            method: 'POST',
                            params: {
                                radioOvalue:Ext.getCmp('ownerVehId').getValue(),
                                radioMvalue:Ext.getCmp('marketVehId').getValue(),
                                buttonValue: buttonValue,
                                startDateTime: Ext.getCmp('startDateTime').getValue(),
								state:Ext.getCmp('statecomboId').getValue(),
								stateName:Ext.getCmp('statecomboId').getRawValue(),
								location: Ext.getCmp('locationId').getValue(),   
					            vehicleNumber: Ext.getCmp('vehiclecomboId').getValue(),
                    			StatusId: Ext.getCmp('tripStatusComboId').getValue(),
                    			StatusName: Ext.getCmp('tripStatusComboId').getRawValue(),
								reason: Ext.getCmp('reasonComboId').getValue(),
								reasonName:Ext.getCmp('reasonComboId').getRawValue(),
                    			openingKMS: Ext.getCmp('openKmsId').getValue(),
								hiredVehicleNo: Ext.getCmp('hiredvehicleNoId').getValue(),
								hiredAmount: Ext.getCmp('hiredAmountId').getValue(),
								hiredVehicleKMS: Ext.getCmp('hiredVechKmsId').getValue(),
                    			customerID: Ext.getCmp('custcomboId').getValue(),
                    			uniqueId: uniqueId,
                    			stateModify: stateModify,
                    			stateModifyName:stateModifyName,
                    			statusIdModify:statusIdModify,
								statusNameModify:statusNameModify,
								reasonIdsModify:reasonIdsModify,
								reasonNameModify:reasonNameModify
                            },
                            success: function (response, options) {
								var message = response.responseText;
								Ext.example.msg(message);
                               
								Ext.getCmp('startDateTime').reset();
								Ext.getCmp('statecomboId').reset();
                                Ext.getCmp('locationId').reset();
                                Ext.getCmp('vehiclecomboId').reset();
                                Ext.getCmp('vehicleGroupId').reset();
                    			Ext.getCmp('tripStatusComboId').reset();   
                    			Ext.getCmp('reasonComboId').reset();  
                    			Ext.getCmp('openKmsId').reset();  
                    			Ext.getCmp('hiredvehicleNoId').reset();   
                    			Ext.getCmp('hiredAmountId').reset();   
                    			Ext.getCmp('hiredVechKmsId').reset(); 
                    				Ext.getCmp('ownerVehId').reset();
                                Ext.getCmp('marketVehId').reset();  
                    			myWin.hide();
                    			myWin.getEl().unmask();  
                    			store.load({
				                    params: {
				                        CustID: Ext.getCmp('custcomboId').getValue(),
				                        startdate: Ext.getCmp('startdate').getValue(),
				                        enddate: Ext.getCmp('enddate').getValue(),
				                        custName : Ext.getCmp('custcomboId').getRawValue(),
				                        jspName: jspName
				                  }
				               });
                              			custId=Ext.getCmp('custcomboId').getValue();
								  	    sdates=Ext.getCmp('startDateTime').getValue();
								      	 vehiclestore.load({
				                           params: {
				                         CustId: custId,
				                         startDate:sdates
				                              }
				                          });
                                stateComboStore.reload();
				                tripStatusStore.reload();
				                reasonStore.reload();
                            },
                            failure: function () {
								Ext.example.msg("Error");
								myWin.hide();
                            }
                        });
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=cancel%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls : 'cancelbutton',
        width: '80',
        listeners: {
      
            click: {
                fn: function () {
                    myWin.hide();
                }
            }
        }
    }]
});

   	
   //****************************** Window For Adding Trip Information Ends Here************************
 		var outerPanelWindow = new Ext.Panel({
   		standardSubmit: true,
   		id:'radiocasewinpanelId',
    	frame: true,
        height: 790,
        width: 458,  
    	items: [caseInnerPanel, winButtonPanel]
		});
  
   //************************* Outer Pannel *******************************************//
 myWin = new Ext.Window({
    title: 'My Window',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    height: 520,
    width: 471,
    id: 'myWin',
    items: [outerPanelWindow]
});

    
   //**************************Outer Pannel Ends Here *********************************//
   
   
   //**************************Function For Adding Customer Information For Trip*******************
      function addRecord() {
       Ext.getCmp('startDateTime').reset();
       Ext.getCmp('tripStatusComboId').reset();  
	//alert('Insdie Add');
    	if (Ext.getCmp('custcomboId').getValue() == "") {
             Ext.example.msg("<%=pleaseSelectcustomer%>");
             Ext.getCmp('custcomboId').focus();
        	 return;
    	}
    	buttonValue = "add";
    	title = '<%=addTripInformation%>';
    	myWin.setTitle(title);
    	 Ext.getCmp('startDateTime').setValue(datecur);
    	 Ext.getCmp('tripStatusComboId').setValue('On Route');
		 Ext.getCmp('statecomboId').reset();
         Ext.getCmp('locationId').reset();
         Ext.getCmp('vehiclecomboId').reset();
         Ext.getCmp('vehicleGroupId').reset();   
         Ext.getCmp('reasonComboId').reset();   
         Ext.getCmp('openKmsId').reset();    
         Ext.getCmp('hiredvehicleNoId').reset();   
         Ext.getCmp('hiredAmountId').reset();   
         Ext.getCmp('hiredVechKmsId').reset();
    	 Ext.getCmp('ownerVehId').enable();
         Ext.getCmp('marketVehId').enable();
         Ext.getCmp('ownerVehId').setValue(true);
         Ext.getCmp('marketVehId').setValue(false);
         Ext.getCmp('startDateTime').enable();
		 Ext.getCmp('vehiclecomboId').enable();
		 Ext.getCmp('openKmsId').enable();
         Ext.getCmp('vehicleGroupId').disable();
         Ext.getCmp('hiredDetailsPanelId').hide();
         Ext.getCmp('hiredvehicleNoLabelId').hide();
		 Ext.getCmp('hiredAmountLabelId').hide();
		 Ext.getCmp('hiredVechKmsLabelId').hide();
		 Ext.getCmp('hiredvehicleNoId').hide();  
         Ext.getCmp('hiredAmountId').hide();   
         Ext.getCmp('hiredVechKmsId').hide();
	     Ext.getCmp('reasonlabelId').hide();
	   	 Ext.getCmp('reasonId').hide();
	     Ext.getCmp('reasonComboId').hide();
	     myWin.show(); 
	}
	
	
   //*********************** Function to Modify Data ***********************************
    function check(){
     var selected = grid.getSelectionModel().getSelected();
		                Ext.getCmp('startDateTime').setValue(selected.get('sdate'));
				        Ext.getCmp('statecomboId').setValue(selected.get('state'));
				        Ext.getCmp('locationId').setValue(selected.get('location'));
						Ext.getCmp('reasonComboId').setValue(selected.get('reasonForOffRoad'));
	 					Ext.getCmp('hiredvehicleNoId').setValue(selected.get('registrationNo'));
				        Ext.getCmp('hiredAmountId').setValue(selected.get('hiredAmount'));
				        Ext.getCmp('hiredVechKmsId').setValue(selected.get('hiredVehicleKmsRun')); 
                    	Ext.getCmp('reasonlabelId').show();
				   	 	Ext.getCmp('reasonId').show();
				    	Ext.getCmp('reasonComboId').show();
				    	//alert('modi');
				    	Ext.getCmp('hiredDetailsPanelId').show();
				    	Ext.getCmp('hiredvehicleNoLabelId').show();
						Ext.getCmp('hiredAmountLabelId').show();
						Ext.getCmp('hiredVechKmsLabelId').show();
						//alert('between');
				    	Ext.getCmp('hiredvehicleNoId').show(); 
                    	Ext.getCmp('hiredAmountId').show();   
                    	Ext.getCmp('hiredVechKmsId').show();
                    	//alert('modi2');
    }
    function modifyData() {
    //alert('modify data');
    if (Ext.getCmp('custcomboId').getValue() == "") {
    	Ext.example.msg("<%=pleaseSelectcustomer%>");
    	Ext.getCmp('custcomboId').focus();
        return;
    }
    if(grid.getSelectionModel().getCount()>1){
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
 
    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRecordsFound%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    var selected = grid.getSelectionModel().getSelected();
    if(selected.get('status')=='Closed'){
    	Ext.example.msg("You Cannot Modify the Closed Trip..");
    	return;
    }
    buttonValue = "modify";
       // disableTabElements();
        titel = "<%=modifyTripInformation%>"
        myWin.setTitle(titel);
        var selected = grid.getSelectionModel().getSelected();
        
    var ownVehicle;
    var marketVehicle;
    if(selected.get('tripStatus')=="Off Route"||selected.get('tripStatus')=="Off Road"||selected.get('tripStatus')=="On Route"){
    ownVehicle=1;
    }
    if(selected.get('tripStatus')==""){
    marketVehicle=2;
    }
    myWin.show();
    if(ownVehicle==1){
    	Ext.getCmp('ownerVehId').disable();
        Ext.getCmp('marketVehId').disable();
		Ext.getCmp('ownerVehId').setValue(true);
        Ext.getCmp('vehicleGroupId').disable();
        Ext.getCmp('startDateTime').disable();
        Ext.getCmp('vehiclecomboId').disable();
        Ext.getCmp('openKmsId').disable();
        Ext.getCmp('startDateTime').setValue(selected.get('sdate'));
        Ext.getCmp('statecomboId').setValue(selected.get('state'));
        Ext.getCmp('locationId').setValue(selected.get('location'));
        Ext.getCmp('vehiclecomboId').setValue(selected.get('registrationNo')); 
        Ext.getCmp('tripStatusComboId').setValue(selected.get('tripStatusIds'));    
        Ext.getCmp('tripStatusComboId').setValue(selected.get('tripStatus'));
        Ext.getCmp('openKmsId').setValue(selected.get('OpeningKms'));
        Ext.getCmp('tripStatusComboId').setValue(selected.get('tripStatus'));
        var row = vehiclestore.findExact('Registration_No',selected.get('registrationNo'));
		var rec = vehiclestore.getAt(row);
		 if(rec!=null||rec==""){
		  Ext.getCmp('vehicleGroupId').setValue(rec.data['Vehicle_group']); 
       	  }else{
          Ext.getCmp('vehicleGroupId').setValue(''); 
       	 }
        if(selected.get('tripStatus')=="Off Route"||selected.get('tripStatus')=="Off Road"){
		Ext.getCmp('hiredDetailsPanelId').show();
		Ext.getCmp('hiredvehicleNoLabelId').show();
		Ext.getCmp('hiredAmountLabelId').show();
		Ext.getCmp('hiredVechKmsLabelId').show();
		Ext.getCmp('hiredvehicleNoId').show();   
        Ext.getCmp('hiredAmountId').show();   
        Ext.getCmp('hiredVechKmsId').show(); 
	    Ext.getCmp('reasonlabelId').show();
	   	Ext.getCmp('reasonId').show();
	    Ext.getCmp('reasonComboId').show();
	    Ext.getCmp('reasonComboId').setValue(selected.get('reasonForOffRoad'));
        Ext.getCmp('hiredvehicleNoId').setValue(selected.get('hiredVehicleNo'));
        Ext.getCmp('hiredAmountId').setValue(selected.get('hiredAmount'));
        Ext.getCmp('hiredVechKmsId').setValue(selected.get('hiredVehicleKmsRun'));     
	    }else{
	    Ext.getCmp('hiredDetailsPanelId').hide();
	    Ext.getCmp('hiredvehicleNoLabelId').hide();
		Ext.getCmp('hiredAmountLabelId').hide();
		Ext.getCmp('hiredVechKmsLabelId').hide();
		Ext.getCmp('hiredvehicleNoId').hide();  
        Ext.getCmp('hiredAmountId').hide();   
        Ext.getCmp('hiredVechKmsId').hide();
	    Ext.getCmp('reasonlabelId').hide();
	   	Ext.getCmp('reasonId').hide();
	   	Ext.getCmp('reasonComboId').hide();
	   	Ext.getCmp('reasonComboId').reset();  
        Ext.getCmp('hiredvehicleNoId').reset();   
        Ext.getCmp('hiredAmountId').reset();   
        Ext.getCmp('hiredVechKmsId').reset(); 
	    }
    }
   // myWin.show();
    if(marketVehicle==2){
					    Ext.getCmp('ownerVehId').setValue(false);
					    Ext.getCmp('ownerVehId').disable();
					    Ext.getCmp('marketVehId').setValue(true);
					    Ext.getCmp('marketVehId').disable();
					    check();
    }
        
    }
   
   //*********************** Function to Modify Data Ends Here **************************	
   
   //*********************** Function to Delete Data starts Here **************************//
   function deleteData(){
   
  				var selected = grid.getSelectionModel().getSelected();
                var vehicleNumber = selected.get('registrationNo');
				var status=selected.get('status');
				var uid=selected.get('uniqueIdDataIndex');					    		
		   		if(status=='Closed'){
		    	Ext.example.msg("You Cannot delete the Closed Trip	");
		    	return;
		    	}
 
      if(grid.getSelectionModel().getCount()>1){
                            Ext.example.msg("<%=SelectSingleRow%>");
           					return;
       						}
  
      Ext.Msg.show({
        title: '<%=delete%>',
        msg: '<%=wantToDelete%>',
        progressText: 'Deleting  ...',
        buttons: {
            yes: true,
            no: true
        },

        fn: function (btn) {
            switch (btn) {
            case 'yes':
                //Ajax request
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/TripCreation.do?param=deleteOpenedTrip',
                    method: 'POST',
                    params: {
                        vehicleNumber:vehicleNumber,
                        custId:Ext.getCmp('custcomboId').getValue(),
						uniqueId:uid
                    },
                    success: function (response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                        store.load({
                   		 params: {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        startdate: Ext.getCmp('startdate').getValue(),
                        enddate: Ext.getCmp('enddate').getValue(),
                        custName : Ext.getCmp('custcomboId').getRawValue(),
                        jspName: jspName
                  }

               });

                    },
                    failure: function () {
                        Ext.example.msg(message);
                        store.reload();
                        outerPanelWindow.getEl().unmask();

                    }
                });

                break;
            case 'no':
                Ext.example.msg("Details not Deleted..");
                store.reload();
                break;

            }
        }
    });
 }
 	//*********************** Function to Delete Data ends Here **************************//
 	
   // ***********************    Main Starts From Here *********************************//		
   	
   	Ext.onReady(function () {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';

    outerPanel = new Ext.Panel({
        //title: 'Trip Creation',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        //cls: 'outerpanel',
        height:500,
        width:screen.width-40,
        items: [customerPanel,grid]
    });
    Ext.getCmp('reasonlabelId').hide();
    Ext.getCmp('reasonId').hide();
    Ext.getCmp('reasonComboId').hide();
     
});

	// ***********************    Main Ends Here *********************************//	
   		</script>
	</body>
</html>
<%}%>
