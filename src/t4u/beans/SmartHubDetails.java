package t4u.beans;

public class SmartHubDetails {

	private double latitude;
	private double longitude;
	private int hubId;
	
	public SmartHubDetails(double latitude, double longitude, int hubId) {
		super();
		this.latitude = latitude;
		this.longitude = longitude;
		this.hubId = hubId;
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
	public int getHubId() {
		return hubId;
	}
	public void setHubId(int hubId) {
		this.hubId = hubId;
	}
	
	
}
