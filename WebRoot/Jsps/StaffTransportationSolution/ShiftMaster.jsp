<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
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
tobeConverted.add("Route_Master");
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Route_Id");
tobeConverted.add("Route_Name");
tobeConverted.add("Route_Type");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("Route_Master_Information");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Modify_Details");
tobeConverted.add("Route_Master_Details");
tobeConverted.add("Enter_Route_ID");
tobeConverted.add("Enter_Route_Name");
tobeConverted.add("Enter_Route_Type");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Branch_Name");
tobeConverted.add("Select_Branch");
//tobeConverted.add("This_Route_is_Already_Exists_Please_Select_Different_One");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String ShiftMaster= "Shift Master";//convertedWords.get(0);
String Add=convertedWords.get(1);
String Modify=convertedWords.get(2);
String CustomerName=convertedWords.get(3);
String SelectCustomerName=convertedWords.get(4);
String ShiftMasterDetails="Shift Master Details";//convertedWords.get(5);
String NoRecordsFound=convertedWords.get(6);
String ClearFilterData=convertedWords.get(7);
String SLNO=convertedWords.get(8);
String ID=convertedWords.get(9);
String ShiftID="Shift ID";//convertedWords.get(10);
String ShiftName="Shift Name";//convertedWords.get(11);
String RouteType=convertedWords.get(12);
String Excel=convertedWords.get(13);
String Delete=convertedWords.get(14);
String AddShiftMaster="Add Shift Master";//convertedWords.get(15);
String NoRowsSelected=convertedWords.get(16);
String SelectSingleRow=convertedWords.get(17);
String ModifyDetails=convertedWords.get(18);
String AssociateShift="Shift Master Details";//convertedWords.get(19);
String SelectRouteID=convertedWords.get(20);
String EnterShiftName="Enter Shift Name";//convertedWords.get(21);
String SelectRouteType=convertedWords.get(22);
String Save=convertedWords.get(23);
String Cancel=convertedWords.get(24);
String StartTime = "Start Time";
String EndTime  = "End Time";
String Status = "Status";
String EnterStartTime = "Enter Start Time";
String EnterEndTime = "Enter End Time";
String  InvalidStartTime = "Invalid Start Time";
String  InvalidEndTime = "Invalid End Time";
String branch=convertedWords.get(25);
String slectBranch=convertedWords.get(26);

//String RouteisAlreadyExistsPleaseSelectDifferentOne=convertedWords.get(25);

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Shift Master</title>		
	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.x-panel-header
		{
				height: 7% !important;
		}
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			height : 42px !important;
		}
  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
   
var outerPanel;
var ctsb;
var jspName = "ShiftMasterDetails";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var selectedVehicles = "-";
var selectedShiftId = null;
var selectedName = null;
var selectedType = null;
var datecur = datecur;
var dtprev = dtprev;
var duration = "00:00";
var ShiftId;
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
                store.load({
                    params: {
                        CustId: custId
                    }
                });
              BranchStore.load({params:{clientId:custId}});
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
            fn: function() {
                custId = Ext.getCmp('custcomboId').getValue();
                 BranchStore.load({params:{clientId:custId}});
                store.load({
                    params: {
                        CustId: custId
                    }
                });
            }
        }
    }
});

  var BranchStore = new Ext.data.JsonStore({
			   url:'<%=request.getContextPath()%>/ShiftMasterActions.do?param=getBranch',
			   id:'BranchStoreId',
		       root: 'BranchStoreRootUser',
		       autoLoad: false,
		       remoteSort: true,
			   fields: ['BranchId','BranchName']
			  });
			  
   var BranchBombo = new Ext.form.ComboBox({
			    store: BranchStore,
			    id: 'branchComboId',
			    mode: 'local',
			    forceSelection: true,
			    selectOnFocus: true,  
			    anyMatch: true,
			    emptyText: 'Select Branch',
			    blankText: 'Select Branch',
			    typeAhead: false,
			    triggerAction: 'all',  
			    valueField: 'BranchId',  
			    displayField: 'BranchName',
			    cls: 'selectstylePerfect' ,
			    listeners: {
			        select: {
			            fn: function() {
			              validationStore.load({params:{clientId:custId,BranchId:Ext.getCmp('branchComboId').getValue()}});
			            }
			        }
    		}
		});

 var validationStore = new Ext.data.JsonStore({
			   url:'<%=request.getContextPath()%>/ShiftMasterActions.do?param=getShiftDetailsForValidation',
			   id:'validationStoreId',
		       root: 'getShiftDetailsForValidationR',
		       autoLoad: false,
		       remoteSort: true,
			   fields: ['TotalHrs','startTime','endTime']
			  });
			  
 function calculateTimeDiff(startTime, endTime) {//this function calculates time difference in hours
         var time1 = startTime.split(':'), time2 = endTime.split(':');
         var hours1 = parseInt(time1[0]), 
             hours2 = parseInt(time2[0]),
             mins1 = parseInt(time1[1]),
             mins2 = parseInt(time2[1]);
         var hours = hours2 - hours1, mins = 0;
         if(hours < 0) {
         	   hours = 24 + hours;
         	}
	     if(mins2 >= mins1) {
	           mins = mins2 - mins1;
	      }else {
               mins = (mins2 + 60) - mins1;
               hours--;
	         }

if(mins>59){
		       mins = mins / 60;
		       hours++;
		       mins = mins.toFixed(2); 
	}	     
		       hours =hours+"."+mins;
        return hours;
     }
			  				  
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
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },
        Client
    ]
});

var statuscombostore = new Ext.data.SimpleStore({
    id: 'statuscombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Active', 'Active'],
        ['Inactive', 'Inactive']
    ]
});

var statuscombo = new Ext.form.ComboBox({
    store: statuscombostore,
    id: 'statuscomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    emptyText: 'Select Status',
    blankText: 'Select Status',
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'Active',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});

var innerPanelForShiftMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 200,
    width: 400,
    frame: false,
    id: 'innerPanelForShiftMasterDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=AssociateShift%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'AssociateShiftId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [ {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyIdB'
        },{
            xtype: 'label',
            text: 'Select Branch' + ' :',
            cls: 'labelstyle',
            id: 'branchLabelId'
        },BranchBombo,{},
	   	{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'nameEmptyId1'
        },{
            xtype: 'label',
            text: '<%=ShiftName%>' + ' :',
            cls: 'labelstyle',
            id: 'nameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'NameId',
            mode: 'local',
            forceSelection: true,
            emptyText: '<%=EnterShiftName%>',
            blankText: '<%=EnterShiftName%>',
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        }, {},
        
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'EmptyId2'
        },{
            xtype: 'label',
            text: '<%=StartTime%>' + ' :',
            cls: 'labelstyle',
            id: 'startTimeLabelId'
        }, {
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
// alert(Ext.getCmp('branchComboId').getRawValue());               					
 var departure = Ext.getCmp('DepartureFieldId').getValue();
 if(Ext.getCmp('branchComboId').getRawValue() == '8 Hrs'){
 duration = "08:00";
 }else if(Ext.getCmp('branchComboId').getRawValue() == '12 Hrs'){
 duration = "12:00";
 }
                					  if(departure!=""){
                					    var value1 = parseFloat(departure.replace(":",".")).toFixed(2);
                					  	var value2= parseFloat(duration.replace(":",".")).toFixed(2);
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
					 							arrivalTime2 = arrivalTime.split(".");
					 							arrivalTime = arrivalTime2[0]+".0"+arrivalTime2[1];
											}
                					   	Ext.getCmp('ArrivalFieldId').setValue(arrivalTime.replace(".",":"));
                					 }
            				}	
        			}
           
        }, {},
        
          {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'EmptyId3'
        },{
            xtype: 'label',
            text: '<%=EndTime%>' + ' :',
            cls: 'labelstyle',
            id: 'EndTimeLabelId'
        }, {
            xtype: 'textfield',
					cls: 'selectstylePerfect',
            		allowBlank: false,
            		labelSeparator: ':',
            		allowBlank: false,
            		regex:/^\s*([01]?\d|2[0-3]):+([0-5]\d)\s*$/,
            		disabled : false,
            		id: 'ArrivalFieldId'
        }, {},
        
        
        
         {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'statusEmptyId1'
        }, {
            xtype: 'label',
            text: 'Status' + ' :',
            cls: 'labelstyle',
            id: 'statusLabelId'
        },  statuscombo, {}]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 400,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectCustomerName%>");
                        return;
                    }
                    
                    if (Ext.getCmp('branchComboId').getValue() == "") {
                    Ext.example.msg("<%=slectBranch%>");
                        return;
                    } 
                  
                    if (Ext.getCmp('NameId').getValue() == "") {
                    Ext.example.msg("<%=EnterShiftName%>");
                        return;
                    }

                     if (Ext.getCmp('DepartureFieldId').getValue() == "") {
                    Ext.example.msg("<%=EnterStartTime%>");
                        return;
                    }
                     if (Ext.getCmp('ArrivalFieldId').getValue() == "") {
                    Ext.example.msg("<%=EnterEndTime%>");
                        return;
                    }
                   
                   
                   var regdep = /^\s*([01]?\d|2[0-3]):+([0-5]\d)\s*$/;
    				var departure = Ext.getCmp('DepartureFieldId').getValue();
    				if(!regdep.test(departure)){
    					Ext.example.msg("<%=InvalidStartTime%>");
    					Ext.getCmp('DepartureFieldId').focus();
         				return;
    				}
    				
    				var arrival = Ext.getCmp('ArrivalFieldId').getValue();
    				if(!regdep.test(arrival)){
    					Ext.example.msg("<%=InvalidEndTime%>");
    					Ext.getCmp('ArrivalFieldId').focus();
         				return;
    				}
                   
                   
                     if (Ext.getCmp('statuscomboId').getValue() == "") {
                    	Ext.example.msg("Select Status");
                    	return;
                    } 
                    
                   var record = validationStore.getAt(0); 
                   var totalHrs=record.get('TotalHrs');
                   var endDate=record.get('endTime');
                    
                   var Hrs=calculateTimeDiff(departure,arrival);
                   //alert("hrs from cal == "+Hrs);
                   var hrss = Hrs.split('.');
                     var hr = parseInt(hrss[0])*60+ parseInt(hrss[1]);
                   totalHrs = parseFloat(totalHrs).toFixed(2);
                   var timeLeft3 =  totalHrs.split('.');
                   		var totalMins = parseInt(timeLeft3[0])*60 + parseInt(timeLeft3[1]);
                   		var difmin=1440-totalMins;
                  
                  // if (buttonValue != 'Modify') {
              
                  //alert("480 == "+hr);
                  //alert("diff bckend == "+difmin);
                   		if( difmin <= hr  ){
                   
                   		//var timeLeft = parseFloat(24-totalHrs).toFixed(2);
                   		//alert(timeLeft);
                   		//var timeLeft2 =  timeLeft.split('.');
                   		var sm = difmin;// parseInt(timeLeft2[0])*60 + parseInt(timeLeft2[1]);
                   		//alert(sm);
                         var h = parseInt(sm/60)%24;
                					  	//alert(h);
                					  	var m = sm%60;
                					  //	alert(m);
                   		
                   		
    						Ext.example.msg("Shifts Alrady Added For This Branch");    					
         						return;
    					}
                  // }    
                    var rec;
                    if (innerPanelForShiftMasterDetails.getForm().isValid()) {
                        if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            ShiftId = selected.get('ShiftIdDataIndex');
                           
                        }else{
                        ShiftId = 0;
                        }
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/ShiftMasterActions.do?param=AddorModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId : Ext.getCmp('custcomboId').getValue(),
                                ShiftName: Ext.getCmp('NameId').getValue(),
                                StartTime: Ext.getCmp('DepartureFieldId').getValue(),
                                EndTime : Ext.getCmp('ArrivalFieldId').getValue(),
                                Status : Ext.getCmp('statuscomboId').getValue(),
                                ShiftId : ShiftId,
                                BranchId : Ext.getCmp('branchComboId').getValue()                              
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                
                                Ext.getCmp('NameId').reset();
                                Ext.getCmp('DepartureFieldId').reset();
                                Ext.getCmp('ArrivalFieldId').reset();
                                Ext.getCmp('statuscomboId').reset();
                              
                                myWin.hide();
                                ShiftMasteShiftrPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
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
                fn: function() {
                    myWin.hide();
                }
            }
        }
    }]
});

var ShiftMasteShiftrPanelWindow = new Ext.Panel({
    width: 410,
    height: 270,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForShiftMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 330,
    width: 430,
    id: 'myWin',
    items: [ShiftMasteShiftrPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddShiftMaster%>';
    myWin.setPosition(450, 170);
    myWin.show();
    //  myWin.setHeight(350);
    
     Ext.getCmp('NameId').reset();
     Ext.getCmp('DepartureFieldId').reset();
     Ext.getCmp('ArrivalFieldId').reset();
     Ext.getCmp('statuscomboId').reset();
     Ext.getCmp('branchComboId').setValue('');
    
    myWin.setTitle(titelForInnerPanel);
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
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
 
    var selected = grid.getSelectionModel().getSelected();
     
     Ext.getCmp('NameId').setValue(selected.get('ShiftNameIndex'));
     Ext.getCmp('DepartureFieldId').setValue(selected.get('StartTimeIndex'));
     Ext.getCmp('ArrivalFieldId').setValue(selected.get('EndTimeIndex'));
     Ext.getCmp('statuscomboId').setValue(selected.get('statusIndex'));   
     Ext.getCmp('branchComboId').setValue(selected.get('branchIDIndex'));
     validationStore.load({params:{clientId:custId,BranchId:selected.get('branchIDIndex')}});
}

function deleteData() {
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
      var selected = grid.getSelectionModel().getSelected();
      ShiftId = selected.get('ShiftIdDataIndex');
   Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/ShiftMasterActions.do?param=deleteShiftDetails',
                            method: 'POST',
                            params: {
                              
                                CustId : Ext.getCmp('custcomboId').getValue(),                             
                                ShiftId : ShiftId                              
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                outerPanel.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
                                    }
                                });
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                store.reload();
                            }
                        });
   
}

var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'ShiftMasterRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'ShiftIdDataIndex'
    }, {
        name: 'ShiftNameIndex'
    }, {
        name: 'StartTimeIndex'
    },{
        name: 'EndTimeIndex'
    },{
        name: 'statusIndex'
    },{
        name: 'branchIndex'
    },{
        name: 'branchIDIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ShiftMasterActions.do?param=getShiftMasterDetails',
        method: 'POST'
    }),
    storeId: 'ShiftMasterId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    },  {
        type: 'string',
        dataIndex: 'ShiftIdDataIndex'
    }, {
        type: 'string',
        dataIndex: 'ShiftNameIndex'
    }, {
        type: 'string',
        dataIndex: 'StartTimeIndex'
    }, {
        type: 'string',
        dataIndex: 'EndTimeIndex'
    },  {
        type: 'string',
        dataIndex: 'statusIndex'
    },  {
        type: 'string',
        dataIndex: 'branchIndex'
    }]
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
        }, {
            header: "<span style=font-weight:bold;><%=ShiftID%></span>",
            dataIndex: 'ShiftIdDataIndex',
            width: 50,
            hidden:true,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ShiftName%></span>",
            dataIndex: 'ShiftNameIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=StartTime%></span>",
            dataIndex: 'StartTimeIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=EndTime%></span>",
            dataIndex: 'EndTimeIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=Status%></span>",
            dataIndex: 'statusIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=branch%></span>",
            dataIndex: 'branchIndex',
            width: 100,
            filter: {
                type: 'string'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=branch%></span>",
            dataIndex: 'branchIDIndex',          
            hidden:true
        }
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};

grid = getGrid('<%=ShiftMasterDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 8, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');

Ext.onReady(function() {
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=ShiftMaster%>',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,        
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
});</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->