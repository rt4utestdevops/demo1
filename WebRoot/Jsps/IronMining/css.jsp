<%@ page language="java" import="java.util.*,t4u.beans.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://packtag.sf.net" prefix="pack" %>
<%
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();


 %>
  <pack:style src="../../Main/modules/ironMining/theme/css/miningComponent.css" />

<style>
.x-form-text,.x-form-textarea,.x-combo-list{
	 direction: ltr;
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
