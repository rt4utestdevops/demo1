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
	if(str.length>11){
	loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
	}
	session.setAttribute("loginInfoDetails",loginInfo);
	
}
	Properties properties = ApplicationListener.prop;
String GoogleApiKey = properties.getProperty("GoogleMapApiKeyen").trim();
	CommonFunctions cf = new CommonFunctions();
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
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Excel");
tobeConverted.add("Cancel");
tobeConverted.add("Add");
tobeConverted.add("Delete");
tobeConverted.add("Modify");
tobeConverted.add("Modify_Details");
tobeConverted.add("Save");
tobeConverted.add("Customer_Name");
tobeConverted.add("Select_Customer_Name");
tobeConverted.add("SLNO");
tobeConverted.add("Select_Group_Name");
tobeConverted.add("Select_Vehicle");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String NoRecordsFound = convertedWords.get(0);
String ClearFilterData = convertedWords.get(1);
String Excel = convertedWords.get(2);
String Cancel = convertedWords.get(3);
String Add = convertedWords.get(4);
String Delete = convertedWords.get(5);
String Modify = convertedWords.get(6);
String ModifyDetails = convertedWords.get(7); 
String Save=convertedWords.get(8);
String Customer_Name = convertedWords.get(9);
String SelectCustomerName=convertedWords.get(10);
String SLNO = convertedWords.get(11);
String SelectGroupName=convertedWords.get(12);
String SelectVehicle=convertedWords.get(13);
	%>
<jsp:include page="../Common/header.jsp" /> 
    <title>Trip Generation</title>

  <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	#totalAttDistanceLabel{
	margin-left: 125px !important ;
	}
	#driverLabId,#mobileLabId{
	margin-left: 50px !important ;
	}
	#distanceTxtId{
	margin-left: 20px !important ;
	}
	.ext-strict .x-form-text {
		height: 21px !important;
	}
	label {
			display : inline !important;
		}
		.x-window-tl *.x-window-header {
			padding-top : 6px !important;
			height : 46px !important;
		}
		#NewRecordId {
			width : 644px !important;
		}

  </style>

   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
    <!-- for exporting to excel***** -->
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
	.x-layer ul {
		 	min-height: 27px !important;
		}
   </style>
   
  <script src="https://maps.googleapis.com/maps/api/js?v=3.exp&libraries=places,geometry&key=AIzaSyBSHs2852hTpOnebBOn48LObrqlRdEkpBs&region=IN"></script>
 
   <script>
    var outerPanel;
 	var ctsb;
 	var dtcur = new Date();
 	var dtnxt = nextDate;
 	var jspName="Trip_Generation";
 	var titelForInnerPanel="Add Trip Details";
 	var exportDataType="int, string, string, date, string, string, string, string, date ";
 	var selected;
 	var grid;
 	var buttonValue;
 	var title;
 	var myWin;
 	var custId = '<%=customerId%>';
 	var globalGroupId;
 	var id;
 	var touchPointCombos=[];
 	var lastTouchPointLat;
 	var lastTouchPointLong;
 	var lasttouchId;
 	var routeName;
 	var lasttouchPoint;
 	
 	function isValidTripId(tripid) {
    	var pattern = new RegExp(/^\s*[a-zA-Z0-9\s]+\s*$/);
    	return pattern.test(tripid);
	}
 	function isValidMobile(mobileid) {
    	var pattern = new RegExp(/^\s*[0-9\s]+\s*$/);
    	return pattern.test(mobileid);
	}
//override function for showing first row in grid
 	Ext.override(Ext.grid.GridView, {
    	afterRender: function(){
        this.mainBody.dom.innerHTML = this.renderRows();
        this.processRows(0, true);
        if(this.deferEmptyText !== true){
            this.applyEmptyText();
        }
        this.fireEvent("viewready", this);//new event
    	}   
	});  
//**************LatLong*************************
function setLatLong(comp){
var locationstr = locationStore.findExact('HubId', Ext.getCmp(comp.id).getValue());
  if(locationstr >=0)
    {
     var record = locationStore.getAt(locationstr);
     var currentLat =record.data['Latitude'];
	 var currentLong =record.data['Longitude'];
	 lastTouchPointLat=currentLat;
	 lastTouchPointLong=currentLong;
	 return record;
    }else{
      Ext.example.msg("No data");
     }
}

function setLatLong1(comp,preComp,distanceColNo){
var locationsrc = locationStore.findExact('HubId', Ext.getCmp(comp.id).getValue());
  if(locationsrc >=0)
    {
     var record = locationStore.getAt(locationsrc);
     var currentLat =record.data['Latitude'];
	 var currentLong =record.data['Longitude'];
    }else{
      Ext.example.msg("No data");
     }
     
     var locationdes = locationStore.findExact('HubId', Ext.getCmp(preComp).getValue());
     if(locationdes=='-1'){
     locationdes = 0;
     }
  if(locationdes >=0)
    {
     var record = locationStore.getAt(locationdes);
     var previousLat =record.data['Latitude'];
	 var previousLong =record.data['Longitude'];
    }else{
      Ext.example.msg("No data");
     }
      if(comp.id!='locationDestinationComboId'){
	 lastTouchPointLat=currentLat;
	 lastTouchPointLong=currentLong;
	 }
	 else{
	previousLat = lastTouchPointLat;
	previousLong = lastTouchPointLong;
	 }
     getDistanceETA(currentLat,currentLong,previousLat,previousLong,distanceColNo,comp)
     
}
//****************Distance calculation*********************
function getDistanceETA(Sourcelat,Sourcelong, destlat,destLong,touchPointId,currentTouchpt){

var origin = new google.maps.LatLng( Sourcelat,Sourcelong);
 var destination =new google.maps.LatLng(destlat,destLong);
//var origin1 = new google.maps.LatLng(55.930385, -3.118425);
//var origin2 = 'Greenwich, England';
//var destinationA = 'Stockholm, Sweden';
//var destinationB = new google.maps.LatLng(50.087692, 14.421150);
	var resetId=currentTouchpt.id;

var service = new google.maps.DistanceMatrixService();
service.getDistanceMatrix(
  {
    origins: [origin],
    destinations: [destination],
    travelMode: google.maps.TravelMode.DRIVING,
    unitSystem: google.maps.UnitSystem.METRIC,
    avoidHighways: false,
    avoidTolls: false,
  }, callback);

//function callback(response, status) {
  // See Parsing the Results for
  // the basics of a callback function.
//}

function callback(response, status) {
   // var orig = document.getElementById("orig"),
    //    dest = document.getElementById("dest"),
        //dist = document.getElementById("touchPointDistanceId"+touchPointId);
       var dist= Ext.getCmp("touchPointDistanceId"+touchPointId);

    if(response.rows[0].elements[0].status=="OK") {
       // orig.value = response.destinationAddresses[0];
      //  dest.value = response.originAddresses[0];
       var res =response;
       var hr =0;
       var min = 0;
       
       var dist= res.rows[0].elements[0].distance.text;
         var distance ;
          var time ;
      if(dist.includes("km")) {
      distance=dist.replace("km","").replace(",","");
      time = (distance*60)/30;
      hr =  parseInt((time/60));
      min= parseInt((time%60));
      if(min<10){
      	min = '0' + min;
      }
     }
     else if(dist.includes("m")) {
         distance=dist.replace("m","").replace(",","");
         distance=distance/1000;
      time = (distance*60)/30;
      hr =  parseInt((time/60));
      min= parseInt((time%60));
      if(min<10){
      	min = '0' + min;
      }
      dist=distance+"km";
     }
     if(currentTouchpt.id=='locationDestinationComboId'){
     Ext.getCmp('destinationDistanceId').setValue(distance);
     Ext.getCmp('destinationTimeId').setValue(hr+':'+min);
     //******tottal distance and time**************
     var tpDist=0;
     var desDist=0;
     var totalDist=0;
     var totalTime=0;
     var totalHr = 0;
     var totalmin=0;
     for(var j=1;j<=10;j++){
     var tp = parseFloat(Ext.getCmp('touchPointDistanceId'+j).getValue().replace("km","").replace(",","").replace("m",""));
     	if(Ext.getCmp('touchPointDistanceId'+j).getValue()==""){
     		break;
     	}
     	tpDist = tpDist + tp;
     }
     desDist = parseFloat(Ext.getCmp('destinationDistanceId').getValue().replace("km","").replace(",","").replace("m",""));
     totalDist = tpDist + desDist;
     totalTime = (totalDist*60)/30;
     totalHr =  parseInt((totalTime/60));
     totalmin= parseInt((totalTime%60));
     if(totalmin<10){
      	totalmin = '0' + totalmin;
      }
     Ext.getCmp('distTextId').setValue(totalDist.toFixed(2));
     Ext.getCmp('attTextId').setValue(totalHr+':'+totalmin);
     }
     else{
     Ext.getCmp('touchPointDistanceId'+touchPointId).setValue(distance);
     Ext.getCmp('touchPointTimeId'+touchPointId).setValue(hr+':'+min);
     //   resetId = 'touchPointDistanceId'+touchPointId;
     }
    } else {
        Ext.example.msg("No Distance Found For Given Location");
        if(resetId=='locationDestinationComboId'){
        Ext.getCmp('locationDestinationComboId').reset();
        Ext.getCmp('destinationTimeId').reset();
        Ext.getCmp('destinationDistanceId').reset();
        Ext.getCmp('attTextId').reset();
	    Ext.getCmp('distTextId').reset();
        }
        else{
        Ext.getCmp('touchPointDistanceId'+touchPointId).reset();
        Ext.getCmp('touchPointTimeId'+touchPointId).reset();
        Ext.getCmp('touchPointcomboId'+touchPointId).reset();
        if(resetId == 'touchPointcomboId1'){
        	lasttouchId = 'locationSourceComboId';
	        var lastrec=setLatLong(Ext.getCmp('locationSourceComboId'));
       		lastTouchPointLat=lastrec.data['Latitude'];
	  		lastTouchPointLong=lastrec.data['Longitude'];
        }else{
        lasttouchId ='touchPointcomboId'+(touchPointId-1);
        var lastrec=setLatLong(Ext.getCmp('touchPointcomboId'+(touchPointId-1)));
        lastTouchPointLat=lastrec.data['Latitude'];
	    lastTouchPointLong=lastrec.data['Longitude'];
	    }
        }
        
    }
}
}

//**************************customer combo***************************
	var customercombostore = new Ext.data.JsonStore({
      url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
      id: 'CustomerStoreId',
      root: 'CustomerRoot',
      autoLoad: true,
      remoteSort: true,
      fields: ['CustId', 'CustName'],
      listeners: {
          load: function (custstore, records, success, options) {
              if ( <%= customerId %> > 0) {
                  Ext.getCmp('custcomboId').setValue('<%=customerId%>');
                  custId = Ext.getCmp('custcomboId').getValue();
                  custName = Ext.getCmp('custcomboId').getRawValue();
                  
                  locationStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
                  vehicleStore.load({
                       params: {
                           CustId: Ext.getCmp('custcomboId').getValue()
                       }
                   });
              }
          }
      }
  });

  var custnamecombo = new Ext.form.ComboBox({
      store: customercombostore,
      id: 'custcomboId',
      mode: 'local',
      forceSelection: true,
      emptyText: '<%=SelectCustomerName%>',
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
                   summaryGrid.store.clearData();
  		           summaryGrid.view.refresh();
              }
          }
      }
  });	
  
 //***************** Location combo **************************		
	var locationStore= new Ext.data.JsonStore({
	   url:'<%=request.getContextPath()%>/StoppageReportAction.do?param=getLocation',
       root: 'locationroot',
       autoLoad: true,
	   fields: ['HubName','Longitude','Latitude','HubId']
	   
     });
	 
	var locationSourceCombo = new Ext.form.ComboBox({
        store: locationStore,
        id: 'locationSourceComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Location',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'HubId',
        displayField: 'HubName',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	            if (Ext.getCmp('amazonTripId').getValue().trim() == ""|| Ext.getCmp('amazonTripId').getValue() == null) {
                    Ext.example.msg("Enter Shipment Id");
                    this.reset();
                        return;
                    }
                    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
                    Ext.example.msg("Select Vehicle No For Trip");
                    this.reset();
                        return;
                    }
	            	
	            	if(Ext.getCmp('touchPointcomboId1').getValue()==this.getValue()){
	            		Ext.example.msg("Two Locations cannot be same");
                    	this.reset();
                        return;
	            		}
	            	setLatLong(this);
	            	for(var p=1;p<=10;p++){
	            	Ext.getCmp('touchPointcomboId'+p).reset();
	            	Ext.getCmp('touchPointDistanceId'+p).reset();
	            	Ext.getCmp('touchPointTimeId'+p).reset();
	            	}
	            	Ext.getCmp('locationDestinationComboId').reset();
	            	Ext.getCmp('destinationTimeId').reset();
	            	Ext.getCmp('destinationDistanceId').reset();
	            	Ext.getCmp('attTextId').reset();
	            	Ext.getCmp('distTextId').reset();
	            }
	        },
	        change:{
	        	fn: function() {
	        		if(this.getValue()==null || this.getValue()==""){
	        		for(var p=1;p<=10;p++){
	            	Ext.getCmp('touchPointcomboId'+p).reset();
	            	Ext.getCmp('touchPointDistanceId'+p).reset();
	            	Ext.getCmp('touchPointTimeId'+p).reset();
	            	}
	            	
	            	Ext.getCmp('locationDestinationComboId').reset();
	            	Ext.getCmp('destinationTimeId').reset();
	            	Ext.getCmp('destinationDistanceId').reset();
	            	Ext.getCmp('attTextId').reset();
	            	Ext.getCmp('distTextId').reset();
	        		}
	        	}
	        }
	    }
	});	
	//************Touch point combos from 1 to 10***********
	for(var i=1;i<=10;i++){
		touchPointCombos[i] = new Ext.form.ComboBox({
        store: locationStore,
        id: 'touchPointcomboId'+i,
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Location',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'HubId',
        displayField: 'HubName',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	            if (Ext.getCmp('amazonTripId').getValue().trim() == "") {
                    Ext.example.msg("Enter Shipment Id");
                    this.reset();
                        return;
                    }
                    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
                    Ext.example.msg("Select Vehicle No For Trip");
                    this.reset();
                        return; 
                    }
	            var sourceLoc = Ext.getCmp('locationSourceComboId').getValue();
	            if(Ext.getCmp('locationSourceComboId').getValue()=="")
	            {
	            Ext.example.msg("Select Source Point");
                this.reset();
                return;
	            }
	            var x=parseInt(this.id.substring(17,this.id.length));
	           if(x>1){
	           	if( Ext.getCmp('touchPointTimeId'+(x-1)).getValue()==  ""){
	         	Ext.example.msg("No ETA is captured for previous touch point please select it again");
                    this.reset();
                    if(x>2){
                    var lastrec=setLatLong(Ext.getCmp('touchPointcomboId'+(x-2)));
       					lastTouchPointLat=lastrec.data['Latitude'];
	  					lastTouchPointLong=lastrec.data['Longitude'];
	  					}
	  					else {
	  					 var lastrec=setLatLong(Ext.getCmp('locationSourceComboId'));
       					lastTouchPointLat=lastrec.data['Latitude'];
	  					lastTouchPointLong=lastrec.data['Longitude'];
	  					}
                    Ext.getCmp('touchPointcomboId'+lasttouchPoint).reset();
                    Ext.getCmp('touchPointcomboId'+lasttouchPoint).focus();
                    lasttouchPoint= (x-2);
                        return;
	         	}
	         	}
	            if (x>1 && Ext.getCmp('touchPointcomboId'+(x-1)).getValue() == "" ) {
                    Ext.example.msg("Select Previous Touch Point ");
                    this.reset();
                        return;
                    }
                   
	            	if(x>1 && Ext.getCmp('touchPointcomboId'+(x-1)).getValue() == this.getValue() || Ext.getCmp('touchPointcomboId1').getValue() == sourceLoc){	
	            		Ext.example.msg("Two Consecutive Locations cannot be same");
                   	this.reset();
                    	for(var p=x;p<=10;p++){
	            	Ext.getCmp('touchPointcomboId'+p).reset();
	            	Ext.getCmp('touchPointDistanceId'+p).reset();
	            	Ext.getCmp('touchPointTimeId'+p).reset();
	            	}
	            	Ext.getCmp('locationDestinationComboId').reset();
	            	Ext.getCmp('destinationTimeId').reset();
	            	Ext.getCmp('destinationDistanceId').reset();
	            	Ext.getCmp('attTextId').reset();
	            	Ext.getCmp('distTextId').reset();
                        return;
	            	}
	            
	             for(var p=x+1;p<=10;p++){
	            	Ext.getCmp('touchPointcomboId'+p).reset();
	            	Ext.getCmp('touchPointDistanceId'+p).reset();
	            	Ext.getCmp('touchPointTimeId'+p).reset();
	            	}
	            	Ext.getCmp('locationDestinationComboId').reset();
	            	Ext.getCmp('destinationTimeId').reset();
	            	Ext.getCmp('destinationDistanceId').reset();
	            	Ext.getCmp('attTextId').reset();
	            	Ext.getCmp('distTextId').reset();
	            	
	            if(x==1){
	              setLatLong1(this,'locationSourceComboId',x);
	              lasttouchId= this.id;
	              }
	              else{
	              setLatLong1(this,'touchPointcomboId'+(x-1),x);
	              lasttouchId= this.id;
	              }
	              lasttouchPoint = x;
	            }
	        },
	        change:{
	        	fn: function() {
	        	var x=parseInt(this.id.substring(17,this.id.length));
	        		if(this.getValue()==null || this.getValue()==""){
	        		if(x==1){
	            		lasttouchId = 'locationSourceComboId';
	            		var lastrec=setLatLong(Ext.getCmp('locationSourceComboId'));
       					lastTouchPointLat=lastrec.data['Latitude'];
	  					lastTouchPointLong=lastrec.data['Longitude'];
	            	}else{
	            		lasttouchId ='touchPointcomboId'+(x-1);
       					var lastrec=setLatLong(Ext.getCmp('touchPointcomboId'+(x-1)));
       					lastTouchPointLat=lastrec.data['Latitude'];
	  					lastTouchPointLong=lastrec.data['Longitude'];
	  				}
	        		for(var p=x;p<=10;p++){
	            	Ext.getCmp('touchPointcomboId'+p).reset();
	            	Ext.getCmp('touchPointDistanceId'+p).reset();
	            	Ext.getCmp('touchPointTimeId'+p).reset();
	            	}
	            	
	            	Ext.getCmp('locationDestinationComboId').reset();
	            	Ext.getCmp('destinationTimeId').reset();
	            	Ext.getCmp('destinationDistanceId').reset();
	            	Ext.getCmp('attTextId').reset();
	            	Ext.getCmp('distTextId').reset();
	        		}
	        	}
	        }
	    }
	});
	}
	
	var locationDestinationCombo = new Ext.form.ComboBox({
        store: locationStore,
        id: 'locationDestinationComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Location',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'HubId',
        displayField: 'HubName',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	            
	              if(Ext.getCmp('touchPointcomboId1').getValue()!="" &&  Ext.getCmp('touchPointTimeId'+lasttouchPoint).getValue()==""){
	         	Ext.example.msg("No ETA is captured for previous touch point please select it again");
                    this.reset();
                       if(lasttouchPoint>1){
                    var lastrec=setLatLong(Ext.getCmp('touchPointcomboId'+(parseInt(lasttouchPoint)-1)));
       					lastTouchPointLat=lastrec.data['Latitude'];
	  					lastTouchPointLong=lastrec.data['Longitude'];
	  					}
	  					else {
	  					 var lastrec=setLatLong(Ext.getCmp('locationSourceComboId'));
       					lastTouchPointLat=lastrec.data['Latitude'];
	  					lastTouchPointLong=lastrec.data['Longitude'];
	  					}
                    Ext.getCmp('touchPointcomboId'+lasttouchPoint).reset();
                    Ext.getCmp('touchPointcomboId'+lasttouchPoint).focus();
                    lasttouchPoint = parseInt(lasttouchPoint)-1;
                        return;
	         	}
	         	
	            if (Ext.getCmp('amazonTripId').getValue().trim() == "") {
                    Ext.example.msg("Enter Shipment Id");
                    this.reset();
                        return;
                    }
                    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
                    Ext.example.msg("Select Vehicle No For Trip");
                    this.reset();
                        return;
                    }
                    if(Ext.getCmp('locationSourceComboId').getValue()==""){
	            	Ext.example.msg("Select Source Point");
                	this.reset(); 
                	return;
	            	}
                  if(Ext.getCmp('touchPointcomboId1').getValue()==""){
                  lasttouchId='locationSourceComboId';
                  }
	              setLatLong1(this,lasttouchId,0);
	            }
	        },
	        change:{
	        	fn: function() {
	        		if(this.getValue()==null || this.getValue()==""){
	            	this.reset();
	            	Ext.getCmp('destinationTimeId').reset();
	            	Ext.getCmp('destinationDistanceId').reset();
	            	Ext.getCmp('attTextId').reset();
	            	Ext.getCmp('distTextId').reset();
	        		}
	        	}
	        }
	    }
	});
//***************** vehicle combo **************************		
	var vehicleStore= new Ext.data.JsonStore({
	   url:'<%=request.getContextPath()%>/StoppageReportAction.do?param=getVehicleNo',
       root: 'vehicleroot',
       autoLoad: true,
	   fields: ['vehicleNoName','groupId','driverName','mobileNo']
	   
     });
	 
	var vehiclecombo = new Ext.form.ComboBox({
        store: vehicleStore,
        id: 'vehiclecomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectVehicle%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'vehicleNoName',
        displayField: 'vehicleNoName',
        cls: 'selectstylePerfect',
        loadingText: 'Searching...',
	    enableKeyEvents: true,
	    minChars: 2,
	    listeners: {
	        select: {
	            fn: function() {
	            }
	        }
	    }
	});
	
	//**************************** innerPanel ***********************************************		
	var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'innerPanelId',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 10
        },
        items: [{width:30},
        		{
                	xtype: 'label',
                 	text: 'Customer Name' + ' :',
                 	cls: 'labelstyle',
                 	id: 'customerlab'
               
            	},
            	{width:10},
            	custnamecombo,
     			{width:85},
			    { 
			    	xtype:'button',
			    	text:'View',
			    	id: 'addbuttonid',
			    	width:80,
			    	hidden:false,
			    	listeners: 
	       			{
		        		click:
		        		{
			       			fn:function()
			       			{
			       				if(Ext.getCmp('custcomboId').getValue() == "" )
							    {
						                 Ext.example.msg("<%=SelectCustomerName%>");
						                 Ext.getCmp('custcomboId').focus();
				                      	 return;
							    }
							    
							   Store.load({
				                        params: {
				                        	jspName:jspName,
				                            CustId: Ext.getCmp('custcomboId').getValue(),
				                            CustName: Ext.getCmp('custcomboId').getRawValue()
				                            
                       				}
				                });
				                locationStore.load({
                       					params: {
                           					CustId: Ext.getCmp('custcomboId').getValue()
                      				 }
                   				});
                  				vehicleStore.load({
                       					params: {
                           					CustId: Ext.getCmp('custcomboId').getValue()
                       				}
                   				});

			       			}
	       				}
       				}
			    }	
        	]
   		 }); // End of innerPanel
   
 		
  var innerPanelForVehicleDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 400,
    width: 680,
    frame: false,
    id: 'innerPanelForVehicleDetailsId',
    layout: 'table',
    layoutConfig: {
        columns: 7
    },
    items: [{
        xtype: 'fieldset',
        title: titelForInnerPanel,
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 4,
        id: 'NewRecordId',
        width: 660,
        layout: 'table',
        layoutConfig: {
            columns: 7
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'amazonmandatoryfield'
        },{
            xtype: 'label',
            text: 'Shipment Id' + ' :',
            cls: 'labelstyle',
            id: 'amazonLabelId'
        },{
            xtype: 'textfield',
            maskRe: /[A-Za-z0-9]/,
            regex:/[A-Za-z0-9]/,
            emptyText:'Enter Shipment Id',
            cls: 'selectstylePerfect',
            id: 'amazonTripId',
            listeners: {
                change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
		},
        {},{
        	xtype: 'label',
            text: 'Driver Name' + ' :',
            cls: 'labelstyle',
            id: 'driverLabId'
      	},{
      		xtype: 'textfield',
      		maskRe: /[A-Za-z0-9]/,
            regex:/[A-Za-z0-9]/,
            emptyText:'Enter Driver Name',
            cls: 'selectstylePerfect',
            id: 'driverLabValId'
        },{},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryfield'
        },{
            xtype: 'label',
            text: 'Select Vehicle' + ' :',
            cls: 'labelstyle',
            id: 'vehicleNoLabelId'
        },vehiclecombo,
        {},{
        	xtype: 'label',
            text: 'Mobile No' + ' :',
            cls: 'labelstyle',
            id: 'mobileLabId'
        },{
        	xtype: 'textfield',
        	maskRe: /[0-9]/,
            regex:/[0-9]/,
            enforceMaxLength :true,
            emptyText:'Enter Mobile No',
            cls: 'selectstylePerfect',
            id: 'mobileLabValId',
            autoCreate: {//restricts mobile no to 10 chars max, 
                   tag: "input",
                   maxlength: 10,
                   type: "text",
                   size: "10",
                   autocomplete: "off"
               },
         },{},
        {
        	xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatorytimefield'
          },{
        	xtype: 'label',
			text : 'Trip Start Date' + ' :',
			cls: 'labelstyle',
			id: 'datelab',
			width:60
        },{
        	xtype: 'datefield',
  		    cls: 'selectstylePerfect',
  		    width: 185,
  		    format: getDateTimeFormat(),
  		    emptyText: 'Select Date',
            allowBlank: false,
            blankText: 'Select Date',
            id: 'dateId',
            value: dtcur,
            vtype: 'daterange',
            //maxValue: dtnxt,
            listeners: {
     			select: {
         			fn: function() {
             			
         				}
     				}
 				}
        },{width:25},{},{},{height:40},
        {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatorysourcefield'
        },{
            xtype: 'label',
            text: 'Source/Origin' + ' :',
            cls: 'labelstyle',
            id: 'sourceLabelId'
        },locationSourceCombo,{},{
        	xtype: 'label',
            text:'Approx Transit Time(hh:mm)',
            cls: 'labelstyle',
            id: 'approxTimeId'
        },{
        	xtype: 'label',
            text:'Distance (Kms)',
            cls: 'labelstyle',
            id: 'distanceTxtId'	
        },{height:40},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryfield1'
        },{
            xtype: 'label',
            text: 'Touch Point1' + ' :',
            cls: 'labelstyle',
            id: 'touchPoint1LabId'
        },touchPointCombos[1],{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointTimeId1',
            readOnly:true  
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointDistanceId1',
            readOnly:true   
		},{},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryfield2'
        },{
            xtype: 'label',
            text: 'Touch Point2' + ' :',
            cls: 'labelstyle',
            id: 'touchPoint2LabId'
        },touchPointCombos[2],{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointTimeId2',
            readOnly:true   
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointDistanceId2',
            readOnly:true  
		},{},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryfield3'
        },{
            xtype: 'label',
            text: 'Touch Point3' + ' :',
            cls: 'labelstyle',
            id: 'touchPoint3LabId'
        },touchPointCombos[3],{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointTimeId3',
            readOnly:true  
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointDistanceId3',
            readOnly:true   
		},{},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryfield4'
        },{
            xtype: 'label',
            text: 'Touch Point4' + ' :',
            cls: 'labelstyle',
            id: 'touchPoint4LabId'
        },touchPointCombos[4],{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointTimeId4',
            readOnly:true 
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointDistanceId4',
            readOnly:true   
		},{},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryfield5'
        },{
            xtype: 'label',
            text: 'Touch Point5' + ' :',
            cls: 'labelstyle',
            id: 'touchPoint5LabId'
        },touchPointCombos[5],{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointTimeId5',
            readOnly:true  
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointDistanceId5',
            readOnly:true 
		},{},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryfield6'
        },{
            xtype: 'label',
            text: 'Touch Point6' + ' :',
            cls: 'labelstyle',
            id: 'touchPoint6LabId'
        },touchPointCombos[6],{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointTimeId6',
            readOnly:true 
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointDistanceId6',
            readOnly:true
		},{},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryfield7'
        },{
            xtype: 'label',
            text: 'Touch Point7' + ' :',
            cls: 'labelstyle',
            id: 'touchPoint7LabId'
        },touchPointCombos[7],{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointTimeId7',
            readOnly:true   
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointDistanceId7',
            readOnly:true
		},{},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryfield8'
        },{
            xtype: 'label',
            text: 'Touch Point8' + ' :',
            cls: 'labelstyle',
            id: 'touchPoint8LabId'
        },touchPointCombos[8],{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointTimeId8',
            readOnly:true   
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointDistanceId8',
            readOnly:true
		},{},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryfield9'
        },{
            xtype: 'label',
            text: 'Touch Point9' + ' :',
            cls: 'labelstyle',
            id: 'touchPoint9LabId'
        },touchPointCombos[9],{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointTimeId9',
            readOnly:true  
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointDistanceId9',
            readOnly:true   
		},{},{
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'mandatoryfield10'
        },{
            xtype: 'label',
            text: 'Touch Point10' + ' :',
            cls: 'labelstyle',
            id: 'touchPoint10LabId'
        },touchPointCombos[10],{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointTimeId10',
            readOnly:true   
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'touchPointDistanceId10',
            readOnly:true   
		},{height:40},{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mandatoryfield11'
        },{
            xtype: 'label',
            text: 'Destination' + ' :',
            cls: 'labelstyle',
            id: 'destinationLabId'
        },locationDestinationCombo,{},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'destinationTimeId',
            readOnly:true   
		},{
            xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'destinationDistanceId',
            readOnly:true   
		},{height:30},
		{},{},{
			xtype: 'label',
            text: 'Total' + ' :',
            cls: 'labelstyle',
            id:'totalAttDistanceLabel'
           
        },{},
		{
			xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'attTextId',
            readOnly:true 
		},{
			xtype: 'textfield',
            emptyText:'',
            cls: 'selectstylePerfect',
            id: 'distTextId',
            readOnly:true 
		}
    ]
    }]
});	
 	
  var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 50,
    width: 680,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('amazonTripId').getValue().trim() == "") {
                    Ext.example.msg("Enter Shipment Id");
                        return;
                    }
                    var tripno = Ext.getCmp('amazonTripId').getValue();
                    	if(!isValidTripId(tripno))
    					{
       						Ext.example.msg("Invalid Shipment Id");
        					return;
    					}
                    if (Ext.getCmp('vehiclecomboId').getValue() == "") {
                    Ext.example.msg("Select Vehicle No For Trip");
                        return;
                    }
                    if (Ext.getCmp('dateId').getValue() == "") {
                    Ext.example.msg("Select Trip Start Date");
                        return;
                    }
                    if (Ext.getCmp('locationSourceComboId').getValue() == "") {
                    Ext.example.msg("Select Source Location");
                        return;
                    }
                    if (Ext.getCmp('locationDestinationComboId').getValue() == "") {
                    Ext.example.msg("Select Destination Location");
                        return;
                    }
                   
                     if (Ext.getCmp('locationDestinationComboId').getValue() == Ext.getCmp('locationSourceComboId').getValue() && Ext.getCmp('touchPointcomboId1').getValue() =="" ) {
                    Ext.example.msg("Select atleast one Touch point or Select different destination");
                       return;
                    	}
               		
               		if (Ext.getCmp('locationDestinationComboId').getValue() == Ext.getCmp(lasttouchId).getValue() )  {
                    Ext.example.msg("Destination Location and Last Touch Point Location Cannot Be Same");
                        return;
                    }
                   
                    var touchPointCombo= [];
                    var touchPointDistance=[];
                    var touchPointTime=[];
								for(var i=1;i<=10;i++){
									touchPointCombo[i] =Ext.getCmp('touchPointcomboId'+i).getValue();
									touchPointDistance[i] =Ext.getCmp('touchPointDistanceId'+i).getValue();
									touchPointTime[i] =Ext.getCmp('touchPointTimeId'+i).getValue().replace(":",".");
								}
					var s1 = Ext.getCmp('locationSourceComboId').getRawValue();
					var d1 = Ext.getCmp('locationDestinationComboId').getRawValue();
					routeName = s1.substring(0, s1.indexOf(",")).toUpperCase()+" - "+ d1.substring(0, d1.indexOf(",")).toUpperCase();
					OuterPanelWindow.getEl().mask();
                    Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/StoppageReportAction.do?param=AddTripGeneration',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustId: Ext.getCmp('custcomboId').getValue(),
                                amazonTripId: Ext.getCmp('amazonTripId').getValue(),
                                VehicleNo: Ext.getCmp('vehiclecomboId').getValue(),
                                sourceLocation: Ext.getCmp('locationSourceComboId').getValue(),
                                destinationLocation: Ext.getCmp('locationDestinationComboId').getValue(),
								destinationTime: Ext.getCmp('destinationTimeId').getValue().replace(":","."),
								destinationDistance: Ext.getCmp('destinationDistanceId').getValue(),
								touchPointCombo: touchPointCombo,
								touchPointDistance: touchPointDistance,
								touchPointTime: touchPointTime,
								driverName:Ext.getCmp('driverLabValId').getValue(),
								mobileNo:Ext.getCmp('mobileLabValId').getValue(),
								dateId:Ext.getCmp('dateId').getValue(),
								routeName: routeName,
								totalTime:Ext.getCmp('attTextId').getValue(),
								totalDistance:Ext.getCmp('distTextId').getValue()
								
                            },
                            success: function(response, options) {
                                var message = response.responseText;
                                 Ext.example.msg(message);
                               
								Ext.getCmp('amazonTripId').reset();
								Ext.getCmp('vehiclecomboId').reset();
								Ext.getCmp('locationSourceComboId').reset();
								Ext.getCmp('locationDestinationComboId').reset();
								Ext.getCmp('destinationTimeId').reset();
								Ext.getCmp('destinationDistanceId').reset();
								for(var i=1;i<=10;i++){
									Ext.getCmp('touchPointcomboId'+i).reset();
									Ext.getCmp('touchPointDistanceId'+i).reset();
									Ext.getCmp('touchPointTimeId'+i).reset();
								}
								Ext.getCmp('driverLabValId').reset();
								Ext.getCmp('mobileLabValId').reset();
								Ext.getCmp('attTextId').reset();
								Ext.getCmp('distTextId').reset();
                                myWin.hide();
                                OuterPanelWindow.getEl().unmask();
                                Store.load({
                                    params: {
                                    	jspName:jspName,
                                        CustId: Ext.getCmp('custcomboId').getValue(),
                                        CustName: Ext.getCmp('custcomboId').getRawValue()
                                    }
                                });
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
 	
var OuterPanelWindow = new Ext.Panel({
    width: 700,
    height: 480,
    autoScroll: false,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForVehicleDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 500,
    width: 700,
    id: 'myWin',
    items: [OuterPanelWindow]
});

function addRecord() {
    buttonValue = '<%=Add%>';
    titelForInnerPanel = 'Add Details';
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
	
	Ext.getCmp('amazonTripId').reset();
	Ext.getCmp('vehiclecomboId').reset();
	Ext.getCmp('locationSourceComboId').reset();
	Ext.getCmp('locationDestinationComboId').reset();
	Ext.getCmp('destinationTimeId').reset();
	Ext.getCmp('destinationDistanceId').reset();
	for(var i=1;i<=10;i++){
		Ext.getCmp('touchPointcomboId'+i).reset();
		Ext.getCmp('touchPointDistanceId'+i).reset();
		Ext.getCmp('touchPointTimeId'+i).reset();
	}
	Ext.getCmp('driverLabValId').reset();
	Ext.getCmp('mobileLabValId').reset();
	Ext.getCmp('attTextId').reset();
    Ext.getCmp('distTextId').reset();
} 	
 	
//============================ Grid table creation ================================
		//********** reader *************
     	var reader = new Ext.data.JsonReader({
        idProperty: 'darreaderid',
        root: 'TripGenerationRoot',
        totalProperty: 'total',
        fields: [{
        	name: 'slnoIndex'
        },{ 
        	name: 'vehicleNoIndex'
        },{
            name: 'amazonTripIndex'
        },{
            name: 'TripStartDateIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        },{
            name: 'totalPlannedDistanceIndex'
        },{
            name: 'totalplannedDateIndex'
        },{
            name: 'routeNameIndex'
        },{
            name: 'addedByIndex'
        },{
            name: 'addedDateIndex',
            type: 'date',
  		    dateFormat: getDateTimeFormat()
        }]
    });
		//********** store *****************
		var Store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
           	url: '<%=request.getContextPath()%>/StoppageReportAction.do?param=getTripGenerationDetails',
            method: 'POST'
        }),
        remoteSort: false,
        storeId: 'darstore',
        reader: reader
    	});
    	
		//*********** filters **********
		var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        },{
            type: 'numeric',
            dataIndex: 'idIndex'
        },{
            type: 'string',
            dataIndex: 'vehicleNoIndex'
        },{
            type: 'string',
            dataIndex: 'amazonTripIndex'
        },{
            type: 'date',
            dataIndex: 'TripStartDateIndex'
        }, {
            type: 'string',
            dataIndex: 'totalPlannedDistanceIndex'
        }, {
            type: 'string',
            dataIndex: 'totalplannedDateIndex'
        }, {
            type: 'String',
            dataIndex: 'routeNameIndex'
        }, {
            type: 'String',
            dataIndex: 'addedByIndex'
        }, {
            type: 'date',
            dataIndex: 'addedDateIndex'
        }]
      });
		
		//************************************Column Model Config******************************************
    	var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }),{
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;>Vehicle No</span>",
                dataIndex: 'vehicleNoIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Shipment Id</span>",
                dataIndex: 'amazonTripIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
        		header: "<span style=font-weight:bold;>Trip Start Date Time</span>",
           	 	dataIndex: 'TripStartDateIndex',
            	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            	filter: {
            	type: 'date'
            	}
        	},{
                header: "<span style=font-weight:bold;>Total Planned Distance (Kms)</span>",
                dataIndex: 'totalPlannedDistanceIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
        		header: "<span style=font-weight:bold;>Total Planned Duration (HH:MM)</span>",
           	 	dataIndex: 'totalplannedDateIndex',
            	filter: {
            	type: 'string'
            	}
        	},{
                header: "<span style=font-weight:bold;>Route Name</span>",
                dataIndex: 'routeNameIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>Inserted By</span>",
                dataIndex: 'addedByIndex',
                width: 100,
                filter: {
                    type: 'string'
                }
            },{
        		header: "<span style=font-weight:bold;>Inserted Date Time</span>",
           	 	dataIndex: 'addedDateIndex',
            	renderer: Ext.util.Format.dateRenderer(getDateTimeFormat()),
            	filter: {
            	type: 'date'
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

	//***************** getGrid ****************************
summaryGrid = getGrid('', '<%=NoRecordsFound%>', Store, screen.width - 40, 450, 15, filters, '<%=ClearFilterData%>', false, '', 16, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', false, '<%=Modify%>', false, '<%=Delete%>');

	//*********************main starts from here*************************
 	Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			title:'Trip Generation',
			renderTo : 'content',
			standardSubmit: true,
			frame:true,
			cls:'outerpanel',
			border:false,
			items: [innerPanel,summaryGrid]  
			//bbar:ctsb			
			}); 
			
	});   
   
    </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->