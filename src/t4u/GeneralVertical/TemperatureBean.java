package t4u.GeneralVertical;

import java.util.HashMap;


public class TemperatureBean implements Comparable<TemperatureBean> {
	String T1="";
	public String getT1() {
		return T1;
	}
	public void setT1(String t1) {
		T1 = t1;
	}
	public String getIocat() {
		return iocat;
	}
	public void setIocat(String iocat) {
		this.iocat = iocat;
	}
	public String getT2() {
		return T2;
	}
	public void setT2(String t2) {
		T2 = t2;
	}
	public String getT3() {
		return T3;
	}
	public void setT3(String t3) {
		T3 = t3;
	}
	public String getReefer() {
		return reefer;
	}
	public void setReefer(String reefer) {
		this.reefer = reefer;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getGmt() {
		return gmt;
	}
	public void setGmt(String gmt) {
		this.gmt = gmt;
	}
	String iocat="";
	
	String T2="";
	String T3="";
	HashMap<String,String> sensorNameToValue = new HashMap<String,String>();
	
	public HashMap<String, String> getSensorNameToValue() {
		return sensorNameToValue;
	}
	public void setSensorNameToValue(HashMap<String, String> sensorNameToValue) {
		this.sensorNameToValue = sensorNameToValue;
	}
	String reefer="";
	String location="";
	String gmt="";
	
	public int compareTo(TemperatureBean o) {
		return this.gmt.compareTo(o.getGmt());
	}
}
