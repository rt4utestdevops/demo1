<%@ page  language="java" import="java.util.*,java.text.SimpleDateFormat,t4u.functions.*,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>

<% 

Properties properties = ApplicationListener.prop;
String server = properties.getProperty("hostName").trim();
String user1 = properties.getProperty("userName").trim();
String pass = properties.getProperty("password").trim();

 
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
			loginInfo.setStyleSheetOverride("N");
		}
		session.setAttribute("loginInfoDetails", loginInfo);
	}
	CommonFunctions cf = new CommonFunctions();
	LoginInfoBean loginInfo = (LoginInfoBean) session
			.getAttribute("loginInfoDetails");
	if (loginInfo == null) {
		LoginInfoBean loginInfo1 = new LoginInfoBean();
		loginInfo1.setSystemId(0);
		loginInfo1.setLanguage("en");
		session.setAttribute("loginInfoDetails", loginInfo1);
} else {
		session.setAttribute("loginInfoDetails", loginInfo);
		String language = loginInfo.getLanguage();
	}		 
 %>
 

<!DOCTYPE HTML>
<html>
 <head>
</head>	    
	 <style>
  .x-panel-tl
	{
		border-bottom: 0px solid !important;
	}
  </style>
  <body>
   
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	
   <script>
   var custarray = [['ADWISE']];
   var count;
   var store= new Ext.data.SimpleStore({
    id: 'CustomerID',
   fields: ['name'],
   autoLoad: true,
   data: custarray
   });
    
   var CustomerCombo = new Ext.form.ComboBox({
  store:store,
  id: 'CustomerComboID',
  mode: 'local',
  hidden: false,
  selectOnFocus: true,
  allowBlank: false,
  anyMatch: true,
  valueField: 'name',
  displayField: 'name', 
  forceSelection: true,
  autoload: true,
  typeAhead: false,
  triggerAction: 'all',
  listeners: {
	select: {
			fn: function() {
							store1.load({
								params:{}
									});

}
}
}
  });
   
   var store1 = new Ext.data.JsonStore({
       url: '<%=request.getContextPath()%>/AdwiseManagement.do?param=getUID',
       id: 'UidStoreId',
       root: 'UIDRoot',
       autoLoad: false,
       remoteSort: true,
       fields: ['UID','IMEI']
   });
   
    var CustomerUIDCombo = new Ext.form.ComboBox({
   id: 'CustomerUIDId',
   store:store1,
   mode: 'local',
   hidden: false,
   selectOnFocus: true,
   allowBlank: false,
   anyMatch: true,
   valueField: 'IMEI',
   displayField: 'UID', 
   forceSelection: true,
   autoload: false,
   typeAhead: false,
   triggerAction: 'all',
   listeners: {
 		select: {
 			fn: function() {
 				UID = Ext.getCmp('CustomerUIDId').getRawValue();
 				IMEI = Ext.getCmp('CustomerUIDId').getValue();
 				Ext.getCmp('imeiid').setText(IMEI);
 				 Ext.getCmp('IpId').setValue('<%=server%>');
 						Ext.getCmp('UserId').setValue('<%=user1%>');
 							Ext.getCmp('PwdId').setValue('<%=pass%>');
 							Ext.getCmp('portId').setValue(21);
 							Ext.getCmp('IpId').disable();
 							Ext.getCmp('UserId').disable();
 							Ext.getCmp('PwdId').disable();
 							Ext.getCmp('portId').disable();
 							 Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/AdwiseManagement.do?param=getCameraDetails',
                           method: 'POST',
                           params: {
                        //   Cam_Num: Ext.getCmp('CamFldID').getValue(),
                           uidValue: Ext.getCmp('CustomerUIDId').getRawValue()
                           },
                           success: function(response) {
                                count = response.responseText;
                           },
                           failure: function() {
                               Ext.example.msg("Error");
                           }
                           });
 				
 			}
 		}
 	}
   });
   
    var innerGetpannel =new Ext.Panel({
   frame:true,
   height:300,
   colspan:2,
   rowspan:2,
   title:'GET',
   layout:'table',
   layoutConfig: {
 		columns: 2
 	},
 	items:[{
           
           xtype:'label',
           text:'CAM_FTP_GET '+':',
           cls:'lablestyle',
           id:'g1'
           },{
               xtype: 'checkbox',
               fieldLabel: 'CAM_FTP_GET',
               cls: 'labelstyle',
               id: 'ftpGetId',
               width:300,
               checked:false,
               height:25
           },
           {
           xtype:'label',
           text:'CAM_STAT_GET'+':',
           cls:'lablestyle',
           id:'g2'
           },
           {
               xtype: 'checkbox',
               fieldLabel: 'CAM_STAT_GET',
               cls: 'labelstyle',
               id: 'CamStatId',
               checked:false,
               width:300,
               height:25
           },
            {
           xtype:'label',
           text:'CAM_FLD_GET '+':',
           cls:'lablestyle',
           id:'g3'
           },{
               xtype: 'checkbox',
               fieldLabel: 'CAM_FLD_GET',
               cls: 'labelstyle',
               id: 'camFldGetId',
               width:300,
               checked:false,
               height:25
           },
           {
 		xtype: 'button',
 		text: 'Submit',
 		id: 'submittId2',
 		cls: 'buttonstyle',
 		width:'100',
 		listeners: {
               click: {
                   fn: function() {
                   if (Ext.getCmp('CustomerComboID').getValue() == "") {
 						Ext.example.msg("Please Select Customer");
 						return;
 					}
 					if (Ext.getCmp('CustomerUIDId').getValue() == "") {
 						Ext.example.msg("Please Select Customer UID");
 						return;
 					}
 					if (Ext.getCmp('ftpGetId').getValue() == false && Ext.getCmp('CamStatId').getValue() == false && Ext.getCmp('camFldGetId').getValue() == false) {
 						Ext.example.msg("Please Enter atleast one Command");
 						return;
 					}
                   Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/AdwiseManagement.do?param=getDetails',
                           method: 'POST',
                           params: {
                           ftpGetId: Ext.getCmp('ftpGetId').getValue(),
                           CamStatId: Ext.getCmp('CamStatId').getValue(),
                           camFldGetId: Ext.getCmp('camFldGetId').getValue(),
                           
                           uidValue: Ext.getCmp('CustomerUIDId').getRawValue(),
                            deviceId: Ext.getCmp('CustomerUIDId').getValue()
                           },
                           success: function(response) {
                               var message = response.responseText;
                               Ext.example.msg(message);
          
                           },
                           failure: function() {
                               Ext.example.msg("Error");
                           }
                   
                   });
                   }
                   }
                   }
 		}]
 	});
    
   var innerSetpannel =new Ext.Panel({
   frame:true,
   height:300,
   colspan:2,
   rowspan:2,
   title:'SET',
   layout:'table',
   layoutConfig: {
 		columns: 2
 	},
 	items:[{
           
           xtype:'label',
           text:'IP '+':',
           cls:'lablestyle',
           id:'l1'
           },{
               xtype: 'textfield',
               fieldLabel: 'IP',
               cls: 'labelstyle',
               id: 'IpId',
               width:300,
               height:25
           },
            {
           xtype:'label',
           text:'USER NAME '+':',
           cls:'lablestyle',
           id:'l2'
           },
           {
               xtype: 'textfield',
               fieldLabel: 'User Name',
               cls: 'labelstyle',
               id: 'UserId',
               width:300,
               height:25
           },
            {
           xtype:'label',
           text:'PASSWORD '+':',
           cls:'lablestyle',
           id:'l3'
           },{
               xtype: 'textfield',
               fieldLabel: 'Password',
               cls: 'labelstyle',
               id: 'PwdId',
               width:300,
               height:25
           },
           {
           xtype:'label',
           text:'CAM INTR '+':',
           cls:'lablestyle',
           id:'l4'
           },{
               xtype: 'textfield',
               fieldLabel: 'INR',
               cls: 'labelstyle',
               id: 'IntrID',
               width:300,
               height:25,
               listeners: {
			        render: function(c) {
			          new Ext.ToolTip({
			            target: c.getEl(),
			            html: 'Enter time,Cam1 status and Cam2 status. Ex: M2,1,0'
			          });
			        }
			    }
           },
           {
           xtype:'label',
           text:'CAMERA FOLDER '+':',
           cls:'lablestyle',
           id:'l5'
           },
           {
               xtype: 'textfield',
               fieldLabel: 'camera_folder',
               cls: 'labelstyle',
               id: 'CamFldID',
               maskRe: /[A-Za-z0-9,]/,
               width:300,
               height:25,
               listeners: {
			        render: function(c) {
			          new Ext.ToolTip({
			            target: c.getEl(),
			            html: 'Enter folder names. Ex: Cam1Data,Cam2Data'
			          });
			        }
			    }
           },
           {
           xtype:'label',
           text:'PORT '+':',
           cls:'lablestyle',
           id:'l6'
           },{
               xtype: 'textfield',
               fieldLabel: 'port',
               cls: 'labelstyle',
               id: 'portId',
               width:300,
               height:25
           },
           {
           xtype:'label',
           text:'CAM_FTP '+':',
           cls:'lablestyle',
           id:'l7'
           },{
               xtype: 'checkbox',
               fieldLabel: 'Cam_ftp',
               cls: 'labelstyle',
               id: 'CamFtpId',
               checked:false,
               width:300,
               height:25
           },
           {
 		xtype: 'button',
 		text: 'Submit',
 		id: 'submittId1',
 		cls: 'buttonstyle',
 		width:'100',
 		listeners: {
               click: {
                   fn: function() {
                   if (Ext.getCmp('CustomerComboID').getValue() == "") {
 						Ext.example.msg("Please Select Customer");
 						return;
 					}
 					if (Ext.getCmp('CustomerUIDId').getValue() == "") {
 						Ext.example.msg("Please Select Customer UID");
 						return;
 					}
 					if (Ext.getCmp('IntrID').getValue() == "" && Ext.getCmp('CamFldID').getValue() == "" && Ext.getCmp('CamFtpId').getValue() == false) {
 						Ext.example.msg("Please Enter atleast one Command");
 						return;
 					}
 					if(Ext.getCmp('CamFtpId').getValue() == true) 
 					{
 					   if (Ext.getCmp('IpId').getValue() == "") {
 						Ext.example.msg("Please Enter  IP");
 						return;
 					}
 					if (Ext.getCmp('UserId').getValue() == "") {
 						Ext.example.msg("Please Enter USERNAME");
 						return;
 					}
 					if (Ext.getCmp('PwdId').getValue() == "") {
 						Ext.example.msg("Please Enter Password");
 						return;
 					}
 					}
 					var pattr1=/^[MHmh][0-9]*,[0-1],[0-1]$/;
				if(!(Ext.getCmp('IntrID').getValue() == ""))
				{
				if(!pattr1.test(Ext.getCmp('IntrID').getValue()))
				{
					Ext.example.msg("Please Check input format for Interval");
					return;
	 			}
	 			
				}
				
				
 					if(Ext.getCmp('CamFldID').getValue()!="")
 					{
	 				//	var pattr=/^[A-Za-z_][0-9A-Za-z_]+,[A-Za-z_][0-9A-Za-z_]+$/;
	 					var pattr=/^[A-Za-z0-9_]+,[A-Za-z0-9_]+$/;
	 					if(pattr.test(Ext.getCmp('CamFldID').getValue()))
	 					{	if(count==1){
		 						Ext.example.msg("Please Enter One folder name");
		 						return;
	 						}
	 					}
	 					else if(/^[A-Za-z0-9_]+$/.test(Ext.getCmp('CamFldID').getValue()))
	 					{   if(count==2){
		 						Ext.example.msg("Please Enter Two folder name for two cameras");
		 						return;
	 						}
	 					}
	 					else 
	 					{
		 					Ext.example.msg("Please Check input format for Folder name and Maximum Camera folder is 2");
		 					return;
	 					}
 					}
 					
                   Ext.Ajax.request({
                           url: '<%=request.getContextPath()%>/AdwiseManagement.do?param=setDetails',
                           method: 'POST',
                           params: {
                           IP: Ext.getCmp('IpId').getValue(),
                           UserId: Ext.getCmp('UserId').getValue(),
                           PwdID: Ext.getCmp('PwdId').getValue(),
                           IntrID: Ext.getCmp('IntrID').getValue(),
                           CamFldID: Ext.getCmp('CamFldID').getValue(),
                           portID: Ext.getCmp('portId').getValue(),
                           camFtpId: Ext.getCmp('CamFtpId').getValue(),
                           uidValue: Ext.getCmp('CustomerUIDId').getRawValue(),
                            deviceId: Ext.getCmp('CustomerUIDId').getValue()
                           },
                           success: function(response) {
                               var message = response.responseText;
                               Ext.example.msg(message);
          
                           },
                           failure: function() {
                               Ext.example.msg("Error");
                           }
                   
                   })
                   }}}
 		}
 	]
 	});
   
   var OuterSetGetpannel =new Ext.Panel({
   frame:true,
   height:312,
   colspan:2,
   rowspan:2,
   margin: '0 0 0 0',
   padding:'0px',
   layout:'table',
   layoutConfig: {
 		columns: 2
 	},
 	items:[innerSetpannel,innerGetpannel]
 	});

   var panel1 = new Ext.Panel({
   frame:true,
   height:100,
   title:'Adwise Management',
   colspan:2,
   layout:'table',
 padding:'10px',
   layoutConfig: {
 		columns: 20
 	},
   
   items:[{
               xtype: 'label',
               text: 'Customer : ',
               cls: 'labelstyle',
               id: 'AdwiseId'
           },
           CustomerCombo, {
               width: 40
           },
           {
               xtype: 'label',
               text: 'Select UID : ',
               cls: 'labelstyle',
               id: 'uid'
           }, CustomerUIDCombo, {
               width: 40
           },{
               xtype: 'label',
               text: 'IMEI : ',
               cls: 'labelstyle',
               id: 'imeilabelid'
           },{
               xtype: 'label',
               text: '',
               cls: 'labelstyle',
               id: 'imeiid'
           }]
           
           
   });
    Ext.onReady(function() {
       Ext.QuickTips.init();
       var outerPanel = new Ext.Panel({
           renderTo: 'content',
           standardSubmit: true,
           frame: false,
           cls: 'outerpanel',
           layout: 'table',
           height:'400',
           width:screen.width,
           width : 862,
           layoutConfig: {
               columns: 1
           },
                   
           items:[panel1,OuterSetGetpannel]
       });
   });
   
   
   
   
   </script>
  </body>
</html>
