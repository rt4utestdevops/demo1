<%@ page language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %> 
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
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
cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
String responseaftersubmit="''";
if(session.getAttribute("responseaftersubmit")!=null){
   	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}		
LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("SLNO");
tobeConverted.add("Prepaid_Card_No");
tobeConverted.add("Issued_To");
tobeConverted.add("Amount");
tobeConverted.add("Prepaid_Card_Master");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Add");
tobeConverted.add("Edit");
tobeConverted.add("Card_No");
tobeConverted.add("Name");
tobeConverted.add("Phone_Number");
tobeConverted.add("Email_ID");
tobeConverted.add("Status");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Add_Prepaid_Card_Details");
tobeConverted.add("Modify_Prepaid_Card_Details");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Refund");
tobeConverted.add("Pending_Amount");
tobeConverted.add("Reference_Code");
tobeConverted.add("Cash_Back");
tobeConverted.add("Validate");
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);

String SLNO=convertedWords.get(0);
String prepaidCardNo=convertedWords.get(1);
String issuedTo=convertedWords.get(2);
String amount=convertedWords.get(3);
String prepaidCardMaster = convertedWords.get(4);
String clearFilterData = convertedWords.get(5);
String add = convertedWords.get(6);
String edit = convertedWords.get(7);
String cardNo = convertedWords.get(8);
String name = convertedWords.get(9);
String phoneNumber = convertedWords.get(10);
String emailId = convertedWords.get(11);
String status=convertedWords.get(12);
String save = convertedWords.get(13);
String cancel = convertedWords.get(14);
String addPrepaidCardNo = convertedWords.get(15);
String modifyPrepaidCardNo = convertedWords.get(16);
String noRowSelected=convertedWords.get(17);
String selectSingleRow=convertedWords.get(18);
String refund=convertedWords.get(19);
String pendingAmount=convertedWords.get(20);
String referenceCode=convertedWords.get(21);
String cashBack=convertedWords.get(22);
String validate=convertedWords.get(23);
%>

<jsp:include page="../Common/header.jsp" />
       
    <title>PrepaidCardMaster</title>    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
 
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" />
   	<%}%>
   	<jsp:include page="../Common/ExportJS.jsp" />
   	<style>		
	.x-panel-header
		{
				height: 7% !important;
		}
		.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
			height: 26px !important;
			padding-top: 8px;
		}
		.x-form-text {
			height: 21px !important;
		}
		label
		{
			display : inline !important;
		}
		.x-window-tl *.x-window-header
		{
			height : 40px !important;
		}
		
		.x-form-text {
			height: 26px !important;
		}
		.x-window-tl *.x-window-header {
			height : 36px !important;
		}
		
		.x-window-tl *.x-window-header {
			padding-top : 10px !important;
		}


	</style>
   	<script>
   	var jspName = "Prepaid_Card_Master";
	var exportDataType = "int,int,string,string,string,string,string";
	var myWin;
	var grid;
 	var buttonValue;
 	var title;
 	var cashBackGrid;
 	var reader = new Ext.data.JsonReader({
      idProperty: 'prepaidCardMasterId',
      root: 'prepaidCardMaster',
      totalProperty: 'total',
      fields: [{
          		type: 'numeric',
          		name: 'SNOIndex'
      		 },{
          		type: 'numeric',
          		name: 'UniqueNoIndex'
      		 },{
          		type: 'string',
          		name: 'issuedIndex'
      		 },{
          		type: 'string',
          		name: 'phoneNoIndex'
      		 },{
          		type: 'string',
          		name: 'emailIdIndex'
      		 },{
          		type: 'int',
          		name: 'amountIndex'
      		 },{
      		 	tye:'int',
      		 	name:'pendingamountIndex'
      		 }]
    });
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
			        type: 'numeric',
			        dataIndex: 'SNOIndex'
			    },{
			        type: 'numeric',
			        dataIndex: 'UniqueNoIndex'
			    },{
	          		type: 'string',
	          		dataIndex: 'issuedIndex'
	      		 },{
	      		 	type:'string',
	      		 	dataIndex:'phoneNoIndex'
	      		 },{
	      		 	type:'string',
	      		 	dataIndex:'emailIdIndex'
	      		 },{
	          		type: 'int',
	          		dataIndex: 'amountIndex'
      		 	},{
      		 		type:'int',
      		 		dataIndex:'pendingamountIndex'
      		 	}]
    });
    var createColModel = function(finish, start) {
	    var columns = [
	     	new Ext.grid.RowNumberer({
	            header : "<span style=font-weight:bold;><%=SLNO%></span>",
	            width : 50,
	            filter:{
            		type: 'numeric'
				}
	        }),{
	            dataIndex: 'SNOIndex',
	            width: 30,
	            hidden: true,
	            header: "<span style=font-weight:bold;><%=SLNO%></span>",
	            filter: {
	                type: 'numeric'
	            }
	        },{
	            dataIndex: 'UniqueNoIndex',
	            width: 30,
	            hidden: true,
	            hiddable:true,
	            header: "<span style=font-weight:bold;>Unique Id</span>",
	            filter: {
	                type: 'numeric'
	            }
	        },{
		        header: "<span style=font-weight:bold;><%=issuedTo%></span>", 
		        sortable: true,
		        dataIndex: 'issuedIndex',
		        filter:{
            		type: 'string'
				}		       
		    },{
		        header: "<span style=font-weight:bold;><%=phoneNumber%></span>", 
		        sortable: true,
		        dataIndex: 'phoneNoIndex',
		        filter:{
            		type: 'string'
				}		       
		    },{
		        header: "<span style=font-weight:bold;><%=emailId%></span>", 
		        sortable: true,
		        dataIndex: 'emailIdIndex',
		        filter:{
            		type: 'string'
				}		       
		    },{
		        header: "<span style=font-weight:bold;><%=amount%></span>",
		        sortable: true,
		        dataIndex: 'amountIndex',
		        filter:{
            		type: 'int'
				}	        
		    },{
		        header: "<span style=font-weight:bold;>Pending Amount</span>",
		        sortable: true,
		        dataIndex: 'pendingamountIndex',
		        filter:{
            		type: 'int'
				}	        
		    }];
	    return new Ext.grid.ColumnModel({
	        columns: columns.slice(start || 0, finish),  
	        defaults: {
	            sortable: true
	        }
	    });
	};
	
	
//***************************************Refund Column Model********************************
var reader1 = new Ext.data.JsonReader({
      idProperty: 'prepaidCardMasterId',
      root: 'prepaidCardMasterRefund',
      totalProperty: 'total',
      fields: [
      			{
          		type: 'numeric',
          		name: 'SNODataIndex'
      		 },{
          		type: 'string',
          		name: 'custNameDataIndex'
      		 },{
          		type: 'string',
          		name: 'phoneNoDataIndex'
      		 },{
          		type: 'string',
          		name: 'emailIdDataIndex'
      		 },{
          		type: 'numeric',
          		name: 'amountDataIndex'
      		 },{
      		 	type:'string',
      		 	name:'statusDataIndex'
      		 },{
      		 	type:'numeric',
      		    name:'pendingAmountDataIndex'
      		 }]
    });
    var filters1 = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
			        type: 'numeric',
			        dataIndex: 'SNODataIndex'
			    },{
	          		type: 'string',
	          		dataIndex: 'custNameDataIndex'
	      		 },{
	      		 	type:'string',
	      		 	dataIndex:'phoneNoDataIndex'
	      		 },{
	      		 	type:'string',
	      		 	dataIndex:'emailIdDataIndex'
	      		 },{
	          		type: 'numeric',
	          		dataIndex: 'amountDataIndex'
      		 	},{
      		 		type:'string',
      		 		dataIndex:'statusDataIndex'
      		 	},{
      		 		type:'numeric',
      		 		dataIndex:'pendingAmountDataIndex'
      		 	}]
    });

var cols1= new Ext.grid.ColumnModel([
	     	new Ext.grid.RowNumberer({
	            header : "<span style=font-weight:bold;><%=SLNO%></span>",
	            width : 50,
	            filter:{
            		type: 'numeric'
				}
	        }),{
	            dataIndex: 'SNODataIndex',
	            width: 30,
	            hidden: true,
	            header: "<span style=font-weight:bold;><%=SLNO%></span>",
	            filter: {
	                type: 'numeric'
	            }
	        },{
		        header: "<span style=font-weight:bold;><%=issuedTo%></span>", 
		        sortable: true,
		        width:150,
		        dataIndex: 'custNameDataIndex',
		        filter:{
            		type: 'string'
				}		       
		    },{
		        header: "<span style=font-weight:bold;><%=phoneNumber%></span>", 
		        sortable: true,
		        width:150,
		        dataIndex: 'phoneNoDataIndex',
		        filter:{
            		type: 'string'
				}		       
		    },{
		        header: "<span style=font-weight:bold;><%=emailId%></span>", 
		        sortable: true,
		        width:150,
		        dataIndex: 'emailIdDataIndex',
		        filter:{
            		type: 'string'
				}		       
		    },{
		        header: "<span style=font-weight:bold;><%=amount%></span>",
		        sortable: true,
		        width:100,
		        dataIndex: 'amountDataIndex',
		        filter:{
            		type: 'int'
				}	        
		    },{
		    	header: "<span style=font-weight:bold;><%=status%></span>",
		        sortable: true,
		        width:100,
		        dataIndex: 'statusDataIndex',
		        filter:{
            		type: 'string'
				}	
		    },{
		   		header: "<span style=font-weight:bold;><%=pendingAmount%></span>",
		        sortable: true,
		        width:150,
		        dataIndex: 'pendingAmountDataIndex',
		        filter:{
            		type: 'int'
			}
			}
]);
//****************************************************************************Inner panel for displaying form field**************************************************************************
	var innerPanel = new Ext.form.FormPanel({
		standardSubmit: true,	
		autoScroll:true,
		width:'100%',
		frame:true,
		id:'prepaidMaster',
		layout:'table',
		layoutConfig: {columns:3},
		items:[
            	{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryname'
            	},{
	    		xtype:'label',
	    		cls:'labelstyle',
	    		id:'namelab',
	    		text:'<%=name%> :'
	    		},{
	    		xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'Enter Card Holder Name',
	    		blankText:'Enter Card Holder Name',
	    		allowBlank:false,
	    		maskRe: /[a-z\s]/i,
	    		id:'name',
	    		regex:validate('city'),
	    		listeners: {
                          change: function (field, newValue, oldValue) 
                          {
                          field.setValue(newValue.toUpperCase().trim());
                          }
                       }
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryphoneno'
            	},{
	    		xtype:'label',
	    		cls:'labelstyle',
	    		id:'phoneNolab',
	    		text:'<%=phoneNumber%> :'
	    		},{
	    		xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'Enter Phone Number',
	    		blankText:'Enter Phone Number',
	    		maxLength: 15,
	    		autoCreate: {tag: 'input', type: 'text', size: '20', autocomplete:'off', maxlength: '15'},
	    		allowBlank:false,
	    		allowDecimals: false,
	    		maskRe: /[0-9]/i,
	    		id:'phoneNo'
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryemailid'
            	},{
	    		xtype:'label',
	    		cls:'labelstyle',
	    		id:'emailIdlab',
	    		text:'<%=emailId%> :'
	    		},{
	    		xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		vtype: 'email',
	    		emptyText:'Enter Email Id',
	    		blankText:'Enter Email Id',
	    		allowBlank:false,
	    		id:'emailId'
	    		},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryamount'
            	},{
	    		xtype:'label',
	    		cls:'labelstyle',
	    		id:'amountlab',
	    		text:'<%=amount%> :'
	    		},{
	    		xtype:'numberfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'Enter Amount',
	    		blankText:'Enter Amount',
	    		allowBlank:false,
	    		allowNegative: false,
	    		id:'amount'
	    		}]
	    });
//****************************************************************************Button for Inner panel form field**************************************************************************    
	var winButtonPanel=new Ext.Panel({
        	id: 'winbuttonid',
        	standardSubmit: true,
			autoHeight:true,
			cls:'windowbuttonpanel',
			frame:true,
			layout:'table',
			layoutConfig: {
				columns:2
			},
			buttons:[{
       			xtype:'button',
      			text:'<%=save%>',
        		id:'addButtId',
        		iconCls:'savebutton',
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function(){
       						
		                    if (Ext.getCmp('name').getValue() == "") {
		                        Ext.example.msg("Enter Card Holder Name");
		                        Ext.getCmp('name').focus();
		                        return;
		                    }
		                    if (Ext.getCmp('phoneNo').getValue() == "") {
		                        Ext.example.msg("Enter Phone Number");
		                        Ext.getCmp('phoneNo').focus();
		                        return;
		                    }
		                    if (Ext.getCmp('emailId').getValue() == "") {
		                        Ext.example.msg("Enter Email Id");
		                        Ext.getCmp('emailId').focus();
		                        return;
		                    }
		                    if (Ext.getCmp('amount').getValue() == "") {
		                        Ext.example.msg("Enter Amount");
		                        Ext.getCmp('amount').focus();
		                        return;
		                    }	
		                    if (innerPanel.getForm().isValid()) {
		                    var selected = grid.getSelectionModel().getSelected();
		                    if(buttonValue=='Add'){
		                    	var uniqueId='';	
		                    }else{
		                    	uniqueId=selected.get('UniqueNoIndex');
		                    }
		                    Ext.Ajax.request({
	                            url: '<%=request.getContextPath()%>/PrepaidCardMaster.do?param=addOrModifyPrepaidCardMasterList',
	                            method: 'POST',
	                            params: { 
	                            	buttonValue: buttonValue,
	                            	//cardNumber: Ext.getCmp('cardNo').getValue(),                             
	                                cardHolderName: Ext.getCmp('name').getValue(),	                                
	                                phoneNo: Ext.getCmp('phoneNo').getValue(),
	                                emailId: Ext.getCmp('emailId').getValue(),
	                                amount: Ext.getCmp('amount').getValue(),
	                                uniqueId: uniqueId    
	                            },
	                            success: function (response, options) {
	                                var message = response.responseText;
	                                Ext.example.msg(message);
	                            //   Ext.getCmp('cardNo').reset();
	                                Ext.getCmp('name').reset();
	                                Ext.getCmp('phoneNo').reset();
	                                Ext.getCmp('emailId').reset();	                                
	                                Ext.getCmp('amount').reset();
									store.reload();	                                
	                                myWin.hide();
	                               },
	                            failure: function () {
	                                Ext.example.msg("Error");
	                                store.reload();
	                                myWin.hide();
	                            }
                        	});
       					}else{
       					 Ext.example.msg('There is some invalid data in field, please correct it');
       					}
       					}
       					
       				}
       			}
      		},{
       			xtype:'button',
      			text:'<%=cancel%>',
        		id:'cancelButtId',
        		iconCls:'cancelbutton',
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function()
       					{
       						myWin.hide();
       					}
       				}
       			}
      		}]
	});
	
//****************************************************************************Cash Back Button Panel*************************************************************************************
var cashBackwinButtonPanel=new Ext.Panel({
        	id: 'cashBackwinbuttonid',
        	standardSubmit: true,
			autoHeight:true,
			cls:'windowbuttonpanel',
			frame:true,
			layout:'table',
			layoutConfig: {
				columns:2
			},
			buttons:[{
       			xtype:'button',
      			text:'<%=refund%>',
        		id:'refundButtonId',
        		//iconCls:'savebutton',
        		disabled: true,
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
        				fn:function(){
        				if (Ext.getCmp('refCode').getValue() == "") {
		                        Ext.example.msg("Enter Reference Code");
		                        Ext.getCmp('refCode').focus();
		                        return;
		                    }
		                    if (Ext.getCmp('emailId1').getValue()== "") {
		                        Ext.example.msg("Enter Email Id");
		                        Ext.getCmp('emailId1').focus();
		                        return;
		                    }	
       					Ext.Ajax.request({
	                            url: '<%=request.getContextPath()%>/PrepaidCardMaster.do?param=refundPrepaidCardMasterList',
	                            method: 'POST',
	                            params: { 
	                            	referenceCode: Ext.getCmp('refCode').getValue(),	                                
	                                emailId: Ext.getCmp('emailId1').getValue()                       
	                            },
	                            success: function (response, options) {
	                                var message = response.responseText;
	                                Ext.example.msg(message);
									refundstore.reload();	  
	                               // myWin.hide();
	                               Ext.getCmp('refundButtonId').disable();
	                               
	                               },
	                            failure: function () {
	                                Ext.example.msg("Error");
	                                refundstore.reload();
	                               // myWin.hide();
	                            }
                        	});
	                   }
       				}
       			}
      		},{
       			xtype:'button',
      			text:'<%=cancel%>',
        		id:'refundcancelButtId',
        		iconCls:'cancelbutton',
        		cls:'buttonstyle',
        		width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function()
       					{
       						Ext.getCmp('refCode').reset();	                                
	                        Ext.getCmp('emailId1').reset();
	                        refundstore.removeAll()
       						store.reload();
       						cashBackWin.hide();
       					}
       				}
       			}
      		}]
	});
	
//****************************************************************************Cash Back Inner Panel**************************************************************************************
var cashBackInnerPanel = new Ext.form.FormPanel({
		standardSubmit: true,	
		autoScroll:true,
		width:'100%',
		frame:true,
		id:'cashBackId',
		layout:'table',
		layoutConfig: {columns:9},
		items:[
            	{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryRef'
            	},{
	    		xtype:'label',
	    		cls:'labelstyle',
	    		id:'referencelab',
	    		text:'<%=referenceCode%> :'
	    		},{
	    		xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'Enter Reference Code',
	    		blankText:'Enter Reference Code',
	    		allowBlank:false,
	    		id:'refCode',
	    		listeners: {
                          change: function (field, newValue, oldValue) 
                          {
							refundstore.removeAll();
							Ext.getCmp('refundButtonId').disable();
                          }
                          
                       }
	    		},{width:25},{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryEmail1'
            	},{
	    		xtype:'label',
	    		cls:'labelstyle',
	    		id:'emaillab1',
	    		text:'<%=emailId%> :'
	    		},{
	    		xtype:'textfield',
	    		cls:'textrnumberstyle',
	    		emptyText:'Enter Email Id',
	    		blankText:'Enter Email Id',
	    		allowBlank:false,
	    		id:'emailId1',
	    		},{width:20},{
	    		xtype:'button',
      			text:'<%=validate%>',
        		id:'validateButtId',
        		iconCls:'validatebutton',
        		cls:'buttonstyle',
            	width:80,
       			listeners: 
       			{
        			click:
        			{
       					fn:function(){
       						if (Ext.getCmp('refCode').getValue() == "") {
		                        Ext.example.msg("Enter Reference Code");
		                        Ext.getCmp('refCode').focus();
		                        return;
		                    }
		                    if (Ext.getCmp('emailId1').getValue()== "") {
		                        Ext.example.msg("Enter Email Id");
		                        Ext.getCmp('emailId1').focus();
		                        return;
		                    }	
		                    Ext.Ajax.request({
	                            url: '<%=request.getContextPath()%>/PrepaidCardMaster.do?param=checkReferencecodeAndEmailId',
	                            method: 'POST',
	                            params: { 
	                                referenceCode: Ext.getCmp('refCode').getValue(),	                                
	                                emailId: Ext.getCmp('emailId1').getValue()
	                                },
									    success: function (response, options) {
  	                                    var message = response.responseText;
										if(message=='Reference Code Exists')
										{
											Ext.getCmp('refundButtonId').enable();
											refundstore.load({
											params:{
											referenceCode: Ext.getCmp('refCode').getValue(),
											emailId: Ext.getCmp('emailId1').getValue()
											}
											});	  
										}
										else{
	                                		Ext.example.msg(message);
	                                		//Ext.getCmp('refCode').reset();
	                                		//Ext.getCmp('emailId1').reset();
	                                		
	                               }
	                               },
	                            failure: function () {
	                       		Ext.example.msg("Error");
	                                refundstore.reload();
	                                myWin.hide();
	                           }
	                           
                        	});
       					}
       				}
       				}
       			}]
	    		});

//****************************************************************************Outer panel window for form field**************************************************************************
	var outerPanelWindow=new Ext.Panel({
		cls:'outerpanelwindow',
		standardSubmit: true,
		frame:false,
		items: [innerPanel, winButtonPanel]
	});
//***************************************************************************Store for refund**************************************************************************

    var refundstore = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
                  url: '<%=request.getContextPath()%>/PrepaidCardMaster.do?param=getprepaidCardMasterRefundList',
            method: 'POST'
        }),
       reader: reader1
    });
//***************************************************************************Cash Back Grid**************************************************************************
    
	 cashBackGrid = new Ext.grid.GridPanel({
      id: 'firstGrid',
      ds: refundstore,
      frame: true,
      cm: cols1,
      plugins: [filters1],
      stripeRows: true,
      height: 150,
      width: 880,
      autoScroll: true
  });
	
//****************************************************************************Outer panel For Cash Back***********************************************************************
var cashBackouterPanelWindow=new Ext.Panel({
		cls:'outerpanelwindow',
		standardSubmit: true,
		frame:false,
		items: [cashBackInnerPanel,cashBackGrid,cashBackwinButtonPanel]
	});
	
//****************************************************************************Window For Add and Edit**************************************************************************
	myWin = new Ext.Window({
	    title: 'titelForInnerPanel',
	    closable: false,
	    resizable: false,
	    modal: true,
	    autoScroll: false,
	    frame:true,
	    height: 250,
	    width: 390,
	    id: 'myWin',
	    items: [outerPanelWindow]
	});
//**************************************************************************Window For Cash Back********************************************************************************
cashBackWin = new Ext.Window({
	    title: 'titelForCashBack',
	    closable: false,
	    resizable: false,
	    modal: true,
	    autoScroll: false,
	    frame:true,
	    height: 300,
	    width: 880,
	    id: 'cashBackmyWin',
	    items: [cashBackouterPanelWindow]
	});	
	
	
//****************************************************************************Add Prepaid Card Details**************************************************************************
	function addRecord() {
	    buttonValue = 'Add';
	    titelForInnerPanel = '<%=addPrepaidCardNo%>';
	    myWin.setPosition(460,100);	    	   
	    myWin.setTitle(titelForInnerPanel);	    
	    myWin.show();	    
	  //  Ext.getCmp('cardNo').reset();
    	Ext.getCmp('name').reset();
    	Ext.getCmp('phoneNo').reset();
    	Ext.getCmp('emailId').reset();
    	Ext.getCmp('amount').reset();
    	Ext.getCmp('amount').enable();
	}
	
//****************************************************************************Cash Back Details************************************************************************************
	function cashBackData(){
		titelForCashBack='Prepaid Card Details';
 		cashBackWin.setPosition(280,100);	    	   
	    cashBackWin.setTitle(titelForCashBack);	    
	    cashBackWin.show();
	}


//****************************************************************************Modify Prepaid Card Details**************************************************************************	
	function modifyData(){
	  if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=noRowSelected%>");
        return;
	  }
	  if (grid.getSelectionModel().getCount() > 1) {
	        Ext.example.msg("<%=selectSingleRow%>");
	        return;
	  }
	  buttonValue='modify';
	  title='<%=modifyPrepaidCardNo%>';
	  myWin.setTitle(title);
	  myWin.show();
	  var selected = grid.getSelectionModel().getSelected();
      Ext.getCmp('name').setValue(selected.get('issuedIndex'));
      Ext.getCmp('phoneNo').setValue(selected.get('phoneNoIndex'));
      Ext.getCmp('emailId').setValue(selected.get('emailIdIndex'));
      Ext.getCmp('amount').setValue(selected.get('amountIndex'));
      Ext.getCmp('amount').disable();
	}	
//****************************************************************************Store**************************************************************************	
    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/PrepaidCardMaster.do?param=getprepaidCardMasterList',
            method: 'POST'
        }),
        reader: reader
    });
    
 
//****************************************************************************Grid**************************************************************************
    
    grid = getGrid1('','NoRecordFound',store,screen.width - 40,450,8,filters,'Clear Filter Data',false,'',9,false,'',false,'',true,'Excel',jspName,exportDataType,true,'PDF',true,'Add',true,'Modify',true,'Cash Back');

//****************************************************************************Ext Panel**************************************************************************  	
 
  
   	Ext.onReady(function () {
   	
	    Ext.QuickTips.init();
	    Ext.form.Field.prototype.msgTarget = 'side';
	    
	    outerPanel = new Ext.Panel({
	        title: '<%=prepaidCardMaster%>',
	        renderTo: 'content',
	        standardSubmit: true,
	        frame: true,
	        width: screen.width-22,
	        height:520,
	        cls: 'outerpanel',
	        layout: 'table',
	        layoutConfig: {columns: 1},
	        items: [grid]
	    }); 
	    store.load({params:{jspName:jspName}});  
	});
   	</script>   	
  <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
