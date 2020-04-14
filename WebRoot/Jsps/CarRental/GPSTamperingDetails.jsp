<%@ page language="java"
	import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
String cityId=request.getParameter("cityId");
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

String FieldTamperingDetails= "Field Tampering Details";


int userId=loginInfo.getUserId(); 
int systemId = loginInfo.getSystemId();
int customerId = loginInfo.getCustomerId();

String userAuthority=cf.getUserAuthority(systemId,userId);	

boolean addAuth=false;
boolean modifyAuth=false;
if(userAuthority.equalsIgnoreCase("User")){
	addAuth = false;
	modifyAuth=false;
}else{
	addAuth = true;
	modifyAuth = true;
}
	

%>

<!DOCTYPE HTML>
<html>
	<head>
		<base href="<%=basePath%>">
		<title><%=FieldTamperingDetails%></title>
		<style>
		#filePath{
			width: 381px !important;
		    border-radius: 7px;
		    height: 23px;
		}
		#ext-comp-1066{
			display:none;
		}
		#filePath-file{
			padding-left: 16px;
		}
	</style>
	</head>
	<body>
	 <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
       <jsp:include page="../Common/ImportJSSandMining.jsp"/>
	   <jsp:include page="../IronMining/css.jsp" />
		<%}else {%>
		<jsp:include page="../Common/ImportJS.jsp" />
		<jsp:include page="../IronMining/css.jsp" />
		<%} %>
		 <jsp:include page="../Common/ExportJS.jsp" />
 <script>
  var outerPanel;
  var jspName = "GPSTamperingDetails";
  var exportDataType = "int,string,string,string,string,string,string";
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
                  cityStore.load();
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
              	cityStore.load();
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
              width: 25
          },{
              xtype: 'label',
              cls: 'labelstyle',
              id: 'startdatelab',
              width: 200,
              hidden:true,
              text: 'From Date' + ' :'
          }, {
              width: 5
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 120,
              format: getDateFormat(),
              emptyText: 'Select From Date',
              allowBlank: false,
              blankText: 'Select From Date',
              id: 'startdate',
              hidden:true,
              value: currentDate
          }, {
              width: 70
          }, {
              xtype: 'label',
              cls: 'labelstyle',
              id: 'enddatelab',
              hidden:true,
              width: 200,
              text: 'To Date' + ' :'
          }, {
              width: 5
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              width: 160,
              hidden:true,
              format: getDateFormat(),
              emptyText: 'Select To Date',
              allowBlank: false,
              blankText: 'Select To Date',
              id: 'enddate',
              value: nextDate
          }, {
              width: 20
          }, {
              xtype: 'button',
              text: 'View',
              id: 'submitId',
              cls: 'buttonStyle',
              hidden:true,
              width: 60,
              handler: function() {
              if (Ext.getCmp('custcomboId').getValue() == "") {
                  Ext.example.msg("Select Customer");
                  Ext.getCmp('custcomboId').focus();
                  return;
              }
              if (dateCompare(Ext.getCmp('startdate').getValue(), Ext.getCmp('enddate').getValue()) == -1) {
                  Ext.example.msg("To Date must be greater than From Date");
                  Ext.getCmp('enddate').focus();
                  return;
              }
          	 store.load({
	            params: {
	                 custId: Ext.getCmp('custcomboId').getValue(),
	                 jspName: jspName,
	                 custName: Ext.getCmp('custcomboId').getRawValue(),
	                 endDate: Ext.getCmp('enddate').getValue(),
	        		 startDate: Ext.getCmp('startdate').getValue(),
	        		 cityId: '<%= cityId %>'
	            }
           });
         }
       }]
  });
var cityStore= new Ext.data.JsonStore({
	url: '<%=request.getContextPath()%>/FieldTamperingAction.do?param=getCityName',
	root: 'cityRoot',
	autoLoad: false,
	id: 'cityStoreId',
	fields: ['cityId','cityName']
	});
	
	//****************************combo for OrgCode***************************************
var cityCombo = new Ext.form.ComboBox({
    store: cityStore,
    id: 'cityComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select City',
    blankText: 'Select City',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'cityId',
    displayField: 'cityName',
    cls:'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
           		vehicleStore.load({
                      params: {
                          cityId: Ext.getCmp('cityComboId').getValue()
                      }
                });
            }
        }
    }
});
	//****************************combo for tcno***************************************
var vehicleStore= new Ext.data.JsonStore({
	 url: '<%=request.getContextPath()%>/FieldTamperingAction.do?param=getVehicleNo',
	 root: 'vehicleNoRoot',
	 autoLoad: false,
	 id: 'vehicleRootId',
	 fields: ['vehicleNo','lastCommDate']
});

var vehicleCombo = new Ext.form.ComboBox({
    store: vehicleStore,
    id: 'vehicleNoComboId',
    mode: 'local',
    forceSelection: true,
    emptyText: 'Select Vehicle No',
    blankText: 'Select Vehicle No',
    resizable: true,
    selectOnFocus: true,
    allowBlank: true,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    lazyRender: true,
    valueField: 'vehicleNo',
    displayField: 'vehicleNo',
    cls:'selectstylePerfect',
    listeners: {
     select: {
       fn: function () {
       	   var row = vehicleStore.find('vehicleNo', Ext.getCmp('vehicleNoComboId').getValue());
           var rec = vehicleStore.getAt(row);
           Ext.getCmp('lastCommId').setValue(rec.data['lastCommDate']);
       }
     }
    }
});
    //******************************store for reason**********************************
    var reasonStore = new Ext.data.SimpleStore({
        id: 'storeId',
        fields: ['Name', 'Value'],
        autoLoad: true,
        data: [
            ['Connection tampering', 'Connection tampering'],
            ['Power wire tampered','Power wire tampered'],
            ['Ignition directed','Ignition directed'],
            ['Ground wire disconnected','Ground wire disconnected'],
            ['Device Missing','Device Missing'],
            ['Device damage','Device damage'],
            ['wire harness missing','wire harness missing'],
            ['wire harness damage','wire harness damage'],
            ['SIM’s tampering','SIM’s tampering'],
            ['SIM deactivated','SIM deactivated'],
            ['Device issue','Device issue']
        ]
    });
    //****************************combo for Permit request type****************************************
    var reasonCombo = new Ext.form.ComboBox({
        store: reasonStore,
        id: 'reasonComboId',
        mode: 'local',
        forceSelection: true,
        emptyText: 'Select Reason',
        resizable: true,
        selectOnFocus: true,
        allowBlank: false,
        anyMatch: true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
        valueField: 'Value',
        displayField: 'Name',
        cls: 'selectstylePerfect',
    });

 var fileUploadPanel = new Ext.FormPanel({
      fileUpload: true,
      width: '100%',
      frame: true,
      autoHeight: true,
      standardSubmit: false,
      labelWidth: 70,
      defaults: {
          anchor: '95%',
          allowBlank: false,
          msgTarget: 'side'
      },
      items: [{
          xtype: 'fileuploadfield',
          id: 'filePath',
          emptyText: 'Browse',
          fieldLabel: 'Choose File',
          name: 'filePath',
          buttonText: '',
          listeners: {
              fileselected: {
                  fn: function() {
                      var filePath = document.getElementById('filePath').value;
                      var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                      if (imgext == "jpg" || imgext == "jpeg") {} else {
                          Ext.MessageBox.show({
                              msg: 'Please select only .jpg or .jpeg files',
                              buttons: Ext.MessageBox.OK
                          });
                          Ext.getCmp('filePath').setValue("");
                          return;
                      }
                  }
              }
          }
      }],
      buttons: [{
          text: 'Upload',
          iconCls: 'uploadbutton',
          handler: function() {
              if (fileUploadPanel.getForm().isValid()) {
                  var filePath = document.getElementById('filePath').value;
                  var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                  if (imgext == "jpg" || imgext == "jpeg") {
                      //clearInputData();
                  } else {
                      Ext.MessageBox.show({
                          msg: 'Please select only .jpg or .jpeg files',
                          buttons: Ext.MessageBox.OK
                      });
                      Ext.getCmp('filePath').setValue("");
                      return;
                  }
                  var custId= Ext.getCmp('custcomboId').getValue()
                  fileUploadPanel.getForm().submit({
                  	  url: '<%=request.getContextPath()%>/UploadImage?filePath='+filePath,
                      enctype: 'multipart/form-data',
                      waitMsg: 'Uploading your file...',
                      success: function(response, action) {
						  Ext.example.msg("File Uploaded Successfulluy");
                      },
                      failure: function() {
                          Ext.example.msg("Error");
                      }
                  });
              }
          }
      },{
            text: 'Reset',
            handler: function(){
                fileUploadPanel.getForm().reset();
            }
       }]
  });

 var importPanelWindow = new Ext.Panel({
      cls: 'outerpanelwindow',
      frame: false,
      layout: 'column',
      width: 680,
      layoutConfig: {
          columns: 1
      },
      items: [fileUploadPanel]
  });
//******************************************Add and Modify function *********************************************************************//
  var innerPanelDetails = new Ext.form.FormPanel({
      standardSubmit: true,
      collapsible: false,
      //autoScroll: true,
      height: 200,
      width: 680,
      frame: true,
      id: 'innerPanelId',
      layout: 'table',
      resizable: true,
      layoutConfig: {
          columns: 4
      },
      items: [{
          xtype: 'fieldset',
          title: '<%=FieldTamperingDetails%>',
          cls: 'my-fieldset',
          collapsible: false, 
          autoScroll: true,
          colspan: 3,
          id: 'detailsid',
          width: 660,
          height: 180,
          layout: 'table',
          layoutConfig: {
              columns: 7
          },
          items: [ {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'cityManId'
          }, {
              xtype: 'label',
              text: 'City' + ' :',
              cls: 'labelstyle',
              id: 'cityLabelId'
          }, cityCombo,{width:30},{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'vehicleEmptyId'
          }, {
              xtype: 'label',
              text: 'Vehicle No' + ' :',
              cls: 'labelstyle',
              id: 'vehicleLabelId'
          },vehicleCombo,{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'lastCommEmptyId'
          }, {
              xtype: 'label',
              text: 'Last Comm Date' + ' :',
              cls: 'labelstyle',
              id: 'lastCommLabelId'
          }, {
              xtype: 'textfield',
              cls: 'selectstylePerfect',
              id: 'lastCommId',
              allowBlank: false,
              readOnly:true,
          }, {width:30},{
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'dateManId'
          }, {
              xtype: 'label',
              text: 'Date' + ' :',
              cls: 'labelstyle',
              id: 'dateLabId'
          }, {
              xtype: 'datefield',
              cls: 'selectstylePerfect',
              id: 'dateId',
              emptyText: 'Select Attended Date',
              blankText: 'Select Attended Date',
              format: getDateFormat(),
              submitFormat: getDateFormat(),
              value: previousDate,
              maxValue: previousDate
           }, {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'reasonManId'
          }, {
              xtype: 'label',
              text: 'Reason' + ' :',
              cls: 'labelstyle',
              id: 'reasonLabId'
          },  reasonCombo,{width:30},
          {
              xtype: 'label',
              text: '*',
              cls: 'mandatoryfield',
              id: 'resolutionManId'
          }, {
              xtype: 'label',
              text: 'Resolution' + ' :',
              cls: 'labelstyle',
              id: 'resolutionLabId'
          },  {
              xtype: 'textarea',
              cls: 'selectstylePerfect',
              id: 'resolutionId',
              allowBlank: false
          }]
    }]
  });
  
  var innerWinButtonPanel = new Ext.Panel({
      id: 'winbuttonid',
      standardSubmit: true,
      collapsible: false,
      autoHeight: true,
      height: 90,
      width: 680,
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
                      if (Ext.getCmp('cityComboId').getValue() == "") {
                          Ext.example.msg("Select City");
                          Ext.getCmp('cityComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('vehicleNoComboId').getValue() == "") {
                          Ext.example.msg("Select Vehicle");
                          Ext.getCmp('vehicleNoComboId').focus();
                          return;
                      }
                      if (Ext.getCmp('dateId').getValue() == "") {
                          Ext.example.msg("Select Date");
                          Ext.getCmp('dateId').focus();
                          return;
                      }
                      if(Ext.getCmp('dateId').getValue()>new Date()){
                      	  Ext.example.msg("Date should not be future date.");
                          Ext.getCmp('dateId').focus();
                          return;
                      }
                      if (Ext.getCmp('reasonComboId').getValue() == "") {
                          Ext.example.msg("Select Reason");
                          Ext.getCmp('reasonComboId').focus();
                          return;
                      }
                       if (Ext.getCmp('resolutionId').getValue() == "") {
                          Ext.example.msg("Enter Resolution");
                          Ext.getCmp('resolutionId').focus();
                          return;
                      }
                      if (Ext.getCmp('filePath').getValue() == "") {
                          Ext.example.msg("Please select Image to upload");
                          Ext.getCmp('filePath').focus();
                          return;
                      }
                      OuterPanelWindow.getEl().mask();
                      Ext.Ajax.request({
                          url: '<%=request.getContextPath()%>/FieldTamperingAction.do?param=addFieldTamperingDetails',
                          method: 'POST',
                          params: {
							 cityId: Ext.getCmp('cityComboId').getValue(),
							 vehicleNo: Ext.getCmp('vehicleNoComboId').getValue(),
							 attendanceDate: Ext.getCmp('dateId').getValue(),
							 reason : Ext.getCmp('reasonComboId').getValue(),
							 resolution: Ext.getCmp('resolutionId').getValue(),
							 filePath: Ext.getCmp('filePath').getValue()
                          },
                          success: function(response, options) {
                              var message = response.responseText;
                              console.log(message);
                              Ext.example.msg(message);
                              Ext.getCmp('cityComboId').reset();
       						  Ext.getCmp('vehicleNoComboId').reset();
       						  Ext.getCmp('dateId').reset();
       						  Ext.getCmp('reasonComboId').reset();
       						  Ext.getCmp('resolutionId').reset();
                              myWin.hide();
                              store.load({
					               params: {
					                 jspName: jspName,
					                 custName: Ext.getCmp('custcomboId').getRawValue(),
					                 endDate: Ext.getCmp('enddate').getValue(),
        		 					 startDate: Ext.getCmp('startdate').getValue(),
        		 					 cityId: '<%= cityId %>'
					               }
				              });
                              OuterPanelWindow.getEl().unmask();
                          },
                          failure: function() {
                              Ext.example.msg("Error");
                              Ext.getCmp('cityComboId').reset();
       						  Ext.getCmp('vehicleNoComboId').reset();
       						  Ext.getCmp('dateId').reset();
       						  Ext.getCmp('reasonComboId').reset();
       						  Ext.getCmp('resolutionId').reset();
                              store.load({
					               params: {
					                 jspName: jspName,
					                 custName: Ext.getCmp('custcomboId').getRawValue(),
					                 endDate: Ext.getCmp('enddate').getValue(),
        		 					 startDate: Ext.getCmp('startdate').getValue(),
        		 					 cityId: '<%= cityId %>'
					               }
				              });
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
      height: 400,
      standardSubmit: true,
      frame: true,
      items: [innerPanelDetails,importPanelWindow, innerWinButtonPanel]
  });
  
  myWin = new Ext.Window({
      title: 'titelForInnerPanel',
      closable: false,
      resizable: false,
      modal: true,
      autoScroll: false,
      height: 400,
      width: 700,
      frame: true,
      id: 'myWin',
      items: [OuterPanelWindow]
  });
  function addRecord() {
      if (Ext.getCmp('custcomboId').getValue() == "") {
          Ext.example.msg("<%=SelectCustomer%>");
          Ext.getCmp('custcomboId').focus();
          return;
      }
     
      buttonValue = '<%=Add%>';
      titelForInnerPanel = '<%=AddDetails%>';
      myWin.setPosition(200,50);
      myWin.show();
      myWin.setTitle(titelForInnerPanel);
      Ext.getCmp('cityComboId').reset();
	  Ext.getCmp('vehicleNoComboId').reset();
	  Ext.getCmp('dateId').reset();
	  Ext.getCmp('reasonComboId').reset();
	  Ext.getCmp('resolutionId').reset();
      
  }

   //***************************************************************************************//
  var reader = new Ext.data.JsonReader({
      idProperty: 'IdDetails',
      root: 'TamperingDetailsRoot',
      totalProperty: 'total',
      fields: [{
          name: 'slnoIndex'
      },{
          name: 'cityNameIndex'
      },{
          name: 'vehicleNoIndex'
      },{
          name: 'veheModelIndex'
      },{
          name: 'attendedDateIndex'
      },{
          name: 'reasonIndex'
      },{
          name: 'resolutionIndex'
      }]
  });
  
  var store = new Ext.data.GroupingStore({
      autoLoad: false,
      proxy: new Ext.data.HttpProxy({
          url: '<%=request.getContextPath()%>/FieldTamperingAction.do?param=getFieldTamperingDetails',
          method: 'POST'
      }),
      remoteSort: false,
      storeId: 'PlantDetails',
      reader: reader
  });
  
  var filters = new Ext.ux.grid.GridFilters({
      local: true,
      filters: [{
          type: 'numeric',
          dataIndex: 'slnoIndex'
      },{
          type: 'string',
          dataIndex: 'cityNameIndex'
      },{
          type: 'string',
          dataIndex: 'vehicleNoIndex'
      },{
          type: 'string',
          dataIndex: 'veheModelIndex'
      },{
          type: 'date',
          dataIndex: 'attendedDateIndex'
      },{
          type: 'string',
          dataIndex: 'reasonIndex'
      },{
          type: 'string',
          dataIndex: 'resolutionIndex'
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
              header: "<span style=font-weight:bold;>City Name</span>",
              dataIndex: 'cityNameIndex',
          },{
              header: "<span style=font-weight:bold;>Vehicle No</span>",
              dataIndex: 'vehicleNoIndex',
          },{
          	  header: "<span style=font-weight:bold;>Vehicle Model</span>",
              dataIndex: 'veheModelIndex',
          },{
              header: "<span style=font-weight:bold;>Attended Date</span>",
              //renderer: Ext.util.Format.dateRenderer(getDateFormat()),
              dataIndex: 'attendedDateIndex',
          },{
          	  header: "<span style=font-weight:bold;>Reason For NC</span>",
              dataIndex: 'reasonIndex',
          },{
          	  header: "<span style=font-weight:bold;>Action Taken</span>",
              dataIndex: 'resolutionIndex',
          }
      ];
      return new Ext.grid.ColumnModel({
          columns: columns.slice(start || 0, finish),
          defaults: {
              sortable: true
          }
      });
  };
  
  grid = getGrid('<%=FieldTamperingDetails%>', '<%=NoRecordsFound%>', store, screen.width - 40, 450, 10, filters, '<%=ClearFilterData%>', false, '', 9, false, '', false, '', true, 'Excel', jspName, exportDataType, false, 'PDF', true, '<%=Add%>', false, '<%=Modify%>', false, 'Delete');
 
 Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: '',
        renderTo: 'content',
        standardSubmit: true,
        frame: true,
        width: screen.width-25,
        cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [clientPanel, grid]
    });
    var cm =grid.getColumnModel();  
    for (var j = 1; j < cm.getColumnCount(); j++) {
       cm.setColumnWidth(j,210);
    }
    sb = Ext.getCmp('form-statusbar');
    store.load({
       params: {
         jspName: jspName,
         custName: Ext.getCmp('custcomboId').getRawValue(),
         endDate: Ext.getCmp('enddate').getValue(),
		 startDate: Ext.getCmp('startdate').getValue(),
		 cityId: '<%= cityId %>'
       }
     });
});

  </script>
<br></body>
</html>
<%}%>
