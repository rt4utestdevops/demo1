<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	Properties properties = ApplicationListener.prop;
	//String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	Properties prop = ApplicationListener.prop;
	String WEIGHTwebServicePath=prop.getProperty("WebServiceUrlPathForWeight");
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
	
	StringBuffer hrlist=cf.getExtList(0,24);
    StringBuffer minlist=cf.getExtList(0,60);
	
	Date getLocalDateTime = new Date();
	SimpleDateFormat ddmmyyyy = new SimpleDateFormat("HH:mm");
	String todaysTime = ddmmyyyy.format(getLocalDateTime);

	String[] arr = todaysTime.split(":");
	String hours=arr[0];
	String minutes=arr[1];

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("UniqueId_No");
tobeConverted.add("Consumer_Application_No");
tobeConverted.add("MDP_No");
tobeConverted.add("Vehicle_No");
tobeConverted.add("Validity_Period");
tobeConverted.add("Transporter_Name");
tobeConverted.add("Customer_Name");
tobeConverted.add("Driver_Name");
tobeConverted.add("Transporter");
tobeConverted.add("ML_No");
tobeConverted.add("Customer_Address");
tobeConverted.add("District");
tobeConverted.add("Quantity");
tobeConverted.add("Via_Route");
tobeConverted.add("To_Place");
tobeConverted.add("Sand_Port_No");
tobeConverted.add("Sand_Port_Unique_No");
tobeConverted.add("Valid_From");
tobeConverted.add("Valid_To");
tobeConverted.add("Mineral_Type");
tobeConverted.add("Loading_Type");
tobeConverted.add("Survey_No");
tobeConverted.add("Village");
tobeConverted.add("Taluka");
tobeConverted.add("Amount_CubicMeter");
tobeConverted.add("Processing_Fees");
tobeConverted.add("Total_Fee");
tobeConverted.add("Printed");
tobeConverted.add("MDP_Date");
tobeConverted.add("DD_No");
tobeConverted.add("Bank_Name");
tobeConverted.add("DD_Date");
tobeConverted.add("Group_Id");
tobeConverted.add("Group_Name");
tobeConverted.add("Index_No");
tobeConverted.add("Sand_Loading_From_Time");
tobeConverted.add("Sand_Loading_To_Time");
tobeConverted.add("Select_Consumer_Application_No");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Cancel");
tobeConverted.add("Save");
tobeConverted.add("select_vehicle_No");
tobeConverted.add("Select_Sand_Port");
tobeConverted.add("Select_To_Place");
tobeConverted.add("Select_Loading_Type");
tobeConverted.add("Modify");
tobeConverted.add("PDF");
tobeConverted.add("Excel");
tobeConverted.add("Consumer_MDP_Generator");
tobeConverted.add("From_Sand_Port");
tobeConverted.add("Contact_No");
tobeConverted.add("Something_Wrong_In_weight");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SLNO=convertedWords.get(0);
String UniqueId_No=convertedWords.get(1);
String Consumer_Application_No=convertedWords.get(2);
String MDP_No=convertedWords.get(3);
String Vehicle_No=convertedWords.get(4);
String Validity_Period=convertedWords.get(5);
String Transporter_Name=convertedWords.get(6);
String Customer_Name=convertedWords.get(7);
String Driver_Name=convertedWords.get(8);
String Transporter=convertedWords.get(9);
String ML_No=convertedWords.get(10);
String Customer_Address=convertedWords.get(11);
String District=convertedWords.get(12);
String Quantity=convertedWords.get(13);
String Via_Route=convertedWords.get(14);
String To_Place=convertedWords.get(15);
String Sand_Port_No=convertedWords.get(16);
String Sand_Port_Unique_No=convertedWords.get(17);
String Valid_From=convertedWords.get(18);
String Valid_To=convertedWords.get(19);
String Mineral_Type=convertedWords.get(20);
String Loading_Type=convertedWords.get(21);
String Survey_No=convertedWords.get(22);
String Village=convertedWords.get(23);
String Taluka=convertedWords.get(24);
String Amount_CubicMeter=convertedWords.get(25);
String Processing_Fees=convertedWords.get(26);
String Total_Fee=convertedWords.get(27);
String Printed=convertedWords.get(28);
String MDP_Date=convertedWords.get(29);
String DD_No=convertedWords.get(30);
String Bank_Name=convertedWords.get(31);
String DD_Date=convertedWords.get(32);
String Group_Id=convertedWords.get(33);
String Group_Name=convertedWords.get(34);
String Index_No=convertedWords.get(35);
String Sand_Loading_From_Time=convertedWords.get(36);
String Sand_Loading_To_Time=convertedWords.get(37);
String Select_Consumer_Application_No=convertedWords.get(38);
String No_Records_Found=convertedWords.get(39);
String Clear_Filter_Data=convertedWords.get(40);
String Add=convertedWords.get(41);
String No_Rows_Selected=convertedWords.get(42);
String Select_Single_Row=convertedWords.get(43);
String Cancel=convertedWords.get(44);
String Save=convertedWords.get(45);
String select_vehicle_No=convertedWords.get(46);
String Select_Sand_Port=convertedWords.get(47);
String Select_To_Place=convertedWords.get(48);
String Select_Loading_Type=convertedWords.get(49);
String Modify=convertedWords.get(50);
String PDF=convertedWords.get(51);
String Excel=convertedWords.get(52);
String Consumer_MDP_Generator=convertedWords.get(53);
String From_Sand_Port=convertedWords.get(54);
String Distance="Distance";
String Contact_No = convertedWords.get(55);
String SomethingWronginweight=convertedWords.get(56);

String startHr = "";
%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>ILMS MDP Integration</title>	
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.my-label-style2-1 {
                font-weight: bold;
                font-size: 15px;
                text-align: center;
            }
  </style>
  <body>
    <%if(loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
	<%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
	
   <script>
var setLocation="false";
var outerPanel;
var ctsb;
var jspname = "ILMS_MDP_Integration";
var exportDataType = "int,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string,string";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var dtcur = datecur;
var dtnext=datenext;
var custname="";
var mdpNoModify 
var permitNoModify;
var transporterModify;
var loadingTypeModify; 
var surveyNoModify;
var villageModify; 
var talukModify; 
var districtModify;
var quantityModify; 
var amountModify; 
var totalFeeModify; 
var fromPlaceModify; 
var toPlaceModify;
var sandPortNoModify; 
var sandPortUniqueIdModify; 
var validFromModify;
var validToModify; 
var customerNameModify ;
var driverNameModify ;
var viaRouteModify ;
var mineralTypeModify;
var vehicleNoModify;
var SandLoadingFromTimeModify;
var SandLoadingToTimeModify;
var applicationNoModify;
var transporter ;
var vehicleNo;
var customerAddress;
var todaysDate = new Date();
var uniqueIdModify;
var validityPeriodModify;
var MlNoModify;
var processingFeeModify;
var vehicleAddrModify;
var printedModify;
var TSDateModify;
var DDNoModify;
var bankNameModify;
var DDDateModify;
var groupIdModify ;
var groupNameModify;
var indexNoModify;
var mineralTypeModify;
var DD_NoNew;
var DD_Date;
var Bank_Name;
var DD_Date;
var groupId;
var groupName;
var ValidFromNew;
var DailyOff1;
var ValidToNew;
var DailyOff2;
var TSFormatNew;
var LoadCapacityNew;
var LoadTypeNew;
var SelfAmountNew;
var MachineAmountNew;
var DefaultLoadType;
var TripSheetFormat;
var SandLoadingFromTime;
var SandLoadingToTime;
var messageQuant="";  
var startdate = "";    
var ts="";  
var uniqueID="";
var date=new Date();
//var availableSand=0;
var assessedquantity="";
var rate="";
var sandportUniqueidModify="";
var extractionTypeModify="";
var stockyardUID="";
var fromPlaceAdd="";
var distance;
var stockyardlat;
var stockyardlong;
var lat;
var longi;
var longitude;
var latitude;      
var destlatlong;
var myDate = new Date();
myDate.setHours(myDate.getHours() + 24);
var nxtdate=nextDate;
nxtdate.setHours(23);
nxtdate.setMinutes(59);
nxtdate.setSeconds(59);
var previousDate = new Date().add(Date.DAY, -1);
previousDate.setHours(23);
previousDate.setMinutes(59);
previousDate.setSeconds(59);
var VehicleWeightRec;
var grossweight;
var loadingCapacity;

var storeHrs = [<%=hrlist%>];
var storeMin = [<%=minlist%>];

var clickCount = 0;
var portLocationId ="";


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
                params:{ClientId: custId,
                        jspname:jspname,
                        custname:custname}
                });
		        //PermitStoreNew.load({params:{clientId:custId}});
		        FromSandPortStore.load({params:{clientId:custId}});
		        // ToPlaceStore.load({params:{clientId:custId}});
                // ApplicationNoStore.load({params:{clientId:custId}});
                // fromStockyardStore.load({params:{clientId:custId}});
            }
        }
    }
});

var Client = new Ext.form.ComboBox({
    store: clientcombostore,
    id: 'custcomboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Client',
    blankText: 'Select Client',
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
				store.load({params:{ClientId: custId,
				        jspname:jspname,
                        custname:custname}});
		        //PermitStoreNew.load({params:{clientId:custId}});
		        FromSandPortStore.load({params:{clientId:custId}});
		        //ToPlaceStore.load({params:{clientId:custId}});
		        //vehicleNoStore.load({params:{clientId: custId}});
		        //ApplicationNoStore.load({params:{clientId:custId}});
		        //fromStockyardStore.load({params:{clientId:custId}});
		      MDPTripSheetTimingsStore.load({
                    params: {
                            clientId: custId
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
            text: 'Client Name' + ' :',
            cls: 'labelstyle',
            id:'clientlabelid'
        },
        Client
    ]
});
		var velicleWeightStore = new Ext.data.JsonStore({
		 		   url:'<%=request.getContextPath()%>/ILMS_MDP_GenetationAction.do?param=getVehicleWeight',
				   id:'velicleWeightStoreId',
			       root: 'velicleWeightStoreList',
			       autoLoad: false,
			       remoteSort:true,
				   fields: ['UnloadWeight','loadWeight','netWeight','readUnladenWeightFromApp']
		}); 


	var PermitStoreNew= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/ILMS_MDP_GenetationAction.do?param=getPermitsNewGRID',
				   id:'PermitStoreNewId',
			       root: 'PermitstoreNewList',
			       autoLoad: false,
			       remoteSort:true,
				   fields: ['PermitNoNew','OwnerNameNew','Owner_TypeNew','PortNew','LoadCapacityNew','Group_Name','Group_Id','blockVehicle','loadingCapacity']
			     });
			     
      	var PermitComboNew=new Ext.form.ComboBox({
				  frame:true,
				  store: PermitStoreNew,
				  id:'PermitComboNewId',
				  width: 175,
				  forceSelection:true,
				  emptyText:'<%=select_vehicle_No%>',
				  anyMatch:true,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  triggerAction: 'all',
				  displayField: 'PermitNoNew',
				  valueField: 'PermitNoNew',
				  cls: 'selectstylePerfect',
				  listeners: {
		                select: {
		                 	 fn:function(){ 
		                 	 Ext.getCmp('unloadWeightTextId').reset();
							 Ext.getCmp('loadingWeightTextId').reset();
							 Ext.getCmp('netWeightTextId').reset();
							 
		                 	 permitNo=Ext.getCmp('PermitComboNewId').getValue();
							 var row = PermitStoreNew.find('PermitNoNew',permitNo);
							 var rec = PermitStoreNew.getAt(row);
							 LoadCapacityNew=rec.data['LoadCapacityNew'];
							 
							 loadingCapacity=rec.data['loadingCapacity'];
							 
							 groupId=rec.data['Group_Id'];
							 groupName=rec.data['Group_Name'];	
							 var blockedVehicle = rec.data['blockVehicle'];
							 
							 console.log("loadingCapacity :::: " + loadingCapacity);
							 if(permitNo == blockedVehicle){
							 	Ext.example.msg("Vehicle No "+permitNo+" is Blocked");
							 	Ext.getCmp('PermitComboNewId').reset();
								return;
							 }
							 
							  if(<%=systemId%>==296){
							  
							  Ext.Ajax.request({
							  url: '<%=request.getContextPath()%>/ILMS_MDP_GenetationAction.do?param=getMdpCountAndLoadingCapacityFromDb',
							  method: 'POST',
							  params:
							  {
							     clientId:custId,
							     portId:portLocationId
							     //portId:Ext.getCmp('FromSandPortStoreId').getValue()
							  },
							  success:function(response)
							  {
							    var newResponse = response.responseText;
							    console.log("newResponse ::" + newResponse);
							   var count = JSON.parse(newResponse);
							   console.log(count.MdpCountLoadingCapacityList);
							   loadingCapacityDBValueType1=count.MdpCountLoadingCapacityList[0].loadingCapacityFromDBType1;
							   mdpCountDBValueType1=count.MdpCountLoadingCapacityList[0].mdpCountFromDBType1;
							   loadingCapacityDBValueType2=count.MdpCountLoadingCapacityList[0].loadingCapacityFromDBType2;
							   mdpCountDBValueType2=count.MdpCountLoadingCapacityList[0].mdpCountFromDBType2;
							   loadingCapacityDBValueType3=count.MdpCountLoadingCapacityList[0].loadingCapacityFromDBType3;
							   mdpCountDBValueType3=count.MdpCountLoadingCapacityList[0].mdpCountFromDBType3;
							  // console.log("mdpCountFromDB === "+count.MdpCountLoadingCapacityList[0].mdpCountFromDB);
							  // console.log("loadingCapacityFromDB === "+count.MdpCountLoadingCapacityList[0].loadingCapacityFromDB);
							    
							   
							  }, 
							  failure: function(response)
	                          {
	                          	Ext.Msg.alert("Failure :: " + response);
	                          }
	                        }); 
	                        
	                        if(Ext.getCmp('FromSandPortStoreId').getRawValue() == "BALKUR BLOCK NO 4 STOCKYARD NO 4")
	                        {
	                          
	                        //console.log(" Ext.getCmp('FromSandPortStoreId').getValue() 4 " + Ext.getCmp('FromSandPortStoreId').getValue());
	                        Ext.Ajax.request({
							  url: '<%=request.getContextPath()%>/ILMS_MDP_GenetationAction.do?param=getMDPCountForLocation4',
							  method: 'POST',
							  params:
							  {
							     vehicleNo : permitNo
							  },
							  success:function(response)
							  {
							    var newResponse = response.responseText;
							   // console.log("newResponse  " ,newResponse );
							    var mdpCount = JSON.parse(newResponse).MDPCountForLocationList[0].count;
							   // console.log("mdpCount :::  " ,mdpCount );
							    if(mdpCount == 1){
							    	Ext.Msg.alert("1 MDP per Day for this Stockyard ");
							    	myWin.hide();
 							    Ext.getCmp('FromSandPortStoreId').reset();
							    Ext.getCmp('PermitComboNewId').reset();
							    } 	
							   
							  }, 
							  failure: function(response)
	                          {
	                          	Ext.Msg.alert("Failure in ajax ::  " + response);
	                          }
	                        });
	                        }
	                           
	                        if(Ext.getCmp('FromSandPortStoreId').getRawValue() == "HALNAD BLOCK NO 6 STOCKYARD NO 6")
	                        {
	                        //console.log(" Ext.getCmp('FromSandPortStoreId').getValue() 6 " + Ext.getCmp('FromSandPortStoreId').getValue());
	                        Ext.Ajax.request({
							  url: '<%=request.getContextPath()%>/ILMS_MDP_GenetationAction.do?param=getMDPCountForLocation6',
							  method: 'POST',
							  params:
							  {
							     vehicleNo : permitNo
							  },
							  success:function(response)
							  {
							    var newResponse = response.responseText;
							   // console.log("newResponse  " ,newResponse );
							    var mdpCount = JSON.parse(newResponse).MDPCountForLocationList[0].count;
							   // console.log("mdpCount :::  " ,mdpCount );
							    if(mdpCount == 1){
							    	Ext.Msg.alert("1 MDP per Day for this Stockyard ");
							    	myWin.hide();
 							    Ext.getCmp('FromSandPortStoreId').reset();
							    Ext.getCmp('PermitComboNewId').reset();
							    } 	
							   
							  }, 
							  failure: function(response)
	                          {
	                          	Ext.Msg.alert("Failure in ajax ::  " + response);
	                          }
	                        }); 
	                        }
	                         
							  Ext.Ajax.request({
							  url: '<%=request.getContextPath()%>/ILMS_MDP_GenetationAction.do?param=getUnladenWeight',
							  method: 'POST',
							  params:
							  {
							     vehicleNo : permitNo
							  },
							  success:function(response)
							  {
							    var newResponse = response.responseText;
							    var mdpCount = JSON.parse(newResponse).UnladenList[0].count;
							    //console.log("loadingCapacity  " ,loadingCapacity );
							    //console.log("mdpCount  " ,mdpCount );
							    if(loadingCapacity == 0){
							    	Ext.Msg.alert("Cannot Generate MDP with 0 Loading Capacity");
							    	myWin.hide();
							     Ext.getCmp('FromSandPortStoreId').reset();
							    Ext.getCmp('PermitComboNewId').reset();
							    } 
							    //if(loadingCapacity > 4000 && !(mdpCount <2)){
							    if(loadingCapacity > loadingCapacityDBValueType1 && !(mdpCount <mdpCountDBValueType1)){
							    	Ext.Msg.alert("2 MDP per Day for more than 3 Ton vehicles");
							    	myWin.hide();
 							    Ext.getCmp('FromSandPortStoreId').reset();
							    Ext.getCmp('PermitComboNewId').reset();
							    }
							    //else if((loadingCapacity <= 4000 && loadingCapacity > 0 ) && !(mdpCount <3)){
							    else if((loadingCapacity <= loadingCapacityDBValueType2 && loadingCapacity > 0 ) && !(mdpCount <mdpCountDBValueType2)){
							    	Ext.Msg.alert("3 MDP per Day for less than 3 Ton vehicles");	
							    	myWin.hide();
							    Ext.getCmp('FromSandPortStoreId').reset();
							    Ext.getCmp('PermitComboNewId').reset();
							    }
							   
							  }, 
							  failure: function(response)
	                          {
	                          	Ext.Msg.alert("Failure :: " + response);
	                          }
	                        }); 
	                        
	                        }
							 
		                 	// FromSandPortStore.load({params:{clientId:custId}});
		                 	 
		              
						}
					}
				}
	       });


var FromSandPortStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/ILMS_MDP_GenetationAction.do?param=getFromSandPortStore',
				   id:'FromSandPortStore1',
			       root: 'FromSandPortStoreList',
			       autoLoad: true,
			       remoteSort:true,
				    fields: ['portNo','portName','portVillage','portTaluk','portSurveyNumber','portUniqueid','assessedQuantity','DD_NoNew','DD_Date','Bank_Name','ValidFromNew','DailyOff1','ValidToNew','DailyOff2','TSFormatNew','SelfAmountNew','MachineAmountNew','LoadTypeNew','lat','longi']
			     })
			     
 var FromSandPort = new Ext.form.ComboBox({
     			frame:true,
				  store: FromSandPortStore,
				  id:'FromSandPortStoreId',
				  width: 175,
				  forceSelection:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  hidden:false,
				  anyMatch:true,
	              onTypeAhead:true,
	              enableKeyEvents:true,
				  triggerAction: 'all',
				  displayField: 'portName',
				  valueField: 'portName', 
	        	  emptyText:'Select Port',
	        	  cls: 'selectstylePerfect',
	        	  
	        	   listeners: {
		                   select: {
		                 	   fn:function(){
		                 	  var stockyard=Ext.getCmp('FromSandPortStoreId').getValue();
		                 	  var row = FromSandPortStore.find('portName',stockyard);
							  var rec = FromSandPortStore.getAt(row);
							  uniqueID=rec.data['portUniqueid'];
							  portLocationId =uniqueID;
							   var lat=rec.data['lat'];
							   var lon=rec.data['longi'];
							   var loc=rec.data['portName'];
							   parent.test3(lat,lon,loc);
							   
							  Ext.getCmp('setLocationId').enable();
							  Ext.Ajax.request({
							  url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getmaxTripSheetNo',
							  method: 'POST',
							  params:
							  {
							    ClientId: custId
							  },
							  success:function(response, options)
							  {
							    var tsno=response.responseText;
							   // ts=ts+"-"+tsno;
							    Ext.getCmp('mdpNoId').setValue(tsno);
							  }, // end of success
							  failure: function(response, options)
	                          {
	                            Ext.getCmp('mdpNoId').setValue(ts+"-");
	                          }// end of failure
	                        }); // end of Ajax	
	                        Ext.getCmp('PermitComboNewId').reset();
	                        PermitStoreNew.load({
	                        params:{
	                        clientId:custId,
	                        sourceLat : lat,
	                        sourceLong : lon
	                        }});
		        }         	 	
              } 
		    } 
	   }); 
	   
 var MDPTripSheetTimingsStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/ILMS_MDP_GenetationAction.do?param=getMDPTripSheetTimings',
    id: 'MDPTripSheetTimingsId',
    root: 'MDPTripSheetTimingsRoot',
    autoLoad: false,
    remoteSort: true,
    fields: ['messageId','validTime']
 });
 
 
 // 12345
  		var startCombo = new Ext.form.ComboBox({
     			  frame:true,
				  store: storeHrs,
				  id:'startComboId',
				  width: 46,
				  forceSelection:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  hidden:false,
				  anyMatch:true,
	              onTypeAhead:true,
	              enableKeyEvents:true,
				  triggerAction: 'all',
				  displayField: '',
				  valueField: '', 
	        	  //emptyText:'0',
	        	  value:'<%=hours%>'
		});
		var minCombo = new Ext.form.ComboBox({
     			  frame:true,
				  store: storeMin,
				  id:'minComboId',
				  width: 46,
				  forceSelection:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  hidden:false,
				  anyMatch:true,
	              onTypeAhead:true,
	              enableKeyEvents:true,
				  triggerAction: 'all',
				  displayField: '',
				  valueField: '', 
	        	 // emptyText:'0',
	        	  value:'<%=minutes%>'
	        	  
		});
         var startTime = new Ext.Panel({
			    			layout:'table',
			    			id:'startTimeId',
			    			layoutConfig: {
			       					columns: 6
			    			},
			    			items: [{
			    				  xtype : 'label',
			                     width : 60,
			        			 text: 'HRMIN',
			        			 cls: 'myStyle' 
			    			},startCombo,{
			                     xtype : 'label',
			        			 width: 0,
			        			 cls: 'myStyle' 
			                },minCombo,{
			                     xtype : 'label',
			        			 width: 5,
			        			 cls: 'myStyle' 
			                },{
			                   
			                }]
			});

// 12345			

var innerPanelForMDPGenerator = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 400,
    width: 850,
    frame: true,
    id: 'innerPanelForMDPGeneratorId',
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
        id: 'MDPGenerationDetailsId',
        width: 820,
        layout: 'table',
        layoutConfig: {
            columns: 8
        },
       items: [        
         {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'fromSandPortid1'
        },{
            xtype: 'label',
            text: 'Loading Location' + ' :',
            cls: 'labelstyle',
            id: 'fromSandPortLabelId'
        },FromSandPort, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'fromSandPortid2'
        }, {},{},{},{},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'permitNoId1'
        }, {
            xtype: 'label',
            text: '<%=Vehicle_No%>' + ' :',
            cls: 'labelstyle',
            id: 'permitnoLabelId'
        },PermitComboNew, 
		{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'permitNoId2'
        },{width : 50},{
				                xtype: 'label',
				                text: 'Serial Port Weigh Bridge  : ',
				                cls: 'labelstyle'
				                },{
               					 xtype: 'checkbox',
				                 name: 'checkBoxPanel3',
				                 id: 'weighScaleMeasureId',
				                 checked: true,
				                 inputValue: true, 
				                 uncheckedValue: false
				                 
				},{width:12},
        		{
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'tripsheetno1'
              },{
                  xtype: 'label',
                  text: 'ILMS Trip Sheet Number' + ' :',
                  cls: 'labelstyle',
                  id: 'tripSheetNoLabelId'
              }, {
				xtype: 'textfield',
				cls: 'selectstylePerfect',
				allowBlank: false,
				size: "100", 
				blankText: '',
				emptyText: '',
				labelSeparator: '',
				id: 'tripsheetNOId'
			} ,  {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'tripsheetno2'
              },{width : 50},{
                                    xtype: 'button',
                                    text: 'Capture Weight',
                                    //iconCls: 'capturebutton',
                                    scale: 'large',
                                    name: 'filepath',
                                    id: 'captureWeightIdT',
                                    width: 150,
                                    cls: 'buttonstyle',
                                    listeners: {
                                        click: {
                                            fn: function(){
                                            if (weighScaleMeasureId.checked) {
                                            if (Ext.getCmp('PermitComboNewId').getValue() == "") {
                        								Ext.example.msg("<%=select_vehicle_No%>");
								                        return;
								                    } 
								       /*     if (Ext.getCmp('PermitComboNewId').getValue() != "") {
								                    clickCount=1;
								                    }*/
                                            $.ajax({
                                                        type: "GET",
                                                        url: '<%=WEIGHTwebServicePath%>',
                                                        success: function(data) {
															if(data.indexOf('Something is wrong. Please check')<0){
															var netBW;
                                                            	Ext.getCmp('unloadWeightTextId').setValue(parseFloat(LoadCapacityNew));
                                                            	Ext.getCmp('loadingWeightTextId').setValue(parseFloat(data));
                                                            	netBW=data-LoadCapacityNew;
                                                            	if(netBW <= 0){
                                                            	Ext.example.msg("Load Weight Should Greater Than Unload Weight");
                                                            	Ext.getCmp('netWeightTextId').setValue(0);
                                                            	}else{
                                                            	Ext.getCmp('netWeightTextId').setValue(parseFloat(netBW));
                                                            	}
                                                            }
                                                        },
                                                        error: function() {
                                                            Ext.example.msg("<%=SomethingWronginweight%>");
                                                        }
                                                    }); 
                                                    }else{
                                                    if (Ext.getCmp('PermitComboNewId').getValue() == "") {
                        								Ext.example.msg("<%=select_vehicle_No%>");
								                        return;
								                    }
						                                velicleWeightStore.load({
						                        		params:{
						                        		permitNo : permitNo
						                        		},
						                        		callback: function(){
						                        			
						                        			var netWt;
						                        			var readUnladenWeightFromApp;
						                        			VehicleWeightRec = velicleWeightStore.getAt(0);
						                        			
						                        			if(VehicleWeightRec.data['readUnladenWeightFromApp']=='Y'){
						                        			Ext.getCmp('unloadWeightTextId').setValue(parseFloat(LoadCapacityNew));
						                        			Ext.getCmp('loadingWeightTextId').setValue(VehicleWeightRec.data['loadWeight']);
						                        			
						                        			netWt=VehicleWeightRec.data['loadWeight'] - LoadCapacityNew;
						                        			}else{
						                        			Ext.getCmp('unloadWeightTextId').setValue(VehicleWeightRec.data['UnloadWeight']);
						                        			Ext.getCmp('loadingWeightTextId').setValue(VehicleWeightRec.data['loadWeight']);
						                        			
						                        			netWt=VehicleWeightRec.data['loadWeight'] - VehicleWeightRec.data['UnloadWeight'];
						                        			}
						                        			
						                        			if(netWt <=0){
						                        			Ext.example.msg("Load Weight Should Greater Than Unload Weight");
						                        			Ext.getCmp('netWeightTextId').setValue(0);
						                        			}else{
						                        			Ext.getCmp('netWeightTextId').setValue(netWt);
						                        			}
						                        			if(VehicleWeightRec.data['UnloadWeight'] == "0" &&  VehicleWeightRec.data['loadWeight'] == "0"){
						                        			Ext.example.msg("Vehicle weight is not available");
						                        			}
						                        			}
						                        		});
                                                    }
                                            } //fun
                                        } //click
                                    } //listeners
                                } ,{},{},
              {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mdpNoid1'
        }, {
            xtype: 'label',
            text: '<%=MDP_No%>' + ' :',
            cls: 'labelstyle',
            id: 'mdpNolabelid'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            readOnly:true,
            id: 'mdpNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mdpNoid2'
        },
        {width : 50},{
            xtype: 'label',
            text: 'Unladen Weight' + ' :',
            cls: 'my-label-style2-1',
            //cls: 'labelstyle',
            id: 'unloadWeightLabId'
        },{
				xtype: 'textfield',
				cls: 'selectstylePerfect',
				allowBlank: false,
				size: "100", 
				blankText: '',
				emptyText: '0.0',
				labelSeparator: '',
				readOnly:true,
				id: 'unloadWeightTextId'
			},{
	            xtype: 'label',
	            text: 'Kg',
	            cls: 'labelstyle',
	            id:'unloadKgsId'
        		},
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'contactNoId1'
        },
         {
            xtype: 'label',
            text: '<%=Contact_No%>' + ' :',
            cls: 'labelstyle',
            id: 'contactNolabelid'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,            
            //size: "10", 
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            autoCreate :  { //restricts user to 15 chars max, cannot enter 16th char
             tag: "input", 
             maxlength : 15, 
             type: "text", 
             size: "15", 
             autocomplete: "off"},
           // maxLength: 15,
            id: 'contactNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'contactNoid2'
        },{width : 50},{
            xtype: 'label',
            text: 'Gross Weight' + ' :',
            cls: 'my-label-style2-1',
            //cls: 'labelstyle',
            id: 'loadingWeightLabId'
        },{
				xtype: 'textfield',
				cls: 'selectstylePerfect',
				allowBlank: false,
				size: "100", 
				blankText: '',
				emptyText: '0.0',
				labelSeparator: '',
				readOnly:true,
				id: 'loadingWeightTextId'
			},{
	            xtype: 'label',
	            text: 'Kg',
	            cls: 'labelstyle',
	            id:'loadKgsId'
        	},		
		{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'custAddressId1'
        },
         {
            xtype: 'label',
            text: 'Customer Name/ Address' + ' :',           
            cls: 'labelstyle',
            id: 'custAddresslabelid'
        }, {
            xtype: 'textarea',
            cls: 'selectstylePerfect',
            allowBlank: false,
            size: "100", 
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'custAddressId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'custAddressid2'
        },{width : 50},{
            xtype: 'label',
            text: 'Net Weight' + ' :',
            cls: 'my-label-style2-1',
            //cls: 'labelstyle',
            id: 'netWeightLabId'
        },{
				xtype: 'textfield',
				cls: 'selectstylePerfect',
				allowBlank: false,
				size: "100", 
				blankText: '',
				emptyText: '0.0',
				labelSeparator: '',
				readOnly:true,
				id: 'netWeightTextId'
			},{
	            xtype: 'label',
	            text: 'Kg',
	            cls: 'labelstyle',
	            id:'netKgsId'
        	},
       
              {
            	xtype: 'label',
            	text: '*',
            	cls: 'mandatoryfield',
            	id: 'setLoc1'
       		 }, {
            	xtype: 'label',
            	text: 'Destination' + ' :',
            	cls: 'labelstyle',
            	id: 'destinationId'
        	}, {
        xtype: 'button',
        text: 'Set Location',
        id: 'setLocationId',
        cls: 'buttonstyle',
        //iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                var setLocation="true";
                parent.Ext.getCmp('MDPMaptab').enable();
	            parent.Ext.getCmp('MDPMaptab').show();
                parent.BackOption(1);
					                     
                if ( <%= customerId == 0 %> ) {
                	 if (Ext.getCmp('custcomboId').getValue() == "" || Ext.getCmp('custcomboId').getValue() == "0") {
                   	sb.setStatus({
                 	text: 'Please Select Customer Name',
                 	iconCls: '',
                 	clear: true
           			});
          				return;
      			 		}
			 		}  
                }
             }
          }
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'setLoc2'
        },{},{},{},{},
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'toPlaceid1'
        }, {
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'toPlacelabelid'
        }, parent.Destination, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'toPlaceid2'
        },{},{},{},{},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'validFromid1'
        }, {
            xtype: 'label',
            text: '<%=Valid_From%>' + ' :',
            cls: 'labelstyle',
            id: 'validFromlabelid'
        },{
			  xtype: 'datefield',
			  cls: 'selectstylePerfect',							 
              format: getDateFormat(), //getDateTimeFormat(),
			  allowBlank: false,
			  readOnly: true,
			  emptyText: '',
			 // value:dtcur,
			 minValue:dtcur,
			 //maxValue:dtnext,
			  id: 'validfromId',
			  listeners: {
					select: function() {
						
								var fromDate=new Date();
								var Today=new Date();
								fromDate=new Date(fromDate);
								if(Today>fromDate)
								{
									Ext.example.msg("VALID FROM date Should be greater then the present time");
									grid.store.reload();
									return;
								}
		                   
		              }  
		        }
		  }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'validFromid2'
        },startTime,{},{},{},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'validToid1'
        }, {
            xtype: 'label',
            text: '<%=Valid_To%>' + ' :',
            cls: 'labelstyle',
            id: 'validTolabelid'
        },parent.validToTime,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'validToid2'
        },parent.endTime,{},{},{}, // endTime 
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'distanceid1'
        },{
            xtype: 'label',
            text: '<%=Distance%>' + ' :',
            cls: 'labelstyle',
            id: 'distancelableId'
        },parent.distancecombo,{
            xtype: 'label',
            text: 'km',
            cls: 'labelstyle',
            id: 'distanceid2'
        }
		
]
    }]
});
Date.prototype.withoutTime = function () {
    var d = new Date(this);
    d.setHours(0, 0, 0, 0);
    return d;
}
var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 850,
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
                   if (Ext.getCmp('custcomboId').getValue() == "") {
                        Ext.example.msg("Select Client Name");
                        return;
                    }
                    
                   if (Ext.getCmp('FromSandPortStoreId').getValue() == "") {
                        Ext.example.msg("<%=Select_Sand_Port%>");
                        return;
                    }
                    else {fromPlaceAdd = Ext.getCmp('FromSandPortStoreId').getValue();}
                    
                   if (Ext.getCmp('PermitComboNewId').getValue() == "") {
                        Ext.example.msg("<%=select_vehicle_No%>");
                        return;
                    }
                    
                    
                    if (Ext.getCmp('tripsheetNOId').getValue() == "") {
                        Ext.example.msg("Enter ILMS Trip Sheet No.");
                        return;
                    }
                   
                    if (parent.Ext.getCmp('ToPlaceId').getValue() == "") {
                        Ext.example.msg("<%=Select_To_Place%>");
                       return;
                    }
                    if (Ext.getCmp('validfromId').getValue() == "") {
                        Ext.example.msg("select Valid From");
                        return;
                    }
                    if(( dateCompare(previousDate,Ext.getCmp('validfromId').getValue()) == -1) ){
                        Ext.example.msg("Valid from cannot be less than current date/time");
                        return;
                    }
                    
                    
                    if (parent.Ext.getCmp('validToId').getValue() == "") {
                        Ext.example.msg("select Valid To");
                        return;
                    }
                    //click count code for Capture Weight
                   /* if (clickCount == 0) {
                        Ext.example.msg("Click on Capture Weight Button");
                        clickCount =0;
                        return;
                    }else{
                    clickCount =0;
                    }*/
                    
                   var validToDate = new Date(parent.Ext.getCmp('validToId').getValue());
               /*    if(<%=systemId%>==296){
                   	/*	
                    if (validToDate.getHours()>17 || (validToDate.withoutTime()>date.withoutTime())) {
                        Ext.example.msg("Cannot generate MDP after 6PM");
                        return;
                    }
                   }  */
                  
               /*      if (dateCompare(Ext.getCmp('validfromId').getValue(), parent.Ext.getCmp('validToId').getValue()) == -1) {
                             Ext.example.msg("Valid To Should Be Greater than Valid From Date");
                             Ext.getCmp('enddate').focus();
                             return;
                     } */
                    // var hr=parent.Ext.getCmp('validToId').getValue().getTime() - Ext.getCmp('validfromId').getValue().getTime();
                    // if ((hr/(1000 * 60 * 60)) > 24) {
                    //         Ext.example.msg("Valid To Timeduration Should not be Greater than 24 Hrs.");
                    //         Ext.getCmp('enddate').focus();
                    //         return;
                    // }
                    
                    
                    if (Ext.getCmp('mdpNoId').getValue()== undefined) {
                        Ext.example.msg("Invalid MDP No");
                        return;
                    } 
                    
                   
                    
                  <%--   if (buttonValue == "<%=Modify%>") {
                        var selected = grid.getSelectionModel().getSelected();
                        districtModify = selected.get('DistrictDataIndex');
                        uniqueIdModify = selected.get('UniqueIdDataIndex');
                        validityPeriodModify = selected.get('ValidityPeriodDataIndex');
                        transporterModify = selected.get('TransporterDataIndex');
                        MlNoModify = selected.get('MlnoDataIndex');
                        processingFeeModify = selected.get('ProcessingFeeDataIndex');
                        vehicleAddrModify = selected.get('VehicleAddrDataIndex');
                        printedModify = selected.get('PrintedIndex');
                        TSDateModify = selected.get('TSDateDataIndex');
                        DDNoModify = selected.get('DDNumberDataIndex');
                        bankNameModify = selected.get('BankNameIndex');
                        DDDateModify = selected.get('DDDateDataIndex');
                        groupIdModify = selected.get('GroupIdDataIndex');
                        groupNameModify = selected.get('GroupNameIndex');
                        indexNoModify = selected.get('IndexNoIndex');
                        mineralTypeModify = selected.get('MiningTypeDataIndex');
                        vehicleNoModify = selected.get('VehicleNoDataIndex');
                        SandLoadingFromTimeModify = selected.get('SandLoadingFromTimeIndex');
                        SandLoadingToTimeModify = selected.get('SandLoadingToTimeIndex');
                        quantityModify = selected.get('QuantityDataIndex');
                        sandportUniqueidModify = selected.get('SandPortUniqueIdIndex');
                        extractionTypeModify= selected.get('extractionindx');
                        
                    } --%>
                   
                    var dt = new Date(Ext.getCmp('validfromId').getValue());
                    var month = dt.getMonth()+1;
                    month = month.toString();
                    if(month.length == 1){
                    	month = '0'+month;
                    }
                    var day = dt.getDate();
                    
                    day = day.toString();
                    if(day.length == 1) {//if(day.length < 2) {
                    	day = '0'+day;
                    }
                    var dt1 = dt.getFullYear() + '-' + (month) + '-' + day + ' ' + Ext.getCmp('startComboId').getValue() +':'+Ext.getCmp('minComboId').getValue()+':00';

                    var dt2 = new Date(parent.Ext.getCmp('validToId').getValue());
                    var validToHour = parent.Ext.getCmp('validToHHComboId').getValue();
                    var validToMin = parent.Ext.getCmp('validToMMComboId').getValue();
                    
                    var validToMonth = dt2.getMonth()+1;
                    validToMonth = validToMonth.toString();
                    if(validToMonth.length == 1){
                    	validToMonth = '0'+validToMonth;
                    }
                    
                    var validToDay = dt.getDate();
                    validToDay = validToDay.toString();
                    if(validToDay.length == 1) {
                    	validToDay = '0'+validToDay;
                    }
                    
                     var dt3 = dt2.getFullYear() + '-' + validToMonth + '-' + dt2.getDate() + ' ' + validToHour +':'+validToMin+':00';
                     if (dateCompare(dt1, dt3) == -1) {
                             Ext.example.msg("Valid To Should Be Greater than Valid From Date ");
                             Ext.getCmp('validfromId').focus();
                             return;
                     }
                    
                     if(<%=systemId%>==296){
                   		 if (validToHour >17 || (dt2.withoutTime()>date.withoutTime())) {
                        		Ext.example.msg("Cannot generate MDP after 6PM");
                        		return;
                    	 }
                     }
                       
                 
                    sandInwardPermitOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/ILMS_MDP_GenetationAction.do?param=saveGRID',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            custId: Ext.getCmp('custcomboId').getValue(),
                            vehicleNoAdd : Ext.getCmp('PermitComboNewId').getValue(),
                            permitNoAdd : Ext.getCmp('tripsheetNOId').getValue(),
                            mdpNoAdd : Ext.getCmp('mdpNoId').getValue(),
	                        fromPlaceAdd : fromPlaceAdd,
	                        toPlaceAdd : parent.Ext.getCmp('ToPlaceId').getValue(),
	                        validFromAdd :dt1, //Ext.getCmp('validfromId').getValue(),
	                        validToAdd : dt3,//parent.Ext.getCmp('validToId').getValue(),
	                        distanceAdd : parent.Ext.getCmp('distanceHoursId').getValue(),
	                        processingFeeAdd : '0.000', 
	                        printedAdd : 'N',
	                        TSDateAdd : todaysDate,
	                        groupIdAdd : groupId,
	                        groupNameAdd : groupName,
	                        uniqueID:uniqueID,
	                        contactNoAdd : Ext.getCmp('contactNoId').getValue(),
	                        customerNameOrAddressAdd : Ext.getCmp('custAddressId').getValue(),
	                        unloadWeight: Ext.getCmp('unloadWeightTextId').getValue(),
                        	loadWeight: Ext.getCmp('loadingWeightTextId').getValue(),
                        	destLat: parent.destLat,
                        	destLng: parent.destLng,
                        	netWeight : Ext.getCmp('netWeightTextId').getValue(),
	                        //sandExtraction:Ext.getCmp('loaingtypeLoccomboid').getValue(),
	                        // loadingTypeAdd : Ext.getCmp('LoadingTypestoreId').getValue(),
	                        // sandPortNoAdd : Ext.getCmp('sandPortNumberId').getValue(),
	                        // sandPortUniqueIdAdd : Ext.getCmp('sandPortUniqueNoId').getValue(),
	                        // customerNameAdd : Ext.getCmp('customerNameId').getValue(),
	                        // validityPeriodAdd : '1 Day',
	                        // fromstockyard : Ext.getCmp('fromstockyardcomboid').getRawValue(),
	                        // fromstockyardId : Ext.getCmp('fromstockyardcomboid').getValue(),
	                        
                            
                        }, 
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            Ext.getCmp('mdpNoId').reset();
							Ext.getCmp('PermitComboNewId').reset();
							Ext.getCmp('FromSandPortStoreId').reset();
							Ext.getCmp('validfromId').reset();
							parent.Ext.getCmp('distanceHoursId').reset();
							parent.Ext.getCmp('validToId').reset();
							Ext.getCmp('tripsheetNOId').reset();
							Ext.getCmp('setLocationId').disable();
							Ext.getCmp('contactNoId').reset();
							Ext.getCmp('custAddressId').reset();
							parent.Ext.getCmp('ToPlaceId').reset(),
							Ext.getCmp('unloadWeightTextId').reset(),
							Ext.getCmp('loadingWeightTextId').reset(),
							Ext.getCmp('netWeightTextId').reset(),
							Ext.getCmp('startComboId').reset();
							Ext.getCmp('minComboId').reset();
							parent.Ext.getCmp('validToHHComboId').reset();
				   		    parent.Ext.getCmp('validToMMComboId').reset();
                            myWin.hide();
                            sandInwardPermitOuterPanelWindow.getEl().unmask();
                             store.load({
                                params: {
                                    ClientId: Ext.getCmp('custcomboId').getValue(),
                                    jspname:jspname,
                                    custname:custname
                                 }
                            });
                        //    PermitStoreNew.load({params:{clientId:custId}});
		        			FromSandPortStore.load({params:{clientId:custId}});
		        		//	ToPlaceStore.load({params:{clientId:custId}});
		      			//	vehicleNoStore.load({params:{clientId: custId}});
		      			//	ApplicationNoStore.load({params:{clientId:custId}});
		      			//	fromStockyardStore.load({params:{clientId:custId}});
		      			Ext.getCmp('setLocationId').disable();
                         
                        },
                        failure: function() {
                            Ext.example.msg("Error");
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
					Ext.getCmp('mdpNoId').reset();
					Ext.getCmp('PermitComboNewId').reset();
					Ext.getCmp('FromSandPortStoreId').reset();
					Ext.getCmp('validfromId').reset();
					parent.Ext.getCmp('distanceHoursId').reset();
					parent.Ext.getCmp('validToId').reset();
					Ext.getCmp('tripsheetNOId').reset();
					Ext.getCmp('setLocationId').disable();
					Ext.getCmp('contactNoId').reset();
					Ext.getCmp('custAddressId').reset();
					parent.Ext.getCmp('ToPlaceId').reset();
					Ext.getCmp('unloadWeightTextId').reset();
				    Ext.getCmp('loadingWeightTextId').reset();
				    Ext.getCmp('netWeightTextId').reset();
				    Ext.getCmp('weighScaleMeasureId').setValue(true);
				    //Ext.getCmp('startComboId').reset();
					//Ext.getCmp('minComboId').reset();
				    parent.Ext.getCmp('validToHHComboId').reset();
				    parent.Ext.getCmp('validToMMComboId').reset();
                    myWin.hide();
                }
            }
        }
    }]
});

var sandInwardPermitOuterPanelWindow = new Ext.Panel({
    width: 860,
    height: 450,
    standardSubmit: true,
    frame: false,
    items: [innerPanelForMDPGenerator, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 500,
    width: 860,
    id: 'myWin',
    items: [sandInwardPermitOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("select Client Name");
        return;
    }
    var d1=new Date();
    if(<%=systemId%>==204 && d1.getDay()==0)
	{
	Ext.example.msg("Cannot Generate MDP on Sundays");
    return;
	}
    MDPTripSheetTimingsStore.load({
         params: {
                 clientId: Ext.getCmp('custcomboId').getValue()
             },
  		 callback: function (records, options, success) {
         var rec = MDPTripSheetTimingsStore.getAt(0);
         if(rec.data['messageId'] != "Success"){
         Ext.example.msg("Cannot Generate MDP In This Duration");
         return;
   	}
   	else {
    titelForInnerPanel = 'Add Information';
    myWin.setPosition(230, 30);
    buttonValue = '<%=Add%>';
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    var d = new Date();
    hour=d.getHours();
    minute=d.getMinutes();
    seconds=d.getSeconds();
	d.setDate(d.getDate());
	d.setHours(hour);
	d.setMinutes(minute);
	d.setSeconds(seconds);
    Ext.getCmp('validfromId').setValue(d);
   }
    }
  });
}



var reader = new Ext.data.JsonReader({
    idProperty: 'mdpGeneratorid',
    root: 'newGridRoot',
    totalProperty: 'total',
    fields: [
    		{name:'SLNODataIndex'},
    		{name:'UniqueIdDataIndex'},
    		{name:'applicationNODataIndex'},
			{name:'TripSheetNODataIndex'},
			{name:'PermitNoDataIndex'},
			{name:'ValidityPeriodDataIndex'},
			{name:'PermitHolderDataIndex'},
			{name:'CustomerNameDataIndex'},
			{name:'TransporterDataIndex'},
			{name:'MlnoDataIndex'},
			{name:'MiningTypeDataIndex'},
			{name:'LoadingTypeDataIndex'},
			{name:'SurveyNoDataIndex'},
			{name:'VillageDataIndex'},
			{name:'TalukDataIndex'},
			{name:'DistrictDataIndex'},
			{name:'QuantityDataIndex'},
			{name:'RoyalityDataIndex'},
			{name:'ProcessingFeeDataIndex'},
			{name:'TotalFeeDataIndex'},
			{name:'VehicleNoDataIndex'},
			{name:'VehicleAddrDataIndex'},
			{name:'FromPlaceDataIndex'},
			{name:'ViaRouteDataIndex'},
			{name:'ToPlaceIndex'},
			{name:'SandPortNoIndex'},
			{name:'SandPortUniqueIdIndex'},
			{name:'DateOfEntryDataIndex', type:'date'},
			{name:'DateOfEntryDataIndex1', type:'date'},
			{name:'PrintedIndex'},
			{name:'TSDateDataIndex', type:'date'},
			{name:'DDNumberDataIndex'},
			{name:'BankNameIndex'},
			{name:'DDDateDataIndex'},
			{name:'GroupIdDataIndex'},
			{name:'GroupNameIndex'},
			{name:'IndexNoIndex'},
			{name:'DriverIndex'},
			{name:'SandLoadingFromTimeIndex'},
			{name:'SandLoadingToTimeIndex'},
			{name:'extractionindx'},
			{name:'distanceindex'}
	        ] // END OF Fields
}); // End of Reader

 var store  = new Ext.data.GroupingStore({
     url:'<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getTSDetailsGRID',
     bufferSize: 367,
     reader: reader,
     autoLoad: true,
     remoteSort:true
   });

var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters:[
        {dataIndex:'SLNODataIndex', type:'numeric'},
        {dataIndex:'UniqueIdDataIndex', type:'numeric'},
        {dataIndex:'applicationNODataIndex', type:'string'},
		{dataIndex:'TripSheetNODataIndex', type:'string'},
		{dataIndex:'PermitNoDataIndex', type:'string'},
		{dataIndex:'ValidityPeriodDataIndex', type:'string'},
		{dataIndex:'PermitHolderDataIndex', type:'string'},
		{dataIndex:'CustomerNameDataIndex', type:'string'},
		{dataIndex:'DriverIndex', type:'string'},
		{dataIndex:'TransporterDataIndex', type:'string'},
		{dataIndex:'MlnoDataIndex', type:'string'},
		{dataIndex:'VehicleNoDataIndex', type:'string'},
		{dataIndex:'VehicleAddrDataIndex', type:'string'},
		{dataIndex:'DistrictDataIndex', type:'string'},
		{dataIndex:'QuantityDataIndex', type:'string'},
		{dataIndex:'FromPlaceDataIndex', type:'string'},
		{dataIndex:'ViaRouteDataIndex', type:'string'},
		{dataIndex:'ToPlaceIndex', type:'string'},
		{dataIndex:'SandPortNoIndex', type:'string'},
		{dataIndex:'SandPortUniqueIdIndex', type:'string'},
		{dataIndex:'DateOfEntryDataIndex', type:'date'},
		{dataIndex:'DateOfEntryDataIndex1', type:'date'},
		{dataIndex:'MiningTypeDataIndex', type:'string'},
		{dataIndex:'LoadingTypeDataIndex', type:'string'},
		{dataIndex:'SurveyNoDataIndex', type:'string'},
		{dataIndex:'VillageDataIndex', type:'string'},
		{dataIndex:'TalukDataIndex', type:'string'},
		{dataIndex:'RoyalityDataIndex', type:'numeric'},
		{dataIndex:'ProcessingFeeDataIndex', type:'numeric'},
		{dataIndex:'TotalFeeDataIndex', type:'numeric'},
		{dataIndex:'PrintedIndex', type:'string'},
		{dataIndex:'TSDateDataIndex', type:'date'},
		{dataIndex:'DDNumberDataIndex', type:'string'},
		{dataIndex:'BankNameIndex', type:'string'},
		{dataIndex:'DDDateDataIndex', type:'date'},
		{dataIndex:'GroupIdDataIndex', type:'string'},
		{dataIndex:'GroupNameIndex', type:'string'},
		{dataIndex:'IndexNoIndex', type:'string'},
		{dataIndex:'SandLoadingFromTimeIndex', type:'string'},
		{dataIndex:'SandLoadingToTimeIndex', type:'string'},
		{dataIndex:'extractionindx', type:'string'},
		{dataIndex:'distanceindex', type:'numeric'}
		]
});

var createColModel =function(finish, start) {
    var columns = 
     [new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            dataIndex: 'SLNODataIndex',
            hidden:true,
        	//sortable: true,
        	//hideable: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },{
            dataIndex: 'UniqueIdDataIndex',
            hidden:true,
            //sortable: true,
           // hideable: true,
            width: 150,
            header: "<span style=font-weight:bold;><%=UniqueId_No%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Consumer_Application_No%></span>",
            dataIndex: 'applicationNODataIndex',
            hidden: true,
        	sortable: true,
        	hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        },{
            dataIndex: 'TripSheetNODataIndex',
            hidden: false,
        	//sortable: true,
        	//hideable: true,
        	width: 150,
            header: "<span style=font-weight:bold;><%=MDP_No%></span>",
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>ILMS Trip Sheet No.</span>",
            dataIndex: 'PermitNoDataIndex',
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Validity_Period%></span>",
            dataIndex: 'ValidityPeriodDataIndex',
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Transporter_Name%></span>",
            dataIndex: 'PermitHolderDataIndex',
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Customer_Name%></span>",
            dataIndex: 'CustomerNameDataIndex',
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Driver_Name%></span>",
            dataIndex: 'DriverIndex',
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Transporter%></span>",
            dataIndex: 'TransporterDataIndex',
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ML_No%></span>",
            dataIndex: 'MlnoDataIndex',
           	hidden: true,
        	//sortable: true,
        	//hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Vehicle_No%></span>",
            dataIndex: 'VehicleNoDataIndex',
            width: 150,
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Customer_Address%></span>",
            dataIndex: 'VehicleAddrDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=District%></span>",
            dataIndex: 'DistrictDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Quantity%>(CBM)</span>",
            dataIndex: 'QuantityDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=From_Sand_Port%></span>",
            dataIndex: 'FromPlaceDataIndex',
            width: 150,
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Via_Route%></span>",
            dataIndex: 'ViaRouteDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=To_Place%></span>",
            dataIndex: 'ToPlaceIndex',
            width: 150,
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Sand_Port_No%></span>",
            dataIndex: 'SandPortNoIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Sand_Port_Unique_No%></span>",
            dataIndex: 'SandPortUniqueIdIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Valid_From%></span>",
            dataIndex: 'DateOfEntryDataIndex',
            width: 150,
            renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Valid_To%></span>",
            dataIndex: 'DateOfEntryDataIndex1',
            width: 150,
            renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            hidden: false,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Mineral_Type%></span>",
            dataIndex: 'MiningTypeDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Loading_Type%></span>",
            dataIndex: 'LoadingTypeDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Survey_No%></span>",
            dataIndex: 'SurveyNoDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Village%></span>",
            dataIndex: 'VillageDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Taluka%></span>",
            dataIndex: 'TalukDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Amount_CubicMeter%>(Rs)</span>",
            dataIndex: 'RoyalityDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Processing_Fees%>(Rs)</span>",
            dataIndex: 'ProcessingFeeDataIndex',
            width: 150,
            hidden: true,
        	//sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Total_Fee%>(Rs)</span>",
            dataIndex: 'TotalFeeDataIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=Printed%></span>",
            dataIndex: 'PrintedIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=MDP_Date%></span>",
            dataIndex: 'TSDateDataIndex',
            renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            width: 150,
            hidden: false,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=DD_No%></span>",
            dataIndex: 'DDNumberDataIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Bank_Name%></span>",
            dataIndex: 'BankNameIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=DD_Date%></span>",
            dataIndex: 'DDDateDataIndex',
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            width: 150,
            hidden: true,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Group_Id%></span>",
            dataIndex: 'GroupIdDataIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Group_Name%></span>",
            dataIndex: 'GroupNameIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Index_No%></span>",
            dataIndex: 'IndexNoIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Sand_Loading_From_Time%></span>",
            dataIndex: 'SandLoadingFromTimeIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Sand_Loading_To_Time%></span>",
            dataIndex: 'SandLoadingToTimeIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Extraction Type</span>",
            dataIndex: 'extractionindx',
            width: 150,
            hidden: true,
        	sortable: true,
        	//hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Distance%></span>",
            dataIndex: 'distanceindex',
            width: 150,
            hidden: false,
        	sortable: true,
        	//hideable: true,
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
         if(selection.getCount()>1)
         {
         	Ext.example.msg("Select Single Row");
			return;
         }
         			                var uids="";
									var ts="";
									var total=0;
					 for(i=0;i < grid.store.getCount();i++){ 
										 
										 if(selection.isSelected(i)){
										    var uid = grid.store.getAt(i).data.UniqueIdDataIndex;
										    var ts1= grid.store.getAt(i).data.PermitNoDataIndex; 
									        uids=uids+","+uid;
									        ts=ts+","+ts1;
									       } 
										 }
										
							if(uids=="")
							{
							Ext.example.msg("No records selected to print...");
							return;
							}
		Ext.Ajax.request({
         url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getPDFFileType',
             method: 'POST',
              params: {
                       systemId:<%=systemId%>
                     },
                	success:function(response, options)
                   {
                   	if(response.responseText=="D")  // It refers to Type="D"
             		{
             			window.open("<%=request.getContextPath()%>/Sand_Mining_ILMS_MDP?uids="+uids+"&ts="+ts+"&systemId="+<%=systemId%>+"");										 
             		}
             	   }, // end of success
            		failure: function(response, options)
                    {
                      Ext.example.msg("ERROR WHILE PROCESSING")
                    }// end of failure
                  }); 

    loadGrid1();  
}
function load(){
	
grid.store.reload();
	    }
function loadGrid1(){
	
 		setTimeout('load()',2000);
 		
	    }

//*****************************************************************Grid *******************************************************************************
grid = getSandPermitGrid('ILMS MDP Integration', '<%=No_Records_Found%>', store, screen.width - 32, 420, 45, filters, '<%=Clear_Filter_Data%>', false, '',20, false, '', false, '', false, '<%=Excel%>', jspname, exportDataType, false, '<%=PDF%>', true, '<%=Add%>', false, '<%=Modify%>', true, 'Print MDP');
//******************************************************************************************************************************************************

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'ILMS MDP Integration',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [customerComboPanel,grid]
    });
    sb = Ext.getCmp('form-statusbar');
    if(<%=customerId%> > 0)
    {
    Ext.getCmp('clientlabelid').hide();
    Ext.getCmp('custcomboId').hide();
    Ext.getCmp('setLocationId').disable();
    }
    if(<%=systemId%>==296){
    //parent.Ext.getCmp('validToId').readOnly = true;
    	parent.Ext.getCmp('validToId').disable();
    	parent.Ext.getCmp('validToHHComboId').disable();
    	parent.Ext.getCmp('validToMMComboId').disable();
    }
    parent.Ext.getCmp('validToId').readOnly = true;
    var cm = grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,150);
    }
});

</script>
</body>
</html>
