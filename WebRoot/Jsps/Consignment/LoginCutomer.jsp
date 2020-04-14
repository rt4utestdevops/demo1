<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"😕/"+request.getServerName()+":"+request.getServerPort()+path+"/";
LoginInfoBean loginInfo=new LoginInfoBean();
int systemId=Integer.parseInt(request.getParameter("systemId"));
loginInfo.setSystemId(systemId);
loginInfo.setUserId(1);
loginInfo.setLanguage("en");  
loginInfo.setZone("A");
loginInfo.setOffsetMinutes(330);
loginInfo.setCategory("India");
loginInfo.setCategoryType("South India");
loginInfo.setSystemName("T4U");
loginInfo.setCustomerId(0);
loginInfo.setStyleSheetOverride("Y");

if(loginInfo==null){
response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);	
String language="en";

CommonFunctions cf = new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean) session.getAttribute("loginInfoDetails"), session, request, response);
String responseaftersubmit="''";
String feature="1";
if(session.getAttribute("responseaftersubmit")!=null){
  responseaftersubmit="'"+session.getAttribute("responseaftersubmit").toString()+"'";
session.setAttribute("responseaftersubmit",null);
}


int customerId = loginInfo.getCustomerId();
int userId = loginInfo.getUserId();	
ArrayList<String> tobeConverted = new ArrayList<String>();
tobeConverted.add("Login_Details");
tobeConverted.add("USER_ID");
tobeConverted.add("Enter_User_Id");
tobeConverted.add("PASSWORD");
tobeConverted.add("Enter_Password");
tobeConverted.add("Login");
tobeConverted.add("Customer_Login_Details");
tobeConverted.add("Back");

ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
String LoginDetails=convertedWords.get(0);
String UserId=convertedWords.get(1);
String EnterUserId=convertedWords.get(2);
String Password=convertedWords.get(3);
String EnterPassword=convertedWords.get(4);
String Login=convertedWords.get(5);
String CustomerLoginDetails=convertedWords.get(6);
String Back = convertedWords.get(7);


%>

<!DOCTYPE HTML>
<html>
 <head>
 		<title>Login</title>	
 		  
</head>	    
	 <style type="text/css">
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
	.bodyBackGround{
background-image: url(/ApplicationImages/DashBoard/DashBoardBackground.png) !important;
margin-left:0px;
}
  </style>
  <body>
   <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else{%>
	<jsp:include page="../Common/ImportJS.jsp" /><%}%>
   <jsp:include page="../Common/ExportJS.jsp" />
   <script>
var outerPanel;
var ctsb;
var name;
var bookingCustname;
var bookingCustId;
var systemId;
var custId;
var customerLogin = "customerLogin";

var dataStore = new Ext.data.JsonStore({
    url: '<%=request.getContextPath()%>/BookingCustomerAction.do?param=toGetLoginDetailsData',
    id: 'dashBoardStoreId',
    root: 'dashBoardDataRoot',
    autoLoad: false,
    fields: ['custName', 'bookingCustomerName', 'bookingCustomerId', 'systemId', 'custId', 'region']
});

var loginPanel = new Ext.form.FormPanel({
    standardSubmit: true,
    collapsible: false,
    autoScroll: true,
    height: 130,
    width: 520,
    frame: true,
    id: 'loginPanelId',
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    items: [{
        xtype: 'fieldset',
        title: '<%=LoginDetails%>',
        cls: 'fieldsetpanel',
        collapsible: false,
        colspan: 3,
        id: 'loginDetailsId',
        width: 490,
        layout: 'table',
        layoutConfig: {
            columns: 4
        },
        items: [{
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'userNameIdMandatory'
        }, {
            xtype: 'label',
            text: 'User Id' + ' :',
            cls: 'labelstyle',
            id: 'userNameLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            allowBlank: false,
            blankText: '<%=EnterUserId%>',
            emptyText: '<%=EnterUserId%>',
            vtype: 'email',
            labelSeparator: '',
            id: 'userNameId'
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'userNameEmptyId'
        }, {
            xtype: 'label',
            text: '*',
            cls: 'mandatoryfield',
            id: 'passwordIdMandatory'
        }, {
            xtype: 'label',
            text: '<%=Password%>' + ' :',
            cls: 'labelstyle',
            id: 'passwordLabelId'
        }, {
            xtype: 'textfield',
            cls: 'selectstylePerfect',
            inputType: 'password',
            emptyText: '<%=EnterPassword%>',
            allowBlank: false,
            id: 'passwordId',
            listeners: {
                specialkey: function(f, e) {
                    if (e.getKey() == e.ENTER) {
                        ajaxFunc();
                    }
                }
            }
        }, {
            xtype: 'label',
            text: '',
            cls: 'mandatoryfield',
            id: 'passwordEmptyId'
        }]
    }]
});

function ajaxFunc() {
    Ext.Ajax.request({
        url: '<%=request.getContextPath()%>/BookingCustomerAction.do?param=loginDetails',
        method: 'POST',
        params: {
            userId: Ext.getCmp('userNameId').getValue(),
            password: Ext.getCmp('passwordId').getValue()
        },
        success: function(response, options) {
            var message = response.responseText;
            // Ext.example.msg(message);
            if (message == 'Valid') {
                dataStore.load({
                    params: {
                        userId: Ext.getCmp('userNameId').getValue()
                    },
                    callback: function() {
                        for (var i = 0; i < dataStore.getCount(); i++) {
                            var rec = dataStore.getAt(i);
                            name = rec.data['custName'];
                            bookingCustname = rec.data['bookingCustomerName'];
                            bookingCustId = rec.data['bookingCustomerId'];
                            systemId = rec.data['systemId'];
                            custId = rec.data['custId'];
                            region = rec.data['region'];
                            window.location = "<%=request.getContextPath()%>/Jsps/Consignment/ConsignmentDashBoard.jsp?name=" + name + "&bookingCustname=" + bookingCustname + "&bookingCustId=" + bookingCustId + "&systemId=" + systemId + "&custId=" + custId + "&customerLogin=" + customerLogin + "&region=" + region;
                        }
                    }
                });
            } else {
                Ext.example.msg(message);
                Ext.getCmp('userNameId').reset();
                Ext.getCmp('passwordId').reset();
            }
        },
        failure: function() {
            Ext.example.msg("Error");
        }
    });
}

var innerWinButtonPanel = new Ext.Panel({
    id: 'innerWinButtonPanelId',
    standardSubmit: true,
    collapsible: false,
    autoHeight: true,
    height: 100,
    width: 520,
    frame: true,
    layout: 'table',
    layoutConfig: {
        columns: 4
    },
    buttons: [{
        xtype: 'button',
        text: '<%=Login%>',
        iconCls: 'savebutton',
        id: 'saveButtonId',
        cls: 'buttonstyle',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    if (Ext.getCmp('userNameId').getValue() == "") {
                        Ext.example.msg("<%=EnterUserId%>");
                        return;
                    }
                    if (Ext.getCmp('passwordId').getValue() == "") {
                        Ext.example.msg("<%=EnterPassword%>");
                        return;
                    }
                    ajaxFunc()
                }
            }
        }
    }, {
        xtype: 'button',
        text: '<%=Back%>',
        id: 'canButtId',
        cls: 'buttonstyle',
        iconCls: 'backbutton',
        width: 70,
        listeners: {
            click: {
                fn: function() {
                    window.location = "/jsps/login_jsps/System_74/loginNALL.jsp";
                    Ext.getCmp('userNameId').reset();
                    Ext.getCmp('passwordId').reset();
                }
            }
        }
    }]
});

var signInOuterPanelWindow = new Ext.Panel({
    title: '<div style="text-align:center;"><%=CustomerLoginDetails%></div>',
    titleAlign: 'center',
    width: 520,
    height: 230,
    standardSubmit: true,
    frame: false,
    <!--    bodyCfg: {-->
    <!--		         cls: 'bodyBackGround',-->
    <!--		        style: {-->
    <!--		            'background-color': 'transparent'-->
    <!--		        }-->
    <!--		    },-->
    items: [loginPanel, innerWinButtonPanel]
});

var firstAndSecondPanels = new Ext.Panel({
    standardSubmit: true,
    collapsible: false,
    id: 'firsrAndSecondGridPanelId',
    layout: 'table',
    frame: false,
    width: '100%',
    border: false,
    <!--        bodyCfg: {-->
    <!--		         cls: 'bodyBackGround',-->
    <!--		        style: {-->
    <!--		            'background-color': 'transparent'-->
    <!--		        }-->
    <!--		    },-->
    height: 430,
    layoutConfig: {
        columns: 3
    },
    items: [{
        width: 400
    }, signInOuterPanelWindow, {
        width: 700
    }]
});

Ext.onReady(function() {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        renderTo: 'content',
        standardSubmit: true,
        //frame: false,
        width: screen.width - 33,
        height: 336,
        border: false,
        // cls: 'outerpanel',
        layout: 'table',
        layoutConfig: {
            columns: 1
        },
        items: [firstAndSecondPanels]
            //bbar: ctsb
    });
    sb = Ext.getCmp('form-statusbar');
});
</script>
</body>
</html>
 <%}%>   
    
    
    
    

