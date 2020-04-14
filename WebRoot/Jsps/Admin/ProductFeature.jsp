<%@ page language="java" import="java.util.*,t4u.beans.*,t4u.functions.CommonFunctions,t4u.common.*" pageEncoding="utf-8"%>
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
int SystemId=loginInfo.getSystemId();
int customeridlogged=loginInfo.getCustomerId();
int userId=loginInfo.getUserId();
int CustIdPassed=0;
int GrpIdPassed=0;
boolean showGrp=false;
if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}
if(request.getParameter("GroupId")!=null){
	showGrp=true;
	GrpIdPassed=Integer.parseInt(request.getParameter("GroupId").toString().trim());
}

ArrayList<String> list=new ArrayList<String>();
list.add("Add_On_Pkg");
list.add("Asset_Group_Name");
list.add("Cancel");
list.add("Customer_Name");
list.add("Do_Disassociate");
list.add("Loading_Record_Please_Wait");
list.add("Mand_Package");
list.add("No_Records_Found");
list.add("Package");
list.add("Product_Features");
list.add("Save");
list.add("Saving_Form");
list.add("Select_Asset_Group");
list.add("Select_Customer");
list.add("Vertical_Sol");
list.add("Select_Package");
list.add("Next");
list.add("Disassociate_Process_From_Asset");
list.add("Cannot_Disassociate_Man_Package");
list.add("Cannot_Disassociate_Ess");
list.add("Select_Mandatory");
list.add("Cannot_Disassociate_Vert");
list.add("Select_Verticalized_Solution_Package");
list.add("Check_Group_Vertical");
ArrayList<String> listLangConv=cf.getLanguageSpecificWordForKey(list,language);
String Add_On_Pkg=listLangConv.get(0);
String Asset_Group_Name=listLangConv.get(1);
String Cancel=listLangConv.get(2);
String Customer_Name=listLangConv.get(3);
String Do_Disassociate=listLangConv.get(4);
String Loading_Record_Please_Wait=listLangConv.get(5);
String Mand_Package=listLangConv.get(6);
String No_Records_Found=listLangConv.get(7);
String Package=listLangConv.get(8);
String Product_Features=listLangConv.get(9);
String Save=listLangConv.get(10);
String Saving_Form=listLangConv.get(11);
String Select_Asset_Group=listLangConv.get(12);
String Select_Customer=listLangConv.get(13);
String Vertical_Sol=listLangConv.get(14);
String Select_Package=listLangConv.get(15);
String Next=listLangConv.get(16);
String Disassociating_process_mesg=listLangConv.get(17);
String Cannot_Disassociate_Man_Package=listLangConv.get(18);
String Cannot_Disassociate_Ess=listLangConv.get(19);
String Select_Mandatory=listLangConv.get(20);
String Cannot_Disassociate_All_Vetrical = listLangConv.get(21);
String Select_Verticalized = listLangConv.get(22);
String Select_One_Vertical_Group=listLangConv.get(23);
String userAuthority=cf.getUserAuthority(SystemId,userId);
%>
<head>
<title></title>
<style type="text/css">
  .x-grid3-hd-checker {
	visibility: hidden;
  }
</style>
</head>
<body>
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
  <jsp:include page="../Common/ImportJSSandMining.jsp"/>
  <%}else {%>
  <jsp:include page="../Common/ImportJS.jsp" /><%} %>
  <jsp:include page="../Common/GroupTabJS.jsp" />   
  <script type="text/javascript">
<%
if(showGrp == false && customeridlogged > 0 && loginInfo.getIsLtsp() == -1 && !userAuthority.equalsIgnoreCase("Admin"))
{
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
}
else
{
 
if(showGrp == true && userAuthority.equalsIgnoreCase("User") && customeridlogged > 0)
{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
}
%>  
var outerPanel;
var pageName='Product Feature';
 var uncheckedServices;
 var saveFlagMan=0;
 var saveFlagVer=0;
 var saveFlagAddon=0;
 var globalCustomerID=parent.globalCustomerID;
 var CustIdPassed=<%=CustIdPassed%>;
 var ctsb=new Ext.ux.StatusBar({
            defaultText: 'Ready',
            id: 'basic-statusbar',
         cls:'statusbarfontstyle',
		hasfocus:true
        })



 //product process details store
  var processdetailsstore=new Ext.data.JsonStore({
         url:'<%=request.getContextPath()%>/ProductFeaturesAction.do?param=getProductProcessDetails',
         id:'processDetailsStoreId',
         root:'ProcessDetailsRoot',
         autoLoad:false,
         remoteSort:true,
         fields:['ProductDetails']
  });
    
    //customer process details store
  var customergrpprocessdetailsstore=new Ext.data.JsonStore({
         url:'<%=request.getContextPath()%>/ProductFeaturesAction.do?param=getCustomerGrpProcessDetails',
         id:'customergrpProcessDetailsStoreId',
         root:'CustomerGrpProcessDetailsRoot',
         autoLoad:false,
         remoteSort:true,
         fields:['CustomerGrpProcessDetails']
  });
    
   //This is to get the check box column in grid
	  var smMandatory= new Ext.grid.CheckboxSelectionModel({ 
	  checkOnly: true,
	   header : false
         });
         
   //This is to get the check box column in grid
	  var smVertical= new Ext.grid.CheckboxSelectionModel({ 
	  checkOnly: true,
	   header : false
         });
         
    //This is to get the check box column in grid
	  var smAddOn= new Ext.grid.CheckboxSelectionModel({ 
	  checkOnly: true,
	   header : false
         });
    
     //Reader for a grid,which is called from grid store the root id given here should be unique. 	
	  var readerMandatory = new Ext.data.JsonReader({
		    root      : 'readerMandatorydata',
            fields	  : [
						  {name:'ProcessNameDataIndex', type:'string'},
						  {name:'ProcessIdDataIndex', type:'string'},
						  {name:'ProcessLabelDataIndex', type:'string'}
			            ] 
      });
      
      //Reader for a grid,which is called from grid store the root id given here should be unique. 	
	  var readerVertical = new Ext.data.JsonReader({
		    root      : 'readerVerticaldata',
            fields	  : [
						  {name:'ProcessNameDataIndex', type:'string'},
						  {name:'ProcessIdDataIndex', type:'string'},
						  {name:'ProcessLabelDataIndex', type:'string'}
			            ] 
      });
      
       //Reader for a grid,which is called from grid store the root id given here should be unique. 	
	  var readerAddOn = new Ext.data.JsonReader({
		    root      : 'readerAddOndata',
            fields	  : [
						  {name:'ProcessNameDataIndex', type:'string'},
						  {name:'ProcessIdDataIndex', type:'string'},
						  {name:'ProcessLabelDataIndex', type:'string'}
			            ] 
      });
      
        //product process Mandatory store
  var processMandatorystore=new Ext.data.Store({
         url:'<%=request.getContextPath()%>/ProductFeaturesAction.do?param=getProductMandatoryProcess',
         bufferSize	: 367,
		 reader		: readerMandatory,
		 autoLoad    : true,
		 remoteSort  :true	
  });
   processMandatorystore.on('beforeload',function(store, operation,eOpts){
   			if(<%=showGrp%> && <%=GrpIdPassed%>==0){
   				operation.params={
          	    custId:Ext.getCmp('custmastcomboId').getValue(),group:"true"
          	    };
          	}else if(<%=showGrp%> && <%=GrpIdPassed%>>0){
          	operation.params={
       	    	 custId:CustIdPassed,group:"true"
       	    	};
          	}else{
          	operation.params={
       	    	 custId:CustIdPassed,group:<%=showGrp%>
       	    	};
          	}
	},this);
	
	 processMandatorystore.on('load',function(store, operation,eOpts){
	 if(<%=showGrp%>){
	 customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue(),GrpId:Ext.getCmp('assetgroupcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
   					var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		ind=processMandatoryGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smMandatory.selectRow(ind,true);
	       											} 
       										}
       		}
       		});
       		}else{
       		customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
   					var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		ind=processMandatoryGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smMandatory.selectRow(ind,true);
	       											} 
       										}
       		}
       		});
       		}
	},this);
	

	
   //product process vertical store
  var processVerticalstore=new Ext.data.Store({
         url:'<%=request.getContextPath()%>/ProductFeaturesAction.do?param=getProductVerticalProcess',
         bufferSize	: 367,
		 reader		: readerVertical,
		 autoLoad    : true,
		 remoteSort  :true	
  });
  
  processVerticalstore.on('beforeload',function(store, operation,eOpts){
   			if(<%=showGrp%> && <%=GrpIdPassed%>==0){
   				operation.params={
          	    custId:Ext.getCmp('custmastcomboId').getValue(),group:"true"
          	    };
          	}else if(<%=showGrp%> && <%=GrpIdPassed%>>0){
          	operation.params={
       	    	 custId:CustIdPassed,group:"true"
       	    	};
          	}else{
          	operation.params={
       	    	 custId:CustIdPassed,group:<%=showGrp%>
       	    	};
          	}
	},this);
	
	 processVerticalstore.on('load',function(store, operation,eOpts){
   			 if(<%=showGrp%>){
	 customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue(),GrpId:Ext.getCmp('assetgroupcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
   	 		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		ind=processVerticalGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smVertical.selectRow(ind,true);
	       											} 
       										}
       		}
       		});
       		}else{
       		 customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
   	 		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		ind=processVerticalGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smVertical.selectRow(ind,true);
	       											} 
       										}
       		}
       		});
       		}
	},this);
  
   //product process add-on store
  var processAddOnstore=new Ext.data.Store({
         url:'<%=request.getContextPath()%>/ProductFeaturesAction.do?param=getProductAddOnProcess',
         bufferSize	: 367,
		 reader		: readerAddOn,
		 autoLoad    : true,
		 remoteSort  :true	
  });
      
   processAddOnstore.on('beforeload',function(store, operation,eOpts){
   			if(<%=showGrp%> && <%=GrpIdPassed%>==0){
   				operation.params={
          	    custId:Ext.getCmp('custmastcomboId').getValue(),group:"true"
          	    };
          	}else if(<%=showGrp%> && <%=GrpIdPassed%>>0){
          	operation.params={
       	    	 custId:CustIdPassed,group:"true"
       	    	};
          	}else{
          	operation.params={
       	    	 custId:CustIdPassed,group:<%=showGrp%>
       	    	};
          	}
	},this);
	
	processAddOnstore.on('load',function(store, operation,eOpts){
   			 if(<%=showGrp%>){
	 customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue(),GrpId:Ext.getCmp('assetgroupcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
		                 	    	var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		ind=processAddOnGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smAddOn.selectRow(ind,true);
	       											} 
       										}
       		}
       		});
       		}else{
       		 customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
		                 	    	var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		ind=processAddOnGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smAddOn.selectRow(ind,true);
	       											} 
       										}
       		}
       		});
       		}
	},this);
	
	
      //filter for each column should be defined here.
	var filtersMandatory = new Ext.ux.grid.GridFilters({
	local   : true,
	filters :[
				{dataIndex:'ProcessNameDataIndex', type:'string'},
				{dataIndex:'ProcessIdDataIndex', type:'string'},
				{dataIndex:'ProcessLabelDataIndex', type:'string'}
				
			]
		}); 
		
		//filter for each column should be defined here.
	var filtersVertical = new Ext.ux.grid.GridFilters({
	local   : true,
	filters :[
				{dataIndex:'ProcessNameDataIndex', type:'string'},
				{dataIndex:'ProcessIdDataIndex', type:'string'},
				{dataIndex:'ProcessLabelDataIndex', type:'string'}
				
			]
		}); 
         
        //filter for each column should be defined here.
	var filtersAddOn = new Ext.ux.grid.GridFilters({
	local   : true,
	filters :[
				{dataIndex:'ProcessNameDataIndex', type:'string'},
				{dataIndex:'ProcessIdDataIndex', type:'string'},
				{dataIndex:'ProcessLabelDataIndex', type:'string'}
				
			]
		}); 
	
	//column model to declare columns required in a grid
	var colsMandatory = new Ext.grid.ColumnModel( [smMandatory,
		{ 
		  header:'<b><%=Package%></b>', 
		  menuDisabled:true,
		  sortable: false,
		  width:200,
		  dataIndex: 'ProcessNameDataIndex'
		},
		{ 
		  header:'', 
		  sortable: true, 
		  hidden:true,
		  hideable:false,
		  dataIndex: 'ProcessIdDataIndex'
		},
		{ 
		  header:'', 
		  sortable: true, 
		  hidden:true,
		  hideable:false,
		  dataIndex: 'ProcessLabelDataIndex'
		}
	]);
	//column model to declare columns required in a grid
	var colsVertical = new Ext.grid.ColumnModel( [smVertical,
		{ 
		  header:'<b><%=Package%></b>', 
		  menuDisabled:true,
		  sortable: false,
		  width:200,
		  dataIndex: 'ProcessNameDataIndex'
		},
		{ 
		  header:'', 
		  sortable: true, 
		  hidden:true,
		   hideable:false,
		  dataIndex: 'ProcessIdDataIndex'
		},
		{ 
		  header:'',  
		  sortable: true, 
		  hidden:true,
		  hideable:false,
		  dataIndex: 'ProcessLabelDataIndex'
		}
	]);//column model to declare columns required in a grid
	var colsAddOn = new Ext.grid.ColumnModel( [smAddOn,
		{ 
		  header:'<b><%=Package%></b>', 
		  menuDisabled:true,
		  sortable: false,
		  width:200,
		  dataIndex: 'ProcessNameDataIndex'
		},
		{ 
		  header:'', 
		  sortable: true, 
		  hidden:true,
		   hideable:false,
		  dataIndex: 'ProcessIdDataIndex'
		},
		{ 
		  header:'', 
		  sortable: true, 
		  hidden:true,
		  hideable:false,
		  dataIndex: 'ProcessLabelDataIndex'
		}
	]);
	      
  //grid declaration	
	var processMandatoryGrid = new Ext.grid.GridPanel({
       title		: '<%=Mand_Package%>', 
       id			: 'processMandatoryGrid',
       ds			: processMandatorystore,
       frame		: true,
       cm			: colsMandatory,
	   view 	    : new Ext.grid.GridView({
	   				  autoFit:true,
	                  nearLimit : 3,
                      loadMask : {msg : '<%=Loading_Record_Please_Wait%>'},
         		      emptyText:'<%=No_Records_Found%>' 
			          }),
<!--	   plugins	   : [filtersMandatory],			          -->
       stripeRows  : true,
       width:300,
       height: 320,
       autoScroll  : true,
	   loadMask    : {msg: '<%=Loading_Record_Please_Wait%>'},
       sm          : smMandatory
<!--       ,       tbar		   :-->
<!--					[-->
<!--					{-->
<!--		 			text: '',-->
<!--		 			handler: function()-->
<!--		 			{-->
<!--		 				processMandatoryGrid.filters.clearFilters();-->
<!--					}			-->
<!--					}-->
<!--					]       -->

	}); 
	//grid declaration	
	var processVerticalGrid = new Ext.grid.GridPanel({
       title		: '<%=Vertical_Sol%>', 
       id			: 'processVerticalGrid',
       ds			: processVerticalstore,
       frame		: true,
       cm			: colsVertical,
	   view 	    : new Ext.grid.GridView({
	   				 autoFit:true,
	                  nearLimit : 3,
                      loadMask : {msg : '<%=Loading_Record_Please_Wait%>'},
         		      emptyText:'<%=No_Records_Found%>' 
			          }),
<!--	   plugins	   : [filtersVertical],			          -->
       stripeRows  : true,
       height: 320,
       width:300,
       autoScroll  : true,
	   loadMask    : {msg: '<%=Loading_Record_Please_Wait%>'},
       sm          : smVertical
<!--       ,tbar		   :-->
<!--					[-->
<!--					{-->
<!--		 			text: '',-->
<!--		 			handler: function()-->
<!--		 			{-->
<!--		 				processVerticalGrid.filters.clearFilters();-->
<!--					}			-->
<!--					}-->
<!--					]       -->

	}); 
	//grid declaration	
	var processAddOnGrid = new Ext.grid.GridPanel({
       title		: '<%=Add_On_Pkg%>', 
       id			: 'processAddOnGrid',
       ds			: processAddOnstore,
       frame		: true,
       cm			: colsAddOn,
	   view 	    : new Ext.grid.GridView({
	   				  autoFit:true,
	                  nearLimit : 3,
                      loadMask : {msg : '<%=Loading_Record_Please_Wait%>'},
         		      emptyText:'<%=No_Records_Found%>' 
			          }),
<!--	   plugins	   : [filtersAddOn],			          -->
       stripeRows  : true,
       height	   : 320,
       width:300,
       autoScroll  : true,
	   loadMask    : {msg: '<%=Loading_Record_Please_Wait%>'},
       sm          : smAddOn
<!--       ,tbar		   :-->
<!--					[-->
<!--					{-->
<!--		 			text: '',-->
<!--		 			handler: function()-->
<!--		 			{-->
<!--		 				processAddOnGrid.filters.clearFilters();-->
<!--					}			-->
<!--					}-->
<!--					]       -->

	}); 
    //****************************ProcessMandatoryGrid oncellclick func *****************************************
    processMandatoryGrid.on({
        			"cellclick":{fn: onCellClickForprocessMandatoryGrid },
   					"viewready":{fn:onViewReadyMan}
   				});
   	 function onViewReadyMan(processAddOnGrid, rowIndex, columnIndex, e){  
   	 		saveFlagMan=0;
   	 		if(customergrpprocessdetailsstore.data.items.length>0){
   	 		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		ind=processMandatoryGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smMandatory.selectRow(ind,true);
	       											} 
       										}
       		}
   	 }
   	
   	
   	 function onCellClickForprocessMandatoryGrid(processMandatoryGrid, rowIndex, columnIndex, e){
 
 		saveFlagMan=1;
   	 	var r = processMandatoryGrid.store.getAt(rowIndex);  
   	 		    	 
   		if(columnIndex == processMandatoryGrid.getColumnModel().findColumnIndex('ProcessNameDataIndex')){
   		if(!(smMandatory.isSelected(rowIndex))){
       		smMandatory.selectRow(rowIndex,true);
       	}else{
       		smMandatory.deselectRow(rowIndex,false);
       	}
       	}
       	if(!<%=showGrp%> && !(smMandatory.isSelected(rowIndex))){
	   	 if(customergrpprocessdetailsstore.data.items.length>0){
   	 		var rec=customergrpprocessdetailsstore.getAt(0);
			var details=","+rec.data['CustomerGrpProcessDetails']+",";
			var pro=","+r.data['ProcessIdDataIndex']+",";
			if(details.indexOf(pro) != -1){
   	 		Ext.Msg.show({
										title: '<%=Disassociating_process_mesg%>',
										msg: '<%=Do_Disassociate%>',
										width:450,
										buttons: {
										yes: true,
										no: true
										},
										fn: function(btn) {
										switch(btn){
										case 'yes':  
										uncheckedServices=uncheckedServices+r.data['ProcessIdDataIndex']+',';
										break; 
										case 'no':
										smMandatory.selectRow(rowIndex,true);
										break;
										}
										}
										});
						}
						}
		} 
       	if(smMandatory.isSelected(rowIndex)){
       	var ProcessId=r.data['ProcessIdDataIndex'];
       	var ProcessName=r.data['ProcessNameDataIndex'];
       	var ProcessLabel=r.data['ProcessLabelDataIndex'];
       	processdetailsstore.load({params:{ProcessId:ProcessId},
								    callback:function(){
								    	var recd=processdetailsstore.getAt(0);
								    	var details=recd.data['ProductDetails'];
										detailspanelmandatory.body.update('<b><u>'+ProcessName+'</u> :</b>'+details);
										detailspanelmandatory.doLayout();
										detailspanelmandatory.show();
									    }});
		}
		else{	
			var ProcessId=r.data['ProcessIdDataIndex'];
       		var ProcessName=r.data['ProcessNameDataIndex'];
       		var ProcessLabel=r.data['ProcessLabelDataIndex'];
				processdetailsstore.load({params:{ProcessId:ProcessId},
								    callback:function(){
								    	var recd=processdetailsstore.getAt(0);
								    	var details=recd.data['ProductDetails'];
								    	detailspanelmandatory.body.update('<b><u>'+ProcessName+'</u> :</b>'+details);
										detailspanelmandatory.doLayout();
										detailspanelmandatory.show();
									    }});
				if(<%=showGrp%>){
				var essind=processMandatorystore.findExact( 'ProcessLabelDataIndex', "Ess_Montr");
                     if(essind==rowIndex){
                     Ext.example.msg("<%=Cannot_Disassociate_Ess%>");
					    	 processMandatorystore.load();
	                     	 return;
	  				}
					var r=customergrpprocessdetailsstore.getAt(0);
			    	 var details=r.data['CustomerGrpProcessDetails'];
			    	 var serviceschecked=details.split(',');
			    	 for(var ins=0;ins<serviceschecked.length;ins++){
			    		var serind=processVerticalstore.findExact( 'ProcessIdDataIndex', serviceschecked[ins]); 
	 					if(serind>-1){
	 					Ext.example.msg("<%=Cannot_Disassociate_Man_Package%>");
					    	  processMandatorystore.load();
	                     	 return;
	  					}
                     }
             }					
		}
     } // END OF ON-CELL-CLICK 
     
     //****************************ProcessVerticalGrid oncellclick func *****************************************
    processVerticalGrid.on({
        			"cellclick":{fn: onCellClickForprocessVerticalGrid },
   			   		"viewready":{fn:onViewReadyVer}
   				});
   	 function onViewReadyVer(processAddOnGrid, rowIndex, columnIndex, e){
   	 		saveFlagVer=0;
   	 		if(customergrpprocessdetailsstore.data.items.length>0){
   	 		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		ind=processVerticalGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smVertical.selectRow(ind,true);
	       											} 
       										}
       		}
   	 }
   	
   	 function onCellClickForprocessVerticalGrid(processVerticalGrid, rowIndex, columnIndex, e){   	 
   	 	saveFlagVer=1;
   		var r = processVerticalGrid.store.getAt(rowIndex);
   		if(columnIndex == processVerticalGrid.getColumnModel().findColumnIndex('ProcessNameDataIndex')){
   		if(!(smVertical.isSelected(rowIndex))){
       		smVertical.selectRow(rowIndex,true);
       	}else{
       		smVertical.deselectRow(rowIndex,false);
       	}
       	}
       	if(!<%=showGrp%> && !(smVertical.isSelected(rowIndex))){
	   	 if(customergrpprocessdetailsstore.data.items.length>0){
   	 		var rec=customergrpprocessdetailsstore.getAt(0);
			var details=","+rec.data['CustomerGrpProcessDetails']+",";
			var pro=","+r.data['ProcessIdDataIndex']+",";
			if(details.indexOf(pro) != -1){
   	 		Ext.Msg.show({
										title: '<%=Disassociating_process_mesg%>',
										msg: 'want to disassociate?',
										width:'50%',
										buttons: {
										yes: true,
										no: true
										},
										fn: function(btn) {
										switch(btn){
										case 'yes':  
										uncheckedServices=uncheckedServices+r.data['ProcessIdDataIndex']+',';
										break; 
										case 'no':
										smVertical.selectRow(rowIndex,true);
										break;
										}
										}
										});
						}
						}
		}   	  
		if(smVertical.isSelected(rowIndex)){
       	var ProcessId=r.data['ProcessIdDataIndex'];
       	var ProcessName=r.data['ProcessNameDataIndex'];
       	var ProcessLabel=r.data['ProcessLabelDataIndex'];
       	processdetailsstore.load({params:{ProcessId:ProcessId},
								    callback:function(){
								    	var recd=processdetailsstore.getAt(0);
								    	var details=recd.data['ProductDetails'];
											detailspanelverticalized.body.update('<b><u>'+ProcessName+'</u> :</b>'+details);
											detailspanelverticalized.doLayout();
											detailspanelverticalized.show();
									    }});
		}
		else{
			 	var ProcessId=r.data['ProcessIdDataIndex'];
       	var ProcessName=r.data['ProcessNameDataIndex'];
       	var ProcessLabel=r.data['ProcessLabelDataIndex'];
       	processdetailsstore.load({params:{ProcessId:ProcessId},
								    callback:function(){
								    	var recd=processdetailsstore.getAt(0);
								    	var details=recd.data['ProductDetails'];
											detailspanelverticalized.body.update('<b><u>'+ProcessName+'</u> :</b>'+details);
											detailspanelverticalized.doLayout();
											detailspanelverticalized.show();
									    }});						
		}
     } // END OF ON-CELL-CLICK
     
     //****************************ProcessAddOnGrid oncellclick func *****************************************
    processAddOnGrid.on({
        			"cellclick":{fn: onCellClickForprocessAddOnGrid },
        			"viewready":{fn:onViewReadyAddon}
   				});
   	 function onViewReadyAddon(processAddOnGrid, rowIndex, columnIndex, e){  
   	 		saveFlagAddon=0;
   	 		if(customergrpprocessdetailsstore.data.items.length>0){
   	 		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		ind=processAddOnGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smAddOn.selectRow(ind,true);
	       											} 
       										}
       		}
   	 }
   	 function onCellClickForprocessAddOnGrid(processAddOnGrid, rowIndex, columnIndex, e){   	
   	 	saveFlagAddon=1; 
   		var r = processAddOnGrid.store.getAt(rowIndex);
   		if(columnIndex == processAddOnGrid.getColumnModel().findColumnIndex('ProcessNameDataIndex')){
   		if(!(smAddOn.isSelected(rowIndex))){
       		smAddOn.selectRow(rowIndex,true);
       	}else{
       		smAddOn.deselectRow(rowIndex,false);
       	}
       	}
       	if(!<%=showGrp%> && !(smAddOn.isSelected(rowIndex))){
	   	 if(customergrpprocessdetailsstore.data.items.length>0){
   	 		var rec=customergrpprocessdetailsstore.getAt(0);
			var details=","+rec.data['CustomerGrpProcessDetails']+",";
			var pro=","+r.data['ProcessIdDataIndex']+",";
			if(details.indexOf(pro) != -1){
   	 		Ext.Msg.show({
										title: '<%=Disassociating_process_mesg%>',
										msg: 'want to disassociate?',
										width:450,
										buttons: {
										yes: true,
										no: true
										},
										fn: function(btn) {
										switch(btn){
										case 'yes': 
										uncheckedServices=uncheckedServices+r.data['ProcessIdDataIndex']+',';
										break; 
										case 'no':
										smAddOn.selectRow(rowIndex,true);
										break;
										}
										}
										});
						}
						}
		}   	  
       	if(smAddOn.isSelected(rowIndex)){
       	var ProcessId=r.data['ProcessIdDataIndex'];
       	var ProcessName=r.data['ProcessNameDataIndex'];
       	processdetailsstore.load({params:{ProcessId:ProcessId},
								    callback:function(){
								    	var recd=processdetailsstore.getAt(0);
								    	var details=recd.data['ProductDetails'];
										detailspaneladdson.body.update('<b><u>'+ProcessName+'</u> :</b>'+details);
										detailspaneladdson.doLayout();
										detailspaneladdson.show();
									    }});
		}
		else{
			var ProcessId=r.data['ProcessIdDataIndex'];
       	var ProcessName=r.data['ProcessNameDataIndex'];
       	processdetailsstore.load({params:{ProcessId:ProcessId},
								    callback:function(){
								    	var recd=processdetailsstore.getAt(0);
								    	var details=recd.data['ProductDetails'];
								    	detailspaneladdson.body.update('<b><u>'+ProcessName+'</u> :</b>'+details);
										detailspaneladdson.doLayout();
										detailspaneladdson.show();
									    }});							
		}
     } // END OF ON-CELL-CLICK 
  
  
    //*************Asset Group store********************************************************
      var assetgroupcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getallgroup',
				   id:'GroupStoreId',
			       root: 'GroupRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['GroupId','GroupName','ActivationStatus'],
				   listeners: {
    				load: function(store, records, success, options) {
        				 if(<%=GrpIdPassed%>>0){
        				 		var indd=assetgroupcombostore.findExact( 'GroupId', '<%=GrpIdPassed%>'); 
        				 		if(indd>=0){
				 		  		Ext.getCmp('assetgroupcomboId').setValue(<%=GrpIdPassed%>);
				 		  		}

				 		  		customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue(),GrpId:Ext.getCmp('assetgroupcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
		                 	    		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		var ind=processMandatoryGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
								    		if(ind>-1){
       										smMandatory.selectRow(ind,true);
       										}else{
       											ind=processVerticalGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
       											if(ind>-1){
	       											smVertical.selectRow(ind,true);
	       										}else{
	       											ind=processAddOnGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smAddOn.selectRow(ind,true);
	       											} 
	       										}
       										}
								    	}
		                 	    	}
		                 	    	});
				 		  }
    				}
    				}
				   
				
	  });
  
   //***************Asset Group Combo*************************************************
	  var assetgroupcombo=new Ext.form.ComboBox({
	        store: assetgroupcombostore,
	        id:'assetgroupcomboId',
	        mode: 'local',
	        forceSelection: true,
	        hidden:true,
	        emptyText:'<%=Select_Asset_Group%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'GroupId',
	    	displayField: 'GroupName',
	    	listWidth : 200,
	    	cls:'selectstyle',
	    	listeners: 
	    	{
		         select: 
		         {
		               fn:function()
		               {
		               	   processMandatorystore.load();
		                 	   processVerticalstore.load();
		                 	   processAddOnstore.load();
		               	customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue(),GrpId:Ext.getCmp('assetgroupcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
		                 	    		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		var ind=processMandatoryGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
								    		if(ind>-1){
       										smMandatory.selectRow(ind,true);
       										}else{
       											ind=processVerticalGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
       											if(ind>-1){
	       											smVertical.selectRow(ind,true);
	       										}else{
	       											ind=processAddOnGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smAddOn.selectRow(ind,true);
	       											} 
	       										}
       										}
								    	}
		                 	    	}
		                 	    	});
 					   }
 				 }
 			}
 	  });
    
  
//****store for getting customer name
  var custmastcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getallCustomer',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName','Status','ActivationStatus'],
				      listeners: {
    				load: function(store, records, success, options) {
        				 if(<%=customeridlogged%>>0){
				 			Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
				 			 assetgroupcombostore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()}
		                 	    	});
		                 	if(!<%=showGrp%>){
				 			customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
		                 	    		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		var ind=processMandatoryGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
								    		if(ind>-1){
       										smMandatory.selectRow(ind,true);
       										}else{
       											ind=processVerticalGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
       											if(ind>-1){
	       											smVertical.selectRow(ind,true);
	       										}else{
	       											ind=processAddOnGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smAddOn.selectRow(ind,true);
	       											} 
	       										}
       										}
								    	}
		                 	    	}
		                 	    	});
		                 	    	}
				 		  }
				 		  else if(CustIdPassed>0){
				 		  		Ext.getCmp('custmastcomboId').setValue(CustIdPassed);
				 		  		var clientId=Ext.getCmp('custmastcomboId').getValue();
				 		  		var idx = custmastcombostore.findBy(function(record){
								if(record.get('CustId') == clientId){
								status=record.get('ActivationStatus');
								if(status=='Incomplete')
								{
								 parent.globalCustomerID=0;
								}
								else
								{
								 parent.globalCustomerID=CustIdPassed;
								}
								}
								});
				 		  		assetgroupcombostore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()}
		                 	    	});
				 		  		if(!<%=showGrp%>){
				 		  		customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
		                 	    		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		var ind=processMandatoryGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
								    		if(ind>-1){
       										smMandatory.selectRow(ind,true);
       										}else{
       											ind=processVerticalGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
       											if(ind>-1){
	       											smVertical.selectRow(ind,true);
	       										}else{
	       											ind=processAddOnGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smAddOn.selectRow(ind,true);
	       											} 
	       										}
       										}
								    	}
		                 	    	}
		                 	    	});
				 		  }
				 		  }
				 		  else if(globalCustomerID!=0)
                			{
				 		  		Ext.getCmp('custmastcomboId').setValue(globalCustomerID);
				 		  		var clientId=Ext.getCmp('custmastcomboId').getValue();
				 		  		var idx = custmastcombostore.findBy(function(record){
								if(record.get('CustId') == clientId){
								status=record.get('ActivationStatus');
								if(status=='Incomplete')
								{
								 parent.globalCustomerID=0;
								}
								else
								{
								 parent.globalCustomerID=CustIdPassed;
								}
								}
								});
				 		  		assetgroupcombostore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()}
		                 	    	});
		                 	    	if(<%=showGrp%>){
		                 	   			processMandatorystore.load();
		                 	   			processVerticalstore.load();
		                 	   			processAddOnstore.load();
		                 	   			}
		                 	    if(!<%=showGrp%>){
				 		  		customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
		                 	    		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		var ind=processMandatoryGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
								    		if(ind>-1){
       										smMandatory.selectRow(ind,true);
       										}else{
       											ind=processVerticalGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
       											if(ind>-1){
	       											smVertical.selectRow(ind,true);
	       										}else{
	       											ind=processAddOnGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smAddOn.selectRow(ind,true);
	       											} 
	       										}
       										}
								    	}
		                 	    	}
		                 	    	});
				 		  }	
                }
    				}
    				}
				  
	});
 

   
  
 // ** combo for customername
 var custnamecombo=new Ext.form.ComboBox({
	        store: custmastcombostore,
	        id:'custmastcomboId',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=Select_Customer%>',
	        blankText :'<%=Select_Customer%>',
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
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	   parent.globalCustomerID=Ext.getCmp('custmastcomboId').getValue();
		                 	   CustIdPassed=Ext.getCmp('custmastcomboId').getValue();
		                 	   var status="";
		                 	   Ext.getCmp('assetgroupcomboId').reset();
		                 	   var clientId=Ext.getCmp('custmastcomboId').getValue();
					var idx = custmastcombostore.findBy(function(record){
					if(record.get('CustId') == clientId){
					status=record.get('ActivationStatus');
					if(status=='Incomplete')
					{
					 parent.globalCustomerID=0;
					}
					else
					{
					 parent.globalCustomerID=Ext.getCmp('custmastcomboId').getValue();
					}
					}
					});
		                 	   if(<%=showGrp%>){
		                 	   processMandatorystore.load();
		                 	   processVerticalstore.load();
		                 	   processAddOnstore.load();
		                 	   assetgroupcombostore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()}
		                 	    	});
		                 	   }else{
		                 	        processMandatorystore.load();
		                 	   		processVerticalstore.load();
		                 	   		processAddOnstore.load({callback: function(){
		                 	    	customergrpprocessdetailsstore.load({
		                 	    	params:{CustId:Ext.getCmp('custmastcomboId').getValue()},
		                 	    	callback: function(){
		                 	    	uncheckedServices='';
		                 	    	saveFlagMan=0;
		                 	    	saveFlagVer=0;
		                 	    	saveFlagAddon=0;
		                 	    		var r=customergrpprocessdetailsstore.getAt(0);
								    	var details=r.data['CustomerGrpProcessDetails'];
								    	var services=details.split(',');
								    	for(var ins=0;ins<services.length;ins++){
								    		var ind=processMandatoryGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
								    		if(ind>-1){
       										smMandatory.selectRow(ind,true);
       										}else{
       											ind=processVerticalGrid.store.findExact( 'ProcessIdDataIndex', services[ins]); 
       											if(ind>-1){
	       											smVertical.selectRow(ind,true);
	       										}else{
	       											ind=processAddOnGrid.store.findExact( 'ProcessIdDataIndex', services[ins]);
	       											if(ind>-1){
	       												smAddOn.selectRow(ind,true);
	       											} 
	       										}
       										}
								    	}
		                 	    	}
		                 	    	});
		                 	    	}
		                 	   });
		                 	   }
		           }}}
    });
    
    
    
    
    var customergrppanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		bodyStyle: 'padding:10px 10px;',
		region:'north',
		width:'100%',
		height:'20',
		border:false,
		id:'customergrppanelid',
		layout:'table',
		layoutConfig: {
			columns:5
		},
		items: [{xtype:'label',id:'custlabelid',hidden:false,text:'<%=Customer_Name%>'+' :',cls:'labelstyle'},custnamecombo,{width:10,border:false},{xtype:'label',id:'grplabelid',hidden:true,text:'<%=Asset_Group_Name%>'+' :',cls:'labelstyle'},assetgroupcombo
		]				
		});
    
    //**********************combo for CustomerName end ********************************


   
    
 
		
var buttonPanel=new Ext.FormPanel({
		 id: 'buttonid',
		 width:'100%',
		 height:40,
		 layout: 'fit',
		 frame:true,
		 buttons:[{
			       text: '<%=Next%>',
			       iconCls:'nextbutton',
			       handler : function(){
			       
			       	if(!<%=showGrp%>)
			       	{
			       	var status="";
			       	var clientId=Ext.getCmp('custmastcomboId').getValue();
					var idx = custmastcombostore.findBy(function(record){
					if(record.get('CustId') == clientId){
					status=record.get('ActivationStatus');
					}
					});
					if(status=='Incomplete')
					{
					Ext.example.msg('Customer Registration Process is Incomplete');
					return;
					}
					else
					{
						var clientId=Ext.getCmp('custmastcomboId').getValue();
						parent.Ext.getCmp('customizationTab').enable();
						parent.Ext.getCmp('customizationTab').show();
						parent.Ext.getCmp('customizationTab').update("<iframe style='width:100%;height:525px;border:0;' src='<%=path%>/Jsps/Admin/CustomerSetting.jsp?feature=1&CustIdPassed=clientId'></iframe>");
			       
					}
			       	}
			       	else
			       	{
			       	var status="";
			       	var groupId=Ext.getCmp('assetgroupcomboId').getValue();
					var idx = assetgroupcombostore.findBy(function(record){
					if(record.get('GroupId') == groupId){
					status=record.get('ActivationStatus');
					}
					});
					if(status=='Incomplete')
					{
					Ext.example.msg('Asset Registration Process is Incomplete');
					return;
					}
					else
					{	
					var clientId=Ext.getCmp('custmastcomboId').getValue();		       						
			       	var usermanagementurl='<%=request.getContextPath()%>/Jsps/Admin/UserManagement.jsp?feature=1&CustId='+clientId+'';
					parent.Ext.getCmp('userManagementTab').enable();
					parent.Ext.getCmp('userManagementTab').show();
					parent.Ext.getCmp('userManagementTab').update("<iframe style='width:100%;height:595px;border:0;' src='"+usermanagementurl+"'></iframe>");
			        }
			        }
			       
			       }
			      }]		      
	});

	
	var detailspanelmandatory = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		autoScroll :true,
		frame:true,
		hidden:true,
		preventBodyReset: true,
		width:510,
		height:320,
		id:'detailspanelmanid',
		layout:'table',
		layoutConfig: {
			columns:1
		}
	});
	
	var detailspanelverticalized = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		autoScroll :true,
		frame:true,
		preventBodyReset: true,
		hidden:true,
		width:510,
		height:320,
		id:'detailspaneverlid',
		layout:'table',
		layoutConfig: {
			columns:1
		}
	});
	var detailspaneladdson = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		autoScroll :true,
		frame:true,
		hidden:true,
		preventBodyReset: true,
		width:510,
		height:320,
		id:'detailspaneladdsid',
		layout:'table',
		layoutConfig: {
			columns:1
		}
	});
	
	var buttonPanelman=new Ext.Panel({
		 id: 'buttonmanid',
		 frame:true,
		 buttons:[{
			       text: 'Save',
			       id:'saveButtonId',
			       iconCls:'savebutton',
			       listeners: {
			        click:{
			       	fn:function(){
			       	var custActivation="";
			       	var grpActivation="";
			       	
			       	if(Ext.getCmp('custmastcomboId').getValue()=="" )
  					{
  					Ext.example.msg("<%=Select_Customer%>");
                    return;
                	}
                	var custName="";
	                var custind=custmastcombostore.findExact('CustId',parseInt(Ext.getCmp('custmastcomboId').getValue())); 
	                if(custind!=-1){
	                var custrec=custmastcombostore.getAt(custind);
	                custActivation=custrec.data['ActivationStatus'];
	                custName=custrec.data['CustName'];
	                }
                	if(<%=showGrp%> && Ext.getCmp('assetgroupcomboId').getValue()=="" )
  					{
  					Ext.example.msg("<%=Select_Asset_Group%>");
                     return;
                	}
                	if(<%=showGrp%>)
  					{
                	var grpind=assetgroupcombostore.findExact( 'GroupId', Ext.getCmp('assetgroupcomboId').getValue()); 
	                if(grpind!=-1){
	                var grprec=assetgroupcombostore.getAt(grpind);
	                grpActivation=grprec.data['ActivationStatus'];
	                }
	                }
                	
					var services="";
					var records = processMandatoryGrid.selModel.getSelections();
					for (var i = 0, len = records.length; i < len; i++)
					{
					
		    			var store =  records[i];
		    			var process = store.get('ProcessIdDataIndex'); 
		    			services = services + process + ",";		    			
		 			}
		 			services=services.substring(0,services.length-1);
		 			if(!<%=showGrp%> && services=="" && uncheckedServices=="")
  					{
  					Ext.example.msg("<%=Select_Package%>");
                     return;
                     }
                     else if(<%=showGrp%> && saveFlagMan==0){
                     Ext.example.msg("<%=Select_Package%>");
	                     return;
                     }
                     var essind=processMandatorystore.findExact( 'ProcessLabelDataIndex', "Ess_Montr");
                     if(essind>-1 && uncheckedServices!=""){
                     var essrec=processMandatorystore.getAt(essind);
                     var espid=essrec.data['ProcessIdDataIndex'];
                     var uncheck=','+uncheckedServices;
                     var unind=uncheck.indexOf(','+espid+',');
                     		if(unind>-1){
                     		Ext.example.msg("<%=Cannot_Disassociate_Ess%>");
					    	 processMandatorystore.load();
	                     	 return;
	                     	}
	  				}
                     
                     var r=customergrpprocessdetailsstore.getAt(0);
			    	 var details=r.data['CustomerGrpProcessDetails'];
			    	 var serviceschecked=details.split(',');
			    	 for(var ins=0;ins<serviceschecked.length;ins++){
			    		var serind=processVerticalstore.findExact( 'ProcessIdDataIndex', serviceschecked[ins]); 
	 					if(serind>-1 && uncheckedServices!=""){
	 					Ext.example.msg("<%=Cannot_Disassociate_Man_Package%>");
					    	  processMandatorystore.load();
	                     	 return;
	  					}
                     }
                     if(processVerticalGrid.selModel.getSelections().length==0 && !<%=showGrp%>){
                     Ext.example.msg("<%=Select_Verticalized%>");
	                     return;
                    }
		 			var processtypelabel="Mand_Package";			
					//scrolling on top
									    window.scrollTo(0,0);
										//Ajax request
										Ext.Ajax.request({
										 				url: '<%=request.getContextPath()%>/ProductFeaturesAction.do?param=saveCustomerMandatoryProcessDetails',
														method: 'POST',
														params: 
														{    ProcessTypeLabel:processtypelabel,
															 custId:Ext.getCmp('custmastcomboId').getValue(),
															 grpId:Ext.getCmp('assetgroupcomboId').getValue(),
												         	 showGrp:<%=showGrp%>,
												         	 checkedServices:services.toString(),
												         	 uncheckedServices:uncheckedServices.toString(),
												         	 custActivation:custActivation,
			       											 grpActivation:grpActivation,
			       											 custName:custName,
			       											 pageName: pageName
														},
														success:function(response, options)//start of success
														{
														
														services='';
															uncheckedServices='';
															saveFlagMan=0;
		                 	    							saveFlagVer=0;
		                 	    							saveFlagAddon=0;
		                 	    							Ext.example.msg(response.responseText);
											                     processMandatorystore.load();
		                 	   									processVerticalstore.load();
		                 	   									processAddOnstore.load();
		                 	   									detailspanelmandatory.hide();
															  
														}, // END OF  SUCCESS
													    failure: function()//start of failure 
													    {
													    	services='';
													    	uncheckedServices='';
													    	saveFlagMan=0;
								                 	    	saveFlagVer=0;
								                 	    	saveFlagAddon=0;
													        Ext.example.msg(response.responseText);
											                     custmastcombostore.reload();
											                     assetgroupcombostore.reload();
											                      processMandatorystore.load();
		                 	   									processVerticalstore.load();
		                 	   									processAddOnstore.load();
		                 	   									detailspanelmandatory.hide();
														} // END OF FAILURE 
											}); // END OF AJAX	
                     
                	}
		 			}
		 			}
		 			
			      }]
	});
	var buttonPanelver=new Ext.FormPanel({
		 id: 'buttonverid',
		 frame:true,
		 buttons:[{
			       text: 'Save',
			        iconCls:'savebutton',
			        listeners: {
			        click:{
			       	fn:function(){
			       	var custActivation="";
			       	var grpActivation="";
			       	  	
			       	if(Ext.getCmp('custmastcomboId').getValue()=="" )
  					{
  					Ext.example.msg("<%=Select_Customer%>");
                    return;
                	}
                	var custName="";
                	var custind=custmastcombostore.findExact( 'CustId',parseInt(Ext.getCmp('custmastcomboId').getValue())); 
	                if(custind!=-1){
	                var custrec=custmastcombostore.getAt(custind);
	                custActivation=custrec.data['ActivationStatus'];
	                custName=custrec.data['CustName'];
	                }
                	
                	if(<%=showGrp%> && Ext.getCmp('assetgroupcomboId').getValue()=="" )
  					{
  					Ext.example.msg("<%=Select_Asset_Group%>");
                     return;
                	}
                	
                	if(<%=showGrp%>)
  					{
                	var grpind=assetgroupcombostore.findExact( 'GroupId', Ext.getCmp('assetgroupcomboId').getValue()); 
	                if(grpind!=-1){
	                var grprec=assetgroupcombostore.getAt(grpind);
	                grpActivation=grprec.data['ActivationStatus'];
	                }
	                }
	                
					var services="";
					var records = processVerticalGrid.selModel.getSelections();					
					if(<%=showGrp%> && records.length>1)
					{
					Ext.example.msg("<%=Select_One_Vertical_Group%>");
                     return;
					}
					if(!<%=showGrp%> && records.length>1)
					{
					Ext.example.msg("<%=Select_One_Vertical_Group%>");
                     return;
					}
					for (var i = 0, len = records.length; i < len; i++)
					{
					
		    			var store =  records[i];
		    			var process = store.get('ProcessIdDataIndex'); 
		    			services = services + process + ",";		    			
		 			}
		 			services=services.substring(0,services.length-1);
		 			
		 			if(!<%=showGrp%> && services=="" && uncheckedServices=="")
  					{
  					Ext.example.msg("<%=Select_Package%>");
                     return;
                     }
                     else if(<%=showGrp%> && saveFlagVer==0){
                     Ext.example.msg("<%=Select_Package%>");
	                     return;
                     }                     
                    else if(services=="" && !<%=showGrp%>){
                    Ext.example.msg("<%=Cannot_Disassociate_All_Vetrical%>");
					   processVerticalstore.load();
                       return;
                    }
		 			var processtypelabel="Vertical_Sol";		
					//scrolling on top
									    window.scrollTo(0,0);
										//Ajax request
										Ext.Ajax.request({
										 				url: '<%=request.getContextPath()%>/ProductFeaturesAction.do?param=saveCustomerVerticalizedProcessDetails',
														method: 'POST',
														params: 
														{
														     ProcessTypeLabel:processtypelabel,
															 custId:Ext.getCmp('custmastcomboId').getValue(),
															 grpId:Ext.getCmp('assetgroupcomboId').getValue(),
												         	 showGrp:<%=showGrp%>,
												         	 checkedServices:services.toString(),
												         	 uncheckedServices:uncheckedServices.toString(),
												         	 custActivation:custActivation,
			       	 										 grpActivation:grpActivation,
			       											 custName:custName,
			       											 pageName: pageName
														},
														success:function(response, options)//start of success
														{
														
															services='';
															uncheckedServices='';
															saveFlagMan=0;
								                 	    	saveFlagVer=0;
								                 	    	saveFlagAddon=0;
                                                            Ext.example.msg(response.responseText);
															 processMandatorystore.load();
		                 	   									processVerticalstore.load();
		                 	   									processAddOnstore.load();
		                 	   									detailspanelverticalized.hide();
															  
														}, // END OF  SUCCESS
													    failure: function()//start of failure 
													    {
													    	services='';
													    	uncheckedServices='';
													    	saveFlagMan=0;
								                 	    	saveFlagVer=0;
								                 	    	saveFlagAddon=0;
														    Ext.example.msg(response.responseText);
															 custmastcombostore.reload();
											                     assetgroupcombostore.reload();
											                      processMandatorystore.load();
		                 	   									processVerticalstore.load();
		                 	   									processAddOnstore.load();
		                 	   									detailspanelverticalized.hide();
														} // END OF FAILURE 
											}); // END OF AJAX	
			       	
			       	}}}
			      }]
	});
	var buttonPaneladdson=new Ext.Panel({
		 id: 'buttonaddsid',
		 frame:true,
		 buttons:[{
			       text: 'Save',
			        iconCls:'savebutton',
			       listeners: {
			        click:{
			       	fn:function(){
			       	var custActivation="";
			       	var grpActivation="";
			       	
			       	if(Ext.getCmp('custmastcomboId').getValue()=="" )
  					{
  					Ext.example.msg("<%=Select_Customer%>");
                     return;
                	}
                	var custName="";
                	var custind=custmastcombostore.findExact( 'CustId',parseInt(Ext.getCmp('custmastcomboId').getValue())); 
	                if(custind!=-1){
	                var custrec=custmastcombostore.getAt(custind);
	                custActivation=custrec.data['ActivationStatus'];
	                custName=custrec.data['CustName'];
	                }
                	
                	if(<%=showGrp%> && Ext.getCmp('assetgroupcomboId').getValue()=="" )
  					{
  					Ext.example.msg("<%=Select_Asset_Group%>");
                     return;
                	}
                	if(<%=showGrp%>)
  					{
                	var grpind=assetgroupcombostore.findExact( 'GroupId', Ext.getCmp('assetgroupcomboId').getValue()); 
	                if(grpind!=-1){
	                var grprec=assetgroupcombostore.getAt(grpind);
	                grpActivation=grprec.data['ActivationStatus'];
	                }
	                }
                	
					var services="";
					var records = processAddOnGrid.selModel.getSelections();
					for (var i = 0, len = records.length; i < len; i++)
					{
					
		    			var store =  records[i];
		    			var process = store.get('ProcessIdDataIndex'); 
		    			services = services + process + ",";		    			
		 			}
		 			services=services.substring(0,services.length-1);
		 			
		 			if(!<%=showGrp%> && services=="" && uncheckedServices=="")
  					{
  					Ext.example.msg("<%=Select_Package%>");
                     return;
                     }
                     else if(<%=showGrp%> && saveFlagAddon==0){
                     Ext.example.msg("<%=Select_Package%>");
	                     return;
                     }
                    
                    if(processMandatoryGrid.selModel.getSelections().length==0){
                    Ext.example.msg("<%=Select_Mandatory%>");
	                     return;
                    }else if(processVerticalGrid.selModel.getSelections().length==0 && !<%=showGrp%>){
                    Ext.example.msg("<%=Select_Verticalized%>");
	                     return;
                    }
		 			var processtypelabel="Add_On_Pkg";			
					//scrolling on top
									    window.scrollTo(0,0);
										//Ajax request
										Ext.Ajax.request({
										 				url: '<%=request.getContextPath()%>/ProductFeaturesAction.do?param=saveCustomerAddsonProcessDetails',
														method: 'POST',
														params: 
														{    ProcessTypeLabel:processtypelabel,
															 custId:Ext.getCmp('custmastcomboId').getValue(),
															 grpId:Ext.getCmp('assetgroupcomboId').getValue(),
												         	 showGrp:<%=showGrp%>,
												         	 checkedServices:services.toString(),
												         	 uncheckedServices:uncheckedServices.toString(),
												         	 custActivation:custActivation,
			       	 										 grpActivation:grpActivation,
			       											 custName:custName,
			       											 pageName: pageName
														},
														success:function(response, options)//start of success
														{
														
														services='';
															uncheckedServices='';
															saveFlagMan=0;
								                 	    	saveFlagVer=0;
								                 	    	saveFlagAddon=0;
															
                                                              Ext.example.msg(response.responseText);
											                    processMandatorystore.load();
		                 	   									processVerticalstore.load();
		                 	   									processAddOnstore.load();
		                 	   									detailspaneladdson.hide();
															  
														}, // END OF  SUCCESS
													    failure: function()//start of failure 
													    {
													    	services='';
													    	uncheckedServices='';
															saveFlagMan=0;
								                 	    	saveFlagVer=0;
								                 	    	saveFlagAddon=0;
														    Ext.example.msg(response.responseText);
															 custmastcombostore.reload();
											                     assetgroupcombostore.reload();
											                      processMandatorystore.load();
		                 	   									processVerticalstore.load();
		                 	   									processAddOnstore.load();
		                 	   									detailspaneladdson.hide();
														} // END OF FAILURE 
											}); // END OF AJAX	
			       	
			       	}}}
			      }]
	});
	var  t4upackages = new Ext.ux.GroupTabPanel({
            tabWidth: 130,
            width:'100%',
            activeGroup: 0,
            id:'tabid',
    		region:'center',
          items: [{
                expanded: false,
                items: [{
                    title: 'Mandatory Packages',
                    id:'mandatorypackid',
                    iconCls: 'x-icon-configuration',
                    tabTip: 'Mandatory Packages',
                    style: 'padding: 1px;',
                    layout:'table',
					layoutConfig: {
						columns:3
					},
                    items:[processMandatoryGrid,{border:false,width:15},detailspanelmandatory,buttonPanelman] 
                }]
            },
            {
                expanded: false,
                items: [{
                    title: 'Verticalized Solution',
                    id:'verticalizedpackid',
                    iconCls: 'x-icon-configuration',
                    tabTip: 'Verticalized Solution',
                    style: 'padding: 1px;',
                     layout:'table',
					layoutConfig: {
						columns:3
					},
                    items:[processVerticalGrid,{border:false,width:15},detailspanelverticalized,buttonPanelver] 
                }]
            },{
                expanded: false,
                items: [{
                    title: 'Add-on Packages',
                    id:'addonpackid',
                    iconCls: 'x-icon-configuration',
                    tabTip: 'Add-on Packages',
                    style: 'padding: 1px;',
                    layout:'table',
					layoutConfig: {
						columns:3
					},
                    items:[processAddOnGrid,{border:false,width:15},detailspaneladdson,buttonPaneladdson] 
                }]
            }
            
            
            ]
        }); 
	
	
	//viewport for displaying all panel depending clicking label
	 var viewport = new Ext.Viewport({
        layout:'border',
        height:'60%',
        width:'100%',
        border: false,
        autoScroll:false,
         items:[{
          region:'north',
            height:'70',
            width:'100%',
            items:[customergrppanel]
            },
         	t4upackages,
         {
            region:'south',
            height:'70',
            width:'100%',            
            items:[buttonPanel]
            //bbar:ctsb
            
            
         }]
         
            });	
            
//*****main starts from here*************************
 Ext.onReady(function() {
 
 if(<%= customeridlogged %> > 0){
  if('<%=userAuthority%>' == 'Supervisor' || "<%=userAuthority%>" == "Supervisor"){
        
				Ext.getCmp('buttonaddsid').disable();
				Ext.getCmp('buttonverid').disable();
				Ext.getCmp('buttonmanid').disable();
				
			}else{
				Ext.getCmp('buttonaddsid').enable();
				Ext.getCmp('buttonverid').enable();
				Ext.getCmp('buttonmanid').enable();
			} 
 }
 	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';
	if(!<%=showGrp%>){
				Ext.getCmp('custmastcomboId').show();
				Ext.getCmp('custlabelid').show();
				Ext.getCmp('grplabelid').hide();
				Ext.getCmp('assetgroupcomboId').hide();
			}else{
				Ext.getCmp('grplabelid').show();
				Ext.getCmp('assetgroupcomboId').show();
			}
		if(globalCustomerID!=0)
        {
      	  custmastcombostore.reload();
        }   
        				         	   			
 	outerPanel = new Ext.Panel({
			title:'',
			renderTo : 'content',
			standardSubmit: true,
			autoScroll:true,
			//height:530,
			frame:true,
			cls:'outerpanel',
			items: [viewport]
			}); 
			if(!<%=showGrp%>){
				Ext.getCmp('custmastcomboId').show();
				Ext.getCmp('custlabelid').show();
				Ext.getCmp('grplabelid').hide();
				Ext.getCmp('assetgroupcomboId').hide();
			}else{
				Ext.getCmp('grplabelid').show();
				Ext.getCmp('assetgroupcomboId').show();
			}
		if(globalCustomerID!=0)
        {
        	custmastcombostore.reload();
        }  
       
      	
        		
});
<%}%>			
  </script>
  </body>

  
</html>