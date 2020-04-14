<%@ page  language="java" import="java.util.*,t4u.functions.CommonFunctions,t4u.beans.*,t4u.common.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>

<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	CommonFunctions cf=new CommonFunctions();
	cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
	LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
	String language=loginInfo.getLanguage();
	int customeridlogged=loginInfo.getCustomerId();
	//getting hashmap with language specific words
	HashMap langConverted=ApplicationListener.langConverted;
	String Reload=cf.getLabelFromDB("Reload",language);
	
	
 	String XaxisLable="X-Axis";
	String YaxisLable="Y-Axis";
	String pageName="Page-Name"; 	
	String chartColour="0x4863A0";
	String toolTip="Both";
	
	if(request.getParameter("XaxisLable")!= null)
	{
		XaxisLable = request.getParameter("XaxisLable");
	}
	if(request.getParameter("YaxisLable")!= null)
	{
		YaxisLable = request.getParameter("YaxisLable");
	}
	if(request.getParameter("pageName")!= null)
	{
		pageName = request.getParameter("pageName").toString();
	}
	if(request.getParameter("chartColour")!= null)
	{
		chartColour = request.getParameter("chartColour").toString();
	}
	if(request.getParameter("toolTip")!= null)
	{
		toolTip = request.getParameter("toolTip").toString();
	}
	
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Charts</title>
	<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
	<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
	<pack:style src="../../Main/resources/css/ext-all.css" />
	<pack:style src="../../Main/resources/css/xtheme-gray.css" />
	<pack:style src="../../Main/src/widgets/chart/Chart.js"/>
</head>
<table align="center">
			<tr>
				<td id="container"></td>
			</tr>
</table>
<body>
<script type="text/javascript" >

Ext.chart.Chart.CHART_URL = '../../Main/resources/charts.swf';

var store=parent.chartstore;

Ext.onReady(function(){

    new Ext.Panel({
        iconCls:'chart',
        title: '<%=pageName%>',
        frame:true,
		height:400,
		width:700,        
		renderTo: 'container',
        layout:'fit',
		tbar: [{
            text: '<%=Reload%>',
            handler: function(){
                window.location.reload();
            }
        }],
        items: {
            xtype: 'columnchart',
            store: store,
            animate: true,
            shadow: true,
            url:'../../Main/resources/charts.swf',
            xField: 'Xaxis',
            xAxis: new Ext.chart.CategoryAxis({
                title: '<%=XaxisLable%>'
            }),
            yAxis: new Ext.chart.NumericAxis({
                title: '<%=YaxisLable%>'
            }),
            tipRenderer : function(chart, record, index, series)
            {
            		if('<%=toolTip%>'=="Xaxis")
            		{
            			 return '<%=XaxisLable%>' +':'+ record.data.Xaxis;
            		}
            		else if('<%=toolTip%>'=="Yaxis")
            		{
            			 return '<%=YaxisLable%>' +':'+ Ext.util.Format.number(record.data.Yaxis, '0.00');
            		}
            		else 
            		{
            			 return '<%=XaxisLable%>' +':'+ record.data.Xaxis +'\n'+'<%=YaxisLable%>' +':'+ Ext.util.Format.number(record.data.Yaxis, '0.00');
            		}
            		
            },
            chartStyle: {
                padding: 10,
                animationEnabled: true,
            	hideOverlappingLabels:false,
                font: {
                    name: 'Tahoma',
                    color: 0x444444,
                    size: 11
                },
                dataTip: {
                    padding: 5,
                    border: {
                        color: 0x99bbe8,
                        size:1
                    },
                    background: {
                        color: 0xDAE7F6,
                        alpha: .9
                    },
                    font: {
                        name: 'Tahoma',
                        color: 0x15428B,
                        size: 10,
                        bold: true
                    }
                },
                xAxis: {
                    color: 0x69aBc8,
                    majorTicks: {color: 0x69aBc8, length: 4},
                    minorTicks: {color: 0x69aBc8, length: 2},
                    majorGridLines: {size: 1, color: 0xeeeeee},
                    labelRotation: -45
                },
                yAxis: {
                    color: 0x69aBc8,
                    majorTicks: {color: 0x69aBc8, length: 4},
                    minorTicks: {color: 0x69aBc8, length: 2},
                    majorGridLines: {size: 1, color: 0xdfe8f6}
                    
                   
                }
            },
            series: [{
                type: 'column',
                yField: 'Yaxis',
                style: {
                    mode: 'stretch',
                    color:<%=chartColour%>,
                    size:30
                }
            }
            
            ]
        }
    });
    
});
</script>
</body>
</html>
