package t4u.GeneralVertical;

import java.util.List;

public class LegDetailsBean {
	
	private int slNo;
	private String tripNo;
	private String ShipmentId;
	private String routeName;
	private String vehicleNo;
	private String make;
	private String lrNo;
	private String custRefId;
	private String customerName;
	private String driverName;
	private String driverContact;
	private String Location;
	private String origin;
	private String Destination;
	private String status;
	private String STP;
	private String ATP;
	private String STD;
	private String ATD;
	private String nearestHub;
	private String distanceToNextHub;
	private String ETHA;
	private String ETA;
	private String STA;
	private String ATA;
	private String delay;
	private String avgSpeed;
	private String stoppageTime;
	private String totalDist;
	private String placementDelay;
	private String customerDetentionTime;
	private String loadingDetentionTime;
	private String unloadingDetentionTime;
	private String flag;
	private String weather;
	private String endDateHidden;
	private String routeIdHidden;
	private String panicAlert;
	private String doorAlert;
	private String nonReporting;
	private String fuelConsumed;
	private String mileage;
	private String mileageOBD;
	private String nextLeg;
	private String nextLegETA;
	private String totalStopDuration;
	private String weightedGreenBandSpeed;
	private String weightedGreenBandRPM;
	private String llsMileage;
	private String obdMileageForSLALegReport;
	private String vehicleLength;
	private List <LegInfoBean> legDetails;
	private String tripType;
	private String tripCategory;
	private String departureDelayWrtSTD;
	private String plannedTransitTime;
	private String actualTransitTime;
	private String stawrtatd;
	
	
	public int getSlNo() {
		return slNo;
	}
	public void setSlNo(int slNo) {
		this.slNo = slNo;
	}
	public String getTripNo() {
		return tripNo;
	}
	public void setTripNo(String tripNo) {
		this.tripNo = tripNo;
	}
	public String getShipmentId() {
		return ShipmentId;
	}
	public void setShipmentId(String shipmentId) {
		ShipmentId = shipmentId;
	}
	public String getRouteName() {
		return routeName;
	}
	public void setRouteName(String routeName) {
		this.routeName = routeName;
	}
	public String getVehicleNo() {
		return vehicleNo;
	}
	public void setVehicleNo(String vehicleNo) {
		this.vehicleNo = vehicleNo;
	}
	public String getMake() {
		return make;
	}
	public void setMake(String make) {
		this.make = make;
	}
	public String getLrNo() {
		return lrNo;
	}
	public void setLrNo(String lrNo) {
		this.lrNo = lrNo;
	}
	public String getCustRefId() {
		return custRefId;
	}
	public void setCustRefId(String custRefId) {
		this.custRefId = custRefId;
	}
	public String getCustomerName() {
		return customerName;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	public String getDriverName() {
		return driverName;
	}
	public void setDriverName(String driverName) {
		this.driverName = driverName;
	}
	public String getDriverContact() {
		return driverContact;
	}
	public void setDriverContact(String driverContact) {
		this.driverContact = driverContact;
	}
	public String getLocation() {
		return Location;
	}
	public void setLocation(String location) {
		Location = location;
	}
	public String getOrigin() {
		return origin;
	}
	public void setOrigin(String origin) {
		this.origin = origin;
	}
	public String getDestination() {
		return Destination;
	}
	public void setDestination(String destination) {
		Destination = destination;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getSTP() {
		return STP;
	}
	public void setSTP(String sTP) {
		STP = sTP;
	}
	public String getATP() {
		return ATP;
	}
	public void setATP(String aTP) {
		ATP = aTP;
	}
	public String getSTD() {
		return STD;
	}
	public void setSTD(String sTD) {
		STD = sTD;
	}
	public String getATD() {
		return ATD;
	}
	public void setATD(String aTD) {
		ATD = aTD;
	}
	public String getNearestHub() {
		return nearestHub;
	}
	public void setNearestHub(String nearestHub) {
		this.nearestHub = nearestHub;
	}
	public String getDistanceToNextHub() {
		return distanceToNextHub;
	}
	public void setDistanceToNextHub(String distanceToNextHub) {
		this.distanceToNextHub = distanceToNextHub;
	}
	public String getETHA() {
		return ETHA;
	}
	public void setETHA(String eTHA) {
		ETHA = eTHA;
	}
	public String getETA() {
		return ETA;
	}
	public void setETA(String eTA) {
		ETA = eTA;
	}
	public String getSTA() {
		return STA;
	}
	public void setSTA(String sTA) {
		STA = sTA;
	}
	public String getATA() {
		return ATA;
	}
	public void setATA(String aTA) {
		ATA = aTA;
	}
	public String getDelay() {
		return delay;
	}
	public void setDelay(String delay) {
		this.delay = delay;
	}
	public String getAvgSpeed() {
		return avgSpeed;
	}
	public void setAvgSpeed(String avgSpeed) {
		this.avgSpeed = avgSpeed;
	}
	public String getStoppageTime() {
		return stoppageTime;
	}
	public void setStoppageTime(String stoppageTime) {
		this.stoppageTime = stoppageTime;
	}
	public String getTotalDist() {
		return totalDist;
	}
	public void setTotalDist(String totalDist) {
		this.totalDist = totalDist;
	}
	public String getPlacementDelay() {
		return placementDelay;
	}
	public void setPlacementDelay(String placementDelay) {
		this.placementDelay = placementDelay;
	}
	public String getCustomerDetentionTime() {
		return customerDetentionTime;
	}
	public void setCustomerDetentionTime(String customerDetentionTime) {
		this.customerDetentionTime = customerDetentionTime;
	}
	public String getLoadingDetentionTime() {
		return loadingDetentionTime;
	}
	public void setLoadingDetentionTime(String loadingDetentionTime) {
		this.loadingDetentionTime = loadingDetentionTime;
	}
	public String getUnloadingDetentionTime() {
		return unloadingDetentionTime;
	}
	public void setUnloadingDetentionTime(String unloadingDetentionTime) {
		this.unloadingDetentionTime = unloadingDetentionTime;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getWeather() {
		return weather;
	}
	public void setWeather(String weather) {
		this.weather = weather;
	}
	public String getEndDateHidden() {
		return endDateHidden;
	}
	public void setEndDateHidden(String endDateHidden) {
		this.endDateHidden = endDateHidden;
	}
	public String getRouteIdHidden() {
		return routeIdHidden;
	}
	public void setRouteIdHidden(String routeIdHidden) {
		this.routeIdHidden = routeIdHidden;
	}
	public String getPanicAlert() {
		return panicAlert;
	}
	public void setPanicAlert(String panicAlert) {
		this.panicAlert = panicAlert;
	}
	public String getDoorAlert() {
		return doorAlert;
	}
	public void setDoorAlert(String doorAlert) {
		this.doorAlert = doorAlert;
	}
	public String getNonReporting() {
		return nonReporting;
	}
	public void setNonReporting(String nonReporting) {
		this.nonReporting = nonReporting;
	}
	public String getFuelConsumed() {
		return fuelConsumed;
	}
	public void setFuelConsumed(String fuelConsumed) {
		this.fuelConsumed = fuelConsumed;
	}
	public String getMileage() {
		return mileage;
	}
	public void setMileage(String mileage) {
		this.mileage = mileage;
	}
	public String getMileageOBD() {
		return mileageOBD;
	}
	public void setMileageOBD(String mileageOBD) {
		this.mileageOBD = mileageOBD;
	}
	public String getNextLeg() {
		return nextLeg;
	}
	public void setNextLeg(String nextLeg) {
		this.nextLeg = nextLeg;
	}
	public String getNextLegETA() {
		return nextLegETA;
	}
	public void setNextLegETA(String nextLegETA) {
		this.nextLegETA = nextLegETA;
	}
	public List<LegInfoBean> getLegDetails() {
		return legDetails;
	}
	public void setLegDetails(List<LegInfoBean> legDetails) {
		this.legDetails = legDetails;
	}
	public String getTotalStopDuration() {
		return totalStopDuration;
	}
	public void setTotalStopDuration(String totalStopDuration) {
		this.totalStopDuration = totalStopDuration;
	}
	public String getWeightedGreenBandSpeed() {
		return weightedGreenBandSpeed;
	}
	public void setWeightedGreenBandSpeed(String weightedGreenBandSpeed) {
		this.weightedGreenBandSpeed = weightedGreenBandSpeed;
	}
	public String getWeightedGreenBandRPM() {
		return weightedGreenBandRPM;
	}
	public void setWeightedGreenBandRPM(String weightedGreenBandRPM) {
		this.weightedGreenBandRPM = weightedGreenBandRPM;
	}
	public String getLlsMileage() {
		return llsMileage;
	}
	public void setLlsMileage(String llsMileage) {
		this.llsMileage = llsMileage;
	}
	public String getObdMileageForSLALegReport() {
		return obdMileageForSLALegReport;
	}
	public void setObdMileageForSLALegReport(String obdMileageForSLALegReport) {
		this.obdMileageForSLALegReport = obdMileageForSLALegReport;
	}
	public String getVehicleLength() {
		return vehicleLength;
	}
	public void setVehicleLength(String vehicleLength) {
		this.vehicleLength = vehicleLength;
	}
	public String getTripType() {
		return tripType;
	}
	public void setTripType(String tripType) {
		this.tripType = tripType;
	}
	public String getTripCategory() {
		return tripCategory;
	}
	public void setTripCategory(String tripCategory) {
		this.tripCategory = tripCategory;
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
	
	public String getStawrtatd() {
		return stawrtatd;
	}
	public void setStawrtatd(String stawrtatd) {
		this.stawrtatd = stawrtatd;
	}
	
	
}
