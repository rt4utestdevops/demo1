package t4u.util;

public class TemperatureConfigurationBean {

	private String registrationNo;
	private int systemId;
	private int customerId;
	private String minPositiveTemp;
	private String minNegativeTemp;
	private String maxPositiveTemp;
	private String maxNegativeTemp;
	private String sensorName;
	private String name;
	
	public TemperatureConfigurationBean(String registrationNo, int systemId,
			int customerId, String minPositiveTemp, String minNegativeTemp,
			String maxPositiveTemp, String maxNegativeTemp, String sensorName, String name) {
		super();
		this.registrationNo = registrationNo;
		this.systemId = systemId;
		this.customerId = customerId;
		this.minPositiveTemp = minPositiveTemp;
		this.minNegativeTemp = minNegativeTemp;
		this.maxPositiveTemp = maxPositiveTemp;
		this.maxNegativeTemp = maxNegativeTemp;
		this.sensorName = sensorName;
		this.name = name;
	}

	public String getRegistrationNo() {
		return registrationNo;
	}
	
	public int getSystemId() {
		return systemId;
	}
	
	public int getCustomerId() {
		return customerId;
	}
	
	public String getMinPositiveTemp() {
		return minPositiveTemp;
	}
	
	public String getMinNegativeTemp() {
		return minNegativeTemp;
	}
	
	public String getMaxPositiveTemp() {
		return maxPositiveTemp;
	}
	
	public String getMaxNegativeTemp() {
		return maxNegativeTemp;
	}

	public String getSensorName() {
		return sensorName;
	}
	public String getName() {
		return name;
	}

	
}
