package t4u.beans;

import org.apache.struts.action.ActionForm;

@SuppressWarnings("serial")
public class ExportForm1 extends ActionForm
{
	private String reporttype;
	private String filename;
	private String report;
	private String filteredRecords;
	private String hiddencolumns;
	private String exportDesc;
	private String exportDataType;
	private String subtotal;

	public String getExportDataType() {
		return exportDataType;
	}
	public void setExportDataType(String exportDataType) {
		this.exportDataType = exportDataType;
	}
	public String getFilename() 
	{
		return filename;
	}
	public void setFilename(String filename) 
	{
		this.filename = filename;
	}
	public String getFilteredRecords() 
	{
		return filteredRecords;
	}
	public void setFilteredRecords(String filteredRecords) 
	{
		this.filteredRecords = filteredRecords;
	}
	public String getHiddencolumns() 
	{
		return hiddencolumns;
	}
	public void setHiddencolumns(String hiddencolumns) 
	{
		this.hiddencolumns = hiddencolumns;
	}
	public String getReport()
	{
		return report;
	}
	public void setReport(String report) 
	{
		this.report = report;
	}
	public String getReporttype() 
	{
		return reporttype;
	}
	public void setReporttype(String reporttype) 
	{
		this.reporttype = reporttype;
	}
	public String getExportDesc() 
	{
		return exportDesc;
	}
	public void setExportDesc(String exportDesc) 
	{
		this.exportDesc = exportDesc;
	}
	/**
	 * @return the subtotal
	 */
	public String getSubtotal() {
		return subtotal;
	}
	/**
	 * @param subtotal the subtotal to set
	 */
	public void setSubtotal(String subtotal) {
		this.subtotal = subtotal;
	}
	
	
}
