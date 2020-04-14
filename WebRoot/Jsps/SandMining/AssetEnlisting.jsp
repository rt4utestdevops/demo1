
<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	if(str.length>8){
	loginInfo.setCustomerName(str[8].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
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
String systemID=Integer.toString(systemid);
int customeridlogged=loginInfo.getCustomerId();
int CustIdPassed=0;
if(request.getParameter("CustId")!=null){
	CustIdPassed=Integer.parseInt(request.getParameter("CustId").toString().trim());
}
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("AssetEnlisting_Delisting");
tobeConverted.add("Insurance_Number");
tobeConverted.add("Insurance_Expdate");
tobeConverted.add("Fitness_Expdate");
tobeConverted.add("Enlisting");
tobeConverted.add("Delisting");
tobeConverted.add("Application_No");
tobeConverted.add("Pollution_Expdate");
tobeConverted.add("Years_Permit-No");
tobeConverted.add("Years_Permit_Date_Exp");
tobeConverted.add("Name_Of_Reg_Owner");
tobeConverted.add("Permanent_Address");
tobeConverted.add("Temporary_Address");
tobeConverted.add("Mobile_No");
tobeConverted.add("Gross_Weight");
tobeConverted.add("Unladen_Weight");
tobeConverted.add("RTO");
tobeConverted.add("Permit_No");
tobeConverted.add("Permit_Expdate");
tobeConverted.add("year_Of_Manf");
tobeConverted.add("Loading_Capacity");
tobeConverted.add("UniqueId_No");
tobeConverted.add("Reference_No");
tobeConverted.add("Asset_Enlisting");
tobeConverted.add("Modify_Vehicle_Information");
tobeConverted.add("Enter_Application_No");
tobeConverted.add("Enter_Vehicle_Registration_No");
tobeConverted.add("Enter_permit_DateExp");
tobeConverted.add("Enter_Regowner_Name");
tobeConverted.add("Enter_Rto");
tobeConverted.add("Enter-Loading_Capacity");
tobeConverted.add("Enter_UniqueId_No");
tobeConverted.add("Enter_Permanent_Add");
tobeConverted.add("Enter_Temporary_Add");
tobeConverted.add("Enter_Contact-Number");
tobeConverted.add("Are_you_sure_you_want_to_delete");
tobeConverted.add("Registration_Number");
tobeConverted.add("Modify");
tobeConverted.add("SLNO");
tobeConverted.add("Save");
tobeConverted.add("Cancel");
tobeConverted.add("Select_Single_Row");
tobeConverted.add("No_Rows_Selected");
tobeConverted.add("Enter_Date");
tobeConverted.add("Date");
tobeConverted.add("Sel_Reg_No");
tobeConverted.add("Enlisting_UID");


ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String AssetEnlisting_Delisting=convertedWords.get(0);
String INSURANACENUMBER=convertedWords.get(1);
String INSURANCEEXPDATE=convertedWords.get(2);
String FITNESSEXPDATE=convertedWords.get(3);
String Enlisting=convertedWords.get(4);
String Delisting=convertedWords.get(5);
String APPLICATIONNO=convertedWords.get(6);
String POLLUTIONEXPDATE=convertedWords.get(7);
String YEARSPERMITNO=convertedWords.get(8);
String YEARSPERMITDATEEXP=convertedWords.get(9);
String NAMEOFREGOWNER=convertedWords.get(10);
String PERMANENTADDRESS=convertedWords.get(11);
String TEMPORARYADDRESS=convertedWords.get(12);
String MOBILENO=convertedWords.get(13);
String GROSSWEIGHT=convertedWords.get(14);
String UNLADENWEIGHT=convertedWords.get(15);
String RTO=convertedWords.get(16);
String PERMITNO=convertedWords.get(17);
String PERMITEXPDATE=convertedWords.get(18);
String yearofmanf=convertedWords.get(19);
String LOADINDCAPACITY=convertedWords.get(20);
String UNIQUEIDNO=convertedWords.get(21);
String REFERENCENO=convertedWords.get(22);
String AssetEnlisting=convertedWords.get(23);
String ModifyVehicleInformation=convertedWords.get(24);
String enterApplicationNo=convertedWords.get(25);
String EnterVehicleRegistrationNo=convertedWords.get(26);
String EnterpermitDateExp=convertedWords.get(27);
String EnterRegownerName=convertedWords.get(28);
String EnterRto=convertedWords.get(29);
String EnterLoadingCapacity=convertedWords.get(30);
String EnterUniqueIdNo=convertedWords.get(31);
String EnterPermanentAdd=convertedWords.get(32);
String EnterTemporaryAdd=convertedWords.get(33);
String EnterContactNumber=convertedWords.get(34);
String Areyousureyouwanttodelete=convertedWords.get(35);
String Registration_Number=convertedWords.get(36);
String Modify=convertedWords.get(37);
String SLNO=convertedWords.get(38);
String Save=convertedWords.get(39);
String Cancel=convertedWords.get(40);
String selectSingleRow=convertedWords.get(41);
String noRowsSelected=convertedWords.get(42);
String enterDate=convertedWords.get(43);
String DATE=convertedWords.get(44);
String selectVehicle=convertedWords.get(45);
String ENLISTINGUID=convertedWords.get(46);

%>

<!DOCTYPE HTML>
<html>
 <head>
	<title><%=AssetEnlisting_Delisting%></title>	
	<pack:style src="../../Main/modules/sandMining/theme/css/formLayout.css" />	
	</head>	    
  <body onload="refresh();">
   <jsp:include page="../Common/ImportJSSandMining.jsp" />
   <jsp:include page="../Common/ExportJS.jsp" />
   <style>
		 .x-toolbar-layout-ct {
			//width : 1310px !important;
		}		
   </style>
   <script>
    var outerPanel;
    var jspName = "AssetEnrolment";
    var exportDataType = "int,int,date,string,string,date,date,date,string,date,string,string,string,string,float,float,string,string,date,string,float,string,int,string";
    var selected;
    var grid;
    var buttonValue;
    var titel;
    var myWin;
    var dtprev = dateprev;

    
    function refresh() {
	    isChrome = window.chrome;
	    if (isChrome && parent.flagASSET < 2) {
	        setTimeout(
	            function () {
	                parent.Ext.getCmp('assetEnlistingTab').enable();
	                parent.Ext.getCmp('assetEnlistingTab').show();
	                parent.Ext.getCmp('assetEnlistingTab').update("<iframe style='width:100%;height:600px;border:0;'src='<%=path%>/Jsps/SandMining/AssetEnlisting.jsp'></iframe>");
	            }, 0);
	        parent.ASSETTab.doLayout();
	        parent.flagASSET = parent.flagASSET + 1;
	    }
	}
    
    
    
            
            			
     var innerPanel = new Ext.form.FormPanel({
        standardSubmit: true,
        collapsible: false,
        autoScroll: true,
        height: 390,
        width: '100%',
        frame: true,
        id: 'custMaster',
        layout: 'table',
         defaults: {
        bodyPadding: '0 0 50 0'
    	},
        layoutConfig: {
        tableAttrs: {width: '100%' }, 
            columns:4    
        },
        items: [{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryname'
            	}, 
            {
                xtype: 'label',
                text: '<%=APPLICATIONNO%>' + ' :',
                cls: 'labelstyle',
                id: 'applicationnotxt'
            }, 
            {
                xtype: 'numberfield',
                cls:'textrnumberstyle',
                regex:validate('na'),
                emptyText:'<%=enterApplicationNo%>',
                allowBlank: false,
                regexText:'Customer Name should be in Albhates only',
                blankText :'<%=enterApplicationNo%>',
                id: 'applicationnoid'
                
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatory1'
            	}, 
            {
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorydate'
            	},
            	{
                xtype: 'label',
                text: '<%=DATE%>' + ' :',
                cls: 'labelstyle',
                id: 'datetxt'
                },
             {
                xtype: 'datefield',
                cls: 'selectstyle',
                id: 'dateid',
                format: getDateFormat(),
                allowBlank: false,
                blankText: 'Select Date',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                allowBlank: false,
                value: dtprev

            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatory2'
            	},

            {
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorynumber'
            	},

            {
                xtype: 'label',
                text: '<%=Registration_Number%>' + ' :',
                cls: 'labelstyle',
                id: 'vehiclenotxt'
            }, 
            {
                xtype: 'textfield',
                regex:validate('reg'),
                emptyText:'<%=EnterVehicleRegistrationNo%>',
                allowBlank: false,
                regexText:'Customer Name should be in Albhates only',
                blankText :'<%=EnterVehicleRegistrationNo%>',
                cls: 'textrnumberstyle',
                id: 'vehiclenoid'
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatory3'
            	},
{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryinnumber'
            	},
            {
                xtype: 'label',
                text: '<%=INSURANACENUMBER%>' + ' :',
                cls: 'labelstyle',
                id: 'insurancenotxt'
            },
             {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                id: 'insurancenoid'
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatory4'
            	},
{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryinexp'
            	},
            {
                xtype: 'label',
                text: '<%=INSURANCEEXPDATE%>' + ' :',
                cls: 'labelstyle',
                id: 'insuranceexptxt'
            },
             {
                xtype: 'datefield',
                cls: 'selectstyle',
                id: 'insuranceexpid',
                format: getDateFormat(),
                allowBlank: false,
                blankText: 'Select Date',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                allowBlank: false,
                value: dtprev


            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatory5'
            	},
{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryfitexp'
            	},
            {
                xtype: 'label',
                text: '<%=FITNESSEXPDATE%>' + ' :',
                cls: 'labelstyle',
                id: 'fitnessexptxt'
            },
             {
                xtype: 'datefield',
                cls: 'selectstyle',
                id: 'fitnessexpid',
                format: getDateFormat(),
                allowBlank: false,
                blankText: 'Select Date',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                allowBlank: false,
                value: dtprev

            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatory6'
            	},
{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorypolexp'
            	},
            {
                xtype: 'label',
                text: '<%=POLLUTIONEXPDATE%>' + ' :',
                cls: 'labelstyle',
                id: 'pollutionexptxt'
            }, 
            {
                xtype: 'datefield',
                cls: 'selectstyle',
                id: 'pollutionexpid',
                format: getDateFormat(),
                allowBlank: false,
                blankText: 'Select Date',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                allowBlank: false,
                value: dtprev
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatory7'
            	},
{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryreowner'
            	},

            {
                xtype: 'label',
                text: '<%=NAMEOFREGOWNER%>' + ' :',
                cls: 'labelstyle',
                id: 'regownertxt'
            },
             {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                regex:validate('owner'),
                emptyText:'<%=EnterRegownerName%>',
                allowBlank: false,
                regexText:'Customer Name should be in Albhates only',
                blankText :'<%=EnterRegownerName%>',
                id: 'regownerid'
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorya'
            	},
{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryperadd'
            	},
            {
                xtype: 'label',
                text: '<%=PERMANENTADDRESS%>' + ' :',
                cls: 'labelstyle',
                id: 'permanenttxt'
            },
             {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                regex:validate('peadd'),
                emptyText:'<%=EnterPermanentAdd%>',
                allowBlank: false,
                regexText:'Customer Name should be in Albhates only',
                blankText :'<%=EnterPermanentAdd%>',
                id: 'permanentid'
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryb'
            	},
{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatorytemadd'
            	},
            {
                xtype: 'label',
                text: '<%=TEMPORARYADDRESS%>' + ' :',
                cls: 'labelstyle',
                id: 'temporarytxt'
            }, 
            {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                regex:validate('teadd'),
                emptyText:'<%=EnterTemporaryAdd%>',
                allowBlank: false,
                regexText:'Customer Name should be in Albhates only',
                blankText :'<%=EnterTemporaryAdd%>',
                id: 'temporaryid'
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryc'
            	},
{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryconno'
            	},
            {
                xtype: 'label',
                text: '<%=MOBILENO%>' + ' :',
                cls: 'labelstyle',
                id: 'contacttxt'
            }, 
            {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                regex:validate('con'),
                emptyText:'<%=EnterContactNumber%>',
                allowBlank: false,
                regexText:'Customer Name should be in Albhates only',
                blankText :'<%=EnterContactNumber%>',
                id: 'contactid'
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryd'
            	},
{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorygross'
            	},
            {
                xtype: 'label',
                text: '<%=GROSSWEIGHT%>' + ' :',
                cls: 'labelstyle',
                id: 'grosstxt'
            },
             {
                xtype: 'numberfield',
                cls: 'textrnumberstyle',
                id: 'grossid'
            },{
	    		html:'(tons)',
	    		hidden:false,
	    		id:'ton'
	    		},
 {
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryweight'
            	},
            {
                xtype: 'label',
                text: '<%=UNLADENWEIGHT%>' + ' :',
                cls: 'labelstyle',
                id: 'unladentxt'
            },
            {
                xtype: 'numberfield',
                cls: 'textrnumberstyle',
                id: 'unladenid'
            },{
	    		html:'(tons)',
	    		hidden:false,
	    		id:'ton1'
	    		},
	    		{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryrto'
            	},
            {
                xtype: 'label',
                text: '<%=RTO%>' + ' :',
                cls: 'labelstyle',
                id: 'RTOtxt'
            }, 
            {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                regex:validate('rto'),
                emptyText:'<%=EnterRto%>',
                allowBlank: false,
                regexText:'Customer Name should be in Albhates only',
                blankText :'<%=EnterRto%>',
                id: 'RTOid'
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryf'
            	},
{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryperno'
            	},
            {
                xtype: 'label',
                text: '<%=PERMITNO%>' + ' :',
                cls: 'labelstyle',
                id: 'permitnotxt'
            },
             {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                id: 'permitnoid'
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryg'
            	},
{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryperexp'
            	},
            {
                xtype: 'label',
                text: '<%=PERMITEXPDATE%>' + ' :',
                cls: 'labelstyle',
                id: 'permitexptxt'
            }, 
            {
                xtype: 'datefield',
                cls: 'selectstyle',
                id: 'permitexpid',
                format: getDateFormat(),
                allowBlank: false,
                blankText: 'Select Date',
                submitFormat: getDateFormat(),
                labelSeparator: '',
                allowBlank: false,
                value: dtprev
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryh'
            	},
{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatorymanf'
            	},
            {
                xtype: 'label',
                text: '<%=yearofmanf%>' + ' :',
                cls: 'labelstyle',
                id: 'yeartxt'
            }, 
            {
                xtype: 'numberfield',
                cls: 'textrnumberstyle',
                id: 'yearid'
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryi'
            	},
{
            	xtype:'label',
            	text:'*',
            	cls:'mandatoryfield',
            	id:'mandatoryload'
            	},
            {
                xtype: 'label',
                text: '<%=LOADINDCAPACITY%>' + ' :',
                cls: 'labelstyle',
                id: 'loadingtxt'
            }, 
            {
                xtype: 'numberfield',
                cls: 'textrnumberstyle',
                regex:validate('load'),
                emptyText:'<%=EnterLoadingCapacity%>',
                allowBlank: false,
                regexText:'Customer Name should be in Albhates only',
                blankText :'<%=EnterLoadingCapacity%>',
                id: 'loadingid'
            },{
	    		html:'(tons)',
	    		hidden:false,
	    		id:'ton2'
	    		},
               {
                xtype: 'checkbox',
               	checked: true,
                fieldLabel: '',
                labelSeparator: '',
               // boxLabel: 'Send Sms To Owner',
                //name: 'owner',
                id: 'smstxt',
                },{
            	xtype:'label',
            	text:'Send Sms To Owner',
            	cls:'labelstyle',
            	id:'mandatorysms'
            	},{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryown'
            	},{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryk'
            	},
                	   
            
{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryuni'
            	},
            {
                xtype: 'label',
                text: '<%=UNIQUEIDNO%>' + ' :',
                cls: 'labelstyle',
                id: 'uniquetxt'
            },
             {
                xtype: 'textfield',
                cls: 'textrnumberstyle',
                id: 'uniqueid'
            },{
            	xtype:'label',
            	text:'',
            	cls:'mandatoryfield',
            	id:'mandatoryl'
            	}
        ]
    });
    var winButtonPanel = new Ext.Panel({
        id: 'winbuttonid',
        standardSubmit: true,
        collapsible: false,
        autoHeight: true,
        height: 120,
        width: '100%',
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
            bodyCfg : { cls:'buttonstyle' ,style: {'background-color':'#C8D3DB !important'} },
            width: 70,
            listeners: {
                click: {
                    fn: function () {
                        if (Ext.getCmp('applicationnoid').getValue() == "") {
							setMsgBoxStatus("<%=enterApplicationNo%>");
                            Ext.getCmp('applicationnoid').focus();
                            return;
                        }

                        if (Ext.getCmp('dateid').getValue() == "") {
							setMsgBoxStatus("<%=enterDate%>");
                            Ext.getCmp('dateid').focus();
                            return;
                        }


                        if (Ext.getCmp('vehiclenoid').getValue() == "") {
						setMsgBoxStatus("<%=EnterVehicleRegistrationNo%>");

                            Ext.getCmp('vehiclenoid').focus();
                            return;
                        }

                        

                       if (Ext.getCmp('regownerid').getValue() == "") {
                           setMsgBoxStatus("<%=EnterRegownerName%>");
                            Ext.getCmp('regownerid').focus();
                           return;
                        }

                        if (Ext.getCmp('permanentid').getValue() == "") {
                            setMsgBoxStatus("<%=EnterPermanentAdd%>");
                            Ext.getCmp('permanentid').focus();
                           return;
                        }

                       if (Ext.getCmp('temporaryid').getValue() == "") {
                            setMsgBoxStatus("<%=EnterTemporaryAdd%>");
                            Ext.getCmp('temporaryid').focus();
                            return;
                        }                        if (Ext.getCmp('contactid').getValue() == "") {
                            setMsgBoxStatus("<%=EnterContactNumber%>");
                            Ext.getCmp('contactid').focus();
                            return;
                       }

                        if (Ext.getCmp('RTOid').getValue() == "") {
                            setMsgBoxStatus("<%=EnterRto%>");
                            Ext.getCmp('RTOid').focus();
                           return;
                        }
                        if (Ext.getCmp('permitexpid').getValue() == "") {
                            setMsgBoxStatus("<%=EnterpermitDateExp%>");
                            Ext.getCmp('permitexpid').focus();
                            return;
                        }


                        if (Ext.getCmp('loadingid').getValue() == "") {
                            setMsgBoxStatus("<%=EnterLoadingCapacity%>");
                            Ext.getCmp('loadingid').focus();
                            return;
                        }


				 if(innerPanel.getForm().isValid()) {
				        var selected;
				        var id=0;
				        if(buttonValue=='Modify'){
				        selected =  grid.getSelectionModel().getSelected();
				        id=selected.get('UID');
				        }
				        outerPanelWindow.getEl().mask(); 	
				        Ext.Ajax.request({
                            url: '<%=request.getContextPath()%>/SandMiningAction.do?param=VehicleSaveModify',
                            method: 'POST',
                            params: {
                                buttonValue: buttonValue,
                                Date: Ext.getCmp('dateid').getValue(),
                                ApplicationNo: Ext.getCmp('applicationnoid').getValue(),
                                VehicleRegistrationNo: Ext.getCmp('vehiclenoid').getValue(),
                               
                                ReGownerName: Ext.getCmp('regownerid').getValue(),
                                PermanenntAdd: Ext.getCmp('permanentid').getValue(),
                                TemporaryAdd: Ext.getCmp('temporaryid').getValue(),
                                ContactNo: Ext.getCmp('contactid').getValue(),
                                RTO: Ext.getCmp('RTOid').getValue(),
                                LoadingCapacity: Ext.getCmp('loadingid').getValue(),
                 				sms: Ext.getCmp('smstxt').getValue(),
                                InsuranceNo: Ext.getCmp('insurancenoid').getValue(),
                                InsuranceexpDate: Ext.getCmp('insuranceexpid').getValue(),
                                FitnessExpdate: Ext.getCmp('fitnessexpid').getValue(),
                                PollutionexpDate: Ext.getCmp('pollutionexpid').getValue(),
                                GrossWeight: Ext.getCmp('grossid').getValue(),
                                UnLadenWeight: Ext.getCmp('unladenid').getValue(),
                                PermitNo: Ext.getCmp('permitnoid').getValue(),
                                PermitExpDate: Ext.getCmp('permitexpid').getValue(),
                                YearOfManf: Ext.getCmp('yearid').getValue(),
                                UniqueIdNo:Ext.getCmp('uniqueid').getValue(),
                                UniqueNo:id
                            },
                            success: function (response, options) {
                                var message = response.responseText;
                                setMsgBoxStatus(message);
                                    Ext.getCmp('dateid').reset();
							        Ext.getCmp('insurancenoid').reset();
							        Ext.getCmp('insuranceexpid').reset();
							        Ext.getCmp('fitnessexpid').reset();
							        Ext.getCmp('pollutionexpid').reset();
							        Ext.getCmp('regownerid').reset();
							        Ext.getCmp('permanentid').reset();
							        Ext.getCmp('temporaryid').reset();
							        Ext.getCmp('contactid').reset();
							        Ext.getCmp('grossid').reset();
							        Ext.getCmp('unladenid').reset();
							        Ext.getCmp('RTOid').reset();
							        Ext.getCmp('permitnoid').reset();
							        Ext.getCmp('permitexpid').reset();
							        Ext.getCmp('yearid').reset();
							        Ext.getCmp('loadingid').reset();
							      Ext.getCmp('smstxt').reset();
							        Ext.getCmp('applicationnoid').reset();
							        Ext.getCmp('vehiclenoid').reset();
							        
                               myWin.hide();
                                store.reload();
                             grid.getView().refresh();
							 outerPanelWindow.getEl().unmask();   
                             },
                            failure: function () {

                                setMsgBoxStatus("Error");
                                store.reload();
                                outerPanelWindow.getEl().unmask();
                                myWin.hide();
                            }
                            
                        });
                   }else{
					setMsgBoxStatus('There is some invalid data in field plz correct it');
										
					
					}
                    }
                }
            }
        }, {
            xtype: 'button',
            text: '<%=Cancel%>',
            iconCls: 'cancelbutton',
            id: 'canButtId',
            cls: 'buttonstyle',
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
    var outerPanelWindow = new Ext.Panel({
        width: '100%',
        border:true,
        standardSubmit: true,
        frame: false,
        items: [innerPanel, winButtonPanel]
    });


    myWin = new Ext.Window({
        title: titel,
        closable: false,
        resizable: false,
        modal: true,
        autoScroll: false,
        height: 500,
        width: '60%',
        id: 'myWin',
        items: [outerPanelWindow]
    });

    function addRecord() {
        buttonValue = "Enlisting";
        titel = '<%=AssetEnlisting%>';
        myWin.show();
        myWin.setPosition(270, 12);
        myWin.setTitle(titel);
        Ext.getCmp('applicationnoid').show();
        Ext.getCmp('applicationnoid').enable();
        Ext.getCmp('applicationnotxt').show();
        Ext.getCmp('dateid').enable();
        Ext.getCmp('datetxt').show();
        Ext.getCmp('vehiclenoid').show();
        Ext.getCmp('vehiclenoid').enable();
        Ext.getCmp('vehiclenotxt').show();
        Ext.getCmp('insurancenoid').show();
        Ext.getCmp('insurancenotxt').show();
        Ext.getCmp('insuranceexpid').show();
        Ext.getCmp('insuranceexptxt').show();
        Ext.getCmp('fitnessexpid').show();
        Ext.getCmp('fitnessexptxt').show();
        Ext.getCmp('pollutionexpid').show();
        Ext.getCmp('pollutionexptxt').show();
        Ext.getCmp('regownerid').show();
        Ext.getCmp('regownertxt').show();
        Ext.getCmp('permanentid').show();
        Ext.getCmp('permanenttxt').show();
        Ext.getCmp('temporaryid').show();
        Ext.getCmp('temporarytxt').show();
        Ext.getCmp('contactid').show();
        Ext.getCmp('contacttxt').show();
        Ext.getCmp('grossid').show();
        Ext.getCmp('grosstxt').show();
        Ext.getCmp('unladenid').show();
        Ext.getCmp('unladentxt').show();
        Ext.getCmp('RTOid').show();
        Ext.getCmp('RTOtxt').show();
        Ext.getCmp('permitnoid').show();
        Ext.getCmp('permitnotxt').show();
        Ext.getCmp('permitexpid').show();
        Ext.getCmp('permitexptxt').show();
        Ext.getCmp('yearid').show();
        Ext.getCmp('yeartxt').show();
        Ext.getCmp('loadingid').show();
        Ext.getCmp('loadingtxt').show();
        Ext.getCmp('smstxt').show();
        Ext.getCmp('uniqueid').hide();
        Ext.getCmp('mandatoryuni').hide();
        Ext.getCmp('uniquetxt').hide();
        Ext.getCmp('dateid').reset();
							        Ext.getCmp('insurancenoid').reset();
							        Ext.getCmp('insuranceexpid').reset();
							        Ext.getCmp('fitnessexpid').reset();
							        Ext.getCmp('pollutionexpid').reset();
							        Ext.getCmp('regownerid').reset();
							        Ext.getCmp('permanentid').reset();
							        Ext.getCmp('temporaryid').reset();
							        Ext.getCmp('contactid').reset();
							        Ext.getCmp('grossid').reset();
							        Ext.getCmp('unladenid').reset();
							        Ext.getCmp('RTOid').reset();
							        Ext.getCmp('permitnoid').reset();
							        Ext.getCmp('permitexpid').reset();
							        Ext.getCmp('yearid').reset();
							        Ext.getCmp('loadingid').reset();
							        Ext.getCmp('applicationnoid').reset();
							        Ext.getCmp('vehiclenoid').reset();
    }



    function modifyData() {
        if (grid.getSelectionModel().getCount() > 1) {
            setMsgBoxStatus("<%=selectSingleRow%>");
            return;
        }

        if (grid.getSelectionModel().getSelected() == null) {
            setMsgBoxStatus('<%=noRowsSelected%>');
            return;
        }
        buttonValue = "Modify";
        titel = "<%=ModifyVehicleInformation%>"
        myWin.setTitle(titel);
        Ext.getCmp('applicationnoid').disable();
        // Ext.getCmp('applicationnotxt').show();
        Ext.getCmp('dateid').disable();
        //Ext.getCmp('datetxt').show();
        Ext.getCmp('vehiclenoid').disable();
        //Ext.getCmp('vehiclenotxt').hiddden=true;
        Ext.getCmp('insurancenoid').show();
        Ext.getCmp('insurancenotxt').show();
        Ext.getCmp('insuranceexpid').show();
        Ext.getCmp('insuranceexptxt').show();
        Ext.getCmp('fitnessexpid').show();
        Ext.getCmp('fitnessexptxt').show();
        Ext.getCmp('pollutionexpid').show();
        Ext.getCmp('pollutionexptxt').show();
        Ext.getCmp('regownerid').show();
        Ext.getCmp('regownertxt').show();
        Ext.getCmp('permanentid').show();
        Ext.getCmp('permanenttxt').show();
        Ext.getCmp('temporaryid').show();
        Ext.getCmp('temporarytxt').show();
        Ext.getCmp('contactid').show();
        Ext.getCmp('contacttxt').show();
        Ext.getCmp('grossid').show();
        Ext.getCmp('grosstxt').show();
        Ext.getCmp('unladenid').show();
        Ext.getCmp('unladentxt').show();
        Ext.getCmp('RTOid').show();
        Ext.getCmp('RTOtxt').show();
        Ext.getCmp('permitnoid').show();
        Ext.getCmp('permitnotxt').show();
        Ext.getCmp('permitexpid').show();
        Ext.getCmp('permitexptxt').show();
        Ext.getCmp('yearid').show();
        Ext.getCmp('yeartxt').show();
        Ext.getCmp('loadingid').show();
        Ext.getCmp('loadingtxt').show();
        Ext.getCmp('uniqueid').show();
        Ext.getCmp('smstxt').hide();
        Ext.getCmp('mandatoryuni').show();
        Ext.getCmp('uniqueid').disable();
        Ext.getCmp('uniquetxt').show();
       
        
               
        var selected = grid.getSelectionModel().getSelected();
        myWin.show();
        myWin.setPosition(270, 12);
        Ext.getCmp('applicationnoid').setValue(selected.get('APPLICATIONNO'));
        Ext.getCmp('dateid').setValue(selected.get('DATE'));
        Ext.getCmp('vehiclenoid').setValue(selected.get('VEHICLEREGISTRATIONNO'));
        Ext.getCmp('insurancenoid').setValue(selected.get('INSURANACENUMBER'));
        Ext.getCmp('insuranceexpid').setValue(selected.get('INSURANCEEXPDATE'));
        Ext.getCmp('fitnessexpid').setValue(selected.get('FITNESSEXPDATE'));
        Ext.getCmp('pollutionexpid').setValue(selected.get('POLLUTIONEXPDATE'));
        Ext.getCmp('regownerid').setValue(selected.get('NAMEOFREGOWNER'));
        Ext.getCmp('permanentid').setValue(selected.get('PERMANENTADD'));
        Ext.getCmp('temporaryid').setValue(selected.get('TEMPORARYADD'));
        Ext.getCmp('contactid').setValue(selected.get('CONTACTNO'));
        Ext.getCmp('grossid').setValue(selected.get('GROSSWEIGHT'));
        Ext.getCmp('unladenid').setValue(selected.get('UNLADENWEIGHT'));
        Ext.getCmp('RTOid').setValue(selected.get('RTO'));
        Ext.getCmp('permitnoid').setValue(selected.get('PERMITNO'));
        Ext.getCmp('permitexpid').setValue(selected.get('PERMITEXPDATE'));
        Ext.getCmp('yearid').setValue(selected.get('yearofmanf'));
        Ext.getCmp('loadingid').setValue(selected.get('LOADINDCAPACITY'));
        Ext.getCmp('uniqueid').setValue(selected.get('UNIQUEIDNO')); 
      //  Ext.getCmp('smstxt').getValue()
          
    }
   
     function deleteData() {
       if (grid.getSelectionModel().getCount() > 1) {
            setMsgBoxStatus("<%=selectSingleRow%>");
            return;
        }

        if (grid.getSelectionModel().getSelected() == null) {
           	setMsgBoxStatus('<%=noRowsSelected%>');
            return;
        }
        Ext.Msg.show({
            title: '<%=Delisting%>',
            msg: '<%=Areyousureyouwanttodelete%>',
            buttons: {
                yes: true,
                no: true
            },
            fn: function (btn) {
                switch (btn) {
                case 'yes':
                    outerPanel.getEl().mask();
                    //Ajax request
                     var selected = grid.getSelectionModel().getSelected();
                    Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/SandMiningAction.do?param=VechicleDelist',
                        method: 'POST',
                        params: {
                           
                            VehicleRegistrationNo: selected.get('VEHICLEREGISTRATIONNO'),
                            UniqueIdNo:selected.get('UID'),
                           // sms: selected.get('smstxt'),
                            ContactNo: selected.get('CONTACTNO'),
                            ReGownerName: selected.get('NAMEOFREGOWNER')
                        },
                        success: function (response, options) {

                            setMsgBoxStatus(response.responseText);
                            store.reload();
                            outerPanel.getEl().unmask();

                        },
                        failure: function () {
                            setMsgBoxStatus("Error");
                            store.reload();
                            outerPanel.getEl().unmask();

                        }
                    });

                    break;
                case 'no':
                    setMsgBoxStatus("Vehicle not Delisted");
                    store.reload();
                    break;

                }
            }
        });

    }


    var reader = new Ext.data.JsonReader({
        idProperty: 'vehicleinformationid',
        root: 'vehicleInformationRoot',
        totalProperty: 'total',
        fields: [{name:'slnoIndex'},{
                name: 'APPLICATIONNO'
            }, {
                name: 'DATE'
            }, {
                name: 'VEHICLEREGISTRATIONNO'
            },{
                name: 'INSURANACENUMBER'
            },{
                name: 'INSURANCEEXPDATE'
            },{
                name: 'FITNESSEXPDATE'
            },{
                name: 'POLLUTIONEXPDATE'
            }, {
                name: 'NAMEOFREGOWNER'
            }, {
                name: 'PERMANENTADD'
            }, {
                name: 'TEMPORARYADD'
            }, {
                name: 'CONTACTNO'
            },{
                name: 'GROSSWEIGHT'
            },{
                name: 'UNLADENWEIGHT'
            },
            {
                name: 'RTO'
            },{
                name: 'PERMITNO'
            },{
                name: 'PERMITEXPDATE'
            },{
                name: 'yearofmanf'
            },
            
            {
                name: 'LOADINDCAPACITY'
            },

            {
                name: 'UNIQUEIDNO'
            },
            {
                name: 'UID'
            },
            {
               name:'ENLISTINGUID'
            }
        ]
    });




    //********************************************************* Store Configs********************************************************************************

    var store = new Ext.data.GroupingStore({
        autoLoad: false,
        proxy: new Ext.data.HttpProxy({
            url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getVehicleEnlistingDetails',
            method: 'POST'
        }),
        storeId: 'vehicleinformationid',
        reader: reader
    });


    //********************************************************************Filter Config************************************************************************************
    var filters = new Ext.ux.grid.GridFilters({
        local: true,
        filters: [{type:'numeric',
        		dataIndex:'slnoIndex'
        		},	{
                type: 'int',
                dataIndex: 'APPLICATIONNO'
            }, {
                type: 'date',
                dataIndex: 'DATE'
            },{
                type: 'string',
                dataIndex: 'VEHICLEREGISTRATIONNO'
            }, {
                type: 'string',
                dataIndex: 'INSURANACENUMBER'
            },
             {
                type: 'date',
                dataIndex: 'INSURANCEEXPDATE'
            }, {
                type: 'date',
                dataIndex: 'FITNESSEXPDATE'
            }, {
                type: 'date',
                dataIndex: 'POLLUTIONEXPDATE'
            }, {
                type: 'string',
                dataIndex: 'YEARSPERMITNO'
            }, 
            
              {
                type: 'date',
                dataIndex: 'YEARSPERMITDATEEXP'
            }, {
                type: 'string',
                dataIndex: 'NAMEOFREGOWNER'

            }, {
                type: 'string',
                dataIndex: 'PERMANENTADDRESS'

            },

            {
                type: 'string',
                dataIndex: 'TEMPORARYADDRESS'

            }, {
                type: 'string',
                dataIndex: 'CONTACTNO'

            },
             {
                type: 'float',
                dataIndex: 'GROSSWEIGHT'
            }, {
                type: 'float',
                dataIndex: 'UNLADENWEIGHT'
            },
            {
                type: 'string',
                dataIndex: 'RTO'

            },
             {
                type: 'string',
                dataIndex: 'PERMITNO'
            },
             {
                type: 'date',
                dataIndex: 'PERMITEXPDATE'
            },
             {
                type: 'string',
                dataIndex: 'yearofmanf'
            },

            {
                type: 'float',
                dataIndex: 'LOADINDCAPACITY'

            },

            {
                type: 'string',
                dataIndex: 'UNIQUEIDNO'

            },
            {
                type: 'int',
                dataIndex: 'UID'

            },
            {
                type: 'string',
                dataIndex: 'ENLISTINGUID'

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
                },{
                header: "<span style=font-weight:bold;><%=APPLICATIONNO%></span>",
                dataIndex: 'APPLICATIONNO',

                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=DATE%></span>",
                dataIndex: 'DATE',

                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=Registration_Number%></span>",
                dataIndex: 'VEHICLEREGISTRATIONNO',

                filter: {
                    type: 'string'
                }
            }, {
                    dataIndex: 'INSURANACENUMBER',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=INSURANACENUMBER%></span>",
                    filter: {
                        type: 'string'
                    }
                },{
                    dataIndex: 'INSURANCEEXPDATE',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=INSURANCEEXPDATE%></span>",
                    filter: {
                        type: 'date'
                    }
                },{
                    dataIndex: 'FITNESSEXPDATE',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=FITNESSEXPDATE%></span>",
                    filter: {
                        type: 'date'
                    }
                },{
                    dataIndex: 'POLLUTIONEXPDATE',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=POLLUTIONEXPDATE%></span>",
                    filter: {
                        type: 'date'
                    }
                },{
                    dataIndex: 'YEARSPERMITNO',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=YEARSPERMITNO%></span>",
                    filter: {
                        type: 'string'
                    }
                },
            
             {
                header: "<span style=font-weight:bold;><%=YEARSPERMITDATEEXP%></span>",
                hidden: true,
                dataIndex: 'YEARSPERMITDATEEXP',
                filter: {
                    type: 'date'
                }
            }, {
                header: "<span style=font-weight:bold;><%=NAMEOFREGOWNER%></span>",
                dataIndex: 'NAMEOFREGOWNER',

                filter: {
                    type: 'string'
                }
            },

            {
                header: "<span style=font-weight:bold;><%=PERMANENTADDRESS%></span>",
                dataIndex: 'PERMANENTADD',

                filter: {
                    type: 'string'
                }
            },

            {
                header: "<span style=font-weight:bold;><%=TEMPORARYADDRESS%></span>",
                dataIndex: 'TEMPORARYADD',

                filter: {
                    type: 'string'
                }
            },

            {
                header: "<span style=font-weight:bold;><%=MOBILENO%></span>",
                dataIndex: 'CONTACTNO',
                filter: {
                    type: 'string'
                }
            },{
                    dataIndex: 'GROSSWEIGHT',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=GROSSWEIGHT%></span>",
                    filter: {
                        type: 'float'
                    }
                },{
                    dataIndex: 'UNLADENWEIGHT',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=UNLADENWEIGHT%></span>",
                    filter: {
                        type: 'string'
                    }
                },
           {
                header: "<span style=font-weight:bold;><%=RTO%></span>",
                dataIndex: 'RTO',

                filter: {
                    type: 'string'
                }
            }, {
                    dataIndex: 'PERMITNO',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=PERMITNO%></span>",
                    filter: {
                        type: 'string'
                    }
                },{
                    dataIndex: 'PERMITEXPDATE',
                   header: "<span style=font-weight:bold;><%=PERMITEXPDATE%></span>",
                    filter: {
                        type: 'date'
                    }
                },{
                    dataIndex: 'yearofmanf',
                    hidden: true,
                    header: "<span style=font-weight:bold;><%=yearofmanf%></span>",
                    filter: {
                        type: 'string'
                    }
                },
            
            
            {
                header: "<span style=font-weight:bold;><%=LOADINDCAPACITY%></span>",
                dataIndex: 'LOADINDCAPACITY',

                filter: {
                    type: 'numeric'
                }
            }, {
                header: "<span style=font-weight:bold;><%=UNIQUEIDNO%></span>",
                dataIndex: 'UNIQUEIDNO',
                filter: {
                    type: 'string'
                }
            }, {
                header: "<span style=font-weight:bold;>UNIOQUEID</span>",
                dataIndex: 'UID',
                hidden:true,
                filter: {
                    type: 'numeric'
                }
            },{
                header: "<span style=font-weight:bold;><%=ENLISTINGUID%></span>",
                dataIndex: 'ENLISTINGUID',
                
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
    grid = getGrid('<%=AssetEnlisting_Delisting%>', 'NoRecordsFound', store, screen.width - 25, 500, 25, filters, 'Clear Filter Data', false, '', 25, false, '', false, '', true, 'Excel', jspName, exportDataType, false, '', true, 'Enlisting', true, 'Modify', true, 'Delisting');
    //******************************************************************************************************************************************************



    //****************************************************Main starts from here**************************************************************************


    Ext.namespace('Ext.ux');
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    Ext.onReady(function () {
        Ext.QuickTips.init();
        Ext.form.Field.prototype.msgTarget = 'side';
        outerPanel = new Ext.Panel({
            renderTo: 'content',
            standardSubmit: true,
            frame: false,
            border: false,
            bodyCfg : { cls:'outerpanel' ,style: {'background':'#FFFFFF !important'} },
            items: [grid]
        });
        store.load({
                params:{jspName:jspName}
                });
                

    });
</script>
</body>
</html>