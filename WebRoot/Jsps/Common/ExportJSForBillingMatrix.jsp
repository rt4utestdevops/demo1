<%@ page language="java" import="java.util.*,t4u.functions.*,t4u.beans.*" pageEncoding="utf-8"%>
<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>   
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
CommonFunctions cf=new CommonFunctions();
cf.checkLoginInfo((LoginInfoBean)session.getAttribute("loginInfoDetails"),session,request,response);
LoginInfoBean loginInfo=(LoginInfoBean)session.getAttribute("loginInfoDetails");
String language=loginInfo.getLanguage();
String NoRecordsFound=cf.getLabelFromDB("No_Records_Found",language);
%>

<html:form action="/exportBilling"> 
   	<html:hidden property = "reporttype" value = ""/>
    <html:hidden property = "filename" value = ""/>
    <html:hidden property = "report" value = ""/>
    <html:hidden property = "filteredRecords" value = ""/>
    <html:hidden property = "hiddencolumns" value = ""/>
    <html:hidden property = "exportDesc" value = ""/>
    <html:hidden property = "exportDataType" value = ""/>
    <html:hidden property = "subtotal" value = ""/>
 </html:form>
 <script >
  
   function getordreport(type,desc,filename,grid,exportDataType)
  {
        var hiddencolumn = "";
	   	var cm =grid.getColumnModel();
  	   	var filteredRecords="";  	   	
  	   		
		for (var i = 0, it = grid.store.data.items, l = it.length; i < l; i++) 
        {
            	for (var j = 0; j < cm.getColumnCount(); j++) 
            	{
	            	if(i==0)
	            	{
	            		if(cm.isHidden(j))
	            		{
	            		   var  k = j -1;
	            		   hiddencolumn = hiddencolumn +k+",";
	            		}
	         		}
          		}
          		
	            r = it[i].data;
	            var v = r[cm.getDataIndex(1)];
	            var strReplaceAll = v;
	            filteredRecords=filteredRecords+strReplaceAll+",";
         }
		 if(filteredRecords=="")
		 {
		   		Ext.MessageBox.show({
							msg:'<%=NoRecordsFound%>',width: 150,buttons: Ext.MessageBox.OK
				});
		 }
		 else
		 {
		  	 
       		  document.ExportForm1.reporttype.value = type;
       		  document.ExportForm1.filename.value =filename;
       		  document.ExportForm1.report.value = filename;
       		  document.ExportForm1.filteredRecords.value = filteredRecords;
       		  document.ExportForm1.hiddencolumns.value = hiddencolumn;
       		  document.ExportForm1.exportDesc.value=desc;
       		  document.ExportForm1.exportDataType.value=exportDataType;
       		  document.ExportForm1.submit();
		 }
  }



</script>
