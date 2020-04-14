<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();

String responseaftersubmit="''";
if(session.getAttribute("responseaftersubmit")!=null){
	responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
	session.setAttribute("responseaftersubmit",null);
}
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");

int systemId=loginInfo.getSystemId();
int userId=loginInfo.getUserId();
//getting language
String language=loginInfo.getLanguage();
//getting client id
int customeridlogged=loginInfo.getCustomerId();
ArrayList<String> languageconvertionlabel=new ArrayList<String>();
languageconvertionlabel.add("Customer_Information");
languageconvertionlabel.add("Select_Customer");
languageconvertionlabel.add("Customer_Name");
languageconvertionlabel.add("Address");
languageconvertionlabel.add("City");
languageconvertionlabel.add("Select_Status");
languageconvertionlabel.add("Enter_Customer_name");
languageconvertionlabel.add("Enter_Address");
languageconvertionlabel.add("Enter_City_Name");
languageconvertionlabel.add("Delete");
languageconvertionlabel.add("want_to_delete");
languageconvertionlabel.add("Customer Not Deleted");
languageconvertionlabel.add("Phone_No");
languageconvertionlabel.add("Mobile");
languageconvertionlabel.add("Enter_Phone_No");
languageconvertionlabel.add("Enter_Mobile_No");
languageconvertionlabel.add("Fax");
languageconvertionlabel.add("Enter_Fax_No");
languageconvertionlabel.add("Status");
languageconvertionlabel.add("Next");
languageconvertionlabel.add("Error");
languageconvertionlabel.add("Deleting");
languageconvertionlabel.add("Select_State");
languageconvertionlabel.add("Select_Country");
languageconvertionlabel.add("Name");
languageconvertionlabel.add("New_Name");
languageconvertionlabel.add("Country");
languageconvertionlabel.add("State");
languageconvertionlabel.add("ZipCode");
languageconvertionlabel.add("Enter_Zip_Code");
languageconvertionlabel.add("Contact_Details");
languageconvertionlabel.add("Email_ID");
languageconvertionlabel.add("Enter_Email_Id");
languageconvertionlabel.add("Website");
languageconvertionlabel.add("Enter_Website");
languageconvertionlabel.add("Account_Status");
languageconvertionlabel.add("Save");
languageconvertionlabel.add("Cancel");
languageconvertionlabel.add("Add_Customer");
languageconvertionlabel.add("Next");
languageconvertionlabel.add("SLNO");
languageconvertionlabel.add("CUSTOMER_ID");
languageconvertionlabel.add("Modify_Customer_Information");
languageconvertionlabel.add("Registration_Status");
languageconvertionlabel.add("No_Records_Found");
languageconvertionlabel.add("Select_Single_Row"); 
languageconvertionlabel.add("Email_ID");
languageconvertionlabel.add("Validate_Mesg_For_Form");
languageconvertionlabel.add("Validate_Mesg_For_Customer_Name");
languageconvertionlabel.add("Validate_Mesg_For_Inactive_Cust");
languageconvertionlabel.add("Payment_Notification_Alert");
languageconvertionlabel.add("Payment_Due_Date");
languageconvertionlabel.add("Payment_Notification_Period");
languageconvertionlabel.add("OS_LIMIT");
languageconvertionlabel.add("Enter_Speed");
languageconvertionlabel.add("Snooze_Time");
languageconvertionlabel.add("Enter_Snooze_Time");
ArrayList<String> convertedWords=cf.getLanguageSpecificWordForKey(languageconvertionlabel,language);
String feature="1";
String CustomerInformation=convertedWords.get(0);
String selectCustomer=convertedWords.get(1);
String CustomerName=convertedWords.get(2);
String Address=convertedWords.get(3);
String City=convertedWords.get(4);
String selectStatus=convertedWords.get(5);
String enterCustName=convertedWords.get(6);
String enterAddr=convertedWords.get(7);
String enterCityName=convertedWords.get(8);
String delete=convertedWords.get(9);
String wantToDelete=convertedWords.get(10);
String custNotDeleted=convertedWords.get(11);
String phoneNo=convertedWords.get(12);
String mobile=convertedWords.get(13);
String enterPhoneNo=convertedWords.get(14);
String enterMobileNo=convertedWords.get(15);
String fax=convertedWords.get(16);
String enterFaxNo=convertedWords.get(17);
String status=convertedWords.get(18);
String next=convertedWords.get(19);
String error=convertedWords.get(20);
String deleting=convertedWords.get(21);
String selectState=convertedWords.get(22);
String SelectCountry=convertedWords.get(23);
String Name=convertedWords.get(24);
String NewName =convertedWords.get(25);
String Country =convertedWords.get(26);
String State=convertedWords.get(27);
String ZipCode =convertedWords.get(28);
String EnterZipCode =convertedWords.get(29);
String ContactDetails =convertedWords.get(30);
String EMailId=convertedWords.get(31);
String EnterEmailId =convertedWords.get(32);
String Website=convertedWords.get(33);
String EnterWebsite =convertedWords.get(34);
String AccountStatus =convertedWords.get(35);
String Save=convertedWords.get(36);
String Cancel=convertedWords.get(37);
String AddCustomer =convertedWords.get(38);
String Next=convertedWords.get(39);
String SLNO=convertedWords.get(40);
String CUSTOMERID =convertedWords.get(41);
String ModifyCustomerInformation =convertedWords.get(42);
String RegistrationStatus=convertedWords.get(43);
String NoRecordsFound=convertedWords.get(44);
String selectSingleRow=convertedWords.get(45);
String emailId=convertedWords.get(46);
String Validate_Mesg_For_Form=convertedWords.get(47);
String Validate_Mesg_For_Customer_Name=convertedWords.get(48);
String Validate_Mesg_For_Inactive_Cust=convertedWords.get(49);
String Payment_Notification_Alert=convertedWords.get(50);
String paymentduedate=convertedWords.get(51);
String paymentnotificationperiod=convertedWords.get(52);
String speedLimit=convertedWords.get(53);
String enterSpeed=convertedWords.get(54);
String snoozeTime = convertedWords.get(55);
String enterSnoozeTime = convertedWords.get(56);
String userAuthority=cf.getUserAuthority(systemId,userId);
//String unitOfMeasure = cf.getUnitOfMeasure(systemId);


%>

<!DOCTYPE HTML>
<html>
 <head>
	<title><%=CustomerInformation%></title>		
	<style>
	.x-panel-tl{
		border-bottom: 0px solid !important;
	}
	</style>
 </head>	    
 <body onload="refresh();" >
   	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>

<script>

<%
if( customeridlogged > 0 && loginInfo.getIsLtsp() == -1 && !userAuthority.equalsIgnoreCase("Admin"))
{
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/401Error.html");

}else{

%>  
/*******************resize window event function**********************/
Ext.EventManager.onWindowResize(function () {
	var width = '100%';
	var height = '100%';
	grid.setSize(width, height);
	outerPanel.setSize(width, height);
	outerPanel.doLayout();
});
var pageName='<%=CustomerInformation%>';
 var dtcur = datecur;
 var outerPanel;
 var ctsb;
 var jspName="CustomerMaster";
 var exportDataType="string";
 var selected;
 var grid;
 var buttonValue;
 var titel;
 var myWin;
 var custIdnew = <%=customeridlogged%>;
 var isLtsp= <%=loginInfo.getIsLtsp()%>;
 var store;
 
 /***********************In chrome activate was slow so refreshing the page***********************/
 function refresh() {
     isChrome = window.chrome;
     if (isChrome && parent.flagtab < 2) {
         setTimeout(function() {
             parent.Ext.getCmp('customerInformationTab').enable();
             parent.Ext.getCmp('customerInformationTab').show();
             if (custIdnew > 0 && isLtsp == -1) {

                // parent.Ext.getCmp('customerInformationTab').update("<iframe style='width:100%;height:595px;border:0;'src='<%=path%>/Jsps/Common/401Error.html?feature=1'></iframe>");
             } else {
                 //parent.Ext.getCmp('customerInformationTab').update("<iframe style='width:100%;height:595px;border:0;'src='<%=path%>/Jsps/Admin/CustomerMaster.jsp?feature=1'></iframe>");
             }
         }, 0);
         parent.adminTab.doLayout();
         parent.flagtab = parent.flagtab + 1;
     } else {
         if (custIdnew > 0 && isLtsp == -1) {
            // parent.Ext.getCmp('customerInformationTab').update("<iframe style='width:100%;height:595px;border:0;'src='<%=path%>/Jsps/Common/401Error.html?feature=1'></iframe>");
            // parent.adminTab.doLayout();
         }
     }
 }
 /***********************to disable/enable when pop up opens ****************************************************************************/
   function disableTabElements() {
      parent.Ext.getCmp('productFeaturetab').disable(true);
      parent.Ext.getCmp('customizationTab').disable(true);
      parent.Ext.getCmp('userManagementTab').disable(true);
      if (parent.Ext.getCmp('userFeatureDetachmentTab')){
		parent.Ext.getCmp('userFeatureDetachmentTab').disable(true);
		}
		if (parent.Ext.getCmp('roleManagementTab')){
		parent.Ext.getCmp('roleManagementTab').disable(true);
		}
      parent.Ext.getCmp('assetGroupTab').disable(true);
      parent.Ext.getCmp('assetassociationTab').disable(true);
  }

  function enableTabElements() {
      parent.Ext.getCmp('productFeaturetab').enable(true);
      parent.Ext.getCmp('customizationTab').enable(true);
      parent.Ext.getCmp('userManagementTab').enable(true);
      if (parent.Ext.getCmp('userFeatureDetachmentTab')){
		parent.Ext.getCmp('userFeatureDetachmentTab').enable(true);
		}
		if (parent.Ext.getCmp('roleManagementTab')){
		parent.Ext.getCmp('roleManagementTab').enable(true);
		}
      parent.Ext.getCmp('assetGroupTab').enable(true);
      parent.Ext.getCmp('assetassociationTab').enable(true);
  }
 /*************************override function for grid view taking first row as default*****************************************************/
	 Ext.override(Ext.grid.GridView, {
	    afterRender: function(){
	        this.mainBody.dom.innerHTML = this.renderRows();
	        this.processRows(0, true);
	        if(this.deferEmptyText !== true){
	            this.applyEmptyText();
	        }
	        this.fireEvent("viewready", this);//new event
	    }   
	});
/******store for getting State Name List******/
	var statestore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/CustomerAction.do?param=getStateList',
	    id: 'StateStoreId',
	    root: 'StateRoot',
	    autoLoad: false,
	    fields: ['StateID', 'StateName']
	});


/***** combo for customername*************/
	var statecombo = new Ext.form.ComboBox({
	    store: statestore,
	    id: 'custstate',
	    mode: 'local',
	    hidden: false,
	    forceSelection: true,
	    emptyText: '<%=selectState%>',
	    blankText: '<%=selectState%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'StateID',
	    displayField: 'StateName',
	    cls: 'selectstyle',
	    listeners: {
	        select: {
	            fn: function() {}
	        }
	    }
	});
/**************store for getting Countrty List******************/
	var countrystore = new Ext.data.JsonStore({
	    url: '<%=request.getContextPath()%>/CustomerAction.do?param=getCountryList',
	    id: 'CountryStoreId',
	    root: 'CountryRoot',
	    autoLoad: true,
	    fields: ['CountryID', 'CountryName']
	});	
//***** combo for customername
	var countrycombo = new Ext.form.ComboBox({
	    store: countrystore,
	    id: 'custcountry',
	    mode: 'local',
	    hidden: false,
	    forceSelection: true,
	    emptyText: '<%=SelectCountry%>',
	    blankText: '<%=SelectCountry%>',
	    selectOnFocus: true,
	    allowBlank: false,
	    anyMatch: true,
	    typeAhead: false,
	    triggerAction: 'all',
	    valueField: 'CountryID',
	    displayField: 'CountryName',
	    cls: 'selectstyle',
	    listeners: {
	        select: {
	            fn: function() {
	                Ext.getCmp('custstate').reset();
	                statestore.load({
	                    params: {
	                        countryId: Ext.getCmp('custcountry').getValue()
	                    }
	                });
	            }
	        }
	    }
	});
 
   //store for status
   var statuscombostore= new Ext.data.SimpleStore({
	  id:'statuscombostoreId',
	  autoLoad: true,
	  fields: ['Name','Value'],
	  data: [['Active', 'Active'], ['Inactive', 'Inactive']]
	});
			                                   
  //combo definition of  status field 
    var statuscombo = new Ext.form.ComboBox({
        store: statuscombostore,
        id:'statuscomboId',
        mode: 'local',
        forceSelection: true,
        emptyText:'<%=selectStatus%>',
        blankText:'<%=selectStatus%>',
        selectOnFocus:true,
        allowBlank: false,
        anyMatch:true,
        typeAhead: false,
        triggerAction: 'all',
        lazyRender: true,
    	valueField: 'Value',
    	value:'Active',
    	displayField: 'Name',
    	cls:'selectstyle'   
    });
 
 
 
 /*********************inner panel for displaying form field in window***********************/
  var innerPanel = new Ext.form.FormPanel({
		standardSubmit: true,
	    collapsible: false,    
	    autoScroll: true,    
	    height: 340,
	    width: '100%',
	    frame: true,
	    id: 'custMaster',
	    layout: 'table',
	    layoutConfig: {
	        columns: 3
	    },
	    items: [{
	        xtype: 'fieldset',
	        title: '<%=CustomerInformation%>',
	        cls: 'fieldsetpanel',
	        collapsible: false,
	        colspan: 3,
	        id: 'custpanelid',
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
	                id: 'mandatoryname'
	            }, {
	                xtype: 'label',
	                cls: 'labelstyle',
	                id: 'custnamelab',
	                text: '<%=Name%> :'
	            }, {
	                xtype: 'textfield',
	                cls: 'textrnumberstyle',
	                regex: validate('alphanumericname'),
	                emptyText: '<%=enterCustName%>',
	                allowBlank: false,
	                regexText: '<%=Validate_Mesg_For_Customer_Name%>',
	                blankText: '<%=enterCustName%>',
	                id: 'custname',
	                listeners: {
	                    change: function(field, newValue, oldValue) {
	                        field.setValue(newValue.toUpperCase().trim());
	                    }
	                },
	                maskRe: /[ a-zA-Z]/i,
	            }, {
	                xtype: 'label',
	                text: '*',
	                hidden: true,
	                cls: 'mandatoryfield',
	                id: 'mandatorynewname'
	            }, {
	                xtype: 'label',
	                cls: 'labelstyle',
	                id: 'custnewnamelab',
	                hidden: true,
	                text: '<%=Name%> :'
	            }, {
	                xtype: 'textfield',
	                cls: 'textrnumberstyle',
	                hidden: true,
	                regex: validate('alphanumericname'),
	                emptyText: '<%=enterCustName%>',
	                allowBlank: false,
	                regexText: '<%=Validate_Mesg_For_Customer_Name%>',
	                blankText: '<%=enterCustName%>',
	                id: 'custnewname',
	                listeners: {
	                    change: function(field, newValue, oldValue) {
	                        field.setValue(newValue.toUpperCase().trim());
	                    }
	                }
	            }, {
	                xtype: 'label',
	                text: '*',
	                cls: 'mandatoryfield',
	                id: 'mandatoryaddress'
	            }, {
	                xtype: 'label',
	                text: '<%=Address%>  :',
	                cls: 'labelstyle',
	                id: 'custmastaddlab'
	            }, {
	                xtype: 'textarea',
	                cls: 'textareastyle',
	                emptyText: '<%=enterAddr%>',
	                blankText: '<%=enterAddr%>',
	                allowBlank: false,
	                id: 'custaddress',
	                listeners: {
	                    change: function(field, newValue, oldValue) {
	                        field.setValue(newValue.toUpperCase());
	                    }
	                }
	            }, {
	                xtype: 'label',
	                text: '*',
	                cls: 'mandatoryfield',
	                id: 'mandatorycountry'
	            }, {
	                xtype: 'label',
	                text: '<%=Country%>   :',
	                cls: 'labelstyle',
	                id: 'custmastcountrylab'
	            },
	            countrycombo, {
	                xtype: 'label',
	                text: '*',
	                cls: 'mandatoryfield',
	                id: 'mandatorystate'
	            }, {
	                xtype: 'label',
	                text: '<%=State%>  :',
	                cls: 'labelstyle',
	                id: 'custmaststatelab'
	            },
	            statecombo, {
	                xtype: 'label',
	                text: '*',
	                cls: 'mandatoryfield',
	                id: 'mandatorycity'
	            }, {
	                xtype: 'label',
	                text: '<%=City%>' + '  :',
	                cls: 'labelstyle',
	                id: 'custmastcitylab'
	            }, {
	                xtype: 'textfield',
	                cls: 'textrnumberstyle',
	                regex: validate('city'),
	                emptyText: '<%=enterCityName%>',
	                blankText: '<%=enterCityName%>',
	                regexText: 'City Name should be in Albhates only',
	                allowBlank: false,
	                id: 'custcity',
	                listeners: {
	                    change: function(field, newValue, oldValue) {
	                        field.setValue(newValue.toUpperCase().trim());
	                    }
	                }
	            }, {
	                xtype: 'label',
	                text: '',
	                cls: 'mandatoryfield',
	                id: 'mandatoryzipcode'
	            }, {
	                xtype: 'label',
	                text: '<%=ZipCode%>  :',
	                cls: 'labelstyle',
	                id: 'custmastziplab'
	            }, {
	                xtype: 'numberfield',
	                allowDecimals: false,
	                cls: 'textrnumberstyle',
	                maxLength: 10,
	                emptyText: '<%=EnterZipCode%>',
	                blankText: '<%=EnterZipCode%>',
	                id: 'custzipcode'
	            }
	        ]
	    }, {
	        xtype: 'fieldset',
	        title: '<%=ContactDetails%>',
	        cls: 'fieldsetpanel',
	        collapsible: false,
	        colspan: 3,
	        id: 'custcontactdetails',
	        layout: 'table',
	        layoutConfig: {
	            columns: 3,
	            tableAttrs: {
	                style: {
	                    width: '85%'
	                }
	            }
	        },
	        items: [{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'mandatoryphoneno'
	        }, {
	            xtype: 'label',
	            text: '<%=phoneNo%>' + '  :',
	            cls: 'labelstyle',
	            id: 'custmastphonelab'
	        }, {
	            xtype: 'textfield',
	            allowDecimals: false,
	            cls: 'textrnumberstyle',
	            regex: validate('phone'),
	            emptyText: '<%=enterPhoneNo%>',
	            blankText: '<%=enterPhoneNo%>',
	            maxLength: 20,
	            id: 'custphoneno',
	             maskRe: /[0-9]/i
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'mandatorymobile'
	        }, {
	            xtype: 'label',
	            text: '<%=mobile%>' + '  :',
	            cls: 'labelstyle',
	            id: 'custmastmobilelab'
	        }, {
	            xtype: 'textfield',
	            allowDecimals: false,
	            cls: 'textrnumberstyle',
	            regex: validate('mobile'),
	            emptyText: '<%=enterMobileNo%>',
	            blankText: '<%=enterMobileNo%>',
	            maxLength: 20,
	            allowBlank: true,
	            id: 'custmobileno',
	             maskRe: /[0-9]/i
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'mandatoryfax'
	        }, {
	            xtype: 'label',
	            text: '<%=fax%> ' + '  :',
	            cls: 'labelstyle',
	            id: 'custmastfaxlab'
	        }, {
	            xtype: 'textfield',
	            allowDecimals: false,
	            cls: 'textrnumberstyle',
	            regex: validate('phone'),
	            emptyText: '<%=enterFaxNo%>',
	            maxLength: 20,
	            id: 'custfax'
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'mandatoryemail'
	        }, {
	            xtype: 'label',
	            text: '<%=EMailId%> ' + '  :',
	            cls: 'labelstyle',
	            id: 'custmastemaillab'
	        }, {
	            xtype: 'textfield',
	            cls: 'textrnumberstyle',
	            vtype: 'email',
	            emptyText: '<%=EnterEmailId%>',
	            id: 'custemailid'
	        }, {
	            xtype: 'label',
	            text: '',
	            cls: 'mandatoryfield',
	            id: 'mandatoryweb'
	        }, {
	            xtype: 'label',
	            text: '<%=Website%> ' + '  :',
	            cls: 'labelstyle',
	            id: 'custmastweblab'
	        }, {
	            xtype: 'textfield',
	            cls: 'textrnumberstyle',
	            vtype: 'url',
	            emptyText: '<%=EnterWebsite%>',
	            id: 'custwebsite'
	        }]
	    }, {
	        xtype: 'fieldset',
	        title: '<%=Payment_Notification_Alert%>',
	        cls: 'fieldsetpanel',
	        colspan: 3,
	        collapsible: false,
	        id: 'Payment_Alert',
	        layout: 'table',
	        layoutConfig: {
	            columns: 5
	        },
	        items: [{
	            html: '',
	            cls: 'mandatoryfield',
	            id: 'PAYMENTDUE_DATE' + 'htm'
	        }, {
	            width: 20
	        }, {
	            xtype: 'label',
	            cls: 'labellargestyle',
	            text: '<%=paymentduedate%>  :',
	            id: 'PAYMENTDUE_DATE' + 'label'
	        }, {
	            width: 5
	        }, {
	            xtype: 'datefield',
	            format: getDateFormat(),
	            value: dtcur,
	            vtype: 'daterange',
	            emptyText: '',
	            cls: 'selectstyle',
	            id: 'PAYMENTDUE_DATE' + 'field'
	        }, {
	            html: '',
	            cls: 'mandatoryfield',
	            id: 'PAYMENT_NOTIFICATIONPERIOD' + 'htm'
	        }, {
	            width: 20
	        }, {
	            xtype: 'label',
	            cls: 'labellargestyle',
	            text: '<%=paymentnotificationperiod%>  :',
	            id: 'PAYMENT_NOTIFICATIONPERIOD' + 'label'
	        }, {
	            width: 2
	        }, {
	            xtype: 'numberfield',
	            cls: 'textrnumberstyle',
	            emptyText: '',
	            blankText: '',
	            maxLength: 5,
	            allowBlank: true,
	            id: 'PAYMENT_NOTIFICATIONPERIOD' + 'field'
	        }]
	    }, {
	        xtype: 'fieldset',
	        title: '<%=AccountStatus%>',
	        cls: 'fieldsetpanel',
	        collapsible: false,
	        colspan: 3,
	        id: 'custaccountstatus',
	
	        layout: 'table',
	        layoutConfig: {
	            columns: 5
	        },
	        items: [{
	            xtype: 'label',
	            text: '*',
	            cls: 'mandatoryfield',
	            id: 'mandatorystatus'
	        }, {
	            width: 20
	        }, {
	            xtype: 'label',
	            text: '<%=status%> ' + ' :',
	            cls: 'labelstyle',
	            id: 'custmaststatuslab'
	        }, {
	            width: 65
	        }, statuscombo]
	    }, {
	        xtype: 'fieldset',
	        title: 'Vehicle Information',
	        cls: 'fieldsetpanel',
	        collapsible: false,
	        colspan: 3,
	        id: 'vehicleInfoId',
	        layout: 'table',
	        layoutConfig: {
	            columns: 5
	        },
	        items: [{
	            html: '',
	            cls: 'mandatoryfield',
	            id: 'speedLimitMandatoryLabelId' + 'htm'
	        }, {
	            width: 20
	        }, {
	            xtype: 'label',
	            text: 'Default Speed :',
	            cls: 'labelstyle',
	            id: 'speedLimitMandatoryLabel'
	        }, {
	            width: 65
	        }, {
	            xtype: 'numberfield',
	            cls: 'textrnumberstyle',
	            maxLength: 10,
	            emptyText: '<%=enterSpeed%>',
	            id: 'speedLimitId'
	        }]
	    }, {
	        xtype: 'fieldset',
	        title: 'Snooze Setting',
	        cls: 'fieldsetpanel',
	        collapsible: false,
	        colspan: 3,
	        id: 'mainPowerOnOffId',
	        layout: 'table',
	        layoutConfig: {
	            columns: 5
	        },
	        items: [{
	            html: '',
	            cls: 'mandatoryfield',
	            id: 'SnoozeMandatoryLabelId' + 'htm'
	        }, {
	            width: 20
	        }, {
	            xtype: 'label',
	            text: '<%=snoozeTime%>' + ' (Mins) :',
	            cls: 'labelstyle',
	            id: 'SnoozeMandatoryLabel'
	        }, {
	            width: 65
	        }, {
	            xtype: 'numberfield',
	            cls: 'textrnumberstyle',
	            maxLength: 10,
	            allowDecimals: false,
	            allowNegative: false,
	            emptyText: '<%=enterSnoozeTime%>',
	            id: 'snoozeId'
	        }]
	    }]
	});
/****************window static button panel****************************/	    		 
var winButtonPanel = new Ext.Panel({
    id: 'winbuttonid',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    cls: 'windowbuttonpanel',
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 2
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Save%>',
        id: 'addButtId',
        iconCls: 'savebutton',
        cls: 'buttonstyle',
        width: 80,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('custname').getValue() == "") {
                        Ext.example.msg("<%=enterCustName%>");
                        Ext.getCmp('custname').focus();
                        return;
                    }
                    if (buttonValue == "modify") {
                        if (Ext.getCmp('custnewname').getValue() == "") {
                            Ext.example.msg("<%=enterCustName%>");
                            Ext.getCmp('custnewname').focus();
                            return;
                        }
                    }
                    if (Ext.getCmp('custaddress').getValue() == "") {
                        Ext.example.msg("<%=enterAddr%>");
                        Ext.getCmp('custaddress').focus();
                        return;
                    }
                    if (Ext.getCmp('custcountry').getValue() == "") {
                        Ext.example.msg("<%=SelectCountry%>");
                        Ext.getCmp('custcountry').focus();
                        return;
                    }
                    if (Ext.getCmp('custstate').getValue() == "") {
                        Ext.example.msg("<%=selectState%>");
                        Ext.getCmp('custstate').focus();
                        return;
                    }
                    if (Ext.getCmp('custcity').getValue() == "") {
                        Ext.example.msg("<%=enterCityName%>");
                        Ext.getCmp('custcity').focus();
                        return;
                    }
                    if (Ext.getCmp('custphoneno').getValue() == "") {
                        Ext.example.msg("<%=enterPhoneNo%>");
                        Ext.getCmp('custphoneno').focus();
                        return;
                    }

                    if (Ext.getCmp('statuscomboId').getValue() == "") {
                        Ext.example.msg("<%=selectStatus%>");
                        Ext.getCmp('statuscomboId').focus();
                        return;
                    }

                    var selected = grid.getSelectionModel().getSelected();
                    var custId;
                    var CustName;
                    if (selected == undefined || selected == "undefined") {
                        custId = "0";
                    }
                    if (buttonValue == "add") {
                        custId = "0";
                        CustName = Ext.getCmp('custname').getValue();
                        Ext.getCmp('custnewname').setValue(Ext.getCmp('custname').getValue());
                    } else if (buttonValue == "modify") {
                        custId = selected.get('customeridIndex');
                        CustName = Ext.getCmp('custname').getValue();
                        Ext.getCmp('custname').setValue(Ext.getCmp('custnewname').getValue());
                    }
                    if (innerPanel.getForm().isValid()) {
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/CustomerAction.do?param=saveCustomerDetails',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                custId: custId,
                                custName: CustName,
                                custNewName: Ext.getCmp('custnewname').getValue(),
                                custAddress: Ext.getCmp('custaddress').getValue(),
                                custCity: Ext.getCmp('custcity').getValue(),
                                custState: Ext.getCmp('custstate').getValue(),
                                custCountry: Ext.getCmp('custcountry').getValue(),
                                custZipcode: Ext.getCmp('custzipcode').getValue(),
                                custPhone: Ext.getCmp('custphoneno').getValue(),
                                custMobile: Ext.getCmp('custmobileno').getValue(),
                                custFax: Ext.getCmp('custfax').getValue(),
                                custEmail: Ext.getCmp('custemailid').getValue(),
                                custWebsite: Ext.getCmp('custwebsite').getValue(),
                                custStatus: Ext.getCmp('statuscomboId').getValue(),
                                custPaymentduedate: Ext.getCmp('PAYMENTDUE_DATEfield').getValue(),
                                custPaymentNotification: Ext.getCmp('PAYMENT_NOTIFICATIONPERIODfield').getValue(),
                                speedLimit: Ext.getCmp('speedLimitId').getValue(),
                                snoozeTime : Ext.getCmp('snoozeId').getValue(),
                                pageName: pageName
                            },
                            success: function(response, options) //start of success
                                {
                                    var str = response.responseText;
                                    var array = str.split(",");
                                    var a = array[0];
                                    var b = array[1];
                                    store.load({
                                        callback: function() {
                                            var ind = grid.store.findExact('customeridIndex', b);
                                            grid.getSelectionModel().selectRow(ind);
                                            var selected = grid.getSelectionModel().getSelected().get('customeridIndex');
                                            if (selected != 'undefined') {
                                                if (grid.getSelectionModel().getSelected().get('statusIndex') == 'Inactive' || grid.getSelectionModel().getSelected().get('activationstatusIndex') == 'Incomplete') {
                                                    parent.globalCustomerID = 0;
                                                } else {
                                                    parent.globalCustomerID = selected;
                                                }
                                            }
                                        }
                                    });
                                    Ext.example.msg(a);
                                    Ext.getCmp('custname').reset();
                                    Ext.getCmp('custnewname').reset();
                                    Ext.getCmp('custaddress').reset();
                                    Ext.getCmp('custcity').reset();
                                    Ext.getCmp('custstate').reset();
                                    Ext.getCmp('custcountry').reset();
                                    Ext.getCmp('custzipcode').reset();
                                    Ext.getCmp('custphoneno').reset();
                                    Ext.getCmp('custmobileno').reset();
                                    Ext.getCmp('custfax').reset();
                                    Ext.getCmp('custemailid').reset();
                                    Ext.getCmp('custwebsite').reset();
                                    Ext.getCmp('statuscomboId').setValue('Active');
                                    Ext.getCmp('PAYMENT_NOTIFICATIONPERIODfield').reset();
                                    Ext.getCmp('PAYMENTDUE_DATEfield').reset();
                                    Ext.getCmp('speedLimitId').reset();
                                    Ext.getCmp('snoozeId').reset();
                                    enableTabElements();
                                    myWin.hide();

                                }, // END OF  SUCCESS
                            failure: function() //start of failure 
                                {
                                    Ext.example.msg("error");
                                    Ext.getCmp('custname').reset();
                                    Ext.getCmp('custnewname').reset();
                                    Ext.getCmp('custaddress').reset();
                                    Ext.getCmp('custcity').reset();
                                    Ext.getCmp('custstate').reset();
                                    Ext.getCmp('custcountry').reset();
                                    Ext.getCmp('custzipcode').reset();
                                    Ext.getCmp('custphoneno').reset();
                                    Ext.getCmp('custmobileno').reset();
                                    Ext.getCmp('custfax').reset();
                                    Ext.getCmp('custemailid').reset();
                                    Ext.getCmp('custwebsite').reset();
                                    Ext.getCmp('statuscomboId').setValue('Active');
                                    Ext.getCmp('PAYMENT_NOTIFICATIONPERIODfield').reset();
                                    Ext.getCmp('PAYMENTDUE_DATEfield').reset();
                                    Ext.getCmp('speedLimitId').reset();
                                    Ext.getCmp('snoozeId').reset();
                                    enableTabElements();
                                    myWin.hide();
                                } // END OF FAILURE 
                        }); // END OF AJAX		
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
        width: '80',
        listeners: {
            click: {
                fn: function() {
                    enableTabElements();
                    myWin.hide();
                }
            }
        }
    }]
});
/***********panel contains window content info***************************/
var outerPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    standardSubmit: true,
    frame: false,
    items: [innerPanel, winButtonPanel]
});
/***********************window for form field****************************/
myWin = new Ext.Window({
    title: titel,
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: 'mywindow',
    id: 'myWin',
    items: [outerPanelWindow]
});
/*function for add button in grid that will open form window*/
 function addRecord() {
    buttonValue = "add";
    titel = '<%=AddCustomer%>';
    disableTabElements();
    myWin.show();
    myWin.setTitle(titel);
    myWin.setPosition(380, 40);
    Ext.getCmp('mandatoryname').show();
    Ext.getCmp('custnamelab').show();
    Ext.getCmp('custname').show();
    Ext.getCmp('custname').reset();
    Ext.getCmp('custnewname').reset();
    Ext.getCmp('custaddress').reset();
    Ext.getCmp('custcity').reset();
    Ext.getCmp('custstate').reset();
    Ext.getCmp('custcountry').reset();
    Ext.getCmp('custzipcode').reset();
    Ext.getCmp('custphoneno').reset();
    Ext.getCmp('custmobileno').reset();
    Ext.getCmp('custfax').reset();
    Ext.getCmp('custemailid').reset();
    Ext.getCmp('custwebsite').reset();
    Ext.getCmp('statuscomboId').setValue('Active');
    Ext.getCmp('PAYMENT_NOTIFICATIONPERIODfield').reset();
    Ext.getCmp('PAYMENTDUE_DATEfield').reset();
    Ext.getCmp('speedLimitId').reset();
    Ext.getCmp('snoozeId').reset();
    Ext.getCmp('mandatorynewname').hide();
    Ext.getCmp('custnewnamelab').hide();
    Ext.getCmp('custnewname').hide();

}
/***********button panel for next button*******************/
 var buttonPanel = new Ext.FormPanel({
     id: 'buttonid',
     cls: 'colorid',
     frame: true,
     buttons: [{
         text: '<%=Next%>',
         cls: 'colorid',
         iconCls: 'nextbutton',
         handler: function() {
             if (grid.getSelectionModel().getSelected().get('statusIndex') == 'Inactive') {
                 Ext.example.msg("<%=Validate_Mesg_For_Inactive_Cust%>");
                 Ext.getCmp('statuscomboId').focus();
                 return;
             }
             if (grid.getSelectionModel().getCount() == 0) {
                 Ext.example.msg("<%=selectSingleRow%>");
                 return;
             }
             if (grid.getSelectionModel().getCount() > 1) {
                 Ext.example.msg("<%=selectSingleRow%>");
                 return;
             }
             var selected = grid.getSelectionModel().getSelected();
             var customerID = selected.get('customeridIndex');
             var customerFeatureAssociation = '<%=request.getContextPath()%>/Jsps/Admin/ProductFeature.jsp?feature=<%=feature%>&CustId=' + customerID;
             parent.Ext.getCmp('productFeaturetab').enable();
             parent.Ext.getCmp('productFeaturetab').show();
             parent.Ext.getCmp('productFeaturetab').update("<iframe style='width:100%;height:525px;border:0;' src='" + customerFeatureAssociation + "'></iframe>");

         }
     }]
 });  
/******************grid config starts********************************************************/
/**********************reader configs************************/
	var reader = new Ext.data.JsonReader({
	    idProperty: 'customerdetailid',
	    root: 'CustomerDetailsRoot',
	    totalProperty: 'total',
	    fields: [{
	        name: 'slnoIndex'
	    }, {
	        name: 'customeridIndex'
	    }, {
	        name: 'nameIndex'
	    }, {
	        name: 'addressIndex'
	    }, {
	        name: 'cityIndex'
	    }, {
	        name: 'stateIndex'
	    }, {
	        name: 'countryIndex'
	    }, {
	        name: 'zipcodeIndex'
	    }, {
	        name: 'phonenoIndex'
	    }, {
	        name: 'mobilenoIndex'
	    }, {
	        name: 'faxIndex'
	    }, {
	        name: 'emailidIndex'
	    }, {
	        name: 'websiteIndex'
	    }, {
	        name: 'paymentduedateIndex',
	        type: 'date',
	        dateFormat: getDateFormat()
	    }, {
	        name: 'paymentnotificationIndex'
	    }, {
	        name: 'statusIndex'
	    }, {
	        name: 'countryidIndex'
	    }, {
	        name: 'stateidIndex'
	    }, {
	        name: 'activationstatusIndex'
	    }, {
	        name: 'speedLimitIndex'
	    }, {
	        name: 'snoozeTimeIndex'
	    }, {
	    	name: 'paymentDueIndex'
	    }]
	});

	//************************* store configs**************/

		store= new Ext.data.GroupingStore({
	    autoLoad: true,
	    proxy: new Ext.data.HttpProxy({
	        url: '<%=request.getContextPath()%>/CustomerAction.do?param=getCustomerDetails',
	        method: 'POST'
	    }),
	    remoteSort: false,
	    sortInfo: {
	        field: 'nameIndex',
	        direction: 'ASC'
	    },
	    storeId: 'custStore',
	    reader: reader
	});
	
	/**********************filter config**************/
	var filters = new Ext.ux.grid.GridFilters({
	    local: true,
	    filters: [{
	        type: 'numeric',
	        dataIndex: 'slnoIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'customeridIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'nameIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'addressIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'cityIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'stateIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'countryIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'zipcodeIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'phonenoIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'mobilenoIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'faxIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'emailidIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'websiteIndex'
	    }, {
	        dataIndex: 'paymentduedateIndex',
	        type: 'date'
	    }, {
	        type: 'string',
	        dataIndex: 'paymentnotificationIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'statusIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'countryidIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'stateidIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'activationstatusIndex'
	    }, {
	        type: 'string',
	        dataIndex: 'speedLimitIndex'
	    }, {
	    	type : 'numeric',
	    	dataIndex : 'snoozeTimeIndex'
	    }, {
	    	type : 'string',
	    	dataIndex : 'paymentDueIndex'
	    }]
	});

	/**************column model config**************/
	var createColModel = function(finish, start) {

	    var columns = [
	        new Ext.grid.RowNumberer({
	            header: "<span style=font-weight:bold;><%=SLNO%></span>",
	            width: 40
	        }), {
	            dataIndex: 'slnoIndex',
	            hidden: true,
	            header: "<span style=font-weight:bold;><%=SLNO%></span>",
	            filter: {
	                type: 'numeric'
	            }
	        }, {
	            dataIndex: 'customeridIndex',
	            hidden: true,
	            header: "<span style=font-weight:bold;><%=CUSTOMERID%></span>",
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=Name%></span>",
	            dataIndex: 'nameIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=Address%></span>",
	            dataIndex: 'addressIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=City%></span>",
	            dataIndex: 'cityIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=State%></span>",
	            dataIndex: 'stateIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=Country%></span>",
	            dataIndex: 'countryIndex',
	            hidden: true,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=ZipCode%></span>",
	            dataIndex: 'zipcodeIndex',
	            hidden: true,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=phoneNo%></span>",
	            dataIndex: 'phonenoIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=mobile%></span>",
	            hidden: true,
	            dataIndex: 'mobilenoIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=fax%></span>",
	            dataIndex: 'faxIndex',
	            hidden: true,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=EMailId%></span>",
	            hidden: true,
	            dataIndex: 'emailidIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=Website%></span>",
	            hidden: true,
	            dataIndex: 'websiteIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=paymentduedate%></span>",
	            dataIndex: 'paymentduedateIndex',
	            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
	            filter: {
	                type: 'date'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=paymentnotificationperiod%></span>",
	            filter: {
	                type: 'string'
	            },
	            dataIndex: 'paymentnotificationIndex'
	        }, {
	            header: "<span style=font-weight:bold;><%=status%></span>",
	            dataIndex: 'statusIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;>CountryIdIndex</span>",
	            hidden: true,
	            dataIndex: 'countryidIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;>StateIdIndex</span>",
	            hidden: true,
	            dataIndex: 'stateidIndex',
	            width: 20,
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;><%=RegistrationStatus%></span>",
	            hidden: false,
	            dataIndex: 'activationstatusIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	            header: "<span style=font-weight:bold;>Default Speed </span>",
	            hidden: false,
	            dataIndex: 'speedLimitIndex',
	            filter: {
	                type: 'string'
	            }
	        }, {
	        	header : "<span style=font-weight:bold;><%=snoozeTime%></span>",
	        	hidden : true,
	        	dataIndex : 'snoozeTimeIndex',
	        	filter : {
	        		type : 'numeric'
	        	}
	        }, {
	        	header : "<span style=font-weight:bold;>Payment Due</span>",
	        	dataIndex : 'paymentDueIndex'
	        }
	    ];

	    return new Ext.grid.ColumnModel({
	        columns: columns.slice(start || 0, finish),
	        defaults: {
	            sortable: true
	        }
	    });
};
<%
if(customeridlogged > 0 )
{%>
    
grid = getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 60, 430, 23, filters, 'Clear Filter Data', false, '', 21, false, '', false, '', false, '', jspName, exportDataType, false, '', false, 'Add', true, 'Modify', false, 'Delete', true, 'Login Block/Unblock');
grid.on({
    "cellclick": {
        fn: onCellClickOnGrid
    }
});
<%}else {%>
grid = getGridManager('', '<%=NoRecordsFound%>', store, screen.width - 60, 430, 23, filters, 'Clear Filter Data', false, '', 21, false, '', false, '', false, '', jspName, exportDataType, false, '', true, 'Add', true, 'Modify', true, 'Delete', true, 'Login Block/Unblock');
grid.on({
    "cellclick": {
        fn: onCellClickOnGrid
    }
});

<%}%>

function onCellClickOnGrid(grid, rowIndex, columnIndex, e) {
    var selected = grid.getSelectionModel().getSelected().get('customeridIndex');
    if (grid.getSelectionModel().getSelected().get('statusIndex') == 'Inactive' || grid.getSelectionModel().getSelected().get('activationstatusIndex') == 'Incomplete') {
        parent.globalCustomerID = 0;
    } else {
        parent.globalCustomerID = selected;
    }
}     
  //modify the dat
function modifyData() {
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }
  
    buttonValue = "modify";
    titel = "<%=ModifyCustomerInformation%>"
    myWin.setTitle(titel);
    disableTabElements();
  
    Ext.getCmp('mandatoryname').hide();
    Ext.getCmp('custnamelab').hide();
    Ext.getCmp('custname').hide();
    Ext.getCmp('mandatorynewname').show();
    Ext.getCmp('custnewnamelab').show();
    Ext.getCmp('custnewname').show();
    Ext.getCmp('custname').setValue("");
    Ext.getCmp('custaddress').setValue("");
    Ext.getCmp('custcity').setValue("");
    Ext.getCmp('custcountry').setValue("");
    Ext.getCmp('custstate').setValue("");
    Ext.getCmp('custzipcode').setValue("");
    Ext.getCmp('custphoneno').setValue("");
    Ext.getCmp('custmobileno').setValue("");
    Ext.getCmp('custfax').setValue("");
    Ext.getCmp('custemailid').setValue("");
    Ext.getCmp('custwebsite').setValue("");
    Ext.getCmp('statuscomboId').setValue("");
    Ext.getCmp('PAYMENT_NOTIFICATIONPERIODfield').setValue("");
    Ext.getCmp('PAYMENTDUE_DATEfield').setValue("");
	Ext.getCmp('speedLimitId').setValue("");
	Ext.getCmp('snoozeId').setValue("");
    myWin.show();
    var selected = grid.getSelectionModel().getSelected();
  
    statestore.load({
        params: {
            countryId: selected.get('countryidIndex')
        },
        callback: function() {
            Ext.getCmp('custname').setValue(selected.get('nameIndex'));
            Ext.getCmp('custnewname').setValue(selected.get('nameIndex'));
            Ext.getCmp('custaddress').setValue(selected.get('addressIndex'));
            Ext.getCmp('custcity').setValue(selected.get('cityIndex'));
            Ext.getCmp('custcountry').setValue(selected.get('countryidIndex'));
            Ext.getCmp('custstate').setValue(selected.get('stateidIndex'));
            Ext.getCmp('custzipcode').setValue(selected.get('zipcodeIndex'));
            Ext.getCmp('custphoneno').setValue(selected.get('phonenoIndex'));
            Ext.getCmp('custmobileno').setValue(selected.get('mobilenoIndex'));
            Ext.getCmp('custfax').setValue(selected.get('faxIndex'));
            Ext.getCmp('custemailid').setValue(selected.get('emailidIndex'));
            Ext.getCmp('custwebsite').setValue(selected.get('websiteIndex'));
            Ext.getCmp('statuscomboId').setValue(selected.get('statusIndex'));
            Ext.getCmp('PAYMENT_NOTIFICATIONPERIODfield').setValue(selected.get('paymentnotificationIndex'));
            Ext.getCmp('PAYMENTDUE_DATEfield').setValue(selected.get('paymentduedateIndex'));
            Ext.getCmp('speedLimitId').setValue(selected.get('speedLimitIndex'));
            Ext.getCmp('snoozeId').setValue(selected.get('snoozeTimeIndex'));
        }
    });


}
 //deleting record
 function deleteData() {
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }
    Ext.getCmp('custname').setValue("");
    Ext.getCmp('custaddress').setValue("");
    Ext.getCmp('custcity').setValue("");
    Ext.getCmp('custstate').setValue("");
    Ext.getCmp('custcountry').setValue("");
    Ext.getCmp('custzipcode').setValue("");
    Ext.getCmp('custphoneno').setValue("");
    Ext.getCmp('custmobileno').setValue("");
    Ext.getCmp('custfax').setValue("");
    Ext.getCmp('custemailid').setValue("");
    Ext.getCmp('custwebsite').setValue("");
    Ext.getCmp('statuscomboId').setValue("");
    Ext.getCmp('PAYMENT_NOTIFICATIONPERIODfield').setValue("");
    Ext.getCmp('PAYMENTDUE_DATEfield').setValue("");
    Ext.getCmp('speedLimitId').setValue("");
    Ext.getCmp('snoozeId').setValue("");
    var selected = grid.getSelectionModel().getSelected();

    Ext.Msg.show({
        title: '<%=delete%>',
        msg: '<%=wantToDelete%>',
        buttons: {
            yes: true,
            no: true
        },
        fn: function(btn) {
            switch (btn) {
                case 'yes':
                    var custId = selected.get('customeridIndex');
                    var CustName = selected.get('nameIndex');
                    //showing message
                    ctsb.showBusy('<%=deleting%>');
                    outerPanel.getEl().mask();
                    //Ajax request
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CustomerAction.do?param=deleteCustomerDetails',
                        method: 'POST',
                        params: {
                            custId: custId,
                            custName: CustName,
                            pageName: pageName
                        },
                        success: function(response, options) //start of success
                            {
                                Ext.example.msg(response.responseText);
                                store.reload();
                                outerPanel.getEl().unmask();

                            }, // END OF  SUCCESS
                        failure: function() //start of failure 
                            {
                                Ext.example.msg("error");
                                store.reload();
                                outerPanel.getEl().unmask();

                            } // END OF FAILURE 
                    }); // END OF AJAX
                    break;
                case 'no':
                    Ext.example.msg("<%=custNotDeleted%>");
                    store.reload();
                    break;
            }
        }
    });
}
//************For Login Block/UnBlock *************************************
function closetripsummary(){
    if (grid.getSelectionModel().getCount() == 0) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=selectSingleRow%>");
        return;
    }
    var selected = grid.getSelectionModel().getSelected();
    var loginStatus;
    if(selected.get('paymentDueIndex')=='Y'){
    loginStatus="Unblock";
    }else{ loginStatus="Block"; }
    Ext.Msg.show({
        title: 'Payment Due',
        msg: 'Do you want to '+loginStatus+' the login for Customer ?',
        buttons: {
            yes: true,
            no: true
        },
        fn: function(btn) {
            switch (btn) {
                case 'yes':
                    var custId = selected.get('customeridIndex');
                    ctsb.showBusy('<%=deleting%>');
                    outerPanel.getEl().mask();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/CustomerAction.do?param=block_UnblockCustomer',
                        method: 'POST',
                        params: {
                            custId: custId,
                            paymentDue: selected.get('paymentDueIndex'),
                            pageName: pageName
                        },
                        success: function(response, options) //start of success
                            {
                                Ext.example.msg(response.responseText);
                                store.reload();
                                outerPanel.getEl().unmask();
                            }, // END OF  SUCCESS
                        failure: function() //start of failure 
                            {
                                Ext.example.msg("error");
                                store.reload();
                                outerPanel.getEl().unmask();
                            } // END OF FAILURE 
                    }); // END OF AJAX
                    break;
                case 'no':   break;
            }
        }
    });

}
	  
//*****main starts from here*************************
 Ext.onReady(function(){
	ctsb=tsb;
	Ext.QuickTips.init();
	Ext.form.Field.prototype.msgTarget = 'side';			         	   			
 	outerPanel = new Ext.Panel({
		title:'',
		renderTo : 'content',
		standardSubmit: true,
		autoScroll:false,
		frame:true,
		border:false,
		width:screen.width-38,
		height:500,
		cls:'outerpanel',
		items: [grid, buttonPanel]
	}); 

/******************************************************* Following code when rendering the grid********************************************************/
	grid.getView().on({
	    viewready: {
	        fn: function() {
	            grid.getSelectionModel().selectRow(0);
	            var selected = "";
	            if (grid.getSelectionModel().getCount() > 0) {
	                selected = grid.getSelectionModel().getSelected().get('customeridIndex');
	                if (grid.getSelectionModel().getSelected().get('statusIndex') == 'Inactive' || grid.getSelectionModel().getSelected().get('activationstatusIndex') == 'Incomplete') {
	                    parent.globalCustomerID = 0;
	                } else {
	                    parent.globalCustomerID = selected;
	                }
	            }
	        }
	    }
	
	}); 
});
<% } %>
  </script>
  </body>
</html>
