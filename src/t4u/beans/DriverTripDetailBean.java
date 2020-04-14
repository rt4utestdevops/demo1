package t4u.beans;

public class DriverTripDetailBean {
	String startDate;
	String endDate;
	int driverId;
	double totalDistance;
	double avarageSpeed;
	double maxSpeed;
	int acclCount;
	double totalAccl;
	int declCount;
	double totalDecl;
	int overspeedCount;
	int overspeedCountgraded;
	double overspeedDistance;
	double stopTime;
	double idleTime;
	int seatBeltCount;
	int acIdleCount;
	double drivingHr;
	double seatBeltOffDistance;
	String StartDriver;
	int overspeedDurationgraded;
	int overspeedDurationBlacktop;
	String driverName;
	double acclCountScore;
	double declCountScore;
	double overspeedCountScore;
	double totalScore;
	
	public double getAcclCountScore() {
		return acclCountScore;
	}
	public void setAcclCountScore(double acclCountScore) {
		this.acclCountScore = acclCountScore;
	}
	public double getDeclCountScore() {
		return declCountScore;
	}
	public void setDeclCountScore(double declCountScore) {
		this.declCountScore = declCountScore;
	}
	public double getOverspeedCountScore() {
		return overspeedCountScore;
	}
	public void setOverspeedCountScore(double overspeedCountScore) {
		this.overspeedCountScore = overspeedCountScore;
	}
	public double getTotalScore() {
		return totalScore;
	}
	public void setTotalScore(double totalScore) {
		this.totalScore = totalScore;
	}
	public String getDriverName() {
		return driverName;
	}
	public void setDriverName(String driverName) {
		this.driverName = driverName;
	}
	public int getOverspeedDurationgraded() {
		return overspeedDurationgraded;
	}
	public void setOverspeedDurationgraded(int overspeedDurationgraded) {
		this.overspeedDurationgraded = overspeedDurationgraded;
	}
	public int getOverspeedDurationBlacktop() {
		return overspeedDurationBlacktop;
	}
	public void setOverspeedDurationBlacktop(int overspeedDurationBlacktop) {
		this.overspeedDurationBlacktop = overspeedDurationBlacktop;
	}
	public int getOverspeedCountGraded() {
		return overspeedCountgraded;
	}
	public void setOverspeedCountGraded(int overspeedCountgraded) {
		this.overspeedCountgraded = overspeedCountgraded;
	}
	public String getStartDriver() {
		return StartDriver;
	}
	public void setStartDriver(String startDriver) {
		StartDriver = startDriver;
	}
	String EndDriver;
	
	public String getEndDriver() {
		return EndDriver;
	}
	public void setEndDriver(String endDriver) {
		EndDriver = endDriver;
	}
	public double getSeatBeltOffDistance() {
		return seatBeltOffDistance;
	}
	public void setSeatBeltOffDistance(double seatBeltOffDistance) {
		this.seatBeltOffDistance = seatBeltOffDistance;
	}
	public int getAcclCount() {
		return acclCount;
	}
	public void setAcclCount(int acclCount) {
		this.acclCount = acclCount;
	}
	public int getAcIdleCount() {
		return acIdleCount;
	}
	public void setAcIdleCount(int acIdleCount) {
		this.acIdleCount = acIdleCount;
	}
	public double getAvarageSpeed() {
		return avarageSpeed;
	}
	public void setAvarageSpeed(double avarageSpeed) {
		this.avarageSpeed = avarageSpeed;
	}
	public int getDeclCount() {
		return declCount;
	}
	public void setDeclCount(int declCount) {
		this.declCount = declCount;
	}
	public int getDriverId() {
		return driverId;
	}
	public void setDriverId(int driverId) {
		this.driverId = driverId;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public double getIdleTime() {
		return idleTime;
	}
	public void setIdleTime(double idleTime) {
		this.idleTime = idleTime;
	}
	public double getMaxSpeed() {
		return maxSpeed;
	}
	public void setMaxSpeed(double maxSpeed) {
		this.maxSpeed = maxSpeed;
	}
	public int getOverspeedCount() {
		return overspeedCount;
	}
	public void setOverspeedCount(int overspeedCount) {
		this.overspeedCount = overspeedCount;
	}
	public double getOverspeedDistance() {
		return overspeedDistance;
	}
	public void setOverspeedDistance(double overspeedDistance) {
		this.overspeedDistance = overspeedDistance;
	}
	public int getSeatBeltCount() {
		return seatBeltCount;
	}
	public void setSeatBeltCount(int seatBeltCount) {
		this.seatBeltCount = seatBeltCount;
	}
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public double getStopTime() {
		return stopTime;
	}
	public void setStopTime(double stopTime) {
		this.stopTime = stopTime;
	}
	public double getTotalAccl() {
		return totalAccl;
	}
	public void setTotalAccl(double totalAccl) {
		this.totalAccl = totalAccl;
	}
	public double getTotalDecl() {
		return totalDecl;
	}
	public void setTotalDecl(double totalDecl) {
		this.totalDecl = totalDecl;
	}
	public double getTotalDistance() {
		return totalDistance;
	}
	public void setTotalDistance(double totalDistance) {
		this.totalDistance = totalDistance;
	}
	public double getDrivingHr() {
		return drivingHr;
	}
	public void setDrivingHr(double drivingHr) {
		this.drivingHr = drivingHr;
	}
}
