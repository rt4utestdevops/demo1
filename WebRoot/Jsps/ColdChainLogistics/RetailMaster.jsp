<%@ page language="java"import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if (request.getParameter("list") != null) {
		String list = request.getParameter("list").toString().trim();
		String[] str = list.split(",");
		int systemid = Integer.parseInt(str[0].trim());
		int customerid = Integer.parseInt(str[1].trim());
		int userid = Integer.parseInt(str[2].trim());
		String language = str[3].trim();
		LoginInfoBean loginInfo = new LoginInfoBean();
		loginInfo.setSystemId(systemid);
		loginInfo.setCustomerId(customerid);
		loginInfo.setUserId(userid);
		loginInfo.setLanguage(language);
		loginInfo.setStyleSheetOverride("N");
		loginInfo.setZone(str[4].trim());
		loginInfo.setOffsetMinutes(Integer.parseInt(str[5].trim()));
		loginInfo.setSystemName(str[6].trim());
		loginInfo.setCategory(str[7].trim());
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if (str.length > 11) {
			loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
		if (str.length > 11) {
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/SessionDestroy.html");
	} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
			 
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Add");
tobeConverted.add("Modify");
tobeConverted.add("No_Records_Found");
tobeConverted.add("Clear_Filter_Data");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("SLNO");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("Add_Details");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("Delete");
tobeConverted.add("Are_you_sure_you_want_to_delete");
tobeConverted.add("State");
tobeConverted.add("City");
tobeConverted.add("Select_State");
tobeConverted.add("Enter_City");
tobeConverted.add("Address");
tobeConverted.add("Enter_Address");
tobeConverted.add("Latitude");
tobeConverted.add("Longitude");
tobeConverted.add("Enter_Latitude");
tobeConverted.add("Enter_Longitude");
tobeConverted.add("Retailer_Name");
tobeConverted.add("Enter_Retailer_Name");
tobeConverted.add("Zone");
tobeConverted.add("Select_Zone");
tobeConverted.add("Retailer_Master");
tobeConverted.add("Retailer_Master_Details");
tobeConverted.add("Contact_Number");
tobeConverted.add("Enter_Contact-Number");
tobeConverted.add("Validate_Mesg_For_Form");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String Add=convertedWords.get(0);
String Modify=convertedWords.get(1);
String NoRecordsFound=convertedWords.get(2);
String ClearFilterData=convertedWords.get(3);
String Save=convertedWords.get(4);
String Cancel=convertedWords.get(5);
String SLNO=convertedWords.get(6);
String NoRowsSelected=convertedWords.get(7);
String SelectSingleRow=convertedWords.get(8);
String AddDetails=convertedWords.get(9);
String SelectCustomer=convertedWords.get(10);
String CustomerName=convertedWords.get(11);
String Delete=convertedWords.get(12);
String Areyousureyouwanttodelete=convertedWords.get(13);
String State=convertedWords.get(14);
String City=convertedWords.get(15);
String SelectState=convertedWords.get(16);
String EnterCity=convertedWords.get(17);
String Address=convertedWords.get(18);
String EnterAddress=convertedWords.get(19);
String Latitude=convertedWords.get(20);
String Longitude=convertedWords.get(21);
String EnterLatitude=convertedWords.get(22);
String EnterLongitude=convertedWords.get(23);
String RetailerName=convertedWords.get(24);
String EnterRetailerName=convertedWords.get(25);
String Zone=convertedWords.get(26);
String SelectZone=convertedWords.get(27);
String RetailerMaster=convertedWords.get(28);
String RetailerMasterDetailes=convertedWords.get(29);
String ContactNumber=convertedWords.get(30);
String EnterContactNumber=convertedWords.get(31);
String Validate_Mesg_For_Form=convertedWords.get(32);
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();
%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title><%=RetailerMaster%></title>
	
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
		 <style>
			label {
				display : inline !important;
			}		
			.x-layer ul {
				min-height: 27px !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-window-tl *.x-window-header {
				height : 36px !important;
			}			
			
		 </style>
 <script>
   var outerPanel;
   var jspName = "";
   var exportDataType = "";
   var grid;
   var myWin;
   var buttonValue;
   
    //----------------------------------customer store---------------------------// 
    var customercombostore = new Ext.data.JsonStore({
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
                    custName = Ext.getCmp('custcomboId').getRawValue();
                    zoneStore.load({
                       params: {
                           CustId:custId,
                       }
                   }); 
                    store.load({
                      params: {
                          CustId: custId
                      }
                  }); 
                }
            }
        }
    });

    //******************************************************************customer Combo******************************************//
    var custnamecombo = new Ext.form.ComboBox({
        store: customercombostore,
        id: 'custcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=SelectCustomer%>' ,
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
                   custName=Ext.getCmp('custcomboId').getRawValue();
                   zoneStore.load({
                       params: {
                           CustId:custId,
                       }
                   }); 
                   store.load({
                       params: {
                           JspName: jspName,
                           CustId:custId,
                           CustName:custName
                       }
                   }); 
                   stateStore.load(); 
               }
           }
       }
    });
    
    
    
      
 //***************************************************************************************************************//
   var clientPanel = new Ext.Panel({
       standardSubmit: true,
       collapsible: false,
       id: 'clientPanelId',
       layout: 'table',
       frame: false,
       width: screen.width - 60,
       height: 50,
       layoutConfig: {
           columns: 15
       },
       items: [{
               xtype: 'label',
              text: '<%=SelectCustomer%>' + ' :',
               cls: 'labelstyle',
               id: 'ltspcomboId'
           },
          custnamecombo, {
               width: 40
           }
       ]
   });
 
//******************************************Add and Modify function *********************************************************************//
   var zoneStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/RetailerMasterAction.do?param=getZone',
        id: 'zoneStoreId',
        root: 'zoneRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['Zone_ID', 'Zone_Name'],
        listeners: {
        }
    });
  
  var zoneCombo = new Ext.form.ComboBox({
      store: zoneStore,
      id: 'zoneId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'Zone_ID',
      emptyText: '<%=SelectZone%>', 
      displayField: 'Zone_Name',
      width : 200,
      cls: 'selectstylePerfect',
      listeners: {
      	 select: {
              fn: function() {
                  zoneId = Ext.getCmp('zoneId').getValue();
                  zoneName = Ext.getCmp('zoneId').getRawValue();
              } 
          }
      }
  });
  
  var stateStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getStates',
        id: 'stateStoreId',
        root: 'StateRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['StateID', 'stateName']
    });
  
  var stateCombo = new Ext.form.ComboBox({
      store: stateStore,
      id: 'stateId',
      mode: 'local',
      forceSelection: true,
      selectOnFocus: true,
      allowBlank: false,
      anyMatch: true,
      typeAhead: false,
      triggerAction: 'all',
      lazyRender: true,
      valueField: 'StateID',
      emptyText: '<%=SelectState%>',
      displayField: 'stateName',
        anchor    : '85%',
      cls: 'selectstylePerfect',
      listeners: {
      	 select: {
              fn: function() {
                  StateId = Ext.getCmp('stateId').getValue();
                  StateName = Ext.getCmp('stateId').getRawValue();
              } 
          }
      }
  });
 
  
  
   //***************************************************************************************//
   var innerPanelForRetailMasterDetails = new Ext.form.FormPanel({
    standardSubmit: true,    
    collapsible: false,
    autoScroll: true,
    height: 320,
    width: 400,
    frame: true,
    id: 'innerPanelForGradeDetailsId',
    layout: 'table',
      resizable:true, 
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=RetailerMasterDetailes%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'RetailMasterDetialsId',
        width: 360,
        layout: 'table',
        layoutConfig: {
            columns: 3,
             tableAttrs: {
		            style: {
		                width: '88%'
		            }
        			}
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'retailerNameEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=RetailerName%>' + ' :',
            cls: 'labelstyle',
            id: 'retailerNameLabelId',
		},{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterRetailerName%>',
            emptyText: '<%=EnterRetailerName%>',
            labelSeparator: '',
            allowBlank: false,
            id: 'retailerNameId',
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					}
					}
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'addressEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Address%>' + ' :',
            cls: 'labelstyle',
            id: 'addressLabelId',
		},{
            xtype: 'textarea',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterAddress%>',
            emptyText: '<%=EnterAddress%>',
            labelSeparator: '',
            allowBlank: false,
            id: 'AddressId',
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					}
					}
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'zoneEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Zone%>' + ' :',
            cls: 'labelstyle',
            id: 'zoneLabelId',
		},zoneCombo,
		{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'stateEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=State%>' + ' :',
            cls: 'labelstyle',
            id: 'stateLabelId',
		},stateCombo,
		{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'cityEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=City%>' + ' :',
            cls: 'labelstyle',
            id: 'cityLabelId',
		},{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            regex:validatation('city'),
	    	regexText:'City Name should be in Albhates only',
            blankText: '<%=EnterCity%>',
            emptyText: '<%=EnterCity%> ',
            labelSeparator: '',
            allowBlank: false,
            id: 'cityId',
            listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					}
					}
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'latitudeEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Latitude%>' + ' :',
            cls: 'labelstyle',
            id: 'latitudeLabelId',
		},{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterLatitude%> ',
            emptyText: '<%=EnterLatitude%> ',
            regex:validatation('latlong'),
	    	regexText:'Latitude should be in Float Value ',
            labelSeparator: '',
            forcePrecision: true, 
            allowBlank: false,
            id: 'latitudeId'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'LongitudeEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=Longitude%>' + ' :',
            cls: 'labelstyle',
            id: 'LongitudeLabelId',
		},{
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterLongitude%> ',
            emptyText: '<%=EnterLongitude%> ',
            forcePrecision: false, 
            labelSeparator: '',
            regex:validatation('latlong'),
	    	regexText:'Longitude should be in Float Value ',
            allowBlank: false,
            id: 'longitudeId'
        },{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'contactEmptyId1'
        }, {
            xtype: 'label',
            text: '<%=ContactNumber%>' + ' :',
            cls: 'labelstyle',
            id: 'contactLabelId',
		},{
            xtype: 'numberfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterContactNumber%> ',
            emptyText: '<%=EnterContactNumber%>',
            regex:validate('mobile'),
            maxLength : 20,
            forcePrecision: false, 
            allowBlank: false,
            id: 'contactId'
        }
		]
    }]
});
var innerWinButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 110,
    width: 400,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        cls: 'buttonstyle',
        iconCls:'savebutton',
        width: 70,
        listeners: {
            click: {
                fn: function () {
                	if (Ext.getCmp('custcomboId').getValue() == "") {
  						Ext.example.msg("<%=SelectCustomer%>");
  						return;
  						}
                    if (Ext.getCmp('retailerNameId').getValue() == "") {
                   			 Ext.example.msg("<%=EnterRetailerName%>");
             	   			 Ext.getCmp('retailerNameId').focus();
                   			 return;
                    	}
                    if (Ext.getCmp('AddressId').getValue() == "") {
                   			 Ext.example.msg("<%=EnterAddress%>");
             	   			 Ext.getCmp('AddressId').focus();
                   			 return;
                    	}
                    	if (Ext.getCmp('zoneId').getValue() == "") {
                   			 Ext.example.msg("<%=SelectZone%>");
             	   			 Ext.getCmp('zoneId').focus();
                   			 return;
                    	}
                    	if (Ext.getCmp('stateId').getValue() == "") {
                   			 Ext.example.msg("<%=SelectState%>");
             	   			 Ext.getCmp('stateId').focus();
                   			 return;
                    	}
                    	 if (Ext.getCmp('cityId').getValue() == "") {
                   			 Ext.example.msg("<%=EnterCity%>");
             	   			 Ext.getCmp('cityId').focus();
                   			 return;
                    	}
            
              		 	if (Ext.getCmp('latitudeId').getValue() == "") {
                   			 Ext.example.msg("<%=EnterLatitude%>");
             	   			 Ext.getCmp('latitudeId').focus();
                   			 return;
                    	} 
                    	if (Ext.getCmp('longitudeId').getValue() == "") {
                   			 Ext.example.msg("<%=EnterLongitude%>");
             	   			 Ext.getCmp('longitudeId').focus();
                   			 return;
                    	}
                    	if (Ext.getCmp('contactId').getValue() == "") {
                   			 Ext.example.msg("<%=EnterContactNumber%>");
             	   			 Ext.getCmp('contactId').focus();
                   			 return;
                    	}
                    	
                    	
                        var id;
                        if (buttonValue == '<%=Modify%>') {
                            var selected = grid.getSelectionModel().getSelected();
                             id = selected.get('IdDataIndex');
                        }
                       if(innerPanelForRetailMasterDetails.getForm().isValid()) {
                       	RetailMasterOuterPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                      	url: '<%=request.getContextPath()%>/RetailerMasterAction.do?param=retailerMasterAddModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                CustID: Ext.getCmp('custcomboId').getValue(),
                                CustName: Ext.getCmp('custcomboId').getRawValue(),
                                retailerName: Ext.getCmp('retailerNameId').getValue(),
                                Address: Ext.getCmp('AddressId').getValue(),
                                zone: Ext.getCmp('zoneId').getValue(),
                                state: Ext.getCmp('stateId').getValue(),
                                city: Ext.getCmp('cityId').getValue(),
                                latitude: Ext.getCmp('latitudeId').getValue(),
                    			longitude: Ext.getCmp('longitudeId').getValue(),
                    			contact: Ext.getCmp('contactId').getValue(),
                                id: id,
                                jspName: jspName
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                Ext.getCmp('retailerNameId').reset();
                                Ext.getCmp('AddressId').reset();
                                Ext.getCmp('zoneId').reset();
                                Ext.getCmp('stateId').reset();
                                Ext.getCmp('cityId').reset();
                      	        Ext.getCmp('latitudeId').reset();
                                Ext.getCmp('longitudeId').reset();
                                Ext.getCmp('contactId').reset();
                                myWin.hide();
                                store.reload();
                                RetailMasterOuterPanelWindow.getEl().unmask();
                            },

                            failure: function () {
                            Ext.example.msg("Error");
                                store.reload();
                                myWin.hide();
                            }
                        }); 
                        } else {
							Ext.example.msg("<%=Validate_Mesg_For_Form%>");
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
                    myWin.hide();
                }
            }
        }
    }]
});

var RetailMasterOuterPanelWindow = new Ext.Panel({
    width: 410,
    height:430,
    standardSubmit: true,
    frame: true,
    items: [innerPanelForRetailMasterDetails, innerWinButtonPanel]
});

myWin = new Ext.Window({
    title: 'titelForInnerPanel',
    closable: false,
    resizable: false,
    modal: true,
    autoScroll: false,
    height: 440,
    width: 420,
    frame:true,
    id: 'myWin',
    items: [RetailMasterOuterPanelWindow]
});

function addRecord() {
    if (Ext.getCmp('custcomboId').getValue() == "") {
  		Ext.example.msg("<%=SelectCustomer%>");
  		return;
  	}
    buttonValue = '<%=Add%>';
    titelForInnerPanel = '<%=AddDetails%>';
    myWin.setPosition(450, 80);
    myWin.show();
    myWin.setTitle(titelForInnerPanel);
    Ext.getCmp('retailerNameId').reset();
    Ext.getCmp('AddressId').reset();
    Ext.getCmp('zoneId').reset();
    Ext.getCmp('stateId').reset();
    Ext.getCmp('cityId').reset();
    Ext.getCmp('latitudeId').reset();
    Ext.getCmp('longitudeId').reset();
    Ext.getCmp('contactId').reset();
}
 
function modifyData() {
   if (Ext.getCmp('custcomboId').getValue() == "") {
  	   Ext.example.msg("<%=SelectCustomer%>");
  		return;
  	}
    if (grid.getSelectionModel().getCount() == 0) {
	    Ext.example.msg("<%=NoRowsSelected%>");
	    return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
	    Ext.example.msg("<%=SelectSingleRow%>");
	    return;
    }
    buttonValue = '<%=Modify%>'; 
    titelForInnerPanel= '<%=Modify%>'; 
    myWin.setPosition(450, 80);
    myWin.setTitle(titelForInnerPanel);
    myWin.show();
    var selected = grid.getSelectionModel().getSelected();
    Ext.getCmp('retailerNameId').setValue(selected.get('retailerNameDataIndex'));
    Ext.getCmp('AddressId').setValue(selected.get('addressDataIndex'));
    Ext.getCmp('zoneId').setValue(selected.get('zoneDataIndex'));
    Ext.getCmp('stateId').setValue(selected.get('stateDataIndex'));
    Ext.getCmp('cityId').setValue(selected.get('cityDataIndex'));
    Ext.getCmp('latitudeId').setValue(selected.get('latitudeDataIndex'));
    Ext.getCmp('longitudeId').setValue(selected.get('longitudeDataIndex'));
    Ext.getCmp('contactId').setValue(selected.get('contactDataIndex'));
 
}

function deleteData() {
     if (Ext.getCmp('custcomboId').getValue() == "") {
  		 Ext.example.msg("<%=SelectCustomer%>");
  		 return;
  	}              
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }
    Ext.Msg.show({
        title: '<%=Delete%>',
        msg: '<%=Areyousureyouwanttodelete%>',
        buttons: {
            yes: true,
            no: true
        },
        fn: function (btn) {
            switch (btn) {
            case 'yes':
                var selected = grid.getSelectionModel().getSelected();
                id = selected.get('IdDataIndex');
                outerPanel.getEl().mask();
                Ext.Ajax.request({
                 url: '<%=request.getContextPath()%>/RetailerMasterAction.do?param=deleteData',
                    method: 'POST',
                    params: {
                        CustId: Ext.getCmp('custcomboId').getValue(),
                        id: id
                    },
                    success: function (response, options) {
                        var message = response.responseText;
                        Ext.example.msg(message);
                        outerPanel.getEl().unmask();
                        store.load({
                            params: {
                                CustId: custId
                            }
                        });
                    },
                    failure: function () {
                        Ext.example.msg("Error");
                        store.reload();
                    }
                });
                break;
            case 'no':
                Ext.example.msg("Not Deleted");					//label
                store.reload();
                break;
            }
        }
    });
}

function validatation(name){
	 if(name=='city'){
	return	/^\s*[a-zA-Z_,\s]+\s*$/;
	}
	else if(name=='latlong'){
		return /^([-+]?\d{0,9}[.]?\d*)$/;
	}
}

   var reader = new Ext.data.JsonReader({
       idProperty: 'RetailMasterDetails',
       root: 'getRetailMasterDetails',
       totalProperty: 'total',
       fields: [{
           name: 'slnoIndex'
       }, {
           name: 'retailerNameDataIndex'
	   }, {
           name: 'addressDataIndex'
       },{
           name: 'zoneNameDataIndex'
       },{
           name: 'stateNameDataIndex'
       },{
           name: 'zoneDataIndex'
       },{
           name: 'stateDataIndex'
       },{
           name: 'cityDataIndex'
       },{
           name: 'latitudeDataIndex',
           type: 'numeric'
       },{
           name: 'longitudeDataIndex',
           type: 'numeric'
       },{
           name: 'contactDataIndex'
       },{
           name: 'IdDataIndex'
       }]
   });
   
   var store = new Ext.data.GroupingStore({
       autoLoad: false,
       proxy: new Ext.data.HttpProxy({
         url: '<%=request.getContextPath()%>/RetailerMasterAction.do?param=getRetailMasterDetails',
           method: 'POST'
       }),
       remoteSort: false,
       storeId: 'RetailMasterDetails',
       reader: reader
   });
  
   var filters = new Ext.ux.grid.GridFilters({
       local: true,
       filters: [{
           type: 'numeric',
           dataIndex: 'slnoIndex'
       }, {
           type: 'string',
           dataIndex: 'retailerNameDataIndex'
       }, {
           type: 'string',
           dataIndex: 'addressDataIndex'
       }, {
           type: 'string',
           dataIndex: 'zoneDataIndex'
       }, {
           type: 'string',
           dataIndex: 'stateDataIndex'
       },{
           type: 'string',
           dataIndex: 'zoneNameDataIndex'
       }, {
           type: 'string',
           dataIndex: 'stateNameDataIndex'
       }, {
           type: 'string',
           dataIndex: 'cityDataIndex'
       }, {
           type: 'string',
           dataIndex: 'contactDataIndex'
       },{	
       		type :'int',
       		dataIndex:'IdDataIndex'
       }]
   });
        
   var createColModel = function(finish, start) {
       var columns = [
           new Ext.grid.RowNumberer({
               header: "<span style=font-weight:bold;><%=SLNO%></span>",
               width: 50
           }), {
               dataIndex: 'slnoIndex',
               hidden: true,
               header: "<span style=font-weight:bold;><%=SLNO%></span>",
           }, {
               header: "<span style=font-weight:bold;><%=RetailerName%></span>",
               dataIndex: 'retailerNameDataIndex',
               width: 80,
           }, {
               header: "<span style=font-weight:bold;><%=Address%></span>",
               dataIndex: 'addressDataIndex',
               width: 80,
               
           }, {
               header: "<span style=font-weight:bold;><%=Zone%></span>",
               dataIndex: 'zoneNameDataIndex',
               width: 80,
           }, {
               header: "<span style=font-weight:bold;><%=State%></span>",
               dataIndex: 'stateNameDataIndex',
               width: 80,
           }, {
               header: "<span style=font-weight:bold;><%=City%></span>",
               dataIndex: 'cityDataIndex',
               width: 80,
           }, {
               header: "<span style=font-weight:bold;><%=ContactNumber%></span>",
               dataIndex: 'contactDataIndex',
               width: 80,
           }
		   
       ];
       return new Ext.grid.ColumnModel({
           columns: columns.slice(start || 0, finish),
           defaults: {
               sortable: true
           }
       });
   };

  grid = getGrid('<%=RetailerMasterDetailes%>', '<%=NoRecordsFound%>', store, screen.width-40,460, 21, filters, 'ClearFilterData', false, '', 16, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');
  
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-22,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel,grid]
        //bbar: ctsb
    });
   // sb = Ext.getCmp('form-statusbar');
});
</script>
<jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>
