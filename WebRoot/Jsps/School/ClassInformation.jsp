<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customeridlogged = loginInfo.getCustomerId();
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Select_School");
tobeConverted.add("SuperVisor_Name");
tobeConverted.add("want_to_delete");
tobeConverted.add("Error");
tobeConverted.add("Deleting");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("SLNO");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row"); 
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Modify_Details");
tobeConverted.add("Delete");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Select_Supervisor");
tobeConverted.add("Class");
tobeConverted.add("Select_School_Name");
tobeConverted.add("Class_Information");
tobeConverted.add("Class_Information_Not_Deleted");
tobeConverted.add("Class_Information_Details");
tobeConverted.add("Select_Class_Type");

ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectSchool=convertedWords.get(0);
String SuperVisorName=convertedWords.get(1);
String wanttodelete=convertedWords.get(2);
String Error=convertedWords.get(3);
String Deleting=convertedWords.get(4);
String Save=convertedWords.get(5);
String Cancel=convertedWords.get(6);
String SLNO=convertedWords.get(7);
String NoRowsSelected=convertedWords.get(8);
String SelectSingleRow=convertedWords.get(9);
String Add=convertedWords.get(10);
String Modify=convertedWords.get(11);
String NoRecordsFound=convertedWords.get(12);
String ModifyDetails=convertedWords.get(13);
String Delete=convertedWords.get(14);
String ClearFilterData=convertedWords.get(15);
String SelectSupervisor=convertedWords.get(16);
String Class=convertedWords.get(17);
String SelectSchoolName=convertedWords.get(18);
String ClassInformation=convertedWords.get(19);
String ClassInformationNotDeleted=convertedWords.get(20);
String ClassInformationDetails=convertedWords.get(21);
String SelectClassType=convertedWords.get(22);

%>

<jsp:include page="../Common/header.jsp" />
 
		<title>Class Information</title>	
		 <style>
   .lblfield
   {
   spacing: 10px;
	height: 20px;
	width: 160 px !important;
	min-width: 160px !important;
	margin-bottom: 5px !important;
	margin-left: 13px !important;
margin-right: 7px;
	font-size: 12px;
	font-family: sans-serif;
   }
   label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
    height: 21px !important;
}
.x-window-tl *.x-window-header {
			height : 40px !important;
		}
		.footer {
			bottom : -14px !important;
		}
   </style>	
	  

 
 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
  
   <script>
 
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
 var outerPanel;
 var ctsb;
 
 var panel1;
 var closereportflag = false;
 var selected;
 var titelForInnerPanel;
 /********************resize window event function***********************/
 Ext.EventManager.onWindowResize(function () {
     var width = '100%';
     var height = '100%';
     grid.setSize(width, height);
     outerPanel.setSize(width, height);
     outerPanel.doLayout();
 });
 //******************************store for getting customer name************************
 var clientcombostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
    id: 'CustomerStoreId',
    root: 'CustomerRoot',
    autoLoad: true,
    remoteSort: true,
    fields: ['CustId', 'CustName'],
    listeners: {
        load: function (custstore, records, success, options) {
            if ( <%= customeridlogged %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
                custId = Ext.getCmp('custcomboId').getValue();
                store.load({
                    params: {
                        CustId: custId
                    }
                });
                
                  
                supervisorNamesCombostore.load({
                     					params: {
                         						CustId: Ext.getCmp('custcomboId').getValue(),
                         						LTSPId: <%=systemId%>
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
    emptyText: '<%=SelectSchool%>',
    blankText: '<%=SelectSchool%>',
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
                        CustId: custId
                    }
                });
              
                supervisorNamesCombostore.load({
                     					params: {
                         						CustId: Ext.getCmp('custcomboId').getValue()
                         				
                     							}
                 					});
            }
        }
    }
    
});



var supervisorNamesCombostore = new Ext.data.JsonStore({
    url:'<%=request.getContextPath()%>/ClassInformationAction.do?param=getUserNames',
				   id:'snStoreId',
			       root:'snRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['snId','snName']
 });
 
 var supervisorNamesCombo = new Ext.form.ComboBox({
     store: supervisorNamesCombostore,
     fieldLabel: 'supervisorName',
     id: 'supervisorNameId',
     mode: 'local',
     hidden: false,
     resizable: true,
     forceSelection: true,
     emptyText: '<%=SelectSupervisor%>',
     blankText: '',
     selectOnFocus: true,
     allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'snId',
     displayField: 'snName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             CustId = Ext.getCmp('custcomboId').getValue();
             selectedSupervisorId= Ext.getCmp('supervisorNameId').getValue();
             }
         }
     }
 });
 

 //********************************* Reader Config***********************************
 var reader = new Ext.data.JsonReader({
     idProperty: 'ClassInformationRootId',
     root: 'ClassInformationRoot',
     totalProperty: 'total',
     fields: [{
         name: 'slnoIndex'
     }, {
         name: 'classIndex'
     },{
         name: 'supervisorIDIndex'
     }, {
         name: 'supervisorNameIndex'
     },{
         name: 'createdByIndex'
     }, {
         name: 'createdTimeIndex'
     },{
         name: 'IDIndex'
     }]
 });
 //******************************** Grid Store*************************************** 
 var store = new Ext.data.GroupingStore({
     autoLoad: false,
     proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/ClassInformationAction.do?param=getClassInfoReport',
         method: 'POST'
     }),
    remoteSort: false,
     sortInfo: {
         field: 'classIndex',
         direction: 'ASC'
     },
     storeId: 'gridStoreid',
     reader: reader
 });
 


 var filters = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
       },{
         dataIndex: 'classIndex',
         type: 'string'
     }, {
         type: 'string',
         dataIndex: 'supervisorIDIndex'
     }, {
         type: 'string',
         dataIndex: 'supervisorNameIndex'
     }, {
         type: 'string',
         dataIndex: 'createdByIndex'
     }, {
         type: 'string',
         dataIndex: 'createdTimeIndex'
     }]
 });
 
 
 
 
 
  //**********************inner panel start******************************************* 
 var innerPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'custMaster',
     layout: 'table',
     frame: true,
     height:50,
	 width: screen.width-18,
     layoutConfig: {
         columns: 10
     },
     items: [{
             xtype: 'label',
             text: '<%=SelectSchool%>' + ' :',
             cls: 'labelstyle'
         },
         Client
     ]
 });



 //**************************** Grid Pannel Config ******************************************

 var createColModel = function (finish, start) {
     var columns = [
         new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;>Sl No</span>",
             width: 50
         }),{
             dataIndex: 'slnoIndex',
             header: "<span style=font-weight:bold;>Sl No</span>",
             hidden:true,
             filter: {
                 type: 'numeric'
           }
           }, {
             header: "<span style=font-weight:bold;>Class</span>",
             dataIndex: 'classIndex',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>SupervisorID</span>",
             dataIndex: 'supervisorIDIndex',
             hidden : true,
             filter: {
                 type: 'string'
             }
         },
         {
             header: "<span style=font-weight:bold;>Supervisor Name</span>",
             dataIndex: 'supervisorNameIndex',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Created By</span>",
             dataIndex: 'createdByIndex',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Created Time</span>",
             dataIndex: 'createdTimeIndex',
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

grid = getGrid('<%=ClassInformationDetails%>', '<%=NoRecordsFound%>', store, screen.width - 36, 420, 10, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', '', '', false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');
 


 //**************************** Grid Panel Config ends here**********************************
 //**************************** Grid Form config starts here*********************************
 Ext.ns('App', 'App.user');

 var innerPanelForClassInfo = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 110,
    width: 400,
    frame: true,
    id: 'innerPanelForClassInfoId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: 'Class Information',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'OwnerInformationId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [ {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'classEmptyId1'
        },{
            xtype: 'label',
            text: '<%=Class%>' + ' :',
            cls: 'labelstyle',
            id: 'classLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            allowBlank: false,
            id: 'classId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'classId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'supervisorNameEmptyId1'
        },{
            xtype: 'label',
            text: '<%=SuperVisorName%>' + ' :',
            cls: 'labelstyle',
            id: 'supervisorNameLabelId'
        }, 
        supervisorNamesCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'supervisorNameEmptyId2'
        }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 380,
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
                fn: function () {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectSchoolName%>");
                        Ext.getCmp('custcomboId').focus();
                        return;
                    }
                    
                    if (Ext.getCmp('classId').getValue() == "") {
                        Ext.example.msg("<%=SelectClassType%>");
                        Ext.getCmp('classId').focus();
                        return;
                    }
                    if (Ext.getCmp('supervisorNameId').getValue() == "") {
                        Ext.example.msg("<%=SelectSupervisor%>");
                        Ext.getCmp('supervisorNameId').focus();
                        return;
                    }
                    
                     
                    if (innerPanelForClassInfo.getForm().isValid()) {
                    var id;
                    var selectedClass;
                    var selectedSupervisorId;
                    var selectedID;
                    var selected;
                        if (buttonValue == 'Modify') {
                             selected = grid.getSelectionModel().getSelected();
                             selectedClass=selected.get('classIndex');
                             selectedID=selected.get('IDIndex');
                             id = selected.get('supervisorIDIndex');
                        }
                     classInfoOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/ClassInformationAction.do?param=classInfoAddAndModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                custName: Ext.getCmp('custcomboId').getRawValue(),
                                className: Ext.getCmp('classId').getValue(),
                                supervisorName: Ext.getCmp('supervisorNameId').getValue(),
                                gridClassName:selectedClass,
                                gridID:selectedID,
                                id:id
                           
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('classId').reset();
                                Ext.getCmp('supervisorNameId').reset();
                              
                                myWin.hide();
                                classInfoOuterPanelWindow.getEl().unmask();
                                store.load({
                                    params: {
                                        CustId: custId
                                    }
                                });
                                
                                supervisorNamesCombostore.load({
                     					params: {
                         						CustId: Ext.getCmp('custcomboId').getValue()
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
 var classInfoOuterPanelWindow = new Ext.Panel({
    width: 390,
    height: 200,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForClassInfo, innerWinButtonPanel]
});
myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 220,
    width: 390,
    id: 'myWin',
    items: [classInfoOuterPanelWindow]
});


function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectSchoolName%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=ClassInformationDetails%>';
    myWin.setPosition(450, 150);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('classId').reset();
    Ext.getCmp('supervisorNameId').reset();
  }

 function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectSchoolName%>");
        Ext.getCmp('custcomboId').focus();
        return;
    }
   
    buttonValue = 'Modify';
    
    titelForInnerPanel = '<%=ModifyDetails%>';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    Ext.getCmp('classId').show();
    Ext.getCmp('supervisorNameId').show();
    
   
    var selected = grid.getSelectionModel().getSelected();
     if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
     var selected;
     supervisorNamesCombostore.load({
        params: {
            CustId: Ext.getCmp('custcomboId').getValue()
        },
        callback: function () {
            myWin.setPosition(450, 150);
            myWin.setTitle(titelForInnerPanel);
            myWin.show();
            selected = grid.getSelectionModel().getSelected();
          	Ext.getCmp('classId').setValue(selected.get('classIndex'));
    		Ext.getCmp('supervisorNameId').setValue(selected.get('supervisorIDIndex'));
        }
    });
}

      
   function deleteData() {
       if (Ext.getCmp('custcomboId').getValue() == "") {
                            Ext.example.msg("<%=SelectSchoolName%>");
           					Ext.getCmp('custcomboId').focus();
           					return;
       						}
   
  
        buttonValue = "Delete";
        
        
        var selected = grid.getSelectionModel().getSelected();
          if(grid.getSelectionModel().getCount()>1){
                            Ext.example.msg("<%=SelectSingleRow%>");
           					return;
       						}
    
    if (grid.getSelectionModel().getSelected() == null) {
                            Ext.example.msg("<%=NoRowsSelected%>");
           					Ext.getCmp('custcomboId').focus();
           					return;
       						}
        classId=selected.get('classIndex');

        Ext.Msg.show({
            title: '<%=Delete%>',
            msg: '<%=wanttodelete%>',
            buttons: {
                yes: true,
                no: true
            },
            fn: function (btn) {
                switch (btn) {
                case 'yes':
                    ctsb.showBusy('<%=Deleting%>');
                    outerPanel.getEl().mask();
                    var selected = grid.getSelectionModel().getSelected();
                    var selectedID = selected.get('IDIndex');
                    var selectedClass=selected.get('classIndex');
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/ClassInformationAction.do?param=deleteData',
                        method: 'POST',
                        params: {
                            CustId: Ext.getCmp('custcomboId').getValue(),
                            gridID:selectedID,
                            className: Ext.getCmp('classId').getValue(),
                            gridClassName:selectedClass
                        },
                        success: function (response, options) {
                            Ext.example.msg(response.responseText); 
                            store.reload();
                            outerPanel.getEl().unmask();
                        },
                        failure: function () {
                            Ext.example.msg("<%=Error%>"); 
                            store.reload();
                            outerPanel.getEl().unmask();

                        }
                    });

                    break;
                case 'no':
                    Ext.example.msg("<%=ClassInformationNotDeleted%>");
                    store.reload();
                    break;

                }
            }
        });

    }

 var gridPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     cls: 'outerpanel',
     layout: 'table',
     layoutConfig: {
         columns: 2,
         columnWidth: 100
     },
     items: [grid],
     bbar: ctsb
 });
 //***************************  Main starts from here **************************************************
 Ext.onReady(function () {
     ctsb = tsb;
     Ext.QuickTips.init();
     Ext.form.Field.prototype.msgTarget = 'side';
     outerPanel = new Ext.Panel({
         title: '<%=ClassInformation%>',
         renderTo: 'content',
         standardSubmit: true,
         frame: true,
         width:screen.width-25,
         height:545,
         cls: 'outerpanel',
         items: [innerPanel, gridPanel]
     });


 });
   
   </script>
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>