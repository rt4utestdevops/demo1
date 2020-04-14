<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*,java.text.SimpleDateFormat" pageEncoding="utf-8"%>
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
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
//getting language
String language=loginInfo.getLanguage();
boolean isLtsp=loginInfo.getIsLtsp()==0;
int systemid=loginInfo.getSystemId();
int userid=loginInfo.getUserId();
String systemID=Integer.toString(systemid);
//getting hashmap with language specific words
HashMap langConverted=ApplicationListener.langConverted;
LanguageWordsBean lwb=null;
int customeridlogged=loginInfo.getCustomerId();
//Getting words based on language 
String SelectCustomer;
lwb=(LanguageWordsBean)langConverted.get("Select_Customer");
if(language.equals("ar")){
	SelectCustomer=lwb.getArabicWord();
}else{
	SelectCustomer=lwb.getEnglishWord();
}
lwb=null;
String Non_Communication_Report;
lwb=(LanguageWordsBean)langConverted.get("Non_Communication_Report");
if(language.equals("ar")){
	Non_Communication_Report=lwb.getArabicWord();
}else{
	Non_Communication_Report=lwb.getEnglishWord();
}
lwb=null;
String NoRecordsFound;
lwb=(LanguageWordsBean)langConverted.get("No_Records_Found");
if(language.equals("ar")){
	NoRecordsFound=lwb.getArabicWord();
}else{
	NoRecordsFound=lwb.getEnglishWord();
}
lwb=null;
String CustomerName;
lwb=(LanguageWordsBean)langConverted.get("Customer_Name");
if(language.equals("ar")){
	CustomerName=lwb.getArabicWord();
}else{
	CustomerName=lwb.getEnglishWord();
}
lwb=null;
String SLNO;
lwb=(LanguageWordsBean)langConverted.get("SLNO");
if(language.equals("ar")){
	SLNO=lwb.getArabicWord();
}else{
	SLNO=lwb.getEnglishWord();
}
lwb=null;
String Non_Communicating_MoreThen24Hrs;
lwb=(LanguageWordsBean)langConverted.get("Non_Communicating_Greater_Than_24Hrs");
if(language.equals("ar")){
	Non_Communicating_MoreThen24Hrs=lwb.getArabicWord();
}else{
	Non_Communicating_MoreThen24Hrs=lwb.getEnglishWord();
}
lwb=null;
String Non_Comm_Assets;
lwb=(LanguageWordsBean)langConverted.get("Non_Communicating_Assets");
if(language.equals("ar")){
	Non_Comm_Assets=lwb.getArabicWord();
}else{
	Non_Comm_Assets=lwb.getEnglishWord();
}
lwb=null;
String Last_Location;
lwb=(LanguageWordsBean)langConverted.get("Last_Location");
if(language.equals("ar")){
	Last_Location=lwb.getArabicWord();
}else{
	Last_Location=lwb.getEnglishWord();
}
lwb=null;
String LastCommunicatingDate;
lwb=(LanguageWordsBean)langConverted.get("Last_Communicated_Date_Time");
if(language.equals("ar")){
	LastCommunicatingDate=lwb.getArabicWord();
}else{
	LastCommunicatingDate=lwb.getEnglishWord();
}
lwb=null;
String OwnerName;
lwb=(LanguageWordsBean)langConverted.get("Owner_Name");
if(language.equals("ar")){
	OwnerName=lwb.getArabicWord();
}else{
	OwnerName=lwb.getEnglishWord();
}
lwb=null;
String ContactNumber;
lwb=(LanguageWordsBean)langConverted.get("Contact_Number");
if(language.equals("ar")){
	ContactNumber=lwb.getArabicWord();
}else{
	ContactNumber=lwb.getEnglishWord();
}
lwb=null;
String Submit;
lwb=(LanguageWordsBean)langConverted.get("Submit");
if(language.equals("ar")){
	Submit=lwb.getArabicWord();
}else{
	Submit=lwb.getEnglishWord();
}
lwb=null;

String ClearFilterData;
lwb=(LanguageWordsBean)langConverted.get("Clear_Filter_Data");
if(language.equals("ar")){
	ClearFilterData=lwb.getArabicWord();
}else{
	ClearFilterData=lwb.getEnglishWord();
}
lwb=null;
String ReconfigureGrid;
lwb=(LanguageWordsBean)langConverted.get("Reconfigure_Grid");
if(language.equals("ar")){
	ReconfigureGrid=lwb.getArabicWord();
}else{
	ReconfigureGrid=lwb.getEnglishWord();
}
lwb=null;
String ClearGrouping;
lwb=(LanguageWordsBean)langConverted.get("Clear_Grouping");
if(language.equals("ar")){
	ClearGrouping=lwb.getArabicWord();
}else{
	ClearGrouping=lwb.getEnglishWord();
}
lwb=null;
String Excel=cf.getLabelFromDB("Excel",language);
String userAuthority=cf.getUserAuthority(systemid,userid);
if(!userAuthority.equalsIgnoreCase("admin") || !isLtsp)
{
response.sendRedirect(request.getContextPath()
				+ "/Jsps/Common/401Error.html");
}
%>
<jsp:include page="../Common/header.jsp" />
        <title>
            <%=Non_Communication_Report%>
        </title>
         
    <div height="100%"">
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
         <!-- for exporting to excel***** -->
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
			}
			.x-panel-body-noborder {
				height : 347px !important;
			}
			.x-layer ul {
				min-height: 27px !important;
			}
			</style>
		<%}%>
		<style>
			.x-panel-body-noborder {
				height : 366px !important;
			}
		</style>
<script>
var outerPanel;
var jspName = "NonCommunicatingVehiclesReport";
var dtcur = datecur;
var dtprev = dateprev;
var datenxt=datenext;
var startdatepassed;
var enddatepassed;
var exportDataType = "int,string,string,string,int";
  //******************************Store for getting customer name************************
            var custmastcombostore = new Ext.data.JsonStore({
                url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
                id: 'CustomerStoreId',
                root: 'CustomerRoot',
                autoLoad: true,
                remoteSort: true,
                fields: ['CustId', 'CustName'],
                listeners: {
                    load: function (custstore, records, success, options) {
                        if ( <%= customeridlogged %> > 0) {
                            Ext.getCmp('custmastcomboId').setValue('<%=customeridlogged%>');
                        }
                    }
                }
            });
               //**************************** Combo for Client Name***************************************************
            var clientnamecombo = new Ext.form.ComboBox({
                store: custmastcombostore,
                id: 'custmastcomboId',
                mode: 'local',
                forceSelection: true,
                emptyText: '<%=SelectCustomer%>',
                blankText: '<%=SelectCustomer%>',
                selectOnFocus: true,
                allowBlank: false,
                typeAhead: true,
                triggerAction: 'all',
                lazyRender: true,
                valueField: 'CustId',
                displayField: 'CustName',
                cls: 'selectstylePerfect',
                listeners: {
        		select: {
            	fn: function() {
                custId = Ext.getCmp('custmastcomboId').getValue();
                custName=Ext.getCmp('custmastcomboId').getRawValue();
            	}
        		}
    			}
            });
              //********************************* Reader Config***********************************
            var reader = new Ext.data.JsonReader({
                idProperty: 'gridrootid',
                root: 'GridRoot',
                totalProperty: 'total',
                fields: [{
                        name: 'slnoIndex'
                    },{
                        name: 'vehnoIndex'
                    }, {
                        name: 'startnoncomdatetime'
                    }, {
                        name: 'stopnoncomdatetime'
                    }, {
                        name: 'noncommHrs'
                    }
                ]
            });
            
          	var store = new Ext.data.GroupingStore({
                autoLoad: false,
                proxy: new Ext.data.HttpProxy({
                    url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getGridNonCommunicatingVehData',
                    method: 'POST'
                }),
                remoteSort: false,
                storeId: 'gridStore',
                reader: reader
            });
            
            var filters = new Ext.ux.grid.GridFilters({
                local: true,
                filters: [{
                        type: 'numeric',
                        dataIndex: 'slnoIndex'
                    },{
                        dataIndex: 'vehnoIndex',
                        type: 'string'
                    }, {
                        type: 'date',
                        dataIndex: 'startnoncomdatetime'
                    }, {
                        type: 'date',
                        dataIndex: 'stopnoncomdatetime'
                    }, {
                        type: 'numeric',
                        dataIndex: 'noncommHrs'
                    }
                    
                ]
            });
            
             //**************************** Grid Pannel Config ******************************************

            var createColModel = function (finish, start) {
                var columns = [
                    new Ext.grid.RowNumberer({
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        width: 40
                    }),{
                        dataIndex: 'slnoIndex',
                        hidden: true,
                        header: "<span style=font-weight:bold;><%=SLNO%></span>",
                        filter: {
                            type: 'numeric'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>Vehicle/Boat RegistrationNo</span>",
                        dataIndex: 'vehnoIndex',
                        //width:40,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>Start of NonCommunication</span>",
                        dataIndex: 'startnoncomdatetime',
                        //width:70,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>End of NonCommunication</span>",
                        dataIndex: 'stopnoncomdatetime',
                        //width:40,
                        filter: {
                            type: 'string'
                        }
                    }, {
                        header: "<span style=font-weight:bold;>Non Communicating Mins</span>",
                        dataIndex: 'noncommHrs',
                        //width:30,
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
            
             //**************************** Grid Panel Config ends here**********************************
            var userGrid = getGrid('', '<%=NoRecordsFound%>', store, screen.width-35, 405, 7, filters,'<%=ClearFilterData%>', false, '', 10, false, '', false, '', true, '<%=Excel%>', jspName, exportDataType, false, '');

            userGrid.on({
                cellclick: {
                    fn: function (userGrid, rowIndex, columnIndex, e) {
                        

                    }
                }
            });
             //************************************* Inner panel start******************************************* 
            var innerPanel = new Ext.Panel({
            	frame: false,
            	height:40,
                id: 'custMaster',
                layout: 'table',
                layoutConfig: {
                    columns: 10
                },
                items: [{
                        xtype: 'label',
                        text: '<%=CustomerName%>' + '  :',
                        width : 90,
                        cls: 'labelstyle',
                        id: 'clientnamhidlab'
                    },
                    clientnamecombo,{width:10},{width:10},{
	        			xtype: 'label',
						text: 'Start Date :',
						width : 90,
						cls: 'labelstyle'
				     },{
                        xtype: 'datefield',
                        cls: 'selectstylePerfect',
                        format: getDateFormat(),
                        id:'startdate',
                    //  disabled:true,
                        emptyText: 'Select Date',
                        value: dtprev,
                        maxValue: dtcur,
                        vtype: 'daterange',
                        endDateField: 'enddate',
                        listeners: {
              			select: function(  ){
                    		startdatepassed=Ext.getCmp('startdate').getValue()
                		}
            			}
                    },{width:20},{
	        			xtype: 'label',
						text: 'End Date :',
						width : 90,
						cls: 'labelstyle'
				     },
                    {
                        xtype: 'datefield',
                        cls: 'selectstylePerfect',
                        format: getDateFormat(),
                        emptyText: 'Select Date',
                    //  disabled:true,
                        id: 'enddate',
                        value: dtcur,
                        maxValue: datenxt,
                        vtype: 'daterange',
                        startDateField: 'startdate',
                        listeners: {
              			select: function(  ){
                    		enddatepassed=Ext.getCmp('enddate').getValue()
                		}
            			}
                    },{width:25}
                ]
            }); // End of Panel	
            
            var submitButton = new Ext.Button({
            text: 'View',
            cls: 'sandreportbutton',
            handler: function ()
            {
                   startdatepassed=Ext.getCmp('startdate').getValue();
                   enddatepassed=Ext.getCmp('enddate').getValue();
                   custId = Ext.getCmp('custmastcomboId').getValue();
                   
                    if (Ext.getCmp('custmastcomboId').getValue() == "") {
                        Ext.example.msg("Select Customer");
                        return;
                    }
                    if (Ext.getCmp('startdate').getValue() == "") {
                        Ext.example.msg("Select Start date");
                        return;
                    }
                    if (Ext.getCmp('enddate').getValue() == "") {
                        Ext.example.msg("Select end date");
                        return;
                    }
                   //alert(startdatepassed);
					store.load({
                                params: {
                                    custID: Ext.getCmp('custmastcomboId').getValue(),
                                    jspName:jspName,
                                    startdate:startdatepassed,
							   		enddate:enddatepassed
                                		}
                            });
            }
        });
        
         var buttonPanel = new Ext.Panel({
            frame: false,
            layout: 'column',
            layoutConfig: {
                columns: 2
            },
            items: [{width:100},submitButton]
        });
        
        var durartionPanel = new Ext.Panel({
            frame: false,
            height:40,
            layout: 'column',
    		layoutConfig: {
        				columns: 2
    		},
            items: [innerPanel,buttonPanel]
        });

        var mainPanel = new Ext.Panel({
            items: [durartionPanel]
        });
		
            //***************************  Main starts from here **************************************************
            Ext.onReady(function () {
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    title: '<%=Non_Communication_Report%>',
                    renderTo: 'content',
                    standardSubmit: true,
                    autoHeight:true,
					frame: true,
                    cls: 'mainpanelpercentage',
                    items: [mainPanel,userGrid]
                });
            });
</script>
</div>
 <jsp:include page="../Common/footer.jsp" />

