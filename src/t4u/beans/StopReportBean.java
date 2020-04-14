package t4u.beans;

import java.io.Serializable;
import java.util.Date;

public class StopReportBean implements Serializable {
	private static final long serialVersionUID = 1L;
	public String unitNo;
	public String regNo;
	public String startDate;
	public String endDate;
	public String direction;
	public String location;
	public long duration;
	public String gpsDateTime;
	public String drivername;
	public double speed;
	public double  distance;
	public Date date_time;
	public String ignition;
	
	public String getIgnition() {
		return ignition;
	}
	public void setIgnition(String ignition) {
		this.ignition = ignition;
	}
	public Date getTimestamp() {
		return date_time;
	}
	public void getTimestamp(Date date_time) {
		this.date_time = date_time;
	}
	
	public long getDuration() {
		return duration;
	}
	public void setDuration(long duration) {
		this.duration = duration;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getDrivername() {
		return drivername;
	}
	public void setDrivername(String drivername) {
		this.drivername =drivername;
	}
	
	
	public String getRegNo() {
		return regNo;
	}
	public void setRegNo(String regNo) {
		this.regNo = regNo;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getUnitNo() {
		return unitNo;
	}
	public void setUnitNo(String unitNo) {
		this.unitNo = unitNo;
	}
	public String getGpsDateTime() {
		return gpsDateTime;
	}
	public void setGpsDateTime(String gpsDateTime) {
		this.gpsDateTime = gpsDateTime;
	}
	
	public double getSpeed() {
		return speed;
	}
	public void setSpeed(double speed) {
		this.speed = speed;
	}
	public String getDirection() {
		return direction;
	}
	public void setDirection(String direction) {
		this.direction = direction;
	}
	public double getDistance()
	{
		return distance;
	}
	public void setDistance(double distance) {
		this.distance = distance;
	}
	
	
}
