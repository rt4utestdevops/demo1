<%@ page language="java" import="java.util.*,t4u.beans.*,t4u.functions.CommonFunctions,t4u.functions.AdminFunctions,t4u.common.*" pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
 

<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();


//cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);

LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
//getting client id
int customeridlogged=loginInfo.getCustomerId();
int systemId=loginInfo.getSystemId();
int userId=loginInfo.getUserId();

int CustIdPassed=0; 
if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}
AdminFunctions af=new AdminFunctions();
ArrayList<String> columnLists = new ArrayList<String>();
  	columnLists=af.getSettingLabelColumnList();
  	
ArrayList<String> languageconvertionlabel=new ArrayList<String>();
languageconvertionlabel.add("Select_Customer");
languageconvertionlabel.add("Customer_Name");
languageconvertionlabel.add("Customer_Setting_Details");
languageconvertionlabel.add("Select_Image");
languageconvertionlabel.add("Image");
languageconvertionlabel.add("Submit");
languageconvertionlabel.add("Customer_Setting");
languageconvertionlabel.add("Saving_Form");
languageconvertionlabel.add("Select_Restrictive_Time");
languageconvertionlabel.add("Select_Live_Position_Time");
languageconvertionlabel.add("Select_Seat_Belt_Interval_Time");
languageconvertionlabel.add("Vehicle_Images");
languageconvertionlabel.add("Health_ And_Safety_Assurance");
languageconvertionlabel.add("Over_Speed_limit_Black_Top");
languageconvertionlabel.add("Over_Speed_limit_Graded");
languageconvertionlabel.add("Enter_Over_Speed_Black_Top");
languageconvertionlabel.add("Enter_Over_Speed_Limit_Graded");
languageconvertionlabel.add("Minimum_Temperature");
languageconvertionlabel.add("Maximum_Temperature");
languageconvertionlabel.add("Enter_Minimum_Temperature");
languageconvertionlabel.add("Enter_Maximum_Temperature");
languageconvertionlabel.add("Stoppage_Time_On_Trip");
languageconvertionlabel.add("Enter_Stoppage_Time_On_Trip");
languageconvertionlabel.add("Essential_Monitoring");
languageconvertionlabel.add("Stoppage_Time_Limit");
languageconvertionlabel.add("Idle_Time_Limit");
languageconvertionlabel.add("Non_Communicating_Time");
languageconvertionlabel.add("Live_Position_Time");
languageconvertionlabel.add("Advance_Monitoring");
languageconvertionlabel.add("Restrictive_Moment_Start_Time");
languageconvertionlabel.add("Restrictive_Moment_End_Time");
languageconvertionlabel.add("Restrictive_Non_Moment_Start_Time");
languageconvertionlabel.add("Restrictive_Non_Moment_End_Time");
languageconvertionlabel.add("Save");
languageconvertionlabel.add("Cancel");
languageconvertionlabel.add("AC_Idle_Time");
languageconvertionlabel.add("Distance_Near_To_Border");
languageconvertionlabel.add("Enter_Distance_Near_To_Border");
languageconvertionlabel.add("SEAT_BELT_INTERVAL");
languageconvertionlabel.add("Enter_Seat_Belt_Interval_Time");
languageconvertionlabel.add("Restrictive_Distance");
languageconvertionlabel.add("Non_Restrictive_Distance");
languageconvertionlabel.add("Add_Image");
languageconvertionlabel.add("Milk_Distribution_Logistics");
languageconvertionlabel.add("Trip");
languageconvertionlabel.add("Select_Stoppage_time");
languageconvertionlabel.add("Select_Idle_Time");
languageconvertionlabel.add("Select_Non_Communicating_Time");
languageconvertionlabel.add("Restrictive_Moment_Distance");
languageconvertionlabel.add("Seat_Belt_Distance");
languageconvertionlabel.add("Restrictive_Non_Moment_Distance");
languageconvertionlabel.add("Payment_Due_Date");
languageconvertionlabel.add("Enter_Payment_Due_Date");
languageconvertionlabel.add("Payment_Notification_Period");
languageconvertionlabel.add("Select_Restrictive_Moment_Start_Time");
languageconvertionlabel.add("Select_Restrictive_Moment_End_Time");
languageconvertionlabel.add("Enter_Restrictive_Moment_Distance");
languageconvertionlabel.add("Enter_ac_Idle_Time");
languageconvertionlabel.add("Enter_Near_Border_Distance");
languageconvertionlabel.add("Enter_Seat_Belt_Distance");
languageconvertionlabel.add("Enter_Payment_Due_Date");
languageconvertionlabel.add("Enter_Payment_Notification_Period");
languageconvertionlabel.add("Next");
languageconvertionlabel.add("Restrictive_Movement_Alert");
languageconvertionlabel.add("Seat_Belt_Alert");
languageconvertionlabel.add("Payment_Notification_Alert");
languageconvertionlabel.add("AC_Idle_Alert");
languageconvertionlabel.add("Border_Alert");
languageconvertionlabel.add("Validate_Mesg_For_Time");
languageconvertionlabel.add("Validate_Mesg_For_Form");
languageconvertionlabel.add("Subsequent_Remainder");
languageconvertionlabel.add("Subsequent_Notification");
languageconvertionlabel.add("Essential_Setting");
languageconvertionlabel.add("Idle_Alert_Setting");
languageconvertionlabel.add("Enter_Subsequent_Notification");
languageconvertionlabel.add("Work_Week");
languageconvertionlabel.add("Days");
languageconvertionlabel.add("Mon");
languageconvertionlabel.add("Tue");
languageconvertionlabel.add("Wed");
languageconvertionlabel.add("Thu");
languageconvertionlabel.add("Fri");
languageconvertionlabel.add("Sat");
languageconvertionlabel.add("Sun");
languageconvertionlabel.add("First_day_of_week");
languageconvertionlabel.add("Start_Time");
languageconvertionlabel.add("End_Time");
languageconvertionlabel.add("End_Time_Must_Be_Greater_Than_Start_Time");

languageconvertionlabel.add("Stoppage_Alert_Inside_Hub");
languageconvertionlabel.add("Validate_Mesg_For_Stoppage_Time");
languageconvertionlabel.add("Enter_Start_Time");
languageconvertionlabel.add("Enter_End_Time");

languageconvertionlabel.add("Door_Sensor_Alert");
languageconvertionlabel.add("doorsensoralerthub");

ArrayList<String> convertedWords=cf.getLanguageSpecificWordForKey(languageconvertionlabel,language);
String selCustName=convertedWords.get(0);
String custName=convertedWords.get(1);
String custSetDet=convertedWords.get(2);
String selImg=convertedWords.get(3);
String image=convertedWords.get(4);
String submit=convertedWords.get(5);
String custSet=convertedWords.get(6);
String savForm=convertedWords.get(7);
String selectrestrictivetime=convertedWords.get(8);
String selectlivepositiontime=convertedWords.get(9);
String seatbeltintervaltime=convertedWords.get(10);
String vehicleimages=convertedWords.get(11);
String healthandsafetyassurance=convertedWords.get(12);
String overspeedlimitblacktop=convertedWords.get(13);
String overspeedlimitgrade=convertedWords.get(14);
String enterOverSpeedLimitForBlackTop=convertedWords.get(15);
String enterOverSpeedLimitForGraded=convertedWords.get(16);
String minTemp=convertedWords.get(17);
String maxTemp=convertedWords.get(18);
String enterMinTemp=convertedWords.get(19);
String enterMaxTemp=convertedWords.get(20);
String stoppageTimeOnTrip=convertedWords.get(21);
String enterStoppageTimeOnTrip=convertedWords.get(22);
String essentialMonitoring=convertedWords.get(23);
String stoppageTimeLimit=convertedWords.get(24);
String idleTimeLimit=convertedWords.get(25);
String nonCommunicatingTime=convertedWords.get(26);
String livePositionTime=convertedWords.get(27);
String advanceMonitoring=convertedWords.get(28);
String restrictiveMomentStart=convertedWords.get(29);
String restrictiveMomentEnd=convertedWords.get(30);
String restrictiveNonMomentStart=convertedWords.get(31);
String restrictiveNonMomentEnd=convertedWords.get(32);
String save=convertedWords.get(33);
String cancel=convertedWords.get(34);
String acIdleTime=convertedWords.get(35);
String distancenearborder=convertedWords.get(36);
String enterDistanceNearBorder=convertedWords.get(37);
String seatBeltInterval=convertedWords.get(38);
String EnterseatBeltInterval=convertedWords.get(39);
String restrictiveDistance=convertedWords.get(40);
String nonRestrictiveDistance=convertedWords.get(41);
String addimage=convertedWords.get(42);
String milkdistributionlogistics=convertedWords.get(43);
String trip=convertedWords.get(44);
String selectstoppagetime=convertedWords.get(45);
String selectidletime=convertedWords.get(46);
String selectnoncommunicatingtime=convertedWords.get(47);
String restrictivemomentdistance=convertedWords.get(48);
String seatbeltdistance=convertedWords.get(49);
String restrictivenonmomentdistance=convertedWords.get(50);
String paymentduedate=convertedWords.get(51);
String enteraymentduedate=convertedWords.get(52);
String paymentnotificationperiod=convertedWords.get(53);
String selectrestrictivemomentstarttime=convertedWords.get(54);
String selectrestrictivemomentendtime=convertedWords.get(55);
String enterrestrictivemomentdistance=convertedWords.get(56);
String enteracidletime=convertedWords.get(57);
String nearborderdistance=convertedWords.get(58);
String enterseatbeltdistance=convertedWords.get(59);
String enterpaymentduedate=convertedWords.get(60);
String enterpaymentnotificationperiod=convertedWords.get(61);
String next=convertedWords.get(62);
String Restrictive_Movement_Alert=convertedWords.get(63);
String Seat_Belt_Alert=convertedWords.get(64);
String Payment_Notification_Alert=convertedWords.get(65);
String AC_Idle_Alert=convertedWords.get(66);
String Border_Alert=convertedWords.get(67);
String validateTime=convertedWords.get(68);
String validateMessage=convertedWords.get(69);
String subsequentRemainder=convertedWords.get(70);
String subsequentNotification=convertedWords.get(71);
String essentialSetting=convertedWords.get(72);
String idleAlertSetting=convertedWords.get(73);
String enterSubsequentNotification=convertedWords.get(74);
String workWeek=convertedWords.get(75);
String days=convertedWords.get(76);
String mon=convertedWords.get(77);
String tue=convertedWords.get(78);
String wed=convertedWords.get(79);
String thu=convertedWords.get(80);
String fri=convertedWords.get(81);
String sat=convertedWords.get(82);
String sun=convertedWords.get(83);
String firstDayOfWeek=convertedWords.get(84);
String StartTime=convertedWords.get(85);
String EndTime=convertedWords.get(86);
String endTimeMustBeGreaterThanStartTime=convertedWords.get(87);
String stoppageAlertInsideHub=convertedWords.get(88);
String validateStoppageTime=convertedWords.get(89);
String EnterStartTime=convertedWords.get(90);
String EnterEndTime=convertedWords.get(91);
String Door_Sensor_Alert=convertedWords.get(92);
String doorsensoralerthub=convertedWords.get(93);
String userAuthority=cf.getUserAuthority(systemId,userId);
String unitOfMeasure = cf.getUnitOfMeasure(systemId);


%>
<style>
	#images-view .thumb img {
 	 height: 24px !Important;
 	 width: 24px !Important;
	}

</style>
  <body>
  
   	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
  	<jsp:include page="../Common/GroupTabJS.jsp" />
	<style>
			.x-panel-body .x-form {
		 width: 1048px !important;
	}
	/*.x-panel-btns {
		width : 1301px !important;
	} */
	.x-panel-footer
	{
		width:99% !important;
	}
	.x-toolbar-right-ct{
		padding-right:24px;
	}
</style>
  <script type="text/javascript">

  
 <% if( customeridlogged > 0 && loginInfo.getIsLtsp() == -1 && !userAuthority.equalsIgnoreCase("Admin"))
{
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
}else{
%>  
  
 function disableTabElements(){
		parent.Ext.getCmp('customerInformationTab').disable(true);
		parent.Ext.getCmp('productFeaturetab').disable(true);
		parent.Ext.getCmp('userManagementTab').disable(true);
		if (parent.Ext.getCmp('userFeatureDetachmentTab')){
		parent.Ext.getCmp('userFeatureDetachmentTab').disable(true);
		}
		if (parent.Ext.getCmp('roleManagementTab')){
		parent.Ext.getCmp('roleManagementTab').disable(true);
		}
		parent.Ext.getCmp('assetGroupTab').disable(true);
		parent.Ext.getCmp('assetassociationTab').disable(true);
}
function enableTabElements(){
		parent.Ext.getCmp('customerInformationTab').enable(true);
		parent.Ext.getCmp('productFeaturetab').enable(true);
		parent.Ext.getCmp('userManagementTab').enable(true);
		if (parent.Ext.getCmp('userFeatureDetachmentTab')){
		parent.Ext.getCmp('userFeatureDetachmentTab').enable(true);
		}
		if (parent.Ext.getCmp('roleManagementTab')){
		parent.Ext.getCmp('roleManagementTab').enable(true);
		}
		parent.Ext.getCmp('assetGroupTab').enable(true);
		parent.Ext.getCmp('assetassociationTab').enable(true);
}
     
     var pageName='Customer Setting';
    var dtcur = datecur;
   var dtnext = datenext;
   var futurelis=new Array();
   var globalCustomerID=parent.globalCustomerID;
  var ctsb=new Ext.ux.StatusBar({
            defaultText: 'Ready',
            id: 'basic-statusbar',
         cls:'statusbarfontstyle',
		hasfocus:true
        })
   
    //seatbelt interval store
 var seatbeltinterval= new Ext.data.SimpleStore({
	    id:'seatbeltstoreId',
        autoLoad: true,
	    fields: ['Name','Value'],
	    data: [['0', '0'], ['5', '5'],['10', '10'],['15', '15'],['30', '30']]
      });
      
 //liveposition store
 var livepostimstore= new Ext.data.SimpleStore({
	    id:'livepositionstoreId',
        autoLoad: true,
	    fields: ['Name','Value'],
	    data: [['0', '0'], ['2', '2'],['4', '4'],['6', '6'],['12', '12'], ['24', '24']]
      });
 
//store for image
    var momenttimestore= new Ext.data.SimpleStore({
	    id:'momentstoreId',
        autoLoad: true,
	    fields: ['Name','Value'],
	    data: [['1', '2'], ['2', '2'],['3', '3'],['4', '4'],['5', '5'], ['6', '6'],['7', '7'],['8', '8'],['9', '9'], ['10', '10'],['11', '11'],['12', '12'],['13', '13'], ['14', '14'],['15', '15'],['16', '16'],['17', '17'], ['18', '18'],['19', '19'],['20', '20'],['21', '21'], ['22', '22'],['23', '23']]
      });
      
     //store for customersetting details 
    var customersettingdetails=new Ext.data.JsonStore({
         url:'<%=request.getContextPath()%>/CustomerSettingAction.do?param=getCustomerSettingDetails',
         id:'customersettinstoreid',
         root:'CustomerSettingDetailsRoot',
         autoLoad:false,
         remoteSort:true,
         fields:['CustomerId','Image','StoppageTime','IdleTime','NonCommTime','LivePositionTime','SubRemainder','SubNotification','RestMomStartTime','ResNonMomStartTime','ResMomEndTime','ResNonMomEndTime','ACIdleTime','NearBoarder','SeatBeltInt','ResDistance','NonResDis','MinTemp','MaxTemp','OverSpeedBlackTop','OverSpeedGraded','SeatBeltDistance','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday','FirstDayWeek','STime','ETime','SAlertInsideHub','Monday1','Tuesday1','Wednesday1','Thursday1','Friday1','Saturday1','Sunday1',
,'DoorSensorInt','Doorsensoralertinsidehub']
     });
   //restrictive moment start combo declaration
   
  var RestrictiveMomentStartTime=new Ext.form.ComboBox({
				        id:'RESTRICTIVE_MOMENT_START'+'field',
				        store:momenttimestore,
				        mode: 'local',
				        forceSelection: true,
				        emptyText:'<%=selectrestrictivetime%>',
				        blankText:'<%=selectrestrictivetime%>',
				        selectOnFocus:true,
				        allowBlank: true,
				        hidden:true,
				        anyMatch:true,
				        typeAhead: false,
				        triggerAction: 'all',
				        lazyRender: true,
				    	valueField: 'Value',
				    	displayField: 'Name',
				    	cls:'selectstyle' 
						});
						
  //restrictive moment end combo definition
    var RestrictiveMomentEndTime=new Ext.form.ComboBox({
				        id:'RESTRICTIVE_MOMENT_END'+'field',
				        store:momenttimestore,
				        mode: 'local',
				        forceSelection: true,
				        emptyText:'<%=selectrestrictivetime%>',
				        blankText:'<%=selectrestrictivetime%>',
				        selectOnFocus:true,
				        hidden:true,
				        allowBlank: true,
				        anyMatch:true,
				        typeAhead: false,
				        triggerAction: 'all',
				        lazyRender: true,
				    	valueField: 'Value',
				    	displayField: 'Name',
				    	cls:'selectstyle' 
						});
						
	//restrictive non moment  start time combo definition
    var RestrictiveNonMomentStartTime=new Ext.form.ComboBox({
				        id:'RESTRICTIVE_NON_MOMENT_START'+'field',
				        store:momenttimestore,
				        mode: 'local',
				        hidden:true,
				        forceSelection: true,
				        emptyText:'<%=selectrestrictivetime%>',
				        blankText:'<%=selectrestrictivetime%>',
				        selectOnFocus:true,
				        allowBlank: true,
				        anyMatch:true,
				        typeAhead: false,
				        triggerAction: 'all',
				        lazyRender: true,
				    	valueField: 'Value',
				    	displayField: 'Name',
				    	cls:'selectstyle' 
						});
						
	//restrictive non moment end time					
	var RestrictiveNonMomentEndTime=new Ext.form.ComboBox({
				        id:'resnonmomentendtimeid',
				        store:momenttimestore,
				        mode: 'local',
				        hidden:true,
				        forceSelection: true,
				        emptyText:'<%=selectrestrictivetime%>',
				        blankText:'<%=selectrestrictivetime%>',
				        selectOnFocus:true,
				        allowBlank: true,
				        anyMatch:true,
				        typeAhead: false,
				        triggerAction: 'all',
				        lazyRender: true,
				    	valueField: 'Value',
				    	displayField: 'Name',
				    	cls:'selectstyle' 
						});
						
	//live position combobox definition
	var LivePosition=new Ext.form.ComboBox({
	                    id:'LIVE_POSITION_ALERT'+'field',
				        store:livepostimstore,
				        mode: 'local',
				        forceSelection: true,
				        emptyText:'<%=selectlivepositiontime%>',
				        blankText:'<%=selectlivepositiontime%>',
				        selectOnFocus:true,
				        allowBlank: true,
				        hidden:true,
				        anyMatch:true,
				        typeAhead: false,
				        triggerAction: 'all',
				        lazyRender: true,
				    	valueField: 'Value',
				    	displayField: 'Name',
				    	cls:'selectstyle' 
						});
//seat belt combo definition
   var SeatBeltInterval=new Ext.form.ComboBox({
				        id:'SEAT_BELT_INTERVAL'+'field',
				        id:'SEAT_BELT_INTERVAL'+'field',
				        store:seatbeltinterval,
				        mode: 'local',
				        forceSelection: true,
				        emptyText:'<%=seatbeltintervaltime%>',
				        blankText:'<%=seatbeltintervaltime%>',
				        selectOnFocus:true,
				        hidden:true,
				        allowBlank: true,
				        anyMatch:true,
				        typeAhead: false,
				        triggerAction: 'all',
				        lazyRender: true,
				    	valueField: 'Value',
				    	displayField: 'Name',
				    	cls:'selectstyle' 
						});
						
	 var dayStore= new Ext.data.SimpleStore({
	    id:'daystoreId',
        autoLoad: true,
	    fields: ['id','day'],
	    data: [['0',''],['1', 'Monday'], ['2', 'Tuesday'],['3', 'Wednesday'],['4', 'Thursday'],['5', 'Friday'], ['6', 'Saturday'],['7', 'Sunday']]
      });					
						
	var FirstDay =	new Ext.form.ComboBox({
				        store:dayStore,
				        mode: 'local',
				        id:'FIRST_DAY_WEEK'+'field',
				        forceSelection: true,
				       // emptyText:'<%=seatbeltintervaltime%>',
				       // blankText:'<%=seatbeltintervaltime%>',
				        selectOnFocus:true,
				        hidden:false,
				        allowBlank: true,
				        anyMatch:true,
				        typeAhead: false,
				        triggerAction: 'all',
				       lazyRender: true,
				    	valueField: 'id',
				    	displayField: 'day',
				    	cls:'selectstyle' 
						});
						
	var timeStore= new Ext.data.SimpleStore({
	    id:'timeId',
        autoLoad: true,
	    fields: ['startId','start'],
	    data: [['0', '00:00'], ['0.3', '00:30'],['1', '01:00'],['1.3', '01:30'],['2', '02:00'],['2.3', '02:30'],['3', '03:00'],['3.3', '03:30'],['4', '04:00'],['4.3', '04:30'],['5', '05:00'],['5.3', '05:30'],
	           ['6', '06:00'],['6.3', '06:30'],['7', '07:00'],['7.3', '07:30'],['8', '08:00'],['8.3', '08:30'],['9', '09:00'],['9.3', '09:30'],['10', '10:00'],['10.3', '10:30'],['11', '11:00'],['11.3', '11:30'],
	           ['12', '12:00'],['12.3', '12:30'],['13', '13:00'],['13.3', '13:30'],['14', '14:00'],['14.3', '14:30'],['15', '15:00'],['15.3', '15:30'],['16', '16:00'],['16.3', '16:30'],['17', '17:00'],['17.3', '17:30'],
	           ['18', '18:00'],['18.3', '18:30'],['19', '19:00'],['19.3', '19:30'],['20', '20:00'],['20.3', '20:30'],['21', '21:00'],['21.3', '21:30'],['22', '22:00'],['22.3', '22:30'],['23', '23:00'],['23.3', '23:30']
	           ]
      });
      							
						
	var startTime=new Ext.form.ComboBox({
				        store:timeStore,
				        mode: 'local',
				        id:'START_TIME'+'field',
				        forceSelection: true,
				       // emptyText:'<%=seatbeltintervaltime%>',
				       // blankText:'<%=seatbeltintervaltime%>',
				        selectOnFocus:true,
				        hidden:false,
				        allowBlank: true,
				        anyMatch:true,
				        typeAhead: false,
				        triggerAction: 'all',
				       lazyRender: true,
				    	valueField: 'startId',
				    	displayField: 'start',
				    	cls:'selectstyle' 
						});	
						
	var endTime=new Ext.form.ComboBox({
				        store:timeStore,
				        mode: 'local',
				        id:'END_TIME'+'field',
				        forceSelection: true,
				       // emptyText:'<%=seatbeltintervaltime%>',
				       // blankText:'<%=seatbeltintervaltime%>',
				        selectOnFocus:true,
				        hidden:false,
				        allowBlank: true,
				        anyMatch:true,
				        typeAhead: false,
				        triggerAction: 'all',
				       lazyRender: true,
				    	valueField: 'startId',
				    	displayField: 'start',
				    	cls:'selectstyle'
				    	});						
						
								
	var xd = Ext.data;
  
    var store = new Ext.data.JsonStore({
        url:'<%=request.getContextPath()%>/CustomerAction.do?param=getVehicleImages' ,
        root: 'vehicleImagesRoot',
        autoLoad:true,
        fields: ['name', 'url']
    });
    store.load();


    var tpl = new Ext.XTemplate(
		'<tpl for=".">',
            '<div class="thumb-wrap" id="{name}">',
		    '<div class="thumb"><img src="{url}" title="{name}"/></div></div>',
        '</tpl>',
        '<div class="x-clear"></div>'
	);
  var view=new Ext.DataView({
            store: store,
            tpl: tpl,
            height:300,
            autoScroll:true,
            singleSelect: true,
            overClass:'x-view-over',
            itemSelector:'div.thumb-wrap',
            emptyText: 'No images to display',

            plugins: [
                new Ext.DataView.DragSelector(),
                new Ext.DataView.LabelEditor({dataIndex: 'name'})
            ],

            prepareData: function(data){
                data.shortName = Ext.util.Format.ellipsis(data.name, 15);
                return data;
            },
            
           listeners: {
           selectionchange: {
            		fn: function(dv,nodes){
            			var l = nodes.length;
            			
            			var s = l != 1 ? 's' : '';
            			//panel.setTitle('Simple DataView ('+l+' item'+s+' selected)');
            			selNode = view.getSelectedRecords()[0];
            			
						Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/CustomerSettingAction.do?param=saveImages',
									method: 'POST',
									params: 
									{ 
									     CustId:Ext.getCmp('custsetcomboId').getValue(),
										 ImageName:selNode.data.name,
										 pageName: pageName
							         	 
							         },
									success:function(response, options)//start of success
									{
									      Ext.example.msg(response.responseText);
										 myWin.hide();
								     enableTabElements();
								      customersettingdetails.load({
									  params:{
									  CustId:Ext.getCmp('custsetcomboId').getValue()
									  },
									  callback:function(){
									  var clientId=Ext.getCmp('custsetcomboId').getValue();
									  var image="";
									  var idx = customersettingdetails.findBy(function(record){
									  if(record.get('CustomerId') == clientId){
					    				image=record.get('Image');
									  }
									  });
									  imagefunction(image);
									  
									  }
									  
		        						});
										
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								          Ext.example.msg("error");
									 myWin.hide();
									 enableTabElements();
									} // END OF FAILURE 
						}); // END OF AJAX
		   				 
            			
            		}
            	}
            	}
        });
    var panel = new Ext.Panel({
        id:'images-view',
        frame:true,
        width:'100%',
        height:'300',
        collapsible:false,
        layout:'fit',
        title:'<%=vehicleimages%>',
        items:view
    });
    
    var calPanel=new Ext.Panel({
        id:'calview',
        frame:false,
        width:'600',
        height:'200',
        border:false,
        layout:'table',
        layoutConfig: {
			columns:4
			},
       items:[{
				xtype: 'label',
				id:'lday',
				cls:'labellargestyle',
				hidden:false,
				text:'<%=firstDayOfWeek%>'+':'
				},{width:80},
				FirstDay,{width:40},
				{
				xtype: 'label',
				id:'lstime',
				cls:'labellargestyle',
				hidden:false,
				text:'<%=StartTime%>'+':'
				},{width:80},
				startTime,{width:40},
				{
				xtype: 'label',
				id:'letime',
				cls:'labellargestyle',
				hidden:false,
				text:'<%=EndTime%>'+':'
				},{width:70},endTime
			  
	    		]
    });
    
    
    
    
        var restrictiveMovementAlertPanel=new Ext.Panel({
        id:'restrictiveMovementAlertPanelId',
        frame:false,
        width:'600',
        height:'200',
        border:false,
        layout:'table',
        layoutConfig: {
			columns:5
			},
       items:[{
				xtype: 'label',
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				id:'RESTRICTIVE_MOMENT_START'+'label',				
				text:'<%=restrictiveMomentStart%>  :'
				},
				{width:90},
				{
                 xtype: 'textfield',
                 regex:/^([0-1][0-9]|2[0-3]):([0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 cls: 'selectstylePerfect',
                 id: 'dateId',
                 emptyText:'<%=EnterStartTime%>',
                 blankText:'<%=EnterStartTime%>'
                 
				},{width:18},
				{
	    		html:'',
	    		html:'(HH:MM)',
	    		hidden:true,
	    		id:'RESTRICTIVE_MOMENT_START'+'htm'
	    		},
	    		
	    		
	    		
	    		{
				xtype: 'label',
				id:'RESTRICTIVE_MOMENT_END'+'label',
				cls:'labellargestyle',
				hidden:true,
				text:'<%=restrictiveMomentEnd%>  :'
				},{width:90},
				{
                 xtype: 'textfield',
                 regex:/^([0-1][0-9]|2[0-3]):([0-5][0-9])?$/,
                 regexText:'Enter valid format eg,(HH:MM)',
                 cls: 'selectstylePerfect',
                 id: 'dateId2',
                 emptyText:'<%=EnterEndTime%>',
                 blankText:'<%=EnterEndTime%>'
                 //allowBlank:false
                 
 				
				},{width:18},
				{
	    		html:'',
	    		html:'(HH:MM)',
	    		hidden:true,
	    		id:'RESTRICTIVE_MOMENT_END'+'htm'
	    		},
	    		
	    		
	    		
	    		
	    		{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				id:'RESTRICTIVE_MOMENT_DISTANCE'+'label',
				text:'<%=restrictivemomentdistance%>  :'
				},{width:90},{
				xtype:'numberfield',
	    		cls:'selectstylePerfect',
	    		emptyText:'',
	    		blankText :'',
	    		hidden:true,
	    		allowBlank: true,
	    		maxLength : 5,
	    		allowDecimals: false,
	    		id:'RESTRICTIVE_MOMENT_DISTANCE'+'field'
	    		},{width:18},
	    		{
	    		html:'(<%=unitOfMeasure%>)',
	    		hidden:true,
	    		id:'RESTRICTIVE_MOMENT_DISTANCE'+'htm'
	    		}
	    		
			  
	    		]
    });
 
 
 
 var dayPanelForRestrictiveMovementAlert=new Ext.Panel({
        id:'dayPanelForRestrictiveMovementAlertId',
        frame:false,
        width:'600',
        height:'200',
        border:false,
        layout:'table',
      layoutConfig: {
			columns:23
			},
        items:[{width:5},
               {
		 		xtype: 'label',
				text:'<%=days%>:'
				},{width:40},
				{
				xtype: 'checkbox',
				id:'MONDAY1'+'field',
				boxLabel:'<%=mon%>'
				},
				{width:40},
				{
				xtype: 'checkbox',
				id:'TUESDAY1'+'field',
				boxLabel:'<%=tue%>'
				},
				{width:40},
				{
				xtype: 'checkbox',
				id:'WEDNESDAY1'+'field',
				boxLabel:'<%=wed%>'
				},
				{width:40},
				{
				xtype: 'checkbox',
			    id:'THURSDAY1'+'field',
			    boxLabel:'<%=thu%>'
				},
				{width:40},
				{
				xtype: 'checkbox',
				id:'FRIDAY1'+'field',
				boxLabel:'<%=fri%>'
				},
				{width:40},
				{
				xtype: 'checkbox',
				id:'SATURDAY1'+'field',
				boxLabel:'<%=sat%>'
				},{width:40},
				{
				xtype: 'checkbox',
			    id:'SUNDAY1'+'field',
			    boxLabel:'<%=sun%>'
				}
				
          ]
          });
 var dayPanel=new Ext.Panel({
        id:'daypid',
        frame:false,
        width:'600',
        height:'200',
        border:false,
        layout:'table',
      layoutConfig: {
			columns:23
			},
        items:[{width:5},
               {
		 		xtype: 'label',
				text:'<%=days%>:'
				},{width:40},
				{
				xtype: 'checkbox',
				id:'MONDAY'+'field',
				boxLabel:'<%=mon%>'
				},
				{width:40},
				{
				xtype: 'checkbox',
				id:'TUESDAY'+'field',
				boxLabel:'<%=tue%>'
				},
				{width:40},
				{
				xtype: 'checkbox',
				id:'WEDNESDAY'+'field',
				boxLabel:'<%=wed%>'
				},
				{width:40},
				{
				xtype: 'checkbox',
			    id:'THURSDAY'+'field',
			    boxLabel:'<%=thu%>'
				},
				{width:40},
				{
				xtype: 'checkbox',
				id:'FRIDAY'+'field',
				boxLabel:'<%=fri%>'
				},
				{width:40},
				{
				xtype: 'checkbox',
				id:'SATURDAY'+'field',
				boxLabel:'<%=sat%>'
				},{width:40},
				{
				xtype: 'checkbox',
			    id:'SUNDAY'+'field',
			    boxLabel:'<%=sun%>'
				}
				
          ]
          });
   
    var imgname="";
	function getImageName(imgname){
	imgname=imgname;
	}
	
	var imagenames='<img id="imageid" src=/ApplicationImages/CustomisationImages/Aggregate_BG.png>';
	var imagecontentPanel="";
	// function for setting image on demand
	function imagefunction(imagename){
	
	document.getElementById("imageid").setAttribute('src','/ApplicationImages/CustomisationImages/'+imagename);
	document.getElementById('idimg').value='<img id="imageid" src=/ApplicationImages/CustomisationImages/'+imagename+'>';
	imagenames='<img id="imageid" src=/ApplicationImages/CustomisationImages/'+imagename+'>';
	
	
	//imagecontentPanel.doAutoLoad();
	}		
	//image panel for adding image	
var imagepanel=new Ext.Panel({
						standardSubmit: true,
						frame:false,
						collapsible:false,
				        id:'SettingName'+'id',
				        name :'image',
                        width:'100%',
                        border: false,
                        layout:'table',
                        layoutConfig: {
						columns:4
						},
                        items:[
                        {border: false,width:10},
                        {
                         border: false,
                        //html :imagefunction(imgname),
                        html:'<img border="0" id="imageid" src=/ApplicationImages/CustomisationImages/Aggregate_BG.png>',
                        id:'idimg'
                        },{border: false,width:10},{
                        xtype:'button',
                        width:80,
                        text:'<%=addimage%>',
                        iconCls:'addbutton',
                        listeners: {
        				click:{
       			 		fn:function(){
       			 			if(Ext.getCmp('custsetcomboId').getValue()== "")	
										{
										Ext.example.msg("<%=selCustName%>");
										Ext.getCmp('custsetcomboId').focus();
										return;
										}
       			 		myWin.show();
       			 		disableTabElements();
       			 		//imagecontentPanel=Ext.get('SettingName'+'id');
       			 		//window.open('VehicleImages.jsp','imagewindow','width=400,height=400');
       			 		 
       			 		
       			 		}
       			 		}
       			 		}
                        }
                        ]			        
						});
   
   
   //functions for checking contains in javascript
   Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
}
   
   //store for feature name, type, fieldtype and message label for dynamic component generation
     var featureliststore=new Ext.data.JsonStore({
         url:'<%=request.getContextPath()%>/CustomerSettingAction.do?param=getProcessLabel',
         id:'featureStoreId',
         root:'ProcessLabelIdRoot',
         autoLoad:false,
         remoteSort:true,
         fields:['ProcessLabelId','ProcessId']


  });
  
  //store for customername
 
     var custnamecombostore= new Ext.data.JsonStore({
		 url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
	     id:'CustomerStoreId',
         root: 'CustomerRoot',
         autoLoad: true,
         remoteSort: true,
	     fields: ['CustId','CustName','Status','ActivationStatus'],
	     
	     
	     	   listeners: {
            load: function (custstore, records, success, options) {
				   
			
				     if ( <%= customeridlogged %> > 0) {
                Ext.getCmp('custsetcomboId').setValue(<%=customeridlogged%>);
                showCustomerSetting();
                }
                else if(<%= CustIdPassed %> > 0)
                {
                Ext.getCmp('custsetcomboId').setValue(<%=CustIdPassed%>);
                showCustomerSetting();
                }
                else if(globalCustomerID!=0)
                {
                Ext.getCmp('custsetcomboId').setValue(globalCustomerID);
                showCustomerSetting();
                }
	     
	     
	     }}
	     
	     

   });
   /****************************function showing customization info*********************************/
   function showCustomerSetting()
   {
     Ext.getCmp('tabid').show();
    	       var futurelisst=new Array();
    	        featureliststore.load({
    	        params:{
    	        CustId:Ext.getCmp('custsetcomboId').getValue()
    	        },
                 callback:function(){
                  for(var i=0;i<featureliststore.data.length;i++){
                 var record=featureliststore.getAt(i);
                 futurelisst.push(record.data['ProcessLabelId']);
                 }
                  //code for displaying feature
                 
					 
                  
                  
                  if(futurelisst.contains('Adv_Montr')){
                  Ext.getCmp('advancemonitoringid').show();
                  Ext.getCmp('Advwinbuttonid').show();                  
                   Ext.getCmp('advancemonit').setTitle('<%=advanceMonitoring%>');
                  }else{
                  Ext.getCmp('advancemonitoringid').hide();
                   Ext.getCmp('Advwinbuttonid').hide(); 
                  Ext.getCmp('advancemonit').setTitle('');
                  }
                  if(futurelisst.contains('Milk_Dis_log')){
                  Ext.getCmp('milkdistributionlogisricsid').show();
                  Ext.getCmp('milkdislogid').setTitle('<%=milkdistributionlogistics%>');
                  }
                  else{
                  Ext.getCmp('milkdistributionlogisricsid').hide();
                  Ext.getCmp('milkdislogid').setTitle('');
                  }
                  if(futurelisst.contains('Health_Saf_Ass')){
                  Ext.getCmp('healthandsafetyid').show();
                  Ext.getCmp('healsafassid').setTitle('<%=healthandsafetyassurance%>');
                  }
                  else{
                  Ext.getCmp('healthandsafetyid').hide();
                  Ext.getCmp('healsafassid').setTitle('');
                  }
                  if(futurelisst.contains('Ess_Montr')){
                  Ext.getCmp('essentialmonitoringid').show();
				  Ext.getCmp('essentialwinbuttonid').show();
                  Ext.getCmp('essentialmonit').setTitle('<%=essentialMonitoring%>');
                  }else{
                   Ext.getCmp('essentialmonitoringid').hide();
				    Ext.getCmp('essentialwinbuttonid').hide(); 
                   Ext.getCmp('essentialmonit').setTitle('');
                  
                  }
                   
                    
                  var tab = Ext.getCmp('essentialmonit');
				  var tabGroup = tab.ownerCt;
				  var groupingPanel = tabGroup.ownerCt;
				
				  groupingPanel.setActiveGroup(tabGroup);
				  tabGroup.setActiveTab(tab);
				   }
				   });
				  
				  customersettingdetails.load({
				  params:{
				  CustId:Ext.getCmp('custsetcomboId').getValue()
				 
				  },
				  callback:function(){
				 
				  //to load data in fields
				  		var clientId=Ext.getCmp('custsetcomboId').getValue();
				  		var image="";
				  		var stoppageTime="";
				  		var idletime="";
				  		var nonCommtime="";
				  		var livepostime="";
                        var subRemainder="";
						var subNotification="";
				  		var rsemomstartime="";
				  		var rsenonmomstarttime="";
				  		var rsemomendtime="";
				  		var resnonmomendtime="";
				  		var acidletime="";
				  		var nearborderdis="";
				  		var doorinterval="";
				  		var seatbeltinterval="";
				  		var restrictivedistance="";
				  		var nonrestrictivedis="";
				  		var mintemp="";
				  		var maxtemp="";
				  		var overspeedlimitblacktop="";
				  		var overspeedlimitgraded="";
				  		var seatbeltdistance="";
				  		var doorsensoralertinsidehub=""
				  		var monday="";
				  		var tuesday="";
				  		var wednesday="";
				  		var thursday="";
				  		var friday="";
				  		var saturday="";
				  		var sunday="";
				  		var firstday="";
				  		var startt="";
				  		var endt="";
				  		var stoppageAlertInsideHubb="";
				  		
				  		var monday1="";
				  		var tuesday1="";
				  		var wednesday1="";
				  		var thursday1="";
				  		var friday1="";
				  		var saturday1="";
				  		var sunday1="";
				  		
				  		
				  		var idx = customersettingdetails.findBy(function(record){
				  		
				      //alert("**record**"+record.get('CustomerId'));
					    if(record.get('CustomerId') == clientId){
					    image=record.get('Image');
				  		stoppageTime=record.get('StoppageTime');
				  		idletime=record.get('IdleTime');
				  		nonCommtime=record.get('NonCommTime');
				  		livepostime=record.get('LivePositionTime');
						subRemainder=record.get('SubRemainder');
						subNotification=record.get('SubNotification');
				  		rsemomstartime=record.get('RestMomStartTime');
				  		rsenonmomstarttime=record.get('ResNonMomStartTime');
				  		rsemomendtime=record.get('ResMomEndTime');
				  		resnonmomendtime=record.get('ResNonMomEndTime');
				  		acidletime=record.get('ACIdleTime');
				  		nearborderdis=record.get('NearBoarder');
				  		doorinterval=record.get('DoorSensorInt');
				  		seatbeltinterval=record.get('SeatBeltInt');
				  		restrictivedistance=record.get('ResDistance');
				  		nonrestrictivedis=record.get('NonResDis');
				  		mintemp=record.get('MinTemp');
				  		maxtemp=record.get('MaxTemp');
				  		overspeedlimitblacktop=record.get('OverSpeedBlackTop');
				  		overspeedlimitgraded=record.get('OverSpeedGraded');
				  		seatbeltdistance=record.get('SeatBeltDistance');
				  		doorsensoralertinsidehub=record.get('Doorsensoralertinsidehub');
				  		monday=record.get('Monday');
				  		tuesday=record.get('Tuesday');
				  		wednesday=record.get('Wednesday');
				  		thursday=record.get('Thursday');
				  		friday=record.get('Friday');
					    saturday=record.get('Saturday');
					    sunday=record.get('Sunday');
					    firstday=record.get('FirstDayWeek');
					    startt =  record.get('STime');
					    endt=  record.get('ETime');
					    
					    monday1=record.get('Monday1');
				  		tuesday1=record.get('Tuesday1');
				  		wednesday1=record.get('Wednesday1');
				  		thursday1=record.get('Thursday1');
				  		friday1=record.get('Friday1');
					    saturday1=record.get('Saturday1');
					    sunday1=record.get('Sunday1');
					    
					    
					    stoppageAlertInsideHubb=record.get('SAlertInsideHub');
				
					     }
				    	});
				    	imagefunction(image);
				    	Ext.getCmp('STOPPAGE_TIME_ALERT'+'field').setValue(stoppageTime);
				    	Ext.getCmp('IDLETIME_ALERT'+'field').setValue(idletime);
				    	Ext.getCmp('NON_COMMUNICATING_ALERT'+'field').setValue(nonCommtime);
				    	Ext.getCmp('LIVE_POSITION_ALERT'+'field').setValue(livepostime);
                        Ext.getCmp('SUBSEQUENENT_REMAINDERID'+'field').setValue(subRemainder);
				    	Ext.getCmp('SUBSEQUENENT_NOTIFICATIONID'+'field').setValue(subNotification);
				    	Ext.getCmp('dateId').setValue(rsemomstartime);
				    	Ext.getCmp('RESTRICTIVE_NON_MOMENT_START'+'field').setValue(rsenonmomstarttime);
				    	Ext.getCmp('dateId2').setValue(rsemomendtime);
				    	Ext.getCmp('resnonmomentendtimeid').setValue(resnonmomendtime);
				    	Ext.getCmp('ACIDLE_TIME_ALERT'+'field').setValue(acidletime);
				    	Ext.getCmp('NEARTO_BOARDER_DISTANCE'+'field').setValue(nearborderdis);
				    	Ext.getCmp('Door_Sensor_Interval'+'field').setValue(doorinterval);
				    	Ext.getCmp('SEAT_BELT_INTERVAL'+'field').setValue(seatbeltinterval);
				    	Ext.getCmp('RESTRICTIVE_MOMENT_DISTANCE'+'field').setValue(restrictivedistance);
				    	Ext.getCmp('nonrestrictivedistanceid').setValue(nonrestrictivedis);
				    	Ext.getCmp('MIN_TEMPERATURE'+'field').setValue(mintemp);
				    	Ext.getCmp('MAX_TEMPERATURE'+'field').setValue(maxtemp);
			    	    Ext.getCmp('OS_LIMIT_BLACKTOP'+'field').setValue(overspeedlimitblacktop);
				    	Ext.getCmp('OS_LIMIT_GRADED'+'field').setValue(overspeedlimitgraded);
				    	Ext.getCmp('SEATBELT_DISTANCE'+'field').setValue(seatbeltdistance);
				    	Ext.getCmp('DOOR_SENSOR_ALERT_INSIDE_HUB'+'field').setValue(doorsensoralertinsidehub);
				    	Ext.getCmp('MONDAY'+'field').setValue(monday);
				    	Ext.getCmp('TUESDAY'+'field').setValue(tuesday);
				    	Ext.getCmp('WEDNESDAY'+'field').setValue(wednesday);
				    	Ext.getCmp('THURSDAY'+'field').setValue(thursday);
				    	Ext.getCmp('FRIDAY'+'field').setValue(friday);
				    	Ext.getCmp('SATURDAY'+'field').setValue(saturday);
				    	Ext.getCmp('SUNDAY'+'field').setValue(sunday);
				    	Ext.getCmp('FIRST_DAY_WEEK'+'field').setValue(firstday);
				    	Ext.getCmp('START_TIME'+'field').setValue(startt);
				    	Ext.getCmp('END_TIME'+'field').setValue(endt);
				    	Ext.getCmp('STOPPAGE_ALERT_INSIDE_HUB'+'field').setValue(stoppageAlertInsideHubb);
				    	
				    	Ext.getCmp('MONDAY1'+'field').setValue(monday1);
				    	Ext.getCmp('TUESDAY1'+'field').setValue(tuesday1);
				    	Ext.getCmp('WEDNESDAY1'+'field').setValue(wednesday1);
				    	Ext.getCmp('THURSDAY1'+'field').setValue(thursday1);
				    	Ext.getCmp('FRIDAY1'+'field').setValue(friday1);
				    	Ext.getCmp('SATURDAY1'+'field').setValue(saturday1);
				    	Ext.getCmp('SUNDAY1'+'field').setValue(sunday1);
				    	
				    
				    	if(doorsensoralertinsidehub=='Y')
				    	{
				    	Ext.getCmp('DOOR_SENSOR_ALERT_INSIDE_HUB'+'field').setValue(true);
				    	}
				    	if(monday=='Y')
				    	{
				    	Ext.getCmp('MONDAY'+'field').setValue(true);
				    	}
				    	if(tuesday=='Y')
				    	{
				    	Ext.getCmp('TUESDAY'+'field').setValue(true);
				    	}
				    	if(wednesday=='Y')
				    	{
				    	Ext.getCmp('WEDNESDAY'+'field').setValue(true);
				    	}
				    	if(thursday=='Y')
				    	{
				    	Ext.getCmp('THURSDAY'+'field').setValue(true);
				    	}
				    	if(friday=='Y')
				    	{
				    	Ext.getCmp('FRIDAY'+'field').setValue(true);
				    	}
				    	if(saturday=='Y')
				    	{
				    	Ext.getCmp('SATURDAY'+'field').setValue(true);
				    	}
				    	if(sunday=='Y')
				    	{
				    	Ext.getCmp('SUNDAY'+'field').setValue(true);
				    	}
				    	if(stoppageAlertInsideHubb=='Y')
				    	{
				    	Ext.getCmp('STOPPAGE_ALERT_INSIDE_HUB'+'field').setValue(true);
				    	}
				    	
				    	
				    	
				    	
				    	if(monday1=='Y')
				    	{
				    	Ext.getCmp('MONDAY1'+'field').setValue(true);
				    	}
				    	if(tuesday1=='Y')
				    	{
				    	Ext.getCmp('TUESDAY1'+'field').setValue(true);
				    	}
				    	if(wednesday1=='Y')
				    	{
				    	Ext.getCmp('WEDNESDAY1'+'field').setValue(true);
				    	}
				    	if(thursday1=='Y')
				    	{
				    	Ext.getCmp('THURSDAY1'+'field').setValue(true);
				    	}
				    	if(friday1=='Y')
				    	{
				    	Ext.getCmp('FRIDAY1'+'field').setValue(true);
				    	}
				    	if(saturday1=='Y')
				    	{
				    	Ext.getCmp('SATURDAY1'+'field').setValue(true);
				    	}
				    	if(sunday1=='Y')
				    	{
				    	Ext.getCmp('SUNDAY1'+'field').setValue(true);
				    	}
				    	
				    	
				    	
				    	
				    	}
				  });
                  
                
    	       
   }
  //********************combo for CustomerName start ****************************************
  
    var customersettingcombo = new Ext.form.ComboBox({
        store: custnamecombostore,
        id:'custsetcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selCustName%>',
        blankText:'<%=selCustName%>',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'CustId',
    	displayField: 'CustName',
    	listWidth : 200,
    	cls:'selectstyle',
    	listeners:{
    	    select:{
    	    //function for creating dynamic fieldset with component
    	       fn:function(){
    	       parent.globalCustomerID=Ext.getCmp('custsetcomboId').getValue();
    	       showCustomerSetting();
    	         
					
    	        }
    	    }
    	}   
    });
    
    //**********************combo for CustomerName end ********************************
 //health safety insurance panel
 
  var HealthAndSafetyAssurance=new Ext.form.FormPanel({
  		monitorValid:true,
		standardSubmit: true,
		frame:false,
		title:'<%=healthandsafetyassurance%>',
		collapsible:false,
		hidden:true,
		frame:true,
		width:screen.width-285,
	    height:'100%',
		id:'healthandsafetyid',
		layout:'table',
		layoutConfig: {
			columns:6,
			tableAttrs: {
            style: {
                width: '92%'
            }
 			}
		},
		items: [{
				xtype: 'label',
				cls:'labellargestyle',
				text:'<%=overspeedlimitblacktop%>  :',
				hidden:true,
				id:'OS_LIMIT_BLACKTOP'+'label'
				},{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		hidden:true,
	    		emptyText:'',
	    		blankText :'',
	    		allowBlank: true,
	    		maxLength : 5,
	    		id:'OS_LIMIT_BLACKTOP'+'field'
	    		},{
	    		html:'(<%=unitOfMeasure%>)',
	    		hidden:true,
	    		id:'OS_LIMIT_BLACKTOP'+'htm'
	    		},{width:180},{width:20},{width:20},
	    		{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				text:'<%=overspeedlimitgrade%>  :',
				id:'OS_LIMIT_GRADED'+'label'
				},{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'',
	    		hidden:true,
	    		blankText :'',
	    		maxLength : 5,
	    		allowBlank: true,
	    		id:'OS_LIMIT_GRADED'+'field'
	    		},{
	    		html:'(<%=unitOfMeasure%>)',
	    		hidden:true,
	    		id:'OS_LIMIT_GRADED'+'htm'
	    		},{width:180},{width:20},{width:20},
	    		{width:20},{width:20},{width:20},{width:180},
	    		{
	    		xtype:'button',
	    		text:'<%=save%>',
	    		formBind:true,
	    		iconCls:'savebutton',
	    		width:60,
	    		listeners: {
			        click:{
			       	fn:function(){
			       	
					if(HealthAndSafetyAssurance.getForm().isValid()) {	
										
							Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/CustomerSettingAction.do?param=saveHealthAndSafetyDetails',
									method: 'POST',
									params: 
									{ 
									     custName:Ext.getCmp('custsetcomboId').getValue(),
										 BlackTop:Ext.getCmp('OS_LIMIT_BLACKTOP'+'field').getValue(),
										 Graded:Ext.getCmp('OS_LIMIT_GRADED'+'field').getValue(),
										 pageName: pageName
							         	 
							         },
									success:function(response, options)//start of success
									{
									      Ext.example.msg(response.responseText);
								      var clientId=Ext.getCmp('custsetcomboId').getValue();
			         				  var idx = customersettingdetails.findBy(function(record){
									  if(record.get('CustomerId') == clientId){
					    				record.set('OverSpeedBlackTop',Ext.getCmp('OS_LIMIT_BLACKTOP'+'field').getValue());
				  						record.set('OverSpeedGraded',Ext.getCmp('OS_LIMIT_GRADED'+'field').getValue());
									  }
									  });
		        		
										
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								         Ext.example.msg("error");
								    	 Ext.getCmp('OS_LIMIT_BLACKTOP'+'field').reset();
								      Ext.getCmp('OS_LIMIT_GRADED'+'field').reset();
									} // END OF FAILURE 
						}); // END OF AJAX
						
						}else{
						Ext.example.msg("<%=validateMessage%>");
					}
						
						}}}
	    		},{
	    		xtype:'button',
	    		text:'<%=cancel%>',
	    		iconCls:'cancelbutton',
	    		width:60,
	    		listeners: {
			        click:{
			       	fn:function(){
			       	var overspeedlimitblacktop="";
			       	var overspeedlimitgraded="";
			       	 var clientId=Ext.getCmp('custsetcomboId').getValue();
			         var idx = customersettingdetails.findBy(function(record){
									  if(record.get('CustomerId') == clientId){
					    				overspeedlimitblacktop=record.get('OverSpeedBlackTop');
				  						overspeedlimitgraded=record.get('OverSpeedGraded');
									  }
									  });
			        Ext.getCmp('OS_LIMIT_BLACKTOP'+'field').setValue(overspeedlimitblacktop);
				    Ext.getCmp('OS_LIMIT_GRADED'+'field').setValue(overspeedlimitgraded);
			       	
			       	}}}
	    		}]
				
				});
				
	//milk distribution logistics panel
	var MilkDistributionLogistics=new Ext.form.FormPanel({
	    monitorValid:true,
	    standardSubmit: true,
		frame:false,
		title:'<%=milkdistributionlogistics%>',
		collapsible:false,
		hidden:true,
		frame:true,
		width:screen.width-285,
	    height:280,
		id:'milkdistributionlogisricsid',
		layout:'table',
		layoutConfig: {
			columns:6,
			tableAttrs: {
            style: {
                width: '92%'
            }
 			}
		},
		items: [{
				xtype: 'label',
				cls:'labellargestyle',
				id:'MIN_TEMPERATURE'+'label',
				hidden:true,
				text:'<%=minTemp%> :'
				},{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		hidden:true,
	    		id:'MIN_TEMPERATURE'+'field',
	    		emptyText:'',
	    		blankText :'',
	    		maxLength : 5,
	    		allowBlank: true
	    		},{
	    		html:'(Degree)',
	    		hidden:true,
	    		id:'MIN_TEMPERATURE'+'htm'
	    		},{width:180},{width:20},{width:20},{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				id:'MAX_TEMPERATURE'+'label',
				text:'<%=maxTemp%> :'
				},{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		id:'MAX_TEMPERATURE'+'field',
	    		hidden:true,
	    		emptyText:'',
	    		maxLength : 5,
	    		blankText :'',
	    		allowBlank: true
	    		
	    		},{
	    		html:'(Degree)',
	    		id:'MAX_TEMPERATURE'+'htm',
	    		hidden:true
	    		},{width:180},{width:20},{width:20}
	    		,{width:20},{width:20},{width:20},{width:180},
	    		{
	    		xtype:'button',
	    		text:'<%=save%>',
	    		formBind:true,
	    		iconCls:'savebutton',
	    		width:60,
	    		listeners: {
			        click:{
			       	fn:function(){
			       if(MilkDistributionLogistics.getForm().isValid()) {	
									
							Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/CustomerSettingAction.do?param=saveMilkDistributionLogisticsDetails',
									method: 'POST',
									params: 
									{    
									custName:Ext.getCmp('custsetcomboId').getValue(),
										 MinTemp:Ext.getCmp('MIN_TEMPERATURE'+'field').getValue(),
										 MaxTemp:Ext.getCmp('MAX_TEMPERATURE'+'field').getValue(),
										  pageName: pageName
										
							         	 
							         },
									success:function(response, options)//start of success
									{
									     Ext.example.msg(response.responseText);
										var clientId=Ext.getCmp('custsetcomboId').getValue();
			         				  var idx = customersettingdetails.findBy(function(record){
									  if(record.get('CustomerId') == clientId){
					    				record.set('MinTemp',Ext.getCmp('MIN_TEMPERATURE'+'field').getValue());
				  						record.set('MaxTemp',Ext.getCmp('MAX_TEMPERATURE'+'field').getValue());
									  }
									  });
		        		
										
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								          Ext.example.msg("error");
									  Ext.getCmp('MIN_TEMPERATURE'+'field').reset();
								      Ext.getCmp('MAX_TEMPERATURE'+'field').reset();
									} // END OF FAILURE 
						}); // END OF AJAX
						
						}else{
						Ext.example.msg('<%=validateMessage%>');
					}
						
						}}}
	    		},{
	    		xtype:'button',
	    		text:'<%=cancel%>',
	    		iconCls:'cancelbutton',
	    		width:60,
	    		listeners: {
			        click:{
			       	fn:function(){
			       	var mintemp="";
			       	var maxtemp="";
			       	 var clientId=Ext.getCmp('custsetcomboId').getValue();
			         var idx = customersettingdetails.findBy(function(record){
									  if(record.get('CustomerId') == clientId){
					    				mintemp=record.get('MinTemp');
				  						maxtemp=record.get('MaxTemp');
									  }
									  });
			       	
			       Ext.getCmp('MIN_TEMPERATURE'+'field').setValue(mintemp);
				   Ext.getCmp('MAX_TEMPERATURE'+'field').setValue(maxtemp);
			       	
			       	}}}
	    		}]
	
	
	});
	//trip panel
	var Trip=new Ext.Panel({
		standardSubmit: true,
		frame:false,
		title:'<%=trip%>',
		collapsible:false,
		hidden:true,
		frame:true,
		width:'90%',
		height:'100%',
		id:'tripid',
		layout:'table',
		layoutConfig: {
			columns:3
		},
		items: [{
				xtype: 'label',
				cls:'labellargestyle',
				id:'STOPPAGETIME_TIME'+'label',
				text:'<%=stoppageTimeOnTrip%>  :'
				},{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'',
	    		blankText :'',
	    		allowBlank: true,
	    		id:'stoppagetimetripid'
	    		},{
	    		html:'(DD:HH:MM)'
	    		},{cls:'labelstyle'},
	    		{
	    		xtype:'button',
	    		text:'<%=trip%>',
	    		formBind:true,
	    		cls:'custsetrightstyle',
	    		listeners: {
			        click:{
			       	fn:function(){
			      if(Trip.getForm().isValid()) {	
															
							Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/CustomerSettingAction.do?param=saveTripDetails',
									method: 'POST',
									params: 
									{    custName:Ext.getCmp('custsetcomboId').getValue(),
										 StoppageTimeTrip:Ext.getCmp('stoppagetimetripid').getValue()
										
							         	 
							         },
									success:function(response, options)//start of success
									{
									      Ext.example.msg(response.responseText);
										  ctsb.setStatus({
													 text:getMessageForStatus(response.responseText), 
													 iconCls:'',
													 clear: true
								                     });
								      Ext.getCmp('stoppagetimetripid').setValue(Ext.getCmp('stoppagetimetripid').getValue());
								       
		        		
										
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								          Ext.example.msg("error");
									         Ext.getCmp('stoppagetimetripid').reset();
									} // END OF FAILURE 
						}); // END OF AJAX
						
						}else{
						Ext.example.msg("<%=validateMessage%>");
					}
						
						}}}
	    		},{
	    		xtype:'button',
	    		text:'<%=cancel%>',
	    		iconCls:'cancelbutton',
	    		width:50,
	    		listeners: {
			        click:{
			       	fn:function(){
			       	Ext.getCmp('stoppagetimetripid').reset();
			       	
			       	}}}
		}
		]});		
	//essential monitoring panel
	var EssentialMonitoring=new Ext.form.FormPanel({
	    monitorValid:true,
		standardSubmit: true,
		frame:false,
		autoScroll:true,
		title:'<%=essentialMonitoring%>',
		collapsible:false,
		hidden:true,
		frame:true,
		width:screen.width-285,
	    height:280,
		id:'essentialmonitoringid',
	    defaults: {
	            anchor: '60%'
	        },
		layoutConfig: {
			columns:5,
			tableAttrs: {
            style: {
                width: '50%'
              }
 			}
		},items: [{
				xtype: 'fieldset',
				title: '<%=essentialSetting%>',
				cls:'fieldsetpanellarge',
				colspan:3,
				collapsible:true,
				collapsed:false,
				id:'essentialFieldsetId1',
				layout:'table',
				layoutConfig: {
					columns:3,
					tableAttrs: {
		            style: {
		                width: '60%'
		               }
		 			}
				},	
		items: [{
				xtype: 'label',
				cls:'labellargestyle',
				id:'STOPPAGE_TIME_ALERT'+'label',
				hidden:true,
				text:'<%=stoppageTimeLimit%>  :'
				},{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		regex:/^[0-9]+$/,
	    		emptyText:'',
	    		blankText :'',
	    		hidden:true,
	    		id:'STOPPAGE_TIME_ALERT'+'field',
	    		allowBlank: true,
	    		listeners:{
        		change: function(field, newValue, oldValue){
	    		var valid=validateStoppageLimitEnteredTime(newValue);
	    		if(!valid){
	    		    Ext.example.msg("<%=validateStoppageTime%>");
					Ext.getCmp('STOPPAGE_TIME_ALERT'+'field').focus();
					return;
	    		}
	    		}
	    		}
	    		},{
	    		html:'(Mins)',
	    		hidden:true,
	    		id:'STOPPAGE_TIME_ALERT'+'htm'
	    		},{width:180},{width:20},{width:20},
	    		{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				id:'NON_COMMUNICATING_ALERT'+'label',
				text:'<%=nonCommunicatingTime%>  :'
				},{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		regex:/^[0-9]+$/,
	    		emptyText:'',
	    		blankText :'',
	    		hidden:true,
	    		allowBlank: true,
	    		id:'NON_COMMUNICATING_ALERT'+'field',
	    		listeners:{
        		change: function(field, newValue, oldValue){
	    		var valid=validateEnteredTime(newValue);
	    		if(!valid){
	    		    Ext.example.msg("<%=validateTime%>");
					Ext.getCmp('NON_COMMUNICATING_ALERT'+'field').focus();
					return;
	    		     }
	    		  }
	    		}
	    		},{
	    		html:'(Mins)',
	    		hidden:true,
	    		id:'NON_COMMUNICATING_ALERT'+'htm'
	    		},{width:180},{width:20},{width:20},{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				id:'LIVE_POSITION_ALERT'+'label',
				text:'<%=livePositionTime%>  :'
				},LivePosition,{
	    		html:'(Hours)',
	    		hidden:true,
	    		id:'LIVE_POSITION_ALERT'+'htm'
	    		},{width:180},{width:20},{width:20}
	    		,{
	    		xtype: 'checkbox',
	    		cls:'ExtnCheckBox',
				id:'STOPPAGE_ALERT_INSIDE_HUB'+'field'
	    		},{
	    		xtype: 'label',
			     cls:'labellargestyleforcheckbox',  
				id:'STOPPAGE_ALERT_INSIDE_HUB'+'label',
				text:'<%= stoppageAlertInsideHub%>'
	    		},{width:40}
	    		]},{
				xtype: 'fieldset',
				title: '<%=idleAlertSetting%>',
				cls:'fieldsetpanellarge',
				colspan:3,
				collapsible:true,
				collapsed:false,
				id:'essentialIdleAlertId',
				layout:'table',
				layoutConfig: {
					columns:3,
					tableAttrs: {
		            style: {
		                width: '60%'
		              }
		 			}
				},
				items: [{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				id:'IDLETIME_ALERT'+'label',
				text:'<%=idleTimeLimit%>  :'
				},{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		regex:/^[0-9]+$/,
	    		emptyText:'',
	    		blankText :'',
	    		hidden:true,
	    		allowBlank: true,
	    		id:'IDLETIME_ALERT'+'field',
	    		listeners:{
        		change: function(field, newValue, oldValue){
	    		var valid=validateEnteredTime(newValue);
	    		if(!valid){
	    		    Ext.example.msg("<%=validateTime%>");
					Ext.getCmp('IDLETIME_ALERT'+'field').focus();
					return;
	    		    }
	    		  }
	    		}	    		
	    		},{
	    		html:'(Mins)',
	    		hidden:true,
	    		id:'IDLETIME_ALERT'+'htm'
	    		},{width:180},{width:20},{width:20},{
				xtype: 'label',
				cls:'labellargestyle',
				id:'SUBSEQUENENT_REMAINDERID'+'label',
				text:'<%=subsequentRemainder%>   :'
				},{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'',
	    		blankText :'',
	    		allowBlank: true,
				allowDecimals:false,
	    		id:'SUBSEQUENENT_REMAINDERID'+'field',
				listeners:{
        		change: function(field, newValue, oldValue){
	    		var valid=validateEnteredTime(newValue);
	    		if(!valid){
	    		    Ext.example.msg("<%=validateTime%>");
					Ext.getCmp('SUBSEQUENENT_REMAINDERID'+'field').focus();
					return;
	    		    }
	    		  }
	    		}		
	    		},{
	    		html:'(Mins)',
	    		id:'SUBSEQUENENT_REMAINDERID'+'htm'
	    		},{width:180},{width:20},{width:20},{
				xtype: 'label',
				cls:'labellargestyle',
				id:'SUBSEQUENENT_NOTIFICATIONID'+'label',
				text:'<%=subsequentNotification%>   :'
				},{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'',
	    		blankText :'',
	    		allowBlank: true,
				allowDecimals:false,
				minValue: 0,
                maxValue: 10,
	    		id:'SUBSEQUENENT_NOTIFICATIONID'+'field'
	    		},{
	    		html:'(Mins)',
	    		id:'SUBSEQUENENT_NOTIFICATIONID'+'htm'
	    		},{width:180},{width:20},{width:20}
				]}
         ]});
		var EssentialButtonPanel=new Ext.Panel({
		        	id: 'essentialwinbuttonid',
		        	standardSubmit: true,
					collapsible:false,
					hidden:true,
				    cls:'windowbuttonpanel',
					frame:true,
					width:screen.width-285,
				    height:20,
					buttons: [{
				xtype:'button',
	    		text:'<%=save%>',
	    		iconCls:'savebutton',
	    		formBind:true,
	    		width:65,
	    		listeners: {
			        click:{
			        //validation part
			        fn:function(){
			                 
			     		var valid=validateStoppageLimitEnteredTime(Ext.getCmp('STOPPAGE_TIME_ALERT'+'field').getValue());
	    				if(!valid){
	    				Ext.example.msg("<%=validateStoppageTime%>");
						Ext.getCmp('STOPPAGE_TIME_ALERT'+'field').focus();
						return;
	    				}
	    				
	    				valid=validateEnteredTime(Ext.getCmp('NON_COMMUNICATING_ALERT'+'field').getValue());
	    				if(!valid){
	    				Ext.example.msg("<%=validateTime%>");
						Ext.getCmp('NON_COMMUNICATING_ALERT'+'field').focus();
						return;
	    				}

						valid=validateEnteredTime(Ext.getCmp('IDLETIME_ALERT'+'field').getValue());
	    				if(!valid){
	    				Ext.example.msg("<%=validateTime%>");
						Ext.getCmp('IDLETIME_ALERT'+'field').focus();
						return;
	    				}

                          valid=validateEnteredTime(Ext.getCmp('SUBSEQUENENT_REMAINDERID'+'field').getValue());
	    				if(!valid){
	    				Ext.example.msg("<%=validateTime%>");
						Ext.getCmp('SUBSEQUENENT_REMAINDERID'+'field').focus();
						return;
	    				} 
						 if(Ext.getCmp('SUBSEQUENENT_REMAINDERID'+'field').getValue()!= "" && Ext.getCmp('SUBSEQUENENT_NOTIFICATIONID'+'field').getValue() == "" )
						{
						 Ext.example.msg("<%=enterSubsequentNotification%>");
                      	 Ext.getCmp('SUBSEQUENENT_NOTIFICATIONID'+'field').focus();
                      	 return;
			             }
                        

                        
						if(EssentialMonitoring.getForm().isValid()) {	
							Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/CustomerSettingAction.do?param=saveEssentialMonitoringDetails',
									method: 'POST',
									params: 
									{ 
										 custName:Ext.getCmp('custsetcomboId').getValue(),
										 stopagelimitlimit:Ext.getCmp('STOPPAGE_TIME_ALERT'+'field').getValue(),
										 idletimelimit:Ext.getCmp('IDLETIME_ALERT'+'field').getValue(),
										 noncommunicatinglimit:Ext.getCmp('NON_COMMUNICATING_ALERT'+'field').getValue(),
										 livepositiontime:Ext.getCmp('LIVE_POSITION_ALERT'+'field').getValue(),
										 subsequentRemainder:Ext.getCmp('SUBSEQUENENT_REMAINDERID'+'field').getValue(),
										 subsequentNotification:Ext.getCmp('SUBSEQUENENT_NOTIFICATIONID'+'field').getValue(),
										 stoppageAlertInsideHub:Ext.getCmp('STOPPAGE_ALERT_INSIDE_HUB'+'field').getValue(),pageName: pageName
							         	 
							         },
									success:function(response, options)//start of success
									{
									      Ext.example.msg(response.responseText);
										 var clientId=Ext.getCmp('custsetcomboId').getValue();
			         				  var idx = customersettingdetails.findBy(function(record){
									  if(record.get('CustomerId') == clientId){
					    				record.set('StoppageTime',Ext.getCmp('STOPPAGE_TIME_ALERT'+'field').getValue());
				  						record.set('IdleTime',Ext.getCmp('IDLETIME_ALERT'+'field').getValue());
				  						record.set('NonCommTime',Ext.getCmp('NON_COMMUNICATING_ALERT'+'field').getValue());
				  						record.set('LivePositionTime',Ext.getCmp('LIVE_POSITION_ALERT'+'field').getValue());
										record.set('SubRemainder',Ext.getCmp('SUBSEQUENENT_REMAINDERID'+'field').getValue());
										record.set('SubNotification',Ext.getCmp('SUBSEQUENENT_NOTIFICATIONID'+'field').getValue());
										record.set('SAlertInsideHub',Ext.getCmp('STOPPAGE_ALERT_INSIDE_HUB'+'field').getValue());
										
									  }
									  });
								     
		        		
										
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								            Ext.example.msg("error");
									        Ext.getCmp('STOPPAGE_TIME_ALERT'+'field').reset();
									        Ext.getCmp('IDLETIME_ALERT'+'field').reset();
									        Ext.getCmp('NON_COMMUNICATING_ALERT'+'field').reset();
									        Ext.getCmp('LIVE_POSITION_ALERT'+'field').reset();
											Ext.getCmp('SUBSEQUENENT_REMAINDERID'+'field').reset();
											Ext.getCmp('SUBSEQUENENT_NOTIFICATIONID'+'field').reset();
											Ext.getCmp('STOPPAGE_ALERT_INSIDE_HUB'+'field').reset();
									} // END OF FAILURE 
						}); // END OF AJAX
						
						
						}else{
						Ext.example.msg("<%=validateMessage%>");
					       }
					
			        }}}
	    		},{
	    		xtype:'button',
	    		text:'<%=cancel%>',
				id:'cancelid',
	    		iconCls:'cancelbutton',
	    		width:65,
	    			listeners: {
			        click:{
			        //validation part
			        fn:function(){
			        var stoppageTime="";
			        var idletime="";
			        var nonCommtime="";
			        var livepostime="";
				    var subRemainder="";
					var subNotification="";
			     	var stoppageAlertInsidHubb="";
			        var clientId=Ext.getCmp('custsetcomboId').getValue();
			         var idx = customersettingdetails.findBy(function(record){
									  if(record.get('CustomerId') == clientId){
					    				stoppageTime=record.get('StoppageTime');
								  		idletime=record.get('IdleTime');
								  		nonCommtime=record.get('NonCommTime');
								  		livepostime=record.get('LivePositionTime');
										subRemainder=record.get('SubRemainder');
										subNotification=record.get('SubNotification');
								     	stoppageAlertInsidHubb=record.get('SAlertInsideHub');
								     	
									  }
									  });
									
			        Ext.getCmp('STOPPAGE_TIME_ALERT'+'field').setValue(stoppageTime);
			        Ext.getCmp('IDLETIME_ALERT'+'field').setValue(idletime);
			        Ext.getCmp('NON_COMMUNICATING_ALERT'+'field').setValue(nonCommtime);
			        Ext.getCmp('LIVE_POSITION_ALERT'+'field').setValue(livepostime);
					Ext.getCmp('SUBSEQUENENT_REMAINDERID'+'field').setValue(subRemainder);
			        Ext.getCmp('SUBSEQUENENT_NOTIFICATIONID'+'field').setValue(subNotification);
		            Ext.getCmp('STOPPAGE_ALERT_INSIDE_HUB'+'field').setValue(stoppageAlertInsidHubb);
	    		}
		}
		}
		}]    
}); 
	//advance monitoring panel	
    var  AdvanceMonitoring=new Ext.form.FormPanel({
		standardSubmit: true,
		frame:false,
		title:'<%=advanceMonitoring%>',
		collapsible:false,
		hidden:true,
		frame:true,
		autoScroll:true,
		width:screen.width-285,
	    height:280,
		id:'advancemonitoringid',
		layout:'table',
		layoutConfig: {
			columns:5,
			tableAttrs: {
            style: {
                width: '50%'
            }
 			}
		},
		items: [{
				xtype: 'fieldset',
				title: '<%=Restrictive_Movement_Alert%>',
				cls:'fieldsetpanellarge',
				colspan:3,
				collapsible:true,
				collapsed:false,
				height:150,
				id:'Restrictive_Movement_Alert',
				layout:'table',
				layoutConfig:{
		           columns:1
		        },
		 		items:[restrictiveMovementAlertPanel,dayPanelForRestrictiveMovementAlert]	
                },{width:20},{width:20}
	    		,{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				id:'RESTRICTIVE_NON_MOMENT_START'+'label',
				text:'<%=restrictiveNonMomentStart%>  :'
				},RestrictiveNonMomentStartTime,{
				hidden:true,
				id:'RESTRICTIVE_NON_MOMENT_START'+'htm',
	    		html:'(<%=unitOfMeasure%>)'
	    		},{width:20,hidden:true},{width:20,hidden:true},
	    		{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				text:'<%=restrictiveNonMomentEnd%>  :'
				},RestrictiveNonMomentEndTime,{
				hidden:true,
	    		html:''
	    		},{width:20,hidden:true},{width:20,hidden:true}
	    		,{
				xtype: 'fieldset',
				title: '<%=AC_Idle_Alert%>',
				cls:'fieldsetpanellarge',
				colspan:3,
				collapsible:true,
				collapsed:false,
				id:'AC_Idle_Alert',
				layout:'table',
				layoutConfig: {
					columns:4,
					tableAttrs: {
		            style: {
		                width: '60%'
		            }
		 			}
				},
				items: [{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				id:'ACIDLE_TIME_ALERT'+'label',
				text:'<%=acIdleTime%>  :'
				},{width:70},{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		regex:/^[0-9]+$/,
	    		emptyText:'',
	    		blankText :'',
	    		hidden:true,
	    		id:'ACIDLE_TIME_ALERT'+'field',
	    		listeners:{
        		change: function(field, newValue, oldValue){
	    		var valid=validateEnteredTime(newValue);
	    		if(!valid){
	    		    Ext.example.msg("<%=validateTime%>");
					Ext.getCmp('ACIDLE_TIME_ALERT'+'field').focus();
					return;
	    		}
	    		}
	    		}
	    		
	    		},{
	    		html:'(Mins)',
	    		hidden:true,
	    		id:'ACIDLE_TIME_ALERT'+'htm'
	    		}]},{width:20},{width:20}
	    		,{
				xtype: 'fieldset',
				title: '<%=Border_Alert%>',
				cls:'fieldsetpanellarge',
				colspan:3,
				collapsible:true,
				collapsed:false,
				id:'Border_Alert',
				layout:'table',
				layoutConfig: {
					columns:4,
					tableAttrs: {
		            style: {
		                width: '60%'
		            }
		 			}
				},
				items: [{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				text:'<%=distancenearborder%>  :',
				id:'NEARTO_BOARDER_DISTANCE'+'label'
				},{width:2},{
				xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'',
	    		blankText :'',
	    		maxLength : 5,
	    		hidden:true,
	    		allowBlank: true,
	    		id:'NEARTO_BOARDER_DISTANCE'+'field'
	    		},{
	    		html:'(<%=unitOfMeasure%>)',
	    		hidden:true,
	    		id:'NEARTO_BOARDER_DISTANCE'+'htm'
	    		}]},{width:20},{width:20},
	    		{
				xtype: 'fieldset',
				title: '<%=Seat_Belt_Alert%>',
				cls:'fieldsetpanellarge',
				colspan:3,
				collapsible:true,
				collapsed:false,
				id:'SeatBelt_Alert',
				layout:'table',
				layoutConfig: {
					columns:4,
					tableAttrs: {
		            style: {
		                width: '62%'
		            }
		 			}
				},
				items: [{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				text:'<%=seatbeltintervaltime%> :',
				id:'SEAT_BELT_INTERVAL'+'label'
				},{width:1},SeatBeltInterval,{
	    		html:'(Mins)',
	    		id:'SEAT_BELT_INTERVAL'+'htm'
	    		},
	    		{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				text:'<%=seatbeltdistance%>  :',
				id:'SEATBELT_DISTANCE'+'label'
				},{width:70},
				{
				xtype:'numberfield',
				hidden:true,
	    		cls:'textrnumberstyle',
	    		emptyText:'',
	    		blankText :'',
	    		allowBlank: true,
	    		maxLength : 5,
	    		id:'SEATBELT_DISTANCE'+'field'
	    		}
				,{
	    		html:'(<%=unitOfMeasure%>)',
	    		hidden:true,
	    		id:'SEATBELT_DISTANCE'+'htm'
	    		}]},{width:20},{width:20},
	    		{
				xtype: 'fieldset',
				title: '<%=Door_Sensor_Alert%>',
				cls:'fieldsetpanellarge',
				colspan:3,
				collapsible:true,
				collapsed:false,
				id:'Door_Alert',
				layout:'table',
				layoutConfig: {
					columns:3,
					tableAttrs: {
		            style: {
		                width: '60%'
		            }
		 			}
				},items: [
				{
					xtype: 'label',
					cls:'labellargestyle',
					text:'<%=seatbeltintervaltime%>  :',
					id:'Door_Sensor_Interval'+'label'
				},
				{
					xtype:'numberfield',
	    			cls:'textrnumberstyle',
	    			maxValue:60,
	    			maxLength : 2,
	    			//minLength : 2,
	    			minValue:0,
		    		allowBlank: false,
		    		id:'Door_Sensor_Interval'+'field'
	    		},
	    		{
	    			html:'(Mins)',
		    		id:'Door_Sensor_Interval'+'htm'
	    		},{width:177},{width:20},{width:20},
	    		{
	    			xtype: 'checkbox',
					id:'DOOR_SENSOR_ALERT_INSIDE_HUB'+'field',
					cls:'ExtnCheckBox'
	    		},
	    		{
	    		xtype: 'label',
			    cls:'labellargestyleforcheckbox',  
				text:'<%=doorsensoralerthub%>',
				id:'DOOR_SENSOR_ALERT_INSIDE_HUB'+'label'
	    		},{width:40}
	    		]},
	    		{width:20},{width:20},
	    		{
				xtype: 'fieldset',
				title: '<%=workWeek%>',
				cls:'fieldsetpanellarge',
				colspan:1,
			    collapsible:true,
				collapsed:false,
				id:'Calender_Opt',
				layout:'table',
				layoutConfig:{
		           columns:1
		        },
		 		items:[dayPanel,{height:20},calPanel]
				},
	    		{
				xtype: 'label',
				cls:'labellargestyle',
				hidden:true,
				text:'<%=restrictivenonmomentdistance%>  :'
				},{
				xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		hidden:true,
	    		emptyText:'',
	    		blankText :'',
	    		allowBlank: true,
	    		maxLength : 5,
	    		id:'nonrestrictivedistanceid'
	    		},{
	    		hidden:true,
	    		html:'(<%=unitOfMeasure%>)'
	    		},{width:20,hidden:true},{width:20,hidden:true}
	    		]});
	    		
	    		var AdvwinButtonPanel=new Ext.Panel({
		        	id: 'Advwinbuttonid',
		        	standardSubmit: true,
					collapsible:false,
					width:screen.width-285,
	    			height:20,
					hidden:true,
					cls:'windowbuttonpanel',
					frame:true,
					buttons: [
	    		{
	    		xtype:'button',
	    		text:'<%=save%>',
	    		iconCls:'savebutton',
	    		formBind:true,
	    		width:70,
	    		listeners: {
			        click:{
			       	fn:function(){
	    				
	    				
<!--			       if(Ext.getCmp('dateId').getValue()!="")-->
<!--			       {	-->
<!--			       if(Ext.getCmp('dateId').getValue()!="00:00" || Ext.getCmp('dateId2').getRawValue()!="00:00"){	-->
<!--			       	-->
<!--	    			if((Ext.getCmp('dateId').getValue())>=(Ext.getCmp('dateId2').getValue()))	-->
<!--	    			{-->
<!--	    			ctsb.setStatus({-->
<!--						                 text: getMessageForStatus('<%=endTimeMustBeGreaterThanStartTime%>'),-->
<!--						                 iconCls: '',-->
<!--						                 clear: true-->
<!--						             });-->
<!--						             Ext.getCmp('dateId2').focus();-->
<!--						             return;-->
<!--	    			}-->
<!--	    			}-->
<!--	    			}	-->
	    			
	    			
<!--	    			 if(Ext.getCmp('dateId').getValue()!="" && Ext.getCmp('dateId2').getValue()=="" )-->
<!--			       {	-->
<!--			       ctsb.setStatus({-->
<!--						                 text: getMessageForStatus('Please Enter EndTime'),-->
<!--						                 iconCls: '',-->
<!--						                 clear: true-->
<!--						             });-->
<!--						             Ext.getCmp('dateId2').focus();-->
<!--						             return;-->
<!--	    			-->
<!--	    			}-->
<!--	    			-->
<!--	    			 if(Ext.getCmp('dateId2').getValue()!="" && Ext.getCmp('dateId').getValue()=="" )-->
<!--			       {	-->
<!--			       ctsb.setStatus({-->
<!--						                 text: getMessageForStatus('Please Enter StartTime'),-->
<!--						                 iconCls: '',-->
<!--						                 clear: true-->
<!--						             });-->
<!--						             Ext.getCmp('dateId').focus();-->
<!--						             return;-->
<!--	    			-->
<!--	    			}-->
	    			
	    			
			       	var valid=validateEnteredTime(Ext.getCmp('ACIDLE_TIME_ALERT'+'field').getValue());
	    				if(!valid){
	    				Ext.example.msg("<%=validateTime%>");
						Ext.getCmp('ACIDLE_TIME_ALERT'+'field').focus();
						return;
	    				}
	    				
	    				
					if((Ext.getCmp('START_TIME'+'field').getRawValue())!="")
					{	      
	    			if((Ext.getCmp('START_TIME'+'field').getRawValue())!='00:00')
	    			{
	    			 if ((Ext.getCmp('END_TIME'+'field').getRawValue())!='00:00')
	    			{	
	    			if((Ext.getCmp('START_TIME'+'field').getRawValue())>=(Ext.getCmp('END_TIME'+'field').getRawValue()))	
	    			{
	    			Ext.example.msg("<%=endTimeMustBeGreaterThanStartTime%>");
						             Ext.getCmp('END_TIME'+'field').focus();
						             return;
	    			}	
	    			}
	    			else{
	    			 if((Ext.getCmp('START_TIME'+'field').getRawValue())>=(Ext.getCmp('END_TIME'+'field').getRawValue()))	
	    			{
	    			Ext.example.msg("<%=endTimeMustBeGreaterThanStartTime%>");
						             Ext.getCmp('END_TIME'+'field').focus();
						             return;
	    			}	
	    			}
	    			}
	    			}
	    			
					if(AdvanceMonitoring.getForm().isValid()) {
                       
 							Ext.Ajax.request({
					 				url: '<%=request.getContextPath()%>/CustomerSettingAction.do?param=saveAdvanceMonitoringDetails',
									method: 'POST',
									params: 
									{ 
									     custName:Ext.getCmp('custsetcomboId').getValue(),
										 RestrictiveMomentStart:Ext.getCmp('dateId').getValue(),
										 RestrictiveMomentEnd:Ext.getCmp('dateId2').getValue(),
										 RestrictiveDistance:Ext.getCmp('RESTRICTIVE_MOMENT_DISTANCE'+'field').getValue(),
										 //RestrictiveNoneMomentStart:Ext.getCmp('RESTRICTIVE_NON_MOMENT_START'+'field').getValue(),
										 //RestrictiveNonMomentEnd:Ext.getCmp('resnonmomentendtimeid').getValue(),
										 AcIdle:Ext.getCmp('ACIDLE_TIME_ALERT'+'field').getValue(),
										 DistanceNearBorder:Ext.getCmp('NEARTO_BOARDER_DISTANCE'+'field').getValue(),
										 DoorSensorIntervalTime:Ext.getCmp('Door_Sensor_Interval'+'field').getValue(),
										 SeatBeltInterval:Ext.getCmp('SEAT_BELT_INTERVAL'+'field').getValue(),
										 SeatBeltDistance:Ext.getCmp('SEATBELT_DISTANCE'+'field').getValue(),
										 Doorsensoralertinsidehub:Ext.getCmp('DOOR_SENSOR_ALERT_INSIDE_HUB'+'field').getValue(),
										 Monday:Ext.getCmp('MONDAY'+'field').getValue(),
										 Tuesday:Ext.getCmp('TUESDAY'+'field').getValue(),
										 Wednesday:Ext.getCmp('WEDNESDAY'+'field').getValue(),
										 Thursday:Ext.getCmp('THURSDAY'+'field').getValue(),
										 Friday:Ext.getCmp('FRIDAY'+'field').getValue(),
										 Saturday:Ext.getCmp('SATURDAY'+'field').getValue(),
										 Sunday:Ext.getCmp('SUNDAY'+'field').getValue(),
										 FirstDayWeek:Ext.getCmp('FIRST_DAY_WEEK'+'field').getValue(),
										 STime:Ext.getCmp('START_TIME'+'field').getValue(),
										 ETime:Ext.getCmp('END_TIME'+'field').getValue(),
										 
										 Monday1:Ext.getCmp('MONDAY1'+'field').getValue(),
										 Tuesday1:Ext.getCmp('TUESDAY1'+'field').getValue(),
										 Wednesday1:Ext.getCmp('WEDNESDAY1'+'field').getValue(),
										 Thursday1:Ext.getCmp('THURSDAY1'+'field').getValue(),
										 Friday1:Ext.getCmp('FRIDAY1'+'field').getValue(),
										 Saturday1:Ext.getCmp('SATURDAY1'+'field').getValue(),
										 Sunday1:Ext.getCmp('SUNDAY1'+'field').getValue(),
										 pageName: pageName
								
										 //NonRestrictiveDistance:Ext.getCmp('nonrestrictivedistanceid').getValue()
									 	 
							         },
									success:function(response, options)//start of success
									{
										Ext.example.msg(response.responseText);
								        var clientId=Ext.getCmp('custsetcomboId').getValue();
			         				  	var idx = customersettingdetails.findBy(function(record){
									  	if(record.get('CustomerId') == clientId){
					    				record.set('RestMomStartTime',Ext.getCmp('dateId').getValue());
				  						//record.set('ResNonMomStartTime',Ext.getCmp('RESTRICTIVE_NON_MOMENT_START'+'field').getValue());
				  						record.set('ResMomEndTime',Ext.getCmp('dateId2').getValue());
				  						//record.set('ResNonMomEndTime',Ext.getCmp('resnonmomentendtimeid').getValue());
				  						record.set('ACIdleTime',Ext.getCmp('ACIDLE_TIME_ALERT'+'field').getValue());
				  						record.set('NearBoarder',Ext.getCmp('NEARTO_BOARDER_DISTANCE'+'field').getValue());
				  						record.set('DoorSensorInt',Ext.getCmp('Door_Sensor_Interval'+'field').getValue());
				  						record.set('SeatBeltInt',Ext.getCmp('SEAT_BELT_INTERVAL'+'field').getValue());
				  						record.set('ResDistance',Ext.getCmp('RESTRICTIVE_MOMENT_DISTANCE'+'field').getValue());
				  						//record.set('NonResDis',Ext.getCmp('nonrestrictivedistanceid').getValue());
				  						record.set('SeatBeltDistance',Ext.getCmp('SEATBELT_DISTANCE'+'field').getValue());
				  						record.set('Doorsensoralertinsidehub',Ext.getCmp('DOOR_SENSOR_ALERT_INSIDE_HUB'+'field').getValue());
				  						record.set('Monday',Ext.getCmp('MONDAY'+'field').getValue());
										record.set('Tuesday',Ext.getCmp('TUESDAY'+'field').getValue());
										record.set('Wednesday',Ext.getCmp('WEDNESDAY'+'field').getValue());
										record.set('Thursday',Ext.getCmp('THURSDAY'+'field').getValue());
										record.set('Friday',Ext.getCmp('FRIDAY'+'field').getValue());
										record.set('Saturday',Ext.getCmp('SATURDAY'+'field').getValue());
										record.set('Sunday',Ext.getCmp('SUNDAY'+'field').getValue());
										record.set('FirstDayWeek',Ext.getCmp('FIRST_DAY_WEEK'+'field').getValue());
										record.set('STime',Ext.getCmp('START_TIME'+'field').getValue());
										record.set('ETime',Ext.getCmp('END_TIME'+'field').getValue());
										
										record.set('Monday1',Ext.getCmp('MONDAY1'+'field').getValue());
										record.set('Tuesday1',Ext.getCmp('TUESDAY1'+'field').getValue());
										record.set('Wednesday1',Ext.getCmp('WEDNESDAY1'+'field').getValue());
										record.set('Thursday1',Ext.getCmp('THURSDAY1'+'field').getValue());
										record.set('Friday1',Ext.getCmp('FRIDAY1'+'field').getValue());
										record.set('Saturday1',Ext.getCmp('SATURDAY1'+'field').getValue());
										record.set('Sunday1',Ext.getCmp('SUNDAY1'+'field').getValue());
										
									  }
									  });
								        	        		
										
									}, // END OF  SUCCESS
								    failure: function()//start of failure 
								    {
								    Ext.example.msg("error");
									     Ext.getCmp('dateId').reset();
										 Ext.getCmp('dateId2').reset();
										 //Ext.getCmp('RESTRICTIVE_NON_MOMENT_START'+'field').reset();
										 //Ext.getCmp('resnonmomentendtimeid').reset();
										 Ext.getCmp('ACIDLE_TIME_ALERT'+'field').reset();
										 Ext.getCmp('NEARTO_BOARDER_DISTANCE'+'field').reset();
										 Ext.getCmp('Door_Sensor_Interval'+'field').reset();
										 Ext.getCmp('SEAT_BELT_INTERVAL'+'field').reset();
										 Ext.getCmp('RESTRICTIVE_MOMENT_DISTANCE'+'field').reset();
										 //Ext.getCmp('nonrestrictivedistanceid').reset();
										 Ext.getCmp('SEATBELT_DISTANCE'+'field').reset();
										 Ext.getCmp('DOOR_SENSOR_ALERT_INSIDE_HUB'+'field').reset();
										 Ext.getCmp('MONDAY'+'field').reset();
										 Ext.getCmp('TUESDAY'+'field').reset();
										 Ext.getCmp('WEDNESDAY'+'field').reset();
										 Ext.getCmp('THURSDAY'+'field').reset();
										 Ext.getCmp('FRIDAY'+'field').reset();
										 Ext.getCmp('SATURDAY'+'field').reset();
										 Ext.getCmp('SUNDAY'+'field').reset();
										 Ext.getCmp('FIRST_DAY_WEEK'+'field').reset();
										 Ext.getCmp('START_TIME'+'field').reset();
										 Ext.getCmp('END_TIME'+'field').reset();
										 
										 Ext.getCmp('MONDAY1'+'field').reset();
										 Ext.getCmp('TUESDAY1'+'field').reset();
										 Ext.getCmp('WEDNESDAY1'+'field').reset();
										 Ext.getCmp('THURSDAY1'+'field').reset();
										 Ext.getCmp('FRIDAY1'+'field').reset();
										 Ext.getCmp('SATURDAY1'+'field').reset();
										 Ext.getCmp('SUNDAY1'+'field').reset();
										 
									} // END OF FAILURE 
						}); // END OF AJAX
					}else{
					Ext.example.msg("<%=validateMessage%>");
					}
			       	
			       	}}}
	    		},{
	    		xtype:'button',
	    		text:'<%=cancel%>',
	    		iconCls:'cancelbutton',
	    		width:70,
	    		listeners: {
			        click:{
			       	fn:function(){
			       	var rsemomstartime="";
			       	var rsenonmomstarttime="";
			       	var rsemomendtime="";
			       	var resnonmomendtime="";
			       	var acidletime="";
			       	var nearborderdis="";
			       	var doorsensorinterval="";
			       	var seatbeltinterval="";
			       	var restrictivedistance="";
			       	var nonrestrictivedis="";
			       	var seatbeltdis="";
			       	 var clientId=Ext.getCmp('custsetcomboId').getValue();
			         var idx = customersettingdetails.findBy(function(record){
									  if(record.get('CustomerId') == clientId){
					    				rsemomstartime=record.get('RestMomStartTime');
								  		//rsenonmomstarttime=record.get('ResNonMomStartTime');
								  		rsemomendtime=record.get('ResMomEndTime');
								  		//resnonmomendtime=record.get('ResNonMomEndTime');
								  		acidletime=record.get('ACIdleTime');
								  		nearborderdis=record.get('NearBoarder');
								  		doorsensorinterval=record.get("DoorSensorInt");
								  		seatbeltinterval=record.get('SeatBeltInt');
								  		restrictivedistance=record.get('ResDistance');
								  		//nonrestrictivedis=record.get('NonResDis');
								  		seatbeltdis=record.get('SeatBeltDistance');
								  		
									  }
									  });
			       	 Ext.getCmp('dateId').setValue(rsemomstartime);
					 Ext.getCmp('dateId2').setValue(rsemomendtime);
					 //Ext.getCmp('RESTRICTIVE_NON_MOMENT_START'+'field').setValue(rsenonmomstarttime);
					// Ext.getCmp('resnonmomentendtimeid').setValue(resnonmomendtime);
					 Ext.getCmp('ACIDLE_TIME_ALERT'+'field').setValue(acidletime);
					 Ext.getCmp('NEARTO_BOARDER_DISTANCE'+'field').setValue(nearborderdis);
					 Ext.getCmp('Door_Sensor_Interval'+'field').setValue(doorsensorinterval);
					 Ext.getCmp('SEAT_BELT_INTERVAL'+'field').setValue(seatbeltinterval);
					 Ext.getCmp('RESTRICTIVE_MOMENT_DISTANCE'+'field').setValue(restrictivedistance);
					 //Ext.getCmp('nonrestrictivedistanceid').setValue(nonrestrictivedis);
					 Ext.getCmp('SEATBELT_DISTANCE'+'field').setValue(seatbeltdis);
					 
					 
			       	}}}
	    		}
	    
					]
		           
		    }); 
	    		
		
    // create some portlet tools using built in Ext tool ids
    var tools = [{
        id:'gear',
        handler: function(){
            Ext.Msg.alert('Message', '.');
        }
    },{
        id:'close',
        handler: function(e, target, panel){
            panel.ownerCt.remove(panel, true);
        }
    }];

/****************window static button panel****************************/	    		 
    var winButtonPanel=new Ext.Panel({
		        	id: 'winbuttonid',
		        	standardSubmit: true,
					collapsible:false,
					height:80,
					cls:'windowbuttonpanel',
					frame:true,
					layout:'table',
					layoutConfig: {
						columns:2
					},
					items: [
					{
					id:'id1',
					width:'450px'
					},
	       			{
	       			xtype:'button',
	      			text:'<%=cancel%>',
	        		id:'canButtId',
	        		iconCls:'cancelbutton',
	        		cls:'winbuttonstyle',	
	        		width:'70px',
	       			listeners: 
	       			{
	        			click:
	        			{
	       					fn:function()
	       					{
	       					myWin.hide();
	       					enableTabElements();
	       					
	       					}}}
	       		}
					]
		           
		    }); 

var outerPanelWindow=new Ext.Panel({
			cls:'outerpanelwindow',
			autoScroll:false,
			standardSubmit: true,
			frame:false,
			items: [panel, winButtonPanel]
			}); 
   /***********************window for form field****************************/	
var myWin = new Ext.Window({
        title:'',
        closable: false,
        modal: true,
        resizable:false,
        autoScroll: true,
        cls:'mywindow',
        //height : 400,
        //width  : 550,
        id     : 'myWin',
        items  : [outerPanelWindow]
    });
    
   
    
  //client panel for selecting customerPanel
  var customerPanel = new Ext.Panel({
		standardSubmit: true,
		frame:false,
		collapsible:false,
		border: false,
		width:'90%',
		height:70,
		region:'north',
		id:'custSettclientDetails',
		layout:'table',
		layoutConfig: {
			columns:2
		},
		items: [{border: false,width:20,height:10},{border: false,width:20,height:10},
	    		{
				xtype: 'label',
				cls:'labellargestyle',
				text:'<%=custName%>'+'  :'
				},customersettingcombo,
				{
				xtype: 'label',
				cls:'labellargestyle',
				text:'<%=image%>'+':'
				},
				imagepanel
		
		
		]});
		
var buttonPanel=new Ext.FormPanel({
		 id: 'buttonid',
		 width:'100%',
		 height:30,
		 layout: 'fit',
		 frame:true,
		 buttons:[{
			       text: '<%=next%>',
			       iconCls:'nextbutton',
			       handler : function(){
			        var customerId=Ext.getCmp('custsetcomboId').getValue();
			        if(customerId==""){
			        Ext.example.msg("<%=selCustName%>");
           					return;
       						}
    				 var assetgroupurl='<%=request.getContextPath()%>/Jsps/Admin/AssetGroup.jsp?CustId='+customerId;
					 parent.Ext.getCmp('assetGroupTab').enable();
					 parent.Ext.getCmp('assetGroupTab').show();
					 parent.Ext.getCmp('assetGroupTab').update("<iframe style='width:100%;height:530px;border:0;'  src='"+assetgroupurl+"'></iframe>");
			       }
			      }]		      
	});
	//viewport for displaying all panel depending clicking label
	 var viewport = new Ext.Viewport({
        layout:'border',
        width:'100%',
        border: false,
        autoScroll:false,
         items:[customerPanel,{
            xtype: 'grouptabpanel',
    		tabWidth: '180',
    		id:'tabid',
    		width:'10%',
    		region:'center',
    		//height:200,
    		//width:500,
    		activeGroup: 0,
    		items: [{
                expanded: false,
                items: [{
                    title: '<%=essentialMonitoring%>',
                    id:'essentialmonit',
                    iconCls: 'x-icon-configuration',
                    tabTip: '<%=essentialMonitoring%>',
                    style: 'padding: 10px;',
					autoScroll:false,
                    items:[EssentialMonitoring,EssentialButtonPanel] 
                }]
            }, {
                expanded: false,
                items: [{
                    title: '<%=advanceMonitoring%>',
                    id:'advancemonit',
                    iconCls: 'x-icon-configuration',
                    tabTip: '<%=advanceMonitoring%>',
                    style: 'padding: 10px;',
                    autoScroll:false,
                    items:[AdvanceMonitoring,AdvwinButtonPanel] 
                }]
            },
            {
                expanded: false,
                items: [{
                    title: '<%=milkdistributionlogistics%>',
                    id:'milkdislogid',
                    iconCls: 'x-icon-configuration',
                    tabTip: '<%=milkdistributionlogistics%>',
                    style: 'padding: 10px;',
                    items:[MilkDistributionLogistics] 
                }]
            },{
                expanded: false,
                items: [{
                    title: '<%=healthandsafetyassurance%>',
                    id:'healsafassid',
                    iconCls: 'x-icon-configuration',
                    tabTip: '<%=healthandsafetyassurance%>',
                    style: 'padding: 10px;',
                    items:[HealthAndSafetyAssurance] 
                }]
            }
            ]
           
		}
		,{  
            region:'south',
            height:'70',
            width:'100%',
            items:[buttonPanel]
            //bbar:ctsb
            }]
    });	
//*****main starts from here*************************
 Ext.onReady(function() {
 Ext.QuickTips.init();
 Ext.getCmp('essentialmonit').setTitle('');
 Ext.getCmp('advancemonit').setTitle('');
  Ext.getCmp('milkdislogid').setTitle('');
  Ext.getCmp('healsafassid').setTitle('');
 Ext.form.Field.prototype.msgTarget = 'side';
 Ext.getCmp('tabid').hide();
 
 <%
 for(int i=0;i<columnLists.size();i++){
 if(!(columnLists.get(i).toString().equals("RESTRICTIVE_NON_MOMENT_START")) && !(columnLists.get(i).toString().equals("RESTRICTIVE_NON_MOMENT_DISTANCE")) && !(columnLists.get(i).toString().equals("RESTRICTIVE_NON_MOMENT_END")) && !(columnLists.get(i).toString().equals("RESTRICTIVE_NON_MOMENT_START"))
 && !(columnLists.get(i).toString().equals("PAYMENT_NOTIFICATIONPERIOD")) && !(columnLists.get(i).toString().equals("PAYMENTDUE_DATE")) ){
 %>
 Ext.getCmp('<%=columnLists.get(i).toString()%>'+'label').show();
 Ext.getCmp('<%=columnLists.get(i).toString()%>'+'field').show();
 Ext.getCmp('<%=columnLists.get(i).toString()%>'+'htm').show();
 <%
 }
 }
 %>
 



});
	<%}%>		
 </script>
  </body>

  
</html>