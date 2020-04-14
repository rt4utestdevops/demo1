<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
String responseaftersubmit="''";
//String feature=session.getAttribute("feature").toString();
String feature="1";
if(session.getAttribute("responseaftersubmit")!=null){
	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
int systemid=loginInfo.getSystemId();
int userId = loginInfo.getUserId();
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
int CustIdPassed=0;
if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");
tobeConverted.add("Asset_Group_Name");
tobeConverted.add("SuperVisor_Name");
tobeConverted.add("Delete");
tobeConverted.add("Are_you_sure_you_want_to_delete");
tobeConverted.add("Next");
tobeConverted.add("Error");
tobeConverted.add("Deleting");
tobeConverted.add("Supervisor_Contact_No");
tobeConverted.add("Supervisor_Email");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("SLNO");
tobeConverted.add("Asset_Group");
tobeConverted.add("Select_Supervisor");
tobeConverted.add("Enter_Asset_Group");
tobeConverted.add("Modify_Asset_Group");
tobeConverted.add("Add_Asset_Group");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Select_Single_Row"); 
tobeConverted.add("Registration_Status");
tobeConverted.add("Cannot-Delete_Default_Asset-Group");
tobeConverted.add("Cannot-Modify_Default_Asset-Group");
tobeConverted.add("State");
tobeConverted.add("Select_State");
tobeConverted.add("Validate_Mesg_For_Group_Name");
tobeConverted.add("Select_Hub_Name");
tobeConverted.add("Hub_Name");
tobeConverted.add("Hub_Id");
tobeConverted.add("City");
tobeConverted.add("Select_City");
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String selectCustomer=convertedWords.get(0);
String CustomerName=convertedWords.get(1);
String AsserGroupName=convertedWords.get(2);
String SuperVisorName=convertedWords.get(3);
String delete=convertedWords.get(4);
String wantToDelete=convertedWords.get(5);
String next=convertedWords.get(6);
String error=convertedWords.get(7);
String deleting=convertedWords.get(8);
String SupervisorNo =convertedWords.get(9);
String SupervisorEmail=convertedWords.get(10);
String Save=convertedWords.get(11);
String Cancel=convertedWords.get(12);
String SLNO=convertedWords.get(13);
String AssetGroup=convertedWords.get(14);
String selectSupervisor=convertedWords.get(15);
String enterAssetGroup=convertedWords.get(16);
String modifyAssetGroup=convertedWords.get(17);
String addAssetGroup=convertedWords.get(18);
String noRowsSelected=convertedWords.get(19);
String selectSingleRow=convertedWords.get(20);
String RegistrationStatus=convertedWords.get(21);
String Cannot_Delete_Default_Asset_Group=convertedWords.get(22);
String Cannot_Modify_Default_Asset_Group=convertedWords.get(23);
String stateName=convertedWords.get(24);
String selectStateName=convertedWords.get(25);
String Validate_Mesg_For_Group_Name=convertedWords.get(26);
String SelectHubName=convertedWords.get(27);
String HubName= convertedWords.get(28);
String HubId=convertedWords.get(29);
String cityName=convertedWords.get(30);
String selectCity=convertedWords.get(31);
String userAuthority=cf.getUserAuthority(systemid,userId);
%>

<!DOCTYPE HTML>
<html>
 <head>
 
		<title><%=AssetGroup%></title>		
	</head>	    
	    <style>
  
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body height="100%">
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
   <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                              
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" />
   <%} %>
   <script>
    var pageName='<%=AssetGroup%>';
    var outerPanel;
    var ctsb;
    var jspName = "Asset Group";
    var exportDataType = "string";
    var selected;
    var grid;
    var buttonValue;
    var assetgroupstate;
    var assetgroupcity;
    var titel;
    var myWin;
    var globalCustomerID=parent.globalCustomerID;
    var hubIdModify;
    Ext.Ajax.timeout = 360000;
    Ext.override(Ext.grid.GridView, {
        afterRender: function () {
            this.mainBody.dom.innerHTML = this.renderRows();
            this.processRows(0, true);
            if (this.deferEmptyText !== true) {
                this.applyEmptyText();
            }
            this.fireEvent("viewready", this); //new event
        }
    });
	Ext.EventManager.onWindowResize(function () {
	var width = Ext.getBody().getViewSize().width-10;
	var height = '100%';
    var tmpHeight = Ext.getBody().getViewSize().height - 160;
    //var height = Ext.getBody().getViewSize().height - 140;
    grid.setSize(width, height);
	outerPanel.setSize(width, height);
	outerPanel.doLayout();
	});
	//to disable/enable when pop up opens ***************************************************************************************************
	function disableTabElements(){
		parent.Ext.getCmp('customerInformationTab').disable(true);
		parent.Ext.getCmp('productFeaturetab').disable(true);
		parent.Ext.getCmp('customizationTab').disable(true);
		parent.Ext.getCmp('userManagementTab').disable(true);
		if (parent.Ext.getCmp('userFeatureDetachmentTab')){
		parent.Ext.getCmp('userFeatureDetachmentTab').disable(true);
		}
		if (parent.Ext.getCmp('roleManagementTab')){
		parent.Ext.getCmp('roleManagementTab').disable(true);
		}
		parent.Ext.getCmp('assetassociationTab').disable(true);
	}
	function enableTabElements(){
			parent.Ext.getCmp('customerInformationTab').enable(true);
			parent.Ext.getCmp('productFeaturetab').enable(true);
			parent.Ext.getCmp('customizationTab').enable(true);
			parent.Ext.getCmp('userManagementTab').enable(true);
			if (parent.Ext.getCmp('userFeatureDetachmentTab')){
		parent.Ext.getCmp('userFeatureDetachmentTab').enable(true);
		}
		if (parent.Ext.getCmp('roleManagementTab')){
		parent.Ext.getCmp('roleManagementTab').enable(true);
		}
			parent.Ext.getCmp('assetassociationTab').enable(true);
	}
    //************************************************Store for getting customer name**************************************************************
    var custmastcombostore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
        id: 'CustomerStoreId',
        root: 'CustomerRoot',
        autoLoad: true,
        remoteSort: true,
        fields: ['CustId', 'CustName','Status','ActivationStatus'],
        listeners: {
            load: function (custstore, records, success, options) {
                if ( <%= customeridlogged %> > 0) {
                Ext.getCmp('custmastcomboId').setValue(<%=customeridlogged%>);
                    store.load({
                        params: {
                            customerID:<%= customeridlogged %>
                        }
                    });
                    supervisordetailsstore.load({
                        params: {
                            CustId:<%= customeridlogged %>
                        }
                    });
                    statedetailsstore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                    
                     hubNameStore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                }
                else if(<%= CustIdPassed %> > 0)
                {
                Ext.getCmp('custmastcomboId').setValue(<%=CustIdPassed%>);
                store.load({
                        params: {
                            customerID:<%= CustIdPassed %>
                        }
                    });
                    supervisordetailsstore.load({
                        params: {
                            CustId:<%= CustIdPassed %>
                        }
                    });
                    statedetailsstore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                    
                     hubNameStore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                }
                else if(globalCustomerID!=0)
                {
                Ext.getCmp('custmastcomboId').setValue(globalCustomerID);
                store.load({
                        params: {
                            customerID:globalCustomerID
                        }
                    });
                    supervisordetailsstore.load({
                        params: {
                            CustId:globalCustomerID
                        }
                    });
                    statedetailsstore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                    
                     hubNameStore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                }
            }
        }
    });

    //************************************************* Combo for Customer Name*****************************************************
    var custnamecombo = new Ext.form.ComboBox({
        store: custmastcombostore,
        id: 'custmastcomboId',
        mode: 'local',
        hidden: false,
        resizable: false,
        forceSelection: true,
        emptyText: '<%=selectCustomer%>',
        blankText: '<%=selectCustomer%>',
        selectOnFocus: true,
        allowBlank: false,
        typeAhead: true,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'CustId',
        displayField: 'CustName',
        listWidth : 200,
        cls: 'selectstyle',
        listeners: {
            select: {
                fn: function () {
                    parent.globalCustomerID=Ext.getCmp('custmastcomboId').getValue();
                    store.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                    supervisordetailsstore.load({
                        params: {
                            CustId: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                    statedetailsstore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                    
                    hubNameStore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                        }
                    });
                }
            }
        }
    });
        //*****************************************Store for getting State Details*******************************************************************
    var statedetailsstore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=getStateDetails',
        id: 'StateStoreId',
        root: 'StateRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['StateId', 'StateName']
    });
 //************************************************* Combo for State Name*****************************************************
    var statenamecombo = new Ext.form.ComboBox({
        store: statedetailsstore,
        id: 'statecomboId',
        mode: 'local',
        hidden: false,
        resizable: false,
        forceSelection: true,
        emptyText: '<%=selectStateName%>',
        blankText: '<%=selectStateName%>',
        selectOnFocus: true,
        allowBlank: false,
        typeAhead: true,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'StateId',
        displayField: 'StateName',
        listWidth : 200,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                	Ext.getCmp('cityComboId').reset();
                	cityStore.load({
                		params:{
                			stateId : Ext.getCmp('statecomboId').getValue()
                		}
                	});
                }
            }
        }
    });
  //*****************************************Store for getting City Details*******************************************************************
    var cityStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=getCityDetails',
        id: 'cityStoreId',
        root: 'cityRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['cityId', 'cityName']
    });
 //************************************************* Combo for City Name*****************************************************
    var cityCombo = new Ext.form.ComboBox({
        store: cityStore,
        id: 'cityComboId',
        mode: 'local',
        hidden: false,
        resizable: false,
        forceSelection: true,
        emptyText: '<%=selectCity%>',
        blankText: '<%=selectCity%>',
        selectOnFocus: true,
        allowBlank: false,
        typeAhead: true,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'cityId',
        displayField: 'cityName',
        listWidth : 200,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                }
            }
        }
    });
    
        var hubNameStore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=getHubNames',
        id: 'hubStoreId',
        root: 'hubNameRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['hubId', 'hubName']
    });
 //************************************************* Combo for State Name*****************************************************
    var hubNameCombo = new Ext.form.ComboBox({
        store: hubNameStore,
        id: 'hubcomboId',
        mode: 'local',
        hidden: false,
        resizable: true,
        forceSelection: true,
        emptyText: '<%=SelectHubName%>',
        blankText: '<%=SelectHubName%>',
        selectOnFocus: true,
        allowBlank: false,
        typeAhead: true,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'hubId',
        displayField: 'hubName',
        listWidth : 200,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                }
            }
        }
    });
    //*****************************************Store for getting Supervisor Details*******************************************************************
    var supervisordetailsstore = new Ext.data.JsonStore({
        url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=getSupervisorDetails',
        id: 'SupervisorStoreId',
        root: 'SupervisorRoot',
        autoLoad: false,
        remoteSort: true,
        fields: ['UserId', 'SupervisorName', 'SupervisorPhone', 'SupervisorEmail']
    });

    //**************************************** Combo for Supervisorname ******************************************************************************
    var assetSupervisorNameCombo = new Ext.form.ComboBox({
        store: supervisordetailsstore,
        id: 'assetsupcomboId',
        mode: 'local',
        forceSelection: true,
        emptyText: '<%=selectSupervisor%>',
        blankText: '<%=selectSupervisor%>',
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'UserId',
        displayField: 'SupervisorName',
        listWidth : 200,
        cls: 'selectstylePerfect',
        listeners: {
            select: {
                fn: function () {
                    Ext.getCmp('supervisoremailid').reset();
                    Ext.getCmp('supervisornoid').reset();
                    var superId = Ext.getCmp('assetsupcomboId').getValue();
                    var email = "";
                    var phone = "";

                    var idx = supervisordetailsstore.findBy(function (record) {
                        if (record.get('UserId') == superId) {
                            email = record.get('SupervisorEmail');
                            phone = record.get('SupervisorPhone');
                        }
                    });

                    Ext.getCmp('supervisoremailid').setValue(email);
                    Ext.getCmp('supervisornoid').setValue(phone);
                }
            }
        }
    });
    //********************************************* Inner Pannel **************************************************************************************
    var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: false,
        height: 260,
        width: '100%',
        frame: true,
        id: 'custMaster',
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [
            {
                cls: 'mandatoryfield'
            },{
                cls: 'labelstyle'
            }, {
                cls: 'labelstyle'
            },
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryassetgroup'
            }, 
			{
                xtype: 'label',
                text: '<%=AsserGroupName%>'+' :',
                cls: 'labelstyle',
                id: 'assetgroupnametxt'
            }, {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                maskRe: /([a-zA-Z0-9\s]+)$/,
                regexText:'<%=Validate_Mesg_For_Group_Name%>',
                id: 'assetgroupnameid'
            },
            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryassetgroupnew'
            },
            
            {
                xtype: 'label',
                text: '<%=AsserGroupName%>'+' :',
                cls: 'labelstyle',
                id: 'assetgroupnamenewtxt'
            }, {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                maskRe: /([a-zA-Z0-9\s]+)$/,
                regexText:'<%=Validate_Mesg_For_Group_Name%>',
                id: 'assetgroupnamenewid'
            },{
                cls: 'mandatoryfield'
            },{
                xtype: 'label',
                text: '<%=stateName%>'+' :',
                cls: 'labelstyle',
                id: 'assetstatenametxt'
              },statenamecombo,
              {
                cls: 'mandatoryfield'
            },{
                xtype: 'label',
                text: '<%=cityName%>'+' :',
                cls: 'labelstyle',
                id: 'cityNameLable'
              },cityCombo,
			 {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'assetsupervisorcombp'
            },
             {
                xtype: 'label',
                text: '<%=SuperVisorName%>'+' :',
                cls: 'labelstyle',
                id: 'supervisornamenametxt'
            },
            assetSupervisorNameCombo,
            {
                cls: 'mandatoryfield'
            }, {
                xtype: 'label',
                text: '<%=SupervisorEmail%>'+' :',
                cls: 'labelstyle',
                id: 'supervisoremailtxt'
            }, {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                readOnly: true,
                id: 'supervisoremailid'
            },
            {
                cls: 'mandatoryfield'
            }, {
                xtype: 'label',
                text: '<%=SupervisorNo%>'+' :',
                cls: 'labelstyle',
                id: 'supervisornotxt'
            }, {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                readOnly: true,
                id: 'supervisornoid'
            },{
                cls: 'mandatoryfield'
            },{
                xtype: 'label',
                text: '',
                cls: 'labelstyle',
                id: 'hubnameTxt'
              },hubNameCombo,
            
            {cls: 'mandatoryfield'},{
                xtype: 'textfield',
                text: 'Group ID:',
                hidden: true,
                cls: 'textrnumberstyle',
                id: 'assetgroupid'
            },{cls: 'labelstyle'}
            
        ]
    });
    var winButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 50,
        width: '100%',
        frame: true,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        buttons:[{
            xtype: 'button',
            text: '<%=Save%>',
            id: 'addButtId',
            iconCls:'savebutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function () {
						if (Ext.getCmp('assetgroupnameid').getValue() == "") {
						    Ext.example.msg("<%=enterAssetGroup%>");
           					Ext.getCmp('assetgroupnameid').focus();
           					return;
       						}
       					if (Ext.getCmp('assetsupcomboId').getValue() == "") {
       					    Ext.example.msg("<%=selectSupervisor%>");
           					Ext.getCmp('assetsupcomboId').focus();
           					return;
       						}
       					if(Ext.getCmp('assetgroupnameid').getValue()==Ext.getCmp('assetgroupnamenewid').getValue())
       					{
       					var assetgroupnew=null;
       					}
       					else
       					{
       					assetgroupnew=Ext.getCmp('assetgroupnamenewid').getValue();
       					}
       					if(Ext.getCmp('statecomboId').getValue()== "")
       					{
       					assetgroupstate=0;
       					}
       					else
       					{	
       					assetgroupstate=Ext.getCmp('statecomboId').getValue();
       					}
       					assetgroupcity=Ext.getCmp('cityComboId').getValue();                			
			           
			               if (buttonValue == 'modify') {
                        var selected = grid.getSelectionModel().getSelected();
                        
                        if (selected.get('hubNameIndex') != Ext.getCmp('hubcomboId').getValue()) {
                            hubIdModify = Ext.getCmp('hubcomboId').getValue();
                        } else {
                            hubIdModify = selected.get('hubIdIndex');
                        }
                        
                        if(Ext.getCmp('cityComboId').getValue()== "")
       					{
       						assetgroupcity=0;
       					}
       					else
       					{	if(Ext.getCmp('cityComboId').getRawValue()==selected.get('cityName')){
       							assetgroupcity=selected.get('cityId');
       						}else{
       							assetgroupcity=Ext.getCmp('cityComboId').getValue();
       						}
       					}
                    }
                    //Ajax request starts here
			            outerPanelWindow.getEl().mask();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=saveormodifyAssetGroup',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                assetGroupName: Ext.getCmp('assetgroupnameid').getValue(),
                                assetSupervisor: Ext.getCmp('assetsupcomboId').getValue(),
                                customerID: Ext.getCmp('custmastcomboId').getValue(),
                                assetnewGroupName:assetgroupnew,
                                assetnewGroupid: Ext.getCmp('assetgroupid').getValue(),
                                assetgroupstate:assetgroupstate,
                                cityId:assetgroupcity,
                                hubId:Ext.getCmp('hubcomboId').getValue(),
                                hubIdModify:hubIdModify,
                                pageName: pageName
                            },
                            success: function (response, options) {
                                 var str=response.responseText;
								var array = str.split(",");
								var message = array[0];
								var groupid = array[1];
                                store.load({
                                    params: {customerID: Ext.getCmp('custmastcomboId').getValue()},
                                    callback:function(){
														  var rownum=grid.store.findExact( 'assetgroupidIndex', groupid);
														  grid.getSelectionModel().selectRow(rownum);
														 }
                               			  });
                               			  
                          hubNameStore.load({
                        params: {
                            customerID: Ext.getCmp('custmastcomboId').getValue()
                               }
                       });
                                 Ext.example.msg(message);
                                enableTabElements();
                                outerPanelWindow.getEl().unmask();  
                                myWin.hide();

                            },
                            failure: function () {

                                Ext.example.msg("Error");
                                enableTabElements();
                                outerPanelWindow.getEl().unmask();  
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
            iconCls:'cancelbutton',
            cls: 'buttonstyle',
            width: 70,
            listeners: {
                click: {
                    fn: function () {
                        myWin.hide();
						enableTabElements();
                    }
                }
            }
        }]

    });
    var outerPanelWindow = new Ext.Panel({
        width: '100%',
        height:330,
        standardSubmit: true,
        frame: false,
        items: [innerPanel, winButtonPanel]
    });

    myWin = new Ext.Window({
        title: titel,
        closable: false,
        resizable:false,
        modal: true,
        autoScroll: false,
        height: 365,
        width: '40%',
        id: 'myWin',
        items: [outerPanelWindow]
    });
    
    var buttonPanel=new Ext.FormPanel({
		 id: 'buttonid',
		 width:'100%',
		 height:10,
		 layout: 'fit',
		 frame:true,
		 buttons:[{
			       text: '<%=next%>',
			       iconCls:'nextbutton',
			       handler : function(){
			       gotoProductFeature();
			       }
			      }]		      
	});
	function gotoProductFeature()
	{
	 if(grid.getSelectionModel().getCount()==0){
	                        Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}
      if(grid.getSelectionModel().getCount()>1){
                            Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}
	var selected = grid.getSelectionModel().getSelected();
	var groupID=selected.get('assetgroupidIndex');
    var customerId=Ext.getCmp('custmastcomboId').getValue();
    var assetgroupassociationurl='<%=request.getContextPath()%>/Jsps/Admin/ProductFeature.jsp?feature=<%=feature%>&CustId='+customerId+'&GroupId='+groupID+'';
	parent.Ext.getCmp('assetassociationTab').enable();
	parent.Ext.getCmp('assetassociationTab').show();
	parent.Ext.getCmp('assetassociationTab').update("<iframe style='width:100%;height:530px;border:0;'  src='"+assetgroupassociationurl+"'></iframe>");
	}  
    //*************************************************Function for ADD button**************************************************************************

    function addRecord() {
    	if (Ext.getCmp('custmastcomboId').getValue() == "") {
    	                    Ext.example.msg("<%=selectCustomer%>");
           					Ext.getCmp('custmastcomboId').focus();
           					return;
       						}
        buttonValue = "add";
        titel = '<%=addAssetGroup%>';
        disableTabElements();
        myWin.show();
        myWin.setTitle(titel);
        Ext.getCmp('assetgroupnameid').show();
        Ext.getCmp('assetgroupnametxt').show();
        Ext.getCmp('mandatoryassetgroup').show();
        Ext.getCmp('assetgroupnameid').reset();
        Ext.getCmp('hubcomboId').hide();
        Ext.getCmp('statecomboId').reset();
        Ext.getCmp('cityComboId').reset();
        Ext.getCmp('assetsupcomboId').reset();
        Ext.getCmp('supervisoremailid').reset();
        Ext.getCmp('supervisornoid').reset();
        Ext.getCmp('assetgroupnamenewtxt').hide();
        Ext.getCmp('assetgroupnamenewid').hide();
        Ext.getCmp('mandatoryassetgroupnew').hide();
    }
    //***************************************************Function for Modify Button***********************************************************************

    function modifyData() {
    if (Ext.getCmp('custmastcomboId').getValue() == "") {
                            Ext.example.msg("<%=selectCustomer%>");
           					Ext.getCmp('custmastcomboId').focus();
           					return;
       						}
    if(grid.getSelectionModel().getSelected().get('assetgroupnameIndex').trim()== Ext.getCmp('custmastcomboId').getRawValue().trim())
    {
                            Ext.example.msg("<%=Cannot_Modify_Default_Asset_Group%>");
           					return;
    }
    if(grid.getSelectionModel().getCount()>1){
                            Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}
    if (Ext.getCmp('custmastcomboId').getValue() == "") {
                             Ext.example.msg("<%=selectCustomer%>");
           					Ext.getCmp('custmastcomboId').focus();
           					return;
       						}
    if (grid.getSelectionModel().getSelected() == null) {
                            Ext.example.msg("<%=noRowsSelected%>");
           					Ext.getCmp('custmastcomboId').focus();
           					return;
       						}
        buttonValue = "modify";
        disableTabElements();
        titel = "<%=modifyAssetGroup%>"
        myWin.setTitle(titel);
        Ext.getCmp('assetgroupnameid').reset();
        Ext.getCmp('assetgroupnameid').hide();
        Ext.getCmp('assetgroupnametxt').hide();
        Ext.getCmp('mandatoryassetgroup').hide();
        Ext.getCmp('hubcomboId').hide();
        Ext.getCmp('assetsupcomboId').reset();
        Ext.getCmp('supervisoremailid').reset();
        Ext.getCmp('supervisornoid').reset();
        Ext.getCmp('assetgroupnamenewtxt').show();
        Ext.getCmp('assetgroupnamenewid').show();
        Ext.getCmp('mandatoryassetgroupnew').show();
        Ext.getCmp('assetgroupnamenewid').reset();
        var selected = grid.getSelectionModel().getSelected();
        myWin.show();
        Ext.getCmp('assetgroupnameid').setValue(selected.get('assetgroupnameIndex'));
        Ext.getCmp('assetgroupnamenewid').setValue(selected.get('assetgroupnameIndex'));
        Ext.getCmp('statecomboId').setValue(selected.get('statecode'));
        cityStore.load({
       		params:{
       			stateId : Ext.getCmp('statecomboId').getValue()
       		}
       			});
       		if(selected.get('cityId')!=0){
		          Ext.getCmp('cityComboId').setValue(selected.get('cityName'));
		        }else{
		          Ext.getCmp('cityComboId').reset();
		        }
       
        
        if(selected.get('supervisoridIndex')!='undefined'||selected.get('supervisoridIndex')!=0)
        {
        Ext.getCmp('assetsupcomboId').setValue(selected.get('supervisoridIndex'));
        Ext.getCmp('supervisoremailid').setValue(selected.get('supervisoremailIndex'));
        Ext.getCmp('supervisornoid').setValue(selected.get('supervisornoIndex'));
        }
        Ext.getCmp('assetgroupid').setValue(selected.get('assetgroupidIndex'));
        Ext.getCmp('hubcomboId').setValue(selected.get('hubNameIndex'));
    }
    //************************************************Function for Deleting Record**********************************************************************

    function deleteData() {
    if (Ext.getCmp('custmastcomboId').getValue() == "") {
                             Ext.example.msg("<%=selectCustomer%>");
           					Ext.getCmp('custmastcomboId').focus();
           					return;
       						}
    if(grid.getSelectionModel().getSelected().get('assetgroupnameIndex').trim()== Ext.getCmp('custmastcomboId').getRawValue().trim())
    {
                            Ext.example.msg("<%=Cannot_Delete_Default_Asset_Group%>");
           					return;
    }
    if(grid.getSelectionModel().getCount()>1){
                             Ext.example.msg("<%=selectSingleRow%>");
           					return;
       						}
    if (Ext.getCmp('custmastcomboId').getValue() == "") {
                            Ext.example.msg("<%=selectCustomer%>");
           					Ext.getCmp('custmastcomboId').focus();
           					return;
       						}
    if (grid.getSelectionModel().getSelected() == null) {
                            Ext.example.msg("<%=noRowsSelected%>");
           					Ext.getCmp('custmastcomboId').focus();
           					return;
       						}
        var selected = grid.getSelectionModel().getSelected();
        var groupID = selected.get('assetgroupidIndex');


        Ext.Msg.show({
            title: '<%=delete%>',
            msg: '<%=wantToDelete%>',
            buttons: {
                yes: true,
                no: true
            },
            fn: function (btn) {
                switch (btn) {
                case 'yes':
                    ctsb.showBusy('<%=deleting%>');
                    outerPanel.getEl().mask();
                    //Ajax request
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=deleteAssetGroupDetails',
                        method: 'POST',
                        params: {
                            assetgroupID: groupID,
                            customerID: Ext.getCmp('custmastcomboId').getValue(),
                            customerName:Ext.getCmp('custmastcomboId').getRawValue(),
                            pageName: pageName
                            
                        },
                        success: function (response, options) {
                                Ext.example.msg(response.responseText);
                            store.reload();
                            outerPanel.getEl().unmask();
                        },
                        failure: function () {
                            Ext.example.msg("Error");
                            store.reload();
                            outerPanel.getEl().unmask();

                        }
                    });

                    break;
                case 'no':
                    Ext.example.msg("Asset Group not Deleted");
                    store.reload();
                    break;

                }
            }
        });

    }
    //********************************************Grid config starts***************************************************************************************
    // **********************************************Reader configs****************************************************************************************
    var reader = new Ext.data.JsonReader({
        idProperty: 'assetgroupdetailid',
        root: 'AssetGroupRoot',
        totalProperty: 'total',
        fields: [{
            name: 'slnoIndex'
        }, {
            name: 'assetgroupidIndex'
        }, {
            name: 'assetgroupnameIndex'
        }, {
            name: 'supervisoridIndex'
        }, {
            name: 'supervisornameIndex'
        }, {
            name: 'supervisoremailIndex'
        }, {
            name: 'supervisornoIndex'
        }, {
        	name:'status'
        }, {
        	name:'statecode'
        }, {
        	name:'statename'
        }, {
        	name:'cityId'
        }, {
        	name:'cityName'
        }, {
        	name:'hubIdIndex'
        } 
        ,{
        	name:'hubNameIndex'
        }
        ]
    });

    //********************************************************* Store Configs********************************************************************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/AssetGroupAction.do?param=getAssetGroupDetails',
            method: 'POST'
        }),
        remoteSort: false,
        sortInfo: {
            field: 'assetgroupnameIndex',
            direction: 'ASC'
        },
        storeId: 'assetgroupdetailid',
        reader: reader
        });
        store.on('beforeload', function (store, operation, eOpts) {
                operation.params = {
                    customerID: Ext.getCmp('custmastcomboId').getValue()
                };
            }, this);
   
    //********************************************************************Filter Config************************************************************************************
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{
            type: 'numeric',
            dataIndex: 'slnoIndex'
        }, {
            type: 'string',
            dataIndex: 'assetgroupidIndex'
        }, {
            type: 'string',
            dataIndex: 'assetgroupnameIndex'
        }, {
            type: 'string',
            dataIndex: 'supervisoridIndex'
        }, {
            type: 'string',
            dataIndex: 'supervisornameIndex'
        }, {
            type: 'string',
            dataIndex: 'supervisoremailIndex'
        }, {
            type: 'string',
            dataIndex: 'supervisornoIndex'
        },{
         	type:'string',
         	dataIndex:'status'
         },{
         	type:'string',
         	dataIndex:'statecode'
         },{
         	type:'string',
         	dataIndex:'statename'
         }, {
         	type:'string',
         	dataIndex:'cityId'
         }, {
         	type:'string',
         	dataIndex:'cutyName'
         }, {
         	type:'int',
         	dataIndex:'hubIdIndex'
         }
         ,{
         	type:'string',
         	dataIndex:'hubNameIndex'
         }
         ]
    });

    //*********************************************Column model config***************************************************************************
    var createColModel = function (finish, start) {

        var columns = [
            new Ext.grid.RowNumberer({
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                width: 50
            }), {
                dataIndex: 'slnoIndex',
                hidden: true,
                header: "<span style=font-weight:bold;><%=SLNO%></span>",
                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;>Asset Group Id</span>",
                dataIndex: 'assetgroupidIndex',
                hidden: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=AsserGroupName%></span>",
                dataIndex: 'assetgroupnameIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>Supervisor ID</span>",
                dataIndex: 'supervisoridIndex',
                hidden: true,
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=SuperVisorName%></span>",
                dataIndex: 'supervisornameIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=SupervisorEmail%></span>",
                dataIndex: 'supervisoremailIndex',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;><%=SupervisorNo%></span>",
                dataIndex: 'supervisornoIndex',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=RegistrationStatus%></span>",
                dataIndex: 'status',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=stateName%></span>",
                dataIndex: 'statename',
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;>State code</span>",
                dataIndex: 'statecode',
                hidden:true,
                filter: {
                    type: 'string'
                }
            },{
                header: "<span style=font-weight:bold;><%=cityName%></span>",
                dataIndex: 'cityName'
            },{
                header: "<span style=font-weight:bold;>City code</span>",
                dataIndex: 'cityId',
                hidden:true
            },{
                header: "<span style=font-weight:bold;><%=HubId%></span>",
                dataIndex: 'hubIdIndex',
                hidden:true,
                filter: {
                    type: 'int'
                }
            }
            ,{
                header: "<span style=font-weight:bold;><%=HubName%></span>",
                dataIndex: 'hubNameIndex',
                hidden:true,
                hideable:true,
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
    //*****************************************************************Grid *******************************************************************************
   
   
<%
if(customeridlogged > 0 )
{
	if(userAuthority.equalsIgnoreCase("Admin"))
	{%> 
    grid = getGridManager('', 'NoRecordsFound', store,screen.width-25,410, 17, filters, 'Clear Filter Data', false, '', 14, false, '', false, '', false, '', jspName, exportDataType, false, '', true, 'Add', true, 'Modify', true, 'Delete');
    <%} else if(userAuthority.equalsIgnoreCase("Supervisor")) {%>
    		 grid = getGridManager('', 'NoRecordsFound', store,screen.width-25,410, 17, filters, 'Clear Filter Data', false, '', 14, false, '', false, '', false, '', jspName, exportDataType, false, '', false, 'Add', false, 'Modify', false, 'Delete');
    <%} else 
    	{
    		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
    	}
} else {%>
	     grid = getGridManager('', 'NoRecordsFound', store,screen.width-25,410, 17, filters, 'Clear Filter Data', false, '', 14, false, '', false, '', false, '', jspName, exportDataType, false, '', true, 'Add', true, 'Modify', true, 'Delete');
<% }%>
    
    
    //***********************************************************Customer Panel Start************************************************************************ 
    var customerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        frame:false,
        cls: 'innerpanelsmallest',
        id: 'custMaster',
        layout: 'table',
        layoutConfig: {
            columns: 3
        },
        items: [{
                xtype: 'label',
                text: '<%=CustomerName%>' + '  :',
                allowBlank: false,
                hidden: false,
                cls: 'labellargestyle',
                id: 'custnamhidlab'
            },
            custnamecombo, {
                cls: 'labellargestyle'
            }
        ]
    });
    //****************************************************Main starts from here**************************************************************************
    Ext.namespace('Ext.ux');
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    Ext.onReady(function () {
        ctsb = tsb;
		Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            title: '',
            height:525,
            width:screen.width-25,
            renderTo: 'content',
            standardSubmit: true,
            frame: true,
            border:false,
            cls: 'outerpanel',
            items: [customerPanel, grid,buttonPanel]
            //bbar: ctsb  
        });
//*****************************To show response after submit      
			if(<%=responseaftersubmit%>!=''){
			Ext.example.msg("<%=responseaftersubmit%>");
	                     }
	      // Following code when rendering the grid                   
        grid.getView().on({
            viewready: {
                fn: function () {
                    grid.getSelectionModel().selectRow(0);
                }
            }
        });
        if(globalCustomerID!=0)
        {
        custmastcombostore.reload();
        }
			
    });
</script>
</body>
</html>