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
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
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
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("SLNO");
tobeConverted.add("Id");
tobeConverted.add("Excel");
tobeConverted.add("Delete");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Mine_Code");
tobeConverted.add("Enter_Mine_Code");
tobeConverted.add("Plant_Feed_Details");
tobeConverted.add("Add_Plant_Feed_Details");
tobeConverted.add("Modify_Plant_Feed_Details");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String Add=convertedWords.get(0);
String Modify=convertedWords.get(1);
String CustomerName=convertedWords.get(2);
String SelectCustomerName=convertedWords.get(3);
String NoRecordsFound=convertedWords.get(4);
String ClearFilterData=convertedWords.get(5);
String SLNO=convertedWords.get(6);
String ID=convertedWords.get(7);
String Excel=convertedWords.get(8);
String Delete=convertedWords.get(9);
String NoRowsSelected=convertedWords.get(10);
String SelectSingleRow=convertedWords.get(11);
String Save=convertedWords.get(12);
String Cancel=convertedWords.get(13);
String Mine_Code=convertedWords.get(14);
String Enter_Mine_Code=convertedWords.get(15);

String Plant_Feed_Details=convertedWords.get(16);
String Add_Plant_Feed_Details=convertedWords.get(17);
String Modify_Plant_Feed_Details=convertedWords.get(18);

int userId=loginInfo.getUserId(); 
String userAuthority=cf.getUserAuthority(systemId,userId);	

String addButton="true";
	    String modifyButton="true";
	    String deleteButton="false";
	    
	     if(loginInfo.getIsLtsp()== 0)
	    {
	        addButton="true";
		    modifyButton="true";
		    deleteButton="true";
	    }
	else if(loginInfo.getIsLtsp()== -1 && (userAuthority.equalsIgnoreCase("Supervisor")))
		{
			addButton="true";
		    modifyButton="true";
		    deleteButton="false";
	        
		}else{
		    addButton="false";
		    modifyButton="false";
		    deleteButton="false";
		}
%>
<jsp:include page="../Common/header.jsp" />
 		<title>Plant Feed Details</title>		
  
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			label {
				display : inline !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			.x-menu-list {
				height:auto !important;
			}
			div#myWin {
				top : 51px !important;
			}
		</style>
	<%}%>
   <script>
   
var outerPanel;
var ctsb;
var jspName = "PlantFeedDetails";
var exportDataType = "int,int,string,string,string,string,number,string,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,number,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var dtcur = datecur;
var custName;
var sumOfLumpsFinesConcentrates;
var orgCode;
var romChallanType;
var oCodeID;
var oCodeName;
var romQty;
var procOreQty;
var romUsedQty;
var procOreUsedQty;
var TypeQuantity;
var TypeUsedQuantity;
var plantQty;
var UfoQty;
var lumpsQty;
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
                custId = <%=customerId%>;
                custName = Ext.getCmp('custcomboId').getRawValue();
                store.load({
                    params: {
                        CustId: custId,
                        CustName: custName,
                         jspName:jspName
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
    emptyText: '<%=SelectCustomerName%>',
    blankText: '<%=SelectCustomerName%>',
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
                custName = Ext.getCmp('custcomboId').getRawValue();
                store.load({
                    params: {
                        CustId: custId,
                        CustName: custName,
                        jspName:jspName
                    }
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
            text: '<%=CustomerName%>' + ' :',
            cls: 'labelstyle'
        },
        Client
    ]
});

  var oCodeStore= new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/PlantFeedDetailsAction.do?param=getOCode',
            root: 'oCodeRoot',
            autoLoad: false,
            fields: ['ORG_ID','ORG_CODE','ORG_NAME']
   });
  
  var oNameCombo = new Ext.form.ComboBox({
      store: oCodeStore,
      id: 'oNameId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      resizable: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'ORG_ID',
      emptyText: 'Select Organisation Name',
      displayField: 'ORG_NAME',
      cls: 'selectstylePerfect',
      listeners: {
      select: {
      			fn:function(){
      			custId = Ext.getCmp('custcomboId').getValue();
      			oNameID = Ext.getCmp('oNameId').getValue();
      			var id0=oCodeStore.find('ORG_ID',oNameID);
      			var record0=oCodeStore.getAt(id0);
      			Ext.getCmp('oCodeId').setValue(record0.data['ORG_CODE']);
      			Ext.getCmp('plantNameComboId').reset();
      			Ext.getCmp('plantQtyId').reset();
      			plantNameStore.load({
	                    params: {
	                    	clientId: custId,
			                orgId:oNameID
	                    }
      				});
      			}
      		  }
      }
  });
 
 var plantNameStore= new Ext.data.JsonStore({
            url: '<%=request.getContextPath()%>/PlantFeedDetailsAction.do?param=getplantIdAndName',
            root: 'plantNameRoot',
            autoLoad: false,
            fields: ['PLANT_ID','PLANT_NAME','PLANT_QTY','UFO_QTY','LUMPS_QTY']
   });
 
 var plantNameCombo = new Ext.form.ComboBox({
      store: plantNameStore,
      id: 'plantNameComboId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      resizable: true,
      allowBlank: false,
      allowNegative: false,
      anyMatch: true,
      disabled: false,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'PLANT_ID',
      emptyText: 'Select Plant Name',
      displayField: 'PLANT_NAME',
      cls: 'selectstylePerfect',
		     listeners: {
		      select: {
		      	fn:function(){
      			custId = Ext.getCmp('custcomboId').getValue();
      			plantID = Ext.getCmp('plantNameComboId').getValue();
      			var id0=plantNameStore.find('PLANT_ID',plantID);
      			var record0=plantNameStore.getAt(id0);
      			plantQty=record0.data['PLANT_QTY'];
      			UfoQty=record0.data['UFO_QTY'];
      			lumpsQty=record0.data['LUMPS_QTY'];
      			Ext.getCmp('plantQtyId').reset();
      			Ext.getCmp('typeId').reset();
      			}
		      }
		     }
 });
 
  var romQuantity = new Ext.form.NumberField({
           emptyText: 'Enter ROM/UFO/LUMPS Quantity',
           allowBlank: true,
           cls: 'selectstylePerfect',
           id: 'romid',
           listeners: {
         	change: function() {
           	var selected = grid.getSelectionModel().getSelected();
           	if (buttonValue == 'Add') {}
           	if (buttonValue == 'Modify') {}
        	}
           }
  		});
  
      //******************************store for Mineral**********************************
    var typeStore = new Ext.data.SimpleStore({
        id: 'typeStoreId',
        fields: ['Name', 'Value'],
        autoLoad: false,
        data: [
            ['ROM', 'ROM'],
            ['UFO', 'UFO'],
            ['LUMPS', 'LUMPS']
        ]
    });

    //****************************combo for Mineral****************************************
    var typeCombo = new Ext.form.ComboBox({
        store: typeStore,
        id: 'typeId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Type',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function() {
	                if(Ext.getCmp('typeId').getValue()=='ROM'){
	                	Ext.getCmp('plantQtyId').setValue(plantQty);
	                	//Ext.getCmp('UFOid').enable();
	                }
	                else if(Ext.getCmp('typeId').getValue()=='LUMPS'){
	                	Ext.getCmp('plantQtyId').setValue(lumpsQty);
	                	//Ext.getCmp('UFOid').enable();
	                }
	                else{
	                	Ext.getCmp('plantQtyId').setValue(UfoQty);
	                	Ext.getCmp('UFOid').reset();
	                	//Ext.getCmp('UFOid').disable();
	                }
                }
            }
        }
    });
  
var innerPanelForPlantFeedDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 405,
    width: 1100,
    frame: false,
    id: 'innerPanelForPlantFeedDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 5
    },
    items: [{
        xtype: 'fieldset',
        title:'Plant Feed Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        id: 'MineralInfoId',
        width: 1100,
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
        xtype: 'panel',
        id: 'FHid',
        width: 400,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'numberEmptyId1on'
        },{
            xtype: 'label',
            text: 'O NAME' + ' :',
            cls: 'labelstyle',
            id: 'organNameId'
        },oNameCombo, {},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'numberEmptyId1'
        },{
            xtype: 'label',
            text: 'O CODE' + ' :',
            cls: 'labelstyle',
            id: 'organCodeId'
        },  {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'oCodeId',
            disabled: true,
            readOnly:true,
            mode: 'local',
            }, {},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'numberEmptyIdpln'
        },{
            xtype: 'label',
            text: 'Plant Name' + ' :',
            cls: 'labelstyle',
            id: 'plantNamelabelId'
        }, plantNameCombo, {},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'typeEmptyId'
        },{
            xtype: 'label',
            text: 'Type' + ' :',
            cls: 'labelstyle',
            id: 'typelabelId'
        }, typeCombo, {},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'manPlantQtyId'
        },{
            xtype: 'label',
            text: 'Plant/UFO/Lumps Quantity' + ' :',
            cls: 'labelstyle',
            id: 'plantQtyLabId'
        },  {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            id: 'plantQtyId',
            readOnly:true,
            mode: 'local',
            }, {},
        {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorydate'
            },{
                 xtype: 'label',
	            text: 'Date' + ' :',
	            cls: 'labelstyle'
            },{
                xtype: 'datefield',
	            cls: 'selectstylePerfect',
	            id: 'dateid',
	            format: 'd/m/Y',
	            allowBlank: false,
	            emptyText: 'Enter Date',
	            blankText: 'Enter Date',
	            labelSeparator: '',
	            value: dtcur
	            },{},
	            {
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: 'ROM / UFO / LUMPS' + ' :',
	            cls: 'labelstyle'
	        }, romQuantity,{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(L)Below 55%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'lump1id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(L)55% to Below 58%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            cls: 'selectstylePerfect',
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            id: 'lump2id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(L)58% to Below 60%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'lump3id'
	        },{},
	        {
	              xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(L)60% to Below 62%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'lump4id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(L)62% to Below 65%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'lump5id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(L)65% and Above' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'lump6id'
	        },{}]
	        },{
        xtype: 'panel',
        id: 'SHid',
        width: 400,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(F)Below 55%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'fine1id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(F)55% to Below 58%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'fine2id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(F)58% to Below 60%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'fine3id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(F)60% to Below 62%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'fine4id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(F)62% to Below 65%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'fine5id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(F)65% and Above' + ' :',
	            cls: 'labelstyle'
	         },{    
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'fine6id'
	        },{},    
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(C)Below 55%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'concentrate1id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(C)55% to Below 58%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'concentrate2id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(C)58% to Below 60%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'concentrate3id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(C)60% to Below 62%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'concentrate4id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(C)62% to Below 65%' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'concentrate5id'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: '(C)65% and Above' + ' :',
	            cls: 'labelstyle'
	        },{    
	            xtype: 'numberfield',
	            emptyText: '',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'concentrate6id'
	       },{}]
	        },{
	        xtype: 'panel',
            id: 'SHid1',
            width: 400,
            layout: 'table',
            layoutConfig: {
            columns: 4
        },
        items: [{
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: 'Tailings' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: 'Enter Tailings Quantity',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'tailingsid'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: 'Rejects' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: 'Enter Rejects Quantity',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'rejectsid'
	        },{},
	        {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield'
	        }, {
	            xtype: 'label',
	            text: 'UFO' + ' :',
	            cls: 'labelstyle'
	        }, {
	            xtype: 'numberfield',
	            emptyText: 'Enter UFO Quantity',
	            allowBlank: true,
	            allowNegative: false,
	            listeners:{ change: function(f, n, o){ f.setValue(Math.abs(n)); } },
	            autoCreate: { tag: "input",autocomplete: "off",maxlength: 9 },
	            cls: 'selectstylePerfect',
	            id: 'UFOid'
	        },{},
	        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'numberEmptyId1remarks'
        },{
            xtype: 'label',
            text: 'Remarks' + ' :',
            cls: 'labelstyle',
            id: 'remarksLableId'
        },{
            xtype: 'textfield',
            emptyText: 'Enter Remarks',
            allowBlank: true,
            autoCreate: { tag: "input",autocomplete: "off",maxlength: 100 },
            cls: 'selectstylePerfect',
            id: 'remarksId'
	        }, {}]
	        }]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 90,
    width: 1100,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    var rec;
                    var id;
                    var romQty;
                    
                    if (Ext.getCmp('oNameId').getValue() == "") {
                       	Ext.example.msg("Select Organization Name");
                       	Ext.getCmp('oNameId').focus();
                       	return;
                    }
                    if (Ext.getCmp('plantNameComboId').getValue() == "") {
                       	Ext.example.msg("Select Plant Name");
                       	Ext.getCmp('plantNameComboId').focus();
                       	return;
                    }
                    if (Ext.getCmp('dateid').getValue() == "") {
                       	Ext.example.msg("Select Date");
                       	Ext.getCmp('dateid').focus();
                       	return;
                    }
                    if (Ext.getCmp('typeId').getValue() == "") {
                        Ext.example.msg("Select Type");
                        Ext.getCmp('typeId').focus();
                        return;
                    }
                    if (Ext.getCmp('romid').getValue() == "") {
                        Ext.example.msg("Enter ROM/UFO Quantity");
                        Ext.getCmp('romid').focus();
                        return;
                    }
                    if (buttonValue == 'Add') {
                    	  romQty=Ext.getCmp('romid').getValue();
                          if(parseFloat(Ext.getCmp('plantQtyId').getValue()) < parseFloat(Ext.getCmp('romid').getValue())){
                          	Ext.example.msg("ROM/UFO should not be greater than Plant Qty");
                          	return;
                          }
                    }else if (buttonValue == 'Modify') {
                            var selected = grid.getSelectionModel().getSelected();
                            id = selected.get('uniqueIdIndex');
                            var selPlantQty= selected.get('plantQtyIndex');
                            var selRomQty=selected.get('romDataIndex');
                            romQty= parseFloat(parseFloat(Ext.getCmp('romid').getValue()).toFixed(2)- selRomQty).toFixed(2);
                            if(selPlantQty < romQty){
                          	Ext.example.msg("ROM should not be greater than Plant Qty");
                          	return;
                          }
                        }
                      
                    var lump1id = Ext.getCmp('lump1id').getValue();
				    var lump2id = Ext.getCmp('lump2id').getValue();
				    var lump3id = Ext.getCmp('lump3id').getValue();
				    var lump4id = Ext.getCmp('lump4id').getValue();
				    var lump5id = Ext.getCmp('lump5id').getValue();
				    var lump6id = Ext.getCmp('lump6id').getValue();
				    var fine1id = Ext.getCmp('fine1id').getValue();
				    var fine2id = Ext.getCmp('fine2id').getValue();
				    var fine3id = Ext.getCmp('fine3id').getValue();
				    var fine4id = Ext.getCmp('fine4id').getValue();
				    var fine5id = Ext.getCmp('fine5id').getValue();
				    var fine6id = Ext.getCmp('fine6id').getValue();
				    var concentrate1id = Ext.getCmp('concentrate1id').getValue();
				    var concentrate2id = Ext.getCmp('concentrate2id').getValue();
				    var concentrate3id = Ext.getCmp('concentrate3id').getValue();
				    var concentrate4id = Ext.getCmp('concentrate4id').getValue();
				    var concentrate5id = Ext.getCmp('concentrate5id').getValue();
				    var concentrate6id = Ext.getCmp('concentrate6id').getValue();
				    var tailingsid = Ext.getCmp('tailingsid').getValue();
				    var rejectsid = Ext.getCmp('rejectsid').getValue();
				    var UFOid = Ext.getCmp('UFOid').getValue();
				    
				    if(lump1id == ""){
						lump1id = 0;
					}
					if(lump2id == ""){
						lump2id = 0;
					}
					if(lump3id == ""){
						lump3id = 0;
					}
					if(lump4id == ""){
						lump4id = 0;
					}
					if(lump5id == ""){
						lump5id = 0;
					}
					if(lump6id == ""){
						lump6id = 0;
					}
					if(fine1id == ""){
						fine1id = 0;
					}
					if(fine2id == ""){
						fine2id = 0;
					}
					if(fine3id == ""){
						fine3id = 0;
					}
					if(fine4id == ""){
						fine4id = 0;
					}
					if(fine5id == ""){
						fine5id = 0;
					}
					if(fine6id == ""){
						fine6id = 0;
					}
					if(concentrate1id == ""){
						concentrate1id = 0;
					}
					if(concentrate2id == ""){
						concentrate2id = 0;
					}
					if(concentrate3id == ""){
						concentrate3id = 0;
					}
					if(concentrate4id == ""){
						concentrate4id = 0;
					}
					if(concentrate5id == ""){
						concentrate5id = 0;
					}
					if(concentrate6id == ""){
						concentrate6id = 0;
					}
					if(tailingsid == ""){
						tailingsid = 0;
					}
					if(rejectsid == ""){
						rejectsid = 0;
					}
					if(UFOid == ""){
						UFOid = 0;
					}
                    sumOfLumpsFinesConcentrates = lump1id + lump2id + lump3id + lump4id + lump5id + lump6id + fine1id +fine2id +fine3id + fine4id + fine5id + fine6id +  concentrate1id +concentrate2id +concentrate3id + concentrate4id + concentrate5id + concentrate6id  + tailingsid + rejectsid + UFOid;

                        if ((sumOfLumpsFinesConcentrates.toFixed(2)) != (Ext.getCmp('romid').getValue())) {
                          Ext.example.msg("Sum of Lumps, Fines, Tailings, Rejects and UFO should be equal to ROM/UFO quantity"); 
                          return;
                        }
                        routeMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/PlantFeedDetailsAction.do?param=AddorModifyPlantFeedDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId:Ext.getCmp('custcomboId').getValue(),
							    oCode:oNameID,
							    date:Ext.getCmp('dateid').getValue(),
							    rom:Ext.getCmp('romid').getValue(),
							    romQty:romQty,
							    lump1:Ext.getCmp('lump1id').getValue(),
							    lump2:Ext.getCmp('lump2id').getValue(),
							    lump3:Ext.getCmp('lump3id').getValue(),
							    lump4:Ext.getCmp('lump4id').getValue(),
							    lump5:Ext.getCmp('lump5id').getValue(),
							    lump6:Ext.getCmp('lump6id').getValue(),
							    fine1:Ext.getCmp('fine1id').getValue(),
							    fine2:Ext.getCmp('fine2id').getValue(),
							    fine3:Ext.getCmp('fine3id').getValue(),
							    fine4:Ext.getCmp('fine4id').getValue(),
							    fine5:Ext.getCmp('fine5id').getValue(),
							    fine6: Ext.getCmp('fine6id').getValue(),
							    concentrate1:Ext.getCmp('concentrate1id').getValue(),
							    concentrate2:Ext.getCmp('concentrate2id').getValue(),
							    concentrate3:Ext.getCmp('concentrate3id').getValue(),
							    concentrate4:Ext.getCmp('concentrate4id').getValue(),
							    concentrate5:Ext.getCmp('concentrate5id').getValue(),
							    concentrate6: Ext.getCmp('concentrate6id').getValue(),
							    tailing:Ext.getCmp('tailingsid').getValue(),
							    reject:Ext.getCmp('rejectsid').getValue(),
							    UFO:Ext.getCmp('UFOid').getValue(),
							    plantId:plantID,
							    id: id,
                              	jspName: jspName,
                              	type : Ext.getCmp('typeId').getValue(),
                              	remark : Ext.getCmp('remarksId').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                  Ext.getCmp('typeId').reset();
							      Ext.getCmp('oCodeId').reset();
							      Ext.getCmp('oNameId').reset();
							      Ext.getCmp('plantNameComboId').reset();
							      Ext.getCmp('plantQtyId').reset();
							      Ext.getCmp('dateid').reset();
							      Ext.getCmp('romid').reset();
							      Ext.getCmp('lump1id').reset();
							      Ext.getCmp('lump2id').reset();
							      Ext.getCmp('lump3id').reset();
							      Ext.getCmp('lump4id').reset();
							      Ext.getCmp('lump5id').reset();
							      Ext.getCmp('lump6id').reset();
							      Ext.getCmp('fine1id').reset();
							      Ext.getCmp('fine2id').reset();
							      Ext.getCmp('fine3id').reset();
							      Ext.getCmp('fine4id').reset();
							      Ext.getCmp('fine5id').reset();
							      Ext.getCmp('fine6id').reset();
							      Ext.getCmp('concentrate1id').reset();
							      Ext.getCmp('concentrate2id').reset();
							      Ext.getCmp('concentrate3id').reset();
							      Ext.getCmp('concentrate4id').reset();
							      Ext.getCmp('concentrate5id').reset();
							      Ext.getCmp('concentrate6id').reset()
							      Ext.getCmp('tailingsid').reset();
							      Ext.getCmp('rejectsid').reset();
							      Ext.getCmp('UFOid').reset(),
							      Ext.getCmp('remarksId').reset(),
	                              myWin.hide();
	                              routeMasterOuterPanelWindow.getEl().unmask();
	                              custName = Ext.getCmp('custcomboId').getRawValue();
	                              store.reload();
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

var routeMasterOuterPanelWindow = new Ext.Panel({
    width: 1150,
    height: 505,
    standardSubmit: true,
    title: titelForInnerPanel,
    frame: true,
    items: [innerPanelForPlantFeedDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 510,
    width: 1150,
    id: 'myWin',
    items: [routeMasterOuterPanelWindow]
});

   var cancelInnerPanel = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     frame: false,
     id: 'cancel',

     items: [{
         xtype: 'fieldset',
         width: 480,
         title: 'Cancel Details',
         id: 'closefieldset',
         collapsible: false,
         layout: 'table',
         layoutConfig: {
             columns: 5
         },
         items: [{
             xtype: 'label',
             text: '',
             cls: 'mandatoryfield',
             id: 'mandatorycloseLabel'
         }, {
             xtype: 'label',
             text: '*',
             cls: 'mandatoryfield',
             id: 'mandatorycloseLabelId'
         }, {
             xtype: 'label',
             text: 'Remark' + '  :',
             cls: 'labelstyle',
             id: 'remarkLabelId'
         }, {
             width: 10
         }, {
             xtype: 'textarea',
             cls: 'selectstylePerfect',
             id: 'remark',
             emptyText: 'Enter Remarks',
             blankText: 'Enter Remarks',
         }]
     }]
 });
 var winButtonPanelForCancel = new Ext.Panel({
     id: 'winbuttonid12',
     standardSubmit: true,
     collapsible: false,
     height: 8,
     cls: 'windowbuttonpanel',
     frame: true,
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     buttons: [{
         xtype: 'button',
         text: 'Ok',
         id: 'cancelId1',
         cls: 'buttonstyle',
         iconCls: 'savebutton',
         width: 80,
         listeners: {
             click: {
                 fn: function() {
                     if (Ext.getCmp('remark').getValue() == "") {
                         Ext.example.msg("Enter Remark");
                         Ext.getCmp('remark').focus();
                         return;
                     }
                     cancelWin.getEl().mask();
                     var selected = grid.getSelectionModel().getSelected();
                     id = selected.get('uniqueIdIndex');
                     totalLumps=parseFloat(selected.get('lBelow55DataIndex'))+parseFloat(selected.get('lBelow58DataIndex'))+parseFloat(selected.get('lBelow60DataIndex'))+parseFloat(selected.get('lBelow62DataIndex'))+parseFloat(selected.get('lBelow65DataIndex'))+parseFloat(selected.get('labove65DataIndex'));
                     totalFines=parseFloat(selected.get('fBelow55DataIndex'))+parseFloat(selected.get('fBelow58DataIndex'))+parseFloat(selected.get('fBelow60DataIndex'))+parseFloat(selected.get('fBelow62DataIndex'))+parseFloat(selected.get('fBelow65DataIndex'))+parseFloat(selected.get('fabove65DataIndex'));
                     totalConcentrates=parseFloat(selected.get('cBelow55DataIndex'))+parseFloat(selected.get('cBelow58DataIndex'))+parseFloat(selected.get('cBelow60DataIndex'))+parseFloat(selected.get('cBelow62DataIndex'))+parseFloat(selected.get('cBelow65DataIndex'))+parseFloat(selected.get('cabove65DataIndex'));
                     Ext.Ajax.request({
                         url: '<%=request.getContextPath()%>/PlantFeedDetailsAction.do?param=cancelPlantFeed',
                         method: 'POST',
                         params: {
                             id: id,
                             CustID: Ext.getCmp('custcomboId').getValue(),
                             remark: Ext.getCmp('remark').getValue(),
                             qty: selected.get('romDataIndex'),
                             totalFinesTf: totalFines,
                     		 totalLumpsTf: totalLumps,
                     		 totalConcentratesTf: totalConcentrates,
                     		 tailings:selected.get('tailingsDataIndex'),
                     		 ufo: selected.get('UFODataIndex'),
                     		 type: selected.get('typeIndex'),
                     		 plantId: selected.get('plantIdDataIndex')
                         },
                         success: function(response, options) {
                             var message = response.responseText;
                             Ext.example.msg(message);
                             cancelWin.getEl().unmask();
                             store.reload();
                             Ext.getCmp('remark').reset();
                             cancelWin.hide();
                         },
                         failure: function() {
                             Ext.example.msg("Error");
                             store.reload();
                             Ext.getCmp('remark').reset();
                             cancelWin.hide();
                         }
                     });
                 }
             }
         }
     }, {
         xtype: 'button',
         text: '<%=Cancel%>',
         id: 'cancelButtonId2',
         cls: 'buttonstyle',
         iconCls: 'cancelbutton',
         width: '80',
         listeners: {
             click: {
                 fn: function() {
                     cancelWin.hide();
                     Ext.getCmp('remark').reset();
                 }
             }
         }
     }]
 });
 var cancelPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     autoScroll: true,
     width: 490,
     height: 180,
     frame: true,
     id: 'cancelPanel1',
     items: [cancelInnerPanel]
 });
 var outerPanelWindowForCancel = new Ext.Panel({
     standardSubmit: true,
     id: 'cancelwinpanelId1',
     frame: true,
     height: 250,
     width: 520,
     items: [cancelPanel, winButtonPanelForCancel]
 });

 cancelWin = new Ext.Window({
     closable: false,
     modal: true,
     resizable: false,
     autoScroll: false,
     height: 300,
     width: 530,
     id: 'closemyWin',
     items: [outerPanelWindowForCancel]
 });
 
  function deleteData(){
 	selected = grid.getSelectionModel().getSelected();
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomerName%>");
          return;
      }
      if (grid.getSelectionModel().getCount() == 0) {
          Ext.example.msg("No Rows Selected");
          return;
      }
      if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select Single Row");
          return;
      }
      cancelWin.show();
 }

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
     Ext.example.msg("<%=SelectCustomerName%>");
        return;
    }
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=Add_Plant_Feed_Details%>';
    myWin.setPosition(100, 25);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    
	oCodeStore.load({
        params: {
			clientId: custId
		}
	});
	plantNameStore.removeAll(true);
      Ext.getCmp('typeId').reset();
      Ext.getCmp('remarksId').reset();
      Ext.getCmp('oNameId').reset();
      Ext.getCmp('oCodeId').reset();
	  Ext.getCmp('plantNameComboId').reset();
	  Ext.getCmp('plantQtyId').reset();
      Ext.getCmp('dateid').reset();
      Ext.getCmp('romid').reset();
      Ext.getCmp('lump1id').reset();
      Ext.getCmp('lump2id').reset();
      Ext.getCmp('lump3id').reset();
      Ext.getCmp('lump4id').reset();
      Ext.getCmp('lump5id').reset();
      Ext.getCmp('lump6id').reset();
      Ext.getCmp('fine1id').reset();
      Ext.getCmp('fine2id').reset();
      Ext.getCmp('fine3id').reset();
      Ext.getCmp('fine4id').reset();
      Ext.getCmp('fine5id').reset();
      Ext.getCmp('fine6id').reset();
      Ext.getCmp('concentrate1id').reset();
      Ext.getCmp('concentrate2id').reset();
      Ext.getCmp('concentrate3id').reset();
      Ext.getCmp('concentrate4id').reset();
      Ext.getCmp('concentrate5id').reset();
      Ext.getCmp('concentrate6id').reset();
      Ext.getCmp('tailingsid').reset();
      Ext.getCmp('rejectsid').reset();
      Ext.getCmp('UFOid').reset();
      
      Ext.getCmp('dateid').enable();
      Ext.getCmp('oCodeId').enable();
      Ext.getCmp('plantNameComboId').enable();
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
    if(grid.getSelectionModel().getCount()!=1){
	      myWin.hide();
	      Ext.example.msg("<%=SelectSingleRow%>");
	}
    buttonValue = '<%=Modify%>';
    titelForInnerPanel = '<%=Modify_Plant_Feed_Details%>';
    myWin.setPosition(250, 25);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    
    var selected = grid.getSelectionModel().getSelected();
	oCodeStore.load({
        params: {
			clientId: custId
		}
	});
	plantNameStore.load({
       params: {
       	clientId: custId,
     	orgId:selected.get('orgIdIndex')
       }
	});
   
    Ext.getCmp('oCodeId').setValue(selected.get('oCodeDataIndex'));
    Ext.getCmp('oCodeId').disable();
    Ext.getCmp('oNameId').setValue(selected.get('orgNameDataIndex'));
    oNameID=selected.get('orgIdIndex');
    Ext.getCmp('plantNameComboId').setValue(selected.get('plantNameDataIndex'));
    Ext.getCmp('plantQtyId').setValue(selected.get('plantQtyIndex'));
    plantID=selected.get('plantIdDataIndex');
    Ext.getCmp('dateid').setValue(selected.get('dateDataIndex'));
    Ext.getCmp('dateid').disable();
    Ext.getCmp('romid').setValue(selected.get('romDataIndex'));
   
	Ext.getCmp('lump1id').setValue(selected.get('lBelow55DataIndex'));
    Ext.getCmp('lump2id').setValue(selected.get('lBelow58DataIndex'));
    Ext.getCmp('lump3id').setValue(selected.get('lBelow60DataIndex'));
    Ext.getCmp('lump4id').setValue(selected.get('lBelow62DataIndex'));
	Ext.getCmp('lump5id').setValue(selected.get('lBelow65DataIndex'));
    Ext.getCmp('lump6id').setValue(selected.get('labove65DataIndex'));
    Ext.getCmp('fine1id').setValue(selected.get('fBelow55DataIndex'));
    Ext.getCmp('fine2id').setValue(selected.get('fBelow58DataIndex'));
    Ext.getCmp('fine3id').setValue(selected.get('fBelow60DataIndex'));
    Ext.getCmp('fine4id').setValue(selected.get('fBelow62DataIndex'));
	Ext.getCmp('fine5id').setValue(selected.get('fBelow65DataIndex'));
    Ext.getCmp('fine6id').setValue(selected.get('fabove65DataIndex'));
    Ext.getCmp('concentrate1id').setValue(selected.get('cBelow55DataIndex'));
    Ext.getCmp('concentrate2id').setValue(selected.get('cBelow58DataIndex'));
    Ext.getCmp('concentrate3id').setValue(selected.get('cBelow60DataIndex'));
    Ext.getCmp('concentrate4id').setValue(selected.get('cBelow62DataIndex'));
	Ext.getCmp('concentrate5id').setValue(selected.get('cBelow65DataIndex'));
    Ext.getCmp('concentrate6id').setValue(selected.get('cabove65DataIndex'));
	Ext.getCmp('tailingsid').setValue(selected.get('tailingsDataIndex'));
    Ext.getCmp('rejectsid').setValue(selected.get('rejectsDataIndex'));
    Ext.getCmp('UFOid').setValue(selected.get('UFODataIndex'));
   
    }
    
var reader = new Ext.data.JsonReader({
    idProperty: 'plantfeedDetailsid',
    root: 'plantfeedDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'uniqueIdIndex'
    }, {
    	name: 'typeIndex'
    }, {
    	name: 'orgIdIndex'
    }, {
        name: 'oCodeDataIndex'
    }, {
        name: 'orgNameDataIndex'
    }, {
        name: 'plantIdDataIndex'
    }, {
        name: 'plantNameDataIndex'
    }, {
    	name: 'plantQtyIndex'
    }, {
    	type: 'date',
    	dateFormat: 'd/m/Y',
        name: 'dateDataIndex'
    }, {
        name: 'romDataIndex'
    }, {
        name: 'lBelow55DataIndex'
    }, {
        name: 'lBelow58DataIndex'
    }, {
        name: 'lBelow60DataIndex'
    }, {
        name: 'lBelow62DataIndex'
    }, {
        name: 'lBelow65DataIndex'
    }, {
        name: 'labove65DataIndex'
    }, {
        name: 'fBelow55DataIndex'
    }, {
        name: 'fBelow58DataIndex'
    }, {
        name: 'fBelow60DataIndex'
    }, {
        name: 'fBelow62DataIndex'
    }, {
        name: 'fBelow65DataIndex'
    }, {
        name: 'fabove65DataIndex'
    }, {
        name: 'cBelow55DataIndex'
    }, {
        name: 'cBelow58DataIndex'
    }, {
        name: 'cBelow60DataIndex'
    }, {
        name: 'cBelow62DataIndex'
    }, {
        name: 'cBelow65DataIndex'
    }, {
        name: 'cabove65DataIndex'
    }, {
        name: 'tailingsDataIndex'
    }, {
        name: 'rejectsDataIndex'
    }, {
        name: 'UFODataIndex'
    }, {
        name: 'remarksDataIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
       url: '<%=request.getContextPath()%>/PlantFeedDetailsAction.do?param=getPlantFeedDetails',
        method: 'POST'
    }),
    storeId: 'plantfeedDetailsId',
    reader: reader
});

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        type: 'int',
        dataIndex: 'uniqueIdIndex'
    }, {
        type: 'string',
        dataIndex: 'typeIndex'
    }, {
        type: 'string',
        dataIndex: 'oCodeDataIndex'
    }, {
        type: 'string',
        dataIndex: 'orgNameDataIndex'
    }, {
        type: 'string',
        dataIndex: 'plantNameDataIndex'
    }, {
    	type: 'numeric',
    	dataIndex: 'plantQtyIndex'
    }, {
        type: 'date',
        dataIndex: 'dateDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'romDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'lBelow55DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'lBelow58DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'lBelow60DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'lBelow62DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'lBelow65DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'labove65DataIndex'
    },{
        type: 'numeric',
        dataIndex: 'fBelow55DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'fBelow58DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'fBelow60DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'fBelow62DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'fBelow65DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'fabove65DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'cBelow55DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'cBelow58DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'cBelow60DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'cBelow62DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'cBelow65DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'cabove65DataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'tailingsDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'rejectsDataIndex'
    },{
        type: 'numeric',
        dataIndex: 'UFODataIndex'
    },{
        type: 'string',
        dataIndex: 'remarksDataIndex'
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
            header: "<span style=font-weight:bold;><%=SLNO%></span>"
        },{
            header: "<span style=font-weight:bold;>ID</span>",
            dataIndex: 'uniqueIdIndex',
			hidden:true
        }, {
            header: "<span style=font-weight:bold;>Type</span>",
            dataIndex: 'typeIndex'
        },{
            header: "<span style=font-weight:bold;>Organization Code</span>",
            dataIndex: 'oCodeDataIndex'
        }, {
            header: "<span style=font-weight:bold;>Organization Name</span>",
            dataIndex: 'orgNameDataIndex'
        }, {
            header: "<span style=font-weight:bold;>Plant Name</span>",
            dataIndex: 'plantNameDataIndex'
        }, {
            header: "<span style=font-weight:bold;>Plant Quantity</span>",
            dataIndex: 'plantQtyIndex'
        }, {
            header: "<span style=font-weight:bold;>Date</span>",
            dataIndex: 'dateDataIndex',
           renderer: Ext.util.Format.dateRenderer('d/m/Y'),
            filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>ROM / UFO</span>",
            dataIndex: 'romDataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Lumps Below 55%</span>",
            dataIndex: 'lBelow55DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Lumps 55% Below 58%</span>",
            dataIndex: 'lBelow58DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Lumps 58% Below 60%</span>",
            dataIndex: 'lBelow60DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Lumps 60% Below 62%</span>",
            dataIndex: 'lBelow62DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Lumps 62% Below 65%</span>",
            dataIndex: 'lBelow65DataIndex',
            align: 'right'
        },{
            header: "<span style=font-weight:bold;>Lumps 65% and Above</span>",
            dataIndex: 'labove65DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Fines Below 55%</span>",
            dataIndex: 'fBelow55DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Fines 55% Below 58%</span>",
            dataIndex: 'fBelow58DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Fines 58% Below 60%</span>",
            dataIndex: 'fBelow60DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Fines 60% Below 62%</span>",
            dataIndex: 'fBelow62DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Fines 62% Below 65%</span>",
            dataIndex: 'fBelow65DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Fines 65% and Above</span>",
            dataIndex: 'fabove65DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Concentrates Below 55%</span>",
            dataIndex: 'cBelow55DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Concentrates 55% Below 58%</span>",
            dataIndex: 'cBelow58DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Concentrates 58% Below 60%</span>",
            dataIndex: 'cBelow60DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Concentrates 60% Below 62%</span>",
            dataIndex: 'cBelow62DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Concentrates 62% Below 65%</span>",
            dataIndex: 'cBelow65DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Concentrates 65% and Above</span>",
            dataIndex: 'cabove65DataIndex',
            align: 'right'
        }, {
            header: "<span style=font-weight:bold;>Tailings</span>",
            dataIndex: 'tailingsDataIndex',
            align: 'right'
        },{
            header: "<span style=font-weight:bold;>Rejects</span>",
            dataIndex: 'rejectsDataIndex',
            align: 'right'
        },{
            header: "<span style=font-weight:bold;>UFO</span>",
            dataIndex: 'UFODataIndex',
            align: 'right'
        },{
             header: "<span style=font-weight:bold;>Remarks</span>",
             dataIndex: 'remarksDataIndex',
             hidden: false,
             width: 100
            } 
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};
grid = getGrid('Plant Feed Details', '<%=NoRecordsFound%>', store, screen.width - 40, 440, 50, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', <%=addButton%>, '<%=Add%>', false, '<%=Modify%>', <%=deleteButton%>, 'Cancel');

Ext.onReady(function() {
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
        items: [customerComboPanel, grid]
    });
    var cm =grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,110);
    }
    sb = Ext.getCmp('form-statusbar');
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>

