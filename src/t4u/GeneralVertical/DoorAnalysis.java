package t4u.GeneralVertical;


public class DoorAnalysis implements Comparable<DoorAnalysis> {

	
	
	String INPT1Value;
	String INPT2Value;
	String INPT3Value;
	String INPT4Value;
	String INPT5Value;
	String INPT6Value;
	String INPT7Value;
	String INPT8Value;
	String INPT9Value;
	String INPT10Value;
	String TEMEPERATURE1Value;
	String TEMEPERATURE2Value;
	String BUTTON1Value;
	String RegistrationNo;
	String GMT;
	String location;
	
	public String getLocation() {
		return location;
	}
	public void setLocation(String location) {
		this.location = location;
	}
	public String getINPT1Value() {
		return INPT1Value;
	}
	public void setINPT1Value(String iNPT1Value) {
		INPT1Value = iNPT1Value;
	}
	public String getINPT2Value() {
		return INPT2Value;
	}
	public void setINPT2Value(String iNPT2Value) {
		INPT2Value = iNPT2Value;
	}
	public String getINPT3Value() {
		return INPT3Value;
	}
	public void setINPT3Value(String iNPT3Value) {
		INPT3Value = iNPT3Value;
	}
	public String getINPT4Value() {
		return INPT4Value;
	}
	public void setINPT4Value(String iNPT4Value) {
		INPT4Value = iNPT4Value;
	}
	public String getINPT5Value() {
		return INPT5Value;
	}
	public void setINPT5Value(String iNPT5Value) {
		INPT5Value = iNPT5Value;
	}
	public String getINPT6Value() {
		return INPT6Value;
	}
	public void setINPT6Value(String iNPT6Value) {
		INPT6Value = iNPT6Value;
	}
	public String getINPT7Value() {
		return INPT7Value;
	}
	public void setINPT7Value(String iNPT7Value) {
		INPT7Value = iNPT7Value;
	}
	public String getINPT8Value() {
		return INPT8Value;
	}
	public void setINPT8Value(String iNPT8Value) {
		INPT8Value = iNPT8Value;
	}
	public String getINPT9Value() {
		return INPT9Value;
	}
	public void setINPT9Value(String iNPT9Value) {
		INPT9Value = iNPT9Value;
	}
	public String getINPT10Value() {
		return INPT10Value;
	}
	public void setINPT10Value(String iNPT10Value) {
		INPT10Value = iNPT10Value;
	}
	public String getTEMEPERATURE1Value() {
		return TEMEPERATURE1Value;
	}
	public void setTEMEPERATURE1Value(String tEMEPERATURE1Value) {
		TEMEPERATURE1Value = tEMEPERATURE1Value;
	}
	public String getTEMEPERATURE2Value() {
		return TEMEPERATURE2Value;
	}
	public void setTEMEPERATURE2Value(String tEMEPERATURE2Value) {
		TEMEPERATURE2Value = tEMEPERATURE2Value;
	}
	public String getBUTTON1Value() {
		return BUTTON1Value;
	}
	public void setBUTTON1Value(String bUTTON1Value) {
		BUTTON1Value = bUTTON1Value;
	}
	public String getRegistrationNo() {
		return RegistrationNo;
	}
	public void setRegistrationNo(String registrationNo) {
		RegistrationNo = registrationNo;
	}
	public String getGMT() {
		return GMT;
	}
	public void setGMT(String gMT) {
		GMT = gMT;
	}
	
	public int compareTo(DoorAnalysis o) {
		return this.GMT.compareTo(o.getGMT());
	}
	
	
	
}
