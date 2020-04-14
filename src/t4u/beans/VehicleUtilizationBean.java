package t4u.beans;

public class VehicleUtilizationBean{
	
	private Double travelTime;
	private String registrationNo;
	private String travelTimeFormatted;
	
	public void setRegistrationNo(String registrationNo) {
		this.registrationNo = registrationNo;
	}
	public String getRegistrationNo() {
		return registrationNo;
	}
	public void setTravelTimeFormatted(String travelTimeFormatted) {
		this.travelTimeFormatted = travelTimeFormatted;
	}
	public String getTravelTimeFormatted() {
		return travelTimeFormatted;
	}
	public void setTravelTime(Double travelTime) {
		this.travelTime = travelTime;
	}
	public Double getTravelTime() {
		return travelTime;
	}
	
	

}
