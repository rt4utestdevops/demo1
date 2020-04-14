<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	Properties properties = ApplicationListener.prop;
	String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
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
	
	SandMiningFunctions smf = new SandMiningFunctions();
	boolean ConsumerMDPstate;
	boolean isModelCKM;
	boolean Quantity_Measure;
	ConsumerMDPstate = smf.status(systemId);
	isModelCKM = smf.isChikkmagalurModel(systemId);
	Quantity_Measure = smf.Quantity_Measure(systemId);
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
%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Consumer MDP Generator</title>	
 		<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyBSHs2852hTpOnebBOn48LObrqlRdEkpBs&region=IN"></script>  
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
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
var outerPanel;
var ctsb;
var jspname = "Consumer_MDP_Generator";
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
var ApplicationRec;
myDate.setHours(myDate.getHours() + 24);
var nxtdate=nextDate;
nxtdate.setHours(23);
nxtdate.setMinutes(59);
nxtdate.setSeconds(59);
var previousDate = new Date().add(Date.DAY, -1);
previousDate.setHours(23);
previousDate.setMinutes(59);
previousDate.setSeconds(59);

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
		        PermitStoreNew.load({params:{clientId:custId}});
		        FromSandPortStore.load({params:{clientId:custId}});
		        ToPlaceStore.load({params:{clientId:custId}});
                ApplicationNoStore.load({params:{clientId:custId}});
                fromStockyardStore.load({params:{clientId:custId}});
               // MDPLimitStore.load({params:{clientId:custId}});
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
		        PermitStoreNew.load({params:{clientId:custId}});
		        FromSandPortStore.load({params:{clientId:custId}});
		        ToPlaceStore.load({params:{clientId:custId}});
		      	vehicleNoStore.load({params:{clientId: custId}});
		      	ApplicationNoStore.load({params:{clientId:custId}});
		      	fromStockyardStore.load({params:{clientId:custId}});
		      //	MDPLimitStore.load({params:{clientId:custId}});
            }
        }
    }
});

var vehicleNoStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getVehicleNoGRID',
				   id:'vehicleNoStoreId',
			       root: 'vehicleNoRoot',
			       autoLoad: true,
			       remoteSort:true,
				   fields: ['vehicleno','VehOwner','VehAddr','model']
			     });

var VehicleCombo=new Ext.form.ComboBox({
				  frame:true,
				  store: vehicleNoStore,
				  id:'vehicleId',
				  width: 175,
				  forceSelection:true,
				  emptyText:'Select Vehicle',
				  anyMatch:true,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  triggerAction: 'all',
				  displayField: 'vehicleno',
				  valueField: 'vehicleno',
				  cls: 'selectstylePerfect',
				  listeners: {
		                select: {
		                 	 fn:function(){
	                 				vehiclenumberstr=Ext.getCmp('vehicleId').getValue();
	                 		     }
		                	} // END OF SELECT
		               } // END OF LISTENERS 
	   
	       });
	       	       	 		
	var loaingtypeLocstore = new Ext.data.SimpleStore({
    id: 'loTypeId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['Sand Block', 'Sand Block'],
        ['Stockyard', 'Stockyard']
    ]
});	
		
				
var loaingtypeLoccombo=new Ext.form.ComboBox({
				  frame:true,
				  store: loaingtypeLocstore,
				  id:'loaingtypeLoccomboid',
				  width: 175,
				  forceSelection:true,
				  emptyText:'Select Sand Extraction From',
				  anyMatch:true,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  triggerAction: 'all',
				  displayField: 'Name',
				  valueField: 'Name',
				  cls: 'selectstylePerfect',
				  listeners: {
		                select: {
		                 	 fn:function(){
		                 	 
		                 	 if(Ext.getCmp('loaingtypeLoccomboid').getValue()=='Stockyard')
		                 	 {
		                 	 Ext.getCmp('FromSandPortStoreId').hide();
		                 	  Ext.getCmp('fromSandPortid1').hide();
		                 	   Ext.getCmp('fromSandPortLabelId').hide();
		                 	    Ext.getCmp('fromSandPortid2').hide();
		                 	    Ext.getCmp('fromstockyardid1').show();
		                 	    Ext.getCmp('fromstockyardid2').show();
		                 	    Ext.getCmp('fromstockyardcomboid').show();
		                 	    Ext.getCmp('fromstockyardLabelId').show();
		                 	 }
		                 	 if(Ext.getCmp('loaingtypeLoccomboid').getValue()=='Sand Block')
		                 	 {
		                 	 Ext.getCmp('fromstockyardid1').hide();
		                 	  Ext.getCmp('fromstockyardid2').hide();
		                 	   Ext.getCmp('fromstockyardcomboid').hide();
		                 	    Ext.getCmp('fromstockyardLabelId').hide();
		                 	    
		                 	    Ext.getCmp('FromSandPortStoreId').show();
		                 	   Ext.getCmp('fromSandPortid1').show();
		                 	   Ext.getCmp('fromSandPortLabelId').show();
		                 	    Ext.getCmp('fromSandPortid2').show();
		                 	 }
	                 				//vehiclenumberstr=Ext.getCmp('vehicleId').getValue();
	                 		     }
		                	} // END OF SELECT
		               } // END OF LISTENERS 
	   
	       });		
	       
	   var fromStockyardStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getStockyards',
				   id:'fromStockyardStoreId',
			       root: 'fromStockyardRoot',
			       autoLoad: true,
			       remoteSort:true,
				   fields: ['stockyardName','stockyardId','availablesand','rate','stockyardvillage','stockyardtaluka','stockyardlat','stockyardlong']
			     });    
	       
	       var FromStockyard=new Ext.form.ComboBox({
				  frame:true,
				  store: fromStockyardStore,
				  id:'fromstockyardcomboid',
				  width: 175,
				  hidden:true,
				  forceSelection:true,
				  emptyText:'Select Stockyard From',
				  anyMatch:true,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  triggerAction: 'all',
				  displayField: 'stockyardName',
				  valueField: 'stockyardId',
				  cls: 'selectstylePerfect',
				  listeners: {
		                select: {
		                 	 fn:function(){
		                 	 calculateDistance();
		                 	 if(Ext.getCmp('PermitComboNewId').getValue()=="")
		                 	 {
		                 	 Ext.example.msg("Please select Vehicle No Before selecting stockyard");
		                 	 Ext.getCmp('fromstockyardcomboid').reset();
		                 	 };
		                 	 var stockyard=Ext.getCmp('fromstockyardcomboid').getValue();
		                 	  var row = fromStockyardStore.find('stockyardId',stockyard);
							   var rec = fromStockyardStore.getAt(row);
							   var availableSand=rec.data['availablesand'];
							   var village=rec.data['stockyardvillage'];
							   var taluka=rec.data['stockyardtaluka'];
							   rate=rec.data['rate'];
							    stockyardUID=rec.data['stockyardId'];
							    Ext.getCmp('LoadingTypestoreId').setValue('Self');
							    Ext.getCmp('mineralTypeId').setValue('Ordinary Sand');
							    Ext.getCmp('surveyNoId').setValue(stockyardUID);
							    Ext.getCmp('villageId').setValue(village);
	  							Ext.getCmp('talukId').setValue(taluka);
	  							SandLoadingFromTime="06:00";
								SandLoadingToTime="18:00";
								Ext.getCmp('sandPortNumberId').setValue(stockyardUID);
	  							if(Ext.getCmp('quantityId').getValue() > availableSand)
							   {
							   Ext.example.msg("Quantiry Available at Stockyard is less than entered quantity");
							   Ext.getCmp('fromstockyardcomboid').reset();
							   };
							   Ext.getCmp('sandPortUniqueNoId').setValue(stockyardUID);
							    Ext.getCmp('amountId').setValue(rate);
							    var acm=0;
							    acm=Ext.getCmp('quantityId').getValue();
							    total=parseFloat(rate)*parseFloat(acm);
							    Ext.getCmp('totalFeesId').setValue(total);
							    var port="";
							    FromSandPortDetailsStore.load({params:{clientId:custId,portname:port,applicationNo:Ext.getCmp('ApplicationStoreId').getValue()},
		                 	    callback: function (records, options, success) {
		                 	     var rec=FromSandPortDetailsStore.getAt(0); 								
		                 	     DD_NoNew=rec.data['DD_NoNew'];
								 DD_Date=rec.data['DD_Date'];
								 Bank_Name=rec.data['Bank_Name'];
								//DD_Date = Date.parseDate(DD_Date, 'd/m/Y');
								 uniqueID=rec.data['uniqueId'];
		
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
		   					
		                 	   
		 Ext.Ajax.request({
         url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getAmtGRID',
             method: 'POST',
             params: {
                       uniqueID:uniqueID,
                       clientId:custId,
                       applicationNo:Ext.getCmp('ApplicationStoreId').getValue()
                     },
            success:function(response, options)
            {
               if(response.responseText=="Error")
               {
	            grid.store.reload();
	            Ext.example.msg("Low on Balance Please  Deposit...!");
                return;
               }
            }, // end of success
        	failure: function(response, options)
             {
                grid.store.reload();
                 Ext.example.msg("Error while Processing....!");
                return;
             }// end of failure
        });
		                 	   
		                 	   }});
		                 	 }
		                	} // END OF SELECT
		               } // END OF LISTENERS 
	   
	       });								

	var PermitStoreNew= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getPermitsNewGRID',
				   id:'PermitStoreNewId',
			       root: 'PermitstoreNewList',
			       autoLoad: false,
			       remoteSort:true,
				   fields: ['PermitNoNew','OwnerNameNew','Owner_TypeNew','PortNew','LoadCapacityNew','Group_Name','Group_Id']
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
		                 	 permitNo=Ext.getCmp('PermitComboNewId').getValue();
							 var row = PermitStoreNew.find('PermitNoNew',permitNo);
							 var rec = PermitStoreNew.getAt(row);
							 LoadCapacityNew=rec.data['LoadCapacityNew'];
							 groupId=rec.data['Group_Id'];
							 groupName=rec.data['Group_Name'];	 
							 messageQuant="";
			   				
							Ext.getCmp('quantityId').setValue(LoadCapacityNew);
							var applicationNo = Ext.getCmp('ApplicationStoreId').getValue();
						Ext.Ajax.request({
						          url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=updateQuantity',
						          method: 'POST',
						          params: {
						          permitNo:permitNo,
			                       qty:Ext.getCmp('quantityId').getValue(),
			                       clientId:custId,
			                       applicationNo : applicationNo
				             },
				             success:function(response, options)
		                    {
		                    messageQuant=response.responseText;
		                    if(messageQuant=="ERROR")
	                       {
		                    Ext.example.msg("Approved Quantity is less than entered quantity");
		                    return;
	                       }else if(messageQuant=="Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP"){
	                        Ext.example.msg("Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP");
	                        Ext.getCmp('PermitComboNewId').reset();
		                    return;
	                       }
		                    }, // end of success
		            	   failure: function(response, options)
		                   {
		                     messageQuant="";
		                   }//
	           });
							var tidType=rec.data['Owner_TypeNew'];
<!--							if(tidType=="Transporter")-->
<!--							{-->
<!--							TSGrid.getColumnModel().config[14].editable=true;-->
<!--							TSGrid.getColumnModel().config[15].editable=true;-->
<!--							TSGrid.getColumnModel().config[16].editable=true;-->
<!--							}-->
<!--							else-->
<!--							{-->
<!--							TSGrid.getColumnModel().config[14].editable=false;-->
<!--							TSGrid.getColumnModel().config[15].editable=false;-->
<!--							TSGrid.getColumnModel().config[16].editable=false;-->
<!--							}-->
							
	 // end of Ajax	
<!--if(<%=systemId%>==134 || <%=systemId%>==133 || <%=systemId%>==210){-->
<!--    //================================to check only one TS per Vehicle for a day for shimoga-->
<!--    		Ext.Ajax.request({-->
<!--         url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getVehicleTScount',-->
<!--             method: 'POST',-->
<!--             params: {-->
<!--                       vehno:permitNo,-->
<!--                       systemId:<%=systemId%>,-->
<!--                       clientId:custId-->
<!--                     },-->
<!--                	success:function(response, options)-->
<!--	                 {-->
<!--	                   if(response.responseText=="Error")-->
<!--	                   {-->
<!--						grid.store.reload();-->
<!--						Ext.example.msg("Cannot generate 2 MDPs for this vehicle in the same day...!");-->
<!--	                    return;-->
<!--	                   }-->
<!--	                   if(response.responseText=="Error1")-->
<!--	                   {-->
<!--						grid.store.reload();-->
<!--	                    Ext.example.msg("Cannot generate more then 3 MDPs for this vehicle in the same day...!");-->
<!--	                    return;-->
<!--	                   }-->
<!--	                 }, // end of success-->
<!--            		failure: function(response, options)-->
<!--                     {-->
<!--                       grid.store.reload();-->
<!--                       Ext.example.msg("Error while Processing....!");-->
<!--                       return;-->
<!--                     }// end of failure-->
<!--                        }); // end of Ajax	                      -->
<!--			}				-->
                     var oType=rec.data['Owner_TypeNew'];
                     Ext.getCmp('transporterNameId').setValue(rec.data['OwnerNameNew']);
                     transporter = rec.data['OwnerNameNew'];
                     vehicleNo = permitNo;
                     customerAddress = rec.data['PortNew'];
                                    
                     if(oType=="LeaseOwner")
                      {
                        var type=oType;
                      } else {
                        var type=rec.data['OwnerNameNew'];
                      }
                   vehicleNoStore.load({
	                     params:{clientId: custId,type:type}
                   });   //---------not using------

}
}
}
		                 	 
	       });
	       


 var days = [['1 Day'],['2 Days'],['3 Days'],['4 Days'],['5 Days'],['6 Days'],['7 Days'],['8 Days'],['9 Days'],['10 Days'],['11 Days'],['12 Days'],['13 Days'],['14 Days'],['15 Days'],['16 Days'],['17 Days'],['18 Days'],['19 Days'],['20 Days'],['21 Days'],['22 Days'],['23 Days'],['24 Days'],['25 Days'],['26 Days'],['27 Days'],['28 Days'],['29 Days'],['30 Days']];   
	          var daystore= new  Ext.data.SimpleStore({
			       data:days,
				   fields: ['dayid']
			     });
			      	      
 var Days = new Ext.form.ComboBox({
     			frame:true,
				  store: daystore,
				  id:'daystoreId',
				  width: 175,
				  forceSelection:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  hidden:true,
				  anyMatch:true,
	              onTypeAhead:true,
				  triggerAction: 'all',
				  displayField: 'dayid',
				  valueField: 'dayid', 
	        	  emptyText:'Select day',
	        	  cls: 'selectstylePerfect',
	        	   listeners: {
		                   select: {
		                 	   fn:function(){
		                 			
									// viewall();
                 			  } 
		                 } 
		               } 	
			});
			
			
			 var LoadingType = [['Machine'],['Self']];   
	          var LoadingTypestore= new  Ext.data.SimpleStore({
			       data:LoadingType,
				   fields: ['LoadingTypeid']
			     });
			      	      
 var LoadingTypeCombo = new Ext.form.ComboBox({
     			frame:true,
				  store: LoadingTypestore,
				  id:'LoadingTypestoreId',
				  width: 175,
				  forceSelection:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  hidden:false,
				  anyMatch:true,
	              onTypeAhead:true,
				  triggerAction: 'all',
				  displayField: 'LoadingTypeid',
				  valueField: 'LoadingTypeid', 
	        	  emptyText:'Select Loading Type',
	        	  cls: 'selectstylePerfect',
	        	   listeners: {
		                   select: {
		                 	   fn:function(){
										var loadType=Ext.getCmp('LoadingTypestoreId').getValue();
										var fromPort=Ext.getCmp('FromSandPortStoreId').getValue();
										
		Ext.Ajax.request({
         url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=checkTSCOuntFORPORT',
             method: 'POST',
             params: {
                       loadType:loadType,
                       clientId:custId,
                       fromPort:fromPort,
                       groupId:groupId,
                       groupName:groupName
                     },
                success:function(response, options)
                {
                   var rep=response.responseText;
                   if(rep=="Error")
                   {
	                   Ext.example.msg("Max number of MDPs reached for this sand port and loading type combination...!");
	                   grid.store.reload();
	                   return;
                   }
                 }, // end of success
           		failure: function(response, options)
                 {
                     grid.store.reload();
                     Ext.example.msg("Error while Processing....!");
                     return;
                  }// end of failure
             }); // end of Ajax	
<!--            if(<%=systemId%>==134 || <%=systemId%>==12 ) -->
<!--             {-->
<!--          		var r=0;-->
<!--          		var qty=Ext.getCmp('quantityId').getValue();-->
<!--			    if(Ext.getCmp('LoadingTypestoreId').getValue()=='Self')-->
<!--				{-->
<!--		 			r=300;-->
<!--				}-->
<!--				else-->
<!--				{-->
<!--		 			r=Ext.getCmp('amountId').getValue();-->
<!--				}-->
<!--					r=Ext.getCmp('amountId').getValue();-->
<!--					var total=parseFloat(r);-->
<!--					var permit=Ext.getCmp('PermitComboNewId').getValue();-->
<!--					var CreditBy=Ext.getCmp('transporterNameId').getValue();-->
<!--					total=parseFloat(total)*parseFloat(qty);-->
<!--					-->
<!--		Ext.Ajax.request({-->
<!--         url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=checkTotal',-->
<!--             method: 'POST',-->
<!--             params: {-->
<!--                       PERMITNO:permit,-->
<!--                       systemId:<%=systemId%>,-->
<!--                       clientId:custId,-->
<!--                       TYPE:CreditBy,-->
<!--                       total:total-->
<!--                     },-->
<!--                	success:function(response, options)-->
<!--                    {-->
<!--                     if(response.responseText=="Error")-->
<!--                     {-->
<!--						grid.store.reload();-->
<!--                   		Ext.example.msg("Total Fee is greater then balance....Please  Deposit...!");-->
<!--                   		return;-->
<!--                   	 }-->
<!--                    }, // end of success-->
<!--            		failure: function(response, options)-->
<!--                    {-->
<!--                      grid.store.reload();-->
<!--                      Ext.example.msg("Error while Processing....!");-->
<!--                      return;-->
<!--                    }// end of failure-->
<!--                 }); // end of Ajax	-->
<!--                if(Ext.getCmp('loaingtypeLoccomboid').getValue()=='Sand Block') -->
<!--                { -->
<!--            	Ext.getCmp('amountId').setValue(r);-->
<!--				Ext.getCmp('totalFeesId').setValue(total);-->
<!--				}-->
<!--             }    -->
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
			}
        
        } 
	 
	 } 

});
			
	   var FromSandPortStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getFromSandPortStore',
				   id:'FromSandPortStoreId',
			       root: 'FromSandPortStoreList',
			       autoLoad: true,
			       remoteSort:true,
				    fields: ['portNo','portName','portVillage','portTaluk','portSurveyNumber','portUniqueid','assessedQuantity','DD_NoNew','DD_Date','Bank_Name','ValidFromNew','DailyOff1','ValidToNew','DailyOff2','TSFormatNew','SelfAmountNew','MachineAmountNew','LoadTypeNew','lat','longi']
			     })
			     
	     var FromSandPortDetailsStore= new Ext.data.JsonStore({
		   url:'<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getFromSandPortDetailsStore',
		   id:'FromSandPortDetailsStoreId',
	       root: 'FromSandPortDetailsStoreList',
	       autoLoad: false,
	       remoteSort:true,
		    fields: ['DD_NoNew','DD_Date','Bank_Name','ValidFromNew','DailyOff1','ValidToNew','DailyOff2','TSFormatNew','SelfAmountNew','MachineAmountNew','LoadTypeNew','uniqueId']
	     })
			     
		var ToPlaceStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getToPlaceStore',
				   id:'ToPlaceStoreId',
			       root: 'ToPlaceStoreList',
			       autoLoad: true,
			       remoteSort:true,
				    fields: ['toPlace']
			     })			     
		var RoyalityStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getRoyalityStoreStore',
				   id:'RoyalityStoreStoreId',
			       root: 'RoyalityStoreStoreList',
			       autoLoad: true,
			       remoteSort:true,
				    fields: ['SelfAmountNew','MachineAmountNew','DefaultLoadType','TalukNew','TSNOFormat','SandLoadingFromTime','SandLoadingToTime']
			     })	  
			     
		var ApplicationNoStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getApplicationNo',
				   id:'ApplicationNoStoreId',
			       root: 'ApplicationNoStoreList',
			       autoLoad: true,
			       remoteSort:true,
				    fields: ['ApplicationNo','consumerName','consumerMobile','workAddress','latitude','longitude']//tolocation latlong
			     })	   
		var MDPLimitStore = new Ext.data.JsonStore({
		 			url:'<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getMDPLimitStore',
				   id:'MDPLimitStoreId',
			       root: 'MDPLimitStoreList',
			       autoLoad: true,
			       remoteSort:true,
				    fields: ['ConsumerType','TotalMdpLimit','TotalMdpUsed']
		})     	      
 var FromSandPort = new Ext.form.ComboBox({
     			frame:true,
				  store: FromSandPortStore,
				  id:'FromSandPortStoreId',
				  width: 175,
				  forceSelection:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  hidden:true,
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
		                 	   calculateDistance();
		                 	   var portname=Ext.getCmp('FromSandPortStoreId').getValue();
		                 	   var applicationNo = Ext.getCmp('ApplicationStoreId').getValue();
		                 	   FromSandPortDetailsStore.load({params:{clientId:custId,portname:portname,applicationNo:applicationNo},
		                 	   callback: function (records, options, success) {
		                 	     var rec=FromSandPortDetailsStore.getAt(0); 								
		                 	     DD_NoNew=rec.data['DD_NoNew'];
								 DD_Date=rec.data['DD_Date'];
								 Bank_Name=rec.data['Bank_Name'];
								// DD_Date = Date.parseDate(DD_Date, 'd/m/Y');
								 ValidFromNew=rec.data['ValidFromNew'];
								 DailyOff1=rec.data['DailyOff1'];
								 ValidToNew=rec.data['ValidToNew'];
								 DailyOff2=rec.data['DailyOff2'];
								 TSFormatNew=rec.data['TSFormatNew'];
								 LoadTypeNew=rec.data['LoadTypeNew'];
								 uniqueID=rec.data['uniqueId'];
								 
		   						 if(ValidFromNew=="PRESENT")
		   						     startdate = DailyOff1;
		   					      else
		   						     startdate = DailyOff1.substring(0,10)+" "+ValidFromNew;
		   						 	
		   						// startdate = Date.parseDate(startdate, 'd-m-Y H:i:s');
		   						
			   					var enddate ="";
			   					if(ValidToNew=="PRESENT")
			   						enddate = DailyOff2;
			   					else
			   						enddate = DailyOff2.substring(0,10)+" "+ValidToNew;
			   							
			   					//enddate  = Date.parseDate(enddate , 'd/m/Y H:i:s');
								
		                 	   
		                 	   	Ext.Ajax.request({
         url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=getAmtGRID',
             method: 'POST',
             params: {
                       uniqueID:uniqueID,
                       clientId:custId,
                       applicationNo:applicationNo
                     },
            success:function(response, options)
            {
               if(response.responseText=="Error")
               {
	            grid.store.reload();
	            Ext.example.msg("Low on Balance Please  Deposit...!");
                return;
               }
            }, // end of success
        	failure: function(response, options)
             {
                grid.store.reload();
                 Ext.example.msg("Error while Processing....!");
                return;
             }// end of failure
        });
		                 	   
		                 	   }});
		                 	   ToPlaceStore.load({params:{clientId:custId}});
							   var row = FromSandPortStore.find('portName',portname);
							   var rec = FromSandPortStore.getAt(row);
							   var portNo=rec.data['portNo'];
							   var portSurvey_No=rec.data['portSurveyNumber'];
							   var portVillageNew=rec.data['portVillage'];
							   var portTalukNew=rec.data['portTaluk'];
							   var portNoUniqueId=rec.data['portUniqueid'];
							   var assessedQuant=rec.data['assessedQuantity'];
							   Ext.getCmp('sandPortNumberId').setValue(portNo);
							   Ext.getCmp('surveyNoId').setValue(portSurvey_No);
							   Ext.getCmp('villageId').setValue(portVillageNew);
							   Ext.getCmp('talukId').setValue(portTalukNew);
							   Ext.getCmp('sandPortUniqueNoId').setValue(portNoUniqueId);
							   Ext.getCmp('mineralTypeId').setValue('Ordinary Sand');
							   if(Ext.getCmp('quantityId').getValue() > assessedQuant)
							   {
							    Ext.example.msg("Assessed Quantiry is less than entered quantity");
							    Ext.getCmp('FromSandPortStoreId').reset();
							   }
         //======================= Newly Added For Amount/Cubic Port Wise===========
                     
	                    
			                   var permitNo=Ext.getCmp('PermitComboNewId').getValue();
							   var row = PermitStoreNew.find('PermitNoNew',permitNo);
							   var rec = PermitStoreNew.getAt(row);
							   LoadCapacityNew=rec.data['LoadCapacityNew'];

		                       var TripSheetFormat;
		                       var SelfAmountNew="";
		 				       var MachineAmountNew="";
		                       RoyalityStore.load({params:{clientId:custId,portname:portname},
		                 	   callback: function (records, options, success) {                            
		 				 	   var i;
		 				 	   var DefaultLoadType;		
		 				 	   for(var i=0;i<RoyalityStore.data.length;i++)
			 				   {
			 					 var re=RoyalityStore.getAt(i); 								
			 					 SelfAmountNew=re.data['SelfAmountNew'];
			 					 MachineAmountNew=re.data['MachineAmountNew'];
			 					 DefaultLoadType=re.data['DefaultLoadType'];
			 					 TripSheetFormat=re.data['TSNOFormat'];
			 					 SandLoadingFromTime=re.data['SandLoadingFromTime'];
			 					 SandLoadingToTime=re.data['SandLoadingToTime'];
			 				   }
		 					   Ext.getCmp('LoadingTypestoreId').setValue(DefaultLoadType);
							   var tot = 0;
							   if(DefaultLoadType=="Self")
							  {
							    Ext.getCmp('amountId').setValue(SelfAmountNew );
							    tot=SelfAmountNew;
							  }
							  else
							  {
							    Ext.getCmp('amountId').setValue(MachineAmountNew);
							    tot=MachineAmountNew;
				        	  }
							  Ext.getCmp('quantityId').setValue(LoadCapacityNew);
							  var total=parseFloat(tot)*parseFloat(LoadCapacityNew);
							  Ext.getCmp('totalFeesId').setValue(total);
							 
							  ts=TripSheetFormat;
							  Ext.Ajax.request({
							  url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=maxTSGRID',
							  method: 'POST',
							  params:
							  {
							    ClientId: custId
							  },
							  success:function(response, options)
							  {
							    var tsno=response.responseText;
							    ts=ts+"-"+tsno;
							    Ext.getCmp('mdpNoId').setValue(ts);
							  }, // end of success
							  failure: function(response, options)
	                          {
	                            Ext.getCmp('mdpNoId').setValue(ts+"-");
	                          }// end of failure
	                        }); // end of Ajax	
	                      Ext.getCmp('mdpNoId').setValue(ts+"-");
	                  }               
	               });    
	                          
		           var applicationNo = Ext.getCmp('ApplicationStoreId').getValue();
			Ext.Ajax.request({
			          url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=updateQuantity',
			          method: 'POST',
			          params: {
			                       qty:Ext.getCmp('quantityId').getValue(),
			                       clientId:custId,
			                       applicationNo : applicationNo
				             },
				             success:function(response, options)
		                    {
		                    messageQuant=response.responseText;
		                    if(messageQuant=="ERROR")
	                       {
		                    Ext.example.msg("Approved Quantity is less than entered quantity");
		                    return;
	                       }else if(messageQuant=="Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP"){
	                       Ext.example.msg("Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP");
		                    return;
	                       }
		                    }, // end of success
		            	   failure: function(response, options)
		                   {
		                     messageQuant="";
		                   }//
	           });                     
				}	
              } 
		    } 
	   }); 
			
	var ApplicationNoCombo = new Ext.form.ComboBox({
     			  frame:true,
				  store: ApplicationNoStore,
				  id:'ApplicationStoreId',
				  width: 175,
				  forceSelection:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  hidden:false,
				  anyMatch:true,
	              onTypeAhead:true,
				  triggerAction: 'all',
				  displayField: 'ApplicationNo',
				  valueField: 'ApplicationNo', 
	        	  emptyText:'Select Application No',
	        	  cls: 'selectstylePerfect',
	        	  listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   if(Ext.getCmp('ApplicationStoreId').getValue()!=""){
		                 	   var application=Ext.getCmp('ApplicationStoreId').getValue();
		                 	   var row1 = ApplicationNoStore.find('ApplicationNo',application);
							   var rec1 = ApplicationNoStore.getAt(row1);
							   var consumerName=rec1.data['consumerName'];
							   var workaddress=rec1.data['workAddress'];
							   var consumerMobile=rec1.data['consumerMobile'];
							   Ext.getCmp('customerNameId').setValue(consumerName);
							   Ext.getCmp('customerMobileId').setValue(consumerMobile);
							   Ext.getCmp('ToPlaceId').setValue(workaddress);
							   latitude=rec1.data['latitude'];
							   longitude=rec1.data['longitude'];
							   destlatlong=rec1.data['latitude'] + ',' + rec1.data['longitude'];
							   
							   if(<%=ConsumerMDPstate%>){
							   FromSandPortStore.load({
							   params:{
							   clientId:custId,
							   appNo:Ext.getCmp('ApplicationStoreId').getValue()
							   }});
							   fromStockyardStore.load({
							   params:{
							   clientId:custId,
							   appNo:Ext.getCmp('ApplicationStoreId').getValue()
							   }});
							   }
							   MDPLimitStore.load({
                        		params:{
                        		clientId:custId,
                        		applicationNO : Ext.getCmp('ApplicationStoreId').getValue(),
                        		date:Ext.getCmp('validfromId').getValue()
                        		},
                        		callback: function(){
                        		
                        			ApplicationRec = MDPLimitStore.getAt(0);
                        			Ext.getCmp('limitLabelId').setText(ApplicationRec.data['TotalMdpLimit'] +" / day");
                        			Ext.getCmp('usedlabelId').setText(ApplicationRec.data['TotalMdpUsed'] +" / day");
                        			
                        			if(ApplicationRec.data['TotalMdpLimit'] != "NA" && ApplicationRec.data['TotalMdpLimit'] <= ApplicationRec.data['TotalMdpUsed'] ){
                        			Ext.example.msg("Sorry!! MDP limit has reached for this application type");
                        			Ext.getCmp('ApplicationStoreId').focus();
                        			}
                        			}
                        		});
							   }
                 			} 
		                 } 
		               } 	
			});		
			
			
			var ToPlaceCombo = new Ext.form.ComboBox({
     			  frame:true,
				  store: ToPlaceStore,
				  displayField:'toPlace',
				  readOnly: true,
				  valueField: 'toPlace',
				  mode: 'local',
				  selectOnFocus:true,
				  forceSelection:false,
				  anyMatch:true,
				  onTypeAhead:true,
				  emptyText:'',
				  triggerAction: 'all',
				  labelSeparator: '',
				  id: 'ToPlaceId',
				  enableKeyEvents:true,
				  //maxLength: 20,
				  value: '',
	        	  cls: 'selectstylePerfect',
	        	  listeners: {
		                   select: {
		                 	   fn:function(){
		                 	  	
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

function calculateDistance(){
var sourcelatlong;
	if(Ext.getCmp('loaingtypeLoccomboid').getValue()=='Stockyard'){
		var stockyard=Ext.getCmp('fromstockyardcomboid').getValue();
		var row = fromStockyardStore.find('stockyardId',stockyard);
		var rec = fromStockyardStore.getAt(row);
		sourcelatlong=rec.data['stockyardlat'] + ',' + rec.data['stockyardlong'];
	}
	if(Ext.getCmp('loaingtypeLoccomboid').getValue()=='Sand Block'){
		var portname=Ext.getCmp('FromSandPortStoreId').getValue();
		var row = FromSandPortStore.find('portName',portname);
		var rec = FromSandPortStore.getAt(row);
		sourcelatlong=rec.data['lat'] + ',' + rec.data['longi'];
	}
	
	
	 var service = new google.maps.DistanceMatrixService();
    service.getDistanceMatrix({
        origins: [sourcelatlong],
        destinations: [destlatlong],
        travelMode: google.maps.TravelMode.DRIVING,
        unitSystem: google.maps.UnitSystem.METRIC
    }, function callback(response, status) {
        if (status == google.maps.DistanceMatrixStatus.OK && response.rows[0].elements[0].status != "ZERO_RESULTS") {
            var distance = response.rows[0].elements[0].distance.text;
            var speed=10;
			var speedperkm=parseFloat(distance)/speed; 
            var validFromDate1 = new Date();
            var validToDate1 = new Date(new Date(validFromDate1).getTime() + 60 * 60 * speedperkm * 1000);
			Ext.getCmp('validfromId').setValue(validFromDate1);
			Ext.getCmp('validToId').setValue(validToDate1);
			Ext.getCmp('distanceHoursId').setValue(distance);
        }else{
        console.log("Unable to find the distance via road.");
		Ext.getCmp('distanceHoursId').reset();
		Ext.getCmp('validToId').reset();
        }
    });
    
}

var innerPanelForMDPGenerator = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 330,
    width: 645,
    frame: true,
    id: 'innerPanelForMDPGeneratorId',
    layout: 'table',
    layoutConfig: {
        columns: 7
    },
    items: [{
        xtype: 'fieldset',
        title: '',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'MDPGenerationDetailsId',
        width: 615,
        layout: 'table',
        layoutConfig: {
            columns: 7
        },
       items: [        
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'applicationNoid1'
        },{
            xtype: 'label',
            text: '<%=Consumer_Application_No%>' + ' :',
            cls: 'labelstyle',
            id: 'applicationNoLabelId'
        }, ApplicationNoCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'applicationNoid2'
        },{width : 50},{
            xtype: 'label',
            text: 'MDP Limit' + ' :',
            cls: 'labelstyle',
            id: 'limitlabelid1'
        },{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'limitLabelId'
        	},
           {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'sandtype1'
        },{
            xtype: 'label',
            text: 'Sand Extraction From' + ' :',
            cls: 'labelstyle',
            id: 'sandtype2'
        }, loaingtypeLoccombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandtype3'
        },{width : 50},{
            xtype: 'label',
            text: 'MDP Used' + ' :',
            cls: 'labelstyle',
            id: 'usedlabelid1'
        },{
            xtype: 'label',
            text: '',
            cls: 'labelstyle',
            id: 'usedlabelId'
        	},
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
        }, {},{},{}, 
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
        }, {},{},{}, 
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'transporterNameId1'
        }, {
            xtype: 'label',
            text: '<%=Transporter_Name%>' + ' :',
            cls: 'labelstyle',
            id: 'transporterNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'transporterNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'transporterNameId2'
        }, {},{},{},
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'customerNameid1'
        },{
            xtype: 'label',
            text: '<%=Customer_Name%>' + ' :',
            cls: 'labelstyle',
            id: 'customerNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'customerNameId'
        } ,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'customerNameid2'
        }, {},{},{},
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'customerMobileid1'
        },{
            xtype: 'label',
            text: 'Customer Mobile No.' + ' :',
            cls: 'labelstyle',
            id: 'customerMobileLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            readOnly:true,
            labelSeparator: '',
            id: 'customerMobileId'
        } ,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'customerMobileid2'
        }, {},{},{},
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'driverNameid1'
        },{
            xtype: 'label',
            text: '<%=Driver_Name%>' + ' :',
            cls: 'labelstyle',
            id: 'driverNameLabelId'
        },  {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'driverNameId'
        } ,{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'driverNameid2'
        }, {},{},{},
        {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'quantityid1'
              },{
                  xtype: 'label',
                  text: '<%=Quantity%>' + '(CBM) :',
                  cls: 'labelstyle',
                  id: 'quantityLabelId'
              }, {
				xtype: 'numberfield',
				cls: 'selectstylePerfect',
				allowBlank: false,
				size: "100", 
				blankText: '',
				 readOnly:true,
				emptyText: '',
				labelSeparator: '',
				id: 'quantityId',
				listeners: {
		          'change':function(){
		                var r=0;
						var qty=Ext.getCmp('quantityId').getValue();
<!--						if(<%=systemId%>==134 || <%=systemId%>==12)-->
<!--						{-->
<!--							if(Ext.getCmp('LoadingTypestoreId').getValue()=='Self')-->
<!--							{-->
<!--						 		r=300;-->
<!--							}-->
<!--							else-->
<!--							{-->
<!--						 		r=Ext.getCmp('amountId').getValue();-->
<!--							}-->
<!--						}-->
<!--						else-->
<!--						{-->
<!--						     r=Ext.getCmp('amountId').getValue();-->
<!--						}-->
						r=Ext.getCmp('amountId').getValue();
						var total=parseFloat(r);
						var permit=Ext.getCmp('PermitComboNewId').getValue();
						var CreditBy=Ext.getCmp('transporterNameId').getValue();
						total=parseFloat(total)*parseFloat(qty);
						Ext.Ajax.request({
			                url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=checkTotal',
			                method: 'POST',
			                params: {
				                       PERMITNO:permit,
				                       systemId:<%=systemId%>,
				                       clientId:custId,
				                       TYPE:CreditBy,
				                       total:total
			                        },
			            success:function(response, options)
	                    {
	                       if(response.responseText=="Error")
	                       {
							grid.store.reload();
		                    Ext.example.msg("Total Fee is greater then balance....Please  Deposit...!");
		                    return;
	                       }
	                   }, // end of success
	            	   failure: function(response, options)
	                   {
	                      grid.store.reload();
	                      Ext.example.msg("Error while Processing....!");
	                      return;
	                   }// end of failure
	            }); // end of Ajax	
	            
			var applicationNo = Ext.getCmp('ApplicationStoreId').getValue();
			Ext.Ajax.request({
			          url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=updateQuantity',
			          method: 'POST',
			          params: {
			                       qty:Ext.getCmp('quantityId').getValue(),
			                       clientId:custId,
			                       applicationNo : applicationNo
				             },
				             success:function(response, options)
		                    {
		                    messageQuant=response.responseText;
		                    if(messageQuant=="ERROR")
	                       {
		                    Ext.example.msg("Approved Quantity is less than entered quantity");
		                    return;
	                       }else if(messageQuant=="Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP"){
	                       Ext.example.msg("Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP");
		                    return;
	                       }
		                    }, // end of success
		            	   failure: function(response, options)
		                   {
		                     messageQuant="";
		                   }//
	           });
		        Ext.getCmp('totalFeesId').setValue(total);
			}
         }
	} ,  {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'quantityid2'
              }, {},{},{},
              {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'fromSandPortid1',
                  hidden:true
              },{
                  xtype: 'label',
                  text: '<%=From_Sand_Port%>' + ' :',
                  cls: 'labelstyle',
                  id: 'fromSandPortLabelId',
                  hidden:true
              },FromSandPort, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'fromSandPortid2'
              }, {},{},{},
              {
                  xtype: 'label',
                  text: '*',
                  cls: 'mandatoryfield',
                  id: 'fromstockyardid1',
                  hidden:true
              },{
                  xtype: 'label',
                  text: 'From Stockyard' + ' :',
                  cls: 'labelstyle',
                  id: 'fromstockyardLabelId',
                  hidden:true
              },FromStockyard, {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'fromstockyardid2',
                  hidden:true
              }, {},{},{},
              {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'viaRouteid1'
              },{
                  xtype: 'label',
                  text: '<%=Via_Route%>' + ' :',
                  cls: 'labelstyle',
                  id: 'viaRouteLabelId'
              }, {
				xtype: 'textfield',
				cls: 'selectstylePerfect',
				allowBlank: false,
				size: "100", 
				blankText: '',
				emptyText: '',
				labelSeparator: '',
				id: 'viaRouteId'
			} ,  {
                  xtype: 'label',
                  text: '',
                  cls: 'mandatoryfield',
                  id: 'viaRouteid2'
              }, {},{},{},
              {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'toPlaceid1'
        }, {
            xtype: 'label',
            text: '<%=To_Place%>' + ' :',
            cls: 'labelstyle',
            id: 'toPlacelabelid'
        }, ToPlaceCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'toPlaceid2'
        }, {},{},{},
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandPortNumberid1'
        }, {
            xtype: 'label',
            text: '<%=Sand_Port_No%>' + ' :',
            cls: 'labelstyle',
            id: 'sandPortNumberlabelid'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'sandPortNumberId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'SandPortNumberid2'
        }, {},{},{},
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandPortUniqueNoid1'
        }, {
            xtype: 'label',
            text: '<%=Sand_Port_Unique_No%>' + ' :',
            cls: 'labelstyle',
            id: 'sandPortUniqueNolabelid'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'sandPortUniqueNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'sandPortUniqueNoid2'
        }, {},{},{},
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
              format: getDateTimeFormat(),
			  allowBlank: false,
			  readOnly: false,
			  emptyText: '',
			 // value:dtcur,
			 minValue:dtcur,
			 maxValue:dtnext,
			  id: 'validfromId',
			  listeners: {
					select: function() {
<!--						if(<%=systemId%>==134){-->
<!--								var fromDate=new Date();-->
<!--								var Today=new Date();-->
<!--								fromDate=new Date(fromDate);-->
<!--								if(Today>fromDate)-->
<!--								{-->
<!--									Ext.example.msg("VALID FROM date Should be greater then the present time");-->
<!--									grid.store.reload();-->
<!--									return;-->
<!--								}-->
<!--		                   }-->
		                 
		                   Ext.getCmp('ApplicationStoreId').reset();
		                   Ext.getCmp('limitLabelId').setText('');
		                   Ext.getCmp('usedlabelId').setText('');
		              }
		        }
		  }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'validFromid2'
        }, {},{},{},
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'distanceid1'
        },{
            xtype: 'label',
            text: '<%=Distance%>' + ' :',
            cls: 'labelstyle',
            id: 'distancelableId'
        },{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            readOnly: true,
            id: 'distanceHoursId',
            listeners: {
			change: function() {
		             		 }
		        }
        },{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'distanceid2'
        }, {},{},{},
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
        },{
			  xtype: 'datefield',
			  cls: 'selectstylePerfect',
			  format: getDateTimeFormat(),
			  allowBlank: false,
			  readOnly: false,
			  emptyText: '',
              maxValue: myDate, 
			  id: 'validToId'
		  }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'validToid2'
        }, {},{},{},
		{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mineralTypeid1'
        }, {
            xtype: 'label',
            text: '<%=Mineral_Type%>' + ' :',
            cls: 'labelstyle',
            id: 'mineralTypelabelid'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'mineralTypeId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mineralTypeid2'
        }, {},{},{},
		{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'loadingTypeid1'
        }, {
            xtype: 'label',
            text: '<%=Loading_Type%>' + ' :',
            cls: 'labelstyle',
            id: 'loadingTypelabelid'
        }, LoadingTypeCombo, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'loadingTypeid2'
        }, {},{},{},
		{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'surveyNoid1'
        }, {
            xtype: 'label',
            text: '<%=Survey_No%>' + ' :',
            cls: 'labelstyle',
            id: 'surveyNolabelid'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'surveyNoId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'surveyNoid2'
        }, {},{},{},
		{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'villageid1'
        }, {
            xtype: 'label',
            text: '<%=Village%>' + ' :',
            cls: 'labelstyle',
            id: 'villagelabelid'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'villageId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'villageid2'
        }, {},{},{},
        {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'talukid1'
        }, {
            xtype: 'label',
            text: '<%=Taluka%>' + ' :',
            cls: 'labelstyle',
            id: 'taluklabelid'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'talukId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'talukid2'
        }, {},{},{},
		{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'amountid1'
        }, {
            xtype: 'label',
            text: '<%=Amount_CubicMeter%>'+'(Rs)' + ' :',
            cls: 'labelstyle',
            id: 'amountlabelid'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            readOnly:true,
            id: 'amountId',
            listeners: {
		          'change':function(){
		                var r=0;
						var qty=Ext.getCmp('quantityId').getValue();
<!--						if(<%=systemId%>==134 || <%=systemId%>==12)-->
<!--						{-->
<!--							if(Ext.getCmp('LoadingTypestoreId').getValue()=='Self')-->
<!--							{-->
<!--						 		r=300;-->
<!--							}-->
<!--							else-->
<!--							{-->
<!--						 		r=Ext.getCmp('amountId').getValue();-->
<!--							}-->
<!--						}-->
<!--						else-->
<!--						{-->
<!--						     r=Ext.getCmp('amountId').getValue();-->
<!--						}-->
						r=Ext.getCmp('amountId').getValue();
						var total=parseFloat(r);
						var permit=Ext.getCmp('PermitComboNewId').getValue();
						var CreditBy=Ext.getCmp('transporterNameId').getValue();
						total=parseFloat(total)*parseFloat(qty);
						Ext.Ajax.request({
			                url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=checkTotal',
			                method: 'POST',
			                params: {
				                       PERMITNO:permit,
				                       systemId:<%=systemId%>,
				                       clientId:custId,
				                       TYPE:CreditBy,
				                       total:total,
				                       applicatn:Ext.getCmp('ApplicationStoreId').getValue()
			                        },
			            success:function(response, options)
	                    {
	                       if(response.responseText=="Error")
	                       {
							grid.store.reload();
		                    Ext.example.msg("Total Fee is greater then balance....Please  Deposit...!");
		                    return;
	                       }
	                   }, // end of success
	            	   failure: function(response, options)
	                   {
	                      grid.store.reload();
	                      Ext.example.msg("Error while Processing....!");
	                      return;
	                   }// end of failure
	            }); // end of Ajax	
			
		        Ext.getCmp('totalFeesId').setValue(total);
			}
         }
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'amountid2'
        }, {},{},{},
		{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'totalFeesid1'
        }, {
            xtype: 'label',
            text: '<%=Total_Fee%>'+'(Rs)' + ' :',
            cls: 'labelstyle',
            id: 'totalFeeslabelid'
        }, {
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
            id: 'totalFeesId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'totalFeesid2'
        },{},{},{}
]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 640,
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
                    if (Ext.getCmp('ApplicationStoreId').getValue() == "") {
                        Ext.example.msg("<%=Select_Consumer_Application_No%>");
                        return;
                    }
                    if(ApplicationRec.data['TotalMdpLimit'] != "NA" && ApplicationRec.data['TotalMdpLimit'] <= ApplicationRec.data['TotalMdpUsed'] ){
                        Ext.example.msg("Sorry!! MDP limit has reached for this application type");
                        Ext.getCmp('ApplicationStoreId').focus();
                        return;
                    }
                    if (Ext.getCmp('loaingtypeLoccomboid').getValue() == "") {
                        Ext.example.msg("Please Select Sand Extraction From");
                        return;
                    }
                    if (Ext.getCmp('PermitComboNewId').getValue() == "") {
                        Ext.example.msg("<%=select_vehicle_No%>");
                        return;
                    }
                    if (Ext.getCmp('transporterNameId').getValue() == "") {
                        Ext.example.msg("Select Transporter Name");
                        return;
                    }
                    if (Ext.getCmp('loaingtypeLoccomboid').getValue() == 'Sand Block') {
                    if (Ext.getCmp('FromSandPortStoreId').getValue() == "") {
                        Ext.example.msg("<%=Select_Sand_Port%>");
                        return;
                    }
                    else {fromPlaceAdd = Ext.getCmp('FromSandPortStoreId').getValue();}
                    }
                    else
                    {
                     if (Ext.getCmp('fromstockyardcomboid').getValue() == "") {
                        Ext.example.msg("Select Stockyard");
                        return;
                    }
                    else{fromPlaceAdd = Ext.getCmp('fromstockyardcomboid').getRawValue();}
                    }
                    if (Ext.getCmp('ToPlaceId').getValue() == "") {
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
                    
                    if((dateCompare(Ext.getCmp('validfromId').getValue(), nxtdate) == -1) || (dateCompare(Ext.getCmp('validToId').getValue(), nxtdate) == -1)){
                        Ext.example.msg("Future MDP's Cannot Be Generated for more than one day");
                        return;
                    }
                    
                    if (Ext.getCmp('validToId').getValue() == "") {
                        Ext.example.msg("select Valid To");
                        return;
                    }
                   
                    if (Ext.getCmp('LoadingTypestoreId').getValue() == "") {
                        Ext.example.msg("<%=Select_Loading_Type%>");
                        return;
                    }
                     if (dateCompare(Ext.getCmp('validfromId').getValue(), Ext.getCmp('validToId').getValue()) == -1) {
                             Ext.example.msg("Valid To Should Be Greater than Valid From Date");
                             Ext.getCmp('enddate').focus();
                             return;
                     }
                     var hr=Ext.getCmp('validToId').getValue().getTime() - Ext.getCmp('validfromId').getValue().getTime();
                     if ((hr/(1000 * 60 * 60)) > 24) {
                             Ext.example.msg("Valid To Timeduration Should not be Greater than 24 Hrs.");
                             Ext.getCmp('enddate').focus();
                             return;
                     }
                    
                    if (Ext.getCmp('quantityId').getValue()== "" || Ext.getCmp('quantityId').getValue()==0.000) {
                        Ext.example.msg("Invalid Quantity");
                        return;
                    } 
                    
                    if (Ext.getCmp('totalFeesId').getValue()== "" || Ext.getCmp('totalFeesId').getValue()==0.000) {
                        Ext.example.msg("Cannot Generate MDP with Total Fee 0");
                        return;
                    } 
                    
                    if (Ext.getCmp('mdpNoId').getValue()== undefined) {
                        Ext.example.msg("Invalid MDP No");
                        return;
                    } 
                    if (messageQuant== "ERROR") {
                        Ext.example.msg("Approved Quantity is less than entered quantity");
                        return;
                    }
                    if(messageQuant=="Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP"){
	                    Ext.example.msg("Sorry!! Vehicle is in Blocked state, You cannot perform Credit/MDP");
		                return;
	                }
                    
                     if (buttonValue == "<%=Modify%>") {
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
                        
                    }
                    
                    sandInwardPermitOuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/ConsumerMDPGeneratorAction.do?param=saveGRID',
                        method: 'POST',
                        params: {
                            buttonValue: buttonValue,
                            custId: Ext.getCmp('custcomboId').getValue(),
                            mdpNoAdd : Ext.getCmp('mdpNoId').getValue(),
	                        permitNoAdd : Ext.getCmp('PermitComboNewId').getValue(),
	                        transporterNameAdd : Ext.getCmp('transporterNameId').getValue(),
	                        loadingTypeAdd : Ext.getCmp('LoadingTypestoreId').getValue(),
	                        surveyNoAdd : Ext.getCmp('surveyNoId').getValue(),
	                        villageAdd : Ext.getCmp('villageId').getValue(),
	                        talukAdd : Ext.getCmp('talukId').getValue(),
	                        districtAdd : '',
	                        quantityAdd : Ext.getCmp('quantityId').getValue(),
	                        amountAdd : Ext.getCmp('amountId').getValue(),
	                        totalFeeAdd : Ext.getCmp('totalFeesId').getValue(),
	                        fromPlaceAdd : fromPlaceAdd,
	                        toPlaceAdd : Ext.getCmp('ToPlaceId').getValue(),
	                        sandPortNoAdd : Ext.getCmp('sandPortNumberId').getValue(),
	                        sandPortUniqueIdAdd : Ext.getCmp('sandPortUniqueNoId').getValue(),
	                        validFromAdd : Ext.getCmp('validfromId').getValue(),
	                        distanceAdd : Ext.getCmp('distanceHoursId').getValue(),
	                        validToAdd : Ext.getCmp('validToId').getValue(),
	                        customerNameAdd : Ext.getCmp('customerNameId').getValue(),
	                        customerMobileAdd : Ext.getCmp('customerMobileId').getValue(),
	                        driverNameAdd : Ext.getCmp('driverNameId').getValue(),
	                        viaRouteAdd : Ext.getCmp('viaRouteId').getValue(),
	                        mineralTypeAdd : Ext.getCmp('mineralTypeId').getValue(),
	                        applicationNoAdd : Ext.getCmp('ApplicationStoreId').getValue(),
	                        validityPeriodAdd : '1 Day',
	                        transporterAdd : transporter,
	                        //MlNoModify = selected.get('MlnoDataIndex');
	                        processingFeeAdd : '0.000', 
	                        vehicleAddrAdd : customerAddress,
	                        printedAdd : 'N',
	                        TSDateAdd : todaysDate,
	                        DDNoAdd : DD_NoNew,
	                        bankNameAdd : Bank_Name,
	                        DDDateAdd : DD_Date,
	                        groupIdAdd : groupId,
	                        groupNameAdd : groupName,
	                        vehicleNoAdd : vehicleNo,
	                        SandLoadingFromTimeAdd :SandLoadingFromTime,
	                        SandLoadingToTimeAdd :SandLoadingToTime,
	                        uniqueID:uniqueID,
	                        sandExtraction:Ext.getCmp('loaingtypeLoccomboid').getValue(),
	                        fromstockyard : Ext.getCmp('fromstockyardcomboid').getRawValue(),
	                        fromstockyardId : Ext.getCmp('fromstockyardcomboid').getValue(),
	                        
                            districtModify : districtModify,
	                        mineralTypeModify : mineralTypeModify,
	                        uniqueIdModify : uniqueIdModify,
	                        applicationNoModify : applicationNoModify,
	                        validityPeriodModify : validityPeriodModify,
	                        transporterModify : transporterModify,
	                        MlNoModify : MlNoModify,
	                        processingFeeModify : processingFeeModify,
	                        vehicleAddrModify : vehicleAddrModify,
	                        printedModify : printedModify,
	                        TSDateModify : TSDateModify,
	                        DDNoModify : DDNoModify,
	                        bankNameModify : bankNameModify,
	                        DDDateModify : DDDateModify,
	                        groupIdModify : groupIdModify,
	                        groupNameModify : groupNameModify,
	                        indexNoModify : indexNoModify,
	                        vehicleNoModify : vehicleNoModify,
	                        SandLoadingFromTimeModify : SandLoadingFromTimeModify,
                            SandLoadingToTimeModify : SandLoadingToTimeModify,
                            quantityModify : quantityModify,
                            uniqueID:uniqueID,
                            sandportUniqueidModify:sandportUniqueidModify,
                            extractionTypeModify:extractionTypeModify,
                            latitude: latitude,
                            longitude: longitude
                        },
                        success: function(response, options) {
                            var message = response.responseText;
                            Ext.example.msg(message);
                            myWin.hide();
                            sandInwardPermitOuterPanelWindow.getEl().unmask();
                             store.load({
                                params: {
                                    ClientId: Ext.getCmp('custcomboId').getValue(),
                                    jspname:jspname,
                                    custname:custname
                                 }
                            });
                            PermitStoreNew.load({params:{clientId:custId}});
		        			FromSandPortStore.load({params:{clientId:custId}});
		        			ToPlaceStore.load({params:{clientId:custId}});
		      				vehicleNoStore.load({params:{clientId: custId}});
		      				ApplicationNoStore.load({params:{clientId:custId}});
		      				fromStockyardStore.load({params:{clientId:custId}});
                            
                            
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
					Ext.getCmp('ApplicationStoreId').reset();
					Ext.getCmp('mdpNoId').reset();
					Ext.getCmp('PermitComboNewId').reset();
					Ext.getCmp('transporterNameId').reset();
					Ext.getCmp('customerNameId').reset();
					Ext.getCmp('customerMobileId').reset();
					Ext.getCmp('driverNameId').reset();
					Ext.getCmp('quantityId').reset();
					Ext.getCmp('FromSandPortStoreId').reset();
					Ext.getCmp('viaRouteId').reset();
					Ext.getCmp('ToPlaceId').reset();
					Ext.getCmp('sandPortNumberId').reset();
					Ext.getCmp('sandPortUniqueNoId').reset();
					Ext.getCmp('validfromId').reset();
					Ext.getCmp('distanceHoursId').reset();
					Ext.getCmp('validToId').reset();
					Ext.getCmp('mineralTypeId').reset();
					Ext.getCmp('LoadingTypestoreId').reset();
					Ext.getCmp('surveyNoId').reset();
					Ext.getCmp('villageId').reset();
					Ext.getCmp('talukId').reset();
					Ext.getCmp('amountId').reset();
					Ext.getCmp('totalFeesId').reset();
					Ext.getCmp('limitLabelId').setText('');
		            Ext.getCmp('usedlabelId').setText('');
                    myWin.hide();
                }
            }
        }
    }]
});

var sandInwardPermitOuterPanelWindow = new Ext.Panel({
    width: 640,
    height: 430,
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
    height: 450,
    width: 650,
    id: 'myWin',
    items: [sandInwardPermitOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
        Ext.example.msg("select Client Name");
        return;
    }
    titelForInnerPanel = 'Add Information';
    myWin.setPosition(350, 30);
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
    Ext.getCmp('ApplicationStoreId').enable();
    Ext.getCmp('mdpNoId').enable();
    Ext.getCmp('PermitComboNewId').enable();
    Ext.getCmp('transporterNameId').enable();
    Ext.getCmp('loaingtypeLoccomboid').enable();
    Ext.getCmp('totalFeesId').disable();
    Ext.getCmp('ApplicationStoreId').reset();
	Ext.getCmp('mdpNoId').reset();
	Ext.getCmp('PermitComboNewId').reset();
	Ext.getCmp('transporterNameId').reset();
	Ext.getCmp('customerNameId').reset();
	Ext.getCmp('customerMobileId').reset();
	Ext.getCmp('driverNameId').reset();
	Ext.getCmp('quantityId').reset();
	Ext.getCmp('FromSandPortStoreId').reset();
	Ext.getCmp('viaRouteId').reset();
	Ext.getCmp('ToPlaceId').reset();
	Ext.getCmp('sandPortNumberId').reset();
	Ext.getCmp('sandPortUniqueNoId').reset();
	Ext.getCmp('validToId').reset();
	Ext.getCmp('mineralTypeId').reset();
	Ext.getCmp('LoadingTypestoreId').reset();
	Ext.getCmp('surveyNoId').reset();
	Ext.getCmp('villageId').reset();
	Ext.getCmp('talukId').reset();
	Ext.getCmp('amountId').reset();
	Ext.getCmp('totalFeesId').reset();
	Ext.getCmp('loaingtypeLoccomboid').reset();
    Ext.getCmp('fromstockyardcomboid').reset();
    Ext.getCmp('loaingtypeLoccomboid').reset();
    Ext.getCmp('distanceHoursId').reset();
    Ext.getCmp('limitLabelId').setText('');
	Ext.getCmp('usedlabelId').setText('');
	 if(<%=Quantity_Measure%>){
	 Ext.getCmp('quantityLabelId').setText('Quantity' + '(Tons):');
	  Ext.getCmp('amountlabelid').setText('Amount/Tons' + '(Rs):');
	 }
}

 function modifyData() {
       //clientcombostore.reload();
       if (Ext.getCmp('custcomboId').getValue() == "") {
           Ext.example.msg("Select Client Name");
           return;
       }
       if (grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
       if (grid.getSelectionModel().getCount() > 1) {
          Ext.example.msg("Select single row");
           return;
       }
      PermitStoreNew.load({params:{clientId:custId}});
	   FromSandPortStore.load({params:{clientId:custId}});
	   buttonValue = '<%=Modify%>';
       // Ext.getCmp('usersCheckBoxId').hide();
       titelForInnerPanel = 'Modify Information';
       myWin.setPosition(350, 30);
       myWin.setTitle(titelForInnerPanel);
       myWin.show();
       Ext.getCmp('ApplicationStoreId').disable();
	   Ext.getCmp('mdpNoId').disable();
	   Ext.getCmp('PermitComboNewId').disable();
	   Ext.getCmp('transporterNameId').disable();
	   Ext.getCmp('totalFeesId').disable();
	   Ext.getCmp('loaingtypeLoccomboid').disable();
	   Ext.getCmp('amountId').disable();
	   Ext.getCmp('quantityId').disable();
	   
       var selected = grid.getSelectionModel().getSelected();
       if(selected.get('extractionindx')=='Stockyard')
       {
                             Ext.getCmp('FromSandPortStoreId').hide();
		                 	  Ext.getCmp('fromSandPortid1').hide();
		                 	   Ext.getCmp('fromSandPortLabelId').hide();
		                 	    Ext.getCmp('fromSandPortid2').hide();
		                 	    Ext.getCmp('fromstockyardid1').show();
		                 	    Ext.getCmp('fromstockyardid2').show();
		                 	    Ext.getCmp('fromstockyardcomboid').show();
		                 	    Ext.getCmp('fromstockyardLabelId').show();
		                 	   Ext.getCmp('fromstockyardcomboid').setValue(selected.get('FromPlaceDataIndex'));
       }
       else
       {
         Ext.getCmp('FromSandPortStoreId').setValue(selected.get('FromPlaceDataIndex'));
       }
       Ext.getCmp('ApplicationStoreId').setValue(selected.get('applicationNODataIndex'));
	   Ext.getCmp('mdpNoId').setValue(selected.get('TripSheetNODataIndex'));
	   Ext.getCmp('PermitComboNewId').setValue(selected.get('PermitNoDataIndex'));
	   Ext.getCmp('transporterNameId').setValue(selected.get('PermitHolderDataIndex'));
	   Ext.getCmp('customerNameId').setValue(selected.get('CustomerNameDataIndex'));
	   //Ext.getCmp('customerMobileId').setValue(selected.get('CustomerNameDataIndex'));
	   Ext.getCmp('driverNameId').setValue(selected.get('DriverIndex'));
	   Ext.getCmp('quantityId').setValue(selected.get('QuantityDataIndex'));
	  // Ext.getCmp('FromSandPortStoreId').setValue(selected.get('FromPlaceDataIndex'));
	   Ext.getCmp('viaRouteId').setValue(selected.get('ViaRouteDataIndex'));
	   Ext.getCmp('ToPlaceId').setValue(selected.get('ToPlaceIndex'));
	   Ext.getCmp('sandPortNumberId').setValue(selected.get('SandPortNoIndex'));
	   Ext.getCmp('sandPortUniqueNoId').setValue(selected.get('SandPortUniqueIdIndex'));
	   Ext.getCmp('validfromId').setValue(selected.get('DateOfEntryDataIndex'));
	   Ext.getCmp('validToId').setValue(selected.get('DateOfEntryDataIndex1'));
	   Ext.getCmp('mineralTypeId').setValue(selected.get('MiningTypeDataIndex'));
	   Ext.getCmp('LoadingTypestoreId').setValue(selected.get('LoadingTypeDataIndex'));
	   Ext.getCmp('surveyNoId').setValue(selected.get('SurveyNoDataIndex'));
	   Ext.getCmp('villageId').setValue(selected.get('VillageDataIndex'));
	   Ext.getCmp('talukId').setValue(selected.get('TalukDataIndex'));
	   Ext.getCmp('amountId').setValue(selected.get('RoyalityDataIndex'));
	   Ext.getCmp('totalFeesId').setValue(selected.get('TotalFeeDataIndex'));
	   Ext.getCmp('loaingtypeLoccomboid').setValue(selected.get('extractionindx'));
	   Ext.getCmp('distanceHoursId').setValue(selected.get('distanceindex'));
	   
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
     autoLoad: false,
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
		{dataIndex:'TransporterDataIndex', type:'string'},
		{dataIndex:'MlnoDataIndex', type:'string'},
		{dataIndex:'MiningTypeDataIndex', type:'string'},
		{dataIndex:'LoadingTypeDataIndex', type:'string'},
		{dataIndex:'SurveyNoDataIndex', type:'string'},
		{dataIndex:'VillageDataIndex', type:'string'},
		{dataIndex:'TalukDataIndex', type:'string'},
		{dataIndex:'DistrictDataIndex', type:'string'},
		{dataIndex:'QuantityDataIndex', type:'string'},
		{dataIndex:'RoyalityDataIndex', type:'numeric'},
		{dataIndex:'ProcessingFeeDataIndex', type:'numeric'},
		{dataIndex:'TotalFeeDataIndex', type:'numeric'},
		{dataIndex:'VehicleNoDataIndex', type:'string'},
		{dataIndex:'VehicleAddrDataIndex', type:'string'},
		{dataIndex:'FromPlaceDataIndex', type:'string'},
		{dataIndex:'ViaRouteDataIndex', type:'string'},
		{dataIndex:'ToPlaceIndex', type:'string'},
		{dataIndex:'SandPortNoIndex', type:'string'},
		{dataIndex:'SandPortUniqueIdIndex', type:'string'},
		{dataIndex:'DateOfEntryDataIndex', type:'date'},
		{dataIndex:'DateOfEntryDataIndex1', type:'date'},
		{dataIndex:'PrintedIndex', type:'string'},
		{dataIndex:'TSDateDataIndex', type:'date'},
		{dataIndex:'DDNumberDataIndex', type:'string'},
		{dataIndex:'BankNameIndex', type:'string'},
		{dataIndex:'DDDateDataIndex', type:'date'},
		{dataIndex:'GroupIdDataIndex', type:'string'},
		{dataIndex:'GroupNameIndex', type:'string'},
		{dataIndex:'IndexNoIndex', type:'string'},
		{dataIndex:'DriverIndex', type:'string'},
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
        	sortable: true,
        	hideable: true,
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            filter: {
                type: 'numeric'
            }
        },{
            dataIndex: 'UniqueIdDataIndex',
            hidden:true,
            hideable: true,
            width: 150,
            header: "<span style=font-weight:bold;><%=UniqueId_No%></span>",
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Consumer_Application_No%></span>",
            dataIndex: 'applicationNODataIndex',
            hidden: false,
        	sortable: true,
        	hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        },{
            dataIndex: 'TripSheetNODataIndex',
            hidden: false,
        	sortable: true,
        	hideable: true,
        	width: 150,
            header: "<span style=font-weight:bold;><%=MDP_No%></span>",
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Vehicle_No%></span>",
            dataIndex: 'PermitNoDataIndex',
            hidden: false,
        	sortable: true,
        	hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Validity_Period%></span>",
            dataIndex: 'ValidityPeriodDataIndex',
            hidden: true,
        	sortable: true,
        	hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Transporter_Name%></span>",
            dataIndex: 'PermitHolderDataIndex',
            hidden: false,
        	sortable: true,
        	hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Customer_Name%></span>",
            dataIndex: 'CustomerNameDataIndex',
            hidden: false,
        	sortable: true,
        	hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Driver_Name%></span>",
            dataIndex: 'DriverIndex',
            hidden: false,
        	sortable: true,
        	hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Transporter%></span>",
            dataIndex: 'TransporterDataIndex',
            hidden: true,
        	sortable: true,
        	hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ML_No%></span>",
            dataIndex: 'MlnoDataIndex',
           	hidden: true,
        	sortable: true,
        	hideable: true,
            width: 150,
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;><%=Vehicle_No%></span>",
            dataIndex: 'VehicleNoDataIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Customer_Address%></span>",
            dataIndex: 'VehicleAddrDataIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=District%></span>",
            dataIndex: 'DistrictDataIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Quantity%>(CBM)</span>",
            dataIndex: 'QuantityDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=From_Sand_Port%></span>",
            dataIndex: 'FromPlaceDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Via_Route%></span>",
            dataIndex: 'ViaRouteDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=To_Place%></span>",
            dataIndex: 'ToPlaceIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Sand_Port_No%></span>",
            dataIndex: 'SandPortNoIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Sand_Port_Unique_No%></span>",
            dataIndex: 'SandPortUniqueIdIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Valid_From%></span>",
            dataIndex: 'DateOfEntryDataIndex',
            width: 150,
            renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Valid_To%></span>",
            dataIndex: 'DateOfEntryDataIndex1',
            width: 150,
            renderer: Ext.util.Format.dateRenderer('d/m/Y H:i:s'),
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Mineral_Type%></span>",
            dataIndex: 'MiningTypeDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Loading_Type%></span>",
            dataIndex: 'LoadingTypeDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Survey_No%></span>",
            dataIndex: 'SurveyNoDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Village%></span>",
            dataIndex: 'VillageDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Taluka%></span>",
            dataIndex: 'TalukDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Amount_CubicMeter%>(Rs)</span>",
            dataIndex: 'RoyalityDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Processing_Fees%>(Rs)</span>",
            dataIndex: 'ProcessingFeeDataIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Total_Fee%>(Rs)</span>",
            dataIndex: 'TotalFeeDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;><%=Printed%></span>",
            dataIndex: 'PrintedIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	hideable: true,
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
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=DD_No%></span>",
            dataIndex: 'DDNumberDataIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Bank_Name%></span>",
            dataIndex: 'BankNameIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
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
        	hideable: true,
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=Group_Id%></span>",
            dataIndex: 'GroupIdDataIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Group_Name%></span>",
            dataIndex: 'GroupNameIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Index_No%></span>",
            dataIndex: 'IndexNoIndex',
            width: 150,
            hidden: true,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Sand_Loading_From_Time%></span>",
            dataIndex: 'SandLoadingFromTimeIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Sand_Loading_To_Time%></span>",
            dataIndex: 'SandLoadingToTimeIndex',
            width: 150,
            hidden: false,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>Extraction Type</span>",
            dataIndex: 'extractionindx',
            width: 150,
            hidden: true,
        	sortable: true,
        	hideable: true,
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;><%=Distance%></span>",
            dataIndex: 'distanceindex',
            width: 150,
            hidden: true,
        	sortable: true,
        	hideable: true,
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
             			window.open("<%=request.getContextPath()%>/Sand_Mining_MDP?uids="+uids+"&ts="+ts+"&systemId="+<%=systemId%>+"");										 
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
grid = getSandPermitGrid('<%=Consumer_MDP_Generator%>', '<%=No_Records_Found%>', store, screen.width - 32, 420, 45, filters, '<%=Clear_Filter_Data%>', false, '',20, false, '', false, '', true, '<%=Excel%>', jspname, exportDataType, true, '<%=PDF%>', true, '<%=Add%>', true, '<%=Modify%>', true, 'Print MDP');
//******************************************************************************************************************************************************
Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '<%=Consumer_MDP_Generator%>',
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
    }
    var cm = grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,150);
    }
    
});
</script>
</body>
</html>
    
    
    
    
    

