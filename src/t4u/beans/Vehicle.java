package t4u.beans;


import com.vividsolutions.jts.geom.Coordinate;

/**
 * 
 * @author Parameshwar
 * This is a bean for live data
 *
 */
public class Vehicle {

	private String registration_no;
	private String unitid;
	private double latitude;
	private double longitude;
	private double speed;
	private String gpsDateTime;
	private String location;
	private int ignition;
	private double deltaDistance;
	private double odometer;
	private String GMT;
	private int clientId;
	private String offSet;
	private int systemId;
	private String driverName;
	private double fuelPercentage;
	private String category;
	private double duration;
	private Coordinate vehcoord;
	private double temperature;
	private String io3;
	private String io4;
	private String io5;
	private String io6;
	private int driverId;
	
	public int getDriverId() {
		return driverId;
	}
	public void setDriverId(int driverId) {
		this.driverId = driverId;
	}
	public String getIo3() {
		return io3;
	}
	public void setIo3(String io3) {
		this.io3 = io3;
	}
	public String getIo4() {
		return io4;
	}
	public void setIo4(String io4) {
		this.io4 = io4;
	}
	public String getIo5() {
		return io5;
	}
	public void setIo5(String io5) {
		this.io5 = io5;
	}
	public String getIo6() {
		return io6;
	}
	public void setIo6(String io6) {
		this.io6 = io6;
	}
	public String getRegistration_no() {
		return registration_no;
	}
	public void setRegistration_no(String registrationNo) {
		registration_no = registrationNo;
	}
	public String getUnitid() {
		return unitid;
	}
	public void setUnitid(String unitid) {
		this.unitid = unitid;
	}
	public double getLatitude() {
		return latitude;
	}
	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}
	public double getLongitude() {
		return longitude;
	}
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public double getSpeed() {
		return speed;
	}
	public void setSpeed(double speed) {
		this.speed = speed;
	}
	public String getGpsDateTime() {
		return gpsDateTime;
	}
	public void setGpsDateTime(String gpsDateTime) {
		this.gpsDateTime = gpsDateTime;
	}
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public int getIgnition() {
		return ignition;
	}
	public void setIgnition(int ignition) {
		this.ignition = ignition;
	}
	public double getDeltaDistance() {
		return deltaDistance;
	}
	public void setDeltaDistance(double deltaDistance) {
		this.deltaDistance = deltaDistance;
	}
	public double getOdometer() {
		return odometer;
	}
	public void setOdometer(double odometer) {
		this.odometer = odometer;
	}
	public String getGMT() {
		return GMT;
	}
	public void setGMT(String gMT) {
		GMT = gMT;
	}
	public int getClientId() {
		return clientId;
	}
	public void setClientId(int clientId) {
		this.clientId = clientId;
	}
	public String getOffSet() {
		return offSet;
	}
	public void setOffSet(String offSet) {
		this.offSet = offSet;
	}
	public int getSystemId() {
		return systemId;
	}
	public void setSystemId(int systemId) {
		this.systemId = systemId;
	}
	public String getDriverName() {
		return driverName;
	}
	public void setDriverName(String driverName) {
		this.driverName = driverName;
	}
	public double getFuelPercentage() {
		return fuelPercentage;
	}
	public void setFuelPercentage(double fuelPercentage) {
		this.fuelPercentage = fuelPercentage;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public double getDuration() {
		return duration;
	}
	public void setDuration(double duration) {
		this.duration = duration;
	}
	public Coordinate getCoordinate() {
		return vehcoord;
	}
	public void setCoordinate(Coordinate vehcoordinate) {
		vehcoord = vehcoordinate;
	}
	public double getTemperature() {
		return temperature;
	}
	public void setTemperature(double temperature) {
		this.temperature = temperature;
	}
}
