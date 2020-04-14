<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="ISO-8859-1"%>
	<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
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
		 ArrayList<String> tobeConverted = new ArrayList<String>();
		tobeConverted.add("Holidays_Details");
		tobeConverted.add("Select_School");
		tobeConverted.add("Standard");
		tobeConverted.add("Select_Standard");
		tobeConverted.add("School_Holiday_Information");
		tobeConverted.add("From_Date");
		tobeConverted.add("Select_From_Date");
		tobeConverted.add("To_Date");
		tobeConverted.add("Select_To_Date");
		tobeConverted.add("Days");
		tobeConverted.add("Save");
		tobeConverted.add("Cancel");
		tobeConverted.add("Add");
		tobeConverted.add("Select_Single_Row");
		tobeConverted.add("No_Rows_Selected");
		tobeConverted.add("Modify");
		tobeConverted.add("Delete_Holiday_Details");
		tobeConverted.add("Are_you_sure_you_want_to_delete");
		tobeConverted.add("SLNO");
		tobeConverted.add("No_Records_Found");
		tobeConverted.add("PDF");
		tobeConverted.add("Delete");

		ArrayList<String> convertedWords = new ArrayList<String>();
		convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted, language);
		String HolidayDetails = convertedWords.get(0);
		String SelectSchool = convertedWords.get(1);
		String Standard = convertedWords.get(2);
		String SelectStandard = convertedWords.get(3);
		String SchoolHolidayInformation = convertedWords.get(4);
		String FromDate = convertedWords.get(5);
		String SelectFromDate = convertedWords.get(6);
		String ToDate = convertedWords.get(7);
		String SelectToDate = convertedWords.get(8);
		String Days = convertedWords.get(9);
		String Save = convertedWords.get(10);
		String Cancel = convertedWords.get(11);
		String Add = convertedWords.get(12);
		String SelectSingleRow = convertedWords.get(13);
		String NoRowsSelected = convertedWords.get(14);
		String Modify = convertedWords.get(15);
		String DeleteHolidayDetails = convertedWords.get(16);
		String Areyousureyouwanttodelete = convertedWords.get(17);
		String SLNO = convertedWords.get(18);
		String NoRecordsFound = convertedWords.get(19);
		String PDF = convertedWords.get(20);
		String Delete = convertedWords.get(21);
%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">

		<title><%=HolidayDetails%></title>
				<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
				<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
				<pack:script src="../../Main/Js/T4UStatusBar.js"></pack:script>
				<pack:script src="../../Main/Js/Common.js"></pack:script>
				<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
				<pack:script src="../../Main/resources/ux/statusbar/StatusBar.js"></pack:script>
				<pack:script src="../../Main/resources/ux/statusbar/ValidationStatus.js"></pack:script>
				<pack:script src="../../Main/resources/ux/fileuploadfield/FileUploadField.js"></pack:script>
				<!-- for grid -->
				<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
				<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
				<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
				<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
				<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
				<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
				<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
				<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
				<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
				<pack:style src="../../Main/resources/css/ext-all.css" />
				<pack:style src="../../Main/resources/css/chooser.css" />
				<pack:style src="../../Main/resources/css/xtheme-blue.css" />
				<pack:style src="../../Main/resources/css/common.css" />
				<pack:style src="../../Main/resources/css/dashboard.css" />
				<pack:style src="../../Main/resources/css/commonnew.css" />
				<pack:style src="../../Main/iconCls/icons.css" />
				<pack:style src="../../Main/resources/ux/statusbar/css/statusbar.css" />
				<pack:style src="../../Main/modules/school/css/kalendar.css" />
				<pack:script src="../../Main/modules/school/js/jquery.min.js"></pack:script>
				<pack:script src="../../Main/modules/school/js/kalendar.js"></pack:script> 
				<pack:script src="../../Main/Js/examples1.js"></pack:script>
                <pack:style src="../../Main/resources/css/examples1.css" />	
				<!-- for grid -->
				<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
				<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
				

		<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}

#wrap{
    width:110%;
    margin:0 auto;
}
.box{
    float:left;
    width:31%;
    height:433px;
    margin:0 auto;
}
.rbox{
    float:right;
    width:69%;
    height:400px;
    margin:0 auto;
}
.schoolCombo{
background-color:#DFE8F6 !important;
}
		label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
</style>


	 <div class="schoolCombo" id="school" ></div>
		<div id="wrapper">
			<div class="box kalendar" id="cal"></div>
			<div class="rbox" id="main"></div>
		</div>
		<script>
/*******************resize window event function**********************/
Ext.EventManager.onWindowResize(function () {
    var width = '100%';
    var height = '100%';
    grid.setSize(width, height);
    outerPanel.setSize(width, height);
    outerPanel.doLayout();
});
var dtcur = datecur;
 var dtnext = datecur.add(Date.DAY, 1);   
///var dtcur = datecur.add(Date.DAY, -2); 
var outerPanel;
var ctsb;
var jspName = "HolidayDetails";
var exportDataType = "int,int,int,number,String,String";
var selected;
var grid;
var buttonValue;
var globlelId;
//****************************************customer store****************************//

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
                custName=Ext.getCmp('custcomboId').getRawValue();
                store.load({
                       params: {
                           CustId: custId,
                           CustName: custName,
                           jspName:jspName
                       }
                   });
                standardstore.load({
                       params: {
                           CustId: custId,
                           CustName: custName
                       }
                   });
             }
        }
        
    }
});

//******************************************************************customer Combo******************************************//
 var custnamecombo = new Ext.form.ComboBox({
       store: clientcombostore,
       id: 'custcomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectSchool%>',
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
               calendarEvent();
                   custId = Ext.getCmp('custcomboId').getValue();
                   globlelId = Ext.getCmp('custcomboId').getValue();
                   custName = Ext.getCmp('custcomboId').getRawValue();
				   store.load({
                       params: {
                           CustId: custId,
                           CustName: custName,
                           jspName:jspName
                       }
                   });
                   standardstore.load({
                       params: {
                           CustId: custId,
                           CustName: custName
                       }
                   });
           
                   if ( <%=customerId%> > 0) {
                       Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
                         store.load({
                           params: {
                               CustId: custId,
                               CustName: custName,
                               jspName:jspName
                           }
                       });
                      standardstore.load({
                       params: {
                           CustId: custId
                       }
                     });
                   }
               }
           }
       }
   });
    function calendarEvent(){
    var custIds = Ext.getCmp('custcomboId').getValue();
               var url='<%=request.getContextPath()%>/SchoolHolidayListAction.do?param=getHolidayList';
                $.ajax({
                    url: url,
					type: 'POST',
					data: {paramId:custIds},
                    dataType: "json",
                    success: function(data) {
                    var eventArray=data;

					 $('.kalendar').kalendar({ 
						events: eventArray,
						color: "green",
						firstDayOfWeek: "Sunday",
						eventcolors: {
						yellow: {
						background: "#FC0",
						text: "#000",
						link: "#000"
						},
						blue: {
						background: "#6180FC",
						text: "#FFF",
						link: "#FFF"
						}
						}
						});
					}
                });
    }
/**********************************************StandardStore****************************************/
var standardstore = new Ext.data.JsonStore({			
url: '<%=request.getContextPath()%>/SchoolHolidayListAction.do?param=getStandard',
       id: 'StandardStoreId',
       root: 'standardHolidayRoot',
       autoLoad: true,
       fields: ['STANDARD']	
 });
/*********************************StandardCombo********************************************/
 var Standardcombo = new Ext.form.ComboBox({
       store: standardstore,
       id: 'standardcomboId',
       mode: 'local',
       hidden: false,
       forceSelection: true,
       emptyText: '<%=SelectStandard%>',
       blankText: '<%=SelectStandard%>',
       selectOnFocus: true,
       anyMatch: true,
	   allowBlank: false,
       typeAhead: false,
       triggerAction: 'all',
       valueField: 'STANDARD',
       displayField: 'STANDARD',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
					 	
               }
           }
       }
   }); 
/*****************************Combo for Customer********************************************/
var comboPanel = new Ext.Panel({
    title:'Holiday Information',
    standardSubmit: true,
    collapsible: false,
    id: 'traderMaster',
    layout: 'table',
    frame: true,
    width: screen.width -25,
    height: 60,
    layoutConfig: {
        columns: 3
    },
    items: [{
            xtype: 'label',
            text: '<%=SelectSchool%>' + ' :',
            cls: 'labelstyle'
        },
        custnamecombo,{
        width:80
        }
    ]
});
comboPanel.render('school');
/*********************inner panel for displaying form field in window***********************/
var innerPanelForUnitDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 150,
    width: 381,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=SchoolHolidayInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 2,
        id: 'addpanelid',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorystandardid'
            },{
                xtype: 'label',
                text: 'Standard' + ':',
                cls: 'labelstyle',
                id: 'standardid'
            }, Standardcombo, {
                xtype: 'label',
                text: ''
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryFromDateId'
            },{
                xtype: 'label',
                text: '<%=FromDate%>' + ':',
                cls: 'labelstyle',
                id: 'FromDateid'
            },{
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format : 'd-m-Y',
                emptyText: '<%=SelectFromDate%>',
                allowBlank: false,
                blankText: '<%=SelectFromDate%>',
                id: 'fromdate',
                //minValue: dtcur,
                value: dtcur
            }, {
                xtype: 'label',
                text: ''
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryToDateId'
            },{
                xtype: 'label',
                text: '<%=ToDate%>' + ':',
                cls: 'labelstyle',
                id: 'ToDateid'
            },  {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 185,
                format: 'd-m-Y',
                emptyText: '<%=SelectToDate%>',
                allowBlank: false,
                blankText: '<%=SelectToDate%>',
                id: 'todate',
                value:dtnext
                //value: dtcur
            }, {
                xtype: 'label',
                text: ''
            },
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
    width: 381,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls:'savebutton',
        id: 'addButtId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {

                    if (Ext.getCmp('standardcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectStandard%>");
                        Ext.getCmp('standardcomboId').focus();
                        return;
                    }
					if (Ext.getCmp('fromdate').getValue() == "") {
					    Ext.example.msg("<%=SelectFromDate%>"); 
                        Ext.getCmp('fromdate').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('todate').getValue() == "") {
                        Ext.example.msg("<%=SelectToDate%>");
                        Ext.getCmp('todate').focus();
                        return;
                    }
                    
                    if (innerPanelForUnitDetails.getForm().isValid()) {
                          var uniqueId;
                          var selected;
                        if (buttonValue == 'modify') {
                            selected = grid.getSelectionModel().getSelected();
                            uniqueId=selected.get('IdDataIndex');
                            //alert(uniqueId);
                        }
                        Ext.getCmp('addButtId').disable();
                        Ext.getCmp('canButtId').disable();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SchoolHolidayListAction.do?param=saveHolidayList',
                            method: 'POST',
                            params: {
                                  UniqueId:uniqueId,
                                  buttonValue: buttonValue,
                                  standard: Ext.getCmp('standardcomboId').getValue(),
                                  fromDate: Ext.getCmp('fromdate').getValue(),
                                  toDate: Ext.getCmp('todate').getValue(),
                                  custId:Ext.getCmp('custcomboId').getValue()
                            },
                              success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin.hide();
                                 store.reload({
                                    params: {
                                    CustId: custId,
                                    CustName: custName,
                                    jspName:jspName
                                    }
                                  });
                                  
                                   Ext.getCmp('standardcomboId').reset();
                                   Ext.getCmp('fromdate').reset();
                                   Ext.getCmp('todate').reset();
                                  
                                   Ext.getCmp('addButtId').enable();
                                   Ext.getCmp('canButtId').enable();
                                    calendarEvent().refresh();
                                   outerPanelWindow.getEl().unmask();
                            },
                            failure: function () {
                                Ext.example.msg("Failed to Insert...");
                                store.reload();
                                Ext.getCmp('addButtId').enable();
                                Ext.getCmp('canButtId').enable();
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
                 Ext.getCmp('standardcomboId').reset();
                 Ext.getCmp('fromdate').reset();
                 Ext.getCmp('todate').reset();
                                  
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
    frame: false,
    items: [innerPanelForUnitDetails, innerWinButtonPanel]
});
/***********************window for form field****************************/
myWin = new Ext.Window({
    title: 'titel',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: '',
    //height : 400,
    width: 395,
    id: 'myWin',
    items: [outerPanelWindow]
});

//***********************************function for add button in grid that will open form window**************************************************//
function addRecord() {
    buttonValue = "add";
    titel = '<%=Add%>';
     if (Ext.getCmp('custcomboId').getValue()== "") {
                   Ext.example.msg("<%=SelectSchool%>");
                   Ext.getCmp('custcomboId').focus();
                   return;
                }
    myWin.show();
        Ext.getCmp('standardcomboId').reset();
        Ext.getCmp('fromdate').reset();
        Ext.getCmp('todate').reset();
    myWin.setTitle(titel);
	
}
//**************************************function for modify button in grid that will open form window*********************************************//
function modifyData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    buttonValue = "modify";
    titelForInnerPanel = '<%=Modify%>';
     custId = Ext.getCmp('custcomboId').getValue();
    var selected = grid.getSelectionModel().getSelected();
           myWin.setPosition(450, 150);
           myWin.setTitle(titelForInnerPanel);
            myWin.show();
            Ext.getCmp('standardcomboId').setValue(selected.get('StandardDataIndex'));
            Ext.getCmp('fromdate').setValue(selected.get('FromDateDataIndex'));
            Ext.getCmp('todate').setValue(selected.get('TodateDataIndex'));
}
//******************function for delete button in grid that will open form window********************************//
function deleteData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    Ext.Msg.show({
        title: '<%=DeleteHolidayDetails%>',
        msg: '<%=Areyousureyouwanttodelete%>',
        progressText: 'Deleting  ...',
        buttons: {
            yes: true,
            no: true
        },
        fn: function (btn) {
            switch (btn) {
            case 'yes':
                var selected = grid.getSelectionModel().getSelected();
                var uniqueId=selected.get('IdDataIndex');
                var custId = Ext.getCmp('custcomboId').getValue();
				var standard=selected.get('StandardDataIndex');
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/SchoolHolidayListAction.do?param=deleteHolidayDetails',
                    method: 'POST',
                    params: {
                        UniqueId:uniqueId,
                        CustId:custId,
                        Standard:standard
                    },
                    success: function (response, options) {
                    
                        var message = response.responseText;
                        Ext.example.msg(message);
                       store.reload();
                       calendarEvent().refresh();
                       outerPanelWindow.getEl().unmask();
                    },
                    failure: function () {
                        Ext.example.msg("Error");
                        store.reload();
                        outerPanelWindow.getEl().unmask();

                    }
                });

                break;
            case 'no':
                Ext.example.msg("HolidayDetails not Deleted..");
                store.reload();
                break;

            }
        }
    });
}

//***************************jsonreader****************************************************************//
var reader = new Ext.data.JsonReader({
    root: 'HolidayDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoDataIndex'
    },{
        name: 'StandardDataIndex'
    },{
        name: 'FromDateDataIndex'
    },{
        name: 'TodateDataIndex'
    }, {
        name: 'DaysDataIndex'
    },{
       name:'IdDataIndex'
    }]
});

//************************* store configs****************************************//
var custName=Ext.getCmp('custcomboId').getRawValue();
var store = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SchoolHolidayListAction.do?param=getHolidayDetails',
        method: 'POST'
    }),
     remoteSort: false,
    sortInfo: {
        field: 'StandardDataIndex',
        direction: 'asc'
    },
    bufferSize: 700,
    reader: reader
});
//****************************grid filters*************************************************//
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            dataIndex: 'slnoDataIndex',
             type: 'numeric'
        }, {
            dataIndex: 'StandardDataIndex',
            type: 'String'
        }, {
            dataIndex: 'FromDateDataIndex',
            type: 'String'
        }, {
            dataIndex: 'TodateDataIndex',
            type: 'String'
        }, {
            dataIndex: 'DaysDataIndex',
            type: 'String'
        }
    ]
});
//****************column Model Config***************************************************//
var createColModel = function (finish, start) {

     var columns = [
         new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;><%=SLNO%></span>",
             width: 50
         }), {
             dataIndex: 'slnoDataIndex',
             hidden: true,
             header: "<span style=font-weight:bold;><%=SLNO%></span>",
             width: 100,
             filter: {
                 type: 'numeric'
             }
			},{
            header: "<span style=font-weight:bold;><%=Standard%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'StandardDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=FromDate%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            renderer: Ext.util.Format.dateRenderer('d-m-Y'),
            dataIndex: 'FromDateDataIndex'
        }, {
            header: "<span style=font-weight:bold;><%=ToDate%></span>",
            hidden: false,
            width: 100,
            sortable: true,
             renderer: Ext.util.Format.dateRenderer('d-m-Y'),
            dataIndex: 'TodateDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=Days%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'DaysDataIndex',
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
//*****************************************grid**********************************************//

grid = getGrid('', '<%=NoRecordsFound%>', store, 900, 400, 20, filters,'', false, '', 20, false, '', false, '', false, '', jspName, exportDataType, false, '<%=PDF%>', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');

//************************************************************************************************//
var calendarPanel = new Ext.Panel({
       title: '',
	   //renderTo: 'cal',
       standardSubmit: true,
       collapsible: false,
       id: 'secondRoutePanelId',
       layout: 'table',
       frame: true,
       //width: 300,
       height: 400
   });
   calendarPanel.render('cal');
  //******************************************************calendar*******************************//
  
//*****main starts from here*******************************************************************//
Ext.onReady(function () {
calendarEvent();
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 120000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        //renderTo: 'content',
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
    });
     
    outerPanel.render('main');	
});

</script>
	<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%
	}
%>