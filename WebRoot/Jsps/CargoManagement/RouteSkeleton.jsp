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


String xpressCargoTripAllocation;
lwb=(LanguageWordsBean)langConverted.get("Trip_Allocation");
if(language.equals("ar")){
	xpressCargoTripAllocation=lwb.getArabicWord();
}else{
	xpressCargoTripAllocation=lwb.getEnglishWord();
}
lwb=null;

String submit;
lwb=(LanguageWordsBean)langConverted.get("Submit");
if(language.equals("ar")){
	submit=lwb.getArabicWord();
}else{
	submit=lwb.getEnglishWord();
}
lwb=null;

String closeTrip;
lwb=(LanguageWordsBean)langConverted.get("Close_Trip");
if(language.equals("ar")){
	closeTrip=lwb.getArabicWord();
}else{
	closeTrip=lwb.getEnglishWord();
}
lwb=null;


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

String custNotDeleted;
lwb=(LanguageWordsBean)langConverted.get("Trip_Not_Deleted");
if(language.equals("ar")){
	custNotDeleted=lwb.getArabicWord();
}else{
	custNotDeleted=lwb.getEnglishWord();
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

String enterCargoTripName;
lwb=(LanguageWordsBean)langConverted.get("Enter_Cargo_Trip_Name");
if(language.equals("ar")){
	enterCargoTripName=lwb.getArabicWord();
}else{
	enterCargoTripName=lwb.getEnglishWord();
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






String TripAllocationInformation;
lwb=(LanguageWordsBean)langConverted.get("Trip_Allocation_Information");
if(language.equals("ar")){
	TripAllocationInformation=lwb.getArabicWord();
}else{
	TripAllocationInformation=lwb.getEnglishWord();
}
lwb=null;

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

String enterCargoTripCode;
lwb=(LanguageWordsBean)langConverted.get("Enter_Cargo_Trip_Code");
if(language.equals("ar")){
	enterCargoTripCode=lwb.getArabicWord();
}else{
	enterCargoTripCode=lwb.getEnglishWord();
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
 
		<title>Route Skeleton</title>		
	</head>	    
  
  <body height="100%">
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
        <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
        <%}else {%>  
        <jsp:include page="../Common/ImportJS.jsp" /><%} %>
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
   </style>
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
             custId = Ext.getCmp('custmastcomboId').getValue();
                 Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
                 store.load({
                     params: {
                         custID: <%= customeridlogged %>
                     },
                     callback: function () {
                         userGrid.getSelectionModel().deselectRow(0);
                     }
                 });

                 routeOriginCombostore.load({
                     params: {
                         CustId: <%= customeridlogged %> ,
                         LTSPId: <%= systemID %>
                     }
                 });

                 routeDestinationCombostore.load({
                     params: {
                         CustId: Ext.getCmp('custmastcomboId').getValue(),
                         LTSPId: <%= systemID %>
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
             custId = Ext.getCmp('custmastcomboId').getValue();
             store.load({
                        params: {
                            custId: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                 routeOriginCombostore.load({
                     params: {
                         CustId: Ext.getCmp('custmastcomboId').getValue(),
                         LTSPId: <%= systemID %>
                     }
                 });

                 routeDestinationCombostore.load({
                     params: {
                         CustId: Ext.getCmp('custmastcomboId').getValue(),
                         LTSPId: <%= systemID %>
                     }
                 });
             }
         }
     }
 });
 //********************************* Reader Config***********************************
 var reader = new Ext.data.JsonReader({
     idProperty: 'RouteSkeletonRootId',
     root: 'RouteSkeletonRoot',
     totalProperty: 'total',
     fields: [{
         name: 'slnoIndex'
     }, {
         name: 'routeCodeIndex'
     }, {
         name: 'routeCodeId'
     },{
         name: 'routeNameIndex'
     }, {
         name: 'routeOriginIndex'
     }, {
         name: 'routeDestinationIndex'
     }, {
         name: 'totalTimeIndex'
     }, {
         name: 'approximateDistanceIndex'
     }, {
         name: 'averageSpeedIndex'
     },{
         name: 'originArrivalIndex'
     },{
         name: 'originDepartIndex'
     },,{
         name: 'destArrivalIndex'
     },{
         name: 'destDepartIndex'
     },{
         name: 'transPoint1Index'
     },{
         name: 'transPoint2Index'
     },,{
         name: 'transPoint3Index'
     },{
         name: 'transPoint4Index'
     },,{
         name: 'transPoint5Index'
     },{
         name: 'transPoint6Index'
     },,{
         name: 'transPoint7Index'
     },{
         name: 'transPoint8Index'
     },,{
         name: 'transPoint9Index'
     },{
         name: 'transPoint10Index'
     },{
         name: 'transArrival1Index'
     },{
         name: 'transDepart1Index'
     },{
         name: 'transArrival2Index'
     },{
         name: 'transDepart2Index'
     },{
         name: 'transArrival3Index'
     },{
         name: 'transDepart3Index'
     },{
         name: 'transArrival4Index'
     },{
         name: 'transDepart4Index'
     },,{
         name: 'transArrival5Index'
     },{
         name: 'transDepart5Index'
     },{
         name: 'transArrival6Index'
     },{
         name: 'transDepart6Index'
     },{
         name: 'transArrival7Index'
     },{
         name: 'transDepart7Index'
     },{
         name: 'transArrival8Index'
     },{
         name: 'transDepart8Index'
     },{
         name: 'transArrival9Index'
     },{
         name: 'transDepart9Index'
     },{
         name: 'transArrival10Index'
     },{
         name: 'transDepart10Index'
     },{
         name: 'originidIndex'
     },{
         name: 'destidIndex'
     }]
 });
 //******************************** Grid Store*************************************** 
 var store = new Ext.data.GroupingStore({
     autoLoad: false,
     proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=getRouteSkeletonReport',
         method: 'POST'
     }),
    remoteSort: false,
     sortInfo: {
         field: 'routeCodeIndex',
         direction: 'ASC'
     },
     storeId: 'gridStoreid',
     reader: reader
 });
 store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                    custID: Ext.getCmp('custmastcomboId').getValue()
                };
            }, this);


 var filters = new Ext.ux.grid.GridFilters({
     local: true,
     filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
       },{
         dataIndex: 'routeCodeIndex',
         type: 'string'
     }, {
         type: 'string',
         dataIndex: 'routeNameIndex'
     }, {
         type: 'string',
         dataIndex: 'routeOriginIndex'
     }, {
         type: 'string',
         dataIndex: 'routeDestinationIndex'
     }, {
         type: 'string',
         dataIndex: 'totalTimeIndex'
     }, {
         type: 'string',
         dataIndex: 'approximateDistanceIndex'
     }, {
         type: 'string',
         dataIndex: 'averageSpeedIndex'
     }]
 });
 
 
 //***********************************************route origin and route destination combo & store******************************
 var routeOriginCombostore = new Ext.data.JsonStore({
    url:'<%=request.getContextPath()%>/CargoManagementAction.do?param=getHubs',
				   id:'HubStoreId',
			       root: 'HubRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['HubId','HubName']
 });
 
 var routeOriginCombo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeOrigin',
     id: 'routeOriginid',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Origin',
     blankText: 'Select Route Origin',
     selectOnFocus: true,
     //allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             
             }
         }
     }
 });
 
 var routeTransPoint1Combo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeTransition',
     id: 'TransPoint1',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Transition Point 1 ',
     blankText: 'Select Route Transition Point 1 ',
     selectOnFocus: true,
     //allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             checkFunction('TransPoint1');
             
             }
         }
     }
 });
 
 var routeTransPoint2Combo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeTransition',
     id: 'TransPoint2',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Transition Point 2',
     blankText: 'Select Route Transition Point 2',
     selectOnFocus: true,
     //allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             checkFunction('TransPoint2');
             
             }
         }
     }
 });
 
 var routeTransPoint3Combo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeTransition',
     id: 'TransPoint3',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Transition Point 3',
     blankText: 'Select Route Transition Point 3',
     selectOnFocus: true,
    // allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             checkFunction('TransPoint3');
             
             }
         }
     }
 });
 
 var routeTransPoint4Combo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeTransition',
     id: 'TransPoint4',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Transition Point 4',
     blankText: 'Select Route Transition Point 4',
     selectOnFocus: true,
     //allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             checkFunction('TransPoint4');
             
             }
         }
     }
 });
 
 var routeTransPoint5Combo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeTransition',
     id: 'TransPoint5',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Transition Point 5',
     blankText: 'Select Route Transition Point 5',
     selectOnFocus: true,
    // allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             checkFunction('TransPoint5');
             
             }
         }
     }
 });
 
 var routeTransPoint6Combo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeTransition',
     id: 'TransPoint6',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Transition Point 6',
     blankText: 'Select Route Transition Point 6',
     selectOnFocus: true,
     //allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             checkFunction('TransPoint6');
             
             }
         }
     }
 });
 
 var routeTransPoint7Combo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeTransition',
     id: 'TransPoint7',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Transition Point 7',
     blankText: 'Select Route Transition Point 7',
     selectOnFocus: true,
     //allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             checkFunction('TransPoint7');
             
             }
         }
     }
 });
 
 var routeTransPoint8Combo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeTransition',
     id: 'TransPoint8',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Transition Point 8',
     blankText: 'Select Route Transition Point 8',
     selectOnFocus: true,
     //allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             checkFunction('TransPoint8');
             
             }
         }
     }
 });
 
 var routeTransPoint9Combo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeTransition',
     id: 'TransPoint9',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Transition Point 9',
     blankText: 'Select Route Transition Point 9',
     selectOnFocus: true,
     //allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             checkFunction('routeTransPoint9id');
             
             
             
             }
         }
     }
 });
 
 var routeTransPoint10Combo = new Ext.form.ComboBox({
     store: routeOriginCombostore,
     fieldLabel: 'routeTransition',
     id: 'TransPoint10',
     mode: 'local',
     hidden: false,
     resizable: true,
     //forceSelection: true,
     emptyText: 'Select Route Transition Point 10',
     blankText: 'Select Route Transition Point 10',
     selectOnFocus: true,
     //allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             
             custId = Ext.getCmp('custmastcomboId').getValue();
             checkFunction('TransPoint10');
             
             }
         }
     }
 });
 
 
 var routeDestinationCombostore = new Ext.data.JsonStore({
    url:'<%=request.getContextPath()%>/CargoManagementAction.do?param=getHubs',
				   id:'HubStoreId',
			       root: 'HubRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['HubId','HubName']
 });
 
 var routeDestinationCombo = new Ext.form.ComboBox({
     store: routeDestinationCombostore,
     fieldLabel: 'routeDestination',
     id: 'routeDestinationid',
     mode: 'local',
     hidden: false,
     resizable: true,
     forceSelection: true,
     emptyText: 'Select Route Destination',
     blankText: 'Select Route Destination',
     selectOnFocus: true,
     allowBlank: false,
     typeAhead: true,
     triggerAction: 'all',
     lazyRender: true,
     valueField: 'HubId',
     displayField: 'HubName',
     cls: 'selectstylePerfect',
     listeners: {
         select: {
             fn: function () {
             custId = Ext.getCmp('custmastcomboId').getValue();
             }
         }
     }
 });
 
 
 				function checkFunction(currentid)
 				    {
 				    
                     if  (Ext.getCmp(currentid).getValue() == Ext.getCmp('routeOriginid').getValue())
                     {
                   	     Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  (Ext.getCmp(currentid).getValue() == Ext.getCmp('routeDestinationid').getValue())
                     {
                   		 Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  ((currentid.toString() != 'TransPoint1')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('TransPoint1').getValue()))
                     {
                    	 Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  ((currentid.toString() != 'TransPoint2')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('TransPoint2').getValue()))
                     {
                    	 Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  ((currentid.toString() != 'TransPoint3')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('TransPoint3').getValue()))
                     {
                         Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  ((currentid.toString()!= 'TransPoint4')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('TransPoint4').getValue()))
                     {
                     	 Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  ((currentid.toString() != 'TransPoint5')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('TransPoint5').getValue()))
                     {
                   	 	 Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  ((currentid.toString() != 'TransPoint6')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('TransPoint6').getValue()))
                     {
                    	 Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     
                     if  ((currentid.toString() != 'TransPoint7')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('TransPoint7').getValue()))
                     {
                    	 Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString()!= 'TransPoint8')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('TransPoint8').getValue()))
                     {
                    	 Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'TransPoint9')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('TransPoint9').getValue()))
                     {
                    	 Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     if  ((currentid.toString() != 'TransPoint10')&&(Ext.getCmp(currentid).getValue() == Ext.getCmp('TransPoint10').getValue()))
                     {
                    	 Ext.example.msg("Already Exists");
                         Ext.getCmp(currentid).reset();
                         Ext.getCmp(currentid).focus();
                         return;
                     }
                     }
                     
                    
                     
 
 
 
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
             text: '<%=CustomerName%>' + ' :',
             cls: 'labelstyle'
         },
         custnamecombo
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
             header: "<span style=font-weight:bold;>Route Code</span>",
             dataIndex: 'routeCodeIndex',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Route Name</span>",
             dataIndex: 'routeNameIndex',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Route Origin</span>",
             dataIndex: 'routeOriginIndex',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Route Destination</span>",
             dataIndex: 'routeDestinationIndex',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Total Time (hr)</span>",
             dataIndex: 'totalTimeIndex',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Approximate Distance (km)</span>",
             dataIndex: 'approximateDistanceIndex',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;>Average Speed (km/h)</span>",
             dataIndex: 'averageSpeedIndex',
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

 var userGrid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 60, 400, 10, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', false, 'Excel', '', '', false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, '');

 


 //**************************** Grid Panel Config ends here**********************************
 //**************************** Grid Form config starts here*********************************
 Ext.ns('App', 'App.user');
 

  var innerPanelForCloseTripDetails = new Ext.form.FormPanel({
     standardSubmit: true,
     collapsible: false,
     autoScroll: true,
     height: 335,
     width: 735,
     frame: true,
     id: 'custMaster',
     layout: 'table',
     layoutConfig: {
         columns: 8
     },
     items: [{
         xtype: 'fieldset',
         title: 'Information',
         cls: 'fieldsetpanel',
         collapsible: false,
         colspan: 9,
         id: 'addpanelid',
         width: 700,
         layout: 'table',
         layoutConfig: {
             columns: 8
         },
         items: [ {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskId'
             },
         	 {
                 xtype: 'label',
                 text: 'Route Code' + ' :',
                 cls: 'labelstyle',
                 id: 'typeTxtId'
             },
              {
                xtype: 'textfield',
                emptyText:'Enter Route Code',
                allowBlank: false,
                blankText :'',
                cls: 'textrnumberstyle',
                id: 'routeCodeid'
            },
             {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskId2'
             },
             {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskId3'
             },
              {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskId1'
             },{
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskId4'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTaskId5'
             },
             
             
             {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatoryrouteId'
             },
              {
                 xtype: 'label',
                 text: 'Route Name' + ' :',
                 cls: 'labelstyle',
                 id: 'routeTxtId'
             }, 
             {
                xtype: 'textfield',
                emptyText:'Enter Route Name',
                allowBlank: false,
                blankText :'',
                cls: 'textrnumberstyle',
                id: 'routeNameid'
            },   {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryrouteId2'
             },  {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryrouteId3'
             }, {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryrouteId1'
             },{
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryrouteId4'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryrouteId5'
             },
             
             
             {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatoryStartTimeId'
             },
             {
                 xtype: 'label',
                 text: 'Route Origin' + ' :',
                 cls: 'labelstyle',
                 id: 'starttimeTxtId'
             }, 
             routeOriginCombo,   {
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryStartTimeId4'
             },{
                 xtype: 'textfield',
                // inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
              //   blankText :'00:00',
                 width: 80,
                 id: 'originArrivalId'
             }, {
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryTStartTimeId5'
             }, {
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'originDepartureId'
             }, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryTStartTimeId1'
             },
             
             {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint1Id1'
             },
             {
                 xtype: 'label',
                 text: 'Transition Point 1' + ' :',
                 cls: 'labelstyle',
                 id: 'routepoint1Id'
             },
             routeTransPoint1Combo,{
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint1Id4'
             }, {
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                 //blankText :'00:00',
                 width: 80,
                 id: 'arrivalId1'
             },{
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint1Id5'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                 //blankText :'00:00',
                 width: 80,
                 id: 'departId1'
             },
              {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint1Id'
             },
             
              {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint2Id'
             },
             {
                 xtype: 'label',
                 text: 'Transition Point 2' + ' :',
                 cls: 'labelstyle',
                 id: 'routepoint2Id'
             }, 
             routeTransPoint2Combo, {
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint2Id4'
             },{
                xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                 // blankText :'00:00',
                 width: 80,
                 id: 'arrivalId2'
             },{
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint2Id5'
             },{
                xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                 //blankText :'00:00',
                 width: 80,
                 id: 'departId2'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint2Id1'
             },
             
              {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint3Id'
             },
             {
                 xtype: 'label',
                 text: 'Transition Point 3' + ' :',
                 cls: 'labelstyle',
                 id: 'routepoint3Id'
             }, 
             routeTransPoint3Combo,{
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint3Id4'
             }, {
                xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                 //blankText :'00:00',
                 width: 80,
                 id: 'arrivalId3'
             }, {
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint3Id5'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)', 
                 emptyText:'00:00',
                // allowBlank: false,
                 //blankText :'00:00',
                 width: 80,
                 id: 'departId3'
             }, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint3Id1'
             },
            
             
              {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint4Id'
             },
             {
                 xtype: 'label',
                 text: 'Transition Point 4' + ' :',
                 cls: 'labelstyle',
                 id: 'routepoint4Id'
             }, 
             routeTransPoint4Combo, {
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint4Id4'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                 //blankText :'00:00',
                 width: 80,
                 id: 'arrivalId4'
             }, {
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint4Id5'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                 //blankText :'00:00',
                 width: 80,
                 id: 'departId4'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint4Id1'
             }, 
             
              {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint5Id'
             },
             {
                 xtype: 'label',
                 text: 'Transition Point 5' + ' :',
                 cls: 'labelstyle',
                 id: 'routepoin5tId'
             }, 
             routeTransPoint5Combo, {
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint5Id4'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                 //blankText :'00:00',
                 width: 80,
                 id: 'arrivalId5'
             },{
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint5Id5'
             },{
                xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'departId5'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint5Id1'
             },
             
             
             
              {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint6Id'
             },
             {
                 xtype: 'label',
                 text: 'Transition Point 6' + ' :',
                 cls: 'labelstyle',
                 id: 'routepoint6Id'
             }, 
             routeTransPoint6Combo,
             {
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint6Id4'
             }, {
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                 //blankText :'00:00',
                 width: 80,
                 id: 'arrivalId6'
             },{
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint6Id5'
             },
             {
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'departId6'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint6Id1'
             },
             
             
             
              {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint7Id'
             },
             {
                 xtype: 'label',
                 text: 'Transition Point 7' + ' :',
                 cls: 'labelstyle',
                 id: 'routepoint7Id'
             },
             routeTransPoint7Combo,
             {
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint7Id4'
             },
             {
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'arrivalId7'
             },{
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint7Id5'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'departId7'
             }, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint7Id1'
             },
        
              {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint8Id'
             },
             {
                 xtype: 'label',
                 text: 'Transition Point 8' + ' :',
                 cls: 'labelstyle',
                 id: 'routepoint8Id'
             }, 
             routeTransPoint8Combo,
             {
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint8Id4'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                 //blankText :'00:00',
                 width: 80,
                 id: 'arrivalId8'
             },{
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint8Id5'
             },{
                xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'departId8'
             }, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint8Id1'
             },
             
             
             
              {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint9Id'
             },
             {
                 xtype: 'label',
                 text: 'Transition Point 9' + ' :',
                 cls: 'labelstyle',
                 id: 'routepoint9Id'
             }, 
             routeTransPoint9Combo,
              {
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint9Id4'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'arrivalId9'
             },{
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint9Id5'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'departId9'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint9Id1'
             },
             
              {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint10Id'
             },
             {
                 xtype: 'label',
                 text: 'Transition Point 10' + ' :',
                 cls: 'labelstyle',
                 id: 'routepoint10Id'
             }, 
             routeTransPoint10Combo,
             {
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint10Id4'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'arrivalId10'
             },{
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatoryroutepoint10Id5'
             },
             {
                xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                // allowBlank: false,
                //blankText :'00:00',
                 width: 80,
                 id: 'departId10'
             }, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryroutepoint10Id1'
             },
             {
             
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatorydestId'
             },
             {
                 xtype: 'label',
                 text: 'Route Destination' + ' :',
                 cls: 'labelstyle',
                 id: 'destId'
             }, 
             routeDestinationCombo,{
                 xtype: 'label',
                 text: ' Arrival' + ' ',
                 cls:'lblfield',
                 id: 'mandatorydestId4'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'destArrivalId'
             },{
                 xtype: 'label',
                 text: 'Departure' + ' ',
                 cls:'lblfield',
                 id: 'mandatorydestId5'
             },{
                 xtype: 'textfield',
                 //inputType:'time',
                 regex:/^([0-1]?[0-9]|2[0-4]):([0-5][0-9])(:[0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 emptyText:'00:00',
                 //allowBlank: false,
                // blankText :'00:00',
                 width: 80,
                 id: 'destDepartId'
             }, {
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorydestId1'
             },
             
             
             {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatorytotalId'
             },
              {
                 xtype: 'label',
                 text: 'Total Time (hr)' + ' :',
                 cls: 'labelstyle',
                 id: 'totalId'
             }, 
             {
                xtype: 'textfield',
                emptyText:'Enter Total Time',
                allowBlank: false,
                blankText :'',
                cls: 'textrnumberstyle',
                id: 'totalTimeid'
                
                
            },  {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorytotalId2'
             }, {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorytotalId3'
             }, {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorytotalId4'
             }, {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorytotalId5'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorytotalId1'
             },
             
             
             {
                xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatorydistId'
             },
              {
                 xtype: 'label',
                 text: 'Approximate Distance(km)' + ':',
                 cls: 'labelstyle',
                 id: 'distId'
             }, 
             {
                xtype: 'textfield',
                allowBlank: false,
                blankText :'',
                cls: 'textrnumberstyle',
                id: 'approxDistanceid',
                enableKeyEvents: true, 
                listeners: {
                     keypress: function(obj, e)  {
                     if (Ext.getCmp('totalTimeid').getValue() == "" || Ext.getCmp('totalTimeid').getValue() == 0) {
                    	 Ext.example.msg("Enter Time");
                         Ext.getCmp('totalTimeid').focus();
                         return;
                         }                        
                         speed = Ext.getCmp('approxDistanceid').getValue('approximateDistanceIndex')/Ext.getCmp('totalTimeid').getValue('totalTimeIndex');
                         Ext.getCmp('averageSpeedid').setValue(speed.toFixed(2));
                     },
                     change : function(field, newValue,oldValue)  {
                     if (Ext.getCmp('totalTimeid').getValue() == "" || Ext.getCmp('totalTimeid').getValue() == 0) {
                    	 Ext.example.msg("Enter Time");
                         Ext.getCmp('totalTimeid').focus();
                         return;
                         }                        
                         speed = Ext.getCmp('approxDistanceid').getValue('approximateDistanceIndex')/Ext.getCmp('totalTimeid').getValue('totalTimeIndex');
                         Ext.getCmp('averageSpeedid').setValue(speed.toFixed(2));
                     }
                 }
                 
				
            }, {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorydistId2'
             },{
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorydistId3'
             }, {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorydistId4'
             },{
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorydistId5'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatorydistId1'
             },
             
             
             {
                 xtype: 'label',
                 text: '*',
                 cls: 'mandatoryfield',
                 id: 'mandatoryspeedId'
             },
             {
                 xtype: 'label',
                 text: 'Average Speed (km/h)' + ':',
                 cls: 'labelstyle',
                 id: 'speedId'
             }, 
             {
                xtype: 'textfield',
                emptyText:'Average Speed',
                disabled:true,
                blankText :'',
                cls: 'textrnumberstyle',
                id: 'averageSpeedid'
                
                
            },  {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryspeedId2'
             }, {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryspeedId3'
             }, {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryspeedId4'
             }, {
                 xtype: '',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryspeedId5'
             },{
                 xtype: 'label',
                 text: '',
                 cls: 'mandatoryfield',
                 id: 'mandatoryspeedId1'
             },{
                 xtype: 'textfield',
                 hidden:true,
                 cls: 'mandatoryfield',
                 id: 'routeId'
             }
        ]
     }]
 });

 var innerWinButtonPanelForCloseTrip = new Ext.Panel({
     id: 'winbuttonid',
     standardSubmit: true,
     collapsible: false,
     autoHeight: true,
     height: 400,
     width: 750,
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
                     if (Ext.getCmp('routeCodeid').getValue() == "") {
                    	 Ext.example.msg("Enter Route Code");
                         Ext.getCmp('routeCodeid').focus();
                         return;
                     }
                     if (Ext.getCmp('routeNameid').getValue() == "") {
                     	 Ext.example.msg("Enter Route Name");
                    	 Ext.getCmp('routeNameid').focus();
                         return;
                     }
                     if (Ext.getCmp('routeOriginid').getValue() == "") {
                  		 Ext.example.msg("Enter Route Origin");
                    	 Ext.getCmp('routeOriginid').focus();
                         return;
                     }
<!--                    if (Ext.getCmp('originArrivalId').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Origin Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('originArrivalId').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('originDepartureId').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Origin Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('originDepartureId').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('arrivalId1').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point1 Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('arrivalId1').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('departId1').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point1 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('departId1').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('arrivalId2').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point2 Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('arrivalId2').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('departId2').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point2 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('departId2').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('arrivalId3').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point3 Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('arrivalId3').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('departId3').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point3 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('departId3').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('arrivalId4').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point4 Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('arrivalId4').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('departId4').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point4 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('departId4').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('arrivalId5').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point5 Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('arrivalId5').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('departId5').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point5 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('departId5').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('arrivalId6').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point6 Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('arrivalId6').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('departId6').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point6 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('departId6').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('arrivalId7').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point7 Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('arrivalId7').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('departId7').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point7 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('departId7').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('arrivalId8').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point8 Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('arrivalId8').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('departId8').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point8 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('departId8').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('arrivalId9').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point9 Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('arrivalId9').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('departId9').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point9 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('departId9').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('arrivalId10').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point10 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('arrivalId10').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('departId10').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point10 Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('departId10').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('destArrivalId').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Destination Arrival Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('destArrivalId').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                    if (Ext.getCmp('destDepartId').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Destination Departure Time'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('destDepartId').focus();-->
<!--                         return;-->
<!--                     }-->
                    

<!--                     if (Ext.getCmp('TransPoint2').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point 2'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('TransPoint2').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                     if (Ext.getCmp('TransPoint3').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point 3'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('TransPoint3').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                     if (Ext.getCmp('TransPoint4').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point 4'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('TransPoint4').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                     if (Ext.getCmp('TransPoint5id').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point 5'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('TransPoint5').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                     if (Ext.getCmp('TransPoint6').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point 6'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('TransPoint6').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                     if (Ext.getCmp('TransPoint7').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point 7'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('TransPoint7').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                     if (Ext.getCmp('TransPoint8').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point 8'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('TransPoint8').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                     if (Ext.getCmp('TransPoint9').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point 9'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('TransPoint9').focus();-->
<!--                         return;-->
<!--                     }-->
<!--                     if (Ext.getCmp('TransPoint10').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Transition Point 10'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('TransPoint10').focus();-->
<!--                         return;-->
<!--                     }-->
                     if (Ext.getCmp('routeDestinationid').getValue() == "") {
                    	 Ext.example.msg("Enter Route Destination");
                         Ext.getCmp('routeDestinationid').focus();
                         return;
                     }
                     if (Ext.getCmp('totalTimeid').getValue() == "") {
                    	 Ext.example.msg("Enter Total Time");
                         Ext.getCmp('totalTimeid').focus();
                         return;
                     }
                     if (Ext.getCmp('approxDistanceid').getValue() == "") {
                         Ext.example.msg("Enter Approximate Distance");
                         Ext.getCmp('approxDistanceid').focus();
                         return;
                     }
<!--                     if (Ext.getCmp('averageSpeedid').getValue() == "") {-->
<!--                         ctsb.setStatus({-->
<!--                             text: getMessageForStatus('Enter Average Speed'),-->
<!--                             iconCls: '',-->
<!--                             clear: true-->
<!--                         });-->
<!--                         Ext.getCmp('averageSpeedid').focus();-->
<!--                         return;-->
<!--                     }-->
                        
                         if (buttonvalue == 'Modify') {
                             var selected = userGrid.getSelectionModel().getSelected();
                             
                           }
                         if(innerPanelForCloseTripDetails.getForm().isValid()) {
                         closeTripOuterPanelWindow.getEl().mask();
                         Ext.Ajax.request({
                             url: '<%=request.getContextPath()%>/CargoManagementAction.do?param=RouteSkeletonsaveormodifyContainer',
                             method: 'POST',
                             params: {
                                 buttonvalue: buttonvalue,
                                 routeCodeId:Ext.getCmp('routeId').getValue(),
                                 custID: Ext.getCmp('custmastcomboId').getValue(),
                                 routeCode: Ext.getCmp('routeCodeid').getValue(),
                                 routeName: Ext.getCmp('routeNameid').getValue(),
                                 routeOrigin: Ext.getCmp('routeOriginid').getValue(),
                                 originArrival: Ext.getCmp('originArrivalId').getValue(),
                                 originDeparture: Ext.getCmp('originDepartureId').getValue(),
                                 transpointArrival1: Ext.getCmp('arrivalId1').getValue(),
                                 transpointDeparture1: Ext.getCmp('departId1').getValue(),
                                 transpointArrival2: Ext.getCmp('arrivalId2').getValue(),
                                 transpointDeparture2: Ext.getCmp('departId2').getValue(),
                                 transpointArrival3: Ext.getCmp('arrivalId3').getValue(),
                                 transpointDeparture3: Ext.getCmp('departId3').getValue(),
                                 transpointArrival4: Ext.getCmp('arrivalId4').getValue(),
                                 transpointDeparture4: Ext.getCmp('departId4').getValue(),
                                 transpointArrival5: Ext.getCmp('arrivalId5').getValue(),
                                 transpointDeparture5: Ext.getCmp('departId5').getValue(),
                                 transpointArrival6: Ext.getCmp('arrivalId6').getValue(),
                                 transpointDeparture6: Ext.getCmp('departId6').getValue(),
                                 transpointArrival7: Ext.getCmp('arrivalId7').getValue(),
                                 transpointDeparture7: Ext.getCmp('departId7').getValue(),
                                 transpointArrival8: Ext.getCmp('arrivalId8').getValue(),
                                 transpointDeparture8: Ext.getCmp('departId8').getValue(),
                                 transpointArrival9: Ext.getCmp('arrivalId9').getValue(),
                                 transpointDeparture9: Ext.getCmp('departId9').getValue(),
                                 transpointArrival10: Ext.getCmp('arrivalId10').getValue(),
                                 transpointDeparture10: Ext.getCmp('departId10').getValue(),
                                 destArrival: Ext.getCmp('destArrivalId').getValue(),
                                 destDeparture: Ext.getCmp('destDepartId').getValue(),
                                 TransPoint1: Ext.getCmp('TransPoint1').getValue(),
                                 TransPoint2: Ext.getCmp('TransPoint2').getValue(),
                                 TransPoint3: Ext.getCmp('TransPoint3').getValue(),
                                 TransPoint4: Ext.getCmp('TransPoint4').getValue(),
                                 TransPoint5: Ext.getCmp('TransPoint5').getValue(),
                                 TransPoint6: Ext.getCmp('TransPoint6').getValue(),
                                 TransPoint7: Ext.getCmp('TransPoint7').getValue(),
                                 TransPoint8: Ext.getCmp('TransPoint8').getValue(),
                                 TransPoint9: Ext.getCmp('TransPoint9').getValue(),
                                 TransPoint10: Ext.getCmp('TransPoint10').getValue(),
                                 routeDestination: Ext.getCmp('routeDestinationid').getValue(),
                                 totalTime: Ext.getCmp('totalTimeid').getValue(),
                                 approxDistance: Ext.getCmp('approxDistanceid').getValue(),
                                 averageSpeed: Ext.getCmp('averageSpeedid').getValue()
                                
                             },
                             success: function (response, options) {
                               closereportflag = false;
                                 
                                 routeOriginCombostore.load({
                     					params: {
                         						CustId: Ext.getCmp('custmastcomboId').getValue(),
                         						LTSPId: <%= systemID %>
                     							}
                 					});

                 				routeDestinationCombostore.load({
                     				params: {
                         						CustId: Ext.getCmp('custmastcomboId').getValue(),
                         						LTSPId: <%= systemID %>
                     						}
                 					});

                                 Ext.getCmp('routeCodeid').reset();
                                 Ext.getCmp('routeNameid').reset();
                                 Ext.getCmp('routeOriginid').reset();
                                 Ext.getCmp('originArrivalId').reset(),
                                 Ext.getCmp('originDepartureId').reset(),
                                 Ext.getCmp('arrivalId1').reset(),
                                 Ext.getCmp('departId1').reset(),
                                 Ext.getCmp('arrivalId2').reset(),
                                 Ext.getCmp('departId2').reset(),
                                 Ext.getCmp('arrivalId3').reset(),
                                 Ext.getCmp('departId3').reset(),
                                 Ext.getCmp('arrivalId4').reset(),
                                 Ext.getCmp('departId4').reset(),
                                 Ext.getCmp('arrivalId5').reset(),
                                 Ext.getCmp('departId5').reset(),
                                 Ext.getCmp('arrivalId6').reset(),
                                 Ext.getCmp('departId6').reset(),
                                 Ext.getCmp('arrivalId7').reset(),
                                 Ext.getCmp('departId7').reset(),
                                 Ext.getCmp('arrivalId8').reset(),
                                 Ext.getCmp('departId8').reset(),
                                 Ext.getCmp('arrivalId9').reset(),
                                 Ext.getCmp('departId9').reset(),
                                 Ext.getCmp('arrivalId10').reset(),
                                 Ext.getCmp('departId10').reset(),
                                 Ext.getCmp('destArrivalId').reset(),
                                 Ext.getCmp('destDepartId').reset(),
                                 Ext.getCmp('TransPoint1').reset();
                                 Ext.getCmp('TransPoint2').reset();
                                 Ext.getCmp('TransPoint3').reset();
                                 Ext.getCmp('TransPoint4').reset();
                                 Ext.getCmp('TransPoint5').reset();
                                 Ext.getCmp('TransPoint6').reset();
                                 Ext.getCmp('TransPoint7').reset();
                                 Ext.getCmp('TransPoint8').reset();
                                 Ext.getCmp('TransPoint9').reset();
                                 Ext.getCmp('TransPoint10').reset();
                                 Ext.getCmp('routeDestinationid').reset();
                                 Ext.getCmp('totalTimeid').reset();
                                 Ext.getCmp('approxDistanceid').reset();
                                 Ext.getCmp('averageSpeedid').reset();
                                 myWin.hide();
                                 closeTripOuterPanelWindow.getEl().unmask();
                              
                                 var message=response.responseText;
                                 Ext.example.msg(message);
                                
                                 custmastcombostore.reload();
                                 store.load({
                                     params: {
                                         custID: Ext.getCmp('custmastcomboId').getValue(),
                                        
                                      
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
                         
                         }else{
                                 Ext.example.msg("Invalid format");
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
     width: 750,
     height: 450,
     standardSubmit: true,
     frame: true,
     items: [innerPanelForCloseTripDetails, innerWinButtonPanelForCloseTrip]
 });

 myWin = new Ext.Window({
     title: titelForInnerPanel,
     closable: false,
     resizable: false,
     modal: true,
     autoScroll: false,
     height: 450,
     width: 750,
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
     myWin.setPosition(300, 70);
     myWin.show();
     myWin.setTitle(titelForInnerPanel);
     Ext.getCmp('routeCodeid').reset();
     Ext.getCmp('routeNameid').reset();
     Ext.getCmp('routeOriginid').reset();
     Ext.getCmp('originArrivalId').reset(),
     Ext.getCmp('originDepartureId').reset(),
     Ext.getCmp('arrivalId1').reset(),
     Ext.getCmp('departId1').reset(),
     Ext.getCmp('arrivalId2').reset(),
     Ext.getCmp('departId2').reset(),
     Ext.getCmp('arrivalId3').reset(),
     Ext.getCmp('departId3').reset(),
     Ext.getCmp('arrivalId4').reset(),
     Ext.getCmp('departId4').reset(),
     Ext.getCmp('arrivalId5').reset(),
     Ext.getCmp('departId5').reset(),
     Ext.getCmp('arrivalId6').reset(),
     Ext.getCmp('departId6').reset(),
     Ext.getCmp('arrivalId7').reset(),
     Ext.getCmp('departId7').reset(),
     Ext.getCmp('arrivalId8').reset(),
     Ext.getCmp('departId8').reset(),
     Ext.getCmp('arrivalId9').reset(),
     Ext.getCmp('departId9').reset(),
     Ext.getCmp('arrivalId10').reset(),
     Ext.getCmp('departId10').reset(),
     Ext.getCmp('destArrivalId').reset(),
     Ext.getCmp('destDepartId').reset(),
     Ext.getCmp('TransPoint1').reset();
     Ext.getCmp('TransPoint2').reset();
     Ext.getCmp('TransPoint3').reset();
     Ext.getCmp('TransPoint4').reset();
	 Ext.getCmp('TransPoint5').reset();
     Ext.getCmp('TransPoint6').reset();
     Ext.getCmp('TransPoint7').reset();
     Ext.getCmp('TransPoint8').reset();
     Ext.getCmp('TransPoint9').reset();
     Ext.getCmp('TransPoint10').reset();
     Ext.getCmp('routeDestinationid').reset();
     Ext.getCmp('totalTimeid').reset();
     Ext.getCmp('approxDistanceid').reset();
     Ext.getCmp('averageSpeedid').reset();
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
     var value = selected.get(userGrid.getColumnModel().getDataIndex(6));
    
     if (value == 'Closed') {
			     Ext.example.msg("<%=RecordHasBeenClosedSoUnableToModify%>");
        		 return;
     }

     buttonvalue = '<%=Modify%>';
     titelForInnerPanel = '<%=ModifyDetails%>';
     myWin.setPosition(300, 70);
     myWin.setTitle(titelForInnerPanel);
     myWin.show();
     
     Ext.getCmp('routeCodeid').show();
     Ext.getCmp('routeNameid').show();
     Ext.getCmp('routeOriginid').show();
     Ext.getCmp('originArrivalId').show(),
     Ext.getCmp('originDepartureId').show(),
     Ext.getCmp('arrivalId1').show(),
     Ext.getCmp('departId1').show(),
     Ext.getCmp('arrivalId2').show(),
     Ext.getCmp('departId2').show(),
     Ext.getCmp('arrivalId3').show(),
     Ext.getCmp('departId3').show(),
     Ext.getCmp('arrivalId4').show(),
     Ext.getCmp('departId4').show(),
     Ext.getCmp('arrivalId5').show(),
     Ext.getCmp('departId5').show(),
     Ext.getCmp('arrivalId6').show(),
     Ext.getCmp('departId6').show(),
     Ext.getCmp('arrivalId7').show(),
     Ext.getCmp('departId7').show(),
     Ext.getCmp('arrivalId8').show(),
     Ext.getCmp('departId8').show(),
     Ext.getCmp('arrivalId9').show(),
     Ext.getCmp('departId9').show(),
     Ext.getCmp('arrivalId10').show(),
     Ext.getCmp('departId10').show(),
     Ext.getCmp('destArrivalId').show(),
     Ext.getCmp('destDepartId').show(),
     Ext.getCmp('TransPoint1').show();
     Ext.getCmp('TransPoint2').show();
     Ext.getCmp('TransPoint3').show();
     Ext.getCmp('TransPoint4').show();
     Ext.getCmp('TransPoint5').show();
     Ext.getCmp('TransPoint6').show();
     Ext.getCmp('TransPoint7').show();
     Ext.getCmp('TransPoint8').show();
     Ext.getCmp('TransPoint9').show();
     Ext.getCmp('TransPoint10').show();
     Ext.getCmp('routeDestinationid').show();
     Ext.getCmp('totalTimeid').show();
     Ext.getCmp('approxDistanceid').show();
     Ext.getCmp('averageSpeedid').disable();
     Ext.getCmp('averageSpeedid').reset();
     
     
     var selected = userGrid.getSelectionModel().getSelected();
     Ext.getCmp('routeCodeid').setValue(selected.get('routeCodeIndex'));
     Ext.getCmp('routeNameid').setValue(selected.get('routeNameIndex'));
     Ext.getCmp('routeOriginid').setValue(selected.get('originidIndex'));
     Ext.getCmp('originArrivalId').setValue(selected.get('originArrivalIndex'));
     Ext.getCmp('originDepartureId').setValue(selected.get('originDepartIndex'));
     Ext.getCmp('destArrivalId').setValue(selected.get('destArrivalIndex'));
     Ext.getCmp('destDepartId').setValue(selected.get('destDepartIndex'));
     Ext.getCmp('TransPoint1').setValue(selected.get('transPoint1Index'));
    // alert(selected.get('transArrival10Index'));
     Ext.getCmp('TransPoint2').setValue(selected.get('transPoint2Index'));
     Ext.getCmp('TransPoint3').setValue(selected.get('transPoint3Index'));
     Ext.getCmp('TransPoint4').setValue(selected.get('transPoint4Index'));
     Ext.getCmp('TransPoint5').setValue(selected.get('transPoint5Index'));
     Ext.getCmp('TransPoint6').setValue(selected.get('transPoint6Index'));
     Ext.getCmp('TransPoint7').setValue(selected.get('transPoint7Index'));
     Ext.getCmp('TransPoint8').setValue(selected.get('transPoint8Index'));
     Ext.getCmp('TransPoint9').setValue(selected.get('transPoint9Index'));
     Ext.getCmp('TransPoint10').setValue(selected.get('transPoint10Index'));
     Ext.getCmp('arrivalId1').setValue(selected.get('transArrival1Index'));
     Ext.getCmp('departId1').setValue(selected.get('transDepart1Index'));
     Ext.getCmp('arrivalId2').setValue(selected.get('transArrival2Index'));
     Ext.getCmp('departId2').setValue(selected.get('transDepart2Index'));
     Ext.getCmp('arrivalId3').setValue(selected.get('transArrival3Index'));
     Ext.getCmp('departId3').setValue(selected.get('transDepart3Index'));
     Ext.getCmp('arrivalId4').setValue(selected.get('transArrival4Index'));
     Ext.getCmp('departId4').setValue(selected.get('transDepart4Index'));
     Ext.getCmp('arrivalId5').setValue(selected.get('transArrival5Index'));
     Ext.getCmp('departId5').setValue(selected.get('transDepart5Index'));
     Ext.getCmp('arrivalId6').setValue(selected.get('transArrival6Index'));
     Ext.getCmp('departId6').setValue(selected.get('transDepart6Index'));
     Ext.getCmp('arrivalId7').setValue(selected.get('transArrival7Index'));
     Ext.getCmp('departId7').setValue(selected.get('transDepart7Index'));
     Ext.getCmp('arrivalId8').setValue(selected.get('transArrival8Index'));
     Ext.getCmp('departId8').setValue(selected.get('transDepart8Index'));
     Ext.getCmp('arrivalId9').setValue(selected.get('transArrival9Index'));
     Ext.getCmp('departId9').setValue(selected.get('transDepart9Index'));
     Ext.getCmp('arrivalId10').setValue(selected.get('transArrival10Index'));
     Ext.getCmp('departId10').setValue(selected.get('transDepart10Index'));
     Ext.getCmp('routeDestinationid').setValue(selected.get('destidIndex'));
     Ext.getCmp('totalTimeid').setValue(selected.get('totalTimeIndex'));
     Ext.getCmp('approxDistanceid').setValue(selected.get('approximateDistanceIndex'));
     Ext.getCmp('averageSpeedid').setValue(selected.get('averageSpeedIndex'));
     Ext.getCmp('routeId').setValue(selected.get('routeCodeId'));
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
         title: 'Route Skeleton',
         renderTo: 'content',
         standardSubmit: true,
         frame: true,
         width:screen.width-25,
         cls: 'outerpanel',
         items: [innerPanel, gridPanel]
     });


 });
   
   </script>
  </body>
</html>