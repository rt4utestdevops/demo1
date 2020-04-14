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



tobeConverted.add("Division");
tobeConverted.add("SLNO");
tobeConverted.add("Select_Division_Name");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Cancel");
tobeConverted.add("Save");
tobeConverted.add("Permit_No");
tobeConverted.add("Contract_No");
tobeConverted.add("Contractor_Name");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Quantity");
tobeConverted.add("Sand_Block_From");
tobeConverted.add("Stockyard_To");
tobeConverted.add("Valid_From");
tobeConverted.add("Valid_To");
tobeConverted.add("Processing_Fees");
tobeConverted.add("Enter_Permit_No");
tobeConverted.add("Select_Contractor");
tobeConverted.add("Enter_Contract_No");
tobeConverted.add("select_vehicle_No");
tobeConverted.add("Enter_Quantity");
tobeConverted.add("Select_Sand_Block");
tobeConverted.add("Select_Stockyard");
tobeConverted.add("Enter_Valid_From");
tobeConverted.add("Enter_Valid_To");
tobeConverted.add("Enter_Processing_Fees");
tobeConverted.add("Sand_Inward_Permit_Generation");
tobeConverted.add("Modify");
tobeConverted.add("Print_Permit");
tobeConverted.add("PDF");
tobeConverted.add("Excel");
tobeConverted.add("UniqueId_No");
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);



String Division=convertedWords.get(0);
String SLNO=convertedWords.get(1);
String SelectDivision=convertedWords.get(2);
String NoRecordsFound=convertedWords.get(3);
String ClearFilterData=convertedWords.get(4);
String Add=convertedWords.get(5);
String NoRowsSelected=convertedWords.get(6);
String SelectSingleRow=convertedWords.get(7);
String Cancel=convertedWords.get(8);
String Save=convertedWords.get(9);
String Permit_No=convertedWords.get(10);
String Contract_No=convertedWords.get(11);
String Contractor_Name=convertedWords.get(12);
String Vehicle_No=convertedWords.get(13);
String Quantity=convertedWords.get(14);
String Sand_Block_From=convertedWords.get(15);
String Stockyard_To=convertedWords.get(16);
String Valid_From=convertedWords.get(17);
String Valid_To=convertedWords.get(18);
String Processing_Fees=convertedWords.get(19);
String Enter_Permit_No=convertedWords.get(20);
String Select_Contractor=convertedWords.get(21);
String Enter_Contract_No=convertedWords.get(22);
String select_vehicle_No=convertedWords.get(23);
String Enter_Quantity=convertedWords.get(24);
String Select_Sand_Block=convertedWords.get(25);
String Select_Stockyard=convertedWords.get(26);
String Enter_Valid_From=convertedWords.get(27);
String Enter_Valid_To=convertedWords.get(28);
String Enter_Processing_Fees=convertedWords.get(29);
String Sand_Inward_Permit_Generation=convertedWords.get(30);
String Modify=convertedWords.get(31);
String Print_Permit=convertedWords.get(32);
String PDF=convertedWords.get(33);
String EXCEL=convertedWords.get(34);
String UniqueId_No=convertedWords.get(35);

%>

<jsp:include page="../Common/header.jsp" />
 		<title>Sand Inward Permit Generation</title>	
 		  
 
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
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
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}				
			.x-window-tl *.x-window-header {			
				padding-top : 6px !important;
				height : 38px !important;
			}							
		</style>
	 <%}%>	
   <script>
var outerPanel;
var ctsb;
var jspname = "Sand_Inward_Trip_Sheet";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var contractorNameModify;
var  contractorNoModify;
var vehicleNoModify;
var quantityModify;
var sandBlockModify;
var stockyardModify;
var validFromModify;
var validToModify;
var procFeesModify;
var selectedQuantity;
var dtcur = datecur;
var dtnext=datenext;
var custname="";

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
                store.load({
                    params: {
                        CustId: custId,
                        jspname:jspname,
                        custname:custname
                    }
                });
                 contractorComboStore.load({
                    params: {
                         CustId: custId
                    }
                });
                stockyardtostore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                
                 sandblockfromStore.load({
                    params: {
                       CustId: Ext.getCmp('custcomboId').getValue() 
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
    emptyText: '<%=SelectDivision%>',
    blankText: '<%=SelectDivision%>',
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
                   store.load({
                    params: {
                        CustId: custId,
                        jspname:jspname,
                        custname:custname
                    }
                });
                 contractorComboStore.load({
                    params: {
                         CustId: custId
                    }
                });
                stockyardtostore.load({
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue()
                    }
                });
                
                 sandblockfromStore.load({
                    params: {
                       CustId: Ext.getCmp('custcomboId').getValue() 
                    }
                });
                
            }
        }
    }
});





var  contractorComboStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getContractor',
    id: 'contractorStoreId',
    root: 'contractorRoot',
    autoload: true,
    remoteSort: true,
    fields: ['contractor_id', 'contractor_name'],
    listeners: {
        load: function() {}
    }
});

var contractorCombo = new Ext.form.ComboBox({
    store:  contractorComboStore,
    id: 'contractorcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Contractor%>',
    blankText: '<%=Select_Contractor%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'contractor_id',
    displayField: 'contractor_name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                Ext.getCmp('sandblockscomboId').reset();
                Ext.getCmp('vehicleNoscomboid').reset();
                if(Ext.getCmp('contractorcomboId').getValue()!='')
                {
                Ext.Ajax.request({
  															url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getContractNo',
															method: 'POST',
															params:
															{
																cname: Ext.getCmp('contractorcomboId').getValue(),
																CustId: Ext.getCmp('custcomboId').getValue()
																
															},
															success:function(response, options)
															{
															var cid=response.responseText;
															Ext.getCmp('contractnoId').setValue(cid);
															Ext.getCmp('contractnoId').disable();
															}, // end of success
            		failure: function(response, options)
                      {
                     
                      }// end of failure
                        });
                      vehicleNostore.load({
                      params: {
                      contractorName:Ext.getCmp('contractorcomboId').getValue(),
                       CustId: Ext.getCmp('custcomboId').getValue()  
                    }
                      
                      });  
                       sandblockfromStore.load({
                       params: {
                       CustId: Ext.getCmp('custcomboId').getValue() ,
                       contractorId: Ext.getCmp('contractorcomboId').getValue()
                    }
                });
                }
            }
        }
    }
});

var sandblockfromStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getSandBlocksFrom',
    id: 'sandblocksId',
    root: 'sandBlockRoot',
    autoload: false,
    remoteSort: true,
    fields: ['sandblock_name', 'sandblock_id'],
    listeners: {
        load: function() {}
    }
});
var sandBlockscombo = new Ext.form.ComboBox({
    store: sandblockfromStore,
    id: 'sandblockscomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Sand_Block%>',
    blankText: '<%=Select_Sand_Block%>',
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'sandblock_id',
    displayField: 'sandblock_name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
                if(Ext.getCmp('sandblockscomboId').getValue()!='')
                {
                 custId = Ext.getCmp('custcomboId').getValue();
                 Ext.Ajax.request({
  															url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getContractNo',
															method: 'POST',
															params:
															{
																cname: Ext.getCmp('contractorcomboId').getValue(),
																CustId: Ext.getCmp('custcomboId').getValue() 
																
															},
															success:function(response, options)
															{
															var cid=response.responseText;
															Ext.getCmp('contractnoId').setValue(cid);
															Ext.getCmp('contractnoId').disable();
															}, // end of success
            		failure: function(response, options)
                      {
                     
                      }// end of failure
                        }); Ext.Ajax.request({
  															url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getPermitNo',
															method: 'POST',
															params:
															{
																
																CustId:custId
															},
															success:function(response, options)
															{
															var permitNo=response.responseText;
															Ext.getCmp('permitnoId').setValue(permitNo);
															
															}, // end of success
            		failure: function(response, options)
                      {
                     
                      }// end of failure
                        });
                Ext.getCmp('processingfeeId').setValue('0');
                }
            }
        }
    }
});

var stockyardtostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getStockyardsTo',
    id: 'stockyardsId',
    root: 'stockyardsRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['stockyard_id', 'stockyard_name']
});

var stockyardcombo = new Ext.form.ComboBox({
    store: stockyardtostore,
    id: 'stockyardcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=Select_Stockyard%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'stockyard_id',
    displayField: 'stockyard_name',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {}
        }
    }
});

var vehicleNostore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getVehicleNos',
    id: 'vehiclesId',
    root: 'vehicleRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['vehicle_no', 'vehicle_id']
});

var vehicleNoscombo = new Ext.form.ComboBox({
    store: vehicleNostore,
    id: 'vehicleNoscomboid',
    mode: 'local',
    forceSelection: true,
    emptyText: '<%=select_vehicle_No%>',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'vehicle_id',
    displayField: 'vehicle_no',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function() {
            
            Ext.Ajax.request({
  															url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getQuantity',
															method: 'POST',
															params:
															{
																vehicleNo: Ext.getCmp('vehicleNoscomboid').getValue()
																
															},
															success:function(response, options)
															{
															var abc=response.responseText;
															Ext.getCmp('quantityId').setValue(response.responseText);
															Ext.getCmp('quantityId').disable();
															}, // end of success
            		failure: function(response, options)
                      {
                     
                      }// end of failure
                        });
            }
        }
    }
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
            text: '<%=Division%>' + ' :',
            cls: 'labelstyle',
            id:'clientlabelid'
        },
        Client
    ]
});

var innerPanelForSandInwardPermit = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 290,
    width: 450,
    frame: true,
    id: 'innerPanelForSandBlockManagementId',
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
        id: 'sandBlockDetailsId',
        width: 420,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'permitid1'
        }, {
            xtype: 'label',
            text: 'Permit No' + ' :',
            cls: 'labelstyle',
            id: 'permitlabelid'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=Enter_Permit_No%>',
            emptyText: '<%=Enter_Permit_No%>',
            labelSeparator: '',
            id: 'permitnoId',
            readOnly:true
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'permitid2'
        },  {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'contractorNameid1'
        },{
            xtype: 'label',
            text: 'Contractor Name' + ' :',
            cls: 'labelstyle',
            id: 'contractornameLabelId'
        }, contractorCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'contractorNameid2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'contractNoId1'
        }, {
            xtype: 'label',
            text: 'Contractor No' + ' :',
            cls: 'labelstyle',
            id: 'contractnoLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: 'Enter Contractor No',
            emptyText: 'Enter Contractor No',
            labelSeparator: '',
            id: 'contractnoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'contractNoId2'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'vehiclenoid1'
        },{
            xtype: 'label',
            text: 'Vehicle No' + ' :',
            cls: 'labelstyle',
            id: 'vehiclenoLabelId'
        }, vehicleNoscombo , {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'vehiclenoid2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'quantityId1'
        }, {
            xtype: 'label',
            text: 'Quantity' + ' :',
            cls: 'labelstyle',
            id: 'quantityLabelId'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            allowNegative:false,
            blankText: '<%=Enter_Quantity%>',
            emptyText: '<%=Enter_Quantity%>',
            labelSeparator: '',
            id: 'quantityId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'quantityId2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'sandblockid1'
        },{
            xtype: 'label',
            text: 'Sand Block From' + ' :',
            cls: 'labelstyle',
            id: 'sandblockLabelId'
        }, sandBlockscombo ,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandblockid2'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'stockyardid1'
        },{
            xtype: 'label',
            text: 'Stockyard To' + ' :',
            cls: 'labelstyle',
            id: 'stockyardLabelId'
        },  stockyardcombo ,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'stockyardid2'
        }, {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'validfromid1'
              },{
                  xtype: 'label',
                  text: 'Valid From' + ' :',
                  cls: 'labelstyle',
                  id: 'validfromLabelId'
              },  {
                  xtype: 'datefield',
                  cls: 'selectstylePerfect',
                  
                  format: getDateTimeFormat(),
                  
                  allowBlank: false,
                 
                  emptyText: '<%=Enter_Valid_From%>',
                  emptyText: '<%=Enter_Valid_From%>',
                  id: 'validfromId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'validfromid2'
              }, {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'validtoid1'
              },{
                  xtype: 'label',
                  text: 'Valid To' + ' :',
                  cls: 'labelstyle',
                  id: 'validtoLabelId'
              },  {
                  xtype: 'datefield',
                  cls: 'selectstylePerfect',
                   
                  format: getDateTimeFormat(),
                  allowBlank: false,
                  emptyText: '<%=Enter_Valid_To%>',
                  emptyText: '<%=Enter_Valid_To%>',
                  id: 'validtoId'
              }, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'validtoid2'
              }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'processingfeeid1'
        }, {
            xtype: 'label',
            text: 'Processing Fee' + ' :',
            cls: 'labelstyle',
            id: 'processingfeelabelid'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            allowNegative:false,
            blankText: '<%=Enter_Processing_Fees%>',
            emptyText: '<%=Enter_Processing_Fees%>',
            labelSeparator: '',
            id: 'processingfeeId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'processingfeeid2'
        }]
    }]
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
                	if (Ext.getCmp('permitnoId').getValue() == "") {
                        Ext.example.msg("Permit Number Should not be Empty--RESELECT SANDBLOCK ");
                        return;
                    }
                    if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectDivision%>");
                        return;
                    }
                    if (Ext.getCmp('contractorcomboId').getValue() == "") {
                        Ext.example.msg("select contractor");
                        return;
                    }
                    if (Ext.getCmp('contractnoId').getValue() == "") {
                        Ext.example.msg("Select Contract No");
                        return;
                    }
                    if (Ext.getCmp('vehicleNoscomboid').getValue() == "") {
                        Ext.example.msg("Enter Vehicle No");
                        return;
                    }
                    if (Ext.getCmp('quantityId').getValue() == "") {
                        Ext.example.msg("enter quantity");
                        return;
                    }
                    if (Ext.getCmp('sandblockscomboId').getValue() == "") {
                        Ext.example.msg("select Sand block");
                        return;
                    }
                    if (Ext.getCmp('stockyardcomboId').getValue() == "") {
                        Ext.example.msg("select stockyard");
                        return;
                    }
                   
                    if (Ext.getCmp('validfromId').getValue() == "") {
                        Ext.example.msg("Enter Valid From");
                        return;
                    }
                    if (Ext.getCmp('validtoId').getValue() == "") {
                        Ext.example.msg("Enter Valid To");
                        return;
                    }
                    
                     if (dateCompare(Ext.getCmp('validfromId').getValue(), Ext.getCmp('validtoId').getValue()) == -1) {
                             Ext.example.msg("Valid To Should Be Greater than Valid From Date");
                             Ext.getCmp('enddate').focus();
                             return;
                       }
                    
                    //  if (innerPanelForSandInwardPermit.getForm().isValid()) {
                   
                    if (buttonValue == 'Modify') {
                        var selected = grid.getSelectionModel().getSelected();
                        id = selected.get('uniqueIdDataIndex');
                        selectedQuantity=selected.get('quantityindex');
                        if (selected.get('contractornameindex') != Ext.getCmp('contractorcomboId').getValue()) {
                            contractorNameModify = Ext.getCmp('contractorcomboId').getValue();
                        } else {
                             contractorNameModify = selected.get('contractornameindex');
                        }
                         if (selected.get('contractornoindex') != Ext.getCmp('contractorcomboId').getValue()) {
                            contractorNoModify = Ext.getCmp('contractorcomboId').getValue();
                        } else {
                             contractorNoModify = selected.get('contractornoindex');
                        }
                        if (selected.get('vehiclenoindex') != Ext.getCmp('contractorcomboId').getValue()) {
                            vehicleNoModify = Ext.getCmp('contractorcomboId').getValue();
                        } else {
                             vehicleNoModify = selected.get('vehiclenoindex');
                        }
                        if (selected.get('quantityindex') != Ext.getCmp('quantityId').getValue()) {
                            quantityModify = Ext.getCmp('quantityId').getValue();
                        } else {
                             quantityModify = selected.get('quantityindex');
                        }
                        if (selected.get('sandblockindex') != Ext.getCmp('contractorcomboId').getValue()) {
                            sandBlockModify = Ext.getCmp('contractorcomboId').getValue();
                        } else {
                             sandBlockModify = selected.get('sandblockindex');
                        }
                       if (selected.get('stockyardindex') != Ext.getCmp('contractorcomboId').getValue()) {
                            stockyardModify = Ext.getCmp('contractorcomboId').getValue();
                        } else {
                             stockyardModify = selected.get('stockyardindex');
                        }
                        if (selected.get('validfromindex') != Ext.getCmp('validfromId').getValue()) {
                            validFromModify = Ext.getCmp('validfromId').getValue();
                        } else {
                             validFromModify = selected.get('validfromindex');
                        }
                        if (selected.get('validtoindex') != Ext.getCmp('validtoId').getValue()) {
                            validToModify = Ext.getCmp('validtoId').getValue();
                        } else {
                             validToModify = selected.get('validtoindex');
                        }
                         if (selected.get('processingfeesindex') != Ext.getCmp('processingfeeId').getValue()) {
                            procFeesModify = Ext.getCmp('processingfeeId').getValue();
                        } else {
                             procFeesModify = selected.get('processingfeesindex');
                        }
                         
                    }
                    sandInwardPermitOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=addModifyPermitDetails',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            permitNo: Ext.getCmp('permitnoId').getValue(),
                            custId: Ext.getCmp('custcomboId').getValue(),
                            contractorName : Ext.getCmp('contractorcomboId').getValue(),
                            contractorNo : Ext.getCmp('contractnoId').getValue(),
                            vehicleNo : Ext.getCmp('vehicleNoscomboid').getValue(),
							quantity : Ext.getCmp('quantityId').getValue(),
							sandblockName : Ext.getCmp('sandblockscomboId').getValue(),
							stockyardName : Ext.getCmp('stockyardcomboId').getValue(),
							validfrom : Ext.getCmp('validfromId').getValue(),
							validto : Ext.getCmp('validtoId').getValue(),
							processingFee : Ext.getCmp('processingfeeId').getValue(),
                            contractorNameModify:contractorNameModify,
                           contractorNoModify:contractorNoModify,
                           vehicleNoModify:vehicleNoModify,
quantityModify:quantityModify,
sandBlockModify:sandBlockModify,
stockyardModify:stockyardModify,
validFromModify:validFromModify,
validToModify:validToModify,
procFeesModify:procFeesModify,
selectedQuantity:selectedQuantity
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('contractorcomboId').reset();
                            Ext.getCmp('contractnoId').enable();
							Ext.getCmp('quantityId').enable();
                            myWin.hide();
                            sandInwardPermitOuterPanelWindow.getEl().unmask();
                            Ext.getCmp('custcomboId').getValue();
                            Ext.getCmp('permitnoId').reset();
Ext.getCmp('contractorcomboId').reset();
Ext.getCmp('contractnoId').reset();
Ext.getCmp('vehicleNoscomboid').reset();
Ext.getCmp('quantityId').reset();
Ext.getCmp('sandblockscomboId').reset();
Ext.getCmp('stockyardcomboId').reset();
Ext.getCmp('validfromId').reset();
Ext.getCmp('validtoId').reset();
Ext.getCmp('processingfeeId').reset();
custname= Ext.getCmp('custcomboId').getRawValue();
                            store.load({
                                params: {
                                    CustId: Ext.getCmp('custcomboId').getValue(),
                                    jspname:jspname,
                                    custname:custname
                                }
                            });
                            
                            
                        },
                        failure: function() {
                            Ext.example.msg("Error");
                            Ext.getCmp('contractnoId').enable();
							Ext.getCmp('quantityId').enable();
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
Ext.getCmp('contractnoId').reset();
Ext.getCmp('contractorcomboId').reset();
Ext.getCmp('vehicleNoscomboid').reset();
Ext.getCmp('quantityId').reset();
Ext.getCmp('sandblockscomboId').reset();
Ext.getCmp('stockyardcomboId').reset();
Ext.getCmp('validfromId').reset();
Ext.getCmp('validtoId').reset();
Ext.getCmp('processingfeeId').reset();
Ext.getCmp('contractnoId').enable();
Ext.getCmp('quantityId').enable();
                    myWin.hide();
                }
            }
        }
    }]
});

var sandInwardPermitOuterPanelWindow = new Ext.Panel({
    width: 460,
    height: 340,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForSandInwardPermit, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 390,
    width: 460,
    id: 'myWin',
    items: [sandInwardPermitOuterPanelWindow]
});

function addRecord() {
        sandblockfromStore.removeAll(); 
        vehicleNostore.removeAll();  
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("<%=SelectDivision%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = 'Add Details';
    myWin.setPosition(450, 80);
  
   
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
Ext.getCmp('permitnoId').reset();
Ext.getCmp('contractorcomboId').reset();
Ext.getCmp('contractnoId').reset();
Ext.getCmp('vehicleNoscomboid').reset();
Ext.getCmp('quantityId').reset();
Ext.getCmp('sandblockscomboId').reset();
Ext.getCmp('stockyardcomboId').reset();
Ext.getCmp('validfromId').reset();
Ext.getCmp('validtoId').reset();
Ext.getCmp('processingfeeId').reset();
  
}

var sm1= new Ext.grid.CheckboxSelectionModel({ 

         });

var reader = new Ext.data.JsonReader({
    idProperty: 'sandBlockid',
    root: 'sandInwardPermitRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'permitnoindex'
    }, {
        name: 'contractornameindex'
    }, {
        name: 'contractornoindex'
    }, {
        name: 'vehiclenoindex'
    }, {
        name: 'quantityindex'
    }, {
        name: 'sandblockindex'
    }, {
        name: 'stockyardindex'
    }, {
        name: 'validfromindex'
    }, {
        name: 'validtoindex'
    }, {
        name: 'processingfeesindex' 
    }, {
        name: 'uniqueid'}]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/SandBlockManagementAction.do?param=getSandPermitDetails',
        method: 'POST'
    }),
    storeId: 'sandId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'string',
        dataIndex: 'permitnoindex'
    }, {
        type: 'string',
        dataIndex: 'contractornameindex'
    }, {
        type: 'string',
        dataIndex: 'contractornoindex'
    }, {
        type: 'string',
        dataIndex: 'vehiclenoindex'
    }, {
        type: 'numeric',
        dataIndex: 'quantityindex'
    }, {
        type: 'string',
        dataIndex: 'sandblockindex'
    }, {
        type: 'string',
        dataIndex: 'stockyardindex'
    }, {
        type: 'date',
        dataIndex: 'validfromindex'
    }, {
        type: 'date',
        dataIndex: 'validtoindex'
    }, {
        type: 'numeric',
        dataIndex: 'processingfeesindex'
    }]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden:true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },{
            dataIndex: 'uniqueid',
            hidden:true,
            header: "<span style=font-weight:bold;><%=UniqueId_No%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            dataIndex: 'permitnoindex',
            header: "<span style=font-weight:bold;><%=Permit_No%></span>",
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Contractor_Name%></span>",
            dataIndex: 'contractornameindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Contractor No</span>",
            dataIndex: 'contractornoindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Vehicle_No %></span>",
            dataIndex: 'vehiclenoindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Quantity %></span>",
            dataIndex: 'quantityindex',
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Sand_Block_From %></span>",
            dataIndex: 'sandblockindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Stockyard_To %></span>",
            dataIndex: 'stockyardindex',
            width: 100,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Valid_From %></span>",
            dataIndex: 'validfromindex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Valid_To %></span>",
            dataIndex: 'validtoindex',
            width: 100,
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Processing_Fees %></span>",
            dataIndex: 'processingfeesindex',
            width: 100,
            filter: {
                type: 'numeric'
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

function PrintPDF()
{      
         
         var selection= grid.getSelectionModel();
         			                var uids="";
									var ts="";
									var total=0;
					 for(i=0;i < grid.store.getCount();i++){ 
										 
										 if(selection.isSelected(i)){
										    var uid = grid.store.getAt(i).data.uniqueid;
										    var ts1= grid.store.getAt(i).data.permitnoindex; 
									        uids=uids+","+uid;
									        ts=ts+","+ts1;
									       } 
										 }
										
							if(uids=="")
							{
							
							Ext.example.msg("No records selected to print...");
							return;
							}
							else
							{
							window.open("<%=request.getContextPath()%>/Sand_Inward_Permit?uids="+uids+"&ts="+ts+"&systemId="+<%=systemId%>+"");	
							
							}
	

      loadGrid1();                


}
function load(){
	
grid.store.reload();

 }
function loadGrid1(){
	
 		setTimeout('load()',5000);
 		
	    }



//*****************************************************************Grid *******************************************************************************
grid = getSandPermitGrid('<%=Sand_Inward_Permit_Generation%>', '<%=NoRecordsFound%>', store, screen.width - 40, 420, 20, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=EXCEL%>', jspname, exportDataType, true, '<%=PDF%>', true, '<%=Add%>', false, '<%=Modify%>', true, '<%=Print_Permit%>');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=Sand_Inward_Permit_Generation%>',
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
    if(<%=customerId%> > 0)
    {
    Ext.getCmp('clientlabelid').hide();
    Ext.getCmp('custcomboId').hide();
    }
});
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
    
    
    
    
    

