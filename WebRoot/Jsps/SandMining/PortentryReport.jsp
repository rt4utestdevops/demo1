<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@page import="com.itextpdf.text.log.SysoLogger"%>
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
	CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
//getting language
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);

Properties properties = ApplicationListener.prop;
String AMSPath = properties.getProperty("AMSPath").trim();

//getting hashmap with language specific words
	HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;
int customeridlogged=loginInfo.getCustomerId();
//Getting words based on language 

String Division;
lwb=(LanguageWordsBean)langConverted.get("Division");
if(language.equals("ar")){
	Division=lwb.getArabicWord();
}else{
	Division=lwb.getEnglishWord();
}
System.out.println(Division);
lwb=null;

String SubDivision;
lwb=(LanguageWordsBean)langConverted.get("Sub_Division");
if(language.equals("ar")){
	SubDivision=lwb.getArabicWord();
}else{
	SubDivision=lwb.getEnglishWord();
}
lwb=null;

String SelectSubDivision="select sub division";
lwb=(LanguageWordsBean)langConverted.get("Select_Sub_Division");
if(language.equals("ar")){
	SelectSubDivision=lwb.getArabicWord();
}else{
	SelectSubDivision=lwb.getEnglishWord();
}
lwb=null;


String selectstartdate;
lwb=(LanguageWordsBean)langConverted.get("Start_Date");
if(language.equals("ar")){
	selectstartdate=lwb.getArabicWord();
}else{
	selectstartdate=lwb.getEnglishWord();
}
lwb=null;

String selectenddate;
lwb=(LanguageWordsBean)langConverted.get("End_Date");
if(language.equals("ar")){
	selectenddate=lwb.getArabicWord();
}else{
	selectenddate=lwb.getEnglishWord();
}
lwb=null;

String SelectDivision;
lwb=(LanguageWordsBean)langConverted.get("Select_Division");
if(language.equals("ar")){
	SelectDivision=lwb.getArabicWord();
}else{
	SelectDivision=lwb.getEnglishWord();
}
lwb=null;

String Pleaseselectdivision;
lwb=(LanguageWordsBean)langConverted.get("Select_Division");
if(language.equals("ar")){
	Pleaseselectdivision=lwb.getArabicWord();
}else{
	Pleaseselectdivision=lwb.getEnglishWord();
}
lwb=null;

String Pleaseselectsubdivision="please select sub division";
lwb=(LanguageWordsBean)langConverted.get("Select_Sub_Division");
if(language.equals("ar")){
	Pleaseselectsubdivision=lwb.getArabicWord();
}else{
	Pleaseselectsubdivision=lwb.getEnglishWord();
}
lwb=null;

String Pleaseselectstartdate;
lwb=(LanguageWordsBean)langConverted.get("Select_Start_Date");
if(language.equals("ar")){
	Pleaseselectstartdate=lwb.getArabicWord();
}else{
	Pleaseselectstartdate=lwb.getEnglishWord();
}
lwb=null;


String UnauthorizedPortEntryReport;
lwb=(LanguageWordsBean)langConverted.get("Unauthorized_Port_Entry_Report");
if(language.equals("ar")){
	UnauthorizedPortEntryReport=lwb.getArabicWord();
}else{
	UnauthorizedPortEntryReport=lwb.getEnglishWord();
}
lwb=null;

String Pleaseselectenddate;
lwb=(LanguageWordsBean)langConverted.get("Select_End_Date");
if(language.equals("ar")){
	Pleaseselectenddate=lwb.getArabicWord();
}else{
	Pleaseselectenddate=lwb.getEnglishWord();
}
lwb=null;

String NoRecordsFound;
lwb=(LanguageWordsBean)langConverted.get("No_Records_Found");
if(language.equals("ar")){
	NoRecordsFound=lwb.getArabicWord();
}else{
	NoRecordsFound=lwb.getEnglishWord();
}
lwb=null;

String ClearFilterData;
lwb=(LanguageWordsBean)langConverted.get("Clear_Filter_Data");
if(language.equals("ar")){
	ClearFilterData=lwb.getArabicWord();
}else{
	ClearFilterData=lwb.getEnglishWord();
}
lwb=null;

String ReconfigureGrid;
lwb=(LanguageWordsBean)langConverted.get("Reconfigure_Grid");
if(language.equals("ar")){
	ReconfigureGrid=lwb.getArabicWord();
}else{
	ReconfigureGrid=lwb.getEnglishWord();
}
lwb=null;

String ClearGrouping;
lwb=(LanguageWordsBean)langConverted.get("Clear_Grouping");
if(language.equals("ar")){
	ClearGrouping=lwb.getArabicWord();
}else{
	ClearGrouping=lwb.getEnglishWord();
}
lwb=null;

String SLNO;
lwb=(LanguageWordsBean)langConverted.get("SLNO");
if(language.equals("ar")){
	SLNO=lwb.getArabicWord();
}else{
	SLNO=lwb.getEnglishWord();
}
lwb=null;

String AssetNO;
lwb=(LanguageWordsBean)langConverted.get("Asset_No");
if(language.equals("ar")){
	AssetNO=lwb.getArabicWord();
}else{
	AssetNO=lwb.getEnglishWord();
}
lwb=null;

String SandBlockName;
lwb=(LanguageWordsBean)langConverted.get("Sand_Block_Name");
if(language.equals("ar")){
	SandBlockName=lwb.getArabicWord();
}else{
	SandBlockName=lwb.getEnglishWord();
}
lwb=null;


String ArrivingDateTime;
lwb=(LanguageWordsBean)langConverted.get("Arriving_Date_Time");
if(language.equals("ar")){
	ArrivingDateTime=lwb.getArabicWord();
}else{
	ArrivingDateTime=lwb.getEnglishWord();
}
lwb=null;

String Detention;
lwb=(LanguageWordsBean)langConverted.get("Detention");
if(language.equals("ar")){
	Detention=lwb.getArabicWord();
}else{
	Detention=lwb.getEnglishWord();
}
lwb=null;

String Remarks;
lwb=(LanguageWordsBean)langConverted.get("Remarks");
if(language.equals("ar")){
	Remarks=lwb.getArabicWord();
}else{
	Remarks=lwb.getEnglishWord();
}
lwb=null;
	
	CommonFunctions cf1 = new CommonFunctions();
	cf1.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
	String responseaftersubmit="''";
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo1 = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language1 = loginInfo1.getLanguage();
	int systemId = loginInfo1.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userid = loginInfo.getUserId();

int CustIdfrom=0;
if(request.getParameter("CustId")!=null){
	CustIdfrom=Integer.parseInt(request.getParameter("CustId").toString().trim());
}
int UserIdfrom=0;
if(request.getParameter("UserId")!=null){
	UserIdfrom=Integer.parseInt(request.getParameter("UserId").toString().trim());
}

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("User");

tobeConverted.add("Select_User");
tobeConverted.add("Group_Name");
tobeConverted.add("SLNO");
tobeConverted.add("Non_Associated");
tobeConverted.add("Associate");
tobeConverted.add("Disassociate");
tobeConverted.add("Associated");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("Group_Id");
tobeConverted.add("Group_Name_Already_Associated");
tobeConverted.add("Group_Name_Already_Disassociated");
tobeConverted.add("CUSTOMER_ID");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Please_Select_Atleast_One_Group_Name_To_Associate");
tobeConverted.add("Please_Select_Atleast_One_Group_Name_To_Disassociate");
tobeConverted.add("You_Can_Either_Associate_Or_Dissociate_At_a_Time");
tobeConverted.add("Next");


ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectCustomer=convertedWords.get(0); 
String CustomerName=convertedWords.get(1); 
String User=convertedWords.get(2); 

String SelectUser=convertedWords.get(3); 
String GroupName=convertedWords.get(4); 
String SLNO1=convertedWords.get(5); 

String NonAssociated=convertedWords.get(6); 
String Associate=convertedWords.get(7); 
String Disassociate=convertedWords.get(8); 
String Associated=convertedWords.get(9); 
String SelectCustomerName =convertedWords.get(10); 
String GroupId =convertedWords.get(11); 
String GroupNameAlreadyAssociated=convertedWords.get(12); 
String GroupNameAlreadyDisAssociated=convertedWords.get(13); 
String CustomerId=convertedWords.get(14); 
String NoRecordsfound=convertedWords.get(15); 
String PleaseselectAtleastOneGroupNameToAssociate=convertedWords.get(16);              
String PleaseselectAtleastOneGroupNameToDisassociate=convertedWords.get(17);
String YouCanEitherAssociateOrDissociateAtaTime=convertedWords.get(18);
String Next=convertedWords.get(19);
%>
<jsp:include page="../Common/header.jsp" />
 		<title></title>		
	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
 
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
    <%} %>
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
   var selected;
     var globalCustomerID=parent.globalCustomerID;
  var flag=false;
  var jspName='UnauthorizedPortEntryReport';
  var jspName1='HubArrDepCountReport';
  var exportDataType="int,string,string,string,string,string,string" ;
  var exportDataType1="int,string,string,string" ;
   var gridData = "";
   var json = "";
   var dateprev=dateprev;
var datecur=datecur;
   var vehicleNo;
  
  
   var startdate = new Ext.form.DateField({
            fieldLabel: '<%=selectstartdate%>',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '<%=Pleaseselectstartdate%>',
            allowBlank: false,
            blankText: '<%=selectstartdate%>',
            submitFormat: getDateTimeFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'startdate',
            value: dateprev,
            maxValue: '',
            vtype: 'daterange',
            endDateField: 'enddate'

        });




        var enddate = new Ext.form.DateField({
            fieldLabel: '<%=selectenddate%>',
            cls: 'selectstyle',
            format: getDateFormat(),
            emptyText: '<%=Pleaseselectenddate%>',
            allowBlank: false,
            blankText: '<%=Pleaseselectenddate%>',
            submitFormat: getDateFormat(),
            labelSeparator: '',
            allowBlank: false,
            id: 'enddate',
            value: datecur,
            maxValue: '',
            vtype: 'daterange',
            startDateField: 'startdate'
        });
  
   var editInfo2 = new Ext.Button({
            text: 'View Details',
            cls: 'buttonStyle',
            width: 100,
            align : 'center',
            handler: function ()

            {
              var selected=grid1.getSelectionModel().getSelected();
              if (selected == undefined || selected == "undefined") 
              {
              alert("select atleast one row");
              return;
              }
                          
                           var records1 = grid1.getSelectionModel().getSelections();
                           for (var i = 0; i < records1.length; i++) {
                           var record1 = records1[i];
                           var row = grid1.store.findExact('slnoIndex', record1.get('slnoIndex'));
                           var store = grid1.store.getAt(row);
                           json = json + Ext.util.JSON.encode(store.data) + ',';
              }
                        storeLoad();
                        json="";
            }
        });
        
        
        
        function storeLoad()
        {
        store.load({
                         params: {
                         CustID: Ext.getCmp('custcomboId').getValue(),
                         startdate: Ext.getCmp('startdate').getValue(),
                         enddate: Ext.getCmp('enddate').getValue(),
                         jspName: jspName,
                         gridData: json
                         
                    }

                });
        }
        var editInfo2buttonpanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'editInfo2buttonpanelId',
       layout: 'table',
        
       frame: false,
       width: 480,
       
       height: 100,
       layoutConfig: {
           columns: 5
           
       },
       items: [editInfo2
       ]
   });
  
  
     var editInfo1 = new Ext.Button({
            text: 'Submit',
            cls: 'buttonStyle',
            width: 100,
            handler: function ()

            {
                var CustomerName = Ext.getCmp('custcomboId').getValue();
               // var groupcombo=Ext.getCmp('groupcomboid').getValue()
                var startdate = Ext.getCmp('startdate').getValue();
                var enddate = Ext.getCmp('enddate').getValue();
                if (Ext.getCmp('custcomboId').getValue() == "") {
                	setMsgBoxStatus('<%=Pleaseselectdivision%>');
                   
                    Ext.getCmp('CustomerNameId').focus();
                    return;
                }
                

                if (Ext.getCmp('startdate').getValue() == "") {
                    setMsgBoxStatus('<%=Pleaseselectstartdate%>');
                    Ext.getCmp('startdate').focus();
                    return;
                }
                if (Ext.getCmp('enddate').getValue() == "") {
                    setMsgBoxStatus('<%=Pleaseselectenddate%>');
                    Ext.getCmp('enddate').focus();
                    return;
                }
                
                firstGridStore.load({  
                       params : {
                        CustID: Ext.getCmp('custcomboId').getValue(),
                        //GroupID:Ext.getCmp('groupcomboid').getValue(),
                        startdate: Ext.getCmp('startdate').getValue(),
                        enddate: Ext.getCmp('enddate').getValue(),
                        jspName: jspName1
                
                
                }
                
                
                });
               store.removeAll();
            }
        });
  
      
   
   var clientcombostore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer&paramforltsp=yes',
       id: 'CustomerStoreId',
       root: 'CustomerRoot',
       autoLoad: true,
       remoteSort: true,
       fields: ['CustId', 'CustName'],
       listeners: {
           load: function (custstore, records, success, options) {
              if ( <%= customerId %> > 0) {
                Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                }
          
           }
       }
   });   
      
   var Client = new Ext.form.ComboBox({
       store: clientcombostore,
       id: 'custcomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectCustomer%>',
       blankText: '<%=SelectCustomer%>',
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
                  
                   
                   
               }
           }
       }
   });
   
   
   
   
   var comboPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
      // title:'Dashboard',
       id: 'traderMaster',
       layout: 'table',
       frame: false,
       width: screen.width - 25,
       height: 40,
       layoutConfig: {
           columns: 13
       },
       items: [{
               xtype: 'label',
               text: '<%=CustomerName%>' + ' :',
               cls: 'labelstyle'
           },
           Client, {
               width: 15
           },{ xtype: 'label',
                    text: '<%=selectstartdate%>' + ':',
                    width: 20,
                    cls: 'labelstyle'

                },
                startdate,{
                        width: 20,
                        height: 10
                    },

                {
                    xtype: 'label',
                    text: '<%=selectenddate%>' + ':',
                    width: 20,
                    cls: 'labelstyle'
                },
                enddate, {
                        width: 20,
                        height: 10
                    },editInfo1
       ]
   });
   
var blockReasonStore = new Ext.data.SimpleStore({
    id: 'blockReasonId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['No MDP', '1'],
        ['Multiple visits with One MDP', '2'],
        ['Different location MDP','3']
    ]
});

var blockReasonCombo = new Ext.form.ComboBox({
    store: blockReasonStore,
    id: 'blockReasonComboId',
    mode: 'local',
    forceSelection: true,
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    emptyText: 'Select Block Reason',
    displayField: 'Name',
    cls: 'selectstylePerfect'
});
    //***************************************************************************FIRST GRID***********************************************************************************//
   var sm1 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });
   
  
   
   var reader1 = new Ext.data.JsonReader({
       root: 'unauthorizedHubCountRoot',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'AssetNoIndex',
           type: 'string'
       }, {
           name: 'AssetGroupIndex',
           type: 'string'
       }, {
           name: 'HubCountIndex',
           type: 'string'
       }]
   });
   
    var firstGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/SandMiningAction.do?param=unauthorizedHubCount',
       bufferSize: 367,
       reader: reader1,
       autoLoad: false,
       remoteSort: false,
       getGroupState: Ext.emptyFn
   });
   
   var filters1 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           dataIndex: 'AssetNoIndex',
           type: 'string'
       }, {
           dataIndex: 'AssetGroupIndex',
           type: 'string'
       }, {
           dataIndex: 'HubCountIndex',
           type: 'string'
       }]
   });
   
   var cols1 = new Ext.grid.ColumnModel([
       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }),sm1,  {
                    dataIndex: 'slnoIndex',
                    hidden: true,
                    header: '<b>SL NO</b>',
                    filter: {
                        type: 'numeric'
                    }
                },{
           header: '<b>Asset Number</b>',
           width: 155,
           sortable: true,
           dataIndex: 'AssetNoIndex'
       }, {
           header: '<b>Asset Group</b>',
           width: 155,
           sortable: true,
           dataIndex: 'AssetGroupIndex'
       }, {
           header: '<b>Hub Arr/Dep Count</b>',
           width: 155,
           sortable: true,
           dataIndex: 'HubCountIndex'
       } 
   ]);
   
    //***************************************************************************88SECOND GRID*******************************************************************************************//
   var sm2 = new Ext.grid.CheckboxSelectionModel({
       checkOnly: true
   });
   
   var cols2 = new Ext.grid.ColumnModel([
       new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }), sm2, {
           header: '<b><%=GroupName%></b>',
           width: 155,
           sortable: true,
           dataIndex: 'groupNameDataIndex2'
       }, {
           header: '<b><%=GroupId%></b>',
           width: 155,
           sortable: true,
           hidden: true,
           dataIndex: 'groupIdDataIndex2'
       }, {
           header: '<b><%=CustomerName%></b>',
           width: 155,
           sortable: true,
           dataIndex: 'custNameDataIndex2'
       }, {
           header: '<b><%=CustomerId%></b>',
           width: 155,
           sortable: true,
           hidden: true,
           dataIndex: 'custIdDataIndex2'
       }
   ]);
   
   var reader2 = new Ext.data.JsonReader({
       root: 'secondGridRoot',
       fields: [{
           name: 'slnoIndex2'
       }, {
           name: 'groupNameDataIndex2',
           type: 'string'
       }, {
           name: 'groupIdDataIndex2',
           type: 'int'
       }, {
           name: 'custNameDataIndex2',
           type: 'String'
       }, {
           name: 'custIdDataIndex2',
           type: 'int'
       }]
   });
   
   var filters2 = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex2'
       }, {
           dataIndex: 'groupNameDataIndex2',
           type: 'string'
       }, {
           dataIndex: 'groupIdDataIndex2',
           type: 'int'
       }, {
           dataIndex: 'custNameDataIndex2',
           type: 'string'
       }, {
           name: 'custIdDataIndex2',
           type: 'int'
       }]
   });
   
   var secondGridStore = new Ext.data.Store({
       url: '<%=request.getContextPath()%>/UserAssetGroupAssociationAction.do?param=getDataForAssociation',
       bufferSize: 367,
       reader: reader2,
       autoLoad: false,
       remoteSort: false
   });
   

   
     var reader = new Ext.data.JsonReader({
            idProperty: 'darreaderid',
            root: 'UnauthorizedPortEntryRoot',
            totalProperty: 'total',
            fields: [{
                name: 'slnoIndex'
            }, {
                name: 'AssetNo'
            }, {
                name: 'assetGroupName'
            }, {
                name: 'SandBlockName'
            }, {
                name: 'ArrivingDateTime'
                //type: 'date',
               // dateFormat: getDateTimeFormat()
            }, {
                name: 'Detention(HH:MM)'
            }, {
                name: 'Remarks'
            }]
        });

         //***************************************Store Config*****************************************
        var store = new Ext.data.GroupingStore({
            autoLoad: false,
            proxy: new Ext.data.HttpProxy({
                url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getUnauthorizedPortEntryReport',
                method: 'POST'
            }),

            storeId: 'CustomerStoreId',
            reader: reader,
            getGroupState: Ext.emptyFn
        });

         //**********************Filter Config****************************************************
        var filters = new Ext.ux.grid.GridFilters({
            local: true,
            filters: [{
                type: 'numeric',
                dataIndex: 'slnoIndex'
            }, {
                type: 'string',
                dataIndex: 'AssetNo'
            }, {
                type: 'string',
                dataIndex: 'assetGroupName'
            }, {
                type: 'string',
                dataIndex: 'SandBlockName'
            }, {
                type: 'date',
                dataIndex: 'ArrivingDateTime'
            }, {
                type: 'string',
                dataIndex: 'Detention(HH:MM)'
            }, {
                type: 'string',
                dataIndex: 'Remarks'
            }]
        });

         //************************************Column Model Config******************************************
        
        
        var createColModel = function (finish, start) {

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
                    dataIndex: 'AssetNo',
                    header: "<span style=font-weight:bold;><%=AssetNO%></span>",
                    width: 50,
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'assetGroupName',
                    header: "<span style=font-weight:bold;>Asset Group</span>",
                    width: 50,
                    filter: {
                        type: 'string'
                    }
                },{
                    dataIndex: 'SandBlockName',
                    header: "<span style=font-weight:bold;><%=SandBlockName%></span>",
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'ArrivingDateTime',
                    header: "<span style=font-weight:bold;><%=ArrivingDateTime%></span>",
                    //renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
                    filter: {
                        type: 'string'
                      }
                }, {
                    dataIndex: 'Detention(HH:MM)',
                    header: "<span style=font-weight:bold;><%=Detention%></span>",
                    filter: {
                        type: 'string'
                    }
                }, {
                    dataIndex: 'Remarks',
                    header: "<span style=font-weight:bold;><%=Remarks%></span>",
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
        
        
         var createColModel1 = function (finish, start) {

            var columns = [
                 new Ext.grid.RowNumberer({
           header: "<span style=font-weight:bold;><%=SLNO%></span>",
           width: 40
       }), {
                    dataIndex: 'slnoIndex',
                    hidden: true,
                    header: '<b>SL NO</b>',
                    filter: {
                        type: 'numeric'
                    }
                },{
           header: '<b>Asset Number</b>',
           width: 155,
           sortable: true,
           dataIndex: 'AssetNoIndex'
       }, {
           header: '<b>Asset Group</b>',
           width: 155,
           sortable: true,
           dataIndex: 'AssetGroupIndex'
       },{
           header: '<b>Hub Arr/Dep Count</b>',
           width: 155,
           sortable: true,
           dataIndex: 'HubCountIndex'
       } 
   
            ];

            return new Ext.grid.ColumnModel({
                columns: columns.slice(start || 0, finish),
                defaults: {
                    sortable: true
                }
            });
        };
        
        function modifyData()
{
 var startdatee='';
 var endDatee='';
 var userid='<%=userid%>';
 var clientid='<%=customerId%>';
 var selected = grid2.getSelectionModel().getSelected();
 vehicleNo = selected.get('AssetNo');
 var reachentry=selected.get('ArrivingDateTime');
 //var latitude=selected.get('latitudeindex');
 //var longitude=selected.get('longitudeindex');
 //var destination=selected.get('clientAddressDataIndex');
 //destination=destination.replace(" ","%20");
 var flag1="ROUTE";  
 if(reachentry=="" || reachentry==null)
{
 Ext.example.msg("Please select A vehicle Having eWayBill"); 
 return;		                            
}
 reachentry=reachentry.replace(" ", "T");

 var url="/jsps/Redirect.jsp?vehicleNo="+vehicleNo+"&startdate="+startdatee+"&enddate="+endDatee+"&userid="+userid+"&clientid="+clientid+"&reachentry="+reachentry+"&flag1="+flag1;

 	var win = new Ext.Window({
        title:'History Analysis Window',
        autoShow : false,
    	constrain : false,
    	constrainHeader : false,
    	resizable : false,
    	maximizable : true,
    	minimizable :true,
    	footer:true,
    	header:false,
        width:screen.width-40,
        height:510,
        shim:false,
        animCollapse:false,
        border:false,
        constrainHeader:true,
        layout: 'fit',
		html : "<iframe style='width:100%;height:470px;background:#ffffff' src="+url+"></iframe>",
		listeners: {
			maximize: function(){
			},
			minimize:function(){
			},
			resize:function(){
			},
			restore:function(){
			}
		}
    });
  
    win.show();
win.setPosition(10, 5);

}
  //******************************************Add and Modify function *********************************************************************//
  var innerPanelForBlockingVehicleDetails = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
      height: 170,
      width: 390,
      frame: true,
      id: 'innerPanelForBlockingVehicleDetailsId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 5
      },
      
          items: [{ height:30},{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'vehicleNoEmptyId'
          }, {
              xtype: 'label',
              text: 'Vehicle No' + ' :',
              cls: 'labelstyle',
              id: 'vehiclenoLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              id: 'vehicleNoID',
              allowBlank: false,
              blankText: '',
              emptyText: '',
              autoCreate: {  
                       tag: "input",
                       maxlength: 50,
                       type: "text",
                       size: "200",
                       autocomplete: "off"
                   },
              disabled: true,
              mode: 'local',
              labelSeparator: ''
          },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'vehicleNoEmptyId2'
        }, { height:30},{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'blockingReasonEmptyId'
          }, {
              xtype: 'label',
              text: 'Blocking Reason' + ' :',
              cls: 'labelstyle',
              id: 'blockingReasonLabelId'
          }, blockReasonCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'blockingreasonEmptyId2'
          },{ height:30},{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'remarksEmptyId'
          }, {
              xtype: 'label',
              text: 'Remarks' + ' :',
              cls: 'labelstyle',
              id: 'remarksLabelId'
          }, {
              xtype: 'textarea',
              cls: 'selectstylePerfect',
              allowBlank: false,
              id: 'remarksID',
              resizable: true,
              blankText: 'Enter Remarks',
              emptyText: 'Enter Remarks'
             
          }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'remarksEmptyId2'
        }
      
      ]
    
  });
  
  var innerWinButtonPanel = new Ext.Panel({
      id: 'winbuttonid',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 90,
      width: 390,
      frame: true,
      layout: 'table',
      layoutConfig: {
          columns: 4
      },
      buttons: [{
          xtype: 'button',
          text: 'Submit',
          id: 'addButtId',
          cls: 'buttonstyle',
          iconCls: 'savebutton',
          width: 70,
          listeners: {
          click: {
          fn :function() {
           if (Ext.getCmp('blockReasonComboId').getRawValue() == "") {
            Ext.example.msg("Select Bocking Reason");
             return;
           }
            if (Ext.getCmp('remarksID').getValue() == "") {
             Ext.example.msg("Enter Remarks");
                        return;
          }
          Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SandMiningAction.do?param=InsertBlockedVehicles',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                vehicleno: Ext.getCmp('vehicleNoID').getValue(),
                                blockingReason: Ext.getCmp('blockReasonComboId').getRawValue(),
                                remarks: Ext.getCmp('remarksID').getValue()
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
							    Ext.getCmp('blockReasonComboId').reset();
								Ext.getCmp('remarksID').reset();
								Ext.getCmp('vehicleNoID').reset();
                                myWin.hide();
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
        text: 'Cancel',
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
  
  var BlockingOuterPanelWindow = new Ext.Panel({
      width: 420,
      height: 250,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForBlockingVehicleDetails, innerWinButtonPanel]
  });
  myWin = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 300,
      width: 420,
       frame: true,
      id: 'myWin',
      items: [BlockingOuterPanelWindow]
  });
        
function verifyFunction() {
var selected = grid2.getSelectionModel().getSelected();
        if (Ext.getCmp('custcomboId').getValue() == "") {
            Ext.example.msg("Select Customer Name");
            return;
        }
        if (grid2.getSelectionModel().getCount() == 0) {
            Ext.example.msg("No Rows Selected");
            return;
        }
        if (grid2.getSelectionModel().getCount() > 1) {
            Ext.example.msg("Select Single Row");
            return;
        }

var selected = grid2.getSelectionModel().getSelected();
vehicleNo = selected.get('AssetNo');
Ext.getCmp('vehicleNoID').setValue(vehicleNo);
Ext.getCmp('blockReasonComboId').reset();
Ext.getCmp('remarksID').reset();
Ext.Ajax.request({
    url: '<%=request.getContextPath()%>/SandMiningAction.do?param=CheckBlockedVehicles',
    method: 'POST',
    params: {
        CustId: Ext.getCmp('custcomboId').getValue(),
        vehicleno: Ext.getCmp('vehicleNoID').getValue()
    },
    success: function(response, options) {
        var message = response.responseText;
        if(message=="Vehicle Already Blocked"){
        Ext.example.msg("Vehicle Already Blocked");
        }
        else{
        buttonValue = "Block Vehicle";
    	titelForInnerPanel = 'Blocking Vehicle Details';
   		myWin.setPosition(450,50);
		myWin.setTitle(titelForInnerPanel); 
        myWin.show();
        }
    },
    failure: function() {
        Ext.example.msg("Error");
        approveWin.hide();
    }
});
}
         //*******************************************Grid Panel Config***************************************

      
   //var grid1 = getSelectionModelGrid('<%=NonAssociated%>', '<%=NoRecordsfound%>', firstGridStore, 470, 370, cols1, 6, filters1, sm1);
    var grid1 = getGrid_new('Details', '<%=NoRecordsFound%>', firstGridStore, 480, 370, 7, filters1, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, 'Excel', jspName1, exportDataType1, false, '');
   
   //var grid2 = getSelectionModelGrid('<%=Associated%>', '<%=NoRecordsfound%>', secondGridStore, 1070, 370, cols2, 6, filters2, sm2);
   var grid2 = getGrid('Vehicle Full Details', '<%=NoRecordsFound%>', store, 821, 370, 10, filters, '<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, 'Excel', jspName, exportDataType,true, 'PDF', false, '',true, 'History Analysis',false,'',false,'',false,'Block Vehicle');

   
    var firstGridForNonAssociation = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'FirstGridForNonAssociationId',
       layout: 'table',
       frame: false,
       width: 480,
       height: 380,
       items: [grid1]
   }); 
   
   
   var secondGridPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'secondGridPanelId',
       layout: 'table',
       frame: false,
       width: 1080,
       height: 380,
       items: [grid2]
   });
   
   var firstAndSecondPanels = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'firsrAndSecondGridPanelId',
       layout: 'table',
       frame: false,
       width: '100%',
       height: 395,
       layoutConfig: {
           columns: 5
       },
       items: [firstGridForNonAssociation,{width:25},secondGridPanel 
       ]
   });
  
  //****************************************Grid function*********************************//
  
function getGrid_new(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr){
	 var grid = new Ext.grid.GridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel1(gridnoofcols),
	        loadMask: true,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        listeners: {
                render : function(grid){
                  grid.store.on('load', function(store, records, options){
                    grid.getSelectionModel().selectFirstRow();       
                  });                      
                }
               },
	        plugins: [filters],	       
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            iconCls : 'clearfilterbutton',
	            handler: function () {
	        	grid.filters.clearFilters();
	            } 
	        }]);
	if(reconfigure){
		grid.getBottomToolbar().add([
		 '-',                            
			{
            text: reconfigurestr,
            handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
            } 
        }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(add)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:addstr,
			    iconCls : 'addbutton',
			    handler : function(){
			    addRecord();

			    }    
			  }]);
		}	
		if(modify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:modifystr,
			    iconCls : 'editbutton',
			    id: 'modifyId',
			    handler : function(){
			    modifyData();

			    }    
			  }]);
		}	
		if(del)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:delstr,
			    iconCls : 'deletebutton',
			    id: 'gridDeleteId',
			    handler : function(){
			    deleteData();

			    }    
			  }]);
		}
		if(copy)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:copystr,
			    iconCls : 'copybutton',
			    id: 'gridCopyId',
			    handler : function(){
			    copyData();
			   }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'excelbutton',
			    handler : function(){
			    getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:'',
			    iconCls : 'pdfbutton',
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:closestr,
			    iconCls:'closeTripbuttonS',
			    id: 'gridCloseTripId',
			    handler : function(){
				closetripsummary();
			    }    
			  }]);
		}
		if(verify)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:verifystr,
			    iconCls:'',
			    id: 'gridVerifyId',
			    handler : function(){
					verifyFunction();
			    }    
			  }]);
		}
		if(approve)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:approvestr,
			    iconCls:'',
			    id: 'gridApproveId',
			    handler : function(){
					approveFunction();
			    }    
			  }]);
		}
		if(postpone)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:postponestr,
			    iconCls:'postponebutton',
			    id: 'gridPostponeId',
			    handler : function(){
					postponeFunction();
			    }    
			  }]);
		}
		if(importExcel)
		{
			grid.getBottomToolbar().add([
			'-',                             
			{
			    text:importStr,
			    iconCls : 'excelbutton',
			    handler : function(){
			    importExcelData();

			    }    
			  }]);
		}
		if(save)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:saveStr,
			    iconCls : 'savebutton',
			    handler : function(){
			    saveDate();

			    }    
			  }]);
		}
		if(clearData)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:clearStr,
			    iconCls : 'clearbutton',
			    handler : function(){
			    clearInputData();

			    }    
			  }]);
		}
		if(close)
		{
			grid.getBottomToolbar().add([
			'-',                            
			{
			    text:closeStr,
			    iconCls : 'closebutton',
			    handler : function(){
			    closeImportWin();

			    }    
			  }]);
		}

	return grid;
}
 
  	
   Ext.onReady(function () {
       ctsb = tsb;
       Ext.QuickTips.init();
       Ext.form.Field.prototype.msgTarget = 'side';
       outerPanel = new Ext.Panel({
           title: 'Un-Authorized Port Entry',
           renderTo: 'content',
           standardSubmit: true,
           frame: true,
           width: screen.width-25,
           height:550,
           cls: 'outerpanel',
           layout: 'table',
           layoutConfig: {
               columns: 1
           },
           items: [comboPanel, firstAndSecondPanels,editInfo2buttonpanel]
           //bbar: ctsb
       });
       sb = Ext.getCmp('form-statusbar');
   });
   </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->






   
   
   
   
   
   
   
   
   
   
   