<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
//getting language
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
String systemID=Integer.toString(systemid);
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;
int customeridlogged=loginInfo.getCustomerId();
//Getting words based on language 
String selectCustomer;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer");
if(language.equals("ar")){
	selectCustomer=lwb.getArabicWord();
}else{
	selectCustomer=lwb.getEnglishWord();
}
lwb=null;
String CustomerName;
lwb=(LanguageWordsBean)langConverted.get("Customer_Name");
if(language.equals("ar")){
	CustomerName=lwb.getArabicWord();
}else{
	CustomerName=lwb.getEnglishWord();
}
lwb=null;


String xpressCargoTripAllocation="Route Allocation";

String submit;
lwb=(LanguageWordsBean)langConverted.get("Submit");
if(language.equals("ar")){
	submit=lwb.getArabicWord();
}else{
	submit=lwb.getEnglishWord();
}
lwb=null;

String closeTrip="Close Route"; 


String reset="Reset";
lwb=(LanguageWordsBean)langConverted.get("Reset");
if(language.equals("ar")){
	reset=lwb.getArabicWord();
}else{
	reset=lwb.getEnglishWord();
}
lwb=null;


String wantToDelete;
lwb=(LanguageWordsBean)langConverted.get("Are_you_sure_you_want_to_delete");
if(language.equals("ar")){
	wantToDelete=lwb.getArabicWord();
}else{
	wantToDelete=lwb.getEnglishWord();
}
lwb=null;


String endTime;
lwb=(LanguageWordsBean)langConverted.get("End_Date");
if(language.equals("ar")){
	endTime=lwb.getArabicWord();
}else{
	endTime=lwb.getEnglishWord();
}
lwb=null;

String startTime;
lwb=(LanguageWordsBean)langConverted.get("Start_Date");
if(language.equals("ar")){
	startTime=lwb.getArabicWord();
}else{
	startTime=lwb.getEnglishWord();
}
lwb=null;

String routeName;
lwb=(LanguageWordsBean)langConverted.get("Route_Name");
if(language.equals("ar")){
	routeName=lwb.getArabicWord();
}else{
	routeName=lwb.getEnglishWord();
}
lwb=null;

String vehicleNo;
lwb=(LanguageWordsBean)langConverted.get("Registration_No");
if(language.equals("ar")){
	vehicleNo=lwb.getArabicWord();
}else{
	vehicleNo=lwb.getEnglishWord();
}
lwb=null;


String status;
lwb=(LanguageWordsBean)langConverted.get("Status");
if(language.equals("ar")){
	status=lwb.getArabicWord();
}else{
	status=lwb.getEnglishWord();
}
lwb=null;

String NoRecordsFound="No_Records_Found";
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

String error;
lwb=(LanguageWordsBean)langConverted.get("Error");
if(language.equals("ar")){
	error=lwb.getArabicWord();
}else{
	error=lwb.getEnglishWord();
}
lwb=null;

String TentativeEndDate;
lwb=(LanguageWordsBean)langConverted.get("Tentative_End_Date");
if(language.equals("ar")){
	TentativeEndDate=lwb.getArabicWord();
}else{
	TentativeEndDate=lwb.getEnglishWord();
}
lwb=null;

String Start_Date_Tentative_Date;
lwb=(LanguageWordsBean)langConverted.get("Start_Date_Tentative_Date");
if(language.equals("ar")){
	Start_Date_Tentative_Date=lwb.getArabicWord();
}else{
	Start_Date_Tentative_Date=lwb.getEnglishWord();
}
lwb=null;

String deleting;
lwb=(LanguageWordsBean)langConverted.get("Deleting");
if(language.equals("ar")){
	deleting=lwb.getArabicWord();
}else{
	deleting=lwb.getEnglishWord();
}
lwb=null;

String selectVehicle;
lwb=(LanguageWordsBean)langConverted.get("Sel_Reg_No");
if(language.equals("ar")){
	selectVehicle=lwb.getArabicWord();
}else{
	selectVehicle=lwb.getEnglishWord();
}
lwb=null;

String selectRoute;
lwb=(LanguageWordsBean)langConverted.get("Select_Route");
if(language.equals("ar")){
	selectRoute=lwb.getArabicWord();
}else{
	selectRoute=lwb.getEnglishWord();
}
lwb=null;

String selectStartTime;
lwb=(LanguageWordsBean)langConverted.get("Select_Start_Date");
if(language.equals("ar")){
	selectStartTime=lwb.getArabicWord();
}else{
	selectStartTime=lwb.getEnglishWord();
}
lwb=null;

String selectEndTime;
lwb=(LanguageWordsBean)langConverted.get("Select_End_Date");
if(language.equals("ar")){
	selectEndTime=lwb.getArabicWord();
}else{
	selectEndTime=lwb.getEnglishWord();
}
lwb=null;


String TripAllocationInformation="Route Allocation Information";

String AssetNumber;
lwb=(LanguageWordsBean)langConverted.get("Asset_Number");
if(language.equals("ar")){
	AssetNumber=lwb.getArabicWord();
}else{
	AssetNumber=lwb.getEnglishWord();
}
lwb=null;

String Save;
lwb=(LanguageWordsBean)langConverted.get("Save");
if(language.equals("ar")){
	Save=lwb.getArabicWord();
}else{
	Save=lwb.getEnglishWord();
}
lwb=null;

String Cancel;
lwb=(LanguageWordsBean)langConverted.get("Cancel");
if(language.equals("ar")){
	Cancel=lwb.getArabicWord();
}else{
	Cancel=lwb.getEnglishWord();
}
lwb=null;

String SelectCustomerName;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer_Name");
if(language.equals("ar")){
	SelectCustomerName=lwb.getArabicWord();
}else{
	SelectCustomerName=lwb.getEnglishWord();
}
lwb=null;

String Add;
lwb=(LanguageWordsBean)langConverted.get("Add");
if(language.equals("ar")){
	Add=lwb.getArabicWord();
}else{
	Add=lwb.getEnglishWord();
}
lwb=null;

String AddDetails;
lwb=(LanguageWordsBean)langConverted.get("Add_Details");
if(language.equals("ar")){
	AddDetails=lwb.getArabicWord();
}else{
	AddDetails=lwb.getEnglishWord();
}
lwb=null;

String NoRowsSelected;
lwb=(LanguageWordsBean)langConverted.get("No_Rows_Selected");
if(language.equals("ar")){
	NoRowsSelected=lwb.getArabicWord();
}else{
	NoRowsSelected=lwb.getEnglishWord();
}
lwb=null;

String SelectSingleRow;
lwb=(LanguageWordsBean)langConverted.get("Select_Single_Row");
if(language.equals("ar")){
	SelectSingleRow=lwb.getArabicWord();
}else{
	SelectSingleRow=lwb.getEnglishWord();
}
lwb=null;

String RecordHasBeenClosedSoUnableToModify;
lwb=(LanguageWordsBean)langConverted.get("Record_Has_Been_Closed_So_Unable_To_Modify");
if(language.equals("ar")){
	RecordHasBeenClosedSoUnableToModify=lwb.getArabicWord();
}else{
	RecordHasBeenClosedSoUnableToModify=lwb.getEnglishWord();
}
lwb=null;

String Modify;
lwb=(LanguageWordsBean)langConverted.get("Modify");
if(language.equals("ar")){
	Modify=lwb.getArabicWord();
}else{
	Modify=lwb.getEnglishWord();
}
lwb=null;

String ModifyDetails;
lwb=(LanguageWordsBean)langConverted.get("Modify_Details");
if(language.equals("ar")){
	ModifyDetails=lwb.getArabicWord();
}else{
	ModifyDetails=lwb.getEnglishWord();
}
lwb=null;

String CloseTripInformation;
lwb=(LanguageWordsBean)langConverted.get("Close_Trip_Information");
if(language.equals("ar")){
	CloseTripInformation=lwb.getArabicWord();
}else{
	CloseTripInformation=lwb.getEnglishWord();
}
lwb=null;

String RecordHasBeenAlreadyClosed;
lwb=(LanguageWordsBean)langConverted.get("Record_Has_Been_Already_Closed");
if(language.equals("ar")){
	RecordHasBeenAlreadyClosed=lwb.getArabicWord();
}else{
	RecordHasBeenAlreadyClosed=lwb.getEnglishWord();
}
lwb=null;



String CloseTrip;
lwb=(LanguageWordsBean)langConverted.get("Close_Trip");
if(language.equals("ar")){
	CloseTrip=lwb.getArabicWord();
}else{
	CloseTrip=lwb.getEnglishWord();
}
lwb=null;


String CloseTripDetails;
lwb=(LanguageWordsBean)langConverted.get("Close_Trip_Details");
if(language.equals("ar")){
	CloseTripDetails=lwb.getArabicWord();
}else{
	CloseTripDetails=lwb.getEnglishWord();
}
lwb=null;



String monthValidation;
lwb=(LanguageWordsBean)langConverted.get("Month_Validation");
if(language.equals("ar")){
	monthValidation=lwb.getArabicWord();
}else{
	monthValidation=lwb.getEnglishWord();
}
lwb=null;


String EndDateMustBeGreaterthanStartDate;
lwb=(LanguageWordsBean)langConverted.get("End_Date_Must_Be_Greater_Than_Start_Date");
if(language.equals("ar")){
	EndDateMustBeGreaterthanStartDate=lwb.getArabicWord();
}else{
	EndDateMustBeGreaterthanStartDate=lwb.getEnglishWord();
}
lwb=null;

langConverted=null;
%>

<!DOCTYPE HTML>
<html>
 <head>
 
		<title>Xpress Cargo Trip Allocation</title>		

	</head>	    
  
  <body height="100%">
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <script>
 var outerPanel;
 var ctsb;
 var panel1;
 var closereportflag = false;
 var selected;
 var titelForInnerPanel;
 var dtcur = datecur;
 var dtprev = dateprev;
 /********************resize window event function***********************/
 Ext.EventManager.onWindowResize(function () {
     var width = '100%';
     var height = '100%';
     userGrid.setSize(width, height);
     outerPanel.setSize(width, height);
     outerPanel.doLayout();
 });
 //******************************store for getting customer name************************
 var custmastcombostore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
     id: 'CustomerStoreId',
     root: 'CustomerRoot',
     autoLoad: true,
     remoteSort: true,
     fields: ['CustId', 'CustName'],
     listeners: {
         load: function (cutstore, records, success, options) {
             if ( <%= customeridlogged %> > 0) {
                 Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
                 store.load({
                     params: {
                         custID:Ext.getCmp('custmastcomboId').getValue()
                         //assetID:Ext.getCmp('assetgroupcomboid').getValue(),
                     },
                     callback: function () {
                         userGrid.getSelectionModel().deselectRow(0);
                     }
                 });

                 vehiclestore.load({
                     params: {
                         CustId: <%= customeridlogged %> ,
                         LTSPId: <%= systemID %>
                     }
                 });

                 routecombostore.load({
                     params: {
                         custID: <%= customeridlogged %>
                     }
                 });
             }
         }
     }
 });

 //**************************** Combo for Customer Name***************************************************
 var custnamecombo = new Ext.form.ComboBox({
     store: custmastcombostore,
     id: 'custmastcomboId',
     mode: 'local',
     hidden: false,
     resizable: true,
     forceSelection: true,
     emptyText: '<%=selectCustomer%>',
     blankText: '<%=selectCustomer%>',
     selectOnFocus: true,
     allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'CustId',
     displayField: 'CustName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             CustId:Ext.getCmp('custmastcomboId').getValue();
                 Ext.getCmp('vehicleno').reset();
                 Ext.getCmp('routeid').reset();
                 Ext.getCmp('starttime').reset();
                 Ext.getCmp('endtime').reset();
                 Ext.getCmp('assetgroupcomboid').reset();
                 <!--		                 	  	 assetgroupnamecombostore.load({-->
                 <!--		                 	    params:{CustId:Ext.getCmp('custmastcomboId').getValue()}-->
                 <!--              		          	});-->
				
				store.load({
                     params: {
                         custID:Ext.getCmp('custmastcomboId').getValue()
                         //assetID:Ext.getCmp('assetgroupcomboid').getValue(),
                     },
                     callback: function () {
                         userGrid.getSelectionModel().deselectRow(0);
                     }
                 });
              

                 vehiclestore.load({
                     params: {
                         CustId: Ext.getCmp('custmastcomboId').getValue(),
                         LTSPId: <%= systemID %>
                     }
                 });

                 routecombostore.load({
                     params: {
                         custID: Ext.getCmp('custmastcomboId').getValue()
                     }
                 });
             }
         }
     }
 });
 //********************************* Reader Config***********************************
 var reader = new Ext.data.JsonReader({
     idProperty: 'gridrootid',
     root: 'GridRoot',
     totalProperty: 'total',
     fields: [{
         name: 'id'
     }, {
         name: 'vehicleno'
     }, {
         name: 'routename'
     }, {
         name: 'routecode'
     }, {
         name: 'arrivaltime'
     }, {
         name: 'departuretime'
     }, {
         name: 'assetallocationdate',
         type: 'date',
         dateFormat: getDateTimeFormat()
     },{
         name: 'status'
     }, {
         name: 'routeid'
     }, ]
 });
 //******************************** Grid Store*************************************** 
 var store = new Ext.data.GroupingStore({
     autoLoad: false,
     proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=getGridTripAllocation',
         method: 'POST'
     }),
     remoteSort: false,
     sortInfo: {
         field: 'vehicleno',
         direction: 'ASC'
     },
     storeId: 'gridStore',
     reader: reader
 });
<!-- store.on('beforeload', function (store, operation, eOpts) {-->
<!--     operation.params = {-->
<!--         custID: Ext.getCmp('custmastcomboId').getValue(),-->
<!--         startdate: Ext.getCmp('startdate').getValue(),-->
<!--         enddate: Ext.getCmp('enddate').getValue()-->
<!--         -->
<!--     };-->
<!-- }, this);-->

 var filters = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
         dataIndex: 'vehicleno',
         type: 'string'
     }, {
         type: 'string',
         dataIndex: 'routename'
     }, {
         type: 'string',
         dataIndex: 'routecode'
     },
     {
         type: 'string',
         dataIndex: 'arrivaltime'
     }, {
         type: 'string',
         dataIndex: 'departuretime'
     }, {
         type: 'date',
         dataIndex: 'assetallocationdate'
     }, {
         type: 'string',
         dataIndex: 'status'
     },{
         type: 'int',
         dataIndex: 'id'
     }]
 });
 //***********************************Feature Store*************************************************
 var assetgroupnamecombostore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=getGroupName',
     id: 'GroupNameStoreId',
     root: 'GroupNameRoot',
     autoLoad: false,
     remoteSort: true,
     fields: ['GroupId', 'GroupName', 'SupervisorId']
 });
 //*********************************** RouteName Store************************************************
 var routecombostore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=getRoutesTripAllocation',
     id: 'RouteId',
     root: 'RootName',
     autoLoad: false,
     remoteSort: true,
     fields: ['RouteID', 'RouteName']
 });
 //************************************ Vehicle Store************************************************
 var vehiclestore = new Ext.data.JsonStore({
     url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=getVehicleDetails',
     id: 'VehicleStoreId',
     root: 'VehicleRoot',
     autoLoad: false,
     remoteSort: true,
     fields: ['VehicleNo', 'IMEINo', 'DeviceType', 'VehicleAlias']
 });
 //***********************************Feature for combo***********************************************
 var assetgroupcombo = new Ext.form.ComboBox({
     store: assetgroupnamecombostore,
     id: 'assetgroupcomboid',
     mode: 'local',
     hidden: false,
     resizable: true,
     forceSelection: true,
     emptyText: 'Select Group',
     blankText: 'Select Group',
     selectOnFocus: true,
     allowBlank: false,
     typeAhead: true,
     hidden: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'GroupId',
     displayField: 'GroupName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {}
         }
     }
 });
 
 
  var editInfo1 = new Ext.Button({
            text: 'Submit',
            cls: 'buttonStyle',
            width: 70,
            handler: function ()

            {
                var clientName = Ext.getCmp('custmastcomboId').getValue();
                var startdate = Ext.getCmp('startdate').getValue();
                var enddate = Ext.getCmp('enddate').getValue();
                
                if (Ext.getCmp('custmastcomboId').getValue() == "") {
                	Ext.example.msg("Pleaseselectclient");
                    Ext.getCmp('custmastcomboId').focus();
                    return;
                }

                if (Ext.getCmp('startdate').getValue() == "") {
              	    Ext.example.msg("Pleaseselectstartdate");
                    Ext.getCmp('startdate').focus();
                    return;
                }
                if (Ext.getCmp('enddate').getValue() == "") {
	                Ext.example.msg("Pleaseselectenddate");
                    Ext.getCmp('enddate').focus();
                    return;
                }
                
                if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                	Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
                    Ext.getCmp('enddate').focus();
                    return;
               }
                       
                       if(checkMonthValidation(Ext.getCmp('startdate').getValue(),Ext.getCmp('enddate').getValue()))
            		 				{
            		 				Ext.example.msg("<%=monthValidation%>");
               		   	 				Ext.getCmp('enddate').focus(); 
               		    				return;
            		 				}
     
                
                store.load({
                    params: {
                        custID: Ext.getCmp('custmastcomboId').getValue(),
                        startdate: Ext.getCmp('startdate').getValue(),
                        enddate: Ext.getCmp('enddate').getValue()
                   }

                });

            }
        });
 
 
 
 
 
 
 //**********************inner panel start******************************************* 
 var innerPanel = new Ext.Panel({
     standardSubmit: true,
     collapsible: false,
     id: 'custMaster',
     layout: 'table',
     frame: true,
     layoutConfig: {
         columns: 10
     },
     items: [{
             xtype: 'label',
             text: '<%=CustomerName%>' + ' :',
             cls: 'labelstyle'
         },
         custnamecombo,{width:20}
         ]
 });



 //**************************** Grid Pannel Config ******************************************

 var createColModel = function (finish, start) {
     var columns = [
         new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;>Slno</span>",
             width: 50
         }), {
             header: "<span style=font-weight:bold;>Asset No</span>",
             dataIndex: 'vehicleno',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Route Code</span>",
             dataIndex: 'routecode',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;><%=routeName%></span>",
             dataIndex: 'routename',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Arrival Time(HH:MM)</span>",
             dataIndex: 'arrivaltime',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Departure Time(HH:MM)</span>",
             dataIndex: 'departuretime',
             filter: {
                 type: 'string'
             }
         },
         {
             header: "<span style=font-weight:bold;>Asset Allocation Date</span>",
             dataIndex: 'assetallocationdate',
             renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
             filter: {
                 type: 'date'
             }
         }, { 
             header: "<span style=font-weight:bold;><%=status%></span>",
             dataIndex: 'status',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Route id</span>",
             dataIndex: 'routeid',
             hidden: true,
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>ID</span>",
             dataIndex: 'id',
             hidden: true,
             filter: {
                 type: 'int'
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

 var userGrid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 70, 375, 10, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', '', '', false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '', true,'Close');

 <!---->
 <!--userGrid.on({-->
 <!--        cellclick:{-->
 <!--            fn: function(userGrid, rowIndex, columnIndex, e){-->
 <!--                Ext.getCmp('vehicleno').reset();-->
 <!--				Ext.getCmp('routeid').reset();-->
 <!--				Ext.getCmp('starttime').reset();-->
 <!--				Ext.getCmp('tentativeendtime').reset();-->
 <!--				Ext.getCmp('endtime').reset();-->
 <!--        		var record = userGrid.getSelectionModel().getSelected();-->
 <!--        		var index = userGrid.store.indexOf(record);-->
 <!--        		var record = userGrid.store.getAt(index);-->
 <!--        		var value=record.get(userGrid.getColumnModel().getDataIndex(6));-->
 <!--        -->
 <!--		        if(value=='Open')-->
 <!--		        {-->
 <!--		                var rec = userGrid.store.getAt(index);-->
 <!--		                userForm.loadRecord(rec);-->
 <!--		        }-->
 <!--		        else-->
 <!--		        {-->
 <!--		        closereportflag=true; -->
 <!--		        }    -->
 <!--            }-->
 <!--        },-->
 <!--        -->
 <!--    });-->



 //**************************** Grid Panel Config ends here**********************************
 //**************************** Grid Form config starts here*********************************
 Ext.ns('App', 'App.user');
 var vehiclescombo = new Ext.form.ComboBox({
     store: vehiclestore,
     fieldLabel: '<%=vehicleNo%>',
     id: 'vehicleno',
     mode: 'local',
     hidden: false,
     resizable: true,
     forceSelection: true,
     emptyText: 'Select Vehicle',
     blankText: 'Select Vehicle',
     selectOnFocus: true,
     allowBlank: false,
     anyMatch: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'VehicleNo',
     displayField: 'VehicleNo',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {}
         }
     }
 });
 var routescombo = new Ext.form.ComboBox({
     store: routecombostore,
     fieldLabel: '<%=routeName%>',
     id: 'routeid',
     mode: 'local',
     hidden: false,
     resizable: true,
     forceSelection: true,
     emptyText: '',
     blankText: 'Select Route',
     selectOnFocus: true,
     allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'RouteID',
     displayField: 'RouteName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {}
         }
     }
 });
 //store for status
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
                id: 'statusid',
                mode: 'local',
                forceSelection: true,
                emptyText: 'Select Status',
                blankText: 'Select Status',
                selectOnFocus: true,
                allowBlank: false,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'Value',
                displayField: 'Value',
                cls: 'selectstylePerfect',
                listeners: {
                    select: {
                        fn: function () {}
                    }
                }
            });
 var starttime = new Ext.form.DateField({
     fieldLabel: '<%=startTime%>',
     cls: 'selectstylePerfect',
     format: getDateTimeFormat(),
     submitFormat: getDateTimeFormat(),
     labelSeparator: '',
     allowBlank: false,
     id: 'starttime'
     //value: todaysDate
     //validateValue: function (value) { return validateFromTo(value); }
 });
 var tentativeendtime = new Ext.form.DateField({
     fieldLabel: '<%=TentativeEndDate%>',
     cls: 'selectstylePerfect',
     format: getDateTimeFormat(),
     submitFormat: getDateTimeFormat(),
     labelSeparator: '',
     allowBlank: false,
     id: 'tentativeendtime'
     //value: todaysDate
     //validateValue: function (value) { return validateFromTo(value); }tentativeendtime
 });
 var endtime = new Ext.form.DateField({
     fieldLabel: '<%=endTime%>',
     cls: 'selectstylePerfect',
     format: getDateTimeFormat(),
     submitFormat: getDateTimeFormat(),
     labelSeparator: '',
     allowBlank: true,
     id: 'endtime'
     //value: todaysDate
     //validateValue: function (value) { return validateFromTo(value); }
 });

 var allocationid = new Ext.form.TextField({
     fieldLabel: 'ID',
     cls: 'selectstylePerfect',
     allowBlank: true,
     id: 'id',
     hidden: true
     //value: todaysDate
     //validateValue: function (value) { return validateFromTo(value); }
 });


 var innerPanelForCloseTripDetails = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     autoScroll: true,
     height: 145,
     width: 400,
     frame: true,
     id: 'custMaster',
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     items: [{
         xtype: 'fieldset',
         title: '<%=TripAllocationInformation%>',
         cls: 'fieldsetpanel',
         collapsible: false,
         colspan: 3,
         id: 'addpanelid',
         width: 360,
         layout: 'table',
         layoutConfig: {
             columns: 4
         },
         items: [ {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskId'
             },
         	{
                 xtype: 'label',
                 text: '<%=AssetNumber%>' + ' :',
                 cls: 'labelstyle',
                 id: 'typeTxtId'
             },
             vehiclescombo, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskId1'
             },
             {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatoryrouteId'
             }, {
                 xtype: 'label',
                 text: '<%=routeName%>' + ' :',
                 cls: 'labelstyle',
                 id: 'routeTxtId'
             }, 
             routescombo,{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskId2'
             },
             {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatorystatusId'
             },{
                 xtype: 'label',
                 text: '<%=status%>' + ' :',
                 cls: 'labelstyle',
                 id: 'statusTxtId'
             }, 
             statuscombo,{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorystatusId1'
             }
        ]
     }]
 });

 var innerWinButtonPanelForCloseTrip = new Ext.Panel({
     id: 'winbuttonid',
     standardSubmit: true,
     collapsible: false,
     autoHeight: true,
     height: 110,
     width: 380,
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
                     if (Ext.getCmp('vehicleno').getValue() == "") {
                    	 Ext.example.msg("<%=selectVehicle%>");
                         Ext.getCmp('vehicleno').focus();
                         return;
                     }
                     if (Ext.getCmp('routeid').getValue() == "") {
                  	     Ext.example.msg("<%=selectRoute%>");
                         Ext.getCmp('routeid').focus();
                         return;
                     }
                     if (Ext.getCmp('starttime').getValue() > Ext.getCmp('tentativeendtime').getValue()) {
                     	 Ext.example.msg("<%=Start_Date_Tentative_Date%>");
                         Ext.getCmp('datefieldid').focus();
                         return;
                     }

                     if (innerPanelForCloseTripDetails.getForm().isValid()) {
                         var id;
                         if (buttonvalue == 'Modify') {
                             var selected = userGrid.getSelectionModel().getSelected();
                             id = selected.get('id');
                          }
                         closeTripOuterPanelWindow.getEl().mask();
                         Ext.Ajax.request({
                             url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=saveormodifyTripAllocation',
                             method: 'POST',
                             params: {
                                 buttonvalue: buttonvalue,
                                 custID: Ext.getCmp('custmastcomboId').getValue(),
                                 vehicleno: Ext.getCmp('vehicleno').getValue(),
                                 status:Ext.getCmp('statusid').getValue(),
                                 routename: Ext.getCmp('routeid').getValue(),
                                 id: id
                              },
                             success: function (response, options) {
                               closereportflag = false;
                                 vehiclestore.load({
                                     params: {
                                         CustId: Ext.getCmp('custmastcomboId').getValue(),
                                         LTSPId: <%= systemID %>
                                     }
                                 });

                                 Ext.getCmp('vehicleno').reset();
                                 Ext.getCmp('routeid').reset();
                                 Ext.getCmp('starttime').reset();
                                 Ext.getCmp('tentativeendtime').reset();
                                 Ext.getCmp('id').reset();
                                 myWin.hide();
	                             closeTripOuterPanelWindow.getEl().unmask();
	                             Ext.example.msg(response.responseText);
	                             custmastcombostore.reload();
                                 store.load({
                                     params: {
                                         custID: Ext.getCmp('custmastcomboId').getValue()
                                       },
                                     callback: function () {
                                         userGrid.getSelectionModel().deselectRow(0);
                                     }
                                 });
                                 userGrid.getView().refresh();
                                 outerPanel.getEl().unmask();
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
                 }
             }
         }
     }]
 });

 var closeTripOuterPanelWindow = new Ext.Panel({
     width: 390,
     height: 210,
     standardSubmit: true,
     frame: false,
     items: [innerPanelForCloseTripDetails, innerWinButtonPanelForCloseTrip]
 });

 myWin = new Ext.Window({
     title: titelForInnerPanel,
     closable: false,
     resizable: false,
     modal: true,
     autoScroll: false,
     height: 250,
     width: 390,
     id: 'myWin',
     items: [closeTripOuterPanelWindow]
 });


 function addRecord() {

     if (Ext.getCmp('custmastcomboId').getValue() == "") {
     					Ext.example.msg("<%=SelectCustomerName%>");
                        return;
                    }

     buttonvalue = '<%=Add%>';
     titelForInnerPanel = '<%=AddDetails%>';
     myWin.setPosition(450, 150);
     myWin.show();
      Ext.getCmp('statusid').setValue('Active').disable();
      Ext.getCmp('vehicleno').enable();
      myWin.setTitle(titelForInnerPanel);
      Ext.getCmp('vehicleno').reset();
      Ext.getCmp('routeid').reset();
      Ext.getCmp('starttime').reset();
      Ext.getCmp('tentativeendtime').reset();
      Ext.getCmp('id').reset();
 }

 function modifyData() {
     if (userGrid.getSelectionModel().getCount() == 0) {
	     Ext.example.msg("<%=NoRowsSelected%>");
         return;
     }
     if (userGrid.getSelectionModel().getCount() > 1) {
    	 Ext.example.msg("<%=SelectSingleRow%>");
         return;
     }

     var selected = userGrid.getSelectionModel().getSelected();
     var index = userGrid.store.indexOf(selected);
     var selected = userGrid.store.getAt(index);
     var value = selected.get(userGrid.getColumnModel().getDataIndex(7));

     if (value == 'Closed') {
	     Ext.example.msg("<%=RecordHasBeenClosedSoUnableToModify%>");
         return;
     }

     buttonvalue = '<%=Modify%>';
     titelForInnerPanel = '<%=ModifyDetails%>';
     myWin.setPosition(450, 150);
     myWin.setTitle(titelForInnerPanel);
     myWin.show();
     
     Ext.getCmp('vehicleno').disable();
     Ext.getCmp('statusid').enable();
     Ext.getCmp('routeid').show();
     Ext.getCmp('starttime').show();
     Ext.getCmp('tentativeendtime').show();
     var selected = userGrid.getSelectionModel().getSelected();
     Ext.getCmp('vehicleno').setValue(selected.get('vehicleno'));
     Ext.getCmp('routeid').setValue(selected.get('routename'));
     Ext.getCmp('statusid').setValue(selected.get('status'));
     Ext.getCmp('starttime').setValue(selected.get('starttime'));
     Ext.getCmp('tentativeendtime').setValue(selected.get('tentativeendtime'));
     Ext.getCmp('routeid').setValue(selected.get('routeid'));
    }

 var closeTripPanel = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     autoScroll: true,
     height: 50,
     width: 320,
     frame: true,
     id: 'closeForTripid',
     layout: 'table',
     layoutConfig: {
         columns: 4,
         style: {
             // width: '10%'
         }
     },
     items: [{
         xtype: 'label',
         text:'Are you sure you want to close trip?'    
     }]
 });

 var closeTripButtonPanel = new Ext.Panel({
     id: 'closeTripbuttonid',
     standardSubmit: true,
     collapsible: false,
     autoHeight: true,
     height: 20,
     width: 320,
     frame: true,
     layout: 'table',
     layoutConfig: {
         columns: 4
     },
     buttonAlign: 'left',
     buttons: [{
         xtype: 'button',
         text: 'Yes',
         id: 'savesId',
         cls: 'buttonstyle',
         iconCls: 'savebutton',
         width: 70,
         listeners: {
             click: {
                 fn: function () {
                     closeTripPanelWindow.getEl().mask();
                     var selected = userGrid.getSelectionModel().getSelected();
                     Ext.Ajax.request({
                         url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=closeTripAllocation',
                         method: 'POST',
                         params: {
                             custID: Ext.getCmp('custmastcomboId').getValue(),
                             vehicleno: selected.get('vehicleno'),
                             routename: selected.get('routeid'),
                             endtime: Ext.getCmp('endtime').getValue()
                         },
                         
                         
                         success: function (response, options) //start of success
                         {
                             Ext.getCmp('vehicleno').reset();
                             Ext.getCmp('routeid').reset();
                             Ext.getCmp('starttime').reset();
                             Ext.getCmp('endtime').reset();
                             Ext.example.msg(response.responseText);
                             closeTripWin.hide();
                             closeTripPanelWindow.getEl().unmask();
                             vehiclestore.load({
                                 params: {
                                     CustId: Ext.getCmp('custmastcomboId').getValue(),
                                     LTSPId: <%= systemID %>
                                 }
                             });
                             custmastcombostore.reload();
                             store.load({
                                 params: {
                                     custID: Ext.getCmp('custmastcomboId').getValue()
                                    },
                                 callback: function () {
                                     userGrid.getSelectionModel().deselectRow(0);
                                 }
                             });
                             userGrid.getView().refresh();
                             outerPanel.getEl().unmask();
                         }, // END OF  SUCCESS
                         failure: function () //start of failure 
                         {
                        	 Ext.example.msg("<%=error%>");
                             custmastcombostore.reload();

                             outerPanel.getEl().unmask();
                         } // END OF FAILURE 
                     }); // END OF AJAX	
                     
                 }
             }
         }
     }, {
         xtype: 'button',
         text: 'No',
         id: 'cancelsButtId',
         cls: 'buttonstyle',
         iconCls: 'cancelbutton',
         width: 70,
         listeners: {
             click: {
                 fn: function () {
                     closeTripWin.hide();
                 }
             }
         }
     }]
 });

 var closeTripPanelWindow = new Ext.Panel({
     standardSubmit: true,
     height: 115,
     width: 350,
     frame: true,
     items: [closeTripPanel, closeTripButtonPanel]
 });

 closeTripWin = new Ext.Window({
     closable: false,
     resizable: false,
     modal: true,
     autoScroll: false,
     height: 170,
     width: 345,
     id: 'closeTripWinId',
     items: [closeTripPanelWindow]
 });

 function closetripsummary() {

     if (userGrid.getSelectionModel().getCount() == 0) {
   		Ext.example.msg("<%=NoRowsSelected%>");
     }

     if (userGrid.getSelectionModel().getCount() > 1) {
     	Ext.example.msg("<%=SelectSingleRow%>");
        return;
     }
     var selected = userGrid.getSelectionModel().getSelected();
     var index = userGrid.store.indexOf(selected);
     var selected = userGrid.store.getAt(index);
     var value = selected.get(userGrid.getColumnModel().getDataIndex(7));
  
     if (value == 'Closed') {
    	 Ext.example.msg("<%=RecordHasBeenAlreadyClosed%>");
         return;
     }
     buttonvalue = '<%=CloseTrip%>';
     closeTripWin.show();
     titelForInnerPanel = '<%=CloseTripDetails%>';
     closeTripWin.setPosition(450, 150);
     closeTripWin.setTitle(titelForInnerPanel);
    
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
     items: [userGrid],
    bbar: ctsb
 });
 //***************************  Main starts from here **************************************************
 Ext.onReady(function () {
     ctsb = tsb;
     Ext.QuickTips.init();
     Ext.form.Field.prototype.msgTarget = 'side';
     outerPanel = new Ext.Panel({
         title: '<%=xpressCargoTripAllocation%>',
         renderTo: 'content',
         standardSubmit: true,
         width:screen.width-55,
         height:screen.height-258,
         frame: true,
        // cls: 'outerpanel',
         items: [innerPanel, gridPanel]
     });

 });
   
   </script>
  </body>
</html>