<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.functions.AdminFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
AdminFunctions adfuncs=new AdminFunctions();

cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int customeridlogged=loginInfo.getCustomerId();
int systemId=loginInfo.getSystemId();
int userId=loginInfo.getUserId();
String userName=loginInfo.getUserFirstName();
if(loginInfo.getUserLastName()!=null){
userName = loginInfo.getUserFirstName()+" "+loginInfo.getUserLastName();
}
int CustIdPassed=0;
if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}
int UserIdPassed=0;
if(request.getParameter("UserId")!=null){
	UserIdPassed=Integer.parseInt(request.getParameter("UserId").toString().trim());
}
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;

//Getting words based on language 
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("User_Feature_Detachment");
tobeConverted.add("Detaching_User_Feature");
tobeConverted.add("Select_User");
tobeConverted.add("Save"); 
tobeConverted.add("Finish");
tobeConverted.add("Note_For_User_Detachment");
tobeConverted.add("Please_Select_Features");
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String SelectCustomer=convertedWords.get(0);
String CustomerName=convertedWords.get(1);
String userFeature=convertedWords.get(2);
String detachinguserfeature=convertedWords.get(3);
String SelectUser=convertedWords.get(4);
String submit=convertedWords.get(5);
String Finish=convertedWords.get(6);
String note=convertedWords.get(7);
String Please_Select_Features=convertedWords.get(8);
String userAuthority=cf.getUserAuthority(systemId,userId);

%>

<!DOCTYPE HTML>
<html>
  <head>
    <title><%=userFeature %></title>
    <meta http-equiv="X-UA-Compatible" content="IE=8">
  </head>
  <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body>
  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
  <jsp:include page="../Common/ImportJSSandMining.jsp"/>
  <%}else {%>
  <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <script>
   var pageName='<%=userFeature %>';
   var outerPanel;
   var ctsb;
   var selNodes;
   var globalCustomerID=parent.globalCustomerID;
   var flag=false;
  //tree panel for showing element in tree structure
  
   var user=<%=UserIdPassed%>; 
   var customeridpassed=<%= CustIdPassed %>;
   
   var treeLoaderUrl='<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree';
   if(user>0){
   		treeLoaderUrl=treeLoaderUrl+'&userId='+user+'&clientId='+customeridpassed;
   }
   //****store for getting user
  var usercombostore=  new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/AssetGroupAction.do?param=getSupervisorDetails',
				   id:'SupervisorStoreId',
			       root: 'SupervisorRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['UserId','SupervisorName','SupervisorPhone','SupervisorEmail']
	});
 
   //****store for getting customer name
  var customercombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getCustomer&paramforltsp=yes',
				   id:'CustomerStoreId',
			       root: 'CustomerRoot',
			       autoLoad: true,
			       remoteSort: true,
				   fields: ['CustId','CustName','Status','ActivationStatus'],
				   listeners: {
    				load: function(custstore, records, success, options) {
        				 if(<%=customeridlogged%>>0){
				 			Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
				 				   tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree';
		                 	    tree.getRootNode().reload();
		                 	     tree.expandAll();
		                 	   Ext.getCmp('usercomboId').reset();
		                 	   var globalClientId=Ext.getCmp('custcomboId').getValue(); 
		                 	   
		                 	   usercombostore.load({
		                 	    params:{CustId:globalClientId}
              		          	});
              		          	 if(user > 0){
			              		  var globalClientId=Ext.getCmp('custcomboId').getValue(); 
			                 	   usercombostore.load({
			                 	    params:{CustId:globalClientId},
			                 	    callback:function(){
			                 	  
			                 	 if('<%=userAuthority%>' == "User" ){
			                 	 Ext.getCmp('usercomboId').setValue(<%=userId%>);	                 	 		                 	   
		                 	     Ext.getCmp('usercomboId').setReadOnly(true);
		                 	     Ext.getCmp('custcomboId').setReadOnly(true);
			              		 tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree&userId='+<%=userId%>+'&clientId='+Ext.getCmp('custcomboId').getValue();
			                     tree.getRootNode().reload();
			                     tree.expandAll();
			              		  }else{
			              		   Ext.getCmp('usercomboId').setValue(user);	                 	 		                 	   
		                 	     Ext.getCmp('usercomboId').setReadOnly(false);
		                 	     Ext.getCmp('custcomboId').setReadOnly(false);
			              		 	tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree&userId='+<%=UserIdPassed%>+'&clientId='+Ext.getCmp('custcomboId').getValue();
			                     	tree.getRootNode().reload();
			                     	 tree.expandAll();
			                 	   
			                 	   }
			                 	    }
			                 	    
			            		          	});
			              		
			              		 }else{
			              		usercombostore.load({
			                 	    params:{CustId:globalClientId},
			                 	    callback:function(){
			              		 if('<%=userAuthority%>' == "User" ){	 
		                 	     Ext.getCmp('usercomboId').setValue(<%=userId%>);
		                 	     Ext.getCmp('usercomboId').setReadOnly(true);
		                 	     Ext.getCmp('custcomboId').setReadOnly(true);
		                 	     tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree&userId='+<%=userId%>+'&clientId='+Ext.getCmp('custcomboId').getValue();
			                     	tree.getRootNode().reload();
			                     	 tree.expandAll();
		                 	   }
			              		 
			              		 }
			              		 });
			              		 }// end else
			              		  
				 		  }

                else if(customeridpassed > 0)
                {
                Ext.getCmp('custcomboId').setValue(customeridpassed);
                	   tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree';
		                 	    tree.getRootNode().reload();
		                 	     tree.expandAll();
		                 	   Ext.getCmp('usercomboId').reset();
		                 	   var globalClientId=Ext.getCmp('custcomboId').getValue(); 
		                 	  
              		 if(user > 0){
              		  var globalClientId=Ext.getCmp('custcomboId').getValue(); 
                 	   usercombostore.load({
                 	    params:{CustId:globalClientId},
                 	    callback:function(){
                 	     Ext.getCmp('usercomboId').setValue(user);
              		 	tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree&userId='+user+'&clientId='+Ext.getCmp('custcomboId').getValue();
                     	tree.getRootNode().reload();
                     	 tree.expandAll();
                 	    }
                 	    
            		          	});
              		
              		 }else{
              		 	 usercombostore.load({
		                 	    params:{CustId:globalClientId}
              		          	});
              		 }      	
              		    
                }
                else if(customeridpassed==0 && user > 0 )
                {
                Ext.getCmp('custcomboId').setValue(customeridpassed);
                	   tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree';
		                 	    tree.getRootNode().reload();
		                 	     tree.expandAll();
		                 	   Ext.getCmp('usercomboId').reset();
		                 	   var globalClientId=Ext.getCmp('custcomboId').getValue(); 
		                 	  
              		 usercombostore.load({
                 	    params:{CustId:globalClientId},
                 	    callback:function(){
                 	     Ext.getCmp('usercomboId').setValue(user);
              		 	tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree&userId='+user+'&clientId='+Ext.getCmp('custcomboId').getValue();
                     	tree.getRootNode().reload();
                     	 tree.expandAll();
                 	    }
                 	    
            		          	});
              		
                }
                else if(globalCustomerID!=0)
                {
                Ext.getCmp('custcomboId').setValue(globalCustomerID);
   	   					tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree';
		                 	    tree.getRootNode().reload();
		                 	     tree.expandAll();
		                 	   Ext.getCmp('usercomboId').reset();
		                 	   var globalClientId=Ext.getCmp('custcomboId').getValue(); 
		                 	   
		                 	  // usercombostore.load({
		                 	  //  params:{CustId:globalClientId}
              		          //	});
              		          
              		           usercombostore.load({
                 	    params:{CustId:globalClientId},
                 	    callback:function(){
                 	    if(user>0){
                 	     Ext.getCmp('usercomboId').setValue(user);
                 	     }
              		 	tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree&userId='+user+'&clientId='+Ext.getCmp('custcomboId').getValue();
                     	tree.getRootNode().reload();
                     	 tree.expandAll();
                 	    }
                 	    
            		          	});
                }
            }
    				}
    				
	});
	
	
	 //***** combo for customername
 var custnamecombo=new Ext.form.ComboBox({
	        store: customercombostore,
	        id:'custcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=SelectCustomer%>',
	        blankText:'<%=SelectCustomer%>',
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
		                 	   parent.globalCustomerID=Ext.getCmp('custcomboId').getValue();
		                 	   customeridpassed=Ext.getCmp('custcomboId').getValue();
		                 	   tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree';
		                 	    tree.getRootNode().reload();
		                 	    tree.expandAll();
		                 	   Ext.getCmp('usercomboId').reset();
		                 	   var globalClientId=Ext.getCmp('custcomboId').getValue(); 
		                 	   
		                 	   usercombostore.load({
		                 	    params:{CustId:globalClientId}
              		          	});
		                 	   }
		                 	   }
		                }
		    }); 
	//treepanel for creating feature tree
	   
	
		var tree = new Ext.tree.TreePanel({
        height: 290,
        width: '99%',
        hidden:false,
        useArrows:true,
        autoScroll:true,
        animate:true,
        enableDD:false,
        containerScroll: true,
        rootVisible: false,
        frame: false,
        
       loader: new Ext.tree.TreeLoader({
       dataUrl:  treeLoaderUrl,
       preloadChildren:true
     
        }),
        
        // auto create TreeLoader
        listeners: {
            'checkchange': function(node, checked){
                if(checked){
                flag=true;
                node.expand();
                node.expandChildNodes(true);
           		node.eachChild(function(child){
           	    child.ui.toggleCheck(checked);
               	child.fireEvent('checkchange', child, checked);
	               })
                }else{
                flag=true;
                node.expand();
                node.expandChildNodes(true);
           		node.eachChild(function(child){
           	    child.ui.toggleCheck(checked);
               	child.fireEvent('checkchange', child, checked);
                })
                
            }
            if(checked){
			node.getUI().addClass('treecomplete');
			}else{
			node.getUI().removeClass('treecomplete');
			}
            
        },
        scope: this
        }
        });
        
        var root=new Ext.tree.AsyncTreeNode({
        text: '',
        id: 'src'
   				 });
   				 
   		tree.setRootNode(root);
   		root.expand();
   		tree.expandAll();
		

		    
		   
		    
		    
//***** combo for Feature Group
 var usercombo=new Ext.form.ComboBox({
	        store: usercombostore,
	        id:'usercomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=SelectUser%>',
	        blankText:'<%=SelectUser%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'UserId',
	    	displayField: 'SupervisorName',
	    	listWidth : 200,
	    	cls:'selectstyle',
	    	listeners: {
		                   select: function(){
		                   	user= Ext.getCmp('usercomboId').getValue();
		                 	   tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree&userId='+Ext.getCmp('usercomboId').getValue()+'&clientId='+Ext.getCmp('custcomboId').getValue();
                               tree.getRootNode().reload();
                                tree.expandAll();
		                 	   }
		               }
		   });
		 
		   
	
		   
		   
 //**********************inner panel start******************************************* 
  var innerPanel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
		cls:'innerpaneltreepanel',
		id:'userfeatureid',
		layout:'table',
		layoutConfig: {
			columns:2
		},
		items: [
				{
				xtype: 'label',
				text: '<%=CustomerName%>'+' :',
				cls:'labelstyle',
				id:'custnamelab'
				},
				custnamecombo,
				{
				xtype: 'label',
				text: '<%=SelectUser%>'+' :',
				cls:'labelstyle',
				id:'useridlab'
				},
				usercombo
				
       			]
		}); // End of Panel	
	 
	 
   //button panel for submit the button
	var buttonsubPanel=new Ext.Panel({
		standardSubmit: true,
		frame:false,
		autoScroll:false,
		collapsible:false,
		width:'100%',
		height:20,
		id:'userFeaturesubmitbutton',
		layout:'table',
		layoutConfig: {
			columns:1
		},
		items: [
			{
			html:'<div style="color:red;font-size:12px;"><%=note%></div>'
			
			}
										]
							    
							    });
							    
							    
	 var buttonPanelNext=new Ext.FormPanel({
		 id: 'buttonid',
		 autoScroll:false,
		 width:'100%',
		 height:10,
		 layout: 'fit',
		 frame:true,
		 buttons:[{
					xtype: 'button',
					text:'<%=submit%>',
					id:'addButtonId',
					iconCls:'savebutton',
			        width:'80px',
			       	listeners: {
			        click:{
			       	fn:function(){
			       	
			       	 // tree.getRootNode().cascade(function(n){
			         // tree.getLoader().doPreload(n);
			         // n.loaded=true;
			        //  n.ui.updateExpandIcon();
			        //  });
	        		var msg = '',  selNodes = tree.getChecked();
	                if(Ext.getCmp('custcomboId').getValue()== "" && Ext.getCmp('custcomboId').getValue()!= "0")	
										{
										Ext.example.msg("<%=SelectCustomer%>");
										Ext.getCmp('custcomboId').focus();
										return;
										}
										
					  if(Ext.getCmp('usercomboId').getValue()== "")	
										{
										Ext.example.msg("<%=SelectUser%>");
										Ext.getCmp('usercomboId').focus();
										return;
										}
					if(flag==false)
		   		      {
		   		      Ext.example.msg("<%=Please_Select_Features%>");
		      	      return;  
		    	     } // END OF IF				
					
					 Ext.each(selNodes, function(node){
				      				      
				       if(node.attributes.data>0){
				       msg += node.attributes.data+',';
				       }
				       });
				      
										
					ctsb.showBusy('<%=detachinguserfeature%>');
      				outerPanel.getEl().mask();      
      				//alert(Ext.getCmp('usercomboId').getValue());  
      Ext.Ajax.request({
  			url: '<%=request.getContextPath()%>/UserFeatureAction.do?param=savedeatchedfeatures',
			method: 'POST',
			params: {CustId:Ext.getCmp('custcomboId').getValue(),
			         UserId:Ext.getCmp('usercomboId').getValue(),
			         selectedFeatures:msg,
			         pageName: pageName
			         },
			success:function(response, options)
			{
			flag=false;
			 Ext.example.msg(response.responseText);
             //usercombostore.load();
             //Ext.getCmp('custcomboId').reset();
             //Ext.getCmp('usercomboId').reset();             
             //tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree',
             //tree.getRootNode().reload();
             // tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree&userId='+Ext.getCmp('usercomboId').getValue()+'&clientId='+Ext.getCmp('custcomboId').getValue();
             // tree.getRootNode().reload();
             outerPanel.getEl().unmask();                													
			}, // END OF  SUCCESS
		    failure: function() 
		    {
		    flag=false;
		    Ext.example.msg("error");
		   // tree.getLoader().dataUrl = '<%=request.getContextPath()%>/UserFeatureAction.do?param=getFeatureGroupTree',
           //  tree.getRootNode().reload();
		    //Ext.getCmp('custcomboId').reset(); 
            //Ext.getCmp('usercomboId').reset();
             //usercombostore.load();
		    outerPanel.getEl().unmask();	
			} // END OF FAILURE 
 		    }); // END OF AJAX       
										
										
										
										
										}
										}
			}},
		 	{
			       text: '<%=Finish%>',
			       iconCls:'finishbutton',
			       handler : function(){
			        var customerId=Ext.getCmp('custcomboId').getValue();
   					parent.Ext.getCmp('customerInformationTab').enable();
					parent.Ext.getCmp('customerInformationTab').show();
			       	parent.Ext.getCmp('customerInformationTab').update("<iframe style='width:100%;height:525px;border:0;'  src='<%=path%>/Jsps/Admin/CustomerMaster.jsp?feature=1'></iframe>");
			       }
			      }]		      
	});
	
var innerTreePanel = new Ext.Panel({
		standardSubmit: true,
		autoScroll:false,
		collapsible:false,
		height:310,
		width:'100%',
		id:'innertreepanelid',
		items:[tree]
		});
//*****main starts from here*************************
 Ext.onReady(function(){
	ctsb=tsb;
	
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
			//title:'<%=userFeature%>',
			renderTo : 'content',
			standardSubmit: true,
			autoScroll:false,
			frame:true,
			width:screen.width-38,
			height:510,
			cls:'outerpanel',
			items: [innerPanel,innerTreePanel,buttonsubPanel,buttonPanelNext]
			//bbar:ctsb			
			}); 
             
	});

   
   </script>
  </body>
</html>
