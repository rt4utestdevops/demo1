<%@ page language="java" import="java.util.*,t4u.beans.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();


 %>
  
<pack:script src="../../Main/adapter/ext/ext-base.js"></pack:script>
<pack:script src="../../Main/Js/ext-all-debug.js"></pack:script>
<pack:script src="../../Main/Js/T4UStatusBar.js"></pack:script>
<pack:script src="../../Main/Js/Common.js"></pack:script>
<pack:script src="../../Main/Js/cancelbackspace.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/StatusBar.js"></pack:script>
<pack:script src="../../Main/resources/ux/statusbar/ValidationStatus.js"></pack:script>
<pack:script src="../../Main/resources/ux/fileuploadfield/FileUploadField.js"></pack:script>
<!-- for grid -->
<pack:script src="../../Main/resources/ux/gridfilters/menu/RangeMenu.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/menu/ListMenu.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/GridFilters.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/Filter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/StringFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/DateFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/ListFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/NumericFilter.js"></pack:script>
<pack:script src="../../Main/resources/ux/gridfilters/filter/BooleanFilter.js"></pack:script>
<pack:style src="../../Main/resources/css/ext-all.css" />
<pack:style src="../../Main/resources/css/chooser.css" />
<pack:style src="../../Main/resources/css/xtheme-blue.css" />
<pack:style src="../../Main/resources/css/common.css" />
<pack:style src="../../Main/resources/css/dashboard.css" />
<pack:style src="../../Main/resources/css/commonnew.css" />
<pack:style src="../../Main/iconCls/icons.css" />
<pack:style src="../../Main/resources/ux/statusbar/css/statusbar.css" />
<!-- for grid -->
<pack:style src="../../Main/resources/ux/gridfilters/css/GridFilters.css" />
<pack:style src="../../Main/resources/ux/gridfilters/css/RangeMenu.css" />
<pack:script src="../../Main/Js/examples1.js"></pack:script>
<pack:style src="../../Main/resources/css/examples1.css" />
<pack:script src="../../Main/Js/jquery.min.js"></pack:script>
<pack:script src="../../Main/Js/jquery-ui.js"></pack:script>	
<pack:script src="../../Main/Js/MonthPickerPlugin.js"></pack:script>

<style>
.x-form-text,.x-form-textarea,.x-combo-list{
	 direction: ltr;
}.x-panel-header {
    height: 6% !important;
}</style>
<script>
if('<%=language%>'=='ar'){
	document.documentElement.setAttribute("dir", "rtl");
}else if('<%=language%>'=='en'){
	document.documentElement.setAttribute("dir", "ltr");
}
function getwindow(jsp){
window.location=jsp;
 }
</script>
<script>
//(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
//(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
//m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
//})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

//ga('create', 'UA-42892514-4', 'telematics4u.in');
//ga('send', 'pageview');

</script>


  <table id="tableID" style="width:100%;height:99%;background-color:#DFE8F6;margin-top: 0;overflow:hidden" align="center">
  <tr valign="top" height="99%">
  <td height="99%">
  <div id="content"></div>
  </td>
  </tr>
</table>