package t4u.GeneralVertical;

public class LegInfoBean {

	private String LegName;
	private String Source;
	private String Destination;
	private String LegSTD;
	private String LegSTA;
	private String LegATA;
	private String LegATD;
	private String TotalDistance;
	private String AvgSpeed;
	private String FuelConsumed;
	private String Mileage;
	private String OBDMileage;
	private String TravelDuration;
	private String Driver1;
	private String Driver2;
	private String LegETA;
	private String Driver1Contact;
	private String Driver2Contact;
	private String totalStoppage;
	private String greenBandSpeedPercentage;
	private String greenBandRPMPercentage;
	private String departureDelayWrtSTD; //ATD-STD
	private String plannedTransitTime; //TAT
	private String actualTransitTime;//ATA-ATD
	
	private String STAwrtATD;
	private String TransitDelay;
	private Double LegDistance;
	
	private long sDepartureDelay;
	private long sPlannedT;
	private long sActualT;
	private long sTransitDelay;
	
	
	public String getLegName() {
		return LegName;
	}
	public void setLegName(String legName) {
		LegName = legName;
	}
	public String getSource() {
		return Source;
	}
	public void setSource(String source) {
		Source = source;
	}
	public String getDestination() {
		return Destination;
	}
	public void setDestination(String destination) {
		Destination = destination;
	}
	public String getLegSTD() {
		return LegSTD;
	}
	public void setLegSTD(String legSTD) {
		LegSTD = legSTD;
	}
	public String getLegSTA() {
		return LegSTA;
	}
	public void setLegSTA(String legSTA) {
		LegSTA = legSTA;
	}
	public String getLegATA() {
		return LegATA;
	}
	public void setLegATA(String legATA) {
		LegATA = legATA;
	}
	public String getLegATD() {
		return LegATD;
	}
	public void setLegATD(String legATD) {
		LegATD = legATD;
	}
	public String getTotalDistance() {
		return TotalDistance;
	}
	public void setTotalDistance(String totalDistance) {
		TotalDistance = totalDistance;
	}
	public String getAvgSpeed() {
		return AvgSpeed;
	}
	public void setAvgSpeed(String avgSpeed) {
		AvgSpeed = avgSpeed;
	}
	public String getFuelConsumed() {
		return FuelConsumed;
	}
	public void setFuelConsumed(String fuelConsumed) {
		FuelConsumed = fuelConsumed;
	}
	public String getMileage() {
		return Mileage;
	}
	public void setMileage(String mileage) {
		Mileage = mileage;
	}
	public String getOBDMileage() {
		return OBDMileage;
	}
	public void setOBDMileage(String oBDMileage) {
		OBDMileage = oBDMileage;
	}
	public String getTravelDuration() {
		return TravelDuration;
	}
	public void setTravelDuration(String travelDuration) {
		TravelDuration = travelDuration;
	}
	public String getDriver1() {
		return Driver1;
	}
	public void setDriver1(String driver1) {
		Driver1 = driver1;
	}
	public String getDriver2() {
		return Driver2;
	}
	public void setDriver2(String driver2) {
		Driver2 = driver2;
	}
	public String getLegETA() {
		return LegETA;
	}
	public void setLegETA(String legETA) {
		LegETA = legETA;
	}
	public String getDriver1Contact() {
		return Driver1Contact;
	}
	public void setDriver1Contact(String driver1Contact) {
		Driver1Contact = driver1Contact;
	}
	public String getDriver2Contact() {
		return Driver2Contact;
	}
	public void setDriver2Contact(String driver2Contact) {
		Driver2Contact = driver2Contact;
	}
	public String getTotalStoppage() {
		return totalStoppage;
	}
	public void setTotalStoppage(String totalStoppage) {
		this.totalStoppage = totalStoppage;
	}
	public String getGreenBandSpeedPercentage() {
		return greenBandSpeedPercentage;
	}
	public void setGreenBandSpeedPercentage(String greenBandSpeedPercentage) {
		this.greenBandSpeedPercentage = greenBandSpeedPercentage;
	}
	public String getGreenBandRPMPercentage() {
		return greenBandRPMPercentage;
	}
	public void setGreenBandRPMPercentage(String greenBandRPMPercentage) {
		this.greenBandRPMPercentage = greenBandRPMPercentage;
	}
	public String getDepartureDelayWrtSTD() {
		return departureDelayWrtSTD;
	}
	public void setDepartureDelayWrtSTD(String departureDelayWrtSTD) {
		this.departureDelayWrtSTD = departureDelayWrtSTD;
	}
	public String getPlannedTransitTime() {
		return plannedTransitTime;
	}
	public void setPlannedTransitTime(String plannedTransitTime) {
		this.plannedTransitTime = plannedTransitTime;
	}
	public String getActualTransitTime() {
		return actualTransitTime;
	}
	public void setActualTransitTime(String actualTransitTime) {
		this.actualTransitTime = actualTransitTime;
	}
	
	public String getSTAwrtATD() {
		return STAwrtATD;
	}
	public void setSTAwrtATD(String sTAwrtATD) {
		STAwrtATD = sTAwrtATD;
	}
	public String getTransitDelay() {
		return TransitDelay;
	}
	public void setTransitDelay(String transitDelay) {
		TransitDelay = transitDelay;
	}
	public Double getLegDistance() {
		return LegDistance;
	}
	public void setLegDistance(Double legDistance) {
		LegDistance = legDistance;
	}
	
	public long getsDepartureDelay() {
		return sDepartureDelay;
	}
	public void setsDepartureDelay(long sDepartureDelay) {
		this.sDepartureDelay = sDepartureDelay;
	}
	public long getsPlannedT() {
		return sPlannedT;
	}
	public void setsPlannedT(long sPlannedT) {
		this.sPlannedT = sPlannedT;
	}
	public long getsActualT() {
		return sActualT;
	}
	public void setsActualT(long sActualT) {
		this.sActualT = sActualT;
	}
	public long getsTransitDelay() {
		return sTransitDelay;
	}
	public void setsTransitDelay(long sTransitDelay) {
		this.sTransitDelay = sTransitDelay;
	}
	
	
}
