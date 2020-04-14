<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
    StringBuffer hrlist=cf.getExtList(0,24);
    StringBuffer minlist=cf.getExtList(0,60);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Customers_Information");
tobeConverted.add("Product_Features");
tobeConverted.add("Customization");
tobeConverted.add("User_Management");
tobeConverted.add("User_Feature_Detachment");
tobeConverted.add("Asset_Group");
tobeConverted.add("Asset_Group_Features"); 
tobeConverted.add("User_Role"); 

ArrayList<String> convertedWords=new ArrayList<String>();
String language=loginInfo.getLanguage();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String customerInformation=convertedWords.get(0);
String productFeatures=convertedWords.get(1);
String customization=convertedWords.get(2);
String userManagement=convertedWords.get(3);
String userFeatureDetachment=convertedWords.get(4);
String assetGroup=convertedWords.get(5);
String assetGroupFeatures=convertedWords.get(6);	
String UserRole=convertedWords.get(7);
%>
<jsp:include page="../Common/header.jsp" />
<title>ILMS MDP Integration</title>
<style>
.x-tab-panel-header{
border: 0px solid !important;
padding-bottom: 0px !important;
}
.x-panel-tl
{
border-bottom: 0px solid !important;
}
</style>

<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/SandMiningMenuTabJS.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/MenuTabJS.jsp"/>
<%} %>
     
 <script>
    var adminTab;
    var latitude="";
    var longitude="";
    var source="";
    var arr=[];
    var List="";
    var distance1="";
    var destination1="";
    var TSGrid;
    var dump="";
    var dist="";
    var speednew;
 	var buffertime="";
 	var dbDate;
 	var portname="";
 	var globalClientId = '<%=customerId%>';
 	var speed1=30;
	var validFromDate11="";
	var validToDate11="";
	var destLat="";
	var destLng="";
	var hourId = "";
	var validToHours = "";
	var validToMinutes = "";
	
	var storeHrs = [<%=hrlist%>];
	var storeMin = [<%=minlist%>];
 	function getList(){
    
    	return 'ILMSMDPGeneratorTab';  
    }
  function test3(lat,lon,loc) {
    source=loc;
    latitude=lat;
    longitude=lon;
  }
  function test1() {
    arr[0]=latitude;
    arr[1]=longitude;
    arr[2]=source;
    return arr;
  }
  
  var validToHHCombo = new Ext.form.ComboBox({ // 9876
     			  frame:true,
				  store: storeHrs,
				  id:'validToHHComboId',
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
	        	  emptyText:'0',
	        	  value:0,
		});
		var validToMMCombo = new Ext.form.ComboBox({
     			  frame:true,
				  store: storeMin,
				  id:'validToMMComboId',
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
	        	  emptyText:'0',
	        	  value:0,
		});
			var endTime = new Ext.Panel({
			    			layout:'table',
			    			id:'endTimeId',
			    			layoutConfig: {
			       					columns: 6
			    			},
			    			items: [{
			    				  xtype : 'label',
			                     width : 60,
			        			 text: 'HRMIN',
			        			 cls: 'myStyle' 
			    			},validToHHCombo,{
			                     xtype : 'label',
			        			 width: 0,
			        			 cls: 'myStyle' 
			                },validToMMCombo,{
			                     xtype : 'label',
			        			 width: 5,
			        			 cls: 'myStyle' 
			                },{
			                   
			                }]
			});
// 12345			
  
  var Destination = new Ext.form.TextField({
			cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '',
            emptyText: 'Destination',
            labelSeparator: '',
            readOnly:false,
            id: 'ToPlaceId'
}); 
var distancecombo = new Ext.form.NumberField({
			cls: 'selectstylePerfect',
            allowBlank: false,
            allowNegative: false,
            blankText: '',
            emptyText: '',
            labelSeparator: '',
             autoCreate :  { //restricts user to 6 chars max, cannot enter 7th char
             tag: "input", 
             maxlength : 6, 
             type: "text", 
             maskRe: /[0-9]/,
             size: "6", 
             autocomplete: "off"},
            readOnly: false,
            id: 'distanceHoursId',
          //  maxLength : 3,
             listeners: {
    			change: function(){
    			  var dist=Ext.getCmp('distanceHoursId').getValue();
    			  Ext.getCmp('distanceHoursId').setValue(dist);
    			  var speedperkm=dist/speed1; 
    				speedperkm=speedperkm.toFixed(2);
    			    validFromDate11 = new Date();
				    validToDate11 = new Date(new Date(validFromDate11).getTime() + 60 * 60 * speedperkm * 1000);
				    Ext.getCmp('validToId').setValue(validToDate11);
   				 }
  			}
          
}); 
var validToTime = new Ext.form.DateField({
			 cls: 'selectstylePerfect',
			  format: getDateFormat(), //getDateTimeFormat()
			  allowBlank: false,
			  readOnly: false,
			  emptyText: '',
             // maxValue: myDate, 
			  id: 'validToId'
});
   function mapdetails(destination,destlatitude,destlongitude,distance) {
    
    destination1=destination;
    destlatitude=destlatitude;
    destlongitude=destlongitude;
    distance1=distance;
    destLat=destlatitude;
    destLng=destlongitude;
    
    Ext.getCmp('ToPlaceId').setValue(destination);
    Ext.getCmp('distanceHoursId').setValue(distance);
    var speedperkm=distance/speed1; 
    speedperkm=speedperkm.toFixed(2);
    validFromDate11 = new Date();
    validToDate11 = new Date(new Date(validFromDate11).getTime() + 60 * 60 * speedperkm * 1000);
   
    validToHours = validToDate11.getHours(); 
    validToHours = validToHours.toString();
    if(validToHours.length == 1) {
    	validToHours = '0' + validToHours;
    }
    
    validToMinutes = validToDate11.getMinutes();
    validToMinutes = validToMinutes.toString();
    if(validToMinutes.length == 1) {
    	validToMinutes = '0' + validToMinutes;
    }
    
    Ext.getCmp('validToId').setValue(validToDate11);
    Ext.getCmp('validToHHComboId').setValue(validToHours);
    Ext.getCmp('validToMMComboId').setValue(validToMinutes);
    }
    
   function mapdetails1(){
    	arr[0]=distance1;
    	arr[1]=destination1;
    	return arr;
    }
    
  
    
    
    
  function BackOption(value)
  {
    
      adminTab.remove(value);
      switch(value)
	    {
		case 0:
		    adminTab.insert(1,{title: 'MDP Map',
            iconCls: 'test',
            id:'MDPTabId',
            html : "<iframe style='width:100%;height:100%;align:center'; src='<%=path%>/Jsps/SandMining/ILMS_MDP_Integration.jsp'></iframe>"});
            Ext.getCmp('MDPTabId').show();
           break;
		case 1:
		    adminTab.insert(2,{title: 'MDP Map',
            iconCls: 'test',
            id:'MDPMaptab',
            html : "<iframe style='width:100%;height:100%;align:center'; src='/jsps/SandMining_jsps/MDPGeneratorMap.jsp'></iframe>"});
            Ext.getCmp('MDPMaptab').show();
            Ext.getCmp('MDPTabId').disable(true);
           break;
   		}
 }
 
 
    
    
    Ext.onReady(function(){
     adminTab = new Ext.TabPanel({
        resizeTabs:true, 
        enableTabScroll:false,
        width:screen.width-20,
        height:555,   
        activeTab: 'MDPTabId',
        layoutOnTabChange: true,
        listeners: {
		tabchange:function(tp, newTab, currentTab){

    }
	},
        defaults: {autoScroll:false}
     });
   
    addTab();
   function addTab(){
        adminTab.add({
            id:'MDPTabId',
            title: 'MDP',
            iconCls: 'test',
            listeners: {
		       show: function(panel) { 
		                  
		        
		         // console.log(Ext.getCmp('ToPlaceId').getValue());
		       }
		   },
           html : "<iframe style='width:102%;height:576px;align:center'; src='<%=path%>/Jsps/SandMining/ILMS_MDP_Integration.jsp'></iframe>"
        }).show();
        
         adminTab.add({
           id:'MDPMaptab',
           title: 'MDP Map',
           iconCls: 'test',
           html : "<iframe style='width:100%;height:100%;align:center'; src='/jsps/SandMining_jsps/MDPGeneratorMap.jsp'></iframe>"
        }).show();
         Ext.getCmp('MDPMaptab').disable(true);
        
         }
   adminTab.render('admindiv'); 
   
   
});		

</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>