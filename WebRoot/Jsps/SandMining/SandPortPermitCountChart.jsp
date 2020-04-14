<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
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
int customeridlogged=loginInfo.getCustomerId();
String language=loginInfo.getLanguage();
ArrayList<String> tobeConverted=new ArrayList<String>();
tobeConverted.add("Select_Division");
tobeConverted.add("Division");
tobeConverted.add("Sand_Port_Wise_Permit_Count");
tobeConverted.add("Custom_Date");
tobeConverted.add("Last_Week");
tobeConverted.add("Last_Month");
tobeConverted.add("Last_Year");
tobeConverted.add("Permit_Count");
tobeConverted.add("Permit");
tobeConverted.add("Sand_Port");
tobeConverted.add("Sand_Port_Wise_Count_Chart");
ArrayList<String> convertedWords=new ArrayList<String>();
convertedWords=cf.getLanguageSpecificWordForKey(tobeConverted,language);
String selectDivision=convertedWords.get(0);
String division=convertedWords.get(1);
String sand_port_wise_permit_count=convertedWords.get(2);
String custom_date=convertedWords.get(3);
String last_week=convertedWords.get(4);
String last_month=convertedWords.get(5);
String last_year=convertedWords.get(6);
String permit_count=convertedWords.get(7);
String permit=convertedWords.get(8);
String sandport=convertedWords.get(9);
String sandportchart=convertedWords.get(10);
%>

<jsp:include page="../Common/header.jsp" />

        <title>
		<%=sand_port_wise_permit_count%>
        </title>
    
    
    <div class="largebody">
        <jsp:include page="../Common/ImportJSSandMining.jsp" />
        <!-- for exporting to excel***** -->
        <jsp:include page="../Common/ExportJS.jsp" />
        <script type="text/javascript" src="../../Main/Js/jsapi.js"></script>
		<% String newMenuStyle=loginInfo.getNewMenuStyle();
		if(newMenuStyle.equalsIgnoreCase("YES")){%>
		<style>	
			.x-panel-header
			{
				height: 41% !important;
			}	
			
			label {
				display : inline !important;
			}			
			.ext-strict .x-form-text {
				height: 21px !important;
			}
			.x-window-tl *.x-window-header {
				padding-top : 6px !important;
				height : 38px !important;
			}			
		</style>
	 <%}%>
   		<script>
    	google.load("visualization", "1", {packages:["corechart"]});
            var outerPanel;
            var dtprev = dateprev;
            var dtcur = datecur;
            var state="";

	var barchartPannel = new Ext.Panel({
		standardSubmit: true,
		collapsible:false,
        border:false,
        frame:false,
		width:'100%',
		height:415,
		id:'barchartid',
		items: [
				{xtype:'panel',
				id:'barchartpiepannelid',
				border:false,
				html : '<table width="100%"><tr><tr> <td> <div id="visualization" align="left"> </div></td></tr></table>'
       			}			  							
			]
		});
var portWisePertCountStore=new Ext.data.JsonStore({
				url: '<%=request.getContextPath()%>/SandMiningAction.do?param=getSandPortWisePermitCount',
				id:'SandPortWisePermitCountId',
				root: 'SandPortWisePermitCountRoot',
				autoLoad: false,
				remoteSort: true,
				fields: ['port','count','groupname']
		});			
//******************************************** Statutory BarChart**********************************************************		
function sandPortChart() {
var loadMask = new Ext.LoadMask('outerpanelid', {msg:'Loading..'});
    portWisePertCountStore.load({
        params: {
            CustID:Ext.getCmp('custcomboId').getValue(),
            startdate:Ext.getCmp('startdate').getValue(),
            enddate:Ext.getCmp('enddate').getValue(),
        },
        callback: function () {
        var startdate=Ext.getCmp('startdate').getValue();
        var startdateformatted=startdate.format("d M Y");
        var enddate=Ext.getCmp('enddate').getValue();
        var enddateformatted=enddate.format("d M Y");
            var options = {
                title: '<%=sand_port_wise_permit_count%> from '+startdateformatted+' to '+enddateformatted,
                titleTextStyle: {
                    color: '#686262',
                    fontSize: 13
                },
                pieSliceText: "value",
                legend: {
                    position: 'none'
                },
                backgroundColor: '#E4E4E4',
                //colors: ['#4572A7', '#93A9CF'],
                sliceVisibilityThreshold: 0,
                height: 415,
                isStacked: true,
                hAxis:{title:'Sand Ports',textStyle:{fontSize: 10},titleTextStyle: { italic: false}},
                vAxis:{title:'Permit Count',titleTextStyle: { italic: false} }
            };
            var sandportgraph = new google.visualization.ColumnChart(document.getElementById('visualization'));
            var barchartdata = new google.visualization.DataTable();
            barchartdata.addColumn('string', 'Count');
            barchartdata.addColumn('number', 'Permit');
            //barchartdata.addColumn('number','');//Used for red bar
            barchartdata.addRows(portWisePertCountStore.getCount() + 1);
            var rowdata = new Array();
            // Below is the Model for rowdata
            //barchartdata.setCell(0, 0, 'Adyar Port');
            //barchartdata.setCell(0, 1, 100);
            //barchartdata.setCell(1, 0, 'Manglore Port');
            //barchartdata.setCell(1, 1, 25);
            //barchartdata.setCell(1, 0, 'Adayar Port');
            //barchartdata.setCell(1, 2, 25);
<!--            var tempgroupname='temp';-->
            for (i = 0; i < portWisePertCountStore.getCount(); i++) {
                var rec = portWisePertCountStore.getAt(i);
                rowdata.push(rec.data['port']);
                rowdata.push(parseInt(rec.data['count']));
            }
            var k = 0;
            var m=0;
            var n=0;
            for (i = 0; i < portWisePertCountStore.getCount(); i++) {
                for (j = 0; j <= 1; j++) {
                	var rec = portWisePertCountStore.getAt(i);
<!--                	if(j!=0)-->
<!--                	{-->
<!--                	if(tempgroupname!=rec.data['groupname'])-->
<!--                	{-->
<!--                	if(n==0||n==2)-->
<!--                	{-->
<!--                	m=1;-->
<!--                	n=m;-->
<!--                	}-->
<!--                	else-->
<!--                	{-->
<!--                	m=2;-->
<!--                	n=m;-->
<!--                	}-->
<!--                	tempgroupname=rec.data['groupname'];-->
<!--                	}-->
<!--                	barchartdata.setCell(i, m, rowdata[k]);-->
<!--                	}-->
<!--                	else-->
<!--                	{-->
                    barchartdata.setCell(i, j, rowdata[k]);
<!--                    }-->
                    k++;
                }
            }

            sandportgraph.draw(barchartdata, options);
			loadMask.hide();
        }
    });
}          

//****************************************Customer Name Store**************************
            var customercombostore = new Ext.data.JsonStore({
                url: '<%=request.getContextPath()%>/CommonAction.do?param=getCustomer',
                id: 'CustomerStoreId',
                root: 'CustomerRoot',
                autoLoad: true,
                remoteSort: true, 
                fields: ['CustId', 'CustName'],
                listeners: {
                    load: function (custstore, records, success, options) {
                        if ( <%= customeridlogged %> > 0) {
                            Ext.getCmp('custcomboId').setValue('<%=customeridlogged%>');
                        }
                    }
                }
            });
             //**************************************Customer Combo*************************************
            var custnamecombo = new Ext.form.ComboBox({
                store: customercombostore,
                id: 'custcomboId',
                mode: 'local',
                forceSelection: true,
                emptyText: '<%=division%>',
                selectOnFocus: true,
                allowBlank: false,
                anyMatch: true,
                typeAhead: false,
                triggerAction: 'all',
                lazyRender: true,
                resizable:true,
                valueField: 'CustId',
                displayField: 'CustName',
                cls: 'sandselectstyle',
                listeners: {
                    select: {
                        fn: function () {
                        }
                    }
                }
            });
            
var datePanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                border:false,
        		frame:false,
                //bodyCfg : { cls:'sandinnerpanelgridpercentage' , style: {'padding-top':'10px'} },
                id: 'datepannel',
                height:50,
                layout: 'column',
                layoutConfig: {
                    columns: 6
                },
                items: [
                	{
                        xtype: 'label',
                        cls: 'labelstyle',
                        id: 'startdatelab',
                        text: 'StartDate' + ' :'
                    }, {
                        xtype: 'datefield',
                        cls: 'sandcombostyle',
                        format: getDateFormat(),
                        emptyText: 'SelectStartDate',
                        allowBlank: false,
                        disabled:true,
                        width:'10%',
                        blankText: 'SelectStartDate',
                        id: 'startdate',
                        value: dtprev,
                        maxValue: dtprev,
                        vtype: 'daterange',
                        endDateField: 'enddate'
                    },
                    {
                        xtype: 'label',
                        cls: 'sandlabelstyle',
                        id: 'enddatelab',
                        text: 'EndDate' + ' :'
                    }, {
                        xtype: 'datefield',
                        cls: 'sandcombostyle',
                        format: getDateFormat(),
                        emptyText: 'SelectEndDate',
                        allowBlank: false,
                        disabled:true,
                        width:'10%',
                        blankText: 'SelectEndDate',
                        id: 'enddate',
                        value: dtcur,
                        maxValue: dtcur,
                        vtype: 'daterange',
                        startDateField: 'startdate'
                    },{
                        xtype: 'button',
                        text: 'Submit',
                        id: 'dailyreportid',
                        cls: 'sandreportbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                if(Ext.getCmp('custcomboId').getValue()=='')
                                {
                                setMsgBoxStatus('<%=selectDivision%>');
                                Ext.getCmp('custcomboId').focus();
                                return;
                                }
                                sandPortChart();
                                }
                            }
                        }
                    }]
});
             //********************************************Inner Pannel Starts******************************************* 
            var buttonPanel = new Ext.Panel({
                standardSubmit: true,
                collapsible: false,
                title:'<%=sand_port_wise_permit_count%>',
                border:false,
                frame:false,
                cls: 'sandinnerpanelgridpercentage',
                id: 'buttonpanel',
                height:90,
                layout: 'column',
                layoutConfig: {
                    columns: 5
                },
                items: [{width:'20%',height:10,border:false},{width:'20%',height:10,border:false},{width:'20%',height:10,border:false},{width:'20%',height:10,border:false},{width:'20%',height:10,border:false},
                	{
                        xtype: 'label',
                        text: '<%=division%>' + ' :',
                        cls: 'labelstyle',
                        id: 'custnamelab'
                    },
                    custnamecombo,
                    {
                        xtype: 'button',
                        text: '<%=custom_date%>',
                        id: 'Customreportid',
                        cls: 'sandreportbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                Ext.getCmp('startdate').setDisabled(false);
                                Ext.getCmp('enddate').setDisabled(false);
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '<%=last_week%>',
                        id: 'weeklyreportid',
                        cls: 'sandreportbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                Ext.getCmp('startdate').setDisabled(true);
                                Ext.getCmp('enddate').setDisabled(true);
                                Ext.getCmp('startdate').setValue(getLastWeekMonday());
                                Ext.getCmp('enddate').setValue(getLastSunday());
                                }
                            }
                        }
                    },
                    {
                        xtype: 'button',
                        text: '<%=last_month%>',
                        id: 'monthlyreportid',
                        cls: 'sandreportbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                Ext.getCmp('startdate').setDisabled(true);
                                Ext.getCmp('enddate').setDisabled(true);
                                Ext.getCmp('startdate').setValue(firstDayInPreviousMonth());
                                Ext.getCmp('enddate').setValue(lastDayInPreviousMonth());
                                }
                            }
                        }
                    },{
                        xtype: 'button',
                        text: '<%=last_year%>',
                        id: 'yearlyreportid',
                        cls: 'sandreportbutton',
                        listeners: {
                            click: {
                                fn: function () {
                                Ext.getCmp('startdate').setDisabled(true);
                                Ext.getCmp('enddate').setDisabled(true);
                                Ext.getCmp('startdate').setValue(getLastYearStartDate());
                                Ext.getCmp('enddate').setValue(getCurrentYearStartDate());
                                }
                            }
                        }
                        }            
                ]
            }); // End of Panel	
            
            var mainPanel = new Ext.Panel({
                border:false,
                items: [buttonPanel,datePanel]
            });
            
function firstDayInPreviousMonth() {
var d = new Date();
d.setDate(1);
d.setMonth(d.getMonth() - 1);
return d;
}

function lastDayInPreviousMonth() {
var d=new Date(); 
d.setDate(1); 
d.setHours(-1);
return d;
}

function getLastWeekMonday()
{
var beforeOneWeek = new Date(new Date().getTime() - 60 * 60 * 24 * 7 * 1000);
day = beforeOneWeek.getDay();
diffToMonday = beforeOneWeek.getDate() - day + (day === 0 ? -6 : 1);
lastMonday = new Date(beforeOneWeek.setDate(diffToMonday));
return lastMonday;
}

function getLastSunday()
{
var beforeOneWeek = new Date(new Date().getTime() - 60 * 60 * 24 * 7 * 1000);
day = beforeOneWeek.getDay();
diffToMonday = beforeOneWeek.getDate() - day + (day === 0 ? -6 : 1);
lastSunday = new Date(beforeOneWeek.setDate(diffToMonday + 6));
return lastSunday;
}

function getLastYearStartDate()
{
return new Date(new Date().getFullYear()-1, 0, 1);
}

function getCurrentYearStartDate()
{
return new Date(new Date().getFullYear(), 0, 1);
}
             //***************************************Main starts from here*************************
            Ext.onReady(function () {
                Ext.QuickTips.init();
                Ext.form.Field.prototype.msgTarget = 'side';
                outerPanel = new Ext.Panel({
                    renderTo: 'content',
                    standardSubmit: true,
                    frame: false,
     				height:550,
                    cls: 'outerpanel',
                    id:'outerpanelid',
                    items: [mainPanel,barchartPannel]
                }); 
                sandPortChart();
            });
        </script>
		</div>
     <jsp:include page="../Common/footer.jsp" />
 <!-- </body>   -->
 <!-- </html> -->