<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	Properties properties = ApplicationListener.prop;
	//String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	Properties prop = ApplicationListener.prop;
	String WEIGHTwebServicePath=prop.getProperty("WebServiceUrlPathForWeight");
	if(request.getParameter("list")!=null){
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
	Date date=new Date();
	SimpleDateFormat simpleDateFormatddMMYY1 = new SimpleDateFormat("dd/MM/yyyy");
	String validF=simpleDateFormatddMMYY1.format(date);
	validF=validF+"08:00:00";
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
	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("UniqueId_No");
tobeConverted.add("Consumer_Application_No");
tobeConverted.add("MDP_No");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Validity_Period");
tobeConverted.add("Transporter_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Driver_Name");
tobeConverted.add("Transporter");
tobeConverted.add("ML_No");
tobeConverted.add("Customer_Address");
tobeConverted.add("District");
tobeConverted.add("Quantity");
tobeConverted.add("Via_Route");
tobeConverted.add("To_Place");
tobeConverted.add("Sand_Port_No");
tobeConverted.add("Sand_Port_Unique_No");
tobeConverted.add("Valid_From");
tobeConverted.add("Valid_To");
tobeConverted.add("Mineral_Type");
tobeConverted.add("Loading_Type");
tobeConverted.add("Survey_No");
tobeConverted.add("Village");
tobeConverted.add("Taluka");
tobeConverted.add("Amount_CubicMeter");
tobeConverted.add("Processing_Fees");
tobeConverted.add("Total_Fee");
tobeConverted.add("Printed");
tobeConverted.add("MDP_Date");
tobeConverted.add("DD_No");
tobeConverted.add("Bank_Name");
tobeConverted.add("DD_Date");
tobeConverted.add("Group_Id");
tobeConverted.add("Group_Name");
tobeConverted.add("Index_No");
tobeConverted.add("Sand_Loading_From_Time");
tobeConverted.add("Sand_Loading_To_Time");
tobeConverted.add("Select_Consumer_Application_No");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Cancel");
tobeConverted.add("Save");
tobeConverted.add("select_vehicle_No");
tobeConverted.add("Select_Sand_Port");
tobeConverted.add("Select_To_Place");
tobeConverted.add("Select_Loading_Type");
tobeConverted.add("Modify");
tobeConverted.add("PDF");
tobeConverted.add("Excel");
tobeConverted.add("Consumer_MDP_Generator");
tobeConverted.add("From_Sand_Port");
tobeConverted.add("Contact_No");
tobeConverted.add("Something_Wrong_In_weight");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0);
String UniqueId_No=convertedWords.get(1);
String Consumer_Application_No=convertedWords.get(2);
String MDP_No=convertedWords.get(3);
String Vehicle_No=convertedWords.get(4);
String Validity_Period=convertedWords.get(5);
String Transporter_Name=convertedWords.get(6);
String Customer_Name=convertedWords.get(7);
String Driver_Name=convertedWords.get(8);
String Transporter=convertedWords.get(9);
String ML_No=convertedWords.get(10);
String Customer_Address=convertedWords.get(11);
String District=convertedWords.get(12);
String Quantity=convertedWords.get(13);
String Via_Route=convertedWords.get(14);
String To_Place=convertedWords.get(15);
String Sand_Port_No=convertedWords.get(16);
String Sand_Port_Unique_No=convertedWords.get(17);
String Valid_From=convertedWords.get(18);
String Valid_To=convertedWords.get(19);
String Mineral_Type=convertedWords.get(20);
String Loading_Type=convertedWords.get(21);
String Survey_No=convertedWords.get(22);
String Village=convertedWords.get(23);
String Taluka=convertedWords.get(24);
String Amount_CubicMeter=convertedWords.get(25);
String Processing_Fees=convertedWords.get(26);
String Total_Fee=convertedWords.get(27);
String Printed=convertedWords.get(28);
String MDP_Date=convertedWords.get(29);
String DD_No=convertedWords.get(30);
String Bank_Name=convertedWords.get(31);
String DD_Date=convertedWords.get(32);
String Group_Id=convertedWords.get(33);
String Group_Name=convertedWords.get(34);
String Index_No=convertedWords.get(35);
String Sand_Loading_From_Time=convertedWords.get(36);
String Sand_Loading_To_Time=convertedWords.get(37);
String Select_Consumer_Application_No=convertedWords.get(38);
String No_Records_Found=convertedWords.get(39);
String Clear_Filter_Data=convertedWords.get(40);
String Add=convertedWords.get(41);
String No_Rows_Selected=convertedWords.get(42);
String Select_Single_Row=convertedWords.get(43);
String Cancel=convertedWords.get(44);
String Save=convertedWords.get(45);
String select_vehicle_No=convertedWords.get(46);
String Select_Sand_Port=convertedWords.get(47);
String Select_To_Place=convertedWords.get(48);
String Select_Loading_Type=convertedWords.get(49);
String Modify=convertedWords.get(50);
String PDF=convertedWords.get(51);
String Excel=convertedWords.get(52);
String Consumer_MDP_Generator=convertedWords.get(53);
String From_Sand_Port=convertedWords.get(54);
String Distance="Distance";
String Contact_No = convertedWords.get(55);
String SomethingWronginweight=convertedWords.get(56);


%>

<jsp:include page="../Common/header.jsp" />
 		<title>Vehicle Pause Time Setting</title>	
   
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.my-label-style2-1 {
                font-weight: bold;
                font-size: 15px;
                text-align: center;
            }
  </style>

    <%if(loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<%}%>
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
				height: 38px !important;				
			}
			.x-layer ul {
				min-height: 27px !important;
			}		
			.x-menu-list {
				height:auto !important;
			}

		</style>
	 <%}%>
   <script>
   var outerPanel;
var ctsb;
var jspname = "Vehicle Pause Time";
var exportDataType = "int,int,string,string,string,string,string,string,string";
var selected;
var custName="";
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var dtcur = datecur;
var dtnext=datenext;
var custname="";
var IdModify; 



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
                custId = Ext.getCmp('custcomboId').getValue();
                custname= Ext.getCmp('custcomboId').getRawValue();
               
                vehicleNoStore.load({
                params: {
                CustId: custId
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
    emptyText: 'Select Client',
    blankText: 'Select Client',
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
                custname= Ext.getCmp('custcomboId').getRawValue();
				
		       vehicleNoStore.load({
                params: {
                CustId: custId
                }
                });
            }
        }
    }
});

var vehicleNoStore= new Ext.data.JsonStore({
	   url:'<%=request.getContextPath()%>/VehiclePauseTimeAction.do?param=getVehicleNo',
	   id:'vehicleStoreId',
       root: 'vehiclestoreList',
       autoLoad: false,
       remoteSort:true,
	   fields: ['PermitNoNew']
     });
			     
   var vehicleNoCombo=new Ext.form.ComboBox({
	  frame:true,
	  store: vehicleNoStore,
	  id:'vehicleComboId',
	  width: 175,
	  forceSelection:true,
	  emptyText:'Select Vehicle No',
	  anyMatch:true,
      onTypeAhead:true,
	  enableKeyEvents:true,
	  mode: 'local',
	  triggerAction: 'all',
	  displayField: 'PermitNoNew',
	  valueField: 'PermitNoNew',
	  cls: 'selectstylePerfect',
	  listeners: {
               select: {
               	 fn:function(){ 
			}
		}
	}
 });
 
 var reasonstore = new Ext.data.SimpleStore({
    id: 'loTypeId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Breakdown', 'Breakdown'],
        ['Welding', 'Welding'],
        ['Battery Servicing', 'Battery Servicing'],
        ['Starter Servicing', 'Starter Servicing'],
        ['Wiring Work', 'Wiring Work'],
        ['GPS Service', 'GPS Service'],
        ['Others', 'Others']
    ]
});	
		
				
var pauseReasoncombo=new Ext.form.ComboBox({
				  frame:true,
				  store: reasonstore,
				  id:'pauseReasoncomboid',
				  width: 175,
				  forceSelection:true,
				  emptyText:'Select Reason',
				  anyMatch:true,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  triggerAction: 'all',
				  displayField: 'Name',
				  valueField: 'Name',
				  cls: 'selectstylePerfect',
				  listeners: {
		                select: {
		                 	 fn:function(){
		                 	 
	                 		     }
		                	} // END OF SELECT
		               } // END OF LISTENERS 
	   
	       });

	var startdate = new Ext.form.DateField({
            fieldLabel: '',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '',
            allowBlank: false,
            blankText: '',
            submitFormat: getDateTimeFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'startdate',
            value: dtcur
          //  maxValue: dtprev,
            //vtype: 'daterange',
          //  endDateField: 'enddate'

        });




        var enddate = new Ext.form.DateField({
            fieldLabel: '',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '',
            allowBlank: false,
            blankText: '',
            submitFormat: getDateFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'enddate',
            value: dtnext
           // maxValue: dtcur,
           // vtype: 'daterange',
          //  startDateField: 'startdate'
        });

var customerComboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'customerComboPanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 13
    },
    items: [{
            xtype: 'label',
            text: 'Client Name' + ' :',
            cls: 'labelstyle',
            id:'clientlabelid'
        },Client,{width:25},
        { 
         	xtype: 'label',
            text: 'Start Date' + ' :',
            cls: 'labelstyle'},
            startdate,{width:25},
        { 
            xtype: 'label',
            text: 'End Date' + ' :',
            cls: 'labelstyle'},
            enddate,{width:40},
        {
        	xtype:'button',
			text: 'View',
			width:70,
			listeners: {
			click: {fn:function(){
				
				if(Ext.getCmp('custcomboId').getValue()=="")
                     {
                           Ext.example.msg("Select Client");
                           return;
                     }
                     if(Ext.getCmp('startdate').getValue()=="")
                     {
                           Ext.example.msg("Select Start Date");
                           return;
                     }
                     if(Ext.getCmp('enddate').getValue()=="")
                     {
                           Ext.example.msg("Select End Date");
                           return;
                     }
				 if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                           Ext.example.msg("End Date Should Be Greater than Start Date");
                           return;
                     }
                     
                    var Startdates=Ext.getCmp('startdate').getValue();
           		 	var Enddates=Ext.getCmp('enddate').getValue();
          	        var Startdate = new Date(Enddates).add(Date.DAY, -30);
           		 	  if(Startdates <  Startdate)
           		 					{
           		 					Ext.example.msg("Difference between two dates should not be  more than 30 days.");
           		 					return;
           		 					}
						 store.load({
						 params:{
								CustId: custId,
		                      	custName:custname,
		                      	endDate:Ext.getCmp('enddate').getValue(),
                                startDate:Ext.getCmp('startdate').getValue(),
		                      	jspname:jspname
		                      	}
		                  });
				}
			}
		}
	}
    ]
});  
   
   var innerPanelForMDPGenerator = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 190,
    width: 450,
    frame: true,
    id: 'innerPanelForPauseTimeId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
       items: [        
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryId1'
        }, {
            xtype: 'label',
            text: '<%=Vehicle_No%>' + ' :',
            cls: 'labelstyle',
            id: 'permitnoLabelId'
        },vehicleNoCombo, {},
		{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryId2'
        }, {
            xtype: 'label',
            text: 'Pause Start Date/Time' + ' :',
            cls: 'labelstyle',
            id: 'validFromlabelid'
        },{
			  xtype: 'datefield',
			  cls: 'selectstylePerfect',							 
              format: getDateTimeFormat(),
			  allowBlank: false,
			  readOnly: false,
			  emptyText: '',
			  value:dtcur,
			  minValue:dtcur,
			 //maxValue:dtnext,
			  id: 'pauseStartTimeId'
			 
		  }, {},
		  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryId3'
        }, {
            xtype: 'label',
            text: 'Pause End Date/Time' + ' :',
            cls: 'labelstyle',
            id: 'validTolabelid'
        },{
			  xtype: 'datefield',
			  cls: 'selectstylePerfect',							 
              format: getDateTimeFormat(),
			  allowBlank: false,
			  readOnly: false,
			  emptyText: '',
			 //value:dtcur,
			 //minValue:dtcur,
			 //maxValue:dtnext,
			  id: 'pauseEndTimeId'
			 
		  }, {}, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryId4'
        },{
            xtype: 'label',
            text: 'Reason' + ' :',
            cls: 'labelstyle',
            id: 'distancelableId'
        },pauseReasoncombo,{ },
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryId5'
        },{
            xtype: 'label',
            text: 'Remarks' + ' :',
            cls: 'labelstyle',
            id: 'remarksID'
        }, {
            xtype: 'textarea',
            width: 410,
            height: 60,
            cls: 'selectstylePerfect',
            emptyText: '',
            autoCreate: {//restricts user to 50 chars max, 
                   tag: "input",
                   maxlength: 50,
                   type: "text",
                   size: "50",
                   autocomplete: "off"
               },
            id: 'remarksTextId'
        },{}
		]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
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
                   if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("Select Client Name");
                        return;
                    }
                   
                   if (Ext.getCmp('vehicleComboId').getValue() == "") {
                        Ext.example.msg("<%=select_vehicle_No%>");
                        return;
                    }
                    
                    if (Ext.getCmp('pauseStartTimeId').getValue() == "") {
                        Ext.example.msg("Select Pause Start Date/Time");
                        return;
                    }
                    
                    if (Ext.getCmp('pauseEndTimeId').getValue() == "") {
                        Ext.example.msg("Select Pause End Date/Time");
                        return;
                    }
                    
                     if (dateCompare(Ext.getCmp('pauseStartTimeId').getValue(),Ext.getCmp('pauseEndTimeId').getValue()) == -1) {
                             Ext.example.msg("End Time Should Be Greater than Start Time");
                             Ext.getCmp('pauseEndTimeId').focus();
                             return;
                     }
                    if (Ext.getCmp('pauseReasoncomboid').getValue() == "") {
                        Ext.example.msg("Select Pause Reason");
                        return;
                    }
                    
                   
                    
                   if (buttonValue == "<%=Modify%>") {
                        var selected = grid.getSelectionModel().getSelected();
                        IdModify = selected.get('IdDataIndex');
                    } 
                   
                    pauseTimeOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/VehiclePauseTimeAction.do?param=addModifyPauseTimeDetails',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            custId: Ext.getCmp('custcomboId').getValue(),
                            vehicleNoAdd : Ext.getCmp('vehicleComboId').getValue(),
                            pauseStartTime : Ext.getCmp('pauseStartTimeId').getValue(),
                            pauseEndTime : Ext.getCmp('pauseEndTimeId').getValue(),
                            pauseReason : Ext.getCmp('pauseReasoncomboid').getValue(),
                            remarks : Ext.getCmp('remarksTextId').getValue(),
                            IdModify : IdModify
                        }, 
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('vehicleComboId').reset();
							Ext.getCmp('pauseStartTimeId').reset();
							Ext.getCmp('pauseEndTimeId').reset();
							Ext.getCmp('pauseReasoncomboid').reset();
							Ext.getCmp('remarksTextId').reset();
                            myWin.hide();
                            pauseTimeOuterPanelWindow.getEl().unmask();
                             store.load({
                                params: {
                                   	CustId: Ext.getCmp('custcomboId').getValue(),
                        			custName:custname,
                        			endDate:Ext.getCmp('enddate').getValue(),
                                	startDate:Ext.getCmp('startdate').getValue(),
                        			jspname:jspname
                                 }
                            });
                         
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
					Ext.getCmp('vehicleComboId').reset();
					Ext.getCmp('pauseStartTimeId').reset();
					Ext.getCmp('pauseEndTimeId').reset();
					Ext.getCmp('pauseReasoncomboid').reset();
					Ext.getCmp('remarksTextId').reset();
				    //Ext.getCmp('weighScaleMeasureId').setValue(true);
                    myWin.hide();
                }
            }
        }
    }]
});
   
  var pauseTimeOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 280,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForMDPGenerator, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 300,
    width: 460,
    id: 'myWin',
    items: [pauseTimeOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("select Client Name");
        return;
    }
    titelForInnerPanel = 'Add Information';
    myWin.setPosition(455, 172);
    buttonValue = '<%=Add%>';
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('vehicleComboId').enable();
	Ext.getCmp('pauseReasoncomboid').enable();
	Ext.getCmp('remarksTextId').enable();
    
} 

function modifyData() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("Select Client Name");
           return;
       }
       if (grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
       if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select single row");
           return;
       }
        buttonValue="Modify";
        titelForInnerPanel = 'Modify Information';
       myWin.setPosition(455, 172);
       myWin.setTitle(titelForInnerPanel);
       myWin.show();
       Ext.getCmp('vehicleComboId').disable();
	   Ext.getCmp('pauseReasoncomboid').disable();
	   Ext.getCmp('remarksTextId').disable();
	   
	   var selected = grid.getSelectionModel().getSelected();
	   Ext.getCmp('vehicleComboId').setValue(selected.get('VehicleNoDataIndex'));
       Ext.getCmp('pauseStartTimeId').setValue(selected.get('pauseStartTimeDataIndex'));
       Ext.getCmp('pauseEndTimeId').setValue(selected.get('pauseEndTimeDataIndex'));
       Ext.getCmp('pauseReasoncomboid').setValue(selected.get('reasonDataIndex'));
       Ext.getCmp('remarksTextId').setValue(selected.get('remarksDataIndex'));
   }
   
 var reader = new Ext.data.JsonReader({
    idProperty: 'vehiclePauseTimereadreId',
    root: 'vehiclePauseTimeroot',
    totalProperty: 'total',
    fields: [
    		{name:'SLNODataIndex'},
    		{name:'IdDataIndex'},
			{name:'VehicleNoDataIndex'},
			{name:'pauseStartTimeDataIndex'},
			{name:'pauseEndTimeDataIndex'},
			{name:'reasonDataIndex'},
			{name:'insertedByDataIndex'},
			{name:'insertedTimeDataIndex'},
			{name:'remarksDataIndex'}
	        ] // END OF Fields
}); // End of Reader

 var store  = new Ext.data.GroupingStore({
     url:'<%=request.getContextPath()%>/VehiclePauseTimeAction.do?param=getVehiclePauseTimeDetails',
     bufferSize: 367,
     reader: reader,
     autoLoad: false,
     remoteSort:true
   });

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters:[
        {dataIndex:'SLNODataIndex', type:'numeric'},
        {dataIndex:'IdDataIndex', type:'numeric'},
		{dataIndex:'VehicleNoDataIndex', type:'string'},
		{dataIndex:'pauseStartTimeDataIndex', type:'date'},
		{dataIndex:'pauseEndTimeDataIndex', type:'date'},
		{dataIndex:'reasonDataIndex', type:'string'},
		{dataIndex:'insertedByDataIndex', type:'string'},
		{dataIndex:'insertedTimeDataIndex', type:'date'},
		{dataIndex:'remarksDataIndex', type:'string'}
		]
});

var createColModel =function(finish, start) {
    var columns = 
     [new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'SLNODataIndex',
            hidden:true,
        	//sortable: true,
        	//hideable: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>ID</span>",
            dataIndex: 'IdDataIndex',
            hidden:true,
            width: 150,
            filter: {
                type: 'int'
            }
        },{
            header: "<span style=font-weight:bold;><%=Vehicle_No%></span>",
            dataIndex: 'VehicleNoDataIndex',
            width: 150,
            hidden: false,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Pause Start Date/Time</span>",
            dataIndex: 'pauseStartTimeDataIndex',
            width: 150,
            //renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Pause End Date/Time </span>",
            dataIndex: 'pauseEndTimeDataIndex',
            width: 150,
           // renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Reason</span>",
            dataIndex: 'reasonDataIndex',
            width: 150,
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Inserted By</span>",
            dataIndex: 'insertedByDataIndex',
            width: 150,
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Inserted Date/Time </span>",
            dataIndex: 'insertedTimeDataIndex',
            width: 150,
            //renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Remarks</span>",
            dataIndex: 'remarksDataIndex',
            width: 150,
            hidden: false,
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
grid = getSandPermitGrid('Vehicle Pause Time Setting', '<%=No_Records_Found%>', store, screen.width - 32, 420, 45, filters, '<%=Clear_Filter_Data%>', false, '',20, false, '', false, '', true, '<%=Excel%>', jspname, exportDataType, false, '<%=PDF%>', true, '<%=Add%>', true, '<%=Modify%>', false, 'Print MDP');
//******************************************************************************************************************************************************

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Vehicle Pause Time Setting',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel,grid]
    });
    sb = Ext.getCmp('form-statusbar');
    
    //var cm = grid.getColumnModel();  
   // for (var j = 1; j < cm.getColumnCount(); j++) {
   //    cm.setColumnWidth(j,150);
   // }
});

</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->