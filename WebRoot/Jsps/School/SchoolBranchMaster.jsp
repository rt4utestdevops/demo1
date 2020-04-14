<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="ISO-8859-1"%>
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
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
     
    ArrayList<String> tobeConverted = new ArrayList<String>();
    
   // tobeConverted.add("Branch_Master_Details");
   // tobeConverted.add("Branch_Master");
    tobeConverted.add("Select_School");
    tobeConverted.add("Select_Country");
    tobeConverted.add("Select_State");
    tobeConverted.add("Select_Hub_Name");
    tobeConverted.add("Select_Branch");
    tobeConverted.add("Branch_Information");
    tobeConverted.add("Branch_Name");
    tobeConverted.add("Enter_Branch_ID");
    tobeConverted.add("BranchID");
    tobeConverted.add("Country");  
    tobeConverted.add("State"); 
    tobeConverted.add("City");
    tobeConverted.add("Enter_City_Name");
    tobeConverted.add("Contact_Number");
    tobeConverted.add("Enter_Contact-Number"); 
    tobeConverted.add("Email_ID");
    tobeConverted.add("Enter_Email_Id"); 
    tobeConverted.add("Mobile_No");
    tobeConverted.add("Enter_Mobile_Number");
    tobeConverted.add("Hub_Name"); 
    tobeConverted.add("Created_By"); 
    tobeConverted.add("Created_Time"); 
    tobeConverted.add("Save");
    tobeConverted.add("Cancel");
    tobeConverted.add("Add");
    tobeConverted.add("Select_Single_Row");
    tobeConverted.add("No_Rows_Selected");
    tobeConverted.add("Modify");
    tobeConverted.add("Delete_Branch_Details");
    tobeConverted.add("Are_you_sure_you_want_to_delete");
    tobeConverted.add("SLNO");  
    tobeConverted.add("No_Records_Found");
    tobeConverted.add("PDF");
    tobeConverted.add("Delete");
    
 ArrayList<String> convertedWords = new ArrayList<String>();
 convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
     
    // String BranchMasterDetails=convertedWords.get(0);
    // String BranchMaster=convertedWords.get(1);
     String SelectSchool=convertedWords.get(0);
     String SelectCountry=convertedWords.get(1);
     String SelectState=convertedWords.get(2);
     String SelectHubName=convertedWords.get(3);
     String SelectBranch=convertedWords.get(4);
     String BranchInformation =convertedWords.get(5);
     String BranchName=convertedWords.get(6);
     String EnterBranchID=convertedWords.get(7);
     String BranchID =convertedWords.get(8);
     String Country=convertedWords.get(9);
     String State=convertedWords.get(10);
     String City=convertedWords.get(11);
     String EnterCityName=convertedWords.get(12);
     String ContactNumber=convertedWords.get(13);
     String EnterContactNumber=convertedWords.get(14);
     String EmailId=convertedWords.get(15);
     String EnterEmailId=convertedWords.get(16);
     String MobileNo=convertedWords.get(17);
     String EnterMobileNo=convertedWords.get(18);
     String HubName=convertedWords.get(19);
     String CreatedBy=convertedWords.get(20);
     String CreatedTime=convertedWords.get(21);
     String Save=convertedWords.get(22);
     String Cancel=convertedWords.get(23);
     String Add=convertedWords.get(24);
     String SelectSingleRow=convertedWords.get(25);
     String NoRowsSelected=convertedWords.get(26);
     String Modify=convertedWords.get(27);
     String DeleteBranchDetails=convertedWords.get(28);
     String Areyousureyouwanttodelete=convertedWords.get(29);
     String SLNO=convertedWords.get(30);
     String NoRecordsFound=convertedWords.get(31);
     String PDF=convertedWords.get(32);
     String Delete=convertedWords.get(33);
%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">

		<title><%=BranchInformation%></title>
		<style>
		.x-panel-tl {
			border-bottom: 0px solid !important;
		}
		label {
			display : inline !important;
		}
		.ext-strict .x-form-text {
			height: 21px !important;
		}
		.x-window-tl *.x-window-header {
			height: 41px !important;
		}
</style>

	
		
 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
		<script>

/*******************resize window event function**********************/
Ext.EventManager.onWindowResize(function () {
    var width = '100%';
    var height = '100%';
    grid.setSize(width, height);
    outerPanel.setSize(width, height);
    outerPanel.doLayout();
});
var outerPanel;
var ctsb;
var jspName = "<%=BranchInformation%>";
var exportDataType = "int,String,String,String,String,number,String,float,float,float,String,String";
var selected;
var grid;
var buttonValue;
//****************************************customer store****************************//

var clientcombostore = new Ext.data.JsonStore({
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
                custName=Ext.getCmp('custcomboId').getRawValue();
                hubnamestore.load({
                    		params: {
                        		CustId: <%= customerId %> ,
                        		LTSPId: <%= systemId %>
                    		}
                   });
				
				store.load({
                       params: {
                           CustId: custId,
                           CustName: custName,
                           jspName:jspName
                       }
                   });
                   
                assetgroupcombostore.load({
		               	params:{CustId:Ext.getCmp('custcomboId').getValue()}
		        });
        }
    }
  }
});

//******************************************************************customer Combo******************************************//
 var custnamecombo = new Ext.form.ComboBox({
       store: clientcombostore,
       id: 'custcomboId',
       mode: 'local',
       forceSelection: true,
       emptyText: '<%=SelectSchool%>',
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
                   custId = Ext.getCmp('custcomboId').getValue();
                   custName = Ext.getCmp('custcomboId').getRawValue();
                   
                   hubnamestore.load({
                    		params: {
                        		CustId: custId,
                        		LTSPId: <%= systemId %>
                    		}
                   });
				   store.load({
                       params: {
                           CustId: custId,
                           CustName: custName,
                           jspName:jspName
                       }
                   });
                   
                   assetgroupcombostore.load({
		               	params:{CustId:Ext.getCmp('custcomboId').getValue()}
		           });
                   
           
                   if ( <%= customerId %> > 0) {
                       Ext.getCmp('custcomboId').setValue('<%= customerId %>');
                       custId = Ext.getCmp('custcomboId').getValue();
                       custName = Ext.getCmp('custcomboId').getRawValue();
                       
                       	 hubnamestore.load({
                    		params: {
                        		CustId: <%= customerId %> ,
                        		LTSPId: <%= systemId %>
                    		}
                		 });
                		 
                         store.load({
                           		params: {
                               		CustId: custId,
                               		CustName: custName,
                               		jspName:jspName
                           		}
                       	 });
                       	 
                       	 assetgroupcombostore.load({
		                 	    params:{CustId:Ext.getCmp('custcomboId').getValue()}
		               	 });
                   }
               }
           }
       }
   });

/******store for getting State Name List******/
   var statestore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/SchoolBranchMasterAction.do?param=getStateList',
				   id:'StateStoreId',
			       root: 'StateRoot',
			       autoLoad: false,
				   fields: ['StateID','StateName']
	});
	
	
//***** combo for customername*************/
  var statecombo=new Ext.form.ComboBox({
	        store: statestore,
	        id:'statecomboId',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=SelectState%>',
	        blankText :'<%=SelectState%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	    	valueField: 'StateID',
	    	displayField: 'StateName',
	    	cls:'selectstylePerfect',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
  }}}
  });
  
  /**************store for getting Countrty List******************/
  var countrystore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/SchoolBranchMasterAction.do?param=getCountryNameList',
				   id:'CountryStoreId',
			       root: 'CountryRoot',
			       autoLoad: true,
				   fields: ['CountryID','CountryName']
	});
	
	
//***** combo for countryname
  var countrycombo=new Ext.form.ComboBox({
	        store: countrystore,
	        id:'countrycomboId',
	        mode: 'local',
	        hidden:false,
	        forceSelection: true,
	        emptyText:'<%=SelectCountry%>',
	        blankText :'<%=SelectCountry%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	    	valueField: 'CountryID',
	    	displayField: 'CountryName',
	    	cls:'selectstylePerfect',
	    	listeners: {
		                   select: {
		                 	   fn:function(){
		                 	  
		                 	   Ext.getCmp('statecomboId').reset();
		                 	   statestore.load({
		                 	   params:{
		                 	  		countryId:Ext.getCmp('countrycomboId').getValue()
		                 	  	}
		                 	  });
		                 	   
  }}}
  });
  
  var hubnamestore=new Ext.data.JsonStore({				
	  			 url: '<%=request.getContextPath()%>/SchoolBranchMasterAction.do?param=getHubDetails',  
	  			 id:'hubdetailsstoreId', 
    			 root: 'HubDetailsRoot',
           	 	 autoLoad: false,
    			 remoteSort: true,
    			 fields: ['NAME','VALUE']
				});
		
		//*****************************Store For hubID Ends Here******************************
		
		//*****************************Combo For hubID****************************************
		
  var hubDetailsCombo= new Ext.form.ComboBox({
		store: hubnamestore,
    	id: 'hubdetailscomboId',
    	mode: 'local',
    	forceSelection: true,
    	emptyText: '<%=SelectHubName%>',
    	blankText :'<%=SelectHubName%>',
    	selectOnFocus: true,
    	allowBlank: false,
    	resizable: true,
    	anyMatch: true,
    	typeAhead: false,
    	expandable: true,
    	triggerAction: 'all',
    	lazyRender: true,
    	valueField: 'VALUE',
    	displayField: 'NAME',
    	cls: 'selectstylePerfect',
    	listeners: {
        	select: {
            fn: function () {
           
				
					
            }
        }
    }
	});
	
	//*************Asset Group store********************************************************
      var assetgroupcombostore= new Ext.data.JsonStore({
			url:'<%=request.getContextPath()%>/CommonAction.do?param=getallgroup',
				   id:'GroupStoreId',
			       root: 'GroupRoot',
			       autoLoad: false,
			       remoteSort: true,
				   fields: ['GroupId','GroupName','ActivationStatus']
	  });
  
   //***********************************Asset Group Combo*************************************************
	  var assetgroupcombo=new Ext.form.ComboBox({
	        store: assetgroupcombostore,
	        id:'assetgroupcomboId',
	        mode: 'local',
	        forceSelection: true,
	        emptyText:'<%=SelectBranch%>',
	        selectOnFocus:true,
	        allowBlank: false,
	        anyMatch:true,
            typeAhead: false,
	        triggerAction: 'all',
	        lazyRender: true,
	    	valueField: 'GroupId',
	    	displayField: 'GroupName',
	    	cls:'selectstylePerfect',
	    	listeners: 
	    	{
		         select: 
		         {
		               fn:function()
		               {
		               	   
 					   }
 				 }
 			}
 	  });
	

/*****************************Combo for Customer********************************************/
var comboPanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'traderMaster',
    layout: 'table',
    frame: false,
    width: screen.width - 100,
    height: 40,
    layoutConfig: {
        columns: 3
    },
    items: [{
            xtype: 'label',
            text: '<%=SelectSchool%>' + ' :',
            cls: 'labelstyle'
        },
        custnamecombo,{
        width:80
        }
    ]
});


/*********************inner panel for displaying form field in window***********************/
var innerPanelForUnitDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 320,
    width: 381,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 2,
        id: 'addpanelid',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryBranchNameid'
            },
        	{
                xtype: 'label',
                text: '<%=BranchID%>' + ':',
                cls: 'labelstyle',
                id: 'BranchNameid'
            },{
                xtype: 'textfield',
                allowBlank: false,
                allowDecimals: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterBranchID%>',
                blankText: '<%=EnterBranchID%>',
                id: 'BranchNameId'
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryassetgroupId'
            },{
                xtype: 'label',
                text: '<%=BranchName%>' + ':',
                cls: 'labelstyle',
                id: 'assetgroupId'
            },assetgroupcombo,{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorycountryId'
            },{
                xtype: 'label',
                text: '<%=Country%>' + ':',
                cls: 'labelstyle',
                id: 'countryId'
            },countrycombo,{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryStateId'
            },{
                xtype: 'label',
                text: '<%=State%>' + ':',
                cls: 'labelstyle',
                id: 'StateId'
            },statecombo,{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryCityid'
            },{
                xtype: 'label',
                text: '<%=City%>' + ':',
                cls: 'labelstyle',
                id: 'Cityid'
            },{
                xtype: 'textfield',
                cls: 'selectstylePerfect',
                maskRe: /[a-zA-Z ,.]/,
                emptyText: '<%=EnterCityName%>',
                blankText: '<%=EnterCityName%>',
                id: 'CityId'
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '<%=ContactNumber%>' + ':',
                cls: 'labelstyle',
                id: 'ContactNumberid'
            },{
                xtype: 'textfield',
                allowDecimals: false,
                maskRe: /[0-9]/,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterContactNumber%>',
                blankText: '<%=EnterContactNumber%>',
                id: 'ContactNumberId'
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '<%=EmailId%>' + ':',
                cls: 'labelstyle',
                id: 'EmailIdid'
            },{
                xtype: 'textfield',
                regex: /^([\w\-\'\-]+)(\.[\w-\'\-]+)*@([\w\-]+\.){1,5}([A-Za-z]){2,4}$/,
                regexText:'Enter valid email format eg,(XXXXX@com)',
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterEmailId%>',
                blankText: '<%=EnterEmailId%>',
                id: 'EmailIdId'
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryMobileid'
            },{
                xtype: 'label',
                text: '<%=MobileNo%>' + ':',
                cls: 'labelstyle',
                id: 'Mobileid'
            },  {
                xtype: 'textfield',
                allowBlank: false,
                allowDecimals: false,
                maskRe: /[0-9]/,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterMobileNo%>',
                blankText: '<%=EnterMobileNo%>',
                id: 'MobileId'
            }, {
                xtype: 'label',
                text: ''
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryhubdetailsId'
            }, {
                xtype: 'label',
                text: '<%=HubName%>' + ':',
                cls: 'labelstyle',
                id: 'hubdetailsId'
            }, hubDetailsCombo , {
                xtype: 'label',
                text: ''
            }
        ]
    }]
});

/********************************button**************************************/
var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 381,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        iconCls:'savebutton',
        id: 'addButtId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function () {
					
                   	if (Ext.getCmp('BranchNameId').getValue() == "") {
                        Ext.example.msg("<%=EnterBranchID%>");
                	    Ext.getCmp('BranchNameId').focus();
                	    return;
              		}
              		
              		if (Ext.getCmp('assetgroupcomboId').getValue() == "") {
                        Ext.example.msg("<%=SelectBranch%>");
                	    Ext.getCmp('assetgroupcomboId').focus();
                	    return;
              		}
			   if (Ext.getCmp('countrycomboId').getValue() == "") {
                   Ext.example.msg("<%=SelectCountry%>");
                   Ext.getCmp('countrycomboId').focus();
                   return;
              }
			   if (Ext.getCmp('statecomboId').getValue() == "") {
                   Ext.example.msg("<%=SelectState%>");
                   Ext.getCmp('statecomboId').focus();
                   return;
              }
			   if (Ext.getCmp('CityId').getValue() == "") {
                   Ext.example.msg("<%=EnterCityName%>");
                   Ext.getCmp('CityId').focus();
                   return;
              }
              if (Ext.getCmp('MobileId').getValue() == "") {
                   Ext.example.msg("<%=EnterMobileNo%>");
                   Ext.getCmp('MobileId').focus();
                   return;
              }
			   if (Ext.getCmp('hubdetailscomboId').getValue() == "") {
                   Ext.example.msg("<%=SelectHubName%>");
                   Ext.getCmp('hubdetailscomboId').focus();
                   return;
              }
              
                    if (innerPanelForUnitDetails.getForm().isValid()) {
                         var selected;
                         var uniqueId;
                        if (buttonValue == 'modify') {
                            selected = grid.getSelectionModel().getSelected();
                            uniqueId= selected.get('IdDataIndex');
                           // alert(selected.get('assetNumberDataIndex'));
                           // alert(uniqueId);
                        }
                        Ext.getCmp('addButtId').disable();
                        Ext.getCmp('canButtId').disable();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SchoolBranchMasterAction.do?param=saveBranchMasterDetailsInformation',
                            method: 'POST',
                            params: {
                            	  UniqueId:uniqueId,
                                  custId:Ext.getCmp('custcomboId').getValue(),
                                  buttonValue: buttonValue,
                                  BranchName: Ext.getCmp('BranchNameId').getValue(),
                                  GroupID: Ext.getCmp('assetgroupcomboId').getValue(),
                                  country: Ext.getCmp('countrycomboId').getValue(),
                                  State: Ext.getCmp('statecomboId').getValue(),
                                  City: Ext.getCmp('CityId').getValue(),
                                  ContactNumber: Ext.getCmp('ContactNumberId').getValue(),
                                  EmailId: Ext.getCmp('EmailIdId').getValue(),
                                  Mobile: Ext.getCmp('MobileId').getValue(),
                                  HubId: Ext.getCmp('hubdetailscomboId').getValue()
                            },
                              success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin1.hide();
                                 store.reload({
                                    params: {
                                    CustId: custId,
                                    CustName: custName,
                                    jspName:jspName
                                    }
                                  });
                                  	Ext.getCmp('BranchNameId').reset();
                                  	Ext.getCmp('assetgroupcomboId').reset();
							        Ext.getCmp('countrycomboId').reset();
							        Ext.getCmp('statecomboId').reset();
							        Ext.getCmp('CityId').reset();
									Ext.getCmp('ContactNumberId').reset();
							        Ext.getCmp('EmailIdId').reset();
							        Ext.getCmp('MobileId').reset();
							        Ext.getCmp('hubdetailscomboId').reset();
									
									Ext.getCmp('addButtId').enable();
									Ext.getCmp('canButtId').enable();
                                   outerPanelWindow.getEl().unmask();
                            },
                            failure: function () {
                                Ext.example.msg("Failed to Insert...");
                                store.reload();
                                 Ext.getCmp('addButtId').enable();
                                 Ext.getCmp('canButtId').enable();
                                myWin1.hide();
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
                    myWin1.hide();
                    Ext.getCmp('BranchNameId').reset();
                    Ext.getCmp('assetgroupcomboId').reset();
			        Ext.getCmp('countrycomboId').reset();
			        Ext.getCmp('statecomboId').reset();
			        Ext.getCmp('CityId').reset();
					Ext.getCmp('ContactNumberId').reset();
			        Ext.getCmp('EmailIdId').reset();
			        Ext.getCmp('MobileId').reset();
			        Ext.getCmp('hubdetailscomboId').reset();
                }
            }
        }
    }]
});
/***********panel contains window content info***************************/
var outerPanelWindow = new Ext.Panel({
    //width:540,
    cls: 'outerpanelwindow',
    standardSubmit: true,
    frame: false,
    items: [innerPanelForUnitDetails, innerWinButtonPanel]
});
/***********************window for form field****************************/
myWin1 = new Ext.Window({
    title: 'titel',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: '',
    //height : 400,
    width: 395,
    id: 'myWin1',
    items: [outerPanelWindow]
});


//***********************************function for add button in grid that will open form window**************************************************//
function addRecord() {

	if (Ext.getCmp('custcomboId').getValue() == "") {
	    Ext.example.msg("Select Customer");
        Ext.getCmp('custcomboId').focus();
        return;
    }
    buttonValue = "add";
    titel = '<%=Add%>';
    myWin1.show();
        Ext.getCmp('BranchNameId').reset();
        Ext.getCmp('assetgroupcomboId').reset();
        Ext.getCmp('countrycomboId').reset();
        Ext.getCmp('statecomboId').reset();
        Ext.getCmp('CityId').reset();
		Ext.getCmp('ContactNumberId').reset();
        Ext.getCmp('EmailIdId').reset();
        Ext.getCmp('MobileId').reset();
        Ext.getCmp('hubdetailscomboId').reset();
        
    myWin1.setTitle(titel);
	
}
//**************************************function for modify button in grid that will open form window*********************************************//
function modifyData() {
    if (grid.getSelectionModel().getCount() > 1) {
         Ext.example.msg("<%=SelectSingleRow%>");
         return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    buttonValue = "modify";
    titelForInnerPanel = '<%=Modify%>';
    custId = Ext.getCmp('custcomboId').getValue();
    var selected = grid.getSelectionModel().getSelected();
    statestore.load({
		     params:{
		            countryId:selected.get('ModifyCountryIDDataIndex')
		         },
		                 	    
         	 callback: function () {
           		myWin1.setPosition(450, 150);
            	myWin1.setTitle(titelForInnerPanel);
            	myWin1.show();
            	Ext.getCmp('BranchNameId').setValue(selected.get('BranchNameDataIndex'));
            	Ext.getCmp('assetgroupcomboId').setValue(selected.get('ModifyGroupIDDataIndex'));
            	Ext.getCmp('countrycomboId').setValue(selected.get('ModifyCountryIDDataIndex'));
            	Ext.getCmp('statecomboId').setValue(selected.get('ModifyStateIDDataIndex'));
            	Ext.getCmp('CityId').setValue(selected.get('CityDataIndex'));
				Ext.getCmp('ContactNumberId').setValue(selected.get('ContactNumberDataIndex'));
				Ext.getCmp('EmailIdId').setValue(selected.get('EmailIdDataIndex'));
				Ext.getCmp('MobileId').setValue(selected.get('MobileDataIndex'));
				Ext.getCmp('hubdetailscomboId').setValue(selected.get('ModifyHubIDDataIndex'));
       	 	}
        });
}
//******************function for delete button in grid that will open form window********************************//
function deleteData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    Ext.Msg.show({
        title: '<%=DeleteBranchDetails%>',
        msg: '<%=Areyousureyouwanttodelete%>',
        progressText: 'Deleting  ...',
        buttons: {
            yes: true,
            no: true
        },
        fn: function (btn) {
            switch (btn) {
            case 'yes':
                var selected = grid.getSelectionModel().getSelected();
                var uniqueId=selected.get('IdDataIndex');
                var custId = Ext.getCmp('custcomboId').getValue();
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/SchoolBranchMasterAction.do?param=deleteBranchMasterDetails',
                    method: 'POST',
                    params: {
                        UniqueId:uniqueId,
                        CustId:custId
                    },
                    success: function (response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                       store.reload();
                    },
                    failure: function () {
                        Ext.example.msg("Error");
                        store.reload();
                        outerPanelWindow.getEl().unmask();

                    }
                });

                break;
            case 'no':
                Ext.example.msg("No Rows Deleted...");
                break;

            }
        }
    });
}


//***************************jsonreader****************************************************************//
var reader = new Ext.data.JsonReader({
    root: 'BranchMasterDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoDataIndex'
    },{
        name: 'GroupIDDataIndex'
    },{
        name: 'ModifyGroupIDDataIndex'
    },{
        name: 'BranchNameDataIndex'
    },{
        name: 'CountryDataIndex'
    },{
        name: 'ModifyCountryIDDataIndex'
    },{
        name: 'StateDataIndex'
    },{
        name: 'ModifyStateIDDataIndex'
    },{
        name: 'CityDataIndex'
    },{
        name: 'ContactNumberDataIndex'
    },{
        name: 'EmailIdDataIndex'
    },{
        name: 'MobileDataIndex'
    },{
        name: 'HubIDDataIndex'
    },{
        name: 'ModifyHubIDDataIndex'
    },{
        name: 'createdNameDataIndex'
    },{
        name: 'createdTimeDataIndex'
    },{
        name: 'IdDataIndex'
    }]
});

//************************* store configs****************************************//
var store = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
       url: '<%=request.getContextPath()%>/SchoolBranchMasterAction.do?param=getBranchMasterDetails',
        method: 'POST'
    }),
     remoteSort: false,
    sortInfo: {
        field: 'BranchNameDataIndex',
        direction: 'asc'
    },
    bufferSize: 700,
    reader: reader
});
//****************************grid filters*************************************************//
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            dataIndex: 'slnoDataIndex',
             type: 'numeric'
        }, {
            dataIndex: 'BranchNameDataIndex',
            type: 'String'
        },  {
            dataIndex: 'GroupIDDataIndex',
            type: 'String'
        }, {
            dataIndex: 'CountryDataIndex',
            type: 'String'
        }, {
            dataIndex: 'StateDataIndex',
            type: 'String'
        }, {
            dataIndex: 'CityDataIndex',
            type: 'String'
        }, {
            dataIndex: 'ContactNumberDataIndex',
            type: 'String'
        }, {
            dataIndex: 'EmailIdDataIndex',
            type: 'String'
        }, {
            dataIndex: 'MobileDataIndex',
            type: 'String'
        }, {
            dataIndex: 'HubIDDataIndex',
            type: 'int'
        }, {
            dataIndex: 'createdNameDataIndex',
            type: 'string'
        }, {
        	dataIndex: 'createdTimeDataIndex',
         	type: 'string'
     	}
    ]
});
//****************column Model Config***************************************************//
var createColModel = function (finish, start) {

     var columns = [
         new Ext.grid.RowNumberer({
             header: "<span style=font-weight:bold;><%=SLNO%></span>",
             width: 50
         }), {
             dataIndex: 'slnoDataIndex',
             hidden: true,
             header: "<span style=font-weight:bold;><%=SLNO%></span>",
             width: 100,
             filter: {
                 type: 'numeric'
             }
			},{
            header: "<span style=font-weight:bold;><%=BranchID%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'BranchNameDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=BranchName%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'GroupIDDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=Country%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'CountryDataIndex',
            filter: {
                type: 'String'
            }
        }, {
            header: "<span style=font-weight:bold;><%=State%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'StateDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=City%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'CityDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=ContactNumber%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'ContactNumberDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=EmailId%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'EmailIdDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=MobileNo%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'MobileDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=HubName%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'HubIDDataIndex',
            filter: {
                type: 'int'
            }
        },{
             header: "<span style=font-weight:bold;><%=CreatedBy%></span>",
             hidden: false,
             dataIndex: 'createdNameDataIndex',
             filter: {
                 type: 'string'
             }
         }, {
             header: "<span style=font-weight:bold;><%=CreatedTime%></span>",
             hidden: false,
             width: 155,
             dataIndex: 'createdTimeDataIndex',
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
//*****************************************grid**********************************************//

grid = getGrid('<%=BranchInformation%>', '<%=NoRecordsFound%>', store, screen.width - 36, 475, 20, filters,'', false, '', 20, false, '', false, '', false, '', jspName, exportDataType, false, '<%=PDF%>', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');

//*****main starts from here*******************************************************************//
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 120000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
        columns: 1
         },
        items: [comboPanel,grid]
    });
    //store.load();
});
</script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>