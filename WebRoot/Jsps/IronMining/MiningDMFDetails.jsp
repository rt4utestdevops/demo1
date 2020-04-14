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
		if(str.length>11){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
			session.setAttribute("loginInfoDetails", loginInfo);
		}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
		
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");

tobeConverted.add("SLNO");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Add_Details");
tobeConverted.add("Modify_Details");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");

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
String SelectSingleRow=convertedWords.get(8);
String AddDetails=convertedWords.get(9);
String ModifyDetails=convertedWords.get(10);
String SelectCustomer=convertedWords.get(11);
String CustomerName=convertedWords.get(12);

int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	
if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title>Mining DMF Details</title>
	
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
		 <style>
			.x-panel-header
			{
				height: 7% !important;
			}		
			.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
				height: 26px !important;
				padding-top: 8px;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			}
			label {
				display : inline !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}	
			div#myWin {
				top : 51px !important;
			}
		</style>
 
<script>
    var outerPanel;
    var jspName = "Mining DMF Details";
    var exportDataType = "int,string,number,number,number,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
    var grid;
    var myWin;
    var buttonValue;
    var orgCode;
    var orgName;
    var selected;
    var newRowAdded = 0;
    var editedRows = "";
    var datenext1= nextDate;

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
                if (<%= customerId %> > 0) {
                    Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                    custId = Ext.getCmp('custcomboId').getValue();
                    store.load({
                       params: {
                           CustId: custId,
                           jspName: jspName,
                           CustName: Ext.getCmp('custcomboId').getRawValue(),
                           endDate: Ext.getCmp('enddate').getValue(),
               			   startDate: Ext.getCmp('startdate').getValue()
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
        emptyText: '<%=SelectCustomer%>',
        resizable: true,
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
                     store.load({
                       params: {
                           CustId: custId,
                           jspName: jspName,
                           CustName: Ext.getCmp('custcomboId').getRawValue(),
                           endDate: Ext.getCmp('enddate').getValue(),
               			   startDate: Ext.getCmp('startdate').getValue()
                       }
                   });
                }
            }
        }
    });
    var dmfMonthVaildStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/MiningDMFAction.do?param=getMonthValidation',
        root: 'dmfValidRoot',
        autoLoad: false,
		fields:['flag']
    });
    
    var dmfAmtStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/MiningDMFAction.do?param=getDMFAmount',
        root: 'dmfAmtRoot',
        autoLoad: false,
        fields: ['NDMF','SDMF','FYEAR','BAL_NDMF','BAL_SDMF','TOTAL_ROYALTY']
    });
    //*************************************************Client Panel**************************************************************//
    var clientPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'clientPanelId',
        layout: 'table',
        frame: false,
        width: screen.width - 60,
        height: 50,
        layoutConfig: {
            columns: 13
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + ' :',
                cls: 'labelstyle',
                id: 'ltspcomboId'
            },
            custnamecombo, {
                 width: 10
            }, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'startdatelab',
                width: 200,
                text: 'Start Date' + ' :'
            }, {
                width: 10
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 120,
                format: getDateFormat(),
                emptyText: 'Select Start Date',
                allowBlank: false,
                blankText: 'Select Start Date',
                id: 'startdate',
                value: currentDate
            }, {
                width: 10
            }, {
                xtype: 'label',
                cls: 'labelstyle',
                id: 'enddatelab',
                width: 200,
                text: 'End Date' + ' :'
            }, {
                width: 10
            }, {
                xtype: 'datefield',
                cls: 'selectstylePerfect',
                width: 160,
                format: getDateFormat(),
                emptyText: 'Select End Date',
                allowBlank: false,
                blankText: 'Select End Date',
                id: 'enddate',
                value: datenext1
            }, {
                width: 20
            }, {
                xtype: 'button',
                text: 'View',
                id: 'submitId',
                cls: 'buttonStyle',
                width: 60,
                handler: function() {
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
                    var dateDifrnc = new Date(Enddates).add(Date.DAY, -31);
                    if (Startdates < dateDifrnc) {
                        Ext.example.msg("Difference between two dates should not be  greater than 31 days.");
                        Ext.getCmp('startdate').focus();
                        return;
                    }
                    store.load({
                       params: {
                           CustId: custId,
                           jspName: jspName,
                           CustName: Ext.getCmp('custcomboId').getRawValue(),
                           endDate: Ext.getCmp('enddate').getValue(),
			               startDate: Ext.getCmp('startdate').getValue()
                       }
                   });
                }
            }
        ]
    });
    var dmfReader = new Ext.data.JsonReader({
        idProperty: 'dmfRootId',
        root: 'dmfRoot',
        totalProperty: 'total',
        fields: [{
            name: 'SLNOIndex'
        }, {
            name: 'typeIndex'
        }, {
            name: 'northDmfIndex'
        }, {
            name: 'southDmfIndex'
        }]
    });
    var dmfFilters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'int',
            dataIndex: 'SLNOIndex'
        }, {
            type: 'string',
            dataIndex: 'typeIndex'
        }, {
            type: 'numeric',
            dataIndex: 'northDmfIndex',
        }, {
            type: 'numeric',
            dataIndex: 'southDmfIndex',
        }]
    });
    var dmfColModel = new Ext.grid.ColumnModel({
        columns: [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;>SlNo</span>",
                dataIndex: 'SLNOIndex',
                width: 50
            }), {
                header: "<span style=font-weight:bold;>SlNo</span>",
                width: 30,
                hidden: true,
                dataIndex: 'SLNOIndex'
            }, {
                header: "<span style=font-weight:bold;>Field Value</span>",
                sortable: true,
                dataIndex: 'typeIndex',
                width: 200
                //editor: new Ext.grid.GridEditor(new Ext.form.TextField({}))
            }, {
                header: "<span style=font-weight:bold;>North DMF</span>",
                sortable: true,
                dataIndex: 'northDmfIndex',
                width: 130,
                editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                    allowNegative: false
                    //allowDecimals: false
                }))
            }, {
                header: "<span style=font-weight:bold;>South DMF</span>",
                sortable: true,
                dataIndex: 'southDmfIndex',
                width: 130,
                editor: new Ext.grid.GridEditor(new Ext.form.NumberField({
                    allowNegative: false
                    //allowDecimals: false
                }))
            }
        ]
    });
    var DMFStore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MiningDMFAction.do?param=getDMFfieldValues',
            method: 'POST'
        }),
        reader: dmfReader
    });
    var dmfPlant = Ext.data.Record.create([{
            name: 'SLNOIndex'
        }, {
            name: 'typeIndex'
        }, {
            name: 'northDmfIndex'
        }, {
            name: 'southDmfIndex'
        }]
        );
    var selModDel = new Ext.grid.RowSelectionModel({
        singleSelect: true
    });
    var DMFGrid = new Ext.grid.EditorGridPanel({
        height: 300,
        width: screen.width - 830,
        autoScroll: true,
        border: false,
        store: DMFStore,
        id: 'GridId',
        cm: dmfColModel,
        sm: selModDel,
        plugins: dmfFilters,
        clicksToEdit: 1
    });
    DMFGrid.on({
        afteredit: function(e) {
            var field = e.field;
            var slno = e.record.data['SLNOIndex'];
            var temp = editedRows.split(",");
            var isIn = 0;
            for (var i = 0; i < temp.length; i++) {
                if (temp[i] == slno) {
                    isIn = 1
                }
            }
            if (isIn == 0) {
                editedRows = editedRows + slno + ",";
            }
        }
    });
    //******************************************Add and Modify function *********************************************************************//		

    var innerPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: '371px',
        width: 1180,
        frame: true,
        id: 'innerPanelId',
        layout: 'table',
        resizable: true,
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'fieldset',
            title: 'DMF Details',
            cls: 'my-fieldset',
            collapsible: false,
            autoScroll: true,
            colspan: 3,
            id: 'dmfDetailsid',
            width: 360,
            height: 362,
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
                    id: 'financialYearEmptyId'
                }, {
                    xtype: 'label',
                    text: 'Date' + '',
                    cls: 'labelstyle',
                    id: 'financialYearLabelId'
                }, {
                    xtype: 'datefield',
	                format: getDateFormat(),
	                enableKeyEvents : true,
	                cls: 'selectstylePerfect',
	                id: 'financialYearId',
	                resizable:true, 
	                mode: 'local',
	                forceSelection: false,
	                selectOnFocus: true,
	                autoScroll: true,
	                listeners: {
	                	 select: {
                        	fn: function(f,n,o) {
                        	
			              		DMFStore.load();
			           			fyear=Ext.getCmp('financialYearId').getValue();		           			
			           			dmfMonthVaildStore.load({
			                       params: {
			                           year:Ext.getCmp('financialYearId').getValue()
			                       }
			                   });
			           			//var recd = dmfMonthVaildStore.getAt(0);
			           			//if(recd.data['flag']=='true'){
			           			//Ext.getCmp('financialYearId').setValue('');
			           			// Ext.example.msg("Details already added for this month");
			           			//}
			                  //  Ext.getCmp('totalDmfId').setValue(rec.data['TOTAL_ROYALTY']);
			                   // Ext.getCmp('totalNDmfId').setValue(rec.data['NDMF']);
			                   // Ext.getCmp('totalSDmfId').setValue(rec.data['SDMF']);
			                   // Ext.getCmp('NDmfBalanceId').setValue(rec.data['BAL_NDMF']);
			                   // Ext.getCmp('SDmfBalanceId').setValue(rec.data['BAL_SDMF']);
	              			}
              			}
	              	}
                }, {
                    xtype: 'label',
                    text: '*',
                    cls: 'mandatoryfield',
                    id: 'dmfTEmptyId2'
                }, {
                    xtype: 'label',
                    text: 'Total DMF' + ' :',
                    cls: 'labelstyle',
                    id: 'totalDmfTLabelId'
                }, {
                    xtype: 'numberfield',
                    cls: 'selectstylePerfect',
                    id: 'totalDmfId',
                    allowBlank: false,
                    allowNegative: false,
                    anchor: '90%',
                    allowDecimals: true,
                    decimalPrecision:3
                   // readOnly: true
                }, {
                    xtype: 'label',
                    text: '',
                    cls: 'mandatoryfield',
                    id: 'dmfEmptyId2'
                }, {
                    xtype: 'label',
                    text: 'North DMF' + ' :',
                    cls: 'labelstyle',
                    id: 'totalDmfLabelId'
                }, {
                    xtype: 'numberfield',
                    cls: 'selectstylePerfect',
                    id: 'totalNDmfId',
                    allowBlank: false,
                    allowNegative: false,
                    anchor: '90%',
                    allowDecimals: true,
                    decimalPrecision:3
                    //readOnly: true
                }, {
                    xtype: 'label',
                    text: '',
                    cls: 'mandatoryfield',
                    id: 'BalEmptyId',
                    hidden: true
                }, {
                    xtype: 'label',
                    text: 'North DMF Bal' + ' :',
                    cls: 'labelstyle',
                    id: 'dmfBalLabelIds',
                     hidden: true
                }, {
                    xtype: 'numberfield',
                    cls: 'selectstylePerfect',
                    id: 'NDmfBalanceId',
                    allowBlank: false,
                    allowNegative: false,
                    anchor: '90%',
                    allowDecimals: true,
                    decimalPrecision:3,
                     hidden: true
                 //   readOnly: true
                },{
                    xtype: 'label',
                    text: '',
                    cls: 'mandatoryfield',
                    id: 'dmfEmptyId21'
                }, {
                    xtype: 'label',
                    text: 'South DMF' + ' :',
                    cls: 'labelstyle',
                    id: 'totalSDmfLabelId1'
                }, {
                    xtype: 'numberfield',
                    cls: 'selectstylePerfect',
                    id: 'totalSDmfId',
                    allowBlank: false,
                    allowNegative: false,
                    anchor: '90%',
                    allowDecimals: true,
                    decimalPrecision:3
                   // readOnly: true
                }, {
                    xtype: 'label',
                    text: '',
                    cls: 'mandatoryfield',
                    id: 'BalEmptyId1',
                     hidden: true
                }, {
                    xtype: 'label',
                    text: 'South DMF Bal' + ' :',
                    cls: 'labelstyle',
                    id: 'dmfBalLabelIds1',
                     hidden: true
                }, {
                    xtype: 'numberfield',
                    cls: 'selectstylePerfect',
                    id: 'SDmfBalanceId',
                    allowBlank: false,
                    allowNegative: false,
                    anchor: '90%',
                    allowDecimals: true,
                    decimalPrecision:3,
                     hidden: true
                    //readOnly: true
                }]
        }, {
            xtype: 'fieldset',
            title: 'DMF Details',
            cls: 'my-fieldset',
            collapsible: false,
            autoScroll: true,
            colspan: 3,
            id: 'dmfTableid',
            width: 600,
            height: 362,
            layout: 'table',
            layoutConfig: {
                columns: 3,
                tableAttrs: {
                    style: {
                        width: '88%'
                    }
                }
            },
            items: [DMFGrid]
        }]
    });

    var innerWinButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 90,
        width: 960,
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
            iconCls: 'savebutton',
            width: 70,
            listeners: {
                click: {
                    fn: function() {
                        var JSON = '';
                        if (Ext.getCmp('custcomboId').getValue() == "") {
                            Ext.example.msg("<%=SelectCustomer%>");
                            Ext.getCmp('custcomboId').focus();
                            return;
                        }
                        if (Ext.getCmp('financialYearId').getValue() == "") {
                            Ext.example.msg("Enter Date");
                            Ext.getCmp('financialYearId').focus();
                            return;
                        }
                      		var recd = dmfMonthVaildStore.getAt(0);
			           			 if(recd.data['flag']=='true'){
			           			 Ext.getCmp('financialYearId').setValue('');
			           			 Ext.example.msg("Details already added for this month");
			           			 Ext.getCmp('financialYearId').focus();
			           			 return;
			           			}
                       // if(Ext.getCmp('totalNDmfId').getValue()>Ext.getCmp('totalDmfId').getValue() ){
                      //   Ext.example.msg("North DMF should be less than Total DMF");
                      //      Ext.getCmp('totalNDmfId').focus();
                      //      return;
                       // }
                      //  if(Ext.getCmp('totalSDmfId').getValue()>Ext.getCmp('totalDmfId').getValue() ){
                       //  Ext.example.msg("South DMF should be less than Total DMF");
                       //     Ext.getCmp('totalSDmfId').focus();
                       //     return;
                       // }
                        var SumofNSDMF=Ext.getCmp('totalNDmfId').getValue()+Ext.getCmp('totalSDmfId').getValue();
                        
                        // if(SumofNSDMF > Ext.getCmp('totalDmfId').getValue() ){
                       //   Ext.example.msg("Sum of North DMF and South DMF should be less than Total DMF");
                       //     Ext.getCmp('totalSDmfId').focus();
                       //     return;
                        //}
                        var totalSDMF=0;
                        var totalNDMF=0;
                        if (editedRows == "") {
                            Ext.example.msg("Please Enter at least one row");
                            return;
                        }
                        var tempForGrid = editedRows.split(",");
                        for (var i = 0; i < tempForGrid.length; i++) {
                            var row = DMFGrid.store.find('SLNOIndex', tempForGrid[i]);
                            if (row == -1) {
                                continue;
                            }
                            var storer = DMFGrid.store.getAt(row);
                            if (storer.data['northDmfIndex'] == "" && storer.data['southDmfIndex'] == "") {
                                Ext.example.msg("Please Enter Either North DMF or South DMF");
                                return;
                            }
                            JSON += Ext.util.JSON.encode(storer.data) + ',';
                        }
                        var gridLen=DMFGrid.getStore().data.length;
                        for(var k=0;k<gridLen;k++){
                        	var record = DMFGrid.getStore().getAt(k);
                        	totalSDMF = totalSDMF + Number(record.data['southDmfIndex']);
                        	totalNDMF = totalNDMF + Number(record.data['northDmfIndex']);
                        }

                        if((Number(totalSDMF)>Number(Ext.getCmp('totalSDmfId').getValue())) || (Number(totalNDMF)>Number(Ext.getCmp('totalNDmfId').getValue()))){
                       	Ext.example.msg("Sum of Field DMF Values should be less than equal to DMF");
                            return;
                       }
                        if (JSON != '') {
                            JSON = JSON.substring(0, JSON.length - 1);
                        }
                        var id;
                        selected = grid.getSelectionModel().getSelected();
                        outerPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/MiningDMFAction.do?param=saveDMFDetails',
                            method: 'POST',
                            params: {
                                json: JSON,
                                date: Ext.getCmp('financialYearId').getValue(),
                                northdmf: Ext.getCmp('totalNDmfId').getValue(),
                                southdmf: Ext.getCmp('totalSDmfId').getValue(),
                                totaldmf: Ext.getCmp('totalDmfId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                console.log(message);
                                Ext.example.msg(message);
                                Ext.getCmp('financialYearId').reset();
                                Ext.getCmp('SDmfBalanceId').reset();
                                Ext.getCmp('NDmfBalanceId').reset();
                                Ext.getCmp('totalDmfId').reset();
                                Ext.getCmp('totalNDmfId').reset();
                                Ext.getCmp('totalSDmfId').reset();
                                myWin.hide();
                                store.load({
			                        params: {
			                            CustId: custId,
			                            jspName: jspName,
			                            CustName: Ext.getCmp('custcomboId').getRawValue(),
			                            endDate: Ext.getCmp('enddate').getValue(),
			                			startDate: Ext.getCmp('startdate').getValue()
			                        }
			                    });
                                outerPanelWindow.getEl().unmask();
                                newRowAdded = 0;
                                DMFStore.removeAll();
                                editedRows = "";
                            },
                            failure: function() {
                                Ext.example.msg("Error");
                                Ext.getCmp('financialYearId').reset();
                                Ext.getCmp('SDmfBalanceId').reset();
                                Ext.getCmp('NDmfBalanceId').reset();
                                Ext.getCmp('totalDmfId').reset();
                                Ext.getCmp('totalNDmfId').reset();
                                Ext.getCmp('totalSDmfId').reset();
                                store.load({
			                        params: {
			                            CustId: custId,
			                            jspName: jspName,
			                            CustName: Ext.getCmp('custcomboId').getRawValue(),
			                            endDate: Ext.getCmp('enddate').getValue(),
			                			startDate: Ext.getCmp('startdate').getValue()
			                        }
			                    });
                                myWin.hide();
                                newRowAdded = 0;
                                DMFStore.removeAll();
                                editedRows = "";
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
                    fn: function() {
                        myWin.hide();
                        newRowAdded = 0;
                        DMFStore.removeAll();
                        editedRows = "";
                    }
                }
            }
        }]
    });

    var outerPanelWindow = new Ext.Panel({
        width: 970,
        height: 500,
        standardSubmit: true,
        frame: true,
        items: [innerPanel, innerWinButtonPanel]
    });

    myWin = new Ext.Window({
        title: 'titelForInnerPanel',
        closable: false,
        resizable: false,
        modal: true,
        autoScroll: false,
        height: 500,
        width: 970,
        frame: true,
        id: 'myWin',
        items: [outerPanelWindow]
    });
    function addRecord() {
        Ext.getCmp('financialYearId').reset();
        Ext.getCmp('SDmfBalanceId').reset();
        Ext.getCmp('NDmfBalanceId').reset();
        Ext.getCmp('totalDmfId').reset();
        Ext.getCmp('totalNDmfId').reset();
        Ext.getCmp('totalSDmfId').reset();
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("<%=SelectCustomer%>");
            Ext.getCmp('custcomboId').focus();
            return;
        }
        dmfAmtStore.load();
        buttonValue = '<%=Add%>';
        titelForInnerPanel = '<%=AddDetails%>';
        myWin.setPosition(140, 30);
        myWin.show();
        myWin.setTitle(titelForInnerPanel);
    }
    //***************************************************************************************//
    var reader = new Ext.data.JsonReader({
        idProperty: 'DMFMasterDetails',
        root: 'DMFMasterRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'uid'
        }, {
            name: 'financialYearIndex'
        }, {
            name: 'fieldValuesIndex'
        }, {
            name: 'southDMFIndex'
        }, {
            name: 'northDMFIndex'
        }, {
            name: 'DMFIndex'
        }, {
            name: 'cfvalueIndex'
        }, {
            name: 'totalDMFIndex'
        },{
            name: 'ENDIndex'
        }, {
            name: 'ESDIndex'
        }, {
            name: 'INDIndex'
        }, {
            name: 'ISDIndex'
        }, {
            name: 'ANDIndex'
        }, {
            name: 'ASDIndex'
        }, {
            name: 'DWNDIndex'
        }, {
            name: 'DWSDIndex'
        },{
            name: 'EleNDIndex'
        }, {
            name: 'EleSDIndex'
        }, {
            name: 'EnvNDIndex'
        }, {
            name: 'EnvSDIndex'
        }, {
            name: 'HCNDIndex'
        }, {
            name: 'HCSDIndex'
        }, {
            name: 'HNDIndex'
        }, {
            name: 'HSDIndex'
        }, {
            name: 'IrrNDIndex'
        }, {
            name: 'IrrSDIndex'
        }, {
            name: 'SanNDIndex'
        }, {
            name: 'SanSDIndex'
        }, {
            name: 'SDNDIndex'
        },{
            name: 'SDSDIndex'
        }, {
            name: 'SportNDIndex'
        }, {
            name: 'SportSDIndex'
        }]
    });

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/MiningDMFAction.do?param=getDMFDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'dmfStoreId',
        reader: reader
    });

    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'financialYearIndex'
        }, {
            type: 'string',
            dataIndex: 'fieldValuesIndex'
        }, {
            type: 'numeric',
            dataIndex: 'southDMFIndex'
        }, {
            type: 'numeric',
            dataIndex: 'northDMFIndex'
        },{
            type: 'numeric',
            dataIndex: 'DMFIndex'
        }, {
            type: 'numeric',
            dataIndex: 'cfvalueIndex'
        }, {
            type: 'numeric',
            dataIndex: 'totalDMFIndex'
        }, {
            type: 'numeric',
            dataIndex: 'ENDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'ESDIndex'
        },{
            type: 'numeric',
            dataIndex: 'INDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'ISDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'ANDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'ASDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'DWNDIndex'
        },{
            type: 'numeric',
            dataIndex: 'DWSDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'EleNDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'EleSDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'EnvNDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'EnvSDIndex'
        },{
            type: 'numeric',
            dataIndex: 'HCNDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'HCSDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'HNDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'HSDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'IrrNDIndex'
        },{
            type: 'numeric',
            dataIndex: 'IrrSDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'SanNDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'SanSDIndex'
        },{
            type: 'numeric',
            dataIndex: 'SDNDIndex'
        },{
            type: 'numeric',
            dataIndex: 'SDSDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'SportNDIndex'
        }, {
            type: 'numeric',
            dataIndex: 'SportSDIndex'
        }
        ]
    });

    var createColModel = function(finish, start) {
        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                width: 50,
                header: "<span style=font-weight:bold;><%=SLNO%></span>"
            }, {
                header: "<span style=font-weight:bold;>Date</span>",
                dataIndex: 'financialYearIndex',
                hidden: false,
                width: 80
            }, {
                header: "<span style=font-weight:bold;>North DMF</span>",
                dataIndex: 'northDMFIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>South DMF</span>",
                dataIndex: 'southDMFIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Total DMF</span>",
                dataIndex: 'DMFIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Education North DMF</span>",
                dataIndex: 'ENDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Education South DMF</span>",
                dataIndex: 'ESDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Infrastructure North DMF</span>",
                dataIndex: 'INDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Infrastructure South DMF</span>",
                dataIndex: 'ISDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Afforestation North DMF</span>",
                dataIndex: 'ANDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Afforestation South DMF</span>",
                dataIndex: 'ASDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Drinking Water North DMF</span>",
                dataIndex: 'DWNDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Drinking Water South DMF</span>",
                dataIndex: 'DWSDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Electrification North DMF</span>",
                dataIndex: 'EleNDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Electrification South DMF</span>",
                dataIndex: 'EleSDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Environment North DMF</span>",
                dataIndex: 'EnvNDIndex', 
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Environment South DMF</span>",
                dataIndex: 'EnvSDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Health Care North DMF</span>",
                dataIndex: 'HCNDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Health Care South DMF</span>",
                dataIndex: 'HCSDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Housing North DMF</span>",
                dataIndex: 'HNDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Housing South DMF</span>",
                dataIndex: 'HSDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Irrigation North DMF</span>",
                dataIndex: 'IrrNDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Irrigation South DMF</span>",
                dataIndex: 'IrrSDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Sanitation North DMF</span>",
                dataIndex: 'SanNDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Sanitation South DMF</span>",
                dataIndex: 'SanSDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Skill Development North DMF</span>",
                dataIndex: 'SDNDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Skill Development South DMF</span>",
                dataIndex: 'SDSDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Sports North DMF</span>",
                dataIndex: 'SportNDIndex',
                hidden: false,
                width: 180
            }, {
                header: "<span style=font-weight:bold;>Sports South DMF</span>",
                dataIndex: 'SportSDIndex',
                hidden: false,
                width: 180
            }
        ];
        return new Ext.grid.ColumnModel({
            columns: columns.slice(start || 0, finish),
            defaults: {
                sortable: true
            }
        });
    };

    grid = getGrid("DMF Details", '<%=NoRecordsFound%>', store, screen.width - 40, 450, 50, filters, '<%=ClearFilterData%>', false, '', 8, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', false, '<%=Modify%>', false, 'Delete', false, 'Active/Inactive');

    Ext.onReady(function() {
        ctsb = tsb;
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '',
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            width: screen.width - 22,
            cls: 'outerpanel',
            layout: 'table',
            layoutConfig: {
                columns: 1
            },
            items: [clientPanel, grid]
        });
    });
    var cm = grid.getColumnModel();
        for (var j = 1; j < cm.getColumnCount(); j++) {       
            cm.setColumnWidth(j, 355);
        }
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    <%}%>		
  <%}%>  
		