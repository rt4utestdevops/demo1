package t4u.beans;

import java.io.Serializable;
import java.util.ArrayList;

@SuppressWarnings({"serial","unchecked"})
public class ReportHelper implements Serializable
{

	private ArrayList reportsList=new ArrayList(); 
	private ArrayList headersList=new ArrayList();
	private ArrayList informationList=new ArrayList();
	
	private ArrayList reportsList1=new ArrayList(); 
	private ArrayList headersList1=new ArrayList();
	private ArrayList informationList1=new ArrayList();
	
	
	
	
	public ArrayList getReportsList1() {
		return reportsList1;
	}
	public void setReportsList1(ArrayList reportsList1) {
		this.reportsList1 = reportsList1;
	}
	public ArrayList getHeadersList1() {
		return headersList1;
	}
	public void setHeadersList1(ArrayList headersList1) {
		this.headersList1 = headersList1;
	}
	public ArrayList getInformationList1() {
		return informationList1;
	}
	public void setInformationList1(ArrayList informationList1) {
		this.informationList1 = informationList1;
	}
	

	public ArrayList getReportsList() 
	{
		return reportsList;
	}
	public void setReportsList(ArrayList reportsList) 
	{
		this.reportsList = reportsList;
	}
	public ArrayList getHeadersList() 
	{
		return headersList;
	}
	public void setHeadersList(ArrayList headersList) 
	{
		this.headersList = headersList;
	}
	public ArrayList getInformationList() 
	{
		return informationList;
	}
	public void setInformationList(ArrayList informationList) 
	{
		this.informationList = informationList;
	} 
	
}
