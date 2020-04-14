package t4u.GeneralVertical.aggrasivetat;

public class PinCodeOriginDestinationModel {
	
	private int id;
	private int pinCode;
	private int originDestinationId;
	private String name;
//	/pinCodeOriginDestination ID, PIN_CODE, ORIGIN_DESTINATION_ID, NAME
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getPinCode() {
		return pinCode;
	}
	public void setPinCode(int pinCode) {
		this.pinCode = pinCode;
	}
	public int getOriginDestinationId() {
		return originDestinationId;
	}
	public void setOriginDestinationId(int originDestinationId) {
		this.originDestinationId = originDestinationId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}

}
