<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
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
		loginInfo.setStyleSheetOverride("N");
		if (str.length > 8) {
			loginInfo.setCustomerName(str[8].trim());
		}
		if (str.length > 9) {
			loginInfo.setCategoryType(str[9].trim());
		}
		if (str.length > 10) {
			loginInfo.setUserName(str[10].trim());
		}
		if(str.length>11){
		loginInfo.setCountryCode(Integer.parseInt(str[11].trim()));
		}
			session.setAttribute("loginInfoDetails", loginInfo);
		}
	CommonFunctions cf = new CommonFunctions();
	String ipVal = request.getParameter("ipVal");	
	LoginInfoBean loginInfo = (LoginInfoBean) session.getAttribute("loginInfoDetails");
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
tobeConverted.add("Modify_Details");
tobeConverted.add("Select_Customer");
tobeConverted.add("Customer_Name");

tobeConverted.add("Organization_Code");
tobeConverted.add("Organization_Name");
tobeConverted.add("Enter_Organization_Name");
tobeConverted.add("Enter_Organization_Code");
tobeConverted.add("Mining_Organization_Master");

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
String ModifyDetails=convertedWords.get(10);
String SelectCustomer=convertedWords.get(11);
String CustomerName=convertedWords.get(12);

String organizationCode=convertedWords.get(13);
String organizationName=convertedWords.get(14);
String EnterOrganizationName=convertedWords.get(15);
String EnterOrganizationCode=convertedWords.get(16);
String miningOrganizationMaster=convertedWords.get(17);

String impFines = "Imported Fines";
String impLumps = "Imported Lumps";
String impConcentrates = "Imported Concentrates";
String impTailings = "Imported Tailings";

int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	
if(customerId > 0 && loginInfo.getIsLtsp()== -1 && !userAuthority.equalsIgnoreCase("Admin"))
	{
		response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");
	}
	else{

%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">
		<title><%=miningOrganizationMaster%></title>
	
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
	   <jsp:include page="../IronMining/css.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
		
			<% String newMenuStyle=loginInfo.getNewMenuStyle();
			if(newMenuStyle.equalsIgnoreCase("YES")){%>
			<style>
				.ext-strict .x-form-text {
					height: 21px !important;
				}
				label {
					display : inline !important;
				}
				.x-window-tl *.x-window-header {
					padding-top : 6px !important;
					height : 38px !important;
				}
				.x-layer ul {
					min-height: 27px !important;
				}					
				.x-menu-list {
					height:auto !important;
				}
				
			</style>
		<%}%>
		 
 <script>
 var innerpage=<%=ipVal%>;
	
	   	    if (innerpage == true) {
				
				if(document.getElementById("topNav")!=null && document.getElementById("topNav")!=undefined)
				{
					document.getElementById("topNav").style.display = "none";
					$(".container").css({"margin-top":"-72px"});
				}
				
			}
  var outerPanel;
  var jspName = "OrganizationMaster";
  var exportDataType = "int,string,string,string,string,number,number,number,number,number,number,int";
  var grid;
  var myWin;
  var buttonValue;
  var orgCode;
  var orgName;
  var selected;
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
                  store.load({
                      params: {
                          CustId: custId,
                          custName: Ext.getCmp('custcomboId').getRawValue(),
                          jspName: jspName
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
      emptyText: '<%=SelectCustomer%>',
      resizable: true,
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
                  store.load({
                      params: {
                          CustId: custId,
                          custName: Ext.getCmp('custcomboId').getRawValue(),
                          jspName: jspName
                      }
                  });
              }
          }
      }
  });
  //*************************************************Client Panel**************************************************************//
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
              text: '<%=CustomerName%>' + ' :',
              cls: 'labelstyle',
              id: 'ltspcomboId'
          },
          custnamecombo, {
              width: 40
          }
      ]
  });
  //******************************************Add and Modify function *********************************************************************//
  var innerPanelForMiningOrgMasterDetails = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      autoScroll: true,
      height: 170,
      width: 480,
      frame: true,
      id: 'innerPanelForMiningOrgMasterDetailsId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: '<%=miningOrganizationMaster%>',
          cls: 'my-fieldset',
          collapsible: false, 
          autoScroll: true,
          colspan: 3,
          id: 'MiningOrgMasterDetailsid',
          width: 465,
          height: 145,
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
              id: 'orgCodeEmptyId'
          }, {
              xtype: 'label',
              text: '<%=organizationCode%>' + ' :',
              cls: 'labelstylenew',
              id: 'orgCodeLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              id: 'orgCodeID',
              allowBlank: false,
              blankText: '<%=EnterOrganizationCode%>',
              emptyText: '<%=EnterOrganizationCode%>',
              labelSeparator: '',
              listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase().trim());
					 if(field.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
				field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus(); 
					 } 
					}
					}
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'orgNameEmptyId'
          }, {
              xtype: 'label',
              text: '<%=organizationName%>' + ' :',
              cls: 'labelstylenew',
              id: 'orgNameLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: '<%=EnterOrganizationName%>',
              emptyText: '<%=EnterOrganizationName%>',
              labelSeparator: '',
              id: 'orgNameID',
              listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
 					if(field.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus(); }					}
					}
          },{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'aliasNameEmptyId'
          }, {
              xtype: 'label',
              text: 'Alias Name' + ' :',
              cls: 'labelstylenew',
              id: 'aliasNameLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: 'Enter Alias Name',
              emptyText: 'Enter Alias Name',
              labelSeparator: '',
              id: 'aliasNameId',
              listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
 					if(field.getValue().length> 20){ Ext.example.msg("Field exceeded it's Maximum length"); 
						field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus(); }					}
					}
          }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'gstNoEmptyId'
          }, {
              xtype: 'label',
              text: 'GST No' + ' :',
              cls: 'labelstylenew',
              id: 'gstNoLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfectnew',
              allowBlank: false,
              blankText: 'Enter GST No',
              emptyText: 'Enter GST No',
              labelSeparator: '',
              id: 'gstNoId',
              listeners:{
					change: function(field, newValue, oldValue){
					field.setValue(newValue.toUpperCase());
 					if(field.getValue().length> 50){ Ext.example.msg("Field exceeded it's Maximum length"); 
						field.setValue(newValue.substr(0,50).toUpperCase().trim()); field.focus(); }					
					}
			  }
          }]
    }]
  });
  
  var innerWinButtonPanel = new Ext.Panel({
      id: 'winbuttonid',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 90,
      width: 480,
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
          iconCls: 'savebutton',
          width: 70,
          listeners: {
              click: {
                  fn: function() {
                      if (Ext.getCmp('custcomboId').getValue() == "") {
                          Ext.example.msg("<%=SelectCustomer%>");
                          Ext.getCmp('custcomboId').focus();
                          return;
                      }
                      if (Ext.getCmp('orgCodeID').getValue() == "") {
                          Ext.example.msg("<%=EnterOrganizationCode%>");
                          Ext.getCmp('orgCodeID').focus();
                          return;
                      }
                      if (Ext.getCmp('orgNameID').getValue() == "") {
                          Ext.example.msg("<%=EnterOrganizationName%>");
                          Ext.getCmp('orgNameID').focus();
                          return;
                      }
                      if (Ext.getCmp('aliasNameId').getValue() == "") {
                          Ext.example.msg("Enter Alias Name");
                          Ext.getCmp('aliasNameId').focus();
                          return;
                      }
                      if (Ext.getCmp('gstNoId').getValue() == "") {
                          Ext.example.msg("Enter GST No");
                          Ext.getCmp('gstNoId').focus();
                          return;
                      }
                      var id;
                      if (buttonValue == '<%=Modify%>') {
                          selected = grid.getSelectionModel().getSelected();
                          id = selected.get('UniqueIDIndex');
                      }
                      MiningOrgMasterOuterPanelWindow.getEl().mask();
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/MiningOrganizationMasterAction.do?param=miningOrgMasterAddModify',
                          method: 'POST',
                          params: {
                              buttonValue: buttonValue,
                              CustID: Ext.getCmp('custcomboId').getValue(),
                              id: id,
                              orgCode:Ext.getCmp('orgCodeID').getValue(),
                              orgName:Ext.getCmp('orgNameID').getValue(),
                              aliasName:Ext.getCmp('aliasNameId').getValue(),
                              gstNo : Ext.getCmp('gstNoId').getValue()
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              Ext.example.msg(message);
                              Ext.getCmp('orgCodeID').reset();
       						  Ext.getCmp('orgNameID').reset();
       						  Ext.getCmp('aliasNameId').reset();
       						  Ext.getCmp('gstNoId').reset();
                              myWin.hide();
                              store.reload();
                              MiningOrgMasterOuterPanelWindow.getEl().unmask();
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                              Ext.getCmp('orgCodeID').reset();
       						  Ext.getCmp('orgNameID').reset();
       						  Ext.getCmp('aliasNameId').reset();
       						  Ext.getCmp('gstNoId').reset();
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
  
  var MiningOrgMasterOuterPanelWindow = new Ext.Panel({
      width: 490,
      height: 290,
      standardSubmit: true,
      frame: true,
      items: [innerPanelForMiningOrgMasterDetails, innerWinButtonPanel]
  });
  
  myWin = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 300,
      width: 500,
       frame: true,
      id: 'myWin',
      items: [MiningOrgMasterOuterPanelWindow]
  });

  function addRecord() {
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          Ext.getCmp('custcomboId').focus();
          return;
      }
     
      buttonValue = '<%=Add%>';
      titelForInnerPanel = '<%=AddDetails%>';
      myWin.setPosition(450,50);
      myWin.show();
      myWin.setTitle(titelForInnerPanel); 
      Ext.getCmp('orgCodeID').reset();
      Ext.getCmp('orgNameID').reset();
      Ext.getCmp('aliasNameId').reset();
      Ext.getCmp('gstNoId').reset();
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
          titelForInnerPanel = '<%=ModifyDetails%>';
          myWin.setPosition(450,50);
          myWin.setTitle(titelForInnerPanel);
          myWin.show();
          selected = grid.getSelectionModel().getSelected();
          Ext.getCmp('orgCodeID').setValue(selected.get('OrganizationCodeIndex'));
          Ext.getCmp('orgNameID').setValue(selected.get('OrganizationNameIndex'));
          Ext.getCmp('aliasNameId').setValue(selected.get('aliasNameIndex'));
          Ext.getCmp('gstNoId').setValue(selected.get('gstNoIndex'));
      }
      //***************************************************************************************//
  var reader = new Ext.data.JsonReader({
      idProperty: 'MiningOrgMasterDetails',
      root: 'MiningOrganizationMasterRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      },{
          name: 'UniqueIDIndex'
      },{
          name: 'OrganizationCodeIndex'
      },{
          name: 'OrganizationNameIndex'
      },{
          name: 'aliasNameIndex'
      },{
          name: 'gstNoIndex'
      },{
      	  name: 'purchROMIndex'
      },{
          name: 'mwalletBalanceDataIndex'
      },{
          name: 'impFinesDataIndex'
      },{
          name: 'impLumpsDataIndex'
      },{
          name: 'impConcentratesDataIndex'
      },{
          name: 'impTailingsDataIndex'    
      }]
  });
  
  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/MiningOrganizationMasterAction.do?param=getMiningOrganizationMasterDetails',
          method: 'POST'
      }),
      remoteSort: false,
      storeId: 'MiningOrgMasterDetails',
      reader: reader
  });
  
  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      },{
          type: 'string',
          dataIndex: 'OrganizationCodeIndex'
      },{
          type: 'string',
          dataIndex: 'OrganizationNameIndex'
      },{
          type: 'string',
          dataIndex: 'aliasNameIndex'
      },{
          type: 'string',
          dataIndex: 'gstNoIndex'
      },{
      	  type: 'numeric',
      	  dataIndex: 'purchROMIndex'
      },{
          type: 'numeric',
          dataIndex: 'mwalletBalanceDataIndex'
      },{
          type: 'numeric',
          dataIndex: 'impFinesDataIndex'
      },{
          type: 'numeric',
          dataIndex: 'impLumpsDataIndex'
      },{
          type: 'numeric',
          dataIndex: 'impConcentratesDataIndex'
      },{
          type: 'numeric',
          dataIndex: 'impTailingsDataIndex'    
      }]
  });
  var createColModel = function(finish, start) {
      var columns = [
          new Ext.grid.RowNumberer({
              header: "<span style=font-weight:bold;><%=SLNO%></span>",
              width: 50
          }),{
              dataIndex: 'slnoIndex',
              hidden: true,
              width: 50,
              header: "<span style=font-weight:bold;><%=SLNO%></span>"
          },{
              dataIndex: 'OrganizationCodeIndex',
              hidden: false,
              width: 200,
              header: "<span style=font-weight:bold;><%=organizationCode%></span>"
          },{
              dataIndex: 'OrganizationNameIndex',
              hidden: false,
              width: 200,
              header: "<span style=font-weight:bold;><%=organizationName%></span>"
          },{
              dataIndex: 'aliasNameIndex',
              hidden: false,
              width: 200,
              header: "<span style=font-weight:bold;>Alias Name</span>"
          },{
              dataIndex: 'gstNoIndex',
              hidden: false,
              width: 200,
              header: "<span style=font-weight:bold;>GST No</span>"
          },{
              dataIndex: 'purchROMIndex',
              hidden: true,
              align:'right',
              width: 200,
              header: "<span style=font-weight:bold;>Purchased ROM</span>"
          },{
              dataIndex: 'mwalletBalanceDataIndex',
              hidden: true,
              align:'right',
              width: 70,
              header: "<span style=font-weight:bold;>M-Wallet Balance</span>"
          },{
              dataIndex: 'impFinesDataIndex',
              hidden: true,
              align:'right',
              width: 70,
              header: "<span style=font-weight:bold;><%=impFines%></span>"
          },{
              dataIndex: 'impLumpsDataIndex',
              hidden: true,
              align:'right',
              width: 70,
              header: "<span style=font-weight:bold;><%=impLumps%></span>"
          },{
              dataIndex: 'impConcentratesDataIndex',
              hidden: true,
              align:'right',
              width: 70,
              header: "<span style=font-weight:bold;><%=impConcentrates%></span>"
          },{
              dataIndex: 'impTailingsDataIndex',
              hidden: true,
              align:'right',
              width: 70,
              header: "<span style=font-weight:bold;><%=impTailings%></span>"
          },{
              dataIndex: 'UniqueIDIndex',
              hidden: true,
              width: 50,
              header: "<span style=font-weight:bold;>ID</span>"
          },
      ];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: true
          }
      });
  };
  
  grid = getGrid('<%=miningOrganizationMaster%>', '<%=NoRecordsFound%>', store, screen.width - 80, 460, 37, filters, '<%=ClearFilterData%>', false, '', 23, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', true, '<%=Modify%>', false, 'Delete');
  
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
        items: [clientPanel, grid]
    });
    sb = Ext.getCmp('form-statusbar');
});

  </script>
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
 <script> 
	  if (innerpage == true) {
				
				
				var divsToHide = document.getElementsByClassName("footer"); //divsToHide is an array
				
					for(var i = 0; i < divsToHide.length; i++){
						divsToHide[i].style.display = "none"; // depending on what you're doing
						$(".container").css({"margin-top":"-72px"});
					}
			}
			
			</script>
<%}%>
<%}%>
 
