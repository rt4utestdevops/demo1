<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
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
	String ipVal = request.getParameter("ipVal");	
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
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("SLNO");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Rate");
tobeConverted.add("Type");
tobeConverted.add("Enter_Rate");
tobeConverted.add("Enter_Type");
tobeConverted.add("Select_Customer");
tobeConverted.add("Month");
tobeConverted.add("Year");
tobeConverted.add("Grade");
tobeConverted.add("Mineral_Code");
tobeConverted.add("Select_Month");
tobeConverted.add("Enter_Year");
tobeConverted.add("Enter_Grade");
tobeConverted.add("Select_Mineral_Code");
tobeConverted.add("Add_Details");
tobeConverted.add("Grade_Master_Details");
tobeConverted.add("Select_Single_Row");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String Add=convertedWords.get(0);
String Modify=convertedWords.get(1);
String NoRecordsFound=convertedWords.get(2);
String ClearFilterData=convertedWords.get(3);
String Save=convertedWords.get(4);
String Cancel=convertedWords.get(5);
String SLNO=convertedWords.get(6);
String NoRowsSelected=convertedWords.get(7);
String Rate=convertedWords.get(8);
String Type=convertedWords.get(9);
String EnterRate=convertedWords.get(10);
String EnterType=convertedWords.get(11);
String SelectCustomer=convertedWords.get(12);
String Month=convertedWords.get(13);
String Year=convertedWords.get(14);
String Grade=convertedWords.get(15);
String MineralCode=convertedWords.get(16);
String SelectMonth=convertedWords.get(17);
String EnterYear=convertedWords.get(18);
String EnterGrade=convertedWords.get(19);
String SelectMineralCode=convertedWords.get(20);
String AddDetails=convertedWords.get(21);
String GradeMasterDetails=convertedWords.get(22);
String SelectSingleRow=convertedWords.get(23);

int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);	

if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{
%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title><%=GradeMasterDetails%></title>
	
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<jsp:include page="../IronMining/css.jsp" />
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<jsp:include page="../IronMining/css.jsp" />
	<%}%>
		 <jsp:include page="../Common/ExportJS.jsp" />
	<style>
		
		label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			height : 38px !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-layer ul {
		 	min-height: 27px !important;
		}
		.x-table-layout-ct {
			overflow : hidden !important;
		}
	</style>
 <script>
 var innerpage=<%=ipVal%>;
	
	   	    if (innerpage == true) {
				
				if(document.getElementById("topNav")!=null && document.getElementById("topNav")!=undefined)
				{
					document.getElementById("topNav").style.display = "none";
					$(".container").css({"margin-top":"-72px"});
				}
				
			}
   var outerPanel;
   var outerPanelForGrid;
   var jspName = "GradeMaster";
   var exportDataType = "int,string,string,string,number,number,number,string,string,int";
   var grid;
   var myWin;
   var buttonValue;
   var editedRowsForGrid="";
   var editedRate;
 //----------------------------------customer store---------------------------// 
    var customercombostore = new Ext.data.JsonStore({
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
                    custName = Ext.getCmp('custcomboId').getRawValue();
                     mineralStore.load({
                       params: {
                           CustId:custId
                       }
                   });
                   store.load({
                       params: {
                           jspName: jspName,
                           CustId:custId,
                           CustName:custName
                       }
                   }); 
                }
            }
        }
    });

    //******************************************************************customer Combo******************************************//
    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCustomer%>' ,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        resizable: true,
        lazyRender: true,
        valueField: 'CustId',
        displayField: 'CustName',
        cls: 'selectstylePerfect',
        listeners: {
           select: {
               fn: function() {
                   custId = Ext.getCmp('custcomboId').getValue();
                   custName=Ext.getCmp('custcomboId').getRawValue();
                   mineralStore.load({
                       params: {
                           CustId:custId
                       }
                   });
                   store.load({
                       params: {
                           jspName: jspName,
                           CustId:custId,
                           CustName:custName
                       }
                   }); 
               }
           }
       }
    });

 //***************************************************************************************************************//
   var clientPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'clientPanelId',
       layout: 'table',
       frame: false,
       width: screen.width - 60,
       height: 50,
       layoutConfig: {
           columns: 15
       },
       items: [{
               xtype: 'label',
               text: '<%=SelectCustomer%>' + ' :',
               cls: 'labelstyle',
               id: 'ltspcomboId'
           },
           custnamecombo, {
               width: 40
           }
       ]
   });
   
 //******************************************Add and Modify function *********************************************************************//
var mineralStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/MiningGradeMasterAction.do?param=getMineralCode',
       id: 'mineralCodeStoreId',
       root: 'mineralCodeRoot',
       autoLoad: true,
       remoteSort: true,
       fields: ['Mineral', 'Value'],
       listeners: {}
   });

var mineralCombo = new Ext.form.ComboBox({
       store: mineralStore,
       id: 'mineralComboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       valueField: 'Value',
       emptyText: '<%=SelectMineralCode%>',
       resizable: true,
       displayField: 'Mineral',
       cls: 'selectstylePerfectnew',
       listeners: {
        select: {
               fn: function() {
                    gradeStore.load({
                    params: {
                        mineral:Ext.getCmp('mineralComboId').getValue()
                    }
                });
                if(Ext.getCmp('mineralComboId').getValue() == 'Fe'){
                Ext.getCmp('typeComboId').show();
                Ext.getCmp('typeEmptyId1').show();
                Ext.getCmp('typeoLabelId').show();
                Ext.getCmp('typeComboId1').hide();
                Ext.getCmp('typeEmptyId2').hide();
                Ext.getCmp('typeoLabelId2').hide();
                }else{
                Ext.getCmp('typeComboId').hide();
                Ext.getCmp('typeEmptyId1').hide();
                Ext.getCmp('typeoLabelId').hide();
                Ext.getCmp('typeComboId1').show();
                Ext.getCmp('typeEmptyId2').show();
                Ext.getCmp('typeoLabelId2').show();
                }
                Ext.getCmp('typeComboId').reset();
                Ext.getCmp('typeComboId1').reset();
                Ext.getCmp('gradeComboId').reset();
           }
        }
        }
   });
   
   //*******************************combo for grade
   var gradeStore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/MiningGradeMasterAction.do?param=getGrade',
       id: 'gradeCodeStoreId',
       root: 'gradeRoot',
       autoLoad: false,
       remoteSort: true,
       fields: ['gradesIndex']
   });

var gradeCombo = new Ext.form.ComboBox({
       store: gradeStore,
       id: 'gradeComboId',
       mode: 'local',
       forceSelection: true,
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       lazyRender: true,
       width:205,
       emptyText: '<%=EnterGrade%>',
       resizable: true,
       valueField: 'gradesIndex',
       displayField: 'gradesIndex',
       cls: 'selectstylePerfectnew',
       listeners: {
        select: {
               fn: function() {
               }
           }
        }
   });

  var monthComboStore = new Ext.data.SimpleStore({
    id: 'monthComboStoreId',
    autoLoad: true,
    fields: ['Name','Value'],
    data: [
        ['January','January'],
        ['February','February'],
        ['March','March'],
        ['April','April'],
        ['May','May'],
        ['June','June'],
        ['July','July'],
        ['August','August'],
        ['September','September'],
        ['October', 'October'],
        ['November','November'],
        ['December','December']
    ]
});

var monthCombo= new Ext.form.ComboBox({
    store: monthComboStore,
    id: 'monthComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: '<%=SelectMonth%>',
    resizable: true,
    displayField: 'Name',
    cls: 'selectstylePerfectnew',
    resizable:true,
     height: 350
}); 
var typeComboStore1 = new Ext.data.SimpleStore({
    id: 'typeComboStoreId1',
    autoLoad: true,
    fields: ['Name','Value'],
    data: [
        ['NA','NA']
    ]
});

var typeCombo1= new Ext.form.ComboBox({
    store: typeComboStore1,
    id: 'typeComboId1',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    hidden:false,
    emptyText: '<%=EnterType%>' ,
    resizable: true,
    displayField: 'Name',
    cls: 'selectstylePerfectnew',
     height: 350,
     listeners: {
        select: {
               fn: function() {
                 outerPanelForGrid.show();
                    innerGradeStore.load({
				      params: {
				          CustID: Ext.getCmp('custcomboId').getValue(),
				          mineralCode: Ext.getCmp('mineralComboId').getValue(),
				          mineralType: Ext.getCmp('typeComboId').getValue()
				      }
				  });
               }
           }
        }
	});

var typeComboStore = new Ext.data.SimpleStore({
    id: 'typeComboStoreId',
    autoLoad: true,
    fields: ['Name','Value'],
    data: [
        ['Lumps','Lumps'],
        ['Fines','Fines'],
        ['ROM','ROM'],
        ['Concentrates','Concentrates'],
        ['Tailings','Tailings'],
        ['High Court','High Court']
    ]
});

var typeCombo= new Ext.form.ComboBox({
    store: typeComboStore,
    id: 'typeComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: '<%=EnterType%>' ,
    resizable: true,
    displayField: 'Name',
    cls: 'selectstylePerfectnew',
     height: 350,
     listeners: {
        select: {
               fn: function() {
                 outerPanelForGrid.show();
                    innerGradeStore.load({
				      params: {
				          CustID: Ext.getCmp('custcomboId').getValue(),
				          mineralCode: Ext.getCmp('mineralComboId').getValue(),
				          mineralType: Ext.getCmp('typeComboId').getValue()
				      }
				  });
               }
           }
        }
	});

var innerPanelForGridMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 313,
    width: 470,
    frame: true,
    id: 'innerPanelForGradeDetailsId',
    layout: 'table',
      resizable:true, 
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=GradeMasterDetails%>',
        cls: 'my-fieldset',
        collapsible: false,
        colspan: 3,
        id: 'GradeMasterDetailsid',
        width: 450,
        height:290,
        layout: 'table',
        layoutConfig: {
            columns: 3,
             tableAttrs: {
		            style: {
		                width: '88%'
		            }
        			}
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'monthEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Month%>' + ' :',
            cls: 'labelstylenew',
            id: 'monthLabelId',
            resizable:true
        },
        monthCombo,   
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'yearEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Year%>' + ' :',
            cls: 'labelstylenew',
            id: 'yearLabelId'
        },{
            xtype: 'numberfield',
            cls: 'selectstylePerfectnew',
            allowBlank: false,
            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
            blankText: '<%=EnterYear%>',
            emptyText: '<%=EnterYear%>',
            autoCreate: {//restricts user to 4 chars max, 
                   tag: "input",
                   maxlength: 4,
                   type: "text",
                   size: "4",
                   autocomplete: "off"
               },
            labelSeparator: '',
            allowBlank: false,
            id: 'yearId'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mineralCodeEmptyId1'
        },{
        	 xtype: 'label',
            text: '<%=MineralCode%>' + ' :',
            cls: 'labelstylenew',
            id: 'mineralCodeLabelId'
        }, 
        mineralCombo
        , {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'gradeEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Grade%>' + ' :',
            cls: 'labelstylenew',
            id: 'gradeLabelId'
        },
        gradeCombo
        , {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'rateEmptyId1'
        }, {
            xtype: 'label',
            text: ' IBM Rate' + ' :',
            cls: 'labelstylenew',
            id: 'rateLabelId'
        }, {
            xtype: 'numberfield',
            cls:'selectstylePerfectnew',
	    	blankText: '<%=EnterRate%>',
            emptyText: '<%=EnterRate%>',
            id: 'rateId',
            allowNegative: false,
            listeners:{ change: function(f, n, o){
             	f.setValue(Math.abs(n));
             	Ext.getCmp('rate1Id').setValue(Number(parseFloat(f.getValue() * 0.15)).toFixed(2));
             	Ext.getCmp('rate2Id').setValue(Number(parseFloat(f.getValue() * 0.10)).toFixed(2));  
             } },
            autoCreate: {//restricts user to 10 chars with decimals, 
                tag: "input",
                maxlength: 9,
                autocomplete: "off"
             },
            allowDecimal:true
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'rate1EmptyId1'
        }, {
            xtype: 'label',
            text: 'Royalty Rate(15%)' + ' :',
            cls: 'labelstylenew',
            id: 'rate1LabelId'
        }, {
            xtype: 'numberfield',
            cls:'selectstylePerfectnew',
	    	blankText: '<%=EnterRate%>',
            emptyText: '<%=EnterRate%>',
            id: 'rate1Id',
            readOnly: true
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'rate2EmptyId1'
        }, {
            xtype: 'label',
            text: 'GIOPF Rate(10%)' + ' :',
            cls: 'labelstylenew',
            id: 'rate2LabelId'
        }, {
            xtype: 'numberfield',
            cls:'selectstylePerfectnew',
	    	blankText: '<%=EnterRate%>',
            emptyText: '<%=EnterRate%>',
            id: 'rate2Id',
            readOnly: true
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'typeEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Type%>' + ' :',
            cls: 'labelstylenew',
            id: 'typeoLabelId'
        },typeCombo
        , {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            hidden:false,
            id: 'typeEmptyId2'
        }, {
            xtype: 'label',
            text: '<%=Type%>' + ' :',
            cls: 'labelstylenew',
            hidden:false,
            id: 'typeoLabelId2'
        },typeCombo1]
    }]
});

//************************Grade and Rate grid********************************//
    var ReaderForGrade = new Ext.data.JsonReader({
        idProperty: 'gradeRootId',
        root: 'gradeRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNOIndex'
        }, {
            name: 'gradeIndex'
        }, {
            name: 'rateIndex'
        }]
    });
    var gradeFilters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'int',
            dataIndex: 'SLNOIndex'
        }, {
            type: 'string',
            dataIndex: 'gradeIndex'
        }, {
            type: 'int',
            dataIndex: 'rateIndex',
        }]
    });

    var columnModel2 = new Ext.grid.ColumnModel({
        columns: [new Ext.grid.RowNumberer({
	            header : "<span style=font-weight:bold;>SLNO</span>",
	            dataIndex: 'SLNOIndex',
	            width : 50
	        }),{
            header: "<span style=font-weight:bold;>SLNO</span>",
            dataIndex: 'SLNOIndex',
            hidden: true,
            width: 40
        }, {
            header: "<span style=font-weight:bold;>Grade</span>",
            sortable: false,
            hidden: false,
            width: 140,
            dataIndex: 'gradeIndex'
        }, {
            header: "<span style=font-weight:bold;>IBM Rate</span>",
            sortable: false,
            align: 'right',
            width: 80,
            dataIndex: 'rateIndex',
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                decimalPrecision: 2,
                autoCreate: {//restricts user to 10 chars with decimals, 
                tag: "input",
                maxlength: 9,
                autocomplete: "off"
             	},
                allowNegative: false,
                listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
            }))

        }, {
            header: "<span style=font-weight:bold;>Royalty Rate(15%)</span>",
            sortable: false,
            align: 'right',
            width: 133,
            dataIndex: 'rateIndex1',
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                readOnly:true
            }))

        }, {
            header: "<span style=font-weight:bold;>GIOPF Rate(10%)</span>",
            sortable: false,
            align: 'right',
            width: 125,
            dataIndex: 'rateIndex2',
            editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                readOnly:true
            }))

        }]
    });
    var innerGradeStore = new Ext.data.GroupingStore({
        autoLoad: false,
        remoteSort: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MiningGradeMasterAction.do?param=getGridData',
            method: 'POST'
        }),
        reader: ReaderForGrade
    });
    var selModel2 = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });
    var gradeplant = Ext.data.Record.create([{
        name: 'SLNOIndex'
    }, {
        name: 'gradeIndex'
    }, {
        name: 'rateIndex'
    }]);
    var outerPanelForGrid = new Ext.grid.EditorGridPanel({
        title: 'Details',
        layout: 'fit',
        stripeRows: true,
        height: 300,
        width: 545,
        autoScroll: true,
        hidden: true,
        border: false,
        store: innerGradeStore,
        id: 'othersgridId',
        colModel: columnModel2,
        sm: selModel2,
        plugins: [gradeFilters],
        clicksToEdit: 1
    });
    outerPanelForGrid.on({
        afteredit: function(e) {
            var field = e.field;
            var slno = e.record.data['SLNOIndex'];
            var temp = editedRowsForGrid.split(",");
            var isIn = 0;
            for (var i = 0; i < temp.length; i++) {
                if (temp[i] == slno) {
                    isIn = 1
                }
            }
            if (isIn == 0) {
                editedRowsForGrid = editedRowsForGrid + slno + ",";
            }
            
            editedRate=e.record.data['rateIndex'];
            e.record.set('rateIndex1',  Number(parseFloat(editedRate * 0.15)).toFixed(2));
            e.record.set('rateIndex2',  Number(parseFloat(editedRate * 0.10)).toFixed(2));
        }
    });
    var gridPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 313,
        width: 560,
        frame: true,
        id: 'addPanelInfo',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [outerPanelForGrid]
    });
    var caseInnerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 330,
        width: 1050,
        frame: true,
        id: 'addCaseInfo',
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [innerPanelForGridMasterDetails, gridPanel]
    });
    
    //********************* win button panel***************************//
var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 50,
    width: 1000,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                    Ext.example.msg("<%=SelectCustomer%>");
                    return;
                    }
                    if (Ext.getCmp('monthComboId').getValue() == "") {
                   			 Ext.example.msg("<%=SelectMonth%>");
             	   			 Ext.getCmp('monthComboId').focus();
                   			 return;
                    	}
                    	var pattern = /[0-9]{4}$/;
                      	if (!pattern.test(Ext.getCmp('yearId').getValue())) {
                          Ext.example.msg("Enter A Valid Year");
                          Ext.getCmp('yearId').focus();
                          return;
                      	}
                    	 if (Ext.getCmp('mineralComboId').getValue() == "") {
                   			 Ext.example.msg("<%=SelectMineralCode%>");
             	   			 Ext.getCmp('mineralComboId').focus();
                   			 return;
                    	}
                    if(Ext.getCmp('mineralComboId').getValue() == 'Fe'){
                    	  if (Ext.getCmp('typeComboId').getValue() == "") {
                   			 Ext.example.msg("<%=EnterType%>");
             	   			 Ext.getCmp('typeComboId').focus();
                   			 return;
                    	   }
                    	}
                    else {
                    	if (Ext.getCmp('typeComboId1').getValue() == "") {
                   			 Ext.example.msg("<%=EnterType%>");
             	   			 Ext.getCmp('typeComboId1').focus();
                   			 return;
                    	}
                    	}
                    	if (Ext.getCmp('mineralComboId').getValue() == "Fe") {
						    var tempValue = editedRowsForGrid;
						    var finalJSON = '';
						    if (tempValue == "" && buttonValue == '<%=Add%>') {
						        Ext.example.msg("Please Enter Rate");
						        return;
						    }
						    if(buttonValue == '<%=Add%>'){
						    for(var j = 1; j < 7; j++){
						       var rowVFe = outerPanelForGrid.store.find('SLNOIndex', j);
						       
						       if (rowVFe == -1) {
                                    continue;
                                }
                                var storeVFe = outerPanelForGrid.store.getAt(rowVFe);
                                if (Ext.getCmp('typeComboId').getValue() == "Tailings") {
                                	var pattern = /^[0-9][0-9\s]*/;
                      				if (!pattern.test(storeVFe.data['rateIndex'])||(j==1&&storeVFe.data['rateIndex'] == "0")) {
	                                    Ext.example.msg("Please Enter Rate For "+storeVFe.data['gradeIndex']);
	                                    outerPanelForGrid.startEditing(rowVFe, 3);
	                                    return;
                                	}
                                }else{
	                                if (storeVFe.data['rateIndex'] == "" || storeVFe.data['rateIndex'] == "0") {
	                                    Ext.example.msg("Please Enter Rate For "+storeVFe.data['gradeIndex']);
	                                    outerPanelForGrid.startEditing(rowVFe, 3);
	                                    return;
	                                }
                                }
						    }
						    }else if(buttonValue == '<%=Modify%>'){
						    if (Ext.getCmp('rateId').getValue() == "") {
	                   			 Ext.example.msg("<%=EnterRate%>");
	             	   			 Ext.getCmp('rateId').focus();
	                   			 return;
								}
							}
						    var tempForGrid = tempValue.split(",");
						    for (var i = 0; i < tempForGrid.length; i++) {
						        var row1 = outerPanelForGrid.store.find('SLNOIndex', tempForGrid[i]);
						        if (row1 == -1) {
						            continue;
						        }
						        var store1 = outerPanelForGrid.store.getAt(row1);
                                finalJSON += Ext.util.JSON.encode(store1.data) + ',';
                                }
                            if (finalJSON != '') {
                                finalJSON = finalJSON.substring(0, finalJSON.length - 1);
                            }
                            }
                            else if (Ext.getCmp('mineralComboId').getValue() != "Fe") {
						    var tempValue = editedRowsForGrid;
						    var finalJSON = '';
						    if (tempValue == "" && buttonValue == '<%=Add%>') {
						        Ext.example.msg("Please Enter Rate");
						        return;
						    }
						    if(buttonValue == '<%=Add%>'){
						    for(var j = 1; j < 6; j++){
						       var rowVOther = outerPanelForGrid.store.find('SLNOIndex', j);
						       
						       if (rowVOther == -1) {
                                    continue;
                                }
                                var storeVOther = outerPanelForGrid.store.getAt(rowVOther);
                                if (storeVOther.data['rateIndex'] == "" || storeVOther.data['rateIndex'] == "0") {
                                    Ext.example.msg("Please Enter Rate For "+storeVOther.data['gradeIndex']);
                                    outerPanelForGrid.startEditing(rowVOther, 3);
                                    return;
                                }
						    }
						    }else if(buttonValue == '<%=Modify%>'){
						    if (Ext.getCmp('rateId').getValue() == "") {
	                   			 Ext.example.msg("<%=EnterRate%>");
	             	   			 Ext.getCmp('rateId').focus();
	                   			 return;
								}
							}
						    var tempForGrid = tempValue.split(",");
						    for (var i = 0; i < tempForGrid.length; i++) {
						        var row1 = outerPanelForGrid.store.find('SLNOIndex', tempForGrid[i]);
						        if (row1 == -1) {
						            continue;
						        }
						        var store1 = outerPanelForGrid.store.getAt(row1);
                                finalJSON += Ext.util.JSON.encode(store1.data) + ',';
                                }
                            if (finalJSON != '') {
                                finalJSON = finalJSON.substring(0, finalJSON.length - 1);
                            }
                            }
                        var id;
                        if (buttonValue == '<%=Modify%>') {
                            var selected = grid.getSelectionModel().getSelected();
                             id = selected.get('IdDataIndex');
                        }
                        GradeMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/MiningGradeMasterAction.do?param=gradeMasterAddModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                CustName: Ext.getCmp('custcomboId').getRawValue(),
                                month: Ext.getCmp('monthComboId').getValue(),
                                year: Ext.getCmp('yearId').getValue(),
                                grade: Ext.getCmp('gradeComboId').getValue(),
                                rate: Ext.getCmp('rateId').getValue(),
                                mineral: Ext.getCmp('mineralComboId').getValue(),
                                type: Ext.getCmp('typeComboId').getValue(),
                                type1: Ext.getCmp('typeComboId1').getValue(),
                                id: id,
                                json:finalJSON,
                                jspName: jspName
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('monthComboId').reset();
                                Ext.getCmp('yearId').reset();
                                Ext.getCmp('gradeComboId').reset();
                                Ext.getCmp('rateId').reset();
                                Ext.getCmp('mineralComboId').reset();
                                Ext.getCmp('typeComboId').reset();
                                myWin.hide();
                                store.reload();
                                GradeMasterOuterPanelWindow.getEl().unmask();
                                innerGradeStore.removeAll();
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

var GradeMasterOuterPanelWindow = new Ext.Panel({
    width: 1060,
    height:400,
    standardSubmit: true,
    frame: true,
    items: [caseInnerPanel, innerWinButtonPanel]
});

myWin = new Ext.Window({
    //title: 'titelForInnerPanel',
    closable: false,
    resizable: true,
    modal: true,
    autoScroll: false,
    height: 450,
    width: 1070,
    id: 'myWin',
    frame: true,
    items: [GradeMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
    Ext.example.msg("<%=SelectCustomer%>");
    return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddDetails%>';
    myWin.setPosition(175, 50);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('monthComboId').reset();
    Ext.getCmp('yearId').reset();
    Ext.getCmp('gradeComboId').reset();
    Ext.getCmp('mineralComboId').reset();
    Ext.getCmp('typeComboId').reset();
    Ext.getCmp('typeComboId').show();
    Ext.getCmp('typeEmptyId1').show();
    Ext.getCmp('typeoLabelId').show();
    Ext.getCmp('gradeComboId').hide();
    Ext.getCmp('gradeEmptyId1').hide();
    Ext.getCmp('gradeLabelId').hide();
    Ext.getCmp('rateId').hide();
    Ext.getCmp('rateEmptyId1').hide();
    Ext.getCmp('rateLabelId').hide();
    Ext.getCmp('rate1Id').hide();
    Ext.getCmp('rate1EmptyId1').hide();
    Ext.getCmp('rate1LabelId').hide();
    Ext.getCmp('rate2Id').hide();
    Ext.getCmp('rate2EmptyId1').hide();
    Ext.getCmp('rate2LabelId').hide();
    
    Ext.getCmp('typeComboId1').hide();
    Ext.getCmp('typeEmptyId2').hide();
    Ext.getCmp('typeoLabelId2').hide();
    
    innerGradeStore.removeAll();
  //outerPanelForGrid.show();
  gridPanel.show();
    caseInnerPanel.setWidth(1050);
    GradeMasterOuterPanelWindow.setWidth(1060);
    myWin.setWidth(1070);
    innerWinButtonPanel.setWidth(1050);
outerPanelForGrid.hide();
Ext.getCmp('mineralComboId').setReadOnly(false);
Ext.getCmp('gradeComboId').setReadOnly(false);
}

function modifyData() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
	    Ext.example.msg("<%=SelectCustomer%>");
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
    titelForInnerPanel = '<%=Modify%>';
    myWin.setPosition(450, 50);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    Ext.getCmp('monthComboId').show();
    Ext.getCmp('yearId').show();
    Ext.getCmp('gradeComboId').show();
    Ext.getCmp('rateId').show();
    Ext.getCmp('mineralComboId').show();
    Ext.getCmp('gradeEmptyId1').show();
    Ext.getCmp('gradeLabelId').show();
    Ext.getCmp('rateEmptyId1').show();
    Ext.getCmp('rateLabelId').show();
    Ext.getCmp('rate1Id').show();
    Ext.getCmp('rate1EmptyId1').show();
    Ext.getCmp('rate1LabelId').show();
    Ext.getCmp('rate2Id').show();
    Ext.getCmp('rate2EmptyId1').show();
    Ext.getCmp('rate2LabelId').show();
    
    var selected = grid.getSelectionModel().getSelected();
    var mineral=selected.get('mineralCodeDataIndex');
    Ext.getCmp('monthComboId').setValue(selected.get('monthDataIndex'));
    Ext.getCmp('yearId').setValue(selected.get('yearDataIndex'));
    Ext.getCmp('gradeComboId').setValue(selected.get('gradeDataIndex'));
    Ext.getCmp('rateId').setValue(selected.get('rateDataIndex'));
    Ext.getCmp('rate1Id').setValue(selected.get('rate1DataIndex'));
    Ext.getCmp('rate2Id').setValue(selected.get('rate2DataIndex'));
    Ext.getCmp('mineralComboId').setValue(selected.get('mineralCodeDataIndex'));
    Ext.getCmp('typeComboId').setValue(selected.get('typeDataIndex'));
    Ext.getCmp('typeComboId1').setValue(selected.get('typeDataIndex'));
    gradeStore.load({
                    params: {
                        mineral:mineral
                    }
                });
     if(selected.get('mineralCodeDataIndex') == 'Fe'){
    Ext.getCmp('typeComboId').show();
    Ext.getCmp('typeEmptyId1').show();
    Ext.getCmp('typeoLabelId').show();
    Ext.getCmp('typeComboId1').hide();
    Ext.getCmp('typeEmptyId2').hide();
    Ext.getCmp('typeoLabelId2').hide();
    }else{
    Ext.getCmp('typeComboId1').show();
    Ext.getCmp('typeEmptyId2').show();
    Ext.getCmp('typeoLabelId2').show();
    Ext.getCmp('typeComboId').hide();
    Ext.getCmp('typeEmptyId1').hide();
    Ext.getCmp('typeoLabelId').hide();
    }
    outerPanelForGrid.hide();
    gridPanel.hide();
    caseInnerPanel.setWidth(505);
    GradeMasterOuterPanelWindow.setWidth(530);
    myWin.setWidth(530);
    innerWinButtonPanel.setWidth(505);
    Ext.getCmp('mineralComboId').setReadOnly(true);
    Ext.getCmp('gradeComboId').setReadOnly(true);
}
 //***************************************************************************************//
   var reader = new Ext.data.JsonReader({
       idProperty: 'GradeMasterDetails',
       root: 'getGradeMasterDetails',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'monthDataIndex'
	   }, {
           name: 'yearDataIndex'
       }, {
           name: 'gradeDataIndex'
       }, {
           name: 'rateDataIndex'
       }, {
           name: 'rate1DataIndex'
       }, {
           name: 'rate2DataIndex'
       }, {
           name: 'mineralCodeDataIndex'
       },{
           name: 'typeDataIndex'
       },{
           name: 'IdDataIndex'
       }]
   });
   
   var store = new Ext.data.GroupingStore({
       autoLoad: false,
       proxy: new Ext.data.HttpProxy({
           url: '<%=request.getContextPath()%>/MiningGradeMasterAction.do?param=getGradeMasterDetails',
           method: 'POST'
       }),
       remoteSort: false,
       storeId: 'GradeMasterDetails',
       reader: reader
   });
   
   var filters = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           type: 'string',
           dataIndex: 'monthDataIndex'
       }, {
           type: 'int',
           dataIndex: 'yearDataIndex'
       }, {
           type: 'string',
           dataIndex: 'gradeDataIndex'
       }, {
           type: 'numeric',
           dataIndex: 'rateDataIndex'
       }, {
           type: 'numeric',
           dataIndex: 'rate1DataIndex'
       }, {
           type: 'numeric',
           dataIndex: 'rate2DataIndex'
       }, {
           type: 'string',
           dataIndex: 'typeDataIndex'
       }, {
           type: 'int',
           dataIndex: 'IdDataIndex'
       }, {	
       		type :'string',
       		dataIndex:'mineralCodeDataIndex'
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
               width: 50
           }, {
               header: "<span style=font-weight:bold;><%=Month%></span>",
               dataIndex: 'monthDataIndex',
               width: 80
           }, {
               header: "<span style=font-weight:bold;><%=Year%></span>",
               dataIndex: 'yearDataIndex',
               width: 80
           }, {
               header: "<span style=font-weight:bold;><%=Grade%></span>",
               dataIndex: 'gradeDataIndex',
               width: 80
           }, {
               header: "<span style=font-weight:bold;>IBM Rate</span>",
               dataIndex: 'rateDataIndex',
               align: 'right',
               width: 80
           }, {
               header: "<span style=font-weight:bold;>Royalty Rate (15%)</span>",
               dataIndex: 'rate1DataIndex',
               align: 'right',
               width: 80
           }, {
               header: "<span style=font-weight:bold;>GIOPF Rate (10%)</span>",
               dataIndex: 'rate2DataIndex',
               align: 'right',
               width: 80,
           },  {
               header: "<span style=font-weight:bold;><%=MineralCode%></span>",
               dataIndex: 'mineralCodeDataIndex',
               width: 80
           }, {
               header: "<span style=font-weight:bold;><%=Type%></span>",
               dataIndex: 'typeDataIndex',
               width: 80
           }, {
               header: "<span style=font-weight:bold;>ID</span>",
               dataIndex: 'IdDataIndex',
               width: 50,
               hidden: true
           }
       ];
       return new Ext.grid.ColumnModel({
           columns: columns.slice(start || 0, finish),
           defaults: {
               sortable: true
           }
       });
   };

  grid = getGrid('<%=GradeMasterDetails%>', '<%=NoRecordsFound%>', store, screen.width-40,460, 21, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');
 
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel, grid]
        //bbar: ctsb
    });
    sb = Ext.getCmp('form-statusbar');
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 <script> 
	  if (innerpage == true) {
				
				
				var divsToHide = document.getElementsByClassName("footer"); //divsToHide is an array
				
					for(var i = 0; i < divsToHide.length; i++){
						divsToHide[i].style.display = "none"; // depending on what you're doing
						$(".container").css({"margin-top":"-72px"});
					}
			}
			
			</script>
<%}%>
<%}%>