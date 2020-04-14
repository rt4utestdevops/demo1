<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="ISO-8859-1"%>
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
    tobeConverted.add("Route_Student_Details");
    tobeConverted.add("Select_School");
    tobeConverted.add("Select_Standard");
    tobeConverted.add("Select_PickUp_Type");
    tobeConverted.add("Select_Drop_Type");
    tobeConverted.add("Select_Country_Code");
    tobeConverted.add("Route_Student_Information");
    tobeConverted.add("Student_Name");
    tobeConverted.add("Enter_Student_Name");
    tobeConverted.add("Standard");
    tobeConverted.add("Enter_Standard");
    tobeConverted.add("Section");
    tobeConverted.add("Enter_Section");
    tobeConverted.add("Parent_Name");
    tobeConverted.add("Enter_Parent_Name"); 
    tobeConverted.add("Parent_Mobile");
    tobeConverted.add("Enter_Parent_Mobile_Number"); 
    tobeConverted.add("Country_Code"); 
    tobeConverted.add("Email_ID");
    tobeConverted.add("Enter_Email_Id"); 
    tobeConverted.add("Latitude"); 
    tobeConverted.add("Enter_Latitude"); 
    tobeConverted.add("Longitude"); 
    tobeConverted.add("Enter_Longitude");  
    tobeConverted.add("Radius");  
    tobeConverted.add("Enter_Radius");  
    tobeConverted.add("PickUp_Route_No");  
    tobeConverted.add("Drop_Route_No");  
    tobeConverted.add("Save");
    tobeConverted.add("Cancel");
    tobeConverted.add("Add");
    tobeConverted.add("Select_Single_Row");
    tobeConverted.add("No_Rows_Selected");
    tobeConverted.add("Modify");
    tobeConverted.add("Delete_Route_Details");
    tobeConverted.add("Are_you_sure_you_want_to_delete");
    tobeConverted.add("SLNO");  
    tobeConverted.add("No_Records_Found");
    tobeConverted.add("PDF");
    tobeConverted.add("Delete");
    tobeConverted.add("Manage_Students");
 ArrayList<String> convertedWords = new ArrayList<String>();
 convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
     String RouteStudentDetails=convertedWords.get(0);
     String SelectSchool=convertedWords.get(1);
     String SelectStandard=convertedWords.get(2);
     String SelectPickUpType=convertedWords.get(3);
     String SelectDropType=convertedWords.get(4);
     String SelectCountryCode=convertedWords.get(5);
     String RouteStudentInformation =convertedWords.get(6);
     String StudentName=convertedWords.get(7);
     String EnterStudentName=convertedWords.get(8);
     String Standard=convertedWords.get(9);
     String EnterStandard=convertedWords.get(10);
     String Section=convertedWords.get(11);
     String EnterSection=convertedWords.get(12);
     String ParentName=convertedWords.get(13);
     String EnterParentName=convertedWords.get(14);
     String ParentMobile=convertedWords.get(15);
     String EnterParentMobileNumber=convertedWords.get(16);
     String CountryCode=convertedWords.get(17);
     String EmailId=convertedWords.get(18);
     String EnterEmailId=convertedWords.get(19);
     String Latitude=convertedWords.get(20);
     String EnterLatitude=convertedWords.get(21);
     String Longitude=convertedWords.get(22);
     String EnterLongitude=convertedWords.get(23);
     String Radius=convertedWords.get(24);
     String EnterRadius=convertedWords.get(25);
     String PickUpRouteNo=convertedWords.get(26);
     String DropRouteNo=convertedWords.get(27);
     String Save=convertedWords.get(28);
     String Cancel=convertedWords.get(29);
     String Add=convertedWords.get(30);
     String SelectSingleRow=convertedWords.get(31);
     String NoRowsSelected=convertedWords.get(32);
     String Modify=convertedWords.get(33);
     String DeleteRouteDetails=convertedWords.get(34);
     String Areyousureyouwanttodelete=convertedWords.get(35);
     String SLNO=convertedWords.get(36);
     String NoRecordsFound=convertedWords.get(37);
     String PDF=convertedWords.get(38);
     String Delete=convertedWords.get(39);
     String ManageStudents=convertedWords.get(40);
     String SelectBranch="Select Branch";
     String BranchName="Branch Name";
%>

<jsp:include page="../Common/header.jsp" />
		<base href="<%=basePath%>">

		<title><%=ManageStudents%></title>
		<style>
.x-panel-tl {
	border-bottom: 0px solid !important;
}
</style>
	
	<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>                  
    <jsp:include page="../Common/ImportJSSandMining.jsp"/>                                               
   <%}else {%>  
   <jsp:include page="../Common/ImportJS.jsp" /><%} %>
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
			label {
				display : inline !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height: 36px !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			#addpanelid {
				width : 358px !important;
			}
			.footer {
				bottom : -2px !important;
			}
		</style>
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
var jspName = "ManageStudents";
var exportDataType = "int,String,String,String,String,String,int,String,float,float,String,String,String,String";
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
                custName=Ext.getCmp('custcomboId').getRawValue();
                branchStore.load({
                           params: {
                              CustId: custId
                           }
                     });
                 Ext.getCmp('branchcomboId').reset(); 
                countrystore.load({
                           params: {
                               CustId: custId
                           }
               });
                pickUpStore.load({
                           params: {
                               CustId: custId
                           }
               });
               dropTypestore.load({
                           params: {
                               CustId: custId
                           }
               });
               standardstore.load({
                           params: {
                            CustId: custId
                           }
                     });
             branchPopUpStore.load({
                           params: {
                               CustId: custId
                           }
                     });  
                             
                   if ( <%= customerId %> > 0) {
                       Ext.getCmp('custcomboId').setValue('<%= customerId %>');
                      custId = Ext.getCmp('custcomboId').getValue();
                      custName=Ext.getCmp('custcomboId').getRawValue();
                     branchStore.load({
                           params: {
                               CustId: custId
                           }
                     });
                countrystore.load({
                           params: {
                               countryId:countryId
                           }
               });
                pickUpStore.load({
                           params: {
                               CustId: custId
                           }
               });
               dropTypestore.load({
                           params: {
                               CustId:custId
                           }
               });
               standardstore.load({
                           params: {
                               CustId: custId
                           }
                     });
               branchPopUpStore.load({
                           params: {
                               CustId: custId
                           }
                     });      
                   }
               }
           }
       }
   });
/**************************************Branch List for POPUP***********************************/
var branchPopUpStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SchoolRouteStudentDetailsAction.do?param=getBranchListForPopUp',
    id: 'branchPopUpStoreId',
    root: 'branchPopUpRoot',
    autoLoad: false,
    fields: ['Branch_Id', 'Branch_Name']
});

/**************************************combo Branch List POPUP***********************************/
var branchPopUpcombo = new Ext.form.ComboBox({
    store: branchPopUpStore,
    id: 'branchPopUpcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    blankText: '<%=SelectBranch%>',
    emptyText: '<%=SelectBranch%>',
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'Branch_Id',
    displayField: 'Branch_Name',
    cls: 'selectstyle',
    listeners: {
        select: {
            fn: function () {
               
            }
        }
    }
});      
   
/**************************************Branch List***********************************/
var branchStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/SchoolRouteStudentDetailsAction.do?param=getBranchList',
    id: 'branchStoreId',
    root: 'branchRoot',
    autoLoad: false,
    fields: ['BRANCH_ID', 'BRANCH_NAME']
});

/**************************************combo Branch List***********************************/
var branchcombo = new Ext.form.ComboBox({
    store: branchStore,
    id: 'branchcomboId',
    mode: 'local',
    hidden: false,
    forceSelection: true,
    blankText: '<%=SelectBranch%>',
    emptyText: '<%=SelectBranch%>',
    allowBlank: false,
    anyMatch: true,
    typeAhead: false,
    triggerAction: 'all',
    valueField: 'BRANCH_ID',
    displayField: 'BRANCH_NAME',
    cls: 'selectstylePerfect',
    listeners: {
        select: {
            fn: function () {
                custId = Ext.getCmp('custcomboId').getValue();
                custName=Ext.getCmp('custcomboId').getRawValue();
                //alert(Ext.getCmp('branchcomboId').getValue());
                 store.load({
                       params: {
                           CustId: custId,
                           CustName: custName,
                           jspName:jspName,
                           branchId:Ext.getCmp('branchcomboId').getValue()
                       }
                     });    
            }
        }
    }
});   
   
/**********************************************StandardStore****************************************/
var standardstore = new Ext.data.JsonStore({			
url: '<%=request.getContextPath()%>/SchoolRouteStudentDetailsAction.do?param=getStandardList',
       id: 'StandardStoreId',
       root: 'standardRoot',
       autoLoad: true,
       fields: ['STANDARD']	
 });
/*********************************StandardCombo********************************************/
 var Standardcombo = new Ext.form.ComboBox({
       store: standardstore,
       id: 'standardcomboId',
       mode: 'local',
       hidden: false,
       forceSelection: true,
       emptyText: '<%=SelectStandard%>',
       blankText: '<%=SelectStandard%>',
       selectOnFocus: true,
       anyMatch: true,
	   allowBlank: false,
       typeAhead: false,
       triggerAction: 'all',
       valueField: 'STANDARD',
       displayField: 'STANDARD',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
					 	
               }
           }
       }
   }); 
/**********************************************TypeStore****************************************/
var pickUpStore = new Ext.data.JsonStore({			
url: '<%=request.getContextPath()%>/SchoolRouteStudentDetailsAction.do?param=getPickupcodeList',
       id: 'PickUpStoreId',
       root: 'PickUpRoot',
       autoLoad: true,
       fields: ['ROUTE_NO']	
 });
/*********************************TypeCombo********************************************/
var Typecombo = new Ext.form.ComboBox({
       store: pickUpStore,
       id: 'typecomboId',
       mode: 'local',
       hidden: false,
       forceSelection: true,
       emptyText: '<%=SelectPickUpType%>',
       blankText: '<%=SelectPickUpType%>',
       selectOnFocus: true,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       valueField: 'ROUTE_NO',
       displayField: 'ROUTE_NO',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
					 	
               }
           }
       }
   }); 
/**********************************************TypeStore****************************************/
var dropTypestore = new Ext.data.JsonStore({			
url: '<%=request.getContextPath()%>/SchoolRouteStudentDetailsAction.do?param=getDropcodeList',
       id: 'dropCodeStoreId',
       root: 'DropRoot',
       autoLoad: true,
       fields: ['ROUTE_NO']	
 });
/*********************************TypeCombo********************************************/
 var DropTypecombo = new Ext.form.ComboBox({
       store: dropTypestore,
       id: 'dropcomboId',
       mode: 'local',
       hidden: false,
       forceSelection: true,
       emptyText: '<%=SelectDropType%>',
       blankText: '<%=SelectDropType%>',
       selectOnFocus: true,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       valueField: 'ROUTE_NO',
       displayField: 'ROUTE_NO',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
					 	
               }
           }
       }
   }); 
/**************store for getting Country List******************************************/
var countrystore = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/SchoolRouteStudentDetailsAction.do?param=getCountryList',
       id: 'CountryStoreId',
       root: 'CountryRoot',
       autoLoad: true,
       fields: ['ISD_CODE', 'CountryName']
   });
   
    //***** combo for customername*********************************//
   var countrycombo = new Ext.form.ComboBox({
       store: countrystore,
       id: 'countryId',
       mode: 'local',
       hidden: false,
       forceSelection: true,
       emptyText: '<%=SelectCountryCode%>',
       blankText: '<%=SelectCountryCode%>',
       selectOnFocus: true,
       allowBlank: false,
       anyMatch: true,
       typeAhead: false,
       triggerAction: 'all',
       valueField: 'ISD_CODE',
       displayField: 'CountryName',
       cls: 'selectstylePerfect',
       listeners: {
           select: {
               fn: function () {
					 	
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
        columns: 7
    },
    items: [{
            xtype: 'label',
            text: '<%=SelectSchool%>' + ' :',
            cls: 'labelstyle'
        },
        custnamecombo,{
        width:10
        },{
            xtype: 'label',
            text: '<%=SelectBranch%>' + ' :',
            cls: 'labelstyle'
        },
        branchcombo
    ]
});


/*********************inner panel for displaying form field in window***********************/
var innerPanelForUnitDetails = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 400,
    width: 381,
    frame: true,
    id: 'custMaster',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=RouteStudentInformation%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 2,
        id: 'addpanelid',
        width: 350,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryRouteid'
            },{
                xtype: 'label',
                text: '<%=StudentName%>' + ':',
                cls: 'labelstyle',
                id: 'StudentNameid'
            },{
                xtype: 'textfield',
                allowBlank: false,
                allowDecimals: false,
                maskRe: /[a-zA-Z ,.]/,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterStudentName%>',
                blankText: '<%=EnterStudentName%>',
                id: 'StudentNameId1'
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryStandard'
            },{
                xtype: 'label',
                text: '<%=Standard%>' + ':',
                cls: 'labelstyle',
                id: 'Standardid'
            },Standardcombo,{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryBranchId'
            },{
                xtype: 'label',
                text: '<%=BranchName%>' + ':',
                cls: 'labelstyle',
                id: 'Branchid'
            },branchPopUpcombo,{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatorySectionId'
            },{
                xtype: 'label',
                text: '<%=Section%>' + ':',
                cls: 'labelstyle',
                id: 'SectionId'
            },{
                xtype: 'textfield',
                allowBlank: false,
                allowDecimals: false,
                cls: 'selectstylePerfect',
                maskRe: /[a-zA-Z ,.]/,
                emptyText: '<%=EnterSection%>',
                blankText: '<%=EnterSection%>',
                id: 'SectionId1'
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryParentNameId'
            },{
                xtype: 'label',
                text: '<%=ParentName%>' + ':',
                cls: 'labelstyle',
                id: 'ParentNameId'
            },{
                xtype: 'textfield',
                allowBlank: false,
                allowDecimals: false,
                cls: 'selectstylePerfect',
                maskRe: /[a-zA-Z ,.]/,
                emptyText: '<%=EnterParentName%>',
                blankText: '<%=EnterParentName%>',
                id: 'ParentNameId1'
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryParentMobileid'
            },{
                xtype: 'label',
                text: '<%=ParentMobile%>' + ':',
                cls: 'labelstyle',
                id: 'ParentMobileid'
            },{
                xtype: 'numberfield',
                allowBlank: false,
                allowDecimals: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterParentMobileNumber%>',
                blankText: '<%=EnterParentMobileNumber%>',
                id: 'ParentMobileId'
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryCountryCodeid'
            },{
                xtype: 'label',
                text: '<%=CountryCode%>' + ':',
                cls: 'labelstyle',
                id: 'CountryCodeid'
            },countrycombo,{
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
            }, {
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryLatitudeid'
            },{
                xtype: 'label',
                text: '<%=Latitude%>' + ':',
                cls: 'labelstyle',
                id: 'Latitudeid'
            }, {
                xtype: 'textfield',
                allowBlank: false,
                allowDecimals: false,
                maskRe: /[0-9.]/,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterLatitude%>',
                blankText: '<%=EnterLatitude%>',
                id: 'LatitudeId'
            }, {
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryLongitudeid'
            }, {
                xtype: 'label',
                text: '<%=Longitude%>' + ':',
                cls: 'labelstyle',
                id: 'Longitudeid'
            }, {
                xtype: 'textfield',
                allowBlank: false,
                allowDecimals: false,
                 maskRe: /[0-9.]/,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterLongitude%>',
                blankText: '<%=EnterLongitude%>',
                id: 'LongitudeId'
            }, {
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '*',
                cls: 'mandatoryfield',
                id: 'mandatoryRadiusid'
            }, {
                xtype: 'label',
                text: '<%=Radius%>' + ':',
                cls: 'labelstyle',
                id: 'Radiusid'
            }, {
                xtype: 'textfield',
                allowBlank: false,
                maskRe: /[0-9.]/,
                allowDecimals: false,
                cls: 'selectstylePerfect',
                emptyText: '<%=EnterRadius%>',
                blankText: '<%=EnterRadius%>',
                id: 'RadiusId'
            }, {
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '<%=PickUpRouteNo%>' + ':',
                cls: 'labelstyle',
                id: 'PickUpRouteNoid'
            },Typecombo,{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: ''
            },{
                xtype: 'label',
                text: '<%=DropRouteNo%>' + ':',
                cls: 'labelstyle',
                id: 'DropRouteNoid'
            },DropTypecombo,{
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
					
                   if (Ext.getCmp('StudentNameId1').getValue().trim() == "") {
                   Ext.example.msg("<%=EnterStudentName%>");
                   Ext.getCmp('StudentNameId1').focus();
                return;
              }
			   if (Ext.getCmp('standardcomboId').getValue()== "") {
			   Ext.example.msg("<%=EnterStandard%>");
               Ext.getCmp('standardcomboId').focus();
                return;
              }
              if (Ext.getCmp('branchPopUpcomboId').getValue()== "") {
                   Ext.example.msg("<%=SelectBranch%>");
                   Ext.getCmp('branchPopUpcomboId').focus();
                   return;
                }
              if (Ext.getCmp('SectionId1').getValue().trim() == "") {
                  Ext.example.msg("<%=EnterSection%>");
                  Ext.getCmp('SectionId1').focus();
                  return;
              }
			   if (Ext.getCmp('ParentNameId1').getValue().trim() == "") {
			       Ext.example.msg("<%=EnterParentName%>");
                   Ext.getCmp('ParentNameId1').focus();
                   return;
              }
			   if (Ext.getCmp('ParentMobileId').getValue() == "") {
			       Ext.example.msg("<%=EnterParentMobileNumber%>");
                   Ext.getCmp('ParentMobileId').focus();
                   return;
              }
			   if (Ext.getCmp('countryId').getValue() == "") {
			       Ext.example.msg("<%=SelectCountryCode%>");
                   Ext.getCmp('countryId').focus();
                   return;
              }
			   if (Ext.getCmp('LatitudeId').getValue().trim() == "") {
			       Ext.example.msg("<%=EnterLatitude%>");
                   Ext.getCmp('LatitudeId').focus();
                   return;
              }
			   if (Ext.getCmp('LongitudeId').getValue() == "") {
			       Ext.example.msg("<%=EnterLongitude%>");
                   Ext.getCmp('LongitudeId').focus();
                   return;
              }
			   if (Ext.getCmp('RadiusId').getValue() == "") {
			       Ext.example.msg("<%=EnterRadius%>");
                   Ext.getCmp('RadiusId').focus();
                   return;
              }
                    if (innerPanelForUnitDetails.getForm().isValid()) {
                         var selected;
                         var pickupuniqueId;    
                         var dropuniqueId;
                         var pickupCode;
                         var dropCode;
                         var branchId;
                        if (buttonValue == 'modify') {
                            selected = grid.getSelectionModel().getSelected();
                            pickupuniqueId=selected.get('pickupIdDataIndex');
                            dropuniqueId=selected.get('dropIdDataIndex');
                            pickupCode=selected.get('PickupCodeDataIndex');
                            dropCode=selected.get('DropTypeDataIndex');
                            branchId=selected.get('branchIdDataIndex');
                           // alert(selected.get('assetNumberDataIndex'));
                            //alert(branchId);
                        }
                        Ext.getCmp('addButtId').disable();
                         Ext.getCmp('canButtId').disable();
                        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SchoolRouteStudentDetailsAction.do?param=saveRouteStudentDetailsInformation',
                            method: 'POST',
                            params: {
                                  PickupUniqueId:pickupuniqueId,
                                  DropUniqueId:dropuniqueId,
                                  custId:Ext.getCmp('custcomboId').getValue(),
                                  buttonValue: buttonValue,
                                  studentName: Ext.getCmp('StudentNameId1').getValue(),
                                  standard: Ext.getCmp('standardcomboId').getValue(),
                                  Branch:Ext.getCmp('branchPopUpcomboId').getValue(),
                                  Section: Ext.getCmp('SectionId1').getValue(),
                                  parentname: Ext.getCmp('ParentNameId1').getValue(),
                                  parentMobileNo: Ext.getCmp('ParentMobileId').getValue(),
                                  CountryCode: Ext.getCmp('countryId').getValue(),
                                  EmailId: Ext.getCmp('EmailIdId').getValue(),
                                  Latitude: Ext.getCmp('LatitudeId').getValue(),
                                  Longitude: Ext.getCmp('LongitudeId').getValue(),
								  Radius: Ext.getCmp('RadiusId').getValue(),
                                  PickupCode: Ext.getCmp('typecomboId').getValue(),
                                  DropType: Ext.getCmp('dropcomboId').getValue(),
                                  pickupGrid:pickupCode,
                                  dropGrid:dropCode,
                                  BranchId:branchId
                            },
                              success: function (response, options) {
                                var message = response.responseText;
                                Ext.example.msg(message);
                                myWin.hide();
                                 store.reload({
                                   params: {
                                   CustId: custId,
                                   CustName: custName,
                                   jspName:jspName,
                                   branchId:Ext.getCmp('branchcomboId').getValue()
                                   }
                                 });
                                  	Ext.getCmp('StudentNameId1').reset();
							        Ext.getCmp('standardcomboId').reset();
							        Ext.getCmp('branchPopUpcomboId').reset();
							        Ext.getCmp('SectionId1').reset();
							        Ext.getCmp('ParentNameId1').reset();
							        Ext.getCmp('ParentMobileId').reset();
									Ext.getCmp('countryId').reset();
							        Ext.getCmp('EmailIdId').reset();
							        Ext.getCmp('LatitudeId').reset();
							        Ext.getCmp('LongitudeId').reset();
									Ext.getCmp('RadiusId').reset();
									Ext.getCmp('typecomboId').reset();
									Ext.getCmp('dropcomboId').reset();
									
									Ext.getCmp('addButtId').enable();
									Ext.getCmp('canButtId').enable();
                                   outerPanelWindow.getEl().unmask();
                            },
                            failure: function () {
                            Ext.example.msg("Failed to Insert...");
                                store.reload();
                                Ext.getCmp('addButtId').enable();
                                 Ext.getCmp('canButtId').enable();
                                myWin.hide();
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
                    myWin.hide();
                    Ext.getCmp('StudentNameId1').reset();
			        Ext.getCmp('standardcomboId').reset();
			        Ext.getCmp('branchPopUpcomboId').reset();
			        Ext.getCmp('SectionId1').reset();
			        Ext.getCmp('ParentNameId1').reset();
			        Ext.getCmp('ParentMobileId').reset();
					Ext.getCmp('countryId').reset();
			        Ext.getCmp('EmailIdId').reset();
			        Ext.getCmp('LatitudeId').reset();
			        Ext.getCmp('LongitudeId').reset();
					Ext.getCmp('RadiusId').reset();
					Ext.getCmp('typecomboId').reset();
					Ext.getCmp('dropcomboId').reset();
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
myWin = new Ext.Window({
    title: 'titel',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    cls: '',
    //height : 400,
    width: 395,
    id: 'myWin',
    items: [outerPanelWindow]
});


//***********************************function for add button in grid that will open form window**************************************************//
function addRecord() {
    buttonValue = "add";
    titel = '<%=Add%>';
    
    if (Ext.getCmp('custcomboId').getValue()== "") {
                   Ext.example.msg("<%=SelectSchool%>");
                   Ext.getCmp('custcomboId').focus();
                    return;
                }
    if (Ext.getCmp('branchcomboId').getValue()== "") {
                   Ext.example.msg("<%=SelectBranch%>");
                    Ext.getCmp('branchcomboId').focus();
                    return;
                }
    
            standardstore.load({
                           params: {
                             CustId: Ext.getCmp('custcomboId').getValue()
                           }
                        });
             branchPopUpStore.load({
                           params: {
                               CustId: Ext.getCmp('custcomboId').getValue()
                           }
                     });  
    
    myWin.show();
        Ext.getCmp('StudentNameId1').reset();
        Ext.getCmp('standardcomboId').reset();
        Ext.getCmp('branchPopUpcomboId').reset();
        Ext.getCmp('SectionId1').reset();
        Ext.getCmp('ParentNameId1').reset();
        Ext.getCmp('ParentMobileId').reset();
		Ext.getCmp('countryId').reset();
        Ext.getCmp('EmailIdId').reset();
        Ext.getCmp('LatitudeId').reset();
        Ext.getCmp('LongitudeId').reset();
		Ext.getCmp('RadiusId').reset();
		Ext.getCmp('typecomboId').reset();
		Ext.getCmp('dropcomboId').reset();
        
    myWin.setTitle(titel);
	
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
        standardstore.load({
                           params: {
                             CustId: Ext.getCmp('custcomboId').getValue()
                           }
                        });
    branchPopUpStore.load({
        params: {
            CustId: Ext.getCmp('custcomboId').getValue()
        },
        callback: function () {
           myWin.setPosition(450, 150);
           myWin.setTitle(titelForInnerPanel);
            myWin.show();
            Ext.getCmp('StudentNameId1').setValue(selected.get('StudentNameDataIndex'));
            Ext.getCmp('standardcomboId').setValue(selected.get('StandardDataIndex'));
            Ext.getCmp('branchPopUpcomboId').setValue(selected.get('branchIdDataIndex'));
            Ext.getCmp('SectionId1').setValue(selected.get('SectionDataIndex'));
            Ext.getCmp('ParentNameId1').setValue(selected.get('ParentNameDataIndex'));
            Ext.getCmp('ParentMobileId').setValue(selected.get('ParentMobileDataIndex'));
			Ext.getCmp('countryId').setValue(selected.get('CountryCodeDataIndex'));
			Ext.getCmp('EmailIdId').setValue(selected.get('EmailIdDataIndex'));
			Ext.getCmp('LatitudeId').setValue(selected.get('LatitudeDataIndex'));
			Ext.getCmp('LongitudeId').setValue(selected.get('LongitudeDataIndex'));
			Ext.getCmp('RadiusId').setValue(selected.get('RadiusDataIndex'));
			Ext.getCmp('typecomboId').setValue(selected.get('PickupCodeDataIndex'));
			Ext.getCmp('dropcomboId').setValue(selected.get('DropTypeDataIndex'));
        }
    }); 
           
}
//******************function for delete button in grid that will open form window********************************//
function deleteData() {
    if (grid.getSelectionModel().getCount() > 1) {
        Ext.example.msg("<%=SelectSingleRow%>");
        return;
    }

    if (grid.getSelectionModel().getSelected() == null) {
        Ext.example.msg("<%=NoRowsSelected%>");
        return;
    }
    Ext.Msg.show({
        title: '<%=DeleteRouteDetails%>',
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
                var pickupuniqueId=selected.get('pickupIdDataIndex');
                var dropuniqueId=selected.get('dropIdDataIndex');
                var custId = Ext.getCmp('custcomboId').getValue();
                var studentName = selected.get('StudentNameDataIndex');
                Ext.Ajax.request({
                    url: '<%=request.getContextPath()%>/SchoolRouteStudentDetailsAction.do?param=deleteRoueStudentDetails',
                    method: 'POST',
                    params: {
                        StudentName:studentName,
                        PickupUniqueId:pickupuniqueId,
                        DropUniqueId:dropuniqueId,
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
                Ext.example.msg("RouteStudentDetails not Deleted..");
                store.reload();
                break;

            }
        }
    });
}


//***************************jsonreader****************************************************************//
var reader = new Ext.data.JsonReader({
    root: 'routeStudentDetailsRoot',
    totalProperty: 'total',
    fields: [{
        name: 'slnoDataIndex'
    },{
        name: 'StudentNameDataIndex'
    },{
        name: 'StandardDataIndex'
    },{
        name: 'SectionDataIndex'
    },{
        name: 'ParentNameDataIndex'
    },{
        name: 'ParentMobileDataIndex'
    },{
        name:'CountryCodeDataIndex'
    },{
        name:'EmailIdDataIndex'
    },{
        name:'LatitudeDataIndex'
    },{
        name:'LongitudeDataIndex'
    },{
        name:'RadiusDataIndex'
    },{
        name:'PickupCodeDataIndex'
    },{
        name:'DropTypeDataIndex'
    },{
        name:'pickupIdDataIndex'
    },{
        name:'dropIdDataIndex'
    },{
        name:'branchDataIndex'
    },{
        name:'branchIdDataIndex'
    }
    ]
});

//************************* store configs****************************************//
var store = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
       url: '<%=request.getContextPath()%>/SchoolRouteStudentDetailsAction.do?param=getRouteStudentDetails',
        method: 'POST'
    }),
     remoteSort: false,
    sortInfo: {
        field: 'StudentNameDataIndex',
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
            dataIndex: 'StudentNameDataIndex',
            type: 'String'
        }, {
            dataIndex: 'StandardDataIndex',
            type: 'String'
        }, {
            dataIndex: 'SectionDataIndex',
            type: 'String'
        },{
            dataIndex: 'ParentNameDataIndex',
            type: 'String'
        }, {
            dataIndex: 'ParentMobileDataIndex',
            type: 'String'
        }, {
            dataIndex: 'CountryCodeDataIndex',
            type: 'int'
        }, {
            dataIndex: 'EmailIdDataIndex',
            type: 'String'
        }, {
            dataIndex: 'LatitudeDataIndex',
            type: 'float'
        }, {
            dataIndex: 'LongitudeDataIndex',
            type: 'float'
        }, {
            dataIndex: 'RadiusDataIndex',
            type: 'String'
        }, {
            dataIndex: 'PickupCodeDataIndex',
            type: 'String'
        }, {
            dataIndex: 'DropTypeDataIndex',
            type: 'String'
        },{
            dataIndex: 'branchDataIndex',
            type: 'String'
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
            header: "<span style=font-weight:bold;><%=StudentName%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'StudentNameDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=Standard%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'StandardDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=Section%></span>",
            hidden: false,
            width: 90,
            sortable: true,
            dataIndex: 'SectionDataIndex',
            filter: {
                type: 'String'
            }
        }, {
            header: "<span style=font-weight:bold;><%=ParentName%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'ParentNameDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=ParentMobile%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'ParentMobileDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=CountryCode%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'CountryCodeDataIndex',
            filter: {
                type: 'number'
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
            header: "<span style=font-weight:bold;><%=Latitude%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'LatitudeDataIndex',
            filter: {
                type: 'float'
            }
        },{
            header: "<span style=font-weight:bold;><%=Longitude%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'LongitudeDataIndex',
            filter: {
                type: 'float'
            }
        },{
            header: "<span style=font-weight:bold;><%=Radius%></span>",
            hidden: false,
            width: 90,
            sortable: true,
            dataIndex: 'RadiusDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=PickUpRouteNo%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'PickupCodeDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;><%=DropRouteNo%></span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'DropTypeDataIndex',
            filter: {
                type: 'String'
            }
        },{
            header: "<span style=font-weight:bold;>Branch Name</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'branchDataIndex',
            filter: {
                type: 'String'
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

grid = getGrid('<%=ManageStudents%>', '<%=NoRecordsFound%>', store, screen.width - 40, 475, 20, filters,'', false, '', 20, false, '', false, '', false, '', jspName, exportDataType, true, '<%=PDF%>', true, '<%=Add%>', true, '<%=Modify%>', true, '<%=Delete%>');

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
        //height:540,
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
