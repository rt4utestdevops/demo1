<%@ page language="java"
	import="java.util.*,t4u.functions.*,t4u.beans.*,t4u.common.*"
	pageEncoding="utf-8"%>
	<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
	String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
if(request.getParameter("list")!=null){
	String list=request.getParameter("list").toString().trim();
	if(!list.isEmpty()){
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
	if(str.length>11){
	loginInfo.setStyleSheetOverride(str[11].trim());
	}
	session.setAttribute("loginInfoDetails",loginInfo);
	}
}
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else
{
	ArrayList<String> tobeConverted=new ArrayList<String>();
	tobeConverted.add("Document_Uploading_Form");
	tobeConverted.add("Choose_File");
	tobeConverted.add("Upload");
	tobeConverted.add("Reset");
	tobeConverted.add("Browse");
	ArrayList<String> convertedWords=new ArrayList<String>();
	String language=loginInfo.getLanguage();
	convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
	String documentUploadingForm=convertedWords.get(0);
	String chooseFile = convertedWords.get(1);
	String upload = convertedWords.get(2);
	String reset = convertedWords.get(3);
	String browse = convertedWords.get(4);
	String SysId = request.getParameter("systemId");
	String ClientId = request.getParameter("clientId");
	String category = request.getParameter("category");
	String value = request.getParameter("value");
	
%>
<!DOCTYPE HTML>
<html>
	<head>
		<title>Document Upload</title>
		<style type="text/css">
.x-form-file-wrap {
	position: relative;
	height: 22px;
}

.x-form-file-wrap .x-form-file {
	position: absolute;
	right: 0;
	-moz-opacity: 0;
	filter: alpha(opacity :       0);
	opacity: 0;
	z-index: 2;
	height: 22px;
}

.x-form-file-wrap .x-form-file-btn {
	position: absolute;
	right: 0;
	z-index: 1;
}

.x-form-file-wrap .x-form-file-text {
	position: absolute;
	left: 0;
	z-index: 3;
	color: #777;
}

</style>
	</head>
<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
<pack:script src="../../Main/Js/T4UStatusBar.js"></pack:script>
<pack:script src="../../Main/Js/Common.js"></pack:script>
<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/StatusBar.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/ValidationStatus.js"></pack:script>
<pack:script src="../../Main/resources/ux/fileuploadfield/FileUploadField.js"></pack:script>

<pack:style src="../../Main/resources/css/ext-all.css" />
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
<jsp:include page="../Common/ImportJSSandMining.jsp"/>
<%}else {%>
<jsp:include page="../Common/ImportJS.jsp" />
<%} %>
<pack:style src="../../Main/resources/css/chooser.css" />

<pack:style src="../../Main/resources/css/common.css" />
<pack:style src="../../Main/resources/css/commonnew.css" />
<pack:style src="../../Main/iconCls/icons.css" />
<pack:style src="../../Main/resources/ux/statusbar/css/statusbar.css" />

	<body style="width: 100%;height:0%;margin: 0;background-color: #DFE8F6;">
		<div id="my_id" align="center" >
		</div>
		



		<script>
   	 var Categoryarray = [["Driver","Driver"],["Vehicle","Vehicle"]]
 	 var CategoryStore = new Ext.data.SimpleStore({
			       data:Categoryarray,
				   fields: ['category','categoryid']
			     });
   	

var categoryField = new Ext.form.ComboBox({
    fieldLabel: 'Category',
    autoHeight: true,
    labelWidth: 70,
    hiddenName: 'number',
    store:Categoryarray ,
	displayField:'categoryid',
	valueField : 'category',
	mode: 'local',
    typeAhead: true,
    triggerAction: 'all',
    emptyText:'Select category...',
    selectOnFocus:true
});
	
 var fp = new Ext.FormPanel({

    fileUpload: true,
     height:190,
    width:Ext.getBody().getViewSize().width*0.8,
    
    frame: false,
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
        width: 60,
        emptyText: '<%=browse%>',
        fieldLabel: '<%=chooseFile%>',
        name: 'filePath',
        buttonText: '',
        buttonCfg: {
            iconCls: 'browsebutton'
        },
        listeners: {

            fileselected: {
                fn: function () {
                    var filePath = document.getElementById('filePath').value;
                    //var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
					return;
                }
            }

        }
    }	],
    buttons: [{
        text: '<%=upload%>',
        iconCls : 'uploadbutton',
        handler: function () {
        
            if (fp.getForm().isValid()) {
                var filePath = document.getElementById('filePath').value;
                
				var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                if (imgext == "jpg" || imgext == "jpeg" || imgext == "JPEG" || imgext == "JPG" || imgext == "PNG" || imgext == "png" || imgext == "TIFF" 
                || imgext == "tiff" || imgext == "gif" || imgext == "GIF" || imgext == "BMP" || imgext == "bmp") {
					
                } else {
                    
                    ctsb.setStatus({
                            text: 'Please select only JPG/JPEG/PNG/TIFF/GIF/BMP files formats.',
                            iconCls: '',
                            clear: true
                        });
                    Ext.getCmp('filePath').setValue("");
                    return;
                }
               
                fp.getForm().submit({
                    url: '<%=request.getContextPath()%>/DocumentManagement.do?param=fileUpload&SystemId=<%=SysId%>&ClientId=<%=ClientId%>&category=<%=category%>&value=<%=value%>',
                    enctype: 'multipart/form-data',
                    waitMsg: 'Uploading your file...',
                    success: function (response, action) {
                    	ctsb.setStatus({
                            text: getMessageForStatus("Successful"),
                            iconCls: '',
                            clear: true
                        });
                    },
                    failure: function () {
                        ctsb.setStatus({
                            text: getMessageForStatus("Unsuccessful"),
                            iconCls: '',
                            clear: true
                        });
                    }
                });
            }
        }
    },  {
        text: '<%=reset%>',
        iconCls : 'closebutton',
        handler: function () {
            fp.getForm().reset();
          
            
        }
    }]
});

 
	Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.form.Field.prototype.msgTarget = 'side';
	
    outerPanel = new Ext.Panel({
        standardSubmit: true,
        frame: false,
        cls: 'outerpanel',
        layout: 'form',
        bbar: tsb,
		renderTo: Ext.get("my_id"),
		title: '<%=documentUploadingForm%>',
		height:200,
    	width:580,
		items: [  fp  ]
});
});

</script>
	</body>
</html>
<%}%>