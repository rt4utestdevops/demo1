package t4u.beans;

import java.io.Serializable;

public class AssetUtilizationBean implements Serializable
{
	private int holidays=0;
	private int utilizedDaysOnWorking=0;
	private int utilizedOnHolidays=0;
	
	public int getHolidays() 
	{
		return holidays;
	}
	public void setHolidays(int holidays) 
	{
		this.holidays = holidays;
	}
	public int getUtilizedDaysOnWorking() 
	{
		return utilizedDaysOnWorking;
	}
	public void setUtilizedDaysOnWorking(int utilizedDaysOnWorking) 
	{
		this.utilizedDaysOnWorking = utilizedDaysOnWorking;
	}
	public int getUtilizedOnHolidays() 
	{
		return utilizedOnHolidays;
	}
	public void setUtilizedOnHolidays(int utilizedOnHolidays) 
	{
		this.utilizedOnHolidays = utilizedOnHolidays;
	}
	
}
