<%@ page language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
	LoginInfoBean loginInfo1=new LoginInfoBean();
	loginInfo1=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	if(loginInfo1!=null)
	{
	int mapType=loginInfo1.getMapType();
	loginInfo.setMapType(mapType);
	}
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
	if(str.length>9){
	loginInfo.setCategoryType(str[9].trim());
	}
	if(str.length>10){
	loginInfo.setUserName(str[10].trim());
	loginInfo.setStyleSheetOverride(str[11].trim());
	loginInfo.setIsLtsp(Integer.parseInt(str[12].trim()));
	}
	session.setAttribute("loginInfoDetails",loginInfo);
}
CommonFunctions cf=new CommonFunctions();
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language = loginInfo.getLanguage();
	int systemId = loginInfo.getSystemId();
	int customerId = loginInfo.getCustomerId();
	int userId = loginInfo.getUserId();
	String customerName = loginInfo.getCustomerName();
String userAuthority=cf.getUserAuthority(systemId,userId);
if(loginInfo==null){
	response.sendRedirect(request.getContextPath()+ "/Jsps/Common/SessionDestroy.html");
}
else if(loginInfo.getCustomerId()>0 && loginInfo.getIsLtsp() == -1 && (!userAuthority.equalsIgnoreCase("Admin"))) 
{
	response.sendRedirect(path + "/Jsps/Common/401Error.html");
}
else
{
session.setAttribute("loginInfoDetails",loginInfo);
    
	ArrayList<String> tobeConverted = new ArrayList<String>();
  tobeConverted.add("Status");
  tobeConverted.add("Select_Status");
  tobeConverted.add("Save");
  tobeConverted.add("Cancel");
  tobeConverted.add("Select_Single_Row");
  tobeConverted.add("No_Rows_Selected");
  tobeConverted.add("Modify");
  tobeConverted.add("Are_you_sure_you_want_to_delete");
  tobeConverted.add("SLNO");
  tobeConverted.add("No_Records_Found");
  tobeConverted.add("Add");
  tobeConverted.add("Delete");
  
  tobeConverted.add("Validity_Start_Date");
  tobeConverted.add("Validity_End_Date");
  tobeConverted.add("Enter_Validity_Start_Date");
  tobeConverted.add("Enter_Validity_End_Date");
  tobeConverted.add("End_Date_Must_Be_Greater_Than_Start_Date");
  tobeConverted.add("Remarks");
  tobeConverted.add("Valid_Status");
  tobeConverted.add("Get_Standard_Format");
  tobeConverted.add("Close");
  tobeConverted.add("Clear");
  tobeConverted.add("Month_Validation");
  
ArrayList<String> convertedWords = new ArrayList<String>();
convertedWords = cf.getLanguageSpecificWordForKey(tobeConverted,language);
 
String Status = convertedWords.get(0);
String SelectStatus=convertedWords.get(1);
String Save = convertedWords.get(2);
String Cancel = convertedWords.get(3);
String selectSingleRow = convertedWords.get(4); 
String noRowsSelected = convertedWords.get(5);
String Modify = convertedWords.get(6); 
String Areyousureyouwanttodelete = convertedWords.get(7); 
String SLNO = convertedWords.get(8);
String NoRecordsFound = convertedWords.get(9); 
String Add = convertedWords.get(10); 
String Delete = convertedWords.get(11); 
String ValidityStartDate=convertedWords.get(12);
String ValidityEndDate=convertedWords.get(13);
String EnterValidityStartDate=convertedWords.get(14);
String EnterValidityEndDate=convertedWords.get(15);
String EndDateMustBeGreaterthanStartDate=convertedWords.get(16);
String Remarks=convertedWords.get(17);
String ValidStatus=convertedWords.get(18);
String GetStandardFormat = convertedWords.get(19);
String Close = convertedWords.get(20);
String Clear = convertedWords.get(21);
String monthValidation=convertedWords.get(22);
%>

<jsp:include page="../Common/header.jsp" />
    <base href="<%=basePath%>">

    <title>
        ILMS Day Wise Data Capturing
    </title>
<style>
.x-panel-tl {
    border-bottom: 0px solid !important;
}
.x-form-file-wrap .x-form-file {
	position: absolute;
	right: 0;
	-moz-opacity: 0;
	filter:alpha(opacity: 0);
	opacity: 0;
	z-index: 2;
    height: 22px;
    cursor: pointer;
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

<%
	String ua = request.getHeader("User-Agent");
	boolean isMSIE10 = (ua != null && ua.indexOf("MSIE 10") != -1);
	boolean isMSIE9 = (ua != null && ua.indexOf("MSIE 9") != -1);
	boolean isMSIE8 = (ua != null && ua.indexOf("MSIE 8") != -1);
	if(isMSIE10 || isMSIE9 || isMSIE8){
%>
#ext-gen127{
width:70px;
}
<%}else{%>
#ext-gen126{
width:70px;
}
<%}%>
.x-form-field-wrap{
 height: 35px;
}
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
.x-form-file-wrap .x-form-file {
height:35px;
}
#filePath{
height:30px;
}
<%}%>
</style>

  <%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
	<jsp:include page="../Common/ImportJSSandMining.jsp"/>
	<%}else {%>
	<jsp:include page="../Common/ImportJS.jsp" /><%} %>
     <!-- for exporting to excel***** -->
   <jsp:include page="../Common/ExportJS.jsp" />
		<style>
			.x-panel-header
			{
				height: 7% !important;
			}		
			.x-grid3-cell-inner,.ext-strict .x-grid3-hd-inner {
				height: 26px !important;
				padding-top: 8px;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
			}
			label {
				display : inline !important;
			}
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-menu-list {
				height: auto !important;
			}
			.x-layer ul {
				//min-height: 27px !important;
			}
		</style>
<script>
 Ext.Ajax.timeout = 360000;
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
var jspName = "ILMSDayWiseDataCapturing";
var exportDataType = "int,date,int,int,int,int";
var exportDatainnerGrid = "int,date,String,int,String,String,String,String,date,date,date,String"; 
var innerGridjspName = "ILMSDayWiseDataCapturingInnerGrid";
var selected;
var grid;
var buttonValue;
var dtprev = dateprev;
var dtcur = datecur;
var innergrid;
var customerName = "<%=customerName%>";
var isWindow = false;

var dateFormatestore = new Ext.data.SimpleStore({
    id: 'dateFormateStoreId',
    autoLoad: true,
    fields: ['Name', 'Value'],
    data: [
        ['dd/MM/yyyy hh:mm', '1'],
        ['MM/dd/yyyy hh:mm', '2']
    ]
});

var dateFormateCombo=new Ext.form.ComboBox({
				  fieldLabel : 'Date Format',
				  store: dateFormatestore,
				  id:'dateFormatecomboid',
				  forceSelection:true,
				  emptyText:'Select date format',
				  anyMatch:true,
	              onTypeAhead:true,
				  enableKeyEvents:true,
				  mode: 'local',
				  triggerAction: 'all',
				  displayField: 'Name',
				  valueField: 'Value',
				  cls: 'selectstylePerfect',
				  value:'1',
				  listeners: {
		                select: {
		                 	 fn:function(){

	                 		     }
		                	} // END OF SELECT
		               } // END OF LISTENERS 
	   
	       });

//********* innerPanel ********		
	var innerPanel = new Ext.Panel({
        standardSubmit: true,
        collapsible: false,
        id: 'fuelMaster',
        layout: 'table',
        frame: true,
        layoutConfig: {
            columns: 15
        },
        items: [{width:30},
			    {
			    xtype: 'label',
			    text : 'From Date' + ' :',
			    cls: 'labelstyle',
			    id: 'startdatelab',
			    width:60
			    },{width:10},
			    {
  		            xtype: 'datefield',
  		            cls: 'selectstylePerfect',
  		            width: 185,
  		            format: getDateFormat(),
  		            emptyText: 'Select Date',
  		            allowBlank: false,
  		            blankText: 'Select Date',
  		            id: 'startdate',
  		            vtype: 'daterange'
  		        },{width:85},
			    {
			    xtype: 'label',
			    text : 'To Date' + ':',
			    cls: 'labelstyle',
			    id: 'enddatelab',
			    width:60
			    },{width:10},
			    {
  		            xtype: 'datefield',
  		            cls: 'selectstylePerfect',
  		            width: 185,
  		            format: getDateFormat(),
  		            emptyText: 'Select Date',
  		            allowBlank: false,
  		            blankText: 'Select Date',
  		            id: 'enddate',
  		            vtype: 'daterange'
  		        },{width:95},
			    { 
			    	xtype:'button',
			    	text:'View',
			    	id: 'addbuttonid',
			    	width:80,
			    	hidden:false,
			    	listeners: 
	       			{
		        		click:
		        		{
			       			fn:function()
			       			{
				   			 	
							    if(Ext.getCmp('startdate').getValue() == "" )
							    {
						             Ext.example.msg("Select Start Date");
						             Ext.getCmp('startdate').focus();
				                     return;
							    }
							    if(Ext.getCmp('enddate').getValue() == "" )
							    {
						             Ext.example.msg("Select End Date");
						             Ext.getCmp('enddate').focus();
				                     return;
							    }
							    
							    var startdates=Ext.getCmp('startdate').getValue();
            		 			var enddates=Ext.getCmp('enddate').getValue();
            		 			
            		 			var d1 = new Date(startdates);
            		 			var d2 = new Date(enddates);
            		 			
               		 			if(d1>d2)
            		 			{
										Ext.example.msg("<%=EndDateMustBeGreaterthanStartDate%>");
										return;
								}	
								
								if (checkMonthValidation(startdates, enddates)) {
  		                           Ext.example.msg("<%=monthValidation%>");
  		                           Ext.getCmp('enddate').focus();
  		                           return;
  		                        }
  		                        store.load({
		                    	params: {
		                    		jspName : jspName,
		                    		customerName : customerName,
		                    		startDate : startdates,
		                    		endDate : enddates
		                    		}
	                			});
  		                        
			       			}
	       				}
       				}
			    }	
        	]
   		 }); // End of innerPanel 


function clearInputData() {
    importgrid.store.clearData();
    importgrid.view.refresh();
}

function importExcelData() {
    importButton = "import";
    importTitle = 'ILMS Day Wise Data Import Details';
    importWin.show();
    isWindow = true;
    importWin.setTitle(importTitle);
}

var fp = new Ext.FormPanel({

    fileUpload: true,
    width: '100%',
    frame: true,
    autoHeight: true,
    standardSubmit: false,
    labelWidth: 90,
   // defaults: {
   //     anchor: '50%',
   //     allowBlank: false,
   //     msgTarget: 'side'
   // },
    items: [
		   {
            xtype: 'datefield',
            fieldLabel : 'From Date',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            emptyText: 'Select Date',
            allowBlank: false,
            blankText: 'Select Date',
            id: 'excelFromdateId',
            vtype: 'daterange',
            maxValue:dtcur
          },
          {
            xtype: 'datefield',
            fieldLabel : 'To Date',
            cls: 'selectstylePerfect',
            format: getDateFormat(),
            emptyText: 'Select Date',
            allowBlank: false,
            blankText: 'Select Date',
            id: 'excelTodateId',
            vtype: 'daterange',
            maxValue:dtcur
          }, dateFormateCombo,
          {
	        xtype: 'fileuploadfield',
	        id: 'filePath',
	        width: 400,
	        emptyText: 'Browse',
	        fieldLabel: 'Choose File',
	        name: 'filePath',
	        buttonText: 'Browse',
	        buttonCfg: {
		        iconCls: 'browsebutton'
         },
         listeners: {

            fileselected: {
                fn: function () {
                
                    var filePath = document.getElementById('filePath').value;
                    var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                    if (imgext == "xls" || imgext == "xlsx") {

                    } else {
                        Ext.MessageBox.show({
                            msg: 'Please select only .xls or .xlsx files',
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
        iconCls : 'uploadbutton',
        handler: function () {
            if (fp.getForm().isValid()) {
            if(Ext.getCmp('excelFromdateId').getValue() == "" )
			    {
		             Ext.example.msg("Select Date");
		             Ext.getCmp('excelFromdateId').focus();
                     return;
			    }
			if(Ext.getCmp('excelTodateId').getValue() == "" )
			    {
		             Ext.example.msg("Select Date");
		             Ext.getCmp('excelTodateId').focus();
                     return;
			    }
            if(Ext.getCmp('dateFormatecomboid').getValue() == "" )
			    {
		             Ext.example.msg("Select Date Format");
		             Ext.getCmp('dateFormatecomboid').focus();
                     return;
			    }
                var filePath = document.getElementById('filePath').value;

                var imgext = filePath.substring(filePath.lastIndexOf(".") + 1, filePath.length);
                if (imgext == "xls" || imgext == "xlsx") {
					clearInputData();
                } else {
                    Ext.MessageBox.show({
                        msg: 'Please select only .xls or .xlsx files',
                        buttons: Ext.MessageBox.OK
                    });
                    Ext.getCmp('filePath').setValue("");
                    return;
                }
                fp.getForm().submit({
                    url: "<%=request.getContextPath()%>/ILMSDayWiseDataCapturingAction.do?param=importILMSDetailsExcel&fromDate="+Ext.getCmp('excelFromdateId').getValue().format('d-m-Y')+"&toDate="+Ext.getCmp('excelTodateId').getValue().format('d-m-Y')+"&dateFormate="+Ext.getCmp('dateFormatecomboid').getValue(),
                    enctype: 'multipart/form-data',
                    waitMsg: 'Uploading your file...',
                    success: function (response, action) {
						
						Ext.Ajax.request({
                        url: '<%=request.getContextPath()%>/ILMSDayWiseDataCapturingAction.do?param=getImportILMSDetails',
                        method: 'POST',
                        params: {
                            ilmsImportResponse: action.response.responseText
                        },
                        success: function (response, options) {
                            ilmsResponseImportData  = Ext.util.JSON.decode(response.responseText);
                            importstore.loadData(ilmsResponseImportData);
                            
                        },
                        failure: function () {
                        Ext.example.msg("Error");
                        }
                    });
                        
                    },
                    failure: function () {
                    Ext.example.msg("Please Upload The Standard Format");
                    }
                });
            }
        }
    }, {
		text: '<%=GetStandardFormat%>',
		iconCls : 'downloadbutton',
	    handler : function(){
	    Ext.getCmp('filePath').setValue("Upload the Standard Format");
	    fp.getForm().submit({
	    	url:'<%=request.getContextPath()%>/ILMSDayWiseDataCapturingAction.do?param=openStandardFileFormats'
	    	});
		}	   
	}]
});

function closeImportWin(){	
	if(isWindow){
	fp.getForm().reset();
	importWin.hide();
	clearInputData();
	isWindow=false;
	 }else{
	myWin.hide();
	}	
}

function saveDate(){

var ValidCount = 0;
var totalcount = importstore.data.length;
    for (var i = 0; i < importstore.data.length; i++) {
        var record = importstore.getAt(i);
        var checkvalidOrInvalid = record.data['importstatusindex'];
        if (checkvalidOrInvalid == 'Valid') {
            ValidCount++;
        }
    }
    
	var saveJson = getJsonOfStore(importstore);
	
Ext.Msg.show({
        title: 'Saving..',
		width : 490,
        msg: 'We have ' + ValidCount + ' valid transaction to be saved out of ' + totalcount + ' .Do you want to continue?',
        buttons: Ext.Msg.YESNO,
        fn: function (btn) {
            if (btn == 'no') {
                return;
            }
            if (btn == 'yes') {
		if (saveJson != '[]' && ValidCount>0) {
         Ext.Ajax.request({
               url: '<%=request.getContextPath()%>/ILMSDayWiseDataCapturingAction.do?param=saveImportIlmsDetails',
               method: 'POST',
               params: {
                            ilmsDataSaveParam: saveJson
               },
               success: function (response, options) {
               			var message = response.responseText;
               			Ext.example.msg(message);
               			store.load({
		                    	params: {
		                    		jspName : jspName,
		                    		customerName : customerName,
		                    		startDate : startdates,
		                    		endDate : enddates
		                    		}
	                			});
               },
               failure: function () {
               Ext.example.msg("Error");
                        }
               });
               clearInputData();
               fp.getForm().reset();
               importWin.hide();
           }else{
           Ext.MessageBox.show({
                        msg: "You don't have any Valid Information to Proceed",
                        buttons: Ext.MessageBox.OK
                    });
           }
         }
       }
     });
}
function getJsonOfStore(importstore) {
    var datar = new Array();
    var jsonDataEncode = "";
    var recordss = importstore.getRange();
    for (var i = 0; i < recordss.length; i++) {
        datar.push(recordss[i].data);
    }
    jsonDataEncode = Ext.util.JSON.encode(datar);

    return jsonDataEncode;
}

var importreader = new Ext.data.JsonReader({
    root: 'ILMSDetailsImportRoot',
    totalProperty: 'total',
    fields: [{
        name: 'importslnoIndex'
    }, {
        name: 'importMMPSIdindex'
    }, {
        name: 'importMMPSCodeindex'
    },{
        name: 'importPermitNoindex'
    }, {
        name: 'importVehicleNoindex'
    }, {
        name: 'importPassIssueDateindex'
    }, {
        name: 'importJourneyStartDateindex'
    }, {
        name: 'importJourneyEndDateindex'
    }, {
        name: 'importstatusindex'
    },{
        name: 'importremarksindex'
    }]
});

var importstore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ILMSDayWiseDataCapturingAction.do?param=getImportILMSDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,
    reader: importreader
});
//****************************grid filters************//
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            type: 'numeric',
            dataIndex: 'importslnoIndex'
        }, {
            type: 'numeric',
            dataIndex: 'importMMPSIdindex'
        }, {
            dataIndex: 'importMMPSCodeindex',
            type: 'String'
        }, {
            dataIndex: 'importPermitNoindex',
            type: 'string'
        },{
            dataIndex: 'importVehicleNoindex',
            type: 'string'
        }, {
            dataIndex: 'importPassIssueDateindex',
            type: 'date'
        }, {
            dataIndex: 'importJourneyStartDateindex',
            type: 'date'
        },{
            dataIndex: 'importJourneyEndDateindex',
            type: 'date'
        },{
            dataIndex: 'importstatusindex',
            type: 'string'
        }, {
            dataIndex: 'importremarksindex',
            type: 'string'
        }

    ]
});
//****************column Model Config***************//
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            dataIndex: 'importslnoIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>MMPS Trip Sheet Id</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importMMPSIdindex'
        }, {
            header: "<span style=font-weight:bold;>MMPS Trip Sheet Code</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importMMPSCodeindex'
        }, {
            header: "<span style=font-weight:bold;>Permit No.</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importPermitNoindex'
        },{
            header: "<span style=font-weight:bold;>Vehicle No</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importVehicleNoindex'
        }, {
            header: "<span style=font-weight:bold;>Pass Issue Date/Time</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'importPassIssueDateindex',
             filter: {
                type: 'date'
            }
        }, {
            header: "<span style=font-weight:bold;>Journey Start Date/Time</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importJourneyStartDateindex',
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Journey End Date/Time</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'importJourneyEndDateindex',
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;><%=ValidStatus%></span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'importstatusindex',
            renderer: checkValid,
            filter: {
                type: 'String'
            }

        },{
            header: "<span style=font-weight:bold;><%=Remarks%></span>",
            hidden: false,
            width: 300,
            sortable: true,
            dataIndex: 'importremarksindex',
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


function checkValid(val) {
    if (val == "Invalid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/No.png">';
    } else if (val == "Valid") {
        return '<img src="/ApplicationImages/ApplicationButtonIcons/Yes.png">';
    }
}
//*******************************grid**************************//
importgrid = getGrid('', '<%=NoRecordsFound%>', importstore, 885, 298, 20, filters,'', false, '', 20, false, '', false, '', false, 'Excel', jspName, exportDataType, false, 'PDF', false, '<%=Add%>', false, '<%=Modify%>', false, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',false,'',true,'<%=Save%>',true,'<%=Clear%>',true,'<%=Close%>');	

//end grid

var importPanelWindow = new Ext.Panel({
    cls: 'outerpanelwindow',
    frame: false,
    layout: 'column',
    layoutConfig: {
        columns: 1
    },
    items: [fp,importgrid]
});

importWin = new Ext.Window({
    title: 'ILMS Import Details',
    width: 1200,
    height:900,
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    id: 'importWin',
    items: [importPanelWindow]
});
<%if (loginInfo.getStyleSheetOverride().equals("Y")){%>
 importWin.setHeight(505);
importWin.setWidth(900);
<%}%>


//***************************jsonreader************//
var reader = new Ext.data.JsonReader({
    root: 'ilmsdataRoot',   
    fields: [{
        name: 'slnoIndex'
    }, {
        name: 'dateOfUploadIndex'
    }, {
        name: 'TotalILMSIndex'
    }, {
        name: 'GPScommunicatingIndex'
    }, {
        name: 'GPSnonCommunicationIndex'
    }, {
        name: 'VehicleNotmatchedIndex'
    }]

});


//************************* store configs***************************//

var store = new Ext.data.GroupingStore({
    autoLoad:false,
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ILMSDayWiseDataCapturingAction.do?param=getIlmsCountData',
        method: 'POST'
    }),
    reader: reader
});
//****************************grid filters**********************//
var filters = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
        type: 'numeric',
        dataIndex: 'slnoIndex'
    }, {
        dataIndex: 'dateOfUploadIndex',
        type: 'date'
    }, {
        dataIndex: 'TotalILMSIndex',
        type: 'numeric'
    }, {
        dataIndex: 'GPScommunicatingIndex',
        type: 'numeric'
    }, {
        dataIndex: 'GPSnonCommunicationIndex',
        type: 'numeric'
    }, {
        dataIndex: 'VehicleNotmatchedIndex',
        type: 'numeric'
    }]
});

//****************column Model Config**********************//
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 60
        }), {           
            hidden: true,           
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 100,
            dataIndex: 'slnoIndex',
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Date of upload</span>",
            hidden: false,
            //width: 100,
            sortable: false,
            dataIndex: 'dateOfUploadIndex',
            renderer: Ext.util.Format.dateRenderer(getDateFormat()),
            filter: {
                type: 'Date'
            }
        }, {
            header: "<span style=font-weight:bold;>Total ILMS passes issued (as per upload data)</span>",
            hidden: false,
            //width: 100,
            sortable: true,
            dataIndex: 'TotalILMSIndex',
            filter: {
                type: 'numeric'
            }
        }, {
            header: "<span style=font-weight:bold;>Passes issued for GPS communicating vehicle</span>",
            hidden: false,
            width: 120,
            //sortable: true,
            dataIndex: 'GPScommunicatingIndex',
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Passes issued for GPS Non-communicating vehicle</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'GPSnonCommunicationIndex',
            filter: {
                type: 'numeric'
            }
        },  {
            header: "<span style=font-weight:bold;>Vehicle number not matched or vehicle not registered </span>",
            hidden: false,
            width: 150,
            dataIndex: 'VehicleNotmatchedIndex',
            filter: {
                type: 'numeric'
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

//********************************grid***************************//
grid = getGrid('', '<%=NoRecordsFound%>', store, screen.width - 40, 430, 20, filters,'', false, '', 20, false, '', false, '', true, 'Excel', jspName, exportDataType, true, 'PDF', false, '<%=Add%>', false, '<%=Modify%>', false, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',true,'New ILMS Upload');
grid.on({
  cellclick: {
      fn: function (grid, rowIndex, columnIndex, e) {
      			
      }
  	},
    celldblclick: {
                    fn: function (grid, rowIndex, columnIndex, e) {
                    
                     approveApplication();
                    }
                  }            
            });
   

 /********for inner grid*******/
var innerGridreader = new Ext.data.JsonReader({
    root: 'ILMSDetailsInnergridRoot',
    totalProperty: 'total',
    fields: [{
        name: 'grid2slnoIndex'
    }, {
        name: 'dateofuploadIndex'
    }, {
        name: 'VehicleNoindex'
    },{
        name: 'mmpstripsheetIdIndex'
    },{
        name: 'mmpstripsheetCodeIndex'
    }, {
        name: 'permitNoIndex'
    }, {
        name: 'leaseCodeIndex'
    }, {
        name: 'miningplaceIndex'
    }, {
        name: 'passIssueDateindex'
    }, {
        name: 'journeyStartDateindex'
    }, {
        name: 'journeyEndDateindex'
    }, {
        name: 'vehicleStatusIndex'
    }]
});

/**********Inner grid store************/
var innergridstore = new Ext.data.GroupingStore({
    proxy: new Ext.data.HttpProxy({
        url: '<%=request.getContextPath()%>/ILMSDayWiseDataCapturingAction.do?param=getInnerGridILMSDetails',
        method: 'POST'
    }),
    remoteSort: false,
    bufferSize: 700,
    autoLoad: false,
    reader: innerGridreader
});         
//****************************grid filters******************//
var filtersInnerGrid = new Ext.ux.grid.GridFilters({
    local: true,
    filters: [{
            type: 'numeric',
            dataIndex: 'grid2slnoIndex'
        }, {
            dataIndex: 'dateofuploadIndex',
            type: 'date'
        }, {
            dataIndex: 'VehicleNoindex',
            type: 'string'
        }, {
            type: 'numeric',
            dataIndex: 'mmpstripsheetIdIndex'
        }, {
            dataIndex: 'mmpstripsheetCodeIndex',
            type: 'String'
        }, {
            dataIndex: 'permitNoIndex',
            type: 'string'
        }, {
            dataIndex: 'leaseCodeIndex',
            type: 'string'
        }, {
            dataIndex: 'miningplaceIndex',
            type: 'string'
        }, {
            dataIndex: 'passIssueDateindex',
            type: 'date'
        }, {
            dataIndex: 'journeyStartDateindex',
            type: 'date'
        }, {
            dataIndex: 'journeyEndDateindex',
            type: 'date'
        },{
            dataIndex: 'vehicleStatusIndex',
            type: 'string'
        }
    ]
});
 //****************Inner grid column Model Config****************
var createColModel = function (finish, start) {
    var columns = [
        new Ext.grid.RowNumberer({
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            width: 50
        }), {
            header: "<span style=font-weight:bold;><%=SLNO%></span>",
            dataIndex: 'grid2slnoIndex',
            hidden: true,
            width: 100,
            filter: {
                type: 'numeric'
            }
        },{
            header: "<span style=font-weight:bold;>Date of upload</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'dateofuploadIndex'
        },{
            header: "<span style=font-weight:bold;>Vehicle Number</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'VehicleNoindex'
        }, {
            header: "<span style=font-weight:bold;>MMPS Trip Sheet Id</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'mmpstripsheetIdIndex'
        }, {
            header: "<span style=font-weight:bold;>MMPS Trip Sheet Code</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'mmpstripsheetCodeIndex'
        },{
            header: "<span style=font-weight:bold;>Permit No.</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'permitNoIndex'
        },{
            header: "<span style=font-weight:bold;>Lease Code</span>",
            hidden: false,
            width: 100,
            sortable: true,
            dataIndex: 'leaseCodeIndex'
        },{
            header: "<span style=font-weight:bold;>Mining place_E</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'miningplaceIndex'
        },{
            header: "<span style=font-weight:bold;>Pass Issue Date</span>",
            hidden: false,
            width: 120,
            sortable: true,
            dataIndex: 'passIssueDateindex',
             filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Journey Start Date</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'journeyStartDateindex',
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Journey End Date</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'journeyEndDateindex',
            filter: {
                type: 'date'
            }
        },{
            header: "<span style=font-weight:bold;>Vehicle Status</span>",
            hidden: false,
            width: 150,
            sortable: true,
            dataIndex: 'vehicleStatusIndex'
        }
    ];
    return new Ext.grid.ColumnModel({
        columns: columns.slice(start || 0, finish),
        defaults: {
            sortable: true
        }
    });
};
 /***************innergrid****************************/
innergrid = getGrid1('', '<%=NoRecordsFound%>', innergridstore, screen.width - 45, 400, 20, filtersInnerGrid,'', false, '', 20, false, '', false, '', true, 'Excel', innerGridjspName, exportDatainnerGrid, true, 'PDF', false, '<%=Add%>', false, '<%=Modify%>', false, '<%=Delete%>',false,'',false,'',false,'',false,'',false,'',false,'',false,'<%=Save%>',false,'<%=Clear%>',true,'<%=Close%>');	
 
 /***********panel contains window content info***************************/

var outerPanelWindow = new Ext.Panel({ 
    standardSubmit: true,
    frame: false,
    items: [innergrid]
});
/***********************inner grid window for form field****************************/

var myWin = new Ext.Window({
    title: 'ILMS Details',
    closable: false,
    modal: true,
    resizable: false,
    autoScroll: false,
    width: screen.width - 40,
    cls: 'mywindow',
    id: 'myWin',
    items: [outerPanelWindow]
});
function approveApplication() {
 
		  if(grid.getSelectionModel().getCount()==0){
                Ext.example.msg("Please select one row");
  					return;
				}
		  if(grid.getSelectionModel().getCount()>1){
                  Ext.example.msg("Please select one row");
 					return;
 			}		
 		var selected = grid.getSelectionModel().getSelected();
		var uploadedDate = selected.get('dateOfUploadIndex');
		
		myWin.show();  
		myWin.setPosition(20, 90);
		
		innergridstore.load({
	                    params: {
	                        uploadDate: uploadedDate,
	                        innerGridjspName : innerGridjspName,
	                        customerName : customerName,
	                    }
	                });
		}


//***********************main starts from here*************************************//
Ext.onReady(function () {
    ctsb = tsb;
    Ext.QuickTips.init();
    Ext.Ajax.timeout = 180000;
    Ext.form.Field.prototype.msgTarget = 'side';
    outerPanel = new Ext.Panel({
        title: 'ILMS Day Wise Data Capturing',
        renderTo: 'content',
        standardSubmit: true,
        autoScroll: false,
        frame: true,
        border: false,
        layout: 'table',
        cls: 'outerpanel',
        layoutConfig: {
            columns: 1
        },
        items: [innerPanel,grid]
        //bbar: ctsb
    });
    
});
</script>
    
 <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->
<%}%>