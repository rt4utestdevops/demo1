<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	String[] str=list.split(",");
	int systemid=Integer.parseInt(str[0].trim());
	int customerid=Integer.parseInt(str[1].trim());
	int userid=Integer.parseInt(str[2].trim());
	String language=str[3].trim();
	LoginInfoBean loginInfo=new LoginInfoBean();
	LoginInfoBean loginInfo1=new LoginInfoBean();
	loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo1!=null)
	{
	int mapType=loginInfo1.getMapType();
	loginInfo.setMapType(mapType);
	}
	loginInfo.setSystemId(systemid);
	loginInfo.setCustomerId(customerid);
	loginInfo.setUserId(userid);
	loginInfo.setLanguage(language);
	loginInfo.setZone(str[4].trim());
	loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
	loginInfo.setSystemName(str[6].trim());
	loginInfo.setCategory(str[7].trim());
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	loginInfo.setStyleSheetOverride(str[11].trim());
	loginInfo.setIsLtsp(Integer.parseInt(str[12].trim()));
	loginInfo.setNewMenuStyle(str[13].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();
String userAuthority=cf.getUserAuthority(systemId,userId);
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
    
	ArrayList<String> tobeConverted = new ArrayList<String>();
  tobeConverted.add("Sim_Details");
  tobeConverted.add("Sim_Details_Information");
  tobeConverted.add("Mobile_Number");
  tobeConverted.add("Enter_Mobile_Number");
  tobeConverted.add("Service_Provider");
  tobeConverted.add("Enter_Service_Provider");
  tobeConverted.add("Sim_Number");
  tobeConverted.add("Enter_Sim_Number");
  tobeConverted.add("Status");
  tobeConverted.add("Select_Status");
  tobeConverted.add("Save");
  tobeConverted.add("Cancel");
  tobeConverted.add("Add_Sim_Details");
  tobeConverted.add("Select_Single_Row");
  tobeConverted.add("No_Rows_Selected");
  tobeConverted.add("Modify");
  tobeConverted.add("Delete_Sim_Details");
  tobeConverted.add("Are_you_sure_you_want_to_delete");
  tobeConverted.add("SLNO");
  tobeConverted.add("Mobile_Data");
  tobeConverted.add("No_Records_Found");
  tobeConverted.add("Add");
  tobeConverted.add("Delete");
  
  tobeConverted.add("Validity_Start_Date");
  tobeConverted.add("Validity_End_Date");
  tobeConverted.add("Enter_Validity_Start_Date");
  tobeConverted.add("Enter_Validity_End_Date");
  tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
  tobeConverted.add("Remarks");
  tobeConverted.add("Valid_Status");
  tobeConverted.add("Get_Standard_Format");
  tobeConverted.add("Close");
  tobeConverted.add("Clear");
  tobeConverted.add("Import_Sim");
  
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 
String SimDetails = convertedWords.get(0);
String SimDetailsInformation = convertedWords.get(1);
String MobileNumber = convertedWords.get(2);
String EnterMobileNumber = convertedWords.get(3);
String ServiceProvider = convertedWords.get(4);
String EnterServiceProvider = convertedWords.get(5);
String SimNumber = convertedWords.get(6);
String EnterSimNumber = convertedWords.get(7);
String Status = convertedWords.get(8);
String SelectStatus=convertedWords.get(9);
String Save = convertedWords.get(10);
String Cancel = convertedWords.get(11);
String AddSimDetails = convertedWords.get(12);
String selectSingleRow = convertedWords.get(13); 
String noRowsSelected = convertedWords.get(14);
String Modify = convertedWords.get(15); 
String DeleteSimDetails = convertedWords.get(16);
String Areyousureyouwanttodelete = convertedWords.get(17); 
String SLNO = convertedWords.get(18);
String MobileData = convertedWords.get(19); 
String NoRecordsFound = convertedWords.get(20); 
String Add = convertedWords.get(21); 
String Delete = convertedWords.get(22); 
String ValidityStartDate=convertedWords.get(23);
String ValidityEndDate=convertedWords.get(24);
String EnterValidityStartDate=convertedWords.get(25);
String EnterValidityEndDate=convertedWords.get(26);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(27);
String Remarks=convertedWords.get(28);
String ValidStatus=convertedWords.get(29);
String GetStandardFormat = convertedWords.get(30);
String Close = convertedWords.get(31);
String Clear = convertedWords.get(32);
String ImportSim = convertedWords.get(33);
String validMobNo="Please enter valid mobile number";
%>

<!DOCTYPE HTML>
<html>

<head>
    <base href="<%=basePath%>">

    <title>
        <%=SimDetails%>
    </title>
<style>
.x-panel-tl {
    border-bottom: 0px solid !important;
}
.x-form-file-wrap .x-form-file {
	position: absolute;
	right: 0;
	-moz-opacity: 0;
	filter:alpha(opacity: 0);
	opacity: 0;
	z-index: 2;
    height: 22px;
    cursor: pointer;
}
.x-form-file-wrap .x-form-file-btn {
	position: absolute;
	right: 0;
	z-index: 1;
}
.x-form-file-wrap .x-form-file-text {
    position: absolute;
    left: 0;
    z-index: 3;
    color: #777;
}
<%
	String ua = request.getHeader("User-Agent");
	boolean isMSIE10 = (ua != null && ua.indexOf("MSIE 10") != -1);
	boolean isMSIE9 = (ua != null && ua.indexOf("MSIE 9") != -1);
	boolean isMSIE8 = (ua != null && ua.indexOf("MSIE 8") != -1);
	if(isMSIE10 || isMSIE9 || isMSIE8){
%>
#ext-gen127{
width:70px;
}
<%}else{%>
#ext-gen126{
width:70px;
}
<%}%>
.x-form-field-wrap{
 height: 35px;
}
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
.x-form-file-wrap .x-form-file {
height:35px;
}
#filePath{
height:30px;
}
<%}%>
</style>
</head>

<body onload="refresh();">
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
	
<script>
 var pageName='<%=SimDetails%>';
 Ext.Ajax.timeout = 360000;
/*******************resize window event function**********************/
Ext.EventManager.onWindowResize(function () {
    var width = '100%';
    var height = '100%';
    grid.setSize(width, height);
    outerPanel.setSize(width, height);
    outerPanel.doLayout();
});
var outerPanel;
var ctsb;
var jspName = "<%=SimDetails%>";
var exportDataType = "string";
var selected;
var grid;
var buttonValue;
var dtprev = dateprev;
var dtcur = datecur;

/**********************************************statusStore****************************************/
var statuscombostore = new Ext.data.SimpleStore({
    id: 'statuscombostoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['ACTIVE', 'ACTIVE'],
        ['INACTIVE', 'INACTIVE']
    ]
});
/*********************************statusCombo********************************************/
var Statuscombo = new Ext.form.ComboBox({
    store: statuscombostore,
    id: 'statuscomboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    value: 'ACTIVE',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});
/*********************inner panel for displaying form field in window***********************/
var innerPanelForSimDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 204,
    width: 390,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=SimDetailsInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'addpanelid',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 3,
            tableAttrs: {
		            style: {
		                width: '92%'
		            }
        			}
        },
        items: [ {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryMobNoId'
            }, {
                xtype: 'label',
                text: '<%=MobileNumber%>' + ':',
                cls: 'labelstyle',
                id: 'MobNoid'
            },{
                xtype: 'textfield',
                allowDecimals: false,
                allowBlank: false,
                cls: 'selectstylePerfect',
                minLength: 5,
                maxLength: 24,
                emptyText: '<%=EnterMobileNumber%>',
                blankText: '<%=EnterMobileNumber%>',
                id: 'MobileNoId',
                maskRe: /[0-9+]/i
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryserviceProviderId'
            }, {
                xtype: 'label',
                text: '<%=ServiceProvider%>' + ':',
                cls: 'labelstyle',
                id: 'serviceProviderid'
            },{
                xtype: 'textfield',
                emptyText: '<%=EnterServiceProvider%>',
                allowBlank: false,
                blankText: '<%=EnterServiceProvider%>',
                cls: 'selectstylePerfect',
                id: 'serviceProvId'
            },  {
                xtype: 'label',
                text: '',
                id: 'mandatorysimNumberId'
            },{
                xtype: 'label',
                text: '<%=SimNumber%>' + ':',
                cls: 'labelstyle',
                id: 'simNumberid'
            }, {
                xtype: 'textfield',
                 maxLength: 24,
                emptyText: '<%=EnterSimNumber%>',
                blankText: '<%=EnterSimNumber%>',
                cls: 'selectstylePerfect',
                id: 'simNumId'
            },
            {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'validityStartDateEmptyId'
            }, 
            {
                xtype: 'label',
                text: '<%=ValidityStartDate%>' + ':',
                cls: 'labelstyle',
                id: 'validityStartDateId1'
            },{
                xtype: 'datefield',
                allowDecimals: false,
                allowBlank: true,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterValidityStartDate%>',
                blankText: '<%=EnterValidityStartDate%>',
                id: 'validityStartDateId',
                value: dtcur,
                format: getDateTimeFormat()
            }, {
                xtype: 'label',
                text: '',
                cls: 'mandatoryfield',
                id: 'validityEndDateEmptyId'
            },  
            {
                xtype: 'label',
                text: '<%=ValidityEndDate%>' + ':',
                cls: 'labelstyle',
                id: 'validityEndDateId1'
            },{
                xtype: 'datefield',
                allowDecimals: false,
                allowBlank: true,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterValidityEndDate%>',
                blankText: '<%=EnterValidityEndDate%>',
                id: 'ValidityEndDateId',
                //value: dtcur,
                format: getDateTimeFormat()
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'statusid'
            },{
                xtype: 'label',
                text: '<%=Status%>' + ' :',
                cls: 'labelstyle',
                id: 'labelstatusId'
            }, 
            Statuscombo
        ]
    }]
});

/********************************button**************************************/
var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 387,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        iconCls:'savebutton',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    var format = /[a-zA-Z!@#$%^&*()_\-=\[\]{};':"\\|,.<>\/?]/;
                    if (Ext.getCmp('MobileNoId').getValue() == "") {
                    Ext.example.msg("<%=EnterMobileNumber%>");
                        return;
                    }
                   if (Ext.getCmp('MobileNoId').getValue().match(format)) {
                    Ext.example.msg("<%=validMobNo%>");
                        return;
                    }
                    if (Ext.getCmp('serviceProvId').getValue() == "") {
                    Ext.example.msg("<%=EnterServiceProvider%>");
                        return;
                    }

                    //if (Ext.getCmp('simNumId').getValue() == "") {
                     //  ctsb.setStatus({
                      //      text: getMessageForStatus("<%=EnterSimNumber%>"),
                       //     iconCls: '',
                      //      clear: true
                     //   });
                      //  return;
                   // }
                    if (Ext.getCmp('statuscomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectStatus%>");
                        return;
                    }
              
              
              if(Ext.getCmp('ValidityEndDateId').getValue()!="")
              {     
             if (dateCompare(Ext.getCmp('validityStartDateId').getValue(), Ext.getCmp('ValidityEndDateId').getValue()) == -1) {
             Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
              Ext.getCmp('enddate').focus();
              return;
            }
          }
                    if (innerPanelForSimDetails.getForm().isValid()) {
                        var selected;
                        var serviceProviderGrid;
                        var statusGrid;
                        var SimNumberGrid;
                        var service;
                        var sim;
                        if (buttonValue == 'modify') {
                            selected = grid.getSelectionModel().getSelected();
                            serviceProviderGrid = selected.get('serviceProvider');
                            SimNumberGrid = selected.get('simNumberDataIndex');
                            statusGrid = selected.get('Status');
                            service = Ext.getCmp('serviceProvId').getValue();
                            sim = Ext.getCmp('simNumId').getValue();
                        }
                        
                        outerPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SimDetailsAction.do?param=saveSimInformation',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                mobileNumber: Ext.getCmp('MobileNoId').getValue().trim(),
                                serviceProvider: Ext.getCmp('serviceProvId').getValue(),
                                simNumber: Ext.getCmp('simNumId').getValue(),
                                status: Ext.getCmp('statuscomboId').getValue(),
                                serviceProviderGrid: serviceProviderGrid,
                                simNumberGrid: SimNumberGrid,
                                StatusGrid: statusGrid,
                                validityStartDate:Ext.getCmp('validityStartDateId').getValue(),
                                validityEndDate:Ext.getCmp('ValidityEndDateId').getValue(),
                                pageName: pageName
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin.hide();
                                Ext.getCmp('MobileNoId').reset();
                                Ext.getCmp('serviceProvId').reset();
                                Ext.getCmp('simNumId').reset();
                                Ext.getCmp('statuscomboId').reset();
                                Ext.getCmp('validityStartDateId').reset();
                                Ext.getCmp('ValidityEndDateId').reset();
                                
                                store.load({
                                    params: {}
                                });
                                outerPanelWindow.getEl().unmask();
                            },
                             failure: function () {
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
                fn: function () {
                    myWin.hide();
                    Ext.getCmp('MobileNoId').reset();
                    Ext.getCmp('serviceProvId').reset();
                    Ext.getCmp('simNumId').reset();
                    Ext.getCmp('statuscomboId').reset();
                    Ext.getCmp('validityStartDateId').reset();
                    Ext.getCmp('ValidityEndDateId').reset();
                    

                }
            }
        }
    }]
});
/***********panel contains window content info***************************/
var outerPanelWindow = new Ext.Panel({
	//width:540,
    cls: 'outerpanelwindow',
    standardSubmit: true,
    frame: true,
    items: [innerPanelForSimDetails, innerWinButtonPanel]
});
/***********************window for form field****************************/
myWin = new Ext.Window({
    title: 'titel',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: '',
    height: 305,
    width: 415,
    id: 'myWin',
    items: [outerPanelWindow]
});

//sameer modify

function clearInputData() {
    importgrid.store.clearData();
    importgrid.view.refresh();
}

function importExcelData() {
    importButton = "import";
    importTitle = 'Sim Import Details';
    importWin.show();
    importWin.setTitle(importTitle);
}

var fp = new Ext.FormPanel({

    fileUpload: true,
    width: '100%',
    frame: true,
    autoHeight: true,
    standardSubmit: false,
    labelWidth: 70,
    defaults: {
        anchor: '95%',
        allowBlank: false,
        msgTarget: 'side'
    },
    items: [{
        xtype: 'fileuploadfield',
        id: 'filePath',
        width: 60,
        emptyText: 'Browse',
        fieldLabel: 'ChooseFile',
        name: 'filePath',
        buttonText: 'Browse',
        buttonCfg: {
	        iconCls: 'browsebutton'
        },
        listeners: {

            fileselected: {
                fn: function () {
                    var filePath = document.getElementById('filePath').value;
                    var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                    if (imgext == "xls" || imgext == "xlsx") {

                    } else {
                        Ext.MessageBox.show({
                            msg: 'Please select only .xls or .xlsx files',
                            buttons: Ext.MessageBox.OK
                        });
                        Ext.getCmp('filePath').setValue("");
                        return;
                    }
                }
            }

        }
    }],
    buttons: [{
        text: 'Upload',
        iconCls : 'uploadbutton',
        handler: function () {
            if (fp.getForm().isValid()) {
                var filePath = document.getElementById('filePath').value;

                var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                if (imgext == "xls" || imgext == "xlsx") {
					clearInputData();
                } else {
                    Ext.MessageBox.show({
                        msg: 'Please select only .xls or .xlsx files',
                        buttons: Ext.MessageBox.OK
                    });
                    Ext.getCmp('filePath').setValue("");
                    return;
                }
                fp.getForm().submit({
                    url: '<%=request.getContextPath()%>/SimDetailsAction.do?param=importSimDetailsExcel',
                    enctype: 'multipart/form-data',
                    waitMsg: 'Uploading your file...',
                    success: function (response, action) {
						
						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/SimDetailsAction.do?param=getImportSimDetails',
                        method: 'POST',
                        params: {
                            simImportResponse: action.response.responseText
                        },
                        success: function (response, options) {
                            simResponseImportData  = Ext.util.JSON.decode(response.responseText);
                            importstore.loadData(simResponseImportData);
                            
                        },
                        failure: function () {
                        Ext.example.msg("Error");
                        }
                    });
                        
                    },
                    failure: function () {
                    Ext.example.msg("Please Upload The Standard Format");
                    }
                });
            }
        }
    }, {
		text: '<%=GetStandardFormat%>',
		iconCls : 'downloadbutton',
	    handler : function(){
	    Ext.getCmp('filePath').setValue("Upload the Standard Format");
	    fp.getForm().submit({
	    	url:'<%=request.getContextPath()%>/SimDetailsAction.do?param=openStandardFileFormats'
	    	});
		}	   
	}]
});

function closeImportWin(){
fp.getForm().reset();
            importWin.hide();
			clearInputData();
}

function saveDate(){

var simValidCount = 0;
var totalSimcount = importstore.data.length;
    for (var i = 0; i < importstore.data.length; i++) {
        var record = importstore.getAt(i);
        var checkvalidOrInvalid = record.data['importsimstatusindex'];
        if (checkvalidOrInvalid == 'Valid') {
            simValidCount++;
        }
    }
    
	var saveJson = getJsonOfStore(importstore);
	
Ext.Msg.show({
        title: 'Saving..',
        msg: 'We have ' + simValidCount + ' valid transaction to be saved out of ' + totalSimcount + ' .Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'no') {
                return;
            }
            if (btn == 'yes') {
		if (saveJson != '[]' && simValidCount>0) {
         Ext.Ajax.request({
               url: '<%=request.getContextPath()%>/SimDetailsAction.do?param=saveImportSimDetails',
               method: 'POST',
               params: {
                            simDataSaveParam: saveJson
               },
               success: function (response, options) {
               			var message = response.responseText;
               			Ext.example.msg(message);
               			store.load();
               },
               failure: function () {
               Ext.example.msg("Error");
                        }
               });
               clearInputData();
               fp.getForm().reset();
               importWin.hide();
           }else{
           Ext.MessageBox.show({
                        msg: "You don't have any Valid Information to Proceed",
                        buttons: Ext.MessageBox.OK
                    });
           }
         }
       }
     });
}
function getJsonOfStore(importstore) {
    var datar = new Array();
    var jsonDataEncode = "";
    var recordss = importstore.getRange();
    for (var i = 0; i < recordss.length; i++) {
        datar.push(recordss[i].data);
    }
    jsonDataEncode = Ext.util.JSON.encode(datar);

    return jsonDataEncode;
}
//sameer grid configuration
//************************* store configs
//***************************jsonreader
var reader = new Ext.data.JsonReader({
    root: 'SimDetailsImportRoot',
    totalProperty: 'total',
    fields: [{
        name: 'importslnoIndex'
    }, {
        name: 'importmobilenumberindex'
    }, {
        name: 'importserviceproviderindex'
    },{
        name: 'importsimnumberindex'
    }, {
        name: 'importsimvaliditystartdateindex'
    }, {
        name: 'importsimvalidityenddateindex'
    }, {
        name: 'importsimstatusindex'
    },{
        name: 'importsimremarksindex'
    }]
});

var importstore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SimDetailsAction.do?param=getImportSimDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,
    reader: reader
});
//****************************grid filters
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            type: 'numeric',
            dataIndex: 'importslnoIndex'
        }, {
            type: 'numeric',
            dataIndex: 'importmobilenumberindex'
        }, {
            dataIndex: 'importserviceproviderindex',
            type: 'String'
        }, {
            dataIndex: 'importmanufacturerindex',
            type: 'string'
        },{
            dataIndex: 'importsimvaliditystartdateindex',
            type: 'date'
        }, {
            dataIndex: 'importsimvalidityenddateindex',
            type: 'date'
        }, {
            dataIndex: 'importsimstatusindex',
            type: 'string'
        }, {
            dataIndex: 'importsimremarksindex',
            type: 'string'
        }

    ]
});
//****************column Model Config
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            dataIndex: 'importslnoIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        },
        {
            header: "<span style=font-weight:bold;><%=MobileNumber%></span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importmobilenumberindex'
        }, {
            header: "<span style=font-weight:bold;><%=ServiceProvider%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importserviceproviderindex'
        }, {
            header: "<span style=font-weight:bold;><%=SimNumber%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importsimnumberindex'
        },
       {
            header: "<span style=font-weight:bold;><%=ValidityStartDate%></span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importsimvaliditystartdateindex',
            filter: {
                type: 'date'
            }
        },
       {
            header: "<span style=font-weight:bold;><%=ValidityEndDate%></span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importsimvalidityenddateindex',
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=ValidStatus%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'importsimstatusindex',
            renderer: checkValid,
            filter: {
                type: 'String'
            }

        },{
            header: "<span style=font-weight:bold;><%=Remarks%></span>",
            hidden: false,
            width: 200,
            sortable: true,
            dataIndex: 'importsimremarksindex',
            filter: {
                type: 'String'
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


function checkValid(val) {
    if (val == "Invalid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/No.png">';
    } else if (val == "Valid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/Yes.png">';
    }
}
//*******************************grid**************************///
importgrid = getGrid('', '<%=NoRecordsFound%>', importstore, 825, 198, 20, filters,'', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, '<%=Add%>', false, '<%=Modify%>', false, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',false,'',true,'<%=Save%>',true,'<%=Clear%>',true,'<%=Close%>');	

//end grid

var excelImageFormat = new Ext.FormPanel({
    standardSubmit: true,
    collapsible: false,
    id: 'excelMaster',

    height: 170,
    width: '100%',
    frame: false,
    items: [{
        cls: 'simimportimagepanel'
    }]
});

var importPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: false,
    layout: 'column',
    layoutConfig: {
        columns: 1
    },
    items: [fp,excelImageFormat,importgrid]
});

importWin = new Ext.Window({
    title: 'Sim Import Details',
    width: 840,
    height:483,
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    id: 'importWin',
    items: [importPanelWindow]
});

<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
 importWin.setHeight(505);
importWin.setWidth(840);
<%}%>
//end modify

//function for add button in grid that will open form window
function addRecord() {
    buttonValue = "add";
    titel = '<%=AddSimDetails%>';
    myWin.show();
    Ext.getCmp('MobileNoId').enable();
    myWin.setTitle(titel);

}

function modifyData() {
    //alert('Modify');

    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;

    }
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=noRowsSelected%>");
        return;
    }
    buttonValue = "modify";
    titelForInnerPanel = '<%=Modify%>';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();

    Ext.getCmp('MobileNoId').disable();

    if (grid.getSelectionModel().getCount() == 1) {
        var selected = grid.getSelectionModel().getSelected();
        Ext.getCmp('MobileNoId').setValue(selected.get('simNo'));
        Ext.getCmp('serviceProvId').setValue(selected.get('serviceProvider'));
        Ext.getCmp('simNumId').setValue(selected.get('simNumberDataIndex').trim());
        Ext.getCmp('statuscomboId').setValue(selected.get('Status'));
        Ext.getCmp('validityStartDateId').setValue(selected.get('validityStartDate'));
        Ext.getCmp('ValidityEndDateId').setValue(selected.get('validityEndDate'));
    }
}

//function for delete button in grid that will open form window
function deleteData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=noRowsSelected%>");
        return;
    }
    Ext.Msg.show({
        title: '<%=DeleteSimDetails%>',
        msg: '<%=Areyousureyouwanttodelete%>',
        progressText: 'Deleting  ...',
        buttons: {
            yes: true,
            no: true
        },

        fn: function (btn) {
            switch (btn) {
            case 'yes':
                // outerPanelWindow.getEl().mask();
                //Ajax request
                var selected = grid.getSelectionModel().getSelected();
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/SimDetailsAction.do?param=deleteSimDetails',
                    method: 'POST',
                    params: {
                        mobileNumber: selected.get('simNo'),
                        serviceProvider: selected.get('serviceProvider'),
                        SimNumber: selected.get('simNumberDataIndex'),
                        STATUS: selected.get('Status'),
                        pageName: pageName
                    },
                    success: function (response, options) {

                        var message = response.responseText;
                        Ext.example.msg(message);
                        store.reload();
                        //outerPanelWindow.getEl().unmask();

                    },
                    failure: function () {
                       Ext.example.msg("Error");
                        store.reload();
                        outerPanelWindow.getEl().unmask();

                    }
                });

                break;
            case 'no':
                Ext.example.msg("Sim Details not Deleted..");
                store.reload();
                break;

            }
        }
    });
}

//***************************jsonreader
var reader = new Ext.data.JsonReader({
    root: 'simdataRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'simNo'
    }, {
        name: 'serviceProvider'
    }, {
        name: 'validateStartDate'
    }, {
        name: 'simNumberDataIndex'
    }, {
        name: 'Status'
    },{
        name: 'validityStartDate'
    },{
        name: 'validityEndDate'
    }]

});


//************************* store configs***************************//

var store = new Ext.data.GroupingStore({
    autoLoad:false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SimDetailsAction.do?param=getsimsData',
        method: 'POST'
    }),
   // remoteSort: true,
  //  bufferSize: 700,
   // autoLoad: true,
   // remoteSort:true,
    reader: reader
});
//****************************grid filters
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        dataIndex: 'simNo',
        type: 'string'
    }, {
        dataIndex: 'serviceProvider',
        type: 'string'
    }, {
        dataIndex: 'validateStartDate',
        type: 'date'
    }, {
        dataIndex: 'simNumberDataIndex',
        type: 'string'
    }, {
        dataIndex: 'Status',
        type: 'string'
    },{
        dataIndex: 'validityStartDate',
        type: 'date'
    },{
        dataIndex: 'validityEndDate',
        type: 'date'
    }]
});
//****************column Model Config
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 60
        }), {
            header: 'slnoIndex',
            hidden: true,
            hideable: false,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=MobileNumber%></span>",
            hidden: false,
            //width: 100,
            //sortable: false,
            dataIndex: 'simNo',
            filter: {
                type: 'String'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ServiceProvider%></span>",
            hidden: false,
            //width: 100,
           // sortable: true,
            dataIndex: 'serviceProvider',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Validity Start From Date</span>",
            hidden: true,
            hideable: false,
            width: 150,
           // sortable: true,
            dataIndex: 'validateStartDate',
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter: {
                type: 'Date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=SimNumber%></span>",
            hidden: false,
            width: 120,
            //sortable: true,
            dataIndex: 'simNumberDataIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ValidityStartDate%></span>",
            hidden: false,
            width: 150,
            dataIndex: 'validityStartDate',
            filter: {
                type: 'date'
            }

        }, {
            header: "<span style=font-weight:bold;><%=ValidityEndDate%></span>",
            hidden: false,
            width: 150,
            dataIndex: 'validityEndDate',
            filter: {
                type: 'date'
            }

        }, {
            header: "<span style=font-weight:bold;><%=Status%></span>",
            hidden: false,
            width: 150,
            dataIndex: 'Status',
            filter: {
                type: 'String'
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

<%
if(customerId > 0 )
{
	if(userAuthority.equalsIgnoreCase("Admin"))
	{%>    
    	grid = getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 40, 490, 20, filters,'', false, '', 20, false, '', false, '', false, '', jspName, exportDataType, false, '', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',true,'<%=ImportSim%>');	    		
 	<%} else if(userAuthority.equalsIgnoreCase("Supervisor")) {%>
 		grid = getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 40, 490, 20, filters,'', false, '', 20, false, '', false, '', false, '', jspName, exportDataType, false, '', false, '<%=Add%>', true, '<%=Modify%>', false, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',true,'<%=ImportSim%>');		
 	<%} else {%>
 		grid = getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 40, 490, 20, filters,'', false, '', 20, false, '', false, '', false, '', jspName, exportDataType, false, '', false, '<%=Add%>', false, '<%=Modify%>', false, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',false,'<%=ImportSim%>');	
<%} 
} else {%>
	grid = getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 40, 490, 20, filters,'', false, '', 20, false, '', false, '', false, '', jspName, exportDataType, false, '', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',true,'<%=ImportSim%>');	
<% }%>

//********************************grid***************************//

//*****main starts from here*************************************//
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    
    Ext.Ajax.timeout = 180000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        //title: '<%=SimDetails%>',
        renderTo: 'content',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [grid]
        //bbar: ctsb
    });
    store.load();
});
</script>
    
</body>

</html>
<%}%>