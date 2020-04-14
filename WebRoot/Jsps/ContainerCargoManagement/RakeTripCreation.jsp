<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"+ request.getServerName() + ":" + request.getServerPort()+ path + "/";
	if(request.getParameter("list")!=null)
	{
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
	String feature="1";
	if(session.getAttribute("responseaftersubmit")!=null){
	   	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
		session.setAttribute("responseaftersubmit",null);
	}
		
    LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
	String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();

%>
<jsp:include page="../Common/header.jsp" />
 		<title>Trip Creation</title>		
    
  <style>
  	.x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  
    <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   	<jsp:include page="../Common/ExportJS.jsp" />
	<% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}						
			.x-menu-list {
				height:auto !important;
			}				
			.x-window-tl *.x-window-header {			
				height : 38px !important;
			}
			fieldset#AssociateLocationId {
				width : 630px !important;
			}
			.x-table-layout-ct {
				overflow : hidden !important;
			}
		</style>
	 <%}%>
   	
   <script>
   
var outerPanel;
var ctsb;
var jspName = "";
var exportDataType = "";
var selected;
var grid;
var buttonValue;
var titelForInnerPanel;
var myWin;
var myInnerWin;
var selectedVehicles = "-";
var selectedRouteId = null;
var selectedName = null;
var selectedType = null;
var innergrid;
var myViewAllocationWin;
var myViewAllcoationgrid;
var outerPanelWindow;

var myAddCashWindow;
var myAddFuelAmtWindow;

 var sm = new Ext.grid.CheckboxSelectionModel({});
var BranchNameCombostore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/RakeTripCreationAction.do?param=getBranchNames',
				   id:'branchNameStoreId',
			       root: 'branchNameRoot',
			       remoteSort:true,
			       autoLoad: true,
				   fields: ['branchId','branchName']	
			     });


var vehicleTypeCombostore = new Ext.data.SimpleStore({
    id: 'vehicleTypeStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['TDP Vehicle', 'TDP Vehicle'],
        ['Market Vehicle', 'Market Vehicle']
   	 ]
});

var MarketVehicleStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/RakeTripCreationAction.do?param=getOwnerName',
				   id:'RegOwnerStoreId',
			       root: 'RegOwnerStoreRoot',
			       remoteSort:true,
				   fields: ['RegNo']
			     });

var BranchNameCombo = 	new Ext.form.ComboBox({
				  frame:true,
				  store: BranchNameCombostore,
				  id:'BranchNameComboId',
				  width: 175,
				  forceSelection:true,
				  emptyText:'Select BranchName',
				  anyMatch:true,
				  allowBlank: false,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  resizable:true,
				  triggerAction: 'all',
				  displayField: 'branchName',
				  valueField: 'branchId',
				  listeners: {
		                select: {
		                 	 fn:function(){
		                 	 		//DriverStore.load({ params:{VehicleNo:VehicleTypeId}});
		                 	 		BranchNameComboId = Ext.getCmp('BranchNameComboId').getValue();
		                 	 		 Ext.getCmp('vehicleTypeId').reset();
		                 	 		 
                	   				 }
                  				}
	       					}
	       });


var VehicleType = new Ext.form.ComboBox({
    store: vehicleTypeCombostore,
    id: 'vehicleTypeId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Vehicle Type',
    blankText: 'Select Vehicle Type',
    selectOnFocus: true,
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'Value',
    displayField: 'Name',
    cls: 'selectstylePerfect',
    listeners: {
		                select: {
		                 	 fn:function(){
	                 				VehicleTypeId = Ext.getCmp('vehicleTypeId').getValue();
	                 				VehicleTypeName = Ext.getCmp('vehicleTypeId').getRawValue();
	                 				BranchNameComboId = Ext.getCmp('BranchNameComboId').getValue();
	                 				if(BranchNameComboId=="")
	                 				{
	                 					Ext.example.msg("Select BranchName");
						    			return;
	                 				}
	                 				//alert(BranchNameComboId);
	                 				VehicleNoStore.load({ params:{VehicleType:VehicleTypeId}});
	                 				store.load({
                    					params: {
                        					jspName : jspName,
                        					VehicleTypeName : VehicleTypeName,
                        					BranchNameComboId: BranchNameComboId
                    					}		
                				});
                				if(VehicleTypeName =='Market Vehicle')
                				{
             						 Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(7, false);
                					 Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(8, false);
                					 Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(9, false);
                					 Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(10, false);
                				}
                				else if(VehicleTypeName =='TDP Vehicle')
                				{
                					 Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(7, true);
                					 Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(8, true);
                					 Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(9, true);
                					 Ext.getCmp('outerPanel').items.items[1].getColumnModel().setHidden(10, true);
                				}
                			}
                	    }
                  }
   
});

var vehicleTypePanel = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'vehicleTypePanelId',
    layout: 'table',
    frame: false,
    width: screen.width - 12,
    height: 40,
    layoutConfig: {
        columns: 5
    },
    items: [
    		{
            xtype: 'label',
            text: 'Branch Name' + ' :',
            cls: 'labelstyle'
        },
    
        BranchNameCombo,
        {width:30},
        
    		{
            xtype: 'label',
            text: 'Trip Type' + ' :',
            cls: 'labelstyle'
        },
        VehicleType
    ]
});

  var VehicleNoStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/RakeTripCreationAction.do?param=getVehicleNumber',
				   id:'VehicleNoStoreId',
			       root: 'VehicleNoRoot',
			       remoteSort:true,
			       autoLoad: true,
				   fields: ['VehicleNo']
			     });
 
 var TPTStore= new Ext.data.JsonStore({
				   url:'<%=request.getContextPath()%>/RakeTripCreationAction.do?param=getTPTNames',
				   id:'TPTStoreId',
			       root: 'TPTRoot',
			       autoLoad: true,
			       remoteSort:true,
				   fields: ['Transportersid','Transportersname']
			     })
 
 var DriverStore = new Ext.data.JsonStore({
 						url:'<%=request.getContextPath()%>/RakeTripCreationAction.do?param=getDriverName',
 						id:'DriverStoreId',
 						root:'DriverRoot',
 						autoLoad: false,
 						remoreSort: true,
 						fields: ['DriverName']
 						});
 

var VehicleCombo = 	new Ext.form.ComboBox({
				  frame:true,
				  store: VehicleNoStore,
				  id:'VehicleCmboId',
				  width: 175,
				  forceSelection:true,
				  emptyText:'Select Vehicle No',
				  anyMatch:true,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  resizable:true,
				  triggerAction: 'all',
				  displayField: 'VehicleNo',
				  valueField: 'VehicleNo',
				  listeners: {
		                select: {
		                 	 fn:function(){
		                 	 		//DriverStore.load({ params:{VehicleNo:VehicleTypeId}});
	                 				VehicleCmboId = Ext.getCmp('VehicleCmboId').getValue();
	                 				 globalClientId = <%=customerId%>, 
	                 				DriverStore.load({ 
	                 				params:{VehicleNo:VehicleCmboId},
	                 				 callback: function() {
                                                            var rec = DriverStore.getAt(0);
                                                          
                                                            if (rec != null) {
                                                                //subTripGridRec.set('DistanceDI', rec.data['distance']);
                                                                Ext.getCmp('DriverNameTextId').setValue(rec.data['DriverName']);
                                                            } else {
                                                               // subTripGridRec.set('DistanceDI', '0');
                                                               Ext.getCmp('DriverNameTextId').setValue("NA");
                                                            }
                                                        }
                                                        });
                                   MarketVehicleStore.load({params:{ClientId: globalClientId,MarketVehicleId: VehicleCmboId},
								    callback:function()
									{
										var rec = MarketVehicleStore.getAt(0);
										if(rec!=null)
										{
											 Ext.getCmp('ownernameTextId').setValue(rec.data['RegNo']);
										}
										else
										{
											 Ext.getCmp('ownernameTextId').setValue("");
										}
									}
									});
									
                			}
                	    }
                  }
	       });
 
 var TPTCombo =   new Ext.form.ComboBox({
				  frame:true,
				  store: TPTStore,
				  id:'TPTComboId',
				  width: 175,
				  forceSelection:true,
				  emptyText:'Select Market Transport',
				  anyMatch:true,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  resizable:true,
				  triggerAction: 'all',
				  displayField: 'Transportersname',
				  valueField: 'Transportersid',
				  listeners: {
		                select: {
		                 	 fn:function(){
	                 				TransportId = Ext.getCmp('TPTComboId').getValue();
	                 				
                			}
                	    }
					}
	       }); 

 			/*var DriverCombo =  new Ext.form.ComboBox({
				  frame:true,
				  store: DriverStore,
				  id:'DriverComboId',
				  width: 175,
				  forceSelection:true,
				  emptyText:'Select Driver ',
				  anyMatch:true,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  resizable:true,
				  triggerAction: 'all',
				  displayField: 'DriverComboId',
				  valueField: 'Transportersid',
				  value: 'Select TPT',
				  listeners: {
		                select: {
		                 	 fn:function(){
	                 				DriverComboId = Ext.getCmp('DriverComboId').getValue();
                			}
                	    }
					}
	       });*/ 

var innerPanelForTripCreation = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 215,
    width: 650,
    frame: false,
    id: 'innerPanelForTripCreationId',
    layout: 'table',
    layoutConfig: {
        columns: 8
    },
    items: [{
        xtype: 'fieldset',
        title: 'Trip Creation Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 6, 
        id: 'AssociateLocationId',
        width: 640,
        height: 190,
        layout: 'table',
        layoutConfig: {
            columns: 8
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'mid1'
        }, {
            xtype: 'label',
            text: 'Vehicle No ' + ' :',
            cls: 'labelstyle',
            id: 'VehicleNOLabelId'
        } ,
      	 VehicleCombo,
        { width: 20 },{
            	xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'mandatoryDriverName'
            },
        {
        	xtype: 'label',
            text: 'Driver Name ' + ' :',
            cls: 'labelstyle',
            id: 'DriverNameLabelId'
        }, {
        		xtype: 'textfield',
            	text: '',
            	cls: 'labelstyle',
            	id: 'DriverNameTextId'
        	}, {height : 30},
        	{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'ownernamemid'
        	}, {
            xtype: 'label',
            text: 'Owner Name' + ' :',
            cls: 'labelstyle',
            id: 'ownerNameId'
       	 },  
       	 {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            id: 'ownernameTextId',
            mode: 'local',
             readOnly: true,
            forceSelection: true,
            selectOnFocus: true,
            allowBlank: false,
            listeners: {
               	 change: function(field, newValue, oldValue) {
                    field.setValue(newValue.toUpperCase().trim());
                }
            }
        	},{},{
        		xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'driverContId'
        	},{
        		xtype: 'label',
        	  	text: 'Driver Contact' + ' :',
        	 	cls: 'labelstyle',
        	  	id: 'driverContactLabelId'
        	},{
        		xtype: 'numberfield',
	        	allowNegative: false,
	            cls: 'selectstylePerfect',
	            id: 'driverContactId',
	            mode: 'local',
	            forceSelection: true,
	            emptyText: 'Enter Driver Contact',
	            blankText: 'Enter Driver Contact',
	            selectOnFocus: true,
	            allowBlank: false
        	
        	},{height : 30},
            {
            	xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'TPTNoid'
            }, {
	            	xtype: 'label',
	        	  	text: 'TPT Name' + ' :',
	        	  	cls: 'labelstyle',
	        	  	id: 'TPTLabelId'
	            },
             TPTCombo,
        	 {},{
        	 	xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'dlNumber'
        	 },{
        	 	xtype: 'label',
        	  	text: 'DL No' + ' :',
        	  	cls: 'labelstyle',
        	  	id: 'dlLabelNumber'
        	 },{
        	 	xtype: 'numberfield',
	            allowNegative: false,
	            cls: 'selectstylePerfect',
	            id: 'drivingLicenceId',
	            mode: 'local',
	            forceSelection: true,
	            emptyText: 'Enter Driving License No',
	            blankText: 'Enter Driving License No',
	            selectOnFocus: true,
	            allowBlank: false
        	 }
        ]
    }]
});

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 650,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Save',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() 
                {
		                    if(Ext.getCmp('vehicleTypeId').getValue()=="")
						    {
						    	Ext.example.msg("Vehicle Type not Selected");
						    	return;
						    }
						 if(Ext.getCmp('vehicleTypeId').getValue()=="TDP Vehicle")
						 {
		                    if (Ext.getCmp('VehicleCmboId').getValue() == "Select Vehicle")
		                    {
		                 	   Ext.example.msg("Select Vehicle Number");
		                        return;
		                    }
		                    if(Ext.getCmp('DriverNameTextId').getValue()=="")
		                    {
		                    	 Ext.example.msg("Driver Name is required");
		                        return;
		                    }
		                 }
		                 else if(Ext.getCmp('vehicleTypeId').getValue()=="Market Vehicle")
		                 { 
		                 	if (Ext.getCmp('VehicleCmboId').getValue() == "Select Vehicle No")
		                    { 
		                 	   Ext.example.msg("Select Vehicle Number");
		                        return;
		                    }
		                    if (Ext.getCmp('ownernameTextId').getValue() == "" )
		                    {
		                    	Ext.example.msg("Enter Owner Name");
		                    	return;
		                    }
		                    if(Ext.getCmp('driverContactId').getValue()==""){
		                    	Ext.example.msg("Enter Driver Contact No");
		                    	return;
		                    }
		                    if(Ext.getCmp('TPTComboId').getValue()==""||Ext.getCmp('TPTComboId').getValue()=="Select TPT")
		                    {
		                    	Ext.example.msg("Select TPT Name");
		                    	return;
		                    }
		                    if(Ext.getCmp('drivingLicenceId').getValue()=="")
		                    {
		                    	Ext.example.msg("Enter Driving License Number");
		                    	return;
		                    }
		                 } 
		                var selected = grid.getSelectionModel().getSelected();
						var uniqueId;
						if(buttonValue == "Modify"){
								   id = selected.get('uniqueIdDataIndex');
						}
		                    Ext.Ajax.request({
                        
                            url: '<%=request.getContextPath()%>/RakeTripCreationAction.do?param=AddorModify',
                            method: 'POST',
                            params: 
                            {
                                buttonValue: buttonValue,
                               // uniqueId:uniqueId,
                                VehicleCmboId: Ext.getCmp('VehicleCmboId').getValue(),
                                vehicleTypeId: Ext.getCmp('vehicleTypeId').getValue(),
                                BranchNameComboId: Ext.getCmp('BranchNameComboId').getValue(),
                                DriverNameTextId:Ext.getCmp('DriverNameTextId').getValue(),
                                ownernameTextId: Ext.getCmp('ownernameTextId').getValue(),
                                driverContactId: Ext.getCmp('driverContactId').getValue(),
                                TPTComboId: Ext.getCmp('TPTComboId').getValue(), 
                                drivingLicenceId: Ext.getCmp('drivingLicenceId').getValue(),
                                id: id
                            },
                           		success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('VehicleCmboId').reset();
                                Ext.getCmp('vehicleTypeId').reset();
                                Ext.getCmp('DriverNameTextId').reset();
                                Ext.getCmp('ownernameTextId').reset();
                                Ext.getCmp('driverContactId').reset();
                                Ext.getCmp('TPTComboId').reset();
                                Ext.getCmp('drivingLicenceId').reset();
                                
                                myWin.hide();
                                routeMasterOuterPanelWindow.getEl().unmask();
                                grid.store.reload();
                                
                            },
                           	failure: function() {
                                Ext.example.msg("Error");
                                grid.store.reload();
                                myWin.hide();
                            }
                        });
                    }
                }
            }
        }
    	, {
        xtype: 'button',
        text: 'Cancel',
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

var routeMasterOuterPanelWindow = new Ext.Panel({
    width: 660,
    height: 295,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForTripCreation, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 355,
    width: 670,
    id: 'myWin',
    items: [routeMasterOuterPanelWindow]
});

function addRecord() {
    
    buttonValue = 'Add';
    titelForInnerPanel = 'Trip Creation Information';
    if(Ext.getCmp('BranchNameComboId').getValue()=="")
    {
    	Ext.example.msg("Select Branch Name");
    	return;
    }
    if(Ext.getCmp('vehicleTypeId').getValue()=="")
    {
    	Ext.example.msg("Select Vehicle Type");
    	return;
    }
    myWin.setPosition(450, 170);
    myWin.show();
    //  myWin.setHeight(350);
    Ext.getCmp('VehicleCmboId').reset();
    Ext.getCmp('ownernameTextId').reset();
    Ext.getCmp('driverContactId').reset();
    Ext.getCmp('TPTComboId').reset();
    Ext.getCmp('drivingLicenceId').reset();
    Ext.getCmp('DriverNameTextId').reset();
    
    if(Ext.getCmp('vehicleTypeId').getValue() == "TDP Vehicle")
    {
     Ext.getCmp('ownernamemid').hide();
     Ext.getCmp('ownerNameId').hide();
     Ext.getCmp('ownernameTextId').hide();
     Ext.getCmp('driverContId').hide();
     Ext.getCmp('driverContactLabelId').hide();
     Ext.getCmp('driverContactId').hide();
     Ext.getCmp('TPTComboId').hide();
     Ext.getCmp('TPTNoid').hide();
     Ext.getCmp('TPTLabelId').hide();
     Ext.getCmp('dlNumber').hide();
     Ext.getCmp('dlLabelNumber').hide();
     Ext.getCmp('drivingLicenceId').hide();
     Ext.getCmp('DriverNameTextId').setReadOnly(true);
     
    }
    else  if(Ext.getCmp('vehicleTypeId').getValue() == "Market Vehicle")
    {
    	
	     Ext.getCmp('mid1').show();
	     Ext.getCmp('VehicleNOLabelId').show();
	     Ext.getCmp('VehicleCmboId').show();
	     Ext.getCmp('DriverNameLabelId').show();
	     Ext.getCmp('ownernamemid').show();
    	 Ext.getCmp('ownerNameId').show();
    	 Ext.getCmp('ownernameTextId').show();
     	 Ext.getCmp('driverContId').show();
    	 Ext.getCmp('driverContactLabelId').show();
    	 Ext.getCmp('driverContactId').show();
     	 Ext.getCmp('TPTComboId').show();
         Ext.getCmp('TPTNoid').show();
         
     	 Ext.getCmp('TPTLabelId').show();
     	 Ext.getCmp('dlNumber').show();
         Ext.getCmp('dlLabelNumber').show();
     	 Ext.getCmp('drivingLicenceId').show();
     	 Ext.getCmp('DriverNameTextId').setReadOnly(false);
    }
    myWin.setTitle(titelForInnerPanel);
}

function modifyData() {
  
    if (grid.getSelectionModel().getCount() == 0) {
     Ext.example.msg("No Rows are Selected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
     Ext.example.msg("Select One Row At a time");
        return;
    }
    buttonValue = 'Modify';
    titelForInnerPanel = 'Modify Trip Creation';
    myWin.setPosition(450, 150);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    
    Ext.getCmp('VehicleCmboId').reset();
    Ext.getCmp('ownernameTextId').reset();
    Ext.getCmp('driverContactId').reset();
    Ext.getCmp('TPTComboId').reset();
    Ext.getCmp('drivingLicenceId').reset();
    Ext.getCmp('DriverNameTextId').reset();
    
    if(Ext.getCmp('vehicleTypeId').getValue() == "TDP Vehicle")
    {
     Ext.getCmp('ownernamemid').hide();
     Ext.getCmp('ownerNameId').hide();
     Ext.getCmp('ownernameTextId').hide();
     Ext.getCmp('driverContId').hide();
     Ext.getCmp('driverContactLabelId').hide();
     Ext.getCmp('driverContactId').hide();
     Ext.getCmp('TPTComboId').hide();
     Ext.getCmp('TPTNoid').hide();
     Ext.getCmp('TPTLabelId').hide();
     Ext.getCmp('dlNumber').hide();
     Ext.getCmp('dlLabelNumber').hide();
     Ext.getCmp('drivingLicenceId').hide();
     Ext.getCmp('DriverNameTextId').setReadOnly(true);
     
    }
    else  if(Ext.getCmp('vehicleTypeId').getValue() == "Market Vehicle")
    {
    	
	     Ext.getCmp('mid1').show();
	     Ext.getCmp('VehicleNOLabelId').show();
	     Ext.getCmp('VehicleCmboId').show();
	     Ext.getCmp('DriverNameLabelId').show();
	     Ext.getCmp('ownernamemid').show();
    	 Ext.getCmp('ownerNameId').show();
    	 Ext.getCmp('ownernameTextId').show();
     	 Ext.getCmp('driverContId').show();
    	 Ext.getCmp('driverContactLabelId').show();
    	 Ext.getCmp('driverContactId').show();
     	 Ext.getCmp('TPTComboId').show();
         Ext.getCmp('TPTNoid').show();
         
     	 Ext.getCmp('TPTLabelId').show();
     	 Ext.getCmp('dlNumber').show();
         Ext.getCmp('dlLabelNumber').show();
     	 Ext.getCmp('drivingLicenceId').show();
     	 Ext.getCmp('DriverNameTextId').setReadOnly(false);
    }
    
    var selected = grid.getSelectionModel().getSelected();
   
    Ext.getCmp('VehicleCmboId').setValue(selected.get('vehicleNoIndex'));
    Ext.getCmp('DriverNameTextId').setValue(selected.get('driverNameIndex'));
    Ext.getCmp('ownernameTextId').setValue(selected.get('OwnerNameIndex'));
    Ext.getCmp('driverContactId').setValue(selected.get('driverContactIndex'));
    Ext.getCmp('drivingLicenceId').setValue(selected.get('driverLicenceIndex'));
    Ext.getCmp('TPTComboId').setValue(selected.get('TPTNameIndex'));
    
}


//for approving
function approveRecord() {
    if (innergrid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }
     buttonValue = 'Allocate';  
     var json = '';
     
     var selected = grid.getSelectionModel().getSelected();
	var uniqueId = selected.get('uniqueIdDataIndex');
		
     var record = innergrid.getSelectionModel().getSelections();
        for (var i = 0, len = record.length; i < len; i++) {
        var row = record[i];
    
        json += Ext.util.JSON.encode(row.data) + ',';
    }
    if (json != '') {
        json = json.substring(0, json.length - 1);
    }
    Ext.MessageBox.confirm('Confirm', "Do you want to allocate the selected Records Continue...?", function(btn) {
        if (btn == 'yes') {
        outerPanelWindow.getEl().mask();
        Ext.Ajax.request({
                 url: '<%=request.getContextPath()%>/RakeTripCreationAction.do?param=allocateOrCancleDetails',
                 method: 'POST',
                 params: {
                     jsonData: json,
                     buttonValue:buttonValue,
                     uniqueId:uniqueId
                 },
                 success: function(response, options){             
                     var message = response.responseText;
                     Ext.example.msg(message);
                     json = '';
                     innergridstore.reload();
                     outerPanelWindow.getEl().unmask();
                     myInnerWin.hide();
                  }, 
                  failure: function(){
                         innergridstore.reload();
                         myInnerWin.hide();
                         outerPanelWindow.getEl().unmask();
                         json = '';
                  } // END OF FAILURE 					
             });
  	   }
    });
}

function deleteData()
{
	myInnerWin.hide();
}


function closeTrip()
{
 	if (innergrid.getSelectionModel().getCount() == 0) {
     Ext.example.msg("No Rows are Selected");
        return;
    }
    buttonValue = 'Cancel';  
     var json = '';
     
     var selected = grid.getSelectionModel().getSelected();
	var uniqueId = selected.get('uniqueIdDataIndex');
		
     var record = innergrid.getSelectionModel().getSelections();
        for (var i = 0, len = record.length; i < len; i++) {
        var row = record[i];
    
        json += Ext.util.JSON.encode(row.data) + ',';
    }
    if (json != '') {
        json = json.substring(0, json.length - 1);
    }
    Ext.MessageBox.confirm('Confirm', "Do you want to cancel the selected Records Continue...?", function(btn) {
        if (btn == 'yes') {
        outerPanelWindow.getEl().mask();
        Ext.Ajax.request({
                 url: '<%=request.getContextPath()%>/RakeTripCreationAction.do?param=allocateOrCancleDetails',
                 method: 'POST',
                 params: {
                     jsonData: json,
                     buttonValue:buttonValue,
                     uniqueId:uniqueId
                 },
                 success: function(response, options){             
                     var message = response.responseText;
                     Ext.example.msg(message);
                     json = '';
                     innergridstore.reload();
                     outerPanelWindow.getEl().unmask();
                     myInnerWin.hide();
                  }, 
                  failure: function(){
                         innergridstore.reload();
                         myInnerWin.hide();
                         outerPanelWindow.getEl().unmask();
                         json = '';
                         									
                     } // END OF FAILURE 					
             });
     }
    });
}

function approveFunction()
{

}

	var viewAllocationGridreader = new Ext.data.JsonReader({
    root: 'viewApprovalInnerGridRoot',
    totalProperty: 'total',
    fields: [{
        name: 'viewContainerSnoIndex'
    },{
    	name: 'viewContainerUniqueIdIndex'
    }, {
        name: 'viewContainerbookingIdIndex'
    }, {
    	name: 'viewContainerbookingDateIndex'
    }, {
    	name: 'viewContainerContainerNoIndex'
    }, {
        name: 'viewContainerSizeIndex'
    },{
        name: 'viewContainerLoadTypeIndex'
    },{
        name: 'viewContainerLocationIndex'
    }, {
        name: 'viewContainerShippingIndex'
    }, {
        name: 'viewContainerBillingCustIndex'
    }, {
        name: 'viewContainerWeightIndex'
    }, {
        name: 'viewContainersbblnoIndex'
    },{
        name: 'viewContainerAllocatedIndex'
    },{
        name: 'viewContainerTripNoIndex'
    }]
});

   var viewAllocationstore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/RakeTripCreationAction.do?param=getAllocationlDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,	
    reader: viewAllocationGridreader
}); 

 var filtersViewAllocationGrid = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            type: 'numeric',
            dataIndex: 'viewContainerSnoIndex'
        },	{
            type: 'numeric',
            dataIndex: 'viewContainerUniqueIdIndex'
        }, {
            dataIndex: 'viewContainerbookingIdIndex',
            type: 'numeric'
        }, {
        	dataIndex: 'viewContainerbookingDateIndex',
        	type: 'string'
        }, {
        	dataIndex: 'viewContainerContainerNoIndex',
        	type: 'string'
        }, {
            dataIndex: 'viewContainerSizeIndex',
            type: 'string'
        }, {
        	dataIndex: 'viewContainerLoadTypeIndex',
            type: 'string'
        }, {
            dataIndex: 'viewContainerLocationIndex',
            type: 'string'
        }, {
            dataIndex: 'viewContainerShippingIndex',
            type: 'string'
        }, {
            dataIndex: 'viewContainerBillingCustIndex',
            type: 'numeric'
        }, {
            dataIndex: 'viewContainerWeightIndex',
            type: 'numeric'
        }, {
            dataIndex: 'viewContainersbblnoIndex',
            type: 'string'
        }, {
            dataIndex: 'viewContainerAllocatedIndex',
            type: 'string'
        }, {
            dataIndex: 'viewContainerTripNoIndex',
            type: 'numeric'
        }]
});


var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), {
            header: "<span style=font-weight:bold;>SLNO</span>",
            dataIndex: 'viewContainerSnoIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>UID</span>",
            dataIndex: 'viewContainerUniqueIdIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Booking No</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'viewContainerbookingIdIndex'
        }, {
        	header: "<span style=font-weight:bold;>Booking Date</span>",
            hidden: false,
            width: 160,
            sortable: true,
            dataIndex: 'viewContainerbookingDateIndex'
        }, {
        	header: "<span style=font-weight:bold;>Container No</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'viewContainerContainerNoIndex'
        }, {
            header: "<span style=font-weight:bold;>Size</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'viewContainerSizeIndex'
        }, {
            header: "<span style=font-weight:bold;>Load Type</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'viewContainerLoadTypeIndex'
        }, {
            header: "<span style=font-weight:bold;>Location</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'viewContainerLocationIndex'
        },{
            header: "<span style=font-weight:bold;>Shipping Name</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'viewContainerShippingIndex'
        },{
            header: "<span style=font-weight:bold;>Billing_Customer</span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'viewContainerBillingCustIndex'
        },{
            header: "<span style=font-weight:bold;>Weight</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'viewContainerWeightIndex'
        }, {
            header: "<span style=font-weight:bold;>SB / BL No</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'viewContainersbblnoIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Allocated</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'viewContainerAllocatedIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Trip No</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'viewContainerTripNoIndex',
            filter: {
                type: 'numeric'
            }
        } ];
   	 	return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};

myViewAllcoationgrid = getGrid1('', 'No Records Found', viewAllocationstore, 1280, 380, 15, filtersViewAllocationGrid, '', false, '', 15, false, '', true, 'Close', false, 'Excel', '', '', false, 'PDF',false,'ADD',false,'Modify');

//getGrid1(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr)
// inner grid code

 	var innerGridreader = new Ext.data.JsonReader({
    root: 'TripApprovalInnergridRoot',
    totalProperty: 'total',
    fields: [{
        name: 'innerslnoIndex'
    },{
    	name: 'innerUniqueIdIndex'
    }, {
        name: 'innerbookingNoIndex'
    }, {
        name: 'innerbookingDateIndex'
    },{
        name: 'innercontainerNoIndex'
    },{
        name: 'sizeIndex'
    }, {
        name: 'innerloadtypeIndex'
    }, {
        name: 'locationIndex'
    }, {
        name: 'shippingnameIndex'
    }, {
        name: 'billingcustomerIndex'
    }, {
        name: 'weightIndex'
    }, {
        name: 'sbblnoIndex'
    },{
        name: 'fuelLtrsIndex'
    },{
        name: 'fuelAmtIndex'
    },{
        name: 'incentivesIndex'
    }]
});
    	
    var innergridstore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/RakeTripCreationAction.do?param=getInnerGridTripApprovalDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,
    reader: innerGridreader
}); 
    
    var filtersInnerGrid = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            type: 'numeric',
            dataIndex: 'innerslnoIndex'
        },	{
            type: 'numeric',
            dataIndex: 'innerUniqueIdIndex'
        }, {
            dataIndex: 'innerbookingNoIndex',
            type: 'numeric'
        }, {
            dataIndex: 'innerbookingDateIndex',
            type: 'date'
        }, {
        	dataIndex: 'innercontainerNoIndex',
            type: 'string'
        }, {
            dataIndex: 'sizeIndex',
            type: 'numeric'
        }, {
            dataIndex: 'innerloadtypeIndex',
            type: 'string'
        }, {
            dataIndex: 'locationIndex',
            type: 'string'
        }, {
            dataIndex: 'shippingnameIndex',
            type: 'string'
        }, {
            dataIndex: 'billingcustomerIndex',
            type: 'string'
        }, {
            dataIndex: 'weightIndex',
            type: 'numeric'
        }, {
            dataIndex: 'sbblnoIndex',
            type: 'string'
        }, {
        	dataIndex: 'fuelLtrsIndex',
        	type: 'numeric'
        }, {
        	dataIndex: 'fuelAmtIndex',
        	type: 'numeric'
        }, {
        	dataIndex: 'incentivesIndex',
        	type: 'numeric'
        } 
    ]
});

 //****************Inner grid column Model Config****************

var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }),sm, {
            header: "<span style=font-weight:bold;>SLNO</span>",
            dataIndex: 'innerslnoIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>UID</span>",
            dataIndex: 'innerUniqueIdIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Booking No</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'innerbookingNoIndex'
        },{
            header: "<span style=font-weight:bold;>Booking Date</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'innerbookingDateIndex'
        }, {
            header: "<span style=font-weight:bold;>Container No</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'innercontainerNoIndex'
        }, {
            header: "<span style=font-weight:bold;>Size</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'sizeIndex'
        },{
            header: "<span style=font-weight:bold;>Load Type</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'innerloadtypeIndex'
        },{
            header: "<span style=font-weight:bold;>Location</span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'locationIndex'
        },{
            header: "<span style=font-weight:bold;>Shipper Name</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'shippingnameIndex'
        },{
            header: "<span style=font-weight:bold;>Billing Customer</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'billingcustomerIndex',
             //filter: {
              //  type: 'date'
            //}
        },{
            header: "<span style=font-weight:bold;>Weight</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'weightIndex',
            filter: {
                type: 'string'
            }
        },{
            header: "<span style=font-weight:bold;>SB / BL No</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'sbblnoIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Fuel Ltrs</span>",
            hidden: true,
            width: 150,
            sortable: true,
            dataIndex: 'fuelLtrsIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Fuel Amt</span>",
            hidden: true,
            width: 150,
            sortable: true,
            dataIndex: 'fuelAmtIndex',
            filter: {
                type: 'string'
            }
        }, {
            header: "<span style=font-weight:bold;>Incentive</span>",
            hidden: true,
            width: 150,
            sortable: true,
            dataIndex: 'incentivesIndex',
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

 
function getSelectionModelEditorGridCashVan(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,approve,approvestr,closetrip,closetripstr,del,delstr,sm){
	 var grid = new Ext.grid.EditorGridPanel({
	    	title:gridtitle,
	        border: false,
	        height: getGridHeight(),
	        autoScroll:true,
	        store: store,
	        id:'grid',
	        colModel: createColModel(gridnoofcols),
	        loadMask: true,
	        sm: sm,
	        view: new Ext.grid.GroupingView({
	        	autoFill:true,
	            groupTextTpl: getGroupConfig(),
	            emptyText: emptytext,deferEmptyText: false
	        }),
	        plugins: [filters],
	        bbar: new Ext.Toolbar({
	        })
	    });
	if(width>0){
		grid.setSize(width,height);
	}
	 grid.getBottomToolbar().add([
	        '->',
	        {
	            text: filterstr,
	            handler: function () {
	        	grid.filters.clearFilters();
	        	} 
	        }]);
		if(reconfigure){
		grid.getBottomToolbar().add([
			{
           text: reconfigurestr,
           handler: function () {
			grid.reconfigure(store, createColModel(reconfigurenoofcols));
           } 
       }]);
		}
		if(group){
			grid.getBottomToolbar().add([
			{
			    text:groupstr,
			    handler : function(){
				store.clearGrouping();
			    }    
			  }]);
		}
		if(del)
		{
			grid.getBottomToolbar().add([
			{
			    text:delstr,
			    handler : function(){
			    deleteData();
			    }    
			  }]);
		}	
		if(approve)
		{
			grid.getBottomToolbar().add([
			{
			    text:approvestr,
			    handler : function(){
			    approveRecord();

			    }    
			  }]);
		}	
		if(closetrip)
		{
			grid.getBottomToolbar().add([
			{
			    text:closetripstr,
			    handler : function(){
			    closeTrip();

			    }    
			  }]);
		}	
		if(chart)
		{
			grid.getBottomToolbar().add([
			{
			    text:chartstr,
			    handler : function(){
				columnchart();
			    }    
			  }]);
		}
		if(excel)
		{
			grid.getBottomToolbar().add([
			{
			    text:excelstr,
			    handler : function(){
				getordreport('xls','All',jspName,grid,exportDataType);
			    }    
			  }]);
		}
		if(pdf)
		{
			grid.getBottomToolbar().add([
			{
			    text:pdfstr,
			    handler : function(){
			    getordreport('pdf','All',jspName,grid,exportDataType);

			    }    
			  }]);
		}	
	return grid;
}


var viewAllocationWindow = new Ext.Panel({ 
    standardSubmit: true,
    frame: false,
    items: [myViewAllcoationgrid]
});

myViewAllocationWin = new Ext.Window({
    title: 'View Allocation Details',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
	maximizable: false,
    width: screen.width - 40,
    cls: 'mywindow',
    id: 'myViewAllocationWin',
    items: [viewAllocationWindow]
    });

innergrid = getSelectionModelEditorGridCashVan('', 'No Records Found', innergridstore, 1280, 380, 32, filtersInnerGrid, '', false, '', 32, false, '', false, '', false, 'Excel', '', '', false, 'PDF', true, 'Allocate', false, 'Cancel', true, 'Close', sm);
 
 /* **********  panel contains window content info ***********************/

	outerPanelWindow = new Ext.Panel({ 
    standardSubmit: true,
    frame: false,
    items: [innergrid]
});
/*************************inner grid window for form field****************************/

	myInnerWin = new Ext.Window({
    title: 'Trip Approval Details',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
	maximizable: false,
    width: screen.width - 40,
    cls: 'mywindow',
    id: 'myInnerWin',
    items: [outerPanelWindow]
});

/* ************ view allocation ********** */ 
function verifyFunction()
{
 		if (grid.getSelectionModel().getCount() == 0) {
           Ext.example.msg("No row selected");
           return;
       }

		var selected = grid.getSelectionModel().getSelected();
		var uniqueId = selected.get('uniqueIdDataIndex');
		myViewAllocationWin.show();
		myViewAllocationWin.setPosition(20,90);	
		//alert(uniqueId);
		//viewAllocationstore.load();
		viewAllocationstore.load({
						params: {
	 	   					uniqueId:uniqueId
						}		
	});
}	

/* ************Allocate Booking ************ */
function copyData()
{

	if (grid.getSelectionModel().getCount() == 0) {
    	 Ext.example.msg("No Rows are Selected");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
     Ext.example.msg("Select One Row At a time");
        return;
    }
		
		var selected = grid.getSelectionModel().getSelected();
		var uniqueId = selected.get('uniqueIdDataIndex');
		
		myInnerWin.show();  
		myInnerWin.setPosition(20, 90);
		innergridstore.load({
						params: {
	 	   					uniqueId:uniqueId
						}		
			});	 
}


var innerPanelAddCash= new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 200,
    width: 650,
    frame: false,
    id: 'innerPanelAddCashId',
    layout: 'table',
    layoutConfig: {
        columns: 8
    },
    items: [{
        xtype: 'fieldset',
        title: 'Additional Cash Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 6, 
        id: 'additianalCashDetailsId',
        width: 640,
        height: 190,
        layout: 'table',
        layoutConfig: {
            columns: 8
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'addtnalamountMid'
        }, {
            xtype: 'label',
            text: 'Enter Amount' + ' :',
            cls: 'labelstyle',
            id: 'addtnalamtLabelId'
        } , {
        	xtype: 'textfield',
            	text: '',
            	cls: 'labelstyle',
            	id: 'addtnalamtfield',
            	maskRe: /[0-9.]/
        	},{}
        ]
    }]
});

var innerAddCashButtonPanel = new Ext.Panel({
    id: 'innerAddCashButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 650,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Add Cash',
        id: 'AddCashsaveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() 
                {
		                    if(Ext.getCmp('vehicleTypeId').getValue()=="")
						    {
						    	Ext.example.msg("Vehicle Type not Selected");
						    	return;
						    }
		                    if (Ext.getCmp('VehicleCmboId').getValue() == "Select Vehicle")
		                    {
		                 	    Ext.example.msg("Select Vehicle Number");
		                        return;
		                    }
		                    if(Ext.getCmp('addtnalamtfield').getValue()=="")
		                    {
		                    	Ext.example.msg("Driver Name is required");
		                        return;
		                    }
		                
		                 
		                   
		                 
		                var selected = grid.getSelectionModel().getSelected();
						var uniqueId = selected.get('uniqueIdDataIndex');
						
						buttonValue="Add Cash";
						
		                    Ext.Ajax.request({
                        	//AddCashPanelWindow.getEl().mask();
                            url: '<%=request.getContextPath()%>/RakeTripCreationAction.do?param=addAdditionalCash',
                            method: 'POST',
                            params: 
                            {
                                buttonValue: buttonValue,
                                addtnalamtfield: Ext.getCmp('addtnalamtfield').getValue(),
                                uniqueId: uniqueId
                            },
                           		success: function(response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('addtnalamtfield').reset();
                                
                                myAddCashWindow.hide();
                                // AddCashPanelWindow.getEl().unmask();
                                grid.store.reload();
                            },
                           	failure: function() {
                                Ext.example.msg("Error");
                                grid.store.reload();
                                myAddCashWindow.hide();
                            }
                        });
                    }
                }
            }
        }
    	, {
        xtype: 'button',
        text: 'Cancel',
        id: 'canAddCashButtnId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                   myAddCashWindow.hide();
                }
            }
        }
    }]
});

var AddCashPanelWindow= new Ext.Panel({
    width: 660,
    height: 275,
    standardSubmit: true,
    frame: true,
    items: [innerPanelAddCash, innerAddCashButtonPanel]
});

myAddCashWindow = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 340,
    width: 670,
    id: 'addcashmyWin',
    items: [AddCashPanelWindow]
});

/* ************Additional Cash function************ */
function postponeFunction()
{
	
	buttonValue= 'Add Cash'
	if(Ext.getCmp('BranchNameComboId').getValue()=="")
    {
    	Ext.example.msg("Select Branch Name");
    	return;
    }
    if(Ext.getCmp('vehicleTypeId').getValue()=="")
    {
    	Ext.example.msg("Select Vehicle Type");
    	return;
    }
	myAddCashWindow.setPosition(450, 170);
	myAddCashWindow.show();
}

var innerPanelAddFuel= new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 215,
    width: 650,
    frame: false,
    id: 'innerPanelAddFuelId',
    layout: 'table',
    layoutConfig: {
        columns: 8
    },
    items: [{
        xtype: 'fieldset',
        title: 'Additional Fuel Details',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 6, 
        id: 'AddFuelAmtId',
        width: 640,
        height: 190,
        layout: 'table',
        layoutConfig: {
            columns: 8
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'addfuelMlabelId'
        }, {
        	xtype: 'label',
            text: ' Add Fuel ' + ' :',
            cls: 'labelstyle',
            id: 'addFuelLabelId'
        }, {
        	    xtype: 'textfield',
            	text: '',
            	cls: 'labelstyle',
            	id: 'additionalFuelField'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'addfuelAmtMlabelId'
            
        }, {
        	xtype: 'label',
            text: ' Add Fuel Amt' + ' :',
            cls: 'labelstyle',
            id: 'addFuelamtlabelId'
        }, {
        	xtype: 'textfield',
            	text: '',
            	cls: 'labelstyle',
            	id: 'additionalfuelAmtField'
        	}
        ]
    }]
});

var innerAddFuelAmtButtonPanel= new Ext.Panel({
    id: 'innerAddFuelAmtButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 650,
    frame: false,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: 'Add',
        id: 'AddFuelAmtsaveButtonId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function() 
                {
		                 if(Ext.getCmp('vehicleTypeId').getValue()=="")
					     {
						    	Ext.example.msg("Vehicle Type not Selected");
						    	return;
					     }
						 if(Ext.getCmp('vehicleTypeId').getValue()=="TDP Vehicle")
						 {
		                    
		                 }
		                 else if(Ext.getCmp('vehicleTypeId').getValue()=="Market Vehicle")
		                 { 
		                 	
		                 } 
		                var selected = grid.getSelectionModel().getSelected();
						var uniqueId = selected.get('uniqueIdDataIndex');
						
						buttonValue="Add";
						
		                    Ext.Ajax.request({
                        	//AddFuelAmtPanelWindow.getEl().mask();
                            url: '<%=request.getContextPath()%>/RakeTripCreationAction.do?param=addAdditionalFuelAndAmount',
                            method: 'POST',
                            params: 
                            {
                                buttonValue: buttonValue,
                                uniqueId:uniqueId,
                                additionalFuelField : Ext.getCmp('additionalFuelField').getValue(),
                                additionalfuelAmtField : Ext.getCmp('additionalfuelAmtField').getValue()
                            },  success: function(response, options)
                           	 {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('additionalFuelField').reset();
                                Ext.getCmp('additionalfuelAmtField').reset();
                                
                                myWin.hide();
                                // AddFuelAmtPanelWindow.getEl().unmask();
                                grid.store.reload();
                                
                            },	failure: function() {
                                Ext.example.msg("Error");
                                grid.store.reload();
                                myWin.hide();
                            }
                        });
                    }
                }
            }
        }
    	, {
        xtype: 'button',
        text: 'Cancel',
        id: 'canAddFuelBtnId',
        cls: 'buttonstyle',
        iconCls: 'cancelbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    myAddFuelAmtWindow.hide();
                }
            }
        }
    }]
});

var AddFuelAmtPanelWindow= new Ext.Panel({
    width: 660,
    height: 295,
    standardSubmit: true,
    frame: true,
    items: [innerPanelAddFuel, innerAddFuelAmtButtonPanel]
});

myAddFuelAmtWindow = new Ext.Window({
    title: titelForInnerPanel,
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 355,
    width: 670,
    id: 'myAddFuelAmtWin',
    items: [AddFuelAmtPanelWindow]
});




/* ******************Additonal Fuel******************** */
function importExcelData()
{
    buttonValue= 'Add'
	if(Ext.getCmp('BranchNameComboId').getValue()=="")
    {
    	Ext.example.msg("Select Branch Name");
    	return;
    }
    if(Ext.getCmp('vehicleTypeId').getValue()=="")
    {
    	Ext.example.msg("Select Vehicle Type");
    	return;
    }
	myAddFuelAmtWindow.setPosition(450, 170);
	myAddFuelAmtWindow.show();
}
/* *************print slip function  */
function saveDate()
{
	if (grid.getSelectionModel().getCount() == 0) {
     Ext.example.msg("No Row is Selected");
        return;
    }
	var selected = grid.getSelectionModel().getSelected();
	var uniqueId = selected.get('uniqueIdDataIndex');
	var tripchartNo = selected.get('TripChartNoIndex');
	var vehicleNo= selected.get('vehicleNoIndex');
	
	//alert(uniqueId+' '+tripchartNo+'  '+vehicleNo);
	//html: "<iframe style='width:100%;height:100%' src=<%=request.getContextPath()%>/jsps/TDP_LMS_jsps/RakeShiftSlip.jsp?uniqueId="+ uniqueId +"&tripchartNo=" + tripchartNo + "&vehicleNo=" + vehicleNo+ "></iframe>",

}

/* ******************Close Trip Allocation******************** */
function closeImportWin()
{
	  if (Ext.getCmp('BranchNameComboId').getValue() == "") {
           Ext.example.msg("Select Branch Name");
           return;
       }
        if (Ext.getCmp('vehicleTypeId').getValue() == "") {
           Ext.example.msg("Select Vehicle Type");
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
     buttonValue = 'Close';  
     var json = '';
     var selected = grid.getSelectionModel().getSelected();
     var uniqueId = selected.get('uniqueIdDataIndex');
     var status = selected.get('statusIndex');
    if( status == 'Close'){
            Ext.example.msg("Trip Already In Close Status");
           return;
    }
    Ext.MessageBox.confirm('Confirm', "Are You Sure Want To Close The Status. Continue...?", function(btn) {
        if (btn == 'yes') {
        outerPanel.getEl().mask();
        Ext.Ajax.request({
                 url: '<%=request.getContextPath()%>/RakeTripCreationAction.do?param=closeRakeShiftTripDetails',
                 method: 'POST',
                 params: { 
                     uniqueid: uniqueId,
                     buttonValue:buttonValue
                 },
                 success: function(response, options){             
                     var message = response.responseText;
                     Ext.example.msg(message);
                     json = '';
                     store.reload();
                     outerPanel.getEl().unmask();
                  }, 
                  failure: function(){
                         store.reload();
                         outerPanel.getEl().unmask();
                         json = '';
                     } // END OF FAILURE 
             });
         }
    });
	
}

function columnchart()
{
	myViewAllocationWin.hide();
}



var reader = new Ext.data.JsonReader({
    idProperty: 'ownMasterid',
    root: 'rakeTripRoot', 
    totalProperty: 'total',
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'uniqueIdDataIndex'
    }, {
        name: 'TripIdIndex'
    }, {
    	name: 'TripChartNoIndex'
    },	{
        name: 'vehicleNoIndex'
    }, {
        name: 'driverNameIndex'
    }, {
        name: 'driverContactIndex'
    }, {
        name: 'TPTNameIndex'
    }, {
    	name: 'driverLicenceIndex'
    } ,{
    	name: 'OwnerNameIndex'
    },	{
        name: 'createdByIndex'
    },  {
        name: 'createdDateIndex'
    },  {
        name: 'closedByIndex'
    }, {
    	name: 'closedDateIndex'
    }, {
        name: 'statusIndex'
    }]
});

var store = new Ext.data.GroupingStore({
    autoLoad: false,
    proxy: new Ext.data.HttpProxy({
       url: '<%=request.getContextPath()%>/RakeTripCreationAction.do?param=getTripDetails',
        method: 'POST'
    }),
    storeId: 'rakeMasterId',
    reader: reader
});


var filters = new Ext.ux.grid.GridFilters({  
    local: true,
    filters: [{
    	 type: 'numeric',
         dataIndex: 'slnoIndex'
    },{
        type: 'numeric',
        dataIndex: 'uniqueIdDataIndex'
    }, {
        type: 'numeric',
        dataIndex: 'TripIdIndex'			
    },	{
    	 type: 'string',
    	 dataIndex: 'TripChartNoIndex'
    } , {
        type: 'int',
        dataIndex: 'vehicleNoIndex'
    }, {
        type: 'string',
        dataIndex: 'driverNameIndex'
    }, {
        type: 'string',
        dataIndex: 'driverContactIndex'
    } , {
        type: 'string',
        dataIndex: 'TPTNameIndex'
    },{
    		type: 'string',
    		dataIndex: 'driverLicenceIndex'
    },{
    	type: 'string',
    	dataIndex: 'OwnerNameIndex'
    },{
        type: 'string',
        dataIndex: 'createdByIndex'
    },{
        type: 'string',
        dataIndex: 'createdDateIndex'
    },{
        type: 'string',
        dataIndex: 'closedByIndex'
    },{
    	type: 'string',
    	dataIndex: 'closedDateIndex'
    },{
        type: 'string',
        dataIndex: 'statusIndex'
    }]
});

var createColModel = function(finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;>SLNO</span>",
            width: 50
        }), {
            dataIndex: 'slnoIndex',
            hidden: true,
            header: "<span style=font-weight:bold;>SLNO</span>",
            filter: {
                type: 'numeric'
            }
        }, {
            dataIndex: 'uniqueIdDataIndex',
            header: "<span style=font-weight:bold;>UID</span>",
            width: 30,
            hidden: true,
	            filter: {
	                type: 'numeric'
	            }
        } , {
            dataIndex: 'TripIdIndex',
            header: "<span style=font-weight:bold;>Trip ID</span>",
            width: 30,
            hidden: true,
	            filter: {
	                type: 'numeric'
	            }
        }, {
            dataIndex: 'TripChartNoIndex',
            header: "<span style=font-weight:bold;>Trip Chart No</span>",
            width: 50,
	            filter: {
	                type: 'numeric'
	            }
        }  , {
            header: "<span style=font-weight:bold;>Vehicle No</span>",
            dataIndex: 'vehicleNoIndex',
            width: 50,
            filter: {
                type: 'int'
            }
        }, 	{
            header: "<span style=font-weight:bold;>Driver Name</span>",
            dataIndex: 'driverNameIndex',
            width: 50,
            filter: {
                type: 'int'
            }
        }, {
            header: "<span style=font-weight:bold;>Driver Contact</span>",
            dataIndex: 'driverContactIndex',
            width: 50,
            hidden: true,
            filter: {
                type: 'string'
            }
        },	{
            header: "<span style=font-weight:bold;>TPT Name</span>",
            dataIndex: 'TPTNameIndex',
            width: 50,
            hidden: true,
            filter: {
                type: 'string'
            }
        } , {
            header: "<span style=font-weight:bold;>Driving Licence </span>",
            dataIndex: 'driverLicenceIndex',
            hidden: true,
            width: 50,
            filter: {
                type: 'string'
            }
        } , {
            header: "<span style=font-weight:bold;>Owner Name</span>",
            dataIndex: 'OwnerNameIndex',
            width: 50,
            hidden: true,
            filter: {
                type: 'int'
            }
        } , {
        	header: "<span style=font-weight:bold;>Created By</span>",
        	dataIndex: 'createdByIndex',
        	width: 50,
        	filter: {
        		type: 'string'
        	}
        } , {
        	header: "<span style=font-weight:bold;>Created Date</span>",
        	dataIndex: 'createdDateIndex',
        	width: 50,
        	filter: {
        		type: 'string'
        	}
        } , {
        	header: "<span style=font-weight:bold;>Closed By</span>",
        	dataIndex: 'closedByIndex',
        	width: 50,
        	filter: {
        		type: 'string'
        	}
        }, {
        	header: "<span style=font-weight:bold;>Closed Date</span>",
        	dataIndex: 'closedDateIndex',
        	width: 50,
        	filter: {
        		type: 'string'
        	}
        }, {
        		header: "<span style=font-weight:bold;>Status</span>",
        		dataIndex: 'statusIndex',
        		width: 30,
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

grid = getGrid('Trip Creation Details', 'No Records Found', store, screen.width - 40, 440, 16, filters, '', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, 'Add Trip', true, 'Modify Trip', false, 'Delete', false, 'close', true, 'View Allocation', false, 'Cash', true, 'Allocate Booking', true, 'Additional Cash',true,'Additional Fuel', true, 'Print Slip',false,'Clear', true,'Close');
//getGrid(gridtitle,emptytext,store,width,height,gridnoofcols,filters,filterstr,reconfigure,reconfigurestr,reconfigurenoofcols,group,groupstr,chart,chartstr,excel,excelstr,jspName,exportDataType,pdf,pdfstr,add,addstr,modify,modifystr,del,delstr,closetrip,closestr,verify,verifystr,approve, approvestr,copy, copystr,postpone,postponestr,importExcel,importStr,save,saveStr,clearData,clearStr,close,closeStr)

Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'Trip Creation',
        id:'outerPanel',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width - 22,
        cls: 'outerpanel',
        layout: 'table',	
        layoutConfig: {
            columns: 1
        },
        items: [vehicleTypePanel,grid]
    });
    sb = Ext.getCmp('form-statusbar');
    			
});
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->