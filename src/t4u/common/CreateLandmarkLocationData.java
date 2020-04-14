package t4u.common;

public class CreateLandmarkLocationData {

	public String hubname;
	public String radius;
	public String latitude;
	public String longitude;
	public String offset;
	public String city;
	public String state;
	public String country;
	public String geoFence;
	public String stdDuration;
	public String Remarks;

	public CreateLandmarkLocationData(String hubname, String radius,
			String latitude, String longitude, String offset, String city,
			String state, String country, String geoFence, String stdDuration,
			String remarks) {
		super();
		this.hubname = hubname;
		this.radius = radius;
		this.latitude = latitude;
		this.longitude = longitude;
		this.offset = offset;
		this.city = city;
		this.state = state;
		this.country = country;
		this.geoFence = geoFence;
		this.stdDuration = stdDuration;
		Remarks = remarks;
	}

	@Override
	public String toString() {
		return "CreateLandmarkLocationData [Remarks=" + Remarks + ", city="
				+ city + ", country=" + country + ", geoFence=" + geoFence
				+ ", hubname=" + hubname + ", latitude=" + latitude
				+ ", longitude=" + longitude + ", offset=" + offset
				+ ", radius=" + radius + ", state=" + state + ", stdDuration="
				+ stdDuration + "]";
	}

}
