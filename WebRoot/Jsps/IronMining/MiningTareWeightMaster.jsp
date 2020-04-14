<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
Properties prop = ApplicationListener.prop;
String RFIDwebServicePath=prop.getProperty("WebServiceUrlPathForRFID");
String WEIGHTwebServicePath=prop.getProperty("WebServiceUrlPathForWeight");
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		LoginInfoBean loginInfo1=new LoginInfoBean();
		loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
		if(loginInfo1!=null)
		{
		int isLtsp=loginInfo1.getIsLtsp();
		loginInfo.setIsLtsp(isLtsp);
		}
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
		if(str.length>12){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf=new CommonFunctions();
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo==null){
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
	}
	else
	{   
	    session.setAttribute("loginInfoDetails", loginInfo);    
		String language = loginInfo.getLanguage();
		ArrayList<String> tobeConverted=new ArrayList<String>();
		tobeConverted.add("Mining_Tare_Weight_Master");
		tobeConverted.add("Please_Select_customer");
		tobeConverted.add("Select_Customer");
		tobeConverted.add("SLNO");
		tobeConverted.add("Type");
		tobeConverted.add("Asset_Number");
		tobeConverted.add("Tare_Weight");
		tobeConverted.add("Quantity");
		tobeConverted.add("Weight_Date_Time");
		tobeConverted.add("No_Records_Found");
		tobeConverted.add("Add_Tare_Weight_Information");
		tobeConverted.add("Modify_Tare_Weight_Information");
		tobeConverted.add("Select_Single_Row");
		tobeConverted.add("Select_Type");
		tobeConverted.add("select_vehicle_No");
		tobeConverted.add("Enter_Quantity");
		tobeConverted.add("Select_Weight_Date_Time");
		tobeConverted.add("Vehicle_No");
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
		
		ArrayList<String> convertedWords=new ArrayList<String>();
        convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
		
		String MiningTripSheetGeneration=convertedWords.get(0);
		String pleaseSelectcustomer=convertedWords.get(1);
		String selectCustomer=convertedWords.get(2);
		String SLNO=convertedWords.get(3);
		String type=convertedWords.get(4);
		String assetNumber=convertedWords.get(5);
		String TareWeight=convertedWords.get(6);
		String quantity=convertedWords.get(7);
		String ValidityDateTime=convertedWords.get(8);
		String noRecordsFound=convertedWords.get(9);
		String addTripSheetInformation=convertedWords.get(10);
		String modifyTripSheetInformation=convertedWords.get(11);
		String SelectSingleRow=convertedWords.get(12);
		String selectType=convertedWords.get(13);
		String selectVehicleNO=convertedWords.get(14);
		String enterQuantity=convertedWords.get(15);
		String SelectValidityDate=convertedWords.get(16);
		String VehicleNo=convertedWords.get(17);
		String EnterVehicleNo=convertedWords.get(18);
		String ReadRFID=convertedWords.get(19);
		String SomethingWronginRFID=convertedWords.get(20);
		String kgs=convertedWords.get(21);
		String Capture=convertedWords.get(22);
		String CaptureQuantity=convertedWords.get(23);
		String SomethingWronginweight=convertedWords.get(24);
		String Save=convertedWords.get(25);
		String Cancel=convertedWords.get(26);
		String WeightDateTime=convertedWords.get(27);
		String enterTareWeight=convertedWords.get(28);
		
		int systemId = loginInfo.getSystemId();
		int userId=loginInfo.getUserId(); 
		int customerId = loginInfo.getCustomerId();
	    String userAuthority=cf.getUserAuthority(systemId,userId);	
	    String addButton="true";
	    String modifyButton="true";
		if(customerId > 0 && loginInfo.getIsLtsp()== -1 && userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
		
	else{
	
		if(customerId > 0 && loginInfo.getIsLtsp()== -1 && userAuthority.equalsIgnoreCase("User"))
	{
		addButton="true";
		modifyButton="true";
	}
	else if(customerId > 0 && loginInfo.getIsLtsp()== -1 && userAuthority.equalsIgnoreCase("Supervisor"))
	{
	    addButton="false";
		modifyButton="false";
	}
%>

<jsp:include page="../Common/header.jsp" />
 		<title>Mining Tare Weight Report</title>		
 
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.quantityBox
	{
	background-color: white ;
    padding: 10px !important;
    width: 110px !important;
    height: 40px !important;
    margin: 10px !important;
    line-height: 20px !important;
    color: black;
    font-weight: bold !important;
    font-size: 2em !important;
    text-align: center !important;
	}
	.my-label-style {
    font-weight: bold; 
    font-size: 23px;
    text-align: center;
    margin-left: 20px;
}
  .my-label-style2{
	spacing: 10px;
	height: 20px;
	width: 150 px !important;
	min-width: 150px !important;
	margin-bottom: 5px !important;
	margin-left: 5px !important;
	font-size: 12px;
	font-family: sans-serif;
	text-align:center; 
	vertical-align:middle;
  }
  .ui-helper-hidden-accessible{visibility: hidden; display: none;}
.ui-autocomplete { overflow-y: scroll; max-height: 130px; position: absolute; min-width: 160px; padding: 4px 0; margin: 0 0 10px 25px; background-color: #ffffff;}
.ui-menu-item { background: #ffffff; border-color: #ffffff; padding: 2.5px 0;}
.ui-state-hover, .ui-state-focus, .ui-state-active { color: #ffffff; text-decoration: none; background-color: #5f6f81; border-radius: 0px; -webkit-border-radius: 0px; -moz-border-radius: 0px; background-image: none; }
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
			#quantityId {
				height : 60px !important;
           	    width  : 120px !important;
			}	
		</style>
	 <%}%>
        <script src="../../Main/Js/modernizr.custom.js"></script>
		<script src="../../Main/modules/common/homeScreen/js/digitalTimer.js"></script>
		<script src="../../Main/Js/jquery.js"></script>
        <script src="../../Main/Js/jquery-ui.js"></script>
		
   <script>
 
        var grid;
		var myWin;
		var buttonValue;
		var uniqueId;
		var closewin;
		var outerPanel;
		var AssetNo;
	 	var jspName='MiningTareWeightReport';
    	var exportDataType = "int,string,string,string,number,string,string,string";
    	var el;
    	var rsSource;
		var rsDestination;
		var transactionNo;
        var dtprev = dateprev;
		var dtcur = datecur;
		var dtnxt = datenext;
 	    var listOfAssetnum = [];
 //----------------------------------------------------------------------------//
 var WeightStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/TripSheetGenerationAction.do?param=getCaptureWeight',
    id: 'rfidStoreId',
    root: 'rfidRoot',
    autoload: false,
    remoteSort: true,
    fields: ['Weight'],
    listeners: {
        load: function() {}
    }
});
   //--------------------------------------------------------------------------//
    var Typecombostore = new Ext.data.SimpleStore({
    id: 'TypecombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['RFID', 'RFID'],
        ['APPLICATON', 'APPLICATION']
    ]
   });
   
   var typecombo = new Ext.form.ComboBox({
    store: Typecombostore,
    id: 'typecomboId',
    mode: 'local',
    forceSelection: true,
    resizable: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    displayField: 'Name',
    value: Typecombostore.getAt(1).data['Value'],
    cls: 'selectstylePerfect',
	blankText: '<%=selectType%>',
    emptyText: '<%=selectType%>',
    listeners: {
        select: {
            fn: function() {
                  vehicleComboStore.load({
				                    params: {
				                    CustId: Ext.getCmp('custcomboId').getValue(),
				                    },
				                    callback: function(){
                    		        listOfAssetnum=[];
                    		        for(var i=0; i<vehicleComboStore.getCount(); i++){
								    var rec = vehicleComboStore.getAt(i);
				                    listOfAssetnum.push(rec.data['vehicleName']);
				                     }
				                     }
				             });
				 //alert( Ext.getCmp('typecomboId').getValue())25px;
                 //alert();
                 var typeValue= Ext.getCmp('typecomboId').getValue();
                   el = Ext.get("ext-comp-1031");
				   el.setWidth(87);
                   el = Ext.get("ext-comp-1032");
				   el.setWidth(45);
				    el = Ext.get("ext-comp-1034");
				    el.setWidth(50);
				   
  				 if(typeValue=='RFID'){
  				 document.getElementById('detailsFirstMaster').style.height = "25px";
  				 
  				     el = Ext.get("ext-comp-1031");
				     el.setWidth(87);
				     el = Ext.get("ext-comp-1032");
				     el.setWidth(54);
				   Ext.getCmp('RFIDId').reset();
				   Ext.getCmp('vehicleRFIDPanelId').show();
				   Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
					   Ext.getCmp('mandatoryVehicleId').hide();
					   Ext.getCmp('VehicleNoID').hide();
					   Ext.getCmp('vehiclecomboId').hide();
						  
					   Ext.getCmp('mandatoryRfid').show();
					   Ext.getCmp('RFIDIDs').show();
					   Ext.getCmp('RFIDId').show();
					   Ext.getCmp('RFIDButtId').show();
				  }
				  if(typeValue=='APPLICATION'){
				  document.getElementById('detailsFirstMaster').style.height = "45px";
				   el = Ext.get("ext-comp-1031");
				   el.setWidth(87);
				   el = Ext.get("ext-comp-1032");
				   el.setWidth(45);
				   Ext.getCmp('vehiclecomboId').reset();
				  Ext.getCmp('vehicleRFIDPanelId').show(); 
				  Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
				 
				   Ext.getCmp('mandatoryRfid').hide();
				   Ext.getCmp('RFIDIDs').hide();
				   Ext.getCmp('RFIDId').hide();
				   Ext.getCmp('RFIDButtId').hide();
				    
				   Ext.getCmp('mandatoryVehicleId').show();
				   Ext.getCmp('VehicleNoID').show();
				   Ext.getCmp('vehiclecomboId').show();
				   }
            }
        }
    }
});

//************************ Store for Vehicel Number  Here***************************************//
	var vehicleComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/MiningTareWeightMasterAction.do?param=getVehicleList',
    id: 'vehicleComboStoreId',
    root: 'vehicleComboStoreRoot',
    autoload: false,
    remoteSort: true,
    fields: ['vehicleNoID', 'vehicleName','UnLadenWeight']
});

var vehicleCombo = new Ext.form.ComboBox({
    store: vehicleComboStore,
    id: 'vehiclecomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    resizable: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    listWidth:150,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'vehicleNoID',
    displayField: 'vehicleName',
    cls: 'selectstylePerfect',
    emptyText: '<%=selectVehicleNO%>',
    blankText: '<%=selectVehicleNO%>',
    listeners: {
        select: {
            fn: function() {
               
            }
        }
    }
});

//------------------------------validity Date-------------------------//

<!--var StartDate = new Ext.form.DateField({-->
<!--			width: 185,-->
<!--			format: getDateTimeFormat(),-->
<!--			id: 'startDateTime',-->
<!--            value: datecur,-->
<!--            //minValue:endDateMinVal,-->
<!--   			//maxValue: new Date(),-->
<!--            vtype: 'daterange',-->
<!--			cls:'selectstylePerfect',-->
<!--		    blankText: '<%=SelectValidityDate%>',-->
<!--		    allowBlank:false,-->
<!--				listeners: 	{-->
<!--				     select:{-->
<!--				         fn: function(){-->
<!--				        -->
<!--				         }//function-->
<!--				       }//select-->
<!--					}//listeners-->
<!--	    });-->

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
                 var cm = grid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,155);
					    }
				vehicleComboStore.load({
				                    params: {
				                    CustId: Ext.getCmp('custcomboId').getValue(),
				                    },
				                    callback: function(){
                    		        listOfAssetnum=[];
                    		        for(var i=0; i<vehicleComboStore.getCount(); i++){
								    var rec = vehicleComboStore.getAt(i);
				                    listOfAssetnum.push(rec.data['vehicleName']);
				                     }
				                     }
				             });
				
			    // WeightStore.load({
			     //   params: {CustId: custId}
			   //});
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
                custId = Ext.getCmp('custcomboId').getValue();
                 var cm = grid.getColumnModel();  
					    for (var j = 1; j < cm.getColumnCount(); j++) {
					       cm.setColumnWidth(j,200);
					    }
             	vehicleComboStore.load({
				                    params: {
				                    CustId: Ext.getCmp('custcomboId').getValue()
				                     }
				             });
				
				// WeightStore.load({
			     //   params: {CustId: custId}
			   //});                                                  
            }
        }
    }
	});
	
//*********************************** Combo for asset Store starts here**********************************************************//
	

var assetCombo = new Ext.form.ComboBox({
    store: vehicleComboStore,
    id: 'assetcomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    resizable: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    listWidth:180,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'vehicleNoID',
    displayField: 'vehicleName',
    cls: 'selectstylePerfect',
    emptyText: 'Select Asset Number',
    blankText: 'Select Asset Number',
    listeners: {
        select: {
            fn: function() {
               
            }
        }
    }
});

// **********************************************Reader configs Starts******************************
    
     var reader = new Ext.data.JsonReader({
        idProperty: 'tripcreationId',
    	root: 'miningTareWeightDetailsRoot',
    	totalProperty: 'total',
    	fields: [{
        name: 'slnoIndex'
    	},{
        name: 'TypeIndex'
    	},{
        name: 'assetNoIndex'
    	},{
    	name: 'tareWeightIndex'
    	},{
        name: 'WeightDateTimeIndex',
          type: 'date',
  		  dateFormat: getDateTimeFormat()
        },{
    	name: 'uniqueIDIndex'
    	}]
    });
    
    // **********************************************Reader configs Ends******************************
    //********************************************Store Configs For Grid*************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MiningTareWeightMasterAction.do?param=getMiningTareWeightDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'miningTripsheetDetailsStore',
        reader: reader
        });
     
   //********************************************Store Configs For Grid Ends*************************
    //********************************************************************Filter Config***************
       
    	var filters = new Ext.ux.grid.GridFilters({
        local: true,
    	filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    	},{
    	type: 'string',
        dataIndex: 'TypeIndex'
    	},{
    	type: 'string',
        dataIndex: 'assetNoIndex'
    	},{
        type: 'string',
        dataIndex: 'tareWeightIndex'
    	},{
    	type: 'date',
        dataIndex: 'WeightDateTimeIndex'
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
        	header: "<span style=font-weight:bold;><%=type%></span>",
        	dataIndex: 'TypeIndex',
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=assetNumber%></span>",
        	dataIndex: 'assetNoIndex',
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=TareWeight%></span>",
        	dataIndex: 'tareWeightIndex',
        	align: 'right',
        	//width: 80,
        	filter: {
            type: 'string'
        	}
    		},{
        	header: "<span style=font-weight:bold;><%=WeightDateTime%></span>",
        	dataIndex: 'WeightDateTimeIndex',
        	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
        	//width: 80,
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
     //*********************************************Column model config Ends*************************** 	
    //******************************************Creating Grid By Passing Parameter***********************
    
     grid = getGrid('<%=MiningTripSheetGeneration%>', '<%=noRecordsFound%>', store,screen.width-55,420, 20, filters, 'Clear Filter Data', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', <%=addButton%>, 'Add', false, 'Modify');
     		
	//**********************************End Of Creating Grid By Passing Parameter*************************
	var customerPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'customerComboPanelId',
     layout: 'table',
     frame: false,
     width: screen.width - 30,
     height: 75,
     layoutConfig: {
         columns: 11
     },
		items: [{width:30},{
		            xtype: 'label',
           		    text: '<%=selectCustomer%>' + ' :',
            		cls: 'labelstyle',
            		id: 'custnamelab'
        			},
        			custnamecombo,
              {
                width: 80
            },
            {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'startdatelab',
              text: 'Start Date' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 100,
              format: getDateFormat(),
              id: 'startdate',
              maxValue:dtcur,
              value: dtcur,
              endDateField: 'enddate'
          }, {width:60},{
              xtype: 'label',
              cls: 'labelstyle',
              id: 'enddatelab',
              text: 'End Date' + ' :'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 100,
              format: getDateFormat(),
              id: 'enddate',
              maxValue:dtnxt,
              value: dtnxt,
              startDateField: 'startdate'
          },{width:50},{
                xtype: 'button',
                text: 'view',
                id: 'generateReport',
                cls: 'buttonwastemanagement',
                width: 60,
                listeners: {
                    click: {
                        fn: function() {
                            Ext.getCmp('autoCompleteId').setValue('');
                            if (Ext.getCmp('custcomboId').getValue() == "") {
                               Ext.example.msg("Select Customer");
                                Ext.getCmp('custcomboId').focus();
                                 return;
             				  }
             				 if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                                                Ext.example.msg("End date must be greater than Start date");
                                                Ext.getCmp('enddate').focus();
                                                return;
                                            }
                                            var Startdates = Ext.getCmp('startdate').getValue();
                                            var Enddates = Ext.getCmp('enddate').getValue();
                                            var dateDifrnc = new Date(Enddates).add(Date.DAY, -30);
                                            if (Startdates < dateDifrnc) {
                                                Ext.example.msg("Difference between two dates should not be  greater than 30 days.");
                                                Ext.getCmp('startdate').focus();
                                                return;
                                            }
                           store.load({
		                    params: {
		                       buttonValue:'view',
		                       CustID: Ext.getCmp('custcomboId').getValue(),
		                       jspName: jspName,
		                       CustName: Ext.getCmp('custcomboId').getRawValue(),
		                       Assetnumber:'',
		                       startdate:Ext.getCmp('startdate').getValue(),
		                       enddate:Ext.getCmp('enddate').getValue()
		                 	}
              				});
              			 }
                    }
                }
            },{width:50},{
                    xtype: 'label',
           		    text: 'Asset Number' + ' : ',
            		cls: 'labelstyle',
            		id: 'asset1'
            		},{
                   xtype: 'textfield',
	               id: 'autoCompleteId',
	               enableKeyEvents : true,
	               emptyText: 'Asset Number',
	               listeners: {
	               		keyup: function(f,n,o){
	               			 $( "#autoCompleteId" ).autocomplete({
						source: listOfAssetnum,
				      	select: function(event, ui) {
				      		var val = ui.item.value;	
				      		if(val!="") {			 			
					 			$('#autoCompleteId').keyup(function(){
					 				if (!this.value) {
					 					
									}
					 			});
					 		}
		            	}
				    });
	               	}
	               }	                    
               },{width:50},{
                xtype: 'button',
                text: 'Search By Asset Number',
                id: 'generateReport1',
                cls: 'buttonwastemanagement',
                width: 60,
                listeners: {
                    click: {
                        fn: function() {
                            if (Ext.getCmp('custcomboId').getValue() == "") {
                                Ext.example.msg("Select Customer");
                                Ext.getCmp('custcomboId').focus();
                                 return;
             				  }
             				  
             				 if (Ext.getCmp('autoCompleteId').getValue() == "") {
                                Ext.example.msg("Enter Asset Number");
                                Ext.getCmp('autoCompleteId').focus();
                                 return;
             				  }
             				  
             				  store.load({
		                      params: {
		                       buttonValue:'Search By Asset Number',
		                       CustID: Ext.getCmp('custcomboId').getValue(),
		                       jspName: jspName,
		                       CustName: Ext.getCmp('custcomboId').getRawValue(),
		                       Assetnumber:Ext.getCmp('autoCompleteId').getValue().toUpperCase()
		                 	}
              				});
             		  }
                    }
                }
                }
              
           ]
				});	    	
//------------------------------------------------------------------------//	    
var detailsFirstPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'detailsFirstMaster',
    			layout: 'table',
    			frame: false,
    			border:false,
    			height:50,
				width :433,
    			layoutConfig: {
        		columns:5
    			},
    			items: [{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryTypeId'
               },{
            		xtype: 'label',
           		    text: 'Type' + ' :',
            		cls: 'labelstyle',
            		id: 'typeNamelab'
        		},{width:87},typecombo,{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryTypeid'
                 }
        			]
	});
//----------------------------------------------------------------//	
 var vehicleRFIDPanel = new Ext.Panel({ 
		        id: 'vehicleRFIDPanelId', 
                standardSubmit: true,
    			hidden: true,
    			layout: 'table',
    			frame: false,
    			//height:80,
				width :437,
    			layoutConfig: {
        		columns: 6
    			},	
			items:[{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryVehicleId'
               },{
                   xtype: 'label',
                   text: '<%=VehicleNo%>' + ' :',
                   cls: 'labelstyle',
                   id: 'VehicleNoID'
               },{width:48},vehicleCombo,{width:20},{
                   xtype: 'label',
                   text: '',
                   cls: 'mandatoryfield',
                   id: 'mandatoryVehicleNoId'
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
                   id: 'RFIDId'
               },{width:20},{
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
		                            url: '<%=request.getContextPath()%>/MiningTareWeightMasterAction.do?param=getRFID',
		                            method: 'POST',
		                            params: {
		                            RFIDValue:RFIDValue,
		                            CustID: Ext.getCmp('custcomboId').getValue()
		                            },
		                            success: function (response, options) {
										var message = response.responseText;
										var vehicleNos = message.replace(/[\:'",.\{\}\[\]\\\/]/gi,'');
										if(vehicleNos=="vno"){
										Ext.example.msg("<%=SomethingWronginRFID%>");
										Ext.getCmp('RFIDId').setValue("<%=EnterVehicleNo%>");
										}else{
										var vehicleNoss = vehicleNos.substring(3);
										Ext.getCmp('RFIDId').setValue(vehicleNoss);
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
               }
			   ]
    }); 
var detailsSecondPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'detailsSecondMaster',
    			layout: 'table',
    			frame: false,
    			height:100,
				width :437,
    			layoutConfig: {
        		columns: 6
    			},
    			items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorytripsheetNumberId'
            },{
                xtype: 'label',
                text: '<%=TareWeight%>'+'  :',
                cls: 'labelstyle',
                id: 'tripsheetNumberLabelId'
            },{width:12},{
			    xtype: 'textfield',
                cls: 'selectstylePerfect',  
                readOnly:true,  
                emptyText: '<%=enterTareWeight%>',
                blankText: '<%=enterTareWeight%>',
                id: 'enrollNumberId',
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber1'
            },
            //-------------------------------------//
            {
                xtype: 'label',
                text: ' ',
                cls: 'labelstyle',
                id: 'tripsheetNumberLabel55'
            },{
			    xtype: 'label',
			     text: '',
                cls: 'selectstylePerfect',               
                id: 'enrollNumberId55',
            },{width:12},{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber55'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber1554'
            },{
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'mandatoryTripsheetNumber155d'
            },
            //---------------------//
            {
                xtype: 'label',
                text: ' ',
                cls: 'mandatoryfield',
                id: 'mandatorydateValidityDateTime77'
				}, {
					xtype: 'label',
					text: ' ',
					cls: 'labelstyle',
					id: 'validitydateTimeLabelId77'
				},{width:12},{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'mandatoryvalidityDateId77'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'mandatoryvalidityDateId877'
               },{
					   xtype: 'label',
					   text: '',
					   cls: 'mandatoryfield',
					   id: 'mandatoryvalidityDateId88'
               }]
	});
//-------------------------------Quantity Panel-------------------------------//
var innerThirdfirstPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'innerThirdMaster',
    			layout: 'table',
    			frame: false,
    			height:40,
				width :210,
    			layoutConfig: {
        		columns: 2
    			},
    			items: [{
                   xtype: 'label',
                   text: '*',
                   cls: 'mandatoryfield',
                   id: 'mandatoryQTYId'
               },{
                   xtype: 'label',
                   text: '<%=quantity%>' + '',
                   cls: 'my-label-style',
                   id: 'QuantityID'
               }]
	});
var innerThirdSecondPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'innerThirdSecondMaster',
    			layout: 'table',
    			frame: false,
    			height:90,
				width :210,
    			layoutConfig: {
        		columns: 3
    			},
    			items: [{width:15},{
                   xtype: 'textfield',
                   width:50,
                   height:60,
                   cls: 'quantityBox',
                   emptyText: '',
                   allowBlank: false,
				   readOnly:true,
                   blankText: '',
                   id: 'quantityId'
               },{
                   xtype: 'label',
                   text: '<%=kgs%>',
                   cls: 'my-label-style2',
                   id: 'kgsId'
               }]
	});
var innerThird3Panel = new Ext.FormPanel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'innerThird3Master',
    			layout: 'table',
    			frame: false,
    			height:140,
				width :210,
    			layoutConfig: {
        		columns: 2
    			},
    			items: [{width:44},{
                   xtype:'button',
                   text:'<%=Capture%>',
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
							//successfunction();
							//alert('hhh');
							//initiateConversion();
							$.ajax({
								type:"GET",
					    		url:'<%=WEIGHTwebServicePath%>',   			
					   			 success:
					       		 function(data){
                						//alert('ssssucess'+data);
					                   Ext.getCmp('quantityId').setValue(data);
					                   Ext.getCmp('enrollNumberId').setValue(data);
					        	}
					        	,error:function(){
					        	Ext.example.msg("<%=SomethingWronginweight%>");
					        	}	
							});
		                }//fun
		            }//click
      			  }//listeners
               }]
	});		
var detailsThirdPanel = new Ext.Panel({
   				standardSubmit: true,
    			collapsible: false,
    			id: 'detailsThirdMaster',
    			layout: 'table',
    			frame: true,
    			height:230,
				width :210,
    			layoutConfig: {
        		columns: 1
    			},
    			items: [innerThirdfirstPanel,innerThirdSecondPanel,innerThird3Panel]
	});
	//****************************** Window For Adding Trip Information****************************
	var interval;
   var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    height:50,
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
        text: '<%=Save%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        iconCls : 'savebutton',
        width: 80,
        listeners: {
            click: {
                fn: function () {
					 if (Ext.getCmp('typecomboId').getValue() == "") {
				    Ext.example.msg("<%=selectType%>");
				    Ext.getCmp('typecomboId').focus();
				    return;
				    }
					if(Ext.getCmp('typecomboId').getValue()=='RFID'){
					if (Ext.getCmp('RFIDId').getValue() == "") {
				    Ext.example.msg("<%=selectVehicleNO%>");
				    Ext.getCmp('RFIDId').focus();
				    return;
				    }
					}else{
					if (Ext.getCmp('vehiclecomboId').getValue() == "") {
				    Ext.example.msg("<%=selectVehicleNO%>");
				    Ext.getCmp('vehiclecomboId').focus();
				    return;
				    }
					}	
					if (Ext.getCmp('enrollNumberId').getValue() == "") {
				    Ext.example.msg("<%=enterTareWeight%>");
				    Ext.getCmp('enrollNumberId').focus();
				    return;
				    }
<!--				    var vehicleId;-->
<!--				     if(Ext.getCmp('typecomboId').getValue()=="RFID"){-->
<!--				        vehicleId=Ext.getCmp('RFIDId').getValue();-->
<!--				     }-->
<!--				     if(Ext.getCmp('typecomboId').getValue()=="APPLICATION"){-->
<!--				     	vehicleId=vehicleCombo.getRawValue();-->
<!--				     }-->
<!--                    var row = vehicleComboStore.findExact('vehicleName', vehicleId);-->
<!--                    var rec = vehicleComboStore.getAt(row);-->
<!--                    var ladenWeight=parseFloat((rec.data['UnLadenWeight'])/1000);-->
<!--                    var Tweight=parseFloat(Ext.getCmp('quantityId').getValue());-->
<!--                    if(ladenWeight==0){-->
<!--                       Ext.example.msg("Please enter Unladen weight");-->
<!--					   return;-->
<!--                    }-->
<!--                    if(ladenWeight<(Tweight-5) || ladenWeight>(Tweight+5)){-->
<!--                       Ext.example.msg("tare should not greater than or less than Unladen weight");-->
<!--					   return;-->
<!--                    }-->
				    var VehicleNoBaseType="";
				     var globalClientId=Ext.getCmp('custcomboId').getValue();
                     var customerName=Ext.getCmp('custcomboId').getRawValue();
				    if(Ext.getCmp('typecomboId').getValue()=="RFID"){
				       VehicleNoBaseType=Ext.getCmp('RFIDId').getValue();
				    }
				    if(Ext.getCmp('typecomboId').getValue()=="APPLICATION"){
				       VehicleNoBaseType=Ext.getCmp('vehiclecomboId').getValue();
				    }
			//-------------------------------------------------------------------------------------//	    
				    if (buttonValue == 'modify') {
				    	var leaseModify;
				    	var gradeModify;
				    	var routeModify;
                        var selected = grid.getSelectionModel().getSelected();
                        uniqueId = selected.get('uniqueIDIndex');
                     }
                    myWin.getEl().mask();
                    //Performs Save Operation
                     //Ajax request starts here
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MiningTareWeightMasterAction.do?param=saveormodifyTareWeight',
                            method: 'POST',
                            params: {
                            buttonValue:buttonValue,
                            CustID: Ext.getCmp('custcomboId').getValue(),
                            type:Ext.getCmp('typecomboId').getValue(),
                            vehicleNo:VehicleNoBaseType,
                            tareWeight:Ext.getCmp('enrollNumberId').getValue(),
                            //weightDateTime:Ext.getCmp('startDateTime').getValue(),
                            CustName: Ext.getCmp('custcomboId').getRawValue(),
                            quantity:Ext.getCmp('quantityId').getValue(),
                            uniqueId:uniqueId
                            },
                            success: function (response, options) {
								var message = response.responseText;
								Ext.example.msg(message);
										
                        		//Ext.getCmp('typecomboId').reset();
								Ext.getCmp('vehiclecomboId').reset();
								Ext.getCmp('RFIDId').reset();
								Ext.getCmp('enrollNumberId').reset();
								//Ext.getCmp('startDateTime').reset();
								Ext.getCmp('quantityId').reset();
                    			myWin.hide();
                    		    myWin.getEl().unmask();  
                            },
                            failure: function () {
								Ext.example.msg("Error");
								Ext.getCmp('mandatoryVehicleId').hide();
								Ext.getCmp('VehicleNoID').hide();
								Ext.getCmp('vehiclecomboId').hide();
								Ext.getCmp('mandatoryRfid').hide();
								Ext.getCmp('RFIDIDs').hide();
								Ext.getCmp('RFIDId').hide();
								Ext.getCmp('RFIDButtId').hide();
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
        cls: 'buttonstyle',
        iconCls : 'cancelbutton',
        width: '80',
        listeners: {
            click: {
                fn: function () {
                clearInterval(interval);
                	    var selected = grid.getSelectionModel().getSelected();
				        /*var type=selected.get('TypeIndex');
				        if(type=="RFID"){
				        Ext.getCmp('detailsFirstMaster').setHeight(25);
				        Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
				        }
				        if(type=="APPLICATION"){
				        Ext.getCmp('detailsFirstMaster').setHeight(45);
				        Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
						}*/
                Ext.getCmp('vehiclecomboId').reset();
				Ext.getCmp('RFIDId').reset();
				Ext.getCmp('quantityId').reset();
                Ext.getCmp('vehicleRFIDPanelId').hide(); 
				Ext.getCmp('mandatoryVehicleId').hide();
				Ext.getCmp('VehicleNoID').hide();
				Ext.getCmp('vehiclecomboId').hide();
				Ext.getCmp('mandatoryRfid').hide();
				Ext.getCmp('RFIDIDs').hide();
				Ext.getCmp('RFIDId').hide();
				Ext.getCmp('RFIDButtId').hide();
                    myWin.hide();
                }
            }
        }
    }]
});
//-----------------------------------------------------------//
	var caseInnerPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       width: 450,
       height:230,
       frame: true,
       id: 'addCaseInfo',
       layout: 'table',
       layoutConfig: {
           columns: 1
       },
    			items: [detailsFirstPanel,vehicleRFIDPanel,detailsSecondPanel]
	});
//----------------------------------------Inside two panel-------------------------------------------------//	
var caseTwoInnerPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       autoScroll: true,
       width: 685,
       height:250,
       frame: true,
       id: 'InneraddCaseInfo',
       layout: 'table',
       layoutConfig: {
           columns: 2
       },
    			items: [caseInnerPanel,detailsThirdPanel]
	});

//****************************** Window For Adding Trip Information Ends Here************************
 		var outerPanelWindow = new Ext.Panel({
   		standardSubmit: true,
   		id:'winpanelId',
    	frame: true,
        height: 320,
        width: 685,
    	items: [caseTwoInnerPanel, winButtonPanel]
		});
   //************************* Outer Pannel *********************************************************//
 myWin = new Ext.Window({
    title: 'My Window',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 360,
    width: 700,
    id: 'myWin',
    items: [outerPanelWindow]
});  

function addRecord() {  
    	if (Ext.getCmp('custcomboId').getValue() == "") {
             Ext.example.msg("<%=pleaseSelectcustomer%>");
             Ext.getCmp('custcomboId').focus();
        	 return;
    	}
interval=setInterval(function() {
      $.ajax({
								type:"GET",
					    		url:'<%=WEIGHTwebServicePath%>',   			
					   			 success:
					       		 function(data){
					            //alert('ssssucess'+data);
					            Ext.getCmp('quantityId').setValue(data);
					            Ext.getCmp('enrollNumberId').setValue(data);
					        	}	
							  });
 }, 5000);
    	buttonValue = "add";
    	 myWin.show(); 
    	title = '<%=addTripSheetInformation%>';
    	myWin.setTitle(title);
    	 var d = new Date();
        document.getElementById('detailsFirstMaster').style.height = "45px"; 
    	//Ext.getCmp('typecomboId').reset();
		Ext.getCmp('vehiclecomboId').reset();
		Ext.getCmp('RFIDId').reset();
		Ext.getCmp('enrollNumberId').reset();
		Ext.getCmp('quantityId').reset();		
    	Ext.getCmp('typecomboId').setDisabled(false);
        Ext.getCmp('RFIDId').enable;
        Ext.getCmp('RFIDButtId').setDisabled(false);
        Ext.getCmp('vehiclecomboId').setDisabled(false);
        Ext.getCmp('quantityId').setDisabled(false);
		Ext.getCmp('RFIDId').setDisabled(false);     
        Ext.getCmp('captureWeightId').enable();
		//Ext.getCmp('startDateTime').setValue(d);
		el = Ext.get("ext-comp-1034");
		el.setWidth(50);
		vehicleComboStore.load({
           params: {
           CustId: Ext.getCmp('custcomboId').getValue(),
           },
           callback: function(){
       	   listOfAssetnum=[];
       	   for(var i=0; i<vehicleComboStore.getCount(); i++){
           var rec = vehicleComboStore.getAt(i);
           listOfAssetnum.push(rec.data['vehicleName']);
           }
          }
        });
		if(Ext.getCmp('typecomboId').getValue()=='APPLICATION'){
		  document.getElementById('detailsFirstMaster').style.height = "45px";
		   el = Ext.get("ext-comp-1031");
		   el.setWidth(87);
		   el = Ext.get("ext-comp-1032");
		   el.setWidth(45);
		   Ext.getCmp('vehiclecomboId').reset();
		   Ext.getCmp('vehicleRFIDPanelId').show(); 
		   Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
		 
		   Ext.getCmp('mandatoryRfid').hide();
		   Ext.getCmp('RFIDIDs').hide();
		   Ext.getCmp('RFIDId').hide();
		   Ext.getCmp('RFIDButtId').hide();
		    
		   Ext.getCmp('mandatoryVehicleId').show();
		   Ext.getCmp('VehicleNoID').show();
		   Ext.getCmp('vehiclecomboId').show();
		 }else{
		   document.getElementById('detailsFirstMaster').style.height = "25px";
		   el = Ext.get("ext-comp-1031");
	       el.setWidth(87);
	       el = Ext.get("ext-comp-1032");
	       el.setWidth(54);
		   Ext.getCmp('RFIDId').reset();
		   Ext.getCmp('vehicleRFIDPanelId').show();
		   Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
		   Ext.getCmp('mandatoryVehicleId').hide();
		   Ext.getCmp('VehicleNoID').hide();
		   Ext.getCmp('vehiclecomboId').hide();
			  
		   Ext.getCmp('mandatoryRfid').show();
		   Ext.getCmp('RFIDIDs').show();
		   Ext.getCmp('RFIDId').show();
		   Ext.getCmp('RFIDButtId').show();
	  	}
	}
	
   //*********************** Function to Modify Data ***********************************
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
    buttonValue = "modify";
     myWin.show();
        titel = "<%=modifyTripSheetInformation%>"
        myWin.setTitle(titel);
        var selected = grid.getSelectionModel().getSelected();
        var type=selected.get('TypeIndex');
        Ext.getCmp('typecomboId').setDisabled(true);
        Ext.getCmp('RFIDId').disable;
        Ext.getCmp('RFIDButtId').setDisabled(true);
        Ext.getCmp('vehiclecomboId').setDisabled(true);
        Ext.getCmp('quantityId').setDisabled(true);
		 Ext.getCmp('RFIDId').setDisabled(true);        
        Ext.getCmp('captureWeightId').disable();
        if(type=="RFID"){
       // Ext.getCmp('detailsFirstMaster').setHeight(25);
         document.getElementById('detailsFirstMaster').style.height = "25px";
                     el = Ext.get("ext-comp-1031");
				     el.setWidth(87);
				     el = Ext.get("ext-comp-1032");
				     el.setWidth(54);
        Ext.getCmp('RFIDId').setValue(selected.get('assetNoIndex'));
				   Ext.getCmp('vehicleRFIDPanelId').show();
				   Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
				   Ext.getCmp('mandatoryVehicleId').hide();
				   Ext.getCmp('VehicleNoID').hide();
				   Ext.getCmp('vehiclecomboId').hide();
						  
				   Ext.getCmp('mandatoryRfid').show();
				   Ext.getCmp('RFIDIDs').show();
				   Ext.getCmp('RFIDId').show();
				   Ext.getCmp('RFIDButtId').show();
        }
        if(type=="APPLICATION"){
        //Ext.getCmp('detailsFirstMaster').setHeight(45);
        document.getElementById('detailsFirstMaster').style.height = "45px";
       			   el = Ext.get("ext-comp-1031");
				   el.setWidth(87);
				   el = Ext.get("ext-comp-1032");
				   el.setWidth(45);
        Ext.getCmp('vehiclecomboId').setValue(selected.get('assetNoIndex'));
                   Ext.getCmp('vehicleRFIDPanelId').show(); 
     			   Ext.getCmp('vehicleRFIDPanelId').setHeight(50);
				   Ext.getCmp('mandatoryRfid').hide();
				   Ext.getCmp('RFIDIDs').hide();
				   Ext.getCmp('RFIDId').hide();
				   Ext.getCmp('RFIDButtId').hide();
				    
				   Ext.getCmp('mandatoryVehicleId').show();
				   Ext.getCmp('VehicleNoID').show();
				   Ext.getCmp('vehiclecomboId').show();
        }
        Ext.getCmp('quantityId').setValue(selected.get('tareWeightIndex'));
		Ext.getCmp('typecomboId').setValue(selected.get('TypeIndex'));
		Ext.getCmp('enrollNumberId').setValue(selected.get('tareWeightIndex'));
		//Ext.getCmp('startDateTime').setValue(selected.get('WeightDateTimeIndex'));
    }

        Ext.onReady(function () {
	    Ext.QuickTips.init();
	    Ext.form.Field.prototype.msgTarget = 'side';
	    outerPanel = new Ext.Panel({
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        height:500,
        width:screen.width-40,
        items: [customerPanel,grid]
    });
    
  });
  </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
<%}%>